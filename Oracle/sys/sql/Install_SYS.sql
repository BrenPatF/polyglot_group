SET SERVEROUTPUT ON
SET TRIMSPOOL ON
SET PAGES 1000
SET LINES 500
SPOOL ..\out\Install_SYS.log
REM
REM Run this script from sys schema to create new schemas for Brendan's demos
REM

@..\sql\C_User lib
@..\sql\C_User app

PROMPT DIRECTORY input_dir
CREATE OR REPLACE DIRECTORY input_dir AS 'C:\input'
/
GRANT ALL ON DIRECTORY input_dir TO PUBLIC
/
GRANT EXECUTE ON UTL_File TO PUBLIC
/
SPOOL OFF
