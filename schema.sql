/* Database schema to keep the structure of entire database. */

-- We will use an artificial PK
CREATE TABLE animals(
  id                INT GENERATED ALWAYS AS IDENTITY,
  name              VARCHAR(250),
  date_of_birth     date,
  escape_attempts   INT,
  neutered          boolean,
  weight_kg         DECIMAL(5,2),
  species           VARCHAR(250),
  PRIMARY KEY(id)
);

CREATE TABLE owners (
    id              SERIAL PRIMARY KEY,
    full_name       VARCHAR,
    age             INTEGER
);

CREATE TABLE species (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR
);    

-- Step 1: Drop the primary key constraint (if exists)
ALTER TABLE animals DROP CONSTRAINT IF EXISTS animals_pkey;

-- Step 2: Add a new serial column and set it as primary key
ALTER TABLE animals
    ADD COLUMN new_id SERIAL PRIMARY KEY;

-- Step 3: Update the new column with the values from the original 'id' column
UPDATE animals
SET new_id = id;

-- Step 4: Drop the original 'id' column
ALTER TABLE animals
    DROP COLUMN id;

-- Step 5: Rename the new column to 'id'
ALTER TABLE animals
    RENAME COLUMN new_id TO id;

-- Step 6: Remove 'species' column
ALTER TABLE animals
    DROP COLUMN IF EXISTS species;

-- Step 7: Add 'species_id' and 'owner_id' columns as foreign keys
ALTER TABLE animals
    ADD COLUMN species_id INTEGER REFERENCES species(id),
    ADD COLUMN owner_id INTEGER REFERENCES owners(id);


CREATE TABLE vets (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR,
    age             INTEGER,
    date_of_graduation date
);

CREATE TABLE specializations (
    vet_id INTEGER REFERENCES vets(id),
    species_id INTEGER REFERENCES species(id),
    PRIMARY KEY (vet_id, species_id)
);

-- Create a unique constraint on the animals table
ALTER TABLE animals ADD CONSTRAINT unique_animal_id UNIQUE (id);

-- Create the visits table
CREATE TABLE visits (
    animal_id INTEGER REFERENCES animals(id),
    vet_id INTEGER REFERENCES vets(id),
    visit_date DATE,
    PRIMARY KEY (animal_id, vet_id, visit_date)
);

