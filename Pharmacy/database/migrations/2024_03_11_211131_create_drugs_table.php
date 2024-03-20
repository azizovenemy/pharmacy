<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('drugs', function (Blueprint $table) {
            $table->id();
            $table->string('name', 50);
            $table->text('description')->nullable();
            $table->foreignId('category_id');
            $table->string('image', 100)->nullable();
            $table->decimal('price', 7, 2)->default(100);
            $table->decimal('rating', 4, 2)->default(1);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('drugs');
    }
};
