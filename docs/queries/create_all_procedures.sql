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
-- MONITORING
-- --------------------------------------------

-- Create PROCEDURE in the MONITORING area for logging.

CREATE or REPLACE PROCEDURE MONITORING.do_log(p_source_proc IN VARCHAR2, 
  p_severity IN VARCHAR2, 
  p_message IN VARCHAR2)
AS
   log_id NUMBER;
BEGIN
   INSERT INTO logging (id, time, source_proc, severity, message)
   VALUES 
    (logging_sequence.nextval, 
     sysdate,
     SUBSTR(p_source_proc,1,200), 
     SUBSTR(p_severity,1,20), 
     SUBSTR(p_message,1,2000));
   COMMIT;
exception
  when OTHERS then
    raise;
END;
/

GRANT EXECUTE ON MONITORING.do_log TO STAGING, CLEANSING, CORE;


-- --------------------------------------------
-- STAGING
-- --------------------------------------------

-- Create PROCEDURE in the STAGING area to load the content of a file into the tables.
CREATE or REPLACE PROCEDURE STAGING.load_quiz_file_to_stag (bucket_path IN VARCHAR2, file_name IN VARCHAR2)
IS
-- Populate QUESTION_ANSWERS_VERSIONS table with passed parameter filename.
  full_path VARCHAR2(2000) := bucket_path || file_name;

