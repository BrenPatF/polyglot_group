CREATE OR REPLACE PACKAGE TT_Col_Group AS
/***************************************************************************************************

Description: TRAPIT  (TRansactional API Testing) for polyglot group-counting module, Col_Group

Further details: 'TRAPIT - TRansactional API Testing in Oracle'
                 http://aprogrammerwrites.eu/?p=1723

Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        30-Oct-2016 1.0   Created
                                                                               
***************************************************************************************************/
PROCEDURE tt_AIP_List_Asis;
PROCEDURE tt_AIP_Sort_By_Key;
PROCEDURE tt_AIP_Sort_By_Value;

END TT_Col_Group;
/
sho err



