-- Create PROCEDURE in the MART area to load the content of the tables in CORE area to the tables in MART area.

create or replace PROCEDURE transfer_quiz_core_to_mart IS

BEGIN
dbms_output.put_line('Transfer the values from the CORE area to the MART area.');

--Populate H_Question table

INSERT INTO H_Question
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_QUESTION
         WHERE NOT EXISTS (SELECT 1 FROM H_Question WHERE question_id = QUESTION_ID AND sourcesystem = SOURCESYSTEM);

--Populate H_Item table
INSERT INTO H_Item
SELECT UNIQUE LOAD_ID, ITEM_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_ITEM
        WHERE NOT EXISTS (SELECT 1 FROM H_Item WHERE item_id = ITEM_ID AND sourcesystem = SOURCESYSTEM);

--Populate H_Quiz_Attempt table

INSERT INTO H_Quiz_Attempt
SELECT UNIQUE LOAD_ID, QUIZ_ATTEMPT_ID, SOURCESYSTEM, QUIZ_ATTEMPT_USER_HASH, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_QUIZ_ATTEMPT
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz_Attempt WHERE quiz_attempt_id = QUIZ_ATTEMPT_ID AND sourcesystem = SOURCESYSTEM);

--Populate H_Question_Attempt table

INSERT INTO H_Question_Attempt
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_QUESTION_ATTEMPT
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt WHERE question_attempt_id = QUESTION_ATTEMPT_ID AND sourcesystem = SOURCESYSTEM);

--Populate H_Question_Attempt_Step table

INSERT INTO H_Question_Attempt_Step
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_STEP_ID, SOURCESYSTEM, MOODLE_KEY, CREATEDUNIXTIME, CREATEDTIMESTAMP, AUTHORIZEDUSERS
         FROM CORE.H_QUESTION_ATTEMPT_STEP
         WHERE NOT EXISTS (SELECT 1 FROM H_Question_Attempt_Step WHERE question_attempt_step_id = QUESTION_ATTEMPT_STEP_ID AND sourcesystem = SOURCESYSTEM);

--Populate H_Quiz table

INSERT INTO H_Quiz
SELECT UNIQUE LOAD_ID, QUIZ_ID, SOURCESYSTEM, MOODLE_KEY, AUTHORIZEDUSERS
         FROM CORE.H_QUIZ
         WHERE NOT EXISTS (SELECT 1 FROM H_Quiz WHERE quiz_id = QUIZ_ID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Info table

INSERT INTO S_Question_Info
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, QUESTION_NAME, TO_CHAR(QUESTION_TEXT), VERSION_ID, AUTHORIZEDUSERS
         FROM CORE.S_QUESTION_INFO
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Info WHERE question_id = QUESTION_ID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Author table

INSERT INTO S_Question_Author
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, QUESTION_AUTHOR_HASH, VERSION_ID, AUTHORIZEDUSERS
         FROM CORE.S_QUESTION_AUTHOR
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Author WHERE question_id = QUESTION_ID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Statistics table

INSERT INTO S_Question_Statistics
SELECT UNIQUE LOAD_ID, QUESTION_ID, SOURCESYSTEM, SLOT, EFFECTIVEWEIGHT, DISCRIMINATIONINDEX, DISCRIMINATIVEEFFICIENCY, SD, FACILITY, RANDOMGUESSSCORE, AUTHORIZEDUSERS
         FROM CORE.S_QUESTION_STATISTICS
         WHERE NOT EXISTS (SELECT 1 FROM S_Question_Statistics WHERE question_id = QUESTION_ID AND sourcesystem = SOURCESYSTEM);

--Populate S_Question_Attempt_Step_Data table

INSERT INTO S_Question_Attempt_Step_Data
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_STEP_ID, SOURCESYSTEM, NAME, TO_CHAR(VALUE), AUTHORIZEDUSERS
         FROM CORE.S_QUESTION_ATTEMPT_STEP_DATA
        WHERE NOT EXISTS (SELECT 1 FROM S_Question_Attempt_Step_Data WHERE question_attempt_step_id = QUESTION_ATTEMPT_STEP_ID AND sourcesystem = SOURCESYSTEM);

--Populate L_Question_Question_Att table

INSERT INTO L_Question_Question_Att
SELECT UNIQUE LOAD_ID, QUESTION_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUESTION_QUESTION_ATT
        WHERE NOT EXISTS (SELECT 1 FROM L_Question_Question_Att WHERE question_id = QUESTION_ID AND question_attempt_id = QUESTION_ATTEMPT_ID AND sourcesystem = SOURCESYSTEM);

--Populate L_Question_Item table

INSERT INTO L_Question_Item
SELECT UNIQUE LOAD_ID, QUESTION_ID, ITEM_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUESTION_ITEM
        WHERE ITEM_ID IS NOT NULL -- There are questions that have no answers, like descriptions.
         AND NOT EXISTS (SELECT 1 FROM L_Question_Item WHERE question_id = QUESTION_ID AND item_id = ITEM_ID AND sourcesystem = SOURCESYSTEM);

--Populate L_Quiz_Att_Question_Att table

INSERT INTO L_Quiz_Att_Question_Att
SELECT UNIQUE LOAD_ID, QUIZ_ATTEMPT_ID, QUESTION_ATTEMPT_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUIZ_ATT_QUESTION_ATT
         WHERE NOT EXISTS (SELECT 1 FROM L_Quiz_Att_Question_Att WHERE quiz_attempt_id = QUIZ_ATTEMPT_ID AND question_attempt_id = QUESTION_ATTEMPT_ID AND sourcesystem = SOURCESYSTEM);

--Populate L_Ques_Att_Ques_Att_Step table

INSERT INTO L_Ques_Att_Ques_Att_Step
SELECT UNIQUE LOAD_ID, QUESTION_ATTEMPT_ID, QUESTION_ATTEMPT_STEP_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUES_ATT_QUES_ATT_STEP
         WHERE NOT EXISTS (SELECT 1 FROM L_Ques_Att_Ques_Att_Step WHERE question_attempt_id = QUESTION_ATTEMPT_ID AND question_attempt_step_id = QUESTION_ATTEMPT_STEP_ID AND sourcesystem = SOURCESYSTEM);

--Populate L_Question_Quiz table

INSERT INTO L_Question_Quiz
SELECT UNIQUE LOAD_ID, QUESTION_ID, QUIZ_ID, SOURCESYSTEM, VALUE_FROM, VALUE_TO, AUTHORIZEDUSERS
         FROM CORE.L_QUESTION_QUIZ
         WHERE NOT EXISTS (SELECT 1 FROM L_Question_Quiz WHERE question_id = QUESTION_ID AND quiz_id = QUIZ_ID AND sourcesystem = SOURCESYSTEM);

COMMIT;

dbms_output.put_line('Done transfering the values from the CORE area to the MART area.');

END;