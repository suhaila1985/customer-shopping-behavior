# 🛍️ Customer Shopping Behavior — End-to-End Data Analytics Project

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

---

## 📌 Project Overview

This end-to-end data analytics project explores **customer shopping behavior** across 3,900 customers using a full data pipeline — from raw CSV ingestion, Python-based data cleaning, SQL exploratory data analysis (EDA), and an interactive Power BI dashboard.

The goal is to uncover actionable insights around **revenue drivers, customer demographics, product performance, loyalty patterns, and payment/shipping preferences**.

---

## 🎯 Business Objectives

| # | Objective |
|---|-----------|
| 1 | Identify top revenue-generating categories and seasons |
| 2 | Understand customer demographics (age, gender, location) |
| 3 | Analyse subscription vs. non-subscription purchase behaviour |
| 4 | Evaluate the impact of discounts and promo codes |
| 5 | Profile loyal, high-value customer segments |
| 6 | Assess review ratings across products and categories |
| 7 | Understand payment method and shipping type preferences |

---

## 🗂️ Project Structure

```
customer-shopping-behavior/
│
├── data/
│   ├── customer_shopping_behavior.csv     # Raw dataset
│   └── shopping_data_clean.csv            # Cleaned dataset (output)
│
├── scripts/
│   ├── clean_shopping_data.py             # Data cleaning pipeline
│   └── load_to_postgres.py                # PostgreSQL ingestion script
│
├── sql/
│   └── eda_queries.sql                    # Full SQL EDA (7 sections, 25+ queries)
│
├── reports/
│   ├── Customer_Shopping_Behavior.pbix    # Power BI dashboard file
│   └── Project_Report.docx               # Full project report
│
├── assets/
│   └── dashboard_preview.png             # Dashboard screenshot
│
├── requirements.txt                       # Python dependencies
└── README.md                              # This file
```

---

## 🔧 Tech Stack

| Layer | Tool |
|-------|------|
| Language | Python 3.10+ |
| Data Wrangling | Pandas, NumPy |
| Database | PostgreSQL 15 (via pgAdmin 4) |
| ORM / Connector | SQLAlchemy + psycopg2 |
| EDA | SQL (PostgreSQL dialect) |
| Visualisation | Microsoft Power BI Desktop |
| IDE | VS Code / Jupyter |

---

## 📊 Dataset Description

| Column | Type | Description |
|--------|------|-------------|
| `customer_id` | Integer | Unique customer identifier |
| `age` | Integer | Customer age (18–70) |
| `gender` | String | Male / Female |
| `item` | String | Item purchased |
| `category` | String | Clothing, Accessories, Footwear, Outerwear |
| `purchase_amount` | Float | Purchase value in USD |
| `location` | String | US State |
| `size` | String | S / M / L / XL |
| `color` | String | Product color |
| `season` | String | Spring / Summer / Fall / Winter |
| `review_rating` | Float | Rating 1.0–5.0 |
| `subscription` | String | Yes / No |
| `shipping_type` | String | Free / Standard / Express etc. |
| `discount_applied` | String | Yes / No |
| `promo_code_used` | String | Yes / No |
| `previous_purchases` | Integer | Number of past purchases |
| `payment_method` | String | Credit Card / PayPal / Cash etc. |
| `purchase_frequency` | String | Weekly / Monthly / Quarterly / Annually |

**Derived Columns (added in cleaning):**

| Column | Description |
|--------|-------------|
| `age_group` | Binned age: 18-25, 26-35, 36-45, 46-55, 56-65, 66+ |
| `spend_tier` | Low (<$40), Mid ($40–$70), High (>$70) |
| `is_loyal` | Subscribed customers with >25 previous purchases |

---

## ⚙️ Setup & Reproduction

### 1. Clone the Repository

```bash
git clone https://github.com/suhaila1985/customer-shopping-behavior.git
cd customer-shopping-behavior
```

### 2. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 3. Run the Data Cleaning Pipeline

```bash
python scripts/clean_shopping_data.py
```

This will:
- Strip BOM characters from the raw CSV
- Rename columns to snake_case
- Fix data types
- Fill 37 missing `review_rating` values with the median
- Clip values to valid ranges
- Remove duplicates
- Add derived columns (`age_group`, `spend_tier`, `is_loyal`)
- Output `shopping_data_clean.csv`

