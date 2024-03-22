<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Cart;
use App\Models\Drug;
use Exception;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Contracts\Routing\ResponseFactory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;


class OrderController extends Controller
{
    /**
     * @param Request $request
     * @return Application|ResponseFactory|\Illuminate\Foundation\Application|Response
     */
    public function index(Request $request): \Illuminate\Foundation\Application|Response|Application|ResponseFactory
    {
        $orders = Order::where('user_id', $request->user()->id)->get();

        return response([
            'orders' => $orders,
        ], 200);
    }

    /**
     * @param Request $request
     * @return JsonResponse
     * @throws Exception
     */
    public function store(Request $request): JsonResponse
    {
        $userId = $request->user()->id;
        DB::beginTransaction();
        try {
            $order = new Order();
            $order->user_id = $userId;
            $order->price = 0;
            $order->order_status_id = 1;
            $order->save();
            $price = 0;
            $cartItems = Cart::where('user_id', $userId)->get();
            foreach ($cartItems as $cart) {
                $drug = Drug::find($cart->drug_id);
                if (!$drug) {
                    continue;
                }
                $orderItem = new OrderItem();
                $orderItem->order_id = $order->id;
                $orderItem->drug_id = $cart->drug_id;
                $orderItem->quantity = $cart->quantity;
                $orderItem->save();
                $price += $drug->price * $orderItem->quantity;;
                $cart->delete();
            }
            $order->price = $price;
            $order->save();
            DB::commit();
            return response()->json($order);
        } catch (Exception $e) {
            DB::rollback();
            throw $e;
        }
    }
}
