<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('system_settings', function (Blueprint $table) {
            //
        });

        // Add the monthly_maintenance_points setting
        DB::table('system_settings')->insert([
            'key' => 'monthly_maintenance_points',
            'value' => '100',
            'type' => 'integer',
            'description' => 'Minimum monthly personal purchase points to be eligible for unilevel bonus.',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('system_settings', function (Blueprint $table) {
            //
        });

        // Remove the monthly_maintenance_points setting
        DB::table('system_settings')->where('key', 'monthly_maintenance_points')->delete();
    }
};
