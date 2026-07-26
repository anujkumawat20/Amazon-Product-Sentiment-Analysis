-- Project      : Amazon Product Sentiment Analysis
-- File         : business_queries.sql
-- Database     : amazon_sentiment_db
-- Table        : reviews
-- Description  : Business analysis queries built on top of an NLP +
--                sentiment-labeled Amazon reviews dataset. Covers
--                basic, aggregate, product, user, sentiment, time-based,
--                advanced SQL, and interview-level analytical queries.
-- Author       : Anuj Kumawat

USE sentiment_analysis_db;

-- SECTION 1 : BASIC QUERIES

-- Q1: View all records (sample view, limited for readability)
SELECT *
FROM reviews
LIMIT 100;

-- Q2: Total number of reviews
SELECT COUNT(*) AS Total_Reviews
FROM reviews;

-- Q3: Total number of unique products
SELECT COUNT(DISTINCT ProductId) AS Total_Products
FROM reviews;

-- Q4: Total number of unique users
SELECT COUNT(DISTINCT UserId) AS Total_Users
FROM reviews;

-- Q5: Average rating across all reviews
SELECT ROUND(AVG(Rating), 2) AS Average_Rating
FROM reviews;

-- Q6: Minimum and maximum rating given
SELECT MIN(Rating) AS Min_Rating,
       MAX(Rating) AS Max_Rating
FROM reviews;

-- Q7: Distinct sentiment categories present in the dataset
SELECT DISTINCT Sentiment
FROM reviews;

-- Q8: Distinct years covered by the dataset
SELECT DISTINCT Year
FROM reviews
ORDER BY Year;

-- Q9: Average review length (in characters/words as stored)
SELECT ROUND(AVG(Review_Length), 2) AS Average_Review_Length
FROM reviews;

-- Q10: Average helpfulness ratio across all reviews
SELECT ROUND(AVG(Helpfulness_Ratio), 2) AS Average_Helpfulness_Ratio
FROM reviews;


-- SECTION 2 : AGGREGATE ANALYSIS

-- Q11: Count of reviews grouped by rating
SELECT Rating,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Rating
ORDER BY Rating;

-- Q12: Count of reviews grouped by sentiment
SELECT Sentiment,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Sentiment
ORDER BY Review_Count DESC;

-- Q13: Count of reviews grouped by year
SELECT Year,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Year
ORDER BY Year;

-- Q14: Count of reviews grouped by month
SELECT Month,
       Month_No,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Month, Month_No
ORDER BY Month_No;

-- Q15: Average rating grouped by year
SELECT Year,
       ROUND(AVG(Rating), 2) AS Average_Rating
FROM reviews
GROUP BY Year
ORDER BY Year;

-- Q16: Average rating grouped by month
SELECT Month,
       Month_No,
       ROUND(AVG(Rating), 2) AS Average_Rating
FROM reviews
GROUP BY Month, Month_No
ORDER BY Month_No;

-- Q17: Average helpfulness ratio grouped by sentiment
SELECT Sentiment,
       ROUND(AVG(Helpfulness_Ratio), 2) AS Average_Helpfulness_Ratio
FROM reviews
GROUP BY Sentiment
ORDER BY Average_Helpfulness_Ratio DESC;

-- Q18: Average review length grouped by sentiment
SELECT Sentiment,
       ROUND(AVG(Review_Length), 2) AS Average_Review_Length
FROM reviews
GROUP BY Sentiment
ORDER BY Average_Review_Length DESC;

-- Q19: Number of distinct products reviewed per year
SELECT Year,
       COUNT(DISTINCT ProductId) AS Product_Count
FROM reviews
GROUP BY Year
ORDER BY Year;

-- Q20: Number of distinct users active per year
SELECT Year,
       COUNT(DISTINCT UserId) AS User_Count
FROM reviews
GROUP BY Year
ORDER BY Year;


-- SECTION 3 : PRODUCT ANALYSIS

-- Q21: Top 10 most reviewed products
SELECT ProductId,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY ProductId
ORDER BY Review_Count DESC
LIMIT 10;

-- Q22: Bottom 10 least reviewed products
SELECT ProductId,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY ProductId
ORDER BY Review_Count ASC
LIMIT 10;

-- Q23: Top 10 highest rated products (minimum 10 reviews for reliability)
SELECT ProductId,
       ROUND(AVG(Rating), 2) AS Average_Rating,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY ProductId
