CREATE OR REPLACE PACKAGE PKG_TVF_OUT_LIAB_RPT
AS

/****************************************************************
REM Module          : TVOD Finance Module
REM Client          : MNET
REM File Name       : PKG_TVF_OUT_LIAB_RPT.sql
REM Form Name       : Outstanding Liability Report
REM Purpose         : This report gives outstanding liability
REM Author          : Ajitkumar Tanwade
REM Creation Date   : 27 Sep 2011
REM Type            : Database Package
REM Change History  :
****************************************************************/

  TYPE c_fin_rep IS REF CURSOR;

--****************************************************************
-- This procedure outputs Outstanding Liability.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_fin_out_liab_reports
  (
    i_rpt_sub_type      IN      VARCHAR2,
    i_channel_company   IN      fid_company.com_name%TYPE,
    i_lic_type          IN      tvod_deal_memo_type.deal_type%TYPE,
    i_licensee          IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    i_budget_code       IN      tbl_tva_license.lic_v_budget_type%TYPE,
    i_supp_short_name   IN      fid_company.com_short_name%TYPE,
    i_con_short_name    IN      tbl_tva_contract.con_v_short_name%TYPE,
    i_include_zeros     IN      VARCHAR2,
    i_period_date       IN      VARCHAR2,
    i_summ_flag         IN      VARCHAR2,
    o_liab_report          OUT  pkg_tvf_out_liab_rpt.c_fin_rep
  );

--****************************************************************
-- This procedure outputs Outstanding Liability Summary.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_fin_out_liab_summ_reports
  (
    i_rpt_sub_type      IN      VARCHAR2,
    i_channel_company   IN      fid_company.com_name%TYPE,
    i_lic_type          IN      tvod_deal_memo_type.deal_type%TYPE,
    i_licensee          IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    i_budget_code       IN      tbl_tva_license.lic_v_budget_type%TYPE,
    i_include_zeros     IN      VARCHAR2,
    i_period_date       IN      VARCHAR2,
    o_liab_report          OUT  pkg_tvf_out_liab_rpt.c_fin_rep
  );

--****************************************************************
-- This procedure outputs Outstanding Liability which is then exported to excel.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_fin_out_liab_exp_to_exl
  (
    i_rpt_sub_type      IN      VARCHAR2,
    i_channel_company   IN      fid_company.com_name%TYPE,
    i_lic_type          IN      tvod_deal_memo_type.deal_type%TYPE,
    i_licensee          IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    i_budget_code       IN      tbl_tva_license.lic_v_budget_type%TYPE,
    i_supp_short_name   IN      fid_company.com_short_name%TYPE,
    i_con_short_name    IN      tbl_tva_contract.con_v_short_name%TYPE,
    i_include_zeros     IN      VARCHAR2,
    i_period_date       IN      VARCHAR2,
    o_liab_report          OUT  pkg_tvf_out_liab_rpt.c_fin_rep
  );

--****************************************************************
-- This procedure outputs Outstanding Liability which is then exported to excel.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_fin_out_liab_summ_excel
  (
    i_rpt_sub_type      IN      VARCHAR2,
    i_channel_company   IN      fid_company.com_name%TYPE,
    i_lic_type          IN      tvod_deal_memo_type.deal_type%TYPE,
    i_licensee          IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    i_budget_code       IN      tbl_tva_license.lic_v_budget_type%TYPE,
    i_include_zeros     IN      VARCHAR2,
    i_period_date       IN      VARCHAR2,
    o_liab_report          OUT  pkg_tvf_out_liab_rpt.c_fin_rep
  );

--****************************************************************
-- This function outputs amount paid for license.
-- REM Client - MNET
--****************************************************************
  FUNCTION fun_tvf_fees_paid
  (
    i_lic_number     IN   tbl_tva_lic_payments.licp_v_lic_number%TYPE,
    i_con_number     IN   tbl_tva_contract.con_n_contract_number%TYPE,
    i_lic_currency   IN   tbl_tva_lic_payments.licp_v_currency%TYPE,
    i_for_ovg        IN   VARCHAR2,
    i_period_date    IN   VARCHAR2
  )
  RETURN NUMBER;

  FUNCTION fun_tvf_fees_paid_rev
  (
    i_lic_number     IN   tbl_tva_lic_payments.licp_v_lic_number%TYPE,
    i_con_number     IN   tbl_tva_contract.con_n_contract_number%TYPE,
    i_lic_currency   IN   tbl_tva_lic_payments.licp_v_currency%TYPE,
    i_for_ovg        IN   VARCHAR2,
    i_period_date    IN   VARCHAR2
  )
  RETURN NUMBER;

  FUNCTION x_fun_tvf_mg_lic_curr
  (
    i_lic_number    IN  tbl_tva_license.lic_v_number%TYPE,
    i_period        IN  NUMBER
  )
  RETURN NUMBER;

  FUNCTION x_fun_tvf_ovg_lic_curr
  (
    i_lic_number    IN  tbl_tva_license.lic_v_number%TYPE,
    i_period        IN  NUMBER
  )
  RETURN NUMBER;

  FUNCTION fun_tvf_cal_spot_rate
  (
    i_lic_curr		      IN    tbl_tva_lic_payments.licp_v_currency%TYPE,
    i_cc_curr		        IN    tbl_tva_lic_payments.licp_v_currency%TYPE,
    i_period_date		    IN    VARCHAR2,
    i_spot_rate_source	IN    VARCHAR2,
    i_rep_sub_type      IN    VARCHAR2,
    i_lic_start_date    IN    tbl_tva_license.lic_dt_start_date%TYPE
  )
  RETURN NUMBER;

  --Added : to check pay date is holiday or not
  FUNCTION holiday_exists
  (
    i_pay_pay_date   IN    DATE
  )
  RETURN NUMBER;
