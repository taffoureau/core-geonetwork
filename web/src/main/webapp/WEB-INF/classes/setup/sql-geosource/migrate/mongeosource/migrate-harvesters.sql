
CREATE OR REPLACE FUNCTION gn_migrate_harvester(parentIdentifier INT) RETURNS integer AS
$BODY$
DECLARE
  r int;
BEGIN
  FOR r IN SELECT id FROM SettingsBackup WHERE parentId = $1
  LOOP
    EXECUTE 'INSERT INTO harvestersettings (SELECT * FROM SettingsBackup WHERE id = ' || r || ')';
    PERFORM gn_migrate_harvester(r);
  END LOOP;
  RETURN 1;
END
$BODY$
LANGUAGE 'plpgsql';


TRUNCATE TABLE harvestersettings;
INSERT INTO HarvesterSettings VALUES  (2, NULL, 'harvesting', NULL);
SELECT * FROM gn_migrate_harvester(2);
INSERT INTO HarvesterSettings VALUES  (1, NULL, 'harvesting', NULL);
UPDATE HarvesterSettings SET parentId = 1 WHERE parentId = 2;
DELETE FROM HarvesterSettings WHERE id = 2;
-- SELECT * FROM harvestersettings;

