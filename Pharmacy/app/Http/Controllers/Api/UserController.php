<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Symfony\Component\HttpFoundation\Response;

class UserController extends Controller
{
    public function index(Request $request)
    {
        return $request->user();
    }

    public function store(Request $request)
    {
        $user = User::query()->create([
            'first_name' => $request->input('first_name'),
            'last_name' => $request->input('last_name'),
            'login' => $request->input('login'),
            'password' => Hash::make($request->input('password'))
        ]);

        return response($user, Response::HTTP_ACCEPTED);
    }

    public function show(int $id)
    {
        return response(User::find($id));
    }

    public function update(Request $request, int $id)
    {
        $drug = User::find($id);
        $drug->update($request->only('first_name', 'last_name', 'login', 'password'));

        return response($drug, Response::HTTP_ACCEPTED);
    }

    public function destroy(int $id)
    {
        $drug = User::find($id);
        $drug->order()->destroy();
        User::destroy($id);

        return response(null, Response::HTTP_NO_CONTENT);
    }
}
