-- =====================================================================
-- 01_data_validation.sql
-- Στόχος: εξερεύνηση κάθε πίνακα ΜΕΜΟΝΩΜΕΝΑ, πριν από οποιοδήποτε JOIN.
-- Καλύπτει: row counts, NULLs, duplicates, date ranges, FK completeness,
--           UTM coverage.
-- =====================================================================


-- =====================================================================
-- 1. ROW COUNTS PER TABLE
-- =====================================================================
-- Γρήγορο "sanity check" — πόσες γραμμές έχει ο κάθε πίνακας.

-- =====================================================================
-- 1. ROW COUNTS PER TABLE
-- =====================================================================
-- Γρήγορο "sanity check" — πόσες γραμμές έχει ο κάθε πίνακας.

SELECT 'users'           AS table_name, COUNT(*) AS row_count FROM users
UNION ALL
SELECT 'sessions',       COUNT(*) FROM sessions
UNION ALL
SELECT 'orders',         COUNT(*) FROM orders
UNION ALL
SELECT 'order_items',    COUNT(*) FROM order_items
UNION ALL
SELECT 'products',       COUNT(*) FROM products
UNION ALL
SELECT 'marketing_costs',COUNT(*) FROM marketing_costs
UNION ALL
SELECT 'discounts',COUNT(*) FROM discounts
UNION ALL
SELECT 'ad_exposures',COUNT(*) FROM ad_exposures;

SELECT
    (SELECT COUNT(*) FROM users)
  + (SELECT COUNT(*) FROM sessions)
  + (SELECT COUNT(*) FROM orders)
  + (SELECT COUNT(*) FROM order_items)
  + (SELECT COUNT(*) FROM products)
  + (SELECT COUNT(*) FROM marketing_costs)
  + (SELECT COUNT(*) FROM discounts)
  + (SELECT COUNT(*) FROM ad_exposures)
  AS total_rows_all_tables;

  ------------------

 SELECT table_name, row_count FROM (
    SELECT 'users'            AS table_name, COUNT(*) AS row_count FROM users
    UNION ALL
    SELECT 'sessions',        COUNT(*) FROM sessions
    UNION ALL
    SELECT 'orders',          COUNT(*) FROM orders
    UNION ALL
    SELECT 'order_items',     COUNT(*) FROM order_items
    UNION ALL
    SELECT 'products',        COUNT(*) FROM products
    UNION ALL
    SELECT 'marketing_costs', COUNT(*) FROM marketing_costs
    UNION ALL
    SELECT 'discounts',       COUNT(*) FROM discounts
    UNION ALL
    SELECT 'ad_exposures',    COUNT(*) FROM ad_exposures
) t
UNION ALL
SELECT 'TOTAL', SUM(row_count) FROM (
    SELECT COUNT(*) AS row_count FROM users
    UNION ALL SELECT COUNT(*) FROM sessions
    UNION ALL SELECT COUNT(*) FROM orders
    UNION ALL SELECT COUNT(*) FROM order_items
    UNION ALL SELECT COUNT(*) FROM products
    UNION ALL SELECT COUNT(*) FROM marketing_costs
    UNION ALL SELECT COUNT(*) FROM discounts
    UNION ALL SELECT COUNT(*) FROM ad_exposures
) counts; 

-- =====================================================================
-- 2. NULL VALUES PER COLUMN
-- =====================================================================
-- Για κάθε πίνακα, μετράμε πόσα NULL έχει κάθε στήλη.
-- Το γράφουμε table-by-table γιατί οι στήλες διαφέρουν.

-- ---- users ----
SELECT
    COUNT(*)                                            AS total_rows,
    SUM(CASE WHEN user_id     IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN email       IS NULL THEN 1 ELSE 0 END) AS null_email,
    SUM(CASE WHEN created_at  IS NULL THEN 1 ELSE 0 END) AS null_created_at,
    SUM(CASE WHEN city        IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN age_group   IS NULL THEN 1 ELSE 0 END) AS null_age_group
FROM users;

