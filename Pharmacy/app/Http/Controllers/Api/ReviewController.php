<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Drug;
use App\Models\Review;
use Illuminate\Contracts\Routing\ResponseFactory;
use Illuminate\Foundation\Application;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class ReviewController extends Controller
{
    /**
     * @param $drug_id
     * @return Application|Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
     */
    public function show($drug_id): Application|Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
    {
        $reviews = Review::with('user')->whereDrugId($drug_id)->get();

        $this->recalculateDrugRating($drug_id);

        return response([
            'reviews' => $reviews
        ], 200);
    }

    /**
     * @param Request $request
     * @param $drug_id
     * @return Application|Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
     */
    public function store(Request $request, $drug_id): Application|Response|\Illuminate\Contracts\Foundation\Application|ResponseFactory
    {
        $request->validate([
            'drug_id' => 'required|exists:drugs,id',
            'rating' => 'required|numeric',
        ]);

        Review::create([
            'user_id' => $request->user()->id,
            'drug_id' => $drug_id,
            'text' =>$request->text,
            'rating' =>$request->rating,
        ]);

        $this->recalculateDrugRating($drug_id);

        return response([
            'message' => 'success'
        ], 201);
    }

    /**
     * Пересчитать и обновить рейтинг лекарства.
     *
     * @param int $drugId
     */
    protected function recalculateDrugRating($drugId): void
    {
        $drug = Drug::findOrFail($drugId);
        $newRating = $drug->reviews()->avg('rating');

        $drug->rating = $newRating;
        $drug->save();
    }
}
