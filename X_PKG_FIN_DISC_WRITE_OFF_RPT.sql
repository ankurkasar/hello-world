CREATE OR REPLACE PACKAGE X_PKG_FIN_DISC_WRITE_OFF_RPT
AS
   /*******************************************************************************
    REM Module          : Pure Finance
    REM Client          : MNet
    REM File Name       : pkg_fin_dscworpt.sql
    REM Form Name       : Discretionary Write - Off Report
    REM Purpose         : Discretionary Write - Off Report
    REM Author          : Aditya Gupta
    REM Creation Date   : 26 Mar 2013
    REM Type            : Database Package
    REM Change History  :
    *******************************************************************************/

   TYPE c_dsc_wo_details IS REF CURSOR;


   --**************************************************************
   --This procedure generates Discretionary Write - Off Report
   --**************************************************************
   PROCEDURE prc_fin_dsc_wo_rpt (
      i_frm_date           IN     FID_LICENSE.LIC_END%TYPE,
      i_to_date            IN     FID_LICENSE.LIC_END%TYPE,
      i_chnl_comp          IN     FID_COMPANY.COM_SHORT_NAME%TYPE,
      i_lic_type           IN     FID_LICENSE.LIC_TYPE%TYPE,
      i_prg_type           IN     FID_LICENSE.LIC_BUDGET_CODE%TYPE,
      i_licensee           IN     FID_LICENSEE.LEE_SHORT_NAME%TYPE,
      i_supp_srt_name      IN     VARCHAR2,
      i_contract           IN     FID_CONTRACT.CON_NAME%TYPE,
      o_c_dsc_wo_details      OUT X_PKG_FIN_DISC_WRITE_OFF_RPT.c_dsc_wo_details);


   --**************************************************************
   --This procedure generates Discretionary Write - Off Excel
   --**************************************************************
   PROCEDURE prc_fin_dsc_wo_exl (
      i_frm_date           IN     FID_LICENSE.LIC_END%TYPE,
      i_to_date            IN     FID_LICENSE.LIC_END%TYPE,
      i_chnl_comp          IN     FID_COMPANY.COM_SHORT_NAME%TYPE,
      i_lic_type           IN     FID_LICENSE.LIC_TYPE%TYPE,
      i_prg_type           IN     FID_LICENSE.LIC_BUDGET_CODE%TYPE,
      i_licensee           IN     FID_LICENSEE.LEE_SHORT_NAME%TYPE,
      i_supp_srt_name      IN     VARCHAR2,
      i_contract           IN     FID_CONTRACT.CON_NAME%TYPE,
      o_c_dsc_wo_details      OUT X_PKG_FIN_DISC_WRITE_OFF_RPT.c_dsc_wo_details);
