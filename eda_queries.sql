-- ============================================================
--  CUSTOMER SHOPPING BEHAVIOR — SQL EXPLORATORY DATA ANALYSIS
--  Table  : public.customer_data
--  Author : Fathima Fayaz
--  Engine : PostgreSQL 15+
-- ============================================================
-- ============================================================
--  SECTION 1: OVERVIEW KPIs
-- ============================================================
-- 1.1  Top-line metrics
SELECT COUNT(*) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_usd,
    SUM(purchase_amount) AS total_revenue_usd,
    ROUND(AVG(review_rating), 2) AS avg_review_rating,
    ROUND(AVG(previous_purchases), 1) AS avg_previous_purchases,
    SUM(
        CASE
            WHEN subscription = 'Yes' THEN 1
            ELSE 0
        END
    ) AS subscribers,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN subscription = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS subscription_rate_pct
FROM public.customer_data;
-- 1.2  Revenue by category
SELECT category,
    COUNT(*) AS customers,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    ROUND(AVG(review_rating), 2) AS avg_rating
FROM public.customer_data
GROUP BY category
ORDER BY total_revenue DESC;
-- 1.3  Revenue by season
SELECT season,
    COUNT(*) AS orders,
    SUM(purchase_amount) AS revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value
FROM public.customer_data
GROUP BY season
ORDER BY revenue DESC;
-- ============================================================
--  SECTION 2: CUSTOMER DEMOGRAPHICS
-- ============================================================
-- 2.1  Gender split with revenue
SELECT gender,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct,
    SUM(purchase_amount) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    ROUND(AVG(review_rating), 2) AS avg_rating
FROM public.customer_data
GROUP BY gender;
-- 2.2  Age group analysis
SELECT CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        WHEN age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END AS age_group,
    COUNT(*) AS customers,
    SUM(purchase_amount) AS revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(AVG(review_rating), 2) AS avg_rating
FROM public.customer_data
GROUP BY 1
ORDER BY 1;
-- 2.3  Top 10 states by revenue
SELECT location,
    COUNT(*) AS customers,
    SUM(purchase_amount) AS revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value
FROM public.customer_data
GROUP BY location
ORDER BY revenue DESC
LIMIT 10;
-- ============================================================
--  SECTION 3: PRODUCT & CATEGORY ANALYSIS
-- ============================================================
-- 3.1  Top 10 best-selling items
SELECT item,
    category,
    COUNT(*) AS times_purchased,
    SUM(purchase_amount) AS revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_price,
    ROUND(AVG(review_rating), 2) AS avg_rating
FROM public.customer_data
GROUP BY item,
    category
ORDER BY times_purchased DESC
LIMIT 10;
-- 3.2  Category × season cross analysis
SELECT category,
    season,
    COUNT(*) AS orders,
    SUM(purchase_amount) AS revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value
FROM public.customer_data
GROUP BY category,
    season
ORDER BY category,
    revenue DESC;
-- 3.3  Most popular sizes per category
SELECT category,
    size,
    COUNT(*) AS count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY category),
        1
    ) AS pct
FROM public.customer_data
GROUP BY category,
    size
ORDER BY category,
    count DESC;
-- 3.4  Top 10 colors by revenue
SELECT color,
    COUNT(*) AS orders,
    SUM(purchase_amount) AS revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM public.customer_data
GROUP BY color
ORDER BY revenue DESC
LIMIT 10;
-- ============================================================
--  SECTION 4: PURCHASE BEHAVIOUR & LOYALTY
-- ============================================================
-- 4.1  Subscription vs non-subscription performance
SELECT subscription,
    COUNT(*) AS customers,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    ROUND(AVG(previous_purchases), 1) AS avg_prev_purchases,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    SUM(purchase_amount) AS total_revenue
FROM public.customer_data
GROUP BY subscription;
-- 4.2  Discount & promo code impact on revenue
SELECT discount_applied,
    promo_code_used,
    COUNT(*) AS orders,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    SUM(purchase_amount) AS revenue
FROM public.customer_data
GROUP BY discount_applied,
    promo_code_used
ORDER BY discount_applied,
    promo_code_used;
