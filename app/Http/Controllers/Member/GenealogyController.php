<?php

namespace App\Http\Controllers\Member;

use App\Http\Controllers\Controller;
use App\Services\GenealogyService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class GenealogyController extends Controller
{
    protected $genealogyService;

    public function __construct(GenealogyService $genealogyService)
    {
        $this->genealogyService = $genealogyService;
    }

    public function showUnilevel()
    {
        // Logic to be implemented in a later step
    }

    public function showMlm()
    {
        // Logic to be implemented in a later step
    }
}
