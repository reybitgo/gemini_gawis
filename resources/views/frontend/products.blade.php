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
            <div class="row">
                <div class="col-lg-4 col-md-6">
                    <!-- Product Item Start -->
                    <div class="product-item wow fadeInUp">
                        <div class="product-image">
                            <figure class="image-anime">
                                <img src="{{ asset('frontend/images/product-image-1.jpg') }}" alt="" />
                            </figure>
                        </div>
                        <div class="product-title">
                            <h3>Starter Package</h3>
                        </div>
                        <div class="product-item-body">
                            <div class="product-rating">
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                            </div>
                            <div class="product-price">
                                <p>₱1,500.00</p>
                            </div>
                        </div>
                    </div>
                    <!-- Product Item End -->
                </div>

                <div class="col-lg-4 col-md-6">
                    <!-- Product Item Start -->
                    <div class="product-item wow fadeInUp" data-wow-delay="0.2s">
                        <div class="product-image">
                            <figure class="image-anime">
                                <img src="{{ asset('frontend/images/product-image-2.jpg') }}" alt="" />
                            </figure>
                        </div>
                        <div class="product-title">
                            <h3>Consumable Product A</h3>
                        </div>
                        <div class="product-item-body">
                            <div class="product-rating">
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                            </div>
                            <div class="product-price">
                                <p>₱500.00</p>
                            </div>
                        </div>
                    </div>
                    <!-- Product Item End -->
                </div>

                <div class="col-lg-4 col-md-6">
                    <!-- Product Item Start -->
                    <div class="product-item wow fadeInUp" data-wow-delay="0.4s">
                        <div class="product-image">
                            <figure class="image-anime">
                                <img src="{{ asset('frontend/images/product-image-3.jpg') }}" alt="" />
                            </figure>
                        </div>
                        <div class="product-title">
                            <h3>Consumable Product B</h3>
                        </div>
                        <div class="product-item-body">
                            <div class="product-rating">
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                            </div>
                            <div class="product-price">
                                <p>₱750.00</p>
                            </div>
                        </div>
                    </div>
                    <!-- Product Item End -->
                </div>

                <div class="col-lg-4 col-md-6">
                    <!-- Product Item Start -->
                    <div class="product-item wow fadeInUp">
                        <div class="product-image">
                            <figure class="image-anime">
                                <img src="{{ asset('frontend/images/product-image-4.jpg') }}" alt="" />
                            </figure>
                        </div>
                        <div class="product-title">
                            <h3>Consumable Product C</h3>
                        </div>
                        <div class="product-item-body">
                            <div class="product-rating">
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                            </div>
                            <div class="product-price">
                                <p>₱600.00</p>
                            </div>
                        </div>
                    </div>
                    <!-- Product Item End -->
                </div>
            </div>
        </div>
    </div>
    <!-- Our Products Section End -->
@endsection
