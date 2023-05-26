
--Allow rights to the CLEANSING user to the table in STAGING. But do this as user STAGING in the STAGING scheme.
GRANT SELECT ON STAGING.QUESTION_ANSWERS_VERSIONS TO CLEANSING;

--Delete all tables.
DROP TABLE H_Question;
DROP TABLE H_Item;
DROP TABLE H_Quiz_Attempt;
DROP TABLE H_Question_Attempt;
DROP TABLE H_Question_Attempt_Step;
DROP TABLE H_Quiz;
DROP TABLE S_Question_Info;
DROP TABLE S_Question_Author;
DROP TABLE S_Question_Statistics;
DROP TABLE S_Question_Attempt_Step_Data;
DROP TABLE L_Question_Question_Att;
DROP TABLE L_Question_Item;
DROP TABLE L_Quiz_Att_Question_Att;
DROP TABLE L_Ques_Att_Ques_Att_Step;
DROP TABLE L_Question_Quiz;

--Generate CLEANSING tables
CREATE TABLE H_Question (question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Item (item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Quiz_Attempt (quiz_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, quiz_attempt_user_hash VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Question_Attempt (question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Question_Attempt_Step (question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, createdunixtime NUMBER, createdtimestamp VARCHAR2(20), authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Quiz (quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE S_Question_Info (question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_name VARCHAR2(255) NOT NULL, question_text CLOB NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE S_Question_Author (question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_author_hash VARCHAR2(255) NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE S_Question_Statistics (question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, slot NUMBER, effectiveweight FLOAT, discriminationindex FLOAT, discriminativeefficiency FLOAT, sd FLOAT, facility FLOAT, randomguessscore FLOAT, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE S_Question_Attempt_Step_Data (question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), name VARCHAR2(32) NOT NULL, value CLOB NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE L_Question_Question_Att (question_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE L_Question_Item (question_id NUMBER NOT NULL, item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE L_Quiz_Att_Question_Att (quiz_attempt_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE L_Ques_Att_Ques_Att_Step (question_attempt_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE L_Question_Quiz (question_id NUMBER NOT NULL, quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));

--Populate H_Question table

INSERT INTO H_Question
SELECT UNIQUE QUESTIONID, SOURCESYSTEM, QUESTIONID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Question WHERE question_id = QUESTIONID AND sourcesystem = SOURCESYSTEM);

--Populate H_Item table

INSERT INTO H_Item
SELECT UNIQUE QUESTIONANSWERSID, SOURCESYSTEM, QUESTIONANSWERSID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
        WHERE QUESTIONANSWERSID IS NOT NULL -- There are questions that have no answers, like descriptions.
        AND NOT EXISTS (SELECT 1 FROM H_Item WHERE item_id = QUESTIONANSWERSID AND sourcesystem = SOURCESYSTEM);

--Populate H_Quiz_Attempt table

INSERT INTO H_Quiz_Attempt
SELECT UNIQUE QUIZATTEMPTSID, SOURCESYSTEM, QZATUSERID, QUIZATTEMPTSID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz_Attempt WHERE quiz_attempt_id = QUIZATTEMPTSID AND sourcesystem = SOURCESYSTEM);

--Populate H_Question_Attempt table

INSERT INTO H_Question_Attempt
SELECT UNIQUE QUESTIONATTEMPTSID, SOURCESYSTEM, QUESTIONATTEMPTSID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt WHERE question_attempt_id = QUESTIONATTEMPTSID AND sourcesystem = SOURCESYSTEM);

--Populate H_Question_Attempt_Step table

INSERT INTO H_Question_Attempt_Step
SELECT UNIQUE QASTEPID, SOURCESYSTEM, QASTEPID, QASTEPCREATED, QASTEPCREATEDSTRING, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt_Step WHERE question_attempt_step_id = QASTEPID AND sourcesystem = SOURCESYSTEM);

--Populate H_Quiz table

INSERT INTO H_Quiz
SELECT UNIQUE QUIZID, SOURCESYSTEM, QUIZID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz WHERE quiz_id = QUIZID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Info table

INSERT INTO S_Question_Info
SELECT UNIQUE QUESTIONID, SOURCESYSTEM, QUESTIONNAME, QUESTIONTEXT, VERSION, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Info WHERE question_id = QUESTIONID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Author table

INSERT INTO S_Question_Author
SELECT UNIQUE QUESTIONID, SOURCESYSTEM, QBEUSERNAME, VERSION, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Author WHERE question_id = QUESTIONID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Statistics table

INSERT INTO S_Question_Statistics
SELECT UNIQUE QUESTIONID, SOURCESYSTEM, SLOT, EFFECTIVEWEIGHT, DISCRIMINATIONINDEX, DISCRIMINATIVEEFFICIENCY, SD, FACILITY, RANDOMGUESSSCORE, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Statistics WHERE question_id = QUESTIONID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Attempt_Step_Data table

INSERT INTO S_Question_Attempt_Step_Data
SELECT UNIQUE QASTEPID, SOURCESYSTEM, QUESTIONATTEMPTSTEPDATANAME, QUESTIONATTEMPTSTEPDATAVALUE, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
        WHERE QUESTIONATTEMPTSTEPDATANAME IS NOT NULL AND QUESTIONATTEMPTSTEPDATAVALUE IS NOT NULL
        AND NOT EXISTS (SELECT 1 FROM S_Question_Attempt_Step_Data WHERE question_attempt_step_id = QASTEPID AND sourcesystem = SOURCESYSTEM);

--Populate L_Question_Question_Att table

INSERT INTO L_Question_Question_Att
SELECT UNIQUE QUESTIONID, QUESTIONATTEMPTSID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
        WHERE QUESTIONANSWERSID IS NOT NULL -- There are questions that have no answers, like descriptions.
         AND NOT EXISTS (SELECT 1 FROM L_Question_Question_Att WHERE question_id = QUESTIONID AND question_attempt_id = QUESTIONATTEMPTSID AND sourcesystem = SOURCESYSTEM);

--Populate L_Question_Item table

INSERT INTO L_Question_Item
SELECT UNIQUE QUESTIONID, QUESTIONANSWERSID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
        WHERE QUESTIONANSWERSID IS NOT NULL -- There are questions that have no answers, like descriptions.
         AND NOT EXISTS (SELECT 1 FROM L_Question_Item WHERE question_id = QUESTIONID AND item_id = QUESTIONANSWERSID AND sourcesystem = SOURCESYSTEM);

--Populate L_Quiz_Att_Question_Att table
INSERT INTO L_Quiz_Att_Question_Att
SELECT UNIQUE QUIZATTEMPTSID, QUESTIONATTEMPTSID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM L_Quiz_Att_Question_Att WHERE quiz_attempt_id = QUIZATTEMPTSID AND question_attempt_id = QUESTIONATTEMPTSID AND sourcesystem = SOURCESYSTEM);

--Populate L_Ques_Att_Ques_Att_Step table

INSERT INTO L_Ques_Att_Ques_Att_Step
SELECT UNIQUE QUESTIONATTEMPTSID, QASTEPID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM L_Ques_Att_Ques_Att_Step WHERE question_attempt_id = QUESTIONATTEMPTSID AND question_attempt_step_id = QASTEPID AND sourcesystem = SOURCESYSTEM);

--Populate L_Question_Quiz table

INSERT INTO L_Question_Quiz
SELECT UNIQUE QUESTIONID, QUIZID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM L_Question_Quiz WHERE question_id = QUESTIONID AND quiz_id = QUIZID AND sourcesystem = SOURCESYSTEM);


--If needed, drop the QUESTION_ANSWERS_VERSIONS table.
DROP TABLE STAGING.QUESTION_ANSWERS_VERSIONS;