HAVING COUNT(*) >= 10
ORDER BY Average_Rating DESC
LIMIT 10;

-- Q24: Top 10 lowest rated products (minimum 10 reviews for reliability)
SELECT ProductId,
       ROUND(AVG(Rating), 2) AS Average_Rating,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY ProductId
HAVING COUNT(*) >= 10
ORDER BY Average_Rating ASC
LIMIT 10;

-- Q25: Products with the highest average helpfulness ratio
SELECT ProductId,
       ROUND(AVG(Helpfulness_Ratio), 2) AS Average_Helpfulness_Ratio,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY ProductId
HAVING COUNT(*) >= 10
ORDER BY Average_Helpfulness_Ratio DESC
LIMIT 10;

-- Q26: Products with the most positive reviews
SELECT ProductId,
       COUNT(*) AS Positive_Review_Count
FROM reviews
WHERE Sentiment = 'Positive'
GROUP BY ProductId
ORDER BY Positive_Review_Count DESC
LIMIT 10;

-- Q27: Products with the most negative reviews
SELECT ProductId,
       COUNT(*) AS Negative_Review_Count
FROM reviews
WHERE Sentiment = 'Negative'
GROUP BY ProductId
ORDER BY Negative_Review_Count DESC
LIMIT 10;

-- Q28: Products with the most neutral reviews
SELECT ProductId,
       COUNT(*) AS Neutral_Review_Count
FROM reviews
WHERE Sentiment = 'Neutral'
GROUP BY ProductId
ORDER BY Neutral_Review_Count DESC
LIMIT 10;

-- Q29: Sentiment distribution per product (count of each sentiment type)
SELECT ProductId,
       SUM(CASE WHEN Sentiment = 'Positive' THEN 1 ELSE 0 END) AS Positive_Count,
       SUM(CASE WHEN Sentiment = 'Negative' THEN 1 ELSE 0 END) AS Negative_Count,
       SUM(CASE WHEN Sentiment = 'Neutral' THEN 1 ELSE 0 END) AS Neutral_Count,
       COUNT(*) AS Total_Reviews
FROM reviews
GROUP BY ProductId
ORDER BY Total_Reviews DESC
LIMIT 20;

-- Q30: Average rating per product (full listing, ordered by rating)
SELECT ProductId,
       ROUND(AVG(Rating), 2) AS Average_Rating,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY ProductId
ORDER BY Average_Rating DESC;


-- SECTION 4 : USER ANALYSIS

-- Q31: Top 10 most active users by review count
SELECT UserId,
       ProfileName,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY UserId, ProfileName
ORDER BY Review_Count DESC
LIMIT 10;

-- Q32: Users giving the most positive reviews
SELECT UserId,
       ProfileName,
       COUNT(*) AS Positive_Review_Count
FROM reviews
WHERE Sentiment = 'Positive'
GROUP BY UserId, ProfileName
ORDER BY Positive_Review_Count DESC
LIMIT 10;

-- Q33: Users giving the most negative reviews
SELECT UserId,
       ProfileName,
       COUNT(*) AS Negative_Review_Count
FROM reviews
WHERE Sentiment = 'Negative'
GROUP BY UserId, ProfileName
ORDER BY Negative_Review_Count DESC
LIMIT 10;

-- Q34: Users giving the most neutral reviews
SELECT UserId,
       ProfileName,
       COUNT(*) AS Neutral_Review_Count
FROM reviews
WHERE Sentiment = 'Neutral'
GROUP BY UserId, ProfileName
ORDER BY Neutral_Review_Count DESC
LIMIT 10;

-- Q35: Average rating given per user (top 10 by review volume)
SELECT UserId,
       ProfileName,
       ROUND(AVG(Rating), 2) AS Average_Rating,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY UserId, ProfileName
ORDER BY Review_Count DESC
LIMIT 10;

-- Q36: Average review length per user (top 10 by review volume)
SELECT UserId,
       ProfileName,
       ROUND(AVG(Review_Length), 2) AS Average_Review_Length,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY UserId, ProfileName
ORDER BY Review_Count DESC
LIMIT 10;

-- Q37: Most helpful reviewers (highest average helpfulness ratio)
SELECT UserId,
       ProfileName,
       ROUND(AVG(Helpfulness_Ratio), 2) AS Average_Helpfulness_Ratio,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY UserId, ProfileName
HAVING COUNT(*) >= 5
ORDER BY Average_Helpfulness_Ratio DESC
LIMIT 10;

