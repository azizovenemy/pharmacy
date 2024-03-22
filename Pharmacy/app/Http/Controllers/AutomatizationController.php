<?php

namespace App\Http\Controllers;

use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class AutomatizationController extends Controller
{
    /**
     * @return void
     */
    function automatedFunction()
    {
        $usersMetrics = $this->getUsersCriteria();
        $maxValues = $this->getMaxValuesPerCriteriaArray($usersMetrics);
        $additiveMetrics = $this->getAdditiveMetricsPerUser($usersMetrics, $maxValues);


        $sortedAdditiveMetrics = $additiveMetrics->sortByDesc('additive');
        $maxValue = $sortedAdditiveMetrics->first()->additive;
        $discountMap = $this->setupDiscountMap();

        $usersWithDiscounts = $this->getUsersWithDiscounts($sortedAdditiveMetrics, $maxValue, $discountMap);

        $this->updateUsersWithDiscount($usersWithDiscounts);
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
     * Получение коллекции с вычисленными критериями для каждого пользователя
     * @return Collection
     */
    public function getUsersCriteria(): Collection
    {
        // Использование фасада DB для работы с таблицей заказазов
        return DB::table('orders AS o')
            // Формирование выборки с расчетом данных для критериев
            ->selectRaw("
            o.user_id,
            SUM(o.price) AS total_spent,
            AVG(o.price) AS average_order_value,
            MAX(o.price) AS highest_order_price,
            DATEDIFF(NOW(), MAX(o.created_at)) AS days_since_last,
            AVG(DATEDIFF(o.created_at, pi.previous_purchase_date)) AS average_purchase_frequency
        ")
            // Присоединение подзапроса для получения даты предыдущей покупки
            ->join(DB::raw("
            (SELECT
                user_id,
                created_at,
                LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS previous_purchase_date
            FROM orders) AS pi
        "), function ($join) {
                // Соединение основной и вспомогательной таблицы по user_id
                $join->on('o.user_id', '=', 'pi.user_id');
            })
            // Исключение записей, где нет предыдущей даты покупки
            ->whereNotNull('pi.previous_purchase_date')
            // Группировка результатов по ID пользователя
            ->groupBy('o.user_id')
            // Получение результата запроса
            ->get();
    }

    /**
     * Получение максимальных значений по каждому критерию
     * @param Collection $usersMetrics
     * @return array
     */
    public function getMaxValuesPerCriteriaArray(Collection $usersMetrics): array
    {
        return [
            'total_spent' => $usersMetrics->max('total_spent'),
            'average_order_value' => $usersMetrics->max('average_order_value'),
            'highest_order_price' => $usersMetrics->max('highest_order_price'),
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
                    + ($user->highest_order_price / $maxValues['highest_order_price'] * 1)
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
        // Преобразование сортированной коллекции $sortedAdditiveMetrics, где каждый элемент представляет собой пользователя
        return $sortedAdditiveMetrics->map(function ($user) use ($maxValue, $discountMap) {
            // Вычисление процента от максимального значения метрики для текущего пользователя
            $percentageOfMax = ($user->additive / $maxValue) * 100;

            // Инициализация переменной для скидки пользователя
            $userDiscount = 0;

            // Перебор карты скидок для определения скидки пользователя
            // $discountMap содержит пороги процентов для скидок
            foreach ($discountMap as $percentThreshold => $discount) {
                // Если процент от максимума для пользователя превышает или равен текущему порогу,
                // назначается соответствующая скидка и прерывается цикл
                if ($percentageOfMax >= $percentThreshold) {
                    $userDiscount = $discount;
                    break;
                }
            }

            // Возвращение объекта с информацией о пользователе,
            // включая его ID, значение метрики и рассчитанную скидку
            return (object)[
                'user_id' => $user->user_id, // ID пользователя
                'additive' => $user->additive, // Значение метрики пользователя
                'discount' => $userDiscount, // Рассчитанная скидка для пользователя
            ];
        });
    }

    /**
     * Обновление персональной скидки каждому пользователю
     * @param Collection $usersWithDiscounts
     * @return void
     */
    public function updateUsersWithDiscount(Collection $usersWithDiscounts): void
    {
        // Создание временной таблицы
        DB::statement("CREATE TEMPORARY TABLE IF NOT EXISTS users_discounts_temp (
                user_id INT PRIMARY KEY,
                discount INT)");

        // Подготовка данных
        $values = $usersWithDiscounts->map(function ($user) {
            return '(' . $user->user_id . ', ' . $user->discount . ')';
        })->join(',');

        // Вставка данных во временную таблицу
        DB::insert("INSERT INTO users_discounts_temp (user_id, discount) VALUES $values");

        // Обновление таблицы пользователей значениями из временной таблицы
        DB::statement("UPDATE users
            JOIN users_discounts_temp
            ON users.id = users_discounts_temp.user_id
            SET users.personal_discount = users_discounts_temp.discount;");

        // Удаление временной таблицы
        DB::statement("DROP TEMPORARY TABLE IF EXISTS users_discounts_temp;");
    }
}
