


DROP TABLE IF EXISTS ad_exposures;
DROP TABLE IF EXISTS discounts;
DROP TABLE IF EXISTS marketing_costs;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id     INTEGER,
    email       TEXT,
    created_at  TIMESTAMP,
    city        TEXT,
    age_group   TEXT
);

CREATE TABLE sessions (
    session_id   INTEGER,
    user_id      INTEGER,
    utm_source   TEXT,
    utm_medium   TEXT,
    utm_campaign TEXT,
    bounced      BOOLEAN,
    duration_s   INTEGER,
    device       TEXT
);

CREATE TABLE orders (
    order_id         INTEGER,
    user_id          INTEGER,
    session_id       INTEGER,
    total_amount     NUMERIC(10,2),
    discount_amount  NUMERIC(10,2),
    created_at       TIMESTAMP,
    status           TEXT
);

CREATE TABLE order_items (
    item_id     INTEGER,
    order_id    INTEGER,
    product_id  INTEGER,
    quantity    INTEGER,
    unit_price  NUMERIC(10,2)
);

CREATE TABLE products (
    product_id  INTEGER,
    name        TEXT,
    category    TEXT,
    brand       TEXT,
    base_price  NUMERIC(10,2),
    margin_pct  NUMERIC(5,2)
);

CREATE TABLE marketing_costs (
    date         DATE,
    channel      TEXT,
    campaign_id  TEXT,
    spend        NUMERIC(10,2),
    impressions  INTEGER,
    clicks       INTEGER
);

CREATE TABLE discounts (
    discount_code  TEXT,
    type           TEXT,
    value          NUMERIC(10,2),
    valid_from     DATE,
    valid_to       DATE,
    channel        TEXT
);

CREATE TABLE ad_exposures (
    exposure_id  INTEGER,
    user_id      INTEGER,
    channel      TEXT,
    campaign_id  TEXT,
    exposed_at   TIMESTAMP,
    ad_format    TEXT
);
