<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Contracts\Routing\ResponseFactory;
use Illuminate\Foundation\Application;
use Illuminate\Http\Response;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class AutomatizationController extends Controller
{
    function automatedFunction(): Application|Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
    {
        $usersMetrics = $this->getUsersCriteria();
        $maxValues = $this->getMaxValuesPerCriteriaArray($usersMetrics);
        $additiveMetrics = $this->getAdditiveMetricsPerUser($usersMetrics, $maxValues);

        $sortedAdditiveMetrics = $additiveMetrics->sortByDesc('additive');
        $maxValue = $sortedAdditiveMetrics->first()->additive;
        $discountMap = $this->setupDiscountMap();
        $usersWithDiscounts = $this->getUsersWithDiscounts($sortedAdditiveMetrics, $maxValue, $discountMap);

        $this->updateUsersWithDiscount($usersWithDiscounts);

        return response(User::all());
    }


    /**
     * @return array
     */
    public function setupDiscountMap(): array
    {
        return [
            90 => 30,
            80 => 25,
            70 => 20,
            60 => 15,
            50 => 10,
            40 => 5,
            0 => 0,
        ];
    }

    /**
     * @return Collection
     */
    public function getUsersCriteria(): Collection
    {
        return DB::table('orders')
            ->select('user_id')
            ->selectRaw('SUM(price) AS total_spent')
            ->selectRaw('AVG(price) AS average_order_value')
            ->selectRaw('MAX(price) AS total_orders_price')
            ->selectRaw('DATEDIFF(NOW(), MAX(created_at)) AS days_since_last')
            ->selectRaw('CASE WHEN COUNT(*) > 1 THEN DATEDIFF(MAX(created_at), MIN(created_at)) / (COUNT(*) - 1) ELSE 0 END AS average_purchase_frequency')
            ->groupBy('user_id')
            ->get();
    }

    /**
     * @param Collection $usersMetrics
     * @return array
     */
    public function getMaxValuesPerCriteriaArray(Collection $usersMetrics): array
    {
        return [
            'total_spent' => $usersMetrics->max('total_spent'),
            'average_order_value' => $usersMetrics->max('average_order_value'),
            'total_orders_price' => $usersMetrics->max('total_orders_price'),
            'days_since_last' => $usersMetrics->max('days_since_last'),
            'average_purchase_frequency' => $usersMetrics->max('average_purchase_frequency'),
        ];
    }

    /**
     * @param Collection $usersMetrics
     * @param array $maxValues
     * @return Collection
     */
    public function getAdditiveMetricsPerUser(Collection $usersMetrics, array $maxValues): Collection
    {
        return $usersMetrics->map(function ($user) use ($maxValues) {
            return (object)[
                'user_id' => $user->user_id,
                'additive' =>
                    ($user->total_spent / $maxValues['total_spent'] * 1)
                    + ($user->average_order_value / $maxValues['average_order_value'] * 0.5)
                    + ($user->total_orders_price / $maxValues['total_orders_price'] * 1)
                    - ($user->days_since_last / $maxValues['days_since_last'] * 0.5)
                    + ($user->average_purchase_frequency / $maxValues['average_purchase_frequency'] * 0.75),
            ];
        });
    }

    /**
     * @param Collection $sortedAdditiveMetrics
     * @param $maxValue
     * @param array $discountMap
     * @return Collection
     */
    public function getUsersWithDiscounts(Collection $sortedAdditiveMetrics, $maxValue, array $discountMap): Collection
    {
        return $sortedAdditiveMetrics->map(function ($user) use ($maxValue, $discountMap) {
            $percentageOfMax = ($user->additive / $maxValue) * 100;
            $userDiscount = 0;

            foreach ($discountMap as $percentThreshold => $discount) {
                if ($percentageOfMax >= $percentThreshold) {
                    $userDiscount = $discount;
                    break;
                }
            }

            return (object)[
                'user_id' => $user->user_id,
                'additive' => $user->additive,
                'discount' => $userDiscount,
            ];
        });
    }

    /**
     * @param Collection $usersWithDiscounts
     * @return void
     */
    public function updateUsersWithDiscount(Collection $usersWithDiscounts): void
    {
        DB::statement("CREATE TEMPORARY TABLE IF NOT EXISTS users_discounts_temp (
                user_id INT PRIMARY KEY,
                discount INT)");

        $values = $usersWithDiscounts->map(function ($user) {
            return '(' . $user->user_id . ', ' . $user->discount . ')';
        })->join(',');

        DB::insert("INSERT INTO users_discounts_temp (user_id, discount) VALUES $values");

        DB::statement("UPDATE users
            JOIN users_discounts_temp
            ON users.id = users_discounts_temp.user_id
            SET users.personal_discount = users_discounts_temp.discount;");

        DB::statement("DROP TEMPORARY TABLE IF EXISTS users_discounts_temp;");
    }
}
