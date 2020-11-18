CREATE OR REPLACE PACKAGE PKG_TVF_ROY_STMT_RPT
AS

 PROCEDURE prc_tvf_roy_stmt_dtls (
      i_report_type         IN       VARCHAR2,
      i_calculate_summary   IN       VARCHAR2,
      i_channel_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_number          IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name      IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name     IN       fid_company.com_short_name%TYPE,
      i_from_date           IN       DATE,
      i_to_date             IN       DATE,
      o_cursor              OUT      sys_refcursor
   );

PROCEDURE prc_tvf_roy_stmt_dtls_exl (
      i_channel_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_number          IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name      IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name     IN       fid_company.com_short_name%TYPE,
      i_from_date           IN       DATE,
      i_to_date             IN       DATE,
      o_cursor              OUT      sys_refcursor
   );

 --****************************************************************
-- This procedure outputs category of expired license.
-- REM Client - MNET
--****************************************************************
    FUNCTION get_category (
      i_lic_n_bo_category   IN   NUMBER,
      i_lic_number          IN   VARCHAR2
   )
      RETURN VARCHAR2;

     --****************************************************************
-- This function outputs spot rate for a particular date.
-- REM Client - MNET
--****************************************************************
   FUNCTION fun_tvf_spot_rate (
      fromcurr   IN   VARCHAR2,
      tocurr     IN   VARCHAR2,
      ondate     IN   DATE
   ) RETURN NUMBER;

    --****************************************************************
-- This procedure outputs total fees of  expired license.
-- REM Client - MNET
--****************************************************************
FUNCTION get_total_fees
(
      i_lic_number           IN   tbl_tva_license.lic_v_number%TYPE,
      i_from_date            IN   DATE,
      i_to_date              IN   DATE
)RETURN NUMBER;

   --****************************************************************
-- This function outputs number of buys correspoinding to license.
-- REM Client - MNET
--****************************************************************
   FUNCTION get_total_buys (
      i_lic_number           IN   tbl_tva_license.lic_v_number%TYPE,
      i_licb_v_format_code   IN   tbl_tvf_lic_buys.licb_v_format_code%TYPE,
      i_from_date            IN   DATE,
      i_to_date              IN   DATE
   ) RETURN NUMBER;

     FUNCTION GET_SCHEDULED_DAYS
   (
       i_lic_number             IN          tbl_tva_license.lic_v_number%TYPE,
       i_from_date              IN          DATE,
       i_to_date                 IN          DATE
   )RETURN NUMBER;

   --****************************************************************
-- This procedure outputs actual net price of license.
-- REM Client - MNET
--****************************************************************
   FUNCTION get_actual_net_price
  (
     i_price          IN      NUMBER,
     i_territory      IN      VARCHAR2
  )RETURN NUMBER;


PROCEDURE prc_tvf_roy_stmt_summary
    (
      i_report_type         IN       VARCHAR2,
      i_channel_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_number          IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name      IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name     IN       fid_company.com_short_name%TYPE,
      i_from_date           IN       DATE,
      i_to_date             IN       DATE,
      o_cursor              OUT      sys_refcursor
   );

 PROCEDURE prc_tvf_roy_stmt_summary_exl
    (
      i_channel_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_number          IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name      IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name     IN       fid_company.com_short_name%TYPE,
      i_from_date           IN       DATE,
      i_to_date             IN       DATE,
      o_cursor              OUT      sys_refcursor
   );

  --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[13-Jun-2013]
      function  GET_AP_EXCH_RATE
      (
      I_LIC_NUMBER in varchar2,
      I_DATE IN DATE
      )  RETURN NUMBER;

       FUNCTION  GET_DP_EXCH_RATE
      (
      I_LIC_NUMBER IN VARCHAR2
      ) RETURN NUMBER;

      -----------------------------------------------------------
     FUNCTION valid_no_rate (no_rate_date DATE)
      RETURN NUMBER;
      -----------------------------------------------------------

      FUNCTION get_spot_rate (
      fromcurr            IN   VARCHAR2,
      tocurr              IN   VARCHAR2,
      ondate              IN   DATE,
      i_spo_n_srs_id      IN   tbl_tvf_spot_rate.spo_n_srs_id%TYPE,
      i_dp_ap_conv_rule   IN   NUMBER
   )
      RETURN NUMBER;

  ----Dev3: TVOD_CR: END :[TVOD_CR]