END PKG_TVF_OUT_LIAB_RPT;
/
CREATE OR REPLACE PACKAGE BODY PKG_TVF_OUT_LIAB_RPT
AS
--****************************************************************
-- This procedure outputs Outstanding Liability.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_fin_out_liab_reports
  (
    i_rpt_sub_type      IN      VARCHAR2,
    i_channel_company   IN      fid_company.com_name%TYPE,
    i_lic_type          IN      tvod_deal_memo_type.deal_type%TYPE,
    i_licensee          IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    i_budget_code       IN      tbl_tva_license.lic_v_budget_type%TYPE,
    i_supp_short_name   IN      fid_company.com_short_name%TYPE,
    i_con_short_name    IN      tbl_tva_contract.con_v_short_name%TYPE,
    i_include_zeros     IN      VARCHAR2,
    i_period_date       IN      VARCHAR2,
    i_summ_flag         IN      VARCHAR2,
    o_liab_report          OUT  pkg_tvf_out_liab_rpt.c_fin_rep
  )
  AS
    l_query     VARCHAR2(11000);
    l_period    NUMBER := to_number(to_char(to_date(i_period_date,'MM/DD/YYYY'),'YYYYMM'));
  BEGIN
    l_query := '
           SELECT channel_company,
                  lic_currency,
                  lic_type,
                  lee,
                  cc_currency,
                  budg,
                  supplier,
                  contract,
                  lic#,
                  programme,
                  acct,
                  start_date,
                  end_date,
                  amort,
                  total_fees_in_lic_curr,
                  mg_in_lic_curr,
                  fees_paid,
                  mg_liab_in_lic_curr,
                  spot_rate,
                  mg_liab_in_cc_curr,
                  ovg_in_lic_curr,
                  ovg_paid,
                  ovg_liab_in_lic_curr,
                  ovg_spot_rate,
                  ovg_liab_in_cc_curr,
                  round((mg_liab_in_lic_curr + ovg_liab_in_lic_curr),4) total_lic_curr,
                  round((mg_liab_in_cc_curr + ovg_liab_in_cc_curr),4) total_cc_curr
             FROM (SELECT channel_company,
                          lic#,
                          lic_currency,
                          lic_type,
                          lee,
                          cc_currency,
                          budg,
                          supplier,
                          contract,
                          programme,
                          acct,
                          start_date,
                          end_date,
                          amort,
                          (mg_in_lic_curr + ovg_in_lic_curr) total_fees_in_lic_curr,
                          mg_in_lic_curr,
                          fees_paid,
                          (inv - fees_paid) mg_liab_in_lic_curr,
                          decode(spot_rate,NULL,''0'',spot_rate) spot_rate,
                          (CASE WHEN inv  - fees_paid < 0
                                THEN (inv * spot_rate) - l_fees_paid_rev
                           ELSE ((inv  - fees_paid)* spot_rate)
                           END) mg_liab_in_cc_curr,
                          ovg_in_lic_curr,
                          ovg_paid,
                          (ovg_in_lic_curr - ovg_paid) ovg_liab_in_lic_curr,
                          decode(spot_rate,NULL,''0'',spot_rate) ovg_spot_rate,
                          decode(((ovg_in_lic_curr - ovg_paid) * spot_rate),NULL,''0'',((ovg_in_lic_curr - ovg_paid) * spot_rate)) ovg_liab_in_cc_curr
                     FROM (SELECT cc.com_name channel_company,
                                  lic.lic_v_number lic#,
                                  lic.lic_v_currency lic_currency,
                                  lt.deal_type lic_type,
                                  lee.tvod_v_lee_short_name lee,
                                  tt.v_ter_cur_code cc_currency,
                                  lic.lic_v_budget_type budg,
                                  supp.com_short_name supplier,
                                  lic.lic_n_con_number con_number,
                                  con.con_v_short_name contract,
                                  gen.gen_title programme,
                                  lic.lic_dt_account_date acct,
                                  to_date(x_pkg_tvf_rpt_common.get_start_date(lic.lic_v_number,lic.lic_dt_start_date,' || l_period || ',''DD-Mon-RRRR'')) start_date,
                                  to_date(x_pkg_tvf_rpt_common.get_end_date(lic.lic_v_number,lic.lic_dt_end_date,' || l_period || ',''DD-Mon-RRRR'')) end_date,
                                  pkg_tvf_out_liab_rpt.x_fun_tvf_mg_lic_curr(lic.lic_v_number,' || l_period || ') inv,
                                  lic.lic_v_amort_code amort,
                                  x_pkg_tvf_rpt_common.get_lic_price(lic.lic_v_number,lic.lic_n_price,' || l_period || ') mg_in_lic_curr,
                                  pkg_tvf_out_liab_rpt.x_fun_tvf_ovg_lic_curr(lic.lic_v_number,' || l_period || ') ovg_in_lic_curr,
                                  round(pkg_tvf_out_liab_rpt.fun_tvf_fees_paid(lic.lic_v_number,lic.lic_n_con_number,lic.lic_v_currency,''N'',''' || i_period_date || '''),4) fees_paid,
                                  round(pkg_tvf_out_liab_rpt.fun_tvf_fees_paid_rev(lic.lic_v_number,lic.lic_n_con_number,lic.lic_v_currency,''N'',''' || i_period_date || '''),4) l_fees_paid_rev,
                                  round(pkg_tvf_out_liab_rpt.fun_tvf_fees_paid(lic.lic_v_number,lic.lic_n_con_number,lic.lic_v_currency,''Y'',''' || i_period_date || '''),4) ovg_paid,
                                  decode(lic.lic_v_currency,''ZAR'',1,(pkg_tvf_out_liab_rpt.fun_tvf_cal_spot_rate(lic.lic_v_currency,tt.v_ter_cur_code,''' || i_period_date || ''',lic.lic_n_ap_exch_rate_src,''' || i_rpt_sub_type || ''',lic.lic_dt_start_date))) spot_rate
                             FROM tbl_tva_license lic,
                                  fid_company cc,
                                  tvod_deal_memo_type lt,
                                  tvod_licensee lee,
                                  tbl_tva_territory tt,
                                  tbl_tva_contract con,
                                  fid_company supp,
                                  fid_general gen
                            WHERE upper(cc.com_short_name) LIKE upper(''' || i_channel_company || ''')
                              AND upper(lt.deal_type) LIKE upper(''' || i_lic_type || ''')
                              AND upper(lee.tvod_v_lee_short_name) LIKE upper(''' || i_licensee || ''')
                              AND upper(lic.lic_v_budget_type) LIKE upper(''' || i_budget_code || ''')
                              AND upper(supp.com_short_name) LIKE upper(''' || i_supp_short_name || ''')
                              AND upper(con.con_v_short_name) LIKE upper(''' || i_con_short_name || ''')
                              AND gen.gen_refno = lic.lic_n_gen_refno
                              AND supp.com_number = con.con_n_supp_com_number
                              AND con.con_n_contract_number = lic.lic_n_con_number
                              AND tt.v_ter_code = cc.com_ter_code
                              AND cc.com_number = con.con_n_com_number
                              AND lt.dm_type_id = lic.lic_n_dm_type
                              AND lee.tvod_n_lee_number = lic.lic_n_lee_number
                              AND lic.lic_dt_account_date IS NOT NULL
                              AND x_pkg_tvf_rpt_common.get_start_date(lic.lic_v_number,lic.lic_dt_start_date,' || l_period || ',''DD-Mon-RRRR'') <= last_day (to_date (''' || i_period_date || ''',''MM/DD/YYYY''))
                              AND lic.lic_dt_account_date <= to_date(''' || i_period_date || ''',''MM/DD/YYYY'')
                              AND (EXISTS (SELECT 1
                                             FROM tbl_tvf_license_sub_ledger
                                            WHERE lis_n_per_year || lpad (lis_n_per_month, 2, 0) = ' || l_period || '
                                              AND lis_v_lic_number = lic.lic_v_number)
                                OR (SELECT to_char(max(nvl(licp_dt_payment_date,to_date(''31-Dec-2199''))),''RRRRMM'')
                                      FROM tbl_tva_lic_payments
                                     WHERE licp_v_lic_number = lic.lic_v_number) >= ' || l_period || '))';
    IF i_include_zeros = 'N'
    THEN
      l_query := l_query || '
                    WHERE (mg_in_lic_curr + ovg_in_lic_curr - fees_paid) <> 0';
    END IF;

    l_query := l_query || '
                      )
         ORDER BY lic_currency,
                  lic_type,
                  budg,
                  programme,
                  lee';

    IF i_summ_flag <> 'Y'
    THEN
      OPEN o_liab_report FOR l_query;
    ELSE
      l_query := 'insert into  tbl_tvf_out_lib_summ(
                                                    ols_v_channel_company,
                                                    ols_v_lic_currency,
                                                    ols_v_lic_type,
                                                    ols_v_lic_lee,
                                                    ols_v_cc_currency,
                                                    ols_v_lic_bud_type,
                                                    ols_v_supplier,
                                                    ols_v_contract,
                                                    ols_v_lic_number,
                                                    ols_v_prog_title,
                                                    ols_dt_acct_date,
                                                    ols_dt_start_date,
                                                    ols_dt_end_date,
                                                    ols_v_amort_code,
                                                    ols_n_total_fee_lic_curr,
                                                    ols_n_mg_lic_curr,
                                                    ols_n_mg_paid_lic_curr,
                                                    ols_n_mg_lib_lic_curr,
                                                    ols_n_mg_spot_rate,
                                                    ols_n_mg_lib_cc_curr,
                                                    ols_n_ovg_lic_curr,
                                                    ols_n_ovg_pid_lic_curr,
                                                    ols_n_ovg_lib_lic_curr,
                                                    ols_n_ovg_spot_rate,
                                                    ols_n_ovg_lib_cc_curr,
                                                    ols_n_tot_lib_lic_curr,
                                                    ols_n_tot_lib_cc_curr
                                                   )
                                                   ' || l_query;

      DELETE FROM tbl_tvf_out_lib_summ;

      EXECUTE IMMEDIATE l_query;
      COMMIT;

      OPEN o_liab_report FOR
      SELECT ols_v_channel_company channel_company,
             ols_v_lic_currency lic_currency,
             ols_v_lic_type lic_type,
             ols_v_lic_lee lee,
             ols_v_cc_currency  cc_currency,
             ols_v_lic_bud_type budg,
             ols_v_supplier supplier,
             ols_v_contract contract,
             ols_v_lic_number lic#,
             ols_v_prog_title programme,
             ols_v_amort_code amort,
             ols_dt_acct_date acct,
             ols_dt_start_date start_date,
             ols_dt_end_date  end_date,
             ols_n_total_fee_lic_curr total_fees_in_lic_curr,
             ols_n_mg_lic_curr mg_in_lic_curr,
             ols_n_mg_paid_lic_curr fees_paid,
             ols_n_mg_lib_lic_curr mg_liab_in_lic_curr,
             ols_n_mg_spot_rate spot_rate,
             ols_n_mg_lib_cc_curr mg_liab_in_cc_curr,
             ols_n_ovg_lic_curr ovg_in_lic_curr,
             ols_n_ovg_pid_lic_curr ovg_paid,
             ols_n_ovg_lib_lic_curr ovg_liab_in_lic_curr,
             ols_n_ovg_spot_rate ovg_spot_rate,
             ols_n_ovg_lib_cc_curr ovg_liab_in_cc_curr,
             ols_n_tot_lib_lic_curr total_lic_curr,
             ols_n_tot_lib_cc_curr  total_cc_curr
        FROM tbl_tvf_out_lib_summ;
    END IF;
  END prc_fin_out_liab_reports;

