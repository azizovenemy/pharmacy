<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Models\User;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Contracts\Routing\ResponseFactory;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Hash;

class AuthenticationController extends Controller
{
    /**
     * @param RegisterRequest $request
     * @return \Illuminate\Foundation\Application|Response|Application|ResponseFactory
     */
    public function register(RegisterRequest $request): \Illuminate\Foundation\Application|Response|Application|ResponseFactory
    {
        $request->validated();

        $userData = [
            'first_name' => $request->first_name,
            'last_name' => $request->last_name,
            'login' => $request->login,
            'password' => Hash::make($request->password),
        ];

        $user = User::create($userData);
        $token = $user->createToken('pharmacyApp')->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    /**
     * @param LoginRequest $request
     * @return \Illuminate\Foundation\Application|Response|Application|ResponseFactory
     */
    public function login(LoginRequest $request): \Illuminate\Foundation\Application|Response|Application|ResponseFactory
    {
        $request->validated();

        $user = User::where('login', $request->login)->first();
        if(!$user || !Hash::check($request->password, $user->password)){
            return response([
                'message' => 'Invalid password'
            ], 422);
        }

        $token = $user->createToken('pharmacyApp')->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token,
        ], 200);
    }
}
