CREATE OR REPLACE PACKAGE Col_Group AS
/***************************************************************************************************

Description: polyglot group-counting module
                                                                               
Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        30-Oct-2016 1.0   Created

***************************************************************************************************/

PROCEDURE AIP_Load_File (p_file VARCHAR2, p_delim VARCHAR2, p_colnum PLS_INTEGER);
FUNCTION AIP_List_Asis RETURN chr_int_arr;
FUNCTION AIP_Sort_By_Key RETURN chr_int_arr;
FUNCTION AIP_Sort_By_Value RETURN chr_int_arr;

END Col_Group;
/
SHO ERR



