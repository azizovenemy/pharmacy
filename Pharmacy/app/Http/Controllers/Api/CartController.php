<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Cart;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CartController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $cart = Cart::where('user_id', $request->user()->id)->get();

        return response()->json($cart);
    }

    public function show(int $id)
    {
        $cart = Cart::where('user_id', $id)->get();

        return response([
            'cart' => $cart,
        ], 200);
    }

    public function store(Request $request, int $drug_id)
    {
        $user_id = $request->user()->id;

        $cart = Cart::query()->create([
            'user_id' => $user_id,
            'drug_id' => $drug_id
        ]);

        return response($cart, Response::HTTP_ACCEPTED);
    }

    public function update(Request $request, int $id)
    {
        $cart = Cart::findOrFail($id);

        $changeAmount = (int)$request->input('amount', 0);

        if ($changeAmount !== 0) {
            $newAmount = $cart->quantity + $changeAmount;

            $cart->quantity = $newAmount;
            $cart->save();

            return response()->json(['message' => 'successful']);
        }

        return response()->json(['message' => 'Cant change value']);
    }

    public function delete(int $id)
    {
        Cart::destroy($id);

        return response(null, 200);
    }
}
