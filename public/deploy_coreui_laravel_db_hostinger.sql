-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 15, 2025 at 04:28 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gemini_gawis_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE PROCEDURE `check_circular_sponsor_reference` (IN `p_user_id` INT, IN `p_sponsor_id` INT)   BEGIN
                DECLARE v_current_id INT;
                DECLARE v_depth INT DEFAULT 0;
                DECLARE v_max_depth INT DEFAULT 100;

                -- Prevent self-sponsorship
                IF p_user_id = p_sponsor_id THEN
                    SIGNAL SQLSTATE "45000"
                        SET MESSAGE_TEXT = "A user cannot sponsor themselves.";
                END IF;

                -- Check for circular reference by walking up the sponsor chain
                SET v_current_id = p_sponsor_id;

                WHILE v_current_id IS NOT NULL AND v_depth < v_max_depth DO
                    -- If we encounter the user being updated, it's circular
                    IF v_current_id = p_user_id THEN
                        SIGNAL SQLSTATE "45000"
                            SET MESSAGE_TEXT = "Circular sponsor reference detected. The selected sponsor is already in your downline network.";
                    END IF;

                    -- Get the next sponsor in the chain
                    SELECT sponsor_id INTO v_current_id
                    FROM users
                    WHERE id = v_current_id;

                    SET v_depth = v_depth + 1;
                END WHILE;

                -- If we hit max depth, assume circular reference exists
                IF v_depth >= v_max_depth THEN
                    SIGNAL SQLSTATE "45000"
                        SET MESSAGE_TEXT = "Maximum sponsor chain depth exceeded. Possible circular reference.";
                END IF;
            END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `level` enum('DEBUG','INFO','WARNING','ERROR','CRITICAL') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'INFO',
  `type` enum('security','transaction','mlm_commission','unilevel_bonus','mlm','wallet','system','order') COLLATE utf8mb4_unicode_ci NOT NULL,
  `event` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `transaction_id` bigint UNSIGNED DEFAULT NULL,
  `order_id` bigint UNSIGNED DEFAULT NULL,
  `related_user_id` bigint UNSIGNED DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('gemini-gawis-cache-5c785c036466adea360111aa28563bfd556b5fba', 'i:2;', 1760502443),
('gemini-gawis-cache-5c785c036466adea360111aa28563bfd556b5fba:timer', 'i:1760502443;', 1760502443);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory_logs`
--

CREATE TABLE `inventory_logs` (
  `id` bigint UNSIGNED NOT NULL,
  `package_id` bigint UNSIGNED NOT NULL,
  `action` enum('restock','sale','reservation','release','adjustment','return') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity_before` int UNSIGNED NOT NULL,
  `quantity_after` int UNSIGNED NOT NULL,
  `quantity_change` int NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Order number, reservation ID, etc.',
  `notes` text COLLATE utf8mb4_unicode_ci,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_09_18_121326_add_two_factor_columns_to_users_table', 1),