-- ---- sessions ----
SELECT
    COUNT(*)                                                AS total_rows,
    SUM(CASE WHEN session_id    IS NULL THEN 1 ELSE 0 END)  AS null_session_id,
    SUM(CASE WHEN user_id       IS NULL THEN 1 ELSE 0 END)  AS null_user_id,
    SUM(CASE WHEN utm_source    IS NULL THEN 1 ELSE 0 END)  AS null_utm_source,
    SUM(CASE WHEN utm_medium    IS NULL THEN 1 ELSE 0 END)  AS null_utm_medium,
    SUM(CASE WHEN utm_campaign  IS NULL THEN 1 ELSE 0 END)  AS null_utm_campaign,
    SUM(CASE WHEN bounced       IS NULL THEN 1 ELSE 0 END)  AS null_bounced,
    SUM(CASE WHEN duration_s    IS NULL THEN 1 ELSE 0 END)  AS null_duration_s,
    SUM(CASE WHEN device        IS NULL THEN 1 ELSE 0 END)  AS null_device
FROM sessions;

-- ---- orders ----
SELECT
    COUNT(*)                                                  AS total_rows,
    SUM(CASE WHEN order_id         IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN user_id          IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN session_id       IS NULL THEN 1 ELSE 0 END) AS null_session_id,
    SUM(CASE WHEN total_amount     IS NULL THEN 1 ELSE 0 END) AS null_total_amount,
    SUM(CASE WHEN discount_amount  IS NULL THEN 1 ELSE 0 END) AS null_discount_amount,
    SUM(CASE WHEN created_at       IS NULL THEN 1 ELSE 0 END) AS null_created_at,
    SUM(CASE WHEN status           IS NULL THEN 1 ELSE 0 END) AS null_status
FROM orders;

-- ---- order_items ----
SELECT
    COUNT(*)                                              AS total_rows,
    SUM(CASE WHEN item_id     IS NULL THEN 1 ELSE 0 END)  AS null_item_id,
    SUM(CASE WHEN order_id    IS NULL THEN 1 ELSE 0 END)  AS null_order_id,
    SUM(CASE WHEN product_id  IS NULL THEN 1 ELSE 0 END)  AS null_product_id,
    SUM(CASE WHEN quantity    IS NULL THEN 1 ELSE 0 END)  AS null_quantity,
    SUM(CASE WHEN unit_price  IS NULL THEN 1 ELSE 0 END)  AS null_unit_price
FROM order_items;

-- ---- products ----
SELECT
    COUNT(*)                                              AS total_rows,
    SUM(CASE WHEN product_id  IS NULL THEN 1 ELSE 0 END)  AS null_product_id,
    SUM(CASE WHEN name        IS NULL THEN 1 ELSE 0 END)  AS null_name,
    SUM(CASE WHEN category    IS NULL THEN 1 ELSE 0 END)  AS null_category,
    SUM(CASE WHEN brand       IS NULL THEN 1 ELSE 0 END)  AS null_brand,
    SUM(CASE WHEN base_price  IS NULL THEN 1 ELSE 0 END)  AS null_base_price,
    SUM(CASE WHEN margin_pct  IS NULL THEN 1 ELSE 0 END)  AS null_margin_pct
FROM products;

-- ---- marketing_costs ----
SELECT
    COUNT(*)                                              AS total_rows,
    SUM(CASE WHEN date         IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN channel      IS NULL THEN 1 ELSE 0 END) AS null_channel,
    SUM(CASE WHEN campaign_id  IS NULL THEN 1 ELSE 0 END) AS null_campaign_id,
    SUM(CASE WHEN spend        IS NULL THEN 1 ELSE 0 END) AS null_spend,
    SUM(CASE WHEN impressions  IS NULL THEN 1 ELSE 0 END) AS null_impressions,
    SUM(CASE WHEN clicks       IS NULL THEN 1 ELSE 0 END) AS null_clicks
FROM marketing_costs;

-- ---- discounts ----
SELECT
    COUNT(*)                                              AS total_rows,
    SUM(CASE WHEN discount_code   IS NULL THEN 1 ELSE 0 END) AS discount_code,
    SUM(CASE WHEN type            IS NULL THEN 1 ELSE 0 END) AS null_type,
    SUM(CASE WHEN value           IS NULL THEN 1 ELSE 0 END) AS null_value,
    SUM(CASE WHEN valid_from      IS NULL THEN 1 ELSE 0 END) AS null_valid_from ,
    SUM(CASE WHEN valid_to        IS NULL THEN 1 ELSE 0 END) AS null_valid_to ,
    SUM(CASE WHEN channel         IS NULL THEN 1 ELSE 0 END) AS null_channel
