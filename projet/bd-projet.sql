DROP SCHEMA IF EXISTS legos CASCADE;
CREATE SCHEMA IF NOT EXISTS legos;
SET search_path TO legos;

CREATE TABLE ASSEMBLAGE (
  PRIMARY KEY (id_B, nom_C),
  id_B  VARCHAR(42) NOT NULL,
  nom_C VARCHAR(42) NOT NULL
);

CREATE TABLE Brique (
  PRIMARY KEY (id_B),
  id_B      VARCHAR(42) NOT NULL,
  nom_B     VARCHAR(42),
  largeur   VARCHAR(42),
  longueur  VARCHAR(42),
  hauteur   VARCHAR(42),
  forme     VARCHAR(42),
  couleur   VARCHAR(42),
  mots_cles VARCHAR(42),
  ville     VARCHAR(42) NOT NULL,
  quantite  VARCHAR(42)
);

CREATE TABLE Configuration (
  PRIMARY KEY (propiete),
  propiete   VARCHAR(42) NOT NULL,
  valeur     VARCHAR(42),
  date_debut VARCHAR(42) NOT NULL
);

CREATE TABLE Construction (
  nom_C          VARCHAR(42) PRIMARY KEY,
  theme          VARCHAR(42),
  description_C  VARCHAR(42),
  anne_C         VARCHAR(42),
  dimmension     VARCHAR(42),
  sexe           INTEGER NOT NULL CHECK (sexe >= 0),
  Code_O         VARCHAR(42),
  age_recommende VARCHAR(42),
  nom_O          VARCHAR(42),
  prix_O         VARCHAR(42),
  nom_A          VARCHAR(42),
  license        VARCHAR(42)
);

CREATE TABLE Etape (
  PRIMARY KEY (numero),
  numero      VARCHAR(42) NOT NULL,
  image       VARCHAR(42),
  instruction VARCHAR(42),
  nom_C       VARCHAR(42) NOT NULL
);

CREATE TABLE Joueuses (
  PRIMARY KEY (prenom_J),
  prenom_J         VARCHAR(42) NOT NULL,
  date_inscription VARCHAR(42),
  avatar           VARCHAR(42)
);

CREATE TABLE Partie (
  PRIMARY KEY (date_debut),
  date_debut VARCHAR(42) NOT NULL,
  date_fin   VARCHAR(42)
);

CREATE TABLE Photo (
  PRIMARY KEY (titre),
  titre         VARCHAR(42) NOT NULL,
  description_P VARCHAR(42),
  chemin        VARCHAR(42),
  id_B          VARCHAR(42) NOT NULL,
  UNIQUE (id_B)
);

CREATE TABLE SCORES (
  PRIMARY KEY (date_debut, prenom_J),
  date_debut VARCHAR(42) NOT NULL,
  prenom_J   VARCHAR(42) NOT NULL,
  score      VARCHAR(42)
);

CREATE TABLE Substitution (
  PRIMARY KEY (id_S),
  id_S        VARCHAR(42) NOT NULL,
  nom_S       VARCHAR(42),
  commentaire VARCHAR(42),
  id_B        VARCHAR(42) NOT NULL
);

CREATE TABLE Tour (
  PRIMARY KEY (numero_T),
  numero_T           VARCHAR(42) NOT NULL,
  date_debut         VARCHAR(42) NOT NULL,
  prenom_J           VARCHAR(42) NOT NULL,
  id_B               VARCHAR(42) NOT NULL,
  description_Action VARCHAR(42)
);

CREATE TABLE Usine (
  PRIMARY KEY (ville),
  ville VARCHAR(42) NOT NULL,
  pays  VARCHAR(42)
);

ALTER TABLE ASSEMBLAGE ADD FOREIGN KEY (nom_C) REFERENCES Construction (nom_C);
ALTER TABLE ASSEMBLAGE ADD FOREIGN KEY (id_B) REFERENCES Brique (id_B);

ALTER TABLE Brique ADD FOREIGN KEY (ville) REFERENCES Usine (ville);

ALTER TABLE Configuration ADD FOREIGN KEY (date_debut) REFERENCES Partie (date_debut);

ALTER TABLE Etape ADD FOREIGN KEY (nom_C) REFERENCES Construction (nom_C);

ALTER TABLE Photo ADD FOREIGN KEY (id_B) REFERENCES Brique (id_B);

ALTER TABLE SCORES ADD FOREIGN KEY (prenom_J) REFERENCES Joueuses (prenom_J);
ALTER TABLE SCORES ADD FOREIGN KEY (date_debut) REFERENCES Partie (date_debut);

