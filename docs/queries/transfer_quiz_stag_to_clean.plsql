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

-- Create PROCEDURE in the CLEANSING area to load the content of the tables in STAGING area to the tables in CLEANSING area.

create or replace PROCEDURE transfer_quiz_stag_to_clean (loadid IN NUMBER) IS

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
