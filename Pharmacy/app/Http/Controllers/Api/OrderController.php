<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class OrderController extends Controller
{
    public function index(Request $request){
        $orders = Order::where('user_id', $request->user()->id)->get();

        return response([
            'orders' => $orders,
        ], 200);
    }
}
