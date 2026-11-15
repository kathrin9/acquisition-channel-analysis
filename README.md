# Customer Quality Analysis in Health & Wellness E-commerce

### Who Are Loyal Customers, What Characterizes Them, and Where Do They Come From?

## 1. Project Overview

An online pharmacy and health & wellness e-shop wants to understand **who its most loyal customers are, what purchasing behaviors characterize them, and which marketing channels attract them.**

Not all customers contribute equally to a business. Some make only one purchase, while others return regularly, purchase frequently, and develop a long-term relationship with the e-shop.

This project focuses on **customer loyalty as the primary indicator of customer quality**, while also exploring spending behavior, discount dependency, and product preferences.

The analysis aims to answer three main questions:

1. **Who are high-quality (loyal) customers?**
2. **What purchasing characteristics distinguish them from other customers?**
3. **Which marketing channels attract the highest number and proportion of loyal customers?**

The final objective is to provide data-driven insights that can help the business improve customer acquisition and retention strategies.

---

## 2. Defining a High-Quality Customer

In this project, a high-quality customer is primarily defined as **a customer who returns and makes purchases consistently over time.**

Customer quality is therefore evaluated mainly through repeat purchasing behavior and purchase frequency, rather than simply through the amount spent on a single order.

### Key Customer Quality Indicators

| Metric | What It Measures |
|---|---|
| Repeat Purchase | Whether a customer returns for additional purchases |
| Purchase Frequency | How frequently a customer places orders within a defined period |
| Time to Second Purchase | How quickly a customer returns after their first purchase |
| Average Order Value (AOV) | Average amount spent per order |
| Discount Dependency | How strongly a customer relies on discounts |

Repeat purchasing behavior and purchase frequency will have the greatest importance when evaluating customer loyalty.

Additional metrics, such as customer lifetime revenue and product category preferences, will be used to understand customer characteristics.

**Important:** Customer quality criteria and scoring thresholds will be finalized after exploring the data to ensure a consistent and meaningful classification.

---

## 3. Customer Profiling: What Characterizes Loyal Customers?

After identifying loyal customers, the next step is to understand their purchasing behavior and how they differ from other customer segments.

### Research Questions

- How frequently do loyal customers make purchases?
- What is their average order value?
- How quickly do they return for a second purchase?
- Are they less dependent on discounts?
- Which product categories do they prefer?
- Do they generate higher customer lifetime revenue?
- Are there differences in demographic characteristics, such as age group or city?

### Expected Outcome

Develop a clear behavioral profile of loyal customers and identify the characteristics that distinguish them from occasional or one-time buyers.

---

## 4. Acquisition Channel Analysis: Where Do Loyal Customers Come From?

The next step is to investigate which marketing channels attract customers who demonstrate stronger loyalty.

### Marketing Channels

- Paid Search
- Organic Search
- Social Media
- Email Marketing

### Research Questions

- Which channel attracts the highest number of loyal customers?
- Which channel has the highest percentage of loyal customers among its acquired customers?
- Do customers from certain channels make repeat purchases more frequently?
- Which channels attract customers with higher purchase frequency?
- How does average order value differ across channels?
- Are customers from certain channels more dependent on discounts?
- Which channels generate the highest customer lifetime revenue?

### Expected Outcome

Identify which acquisition channels are associated with stronger customer loyalty and higher repeat purchasing behavior.

The analysis will distinguish between channels that attract **more customers** and channels that attract **more loyal customers**.

---

## 5. Data Model

The project uses transactional, customer, product, and session-level data to analyze customer loyalty and acquisition channels.

### Core Tables

| Table | Description |
|---|---|
| `users` | Customer information, including registration date, age group, and city |
| `sessions` | Website sessions, traffic sources, and marketing channel information |
| `orders` | Customer purchases, order values, discounts, and order dates |
| `order_items` | Products and quantities included in each order |
| `products` | Product information, categories, prices, and margins |

### Additional Tables

The database also includes:

- `marketing_costs` — Marketing expenditure by channel and campaign
- `discounts` — Promotional discounts and campaign information
- `ad_exposures` — Customer advertising exposure history
- `returns` — Returned products and refunds (optional)

These tables may support future extensions but are not essential to the primary customer loyalty analysis.

### Derived Table: `customer_score`

This table will store the results of customer loyalty scoring and segmentation.

| Column | Description |
|---|---|
| `user_id` | Unique customer identifier |
| `quality_score` | Calculated customer quality score (0–100) |
| `quality_tier` | Customer loyalty segment |
| `first_channel` | First recorded acquisition channel |
| `scored_at` | Scoring date |

---

## 6. Customer Quality Scoring & Segmentation

The project will develop a **Customer Quality Score (0–100)** to classify customers based primarily on their loyalty.

### Proposed Scoring Framework

| Dimension | Initial Weight |
|---|---:|
| Repeat Purchase / Retention | 35% |
| Purchase Frequency | 30% |
| Time to Second Purchase | 15% |
| Average Order Value | 10% |
| Discount Dependency | 10% |
| **Total** | **100%** |

These weights are preliminary and will be reviewed after data exploration.

