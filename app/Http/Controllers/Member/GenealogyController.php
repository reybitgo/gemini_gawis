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
        $user = Auth::user();
        $tree = $this->genealogyService->getGenealogyTree($user, 'unilevel_bonus');

        return view('member.genealogy.unilevel', ['tree' => $tree]);
    }

    public function showMlm()
    {
        $user = Auth::user();
        $tree = $this->genealogyService->getGenealogyTree($user, 'mlm_commission');

        return view('member.genealogy.mlm', ['tree' => $tree]);
    }
}
