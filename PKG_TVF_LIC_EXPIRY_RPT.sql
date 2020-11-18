create or replace PACKAGE          "PKG_TVF_LIC_EXPIRY_RPT" AS

/****************************************************************
REM Module        : Finance Module
REM Client          : MNET
REM File Name        : PKG_TVF_LIC_EXPIRY_RPT.sql
REM Form Name        :License Expiry Report
REM Purpose         : For generating outstanding commitment
REM Author        : Mrunmayi kusurkar
REM Creation Date   : 2 jan 2012
REM Type            : Database Package
REM Change History  :
****************************************************************/

--****************************************************************
-- This procedure outputs details of expired license.
-- REM Client - MNET
--****************************************************************
 PROCEDURE prc_tvf_lic_expiry_dtls (
      i_report_type       IN       VARCHAR2,
      i_calculate_summary IN       VARCHAR2,
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      i_lic_number        IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name    IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_cursor            OUT     sys_refcursor
   );

--****************************************************************
-- This procedure outputs details of expired license in excel sheet.
-- REM Client - MNET
--****************************************************************
   PROCEDURE prc_tvf_lic_expiry_dtls_exl (
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      i_lic_number        IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name    IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_cursor            OUT     sys_refcursor
   );

 --****************************************************************
-- This procedure outputs details of summary of expired license.
-- REM Client - MNET
--****************************************************************
    PROCEDURE prc_tvf_lic_expiry_summary (
      i_report_type       IN       VARCHAR2,
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      i_lic_number        IN       tbl_tva_license.lic_v_number%TYPE,
      i_con_short_name    IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_cursor            OUT     sys_refcursor
   );

  --****************************************************************
