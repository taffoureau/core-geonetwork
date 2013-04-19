
INSERT INTO Categories VALUES (11,'z3950Servers');
INSERT INTO Categories VALUES (12,'registers');
INSERT INTO CategoriesDes VALUES (11,'fr','Serveurs Z3950');
INSERT INTO CategoriesDes VALUES (12,'fr','Annuaires');

INSERT INTO Settings VALUES (88,80,'defaultGroup', NULL);
INSERT INTO Settings VALUES (113,87,'group',NULL);
INSERT INTO Settings VALUES (178,173,'group',NULL);
INSERT INTO Settings VALUES (179,170,'defaultGroup', NULL);

UPDATE Settings SET value='2.7.2' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';