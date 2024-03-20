<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('first_name', 20);
            $table->string('last_name', 20);
            $table->string('login', 50)->unique();
            $table->string('password');
            $table->unsignedTinyInteger('personal_discount')->default(5);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
