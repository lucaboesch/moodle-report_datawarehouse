/* 
 * 2023 Luca Bösch luca.boesch@bfh.ch
 * 
 * This program is free software: you can redistribute it and/or modify it under the terms of the GNU General
 * Public License as published by the Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
 * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program. If not, see
 * https://www.gnu.org/licenses/.
 */

-- --------------------------------------------
-- STAGING
-- --------------------------------------------

-- DROP TABLE STAGING.ASSIGNMENT_SUBMISSIONS;
-- DROP TABLE STAGING.QUESTION_ANSWERS_VERSIONS;

CREATE TABLE STAGING.ASSIGNMENT_SUBMISSIONS 
(
  LOADID VARCHAR2(32672 BYTE) 
, SOURCESYSTEM VARCHAR2(32672 BYTE) 
, AUTHORIZEDUSERS VARCHAR2(32672 BYTE) 
, ASSIGNID VARCHAR2(32672 BYTE) 
, ASSIGNNAME VARCHAR2(32672 BYTE) 
, ASSIGNMAXGRADE VARCHAR2(32672 BYTE) 
, USERHASH VARCHAR2(32672 BYTE) 
, ASSIGNGRADEID VARCHAR2(32672 BYTE) 
, ASSIGNGRADE VARCHAR2(32672 BYTE) 
, ATTEMPTNUMBER VARCHAR2(32672 BYTE) 
, LATEST VARCHAR2(32672 BYTE) 
, SUBMISSION VARCHAR2(32672 BYTE) 
, ONLINETEXT VARCHAR2(32672 BYTE) 
, USERINFODATA VARCHAR2(32672 BYTE) 
);


