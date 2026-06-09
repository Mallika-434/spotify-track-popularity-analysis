-- ================================================
-- Spotify Track Popularity Analysis
-- Data Analyst Portfolio Project
-- Author: Mallika Chand
-- Tool: MySQL Workbench
-- ================================================

CREATE DATABASE spotify_analysis;
USE spotify_analysis;

-- ================================================
-- STEP 1: CREATE TABLES
-- ================================================

CREATE TABLE high_popularity (
   energy FLOAT, tempo FLOAT, danceability FLOAT,
   playlist_genre VARCHAR(100), loudness FLOAT,
   liveness FLOAT, valence FLOAT, track_artist VARCHAR(255),
   time_signature INT, speechiness FLOAT, track_popularity INT,
   track_href VARCHAR(500), uri VARCHAR(500),
   track_album_name VARCHAR(255), playlist_name VARCHAR(255),
   analysis_url VARCHAR(500), track_id VARCHAR(255),
   track_name VARCHAR(255), track_album_release_date VARCHAR(50),
   instrumentalness FLOAT, track_album_id VARCHAR(255),
   mode INT, `key` INT, duration_ms INT, acousticness FLOAT,
   id VARCHAR(255), playlist_subgenre VARCHAR(100),
   type VARCHAR(100), playlist_id VARCHAR(255)
);

CREATE TABLE low_popularity (
   energy FLOAT, tempo FLOAT, danceability FLOAT,
   playlist_genre VARCHAR(100), loudness FLOAT,
   liveness FLOAT, valence FLOAT, track_artist VARCHAR(255),
   time_signature INT, speechiness FLOAT, track_popularity INT,
   track_href VARCHAR(500), uri VARCHAR(500),
   track_album_name VARCHAR(255), playlist_name VARCHAR(255),
   analysis_url VARCHAR(500), track_id VARCHAR(255),
   track_name VARCHAR(255), track_album_release_date VARCHAR(50),
   instrumentalness FLOAT, track_album_id VARCHAR(255),
   mode INT, `key` INT, duration_ms INT, acousticness FLOAT,
   id VARCHAR(255), playlist_subgenre VARCHAR(100),
   type VARCHAR(100), playlist_id VARCHAR(255)
);

-- ================================================
-- STEP 2: LOAD DATA
-- ================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/high_popularity_spotify_data.csv'
INTO TABLE high_popularity
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/low_popularity_spotify_data.csv'
INTO TABLE low_popularity
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 ROWS
(@time_signature, @track_popularity, @speechiness, @danceability,
@playlist_name, @track_artist, @duration_ms, @energy, @playlist_genre,
@playlist_subgenre, @track_href, @track_name, @mode, @uri, @type,
@track_album_release_date, @analysis_url, @id, @instrumentalness,
@track_album_id, @playlist_id, @track_id, @valence, @key, @tempo,
@loudness, @acousticness, @liveness, @track_album_name)
SET time_signature = NULLIF(@time_signature, ''),
    track_popularity = NULLIF(@track_popularity, ''),
    speechiness = NULLIF(@speechiness, ''),
    danceability = NULLIF(@danceability, ''),
    playlist_name = NULLIF(@playlist_name, ''),
    track_artist = NULLIF(@track_artist, ''),
    duration_ms = NULLIF(@duration_ms, ''),
    energy = NULLIF(@energy, ''),
    playlist_genre = NULLIF(@playlist_genre, ''),
    playlist_subgenre = NULLIF(@playlist_subgenre, ''),
    track_href = NULLIF(@track_href, ''),
    track_name = NULLIF(@track_name, ''),
    mode = NULLIF(@mode, ''),
    uri = NULLIF(@uri, ''),
    type = NULLIF(@type, ''),
    track_album_release_date = NULLIF(@track_album_release_date, ''),
    analysis_url = NULLIF(@analysis_url, ''),
    id = NULLIF(@id, ''),
    instrumentalness = NULLIF(@instrumentalness, ''),
    track_album_id = NULLIF(@track_album_id, ''),
    playlist_id = NULLIF(@playlist_id, ''),
    track_id = NULLIF(@track_id, ''),
    valence = NULLIF(@valence, ''),
    `key` = NULLIF(@key, ''),
    tempo = NULLIF(@tempo, ''),
    loudness = NULLIF(@loudness, ''),
    acousticness = NULLIF(@acousticness, ''),
    liveness = NULLIF(@liveness, ''),
    track_album_name = NULLIF(@track_album_name, '');

-- ================================================
-- STEP 3: DATA CLEANING
-- ================================================

-- Row counts
SELECT COUNT(*) FROM high_popularity;
SELECT COUNT(*) FROM low_popularity;

-- Check nulls in high_popularity
SELECT
    SUM(CASE WHEN track_popularity IS NULL THEN 1 ELSE 0 END) AS null_popularity,
    SUM(CASE WHEN energy IS NULL THEN 1 ELSE 0 END) AS null_energy,
    SUM(CASE WHEN tempo IS NULL THEN 1 ELSE 0 END) AS null_tempo,
    SUM(CASE WHEN playlist_genre IS NULL THEN 1 ELSE 0 END) AS null_genre
FROM high_popularity;

