--Generate MART tables
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

