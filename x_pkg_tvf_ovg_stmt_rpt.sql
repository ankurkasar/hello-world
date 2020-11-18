create or replace PACKAGE          x_pkg_tvf_ovg_stmt_rpt
AS
  PROCEDURE x_prc_tvf_ovg_stmt_dtls
  (
    i_report_type         IN       VARCHAR2,
    i_all_columns         IN       VARCHAR2,
    i_channel_comp        IN       fid_company.com_short_name%TYPE,
    i_con_short_name      IN       tbl_tva_contract.con_v_short_name%TYPE,
    i_supp_short_name     IN       fid_company.com_short_name%TYPE,
    i_period              IN       DATE,
    o_cursor              OUT      sys_refcursor
  );

  PROCEDURE x_prc_tvf_ovg_stmt_dtls_exl
  (
    i_report_type         IN      VARCHAR2,
    i_all_columns         IN      VARCHAR2,
    i_order_by            IN      VARCHAR2,
    i_channel_comp        IN      fid_company.com_short_name%TYPE,
    i_con_short_name      IN      tbl_tva_contract.con_v_short_name%TYPE,
    i_supp_short_name     IN      fid_company.com_short_name%TYPE,
    i_from_date           IN       DATE,
    o_cursor              OUT     sys_refcursor
  );

  PROCEDURE x_prc_tvf_ovg_stmt_summary
  (
    i_channel_comp        IN       fid_company.com_short_name%TYPE,
    i_con_short_name      IN       tbl_tva_contract.con_v_short_name%TYPE,
    i_supp_short_name     IN       fid_company.com_short_name%TYPE,
    i_period              IN       DATE,
    o_cursor              OUT      sys_refcursor
  );

  PROCEDURE x_prc_tvf_ovg_stmt_summary_exl
  (
    i_channel_comp        IN       fid_company.com_short_name%TYPE,
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

  FUNCTION get_net_selling_price
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE
  )
  RETURN NUMBER;

  FUNCTION get_net_selling_price_zar
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE,
    i_cur_conv_rule   IN  tbl_tva_license.lic_act_cur_cov_rule%TYPE
  )
  RETURN NUMBER;

  FUNCTION get_net_selling_price_cc
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE,
    i_cur_conv_rule   IN  tbl_tva_license.lic_act_cur_cov_rule%TYPE
  )
  RETURN NUMBER;

  FUNCTION get_nsp_rate_zar
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE,
    i_cur_conv_rule   IN  tbl_tva_license.lic_act_cur_cov_rule%TYPE
  )
  RETURN NUMBER;

  FUNCTION get_nsp_rate_cc
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE,
    i_cur_conv_rule   IN  tbl_tva_license.lic_act_cur_cov_rule%TYPE
  )
  RETURN NUMBER;
END x_pkg_tvf_ovg_stmt_rpt;
/
create or replace PACKAGE BODY          x_pkg_tvf_ovg_stmt_rpt
AS

