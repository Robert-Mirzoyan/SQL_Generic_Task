-- 3. Write SQL queries to find the following data about countries:
-- a. Country with the biggest population (id and name of the country)
SELECT c.id, c.name
FROM country c
ORDER BY c.population DESC
LIMIT 1;
-- b. Top 10 countries with the lowest population density (names of the countries)
SELECT c.name
FROM country c
WHERE c.area > 0
ORDER BY c.population/c.area ASC
LIMIT 10;
-- c. Countries with population density higher than average across all countries
SELECT c.name, c.population/c.area as density
FROM country c
WHERE area > 0 AND c.population/c.area > (
    SELECT AVG(population/area)
    FROM country
    WHERE area > 0
    )
;
-- d. Country with the longest name (if several countries have name of the same length, show all of them)
SELECT c.name
FROM country c
WHERE LENGTH(c.name) = (
    SELECT MAX(LENGTH(name)) FROM country
);
-- e. All countries with name containing letter “F”, sorted in alphabetical order
SELECT *
FROM country
WHERE position('F' in name)>0
ORDER BY name;
-- f. Country which has a population, closest to the average population of all countries
SELECT name, population
FROM country
ORDER BY ABS(population - (SELECT AVG(population) FROM country))
LIMIT 1;

-- 3. Write SQL queries to find the following data about countries and continents:
-- a. Count of countries for each continent
SELECT cnt.name, cty.number
FROM continent cnt LEFT JOIN (
    SELECT continent_id, COUNT(continent_id) as number
    FROM country
    GROUP BY continent_id
) as cty ON cnt.id = cty.continent_id;
-- b. Total area for each continent (print continent name and total area), sorted by area from biggest to smallest
SELECT cnt.name, cty.total_area
FROM continent cnt LEFT JOIN (
    SELECT continent_id, SUM(area) as total_area
    FROM country
    GROUP BY continent_id
) as cty ON cnt.id = cty.continent_id
ORDER BY total_area DESC;
-- c. Average population density per continent
SELECT cnt.name, cty.average_density
FROM continent cnt LEFT JOIN (
    SELECT continent_id, AVG(population/area) as average_density
    FROM country
    WHERE area > 0
    GROUP BY continent_id
) as cty ON cnt.id = cty.continent_id;
-- d. For each continent, find a country with the smallest area (print continent name, country name and area)
SELECT cnt.name as continent_name, cty.name as country_name, cty.area
FROM continent cnt JOIN public.country as cty
ON cnt.id = cty.continent_id
WHERE cty.area = (
    SELECT MIN(c.area)
    FROM country c
    WHERE c.continent_id = cnt.id
    );
-- e. Find all continents, which have average country population less than 20 million
SELECT cnt.name, cty.average_population
FROM continent cnt JOIN (
    SELECT continent_id, AVG(population) as average_population
    FROM country
    GROUP BY continent_id
) as cty ON cnt.id = cty.continent_id
WHERE average_population < 20000000;

-- 4. Write SQL queries to find the following data about people
-- a. Person with the biggest number of citizenships
SELECT p.name, pc2.citizenship_number
FROM person p LEFT JOIN (
    SELECT COUNT(pc.country_id) as citizenship_number, pc.person_id
    FROM person_country pc
    GROUP BY pc.person_id
) pc2 on p.id = pc2.person_id
LIMIT 1;
-- b. All people who have no citizenship
SELECT p.name
FROM person p
WHERE id NOT IN (
    SELECT person_id
    FROM person_country
    );
-- c. Country with the least people in People table
SELECT c.name, pc.people_number
FROM country c LEFT JOIN (
    SELECT COUNT(person_id) as people_number, country_id
    FROM person_country
    GROUP BY country_id
) pc on country_id = c.id
WHERE people_number NOTNULL
ORDER BY people_number ASC
LIMIT 1;
-- d. Continent with the most people in People table
SELECT cnt.name, cty_pc.number
FROM continent cnt
LEFT JOIN (
    SELECT COUNT(cty.continent_id) as number, continent_id
    FROM country cty
    LEFT JOIN person_country pc
    ON cty.id = pc.country_id
    GROUP BY continent_id
) AS cty_pc
ON cnt.id = cty_pc.continent_id;
-- e. Find pairs of people with the same name - print 2 ids and the name
SELECT p1.name, p1.id, p2.id
FROM person p1
INNER JOIN person p2
ON p1.name = p2.name
WHERE p1.id != p2.id;