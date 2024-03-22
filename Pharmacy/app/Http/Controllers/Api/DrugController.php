<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\DrugRequest;
use App\Models\Drug;
use App\Models\Review;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Contracts\Routing\ResponseFactory;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class DrugController extends Controller
{
    /**
     * @return \Illuminate\Foundation\Application|Response|Application|ResponseFactory
     */
    public function index(): \Illuminate\Foundation\Application|Response|Application|ResponseFactory
    {
        $drugs = Drug::all();
        return response([
            'drugs' => $drugs,
        ], 200);
    }

    /**
     * @param $category_id
     * @return \Illuminate\Foundation\Application|Response|Application|ResponseFactory
     */
    public function index_by_category($category_id): \Illuminate\Foundation\Application|Response|Application|ResponseFactory
    {
        $drugs = Drug::where('drug_category_id', $category_id)->get();

        return response([
            'drugs' => $drugs
        ], 200);
    }

    /**
     * @param $text
     * @return \Illuminate\Foundation\Application|Response|Application|ResponseFactory
     */
    public function index_by_text($text): \Illuminate\Foundation\Application|Response|Application|ResponseFactory
    {
        if($text == "|"){
            return response([
                'drugs' => Drug::all()
            ], 200);
        }

        $query = Drug::query();

        $query->where(function ($q) use ($text) {
            $q->where('title', 'LIKE', '%' . $text . '%');
        });

        $drugs = $query->get();

        return response([
            'drugs' => $drugs
        ], 200);
    }

    /**
     * @param DrugRequest $request
     * @return \Illuminate\Foundation\Application|Response|Application|ResponseFactory
     */
    public function store(DrugRequest $request): \Illuminate\Foundation\Application|Response|Application|ResponseFactory
    {
        $request->validated();

        return response([
            'message' => 'success',
        ], 201);
    }
}
