-- Create steering tables in MONITORING area.
CREATE TABLE loadids (
  ID           NUMBER(10) NOT NULL,
  FILENAME     VARCHAR2(2000)  NOT NULL);

ALTER TABLE loadids ADD (
  CONSTRAINT loadids_pk PRIMARY KEY (ID));

CREATE SEQUENCE loadids_sequence;

-- The subsequent commands can only be run after the sequence has created.
-- Run first the commands above this two comment lines, then the one below.

CREATE OR REPLACE TRIGGER loadids_on_insert
  BEFORE INSERT ON loadids
  FOR EACH ROW
BEGIN
  SELECT loadids_sequence.nextval
  INTO :new.id
  FROM dual;
END;

GRANT SELECT, INSERT, UPDATE ON MONITORING.LOADIDS TO STAGING;
GRANT SELECT, INSERT, UPDATE ON MONITORING.LOADIDS TO CLEANSING;
GRANT SELECT, INSERT, UPDATE ON MONITORING.LOADIDS TO CORE;

