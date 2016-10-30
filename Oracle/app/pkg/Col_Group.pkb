CREATE OR REPLACE PACKAGE BODY Col_Group AS
/***************************************************************************************************
Description:  from file via external table

Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        05-Oct-2016 1.0   Created

***************************************************************************************************/

g_chr_int_lis           chr_int_arr;
/***************************************************************************************************

AIP_Load_File:  entry point procedure

***************************************************************************************************/
PROCEDURE AIP_Load_File (p_file VARCHAR2, p_delim VARCHAR2, p_colnum PLS_INTEGER) IS
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

FUNCTION AIP_List_Asis RETURN chr_int_arr IS
BEGIN

  RETURN g_chr_int_lis;

END AIP_List_Asis;

FUNCTION AIP_Sort_By_Key RETURN chr_int_arr IS
  l_chr_int_lis	chr_int_arr;
BEGIN

  SELECT chr_int_rec (t.chr_field, t.int_field)
    BULK COLLECT INTO l_chr_int_lis
    FROM TABLE (g_chr_int_lis) t
   ORDER BY t.chr_field;

  RETURN l_chr_int_lis;

END AIP_Sort_By_Key;

FUNCTION AIP_Sort_By_Value RETURN chr_int_arr IS
  l_chr_int_lis	chr_int_arr;
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



