 A Data Analytics Project for an Online Pharmacy / Health & Wellness E-shop
 Where Do "High-Quality" Customers Come From?
 
 ---
 # Project Overview

An online pharmacy and health & wellness e-shop wants to understand which marketing channels attract the highest-quality customers, not just the most customers.

The central hypothesis is what acquisition channel predicts long-term customer behavior. A customer who arrives via organic search may behave very differently from one who arrives via a discount-driven paid social ad.

This project builds a full analytical pipeline: from raw transactional data → customer quality scoring → channel attribution → business recommendations.

 ---
 
 # Business Questions

 - What is a "High-Quality" Customer?

 Repurchase behavior: Does the customer come back for a 2nd, 3rd+ order? 
 Price sensitivity: Do they buy at full price or only when a discount is applied? 
 Time to repurchase: How quickly do they return after their first order? 
 Product category: Do they buy high-margin categories (vitamins, supplements) or low-margin (generics)? 
 Return/refund rate: Do they keep what they buy? 

 # What Do We Want to Know About Channels?

( Question -> Tables needed )

 Which channel brings the most repeat buyers? -> `sessions`, `orders`, `users` 
 Which channel has the largest average basket size? -> `sessions`, `orders`, `order_items` 
 Which channel drives full-price vs discount purchases? -> `orders`, `discounts` 
 Which channel has the highest bounce rate? -> `sessions` 
 How many ad exposures are needed before a first purchase? -> `ad_exposures` 
 What is the CAC and ROAS per channel? -> `marketing_costs`, `orders` 
 Which channel produces customers with the highest CLV? -> all tables 

 ---
 
 # Data Model

 Tables — Current
 
 users
├── user_id          PK
├── email
├── created_at
├── city
└── age_group

sessions
├── session_id       PK
├── user_id          FK → users
├── utm_source       (google / facebook / instagram / organic / email / direct)
├── utm_medium       (cpc / organic / social / email)
├── utm_campaign
├── bounced          BOOLEAN
├── duration_s
└── device

orders
├── order_id         PK
├── user_id          FK → users
├── session_id       FK → sessions 
├── total_amount
├── discount_amount
├── created_at
└── status

order_items
├── item_id          PK
├── order_id         FK → orders
├── product_id       FK → products
├── quantity
└── unit_price

products
├── product_id       PK
├── name
├── category         (vitamins / supplements / skincare / OTC / personal_care)
├── brand
├── base_price
└── margin_pct

marketing_costs
├── date
├── channel
├── campaign_id
├── spend
├── impressions
└── clicks

discounts  
├── discount_code    PK
├── type             (percentage / fixed)
├── value
├── valid_from
├── valid_to
└── channel          (which channel was the promo targeted at?)

ad_exposures  
├── exposure_id      PK
├── user_id          FK → users
├── channel
├── campaign_id
├── exposed_at
└── ad_format

returns  (optional but recommended)
├── return_id        PK
├── order_id         FK → orders
├── item_id          FK → order_items
├── reason
├── refund_amount
└── returned_at


customer_score  (output table)
├── user_id          FK → users
├── clv_score
├── quality_tier     (platinum / gold / silver / bronze)
├── first_channel
└── scored_at

 ---
 
 # 📊 Customer Quality Score

Each customer receives a composite score (0–100) based on the following dimensions:

| Dimension | Weight | How it's measured |

| Repeat purchase rate | 30% | Number of orders > 1 |
| Average order value | 20% | Mean `total_amount` across all orders |
| Full-price ratio | 20% | Orders with `discount_amount = 0` / total orders |
| Time to 2nd purchase | 15% | Days between order 1 and order 2 (lower = better) |
| Product margin score | 15% | Weighted average `margin_pct` of purchased products |

 # Customers are then segmented into tiers:

| Tier | Score | Description |

| Platinum | 80–100 | Loyal, full-price, high-margin buyers |
|  Gold | 60–79 | Repeat buyers with moderate discount sensitivity |
|  Silver | 40–59 | Occasional buyers, price-sensitive |
| Bronze | 0–39 | One-time, discount-only buyers |

 ---

 #  Analysis Plan

**Phase 1 — Data Validation** (`01_data_validation.sql`)
Explore each table independently before joining anything.
- [ ] Row counts per table
- [ ] NULL values per column
- [ ] Duplicate check
- [ ] Date range validation
- [ ] Foreign key completeness — especially `orders.session_id → sessions`
- [ ] UTM coverage: % of sessions with `utm_source` populated
- [ ] Check UTM coverage in `sessions` (% of sessions with utm_source populated)
- [ ] Identify null / unknown channel traffic
- [ ] Validate date ranges across all tables