CREATE TABLE STAGING.QUESTION_ANSWERS_VERSIONS 
(
  LOADID VARCHAR2(32672 BYTE) 
, SOURCESYSTEM VARCHAR2(32672 BYTE) 
, AUTHORIZEDUSERS VARCHAR2(32672 BYTE) 
, QUESTIONID VARCHAR2(32672 BYTE) 
, QUESTIONPARENT VARCHAR2(32672 BYTE) 
, QUESTIONNAME VARCHAR2(32672 BYTE) 
, QUESTIONTEXT VARCHAR2(32672 BYTE) 
, QUESTIONTEXTFORMAT VARCHAR2(32672 BYTE) 
, GENERALFEEDBACK VARCHAR2(32672 BYTE) 
, GENERALFEEDBACKFORMAT VARCHAR2(32672 BYTE) 
, DEFAULTMARK VARCHAR2(32672 BYTE) 
, PENALTY VARCHAR2(32672 BYTE) 
, QTYPE VARCHAR2(32672 BYTE) 
, LENGTH VARCHAR2(32672 BYTE) 
, QUESTIONSTAMP VARCHAR2(32672 BYTE) 
, QNTIMECREATED VARCHAR2(32672 BYTE) 
, QNTIMECREATEDSTRING VARCHAR2(32672 BYTE) 
, QNTIMEMODIFIED VARCHAR2(32672 BYTE) 
, QNTIMEMODIFIEDSTRING VARCHAR2(32672 BYTE) 
, QNCREATEDBY VARCHAR2(32672 BYTE) 
, QNMODIFIEDBY VARCHAR2(32672 BYTE) 
, QUESTIONANSWERSID VARCHAR2(32672 BYTE) 
, ANSWER VARCHAR2(32672 BYTE) 
, ANSWERFORMAT VARCHAR2(32672 BYTE) 
, FRACTION VARCHAR2(32672 BYTE) 
, FEEDBACK VARCHAR2(32672 BYTE) 
, FEEDBACKFORMAT VARCHAR2(32672 BYTE) 
, QUESTIONVERSIONID VARCHAR2(32672 BYTE) 
, QUESTIONBANKENTRYID VARCHAR2(32672 BYTE) 
, VERSION VARCHAR2(32672 BYTE) 
, STATUS VARCHAR2(32672 BYTE) 
, QUESTIONCATEGORYID VARCHAR2(32672 BYTE) 
, QUESTIONBANKENTRYIDNUMBER VARCHAR2(32672 BYTE) 
, OWNERID VARCHAR2(32672 BYTE) 
, QUESTIONREFERENCESID VARCHAR2(32672 BYTE) 
, USINGCONTEXTID VARCHAR2(32672 BYTE) 
, COMPONENT VARCHAR2(32672 BYTE) 
, QUESTIONAREA VARCHAR2(32672 BYTE) 
, ITEMID VARCHAR2(32672 BYTE) 
, QUESTIONREFERENCESVERSION VARCHAR2(32672 BYTE) 
, QUESTIONCATEGORIESID VARCHAR2(32672 BYTE) 
, QUESTIONCATEGORYNAME VARCHAR2(32672 BYTE) 
, QUESTIONCATEGORYCONTEXTID VARCHAR2(32672 BYTE) 
, INFO VARCHAR2(32672 BYTE) 
, INFOFORMAT VARCHAR2(32672 BYTE) 
, QUESTIONCATEGORYSTAMP VARCHAR2(32672 BYTE) 
, QUESTIONCATEGORYPARENT VARCHAR2(32672 BYTE) 
, SORTORDER VARCHAR2(32672 BYTE) 
, QUESTIONCATEGORYIDNUMBER VARCHAR2(32672 BYTE) 
, SLOT VARCHAR2(32672 BYTE) 
, EFFECTIVEWEIGHT VARCHAR2(32672 BYTE) 
, DISCRIMINATIONINDEX VARCHAR2(32672 BYTE) 
, DISCRIMINATIVEEFFICIENCY VARCHAR2(32672 BYTE) 
, SD VARCHAR2(32672 BYTE) 
, FACILITY VARCHAR2(32672 BYTE) 
, RANDOMGUESSSCORE VARCHAR2(32672 BYTE) 
, QBEUSERNAME VARCHAR2(32672 BYTE) 
, CONTEXTID VARCHAR2(32672 BYTE) 
, PATH VARCHAR2(32672 BYTE) 
, QUESTIONATTEMPTSID VARCHAR2(32672 BYTE) 
, QATIMEMODIFIED VARCHAR2(32672 BYTE) 
, QATIMEMODIFIEDSTRING VARCHAR2(32672 BYTE) 
, QASTEPID VARCHAR2(32672 BYTE) 
, QASTEPCREATED VARCHAR2(32672 BYTE) 
, QASTEPCREATEDSTRING VARCHAR2(32672 BYTE) 
, QUESTIONATTEMPTSTEPDATANAME VARCHAR2(32672 BYTE) 
, QUESTIONATTEMPTSTEPDATAVALUE VARCHAR2(32672 BYTE) 
, QUIZATTEMPTSID VARCHAR2(32672 BYTE) 
, QUIZATTEMPTSUNIQUEID VARCHAR2(32672 BYTE) 
, QUIZID VARCHAR2(32672 BYTE) 
, QUIZNAME VARCHAR2(32672 BYTE) 
, QUIZGRADE VARCHAR2(32672 BYTE) 
, FEEDBACKTEXT VARCHAR2(32672 BYTE) 
, FEEDBACKTEXTFORMAT VARCHAR2(32672 BYTE) 
, FEEDBACKMINGRADE VARCHAR2(32672 BYTE) 
, FEEDBACKMAXGRADE VARCHAR2(32672 BYTE) 
, COURSEID VARCHAR2(32672 BYTE) 
, COURSEMODULESID VARCHAR2(32672 BYTE) 
, MODULENAME VARCHAR2(32672 BYTE) 
, QZATUSERID VARCHAR2(32672 BYTE) 
, USERINFODATA VARCHAR2(32672 BYTE) 
) ;

GRANT SELECT ON STAGING.QUESTION_ANSWERS_VERSIONS TO CLEANSING;
GRANT SELECT ON STAGING.ASSIGNMENT_SUBMISSIONS TO CLEANSING;

-- --------------------------------------------
-- CLEANSING
-- --------------------------------------------

