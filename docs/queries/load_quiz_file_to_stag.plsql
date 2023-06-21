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

-- Create PROCEDURE in the STAGING area to load the content of a file into the tables.
create or replace PROCEDURE load_quiz_file_to_stag (bucket_path IN VARCHAR2, file_name IN VARCHAR2)
IS
-- Populate QUESTION_ANSWERS_VERSIONS table with passed parameter filename.
  full_path VARCHAR2(2000) := bucket_path || file_name;

-- DECLARE
  l_TABLE_NAME        DBMS_QUOTED_ID := '"QUESTION_ANSWERS_VERSIONS"';
  l_CREDENTIAL_NAME   DBMS_QUOTED_ID := '""';
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

dbms_output.put_line('Call the copy from file ' || file_name || ' to the STAGING area.');

  INSERT INTO MONITORING.LOADIDS VALUES (0,file_name);
  COMMIT;

  "C##CLOUD$SERVICE"."DBMS_CLOUD"."COPY_DATA"
  ( TABLE_NAME        => l_TABLE_NAME
   ,CREDENTIAL_NAME   => l_CREDENTIAL_NAME
   ,FILE_URI_LIST     => l_FILE_URI_LIST
   ,FIELD_LIST        => l_FIELD_LIST
   ,FORMAT            => l_FORMAT
   ,OPERATION_ID      => l_OPERATION_ID
  );

dbms_output.put_line('Copying the values from file ' || file_name || ' to the STAGING area done.');

END;
