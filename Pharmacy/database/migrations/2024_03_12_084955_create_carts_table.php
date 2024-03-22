<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('carts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained();
            $table->foreignId('drug_id')->constrained();
            $table->unsignedTinyInteger('quantity')->default(1);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('carts');
    }
};
