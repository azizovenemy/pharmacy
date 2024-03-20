<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\DrugCategory;
use Illuminate\Http\Response;

class DrugCategoryController extends Controller
{
    public function index(): Response
    {
        return response(DrugCategory::all());
    }

    public function show(int $id): Response
    {
        return response(DrugCategory::find($id));
    }
}
