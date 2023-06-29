<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('members', function (Blueprint $table) {
            $table->increments('id')->comment('ID');
            $table->string('name', 100)->nullable()->comment('名稱');
            $table->string('email', 100)->unique()->comment('Email');
            $table->smallInteger('sexual')->comment('sexual');
            $table->timestamps();
            $table->string('nikename')->nullable()->comment('別稱');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('members');
    }
};
