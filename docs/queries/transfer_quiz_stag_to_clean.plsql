-- Create PROCEDURE in the CLEANSING area to load the content of the tables in STAGING area to the tables in CLEANSING area.

create or replace PROCEDURE transfer_quiz_stag_to_clean (loadid IN NUMBER) IS

loadidid NUMBER;

BEGIN
dbms_output.put_line('Insert the values for load id ' || loadid || ' to the CLEANSING area.');

SELECT CAST(loadid AS NUMBER ) INTO loadidid from dual;

--Populate H_Question table

INSERT INTO H_Question
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, SOURCESYSTEM, QUESTIONID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Question WHERE question_id = QUESTIONID AND sourcesystem = SOURCESYSTEM);

--Populate H_Item table

INSERT INTO H_Item
SELECT UNIQUE loadidid AS "LOADID", QUESTIONANSWERSID, SOURCESYSTEM, QUESTIONANSWERSID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
        WHERE QUESTIONANSWERSID IS NOT NULL -- There are questions that have no answers, like descriptions.
        AND NOT EXISTS (SELECT 1 FROM H_Item WHERE item_id = QUESTIONANSWERSID AND sourcesystem = SOURCESYSTEM);

--Populate H_Quiz_Attempt table

INSERT INTO H_Quiz_Attempt
SELECT UNIQUE loadidid AS "LOADID", QUIZATTEMPTSID, SOURCESYSTEM, QZATUSERID, QUIZATTEMPTSID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz_Attempt WHERE quiz_attempt_id = QUIZATTEMPTSID AND sourcesystem = SOURCESYSTEM);

--Populate H_Question_Attempt table

INSERT INTO H_Question_Attempt
SELECT UNIQUE loadidid AS "LOADID", QUESTIONATTEMPTSID, SOURCESYSTEM, QUESTIONATTEMPTSID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt WHERE question_attempt_id = QUESTIONATTEMPTSID AND sourcesystem = SOURCESYSTEM);

--Populate H_Question_Attempt_Step table

INSERT INTO H_Question_Attempt_Step
SELECT UNIQUE loadidid AS "LOADID", QASTEPID, SOURCESYSTEM, QASTEPID, QASTEPCREATED, QASTEPCREATEDSTRING, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt_Step WHERE question_attempt_step_id = QASTEPID AND sourcesystem = SOURCESYSTEM);

--Populate H_Quiz table

INSERT INTO H_Quiz
SELECT UNIQUE loadidid AS "LOADID", QUIZID, SOURCESYSTEM, QUIZID, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz WHERE quiz_id = QUIZID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Info table

INSERT INTO S_Question_Info
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, SOURCESYSTEM, QUESTIONNAME, QUESTIONTEXT, VERSION, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Info WHERE question_id = QUESTIONID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Author table

INSERT INTO S_Question_Author
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, SOURCESYSTEM, QBEUSERNAME, VERSION, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Author WHERE question_id = QUESTIONID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Statistics table

INSERT INTO S_Question_Statistics
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, SOURCESYSTEM, SLOT, EFFECTIVEWEIGHT, DISCRIMINATIONINDEX, DISCRIMINATIVEEFFICIENCY, SD, FACILITY, RANDOMGUESSSCORE, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Statistics WHERE question_id = QUESTIONID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Attempt_Step_Data table

INSERT INTO S_Question_Attempt_Step_Data
SELECT UNIQUE loadidid AS "LOADID", QASTEPID, SOURCESYSTEM, QUESTIONATTEMPTSTEPDATANAME, QUESTIONATTEMPTSTEPDATAVALUE, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
        WHERE QUESTIONATTEMPTSTEPDATANAME IS NOT NULL AND QUESTIONATTEMPTSTEPDATAVALUE IS NOT NULL
        AND NOT EXISTS (SELECT 1 FROM S_Question_Attempt_Step_Data WHERE question_attempt_step_id = QASTEPID AND sourcesystem = SOURCESYSTEM);

--Populate L_Question_Question_Att table

INSERT INTO L_Question_Question_Att
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, QUESTIONATTEMPTSID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
        WHERE QUESTIONANSWERSID IS NOT NULL -- There are questions that have no answers, like descriptions.
         AND NOT EXISTS (SELECT 1 FROM L_Question_Question_Att WHERE question_id = QUESTIONID AND question_attempt_id = QUESTIONATTEMPTSID AND sourcesystem = SOURCESYSTEM);

--Populate L_Question_Item table

INSERT INTO L_Question_Item
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, QUESTIONANSWERSID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
        WHERE QUESTIONANSWERSID IS NOT NULL -- There are questions that have no answers, like descriptions.
         AND NOT EXISTS (SELECT 1 FROM L_Question_Item WHERE question_id = QUESTIONID AND item_id = QUESTIONANSWERSID AND sourcesystem = SOURCESYSTEM);

--Populate L_Quiz_Att_Question_Att table
INSERT INTO L_Quiz_Att_Question_Att
SELECT UNIQUE loadidid AS "LOADID", QUIZATTEMPTSID, QUESTIONATTEMPTSID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM L_Quiz_Att_Question_Att WHERE quiz_attempt_id = QUIZATTEMPTSID AND question_attempt_id = QUESTIONATTEMPTSID AND sourcesystem = SOURCESYSTEM);

--Populate L_Ques_Att_Ques_Att_Step table

INSERT INTO L_Ques_Att_Ques_Att_Step
SELECT UNIQUE loadidid AS "LOADID", QUESTIONATTEMPTSID, QASTEPID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM L_Ques_Att_Ques_Att_Step WHERE question_attempt_id = QUESTIONATTEMPTSID AND question_attempt_step_id = QASTEPID AND sourcesystem = SOURCESYSTEM);

--Populate L_Question_Quiz table

INSERT INTO L_Question_Quiz
SELECT UNIQUE loadidid AS "LOADID", QUESTIONID, QUIZID, SOURCESYSTEM, 0, 0, AUTHORIZEDUSERS
         FROM STAGING.QUESTION_ANSWERS_VERSIONS
         WHERE NOT EXISTS (SELECT 1 FROM L_Question_Quiz WHERE question_id = QUESTIONID AND quiz_id = QUIZID AND sourcesystem = SOURCESYSTEM);

COMMIT;

dbms_output.put_line('Done inserting the values for load id ' || loadid || ' from the STAGING area to the CLEANSING area.');

END;