-- Analyzing Suicide Rates

-- Top 50 countries with the highest suicide rates
SELECT
    country,
    ROUND(AVG(per_100k_pop), 2) AS avg_suicide_rate
FROM
    SuicideRates
GROUP BY
    country
ORDER BY
    avg_suicide_rate DESC
LIMIT 50;


-- Bottom 50 countries with the lowest suicide rates
SELECT
    country,
    ROUND(AVG(per_100k_pop), 2) AS avg_suicide_rate
FROM
    SuicideRates
GROUP BY
    country
ORDER BY
    avg_suicide_rate
LIMIT 50;


-- Average number of suicides per decade for each country as well as the percentage of population which that number represents
SELECT 
    country,
    CONCAT((FLOOR(year / 10) * 10), 's') AS decade,
    AVG(suicides_no) AS avg_suicides,
    CONCAT(ROUND((AVG(suicides_no) / AVG(population)) * 100, 4), '%') AS pop_percent
FROM SuicideRates
GROUP BY country, decade
ORDER BY country;


-- Average suicide rate (per 100k population) for each age group excluding age groups with fewer than 100 cases
SELECT 
	age, 
	ROUND(AVG(per_100k_pop), 2) AS avg_suicide_rate
FROM SuicideRates
GROUP BY age
HAVING COUNT(*) >= 100
ORDER BY avg_suicide_rate DESC;


-- Highest increase of suicides from each year's respective previous year, country included
SELECT 
	year, 
    country, 
    MAX(increase_in_suicides) AS max_increase
FROM (
    SELECT country, year, SUM(suicides_no) - LAG(SUM(suicides_no)) OVER (PARTITION BY country ORDER BY year) AS increase_in_suicides
    FROM SuicideRates
    GROUP BY country, year
) AS subquery
GROUP BY country, year
ORDER BY max_increase DESC;


-- Total number of suicides for each generation and sex, along with the percentage of total suicides it represents
SELECT 
	generation, 
    sex, 
    SUM(suicides_no) AS total_suicides,
    CONCAT(ROUND(SUM(suicides_no) / (SELECT SUM(suicides_no) FROM SuicideRates) * 100, 4), '%') AS percentage_of_total
FROM SuicideRates
GROUP BY generation, sex
ORDER BY generation, sex;


-- Average suicide rate per 100k population for each year, with a rolling average over a 3-year window
SELECT
    year,
    ROUND(AVG(per_100k_pop), 2) AS avg_suicides_per_100k,
    ROUND((AVG(per_100k_pop) +
		LAG(AVG(per_100k_pop)) OVER (ORDER BY year) +
        LEAD(AVG(per_100k_pop)) OVER (ORDER BY year)) / 3, 2) 
			AS rolling_avg_suicides_per_100k
FROM SuicideRates
GROUP BY year
ORDER BY year;


-- Age group with the highest suicide rate in each country and year
SELECT
    country,
    year,
    age,
    per_100k_pop
FROM (
    SELECT
        country,
        year,
        age,
        per_100k_pop,
        ROW_NUMBER() OVER (PARTITION BY country, year ORDER BY per_100k_pop DESC) 
			AS row_num
    FROM
        SuicideRates
) AS ranked
WHERE
    row_num = 1;


-- Total number of suicides for each generation and sex
SELECT 
	generation,
	sex, 
    SUM(suicides_no) AS total_suicides
FROM SuicideRates
GROUP BY generation, sex
ORDER BY generation, sex;
