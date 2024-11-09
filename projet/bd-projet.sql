-- Table: Photo
CREATE TABLE Photo (
    titre VARCHAR(255) PRIMARY KEY,
    descriptionP TEXT,
    chemin VARCHAR(255)
);

-- Table: Oficielle
CREATE TABLE Oficielle (
    CodeO INT PRIMARY KEY,
    age_recommende INT,
    nomO VARCHAR(255),
    prixO DECIMAL(10, 2)
);

-- Table: Etape
CREATE TABLE Etape (
    numero INT PRIMARY KEY,
    image VARCHAR(255),
    instruction TEXT
);

-- Table: Brique
CREATE TABLE Brique (
    idB INT PRIMARY KEY,
    nomB VARCHAR(255),
    largeur DECIMAL(5, 2),
    longueur DECIMAL(5, 2),
    hauteur DECIMAL(5, 2),
    forme VARCHAR(50),
    couleur VARCHAR(50),
    mots_cles TEXT
);

-- Table: Substitution
CREATE TABLE Substitution (
    idS INT PRIMARY KEY,
    nomS VARCHAR(255),
    commentaire TEXT
);

-- Table: Amateur
CREATE TABLE Amateur (
    nomA VARCHAR(255) PRIMARY KEY,
    license VARCHAR(50)
);

-- Table: Construction
CREATE TABLE Construction (
    nomC VARCHAR(255) PRIMARY KEY,
    theme VARCHAR(100),
    descriptionC TEXT,
    anneC INT,
    dimmension VARCHAR(50)
);

-- Associative Table: Construction_Photo (COMPOSSE relationship between Construction and Etape)
CREATE TABLE Construction_Photo (
    construction_nomC VARCHAR(255),
    etape_numero INT,
    PRIMARY KEY (construction_nomC, etape_numero),
    FOREIGN KEY (construction_nomC) REFERENCES Construction(nomC),
    FOREIGN KEY (etape_numero) REFERENCES Etape(numero)
);

-- Associative Table: Construction_Brique (ASSEMBLAGE relationship between Construction and Brique)
CREATE TABLE Construction_Brique (
    construction_nomC VARCHAR(255),
    brique_idB INT,
    PRIMARY KEY (construction_nomC, brique_idB),
    FOREIGN KEY (construction_nomC) REFERENCES Construction(nomC),
    FOREIGN KEY (brique_idB) REFERENCES Brique(idB)
);

-- Table: Configuration
CREATE TABLE Configuration (
    propiete VARCHAR(255) PRIMARY KEY,
    valeur VARCHAR(255)
);

-- Table: Partie
CREATE TABLE Partie (
    idPartie INT SERIAL PRIMARY KEY,
    date_debut DATE,
    date_fin DATE
);

-- Associative Table: Partie_Configuration (POSSEDE relationship between Partie and Configuration)
CREATE TABLE Partie_Configuration (
    partie_id INT,
    configuration_propiete VARCHAR(255),
    PRIMARY KEY (partie_id, configuration_propiete),
    FOREIGN KEY (partie_id) REFERENCES Partie(idPartie),
    FOREIGN KEY (configuration_propiete) REFERENCES Configuration(propiete)
);

-- Table: Tour
CREATE TABLE Tour (
    numeroT INT PRIMARY KEY
);

-- Associative Table: Partie_Tour (relationship between Partie and Tour)
CREATE TABLE Partie_Tour (
    partie_id INT,
    tour_numeroT INT,
    PRIMARY KEY (partie_id, tour_numeroT),
    FOREIGN KEY (partie_id) REFERENCES Partie(idPartie),
    FOREIGN KEY (tour_numeroT) REFERENCES Tour(numeroT)
);

-- Associative Table: Tour_Brique (ACTION relationship between Tour and Brique)
CREATE TABLE Tour_Brique (
    tour_numeroT INT,
    brique_idB INT,
    descriptionAction TEXT,
    PRIMARY KEY (tour_numeroT, brique_idB),
    FOREIGN KEY (tour_numeroT) REFERENCES Tour(numeroT),
    FOREIGN KEY (brique_idB) REFERENCES Brique(idB)
);

-- Table: Usine
CREATE TABLE Usine (
    ville VARCHAR(100),
    pays VARCHAR(100),
    PRIMARY KEY (ville, pays)
);

-- Associative Table: Brique_Usine (FABRIQUE relationship between Brique and Usine)
CREATE TABLE Brique_Usine (
    brique_idB INT,
    usine_ville VARCHAR(100),
    usine_pays VARCHAR(100),
    quantite INT,
    PRIMARY KEY (brique_idB, usine_ville, usine_pays),
    FOREIGN KEY (brique_idB) REFERENCES Brique(idB),
    FOREIGN KEY (usine_ville, usine_pays) REFERENCES Usine(ville, pays)
);

-- Table: Joueuses
CREATE TABLE Joueuses (
    prenomJ VARCHAR(255) PRIMARY KEY,
    date_inscription DATE,
    avatar VARCHAR(255)
);

-- Associative Table: Partie_Joueuses (relationship between Partie and Joueuses)
CREATE TABLE Partie_Joueuses (
    partie_id INT,
    joueuse_prenomJ VARCHAR(255),
    PRIMARY KEY (partie_id, joueuse_prenomJ),
    FOREIGN KEY (partie_id) REFERENCES Partie(idPartie),
    FOREIGN KEY (joueuse_prenomJ) REFERENCES Joueuses(prenomJ)
);

-- Associative Table: Scores (SCORES relationship between Partie and Joueuses)
CREATE TABLE Scores (
    partie_id INT,
    joueuse_prenomJ VARCHAR(255),
    score INT,
    PRIMARY KEY (partie_id, joueuse_prenomJ),
    FOREIGN KEY (partie_id) REFERENCES Partie(idPartie),
    FOREIGN KEY (joueuse_prenomJ) REFERENCES Joueuses(prenomJ)
);

