
SELECT *
FROM layoff_staging2;

-- mostly we can use total_laid_off or funds_raised_millions against other columns
-- percentage_laid_off is not so useful because that is percentage of that particular company
-- and the total employee of each company is not given


SELECT MAX(total_laid_off)
FROM layoff_staging2;

SELECT MAX(percentage_laid_off)
FROM layoff_staging2;

# 1 means total company went down

-- looking at companies that completely went under
SELECT *
FROM layoff_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC;


SELECT COUNT(*)
FROM layoff_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoff_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;


-- total laid off per company

SELECT company, SUM(total_laid_off) as total_sum
FROM layoff_staging2
GROUP BY company
ORDER BY total_sum desc;

-- looking at the date range of the dataset

SELECT MIN(`date`), MAX(`date`)
FROM layoff_staging2;


-- total laid off per industry
SELECT industry, SUM(total_laid_off) as total_sum
FROM layoff_staging2
GROUP BY industry
ORDER BY total_sum desc;

-- total laid off per country
SELECT country, SUM(total_laid_off) as total_sum
FROM layoff_staging2
GROUP BY country
ORDER BY total_sum desc;

-- total laid off per year
SELECT YEAR(`date`), SUM(total_laid_off) as total_sum
FROM layoff_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- total laid off per stage
SELECT stage, SUM(total_laid_off) as total_sum
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- total laid off / each month of year
SELECT  SUBSTRING(`date`,1,7),
SUM(total_laid_off) 
FROM layoff_staging2
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY SUBSTRING(`date`,1,7);


-- progress of layoff by each year-month (rolling total)

WITH rolling_total AS
(
SELECT  SUBSTRING(`date`,1,7) AS y_m,
SUM(total_laid_off)  as total_sum
FROM layoff_staging2
GROUP BY SUBSTRING(`date`,1,7)
ORDER BY SUBSTRING(`date`,1,7)
)
SELECT y_m, total_sum,
SUM(total_sum) OVER(ORDER BY y_m)
FROM rolling_total
WHERE y_m  IS NOT NULL;



-- total laid of per year for each company

SELECT company, YEAR(`date`) , SUM(total_laid_off) as total_sum
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company ASC
;


-- rank companies based on  total laid off companies per year
WITH company_year AS
(
SELECT company, 
YEAR(`date`) as _year , 
SUM(total_laid_off) as total_sum
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *,
DENSE_RANK() OVER(PARTITION BY _year ORDER BY total_sum DESC) as ranking
FROM company_year 
WHERE _year IS NOT NULL
ORDER BY ranking ASC ;



-- top 5 out of above
WITH company_year AS
(
SELECT company, 
YEAR(`date`) as _year , 
SUM(total_laid_off) as total_sum
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
),
company_year_rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY _year ORDER BY total_sum DESC) as ranking
FROM company_year 
WHERE _year IS NOT NULL
ORDER BY ranking ASC 
)
SELECT *
FROM company_year_rank
WHERE ranking<=5
ORDER BY _year;


-- 📌 find top 5 industries that had highest lay off each year

-- total for each industry
SELECT industry, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY industry;


-- finding total of each industry per year
SELECT industry, 
YEAR(`date`) as YM,
SUM(total_laid_off) AS total_sum
FROM layoff_staging2
GROUP BY YM, industry
ORDER BY YM, total_sum DESC;

-- ranking industries for each year
WITH industry_year AS
(
SELECT industry, 
YEAR(`date`) as YM,
SUM(total_laid_off) AS total_sum
FROM layoff_staging2
GROUP BY YM, industry
ORDER BY YM, total_sum DESC
)
SELECT *,
DENSE_RANK() OVER(PARTITION BY YM ORDER BY total_sum DESC) as ranking
FROM industry_year
ORDER BY YM;



-- top 5
WITH industry_year AS
(
SELECT industry, 
YEAR(`date`) as YM,
SUM(total_laid_off) AS total_sum
FROM layoff_staging2
GROUP BY YM, industry
ORDER BY YM, total_sum DESC
),
industry_year_rank AS
(
SELECT *,
DENSE_RANK() OVER(PARTITION BY YM ORDER BY total_sum DESC) as ranking
FROM industry_year
ORDER BY YM
)
SELECT *
FROM industry_year_rank 
WHERE ranking<=5
ORDER BY YM, ranking ;




