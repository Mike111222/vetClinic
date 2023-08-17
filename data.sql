/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Agumon', '03-02-2020', 0, true, 10.23);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Gabumon', '15-11-2018', 2, true, 8);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Pikachu', '07-01-2021', 1, false, 15.04);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Devimon', '12-05-2017', 5, true, 11);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Charmander', '02-08-2020', 0, false, -11);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Plantmon', '15-11-2021', 2, true, -5.7);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Squirtle', '02-04-1993', 3, false, -12.13);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Angemon', '12-06-2005', 1, true, -45);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Boarmon', '07-06-2005', 7, true, 20.4);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Blossom', '13-10-1998', 3, true, 17);
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg) VALUES ('Ditto', '14-05-2022', 4, true, 22);

-- owners table modifications

INSERT INTO owners (full_name, age) VALUES ('Sam Smith', 34);
INSERT INTO owners (full_name, age) VALUES ('Jennifer Orwell', 19);
INSERT INTO owners (full_name, age) VALUES ('Bob', 45);
INSERT INTO owners (full_name, age) VALUES ('Melody Pond', 77);
INSERT INTO owners (full_name, age) VALUES ('Dean Winchester', 14);
INSERT INTO owners (full_name, age) VALUES ('Jodie Whittaker', 38);

-- species table modifications

INSERT INTO species (name) VALUES ('Pokemon');
INSERT INTO species (name) VALUES ('Digimon');

-- animals table modifications

-- Update species_id based on name
UPDATE animals
SET species_id = CASE
    WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
    ELSE (SELECT id FROM species WHERE name = 'Pokemon')
    END;
-- Update owner_id based on owner's full name
UPDATE animals
SET owner_id = (
    CASE
        WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
        WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
        WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
        WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
        WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
    END
);

-- Verify the changes
SELECT * FROM animals;

-- vets table modifications

INSERT INTO vets (name, age, date_of_graduation) VALUES ('William Tatcher', 45, '23-04-2000');
INSERT INTO vets (name, age, date_of_graduation) VALUES ('Maisy Smith', 26, '17-01-2019');
INSERT INTO vets (name, age, date_of_graduation) VALUES ('Stephanie Mendez', 64, '04-05-1981');
INSERT INTO vets (name, age, date_of_graduation) VALUES ('Jack Harkness', 38, '08-06-2008');

-- specializations table modifications

-- Insert specialization data
INSERT INTO specializations (vet_id, species_id)
VALUES
    (1, 1), -- Vet William Tatcher specialized in Pokemon
    (3, 2), -- Vet Stephanie Mendez specialized in Digimon
    (3, 1), -- Vet Stephanie Mendez specialized in Pokemon
    (4, 2); -- Vet Jack Harkness specialized in Digimon

-- visits table modifications
-- Insert visit data
INSERT INTO visits (animal_id, vet_id, visit_date)
VALUES
    (1, 1, '2020-05-24'), -- Agumon visited William Tatcher on May 24th, 2020
    (1, 3, '2020-07-22'), -- Agumon visited Stephanie Mendez on Jul 22th, 2020
    (2, 4, '2021-02-02'), -- Gabumon visited Jack Harkness on Feb 2nd, 2021
    (3, 2, '2020-01-05'), -- Pikachu visited Maisy Smith on Jan 5th, 2020
    (3, 2, '2020-03-08'), -- Pikachu visited Maisy Smith on Mar 8th, 2020
    (3, 2, '2020-05-14'), -- Pikachu visited Maisy Smith on May 14th, 2020
    (4, 3, '2021-05-04'), -- Devimon visited Stephanie Mendez on May 4th, 2021
    (9, 4, '2021-02-24'), -- Charmander visited Jack Harkness on Feb 24th, 2021
    (6, 2, '2019-12-21'), -- Plantmon visited Maisy Smith on Dec 21st, 2019
    (6, 1, '2020-08-10'), -- Plantmon visited William Tatcher on Aug 10th, 2020
    (6, 2, '2021-04-07'), -- Plantmon visited Maisy Smith on Apr 7th, 2021
    (7, 3, '2019-09-29'), -- Squirtle visited Stephanie Mendez on Sep 29th, 2019
    (8, 4, '2020-10-03'), -- Angemon visited Jack Harkness on Oct 3rd, 2020
    (8, 4, '2020-11-04'), -- Angemon visited Jack Harkness on Nov 4th, 2020
    (9, 2, '2019-01-24'), -- Boarmon visited Maisy Smith on Jan 24th, 2019
    (9, 2, '2019-05-15'), -- Boarmon visited Maisy Smith on May 15th, 2019
    (9, 2, '2020-02-27'), -- Boarmon visited Maisy Smith on Feb 27th, 2020
    (9, 2, '2020-08-03'), -- Boarmon visited Maisy Smith on Aug 3rd, 2020
    (10, 3, '2020-05-24'), -- Blossom visited Stephanie Mendez on May 24th, 2020
    (10, 1, '2021-01-11'); -- Blossom visited William Tatcher on Jan 11th, 2021
