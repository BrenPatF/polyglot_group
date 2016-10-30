CREATE OR REPLACE PACKAGE BODY TT_Col_Group AS
/***************************************************************************************************

Description: TRAPIT (TRansactional API Testing) package for Col_Group

Modification History
Who                  When        Which What
-------------------- ----------- ----- -------------------------------------------------------------
Brendan Furey        20-Oct-2016 1.0   Created.

***************************************************************************************************/

c_ms_limit              CONSTANT PLS_INTEGER := 2;
c_proc_name_asis        CONSTANT VARCHAR2(60) := 'Col_Group.tt_AIP_List_Asis';
c_proc_name_key         CONSTANT VARCHAR2(60) := 'Col_Group.tt_AIP_Sort_By_Key';
c_proc_name_value       CONSTANT VARCHAR2(60) := 'Col_Group.tt_AIP_Sort_By_vALUE';

c_file_2lis             CONSTANT L2_chr_arr := L2_chr_arr (
                                      L1_chr_arr ('0,1,Cc,3', '00,1,A,9', '000,1,B,27', '0000,1,A,81'),
                                      L1_chr_arr ('X;;1;;A', 'X;;1;;A')
);
c_prms_2lis             CONSTANT L2_chr_arr := L2_chr_arr (
                                      L1_chr_arr ('lines.csv', ',', '3'), L1_chr_arr ('lines.csv', ';;', '1')
);

c_scenario_lis          CONSTANT L1_chr_arr := L1_chr_arr ('Tie-break/single-delimiter/interior column', 'Two copies/double-delimiter/first column');
c_inp_group_lis         CONSTANT L1_chr_arr := L1_chr_arr ('Parameter', 'File');
c_inp_field_2lis        CONSTANT L2_chr_arr := L2_chr_arr (
                                      L1_chr_arr ('File Name', 'Delimiter', '*Column'),
                                      L1_chr_arr ('Line')
);
c_out_group_lis         CONSTANT L1_chr_arr := L1_chr_arr ('Sorted Array');
c_out_fields_2lis       CONSTANT L2_chr_arr := L2_chr_arr (L1_chr_arr ('Key', '*Count'));

/***************************************************************************************************

Do_Test: Main local procedure for TRAPIT testing Col_Group methods

***************************************************************************************************/

PROCEDURE Do_Test (p_proc_name VARCHAR2, p_exp_2lis L2_chr_arr, p_out_group_lis L1_chr_arr, p_out_fields_2lis L2_chr_arr) IS

  l_timer_set                      PLS_INTEGER;
  l_inp_3lis                       L3_chr_arr := L3_chr_arr();
  l_act_2lis                       L2_chr_arr := L2_chr_arr();

  /***************************************************************************************************

  Setup: Setup procedure for TRAPIT testing Col_Group package. Writes test file, then calls
         constructor API to store data in an array, line counts grouped by key

  ***************************************************************************************************/
  PROCEDURE Setup (p_file                 VARCHAR2,      -- file name
                   p_delim                VARCHAR2,      -- delimiter
                   p_colnum               PLS_INTEGER,   -- key column number in file
                   p_dat_lis              L1_chr_arr,    -- lines to write to test file
                   x_inp_2lis         OUT L2_chr_arr) IS -- generic inputs list

  BEGIN

    Utils.Delete_File (p_file);
    Utils.Write_File (p_file, p_dat_lis);

    x_inp_2lis := L2_chr_arr (L1_chr_arr (Utils.List_Delim (p_file, p_delim, p_colnum)),
                              p_dat_lis);

    Col_Group.AIP_Load_File (p_file => p_file, p_delim => p_delim, p_colnum => p_colnum);

  END Setup;

  /***************************************************************************************************

  Call_Proc: Calls the base method according to calling procedure, and converts record lists to 
             delimited form, and populates the actual list for later checking

  ***************************************************************************************************/
  PROCEDURE Call_Proc (x_act_lis   OUT L1_chr_arr) IS -- actual values list (delimited records)

    l_arr_lis           chr_int_arr;
    l_act_lis           L1_chr_arr := L1_chr_arr();
  BEGIN

    l_arr_lis := CASE p_proc_name
                   WHEN c_proc_name_asis        THEN Col_Group.AIP_List_Asis
                   WHEN c_proc_name_key         THEN Col_Group.AIP_Sort_By_Key
                   WHEN c_proc_name_value       THEN Col_Group.AIP_Sort_By_Value
                 END;
    Timer_Set.Increment_Time (l_timer_set, TT_Utils.c_call_timer);

    l_act_lis.EXTEND (l_arr_lis.COUNT);
    FOR i IN 1..l_arr_lis.COUNT LOOP

      l_act_lis(i) := Utils.List_Delim (l_arr_lis(i).chr_field, l_arr_lis(i).int_field);

    END LOOP;
    x_act_lis := CASE p_proc_name
                    WHEN c_proc_name_asis        THEN L1_chr_arr(l_arr_lis.COUNT)
                    ELSE                              l_act_lis
                  END;

  END Call_Proc;

