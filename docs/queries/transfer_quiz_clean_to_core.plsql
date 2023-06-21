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

-- Create PROCEDURE in the CORE area to load the content of the tables in CLEANSING area to the tables in CORE area.

create or replace PROCEDURE transfer_quiz_clean_to_core IS

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