--****************************************************************
-- This procedure outputs Outstanding Liability Summary.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_fin_out_liab_summ_reports
  (
    i_rpt_sub_type      IN      VARCHAR2,
    i_channel_company   IN      fid_company.com_name%TYPE,
    i_lic_type          IN      tvod_deal_memo_type.deal_type%TYPE,
    i_licensee          IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    i_budget_code       IN      tbl_tva_license.lic_v_budget_type%TYPE,
    i_include_zeros     IN      VARCHAR2,
    i_period_date       IN      VARCHAR2,
    o_liab_report          OUT  pkg_tvf_out_liab_rpt.c_fin_rep
  )
  AS
  BEGIN
    OPEN o_liab_report FOR
    SELECT ols_v_channel_company,
           ols_v_lic_type,
           ols_v_lic_lee,
           ols_v_lic_bud_type,
           ols_v_lic_currency,
           ols_v_cc_currency,
           sum(round(ols_n_total_fee_lic_curr,4)) sum_ols_n_total_fee_lic_curr_,
           sum(round(ols_n_mg_lic_curr,4)) sum_ols_n_mg_lic_curr_,
           sum(round(ols_n_mg_paid_lic_curr,4)) sum_ols_n_mg_paid_lic_curr_,
           sum(round(ols_n_mg_lib_lic_curr,4)) sum_ols_n_mg_lib_lic_curr_,
           sum(round(ols_n_mg_lib_cc_curr,4)) sum_ols_n_mg_lib_cc_curr_,
           sum(round(ols_n_ovg_lic_curr,4)) sum_ols_n_ovg_lic_curr_,
           sum(round(ols_n_ovg_pid_lic_curr,4)) sum_ols_n_ovg_pid_lic_curr_,
           sum(round(ols_n_ovg_lib_lic_curr,4)) sum_ols_n_ovg_lib_lic_curr_,
           sum(round(ols_n_ovg_lib_cc_curr,4)) sum_ols_n_ovg_lib_cc_curr_,
           sum(round(ols_n_tot_lib_lic_curr,4)) sum_ols_n_tot_lib_lic_curr_,
           sum(round(ols_n_tot_lib_cc_curr,4)) sum_ols_n_tot_lib_cc_curr_
      FROM tbl_tvf_out_lib_summ
     WHERE upper(ols_v_channel_company) LIKE upper(i_channel_company)
       AND upper(ols_v_lic_type) LIKE upper(i_lic_type)
       AND upper(ols_v_lic_lee) LIKE upper(i_licensee)
       AND upper(ols_v_lic_bud_type) LIKE upper(i_budget_code)
  GROUP BY ols_v_channel_company,
           ols_v_lic_type,
           ols_v_lic_lee,
           ols_v_lic_bud_type,
           ols_v_lic_currency,
           ols_v_cc_currency
  ORDER BY ols_v_channel_company,
           ols_v_lic_type,
           ols_v_lic_lee,
           ols_v_lic_bud_type,
           ols_v_lic_currency,
           ols_v_cc_currency;
  END prc_fin_out_liab_summ_reports;