(5, '2025_09_18_124039_create_permission_tables', 1),
(6, '2025_09_18_142151_create_transactions_table', 1),
(7, '2025_09_18_142219_create_wallets_table', 1),
(8, '2025_09_18_173537_modify_users_table_add_username_rename_name', 1),
(9, '2025_09_18_174533_create_system_settings_table', 1),
(10, '2025_09_18_230930_update_transaction_types_enum', 1),
(11, '2025_09_18_235847_add_withdrawal_fee_to_transaction_types', 1),
(12, '2025_09_21_111847_update_transactions_table_enum_types', 1),
(13, '2025_09_27_015249_create_packages_table', 1),
(14, '2025_09_27_022220_add_soft_deletes_to_packages_table', 1),
(15, '2025_09_27_055840_create_sessions_table', 1),
(16, '2025_09_28_072147_create_orders_table', 1),
(17, '2025_09_28_072241_create_order_items_table', 1),
(18, '2025_09_28_121451_add_payment_and_refund_to_transaction_types', 1),
(19, '2025_09_28_121648_add_completed_status_to_transactions', 1),
(20, '2025_09_29_112626_enhance_orders_table_for_delivery_system', 1),
(21, '2025_09_29_112720_create_order_status_histories_table', 1),
(22, '2025_09_29_124056_add_delivery_address_to_users_table', 1),
(23, '2025_09_29_124751_add_delivery_address_json_to_orders_table', 1),
(24, '2025_09_30_102311_add_performance_indexes_to_tables', 1),
(25, '2025_09_30_162159_create_package_reservations_table', 1),
(26, '2025_09_30_162306_create_inventory_logs_table', 1),
(27, '2025_10_02_002843_create_return_requests_table', 1),
(28, '2025_10_02_002932_add_delivered_at_to_orders_table', 1),
(29, '2025_10_02_033648_add_return_statuses_to_orders_status_enum', 1),
(30, '2025_10_04_135126_create_mlm_settings_table', 1),
(31, '2025_10_04_135144_add_mlm_fields_to_users_table', 1),
(32, '2025_10_04_135156_add_mlm_fields_to_packages_table', 1),
(33, '2025_10_04_135212_add_segregated_balances_to_wallets_table', 1),
(34, '2025_10_04_174327_make_email_nullable_in_users_table', 1),
(35, '2025_10_06_172105_add_circular_reference_prevention_trigger_to_users_table', 1),
(36, '2025_10_06_173759_add_mlm_commission_type_to_transactions_table', 1),
(37, '2025_10_06_213614_create_referral_clicks_table', 1),
(38, '2025_10_07_105237_add_mlm_fields_to_transactions_table', 1),
(39, '2025_10_08_060430_add_suspended_at_to_users_table', 1),
(40, '2025_10_09_090034_migrate_old_balance_to_purchase_balance', 1),
(41, '2025_10_09_090518_drop_old_balance_columns_from_wallets_table', 1),
(42, '2025_10_09_150152_create_notifications_table', 1),
(43, '2025_10_09_174352_create_activity_logs_table', 1),
(44, '2025_10_10_103130_add_balance_conversion_type_to_transactions_table', 1),
(45, '2025_10_10_144506_add_payment_preferences_to_users_table', 1),
(46, '2025_10_10_215547_add_withdrawable_balance_to_wallets_table', 1),
(47, '2025_10_11_110153_add_unilevel_balance_to_wallets_table', 1),
(48, '2025_10_11_111137_create_products_table', 1),
(49, '2025_10_11_112234_create_unilevel_settings_table', 1),
(50, '2025_10_11_113932_add_unilevel_bonus_to_transactions_type_enum', 1),
(51, '2025_10_12_133000_fix_order_items_table_for_products', 1),
(52, '2025_10_12_194157_add_network_status_to_users_table', 1),
(53, '2025_10_14_083836_add_unilevel_bonus_to_activity_logs_type_enum', 1),
(54, '2025_10_14_093921_add_mlm_to_activity_logs_type_enum', 1);

-- --------------------------------------------------------

--
-- Table structure for table `mlm_settings`
--

