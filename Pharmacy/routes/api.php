<?php

use App\Http\Controllers\Api\AutomatizationController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\DrugCategoryController;
use App\Http\Controllers\Api\DrugController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Auth\AuthenticationController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::get('automate', [AutomatizationController::class, 'automatedFunction']);

Route::post('register', [AuthenticationController::class, 'register']);
Route::post('login', [AuthenticationController::class, 'login']);

Route::get('user', [UserController::class, 'index'])->middleware('auth:sanctum');

Route::get('drug/index', [DrugController::class, 'index']);
Route::post('drug_by_category/{category_id}', [DrugController::class, 'index_by_category']);
Route::post('drug_by_text/{text}', [DrugController::class, 'index_by_text']);
Route::post('drug/store', [DrugController::class, 'store']);

Route::get('drug-categories', [DrugCategoryController::class, 'index']);
Route::get('drug-categories/{id}', [DrugCategoryController::class, 'show']);

Route::get('reviews/{drug_id}', [DrugController::class, 'review_index']);
Route::post('reviews/{drug_id}', [DrugController::class, 'review_store']);

Route::get('cart', [CartController::class, 'index'])->middleware('auth:sanctum');
Route::post('cart/{drug_id}', [CartController::class, 'store'])->middleware('auth:sanctum');
Route::put('cart/{cart_id}', [CartController::class, 'update'])->middleware('auth:sanctum');
Route::delete('cart/{cart_id}', [CartController::class, 'delete'])->middleware('auth:sanctum');

Route::get('orders', [OrderController::class, 'index'])->middleware('auth:sanctum');
Route::post('orders', [OrderController::class, 'store'])->middleware('auth:sanctum');