-- Check nulls in low_popularity
SELECT
    SUM(CASE WHEN track_popularity IS NULL THEN 1 ELSE 0 END) AS null_popularity,
    SUM(CASE WHEN energy IS NULL THEN 1 ELSE 0 END) AS null_energy,
    SUM(CASE WHEN tempo IS NULL THEN 1 ELSE 0 END) AS null_tempo,
    SUM(CASE WHEN playlist_genre IS NULL THEN 1 ELSE 0 END) AS null_genre
FROM low_popularity;

-- Remove null rows from low_popularity
DELETE FROM low_popularity
WHERE energy IS NULL OR tempo IS NULL;

-- Check duplicates
-- Note: Same track_id across rows = same song in multiple playlists
-- These are not true duplicates and have been retained
SELECT track_id, COUNT(*) FROM high_popularity
GROUP BY track_id HAVING COUNT(*) > 1;

SELECT track_id, COUNT(*) FROM low_popularity
GROUP BY track_id HAVING COUNT(*) > 1;

-- ================================================
-- STEP 4: EXPLORATORY ANALYSIS
-- ================================================

-- Overall averages per tier
SELECT AVG(energy), AVG(tempo), AVG(track_popularity)
FROM high_popularity;

SELECT AVG(energy), AVG(tempo), AVG(track_popularity)
FROM low_popularity;

-- Top 5 genres by track count
SELECT COUNT(*) AS track_count, playlist_genre
FROM high_popularity
GROUP BY playlist_genre
ORDER BY track_count DESC
LIMIT 5;

SELECT COUNT(*) AS track_count, playlist_genre
FROM low_popularity
GROUP BY playlist_genre
ORDER BY track_count DESC
LIMIT 5;

-- Average popularity by genre
SELECT ROUND(AVG(track_popularity),2) AS popularity_score, playlist_genre
FROM high_popularity
GROUP BY playlist_genre
ORDER BY popularity_score DESC;

SELECT ROUND(AVG(track_popularity),2) AS popularity_score, playlist_genre
FROM low_popularity
GROUP BY playlist_genre
ORDER BY popularity_score DESC;

-- Energy tier vs popularity
SELECT
    CASE
        WHEN energy < 0.4 THEN 'Low Energy'
        WHEN energy BETWEEN 0.4 AND 0.7 THEN 'Mid Energy'
        ELSE 'High Energy'
    END AS energy_tier,
    ROUND(AVG(track_popularity), 2) AS avg_popularity,
    COUNT(*) AS track_count
FROM high_popularity
GROUP BY energy_tier
ORDER BY avg_popularity DESC;

-- High vs low feature comparison
SELECT 'high' AS popularity_tier,
    ROUND(AVG(energy), 3) AS avg_energy,
    ROUND(AVG(tempo), 2) AS avg_tempo,
    ROUND(AVG(danceability), 3) AS avg_danceability,
    ROUND(AVG(valence), 3) AS avg_valence,
    ROUND(AVG(loudness), 2) AS avg_loudness,
    ROUND(AVG(acousticness), 3) AS avg_acousticness
FROM high_popularity
UNION ALL
SELECT 'low' AS popularity_tier,
    ROUND(AVG(energy), 3),
    ROUND(AVG(tempo), 2),
    ROUND(AVG(danceability), 3),
    ROUND(AVG(valence), 3),
    ROUND(AVG(loudness), 2),
    ROUND(AVG(acousticness), 3)
FROM low_popularity;

-- ================================================
-- STEP 5: ADVANCED ANALYSIS
-- ================================================

-- CTE: Genre summary stats high popularity
WITH genre_stats AS (
    SELECT playlist_genre,
           ROUND(AVG(track_popularity),2) AS avg_popularity,
           ROUND(AVG(energy),3) AS avg_energy,
           COUNT(*) AS track_count
    FROM high_popularity
    GROUP BY playlist_genre
)
SELECT * FROM genre_stats
ORDER BY avg_popularity DESC;

-- CTE: Genre summary stats low popularity
WITH genre_stats_low AS (
    SELECT playlist_genre,
           ROUND(AVG(track_popularity),2) AS avg_popularity,
           ROUND(AVG(energy),3) AS avg_energy,
           COUNT(*) AS track_count
    FROM low_popularity
    GROUP BY playlist_genre
)
SELECT * FROM genre_stats_low
ORDER BY avg_popularity DESC;

-- Top 10 most popular tracks high popularity
SELECT track_name, track_artist, track_popularity,
       RANK() OVER (ORDER BY track_popularity DESC) AS popularity_rank
FROM high_popularity
LIMIT 10;

-- Top 10 most popular tracks low popularity
SELECT track_name, track_artist, track_popularity,
       RANK() OVER (ORDER BY track_popularity DESC) AS popularity_rank
FROM low_popularity
LIMIT 10;

-- ================================================
-- STEP 6: COMBINED GENRE STATS FOR TABLEAU
-- ================================================

SELECT playlist_genre,
       ROUND(AVG(track_popularity),2) AS avg_popularity,
       ROUND(AVG(energy),3) AS avg_energy,
       COUNT(*) AS track_count,
       'high' AS popularity_tier
FROM high_popularity
GROUP BY playlist_genre

UNION ALL

SELECT playlist_genre,
       ROUND(AVG(track_popularity),2) AS avg_popularity,
       ROUND(AVG(energy),3) AS avg_energy,
       COUNT(*) AS track_count,
       'low' AS popularity_tier
FROM low_popularity
GROUP BY playlist_genre
ORDER BY popularity_tier, avg_popularity DESC;