-- Data Cleaning

SELECT * FROM world_layoffs.layoffs;

-- 1.Remove Duplicates
-- 2.Standardizing the Data
-- 3.Remove null values or blank values
-- 4.Remove any Coulumns

-- 1.Remove Duplicates

CREATE TABLE layoffs_stagging
LIKE layoffs;

SELECT *
FROM layoffs_stagging;

INSERT INTO layoffs_stagging
(SELECT * FROM layoffs);

SELECT *
FROM layoffs_stagging;

SELECT *,
ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging;

SELECT *
FROM (SELECT *,
ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging
) AS row_num
WHERE row_num > 1;

WITH temp_table AS
(
SELECT *,
ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging
)
SELECT * 
FROM temp_table
WHERE row_num > 1;


CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_stagging2
SELECT *,
ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_stagging;

SELECT *
FROM layoffs_stagging2;

SELECT * 
FROM layoffs_stagging2
WHERE row_num > 1;

DELETE FROM layoffs_stagging2
WHERE row_num > 1;

SELECT *
FROM layoffs_stagging2;

-- Standardizing the data

SELECT company, TRIM(company)
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET company = TRIM(company);

SELECT DISTINCT location
FROM layoffs_stagging2
ORDER BY 1;

SELECT DISTINCT industry
FROM layoffs_stagging2
ORDER BY 1;

SELECT *
FROM layoffs_stagging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT country
FROM layoffs_stagging2
ORDER BY 1;

SELECT DISTINCT country ,TRIM( TRAILING '.' FROM country)
FROM layoffs_stagging2
ORDER BY 1;

UPDATE layoffs_stagging2
SET country = TRIM( TRAILING '.' FROM country);

SELECT `date`, STR_TO_DATE(`date`,'%m-%d-%Y'),STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_stagging2;

UPDATE layoffs_stagging2
SET  `date` =
	CASE
		WHEN `date` LIKE '%-%' THEN STR_TO_DATE(`date`,'%m-%d-%Y')
        WHEN `date` LIKE '%/%' THEN STR_TO_DATE(`date`,'%m/%d/%Y')
        ELSE `date`
	END;

-- 3.Remove null values or blank values

SELECT *
FROM layoffs_stagging2
WHERE industry = '' OR industry IS NULL;
 
 UPDATE layoffs_stagging2
 SET industry = NULL
 WHERE industry = '' OR industry IS NULL;
 
SELECT *
FROM layoffs_stagging2
WHERE company LIKE '%Airbnb%';

SELECT *
FROM layoffs_stagging2
WHERE company LIKE '%Bally%';

SELECT t1.company, t1.industry, t2.company, t2.industry
FROM layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
    WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
    
UPDATE  layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
 WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

SELECT  DISTINCT industry
FROM layoffs_stagging2;

SELECT *
FROM layoffs_stagging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE FROM layoffs_stagging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;

-- 4.Remove any Coulumns

ALTER TABLE layoffs_stagging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_stagging2;






    