--****************************************************************
-- This procedure outputs Outstanding Liability which is then exported to excel.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_fin_out_liab_exp_to_exl
  (
    i_rpt_sub_type      IN      VARCHAR2,
    i_channel_company   IN      fid_company.com_name%TYPE,
    i_lic_type          IN      tvod_deal_memo_type.deal_type%TYPE,
    i_licensee          IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    i_budget_code       IN      tbl_tva_license.lic_v_budget_type%TYPE,
    i_supp_short_name   IN      fid_company.com_short_name%TYPE,
    i_con_short_name    IN      tbl_tva_contract.con_v_short_name%TYPE,
    i_include_zeros     IN      VARCHAR2,
    i_period_date       IN      VARCHAR2,
    o_liab_report          OUT  pkg_tvf_out_liab_rpt.c_fin_rep
  )
  AS
    l_query     VARCHAR2(11000);
    l_period    NUMBER := to_number(to_char(to_date(i_period_date,'MM/DD/YYYY'),'YYYYMM'));
  BEGIN
    l_query := '
    SELECT channel_company "Channel Company",
           lic_currency "Lic Currency",
           lic_type "Lic Type",
           supplier "Supplier",
           budg "Budget Code",
           contract "Contract",
           programme "Programme",
           lee "Licensee",
           lic# "License #",
           amort "Amort Code",
           to_char(acct,''dd-mon-yyyy'') "Acct Date",
           to_char(start_date,''dd-mon-yyyy'') "License Start Date",
           to_char(end_date,''dd-mon-yyyy'') "License End Date",
           round((mg_in_lic_curr + ovg_in_lic_curr),2) "Total Lic Fee (Lic Curr)",
           round(mg_in_lic_curr,2) "MG (Lic Curr)",
           round(fees_paid,2) "MG Paid (Lic Curr)",
           round(mg_liab_in_lic_curr,2) "MG Liability (Lic Curr)",
           round(spot_rate,5) "Exch. Rate for MG",   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
           round(mg_liab_in_cc_curr,2) "MG Liability (Loc Curr)",
           round(ovg_in_lic_curr,2) "Ovg (Lic Curr)",
           round(ovg_paid,2)  "Ovg Paid (Lic Curr)",
           round(ovg_liab_in_lic_curr,2) "Ovg Liability (Lic Curr)",
           round(ovg_spot_rate,5) "Exch. Rate for Ovg",   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
           round(ovg_liab_in_cc_curr,4) "Ovg Liability (Loc Curr)"
      FROM (SELECT channel_company,
                   lic#,
                   lic_currency,
                   lic_type,
                   lee,
                   cc_currency,
                   budg,
                   supplier,
                   contract,
                   programme,
                   acct,
                   start_date,
                   end_date,
                   amort,
                   (mg_in_lic_curr + ovg_in_lic_curr) total_fees_in_lic_curr,
                   mg_in_lic_curr,
                   fees_paid,
                   (inv - fees_paid) mg_liab_in_lic_curr,
                   decode(spot_rate,NULL,''0'',spot_rate) spot_rate,
                   (CASE WHEN inv  - fees_paid < 0
                         THEN inv * spot_rate  - l_fees_paid_rev
                    ELSE ((inv  - fees_paid)* spot_rate)
                    END) mg_liab_in_cc_curr,
                   ovg_in_lic_curr,
                   ovg_paid,
                   (ovg_in_lic_curr - ovg_paid) ovg_liab_in_lic_curr,
                   decode(spot_rate,NULL,''0'',spot_rate) ovg_spot_rate,
                   decode (((ovg_in_lic_curr - ovg_paid) * spot_rate),NULL,''0'',((ovg_in_lic_curr - ovg_paid) * spot_rate)) ovg_liab_in_cc_curr
              FROM (SELECT cc.com_name channel_company,
                           lic.lic_v_number lic#,
                           lic.lic_v_currency lic_currency,
                           lt.deal_type lic_type,
                           lee.tvod_v_lee_short_name lee,
                           tt.v_ter_cur_code cc_currency,
                           lic.lic_v_budget_type budg,
                           supp.com_short_name supplier,
                           lic.lic_n_con_number con_number,
                           con.con_v_short_name contract,
                           gen.gen_title programme,
                           lic.lic_dt_account_date acct,
                           x_pkg_tvf_rpt_common.get_start_date(lic.lic_v_number,lic.lic_dt_start_date,' || l_period || ',''DD-Mon-RRRR'') start_date,
                           x_pkg_tvf_rpt_common.get_end_date(lic.lic_v_number,lic.lic_dt_end_date,' || l_period || ',''DD-Mon-RRRR'') end_date,
                           lic.lic_v_amort_code amort,
                           x_pkg_tvf_rpt_common.get_lic_price(lic.lic_v_number,lic.lic_n_price,' || l_period || ') mg_in_lic_curr,
                           pkg_tvf_out_liab_rpt.x_fun_tvf_ovg_lic_curr(lic.lic_v_number,' || l_period || ') ovg_in_lic_curr,
                           pkg_tvf_out_liab_rpt.x_fun_tvf_mg_lic_curr(lic.lic_v_number,' || l_period || ') inv,
                           round(pkg_tvf_out_liab_rpt.fun_tvf_fees_paid(lic.lic_v_number,
                                                                        lic.lic_n_con_number,
                                                                        lic.lic_v_currency,
                                                                        ''N'',
                                                                        ''' || i_period_date || '''),4) fees_paid,
                           round(pkg_tvf_out_liab_rpt.fun_tvf_fees_paid_rev(lic.lic_v_number,
                                                                            lic.lic_n_con_number,
                                                                            lic.lic_v_currency,
                                                                            ''N'',
                                                                            ''' || i_period_date || '''),4) l_fees_paid_rev,
                           round(pkg_tvf_out_liab_rpt.fun_tvf_fees_paid(lic.lic_v_number,
                                                                        lic.lic_n_con_number,
                                                                        lic.lic_v_currency,
                                                                        ''Y'',
                                                                        ''' || i_period_date || ''') ,4)ovg_paid,
                           decode(lic.lic_v_currency,''ZAR'',1,(pkg_tvf_out_liab_rpt.fun_tvf_cal_spot_rate(lic.lic_v_currency,
                                                                                                           tt.v_ter_cur_code,
                                                                                                           ''' || i_period_date || ''',
                                                                                                           lic.lic_n_ap_exch_rate_src,
                                                                                                           ''' || i_rpt_sub_type || ''',
                                                                                                           lic.lic_dt_start_date))) spot_rate
                      FROM tbl_tva_license lic,
                           fid_company cc,
                           tvod_deal_memo_type lt,
                           tvod_licensee lee,
                           tbl_tva_territory tt,
                           tbl_tva_contract con,
                           fid_company supp,
                           fid_general gen
                     WHERE upper(cc.com_short_name) LIKE upper(''' || i_channel_company || ''')
                       AND upper(lt.deal_type) LIKE upper(''' || i_lic_type || ''')
                       AND upper(lee.tvod_v_lee_short_name) LIKE upper(''' || i_licensee || ''')
                       AND upper(lic.lic_v_budget_type) LIKE upper(''' || i_budget_code || ''')
                       AND upper(supp.com_short_name) LIKE upper(''' || i_supp_short_name || ''')
                       AND upper(con.con_v_short_name) LIKE upper(''' || i_con_short_name || ''')
                       AND gen.gen_refno = lic.lic_n_gen_refno
                       AND supp.com_number = con.con_n_supp_com_number
                       AND con.con_n_contract_number = lic.lic_n_con_number
                       AND tt.v_ter_code = cc.com_ter_code
                       AND cc.com_number = con.con_n_com_number
                       AND lt.dm_type_id = lic.lic_n_dm_type
                       AND lee.tvod_n_lee_number = lic.lic_n_lee_number
                       AND lic.lic_dt_account_date IS NOT NULL
                       AND x_pkg_tvf_rpt_common.get_start_date(lic.lic_v_number,lic.lic_dt_start_date,' || l_period || ',''DD-Mon-RRRR'') <= last_day (to_date (''' || i_period_date || ''',''mm/dd/yyyy''))
                       AND lic.lic_dt_account_date <= to_date(''' || i_period_date || ''',''mm/dd/YYYY'')
                       AND (EXISTS (SELECT 1
                                      FROM tbl_tvf_license_sub_ledger
                                     WHERE lis_n_per_year || lpad (lis_n_per_month, 2, 0) = ' || l_period || '
                                       AND lis_v_lic_number = lic.lic_v_number)
                         OR (SELECT to_char(max(nvl(licp_dt_payment_date,to_date(''31-Dec-2199''))),''RRRRMM'')
                               FROM tbl_tva_lic_payments
                              WHERE licp_v_lic_number = lic.lic_v_number) >= ' || l_period || '))';

    IF i_include_zeros = 'N'
    THEN
      l_query := l_query || '
             WHERE (mg_in_lic_curr + ovg_in_lic_curr - fees_paid) <> 0';
    END IF;

    l_query := l_query || '
           )
  ORDER BY "Channel Company",
           "Lic Currency",
           "Lic Type",
           "Budget Code",
           "Programme",
           "Licensee"';

    dbms_output.put_line(l_query);
    OPEN o_liab_report FOR l_query;
  END prc_fin_out_liab_exp_to_exl;