BEGIN

  l_timer_set := TT_Utils.Init (p_proc_name);
  l_act_2lis.EXTEND (c_file_2lis.COUNT);
  l_inp_3lis.EXTEND (c_file_2lis.COUNT);

  FOR i IN 1..c_file_2lis.COUNT LOOP

    Setup (p_file              => c_prms_2lis(i)(1),
           p_delim             => c_prms_2lis(i)(2),
           p_colnum            => c_prms_2lis(i)(3),
           p_dat_lis           => c_file_2lis(i),    -- data file inputs 
           x_inp_2lis          => l_inp_3lis(i));
    Timer_Set.Increment_Time (l_timer_set, 'Setup');

    Call_Proc (l_act_2lis(i));

  END LOOP;

  TT_Utils.Check_TT_Results (p_proc_name, c_scenario_lis, l_inp_3lis, l_act_2lis, p_exp_2lis, l_timer_set, c_ms_limit,
                             c_inp_group_lis, c_inp_field_2lis, p_out_group_lis, p_out_fields_2lis);

END Do_Test;

/***************************************************************************************************

tt_AIP_List_Asis: Entry procedure for TRAPIT testing Col_Group.AIP_List_Asis

***************************************************************************************************/
PROCEDURE tt_AIP_List_Asis IS

  c_proc_name           CONSTANT VARCHAR2(61) := c_proc_name_asis;
  c_exp_2lis            CONSTANT L2_chr_arr := L2_chr_arr (L1_chr_arr('3'), L1_chr_arr('2'));
  c_out_group_lis       CONSTANT L1_chr_arr := L1_chr_arr ('Counts');
  c_out_fields_2lis     CONSTANT L2_chr_arr := L2_chr_arr (L1_chr_arr ('*#Records'));

BEGIN

  Do_Test (c_proc_name, c_exp_2lis, c_out_group_lis, c_out_fields_2lis);

END tt_AIP_List_Asis;

/***************************************************************************************************

tt_AIP_Sort_By_Key: Entry procedure for TRAPIT testing Col_Group.AIP_Sort_By_Key

***************************************************************************************************/
PROCEDURE tt_AIP_Sort_By_Key IS

  c_proc_name             CONSTANT VARCHAR2(61) := c_proc_name_key;
  c_exp_2lis              CONSTANT L2_chr_arr := L2_chr_arr (L1_chr_arr (Utils.List_Delim ('A','2'),
                                                                         Utils.List_Delim ('Bx','1'),
                                                                         Utils.List_Delim ('Cc','1')),
                                                             L1_chr_arr (Utils.List_Delim ('X','2'))
                                                 );
BEGIN

  Do_Test (c_proc_name, c_exp_2lis, c_out_group_lis, c_out_fields_2lis);

END tt_AIP_Sort_By_Key;

/***************************************************************************************************

tt_AIP_Sort_By_Value: Entry procedure for TRAPIT testing Col_Group.AIP_Sort_By_Value

***************************************************************************************************/
PROCEDURE tt_AIP_Sort_By_Value IS

  c_proc_name             CONSTANT VARCHAR2(61) := c_proc_name_value;
  c_exp_2lis              CONSTANT L2_chr_arr := L2_chr_arr (L1_chr_arr (Utils.List_Delim ('B','1'),
                                                                         Utils.List_Delim ('Cc','1'),
                                                                         Utils.List_Delim ('A','2')),
                                                             L1_chr_arr (Utils.List_Delim ('X','2'))
                                                 );
BEGIN

  Do_Test (c_proc_name, c_exp_2lis, c_out_group_lis, c_out_fields_2lis);

END tt_AIP_Sort_By_Value;

END TT_Col_Group;
/
SHO ERR
