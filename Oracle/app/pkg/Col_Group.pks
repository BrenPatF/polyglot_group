CREATE OR REPLACE PACKAGE Col_Group AS
/***************************************************************************************************
Description: HR demo batch code. Procedure saves new employees from file via external table
                                                                               
Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        05-Oct-2016 1.0   Created

***************************************************************************************************/

PROCEDURE AIP_Load_File (p_file VARCHAR2, p_delim VARCHAR2, p_colnum PLS_INTEGER);
FUNCTION AIP_List_Asis RETURN chr_int_arr;
FUNCTION AIP_Sort_By_Key RETURN chr_int_arr;
FUNCTION AIP_Sort_By_Value RETURN chr_int_arr;

END Col_Group;
/
SHO ERR



