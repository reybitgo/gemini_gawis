@props([
    'member',
    'earningsLabel' => 'Earnings',
])

<li class="genealogy-node">
    <div class="node-content">
        <div class="node-main">
            <div class="node-avatar">
                {{-- Placeholder for an avatar --}}
                <div class="avatar-initials">{{ strtoupper(substr($member->username, 0, 1)) }}</div>
            </div>
            <div class="node-details">
                <div class="node-name">{{ $member->fullname }} <span class="node-username">({{ $member->username }})</span></div>
                <div class="node-meta">Joined: {{ date('M d, Y', strtotime($member->join_date)) }}</div>
            </div>
        </div>
        <div class="node-stats">
            <div class="node-level">Level {{ $member->level }}</div>
            <div class="node-earnings">{{ $earningsLabel }}: <span class="earnings-amount">{{ currency($member->earnings) }}</span></div>
            <div class="node-status status-{{ $member->status }}">{{ ucfirst($member->status) }}</div>
        </div>
        @if(!empty($member->children))
            <button class="node-toggle" aria-expanded="false">+</button>
        @endif
    </div>

    @if (!empty($member->children))
        <ul class="genealogy-level" style="display: none;">
            @foreach ($member->children as $child)
                <x-genealogy-node :member="$child" :earnings-label="$earningsLabel" />
            @endforeach
        </ul>
    @endif
</li>

@once
<style>
    .genealogy-tree, .genealogy-level {
        list-style: none;
        padding-left: 0;
    }
    .genealogy-level {
        padding-left: 20px; /* Default indentation */
        border-left: 1px solid #ddd;
        margin-left: 10px;
    }
    .genealogy-node {
        margin-bottom: 10px;
    }
    .node-content {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        padding: 10px 15px;
        flex-wrap: wrap; /* Allow wrapping on small screens */
    }
    .node-main {
        display: flex;
        align-items: center;
        flex-grow: 1;
    }
    .node-avatar {
        margin-right: 15px;
    }
    .avatar-initials {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #6c757d;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }
    .node-name {
        font-weight: 600;
    }
    .node-username {
        color: #6c757d;
        font-weight: 400;
    }
    .node-meta {
        font-size: 0.8rem;
        color: #6c757d;
    }
    .node-stats {
        display: flex;
        align-items: center;
        gap: 15px;
        margin-left: 20px;
        flex-shrink: 0; /* Prevent stats from shrinking */
    }
    .node-level, .node-earnings, .node-status {
        font-size: 0.85rem;
    }
    .earnings-amount {
        font-weight: bold;
        color: #28a745;
    }
    .node-status {
        font-weight: 500;
        padding: 2px 8px;
        border-radius: 4px;
        color: white;
    }
    .status-active { background-color: #28a745; }
    .status-inactive { background-color: #6c757d; }
    .status-suspended { background-color: #dc3545; }

    .node-toggle {
        background: #e9ecef;
        border: 1px solid #ddd;
        border-radius: 50%;
        width: 24px;
        height: 24px;
        line-height: 22px;
        text-align: center;
        cursor: pointer;
        margin-left: 15px;
    }

    /* Responsive Styles */
    @media (max-width: 768px) {
        .node-content {
            flex-direction: column;
            align-items: flex-start;
        }
        .node-stats {
            margin-left: 0;
            margin-top: 10px;
            width: 100%;
            justify-content: space-between;
        }
        .genealogy-level {
            padding-left: 10px; /* Reduced indentation for mobile */
            margin-left: 5px;
        }
        .node-toggle {
            position: absolute;
            top: 10px;
            right: 10px;
        }
    }
</style>
@endonce
