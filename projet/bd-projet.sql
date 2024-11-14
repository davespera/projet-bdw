DROP SCHEMA IF EXISTS legos CASCADE;
CREATE SCHEMA IF NOT EXISTS legos;
SET search_path TO legos;

CREATE TABLE ASSEMBLAGE (
  PRIMARY KEY (id_B, nom_C),
  id_B      INTEGER NOT NULL CHECK (id_B >= 0),
  nom_C VARCHAR(42) NOT NULL
);

CREATE TABLE Brique (
  PRIMARY KEY (id_B),
  id_B      INTEGER NOT NULL CHECK (id_B >= 0),
  nom_B     VARCHAR(42),
  largeur   INTEGER NOT NULL CHECK (largeur >= 0),
  longueur  INTEGER NOT NULL CHECK (longueur >= 0),
  hauteur   FLOAT NOT NULL CHECK (hauteur >= 0),
  forme     VARCHAR(42),
  couleur   VARCHAR(20),
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
  id_B      INTEGER NOT NULL CHECK (id_B >= 0),
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
  id_B      INTEGER NOT NULL CHECK (id_B >= 0)
);

CREATE TABLE Tour (
  PRIMARY KEY (numero_T),
  numero_T           VARCHAR(42) NOT NULL,
  date_debut         VARCHAR(42) NOT NULL,
  prenom_J           VARCHAR(42) NOT NULL,
  id_B      INTEGER NOT NULL CHECK (id_B >= 0),
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

CREATE OR REPLACE FUNCTION insert_into_brique(
    p_id_B INT,
    p_longueur INT,
    p_largeur INT,
    p_hauteur FLOAT,
    p_couleur VARCHAR
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO legos.Brique (id_B, nom_B, largeur, longueur, couleur, hauteur, forme, mots_cles, ville, quantite)
    VALUES (p_id_B, NULL, p_largeur, p_longueur, p_couleur, CAST(p_hauteur AS FLOAT), NULL, NULL, 'Berlin', NULL);
END;
$$ LANGUAGE plpgsql;

--Esto petará si se ejecuta 
--SELECT insert_into_brique(1, 1, 1, 1, '#000000');
--SELECT insert_into_brique(2, 2, 1, 1, '#000000');
--SELECT insert_into_brique(3, 3, 1, 1, '#000000');
--SELECT insert_into_brique(4, 4, 1, 1, '#000000');
--SELECT insert_into_brique(5, 6, 1, 1, '#000000');
--SELECT insert_into_brique(6, 8, 1, 1, '#000000');
--SELECT insert_into_brique(7, 10, 1, 1, '#000000');
--SELECT insert_into_brique(8, 12, 1, 1, '#000000');	
--SELECT insert_into_brique(9, 1, 2, 1, '#000000');
--SELECT insert_into_brique(10, 2, 2, 1, '#000000');
--SELECT insert_into_brique(11, 3, 2, 1, '#000000');
--SELECT insert_into_brique(12, 4, 2, 1, '#000000');
--SELECT insert_into_brique(13, 6, 2, 1, '#000000');
--SELECT insert_into_brique(14, 8, 2, 1, '#000000');
--SELECT insert_into_brique(15, 10, 2, 1, '#000000');
--SELECT insert_into_brique(16, 12, 2, 1, '#000000');
--SELECT insert_into_brique(17, 1, 3, 1, '#000000');
--SELECT insert_into_brique(18, 2, 3, 1, '#000000');
--SELECT insert_into_brique(19, 3, 3, 1, '#000000');
--SELECT insert_into_brique(20, 4, 3, 1, '#000000');
--SELECT insert_into_brique(21, 6, 3, 1, '#000000');
--SELECT insert_into_brique(22, 8, 3, 1, '#000000');
--SELECT insert_into_brique(23, 10, 3, 1, '#000000');
--SELECT insert_into_brique(24, 12, 3, 1, '#000000');
--SELECT insert_into_brique(25, 1, 4, 1, '#000000');
--SELECT insert_into_brique(26, 2, 4, 1, '#000000');
--SELECT insert_into_brique(27, 3, 4, 1, '#000000');
--SELECT insert_into_brique(28, 4, 4, 1, '#000000');
--SELECT insert_into_brique(29, 6, 4, 1, '#000000');
--SELECT insert_into_brique(30, 8, 4, 1, '#000000');
--SELECT insert_into_brique(31, 10, 4, 1, '#000000');
--SELECT insert_into_brique(32, 12, 4, 1, '#000000');
--SELECT insert_into_brique(33, 1, 6, 1, '#000000');
--SELECT insert_into_brique(34, 2, 6, 1, '#000000');
--SELECT insert_into_brique(35, 3, 6, 1, '#000000');
--SELECT insert_into_brique(36, 4, 6, 1, '#000000');
--SELECT insert_into_brique(37, 6, 6, 1, '#000000');
--SELECT insert_into_brique(38, 8, 6, 1, '#000000');
--SELECT insert_into_brique(39, 10, 6, 1, '#000000');
--SELECT insert_into_brique(40, 12, 6, 1, '#000000');
--SELECT insert_into_brique(41, 1, 8, 1, '#000000');
--SELECT insert_into_brique(42, 2, 8, 1, '#000000');
--SELECT insert_into_brique(43, 3, 8, 1, '#000000');
--SELECT insert_into_brique(44, 4, 8, 1, '#000000');
--SELECT insert_into_brique(45, 6, 8, 1, '#000000');
--SELECT insert_into_brique(46, 8, 8, 1, '#000000');
--SELECT insert_into_brique(47, 10, 8, 1, '#000000');
--SELECT insert_into_brique(48, 12, 8, 1, '#000000');
--SELECT insert_into_brique(49, 1, 10, 1, '#000000');
--SELECT insert_into_brique(50, 2, 10, 1, '#000000');
--SELECT insert_into_brique(51, 3, 10, 1, '#000000');
--SELECT insert_into_brique(52, 4, 10, 1, '#000000');
--SELECT insert_into_brique(53, 6, 10, 1, '#000000');
--SELECT insert_into_brique(54, 8, 10, 1, '#000000');
--SELECT insert_into_brique(55, 10, 10, 1, '#000000');
--SELECT insert_into_brique(56, 12, 10, 1, '#000000');
--SELECT insert_into_brique(57, 1, 12, 1, '#000000');
--SELECT insert_into_brique(58, 2, 12, 1, '#000000');
--SELECT insert_into_brique(59, 3, 12, 1, '#000000');
--SELECT insert_into_brique(60, 4, 12, 1, '#000000');
--SELECT insert_into_brique(61, 6, 12, 1, '#000000');
--SELECT insert_into_brique(62, 8, 12, 1, '#000000');
--SELECT insert_into_brique(63, 10, 12, 1, '#000000');
--SELECT insert_into_brique(64, 12, 12, 1, '#000000');
--SELECT insert_into_brique(65, 1, 1, 0.33, '#000000');
--SELECT insert_into_brique(66, 2, 1, 0.33, '#000000');
--SELECT insert_into_brique(67, 3, 1, 0.33, '#000000');
--SELECT insert_into_brique(68, 4, 1, 0.33, '#000000');
--SELECT insert_into_brique(69, 6, 1, 0.33, '#000000');
--SELECT insert_into_brique(70, 8, 1, 0.33, '#000000');
--SELECT insert_into_brique(71, 10, 1, 0.33, '#000000');
--SELECT insert_into_brique(72, 12, 1, 0.33, '#000000');
--SELECT insert_into_brique(73, 1, 2, 0.33, '#000000');
--SELECT insert_into_brique(74, 2, 2, 0.33, '#000000');
--SELECT insert_into_brique(75, 3, 2, 0.33, '#000000');
--SELECT insert_into_brique(76, 4, 2, 0.33, '#000000');
--SELECT insert_into_brique(77, 6, 2, 0.33, '#000000');
--SELECT insert_into_brique(78, 8, 2, 0.33, '#000000');
--SELECT insert_into_brique(79, 10, 2, 0.33, '#000000');
--SELECT insert_into_brique(80, 12, 2, 0.33, '#000000');
--SELECT insert_into_brique(81, 1, 3, 0.33, '#000000');
--SELECT insert_into_brique(82, 2, 3, 0.33, '#000000');
--SELECT insert_into_brique(83, 3, 3, 0.33, '#000000');
--SELECT insert_into_brique(84, 4, 3, 0.33, '#000000');
--SELECT insert_into_brique(85, 6, 3, 0.33, '#000000');
--SELECT insert_into_brique(86, 8, 3, 0.33, '#000000');
--SELECT insert_into_brique(87, 10, 3, 0.33, '#000000');
--SELECT insert_into_brique(88, 12, 3, 0.33, '#000000');
--SELECT insert_into_brique(89, 1, 4, 0.33, '#000000');
--SELECT insert_into_brique(90, 2, 4, 0.33, '#000000');
--SELECT insert_into_brique(91, 3, 4, 0.33, '#000000');
--SELECT insert_into_brique(92, 4, 4, 0.33, '#000000');
--SELECT insert_into_brique(93, 6, 4, 0.33, '#000000');
--SELECT insert_into_brique(94, 8, 4, 0.33, '#000000');
--SELECT insert_into_brique(95, 10, 4, 0.33, '#000000');
--SELECT insert_into_brique(96, 12, 4, 0.33, '#000000');
--SELECT insert_into_brique(97, 1, 6, 0.33, '#000000');
--SELECT insert_into_brique(98, 2, 6, 0.33, '#000000');
--SELECT insert_into_brique(99, 3, 6, 0.33, '#000000');
--SELECT insert_into_brique(100, 4, 6, 0.33, '#000000');
--SELECT insert_into_brique(101, 6, 6, 0.33, '#000000');
--SELECT insert_into_brique(102, 8, 6, 0.33, '#000000');
--SELECT insert_into_brique(103, 10, 6, 0.33, '#000000');
--SELECT insert_into_brique(104, 12, 6, 0.33, '#000000');
--SELECT insert_into_brique(105, 1, 8, 0.33, '#000000');
--SELECT insert_into_brique(106, 2, 8, 0.33, '#000000');
--SELECT insert_into_brique(107, 3, 8, 0.33, '#000000');
--SELECT insert_into_brique(108, 4, 8, 0.33, '#000000');
--SELECT insert_into_brique(109, 6, 8, 0.33, '#000000');
--SELECT insert_into_brique(110, 8, 8, 0.33, '#000000');
--SELECT insert_into_brique(111, 10, 8, 0.33, '#000000');
--SELECT insert_into_brique(112, 12, 8, 0.33, '#000000');
--SELECT insert_into_brique(113, 1, 10, 0.33, '#000000');
--SELECT insert_into_brique(114, 2, 10, 0.33, '#000000');
--SELECT insert_into_brique(115, 3, 10, 0.33, '#000000');
--SELECT insert_into_brique(116, 4, 10, 0.33, '#000000');
--SELECT insert_into_brique(117, 6, 10, 0.33, '#000000');
--SELECT insert_into_brique(118, 8, 10, 0.33, '#000000');
--SELECT insert_into_brique(119, 10, 10, 0.33, '#000000');
--SELECT insert_into_brique(120, 12, 10, 0.33, '#000000');
--SELECT insert_into_brique(121, 1, 12, 0.33, '#000000');
--SELECT insert_into_brique(122, 2, 12, 0.33, '#000000');
--SELECT insert_into_brique(123, 3, 12, 0.33, '#000000');
--SELECT insert_into_brique(124, 4, 12, 0.33, '#000000');
--SELECT insert_into_brique(125, 6, 12, 0.33, '#000000');
--SELECT insert_into_brique(126, 8, 12, 0.33, '#000000');
--SELECT insert_into_brique(127, 10, 12, 0.33, '#000000');
--SELECT insert_into_brique(128, 12, 12, 0.33, '#000000');
--SELECT insert_into_brique(129, 1, 1, 1, '#c0c0c0');
--SELECT insert_into_brique(130, 2, 1, 1, '#c0c0c0');
--SELECT insert_into_brique(131, 3, 1, 1, '#c0c0c0');
--SELECT insert_into_brique(132, 4, 1, 1, '#c0c0c0');
--SELECT insert_into_brique(133, 6, 1, 1, '#c0c0c0');
--SELECT insert_into_brique(134, 8, 1, 1, '#c0c0c0');
--SELECT insert_into_brique(135, 10, 1, 1, '#c0c0c0');
--SELECT insert_into_brique(136, 12, 1, 1, '#c0c0c0');
--SELECT insert_into_brique(137, 1, 2, 1, '#c0c0c0');
--SELECT insert_into_brique(138, 2, 2, 1, '#c0c0c0');
--SELECT insert_into_brique(139, 3, 2, 1, '#c0c0c0');
--SELECT insert_into_brique(140, 4, 2, 1, '#c0c0c0');
--SELECT insert_into_brique(141, 6, 2, 1, '#c0c0c0');
--SELECT insert_into_brique(142, 8, 2, 1, '#c0c0c0');
--SELECT insert_into_brique(143, 10, 2, 1, '#c0c0c0');
--SELECT insert_into_brique(144, 12, 2, 1, '#c0c0c0');
--SELECT insert_into_brique(145, 1, 3, 1, '#c0c0c0');
--SELECT insert_into_brique(146, 2, 3, 1, '#c0c0c0');
--SELECT insert_into_brique(147, 3, 3, 1, '#c0c0c0');
--SELECT insert_into_brique(148, 4, 3, 1, '#c0c0c0');
--SELECT insert_into_brique(149, 6, 3, 1, '#c0c0c0');
--SELECT insert_into_brique(150, 8, 3, 1, '#c0c0c0');
--SELECT insert_into_brique(151, 10, 3, 1, '#c0c0c0');
--SELECT insert_into_brique(152, 12, 3, 1, '#c0c0c0');
--SELECT insert_into_brique(153, 1, 4, 1, '#c0c0c0');
--SELECT insert_into_brique(154, 2, 4, 1, '#c0c0c0');
--SELECT insert_into_brique(155, 3, 4, 1, '#c0c0c0');
--SELECT insert_into_brique(156, 4, 4, 1, '#c0c0c0');
--SELECT insert_into_brique(157, 6, 4, 1, '#c0c0c0');
--SELECT insert_into_brique(158, 8, 4, 1, '#c0c0c0');
--SELECT insert_into_brique(159, 10, 4, 1, '#c0c0c0');
--SELECT insert_into_brique(160, 12, 4, 1, '#c0c0c0');
--SELECT insert_into_brique(161, 1, 6, 1, '#c0c0c0');
--SELECT insert_into_brique(162, 2, 6, 1, '#c0c0c0');
--SELECT insert_into_brique(163, 3, 6, 1, '#c0c0c0');
--SELECT insert_into_brique(164, 4, 6, 1, '#c0c0c0');
--SELECT insert_into_brique(165, 6, 6, 1, '#c0c0c0');
--SELECT insert_into_brique(166, 8, 6, 1, '#c0c0c0');
--SELECT insert_into_brique(167, 10, 6, 1, '#c0c0c0');
--SELECT insert_into_brique(168, 12, 6, 1, '#c0c0c0');
--SELECT insert_into_brique(169, 1, 8, 1, '#c0c0c0');
--SELECT insert_into_brique(170, 2, 8, 1, '#c0c0c0');
--SELECT insert_into_brique(171, 3, 8, 1, '#c0c0c0');
--SELECT insert_into_brique(172, 4, 8, 1, '#c0c0c0');
--SELECT insert_into_brique(173, 6, 8, 1, '#c0c0c0');
--SELECT insert_into_brique(174, 8, 8, 1, '#c0c0c0');
--SELECT insert_into_brique(175, 10, 8, 1, '#c0c0c0');
--SELECT insert_into_brique(176, 12, 8, 1, '#c0c0c0');
--SELECT insert_into_brique(177, 1, 10, 1, '#c0c0c0');
--SELECT insert_into_brique(178, 2, 10, 1, '#c0c0c0');
--SELECT insert_into_brique(179, 3, 10, 1, '#c0c0c0');
--SELECT insert_into_brique(180, 4, 10, 1, '#c0c0c0');
--SELECT insert_into_brique(181, 6, 10, 1, '#c0c0c0');
--SELECT insert_into_brique(182, 8, 10, 1, '#c0c0c0');
--SELECT insert_into_brique(183, 10, 10, 1, '#c0c0c0');
--SELECT insert_into_brique(184, 12, 10, 1, '#c0c0c0');
--SELECT insert_into_brique(185, 1, 12, 1, '#c0c0c0');
--SELECT insert_into_brique(186, 2, 12, 1, '#c0c0c0');
--SELECT insert_into_brique(187, 3, 12, 1, '#c0c0c0');
--SELECT insert_into_brique(188, 4, 12, 1, '#c0c0c0');
--SELECT insert_into_brique(189, 6, 12, 1, '#c0c0c0');
--SELECT insert_into_brique(190, 8, 12, 1, '#c0c0c0');
--SELECT insert_into_brique(191, 10, 12, 1, '#c0c0c0');
--SELECT insert_into_brique(192, 12, 12, 1, '#c0c0c0');
--SELECT insert_into_brique(193, 1, 1, 0.33, '#c0c0c0');
--SELECT insert_into_brique(194, 2, 1, 0.33, '#c0c0c0');
--SELECT insert_into_brique(195, 3, 1, 0.33, '#c0c0c0');
--SELECT insert_into_brique(196, 4, 1, 0.33, '#c0c0c0');
--SELECT insert_into_brique(197, 6, 1, 0.33, '#c0c0c0');
--SELECT insert_into_brique(198, 8, 1, 0.33, '#c0c0c0');
--SELECT insert_into_brique(199, 10, 1, 0.33, '#c0c0c0');
--SELECT insert_into_brique(200, 12, 1, 0.33, '#c0c0c0');
--SELECT insert_into_brique(201, 1, 2, 0.33, '#c0c0c0');
--SELECT insert_into_brique(202, 2, 2, 0.33, '#c0c0c0');
--SELECT insert_into_brique(203, 3, 2, 0.33, '#c0c0c0');
--SELECT insert_into_brique(204, 4, 2, 0.33, '#c0c0c0');
--SELECT insert_into_brique(205, 6, 2, 0.33, '#c0c0c0');
--SELECT insert_into_brique(206, 8, 2, 0.33, '#c0c0c0');
--SELECT insert_into_brique(207, 10, 2, 0.33, '#c0c0c0');
--SELECT insert_into_brique(208, 12, 2, 0.33, '#c0c0c0');
--SELECT insert_into_brique(209, 1, 3, 0.33, '#c0c0c0');
--SELECT insert_into_brique(210, 2, 3, 0.33, '#c0c0c0');
--SELECT insert_into_brique(211, 3, 3, 0.33, '#c0c0c0');
--SELECT insert_into_brique(212, 4, 3, 0.33, '#c0c0c0');
--SELECT insert_into_brique(213, 6, 3, 0.33, '#c0c0c0');
--SELECT insert_into_brique(214, 8, 3, 0.33, '#c0c0c0');
--SELECT insert_into_brique(215, 10, 3, 0.33, '#c0c0c0');
--SELECT insert_into_brique(216, 12, 3, 0.33, '#c0c0c0');
--SELECT insert_into_brique(217, 1, 4, 0.33, '#c0c0c0');
--SELECT insert_into_brique(218, 2, 4, 0.33, '#c0c0c0');
--SELECT insert_into_brique(219, 3, 4, 0.33, '#c0c0c0');
--SELECT insert_into_brique(220, 4, 4, 0.33, '#c0c0c0');
--SELECT insert_into_brique(221, 6, 4, 0.33, '#c0c0c0');
--SELECT insert_into_brique(222, 8, 4, 0.33, '#c0c0c0');
--SELECT insert_into_brique(223, 10, 4, 0.33, '#c0c0c0');
--SELECT insert_into_brique(224, 12, 4, 0.33, '#c0c0c0');
--SELECT insert_into_brique(225, 1, 6, 0.33, '#c0c0c0');
--SELECT insert_into_brique(226, 2, 6, 0.33, '#c0c0c0');
--SELECT insert_into_brique(227, 3, 6, 0.33, '#c0c0c0');
--SELECT insert_into_brique(228, 4, 6, 0.33, '#c0c0c0');
--SELECT insert_into_brique(229, 6, 6, 0.33, '#c0c0c0');
--SELECT insert_into_brique(230, 8, 6, 0.33, '#c0c0c0');
--SELECT insert_into_brique(231, 10, 6, 0.33, '#c0c0c0');
--SELECT insert_into_brique(232, 12, 6, 0.33, '#c0c0c0');
--SELECT insert_into_brique(233, 1, 8, 0.33, '#c0c0c0');
--SELECT insert_into_brique(234, 2, 8, 0.33, '#c0c0c0');
--SELECT insert_into_brique(235, 3, 8, 0.33, '#c0c0c0');
--SELECT insert_into_brique(236, 4, 8, 0.33, '#c0c0c0');
--SELECT insert_into_brique(237, 6, 8, 0.33, '#c0c0c0');
--SELECT insert_into_brique(238, 8, 8, 0.33, '#c0c0c0');
--SELECT insert_into_brique(239, 10, 8, 0.33, '#c0c0c0');
--SELECT insert_into_brique(240, 12, 8, 0.33, '#c0c0c0');
--SELECT insert_into_brique(241, 1, 10, 0.33, '#c0c0c0');
--SELECT insert_into_brique(242, 2, 10, 0.33, '#c0c0c0');
--SELECT insert_into_brique(243, 3, 10, 0.33, '#c0c0c0');
--SELECT insert_into_brique(244, 4, 10, 0.33, '#c0c0c0');
--SELECT insert_into_brique(245, 6, 10, 0.33, '#c0c0c0');
--SELECT insert_into_brique(246, 8, 10, 0.33, '#c0c0c0');
--SELECT insert_into_brique(247, 10, 10, 0.33, '#c0c0c0');
--SELECT insert_into_brique(248, 12, 10, 0.33, '#c0c0c0');
--SELECT insert_into_brique(249, 1, 12, 0.33, '#c0c0c0');
--SELECT insert_into_brique(250, 2, 12, 0.33, '#c0c0c0');
--SELECT insert_into_brique(251, 3, 12, 0.33, '#c0c0c0');
--SELECT insert_into_brique(252, 4, 12, 0.33, '#c0c0c0');
--SELECT insert_into_brique(253, 6, 12, 0.33, '#c0c0c0');
--SELECT insert_into_brique(254, 8, 12, 0.33, '#c0c0c0');
--SELECT insert_into_brique(255, 10, 12, 0.33, '#c0c0c0');
--SELECT insert_into_brique(256, 12, 12, 0.33, '#c0c0c0');
--SELECT insert_into_brique(257, 1, 1, 1, '#ffffff');
--SELECT insert_into_brique(258, 2, 1, 1, '#ffffff');
--SELECT insert_into_brique(259, 3, 1, 1, '#ffffff');
--SELECT insert_into_brique(260, 4, 1, 1, '#ffffff');
--SELECT insert_into_brique(261, 6, 1, 1, '#ffffff');
--SELECT insert_into_brique(262, 8, 1, 1, '#ffffff');
--SELECT insert_into_brique(263, 10, 1, 1, '#ffffff');
--SELECT insert_into_brique(264, 12, 1, 1, '#ffffff');
--SELECT insert_into_brique(265, 1, 2, 1, '#ffffff');
--SELECT insert_into_brique(266, 2, 2, 1, '#ffffff');
--SELECT insert_into_brique(267, 3, 2, 1, '#ffffff');
--SELECT insert_into_brique(268, 4, 2, 1, '#ffffff');
--SELECT insert_into_brique(269, 6, 2, 1, '#ffffff');
--SELECT insert_into_brique(270, 8, 2, 1, '#ffffff');
--SELECT insert_into_brique(271, 10, 2, 1, '#ffffff');
--SELECT insert_into_brique(272, 12, 2, 1, '#ffffff');
--SELECT insert_into_brique(273, 1, 3, 1, '#ffffff');
--SELECT insert_into_brique(274, 2, 3, 1, '#ffffff');
--SELECT insert_into_brique(275, 3, 3, 1, '#ffffff');
--SELECT insert_into_brique(276, 4, 3, 1, '#ffffff');
--SELECT insert_into_brique(277, 6, 3, 1, '#ffffff');
--SELECT insert_into_brique(278, 8, 3, 1, '#ffffff');
--SELECT insert_into_brique(279, 10, 3, 1, '#ffffff');
--SELECT insert_into_brique(280, 12, 3, 1, '#ffffff');
--SELECT insert_into_brique(281, 1, 4, 1, '#ffffff');
--SELECT insert_into_brique(282, 2, 4, 1, '#ffffff');
--SELECT insert_into_brique(283, 3, 4, 1, '#ffffff');
--SELECT insert_into_brique(284, 4, 4, 1, '#ffffff');
--SELECT insert_into_brique(285, 6, 4, 1, '#ffffff');
--SELECT insert_into_brique(286, 8, 4, 1, '#ffffff');
--SELECT insert_into_brique(287, 10, 4, 1, '#ffffff');
--SELECT insert_into_brique(288, 12, 4, 1, '#ffffff');
--SELECT insert_into_brique(289, 1, 6, 1, '#ffffff');
--SELECT insert_into_brique(290, 2, 6, 1, '#ffffff');
--SELECT insert_into_brique(291, 3, 6, 1, '#ffffff');
--SELECT insert_into_brique(292, 4, 6, 1, '#ffffff');
--SELECT insert_into_brique(293, 6, 6, 1, '#ffffff');
--SELECT insert_into_brique(294, 8, 6, 1, '#ffffff');
--SELECT insert_into_brique(295, 10, 6, 1, '#ffffff');
--SELECT insert_into_brique(296, 12, 6, 1, '#ffffff');
--SELECT insert_into_brique(297, 1, 8, 1, '#ffffff');
--SELECT insert_into_brique(298, 2, 8, 1, '#ffffff');
--SELECT insert_into_brique(299, 3, 8, 1, '#ffffff');
--SELECT insert_into_brique(300, 4, 8, 1, '#ffffff');
--SELECT insert_into_brique(301, 6, 8, 1, '#ffffff');
--SELECT insert_into_brique(302, 8, 8, 1, '#ffffff');
--SELECT insert_into_brique(303, 10, 8, 1, '#ffffff');
--SELECT insert_into_brique(304, 12, 8, 1, '#ffffff');
--SELECT insert_into_brique(305, 1, 10, 1, '#ffffff');
--SELECT insert_into_brique(306, 2, 10, 1, '#ffffff');
--SELECT insert_into_brique(307, 3, 10, 1, '#ffffff');
--SELECT insert_into_brique(308, 4, 10, 1, '#ffffff');
--SELECT insert_into_brique(309, 6, 10, 1, '#ffffff');
--SELECT insert_into_brique(310, 8, 10, 1, '#ffffff');
--SELECT insert_into_brique(311, 10, 10, 1, '#ffffff');
--SELECT insert_into_brique(312, 12, 10, 1, '#ffffff');
--SELECT insert_into_brique(313, 1, 12, 1, '#ffffff');
--SELECT insert_into_brique(314, 2, 12, 1, '#ffffff');
--SELECT insert_into_brique(315, 3, 12, 1, '#ffffff');
--SELECT insert_into_brique(316, 4, 12, 1, '#ffffff');
--SELECT insert_into_brique(317, 6, 12, 1, '#ffffff');
--SELECT insert_into_brique(318, 8, 12, 1, '#ffffff');
--SELECT insert_into_brique(319, 10, 12, 1, '#ffffff');
--SELECT insert_into_brique(320, 12, 12, 1, '#ffffff');
--SELECT insert_into_brique(321, 1, 1, 0.33, '#ffffff');
--SELECT insert_into_brique(322, 2, 1, 0.33, '#ffffff');
--SELECT insert_into_brique(323, 3, 1, 0.33, '#ffffff');
--SELECT insert_into_brique(324, 4, 1, 0.33, '#ffffff');
--SELECT insert_into_brique(325, 6, 1, 0.33, '#ffffff');
--SELECT insert_into_brique(326, 8, 1, 0.33, '#ffffff');
--SELECT insert_into_brique(327, 10, 1, 0.33, '#ffffff');
--SELECT insert_into_brique(328, 12, 1, 0.33, '#ffffff');
--SELECT insert_into_brique(329, 1, 2, 0.33, '#ffffff');
--SELECT insert_into_brique(330, 2, 2, 0.33, '#ffffff');
--SELECT insert_into_brique(331, 3, 2, 0.33, '#ffffff');
--SELECT insert_into_brique(332, 4, 2, 0.33, '#ffffff');
--SELECT insert_into_brique(333, 6, 2, 0.33, '#ffffff');
--SELECT insert_into_brique(334, 8, 2, 0.33, '#ffffff');
--SELECT insert_into_brique(335, 10, 2, 0.33, '#ffffff');
--SELECT insert_into_brique(336, 12, 2, 0.33, '#ffffff');
--SELECT insert_into_brique(337, 1, 3, 0.33, '#ffffff');
--SELECT insert_into_brique(338, 2, 3, 0.33, '#ffffff');
--SELECT insert_into_brique(339, 3, 3, 0.33, '#ffffff');
--SELECT insert_into_brique(340, 4, 3, 0.33, '#ffffff');
--SELECT insert_into_brique(341, 6, 3, 0.33, '#ffffff');
--SELECT insert_into_brique(342, 8, 3, 0.33, '#ffffff');
--SELECT insert_into_brique(343, 10, 3, 0.33, '#ffffff');
--SELECT insert_into_brique(344, 12, 3, 0.33, '#ffffff');
--SELECT insert_into_brique(345, 1, 4, 0.33, '#ffffff');
--SELECT insert_into_brique(346, 2, 4, 0.33, '#ffffff');
--SELECT insert_into_brique(347, 3, 4, 0.33, '#ffffff');
--SELECT insert_into_brique(348, 4, 4, 0.33, '#ffffff');
--SELECT insert_into_brique(349, 6, 4, 0.33, '#ffffff');
--SELECT insert_into_brique(350, 8, 4, 0.33, '#ffffff');
--SELECT insert_into_brique(351, 10, 4, 0.33, '#ffffff');
--SELECT insert_into_brique(352, 12, 4, 0.33, '#ffffff');
--SELECT insert_into_brique(353, 1, 6, 0.33, '#ffffff');
--SELECT insert_into_brique(354, 2, 6, 0.33, '#ffffff');
--SELECT insert_into_brique(355, 3, 6, 0.33, '#ffffff');
--SELECT insert_into_brique(356, 4, 6, 0.33, '#ffffff');
--SELECT insert_into_brique(357, 6, 6, 0.33, '#ffffff');
--SELECT insert_into_brique(358, 8, 6, 0.33, '#ffffff');
--SELECT insert_into_brique(359, 10, 6, 0.33, '#ffffff');
--SELECT insert_into_brique(360, 12, 6, 0.33, '#ffffff');
--SELECT insert_into_brique(361, 1, 8, 0.33, '#ffffff');
--SELECT insert_into_brique(362, 2, 8, 0.33, '#ffffff');
--SELECT insert_into_brique(363, 3, 8, 0.33, '#ffffff');
--SELECT insert_into_brique(364, 4, 8, 0.33, '#ffffff');
--SELECT insert_into_brique(365, 6, 8, 0.33, '#ffffff');
--SELECT insert_into_brique(366, 8, 8, 0.33, '#ffffff');
--SELECT insert_into_brique(367, 10, 8, 0.33, '#ffffff');
--SELECT insert_into_brique(368, 12, 8, 0.33, '#ffffff');
--SELECT insert_into_brique(369, 1, 10, 0.33, '#ffffff');
--SELECT insert_into_brique(370, 2, 10, 0.33, '#ffffff');
--SELECT insert_into_brique(371, 3, 10, 0.33, '#ffffff');
--SELECT insert_into_brique(372, 4, 10, 0.33, '#ffffff');
--SELECT insert_into_brique(373, 6, 10, 0.33, '#ffffff');
--SELECT insert_into_brique(374, 8, 10, 0.33, '#ffffff');
--SELECT insert_into_brique(375, 10, 10, 0.33, '#ffffff');
--SELECT insert_into_brique(376, 12, 10, 0.33, '#ffffff');
--SELECT insert_into_brique(377, 1, 12, 0.33, '#ffffff');
--SELECT insert_into_brique(378, 2, 12, 0.33, '#ffffff');
--SELECT insert_into_brique(379, 3, 12, 0.33, '#ffffff');
--SELECT insert_into_brique(380, 4, 12, 0.33, '#ffffff');
--SELECT insert_into_brique(381, 6, 12, 0.33, '#ffffff');
--SELECT insert_into_brique(382, 8, 12, 0.33, '#ffffff');
--SELECT insert_into_brique(383, 10, 12, 0.33, '#ffffff');
--SELECT insert_into_brique(384, 12, 12, 0.33, '#ffffff');
--SELECT insert_into_brique(385, 1, 1, 1, '#8b4513');
--SELECT insert_into_brique(386, 2, 1, 1, '#8b4513');
--SELECT insert_into_brique(387, 3, 1, 1, '#8b4513');
--SELECT insert_into_brique(388, 4, 1, 1, '#8b4513');
--SELECT insert_into_brique(389, 6, 1, 1, '#8b4513');
--SELECT insert_into_brique(390, 8, 1, 1, '#8b4513');
--SELECT insert_into_brique(391, 10, 1, 1, '#8b4513');
--SELECT insert_into_brique(392, 12, 1, 1, '#8b4513');
--SELECT insert_into_brique(393, 1, 2, 1, '#8b4513');
--SELECT insert_into_brique(394, 2, 2, 1, '#8b4513');
--SELECT insert_into_brique(395, 3, 2, 1, '#8b4513');
--SELECT insert_into_brique(396, 4, 2, 1, '#8b4513');
--SELECT insert_into_brique(397, 6, 2, 1, '#8b4513');
--SELECT insert_into_brique(398, 8, 2, 1, '#8b4513');
--SELECT insert_into_brique(399, 10, 2, 1, '#8b4513');
--SELECT insert_into_brique(400, 12, 2, 1, '#8b4513');
--SELECT insert_into_brique(401, 1, 3, 1, '#8b4513');
--SELECT insert_into_brique(402, 2, 3, 1, '#8b4513');
--SELECT insert_into_brique(403, 3, 3, 1, '#8b4513');
--SELECT insert_into_brique(404, 4, 3, 1, '#8b4513');
--SELECT insert_into_brique(405, 6, 3, 1, '#8b4513');
--SELECT insert_into_brique(406, 8, 3, 1, '#8b4513');
--SELECT insert_into_brique(407, 10, 3, 1, '#8b4513');
--SELECT insert_into_brique(408, 12, 3, 1, '#8b4513');
--SELECT insert_into_brique(409, 1, 4, 1, '#8b4513');
--SELECT insert_into_brique(410, 2, 4, 1, '#8b4513');
--SELECT insert_into_brique(411, 3, 4, 1, '#8b4513');
--SELECT insert_into_brique(412, 4, 4, 1, '#8b4513');
--SELECT insert_into_brique(413, 6, 4, 1, '#8b4513');
--SELECT insert_into_brique(414, 8, 4, 1, '#8b4513');
--SELECT insert_into_brique(415, 10, 4, 1, '#8b4513');
--SELECT insert_into_brique(416, 12, 4, 1, '#8b4513');
--SELECT insert_into_brique(417, 1, 6, 1, '#8b4513');
--SELECT insert_into_brique(418, 2, 6, 1, '#8b4513');
--SELECT insert_into_brique(419, 3, 6, 1, '#8b4513');
--SELECT insert_into_brique(420, 4, 6, 1, '#8b4513');
--SELECT insert_into_brique(421, 6, 6, 1, '#8b4513');
--SELECT insert_into_brique(422, 8, 6, 1, '#8b4513');
--SELECT insert_into_brique(423, 10, 6, 1, '#8b4513');
--SELECT insert_into_brique(424, 12, 6, 1, '#8b4513');
--SELECT insert_into_brique(425, 1, 8, 1, '#8b4513');
--SELECT insert_into_brique(426, 2, 8, 1, '#8b4513');
--SELECT insert_into_brique(427, 3, 8, 1, '#8b4513');
--SELECT insert_into_brique(428, 4, 8, 1, '#8b4513');
--SELECT insert_into_brique(429, 6, 8, 1, '#8b4513');
--SELECT insert_into_brique(430, 8, 8, 1, '#8b4513');
--SELECT insert_into_brique(431, 10, 8, 1, '#8b4513');
--SELECT insert_into_brique(432, 12, 8, 1, '#8b4513');
--SELECT insert_into_brique(433, 1, 10, 1, '#8b4513');
--SELECT insert_into_brique(434, 2, 10, 1, '#8b4513');
--SELECT insert_into_brique(435, 3, 10, 1, '#8b4513');
--SELECT insert_into_brique(436, 4, 10, 1, '#8b4513');
--SELECT insert_into_brique(437, 6, 10, 1, '#8b4513');
--SELECT insert_into_brique(438, 8, 10, 1, '#8b4513');
--SELECT insert_into_brique(439, 10, 10, 1, '#8b4513');
--SELECT insert_into_brique(440, 12, 10, 1, '#8b4513');
--SELECT insert_into_brique(441, 1, 12, 1, '#8b4513');
--SELECT insert_into_brique(442, 2, 12, 1, '#8b4513');
--SELECT insert_into_brique(443, 3, 12, 1, '#8b4513');
--SELECT insert_into_brique(444, 4, 12, 1, '#8b4513');
--SELECT insert_into_brique(445, 6, 12, 1, '#8b4513');
--SELECT insert_into_brique(446, 8, 12, 1, '#8b4513');
--SELECT insert_into_brique(447, 10, 12, 1, '#8b4513');
--SELECT insert_into_brique(448, 12, 12, 1, '#8b4513');
--SELECT insert_into_brique(449, 1, 1, 0.33, '#8b4513');
--SELECT insert_into_brique(450, 2, 1, 0.33, '#8b4513');
--SELECT insert_into_brique(451, 3, 1, 0.33, '#8b4513');
--SELECT insert_into_brique(452, 4, 1, 0.33, '#8b4513');
--SELECT insert_into_brique(453, 6, 1, 0.33, '#8b4513');
--SELECT insert_into_brique(454, 8, 1, 0.33, '#8b4513');
--SELECT insert_into_brique(455, 10, 1, 0.33, '#8b4513');
--SELECT insert_into_brique(456, 12, 1, 0.33, '#8b4513');
--SELECT insert_into_brique(457, 1, 2, 0.33, '#8b4513');
--SELECT insert_into_brique(458, 2, 2, 0.33, '#8b4513');
--SELECT insert_into_brique(459, 3, 2, 0.33, '#8b4513');
--SELECT insert_into_brique(460, 4, 2, 0.33, '#8b4513');
--SELECT insert_into_brique(461, 6, 2, 0.33, '#8b4513');
--SELECT insert_into_brique(462, 8, 2, 0.33, '#8b4513');
--SELECT insert_into_brique(463, 10, 2, 0.33, '#8b4513');
--SELECT insert_into_brique(464, 12, 2, 0.33, '#8b4513');
--SELECT insert_into_brique(465, 1, 3, 0.33, '#8b4513');
--SELECT insert_into_brique(466, 2, 3, 0.33, '#8b4513');
--SELECT insert_into_brique(467, 3, 3, 0.33, '#8b4513');
--SELECT insert_into_brique(468, 4, 3, 0.33, '#8b4513');
--SELECT insert_into_brique(469, 6, 3, 0.33, '#8b4513');
--SELECT insert_into_brique(470, 8, 3, 0.33, '#8b4513');
--SELECT insert_into_brique(471, 10, 3, 0.33, '#8b4513');
--SELECT insert_into_brique(472, 12, 3, 0.33, '#8b4513');
--SELECT insert_into_brique(473, 1, 4, 0.33, '#8b4513');
--SELECT insert_into_brique(474, 2, 4, 0.33, '#8b4513');
--SELECT insert_into_brique(475, 3, 4, 0.33, '#8b4513');
--SELECT insert_into_brique(476, 4, 4, 0.33, '#8b4513');
--SELECT insert_into_brique(477, 6, 4, 0.33, '#8b4513');
--SELECT insert_into_brique(478, 8, 4, 0.33, '#8b4513');
--SELECT insert_into_brique(479, 10, 4, 0.33, '#8b4513');
--SELECT insert_into_brique(480, 12, 4, 0.33, '#8b4513');
--SELECT insert_into_brique(481, 1, 6, 0.33, '#8b4513');
--SELECT insert_into_brique(482, 2, 6, 0.33, '#8b4513');
--SELECT insert_into_brique(483, 3, 6, 0.33, '#8b4513');
--SELECT insert_into_brique(484, 4, 6, 0.33, '#8b4513');
--SELECT insert_into_brique(485, 6, 6, 0.33, '#8b4513');
--SELECT insert_into_brique(486, 8, 6, 0.33, '#8b4513');
--SELECT insert_into_brique(487, 10, 6, 0.33, '#8b4513');
--SELECT insert_into_brique(488, 12, 6, 0.33, '#8b4513');
--SELECT insert_into_brique(489, 1, 8, 0.33, '#8b4513');
--SELECT insert_into_brique(490, 2, 8, 0.33, '#8b4513');
--SELECT insert_into_brique(491, 3, 8, 0.33, '#8b4513');
--SELECT insert_into_brique(492, 4, 8, 0.33, '#8b4513');
--SELECT insert_into_brique(493, 6, 8, 0.33, '#8b4513');
--SELECT insert_into_brique(494, 8, 8, 0.33, '#8b4513');
--SELECT insert_into_brique(495, 10, 8, 0.33, '#8b4513');
--SELECT insert_into_brique(496, 12, 8, 0.33, '#8b4513');
--SELECT insert_into_brique(497, 1, 10, 0.33, '#8b4513');
--SELECT insert_into_brique(498, 2, 10, 0.33, '#8b4513');
--SELECT insert_into_brique(499, 3, 10, 0.33, '#8b4513');
--SELECT insert_into_brique(500, 4, 10, 0.33, '#8b4513');
--SELECT insert_into_brique(501, 6, 10, 0.33, '#8b4513');
--SELECT insert_into_brique(502, 8, 10, 0.33, '#8b4513');
--SELECT insert_into_brique(503, 10, 10, 0.33, '#8b4513');
--SELECT insert_into_brique(504, 12, 10, 0.33, '#8b4513');
--SELECT insert_into_brique(505, 1, 12, 0.33, '#8b4513');
--SELECT insert_into_brique(506, 2, 12, 0.33, '#8b4513');
--SELECT insert_into_brique(507, 3, 12, 0.33, '#8b4513');
--SELECT insert_into_brique(508, 4, 12, 0.33, '#8b4513');
--SELECT insert_into_brique(509, 6, 12, 0.33, '#8b4513');
--SELECT insert_into_brique(510, 8, 12, 0.33, '#8b4513');
--SELECT insert_into_brique(511, 10, 12, 0.33, '#8b4513');
--SELECT insert_into_brique(512, 12, 12, 0.33, '#8b4513');
--SELECT insert_into_brique(513, 1, 1, 1, '#00bfff');
--SELECT insert_into_brique(514, 2, 1, 1, '#00bfff');
--SELECT insert_into_brique(515, 3, 1, 1, '#00bfff');
--SELECT insert_into_brique(516, 4, 1, 1, '#00bfff');
--SELECT insert_into_brique(517, 6, 1, 1, '#00bfff');
--SELECT insert_into_brique(518, 8, 1, 1, '#00bfff');
--SELECT insert_into_brique(519, 10, 1, 1, '#00bfff');
--SELECT insert_into_brique(520, 12, 1, 1, '#00bfff');
--SELECT insert_into_brique(521, 1, 2, 1, '#00bfff');
--SELECT insert_into_brique(522, 2, 2, 1, '#00bfff');
--SELECT insert_into_brique(523, 3, 2, 1, '#00bfff');
--SELECT insert_into_brique(524, 4, 2, 1, '#00bfff');
--SELECT insert_into_brique(525, 6, 2, 1, '#00bfff');
--SELECT insert_into_brique(526, 8, 2, 1, '#00bfff');
--SELECT insert_into_brique(527, 10, 2, 1, '#00bfff');
--SELECT insert_into_brique(528, 12, 2, 1, '#00bfff');
--SELECT insert_into_brique(529, 1, 3, 1, '#00bfff');
--SELECT insert_into_brique(530, 2, 3, 1, '#00bfff');
--SELECT insert_into_brique(531, 3, 3, 1, '#00bfff');
--SELECT insert_into_brique(532, 4, 3, 1, '#00bfff');
--SELECT insert_into_brique(533, 6, 3, 1, '#00bfff');
--SELECT insert_into_brique(534, 8, 3, 1, '#00bfff');
--SELECT insert_into_brique(535, 10, 3, 1, '#00bfff');
--SELECT insert_into_brique(536, 12, 3, 1, '#00bfff');
--SELECT insert_into_brique(537, 1, 4, 1, '#00bfff');
--SELECT insert_into_brique(538, 2, 4, 1, '#00bfff');
--SELECT insert_into_brique(539, 3, 4, 1, '#00bfff');
--SELECT insert_into_brique(540, 4, 4, 1, '#00bfff');
--SELECT insert_into_brique(541, 6, 4, 1, '#00bfff');
--SELECT insert_into_brique(542, 8, 4, 1, '#00bfff');
--SELECT insert_into_brique(543, 10, 4, 1, '#00bfff');
--SELECT insert_into_brique(544, 12, 4, 1, '#00bfff');
--SELECT insert_into_brique(545, 1, 6, 1, '#00bfff');
--SELECT insert_into_brique(546, 2, 6, 1, '#00bfff');
--SELECT insert_into_brique(547, 3, 6, 1, '#00bfff');
--SELECT insert_into_brique(548, 4, 6, 1, '#00bfff');
--SELECT insert_into_brique(549, 6, 6, 1, '#00bfff');
--SELECT insert_into_brique(550, 8, 6, 1, '#00bfff');
--SELECT insert_into_brique(551, 10, 6, 1, '#00bfff');
--SELECT insert_into_brique(552, 12, 6, 1, '#00bfff');
--SELECT insert_into_brique(553, 1, 8, 1, '#00bfff');
--SELECT insert_into_brique(554, 2, 8, 1, '#00bfff');
--SELECT insert_into_brique(555, 3, 8, 1, '#00bfff');
--SELECT insert_into_brique(556, 4, 8, 1, '#00bfff');
--SELECT insert_into_brique(557, 6, 8, 1, '#00bfff');
--SELECT insert_into_brique(558, 8, 8, 1, '#00bfff');
--SELECT insert_into_brique(559, 10, 8, 1, '#00bfff');
--SELECT insert_into_brique(560, 12, 8, 1, '#00bfff');
--SELECT insert_into_brique(561, 1, 10, 1, '#00bfff');
--SELECT insert_into_brique(562, 2, 10, 1, '#00bfff');
--SELECT insert_into_brique(563, 3, 10, 1, '#00bfff');
--SELECT insert_into_brique(564, 4, 10, 1, '#00bfff');
--SELECT insert_into_brique(565, 6, 10, 1, '#00bfff');
--SELECT insert_into_brique(566, 8, 10, 1, '#00bfff');
--SELECT insert_into_brique(567, 10, 10, 1, '#00bfff');
--SELECT insert_into_brique(568, 12, 10, 1, '#00bfff');
--SELECT insert_into_brique(569, 1, 12, 1, '#00bfff');
--SELECT insert_into_brique(570, 2, 12, 1, '#00bfff');
--SELECT insert_into_brique(571, 3, 12, 1, '#00bfff');
--SELECT insert_into_brique(572, 4, 12, 1, '#00bfff');
--SELECT insert_into_brique(573, 6, 12, 1, '#00bfff');
--SELECT insert_into_brique(574, 8, 12, 1, '#00bfff');
--SELECT insert_into_brique(575, 10, 12, 1, '#00bfff');
--SELECT insert_into_brique(576, 12, 12, 1, '#00bfff');
--SELECT insert_into_brique(577, 1, 1, 0.33, '#00bfff');
--SELECT insert_into_brique(578, 2, 1, 0.33, '#00bfff');
--SELECT insert_into_brique(579, 3, 1, 0.33, '#00bfff');
--SELECT insert_into_brique(580, 4, 1, 0.33, '#00bfff');
--SELECT insert_into_brique(581, 6, 1, 0.33, '#00bfff');
--SELECT insert_into_brique(582, 8, 1, 0.33, '#00bfff');
--SELECT insert_into_brique(583, 10, 1, 0.33, '#00bfff');
--SELECT insert_into_brique(584, 12, 1, 0.33, '#00bfff');
--SELECT insert_into_brique(585, 1, 2, 0.33, '#00bfff');
--SELECT insert_into_brique(586, 2, 2, 0.33, '#00bfff');
--SELECT insert_into_brique(587, 3, 2, 0.33, '#00bfff');
--SELECT insert_into_brique(588, 4, 2, 0.33, '#00bfff');
--SELECT insert_into_brique(589, 6, 2, 0.33, '#00bfff');
--SELECT insert_into_brique(590, 8, 2, 0.33, '#00bfff');
--SELECT insert_into_brique(591, 10, 2, 0.33, '#00bfff');
--SELECT insert_into_brique(592, 12, 2, 0.33, '#00bfff');
--SELECT insert_into_brique(593, 1, 3, 0.33, '#00bfff');
--SELECT insert_into_brique(594, 2, 3, 0.33, '#00bfff');
--SELECT insert_into_brique(595, 3, 3, 0.33, '#00bfff');
--SELECT insert_into_brique(596, 4, 3, 0.33, '#00bfff');
--SELECT insert_into_brique(597, 6, 3, 0.33, '#00bfff');
--SELECT insert_into_brique(598, 8, 3, 0.33, '#00bfff');
--SELECT insert_into_brique(599, 10, 3, 0.33, '#00bfff');
--SELECT insert_into_brique(600, 12, 3, 0.33, '#00bfff');
--SELECT insert_into_brique(601, 1, 4, 0.33, '#00bfff');
--SELECT insert_into_brique(602, 2, 4, 0.33, '#00bfff');
--SELECT insert_into_brique(603, 3, 4, 0.33, '#00bfff');
--SELECT insert_into_brique(604, 4, 4, 0.33, '#00bfff');
--SELECT insert_into_brique(605, 6, 4, 0.33, '#00bfff');
--SELECT insert_into_brique(606, 8, 4, 0.33, '#00bfff');
--SELECT insert_into_brique(607, 10, 4, 0.33, '#00bfff');
--SELECT insert_into_brique(608, 12, 4, 0.33, '#00bfff');
--SELECT insert_into_brique(609, 1, 6, 0.33, '#00bfff');
--SELECT insert_into_brique(610, 2, 6, 0.33, '#00bfff');
--SELECT insert_into_brique(611, 3, 6, 0.33, '#00bfff');
--SELECT insert_into_brique(612, 4, 6, 0.33, '#00bfff');
--SELECT insert_into_brique(613, 6, 6, 0.33, '#00bfff');
--SELECT insert_into_brique(614, 8, 6, 0.33, '#00bfff');
--SELECT insert_into_brique(615, 10, 6, 0.33, '#00bfff');
--SELECT insert_into_brique(616, 12, 6, 0.33, '#00bfff');
--SELECT insert_into_brique(617, 1, 8, 0.33, '#00bfff');
--SELECT insert_into_brique(618, 2, 8, 0.33, '#00bfff');
--SELECT insert_into_brique(619, 3, 8, 0.33, '#00bfff');
--SELECT insert_into_brique(620, 4, 8, 0.33, '#00bfff');
--SELECT insert_into_brique(621, 6, 8, 0.33, '#00bfff');
--SELECT insert_into_brique(622, 8, 8, 0.33, '#00bfff');
--SELECT insert_into_brique(623, 10, 8, 0.33, '#00bfff');
--SELECT insert_into_brique(624, 12, 8, 0.33, '#00bfff');
--SELECT insert_into_brique(625, 1, 10, 0.33, '#00bfff');
--SELECT insert_into_brique(626, 2, 10, 0.33, '#00bfff');
--SELECT insert_into_brique(627, 3, 10, 0.33, '#00bfff');
--SELECT insert_into_brique(628, 4, 10, 0.33, '#00bfff');
--SELECT insert_into_brique(629, 6, 10, 0.33, '#00bfff');
--SELECT insert_into_brique(630, 8, 10, 0.33, '#00bfff');
--SELECT insert_into_brique(631, 10, 10, 0.33, '#00bfff');
--SELECT insert_into_brique(632, 12, 10, 0.33, '#00bfff');
--SELECT insert_into_brique(633, 1, 12, 0.33, '#00bfff');
--SELECT insert_into_brique(634, 2, 12, 0.33, '#00bfff');
--SELECT insert_into_brique(635, 3, 12, 0.33, '#00bfff');
--SELECT insert_into_brique(636, 4, 12, 0.33, '#00bfff');
--SELECT insert_into_brique(637, 6, 12, 0.33, '#00bfff');
--SELECT insert_into_brique(638, 8, 12, 0.33, '#00bfff');
--SELECT insert_into_brique(639, 10, 12, 0.33, '#00bfff');
--SELECT insert_into_brique(640, 12, 12, 0.33, '#00bfff');
--SELECT insert_into_brique(641, 1, 1, 1, '#0000cd');
--SELECT insert_into_brique(642, 2, 1, 1, '#0000cd');
--SELECT insert_into_brique(643, 3, 1, 1, '#0000cd');
--SELECT insert_into_brique(644, 4, 1, 1, '#0000cd');
--SELECT insert_into_brique(645, 6, 1, 1, '#0000cd');
--SELECT insert_into_brique(646, 8, 1, 1, '#0000cd');
--SELECT insert_into_brique(647, 10, 1, 1, '#0000cd');
--SELECT insert_into_brique(648, 12, 1, 1, '#0000cd');
--SELECT insert_into_brique(649, 1, 2, 1, '#0000cd');
--SELECT insert_into_brique(650, 2, 2, 1, '#0000cd');
--SELECT insert_into_brique(651, 3, 2, 1, '#0000cd');
--SELECT insert_into_brique(652, 4, 2, 1, '#0000cd');
--SELECT insert_into_brique(653, 6, 2, 1, '#0000cd');
--SELECT insert_into_brique(654, 8, 2, 1, '#0000cd');
--SELECT insert_into_brique(655, 10, 2, 1, '#0000cd');
--SELECT insert_into_brique(656, 12, 2, 1, '#0000cd');
--SELECT insert_into_brique(657, 1, 3, 1, '#0000cd');
--SELECT insert_into_brique(658, 2, 3, 1, '#0000cd');
--SELECT insert_into_brique(659, 3, 3, 1, '#0000cd');
--SELECT insert_into_brique(660, 4, 3, 1, '#0000cd');
--SELECT insert_into_brique(661, 6, 3, 1, '#0000cd');
--SELECT insert_into_brique(662, 8, 3, 1, '#0000cd');
--SELECT insert_into_brique(663, 10, 3, 1, '#0000cd');
--SELECT insert_into_brique(664, 12, 3, 1, '#0000cd');
--SELECT insert_into_brique(665, 1, 4, 1, '#0000cd');
--SELECT insert_into_brique(666, 2, 4, 1, '#0000cd');
--SELECT insert_into_brique(667, 3, 4, 1, '#0000cd');
--SELECT insert_into_brique(668, 4, 4, 1, '#0000cd');
--SELECT insert_into_brique(669, 6, 4, 1, '#0000cd');
--SELECT insert_into_brique(670, 8, 4, 1, '#0000cd');
--SELECT insert_into_brique(671, 10, 4, 1, '#0000cd');
--SELECT insert_into_brique(672, 12, 4, 1, '#0000cd');
--SELECT insert_into_brique(673, 1, 6, 1, '#0000cd');
--SELECT insert_into_brique(674, 2, 6, 1, '#0000cd');
--SELECT insert_into_brique(675, 3, 6, 1, '#0000cd');
--SELECT insert_into_brique(676, 4, 6, 1, '#0000cd');
--SELECT insert_into_brique(677, 6, 6, 1, '#0000cd');
--SELECT insert_into_brique(678, 8, 6, 1, '#0000cd');
--SELECT insert_into_brique(679, 10, 6, 1, '#0000cd');
--SELECT insert_into_brique(680, 12, 6, 1, '#0000cd');
--SELECT insert_into_brique(681, 1, 8, 1, '#0000cd');
--SELECT insert_into_brique(682, 2, 8, 1, '#0000cd');
--SELECT insert_into_brique(683, 3, 8, 1, '#0000cd');
--SELECT insert_into_brique(684, 4, 8, 1, '#0000cd');
--SELECT insert_into_brique(685, 6, 8, 1, '#0000cd');
--SELECT insert_into_brique(686, 8, 8, 1, '#0000cd');
--SELECT insert_into_brique(687, 10, 8, 1, '#0000cd');
--SELECT insert_into_brique(688, 12, 8, 1, '#0000cd');
--SELECT insert_into_brique(689, 1, 10, 1, '#0000cd');
--SELECT insert_into_brique(690, 2, 10, 1, '#0000cd');
--SELECT insert_into_brique(691, 3, 10, 1, '#0000cd');
--SELECT insert_into_brique(692, 4, 10, 1, '#0000cd');
--SELECT insert_into_brique(693, 6, 10, 1, '#0000cd');
--SELECT insert_into_brique(694, 8, 10, 1, '#0000cd');
--SELECT insert_into_brique(695, 10, 10, 1, '#0000cd');
--SELECT insert_into_brique(696, 12, 10, 1, '#0000cd');
--SELECT insert_into_brique(697, 1, 12, 1, '#0000cd');
--SELECT insert_into_brique(698, 2, 12, 1, '#0000cd');
--SELECT insert_into_brique(699, 3, 12, 1, '#0000cd');
--SELECT insert_into_brique(700, 4, 12, 1, '#0000cd');
--SELECT insert_into_brique(701, 6, 12, 1, '#0000cd');
--SELECT insert_into_brique(702, 8, 12, 1, '#0000cd');
--SELECT insert_into_brique(703, 10, 12, 1, '#0000cd');
--SELECT insert_into_brique(704, 12, 12, 1, '#0000cd');
--SELECT insert_into_brique(705, 1, 1, 0.33, '#0000cd');
--SELECT insert_into_brique(706, 2, 1, 0.33, '#0000cd');
--SELECT insert_into_brique(707, 3, 1, 0.33, '#0000cd');
--SELECT insert_into_brique(708, 4, 1, 0.33, '#0000cd');
--SELECT insert_into_brique(709, 6, 1, 0.33, '#0000cd');
--SELECT insert_into_brique(710, 8, 1, 0.33, '#0000cd');
--SELECT insert_into_brique(711, 10, 1, 0.33, '#0000cd');
--SELECT insert_into_brique(712, 12, 1, 0.33, '#0000cd');
--SELECT insert_into_brique(713, 1, 2, 0.33, '#0000cd');
--SELECT insert_into_brique(714, 2, 2, 0.33, '#0000cd');
--SELECT insert_into_brique(715, 3, 2, 0.33, '#0000cd');
--SELECT insert_into_brique(716, 4, 2, 0.33, '#0000cd');
--SELECT insert_into_brique(717, 6, 2, 0.33, '#0000cd');
--SELECT insert_into_brique(718, 8, 2, 0.33, '#0000cd');
--SELECT insert_into_brique(719, 10, 2, 0.33, '#0000cd');
--SELECT insert_into_brique(720, 12, 2, 0.33, '#0000cd');
--SELECT insert_into_brique(721, 1, 3, 0.33, '#0000cd');
--SELECT insert_into_brique(722, 2, 3, 0.33, '#0000cd');
--SELECT insert_into_brique(723, 3, 3, 0.33, '#0000cd');
--SELECT insert_into_brique(724, 4, 3, 0.33, '#0000cd');
--SELECT insert_into_brique(725, 6, 3, 0.33, '#0000cd');
--SELECT insert_into_brique(726, 8, 3, 0.33, '#0000cd');
--SELECT insert_into_brique(727, 10, 3, 0.33, '#0000cd');
--SELECT insert_into_brique(728, 12, 3, 0.33, '#0000cd');
--SELECT insert_into_brique(729, 1, 4, 0.33, '#0000cd');
--SELECT insert_into_brique(730, 2, 4, 0.33, '#0000cd');
--SELECT insert_into_brique(731, 3, 4, 0.33, '#0000cd');
--SELECT insert_into_brique(732, 4, 4, 0.33, '#0000cd');
--SELECT insert_into_brique(733, 6, 4, 0.33, '#0000cd');
--SELECT insert_into_brique(734, 8, 4, 0.33, '#0000cd');
--SELECT insert_into_brique(735, 10, 4, 0.33, '#0000cd');
--SELECT insert_into_brique(736, 12, 4, 0.33, '#0000cd');
--SELECT insert_into_brique(737, 1, 6, 0.33, '#0000cd');
--SELECT insert_into_brique(738, 2, 6, 0.33, '#0000cd');
--SELECT insert_into_brique(739, 3, 6, 0.33, '#0000cd');
--SELECT insert_into_brique(740, 4, 6, 0.33, '#0000cd');
--SELECT insert_into_brique(741, 6, 6, 0.33, '#0000cd');
--SELECT insert_into_brique(742, 8, 6, 0.33, '#0000cd');
--SELECT insert_into_brique(743, 10, 6, 0.33, '#0000cd');
--SELECT insert_into_brique(744, 12, 6, 0.33, '#0000cd');
--SELECT insert_into_brique(745, 1, 8, 0.33, '#0000cd');
--SELECT insert_into_brique(746, 2, 8, 0.33, '#0000cd');
--SELECT insert_into_brique(747, 3, 8, 0.33, '#0000cd');
--SELECT insert_into_brique(748, 4, 8, 0.33, '#0000cd');
--SELECT insert_into_brique(749, 6, 8, 0.33, '#0000cd');
--SELECT insert_into_brique(750, 8, 8, 0.33, '#0000cd');
--SELECT insert_into_brique(751, 10, 8, 0.33, '#0000cd');
--SELECT insert_into_brique(752, 12, 8, 0.33, '#0000cd');
--SELECT insert_into_brique(753, 1, 10, 0.33, '#0000cd');
--SELECT insert_into_brique(754, 2, 10, 0.33, '#0000cd');
--SELECT insert_into_brique(755, 3, 10, 0.33, '#0000cd');
--SELECT insert_into_brique(756, 4, 10, 0.33, '#0000cd');
--SELECT insert_into_brique(757, 6, 10, 0.33, '#0000cd');
--SELECT insert_into_brique(758, 8, 10, 0.33, '#0000cd');
--SELECT insert_into_brique(759, 10, 10, 0.33, '#0000cd');
--SELECT insert_into_brique(760, 12, 10, 0.33, '#0000cd');
--SELECT insert_into_brique(761, 1, 12, 0.33, '#0000cd');
--SELECT insert_into_brique(762, 2, 12, 0.33, '#0000cd');
--SELECT insert_into_brique(763, 3, 12, 0.33, '#0000cd');
--SELECT insert_into_brique(764, 4, 12, 0.33, '#0000cd');
--SELECT insert_into_brique(765, 6, 12, 0.33, '#0000cd');
--SELECT insert_into_brique(766, 8, 12, 0.33, '#0000cd');
--SELECT insert_into_brique(767, 10, 12, 0.33, '#0000cd');
--SELECT insert_into_brique(768, 12, 12, 0.33, '#0000cd');
--SELECT insert_into_brique(769, 1, 1, 1, '#006400');
--SELECT insert_into_brique(770, 2, 1, 1, '#006400');
--SELECT insert_into_brique(771, 3, 1, 1, '#006400');
--SELECT insert_into_brique(772, 4, 1, 1, '#006400');
--SELECT insert_into_brique(773, 6, 1, 1, '#006400');
--SELECT insert_into_brique(774, 8, 1, 1, '#006400');
--SELECT insert_into_brique(775, 10, 1, 1, '#006400');
--SELECT insert_into_brique(776, 12, 1, 1, '#006400');
--SELECT insert_into_brique(777, 1, 2, 1, '#006400');
--SELECT insert_into_brique(778, 2, 2, 1, '#006400');
--SELECT insert_into_brique(779, 3, 2, 1, '#006400');
--SELECT insert_into_brique(780, 4, 2, 1, '#006400');
--SELECT insert_into_brique(781, 6, 2, 1, '#006400');
--SELECT insert_into_brique(782, 8, 2, 1, '#006400');
--SELECT insert_into_brique(783, 10, 2, 1, '#006400');
--SELECT insert_into_brique(784, 12, 2, 1, '#006400');
--SELECT insert_into_brique(785, 1, 3, 1, '#006400');
--SELECT insert_into_brique(786, 2, 3, 1, '#006400');
--SELECT insert_into_brique(787, 3, 3, 1, '#006400');
--SELECT insert_into_brique(788, 4, 3, 1, '#006400');
--SELECT insert_into_brique(789, 6, 3, 1, '#006400');
--SELECT insert_into_brique(790, 8, 3, 1, '#006400');
--SELECT insert_into_brique(791, 10, 3, 1, '#006400');
--SELECT insert_into_brique(792, 12, 3, 1, '#006400');
--SELECT insert_into_brique(793, 1, 4, 1, '#006400');
--SELECT insert_into_brique(794, 2, 4, 1, '#006400');
--SELECT insert_into_brique(795, 3, 4, 1, '#006400');
--SELECT insert_into_brique(796, 4, 4, 1, '#006400');
--SELECT insert_into_brique(797, 6, 4, 1, '#006400');
--SELECT insert_into_brique(798, 8, 4, 1, '#006400');
--SELECT insert_into_brique(799, 10, 4, 1, '#006400');
--SELECT insert_into_brique(800, 12, 4, 1, '#006400');
--SELECT insert_into_brique(801, 1, 6, 1, '#006400');
--SELECT insert_into_brique(802, 2, 6, 1, '#006400');
--SELECT insert_into_brique(803, 3, 6, 1, '#006400');
--SELECT insert_into_brique(804, 4, 6, 1, '#006400');
--SELECT insert_into_brique(805, 6, 6, 1, '#006400');
--SELECT insert_into_brique(806, 8, 6, 1, '#006400');
--SELECT insert_into_brique(807, 10, 6, 1, '#006400');
--SELECT insert_into_brique(808, 12, 6, 1, '#006400');
--SELECT insert_into_brique(809, 1, 8, 1, '#006400');
--SELECT insert_into_brique(810, 2, 8, 1, '#006400');
--SELECT insert_into_brique(811, 3, 8, 1, '#006400');
--SELECT insert_into_brique(812, 4, 8, 1, '#006400');
--SELECT insert_into_brique(813, 6, 8, 1, '#006400');
--SELECT insert_into_brique(814, 8, 8, 1, '#006400');
--SELECT insert_into_brique(815, 10, 8, 1, '#006400');
--SELECT insert_into_brique(816, 12, 8, 1, '#006400');
--SELECT insert_into_brique(817, 1, 10, 1, '#006400');
--SELECT insert_into_brique(818, 2, 10, 1, '#006400');
--SELECT insert_into_brique(819, 3, 10, 1, '#006400');
--SELECT insert_into_brique(820, 4, 10, 1, '#006400');
--SELECT insert_into_brique(821, 6, 10, 1, '#006400');
--SELECT insert_into_brique(822, 8, 10, 1, '#006400');
--SELECT insert_into_brique(823, 10, 10, 1, '#006400');
--SELECT insert_into_brique(824, 12, 10, 1, '#006400');
--SELECT insert_into_brique(825, 1, 12, 1, '#006400');
--SELECT insert_into_brique(826, 2, 12, 1, '#006400');
--SELECT insert_into_brique(827, 3, 12, 1, '#006400');
--SELECT insert_into_brique(828, 4, 12, 1, '#006400');
--SELECT insert_into_brique(829, 6, 12, 1, '#006400');
--SELECT insert_into_brique(830, 8, 12, 1, '#006400');
--SELECT insert_into_brique(831, 10, 12, 1, '#006400');
--SELECT insert_into_brique(832, 12, 12, 1, '#006400');
--SELECT insert_into_brique(833, 1, 1, 0.33, '#006400');
--SELECT insert_into_brique(834, 2, 1, 0.33, '#006400');
--SELECT insert_into_brique(835, 3, 1, 0.33, '#006400');
--SELECT insert_into_brique(836, 4, 1, 0.33, '#006400');
--SELECT insert_into_brique(837, 6, 1, 0.33, '#006400');
--SELECT insert_into_brique(838, 8, 1, 0.33, '#006400');
--SELECT insert_into_brique(839, 10, 1, 0.33, '#006400');
--SELECT insert_into_brique(840, 12, 1, 0.33, '#006400');
--SELECT insert_into_brique(841, 1, 2, 0.33, '#006400');
--SELECT insert_into_brique(842, 2, 2, 0.33, '#006400');
--SELECT insert_into_brique(843, 3, 2, 0.33, '#006400');
--SELECT insert_into_brique(844, 4, 2, 0.33, '#006400');
--SELECT insert_into_brique(845, 6, 2, 0.33, '#006400');
--SELECT insert_into_brique(846, 8, 2, 0.33, '#006400');
--SELECT insert_into_brique(847, 10, 2, 0.33, '#006400');
--SELECT insert_into_brique(848, 12, 2, 0.33, '#006400');
--SELECT insert_into_brique(849, 1, 3, 0.33, '#006400');
--SELECT insert_into_brique(850, 2, 3, 0.33, '#006400');
--SELECT insert_into_brique(851, 3, 3, 0.33, '#006400');
--SELECT insert_into_brique(852, 4, 3, 0.33, '#006400');
--SELECT insert_into_brique(853, 6, 3, 0.33, '#006400');
--SELECT insert_into_brique(854, 8, 3, 0.33, '#006400');
--SELECT insert_into_brique(855, 10, 3, 0.33, '#006400');
--SELECT insert_into_brique(856, 12, 3, 0.33, '#006400');
--SELECT insert_into_brique(857, 1, 4, 0.33, '#006400');
--SELECT insert_into_brique(858, 2, 4, 0.33, '#006400');
--SELECT insert_into_brique(859, 3, 4, 0.33, '#006400');
--SELECT insert_into_brique(860, 4, 4, 0.33, '#006400');
--SELECT insert_into_brique(861, 6, 4, 0.33, '#006400');
--SELECT insert_into_brique(862, 8, 4, 0.33, '#006400');
--SELECT insert_into_brique(863, 10, 4, 0.33, '#006400');
--SELECT insert_into_brique(864, 12, 4, 0.33, '#006400');
--SELECT insert_into_brique(865, 1, 6, 0.33, '#006400');
--SELECT insert_into_brique(866, 2, 6, 0.33, '#006400');
--SELECT insert_into_brique(867, 3, 6, 0.33, '#006400');
--SELECT insert_into_brique(868, 4, 6, 0.33, '#006400');
--SELECT insert_into_brique(869, 6, 6, 0.33, '#006400');
--SELECT insert_into_brique(870, 8, 6, 0.33, '#006400');
--SELECT insert_into_brique(871, 10, 6, 0.33, '#006400');
--SELECT insert_into_brique(872, 12, 6, 0.33, '#006400');
--SELECT insert_into_brique(873, 1, 8, 0.33, '#006400');
--SELECT insert_into_brique(874, 2, 8, 0.33, '#006400');
--SELECT insert_into_brique(875, 3, 8, 0.33, '#006400');
--SELECT insert_into_brique(876, 4, 8, 0.33, '#006400');
--SELECT insert_into_brique(877, 6, 8, 0.33, '#006400');
--SELECT insert_into_brique(878, 8, 8, 0.33, '#006400');
--SELECT insert_into_brique(879, 10, 8, 0.33, '#006400');
--SELECT insert_into_brique(880, 12, 8, 0.33, '#006400');
--SELECT insert_into_brique(881, 1, 10, 0.33, '#006400');
--SELECT insert_into_brique(882, 2, 10, 0.33, '#006400');
--SELECT insert_into_brique(883, 3, 10, 0.33, '#006400');
--SELECT insert_into_brique(884, 4, 10, 0.33, '#006400');
--SELECT insert_into_brique(885, 6, 10, 0.33, '#006400');
--SELECT insert_into_brique(886, 8, 10, 0.33, '#006400');
--SELECT insert_into_brique(887, 10, 10, 0.33, '#006400');
--SELECT insert_into_brique(888, 12, 10, 0.33, '#006400');
--SELECT insert_into_brique(889, 1, 12, 0.33, '#006400');
--SELECT insert_into_brique(890, 2, 12, 0.33, '#006400');
--SELECT insert_into_brique(891, 3, 12, 0.33, '#006400');
--SELECT insert_into_brique(892, 4, 12, 0.33, '#006400');
--SELECT insert_into_brique(893, 6, 12, 0.33, '#006400');
--SELECT insert_into_brique(894, 8, 12, 0.33, '#006400');
--SELECT insert_into_brique(895, 10, 12, 0.33, '#006400');
--SELECT insert_into_brique(896, 12, 12, 0.33, '#006400');
--SELECT insert_into_brique(897, 1, 1, 1, '#ffff00');
--SELECT insert_into_brique(898, 2, 1, 1, '#ffff00');
--SELECT insert_into_brique(899, 3, 1, 1, '#ffff00');
--SELECT insert_into_brique(900, 4, 1, 1, '#ffff00');
--SELECT insert_into_brique(901, 6, 1, 1, '#ffff00');
--SELECT insert_into_brique(902, 8, 1, 1, '#ffff00');
--SELECT insert_into_brique(903, 10, 1, 1, '#ffff00');
--SELECT insert_into_brique(904, 12, 1, 1, '#ffff00');
--SELECT insert_into_brique(905, 1, 2, 1, '#ffff00');
--SELECT insert_into_brique(906, 2, 2, 1, '#ffff00');
--SELECT insert_into_brique(907, 3, 2, 1, '#ffff00');
--SELECT insert_into_brique(908, 4, 2, 1, '#ffff00');
--SELECT insert_into_brique(909, 6, 2, 1, '#ffff00');
--SELECT insert_into_brique(910, 8, 2, 1, '#ffff00');
--SELECT insert_into_brique(911, 10, 2, 1, '#ffff00');
--SELECT insert_into_brique(912, 12, 2, 1, '#ffff00');
--SELECT insert_into_brique(913, 1, 3, 1, '#ffff00');
--SELECT insert_into_brique(914, 2, 3, 1, '#ffff00');
--SELECT insert_into_brique(915, 3, 3, 1, '#ffff00');
--SELECT insert_into_brique(916, 4, 3, 1, '#ffff00');
--SELECT insert_into_brique(917, 6, 3, 1, '#ffff00');
--SELECT insert_into_brique(918, 8, 3, 1, '#ffff00');
--SELECT insert_into_brique(919, 10, 3, 1, '#ffff00');
--SELECT insert_into_brique(920, 12, 3, 1, '#ffff00');
--SELECT insert_into_brique(921, 1, 4, 1, '#ffff00');
--SELECT insert_into_brique(922, 2, 4, 1, '#ffff00');
--SELECT insert_into_brique(923, 3, 4, 1, '#ffff00');
--SELECT insert_into_brique(924, 4, 4, 1, '#ffff00');
--SELECT insert_into_brique(925, 6, 4, 1, '#ffff00');
--SELECT insert_into_brique(926, 8, 4, 1, '#ffff00');
--SELECT insert_into_brique(927, 10, 4, 1, '#ffff00');
--SELECT insert_into_brique(928, 12, 4, 1, '#ffff00');
--SELECT insert_into_brique(929, 1, 6, 1, '#ffff00');
--SELECT insert_into_brique(930, 2, 6, 1, '#ffff00');
--SELECT insert_into_brique(931, 3, 6, 1, '#ffff00');
--SELECT insert_into_brique(932, 4, 6, 1, '#ffff00');
--SELECT insert_into_brique(933, 6, 6, 1, '#ffff00');
--SELECT insert_into_brique(934, 8, 6, 1, '#ffff00');
--SELECT insert_into_brique(935, 10, 6, 1, '#ffff00');
--SELECT insert_into_brique(936, 12, 6, 1, '#ffff00');
--SELECT insert_into_brique(937, 1, 8, 1, '#ffff00');
--SELECT insert_into_brique(938, 2, 8, 1, '#ffff00');
--SELECT insert_into_brique(939, 3, 8, 1, '#ffff00');
--SELECT insert_into_brique(940, 4, 8, 1, '#ffff00');
--SELECT insert_into_brique(941, 6, 8, 1, '#ffff00');
--SELECT insert_into_brique(942, 8, 8, 1, '#ffff00');
--SELECT insert_into_brique(943, 10, 8, 1, '#ffff00');
--SELECT insert_into_brique(944, 12, 8, 1, '#ffff00');
--SELECT insert_into_brique(945, 1, 10, 1, '#ffff00');
--SELECT insert_into_brique(946, 2, 10, 1, '#ffff00');
--SELECT insert_into_brique(947, 3, 10, 1, '#ffff00');
--SELECT insert_into_brique(948, 4, 10, 1, '#ffff00');
--SELECT insert_into_brique(949, 6, 10, 1, '#ffff00');
--SELECT insert_into_brique(950, 8, 10, 1, '#ffff00');
--SELECT insert_into_brique(951, 10, 10, 1, '#ffff00');
--SELECT insert_into_brique(952, 12, 10, 1, '#ffff00');
--SELECT insert_into_brique(953, 1, 12, 1, '#ffff00');
--SELECT insert_into_brique(954, 2, 12, 1, '#ffff00');
--SELECT insert_into_brique(955, 3, 12, 1, '#ffff00');
--SELECT insert_into_brique(956, 4, 12, 1, '#ffff00');
--SELECT insert_into_brique(957, 6, 12, 1, '#ffff00');
--SELECT insert_into_brique(958, 8, 12, 1, '#ffff00');
--SELECT insert_into_brique(959, 10, 12, 1, '#ffff00');
--SELECT insert_into_brique(960, 12, 12, 1, '#ffff00');
--SELECT insert_into_brique(961, 1, 1, 0.33, '#ffff00');
--SELECT insert_into_brique(962, 2, 1, 0.33, '#ffff00');
--SELECT insert_into_brique(963, 3, 1, 0.33, '#ffff00');
--SELECT insert_into_brique(964, 4, 1, 0.33, '#ffff00');
--SELECT insert_into_brique(965, 6, 1, 0.33, '#ffff00');
--SELECT insert_into_brique(966, 8, 1, 0.33, '#ffff00');
--SELECT insert_into_brique(967, 10, 1, 0.33, '#ffff00');
--SELECT insert_into_brique(968, 12, 1, 0.33, '#ffff00');
--SELECT insert_into_brique(969, 1, 2, 0.33, '#ffff00');
--SELECT insert_into_brique(970, 2, 2, 0.33, '#ffff00');
--SELECT insert_into_brique(971, 3, 2, 0.33, '#ffff00');
--SELECT insert_into_brique(972, 4, 2, 0.33, '#ffff00');
--SELECT insert_into_brique(973, 6, 2, 0.33, '#ffff00');
--SELECT insert_into_brique(974, 8, 2, 0.33, '#ffff00');
--SELECT insert_into_brique(975, 10, 2, 0.33, '#ffff00');
--SELECT insert_into_brique(976, 12, 2, 0.33, '#ffff00');
--SELECT insert_into_brique(977, 1, 3, 0.33, '#ffff00');
--SELECT insert_into_brique(978, 2, 3, 0.33, '#ffff00');
--SELECT insert_into_brique(979, 3, 3, 0.33, '#ffff00');
--SELECT insert_into_brique(980, 4, 3, 0.33, '#ffff00');
--SELECT insert_into_brique(981, 6, 3, 0.33, '#ffff00');
--SELECT insert_into_brique(982, 8, 3, 0.33, '#ffff00');
--SELECT insert_into_brique(983, 10, 3, 0.33, '#ffff00');
--SELECT insert_into_brique(984, 12, 3, 0.33, '#ffff00');
--SELECT insert_into_brique(985, 1, 4, 0.33, '#ffff00');
--SELECT insert_into_brique(986, 2, 4, 0.33, '#ffff00');
--SELECT insert_into_brique(987, 3, 4, 0.33, '#ffff00');
--SELECT insert_into_brique(988, 4, 4, 0.33, '#ffff00');
--SELECT insert_into_brique(989, 6, 4, 0.33, '#ffff00');
--SELECT insert_into_brique(990, 8, 4, 0.33, '#ffff00');
--SELECT insert_into_brique(991, 10, 4, 0.33, '#ffff00');
--SELECT insert_into_brique(992, 12, 4, 0.33, '#ffff00');
--SELECT insert_into_brique(993, 1, 6, 0.33, '#ffff00');
--SELECT insert_into_brique(994, 2, 6, 0.33, '#ffff00');
--SELECT insert_into_brique(995, 3, 6, 0.33, '#ffff00');
--SELECT insert_into_brique(996, 4, 6, 0.33, '#ffff00');
--SELECT insert_into_brique(997, 6, 6, 0.33, '#ffff00');
--SELECT insert_into_brique(998, 8, 6, 0.33, '#ffff00');
--SELECT insert_into_brique(999, 10, 6, 0.33, '#ffff00');
--SELECT insert_into_brique(1000, 12, 6, 0.33, '#ffff00');
--SELECT insert_into_brique(1001, 1, 8, 0.33, '#ffff00');
--SELECT insert_into_brique(1002, 2, 8, 0.33, '#ffff00');
--SELECT insert_into_brique(1003, 3, 8, 0.33, '#ffff00');
--SELECT insert_into_brique(1004, 4, 8, 0.33, '#ffff00');
--SELECT insert_into_brique(1005, 6, 8, 0.33, '#ffff00');
--SELECT insert_into_brique(1006, 8, 8, 0.33, '#ffff00');
--SELECT insert_into_brique(1007, 10, 8, 0.33, '#ffff00');
--SELECT insert_into_brique(1008, 12, 8, 0.33, '#ffff00');
--SELECT insert_into_brique(1009, 1, 10, 0.33, '#ffff00');
--SELECT insert_into_brique(1010, 2, 10, 0.33, '#ffff00');
--SELECT insert_into_brique(1011, 3, 10, 0.33, '#ffff00');
--SELECT insert_into_brique(1012, 4, 10, 0.33, '#ffff00');
--SELECT insert_into_brique(1013, 6, 10, 0.33, '#ffff00');
--SELECT insert_into_brique(1014, 8, 10, 0.33, '#ffff00');
--SELECT insert_into_brique(1015, 10, 10, 0.33, '#ffff00');
--SELECT insert_into_brique(1016, 12, 10, 0.33, '#ffff00');
--SELECT insert_into_brique(1017, 1, 12, 0.33, '#ffff00');
--SELECT insert_into_brique(1018, 2, 12, 0.33, '#ffff00');
--SELECT insert_into_brique(1019, 3, 12, 0.33, '#ffff00');
--SELECT insert_into_brique(1020, 4, 12, 0.33, '#ffff00');
--SELECT insert_into_brique(1021, 6, 12, 0.33, '#ffff00');
--SELECT insert_into_brique(1022, 8, 12, 0.33, '#ffff00');
--SELECT insert_into_brique(1023, 10, 12, 0.33, '#ffff00');
--SELECT insert_into_brique(1024, 12, 12, 0.33, '#ffff00');
--SELECT insert_into_brique(1025, 1, 1, 1, '#7b68ee');
--SELECT insert_into_brique(1026, 2, 1, 1, '#7b68ee');
--SELECT insert_into_brique(1027, 3, 1, 1, '#7b68ee');
--SELECT insert_into_brique(1028, 4, 1, 1, '#7b68ee');
--SELECT insert_into_brique(1029, 6, 1, 1, '#7b68ee');
--SELECT insert_into_brique(1030, 8, 1, 1, '#7b68ee');
--SELECT insert_into_brique(1031, 10, 1, 1, '#7b68ee');
--SELECT insert_into_brique(1032, 12, 1, 1, '#7b68ee');
--SELECT insert_into_brique(1033, 1, 2, 1, '#7b68ee');
--SELECT insert_into_brique(1034, 2, 2, 1, '#7b68ee');
--SELECT insert_into_brique(1035, 3, 2, 1, '#7b68ee');
--SELECT insert_into_brique(1036, 4, 2, 1, '#7b68ee');
--SELECT insert_into_brique(1037, 6, 2, 1, '#7b68ee');
--SELECT insert_into_brique(1038, 8, 2, 1, '#7b68ee');
--SELECT insert_into_brique(1039, 10, 2, 1, '#7b68ee');
--SELECT insert_into_brique(1040, 12, 2, 1, '#7b68ee');
--SELECT insert_into_brique(1041, 1, 3, 1, '#7b68ee');
--SELECT insert_into_brique(1042, 2, 3, 1, '#7b68ee');
--SELECT insert_into_brique(1043, 3, 3, 1, '#7b68ee');
--SELECT insert_into_brique(1044, 4, 3, 1, '#7b68ee');
--SELECT insert_into_brique(1045, 6, 3, 1, '#7b68ee');
--SELECT insert_into_brique(1046, 8, 3, 1, '#7b68ee');
--SELECT insert_into_brique(1047, 10, 3, 1, '#7b68ee');
--SELECT insert_into_brique(1048, 12, 3, 1, '#7b68ee');
--SELECT insert_into_brique(1049, 1, 4, 1, '#7b68ee');
--SELECT insert_into_brique(1050, 2, 4, 1, '#7b68ee');
--SELECT insert_into_brique(1051, 3, 4, 1, '#7b68ee');
--SELECT insert_into_brique(1052, 4, 4, 1, '#7b68ee');
--SELECT insert_into_brique(1053, 6, 4, 1, '#7b68ee');
--SELECT insert_into_brique(1054, 8, 4, 1, '#7b68ee');
--SELECT insert_into_brique(1055, 10, 4, 1, '#7b68ee');
--SELECT insert_into_brique(1056, 12, 4, 1, '#7b68ee');
--SELECT insert_into_brique(1057, 1, 6, 1, '#7b68ee');
--SELECT insert_into_brique(1058, 2, 6, 1, '#7b68ee');
--SELECT insert_into_brique(1059, 3, 6, 1, '#7b68ee');
--SELECT insert_into_brique(1060, 4, 6, 1, '#7b68ee');
--SELECT insert_into_brique(1061, 6, 6, 1, '#7b68ee');
--SELECT insert_into_brique(1062, 8, 6, 1, '#7b68ee');
--SELECT insert_into_brique(1063, 10, 6, 1, '#7b68ee');
--SELECT insert_into_brique(1064, 12, 6, 1, '#7b68ee');
--SELECT insert_into_brique(1065, 1, 8, 1, '#7b68ee');
--SELECT insert_into_brique(1066, 2, 8, 1, '#7b68ee');
--SELECT insert_into_brique(1067, 3, 8, 1, '#7b68ee');
--SELECT insert_into_brique(1068, 4, 8, 1, '#7b68ee');
--SELECT insert_into_brique(1069, 6, 8, 1, '#7b68ee');
--SELECT insert_into_brique(1070, 8, 8, 1, '#7b68ee');
--SELECT insert_into_brique(1071, 10, 8, 1, '#7b68ee');
--SELECT insert_into_brique(1072, 12, 8, 1, '#7b68ee');
--SELECT insert_into_brique(1073, 1, 10, 1, '#7b68ee');
--SELECT insert_into_brique(1074, 2, 10, 1, '#7b68ee');
--SELECT insert_into_brique(1075, 3, 10, 1, '#7b68ee');
--SELECT insert_into_brique(1076, 4, 10, 1, '#7b68ee');
--SELECT insert_into_brique(1077, 6, 10, 1, '#7b68ee');
--SELECT insert_into_brique(1078, 8, 10, 1, '#7b68ee');
--SELECT insert_into_brique(1079, 10, 10, 1, '#7b68ee');
--SELECT insert_into_brique(1080, 12, 10, 1, '#7b68ee');
--SELECT insert_into_brique(1081, 1, 12, 1, '#7b68ee');
--SELECT insert_into_brique(1082, 2, 12, 1, '#7b68ee');
--SELECT insert_into_brique(1083, 3, 12, 1, '#7b68ee');
--SELECT insert_into_brique(1084, 4, 12, 1, '#7b68ee');
--SELECT insert_into_brique(1085, 6, 12, 1, '#7b68ee');
--SELECT insert_into_brique(1086, 8, 12, 1, '#7b68ee');
--SELECT insert_into_brique(1087, 10, 12, 1, '#7b68ee');
--SELECT insert_into_brique(1088, 12, 12, 1, '#7b68ee');
--SELECT insert_into_brique(1089, 1, 1, 0.33, '#7b68ee');
--SELECT insert_into_brique(1090, 2, 1, 0.33, '#7b68ee');
--SELECT insert_into_brique(1091, 3, 1, 0.33, '#7b68ee');
--SELECT insert_into_brique(1092, 4, 1, 0.33, '#7b68ee');
--SELECT insert_into_brique(1093, 6, 1, 0.33, '#7b68ee');
--SELECT insert_into_brique(1094, 8, 1, 0.33, '#7b68ee');
--SELECT insert_into_brique(1095, 10, 1, 0.33, '#7b68ee');
--SELECT insert_into_brique(1096, 12, 1, 0.33, '#7b68ee');
--SELECT insert_into_brique(1097, 1, 2, 0.33, '#7b68ee');
--SELECT insert_into_brique(1098, 2, 2, 0.33, '#7b68ee');
--SELECT insert_into_brique(1099, 3, 2, 0.33, '#7b68ee');
--SELECT insert_into_brique(1100, 4, 2, 0.33, '#7b68ee');
--SELECT insert_into_brique(1101, 6, 2, 0.33, '#7b68ee');
--SELECT insert_into_brique(1102, 8, 2, 0.33, '#7b68ee');
--SELECT insert_into_brique(1103, 10, 2, 0.33, '#7b68ee');
--SELECT insert_into_brique(1104, 12, 2, 0.33, '#7b68ee');
--SELECT insert_into_brique(1105, 1, 3, 0.33, '#7b68ee');
--SELECT insert_into_brique(1106, 2, 3, 0.33, '#7b68ee');
--SELECT insert_into_brique(1107, 3, 3, 0.33, '#7b68ee');
--SELECT insert_into_brique(1108, 4, 3, 0.33, '#7b68ee');
--SELECT insert_into_brique(1109, 6, 3, 0.33, '#7b68ee');
--SELECT insert_into_brique(1110, 8, 3, 0.33, '#7b68ee');
--SELECT insert_into_brique(1111, 10, 3, 0.33, '#7b68ee');
--SELECT insert_into_brique(1112, 12, 3, 0.33, '#7b68ee');
--SELECT insert_into_brique(1113, 1, 4, 0.33, '#7b68ee');
--SELECT insert_into_brique(1114, 2, 4, 0.33, '#7b68ee');
--SELECT insert_into_brique(1115, 3, 4, 0.33, '#7b68ee');
--SELECT insert_into_brique(1116, 4, 4, 0.33, '#7b68ee');
--SELECT insert_into_brique(1117, 6, 4, 0.33, '#7b68ee');
--SELECT insert_into_brique(1118, 8, 4, 0.33, '#7b68ee');
--SELECT insert_into_brique(1119, 10, 4, 0.33, '#7b68ee');
--SELECT insert_into_brique(1120, 12, 4, 0.33, '#7b68ee');
--SELECT insert_into_brique(1121, 1, 6, 0.33, '#7b68ee');
--SELECT insert_into_brique(1122, 2, 6, 0.33, '#7b68ee');
--SELECT insert_into_brique(1123, 3, 6, 0.33, '#7b68ee');
--SELECT insert_into_brique(1124, 4, 6, 0.33, '#7b68ee');
--SELECT insert_into_brique(1125, 6, 6, 0.33, '#7b68ee');
--SELECT insert_into_brique(1126, 8, 6, 0.33, '#7b68ee');
--SELECT insert_into_brique(1127, 10, 6, 0.33, '#7b68ee');
--SELECT insert_into_brique(1128, 12, 6, 0.33, '#7b68ee');
--SELECT insert_into_brique(1129, 1, 8, 0.33, '#7b68ee');
--SELECT insert_into_brique(1130, 2, 8, 0.33, '#7b68ee');
--SELECT insert_into_brique(1131, 3, 8, 0.33, '#7b68ee');
--SELECT insert_into_brique(1132, 4, 8, 0.33, '#7b68ee');
--SELECT insert_into_brique(1133, 6, 8, 0.33, '#7b68ee');
--SELECT insert_into_brique(1134, 8, 8, 0.33, '#7b68ee');
--SELECT insert_into_brique(1135, 10, 8, 0.33, '#7b68ee');
--SELECT insert_into_brique(1136, 12, 8, 0.33, '#7b68ee');
--SELECT insert_into_brique(1137, 1, 10, 0.33, '#7b68ee');
--SELECT insert_into_brique(1138, 2, 10, 0.33, '#7b68ee');
--SELECT insert_into_brique(1139, 3, 10, 0.33, '#7b68ee');
--SELECT insert_into_brique(1140, 4, 10, 0.33, '#7b68ee');
--SELECT insert_into_brique(1141, 6, 10, 0.33, '#7b68ee');
--SELECT insert_into_brique(1142, 8, 10, 0.33, '#7b68ee');
--SELECT insert_into_brique(1143, 10, 10, 0.33, '#7b68ee');
--SELECT insert_into_brique(1144, 12, 10, 0.33, '#7b68ee');
--SELECT insert_into_brique(1145, 1, 12, 0.33, '#7b68ee');
--SELECT insert_into_brique(1146, 2, 12, 0.33, '#7b68ee');
--SELECT insert_into_brique(1147, 3, 12, 0.33, '#7b68ee');
--SELECT insert_into_brique(1148, 4, 12, 0.33, '#7b68ee');
--SELECT insert_into_brique(1149, 6, 12, 0.33, '#7b68ee');
--SELECT insert_into_brique(1150, 8, 12, 0.33, '#7b68ee');
--SELECT insert_into_brique(1151, 10, 12, 0.33, '#7b68ee');
--SELECT insert_into_brique(1152, 12, 12, 0.33, '#7b68ee');
--SELECT insert_into_brique(1153, 1, 1, 1, '#ff0000');
--SELECT insert_into_brique(1154, 2, 1, 1, '#ff0000');
--SELECT insert_into_brique(1155, 3, 1, 1, '#ff0000');
--SELECT insert_into_brique(1156, 4, 1, 1, '#ff0000');
--SELECT insert_into_brique(1157, 6, 1, 1, '#ff0000');
--SELECT insert_into_brique(1158, 8, 1, 1, '#ff0000');
--SELECT insert_into_brique(1159, 10, 1, 1, '#ff0000');
--SELECT insert_into_brique(1160, 12, 1, 1, '#ff0000');
--SELECT insert_into_brique(1161, 1, 2, 1, '#ff0000');
--SELECT insert_into_brique(1162, 2, 2, 1, '#ff0000');
--SELECT insert_into_brique(1163, 3, 2, 1, '#ff0000');
--SELECT insert_into_brique(1164, 4, 2, 1, '#ff0000');
--SELECT insert_into_brique(1165, 6, 2, 1, '#ff0000');
--SELECT insert_into_brique(1166, 8, 2, 1, '#ff0000');
--SELECT insert_into_brique(1167, 10, 2, 1, '#ff0000');
--SELECT insert_into_brique(1168, 12, 2, 1, '#ff0000');
--SELECT insert_into_brique(1169, 1, 3, 1, '#ff0000');
--SELECT insert_into_brique(1170, 2, 3, 1, '#ff0000');
--SELECT insert_into_brique(1171, 3, 3, 1, '#ff0000');
--SELECT insert_into_brique(1172, 4, 3, 1, '#ff0000');
--SELECT insert_into_brique(1173, 6, 3, 1, '#ff0000');
--SELECT insert_into_brique(1174, 8, 3, 1, '#ff0000');
--SELECT insert_into_brique(1175, 10, 3, 1, '#ff0000');
--SELECT insert_into_brique(1176, 12, 3, 1, '#ff0000');
--SELECT insert_into_brique(1177, 1, 4, 1, '#ff0000');
--SELECT insert_into_brique(1178, 2, 4, 1, '#ff0000');
--SELECT insert_into_brique(1179, 3, 4, 1, '#ff0000');
--SELECT insert_into_brique(1180, 4, 4, 1, '#ff0000');
--SELECT insert_into_brique(1181, 6, 4, 1, '#ff0000');
--SELECT insert_into_brique(1182, 8, 4, 1, '#ff0000');
--SELECT insert_into_brique(1183, 10, 4, 1, '#ff0000');
--SELECT insert_into_brique(1184, 12, 4, 1, '#ff0000');
--SELECT insert_into_brique(1185, 1, 6, 1, '#ff0000');
--SELECT insert_into_brique(1186, 2, 6, 1, '#ff0000');
--SELECT insert_into_brique(1187, 3, 6, 1, '#ff0000');
--SELECT insert_into_brique(1188, 4, 6, 1, '#ff0000');
--SELECT insert_into_brique(1189, 6, 6, 1, '#ff0000');
--SELECT insert_into_brique(1190, 8, 6, 1, '#ff0000');
--SELECT insert_into_brique(1191, 10, 6, 1, '#ff0000');
--SELECT insert_into_brique(1192, 12, 6, 1, '#ff0000');
--SELECT insert_into_brique(1193, 1, 8, 1, '#ff0000');
--SELECT insert_into_brique(1194, 2, 8, 1, '#ff0000');
--SELECT insert_into_brique(1195, 3, 8, 1, '#ff0000');
--SELECT insert_into_brique(1196, 4, 8, 1, '#ff0000');
--SELECT insert_into_brique(1197, 6, 8, 1, '#ff0000');
--SELECT insert_into_brique(1198, 8, 8, 1, '#ff0000');
--SELECT insert_into_brique(1199, 10, 8, 1, '#ff0000');
--SELECT insert_into_brique(1200, 12, 8, 1, '#ff0000');
--SELECT insert_into_brique(1201, 1, 10, 1, '#ff0000');
--SELECT insert_into_brique(1202, 2, 10, 1, '#ff0000');
--SELECT insert_into_brique(1203, 3, 10, 1, '#ff0000');
--SELECT insert_into_brique(1204, 4, 10, 1, '#ff0000');
--SELECT insert_into_brique(1205, 6, 10, 1, '#ff0000');
--SELECT insert_into_brique(1206, 8, 10, 1, '#ff0000');
--SELECT insert_into_brique(1207, 10, 10, 1, '#ff0000');
--SELECT insert_into_brique(1208, 12, 10, 1, '#ff0000');
--SELECT insert_into_brique(1209, 1, 12, 1, '#ff0000');
--SELECT insert_into_brique(1210, 2, 12, 1, '#ff0000');
--SELECT insert_into_brique(1211, 3, 12, 1, '#ff0000');
--SELECT insert_into_brique(1212, 4, 12, 1, '#ff0000');
--SELECT insert_into_brique(1213, 6, 12, 1, '#ff0000');
--SELECT insert_into_brique(1214, 8, 12, 1, '#ff0000');
--SELECT insert_into_brique(1215, 10, 12, 1, '#ff0000');
--SELECT insert_into_brique(1216, 12, 12, 1, '#ff0000');
--SELECT insert_into_brique(1217, 1, 1, 0.33, '#ff0000');
--SELECT insert_into_brique(1218, 2, 1, 0.33, '#ff0000');
--SELECT insert_into_brique(1219, 3, 1, 0.33, '#ff0000');
--SELECT insert_into_brique(1220, 4, 1, 0.33, '#ff0000');
--SELECT insert_into_brique(1221, 6, 1, 0.33, '#ff0000');
--SELECT insert_into_brique(1222, 8, 1, 0.33, '#ff0000');
--SELECT insert_into_brique(1223, 10, 1, 0.33, '#ff0000');
--SELECT insert_into_brique(1224, 12, 1, 0.33, '#ff0000');
--SELECT insert_into_brique(1225, 1, 2, 0.33, '#ff0000');
--SELECT insert_into_brique(1226, 2, 2, 0.33, '#ff0000');
--SELECT insert_into_brique(1227, 3, 2, 0.33, '#ff0000');
--SELECT insert_into_brique(1228, 4, 2, 0.33, '#ff0000');
--SELECT insert_into_brique(1229, 6, 2, 0.33, '#ff0000');
--SELECT insert_into_brique(1230, 8, 2, 0.33, '#ff0000');
--SELECT insert_into_brique(1231, 10, 2, 0.33, '#ff0000');
--SELECT insert_into_brique(1232, 12, 2, 0.33, '#ff0000');
--SELECT insert_into_brique(1233, 1, 3, 0.33, '#ff0000');
--SELECT insert_into_brique(1234, 2, 3, 0.33, '#ff0000');
--SELECT insert_into_brique(1235, 3, 3, 0.33, '#ff0000');
--SELECT insert_into_brique(1236, 4, 3, 0.33, '#ff0000');
--SELECT insert_into_brique(1237, 6, 3, 0.33, '#ff0000');
--SELECT insert_into_brique(1238, 8, 3, 0.33, '#ff0000');
--SELECT insert_into_brique(1239, 10, 3, 0.33, '#ff0000');
--SELECT insert_into_brique(1240, 12, 3, 0.33, '#ff0000');
--SELECT insert_into_brique(1241, 1, 4, 0.33, '#ff0000');
--SELECT insert_into_brique(1242, 2, 4, 0.33, '#ff0000');
--SELECT insert_into_brique(1243, 3, 4, 0.33, '#ff0000');
--SELECT insert_into_brique(1244, 4, 4, 0.33, '#ff0000');
--SELECT insert_into_brique(1245, 6, 4, 0.33, '#ff0000');
--SELECT insert_into_brique(1246, 8, 4, 0.33, '#ff0000');
--SELECT insert_into_brique(1247, 10, 4, 0.33, '#ff0000');
--SELECT insert_into_brique(1248, 12, 4, 0.33, '#ff0000');
--SELECT insert_into_brique(1249, 1, 6, 0.33, '#ff0000');
--SELECT insert_into_brique(1250, 2, 6, 0.33, '#ff0000');
--SELECT insert_into_brique(1251, 3, 6, 0.33, '#ff0000');
--SELECT insert_into_brique(1252, 4, 6, 0.33, '#ff0000');
--SELECT insert_into_brique(1253, 6, 6, 0.33, '#ff0000');
--SELECT insert_into_brique(1254, 8, 6, 0.33, '#ff0000');
--SELECT insert_into_brique(1255, 10, 6, 0.33, '#ff0000');
--SELECT insert_into_brique(1256, 12, 6, 0.33, '#ff0000');
--SELECT insert_into_brique(1257, 1, 8, 0.33, '#ff0000');
--SELECT insert_into_brique(1258, 2, 8, 0.33, '#ff0000');
--SELECT insert_into_brique(1259, 3, 8, 0.33, '#ff0000');
--SELECT insert_into_brique(1260, 4, 8, 0.33, '#ff0000');
--SELECT insert_into_brique(1261, 6, 8, 0.33, '#ff0000');
--SELECT insert_into_brique(1262, 8, 8, 0.33, '#ff0000');
--SELECT insert_into_brique(1263, 10, 8, 0.33, '#ff0000');
--SELECT insert_into_brique(1264, 12, 8, 0.33, '#ff0000');
--SELECT insert_into_brique(1265, 1, 10, 0.33, '#ff0000');
--SELECT insert_into_brique(1266, 2, 10, 0.33, '#ff0000');
--SELECT insert_into_brique(1267, 3, 10, 0.33, '#ff0000');
--SELECT insert_into_brique(1268, 4, 10, 0.33, '#ff0000');
--SELECT insert_into_brique(1269, 6, 10, 0.33, '#ff0000');
--SELECT insert_into_brique(1270, 8, 10, 0.33, '#ff0000');
--SELECT insert_into_brique(1271, 10, 10, 0.33, '#ff0000');
--SELECT insert_into_brique(1272, 12, 10, 0.33, '#ff0000');
--SELECT insert_into_brique(1273, 1, 12, 0.33, '#ff0000');
--SELECT insert_into_brique(1274, 2, 12, 0.33, '#ff0000');
--SELECT insert_into_brique(1275, 3, 12, 0.33, '#ff0000');
--SELECT insert_into_brique(1276, 4, 12, 0.33, '#ff0000');
--SELECT insert_into_brique(1277, 6, 12, 0.33, '#ff0000');
--SELECT insert_into_brique(1278, 8, 12, 0.33, '#ff0000');
--SELECT insert_into_brique(1279, 10, 12, 0.33, '#ff0000');
--SELECT insert_into_brique(1280, 12, 12, 0.33, '#ff0000');


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
    (1, 'Castle'), 
    (2, 'Spaceship');

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
    ('Main Photo', 'Main image of the brick set', '/images/main_photo.jpg', 1),
    ('Detail Shot', 'Close-up of the blue block', '/images/blue_block.jpg', 2);

-- Step 10: Insert into SCORES (SCORES references Partie and Joueuses)
INSERT INTO SCORES (date_debut, prenom_J, score) 
VALUES 
    ('2023-01-01', 'Alice', '85'), 
    ('2023-01-15', 'Bob', '90');

-- Step 11: Insert into Substitution (Substitution references Brique)
INSERT INTO Substitution (id_S, nom_S, commentaire, id_B) 
VALUES 
    ('S1', 'Alternate Red Brick', 'Use this if Red Brick is unavailable', 1),
    ('S2', 'Alternate Blue Block', 'Can replace Blue Block for stability', 2);

-- Step 12: Insert into Tour (Tour references Partie, Joueuses, and Brique)
INSERT INTO Tour (numero_T, date_debut, prenom_J, id_B, description_Action) 
VALUES 
    ('1', '2023-01-01', 'Alice', 1, 'défaussée'), 
    ('2', '2023-01-15', 'Bob',2, 'placée');
	