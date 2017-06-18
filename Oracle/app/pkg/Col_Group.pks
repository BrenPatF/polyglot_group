CREATE OR REPLACE PACKAGE Col_Group AS
/***************************************************************************************************
Name: Col_Group.pks                    Author: Brendan Furey                       Date: 05-Oct-2016

Oracle component of polyglot project: a simple file-reading and group-counting module, with unit
testing programs, code timing and general utility packages, implemented in multiple languages for
learning purposes: https://github.com/BrenPatF/polyglot_group

The Oracle component does not have a main program, but two testing programs, one using utPLSQL, and
the other the author's own framework:

'TRAPIT - TRansactional API Testing in Oracle'
http://aprogrammerwrites.eu/?p=1723

See also: 'Oracle and JUnit Data Driven Testing: An Example' on the Oracle and Java components,
http://aprogrammerwrites.eu/?p=1860

===========================================
|  Driver     |  Class/API  |  Utility    |
==============|=============|==============
|  UT Tester  | *Col Group* |  Utils      |
|  TT Tester  |             |  Timer Set  |
===========================================

Procedures to read delimited lines from file via external table, count values in a given column,
then return counts in various orderings.

***************************************************************************************************/

PROCEDURE AIP_Load_File (p_file VARCHAR2, p_delim VARCHAR2, p_colnum PLS_INTEGER);
FUNCTION AIP_List_Asis RETURN chr_int_arr;
FUNCTION AIP_Sort_By_Key RETURN chr_int_arr;
FUNCTION AIP_Sort_By_Value RETURN chr_int_arr;

END Col_Group;
/
SHO ERR



