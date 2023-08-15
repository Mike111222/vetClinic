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
