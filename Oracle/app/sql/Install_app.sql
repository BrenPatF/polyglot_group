SET SERVEROUTPUT ON
/***************************************************************************************************

Author:      Brendan Furey
Description: 

Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        04-Oct-2016 1.0   Created (from 4 April 2016)

***************************************************************************************************/
SET TRIMSPOOL ON
SET PAGES 1000
SET LINES 500
SPOOL ..\out\Install_app.log

REM Run this script from app schema to create the app objects 

PROMPT Synomym creation TO lib objects
PROMPT ===============================

CREATE OR REPLACE SYNONYM L1_chr_arr FOR lib.L1_chr_arr
/
CREATE OR REPLACE SYNONYM L2_chr_arr FOR lib.L2_chr_arr
/
CREATE OR REPLACE SYNONYM L3_chr_arr FOR lib.L3_chr_arr
/
CREATE OR REPLACE SYNONYM L1_num_arr FOR lib.L1_num_arr
/
CREATE OR REPLACE SYNONYM log_headers FOR lib.log_headers
/
CREATE OR REPLACE SYNONYM log_headers_s FOR lib.log_headers_s
/
CREATE OR REPLACE SYNONYM log_lines FOR lib.log_lines
/
CREATE OR REPLACE SYNONYM log_lines_s FOR lib.log_lines_s
/
CREATE OR REPLACE SYNONYM Utils FOR lib.Utils
/
CREATE OR REPLACE SYNONYM Timer_Set FOR lib.Timer_Set
/
CREATE OR REPLACE SYNONYM TT_Utils FOR lib.TT_Utils
/
PROMPT EXTERNAL table creation
PROMPT =======================
PROMPT Create lines_et
DROP TABLE lines_et
/
CREATE TABLE lines_et (
        line            VARCHAR2(400)
)
ORGANIZATION EXTERNAL ( 
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY input_dir
    ACCESS PARAMETERS (
            RECORDS DELIMITED BY NEWLINE
            FIELDS (
                line POSITION (1:4000) CHAR(4000)
            )
    )
    LOCATION ('lines.csv')
)
    REJECT LIMIT UNLIMITED
/
PROMPT Types creation
PROMPT ==============

CREATE OR REPLACE TYPE chr_int_rec AS 
    OBJECT (chr_field           VARCHAR2(4000), 
            int_field           INTEGER)
/
CREATE OR REPLACE TYPE chr_int_arr AS TABLE OF chr_int_rec
/
PROMPT Packages creation
PROMPT =================

PROMPT Create package Col_Group
@..\pkg\Col_Group.pks
@..\pkg\Col_Group.pkb
GRANT EXECUTE ON Col_Group TO PUBLIC
/
PROMPT Create package TT_Col_Group
@..\pkg\TT_Col_Group.pks
@..\pkg\TT_Col_Group.pkb
GRANT EXECUTE ON TT_Col_Group TO PUBLIC
/
PROMPT Create package UT_Col_Group
@..\pkg\UT_Col_Group.pks
@..\pkg\UT_Col_Group.pkb
GRANT EXECUTE ON UT_Col_Group TO PUBLIC
/
DECLARE
  c_suite_mk    CONSTANT VARCHAR2(30) := 'brendan';
BEGIN

  UTP.UTSuite.Add (c_suite_mk);
  UTP.UTPackage.Add (c_suite_mk, 'COL_GROUP');

END;
/

SPOOL OFF