FROM discounts;


-- ---- ad exposures ----
SELECT
    COUNT(*)                                              AS total_rows,
    SUM(CASE WHEN exposure_id   IS NULL THEN 1 ELSE 0 END) AS null_exposure_id,
    SUM(CASE WHEN user_id            IS NULL THEN 1 ELSE 0 END) AS null_user_id ,
    SUM(CASE WHEN channel           IS NULL THEN 1 ELSE 0 END) AS null_channel,
    SUM(CASE WHEN campaign_id     IS NULL THEN 1 ELSE 0 END) AS null_campaign_id  ,
    SUM(CASE WHEN exposed_at        IS NULL THEN 1 ELSE 0 END) AS null_exposed_at  ,
    SUM(CASE WHEN ad_format         IS NULL THEN 1 ELSE 0 END) AS null_ad_format  
FROM ad exposures;

-- =====================================================================
-- 3. DUPLICATE CHECK
-- =====================================================================
-- (a) Duplicate primary keys -> ΔΕΝ θα έπρεπε ποτέ να υπάρχουν αν το PK
--     είναι σωστά ορισμένο, αλλά ελέγχουμε ούτως ή άλλως (πχ αν έχουν
--     έρθει από CSV/ETL χωρίς constraint).

SELECT user_id, COUNT(*) AS cnt
FROM users
GROUP BY user_id
HAVING COUNT(*) > 1;

SELECT session_id, COUNT(*) AS cnt
FROM sessions
GROUP BY session_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) AS cnt
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT item_id, COUNT(*) AS cnt
FROM order_items
GROUP BY item_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*) AS cnt
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- (b) Business-level duplicates — πιο σημαντικό συχνά από τα PK.
-- Π.χ. ίδιο email σε πολλαπλά user_id (fake / test accounts).

SELECT email, COUNT(*) AS cnt
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Ένα order_id δεν θα έπρεπε ποτέ να εμφανίζεται σε πάνω από ένα session_id.
SELECT order_id, COUNT(DISTINCT session_id) AS distinct_sessions
FROM orders
GROUP BY order_id
HAVING COUNT(DISTINCT session_id) > 1;

-- Πλήρως πανομοιότυπες γραμμές σε order_items (ίδιο order/product/qty/price)
SELECT order_id, product_id, quantity, unit_price, COUNT(*) AS cnt
FROM order_items
GROUP BY order_id, product_id, quantity, unit_price
HAVING COUNT(*) > 1;


-- =====================================================================
-- 4. DATE RANGE VALIDATION
-- =====================================================================
-- Min/max ημερομηνίες ανά πίνακα + έλεγχος για "αδύνατες" τιμές
-- (μελλοντικές ημερομηνίες, πολύ παλιές, κλπ).

SELECT
    MIN(created_at) AS earliest,
    MAX(created_at) AS latest,
    SUM(CASE WHEN created_at > CURRENT_TIMESTAMP THEN 1 ELSE 0 END) AS future_dates
FROM users;

SELECT
    MIN(created_at) AS earliest,
    MAX(created_at) AS latest,
    SUM(CASE WHEN created_at > CURRENT_TIMESTAMP THEN 1 ELSE 0 END) AS future_dates
FROM orders;

SELECT
    MIN(date) AS earliest,
    MAX(date) AS latest,
    SUM(CASE WHEN date > CURRENT_DATE THEN 1 ELSE 0 END) AS future_dates
FROM marketing_costs;

-- Λογικός έλεγχος: το order πρέπει να έχει created_at >= το created_at
-- του χρήστη (δεν μπορεί να παραγγείλει πριν εγγραφεί).
SELECT o.order_id, o.created_at AS order_date, u.created_at AS user_signup_date
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE o.created_at < u.created_at;


-- =====================================================================
-- 5. FOREIGN KEY COMPLETENESS
-- =====================================================================
-- Το πιο κρίσιμο: orders.session_id -> sessions.session_id
-- Πόσα orders έχουν session_id που ΔΕΝ υπάρχει στο sessions;

