CREATE OR REPLACE PACKAGE BODY Col_Group AS
/***************************************************************************************************
Name: Col_Group.pkb                    Author: Brendan Furey                       Date: 05-Oct-2016

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

g_chr_int_lis           chr_int_arr;
/***************************************************************************************************

AIP_Load_File: Reads file via external table, and stores counts of string values in input column into
               package array

***************************************************************************************************/
PROCEDURE AIP_Load_File (p_file     VARCHAR2,       -- file name, including path
                         p_delim    VARCHAR2,       -- field delimiter
                         p_colnum   PLS_INTEGER) IS -- column number of values to be counted
BEGIN

  EXECUTE IMMEDIATE 'ALTER TABLE lines_et LOCATION (''' || p_file || ''')';

  WITH key_column_values AS (
    SELECT Substr (line, Instr(p_delim||line||p_delim, p_delim, 1, p_colnum),
                         Instr(p_delim||line||p_delim, p_delim, 1, p_colnum+1) - Instr(p_delim||line||p_delim, p_delim, 1, p_colnum) - Length(p_delim)) keyval
      FROM lines_et
  )
  SELECT chr_int_rec (keyval, COUNT(*))
    BULK COLLECT INTO g_chr_int_lis
    FROM key_column_values
   GROUP BY keyval;

END AIP_Load_File;

/***************************************************************************************************

AIP_List_Asis: Returns the key-value array of string, count as is, i.e. unsorted

***************************************************************************************************/
FUNCTION AIP_List_Asis RETURN chr_int_arr IS -- key-value array unsorted
BEGIN

  RETURN g_chr_int_lis;

END AIP_List_Asis;

/***************************************************************************************************

AIP_Sort_By_Key: Returns the key-value array of (string, count) sorted by key

***************************************************************************************************/
FUNCTION AIP_Sort_By_Key RETURN chr_int_arr IS -- key-value array sorted by key
  l_chr_int_lis chr_int_arr;
BEGIN

  SELECT chr_int_rec (t.chr_field, t.int_field)
    BULK COLLECT INTO l_chr_int_lis
    FROM TABLE (g_chr_int_lis) t
   ORDER BY t.chr_field;

  RETURN l_chr_int_lis;

END AIP_Sort_By_Key;

/***************************************************************************************************

AIP_Sort_By_Value: Returns the key-value array of (string, count) sorted by value

***************************************************************************************************/
FUNCTION AIP_Sort_By_Value RETURN chr_int_arr IS -- key-value array sorted by value
  l_chr_int_lis chr_int_arr;
BEGIN

  SELECT chr_int_rec (t.chr_field, t.int_field)
    BULK COLLECT INTO l_chr_int_lis
    FROM TABLE (g_chr_int_lis) t
   ORDER BY t.int_field, t.chr_field;

  RETURN l_chr_int_lis;

END AIP_Sort_By_Value;

END Col_Group;
/
SHO ERR