<?php

namespace App\Service;

class Linepay extends AbsPay
{
    public function __construct()
    {
    }

    public function pay($v24)
    {
        echo 'pay bill by Linepay';
    }
}