SELECT COUNT(*) AS orders_without_matching_session
FROM orders o
LEFT JOIN sessions s ON o.session_id = s.session_id
WHERE s.session_id IS NULL;

-- Ίδιο check αλλά και ως ποσοστό επί του συνόλου
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN s.session_id IS NULL THEN 1 ELSE 0 END) AS unmatched,
    ROUND(100.0 * SUM(CASE WHEN s.session_id IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_unmatched
FROM orders o
LEFT JOIN sessions s ON o.session_id = s.session_id;

-- Τα ίδια για τα υπόλοιπα FKs
SELECT COUNT(*) AS orders_without_matching_user
FROM orders o
LEFT JOIN users u ON o.user_id = u.user_id
WHERE u.user_id IS NULL;

SELECT COUNT(*) AS sessions_without_matching_user
FROM sessions s
LEFT JOIN users u ON s.user_id = u.user_id
WHERE u.user_id IS NULL;

SELECT COUNT(*) AS order_items_without_matching_order
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS order_items_without_matching_product
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- =====================================================================
-- 6. UTM COVERAGE
-- =====================================================================
-- % των sessions που έχουν utm_source (δηλαδή ήρθαν από trackable πηγή,
-- σε αντίθεση με direct/organic χωρίς UTM tagging).

SELECT
    COUNT(*)                                                       AS total_sessions,
    SUM(CASE WHEN utm_source IS NOT NULL THEN 1 ELSE 0 END)        AS sessions_with_utm_source,
    ROUND(100.0 * SUM(CASE WHEN utm_source IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_with_utm_source
FROM sessions;

-- Ανάλυση ανά utm_source (τι ποσοστό αντιπροσωπεύει το καθένα)
SELECT
    COALESCE(utm_source, '(none)') AS utm_source,
    COUNT(*)                       AS session_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM sessions
GROUP BY utm_source
ORDER BY session_count DESC;


-- =====================================================================
-- 7. ADDITIONAL FOREIGN KEY COMPLETENESS
-- =====================================================================
-- Τα υπόλοιπα FK ζευγάρια πέρα από orders.session_id -> sessions.
-- Ίδιο pattern: LEFT JOIN + WHERE ... IS NULL βρίσκει τα "ορφανά" rows.

-- order_items.order_id -> orders
SELECT COUNT(*) AS order_items_without_matching_order
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- order_items.product_id -> products
SELECT COUNT(*) AS order_items_without_matching_product
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- sessions.user_id -> users
SELECT COUNT(*) AS sessions_without_matching_user
FROM sessions s
LEFT JOIN users u ON s.user_id = u.user_id
WHERE u.user_id IS NULL AND s.user_id IS NOT NULL;  -- εξαιρούμε τα NULL user_id (guest sessions), αυτά είναι ξεχωριστό θέμα

-- ad_exposures.user_id -> users  (κρίσιμο για το multi-touch attribution)
SELECT COUNT(*) AS ad_exposures_without_matching_user
FROM ad_exposures ae
LEFT JOIN users u ON ae.user_id = u.user_id
WHERE u.user_id IS NULL;


-- =====================================================================
-- 8. DOMAIN / CATEGORICAL VALUE VALIDATION
-- =====================================================================
-- Δεν αρκεί να δεις ότι μια στήλη δεν έχει NULL· πρέπει να δεις κι αν οι
-- τιμές είναι οι αναμενόμενες (case, typos, άγνωστες κατηγορίες).

SELECT DISTINCT utm_source FROM sessions ORDER BY 1;
SELECT DISTINCT utm_medium FROM sessions ORDER BY 1;
SELECT DISTINCT device      FROM sessions ORDER BY 1;
SELECT DISTINCT status      FROM orders   ORDER BY 1;
SELECT DISTINCT category    FROM products ORDER BY 1;
SELECT DISTINCT channel     FROM marketing_costs ORDER BY 1;
SELECT DISTINCT channel     FROM discounts ORDER BY 1;
SELECT DISTINCT ad_format   FROM ad_exposures ORDER BY 1;


-- =====================================================================
-- 9. VALUE SANITY CHECKS
-- =====================================================================
-- Λογικές ασυνέπειες στις τιμές — σημαντικό πριν υπολογίσεις price
-- sensitivity, CLV, CAC/ROAS στα επόμενα scripts.

-- Αρνητικές ή μηδενικές τιμές όπου δεν βγάζει νόημα
SELECT COUNT(*) AS orders_with_non_positive_total FROM orders WHERE total_amount <= 0;
SELECT COUNT(*) AS items_with_non_positive_price   FROM order_items WHERE unit_price <= 0;
SELECT COUNT(*) AS items_with_non_positive_qty     FROM order_items WHERE quantity <= 0;
SELECT COUNT(*) AS products_with_non_positive_base FROM products WHERE base_price <= 0;
SELECT COUNT(*) AS marketing_rows_with_negative_spend FROM marketing_costs WHERE spend < 0;

-- discount_amount μεγαλύτερο από το total_amount (αδύνατο σενάριο)
SELECT order_id, total_amount, discount_amount
FROM orders
WHERE discount_amount > total_amount;

-- discounts όπου valid_to είναι ΠΡΙΝ το valid_from (λογικό σφάλμα)
SELECT discount_code, valid_from, valid_to
FROM discounts
WHERE valid_to < valid_from;

-- bounced = TRUE αλλά με μεγάλη διάρκεια (αντιφατικό — bounce σημαίνει ~μηδενική παραμονή)
SELECT session_id, bounced, duration_s
FROM sessions
WHERE bounced = TRUE AND duration_s > 30;


-- =====================================================================
-- 10. ATTRIBUTION TIMING CONSISTENCY
-- =====================================================================
-- Για να έχει νόημα το multi-touch attribution, το ad exposure πρέπει
-- λογικά να προηγείται της session/order δραστηριότητας του χρήστη.
-- Εδώ εντοπίζουμε exposures που συμβαίνουν ΜΕΤΑ την πρώτη session
-- του χρήστη (πιθανό data quality θέμα ή θέμα ερμηνείας attribution window).

SELECT
    ae.user_id,
    ae.exposed_at,
    s.first_session_at,
    (ae.exposed_at > s.first_session_at) AS exposure_after_first_session
FROM ad_exposures ae
JOIN (
    SELECT user_id, MIN(created_at) AS first_session_at
    FROM sessions
    WHERE user_id IS NOT NULL
    GROUP BY user_id
) s ON ae.user_id = s.user_id
WHERE ae.exposed_at > s.first_session_at
ORDER BY ae.user_id;


-- =====================================================================
-- 11. MARKETING_COSTS COVERAGE
-- =====================================================================
-- Πριν υπολογίσεις CAC/ROAS ανά κανάλι/ημέρα, έλεγξε αν το marketing_costs
-- καλύπτει όλα τα κανάλια και όλο το εύρος ημερομηνιών που εμφανίζονται
-- στο sessions. Αν λείπουν μέρες/κανάλια, το CAC θα βγει λάθος.

-- Ημερομηνιακό εύρος: sessions vs marketing_costs
SELECT 'sessions'        AS source, MIN(created_at)::date AS min_date, MAX(created_at)::date AS max_date FROM sessions
UNION ALL
SELECT 'marketing_costs', MIN(date), MAX(date) FROM marketing_costs;

-- Κανάλια που εμφανίζονται σε sessions (utm_source) αλλά ΔΕΝ έχουν καθόλου
-- γραμμές στο marketing_costs (π.χ. organic/direct είναι αναμενόμενο να λείπουν,
-- αλλά αν λείπει π.χ. 'google', είναι πρόβλημα)
SELECT DISTINCT s.utm_source
FROM sessions s
LEFT JOIN marketing_costs mc ON s.utm_source = mc.channel
WHERE mc.channel IS NULL AND s.utm_source IS NOT NULL
ORDER BY 1;

-- Μέρες όπου ένα paid κανάλι έχει sessions αλλά καμία γραμμή spend εκείνη τη μέρα
SELECT DISTINCT s.utm_source AS channel, s.created_at::date AS activity_date
FROM sessions s
LEFT JOIN marketing_costs mc
       ON s.utm_source = mc.channel
      AND s.created_at::date = mc.date
WHERE s.utm_source IN ('google','facebook','instagram','email')
  AND mc.channel IS NULL
ORDER BY 1, 2;
