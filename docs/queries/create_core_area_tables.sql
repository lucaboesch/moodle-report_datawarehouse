-- Create quiz related tables in CORE area
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