ALTER TABLE Substitution ADD FOREIGN KEY (id_B) REFERENCES Brique (id_B);

ALTER TABLE Tour ADD FOREIGN KEY (id_B) REFERENCES Brique (id_B);
ALTER TABLE Tour ADD FOREIGN KEY (prenom_J) REFERENCES Joueuses (prenom_J);
ALTER TABLE Tour ADD FOREIGN KEY (date_debut) REFERENCES Partie (date_debut);


-- Step 1: Insert into Usine
INSERT INTO Usine (ville, pays) VALUES 
    ('Lille', 'France'), 
    ('Berlin', 'Germany');

-- Step 2: Insert into Brique (Brique has a foreign key reference to Usine)
INSERT INTO Brique (id_B, nom_B, largeur, longueur, hauteur, forme, couleur, mots_cles, ville, quantite) 
VALUES 
    ('B1', 'Red Brick', '2.5', '5.0', '1.5', 'rectangle', 'red', 'structure', 'Lille', '1000'),
    ('B2', 'Blue Block', '3.0', '3.0', '3.0', 'cube', 'blue', 'block', 'Berlin', '500');

-- Step 3: Insert into Partie
INSERT INTO Partie (date_debut, date_fin) 
VALUES 
    ('2023-01-01', '2023-01-10'), 
    ('2023-01-15', '2023-02-15');

-- Step 4: Insert into Configuration (Configuration references date_debut in Partie)
INSERT INTO Configuration (propiete, valeur, date_debut) 
VALUES 
    ('Lighting', 'LED lights', '2023-01-01'), 
    ('Difficulty', 'Intermediate', '2023-01-15');

-- Step 5: Insert into Construction
INSERT INTO Construction (nom_C, theme, description_C, anne_C, dimmension, sexe, Code_O, age_recommende, nom_O, prix_O, nom_A, license) 
VALUES 
    ('Castle', 'Medieval', 'Castle with towers', '2020', '50x50x30 cm', 1, '101', '8+', 'Official Castle Kit', '29.99', NULL, NULL),
    ('Spaceship', 'Sci-Fi', 'Spaceship model', '2021', '60x30x20 cm', 0, NULL, NULL, NULL, NULL, 'Sam', 'L12345');

-- Step 6: Insert into ASSEMBLAGE (ASSEMBLAGE references both Brique and Construction)
INSERT INTO ASSEMBLAGE (id_B, nom_C) 
VALUES 
    ('B1', 'Castle'), 
    ('B2', 'Spaceship');

-- Step 7: Insert into Etape (Etape references Construction)
INSERT INTO Etape (numero, image, instruction, nom_C) 
VALUES 
    ('1', '/images/step1.jpg', 'Start with the base', 'Castle'), 
    ('2', '/images/step2.jpg', 'Add walls', 'Castle'),
    ('3', '/images/step3.jpg', 'Place cockpit', 'Spaceship');

-- Step 8: Insert into Joueuses
INSERT INTO Joueuses (prenom_J, date_inscription, avatar) 
VALUES 
    ('Alice', '2022-05-01', '/avatars/alice.jpg'), 
    ('Bob', '2023-01-20', '/avatars/bob.jpg');

-- Step 9: Insert into Photo (Photo references Brique)
INSERT INTO Photo (titre, description_P, chemin, id_B) 
VALUES 
    ('Main Photo', 'Main image of the brick set', '/images/main_photo.jpg', 'B1'),
    ('Detail Shot', 'Close-up of the blue block', '/images/blue_block.jpg', 'B2');

-- Step 10: Insert into SCORES (SCORES references Partie and Joueuses)
INSERT INTO SCORES (date_debut, prenom_J, score) 
VALUES 
    ('2023-01-01', 'Alice', '85'), 
    ('2023-01-15', 'Bob', '90');

-- Step 11: Insert into Substitution (Substitution references Brique)
INSERT INTO Substitution (id_S, nom_S, commentaire, id_B) 
VALUES 
    ('S1', 'Alternate Red Brick', 'Use this if Red Brick is unavailable', 'B1'),
    ('S2', 'Alternate Blue Block', 'Can replace Blue Block for stability', 'B2');

-- Step 12: Insert into Tour (Tour references Partie, Joueuses, and Brique)
INSERT INTO Tour (numero_T, date_debut, prenom_J, id_B, description_Action) 
VALUES 
    ('1', '2023-01-01', 'Alice', 'B1', 'défaussée'), 
    ('2', '2023-01-15', 'Bob','B2', 'placée');