-- Associative Table: Brique_Substitution (SUBS relationship between Brique and Substitution)
CREATE TABLE Brique_Substitution (
    brique_idB INT,
    substitution_idS INT,
    PRIMARY KEY (brique_idB, substitution_idS),
    FOREIGN KEY (brique_idB) REFERENCES Brique(idB),
    FOREIGN KEY (substitution_idS) REFERENCES Substitution(idS)
);

-- Insert examples for Photo
INSERT INTO Photo (titre, descriptionP, chemin)
VALUES 
    ('Main Photo', 'Main image of the set', '/images/main_photo.jpg'),
    ('Brick Detail', 'Close-up of the brick piece', '/images/brick_detail.jpg');

-- Insert examples for Oficielle
INSERT INTO Oficielle (CodeO, age_recommende, nomO, prixO)
VALUES 
    (101, 8, 'Official Construction Set 1', 29.99),
    (102, 12, 'Advanced Building Kit', 49.99);

-- Insert examples for Etape
INSERT INTO Etape (numero, image, instruction)
VALUES 
    (1, '/images/step1.jpg', 'Start with the base piece'),
    (2, '/images/step2.jpg', 'Add the second layer'),
    (3, '/images/step3.jpg', 'Attach the small pieces on top');

-- Insert examples for Brique
INSERT INTO Brique (idB, nomB, largeur, longueur, hauteur, forme, couleur, mots_cles)
VALUES 
    (1, 'Red Brick', 2.5, 5.0, 1.5, 'rectangle', 'red', 'basic,structure'),
    (2, 'Blue Block', 3.0, 3.0, 3.0, 'cube', 'blue', 'block,support'),
    (3, 'Green Plate', 1.0, 4.0, 0.5, 'flat', 'green', 'foundation,layer');

-- Insert examples for Substitution
INSERT INTO Substitution (idS, nomS, commentaire)
VALUES 
    (1, 'Alternate Red Brick', 'Can substitute for Red Brick if unavailable'),
    (2, 'Alternate Green Plate', 'Slightly different size but fits the same role');

-- Insert examples for Amateur
INSERT INTO Amateur (nomA, license)
VALUES 
    ('Builder Joe', 'L12345'),
    ('Creative Sam', 'L67890');

-- Insert examples for Construction
INSERT INTO Construction (nomC, theme, descriptionC, anneC, dimmension)
VALUES 
    ('Castle Build', 'Medieval', 'A model castle with towers and walls', 2020, '50x50x30 cm'),
    ('Spaceship', 'Sci-Fi', 'A futuristic spacecraft with modular design', 2021, '60x30x20 cm');

-- Example relationships for Construction_Photo
INSERT INTO Construction_Photo (construction_nomC, etape_numero)
VALUES 
    ('Castle Build', 1),
    ('Castle Build', 2),
    ('Spaceship', 1),
    ('Spaceship', 3);

-- Example relationships for Construction_Brique (ASSEMBLAGE)
INSERT INTO Construction_Brique (construction_nomC, brique_idB)
VALUES 
    ('Castle Build', 1),
    ('Castle Build', 2),
    ('Spaceship', 2),
    ('Spaceship', 3);

-- Insert examples for Configuration
INSERT INTO Configuration (propiete, valeur)
VALUES 
    ('Lighting', 'LED lights'),
    ('Difficulty', 'Intermediate');

-- Insert examples for Partie
INSERT INTO Partie (date_debut, date_fin)
VALUES 
    ('2023-01-01', '2023-01-10'),
    ('2023-02-15', '2023-02-20');

-- Example relationships for Partie_Configuration (POSSEDE)
INSERT INTO Partie_Configuration (partie_id, configuration_propiete)
VALUES 
    (1, 'Lighting'),
    (1, 'Difficulty');

-- Insert examples for Tour
INSERT INTO Tour (numeroT)
VALUES 
    (1),
    (2);

-- Example relationships for Partie_Tour
INSERT INTO Partie_Tour (partie_id, tour_numeroT)
VALUES 
    (1, 1),
    (1, 2);

-- Example relationships for Tour_Brique (ACTION)
INSERT INTO Tour_Brique (tour_numeroT, brique_idB, descriptionAction)
VALUES 
    (1, 1, 'Add a red brick to the base'),
    (2, 2, 'Place a blue block on the red brick');

-- Insert examples for Usine
INSERT INTO Usine (ville, pays)
VALUES 
    ('Lille', 'France'),
    ('Berlin', 'Germany');

-- Example relationships for Brique_Usine (FABRIQUE)
INSERT INTO Brique_Usine (brique_idB, usine_ville, usine_pays, quantite)
VALUES 
    (1, 'Lille', 'France', 500),
    (2, 'Berlin', 'Germany', 300);

-- Insert examples for Joueuses
INSERT INTO Joueuses (prenomJ, date_inscription, avatar)
VALUES 
    ('Alice', '2022-05-01', '/avatars/alice.jpg'),
    ('Bob', '2023-01-20', '/avatars/bob.jpg');

-- Example relationships for Partie_Joueuses
INSERT INTO Partie_Joueuses (partie_id, joueuse_prenomJ)
VALUES 
    (1, 'Alice'),
    (2, 'Bob');

-- Example relationships for Scores (SCORES)
INSERT INTO Scores (partie_id, joueuse_prenomJ, score)
VALUES 
    (1, 'Alice', 95),
    (2, 'Bob', 88);

-- Example relationships for Brique_Substitution (SUBS)
INSERT INTO Brique_Substitution (brique_idB, substitution_idS)
VALUES 
    (1, 1),
    (3, 2);
