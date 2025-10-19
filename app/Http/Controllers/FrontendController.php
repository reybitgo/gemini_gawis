<?php

namespace App\Http\Controllers;

use App\Models\Package;
use Illuminate\Http\Request;

class FrontendController extends Controller
{
    public function index()
    {
        $packages = Package::with('mlmSettings')->active()->available()->ordered()->get();
        return view('frontend.index', compact('packages'));
    }
}