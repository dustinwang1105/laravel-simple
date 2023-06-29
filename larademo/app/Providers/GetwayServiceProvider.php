<?php

namespace App\Providers;

use App\Service\Alipay;
use App\Service\IPay;
use App\Service\Linepay;
use Illuminate\Console\View\Components\Line;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\ServiceProvider;

class GetwayServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        Log::info("env===>" . env('ENV_LOG'));
        $this->app->bind('ali', function () {
            return new Alipay();
        });
        $this->app->bind('line', function () {
            return new Linepay();
        });
        $this->app->bind(IPay::class, env('Hami_Pd'));
        //$this->app->bind(IPay::class, Linepay::class);
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
    }
}
