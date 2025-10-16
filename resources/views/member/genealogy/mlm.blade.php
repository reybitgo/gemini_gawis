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
                @if (!empty($tree))
                    <ul class="genealogy-tree">
                        @foreach ($tree as $member)
                            <x-genealogy-node :member="$member" :earnings-label="'MLM Commission'" />
                        @endforeach
                    </ul>
                @else
                    <p class="text-center text-muted">You do not have any downlines yet.</p>
                @endif
            </div>
        </div>
    </div>
@endsection
