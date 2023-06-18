-- Create quiz related tables in CLEANSING area
CREATE TABLE H_Question (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Item (load_id NUMBER NOT NULL, item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Quiz_Attempt (load_id NUMBER NOT NULL, quiz_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, quiz_attempt_user_hash VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Question_Attempt (load_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Question_Attempt_Step (load_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), moodle_key NUMBER NOT NULL, createdunixtime NUMBER, createdtimestamp VARCHAR2(20), authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Quiz (load_id NUMBER NOT NULL, quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE S_Question_Info (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_name VARCHAR2(255) NOT NULL, question_text CLOB NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE S_Question_Author (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, question_author_hash VARCHAR2(255) NOT NULL, version_id NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE S_Question_Statistics (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, slot NUMBER, effectiveweight FLOAT, discriminationindex FLOAT, discriminativeefficiency FLOAT, sd FLOAT, facility FLOAT, randomguessscore FLOAT, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE S_Question_Attempt_Step_Data (load_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), name VARCHAR2(32) NOT NULL, value CLOB NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE L_Question_Question_Att (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE L_Question_Item (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, item_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE L_Quiz_Att_Question_Att (load_id NUMBER NOT NULL, quiz_attempt_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE L_Ques_Att_Ques_Att_Step (load_id NUMBER NOT NULL, question_attempt_id NUMBER NOT NULL, question_attempt_step_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE L_Question_Quiz (load_id NUMBER NOT NULL, question_id NUMBER NOT NULL, quiz_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));

-- Create assignment related tables in CLEANSING area
CREATE TABLE H_Assignment (load_id NUMBER NOT NULL, assign_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Assign_Submission (load_id NUMBER NOT NULL, assign_submission_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, assign_submission_user_hash VARCHAR2(255) NOT NULL, authorizedusers VARCHAR2(32672 BYTE));
CREATE TABLE H_Assign_Grade (load_id NUMBER NOT NULL, assign_grade_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, assign_grade VARCHAR2(255) NOT NULL, assign_submission_user_hash VARCHAR2(255) NOT NULL, moodle_key NUMBER NOT NULL, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE L_Assignment_Assign_Subm (load_id NUMBER NOT NULL, assign_id NUMBER NOT NULL, assign_submission_id NUMBER NOT NULL, sourcesystem VARCHAR2(255) NOT NULL, value_from NUMBER, value_to NUMBER, authorizedusers VARCHAR2(32672 BYTE));

CREATE TABLE S_Assignment_Info (load_id NUMBER NOT NULL, assign_id NUMBER NOT NULL, sourcesystem VARCHAR2(255), assign_name VARCHAR2(255), assign_intro VARCHAR2(32672 BYTE), assign_activity VARCHAR2(32672 BYTE), authorizedusers VARCHAR2(32672 BYTE));

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

