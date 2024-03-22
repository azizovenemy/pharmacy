<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Cart;
use Illuminate\Contracts\Routing\ResponseFactory;
use Illuminate\Foundation\Application;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CartController extends Controller
{
    /**
     * @param Request $request
     * @return JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        $cart = Cart::where('user_id', $request->user()->id)->get();

        return response()->json($cart);
    }

    /**
     * @param int $id
     * @return Application|\Illuminate\Http\Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
     */
    public function show(int $id): Application|\Illuminate\Http\Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
    {
        $cart = Cart::where('user_id', $id)->get();

        return response([
            'cart' => $cart,
        ], 200);
    }

    /**
     * @param Request $request
     * @param int $drug_id
     * @return Application|\Illuminate\Http\Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
     */
    public function store(Request $request, int $drug_id): Application|\Illuminate\Http\Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
    {
        $user_id = $request->user()->id;

        $cart = Cart::query()->create([
            'user_id' => $user_id,
            'drug_id' => $drug_id
        ]);

        return response($cart, Response::HTTP_ACCEPTED);
    }

    /**
     * @param Request $request
     * @param int $id
     * @return JsonResponse
     */
    public function update(Request $request, int $id): JsonResponse
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

    /**
     * @param int $id
     * @return Application|\Illuminate\Http\Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
     */
    public function delete(int $id): Application|\Illuminate\Http\Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
    {
        Cart::destroy($id);

        return response(null, 200);
    }
}
