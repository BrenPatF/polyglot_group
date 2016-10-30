CREATE OR REPLACE PACKAGE TT_Col_Group AS
/***************************************************************************************************
Name:        Col_Group - unit test package for Emp_WS
Description: Unit testing for HR demo web service code
                                                                               
Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        08-Aug-2016 1.0   Created

***************************************************************************************************/
PROCEDURE tt_AIP_List_Asis;
PROCEDURE tt_AIP_Sort_By_Key;
PROCEDURE tt_AIP_Sort_By_Value;

END TT_Col_Group;
/
sho err



