/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals
WHERE name LIKE '%mon';
SELECT name FROM animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals
WHERE neutered = TRUE AND escape_attempts < 3;
SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;
SELECT * FROM animals
WHERE neutered = TRUE;
SELECT * FROM animals
WHERE name != 'Gabumon';
SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;


-- Setting species = 'unspecified' with a transaction;

-- Step 1: Begin the transaction
BEGIN;

-- Step 2: Update the species column to 'unspecified'
UPDATE animals
SET species = 'unspecified';

-- Step 3: Verify the change
SELECT * FROM animals;

-- Step 4: Roll back the transaction
ROLLBACK;

-- Step 5: Verify that the species column values are reverted
SELECT * FROM animals;

-- Inside a transaction:
-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
-- Verify that changes were made.
-- Commit the transaction.
-- Verify that changes persist after commit.

-- Step 1: Begin the transaction
BEGIN;

-- Step 2: Update the species column to 'digimon' for animals with names ending in 'mon'
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

-- Step 3: Update the species column to 'pokemon' for animals with no species already set
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

-- Step 4: Verify the changes
SELECT * FROM animals;

-- Step 5: Commit the transaction
COMMIT;

-- Step 6: Verify that changes persist after commit
SELECT * FROM animals;

-- Inside a transaction delete all records in the animals table, then roll back the transaction.

-- Step 1: Begin the transaction
BEGIN;

-- Step 2: Delete all records from the animals table
DELETE FROM animals;

-- Step 3: Verify that records are deleted
SELECT * FROM animals;

-- Step 4: Roll back the transaction
ROLLBACK;

-- Step 5: Verify that records are restored after rollback
SELECT * FROM animals;


-- Inside a transaction:
-- Delete all animals born after Jan 1st, 2022.
-- Create a savepoint for the transaction.
-- Update all animals' weight to be their weight multiplied by -1.
-- Rollback to the savepoint
-- Update all animals' weights that are negative to be their weight multiplied by -1.
-- Commit transaction

-- Step 1: Begin the transaction
BEGIN;

-- Step 2: Delete all animals born after Jan 1st, 2022
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

-- Step 3: Create a savepoint
SAVEPOINT my_savepoint;

-- Step 4: Update all animals' weight to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1;

-- Step 5: Rollback to the savepoint
ROLLBACK TO my_savepoint;

-- Step 6: Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

-- Step 7: Commit the transaction
COMMIT;

-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals
WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) AS total_escape_attempts
FROM animals
GROUP BY neutered
ORDER BY total_escape_attempts DESC
LIMIT 1;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

