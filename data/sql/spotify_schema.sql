-- Step 1: Create the database (if it doesn't exist already)
CREATE DATABASE IF NOT EXISTS `spotify_project`;

-- Step 2: Select the newly created database
USE `spotify_project`;

-- Step 3: Create the tables and set up foreign keys

DROP TABLE IF EXISTS `music_festivals`;
CREATE TABLE `music_festivals`(
    `festival_id` BIGINT UNSIGNED NOT NULL,  -- Changed to BIGINT UNSIGNED to match festivals_genres
    `demographic_id` BIGINT NOT NULL,  -- Changed to BIGINT
    `country_id` BIGINT NOT NULL,
    `attendance` VARCHAR(255) NOT NULL,
    `economic_impact` BIGINT NOT NULL,
    `genre_id` BIGINT NOT NULL,
    PRIMARY KEY(`festival_id`)
);

DROP TABLE IF EXISTS `songs`;
CREATE TABLE `songs`(
    `spotify_id` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `is_explicit` BOOLEAN NOT NULL,
    `album_id` BIGINT NOT NULL,
    `artist_name` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`spotify_id`)
);

DROP TABLE IF EXISTS `albums`;
CREATE TABLE `albums`(
    `album_id` BIGINT NOT NULL,
    `album_name` VARCHAR(255) NOT NULL,
    `album_release_date` DATE NOT NULL,
    PRIMARY KEY(`album_id`)
);

DROP TABLE IF EXISTS `songs_features`;
CREATE TABLE `songs_features`(
    `spotify_id` VARCHAR(255) NOT NULL,
    `danceability` FLOAT(53) NOT NULL,
    `energy` FLOAT(53) NOT NULL,
    `loudness` FLOAT(53) NOT NULL,
    PRIMARY KEY(`spotify_id`)
);

DROP TABLE IF EXISTS `rankings`;
CREATE TABLE `rankings`(
    `spotify_id` VARCHAR(255) NOT NULL,
    `snapshot_date` DATE NOT NULL,
    `country_id` BIGINT NOT NULL,
    `daily_rank` BIGINT NOT NULL,
    `daily_movement` BIGINT NOT NULL,
    `weekly_movement` BIGINT NOT NULL,
    `popularity` BIGINT NOT NULL,
    PRIMARY KEY(`spotify_id`)
);

DROP TABLE IF EXISTS `region`;
CREATE TABLE `region`(
    `country_id` BIGINT NOT NULL,
    `country` VARCHAR(255) NOT NULL,
    `currency` VARCHAR(1) NOT NULL,
    PRIMARY KEY(`country_id`)
);

-- Add an index on country_id in the region table
CREATE INDEX `idx_country_id` ON `region`(`country_id`);

DROP TABLE IF EXISTS `demographics`;
CREATE TABLE `demographics`(
    `demographic_id` BIGINT NOT NULL,  -- Make sure demographic_id is BIGINT
    `age_group` VARCHAR(255) NOT NULL,
    `visitor_demographic` VARCHAR(255) NOT NULL,
    PRIMARY KEY(`demographic_id`)
);

DROP TABLE IF EXISTS `genres`;
CREATE TABLE `genres`(
    `genre_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,  -- Make sure genre_id is BIGINT UNSIGNED
    `genre` VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS `festivals_genres`;
CREATE TABLE `festivals_genres`(
    `festival_id` BIGINT UNSIGNED NOT NULL,  -- Changed to BIGINT UNSIGNED to match music_festivals
    `genre_id` BIGINT UNSIGNED NOT NULL,  -- Changed to BIGINT UNSIGNED to match genres table
    PRIMARY KEY(`festival_id`, `genre_id`)
);

-- Add foreign key constraints
ALTER TABLE `songs`
ADD CONSTRAINT `songs_album_id_foreign`
FOREIGN KEY (`album_id`) REFERENCES `albums`(`album_id`);

ALTER TABLE `songs`
ADD CONSTRAINT `songs_spotify_id_foreign`
FOREIGN KEY (`spotify_id`) REFERENCES `songs_features`(`spotify_id`);

ALTER TABLE `rankings`
ADD CONSTRAINT `rankings_country_id_foreign`
FOREIGN KEY (`country_id`) REFERENCES `region`(`country_id`);

ALTER TABLE `music_festivals`
ADD CONSTRAINT `music_festivals_demographic_id_foreign`
FOREIGN KEY (`demographic_id`) REFERENCES `demographics`(`demographic_id`);

ALTER TABLE `festivals_genres`
ADD CONSTRAINT `festivals_genres_genre_id_foreign`
FOREIGN KEY (`genre_id`) REFERENCES `genres`(`genre_id`);

ALTER TABLE `music_festivals`
ADD CONSTRAINT `music_festivals_country_id_foreign`
FOREIGN KEY (`country_id`) REFERENCES `region`(`country_id`);

ALTER TABLE `festivals_genres`
ADD CONSTRAINT `festivals_genres_festival_id_foreign`
FOREIGN KEY (`festival_id`) REFERENCES `music_festivals`(`festival_id`);

-- Changed constraint name to avoid duplication
ALTER TABLE `songs`
ADD CONSTRAINT `songs_rankings_spotify_id_foreign`
FOREIGN KEY (`spotify_id`) REFERENCES `rankings`(`spotify_id`);