-- 4.3  Purchase frequency distribution
SELECT purchase_frequency,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    ROUND(AVG(previous_purchases), 1) AS avg_prev_purchases
FROM public.customer_data
GROUP BY purchase_frequency
ORDER BY customers DESC;
-- 4.4  Loyal customer segment
--      Definition: subscribed + more than 25 previous purchases
SELECT COUNT(*) AS loyal_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    SUM(purchase_amount) AS revenue
FROM public.customer_data
WHERE subscription = 'Yes'
    AND previous_purchases > 25;
-- 4.5  Repeat buyer ranking (top 15)
SELECT customer_id,
    age,
    gender,
    location,
    previous_purchases,
    purchase_amount,
    subscription
FROM public.customer_data
ORDER BY previous_purchases DESC
LIMIT 15;
-- ============================================================
--  SECTION 5: PAYMENT & SHIPPING
-- ============================================================
-- 5.1  Payment method breakdown
SELECT payment_method,
    COUNT(*) AS transactions,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct,
    SUM(purchase_amount) AS revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value
FROM public.customer_data
GROUP BY payment_method
ORDER BY transactions DESC;
-- 5.2  Shipping type preference & avg spend
SELECT shipping_type,
    COUNT(*) AS orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    SUM(purchase_amount) AS revenue
FROM public.customer_data
GROUP BY shipping_type
ORDER BY orders DESC;
-- 5.3  Shipping preference by category
SELECT category,
    shipping_type,
    COUNT(*) AS orders
FROM public.customer_data
GROUP BY category,
    shipping_type
ORDER BY category,
    orders DESC;
-- ============================================================
--  SECTION 6: REVIEW RATING ANALYSIS
-- ============================================================
-- 6.1  Rating distribution
SELECT review_rating,
    COUNT(*) AS count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM public.customer_data
GROUP BY review_rating
ORDER BY review_rating DESC;
-- 6.2  Average rating by category and season
SELECT category,
    season,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    COUNT(*) AS orders
FROM public.customer_data
GROUP BY category,
    season
ORDER BY category,
    avg_rating DESC;
-- 6.3  Low-rated items (avg < 3.0)
SELECT item,
    category,
    ROUND(AVG(review_rating), 2) AS avg_rating,
    COUNT(*) AS reviews
FROM public.customer_data
GROUP BY item,
    category
HAVING AVG(review_rating) < 3.0
ORDER BY avg_rating ASC;
-- ============================================================
--  SECTION 7: ADVANCED / COHORT QUERIES
-- ============================================================
-- 7.1  High-value customers (spend > $80 AND subscribed)
SELECT customer_id,
    age,
    gender,
    location,
    purchase_amount,
    previous_purchases,
    payment_method
FROM public.customer_data
WHERE purchase_amount > 80
    AND subscription = 'Yes'
ORDER BY purchase_amount DESC;
-- 7.2  Revenue contribution by spend tier
SELECT spend_tier,
    COUNT(*) AS customers,
    SUM(purchase_amount) AS revenue,
    ROUND(
        100.0 * SUM(purchase_amount) / SUM(SUM(purchase_amount)) OVER (),
        1
    ) AS revenue_pct
FROM (
        SELECT CASE
                WHEN purchase_amount < 40 THEN 'Low (<$40)'
                WHEN purchase_amount <= 70 THEN 'Mid ($40-$70)'
                ELSE 'High (>$70)'
            END AS spend_tier,
            purchase_amount
        FROM public.customer_data
    ) sub
GROUP BY spend_tier
ORDER BY revenue DESC;
-- 7.3  Gender × subscription cross-tab
SELECT gender,
    subscription,
    COUNT(*) AS customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(AVG(review_rating), 2) AS avg_rating
FROM public.customer_data
GROUP BY gender,
    subscription
ORDER BY gender,
    subscription;
-- 7.4  Category revenue trend by season (with season-over-season change)
SELECT season,
    category,
    COUNT(*) AS orders,
    SUM(purchase_amount) AS revenue,
    ROUND(
        SUM(purchase_amount) - LAG(SUM(purchase_amount)) OVER (
            PARTITION BY category
            ORDER BY CASE
                    season
                    WHEN 'Spring' THEN 1
                    WHEN 'Summer' THEN 2
                    WHEN 'Fall' THEN 3
                    ELSE 4
                END
        ),
        2
    ) AS revenue_change_vs_prev_season
FROM public.customer_data
GROUP BY season,
    category
ORDER BY category,
    CASE
        season
        WHEN 'Spring' THEN 1
        WHEN 'Summer' THEN 2
        WHEN 'Fall' THEN 3
        ELSE 4
    END;