/*
This project will continue from the webscraping of rotten tomatoes 140 Action Movies.
Here, we will create a new database and table before importing the data.
In the dataset, each the column,'cast' contains multiple actors.
We will write a query to split the cast column into 4 columns for each actor
A new table will be created for the actors such that each actor will have separate record (first normalization)
*/

CREATE DATABASE IF NOT EXISTS rt_movies;

USE rt_movies;

CREATE TABLE IF NOT EXISTS all_movies (
	movie_title VARCHAR(255) NOT NULL,
    movie_year INT,
    rating INT,
    cast VARCHAR(255),
    director VARCHAR(255),
    critic VARCHAR(255)
    );
    
-- Import the dataset created from the webscarping project

-- Create a table for films which will contain all columns except cast

DROP TABLE IF EXISTS film;
CREATE TABLE IF NOT EXISTS film (
	id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    year_released INT,
    rating INT,
    director VARCHAR(255),
    critic VARCHAR(255)
    );
INSERT INTO film (title, year_released, rating, director, critic)
	SELECT
		movie_title, movie_year, rating, director, critic
    FROM all_movies;

-- Create a table for actors by splitting the cast column and assign ids to each actor

DROP TABLE IF EXISTS actor;
CREATE TABLE IF NOT EXISTS actor (
	id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    count_of_movies INT
    );

-- Create a table that will connect films to actors

DROP TABLE IF EXISTS film_actor;
CREATE TABLE IF NOT EXISTS film_actor (
	id INT AUTO_INCREMENT PRIMARY KEY,
    actor_id INT,
    film_id INT,
    FOREIGN KEY fk_filmactor_film (film_id) REFERENCES film (id),
    FOREIGN KEY fk_filmactor_actor (actor_id) REFERENCES actor (id)
    );

CREATE VIEW vwfilm AS
with cte_a AS (
	SELECT
		f.id,
		f.title,
		m.cast,
		SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 1), ',', -1) AS actor1,
		SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 2), ',', -1) AS actor2,
		SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 3), ',', -1) AS actor3,
		SUBSTRING_INDEX(SUBSTRING_INDEX(cast, ',', 4), ',', -1) AS actor4
	FROM all_movies m
	JOIN film f
		ON m.movie_title = f.title
		AND m.movie_year = f.year_released),

cte_b AS (
	SELECT 
			actor1 AS actor, id
		FROM cte_a
		UNION

		SELECT 
			actor2 AS actor, id
		FROM cte_a
		UNION

		SELECT 
			actor3 AS actor, id
		FROM cte_a
		UNION

		SELECT 
			actor4 AS actor, id
		FROM cte_a
		)
        
SELECT 
	actor,
	id
FROM cte_b;
  
INSERT INTO actor (full_name, count_of_movies)
	SELECT
	actor, count(*) appearances
	FROM vwfilm
	GROUP BY actor;

INSERT INTO film_actor(actor_id, film_id)
	SELECT
	a.id, vw.id
	FROM actor a
	JOIN vwfilm vw
		ON a.full_name = vw.actor;