-- SECTION 5 : SENTIMENT ANALYSIS

-- Q38: Percentage of positive reviews
SELECT ROUND(
         (SUM(CASE WHEN Sentiment = 'Positive' THEN 1 ELSE 0 END) * 100.0)
         / COUNT(*), 2
       ) AS Positive_Review_Percentage
FROM reviews;

-- Q39: Percentage of negative reviews
SELECT ROUND(
         (SUM(CASE WHEN Sentiment = 'Negative' THEN 1 ELSE 0 END) * 100.0)
         / COUNT(*), 2
       ) AS Negative_Review_Percentage
FROM reviews;

-- Q40: Percentage of neutral reviews
SELECT ROUND(
         (SUM(CASE WHEN Sentiment = 'Neutral' THEN 1 ELSE 0 END) * 100.0)
         / COUNT(*), 2
       ) AS Neutral_Review_Percentage
FROM reviews;

-- Q41: Overall sentiment distribution (count and percentage)
SELECT Sentiment,
       COUNT(*) AS Review_Count,
       ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM reviews), 2) AS Percentage
FROM reviews
GROUP BY Sentiment
ORDER BY Review_Count DESC;

-- Q42: Average rating by sentiment
SELECT Sentiment,
       ROUND(AVG(Rating), 2) AS Average_Rating
FROM reviews
GROUP BY Sentiment
ORDER BY Average_Rating DESC;

-- Q43: Average review length by sentiment
SELECT Sentiment,
       ROUND(AVG(Review_Length), 2) AS Average_Review_Length
FROM reviews
GROUP BY Sentiment
ORDER BY Average_Review_Length DESC;

-- Q44: Average helpfulness ratio by sentiment
SELECT Sentiment,
       ROUND(AVG(Helpfulness_Ratio), 2) AS Average_Helpfulness_Ratio
FROM reviews
GROUP BY Sentiment
ORDER BY Average_Helpfulness_Ratio DESC;

-- Q45: Rating distribution inside each sentiment category
SELECT Sentiment,
       Rating,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Sentiment, Rating
ORDER BY Sentiment, Rating;


-- =====================================================================
-- SECTION 6 : TIME ANALYSIS
-- =====================================================================

-- Q46: Total reviews per year
SELECT Year,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Year
ORDER BY Year;

-- Q47: Total reviews per month (aggregated across all years)
SELECT Month,
       Month_No,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Month, Month_No
ORDER BY Month_No;

-- Q48: Year with the highest number of reviews
SELECT Year,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Year
ORDER BY Review_Count DESC
LIMIT 1;

-- Q49: Year with the lowest number of reviews
SELECT Year,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Year
ORDER BY Review_Count ASC
LIMIT 1;

-- Q50: Average rating trend over years
SELECT Year,
       ROUND(AVG(Rating), 2) AS Average_Rating
FROM reviews
GROUP BY Year
ORDER BY Year;

-- Q51: Sentiment trend over years
SELECT Year,
       Sentiment,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Year, Sentiment
ORDER BY Year, Sentiment;

-- Q52: Monthly review trend across all years
SELECT Year,
       Month_No,
       Month,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY Year, Month_No, Month
ORDER BY Year, Month_No;


-- SECTION 7 : ADVANCED SQL

-- Q53: CASE - Label reviews as Short / Medium / Long based on length
SELECT Id,
       ProductId,
       Review_Length,
       CASE
           WHEN Review_Length < 50 THEN 'Short'
           WHEN Review_Length BETWEEN 50 AND 200 THEN 'Medium'
           ELSE 'Long'
       END AS Review_Length_Category
FROM reviews
LIMIT 100;

-- Q54: IF - Flag reviews as Helpful or Not_Helpful based on ratio
SELECT Id,
       ProductId,
       Helpfulness_Ratio,
       IF(Helpfulness_Ratio >= 0.5, 'Helpful', 'Not_Helpful') AS Helpfulness_Flag
FROM reviews
LIMIT 100;

-- Q55: Subquery - Products with average rating above the overall average
SELECT ProductId,
       ROUND(AVG(Rating), 2) AS Average_Rating
FROM reviews
GROUP BY ProductId
HAVING AVG(Rating) > (SELECT AVG(Rating) FROM reviews)
ORDER BY Average_Rating DESC;

-- Q56: Correlated Subquery - Reviews with rating above that product's own average
SELECT r1.Id,
       r1.ProductId,
       r1.Rating
