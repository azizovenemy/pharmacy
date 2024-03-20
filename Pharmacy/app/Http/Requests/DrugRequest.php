<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class DrugRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:50',
            'description' => 'nullable|string|max:255',
            'category_id' => 'required|integer|min:1|max:99',
            'image' => 'nullable|string|max:100',
            'price' => 'required|numeric|min:100|max:9999.99',
            'rating' => 'required|numeric|min:1|max:5',
        ];
    }
}
