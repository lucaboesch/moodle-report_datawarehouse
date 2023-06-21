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