FROM reviews r1
WHERE r1.Rating > (
    SELECT AVG(r2.Rating)
    FROM reviews r2
    WHERE r2.ProductId = r1.ProductId
)
LIMIT 100;

-- Q57: CTE - Average rating and review count per product
WITH product_stats AS (
    SELECT ProductId,
           ROUND(AVG(Rating), 2) AS Average_Rating,
           COUNT(*) AS Review_Count
    FROM reviews
    GROUP BY ProductId
)
SELECT *
FROM product_stats
ORDER BY Review_Count DESC
LIMIT 20;

-- Q58: Window Function - RANK products by average rating
SELECT ProductId,
       Average_Rating,
       RANK() OVER (ORDER BY Average_Rating DESC) AS Rating_Rank
FROM (
    SELECT ProductId,
           ROUND(AVG(Rating), 2) AS Average_Rating
    FROM reviews
    GROUP BY ProductId
) AS product_avg
LIMIT 20;

-- Q59: Window Function - DENSE_RANK products by review count
SELECT ProductId,
       Review_Count,
       DENSE_RANK() OVER (ORDER BY Review_Count DESC) AS Review_Count_Rank
FROM (
    SELECT ProductId,
           COUNT(*) AS Review_Count
    FROM reviews
    GROUP BY ProductId
) AS product_counts
LIMIT 20;

-- Q60: Window Function - ROW_NUMBER to identify each user's most recent review
SELECT *
FROM (
    SELECT Id,
           UserId,
           ProductId,
           Time,
           ROW_NUMBER() OVER (PARTITION BY UserId ORDER BY Time DESC) AS Row_Num
    FROM reviews
) AS ranked_reviews
WHERE Row_Num = 1
LIMIT 100;

-- Q61: OVER (PARTITION BY) - Average rating per product alongside each review
SELECT Id,
       ProductId,
       Rating,
       ROUND(AVG(Rating) OVER (PARTITION BY ProductId), 2) AS Product_Average_Rating
FROM reviews
LIMIT 100;

-- Q62: LEAD - Compare each year's review count to the following year
SELECT Year,
       Review_Count,
       LEAD(Review_Count) OVER (ORDER BY Year) AS Next_Year_Review_Count
FROM (
    SELECT Year, COUNT(*) AS Review_Count
    FROM reviews
    GROUP BY Year
) AS yearly_counts
ORDER BY Year;

-- Q63: LAG - Compare each year's review count to the previous year
SELECT Year,
       Review_Count,
       LAG(Review_Count) OVER (ORDER BY Year) AS Previous_Year_Review_Count
FROM (
    SELECT Year, COUNT(*) AS Review_Count
    FROM reviews
    GROUP BY Year
) AS yearly_counts
ORDER BY Year;

-- Q64: Running Total - Cumulative review count by year
SELECT Year,
       Review_Count,
       SUM(Review_Count) OVER (ORDER BY Year) AS Running_Total_Reviews
FROM (
    SELECT Year, COUNT(*) AS Review_Count
    FROM reviews
    GROUP BY Year
) AS yearly_counts
ORDER BY Year;

-- Q65: Moving Average - 3-year moving average of average rating
SELECT Year,
       Average_Rating,
       ROUND(
         AVG(Average_Rating) OVER (
             ORDER BY Year
             ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
         ), 2
       ) AS Moving_Avg_3_Year
FROM (
    SELECT Year, AVG(Rating) AS Average_Rating
    FROM reviews
    GROUP BY Year
) AS yearly_avg
ORDER BY Year;

-- Q66: NTILE - Split products into 4 performance buckets by average rating
SELECT ProductId,
       Average_Rating,
       NTILE(4) OVER (ORDER BY Average_Rating DESC) AS Rating_Quartile
FROM (
    SELECT ProductId, AVG(Rating) AS Average_Rating
    FROM reviews
    GROUP BY ProductId
) AS product_avg;


-- =====================================================================
-- SECTION 8 : INTERVIEW LEVEL QUERIES
-- =====================================================================

-- Q67: Products whose average rating is above the overall average rating
SELECT ProductId,
       ROUND(AVG(Rating), 2) AS Average_Rating
FROM reviews
GROUP BY ProductId
HAVING AVG(Rating) > (SELECT AVG(Rating) FROM reviews)
ORDER BY Average_Rating DESC;