-- DECLARE
  l_TABLE_NAME        DBMS_QUOTED_ID := '"QUESTION_ANSWERS_VERSIONS"';
  l_CREDENTIAL_NAME   DBMS_QUOTED_ID := '"OBJ_STORE_CRED"';
  l_FILE_URI_LIST     CLOB := full_path;
  l_FIELD_LIST        CLOB :=
    q'[
     "LOADID"                        CHAR(32767)
    ,"SOURCESYSTEM"                  CHAR(4000)
    ,"AUTHORIZEDUSERS"               CHAR(4000)
    ,"QUESTIONID"                    CHAR
    ,"QUESTIONPARENT"                CHAR
    ,"QUESTIONNAME"                  CHAR(4000)
    ,"QUESTIONTEXT"                  CHAR(32767)
    ,"QUESTIONTEXTFORMAT"            CHAR
    ,"GENERALFEEDBACK"               CHAR(32767)
    ,"GENERALFEEDBACKFORMAT"         CHAR
    ,"DEFAULTMARK"                   CHAR
    ,"PENALTY"                       CHAR
    ,"QTYPE"                         CHAR(32767)
    ,"LENGTH"                        CHAR
    ,"QUESTIONSTAMP"                 CHAR(4000)
    ,"QNTIMECREATED"                 CHAR
    ,"QNTIMECREATEDSTRING"           CHAR(4000)
    ,"QNTIMEMODIFIED"                CHAR
    ,"QNTIMEMODIFIEDSTRING"          CHAR(4000)
    ,"QNCREATEDBY"                   CHAR
    ,"QNMODIFIEDBY"                  CHAR
    ,"QUESTIONANSWERSID"             CHAR(32767)
    ,"ANSWER"                        CHAR(32767)
    ,"ANSWERFORMAT"                  CHAR(32767)
    ,"FRACTION"                      CHAR(32767)
    ,"FEEDBACK"                      CHAR(32767)
    ,"FEEDBACKFORMAT"                CHAR(32767)
    ,"QUESTIONVERSIONID"             CHAR
    ,"QUESTIONBANKENTRYID"           CHAR
    ,"VERSION"                       CHAR
    ,"STATUS"                        CHAR(4000)
    ,"QUESTIONCATEGORYID"            CHAR
    ,"QUESTIONBANKENTRYIDNUMBER"     CHAR(32767)
    ,"OWNERID"                       CHAR
    ,"QUESTIONREFERENCESID"          CHAR(32767)
    ,"USINGCONTEXTID"                CHAR(32767)
    ,"COMPONENT"                     CHAR(32767)
    ,"QUESTIONAREA"                  CHAR(32767)
    ,"ITEMID"                        CHAR(32767)
    ,"QUESTIONREFERENCESVERSION"     CHAR(32767)
    ,"QUESTIONCATEGORIESID"          CHAR
    ,"QUESTIONCATEGORYNAME"          CHAR(4000)
    ,"QUESTIONCATEGORYCONTEXTID"     CHAR
    ,"INFO"                          CHAR(32767)
    ,"INFOFORMAT"                    CHAR
    ,"QUESTIONCATEGORYSTAMP"         CHAR(4000)
    ,"QUESTIONCATEGORYPARENT"        CHAR
    ,"SORTORDER"                     CHAR
    ,"QUESTIONCATEGORYIDNUMBER"      CHAR(32767)
    ,"SLOT"                          CHAR(32767)
    ,"EFFECTIVEWEIGHT"               CHAR(32767)
    ,"DISCRIMINATIONINDEX"           CHAR(32767)
    ,"DISCRIMINATIVEEFFICIENCY"      CHAR(32767)
    ,"SD"                            CHAR(32767)
    ,"FACILITY"                      CHAR(32767)
    ,"RANDOMGUESSSCORE"              CHAR(32767)
    ,"QBEUSERNAME"                   CHAR(4000)
    ,"CONTEXTID"                     CHAR(32767)
    ,"PATH"                          CHAR(32767)
    ,"QUESTIONATTEMPTSID"            CHAR
    ,"QATIMEMODIFIED"                CHAR
    ,"QATIMEMODIFIEDSTRING"          CHAR(4000)
    ,"QASTEPID"                      CHAR
    ,"QASTEPCREATED"                 CHAR
    ,"QASTEPCREATEDSTRING"           CHAR(4000)
    ,"QUESTIONATTEMPTSTEPDATANAME"   CHAR(4000)
    ,"QUESTIONATTEMPTSTEPDATAVALUE"  CHAR
    ,"QUIZATTEMPTSID"                CHAR
    ,"QUIZATTEMPTSUNIQUEID"          CHAR
    ,"QUIZID"                        CHAR
    ,"QUIZNAME"                      CHAR(4000)
    ,"QUIZGRADE"                     CHAR
    ,"FEEDBACKTEXT"                  CHAR(32767)
    ,"FEEDBACKTEXTFORMAT"            CHAR
    ,"FEEDBACKMINGRADE"              CHAR
    ,"FEEDBACKMAXGRADE"              CHAR
    ,"COURSEID"                      CHAR
    ,"COURSEMODULESID"               CHAR
    ,"MODULENAME"                    CHAR(4000)
    ,"QZATUSERID"                    CHAR(4000)
    ,"USERINFODATA"                  CHAR(4000)]';
  l_FORMAT            CLOB :=
    '{
       "type" : "CSV WITH EMBEDDED",
       "ignoremissingcolumns" : false,
       "ignoreblanklines" : true,
       "blankasnull" : false,
       "trimspaces" : "lrtrim",
       "characterset" : "AL32UTF8",
       "skipheaders" : 1,
       "logprefix" : "",
       "logretention" : 7,
       "rejectlimit" : 10000000,
       "recorddelimiter" : "X''0D0A''"
     }';
  l_OPERATION_ID      NUMBER ; /* OUT */
BEGIN

  MONITORING.do_log('STAGING.load_quiz_file_to_stag', 'INFO', 'procedure start');
  MONITORING.do_log('STAGING.load_quiz_file_to_stag', 'INFO', 'full_path: '||full_path);

dbms_output.put_line('Call the copy from file ' || file_name || ' to the STAGING area.');

  INSERT INTO MONITORING.LOADIDS VALUES (0,file_name);
  COMMIT;
  
  MONITORING.do_log('STAGING.load_quiz_file_to_stag', 'INFO', 'l_TABLE_NAME: '||l_TABLE_NAME);
  MONITORING.do_log('STAGING.load_quiz_file_to_stag', 'INFO', 'l_CREDENTIAL_NAME: '||l_CREDENTIAL_NAME);
  MONITORING.do_log('STAGING.load_quiz_file_to_stag', 'INFO', 'l_FILE_URI_LIST: '||l_FILE_URI_LIST);
  MONITORING.do_log('STAGING.load_quiz_file_to_stag', 'INFO', 'l_FIELD_LIST: '||l_FIELD_LIST);
  MONITORING.do_log('STAGING.load_quiz_file_to_stag', 'INFO', 'l_FORMAT: '||l_FORMAT);
  MONITORING.do_log('STAGING.load_quiz_file_to_stag', 'INFO', 'l_OPERATION_ID: '||l_OPERATION_ID);


  "C##CLOUD$SERVICE"."DBMS_CLOUD"."COPY_DATA"
  ( TABLE_NAME        => l_TABLE_NAME
   ,CREDENTIAL_NAME   => l_CREDENTIAL_NAME
   ,FILE_URI_LIST     => l_FILE_URI_LIST
   ,FIELD_LIST        => l_FIELD_LIST
   ,FORMAT            => l_FORMAT
   ,OPERATION_ID      => l_OPERATION_ID
  );

