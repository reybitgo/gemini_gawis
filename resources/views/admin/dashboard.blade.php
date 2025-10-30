@extends('layouts.admin')

@section('title', 'Admin Dashboard')
@section('page-title', 'Admin Dashboard')

@section('content')
<!-- Welcome Header -->
<div class="card mb-4">
    <div class="card-body">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h4 class="card-title mb-0">
                    <svg class="icon me-2">
                        <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-chart-pie') }}"></use>
                    </svg>
                    Admin Dashboard
                </h4>
                <p class="text-body-secondary mb-0">System administration and management overview</p>
            </div>
            <div>
                <span class="badge bg-primary-gradient">Administrator Panel</span>
            </div>
        </div>
    </div>
</div>

<!-- System Statistics -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3">
        <div class="card text-white bg-primary-gradient">
            <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                <div>
                    <div class="fs-4 fw-semibold">{{ $userCount }}</div>
                    <div>Total Users</div>
                </div>
                <svg class="icon icon-3xl">
                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-people') }}"></use>
                </svg>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-xl-3">
        <div class="card text-white bg-danger-gradient">
            <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                <div>
                    <div class="fs-4 fw-semibold">{{ $adminCount }}</div>
                    <div>Administrators</div>
                </div>
                <svg class="icon icon-3xl">
                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-shield-alt') }}"></use>
                </svg>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-xl-3">
        <div class="card text-white bg-success-gradient">
            <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                <div>
                    <div class="fs-4 fw-semibold">{{ $memberCount }}</div>
                    <div>Members</div>
                </div>
                <svg class="icon icon-3xl">
                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-user') }}"></use>
                </svg>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-xl-3">
        <div class="card text-white bg-warning-gradient">
            <div class="card-body pb-0 d-flex justify-content-between align-items-start">
                <div>
                    <div class="fs-4 fw-semibold">{{ $pendingTransactions }}</div>
                    <div>Pending Tasks</div>
                </div>
                <svg class="icon icon-3xl">
                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-clock') }}"></use>
                </svg>
            </div>
        </div>
    </div>
</div>

<!-- Financial Overview -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3">
        <div class="card">
            <div class="card-body">
                <div class="d-flex align-items-start">
                    <div class="avatar bg-success-gradient me-3">
                        <svg class="icon text-white">
                            <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-dollar') }}"></use>
                        </svg>
                    </div>
                    <div>
                        <div class="fs-6 fw-semibold text-success">{{ currency($totalBalance) }}</div>
                        <div class="text-body-secondary">Total Balance</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-xl-3">
        <div class="card">
            <div class="card-body">
                <div class="d-flex align-items-start">
                    <div class="avatar bg-warning-gradient me-3">
                        <svg class="icon text-white">
                            <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-clock') }}"></use>
                        </svg>
                    </div>
                    <div>
                        <div class="fs-6 fw-semibold text-warning">{{ $pendingTransactions }}</div>
                        <div class="text-body-secondary">Pending Reviews</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-xl-3">
        <div class="card">
            <div class="card-body">
                <div class="d-flex align-items-start">
                    <div class="avatar bg-info-gradient me-3">
                        <svg class="icon text-white">
                            <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-chart-line') }}"></use>
                        </svg>
                    </div>
                    <div>
                        <div class="fs-6 fw-semibold text-info">{{ $todayTransactions }}</div>
                        <div class="text-body-secondary">Today's Transactions</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-xl-3">
        <div class="card">
            <div class="card-body">
                <div class="d-flex align-items-start">
                    <div class="avatar bg-purple-gradient me-3">
                        <svg class="icon text-white">
                            <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-graph') }}"></use>
                        </svg>
                    </div>
                    <div>
                        <div class="fs-6 fw-semibold text-purple">{{ currency($monthlyVolume) }}</div>
                        <div class="text-body-secondary">Monthly Volume</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Quick Actions -->