END PKG_TVF_ROY_STMT_RPT;
/
CREATE OR REPLACE PACKAGE BODY PKG_TVF_ROY_STMT_RPT
AS
/******************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         02-Nov-2016       Zeshan Khan                 Business Req.-
                                                          1. Business wants to get all the spot rates upto 5 decimal places instead of 4.
*******************************************************************************************************************************************/
   PROCEDURE PRC_TVF_ROY_STMT_DTLS
   (
      i_report_type         IN       VARCHAR2,
      i_calculate_summary   IN       VARCHAR2,
      i_channel_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_number          IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name      IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name     IN       fid_company.com_short_name%TYPE,
      i_from_date           IN       DATE,
      i_to_date             IN       DATE,
      o_cursor              OUT      sys_refcursor
   )
   AS
   BEGIN
      OPEN o_cursor FOR
         SELECT   cc.com_name channel_company,
                  LIC.LIC_V_CURRENCY LIC_CURRENCY,
                  FEE.LICF_V_LIC_NUMBER LIC_NUMBER, LT.DEAL_TYPE LIC_TYPE,
                  supp.com_short_name supplier,
                  con.con_v_short_name contract, gen.gen_title programme,
                  TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy') start_date,
                  TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') end_date,
                  TO_CHAR (lic.lic_dt_lvr, 'dd-Mon-yyyy') lvr_date,
                  lic.lic_n_day_post_lvr days,
                  LIC.LIC_N_REVENUE_SHARE_PERCENT SHARE_PERCENTAGE,
                  lic.lic_v_formats lic_format, cat.boc_v_category "category",
                  FORMULA.TVOD_V_FEE_FORMULA_SHORT_NAME FEE_FORMULA,
                  --lic.LIC_N_SPOT_RATE exch_rate_avail_date,
                  fee.licf_v_ter_name terr, fee.licf_v_format_code format,
                  FEE.LICF_V_MEDIA_TYPE MEDIA_TYPE,
                  fee.licf_v_sp_curr_code selling_price_curr,
                  ROUND (FEE.LICF_N_SELLING_PRICE, 2) SELLING_PRICE,
                  ROUND (fee.licf_n_actual_price, 2) actual_price,
                  DECODE(fee.licf_v_format_code,'HD',ROUND (lic.lic_n_dp_zar_hd, 2),ROUND (lic.lic_n_dp_zar_sd, 2)) "deemed_zar",
                  DECODE(FEE.LICF_V_FORMAT_CODE,'HD',ROUND (LIC.LIC_N_DP_USD_HD, 2),ROUND (LIC.LIC_N_DP_USD_SD, 2)) "deemed_usd",
                  ROUND (SUM (NVL (FEE.LICF_N_NO_OF_BUYS, 0)), 2) NO_OF_BUYS,
                  ROUND (SUM (NVL (FEE.LICF_N_FEE, 0)), 2) TOTAL_FEES,
            --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[11-Jun-2013]
               /* TO_CHAR (fee.licf_dt_date, 'MON') "month",
                  TO_NUMBER (TO_CHAR (TO_DATE (fee.licf_dt_date,
                                               'dd-mon-yyyy'),
                                      'MM'
                                     )
                            ) MONTH_M,
                  TO_CHAR (fee.licf_dt_date, 'YYYY') "year",*/
                   TO_CHAR (FEE.LICF_DT_DATE,'dd-Mon-yyyy') BUYS_DATE,
                    ROUND (FEE.LICF_N_AP_FEE, 2) ACTUAL_FEE,
                  ROUND(PKG_TVF_ROY_STMT_RPT.GET_AP_EXCH_RATE(LIC_V_NUMBER,FEE.LICF_DT_DATE),5) "Actual_price_ex_rate",-- [Ver 0.1]
                  NVL(DECODE(CON_N_FEE_FORMULA_NUMBER,
                         3,0,
                         4,0,
                         ROUND(FEE.LICF_N_DP_FEE,2)),0) "Deemed_Fee",
                NVL(DECODE(CON_N_FEE_FORMULA_NUMBER,
                         3,0,
                         4,0,
                         ROUND(PKG_TVF_ROY_STMT_RPT.GET_DP_EXCH_RATE(LIC_V_NUMBER),5)-- [Ver 0.1]
                       ),0) "Deemed_price_ex_rate"
            --Dev3: TVOD_CR: END :[TVOD_CR]
             FROM tbl_tvf_lic_fees fee,
                  TBL_TVA_LICENSE LIC,
                  fid_company cc,
                  tvod_licensee lee,
                  fid_general gen,
                  tvod_deal_memo_type lt,
                  TBL_TVA_CONTRACT CON,
                  fid_company supp,
                  TVOD_BOXOFFICE_CATEGORY CAT,
                  tvod_license_fee_formula formula
            WHERE UPPER (cc.com_short_name) LIKE UPPER (i_channel_comp)
              AND UPPER (supp.com_short_name) LIKE UPPER (i_supp_short_name)
              AND UPPER (con.con_v_short_name) LIKE UPPER (i_con_short_name)
              AND UPPER (fee.licf_v_lic_number) LIKE UPPER (i_lic_number)
              AND cc.com_number = lee.tvod_n_lee_cha_com_number
              and LEE.TVOD_N_LEE_NUMBER = LIC.LIC_N_LEE_NUMBER
              and LIC.LIC_V_NUMBER = FEE.LICF_V_LIC_NUMBER
              AND gen.gen_refno = lic.lic_n_gen_refno
              AND lt.dm_type_id = lic.lic_n_dm_type
              AND con.con_n_contract_number = lic.lic_n_con_number
              AND supp.com_number = con.con_n_supp_com_number
              --Dev3: TVOD_CR: Start:[TVOD_CR]_[Krutarth P. Patel]_[08-Jul-2013]
              AND cat.BOC_V_CATEGORY = lic.lic_n_bo_category
              --Dev3: TVOD_CR: END :[TVOD_CR]
              and FORMULA.TVOD_N_LIC_FEE_FORMULA_NUMBER = LIC.LIC_N_FEE_FORMULA_NUMBER
              AND FEE.LICF_DT_DATE BETWEEN I_FROM_DATE AND I_TO_DATE
       GROUP BY CC.COM_NAME, LIC.LIC_V_CURRENCY, FEE.LICF_V_LIC_NUMBER, LT.DEAL_TYPE, SUPP.COM_SHORT_NAME, CON.CON_V_SHORT_NAME, GEN.GEN_TITLE, TO_CHAR (LIC.LIC_DT_START_DATE, 'dd-Mon-yyyy'), TO_CHAR (LIC.LIC_DT_END_DATE, 'dd-Mon-yyyy'), TO_CHAR (LIC.LIC_DT_LVR, 'dd-Mon-yyyy'), LIC.LIC_N_DAY_POST_LVR, LIC.LIC_N_REVENUE_SHARE_PERCENT, LIC.LIC_V_FORMATS, CAT.BOC_V_CATEGORY, FORMULA.TVOD_V_FEE_FORMULA_SHORT_NAME, FEE.LICF_V_TER_NAME, FEE.LICF_V_FORMAT_CODE, FEE.LICF_V_MEDIA_TYPE, FEE.LICF_V_SP_CURR_CODE, ROUND (FEE.LICF_N_SELLING_PRICE, 2), ROUND (FEE.LICF_N_ACTUAL_PRICE, 2), DECODE(FEE.LICF_V_FORMAT_CODE,'HD',ROUND (LIC.LIC_N_DP_ZAR_HD, 2),ROUND (LIC.LIC_N_DP_ZAR_SD, 2)), DECODE(FEE.LICF_V_FORMAT_CODE,'HD',ROUND (LIC.LIC_N_DP_USD_HD, 2),ROUND (LIC.LIC_N_DP_USD_SD, 2)), TO_CHAR (FEE.LICF_DT_DATE,'dd-Mon-yyyy'), ROUND (FEE.LICF_N_AP_FEE, 2), ROUND(PKG_TVF_ROY_STMT_RPT.GET_AP_EXCH_RATE(LIC_V_NUMBER,FEE.LICF_DT_DATE),5), DECODE(CON_N_FEE_FORMULA_NUMBER,-- [Ver 0.1]
                         3,0,
                         4,0,
                         ROUND(FEE.LICF_N_DP_FEE,2)), DECODE(CON_N_FEE_FORMULA_NUMBER,
                         3,0,
                         4,0,
                         ROUND(PKG_TVF_ROY_STMT_RPT.GET_DP_EXCH_RATE(LIC_V_NUMBER),5)-- [Ver 0.1]
                       )

        /*GROUP BY cc.com_name,
                  lic.lic_v_currency,
                  fee.licf_v_lic_number,
                  lt.deal_type,
                  supp.com_short_name,
                  con.con_v_short_name,
                  gen.gen_title,
                  TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy'),
                  TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy'),
                  TO_CHAR (lic.lic_dt_lvr, 'dd-Mon-yyyy'),
                  lic.lic_n_day_post_lvr,
                  lic.lic_n_revenue_share_percent,
                  lic.lic_v_formats,
                  cat.boc_v_category,
                  formula.tvod_v_fee_formula_short_name,
                  lic.LIC_N_SPOT_RATE,
                  fee.licf_v_ter_name,
                  fee.licf_v_format_code,
                  fee.licf_v_media_type,
                  TO_CHAR (fee.licf_dt_date, 'MON'),
                  TO_NUMBER (TO_CHAR (TO_DATE ('1-feb-2012', 'dd-mon-yyyy'),
                                      'MM'
                                     )
                            ),
                  TO_CHAR (fee.licf_dt_date, 'YYYY'),
                  fee.licf_v_sp_curr_code,
                  ROUND (fee.licf_n_selling_price, 2),
                  ROUND (fee.licf_n_actual_price, 2),
                  ROUND (lic.lic_n_dp_zar_hd, 2),
                  ROUND (lic.lic_n_dp_usd_hd, 2),
                  ROUND (lic.lic_n_dp_zar_sd, 2),
                  ROUND (lic.lic_n_dp_usd_sd, 2),
                  TO_NUMBER (TO_CHAR (TO_DATE (fee.licf_dt_date,
                                               'dd-mon-yyyy'),
                                      'MM'
                                     )
                            )*/
        ORDER BY cc.com_name,
                  lic.lic_v_currency,
                  lt.deal_type,
                  SUPP.COM_SHORT_NAME,
                  CON.CON_V_SHORT_NAME,
                  GEN.GEN_TITLE;
  /* EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));*/
   END prc_tvf_roy_stmt_dtls;

   PROCEDURE prc_tvf_roy_stmt_dtls_exl (
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      i_lic_number        IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name    IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_cursor            OUT      sys_refcursor
   )
   AS
   BEGIN
      OPEN o_cursor FOR
         SELECT   cc.com_name "Channel Company",
                  lic.lic_v_currency "License Currency",
                  fee.licf_v_lic_number "License Number",
                  lt.deal_type "License Type",
                  supp.com_short_name "Supplier",
                  con.con_v_short_name "Contract", gen.gen_title "Programme",
                  TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy') "Start Date",
                  TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') "End Date",
                  TO_CHAR (lic.lic_dt_lvr, 'dd-Mon-yyyy') "LVR Date",
                  lic.lic_n_day_post_lvr "Days",
                  lic.lic_n_revenue_share_percent "Share percentage",
                  lic.lic_v_formats "License Format",
                  cat.boc_v_category "Category",
                  formula.tvod_v_fee_formula_short_name "Fee Formula",
                  lic.LIC_N_SPOT_RATE "Exch rate avail date",
                  fee.licf_v_ter_name "Territory",
                  fee.licf_v_format_code "Format",
                  fee.licf_v_media_type "Media Type",
                  fee.licf_v_sp_curr_code "Selling price currency",
                  ROUND (FEE.LICF_N_SELLING_PRICE, 2) "Selling price",
                  ROUND (fee.licf_n_actual_price, 2) "Actual price",
                  DECODE(fee.licf_v_format_code,'HD',ROUND (lic.lic_n_dp_zar_hd, 2),ROUND (lic.lic_n_dp_zar_sd, 2)) "Deemed ZAR",
                  DECODE(fee.licf_v_format_code,'HD',ROUND (lic.lic_n_dp_usd_hd, 2),ROUND (lic.lic_n_dp_usd_sd, 2)) "Deemed USD",
                  ROUND (SUM (NVL (fee.licf_n_no_of_buys, 0)),
                         2) "No of buys",
                  ROUND (SUM (NVL (FEE.LICF_N_FEE, 0)), 2) "Total fees",
            --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[11-Jun-2013]
                   /*    TO_CHAR (fee.licf_dt_date, 'MON') "month",
                  TO_CHAR (fee.licf_dt_date, 'YYYY') "year",*/
                  TO_CHAR (FEE.LICF_DT_DATE,'dd-Mon-yyyy') BUYS_DATE,
                   ROUND (FEE.LICF_N_AP_FEE, 2) "Actual_fee",
                  ROUND(PKG_TVF_ROY_STMT_RPT.GET_AP_EXCH_RATE(LIC_V_NUMBER,FEE.LICF_DT_DATE),5) "Actual_price_ex_rate",-- [Ver 0.1]
                  DECODE(CON_N_FEE_FORMULA_NUMBER,
                         3,0,
                         4,0,
                         round(FEE.LICF_N_DP_FEE,2)) "Deemed_Fee",
                DECODE(CON_N_FEE_FORMULA_NUMBER,
                         3,0,
                         4,0,
                         ROUND(PKG_TVF_ROY_STMT_RPT.GET_DP_EXCH_RATE(LIC_V_NUMBER),5)-- [Ver 0.1]
                       ) "Deemed_price_ex_rate"
            --Dev3: TVOD_CR: END :[TVOD_CR]
                --  I_FROM_DATE "From date",
                --  i_to_date "To date"
             FROM tbl_tvf_lic_fees fee,
                  TBL_TVA_LICENSE LIC,
                  fid_company cc,
                  tvod_licensee lee,
                  fid_general gen,
                  tvod_deal_memo_type lt,
                  tbl_tva_contract con,
                  fid_company supp,
                  tvod_boxoffice_category cat,
                  tvod_license_fee_formula formula
            WHERE UPPER (cc.com_short_name) LIKE UPPER (i_channel_comp)
              AND UPPER (supp.com_short_name) LIKE UPPER (i_supp_short_name)
              AND UPPER (con.con_v_short_name) LIKE UPPER (i_con_short_name)
              AND UPPER (fee.licf_v_lic_number) LIKE UPPER (i_lic_number)
              AND cc.com_number = lee.tvod_n_lee_cha_com_number
              AND lee.tvod_n_lee_number = lic.lic_n_lee_number
              AND lic.lic_v_number = fee.licf_v_lic_number
              AND gen.gen_refno = lic.lic_n_gen_refno
              AND lt.dm_type_id = lic.lic_n_dm_type
              AND con.con_n_contract_number = lic.lic_n_con_number
              AND supp.com_number = con.con_n_supp_com_number
              --Dev3: TVOD_CR: Start:[TVOD_CR]_[Krutarth P. Patel]_[08-Jul-2013]
              AND cat.BOC_V_CATEGORY = lic.lic_n_bo_category
              --Dev3: TVOD_CR: END :[TVOD_CR]
              AND formula.tvod_n_lic_fee_formula_number = lic.lic_n_fee_formula_number
              and FEE.LICF_DT_DATE between I_FROM_DATE and I_TO_DATE
      GROUP BY cc.com_name, lic.lic_v_currency, fee.licf_v_lic_number, lt.deal_type, supp.com_short_name, con.con_v_short_name, gen.gen_title, TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy'), TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy'), TO_CHAR (lic.lic_dt_lvr, 'dd-Mon-yyyy'), lic.lic_n_day_post_lvr, lic.lic_n_revenue_share_percent, lic.lic_v_formats, cat.boc_v_category, formula.tvod_v_fee_formula_short_name, lic.LIC_N_SPOT_RATE, fee.licf_v_ter_name, fee.licf_v_format_code, fee.licf_v_media_type, fee.licf_v_sp_curr_code, ROUND (FEE.LICF_N_SELLING_PRICE, 2), ROUND (fee.licf_n_actual_price, 2), DECODE(fee.licf_v_format_code,'HD',ROUND (lic.lic_n_dp_zar_hd, 2),ROUND (lic.lic_n_dp_zar_sd, 2)), DECODE(fee.licf_v_format_code,'HD',ROUND (lic.lic_n_dp_usd_hd, 2),ROUND (lic.lic_n_dp_usd_sd, 2)), TO_CHAR (FEE.LICF_DT_DATE,'dd-Mon-yyyy'), ROUND (FEE.LICF_N_AP_FEE, 2), ROUND(PKG_TVF_ROY_STMT_RPT.GET_AP_EXCH_RATE(LIC_V_NUMBER,FEE.LICF_DT_DATE),5), DECODE(CON_N_FEE_FORMULA_NUMBER,-- [Ver 0.1]
                         3,0,
                         4,0,
                         round(FEE.LICF_N_DP_FEE,2)), DECODE(CON_N_FEE_FORMULA_NUMBER,
                         3,0,
                         4,0,
                         ROUND(PKG_TVF_ROY_STMT_RPT.GET_DP_EXCH_RATE(LIC_V_NUMBER),5)-- [Ver 0.1]
                       )
         ORDER BY cc.com_name,
                  lic.lic_v_currency,
                  lt.deal_type,
                  supp.com_short_name,
                  con.con_v_short_name,
                  gen.gen_title;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
   END PRC_TVF_ROY_STMT_DTLS_EXL;

   PROCEDURE PRC_TVF_ROY_STMT_SUMMARY
   (
      i_report_type       IN       VARCHAR2,
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      i_lic_number        IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name    IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_cursor            OUT      sys_refcursor
   )
   AS
   BEGIN
      OPEN o_cursor FOR
        SELECT  channel_company,
        lic_currency,
        lic_type,
        supplier,
        contract,
        lic#,
        programme,
        start_date,
        end_date,
        share_percentage,
        month#,
        year#,
        MONTH_M,
        --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
        ACTUAL_FEE,
        deemed_fee,
        --Dev3: TVOD_CR: END :[TVOD_CR]
        total_fees,
        no_of_buys,
        MG,
        ROUND(((SELECT SUM(NVL (fees.lictf_n_total_fees, 0))
                        FROM tbl_tvf_lic_totel_fees fees
                      WHERE fees.LICTF_V_LIC_NUMBER = lic#
                        AND fees.lictf_n_year || LPAD (fees.lictf_n_month, 2, 0) <=
                          YEAR# || LPAD (MONTH_M, 2, 0)
                ) - MG ), 2) Overage
  FROM (
          SELECT   cc.com_name channel_company,
                  lic.lic_v_currency lic_currency, lt.deal_type lic_type,
                  supp.com_short_name supplier,
                  con.con_v_short_name contract,
                  tfee.lictf_v_lic_number lic#, gen.gen_title programme,
                  TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy') start_date,
                  TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') end_date,
                  lic.lic_n_revenue_share_percent share_percentage,
                  TO_CHAR (fee.licf_dt_date, 'MON') month#,
                  TO_CHAR (fee.licf_dt_date, 'YYYY') year#,
                  TO_NUMBER (TO_CHAR (TO_DATE (fee.licf_dt_date,
                                               'dd-mon-yyyy'),
                                      'MM'
                                     )
                            ) MONTH_M,
                 --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
                  ROUND(LICF_N_AP_FEE,2) ACTUAL_FEE,
                  round(LICF_N_DP_FEE,2) deemed_fee,
                --Dev3: TVOD_CR: END :[TVOD_CR]
                  round(tfee.lictf_n_total_fees,2) total_fees,
                  SUM (FEE.LICF_N_NO_OF_BUYS) NO_OF_BUYS,
                  round(lic.lic_n_price,2) MG
             FROM tbl_tvf_lic_totel_fees tfee,
                  tbl_tvf_lic_fees fee,
                  tbl_tva_license lic,
                  fid_company cc,
                  tvod_licensee lee,
                  fid_general gen,
                  tvod_deal_memo_type lt,
                  tbl_tva_contract con,
                  fid_company supp
            WHERE UPPER (cc.com_short_name) LIKE UPPER (i_channel_comp)
              AND UPPER (supp.com_short_name) LIKE UPPER (i_supp_short_name)
              AND UPPER (con.con_v_short_name) LIKE UPPER (i_con_short_name)
              AND UPPER (fee.licf_v_lic_number) LIKE UPPER (i_lic_number)
              AND fee.licf_n_cal_month = tfee.lictf_n_month
              AND fee.licf_n_cal_year = tfee.lictf_n_year
              AND fee.LICF_V_LIC_NUMBER =  tfee.lictf_v_lic_number
              AND lic.lic_v_number = tfee.lictf_v_lic_number
              AND cc.com_number = lee.tvod_n_lee_cha_com_number
              AND lee.tvod_n_lee_number = lic.lic_n_lee_number
              AND lt.dm_type_id = lic.lic_n_dm_type
              AND con.con_n_contract_number = lic.lic_n_con_number
              AND supp.com_number = con.con_n_supp_com_number
              AND gen.gen_refno = lic.lic_n_gen_refno
              -- Commented by Ajit AND tfee.lictf_n_year || LPAD (tfee.lictf_n_month, 2, 0) >=
                --                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
              AND tfee.lictf_n_year || LPAD (tfee.lictf_n_month, 2, 0) <=
                                     TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
              AND lic.LIC_DT_END_DATE >= i_to_date
         GROUP BY cc.com_name, lic.lic_v_currency, lt.deal_type, supp.com_short_name, con.con_v_short_name, tfee.lictf_v_lic_number, gen.gen_title, TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy'), TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy'), lic.lic_n_revenue_share_percent, TO_CHAR (fee.licf_dt_date, 'MON'), TO_CHAR (fee.licf_dt_date, 'YYYY'), TO_NUMBER (TO_CHAR (TO_DATE (fee.licf_dt_date,
                                               'dd-mon-yyyy'),
                                      'MM'
                                     )
                            ), ROUND(LICF_N_AP_FEE,2), round(LICF_N_DP_FEE,2), round(tfee.lictf_n_total_fees,2), round(lic.lic_n_price,2)
      ) ORDER BY channel_company,
                lic_currency,
                lic_type,
                supplier,
                contract,
                programme,
                year#,
                month_m;

        /* SELECT   cc.com_name channel_company,
                  lic.lic_v_currency lic_currency, lt.deal_type lic_type,
                  supp.com_short_name supplier,
                  con.con_v_short_name contract,
                  tfee.lictf_v_lic_number lic#, gen.gen_title programme,
                  TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy') start_date,
                  TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') end_date,
                  lic.lic_n_revenue_share_percent share_percentage,
                  TO_CHAR (fee.licf_dt_date, 'MON') month#,
                  TO_CHAR (fee.licf_dt_date, 'YYYY') year#,
                  TO_NUMBER (TO_CHAR (TO_DATE (fee.licf_dt_date,
                                               'dd-mon-yyyy'),
                                      'MM'
                                     )
                            ) month_m,
                  tfee.lictf_n_total_fees total_fees,
                  SUM (fee.licf_n_no_of_buys) no_of_buys,
                  lic.lic_n_price MG,
                  --ROUND( tfee.lictf_n_total_fees - lic.lic_n_price ,2 ) Overage
                  -- Added by Ajit
                  ROUND((SELECT SUM(NVL (fees.lictf_n_total_fees, 0))
                        FROM tbl_tvf_lic_totel_fees fees
                      WHERE fees.LICTF_V_LIC_NUMBER = '148-T'
                        AND fees.lictf_n_year || LPAD (fees.lictf_n_month, 2, 0) <=
                          TO_NUMBER(TO_CHAR (fee.licf_dt_date, 'YYYY') || LPAD (TO_CHAR (fee.licf_dt_date, 'MM'), 2, 0))
                  ) - lic_n_price , 2) Overage
             FROM tbl_tvf_lic_totel_fees tfee,
                  tbl_tvf_lic_fees fee,
                  tbl_tva_license lic,
                  fid_company cc,
                  tvod_licensee lee,
                  fid_general gen,
                  tvod_deal_memo_type lt,
                  tbl_tva_contract con,
                  fid_company supp
            WHERE UPPER (cc.com_short_name) LIKE UPPER (i_channel_comp)
              AND UPPER (supp.com_short_name) LIKE UPPER (i_supp_short_name)
              AND UPPER (con.con_v_short_name) LIKE UPPER (i_con_short_name)
              AND UPPER (fee.licf_v_lic_number) LIKE UPPER (i_lic_number)
              AND fee.licf_n_cal_month = tfee.lictf_n_month
              AND fee.licf_n_cal_year = tfee.lictf_n_year
              AND fee.LICF_V_LIC_NUMBER =  tfee.lictf_v_lic_number
              AND lic.lic_v_number = tfee.lictf_v_lic_number
              AND cc.com_number = lee.tvod_n_lee_cha_com_number
              AND lee.tvod_n_lee_number = lic.lic_n_lee_number
              AND lt.dm_type_id = lic.lic_n_dm_type
              AND con.con_n_contract_number = lic.lic_n_con_number
              AND supp.com_number = con.con_n_supp_com_number
              AND gen.gen_refno = lic.lic_n_gen_refno
              -- Commented by Ajit AND tfee.lictf_n_year || LPAD (tfee.lictf_n_month, 2, 0) >=
                --                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
              AND tfee.lictf_n_year || LPAD (tfee.lictf_n_month, 2, 0) <=
                                     TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
         group by cc.com_name, lic.lic_v_currency, lt.deal_type,
         supp.com_short_name, con.con_v_short_name, tfee.lictf_v_lic_number,
         gen.gen_title, TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy'),
         TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy'), lic.lic_n_revenue_share_percent,
         TO_CHAR (fee.licf_dt_date, 'MON'), TO_CHAR (fee.licf_dt_date, 'YYYY'),
         TO_NUMBER (TO_CHAR (TO_DATE (fee.licf_dt_date,
                                               'dd-mon-yyyy'),
                                      'MM'
                                     )
                            ),
          tfee.lictf_n_total_fees, lic.lic_n_price
         ORDER BY cc.com_name,
                  lic.lic_v_currency,
                  lt.deal_type,
                  supp.com_short_name,
                  con.con_v_short_name,
                  gen.gen_title; */
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
   END prc_tvf_roy_stmt_summary;

   PROCEDURE prc_tvf_roy_stmt_summary_exl (
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      i_lic_number        IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name    IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_cursor            OUT      sys_refcursor
   )
   AS
   BEGIN
      OPEN o_cursor FOR
        SELECT  channel_company as "Channel Company",
        lic_currency as "License Currency",
        lic_type as "License Type",
        supplier "Supplier",
        contract "Contract",
        lic# "License",
        programme "Programme",
        start_date "Start Date",
        end_date "End Date",
        share_percentage "Share Percentage",
        month# "Month",
        year# "Year",
        MONTH_M,
        --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
        ACTUAL_FEE "Actual Fees For Month",
        DEEMED_FEE "Deemed Fees For Month",
        --Dev3: TVOD_CR: END :[TVOD_CR]
        total_fees "Total Fees",
        no_of_buys "No of Buys",
        MG,
        ROUND(((SELECT SUM(NVL (fees.lictf_n_total_fees, 0))
                        FROM tbl_tvf_lic_totel_fees fees
                      WHERE fees.LICTF_V_LIC_NUMBER = lic#
                        AND fees.lictf_n_year || LPAD (fees.lictf_n_month, 2, 0) <=
                          year# || LPAD (month_m, 2, 0)
        ) - MG ), 2) Overage
  FROM (
          SELECT   cc.com_name channel_company,
                  lic.lic_v_currency lic_currency, lt.deal_type lic_type,
                  supp.com_short_name supplier,
                  con.con_v_short_name contract,
                  tfee.lictf_v_lic_number lic#, gen.gen_title programme,
                  TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy') start_date,
                  TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') end_date,
                  lic.lic_n_revenue_share_percent share_percentage,
                  TO_CHAR (fee.licf_dt_date, 'MON') month#,
                  TO_CHAR (fee.licf_dt_date, 'YYYY') year#,
                  TO_NUMBER (TO_CHAR (TO_DATE (fee.licf_dt_date,
                                               'dd-mon-yyyy'),
                                      'MM'
                                     )
                            ) MONTH_M,
                --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
                  ROUND(LICF_N_AP_FEE,2) ACTUAL_FEE,
                  round(LICF_N_DP_FEE,2) deemed_fee,
                --Dev3: TVOD_CR: END :[TVOD_CR]
                  round(tfee.lictf_n_total_fees,2) total_fees,
                  SUM (FEE.LICF_N_NO_OF_BUYS) NO_OF_BUYS,
                  round(lic.lic_n_price,2) MG
             FROM tbl_tvf_lic_totel_fees tfee,
                  tbl_tvf_lic_fees fee,
                  tbl_tva_license lic,
                  fid_company cc,
                  tvod_licensee lee,
                  fid_general gen,
                  tvod_deal_memo_type lt,
                  tbl_tva_contract con,
                  fid_company supp
            WHERE UPPER (cc.com_short_name) LIKE UPPER (i_channel_comp)
              AND UPPER (supp.com_short_name) LIKE UPPER (i_supp_short_name)
              AND UPPER (con.con_v_short_name) LIKE UPPER (i_con_short_name)
              AND UPPER (fee.licf_v_lic_number) LIKE UPPER (i_lic_number)
              AND fee.licf_n_cal_month = tfee.lictf_n_month
              AND fee.licf_n_cal_year = tfee.lictf_n_year
              AND fee.LICF_V_LIC_NUMBER =  tfee.lictf_v_lic_number
              AND lic.lic_v_number = tfee.lictf_v_lic_number
              AND cc.com_number = lee.tvod_n_lee_cha_com_number
              AND lee.tvod_n_lee_number = lic.lic_n_lee_number
              AND lt.dm_type_id = lic.lic_n_dm_type
              AND con.con_n_contract_number = lic.lic_n_con_number
              AND supp.com_number = con.con_n_supp_com_number
              AND gen.gen_refno = lic.lic_n_gen_refno
              -- Commented by Ajit AND tfee.lictf_n_year || LPAD (tfee.lictf_n_month, 2, 0) >=
                --                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
              AND tfee.lictf_n_year || LPAD (tfee.lictf_n_month, 2, 0) <=
                                     TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
              AND lic.LIC_DT_END_DATE >= i_to_date
         GROUP BY cc.com_name, lic.lic_v_currency, lt.deal_type, supp.com_short_name, con.con_v_short_name, tfee.lictf_v_lic_number, gen.gen_title, TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy'), TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy'), lic.lic_n_revenue_share_percent, TO_CHAR (fee.licf_dt_date, 'MON'), TO_CHAR (fee.licf_dt_date, 'YYYY'), TO_NUMBER (TO_CHAR (TO_DATE (fee.licf_dt_date,
                                               'dd-mon-yyyy'),
                                      'MM'
                                     )
                            ), ROUND(LICF_N_AP_FEE,2), round(LICF_N_DP_FEE,2), round(tfee.lictf_n_total_fees,2), lic.lic_n_price
      ) ORDER BY channel_company,
                lic_currency,
                lic_type,
                supplier,
                contract,
                programme,
                year#,
                month_m;

      /*
         SELECT   cc.com_name "Channel Company",
                  lic.lic_v_currency "License Currency",
                  fee.licf_v_lic_number "License Number",
                  lt.deal_type "License Type",
                  supp.com_short_name "Supplier",
                  con.con_v_short_name "Contract", gen.gen_title "Programme",
                  TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy')
                                                                "Start Date",
                  TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') "End Date",
                  lic.lic_n_revenue_share_percent "Share percentage",
                  TO_CHAR (fee.licf_dt_date, 'MON') "Month",
                  TO_CHAR (fee.licf_dt_date, 'YYYY') "Year",
                  tfee.lictf_n_total_fees "Total Fees",
                  SUM (fee.licf_n_no_of_buys) "No of buys",
                  i_from_date "From date", i_to_date "To date",
                  lic.lic_n_price "MG",
                  ROUND( tfee.lictf_n_total_fees - lic.lic_n_price ,2 ) "Overage"
             FROM tbl_tvf_lic_totel_fees tfee,
                  tbl_tvf_lic_fees fee,
                  tbl_tva_license lic,
                  fid_company cc,
                  tvod_licensee lee,
                  fid_general gen,
                  tvod_deal_memo_type lt,
                  tbl_tva_contract con,
                  fid_company supp
            WHERE UPPER (cc.com_short_name) LIKE UPPER (i_channel_comp)
              AND UPPER (supp.com_short_name) LIKE UPPER (i_supp_short_name)
              AND UPPER (con.con_v_short_name) LIKE UPPER (i_con_short_name)
              AND UPPER (fee.licf_v_lic_number) LIKE UPPER (i_lic_number)
              AND fee.licf_n_cal_month = tfee.lictf_n_month
              AND fee.licf_n_cal_year = tfee.lictf_n_year
              AND fee.LICF_V_LIC_NUMBER =  tfee.lictf_v_lic_number
              AND lic.lic_v_number = tfee.lictf_v_lic_number
              AND lt.dm_type_id = lic.lic_n_dm_type
              AND cc.com_number = lee.tvod_n_lee_cha_com_number
              AND lee.tvod_n_lee_number = lic.lic_n_lee_number
              AND con.con_n_contract_number = lic.lic_n_con_number
              AND supp.com_number = con.con_n_supp_com_number
              AND gen.gen_refno = lic.lic_n_gen_refno
              AND tfee.lictf_n_year || LPAD (tfee.lictf_n_month, 2, 0) >=
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
              AND tfee.lictf_n_year || LPAD (tfee.lictf_n_month, 2, 0) <=
                                     TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
         group by cc.com_name, lic.lic_v_currency, fee.licf_v_lic_number, lt.deal_type, supp.com_short_name, con.con_v_short_name, gen.gen_title, TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy'), TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy'), lic.lic_n_revenue_share_percent, TO_CHAR (fee.licf_dt_date, 'MON'), TO_CHAR (fee.licf_dt_date, 'YYYY'), tfee.lictf_n_total_fees, i_from_date, i_to_date, lic.lic_n_price, ROUND( tfee.lictf_n_total_fees - lic.lic_n_price ,2 )
         ORDER BY cc.com_name,
                  lic.lic_v_currency,
                  lt.deal_type,
                  supp.com_short_name,
                  con.con_v_short_name,
                  gen.gen_title; */

     EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));

   END prc_tvf_roy_stmt_summary_exl;

   --****************************************************************
