<?php

namespace App\Http\Controllers;

use App\Models\Members;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class TestController extends Controller
{

    public $ppay;

    function __construct(\App\Service\IPay $ppay)
    {
        $this->ppay = $ppay;
    }

    /**
     * URL will be converted to "/test/foo-bar"
     */
    public function fooBar(Request $request)
    {
        $message = "測試資訊" . env("ENV_LOG");

        Log::emergency($message);
        Log::alert($message);
        Log::critical($message);
        Log::error($message);
        Log::warning($message);
        Log::notice($message);
        Log::info($message);
        Log::debug($message);

        dispatch(new \App\Jobs\ServerReport());

        $pay = app()->make('line');
        $pay->pay("Abc");
        echo "<br/>";
        $this->ppay->pay("aaaaaaaa");
        echo "<br/>";
        $mems = Members::all();
        //print_r();
        foreach ($mems as $mem) {
            echo "foo_bar url: $mem->email";
        }
    }

    public function postMetUrl(Request $request)
    {
        echo "foo_bar url";
    }

    /**
     * URL: "/test/foo-bar1/{name}/{surname?}"
     */
    public function fooBar1(Request $request, $name, $surname = null)
    {
        echo "foo_bar Name=$name, Surname=$surname";
    }
}
