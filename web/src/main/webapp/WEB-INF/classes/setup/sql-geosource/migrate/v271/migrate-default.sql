CREATE TABLE Thesaurus
  (
    id   varchar(250),
    activated    varchar(1),
    primary key(id)
  );


INSERT INTO Settings VALUES (23,20,'protocol','http');

INSERT INTO Settings VALUES (910,1,'metadata',NULL);
INSERT INTO Settings VALUES (911,910,'enableSimpleView','true');
INSERT INTO Settings VALUES (912,910,'enableIsoView','true');
INSERT INTO Settings VALUES (913,910,'enableInspireView','false');
INSERT INTO Settings VALUES (914,910,'enableXmlView','true');
INSERT INTO Settings VALUES (915,910,'defaultView','simple');

INSERT INTO Settings VALUES (722,720,'enableSearchPanel','false');

INSERT INTO Settings VALUES (920,1,'threadedindexing',NULL);
INSERT INTO Settings VALUES (921,920,'maxthreads','1');

  
UPDATE Settings SET value='2.7.1' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';