-- Q68: Users whose review count is above the average review count per user
SELECT UserId,
       ProfileName,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY UserId, ProfileName
HAVING COUNT(*) > (
    SELECT AVG(user_review_count)
    FROM (
        SELECT COUNT(*) AS user_review_count
        FROM reviews
        GROUP BY UserId
    ) AS user_counts
)
ORDER BY Review_Count DESC;

-- Q69: Products having more than 100 reviews
SELECT ProductId,
       COUNT(*) AS Review_Count
FROM reviews
GROUP BY ProductId
HAVING COUNT(*) > 100
ORDER BY Review_Count DESC;

-- Q70: Top 5 products by review count in every year
SELECT Year, ProductId, Review_Count, Rnk
FROM (
    SELECT Year,
           ProductId,
           COUNT(*) AS Review_Count,
           RANK() OVER (PARTITION BY Year ORDER BY COUNT(*) DESC) AS Rnk
    FROM reviews
    GROUP BY Year, ProductId
) AS ranked_products
WHERE Rnk <= 5
ORDER BY Year, Rnk;

-- Q71: Rank all products by average rating (highest first)
SELECT ProductId,
       ROUND(AVG(Rating), 2) AS Average_Rating,
       RANK() OVER (ORDER BY AVG(Rating) DESC) AS Rating_Rank
FROM reviews
GROUP BY ProductId
ORDER BY Rating_Rank;

-- Q72: Rank all users by total review count (highest first)
SELECT UserId,
       ProfileName,
       COUNT(*) AS Review_Count,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS Review_Count_Rank
FROM reviews
GROUP BY UserId, ProfileName
ORDER BY Review_Count_Rank;

-- Q73: Running total of reviews by year
SELECT Year,
       COUNT(*) AS Review_Count,
       SUM(COUNT(*)) OVER (ORDER BY Year) AS Running_Total
FROM reviews
GROUP BY Year
ORDER BY Year;

-- Q74: Difference between consecutive yearly review counts
SELECT Year,
       Review_Count,
       Review_Count - LAG(Review_Count) OVER (ORDER BY Year) AS Review_Count_Difference
FROM (
    SELECT Year, COUNT(*) AS Review_Count
    FROM reviews
    GROUP BY Year
) AS yearly_counts
ORDER BY Year;

-- Q75: Year-over-year review growth percentage
SELECT Year,
       Review_Count,
       ROUND(
         (Review_Count - LAG(Review_Count) OVER (ORDER BY Year)) * 100.0
         / LAG(Review_Count) OVER (ORDER BY Year), 2
       ) AS YoY_Growth_Percentage
FROM (
    SELECT Year, COUNT(*) AS Review_Count
    FROM reviews
    GROUP BY Year
) AS yearly_counts
ORDER BY Year;

-- Q76: Products with the highest positive review ratio (min 10 reviews)
SELECT ProductId,
       SUM(CASE WHEN Sentiment = 'Positive' THEN 1 ELSE 0 END) AS Positive_Count,
       COUNT(*) AS Total_Reviews,
       ROUND(
         (SUM(CASE WHEN Sentiment = 'Positive' THEN 1 ELSE 0 END) * 100.0)
         / COUNT(*), 2
       ) AS Positive_Review_Ratio
FROM reviews
GROUP BY ProductId
HAVING COUNT(*) >= 10
ORDER BY Positive_Review_Ratio DESC
LIMIT 20;

-- Q77: Products appearing in both "Top 10 most reviewed" and "Top 10 highest rated"
WITH most_reviewed AS (
    SELECT ProductId
    FROM reviews
    GROUP BY ProductId
    ORDER BY COUNT(*) DESC
    LIMIT 10
),
highest_rated AS (
    SELECT ProductId
    FROM reviews
    GROUP BY ProductId
    HAVING COUNT(*) >= 10
    ORDER BY AVG(Rating) DESC
    LIMIT 10
)
SELECT mr.ProductId
FROM most_reviewed mr
INNER JOIN highest_rated hr
    ON mr.ProductId = hr.ProductId;

-- Q78: Second highest rated product overall (using DENSE_RANK)
SELECT ProductId, Average_Rating
FROM (
    SELECT ProductId,
           ROUND(AVG(Rating), 2) AS Average_Rating,
           DENSE_RANK() OVER (ORDER BY AVG(Rating) DESC) AS Rnk
    FROM reviews
    GROUP BY ProductId
) AS ranked
WHERE Rnk = 2;

-- END OF SCRIPT