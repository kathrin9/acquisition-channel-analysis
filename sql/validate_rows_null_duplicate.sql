WITH validation as (
  
 SELECT

    'users' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(user_id) AS non_null_ids,
    COUNT(DISTINCT user_id) AS unique_ids,

    COUNT(*) - COUNT(user_id) AS null_ids,

    COUNT(user_id) - COUNT(DISTINCT user_id) AS duplicate_ids

FROM users

UNION ALL

SELECT
    'sessions',
    COUNT(*),
    COUNT(session_id),
    COUNT(DISTINCT session_id),
    COUNT(*) - COUNT(session_id),
    COUNT(session_id) - COUNT(DISTINCT session_id)
FROM sessions 

UNION ALL  

SELECT
    'products',
    COUNT(*),
    COUNT(product_id),
    COUNT(DISTINCT product_id),
    COUNT(*) - COUNT(product_id),
    COUNT(product_id) - COUNT(DISTINCT product_id)
FROM products 

UNION ALL

SELECT
    'orders',
    COUNT(*),
    COUNT(order_id),
    COUNT(DISTINCT order_id),
    COUNT(*) - COUNT(order_id),
    COUNT(order_id) - COUNT(DISTINCT order_id)
FROM orders 

UNION ALL

SELECT
    'order_items',
    COUNT(*),
    COUNT(item_id),
    COUNT(DISTINCT item_id),
    COUNT(*) - COUNT(item_id),
    COUNT(item_id) - COUNT(DISTINCT item_id)
FROM order_items

UNION ALL

SELECT
    'marketing_costs',
    COUNT(*),
    COUNT(campaign_id),
    COUNT(DISTINCT campaign_id),
    COUNT(*) - COUNT(campaign_id),
    COUNT(campaign_id) - COUNT(DISTINCT campaign_id)
FROM marketing_costs

UNION ALL

SELECT
    'discounts',
    COUNT(*),
    COUNT(discount_code),
    COUNT(DISTINCT discount_code),
    COUNT(*) - COUNT(discount_code),
    COUNT(discount_code) - COUNT(DISTINCT discount_code)
FROM discounts

UNION ALL

SELECT
    'ad_exposures',
    COUNT(*),
    COUNT(exposure_id),
    COUNT(DISTINCT exposure_id),
    COUNT(*) - COUNT(exposure_id),
    COUNT(exposure_id) - COUNT(DISTINCT exposure_id)
FROM ad_exposures
)

SELECT *
FROM validation

UNION ALL

SELECT
    'TOTAL',
    SUM(total_rows),
    SUM(non_null_ids),
    SUM(unique_ids),
    SUM(null_ids),
    SUM(duplicate_ids)
FROM validation;