/******************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         02-Nov-2016       Zeshan Khan                 Business Req.-
                                                          1. Business wants to get all the spot rates upto 5 decimal places instead of 4.
*******************************************************************************************************************************************/

  PROCEDURE x_prc_tvf_ovg_stmt_dtls
  (
    i_report_type         IN       VARCHAR2,
    i_all_columns         IN       VARCHAR2,
    i_channel_comp        IN       fid_company.com_short_name%TYPE,
    i_con_short_name      IN       tbl_tva_contract.con_v_short_name%TYPE,
    i_supp_short_name     IN       fid_company.com_short_name%TYPE,
    i_period              IN       DATE,
    o_cursor              OUT      sys_refcursor
  )
  AS
    l_query     VARCHAR2(10000);
    l_period    PLS_INTEGER := to_number(to_char(i_period,'RRRRMM'));
  BEGIN
    l_query := '
    SELECT channel_company,
           lic_currency,
           cc_currency,
           supplier,
           contract,
           programme,
           lic_number,
           period,
           start_date,
           end_date,
           lvr_date,
           days,
           share_percentage,
           bo_category,
           terr,
           selling_price_curr,
           media_type,
           licf_v_format_code,
           selling_price,
           "Net Selling Price (SC)",
           "FX (SC) to (LC) Actual",
           "FX (LC) to (CC) Actual",
           round("Net Selling Price (SC)"/decode("FX (SC) to (LC) Actual",0,1,"FX (SC) to (LC) Actual"),2) "Net Selling Price Conv (LC)",
           round(("Net Selling Price (SC)"/decode("FX (SC) to (LC) Actual",0,1,"FX (SC) to (LC) Actual"))/decode("FX (LC) to (CC) Actual",0,1,"FX (LC) to (CC) Actual"),2) "Net Selling Price Conv (CC)",
           "Deemed Price (LC)",
           "Deemed Price (CC)",
           "FX (LC) to (CC) for Deemed",
           round("Deemed Price (LC)"/decode("FX (LC) to (CC) for Deemed",0,1,"FX (LC) to (CC) for Deemed"),2) "Converted Deemed Price (CC)",
           "Minimum Price (CC)",
           no_of_buys,
           (greatest(round(("Net Selling Price (SC)"/decode("FX (SC) to (LC) Actual",0,1,"FX (SC) to (LC) Actual"))/decode("FX (LC) to (CC) Actual",0,1,"FX (LC) to (CC) Actual"),2),round("Deemed Price (LC)"/decode("FX (LC) to (CC) for Deemed",0,1,"FX (LC) to (CC) for Deemed"),2),"Deemed Price (CC)") * no_of_buys * share_percentage / 100) lic_fee,
           (SELECT round(sum(lis_n_con_inventory),2)
              FROM tbl_tvf_license_sub_ledger
             WHERE lis_v_lic_number = lic_number
               AND lis_n_per_year || lpad(lis_n_per_month,2,0) <= ' || l_period || ') mg,
           (SELECT round(sum(lis_n_con_ovg_inv),2)
              FROM tbl_tvf_license_sub_ledger
             WHERE lis_v_lic_number = lic_number
               AND lis_n_per_year || lpad(lis_n_per_month,2,0) = to_char(to_date(period,''Mon-RRRR''),''RRRRMM'')) overage,
           (SELECT round(sum(lis_n_con_ovg_inv),2)
              FROM tbl_tvf_license_sub_ledger
             WHERE lis_v_lic_number = lic_number
               AND lis_n_per_year || lpad(lis_n_per_month,2,0) <= ' || l_period || ') overage_till_month,
           ROW_NUMBER() OVER (PARTITION BY lic_number,to_date(period,''Mon-RRRR'') ORDER BY lic_number) rank,
           ROW_NUMBER() OVER (PARTITION BY lic_number ORDER BY lic_number) rank2
      FROM (SELECT cc.com_name channel_company,
                   lic.lic_v_currency lic_currency,
                   ter.v_ter_cur_code cc_currency,
                   supp.com_short_name supplier,
                   con.con_v_short_name contract,
                   gen.gen_title programme,
                   fee.licf_v_lic_number lic_number,
                   to_char(fee.licf_dt_date,''Mon-RRRR'') period,
                   to_char(lic.lic_dt_start_date, ''dd-Mon-yyyy'') start_date,
                   to_char(lic.lic_dt_end_date, ''dd-Mon-yyyy'') end_date,
                   to_char(lic.lic_dt_lvr, ''dd-Mon-yyyy'') lvr_date,
                   lic.lic_n_day_post_lvr days,
                   lic.lic_n_revenue_share_percent share_percentage,
                   lic.lic_v_bo_sub_category bo_category,
                   fee.licf_v_ter_name terr,
                   fee.licf_v_sp_curr_code selling_price_curr,
                   fee.licf_v_media_type media_type,
                   fee.licf_v_format_code,
                   max(round (fee.LICF_N_SELLING_PRICE, 2)) selling_price,
                   max(round (fee.LICF_N_ACTUAL_PRICE, 2)) "Net Selling Price (SC)",
                   max(x_pkg_tvf_ovg_stmt_rpt.get_nsp_rate_zar(lic.lic_v_number,fee.licf_v_sp_curr_code,fee.licf_n_selling_price,fee.licf_v_format_code,fee.licf_v_ter_name,licf_dt_date,lic.lic_act_cur_cov_rule)) "FX (SC) to (LC) Actual",
                   max(x_pkg_tvf_ovg_stmt_rpt.get_nsp_rate_cc(lic.lic_v_number,fee.licf_v_sp_curr_code,fee.licf_n_selling_price,fee.licf_v_format_code,fee.licf_v_ter_name,licf_dt_date,lic.lic_act_cur_cov_rule)) "FX (LC) to (CC) Actual",
                   max(decode(fee.licf_v_format_code,''HD'',round(lic.lic_n_dp_zar_hd,2),round(lic.lic_n_dp_zar_sd,2))) "Deemed Price (LC)",
                   max(decode(fee.licf_v_format_code,''HD'',round(lic.lic_n_dp_usd_hd,2),round(lic.lic_n_dp_usd_sd,2))) "Deemed Price (CC)",
                   max(decode(con_n_fee_formula_number,3,0,4,0,round(x_pkg_tvf_ovg_stmt_rpt.get_dp_exch_rate(lic_v_number),5))) "FX (LC) to (CC) for Deemed",   -- [Ver 0.1]
                   max(licf_n_dp_fee) "Minimum Price (CC)",
                   round(sum(nvl(fee.licf_n_no_of_buys,0)),2) no_of_buys
              FROM tbl_tvf_lic_fees fee,
                   tbl_tva_license lic,
                   fid_company cc,
                   tvod_licensee lee,
                   fid_general gen,
                   tbl_tva_contract con,
                   fid_company supp,
                   tbl_tva_territory ter
             WHERE cc.com_number = con.con_n_com_number
               AND lee.tvod_n_lee_number = lic.lic_n_lee_number
               AND lic.lic_v_number = fee.licf_v_lic_number
               AND gen.gen_refno = lic.lic_n_gen_refno
               AND con.con_n_contract_number = lic.lic_n_con_number
               AND supp.com_number = con.con_n_supp_com_number
               AND ter.v_ter_code = cc.com_ter_code
               AND lic.lic_n_dm_type = 1
               AND supp.com_internal = '''|| i_report_type || '''
               AND upper(cc.com_short_name) LIKE upper(''' || i_channel_comp || ''')
               AND upper(supp.com_short_name) LIKE upper(''' || i_supp_short_name || ''')
               AND upper(con.con_v_short_name) LIKE upper(''' || i_con_short_name || ''')
               AND to_number(to_char(fee.licf_dt_date,''RRRRMM'')) <= ' || l_period || '
               AND ' || l_period || ' BETWEEN to_number(to_char(lic.lic_dt_start_date,''RRRRMM'')) AND to_number(to_char(lic.lic_dt_end_date,''RRRRMM''))
          GROUP BY cc.com_name,
                   supp.com_short_name,
                   ter.v_ter_cur_code,
                   con.con_v_short_name,
                   lic.lic_v_currency,
                   gen.gen_title,
                   fee.licf_v_lic_number,
                   to_char (lic.lic_dt_start_date, ''dd-Mon-yyyy''),
                   to_char (lic.lic_dt_end_date, ''dd-Mon-yyyy''),
                   to_char (lic.lic_dt_lvr, ''dd-Mon-yyyy''),
                   to_char(fee.licf_dt_date,''Mon-RRRR''),
                   lic.lic_n_day_post_lvr,
                   lic.lic_n_revenue_share_percent,
                   lic.lic_v_bo_sub_category,
                   con_v_currency,
                   fee.licf_v_ter_name,
                   fee.licf_v_sp_curr_code,
                   fee.licf_v_format_code,
                   fee.licf_v_media_type,
                   round(fee.licf_n_selling_price, 2))
  ORDER BY channel_company,
           supplier,
           contract,
           programme';

    OPEN o_cursor FOR l_query;
  END x_prc_tvf_ovg_stmt_dtls;

  PROCEDURE x_prc_tvf_ovg_stmt_dtls_exl
  (
    i_report_type         IN      VARCHAR2,
    i_all_columns         IN      VARCHAR2,
    i_order_by            IN      VARCHAR2,
    i_channel_comp        IN      fid_company.com_short_name%TYPE,
    i_con_short_name      IN      tbl_tva_contract.con_v_short_name%TYPE,
    i_supp_short_name     IN      fid_company.com_short_name%TYPE,
    i_from_date           IN      DATE,
    o_cursor              OUT     sys_refcursor
  )
  AS
    l_query     VARCHAR2(10000);
    l_period    PLS_INTEGER := to_number(to_char(i_from_date,'RRRRMM'));
  BEGIN
    l_query := '
    SELECT "Channel Company",
           "Supplier",
           "Contract",
           "Programme",
           "License Number",
           "LSD",
           "LED",
           "LVR",
           "Days",
           "% Share",
           "BO Category",
           "Contract Currency",
           "Local Currency",
           "Selling Country",
           "Format",
           "Period",
           "Selling Price",
           "Net Selling Price (SC)",
           "FX (SC) to (LC) Actual",';

    IF i_report_type = 'S' AND i_all_columns = 'Y'
    THEN
      l_query := l_query || '
           "FX (LC) to (CC) Actual",';
    END IF;

    l_query := l_query || '
           round(("Net Selling Price (SC)"/decode("FX (SC) to (LC) Actual",0,1,"FX (SC) to (LC) Actual")),2) "Net Selling Price (LC)",
           round(("Net Selling Price (SC)"/decode("FX (SC) to (LC) Actual",0,1,"FX (SC) to (LC) Actual")/decode("FX (LC) to (CC) Actual",0,1,"FX (LC) to (CC) Actual")),2) "Net Selling Price (CC)",';
    IF i_report_type = 'S' AND i_all_columns = 'Y'
    THEN
      l_query := l_query || '
           "Deemed Price (LC)",
           "Deemed Price (CC)",
           "FX (LC) to (CC) for Deemed",
           round("Deemed Price (LC)"/decode("FX (LC) to (CC) for Deemed",0,1,"FX (LC) to (CC) for Deemed"),2) "Converted Deemed Price (CC)",';
    ELSIF i_report_type = 'S'
    THEN
      l_query := l_query || '
           "Minimum Price (CC)",';
    END IF;

    l_query := l_query || '
           "No of Buys",
           (greatest(round(("Net Selling Price (SC)"/decode("FX (SC) to (LC) Actual",0,1,"FX (SC) to (LC) Actual"))/decode("FX (LC) to (CC) Actual",0,1,"FX (LC) to (CC) Actual"),2),round("Deemed Price (LC)"/decode("FX (LC) to (CC) for Deemed",0,1,"FX (LC) to (CC) for Deemed"),2),"Deemed Price (CC)") * "No of Buys" * "% Share" / 100) "License Fee",
           (SELECT round(sum(lis_n_con_inventory),2)
							FROM tbl_tvf_license_sub_ledger
						 WHERE lis_v_lic_number = "License Number"
							 AND lis_n_per_year || lpad(lis_n_per_month,2,0) <= ' || l_period || ') "MG",
           (SELECT round(sum(lis_n_con_ovg_inv),2)
							FROM tbl_tvf_license_sub_ledger
						 WHERE lis_v_lic_number = "License Number"
							 AND lis_n_per_year || lpad(lis_n_per_month,2,0) = to_char(to_date("Period",''Mon-RRRR''),''RRRRMM'')) "Overage"
      FROM (SELECT cc.com_name "Channel Company",
                   supp.com_short_name "Supplier",
                   con.con_v_short_name "Contract",
                   gen.gen_title "Programme",
                   fee.licf_v_lic_number "License Number",
                   to_char(lic.lic_dt_start_date, ''dd-Mon-yyyy'') "LSD",
                   to_char(lic.lic_dt_end_date, ''dd-Mon-yyyy'') "LED",
                   to_char(lic.lic_dt_lvr, ''dd-Mon-yyyy'') "LVR",
                   lic.lic_n_day_post_lvr "Days",
                   lic.lic_n_revenue_share_percent "% Share",
                   lic.lic_v_bo_sub_category "BO Category",
                   con_v_currency "Contract Currency",
                   ter.v_ter_cur_code "Local Currency",
                   fee.licf_v_ter_name "Selling Country",
                   fee.licf_v_sp_curr_code "Selling Currency",
                   fee.licf_v_format_code "Format",
                   to_char(fee.licf_dt_date,''Mon-RRRR'') "Period",
                   round (fee.licf_n_selling_price, 2) "Selling Price",
                   round (fee.licf_n_actual_price, 2) "Net Selling Price (SC)",
                   max(x_pkg_tvf_ovg_stmt_rpt.get_nsp_rate_zar(lic.lic_v_number,fee.licf_v_sp_curr_code,fee.licf_n_selling_price,fee.licf_v_format_code,fee.licf_v_ter_name,licf_dt_date,lic.lic_act_cur_cov_rule)) "FX (SC) to (LC) Actual",
                   max(x_pkg_tvf_ovg_stmt_rpt.get_nsp_rate_cc(lic.lic_v_number,fee.licf_v_sp_curr_code,fee.licf_n_selling_price,fee.licf_v_format_code,fee.licf_v_ter_name,licf_dt_date,lic.lic_act_cur_cov_rule)) "FX (LC) to (CC) Actual",
                   max(decode(fee.licf_v_format_code,''HD'',round(lic.lic_n_dp_zar_hd,2),round(lic.lic_n_dp_zar_sd,2))) "Deemed Price (LC)",
                   max(decode(fee.licf_v_format_code,''HD'',round(lic.lic_n_dp_usd_hd,2),round(lic.lic_n_dp_usd_sd,2))) "Deemed Price (CC)",
                   max(decode(con_n_fee_formula_number,3,0,4,0,round(x_pkg_tvf_ovg_stmt_rpt.get_dp_exch_rate(lic_v_number),5))) "FX (LC) to (CC) for Deemed",   -- [Ver 0.1]
                   max(licf_n_dp_fee) "Minimum Price (CC)",
                   round(sum(nvl(fee.licf_n_no_of_buys,0)),2) "No of Buys"
              FROM tbl_tvf_lic_fees fee,
                   tbl_tva_license lic,
                   fid_company cc,
                   tvod_licensee lee,
                   fid_general gen,
                   tbl_tva_contract con,
                   fid_company supp,
                   tvod_boxoffice_category cat,
                   tbl_tva_territory ter
             WHERE cc.com_number = con.con_n_com_number
               AND lee.tvod_n_lee_number = lic.lic_n_lee_number
               AND lic.lic_v_number = fee.licf_v_lic_number
               AND gen.gen_refno = lic.lic_n_gen_refno
               AND con.con_n_contract_number = lic.lic_n_con_number
               AND supp.com_number = con.con_n_supp_com_number
               AND cat.boc_v_category = lic.lic_n_bo_category
               AND ter.v_ter_code = cc.com_ter_code
               AND lic.lic_n_dm_type = 1
               AND supp.com_internal = '''|| i_report_type || '''
               AND upper(cc.com_short_name) LIKE upper(''' || i_channel_comp || ''')
               AND upper(supp.com_short_name) LIKE upper(''' || i_supp_short_name || ''')
               AND upper(con.con_v_short_name) LIKE upper(''' || i_con_short_name || ''')
               AND to_number(to_char(fee.licf_dt_date,''RRRRMM'')) <= ' || l_period || '
               AND ' || l_period || ' BETWEEN to_number(to_char(lic.lic_dt_start_date,''RRRRMM'')) AND to_number(to_char(lic.lic_dt_end_date,''RRRRMM''))
          GROUP BY cc.com_name,
                   supp.com_short_name,
                   con.con_v_short_name,
                   gen.gen_title,
                   fee.licf_v_lic_number,
                   to_char(lic.lic_dt_start_date, ''dd-Mon-yyyy''),
                   to_char(lic.lic_dt_end_date, ''dd-Mon-yyyy''),
                   to_char(lic.lic_dt_lvr, ''dd-Mon-yyyy''),
									 to_char(fee.licf_dt_date,''Mon-RRRR''),
                   lic.lic_n_day_post_lvr,
                   lic.lic_n_revenue_share_percent,
                   lic.lic_v_bo_sub_category,
                   con_v_currency,
                   ter.v_ter_cur_code,
                   fee.licf_v_ter_name,
                   fee.licf_v_sp_curr_code,
                   fee.licf_v_format_code,
                   round(fee.licf_n_actual_price,2),
                   round(fee.licf_n_selling_price,2))
  ORDER BY "Channel Company",
           "Supplier",
           "Contract",
           "Programme"';

		dbms_output.put_line (l_query);
    OPEN o_cursor FOR l_query;
  END x_prc_tvf_ovg_stmt_dtls_exl;

  PROCEDURE x_prc_tvf_ovg_stmt_summary
  (
    i_channel_comp      IN       fid_company.com_short_name%TYPE,
    i_con_short_name    IN       tbl_tva_contract.con_v_short_name%TYPE,
    i_supp_short_name   IN       fid_company.com_short_name%TYPE,
    i_period            IN       DATE,
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
           share_percentage,
           (month# ||' - '|| year#) period,
           total_fees,
           no_of_buys,
           mg,
           round((SELECT sum(nvl(fees.lictf_n_overage, 0))
                     FROM tbl_tvf_lic_totel_fees fees
                    WHERE fees.lictf_v_lic_number = lic#
                      AND fees.lictf_n_year || lpad (fees.lictf_n_month, 2, 0) <= year# || lpad (month_m, 2, 0)), 2) overage,
           selling_country,
           total_paid,
           total_unpaid
      FROM (SELECT cc.com_name channel_company,
                   lic.lic_v_currency lic_currency,
                   lt.deal_type lic_type,
                   supp.com_short_name supplier,
                   con.con_v_short_name contract,
                   tfee.lictf_v_lic_number lic#,
                   gen.gen_title programme,
                   lic.lic_n_revenue_share_percent share_percentage,
                   to_char (fee.licf_dt_date, 'MON') month#,
                   to_char (fee.licf_dt_date, 'YYYY') year#,
                   to_number (to_char (fee.licf_dt_date,'MM')) month_m,
                   round(tfee.lictf_n_total_fees,2) total_fees,
                   sum (fee.licf_n_no_of_buys) no_of_buys,
                   round(lic.lic_n_price,2) mg,
                   supp.com_ter_code selling_country,
                   MAX((SELECT sum(licp_n_amount)
                          FROM tbl_tva_lic_payments
                         WHERE licp_c_paid_status = 'P'
                           AND licp_c_ovg_payment = 'Y'
                           AND licp_v_lic_number = lic.lic_v_number
                           AND licp_dt_entry_date <= i_period)) total_paid,
                   MAX((SELECT sum(licp_n_amount)
                          FROM tbl_tva_lic_payments
                         WHERE licp_c_paid_status = 'N'
                           AND licp_c_ovg_payment = 'Y'
                           AND licp_v_lic_number = lic.lic_v_number
                           AND licp_dt_entry_date <= i_period)) total_unpaid
              FROM tbl_tvf_lic_totel_fees tfee,
                   tbl_tvf_lic_fees fee,
                   tbl_tva_license lic,
                   fid_company cc,
                   tvod_licensee lee,
                   fid_general gen,
                   tvod_deal_memo_type lt,
                   tbl_tva_contract con,
                   fid_company supp
             WHERE upper (cc.com_short_name) LIKE upper (i_channel_comp)
               AND upper (supp.com_short_name) LIKE upper (i_supp_short_name)
               AND upper (con.con_v_short_name) LIKE upper (i_con_short_name)
               AND fee.licf_n_cal_month = tfee.lictf_n_month
               AND fee.licf_n_cal_year = tfee.lictf_n_year
               AND fee.licf_v_lic_number =  tfee.lictf_v_lic_number
               AND lic.lic_v_number = tfee.lictf_v_lic_number
               AND cc.com_number = lee.tvod_n_lee_cha_com_number
               AND lee.tvod_n_lee_number = lic.lic_n_lee_number
               AND lt.dm_type_id = lic.lic_n_dm_type
               AND con.con_n_contract_number = lic.lic_n_con_number
               AND supp.com_number = con.con_n_supp_com_number
               AND gen.gen_refno = lic.lic_n_gen_refno
               AND to_number(to_char(fee.licf_dt_date,'RRRRMM')) = to_number(to_char(i_period,'RRRRMM'))
               AND to_number(to_char(i_period,'RRRRMM')) BETWEEN to_number(to_char(lic.lic_dt_start_date,'RRRRMM')) AND to_number(to_char(lic.lic_dt_end_date,'RRRRMM'))
          GROUP BY cc.com_name,
                   lic.lic_v_currency,
                   lt.deal_type,
                   supp.com_short_name,
                   con.con_v_short_name,
                   tfee.lictf_v_lic_number,
                   gen.gen_title,
                   to_char (lic.lic_dt_start_date, 'dd-Mon-yyyy'),
                   to_char (lic.lic_dt_end_date, 'dd-Mon-yyyy'),
                   lic.lic_n_revenue_share_percent,
                   to_char (fee.licf_dt_date, 'MON'),
                   to_char (fee.licf_dt_date, 'YYYY'),
                   to_number (to_char (fee.licf_dt_date,'MM')),
                   round(tfee.lictf_n_total_fees,2),
                   round(lic.lic_n_price,2),
                   supp.com_ter_code)
  ORDER BY lic_currency,
           supplier,
           programme;
  END x_prc_tvf_ovg_stmt_summary;

  PROCEDURE x_prc_tvf_ovg_stmt_summary_exl
  (
    i_channel_comp        IN       fid_company.com_short_name%TYPE,
    i_con_short_name      IN       tbl_tva_contract.con_v_short_name%TYPE,
    i_supp_short_name     IN       fid_company.com_short_name%TYPE,
    i_from_date           IN       DATE,
    i_to_date             IN       DATE,
    o_cursor              OUT      sys_refcursor
  )
  AS
  BEGIN
    OPEN o_cursor FOR
    SELECT channel_company AS "Channel Company",
           lic_currency AS "License Currency",
           lic_type AS "License Type",
           supplier "Supplier",
           contract "Contract",
           lic# "License",
           programme "Programme",
           start_date "Start Date",
           end_date "End Date",
           share_percentage "Share Percentage",
           (month# ||' - '|| year#) period,
           total_fees "Total Fees",
           no_of_buys "No of Buys",
           mg,
           round((SELECT sum(nvl(fees.lictf_n_overage, 0))
                    FROM tbl_tvf_lic_totel_fees fees
                   WHERE fees.lictf_v_lic_number = lic#
                     AND fees.lictf_n_year || lpad (fees.lictf_n_month, 2, 0) <= year# || lpad (month_m, 2, 0)), 2) overage,
           total_paid,
           total_unpaid
      FROM (SELECT cc.com_name channel_company,
                   lic.lic_v_currency lic_currency,
                   lt.deal_type lic_type,
                   supp.com_short_name supplier,
                   con.con_v_short_name contract,
                   tfee.lictf_v_lic_number lic#,
                   gen.gen_title programme,
                   to_char (lic.lic_dt_start_date, 'dd-Mon-yyyy') start_date,
                   to_char (lic.lic_dt_end_date, 'dd-Mon-yyyy') end_date,
                   lic.lic_n_revenue_share_percent share_percentage,
                   to_char (fee.licf_dt_date, 'MON') month#,
                   to_char (fee.licf_dt_date, 'YYYY') year#,
                   to_number (to_char (fee.licf_dt_date,'MM')) month_m,
                   round(tfee.lictf_n_total_fees,2) total_fees,
                   sum (fee.licf_n_no_of_buys) no_of_buys,
                   round(lic.lic_n_price,2) mg,
                   (SELECT sum(licp_n_amount)
                      FROM tbl_tva_lic_payments
                     WHERE licp_c_paid_status = 'P'
                       AND licp_c_ovg_payment = 'Y'
                       AND licp_dt_entry_date <= i_from_date) total_paid,
                   (SELECT sum(licp_n_amount)
                      FROM tbl_tva_lic_payments
                     WHERE licp_c_paid_status = 'N'
                       AND licp_c_ovg_payment = 'Y'
                       AND licp_dt_entry_date <= i_from_date) total_unpaid
              FROM tbl_tvf_lic_totel_fees tfee,
                   tbl_tvf_lic_fees fee,
                   tbl_tva_license lic,
                   fid_company cc,
                   tvod_licensee lee,
                   fid_general gen,
                   tvod_deal_memo_type lt,
                   tbl_tva_contract con,
                   fid_company supp
             WHERE upper (cc.com_short_name) LIKE upper (i_channel_comp)
               AND upper (supp.com_short_name) LIKE upper (i_supp_short_name)
               AND upper (con.con_v_short_name) LIKE upper (i_con_short_name)
               AND fee.licf_n_cal_month = tfee.lictf_n_month
               AND fee.licf_n_cal_year = tfee.lictf_n_year
               AND fee.licf_v_lic_number =  tfee.lictf_v_lic_number
               AND lic.lic_v_number = tfee.lictf_v_lic_number
               AND cc.com_number = con.con_n_com_number
               AND lee.tvod_n_lee_number = lic.lic_n_lee_number
               AND lt.dm_type_id = lic.lic_n_dm_type
               AND con.con_n_contract_number = lic.lic_n_con_number
               AND supp.com_number = con.con_n_supp_com_number
               AND gen.gen_refno = lic.lic_n_gen_refno
               AND to_number(to_char(fee.licf_dt_date,'RRRRMM')) = to_number(to_char(i_from_date,'RRRRMM'))
               AND to_number(to_char(i_from_date,'RRRRMM')) BETWEEN to_number(to_char(lic.lic_dt_start_date,'RRRRMM')) AND to_number(to_char(lic.lic_dt_end_date,'RRRRMM'))
          GROUP BY cc.com_name,
                   lic.lic_v_currency,
                   lt.deal_type,
                   supp.com_short_name,
                   con.con_v_short_name,
                   tfee.lictf_v_lic_number,
                   gen.gen_title,
                   to_char (lic.lic_dt_start_date, 'dd-Mon-yyyy'),
                   to_char (lic.lic_dt_end_date, 'dd-Mon-yyyy'),
                   lic.lic_n_revenue_share_percent,
                   to_char (fee.licf_dt_date, 'MON'),
                   to_char (fee.licf_dt_date, 'YYYY'),
                   to_number (to_char (fee.licf_dt_date,'MM')),
                   round(licf_n_ap_fee,2),
                   round(licf_n_dp_fee,2),
                   round(tfee.lictf_n_total_fees,2),
                   lic.lic_n_price)
  ORDER BY lic_currency,
           supplier,
           programme;
  END x_prc_tvf_ovg_stmt_summary_exl;

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
            AP_EXCH_RATE_DATE :=  I_DATE;
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
  FUNCTION get_dp_exch_rate
  (
    i_lic_number IN VARCHAR2
  )
  RETURN NUMBER
  AS
    l_exch_rate               NUMBER;
    dp_exch_rate_src          NUMBER;
    l_con_exch_rate           NUMBER;
    dp_exch_rate_date         DATE;
    l_dp_exch_rate            NUMBER;
    dp_zar_spot_rate          NUMBER;
    dp_in_zar                 NUMBER;
    dp_usd_spot_rate          NUMBER;
    dp_in_usd                 NUMBER;
    l_lic_dt_start_date       tbl_tva_license.lic_dt_start_date%TYPE;
    l_lic_v_currency          tbl_tva_license.lic_v_currency%TYPE;
    l_lic_n_dp_exch_rate_src  tbl_tva_license.lic_n_ap_exch_rate_src%TYPE;
    l_lic_n_dp_cov_rule       tbl_tva_license.lic_n_dp_cov_rule%TYPE;
    l_lic_dt_dp_review_date   tbl_tva_license.lic_dt_dp_review_date%TYPE;
    l_lic_n_dp_usd_zar_rate   tbl_tva_license.lic_n_dp_usd_zar_rate%TYPE;
  BEGIN
    SELECT lic_dt_start_date,
           lic_v_currency,
           lic_n_ap_exch_rate_src,
           lic_n_dp_cov_rule,
           lic_dt_dp_review_date,
           lic_n_dp_usd_zar_rate
      INTO l_lic_dt_start_date,
           l_lic_v_currency,
           l_lic_n_dp_exch_rate_src,
           l_lic_n_dp_cov_rule,
           l_lic_dt_dp_review_date,
           l_lic_n_dp_usd_zar_rate
      FROM tbl_tva_license
     WHERE lic_v_number = i_lic_number;

    IF l_lic_n_dp_exch_rate_src IS NOT NULL
    THEN
      dp_exch_rate_src := l_lic_n_dp_exch_rate_src;
    ELSE
      dp_exch_rate_src := 1;
    END IF;

    IF l_lic_n_dp_cov_rule = 1 OR l_lic_n_dp_cov_rule = 2
    THEN
      dp_exch_rate_date := l_lic_dt_dp_review_date;
    ELSIF l_lic_n_dp_cov_rule = 3 OR l_lic_n_dp_cov_rule = 4
    THEN
      dp_exch_rate_date := l_lic_dt_start_date;
    ELSIF l_lic_n_dp_cov_rule = 5 OR l_lic_n_dp_cov_rule = 6
    THEN
      dp_exch_rate_date := trunc(l_lic_dt_start_date,'MONTH');
    END IF;
    --- To find out rate on the date of conversion rule

    IF l_lic_n_dp_cov_rule = 7 THEN
      l_dp_exch_rate := l_lic_n_dp_usd_zar_rate;
    ELSE
      l_dp_exch_rate := get_spot_rate('USD', 'ZAR', dp_exch_rate_date, dp_exch_rate_src, l_lic_n_dp_cov_rule);
    END IF;

    RETURN l_dp_exch_rate;
  END get_dp_exch_rate;

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
    perday := to_char(rate_date, 'DD');
    permonth := to_char(rate_date, 'MM');
    peryear := to_char(rate_date, 'YYYY');

    BEGIN
       IF fromcurr = tocurr
       THEN
          spotrate := 1;
       ELSE
         SELECT round(spo_n_rate,5)   -- [Ver 0.1]
           INTO spotrate
           FROM tbl_tvf_spot_rate
          WHERE spo_v_cur_code = fromcurr
            AND spo_v_cur_code_2 = tocurr
            AND spo_n_per_day = perday
            AND spo_n_per_month = permonth
            AND spo_n_per_year = peryear
            AND spo_n_srs_id = i_spo_n_srs_id;
       END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
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
    END;
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

  FUNCTION get_net_selling_price
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE
  )
  RETURN NUMBER
  AS
    l_net_selling_price     NUMBER;
  BEGIN
    SELECT sum(licb_net_selling_price)
      INTO l_net_selling_price
      FROM tbl_tvf_lic_buys
     WHERE licb_v_lic_number = i_lic_number
       AND licb_v_ter_code = i_selling_ter
       AND licb_v_format_code = i_format
       AND licb_n_actual_price = i_selling_price
       AND to_char(licb_dt_date,'RRRRMM') = to_char(i_period_date,'RRRRMM')
       AND licb_v_ap_curr_code = i_selling_curr;

    RETURN l_net_selling_price;
  EXCEPTION
    WHEN no_data_found
    THEN RETURN NULL;
  END get_net_selling_price;

  FUNCTION get_net_selling_price_zar
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE,
    i_cur_conv_rule   IN  tbl_tva_license.lic_act_cur_cov_rule%TYPE
  )
  RETURN NUMBER
  AS
    l_net_selling_price     NUMBER;
  BEGIN
    SELECT (CASE WHEN i_cur_conv_rule = 1
                 THEN 0
            ELSE sum(licb_net_selling_price * licb_n_exch_rate_usd)
            END)
      INTO l_net_selling_price
      FROM tbl_tvf_lic_buys
     WHERE licb_v_lic_number = i_lic_number
       AND licb_v_ter_code = i_selling_ter
       AND licb_v_format_code = i_format
       AND licb_n_actual_price = i_selling_price
       AND to_char(licb_dt_date,'RRRRMM') = to_char(i_period_date,'RRRRMM')
       AND licb_v_ap_curr_code = i_selling_curr;

    RETURN l_net_selling_price;
  EXCEPTION
    WHEN no_data_found
    THEN RETURN NULL;
  END get_net_selling_price_zar;

  FUNCTION get_net_selling_price_cc
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE,
    i_cur_conv_rule   IN  tbl_tva_license.lic_act_cur_cov_rule%TYPE
  )
  RETURN NUMBER
  AS
    l_net_selling_price     NUMBER;
  BEGIN
    SELECT sum(CASE WHEN i_cur_conv_rule = 1
                    THEN licb_net_selling_price * licb_n_exch_rate_usd
               ELSE (licb_net_selling_price * (SELECT aspo_n_avg_rate
                                                 FROM tbl_tvf_avg_spot_rate
                                                WHERE aspo_v_cur_code_1 = i_selling_curr
                                                  AND aspo_v_cur_code_2 = 'ZAR'
                                                  AND aspo_n_year || lpad(aspo_n_month,2,0) = to_char(i_period_date,'RRRRMM'))) * licb_n_exch_rate_usd
               END)
      INTO l_net_selling_price
      FROM tbl_tvf_lic_buys
     WHERE licb_v_lic_number = i_lic_number
       AND licb_v_ter_code = i_selling_ter
       AND licb_v_format_code = i_format
       AND licb_n_actual_price = i_selling_price
       AND to_char(licb_dt_date,'RRRRMM') = to_char(i_period_date,'RRRRMM')
       AND licb_v_ap_curr_code = i_selling_curr;

    RETURN l_net_selling_price;
  EXCEPTION
    WHEN no_data_found
    THEN RETURN 0;
  END get_net_selling_price_cc;

  FUNCTION get_nsp_rate_zar
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE,
    i_cur_conv_rule   IN  tbl_tva_license.lic_act_cur_cov_rule%TYPE
  )
  RETURN NUMBER
  AS
    l_sp_rate     NUMBER;
  BEGIN
    IF i_selling_curr = 'ZAR'
    THEN
      l_sp_rate := 1;
    ELSE
      IF i_cur_conv_rule = 1
      THEN
        l_sp_rate := 0;
      ELSE
        SELECT round(1/aspo_n_avg_rate,5)   -- [Ver 0.1]
          INTO l_sp_rate
          FROM tbl_tvf_avg_spot_rate
         WHERE aspo_v_cur_code_1 = i_selling_curr
           AND aspo_v_cur_code_2 = 'ZAR'
           AND aspo_n_year || lpad(aspo_n_month,2,0) = to_char(i_period_date,'RRRRMM');
      END IF;
    END IF;

    RETURN l_sp_rate;
  EXCEPTION
    WHEN no_data_found
    THEN RETURN 0;
  END get_nsp_rate_zar;

  FUNCTION get_nsp_rate_cc
  (
    i_lic_number      IN  tbl_tva_license.lic_v_number%TYPE,
    i_selling_curr    IN  tbl_tvf_lic_fees.licf_v_sp_curr_code%TYPE,
    i_selling_price   IN  tbl_tvf_lic_fees.licf_n_selling_price%TYPE,
    i_format          IN  tbl_tvf_lic_fees.licf_v_format_code%TYPE,
    i_selling_ter     IN  tbl_tvf_lic_fees.licf_v_ter_name%TYPE,
    i_period_date     IN  DATE,
    i_cur_conv_rule   IN  tbl_tva_license.lic_act_cur_cov_rule%TYPE
  )
  RETURN NUMBER
  AS
    l_sp_rate     NUMBER;
  BEGIN
    SELECT round((1/licb_n_exch_rate_usd),5)   -- [Ver 0.1]
      INTO l_sp_rate
      FROM tbl_tvf_lic_buys
     WHERE licb_v_lic_number = i_lic_number
       AND licb_v_ter_code = i_selling_ter
       AND licb_v_format_code = i_format
       AND licb_n_actual_price = i_selling_price
       AND to_char(licb_dt_date,'RRRRMM') = to_char(i_period_date,'RRRRMM')
       AND licb_v_ap_curr_code = i_selling_curr
       AND rownum < 2;

    RETURN l_sp_rate;
 EXCEPTION
    WHEN no_data_found
    THEN RETURN 0;
  END get_nsp_rate_cc;
END x_pkg_tvf_ovg_stmt_rpt;
/