-- This procedure outputs details of summary of expired license into excel sheet.
-- REM Client - MNET
--****************************************************************
     PROCEDURE prc_tvf_lic_expiry_summary_exl (
         i_channel_comp      IN       fid_company.com_short_name%TYPE,
         i_lic_number        IN       tbl_tva_license.lic_v_number%TYPE,
         i_con_short_name    IN       tbl_tva_contract.con_v_short_name%TYPE,
         i_supp_short_name   IN       fid_company.com_short_name%TYPE,
         i_from_date         IN       DATE,
         i_to_date           IN       DATE,
         o_cursor            OUT     sys_refcursor
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
-- This procedure outputs media type of expired license.
-- REM Client - MNET
--****************************************************************
   FUNCTION get_media_type
   (
       i_lic_number    IN  tbl_tva_license.lic_v_number%TYPE
   )    RETURN VARCHAR2;

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

 FUNCTION get_actual_net_price
  (
     i_price          IN      NUMBER,
     i_territory      IN      VARCHAR2
  )RETURN NUMBER;
END PKG_TVF_LIC_EXPIRY_RPT;
/
create or replace PACKAGE BODY          "PKG_TVF_LIC_EXPIRY_RPT"
AS

/******************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         02-Nov-2016       Zeshan Khan                 Business Req.-
                                                          1. Business wants to get all the spot rates upto 5 decimal places instead of 4.
*******************************************************************************************************************************************/

--****************************************************************
-- This procedure outputs details of expired license.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_tvf_lic_expiry_dtls
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
    l_from_date   VARCHAR2 (30);
    l_to_date     VARCHAR2 (30);
  BEGIN
    OPEN o_cursor FOR
    SELECT cc.com_name channel_company,
           lic.lic_v_currency lic_currency,
           fee.licf_v_lic_number lic#, lt.deal_type lic_type,
           supp.com_short_name supplier,
           con.con_v_short_name contract, gen.gen_title programme,
           TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy') start_date,
           TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') end_date,
           TO_CHAR (lic.lic_dt_lvr, 'dd-Mon-yyyy') lvr_date,
           lic.lic_n_day_post_lvr days,
           lic.lic_n_revenue_share_percent share_percentage,
           lic.lic_v_formats lic_format,
           max((SELECT cat.boc_v_category
                  FROM tvod_boxoffice_category cat
                 WHERE cat.boc_v_category = lic.lic_n_bo_category)) category#,
           max((SELECT formula.tvod_v_fee_formula_short_name
                  FROM tvod_license_fee_formula formula
                 WHERE formula.tvod_n_lic_fee_formula_number = lic.lic_n_fee_formula_number)) fee_formula,
           ROUND (lic.lic_n_mg_exchange_rate, 5) exch_rate_avail_date,   -- [Ver 0.1]
           fee.licf_v_ter_name terr, fee.licf_v_format_code format,
           fee.licf_v_media_type media_type,
           TO_CHAR (fee.licf_dt_date, 'MON') month#,
           TO_NUMBER (TO_CHAR (fee.licf_dt_date,'MM')) month_m,
           TO_CHAR (fee.licf_dt_date, 'YYYY') year#,
           fee.licf_v_sp_curr_code selling_price_curr,
           ROUND (fee.licf_n_selling_price, 2) selling_price,
           ROUND (fee.licf_n_actual_price, 2) actual_price,
           ROUND (lic.lic_n_dp_zar_hd, 2) deemed_zar_hd,
           ROUND (lic.lic_n_dp_usd_hd, 2) deemed_usd_hd,
           ROUND (lic.lic_n_dp_zar_sd, 2) deemed_zar_sd,
           ROUND (lic.lic_n_dp_usd_sd, 2) deemed_usd_sd,
           ROUND (SUM (NVL (fee.licf_n_no_of_buys, 0)), 2) no_of_buys,
           ROUND (SUM (NVL (fee.licf_n_fee, 0)), 2) total_fees
      FROM tbl_tvf_lic_fees fee,
           tbl_tva_license lic,
           fid_company cc,
           fid_general gen,
           tvod_deal_memo_type lt,
           tbl_tva_contract con,
           fid_company supp
     WHERE UPPER (cc.com_short_name) LIKE UPPER (i_channel_comp)
       AND UPPER (supp.com_short_name) LIKE UPPER (i_supp_short_name)
       AND UPPER (con.con_v_short_name) LIKE UPPER (i_con_short_name)
       AND lic.lic_v_number = fee.licf_v_lic_number
       AND gen.gen_refno = lic.lic_n_gen_refno
       AND lt.dm_type_id = lic.lic_n_dm_type
       AND cc.com_number = con.con_n_com_number
       AND con.con_n_contract_number = lic.lic_n_con_number
       AND supp.com_number = con.con_n_supp_com_number
       AND trunc(lic.lic_dt_end_date) BETWEEN i_from_date AND i_to_date
  GROUP BY cc.com_name,
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
           ROUND (lic.lic_n_mg_exchange_rate, 5),   -- [Ver 0.1]
           fee.licf_v_ter_name,
           fee.licf_v_format_code,
           fee.licf_v_media_type,
           TO_CHAR (fee.licf_dt_date, 'MON'),
           TO_NUMBER (TO_CHAR (fee.licf_dt_date,'MM')),
           TO_CHAR (fee.licf_dt_date, 'YYYY'),
           fee.licf_v_sp_curr_code,
           ROUND (fee.licf_n_selling_price, 2),
           ROUND (fee.licf_n_actual_price, 2),
           ROUND (lic.lic_n_dp_zar_hd, 2),
           ROUND (lic.lic_n_dp_usd_hd, 2),
           ROUND (lic.lic_n_dp_zar_sd, 2),
           ROUND (lic.lic_n_dp_usd_sd, 2);
  END prc_tvf_lic_expiry_dtls;

 --****************************************************************
-- This procedure outputs details of expired license in excel sheet.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_tvf_lic_expiry_dtls_exl
  (
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
    SELECT cc.com_name "Channel Company",
           lic.lic_v_currency "Lic Currency",
           fee.licf_v_lic_number "License #",
           lt.deal_type "Lic Type",
           supp.com_short_name "Supplier",
           con.con_v_short_name "Contract",
           gen.gen_title "Programme",
           TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy') "Start Date",
           TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') "End Date",
           TO_CHAR (lic.lic_dt_lvr, 'dd-Mon-yyyy') "LVR Date",
           lic.lic_n_day_post_lvr "Days",
           lic.lic_n_revenue_share_percent "Share Percentage",
           lic.lic_v_formats "License Format",
           max((SELECT cat.boc_v_category
                  FROM tvod_boxoffice_category cat
                 WHERE cat.boc_v_category = lic.lic_n_bo_category)) "Category",
           max((SELECT formula.tvod_v_fee_formula_short_name
                  FROM tvod_license_fee_formula formula
                 WHERE formula.tvod_n_lic_fee_formula_number = lic.lic_n_fee_formula_number)) "Fee Formula",
           ROUND (lic.lic_n_mg_exchange_rate, 5) "Exch Rate Avail Date",   -- [Ver 0.1]
           fee.licf_v_ter_name "Territory",
           fee.licf_v_format_code "Format",
           fee.licf_v_media_type "Media Type",
           TO_CHAR (fee.licf_dt_date, 'MON') "Month",
           TO_CHAR (fee.licf_dt_date, 'YYYY') "Year",
           fee.licf_v_sp_curr_code "Selling Price Currency",
           ROUND (fee.licf_n_selling_price, 2) "Selling Price",
           ROUND (fee.licf_n_actual_price, 2) "Actual Price",
           ROUND (lic.lic_n_dp_zar_hd, 2) "Deemed Zar HD",
           ROUND (lic.lic_n_dp_usd_hd, 2) "Deemed Usd HD",
           ROUND (lic.lic_n_dp_zar_sd, 2) "Deemed Zar SD",
           ROUND (lic.lic_n_dp_usd_sd, 2) "Deemed Usd SD",
           ROUND (SUM (NVL (fee.licf_n_no_of_buys, 0)), 2) "No of Buys",
           ROUND (SUM (NVL (fee.licf_n_fee, 0)), 2) "Total Fees"
      FROM tbl_tvf_lic_fees fee,
           tbl_tva_license lic,
           fid_company cc,
           fid_general gen,
           tvod_deal_memo_type lt,
           tbl_tva_contract con,
           fid_company supp
     WHERE UPPER (cc.com_short_name) LIKE UPPER (i_channel_comp)
       AND UPPER (supp.com_short_name) LIKE UPPER (i_supp_short_name)
       AND UPPER (con.con_v_short_name) LIKE UPPER (i_con_short_name)
       AND lic.lic_v_number = fee.licf_v_lic_number
       AND gen.gen_refno = lic.lic_n_gen_refno
       AND lt.dm_type_id = lic.lic_n_dm_type
       AND cc.com_number = con.con_n_com_number
       AND con.con_n_contract_number = lic.lic_n_con_number
       AND supp.com_number = con.con_n_supp_com_number
       AND trunc(lic.lic_dt_end_date) BETWEEN i_from_date AND i_to_date
  GROUP BY cc.com_name,
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
           ROUND (lic.lic_n_mg_exchange_rate, 5),   -- [Ver 0.1]
           fee.licf_v_ter_name,
           fee.licf_v_format_code,
           fee.licf_v_media_type,
           TO_CHAR (fee.licf_dt_date, 'MON'),
           TO_NUMBER (TO_CHAR (fee.licf_dt_date,'MM')),
           TO_CHAR (fee.licf_dt_date, 'YYYY'),
           fee.licf_v_sp_curr_code,
           ROUND (fee.licf_n_selling_price, 2),
           ROUND (fee.licf_n_actual_price, 2),
           ROUND (lic.lic_n_dp_zar_hd, 2),
           ROUND (lic.lic_n_dp_usd_hd, 2),
           ROUND (lic.lic_n_dp_zar_sd, 2),
           ROUND (lic.lic_n_dp_usd_sd, 2)
  ORDER BY "Channel Company",
           "Lic Currency",
           "Lic Type";
   END prc_tvf_lic_expiry_dtls_exl;

--****************************************************************
-- This procedure outputs details of summary of expired license.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_tvf_lic_expiry_summary
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
    SELECT channel_company,
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
           month_m,
           year#,
           total_fees,
           "MG",
           (CASE WHEN round(total_fees - "MG",2) > 0
                 THEN round(total_fees - "MG",2)
            ELSE 0
            END) "Overage",
           no_of_buys
      FROM (SELECT cc.com_name channel_company,
                   lic.lic_v_currency lic_currency,
                   lt.deal_type lic_type,
                   supp.com_short_name supplier,
                   con.con_v_short_name contract,
                   lic.lic_v_number lic#,
                   gen.gen_title programme,
                   TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy') start_date,
                   TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') end_date,
                   lic.lic_n_revenue_share_percent share_percentage,
                   TO_CHAR (fee.licf_dt_date, 'MON') month#,
                   TO_NUMBER (TO_CHAR (fee.licf_dt_date,'MM')) month_m,
                   TO_CHAR (fee.licf_dt_date, 'YYYY') year#,
                   max((SELECT tfee.lictf_n_total_fees
                          FROM tbl_tvf_lic_totel_fees tfee
                         WHERE lic.lic_v_number = tfee.lictf_v_lic_number
                           AND tfee.lictf_n_month = TO_NUMBER (TO_CHAR (fee.licf_dt_date,'MM'))
                           AND tfee.lictf_n_year = TO_CHAR (fee.licf_dt_date, 'YYYY'))) total_fees,
                   ROUND(lic.lic_n_price,2) "MG",
                   SUM (fee.licf_n_no_of_buys) no_of_buys
              FROM tbl_tvf_lic_fees fee,
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
               AND fee.licf_v_lic_number = lic.lic_v_number
               AND cc.com_number = con.con_n_com_number
               AND lt.dm_type_id = lic.lic_n_dm_type
               AND lee.tvod_n_lee_number = lic.lic_n_lee_number
               AND con.con_n_contract_number = lic.lic_n_con_number
               AND supp.com_number = con.con_n_supp_com_number
               AND gen.gen_refno = lic.lic_n_gen_refno
               AND trunc(lic.lic_dt_end_date) BETWEEN i_from_date AND i_to_date
          group by cc.com_name,
                   lic.lic_v_currency,
                   lt.deal_type,
                   supp.com_short_name,
                   con.con_v_short_name,
                   lic.lic_v_number,
                   gen.gen_title,
                   TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy'),
                   TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy'),
                   lic.lic_n_revenue_share_percent,
                   TO_CHAR (fee.licf_dt_date, 'MON'),
                   TO_NUMBER (TO_CHAR (fee.licf_dt_date,'MM')),
                   TO_CHAR (fee.licf_dt_date, 'YYYY'),
                   ROUND(lic.lic_n_price,2));
  END prc_tvf_lic_expiry_summary;

   --****************************************************************
-- This procedure outputs details of summary of expired license into excel sheet.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_tvf_lic_expiry_summary_exl
  (
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
    SELECT channel_company "Channel Company",
           lic_currency "Lic Currency",
           lic_type "Lic Type",
           supplier "Supplier",
           contract "Contract",
           lic# "License #",
           programme "Programme",
           start_date "Start Date",
           end_date "End Date",
           share_percentage "Share Percentage",
           month# "Month",
           year# "Year",
           total_fees "Total Fees",
           "MG",
           (CASE WHEN round(total_fees - "MG",2) > 0
                 THEN round(total_fees - "MG",2)
            ELSE 0
            END) "Overage",
           no_of_buys "No of Buys"
      FROM (SELECT cc.com_name channel_company,
                   lic.lic_v_currency lic_currency,
                   lt.deal_type lic_type,
                   supp.com_short_name supplier,
                   con.con_v_short_name contract,
                   lic.lic_v_number lic#,
                   gen.gen_title programme,
                   TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy') start_date,
                   TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy') end_date,
                   lic.lic_n_revenue_share_percent share_percentage,
                   TO_CHAR (fee.licf_dt_date, 'MON') month#,
                   TO_NUMBER (TO_CHAR (fee.licf_dt_date,'MM')) month_m,
                   TO_CHAR (fee.licf_dt_date, 'YYYY') year#,
                   max((SELECT tfee.lictf_n_total_fees
                          FROM tbl_tvf_lic_totel_fees tfee
                         WHERE lic.lic_v_number = tfee.lictf_v_lic_number
                           AND tfee.lictf_n_month = TO_NUMBER (TO_CHAR (fee.licf_dt_date,'MM'))
                           AND tfee.lictf_n_year = TO_CHAR (fee.licf_dt_date, 'YYYY'))) total_fees,
                   ROUND(lic.lic_n_price,2) "MG",
                   SUM (fee.licf_n_no_of_buys) no_of_buys
              FROM tbl_tvf_lic_fees fee,
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
               AND fee.licf_v_lic_number = lic.lic_v_number
               AND cc.com_number = con.con_n_com_number
               AND lt.dm_type_id = lic.lic_n_dm_type
               AND lee.tvod_n_lee_number = lic.lic_n_lee_number
               AND con.con_n_contract_number = lic.lic_n_con_number
               AND supp.com_number = con.con_n_supp_com_number
               AND gen.gen_refno = lic.lic_n_gen_refno
               AND trunc(lic.lic_dt_end_date) BETWEEN i_from_date AND i_to_date
          group by cc.com_name,
                   lic.lic_v_currency,
                   lt.deal_type,
                   supp.com_short_name,
                   con.con_v_short_name,
                   lic.lic_v_number,
                   gen.gen_title,
                   TO_CHAR (lic.lic_dt_start_date, 'dd-Mon-yyyy'),
                   TO_CHAR (lic.lic_dt_end_date, 'dd-Mon-yyyy'),
                   lic.lic_n_revenue_share_percent,
                   TO_CHAR (fee.licf_dt_date, 'MON'),
                   TO_NUMBER (TO_CHAR (fee.licf_dt_date,'MM')),
                   TO_CHAR (fee.licf_dt_date, 'YYYY'),
                   ROUND(lic.lic_n_price,2))
  ORDER BY "Channel Company",
           "Lic Currency",
           "Lic Type",
           "Supplier",
           "Contract",
           "Programme";
   END prc_tvf_lic_expiry_summary_exl;

  --****************************************************************
-- This procedure outputs actual net price of expired license.
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
-- This procedure outputs category of expired license.
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
       WHERE lic_n_bo_category = boc_n_number AND lic_v_number = i_lic_number;

      RETURN l_boc_category;
    EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
    RETURN l_boc_category;
   END get_category;

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
-- This function outputs all media types associated with license.
-- REM Client - MNET
--****************************************************************
   FUNCTION get_media_type (i_lic_number IN tbl_tva_license.lic_v_number%TYPE)
      RETURN VARCHAR2
   IS
      l_string   VARCHAR2 (500);
   BEGIN
      FOR i IN
         (SELECT tlmm.n_lic_medt_mapp_media_number,
                 (SELECT media_type
                    FROM tvod_mediatypes tm
                   WHERE tm.media_type_id =
                                 tlmm.n_lic_medt_mapp_media_number
                     AND tlmm.v_lic_medt_mapp_lic_number = i_lic_number)
                                                                  media_type
            FROM tbl_tva_lic_medt_mapping tlmm
           WHERE tlmm.v_lic_medt_mapp_lic_number = i_lic_number)
      LOOP
         IF l_string IS NOT NULL
         THEN
            l_string := l_string || ',' || i.media_type;
         ELSE
            l_string := i.media_type;
         END IF;
      END LOOP;

      DBMS_OUTPUT.put_line (l_string);
      RETURN l_string;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_string := 'N/A';
         RETURN l_string;
   END get_media_type;
END pkg_tvf_lic_expiry_rpt;
/