END X_PKG_FIN_DISC_WRITE_OFF_RPT;
/
CREATE OR REPLACE PACKAGE BODY X_PKG_FIN_DISC_WRITE_OFF_RPT
AS
   /*******************************************************************************
    REM Module          : Pure Finance
    REM Client          : MNet
    REM File Name       : pkg_fin_dscworpt.sql
    REM Form Name       : Discretionary Write - Off Report
    REM Purpose         : Discretionary Write - Off Report
    REM Author          : Aditya Gupta
    REM Creation Date   : 26 Mar 2013
    REM Type            : Database Package
    REM Change History  :
    *******************************************************************************/



   --**************************************************************
   --This procedure generates Discretionary Write - Off Report
   --**************************************************************
   PROCEDURE prc_fin_dsc_wo_rpt (
      i_frm_date           IN     FID_LICENSE.LIC_END%TYPE,
      i_to_date            IN     FID_LICENSE.LIC_END%TYPE,
      i_chnl_comp          IN     FID_COMPANY.COM_SHORT_NAME%TYPE,
      i_lic_type           IN     FID_LICENSE.LIC_TYPE%TYPE,
      i_prg_type           IN     FID_LICENSE.LIC_BUDGET_CODE%TYPE,
      i_licensee           IN     FID_LICENSEE.LEE_SHORT_NAME%TYPE,
      i_supp_srt_name      IN     VARCHAR2,
      i_contract           IN     FID_CONTRACT.CON_NAME%TYPE,
      o_c_dsc_wo_details      OUT X_PKG_FIN_DISC_WRITE_OFF_RPT.c_dsc_wo_details)
   AS
   BEGIN
      OPEN o_c_dsc_wo_details FOR
           SELECT territory,
                  Channel_Company,
                  License_Currency,
                  License_Type,
                  Licensee,
                  Program_Type,
                  Supplier_Name,
                  Contract_Name,
                  License_Number,
                  Program_Title,
                  Account_Date,
                  License_Start_Date,
                  License_End_Date,
                  License_Amort_Code,
                  Max_Date,
                  SUM (Cost_Written_Off) Cost_written_Off-- ,sum(Exchange_Rate) Exchange_Rate
                  ,
                  DECODE (
                     SUM (Cost_Written_Off),
                     0, 0,
                     ROUND (
                        (SUM (ZAR_Cost_Written_Off) / SUM (Cost_Written_Off)),
                        5))
                     Exchange_Rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  SUM (ZAR_Cost_Written_Off) ZAR_Cost_Written_Off
             FROM (SELECT (SELECT ter.ter_cur_code
                             FROM fid_territory ter, fid_company com
                            WHERE ter.ter_code = com.com_ter_code
                                  AND com.com_number = lee.lee_cha_com_number)
                             territory,
                          (SELECT COM_SHORT_NAME
                             FROM FID_COMPANY com,
                                  FID_LICENSE lic,
                                  FID_LICENSEE lee
                            WHERE     com.COM_NUMBER = LEE.LEE_CHA_COM_NUMBER
                                  AND lee.lee_number = lic.lic_lee_number
                                  AND lic.lic_number = fl.lic_number)
                             Channel_Company,
                          FL.LIC_CURRENCY License_Currency,
                          fl.LIC_TYPE License_Type,
                          lee.lee_short_name Licensee,
                          FL.LIC_BUDGET_CODE Program_Type,
                          FC.COM_SHORT_NAME Supplier_Name,
                          FCT.CON_SHORT_NAME Contract_Name,
                          FL.LIC_NUMBER License_Number,
                          FG.GEN_TITLE Program_Title,
                          FL.LIC_ACCT_DATE Account_Date,
                          FL.LIC_START License_Start_Date,
                          FL.LIC_END License_End_Date,
                          FL.LIC_AMORT_CODE License_Amort_Code,
                          (SELECT MAX (DWO_APPRVD_DATE)
                             FROM X_FIN_DISC_WRITE_OFF
                            WHERE DWO_LIC_NO = FL.LIC_NUMBER)
                             Max_Date,
                          ROUND (NVL (FSL.LIS_CON_WRITEOFF, 0), 2)
                             Cost_Written_Off,
                          --   round( nvl((nvl(FSL.LIS_LOC_WRITEOFF,0) / nvl(FSL.LIS_CON_WRITEOFF,0)),0) , 4) Exchange_Rate ,
                          ROUND (NVL (fsl.LIS_LOC_WRITEOFF, 0), 2)
                             ZAR_Cost_Written_Off
                     FROM FID_LICENSE fl,
                          fid_license_sub_ledger fsl,
                          fid_company fc,
                          fid_licensee lee,
                          fid_contract fct,
                          fid_general fg,
                          x_fin_lic_sec_lee slee,
                          x_fin_disc_write_off dwo
                    WHERE     fl.lic_number = slee.LSL_LIC_NUMBER
                          AND fl.lic_number = fsl.LIS_LIC_NUMBER
                          AND slee.lsl_number = fsl.LIS_Lsl_NUMBER
                          AND slee.LSL_LEE_NUMBER = lee.LEE_NUMBER
                          AND fl.LIC_GEN_REFNO = fg.GEN_REFNO
                          AND fl.LIC_CON_NUMBER = fct.CON_NUMBER
                          AND fct.CON_COM_NUMBER = fc.COM_NUMBER
                          AND fl.lic_number = dwo.DWO_LIC_NO
                          AND --Dev.R3: Start: Placeholder_[Devashish Raverkar]_[27-03-2014]
                              fl.lic_status <> 'T'
                          AND --Dev.R3: End:
                              fsl.LIS_PER_YEAR
                              || LPAD (fsl.LIS_PER_MONTH, 2, 0) BETWEEN TO_NUMBER (
                                                                           TO_CHAR (
                                                                              i_frm_date,
                                                                              'YYYYMM'))
                                                                    AND TO_NUMBER (
                                                                           TO_CHAR (
                                                                              i_to_date,
                                                                              'YYYYMM'))
                          AND NVL (fsl.LIS_CON_WRITEOFF, 0) <> 0
                          AND lee.LEE_SHORT_NAME LIKE i_licensee
                          AND fct.CON_SHORT_NAME LIKE i_contract
                          AND fc.com_short_name LIKE i_supp_srt_name
                          AND lee.lee_cha_com_number IN
                                 (SELECT COM_NUMBER
                                    FROM FID_COMPANY
                                   WHERE com_short_name LIKE i_chnl_comp)
                          AND fl.lic_type LIKE i_lic_type
                          AND fl.LIC_BUDGET_CODE LIKE i_prg_type
                          AND dwo.DWO_WRT_OFF_DATE =
                                 (SELECT MAX (DWO_WRT_OFF_DATE)
                                    FROM x_fin_disc_write_off
                                   WHERE DWO_LIC_NO = fl.lic_number))
         GROUP BY territory,
                  Channel_Company,
                  License_Currency,
                  License_Type,
                  Licensee,
                  Program_Type,
                  Supplier_Name,
                  Contract_Name,
                  License_Number,
                  Program_Title,
                  Account_Date,
                  License_Start_Date,
                  License_End_Date,
                  License_Amort_Code,
                  Max_Date
         ORDER BY Channel_Company,
                  License_Currency,
                  License_Type,
                  Licensee,
                  Program_Type,
                  Supplier_Name,
                  License_Number;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_fin_dsc_wo_rpt;



   --**************************************************************
   --This procedure generates Discretionary Write - Off Excel
   --**************************************************************
   PROCEDURE prc_fin_dsc_wo_exl (
      i_frm_date           IN     FID_LICENSE.LIC_END%TYPE,
      i_to_date            IN     FID_LICENSE.LIC_END%TYPE,
      i_chnl_comp          IN     FID_COMPANY.COM_SHORT_NAME%TYPE,
      i_lic_type           IN     FID_LICENSE.LIC_TYPE%TYPE,
      i_prg_type           IN     FID_LICENSE.LIC_BUDGET_CODE%TYPE,
      i_licensee           IN     FID_LICENSEE.LEE_SHORT_NAME%TYPE,
      i_supp_srt_name      IN     VARCHAR2,
      i_contract           IN     FID_CONTRACT.CON_NAME%TYPE,
      o_c_dsc_wo_details      OUT X_PKG_FIN_DISC_WRITE_OFF_RPT.c_dsc_wo_details)
   AS
   BEGIN
      OPEN o_c_dsc_wo_details FOR
           SELECT territory,
                  Channel_Company,
                  License_Currency,
                  License_Type,
                  Licensee,
                  Program_Type,
                  Supplier_Name,
                  Contract_Name,
                  License_Number,
                  Program_Title,
                  Account_Date,
                  License_Start_Date,
                  License_End_Date,
                  License_Amort_Code,
                  Max_Date,
                  SUM (Cost_Written_Off) Cost_written_Off-- ,sum(Exchange_Rate) Exchange_Rate
                  ,
                  DECODE (
                     SUM (Cost_Written_Off),
                     0, 0,
                     ROUND (
                        (SUM (ZAR_Cost_Written_Off) / SUM (Cost_Written_Off)),
                        5))
                     Exchange_Rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  SUM (ZAR_Cost_Written_Off) ZAR_Cost_Written_Off
             FROM (SELECT (SELECT ter.ter_cur_code
                             FROM fid_territory ter, fid_company com
                            WHERE ter.ter_code = com.com_ter_code
                                  AND com.com_number = lee.lee_cha_com_number)
                             territory,
                          (SELECT COM_SHORT_NAME
                             FROM FID_COMPANY com,
                                  FID_LICENSE lic,
                                  FID_LICENSEE lee
                            WHERE     com.COM_NUMBER = LEE.LEE_CHA_COM_NUMBER
                                  AND lee.lee_number = lic.lic_lee_number
                                  AND lic.lic_number = fl.lic_number)
                             Channel_Company,
                          FL.LIC_CURRENCY License_Currency,
                          fl.LIC_TYPE License_Type,
                          lee.lee_short_name Licensee,
                          FL.LIC_BUDGET_CODE Program_Type,
                          FC.COM_SHORT_NAME Supplier_Name,
                          FCT.CON_SHORT_NAME Contract_Name,
                          FL.LIC_NUMBER License_Number,
                          FG.GEN_TITLE Program_Title,
                          FL.LIC_ACCT_DATE Account_Date,
                          FL.LIC_START License_Start_Date,
                          FL.LIC_END License_End_Date,
                          FL.LIC_AMORT_CODE License_Amort_Code,
                          (SELECT MAX (DWO_APPRVD_DATE)
                             FROM X_FIN_DISC_WRITE_OFF
                            WHERE DWO_LIC_NO = FL.LIC_NUMBER)
                             Max_Date,
                          ROUND (NVL (FSL.LIS_CON_WRITEOFF, 0), 2)
                             Cost_Written_Off,
                          -- round( nvl((nvl(FSL.LIS_LOC_WRITEOFF,0) / nvl(FSL.LIS_CON_WRITEOFF,0)),0) , 4) Exchange_Rate ,
                          ROUND (NVL (fsl.LIS_LOC_WRITEOFF, 0), 2)
                             ZAR_Cost_Written_Off
                     FROM FID_LICENSE fl,
                          fid_license_sub_ledger fsl,
                          fid_company fc,
                          fid_licensee lee,
                          fid_contract fct,
                          fid_general fg,
                          x_fin_lic_sec_lee slee,
                          x_fin_disc_write_off dwo
                    WHERE     fl.lic_number = slee.LSL_LIC_NUMBER
                          AND fl.lic_number = fsl.LIS_LIC_NUMBER
                          AND slee.lsl_number = fsl.LIS_Lsl_NUMBER
                          AND slee.LSL_LEE_NUMBER = lee.LEE_NUMBER
                          AND fl.LIC_GEN_REFNO = fg.GEN_REFNO
                          AND fl.LIC_CON_NUMBER = fct.CON_NUMBER
                          AND fct.CON_COM_NUMBER = fc.COM_NUMBER
                          AND fl.lic_number = dwo.DWO_LIC_NO
                          AND fsl.LIS_PER_YEAR
                              || LPAD (fsl.LIS_PER_MONTH, 2, 0) BETWEEN TO_NUMBER (
                                                                           TO_CHAR (
                                                                              i_frm_date,
                                                                              'YYYYMM'))
                                                                    AND TO_NUMBER (
                                                                           TO_CHAR (
                                                                              i_to_date,
                                                                              'YYYYMM'))
                          AND NVL (fsl.LIS_CON_WRITEOFF, 0) <> 0
                          AND --Dev.R3: Start: Placeholder_[Devashish Raverkar]_[27-03-2014]
                              fl.lic_status <> 'T'
                          AND --Dev.R3: End:
                              lee.LEE_SHORT_NAME LIKE i_licensee
                          AND fct.CON_SHORT_NAME LIKE i_contract
                          AND fc.com_short_name LIKE i_supp_srt_name
                          AND lee.lee_cha_com_number IN
                                 (SELECT COM_NUMBER
                                    FROM FID_COMPANY
                                   WHERE com_short_name LIKE i_chnl_comp)
                          AND fl.lic_type LIKE i_lic_type
                          AND fl.LIC_BUDGET_CODE LIKE i_prg_type
                          AND dwo.DWO_WRT_OFF_DATE =
                                 (SELECT MAX (DWO_WRT_OFF_DATE)
                                    FROM x_fin_disc_write_off
                                   WHERE DWO_LIC_NO = fl.lic_number))
         GROUP BY territory,
                  Channel_Company,
                  License_Currency,
                  License_Type,
                  Licensee,
                  Program_Type,
                  Supplier_Name,
                  Contract_Name,
                  License_Number,
                  Program_Title,
                  Account_Date,
                  License_Start_Date,
                  License_End_Date,
                  License_Amort_Code,
                  Max_Date
         ORDER BY Channel_Company,
                  License_Currency,
                  License_Type,
                  Licensee,
                  Program_Type,
                  Supplier_Name,
                  License_Number;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_fin_dsc_wo_exl;
END X_PKG_FIN_DISC_WRITE_OFF_RPT;
/