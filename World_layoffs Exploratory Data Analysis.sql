-- Exploratory Data Analysis

-- Skills used: Joins, CTE's, Window Functions, Aggregate Functions, Creating Views

SELECT *
FROM world_layoffs.layoffs_stagging2;

# Total laid off by companies

SELECT company, SUM(total_laid_off) AS total_off
FROM layoffs_stagging2
GROUP BY company
ORDER BY total_off DESC;

# Total laid off by industries

SELECT industry, SUM(total_laid_off) AS total_off
FROM layoffs_stagging2
GROUP BY industry
ORDER BY total_off DESC;

# Total laid off by countries

SELECT country, SUM(total_laid_off) AS total_off
FROM layoffs_stagging2
GROUP BY country
ORDER BY total_off DESC;

# Maximum and Minimum laid off by company in one day

SELECT MAX(total_laid_off), MIN(total_laid_off)
FROM layoffs_stagging2;

# Total percentage laid off by stage groups

SELECT stage, ROUND(SUM(percentage_laid_off),2) AS total_percentage_laidoff
FROM layoffs_stagging2
GROUP BY stage;

# Total funds raised by companies

SELECT company, SUM(funds_raised_millions) AS total_funds_raised
FROM layoffs_stagging2
GROUP BY company
ORDER BY 2 DESC;

# When the laid off started and ended as per this data

SELECT MAX(`date`), MIN(`date`)
FROM layoffs_stagging2;

# layoffs per month

SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_stagging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY  SUBSTRING(`date`,1,7)
ORDER BY 1 ASC;

# Rolling total by months

WITH Rolling_total (`month`, total_off)AS 
(
SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_stagging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY  SUBSTRING(`date`,1,7)
ORDER BY 1 ASC
)

SELECT `month`, total_off, SUM(total_off) OVER (ORDER BY `month`)  AS rolling_total
FROM Rolling_total;

# Ranking the comapnies based on the total layoffs in the year

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Ranking (company, years, total_off)AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), company_year_rank AS
(
SELECT *,
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_off DESC) AS `rank`
FROM Ranking
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE `rank` <= 5;

























SELECT *
FROM layoffs_stagging2;











