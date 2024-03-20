<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderItem extends Model
{
    use HasFactory;

    protected $primaryKey = 'id';

    protected $fillable = [
        'order_id',
        'drug_id',
        'quantity',
        'price'
    ];
}
