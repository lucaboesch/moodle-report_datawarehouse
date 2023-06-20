-- Create FUNCTION in the MONITORING area to be able to look up load ids for given file names.

create or replace FUNCTION lookup_loadid(file_name IN VARCHAR2)
RETURN NUMBER
IS
   loadid NUMBER;
BEGIN
   SELECT id INTO loadid FROM MONITORING."LOADIDS" WHERE filename=file_name;
   dbms_output.put_line('Load id for file ' || file_name || ' is ' || loadid || '.');
   return(loadid);
exception
  when NO_DATA_FOUND then
    return(0);
END;
