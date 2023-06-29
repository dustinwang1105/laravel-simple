<?php

namespace App\Service;

class Alipay extends AbsPay
{
    public function __construct()
    {
    }

    public function pay($v24)
    {
        $piacc = parent::getPiAcc($v24);
        echo 'pay bill by alipay';
    }
}
