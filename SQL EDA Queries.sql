1. Sales Overview Queries
    
1. Total Orders, Delivered Orders, Cancelled Orders
SELECT
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) AS cancelled_orders
FROM orders;


2. Total Sales & Total Revenue
SELECT
    SUM(price) AS total_sales,
    SUM(price + freight_value) AS total_revenue
FROM order_items;


3. Orders by Customer State
SELECT
    c.customer_state,
    COUNT(o.order_id) AS order_count
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY order_count DESC;


4. Average Freight by Category
SELECT
    p.category,
    ROUND(AVG(oi.freight_value), 2) AS avg_freight
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_freight DESC;


5. Total Revenue by Category
SELECT
    p.category,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


6. Total Revenue & Sales by Geolocation (Customer State)
SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_sales,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;
________________________________________
2. Customer Analysis
7. Customers by State
SELECT
    customer_state,
    COUNT(DISTINCT customer_id) AS customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC;


8. Repeat vs One-Time Buyers
SELECT
    CASE 
        WHEN order_count > 1 THEN 'Repeat Customer'
        ELSE 'One-Time Buyer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) sub
GROUP BY customer_type;
________________________________________
3. Review Analysis

    
    9. Review Score Distribution
SELECT
    review_score,
    COUNT(order_id) AS review_count
FROM reviews
GROUP BY review_score
ORDER BY review_score;


10. Average Review Score by State
SELECT
    c.customer_state,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY avg_review_score DESC;
________________________________________
4. Payment Analysis

    11. Count of Payment Type
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM payments
GROUP BY payment_type
ORDER BY payment_count DESC;


12. Total Payment Value by Type
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


13. Average Installments by Payment Type
SELECT
    payment_type,
    ROUND(AVG(payment_installments), 2) AS avg_installment
FROM payments
GROUP BY payment_type
ORDER BY avg_installment DESC;
________________________________________
5. Optional Deep-Dive Queries

    14. Top 10 Categories by Orders
SELECT
    p.category,
    COUNT(oi.order_id) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_orders DESC
LIMIT 10;


15. Monthly Sales Trend
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    SUM(oi.price) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;