### 4. Load Data into PostgreSQL

Update credentials in `scripts/load_to_postgres.py`, then:

```bash
python scripts/load_to_postgres.py
```

### 5. Run SQL EDA

Open `sql/eda_queries.sql` in pgAdmin 4 or any PostgreSQL client and run the sections as needed.

### 6. Open Power BI Dashboard

Open `reports/Customer_Shopping_Behavior.pbix` in Power BI Desktop. Update the data source to point to your PostgreSQL instance or the cleaned CSV.

---

## 📈 Key Insights

### Revenue & Category
- **Clothing** is the top revenue category at **$104K (44%)** of total revenue
- Revenue is remarkably balanced across all four seasons (~25% each), indicating no dangerous seasonal dependency

### Demographics
- **68% Male** vs 32% Female — a significant gender skew worth investigating for growth opportunities
- Core customer age group is **36–55**, with very limited under-25 engagement

### Products
- Top items (Blouse, Jewelry, Pants, Shirt, Dress) are tightly clustered at **163–171 purchases** — broad demand with no single hero product
- **Outerwear** underperforms even in Winter, signalling a merchandising gap

### Loyalty & Subscriptions
- Non-subscribers generate **$170K** vs $63K for subscribers — driven by sheer volume difference
- Loyal segment (subscribed + >25 purchases) shows higher average order values

### Discounts & Promos
- Promo code and discount usage analysis reveals their net impact on average order value vs. revenue volume

### Ratings
- Average review rating of **3.75/5** — moderate; specific low-rated items identified in EDA (Query 6.3)

---

## 🗃️ SQL EDA Sections

| Section | Queries |
|---------|---------|
| 1. Overview KPIs | Total customers, avg spend, revenue, ratings, subscription rate |
| 2. Demographics | Gender split, age groups, top states by revenue |
| 3. Product & Category | Best-selling items, category × season, size/color breakdown |
| 4. Purchase Behaviour & Loyalty | Subscription impact, discount/promo analysis, frequency, loyal segment |
| 5. Payment & Shipping | Payment method split, shipping preferences by category |
| 6. Review Ratings | Rating distribution, avg rating by category/season, low-rated items |
| 7. Advanced / Cohort | High-value customers, spend tier revenue contribution, season trends |

---

## 📉 Dashboard Visuals

| Visual | Description |
|--------|-------------|
| KPI Cards | Total customers, avg order value, avg review rating |
| Donut Chart | Revenue by category |
| Donut Chart | Revenue by season |
| Bar Chart | Age group vs avg spend |
| Pie Chart | Gender split |
| Bar Chart | Top selling items |
| Bar Chart | Subscription vs non-subscription spend |
| Bar Chart | Customer age distribution |
| Clustered Bar | Purchase frequency distribution |
| Matrix/Heatmap | Category × Season revenue |
| Bar Chart | Order count by shipping type |

---

## 🚧 Data Cleaning Summary

| Step | Action | Result |
|------|--------|--------|
| BOM fix | `utf-8-sig` encoding | Clean headers |
| Column rename | snake_case normalisation | Consistent naming |
| Type casting | Int64, Float, String | Correct dtypes |
| Text standardisation | `.strip().title()` | Uniform values |
| Missing values | Median fill for `review_rating` | 37 rows fixed |
| Range clipping | Age 18–100, Amount 0–10K, Rating 1–5 | No outliers |
| Deduplication | `customer_id` unique | 0 duplicates |
| Derived columns | `age_group`, `spend_tier`, `is_loyal` | Richer analysis |

---

## 🔮 Recommendations

1. **Female customer acquisition** — 68/32 gender split is a major growth lever
2. **Subscriber incentives** — Ensure subscribers outspend non-subscribers per capita
3. **Outerwear strategy** — Weakest category even in Winter; review product range and marketing
4. **Youth engagement** — Under-25 segment is very thin; targeted digital campaigns could help
5. **Rating improvement** — 3.75 average is mediocre; investigate and address low-rated items

---

## 👤 Author

**Fathima Suhaila**
- 📧 [wcc0207@gmail.com]
- 💼 [www.linkedin.com/in/fathimasuhaila198]
- 🐙 [https://github.com/suhaila1985/customer_shopping_behavior]

---

## 📄 License

This project is for educational and portfolio purposes. Dataset used is publicly available via Kaggle.
