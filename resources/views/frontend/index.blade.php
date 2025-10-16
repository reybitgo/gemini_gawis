@extends('layouts.frontend')

@section('content')
    <!-- Hero Section Start -->
    <div class="hero dark-section">
        <div class="hero-overlay"></div>
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <!-- Hero Content Start -->
                    <div class="hero-content">
                        <!-- Section Title Start -->
                        <div class="section-title">
                            <h3 class="wow fadeInUp">Welcome to Gawis iHerbal</h3>
                            <h1 class="text-anime-style-3" data-cursor="-opaque">
                                Your Path to <span>Financial Wellness</span>
                            </h1>
                        </div>
                        <!-- Section Title End -->

                        <!-- Hero List Start -->
                        <div class="hero-list wow fadeInUp" data-wow-delay="0.2s">
                            <ul>
                                <li>
                                    Unlock your earning potential with our Unilevel MLM plan.
                                </li>
                                <li>
                                    High-quality products and a rewarding compensation plan.
                                </li>
                            </ul>
                        </div>
                        <!-- Hero List End -->

                        <!-- Hero Button Start -->
                        <div class="hero-btn wow fadeInUp" data-wow-delay="0.4s">
                            <a href="#" class="btn-default btn-highlighted">Learn More</a>
                            <a href="#" class="btn-default border-btn">Contact Us</a>
                        </div>
                        <!-- Hero Button End -->
                    </div>
                    <!-- Hero Content End -->
                </div>

                <div class="col-lg-6">
                    <!-- Hero Image Start -->
                    <div class="hero-image">
                        <figure>
                            <img src="{{ asset('frontend/images/hero-image.png') }}" alt="" />
                        </figure>
                    </div>
                    <!-- Hero Image End -->
                </div>
            </div>
        </div>
    </div>
    <!-- Hero Section End -->

    <!-- Our Scrolling Ticker Section Start -->
    <div class="our-scrolling-ticker">
        <!-- Scrolling Ticker Start -->
        <div class="scrolling-ticker-box">
            <div class="scrolling-content">
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />5-Level Commission Structure</span>
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />Unilevel Bonus System</span>
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />Real-Time Processing</span>
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />Integrated E-Wallet</span>
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />Premium Quality Products</span>
            </div>

            <div class="scrolling-content">
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />5-Level Commission Structure</span>
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />Unilevel Bonus System</span>
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />Real-Time Processing</span>
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />Integrated E-Wallet</span>
                <span><img src="{{ asset('frontend/images/asterisk-icon.svg') }}" alt="" />Premium Quality Products</span>
            </div>
        </div>
    </div>
    <!-- Our Scrolling Ticker Section End -->

    <!-- About Us Section Start -->
    <div class="about-us">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <!-- About Images Start -->
                    <div class="about-images">
                        <figure>
                            <img src="{{ asset('frontend/images/about-img.png') }}" alt="" />
                        </figure>
                    </div>
                    <!-- About Images End -->
                </div>

                <div class="col-lg-6">
                    <!-- About us Content Start -->
                    <div class="about-us-content">
                        <!-- Section Title Start -->
                        <div class="section-title">
                            <h3 class="wow fadeInUp">about us</h3>
                            <h2 class="text-anime-style-3" data-cursor="-opaque">
                                Committed to your <span>health and success!</span>
                            </h2>
                            <p class="wow fadeInUp" data-wow-delay="0.2s">
                                We provide a unique opportunity for individuals to build their own business through our Unilevel MLM platform, offering high-quality health and wellness products.
                            </p>
                        </div>
                        <!-- Section Title End -->

                        <!-- About Us Body Start -->
                        <div class="about-us-body wow fadeInUp" data-wow-delay="0.4s">
                            <!-- About Us List Start -->
                            <div class="about-us-list">
                                <ul>
                                    <li>Pure & Natural Ingredients</li>
                                    <li>Rewarding Compensation Plan</li>
                                </ul>
                            </div>
                            <!-- About Us List End -->

                            <!-- About Body Item Start -->
                            <div class="about-body-item">
                                <div class="icon-box">
                                    <img src="{{ asset('frontend/images/icon-about-body.svg') }}" alt="" />
                                </div>
                                <div class="about-body-item-title">
                                    <h3>100% Natural & Pure Ingredients</h3>
                                </div>
                            </div>
                            <!-- About Body Item End -->
                        </div>
                        <!-- About Us Body End -->

                        <!-- About Us Footer Start -->
                        <div class="about-us-footer wow fadeInUp" data-wow-delay="0.6s">
                            <!-- About Us Button Start -->
                            <div class="about-us-btn">
                                <a href="#" class="btn-default">more about us</a>
                            </div>
                            <!-- About Us Button End -->

                            <!-- About Contact Box Start -->
                            <div class="about-contact-box">
                                <div class="icon-box">
                                    <img src="{{ asset('frontend/images/icon-phone.svg') }}" alt="" />
                                </div>
                                <div class="about-contact-box-content">
                                    <p>Support Any Time</p>
                                    <h3>
                                        <a href="tel:985852357">+01 - 985 852 357</a>
                                    </h3>
                                </div>
                            </div>
                            <!-- About Contact Box End -->
                        </div>
                        <!-- About Us Footer End -->
                    </div>
                    <!-- About us Content End -->
                </div>
            </div>
        </div>
    </div>
    <!-- About Us Section End -->

    <!-- Our Products Section Start -->
    <div class="our-products">
        <div class="container">
            <div class="row section-row align-items-center">
                <div class="col-lg-6">
                    <!-- Section Title Start -->
                    <div class="section-title">
                        <h3 class="wow fadeInUp">our products</h3>
                        <h2 class="text-anime-style-3" data-cursor="-opaque">
                            Powerful supplements <span>for a healthier you!</span>
                        </h2>
                    </div>
                    <!-- Section Title End -->
                </div>

                <div class="col-lg-6">
                    <!-- Section Button Start -->
                    <div class="section-btn wow fadeInUp" data-wow-delay="0.2s">
                        <a href="#" class="btn-default">view all products</a>
                    </div>
                    <!-- Section Button End -->
                </div>
            </div>

            <div class="row">
                <div class="col-lg-12">
                    <!-- Product Slider Start -->
                    <div class="product-slider">
                        <div class="swiper">
                            <div class="swiper-wrapper">
                                <!-- Product Slide Start -->
                                <div class="swiper-slide">
                                    <div class="product-item">
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
                                </div>
                                <!-- Product Slide End -->

                                <!-- Product Slide Start -->
                                <div class="swiper-slide">
                                    <div class="product-item">
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
                                </div>
                                <!-- Product Slide End -->

                                <!-- Product Slide Start -->
                                <div class="swiper-slide">
                                    <div class="product-item">
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
                                </div>
                                <!-- Product Slide End -->
                            </div>
                            <div class="product-btn">
                                <div class="product-button-prev"></div>
                                <div class="product-button-next"></div>
                            </div>
                        </div>
                    </div>
                    <!-- Testimonial Slider End -->
                </div>
            </div>
        </div>
    </div>
    <!-- Our Product Section End -->
@endsection
