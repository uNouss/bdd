DROP TABLE IF EXISTS vol CASCADE;
DROP TABLE IF EXISTS ligne CASCADE;
DROP TABLE IF EXISTS avion CASCADE;
DROP TABLE IF EXISTS pilote CASCADE;
DROP TABLE IF EXISTS aéroport CASCADE;

CREATE TABLE avion(
    ano     INTEGER,
    type    CHAR(5),
    places INTEGER CONSTRAINT interval_place CHECK( places >= 100 AND places <= 500),
    compagnie VARCHAR(30),
    CONSTRAINT pk_avion PRIMARY KEY(ano)
);

CREATE TABLE pilote(
    pno     SERIAL,
    nom     VARCHAR(30) NOT NULL,
    prénom  VARCHAR(50) NOT NULL,
    adresseP    CHAR(80) NOT NULL,
    CONSTRAINT pk_pilote PRIMARY KEY(pno)
);

CREATE TABLE aéroport(
    rcode       CHAR(3),
    libellé     CHAR(60),
    ville       CHAR(30),
    adresseA    CHAR(80),
    CONSTRAINT pk_aéroport PRIMARY KEY(rcode)
);

CREATE TABLE ligne(
    lno     INTEGER,
    rcodeA     CHAR(3),
    rcodeD     CHAR(3),
    CONSTRAINT pk_ligne PRIMARY KEY(lno),
    CONSTRAINT fk_aéroportA FOREIGN KEY(rcodeA) REFERENCES aéroport(rcode) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_aéroportD FOREIGN KEY(rcodeD) REFERENCES aéroport(rcode) ON UPDATE CASCADE ON DELETE SET NULL
);


CREATE TABLE vol(
    ano     INTEGER,
    pno     INTEGER,
    lno     INTEGER,
    hDepart TIME,
    hArrive TIME,
    CONSTRAINT pk_vol PRIMARY KEY(ano, pno, lno),
    CONSTRAINT fk_avion FOREIGN KEY(ano) REFERENCES avion(ano) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pilote FOREIGN KEY(pno) REFERENCES pilote(pno) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ligne FOREIGN KEY(lno) REFERENCES ligne(lno) ON UPDATE CASCADE ON DELETE CASCADE
);

/* SUPPRESSION DES DONNEES DES TABLES */

DELETE FROM vol;
DELETE FROM aéroport;

/* Q4: tables temporaires */

DROP TABLE noms;
DROP TABLE prenoms;
DROP TABLE adresses;

CREATE TEMPORARY TABLE noms(
    nom     CHAR(20)
);

CREATE TEMPORARY TABLE prenoms(
    prenom     CHAR(20)
);

CREATE TEMPORARY TABLE adresses(
    adresse     CHAR(50)
);

INSERT INTO noms VALUES('Haddock');
INSERT INTO noms VALUES('Tournesol');
INSERT INTO noms VALUES('Bergamotte');
INSERT INTO noms VALUES('Lampion');

INSERT INTO prenoms VALUES('Tryphon');
INSERT INTO prenoms VALUES('Archibald');
INSERT INTO prenoms VALUES('Hippolyte');
INSERT INTO prenoms VALUES('Séraphin');

INSERT INTO adresses VALUES('Moulinsart');
INSERT INTO adresses VALUES('Sbrodj');
INSERT INTO adresses VALUES('Bruxelles');
INSERT INTO adresses VALUES('Klow');


/* Q: 4 */

SELECT * FROM noms, prenoms, adresses;


/* Q6 */

ALTER SEQUENCE pilote_pno_seq RESTART WITH 100;


/* Q5: */

INSERT INTO pilote(nom, prénom, adresseP) SELECT * FROM noms, prenoms, adresses;
SELECT * FROM pilote;

/* Q7 */

INSERT INTO avion VALUES(105 , 'A320', 300, 'AIR FRANCE');
INSERT INTO avion VALUES(106 , 'A380', 320, 'LUFTHANSA');
INSERT INTO avion VALUES(107 , 'B747', 500, 'AIR FRANCE');
INSERT INTO avion VALUES(108 , 'A320', 300, 'TWA');
INSERT INTO avion VALUES(109 , 'B747', 450, 'PANAM');
INSERT INTO avion VALUES(110 , 'A320', 300, 'IBERAMIA');
INSERT INTO avion VALUES(111 , 'A320', 300, NULL);


/* Q8 */

DROP TABLE compagnies;

CREATE TEMPORARY TABLE compagnies(compagnie) AS SELECT DISTINCT compagnie FROM avion WHERE compagnie IS NOT NULL;
SELECT * from compagnies;

/* Q9 */

DROP TABLE modeles;

CREATE TEMPORARY TABLE modeles(type, places) AS SELECT type, MAX(places) FROM avion GROUP BY type;
SELECT * from modeles;


/* Q10 */

SELECT * FROM avion;

DROP SEQUENCE numeros;
CREATE SEQUENCE numeros START 130;


INSERT INTO avion SELECT DISTINCT nextval('numeros'), type, places, compagnie FROM modeles, compagnies;
SELECT * FROM avion;

INSERT INTO aéroport(rcode, libellé, ville) VALUES ('JFK', 'John Fitzgerald Kennedy', 'New-York') ;
INSERT INTO aéroport(rcode, libellé,ville) VALUES ('CDG', 'Roissy Charles de Gaulles','Paris') ;
INSERT INTO aéroport(rcode, libellé,ville) VALUES ('MAD', 'Madrid Barajas','Madrid') ;
INSERT INTO aéroport(rcode, libellé) VALUES ('BRU', 'Bruxelles') ;
INSERT INTO aéroport(rcode, libellé) VALUES ('GVA', 'Genève') ;
INSERT INTO aéroport(rcode, libellé, ville) VALUES ('ORY', 'Orly', 'Paris') ;
INSERT INTO aéroport(rcode, libellé) VALUES ('LAI', 'Lannion') ;
INSERT INTO aéroport(rcode, libellé, ville) VALUES ('LIL', 'Lille-Lesquin', 'Lille') ;

SELECT * FROM aéroport;
/* Q11*/

UPDATE aéroport SET ville=libellé WHERE ville IS NULL;

SELECT * FROM aéroport;

/* Q12 */

SELECT * FROM ligne;

DROP SEQUENCE numerosLignes;
CREATE SEQUENCE numerosLignes START 1000;

INSERT INTO ligne SELECT nextval('numerosLignes'), a1.rcode, a2.rcode FROM aéroport AS a1, aéroport AS a2 WHERE a1.rcode <> a2.rcode;

SELECT * FROM ligne;


/* Q13 */

SELECT * FROM vol;

INSERT INTO vol(ano, pno, lno) SELECT ano, pno, lno FROM ligne, pilote, avion
                WHERE (rcodeA IN('CDG', 'JFK', 'MAD') OR rcodeD IN('CDG', 'JFK', 'MAD'))
                            AND pno % 7 = 0
                            AND (type LIKE 'A%' AND compagnie = 'AIR FRANCE');

SELECT * FROM vol;