--****************************************************************
-- This procedure outputs Outstanding Liability which is then exported to excel.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_fin_out_liab_summ_excel
  (
    i_rpt_sub_type      IN      VARCHAR2,
    i_channel_company   IN      fid_company.com_name%TYPE,
    i_lic_type          IN      tvod_deal_memo_type.deal_type%TYPE,
    i_licensee          IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    i_budget_code       IN      tbl_tva_license.lic_v_budget_type%TYPE,
    i_include_zeros     IN      VARCHAR2,
    i_period_date       IN      VARCHAR2,
    o_liab_report          OUT  pkg_tvf_out_liab_rpt.c_fin_rep
  )
  AS
  BEGIN
    OPEN o_liab_report FOR
    SELECT ols_v_channel_company "Channel Company",
           ols_v_lic_currency "Lic Currency",
           ols_v_lic_type "License Type",
           ols_v_lic_lee "Licensee",
           ols_v_lic_bud_type "Budget Code",
           sum(round(ols_n_total_fee_lic_curr,4)) "Total Lic Fee (Lic Curr)",
           sum(round(ols_n_mg_lic_curr,4)) "MG (Lic Curr)",
           sum(round(ols_n_mg_paid_lic_curr,4)) "MG Paid (Lic Curr)",
           sum(round(ols_n_mg_lib_lic_curr,4)) "MG Liability (Lic Curr)",
           sum(round(ols_n_mg_lib_cc_curr,4)) "MG Liability (Local Curr)",
           sum(round(ols_n_ovg_lic_curr,4)) "OVG (Lic Curr)",
           sum(round(ols_n_ovg_pid_lic_curr,4)) "OVG Paid (Lic Curr)",
           sum(round(ols_n_ovg_lib_lic_curr,4)) "OVG Liability (Lic Curr)",
           sum(round(ols_n_ovg_lib_cc_curr,4)) "OVG Liability (Loc Curr)",
           sum(round(ols_n_tot_lib_lic_curr,4)) "Total Liablity (Lic Curr)",
           sum(round(ols_n_tot_lib_cc_curr,4)) "Total Liablity (Local Curr)"
      FROM tbl_tvf_out_lib_summ
     WHERE upper(ols_v_channel_company) LIKE upper(i_channel_company)
       AND upper(ols_v_lic_type) LIKE upper(i_lic_type)
       AND upper(ols_v_lic_lee) LIKE upper(i_licensee)
       AND upper(ols_v_lic_bud_type) LIKE upper(i_budget_code)
  GROUP BY ols_v_channel_company,
           ols_v_lic_currency,
           ols_v_lic_type,
           ols_v_lic_lee,
           ols_v_cc_currency,
           ols_v_lic_bud_type
  ORDER BY ols_v_channel_company,
           ols_v_lic_type,
           ols_v_lic_lee,
           ols_v_lic_bud_type,
           ols_v_lic_currency,
           ols_v_cc_currency;
  END prc_fin_out_liab_summ_excel;

