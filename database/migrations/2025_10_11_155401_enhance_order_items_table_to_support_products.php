<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('order_items', function (Blueprint $table) {
            // Add product_id column (nullable foreign key)
            $table->foreignId('product_id')->nullable()->after('package_id')->constrained('products')->onDelete('set null');

            // Add item_type column (package or product)
            $table->enum('item_type', ['package', 'product'])->default('package')->after('product_id');

            // Add product_snapshot column for storing product details at time of purchase
            $table->json('product_snapshot')->nullable()->after('package_snapshot');

            // Add index for product_id and item_type
            $table->index(['product_id', 'item_type']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('order_items', function (Blueprint $table) {
            // Drop foreign key and columns in reverse order
            $table->dropForeign(['product_id']);
            $table->dropIndex(['product_id', 'item_type']);
            $table->dropColumn(['product_id', 'item_type', 'product_snapshot']);
        });
    }
};
