@extends('layouts.app')

@section('title', 'MLM Genealogy')

@section('content')
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center">
            <h2 class="mb-4">MLM Genealogy</h2>
            {{-- Add stats and search here in a later phase --}}
        </div>

        <div class="card">
            <div class="card-body">
                <p>Genealogy tree will be rendered here.</p>
                {{-- The <x-genealogy-node> component will be used here in the next phase --}}
            </div>
        </div>
    </div>
@endsection
