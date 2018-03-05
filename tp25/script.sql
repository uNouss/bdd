-- Q1: création des tables

DROP TABLE commande;
DROP TABLE fournisseurs;
DROP TABLE produit;

CREATE TABLE fournisseurs(
    fno     SERIAL,
    nom     VARCHAR(20),
    prenom  VARCHAR(30),
    adresse VARCHAR(50),
    tel     CHAR(10) CONSTRAINT tel_length CHECK( LENGTH(tel) = 10),
    CONSTRAINT pk_fournisseur PRIMARY KEY(fno)
);

CREATE TABLE produit(
    pno     SERIAL,
    libelle VARCHAR(50),
    couleur VARCHAR(20),
    poids   INT CONSTRAINT ctr_poids CHECK( poids > 0 ),
    CONSTRAINT pk_produit PRIMARY KEY(pno)
);

CREATE TABLE commande(
    fno     SERIAL,
    pno     SERIAL,
    prix    INT CONSTRAINT ctr_prix CHECK( prix > 0 ),
    qute    INT CONSTRAINT ctr_qute CHECK( qute > 0 ),
    CONSTRAINT pk_commande PRIMARY KEY(fno, pno),
    CONSTRAINT fk_fournisseur FOREIGN KEY(fno)
        REFERENCES fournisseurs(fno)
        ON UPDATE CASCADE ON DELETE CASCADE, -- ON DELETE SET NULL : au lieu d'effacer met null
    CONSTRAINT fk_produit FOREIGN KEY(pno)
        REFERENCES produit(pno)
        ON UPDATE CASCADE ON DELETE CASCADE  -- ON DELETE SET NULL : au lieu d'effacer met null 
);

-- Q2: insertion dans fournisseurs

INSERT INTO fournisseurs(nom, prenom) VALUES('Dupont', 'Paul');
INSERT INTO fournisseurs(nom, prenom) VALUES('Durant', 'Pierre');

SELECT * FROM fournisseurs;
-- Q3: insertion dans produits

INSERT INTO produit(libelle, couleur) VALUES('Chaise','rouge');
INSERT INTO produit(libelle, couleur) VALUES('Bureau','gris');

SELECT * FROM produit;
-- Q4: On passe des commandes

INSERT INTO commande(fno, pno, prix, qute) VALUES(1, 1, 50, 1);
INSERT INTO commande(fno, pno, prix, qute) VALUES(1, 2, 45, 2);
INSERT INTO commande(fno, pno, prix, qute) VALUES(2, 1, 50, 3);
INSERT INTO commande(fno, pno, prix, qute) VALUES(2, 2, 45, 4);

SELECT * FROM commande;
-- Q5: On essaie de passer une commande d'un produit qui n'existe pas
INSERT INTO commande(fno, pno, prix, qute) VALUES(2, 3, 45, 4);
/*cette insertion provoque une violation de contrainte lié
  à la non existence de cette clé primaire dans la table produit
*/
SELECT * FROM commande;
-- Q6: On detruit un produit

DELETE FROM produit WHERE pno = 2;

SELECT * FROM commande;