-- This procedure outputs actual net price of license.
-- REM Client - MNET
--****************************************************************
   FUNCTION get_actual_net_price (i_price IN NUMBER, i_territory IN VARCHAR2)
      RETURN NUMBER
   IS
      l_net_price   NUMBER;
   BEGIN
      SELECT ROUND (DECODE (i_territory,
                            'RSA', (  i_price
                                    - (i_price * tvod_n_vat_price / 100)),
                            i_price
                           ),
                    4
                   )
        INTO l_net_price
        FROM tvod_vat_template;

      RETURN l_net_price;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_net_price := '';
      WHEN OTHERS
      THEN
         raise_application_error (-20055, SUBSTR (SQLERRM, 1, 200));
   END get_actual_net_price;


   --****************************************************************
-- This procedure outputs total fees of  expired license.
-- REM Client - MNET
--****************************************************************
   FUNCTION get_total_fees (
      i_lic_number   IN   tbl_tva_license.lic_v_number%TYPE,
      i_from_date    IN   DATE,
      i_to_date      IN   DATE
   )
      RETURN NUMBER
   IS
      l_con_ovg_inv   NUMBER;
   BEGIN
      BEGIN
         SELECT   SUM (lis_n_con_ovg_inv)
             INTO l_con_ovg_inv
             FROM tbl_tvf_license_sub_ledger, tbl_tva_license
            WHERE lis_v_lic_number = lic_v_number
              AND lic_v_number = i_lic_number
              AND lis_n_per_year || LPAD (lis_n_per_month, 2, 0)
                     BETWEEN TO_NUMBER (TO_CHAR (TO_DATE (i_from_date),
                                                 'YYYYMM'
                                                )
                                       )
                         AND TO_NUMBER (TO_CHAR (TO_DATE (i_to_date),
                                                 'YYYYMM')
                                       )
         GROUP BY lis_v_lic_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_con_ovg_inv := '';
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      RETURN l_con_ovg_inv;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END get_total_fees;

