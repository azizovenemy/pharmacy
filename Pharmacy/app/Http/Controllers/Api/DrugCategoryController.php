<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DrugCategory;
use Illuminate\Http\Response;

class DrugCategoryController extends Controller
{
    /**
     * @return Response
     */
    public function index(): Response
    {
        return response(DrugCategory::all());
    }

    /**
     * @param int $id
     * @return Response
     */
    public function show(int $id): Response
    {
        return response(DrugCategory::find($id));
    }
}
