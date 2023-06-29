<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class CPay extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:c-pay {user}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    public $ppay;

    public function __construct(\App\Service\IPay $ppay)
    {
        parent::__construct();
        $this->ppay = $ppay;
    }

    /**
     * Execute the console command.
     */
    public function handle()
    {
        echo "afdasfas\n";
        $pay = app()->make('ali');
        $pay->pay("Abc");
        echo "\nDI=============================\n";
        $this->ppay->pay("Abc");
        echo "\n\n";
        echo $this->argument('user');
        echo "\n dispatch===>";
        dispatch(new \App\Jobs\ServerReport());
        echo "\n";
    }
}
