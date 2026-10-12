-- Nykaa Product and Brand Analysis
-- Dataset: Nykaa product listings (16 October 2022)

USE nykaa;

-- Check the data
SELECT *
FROM nyka_popular_brands_products_2022_10_16;

-- 1. Top 5 brands by average rating (at least 50 products)
SELECT
    brand_name,
    ROUND(AVG(rating), 2) AS Avg_Rating,
    COUNT(*) AS Product_Count
FROM nyka_popular_brands_products_2022_10_16
WHERE rating > 0
GROUP BY brand_name
HAVING COUNT(*) >= 50
ORDER BY Avg_Rating DESC
LIMIT 5;

-- 2. Top 5 brands by total discount amount
SELECT
    brand_name,
    SUM(mrp - price) AS Total_Discount,
    ROUND(AVG((mrp - price) / NULLIF(mrp, 0)) * 100, 2) AS Avg_Discount_Percent
FROM nyka_popular_brands_products_2022_10_16
WHERE mrp > 0 AND price IS NOT NULL
GROUP BY brand_name
ORDER BY Total_Discount DESC
LIMIT 5;

-- 3. Products with a rating below 3
SELECT
    brand_name,
    product_title,
    rating,
    price
FROM nyka_popular_brands_products_2022_10_16
WHERE rating > 0 AND rating < 3
ORDER BY rating ASC
LIMIT 10;

-- 4. Affordable products with high ratings
SELECT
    brand_name,
    product_title,
    price,
    rating
FROM nyka_popular_brands_products_2022_10_16
WHERE price < 500 AND rating >= 4.5
ORDER BY rating DESC, price ASC
LIMIT 5;

-- 5. Lowest rated product(s) in each brand
SELECT
    t.brand_name,
    t.product_title,
    t.rating,
    t.price
FROM nyka_popular_brands_products_2022_10_16 AS t
WHERE t.rating > 0
  AND t.rating = (
      SELECT MIN(s.rating)
      FROM nyka_popular_brands_products_2022_10_16 AS s
      WHERE s.brand_name = t.brand_name
        AND s.rating > 0
  )
ORDER BY t.brand_name;

-- 6. Top 5 brands by the sum of their listed prices
-- This is not actual sales revenue because the dataset has no sales data.
SELECT
    brand_name,
    SUM(price) AS Sum_Of_Listed_Prices
FROM nyka_popular_brands_products_2022_10_16
GROUP BY brand_name
ORDER BY Sum_Of_Listed_Prices DESC
LIMIT 5;

-- 7. Average price for each brand
SELECT
    brand_name,
    ROUND(AVG(price), 2) AS Avg_Price,
    COUNT(*) AS Product_Count
FROM nyka_popular_brands_products_2022_10_16
GROUP BY brand_name
ORDER BY Avg_Price DESC;

-- 8. Highest priced product for each brand
SELECT
    t.brand_name,
    t.product_title,
    t.price AS Highest_Price
FROM nyka_popular_brands_products_2022_10_16 AS t
WHERE t.price = (
    SELECT MAX(s.price)
    FROM nyka_popular_brands_products_2022_10_16 AS s
    WHERE s.brand_name = t.brand_name
)
ORDER BY Highest_Price DESC;

-- 9. Count of products in each price range (used for the dashboard)
SELECT
    CASE
        WHEN price <= 250 THEN '01. <= 250'
        WHEN price <= 500 THEN '02. 251-500'
        WHEN price <= 1000 THEN '03. 501-1000'
        WHEN price <= 2000 THEN '04. 1001-2000'
        ELSE '05. > 2000'
    END AS Price_Range,
    COUNT(*) AS Product_Count
FROM nyka_popular_brands_products_2022_10_16
WHERE price IS NOT NULL
GROUP BY Price_Range
ORDER BY Price_Range;

-- 10. Top 10 brands by total review count
SELECT
    brand_name,
    SUM(rating_count) AS Total_Reviews,
    COUNT(*) AS Product_Count
FROM nyka_popular_brands_products_2022_10_16
GROUP BY brand_name
ORDER BY Total_Reviews DESC
LIMIT 10;

-- 11. Check stock status values
SELECT
    in_stock,
    COUNT(*) AS Product_Count
FROM nyka_popular_brands_products_2022_10_16
GROUP BY in_stock;

-- End of the Analysis.