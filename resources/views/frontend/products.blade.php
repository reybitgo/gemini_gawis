@extends('layouts.frontend')

@section('content')
    <!-- Page Header Start -->
    <div class="page-header">
        <div class="hero-overlay"></div>
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <!-- Page Header Box Start -->
                    <div class="page-header-box">
                        <h1 class="text-anime-style-3" data-cursor="-opaque">
                            Our <span>Products</span>
                        </h1>
                        <nav class="wow fadeInUp">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="{{ url('/') }}">home</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">
                                    products
                                </li>
                            </ol>
                        </nav>
                    </div>
                    <!-- Page Header Box End -->
                </div>
            </div>
        </div>
    </div>
    <!-- Page Header End -->

    <!-- Our Products Section Start -->
    <div class="our-products">
        <div class="container">
            <!-- Filters and Search -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <form method="GET" action="{{ route('frontend.our-products') }}" class="d-flex gap-2">
                        <input type="text" name="search" class="form-control" placeholder="Search products..."
                               value="{{ request('search') }}">
                        @if(request()->except('search'))
                            @foreach(request()->except('search') as $key => $value)
                                <input type="hidden" name="{{ $key }}" value="{{ $value }}">
                            @endforeach
                        @endif
                        <button type="submit" class="btn btn-primary">Search</button>
                    </form>
                </div>
                <div class="col-md-4">
                    <select class="form-select" onchange="location = this.value;">
                        <option value="{{ route('frontend.our-products', request()->except('category')) }}"
                                {{ !request('category') ? 'selected' : '' }}>All Categories</option>
                        @foreach($categories as $cat)
                            <option value="{{ route('frontend.our-products', ['category' => $cat] + request()->except('category')) }}"
                                    {{ request('category') == $cat ? 'selected' : '' }}>{{ $cat }}</option>
                        @endforeach
                    </select>
                </div>
                <div class="col-md-4">
                    <select class="form-select" onchange="location = this.value;">
                        <option value="{{ route('frontend.our-products', request()->except('sort')) }}"
                                {{ !request('sort') ? 'selected' : '' }}>Sort by Default</option>
                        <option value="{{ route('frontend.our-products', ['sort' => 'price_asc'] + request()->except('sort')) }}"
                                {{ request('sort') == 'price_asc' ? 'selected' : '' }}>Price: Low to High</option>
                        <option value="{{ route('frontend.our-products', ['sort' => 'price_desc'] + request()->except('sort')) }}"
                                {{ request('sort') == 'price_desc' ? 'selected' : '' }}>Price: High to Low</option>
                        <option value="{{ route('frontend.our-products', ['sort' => 'name'] + request()->except('sort')) }}"
                                {{ request('sort') == 'name' ? 'selected' : '' }}>Name A-Z</option>
                        <option value="{{ route('frontend.our-products', ['sort' => 'newest'] + request()->except('sort')) }}"
                                {{ request('sort') == 'newest' ? 'selected' : '' }}>Newest First</option>
                    </select>
                </div>
            </div>

            @if($products->count() > 0)
                <div class="row">
                    @foreach($products as $product)
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="product-item wow fadeInUp h-100 d-flex flex-column">
                                <div class="product-image" style="height: 150px; overflow: hidden;">
                                    <figure class="image-anime h-100">
                                        <img src="{{ $product->image_url }}" alt="{{ $product->name }}" style="width: 100%; height: 100%; object-fit: cover; object-position: center;" />
                                    </figure>
                                </div>
                                <div class="product-title mb-0">
                                    <h3>{{ $product->name }}</h3>
                                </div>
                                <div class="product-item-body d-flex flex-column flex-grow-1">
                                    <ul class="pricing-features mb-2">
                                        <li><i class="fas fa-check-circle"></i> Price: {{ currency($product->price) }}</li>
                                        <li><i class="fas fa-check-circle"></i> Points: {{ number_format($product->points_awarded) }}</li>
                                        @if($product->total_unilevel_bonus > 0)
                                        <li><i class="fas fa-check-circle"></i> Bonus: {{ currency($product->total_unilevel_bonus) }}</li>
                                        @endif
                                    </ul>
                                    @if(!$product->unilevelSettings->isEmpty())
                                    <div class="mt-auto">
                                        <a href="#" class="btn btn-outline-gawis w-100 view-details-btn" 
                                            data-product-name="{{ $product->name }}" 
                                            data-unilevel-settings='{{ json_encode($product->unilevelSettings) }}'>View Details</a>
                                    </div>
                                    @endif
                                </div>
                            </div>
                        </div>
                    @endforeach
                </div>

                <div class="row mt-4">
                    <div class="col-12">
                        <div class="d-flex justify-content-center">
                            {{ $products->appends(request()->query())->links() }}
                        </div>
                    </div>
                </div>
            @else
                <div class="row">
                    <div class="col-12">
                        <div class="text-center py-5">
                            <h5 class="text-muted">No products found</h5>
                            <p class="text-muted">
                                @if(request('search'))
                                    No products match your search "{{ request('search') }}".
                                    <a href="{{ route('frontend.our-products') }}">View all products</a>
                                @else
                                    There are no products available at the moment.
                                @endif
                            </p>
                        </div>
                    </div>
                </div>
            @endif
        </div>
    </div>
    <!-- Our Products Section End -->

    <!-- Product Details Modal -->
    <div class="modal fade" id="productDetailsModal" tabindex="-1" aria-labelledby="productDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productDetailsModalLabel"><i class="fas fa-info-circle me-2"></i>Product Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-lg-7">
                                <h3 id="modalProductName"></h3>
                                <hr>
                                <h4><i class="fas fa-sitemap me-2"></i>Unilevel Bonus Settings</h4>
                                <p class="text-muted">This table shows the unilevel bonus you can earn from this product.</p>
                                <table class="table table-striped table-bordered">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Level</th>
                                            <th>Bonus</th>
                                        </tr>
                                    </thead>
                                    <tbody id="modalUnilevelSettings">
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-lg-5">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h4><i class="fas fa-shopping-cart me-2"></i>How to Purchase</h4>
                                        <hr>
                                        <div class="alert alert-success">
                                            <i class="fas fa-gift me-2"></i>
                                            <strong>Your dashboard and system access are completely free!</strong>
                                            <p class="mt-2">Simply fund your e-wallet to purchase products and start your journey to financial wellness.</p>
                                        </div>
                                        <ol class="list-group list-group-numbered">
                                            <li class="list-group-item"><strong>Register for a Free Account:</strong> <a href="{{ route('register') }}">Click here to register</a>.</li>
                                            <li class="list-group-item"><strong>Fund Your E-Wallet:</strong> Once registered, log in to your dashboard and add funds to your secure e-wallet.</li>
                                            <li class="list-group-item"><strong>Purchase Products:</strong> With a funded e-wallet, you can purchase your desired products directly from your dashboard.</li>
                                        </ol>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <a href="{{ route('register') }}" class="btn btn-primary"><i class="fas fa-user-plus me-2"></i>Register Now</a>
                </div>
            </div>
        </div>
    </div>

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function() {
    var productDetailsModal = new bootstrap.Modal(document.getElementById('productDetailsModal'));

    document.querySelectorAll('.view-details-btn').forEach(function(button) {
        button.addEventListener('click', function(event) {
            event.preventDefault();

            var productName = this.dataset.productName;
            var unilevelSettings = JSON.parse(this.dataset.unilevelSettings);

            document.getElementById('modalProductName').textContent = productName;

            var unilevelSettingsTbody = document.getElementById('modalUnilevelSettings');
            unilevelSettingsTbody.innerHTML = '';

            if (unilevelSettings && unilevelSettings.length > 0) {
                unilevelSettings.forEach(function(setting) {
                    var row = `<tr>
                        <td>Level ${setting.level}</td>
                        <td>${currency(setting.bonus_amount)}</td>
                    </tr>`;
                    unilevelSettingsTbody.innerHTML += row;
                });
            } else {
                var row = `<tr>
                    <td colspan="2" class="text-center">No unilevel settings configured for this product.</td>
                </tr>`;
                unilevelSettingsTbody.innerHTML = row;
            }

            productDetailsModal.show();
        });
    });

    function currency(amount) {
        return '₱' + parseFloat(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    }
});
</script>
@endpush