<div class="card mb-4">
    <div class="card-header">
        <svg class="icon me-2">
            <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-task') }}"></use>
        </svg>
        <strong>Admin Quick Actions</strong>
        <small class="text-body-secondary ms-auto">Common administrative tasks</small>
    </div>
    <div class="card-body">
        <div class="row g-3">
            <div class="col-lg-2 col-md-4 col-sm-6">
                <div class="card text-center h-100 border-0 shadow-sm quick-action-card">
                    <div class="card-body d-flex flex-column">
                        <div class="mb-3">
                            <div class="avatar avatar-lg bg-primary-gradient mx-auto">
                                <svg class="icon text-white">
                                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-people') }}"></use>
                                </svg>
                            </div>
                        </div>
                        <h6 class="card-title mb-2">User Management</h6>
                        <p class="card-text text-body-secondary small mb-3 flex-grow-1">Manage user accounts, roles and permissions</p>
                        <a href="{{ route('admin.users') }}" class="btn btn-primary btn-sm stretched-link">
                            Access
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
                <div class="card text-center h-100 border-0 shadow-sm quick-action-card">
                    <div class="card-body d-flex flex-column">
                        <div class="mb-3">
                            <div class="avatar avatar-lg bg-success-gradient mx-auto">
                                <svg class="icon text-white">
                                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-wallet') }}"></use>
                                </svg>
                            </div>
                        </div>
                        <h6 class="card-title mb-2">Wallet Management</h6>
                        <p class="card-text text-body-secondary small mb-3 flex-grow-1">Monitor wallets, balances and transaction history</p>
                        <a href="{{ route('admin.wallet.management') }}" class="btn btn-success btn-sm stretched-link">
                            Access
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
                <div class="card text-center h-100 border-0 shadow-sm quick-action-card">
                    <div class="card-body d-flex flex-column">
                        <div class="mb-3">
                            <div class="avatar avatar-lg bg-warning-gradient mx-auto">
                                <svg class="icon text-white">
                                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-task') }}"></use>
                                </svg>
                            </div>
                        </div>
                        <h6 class="card-title mb-2">Transaction Approval</h6>
                        <p class="card-text text-body-secondary small mb-3 flex-grow-1">Review and approve pending transactions</p>
                        <a href="{{ route('admin.transaction.approval') }}" class="btn btn-warning btn-sm stretched-link">
                            <span class="badge bg-light text-warning me-1">{{ $pendingTransactions }}</span>
                            Access
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
                <div class="card text-center h-100 border-0 shadow-sm quick-action-card">
                    <div class="card-body d-flex flex-column">
                        <div class="mb-3">
                            <div class="avatar avatar-lg bg-info-gradient mx-auto">
                                <svg class="icon text-white">
                                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-settings') }}"></use>
                                </svg>
                            </div>
                        </div>
                        <h6 class="card-title mb-2">System Settings</h6>
                        <p class="card-text text-body-secondary small mb-3 flex-grow-1">Configure system parameters and preferences</p>
                        <a href="{{ route('admin.system.settings') }}" class="btn btn-info btn-sm stretched-link">
                            Access
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
                <div class="card text-center h-100 border-0 shadow-sm quick-action-card">
                    <div class="card-body d-flex flex-column">
                        <div class="mb-3">
                            <div class="avatar avatar-lg bg-danger-gradient mx-auto">
                                <svg class="icon text-white">
                                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-list') }}"></use>
                                </svg>
                            </div>
                        </div>
                        <h6 class="card-title mb-2">System Logs</h6>
                        <p class="card-text text-body-secondary small mb-3 flex-grow-1">View system activity and security events</p>
                        <a href="{{ route('admin.logs') }}" class="btn btn-danger btn-sm stretched-link">
                            Access
                        </a>
                    </div>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 col-sm-6">
                <div class="card text-center h-100 border-0 shadow-sm quick-action-card">
                    <div class="card-body d-flex flex-column">
                        <div class="mb-3">
                            <div class="avatar avatar-lg bg-secondary-gradient mx-auto">
                                <svg class="icon text-white">
                                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-chart-pie') }}"></use>
                                </svg>
                            </div>
                        </div>
                        <h6 class="card-title mb-2">Reports</h6>
                        <p class="card-text text-body-secondary small mb-3 flex-grow-1">Generate and export system reports</p>
                        <a href="{{ route('admin.reports') }}" class="btn btn-secondary btn-sm stretched-link">
                            Access
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Recent System Activity -->
<div class="card mb-4 border-0 shadow-sm">
    <div class="card-header bg-white border-0">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h5 class="card-title mb-0 d-flex align-items-center">
                    <div class="avatar avatar-sm bg-info-gradient me-3">
                        <svg class="icon text-white icon-sm">
                            <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-chart-line') }}"></use>
                        </svg>
                    </div>
                    Recent System Activity
                </h5>
                <small class="text-body-secondary">Latest transactions and system events across the platform</small>
            </div>
            <a href="{{ route('admin.transaction.approval') }}" class="btn btn-outline-primary btn-sm">
                <svg class="icon me-1">
                    <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-external-link') }}"></use>
                </svg>
                View All
            </a>
        </div>
    </div>
    <div class="card-body p-0">
        @forelse($recentTransactions as $transaction)
            @php
                // Map transaction type and status to appropriate colors and icons
                $typeColors = [
                    'deposit' => 'success',
                    'withdrawal' => 'warning',
                    'transfer' => 'info',
                    'payment' => 'primary',
                    'refund' => 'secondary',
                    'fee' => 'danger'
                ];

                $statusColors = [
                    'pending' => 'warning',
                    'approved' => 'success',
                    'completed' => 'success',
                    'rejected' => 'danger',
                    'cancelled' => 'secondary'
                ];

                $typeIcons = [
                    'deposit' => 'cil-arrow-circle-bottom',
                    'withdrawal' => 'cil-arrow-circle-top',
                    'transfer' => 'cil-swap-horizontal',
                    'payment' => 'cil-credit-card',
                    'refund' => 'cil-reload',
                    'fee' => 'cil-dollar'
                ];

                $color = $statusColors[$transaction->status] ?? 'secondary';
                $icon = $typeIcons[$transaction->type] ?? 'cil-money';
                $typeColor = $typeColors[$transaction->type] ?? 'secondary';
            @endphp
            <div class="transaction-item d-flex justify-content-between align-items-center p-3 border-bottom">
                <div class="d-flex align-items-center">
                    <div class="avatar avatar-md me-3 bg-{{ $typeColor }}-gradient">
                        <svg class="icon text-white">
                            <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#' . $icon) }}"></use>
                        </svg>
                    </div>
                    <div>
                        <div class="fw-semibold text-dark">{{ ucfirst($transaction->type) }} Transaction</div>
                        <div class="small text-body-secondary d-flex align-items-center">
                            <svg class="icon icon-xs me-1">
                                <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-clock') }}"></use>
                            </svg>
                            {{ $transaction->created_at->diffForHumans() }}
                            <span class="mx-1">•</span>
                            {{ $transaction->user->email ?? 'System' }}
                        </div>
                        <div class="small text-muted">
                            @if($transaction->description)
                                {{ Str::limit($transaction->description, 50) }}
                            @else
                                {{ ucfirst($transaction->type) }} by {{ $transaction->user->fullname ?? $transaction->user->username ?? 'User' }}
                            @endif
                        </div>
                    </div>
                </div>
                <div class="text-end">
                    <div class="fw-bold h6 mb-1 text-{{ $typeColor }}">
                        ${{ number_format($transaction->amount, 2) }}
                    </div>
                    <span class="badge rounded-pill bg-{{ $color }}
                        @if($color === 'warning') text-dark @else text-white @endif">
                        {{ ucfirst($transaction->status) }}
                    </span>
                </div>
            </div>
        @empty
            <div class="empty-state text-center p-5">
                <div class="avatar avatar-xl bg-light mx-auto mb-3">
                    <svg class="icon icon-xl text-body-secondary">
                        <use xlink:href="{{ asset('coreui-template/vendors/@coreui/icons/svg/free.svg#cil-chart-line') }}"></use>
                    </svg>
                </div>
                <h5 class="text-body-secondary mb-2">No recent activity</h5>
                <p class="text-body-secondary mb-0">System activity will appear here as it occurs.</p>
            </div>
        @endforelse
    </div>
