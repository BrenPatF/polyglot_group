CREATE OR REPLACE PACKAGE TT_Col_Group AS
/***************************************************************************************************
Name: TT_Col_Group.pkb                 Author: Brendan Furey                       Date: 05-Oct-2016

Oracle component of polyglot project: a simple file-reading and group-counting module, with unit
testing programs, code timing and general utility packages, implemented in multiple languages for
learning purposes: https://github.com/BrenPatF/polyglot_group

The Oracle component does not have a main program, but two testing programs, one using utPLSQL, and
the other the author's own framework:

'TRAPIT - TRansactional API Testing in Oracle', http://aprogrammerwrites.eu/?p=1723

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

===========================================
|  Driver     |  Class/API  |  Utility    |
==============|=============|==============
|  UT Tester  |  Col Group  |  Utils      |
| *TT Tester* |             |  Timer Set  |
===========================================

TRAPIT (TRansactional API Testing) package specification for Col_Group.

***************************************************************************************************/
PROCEDURE tt_AIP_List_Asis;
PROCEDURE tt_AIP_Sort_By_Key;
PROCEDURE tt_AIP_Sort_By_Value;

END TT_Col_Group;
/
sho err



