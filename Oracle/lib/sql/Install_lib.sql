/***************************************************************************************************

Author:      Brendan Furey
Description: 

Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        04-Oct-2016 1.0   Created (from 4 April 2016)

***************************************************************************************************/
SET SERVEROUTPUT ON
SET TRIMSPOOL ON
SET PAGES 1000
SET LINES 500
SPOOL ..\out\Install_lib.log

REM Run this script from lib schema for Brendan's demos to create the common objects 

PROMPT Common types creation
PROMPT =====================

PROMPT Drop type L3_chr_arr
DROP TYPE L3_chr_arr
/
PROMPT Drop type L2_chr_arr
DROP TYPE L2_chr_arr
/
PROMPT Create type L1_chr_arr
CREATE OR REPLACE TYPE L1_chr_arr IS VARRAY(32767) OF VARCHAR2(32767)
/
PROMPT Create type L2_chr_arr
CREATE OR REPLACE TYPE L2_chr_arr IS VARRAY(32767) OF L1_chr_arr
/
PROMPT Create type L3_chr_arr
CREATE OR REPLACE TYPE L3_chr_arr IS VARRAY(32767) OF L2_chr_arr
/
GRANT EXECUTE ON L1_chr_arr TO PUBLIC
/
GRANT EXECUTE ON L2_chr_arr TO PUBLIC
/
GRANT EXECUTE ON L3_chr_arr TO PUBLIC
/
PROMPT Create type L1_num_arr
CREATE OR REPLACE TYPE L1_num_arr IS VARRAY(32767) OF NUMBER
/
GRANT EXECUTE ON L1_num_arr TO PUBLIC
/

PROMPT Common tables creation
PROMPT ======================

PROMPT Create table log_headers
DROP TABLE log_lines
/
DROP TABLE log_headers
/
CREATE TABLE log_headers (
        id                      INTEGER NOT NULL,
        description             VARCHAR2(500),
        creation_date           TIMESTAMP,
        CONSTRAINT hdr_pk       PRIMARY KEY (id)
)
/
PROMPT Insert the default log header
INSERT INTO log_headers VALUES (0, 'Miscellaneous output', SYSTIMESTAMP)
/
GRANT ALL ON log_headers TO PUBLIC
/
DROP SEQUENCE log_headers_s
/
CREATE SEQUENCE log_headers_s START WITH 1
/
GRANT SELECT ON log_headers_s TO PUBLIC
/
PROMPT Create table log_lines
CREATE TABLE log_lines (
        id                      INTEGER NOT NULL,
        log_header_id           INTEGER NOT NULL,
        group_text              VARCHAR2(100),
        line_text               VARCHAR2(4000),
        creation_date           TIMESTAMP,
        CONSTRAINT lin_pk       PRIMARY KEY (id, log_header_id),
        CONSTRAINT lin_hdr_fk   FOREIGN KEY (log_header_id) REFERENCES log_headers (id)
)
/
GRANT ALL ON log_lines TO PUBLIC
/
DROP SEQUENCE log_lines_s
/
CREATE SEQUENCE log_lines_s START WITH 1
/
GRANT SELECT ON log_lines_s TO PUBLIC
/

PROMPT Packages creation
PROMPT =================

PROMPT Create package Utils
@..\pkg\Utils.pks
@..\pkg\Utils.pkb
GRANT EXECUTE ON Utils TO PUBLIC
/

PROMPT Create package Timer_Set
@..\pkg\Timer_Set.pks
@..\pkg\Timer_Set.pkb
GRANT EXECUTE ON Timer_Set TO PUBLIC;

PROMPT Create package Utils_TT
@..\pkg\Utils_TT.pks
@..\pkg\Utils_TT.pkb
GRANT EXECUTE ON Utils_TT TO PUBLIC
/

SPOOL OFF
