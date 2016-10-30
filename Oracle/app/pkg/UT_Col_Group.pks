CREATE OR REPLACE PACKAGE UT_Col_Group AS
/***************************************************************************************************

Description: utPLSQL unit testing for polyglot group-counting module, Col_Group
                                                                               
Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        30-Oct-2016 1.0   Created
                                                                               
***************************************************************************************************/
PROCEDURE ut_AIP_List_Asis;
PROCEDURE ut_AIP_Sort_By_Key;
PROCEDURE ut_AIP_Sort_By_Value;

PROCEDURE ut_Setup;
PROCEDURE ut_Teardown;

END UT_Col_Group;
/
sho err



