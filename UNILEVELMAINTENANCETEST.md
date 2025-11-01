# Unilevel Maintenance Functionality Test

## 1. Objective

This documentation outlines the steps to test the unilevel maintenance functionality. The goal is to verify that unilevel bonuses are only distributed to uplines who have met the monthly maintenance requirement, which is a minimum personal purchase of products (in points) from the previous month.

## 2. Prerequisites

Before running the tests, ensure the following prerequisites are met:

*   **System Setting:** The `monthly_maintenance_points` system setting is configured. You can set this in the admin panel or by running the following command:

    ```php
    \App\Models\SystemSetting::set('monthly_maintenance_points', 100);
    ```

*   **Users:** At least two users are available in the database: an upline and a buyer. The buyer should be sponsored by the upline.
*   **Product:** At least one product with points is available in the database.
*   **Unilevel Setting:** A unilevel setting is configured for the product.

## 3. Test Scenarios

To test the functionality without waiting for a month to pass, we will manually create orders with a specific `created_at` date.

### 3.1. Upline Meets Maintenance

This scenario tests that an upline who has met the monthly maintenance requirement receives the unilevel bonus.

**Steps:**

1.  **Create a completed order for the upline in the previous month.** This order should have enough points to meet the `monthly_maintenance_points` requirement.

    ```php
    $upline = \App\Models\User::find(1); // Replace with the upline's ID
    $product = \App\Models\Product::find(1); // Replace with the product's ID

    $previousMonthOrder = \App\Models\Order::create([
        'user_id' => $upline->id,
        'status' => 'completed',
        'created_at' => now()->subMonth(),
        'order_number' => 'TEST-001',
        'subtotal' => 200,
        'tax_amount' => 0,
        'total_amount' => 200,
    ]);

    \App\Models\OrderItem::create([
        'order_id' => $previousMonthOrder->id,
        'product_id' => $product->id,
        'quantity' => 2, // 2 * 50 points = 100 points
        'unit_price' => 100,
        'total_price' => 200,
    ]);
    ```

2.  **Create a completed order for the buyer in the current month.**

    ```php
    $buyer = \App\Models\User::find(2); // Replace with the buyer's ID

    $order = \App\Models\Order::create([
        'user_id' => $buyer->id,
        'status' => 'completed',
        'order_number' => 'TEST-002',
        'subtotal' => 100,
        'tax_amount' => 0,
        'total_amount' => 100,
    ]);

    \App\Models\OrderItem::create([
        'order_id' => $order->id,
        'product_id' => $product->id,
        'quantity' => 1,
        'unit_price' => 100,
        'total_price' => 100,
    ]);
    ```

3.  **Process the bonuses for the buyer's order.**

    ```php
    $unilevelBonusService = new \App\Services\UnilevelBonusService();
    $unilevelBonusService->processBonuses($order);
    ```

### 3.2. Upline Does Not Meet Maintenance

This scenario tests that an upline who has not met the monthly maintenance requirement does not receive the unilevel bonus.

**Steps:**

1.  **Ensure the upline has no completed orders in the previous month.**
2.  **Create a completed order for the buyer in the current month.** (Same as step 2 in the previous scenario)
3.  **Process the bonuses for the buyer's order.** (Same as step 3 in the previous scenario)

## 4. Verification

To verify the test results, check the `transactions` table in the database.

*   **For the "Upline Meets Maintenance" scenario:** A new transaction with the type `unilevel_bonus` should be created for the upline.
*   **For the "Upline Does Not Meet Maintenance" scenario:** No new transaction with the type `unilevel_bonus` should be created for the upline.

You can use the following query to check the transactions:

```sql
SELECT * FROM transactions WHERE user_id = <upline_id> AND type = 'unilevel_bonus';
```

## 5. Troubleshooting

If the tests are not passing, check the following:

*   **Log files:** Check the Laravel log file (`storage/logs/laravel.log`) for any errors.
*   **Database:** Verify that the test data is being created correctly in the database.
*   **Code:** Review the `hasMetMonthlyMaintenance` method in the `User` model and the `processBonuses` method in the `UnilevelBonusService` to ensure the logic is correct.
