CREATE OR REPLACE PACKAGE BODY UT_Col_Group AS
/***************************************************************************************************
Name: UT_Col_Group.pkb                 Author: Brendan Furey                       Date: 05-Oct-2016

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
| *UT Tester* |  Col Group  |  Utils      |
|  TT Tester  |             |  Timer Set  |
===========================================

utPLSQL package body for Col_Group.

***************************************************************************************************/

c_proc_name_asis        CONSTANT VARCHAR2(60) := 'Col_Group.ut_AIP_List_Asis';
c_proc_name_key         CONSTANT VARCHAR2(60) := 'Col_Group.ut_AIP_Sort_By_Key';
c_proc_name_value       CONSTANT VARCHAR2(60) := 'Col_Group.ut_AIP_Sort_By_vALUE';

c_file_2lis             CONSTANT L2_chr_arr := L2_chr_arr (
                                      L1_chr_arr ('0,1,Cc,3', '00,1,A,9', '000,1,B,27', '0000,1,A,81'),
                                      L1_chr_arr ('X;;1;;A', 'X;;1;;A')
);
c_prms_2lis             CONSTANT L2_chr_arr := L2_chr_arr (
                                      L1_chr_arr ('lines.csv', ',', '3'), L1_chr_arr ('lines.csv', ';;', '1')
);
c_scenario_lis          CONSTANT L1_chr_arr := L1_chr_arr ('Tie-break/single-delimiter/interior column', 'Two copies/double-delimiter/first column');

/***************************************************************************************************

ut_Setup, ut_Teardown: Mandatory procedures for utPLSQL but don't do anything here

***************************************************************************************************/
PROCEDURE ut_Setup IS
BEGIN
  NULL;
END ut_Setup;

PROCEDURE ut_Teardown IS
BEGIN
  NULL;
END ut_Teardown;

/***************************************************************************************************

Do_Test: Main local procedure for utPLSQL unit testing Col_Group methods

***************************************************************************************************/

PROCEDURE Do_Test (p_proc_name          VARCHAR2,      -- procedure name
                   p_exp_2lis           L2_chr_arr) IS -- expected values 2-d array

  /***************************************************************************************************

  Setup: Setup procedure for unit testing Col_Group package. Writes test file, then calls
         constructor API to store data in an array, line counts grouped by key

  ***************************************************************************************************/
  PROCEDURE Setup (p_file                 VARCHAR2,      -- file name
                   p_delim                VARCHAR2,      -- delimiter
                   p_colnum               PLS_INTEGER,   -- key column number in file
                   p_dat_lis              L1_chr_arr) IS -- lines to write to test file

  BEGIN

    Utils.Delete_File (p_file);
    Utils.Write_File (p_file, p_dat_lis);

    Col_Group.AIP_Load_File (p_file => p_file, p_delim => p_delim, p_colnum => p_colnum);

  END Setup;

  /***************************************************************************************************

  Call_Proc: Calls the base method according to calling procedure, and uses utPLSQL assert procedure
             to assert list counts, and for ordered methods, record lists in delimited form

  ***************************************************************************************************/
  PROCEDURE Call_Proc (p_exp_lis        L1_chr_arr,  -- expected values list (delimited records)
                       p_scenario       VARCHAR2) IS -- scenario description

    l_arr_lis           chr_int_arr;
  BEGIN

    l_arr_lis := CASE p_proc_name
                   WHEN c_proc_name_asis        THEN Col_Group.AIP_List_Asis
                   WHEN c_proc_name_key         THEN Col_Group.AIP_Sort_By_Key
                   WHEN c_proc_name_value       THEN Col_Group.AIP_Sort_By_Value
                 END;

    IF p_proc_name = c_proc_name_asis THEN

      utAssert.Eq (p_scenario || ': List count', l_arr_lis.COUNT, p_exp_lis(1), TRUE);

    ELSE

      utAssert.Eq (p_scenario || ': List count', l_arr_lis.COUNT, p_exp_lis.COUNT, TRUE);
      FOR i IN 1..LEAST (l_arr_lis.COUNT, p_exp_lis.COUNT) LOOP

        utAssert.Eq ('...Record', Utils.List_Delim (l_arr_lis(i).chr_field, l_arr_lis(i).int_field), p_exp_lis(i), TRUE);

      END LOOP;

    END IF;

  END Call_Proc;

BEGIN

  FOR i IN 1..c_file_2lis.COUNT LOOP

    Setup (p_file              => c_prms_2lis(i)(1),
           p_delim             => c_prms_2lis(i)(2),
           p_colnum            => c_prms_2lis(i)(3),
           p_dat_lis           => c_file_2lis(i));

    Call_Proc (p_exp_2lis(i), c_scenario_lis(i));

  END LOOP;

END Do_Test;

/***************************************************************************************************

ut_AIP_List_Asis: Entry procedure for utPLSQL testing Col_Group.AIP_List_Asis

***************************************************************************************************/
PROCEDURE ut_AIP_List_Asis IS

  c_proc_name           CONSTANT VARCHAR2(61) := c_proc_name_asis;
  c_exp_2lis            CONSTANT L2_chr_arr := L2_chr_arr (L1_chr_arr('3'), L1_chr_arr('2'));

BEGIN

  Do_Test (c_proc_name, c_exp_2lis);

END ut_AIP_List_Asis;

/***************************************************************************************************

ut_AIP_Sort_By_Key: Entry procedure for utPLSQL testing Col_Group.AIP_Sort_By_Key

***************************************************************************************************/
PROCEDURE ut_AIP_Sort_By_Key IS

  c_proc_name           CONSTANT VARCHAR2(61) := c_proc_name_key;
  c_exp_2lis            CONSTANT L2_chr_arr := L2_chr_arr (L1_chr_arr (Utils.List_Delim ('A','2'),
                                                                         Utils.List_Delim ('Bx','1'),
                                                                         Utils.List_Delim ('Cc','1')),
                                                             L1_chr_arr (Utils.List_Delim ('X','2'))
                                               );
BEGIN

  Do_Test (c_proc_name, c_exp_2lis);

END ut_AIP_Sort_By_Key;

/***************************************************************************************************

ut_AIP_Sort_By_Value: Entry procedure for utPLSQL testing Col_Group.AIP_Sort_By_Value

***************************************************************************************************/
PROCEDURE ut_AIP_Sort_By_Value IS

  c_proc_name           CONSTANT VARCHAR2(61) := c_proc_name_value;
  c_exp_2lis            CONSTANT L2_chr_arr := L2_chr_arr (L1_chr_arr (Utils.List_Delim ('B','1'),
                                                                         Utils.List_Delim ('Cc','1'),
                                                                         Utils.List_Delim ('A','2')),
                                                             L1_chr_arr (Utils.List_Delim ('X','2'))
                                               );
BEGIN

  Do_Test (c_proc_name, c_exp_2lis);

END ut_AIP_Sort_By_Value;

END UT_Col_Group;
/
SHO ERR
