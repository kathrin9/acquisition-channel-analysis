-- ============================================================
--  DATA VALIDATION
-- 1. Row counts, NULL identifiers and repeated identifiers
-- ============================================================
-- Note: campaign_id in marketing_costs can occur on multiple dates.
-- Its repetition is not necessarily a duplicate record.

WITH validation AS (
    SELECT
        'users' AS table_name,
        COUNT(*) AS total_rows,
        COUNT(user_id) AS non_null_ids,
        COUNT(DISTINCT user_id) AS unique_ids,
        COUNT(*) - COUNT(user_id) AS null_ids,
        COUNT(user_id) - COUNT(DISTINCT user_id) AS duplicate_ids
    FROM users

    UNION ALL
    SELECT 'sessions', COUNT(*), COUNT(session_id), COUNT(DISTINCT session_id),
           COUNT(*) - COUNT(session_id), COUNT(session_id) - COUNT(DISTINCT session_id)
    FROM sessions

    UNION ALL
    SELECT 'products', COUNT(*), COUNT(product_id), COUNT(DISTINCT product_id),
           COUNT(*) - COUNT(product_id), COUNT(product_id) - COUNT(DISTINCT product_id)
    FROM products

    UNION ALL
    SELECT 'orders', COUNT(*), COUNT(order_id), COUNT(DISTINCT order_id),
           COUNT(*) - COUNT(order_id), COUNT(order_id) - COUNT(DISTINCT order_id)
    FROM orders

    UNION ALL
    SELECT 'order_items', COUNT(*), COUNT(item_id), COUNT(DISTINCT item_id),
           COUNT(*) - COUNT(item_id), COUNT(item_id) - COUNT(DISTINCT item_id)
    FROM order_items

    UNION ALL
    SELECT 'marketing_costs', COUNT(*), COUNT(campaign_id), COUNT(DISTINCT campaign_id),
           COUNT(*) - COUNT(campaign_id), NULL
    FROM marketing_costs

    UNION ALL
    SELECT 'discounts', COUNT(*), COUNT(discount_code), COUNT(DISTINCT discount_code),
           COUNT(*) - COUNT(discount_code), COUNT(discount_code) - COUNT(DISTINCT discount_code)
    FROM discounts

    UNION ALL
    SELECT 'ad_exposures', COUNT(*), COUNT(exposure_id), COUNT(DISTINCT exposure_id),
           COUNT(*) - COUNT(exposure_id), COUNT(exposure_id) - COUNT(DISTINCT exposure_id)
    FROM ad_exposures
)
SELECT * FROM validation
UNION ALL
SELECT
    'TOTAL',
    SUM(total_rows),
    SUM(non_null_ids),
    NULL AS unique_ids,
    SUM(null_ids),
    NULL AS duplicate_ids
FROM validation;

-- ============================================================
-- 2. Marketing costs: repeated date/channel/campaign combinations
-- Interpretation assumes one expected row per date/channel/campaign.
-- ============================================================
SELECT
    date,
    channel,
    campaign_id,
    COUNT(*) AS occurrences
FROM marketing_costs
GROUP BY date, channel, campaign_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- ============================================================
-- 3. Products: repeated product_id values
-- ============================================================
SELECT
    product_id,
    COUNT(*) AS occurrences
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC, product_id;

-- Full rows for repeated product_id values
SELECT *
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM products
    GROUP BY product_id
    HAVING COUNT(*) > 1
)
ORDER BY product_id;

-- ============================================================
-- 4. Order items: repeated item_id values
-- ============================================================
SELECT
    item_id,
    COUNT(*) AS occurrences
FROM order_items
GROUP BY item_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC, item_id;

-- Full rows for repeated item_id values
SELECT *
FROM order_items
WHERE item_id IN (
    SELECT item_id
    FROM order_items
    GROUP BY item_id
    HAVING COUNT(*) > 1
)
ORDER BY item_id;
