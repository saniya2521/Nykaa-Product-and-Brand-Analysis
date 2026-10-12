# Nykaa Product and Brand Analysis

## Project overview

This is a beginner-level data analytics project based on a Nykaa product-listing snapshot dated 16 October 2022. I used SQL to answer questions about brand ratings, listed prices, discounts and review counts, and Power BI to build an interactive dashboard for exploring the catalog.

The dataset contains product listings, not orders or transaction records. For that reason, this project analyses listed prices and review counts; it does not calculate actual sales, revenue, profit or customer purchases.

## Business questions

- Which brands have the highest average ratings among brands with enough rated listings?
- Which brands have the largest listed discount amounts and average discount percentages?
- Which listings have low ratings?
- Which listings are affordable and highly rated?
- How do prices and product counts vary across brands and price ranges?
- Which brands have the largest combined rating counts in this snapshot?
- What can be concluded from the recorded stock flags, and what data is missing?

## Tools used

- **MySQL** — filtering, grouping, aggregation, sorting, `CASE`, and correlated subqueries
- **Power BI Desktop** — KPI cards, charts, and interactive slicers
- **CSV / spreadsheet inspection** — basic data checks and validation
## Dataset

- **File:** `nyka_popular_brands_products_2022_10_16.csv`
- **Rows:** 3,663
- **Columns:** 14
- **Distinct brands:** 25
- **Distinct product IDs:** 3,662 (one ID is duplicated)
- **Snapshot date indicated by the filename:** 16 October 2022

Important columns:

| Column | Use in this project |
|---|---|
| `brand_name` | Brand name for a listing |
| `product_id` | Product/listing identifier |
| `product_title` | Product listing title |
| `mrp` | Listed maximum retail price |
| `price` | Listed selling price |
| `rating` | Rating recorded in the source |
| `rating_count` | Rating/review count recorded in the source |
| `in_stock` | Stock flag as captured in the source |
| `tags` | Listing tags; mostly missing |

## Data quality checks and limitations

- There are **3,663 rows but 3,662 distinct product IDs**. One ID appears more than once, so I distinguish listing-row counts from distinct product counts.
- `in_stock` has **300 missing values**. The other 3,363 rows have a recorded `True` flag; there are no explicit `False` values in the CSV. Missing values should not automatically be treated as out of stock. For this reason, stock availability should be presented with a clear limitation.
- `tags` is missing for **3,358 rows** (about 91.7%), so it is not suitable for strong conclusions without further data collection.
- There are **48 rows with rating = 0** and **48 rows with rating_count = 0**. A zero rating may indicate an unrated listing, so the average-rating SQL query excludes zero ratings.
- This is a single snapshot, not a time series. It cannot support month-over-month sales trends.
- `SUM(price)` by brand is **not sales revenue**. The dataset has no quantity sold or transaction data. In the SQL file, this is labelled as the total listed price across rows.
- `rating_count` is a listing-level count from the source. Summing it by brand is useful for comparing recorded review volume, but it does not represent sales or necessarily unique customers.

## Key findings from the CSV

These values were calculated from the supplied CSV and should be interpreted as product-listing findings, not sales results.

### Catalog and brands

- The dataset contains **3,663 listing rows across 25 brands**.
- The largest catalog counts are Nykaa Cosmetics (**812 rows**), Nykaa Naturals (**441**) and Biotique (**370**).
- These three brands account for **1,623 of 3,663 rows (44.3%)**. This is a share of listing rows; one product ID is duplicated.

### Prices and discounts

- Average listed selling price: **₹613.47**.
- Average MRP: **₹757.76**.
- Average discount calculated as `(mrp - price) / mrp`: **18.82%**.
- Median discount: **20.04%**.
- Price distribution by listing row:

| Price range | Listings | Share of rows |
|---|---:|---:|
| ≤ ₹250 | 1,060 | 28.94% |
| ₹251–₹500 | 970 | 26.48% |
| ₹501–₹1,000 | 1,047 | 28.58% |
| ₹1,001–₹2,000 | 457 | 12.48% |
| > ₹2,000 | 129 | 3.52% |

- **3,077 of 3,663 listing rows (84.0%) have a listed price of ₹1,000 or below.** This describes the catalog's price mix; it does not prove what customers purchase.

### Ratings and reviews

- Average rating excluding zero-rated rows: **4.34 / 5**.
- Sum of `rating_count` across rows: **26,518,818**.
- Nykaa Cosmetics has the largest summed rating count in this dataset (**14,644,460**), followed by Nykaa Naturals (**3,894,393**) and Biotique (**1,913,039**).
- These are review/rating counts captured in the listing snapshot, not sales counts.

### Stock flag

- **3,363 rows** have `in_stock = True`; **300 rows** have a missing stock value.
- Since the file contains no explicit `False` values, I do not interpret missing stock values as out of stock or claim that 91.81% of all products are definitely available.

## SQL analysis

1. Top 5 brands by average rating, excluding zero ratings and requiring at least 50 rated listings (the threshold is applied after zero-rated rows are excluded).
2. Top 5 brands by total listed discount amount and average discount percentage.
3. Ten lowest-rated listings with a rating below 3.
4. Five affordable listings priced below ₹500 with ratings of at least 4.5.
5. Lowest-rated non-zero-rated listing(s) within each brand.
6. Brands with the largest sum of listed selling prices not revenue.
7. Average listed selling price by brand.
8. Highest-priced listings by brand.
9. Listing counts by price range.
10. Top 10 brands by summed rating count.
11. Stock-flag quality check, keeping missing values separate.

## Power BI dashboard

The dashboard is a single-page overview with KPI cards, brand comparisons, price distribution, rating/review analysis, stock-flag analysis, and slicers. During testing, selecting a brand changed the KPI cards and charts, confirming that the tested slicer interactions worked.

### Suggested KPI definitions

- **Total Listings:** count of rows (3,663), or **Distinct Products:** distinct count of `product_id` (3,662). Label the card to make the choice clear.
- **Total Brands:** distinct count of `brand_name` (25).
- **Average Selling Price:** average of `price` (₹613.47).
- **Average Discount %:** average of `(mrp - price) / mrp` (18.82%), formatted as a percentage.
- **Average Rating:** average of `rating` excluding zeros (4.34/5).
- **Stock flag recorded as True:** 3,363 rows, with a note that 300 rows have missing stock values. Do not present this as a fully validated in-stock versus out-of-stock split.

## Conclusion

This project gave me practice with SQL filtering, aggregation, sorting, conditional grouping and subqueries, and with building a Power BI dashboard using KPI cards, charts and interactive slicers. The main pattern in this snapshot is that most listings are priced at ₹1,000 or below, while recorded rating counts are concentrated among a few brands. These findings describe the product catalog and engagement indicators, not actual sales performance.