</div>

<style>
.quick-action-card {
    transition: all 0.3s ease;
    border-radius: 12px !important;
}

.quick-action-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15) !important;
}

.quick-action-card .avatar {
    width: 60px;
    height: 60px;
    border-radius: 15px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.quick-action-card .card-body {
    padding: 1.5rem 1rem;
}

.quick-action-card .card-title {
    font-weight: 600;
    color: #2c3e50;
}

.quick-action-card .btn {
    border-radius: 8px;
    font-weight: 500;
    padding: 0.5rem 1rem;
}

/* Icon sizing */
.icon-xl {
    width: 1.5rem;
    height: 1.5rem;
}

.icon-sm {
    width: 0.875rem;
    height: 0.875rem;
}

/* Avatar sizing */
.avatar-sm {
    width: 32px;
    height: 32px;
    border-radius: 8px;
}

.avatar-md {
    width: 40px;
    height: 40px;
    border-radius: 10px;
}

.avatar-xl {
    width: 64px;
    height: 64px;
    border-radius: 16px;
}

/* Transaction item improvements */
.transaction-item {
    transition: all 0.2s ease;
    border-bottom: 1px solid rgba(0, 0, 0, 0.05) !important;
}

.transaction-item:hover {
    background-color: rgba(0, 123, 255, 0.02);
}

.transaction-item:last-child {
    border-bottom: none !important;
}

/* Badge improvements */
.badge.rounded-pill {
    font-size: 10px;
    font-weight: 500;
    padding: 4px 8px;
}

/* Empty state */
.empty-state .avatar-xl {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}

/* Card header improvements */
.card-header.bg-white {
    padding: 1.25rem 1.5rem;
}
</style>

<!-- Bottom spacing for better visual layout -->
<div class="pb-5"></div>

@endsection