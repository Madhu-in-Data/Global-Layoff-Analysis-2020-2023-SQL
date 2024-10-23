-- data cleaning

-- 1. remove duplicates
-- 2. standardize the data
-- 3. null values and blank values
-- 4. removing unnecessary rows or columns

SELECT *
FROM world_layoffs.layoffs;

SELECT COUNT(*)
FROM world_layoffs.layoffs;

-- creating a staging table to use - to preserve our raw data

CREATE TABLE layoff_staging
LIKE layoffs;


SELECT *
FROM layoff_staging;

INSERT INTO layoff_staging
SELECT *
FROM layoffs;


SELECT COUNT(*)
FROM layoff_staging;


-- REMOVING DUPLICATES

-- since there is no unique id for the rows in the table, we can create that using row_number()
-- giving a row number (partitioning by all columns searches for unique rows to give row number)

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry,total_laid_off,
percentage_laid_off, `date`, stage,country,funds_raised_millions ) as row_num
FROM layoff_staging ;


-- shows the duplicates (with row_num>1)
WITH CTE_EG AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry,total_laid_off,
percentage_laid_off, `date`, stage,country,funds_raised_millions ) as row_num
FROM layoff_staging 
)
SELECT *
FROM CTE_EG
WHERE row_num>1;    


-- now we can delete the rows with row_num>1 because they are duplicates
-- to delete them from the actual table, we can  create another staging table with row_num
-- then delete the rows 

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoff_staging2;


-- inserting all values of layoff_staging and row number in layoff_staging2

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry,total_laid_off,
percentage_laid_off, `date`, stage,country,funds_raised_millions ) as row_num
FROM layoff_staging ;


-- checking duplicates again
SELECT *
FROM layoff_staging2
WHERE row_num>1;


-- deleting duplicate rows
DELETE 
FROM layoff_staging2
WHERE row_num>1;

SELECT *
FROM layoff_staging2;



-- STANDARDIZING DATA


-- text
	-- trim white space
    -- removing symbols like dots, %,& 
-- number
	-- checking  data types


-- trimming white space

-- company
SELECT company, TRIM(company)
FROM layoff_staging2;


UPDATE layoff_staging2
SET company = TRIM(company);

-- industry

SELECT DISTINCT industry
FROM layoff_staging2
ORDER BY industry;

# crypo has 3 different representations

SELECT *
FROM layoff_staging2
WHERE industry LIKE'crypto%';

UPDATE layoff_staging2
SET industry = 'Crypto'
WHERE industry LIKE'crypto%';


-- location
SELECT DISTINCT location
FROM layoff_staging2
ORDER BY location;


-- country
SELECT DISTINCT country
FROM layoff_staging2
ORDER BY country ;

# united states has 2 representations
SELECT *
FROM layoff_staging2
WHERE country LIKE 'united states%';

SELECT *
FROM layoff_staging2
WHERE country LIKE 'united states_';
# easy to find united states with . 


-- removing the dot

SELECT country, TRIM(TRAILING '.' FROM  country)
FROM layoff_staging2;

UPDATE layoff_staging2
SET country = TRIM(TRAILING '.' FROM  country)
WHERE country LIKE 'united states%';


-- date

-- changin data types from text to date

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')    #this only alters the date format, not data type
FROM layoff_staging2;

UPDATE layoff_staging2
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y');  

-- changing the data type itself

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;


-- total_laid_off

-- changing data type from text 

ALTER TABLE layoff_staging2
MODIFY COLUMN total_laid_off INT;


-- percentage_laid_off

-- changing data type from text 

ALTER TABLE layoff_staging2
MODIFY COLUMN percentage_laid_off FLOAT;

SELECT *
FROM layoff_staging2;


-- funds_raised_millions

-- changing data type from text 

ALTER TABLE layoff_staging2
MODIFY COLUMN funds_raised_millions INT;


-- NULL VALUES , BLANK VALUES

-- industry had a blank hence checking those rows

SELECT *
FROM layoff_staging2
WHERE industry IS NULL
OR industry ='';

-- airbnb has a blank for industry hence checking if there are other records of that company

SELECT *
FROM layoff_staging2
WHERE company = 'Airbnb';
# this belongs to travel industry




-- better practice to change blank to null , then see if we can update any data

UPDATE layoff_staging2
SET industry = NULL
WHERE industry ='';

-- we can update the blank industry cells with the appropriate industry ,
-- if there are multiple records of same company in same location .
-- which means they are meaning the same company thus same industry

SELECT *
FROM layoff_staging2 t1
join layoff_staging2 t2
	ON t1.company = t2.company
		AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- if you want to look at the industry alone

SELECT t1.industry , t2.industry
FROM layoff_staging2 t1
join layoff_staging2 t2
	ON t1.company = t2.company
		AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


-- updating the industry 

UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
		AND t1.location = t2.location
SET t1.industry=t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;



-- REMOVING UNNECCESARY ROWS OR COLUMNS

-- total_laid_off and percentage_laid_off - if both of these are null, 
-- probabily these records are not gonna be useful
-- not like we should be removing them, but they are not going to be very useful
-- hence we can remove

SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- we also don't need row_num 
ALTER TABLE layoff_staging2
DROP COLUMN row_num;


SELECT *
FROM layoff_staging2;


# that's our final dataset --> READY FOR EDA