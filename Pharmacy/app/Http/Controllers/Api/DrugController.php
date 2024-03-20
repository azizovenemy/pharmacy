<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\DrugRequest;
use App\Models\Drug;
use App\Models\Review;
use Illuminate\Http\Request;

class DrugController extends Controller
{
    public function index(){
        $drugs = Drug::all();
        return response([
            'drugs' => $drugs,
        ], 200);
    }

    public function index_by_category($category_id){
        $drugs = Drug::where('category_id', $category_id)->get();

        return response([
            'drugs' => $drugs
        ], 200);
    }

    public function index_by_text($text){
        $query = Drug::query();

            $query->where(function ($q) use ($text) {
                $q->where('title', 'LIKE', '%' . $text . '%')
                    ->orWhere('description', 'LIKE', '%' . $text . '%');
            });
        $drugs = $query->get();

        return response([
            'drugs' => $drugs
        ], 200);
    }

    public function store(DrugRequest $request){
        $request->validated();

        return response([
            'message' => 'success',
        ], 201);
    }

    public function review_index($drug_id)
    {
        $reviews = Review::with('drug')->with('user')->whereDrugId($drug_id)->get();

        return response([
            'reviews' => $reviews
        ], 200);
    }

    public function review_store(Request $request, $drug_id)
    {
        $request->validate([
            'rating' => 'required'
        ]);

        $review = Review::create([
            'user_id' => auth()->id(),
            'drug_id' => $drug_id,
            'text' =>$request->text,
            'rating' =>$request->rating,
        ]);

        return response([
            'message' => 'success'
        ], 201);
    }
}
