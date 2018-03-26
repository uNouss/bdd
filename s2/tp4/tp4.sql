--


DROP TABLE IF EXISTS import;

CREATE TABLE import(
    n0 text, n1 text, n2 text, n3 text, n4 text, n5 int, n6 int,n7 text,n8 int,n9 text,
    n10 int, n11 text, n12 text, n13 int, n14 text, n15 text, n16 text,n17 text,n18 text,n19 int,
    n20 text, n21 text, n22 text, n23 text, n24 text, n25 int, n26 text,n27 text,n28 text,n29 text,
    n30 text, n31 int, n32 text, n33 text, n34 text, n35 text, n36 text,n37 int,n38 text,n39 text,
    n40 text, n41 text, n42 text, n43 int, n44 text, n45 text, n46 text,n47 text,n48 text,n49 int,
    n50 text, n51 text, n52 text, n53 text, n54 text, n55 int, n56 text,n57 text,n58 text,n59 text,
    n60 text, n61 int, n62 text, n63 text, n64 text, n65 text, n66 text,n67 int,n68 text,n69 text,
    n70 text, n71 text, n72 text, n73 int, n74 text, n75 text, n76 text
);

\copy import from 'data.csv' delimiter ';';


SELECT count(*) FROM import;

DROP TABLE IF EXISTS candidat;
create table candidat(codecand int,nom text,prenom text,sexe text);
insert into candidat values(1,'JOLY','Eva','F');
insert into candidat values(2,'LE PEN','Marine','F');
insert into candidat values(3,'SARKOZY','Nicolas','M');
insert into candidat values(4,'MELANCHON','Jean-Luc','M');
insert into candidat values(5,'POUTOU','Philippe','M');
insert into candidat values(6,'ARTHAUD','Nathalie','F');
insert into candidat values(7,'CHEMINADE','Jacques','M');
insert into candidat values(8,'BAYROU','François','M');
insert into candidat values(9,'DUPONT-AIGNAN','Nicolas','M');
insert into candidat values(10,'HOLLANDE','François','M');

DROP TABLE IF EXISTS commune;
CREATE TABLE commune(codedep,codecom,libdep,libcom,inscrits,votants)
    as seLect distinct n1,n3,n2,n4,n5,n8 from import;
alter table commune add constraint pk_commune primary key(codedep,codecom);

DROP TABLE IF EXISTS vote;
create table vote (codedep,codecom,codecand,suffrages)
    as select n1,n3,1,n19 from import
    union all select n1,n3,2,n25 from import
    union all select n1,n3,3,n31 from import
    union all select n1,n3,4,n37 from import
    union all select n1,n3,5,n43 from import
    union all select n1,n3,6,n49 from import
    union all select n1,n3,7,n55 from import
    union all select n1,n3,8,n61 from import
    union all select n1,n3,9,n67 from import
    union all select n1,n3,10,n73 from import;

DROP TABLE IF EXISTS import;

/*
SELECT * FROM candidat;
SELECT * FROM commune;
SELECT * FROM vote;
*/


SELECT SUM(inscrits) AS TOTAL_INSCRITS FROM commune;
SELECT SUM(votants) AS TOTAL_VOTANTS FROM commune;
SELECT SUM(votants)*100.0/SUM(inscrits) AS TAUX_PARTICIPATION FROM commune;
SELECT libcom FROM commune GROUP BY libcom HAVING (SUM(votants)*100.0/SUM(inscrits)) <=ALL (SELECT SUM(votants)*100.0/SUM(inscrits) AS TAUX_PARTICIPATION_COMMUNE FROM commune GROUP BY libcom);
SELECT libcom, SUM(votants)*100.0/SUM(inscrits) FROM commune GROUP BY libcom HAVING (SUM(votants)*100.0/SUM(inscrits)) >=ALL (SELECT SUM(votants)*100.0/SUM(inscrits) AS TAUX_PARTICIPATION_COMMUNE FROM commune GROUP BY libcom);
SELECT SUM(suffrages) FROM vote WHERE codecand = 10;
SELECT v.codecand, nom, SUM(suffrages) AS suffrages FROM candidat AS c, vote AS v WHERE c.codecand = v.codecand GROUP BY v.codecand, c.nom ORDER BY suffrages DESC;
SELECT v.codecand, nom, SUM(suffrages) AS suffrages FROM candidat AS c, vote AS v WHERE c.codecand = v.codecand AND v.codedep = '59' GROUP BY v.codecand, c.nom ORDER BY suffrages DESC;
SELECT v.codecand, nom, SUM(suffrages) AS suffrages FROM candidat AS c, vote AS v WHERE c.codecand = v.codecand AND v.codedep = '59' AND v.codecom = '009' GROUP BY v.codecand, c.nom ORDER BY suffrages DESC;