CREATE TABLE `mlm_settings` (
  `id` bigint UNSIGNED NOT NULL,
  `package_id` bigint UNSIGNED NOT NULL,
  `level` tinyint UNSIGNED NOT NULL,
  `commission_amount` decimal(10,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `mlm_settings`
--

INSERT INTO `mlm_settings` (`id`, `package_id`, `level`, `commission_amount`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 200.00, 1, '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(2, 1, 2, 50.00, 1, '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(3, 1, 3, 50.00, 1, '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(4, 1, 4, 50.00, 1, '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(5, 1, 5, 50.00, 1, '2025-10-15 04:19:58', '2025-10-15 04:19:58');

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1),
(2, 'App\\Models\\User', 2);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` bigint UNSIGNED NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `order_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','paid','payment_failed','processing','confirmed','packing','ready_for_pickup','pickup_notified','received_in_office','ready_to_ship','shipped','out_for_delivery','delivered','delivery_failed','return_requested','return_approved','return_rejected','return_in_transit','return_received','completed','on_hold','cancelled','refunded','returned','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `payment_status` enum('pending','paid','failed','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `delivered_at` timestamp NULL DEFAULT NULL,
  `delivery_method` enum('office_pickup','home_delivery') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'office_pickup',
  `delivery_address` json DEFAULT NULL,
  `tracking_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `courier_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pickup_date` timestamp NULL DEFAULT NULL,
  `pickup_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pickup_instructions` text COLLATE utf8mb4_unicode_ci,
  `estimated_delivery` timestamp NULL DEFAULT NULL,
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `status_message` text COLLATE utf8mb4_unicode_ci,
  `subtotal` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL,
  `tax_rate` decimal(5,4) NOT NULL DEFAULT '0.0000',
  `points_awarded` int NOT NULL DEFAULT '0',
  `points_credited` tinyint(1) NOT NULL DEFAULT '0',
  `metadata` json DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `customer_notes` text COLLATE utf8mb4_unicode_ci,
  `paid_at` timestamp NULL DEFAULT NULL,
  `processed_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint UNSIGNED NOT NULL,
  `item_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'package',
  `order_id` bigint UNSIGNED NOT NULL,
  `package_id` bigint UNSIGNED DEFAULT NULL,
  `product_id` bigint UNSIGNED DEFAULT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `points_awarded_per_item` int NOT NULL DEFAULT '0',
  `total_points_awarded` int NOT NULL DEFAULT '0',
  `package_snapshot` json DEFAULT NULL,
  `product_snapshot` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_status_histories`
--

CREATE TABLE `order_status_histories` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `changed_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `packages`
--

CREATE TABLE `packages` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `points_awarded` int NOT NULL DEFAULT '0',
  `quantity_available` int DEFAULT NULL,
  `short_description` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `long_description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `meta_data` json DEFAULT NULL,
  `is_mlm_package` tinyint(1) NOT NULL DEFAULT '0',
  `max_mlm_levels` tinyint UNSIGNED NOT NULL DEFAULT '5',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `packages`
--

INSERT INTO `packages` (`id`, `name`, `slug`, `price`, `points_awarded`, `quantity_available`, `short_description`, `long_description`, `image_path`, `is_active`, `sort_order`, `meta_data`, `is_mlm_package`, `max_mlm_levels`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Starter Package', 'starter-package', 1000.00, 100, 9999, 'MLM Starter Package with 5-level commission structure', 'Join our Multi-Level Marketing program with the Starter Package. Earn commissions from your network across 5 levels: ₱200 from direct referrals (Level 1) and ₱50 from each of 4 indirect levels (Levels 2-5). Build your team and maximize your earnings potential!', NULL, 1, 1, '{\"features\": [\"MLM Business Opportunity\", \"Share Referral Links\", \"5-Level Commission Structure\", \"Withdrawable MLM Earnings\", \"Network Visualization\"], \"profit_margin\": \"60%\", \"company_profit\": 600, \"total_commission\": 400, \"commission_breakdown\": {\"level_1\": 200, \"level_2\": 50, \"level_3\": 50, \"level_4\": 50, \"level_5\": 50}}', 1, 5, '2025-10-15 04:19:58', '2025-10-15 04:19:58', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `package_reservations`
--

CREATE TABLE `package_reservations` (
  `id` bigint UNSIGNED NOT NULL,
  `package_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `quantity` int UNSIGNED NOT NULL,
  `session_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` timestamp NOT NULL,
  `status` enum('active','completed','expired','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Order number if completed',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'wallet_management', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55'),
(2, 'transaction_approval', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55'),
(3, 'system_settings', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55'),
(4, 'deposit_funds', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55'),
(5, 'transfer_funds', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55'),
(6, 'withdraw_funds', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55'),
(7, 'view_transactions', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55'),
(8, 'profile_update', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `points_awarded` int NOT NULL DEFAULT '0',
  `quantity_available` int DEFAULT NULL,
  `short_description` text COLLATE utf8mb4_unicode_ci,
  `long_description` text COLLATE utf8mb4_unicode_ci,
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `sort_order` int NOT NULL DEFAULT '0',
  `meta_data` json DEFAULT NULL,
  `total_unilevel_bonus` decimal(10,2) NOT NULL DEFAULT '0.00',
  `sku` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight_grams` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `slug`, `price`, `points_awarded`, `quantity_available`, `short_description`, `long_description`, `image_path`, `is_active`, `sort_order`, `meta_data`, `total_unilevel_bonus`, `sku`, `category`, `weight_grams`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Collagen Beauty Drink', 'collagen-beauty-drink', 1500.00, 25, 100, 'Marine collagen peptides for youthful skin and strong nails', 'Transform your beauty routine with our Collagen Beauty Drink. Made from marine collagen peptides with added vitamins C and E, this delicious drink supports skin elasticity, reduces fine lines, and strengthens hair and nails.', NULL, 1, 0, NULL, 130.00, 'PROD-4SQYJZMT', 'Beauty', 300, '2025-10-15 04:19:59', '2025-10-15 04:19:59', NULL),
(2, 'Immune Booster Capsules', 'immune-booster-capsules', 1200.00, 20, 50, 'A blend of Vitamin C, Zinc, and Elderberry to support your immune system.', 'Stay protected year-round with our Immune Booster Capsules. Each capsule is packed with a powerful combination of Vitamin C, Zinc, and Elderberry extract to help strengthen your body\'s natural defenses.', NULL, 1, 0, NULL, 100.00, 'PROD-JU51V8AX', 'Health & Wellness', 150, '2025-10-15 04:19:59', '2025-10-15 04:19:59', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `referral_clicks`
--

CREATE TABLE `referral_clicks` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `clicked_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `registered` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `return_requests`
--

CREATE TABLE `return_requests` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `reason` enum('damaged_product','wrong_item','not_as_described','quality_issue','no_longer_needed','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `images` json DEFAULT NULL,
  `status` enum('pending','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `admin_response` text COLLATE utf8mb4_unicode_ci,
  `return_tracking_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `rejected_at` timestamp NULL DEFAULT NULL,
  `refunded_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55'),
(2, 'member', 'web', '2025-10-15 04:19:55', '2025-10-15 04:19:55');

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(4, 2),
(5, 2),
(6, 2),
(7, 2),
(8, 2);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('BPH2zcZbo0hSphIpYf7UNfCPNT7VVLmzcZmf5ED2', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'ZXlKcGRpSTZJbEpIY1RoNFoyMVpMMEowZFdKamNUQk5hMlJUUzFFOVBTSXNJblpoYkhWbElqb2lUMVVyYkc5V1RHeENOVmx4VGxaMGJ6Wm5WRW93ZG5aMFFqQkJWMG8yYlRSMFpsVXhTbEpNY3pseGVuTTFOa3d3Tm5FeFpGbExSMHMxTjJKT1pVSXdVMUpQUnpKWldFeFpiMFExUkhndmFFVTRaMHhCV21sbU5pOUVRVU5qTWt3NVdDOVZTazFJTkVKNmVIUmhhekIzT0ZjelRYaHplWE51V0hGNU1uTnhiREZRVTJGaVlXUlNNU3RGTjA5T1JsWlZOamNyYzNRclQxTmFXbTVHZEV4RFozZGpkalZTTkVZdk1FVnZVWGxDWldKVVNFbGtiV0puVjJwaGFtNUJSRFpHVmtFMUwyTlBTV2MzTm5oNWFDdE1aVUV3Ym5jMVoweGhhbTVpUTI0d01VRmhlSFZhVkhwTFdWWlpka1poUmpoaFMyc3ZaRmhYWWpZNWFXVnpUV04xZEU1a1RTdE5XRlJWUzFKa00ybHlVVEpKVGxRNWMxWXJXbEJEUlZsV09VRmhORmt3ZEhaRFMzZHdTRTloTlV0bGFVWkNTWFJsWjFaa2FtTnRPWFV4YjNvaUxDSnRZV01pT2lKbE16ZGhZbVpqTTJSaU1qaGhZakUxWTJVelpqa3pNakpoTjJVellqazRZemRoTWpjeU5ETmlNR05pWldNd05HRmxNR05qWmpjME5HSTNZV1l3TTJVeklpd2lkR0ZuSWpvaUluMD0=', 1760502391);

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` bigint UNSIGNED NOT NULL,
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'string',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `key`, `value`, `type`, `description`, `created_at`, `updated_at`) VALUES
(1, 'app_name', 'Gawis iHerbal', 'string', 'Application name', '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(2, 'app_version', '1.0.0', 'string', 'Application version', '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(3, 'email_verification_enabled', '1', 'boolean', 'Enable email verification', '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(4, 'maintenance_mode', '0', 'boolean', 'Maintenance mode status', '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(5, 'tax_rate', '0', 'decimal', 'E-commerce tax rate (0.0 to 1.0)', '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(6, 'email_verification_required', '1', 'boolean', 'Require email verification after registration', '2025-10-15 04:19:58', '2025-10-15 04:19:58'),
(7, 'reset_count', '2', 'integer', 'Number of times database has been reset', '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(8, 'last_reset_date', '2025-10-15T04:19:59.277246Z', 'string', 'Last database reset timestamp', '2025-10-15 04:19:59', '2025-10-15 04:19:59');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `source_order_id` bigint UNSIGNED DEFAULT NULL,
  `type` enum('deposit','withdrawal','transfer','transfer_out','transfer_in','transfer_charge','withdrawal_fee','payment','refund','mlm_commission','balance_conversion','unilevel_bonus') COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_type` enum('mlm','unilevel') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` tinyint DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `status` enum('pending','approved','rejected','blocked','completed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `payment_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `approved_by` bigint UNSIGNED DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `reference_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `unilevel_settings`
--

CREATE TABLE `unilevel_settings` (
  `id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `level` tinyint NOT NULL,
  `bonus_amount` decimal(10,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `unilevel_settings`
--

INSERT INTO `unilevel_settings` (`id`, `product_id`, `level`, `bonus_amount`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 50.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(2, 1, 2, 30.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(3, 1, 3, 20.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(4, 1, 4, 15.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(5, 1, 5, 15.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(6, 2, 1, 40.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(7, 2, 2, 25.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(8, 2, 3, 15.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(9, 2, 4, 10.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59'),
(10, 2, 5, 10.00, 1, '2025-10-15 04:19:59', '2025-10-15 04:19:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `sponsor_id` bigint UNSIGNED DEFAULT NULL,
  `referral_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `network_status` enum('inactive','active','suspended') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'inactive',
  `network_activated_at` timestamp NULL DEFAULT NULL,
  `last_product_purchase_at` timestamp NULL DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fullname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delivery_instructions` text COLLATE utf8mb4_unicode_ci,
  `delivery_time_preference` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'anytime',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `suspended_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `two_factor_secret` text COLLATE utf8mb4_unicode_ci,
  `two_factor_recovery_codes` text COLLATE utf8mb4_unicode_ci,
  `two_factor_confirmed_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `payment_preference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gcash_number` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maya_number` varchar(11) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pickup_location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `other_payment_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `other_payment_details` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `sponsor_id`, `referral_code`, `network_status`, `network_activated_at`, `last_product_purchase_at`, `username`, `fullname`, `email`, `phone`, `address`, `address_2`, `city`, `state`, `zip`, `delivery_instructions`, `delivery_time_preference`, `email_verified_at`, `suspended_at`, `password`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `created_at`, `updated_at`, `payment_preference`, `gcash_number`, `maya_number`, `pickup_location`, `other_payment_method`, `other_payment_details`) VALUES
(1, NULL, 'REF7TKOCFBH', 'inactive', NULL, NULL, 'admin', 'System Administrator', 'admin@gawisherbal.com', '+63 (947) 367-7436', '123 Herbal Street', NULL, 'Wellness City', 'HC', '12345', NULL, 'anytime', '2025-10-15 04:19:56', NULL, '$2y$12$nfuIYLgZAHCeY/CaMkOcWelX973trFeh5MLWZqYB2YY5.Buc8rcIK', NULL, NULL, NULL, NULL, '2025-10-15 04:19:56', '2025-10-15 04:19:56', NULL, NULL, NULL, NULL, NULL, NULL),
(2, 1, 'REFRFHTETDE', 'inactive', NULL, NULL, 'member', 'John Michael Santos', 'member@gawisherbal.com', '+63 (912) 456-7890', '456 Wellness Avenue', 'Unit 202', 'Health City', 'Metro Manila', '54321', 'Ring doorbell twice. Gate code: 1234', 'morning', '2025-10-15 04:19:58', NULL, '$2y$12$ZD0iyzJ/s2yWoQibXNP3xO4jNK6aOmbvpmewDmjaGYBJR8pXw..ue', NULL, NULL, NULL, NULL, '2025-10-15 04:19:58', '2025-10-15 04:19:58', NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `before_users_insert_check_circular_sponsor` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
                -- Only check if sponsor_id is not NULL
                IF NEW.sponsor_id IS NOT NULL THEN
                    -- For INSERT, we can't check against NEW.id since it doesn't exist yet
                    -- The model-level validation will handle this case
                    -- This trigger primarily protects against raw SQL updates

                    -- Still check for self-reference in case someone manually sets the ID
                    IF NEW.id IS NOT NULL AND NEW.id = NEW.sponsor_id THEN
                        SIGNAL SQLSTATE "45000"
                            SET MESSAGE_TEXT = "A user cannot sponsor themselves.";
                    END IF;
                END IF;
            END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_users_update_check_circular_sponsor` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
                -- Only check if sponsor_id is being changed and is not NULL
                IF NEW.sponsor_id IS NOT NULL AND (OLD.sponsor_id IS NULL OR NEW.sponsor_id != OLD.sponsor_id) THEN
                    CALL check_circular_sponsor_reference(NEW.id, NEW.sponsor_id);
                END IF;
            END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

CREATE TABLE `wallets` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `mlm_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `unilevel_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `withdrawable_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `purchase_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `last_transaction_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wallets`
--

INSERT INTO `wallets` (`id`, `user_id`, `mlm_balance`, `unilevel_balance`, `withdrawable_balance`, `purchase_balance`, `is_active`, `last_transaction_at`, `created_at`, `updated_at`) VALUES
(1, 1, 0.00, 0.00, 0.00, 1000.00, 1, NULL, '2025-10-15 04:19:56', '2025-10-15 04:19:58'),
(2, 2, 0.00, 0.00, 0.00, 1000.00, 1, NULL, '2025-10-15 04:19:58', '2025-10-15 04:19:58');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activity_logs_transaction_id_foreign` (`transaction_id`),
  ADD KEY `activity_logs_order_id_foreign` (`order_id`),
  ADD KEY `activity_logs_type_created_at_index` (`type`,`created_at`),
  ADD KEY `activity_logs_user_id_type_index` (`user_id`,`type`),
  ADD KEY `activity_logs_level_created_at_index` (`level`,`created_at`),
  ADD KEY `activity_logs_type_index` (`type`),
  ADD KEY `activity_logs_event_index` (`event`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `inventory_logs`
--
ALTER TABLE `inventory_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_logs_user_id_foreign` (`user_id`),
  ADD KEY `inventory_logs_package_id_created_at_index` (`package_id`,`created_at`),
  ADD KEY `inventory_logs_action_created_at_index` (`action`,`created_at`),
  ADD KEY `inventory_logs_action_index` (`action`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mlm_settings`
--
ALTER TABLE `mlm_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `mlm_settings_package_id_level_unique` (`package_id`,`level`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `orders_order_number_unique` (`order_number`),
  ADD KEY `orders_user_id_status_index` (`user_id`,`status`),
  ADD KEY `orders_status_created_at_index` (`status`,`created_at`),
  ADD KEY `orders_payment_status_index` (`payment_status`),
  ADD KEY `orders_order_number_index` (`order_number`),
  ADD KEY `idx_orders_status` (`status`),
  ADD KEY `idx_orders_user_id` (`user_id`),
  ADD KEY `idx_orders_created_at` (`created_at`),
  ADD KEY `idx_orders_order_number` (`order_number`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_index` (`order_id`),
  ADD KEY `order_items_package_id_index` (`package_id`),
  ADD KEY `order_items_order_id_package_id_index` (`order_id`,`package_id`),
  ADD KEY `idx_order_items_order_id` (`order_id`),
  ADD KEY `idx_order_items_package_id` (`package_id`),
  ADD KEY `order_items_product_id_foreign` (`product_id`);

--
-- Indexes for table `order_status_histories`
--
ALTER TABLE `order_status_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_status_histories_order_id_created_at_index` (`order_id`,`created_at`),
  ADD KEY `order_status_histories_status_index` (`status`),
  ADD KEY `order_status_histories_changed_by_index` (`changed_by`);

--
-- Indexes for table `packages`
--
ALTER TABLE `packages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `packages_slug_unique` (`slug`),
  ADD KEY `packages_is_active_sort_order_index` (`is_active`,`sort_order`),
  ADD KEY `packages_slug_index` (`slug`),
  ADD KEY `idx_packages_is_active` (`is_active`),
  ADD KEY `idx_packages_slug` (`slug`);

--
-- Indexes for table `package_reservations`
--
ALTER TABLE `package_reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `package_reservations_package_id_foreign` (`package_id`),
  ADD KEY `package_reservations_user_id_foreign` (`user_id`),
  ADD KEY `package_reservations_expires_at_status_index` (`expires_at`,`status`),
  ADD KEY `package_reservations_session_id_index` (`session_id`),
  ADD KEY `package_reservations_expires_at_index` (`expires_at`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_slug_unique` (`slug`),
  ADD UNIQUE KEY `products_sku_unique` (`sku`),
  ADD KEY `products_is_active_sort_order_index` (`is_active`,`sort_order`),
  ADD KEY `products_category_index` (`category`);

--
-- Indexes for table `referral_clicks`
--
ALTER TABLE `referral_clicks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `referral_clicks_user_id_clicked_at_index` (`user_id`,`clicked_at`);

--
-- Indexes for table `return_requests`
--
ALTER TABLE `return_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `return_requests_order_id_foreign` (`order_id`),
  ADD KEY `return_requests_user_id_foreign` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `system_settings_key_unique` (`key`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transactions_reference_number_unique` (`reference_number`),
  ADD KEY `transactions_approved_by_foreign` (`approved_by`),
  ADD KEY `idx_transactions_user_id` (`user_id`),
  ADD KEY `idx_transactions_status` (`status`),
  ADD KEY `idx_transactions_type` (`type`),
  ADD KEY `transactions_source_order_id_index` (`source_order_id`),
  ADD KEY `transactions_source_type_index` (`source_type`),
  ADD KEY `transactions_type_source_type_index` (`type`,`source_type`);

--
-- Indexes for table `unilevel_settings`
--
ALTER TABLE `unilevel_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unilevel_settings_product_id_level_unique` (`product_id`,`level`),
  ADD KEY `unilevel_settings_product_id_is_active_index` (`product_id`,`is_active`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_referral_code_unique` (`referral_code`),
  ADD KEY `users_sponsor_id_index` (`sponsor_id`);

--
-- Indexes for table `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `wallets_user_id_unique` (`user_id`),
  ADD KEY `wallets_withdrawable_balance_index` (`withdrawable_balance`),
  ADD KEY `wallets_unilevel_balance_index` (`unilevel_balance`),
  ADD KEY `wallets_mlm_balance_index` (`mlm_balance`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_logs`
--
ALTER TABLE `inventory_logs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `mlm_settings`
--
ALTER TABLE `mlm_settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_status_histories`
--
ALTER TABLE `order_status_histories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `packages`
--
ALTER TABLE `packages`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `package_reservations`
--
ALTER TABLE `package_reservations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `referral_clicks`
--
ALTER TABLE `referral_clicks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `return_requests`
--
ALTER TABLE `return_requests`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `unilevel_settings`
--
ALTER TABLE `unilevel_settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `wallets`
--
ALTER TABLE `wallets`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `activity_logs_transaction_id_foreign` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `activity_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `inventory_logs`
--
ALTER TABLE `inventory_logs`
  ADD CONSTRAINT `inventory_logs_package_id_foreign` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventory_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `mlm_settings`
--
ALTER TABLE `mlm_settings`
  ADD CONSTRAINT `mlm_settings_package_id_foreign` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_package_id_foreign` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `order_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `order_status_histories`
--
ALTER TABLE `order_status_histories`
  ADD CONSTRAINT `order_status_histories_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `package_reservations`
--
ALTER TABLE `package_reservations`
  ADD CONSTRAINT `package_reservations_package_id_foreign` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `package_reservations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `referral_clicks`
--
ALTER TABLE `referral_clicks`
  ADD CONSTRAINT `referral_clicks_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `return_requests`
--
ALTER TABLE `return_requests`
  ADD CONSTRAINT `return_requests_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `return_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_approved_by_foreign` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transactions_source_order_id_foreign` FOREIGN KEY (`source_order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transactions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `unilevel_settings`
--
ALTER TABLE `unilevel_settings`
  ADD CONSTRAINT `unilevel_settings_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_sponsor_id_foreign` FOREIGN KEY (`sponsor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `wallets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