-- DROP TABLE CLEANSING.H_QUESTION_ATTEMPT_STEP;
-- DROP TABLE CLEANSING.H_QUIZ;
-- DROP TABLE CLEANSING.S_QUESTION_INFO;
-- DROP TABLE CLEANSING.S_QUESTION_AUTHOR;
-- DROP TABLE CLEANSING.S_QUESTION_STATISTICS;
-- DROP TABLE CLEANSING.S_QUESTION_ATTEMPT_STEP_DATA;
-- DROP TABLE CLEANSING.L_QUESTION_QUESTION_ATT;
-- DROP TABLE CLEANSING.L_QUESTION_ITEM;
-- DROP TABLE CLEANSING.L_QUIZ_ATT_QUESTION_ATT;
-- DROP TABLE CLEANSING.L_QUES_ATT_QUES_ATT_STEP;
-- DROP TABLE CLEANSING.L_QUESTION_QUIZ;
-- DROP TABLE CLEANSING.H_ASSIGNMENT;
-- DROP TABLE CLEANSING.H_ASSIGN_SUBMISSION;
-- DROP TABLE CLEANSING.H_ASSIGN_GRADE;
-- DROP TABLE CLEANSING.L_ASSIGNMENT_ASSIGN_SUBM;
-- DROP TABLE CLEANSING.S_ASSIGNMENT_INFO;
-- DROP TABLE CLEANSING.H_QUESTION;
-- DROP TABLE CLEANSING.H_ITEM;

