DROP VIEW IF EXISTS maximums;
DROP VIEW IF EXISTS messcores;
DROP TABLE scores;
DROP TABLE jeu;

CREATE TABLE jeu(
    id INT,
    nom text,
    CONSTRAINT pk_jeu PRIMARY KEY(id)
);

INSERT INTO jeu VALUES(1, 'Jeu A');
INSERT INTO jeu VALUES(2, 'Jeu B');
INSERT INTO jeu VALUES(3, 'Jeu C');

SELECT * FROM jeu;

CREATE TABLE scores(
    login CHAR(20),
    id    INT,
    score INT,
    CONSTRAINT fk_jeu FOREIGN KEY(id) REFERENCES jeu(id)
);


INSERT INTO scores VALUES('sowy', 1,10);
INSERT INTO scores VALUES('sowy', 1, 4);
INSERT INTO scores VALUES('sowy', 2, 14);
INSERT INTO scores VALUES('sowy', 3, 12);
INSERT INTO scores VALUES('vintaerj', 1, 15);
INSERT INTO scores VALUES('vintaerj', 2, 13);
INSERT INTO scores VALUES('vintaerj', 3, 17);

SELECT * FROM scores;

CREATE VIEW messcores AS SELECT * FROM scores WHERE login=USER;

SELECT * FROM messcores;

CREATE VIEW maximums
    AS SELECT id,login, MAX(score) FROM scores
    GROUP BY login, id;

SELECT * FROM maximums;


--GRANT USAGE ON SCHEMA sowy TO vintaerj;
GRANT SELECT ON messcores TO vintaerj;
GRANT SELECT ON maximums TO vintaerj;

SELECT * FROM vintaerj.maximums;
SELECT * FROM vintaerj.messcores;

SELECT * FROM vintaerj.scores; -- non droit réfusé

GRANT INSERT ON jeu TO vintaerj;

INSERT INTO vintaerj.jeu VALUES(14, 'Jeu D');

SELECT * FROM jeu;

INSERT INTO scores VALUES('vintaerj', 4,25);