--****************************************************************
-- This function outputs amount paid for license.
-- REM Client - MNET
--****************************************************************
  FUNCTION fun_tvf_fees_paid_rev
  (
    i_lic_number     IN   tbl_tva_lic_payments.licp_v_lic_number%TYPE,
    i_con_number     IN   tbl_tva_contract.con_n_contract_number%TYPE,
    i_lic_currency   IN   tbl_tva_lic_payments.licp_v_currency%TYPE,
    i_for_ovg        IN   VARCHAR2,
    i_period_date    IN   VARCHAR2
  )
  RETURN NUMBER
  AS
    l_fees_paid_rev   NUMBER;
  BEGIN
    SELECT nvl(sum(round(licp_n_amount,4) * licp_n_spot_rate),0)
      INTO l_fees_paid_rev
      FROM tbl_tva_lic_payments
     WHERE licp_v_lic_number = i_lic_number
       AND licp_v_currency = i_lic_currency
       AND licp_n_con_number = i_con_number
       AND licp_c_paid_status IN ('P','I')
       AND nvl(licp_c_ovg_payment,'N') = i_for_ovg
       AND licp_dt_payment_date <= last_day(to_date(i_period_date,'MM/DD/YYYY'));

    RETURN l_fees_paid_rev;
  EXCEPTION
    WHEN no_data_found
    THEN
      RETURN 0;
  END fun_tvf_fees_paid_rev;

  FUNCTION x_fun_tvf_mg_lic_curr
  (
    i_lic_number    IN  tbl_tva_license.lic_v_number%TYPE,
    i_period        IN  NUMBER
  )
  RETURN NUMBER
  AS
    l_lic_con_inventory   tbl_tvf_license_sub_ledger.lis_n_con_inventory%TYPE;
  BEGIN
    SELECT sum(nvl(lis_n_con_inventory,0))
      INTO l_lic_con_inventory
      FROM tbl_tvf_license_sub_ledger
     WHERE lis_v_lic_number = i_lic_number
       AND lis_n_per_year || lpad(lis_n_per_month,2,0) <= i_period;

    RETURN round(l_lic_con_inventory,2);
  END x_fun_tvf_mg_lic_curr;

  FUNCTION x_fun_tvf_ovg_lic_curr
  (
    i_lic_number    IN  tbl_tva_license.lic_v_number%TYPE,
    i_period        IN  NUMBER
  )
  RETURN NUMBER
  AS
    l_lic_ovg_inventory   tbl_tvf_license_sub_ledger.lis_n_con_inventory%TYPE;
  BEGIN
    SELECT sum(nvl(lis_n_con_ovg_inv,0))
      INTO l_lic_ovg_inventory
      FROM tbl_tvf_license_sub_ledger
     WHERE lis_v_lic_number = i_lic_number
       AND lis_n_per_year || lpad(lis_n_per_month,2,0) <= i_period;

    RETURN round(l_lic_ovg_inventory,2);
  END x_fun_tvf_ovg_lic_curr;

  FUNCTION fun_tvf_fees_paid
  (
    i_lic_number     IN   tbl_tva_lic_payments.licp_v_lic_number%TYPE,
    i_con_number     IN   tbl_tva_contract.con_n_contract_number%TYPE,
    i_lic_currency   IN   tbl_tva_lic_payments.licp_v_currency%TYPE,
    i_for_ovg        IN   VARCHAR2,
    i_period_date    IN   VARCHAR2
  )
  RETURN NUMBER
  AS
    l_fees_paid   NUMBER;
  BEGIN
    SELECT nvl(sum(round(licp_n_amount,4)), 0)
      INTO l_fees_paid
      FROM tbl_tva_lic_payments
     WHERE licp_v_lic_number = i_lic_number
       AND licp_v_currency = i_lic_currency
       AND licp_n_con_number = i_con_number
       AND licp_c_paid_status IN ('P', 'I')
       AND nvl(licp_c_ovg_payment, 'N') = i_for_ovg
       AND licp_dt_payment_date <=  last_day(to_date(i_period_date, 'MM/DD/YYYY')) ;

    RETURN l_fees_paid;
  EXCEPTION
    WHEN no_data_found
    THEN
      RETURN 0;
  END fun_tvf_fees_paid;

  FUNCTION fun_tvf_cal_spot_rate
  (
    i_lic_curr		      IN    tbl_tva_lic_payments.licp_v_currency%TYPE,
    i_cc_curr		        IN    tbl_tva_lic_payments.licp_v_currency%TYPE,
    i_period_date		    IN    VARCHAR2,
    i_spot_rate_source	IN    VARCHAR2,
    i_rep_sub_type      IN    VARCHAR2,
    i_lic_start_date    IN    tbl_tva_license.lic_dt_start_date%TYPE
  )
  RETURN NUMBER
  AS
    l_period_date date;
    l_spotrate   NUMBER;
    l_periode    DATE;
  BEGIN
    IF i_rep_sub_type = 'L'
    THEN
      l_period_date := i_lic_start_date;
    ELSE
      l_period_date := last_day(to_date(i_period_date,'MM/DD/YYYY'));
    END IF;

    l_periode := l_period_date;

    --Added  : to check pay date is holiday or not
    IF pkg_tvf_out_liab_rpt.holiday_exists(l_period_date) = 1
    THEN
      LOOP
        l_periode := l_periode -1 ;
        EXIT WHEN pkg_tvf_out_liab_rpt.holiday_exists(l_periode) = 0;
      END LOOP;
    ELSE
      l_periode := l_period_date;
    END IF;

   	SELECT round(nvl(spo_n_rate,0),5)   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
	    INTO l_spotrate
	    FROM tbl_tvf_spot_rate
	   WHERE spo_v_cur_code = i_lic_curr
	     AND spo_v_cur_code_2 = i_cc_curr
	     AND spo_n_per_day = to_char(l_periode,'DD')
	     AND spo_n_per_month = to_char(l_periode,'MM')
	     AND spo_n_per_year = to_char(l_periode,'YYYY')
	     AND spo_n_srs_id = 1;

    RETURN l_spotrate;
  END fun_tvf_cal_spot_rate;

  --Added : to check pay date is holiday or not
  FUNCTION holiday_exists
  (
    i_pay_pay_date   IN    DATE
  )
  RETURN NUMBER
  AS
    l_count    NUMBER;
    l_result   NUMBER;
  BEGIN
    SELECT count(1)
      INTO l_count
      FROM tbl_tvf_holidays
     WHERE thol_holiday_date = i_pay_pay_date;

    IF l_count > 0
    THEN
      l_result := 1;
      RETURN l_result;
    ELSE
      l_result := 0;
      RETURN l_result;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      l_result := 0;
      RETURN l_result;
  END holiday_exists;
END pkg_tvf_out_liab_rpt;
/