dbms_output.put_line('Copying the values from file ' || file_name || ' to the STAGING area done.');
  MONITORING.do_log('STAGING.load_quiz_file_to_stag', 'INFO', 'procedure end ');

END;
/

GRANT EXECUTE ON STAGING.LOAD_QUIZ_FILE_TO_STAG TO MONITORING;

-- --------------------------------------------
-- CLEANSING
-- --------------------------------------------

-- Create PROCEDURE in the CLEANSING area to load the content of the tables in STAGING area to the tables in CLEANSING area.

CREATE or REPLACE PROCEDURE CLEANSING.transfer_quiz_stag_to_clean (loadid IN NUMBER) IS

loadidid NUMBER;

BEGIN
dbms_output.put_line('Insert the values for load id ' || loadid || ' to the CLEANSING area.');

SELECT CAST(loadid AS NUMBER ) INTO loadidid from dual;

--Populate H_Question table

INSERT INTO H_Question
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, SOURCESYSTEM, QUESTIONID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Question t1 WHERE t1.question_id = t2.QUESTIONID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Item table

INSERT INTO H_Item
SELECT UNIQUE loadidid AS "LOADID", QUESTIONANSWERSID, SOURCESYSTEM, QUESTIONANSWERSID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
        WHERE QUESTIONANSWERSID IS NOT NULL -- There are questions that have no answers, like descriptions.
        AND NOT EXISTS (SELECT 1 FROM H_Item t1 WHERE t1.item_id = t2.QUESTIONANSWERSID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Quiz_Attempt table

INSERT INTO H_Quiz_Attempt
SELECT UNIQUE loadidid AS "LOADID", QUIZATTEMPTSID, SOURCESYSTEM, QZATUSERID, QUIZATTEMPTSID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz_Attempt t1 WHERE t1.quiz_attempt_id = t2.QUIZATTEMPTSID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Question_Attempt table

INSERT INTO H_Question_Attempt
    SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS 
    FROM CLEANSING.H_QUESTION_ATTEMPT t2
    WHERE NOT EXISTS (SELECT 1
                      FROM H_Question_Attempt t1
                      WHERE t1.question_attempt_id = t2.QUESTION_ATTEMPT_ID and t1.SOURCESYSTEM = t2.SOURCESYSTEM
                     );

--Populate H_Question_Attempt_Step table

INSERT INTO H_Question_Attempt_Step
SELECT UNIQUE loadidid AS "LOADID", QASTEPID, SOURCESYSTEM, QASTEPID, QASTEPCREATED, QASTEPCREATEDSTRING, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt_Step t1 WHERE t1.question_attempt_step_id = t2.QASTEPID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Quiz table

INSERT INTO H_Quiz
SELECT UNIQUE loadidid AS "LOADID", QUIZID, SOURCESYSTEM, QUIZID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz t1 WHERE t1.quiz_id = t2.QUIZID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Info table

INSERT INTO S_Question_Info
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, SOURCESYSTEM, QUESTIONNAME, QUESTIONTEXT, VERSION, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Info t1 WHERE t1.question_id = t2.QUESTIONID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Author table

INSERT INTO S_Question_Author
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, SOURCESYSTEM, QBEUSERNAME, VERSION, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Author t1 WHERE t1.question_id = t2.QUESTIONID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Statistics table

INSERT INTO S_Question_Statistics
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, SOURCESYSTEM, SLOT, EFFECTIVEWEIGHT, DISCRIMINATIONINDEX, DISCRIMINATIVEEFFICIENCY, SD, FACILITY, RANDOMGUESSSCORE, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Statistics t1 WHERE t1.question_id = t2.QUESTIONID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Attempt_Step_Data table

INSERT INTO S_Question_Attempt_Step_Data
SELECT UNIQUE loadidid AS "LOADID", QASTEPID, SOURCESYSTEM, QUESTIONATTEMPTSTEPDATANAME, QUESTIONATTEMPTSTEPDATAVALUE, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
        WHERE QUESTIONATTEMPTSTEPDATANAME IS NOT NULL AND QUESTIONATTEMPTSTEPDATAVALUE IS NOT NULL
        AND NOT EXISTS (SELECT 1 FROM S_Question_Attempt_Step_Data t1 WHERE t1.question_attempt_step_id = t2.QASTEPID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Question_Question_Att table

INSERT INTO L_Question_Question_Att
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, QUESTIONATTEMPTSID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
        WHERE QUESTIONANSWERSID IS NOT NULL -- There are questions that have no answers, like descriptions.
         AND NOT EXISTS (SELECT 1 FROM L_Question_Question_Att t1 WHERE t1.question_id = t2.QUESTIONID AND t1.question_attempt_id = t2.QUESTIONATTEMPTSID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Question_Item table

INSERT INTO L_Question_Item
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, QUESTIONANSWERSID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
        WHERE QUESTIONANSWERSID IS NOT NULL -- There are questions that have no answers, like descriptions.
         AND NOT EXISTS (SELECT 1 FROM L_Question_Item t1 WHERE t1.question_id = t2.QUESTIONID AND t1.item_id = t2.QUESTIONANSWERSID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Quiz_Att_Question_Att table
INSERT INTO L_Quiz_Att_Question_Att
SELECT UNIQUE loadidid AS "LOADID", QUIZATTEMPTSID, QUESTIONATTEMPTSID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM L_Quiz_Att_Question_Att t1 WHERE t1.quiz_attempt_id = t2.QUIZATTEMPTSID AND t1.question_attempt_id = t2.QUESTIONATTEMPTSID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Ques_Att_Ques_Att_Step table

INSERT INTO L_Ques_Att_Ques_Att_Step
SELECT UNIQUE loadidid AS "LOADID", QUESTIONATTEMPTSID, QASTEPID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM L_Ques_Att_Ques_Att_Step t1 WHERE t1.question_attempt_id = t2.QUESTIONATTEMPTSID AND t1.question_attempt_step_id = t2.QASTEPID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Question_Quiz table

INSERT INTO L_Question_Quiz
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, QUIZID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS t2
         WHERE NOT EXISTS (SELECT 1 FROM L_Question_Quiz t1 WHERE t1.question_id = t2.QUESTIONID AND t1.quiz_id = t2.QUIZID AND t1.sourcesystem = t2.SOURCESYSTEM);

COMMIT;

dbms_output.put_line('Done inserting the values for load id ' || loadid || ' from the STAGING area to the CLEANSING area.');

END;
/

GRANT EXECUTE ON CLEANSING.TRANSFER_QUIZ_STAG_TO_CLEAN TO MONITORING;

-- --------------------------------------------
-- CORE
-- --------------------------------------------

-- Create PROCEDURE in the CORE area to load the content of the tables in CLEANSING area to the tables in CORE area.

CREATE or REPLACE PROCEDURE CORE.transfer_quiz_clean_to_core IS

BEGIN
dbms_output.put_line('Transfer the values from the CLEANSING area to the CORE area.');

--Populate H_Question table

INSERT INTO H_Question
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CLEANSING.H_QUESTION t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Question t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Item table
INSERT INTO H_Item
SELECT UNIQUE LOAD_ID, ITEM_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CLEANSING.H_ITEM t2
        WHERE NOT EXISTS (SELECT 1 FROM H_Item t1 WHERE t1.item_id = t2.ITEM_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Quiz_Attempt table

INSERT INTO H_Quiz_Attempt
SELECT UNIQUE LOAD_ID, QUIZ_ATTEMPT_ID, SOURCESYSTEM, QUIZ_ATTEMPT_USER_HASH, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CLEANSING.H_QUIZ_ATTEMPT t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz_Attempt t1 WHERE t1.quiz_attempt_id = t2.QUIZ_ATTEMPT_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Question_Attempt table

INSERT INTO H_Question_Attempt
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CLEANSING.H_QUESTION_ATTEMPT t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt t1 WHERE t1.question_attempt_id = t2.QUESTION_ATTEMPT_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Question_Attempt_Step table

INSERT INTO H_Question_Attempt_Step
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_STEP_ID, SOURCESYSTEM, MOODLE_KEY, CREATEDUNIXTIME, CREATEDTIMESTAMP, AUTHORIZEDUSERS
         FROM CLEANSING.H_QUESTION_ATTEMPT_STEP t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt_Step t1 WHERE t1.question_attempt_step_id = t2.QUESTION_ATTEMPT_STEP_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Quiz table

INSERT INTO H_Quiz
SELECT UNIQUE LOAD_ID, QUIZ_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CLEANSING.H_QUIZ t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz t1 WHERE t1.quiz_id = t2.QUIZ_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Info table

INSERT INTO S_Question_Info
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, QUESTION_NAME, TO_CHAR(QUESTION_TEXT), VERSION_ID, AUTHORIZEDUSERS
         FROM CLEANSING.S_QUESTION_INFO t2
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Info t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Author table

INSERT INTO S_Question_Author
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, QUESTION_AUTHOR_HASH, VERSION_ID, AUTHORIZEDUSERS
         FROM CLEANSING.S_QUESTION_AUTHOR t2
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Author t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Statistics table

INSERT INTO S_Question_Statistics
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, SLOT, EFFECTIVEWEIGHT, DISCRIMINATIONINDEX, DISCRIMINATIVEEFFICIENCY, SD, FACILITY, RANDOMGUESSSCORE, AUTHORIZEDUSERS
         FROM CLEANSING.S_QUESTION_STATISTICS t2
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Statistics t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Attempt_Step_Data table

INSERT INTO S_Question_Attempt_Step_Data
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_STEP_ID, SOURCESYSTEM, NAME, TO_CHAR(VALUE), AUTHORIZEDUSERS
         FROM CLEANSING.S_QUESTION_ATTEMPT_STEP_DATA t2
        WHERE NOT EXISTS (SELECT 1 FROM S_Question_Attempt_Step_Data t1 WHERE t1.question_attempt_step_id = t2.QUESTION_ATTEMPT_STEP_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Question_Question_Att table

INSERT INTO L_Question_Question_Att
SELECT UNIQUE LOAD_ID, QUESTION_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CLEANSING.L_QUESTION_QUESTION_ATT t2
        WHERE NOT EXISTS (SELECT 1 FROM L_Question_Question_Att t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.question_attempt_id = t2.QUESTION_ATTEMPT_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Question_Item table

INSERT INTO L_Question_Item
SELECT UNIQUE LOAD_ID, QUESTION_ID, ITEM_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CLEANSING.L_QUESTION_ITEM t2
        WHERE ITEM_ID IS NOT NULL -- There are questions that have no answers, like descriptions.
         AND NOT EXISTS (SELECT 1 FROM L_Question_Item t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.item_id = t2.ITEM_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Quiz_Att_Question_Att table

INSERT INTO L_Quiz_Att_Question_Att
SELECT UNIQUE LOAD_ID, QUIZ_ATTEMPT_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CLEANSING.L_QUIZ_ATT_QUESTION_ATT t2
         WHERE NOT EXISTS (SELECT 1 FROM L_Quiz_Att_Question_Att t1 WHERE t1.quiz_attempt_id = t2.QUIZ_ATTEMPT_ID AND t1.question_attempt_id = t2.QUESTION_ATTEMPT_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Ques_Att_Ques_Att_Step table

INSERT INTO L_Ques_Att_Ques_Att_Step
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_ID, QUESTION_ATTEMPT_STEP_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CLEANSING.L_QUES_ATT_QUES_ATT_STEP t2
         WHERE NOT EXISTS (SELECT 1 FROM L_Ques_Att_Ques_Att_Step t1 WHERE t1.question_attempt_id = t2.QUESTION_ATTEMPT_ID AND t1.question_attempt_step_id = t2.QUESTION_ATTEMPT_STEP_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Question_Quiz table

INSERT INTO L_Question_Quiz
SELECT UNIQUE LOAD_ID, QUESTION_ID, QUIZ_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CLEANSING.L_QUESTION_QUIZ t2
         WHERE NOT EXISTS (SELECT 1 FROM L_Question_Quiz t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.quiz_id = t2.QUIZ_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

COMMIT;

dbms_output.put_line('Done transfering the values from the CLEANSING area to the CORE area.');

END;
/

GRANT EXECUTE ON CORE.TRANSFER_QUIZ_CLEAN_TO_CORE TO MONITORING;

-- --------------------------------------------
-- MART
-- --------------------------------------------

-- Create PROCEDURE in the MART area to load the content of the tables in CORE area to the tables in MART area.

CREATE or REPLACE PROCEDURE MART.transfer_quiz_core_to_mart IS

BEGIN
dbms_output.put_line('Transfer the values from the CORE area to the MART area.');

--Populate H_Question table

INSERT INTO H_Question
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_QUESTION t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Question t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Item table
INSERT INTO H_Item
SELECT UNIQUE LOAD_ID, ITEM_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_ITEM t2
        WHERE NOT EXISTS (SELECT 1 FROM H_Item t1 WHERE t1.item_id = t2.ITEM_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Quiz_Attempt table

INSERT INTO H_Quiz_Attempt
SELECT UNIQUE LOAD_ID, QUIZ_ATTEMPT_ID, SOURCESYSTEM, QUIZ_ATTEMPT_USER_HASH, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_QUIZ_ATTEMPT t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz_Attempt t1 WHERE t1.quiz_attempt_id = t2.QUIZ_ATTEMPT_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Question_Attempt table

INSERT INTO H_Question_Attempt
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_QUESTION_ATTEMPT t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt t1 WHERE t1.question_attempt_id = t2.QUESTION_ATTEMPT_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Question_Attempt_Step table

INSERT INTO H_Question_Attempt_Step
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_STEP_ID, SOURCESYSTEM, MOODLE_KEY, CREATEDUNIXTIME, CREATEDTIMESTAMP, AUTHORIZEDUSERS
         FROM CORE.H_QUESTION_ATTEMPT_STEP t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt_Step t1 WHERE t1.question_attempt_step_id = t2.QUESTION_ATTEMPT_STEP_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate H_Quiz table

INSERT INTO H_Quiz
SELECT UNIQUE LOAD_ID, QUIZ_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_QUIZ t2
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz t1 WHERE t1.quiz_id = t2.QUIZ_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Info table

INSERT INTO S_Question_Info
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, QUESTION_NAME, TO_CHAR(QUESTION_TEXT), VERSION_ID, AUTHORIZEDUSERS
         FROM CORE.S_QUESTION_INFO t2
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Info t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Author table

INSERT INTO S_Question_Author
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, QUESTION_AUTHOR_HASH, VERSION_ID, AUTHORIZEDUSERS
         FROM CORE.S_QUESTION_AUTHOR t2
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Author t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Statistics table

INSERT INTO S_Question_Statistics
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, SLOT, EFFECTIVEWEIGHT, DISCRIMINATIONINDEX, DISCRIMINATIVEEFFICIENCY, SD, FACILITY, RANDOMGUESSSCORE, AUTHORIZEDUSERS
         FROM CORE.S_QUESTION_STATISTICS t2
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Statistics t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate S_Question_Attempt_Step_Data table

INSERT INTO S_Question_Attempt_Step_Data
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_STEP_ID, SOURCESYSTEM, NAME, TO_CHAR(VALUE), AUTHORIZEDUSERS
         FROM CORE.S_QUESTION_ATTEMPT_STEP_DATA t2
        WHERE NOT EXISTS (SELECT 1 FROM S_Question_Attempt_Step_Data t1 WHERE t1.question_attempt_step_id = t2.QUESTION_ATTEMPT_STEP_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Question_Question_Att table

INSERT INTO L_Question_Question_Att
SELECT UNIQUE LOAD_ID, QUESTION_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUESTION_QUESTION_ATT t2
        WHERE NOT EXISTS (SELECT 1 FROM L_Question_Question_Att t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.question_attempt_id = t2.QUESTION_ATTEMPT_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Question_Item table

INSERT INTO L_Question_Item
SELECT UNIQUE LOAD_ID, QUESTION_ID, ITEM_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUESTION_ITEM t2
        WHERE ITEM_ID IS NOT NULL -- There are questions that have no answers, like descriptions.
         AND NOT EXISTS (SELECT 1 FROM L_Question_Item t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.item_id = t2.ITEM_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Quiz_Att_Question_Att table

INSERT INTO L_Quiz_Att_Question_Att
SELECT UNIQUE LOAD_ID, QUIZ_ATTEMPT_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUIZ_ATT_QUESTION_ATT t2
         WHERE NOT EXISTS (SELECT 1 FROM L_Quiz_Att_Question_Att t1 WHERE t1.quiz_attempt_id = t2.QUIZ_ATTEMPT_ID AND t1.question_attempt_id = t2.QUESTION_ATTEMPT_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

--Populate L_Ques_Att_Ques_Att_Step table

INSERT INTO L_Ques_Att_Ques_Att_Step
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_ID, QUESTION_ATTEMPT_STEP_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUES_ATT_QUES_ATT_STEP t2
         WHERE NOT EXISTS (SELECT 1 FROM L_Ques_Att_Ques_Att_Step t1 WHERE t1.question_attempt_id = t2.QUESTION_ATTEMPT_ID AND t1.question_attempt_step_id = t2.QUESTION_ATTEMPT_STEP_ID AND t1.sourcesystem = 
t2.SOURCESYSTEM);

--Populate L_Question_Quiz table

INSERT INTO L_Question_Quiz
SELECT UNIQUE LOAD_ID, QUESTION_ID, QUIZ_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUESTION_QUIZ t2
         WHERE NOT EXISTS (SELECT 1 FROM L_Question_Quiz t1 WHERE t1.question_id = t2.QUESTION_ID AND t1.quiz_id = t2.QUIZ_ID AND t1.sourcesystem = t2.SOURCESYSTEM);

COMMIT;

dbms_output.put_line('Done transfering the values from the CORE area to the MART area.');

END;
/

GRANT EXECUTE ON MART.TRANSFER_QUIZ_CORE_TO_MART TO MONITORING;

-- --------------------------------------------
-- MONITORING
-- --------------------------------------------

-- Create FUNCTION in the MONITORING area to be able to look up load ids for given file names.

CREATE or REPLACE FUNCTION MONITORING.lookup_loadid(file_name IN VARCHAR2)
RETURN NUMBER
IS
   loadid NUMBER;
BEGIN
   SELECT max(id) INTO loadid FROM MONITORING."LOADIDS" WHERE filename=file_name;
   dbms_output.put_line('Load id for file ' || file_name || ' is ' || loadid || '.');
   return(loadid);
exception
  when NO_DATA_FOUND then
    return(0);
END;
/

-- This procedure is to be created in schema MONITORING. 
CREATE or REPLACE PROCEDURE MONITORING.load_quiz_file (bucket_path IN VARCHAR2, file_name IN VARCHAR2)
AS

   loadid number;

   BEGIN

   MONITORING.do_log('MONITORING.load_quiz_file', 'INFO', 'procedure start ');

   /* CALL PROCEDURE LOAD_QUIZ_FILE_TO_CLEAN IN STAGING */
   staging.load_quiz_file_to_stag(bucket_path, file_name);

   /* LOOK UP THE LOAD ID */
   loadid := lookup_loadid(file_name);

   /* CALL PROCEDURE TRANSFER_QUIZ_STAG_TO_CLEAN IN CLEANSING, PASSING THE LOAD ID */
   cleansing.transfer_quiz_stag_to_clean(loadid);

   /* CALL PROCEDURE TRANSFER_QUIZ_CLEAN_TO_CORE IN CORE */
   core.transfer_quiz_clean_to_core;

   /* CALL PROCEDURE TRANSFER_QUIZ_CORE_TO_MART IN MART */
   mart.transfer_quiz_core_to_mart;

   MONITORING.do_log('MONITORING.load_quiz_file', 'INFO', 'procedure end ');

   END;
/