Scoring will account for the available observation period so that customers with different lengths of purchase history can be compared fairly. Overlapping loyalty indicators will also be evaluated to avoid double-counting similar behavior.

### Customer Segments

| Tier | Proposed Score | Description |
|---|---|---|
| Platinum | 80–100 | Highly loyal customers with consistent repeat purchasing behavior |
| Gold | 60–79 | Customers demonstrating strong repeat purchase behavior |
| Silver | 40–59 | Occasional repeat customers |
| Bronze | 0–39 | Customers with limited observed repeat purchasing activity |

Final scoring rules and thresholds will be documented after analyzing customer behavior and the distribution of calculated scores.

---

## 7. Analysis Plan

### Phase 0 — Database Setup (`00_schema.sql`)

Prepare the database and import the source data.

- Create the required database tables.
- Import CSV files.
- Verify imported row counts.
- Review table structures and relationships.

### Phase 1 — Data Exploration & Validation (`01_data_validation.sql`)

Explore and validate the data before performing customer-level analysis.

- Row counts per table
- NULL values and duplicate records
- Date range validation
- Foreign key completeness
- Order status validation
- Missing acquisition channel information
- Invalid or inconsistent values

**Goal:** Ensure the data is reliable for customer loyalty and acquisition channel analysis.

### Phase 2 — Customer Behavior Analysis (`02_customer_behavior.sql`)

Calculate customer-level purchasing metrics.

- Total number of orders per customer
- Repeat purchase indicator
- Purchase frequency
- Average Order Value
- Total customer revenue
- Time to second purchase
- Discount dependency

Only valid purchases will be included, based on documented order status rules.

Purchase frequency will be evaluated using a consistent observation period, and customers with insufficient follow-up time will be handled separately where necessary.

**Goal:** Understand customer purchasing behavior before defining loyalty segments.

### Phase 3 — Customer Quality Scoring (`03_customer_scoring.sql`)

Develop the customer quality classification.

- Explore the distribution of customer metrics.
- Define scoring criteria and normalization methods.
- Calculate customer quality scores.
- Assign customers to loyalty segments.
- Examine the distribution of customers across segments.

**Goal:** Identify high-quality customers primarily based on repeat purchasing behavior and purchase frequency.

### Phase 4 — Loyal Customer Profiling (`04_customer_profiling.sql`)

Analyze the characteristics of loyal customers.

- Average Order Value by customer segment
- Product category preferences
- Discount dependency
- Customer lifetime revenue during the observation period
- Demographic characteristics
- Differences between loyal and occasional customers

Metrics already used to define the loyalty score will be treated as classification criteria rather than independent findings.

**Goal:** Build a clear profile of loyal customers and understand their additional purchasing characteristics.

### Phase 5 — Acquisition Channel Analysis (`05_channel_analysis.sql`)

Connect customer loyalty segments with acquisition channels.

The primary attribution approach will use each customer's **first recorded marketing channel**, based on available session data.

- Number of customers acquired per channel
- Number of loyal customers per channel
- Percentage of loyal customers per channel
- Average customer quality score per channel
- Repeat purchase rate by channel
- Purchase frequency by channel
- Average Order Value by channel
- Customer revenue by channel

Missing or unknown acquisition sources will be identified and reported separately.

**Goal:** Determine which marketing channels attract customers with stronger loyalty and repeat purchasing behavior.

### Phase 6 — Dashboard & Business Recommendations

Create a dashboard to communicate the key findings.

**Customer Loyalty Overview**

- Total customers
- Repeat Purchase Rate
- Customer quality segment distribution
- Purchase frequency

**Loyal Customer Profile**

- Average Order Value
- Discount dependency
- Product category preferences
- Customer revenue

**Acquisition Channel Performance**

- Customers acquired per channel
- Loyal customers per channel
- Percentage of loyal customers per channel
- Average quality score by channel
- Repeat purchase rate by channel

### Business Recommendations

Based on the findings, the project will aim to:

- Identify marketing channels associated with higher customer loyalty.
- Highlight channels with high acquisition volume but low repeat purchasing behavior.
- Understand the purchasing characteristics of loyal customers.
- Suggest opportunities to improve customer retention.
- Support more targeted customer acquisition strategies.

---

## 8. Expected Insights

By the end of the analysis, the project aims to answer:

1. What percentage of customers demonstrate strong loyalty?
2. What purchasing behaviors characterize loyal customers?
3. Which product categories are most popular among loyal customers?
4. Which marketing channel attracts the highest number of loyal customers?
5. Which channel has the highest proportion of loyal customers?
6. Do channels with higher customer acquisition volume also attract more loyal customers?

The key business question is:

**Which marketing channels bring customers who return, purchase frequently, and develop long-term relationships with the business?**

---

## 9. Tools & Technologies

- **SQL:** Data validation, customer-level aggregations, loyalty metrics, and channel analysis.
- **Python:** Exploratory data analysis, customer segmentation, and behavioral profiling.
- **Power BI:** Interactive dashboards for customer loyalty and acquisition channel performance.

---

## 10. Project Status

**In Progress**

Current focus: Database setup, data validation, and customer behavior analysis.

Customer scoring, channel comparisons, dashboards, and business recommendations will be developed as the project progresses.