-- Create quiz related tables in CLEANSING area
CREATE TABLE CLEANSING.H_Question (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.H_Item (load_id NUMBER NOT NULL, item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.H_Quiz_Attempt (load_id NUMBER NOT NULL, quiz_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, quiz_attempt_user_hash VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.H_Question_Attempt (load_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.H_Question_Attempt_Step (load_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, createdunixtime NUMBER, createdtimestamp VARCHAR2(20), authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.H_Quiz (load_id NUMBER NOT NULL, quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE CLEANSING.S_Question_Info (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_name VARCHAR2(255) NOT NULL, question_text CLOB NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.S_Question_Author (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_author_hash VARCHAR2(255) NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.S_Question_Statistics (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, slot NUMBER, effectiveweight FLOAT, discriminationindex FLOAT, discriminativeefficiency FLOAT, sd FLOAT, facility FLOAT, randomguessscore FLOAT, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.S_Question_Attempt_Step_Data (load_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), name VARCHAR2(32) NOT NULL, value CLOB NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE CLEANSING.L_Question_Question_Att (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.L_Question_Item (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.L_Quiz_Att_Question_Att (load_id NUMBER NOT NULL, quiz_attempt_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.L_Ques_Att_Ques_Att_Step (load_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.L_Question_Quiz (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));

-- Create assignment related tables in CLEANSING area
CREATE TABLE CLEANSING.H_Assignment (load_id NUMBER NOT NULL, assign_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.H_Assign_Submission (load_id NUMBER NOT NULL, assign_submission_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, assign_submission_user_hash VARCHAR2(255) NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CLEANSING.H_Assign_Grade (load_id NUMBER NOT NULL, assign_grade_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, assign_grade VARCHAR2(255) NOT NULL, assign_submission_user_hash VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE CLEANSING.L_Assignment_Assign_Subm (load_id NUMBER NOT NULL, assign_id NUMBER NOT NULL, assign_submission_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE CLEANSING.S_Assignment_Info (load_id NUMBER NOT NULL, assign_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), assign_name VARCHAR2(255), assign_intro VARCHAR2(32672 BYTE), assign_activity VARCHAR2(32672 BYTE), authorizedusers VARCHAR2(32672 BYTE));

--Allow rights to the CORE user to the table in CLEANSING.
GRANT SELECT ON CLEANSING.H_QUESTION TO CORE;
GRANT SELECT ON CLEANSING.H_ITEM TO CORE;
GRANT SELECT ON CLEANSING.H_QUIZ_ATTEMPT TO CORE;
GRANT SELECT ON CLEANSING.H_QUESTION_ATTEMPT TO CORE;
GRANT SELECT ON CLEANSING.H_QUESTION_ATTEMPT_STEP TO CORE;
GRANT SELECT ON CLEANSING.H_QUIZ TO CORE;
GRANT SELECT ON CLEANSING.S_QUESTION_INFO TO CORE;
GRANT SELECT ON CLEANSING.S_QUESTION_AUTHOR TO CORE;
GRANT SELECT ON CLEANSING.S_QUESTION_STATISTICS TO CORE;
GRANT SELECT ON CLEANSING.S_QUESTION_ATTEMPT_STEP_DATA TO CORE;
GRANT SELECT ON CLEANSING.L_QUESTION_QUESTION_ATT TO CORE;
GRANT SELECT ON CLEANSING.L_QUESTION_ITEM TO CORE;
GRANT SELECT ON CLEANSING.L_QUIZ_ATT_QUESTION_ATT TO CORE;
GRANT SELECT ON CLEANSING.L_QUES_ATT_QUES_ATT_STEP TO CORE;
GRANT SELECT ON CLEANSING.L_QUESTION_QUIZ TO CORE;

-- --------------------------------------------
-- CORE
-- --------------------------------------------

-- DROP TABLE CORE.H_QUESTION;
-- DROP TABLE CORE.H_ITEM;
-- DROP TABLE CORE.H_QUIZ_ATTEMPT;
-- DROP TABLE CORE.H_QUESTION_ATTEMPT;
-- DROP TABLE CORE.H_QUESTION_ATTEMPT_STEP;
-- DROP TABLE CORE.H_QUIZ;
-- DROP TABLE CORE.S_QUESTION_INFO;
-- DROP TABLE CORE.S_QUESTION_AUTHOR;
-- DROP TABLE CORE.S_QUESTION_STATISTICS;
-- DROP TABLE CORE.S_QUESTION_ATTEMPT_STEP_DATA;
-- DROP TABLE CORE.L_QUESTION_QUESTION_ATT;
-- DROP TABLE CORE.L_QUESTION_ITEM;
-- DROP TABLE CORE.L_QUIZ_ATT_QUESTION_ATT;
-- DROP TABLE CORE.L_QUES_ATT_QUES_ATT_STEP;
-- DROP TABLE CORE.L_QUESTION_QUIZ;

-- Create quiz related tables in CORE area
CREATE TABLE CORE.H_Question (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.H_Item (load_id NUMBER NOT NULL, item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.H_Quiz_Attempt (load_id NUMBER NOT NULL, quiz_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, quiz_attempt_user_hash VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.H_Question_Attempt (load_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.H_Question_Attempt_Step (load_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, createdunixtime NUMBER, createdtimestamp VARCHAR2(20), authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.H_Quiz (load_id NUMBER NOT NULL, quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE CORE.S_Question_Info (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_name VARCHAR2(255) NOT NULL, question_text CLOB NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.S_Question_Author (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_author_hash VARCHAR2(255) NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.S_Question_Statistics (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, slot NUMBER, effectiveweight FLOAT, discriminationindex FLOAT, discriminativeefficiency FLOAT, sd FLOAT, facility FLOAT, randomguessscore FLOAT, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.S_Question_Attempt_Step_Data (load_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), name VARCHAR2(32) NOT NULL, value CLOB NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE CORE.L_Question_Question_Att (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.L_Question_Item (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.L_Quiz_Att_Question_Att (load_id NUMBER NOT NULL, quiz_attempt_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.L_Ques_Att_Ques_Att_Step (load_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE CORE.L_Question_Quiz (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));

-- Create assignment related tables in CORE area

--Allow rights to the MART user to the table in CORE.
GRANT SELECT ON CORE.H_QUESTION TO MART;
GRANT SELECT ON CORE.H_ITEM TO MART;
GRANT SELECT ON CORE.H_QUIZ_ATTEMPT TO MART;
GRANT SELECT ON CORE.H_QUESTION_ATTEMPT TO MART;
GRANT SELECT ON CORE.H_QUESTION_ATTEMPT_STEP TO MART;
GRANT SELECT ON CORE.H_QUIZ TO MART;
GRANT SELECT ON CORE.S_QUESTION_INFO TO MART;
GRANT SELECT ON CORE.S_QUESTION_AUTHOR TO MART;
GRANT SELECT ON CORE.S_QUESTION_STATISTICS TO MART;
GRANT SELECT ON CORE.S_QUESTION_ATTEMPT_STEP_DATA TO MART;
GRANT SELECT ON CORE.L_QUESTION_QUESTION_ATT TO MART;
GRANT SELECT ON CORE.L_QUESTION_ITEM TO MART;
GRANT SELECT ON CORE.L_QUIZ_ATT_QUESTION_ATT TO MART;
GRANT SELECT ON CORE.L_QUES_ATT_QUES_ATT_STEP TO MART;
GRANT SELECT ON CORE.L_QUESTION_QUIZ TO MART;

-- --------------------------------------------
-- MART
-- --------------------------------------------

-- DROP TABLE MART.H_QUESTION;
-- DROP TABLE MART.H_ITEM;
-- DROP TABLE MART.H_QUIZ_ATTEMPT;
-- DROP TABLE MART.H_QUESTION_ATTEMPT;
-- DROP TABLE MART.H_QUESTION_ATTEMPT_STEP;
-- DROP TABLE MART.H_QUIZ;
-- DROP TABLE MART.S_QUESTION_INFO;
-- DROP TABLE MART.S_QUESTION_AUTHOR;
-- DROP TABLE MART.S_QUESTION_STATISTICS;
-- DROP TABLE MART.S_QUESTION_ATTEMPT_STEP_DATA;
-- DROP TABLE MART.L_QUESTION_QUESTION_ATT;
-- DROP TABLE MART.L_QUESTION_ITEM;
-- DROP TABLE MART.L_QUIZ_ATT_QUESTION_ATT;
-- DROP TABLE MART.L_QUES_ATT_QUES_ATT_STEP;
-- DROP TABLE MART.L_QUESTION_QUIZ;

-- Create quiz related tables in MART area
CREATE TABLE MART.H_Question (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.H_Item (load_id NUMBER NOT NULL, item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.H_Quiz_Attempt (load_id NUMBER NOT NULL, quiz_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, quiz_attempt_user_hash VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.H_Question_Attempt (load_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.H_Question_Attempt_Step (load_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, createdunixtime NUMBER, createdtimestamp VARCHAR2(20), authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.H_Quiz (load_id NUMBER NOT NULL, quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE MART.S_Question_Info (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_name VARCHAR2(255) NOT NULL, question_text CLOB NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.S_Question_Author (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_author_hash VARCHAR2(255) NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.S_Question_Statistics (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, slot NUMBER, effectiveweight FLOAT, discriminationindex FLOAT, discriminativeefficiency FLOAT, sd FLOAT, facility FLOAT, randomguessscore FLOAT, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.S_Question_Attempt_Step_Data (load_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), name VARCHAR2(32) NOT NULL, value CLOB NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE MART.L_Question_Question_Att (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.L_Question_Item (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.L_Quiz_Att_Question_Att (load_id NUMBER NOT NULL, quiz_attempt_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.L_Ques_Att_Ques_Att_Step (load_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE MART.L_Question_Quiz (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));

-- --------------------------------------------
-- MONITORING
-- --------------------------------------------

-- DROP TABLE MONITORING.LOADIDS;
-- DROP SEQUENCE MONITORING.loadids_sequence;
-- DROP TABLE MONITORING.logging;
-- DROP SEQUENCE MONITORING.logging_sequence;

-- Create steering tables in MONITORING area.
CREATE TABLE MONITORING.loadids (
  ID           NUMBER(10) NOT NULL,
  FILENAME     VARCHAR2(2000)  NOT NULL);

ALTER TABLE MONITORING.loadids ADD (
  CONSTRAINT loadids_pk PRIMARY KEY (ID));

CREATE SEQUENCE MONITORING.loadids_sequence;

-- The subsequent commands can only be run after the sequence has created.
-- Run first the commands above this two comment lines, then the one below.

CREATE OR REPLACE TRIGGER MONITORING.loadids_on_insert
  BEFORE INSERT ON MONITORING.loadids
  FOR EACH ROW
BEGIN
  SELECT MONITORING.loadids_sequence.nextval
  INTO :new.id
  FROM dual;
END;
/

-- Create logging tables in MONITORING area. Only used by the procedure DO_LOG
CREATE TABLE MONITORING.logging (
  ID           NUMBER(10) NOT NULL,
  time         DATE,
  source_proc  VARCHAR2(200),
  severity     VARCHAR2(20),
  message      VARCHAR2(2000)  NOT NULL);

ALTER TABLE MONITORING.logging ADD (
  CONSTRAINT logging_pk PRIMARY KEY (ID));
  
CREATE SEQUENCE MONITORING.logging_sequence;

CREATE OR REPLACE TRIGGER MONITORING.logging_on_insert
  BEFORE INSERT ON MONITORING.logging
  FOR EACH ROW
BEGIN
  SELECT MONITORING.logging_sequence.nextval
  INTO :new.id
  FROM dual;
END;
/

GRANT SELECT, INSERT, UPDATE ON MONITORING.LOADIDS TO STAGING;
GRANT SELECT, INSERT, UPDATE ON MONITORING.LOADIDS TO CLEANSING;
GRANT SELECT, INSERT, UPDATE ON MONITORING.LOADIDS TO CORE;


