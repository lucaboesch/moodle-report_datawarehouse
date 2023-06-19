-- This procedure is to be created in schema MONITORING. 
create or replace PROCEDURE load_quiz_file (bucket_path IN VARCHAR2, file_name IN VARCHAR2)
AS

   loadid number;

   BEGIN
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

   END;