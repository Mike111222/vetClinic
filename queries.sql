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

-- Write queries (using JOIN) to answer the following questions:
-- What animals belong to Melody Pond?
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

-- List all owners and their animals, including those that don't own any animal.
SELECT o.full_name, a.name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

-- How many animals are there per species?
SELECT s.name, COUNT(*) AS animal_count
FROM species s
LEFT JOIN animals a ON s.id = a.species_id
GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell.

SELECT a.name
FROM animals a
JOIN species s ON a.species_id = s.id
JOIN owners o ON a.owner_id = o.id
WHERE s.name = 'Digimon' AND o.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- Who owns the most animals?
SELECT o.full_name, COUNT(a.id) AS animal_count
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT a.name AS animal_name, v.name AS vet_name, vi.visit_date
FROM visits vi
JOIN animals a ON vi.animal_id = a.id
JOIN vets v ON vi.vet_id = v.id
WHERE vi.vet_id = 1
ORDER BY vi.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animal_id) AS num_animals_seen
FROM visits
WHERE vet_id = 3;

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, s.name AS specialty_name
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animal_name, vi.visit_date
FROM visits vi
JOIN animals a ON vi.animal_id = a.id
JOIN vets v ON vi.vet_id = v.id
WHERE v.name = 'Stephanie Mendez'
  AND vi.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.name AS animal_name, COUNT(vi.animal_id) AS num_visits
FROM visits vi
JOIN animals a ON vi.animal_id = a.id
GROUP BY a.name
ORDER BY num_visits DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT v.name AS vet_name, vi.visit_date
FROM visits vi
JOIN vets v ON vi.vet_id = v.id
WHERE vi.animal_id IN (
    SELECT id
    FROM animals
    WHERE owner_id = 2
)
ORDER BY vi.visit_date ASC
LIMIT 1;

-- Details for the most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, v.name AS vet_name, vi.visit_date
FROM visits vi
JOIN animals a ON vi.animal_id = a.id
JOIN vets v ON vi.vet_id = v.id
ORDER BY vi.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS num_visits_without_specialization
FROM visits vi
JOIN animals a ON vi.animal_id = a.id
JOIN vets v ON vi.vet_id = v.id
LEFT JOIN specializations sp ON v.id = sp.vet_id AND a.species_id = sp.species_id
WHERE sp.vet_id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS most_common_species
FROM visits vi
JOIN animals a ON vi.animal_id = a.id
JOIN species s ON a.species_id = s.id
WHERE a.owner_id = 2
GROUP BY s.name
ORDER BY COUNT(*) DESC
LIMIT 1;
