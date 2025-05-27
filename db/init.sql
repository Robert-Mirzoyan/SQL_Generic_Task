DROP TABLE IF EXISTS person_country CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS continent CASCADE;

CREATE TABLE continent (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO continent (name) VALUES
    ('Africa'),
    ('Asia'),
    ('Europe'),
    ('North America'),
    ('South America'),
    ('Australia'),
    ('Antarctica');


CREATE TABLE country (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    population BIGINT NOT NULL,
    area FLOAT NOT NULL,
    continent_id INT REFERENCES continent(id)
);

INSERT INTO country (name, population, area, continent_id) VALUES
    ('Nigeria', 216000000, 923768, 1),
    ('Egypt', 104000000, 1002450, 1),
    ('China', 1440000000, 9597000, 2),
    ('India', 1390000000, 3287263, 2),
    ('Germany', 83000000, 357022, 3),
    ('France', 67000000, 551695, 3),
    ('USA', 331000000, 9834000, 4),
    ('Canada', 38000000, 9985000, 4),
    ('Brazil', 213000000, 8516000, 5),
    ('Argentina', 45000000, 2780000, 5),
    ('Australia', 25000000, 7692000, 6),
    ('New Zealand', 5000000, 268021, 6),
    ('No Country', 0, 0, 7);

CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO person (name) VALUES
    ('Alice'),
    ('Bob'),
    ('Charlie'),
    ('Diana'),
    ('Edward'),
    ('Fiona'),
    ('George'),
    ('Hannah'),
    ('Ivan'),
    ('Julia'),
    ('Alice'), -- duplicate name for pair test
    ('NoCountryPerson'); -- will have no citizenship


CREATE TABLE person_country (
    person_id INT REFERENCES person(id) ON DELETE CASCADE,
    country_id INT REFERENCES country(id) ON DELETE CASCADE,
    PRIMARY KEY (person_id, country_id)
);

INSERT INTO person_country (person_id, country_id) VALUES
    (1, 1),  -- Alice - Nigeria
    (1, 5),  -- Alice - Germany
    (2, 2),  -- Bob - Egypt
    (2, 3),  -- Bob - China
    (3, 4),  -- Charlie - India
    (3, 6),  -- Charlie - France
    (4, 7),  -- Diana - USA
    (5, 8),  -- Edward - Canada
    (6, 9),  -- Fiona - Brazil
    (6, 10), -- Fiona - Argentina
    (7, 11), -- George - Australia
    (8, 12), -- Hannah - New Zealand
    (9, 3),  -- Ivan - China
    (9, 4),  -- Ivan - India
    (10, 5), -- Julia - Germany
    (11, 6); -- Alice2 - France
-- Note: person_id 12 (NoCountryPerson) has no citizenship