--****************************************************************
-- This procedure outputs category of license.
-- REM Client - MNET
--****************************************************************
   FUNCTION get_category (
      i_lic_n_bo_category   IN   NUMBER,
      i_lic_number          IN   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      l_boc_category   VARCHAR2 (10);
   BEGIN
      SELECT boc_v_category                                      --BO Category
        INTO l_boc_category
        FROM tvod_boxoffice_category, tbl_tva_license
        --Dev3: TVOD_CR: Start:[TVOD_CR]_[Krutarth P. Patel]_[08-Jul-2013]
       WHERE lic_n_bo_category = BOC_V_CATEGORY AND lic_v_number = i_lic_number;
        --Dev3: TVOD_CR: END :[TVOD_CR]
      RETURN l_boc_category;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
   END get_category;

--****************************************************************
-- This procedure outputs total no of scheduled days of license.
--REM Client - MNET
--****************************************************************
   FUNCTION get_scheduled_days (
      i_lic_number   IN   tbl_tva_license.lic_v_number%TYPE,
      i_from_date    IN   DATE,
      i_to_date      IN   DATE
   )
      RETURN NUMBER
   IS
      l_total_days   NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (1)
           INTO l_total_days
           FROM tbl_tvs_schedule, tbl_tva_license
          WHERE sch_v_lic_number = lic_v_number
            AND sch_d_act_date BETWEEN i_from_date AND i_to_date;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_total_days := '';
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
            RETURN l_total_days;
      END;

      RETURN l_total_days;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END get_scheduled_days;

    --****************************************************************
-- This function outputs spot rate for a particular date.
-- REM Client - MNET
--****************************************************************
   FUNCTION fun_tvf_spot_rate (
      fromcurr   IN   VARCHAR2,
      tocurr     IN   VARCHAR2,
      ondate     IN   DATE
   )
      RETURN NUMBER
   IS
      spotrate   NUMBER;
      perday     NUMBER;
      permonth   NUMBER;
      peryear    NUMBER;
   BEGIN
      perday := TO_NUMBER (TO_CHAR (ondate, 'DD'));
      permonth := TO_NUMBER (TO_CHAR (ondate, 'MM'));
      peryear := TO_NUMBER (TO_CHAR (ondate, 'YYYY'));

      BEGIN
         IF fromcurr = tocurr
         THEN
            spotrate := 1;
         ELSE
            SELECT spo_n_rate
              INTO spotrate
              FROM tbl_tvf_spot_rate
             WHERE UPPER (spo_v_cur_code) = UPPER (fromcurr)
               AND UPPER (spo_v_cur_code_2) = UPPER (tocurr)
               AND spo_n_per_day = perday
               AND spo_n_per_month = permonth
               AND spo_n_per_year = peryear;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            spotrate := '';
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      RETURN spotrate;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END fun_tvf_spot_rate;

 --****************************************************************
-- This function outputs number of buys correspoinding to license.
-- REM Client - MNET
--****************************************************************
   FUNCTION get_total_buys (
      i_lic_number           IN   tbl_tva_license.lic_v_number%TYPE,
      i_licb_v_format_code   IN   tbl_tvf_lic_buys.licb_v_format_code%TYPE,
      i_from_date            IN   DATE,
      i_to_date              IN   DATE
   )
      RETURN NUMBER
   IS
      l_total_buys   NUMBER;
   BEGIN
      BEGIN
         SELECT   SUM (licb_v_sub_number)
             INTO l_total_buys
             FROM tbl_tvf_lic_buys
            WHERE licb_v_lic_number = i_lic_number
              AND UPPER (licb_v_format_code) = UPPER (i_licb_v_format_code)
              AND licb_dt_date BETWEEN i_from_date AND i_to_date
         GROUP BY licb_v_lic_number;

         RETURN l_total_buys;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_total_buys := '';
            RETURN l_total_buys;
      END;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END get_total_buys;

--****************************************************************
-- This function returns exchange-rate used for calc fees of correspoinding to license.
--****************************************************************
 --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[13-Jun-2013]
  function  GET_AP_EXCH_RATE
  (
  I_LIC_NUMBER in varchar2,
  I_DATE IN DATE
  ) RETURN NUMBER

   AS
     L_EXCH_RATE  NUMBER;
      ap_exch_rate_src number;
      L_CON_EXCH_RATE NUMBER;
      ap_exch_rate_date DATE;
      L_AP_EXCH_RATE NUMBER;
      L_LIC_DT_START_DATE TBL_TVA_LICENSE.LIC_DT_START_DATE%TYPE;
      L_LIC_V_CURRENCY TBL_TVA_LICENSE.LIC_V_CURRENCY%TYPE;
      L_LIC_N_AP_EXCH_RATE_SRC            TBL_TVA_LICENSE.LIC_N_AP_EXCH_RATE_SRC%TYPE;
      L_LIC_N_AP_COV_RULE TBL_TVA_LICENSE.LIC_N_AP_COV_RULE%TYPE;
      L_LIC_DT_AP_REVIEW_DATE TBL_TVA_LICENSE.LIC_DT_AP_REVIEW_DATE%TYPE;
      L_LIC_N_AP_USD_ZAR_RATE TBL_TVA_LICENSE.LIC_N_AP_USD_ZAR_RATE%TYPE;
      L_LICB_DT_DATE    TBL_TVF_LIC_BUYS.LICB_DT_DATE%TYPE;

   ap_zar_spot_rate    NUMBER;
  ap_in_zar           NUMBER;
  ap_usd_spot_rate    NUMBER;
  ap_in_usd           NUMBER;
------------------------------------------
BEGIN
L_ap_exch_rate := 1;

SELECT lic_dt_start_date, lic_v_currency, lic_n_ap_exch_rate_src,
            lic_n_ap_cov_rule, lic_dt_ap_review_date,
            LIC_N_AP_USD_ZAR_RATE
     INTO   L_LIC_DT_START_DATE, L_LIC_V_CURRENCY, L_LIC_N_AP_EXCH_RATE_SRC,
            L_LIC_N_AP_COV_RULE, L_LIC_DT_AP_REVIEW_DATE,
            l_LIC_N_AP_USD_ZAR_RATE
       FROM tbl_tva_license
      WHERE lic_v_number = i_lic_number;

    SELECT  LICF_DT_DATE
      INTO    l_LICB_DT_DATE
       FROM TBL_TVF_LIC_FEES
      WHERE LICF_V_LIC_NUMBER = I_LIC_NUMBER
        AND licF_dt_date = I_DATE;

      IF l_lic_n_ap_exch_rate_src IS NOT NULL
     THEN
        ap_exch_rate_src := l_lic_n_ap_exch_rate_src;
     ELSE
        ap_exch_rate_src := 1;
     END IF;

       IF l_lic_n_ap_cov_rule = 1 OR l_lic_n_ap_cov_rule = 2
        THEN
           AP_EXCH_RATE_DATE := l_LIC_DT_AP_REVIEW_DATE;

        ELSIF l_lic_n_ap_cov_rule = 3 OR l_lic_n_ap_cov_rule = 4
        THEN
           AP_EXCH_RATE_DATE := l_LIC_DT_START_DATE;

        ELSIF l_lic_n_ap_cov_rule = 5 OR l_lic_n_ap_cov_rule = 6
        THEN
           ap_exch_rate_date :=
              TO_DATE ('01-'
                       || TO_CHAR (l_LIC_DT_START_DATE, 'MON-YY'),'DD-MON-YY'
                      );
        END IF;

        --- To find out rate on the date of conversion rule
        if     l_LIC_N_AP_COV_RULE = 7  --AND groupcount.licb_v_ap_curr_code = 'USD'
        THEN
           L_AP_EXCH_RATE := l_lic_n_ap_usd_zar_rate;
        ELSIF
           l_LIC_N_AP_COV_RULE IS NULL
        THEN
          AP_EXCH_RATE_DATE :=  l_LICB_DT_DATE;
          DBMS_OUTPUT.PUT_LINE('con rule is null.........'||AP_EXCH_RATE_DATE||'...'||ap_exch_rate_src);
           L_AP_EXCH_RATE :=
              get_spot_rate ('USD',
                             'ZAR',
                             ap_exch_rate_date,
                             AP_EXCH_RATE_SRC,
                             l_lic_n_ap_cov_rule
                            );
RETURN L_ap_exch_rate;
          DBMS_OUTPUT.PUT_LINE('exc rate.....'||L_AP_EXCH_RATE);
        END IF;
RETURN L_ap_exch_rate;
  end GET_AP_EXCH_RATE;

  ---To calculate Deemed Price Exchange Rate
   FUNCTION  GET_DP_EXCH_RATE
  (
  I_LIC_NUMBER IN VARCHAR2
  ) RETURN NUMBER
   AS

  L_EXCH_RATE   NUMBER;
  dp_exch_rate_src number;
  L_CON_EXCH_RATE NUMBER;
  dp_exch_rate_date DATE;
  L_dp_exch_rate NUMBER;

  dp_zar_spot_rate    NUMBER;
  dp_in_zar           NUMBER;
  dp_usd_spot_rate    NUMBER;
  dp_in_usd           NUMBER;

  L_LIC_DT_START_DATE TBL_TVA_LICENSE.LIC_DT_START_DATE%TYPE;
      L_LIC_V_CURRENCY TBL_TVA_LICENSE.LIC_V_CURRENCY%TYPE;
      L_LIC_N_DP_EXCH_RATE_SRC            TBL_TVA_LICENSE.LIC_N_AP_EXCH_RATE_SRC%TYPE;
      L_LIC_N_DP_COV_RULE TBL_TVA_LICENSE.LIC_N_DP_COV_RULE%TYPE;
      L_LIC_DT_DP_REVIEW_DATE TBL_TVA_LICENSE.LIC_DT_DP_REVIEW_DATE%TYPE;
      L_LIC_N_DP_USD_ZAR_RATE TBL_TVA_LICENSE.LIC_N_DP_USD_ZAR_RATE%TYPE;
------------------------------------------
BEGIN
   L_dp_exch_rate := 1;



     SELECT lic_dt_start_date, lic_v_currency, lic_n_ap_exch_rate_src,
            LIC_N_DP_COV_RULE, LIC_DT_DP_REVIEW_DATE,
            LIC_N_DP_USD_ZAR_RATE
       into  L_LIC_DT_START_DATE,L_LIC_V_CURRENCY,L_LIC_N_DP_EXCH_RATE_SRC,L_LIC_N_DP_COV_RULE,L_LIC_DT_DP_REVIEW_DATE,L_LIC_N_DP_USD_ZAR_RATE
       FROM TBL_TVA_LICENSE
      WHERE lic_v_number = i_lic_number;

-------------------------------------------

     IF L_LIC_N_DP_EXCH_RATE_SRC IS NOT NULL
     THEN
        dp_exch_rate_src := L_LIC_N_DP_EXCH_RATE_SRC;
     ELSE
        dp_exch_rate_src := 1;
     END IF;

       IF l_lic_n_dp_cov_rule = 1 OR l_lic_n_dp_cov_rule = 2
        THEN
           DP_EXCH_RATE_DATE := l_LIC_DT_DP_REVIEW_DATE;

        ELSIF l_lic_n_dp_cov_rule = 3 OR l_lic_n_dp_cov_rule = 4
        THEN
           DP_EXCH_RATE_DATE := l_LIC_DT_START_DATE;

        ELSIF l_lic_n_dp_cov_rule = 5 OR l_lic_n_dp_cov_rule = 6
        THEN
           dp_exch_rate_date :=
              TO_DATE ('01-'
                       || TO_CHAR (l_LIC_DT_START_DATE, 'MON-YY'),'DD-MON-YY'
                      );
        END IF;

      --- To find out rate on the date of conversion rule
      IF l_lic_n_dp_cov_rule = 7
      THEN
         L_DP_EXCH_RATE := l_lic_n_dp_usd_zar_rate;
      ELSE
         L_DP_EXCH_RATE :=
            GET_SPOT_RATE ('USD',
                           'ZAR',
                           dp_exch_rate_date,
                           DP_EXCH_RATE_SRC,
                           l_lic_n_dp_cov_rule
                          );

      end if;

    RETURN L_dp_exch_rate;

  end GET_DP_EXCH_RATE;

    FUNCTION get_spot_rate
    (
      fromcurr            IN   VARCHAR2,
      tocurr              IN   VARCHAR2,
      ondate              IN   DATE,
      i_spo_n_srs_id      IN   tbl_tvf_spot_rate.spo_n_srs_id%TYPE,
      i_dp_ap_conv_rule   IN   NUMBER
   )
      RETURN NUMBER
   IS
      spotrate    NUMBER;
      perday      NUMBER;
      permonth    NUMBER;
      peryear     NUMBER;
      rate_date   DATE;
   BEGIN
      rate_date := ondate;
  
      <<next_day_rate>>
      perday := TO_CHAR (rate_date, 'DD');
      permonth := TO_CHAR (rate_date, 'MM');
      peryear := TO_CHAR (rate_date, 'YYYY');
  
    dbms_output.put_line('get rate function..'||'fromcurr-'||fromcurr||'..''tocurr-'||tocurr||'..'||perday||'..'||permonth||'..'||peryear||'..'||'source id-'||i_spo_n_srs_id||rate_date);
  
      BEGIN
         IF fromcurr = tocurr
         THEN
            spotrate := 1;
         ELSE
         dbms_output.put_line('in else....');
  
            SELECT spo_n_rate
              INTO spotrate
              FROM tbl_tvf_spot_rate
             WHERE spo_v_cur_code = fromcurr
               AND spo_v_cur_code_2 = tocurr
               AND spo_n_per_day = perday
               AND SPO_N_PER_MONTH = PERMONTH
               AND SPO_N_PER_YEAR = PERYEAR
               AND spo_n_srs_id = i_spo_n_srs_id;
  
              dbms_output.put_line('spotrate-' ||spotrate);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            --IF i_spo_n_srs_id = 1
            --THEN
            IF valid_no_rate (rate_date) = 1
            THEN
               IF i_dp_ap_conv_rule IN (1, 3, 5)
               THEN
                  rate_date := rate_date + 1;
                  GOTO next_day_rate;
               ELSE
                  rate_date := rate_date - 1;
                  GOTO next_day_rate;
               END IF;
            ELSE
               spotrate := '';
            END IF;
      --ELSE
      --   spotrate := '';
      --END IF;
      END;
      dbms_output.put_line('final spotrate-' ||spotrate);
      RETURN spotrate;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601,
                                     SUBSTR (SQLERRM, 1, 200)
                                  || ' - While fetching Spot Rate'
                                 );
   END get_spot_rate;

   FUNCTION valid_no_rate (no_rate_date DATE)
      RETURN NUMBER
   AS
      is_holiday         NUMBER;
      day_of_week        VARCHAR2 (10);
      is_valid_no_rate   NUMBER;
   BEGIN
      is_holiday := 0;
      day_of_week := NULL;

      SELECT COUNT (*)
        INTO is_holiday
        FROM tbl_tvf_holidays
       WHERE thol_holiday_date = no_rate_date;

      SELECT TO_CHAR (no_rate_date, 'DAY')
        INTO day_of_week
        FROM DUAL;

      IF is_holiday = 1 OR UPPER (day_of_week) = 'SUNDAY'
      THEN
         is_valid_no_rate := 1;
      ELSE
         is_valid_no_rate := 0;
      END IF;

      RETURN is_valid_no_rate;
   END valid_no_rate;

  ----Dev3: TVOD_CR: END :[TVOD_CR]


END pkg_tvf_roy_stmt_rpt;
/