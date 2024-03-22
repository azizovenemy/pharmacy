<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reviews', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained();
            $table->foreignId('drug_id')->constrained();
            $table->text('text')->nullable();
            $table->unsignedTinyInteger('rating');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reviews');
    }
};
