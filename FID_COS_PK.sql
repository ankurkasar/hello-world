create or replace PACKAGE FID_COS_PK
AS
   v_lic_sub_ledger_rec   fid_license_sub_ledger%ROWTYPE; --27Mar2015 : Ver 0.2: P1 Issue : Jawahar Garg - Added v_lic_sub_ledger_rec to capture fid_license_sub_ledger fields

   PROCEDURE calculate_amortisation (
      ccomnumber     IN NUMBER,
      period_month   IN NUMBER,
      period_year    IN NUMBER,
      connumber      IN NUMBER,
      user_id        IN VARCHAR2,
      -- Pure Finance: Ajit : 26-Feb-2013 : new parameters region code added
      regioncode     IN fid_region.reg_code%TYPE         -- Pure Finance : END
                                                );

   PROCEDURE calculate_royalty (cha_com_number   IN NUMBER,
                                period_month     IN NUMBER,
                                period_year      IN NUMBER,
                                con_number       IN NUMBER,
                                user_id          IN VARCHAR2,
                                regioncode       IN VARCHAR2);

   -- Pure Finance: Ajit : 25-Feb-2013 : Wrapper package to call all the procedures
   PROCEDURE monthly_costing_calculations (
      i_com_number       IN fid_company.com_number%TYPE,
      i_con_number       IN fid_contract.con_number%TYPE,
      i_con_type         IN fid_contract.con_calc_type%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_month_end_type   IN VARCHAR2,
      i_region           IN fid_region.reg_code%TYPE,
      i_user_id          IN VARCHAR2,
      i_log_date         IN VARCHAR2,
      i_user_email       IN VARCHAR2);

   -- Pure Finance: Ajit : 02-Apr-2013 : Procedure added to processes the new ROY licenses
   -- The licenses started after the GO-Live date of Pure Finance
   PROCEDURE calculate_fin_royalty (cha_com_number        IN NUMBER,
                                    period_month          IN NUMBER,
                                    period_year           IN NUMBER,
                                    con_number            IN NUMBER,
                                    regioncode            IN VARCHAR2,
                                    month_end_type        IN VARCHAR2,
                                    from_date             IN DATE,
                                    todate                IN DATE,
                                    month_end_rate_date   IN DATE,
                                    user_id               IN VARCHAR2);

   -- Pure Finance: Ajit : 08-Apr-2013 :Procedure added to calculate inventory for current routine
   -- month for ROY licenses
   PROCEDURE calulate_inventory_for_roy (i_con_number           IN NUMBER,
                                         i_lic_number           IN NUMBER,
                                         i_lsl_number           IN NUMBER,
                                         i_lic_chs_number       IN NUMBER,
                                         i_lic_start            IN DATE,
                                         i_lic_price            IN NUMBER,
                                         i_old_lic_price        IN NUMBER,
                                         i_lic_min_subscriber   IN NUMBER,
                                         i_lic_status           IN VARCHAR2,
                                         i_start_month          IN BOOLEAN,
                                         i_curr_month           IN NUMBER,
                                         i_curr_year            IN NUMBER,
                                         i_lic_start_rate       IN NUMBER,
                                         i_disc_rate            IN NUMBER,
                                         i_entry_oper           IN VARCHAR2,
										 i_reval_flag			IN VARCHAR2,  --Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/24]
										 --Finance Dev Phase I Zeshan [Start]
										 i_lic_currency			IN VARCHAR2,
										 i_com_number			IN NUMBER
										 --Finance Dev Phase I [End]
											);

   -- Pure Finance: Ajit : 02-Apr-2013 : Procedure added to settle the -ve pre-payments of ROY licenses
   PROCEDURE pre_payment_settlement_for_roy (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_lsl_number      IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_lic_status      IN VARCHAR2,
      i_user_id         IN VARCHAR2);

   -- Pure Finance: Ajit : 23-Feb-2013 : Procedure added to processes the new licenses
   -- The licenses started after the GO-Live date of Pure Finance
   PROCEDURE calculate_fin_amortisation (
      ccomnumber            IN NUMBER,
      period_month          IN NUMBER,
      period_year           IN NUMBER,
      from_date             IN DATE,
      todate                IN DATE,
      connumber             IN NUMBER,
      month_end_rate_date   IN DATE,
      user_id               IN VARCHAR2,
      month_end_type        IN VARCHAR2,
      regioncode            IN fid_region.reg_code%TYPE);

   -- Pure Finance: Ajit : 23-Feb-2013 : Procedure added to check the validation before running the Costing routine
   PROCEDURE validations_check (com_number            IN NUMBER,
                                connumber             IN NUMBER,
                                month_end_type        IN VARCHAR2,
                                regioncode            IN VARCHAR2,
                                first_date_of_month   IN DATE,
                                last_date_of_month    IN DATE,
                                from_date             IN DATE,
                                todate                IN DATE);

   -- Pure Finance: Mangesh : 10-Jul-2013 : Procedure added to check the spot,forward and discount rate before running the Costing routine
   PROCEDURE chk_spot_rate_avail (first_date_of_month   IN DATE,
                                  last_date_of_month    IN DATE,
                                  i_month               IN NUMBER,
                                  i_year                IN NUMBER,
                                  i_month_end_type      IN VARCHAR2,
                                  i_region              IN VARCHAR2,
                                  from_date             IN DATE,
                                  todate                IN DATE);

   -- Pure Finance: Ajit : 28-Feb-2013 : Procedure added to mark the ED Applicable contract
   PROCEDURE mark_ed_applicable (current_month   IN NUMBER,
                                 current_year    IN NUMBER,
                                 connumber       IN NUMBER,
                                 user_id         IN VARCHAR2);

   -- Pure Finance: Ajit : 07-Mar-2013 : Procedure added to settle the -ve payments
   -- for both Active (Pre-payments only) and Cancelled licenses (Pre-payments + payments)
   PROCEDURE pre_payment_settlement (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_lsl_number      IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_lic_status      IN VARCHAR2,
      i_user_id         IN VARCHAR2);

   PROCEDURE pre_payment_pre_license_settle (i_com_number      IN NUMBER,
                                             i_connumber       IN NUMBER,
                                             i_regioncode      IN VARCHAR2,
                                             i_current_month   IN NUMBER,
                                             i_current_year    IN NUMBER,
                                             i_from_date       IN DATE,
                                             i_todate          IN DATE,
                                             i_user_id         IN VARCHAR2);

   -- Pure Finance: Ajit : 07-Mar-2013 : Procedure added to calculate realised forex
   PROCEDURE calculate_realized_forex (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_lsl_number      IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_user_id         IN VARCHAR2);

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to calculate inventory for current routine month
   PROCEDURE calulate_inventory_for_flf (
      i_lic_number           IN     NUMBER,
      i_ter_cur_code         IN     VARCHAR2,
      i_is_ed_applicable     IN     VARCHAR2,
      i_curr_month           IN     NUMBER,
      i_curr_year            IN     NUMBER,
      i_license_start_rate   IN     NUMBER,
      i_disc_rate            IN     NUMBER,
      i_forward_rate         IN     NUMBER,
      i_lic_price_chg_flag   IN     VARCHAR2,
      i_month_end_type       IN     VARCHAR2,
      i_entry_oper           IN     VARCHAR2,
      --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/24]
      i_reval_flag           IN     fid_license_sub_ledger.lis_reval_flag%TYPE,
      --Dev : Fin CR : End
      o_lic_rate                OUT NUMBER);

   -- Pure Finance: Ajit : 21-Mar-2013 : Procedure added to calculate un-realised forex for Linear and PV
   PROCEDURE calc_unrealized_forex_con_pv (
      i_lic_number       IN fid_license.lic_number%TYPE,
      i_lsl_number       IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_lic_start_rate   IN NUMBER,
      i_to_date_rate     IN NUMBER,
      i_to_date          IN DATE,
      i_user_id          IN VARCHAR2);

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to reverse inventory and cost till previous month of routine month
   PROCEDURE reverse_inventory_and_cost (i_lic_number       NUMBER,
                                         i_lic_curreny      VARCHAR2,
                                         i_lic_acct_date    DATE,
                                         i_lsl_number       NUMBER,
                                         i_lsl_lee_price    NUMBER,
                                         i_com_ter_code     VARCHAR2,
                                         i_curr_year        NUMBER,
                                         i_curr_month       NUMBER,
                                         i_user_id          VARCHAR2,
                                         --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/24]
                                         i_reval_flag       fid_license_sub_ledger.lis_reval_flag%TYPE
                                         --Dev : Fin CR : End
                                         );

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to reverse realized forex gain\loss till past month for each paid amount
   --hving amount greater than zero
   PROCEDURE reverse_real_forex_gain_loss (i_lic_number    NUMBER,
                                           i_lsl_number    NUMBER,
                                           i_curr_year     NUMBER,
                                           i_curr_month    NUMBER,
                                           i_user_id       VARCHAR2);

   PROCEDURE reverse_unreal_forex_gain_loss (i_lic_number    NUMBER,
                                             i_lsl_number    NUMBER,
                                             i_curr_year     NUMBER,
                                             i_curr_month    NUMBER,
                                             i_user_id       VARCHAR2);

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to reverse realized forex gain\loss till past month for each paid amount
   --hving amount greater less than zero
   PROCEDURE rev_real_forex_pay_not_settle (i_lic_number    NUMBER,
                                            i_lsl_number    NUMBER,
                                            i_curr_year     NUMBER,
                                            i_curr_month    NUMBER,
                                            i_user_id       VARCHAR2);

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to identify costed schedules in routine month
   PROCEDURE identify_costed_schedules (i_sch_lic_number   IN NUMBER,
                                        i_curr_month       IN NUMBER,
                                        i_curr_year        IN NUMBER,
                                        i_user             IN VARCHAR2);

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to update Is schedule properly costed field
   PROCEDURE update_is_sch_properly_costed (i_sch_lic_number   IN NUMBER,
                                            i_sch_cha_number   IN NUMBER,
                                            i_is_prop_costed   IN VARCHAR2,
                                            i_sch_window       IN NUMBER --value will be 1/2 depending on sch window
                                                                        );

   -- Pure Finance: Ajit : 21-Mar-2013 : Procedure added to calculate un-realised forex for ED
   PROCEDURE calc_unrealized_forex_ed (
      i_con_number      IN fid_contract.con_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_discount_rate   IN NUMBER,
      i_to_date         IN DATE,
      i_region          IN VARCHAR2,
      i_user_id         IN VARCHAR2);

   -- Pure Finance: Mangesh : 21-Mar-2013 : Procedure added to calculate realised forex for ED
   PROCEDURE calc_realized_forex_ed (
      i_lic_number       IN fid_license.lic_number%TYPE,
      i_lsl_number       IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_lsl_lee_price    IN x_fin_lic_sec_lee.lsl_lee_price%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_discount_rate    IN NUMBER,
      i_lic_start_rate   IN NUMBER,
      i_forward_rate     IN NUMBER,
      i_region           IN VARCHAR2,
      i_user_id          IN VARCHAR2);

   -- Pure Finance: Ajit : 22-Mar-2013 : Procedure added for cancelled licenses
   -- To reverse the inventory, cost, realized, unrealized forex and for payment settlement
   PROCEDURE calc_for_cancelled_license (
      i_con_number            IN fid_contract.con_number%TYPE,
      i_current_month         IN NUMBER,
      i_current_year          IN NUMBER,
      i_fromdate              IN DATE,
      i_todate                IN DATE,
      i_region                IN VARCHAR2,
      i_month_end_rate_date   IN DATE,
      i_user_id               IN VARCHAR2);

   PROCEDURE calc_realized_pre_pay_roy (
      i_lic_number       IN fid_license.lic_number%TYPE,
      i_lsl_number       IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_lic_start_rate   IN NUMBER,
      i_user_id          IN VARCHAR2);

   -- Pure Finance: Ajit : 22-Mar-2013 : Procedure added for calculation of realized forex
   -- for historical licenses (Licenses starting before Pure Finance Go-live)
   PROCEDURE payment_historical_licenses (
      i_con_number      IN fid_contract.con_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_region          IN VARCHAR2,
      i_user_id         IN VARCHAR2);

   -- Pure Finance: Ajit : 21-Mar-2013 : Procedure added to make old licenses inactive
   PROCEDURE make_lic_inactive (
      i_con_number      IN fid_contract.con_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_user_id         IN VARCHAR2);

   -- Pure Finance: Ajit : 21-Mar-2013 : Function added to check the if remaining
   -- liability and inventory for the license used in make_lic_inactive procedure
   FUNCTION check_rem_inv_liab (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER)
      RETURN NUMBER;

   -- Pure Finance: Ajit : 07-Mar-2013 : Procedure added to insert record into refund settle table
   PROCEDURE insert_refund_settle (
      i_lic_number             IN fid_license.lic_number%TYPE,
      i_pay_number             IN fid_payment.pay_number%TYPE,
      i_lsl_number             IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_rfd_pay_numbner        IN fid_payment.pay_number%TYPE,
      i_refund_amount          IN fid_payment.pay_amount%TYPE,
      i_current_month          IN NUMBER,
      i_current_year           IN NUMBER,
      i_settled_in_cur_month   IN CHAR,
      i_user_id                IN VARCHAR2);

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to insert/update records in sub_ledger for current routine month
   PROCEDURE insert_update_sub_ledger (i_lis_lic_number             NUMBER,
                                       i_lis_lsl_number             NUMBER,
                                       i_lis_ter_code               VARCHAR2,
                                       i_curr_year                  NUMBER,
                                       i_curr_month                 NUMBER,
                                       i_lis_price                  NUMBER,
                                       i_adjust_factor              NUMBER,
                                       i_lis_rate                   NUMBER,
                                       i_lis_start_rate             NUMBER,
                                       i_lis_paid_exhibition        NUMBER,
                                       i_lis_con_forecast           NUMBER,
                                       i_lis_loc_forecast           NUMBER,
                                       i_lis_con_calc               NUMBER,
                                       i_lis_loc_calc               NUMBER,
                                       i_lis_con_actual             NUMBER,
                                       i_lis_loc_actual             NUMBER,
                                       i_lis_con_adjust             NUMBER,
                                       i_lis_loc_adjust             NUMBER,
                                       i_lis_con_writeoff           NUMBER,
                                       i_lis_loc_writeoff           NUMBER,
                                       i_lis_pv_con_forecast        NUMBER,
                                       i_lis_pv_loc_forecast        NUMBER,
                                       i_lis_pv_con_inv_actual      NUMBER,
                                       i_lis_pv_con_liab_actual     NUMBER,
                                       i_lis_pv_loc_inv_actual      NUMBER,
                                       i_lis_pv_loc_liab_actual     NUMBER,
                                       i_lis_ed_loc_forecast        NUMBER,
                                       i_lis_ed_loc_actual          NUMBER,
                                       i_lis_con_unforseen_cost     NUMBER,
                                       i_lis_loc_unforseen_cost     NUMBER,
                                       --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                                       i_lis_asset_adj_value        NUMBER,
                                       i_lis_start                  DATE,
                                       i_lis_end                    DATE,
                                       i_lis_mean_subs              NUMBER,
                                       i_lis_mg_pv_con_forecast     NUMBER,
                                       i_lis_mg_pv_loc_forecast     NUMBER,
                                       i_lis_loc_asset_adj_value    NUMBER,
                                       i_lis_mg_pv_con_liab         NUMBER,
                                       i_lis_mg_pv_loc_liab         NUMBER,
                                       --END.
                                       i_user_id                    VARCHAR2,
                                       --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/24]
                                       i_lis_reval_flag             fid_license_sub_ledger.lis_reval_flag%TYPE,
                                       --Dev : Fin CR : End
                                       --Finance Dev Phase I Zeshan [Start]
                                       i_lis_lic_cur                fid_license_sub_ledger.lis_lic_cur%TYPE,
                                       i_lis_lic_com_number         fid_license_sub_ledger.lis_lic_com_number%TYPE,
                                       i_lis_lic_status             fid_license_sub_ledger.lis_lic_status%TYPE,
                                       i_lis_pay_mov_flag           fid_license_sub_ledger.lis_pay_mov_flag%TYPE,
                                       i_lis_con_pay                fid_license_sub_ledger.lis_con_pay%TYPE,
                                       i_lis_loc_pay                fid_license_sub_ledger.lis_loc_pay%TYPE
                                       --Finance Dev Phase I [End]
                                       );

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to insert costed schedules
   PROCEDURE insert_costed_schedules (i_sch_number       IN NUMBER,
                                      i_sch_lic_number   IN NUMBER,
                                      i_sch_cha_number   IN NUMBER,
                                      i_sch_date         IN DATE,
                                      i_curr_month       IN NUMBER,
                                      i_curr_year        IN NUMBER,
                                      i_user             IN VARCHAR2);

   -- Pure Finance: Ajit : 22-Mar-2013 : Procedure added to insert record into realized forex
   PROCEDURE insert_realized_forex (
      i_lic_number       IN fid_license.lic_number%TYPE,
      i_lsl_number       IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_pay_number       IN fid_payment.pay_number%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_realized_forex   IN NUMBER,
      i_account_head     IN VARCHAR2,
      i_user_id          IN VARCHAR2);

   -- Pure Finance: Ajit : 22-Mar-2013 : Procedure added to insert record into unrealized forex
   PROCEDURE insert_unrealized_forex (
      i_lic_number         IN fid_license.lic_number%TYPE,
      i_lsl_number         IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month      IN NUMBER,
      i_current_year       IN NUMBER,
      i_unrealized_forex   IN NUMBER,
      i_account_head       IN VARCHAR2,
      i_user_id            IN VARCHAR2);

   --Pure finance :Mangesh :09-APR-2013:Procedure to update Rate Date in Month end Defination
   PROCEDURE update_rate_date (i_month_end_rate_date   IN DATE,
                               i_month_end_type        IN VARCHAR2,
                               i_current_year          IN NUMBER,
                               i_current_month         IN NUMBER,
                               i_region                IN VARCHAR2);

   -- Pure Finance: Ajit : 28-Feb-2013 : Function added to send email
   FUNCTION fun_send_email (i_user           IN VARCHAR2,
                            i_action         IN VARCHAR2,
                            i_log_date       IN VARCHAR2,
                            i_user_mail_id   IN VARCHAR2)
      RETURN NUMBER;

   -- Pure Finance: Ajit : 28-Feb-2013 : Function added to get email-ids as array
   FUNCTION get_email_ids (list_in IN VARCHAR2, delimiter_in VARCHAR2)
      RETURN simplearray;

   PROCEDURE calculate_refund_settlement (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_lsl_number      IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_user_id         IN VARCHAR2);

   FUNCTION x_fin_amort_a_cost_calc (i_lic_start              IN DATE,
                                     i_lic_end                IN DATE,
                                     i_lic_price              IN NUMBER,
                                     i_amort_month            IN NUMBER,
                                     i_cost_till_last_month   IN NUMBER,
                                     i_calc_type              IN VARCHAR2)
   RETURN NUMBER;
   
  --Finance Dev Phase I Zeshan [Start]
  --Sets all payments for given month as Payments/Prepayments
  PROCEDURE X_PRC_SET_PAY_TYPE(
      I_OPEN_MONTH       	IN       DATE
  );
  
  --Gets the Payment Movement for given license for the Open Month also calculates 
  --License and Local Currency payments.
  PROCEDURE x_prc_get_lic_mvmt_data(
    i_lic_number              IN              fid_license.lic_number%TYPE,
    i_lsl_number              IN              x_fin_lic_sec_lee.lsl_number%TYPE,
    i_prev_month_lsd          IN              DATE,
    o_lis_con_pay               OUT           NUMBER,
    o_lis_loc_pay               OUT           NUMBER,
    o_lis_pay_mov_flag          OUT           VARCHAR2
	);
	
  --Gets the effective payments for a given license and lsl number within a specified
  --period.
  PROCEDURE x_prc_get_mve_amt(
          i_lic_number        IN          NUMBER,
          i_lsl_number        IN          x_fin_lic_sec_lee.lsl_number%TYPE,
          i_from_date         IN          DATE,
          i_to_date           IN          DATE,
          o_con_pay             OUT       NUMBER,
          o_lic_pay             OUT       NUMBER);
   --Finance Dev Phase I [End]

END FID_COS_PK;
/
CREATE OR REPLACE PACKAGE BODY FID_COS_PK
AS
   PROCEDURE calculate_amortisation (
      ccomnumber     IN NUMBER,
      period_month   IN NUMBER,
      period_year    IN NUMBER,
      connumber      IN NUMBER,
      user_id        IN VARCHAR2,
      -- Pure Finance: Ajit : 26-Feb-2013 : new parameters region code added
      regioncode     IN fid_region.reg_code%TYPE         -- Pure Finance : END
                                                )
   IS
      period_value       NUMBER;
      lic_start_value    NUMBER;
      lic_end_value      NUMBER;
      lic_showing_lic    NUMBER;
      write_off          NUMBER;
      con_forecast       NUMBER;
      loc_forecast       NUMBER;
      con_actual         NUMBER;
      loc_actual         NUMBER;
      con_adjust         NUMBER;
      loc_adjust         NUMBER;
      adjust_comment     VARCHAR2 (240);
      per_date           DATE;
      per_end_date       DATE;
      remain_months      NUMBER;
      sch_paid           NUMBER;
      sch_paid_plus_wo   NUMBER;
      total_showings     NUMBER;
      forecast_to_date   NUMBER;
      amort_to_date      NUMBER;
      paid_to_date       NUMBER;
      remain_showings    NUMBER;
      outstanding_fee    NUMBER;
      pre_license        BOOLEAN;
      first_month        BOOLEAN;
      last_month         BOOLEAN;
      no_amortisation    BOOLEAN;
      sec_licensee       NUMBER;
      --Finance Dev Phase I Zeshan [Start]
      l_lis_con_pay      fid_license_sub_ledger.lis_con_pay%TYPE;
      l_lis_loc_pay      fid_license_sub_ledger.lis_loc_pay%TYPE;
      l_lis_pay_mov_flag fid_license_sub_ledger.lis_pay_mov_flag%TYPE;
      --Finance Dev Phase I [End]
      CURSOR con_c (
         connumber NUMBER)
      IS
         SELECT *
           FROM fid_company, fid_contract
          WHERE     con_number = connumber
                AND con_status = 'A'
                AND com_number = con_com_number;

      con                con_c%ROWTYPE;

      CURSOR lic_c (
         connumber      NUMBER,
         comnumber      NUMBER,
         periodstart    DATE,
         periodend      DATE)
      IS
         SELECT lic_number,
                NVL (lic_showing_lic, 10) lic_showing_lic,
                NVL (lic_showing_int, 10) lic_showing_int,
                lic_start,
                lic_end,
                lic_acct_date,
                NVL (lic_rate, 1) lic_rate,
                lic_price,
                lic_chs_number,
                lic_currency,
                NVL (lic_amort_code, 'C') lic_amort_code,
                com_ter_code, -- Pure Finance: Ajit : 23-Feb-2013 : Catch-up flag added to identify the license
                NVL (lic_catchup_flag, 'N') lic_catchup_flag,
                --Finance Dev Phase I Zeshan [Start]
                lic_status
                --Finance Dev Phase I [End]
           FROM fid_license,
                fid_licensee,
                fid_company,
                fid_region
          WHERE     lic_con_number = connumber
                AND NVL (lic_acct_date,
                         TO_DATE ('31-DEC-2099', 'DD-MON-YYYY')) <= periodend
                AND lic_end >= periodstart
                AND lic_type IN ('FLF', 'CHC')
                AND lee_number = lic_lee_number
                AND com_number = lee_cha_com_number
                AND com_number = comnumber
                -- Pure Finance: Ajit : 23-Feb-2013 : Condition commented to write common logic for Linear and Catch-up licenses,
                --  where cause added for region and Pure Finance Go-Live date so this loop only prosses the historical data
                --AND NVL(LIC_CATCHUP_FLAG, 'N') = 'N' -- Condition added on 03-Nov-2012 by Ajit to exclude the Catch up Licenses
                AND reg_id(+) = lee_split_region
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (regioncode,
                                  '%', NVL (reg_code, '#'),
                                  regioncode))
                AND lic_start < (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                   FROM x_fin_configs
                                  WHERE KEY = 'GO-LIVEDATE');

      --Dev2: Pure Finance: Ajit : 23-Feb-2013 : Cursor added for Catch-up historical expired licenses
      CURSOR lic_c_exp (
         connumber      NUMBER,
         comnumber      NUMBER,
         periodstart    DATE)
      IS
         SELECT lic_number,
                NVL (lic_showing_lic, 10) lic_showing_lic,
                NVL (lic_showing_int, 10) lic_showing_int,
                lic_start,
                lic_end,
                NVL (lic_rate, 1) lic_rate,
                lic_price,
                lic_chs_number,
                lic_currency,
                NVL (lic_amort_code, 'C') lic_amort_code,
                com_ter_code,
				--Finance Dev Phase I Zeshan [Start]
				lic_status
				--Finance Dev Phase I [End]
           FROM fid_license,
                fid_licensee,
                fid_company,
                fid_region
          WHERE     lic_con_number = connumber
                AND lic_end < periodstart
                AND lic_status = 'A'
                AND lic_type IN ('FLF', 'CHC')
                AND lee_number = lic_lee_number
                AND com_number = lee_cha_com_number
                AND com_number = comnumber
                AND NVL (lic_catchup_flag, 'N') = 'Y'
                -- Pure Finance: Ajit : 23-Feb-2013 :
                --  where clause added for region and Pure Finance Go-Live date
                AND reg_id(+) = lee_split_region
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (regioncode,
                                  '%', NVL (reg_code, '#'),
                                  regioncode))
                AND lic_start < (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                   FROM x_fin_configs
                                  WHERE KEY = 'GO-LIVEDATE') -- TODO - Add Region
                                                            ;

      CURSOR lsl1 (
         licnumber    NUMBER,
         tercode      VARCHAR2,
         peryear      NUMBER,
         permonth     NUMBER)
      IS
         SELECT *
           FROM fid_license_sub_ledger
          WHERE     lis_lic_number = licnumber
                AND lis_ter_code = tercode
                AND lis_per_year = peryear
                AND lis_per_month = permonth;

      lsl                lsl1%ROWTYPE;

      CURSOR sch_c (
         licnumber    NUMBER,
         perstart     DATE,
         perend       DATE)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE     sch_lic_number = licnumber
                AND sch_date BETWEEN perstart AND perend
                AND sch_type = 'P';

      -- Pure Finance: Ajit : 23-Feb-2013 : Cursor added to get Catch-up licenses schedule from playlist for current month
      CURSOR sch_catchup_c (licnumber NUMBER, perstart DATE, perend DATE)
      IS
         SELECT COUNT (*)
           FROM (  SELECT plt_sch_number
                     FROM x_cp_play_list
                    WHERE plt_lic_number = licnumber
                          AND TRIM (plt_sch_start_date) BETWEEN perstart
                                                            AND perend
                          AND plt_sch_type = 'P'
                          AND plt_sch_number NOT IN
                                 (SELECT plt_sch_number
                                    FROM x_cp_play_list
                                   WHERE TRIM (plt_sch_start_date) < perstart
                                         AND plt_lic_number = licnumber
                                         AND plt_sch_type = 'P')
                 GROUP BY plt_sch_number);

      CURSOR sch2_c (
         licnumber    NUMBER,
         startdate    DATE)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE     sch_lic_number = licnumber
                AND sch_type = 'P'
                AND sch_date < startdate;

      -- Pure Finance: Ajit : 23-Feb-2013 : Cursor added to get Catch-up licenses schedule from playlist till last month
      CURSOR sch2_catchup_c (licnumber NUMBER, startdate DATE)
      IS
         SELECT COUNT (*)
           FROM (  SELECT plt_sch_number
                     FROM x_cp_play_list
                    WHERE     plt_lic_number = licnumber
                          AND plt_sch_type = 'P'
                          AND TRIM (plt_sch_start_date) < startdate
                 GROUP BY plt_sch_number);

      CURSOR lis_c (
         licnumber    NUMBER,
         tercode      VARCHAR2,
         peryear      NUMBER,
         permonth     NUMBER)
      IS
         SELECT NVL (SUM (lis_con_forecast), 0),
                NVL (SUM (lis_con_actual + lis_con_adjust), 0)
           FROM fid_license_sub_ledger
          WHERE lis_lic_number = licnumber AND lis_ter_code = tercode
                AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                       peryear || LPAD (permonth, 2, 0);

      --   cursor charuns_c(licnumber number,
      --                    chanumber number) is
      --          select  nvl(lcr_costing_runs, lcr_runs_allocated) channel_runs
      --          from  fid_license_channel_runs
      --          where lcr_lic_number = licnumber
      --            and lcr_cha_number = chanumber;

      --   charuns charuns_c%rowtype;
      CURSOR sch_c_d (
         licnumber    NUMBER,
         perstart     DATE,
         perend       DATE)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE     sch_lic_number = licnumber
                AND sch_date BETWEEN perstart AND perend
                AND sch_type = 'P'
                AND sch_cha_number IN
                       (SELECT lcr_cha_number
                          FROM fid_license_channel_runs
                         WHERE lcr_lic_number = licnumber
                               AND lcr_cost_ind = 'Y');

      CURSOR sch2_c_d (
         licnumber    NUMBER,
         startdate    DATE)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE     sch_lic_number = licnumber
                AND sch_type = 'P'
                AND sch_date < startdate
                AND sch_cha_number IN
                       (SELECT lcr_cha_number
                          FROM fid_license_channel_runs
                         WHERE lcr_lic_number = licnumber
                               AND lcr_cost_ind = 'Y');

     l_reval_flag           fid_license_sub_ledger.lis_reval_flag%TYPE;
     last_day_prev_mth      DATE;
		 l_old_lic_start				DATE;
   BEGIN
      ---  The main processing - Initially copying parameters passed into
      ---  local procedure variables
      --- Identify the Amortisation month
      per_date :=
         TO_DATE (
            '01' || TO_CHAR (period_month, '09') || TO_CHAR (period_year),
            'DDMMYYYY');
      per_end_date :=
         LAST_DAY (
            TO_DATE (
               '01' || TO_CHAR (period_month, '09') || TO_CHAR (period_year),
               'DDMMYYYY'));
      period_value := period_year || LPAD (period_month, 2, 0);
      last_day_prev_mth := last_day(add_months(per_date, -1));

      OPEN con_c (connumber);

      FETCH con_c INTO con;

      -- Select the Licenses for the Contract
      FOR lic IN lic_c (con.con_number,
                        ccomnumber,
                        per_date,
                        per_end_date)
      LOOP
         -- Identify whether the license start date is in this period,
         -- after this period, or whether the license end date is within
         -- this period
         lic_start_value :=
            TO_NUMBER (
               TO_CHAR (lic.lic_start, 'YYYY')
               || TO_CHAR (lic.lic_start, 'MM'));
         lic_end_value :=
            TO_NUMBER (
               TO_CHAR (lic.lic_end, 'YYYY') || TO_CHAR (lic.lic_end, 'MM'));

         IF period_value < lic_start_value
         THEN
            pre_license := TRUE;
         ELSE
            pre_license := FALSE;
         END IF;

         IF period_value = lic_end_value
         THEN
            last_month := TRUE;
         ELSE
            last_month := FALSE;
         END IF;
         -- if the amortisation code is not 'C' then delete sub_ledger
         -- records that have been established by forecasted costing
         -- actions
         IF lic.lic_amort_code != 'C'
         THEN
            DELETE FROM fid_license_sub_ledger
                  WHERE lis_lic_number = lic.lic_number
                        AND lis_per_year || LPAD (lis_per_month, 2, 0) >
                               period_value;
         END IF;

         --   Calculate the number of months in the License Period and
         --   the number of remaining months in the License Period.
         remain_months :=
            CEIL (MONTHS_BETWEEN (LAST_DAY (lic.lic_end), per_date));
         --   Calculate the valuation movement figure
         forecast_to_date := 0;
         amort_to_date := 0;
         con_forecast := 0;
         loc_forecast := 0;
         sec_licensee := NULL;

         SELECT lsl_number
           INTO sec_licensee
           FROM x_fin_lic_sec_lee
          WHERE     lsl_lic_number = lic.lic_number
                AND UPPER (NVL (lsl_is_primary, 'N')) = 'Y'
                AND ROWNUM < 2;

         OPEN lis_c (lic.lic_number,
                     lic.com_ter_code,
                     period_year,
                     period_month);

         FETCH lis_c
         INTO forecast_to_date, amort_to_date;

         CLOSE lis_c;

         -- The valuation movement figure (LIS_CON_FORECAST)
         -- equates to LIC_PRICE - FORECAST_TO_DATE.  The local
         -- valuation movement figure (LIS_LOC_FORECAST) equates
         -- LIS_CON_FORECAST multiplied by the LIC_RATE.
         con_forecast := ROUND (lic.lic_price - NVL (forecast_to_date, 0), 2);
         loc_forecast := ROUND (con_forecast * lic.lic_rate, 2);

        --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/08/04]
        l_reval_flag := NULL;

        BEGIN
          SELECT lis_lic_start
            INTO l_old_lic_start
            FROM fid_license_sub_ledger
           WHERE lis_lic_number = lic.lic_number
             AND lis_per_year || lpad(lis_per_month, 2, 0) = to_number(to_char(last_day_prev_mth, 'YYYYMM'))
             AND ROWNUM < 2;
        EXCEPTION
          WHEN no_data_found
          THEN
            l_old_lic_start := lic.lic_start;
        END;
        
        --Finance Dev Phase I Zeshan [Start]
         l_lis_con_pay := 0;
         l_lis_loc_pay := 0;
         l_lis_pay_mov_flag := 'N';
          
         x_prc_get_lic_mvmt_data(lic.lic_number,sec_licensee,l_old_lic_start,l_lis_con_pay,l_lis_loc_pay,l_lis_pay_mov_flag);
        --Finance Dev Phase I [End]
     
        IF lic.lic_start > l_old_lic_start
        THEN
          l_reval_flag := 'RL';
        END IF;

        IF pre_license = FALSE
        THEN
          IF (lic.lic_price <> forecast_to_date OR con_forecast <> 0 OR loc_forecast <> 0)
          THEN
            l_reval_flag := 'PC';
          END IF;
        END IF;

        IF lic_start_value = period_value
        THEN
          l_reval_flag := 'AL';
        END IF;
        --Dev : Fin CR : End

         -- Pure Finance: Ajit : 23-Feb-2013 : Catch-up checked
         IF NVL (lic.lic_catchup_flag, 'N') = 'N'
         THEN
            -- For linear license get the number of paid showings in the month from scheduler
            -- Determine the number of paid showings in the month
            OPEN sch_c (lic.lic_number, per_date, per_end_date);

            FETCH sch_c INTO sch_paid;

            CLOSE sch_c;
         ELSE
            -- For linear license get the number of paid showings in the month from Playlist
            -- Determine the number of paid showings in the month
            OPEN sch_catchup_c (lic.lic_number, per_date, per_end_date);

            FETCH sch_catchup_c INTO sch_paid;

            CLOSE sch_catchup_c;
         END IF;

         -- Pure Finance: Ajit : End

         -- Pure Finance: Ajit : 23-Feb-2013 : Getting paid_to_date before the loop
         IF NVL (lic.lic_catchup_flag, 'N') = 'N'
         THEN
            -- For linear license get the number of paid showings till month from scheduler
            -- Determine the number of paid showings in the month
            OPEN sch2_c (lic.lic_number, per_date);

            FETCH sch2_c INTO paid_to_date;

            CLOSE sch2_c;
         ELSE
            -- For linear license get the number of paid showings till month from Playlist
            -- Determine the number of paid showings in the month
            OPEN sch2_catchup_c (lic.lic_number, per_date);

            FETCH sch2_catchup_c INTO paid_to_date;

            CLOSE sch2_catchup_c;
         END IF;

         -- Pure Finance: Ajit : End

         -- Amortisation (LIS_CON_ACTUAL) figures are calculated on
         -- the basis of LIC_AMORT_CODE.  If LIC_AMORT_CODE = 'A' then
         -- the LIC_PRICE is written off evenly across the entire
         -- period.  If LIC_AMORT_CODE = 'B' then the LIC_PRICE is
         -- written off across the entire period according to the
         -- number of amortised exhibitions.  If LIC_AMORT_CODE = 'C'
         -- then the user will decide how the amortisation will be
         -- calculated.

         -- Initialise variables
         outstanding_fee := 0;
         con_actual := 0;
         loc_actual := 0;
         con_adjust := 0;
         loc_adjust := 0;

         IF lic.lic_amort_code = 'A'
         THEN
            no_amortisation := FALSE;
            outstanding_fee := lic.lic_price - NVL (amort_to_date, 0);

            IF NVL (remain_months, 0) = 0
            THEN
               remain_months := 1;
            END IF;

            con_actual := ROUND (outstanding_fee / NVL (remain_months, 0), 2);
            loc_actual := ROUND ( (con_actual * lic.lic_rate), 2);
         ELSIF lic.lic_amort_code = 'B'
         THEN
            -- Work out if any "write offs" need to be considered, i.e.
            -- is LIC_END between PER_DATE and PER_END_DATE, and if so,
            -- is LIC_SHOWING_LIC > all paid showings in the Macro
            -- Schedule.  If so, add the difference to SCH_PAID for
            -- calculation purposes.
            no_amortisation := FALSE;
            -- Pure Finance: Ajit : Getting same vaule above the if loop
            /*OPEN sch2_c (lic.lic_number, per_date);

            FETCH sch2_c
             INTO paid_to_date;

            CLOSE sch2_c;
            */
            -- Pure Finance: Ajit : End
            total_showings := NVL (paid_to_date, 0) + NVL (sch_paid, 0);
            sch_paid_plus_wo := NVL (sch_paid, 0);

            IF last_month
            THEN
               IF NVL (lic.lic_showing_lic, 10) > total_showings
               THEN
                  write_off := NVL (lic.lic_showing_lic, 10) - total_showings;
                  sch_paid_plus_wo := sch_paid_plus_wo + NVL (write_off, 0);
               END IF;
            END IF;

            -- Find the number of remaining exhibitions
            remain_showings :=
               NVL (lic.lic_showing_lic, 10) - NVL (paid_to_date, 0);
            -- CALCULATE THE AMORTISATION
            outstanding_fee := lic.lic_price - NVL (amort_to_date, 0);

            -- If the number of amortisable exhibitions <= 0 then LIS_
            -- CON_ACTUAL = LIC_PRICE - SUM(LIS_CON_ACTUAL) which will
            -- usually equal zero
            IF (lic.lic_showing_lic - total_showings) > 0
            THEN
               IF NVL (remain_showings, 0) = 0
               THEN
                  con_actual := 0;
               ELSE
                  con_actual :=
                     outstanding_fee * (sch_paid_plus_wo / remain_showings);
               END IF;

               loc_actual := ROUND (con_actual * lic.lic_rate, 2);
            ELSE
               con_actual := outstanding_fee;
               loc_actual := ROUND (con_actual * lic.lic_rate, 2);
            END IF;
         ELSIF lic.lic_amort_code = 'C'
         THEN
            IF last_month
            THEN
               con_actual :=
                    NVL (forecast_to_date, 0)
                  + NVL (con_forecast, 0)
                  - NVL (amort_to_date, 0);
               loc_actual := ROUND (con_actual * lic.lic_rate, 2);
            ELSE
               no_amortisation := TRUE;
            END IF;
         ELSIF lic.lic_amort_code = 'D'
         THEN
            -- Work out if any "write offs" need to be considered, i.e.
            -- is LIC_END between PER_DATE and PER_END_DATE, and if so,
            -- is LIC_SHOWING_LIC > all paid showings in the Macro
            -- Schedule.  If so, add the difference to SCH_PAID for
            -- calculation purposes.

            -- Pure Finance: Ajit : 23-Feb-2013 : Catch-up checked to the value for linear license
            -- from sch_c_d and sch2_c_d cursors haviing different where cause than sch_c and sch2_c
            IF NVL (lic.lic_catchup_flag, 'N') = 'N'
            THEN
               -- Determine the number of paid showings in the month
               OPEN sch_c_d (lic.lic_number, per_date, per_end_date);

               FETCH sch_c_d INTO sch_paid;

               CLOSE sch_c_d;

               OPEN sch2_c_d (lic.lic_number, per_date);

               FETCH sch2_c_d INTO paid_to_date;

               CLOSE sch2_c_d;
            END IF;

            no_amortisation := FALSE;
            total_showings := NVL (paid_to_date, 0) + NVL (sch_paid, 0);
            sch_paid_plus_wo := NVL (sch_paid, 0);

            IF last_month
            THEN
               IF NVL (lic.lic_showing_lic, 10) > total_showings
               THEN
                  write_off := NVL (lic.lic_showing_lic, 10) - total_showings;
                  sch_paid_plus_wo := sch_paid_plus_wo + NVL (write_off, 0);
               END IF;
            END IF;

            -- Find the number of remaining exhibitions
            remain_showings :=
               NVL (lic.lic_showing_lic, 10) - NVL (paid_to_date, 0);
            -- CALCULATE THE AMORTISATION
            outstanding_fee := lic.lic_price - NVL (amort_to_date, 0);

            -- If the number of amortisable exhibitions <= 0 then LIS_
            -- CON_ACTUAL = LIC_PRICE - SUM(LIS_CON_ACTUAL) which will
            -- usually equal zero
            IF (lic.lic_showing_lic - total_showings) > 0
            THEN
               con_actual :=
                  outstanding_fee * (sch_paid_plus_wo / remain_showings);
               loc_actual := ROUND (con_actual * lic.lic_rate, 2);
            ELSE
               con_actual := outstanding_fee;
               loc_actual := ROUND (con_actual * lic.lic_rate, 2);
            END IF;
         END IF;

         IF pre_license
         THEN
            con_actual := 0;
            loc_actual := 0;
         END IF;

         adjust_comment :=
               'Pr: '
            || LTRIM (TO_CHAR (lic.lic_price, '99999.999'))
            || ' Pd: '
            || LTRIM (TO_CHAR (sch_paid, '990'))
            || ' WO: '
            || LTRIM (TO_CHAR (NVL (write_off, 0), '990'))
            || ' Lic: '
            || LTRIM (TO_CHAR (NVL (lic.lic_showing_int, 10), '999'));

         OPEN lsl1 (lic.lic_number,
                    lic.com_ter_code,
                    period_year,
                    period_month);

         FETCH lsl1 INTO lsl;

         /*
         NOC :
         To set lis_lic_start_rate , so if license start date is moved to future date, lis_lic_start_rate can be used in inventory report
         NEERAJ : KARIM : 13-12-2013
         */
         IF lsl1%NOTFOUND
         THEN
            INSERT INTO fid_license_sub_ledger (lis_number,
                                                lis_lic_number,
                                                lis_ter_code,
                                                lis_per_month,
                                                lis_per_year,
                                                lis_price,
                                                lis_adjust_factor,
                                                lis_rate,
                                                lis_paid_exhibition,
                                                lis_con_forecast,
                                                lis_loc_forecast,
                                                lis_con_actual,
                                                lis_loc_actual,
                                                lis_con_adjust,
                                                lis_loc_adjust,
                                                lis_adjust_comment,
                                                lis_entry_oper,
                                                lis_entry_date,
                                                lis_lsl_number,
                                                lis_lic_start_rate,
                                                lis_lic_start,
                                                lis_lic_end,
                                                --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/26]
                                                lis_reval_flag,
                                                --Dev : Fin CR : End
                                                --Finance Dev Phase I Zeshan [Start]
                                                lis_lic_cur,
                                                lis_lic_com_number,
                                                lis_lic_status,
                                                lis_pay_mov_flag,
                                                lis_con_pay,
                                                lis_loc_pay
                                                --Finance Dev Phase I [End]
                                                )
                 VALUES (seq_fid_license_sub_ledger.NEXTVAL,
                         lic.lic_number,
                         lic.com_ter_code,
                         period_month,
                         period_year,
                         lic.lic_price,
                         1,
                         lic.lic_rate,
                         sch_paid,
                         con_forecast,
                         loc_forecast,
                         con_actual,
                         loc_actual,
                         0,
                         0,
                         NULL,
                         user_id,
                         SYSDATE,
                         sec_licensee,
                         lic.lic_rate,
                         lic.lic_start,
                         lic.lic_end,
                         --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/26]
                         NVL(l_reval_flag,'NC'),
                         --Dev : Fin CR : End
                         --Finance Dev Phase I Zeshan [Start]
                         lic.lic_currency,
                         ccomnumber,
                         lic.lic_status,
                         l_lis_pay_mov_flag,
                         l_lis_con_pay,
                         l_lis_loc_pay
                         --Finance Dev Phase I [End]
                         );
         ELSE
            IF no_amortisation
            THEN
               con_actual := lsl.lis_con_actual;
               loc_actual := lsl.lis_loc_actual;
            END IF;

            -- if an adjustment figure exists then keep this number
            con_adjust := lsl.lis_con_adjust;
            loc_adjust := lsl.lis_loc_adjust;

            UPDATE fid_license_sub_ledger
               SET lis_paid_exhibition = sch_paid,
                   lis_con_forecast = con_forecast,
                   lis_loc_forecast = loc_forecast,
                   lis_con_actual = NVL (con_actual, 0),
                   lis_loc_actual = NVL (loc_actual, 0),
                   lis_con_adjust = NVL (con_adjust, 0),
                   lis_loc_adjust = NVL (loc_adjust, 0),
                   lis_entry_oper = user_id,
                   lis_entry_date = SYSDATE,
                   lis_lic_start_rate = lic.lic_rate,
                   lis_lic_start = lic.lic_start,
                   lis_lic_end = lic.lic_end,
                   --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/26]
                   lis_reval_flag = NVL(l_reval_flag,'NC'),
                   --Dev : Fin CR : End
                   --Finance Dev Phase I Zeshan [Start]
                   lis_lic_cur = lic.lic_currency,
                   lis_lic_com_number = ccomnumber,
                   lis_lic_status = lic.lic_status,
                   lis_pay_mov_flag = l_lis_pay_mov_flag,
                   lis_con_pay = l_lis_con_pay,
                   lis_loc_pay = l_lis_loc_pay
                   --Finance Dev Phase I [End]
             WHERE     lis_lic_number = lic.lic_number
                   AND lis_ter_code = lic.com_ter_code
                   AND lis_per_year = period_year
                   AND lis_per_month = period_month;
         END IF;

         CLOSE lsl1;
      END LOOP;                                      /* End of License Loop */

      -- Pure Finance: Ajit : 23-Feb-2013 : Loop for expired Active Catch-up Licenses only
      FOR lic IN lic_c_exp (con.con_number, ccomnumber, per_date)
      LOOP
         forecast_to_date := 0;
         amort_to_date := 0;
         con_actual := 0;
         loc_actual := 0;
         con_forecast := 0;
         loc_forecast := 0;
         sch_paid := 0;
         sec_licensee := NULL;

         SELECT lsl_number
           INTO sec_licensee
           FROM x_fin_lic_sec_lee
          WHERE     lsl_lic_number = lic.lic_number
                AND UPPER (NVL (lsl_is_primary, 'N')) = 'Y'
                AND ROWNUM < 2;

         DELETE FROM fid_license_sub_ledger
               WHERE lis_lic_number = lic.lic_number
                     AND lis_per_year || LPAD (lis_per_month, 2, 0) =
                            period_value;

         OPEN lis_c (lic.lic_number,
                     lic.com_ter_code,
                     period_year,
                     period_month);

         FETCH lis_c
         INTO forecast_to_date, amort_to_date;

         CLOSE lis_c;

         IF lic.lic_price - NVL (forecast_to_date, 0) <> 0
         THEN
            con_forecast := lic.lic_price - NVL (forecast_to_date, 0);
            loc_forecast := ROUND (con_forecast * lic.lic_rate, 2);
            con_actual :=
                 NVL (forecast_to_date, 0)
               + NVL (con_forecast, 0)
               - NVL (amort_to_date, 0);
            loc_actual := ROUND ( (con_actual * lic.lic_rate), 2);

            /*
            NOC :
            To set lis_lic_start_rate , so if license start date is moved to future date, lis_lic_start_rate can be used in inventory report
            NEERAJ : KARIM : 13-12-2013
            */
            
            --Finance Dev Phase I Zeshan [Start]
            BEGIN
              SELECT lis_lic_start
                INTO l_old_lic_start
                FROM fid_license_sub_ledger
               WHERE lis_lic_number = lic.lic_number
                 AND lis_per_year || lpad(lis_per_month, 2, 0) = to_number(to_char(last_day_prev_mth, 'YYYYMM'))
                 AND ROWNUM < 2;
            EXCEPTION
              WHEN no_data_found
              THEN
                l_old_lic_start := lic.lic_start;
            END;
            
            l_lis_con_pay := 0;
            l_lis_loc_pay := 0;
            l_lis_pay_mov_flag := 'N';
            
            x_prc_get_lic_mvmt_data(lic.lic_number,sec_licensee,l_old_lic_start,l_lis_con_pay,l_lis_loc_pay,l_lis_pay_mov_flag);
            --Finance Dev Phase I [End]
            
            INSERT INTO fid_license_sub_ledger (lis_number,
                                                lis_lic_number,
                                                lis_ter_code,
                                                lis_per_month,
                                                lis_per_year,
                                                lis_price,
                                                lis_adjust_factor,
                                                lis_rate,
                                                lis_paid_exhibition,
                                                lis_con_forecast,
                                                lis_loc_forecast,
                                                lis_con_actual,
                                                lis_loc_actual,
                                                lis_con_adjust,
                                                lis_loc_adjust,
                                                lis_adjust_comment,
                                                lis_entry_oper,
                                                lis_entry_date,
                                                lis_lsl_number,
                                                lis_lic_start_rate,
                                                --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/26]
                                                lis_reval_flag,
                                                --Dev : Fin CR : End
                                                --Finance Dev Phase I Zeshan [Start]
                                                lis_lic_cur,
                                                lis_lic_com_number,
                                                lis_lic_status,
                                                lis_pay_mov_flag,
                                                lis_con_pay,
                                                lis_loc_pay
                                                --Finance Dev Phase I [End]
                                                )
                 VALUES (seq_fid_license_sub_ledger.NEXTVAL,
                         lic.lic_number,
                         lic.com_ter_code,
                         period_month,
                         period_year,
                         lic.lic_price,
                         1,
                         lic.lic_rate,
                         sch_paid,
                         con_forecast,
                         loc_forecast,
                         con_actual,
                         loc_actual,
                         0,
                         0,
                         NULL,
                         user_id,
                         SYSDATE,
                         sec_licensee,
                         lic.lic_rate,
                         --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/26]
                         'NC',
                         --Dev : Fin CR : End
                         --Finance Dev Phase I Zeshan [Start]
                         lic.lic_currency,
                         ccomnumber,
                         lic.lic_status,
                         l_lis_pay_mov_flag,
                         l_lis_con_pay,
                         l_lis_loc_pay
                         --Finance Dev Phase I [End]
                         );
         END IF;
      END LOOP;

      CLOSE con_c;
   END;

   /* ==========================================================
      ========================================================== */
   PROCEDURE calculate_royalty (cha_com_number   IN NUMBER,
                                period_month     IN NUMBER,
                                period_year      IN NUMBER,
                                con_number       IN NUMBER,
                                user_id          IN VARCHAR2,
                                regioncode       IN VARCHAR2)
   IS
      conshortnamev        VARCHAR2 (12);
      leeshortnamev        VARCHAR2 (5);
      periodyearv          NUMBER;
      periodmonthv         NUMBER;
      lic_price            NUMBER;
      lic_factor           NUMBER;
      write_off            NUMBER;
      lic_con_actual       NUMBER;
      lic_loc_actual       NUMBER;
      lic_min_amount       NUMBER;
      lin_min_subscriber   NUMBER;
      con_actual           NUMBER;
      loc_actual           NUMBER;
      con_adjust           NUMBER;
      forecast_diff        NUMBER;
      adjust_diff          NUMBER;
      loc_adjust           NUMBER;
      adjust_comment       VARCHAR2 (240);
      min_subscriber       BOOLEAN;
      per_date             DATE;
      per_end_date         DATE;
      sch_paid             NUMBER;
      sch_paid_plus_wo     NUMBER;
      sub_effective        NUMBER;
      sub_total            NUMBER;
      temp                 VARCHAR2 (1);
      actual_showings      NUMBER;
      forecast_to_date     NUMBER;
      actual_to_date       NUMBER;
      paid_to_date         NUMBER;
      con_forecast         NUMBER;
      loc_forecast         NUMBER;
      remaining_showings   NUMBER;
      total_royalty        NUMBER;
      total_forecast       NUMBER;
      now_territory        VARCHAR2 (3);
      asset_adjust         NUMBER;
      total_asset_adjust   NUMBER;
      new_pay_number       NUMBER;
      pay_check            NUMBER;
      status_check         VARCHAR2 (1);
      lic_showing_use      NUMBER := 0;
      paid_use_ratio       NUMBER := 0;
      total_pay_plan       NUMBER;
      last_month_plan      DATE;
      last_pay             VARCHAR2 (1);
      sec_licensee         NUMBER;
      --Finance Dev Phase I Zeshan [Start]
      l_lis_con_pay        fid_license_sub_ledger.lis_con_pay%TYPE;
      l_lis_loc_pay        fid_license_sub_ledger.lis_loc_pay%TYPE;
      l_lis_pay_mov_flag   fid_license_sub_ledger.lis_pay_mov_flag%TYPE;
      --Finance Dev Phase I [End]

      CURSOR con_c (connumber NUMBER)
      IS
           SELECT *
             FROM fid_company, fid_contract
            WHERE     con_status = 'A'
                  AND con_number = connumber
                  AND con_number IN (SELECT DISTINCT lic_con_number
                                       FROM fid_license
                                      WHERE lic_type = 'ROY')
                  AND com_number = con_com_number
         ORDER BY con_number;

      con                  con_c%ROWTYPE;

      CURSOR lic_c (
         connumber      NUMBER,
         periodstart    DATE,
         periodend      DATE)
      IS
         SELECT lic_number,
                lic_showing_int,
                lic_showing_lic,
                lic_amort_code,
								lic_start,
                lic_end,
                NVL (lic_rate, 0) lic_rate,
                lic_price,
                lic_chs_number,
                lic_currency,
                lic_min_guarantee,
                lic_min_subscriber,
				--Finance Dev Phase I Zeshan [Start]
				lic_status
				--Finance Dev Phase I [End]
           FROM fid_license, fid_licensee, fid_region
          WHERE lic_con_number = connumber
                AND NVL (lic_acct_date,
                         TO_DATE ('31-DEC-2099', 'DD-MON-YYYY')) <= periodend
                AND ( (lic_end >= periodstart)
                     OR (EXISTS
                            (SELECT NULL
                               FROM fid_asset_adjust
                              WHERE     asa_lic_number = lic_number
                                    AND asa_per_year = periodyearv
                                    AND asa_per_month = periodmonthv
                                    AND asa_con_adjust != 0)))
                AND lee_cha_com_number = cha_com_number
                AND lee_number = lic_lee_number
                AND lic_type = 'ROY'
                -- Pure Finance: Ajit : 02-Apr-2013 : License Status Active
                -- condition, region specific and license start date less than Pure Finance
                -- Go-live date
                AND reg_id(+) = lee_split_region
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (regioncode,
                                  '%', NVL (reg_code, '#'),
                                  regioncode))
                AND UPPER (lic_status) = 'A'
                AND lic_start < (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                   FROM x_fin_configs
                                  WHERE KEY = 'GO-LIVEDATE');

      CURSOR cht_c (
         licchsnumber NUMBER)
      IS
         SELECT DISTINCT cht_ter_code
           FROM fid_channel_territory
          WHERE ( (cht_cha_number = licchsnumber)
                 OR EXISTS
                       (SELECT 'X'
                          FROM fid_channel_service
                         WHERE chs_number = licchsnumber
                               AND chs_cha_number = cht_cha_number
                        UNION
                        SELECT 'X'
                          FROM fid_channel_service_channel
                         WHERE     csc_chs_number = licchsnumber
                               AND csc_cha_number = cht_cha_number
                               AND csc_include_subs = 'Y'
                               AND TO_CHAR (csc_end_dt, 'YYYYMM') >=
                                      period_year
                                      || LPAD (period_month, 2, 0)));

      cht                  cht_c%ROWTYPE;

      CURSOR lil_c (licnumber NUMBER, tercode VARCHAR2)
      IS
         SELECT lil_price, lil_adjust_factor, lil_rgh_code
           FROM fid_license_ledger
          WHERE lil_lic_number = licnumber AND lil_ter_code = tercode;

      lil                  lil_c%ROWTYPE;

      CURSOR subscriber_c (
         connumber       NUMBER,
         licchsnumber    NUMBER,
         tercode         VARCHAR2,
         peryear         NUMBER,
         permonth        NUMBER)
      IS
         SELECT NVL (SUM (ROUND (cts_effective, 0)), 0)
           FROM fid_contract_subscriber
          WHERE cts_con_number = connumber
                AND ( (cts_cha_number = licchsnumber)
                     OR EXISTS
                           (SELECT 'X'
                              FROM fid_channel_service
                             WHERE chs_number = licchsnumber
                                   AND chs_cha_number = cts_cha_number
                            UNION
                            SELECT 'X'
                              FROM fid_channel_service_channel
                             WHERE     csc_chs_number = licchsnumber
                                   AND csc_cha_number = cts_cha_number
                                   AND csc_include_subs = 'Y'
                                   AND TO_CHAR (csc_end_dt, 'YYYYMM') >=
                                          period_year
                                          || LPAD (period_month, 2, 0)
                            UNION
                            SELECT 'X'
                              FROM fid_channelservice_subtype
                             WHERE fcs_chs_number = licchsnumber
                                   AND fcs_sub_id = cts_cha_number))
                AND cts_ter_code = tercode
                AND cts_per_year = peryear
                AND cts_per_month = permonth;

      CURSOR lsl1 (
         licnumber    NUMBER,
         tercode      VARCHAR2,
         peryear      NUMBER,
         permonth     NUMBER)
      IS
         SELECT 'X'
           FROM fid_license_sub_ledger
          WHERE     lis_lic_number = licnumber
                AND lis_ter_code = tercode
                AND lis_per_year = peryear
                AND lis_per_month = permonth;

      CURSOR sub_total_c (
         connumber       NUMBER,
         licchsnumber    NUMBER,
         peryear         NUMBER,
         permonth        NUMBER)
      IS
         SELECT NVL (SUM (ROUND (cts_effective, 0)), 0)
           FROM fid_contract_subscriber
          WHERE cts_con_number = connumber
                AND ( (cts_cha_number = licchsnumber)
                     OR EXISTS
                           (SELECT 'X'
                              FROM fid_channel_service
                             WHERE chs_number = licchsnumber
                                   AND chs_cha_number = cts_cha_number
                            UNION
                            SELECT 'X'
                              FROM fid_channel_service_channel
                             WHERE     csc_chs_number = licchsnumber
                                   AND csc_cha_number = cts_cha_number
                                   AND csc_include_subs = 'Y'
                                   AND TO_CHAR (csc_end_dt, 'YYYYMM') >=
                                          period_year
                                          || LPAD (period_month, 2, 0)
                            UNION
                            SELECT 'X'
                              FROM fid_channelservice_subtype
                             WHERE fcs_chs_number = licchsnumber
                                   AND fcs_sub_id = cts_cha_number))
                AND cts_per_year = peryear
                AND cts_per_month = permonth;

      CURSOR sch_c (
         licnumber    NUMBER,
         perstart     DATE,
         perend       DATE)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE     sch_lic_number = licnumber
                AND sch_date BETWEEN perstart AND perend
                AND sch_type = 'P';

      CURSOR sch2_c (licnumber NUMBER)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE sch_lic_number = licnumber AND sch_type = 'P';

      CURSOR sch_c_d (
         licnumber    NUMBER,
         perstart     DATE,
         perend       DATE)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE     sch_lic_number = licnumber
                AND sch_date BETWEEN perstart AND perend
                AND sch_type = 'P'
                AND sch_cha_number IN
                       (SELECT lcr_cha_number
                          FROM fid_license_channel_runs
                         WHERE lcr_lic_number = licnumber
                               AND lcr_cost_ind = 'Y');

      CURSOR sch2_c_d (
         licnumber NUMBER)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE sch_lic_number = licnumber AND sch_type = 'P'
                AND sch_cha_number IN
                       (SELECT lcr_cha_number
                          FROM fid_license_channel_runs
                         WHERE lcr_lic_number = licnumber
                               AND lcr_cost_ind = 'Y');

      CURSOR lis_c (
         licnumber    NUMBER,
         tercode      VARCHAR2,
         peryear      NUMBER,
         permonth     NUMBER)
      IS
         SELECT NVL (SUM (lis_con_forecast), 0),
                NVL (SUM (lis_con_actual + lis_con_adjust), 0)
           FROM fid_license_sub_ledger
          WHERE lis_lic_number = licnumber AND lis_ter_code = tercode
                AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                       peryear || LPAD (permonth, 2, 0);

      CURSOR sch3_c (
         licnumber    NUMBER,
         startdate    DATE)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE     sch_lic_number = licnumber
                AND sch_type = 'P'
                AND sch_date < startdate;

      CURSOR sch3_c_d (
         licnumber    NUMBER,
         startdate    DATE)
      IS
         SELECT COUNT (*)
           FROM fid_schedule
          WHERE     sch_lic_number = licnumber
                AND sch_type = 'P'
                AND sch_date < startdate
                AND sch_cha_number IN
                       (SELECT lcr_cha_number
                          FROM fid_license_channel_runs
                         WHERE lcr_lic_number = licnumber
                               AND lcr_cost_ind = 'Y');

      CURSOR lis_total_c (
         licnumber NUMBER)
      IS
         SELECT NVL (SUM (lis_con_actual + lis_con_adjust), 0),
                NVL (SUM (lis_con_forecast), 0)
           FROM fid_license_sub_ledger
          WHERE lis_lic_number = licnumber;

      CURSOR pay_plan_total (licnumber NUMBER)
      IS
         SELECT COUNT (*)
           FROM fid_license_payment_months
          WHERE lpy_lic_number = licnumber;

      CURSOR pay_plan_last_month (licnumber NUMBER)
      IS
         SELECT MAX (lpy_pay_month)
           FROM fid_license_payment_months
          WHERE lpy_lic_number = licnumber;

     l_reval_flag         fid_license_sub_ledger.lis_reval_flag%TYPE;
     l_old_lic_start      DATE;
     l_lis_lic_price      fid_license_sub_ledger.lis_price%TYPE;
   BEGIN
      --  the main processing - initially copying parameters passed into local procedure variables

      -- leeshortnamev  := lee_short_name;
      -- conshortnamev  := con_short_name;
      periodmonthv := period_month;
      periodyearv := period_year;
      --  identify the royalty month and calculate the preceding month
      per_date :=
         TO_DATE (
            '01' || TO_CHAR (periodmonthv, '09') || TO_CHAR (periodyearv),
            'DDMMYYYY');
      per_end_date :=
         LAST_DAY (
            TO_DATE (
               '01' || TO_CHAR (periodmonthv, '09') || TO_CHAR (periodyearv),
               'DDMMYYYY'));

      -- start the contract loop
      FOR con IN con_c (con_number)
      LOOP                                                    -- contract loop
         -- run the stored package roypck.sql which populates the fid_
         -- contract_subscriber table, via the calculate_subscribers procedure.
         fid_roy_pk.calculate_subscribers (con.con_number,
                                           periodyearv,
                                           periodmonthv);

         -- select the licenses for the contract and start the license loop
         FOR lic IN lic_c (con.con_number, per_date, per_end_date)
         LOOP
            --  keep a running total of royalties for each license to be
            --  used for checking against the minimum subscriber level
            lic_con_actual := 0;
            lic_loc_actual := 0;
            now_territory := NULL;
            --  reset a couple of variables (just to be on the safe side)
            last_pay := 'N';
            sch_paid := 0;
            actual_showings := 0;
            sch_paid_plus_wo := 0;
            write_off := 0;
            sec_licensee := NULL;

            l_reval_flag := NULL;

            SELECT lsl_number
              INTO sec_licensee
              FROM x_fin_lic_sec_lee
             WHERE     lsl_lic_number = lic.lic_number
                   AND UPPER (NVL (lsl_is_primary, 'N')) = 'Y'
                   AND ROWNUM < 2;

            IF lic.lic_amort_code = 'D'
            THEN
               OPEN pay_plan_total (lic.lic_number);

               FETCH pay_plan_total INTO total_pay_plan;

               CLOSE pay_plan_total;

               IF total_pay_plan > 0
               THEN
                  /* if payplan exists, check for amount unpaid, else continue */
                  OPEN pay_plan_last_month (lic.lic_number);

                  FETCH pay_plan_last_month INTO last_month_plan;

                  CLOSE pay_plan_last_month;

                  IF TO_NUMBER (TO_CHAR (last_month_plan, 'YYYYMM')) <
                        TO_NUMBER (
                           period_year || LPAD (period_month, 2, '0'))
                  THEN
                     /* no more unpaid payments in payment plan, set indicator as no revaluations must take place */
                     last_pay := 'Y';
                  END IF;
               END IF;

               lic_showing_use := lic.lic_showing_lic;

               --  determine the number of paid showings in the month
               OPEN sch_c_d (lic.lic_number, per_date, per_end_date);

               FETCH sch_c_d INTO sch_paid;

               CLOSE sch_c_d;

               --  work out if any "write offs" need to be considered, i.e.
               --  is lic_end between per_date and per_end_date, and if so,
               --  is lic_showing_int > all paid showings in the macro schedule.
               --  If so, add the difference to sch_paid for calculation purposes.
               sch_paid_plus_wo := sch_paid;

               IF (lic.lic_end <= per_end_date AND lic.lic_end >= per_date)
               THEN
                  OPEN sch2_c_d (lic.lic_number);

                  FETCH sch2_c_d INTO actual_showings;

                  CLOSE sch2_c_d;

                  IF lic_showing_use > actual_showings
                  THEN
                     write_off := lic_showing_use - actual_showings;
                     sch_paid_plus_wo := sch_paid_plus_wo + write_off;
                  END IF;
               END IF;
            ELSE
               lic_showing_use := lic.lic_showing_int;

               --  determine the number of paid showings in the month
               OPEN sch_c (lic.lic_number, per_date, per_end_date);

               FETCH sch_c INTO sch_paid;

               CLOSE sch_c;

               --  work out if any "write offs" need to be considered, i.e.
               --  is lic_end between per_date and per_end_date, and if so,
               --  is lic_showing_int > all paid showings in the macro schedule.
               --  If so, add the difference to sch_paid for calculation purposes.
               sch_paid_plus_wo := sch_paid;

               IF (lic.lic_end <= per_end_date AND lic.lic_end >= per_date)
               THEN
                  OPEN sch2_c (lic.lic_number);

                  FETCH sch2_c INTO actual_showings;

                  CLOSE sch2_c;

                  IF lic_showing_use > actual_showings
                  THEN
                     write_off := lic_showing_use - actual_showings;
                     sch_paid_plus_wo := sch_paid_plus_wo + write_off;
                  END IF;
               END IF;
            END IF;

            --  check to see if their are minimum subscribers
            --  specified for this license. If so, check whether
            --  minimum subs are greater than effective subs.
            min_subscriber := FALSE;
            lin_min_subscriber := 0;
            sub_total := 0;

            IF NVL (lic.lic_min_subscriber, 0) <> 0
            THEN
               OPEN sub_total_c (con.con_number,
                                 lic.lic_chs_number,
                                 periodyearv,
                                 periodmonthv);

               FETCH sub_total_c INTO sub_total;

               CLOSE sub_total_c;

               IF NVL (lic.lic_min_subscriber, 0) > sub_total
               THEN
                  min_subscriber := TRUE;
               END IF;
            END IF;

            --  Select the channel/service subscriber territories and start the cht loop
            FOR cht IN cht_c (lic.lic_chs_number)
            LOOP
               now_territory := cht.cht_ter_code;
               con_actual := 0;
               loc_actual := 0;

               -- Find any local territory pricing
               OPEN lil_c (lic.lic_number, cht.cht_ter_code);

               FETCH lil_c INTO lil;

               IF lil_c%NOTFOUND
               THEN
                  lic_price := lic.lic_price;
                  lic_factor := 1;
               ELSE
                  IF lil.lil_rgh_code = 'X'
                  THEN
                     lic_price := 0;
                     lic_factor := 0;
                  ELSE
                     lic_price := lil.lil_price;
                     lic_factor := lil.lil_adjust_factor;
                  END IF;
               END IF;

               CLOSE lil_c;

               -- Determine the number of subscribers for the territory
               sub_effective := 0;

               OPEN subscriber_c (con.con_number,
                                  lic.lic_chs_number,
                                  cht.cht_ter_code,
                                  periodyearv,
                                  periodmonthv);

               FETCH subscriber_c INTO sub_effective;

               CLOSE subscriber_c;

               -- pro-rate the subscriber figures according to the minimum
               -- subscriber number in the lineup if the min subscribers are valid
               IF sub_total = 0
               THEN
                  sub_total := 1;
               END IF;

               IF min_subscriber = TRUE
               THEN
                  sub_effective :=
                     sub_effective
                     * (NVL (lic.lic_min_subscriber, 0) / sub_total);
               END IF;

               --  calculate the ytd figures
               forecast_to_date := 0;
               actual_to_date := 0;
               paid_to_date := 0;
               remaining_showings := 0;
               con_forecast := 0;

               OPEN lis_c (lic.lic_number,
                           cht.cht_ter_code,
                           periodyearv,
                           periodmonthv);

               FETCH lis_c
               INTO forecast_to_date, actual_to_date;

               CLOSE lis_c;

               IF lic.lic_amort_code = 'D'
               THEN
                  OPEN sch3_c_d (lic.lic_number, per_date);

                  FETCH sch3_c_d INTO paid_to_date;

                  CLOSE sch3_c_d;
               ELSE
                  OPEN sch3_c (lic.lic_number, per_date);

                  FETCH sch3_c INTO paid_to_date;

                  CLOSE sch3_c;
               END IF;

               --   the number of remaining showings equates to the number
               --   intended (lic_showing_int) - the number shown thus far
               --   prior to the period of calculation
               remaining_showings := NVL (lic_showing_use, 10) - paid_to_date;

               BEGIN
                  --  calculate the royalty
                  paid_use_ratio :=
                     NVL (sch_paid_plus_wo, 0) / NVL (lic_showing_use, 10);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     paid_use_ratio := 0;
               END;

               IF paid_use_ratio > 1
               THEN
                  paid_use_ratio := 1;
               END IF;

               IF last_pay = 'Y'
               THEN                           /* cost using the ytd inv bal */
                  IF remaining_showings > 0
                  THEN
                     con_actual :=
                        NVL (
                           ROUND (
                              (  (forecast_to_date - actual_to_date)
                               / remaining_showings
                               * sch_paid_plus_wo),
                              2),
                           0);
                  END IF;
               ELSE
                  con_actual :=
                     NVL (
                        ROUND (
                           (  lic_price
                            * lic_factor
                            * paid_use_ratio
                            * sub_effective),
                           2),
                        0);
               END IF;

               loc_actual := ROUND (con_actual * lic.lic_rate, 2);
               adjust_comment :=
                     'Pr: '
                  || LTRIM (TO_CHAR (lic_price, '99999.999'))
                  || ' Fa: '
                  || LTRIM (TO_CHAR (lic_factor, '999.999'))
                  || ' Pd: '
                  || LTRIM (TO_CHAR (sch_paid, '999'))
                  || ' Wo: '
                  || LTRIM (TO_CHAR (write_off, '999'))
                  || ' Int: '
                  || LTRIM (TO_CHAR (lic_showing_use, '999'))
                  || ' Sub: '
                  || LTRIM (TO_CHAR (sub_effective, '999,999.99'));

               -- Calculate the valuation movement figure

               --   the valuation movement figure (lis_con_forecast)
               --   equates to remaining_showings/the number of intended
               --   showings (lic_showing_int) multiplied by the lil_price
               --   and lil_factor multiplied by the number of effective
               --   subscribers (sub_effective).  this resultant figure
               --   adding the contents of actual_to_date, minus forecast_
               --   to_date gives the valuation movement figure.
               BEGIN
                  con_forecast :=
                     ROUND (
                        (  (remaining_showings / NVL (lic_showing_use, 10))
                         * lic_price
                         * lic_factor
                         * sub_effective)
                        + actual_to_date
                        - forecast_to_date,
                        2);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     con_forecast := 0;
               END;

               --   these valuation numbers must be adjusted to reflect any adjustment numbers in the asset value adjustment
               --   table.  as a result the _forecast numbers posted to the sub ledger table have been adjusted.
               asset_adjust := 0;

               BEGIN
                  SELECT asa_con_adjust
                    INTO asset_adjust
                    FROM fid_asset_adjust
                   WHERE     asa_lic_number = lic.lic_number
                         AND asa_ter_code = cht.cht_ter_code
                         AND asa_per_year = periodyearv
                         AND asa_per_month = periodmonthv;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;

               IF last_pay = 'Y'
               THEN                   /* no revaluations after last payment */
                  con_forecast := 0;
                  loc_forecast := 0;
               ELSE
                  con_forecast := con_forecast + asset_adjust;
                  loc_forecast := ROUND ( (con_forecast * lic.lic_rate), 2);
               END IF;

        BEGIN
          SELECT lis_lic_start
            INTO l_old_lic_start
            FROM fid_license_sub_ledger
           WHERE lis_lic_number = lic.lic_number
             AND to_date(lis_per_year || lpad(lis_per_month,2,0),'RRRRMM') = last_day(add_months(to_date(periodyearv || lpad(periodmonthv,2,0),'RRRRMM'),-1))
             AND ROWNUM < 2;
        EXCEPTION
          WHEN no_data_found
          THEN
            l_old_lic_start := lic.lic_start;
        END;

		 BEGIN
		  SELECT lis_price
            INTO l_lis_lic_price
            FROM
          (SELECT lis_price

            FROM fid_license_sub_ledger
           WHERE lis_lic_number = lic.lic_number
             AND to_date(lis_per_year || lpad(lis_per_month,2,0),'RRRRMM') = last_day(add_months(to_date(periodyearv || lpad(periodmonthv,2,0),'RRRRMM'),-1))
             AND  NVL(lis_price,0) <> 0
            )WHERE ROWNUM = 1;

        EXCEPTION
          WHEN no_data_found
          THEN
            l_lis_lic_price := lic.lic_price;
        END;

         IF to_char(lic.lic_start,'RRRRMM') < periodyearv || lpad(periodmonthv,2,0)
         THEN
            IF (lic.lic_price <> l_lis_lic_price OR con_forecast <>0 OR loc_forecast <> 0)
            THEN
                 l_reval_flag := 'PC';
            END IF;
         END IF;

        IF lic.lic_start > l_old_lic_start
        THEN
			l_reval_flag := 'RL';
        END IF;

        
         --Finance Dev Phase I Zeshan [Start]
          l_lis_con_pay := 0;
          l_lis_loc_pay := 0;
          l_lis_pay_mov_flag := 'N';
          
          x_prc_get_lic_mvmt_data(lic.lic_number,sec_licensee,l_old_lic_start,l_lis_con_pay,l_lis_loc_pay,l_lis_pay_mov_flag);
         --Finance Dev Phase I [End]
        

        IF to_char(lic.lic_start,'RRRRMM') = periodyearv || lpad(periodmonthv,2,0)
        THEN
          l_reval_flag := 'AL';
        END IF;

               OPEN lsl1 (lic.lic_number,
                          cht.cht_ter_code,
                          periodyearv,
                          periodmonthv);

               FETCH lsl1 INTO temp;

               /*
               NOC :
               To set lis_lic_start_rate , so if license start date is moved to future date, lis_lic_start_rate can be used in inventory report
               NEERAJ : KARIM : 13-12-2013
               */
               IF lsl1%NOTFOUND
               THEN
                  INSERT INTO fid_license_sub_ledger (lis_number,
                                                      lis_lic_number,
                                                      lis_ter_code,
                                                      lis_per_month,
                                                      lis_per_year,
                                                      lis_price,
                                                      lis_adjust_factor,
                                                      lis_rate,
                                                      lis_paid_exhibition,
                                                      lis_con_forecast,
                                                      lis_loc_forecast,
                                                      lis_con_actual,
                                                      lis_loc_actual,
                                                      lis_con_adjust,
                                                      lis_loc_adjust,
                                                      lis_adjust_comment,
                                                      lis_entry_oper,
                                                      lis_entry_date,
                                                      lis_lsl_number,
                                                      lis_lic_start_rate,
                                                      lis_lic_start,
                                                      lis_lic_end,
                                                      --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/26]
                                                      lis_reval_flag,
                                                      --Dev : Fin CR : End
                                                      --Finance Dev Phase I Zeshan [Start]
                                                      lis_lic_cur,
                                                      lis_lic_com_number,
                                                      lis_lic_status,
                                                      lis_pay_mov_flag,
                                                      lis_con_pay,
                                                      lis_loc_pay
                                                      --Finance Dev Phase I [End]
                                                      )
                       VALUES (seq_fid_license_sub_ledger.NEXTVAL,
                               lic.lic_number,
                               cht.cht_ter_code,
                               periodmonthv,
                               periodyearv,
                               lic_price,
                               lic_factor,
                               lic.lic_rate,
                               sch_paid,
                               con_forecast,
                               loc_forecast,
                               con_actual,
                               loc_actual,
                               0,
                               0,
                               NULL,
                               user_id,
                               SYSDATE,
                               sec_licensee,
                               lic.lic_rate,
                               lic.lic_start,
                               lic.lic_end,
                               --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/26]
                               NVL(l_reval_flag,'NC'),
                               --Dev : Fin CR : End
                               --Finance Dev Phase I Zeshan [Start]
                               lic.lic_currency,
                               cha_com_number,
                               lic.lic_status,
                               l_lis_pay_mov_flag,
                               l_lis_con_pay,
                               l_lis_loc_pay
                               --Finance Dev Phase I [End]
                               );
               ELSE
                  UPDATE fid_license_sub_ledger
                     SET lis_price = lic_price,
                         lis_adjust_factor = lic_factor,
                         lis_rate = lic.lic_rate,
                         lis_paid_exhibition = sch_paid,
                         lis_con_forecast = con_forecast,
                         lis_loc_forecast = loc_forecast,
                         lis_con_actual = con_actual,
                         lis_loc_actual = loc_actual,
                         lis_con_adjust = NVL (lis_con_adjust, 0),
                         lis_loc_adjust = NVL (lis_loc_adjust, 0),
                         lis_entry_oper = user_id,
                         lis_entry_date = SYSDATE,
                         lis_lic_start_rate = lic.lic_rate,
                         lis_lic_start = lic.lic_start,
                         lis_lic_end = lic.lic_end,
                         --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/26]
                         lis_reval_flag =  NVL(l_reval_flag,'NC'),
                         --Dev : Fin CR : End
                         --Finance Dev Phase I Zeshan [Start]
                         lis_lic_cur = lic.lic_currency,
                         lis_lic_com_number = cha_com_number,
                         lis_lic_status = lic.lic_status,
                         lis_pay_mov_flag = l_lis_pay_mov_flag,
                         lis_con_pay = l_lis_con_pay,
                         lis_loc_pay = l_lis_loc_pay
                         --Finance Dev Phase I [End]
                   WHERE     lis_lic_number = lic.lic_number
                         AND lis_ter_code = cht.cht_ter_code
                         AND lis_per_year = periodyearv
                         AND lis_per_month = periodmonthv;
               END IF;

               CLOSE lsl1;

               lic_con_actual := lic_con_actual + con_actual;
               lic_loc_actual := lic_loc_actual + loc_actual;
            END LOOP;                                          -- end cht loop

            -- check to see whether the total of the royalties calculated
            -- with the pro-rated subscriber numbers equals the expected
            -- total for the minimum subscriber level. if not then put
            -- the variance (0.01 usually) into the last sub-ledger
            -- record processed.
            IF min_subscriber = TRUE
            THEN
               BEGIN
                  lic_min_amount :=
                     NVL (
                        ROUND (
                             lic_price
                           * (NVL (sch_paid, 0) / NVL (lic_showing_use, 10))
                           * lic.lic_min_subscriber,
                           2),
                        0);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     lic_min_amount := 0;
               END;

               /*
               NOC :
               To set lis_lic_start_rate , so if license start date is moved to future date, lis_lic_start_rate can be used in inventory report
               NEERAJ : KARIM : 13-12-2013
               */
               IF lic_con_actual != lic_min_amount
               THEN
                  UPDATE fid_license_sub_ledger
                     SET lis_con_actual =
                            con_actual + (lic_min_amount - lic_con_actual),
                         lis_entry_oper = user_id,
                         lis_entry_date = SYSDATE,
                         lis_lic_start_rate = lic.lic_rate
                   WHERE     lis_lic_number = lic.lic_number
                         AND lis_ter_code = cht.cht_ter_code
                         AND lis_per_year = periodyearv
                         AND lis_per_month = periodmonthv;

                  lic_con_actual := lic_min_amount;
                  lic_loc_actual := ROUND (lic_min_amount * lic.lic_rate, 2);
               END IF;
            END IF;

            --  if the sum of the lis_con_actuals (royalty figure) to date
            --  is less than the lic_min_guarantee figure then set lis_
            --  con_adjust on the last sub ledger record processed equal
            --  to the difference in order to reflect it.
            IF (lic.lic_end <= per_end_date AND lic.lic_end >= per_date)
            THEN
               total_royalty := 0;
               total_forecast := 0;
               con_adjust := 0;
               loc_adjust := 0;
               forecast_diff := 0;
               adjust_diff := 0;

               OPEN lis_total_c (lic.lic_number);

               FETCH lis_total_c
               INTO total_royalty, total_forecast;

               IF NVL (lic.lic_min_guarantee, 0) > total_forecast
               THEN
                  forecast_diff :=
                     ROUND (lic.lic_min_guarantee - total_forecast, 2);

                  /*
                  NOC :
                  To set lis_lic_start_rate , so if license start date is moved to future date, lis_lic_start_rate can be used in inventory report
                  NEERAJ : KARIM : 13-12-2013
                  */
                  UPDATE fid_license_sub_ledger
                     SET lis_con_forecast =
                            NVL (lis_con_forecast, 0) + forecast_diff,
                         lis_loc_forecast =
                            ROUND (
                               (NVL (lis_con_forecast, 0) + forecast_diff)
                               * lic.lic_rate,
                               2),
                         lis_entry_oper = user_id,
                         lis_entry_date = SYSDATE,
                         lis_lic_start_rate = lic.lic_rate
                   WHERE     lis_lic_number = lic.lic_number
                         AND lis_ter_code = now_territory
                         AND lis_per_year = periodyearv
                         AND lis_per_month = periodmonthv;
               END IF;

               IF NVL (lic.lic_min_guarantee, 0) > total_royalty
               THEN
                  adjust_diff :=
                     ROUND (lic.lic_min_guarantee - total_royalty, 2);

                  /*
                  NOC :
                  To set lis_lic_start_rate , so if license start date is moved to future date, lis_lic_start_rate can be used in inventory report
                  NEERAJ : KARIM : 13-12-2013
                  */
                  UPDATE fid_license_sub_ledger
                     SET lis_con_adjust =
                            NVL (lis_con_adjust, 0) + adjust_diff,
                         lis_loc_adjust =
                            ROUND (
                               (NVL (lis_con_adjust, 0) + adjust_diff)
                               * lic.lic_rate,
                               2),
                         lis_adjust_comment =
                            'Adjusted for licensed ' || 'minimum guarantee',
                         lis_entry_oper = user_id,
                         lis_entry_date = SYSDATE,
                         lis_lic_start_rate = lic.lic_rate
                   WHERE     lis_lic_number = lic.lic_number
                         AND lis_ter_code = now_territory
                         AND lis_per_year = periodyearv
                         AND lis_per_month = periodmonthv;
               END IF;

               CLOSE lis_total_c;
            END IF;

           <<end_lic>>
            NULL;
         END LOOP;                                         -- end license loop
      END LOOP;                                        -- end of contract loop
   END;

   /* ==========================================================
      ========================================================== */

   -- Pure Finance: Ajit : 25-Feb-2013 : Wrapper package to call all the procedures
   PROCEDURE monthly_costing_calculations (
      i_com_number       IN fid_company.com_number%TYPE,
      i_con_number       IN fid_contract.con_number%TYPE,
      i_con_type         IN fid_contract.con_calc_type%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_month_end_type   IN VARCHAR2,
      i_region           IN fid_region.reg_code%TYPE,
      i_user_id          IN VARCHAR2,
      i_log_date         IN VARCHAR2,
      i_user_email       IN VARCHAR2)
   AS
      month_end_from_date   DATE;
      month_end_todate      DATE;
      month_end_rate_date   DATE;
      first_date_of_month   DATE;
      last_date_of_month    DATE;
      discount_rate         NUMBER;
      forward_rate          NUMBER;
      holiday_count         NUMBER;
      no_of_warnings        NUMBER;
      email_status          NUMBER;
   BEGIN
      -- Get the month end from date and to date
      SELECT fmd_from_date, fmd_to_date
        INTO month_end_from_date, month_end_todate
        FROM x_fin_month_defn, fid_region
       WHERE     UPPER (fmd_mon_end_type) = UPPER (i_month_end_type)
             AND fmd_month = i_current_month
             AND fmd_year = i_current_year
             AND fmd_region = reg_id
             AND UPPER (NVL (reg_code, '#')) LIKE
                    UPPER (
                       DECODE (i_region, '%', NVL (reg_code, '#'), i_region))
             AND ROWNUM < 2;

      -- Assign the month end to date to rate date
      month_end_rate_date := month_end_todate;
      --- Identify the first day of Amortisation month
      first_date_of_month :=
         TO_DATE (
               '01'
            || TO_CHAR (i_current_month, '09')
            || TO_CHAR (i_current_year),
            'DDMMYYYY');
      --- Identify the last day of Amortisation month
      last_date_of_month :=
         LAST_DAY (
            TO_DATE (
                  '01'
               || TO_CHAR (i_current_month, '09')
               || TO_CHAR (i_current_year),
               'DDMMYYYY'));

      -- Loop the dates untill get the working day
      LOOP
         IF UPPER (TO_CHAR (month_end_rate_date, 'DAY')) <> 'SUNDAY'
         THEN
            SELECT COUNT (1)
              INTO holiday_count
              FROM tbl_tvf_holidays
             WHERE thol_holiday_date = month_end_rate_date;

            EXIT WHEN holiday_count = 0;
         END IF;

         month_end_rate_date := month_end_rate_date - 1;
      END LOOP;

      --calculate the daily discount rate
      discount_rate :=
         x_pkg_fin_get_spot_rate.get_discount_rate (i_current_month,
                                                    i_current_year);

      -- If the contract is FLF then check if the Contract is ED applicable
      IF UPPER (i_con_type) = 'FLF'
      THEN
         -- Check if the Contract is ED applicable
         mark_ed_applicable (i_current_month,
                             i_current_year,
                             i_con_number,
                             i_user_id);
      END IF;

      IF UPPER (i_month_end_type) = 'FINAL'
      THEN
         pre_payment_pre_license_settle (i_com_number,
                                         i_con_number,
                                         i_region,
                                         i_current_month,
                                         i_current_year,
                                         month_end_from_date,
                                         month_end_todate,
                                         i_user_id);
      END IF;
      
      --Finance Dev Phase I Zeshan [Start]
      --Below marks all the payment for the open month as
      --'Payment' or 'Prepayment'
      --The above is to make sure closed month data
      --does not change
      X_PRC_SET_PAY_TYPE(I_OPEN_MONTH => first_date_of_month);
      --Finance Dev Phase I [End]
      
      -- Calculate the amortisation for historical FLF licenses
      -- Licenses whose license start date is before Pure Finance Go-live
      calculate_amortisation (i_com_number,
                              i_current_month,
                              i_current_year,
                              i_con_number,
                              i_user_id,
                              i_region);
      -- Calculate the amortisation for new FLF licenses
      -- Licenses whose license start date is after Pure Finance Go-live
      calculate_fin_amortisation (i_com_number,
                                  i_current_month,
                                  i_current_year,
                                  month_end_from_date,
                                  month_end_todate,
                                  i_con_number,
                                  -- nvl(discount_rate,0),
                                  month_end_rate_date,
                                  i_user_id,
                                  i_month_end_type,
                                  i_region);

      IF UPPER (i_month_end_type) = 'FINAL'
      THEN
         -- Calculate the unrealized forex gain loss the ED
         calc_unrealized_forex_ed (i_con_number,
                                   i_current_month,
                                   i_current_year,
                                   NVL (discount_rate, 0),
                                   month_end_todate,
                                   i_region,
                                   i_user_id);
      END IF;

      -- Calculate the amortisation for historical ROY licenses
      -- Licenses whose license start date is before Pure Finance Go-live
      calculate_royalty (i_com_number,
                         i_current_month,
                         i_current_year,
                         i_con_number,
                         i_user_id,
                         i_region);
      -- Calculate the amortisation for new ROY licenses
      -- Licenses whose license start date is after Pure Finance Go-live
      calculate_fin_royalty (i_com_number,
                             i_current_month,
                             i_current_year,
                             i_con_number,
                             i_region,
                             i_month_end_type,
                             --nvl(discount_rate,0),
                             month_end_from_date,
                             month_end_todate,
                             month_end_rate_date,
                             i_user_id);

      IF UPPER (i_month_end_type) = 'FINAL'
      THEN
         -- Reverse the inventory, cost, realized, unrealized forex
         -- and do the payment settlement for the Cancelled licenses
         calc_for_cancelled_license (i_con_number,
                                     i_current_month,
                                     i_current_year,
                                     month_end_from_date,
                                     month_end_todate,
                                     i_region,
                                     month_end_rate_date,
                                     i_user_id);
         -- Calculate the realized forex gain loss for the
         -- historical licenses (whose pay date is after the Pure
         -- Finance Go-live and license start date is before the
         -- Pure Finance Go-Live date)
         payment_historical_licenses (i_con_number,
                                      i_current_month,
                                      i_current_year,
                                      month_end_from_date,
                                      month_end_todate,
                                      i_region,
                                      i_user_id);
         -- Make the old licenses Inactive
         make_lic_inactive (i_con_number,
                            i_current_month,
                            i_current_year,
                            i_user_id);
         --calculate the rate for month end defn and
         --set run status to 'Y'
         update_rate_date (month_end_rate_date,
                           i_month_end_type,
                           i_current_year,
                           i_current_month,
                           i_region);
      END IF;


      /*[09-Aug-2016]:Jawahar Garg - updating the reval flag for licenses skipped during costing calc */
	  BEGIN

			  DELETE x_sub_ledger_reval_log;

			  FOR i IN (
						SELECT *
						  FROM fid_license_sub_ledger
						 WHERE lis_per_year || LPAD (lis_per_month, 2, 0) = CONCAT(i_current_year,LPAD(i_current_month,2,0))
						   AND NVL(lis_reval_flag,'NC') = 'NC'
						   AND (
								NVL(lis_con_forecast,0) <> 0 OR NVL(lis_loc_forecast,0) <> 0
							   )
						)
			  LOOP
				  INSERT INTO x_sub_ledger_reval_log(
						lis_lic_number		,
						lis_lsl_number		,
						lis_lic_start		,
						lis_per_month		,
						lis_per_year		,
						lis_ter_code		,
						lis_entry_oper	,
						lis_entry_date
						)
						VALUES
						(
						i.lis_lic_number,
						i.lis_lsl_number,
						i.lis_lic_start,
						i_current_month,
						i_current_year,
						i.lis_ter_code,
						i_user_id,
						SYSDATE
						);

						UPDATE fid_license_sub_ledger
						   SET lis_reval_flag = 'PC'
						 WHERE lis_per_year || LPAD (lis_per_month, 2, 0) = CONCAT(i_current_year,LPAD(i_current_month,2,0))
						   AND lis_lic_number = i.lis_lic_number
						   AND lis_lsl_number = i.lis_lsl_number
						   AND lis_ter_code = i.lis_ter_code;
			  END LOOP;

			  COMMIT;

	  EXCEPTION
	  WHEN OTHERS THEN
	  NULL;
	  END;

   END monthly_costing_calculations;

   -- Pure Finance: Ajit : 02-Apr-2013 : Procedure added to processes the new ROY licenses
   -- The licenses started after the GO-Live date of Pure Finance
   PROCEDURE calculate_fin_royalty (cha_com_number        IN NUMBER,
                                    period_month          IN NUMBER,
                                    period_year           IN NUMBER,
                                    con_number            IN NUMBER,
                                    regioncode            IN VARCHAR2,
                                    month_end_type        IN VARCHAR2,
                                    from_date             IN DATE,
                                    todate                IN DATE,
                                    month_end_rate_date   IN DATE,
                                    user_id               IN VARCHAR2)
   IS
      periodyearv                      NUMBER;
      periodmonthv                     NUMBER;
      old_lic_price                    NUMBER;
      lic_start_month                  NUMBER := 0;
      lic_start_year                   NUMBER := 0;
      lic_start_value                  NUMBER;
      lic_end_value                    NUMBER;
      lic_acc_value                    NUMBER;
      period_value                     NUMBER;
      pre_license                      BOOLEAN;
      pre_license_made_curr_month      BOOLEAN;
      first_month                      BOOLEAN;
      last_month                       BOOLEAN;
      expired_license                  BOOLEAN;
      writeoff_license                 BOOLEAN;
      writeoff_lic_made_curr_month     BOOLEAN;
      price_changed_license            BOOLEAN;
      accouting_month                  BOOLEAN;
      writeoff_flag                    BOOLEAN;
      writeoff_auth_date               NUMBER;
      per_date                         DATE;
      per_end_date                     DATE;
      l_lic_status                     VARCHAR2 (3);
      last_date_of_last_month          DATE;
      l_lic_lsl_number                 NUMBER; --l_lsl_lic_number     --27Mar2015: Ver 0.2 : Jawahar - Renamed l_lsl_lic_number to l_lic_lsl_number for better readability
      disc_writeoff_auth_date          DATE;
      forecast_till_curr_month         NUMBER := 0;
      loc_fore_till_curr_month         NUMBER := 0;
      actual_till_curr_month           NUMBER := 0;
      act_exc_wrtoff_till_curr_mth     NUMBER := 0;
      loc_actual_till_curr_month       NUMBER := 0;
      pv_forecast_till_curr_month      NUMBER := 0;
      pv_loc_fore_till_curr_month      NUMBER := 0;
      pv_inv_actual_till_curr_month    NUMBER := 0;
      pv_inv_loc_act_till_curr_month   NUMBER := 0;
      costed_schedules_for_curr_mon    NUMBER := 0;
      costed_schedule_till_curr_mon    NUMBER := 0;
      costed_schedule_till_last_mon    NUMBER := 0;
      con_writeoff_till_last_month     NUMBER := 0;
      actual_due_to_price_change       NUMBER := 0;
      loc_act_due_to_price_change      NUMBER := 0;
      pv_actual_due_to_price_change    NUMBER := 0;
      pv_loc_act_due_to_price_change   NUMBER := 0;
      forward_to_date_rate             NUMBER := 0;
      license_start_rate               NUMBER := 0;
      con_writeoff                     NUMBER := 0;
      con_rev_writeoff                 NUMBER := 0;
      loc_writeoff                     NUMBER := 0;
      loc_rev_writeoff                 NUMBER := 0;
      con_actual                       NUMBER := 0;
      loc_actual                       NUMBER := 0;
      pv_con_actual                    NUMBER := 0;
      pv_loc_actual                    NUMBER := 0;
      mth_end_date_rate                NUMBER := 0;
      Discount_Rate                    NUMBER := 0;
      --Start - 10-March-2015
      /*L_Is_Write_Off                   NUMBER := 0; */
      --End - 10-March-2015
      cost_curr_mth_showings           NUMBER := 0;
      remain_showings                  NUMBER := 0;
      old_lic_start                    DATE;
      old_lic_end                      DATE;
      duration_changed_license         BOOLEAN;

      CURSOR con_c (connumber NUMBER)
      IS
           SELECT *
             FROM fid_company, fid_contract
            WHERE     con_status = 'A'
                  AND con_number = connumber
                  AND con_number IN (SELECT DISTINCT lic_con_number
                                       FROM fid_license
                                      WHERE lic_type = 'ROY')
                  AND com_number = con_com_number
         ORDER BY con_number;

      con                              con_c%ROWTYPE;

      CURSOR lic_c (
         connumber      NUMBER,
         periodstart    DATE,
         periodend      DATE,
         regioncode     VARCHAR2)
      IS
         SELECT lic_number,
                lic_showing_int,
                NVL (lic_showing_lic, 0) lic_showing_lic,
                lic_amort_code,
                lic_start,
                lic_end,
                lic_acct_date,
                NVL (lic_rate, 0) lic_rate,
                lic_price,
                lic_chs_number,
                lic_currency,
                lic_min_guarantee,
                lic_min_subscriber,
                NVL (lic_writeoff, 'N') lic_writeoff,
                lic_status,
                ter_cur_code,
                NVL (lic_start_rate, 0) lic_start_rate
           FROM fid_license,
                fid_licensee,
                fid_region,
                fid_company,
                fid_territory
          WHERE     lic_con_number = connumber
                AND NVL (lic_acct_date,
                         TO_DATE ('31-DEC-2099', 'DD-MON-YYYY')) <= periodend
                AND lee_cha_com_number = com_number
                AND com_ter_code = ter_code
                AND lee_number = lic_lee_number
                AND lic_type = 'ROY'
                -- Pure Finance: Ajit : 02-Apr-2013 : License Status Active
                -- condition, region specific and license start date less than Pure Finance
                -- Go-live date
                AND reg_id(+) = lee_split_region
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (regioncode,
                                  '%', NVL (reg_code, '#'),
                                  regioncode))
                AND UPPER (lic_status) = 'A'
                AND lic_start >= (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                    FROM x_fin_configs
                                   WHERE KEY = 'GO-LIVEDATE');

      -- Cursor to get the Amortization till routine month (Inventory and Cost)
      CURSOR lis_c (
         licnumber    NUMBER,
         tercode      VARCHAR2,
         peryear      NUMBER,
         permonth     NUMBER)
      IS
         SELECT NVL (SUM (lis_con_forecast), 0),
                NVL (
                   SUM (
                        lis_con_actual
                      + lis_con_adjust
                      + NVL (lis_con_writeoff, 0)),
                   0),
                NVL (SUM (lis_con_actual + lis_con_adjust), 0),
                NVL (SUM (lis_pv_con_forecast), 0),
                NVL (SUM (lis_pv_con_inv_actual), 0),
                NVL (SUM (lis_loc_forecast), 0),
                NVL (
                   SUM (
                        lis_loc_actual
                      + lis_loc_adjust
                      + NVL (lis_loc_writeoff, 0)),
                   0),
                NVL (SUM (lis_pv_loc_forecast), 0),
                NVL (SUM (lis_pv_loc_inv_actual), 0)
           FROM fid_license_sub_ledger
          WHERE lis_lic_number = licnumber AND lis_ter_code = tercode
                AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                       peryear || LPAD (permonth, 2, 0);

      CURSOR cht_c (
         licchsnumber NUMBER)
      IS
         SELECT DISTINCT cht_ter_code
           FROM fid_channel_territory
          WHERE ( (cht_cha_number = licchsnumber)
                 OR EXISTS
                       (SELECT 'X'
                          FROM fid_channel_service
                         WHERE chs_number = licchsnumber
                               AND chs_cha_number = cht_cha_number
                        UNION
                        SELECT 'X'
                          FROM fid_channel_service_channel
                         WHERE     csc_chs_number = licchsnumber
                               AND csc_cha_number = cht_cha_number
                               AND csc_include_subs = 'Y'
                               AND TO_CHAR (csc_end_dt, 'YYYYMM') >=
                                      period_year
                                      || LPAD (period_month, 2, 0)));

      cht                              cht_c%ROWTYPE;
      --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/24]
      l_reval_flag                     fid_license_sub_ledger.lis_reval_flag%TYPE := 'NC';
      --Dev : Fin CR : End
      --Finance Dev Phase I Zeshan [Start]
      l_lis_con_pay                    fid_license_sub_ledger.lis_con_pay%TYPE;
      l_lis_loc_pay                    fid_license_sub_ledger.lis_loc_pay%TYPE;
      l_lis_pay_mov_flag               fid_license_sub_ledger.lis_pay_mov_flag%TYPE;
      --Finance Dev Phase I [End]
   BEGIN
      -- initially copying parameters passed into local procedure variables
      periodmonthv := period_month;
      periodyearv := period_year;
      --- Identify the year month of Amortisation month in YYYYMM format
      period_value := period_year || LPAD (period_month, 2, 0);
      --  identify the royalty month and calculate the preceding month
      per_date :=
         TO_DATE (
            '01' || TO_CHAR (periodmonthv, '09') || TO_CHAR (periodyearv),
            'DDMMYYYY');
      per_end_date :=
         LAST_DAY (
            TO_DATE (
               '01' || TO_CHAR (periodmonthv, '09') || TO_CHAR (periodyearv),
               'DDMMYYYY'));
      -- Get the last date of last month
      last_date_of_last_month := LAST_DAY (ADD_MONTHS (per_date, -1));

      -- start the contract loop
      FOR con IN con_c (con_number)
      LOOP                                                    -- contract loop
         -- run the stored package roypck.sql which populates the fid_
         -- contract_subscriber table, via the calculate_subscribers procedure.
         fid_roy_pk.calculate_subscribers (con.con_number,
                                           periodyearv,
                                           periodmonthv);

         -- select the licenses for the contract and start the license loop
         FOR lic IN lic_c (con.con_number,
                           per_date,
                           per_end_date,
                           regioncode)
         LOOP
            --Start - 10-March-2015
            /*Select Count(1)
            Into  L_Is_Write_Off
            From X_Fin_Write_Off_Roy_Last_Month
            Where Wfr_Lic_Number = Lic.Lic_Number
            and  to_char(Wfr_Lic_End_Month,'YYYYMM') = period_value
            ;*/
            --End - 10-March-2015
            -- Get the license start, end and accouting date values into local variable
            lic_start_value :=
               TO_NUMBER (
                  TO_CHAR (lic.lic_start, 'YYYY')
                  || TO_CHAR (lic.lic_start, 'MM'));
            lic_end_value :=
               TO_NUMBER (
                  TO_CHAR (lic.lic_end, 'YYYY')
                  || TO_CHAR (lic.lic_end, 'MM'));
            lic_acc_value :=
               TO_NUMBER (
                  TO_CHAR (lic.lic_acct_date, 'YYYY')
                  || TO_CHAR (lic.lic_acct_date, 'MM'));



            -- Check if the accouting date is less than Amortisation month and
            -- License start date is greater than Amortisation month
            -- then it is a pre-license

						--Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/23]
            l_reval_flag := NULL;
            BEGIN
             SELECT LIS_LIC_START
               INTO old_lic_start
               FROM fid_license_sub_ledger
              WHERE lis_lic_number = lic.lic_number
                AND lis_per_year || LPAD (lis_per_month, 2, 0) =TO_NUMBER ( TO_CHAR (last_date_of_last_month, 'YYYYMM'))
                AND ROWNUM < 2;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
            old_lic_start := lic.lic_start;
            END;
						--Dev : Fin CR : END : [Jawahar Garg]_[2016/05/23]
            IF lic_acc_value <= period_value
               AND lic_start_value > period_value
            THEN
               pre_license := TRUE;
               l_lic_status := 'PL';                            -- Pre License

               -- Check if the accouting date is equal to Amortisation month
               -- then it is pre-license made in curent month
							 --Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/23]
							 IF lic_start_value > TO_NUMBER(TO_CHAR(old_lic_start,'YYYYMM'))
							 THEN
							 l_reval_flag := 'RL';
							 END IF;
							 --Dev : Fin CR : END : [Jawahar Garg]_[2016/05/23]

               IF lic_acc_value = period_value
               THEN
                  pre_license_made_curr_month := TRUE;
               ELSE
                  pre_license_made_curr_month := FALSE;
               END IF;
            ELSE
               pre_license := FALSE;
            END IF;

            -- Check if the license is starting in amortization month
            -- then it is First Month
            IF lic_acc_value = period_value
            THEN
               accouting_month := TRUE;
            ELSE
               accouting_month := FALSE;
            END IF;

            -- Check if the license end date is less than Amortisation month
            -- then it is expired license
            IF lic_end_value < period_value
            THEN
               expired_license := TRUE;
               l_lic_status := 'EX';                        -- Expired License
            ELSE
               expired_license := FALSE;
            END IF;

            -- Check if the license is starting in amortization month
            -- then it is First Month
            IF lic_start_value = period_value
            THEN
               first_month := TRUE;
               --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/23]
               l_reval_flag := 'AL';
               --Dev : Fin CR : End
            ELSE
               -- Check if the Inventory till date is not eqaul to
               first_month := FALSE;
            END IF;

            -- Check if the license is Writen off
            IF pre_license = FALSE AND lic.lic_writeoff = 'Y'
            THEN
               IF first_month = TRUE OR accouting_month = TRUE
               THEN
                  -- Get the max write off authorization date
                  SELECT TO_NUMBER (TO_CHAR (MAX (dwo_auth_date), 'YYYYMM'))
                    INTO writeoff_auth_date
                    FROM x_fin_disc_write_off
                   WHERE dwo_lic_no = lic.lic_number
                         AND UPPER (dwo_auth_status) = 'AUTHORISED';

                  -- Check if the license autorization date is in current month
                  -- then it is written off license in current month
                  IF writeoff_auth_date >= period_value
                  THEN
                     writeoff_lic_made_curr_month := TRUE;
                     writeoff_license := TRUE;
                  ELSE
                     writeoff_lic_made_curr_month := FALSE;
                  END IF;
               ELSE
                  writeoff_license := TRUE;
                  --writeoff_lic_made_curr_month := TRUE;
                  l_lic_status := 'WR';                   -- Write-off License
               END IF;
            ELSE
               writeoff_license := FALSE;
               writeoff_lic_made_curr_month := FALSE;
            END IF;

            old_lic_price := 0;

            -- Get the license price of last month for any terrotiry
            -- from license sub ledger table
            BEGIN
               SELECT NVL (lis_price, 0),LIS_LIC_START,LIS_LIC_END
                 INTO old_lic_price,old_lic_start,old_lic_end
                 FROM fid_license_sub_ledger
                WHERE lis_lic_number = lic.lic_number AND lis_price <> 0
                      AND lis_per_year || LPAD (lis_per_month, 2, 0) =
                             TO_NUMBER (
                                TO_CHAR (last_date_of_last_month, 'YYYYMM'))
                      AND ROWNUM < 2;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  old_lic_price := lic.lic_price;
            END;

            IF accouting_month = FALSE
            THEN
               IF pre_license = FALSE AND first_month = FALSE
               THEN
                  IF lic.lic_price <> old_lic_price
                  THEN
                     UPDATE fid_license
                        SET lic_price_chg_flg = 'Y',
                            lic_entry_oper = user_id,
                            lic_entry_date = SYSDATE
                      WHERE lic_number = lic.lic_number;

                     price_changed_license := TRUE;
                     l_lic_status := 'PC';            -- Price Changed License
                     --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/23]
                     l_reval_flag := 'PC';
                     --Dev : Fin CR : End
                  ELSE
                     price_changed_license := FALSE;
                  END IF;
               ELSE
                  price_changed_license := FALSE;
               END IF;
            ELSE
               price_changed_license := FALSE;
            END IF;

            -- Check if the license is ending in amortization month
            -- then it is Lsst Month
            IF lic_end_value = period_value
            THEN
               last_month := TRUE;
            ELSE
               last_month := FALSE;
            END IF;

            --delete records from sub ledger for current routine month
            DELETE FROM fid_license_sub_ledger
                  WHERE lis_lic_number = lic.lic_number
                        AND lis_per_year || LPAD (lis_per_month, 2, 0) >=
                               period_value;

            --delete records from realized forex for current routine month
            DELETE FROM x_fin_realized_forex
                  WHERE rzf_lic_number = lic.lic_number
                        AND rzf_year || LPAD (rzf_month, 2, 0) >=
                               period_value;

            --delete records for unrealized forex gain\loss for current routine
            --month
            DELETE FROM x_fin_unrealized_forex
                  WHERE unf_lic_number = lic.lic_number
                        AND unf_year || LPAD (unf_month, 2, 0) >=
                               period_value;

            --delete records from refun settle for current routine month
            DELETE FROM x_fin_refund_settle
                  WHERE frs_lic_number = lic.lic_number
                        AND frs_year || LPAD (frs_month, 2, 0) >=
                               period_value;

            --Delete records from Asset adj for Warner Payment added by Sushma/Swapnil on:24/07/2015
            DELETE FROM x_fin_mg_asset_adj
                  WHERE msa_lic_number = lic.lic_number
                        AND msa_calc_year || LPAD (msa_calc_month, 2, 0) >=
                               period_value;

            -- Get the primary licensee refereance from the secondary licensee table
            SELECT lsl_number
              INTO l_lic_lsl_number --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
              FROM x_fin_lic_sec_lee
             WHERE     lsl_lic_number = lic.lic_number
                   AND UPPER (lsl_is_primary) = 'Y'
                   AND ROWNUM < 2;


            IF first_month
            THEN
               --If license start date is greater than todate then check if spot rate
               --is available on lic_start_date else get spot rate closest to month end rate date
               license_start_rate :=
                  x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                     lic.lic_currency,
                     lic.ter_cur_code,
                     lic.lic_start);

               IF license_start_rate IS NULL
               THEN
                  license_start_rate :=
                     x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                        lic.lic_currency,
                        lic.ter_cur_code,
                        month_end_rate_date);
               END IF;
            ELSE
               license_start_rate := lic.lic_start_rate;
            END IF;

            mth_end_date_rate :=
               x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                  lic.lic_currency,
                  lic.ter_cur_code,
                  todate);
            -- Settle the Pre-payments for Active ROY licenses
            pre_payment_settlement_for_roy (lic.lic_number,
                                            l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                            periodmonthv,
                                            periodyearv,
                                            from_date,
                                            todate,
                                            lic.lic_status,
                                            user_id);
            fid_cos_pk.calculate_refund_settlement (lic.lic_number,
                                                    l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                                    periodmonthv,
                                                    periodyearv,
                                                    from_date,
                                                    todate,
                                                    user_id);

            --check if license in made in current month
            IF pre_license = TRUE
            THEN
               -- if accounting date is not in open month
               IF pre_license_made_curr_month = FALSE
               THEN
                  --  Select the channel/service subscriber territories and start the cht loop
                  FOR cht IN cht_c (lic.lic_chs_number)
                  LOOP
                     -- Get the cumulative inventory  and cost till previous month for
                     -- each licensee of a licence
                     reverse_inventory_and_cost (lic.lic_number,
                                                 lic.lic_currency,
                                                 lic.lic_acct_date,
                                                 l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                                 lic.lic_price,
                                                 cht.cht_ter_code,
                                                 period_year,
                                                 period_month,
                                                 user_id,
                                                 l_reval_flag);	--Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/24]
                  END LOOP;

                  -- Reverse cumulative realized forex G\L till past month
                  -- for each paid payment of each secondry licensee having
                  -- amount greate than zero
                  reverse_real_forex_gain_loss (lic.lic_number,
                                                l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                                period_year,
                                                period_month,
                                                user_id);
                  -- Reverse cumulative realized forex G/L till past month for each paid payment
                  -- having amount less than zero and whose payment is not settled (payment no. does not
                  -- exists in refund settlements table)
                  rev_real_forex_pay_not_settle (lic.lic_number,
                                                 l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                                 period_year,
                                                 period_month,
                                                 user_id);
               END IF;

               IF UPPER (month_end_type) = 'FINAL'
               THEN
                  --Get the discretionary write off flag
                  --and max Authorization date for license
                  SELECT MAX (dwo_auth_date)
                    INTO disc_writeoff_auth_date
                    FROM x_fin_disc_write_off
                   WHERE dwo_lic_no = lic.lic_number;

                  IF writeoff_license = TRUE
                     AND per_end_date >= disc_writeoff_auth_date
                  THEN
                     -- set the write off flag null
                     UPDATE fid_license
                        SET lic_writeoff = NULL,
                            lic_writeoff_mark = 'N',
                            lic_entry_oper = user_id,
                            lic_entry_date = SYSDATE
                      WHERE lic_number = lic.lic_number
                            AND NVL (lic_writeoff, 'N') <> 'N';
                  END IF;

                  IF lic_acc_value < period_value
                  THEN
                     UPDATE fid_license
                        SET lic_rate = NULL,
                            lic_start_rate = NULL,
                            lic_price_chg_flg = 'N',
                            lic_before_acct_date = 'Y',
                            -- set lic_before_acct_date to 'Y' to show reversal license in the commitment report lic_start month
                            lic_entry_oper = user_id,
                            lic_entry_date = SYSDATE
                      WHERE lic_number = lic.lic_number;
                  ELSE
                     UPDATE fid_license
                        SET lic_rate = NULL,
                            lic_start_rate = NULL,
                            lic_acct_date = NULL,
                            lic_price_chg_flg = 'N',
                            lic_before_acct_date = 'Y',
                            -- set lic_before_acct_date to 'Y' to show reversal license in the commitment report lic_start month
                            lic_entry_oper = user_id,
                            lic_entry_date = SYSDATE
                      WHERE lic_number = lic.lic_number;
                  END IF;
               END IF;
            ELSE
               lic_start_month := TO_NUMBER (TO_CHAR (lic.lic_start, 'MM'));
               lic_start_year := TO_NUMBER (TO_CHAR (lic.lic_start, 'YYYY'));
               discount_rate :=
                  x_pkg_fin_get_spot_rate.get_discount_rate (lic_start_month,
                                                             lic_start_year);

               IF first_month = TRUE
               THEN
                  -- Reverse cumulative realized forex G\L till past month
                  -- for each paid payment of each secondry licensee having
                  -- amount greate than zero
                  reverse_real_forex_gain_loss (lic.lic_number,
                                                l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                                period_year,
                                                period_month,
                                                user_id);
                  calc_realized_pre_pay_roy (lic.lic_number,
                                             l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                             period_month,
                                             period_year,
                                             license_start_rate,
                                             user_id);
                  -- Reverse cumulative realized forex G/L till past month for each paid payment
                  -- having amount less than zero and whose payment is not settled (payment no. does not
                  -- exists in refund settlements table)
                  rev_real_forex_pay_not_settle (lic.lic_number,
                                                 l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                                 period_year,
                                                 period_month,
                                                 user_id);

                  IF writeoff_lic_made_curr_month = FALSE
                  THEN
                     -- Untick the write off flag
                     UPDATE fid_license
                        SET lic_writeoff = NULL,
                            lic_writeoff_mark = 'N',
                            lic_entry_oper = user_id,
                            lic_entry_date = SYSDATE
                      WHERE lic_number = lic.lic_number
                            AND NVL (lic_writeoff, 'N') <> 'N';
                  END IF;
               END IF;

               /* IF  (    first_month = TRUE
                       AND writeoff_lic_made_curr_month = FALSE
                      )
                   OR (first_month = false and writeoff_license = TRUE)
                   --(first_month = FALSE AND writeoff_license = TRUE)
                then*/

               -- Identify the Costed Schedule for the routine month
               identify_costed_schedules (lic.lic_number,
                                          period_month,
                                          period_year,
                                          user_id);
               --  Calculate the inventory
               
               calulate_inventory_for_roy (con.con_number,
                                           lic.lic_number,
                                           l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                           lic.lic_chs_number,
                                           lic.lic_start,
                                           lic.lic_price,
                                           old_lic_price,
                                           lic.lic_min_subscriber,
                                           l_lic_status,
                                           first_month,
                                           period_month,
                                           period_year,
                                           license_start_rate,
                                           discount_rate,
                                           user_id,
										   l_reval_flag, 	 --Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/24]
										   --Finance Dev Phase I Zeshan [Start]
										   lic.lic_currency,
										   con.con_com_number
										   --Finance Dev Phase I [End]
										   );

               --  Select the channel/service subscriber territories and start the cht loop
               FOR cht IN cht_c (lic.lic_chs_number)
               LOOP
                  con_writeoff := 0;
                  loc_writeoff := 0;
                  con_actual := 0;
                  loc_actual := 0;
                  con_rev_writeoff := 0;
                  loc_rev_writeoff := 0;

                  IF first_month = TRUE
                  THEN
                     IF writeoff_lic_made_curr_month = FALSE
                     THEN
                        -- Get the write off cost till last month
                        -- and reverse the write off till routine month
                        SELECT -NVL (SUM (lis_con_writeoff), 0),
                               -NVL (SUM (lis_loc_writeoff), 0)
                          INTO con_writeoff, loc_writeoff
                          FROM fid_license_sub_ledger
                         WHERE lis_lic_number = lic.lic_number
                               AND lis_ter_code = cht.cht_ter_code
                               AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                                      period_year
                                      || LPAD (period_month, 2, 0);
                     END IF;
                  END IF;

                  -- Get the costed schedules of current month for linear license
                  SELECT COUNT (*)
                    INTO costed_schedules_for_curr_mon
                    FROM x_fin_cost_schedules
                   WHERE csh_lic_number = lic.lic_number
                         AND csh_year || LPAD (csh_month, 2, 0) =
                                period_year || LPAD (period_month, 2, 0);

                  -- Get the costed schedules till current month for license
                  SELECT COUNT (*)
                    INTO costed_schedule_till_curr_mon
                    FROM x_fin_cost_schedules
                   WHERE csh_lic_number = lic.lic_number
                         AND csh_year || LPAD (csh_month, 2, 0) <=
                                period_year || LPAD (period_month, 2, 0);

                  -- Get the costed schedules till last month for license
                  SELECT COUNT (*)
                    INTO costed_schedule_till_last_mon
                    FROM x_fin_cost_schedules
                   WHERE csh_lic_number = lic.lic_number
                         AND csh_year || LPAD (csh_month, 2, 0) <
                                period_year || LPAD (period_month, 2, 0);

                  -- Open the cursor to get the inventory and
                  -- cost till routine month
                  OPEN lis_c (lic.lic_number,
                              cht.cht_ter_code,
                              periodyearv,
                              periodmonthv);

                  FETCH lis_c
                  INTO forecast_till_curr_month,
                       actual_till_curr_month,
                       act_exc_wrtoff_till_curr_mth,
                       pv_forecast_till_curr_month,
                       pv_inv_actual_till_curr_month,
                       loc_fore_till_curr_month,
                       loc_actual_till_curr_month,
                       pv_loc_fore_till_curr_month,
                       pv_inv_loc_act_till_curr_month;

                  CLOSE lis_c;

                  -- check if the license is made write off
                  -- for the current month or in future month
                  IF (first_month = TRUE
                      AND writeoff_lic_made_curr_month = TRUE)
                     OR writeoff_license = TRUE
                  THEN
                     -- write off amount would be total remaining ivnentory
                     con_writeoff :=
                        ROUND (
                           NVL (
                              con_writeoff
                              + (forecast_till_curr_month
                                 - actual_till_curr_month),
                              0),
                           2);
                     loc_writeoff :=
                        ROUND (
                           NVL (
                              loc_writeoff
                              + (loc_fore_till_curr_month
                                 - loc_actual_till_curr_month),
                              0),
                           2);
                     -- PV cost would be total remaining PV inventory
                     pv_con_actual :=
                        pv_forecast_till_curr_month
                        - pv_inv_actual_till_curr_month;
                     pv_loc_actual :=
                        pv_loc_fore_till_curr_month
                        - pv_inv_loc_act_till_curr_month;
                  ELSIF expired_license = TRUE
                  THEN
                     -- write off amount would be total remaining ivnentory
                     con_writeoff :=
                        forecast_till_curr_month - actual_till_curr_month;
                     loc_writeoff :=
                        loc_fore_till_curr_month - loc_actual_till_curr_month;
                     -- PV cost would be total remaining PV inventory
                     pv_con_actual :=
                        pv_forecast_till_curr_month
                        - pv_inv_actual_till_curr_month;
                     pv_loc_actual :=
                        pv_loc_fore_till_curr_month
                        - Pv_Inv_Loc_Act_Till_Curr_Month;
                  ELSIF Last_Month = TRUE
                  --Start - 10-March-2015
                  --And L_Is_Write_Off > 0
                  --End - 10-March-2015
                  THEN
                     --Start - 10-March-2015
                     --check if there are still costed runs remaining in license end month
                     remain_showings :=
                        lic.lic_showing_lic - costed_schedule_till_curr_mon;

                     --if runs remain then it should be wriiten off
                     IF remain_showings = 0
                     THEN
                        writeoff_flag := FALSE;
                     ELSE
                        writeoff_flag := TRUE;
                     END IF;

                     IF writeoff_flag = FALSE
                     THEN
                        --get the remaining inventory till last month
                        con_actual :=
                             forecast_till_curr_month
                           - actual_till_curr_month
                           - con_writeoff;
                        loc_actual :=
                             loc_fore_till_curr_month
                           - loc_actual_till_curr_month
                           - loc_writeoff;
                     ELSE
                        IF costed_schedules_for_curr_mon = 0
                        THEN
                           -- write off amount would be total remaining ivnentory
                           con_writeoff :=
                                forecast_till_curr_month
                              - actual_till_curr_month
                              - con_writeoff;
                           loc_writeoff :=
                                loc_fore_till_curr_month
                              - loc_actual_till_curr_month
                              - loc_writeoff;
                        ELSE
                           BEGIN
                              cost_curr_mth_showings :=
                                 NVL (
                                    ROUND (
                                       ( (  forecast_till_curr_month
                                          - actual_till_curr_month
                                          - con_writeoff)
                                        * (costed_schedules_for_curr_mon
                                           / (lic.lic_showing_lic
                                              - costed_schedule_till_last_mon) --Remaining Costed schedule till current month
                                                                              )),
                                       2),
                                    0);
                              con_actual := cost_curr_mth_showings;
                              loc_actual :=
                                 NVL (
                                    ROUND (
                                       ( (  loc_fore_till_curr_month
                                          - loc_actual_till_curr_month
                                          - loc_writeoff)
                                        * (costed_schedules_for_curr_mon
                                           / (lic.lic_showing_lic
                                              - costed_schedule_till_last_mon) --Remaining Costed schedule till current month
                                                                              )),
                                       2),
                                    0);
                           EXCEPTION
                              WHEN OTHERS
                              THEN
                                 cost_curr_mth_showings := 0;
                                 con_actual := 0;
                                 loc_actual := 0;
                           END;

                           con_writeoff :=
                              ROUND (
                                 con_writeoff
                                 + (forecast_till_curr_month
                                    - (  actual_till_curr_month
                                       + cost_curr_mth_showings
                                       + con_writeoff)),
                                 2);
                           loc_writeoff :=
                              ROUND (
                                 NVL (
                                    loc_writeoff
                                    + (loc_fore_till_curr_month
                                       - (  loc_actual_till_curr_month
                                          + loc_actual
                                          + loc_writeoff)),
                                    0),
                                 2);
                        END IF;
                     END IF;

                     --End - 10-March-2015
                     /*-- write off amount would be total remaining ivnentory
                     con_writeoff :=
                        forecast_till_curr_month - actual_till_curr_month;
                     loc_writeoff :=
                        loc_fore_till_curr_month - loc_actual_till_curr_month;*/
                     -- PV cost would be total remaining PV inventory
                     pv_con_actual :=
                        pv_forecast_till_curr_month
                        - pv_inv_actual_till_curr_month;
                     pv_loc_actual :=
                        pv_loc_fore_till_curr_month
                        - Pv_Inv_Loc_Act_Till_Curr_Month;
                  ELSE
                     -- Check if it is a start month
                     IF first_month = TRUE
                     THEN
                        BEGIN
                           -- For start month, the cost would be
                           -- inventory till this month into costed runs
                           -- for current month divided by total costed runs
                           -- minus cost till current month
                           con_actual :=
                              (forecast_till_curr_month
                               * (costed_schedules_for_curr_mon
                                  / lic.lic_showing_lic))
                              - act_exc_wrtoff_till_curr_mth;
                           loc_actual :=
                              (loc_fore_till_curr_month
                               * (costed_schedules_for_curr_mon
                                  / lic.lic_showing_lic))
                              - act_exc_wrtoff_till_curr_mth;
                           -- For start month, the PV cost would be
                           -- PV inventory of this month into costed runs
                           -- till current month divided by total costed runs
                           -- minus PV cost till current month
                           pv_con_actual :=
                              (pv_forecast_till_curr_month
                               * (costed_schedule_till_curr_mon
                                  / lic.lic_showing_lic))
                              - pv_inv_actual_till_curr_month;
                           pv_loc_actual :=
                              (pv_loc_fore_till_curr_month
                               * (costed_schedule_till_curr_mon
                                  / lic.lic_showing_lic))
                              - pv_inv_loc_act_till_curr_month;
                        EXCEPTION
                           WHEN OTHERS
                           THEN
                              con_actual := 0;
                              loc_actual := 0;
                              pv_con_actual := 0;
                              pv_loc_actual := 0;
                        END;
                     ELSE
                        IF (lic.lic_showing_lic
                            - costed_schedule_till_curr_mon) = 0
                        THEN
                           -- no costed runs reamaining
                           -- Cost of this month would be all remaining inventory
                           con_actual :=
                              forecast_till_curr_month
                              - actual_till_curr_month;
                           loc_actual :=
                              loc_fore_till_curr_month
                              - loc_actual_till_curr_month;
                           -- PV cost would be total remaining PV inventory
                           pv_con_actual :=
                              pv_forecast_till_curr_month
                              - pv_inv_actual_till_curr_month;
                           pv_loc_actual :=
                              pv_loc_fore_till_curr_month
                              - pv_inv_loc_act_till_curr_month;
                        ELSE
                           -- Costed runs are remaining

                           -- Check if the license price changed
                           IF price_changed_license = TRUE
                           THEN
                              -- If license price changed
                              -- Get the cost of sales due to price change
                              BEGIN
                                 actual_due_to_price_change :=
                                    ( (lic.lic_price - old_lic_price)
                                     / old_lic_price)
                                    * actual_till_curr_month;
                                 loc_act_due_to_price_change :=
                                    ( (lic.lic_price - old_lic_price)
                                     / old_lic_price)
                                    * loc_actual_till_curr_month;
                                 -- Get the PV cost sales due to price change
                                 pv_actual_due_to_price_change :=
                                    ( (lic.lic_price - old_lic_price)
                                     / old_lic_price)
                                    * pv_inv_actual_till_curr_month;
                                 pv_loc_act_due_to_price_change :=
                                    ( (lic.lic_price - old_lic_price)
                                     / old_lic_price)
                                    * pv_inv_loc_act_till_curr_month;
                              EXCEPTION
                                 WHEN OTHERS
                                 THEN
                                    actual_due_to_price_change := 0;
                                    loc_act_due_to_price_change := 0;
                                    pv_actual_due_to_price_change := 0;
                                    pv_loc_act_due_to_price_change := 0;
                              END;
                           END IF;

                           -- Cost would be sum of remaining inventory till current month
                           -- minus the cost due to price change into no of costed runs
                           -- for routine month divided by no of costed runs remaining
                           -- including this month plus cost due to price change
                           BEGIN
                              con_actual :=
                                 ( ( (forecast_till_curr_month
                                      - actual_till_curr_month)
                                    - actual_due_to_price_change)
                                  * costed_schedules_for_curr_mon)
                                 / (lic.lic_showing_lic
                                    - costed_schedule_till_last_mon)
                                 + actual_due_to_price_change;
                              loc_actual :=
                                 ( ( (loc_fore_till_curr_month
                                      - loc_actual_till_curr_month)
                                    - loc_act_due_to_price_change)
                                  * costed_schedules_for_curr_mon)
                                 / (lic.lic_showing_lic
                                    - costed_schedule_till_last_mon)
                                 + loc_act_due_to_price_change;
                           EXCEPTION
                              WHEN OTHERS
                              THEN
                                 con_actual := 0;
                                 loc_actual := 0;
                           END;

                           -- PV Cost would be total remaining inventory minus
                           -- PV COS due to price change into total costed runs till
                           -- current month divided by total costed runs
                           -- plus PV COS due to price change
                           BEGIN
                              pv_con_actual :=
                                 ( ( (pv_forecast_till_curr_month)
                                    - pv_actual_due_to_price_change)
                                  * (costed_schedule_till_curr_mon
                                     / lic.lic_showing_lic))
                                 + pv_actual_due_to_price_change
                                 - pv_inv_actual_till_curr_month;
                              /*pv_loc_actual :=
                                   (  (  (  pv_loc_fore_till_curr_month
                                          - pv_inv_loc_act_till_curr_month
                                         )
                                       - pv_loc_act_due_to_price_change
                                      )
                                    * (  costed_schedule_till_curr_mon
                                       / lic.lic_showing_lic
                                      )
                                   )
                                 + pv_loc_act_due_to_price_change;*/
                              pv_loc_actual :=
                                 ( ( (pv_loc_fore_till_curr_month)
                                    - pv_loc_act_due_to_price_change)
                                  * (costed_schedule_till_curr_mon
                                     / lic.lic_showing_lic))
                                 + pv_loc_act_due_to_price_change
                                 - pv_inv_loc_act_till_curr_month;
                           EXCEPTION
                              WHEN OTHERS
                              THEN
                                 pv_con_actual := 0;
                                 pv_loc_actual := 0;
                           END;
                        END IF;
                     END IF;
                  END IF;

                  --27Mar2015 Ver 0.2 START P1 Issue : Jawahar Garg - con_forecast is not updating after costing routine run in case of 'C'
                  BEGIN
                     SELECT *
                       INTO v_lic_sub_ledger_rec
                       FROM fid_license_sub_ledger
                      WHERE     lis_lic_number = lic.lic_number
                            AND lis_lsl_number = l_lic_lsl_number --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                            AND lis_ter_code = cht.cht_ter_code
                            AND lis_per_year = period_year
                            AND lis_per_month = period_month;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_lic_sub_ledger_rec.lis_ed_loc_forecast := 0;
                        v_lic_sub_ledger_rec.lis_pv_con_forecast := 0;
                        v_lic_sub_ledger_rec.lis_pv_loc_forecast := 0;
                        v_lic_sub_ledger_rec.lis_con_forecast := 0;
                        v_lic_sub_ledger_rec.lis_price := 0;
                        v_lic_sub_ledger_rec.lis_loc_forecast := 0;
                  END;

                  --27Mar2015 Ver 0.2 END.
                  --Finance Dev Phase I Zeshan [Start]
                  l_lis_con_pay := 0;
                  l_lis_loc_pay := 0;
                  l_lis_pay_mov_flag := 'N';
                  
                  x_prc_get_lic_mvmt_data(lic.lic_number,l_lic_lsl_number,old_lic_start,l_lis_con_pay,l_lis_loc_pay,l_lis_pay_mov_flag);
                  --Finance Dev Phase I [End]
                  --update subledger with cost and write-off
                  insert_update_sub_ledger (
                     lic.lic_number,
                     l_lic_lsl_number, --l_lsl_lic_number        --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                     cht.cht_ter_code,
                     period_year,
                     period_month,
                     v_lic_sub_ledger_rec.lis_price, --0,--lic_price               /*ver 0.2 commented 0 and added actual value*/
                     0,                                           --lis_factor
                     license_start_rate,                            --lic_rate
                     NULL,                                    --lic_start_rate
                     costed_schedules_for_curr_mon,          --paid exhibition
                     v_lic_sub_ledger_rec.lis_con_forecast, --0,--con_forecast             /*ver 0.2 commented 0 and added actual value*/
                     v_lic_sub_ledger_rec.lis_loc_forecast, --0,--loc_forecast           /*ver 0.2 commented 0 and added actual value*/
                     0,                                             --con_calc
                     0,                                             --loc_calc
                     con_actual,                                  --con_actual
                     loc_actual,                                  --loc_actual
                     0,                                           --con_adjust
                     0,                                           --loc_adjust
                     con_writeoff,                              --con_writeoff
                     loc_writeoff,                              --loc_writeoff
                     v_lic_sub_ledger_rec.lis_pv_con_forecast, --0,--pv_con_forecast       /*ver 0.2 commented 0 and added actual value*/
                     v_lic_sub_ledger_rec.lis_pv_loc_forecast, --0,--pv_loc_forecast     /*ver 0.2 commented 0 and added actual value*/
                     pv_con_actual,                    --pv con inventory cost
                     NULL,                             --pv con liability cost
                     pv_loc_actual,                    --pv loc inventory cost
                     NULL,                             --pv loc liability cost
                     v_lic_sub_ledger_rec.lis_ed_loc_forecast, --0,--ed_loc_forecast       /*ver 0.2 commented 0 and added actual value*/
                     0,                                              --ed cost
                     0,                                   --con unforseen cost
                     0,                                   --loc unforseen cost
                     --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                     v_lic_sub_ledger_rec.LIS_ASSET_ADJ_VALUE, --Revaluation  value for every month in case of minimum guarantee license
                     lic.lic_start,
                     lic.lic_end,
                     v_lic_sub_ledger_rec.lis_mean_subscriber,
                     v_lic_sub_ledger_rec.LIS_MG_PV_CON_FORECAST, --pv mg con inventory  against mg payments
                     v_lic_sub_ledger_rec.LIS_MG_PV_LOC_FORECAST, --pv mg loc inventory  against mg payments
                     v_lic_sub_ledger_rec.LIS_LOC_ASSET_ADJ_VALUE, ----loc Revaluation  value for every month in case of minimum guarantee license
                     v_lic_sub_ledger_rec.LIS_MG_PV_CON_LIAB, --Pv mg con liab against mg payments
                     v_lic_sub_ledger_rec.LIS_MG_PV_LOC_LIAB, --Pv mg loc liab against mg payments
                     --END [BR_15_144-Finance CRs:New Payment Plan]
                     user_id,
                    --Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/24]
                    CASE WHEN NVL(L_REVAL_FLAG,'NC') = 'NC'
                    AND ( NVL(v_lic_sub_ledger_rec.lis_con_forecast,0) <> 0 OR NVL(v_lic_sub_ledger_rec.lis_loc_forecast,0)<>0 )
                    THEN
                    'PC'
                    ELSE
                    l_reval_flag
                    END,
                    --Dev : Fin CR : End : [Jawahar Garg]_[2016/05/24]
                    --Finance Dev Phase I Zeshan [Start]
                    lic.lic_currency,
                    cha_com_number,
                    lic.lic_status,
                    l_lis_pay_mov_flag,
                    l_lis_con_pay,
                    l_lis_loc_pay);
                    --Finance Dev Phase I [End]
               END LOOP;                              -- territories loop ends

               IF UPPER (month_end_type) = 'FINAL'
               THEN
                  -- Calculate the un-realized forex gain(loss) for Content and PV
                  calc_unrealized_forex_con_pv (lic.lic_number,
                                                l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                                period_month,
                                                period_year,
                                                license_start_rate,
                                                mth_end_date_rate,
                                                todate,
                                                user_id);
                  -- Calculate the realized forex gain(loss) for Content and PV
                  calculate_realized_forex (lic.lic_number,
                                            l_lic_lsl_number, --l_lsl_lic_number  --27Mar2015: Ver 0.2 : Jawahar - renamed l_lsl_lic_number to l_lic_lsl_number.
                                            period_month,
                                            period_year,
                                            from_date,
                                            todate,
                                            user_id);
               END IF;
            -- END IF;
            END IF;
         END LOOP;                                        -- ends license loop
      END LOOP;                                          -- ends contract loop
   END calculate_fin_royalty;

   -- Pure Finance: Ajit : 08-Apr-2013 :Procedure added to calculate inventory for current routine
   -- month for ROY licenses
   PROCEDURE calulate_inventory_for_roy (i_con_number           IN NUMBER,
                                         i_lic_number           IN NUMBER,
                                         i_lsl_number           IN NUMBER,
                                         i_lic_chs_number       IN NUMBER,
                                         i_lic_start            IN DATE,
                                         i_lic_price            IN NUMBER,
                                         i_old_lic_price        IN NUMBER,
                                         i_lic_min_subscriber   IN NUMBER,
                                         i_lic_status           IN VARCHAR2,
                                         i_start_month          IN BOOLEAN,
                                         i_curr_month           IN NUMBER,
                                         i_curr_year            IN NUMBER,
                                         i_lic_start_rate       IN NUMBER,
                                         i_disc_rate            IN NUMBER,
                                         i_entry_oper           IN VARCHAR2,
										 i_reval_flag			IN VARCHAR2,  --Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/24]
										 --Finance Dev Phase I Zeshan [Start]
										 i_lic_currency			IN VARCHAR2,
										 i_com_number			IN NUMBER
										 --Finance Dev Phase I [End]
										 )
   IS
      -- Cursor to get the territories for the specific to license
      CURSOR cht_c (
         licchsnumber NUMBER)
      IS
         SELECT DISTINCT cht_ter_code
           FROM fid_channel_territory
          WHERE ( (cht_cha_number = licchsnumber)
                 OR EXISTS
                       (SELECT 'X'
                          FROM fid_channel_service
                         WHERE chs_number = licchsnumber
                               AND chs_cha_number = cht_cha_number
                        UNION
                        SELECT 'X'
                          FROM fid_channel_service_channel
                         WHERE     csc_chs_number = licchsnumber
                               AND csc_cha_number = cht_cha_number
                               AND csc_include_subs = 'Y'
                               AND TO_CHAR (csc_end_dt, 'YYYYMM') >=
                                      i_curr_year
                                      || LPAD (i_curr_month, 2, 0)));

      cht                              cht_c%ROWTYPE;

      CURSOR lil_c (licnumber NUMBER, tercode VARCHAR2)
      IS
         SELECT lil_price, lil_adjust_factor, lil_rgh_code
           FROM fid_license_ledger
          WHERE lil_lic_number = licnumber AND lil_ter_code = tercode;

      lil                              lil_c%ROWTYPE;

      CURSOR subscriber_c (
         connumber       NUMBER,
         licchsnumber    NUMBER,
         tercode         VARCHAR2,
         peryear         NUMBER,
         permonth        NUMBER)
      IS
         SELECT NVL (SUM (ROUND (cts_effective, 0)), 0)
           FROM fid_contract_subscriber
          WHERE cts_con_number = connumber
                AND ( (cts_cha_number = licchsnumber)
                     OR EXISTS
                           (SELECT 'X'
                              FROM fid_channel_service
                             WHERE chs_number = licchsnumber
                                   AND chs_cha_number = cts_cha_number
                            UNION
                            SELECT 'X'
                              FROM fid_channel_service_channel
                             WHERE     csc_chs_number = licchsnumber
                                   AND csc_cha_number = cts_cha_number
                                   AND csc_include_subs = 'Y'
                                   AND TO_CHAR (csc_end_dt, 'YYYYMM') >=
                                          peryear || LPAD (permonth, 2, 0)
                            UNION
                            SELECT 'X'
                              FROM fid_channelservice_subtype
                             WHERE fcs_chs_number = licchsnumber
                                   AND fcs_sub_id = cts_cha_number))
                AND cts_ter_code = tercode
                AND cts_per_year = peryear
                AND cts_per_month = permonth;

      CURSOR lis_c (
         licnumber    NUMBER,
         tercode      VARCHAR2,
         peryear      NUMBER,
         permonth     NUMBER)
      IS
         SELECT NVL (SUM (lis_con_forecast), 0),
                NVL (SUM (lis_loc_forecast), 0),
                NVL (SUM (lis_pv_con_forecast), 0),
                NVL (SUM (lis_pv_loc_forecast), 0),
                NVL (SUM (lis_pv_con_liab_actual), 0),
                NVL (SUM (lis_pv_loc_liab_actual), 0)
           FROM fid_license_sub_ledger
          WHERE lis_lic_number = licnumber AND lis_ter_code = tercode
                AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                       peryear || LPAD (permonth, 2, 0);

      CURSOR sub_total_c (
         connumber       NUMBER,
         licchsnumber    NUMBER,
         peryear         NUMBER,
         permonth        NUMBER)
      IS
         SELECT NVL (SUM (ROUND (cts_effective, 0)), 0)
           FROM fid_contract_subscriber
          WHERE cts_con_number = connumber
                AND ( (cts_cha_number = licchsnumber)
                     OR EXISTS
                           (SELECT 'X'
                              FROM fid_channel_service
                             WHERE chs_number = licchsnumber
                                   AND chs_cha_number = cts_cha_number
                            UNION
                            SELECT 'X'
                              FROM fid_channel_service_channel
                             WHERE     csc_chs_number = licchsnumber
                                   AND csc_cha_number = cts_cha_number
                                   AND csc_include_subs = 'Y'
                                   AND TO_CHAR (csc_end_dt, 'YYYYMM') >=
                                          peryear || LPAD (permonth, 2, 0)
                            UNION
                            SELECT 'X'
                              FROM fid_channelservice_subtype
                             WHERE fcs_chs_number = licchsnumber
                                   AND fcs_sub_id = cts_cha_number))
                AND cts_per_year = peryear
                AND cts_per_month = permonth;


      --Cursor to get the information about the payment plan
      -- for current and future months
      CURSOR get_future_lpy (
         cp_licnumber    NUMBER,
         cp_month_no     NUMBER)
      IS
         SELECT lpy_number, lpy_pay_month_no, lpy_pay_percent
           FROM fid_license_payment_months
          WHERE lpy_lic_number = cp_licnumber
                AND lpy_pay_month_no >= cp_month_no;

      -- Cursor added to get the split payment
      CURSOR get_future_split (
         cp_licnumber     NUMBER,
         cp_lpy_number    NUMBER,
         cp_month_no      NUMBER)
      IS
         SELECT lsp_id, lsp_percent_payment, lsp_split_month_num
           FROM sgy_lic_split_payment
          WHERE     lsp_lic_number = cp_licnumber
                AND lsp_lpy_number = cp_lpy_number
                AND lsp_split_month_num >= cp_month_no;

      --Cursor to get the information about the payment plan
      CURSOR get_lpy_pv (
         cp_licnumber         NUMBER,
         lic_curr_month_no    NUMBER,
         cp_roy_pay_calc      NUMBER)
      IS
           SELECT lpy_number, lpy_pay_month_no, lpy_pay_percent
             FROM fid_license_payment_months
            WHERE lpy_lic_number = cp_licnumber
                  AND (lpy_pay_month_no + CEIL (cp_roy_pay_calc / 30)) >=
                         lic_curr_month_no
         ORDER BY lpy_pay_month_no;

      --Cursor to get the information about the MG paymnet plan
      CURSOR get_mg_pay (
         p_lic_number         NUMBER,
         lic_curr_month_no    NUMBER,
         p_roy_pay_calc       NUMBER)
      IS
           SELECT MGP_NUMBER, MGP_PAY_MONTH_NO, MGP_PAY_PERCENT
             FROM x_fin_mg_pay_plan
            WHERE MGP_LIC_NUMBER = p_lic_number
                  AND NVL (mgp_is_paid, 'N') = 'N'
                  AND (MGP_PAY_MONTH_NO + CEIL (p_roy_pay_calc / 30)) >
                         lic_curr_month_no
         ORDER BY MGP_PAY_MONTH_NO;

      --Cursor to get the total mg information territory wise
      CURSOR lis_mg_ter (
         licnumber    NUMBER,
         peryear      NUMBER,
         permonth     NUMBER,
         tercode      varchar2
         )
      IS
         SELECT NVL (SUM (LIS_MG_PV_CON_FORECAST), 0),
                NVL (SUM (LIS_MG_PV_LOC_FORECAST), 0),
                NVL (SUM (LIS_MG_PV_CON_LIAB), 0),
                NVL (SUM (LIS_MG_PV_LOC_LIAB), 0)
           FROM fid_license_sub_ledger
          WHERE lis_lic_number = licnumber
          AND lis_ter_code = tercode
            AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                       peryear || LPAD (permonth, 2, 0);

     --Cursor to get mg conslidated values
      CURSOR lis_mg (
         licnumber    NUMBER,
         peryear      NUMBER,
         permonth     NUMBER
         )
      IS
         SELECT NVL (SUM (LIS_MG_PV_CON_FORECAST), 0),
                NVL (SUM (LIS_MG_PV_LOC_FORECAST), 0),
                NVL (SUM (LIS_MG_PV_CON_LIAB), 0),
                NVL (SUM (LIS_MG_PV_LOC_LIAB), 0)
           FROM fid_license_sub_ledger
          WHERE lis_lic_number = licnumber
            AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                       peryear || LPAD (permonth, 2, 0);

      sub_effective                    NUMBER;
      sub_effective_for_last_month     NUMBER;
      lic_price                        NUMBER;
      lic_factor                       NUMBER;
      forecast_to_date                 NUMBER;
      loc_forecast_to_date             NUMBER;
      sub_total                        NUMBER;
      min_subscriber                   BOOLEAN;
      asset_adjust                     NUMBER;
      con_forecast                     NUMBER;
      loc_forecast                     NUMBER;
      l_diff_month_no                  NUMBER;
      per_date                         DATE;
      per_end_date                     DATE;
      already_paid_percentage          NUMBER;
      last_date_of_last_month          DATE;
      pv_con_forecast                  NUMBER;
      pv_con_forecast_for_start_mth    NUMBER;
      pv_con_forecast_due_to_pc        NUMBER;
      pv_loc_forecast                  NUMBER;
      pv_temp_con_forecast             NUMBER;
	    pv_temp_loc_forecast             NUMBER;
      pv_temp_con_forecast_for_start   NUMBER;
      pv_forecast_to_date              NUMBER;
      pv_loc_forecast_to_date          NUMBER;
      l_split_pay_count                NUMBER;
      rem_payment_percetage            NUMBER;
      pay_amount                       NUMBER;
      pay_amount_for_pv_start_mth      NUMBER;
      no_of_days                       NUMBER;
      roy_pay_after_calculation        NUMBER;
      total_rem_con_forecast           NUMBER;
      payment_till_prev_month          NUMBER;
      con_forecast_due_to_price_chan   NUMBER;
      pv_con_liab_act_due_to_pc        NUMBER;
      con_forecast_for_curr_mth_sub    NUMBER;
      con_forecast_pv_for_start_mth    NUMBER;
      loc_forecast_for_curr_mth_sub    NUMBER;
      max_month_no                     NUMBER;
      pv_already_paid_percentage       NUMBER;
      pv_remaining_paid_percentage     NUMBER;
      pay_amount_pv_liab               NUMBER;
      no_of_days_pv_liab               NUMBER;
      pv_con_liability                 NUMBER;
      pv_con_liab_actual               NUMBER;
      pv_loc_liab_actual               NUMBER;
      pv_liab_acutal_to_date           NUMBER;
      pv_loc_liab_acutal_to_date       NUMBER;
      l_acct_month                     BOOLEAN;
      l_lic_acct_date                  DATE;
      no_of_not_paid_for_lpy_number    NUMBER;
      calc_month_no_for_lpy_number     NUMBER;
      calc_month_date_for_lpy_number   DATE;
      calc_month_in_curr_month         BOOLEAN;
      license_month_no                 NUMBER;
      --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K/Swapnil M]_[2015/07/20]
      --Declare the variables
      l_min_mg_flag                    VARCHAR2 (1);
      l_min_sub_flag                   VARCHAR2 (1);
      lic_cal_months                   NUMBER;
      l_lic_end                        DATE;
      L_lic_adj_month                  DATE;
      asset_val_as_of_today            NUMBER (38, 2);
      change_in_asset_val              NUMBER (38, 2);
      asset_loc_val_as_of_today        NUMBER (38, 2);
      change_in_loc_asset_val          NUMBER (38, 2);
      sub_eff_for_lsd_month            NUMBER;
      sub_effective_for_adj_month      NUMBER;
      l_tot_asst_val_till_lst_mnth     NUMBER (38, 2);
      l_msa_con_adj                    NUMBER (38, 2);
      l_msa_loc_adj                    NUMBER (38, 2);
      eff_val_due_to_price_chg         NUMBER (38, 2);
      eff_val_due_to_dur_chg           NUMBER (38, 2);
      l_old_lic_start                  DATE;
      l_old_lic_end                    DATE;
      l_mean_subscriber                NUMBER (38, 2);
      l_prev_mon_mean_sub              NUMBER (38, 2);
      pv_temp_mg_con_forecast          NUMBER (38, 2);
	    pv_temp_mg_loc_forecast          NUMBER (38, 2);
      l_con_min_subs                   NUMBER;
      l_tot_asset_val_orig_mnth        NUMBER (38, 2);
      l_tot_loc_asset_val_orig_mnth    NUMBER (38, 2);
      l_tot_asset_val_adj_mnth         NUMBER (38, 2);
      l_tot_loc_asset_val_adj_mnth     NUMBER (38, 2);
      l_tot_con_forecast_before_lsd    NUMBER (38, 2);
      l_tot_loc_forecast_before_lsd    NUMBER (38, 2);
      l_tot_loc_val_till_lst_mnth      NUMBER (38, 2);
      eff_loc_val_due_to_price_chg     NUMBER (38, 2);
      eff_loc_val_due_to_dur_chg       NUMBER (38, 2);
      pv_mg_con_forec_for_start        NUMBER (38, 2) := 0;
	    pv_mg_loc_forec_for_start        NUMBER (38, 2) := 0;
      tot_pvmg_con_forec_to_date       NUMBER (38, 2);
      tot_pvmg_loc_forec_to_date       NUMBER (38, 2);
      tot_pvmg_liab_to_date            NUMBER (38, 2);
      pv_temp_mg_con_liab              NUMBER (38, 2);
	    pv_temp_mg_loc_liab              NUMBER (38, 2);
      pv_mg_con_forec_for_curr_mth     NUMBER (38, 2);
	    pv_mg_loc_forec_for_curr_mth     NUMBER (38, 2);
      Is_mg_pv_calculated              NUMBER (5) := 0;
      pv_temp_adj_con_forecast         NUMBER (38, 2);
      pv_temp_adj_loc_forecast         NUMBER (38, 2);
      pv_adj_con_forecast              NUMBER (38, 2);
      pv_adj_loc_forecast              NUMBER (38, 2);
      tot_pvmg_loc_liab_to_date        NUMBER (38, 2);
      tot_pv_conforc_till_lst_mth      NUMBER (38, 2);
	    tot_pv_locforc_till_lst_mth      NUMBER (38, 2);
      tot_pv_conliab_till_lst_mth      NUMBER (38, 2);
	    tot_pv_locliab_till_lst_mth      NUMBER (38, 2);
      L_pv_adj_month                   DATE;
      l_lpy_paymonth_no                NUMBER;
      pv_tmp_con_fc_licstrt            NUMBER (38, 2);
	    pv_tmp_loc_fc_licstrt            NUMBER (38, 2);
      tot_pvmg_ter_con_forec_to_date   NUMBER (38, 2);
      tot_pvmg_ter_loc_forec_to_date   NUMBER (38, 2);
      tot_pvmg_ter_liab_to_date        NUMBER (38, 2);
      tot_pvmg_ter_loc_liab_to_date    NUMBER (38, 2);
      l_old_price                      NUMBER;
      --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/24]
      l_reval_flag                     fid_license_sub_ledger.lis_reval_flag%TYPE;
      --Dev : Fin CR : End
      --Finance Dev Phase I Zeshan [Start]
      l_lis_con_pay                    fid_license_sub_ledger.lis_con_pay%TYPE;
      l_lis_loc_pay                    fid_license_sub_ledger.lis_loc_pay%TYPE;
      l_lis_pay_mov_flag               fid_license_sub_ledger.lis_pay_mov_flag%TYPE;
      --Finance Dev Phase I [End]
   --END
   BEGIN
      -- Get the first date of the routine month
      per_date :=
         TO_DATE (
            '01' || TO_CHAR (i_curr_month, '09') || TO_CHAR (i_curr_year),
            'DDMMYYYY');
      --- Identify the last day of Amortisation month
      per_end_date :=
         LAST_DAY (
            TO_DATE (
               '01' || TO_CHAR (i_curr_month, '09') || TO_CHAR (i_curr_year),
               'DDMMYYYY'));
      -- Get the last date of last month
      last_date_of_last_month := LAST_DAY (ADD_MONTHS (per_date, -1));
      
      SELECT TO_NUMBER (content)
        INTO roy_pay_after_calculation
        FROM x_fin_configs
       WHERE KEY = 'ROY_PAY_CALC';

      --  check to see if their are minimum subscribers
      --  specified for this license. If so, check whether
      --  minimum subs are greater than effective subs.
      min_subscriber := FALSE;
      sub_total := 0;

      IF NVL (i_lic_min_subscriber, 0) <> 0
      THEN
         OPEN sub_total_c (i_con_number,
                           i_lic_chs_number,
                           i_curr_year,
                           i_curr_month);

         FETCH sub_total_c INTO sub_total;

         CLOSE sub_total_c;

         IF NVL (i_lic_min_subscriber, 0) > sub_total
         THEN
            min_subscriber := TRUE;
         END IF;
      END IF;

      SELECT lic_acct_date
        INTO l_lic_acct_date
        FROM fid_license
       WHERE lic_number = i_lic_number;

      IF TO_CHAR (l_lic_acct_date, 'YYYYMM') =
            i_curr_year || LPAD (i_curr_month, 2, 0)
      THEN
         l_acct_month := TRUE;
      ELSE
         l_acct_month := FALSE;
      END IF;

      --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K/Swapnil M]_[2015/07/20]
      --To get the min gurantee,min subscriber flag for license
      SELECT NVL (Lic_Min_Subs_Flag, 'N'),
             lic_end,
             NVL (lic_min_guarantee_flag, 'N')          /*Changed by Swapnil*/
        INTO l_min_sub_flag, l_lic_end, l_min_mg_flag
        FROM fid_license
       WHERE lic_number = i_lic_number;

      --Calculate the calender months between lsd and led.
      SELECT MONTHS_BETWEEN (
                TRUNC (TO_DATE (l_lic_end, 'DD-MON-YYYY'), 'month'),
                TRUNC (TO_DATE (i_lic_start, 'DD-MON-YYYY'), 'month'))
             + 1
        INTO lic_cal_months
        FROM DUAL;

      --END [-BR_15_144-Finance CRs:New Payment Plan]

      --  Select the channel/service subscriber territories and start the cht loop
      FOR cht IN cht_c (i_lic_chs_number)
      LOOP
         -- Find any local territory pricing
         OPEN lil_c (i_lic_number, cht.cht_ter_code);

         FETCH lil_c INTO lil;

         IF lil_c%NOTFOUND
         THEN
            lic_price := i_lic_price;
            lic_factor := 1;
         ELSE
            IF lil.lil_rgh_code = 'X'
            THEN
               lic_price := 0;
               lic_factor := 0;
            ELSE
               ---Added by sushma on 05-aug-2015 to check territory rights presents or not
               --if present increment the is_mg_pv_calculated value
               Is_mg_pv_calculated := Is_mg_pv_calculated + 1;
               lic_price := lil.lil_price;
               lic_factor := lil.lil_adjust_factor;
            END IF;
         END IF;

         CLOSE lil_c;

         -- Determine the number of subscribers for the territory
         sub_effective := 0;

         OPEN subscriber_c (i_con_number,
                            i_lic_chs_number,
                            cht.cht_ter_code,
                            i_curr_year,
                            i_curr_month);

         FETCH subscriber_c INTO sub_effective;

         CLOSE subscriber_c;

         -- Determine the number of subscribers for the territory
         -- for last month
         sub_effective_for_last_month := 0;

         OPEN subscriber_c (i_con_number,
                            i_lic_chs_number,
                            cht.cht_ter_code,
                            TO_NUMBER (
                               TO_CHAR (last_date_of_last_month, 'YYYY')),
                            TO_NUMBER (
                               TO_CHAR (last_date_of_last_month, 'MM')));

         FETCH subscriber_c INTO sub_effective_for_last_month;

         CLOSE subscriber_c;

         -- pro-rate the subscriber figures according to the minimum
         -- subscriber number in the lineup if the min subscribers are valid
         IF sub_total = 0
         THEN
            sub_total := 1;
         END IF;

         IF min_subscriber = TRUE
         THEN
            sub_effective :=
               sub_effective * (NVL (i_lic_min_subscriber, 0) / sub_total);
            sub_effective_for_last_month :=
               sub_effective_for_last_month
               * (NVL (i_lic_min_subscriber, 0) / sub_total);
         END IF;

         --  calculate the ytd figures
         forecast_to_date := 0;
         loc_forecast_to_date := 0;
         con_forecast := 0;

         OPEN lis_c (i_lic_number,
                     cht.cht_ter_code,
                     i_curr_year,
                     i_curr_month);

         FETCH lis_c
         INTO forecast_to_date,
              loc_forecast_to_date,
              pv_forecast_to_date,
              pv_loc_forecast_to_date,
              pv_liab_acutal_to_date,
              pv_loc_liab_acutal_to_date;

         CLOSE lis_c;

         con_forecast_due_to_price_chan := 0;
         pv_con_forecast := 0;
         pv_con_forecast_due_to_pc := 0;

         -- Check if the price changed calculate the differance due to price change
         IF i_lic_status = 'PC'
         THEN
            BEGIN
               con_forecast_due_to_price_chan :=
                  ( (i_lic_price - i_old_lic_price) / i_old_lic_price)
                  * forecast_to_date;
            EXCEPTION
               WHEN OTHERS
               THEN
                  con_forecast_due_to_price_chan := 0;
            END;

            BEGIN
               pv_con_forecast_due_to_pc :=
                  - ( (con_forecast_due_to_price_chan / forecast_to_date)
                     * pv_forecast_to_date);
            EXCEPTION
               WHEN OTHERS
               THEN
                  pv_con_forecast_due_to_pc := 0;
            END;

            BEGIN
               pv_con_liab_act_due_to_pc :=
                  - ( (i_lic_price - i_old_lic_price) / i_old_lic_price)
                  * pv_liab_acutal_to_date;
            EXCEPTION
               WHEN OTHERS
               THEN
                  pv_con_liab_act_due_to_pc := 0;
            END;
         END IF;

         -- Get the differance between licese start date and routine month
         SELECT CEIL (
                   MONTHS_BETWEEN (
                      TO_DATE (TO_CHAR (per_date, 'YYYYMM'), 'YYYYMM'),
                      TO_DATE (TO_CHAR (i_lic_start, 'YYYYMM'), 'YYYYMM')))
                + 1
           INTO l_diff_month_no
           FROM DUAL;

         --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K/Swapnil M]_[2015/07/20]
         IF l_min_sub_flag = 'Y'                        /*Changed by Swapnil*/
         THEN
            BEGIN
               SELECT lis_lic_start, lis_lic_end, lis_mean_subscriber,lis_price
                 INTO l_old_lic_start, l_old_lic_end, l_prev_mon_mean_sub,l_old_price
                 FROM fid_license_sub_ledger
                WHERE lis_lic_number = i_lic_number
                      AND LIS_TER_CODE = cht.cht_ter_code
                      AND LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0) =
                             TO_CHAR (ADD_MONTHS (per_date, -1), 'YYYYMM');
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_old_lic_start := i_lic_start;
                  l_old_lic_end := l_lic_end;
                  l_prev_mon_mean_sub := 0;
            END;

            OPEN lis_mg_ter (i_lic_number, i_curr_year, i_curr_month, cht.cht_ter_code);

            FETCH lis_mg_ter
            INTO tot_pvmg_ter_con_forec_to_date,
                 tot_pvmg_ter_loc_forec_to_date,
                 tot_pvmg_ter_liab_to_date,
                 tot_pvmg_ter_loc_liab_to_date;

            CLOSE lis_mg_ter;


             OPEN lis_mg (i_lic_number, i_curr_year, i_curr_month);

            FETCH lis_mg
            INTO tot_pvmg_con_forec_to_date,
                 tot_pvmg_loc_forec_to_date,
                 tot_pvmg_liab_to_date,
                 tot_pvmg_loc_liab_to_date;

            CLOSE lis_mg;

            /*Added code to calculate Mean subscriber by Sushma/Swapnil For Warner Payment */
            IF i_start_month = TRUE
            THEN
               l_mean_subscriber := sub_effective;
            ELSE
               OPEN subscriber_c (i_con_number,
                                  i_lic_chs_number,
                                  cht.cht_ter_code,
                                  TO_NUMBER (TO_CHAR (i_lic_start, 'YYYY')),
                                  TO_NUMBER (TO_CHAR (i_lic_start, 'MM')));

               FETCH subscriber_c INTO sub_eff_for_lsd_month;

               CLOSE subscriber_c;

               /*Mean subscriber is equal to subs effective of current month minus subs effective of LSD month devided by
               calender months between LSD and LED plus Mean Subscriber for previous month*/
               --Round the mean subscriber divided by license duration  to zero on 21-aug-2015
               l_mean_subscriber :=
                  ROUND( (sub_effective - sub_eff_for_lsd_month) / lic_cal_months ,0)
                  + l_prev_mon_mean_sub;


               L_lic_adj_month := i_lic_start;

               LOOP
                  l_tot_asst_val_till_lst_mnth := 0;
                  l_tot_asset_val_adj_mnth := 0;
                  l_tot_asset_val_orig_mnth := 0;
                  change_in_asset_val := 0;
                  change_in_loc_asset_val := 0;
                  asset_val_as_of_today := 0;
                  asset_loc_val_as_of_today := 0;
                  eff_val_due_to_dur_chg := 0;
                  eff_val_due_to_price_chg := 0;
                  eff_loc_val_due_to_price_chg := 0;
                  eff_loc_val_due_to_dur_chg := 0;
                  l_tot_loc_asset_val_orig_mnth := 0;
                  l_tot_loc_asset_val_adj_mnth := 0;
                  l_tot_con_forecast_before_lsd := 0;
                  l_tot_loc_forecast_before_lsd := 0;

                  EXIT WHEN TO_CHAR (L_lic_adj_month, 'YYYYMM') =
                               TO_CHAR (per_date, 'YYYYMM');

                  --dbms_output.put_line(L_lic_adj_month);

                  OPEN subscriber_c (i_con_number,
                                     i_lic_chs_number,
                                     cht.cht_ter_code,
                                     TO_NUMBER (
                                        TO_CHAR (L_lic_adj_month, 'YYYY')),
                                     TO_NUMBER (
                                        TO_CHAR (L_lic_adj_month, 'MM')));

                  FETCH subscriber_c INTO sub_effective_for_adj_month;

                  CLOSE subscriber_c;

                  IF TO_CHAR (L_lic_adj_month, 'YYYYMM') =
                        TO_CHAR (i_lic_start, 'YYYYMM')
                  THEN
                     /*To get the Total asset value for adj month*/
                     SELECT NVL (SUM (LIS_ASSET_ADJ_VALUE), 0),
                            NVL (SUM (LIS_LOC_ASSET_ADJ_VALUE), 0)
                       INTO l_tot_asset_val_orig_mnth,
                            l_tot_loc_asset_val_orig_mnth
                       FROM fid_license_sub_ledger
                      WHERE lis_lic_number = i_lic_number
                            AND LIS_TER_CODE = cht.cht_ter_code
                            AND LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0) =
                                   TO_CHAR (i_lic_start, 'YYYYMM');

                     /*To get total asset adj value for adj month*/
                     SELECT NVL (SUM (a.msa_con_tot_adj_value), 0),
                            NVL (SUM (a.msa_loc_tot_adj_value), 0)
                       INTO l_tot_asset_val_adj_mnth,
                            l_tot_loc_asset_val_adj_mnth
                       FROM x_fin_mg_asset_adj a
                      WHERE a.msa_lic_number = i_lic_number
                            AND a.msa_ter_code = cht.cht_ter_code
                            AND a.msa_adj_year
                                || LPAD (a.msa_adj_month, 2, 0) =
                                   TO_CHAR (i_lic_start, 'YYYYMM')
                            AND a.msa_calc_year
                                || LPAD (a.msa_calc_month, 2, 0) <
                                   TO_CHAR (per_date, 'YYYYMM');

                     --to get the total forcast value for before license start as this value use for incase of per license
                     SELECT NVL (SUM (LIS_CON_FORECAST), 0),
                            NVL (SUM (LIS_LOC_FORECAST), 0)
                       INTO l_tot_con_forecast_before_lsd,
                            l_tot_loc_forecast_before_lsd
                       FROM fid_license_sub_ledger
                      WHERE lis_lic_number = i_lic_number
                            AND LIS_TER_CODE = cht.cht_ter_code
                            AND LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0) <
                                   TO_CHAR (i_lic_start, 'YYYYMM');

                     --Get the total con asset value till previous month of routine month
                     l_tot_asst_val_till_lst_mnth :=
                          l_tot_asset_val_orig_mnth
                        + l_tot_asset_val_adj_mnth
                        + l_tot_con_forecast_before_lsd;
                     --Get the total loc asset value till previous month of routine month
                     l_tot_loc_val_till_lst_mnth :=
                          l_tot_loc_asset_val_orig_mnth
                        + l_tot_loc_asset_val_adj_mnth
                        + l_tot_loc_forecast_before_lsd;


                     asset_val_as_of_today :=
                        NVL (sub_effective_for_adj_month * lic_price, 0);

                     change_in_asset_val :=
                        ROUND (
                           (asset_val_as_of_today
                            - l_tot_asst_val_till_lst_mnth),
                           2);

                     asset_loc_val_as_of_today :=
                        NVL (sub_effective_for_adj_month * lic_price, 0)
                        * i_lic_start_rate;
                     change_in_loc_asset_val :=
                        ROUND (
                           (asset_loc_val_as_of_today
                            - l_tot_loc_val_till_lst_mnth),
                           2);

                     IF change_in_asset_val <> 0
                     THEN
                        eff_val_due_to_price_chg :=
                           ROUND (
                              NVL (sub_effective_for_adj_month, 0)
                              * (lic_price - l_old_price),
                              2);
                        eff_val_due_to_dur_chg := 0;
                     END IF;

                     IF change_in_loc_asset_val <> 0
                     THEN
                        eff_loc_val_due_to_price_chg :=
                           ROUND (
                                NVL (sub_effective_for_adj_month, 0)
                              * (lic_price - l_old_price)
                              * i_lic_start_rate,
                              2);
                        eff_loc_val_due_to_dur_chg := 0;
                     END IF;



                  ELSE
                     OPEN subscriber_c (i_con_number,
                                        i_lic_chs_number,
                                        cht.cht_ter_code,
                                        TO_NUMBER (
                                           TO_CHAR (i_lic_start, 'YYYY')),
                                        TO_NUMBER (
                                           TO_CHAR (i_lic_start, 'MM')));

                     FETCH subscriber_c INTO sub_eff_for_lsd_month;

                     CLOSE subscriber_c;

                     /*To get the Total asset value for adj month*/
                     SELECT NVL (SUM (LIS_ASSET_ADJ_VALUE), 0)
                       INTO l_tot_asset_val_orig_mnth
                       FROM fid_license_sub_ledger
                      WHERE lis_lic_number = i_lic_number
                            AND LIS_TER_CODE = cht.cht_ter_code
                            AND LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0) =
                                   TO_CHAR (L_lic_adj_month, 'YYYYMM');

                     /*To get total asset adj value for adj month*/
                     SELECT NVL (SUM (a.msa_con_tot_adj_value), 0)
                       INTO l_tot_asset_val_adj_mnth
                       FROM x_fin_mg_asset_adj a
                      WHERE a.msa_lic_number = i_lic_number
                            AND a.msa_ter_code = cht.cht_ter_code
                            AND a.msa_adj_year
                                || LPAD (a.msa_adj_month, 2, 0) =
                                   TO_CHAR (L_lic_adj_month, 'YYYYMM')
                            AND a.msa_calc_year
                                || LPAD (a.msa_calc_month, 2, 0) <
                                   TO_CHAR (per_date, 'YYYYMM');

                     l_tot_asst_val_till_lst_mnth :=
                        l_tot_asset_val_orig_mnth + l_tot_asset_val_adj_mnth;

                     --Round the mean subscriber divided by license duration  to zero on 21-aug-2015
                     asset_val_as_of_today :=
                        NVL ( (
                               ROUND( ( (sub_effective_for_adj_month
                                  - sub_eff_for_lsd_month) / lic_cal_months ),0)
                                 * lic_price)
                           , 0);
                     change_in_asset_val :=
                        ROUND (
                           asset_val_as_of_today
                           - l_tot_asst_val_till_lst_mnth,
                           2);

                     -- IF change_in_asset_val<>0
                     -- then

                     eff_val_due_to_price_chg :=
                        ROUND (
                           NVL (
                              ROUND( ( (sub_effective_for_adj_month
                                 - sub_eff_for_lsd_month) / lic_cal_months ),0)
                               * (lic_price - l_old_price) ,0 ) , 2 );

                     --To check weather the
                     IF (TO_CHAR (l_old_lic_start, 'YYYYMM') <>
                            TO_CHAR (i_lic_start, 'YYYYMM'))
                        OR (TO_CHAR (l_old_lic_end, 'YYYYMM') <>
                               TO_CHAR (l_lic_end, 'YYYYMM'))
                     THEN
                        eff_val_due_to_dur_chg :=
                           change_in_asset_val - eff_val_due_to_price_chg;
                     ELSE
                       IF eff_val_due_to_price_chg != 0
                       THEN
                         change_in_asset_val := eff_val_due_to_price_chg;
                        ELSE
                           change_in_asset_val := change_in_asset_val;
                        END IF;

                     END IF;
                  /* else
                         select l.lis_lic_start,l.lis_lic_end
                            INTO l_old_lic_start,l_old_lic_end
                         from fid_license_sub_ledger l
                        where lis_lic_number = i_lic_number
                        and  LIS_TER_CODE =  cht.cht_ter_code
                        and LIS_PER_YEAR || lpad(LIS_PER_MONTH,2,0) =  to_char(add_months(l_lic_start,-1),'YYYYMM');

                         IF    (i_lic_price        <> i_old_lic_price)
                            or (l_old_lic_start <> i_lic_start )
                            or (l_old_lic_end  <> l_lic_end  )
                         then

                               eff_val_due_to_price_chg:= NVL( ( ( sub_effective_for_adj_month  - sub_eff_for_lsd_month )
                                                                                                  * (i_lic_price-i_old_lic_price)) / lic_cal_months,0) ;
                               eff_val_due_to_dur_chg :=change_in_asset_val - eff_val_due_to_price_chg;


                         end if;*/

                  END IF;

                  --change_in_asset_val:=eff_val_due_to_price_chg+eff_val_due_to_dur_chg;

                  /*All three values are checked because if the change_in_asset_val gets balanced
                due to price change and duration change in same month*/
                  IF (   change_in_asset_val <> 0
                      OR eff_val_due_to_price_chg <> 0
                      OR eff_val_due_to_dur_chg <> 0)
                  THEN
                     INSERT
                       INTO x_fin_mg_asset_adj (MSA_LIC_NUMBER,
                                                MSA_TER_CODE,
                                                MSA_CALC_MONTH,
                                                MSA_CALC_YEAR,
                                                MSA_ADJ_MONTH,
                                                MSA_ADJ_YEAR,
                                                MSA_CON_TOT_ADJ_VALUE,
                                                MSA_LOC_TOT_ADJ_VALUE,
                                                MSA_PRICE_CHG_ADJ_VAL,
                                                MSA_LOC_PRICE_CHG_ADJ_VAL,
                                                MSA_DUR_CHG_ADJ_VAL,
                                                MSA_LOC_DUR_CHG_ADJ_VAL,
                                                MSA_ENTRY_OPER,
                                                MSA_ENTRY_DATE)
                     VALUES (i_lic_number,
                             cht.cht_ter_code,
                             i_curr_month,
                             i_curr_year,
                             TO_CHAR (L_lic_adj_month, 'MM'),
                             TO_CHAR (L_lic_adj_month, 'YYYY'),
                             ROUND (change_in_asset_val, 2),
                             --ROUND(change_in_asset_val * i_lic_start_rate,0),
                             ( case when ROUND (change_in_loc_asset_val, 2) = 0 then ROUND(change_in_asset_val * i_lic_start_rate,2) else ROUND (change_in_loc_asset_val, 2) end ),
                             ROUND (eff_val_due_to_price_chg, 2),
                             ROUND (eff_loc_val_due_to_price_chg, 2),
                             ROUND (eff_val_due_to_dur_chg, 2),
                             ROUND (eff_loc_val_due_to_dur_chg, 2),
                             i_entry_oper,
                             SYSDATE);
                  END IF;

                  SELECT ADD_MONTHS (L_lic_adj_month, 1)
                    INTO L_lic_adj_month
                    FROM DUAL;
               END LOOP;
            END IF;
         
         --Finance Dev Phase I Zeshan [Start]
         --Added new else block to get previous month LSD
         ELSE
            BEGIN
               SELECT lis_lic_start
                 INTO l_old_lic_start
                 FROM fid_license_sub_ledger
                WHERE lis_lic_number = i_lic_number
                      AND lis_ter_code = cht.cht_ter_code
                      AND Lis_Per_Year || LPAD (lis_per_month, 2, 0) =
                             TO_CHAR (ADD_MONTHS (per_date, -1), 'YYYYMM');
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_old_lic_start := i_lic_start;
            END;
         END IF;
         --Finance Dev Phase I [End]
         --END.

         -- Get the already paid percentage of for this license before to this month
         SELECT NVL (SUM (lpy_pay_percent), 0)
           INTO already_paid_percentage
           FROM fid_license_payment_months
          WHERE lpy_lic_number = i_lic_number
                AND lpy_pay_month_no < l_diff_month_no;

         --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K/Swapnil M]_[2015/07/20]
         --Calculate the inventory for license as per new paymnet plan
         IF l_min_sub_flag = 'N'
         THEN
            -- Iventory would be inventory due to price change plus
            -- remaining payment percentage into license price into
            -- license factor into subs effective (if it is not the
            -- start month then minus the subs effective till last
            -- month from subs effective of this month) and if it
            -- is a start month then minus the forcast till date
            con_forecast_for_curr_mth_sub :=
               (  ( (100 - already_paid_percentage) / 100)
                * lic_price
                * lic_factor
                * (CASE
                      WHEN i_start_month THEN sub_effective
                      ELSE sub_effective - sub_effective_for_last_month
                   END))
               - (CASE WHEN i_start_month THEN forecast_to_date ELSE 0 END);
         ELSE
            OPEN subscriber_c (i_con_number,
                               i_lic_chs_number,
                               cht.cht_ter_code,
                               TO_NUMBER (TO_CHAR (i_lic_start, 'YYYY')),
                               TO_NUMBER (TO_CHAR (i_lic_start, 'MM')));

            FETCH subscriber_c INTO sub_eff_for_lsd_month;

            CLOSE subscriber_c;

            -- Iventory would be inventory due to price change plus
            -- remaining payment percentage into license price into
            -- license factor into subs effective (if it is not the
            -- start month then minus the subs effective for first
            --month of license(i.e LSD) from subs effective of this month) and if it
            -- is a start month then minus the forcast till date

            --Round the mean subscriber divided by license duration  to zero on 21-aug-2015
            con_forecast_for_curr_mth_sub :=
                (  ( (100 - already_paid_percentage) / 100)
                  * lic_price
                  * lic_factor
                  * ROUND ( ( CASE
                        WHEN i_start_month THEN sub_effective
                        ELSE sub_effective - sub_eff_for_lsd_month
                     END) / (CASE WHEN i_start_month THEN 1 ELSE lic_cal_months END) ,0)
                - (CASE WHEN i_start_month THEN forecast_to_date ELSE 0 END) )
               ;

         END IF;

         --end.

         --Changes done for Scenario pre-license to license start month
         IF i_start_month = TRUE AND l_acct_month = FALSE
            AND TO_CHAR (l_lic_acct_date, 'YYYYMM') <
                   TO_CHAR (i_lic_start, 'YYYYMM')
         THEN
            con_forecast_pv_for_start_mth :=
               (  ( (100 - already_paid_percentage) / 100)
                * lic_price
                * lic_factor
                * sub_effective);
         END IF;

         --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K/Swapnil M]_[2015/07/20]
         IF l_min_sub_flag = 'N'
         THEN
            loc_forecast_for_curr_mth_sub :=
               ( (  ( (100 - already_paid_percentage) / 100)
                  * lic_price
                  * lic_factor
                  * (CASE
                        WHEN i_start_month THEN sub_effective
                        ELSE sub_effective - sub_effective_for_last_month
                     END))
                * i_lic_start_rate)
               - (CASE
                     WHEN i_start_month THEN loc_forecast_to_date
                     ELSE 0
                  END);
         ELSE
            OPEN subscriber_c (i_con_number,
                               i_lic_chs_number,
                               cht.cht_ter_code,
                               TO_NUMBER (TO_CHAR (i_lic_start, 'YYYY')),
                               TO_NUMBER (TO_CHAR (i_lic_start, 'MM')));

            FETCH subscriber_c INTO sub_eff_for_lsd_month;

            CLOSE subscriber_c;

           --Round the mean subscriber divided by license duration  to zero on 21-aug-2015
            loc_forecast_for_curr_mth_sub :=
                ( (  ( (100 - already_paid_percentage) / 100)
                    * lic_price
                    * lic_factor
                    * ROUND( (CASE
                          WHEN i_start_month THEN sub_effective
                          ELSE sub_effective - sub_eff_for_lsd_month
                       END) / (CASE WHEN i_start_month THEN 1 ELSE lic_cal_months END) ,0)
                  * i_lic_start_rate )
                - (CASE
                      WHEN i_start_month THEN loc_forecast_to_date
                      ELSE 0
                   END) )
               ;
         END IF;

         --END.

         IF cht.cht_ter_code = 'ANG'
         THEN
            NULL;
         --dbms_output.put_line (
         --   '1 - loc_forecast_for_curr_mth_sub - '
         -- || loc_forecast_for_curr_mth_sub);
         END IF;

         IF l_min_sub_flag = 'N'
         THEN
            con_forecast :=
               con_forecast_due_to_price_chan + con_forecast_for_curr_mth_sub;
            loc_forecast :=
               (con_forecast_due_to_price_chan * i_lic_start_rate)
               + loc_forecast_for_curr_mth_sub;
         ELSE
            --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K/Swapnil M]_[2015/07/20]
            --get the adjusted values for previous months if any changes are done (like price change,subscriber figure change and lic period change)
            SELECT NVL (SUM (MSA_CON_TOT_ADJ_VALUE), 0),
                   NVL (SUM (MSA_LOC_TOT_ADJ_VALUE), 0)
              INTO l_msa_con_adj, l_msa_loc_adj
              FROM x_fin_mg_asset_adj
             WHERE     MSA_LIC_NUMBER = i_lic_number
                   AND MSA_TER_CODE = cht.cht_ter_code
                   AND MSA_CALC_MONTH = i_curr_month
                   AND MSA_CALC_YEAR = i_curr_year;

            con_forecast :=
               NVL (con_forecast_for_curr_mth_sub, 0) + l_msa_con_adj;
            loc_forecast :=
               NVL (loc_forecast_for_curr_mth_sub, 0) + l_msa_loc_adj;



         END IF;

         -- these valuation numbers must be adjusted to reflect any adjustment numbers in the asset value adjustment
         -- table. as a result the _forecast numbers posted to the sub ledger table have been adjusted.
         asset_adjust := 0;

         BEGIN
            SELECT asa_con_adjust
              INTO asset_adjust
              FROM fid_asset_adjust
             WHERE     asa_lic_number = i_lic_number
                   AND asa_ter_code = cht.cht_ter_code
                   AND asa_per_year = i_curr_year
                   AND asa_per_month = i_curr_month;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         con_forecast := con_forecast + NVL (asset_adjust, 0);
         loc_forecast :=
            ROUND (
               (loc_forecast + (NVL (asset_adjust, 0) * i_lic_start_rate)),
               2);
         rem_payment_percetage := 0;

         -- Get the remaining payment percentage
         SELECT SUM (NVL (lpy_pay_percent, 0))
           INTO rem_payment_percetage
           FROM fid_license_payment_months
          WHERE lpy_lic_number = i_lic_number
                AND lpy_pay_month_no >= l_diff_month_no;


           pv_temp_con_forecast := 0;
           pv_temp_loc_forecast := 0;
           pv_tmp_con_fc_licstrt := 0;
           pv_tmp_loc_fc_licstrt := 0;
           pv_temp_con_forecast_for_start := 0;

           license_month_no := TRUNC (MONTHS_BETWEEN (per_end_date, i_lic_start)) + 1;

           pv_mg_con_forec_for_start:=0;
		       pv_mg_loc_forec_for_start:=0;
           pv_mg_con_forec_for_curr_mth:=0;
		       pv_mg_loc_forec_for_curr_mth:=0;
           pv_temp_mg_con_forecast:=0;
		       pv_temp_mg_loc_forecast:= 0;
           pv_temp_mg_con_liab:=0;
		       pv_temp_mg_loc_liab:=0;

         --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K/Swapnil M]_[2015/07/20]
         --is_mg_pv_calculated flag is used to check that calcualtion of mg pv for first territory which is having territory rights
         IF Is_mg_pv_calculated = 1
         THEN

            IF l_min_sub_flag = 'Y'
            THEN
               --Get the minimum subscriber value at contract level
               IF l_min_mg_flag = 'N'
               THEN
                  l_con_min_subs := 0;
               ELSE
                  BEGIN
                     SELECT con_min_subscriber
                       INTO l_con_min_subs
                       FROM fid_contract
                      WHERE con_number = i_con_number;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_con_min_subs := 0;
                  END;
               END IF;

               /*pv_mg_con_forec_for_start := 0;
               pv_mg_con_forec_for_curr_mth := 0;
               pv_temp_mg_con_forecast := 0;
               pv_temp_mg_con_liab := 0;*/

               --Loop the MG payment paln to calculate the PV inventory of this month
               FOR i IN (SELECT *
                           FROM x_fin_mg_pay_plan
                          WHERE mgp_lic_number = i_lic_number)
               LOOP
                  no_of_days := 0;
                  pay_amount := 0;

                  --Get the pv forecast for MG that should be booked in license start month
                  pay_amount :=
                     NVL (
                          l_con_min_subs
                        * lic_price
                        * (i.MGP_PAY_PERCENT / 100),
                        0);


                  no_of_days :=
                     (LAST_DAY (
                         ADD_MONTHS (i_lic_start, i.mgp_pay_month_no - 1))
                      + roy_pay_after_calculation)
                     - (i_lic_start);

                  --Calculate the mg pv con forecast for start month
                  pv_mg_con_forec_for_start :=
                     NVL (pv_mg_con_forec_for_start, 0)
                     + ((pay_amount
                           / POWER (1 + (i_disc_rate / 100), no_of_days)) - pay_amount);

     END LOOP;

         pv_mg_loc_forec_for_start := pv_mg_loc_forec_for_start + (pv_mg_con_forec_for_start * i_lic_start_rate);

			   pv_temp_mg_con_forecast := pv_mg_con_forec_for_start - tot_pvmg_con_forec_to_date;

			   pv_temp_mg_loc_forecast := pv_mg_loc_forec_for_start - tot_pvmg_loc_forec_to_date;

               --Loop to calcualte MG PV Liability cost by calculating remaining PV forecast at month end
			   FOR get_mg
                  IN get_mg_pay (i_lic_number,
                                 license_month_no,
                                 roy_pay_after_calculation)
               LOOP
                  no_of_days := 0;
                  pay_amount := 0;

                  --Get the mg gross value
                  pay_amount :=
                     NVL (
                          l_con_min_subs
                        * lic_price
                        * (get_mg.MGP_PAY_PERCENT / 100),
                        0);

                  no_of_days :=
                     (LAST_DAY (
                         ADD_MONTHS (i_lic_start,
                                     get_mg.mgp_pay_month_no - 1))
                      + roy_pay_after_calculation)
                     - (per_end_date);

                  If no_of_days < 0
				  THEN
					 no_of_days := 0;
				  END IF;

				  --Calculate the mg pv con forecast for current month
             pv_mg_con_forec_for_curr_mth :=
                     NVL (pv_mg_con_forec_for_curr_mth, 0)
                     + ((pay_amount
                           / POWER (1 + (i_disc_rate / 100), no_of_days))- pay_amount);


               END LOOP;
               pv_mg_loc_forec_for_curr_mth := pv_mg_loc_forec_for_curr_mth + (pv_mg_con_forec_for_curr_mth * i_lic_start_rate);

               pv_temp_mg_con_liab := tot_pvmg_con_forec_to_date - tot_pvmg_liab_to_date
									+ pv_temp_mg_con_forecast - pv_mg_con_forec_for_curr_mth;

               pv_temp_mg_loc_liab := tot_pvmg_loc_forec_to_date - tot_pvmg_loc_liab_to_date
									+ pv_temp_mg_loc_forecast - pv_mg_loc_forec_for_curr_mth;
            END IF;
    ELSE
			pv_temp_mg_con_forecast := 0;
			pv_temp_mg_loc_forecast := 0;
			pv_temp_mg_con_liab := 0;
			pv_temp_mg_loc_liab := 0;
	 END IF;

         --END [BR_15_144-Finance CRs:New]
         pv_temp_adj_con_forecast := 0;
         pv_temp_adj_loc_forecast :=0;
         tot_pv_conforc_till_lst_mth := 0;
         tot_pv_locforc_till_lst_mth := 0;
         tot_pv_conliab_till_lst_mth := 0;
		     tot_pv_locliab_till_lst_mth := 0;

         IF l_min_sub_flag = 'Y'
         THEN
            --below calculation is to calculate the pv con forecst and pv liab for final payment of mg
            IF l_min_mg_flag = 'N'
            THEN
               l_con_min_subs := 0;
            ELSE
               BEGIN
                  SELECT con_min_subscriber
                    INTO l_con_min_subs
                    FROM fid_contract
                   WHERE con_number = i_con_number;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_con_min_subs := 0;
               END;
            END IF;

            --Loop to calculate PV forecast for current month
            FOR lpy
               IN get_lpy_pv (i_lic_number,
                              license_month_no,
                              roy_pay_after_calculation)
            LOOP
               no_of_days := 0;
               pay_amount := 0;

               --calculate the payment amount for current month  which is equal to revaluation of current month minus minimum gurantee amount if start month
               --else  payment amount is equal revaluation of that month
               IF i_start_month = TRUE
               THEN
                  --Get the total con forecast before LSD in case of pre license i.e change the lsd to current month.

                  SELECT NVL (SUM (LIS_CON_FORECAST), 0),
                         NVL (SUM (LIS_LOC_FORECAST), 0)
                    INTO l_tot_con_forecast_before_lsd,
                         l_tot_loc_forecast_before_lsd
                    FROM fid_license_sub_ledger
                   WHERE lis_lic_number = i_lic_number
                         AND LIS_TER_CODE = cht.cht_ter_code
                         AND LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0) <
                                TO_CHAR (i_lic_start, 'YYYYMM');

                  pay_amount :=
                     (con_forecast_for_curr_mth_sub
                      + l_tot_con_forecast_before_lsd)
                     -(CASE WHEN Is_mg_pv_calculated = 1 THEN (l_con_min_subs * lic_price) ELSE 0 END);
               ELSE
                  pay_amount := con_forecast_for_curr_mth_sub;
               END IF;

               --to get no of days for that month
               no_of_days :=
                  (LAST_DAY (
                      ADD_MONTHS (i_lic_start, lpy.lpy_pay_month_no - 1))
                   + roy_pay_after_calculation)
                  - (case when i_start_month =TRUE then i_lic_start else per_end_date end);

               if no_of_days < 0 then
                  no_of_days := 0;
               end if;

               --to get pv con forecast value for current month
               pv_temp_con_forecast := pv_temp_con_forecast + (
                  (pay_amount
                      / POWER (1 + (i_disc_rate / 100), no_of_days))- pay_amount);

               pv_temp_loc_forecast := pv_temp_loc_forecast +
                  (pv_temp_con_forecast * i_lic_start_rate);

               --END IF;
            END LOOP;

          --  pv_con_forecast := pv_temp_con_forecast + pv_temp_mg_con_forecast;
          --  pv_loc_forecast := pv_temp_loc_forecast + pv_temp_mg_loc_forecast;


            /*Loop Added by swapnil on 10 aug 2015*/
            --loop to calcuate PV Liability cost for month
            FOR lpy
               IN get_lpy_pv (i_lic_number,
                              license_month_no,
                              roy_pay_after_calculation)
            LOOP
               no_of_days := 0;
               pay_amount := 0;

               --calculate the payment amount for current month  which is equal to revaluation of current month minus minimum gurantee amount if start month
               --else  payment amount is equal revaluation of that month
               IF i_start_month = TRUE
               THEN
                  --Get the total con forecast before LSD in case of pre license i.e change the lsd to current month.

                  SELECT NVL (SUM (LIS_CON_FORECAST), 0),
                         NVL (SUM (LIS_LOC_FORECAST), 0)
                    INTO l_tot_con_forecast_before_lsd,
                         l_tot_loc_forecast_before_lsd
                    FROM fid_license_sub_ledger
                   WHERE lis_lic_number = i_lic_number
                         AND LIS_TER_CODE = cht.cht_ter_code
                         AND LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0) <
                                TO_CHAR (i_lic_start, 'YYYYMM');

                  pay_amount :=
                     (con_forecast_for_curr_mth_sub
                      + l_tot_con_forecast_before_lsd)
                     - (CASE WHEN Is_mg_pv_calculated = 1 THEN (l_con_min_subs * lic_price) ELSE 0 END);
               ELSE

                       --To get total asset adj value for adj month
                      SELECT NVL (SUM (a.msa_con_tot_adj_value), 0),
                             NVL (SUM (a.msa_loc_tot_adj_value), 0)
                        INTO l_tot_asset_val_adj_mnth,
                             l_tot_loc_asset_val_adj_mnth
                        FROM x_fin_mg_asset_adj a
                       WHERE a.msa_lic_number = i_lic_number
                             AND a.msa_ter_code = cht.cht_ter_code
                             AND a.msa_calc_year || LPAD (a.msa_calc_month, 2, 0) =
                                    TO_CHAR (per_date, 'YYYYMM');

                  pay_amount :=
                     con_forecast_for_curr_mth_sub + ( (forecast_to_date+l_tot_asset_val_adj_mnth)  - (CASE WHEN Is_mg_pv_calculated = 1 THEN (l_con_min_subs * lic_price) ELSE 0 END ) );

               END IF;

               --to get no of days for that month
               no_of_days :=
                  (LAST_DAY (
                      ADD_MONTHS (i_lic_start, lpy.lpy_pay_month_no - 1))
                   + roy_pay_after_calculation)
                  - (per_end_date);

               if no_of_days < 0 then
                  no_of_days := 0;
               end if;

               --to get pv con forecast value for current month
               pv_tmp_con_fc_licstrt :=
                  ((pay_amount
                      / POWER (1 + (i_disc_rate / 100), no_of_days))- pay_amount);

               pv_tmp_loc_fc_licstrt :=
                      pv_tmp_loc_fc_licstrt + (pv_tmp_con_fc_licstrt * i_lic_start_rate);

             /* if no_of_days <= 0 then
                  pv_con_liab_actual :=
                        tot_pv_conforc_till_lst_mth
                              - tot_pv_conliab_till_lst_mth
                              + pv_temp_con_forecast;


                  pv_loc_liab_actual :=
                        tot_pv_locforc_till_lst_mth
                                      - tot_pv_locliab_till_lst_mth
                                      + pv_temp_loc_forecast;
              else
                  pv_con_liab_actual :=
                    (tot_pv_conforc_till_lst_mth
                          - tot_pv_conliab_till_lst_mth
                          + pv_temp_con_forecast - pv_tmp_con_fc_licstrt)
                      + pv_temp_mg_con_liab;


                  pv_loc_liab_actual :=
                    (tot_pv_locforc_till_lst_mth
                                - tot_pv_locliab_till_lst_mth
                                + pv_temp_loc_forecast - pv_tmp_loc_fc_licstrt)
                                + pv_temp_mg_loc_liab;

              --pv_loc_liab_actual := pv_con_liab_actual * i_lic_start_rate;
            end if;*/
          END LOOP;

            ---Start the loop to get the values prior to routine month
            --Calcualte the adjustment values if there any change in price and duration of license period
            l_pv_adj_month := i_lic_start;

            SELECT LPY_PAY_MONTH_NO
              INTO l_lpy_paymonth_no
              FROM fid_license_payment_months
             WHERE LPY_LIC_NUMBER = i_lic_number;

            LOOP
               EXIT WHEN TO_CHAR (L_pv_adj_month, 'YYYYMM') =
                            TO_CHAR (per_date, 'YYYYMM');

               no_of_days := 0;
               pay_amount := 0;


               IF TO_CHAR (L_pv_adj_month, 'YYYYMM') =
                     TO_CHAR (i_lic_start, 'YYYYMM')
               THEN
                  --To get the Total asset value for adj month
                  SELECT NVL (SUM (LIS_ASSET_ADJ_VALUE), 0),
                         NVL (SUM (LIS_LOC_ASSET_ADJ_VALUE), 0)
                    INTO l_tot_asset_val_orig_mnth,
                         l_tot_loc_asset_val_orig_mnth
                    FROM fid_license_sub_ledger
                   WHERE lis_lic_number = i_lic_number
                         AND LIS_TER_CODE = cht.cht_ter_code
                         AND LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0) =
                                TO_CHAR (i_lic_start, 'YYYYMM');

                  --To get total asset adj value for adj month
                  SELECT NVL (SUM (a.msa_con_tot_adj_value), 0),
                         NVL (SUM (a.msa_loc_tot_adj_value), 0)
                    INTO l_tot_asset_val_adj_mnth,
                         l_tot_loc_asset_val_adj_mnth
                    FROM x_fin_mg_asset_adj a
                   WHERE a.msa_lic_number = i_lic_number
                         AND a.msa_ter_code = cht.cht_ter_code
                         AND a.msa_adj_year || LPAD (a.msa_adj_month, 2, 0) =
                                TO_CHAR (i_lic_start, 'YYYYMM')
                         AND a.msa_calc_year || LPAD (a.msa_calc_month, 2, 0) <=
                                TO_CHAR (per_date, 'YYYYMM');

                  --to get no of days for that month
                  no_of_days :=
                     (LAST_DAY (
                         ADD_MONTHS (i_lic_start, l_lpy_paymonth_no - 1))
                      + roy_pay_after_calculation)
                     - (i_lic_start);

                  if no_of_days < 0 then
                     no_of_days := 0;
                  end if;


                  --To get the pay amount for adjustment month which is prior to routine month
                  pay_amount :=
                     (l_tot_asset_val_orig_mnth + l_tot_asset_val_adj_mnth)
                     - (CASE WHEN Is_mg_pv_calculated = 1 THEN (l_con_min_subs * lic_price) ELSE 0 END) ;
               ELSE
                  --To get the Total asset value for adj month
                  SELECT NVL (SUM (LIS_ASSET_ADJ_VALUE), 0)
                    INTO l_tot_asset_val_orig_mnth
                    FROM fid_license_sub_ledger
                   WHERE lis_lic_number = i_lic_number
                         AND LIS_TER_CODE = cht.cht_ter_code
                         AND LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0) =
                                TO_CHAR (l_pv_adj_month, 'YYYYMM');

                  --To get total asset adj value for adj month
                  SELECT NVL (SUM (a.msa_con_tot_adj_value), 0)
                    INTO l_tot_asset_val_adj_mnth
                    FROM x_fin_mg_asset_adj a
                   WHERE a.msa_lic_number = i_lic_number
                         AND a.msa_ter_code = cht.cht_ter_code
                         AND a.msa_adj_year || LPAD (a.msa_adj_month, 2, 0) =
                                TO_CHAR (l_pv_adj_month, 'YYYYMM')
                         AND a.msa_calc_year || LPAD (a.msa_calc_month, 2, 0) <=
                                TO_CHAR (per_date, 'YYYYMM');

                  no_of_days :=
                     (LAST_DAY (
                         ADD_MONTHS (i_lic_start, l_lpy_paymonth_no - 1))
                      + roy_pay_after_calculation)
                     - (LAST_DAY (l_pv_adj_month));

                  if no_of_days < 0 then
                    no_of_days := 0;
                  end if;


                  pay_amount :=
                     l_tot_asset_val_orig_mnth + l_tot_asset_val_adj_mnth;
               END IF;


               --Get the conslidated adjustment value
               pv_temp_adj_con_forecast :=
                  pv_temp_adj_con_forecast +
                       ((pay_amount
                          / POWER (1 + (i_disc_rate / 100), no_of_days))- pay_amount);




               SELECT ADD_MONTHS (L_pv_adj_month, 1)
                 INTO L_pv_adj_month
                 FROM DUAL;
            END LOOP;

               tot_pv_conforc_till_lst_mth :=
                    pv_forecast_to_date - tot_pvmg_ter_con_forec_to_date;

               tot_pv_locforc_till_lst_mth :=
                    pv_loc_forecast_to_date - tot_pvmg_ter_loc_forec_to_date ;

               tot_pv_conliab_till_lst_mth :=
                    pv_liab_acutal_to_date - tot_pvmg_ter_liab_to_date ;

               tot_pv_locliab_till_lst_mth :=
                    pv_loc_liab_acutal_to_date - tot_pvmg_ter_loc_liab_to_date ;



            pv_temp_adj_loc_forecast := pv_temp_adj_con_forecast * i_lic_start_rate ;

            pv_adj_con_forecast :=
               pv_temp_adj_con_forecast - tot_pv_conforc_till_lst_mth;

            pv_adj_loc_forecast :=
                      pv_temp_adj_loc_forecast - tot_pv_locforc_till_lst_mth ;




             pv_con_forecast := pv_temp_con_forecast + pv_adj_con_forecast  + pv_temp_mg_con_forecast;
             pv_loc_forecast := pv_temp_loc_forecast + pv_adj_loc_forecast  + pv_temp_mg_loc_forecast;


              if no_of_days <= 0 then
                  pv_con_liab_actual :=
                        tot_pv_conforc_till_lst_mth
                              - tot_pv_conliab_till_lst_mth
                              + pv_temp_con_forecast + pv_adj_con_forecast;


                  pv_loc_liab_actual :=
                        tot_pv_locforc_till_lst_mth
                                      - tot_pv_locliab_till_lst_mth
                                      + pv_temp_loc_forecast + pv_adj_loc_forecast;
              else
                  pv_con_liab_actual :=
                    (tot_pv_conforc_till_lst_mth + pv_adj_con_forecast
                          - tot_pv_conliab_till_lst_mth
                          + pv_temp_con_forecast - pv_tmp_con_fc_licstrt)
                      + pv_temp_mg_con_liab;


                  pv_loc_liab_actual :=
                    (tot_pv_locforc_till_lst_mth + pv_adj_loc_forecast
                                - tot_pv_locliab_till_lst_mth
                                + pv_temp_loc_forecast - pv_tmp_loc_fc_licstrt)
                                + pv_temp_mg_loc_liab;


           END IF;
              --pv_loc_liab_actual := pv_con_liab_actual * i_lic_start_rate;



			--Min. Sub. License Calculation Ends
         ELSE
            -- Loop for the future payment plan to calculate the
            -- PV intenroty of this month
            FOR lpy IN get_future_lpy (i_lic_number, l_diff_month_no)
            LOOP
               l_split_pay_count := 0;

               -- Get the no of records from the split payment table
               SELECT COUNT (*)
                 INTO l_split_pay_count
                 FROM sgy_lic_split_payment
                WHERE lsp_lic_number = i_lic_number
                      AND lsp_lpy_number = lpy.lpy_number;

               -- Check if the split payment is present or not
               IF l_split_pay_count = 0
               THEN
                  no_of_days := 0;
                  pay_amount := 0;
                  -- Pay amount would be content inventory of this month
                  -- into payment percentage for this month diveded by
                  -- remaning payment percentage
                  pay_amount :=
                     con_forecast_for_curr_mth_sub
                     * (lpy.lpy_pay_percent / rem_payment_percetage);
                  -- No of days is equal to license start date plus
                  -- month number plus royalty payment after the
                  -- calculation minus license start date

                  no_of_days :=
                     (LAST_DAY (
                         ADD_MONTHS (i_lic_start, lpy.lpy_pay_month_no - 1))
                      + roy_pay_after_calculation)
                     - (CASE
                           WHEN i_start_month THEN i_lic_start
                           ELSE per_end_date
                        END);
                  -- PV inventory would be payment amount minus payment amount
                  -- divided by one plus discount rate rest to no of days
                  pv_temp_con_forecast :=
                     pv_temp_con_forecast
                     + (pay_amount
                        - (pay_amount
                           / POWER (1 + (i_disc_rate / 100), no_of_days)));

                  --Changes done for Scenario pre-license to license start month
                  IF i_start_month = TRUE AND l_acct_month = FALSE
                     AND TO_CHAR (l_lic_acct_date, 'YYYYMM') <
                            TO_CHAR (i_lic_start, 'YYYYMM')
                  THEN
                     pay_amount_for_pv_start_mth :=
                        con_forecast_pv_for_start_mth
                        * (lpy.lpy_pay_percent / rem_payment_percetage);
                     pv_temp_con_forecast_for_start :=
                        pv_temp_con_forecast_for_start
                        + (pay_amount_for_pv_start_mth
                           - (pay_amount_for_pv_start_mth
                              / POWER (1 + (i_disc_rate / 100), no_of_days)));
                  END IF;
               ELSE
                  -- Loop for the split payments
                  FOR split_pay
                     IN get_future_split (i_lic_number,
                                          lpy.lpy_number,
                                          l_diff_month_no)
                  LOOP
                     no_of_days := 0;
                     pay_amount := 0;
                     -- Payment amount would be content inventory of this month
                     -- into payment percentage for this month divided by
                     -- remaining payment percentage into split payment
                     -- percentage divided by 100
                     pay_amount :=
                        (con_forecast
                         * (lpy.lpy_pay_percent / rem_payment_percetage))
                        * (split_pay.lsp_percent_payment / 100);
                     -- No of days is equal to license start date plus
                     -- month number plus royalty payment after the
                     -- calculation minus license start date
                     no_of_days :=
                        (LAST_DAY (
                            ADD_MONTHS (i_lic_start,
                                        split_pay.lsp_split_month_num - 1))
                         + roy_pay_after_calculation)
                        - i_lic_start;
                     -- PV inventory would be payment amount minus payment
                     -- amount divided by one plus discount rate rest to
                     -- no of days
                     pv_temp_con_forecast :=
                        pv_temp_con_forecast
                        + (pay_amount
                           - (pay_amount
                              / POWER (1 + (i_disc_rate / 100), no_of_days)));
                  END LOOP;                     -- loop end for split payments
               END IF;
            END LOOP;                            -- loop ends for payment plan


            pv_con_forecast :=
               - (pv_con_forecast_due_to_pc + pv_temp_con_forecast);


            --Changes done for Scenario pre-license to license start month
            IF i_start_month = TRUE AND l_acct_month = FALSE
               AND TO_CHAR (l_lic_acct_date, 'YYYYMM') <
                      TO_CHAR (i_lic_start, 'YYYYMM')
            THEN
               pv_con_forecast_for_start_mth :=
                  -pv_temp_con_forecast_for_start - pv_forecast_to_date;
            END IF;

            --Changes done for Scenario pre-license to license start month
            IF i_start_month = TRUE AND l_acct_month = FALSE
               AND TO_CHAR (l_lic_acct_date, 'YYYYMM') <
                      TO_CHAR (i_lic_start, 'YYYYMM')
            THEN
               pv_loc_forecast :=
                  ( (pv_forecast_to_date + pv_con_forecast_for_start_mth)
                   * i_lic_start_rate)
                  - pv_loc_forecast_to_date;
            ELSE
               pv_loc_forecast :=
                  ROUND ( (pv_con_forecast * i_lic_start_rate), 2);
            END IF;

            total_rem_con_forecast := 0;
            payment_till_prev_month := 0;
            pv_already_paid_percentage := 0;

            -- Get the max month no from Payment Plan
            -- till last month for this license
            SELECT MAX (lpy_pay_month_no)
              INTO max_month_no
              FROM fid_license_payment_months
             WHERE lpy_lic_number = i_lic_number;

            --   AND lpy_pay_month_no < l_diff_month_no;

            -- Get the sum of payment for this license till last month
            SELECT SUM (NVL (lpl_paid_amount, 0))
              INTO payment_till_prev_month
              FROM fid_license_payment_ledger
             WHERE lpl_lpy_number IN (SELECT lpy_number
                                        FROM fid_license_payment_months
                                       WHERE lpy_lic_number = i_lic_number)
                   AND lpl_calc_year || LPAD (lpl_calc_month, 2, 0) <
                          TO_NUMBER (
                             TO_CHAR (
                                LAST_DAY (
                                   ADD_MONTHS (i_lic_start,
                                               l_diff_month_no - 1)),
                                'YYYYMM'))
                   AND lpl_ter_code = cht.cht_ter_code;

            payment_till_prev_month := NVL (payment_till_prev_month, 0);

            -- Get the already paid percentage for this license before to this month
            SELECT NVL (SUM (lpy_pay_percent), 0)
              INTO pv_already_paid_percentage
              FROM fid_license_payment_months
             WHERE lpy_lic_number = i_lic_number
                   AND lpy_pay_month_no < l_diff_month_no;

            -- Get total remaining inventory, it would be Content inventory till
            -- current month minus sum of payments till last month minus
            -- Content inventory for the current month due to price change
            -- into payment percentage till last month divided by 100
            IF i_lic_status = 'PC'
            THEN
				if lic_price <> 0
				then
				   total_rem_con_forecast :=
					  (forecast_to_date
					   + (  con_forecast_for_curr_mth_sub
						  / lic_price
						  * i_old_lic_price))
					  - payment_till_prev_month;
				else
						total_rem_con_forecast := forecast_to_date - payment_till_prev_month;
				end if;

            ELSE
               IF i_start_month = TRUE
               THEN
                  total_rem_con_forecast := (forecast_to_date + con_forecast);
               ELSE
                  total_rem_con_forecast :=
                     (forecast_to_date + con_forecast)
                     - payment_till_prev_month;
               END IF;
            END IF;

            pv_remaining_paid_percentage := 100 - pv_already_paid_percentage;
            pv_con_liability := 0;

			 --commented by sushma and moved upwards
			/*
			license_month_no :=
            TRUNC (MONTHS_BETWEEN (per_end_date, i_lic_start)) + 1;
	        */

            -- Payment plan loop
            FOR lpy
               IN get_lpy_pv (i_lic_number,
                              license_month_no,
                              roy_pay_after_calculation)
            LOOP
               no_of_days_pv_liab := 0;
               pay_amount_pv_liab := 0;
               no_of_not_paid_for_lpy_number := 0;

               --Changed by Karim
               IF (LAST_DAY (
                      ADD_MONTHS (i_lic_start, lpy.lpy_pay_month_no - 1))) <
                     per_end_date
               THEN
                  --Changed by Karim for removing payments that are paid before due date + 45 days
                  SELECT COUNT (pay_number)
                    INTO no_of_not_paid_for_lpy_number
                    FROM fid_payment
                   WHERE     pay_lic_number = i_lic_number
                         AND pay_lpy_number = lpy.lpy_number
                         AND pay_status <> 'P'
                         AND pay_amount <> 0;

                  IF no_of_not_paid_for_lpy_number > 0
                  THEN
                     SELECT NVL (SUM (lpl_paid_amount), 0)
                       INTO pay_amount_pv_liab
                       FROM fid_license_payment_ledger
                      WHERE lpl_lpy_number = lpy.lpy_number
                            AND lpl_ter_code = cht.cht_ter_code
                            AND lpl_calc_year || LPAD (lpl_calc_month, 2, 0) <
                                   i_curr_year || LPAD (i_curr_month, 2, 0);
                  ELSE
                     pay_amount_pv_liab := 0;
                  END IF;
               ELSE
                  pay_amount_pv_liab :=
                     total_rem_con_forecast
                     * (lpy.lpy_pay_percent / pv_remaining_paid_percentage);
               --Changed by Karim
               END IF;

               no_of_days_pv_liab :=
                  (LAST_DAY (
                      ADD_MONTHS (i_lic_start, lpy.lpy_pay_month_no - 1))
                   + roy_pay_after_calculation)
                  - per_end_date;

               IF no_of_days_pv_liab <= 0
               THEN
                  no_of_days_pv_liab := 0;
               ELSE
                  --Changed by Karim
                  pv_con_liability :=
                     pv_con_liability
                     + ( (pay_amount_pv_liab
                          / POWER (1 + (i_disc_rate / 100),
                                   no_of_days_pv_liab))
                        - pay_amount_pv_liab);
               END IF;
            END LOOP;                                -- loop ends payment plan

         -- PV liability cost of this month is eqaul to total PV
         -- inventory till current month minus PV liability cost
         -- till last month minus PV liability
         IF i_lic_status = 'PC'
         Then
            If I_Old_Lic_Price = 0
            Then
                  pv_con_liability :=  Pv_Con_Liability * (1 +  I_Lic_Price);
            else
                  pv_con_liability :=
                     Pv_Con_Liability
                     * (1 + ( (I_Lic_Price - I_Old_Lic_Price) / I_Old_Lic_Price));
            end if;
            pv_con_liab_actual :=
                 (pv_forecast_to_date + pv_con_forecast)
               - pv_liab_acutal_to_date
               - pv_con_liability;
         ELSE
            pv_con_liab_actual :=
                 (pv_forecast_to_date + pv_con_forecast)
               - pv_liab_acutal_to_date
               - pv_con_liability;

               --Changes done for Scenario pre-license to license start month
               IF i_start_month = TRUE AND l_acct_month = FALSE
                  AND TO_CHAR (l_lic_acct_date, 'YYYYMM') <
                         TO_CHAR (i_lic_start, 'YYYYMM')
               THEN
                  pv_con_liab_actual :=
                       (pv_forecast_to_date + pv_con_forecast_for_start_mth)
                     - pv_liab_acutal_to_date
                     - pv_con_liability;
               END IF;
            END IF;

            --Changes done for Scenario pre-license to license start month
            IF i_start_month = TRUE AND l_acct_month = FALSE
               AND TO_CHAR (l_lic_acct_date, 'YYYYMM') <
                      TO_CHAR (i_lic_start, 'YYYYMM')
            THEN
               pv_con_forecast := pv_con_forecast_for_start_mth;
               pv_loc_liab_actual :=
                  ( (pv_liab_acutal_to_date + pv_con_liab_actual)
                   * i_lic_start_rate)
                  - pv_loc_liab_acutal_to_date;
            ELSE
               pv_con_forecast := pv_con_forecast;
               pv_loc_liab_actual :=
                  ROUND ( (pv_con_liab_actual * i_lic_start_rate), 2);
            END IF;
         END IF;

         --27Mar2015:Ver 0.2 START P1 Issue : Jawahar Garg - con_forecast is not updating after costing routine run in case of 'C'
         BEGIN
            SELECT *
              INTO v_lic_sub_ledger_rec
              FROM fid_license_sub_ledger
             WHERE     lis_lic_number = i_lic_number
                   AND lis_lsl_number = i_lsl_number
                   AND lis_ter_code = cht.cht_ter_code
                   AND lis_per_year = i_curr_year
                   AND lis_per_month = i_curr_month;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_lic_sub_ledger_rec.lis_ed_loc_forecast := 0;
         END;

         --27Mar2015:Ver 0.2 END P1 Issue : Jawahar Garg - con_forecast is not updating after costing routine run in case of 'C'
         
         --Finance Dev Phase I Zeshan [Start]
         l_lis_con_pay := 0;
         l_lis_loc_pay := 0;
         l_lis_pay_mov_flag := 'N';
         
         x_prc_get_lic_mvmt_data(i_lic_number,i_lsl_number,l_old_lic_start,l_lis_con_pay,l_lis_loc_pay,l_lis_pay_mov_flag);
         --Finance Dev Phase I [End]
         
         --insert the cumulative inventory and cost obtained for each licensee
         --in sub ledger
         insert_update_sub_ledger (
            i_lic_number,
            i_lsl_number,
            cht.cht_ter_code,
            i_curr_year,
            i_curr_month,
            lic_price,
            lic_factor,
            i_lic_start_rate,
            NULL,                                          --i_lic_start_rate,
            0,                                              -- paid exhibition
            con_forecast,                                     -- Con Inventory
            loc_forecast,                                     -- Loc Inventory
            0,                                                     -- con_calc
            0,                                                     -- loc_calc
            0,                                             -- Con Content Cost
            0,                                             -- Loc Content Cost
            0,                                                   -- con_adjust
            0,                                                   -- loc_adjust
            0,                                                -- Con Write-off
            0,                                                -- Loc Write-off
            pv_con_forecast,                               -- PV Con Inventory
            pv_loc_forecast,                               -- PV Loc Inventory
            0,                                        -- PV Con Inventory Cost
            pv_con_liab_actual,
            -- PV Con Liability cost
            0,
            pv_loc_liab_actual,
            --  PV Loc Liability cost
            v_lic_sub_ledger_rec.lis_ed_loc_forecast, --0,-- ED Inventory    /*ver 0.2 commented 0 and added actual value*/
            0,                                                       --ED Cost
            0,                                           -- Con Unforseen Cost
            0,                                           -- Loc Unforseen cost
            --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
            (CASE
                WHEN l_min_sub_flag = 'Y' THEN con_forecast_for_curr_mth_sub
                ELSE 0
             END),
            i_lic_start,
            l_lic_end,
            l_mean_subscriber,
            pv_temp_mg_con_forecast,                   --pv mg con inventory against mg payments
            pv_temp_mg_loc_forecast,                   --pv mg loc inventory against mg payments
            (CASE
                WHEN l_min_sub_flag = 'Y' THEN loc_forecast_for_curr_mth_sub
                ELSE 0
             END),
            pv_temp_mg_con_liab,
            pv_temp_mg_loc_liab,
            --END [BR_15_144-Finance CRs:New Payment Plan]
            i_entry_oper,
            --Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/24]
						CASE WHEN NVL(I_REVAL_FLAG,'NC') = 'NC'
            AND ( NVL(con_forecast,0) <> 0 OR NVL(loc_forecast,0)<>0 )
						THEN
								'PC'
						ELSE
								i_reval_flag
						END,
            --Dev : Fin CR : End : [Jawahar Garg]_[2016/05/24]
            --Finance Dev Phase I Zeshan [Start]
            i_lic_currency,
            i_com_number,
            i_lic_status,
            l_lis_pay_mov_flag,
            l_lis_con_pay,
            l_lis_loc_pay
            --Finance Dev Phase I [End]
        );
      END LOOP;                                                -- end cht loop

      IF i_start_month = TRUE
      THEN
         UPDATE fid_license
            SET lic_rate = i_lic_start_rate,
                lic_start_rate = i_lic_start_rate,
                lic_entry_oper = i_entry_oper,
                lic_entry_date = SYSDATE
          WHERE lic_number = i_lic_number;
      END IF;
   END calulate_inventory_for_roy;

   -- Pure Finance: Ajit : 02-Apr-2013 : Procedure added to settle the -ve pre-payments of ROY licenses
   PROCEDURE pre_payment_settlement_for_roy (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_lsl_number      IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_lic_status      IN VARCHAR2,
      i_user_id         IN VARCHAR2)
   IS
      -- For ROY licenses this cursor will bring -ve pre-payments with code 'T'
      -- For Calcelled licenses this cursor will bring all the -ve payments with code 'T' in routine month
      CURSOR refund_t_for_mon
      IS
         SELECT pay_number,
                pay_lic_number,
                pay_lsl_number,
                NVL (pay_amount, 0) pay_amount,
                pay_source_number,
                pay_rate
           FROM fid_payment, fid_license
          WHERE     pay_amount < 0
                AND pay_status = 'P'
                AND UPPER (pay_code) = 'T'
                AND lic_number = pay_lic_number
                AND DECODE (i_lic_status, 'A', pay_date, lic_start - 1) <
                       lic_start
                AND pay_lic_number = i_lic_number
                AND pay_lsl_number = i_lsl_number
                AND pay_date BETWEEN i_fromdate AND i_todate;

      refund_t                       refund_t_for_mon%ROWTYPE;

      -- For ROY licenses this cursor will bring -ve pre-payments without code 'T'
      -- For Calcelled licenses this cursor will bring all the -ve payments without code 'T' in routine month
      CURSOR refund_for_mon
      IS
           SELECT pay_number,
                  pay_lic_number,
                  pay_lsl_number,
                  NVL (pay_amount, 0) pay_amount,
                  pay_source_number,
                  pay_date,
                  pay_rate
             FROM fid_payment, fid_license
            WHERE     pay_amount < 0
                  AND pay_status = 'P'
                  AND UPPER (pay_code) <> 'T'
                  AND lic_number = pay_lic_number
                  AND DECODE (i_lic_status, 'A', pay_date, lic_start - 1) <
                         lic_start
                  AND pay_lic_number = i_lic_number
                  AND pay_lsl_number = i_lsl_number
                  AND pay_date BETWEEN i_fromdate AND i_todate
         ORDER BY pay_date;

      refund                         refund_for_mon%ROWTYPE;

      -- For ROY licenses this cursor will bring +ve pre-payments
      -- For Calcelled licenses this cursor will bring all the -ve payments in routine month
      CURSOR pre_payment_till_curr_mon (
         l_pay_date DATE)
      IS
           SELECT pay_number,
                  pay_lic_number,
                  pay_lsl_number,
                  NVL (pay_amount, 0) pay_amount,
                  pay_source_number,
                  pay_rate,
                  pay_lpy_number
             FROM fid_payment, fid_license
            WHERE     pay_amount > 0
                  AND pay_status = 'P'
                  AND lic_number = pay_lic_number
                  AND DECODE (i_lic_status, 'A', pay_date, lic_start - 1) <
                         lic_start
                  AND pay_lic_number = i_lic_number
                  AND pay_lsl_number = i_lsl_number
                  AND pay_date <= l_pay_date
         ORDER BY pay_date;

      pre_payment                    pre_payment_till_curr_mon%ROWTYPE;
      l_rem_refund_amount            NUMBER;
      rfd_amt_already_sett_for_pay   NUMBER;
      rfd_amt_now_sett_for_pay       NUMBER;
      period_value                   NUMBER;
      l_pay_rate                     NUMBER;
   BEGIN
      period_value := i_current_year || LPAD (i_current_month, 2, 0);

      -- Loop for all -ve prepayment for the license with Code 'T' for routine period
      OPEN refund_t_for_mon;

      LOOP
         FETCH refund_t_for_mon INTO refund_t;

         EXIT WHEN refund_t_for_mon%NOTFOUND;
         -- insert into refund settlement table
         insert_refund_settle (refund_t.pay_lic_number,
                               refund_t.pay_source_number,
                               refund_t.pay_lsl_number,
                               refund_t.pay_number,
                               -refund_t.pay_amount,
                               i_current_month,
                               i_current_year,
                               'Y',
                               i_user_id);
         l_pay_rate := 0;

         SELECT NVL (a.pay_rate, 0)
           INTO l_pay_rate
           FROM fid_payment a
          WHERE a.pay_number = refund_t.pay_source_number;

         -- insert inot realized forex table
         insert_realized_forex (
            i_lic_number,
            refund_t.pay_lsl_number,
            refund_t.pay_number,
            i_current_month,
            i_current_year,
            -- Realized forex = settled amount *
            -- (refund payment rate - payment rate)
            (refund_t.pay_amount * (refund_t.pay_rate - l_pay_rate)),
            'CON',
            i_user_id);
      END LOOP;

      -- loop end for -ve prepayment for the license with Code 'T' for routine period
      CLOSE refund_t_for_mon;

      -- Loop for all -ve prepayment for the license without Code 'T' for routine period
      OPEN refund_for_mon;

      LOOP
         FETCH refund_for_mon INTO refund;

         EXIT WHEN refund_for_mon%NOTFOUND;
         l_rem_refund_amount := refund.pay_amount;

         OPEN pre_payment_till_curr_mon (refund.pay_date);

         LOOP
            FETCH pre_payment_till_curr_mon INTO pre_payment;

            EXIT WHEN pre_payment_till_curr_mon%NOTFOUND;

            -- check if the refund amount is greater than 0
            IF l_rem_refund_amount < 0
            THEN
               BEGIN
                  -- get the amount already settled for the month
                  SELECT SUM (frs_rfd_amount)
                    INTO rfd_amt_already_sett_for_pay
                    FROM x_fin_refund_settle
                   WHERE frs_year || LPAD (frs_month, 2, 0) <= period_value
                         AND frs_lic_number = i_lic_number
                         AND frs_pay_number = pre_payment.pay_number;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     rfd_amt_already_sett_for_pay := 0;
               END;

               -- check if the payment amount is not equal to already settled amount
               IF pre_payment.pay_amount <>
                     NVL (rfd_amt_already_sett_for_pay, 0)
               THEN
                  -- check if the rem refund amount (payment amount - already settled amount)
                  -- greater than -ve to be refund aount
                  IF (pre_payment.pay_amount
                      - NVL (rfd_amt_already_sett_for_pay, 0)) >=
                        -l_rem_refund_amount
                  THEN
                     rfd_amt_now_sett_for_pay := -l_rem_refund_amount;
                     l_rem_refund_amount := 0;
                  ELSE
                     rfd_amt_now_sett_for_pay :=
                        pre_payment.pay_amount
                        - NVL (rfd_amt_already_sett_for_pay, 0);
                     l_rem_refund_amount :=
                        l_rem_refund_amount + rfd_amt_now_sett_for_pay;
                  END IF;


                  -- insert into refund settlement table
                  insert_refund_settle (pre_payment.pay_lic_number,
                                        pre_payment.pay_number,
                                        pre_payment.pay_lsl_number,
                                        refund.pay_number,
                                        rfd_amt_now_sett_for_pay,
                                        i_current_month,
                                        i_current_year,
                                        'Y',
                                        i_user_id);
                  -- insert inot realized forex table
                  insert_realized_forex (
                     i_lic_number,
                     pre_payment.pay_lsl_number,
                     refund.pay_number,
                     i_current_month,
                     i_current_year,
                     -- Realized forex = settled amount *
                     -- (refund payment rate - payment rate)
                     (rfd_amt_now_sett_for_pay
                      * (refund.pay_rate - pre_payment.pay_rate)),
                     'CON',
                     i_user_id);
               END IF;
            END IF;

            -- Check if the refund amount is eqaul to 0
            IF l_rem_refund_amount = 0
            THEN
               -- Set the Payment Plan referance (lpy_number)
               -- to payment table
               UPDATE fid_payment
                  SET pay_lpy_number = pre_payment.pay_lpy_number,
                      pay_entry_date = SYSDATE,
                      pay_entry_oper = i_user_id
                WHERE pay_number = refund.pay_number
                      AND pay_lic_number = refund.pay_lic_number;
            END IF;
         END LOOP;          -- loop end for +ve prepayment before the pay date

         CLOSE pre_payment_till_curr_mon;
      END LOOP;

      -- loop end for -ve prepayment for the license without Code 'T' for routine period
      CLOSE refund_for_mon;
   END pre_payment_settlement_for_roy;

   -- Pure Finance: Ajit : 23-Feb-2013 : Procedure added to processes the new licenses
   -- The licenses started after the GO-Live date of Pure Finance
   PROCEDURE calculate_fin_amortisation (
      ccomnumber            IN NUMBER,
      period_month          IN NUMBER,
      period_year           IN NUMBER,
      from_date             IN DATE,
      todate                IN DATE,
      connumber             IN NUMBER,
      month_end_rate_date   IN DATE,
      user_id               IN VARCHAR2,
      month_end_type        IN VARCHAR2,
      regioncode            IN fid_region.reg_code%TYPE)
   IS
      period_value                     NUMBER := 0;
      lic_start_value                  NUMBER := 0;
      lic_start_month                  NUMBER := 0;
      lic_start_year                   NUMBER := 0;
      lic_end_value                    NUMBER := 0;
      lic_acc_value                    NUMBER := 0;
      lic_showing_lic                  NUMBER := 0;
      con_forecast_curr_mth            NUMBER;
      con_actual_curr_mth              NUMBER := 0;
      loc_actual_curr_mth              NUMBER := 0;
      con_forecast_till_curr_mth       NUMBER;
      loc_forecast                     NUMBER;
      loc_forecast_till_curr_mth       NUMBER;
      con_actual                       NUMBER;
      con_actual_till_lst_mth          NUMBER;
      loc_actual_till_lst_mth          NUMBER;
      con_actual_till_curr_mth         NUMBER;
      loc_actual_till_curr_mth         NUMBER;
      loc_actual                       NUMBER;
      con_adjust                       NUMBER;
      prev_month                       NUMBER;
      prev_year                        NUMBER;
      loc_adjust                       NUMBER;
      pv_con_forcast_till_curr_mth     NUMBER;
      pv_loc_forcast_till_curr_mth     NUMBER;
      ed_loc_forecast_till_curr_mth    NUMBER;
      ed_loc_actual_till_lst_mth       NUMBER;
      pv_loc_forecast                  NUMBER;
      ed_loc_actual                    NUMBER;
      con_writeoff                     NUMBER;
      loc_writeoff                     NUMBER;
      unrealized_forex                 NUMBER;
      realized_forex                   NUMBER;
      con_unforseen                    NUMBER;
      loc_unforseen                    NUMBER;
      unforseen_cost                   NUMBER;
      fin_unforceen_cost               NUMBER;
      per_date                         DATE;
      per_end_date                     DATE;
      forecast_to_date                 NUMBER;
      amort_to_date                    NUMBER;
      remain_showings                  NUMBER;
      cost_per_showings                NUMBER;
      cost_curr_mth_showings           NUMBER;
      writeoff_auth_date               NUMBER;
      disc_writeoff_auth_date          DATE;
      costed_run_sub_ledger_to_date    NUMBER;
      pre_license                      BOOLEAN;
      pre_license_made_curr_month      BOOLEAN;
      accouting_month                  BOOLEAN;
      first_month                      BOOLEAN;
      last_month                       BOOLEAN;
      expired_license                  BOOLEAN;
      writeoff_license                 BOOLEAN;
      writeoff_lic_made_curr_month     BOOLEAN;
      price_changed_license            BOOLEAN;
      lic_started_inv_not_added        BOOLEAN;
      bioscope_license                 BOOLEAN;
      writeoff_flag                    BOOLEAN;
      last_day_of_month                DATE;
      license_rate                     NUMBER;
      pv_con_liab_actual               NUMBER;
      pv_con_liab_act_till_cur_mth     NUMBER;
      pv_con_liab_act_till_lst_mth     NUMBER;
      pv_loc_liab_actual               NUMBER;
      pv_liability_till_lst_mth        NUMBER;
      pv_con_inv_actual                NUMBER;
      pv_loc_inv_actual                NUMBER;
      pv_con_actual_till_lst_mth       NUMBER;
      pv_loc_actual_till_lst_mth       NUMBER;
      no_of_days                       NUMBER;
      no_of_days_prev_mth              NUMBER;
      costed_schedules_curr_month      NUMBER := 0;
      costed_schedules_till_curr_mth   NUMBER;
      forward_rate                     NUMBER;
      discount_rate                    NUMBER;
      discount_rate_prev_mth           NUMBER;
      forward_to_date_rate             NUMBER;
      license_start_rate               NUMBER;
      mth_end_date_rate                NUMBER;
      last_day_prev_mth                DATE;
      pv_future_payment_cnt            NUMBER;
      pv_con_liability_act_till_curr   NUMBER;
      pv_loc_liability_act_till_curr   NUMBER;
      l_total_payment_sum              NUMBER := 0;
      l_refund_amount                  NUMBER;
      l_transfer_amount                NUMBER;
      l_actual_pay_amount              NUMBER;
      l_extra_payment                  NUMBER;
      l_pay_amount_adjusted            NUMBER;
      l_actual_payment                 NUMBER;
      l_number                         NUMBER;
      l_total_prepayment_sum           NUMBER := 0;
      -- Dev.R5 : SVOD Implementation : Start : [SVOD Finance]_[Shubhada Bongarde]_[2015/04/14]
      l_lic_start                      DATE;
      l_lic_end                        DATE;
      --Dev.R5 : SVOD Implementation : End
      --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/23]
      l_reval_flag                     VARCHAR2(2);
      l_old_lic_start	                 DATE;
      --Dev : Fin CR : End
      --Finance Dev Phase I Zeshan [Start]
      l_lis_con_pay                    fid_license_sub_ledger.lis_con_pay%TYPE;
      l_lis_loc_pay                    fid_license_sub_ledger.lis_loc_pay%TYPE;
      l_lis_pay_mov_flag               fid_license_sub_ledger.lis_pay_mov_flag%TYPE;
      --Finance Dev Phase I [End]

      -- Cursor to get the Contract information
      CURSOR con_c
      IS
         SELECT *
           FROM fid_company, fid_contract
          WHERE     con_number = connumber
                AND con_status = 'A'
                AND com_number = ccomnumber;

      con                              con_c%ROWTYPE;

      -- Cursor to get the all the licenses with Amort Code D ,C and  E
      CURSOR lic_c (
         connumber      NUMBER,
         comnumber      NUMBER,
         periodstart    DATE,
         periodend      DATE,
         regioncode     VARCHAR2)
      IS
         SELECT lic_number,
                NVL (lic_showing_lic, 10) lic_showing_lic,
                NVL (lic_showing_int, 10) lic_showing_int,
                lic_start,
                lic_end,
                NVL (lic_rate, 1) lic_rate,
                lic_price,
                lic_chs_number,
                lic_currency,
                NVL (lic_amort_code, 'C') lic_amort_code,
                com_ter_code,
                ter_cur_code,
                lic_status,
                NVL (lic_catchup_flag, 'N') lic_catchup_flag,
                lic_acct_date,
                NVL (lic_writeoff, 'N') lic_writeoff,
                NVL (lic_price_chg_flg, 'N') lic_price_chg_flg
           FROM fid_license,
                fid_licensee,
                fid_company,
                fid_region,
                fid_territory
          WHERE     lic_con_number = connumber
                AND NVL (lic_acct_date,
                         TO_DATE ('31-DEC-2099', 'DD-MON-YYYY')) <= periodend
                -- AND lic_end >= periodstart (commented to get  expired Licenses)
                AND lic_type IN ('FLF', 'CHC')
                AND lee_number = lic_lee_number
                AND com_number = lee_cha_com_number
                -- AND com_number = comnumber
                AND com_ter_code = ter_code
                -- Pure Finance: Ajit : 23-Feb-2013 : Condition commented to write common logic for Linear and Catch-up licenses,
                --  and get the liceses started after the Go-Live date of Pure Finance
                --AND NVL(LIC_CATCHUP_FLAG, 'N') = 'N' -- Condition added on 03-Nov-2012 by Ajit to exclude the Catch up Licenses
                AND reg_id(+) = lee_split_region
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (regioncode,
                                  '%', NVL (reg_code, '#'),
                                  regioncode))
                --PURE FINANCE:[exclude licenses for  NCF deal ][MANGESH GULHANE][2013-02-25]
                --AND UPPER (lic_status) <> 'F'
                AND UPPER (lic_status) = 'A'
                --PURE FINANCE End
                -- AND UPPER (lic_amort_code) IN ('D', 'C', 'E')
                AND UPPER (lic_amort_code) IN ('D', 'C', 'E', 'A','F') ---Added for SVOD release    --[25-Aug-2015]Jawahar.Grag[Added amort code 'F' for Omnibus]
                AND lic_start >= (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                    FROM x_fin_configs
                                   WHERE KEY = 'GO-LIVEDATE');

      -- Cursor to get the Amortiztion till date (Invenroty and Cost)
      CURSOR lis_c (
         licnumber    NUMBER,
         tercode      VARCHAR2,
         peryear      NUMBER,
         permonth     NUMBER)
      IS
         SELECT NVL (SUM (lis_con_forecast), 0),
                NVL (SUM (lis_con_actual + lis_con_adjust), 0)
           FROM fid_license_sub_ledger
          WHERE lis_lic_number = licnumber AND lis_ter_code = tercode
                AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                       peryear || LPAD (permonth, 2, 0);

      --cursor to get all the secondry licensee far each license
      CURSOR lic_sec_lee (l_lic_number NUMBER)
      IS
         SELECT lsl_number, lsl_lee_price
           FROM x_fin_lic_sec_lee
          WHERE lsl_lic_number = l_lic_number;

      --cursor to get all the payments for license start date to
      --calculate present value
      CURSOR pv_payments (
         i_lic_number    NUMBER,
         i_lsl_number    NUMBER,
         i_lic_start     DATE)
      IS
         SELECT lic_start,
                lic_price,
                NVL (pay_amount, 0) pay_amount,
                pay_due,
                lsl_lee_price,
                pay_number,
                pay_status,
                pay_date
           FROM fid_payment, fid_license, x_fin_lic_sec_lee
          WHERE     lic_number = pay_lic_number
                AND pay_lsl_number = lsl_number                 --i_lsl_number
                AND pay_amount > 0
                AND pay_lic_number = lsl_lic_number             --i_lic_number
                AND lsl_number = i_lsl_number
                AND lsl_lic_number = i_lic_number
                AND pay_due > lic_start
                AND NVL (pay_date, '31-DEC-2199') >= lic_start;

      --Loop for All the prepayments for License
      --before license start date
      CURSOR lic_pv_pre_payment (
         l_lsl_number    NUMBER,
         l_lic_number    NUMBER)
      IS
         SELECT pay_number,
                pay_amount,
                pay_rate,
                lic_currency
           FROM fid_payment, fid_license
          WHERE     pay_lic_number = lic_number
                AND pay_lsl_number = l_lsl_number
                AND pay_lic_number = l_lic_number
                AND ( (NVL (pay_date, '31-DEC-2199') < lic_start)
                     OR (pay_due < lic_start))
                AND pay_amount > 0;
   --get the details of each payment for a license
   --and update payment percentage field in case of price
   --change scenario
   /*CURSOR payment_details (i_lic_number NUMBER, i_lsl_number NUMBER)
   IS
      SELECT   pay_number, pay_amount, lsl_lee_price, pay_original_payment,
               NVL (pay_payment_pct, 0) pay_payment_pct
          FROM x_fin_lic_sec_lee, fid_payment
         WHERE lsl_number = pay_lsl_number
           AND pay_lsl_number = i_lsl_number
           AND pay_lic_number = i_lic_number
           AND NVL (UPPER (pay_original_payment), 'N') = 'Y'
      ORDER BY pay_number;*/
   -- TODO : only original payments (Check with Karim)
   BEGIN
      --- Identify the first day of Amortisation month
      per_date :=
         TO_DATE (
            '01' || TO_CHAR (period_month, '09') || TO_CHAR (period_year),
            'DDMMYYYY');
      --- Identify the last day of Amortisation month
      per_end_date :=
         LAST_DAY (
            TO_DATE (
               '01' || TO_CHAR (period_month, '09') || TO_CHAR (period_year),
               'DDMMYYYY'));
      --- Identify the year month of Amortisation month in YYYYMM format
      period_value := period_year || LPAD (period_month, 2, 0);
      --calculate the last day of previous month
      last_day_prev_mth := LAST_DAY (ADD_MONTHS (per_end_date, -1));

      IF period_month = 1
      THEN
         prev_month := 12;
         prev_year := period_year - 1;
      ELSE
         prev_month := period_month - 1;
         prev_year := period_year;
      END IF;

      -- Get the unforseen cost of Pure Finance
      SELECT content
        INTO fin_unforceen_cost
        FROM x_fin_configs
       WHERE KEY = 'UNFORSEEN_COST';

      OPEN con_c;

      FETCH con_c INTO con;

      -- Select the Licenses for the Contract
      FOR lic IN lic_c (con.con_number,
                        ccomnumber,
                        per_date,
                        per_end_date,
                        regioncode)
      LOOP
         -- Get the license start, end and accouting date values into local variable
         lic_start_value :=
            TO_NUMBER (
               TO_CHAR (lic.lic_start, 'YYYY')
               || TO_CHAR (lic.lic_start, 'MM'));
         lic_end_value :=
            TO_NUMBER (
               TO_CHAR (lic.lic_end, 'YYYY') || TO_CHAR (lic.lic_end, 'MM'));
         lic_acc_value :=
            TO_NUMBER (
               TO_CHAR (lic.lic_acct_date, 'YYYY')
               || TO_CHAR (lic.lic_acct_date, 'MM'));
         -- Dev.R5 : SVOD Implementation : Start : [SVOD Finance]_[Shubhada Bongarde]_[2015/04/14]
         l_lic_start := lic.lic_start;
         l_lic_end := lic.lic_end;


         -- Dev.R5 : SVOD Implementation : End
         -- Check if the accouting date is less than Amortisation month and
         -- License start date is greater than Amortisation month
         -- then it is a pre-license
         --Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/23]
         l_reval_flag := NULL;

         BEGIN
            SELECT LIS_LIC_START
              INTO l_old_lic_start
              FROM fid_license_sub_ledger
             WHERE lis_lic_number = lic.lic_number
               AND lis_per_year || LPAD (lis_per_month, 2, 0) =TO_NUMBER ( TO_CHAR (last_day_prev_mth, 'YYYYMM'))
               AND ROWNUM < 2;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
          l_old_lic_start := lic.lic_start;
         END;
         --Dev : Fin CR : END : [Jawahar Garg]_[2016/05/23]


         IF lic_acc_value <= period_value AND lic_start_value > period_value
         THEN
            pre_license := TRUE;

			--Dev : Fin CR : Start : [Jawahar Garg]_[2016/05/23]
			IF lic_start_value > TO_NUMBER(TO_CHAR(l_old_lic_start,'YYYYMM'))
			THEN
				 l_reval_flag := 'RL';
			END IF;
			--Dev : Fin CR : END : [Jawahar Garg]_[2016/05/23]

            -- Check if the accouting date is equal to Amortisation month
            -- then it is pre-license made in curent month
            IF lic_acc_value = period_value
            THEN
               pre_license_made_curr_month := TRUE;
            ELSE
               pre_license_made_curr_month := FALSE;
            END IF;
         ELSE
            pre_license := FALSE;
         END IF;

         -- Check if the license end date is less than Amortisation month
         -- then it is expired license
         IF lic_end_value < period_value
         THEN
            expired_license := TRUE;
         ELSE
            expired_license := FALSE;
         END IF;

         -- Check if the license is Writen off
         IF pre_license = FALSE AND lic.lic_writeoff = 'Y'
         THEN
            writeoff_license := TRUE;

            -- Get the max write off authorization date
            SELECT TO_NUMBER (TO_CHAR (MAX (dwo_auth_date), 'YYYYMM'))
              INTO writeoff_auth_date
              FROM x_fin_disc_write_off
             WHERE dwo_lic_no = lic.lic_number
                   AND UPPER (dwo_auth_status) = 'AUTHORISED';

            -- Check if the license autorization date is in current month
            -- then it is written off license in current month
            IF writeoff_auth_date >= period_value
            THEN
               writeoff_lic_made_curr_month := TRUE;
            ELSE
               writeoff_lic_made_curr_month := FALSE;
            END IF;
         ELSE
            writeoff_license := FALSE;
            writeoff_lic_made_curr_month := FALSE;
         END IF;

         forecast_to_date := 0;
         amort_to_date := 0;

         -- Get the Inventory and cost till date
         OPEN lis_c (lic.lic_number,
                     lic.com_ter_code,
                     period_year,
                     period_month);

         -- Fetch the Inventory and cost till date
         FETCH lis_c
         INTO forecast_to_date, amort_to_date;

         CLOSE lis_c;

         -- Check if the license is starting in amortization month
         -- then it is First Month
         IF lic_acc_value = period_value
         THEN
            accouting_month := TRUE;
         ELSE
            -- Check if the Inventory till date is not eqaul to
            -- license price then it is Price Changed licebse
            IF pre_license = FALSE
            THEN
               IF lic.lic_price <> forecast_to_date
               THEN
                  UPDATE fid_license
                     SET lic_price_chg_flg = 'Y',
                         lic_entry_oper = user_id,
                         lic_entry_date = SYSDATE
                   WHERE lic_number = lic.lic_number;

                  price_changed_license := TRUE;
                  --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/23]
                  l_reval_flag := 'PC';
                  --Dev : Fin CR : End
               ELSE
                  price_changed_license := FALSE;
               END IF;
            ELSE
               price_changed_license := FALSE;
            END IF;

            accouting_month := FALSE;
         END IF;

         IF lic_start_value = period_value
         THEN
            first_month := TRUE;
            --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/23]
            l_reval_flag := 'AL';
            --Dev : Fin CR : End
         ELSE
            first_month := FALSE;
         END IF;

         -- Check if the license is ending in amortization month
         -- then it is Lsst Month
         IF lic_end_value = period_value
         THEN
            last_month := TRUE;
         ELSE
            last_month := FALSE;
         END IF;

         -- Check id the accouting date is in amortization month and license
         -- start date is greater than amortization month
         -- then it is License Started but inventory not added
         IF lic_acc_value = period_value AND lic_start_value < period_value
         THEN
            lic_started_inv_not_added := TRUE;
						--Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/23]
            l_reval_flag := 'AL';
            --Dev : Fin CR : End
         ELSE
            lic_started_inv_not_added := FALSE;
         END IF;

         --delete records from sub ledger for current routine month
         IF UPPER (lic.lic_amort_code) <> 'C'
         THEN
            DELETE FROM fid_license_sub_ledger
                  WHERE lis_lic_number = lic.lic_number
                        AND lis_per_year || LPAD (lis_per_month, 2, 0) >=
                               CONCAT (period_year,
                                       LPAD (period_month, 2, 0));
         END IF;

         --delete records from realized forex for current routine month
         DELETE FROM x_fin_realized_forex
               WHERE rzf_lic_number = lic.lic_number
                     AND rzf_year || LPAD (rzf_month, 2, 0) >=
                            CONCAT (period_year, LPAD (period_month, 2, 0));

         --delete records for unrealized forex gain\loss for current routine
         --month
         DELETE FROM x_fin_unrealized_forex
               WHERE unf_lic_number = lic.lic_number
                     AND unf_year || LPAD (unf_month, 2, 0) >=
                            CONCAT (period_year, LPAD (period_month, 2, 0));

         --delete records from refun settle for current routine month
         DELETE FROM x_fin_refund_settle
               WHERE frs_lic_number = lic.lic_number
                     AND frs_year || LPAD (frs_month, 2, 0) >=
                            CONCAT (period_year, LPAD (period_month, 2, 0));

         --latest available rate between last day of previous month
         --and last day of current month(month of CED) is taken as
         --forward rate
         IF UPPER (NVL (con.con_ed_applicable_flag, 'N')) = 'Y'
         THEN
            forward_rate :=
               x_pkg_fin_get_spot_rate.get_forward_rate_with_inverse (
                  lic.lic_currency,
                  lic.ter_cur_code,
                  con.con_con_effective_date);
         END IF;

         --If license start date is greater than todate then check if spot rate
         --is available on lic_start_date else get spot rate closest to month end rate date
         license_start_rate :=
            x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
               lic.lic_currency,
               lic.ter_cur_code,
               lic.lic_start);

         IF license_start_rate IS NULL
         THEN
            license_start_rate :=
               x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                  lic.lic_currency,
                  lic.ter_cur_code,
                  month_end_rate_date);
         END IF;

         --calculate month end rate date spot rate
         mth_end_date_rate :=
            x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
               lic.lic_currency,
               lic.ter_cur_code,
               todate);

         FOR c_lic_sec_lee IN lic_sec_lee (lic.lic_number)
         LOOP
            -- Settle the Pre-payments for Active licenses
            IF UPPER (month_end_type) = 'FINAL'
            THEN
               fid_cos_pk.pre_payment_settlement (lic.lic_number,
                                                  c_lic_sec_lee.lsl_number,
                                                  period_month,
                                                  period_year,
                                                  from_date,
                                                  todate,
                                                  lic.lic_status,
                                                  user_id);
               -- Calculate the realized forex gain(loss) for Content and PV
               fid_cos_pk.calculate_refund_settlement (
                  lic.lic_number,
                  c_lic_sec_lee.lsl_number,
                  period_month,
                  period_year,
                  from_date,
                  todate,
                  user_id);
            END IF;
         END LOOP;

         --check if license in made in current month
         IF pre_license = TRUE
         THEN
            -- if accounting date is in open month
            IF pre_license_made_curr_month = TRUE
            THEN
               UPDATE fid_license
                  SET lic_acct_date = NULL,
                      lic_price_chg_flg = 'N',
                      lic_before_acct_date = 'Y',
                      -- set lic_before_acct_date to 'Y' to show reversal license in the commitment report lic_start month
                      lic_entry_oper = user_id,
                      lic_entry_date = SYSDATE
                WHERE lic_number = lic.lic_number;

               IF UPPER (month_end_type) = 'FINAL'
               THEN
                  --Get the discretionary write off flag
                  --and max Authorization date for license
                  SELECT MAX (dwo_auth_date)
                    INTO disc_writeoff_auth_date
                    FROM x_fin_disc_write_off
                   WHERE dwo_lic_no = lic.lic_number;

                  IF UPPER (lic.lic_writeoff) = 'Y'
                     AND per_end_date >= disc_writeoff_auth_date
                  THEN
                     -- set the write off flag null
                     UPDATE fid_license
                        SET lic_writeoff = NULL,
                            lic_writeoff_mark = 'N',
                            lic_entry_oper = user_id,
                            lic_entry_date = SYSDATE
                      WHERE lic_number = lic.lic_number
                            AND NVL (lic_writeoff, 'N') <> 'N';
                  END IF;
               END IF;
            ELSE
               --Accounting Date in closed month
               --loop through all the secondry licensee for a license
               FOR c_lic_sec_lee IN lic_sec_lee (lic.lic_number)
               LOOP
                  --get the cumulative inventory  and cost till previous month for
                  --each licensee of a licence
                  fid_cos_pk.reverse_inventory_and_cost (
                     lic.lic_number,
                     lic.lic_currency,
                     lic.lic_acct_date,
                     c_lic_sec_lee.lsl_number,
                     c_lic_sec_lee.lsl_lee_price,
                     lic.com_ter_code,
                     period_year,
                     period_month,
                     user_id,
                     l_reval_flag);	--Dev : Fin CR: [Devashish Raverkar]_[2016/05/23]
                  --Reverse cumulative realized forex G\L till past month
                  --for each paid payment of each secondry licensee having
                  --amount greate than zero
                  fid_cos_pk.reverse_real_forex_gain_loss (
                     lic.lic_number,
                     c_lic_sec_lee.lsl_number,
                     period_year,
                     period_month,
                     user_id);
                  -- Reverse cumulative realized forex G/L till past month for each paid payment
                  -- having amount less than zero and whose payment is not settled (payment no. does not
                  --exists in refund settlements table)
                  fid_cos_pk.rev_real_forex_pay_not_settle (
                     lic.lic_number,
                     c_lic_sec_lee.lsl_number,
                     period_year,
                     period_month,
                     user_id);
               END LOOP;

               /*secondry licensee loop end */
               IF UPPER (month_end_type) = 'FINAL'
               THEN
                  --Get the discretionary write off flag
                  --and max Authorization date for license
                  SELECT MAX (dwo_auth_date)
                    INTO disc_writeoff_auth_date
                    FROM x_fin_disc_write_off
                   WHERE dwo_lic_no = lic.lic_number;

                  IF UPPER (lic.lic_writeoff) = 'Y'
                     AND per_end_date >= disc_writeoff_auth_date
                  THEN
                     -- set the write off flag null
                     UPDATE fid_license
                        SET lic_writeoff = NULL,
                            lic_writeoff_mark = 'N',
                            lic_entry_oper = user_id,
                            lic_entry_date = SYSDATE
                      WHERE lic_number = lic.lic_number
                            AND NVL (lic_writeoff, 'N') <> 'N';
                  END IF;
               END IF;

               --set the license rate to null
               --if it is not null
               IF lic_acc_value < period_value
               THEN
                  UPDATE fid_license
                     SET lic_rate = NULL,
                         --lic_start_rate = NULL,
                         lic_price_chg_flg = 'N',
                         lic_before_acct_date = 'Y',
                         -- set lic_before_acct_date to 'Y' to show reversal license in the commitment report lic_start month
                         lic_entry_oper = user_id,
                         lic_entry_date = SYSDATE
                   WHERE lic_number = lic.lic_number;
               ELSE
                  UPDATE fid_license
                     SET lic_rate = NULL,
                         lic_start_rate = NULL,
                         lic_acct_date = NULL,
                         lic_price_chg_flg = 'N',
                         lic_before_acct_date = 'Y',
                         -- set lic_before_acct_date to 'Y' to show reversal license in the commitment report lic_start month
                         lic_entry_oper = user_id,
                         lic_entry_date = SYSDATE
                   WHERE lic_number = lic.lic_number;
               END IF;
            END IF;
         ELSE
            lic_start_month := TO_NUMBER (TO_CHAR (lic.lic_start, 'MM'));
            lic_start_year := TO_NUMBER (TO_CHAR (lic.lic_start, 'YYYY'));
            discount_rate :=
               x_pkg_fin_get_spot_rate.get_discount_rate (lic_start_month,
                                                          lic_start_year);
            --calculate the discount rate for routine month
            discount_rate_prev_mth :=
               x_pkg_fin_get_spot_rate.get_discount_rate (prev_month,
                                                          prev_year);

            IF first_month = TRUE
            THEN
               --loop will get the realized forex G\L till past month
               --for each paid payment having having amount greate than
               --zero
               FOR c_lic_sec_lee IN lic_sec_lee (lic.lic_number)
               LOOP
                  --Reverse cumulative realized forex G\L till past month
                  --for each paid payment of each secondry licensee having
                  --amount greate than zero
                  fid_cos_pk.reverse_real_forex_gain_loss (
                     lic.lic_number,
                     c_lic_sec_lee.lsl_number,
                     period_year,
                     period_month,
                     user_id);
                  -- Reverse cumulative realized forex G/L till past month for each paid payment
                  -- having amount less than zero and whose payment is not settled (payment no. does not
                  --exists in refund settlements table)
                  fid_cos_pk.rev_real_forex_pay_not_settle (
                     lic.lic_number,
                     c_lic_sec_lee.lsl_number,
                     period_year,
                     period_month,
                     user_id);

                  --calculate realized forex for ed it will be calculated
                  --only on license start month
                  --need to chk lic_acct_date????
                  IF UPPER (month_end_type) = 'FINAL'
                  THEN
                     IF UPPER (NVL (con.con_ed_applicable_flag, 'N')) = 'Y'
                     THEN
                        calc_realized_forex_ed (lic.lic_number,
                                                c_lic_sec_lee.lsl_number,
                                                c_lic_sec_lee.lsl_lee_price,
                                                period_month,
                                                period_year,
                                                discount_rate,
                                                license_start_rate,
                                                forward_rate,
                                                regioncode,
                                                user_id);
                     END IF;
                  END IF;
               END LOOP;                       /*secondry licensee loop end */

               IF writeoff_lic_made_curr_month = FALSE
               THEN
                  writeoff_license := FALSE;

                  UPDATE fid_license
                     SET lic_writeoff = NULL,
                         lic_writeoff_mark = 'N',
                         lic_entry_oper = user_id,
                         lic_entry_date = SYSDATE
                   WHERE lic_number = lic.lic_number
                         AND NVL (lic_writeoff, 'N') <> 'N';
               END IF;
            END IF;

            /*First month end */

            -- Identify the Costed Schedule for the routine month
            --only for linear licenses
            IF --UPPER (lic.lic_catchup_flag) <> 'Y' --commented so that SVOD licenses will not be considered
              UPPER (NVL (lic.lic_catchup_flag, 'N')) = 'N'
               AND expired_license = FALSE
            THEN
               fid_cos_pk.identify_costed_schedules (lic.lic_number,
                                                     period_month,
                                                     period_year,
                                                     user_id);
            END IF;

            -- Get the number of Costed run from Sub Ledger table till last month
            SELECT NVL (SUM (lis_paid_exhibition), 0)
              INTO costed_run_sub_ledger_to_date
              FROM (SELECT DISTINCT lis_paid_exhibition,
                                    lis_per_month,
                                    lis_per_year,
                                    lis_lic_number
                      FROM fid_license_sub_ledger
                     WHERE lis_lic_number = lic.lic_number
                           AND lis_paid_exhibition <> 0
                           AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                                  period_value);

            --check if license is a catchup license
            IF NVL (lic.lic_catchup_flag, 'N') = 'N'
            THEN
               --get the costed schedules of current month for linear license
               SELECT COUNT (*)
                 INTO costed_schedules_curr_month
                 FROM x_fin_cost_schedules
                WHERE csh_lic_number = lic.lic_number
                      AND csh_year || LPAD (csh_month, 2, 0) =
                             period_year || LPAD (period_month, 2, 0);

               --get the costed schedules till current month for linear license
               SELECT COUNT (*)
                 INTO costed_schedules_till_curr_mth
                 FROM x_fin_cost_schedules
                WHERE csh_lic_number = lic.lic_number
                      AND csh_year || LPAD (csh_month, 2, 0) <=
                             period_year || LPAD (period_month, 2, 0);
            ELSE
               --get the costed schedules of current month for catch up license
               SELECT COUNT (*)
                 INTO costed_schedules_curr_month
                 FROM (  SELECT plt_sch_number
                           FROM x_cp_play_list
                          WHERE plt_lic_number = lic.lic_number
                                AND TRIM (plt_sch_start_date) BETWEEN per_date
                                                                  AND per_end_date
                                AND plt_sch_type = 'P'
                                AND plt_sch_number NOT IN
                                       (SELECT plt_sch_number
                                          FROM x_cp_play_list
                                         WHERE TRIM (plt_sch_start_date) <
                                                  per_date
                                               AND plt_lic_number =
                                                      lic.lic_number
                                               AND plt_sch_type = 'P'
                                               AND NVL (plt_license_flag, 'Y') =
                                                      'Y')
                       GROUP BY plt_sch_number);

               --to get the costed schedules til current month add the
               --costed schedules till previous month from sub ledger
               --to costed schedules for current month
               SELECT COUNT (*)
                 INTO costed_schedules_till_curr_mth
                 FROM (  SELECT plt_sch_number
                           FROM x_cp_play_list
                          WHERE     plt_lic_number = lic.lic_number
                                AND plt_sch_type = 'P'
                                AND TRIM (plt_sch_start_date) < per_date
                                AND NVL (plt_license_flag, 'Y') = 'Y'
                       GROUP BY plt_sch_number);

               costed_schedules_till_curr_mth :=
                  costed_schedules_till_curr_mth
                  + costed_schedules_curr_month;
            END IF;

            --calculate the inventory for each licensee of license
            --and update it in sub ledger
            --also return the lic_rate
            fid_cos_pk.calulate_inventory_for_flf (
               lic.lic_number,
               lic.com_ter_code,
               con.con_ed_applicable_flag,
               period_month,
               period_year,
               license_start_rate,
               --spot rate
               discount_rate,
               forward_rate,
               lic.lic_price_chg_flg,
               month_end_type,
               user_id,
               l_reval_flag,	--Dev : Fin CR: [Devashish Raverkar]_[2016/05/23]
               license_rate);

            FOR c_lic_sec_lee IN lic_sec_lee (lic.lic_number)
            LOOP
               --get the inventory for current month
               SELECT NVL (SUM (lis_con_forecast), 0),
                      NVL (SUM (lis_con_actual), 0),
                      NVL (SUM (lis_loc_actual), 0)
                 INTO con_forecast_curr_mth,
                      con_actual_curr_mth,
                      loc_actual_curr_mth
                 FROM fid_license_sub_ledger
                WHERE lis_lsl_number = c_lic_sec_lee.lsl_number
                      AND lis_lic_number = lic.lic_number
                      AND lis_per_year || LPAD (lis_per_month, 2, 0) =
                             period_year || LPAD (period_month, 2, 0);

               --calculate the  inventory ,pv_liability and ed forecast till current month
               SELECT NVL (SUM (lis_con_forecast), 0),
                      NVL (
                         SUM (
                              NVL (lis_con_actual, 0)
                            + NVL (lis_con_adjust, 0)
                            + NVL (lis_con_writeoff, 0)),
                         0),
                      NVL (SUM (lis_loc_forecast), 0),
                      NVL (
                         SUM (
                              NVL (lis_loc_actual, 0)
                            + NVL (lis_loc_adjust, 0)
                            + NVL (lis_loc_writeoff, 0)),
                         0),
                      NVL (SUM (lis_pv_con_forecast), 0),
                      NVL (SUM (lis_pv_loc_forecast), 0),
                      NVL (SUM (lis_ed_loc_forecast), 0),
                      NVL (SUM (lis_pv_con_liab_actual), 0),
                      NVL (SUM (lis_pv_loc_liab_actual), 0)
                 INTO con_forecast_till_curr_mth,
                      con_actual_till_curr_mth,
                      loc_forecast_till_curr_mth,
                      loc_actual_till_curr_mth,
                      pv_con_forcast_till_curr_mth,
                      pv_loc_forcast_till_curr_mth,
                      ed_loc_forecast_till_curr_mth,
                      pv_con_liability_act_till_curr,
                      pv_loc_liability_act_till_curr
                 FROM fid_license_sub_ledger
                WHERE lis_lsl_number = c_lic_sec_lee.lsl_number
                      AND lis_lic_number = lic.lic_number
                      AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                             period_year || LPAD (period_month, 2, 0);

               --calculate cost,ed cost and pv cost till previous month
               SELECT   NVL (SUM (lis_con_actual), 0)
                      + NVL (SUM (lis_con_adjust), 0)
                      + NVL (SUM (lis_con_writeoff), 0),
                        NVL (SUM (lis_loc_actual), 0)
                      + NVL (SUM (lis_loc_adjust), 0)
                      + NVL (SUM (lis_loc_writeoff), 0),
                      NVL (SUM (lis_pv_con_inv_actual), 0),
                      NVL (SUM (lis_pv_loc_inv_actual), 0),
                      NVL (SUM (lis_ed_loc_actual), 0),
                      NVL (SUM (lis_pv_con_liab_actual), 0)
                 INTO con_actual_till_lst_mth,
                      loc_actual_till_lst_mth,
                      pv_con_actual_till_lst_mth,
                      pv_loc_actual_till_lst_mth,
                      ed_loc_actual_till_lst_mth,
                      pv_con_liab_act_till_lst_mth
                 FROM fid_license_sub_ledger
                WHERE lis_lsl_number = c_lic_sec_lee.lsl_number
                      AND lis_lic_number = lic.lic_number
                      AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                             period_year || LPAD (period_month, 2, 0);

               --Intialize variables start
               con_actual := 0;
               loc_actual := 0;
               con_writeoff := 0;
               loc_writeoff := 0;
               con_unforseen := 0;
               loc_unforseen := 0;
               pv_con_inv_actual := 0;
               pv_loc_inv_actual := 0;
               ed_loc_actual := 0;
               pv_con_liab_actual := 0;
               pv_con_liab_act_till_cur_mth := 0;
               pv_loc_liab_actual := 0;
               --Intialize variables end
               --FIN21: Issue : Deduct prepayments from license price : 06/01/2014 : Hari
               l_total_prepayment_sum := 0;

               FOR c_lic_pre_payment
                  IN lic_pv_pre_payment (c_lic_sec_lee.lsl_number,
                                         lic.lic_number)
               LOOP
                  --get the refund amount for the corresponding
                  --paymnet made in fid_paymnet
                  SELECT NVL (SUM (frs_rfd_amount), 0)
                    INTO l_refund_amount
                    FROM x_fin_refund_settle
                   WHERE frs_pay_number = c_lic_pre_payment.pay_number
                         AND frs_year || LPAD (frs_month, 2, 0) <=
                                period_year || LPAD (period_month, 2, 0);

                  l_total_prepayment_sum :=
                     l_total_prepayment_sum
                     + (c_lic_pre_payment.pay_amount - l_refund_amount);
               END LOOP;

               l_total_payment_sum := 0;

               /* calculation of PV liability cost till current month start*/

               --cursor to get all the payments after license start date to
               --calculate present value
               FOR c_pv_payments
                  IN pv_payments (lic.lic_number,
                                  c_lic_sec_lee.lsl_number,
                                  lic.lic_start)
               LOOP
                  IF UPPER (c_pv_payments.pay_status) = 'P'
                  THEN
                     IF (c_pv_payments.pay_date > todate)
                        OR (c_pv_payments.pay_date IS NULL
                            AND c_pv_payments.pay_due > todate)
                     THEN
                        IF ROUND (c_pv_payments.pay_due - todate) < 0
                        THEN
                           no_of_days := 0;
                        ELSE
                           no_of_days :=
                              ROUND (c_pv_payments.pay_due - todate);
                        END IF;
                     ELSE
                        no_of_days := 0;
                     END IF;
                  ELSE
                     IF ROUND (c_pv_payments.pay_due - todate) < 0
                     THEN
                        no_of_days := 0;
                     ELSE
                        no_of_days := ROUND (c_pv_payments.pay_due - todate);
                     END IF;
                  END IF;

                  ----CR FIN21 PV calculation changes on [08/11/2013]
                  --   If (FID_COS_PK.X_Fin_Calc_Price_Value(lic.lic_number) <> 0)
                  --  Then
                  SELECT NVL (SUM (frs_rfd_amount), 0)
                    INTO l_refund_amount
                    FROM x_fin_refund_settle
                   WHERE frs_lic_number = lic.lic_number
                         AND frs_pay_number = c_pv_payments.pay_number
                         AND frs_year || LPAD (frs_month, 2, 0) <=
                                period_year || LPAD (period_month, 2, 0);

                  l_actual_pay_amount :=
                     c_pv_payments.pay_amount - (l_refund_amount);
                  l_total_payment_sum :=
                     l_total_payment_sum + l_actual_pay_amount;

                  --FIN21: Issue : Deduct prepayments from license price : 23/12/2013 : Vinayak
                  IF l_total_payment_sum >
                        (c_pv_payments.lsl_lee_price - l_total_prepayment_sum)
                  THEN
                     l_actual_payment :=
                        l_actual_pay_amount
                        - (l_total_payment_sum
                           - (c_pv_payments.lsl_lee_price
                              - l_total_prepayment_sum));

                     IF l_actual_payment < 0
                     THEN
                        l_actual_payment := 0;
                     END IF;
                  ELSE
                     l_actual_payment := l_actual_pay_amount;
                  END IF;

                  -----END CR FIN21 PV calculation changes------
                  -- pv_liability on license start month =
                  -- liability at license start date minus liability at month end of license start
                  -- Formula:-  (pay_amount/(1+disc_rate)^(pay_due-lic_start)
                  --            minus
                  --            pay_amount/(1+disc_rate)^(pay_due-month end date) )
                  pv_con_liab_act_till_cur_mth :=
                     pv_con_liab_act_till_cur_mth
                     + ROUND (
                          NVL (
                             l_actual_payment
                             / POWER (
                                  (1 + (discount_rate / 100)),
                                  ROUND (
                                     c_pv_payments.pay_due - lic.lic_start)),
                             0),
                          2)
                     - ROUND (
                          NVL (
                             l_actual_payment
                             / POWER ( (1 + (discount_rate / 100)),
                                      no_of_days),
                             0),
                          2);
               END LOOP;

               /*pv payment loop end */
               pv_con_liab_actual :=
                  pv_con_liab_act_till_cur_mth - pv_con_liab_act_till_lst_mth;
               pv_loc_liab_actual :=
                  NVL (ROUND (pv_con_liab_actual * license_rate, 2), 0);
               pv_future_payment_cnt := 0;

               BEGIN
                  SELECT COUNT (*)
                    INTO pv_future_payment_cnt
                    FROM fid_payment
                   WHERE     pay_lic_number = lic.lic_number
                         AND pay_lsl_number = c_lic_sec_lee.lsl_number
                         AND pay_due > per_end_date
                         AND NVL (pay_amount, 0) > 0
                         AND UPPER (NVL (pay_status, 'N')) = 'N';

                  IF pv_future_payment_cnt = 0
                  THEN
                     pv_con_liab_actual :=
                        pv_con_forcast_till_curr_mth
                        - pv_con_liability_act_till_curr;
                     pv_loc_liab_actual :=
                        pv_loc_forcast_till_curr_mth
                        - pv_loc_liability_act_till_curr;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;

               IF first_month = TRUE
               THEN
                  IF writeoff_lic_made_curr_month = FALSE
                  THEN
                     SELECT NVL (SUM (lis_con_writeoff), 0),
                            NVL (SUM (lis_loc_writeoff), 0)
                       INTO con_writeoff, loc_writeoff
                       FROM fid_license_sub_ledger
                      WHERE lis_lsl_number = c_lic_sec_lee.lsl_number
                            AND lis_lic_number = lic.lic_number
                            AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                                   period_year || LPAD (period_month, 2, 0);

                     con_writeoff := -ROUND (NVL (con_writeoff, 0), 2);
                     loc_writeoff := -ROUND (NVL (loc_writeoff, 0), 2);
                  END IF;
               END IF;

               --check if license is a write off license,if yes convert the remaining
               --inventory into writeoff,also cost the remaing ed and Pv inventory
               IF writeoff_license = TRUE
               THEN
                  --to cater -ve content write off when reversed
                  con_writeoff :=
                     con_writeoff
                     + (con_forecast_till_curr_mth - con_actual_till_curr_mth);
                  loc_writeoff :=
                     NVL (
                        ROUND (
                           loc_writeoff
                           + (loc_forecast_till_curr_mth
                              - loc_actual_till_curr_mth),
                           2),
                        0);
                  ed_loc_actual :=
                     ed_loc_forecast_till_curr_mth
                     - ed_loc_actual_till_lst_mth;
                  pv_con_inv_actual :=
                     pv_con_forcast_till_curr_mth
                     - pv_con_actual_till_lst_mth;
                  pv_loc_inv_actual :=
                     pv_loc_forcast_till_curr_mth
                     - pv_loc_actual_till_lst_mth;
               ELSIF expired_license = TRUE
               THEN
                  con_actual :=
                     con_forecast_till_curr_mth - con_actual_till_curr_mth;
                  loc_actual :=
                     loc_forecast_till_curr_mth - loc_actual_till_curr_mth;
                  ed_loc_actual :=
                     ed_loc_forecast_till_curr_mth
                     - ed_loc_actual_till_lst_mth;
                  pv_con_inv_actual :=
                     pv_con_forcast_till_curr_mth
                     - pv_con_actual_till_lst_mth;
                  pv_loc_inv_actual :=
                     pv_loc_forcast_till_curr_mth
                     - pv_loc_actual_till_lst_mth;
               ELSIF last_month = TRUE
               THEN
                  --Dev.R5 : SVOD Enhancements : Start : [SVOD Finance]_[Devashish Raverkar]_[2015-04-16]
                  --Calculation for amortization code A
                  IF UPPER (lic.lic_amort_code) = 'A'
                  THEN
                     con_actual :=
                        x_fin_amort_a_cost_calc (l_lic_start,
                                                 l_lic_end,
                                                 con_forecast_till_curr_mth,
                                                 period_value,
                                                 con_actual_till_lst_mth,
                                                 'con_actual');
                     loc_actual :=
                        x_fin_amort_a_cost_calc (l_lic_start,
                                                 l_lic_end,
                                                 loc_forecast_till_curr_mth,
                                                 period_value,
                                                 loc_actual_till_lst_mth,
                                                 'loc_actual');
                     pv_con_inv_actual :=
                        x_fin_amort_a_cost_calc (
                           l_lic_start,
                           l_lic_end,
                           pv_con_forcast_till_curr_mth,
                           period_value,
                           pv_con_actual_till_lst_mth,
                           'pv_con_actual');
                     pv_loc_inv_actual :=
                        x_fin_amort_a_cost_calc (
                           l_lic_start,
                           l_lic_end,
                           pv_loc_forcast_till_curr_mth,
                           period_value,
                           pv_loc_actual_till_lst_mth,
                           'pv_loc_actual');
                     ed_loc_actual :=
                        x_fin_amort_a_cost_calc (
                           l_lic_start,
                           l_lic_end,
                           ed_loc_forecast_till_curr_mth,
                           period_value,
                           ed_loc_actual_till_lst_mth,
                           'ed_loc_actual');
                  --Dev.R5 : SVOD Enhancements : End
                  ELSE
                     --check if there are still costed runs remaining in month of license end
                     remain_showings :=
                        lic.lic_showing_lic - costed_schedules_till_curr_mth;

                     --if runs remain then it should be wriiten off
                     IF remain_showings = 0
                     THEN
                        writeoff_flag := FALSE;
                     ELSE
                        writeoff_flag := TRUE;
                     END IF;

                     IF writeoff_flag = FALSE
                     THEN
                        --get the remaining inventory till last month
                        con_actual :=
                             con_forecast_till_curr_mth
                           - con_actual_till_lst_mth --Karim Ajani - 05- Aug- 2014 -  Start - Missing Scenario 1 - Updated for Issue in July 2014 month end for license no. 656065
                           --System was reverting write-off cost but was not costing for paid schedule in current month
                           --Added con_writeoff as con_writeoff for current month is calculated prior to this
                           - con_writeoff;
                        --Karim Ajani - 05- Aug- 2014 -  END - Missing Scenario 1 - Updated for Issue in July 2014 month end for license no. 656065
                        loc_actual :=
                             loc_forecast_till_curr_mth
                           - loc_actual_till_lst_mth --Karim Ajani - 05- Aug- 2014 -  Start - Missing Scenario 1 - Updated for Issue in July 2014 month end for license no. 656065
                           --System was reverting write-off cost but was not costing for paid schedule in current month
                           --Added loc_writeoff as loc_writeoff for current month is calculated prior to this
                           - loc_writeoff;

                        --Karim Ajani - 05- Aug- 2014 -  END - Missing Scenario 1 - Updated for Issue in July 2014 month end for license no. 656065
                        IF NVL (con_forecast_curr_mth, 0) = 0
                           AND UPPER (lic.lic_amort_code) <> 'C'
                        THEN
                           --calculate the cost per showings
                           --Formula := Inventory till last month/no of paid exhibition last month
                           IF costed_run_sub_ledger_to_date > 0
                           THEN
                              cost_per_showings :=
                                 NVL (
                                    ROUND (
                                       con_actual_till_lst_mth
                                       / costed_run_sub_ledger_to_date,
                                       2),
                                    0);
                           END IF;

                           --calculate the cost for showings of current month
                           --Formula:=cost of each run * no of 'P' schedule for current month
                           cost_curr_mth_showings :=
                              NVL (
                                 ROUND (
                                    cost_per_showings
                                    * costed_schedules_curr_month,
                                    2),
                                 0);
                           unforseen_cost :=
                              ABS ( (con_actual - cost_curr_mth_showings))
                              * license_rate;

                           IF unforseen_cost > TO_NUMBER (fin_unforceen_cost)
                           THEN
                              con_unforseen :=
                                 con_actual - cost_curr_mth_showings;
                              loc_unforseen := con_unforseen * license_rate;
                           END IF;
                        END IF;
                     ELSE
                        --if writeoff flag is true

                        /* --check if license price has increased in last month - TODO - Test
                         IF con_forecast_curr_mth <> 0
                         THEN
                            --get the remaining inventory till last month
                            con_actual := con_forecast_till_curr_mth - con_actual_till_lst_mth;
                            loc_actual := NVL(ROUND(con_actual * license_rate,2),0);

                         ELSE */
                        IF UPPER (lic.lic_amort_code) <> 'C'
                        THEN
                           BEGIN
                              cost_curr_mth_showings :=
                                 NVL (
                                    ROUND (
                                       (  (con_forecast_till_curr_mth)
                                        * costed_schedules_till_curr_mth
                                        / lic.lic_showing_lic)
                                       - con_actual_till_lst_mth
                                       --Karim Ajani - 05- Aug- 2014 -  Start - Missing Scenario 2 - Identified during investigation for issue that came in July 2014 month end for license no. 656065
                                       --System was reverting write-off cost in normal cost column instaed of write-off column
                                       --Added con_writeoff as con_writeoff for current month is calculated prior to this
                                       - con_writeoff,
                                       --Karim Ajani - 05- Aug- 2014 -  END - Missing Scenario 2 - Identified during investigation for issue that came in July 2014 month end for license no. 656065
                                       2),
                                    0);
                              con_actual := cost_curr_mth_showings;
                              loc_actual :=
                                 NVL (
                                    ROUND (
                                       (  (loc_forecast_till_curr_mth)
                                        * costed_schedules_till_curr_mth
                                        / lic.lic_showing_lic)
                                       - loc_actual_till_lst_mth
                                       --Karim Ajani - 05- Aug- 2014 -  Start - Missing Scenario 2 - Identified during investigation for issue that came in July 2014 month end for license no. 656065
                                       --System was reverting write-off cost in normal cost column instaed of write-off column
                                       --Added con_writeoff as con_writeoff for current month is calculated prior to this
                                       - loc_writeoff,
                                       --Karim Ajani - 05- Aug- 2014 -  END - Missing Scenario 2 - Identified during investigation for issue that came in July 2014 month end for license no. 656065
                                       2),
                                    0);
                           EXCEPTION
                              WHEN OTHERS
                              THEN
                                 cost_curr_mth_showings := 0;
                                 con_actual := 0;
                                 loc_actual := 0;
                           END;

                           con_writeoff :=
                              ROUND (
                                 con_writeoff
                                 + (con_forecast_till_curr_mth
                                    - (  con_actual_till_lst_mth
                                       + cost_curr_mth_showings
                                       --Karim Ajani - 05- Aug- 2014 -  Start - Missing Scenario 2 - Identified during investigation for issue that came in July 2014 month end for license no. 656065
                                       --System was reverting write-off cost but was not costing for paid schedule in current month
                                       --Added loc_writeoff as loc_writeoff for current month is calculated prior to this
                                       + con_writeoff --Karim Ajani - 05- Aug- 2014 -  END - Missing Scenario 2 - Identified during investigation for issue that came in July 2014 month end for license no. 656065
                                                     )),
                                 2);
                           loc_writeoff :=
                              ROUND (
                                 NVL (
                                    loc_writeoff
                                    + (loc_forecast_till_curr_mth
                                       - (  loc_actual_till_curr_mth
                                          + loc_actual --Karim Ajani - 05- Aug- 2014 -  Start - Missing Scenario 2 - Identified during investigation for issue that came in July 2014 month end for license no. 656065
                                          --System was reverting write-off cost but was not costing for paid schedule in current month
                                          --Added loc_writeoff as loc_writeoff for current month is calculated prior to this
                                          + loc_writeoff --Karim Ajani - 05- Aug- 2014 -  END - Missing Scenario 2 - Identified during investigation for issue that came in July 2014 month end for license no. 656065
                                                        )),
                                    0),
                                 2);
                        ELSE
                           con_writeoff :=
                              ROUND (
                                 NVL (
                                    con_writeoff
                                    + (con_forecast_till_curr_mth
                                       - con_actual_till_curr_mth),
                                    0),
                                 2);
                           loc_writeoff :=
                              ROUND (
                                 NVL (
                                    loc_writeoff
                                    + (loc_forecast_till_curr_mth
                                       - loc_actual_till_curr_mth),
                                    0),
                                 2);
                        END IF;
                     END IF;

                     ed_loc_actual :=
                        ed_loc_forecast_till_curr_mth
                        - ed_loc_actual_till_lst_mth;
                     pv_con_inv_actual :=
                        pv_con_forcast_till_curr_mth
                        - pv_con_actual_till_lst_mth;
                     pv_loc_inv_actual :=
                        pv_loc_forcast_till_curr_mth
                        - pv_loc_actual_till_lst_mth;
                  END IF;
               ELSE
                  --calculate the cost for  current month showings
                  IF UPPER (lic.lic_amort_code) <> 'C'
                  THEN
                     BEGIN
                        --Dev.R5 : SVOD Enhancements : Start : [SVOD Finance]_[Shubhada Bongarde]_[2015-04-14]
                        --Calculation for amortization code A
                        IF UPPER (lic.lic_amort_code) = 'A'
                        THEN
                           con_actual :=
                              x_fin_amort_a_cost_calc (
                                 l_lic_start,
                                 l_lic_end,
                                 con_forecast_till_curr_mth,
                                 period_value,
                                 con_actual_till_lst_mth,
                                 'con_actual');
                           loc_actual :=
                              x_fin_amort_a_cost_calc (
                                 l_lic_start,
                                 l_lic_end,
                                 loc_forecast_till_curr_mth,
                                 period_value,
                                 loc_actual_till_lst_mth,
                                 'loc_actual');
                           pv_con_inv_actual :=
                              x_fin_amort_a_cost_calc (
                                 l_lic_start,
                                 l_lic_end,
                                 pv_con_forcast_till_curr_mth,
                                 period_value,
                                 pv_con_actual_till_lst_mth,
                                 'pv_con_actual');
                           pv_loc_inv_actual :=
                              x_fin_amort_a_cost_calc (
                                 l_lic_start,
                                 l_lic_end,
                                 pv_loc_forcast_till_curr_mth,
                                 period_value,
                                 pv_loc_actual_till_lst_mth,
                                 'pv_loc_actual');
                           ed_loc_actual :=
                              x_fin_amort_a_cost_calc (
                                 l_lic_start,
                                 l_lic_end,
                                 ed_loc_forecast_till_curr_mth,
                                 period_value,
                                 ed_loc_actual_till_lst_mth,
                                 'ed_loc_actual');
                        --Dev.R5 : SVOD Enhancements : End
                        ELSE
                           IF first_month = TRUE
                           THEN
                              con_actual :=
                                 NVL (
                                    ROUND (
                                       con_forecast_till_curr_mth
                                       * (costed_schedules_till_curr_mth
                                          / lic.lic_showing_lic)
                                       - con_actual_till_lst_mth
                                       - con_writeoff,
                                       2),
                                    0);
                              loc_actual :=
                                 NVL (
                                    ROUND (
                                       loc_forecast_till_curr_mth
                                       * (costed_schedules_till_curr_mth
                                          / lic.lic_showing_lic)
                                       - loc_actual_till_lst_mth
                                       - loc_writeoff,
                                       2),
                                    0);
                           ELSE
                              con_actual :=
                                 NVL (
                                    ROUND (
                                       con_forecast_till_curr_mth
                                       * (costed_schedules_till_curr_mth
                                          / lic.lic_showing_lic)
                                       - con_actual_till_lst_mth,
                                       2),
                                    0);
                              loc_actual :=
                                 NVL (
                                    ROUND (
                                       loc_forecast_till_curr_mth
                                       * (costed_schedules_till_curr_mth
                                          / lic.lic_showing_lic)
                                       - loc_actual_till_lst_mth,
                                       2),
                                    0);
                           END IF;

                           --calculate the local cost for current month showings
                           /* loc_actual :=
                                       NVL (ROUND (con_actual * license_rate, 2), 0);*/
                           --calculate the pv inventory cost for cuurent month showings
                           pv_con_inv_actual :=
                              NVL (
                                 ROUND (
                                    pv_con_forcast_till_curr_mth
                                    * (costed_schedules_till_curr_mth
                                       / lic.lic_showing_lic)
                                    - pv_con_actual_till_lst_mth,
                                    2),
                                 0);
                           --calculate the local pv inventory cost for cuurent month showings
                           /*pv_loc_inv_actual :=
                                nvl (round (pv_con_inv_actual * license_rate, 2), 0);*/
                           pv_loc_inv_actual :=
                              NVL (
                                 ROUND (
                                    pv_loc_forcast_till_curr_mth
                                    * (costed_schedules_till_curr_mth
                                       / lic.lic_showing_lic)
                                    - pv_loc_actual_till_lst_mth,
                                    2),
                                 0);
                           --calculate the local ed cost for cuurent month showings
                           ed_loc_actual :=
                              NVL (
                                 ROUND (
                                    ed_loc_forecast_till_curr_mth
                                    * (costed_schedules_till_curr_mth
                                       / lic.lic_showing_lic)
                                    - ed_loc_actual_till_lst_mth,
                                    2),
                                 0);
                        END IF;
                     --exception handle when lic_showing_lic is zero
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           pv_con_inv_actual := 0;
                           pv_loc_inv_actual := 0;
                           ed_loc_actual := 0;
                           loc_actual := 0;
                           con_actual := 0;
                     END;
                  ELSE
                     BEGIN
                        pv_con_inv_actual :=
                           NVL (
                              ROUND (
                                 ( (con_actual_curr_mth
                                    / c_lic_sec_lee.lsl_lee_price)
                                  * pv_con_forcast_till_curr_mth),
                                 2),
                              0);
                        pv_loc_inv_actual :=
                           NVL (
                              ROUND (
                                 ( (loc_actual_curr_mth
                                    / c_lic_sec_lee.lsl_lee_price)
                                  * pv_loc_forcast_till_curr_mth),
                                 2),
                              0);
                        --calculate the local ed cost for cuurent month showings
                        ed_loc_actual :=
                           NVL (
                              ROUND (
                                 ( (loc_actual_curr_mth
                                    / c_lic_sec_lee.lsl_lee_price)
                                  * ed_loc_forecast_till_curr_mth),
                                 2),
                              0);
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           pv_con_inv_actual := 0;
                           pv_loc_inv_actual := 0;
                           ed_loc_actual := 0;
                     END;
                  END IF;
               END IF;

               --27Mar2015:Ver 0.2 START P1 Issue : Jawahar Garg - con_forecast is not updating after costing routine run in case of 'C'
               BEGIN
                  SELECT *
                    INTO v_lic_sub_ledger_rec
                    FROM fid_license_sub_ledger
                   WHERE     lis_lic_number = lic.lic_number
                         AND lis_lsl_number = c_lic_sec_lee.lsl_number
                         AND lis_ter_code = lic.com_ter_code
                         AND lis_per_year = period_year
                         AND lis_per_month = period_month;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_lic_sub_ledger_rec.lis_ed_loc_forecast := 0;
                     v_lic_sub_ledger_rec.lis_pv_con_forecast := 0;
                     v_lic_sub_ledger_rec.lis_pv_loc_forecast := 0;
                     v_lic_sub_ledger_rec.lis_con_forecast := 0;
                     v_lic_sub_ledger_rec.lis_price := 0;
                     v_lic_sub_ledger_rec.lis_loc_forecast := 0;
               END;

               --27Mar2015 Ver 0.2 END;
               
               --Finance Dev Phase I Zeshan [Start]
               l_lis_con_pay := 0;
               l_lis_loc_pay := 0;
               l_lis_pay_mov_flag := 'N';
                
               x_prc_get_lic_mvmt_data(lic.lic_number,c_lic_sec_lee.lsl_number,l_old_lic_start,l_lis_con_pay,l_lis_loc_pay,l_lis_pay_mov_flag);
               --Finance Dev Phase I [End]
               
               --update the content,ed, pv cost and pv liability in subledger
               fid_cos_pk.insert_update_sub_ledger (
                  lic.lic_number,
                  c_lic_sec_lee.lsl_number,
                  lic.com_ter_code,
                  period_year,
                  period_month,
                  v_lic_sub_ledger_rec.lis_price, --0,--lic_price                /*ver 0.2 commented 0 and added actual value*/
                  1,                                           --adjust factor
                  0,                                                --lic_rate
                  license_start_rate,
                  costed_schedules_curr_month,
                  --paid exhibition
                  v_lic_sub_ledger_rec.lis_con_forecast, --0,--con_forecast           /*ver 0.2 commented 0 and added actual value*/
                  v_lic_sub_ledger_rec.lis_loc_forecast, --0,--loc_forecast          /*ver 0.2 commented 0 and added actual value*/
                  0,                                                --con_calc
                  0,                                                --loc_calc
                  con_actual,
                  loc_actual,
                  0,                                              --con_adjust
                  0,                                              --loc_adjust
                  con_writeoff,
                  loc_writeoff,
                  v_lic_sub_ledger_rec.lis_pv_con_forecast, --0,--pv_con_forecast      /*ver 0.2 commented 0 and added actual value*/
                  v_lic_sub_ledger_rec.lis_pv_loc_forecast, --0,--pv_loc_forecast      /*ver 0.2 commented 0 and added actual value*/
                  pv_con_inv_actual,
                  pv_con_liab_actual,
                  pv_loc_inv_actual,
                  --pv_loc_inv_actual
                  pv_loc_liab_actual,
                  --pv_loc_liability_actual
                  v_lic_sub_ledger_rec.lis_ed_loc_forecast, --0,--ed_loc_forecast     /*ver 0.2 commented 0 and added actual value*/
                  ed_loc_actual,
                  con_unforseen,
                  loc_unforseen,
                  --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                  v_lic_sub_ledger_rec.LIS_ASSET_ADJ_VALUE, --Revaluation value for every month in case of minimum gurantee
                  lic.lic_start,
                  lic.lic_end,
                  v_lic_sub_ledger_rec.lis_mean_subscriber,
                  v_lic_sub_ledger_rec.LIS_MG_PV_CON_FORECAST, --pv mg con inventory against mg payments
                  v_lic_sub_ledger_rec.LIS_MG_PV_LOC_FORECAST, --pv mg loc inventory against mg payments
                  v_lic_sub_ledger_rec.LIS_loc_ASSET_ADJ_VALUE, --Loc Revaluation value for every month in case of minimum gurantee
                  v_lic_sub_ledger_rec.LIS_MG_PV_CON_LIAB, --pv mg con liab against mg payments
                  v_lic_sub_ledger_rec.LIS_MG_PV_LOC_LIAB, --pv mg loc lilab against mg payments
                  user_id,
                  l_reval_flag, 	--Dev : Fin CR: [Devashish Raverkar]_[2016/05/23]
                  --Finance Dev Phase I Zeshan [Start]
                  lic.lic_currency,
                  ccomnumber,
                  lic.lic_status,
                  l_lis_pay_mov_flag,
                  l_lis_con_pay,
                  l_lis_loc_pay
                  --Finance Dev Phase I [End]
                  );

               IF UPPER (month_end_type) = 'FINAL'
               THEN
                  -- Calculate the un-realized forex gain(loss) for Content and PV
                  fid_cos_pk.calc_unrealized_forex_con_pv (
                     lic.lic_number,
                     c_lic_sec_lee.lsl_number,
                     period_month,
                     period_year,
                     license_start_rate,
                     mth_end_date_rate,
                     todate,
                     user_id);
                  -- Calculate the realized forex gain(loss) for Content and PV
                  fid_cos_pk.calculate_realized_forex (
                     lic.lic_number,
                     c_lic_sec_lee.lsl_number,
                     period_month,
                     period_year,
                     from_date,
                     todate,
                     user_id);
               END IF;
            END LOOP;
         /*secondry licensee loop end*/
         END IF;
      END LOOP;                                      /* End of License Loop */

      CLOSE con_c;
   END calculate_fin_amortisation;

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to calculate inventory for each license
   PROCEDURE calulate_inventory_for_flf (
      i_lic_number           IN     NUMBER,
      i_ter_cur_code         IN     VARCHAR2,
      i_is_ed_applicable     IN     VARCHAR2,
      i_curr_month           IN     NUMBER,
      i_curr_year            IN     NUMBER,
      i_license_start_rate   IN     NUMBER,
      i_disc_rate            IN     NUMBER,
      i_forward_rate         IN     NUMBER,
      i_lic_price_chg_flag   IN     VARCHAR2,
      i_month_end_type       IN     VARCHAR2,
      i_entry_oper           IN     VARCHAR2,
      --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/24]
      i_reval_flag           IN     fid_license_sub_ledger.lis_reval_flag%TYPE,
      --Dev : Fin CR : End
      o_lic_rate                OUT NUMBER)
   IS
      --Loop for All the prepayments for License
      --before license start date
      CURSOR lic_pre_payment (
         l_lsl_number    NUMBER,
         l_lic_number    NUMBER)
      IS
         SELECT pay_number,
                pay_amount,
                pay_rate,
                lic_currency,
                PAY_DATE
           FROM fid_payment, fid_license                 --, x_fin_lic_sec_lee
          WHERE     pay_lic_number = lic_number
                AND pay_lsl_number = l_lsl_number
                --AND pay_lsl_number = l_lsl_number
                AND pay_lic_number = l_lic_number
                AND lic_acct_date <= lic_start
                AND pay_date < lic_start
                AND pay_amount > 0
                AND UPPER (pay_status) = 'P'
         UNION
         ---- Changes added to check pre-payments for a license during inventory calculation when acct date greater than lic start date
         SELECT pay_number,
                pay_amount,
                pay_rate,
                lic_currency,
                PAY_DATE
           FROM fid_payment, fid_license                 --, x_fin_lic_sec_lee
          WHERE     pay_lic_number = lic_number
                AND pay_lsl_number = l_lsl_number
                --AND pay_lsl_number = l_lsl_number
                AND pay_lic_number = l_lic_number
                AND lic_acct_date > lic_start
                AND pay_date < lic_acct_date
                AND pay_amount > 0
                AND UPPER (pay_status) = 'P'
         ORDER BY PAY_DATE DESC;

      --Loop for all the paymnets made after license
      --start date for calculation of Present values
      CURSOR lic_pv_payments (
         l_lsl_number    NUMBER,
         l_lic_number    NUMBER)
      IS
         SELECT lic_start,
                lic_price,
                NVL (pay_amount, 0) pay_amount,
                pay_due,
                lsl_lee_price,
                pay_number
           FROM fid_payment, fid_license, x_fin_lic_sec_lee
          WHERE     lic_number = pay_lic_number
                AND pay_lsl_number = lsl_number                 --l_lsl_number
                AND pay_amount > 0
                AND pay_lic_number = lsl_lic_number             --l_lic_number
                AND lsl_number = l_lsl_number
                AND lsl_lic_number = l_lic_number
                AND pay_due > lic_start
                AND NVL (pay_date, '31-DEC-2199') >= lic_start;

      --loop for all the secondry license
      CURSOR lic_sec_lee (l_lic_number NUMBER)
      IS
         SELECT lsl_number,
                lic_start,
                lic_currency,
                lic_price,
                lsl_lee_price
           FROM fid_license, x_fin_lic_sec_lee
          WHERE lic_number = lsl_lic_number AND lic_number = l_lic_number;

      CURSOR license_pv_pre_payments (
         l_lsl_number    NUMBER,
         l_lic_number    NUMBER)
      IS
         SELECT pay_number,
                pay_amount,
                pay_rate,
                lic_currency
           FROM fid_payment, fid_license
          WHERE     pay_lic_number = lic_number
                AND pay_lsl_number = l_lsl_number
                AND pay_lic_number = l_lic_number
                AND ( (NVL (pay_date, '31-dec-2199') < lic_start)
                     OR (pay_due < lic_start))
                AND pay_amount > 0;
      
      l_rfd_sett                     NUMBER;
      l_temp_pre_pay_amount          NUMBER;
      l_init_con_forecast            NUMBER;
      l_init_loc_forecast            NUMBER;
      l_con_forecast                 NUMBER;
      l_loc_forcast                  NUMBER;
      l_pre_pay_amount               NUMBER;
      l_loc_pre_pay_amount           NUMBER;
      l_con_forecast_till_prev_mth   NUMBER;
      l_loc_forecast_till_prev_mth   NUMBER;
      l_pv_con_fore_till_prev_mth    NUMBER;
      l_lis_rate                     NUMBER;
      l_ed_asset                     NUMBER;
      l_lic_rate                     NUMBER;
      l_ed_loc_forecast              NUMBER;
      l_ed_loc_fore_till_prev_mth    NUMBER;
      l_ed_no_of_days                NUMBER;
      l_pv_no_of_days                NUMBER;
      l_dsl_ed_asset                 NUMBER;
      l_pv_con_forecast              NUMBER;
      l_pv_loc_forecast              NUMBER;
      l_previous_month               NUMBER;
      l_previous_year                NUMBER;
      l_lic_currency                 VARCHAR2 (3);
      l_total_payment_sum            NUMBER;
      l_refund_amount                NUMBER;
      l_transfer_amount              NUMBER;
      l_actual_pay_amount            NUMBER;
      l_extra_payment                NUMBER;
      l_pay_amount_adjusted          NUMBER;
      l_actual_payment               NUMBER;
      l_total_prepayment_sum         NUMBER;
      l_lic_start                    DATE;
      l_lic_end                      DATE;
      --Finance Dev Phase I Zeshan [Start]
      l_lis_con_pay                    fid_license_sub_ledger.lis_con_pay%TYPE;
      l_lis_loc_pay                    fid_license_sub_ledger.lis_loc_pay%TYPE;
      l_lis_pay_mov_flag               fid_license_sub_ledger.lis_pay_mov_flag%TYPE;
      l_lis_lic_com_number             fid_license_sub_ledger.lis_lic_com_number%TYPE;
      l_lis_lic_status                 fid_license_sub_ledger.lis_lic_status%TYPE;
      l_old_lic_start                  fid_license_sub_ledger.lis_lic_start%TYPE;
      --Finance Dev Phase I [End]          
   BEGIN
      l_pre_pay_amount := 0;
      l_loc_pre_pay_amount := 0;
      l_init_con_forecast := 0;
      l_pv_con_forecast := 0;
      l_ed_loc_forecast := 0;
      l_pv_con_fore_till_prev_mth := 0;
      l_total_payment_sum := 0;
      --FIN21: Issue : Deduct prepayments from license price : 23/12/2013 : Vinayak
      l_total_prepayment_sum := 0;

      IF i_curr_month = 1
      THEN
         l_previous_month := 12;
         l_previous_year := i_curr_year - 1;
      ELSE
         l_previous_month := i_curr_month - 1;
         l_previous_year := i_curr_year;
      END IF;
      
      --Finance Dev Phase I Zeshan [Start]
      SELECT lic_currency, lic_start, lic_end, con_com_number, lic_status
        INTO l_lic_currency, l_lic_start, l_lic_end, l_lis_lic_com_number, l_lis_lic_status
        FROM fid_license, fid_contract
       WHERE lic_con_number = con_number
         AND lic_number = i_lic_number;
      
      BEGIN
          SELECT lis_lic_start
            INTO l_old_lic_start
            FROM fid_license_sub_ledger
           WHERE lis_lic_number = i_lic_number
             AND lis_per_year || lpad(lis_per_month, 2, 0) = 
                  TO_CHAR (ADD_MONTHS ((TO_DATE ( '01' || TO_CHAR (i_curr_month, '09') || TO_CHAR (i_curr_year), 'DDMMYYYY')), -1), 'YYYYMM')
             AND ROWNUM < 2;
          EXCEPTION
            WHEN no_data_found
            THEN
              l_old_lic_start := l_lic_start;
      END;
      --Finance Dev Phase I [End]
      
      --Loop for each secondry licensee for a license
      FOR c_lic_sec_lee IN lic_sec_lee (i_lic_number)
      LOOP
         l_pre_pay_amount := 0;
         l_loc_pre_pay_amount := 0;
         l_pv_con_forecast := 0;
         l_ed_loc_forecast := 0;
         l_pv_loc_forecast := 0;

         --Loop through all the prepayments for the license before
         --license start  date
         FOR c_lic_pre_payment
            IN lic_pre_payment (c_lic_sec_lee.lsl_number, i_lic_number)
         LOOP
            --get the refund amount for the corresponding
            --paymnet made in fid_paymnet
            SELECT NVL (SUM (frs_rfd_amount), 0)
              INTO l_rfd_sett
              FROM x_fin_refund_settle
             WHERE frs_pay_number = c_lic_pre_payment.pay_number;

            --Adjustment done for negative payment
            IF c_lic_pre_payment.pay_amount >= 0
            THEN
               l_temp_pre_pay_amount :=
                  c_lic_pre_payment.pay_amount - l_rfd_sett;
            ELSE
               --Add the refund amount if payment done is -ve
               l_temp_pre_pay_amount :=
                  c_lic_pre_payment.pay_amount + l_rfd_sett;
            END IF;

            IF c_lic_sec_lee.lsl_lee_price >=
                  (l_pre_pay_amount + l_temp_pre_pay_amount)
            THEN
               --Calculated the prepaymnet made for each licensee of license
               --in contract currency
               l_pre_pay_amount := l_pre_pay_amount + l_temp_pre_pay_amount;
            ELSE
               l_temp_pre_pay_amount :=
                  c_lic_sec_lee.lsl_lee_price - l_pre_pay_amount;
               l_pre_pay_amount :=
                  l_pre_pay_amount
                  + (c_lic_sec_lee.lsl_lee_price - l_pre_pay_amount);
            END IF;

            --Calculated the prepaymnet made for each licensee of license
            --in local currency
            IF UPPER (i_month_end_type) = 'FINAL'
            THEN
               l_loc_pre_pay_amount :=
                  l_loc_pre_pay_amount
                  + l_temp_pre_pay_amount * c_lic_pre_payment.pay_rate;
            ELSE
               l_loc_pre_pay_amount :=
                  l_loc_pre_pay_amount
                  + l_temp_pre_pay_amount
                    * NVL (c_lic_pre_payment.pay_rate, i_license_start_rate);
            END IF;
         END LOOP;

         l_init_con_forecast := c_lic_sec_lee.lsl_lee_price - l_pre_pay_amount;
         l_init_loc_forecast :=
            l_init_con_forecast * i_license_start_rate + l_loc_pre_pay_amount;

         --get the no of costed runs till previous month from Subledger
         SELECT NVL (SUM (lis_con_forecast), 0),
                NVL (SUM (lis_loc_forecast), 0),
                NVL (SUM (lis_pv_con_forecast), 0),
                NVL (SUM (lis_ed_loc_forecast), 0)
           INTO l_con_forecast_till_prev_mth,
                l_loc_forecast_till_prev_mth,
                l_pv_con_fore_till_prev_mth,
                l_ed_loc_fore_till_prev_mth
           FROM fid_license_sub_ledger
          WHERE lis_lsl_number = c_lic_sec_lee.lsl_number
                AND lis_lic_number = i_lic_number
                AND CONCAT (lis_per_year, LPAD (lis_per_month, 2, 0)) <=
                       CONCAT (l_previous_year,
                               LPAD (l_previous_month, 2, 0));

         l_con_forecast :=
            NVL (c_lic_sec_lee.lsl_lee_price - l_con_forecast_till_prev_mth,
                 0);
         l_loc_forcast :=
            NVL (l_init_loc_forecast - l_loc_forecast_till_prev_mth, 0);

         -----------ED CAlCULATION START------------------------------------
         --Calculated Ed asset/Inventory on license start
         --Formulae :=  (Licensee Price - Prepaymnet)*(spot rate - forward rate)
         --calculate ed inventory only for contract where ed is applicable
         IF NVL (UPPER (i_is_ed_applicable), 'N') = 'Y'
         THEN
            l_ed_loc_forecast :=
               (c_lic_sec_lee.lsl_lee_price - l_pre_pay_amount)
               * (i_license_start_rate - i_forward_rate);
         END IF;

         l_ed_loc_forecast := l_ed_loc_forecast + l_ed_loc_fore_till_prev_mth;
         -----------ED CAlCULATION END--------------------------------------

         ------------PV CAlCULATION START------------------------------------
         --For Present Value Calculation Loop for all the payments made
         --after license start date
         --FIN21: Issue : Deduct prepayments from license price : 23/12/2013 : Vinayak
         l_total_prepayment_sum := 0;

         FOR c_lic_pv_pre_payment
            IN license_pv_pre_payments (c_lic_sec_lee.lsl_number,
                                        i_lic_number)
         LOOP
            --get the refund amount for the corresponding
            --paymnet made in fid_paymnet
            SELECT NVL (SUM (frs_rfd_amount), 0)
              INTO l_rfd_sett
              FROM x_fin_refund_settle
             WHERE frs_pay_number = c_lic_pv_pre_payment.pay_number
                   AND frs_year || LPAD (frs_month, 2, 0) <=
                          i_curr_year || LPAD (i_curr_month, 2, 0);

            l_total_prepayment_sum :=
               l_total_prepayment_sum
               + (c_lic_pv_pre_payment.pay_amount - l_rfd_sett);
         END LOOP;

         l_total_payment_sum := 0;

         FOR c_lic_pv_payments
            IN lic_pv_payments (c_lic_sec_lee.lsl_number, i_lic_number)
         LOOP
            --  If (FID_COS_PK.X_Fin_Calc_Price_Value(I_Lic_Number) <> 0)
            -- Then
            SELECT NVL (SUM (frs_rfd_amount), 0)
              INTO l_refund_amount
              FROM x_fin_refund_settle
             WHERE frs_lic_number = i_lic_number
                   AND frs_pay_number = c_lic_pv_payments.pay_number
                   AND frs_year || LPAD (frs_month, 2, 0) <=
                          i_curr_year || LPAD (i_curr_month, 2, 0);

            l_actual_pay_amount :=
               c_lic_pv_payments.pay_amount - (l_refund_amount);
            l_total_payment_sum := l_total_payment_sum + l_actual_pay_amount;

            --FIN21: Issue : Deduct prepayments from license price : 23/12/2013 : Vinayak
            IF l_total_payment_sum >
                  (c_lic_pv_payments.lsl_lee_price - l_total_prepayment_sum)
            THEN
               l_actual_payment :=
                  l_actual_pay_amount
                  - (l_total_payment_sum
                     - (c_lic_pv_payments.lsl_lee_price
                        - l_total_prepayment_sum));

               IF l_actual_payment < 0
               THEN
                  l_actual_payment := 0;
               END IF;
            ELSE
               l_actual_payment := l_actual_pay_amount;
            END IF;

            --calculate the number of days for the payment from license start date
            --Formula:= Lic_start - payment due date
            l_pv_no_of_days :=
               c_lic_pv_payments.pay_due - c_lic_pv_payments.lic_start;
            --calculate the PV inventory for current payment and add it
            --to the prev payments with status 'P' or 'N' after license start date
            --Formula= payment amount - (payment Amount/(1+discount rate)^no_of_days)
            l_pv_con_forecast :=
               l_pv_con_forecast
               + ROUND (
                    NVL (
                       (l_actual_payment
                        - (l_actual_payment
                           / POWER (1 + (i_disc_rate / 100), l_pv_no_of_days))),
                       0),
                    2);
         END LOOP;

         IF l_pv_con_fore_till_prev_mth != 0
         THEN
            l_pv_con_forecast :=
               l_pv_con_forecast + l_pv_con_fore_till_prev_mth;
         END IF;

         -- l_pv_con_forecast:=l_pv_con_forecast + l_pv_con_fore_till_prev_mth;
         l_pv_loc_forecast := l_pv_con_forecast * i_license_start_rate;

         --to handle divide by zero exception
         IF l_con_forecast > 0
         THEN
            l_lis_rate :=
               ROUND (NVL ( (l_loc_forcast / l_con_forecast), 0), 4);
         ELSE
            IF     l_con_forecast = 0
               AND l_loc_forcast = 0
               AND UPPER (l_lic_currency) = UPPER ('USD')
            THEN
               l_lis_rate := i_license_start_rate;
            ELSIF     l_con_forecast = 0
                  AND l_loc_forcast = 0
                  AND UPPER (l_lic_currency) = UPPER ('ZAR')
            THEN
               l_lis_rate := i_license_start_rate;
            ELSE
               l_lis_rate := 0;
            END IF;
         END IF;
         
         --Finance Dev Phase I Zeshan [Start]
         l_lis_con_pay := 0;
         l_lis_loc_pay := 0;
         l_lis_pay_mov_flag := 'N';
         
         x_prc_get_lic_mvmt_data(i_lic_number,c_lic_sec_lee.lsl_number,l_old_lic_start,l_lis_con_pay,l_lis_loc_pay,l_lis_pay_mov_flag);
         --Finance Dev Phase I [End]
         
         insert_update_sub_ledger (i_lic_number,
                                   c_lic_sec_lee.lsl_number,
                                   i_ter_cur_code,
                                   i_curr_year,
                                   i_curr_month,
                                   c_lic_sec_lee.lsl_lee_price,
                                   1,                          --adjust factor
                                   l_lis_rate,
                                   i_license_start_rate,
                                   0,                        --paid exhibition
                                   ROUND (l_con_forecast, 4),
                                   ROUND (l_loc_forcast, 4),
                                   0,                               --con_calc
                                   0,                               --loc_calc
                                   0,                             --con_actual
                                   0,                             --loc_actual
                                   0,                             --con_adjust
                                   0,                             --loc_adjust
                                   0,                           --con_writeoff
                                   0,                           --loc_writeoff
                                   -ROUND (l_pv_con_forecast, 4),
                                   -ROUND (l_pv_loc_forecast, 4),
                                   0,                      --pv_con_inv_actual
                                   0,                     --pv_con_liab_actual
                                   0,                      --pv_loc_inv_actual
                                   0,                     --pv_loc_liab_actual
                                   -ROUND (l_ed_loc_forecast, 4),
                                   0,                          --ed_loc_actual
                                   0,                          --con_unforseen
                                   0,                          --loc_unforseen
                                   --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                                   0, --Revaluation  value for every month in case of minumun gurantee
                                   l_lic_start,
                                   l_lic_end,
                                   0,                        --Mean subscriber
                                   0, --pv mg con inventory against mg payment
                                   0, --pv mg loc inventory against mg payment
                                   0, --Loc Revaluation  value for every month in case of minumun gurantee
                                   0,            --pv con liab for mg payments
                                   0,            --pv loc liab for mg payments
                                   i_entry_oper,
                                   i_reval_flag, --Dev : Fin CR: [Devashish Raverkar]_[2016/05/23]
                                   --Finance Dev Phase I Zeshan [Start]
                                   l_lic_currency,
                                   l_lis_lic_com_number,
                                   l_lis_lic_status,
                                   l_lis_pay_mov_flag,
                                   l_lis_con_pay,
                                   l_lis_loc_pay
                                   --Finance Dev Phase I [End]
                                   );
      -----------PV CAlCULATION END--------------------------------------
      END LOOP;

      SELECT NVL (SUM (lis_con_forecast), 0), NVL (SUM (lis_loc_forecast), 0)
        INTO l_con_forecast, l_loc_forcast
        FROM fid_license_sub_ledger
       WHERE lis_lic_number = i_lic_number
             AND CONCAT (lis_per_year, LPAD (lis_per_month, 2, 0)) <=
                    CONCAT (i_curr_year, LPAD (i_curr_month, 2, 0));

      BEGIN
         l_lic_rate := ROUND (NVL ( (l_loc_forcast / l_con_forecast), 0), 4);
      EXCEPTION
         WHEN OTHERS
         THEN
            IF l_con_forecast = 0 AND UPPER (l_lic_currency) = UPPER ('USD')
            THEN
               l_lic_rate := i_license_start_rate;
            ELSIF l_con_forecast = 0
                  AND UPPER (l_lic_currency) = UPPER ('ZAR')
            THEN
               l_lic_rate := i_license_start_rate;
            END IF;
      END;

      o_lic_rate := l_lic_rate;

      --update the license rate and license start rate of
      --license
      UPDATE fid_license
         SET lic_rate = l_lic_rate,
             lic_start_rate = i_license_start_rate,
             lic_entry_oper = i_entry_oper,
             lic_entry_date = SYSDATE
       WHERE lic_number = i_lic_number;
   END calulate_inventory_for_flf;

   -- Pure Finance: Mangesh : 10-Jul-2013 : Procedure added to check the spot,forward and discount rate before running the Costing routine
   PROCEDURE chk_spot_rate_avail (first_date_of_month   IN DATE,
                                  last_date_of_month    IN DATE,
                                  i_month               IN NUMBER,
                                  i_year                IN NUMBER,
                                  i_month_end_type      IN VARCHAR2,
                                  i_region              IN VARCHAR2,
                                  from_date             IN DATE,
                                  todate                IN DATE)
   AS
      o_spot                         NUMBER;
      -- #region - Abhinay_15Apr2014: FIN22-Non-use case - Date indication in Costing Routine Failure Mail
      o_holiday                      NUMBER;
      -- #region - Abhinay_15Apr2014: FIN22-Non-use case - Date indication in Costing Routine Failure Mail
      employee_rec                   NUMBER;
      -- #region - Abhinay_15Apr2014: FIN22-Non-use case - Date indication in Costing Routine Failure Mail
      per_month                      NUMBER;
      per_year                       NUMBER;
      no_of_holidays_in_month        NUMBER;
      no_of_sundays_in_month         NUMBER;
      no_of_days_in_month            NUMBER;
      no_of_days_aval                NUMBER;
      no_of_days_inv_aval            NUMBER;
      eff_no_of_days_aval            NUMBER;
      eff_no_of_days_inv_aval        NUMBER;
      last_date_of_last_month        DATE;
      fromdate_no                    NUMBER;
      todate_no                      NUMBER;
      first_date_of_month_no         NUMBER;
      last_date_of_month_no          NUMBER;
      holiday_count                  NUMBER;
      discount_rate_available        NUMBER;
      discount_rate_avail_prev_mth   NUMBER;

      --ver 0.1 start
      TYPE LIC_CUR_TY IS TABLE OF VARCHAR2 (100);

      v_lic_cur_ary                  LIC_CUR_TY;
      v_lic_cur                      fid_license.lic_currency%TYPE;
      o_spot_1                       NUMBER;
   --ver 0.1 end
   BEGIN
      fromdate_no := TO_NUMBER (TO_CHAR (from_date, 'RRRRMMDD'));
      todate_no := TO_NUMBER (TO_CHAR (todate, 'RRRRMMDD'));
      no_of_days_in_month := (todate - from_date) + 1;
      first_date_of_month_no :=
         TO_NUMBER (TO_CHAR (first_date_of_month, 'YYYYMMDD'));
      last_date_of_month_no :=
         TO_NUMBER (TO_CHAR (last_date_of_month, 'YYYYMMDD'));
      -- Get the last date of last month
      last_date_of_last_month := LAST_DAY (ADD_MONTHS (todate, -1));




      --Feb Month End issue : Jawahar_10Mar2015 Check spot rate for all license currencies after go-live date
      --ver 0.1 start
      SELECT DISTINCT lic_currency
        BULK COLLECT INTO v_lic_cur_ary
        FROM fid_license
       WHERE     lic_currency <> 'ZAR'
             AND lic_status = 'A'
             AND lic_start >= (SELECT TO_DATE (content, 'DD-MON-RRRR')
                                 FROM x_fin_configs
                                WHERE KEY = 'GO-LIVEDATE');

      --ver 0.1 end

      -- Loop the dates untill get the working day
      LOOP
         IF UPPER (TO_CHAR (last_date_of_last_month, 'DAY')) <> 'SUNDAY'
         THEN
            SELECT COUNT (1)
              INTO holiday_count
              FROM tbl_tvf_holidays
             WHERE thol_holiday_date = last_date_of_last_month;

            EXIT WHEN holiday_count = 0;
         END IF;

         last_date_of_last_month := last_date_of_last_month - 1;
      END LOOP;

      --Count the no. of holidays which does not falls on Sunday in the routine month
      SELECT COUNT (*)
        INTO no_of_holidays_in_month
        FROM tbl_tvf_holidays
       WHERE thol_holiday_date BETWEEN from_date AND todate
             AND thol_holiday_date NOT IN
                    (SELECT l_date
                       FROM (SELECT TO_DATE (
                                       from_date,
                                       'DD-MON-RRRR')
                                    + ROWNUM
                                    - 1
                                       l_date
                               FROM user_objects
                              WHERE (TO_DATE (
                                        from_date,
                                        'DD-MON-RRRR')
                                     + ROWNUM
                                     - 1) BETWEEN TO_DATE (
                                                     from_date,
                                                     'DD-MON-RRRR')
                                              AND TO_DATE (
                                                     todate,
                                                     'DD-MON-RRRR'))
                      WHERE TRIM (
                               TO_CHAR (l_date, 'DAY')) = 'SUNDAY');

      --Count the no. of Sundays in the routine month
      SELECT COUNT (*)
        INTO no_of_sundays_in_month
        FROM (SELECT TO_DATE (from_date, 'DD/MM/RRRR') + ROWNUM - 1 l_date
                FROM user_objects
               WHERE (TO_DATE (from_date, 'DD/MM/RRRR') + ROWNUM - 1) BETWEEN TO_DATE (
                                                                                 from_date,
                                                                                 'DD/MM/RRRR')
                                                                          AND TO_DATE (
                                                                                 todate,
                                                                                 'DD/MM/RRRR'))
       WHERE TRIM (TO_CHAR (l_date, 'DAY')) = 'SUNDAY';

      --Ver 0.1 start
      FOR i IN 1 .. v_lic_cur_ary.COUNT
      LOOP
         v_lic_cur := v_lic_cur_ary (i);

         --Ver 0.1 end

         --Count the no. of days for which the rate from Mcgregor is available for a currency pair in the routine month
         SELECT COUNT (*)
           INTO no_of_days_aval
           FROM tbl_tvf_spot_rate
          -- WHERE spo_v_cur_code = lic.lic_currency
          --    AND spo_v_cur_code_2 = lic.ter_cur_code
          WHERE                                                --ver 0.1 start
                    --spo_v_cur_code = 'USD'
                    spo_v_cur_code = v_lic_cur                   --ver 0.1 end
                AND spo_v_cur_code_2 = 'ZAR'
                AND spo_n_srs_id = 1
                AND    spo_n_per_year
                    || LPAD (spo_n_per_month, 2, 0)
                    || LPAD (spo_n_per_day, 2, 0) BETWEEN fromdate_no
                                                      AND todate_no;

         --Count the no. of days for which the rate from Mcgregor is available for a currency pair in the routine month
         SELECT COUNT (*)
           INTO no_of_days_inv_aval
           FROM tbl_tvf_spot_rate
          -- WHERE spo_v_cur_code = lic.ter_cur_code
          --   AND spo_v_cur_code_2 = lic.lic_currency
          WHERE     spo_v_cur_code = 'ZAR'                     --ver 0.1 start
                --AND spo_v_cur_code_2 = 'USD'
                AND spo_v_cur_code_2 = v_lic_cur                 --ver 0.1 end
                AND spo_n_srs_id = 1
                AND    spo_n_per_year
                    || LPAD (spo_n_per_month, 2, 0)
                    || LPAD (spo_n_per_day, 2, 0) BETWEEN fromdate_no
                                                      AND todate_no;

         --no. of days rate available + No. of Holidays + No. of Sundays in the routine month
         eff_no_of_days_aval :=
              no_of_days_aval
            + no_of_holidays_in_month
            + no_of_sundays_in_month;

         -- #region -> ABHINAY_15Apr2014: FIN22-Non-use case - Date indication in Costing Routine Failure Mail
         IF (i_month_end_type = 'FINAL')
         THEN
            FOR date_cur
               IN /*  (SELECT TO_DATE (fromdate_no, 'DD-MON-RRRR') + ROWNUM - 1 l_date
                      FROM user_objects
                     WHERE (TO_DATE (fromdate_no, 'DD-MON-RRRR') + ROWNUM - 1)
                              BETWEEN TO_DATE (fromdate_no, 'DD-MON-RRRR')
                                  AND TO_DATE (todate_no, 'DD-MON-RRRR'))
                 */
                  (SELECT TO_DATE (fromdate_no, 'YYYYMMDD') + ROWNUM - 1
                             l_date
                     FROM user_objects
                    WHERE (TO_DATE (fromdate_no, 'YYYYMMDD') + ROWNUM - 1) BETWEEN TO_DATE (
                                                                                      fromdate_no,
                                                                                      'YYYYMMDD')
                                                                               AND TO_DATE (
                                                                                      todate_no,
                                                                                      'YYYYMMDD'))
            LOOP
               BEGIN
                  o_spot := 0;

                  SELECT COUNT (*)
                    INTO o_spot
                    FROM tbl_tvf_spot_rate
                   WHERE spo_n_per_day =
                            LTRIM (
                               TO_CHAR (
                                  TO_DATE (date_cur.l_date,
                                           'dd-mon-yyyy hh24:mi:ss'),
                                  'dd'),
                               '0')
                         AND spo_n_per_month =
                                LTRIM (
                                   TO_CHAR (
                                      TO_DATE (date_cur.l_date,
                                               'dd-mon-yyyy hh24:mi:ss'),
                                      'MM'),
                                   '0')
                         AND spo_n_per_year = i_year
                         --ver 0.1 start
                         /*AND spo_v_cur_code IN ('USD', 'ZAR')
                         AND spo_v_cur_code_2 IN ('ZAR', 'USD')*/
                         AND spo_v_cur_code = v_lic_cur
                         AND spo_v_cur_code_2 = 'ZAR'
                         --ver 0.1 end
                         AND spo_n_srs_id = 1;

                  --ver 0.1 satrt
                  IF o_spot = 0
                  THEN
                     o_spot_1 := 0;

                     SELECT COUNT (*)
                       INTO o_spot_1
                       FROM tbl_tvf_spot_rate
                      WHERE spo_n_per_day =
                               LTRIM (
                                  TO_CHAR (
                                     TO_DATE (date_cur.l_date,
                                              'dd-mon-yyyy hh24:mi:ss'),
                                     'dd'),
                                  '0')
                            AND spo_n_per_month =
                                   LTRIM (
                                      TO_CHAR (
                                         TO_DATE (date_cur.l_date,
                                                  'dd-mon-yyyy hh24:mi:ss'),
                                         'MM'),
                                      '0')
                            AND spo_n_per_year = i_year
                            AND spo_v_cur_code = 'ZAR'
                            AND spo_v_cur_code_2 = v_lic_cur
                            AND spo_n_srs_id = 1;

                     --IF (o_spot = 0)      --ver o.1 commented
                     IF (o_spot_1 = 0)
                     --ver 0.1 end
                     THEN
                        SELECT COUNT (*)
                          INTO o_holiday
                          FROM tbl_tvf_holidays
                         WHERE thol_holiday_date = date_cur.l_date;

                        IF (o_holiday = 0)
                        THEN
                           INSERT
                             INTO x_fin_costing_validations (cov_v_code,
                                                             cov_v_error)
                           VALUES (
                                     'SPOTRATE',
                                        'Spot Rate from '
                                     --|| 'USD'                    --ver 0.1 commented
                                     || v_lic_cur              --ver 0.1 added
                                     || ' to'
                                     || 'ZAR'
                                     || 'for Mcgregor for'
                                     || date_cur.l_date
                                     || 'does not exist.');
                        END IF;
                     END IF;
                  END IF;                                      --ver 0.1 added
               END;
            END LOOP;
         END IF;

         -- #endregion -> ABHINAY_15Apr2014:

         no_of_days_aval := 0;
         no_of_days_inv_aval := 0;
         eff_no_of_days_aval := 0;
         eff_no_of_days_inv_aval := 0;

         -- Count the no. of days for which the rate from forward rate is available
         -- for a currency pair in the routine month
         SELECT COUNT (*)
           INTO no_of_days_aval
           FROM x_fin_fwd_rate
          -- WHERE fwd_cur_code = lic.lic_currency
          --   AND fwd_cur_code_2 = lic.ter_cur_code
          WHERE                                                --ver 0.1 start
                --fwd_cur_code = 'USD'
                fwd_cur_code = v_lic_cur                         --ver 0.1 end
                                        AND fwd_cur_code_2 = 'ZAR'
                AND    fwd_per_year
                    || LPAD (fwd_per_month, 2, 0)
                    || LPAD (fwd_per_day, 2, 0) BETWEEN first_date_of_month_no
                                                    AND last_date_of_month_no;

         -- Count the no. of days for which the rate from forward rate is available
         -- for a currency pair in the routine month
         SELECT COUNT (*)
           INTO no_of_days_inv_aval
           FROM x_fin_fwd_rate
          --  WHERE fwd_cur_code = lic.ter_cur_code
          --AND fwd_cur_code_2 = lic.lic_currency
          WHERE fwd_cur_code = 'ZAR'                           --ver 0.1 start
                                     --AND fwd_cur_code_2 = 'USD'
                AND fwd_cur_code_2 = v_lic_cur
                --ver 0.1 end
                AND    fwd_per_year
                    || LPAD (fwd_per_month, 2, 0)
                    || LPAD (fwd_per_day, 2, 0) BETWEEN first_date_of_month_no
                                                    AND last_date_of_month_no;

         -- If the forward rate is not present for any day of routine month then check if
         -- it is present for last date of last month
         IF no_of_days_aval = 0 AND no_of_days_inv_aval = 0
         THEN
            -- Check if the forward rate is present for last date of last month
            SELECT COUNT (*)
              INTO eff_no_of_days_aval
              FROM x_fin_fwd_rate
             --  where fwd_cur_code = lic.lic_currency
             --   and fwd_cur_code_2 = lic.ter_cur_code
             WHERE                                             --ver 0.1 start
                   --fwd_cur_code = 'USD'
                   fwd_cur_code = v_lic_cur                      --ver 0.1 end
                                           AND fwd_cur_code_2 = 'ZAR'
                   AND fwd_per_year =
                          TO_NUMBER (
                             TO_CHAR (last_date_of_last_month, 'YYYY'))
                   AND fwd_per_month =
                          TO_NUMBER (TO_CHAR (last_date_of_last_month, 'MM'))
                   AND fwd_per_day =
                          TO_NUMBER (TO_CHAR (last_date_of_last_month, 'DD'));

            -- Check if the forward rate is present for last date of last month
            SELECT COUNT (*)
              INTO eff_no_of_days_inv_aval
              FROM x_fin_fwd_rate
             -- where fwd_cur_code = lic.ter_cur_code
             --  and fwd_cur_code_2 = lic.lic_currency
             WHERE fwd_cur_code = 'ZAR'                        --ver 0.1 start
                                        --AND fwd_cur_code_2 = 'USD'
                   AND fwd_cur_code_2 = v_lic_cur
                   --ver 0.1 end
                   AND fwd_per_year =
                          TO_NUMBER (
                             TO_CHAR (last_date_of_last_month, 'YYYY'))
                   AND fwd_per_month =
                          TO_NUMBER (TO_CHAR (last_date_of_last_month, 'MM'))
                   AND fwd_per_day =
                          TO_NUMBER (TO_CHAR (last_date_of_last_month, 'DD'));

            IF eff_no_of_days_aval = 0 AND eff_no_of_days_inv_aval = 0
            THEN
               BEGIN
                  INSERT
                    INTO x_fin_costing_validations (cov_v_code, cov_v_error)
                  VALUES (
                            'FWDRATE',
                               'Forward Rate from '
                            --|| 'USD'                           --lic.lic_currency  --ver 0.1 commented
                            || v_lic_cur                       --ver 0.1 added
                            || ' to '
                            || 'ZAR'                        --lic.ter_cur_code
                            || ' does not exist for any day of '
                            || TO_CHAR (todate, 'Mon-YYYY')
                            || ' and last day of '
                            || TO_CHAR (last_date_of_last_month, 'Mon-YYYY'));
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     NULL;
               END;
            END IF;
         END IF;
      END LOOP;                                                --ver 0.1 added

      --END IF;
      --END LOOP;

      --check if discount rate is present for current routine month
      SELECT COUNT (*)
        INTO discount_rate_available
        FROM x_fin_disc_rate
       WHERE     drm_month = TO_NUMBER (TO_CHAR (todate, 'MM'))
             AND drm_year = TO_NUMBER (TO_CHAR (todate, 'YYYY'))
             AND drm_disc_per_anl IS NOT NULL
             AND drm_disc_per_anl <> 0;

      IF discount_rate_available = 0
      THEN
         BEGIN
            INSERT INTO x_fin_costing_validations (cov_v_code, cov_v_error)
                 VALUES (
                           'DISCRATE',
                              'Discount Rate '
                           || ' does not exist for '
                           || TO_CHAR (todate, 'Mon-YYYY'));
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               NULL;
         END;
      END IF;

      SELECT COUNT (*)
        INTO discount_rate_avail_prev_mth
        FROM x_fin_disc_rate
       WHERE drm_month = TO_NUMBER (TO_CHAR (last_date_of_last_month, 'MM'))
             AND drm_year =
                    TO_NUMBER (TO_CHAR (last_date_of_last_month, 'YYYY'))
             AND drm_disc_per_anl IS NOT NULL
             AND drm_disc_per_anl <> 0;

      IF discount_rate_avail_prev_mth = 0
      THEN
         BEGIN
            INSERT INTO x_fin_costing_validations (cov_v_code, cov_v_error)
                 VALUES (
                           'DISCRATE',
                              'Discount Rate '
                           || ' does not exist for last Month '
                           || TO_CHAR (last_date_of_last_month, 'Mon-YYYY'));
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               NULL;
         END;
      END IF;
   END chk_spot_rate_avail;

   -- Pure Finance: Ajit : 23-Feb-2013 : Procedure added to check the validation before running the Costing routine
   PROCEDURE validations_check (com_number            IN NUMBER,
                                connumber             IN NUMBER,
                                month_end_type        IN VARCHAR2,
                                regioncode            IN VARCHAR2,
                                first_date_of_month   IN DATE,
                                last_date_of_month    IN DATE,
                                from_date             IN DATE,
                                todate                IN DATE)
   IS
      per_month                      NUMBER;
      per_year                       NUMBER;
      no_of_holidays_in_month        NUMBER;
      no_of_sundays_in_month         NUMBER;
      no_of_days_in_month            NUMBER;
      no_of_days_aval                NUMBER;
      no_of_days_inv_aval            NUMBER;
      eff_no_of_days_aval            NUMBER;
      eff_no_of_days_inv_aval        NUMBER;
      last_date_of_last_month        DATE;
      fromdate_no                    NUMBER;
      todate_no                      NUMBER;
      first_date_of_month_no         NUMBER;
      last_date_of_month_no          NUMBER;
      holiday_count                  NUMBER;
      discount_rate_available        NUMBER;
      discount_rate_avail_prev_mth   NUMBER;
      l_min_sub_cnt                  NUMBER;

      CURSOR lic_c (
         connumber      NUMBER,
         comnumber      NUMBER,
         periodstart    DATE,
         periodend      DATE,
         regioncode     VARCHAR2)
      IS
         SELECT DISTINCT lic_currency, ter_cur_code
           FROM fid_license,
                fid_licensee,
                fid_company,
                fid_territory,
                fid_region
          WHERE     lic_con_number = connumber
                AND NVL (lic_acct_date,
                         TO_DATE ('31-DEC-2099', 'DD-MON-YYYY')) <= periodend
                --AND lic_end >= periodstart
                --AND lic_type IN ('FLF', 'CHC')
                AND lee_number = lic_lee_number
                AND com_number = lee_cha_com_number
                AND com_ter_code = ter_code
                AND com_number = comnumber
                -- Pure Finance: Ajit : 23-Feb-2013 : Where cause added for region, Amort Code D,
                -- Go-live date, license price <> 0 and active licenses
                AND reg_id(+) = lee_split_region
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (regioncode,
                                  '%', NVL (reg_code, '#'),
                                  regioncode))
                AND UPPER (lic_amort_code) IN ('D', 'C', 'E','F')					--[25-Aug-2015]Jawahar.Grag[Added amort code 'F' for Omnibus]
                AND lic_status = 'A'
                AND NVL (lic_price, 0) <> 0
                AND lic_start >= (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                    FROM x_fin_configs
                                   WHERE KEY = 'GO-LIVEDATE');
   BEGIN
      fromdate_no := TO_NUMBER (TO_CHAR (from_date, 'YYYYMMDD'));
      todate_no := TO_NUMBER (TO_CHAR (todate, 'YYYYMMDD'));
      no_of_days_in_month := (todate - from_date) + 1;
      first_date_of_month_no :=
         TO_NUMBER (TO_CHAR (first_date_of_month, 'YYYYMMDD'));
      last_date_of_month_no :=
         TO_NUMBER (TO_CHAR (last_date_of_month, 'YYYYMMDD'));
      -- Get the last date of last month
      last_date_of_last_month := LAST_DAY (ADD_MONTHS (todate, -1));

      ----------------T licenses scheduled start
      IF UPPER (month_end_type) = 'FINAL'
      THEN
         -- Check for if T license scheduled during routine month
         FOR lic
            IN (SELECT DISTINCT lic_number,
                                (SELECT gen_title
                                   FROM fid_general
                                  WHERE gen_refno = lic_gen_refno)
                                   Programme_title,
                                lic_con_number
                  FROM fid_schedule,
                       fid_license,
                       fid_licensee,
                       fid_region
                 WHERE     lic_number = sch_lic_number
                       AND lic_status = 'T'
                       AND lee_number = lic_lee_number
                       AND reg_id(+) = lee_split_region
                       AND UPPER (NVL (reg_code, '#')) LIKE
                              UPPER (
                                 DECODE (regioncode,
                                         '%', NVL (reg_code, '#'),
                                         regioncode))
                       AND lic_con_number = connumber
                       AND sch_date BETWEEN first_date_of_month
                                        AND last_date_of_month)
         LOOP
            BEGIN
               INSERT
                 INTO x_fin_costing_validations (cov_v_code, cov_v_error)
               VALUES (
                         'TLicense',
                            'The License '
                         || lic.lic_number
                         || ' - '
                         || lic.Programme_title
                         || ' - '
                         || lic.lic_con_number
                         || ' is T license scheduled between '
                         || TO_CHAR (first_date_of_month, 'DD-Mon-YYYY')
                         || ' to '
                         || TO_CHAR (last_date_of_month, 'DD-Mon-YYYY'));
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
            END;
         END LOOP;
      -- END LOOP;
      END IF;


      ---------------T Licenses scheduled end
      IF UPPER (month_end_type) = 'FINAL'
      THEN
         -- Check for if TBA license scheduled during routine month
         FOR lic
            IN (SELECT DISTINCT lic_number
                  FROM fid_schedule,
                       fid_license,
                       fid_licensee,
                       fid_region
                 WHERE     lic_number = sch_lic_number
                       AND NVL (lic_period_tba, 'N') = 'Y'
                       AND lee_number = lic_lee_number
                       AND reg_id(+) = lee_split_region
                       AND UPPER (NVL (reg_code, '#')) LIKE
                              UPPER (
                                 DECODE (regioncode,
                                         '%', NVL (reg_code, '#'),
                                         regioncode))
                       AND lic_con_number = connumber
                       AND sch_date BETWEEN first_date_of_month
                                        AND last_date_of_month)
         LOOP
            BEGIN
               INSERT
                 INTO x_fin_costing_validations (cov_v_code, cov_v_error)
               VALUES (
                         'TBA',
                            'The License '
                         || lic.lic_number
                         || ' is TBA scheduled between '
                         || TO_CHAR (first_date_of_month, 'DD-Mon-YYYY')
                         || ' to '
                         || TO_CHAR (last_date_of_month, 'DD-Mon-YYYY'));
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
            END;
         END LOOP;

         -- Check for if Bioscope license scheduled on channel having scheduling window as TBA
         FOR lic
            IN (SELECT DISTINCT lic_number, sch_cha_number
                  FROM fid_schedule,
                       fid_license,
                       fid_licensee,
                       fid_region
                 WHERE     lic_number = sch_lic_number
                       AND lic_lee_number = lee_number
                       AND reg_id(+) = lee_split_region
                       AND UPPER (lic_amort_code) = 'D'
                       AND UPPER (NVL (reg_code, '#')) LIKE
                              UPPER (
                                 DECODE (regioncode,
                                         '%', NVL (reg_code, '#'),
                                         regioncode))
                       AND UPPER (NVL (lee_bioscope_flag, 'N')) = 'Y'
                       AND UPPER (lic_budget_code) IN
                              (SELECT UPPER (cpt_gen_type)
                                 FROM sgy_pb_costed_prog_type)
                       AND sch_date BETWEEN first_date_of_month
                                        AND last_date_of_month
                       AND lic_con_number = connumber
                       AND NOT EXISTS
                                  (SELECT 'X'
                                     FROM fid_license_channel_runs
                                    WHERE     lcr_lic_number = lic_number
                                          AND lic_con_number = connumber
                                          AND lcr_cha_number = sch_cha_number
                                          --Ver 0.3 Start - P1 Issue Jawahar: 30Mar2015 Used sch_fin_actual_date instead of sch_date as Not schedules not considered from 12 am to 6 am on license end date which was violation of contract
                                          /*
                                          --commented in ver 0.3
                                          AND ( (sch_date BETWEEN lcr_sch_start_date
                                                              AND lcr_sch_end_date)
                                               OR (sch_date BETWEEN lcr_sch_start_date2
                                                                AND lcr_sch_end_date2)))
                                         */
                                          AND ( (sch_fin_actual_date BETWEEN lcr_sch_start_date
                                                                         AND lcr_sch_end_date)
                                               OR (sch_fin_actual_date BETWEEN lcr_sch_start_date2
                                                                           AND lcr_sch_end_date2))) --Ver 0.3 End
                                                                                                   )
         LOOP
            BEGIN
               INSERT
                 INTO x_fin_costing_validations (cov_v_code, cov_v_error)
               VALUES (
                         'SCHWIND',
                            'The License '
                         || lic.lic_number
                         || ' scheduled on Channel '
                         || (SELECT cha_short_name
                               FROM fid_channel
                              WHERE cha_number = lic.sch_cha_number)
                         || ' is either scheduled outside the Scheduling Window, or the Scheduling Window for this license is TBA');
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
            END;
         END LOOP;
      END IF;

      -- Check for if Payment rate and payment date for any of the paid payment whose
      -- status date falls in the routine period is not captured on system
      IF UPPER (month_end_type) = 'FINAL'
      THEN
         FOR lic
            IN (SELECT DISTINCT pay_lic_number, pay_con_number, pay_reference
                  FROM fid_payment,
                       fid_license,
                       fid_licensee,
                       fid_region
                 WHERE     pay_lic_number = lic_number
                       AND lee_number = lic_lee_number
                       AND reg_id(+) = lee_split_region
                       AND UPPER (NVL (reg_code, '#')) LIKE
                              UPPER (
                                 DECODE (regioncode,
                                         '%', NVL (reg_code, '#'),
                                         regioncode))
                       AND pay_status = 'P'
                       AND lic_con_number = connumber
                       AND (pay_rate IS NULL OR pay_date IS NULL)
                       AND (pay_status_date BETWEEN from_date AND todate
                            OR pay_date BETWEEN from_date AND todate))
         LOOP
            BEGIN
               INSERT
                 INTO x_fin_costing_validations (cov_v_code, cov_v_error)
               VALUES (
                         'PAYMENT',
                            'The License '
                         || lic.pay_lic_number
                         || ' having Reference number '
                         || lic.pay_reference
                         || ', belonging to the Contract '
                         || (SELECT con_short_name
                               FROM fid_contract
                              WHERE con_number = lic.pay_con_number)
                         || ' has paid record(s) but the Payment Date and/or the Spot Rate is not captured on the system');
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
            END;
         END LOOP;
      END IF;

      --------Code changes for licenses started but TBA flag still ticked----------------
      IF UPPER (month_end_type) = 'FINAL'
      THEN
         FOR lic
            IN (SELECT lic_number
                  FROM fid_license
                 WHERE     lic_start BETWEEN from_date AND todate
                       AND lic_period_tba = 'Y'
                       AND lic_status = 'A')
         LOOP
            BEGIN
               INSERT
                 INTO x_fin_costing_validations (cov_v_code, cov_v_error)
               VALUES (
                         'LICENSE',
                         'The License ' || lic.lic_number
                         || ' is already started but TBA flag is still ticked');
            EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                  NULL;
            END;
         END LOOP;
      END IF;

      -----------------End----------------------------------------------------------------------------
      --BR_5_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/16]
      FOR i
         IN (SELECT Lic_Number,
                    con_name,
                    con_number,
                    con_short_name,
                    LIC_MIN_GUARANTEE_FLAG,
                    LIC_MIN_SUBS_FLAG
               FROM fid_license,
                    fid_licensee,
                    fid_company,
                    fid_region,
                    fid_contract
              WHERE lic_con_number = connumber
                    AND TO_NUMBER (TO_CHAR (lic_start, 'YYYYMMDD')) <=
                           todate_no
                    AND lee_number = lic_lee_number
                    AND com_number = lee_cha_com_number
                    AND con_number = lic_con_number
                    AND lic_status = 'A'
                    AND com_number = com_number
                    AND reg_id(+) = lee_split_region
                    AND UPPER (NVL (reg_code, '#')) LIKE
                           UPPER (
                              DECODE (regioncode,
                                      '%', NVL (reg_code, '#'),
                                      regioncode))
                    AND lic_start >= (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                        FROM x_fin_configs
                                       WHERE KEY = 'GO-LIVEDATE'))
      LOOP
         IF i.LIC_MIN_GUARANTEE_FLAG = 'Y'
         THEN
            SELECT COUNT (1)
              INTO l_min_sub_cnt
              FROM fid_contract
             WHERE con_number = i.con_number
                   AND NVL (CON_MIN_SUBSCRIBER, 0) = 0;

            IF l_min_sub_cnt > 0
            THEN

               BEGIN
                  INSERT
                    INTO x_fin_costing_validations (cov_v_code, cov_v_error)
                  VALUES (
                            'License',
                            'Minimum Subscriber Number is Required for License No.'
                            || i.lic_number
                            || ' belonging to contract '
                            || i.con_short_name
                            || '-'
                            || i.con_name
                            || ' Which is not entered at contract level. Kindly enter the Minimum subscriber figure for the contract');
               EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                     NULL;
               END;
            END IF;
         END IF;
      END LOOP;

      --END
      COMMIT;
   END;

   -- Pure Finance: Ajit : 28-Feb-2013 : Procedure added to mark the ED Applicable contract
   PROCEDURE mark_ed_applicable (current_month   IN NUMBER,
                                 current_year    IN NUMBER,
                                 connumber       IN NUMBER,
                                 user_id         IN VARCHAR2)
   IS
      l_con_sign_date        DATE;
      l_min_lic_start_date   DATE;
      l_con_effective_date   DATE;
      l_golive_date          DATE;
      l_con_ed_calculated    VARCHAR (5);
      l_min_date             DATE;
   BEGIN
      -- Get sign date, effective date and ED calculated field from fid_contract table
      SELECT NVL (con_date, TO_DATE ('31-DEC-2099', 'DD-MON-YYYY')),
             NVL (con_con_effective_date,
                  TO_DATE ('31-DEC-2099', 'DD-MON-YYYY')),
             con_ed_calculated
        INTO l_con_sign_date, l_con_effective_date, l_con_ed_calculated
        FROM fid_contract
       WHERE con_number = connumber;

      -- Get the Pure Finance live date
      SELECT TO_DATE (content, 'DD-MON-YYYY')
        INTO l_golive_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      -- Get min license start date for this contract
      SELECT MIN (lic_start)
        INTO l_min_lic_start_date
        FROM fid_license
       WHERE lic_con_number = connumber;

      -- Get the minimum date between contract sign date and license start date
      IF l_min_lic_start_date < l_con_sign_date
      THEN
         l_min_date := l_min_lic_start_date;
      ELSE
         l_min_date := l_con_sign_date;
      END IF;

      -- Check if the min date is matching to current routine month and year,
      -- and it is greater than Pure finance GO-Live date and
      -- it is not matching to exstiting Contract Effective date
      IF TO_NUMBER (TO_CHAR (l_min_date, 'YYYYMM')) =
            current_year || LPAD (current_month, 2, 0)
         AND l_min_date >= l_golive_date
         AND l_min_date <> l_con_effective_date
      THEN
         -- Update Contract effective date for this contract and
         -- Update ED applicable flag for this contract
         -- Logic : Check if the contract currency is not equal to Supplier Currency,
         -- Channel Company currency and ( Not equal to USD or if equal to USD
         -- then Supplier Currency is not equal to 'ZAR')
         UPDATE fid_contract
            SET con_ed_applicable_flag = 'Y',
                con_con_effective_date = l_min_date,
                con_entry_date = SYSDATE,
                con_entry_oper = user_id
          WHERE con_number IN
                   (SELECT con_number
                      FROM fid_contract con, fid_company com, fid_company cha
                     WHERE     con.con_number = con_number
                           AND con.con_com_number = com.com_number
                           AND con.con_agy_com_number = cha.com_number
                           AND UPPER (NVL (con.con_ed_applicable_flag, 'N')) =
                                  'N'
                           AND UPPER (con.con_currency) <>
                                  UPPER (com.com_cur_code)
                           AND UPPER (con.con_currency) <>
                                  UPPER (cha.com_cur_code)
                           AND (UPPER (con.con_currency) <> 'USD'
                                OR (UPPER (con.con_currency) = 'USD'
                                    AND UPPER (com.com_cur_code) = 'ZAR')))
                AND UPPER (con_calc_type) = 'FLF';
      END IF;
   END;

   -- Pure Finance: Ajit : 07-Mar-2013 : Procedure added to settle the -ve payments
   -- for both Active (Pre-payments only) and Cancelled licenses (Pre-payments + payments)
   PROCEDURE pre_payment_settlement (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_lsl_number      IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_lic_status      IN VARCHAR2,
      i_user_id         IN VARCHAR2)
   AS
      -- For Actice licenses this cursor will bring only -ve pre-payments with code 'T'
      -- For Calcelled licenses this cursor will bring all the -ve payments with code 'T' in routine month
      CURSOR refund_t_for_mon
      IS
         SELECT pay_number,
                pay_lic_number,
                pay_lsl_number,
                pay_rate,
                NVL (pay_amount, 0) pay_amount,
                pay_source_number
           FROM fid_payment, fid_license
          WHERE     pay_amount < 0
                AND pay_status = 'P'
                AND UPPER (pay_code) = 'T'
                AND lic_number = pay_lic_number
                AND DECODE (i_lic_status, 'A', pay_date, lic_start - 1) <
                       lic_start
                AND pay_lic_number = i_lic_number
                AND pay_lsl_number = i_lsl_number
                AND pay_date BETWEEN i_fromdate AND i_todate;

      refund_t                        refund_t_for_mon%ROWTYPE;

      -- For Actice licenses this cursor will bring only -ve pre-payments without code 'T'
      -- For Calcelled licenses this cursor will bring all the -ve payments without code 'T' in routine month
      CURSOR refund_for_mon
      IS
           SELECT pay_number,
                  pay_lic_number,
                  pay_lsl_number,
                  NVL (pay_amount, 0) pay_amount,
                  pay_source_number,
                  pay_date,
                  pay_rate
             FROM fid_payment, fid_license
            WHERE     pay_amount < 0
                  AND pay_status = 'P'
                  AND UPPER (pay_code) <> 'T'
                  AND lic_number = pay_lic_number
                  AND DECODE (i_lic_status, 'A', pay_date, lic_start - 1) <
                         lic_start
                  AND pay_lic_number = i_lic_number
                  AND pay_lsl_number = i_lsl_number
                  AND pay_date BETWEEN i_fromdate AND i_todate
         ORDER BY pay_date;

      refund                          refund_for_mon%ROWTYPE;

      -- For Actice licenses this cursor will bring only +ve pre-payments
      -- For Calcelled licenses this cursor will bring all the -ve payments in routine month
      CURSOR pre_payment_till_curr_mon (
         l_pay_date DATE)
      IS
           SELECT pay_number,
                  pay_lic_number,
                  pay_lsl_number,
                  NVL (pay_amount, 0) pay_amount,
                  pay_source_number,
                  pay_rate
             FROM fid_payment, fid_license
            WHERE     pay_amount > 0
                  AND pay_status = 'P'
                  AND lic_number = pay_lic_number
                  AND DECODE (i_lic_status, 'A', pay_date, lic_start - 1) <
                         lic_start
                  AND pay_lic_number = i_lic_number
                  AND pay_lsl_number = i_lsl_number
                  AND pay_date <= l_pay_date
         ORDER BY pay_date;

      pre_payment                     pre_payment_till_curr_mon%ROWTYPE;
      l_rem_refund_amount             NUMBER;
      rfd_amt_already_sett_for_pay    NUMBER;
      rfd_amt_now_sett_for_pay        NUMBER;
      tot_rzf_forex_for_pp_rfd_sett   NUMBER;
      period_value                    NUMBER;
      l_pay_rate                      NUMBER;
   BEGIN
      period_value := i_current_year || LPAD (i_current_month, 2, 0);

      -- Loop for all -ve prepayment for the license with Code 'T' for routine period
      OPEN refund_t_for_mon;

      LOOP
         FETCH refund_t_for_mon INTO refund_t;

         EXIT WHEN refund_t_for_mon%NOTFOUND;
         -- insert into refund settlement table
         insert_refund_settle (refund_t.pay_lic_number,
                               refund_t.pay_source_number,
                               refund_t.pay_lsl_number,
                               refund_t.pay_number,
                               -refund_t.pay_amount,
                               i_current_month,
                               i_current_year,
                               'Y',
                               i_user_id);
         l_pay_rate := 0;

         SELECT NVL (a.pay_rate, 0)
           INTO l_pay_rate
           FROM fid_payment a
          WHERE a.pay_number = refund_t.pay_source_number;

         -- insert inot realized forex table
         insert_realized_forex (
            i_lic_number,
            refund_t.pay_lsl_number,
            refund_t.pay_number,
            i_current_month,
            i_current_year,
            -- Realized forex = settled amount *
            -- (refund payment rate - payment rate)
            (refund_t.pay_amount * (refund_t.pay_rate - l_pay_rate)),
            'CON',
            i_user_id);
      END LOOP;

      -- loop end for -ve prepayment for the license with Code 'T' for routine period
      CLOSE refund_t_for_mon;

      -- Loop for all -ve prepayment for the license without Code 'T' for routine period
      OPEN refund_for_mon;

      LOOP
         FETCH refund_for_mon INTO refund;

         EXIT WHEN refund_for_mon%NOTFOUND;
         l_rem_refund_amount := refund.pay_amount;
         tot_rzf_forex_for_pp_rfd_sett := 0;

         OPEN pre_payment_till_curr_mon (refund.pay_date);

         LOOP
            FETCH pre_payment_till_curr_mon INTO pre_payment;

            EXIT WHEN pre_payment_till_curr_mon%NOTFOUND;

            -- check if the refund amount is greater than 0
            IF l_rem_refund_amount < 0
            THEN
               BEGIN
                  -- get the amount already settled for the month
                  SELECT SUM (frs_rfd_amount)
                    INTO rfd_amt_already_sett_for_pay
                    FROM x_fin_refund_settle
                   WHERE frs_year || LPAD (frs_month, 2, 0) <= period_value
                         AND frs_lic_number = i_lic_number
                         AND frs_pay_number = pre_payment.pay_number;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     rfd_amt_already_sett_for_pay := 0;
               END;

               -- check if the payment amount is not equal to already settled amount
               IF pre_payment.pay_amount <>
                     NVL (rfd_amt_already_sett_for_pay, 0)
               THEN
                  -- check if the rem refund amount (payment amount - already settled amount)
                  -- greater than -ve to be refund aount
                  IF (pre_payment.pay_amount
                      - NVL (rfd_amt_already_sett_for_pay, 0)) >=
                        -l_rem_refund_amount
                  THEN
                     rfd_amt_now_sett_for_pay := -l_rem_refund_amount;
                     l_rem_refund_amount := 0;
                  ELSE
                     rfd_amt_now_sett_for_pay :=
                        pre_payment.pay_amount
                        - NVL (rfd_amt_already_sett_for_pay, 0);
                     l_rem_refund_amount :=
                        l_rem_refund_amount + rfd_amt_now_sett_for_pay;
                  END IF;

                  -- insert into refund settlement table
                  insert_refund_settle (pre_payment.pay_lic_number,
                                        pre_payment.pay_number,
                                        pre_payment.pay_lsl_number,
                                        refund.pay_number,
                                        rfd_amt_now_sett_for_pay,
                                        i_current_month,
                                        i_current_year,
                                        'Y',
                                        i_user_id);
                  tot_rzf_forex_for_pp_rfd_sett :=
                     tot_rzf_forex_for_pp_rfd_sett
                     + rfd_amt_now_sett_for_pay
                       * (refund.pay_rate - pre_payment.pay_rate);
               END IF;
            END IF;
         END LOOP;          -- loop end for +ve prepayment before the pay date

         CLOSE pre_payment_till_curr_mon;

         -- insert inot realized forex table
         insert_realized_forex (i_lic_number,
                                pre_payment.pay_lsl_number,
                                refund.pay_number,
                                i_current_month,
                                i_current_year,
                                tot_rzf_forex_for_pp_rfd_sett,
                                'CON',
                                i_user_id);
      END LOOP;

      -- loop end for -ve prepayment for the license without Code 'T' for routine period
      CLOSE refund_for_mon;
   END pre_payment_settlement;

   PROCEDURE pre_payment_pre_license_settle (i_com_number      IN NUMBER,
                                             i_connumber       IN NUMBER,
                                             i_regioncode      IN VARCHAR2,
                                             i_current_month   IN NUMBER,
                                             i_current_year    IN NUMBER,
                                             i_from_date       IN DATE,
                                             i_todate          IN DATE,
                                             i_user_id         IN VARCHAR2)
   IS
      CURSOR lic_c (
         connumber     NUMBER,
         comnumber     NUMBER,
         regioncode    VARCHAR2)
      IS
         SELECT DISTINCT lic_number,
                         NVL (lic_showing_lic, 10) lic_showing_lic,
                         lic_start,
                         lic_end,
                         lsl_number,
                         lic_status
           FROM fid_license,
                fid_licensee,
                fid_company,
                fid_region,
                x_fin_lic_sec_lee,
                fid_payment
          WHERE     lic_con_number = connumber
                AND lsl_lic_number = lic_number
                AND lic_acct_date IS NULL
                AND lic_type IN ('FLF', 'CHC')
                AND lsl_lee_number = lee_number
                AND com_number = lee_cha_com_number
                AND com_number = comnumber
                AND pay_lsl_number = lsl_number
                --only for refund amount
                AND pay_amount < 0
                --pre_payments
                AND pay_date < lic_start
                AND UPPER (NVL (pay_status, 'N')) = 'P'
                AND reg_id(+) = lee_split_region
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (regioncode,
                                  '%', NVL (reg_code, '#'),
                                  regioncode))
                --PURE FINANCE:[exclude licenses for  NCF deal ][MANGESH GULHANE][2013-02-25]
                --AND UPPER (lic_status) <> 'F'
                AND UPPER (lic_status) = 'A'
                --PURE FINANCE End
                AND UPPER (lic_amort_code) IN ('D', 'C', 'E','F')									--[25-Aug-2015]Jawahar.Grag[Added amort code 'F' for Omnibus]
                AND lic_start >= (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                    FROM x_fin_configs
                                   WHERE KEY = 'GO-LIVEDATE');
   BEGIN
      FOR lic IN lic_c (i_connumber, i_com_number, i_regioncode)
      LOOP
         DELETE FROM x_fin_refund_settle
               WHERE frs_lic_number = lic.lic_number
                     AND frs_lsl_number = lic.lsl_number
                     AND frs_year || LPAD (frs_month, 2, 0) >=
                            CONCAT (i_current_year,
                                    LPAD (i_current_month, 2, 0));

         DELETE FROM x_fin_realized_forex
               WHERE rzf_lic_number = lic.lic_number
                     AND rzf_lsl_number = lic.lsl_number
                     AND rzf_year || LPAD (rzf_month, 2, 0) >=
                            CONCAT (i_current_year,
                                    LPAD (i_current_month, 2, 0));

         pre_payment_settlement (lic.lic_number,
                                 lic.lsl_number,
                                 i_current_month,
                                 i_current_year,
                                 i_from_date,
                                 i_todate,
                                 lic.lic_status,
                                 i_user_id);
      END LOOP;
   END pre_payment_pre_license_settle;

   -- Pure Finance: Ajit : 07-Mar-2013 : Procedure added to calculate realised forex
   PROCEDURE calculate_realized_forex (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_lsl_number      IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_user_id         IN VARCHAR2)
   AS
      --Payments made on or after license start date in routine month
      CURSOR payment_for_curr_mon
      IS
         SELECT pay_number,
                NVL (pay_amount, 0) pay_amount,
                pay_lsl_number,
                pay_rate,
                pay_date,
                lic_start_rate
           FROM fid_payment,
                fid_license,
                fid_licensee,
                fid_company,
                fid_territory
          WHERE     pay_lic_number = lic_number
                AND lee_number = lic_lee_number
                AND UPPER (lic_status) = 'A'
                AND UPPER (pay_status) = 'P'
                AND pay_date >= lic_start
                AND lee_number = lic_lee_number
                AND com_number = lee_cha_com_number
                AND ter_code = com_ter_code
                AND ter_cur_code <> lic_currency
                AND lic_number = i_lic_number
                AND pay_lsl_number = i_lsl_number
                AND pay_date BETWEEN i_fromdate AND i_todate;
	
      --Loop for refund payments that are settled against pre-payments
      CURSOR pre_payment_refund_settlement (
         l_pay_number NUMBER)
      IS
         SELECT frs_pay_number, frs_rfd_pay_number, frs_rfd_amount
           FROM x_fin_refund_settle
          WHERE     frs_rfd_pay_number = l_pay_number
                AND frs_lic_number = i_lic_number
                AND frs_lsl_number = i_lsl_number
                AND frs_month = i_current_month
                AND frs_year = i_current_year
                AND frs_is_payment = 'N';

      --Loop for refund payments that are settled against payments
      CURSOR payment_refund_settlement (
         l_pay_number NUMBER)
      IS
         SELECT frs_lsl_number,
                frs_pay_number,
                frs_rfd_pay_number,
                frs_rfd_amount
           FROM x_fin_refund_settle
          WHERE     frs_rfd_pay_number = l_pay_number
                AND frs_lic_number = i_lic_number
                AND frs_lsl_number = i_lsl_number
                AND frs_month = i_current_month
                AND frs_year = i_current_year
                AND frs_is_payment = 'Y';

      l_refund_pay_rate              NUMBER;
      l_pay_rate                     NUMBER;
      total_realized_amount          NUMBER := 0;
      l_refund_amount                NUMBER;
      l_rem_refund_amount            NUMBER;
      payment                        payment_for_curr_mon%ROWTYPE;
      rfd_amt_already_sett_for_pay   NUMBER;
   BEGIN

	  OPEN payment_for_curr_mon;

      LOOP
         FETCH payment_for_curr_mon INTO payment;

         EXIT WHEN payment_for_curr_mon%NOTFOUND;

         IF payment.pay_amount < 0
         THEN
            total_realized_amount := 0;

            FOR pre_payment_refund
               IN pre_payment_refund_settlement (payment.pay_number)
            LOOP
               SELECT NVL (pay_rate, 0)
                 INTO l_refund_pay_rate
                 FROM fid_payment
                WHERE pay_number = pre_payment_refund.frs_rfd_pay_number;

               SELECT NVL (pay_rate, 0)
                 INTO l_pay_rate
                 FROM fid_payment
                WHERE pay_number = pre_payment_refund.frs_pay_number;

               total_realized_amount :=
                  total_realized_amount
                  + pre_payment_refund.frs_rfd_amount
                    * (l_refund_pay_rate - l_pay_rate);
            END LOOP;

            FOR payment_refund
               IN payment_refund_settlement (payment.pay_number)
            LOOP
               SELECT NVL (pay_rate, 0)
                 INTO l_refund_pay_rate
                 FROM fid_payment
                WHERE pay_number = payment_refund.frs_rfd_pay_number;

               total_realized_amount :=
                  total_realized_amount
                  + payment_refund.frs_rfd_amount
                    * (l_refund_pay_rate - payment.lic_start_rate);
            END LOOP;

            SELECT NVL (SUM (frs_rfd_amount), 0)
              INTO rfd_amt_already_sett_for_pay
              FROM x_fin_refund_settle
             WHERE frs_year || LPAD (frs_month, 2, 0) <=
                      i_current_year || LPAD (i_current_month, 2, 0)
                   AND frs_lic_number = i_lic_number
                   AND frs_lsl_number = i_lsl_number
                   AND frs_rfd_pay_number = payment.pay_number;

            l_rem_refund_amount :=
               payment.pay_amount + rfd_amt_already_sett_for_pay;

            IF l_rem_refund_amount < 0
            THEN
               total_realized_amount :=
                  total_realized_amount
                  + (l_rem_refund_amount
                     * (l_refund_pay_rate - payment.lic_start_rate));
            END IF;

            insert_realized_forex (i_lic_number,
                                   payment.pay_lsl_number,
                                   payment.pay_number,
                                   i_current_month,
                                   i_current_year,
                                   total_realized_amount,
                                   'CON',
                                   i_user_id);
         ELSE

			insert_realized_forex (
               i_lic_number,
               payment.pay_lsl_number,
               payment.pay_number,
               i_current_month,
               i_current_year,
               (payment.pay_amount
                * (payment.lic_start_rate - payment.pay_rate)),
               'CON',
               i_user_id);
         END IF;
      END LOOP;
   END calculate_realized_forex;

   PROCEDURE calc_realized_pre_pay_roy (
      i_lic_number       IN fid_license.lic_number%TYPE,
      i_lsl_number       IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_lic_start_rate   IN NUMBER,
      i_user_id          IN VARCHAR2)
   AS
      CURSOR roy_pre_payments
      IS
         SELECT pay_number,
                pay_lic_number,
                pay_lsl_number,
                pay_rate,
                NVL (pay_amount, 0) pay_amount,
                pay_source_number
           FROM fid_payment, fid_license
          WHERE     pay_amount > 0
                AND UPPER (pay_status) = 'P'
                AND lic_number = pay_lic_number
                AND pay_date < lic_start
                AND pay_lic_number = i_lic_number
                AND pay_lsl_number = i_lsl_number;

      rfd_amt_already_sett_for_pay   NUMBER;
   BEGIN
      FOR roy_pre_pay IN roy_pre_payments
      LOOP
         BEGIN
            SELECT NVL (SUM (frs_rfd_amount), 0)
              INTO rfd_amt_already_sett_for_pay
              FROM x_fin_refund_settle
             WHERE frs_year || LPAD (frs_month, 2, 0) <=
                      i_current_year || LPAD (i_current_month, 2, 0)
                   AND frs_lic_number = i_lic_number
                   AND frs_pay_number = roy_pre_pay.pay_number;
         EXCEPTION
            WHEN OTHERS
            THEN
               rfd_amt_already_sett_for_pay := 0;
         END;

         IF ( (roy_pre_pay.pay_amount - rfd_amt_already_sett_for_pay) > 0)
         THEN
            insert_realized_forex (
               i_lic_number,
               roy_pre_pay.pay_lsl_number,
               roy_pre_pay.pay_number,
               i_current_month,
               i_current_year,
               -- Realized forex = payment amount * (license start rate - payment rate)
               ( (roy_pre_pay.pay_amount - rfd_amt_already_sett_for_pay)
                * (i_lic_start_rate - roy_pre_pay.pay_rate)),
               'CON',
               i_user_id);
         END IF;
      END LOOP;
   END calc_realized_pre_pay_roy;

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to reverse inventory and cost till previous month of routine month
   PROCEDURE reverse_inventory_and_cost (i_lic_number       NUMBER,
                                         i_lic_curreny      VARCHAR2,
                                         i_lic_acct_date    DATE,
                                         i_lsl_number       NUMBER,
                                         i_lsl_lee_price    NUMBER,
                                         i_com_ter_code     VARCHAR2,
                                         i_curr_year        NUMBER,
                                         i_curr_month       NUMBER,
                                         i_user_id          VARCHAR2,
                                         --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/24]
                                         i_reval_flag       fid_license_sub_ledger.lis_reval_flag%TYPE
                                         --Dev : Fin CR : End
                                         )
   AS
      CURSOR subledger_inv_prev_mth_c
      IS
         SELECT NVL (SUM (lis_con_forecast), 0) total_inv_till_last_month,
                NVL (SUM (lis_loc_forecast), 0) total_loc_inv_till_last_month,
                NVL (SUM (lis_con_actual), 0) total_con_act_till_last_month,
                NVL (SUM (lis_con_adjust), 0) total_con_adj_till_last_month,
                NVL (SUM (lis_con_writeoff), 0)
                   total_con_woff_till_last_month,
                NVL (SUM (lis_loc_actual), 0) total_loc_act_till_last_month,
                NVL (SUM (lis_loc_adjust), 0) total_loc_adj_till_last_month,
                NVL (SUM (lis_loc_writeoff), 0)
                   total_loc_woff_till_last_month,
                NVL (SUM (lis_pv_con_forecast), 0)
                   total_pv_inv_till_last_month,
                NVL (SUM (lis_pv_loc_forecast), 0)
                   total_pv_loc_inv_till_last_mth,
                NVL (SUM (lis_pv_con_inv_actual), 0)
                   pv_con_inv_act_till_lst_mth,
                NVL (SUM (lis_pv_con_liab_actual), 0)
                   pv_con_liab_act_till_lst_mth,
                NVL (SUM (lis_pv_loc_inv_actual), 0)
                   pv_loc_inv_act_till_lst_mth,
                NVL (SUM (lis_pv_loc_liab_actual), 0)
                   pv_loc_liab_act_till_lst_mth,
                NVL (SUM (lis_ed_loc_forecast), 0)
                   total_ed_inv_till_last_month,
                NVL (SUM (lis_ed_loc_actual), 0) total_ed_act_till_last_month,
                NVL (SUM (lis_con_unforseen_cost), 0)
                   tot_con_unforseen_till_lst_mth,
                NVL (SUM (lis_loc_unforseen_cost), 0)
                   tot_loc_unforseen_till_lst_mth,
                --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                NVL (SUM (LIS_ASSET_ADJ_VALUE), 0) tot_adj_val_till_last_mth,
                NVL (SUM (lis_mean_subscriber), 0) TOT_MEAN_SUBS,
                NVL (SUM (LIS_MG_PV_CON_FORECAST), 0)
                   tot_mgpv_con_inv_till_lst_mth,
                NVL (SUM (LIS_MG_PV_LOC_FORECAST), 0)
                   tot_mgpv_loc_inv_till_lst_mth,
                NVL (SUM (LIS_LOC_ASSET_ADJ_VALUE), 0)
                   tot_loc_adj_val_till_last_mth,
                NVL (SUM (LIS_MG_PV_CON_LIAB), 0) tot_mgpv_con_liab,
                NVL (SUM (lis_mg_pv_loc_liab), 0) tot_mgpv_loc_liab
           --END [BR_15_144-Finance CRs:New Payment Plan]
           FROM fid_license_sub_ledger
           WHERE lis_lic_number = i_lic_number
             AND lis_lsl_number = i_lsl_number
             AND lis_ter_code = i_com_ter_code
             AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                     i_curr_year || LPAD (i_curr_month, 2, 0);

      c_sub_ledger            subledger_inv_prev_mth_c%ROWTYPE;
      reverse_lic_rate        NUMBER;
      pre_license_flag        VARCHAR2 (1);
      go_live_date            DATE;
      l_rev_local_inventory   NUMBER := 0;
      l_lic_start             DATE;
      l_lic_end               DATE;
      
      --Finance Dev Phase I Zeshan [Start]
      l_lis_con_pay           fid_license_sub_ledger.lis_con_pay%TYPE         := 0;
      l_lis_loc_pay           fid_license_sub_ledger.lis_loc_pay%TYPE         := 0;
      l_lis_pay_mov_flag      fid_license_sub_ledger.lis_pay_mov_flag%TYPE    := 'N';
      l_lis_lic_com_number    fid_license_sub_ledger.lis_lic_com_number%TYPE;
      l_lis_lic_status        fid_license_sub_ledger.lis_lic_status%TYPE;
      l_old_lic_start         fid_license_sub_ledger.lis_lic_start%TYPE;
      l_lis_lic_cur           fid_license_sub_ledger.lis_lic_cur%TYPE;
      --Finance Dev Phase I [End]
   BEGIN
      SELECT TO_DATE (content, 'DD-MON-YYYY')
        INTO go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';
      
      --Finance Dev Phase I Zeshan [Start]
      SELECT lic_start, lic_end, lic_status, con_com_number, lic_currency
        INTO l_lic_start, l_lic_end, l_lis_lic_status, l_lis_lic_com_number, l_lis_lic_cur
        FROM fid_license, fid_contract
       WHERE lic_con_number = con_number
         AND lic_number = i_lic_number;
      
      --Get last month License start Date
      BEGIN
        SELECT lis_lic_start
        INTO l_old_lic_start
        FROM fid_license_sub_ledger
         WHERE lis_lic_number = i_lic_number
         AND lis_per_year || lpad(lis_per_month, 2, 0) = 
            TO_CHAR (ADD_MONTHS ((TO_DATE ( '01' || TO_CHAR (i_curr_month, '09') || TO_CHAR (i_curr_year), 'DDMMYYYY')), -1), 'YYYYMM')
         AND ROWNUM < 2;
        EXCEPTION
        WHEN no_data_found
        THEN
          l_old_lic_start := l_lic_start;
      END;
      
      x_prc_get_lic_mvmt_data(i_lic_number,i_lsl_number,l_old_lic_start,l_lis_con_pay,l_lis_loc_pay,l_lis_pay_mov_flag);
      --Finance Dev Phase I [End]

      IF i_lic_acct_date < go_live_date AND i_lic_curreny = 'USD'
      THEN
         reverse_lic_rate := 8.053;
         pre_license_flag := 'Y';
      ELSIF i_lic_acct_date < go_live_date AND i_lic_curreny = 'ZAR'
      THEN
         reverse_lic_rate := 1;
         pre_license_flag := 'Y';
      ELSE
         pre_license_flag := 'N';

         BEGIN
            reverse_lic_rate :=
               ROUND (
                  NVL (
                     (c_sub_ledger.total_loc_inv_till_last_month
                      / c_sub_ledger.total_inv_till_last_month),
                     0),
                  4);
         EXCEPTION
            WHEN OTHERS
            THEN
               reverse_lic_rate := 0;
         END;
      END IF;

      OPEN subledger_inv_prev_mth_c;

      FETCH subledger_inv_prev_mth_c INTO c_sub_ledger;

      IF UPPER (pre_license_flag) = 'Y'
      THEN
         l_rev_local_inventory :=
            ROUND (
               NVL (
                  c_sub_ledger.total_inv_till_last_month * reverse_lic_rate,
                  0),
               2);
      ELSE
         l_rev_local_inventory := c_sub_ledger.total_loc_inv_till_last_month;
      END IF;

      --insert the cumulative inventory and cost obtained for each licensee
      --in sub ledger
      insert_update_sub_ledger (
         i_lic_number,
         i_lsl_number,
         i_com_ter_code,
         i_curr_year,
         i_curr_month,
         i_lsl_lee_price,
         1,                                                    --adjust factor
         reverse_lic_rate,
         reverse_lic_rate,
         0,                                                  --paid exhibition
         -NVL (c_sub_ledger.total_inv_till_last_month, 0),
         -l_rev_local_inventory,
         0,                                                         --con_calc
         0,                                                         --loc_calc
         -NVL (c_sub_ledger.total_con_act_till_last_month, 0),
         --con_actual
         -NVL (c_sub_ledger.total_loc_act_till_last_month, 0),
         --loc_actual
         -NVL (c_sub_ledger.total_con_adj_till_last_month, 0),
         --con_adjust
         -NVL (c_sub_ledger.total_loc_adj_till_last_month, 0),
         --loc_adjust
         -NVL (c_sub_ledger.total_con_woff_till_last_month, 0),
         --con_writeoff
         -NVL (c_sub_ledger.total_loc_woff_till_last_month, 0),
         --loc_writeoff
         -NVL (c_sub_ledger.total_pv_inv_till_last_month, 0),
         --pv_inv
         -NVL (c_sub_ledger.total_pv_loc_inv_till_last_mth, 0),
         --loc_pv_inv
         -NVL (c_sub_ledger.pv_con_inv_act_till_lst_mth, 0),
         --pv_con_inv_actual
         -NVL (c_sub_ledger.pv_con_liab_act_till_lst_mth, 0),
         --pv_con_liability_actual
         -NVL (c_sub_ledger.pv_loc_inv_act_till_lst_mth, 0),
         --pv_loc_inv_actual
         -NVL (c_sub_ledger.pv_loc_liab_act_till_lst_mth, 0),
         --pv_loc_liability_actual
         -NVL (c_sub_ledger.total_ed_inv_till_last_month, 0),
         --ed_inv
         -NVL (c_sub_ledger.total_ed_act_till_last_month, 0),
         --ed_loc_actual
         -NVL (c_sub_ledger.tot_con_unforseen_till_lst_mth, 0),
         --con_unforseen
         -NVL (c_sub_ledger.tot_loc_unforseen_till_lst_mth, 0),
         --loc_unforseen
         --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
         -NVL (c_sub_ledger.tot_adj_val_till_last_mth, 0), --Revaluation value in case of mg for roy
         l_lic_start,
         l_lic_end,
         c_sub_ledger.TOT_MEAN_SUBS,
         -NVL (c_sub_ledger.tot_mgpv_con_inv_till_lst_mth, 0), --pv mg con inventory
         -NVL (c_sub_ledger.tot_mgpv_loc_inv_till_lst_mth, 0), --pv mg loc inventory
         -NVL (c_sub_ledger.tot_loc_adj_val_till_last_mth, 0), --Loc Revaluation value in case of mg for roy
         -NVL (c_sub_ledger.tot_mgpv_con_liab, 0), --Mg pv con liab for mg payments
         -NVL (c_sub_ledger.tot_mgpv_loc_liab, 0), --Mg pv loc liab for mg payments
         --END [BR_15_144-Finance CRs:New Payment Plan ]
         i_user_id,
         i_reval_flag,	--Dev : Fin CR: [Devashish Raverkar]_[2016/05/23]
         --Finance Dev Phase I Zeshan [Start]
         l_lis_lic_cur,
         l_lis_lic_com_number,
         l_lis_lic_status,
         l_lis_pay_mov_flag,
         l_lis_con_pay,
         l_lis_loc_pay
         --Finance Dev Phase I [End]
         );

      CLOSE subledger_inv_prev_mth_c;
   END reverse_inventory_and_cost;

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to reverse realized forex gain\loss till past month for each paid amount
   --hving amount greater than zero
   PROCEDURE reverse_real_forex_gain_loss (i_lic_number    NUMBER,
                                           i_lsl_number    NUMBER,
                                           i_curr_year     NUMBER,
                                           i_curr_month    NUMBER,
                                           i_user_id       VARCHAR2)
   AS
      --will get the realized forex G\L till past month
      --for each paid payment having having amount greate than
      --zero
      CURSOR realized_forex_till_prev_mth
      IS
           SELECT SUM (rzf_realized_forex) total_realized_forex,
                  rzf_account_head,
                  rzf_pay_number
             FROM fid_payment, x_fin_realized_forex
            WHERE     pay_number = rzf_pay_number
                  AND UPPER (pay_status) = 'P'
                  AND pay_amount > 0
                  AND rzf_year || LPAD (rzf_month, 2, 0) <
                         i_curr_year || LPAD (i_curr_month, 2, 0)
                  AND rzf_lic_number = i_lic_number
                  AND rzf_lsl_number = i_lsl_number
         GROUP BY rzf_account_head, rzf_pay_number;

      c_realized_forex   realized_forex_till_prev_mth%ROWTYPE;
   BEGIN
      OPEN realized_forex_till_prev_mth;

      LOOP
         FETCH realized_forex_till_prev_mth INTO c_realized_forex;

         EXIT WHEN realized_forex_till_prev_mth%NOTFOUND;

         IF NVL (c_realized_forex.total_realized_forex, 0) <> 0
         THEN
            fid_cos_pk.insert_realized_forex (
               i_lic_number,
               i_lsl_number,
               c_realized_forex.rzf_pay_number,
               i_curr_month,
               i_curr_year,
               -NVL (c_realized_forex.total_realized_forex, 0),
               c_realized_forex.rzf_account_head,
               i_user_id);
         END IF;
      END LOOP;

      CLOSE realized_forex_till_prev_mth;
   END reverse_real_forex_gain_loss;

   PROCEDURE reverse_unreal_forex_gain_loss (i_lic_number    NUMBER,
                                             i_lsl_number    NUMBER,
                                             i_curr_year     NUMBER,
                                             i_curr_month    NUMBER,
                                             i_user_id       VARCHAR2)
   AS
      CURSOR unrealized_forex_till_prev_mth
      IS
           SELECT SUM (unf_unrealized_forex) total_unrealized_forex,
                  unf_account_head
             FROM x_fin_unrealized_forex
            WHERE unf_year || LPAD (unf_month, 2, 0) <
                     i_curr_year || LPAD (i_curr_month, 2, 0)
                  AND unf_lic_number = i_lic_number
                  AND unf_lsl_number = i_lsl_number
         GROUP BY unf_account_head;
   BEGIN
      FOR c_unrealized_forex IN unrealized_forex_till_prev_mth
      LOOP
         IF NVL (c_unrealized_forex.total_unrealized_forex, 0) <> 0
         THEN
            insert_unrealized_forex (
               i_lic_number,
               i_lsl_number,
               i_curr_month,
               i_curr_year,
               -NVL (c_unrealized_forex.total_unrealized_forex, 0),
               c_unrealized_forex.unf_account_head,
               i_user_id);
         END IF;
      END LOOP;
   END reverse_unreal_forex_gain_loss;

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to reverse realized forex gain\loss till past month for each paid amount
   -- less than zero
   PROCEDURE rev_real_forex_pay_not_settle (i_lic_number    NUMBER,
                                            i_lsl_number    NUMBER,
                                            i_curr_year     NUMBER,
                                            i_curr_month    NUMBER,
                                            i_user_id       VARCHAR2)
   AS
      --get the cummulativ realized forex gain\loss for payamount < 0
      --and whose payment is not settle
      CURSOR real_forex_pay_not_settle
      IS
           SELECT SUM (rzf_realized_forex) total_realized_forex,
                  rzf_account_head,
                  rzf_pay_number
             FROM fid_payment, x_fin_realized_forex
            WHERE     pay_number = rzf_pay_number
                  AND UPPER (pay_status) = 'P'
                  AND pay_amount < 0
                  AND rzf_year || LPAD (rzf_month, 2, 0) <
                         i_curr_year || LPAD (i_curr_month, 2, 0)
                  AND rzf_lic_number = i_lic_number
                  AND rzf_lsl_number = i_lsl_number
                  AND rzf_pay_number NOT IN
                         (SELECT frs_rfd_pay_number
                            FROM x_fin_refund_settle
                           WHERE frs_lic_number = i_lic_number
                                 AND frs_lsl_number = i_lsl_number
                                 AND frs_year || LPAD (frs_month, 2, 0) <
                                        i_curr_year
                                        || LPAD (i_curr_month, 2, 0))
         GROUP BY rzf_account_head, rzf_pay_number;

      c_realized_forex   real_forex_pay_not_settle%ROWTYPE;
   BEGIN
      OPEN real_forex_pay_not_settle;

      FETCH real_forex_pay_not_settle INTO c_realized_forex;

      IF NVL (c_realized_forex.total_realized_forex, 0) <> 0
      THEN
         --reverse the cumaltive realized forex gain/loss till last
         --month
         fid_cos_pk.insert_realized_forex (
            i_lic_number,
            i_lsl_number,
            c_realized_forex.rzf_pay_number,
            i_curr_month,
            i_curr_year,
            -NVL (c_realized_forex.total_realized_forex, 0),
            c_realized_forex.rzf_account_head,
            i_user_id);
      END IF;

      CLOSE real_forex_pay_not_settle;
   END rev_real_forex_pay_not_settle;

   -- Pure Finance: Ajit : 21-Mar-2013 : Procedure added to calculate un-realised forex for Linear and PV
   PROCEDURE calc_unrealized_forex_con_pv (
      i_lic_number       IN fid_license.lic_number%TYPE,
      i_lsl_number       IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_lic_start_rate   IN NUMBER,
      i_to_date_rate     IN NUMBER,
      i_to_date          IN DATE,
      i_user_id          IN VARCHAR2)
   AS
      l_con_forcast_till_mon        NUMBER;
      l_pv_con_forcast_till_mon     NUMBER;
      l_pv_con_liab_cost_till_mon   NUMBER;
      l_payment_till_mon            NUMBER;
   BEGIN
      -- Get the total content inventory, PV inventory and
      -- total PV liability cost including this month
      SELECT NVL (SUM (lis_con_forecast), 0),
             SUM (NVL (lis_pv_con_forecast, 0)),
             SUM (NVL (lis_pv_con_liab_actual, 0))
        INTO l_con_forcast_till_mon,
             l_pv_con_forcast_till_mon,
             l_pv_con_liab_cost_till_mon
        FROM fid_license_sub_ledger
       WHERE lis_lic_number = i_lic_number AND lis_lsl_number = i_lsl_number
             AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                    i_current_year || LPAD (i_current_month, 2, 0);

      -- Get the sum of all the payments including this month
      SELECT NVL (SUM (pay_amount), 0)
        INTO l_payment_till_mon
        FROM fid_payment
       WHERE     UPPER (pay_status) = 'P'
             AND pay_lic_number = i_lic_number
             AND pay_lsl_number = i_lsl_number
             AND pay_date <= i_to_date;

      -- insert into un-realized forex table for Content
      insert_unrealized_forex (
         i_lic_number,
         i_lsl_number,
         i_current_month,
         i_current_year,
         -- Unrealized forex calculated for content
         -- total inventory minus total payment including current month
         -- into license start rate minus last date of routine month rate
         (l_con_forcast_till_mon - l_payment_till_mon)
         * (i_lic_start_rate - i_to_date_rate),
         'CON',
         i_user_id);
      -- insert inot un-realized forex table for PV
      insert_unrealized_forex (
         i_lic_number,
         i_lsl_number,
         i_current_month,
         i_current_year,
         -- Unrealized forex calculated for PV
         -- total PV inventory minus total PV liability cost including current month
         -- into license start rate minus last date of routine month rate
         (l_pv_con_forcast_till_mon - l_pv_con_liab_cost_till_mon)
         * (i_lic_start_rate - i_to_date_rate),
         'PV',
         i_user_id);
   END calc_unrealized_forex_con_pv;

   -- Pure Finance: Ajit : 21-Mar-2013 : Procedure added to calculate un-realised forex for ED
   PROCEDURE calc_unrealized_forex_ed (
      i_con_number      IN fid_contract.con_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_discount_rate   IN NUMBER,
      i_to_date         IN DATE,
      i_region          IN VARCHAR2,
      i_user_id         IN VARCHAR2)
   AS
      -- Cursor to get the all the FLF licenses whose starting date is greater than
      -- last date of routine month with accounting date null Amort Code D,C and E
      -- license start date grater than Pure Finance Go-Live date
      CURSOR lic_c (
         connumber     NUMBER,
         periodend     DATE,
         regioncode    VARCHAR2)
      IS
         SELECT lic_number,
                lic_start,
                lsl_number,
                NVL (lsl_lee_price, 0) lsl_lee_price,
                con_con_effective_date,
                lic_currency,
                ter_cur_code
           FROM fid_license,
                fid_licensee,
                x_fin_lic_sec_lee,
                fid_region,
                fid_contract,
                fid_company,
                fid_territory
          WHERE     lic_con_number = connumber
                AND lic_acct_date IS NULL
                AND NVL (con_con_effective_date,
                         TO_DATE ('31-DEC-2099', 'DD-MON-YYYY')) <= periodend
                AND lic_start > periodend
                AND UPPER (lic_type) = 'FLF'
                AND UPPER (lic_status) = 'A'
                AND lee_number = lic_lee_number
                AND lsl_lic_number = lic_number
                AND lic_con_number = con_number
                AND com_number = lee_cha_com_number
                AND com_ter_code = ter_code
                AND reg_id(+) = lee_split_region
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (regioncode,
                                  '%', NVL (reg_code, '#'),
                                  regioncode))
                AND UPPER (lic_amort_code) IN ('D', 'C', 'E','F')							--[25-Aug-2015]Jawahar.Grag[Added amort code 'F' for Omnibus]
                AND lic_start >= (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                    FROM x_fin_configs
                                   WHERE KEY = 'GO-LIVEDATE');

      l_payment_till_mon   NUMBER;
      cfd_fwd_rate         NUMBER;
      to_date_fwd_rate     NUMBER;
   BEGIN
      -- loop for licenses
      FOR lic IN lic_c (i_con_number, i_to_date, i_region)
      LOOP
         l_payment_till_mon := 0;
         cfd_fwd_rate :=
            x_pkg_fin_get_spot_rate.get_forward_rate_with_inverse (
               lic.lic_currency,
               lic.ter_cur_code,
               lic.con_con_effective_date);
         to_date_fwd_rate :=
            x_pkg_fin_get_spot_rate.get_forward_rate_with_inverse (
               lic.lic_currency,
               lic.ter_cur_code,
               i_to_date);

         -- Delete all the all the records from realized table
         -- specific to license and routine month
         DELETE FROM x_fin_unrealized_forex
               WHERE     unf_lic_number = lic.lic_number
                     AND unf_lsl_number = lic.lsl_number
                     AND unf_month = i_current_month
                     AND unf_year = i_current_year
                     AND unf_account_head = 'ED';

         -- Get the sum of all the payments including this month
         SELECT NVL (SUM (pay_amount), 0)
           INTO l_payment_till_mon
           FROM fid_payment
          WHERE     UPPER (pay_status) = 'P'
                AND pay_lic_number = lic.lic_number
                AND pay_lsl_number = lic.lsl_number
                AND pay_date <= i_to_date;

         -- insert inot un-realized forex table for ED
         insert_unrealized_forex (
            lic.lic_number,
            lic.lsl_number,
            i_current_month,
            i_current_year,
            -- Unrealized forex calculated for ED
            -- remaining license value (license price minus payments till routine month)
            -- into differance of forward rate of Contract effective date and forward rate of
            -- last day of routine month divided by discount rate rest to differance of
            -- license start date and last date of routine month
            ( (lic.lsl_lee_price - l_payment_till_mon)
             * (cfd_fwd_rate - to_date_fwd_rate))
            / POWER (1 + i_discount_rate / 100, (lic.lic_start - i_to_date)),
            'ED',
            i_user_id);
      END LOOP;                                       -- Loop end for Licenses
   END calc_unrealized_forex_ed;

   -- Pure Finance: Ajit : 21-Mar-2013 : Procedure added to calculate un-realised forex for ED
   PROCEDURE calc_realized_forex_ed (
      i_lic_number       IN fid_license.lic_number%TYPE,
      i_lsl_number       IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_lsl_lee_price    IN x_fin_lic_sec_lee.lsl_lee_price%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_discount_rate    IN NUMBER,
      i_lic_start_rate   IN NUMBER,
      i_forward_rate     IN NUMBER,
      i_region           IN VARCHAR2,
      i_user_id          IN VARCHAR2)
   AS
      -- Cursor to get the all the FLF licenses whose starting date is greater than
      -- last date of routine month with accounting date null Amort Code D,C and E
      -- license start date grater than Pure Finance Go-Live date
      /* CURSOR lic_c (licnumber NUMBER, regioncode VARCHAR2)
       IS
          select LIC_NUMBER, LIC_START, LSL_NUMBER,
                 NVL (LSL_LEE_PRICE, 0) LSL_LEE_PRICE
            From  Fid_license,X_fin_lic_sec_lee, Fid_region,Fid_licensee
           Where Lic_number=licnumber
             AND lic_acct_date is not NULL
             AND UPPER (lic_type) = 'FLF'
             AND UPPER (lic_status) = 'A'
             AND lee_number = lic_lee_number
             and lsl_lic_number = lic_number
             AND reg_id(+) = lee_split_region
             And Upper (Nvl (Reg_code, '#')) Like
                    UPPER (DECODE (regioncode,
                                   '%', Nvl (Reg_code, '#'),
                                   regioncode
                                  )
                          )
             AND UPPER (lic_amort_code) IN ('D', 'C', 'E')
             AND lic_start >= (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                 From X_fin_configs
                                where key = 'GO-LIVEDATE');
                                */
      l_pre_payment   NUMBER;
      cfd_fwd_rate    NUMBER;
   BEGIN
      -- loop for licenses
      /*  FOR lic IN lic_c (i_lic_number,i_region)
        loop*/
      l_pre_payment := 0;

      -- Delete all the all the records from realized table
      -- specific to license and routine month
      DELETE x_fin_realized_forex
       WHERE     rzf_lic_number = i_lic_number
             AND rzf_lsl_number = i_lsl_number
             AND rzf_month = i_current_month
             AND rzf_year = i_current_year
             AND rzf_account_head = 'ED';

      -- Get the sum of all the payments including this month
      SELECT NVL (SUM (pay_amount), 0)
        INTO l_pre_payment
        FROM fid_payment, fid_license, x_fin_lic_sec_lee
       WHERE     lsl_lic_number = lic_number
             AND pay_lsl_number = lsl_number
             AND pay_lsl_number = i_lsl_number
             AND pay_lic_number = i_lic_number
             AND pay_date < lic_start
             AND pay_amount > 0
             AND UPPER (pay_status) = 'P';

      -- insert inot realized forex table
      insert_realized_forex (
         i_lic_number,
         i_lsl_number,
         NULL,
         i_current_month,
         i_current_year,
         -- Realized forex calculated for ED
         -- remaining license value (license price minus payments till routine month)
         -- into differance of forward rate of Contract effective date and spot rate on
         -- licnese start rate
         (i_lsl_lee_price - l_pre_payment)
         * (i_lic_start_rate - i_forward_rate),
         'ED',
         i_user_id);
   --  End Loop;                                       -- Loop end for Licenses
   END calc_realized_forex_ed;

   -- Pure Finance: Ajit : 22-Mar-2013 : Procedure added for cancelled licenses
   -- To reverse the inventory, cost, realized, unrealized forex and for payment settlement
   PROCEDURE calc_for_cancelled_license (
      i_con_number            IN fid_contract.con_number%TYPE,
      i_current_month         IN NUMBER,
      i_current_year          IN NUMBER,
      i_fromdate              IN DATE,
      i_todate                IN DATE,
      i_region                IN VARCHAR2,
      i_month_end_rate_date   IN DATE,
      i_user_id               IN VARCHAR2)
   AS
      -- Cursor to get the all the FLF cancelled licenses whose cancelled date is greater than
      -- Pure Finance Go-Live date with Amort Code D,C and E
      CURSOR lic_c
      IS
         SELECT lic_number,
                lic_start,
                lsl_number,
                lic_type,
                lic_currency,
                ter_cur_code,
                NVL (lsl_lee_price, 0) lsl_lee_price,
                lic_status,
                lic_amort_code,
                TO_NUMBER (TO_CHAR (lic_cancel_date, 'YYYYMM'))
                   lic_cancel_date,
                TO_NUMBER (TO_CHAR (lic_start, 'YYYYMM')) lic_start_month
           FROM fid_license,
                fid_licensee,
                x_fin_lic_sec_lee,
                fid_region,
                fid_territory,
                fid_company
          WHERE     lic_con_number = i_con_number
                --AND UPPER (lic_type) = 'FLF'
                AND UPPER (lic_status) = 'C'
                AND lee_number = lic_lee_number
                AND lsl_lic_number = lic_number
                AND reg_id(+) = lee_split_region
                AND com_number = lee_cha_com_number
                AND com_ter_code = ter_code
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (i_region,
                                  '%', NVL (reg_code, '#'),
                                  I_REGION))
                AND UPPER (lic_amort_code) IN ('D', 'C', 'E','F')									--[25-Aug-2015]Jawahar.Grag[Added amort code 'F' for Omnibus]
                AND lic_cancel_date >=
                       (SELECT TO_DATE (content, 'DD-MON-YYYY')
                          FROM x_fin_configs
                         WHERE KEY = 'GO-LIVEDATE');

      -- Cursor to get the all realized forex till previous month
      CURSOR realized_till_prev_month (
         licnumber    NUMBER,
         lslnumber    NUMBER)
      IS
           SELECT SUM (NVL (rzf_realized_forex, 0)) realized_forex,
                  rzf_lic_number,
                  rzf_lsl_number,
                  rzf_pay_number,
                  rzf_account_head
             FROM x_fin_realized_forex
            WHERE rzf_lic_number = licnumber AND rzf_lsl_number = lslnumber
                  AND rzf_year || LPAD (rzf_month, 2, 0) <
                         i_current_year || LPAD (i_current_month, 2, 0)
         GROUP BY rzf_lic_number,
                  rzf_lsl_number,
                  rzf_pay_number,
                  rzf_account_head /*
                 NOC :
                 In order to sum till current month year, previously it was sum for every month-year.
                 NEERAJ : KARIM : 13-12-2013
                 */
                 /*,
                 rzf_year,
                 rzf_month*/
   ;

      payments_till_curr_month       NUMBER;
      con_forecast_till_curr_month   NUMBER;
      license_start_rate             NUMBER;
      mth_end_date_rate              NUMBER;
      l_pay_amount                   NUMBER;
      l_refund_amount                NUMBER;
      l_rem_amount                   NUMBER;
      l_realized_forex               NUMBER;
      l_refund_count                 NUMBER;
      l_lic_cancel_in_om             NUMBER := 0;
      --Finance Dev Phase I Zeshan [Start]
      l_old_lic_start                DATE;
      l_lis_con_pay                  fid_license_sub_ledger.LIS_CON_PAY%TYPE;
      l_lis_loc_pay                  fid_license_sub_ledger.LIS_LOC_PAY%TYPE;
      l_lis_pay_mov_flag             fid_license_sub_ledger.LIS_PAY_MOV_FLAG%TYPE;
      --Finance Dev Phase I [End]
   BEGIN
      -- Loop for Cancelled licenses
      FOR lic IN lic_c
      LOOP
         --delete records for unrealized forex gain\loss for current routine
         --month
         DELETE FROM x_fin_unrealized_forex
               WHERE unf_lic_number = lic.lic_number
                     AND UNF_LSL_NUMBER = lic.lsl_number
                     AND unf_year || LPAD (unf_month, 2, 0) >=
                            CONCAT (i_current_year,
                                    LPAD (i_current_month, 2, 0));

         --delete records from realized forex for current routine month
         DELETE FROM x_fin_realized_forex
               WHERE rzf_lic_number = lic.lic_number
                     AND RZF_LSL_NUMBER = lic.lsl_number
                     AND rzf_year || LPAD (rzf_month, 2, 0) >=
                            CONCAT (i_current_year,
                                    LPAD (i_current_month, 2, 0));

         --  AND rzf_account_head LIKE 'CON';

         --delete records from refun settle for current routine month
         DELETE FROM x_fin_refund_settle
               WHERE frs_lic_number = lic.lic_number
                     AND FRS_LSL_NUMBER = lic.lsl_number
                     AND frs_year || LPAD (frs_month, 2, 0) >=
                            CONCAT (i_current_year,
                                    LPAD (i_current_month, 2, 0));

         -- Loop to reverse the all realized forex
         FOR raz_forex
            IN realized_till_prev_month (lic.lic_number, lic.lsl_number)
         LOOP
            /*
            NOC :
            If payment amount is positive then we will reverse the realized forex.
            NEERAJ : KARIM : 18-12-2013
            */
            IF raz_forex.rzf_pay_number IS NOT NULL
            THEN
               SELECT pay_amount
                 INTO l_pay_amount
                 FROM fid_payment
                WHERE pay_number = raz_forex.rzf_pay_number;
            ELSE
               l_pay_amount := 1;
            END IF;

            -- If pay amount is greater than Zero then only we will insert realized forex for that month.
            IF l_pay_amount > 0
            THEN
               -- insert inot realized forex table
               IF raz_forex.rzf_account_head = 'ED'
               THEN
                  insert_realized_forex (raz_forex.rzf_lic_number,
                                         raz_forex.rzf_lsl_number,
                                         raz_forex.rzf_pay_number,
                                         i_current_month,
                                         i_current_year,
                                         -- Reverse the realized forex
                                         -raz_forex.realized_forex,
                                         raz_forex.rzf_account_head,  --'CON',
                                         i_user_id);
               ELSE
                  BEGIN
                     l_refund_amount := 0;
                     l_rem_amount := 0;
                     l_refund_count := 0;

                     SELECT SUM (FRS_RFD_AMOUNT),
                            l_pay_amount - SUM (FRS_RFD_AMOUNT),
                            COUNT (1)
                       INTO l_refund_amount, l_rem_amount, l_refund_count
                       FROM x_fin_refund_settle
                      WHERE FRS_PAY_NUMBER = raz_forex.rzf_pay_number
                            AND frs_year || LPAD (frs_month, 2, 0) <
                                   i_current_year
                                   || LPAD (i_current_month, 2, 0);

                     IF l_refund_count = 0
                     THEN
                        l_refund_amount := 0;
                        l_rem_amount := l_pay_amount;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_refund_amount := 0;
                        l_rem_amount := l_pay_amount;
                  END;

                  IF l_rem_amount > 0
                  THEN
                     l_realized_forex :=
                        (l_rem_amount / l_pay_amount)
                        * raz_forex.realized_forex;

                     insert_realized_forex (raz_forex.rzf_lic_number,
                                            raz_forex.rzf_lsl_number,
                                            raz_forex.rzf_pay_number,
                                            i_current_month,
                                            i_current_year,
                                            -- Reverse the realized forex
                                            -l_realized_forex,
                                            raz_forex.rzf_account_head, --'CON',
                                            i_user_id);
                  END IF;
               END IF;
            END IF;
         END LOOP;                                  -- realized forex loop end

         IF (lic.lic_cancel_date > lic.lic_start_month)
         THEN
            SELECT NVL (SUM (pay_amount), 0)
              INTO payments_till_curr_month
              FROM fid_payment
             WHERE     pay_lic_number = lic.lic_number
                   AND pay_lsl_number = lic.lsl_number
                   AND UPPER (pay_status) = 'P'
                   AND pay_date <= i_todate;

            SELECT NVL (SUM (lis_con_forecast), 0)
              INTO con_forecast_till_curr_month
              FROM fid_license_sub_ledger
             WHERE lis_lic_number = lic.lic_number
                   AND lis_lsl_number = lic.lsl_number
                   AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                          CONCAT (i_current_year,
                                  LPAD (i_current_month, 2, 0));

            license_start_rate :=
               x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                  lic.lic_currency,
                  lic.ter_cur_code,
                  lic.lic_start);

            IF license_start_rate IS NULL
            THEN
               license_start_rate :=
                  x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                     lic.lic_currency,
                     lic.ter_cur_code,
                     i_month_end_rate_date);
            END IF;

            mth_end_date_rate :=
               x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                  lic.lic_currency,
                  lic.ter_cur_code,
                  i_todate);

            IF (con_forecast_till_curr_month - payments_till_curr_month) <> 0
            THEN
               insert_unrealized_forex (
                  lic.lic_number,
                  lic.lsl_number,
                  i_current_month,
                  i_current_year,
                  -- Unrealized forex calculated for CON - Cancelled Licenses
                  -- remaining inventory value into differance of
                  -- license start date minus month end rate
                  ( (con_forecast_till_curr_month - payments_till_curr_month)
                   * (license_start_rate - mth_end_date_rate)),
                  'CON',
                  i_user_id);
            END IF;
         END IF;

         IF UPPER (lic.lic_type) = 'FLF'
         THEN
            -- Payment settlement for the cancelled licenses for FLF
            pre_payment_settlement (lic.lic_number,
                                    lic.lsl_number,
                                    i_current_month,
                                    i_current_year,
                                    i_fromdate,
                                    i_todate,
                                    lic.lic_status,
                                    i_user_id);
         ELSE
            -- Payment settlement for the cancelled licenses for ROY
            pre_payment_settlement_for_roy (lic.lic_number,
                                            lic.lsl_number,
                                            i_current_month,
                                            i_current_year,
                                            i_fromdate,
                                            i_todate,
                                            lic.lic_status,
                                            i_user_id);
         END IF;

         ---------Updating acct date null for the license which cancelled on routine month----------------------
         UPDATE fid_license
            SET lic_acct_date = NULL
          WHERE lic_number = lic.lic_number AND lic_acct_date IS NOT NULL
                AND TO_CHAR (lic_acct_date, 'YYYYMM') =
                       CONCAT (i_current_year, LPAD (i_current_month, 2, 0));
      -----------------------------End license which cancelled on routine month--------------------------------
      
         --Finance Dev Phase I Zeshan [Start]
         SELECT COUNT(LSH_LIC_NUMBER)
         INTO l_lic_cancel_in_om
         FROM x_lic_status_history
         WHERE lsh_lic_number = lic.lic_number
         AND lsh_status_yyyymm = to_number(to_char(i_current_year||lpad(i_current_month,2,0)))
         AND LSH_LIC_STATUS = 'C';
         
         --Is License cancelled in open month?
         IF l_lic_cancel_in_om > 0
         THEN
            --Get last month License start Date
            BEGIN
              SELECT lis_lic_start
                INTO l_old_lic_start
                FROM fid_license_sub_ledger
               WHERE lis_lic_number = lic.lic_number
                 AND lis_per_year || lpad(lis_per_month, 2, 0) = 
                  TO_CHAR (ADD_MONTHS ((TO_DATE ( '01' || TO_CHAR (i_current_month, '09') || TO_CHAR (i_current_year), 'DDMMYYYY')), -1), 'YYYYMM')
                 AND ROWNUM < 2;
              EXCEPTION
              WHEN no_data_found
              THEN
                l_old_lic_start := lic.lic_start;
            END;
            
            l_lis_con_pay := 0;
            l_lis_loc_pay := 0;
            l_lis_pay_mov_flag := 'N';
            
            x_prc_get_lic_mvmt_data(lic.lic_number,lic.lsl_number,l_old_lic_start,l_lis_con_pay,l_lis_loc_pay,l_lis_pay_mov_flag);
            
            UPDATE fid_license_sub_ledger
               SET
                   LIS_PAY_MOV_FLAG = nvl(l_lis_pay_mov_flag,'N'),
                   LIS_CON_PAY = nvl(l_lis_con_pay,0),
                   LIS_LOC_PAY = nvl(l_lis_loc_pay,0)
             WHERE lis_lic_number = lic.lic_number
               AND lis_per_year = i_current_year
               AND lis_per_month = i_current_month;

         END IF;
         --Finance Dev Phase I [End]
      END LOOP;                                            -- License loop end
   END calc_for_cancelled_license;

   -- Pure Finance: Ajit : 22-Mar-2013 : Procedure added for calculation of realized forex
   -- for historical licenses (Licenses starting before Pure Finance Go-live)
   PROCEDURE payment_historical_licenses (
      i_con_number      IN fid_contract.con_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_region          IN VARCHAR2,
      i_user_id         IN VARCHAR2)
   AS
      -- Cursor to get all the payments for the historical licenses
      -- (License start date before the Pure Finance Go-live)
      -- whose payment date is in routine month
      CURSOR payment_curr_month
      IS
         SELECT lic_number,
                pay_number,
                NVL (pay_amount, 0) pay_amount,
                lic_rate,
                pay_rate,
                pay_lsl_number
           FROM fid_license,
                x_fin_lic_sec_lee,
                fid_payment,
                fid_licensee,
                fid_region,
                fid_territory,
                fid_company
          ---WHERE     UPPER (lic_status) <> 'C'
          WHERE     lic_start < (SELECT TO_DATE (content, 'DD-MON-YYYY')
                                   FROM x_fin_configs
                                  WHERE KEY = 'GO-LIVEDATE')
                AND lsl_lic_number = lic_number
                AND pay_lic_number = lic_number
                AND lee_number = lic_lee_number
                AND com_number = lee_cha_com_number
                AND ter_code = com_ter_code
                AND ter_cur_code <> lic_currency
                AND reg_id(+) = lee_split_region
                AND UPPER (NVL (reg_code, '#')) LIKE
                       UPPER (
                          DECODE (i_region,
                                  '%', NVL (reg_code, '#'),
                                  i_region))
                AND lic_con_number = i_con_number
                AND pay_date BETWEEN i_fromdate AND i_todate;
   BEGIN
      -- start the payment loop fro historical licenses whose
      -- payment date is in routine month
      FOR payment IN payment_curr_month
      LOOP
         DELETE FROM x_fin_realized_forex
               WHERE     rzf_lic_number = payment.lic_number
                     AND rzf_pay_number = payment.pay_number
                     AND rzf_lsl_number = payment.pay_lsl_number
                     AND rzf_account_head = 'CON'
                     AND rzf_year || LPAD (rzf_month, 2, 0) >=
                            i_current_year || LPAD (i_current_month, 2, 0);

         -- insert inot realized forex table
         insert_realized_forex (
            payment.lic_number,
            payment.pay_lsl_number,
            payment.pay_number,
            i_current_month,
            i_current_year,
            -- Realized forex = payment amount * (license rate - payment rate)
            (payment.pay_amount * (8.053 - payment.pay_rate)),
            'CON',
            i_user_id);
      END LOOP;                                            -- payment loop end
   END payment_historical_licenses;

   -- Pure Finance: Ajit : 21-Mar-2013 : Procedure added to make old licenses inactive
   PROCEDURE make_lic_inactive (
      i_con_number      IN fid_contract.con_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_user_id         IN VARCHAR2)
   AS
      last_date_of_month   DATE;
      l_com_ter_code       VARCHAR2 (5);

      CURSOR c_lic_lsl (
         last_date DATE)
      IS
         SELECT lic_number,
                lic_type,
                lic_rate,
                lic_chs_number,
                lsl_number,
                NVL (lsl_lee_price, 0) lsl_lee_price,
                lic_start,
                lic_end
           FROM fid_license, x_fin_lic_sec_lee
          WHERE     lic_end < ADD_MONTHS (last_date, -6)
                AND UPPER (lic_status) NOT IN ('R', 'I')
                AND lic_con_number = i_con_number
                AND lic_number = lsl_lic_number
                AND fid_cos_pk.check_rem_inv_liab (lic_number,
                                                   i_current_month,
                                                   i_current_year) = 0;

      CURSOR c_lic_sub_ledger (
         l_lic_number    NUMBER,
         l_lsl_number    NUMBER,
         l_ter_code      VARCHAR2)
      IS
         SELECT NVL (SUM (lis_pv_con_forecast), 0)
                   total_pv_inv_till_last_month,
                NVL (SUM (lis_pv_loc_forecast), 0)
                   total_pv_loc_inv_till_last_mth,
                NVL (SUM (lis_pv_con_inv_actual), 0)
                   pv_con_inv_act_till_lst_mth,
                NVL (SUM (lis_pv_con_liab_actual), 0)
                   pv_con_liab_act_till_lst_mth,
                NVL (SUM (lis_pv_loc_inv_actual), 0)
                   pv_loc_inv_act_till_lst_mth,
                NVL (SUM (lis_pv_loc_liab_actual), 0)
                   pv_loc_liab_act_till_lst_mth,
                NVL (SUM (lis_ed_loc_forecast), 0)
                   total_ed_inv_till_last_month,
                NVL (SUM (lis_ed_loc_actual), 0) total_ed_act_till_last_month,
                --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                NVL (SUM (LIS_ASSET_ADJ_VALUE), 0)
                   Tot_adj_val_till_last_month,
                NVL (SUM (LIS_MEAN_SUBSCRIBER), 0) Tot_mean_subscriber,
                NVL (SUM (LIS_MG_PV_CON_FORECAST), 0)
                   tot_mgpv_con_inv_till_lst_mth,
                NVL (SUM (LIS_MG_PV_LOC_FORECAST), 0)
                   tot_mgpv_loc_inv_till_lst_mth,
                NVL (SUM (LIS_LOC_ASSET_ADJ_VALUE), 0)
                   Tot_loc_adj_val_till_lst_mth,
                NVL (SUM (LIS_MG_PV_CON_LIAB), 0) Tot_mgpv_con_liab,
                NVL (SUM (LIS_MG_PV_LOC_LIAB), 0) Tot_mgpv_loc_liab
           FROM fid_license_sub_ledger
          WHERE     lis_lic_number = l_lic_number
                AND lis_lsl_number = l_lsl_number
                AND lis_ter_code = l_ter_code
                AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                       i_current_year || LPAD (i_current_month, 2, 0);

      c_sub_ledger         c_lic_sub_ledger%ROWTYPE;

      CURSOR cht_c (
         licchsnumber NUMBER)
      IS
         SELECT DISTINCT cht_ter_code
           FROM fid_channel_territory
          WHERE ( (cht_cha_number = licchsnumber)
                 OR EXISTS
                       (SELECT 'X'
                          FROM fid_channel_service
                         WHERE chs_number = licchsnumber
                               AND chs_cha_number = cht_cha_number
                        UNION
                        SELECT 'X'
                          FROM fid_channel_service_channel
                         WHERE     csc_chs_number = licchsnumber
                               AND csc_cha_number = cht_cha_number
                               AND csc_include_subs = 'Y'
                               AND TO_CHAR (csc_end_dt, 'YYYYMM') >=
                                      i_current_year
                                      || LPAD (i_current_month, 2, 0)));

      cht                  cht_c%ROWTYPE;
   BEGIN
      -- get the last date of the month
      last_date_of_month :=
         LAST_DAY (
            TO_DATE (
                  '01'
               || TO_CHAR (i_current_month, '09')
               || TO_CHAR (i_current_year),
               'DDMMYYYY'));

      FOR c_lic IN c_lic_lsl (last_date_of_month)
      LOOP
         IF (UPPER (c_lic.lic_type) = 'FLF')
         THEN
            SELECT com.com_ter_code
              INTO l_com_ter_code
              FROM fid_license lic, fid_licensee lee, fid_company com
             WHERE     lic.lic_lee_number = lee.lee_number
                   AND lee.lee_cha_com_number = com.com_number
                   AND lic.lic_number = c_lic.lic_number;

            OPEN c_lic_sub_ledger (c_lic.lic_number,
                                   c_lic.lsl_number,
                                   l_com_ter_code);

            FETCH c_lic_sub_ledger INTO c_sub_ledger;

            IF ( (NVL (c_sub_ledger.total_pv_inv_till_last_month, 0)
                  - NVL (c_sub_ledger.pv_con_inv_act_till_lst_mth, 0)) <> 0
                OR (NVL (c_sub_ledger.total_pv_inv_till_last_month, 0)
                    - NVL (c_sub_ledger.pv_con_liab_act_till_lst_mth, 0)) <>
                      0
                OR (NVL (c_sub_ledger.total_pv_loc_inv_till_last_mth, 0)
                    - NVL (c_sub_ledger.pv_loc_inv_act_till_lst_mth, 0)) <> 0
                OR (NVL (c_sub_ledger.total_pv_loc_inv_till_last_mth, 0)
                    - NVL (c_sub_ledger.pv_loc_liab_act_till_lst_mth, 0)) <>
                      0
                OR (NVL (c_sub_ledger.total_ed_inv_till_last_month, 0)
                    - NVL (c_sub_ledger.total_ed_act_till_last_month, 0)) <>
                      0)
            THEN
               --27Mar2015:Ver 0.2 START P1 Issue : Jawahar Garg - con_forecast is not updating after costing routine run in case of 'C'
               BEGIN
                  SELECT *
                    INTO v_lic_sub_ledger_rec
                    FROM fid_license_sub_ledger
                   WHERE     lis_lic_number = c_lic.lic_number
                         AND lis_lsl_number = c_lic.lsl_number
                         AND lis_ter_code = l_com_ter_code
                         AND lis_per_year = i_current_year
                         AND lis_per_month = i_current_month;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_lic_sub_ledger_rec.lis_ed_loc_forecast := 0;
                     v_lic_sub_ledger_rec.lis_pv_con_forecast := 0;
                     v_lic_sub_ledger_rec.lis_pv_loc_forecast := 0;
                     v_lic_sub_ledger_rec.lis_con_forecast := 0;
                     v_lic_sub_ledger_rec.lis_loc_forecast := 0;
               END;

               ----27Mar2015:Ver 0.2 End;

               insert_update_sub_ledger (
                  c_lic.lic_number,
                  c_lic.lsl_number,
                  l_com_ter_code,
                  i_current_year,
                  i_current_month,
                  c_lic.lsl_lee_price,
                  1,                                           --adjust factor
                  c_lic.lic_rate,
                  c_lic.lic_rate,
                  0,                                         --paid exhibition
                  v_lic_sub_ledger_rec.lis_con_forecast, --0,--i_lis_con_forecast        /*ver 0.2 commented 0 and added actual value*/
                  v_lic_sub_ledger_rec.lis_loc_forecast, --0,--i_lis_loc_forecast        /*ver 0.2 commented 0 and added actual value*/
                  0,                                                --con_calc
                  0,                                                --loc_calc
                  0,
                  --con_actual
                  0,
                  --loc_actual
                  0,
                  --con_adjust
                  0,
                  --loc_adjust
                  0,
                  --con_writeoff
                  0,
                  --loc_writeoff
                  v_lic_sub_ledger_rec.lis_pv_con_forecast, --0, --i_lis_pv_con_forecast    /*ver 0.2 commented 0 and added actual value*/
                  v_lic_sub_ledger_rec.lis_pv_loc_forecast, --0, --i_lis_pv_loc_forecast    /*ver 0.2 commented 0 and added actual value*/
                  NVL (c_sub_ledger.total_pv_inv_till_last_month, 0)
                  - NVL (c_sub_ledger.pv_con_inv_act_till_lst_mth, 0),
                  --pv_con_inv_actual
                  NVL (c_sub_ledger.total_pv_inv_till_last_month, 0)
                  - NVL (c_sub_ledger.pv_con_liab_act_till_lst_mth, 0),
                  --pv_con_liability_actual
                  NVL (c_sub_ledger.total_pv_loc_inv_till_last_mth, 0)
                  - NVL (c_sub_ledger.pv_loc_inv_act_till_lst_mth, 0),
                  --pv_loc_inv_actual
                  NVL (c_sub_ledger.total_pv_loc_inv_till_last_mth, 0)
                  - NVL (c_sub_ledger.pv_loc_liab_act_till_lst_mth, 0),
                  --pv_loc_liability_actual
                  v_lic_sub_ledger_rec.lis_ed_loc_forecast, --0,--i_lis_ed_loc_forecast    /*ver 0.2 commented 0 and added actual value*/
                  NVL (c_sub_ledger.total_ed_inv_till_last_month, 0)
                  - NVL (c_sub_ledger.total_ed_act_till_last_month, 0),
                  --ed_loc_actual
                  0,
                  --con_unforseen
                  0,
                  --loc_unforseen
                  --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                  0, --c_sub_ledger.Tot_adj_val_till_last_month,  --Revaluation value in case of mg for roy
                  c_lic.lic_start,
                  c_lic.lic_end,
                  0,
                  0, --c_sub_ledger.tot_mgpv_con_inv_till_lst_mth, --pv mg con inventory
                  0, --c_sub_ledger.tot_mgpv_loc_inv_till_lst_mth, --pv mg loc inventory
                  0, --c_sub_ledger.Tot_loc_adj_val_till_lst_mth, --Loc revaluation value in case of mg for roy
                  0,                          --Mg pv con liab for mg payments
                  0,                          --Mg pv loc liab for mg payments
                  --END [BR_15_144-Finance CRs:New Payment Plan]
                  i_user_id,
                  NULL,	--Dev : Fin CR: [Devashish Raverkar]_[2016/05/23]
                  null,
                  null,
                  null,
                  null,
                  null,
                  null);
            END IF;

            CLOSE c_lic_sub_ledger;
         ELSE
            FOR cht IN cht_c (c_lic.lic_chs_number)
            LOOP
               OPEN c_lic_sub_ledger (c_lic.lic_number,
                                      c_lic.lsl_number,
                                      cht.cht_ter_code);

               FETCH c_lic_sub_ledger INTO c_sub_ledger;

               IF ( (NVL (c_sub_ledger.total_pv_inv_till_last_month, 0)
                     - NVL (c_sub_ledger.pv_con_inv_act_till_lst_mth, 0)) <>
                      0
                   OR (NVL (c_sub_ledger.total_pv_inv_till_last_month, 0)
                       - NVL (c_sub_ledger.pv_con_liab_act_till_lst_mth, 0)) <>
                         0
                   OR (NVL (c_sub_ledger.total_pv_loc_inv_till_last_mth, 0)
                       - NVL (c_sub_ledger.pv_loc_inv_act_till_lst_mth, 0)) <>
                         0
                   OR (NVL (c_sub_ledger.total_pv_loc_inv_till_last_mth, 0)
                       - NVL (c_sub_ledger.pv_loc_liab_act_till_lst_mth, 0)) <>
                         0
                   OR (NVL (c_sub_ledger.total_ed_inv_till_last_month, 0)
                       - NVL (c_sub_ledger.total_ed_act_till_last_month, 0)) <>
                         0)
               THEN
                  --27Mar2015 :Ver 0.2 : START P1 Issue : Jawahar Garg - con_forecast is not updating after costing routine run in case of 'C'
                  BEGIN
                     SELECT *
                       INTO v_lic_sub_ledger_rec
                       FROM fid_license_sub_ledger
                      WHERE     lis_lic_number = c_lic.lic_number
                            AND lis_lsl_number = c_lic.lsl_number
                            AND lis_ter_code = cht.cht_ter_code
                            AND lis_per_year = i_current_year
                            AND lis_per_month = i_current_month;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_lic_sub_ledger_rec.lis_ed_loc_forecast := 0;
                        v_lic_sub_ledger_rec.lis_pv_con_forecast := 0;
                        v_lic_sub_ledger_rec.lis_pv_loc_forecast := 0;
                        v_lic_sub_ledger_rec.lis_con_forecast := 0;
                        v_lic_sub_ledger_rec.lis_loc_forecast := 0;
                  END;

                  --27Mar2015:Ver 0.2 End.

                  insert_update_sub_ledger (
                     c_lic.lic_number,
                     c_lic.lsl_number,
                     cht.cht_ter_code,
                     i_current_year,
                     i_current_month,
                     c_lic.lsl_lee_price,
                     1,                                        --adjust factor
                     c_lic.lic_rate,
                     c_lic.lic_rate,
                     0,                                      --paid exhibition
                     v_lic_sub_ledger_rec.lis_con_forecast, --0,--i_lis_con_forecast        /*ver 0.2 commented 0 and added actual value*/
                     v_lic_sub_ledger_rec.lis_loc_forecast, --0,--i_lis_loc_forecast        /*ver 0.2 commented 0 and added actual value*/
                     0,                                             --con_calc
                     0,                                             --loc_calc
                     0,
                     --con_actual
                     0,
                     --loc_actual
                     0,
                     --con_adjust
                     0,
                     --loc_adjust
                     0,
                     --con_writeoff
                     0,
                     --loc_writeoff
                     v_lic_sub_ledger_rec.lis_pv_con_forecast, --0,--i_lis_pv_con_forecast        /*ver 0.2 commented 0 and added actual value*/
                     v_lic_sub_ledger_rec.lis_pv_loc_forecast, --0,--i_lis_pv_loc_forecast        /*ver 0.2 commented 0 and added actual value*/
                     NVL (c_sub_ledger.total_pv_inv_till_last_month, 0)
                     - NVL (c_sub_ledger.pv_con_inv_act_till_lst_mth, 0),
                     --pv_con_inv_actual
                     NVL (c_sub_ledger.total_pv_inv_till_last_month, 0)
                     - NVL (c_sub_ledger.pv_con_liab_act_till_lst_mth, 0),
                     --pv_con_liability_actual
                     NVL (c_sub_ledger.total_pv_loc_inv_till_last_mth, 0)
                     - NVL (c_sub_ledger.pv_loc_inv_act_till_lst_mth, 0),
                     --pv_loc_inv_actual
                     NVL (c_sub_ledger.total_pv_loc_inv_till_last_mth, 0)
                     - NVL (c_sub_ledger.pv_loc_liab_act_till_lst_mth, 0),
                     --pv_loc_liability_actual
                     v_lic_sub_ledger_rec.lis_ed_loc_forecast, --0,--i_lis_ed_loc_forecast        /*ver 0.2 commented 0 and added actual value*/
                     NVL (c_sub_ledger.total_ed_inv_till_last_month, 0)
                     - NVL (c_sub_ledger.total_ed_act_till_last_month, 0),
                     --ed_loc_actual
                     0,
                     --con_unforseen
                     0,
                     --loc_unforseen
                     --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                     c_sub_ledger.Tot_adj_val_till_last_month, --Revaluation value in case of mg for roy
                     c_lic.lic_start,
                     c_lic.lic_end,
                     0,
                     c_sub_ledger.tot_mgpv_con_inv_till_lst_mth, --pv mg con inventory
                     c_sub_ledger.tot_mgpv_loc_inv_till_lst_mth, --pv mg loc inventory
                     c_sub_ledger.Tot_loc_adj_val_till_lst_mth, --Loc Revaluation value in case of mg for roy
                     c_sub_ledger.Tot_mgpv_con_liab, --Mg pv con liab for mg payments
                     c_sub_ledger.Tot_mgpv_loc_liab, --Mg pv con liab for mg payments
                     --END [BR_15_144-Finance CRs:New Payment Plan]
                     i_user_id,
                     NULL,
                     null,
                     null,
                     null,
                     null,
                     null,
                     null);	--Dev : Fin CR: [Devashish Raverkar]_[2016/05/23]
               END IF;

               CLOSE c_lic_sub_ledger;
            END LOOP;
         END IF;
      END LOOP;

      -- Make the all licenses inactive whose license end date is
      -- before 6 month, license status is not already inactive and
      -- R and remaining invetory and remaining liability is not eqaul to 0
      UPDATE fid_license
         SET lic_status = 'I',
             lic_play_status = '+',
             lic_entry_oper = i_user_id
       WHERE     lic_end < ADD_MONTHS (last_date_of_month, -6)
             AND lic_status NOT IN ('R', 'I', 'C')
             AND lic_con_number = i_con_number
             AND check_rem_inv_liab (lic_number,
                                     i_current_month,
                                     i_current_year) = 0;
   END make_lic_inactive;

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to identify costed schedules in routine month
   PROCEDURE identify_costed_schedules (i_sch_lic_number   IN NUMBER,
                                        i_curr_month       IN NUMBER,
                                        i_curr_year        IN NUMBER,
                                        i_user             IN VARCHAR2)
   AS
      c_previous_month                 NUMBER;
      c_previous_year                  NUMBER;
      c_lic_showing_lic                NUMBER;
      c_no_of_sch_on_paid_channel      NUMBER;
      c_is_bioscope_lee                NUMBER;
      c_no_of_costed_ind               NUMBER;
      c_no_cost_prev_mnt_sub_led       NUMBER;
      c_no_of_costed_sch_prev_ind      NUMBER;
      c_no_lic_sch_prev_mth            NUMBER;
      c_no_runs_sch_prev_mth           NUMBER;
      c_costed_runs_on_sw              NUMBER;
      c_costed_runs_on_cha             NUMBER;
      c_total_cost_runs_remain         NUMBER;
      c_no_lic_sch_bw_sw2_ldprev_mnt   NUMBER;
      c_costed_sch_bw_sw2_ldprev_mnt   NUMBER;
      l_paid_run_limit                 NUMBER;
      l_used_paid_run                  NUMBER;
      l_lic_start                      fid_license.lic_start%TYPE;
      l_lic_end                        fid_license.lic_end%TYPE;
      l_alloc_costed_runs              x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
      l_sch_window                     x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
      l_sw1_start                      x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_sw1_end                        x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_sw2_start                      x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_sw2_end                        x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_5_2_go_live_date               DATE;
      l_cw1_costed_runs                x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
      l_costed_runs_cost_schedules     NUMBER := 0;

      --SCH_FIN_ACTUAL_DATE:-IF THE SCHEDULE TIME IS BETWEEN 0 AND CHANNEL START TIME THEN
      --SCH_FIN_ACTUAL_DATE=SCH_DATE+1 ELSE IT WILL BE THE SAME AS SCH_DATE
      --get Not Paid schedules on costed channel and schedule number not in
      --costed schedule table
      CURSOR cost_not_paid_sch (
         l_sch_lic_number NUMBER)
      IS
           SELECT sch_lic_number,
                  sch_number,
                  sch_cha_number,
                  sch_fin_actual_date
             FROM fid_schedule, fid_license_channel_runs
            WHERE     sch_lic_number = lcr_lic_number
                  AND sch_cha_number = lcr_cha_number
                  AND sch_lic_number = l_sch_lic_number
                  AND UPPER (sch_type) = 'N'
                  AND UPPER (lcr_cost_ind) = 'Y'
                  AND sch_fin_actual_date <
                         TO_DATE (
                               '01'
                            || LPAD (TO_CHAR (i_curr_month), 2, '0')
                            || i_curr_year,
                            'DDMMYYYY')
                  AND sch_number NOT IN
                         (SELECT csh_sch_number
                            FROM x_fin_cost_schedules
                           WHERE csh_lic_number = l_sch_lic_number)
         ORDER BY sch_fin_actual_date, sch_time, sch_number;

      CURSOR cost_paid_notpaid_sch (
         l_sch_lic_number NUMBER)
      IS
           SELECT sch_lic_number,
                  sch_number,
                  sch_cha_number,
                  sch_fin_actual_date,
                  NVL (csh_sch_number, 0) csh_sch_number
             FROM fid_schedule, fid_license_channel_runs, x_fin_cost_schedules
            WHERE     sch_lic_number = lcr_lic_number
                  AND sch_number = csh_sch_number(+)
                  AND UPPER (sch_type) IN ('P', 'N')
                  AND sch_cha_number = lcr_cha_number
                  AND sch_lic_number = l_sch_lic_number
                  AND sch_fin_actual_date <
                         LAST_DAY (
                            TO_DATE (
                                  '01'
                               || LPAD (TO_CHAR (i_curr_month), 2, '0')
                               || i_curr_year,
                               'DDMMYYYY'))
                         + 1
         ORDER BY sch_fin_actual_date, sch_time, sch_number;

      --Loop for paid schedules for current month on costed tick channels
      CURSOR cost_paid_sch (
         l_sch_lic_number NUMBER)
      IS
           SELECT sch_lic_number,
                  sch_number,
                  sch_cha_number,
                  sch_fin_actual_date
             FROM fid_schedule, fid_license_channel_runs
            WHERE     sch_lic_number = lcr_lic_number
                  AND sch_cha_number = lcr_cha_number
                  AND sch_lic_number = l_sch_lic_number
                  AND UPPER (sch_type) = 'P'
                  AND UPPER (lcr_cost_ind) = 'Y'
                  AND sch_fin_actual_date BETWEEN TO_DATE (
                                                     '01'
                                                     || LPAD (
                                                           TO_CHAR (
                                                              i_curr_month),
                                                           2,
                                                           '0')
                                                     || i_curr_year,
                                                     'DDMMYYYY')
                                              AND LAST_DAY (
                                                     TO_DATE (
                                                        '01'
                                                        || LPAD (
                                                              TO_CHAR (
                                                                 i_curr_month),
                                                              2,
                                                              '0')
                                                        || i_curr_year,
                                                        'DDMMYYYY'))
         ORDER BY sch_fin_actual_date, sch_time, sch_number;

      --get the costed channel for license
      CURSOR cost_ind_per_lic (
         l_sch_lic_number NUMBER)
      IS
         SELECT lcr_lic_number,
                lcr_cha_number,
                lcr_sch_start_date2,
                lcr_cha_costed_runs,
                lcr_cha_costed_runs2
           FROM fid_license_channel_runs
          WHERE lcr_lic_number = l_sch_lic_number
                AND UPPER (lcr_cost_ind) = 'Y';

      --Loop for each not paid schedules till previous month and schedule number not in
      --costed schedule table and schedule on channel with properly costed for either
      --sch_wind1 or sch_wind2 ='N'
      CURSOR not_paid_sch_prev_mth (
         l_sch_lic_number NUMBER)
      IS
           SELECT sch_number,
                  sch_lic_number,
                  sch_type,
                  sch_fin_actual_date,
                  sch_cha_number,
                  lcr_cha_costed_runs,
                  lcr_cha_costed_runs2,
                  lcr_is_sch_pro_costed2,
                  lcr_is_sch_pro_costed,
                  lcr_sch_start_date,
                  lcr_sch_end_date,
                  lcr_sch_start_date2,
                  lcr_sch_end_date2
             FROM fid_schedule, fid_license_channel_runs
            WHERE     sch_lic_number = lcr_lic_number
                  AND sch_cha_number = lcr_cha_number
                  AND sch_lic_number = l_sch_lic_number
                  --please check the costed tick condition
                  AND UPPER (lcr_cost_ind) = 'Y'
                  AND UPPER (sch_type) = 'N'
                  AND (UPPER ( (NVL (lcr_is_sch_pro_costed, '#'))) = 'N'
                       OR UPPER (NVL (lcr_is_sch_pro_costed2, '#')) = 'N')
                  AND sch_fin_actual_date <
                         TO_DATE (
                               '01'
                            || LPAD (TO_CHAR (i_curr_month), 2, '0')
                            || i_curr_year,
                            'DDMMYYYY')
                  AND sch_number NOT IN
                         (SELECT NVL (csh_sch_number, 0)
                            FROM x_fin_cost_schedules
                           WHERE csh_lic_number = l_sch_lic_number)
         ORDER BY sch_fin_actual_date, sch_time, sch_number;
   BEGIN
      c_total_cost_runs_remain := 0;

      --delete all the costed schedules for license of current routine period
      --if exist
      DELETE FROM x_fin_cost_schedules
            WHERE csh_lic_number = i_sch_lic_number
                  AND csh_year || LPAD (csh_month, 2, 0) >=
                         CONCAT (i_curr_year, LPAD (i_curr_month, 2, 0));


      SELECT content
        INTO l_5_2_go_live_date
        FROM x_fin_configs
       --where key ='COSTING_5+2_GO_LIVE_DATE'
       WHERE ID = 6;

      IF i_curr_month = 1
      THEN
         c_previous_month := 12;
         c_previous_year := i_curr_year - 1;
      ELSE
         c_previous_month := i_curr_month - 1;
         c_previous_year := i_curr_year;
      END IF;

      --get the number of costed runs for license
      SELECT lic_showing_lic, lic_start, lic_end
        INTO c_lic_showing_lic, l_lic_start, l_lic_end
        FROM fid_license
       WHERE lic_number = i_sch_lic_number;

      --check if license is bioscope or non bioscope
      SELECT COUNT (*)
        INTO c_is_bioscope_lee
        FROM fid_license
       WHERE lic_lee_number IN (SELECT lee_number
                                  FROM fid_licensee
                                 WHERE NVL (UPPER (lee_bioscope_flag),
                                            'N') = 'Y')
             AND UPPER (lic_budget_code) IN
                    (SELECT UPPER (cpt_gen_type) FROM sgy_pb_costed_prog_type)
             AND UPPER (lic_amort_code) = 'D'
             AND lic_number = i_sch_lic_number;

      --get the no of costed runs till previous month from Subledger
      SELECT NVL (SUM (lis_paid_exhibition), 0)
        INTO c_no_cost_prev_mnt_sub_led
        FROM (SELECT DISTINCT lis_paid_exhibition,
                              lis_per_month,
                              lis_per_year,
                              lis_lic_number
                FROM fid_license_sub_ledger
               WHERE lis_lic_number = i_sch_lic_number
                     AND lis_paid_exhibition <> 0
                     AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                            CONCAT (c_previous_year,
                                    LPAD (c_previous_month, 2, 0)));

      --get the number of runs on costed Tick channel till prev month
      SELECT COUNT (*)
        INTO c_no_of_sch_on_paid_channel
        FROM fid_schedule, fid_license_channel_runs
       WHERE     sch_lic_number = lcr_lic_number
             AND sch_cha_number = lcr_cha_number
             AND sch_lic_number = i_sch_lic_number
             AND sch_fin_actual_date <
                    TO_DATE (
                          '01'
                       || LPAD (TO_CHAR (i_curr_month), 2, '0')
                       || i_curr_year,
                       'DDMMYYYY')
             AND UPPER (lcr_cost_ind) = 'Y'
             AND UPPER (sch_type) IN ('P', 'N');

      --get the costed runs remaining at license level
      IF (c_no_cost_prev_mnt_sub_led < c_lic_showing_lic)
      THEN
         --calculate the remaining runs to be costed
         c_total_cost_runs_remain :=
            c_lic_showing_lic - c_no_cost_prev_mnt_sub_led;
      ELSE
         c_total_cost_runs_remain := 0;
      END IF;

      --check if costed runs remain at license level
      IF (c_no_cost_prev_mnt_sub_led < c_lic_showing_lic)                  --1
      THEN
         IF l_lic_start >= l_5_2_go_live_date
         THEN
            l_used_paid_run := 0;

            FOR sch_p_np IN cost_paid_notpaid_sch (i_sch_lic_number)
            LOOP
               pkg_pb_fid_schedver_pk.prc_cost_rule_config_info (
                  i_sch_lic_number,
                  l_lic_start,
                  l_lic_end,
                  sch_p_np.sch_fin_actual_date,
                  c_lic_showing_lic,
                  l_alloc_costed_runs,
                  l_sch_window,
                  l_sw1_start,
                  l_sw1_end,
                  l_sw2_start,
                  l_sw2_end,
                  l_cw1_costed_runs);

               IF l_sch_window = 1
               THEN
                  l_paid_run_limit := l_alloc_costed_runs;
               ELSE
                  l_paid_run_limit := c_lic_showing_lic;
               END IF;

               SELECT COUNT (*)
                 INTO l_costed_runs_cost_schedules
                 FROM x_fin_cost_schedules, FID_CHANNEL
                WHERE CSH_CHA_NUMBER = CHA_NUMBER
                      AND CSH_LIC_NUMBER = i_sch_lic_number
                      AND TO_NUMBER (TO_CHAR (CSH_SCH_DATE, 'YYYYMM')) <
                             (I_CURR_YEAR || LPAD (I_CURR_MONTH, 2, 0))
                      AND TO_NUMBER (TO_CHAR (CSH_SCH_DATE, 'YYYYMM')) <=
                             TO_NUMBER (TO_CHAR (l_sw1_end, 'YYYYMM'));


               IF l_costed_runs_cost_schedules > l_paid_run_limit
               THEN
                  l_used_paid_run := l_costed_runs_cost_schedules;
               END IF;

               IF l_paid_run_limit > l_used_paid_run
               THEN
                  IF sch_p_np.csh_sch_number > 0
                  THEN
                     NULL;
                  ELSE
                     insert_costed_schedules (sch_p_np.sch_number,
                                              sch_p_np.sch_lic_number,
                                              sch_p_np.sch_cha_number,
                                              sch_p_np.sch_fin_actual_date,
                                              i_curr_month,
                                              i_curr_year,
                                              i_user);
                  END IF;

                  l_used_paid_run := l_used_paid_run + 1;
               ELSE
                  IF sch_p_np.sch_fin_actual_date BETWEEN TO_DATE (
                                                             i_curr_year
                                                             || i_curr_month,
                                                             'YYYYMM')
                                                      AND LAST_DAY (
                                                             TO_DATE (
                                                                i_curr_year
                                                                || i_curr_month,
                                                                'YYYYMM'))
                  THEN
                     UPDATE fid_schedule
                        SET sch_type = 'N'
                      WHERE     sch_number = sch_p_np.sch_number
                            AND sch_lic_number = sch_p_np.sch_lic_number
                            AND sch_type = 'P';
                  END IF;
               END IF;
            END LOOP;
         ELSE
            IF (c_is_bioscope_lee != 1)                                    --2
            THEN
               --this block checks the Not Paid schedules of costed tick channels
               --which needs to be costed as per new costing rule and insert the
               --same in X_FIN_COST_SCHEDULES.
               IF (c_no_of_sch_on_paid_channel > c_no_cost_prev_mnt_sub_led) --6
               THEN
                  --Loop N paid sch on costed channel and sch_number not in costed schedule table
                  FOR l_cost_not_paid_sch
                     IN cost_not_paid_sch (i_sch_lic_number)
                  LOOP
                     IF c_total_cost_runs_remain > 0                       --7
                     THEN
                        --insert the schedule  in X_FIN_COST_SCHEDULES
                        insert_costed_schedules (
                           l_cost_not_paid_sch.sch_number,
                           l_cost_not_paid_sch.sch_lic_number,
                           l_cost_not_paid_sch.sch_cha_number,
                           l_cost_not_paid_sch.sch_fin_actual_date,
                           i_curr_month,
                           i_curr_year,
                           i_user);
                        --descrement remaining costed runs by 1
                        c_total_cost_runs_remain :=
                           c_total_cost_runs_remain - 1;
                        EXIT WHEN c_total_cost_runs_remain = 0;
                     END IF;                                               --7
                  END LOOP;
               END IF;                                                     --6

               --Loop 'P' sch on costed channel  for current month
               FOR l_cost_paid_sch IN cost_paid_sch (i_sch_lic_number)
               LOOP
                  IF (c_total_cost_runs_remain > 0)                        --8
                  THEN
                     --insert the paid schedule of current month in costed schedule table
                     insert_costed_schedules (
                        l_cost_paid_sch.sch_number,
                        l_cost_paid_sch.sch_lic_number,
                        l_cost_paid_sch.sch_cha_number,
                        l_cost_paid_sch.sch_fin_actual_date,
                        i_curr_month,
                        i_curr_year,
                        i_user);
                     --descrement remaining costed runs by 1
                     c_total_cost_runs_remain := c_total_cost_runs_remain - 1;
                  --exit when c_total_cost_runs_remain = 0;
                  ELSE
                     UPDATE fid_schedule
                        SET sch_type = 'N'
                      WHERE sch_number = l_cost_paid_sch.sch_number
                            AND sch_lic_number =
                                   l_cost_paid_sch.sch_lic_number;
                  END IF;                                                  --8
               END LOOP;
            ELSE
               --this block checks the Not Paid schedules till prev months
               --per channel per license of costed tick channels
               --which needs to be costed as per new costing rule and insert the
               --same in costed schedule table
               IF (c_no_of_sch_on_paid_channel > c_no_cost_prev_mnt_sub_led) --6
               THEN
                  --Loop for each costed ticked channel for each License
                  FOR l_cost_ind IN cost_ind_per_lic (i_sch_lic_number)
                  LOOP
                     c_no_of_costed_sch_prev_ind := 0;
                     c_no_runs_sch_prev_mth := 0;

                     --set properly costed ticked for channel of a License to 'Y'
                     UPDATE fid_license_channel_runs
                        SET lcr_is_sch_pro_costed = 'Y',
                            lcr_is_sch_pro_costed2 = 'Y'
                      WHERE lcr_lic_number = l_cost_ind.lcr_lic_number
                            AND lcr_cha_number = l_cost_ind.lcr_cha_number;

                     --Scheduling window 1 conciliation
                     IF l_cost_ind.lcr_sch_start_date2 IS NULL
                        OR l_cost_ind.lcr_sch_start_date2 >=
                              TO_DATE (
                                    '01'
                                 || LPAD (TO_CHAR (i_curr_month), 2, '0')
                                 || i_curr_year,
                                 'DDMMYYYY')
                     THEN
                        --get the number of runs already costed on channel till prev
                        --month from costed schedule table
                        SELECT COUNT (*)
                          INTO c_no_of_costed_sch_prev_ind
                          FROM x_fin_cost_schedules
                         WHERE csh_lic_number = l_cost_ind.lcr_lic_number
                               AND csh_cha_number = l_cost_ind.lcr_cha_number
                               AND CONCAT (csh_year, LPAD (csh_month, 2, 0)) <=
                                      CONCAT (i_curr_year,
                                              LPAD (i_curr_month, 2, 0));

                        --IF c_no_of_costed_sch_prev_ind < l_cost_ind.lcr_cha_costed_runs
                        IF c_no_of_costed_sch_prev_ind <
                              NVL (l_cost_ind.lcr_cha_costed_runs, 0)
                        THEN
                           --get the number of schedules on channel till previous month \\ P N
                           SELECT COUNT (*)
                             INTO c_no_runs_sch_prev_mth
                             FROM fid_schedule
                            WHERE sch_lic_number = l_cost_ind.lcr_lic_number
                                  AND sch_cha_number =
                                         l_cost_ind.lcr_cha_number
                                  --Africa Free Repeat[Mangesh_Gulhane][15-MAR-2013]
                                  --to exclude free runs from schedules
                                  AND UPPER (sch_type) IN ('P', 'N')
                                  --END  Africa Free Repeat
                                  AND sch_fin_actual_date <
                                         TO_DATE (
                                            '01'
                                            || LPAD (TO_CHAR (i_curr_month),
                                                     2,
                                                     '0')
                                            || i_curr_year,
                                            'DDMMYYYY');
                        ELSE
                           --update is_sch_properly_costed to 'Y' for sch_window1
                           update_is_sch_properly_costed (
                              l_cost_ind.lcr_lic_number,
                              l_cost_ind.lcr_cha_number,
                              'Y',
                              1);
                        END IF;
                     ELSE
                        --Get the number of runs already costed and sch date before start of sch_window 2
                        --from costed schedule table
                        SELECT COUNT (*)
                          INTO c_no_of_costed_sch_prev_ind
                          FROM x_fin_cost_schedules
                         WHERE csh_lic_number = l_cost_ind.lcr_lic_number
                               AND csh_cha_number = l_cost_ind.lcr_cha_number
                               AND csh_sch_date <
                                      l_cost_ind.lcr_sch_start_date2;

                        --IF c_no_of_costed_sch_prev_ind < l_cost_ind.lcr_cha_costed_runs
                        IF c_no_of_costed_sch_prev_ind <
                              NVL (l_cost_ind.lcr_cha_costed_runs, 0)
                        THEN
                           --Get the number of runs schedule prior to sch w2 start date // P N
                           SELECT COUNT (*)
                             INTO c_no_runs_sch_prev_mth
                             FROM fid_schedule
                            WHERE sch_lic_number = l_cost_ind.lcr_lic_number
                                  AND sch_cha_number =
                                         l_cost_ind.lcr_cha_number
                                  --Africa Free Repeat[Mangesh_Gulhane][15-MAR-2013]
                                  --to exclude free runs from schedules
                                  AND UPPER (sch_type) IN ('P', 'N')
                                  --END  Africa Free Repeat
                                  AND sch_fin_actual_date <
                                         l_cost_ind.lcr_sch_start_date2;
                        ELSE
                           --update is_sch_properly_costed to 'Y' for sch_window1
                           update_is_sch_properly_costed (
                              l_cost_ind.lcr_lic_number,
                              l_cost_ind.lcr_cha_number,
                              'Y',
                              1);
                        END IF;
                     END IF;

                     IF c_no_runs_sch_prev_mth > c_no_of_costed_sch_prev_ind
                        AND c_no_of_costed_sch_prev_ind <
                               NVL (l_cost_ind.lcr_cha_costed_runs, 0)
                     THEN
                        --update is_sch_properly_costed to 'N' for sch_window1
                        update_is_sch_properly_costed (
                           l_cost_ind.lcr_lic_number,
                           l_cost_ind.lcr_cha_number,
                           'N',
                           1);
                     ELSE
                        --update is_sch_properly_costed to 'Y' for sch_window1
                        update_is_sch_properly_costed (
                           l_cost_ind.lcr_lic_number,
                           l_cost_ind.lcr_cha_number,
                           'Y',
                           1);
                     END IF;

                     --Scheduling window 2 conciliation --new comment
                     --IF l_cost_ind.lcr_sch_start_date2 <
                     IF NVL (l_cost_ind.lcr_sch_start_date2, '31-dec-2199') <
                           TO_DATE (
                                 '01'
                              || LPAD (TO_CHAR (i_curr_month), 2, '0')
                              || i_curr_year,
                              'DDMMYYYY')                                  --3
                     THEN
                        --get the number of runs costed between sch_wnd2 start date and last
                        --day of previous month from costed schedule table
                        SELECT COUNT (*)
                          INTO c_costed_sch_bw_sw2_ldprev_mnt
                          FROM x_fin_cost_schedules
                         WHERE csh_lic_number = i_sch_lic_number
                               AND csh_cha_number = l_cost_ind.lcr_cha_number
                               --AND csh_sch_date BETWEEN l_cost_ind.lcr_sch_start_date2
                               AND csh_sch_date BETWEEN NVL (
                                                           l_cost_ind.lcr_sch_start_date2,
                                                           '31-dec-2199')
                                                    AND LAST_DAY (
                                                           TO_DATE (
                                                              '01'
                                                              || LPAD (
                                                                    TO_CHAR (
                                                                       c_previous_month),
                                                                    2,
                                                                    '0')
                                                              || c_previous_year,
                                                              'DDMMYYYY'));

                        --IF c_costed_sch_bw_sw2_ldprev_mnt < l_cost_ind.lcr_cha_costed_runs2
                        IF c_costed_sch_bw_sw2_ldprev_mnt <
                              NVL (l_cost_ind.lcr_cha_costed_runs2, 0)
                        THEN
                           --get the number of schedules on channel between sch wind 2
                           --start date and last day of previous months // P N
                           SELECT COUNT (*)
                             INTO c_no_lic_sch_bw_sw2_ldprev_mnt
                             FROM fid_schedule
                            WHERE sch_lic_number = i_sch_lic_number
                                  AND sch_cha_number =
                                         l_cost_ind.lcr_cha_number
                                  AND sch_type IN ('P', 'N')
                                  AND sch_fin_actual_date --BETWEEN l_cost_ind.lcr_sch_start_date2
                                                         BETWEEN NVL (
                                                                    l_cost_ind.lcr_sch_start_date2,
                                                                    '31-dec-2199')
                                                             AND LAST_DAY (
                                                                    TO_DATE (
                                                                       '01'
                                                                       || LPAD (
                                                                             TO_CHAR (
                                                                                c_previous_month),
                                                                             2,
                                                                             '0')
                                                                       || c_previous_year,
                                                                       'DDMMYYYY'));

                           IF c_no_lic_sch_bw_sw2_ldprev_mnt >
                                 c_costed_sch_bw_sw2_ldprev_mnt
                           THEN
                              --update is_sch_properly_costed to 'N' for sch_window2
                              update_is_sch_properly_costed (
                                 l_cost_ind.lcr_lic_number,
                                 l_cost_ind.lcr_cha_number,
                                 'N',
                                 2);
                           ELSE
                              --update is_sch_properly_costed to 'Y' for sch_window2
                              update_is_sch_properly_costed (
                                 l_cost_ind.lcr_lic_number,
                                 l_cost_ind.lcr_cha_number,
                                 'Y',
                                 2);
                           END IF;
                        ELSE
                           --update is_sch_properly_costed to 'Y' for sch_window2
                           update_is_sch_properly_costed (
                              l_cost_ind.lcr_lic_number,
                              l_cost_ind.lcr_cha_number,
                              'Y',
                              2);
                        END IF;
                     END IF;                                               --3
                  END LOOP;

                  /*End Loop Costed Tick Channel*/

                  --Loop for each Not Paid schedules till previous month and sch_number not  in
                  --costed sch table and sch on channel with properly costed for either sch_wnd1 or
                  --sch_wnd2 ='N' order by sch_date,sch_time and sch_number.
                  FOR l_not_paid_sch_prev_mth
                     IN not_paid_sch_prev_mth (i_sch_lic_number)
                  LOOP
                     IF c_total_cost_runs_remain > 0                       --5
                     THEN
                        /*IF l_not_paid_sch_prev_mth.sch_date
                        BETWEEN l_not_paid_sch_prev_mth.lcr_sch_start_date
                        AND l_not_paid_sch_prev_mth.lcr_sch_end_date  --4*/
                        c_costed_runs_on_sw := 0;
                        c_costed_runs_on_cha := 0;

                        IF l_not_paid_sch_prev_mth.lcr_sch_start_date2
                              IS NULL
                           OR l_not_paid_sch_prev_mth.sch_fin_actual_date <
                                 l_not_paid_sch_prev_mth.lcr_sch_start_date2
                        THEN
                           IF UPPER (
                                 l_not_paid_sch_prev_mth.lcr_is_sch_pro_costed) =
                                 'N'
                           THEN
                              c_costed_runs_on_sw :=
                                 NVL (
                                    l_not_paid_sch_prev_mth.lcr_cha_costed_runs,
                                    0);

                              --Get the number of runs costed on channel from costed schedule table
                              --before sch_wnd2 start date
                              SELECT COUNT (*)
                                INTO c_costed_runs_on_cha
                                FROM x_fin_cost_schedules
                               WHERE csh_lic_number =
                                        l_not_paid_sch_prev_mth.sch_lic_number
                                     AND csh_cha_number =
                                            l_not_paid_sch_prev_mth.sch_cha_number
                                     AND csh_sch_date <
                                            --l_not_paid_sch_prev_mth.lcr_sch_start_date2;
                                            NVL (
                                               l_not_paid_sch_prev_mth.lcr_sch_start_date2,
                                               '31-dec-2199');
                           END IF;
                        ELSE
                           IF UPPER (
                                 l_not_paid_sch_prev_mth.lcr_is_sch_pro_costed2) =
                                 'N'
                           THEN
                              c_costed_runs_on_sw :=
                                 NVL (
                                    l_not_paid_sch_prev_mth.lcr_cha_costed_runs2,
                                    0);

                              --Get the number of runs costed on channel from costed schdule table
                              --for schedule after sch wnd 2 start date.
                              SELECT COUNT (*)
                                INTO c_costed_runs_on_cha
                                FROM x_fin_cost_schedules
                               WHERE csh_lic_number =
                                        l_not_paid_sch_prev_mth.sch_lic_number
                                     AND csh_cha_number =
                                            l_not_paid_sch_prev_mth.sch_cha_number
                                     --AND csh_sch_date >= l_not_paid_sch_prev_mth.lcr_sch_start_date2;
                                     AND csh_sch_date >=
                                            NVL (
                                               l_not_paid_sch_prev_mth.lcr_sch_start_date2,
                                               '31-dec-2199');
                           END IF;
                        END IF;                                            --4

                        IF c_costed_runs_on_cha < c_costed_runs_on_sw
                        THEN
                           insert_costed_schedules (
                              l_not_paid_sch_prev_mth.sch_number,
                              l_not_paid_sch_prev_mth.sch_lic_number,
                              l_not_paid_sch_prev_mth.sch_cha_number,
                              l_not_paid_sch_prev_mth.sch_fin_actual_date,
                              i_curr_month,
                              i_curr_year,
                              i_user);
                           c_total_cost_runs_remain :=
                              c_total_cost_runs_remain - 1;
                        END IF;
                     END IF;                                               --5
                  END LOOP;
               END IF;

               /*End Loop Not paid sch prev month*/

               --Loop 'P' sch on costed channel  for current month
               FOR l_cost_paid_sch IN cost_paid_sch (i_sch_lic_number)
               LOOP
                  IF (c_total_cost_runs_remain > 0)                        --8
                  THEN
                     --insert the paid schedule of current month in costed schedule table
                     insert_costed_schedules (
                        l_cost_paid_sch.sch_number,
                        l_cost_paid_sch.sch_lic_number,
                        l_cost_paid_sch.sch_cha_number,
                        l_cost_paid_sch.sch_fin_actual_date,
                        i_curr_month,
                        i_curr_year,
                        i_user);
                     --descrement remaining costed runs by 1
                     c_total_cost_runs_remain := c_total_cost_runs_remain - 1;
                  --EXIT WHEN c_total_cost_runs_remain = 0;
                  ELSE
                     UPDATE fid_schedule
                        SET sch_type = 'N'
                      WHERE sch_number = l_cost_paid_sch.sch_number
                            AND sch_lic_number =
                                   l_cost_paid_sch.sch_lic_number;
                  END IF;                                                  --8
               END LOOP;
            /*End Loop Cost Paid Schedules Prev Mth*/
            END IF;                                                        --2
         END IF;
      END IF;
   END identify_costed_schedules;

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to insert/update records in sub_ledger for current routine month
   PROCEDURE insert_update_sub_ledger (i_lis_lic_number             NUMBER,
                                       i_lis_lsl_number             NUMBER,
                                       i_lis_ter_code               VARCHAR2,
                                       i_curr_year                  NUMBER,
                                       i_curr_month                 NUMBER,
                                       i_lis_price                  NUMBER,
                                       i_adjust_factor              NUMBER,
                                       i_lis_rate                   NUMBER,
                                       i_lis_start_rate             NUMBER,
                                       i_lis_paid_exhibition        NUMBER,
                                       i_lis_con_forecast           NUMBER,
                                       i_lis_loc_forecast           NUMBER,
                                       i_lis_con_calc               NUMBER,
                                       i_lis_loc_calc               NUMBER,
                                       i_lis_con_actual             NUMBER,
                                       i_lis_loc_actual             NUMBER,
                                       i_lis_con_adjust             NUMBER,
                                       i_lis_loc_adjust             NUMBER,
                                       i_lis_con_writeoff           NUMBER,
                                       i_lis_loc_writeoff           NUMBER,
                                       i_lis_pv_con_forecast        NUMBER,
                                       i_lis_pv_loc_forecast        NUMBER,
                                       i_lis_pv_con_inv_actual      NUMBER,
                                       i_lis_pv_con_liab_actual     NUMBER,
                                       i_lis_pv_loc_inv_actual      NUMBER,
                                       i_lis_pv_loc_liab_actual     NUMBER,
                                       i_lis_ed_loc_forecast        NUMBER,
                                       i_lis_ed_loc_actual          NUMBER,
                                       i_lis_con_unforseen_cost     NUMBER,
                                       i_lis_loc_unforseen_cost     NUMBER,
                                       --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                                       i_lis_asset_adj_value        NUMBER,
                                       i_lis_start                  DATE,
                                       i_lis_end                    DATE,
                                       i_lis_mean_subs              NUMBER,
                                       i_lis_mg_pv_con_forecast     NUMBER,
                                       i_lis_mg_pv_loc_forecast     NUMBER,
                                       i_lis_loc_asset_adj_value    NUMBER,
                                       i_lis_mg_pv_con_liab         NUMBER,
                                       i_lis_mg_pv_loc_liab         NUMBER,
                                       --END.
                                       i_user_id                    VARCHAR2,
                                       --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/24]
                                       i_lis_reval_flag             fid_license_sub_ledger.lis_reval_flag%TYPE,
                                       --Dev : Fin CR : End
                                       --Finance Dev Phase I Zeshan [Start]
                                       i_lis_lic_cur                fid_license_sub_ledger.lis_lic_cur%TYPE,
                                       i_lis_lic_com_number         fid_license_sub_ledger.lis_lic_com_number%TYPE,
                                       i_lis_lic_status             fid_license_sub_ledger.lis_lic_status%TYPE,
                                       i_lis_pay_mov_flag           fid_license_sub_ledger.lis_pay_mov_flag%TYPE,
                                       i_lis_con_pay                fid_license_sub_ledger.lis_con_pay%TYPE,
                                       i_lis_loc_pay                fid_license_sub_ledger.lis_loc_pay%TYPE
                                       --Finance Dev Phase I [End]
                                       )
   AS
      l_lic_amort_code   VARCHAR2 (1);

      CURSOR lsl1
      IS
         SELECT *
           FROM fid_license_sub_ledger
          WHERE     lis_lic_number = i_lis_lic_number
                AND lis_lsl_number = i_lis_lsl_number
                AND lis_ter_code = i_lis_ter_code
                AND lis_per_year = i_curr_year
                AND lis_per_month = i_curr_month;

      lsl                lsl1%ROWTYPE;
   BEGIN
      OPEN lsl1;

      FETCH lsl1 INTO lsl;

      IF lsl1%NOTFOUND
      THEN
         INSERT INTO fid_license_sub_ledger (lis_number,
                                             lis_lic_number,
                                             lis_lsl_number,
                                             lis_ter_code,
                                             lis_per_year,
                                             lis_per_month,
                                             lis_price,
                                             lis_adjust_factor,
                                             lis_rate,
                                             lis_lic_start_rate,
                                             lis_paid_exhibition,
                                             lis_con_forecast,
                                             lis_loc_forecast,
                                             lis_con_calc,
                                             lis_loc_calc,
                                             lis_con_actual,
                                             lis_loc_actual,
                                             lis_con_adjust,
                                             lis_loc_adjust,
                                             lis_entry_oper,
                                             lis_entry_date,
                                             lis_is_deleted,
                                             lis_update_count,
                                             lis_con_writeoff,
                                             lis_loc_writeoff,
                                             lis_pv_con_forecast,
                                             lis_pv_loc_forecast,
                                             lis_pv_con_inv_actual,
                                             lis_pv_loc_inv_actual,
                                             lis_pv_con_liab_actual,
                                             lis_pv_loc_liab_actual,
                                             lis_ed_loc_forecast,
                                             lis_ed_loc_actual,
                                             lis_con_unforseen_cost,
                                             lis_loc_unforseen_cost,
                                             --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                                             LIS_ASSET_ADJ_VALUE,
                                             LIS_LIC_START,
                                             LIS_LIC_END,
                                             lis_mean_subscriber,
                                             LIS_MG_PV_CON_FORECAST,
                                             LIS_MG_PV_LOC_FORECAST,
                                             LIS_LOC_ASSET_ADJ_VALUE,
                                             LIS_MG_PV_CON_LIAB,
                                             LIS_MG_PV_LOC_LIAB,
                                             lis_reval_flag,    --Dev : Fin CR: [Devashish Raverkar]_[2016/05/23]
                                             --Finance Dev Phase I Zeshan [Start]
                                             lis_lic_cur,
                                             lis_lic_com_number,
                                             lis_lic_status,
                                             lis_pay_mov_flag,
                                             lis_con_pay,
                                             lis_loc_pay)
                                             --Finance Dev Phase I [End]
              VALUES (seq_fid_license_sub_ledger.NEXTVAL,
                      i_lis_lic_number,
                      i_lis_lsl_number,
                      i_lis_ter_code,
                      i_curr_year,
                      i_curr_month,
                      i_lis_price,
                      i_adjust_factor,
                      ROUND (i_lis_rate, 5),   -- 03-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                      ROUND (i_lis_start_rate, 5),   -- 03-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                      i_lis_paid_exhibition,
                      --Dev : Fin CR: Start: [Devashish Raverkar]_[2016/05/23]
                      ROUND (CASE WHEN i_lis_con_forecast >= -0.1 AND i_lis_con_forecast <= 0.1 THEN 0 ELSE i_lis_con_forecast END, 2),
                      ROUND (CASE WHEN i_lis_loc_forecast >= -0.1 AND i_lis_loc_forecast <= 0.1 THEN 0 ELSE i_lis_loc_forecast END, 2),
                      --Dev : Fin CR: End: [Devashish Raverkar]_[2016/05/23]
                      ROUND (i_lis_con_calc, 2),
                      ROUND (i_lis_loc_calc, 2),
                      ROUND (i_lis_con_actual, 2),
                      ROUND (i_lis_loc_actual, 2),
                      ROUND (i_lis_con_adjust, 2),
                      ROUND (i_lis_loc_adjust, 2),
                      i_user_id,
                      SYSDATE,
                      0,
                      0,
                      ROUND (i_lis_con_writeoff, 2),
                      ROUND (i_lis_loc_writeoff, 2),
                      ROUND (i_lis_pv_con_forecast, 2),
                      ROUND (i_lis_pv_loc_forecast, 2),
                      ROUND (NVL (i_lis_pv_con_inv_actual, 0), 2),
                      ROUND (NVL (i_lis_pv_loc_inv_actual, 0), 2),
                      ROUND (NVL (i_lis_pv_con_liab_actual, 0), 2),
                      ROUND (NVL (i_lis_pv_loc_liab_actual, 0), 2),
                      ROUND (NVL (i_lis_ed_loc_forecast, 0), 2),
                      ROUND (NVL (i_lis_ed_loc_actual, 0), 2),
                      ROUND (NVL (i_lis_con_unforseen_cost, 0), 2),
                      ROUND (NVL (i_lis_loc_unforseen_cost, 0), 2),
                      --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                      ROUND (NVL (i_lis_asset_adj_value, 0), 2), --license Revaluation for that month in case of minimum guarantee
                      i_lis_start,
                      i_lis_end,
                      i_lis_mean_subs,
                      ROUND (NVL (i_lis_mg_pv_con_forecast, 0), 2), --pv con froecast for license in case of minimun gurantee
                      ROUND (NVL (i_lis_mg_pv_loc_forecast, 0), 2), --pv loc forcasr for license in case of minimum gurantee
                      ROUND (NVL (i_lis_loc_asset_adj_value, 0), 2), ---license loc Revaluation for that month in case of minimum guarantee
                      ROUND (NVL (i_LIS_MG_PV_CON_LIAB, 0), 2), --pv con liab cost for license in case  of minimum gurantee
                      ROUND (NVL (i_LIS_MG_PV_LOC_LIAB, 0), 2), --pv LOC liab cost for license in case  of minimum gurantee
                      --END [BR_15_144-Finance CRs]
                      decode(i_lis_reval_flag,NULL,'NC',i_lis_reval_flag),		 --Dev : Fin CR: [Devashish Raverkar]_[2016/05/23]
                      --Finance Dev Phase I Zeshan [Start]
                      i_lis_lic_cur,
                      i_lis_lic_com_number,
                      i_lis_lic_status,
                      i_lis_pay_mov_flag,
                      i_lis_con_pay,
                      i_lis_loc_pay
                      --Finance Dev Phase I [End]
                      );
      ELSE
         SELECT UPPER (NVL (lic_amort_code, 'C'))
           INTO l_lic_amort_code
           FROM fid_license
          WHERE lic_number = i_lis_lic_number;

         UPDATE fid_license_sub_ledger
            SET lis_price = i_lis_price, --27Mar2015 :Ver 0.2 :P1 Issue : Jawahar - Added lis_price     --28Mar2015 removed round and nvl
                lis_paid_exhibition = i_lis_paid_exhibition,
                 --Dev : Fin CR: Start: [Devashish Raverkar]_[2016/05/23]
                lis_con_forecast = ROUND (NVL (CASE WHEN i_lis_con_forecast >= -0.1 AND i_lis_con_forecast <= 0.1 THEN 0 ELSE i_lis_con_forecast END, 0), 2), --27Mar2015 :Ver 0.2 :P1 Issue : Jawahar - Added lis_con_forecast
                lis_loc_forecast = ROUND (NVL (CASE WHEN i_lis_loc_forecast >= -0.1 AND i_lis_loc_forecast <= 0.1 THEN 0 ELSE i_lis_loc_forecast END, 0), 2), --27Mar2015 :Ver 0.2 :P1 Issue : Jawahar - Added lis_loc_forecast
                 --Dev : Fin CR: End: [Devashish Raverkar]_[2016/05/23]
                lis_rate = ROUND (i_lis_rate, 5),	-- 03-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                lis_lic_start_rate = ROUND (i_lis_start_rate, 4),
                lis_con_actual =
                   DECODE (l_lic_amort_code,
                           'C', lis_con_actual,
                           ROUND (NVL (i_lis_con_actual, 0), 2)),
                lis_loc_actual =
                   DECODE (l_lic_amort_code,
                           'C', lis_loc_actual,
                           ROUND (NVL (i_lis_loc_actual, 0), 2)),
                lis_con_writeoff =
                   ROUND (NVL (i_lis_con_writeoff, lis_con_writeoff), 2),
                lis_loc_writeoff =
                   ROUND (NVL (i_lis_loc_writeoff, lis_loc_writeoff), 2),
                lis_pv_con_forecast =
                   ROUND (NVL (i_lis_pv_con_forecast, 0), 2), --27Mar2015 :Ver 0.2 :P1 Issue : Jawahar - Added lis_pv_con_forecast
                lis_pv_loc_forecast =
                   ROUND (NVL (i_lis_pv_loc_forecast, 0), 2), --27Mar2015 :Ver 0.2 :P1 Issue : Jawahar - Added lis_pv_loc_forecast
                lis_pv_con_inv_actual =
                   ROUND (
                      NVL (i_lis_pv_con_inv_actual, lis_pv_con_inv_actual),
                      2),
                lis_pv_con_liab_actual =
                   ROUND (
                      NVL (i_lis_pv_con_liab_actual, lis_pv_con_liab_actual),
                      2),
                lis_pv_loc_inv_actual =
                   ROUND (
                      NVL (i_lis_pv_loc_inv_actual, lis_pv_loc_inv_actual),
                      2),
                lis_pv_loc_liab_actual =
                   ROUND (
                      NVL (i_lis_pv_loc_liab_actual, lis_pv_loc_liab_actual),
                      2),
                lis_ed_loc_forecast =
                   ROUND (NVL (i_lis_ed_loc_forecast, 0), 2), --27Mar2015 :Ver 0.2 :P1 Issue : Jawahar - Added lis_ed_loc_forecast
                lis_ed_loc_actual =
                   ROUND (NVL (i_lis_ed_loc_actual, lis_ed_loc_actual), 2),
                lis_con_unforseen_cost =
                   ROUND (
                      NVL (i_lis_con_unforseen_cost, lis_con_unforseen_cost),
                      2),
                lis_loc_unforseen_cost =
                   ROUND (
                      NVL (i_lis_loc_unforseen_cost, lis_loc_unforseen_cost),
                      2),
                --BR_15_144-Finance CRs:New Payment Plan : Start:[Sushma K]_[2015/07/20]
                LIS_ASSET_ADJ_VALUE =
                   ROUND (NVL (i_lis_asset_adj_value, 0), 2),
                LIS_MG_PV_CON_FORECAST =
                   ROUND (NVL (i_lis_mg_pv_con_forecast, 0), 2),
                LIS_MG_PV_loc_FORECAST =
                   ROUND (NVL (i_lis_mg_pv_loc_forecast, 0), 2),
                LIS_LOC_ASSET_ADJ_VALUE =
                   ROUND (NVL (i_lis_loc_asset_adj_value, 0), 2),
                LIS_MG_PV_CON_LIAB = ROUND (NVL (i_lis_mg_pv_con_liab, 0), 2),
                LIS_MG_PV_LOC_LIAB = ROUND (NVL (i_lis_mg_pv_loc_liab, 0), 2),
                --end [BR_15_144-Finance CRs]
                lis_reval_flag = decode(i_lis_reval_flag,NULL,'NC',i_lis_reval_flag),		 --Dev : Fin CR: Start: [Devashish Raverkar]_[2016/05/23]
                lis_update_count = lis_update_count + 1,
                lis_entry_oper = i_user_id,
                lis_entry_date = SYSDATE,
                --Finance Dev Phase I Zeshan [Start]
                lis_lic_cur = nvl(i_lis_lic_cur,lis_lic_cur),
                lis_lic_com_number = nvl(i_lis_lic_com_number,lis_lic_com_number),
                lis_lic_status = nvl(i_lis_lic_status,lis_lic_status),
                lis_pay_mov_flag = nvl(i_lis_pay_mov_flag,lis_pay_mov_flag),
                lis_con_pay = nvl(i_lis_con_pay,lis_con_pay),
                lis_loc_pay = nvl(i_lis_loc_pay,lis_loc_pay)
                 --Finance Dev Phase I [End]
          WHERE lis_lic_number = i_lis_lic_number
            AND lis_lsl_number = i_lis_lsl_number
            AND lis_ter_code = i_lis_ter_code
            AND lis_per_year = i_curr_year
            AND lis_per_month = i_curr_month;
      END IF;

      CLOSE lsl1;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END insert_update_sub_ledger;

   -- Pure Finance: Ajit : 07-Mar-2013 : Procedure added to insert record into refund settle table
   PROCEDURE insert_refund_settle (
      i_lic_number             IN fid_license.lic_number%TYPE,
      i_pay_number             IN fid_payment.pay_number%TYPE,
      i_lsl_number             IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_rfd_pay_numbner        IN fid_payment.pay_number%TYPE,
      i_refund_amount          IN fid_payment.pay_amount%TYPE,
      i_current_month          IN NUMBER,
      i_current_year           IN NUMBER,
      i_settled_in_cur_month   IN CHAR,
      i_user_id                IN VARCHAR2)
   AS
      l_lic_start      DATE;
      l_pay_date       DATE;
      l_payment_flag   VARCHAR2 (1);
   BEGIN
      SELECT lic_start
        INTO l_lic_start
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT pay_date
        INTO l_pay_date
        FROM fid_payment
       WHERE pay_number = i_pay_number;

      IF l_pay_date >= l_lic_start
      THEN
         l_payment_flag := 'Y';
      ELSE
         l_payment_flag := 'N';
      END IF;

      -- Insert into refund settlement table
      INSERT INTO x_fin_refund_settle (frs_number,
                                       frs_lic_number,
                                       frs_lsl_number,
                                       frs_pay_number,
                                       frs_rfd_pay_number,
                                       frs_rfd_amount,
                                       frs_month,
                                       frs_year,
                                       frs_sett_in_curr_month,
                                       frs_update_count,
                                       frs_created_by,
                                       frs_created_on,
                                       frs_modified_by,
                                       frs_modified_on,
                                       frs_is_payment)
           VALUES (x_seq_refund_settle.NEXTVAL,
                   i_lic_number,
                   i_lsl_number,
                   i_pay_number,
                   i_rfd_pay_numbner,
                   NVL (i_refund_amount, 0),
                   i_current_month,
                   i_current_year,
                   i_settled_in_cur_month,
                   0,
                   i_user_id,
                   SYSDATE,
                   i_user_id,
                   SYSDATE,
                   l_payment_flag);
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (
            -20601,
            SUBSTR (SQLERRM, 1, 200) || ' - While refund settlement.');
   END;

   -- Pure Finance: Ajit : 22-Mar-2013 : Procedure added to insert record into unrealized forex
   PROCEDURE insert_unrealized_forex (
      i_lic_number         IN fid_license.lic_number%TYPE,
      i_lsl_number         IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month      IN NUMBER,
      i_current_year       IN NUMBER,
      i_unrealized_forex   IN NUMBER,
      i_account_head       IN VARCHAR2,
      i_user_id            IN VARCHAR2)
   AS
   BEGIN
      IF NVL (i_unrealized_forex, 0) <> 0
      THEN
         -- insert into un-realized forex table
         INSERT INTO x_fin_unrealized_forex (unf_number,
                                             unf_lic_number,
                                             unf_lsl_number,
                                             unf_month,
                                             unf_year,
                                             unf_unrealized_forex,
                                             unf_account_head,
                                             unf_update_count,
                                             unf_created_by,
                                             unf_created_on,
                                             unf_modified_by,
                                             unf_modified_on)
              VALUES (x_seq_unrealized_forex.NEXTVAL,
                      i_lic_number,
                      i_lsl_number,
                      i_current_month,
                      i_current_year,
                      ROUND (NVL (i_unrealized_forex, 0), 2),
                      i_account_head,
                      0,
                      i_user_id,
                      SYSDATE,
                      i_user_id,
                      SYSDATE);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (
            -20601,
            SUBSTR (SQLERRM, 1, 200)
            || ' - While unrealized forex calculation.');
   END insert_unrealized_forex;

   -- Pure Finance: Ajit : 22-Mar-2013 : Procedure added to insert record into realized forex
   PROCEDURE insert_realized_forex (
      i_lic_number       IN fid_license.lic_number%TYPE,
      i_lsl_number       IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_pay_number       IN fid_payment.pay_number%TYPE,
      i_current_month    IN NUMBER,
      i_current_year     IN NUMBER,
      i_realized_forex   IN NUMBER,
      i_account_head     IN VARCHAR2,
      i_user_id          IN VARCHAR2)
   AS
      CURSOR realized_forex
      IS
         SELECT *
           FROM x_fin_realized_forex
          WHERE     rzf_lic_number = i_lic_number
                AND rzf_lsl_number = i_lsl_number
                AND rzf_pay_number = i_pay_number
                AND rzf_month = i_current_month
                AND rzf_year = i_current_year
                AND rzf_account_head = i_account_head;

      realized   realized_forex%ROWTYPE;
   BEGIN
      OPEN realized_forex;

      FETCH realized_forex INTO realized;

      IF realized_forex%NOTFOUND
      THEN
         IF NVL (i_realized_forex, 0) <> 0
         THEN
            -- insert inot realized forex table
            INSERT INTO x_fin_realized_forex (rzf_number,
                                              rzf_lic_number,
                                              rzf_lsl_number,
                                              rzf_pay_number,
                                              rzf_month,
                                              rzf_year,
                                              rzf_realized_forex,
                                              rzf_account_head,
                                              rzf_update_count,
                                              rzf_created_by,
                                              rzf_created_on,
                                              rzf_modified_by,
                                              rzf_modified_on)
                 VALUES (x_seq_realized_forex.NEXTVAL,
                         i_lic_number,
                         i_lsl_number,
                         i_pay_number,
                         i_current_month,
                         i_current_year,
                         ROUND (NVL (i_realized_forex, 0), 4),
                         i_account_head,
                         0,
                         i_user_id,
                         SYSDATE,
                         i_user_id,
                         SYSDATE);
         END IF;
      ELSE
         UPDATE x_fin_realized_forex
            SET rzf_realized_forex = ROUND (NVL (i_realized_forex, 0), 4),
                rzf_modified_by = i_user_id,
                rzf_modified_on = SYSDATE
          WHERE     rzf_lic_number = i_lic_number
                AND rzf_lsl_number = i_lsl_number
                AND rzf_pay_number = i_pay_number
                AND rzf_month = i_current_month
                AND rzf_year = i_current_year
                AND rzf_account_head = i_account_head;
      END IF;
   END insert_realized_forex;

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to insert costed schedules
   PROCEDURE insert_costed_schedules (i_sch_number       IN NUMBER,
                                      i_sch_lic_number   IN NUMBER,
                                      i_sch_cha_number   IN NUMBER,
                                      i_sch_date         IN DATE,
                                      i_curr_month       IN NUMBER,
                                      i_curr_year        IN NUMBER,
                                      i_user             IN VARCHAR2)
   AS
   BEGIN
      INSERT INTO x_fin_cost_schedules (csh_number,
                                        csh_sch_number,
                                        csh_lic_number,
                                        csh_cha_number,
                                        csh_sch_date,
                                        csh_month,
                                        csh_year,
                                        csh_update_count,
                                        csh_created_by,
                                        csh_created_on,
                                        csh_modified_by,
                                        csh_modified_on)
           VALUES (x_seq_cost_schedules.NEXTVAL,
                   i_sch_number,
                   i_sch_lic_number,
                   i_sch_cha_number,
                   i_sch_date,
                   i_curr_month,
                   i_curr_year,
                   0,
                   i_user,
                   SYSDATE,
                   i_user,
                   SYSDATE);
   -- COMMIT;
   END insert_costed_schedules;

   --Pure Finance: Mangesh:29-MAR-2013:Procedure added to update Is schedule properly costed field
   PROCEDURE update_is_sch_properly_costed (i_sch_lic_number    NUMBER,
                                            i_sch_cha_number    NUMBER,
                                            i_is_prop_costed    VARCHAR2,
                                            i_sch_window        NUMBER --value will be 1/2 depending on sch window
                                                                      )
   AS
   BEGIN
      IF i_sch_window = 1
      THEN
         UPDATE fid_license_channel_runs
            SET lcr_is_sch_pro_costed = i_is_prop_costed
          WHERE lcr_lic_number = i_sch_lic_number
                AND lcr_cha_number = i_sch_cha_number;
      END IF;

      IF i_sch_window = 2
      THEN
         UPDATE fid_license_channel_runs
            SET lcr_is_sch_pro_costed2 = i_is_prop_costed
          WHERE lcr_lic_number = i_sch_lic_number
                AND lcr_cha_number = i_sch_cha_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
   END update_is_sch_properly_costed;

   -- Pure Finance: Ajit : 21-Mar-2013 : Function added to check the if remaining
   -- liability and inventory for the license used in make_lic_inactive procedure
   FUNCTION check_rem_inv_liab (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER)
      RETURN NUMBER
   AS
      l_forcast   NUMBER;
      l_cost      NUMBER;
      l_payment   NUMBER;
   BEGIN
        -- Get the total inventory and total cost till last month
        SELECT NVL (SUM (lis_con_forecast), 0),
               NVL (
                  SUM (
                       lis_con_actual
                     + lis_con_adjust
                     + NVL (lis_con_writeoff, 0)),
                  0)
          INTO l_forcast, l_cost
          FROM fid_license_sub_ledger
         WHERE lis_lic_number = i_lic_number
               AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                      i_current_year || LPAD (i_current_month, 2, 0)
      GROUP BY lis_lic_number;

      -- Get all sum of all the payments
      SELECT NVL (SUM (pay_amount), 0)
        INTO l_payment
        FROM fid_payment
       WHERE UPPER (pay_status) = 'P' AND pay_lic_number = i_lic_number;

      -- Check if the inventory is remaining
      -- rem inventory is eqaul to total inventory minus total cost
      IF (l_forcast - l_cost) <> 0
      THEN
         RETURN 1;
      -- Check of the liability is remaining
      -- rem liability is equal to total inventory minus total payments
      ELSIF (l_forcast - l_payment) <> 0
      THEN
         RETURN 1;
      ELSE
         RETURN 0;
      END IF;
   END check_rem_inv_liab;

   -- Pure Finance: Ajit : 28-Feb-2013 : Function added to send email
   FUNCTION fun_send_email (i_user           IN VARCHAR2,
                            i_action         IN VARCHAR2,
                            i_log_date       IN VARCHAR2,
                            i_user_mail_id   IN VARCHAR2)
      RETURN NUMBER
   AS
      l_mail_conn     UTL_SMTP.connection;
      l_smtp_server   VARCHAR2 (100);
      l_recipient     VARCHAR2 (500);
      l_subject       VARCHAR2 (500);
      l_mailfrom      VARCHAR2 (50);
      var             VARCHAR2 (20);
      o_sucess        NUMBER;
      arr_email       simplearray := simplearray (50);
   BEGIN
      var := CHR (38) || 'nbsp;';

      -- Get the SMTP server ip from fwk_appparameter table
      SELECT "Content"
        INTO l_smtp_server
        FROM fwk_appparameter
       WHERE KEY = 'SMTPServer';

      -- Get the recipient, subject, mailfrom from sgy_email table
      SELECT recipient, subject, mailfrom
        INTO l_recipient, l_subject, l_mailfrom
        FROM sgy_email
       WHERE action = i_action;

      -- Get the ',' seperated emailids as array
      arr_email := get_email_ids (l_recipient, ',');
      l_mail_conn := UTL_SMTP.open_connection (l_smtp_server, 25);
      UTL_SMTP.helo (l_mail_conn, l_smtp_server);
      UTL_SMTP.mail (l_mail_conn, l_mailfrom);
      UTL_SMTP.rcpt (l_mail_conn, i_user_mail_id);

      FOR i IN 1 .. arr_email.COUNT - 1
      LOOP
         UTL_SMTP.rcpt (l_mail_conn, '' || arr_email (i) || '');
      END LOOP;

      UTL_SMTP.open_data (l_mail_conn);
      UTL_SMTP.write_data (
         l_mail_conn,
            'Subject:'
         || l_subject
         || i_user
         || ' on Date '
         || i_log_date
         || UTL_TCP.crlf);
      UTL_SMTP.write_data (l_mail_conn,
                           'Content-Type: text/html' || UTL_TCP.crlf);
      UTL_SMTP.write_data (l_mail_conn, UTL_TCP.crlf || '');
      UTL_SMTP.write_data (l_mail_conn, 'Greetings, ');
      UTL_SMTP.write_data (l_mail_conn, ' <BR>');
      UTL_SMTP.write_data (l_mail_conn, '<BR>' || UTL_TCP.crlf);
      UTL_SMTP.write_data (
         l_mail_conn,
         'The Monthly Costing Calculation Failed due to following reason(s)');
      UTL_SMTP.write_data (l_mail_conn, '<BR><BR>');

      ------Mail content for T license scheduled start 10Apr2014
      FOR err IN (SELECT cov_v_error, ROWNUM
                    FROM x_fin_costing_validations
                   WHERE cov_v_code = 'TLicense')
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (
               l_mail_conn,
                  var
               || var
               || var
               || var
               || 'Due to following T licenses scheduled');
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (
            l_mail_conn,
               var
            || var
            || var
            || var
            || var
            || var
            || var
            || var
            || err.ROWNUM
            || '.'
            || var
            || var
            || err.cov_v_error);
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

      UTL_SMTP.write_data (l_mail_conn, '<BR>');

    --Added by sushma on 28-07-2015 to add mail content for minimum subscriber
      --Mail content for licese which are not having the minimum subscribers at contract level
        FOR err IN (SELECT cov_v_error, ROWNUM
                    FROM x_fin_costing_validations
                   WHERE cov_v_code = 'License')
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (
               l_mail_conn,
                  var
               || var
               || var
               || var
               || 'Due to unavailability of Minimum Subscriber for following contracts');
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (
            l_mail_conn,
               var
            || var
            || var
            || var
            || var
            || var
            || var
            || var
            || err.ROWNUM
            || '.'
            || var
            || var
            || err.cov_v_error);
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

      UTL_SMTP.write_data (l_mail_conn, '<BR>');

       FOR err IN (SELECT cov_v_error, ROWNUM
                    FROM x_fin_costing_validations
                   WHERE cov_v_code = 'LICENSE')
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (
               l_mail_conn,
                  var
               || var
               || var
               || var
               || 'Due to following licenses with TBA status');
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (
            l_mail_conn,
               var
            || var
            || var
            || var
            || var
            || var
            || var
            || var
            || err.ROWNUM
            || '.'
            || var
            || var
            || err.cov_v_error);
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

      UTL_SMTP.write_data (l_mail_conn, '<BR>');
      --END by sushma

      ------Mail content for T license scheduled end
      FOR err IN (SELECT cov_v_error, ROWNUM
                    FROM x_fin_costing_validations
                   WHERE cov_v_code = 'TBA')
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (
               l_mail_conn,
                  var
               || var
               || var
               || var
               || 'Due to following licenses with TBA status');
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (
            l_mail_conn,
               var
            || var
            || var
            || var
            || var
            || var
            || var
            || var
            || err.ROWNUM
            || '.'
            || var
            || var
            || err.cov_v_error);
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

      UTL_SMTP.write_data (l_mail_conn, '<BR>');

      FOR err IN (SELECT cov_v_error, ROWNUM
                    FROM x_fin_costing_validations
                   WHERE cov_v_code = 'SCHWIND')
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (
               l_mail_conn,
               var || var || var || var
               || 'Due to following Bioscope licenses scheduled on channel outside the scheduling window or with TBA window');
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (
            l_mail_conn,
               var
            || var
            || var
            || var
            || var
            || var
            || var
            || var
            || err.ROWNUM
            || '.'
            || var
            || var
            || err.cov_v_error);
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

      FOR err IN (SELECT cov_v_error, ROWNUM
                    FROM x_fin_costing_validations
                   WHERE cov_v_code = 'PAYMENT')
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (
               l_mail_conn,
               var || var || var || var
               || 'Due to following having paid records without Payment Date and/or Spot Rate');
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (
            l_mail_conn,
               var
            || var
            || var
            || var
            || var
            || var
            || var
            || var
            || err.ROWNUM
            || '.'
            || var
            || var
            || err.cov_v_error);
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

      FOR err IN (SELECT cov_v_error, ROWNUM
                    FROM x_fin_costing_validations
                   WHERE cov_v_code = 'SPOTRATE')
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (
               l_mail_conn,
               var || var || var || var
               || 'Due to unavailability of McGregor spot rate for following currencies');
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (
            l_mail_conn,
               var
            || var
            || var
            || var
            || var
            || var
            || var
            || var
            || err.ROWNUM
            || '.'
            || var
            || var
            || err.cov_v_error);
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

      FOR err IN (SELECT cov_v_error, ROWNUM
                    FROM x_fin_costing_validations
                   WHERE cov_v_code = 'FWDRATE')
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (
               l_mail_conn,
               var || var || var || var
               || 'Due to unavailability of forward rate for following currencies');
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (
            l_mail_conn,
               var
            || var
            || var
            || var
            || var
            || var
            || var
            || var
            || err.ROWNUM
            || '.'
            || var
            || var
            || err.cov_v_error);
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

      FOR err IN (SELECT cov_v_error, ROWNUM
                    FROM x_fin_costing_validations
                   WHERE cov_v_code = 'DISCRATE')
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (
               l_mail_conn,
                  var
               || var
               || var
               || var
               || 'Due to unavailability of discount rate');
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (
            l_mail_conn,
               var
            || var
            || var
            || var
            || var
            || var
            || var
            || var
            || err.ROWNUM
            || '.'
            || var
            || var
            || err.cov_v_error);
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

      UTL_SMTP.write_data (l_mail_conn, '<BR>');
      UTL_SMTP.write_data (l_mail_conn, '<BR><BR>');
      UTL_SMTP.write_data (l_mail_conn, 'Thanks,<BR>');
      UTL_SMTP.write_data (l_mail_conn, 'Synergy Admin<BR>');
      UTL_SMTP.write_data (l_mail_conn, '<BR>');
      UTL_SMTP.write_data (
         l_mail_conn,
         'This is an auto generated email. Please do not reply to this email.');
      UTL_SMTP.close_data (l_mail_conn);
      UTL_SMTP.quit (l_mail_conn);
      o_sucess := 1;
      RETURN o_sucess;
   EXCEPTION
      WHEN OTHERS
      THEN
         UTL_SMTP.close_data (l_mail_conn);
         UTL_SMTP.quit (l_mail_conn);
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END;

   -- Pure Finance: Ajit : 28-Feb-2013 : Function added to get email-ids as array
   FUNCTION get_email_ids (list_in IN VARCHAR2, delimiter_in VARCHAR2)
      RETURN simplearray
   AS
      v_retval   simplearray
         := simplearray (
                 LENGTH (list_in)
               - LENGTH (REPLACE (list_in, delimiter_in, ''))
               + 1);
   BEGIN
      IF list_in IS NOT NULL
      THEN
         FOR i IN 1 ..
                    LENGTH (list_in)
                  - LENGTH (REPLACE (list_in, delimiter_in, ''))
                  + 1
         LOOP
            v_retval.EXTEND;
            v_retval (i) :=
               SUBSTR (delimiter_in || list_in || delimiter_in,
                       INSTR (delimiter_in || list_in || delimiter_in,
                              delimiter_in,
                              1,
                              i)
                       + 1,
                         INSTR (delimiter_in || list_in || delimiter_in,
                                delimiter_in,
                                1,
                                i + 1)
                       - INSTR (delimiter_in || list_in || delimiter_in,
                                delimiter_in,
                                1,
                                i)
                       - 1);
         END LOOP;
      END IF;

      RETURN v_retval;
   END get_email_ids;

   --Pure finance :Mangesh :09-APR-2013:Procedure to update Rate Date in Month end Defination
   PROCEDURE update_rate_date (i_month_end_rate_date   IN DATE,
                               i_month_end_type        IN VARCHAR2,
                               i_current_year          IN NUMBER,
                               i_current_month         IN NUMBER,
                               i_region                IN VARCHAR2)
   AS
   BEGIN
      UPDATE x_fin_month_defn
         SET fmd_rate_date = i_month_end_rate_date, fmd_run_status = 'Y'
       WHERE     UPPER (fmd_mon_end_type) = UPPER (i_month_end_type)
             AND fmd_month = i_current_month
             AND fmd_year = i_current_year
             AND fmd_region IN (SELECT reg_id
                                  FROM fid_region
                                 WHERE reg_code LIKE '' || i_region || '');
   END;

   PROCEDURE calculate_refund_settlement (
      i_lic_number      IN fid_license.lic_number%TYPE,
      i_lsl_number      IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_current_month   IN NUMBER,
      i_current_year    IN NUMBER,
      i_fromdate        IN DATE,
      i_todate          IN DATE,
      i_user_id         IN VARCHAR2)
   AS
      CURSOR refund_t_for_mon
      IS
         SELECT pay_number,
                pay_lic_number,
                pay_lsl_number,
                pay_rate,
                NVL (pay_amount, 0) pay_amount,
                pay_source_number
           FROM fid_payment, fid_license
          WHERE     pay_amount < 0
                AND pay_status = 'P'
                AND UPPER (pay_code) = 'T'
                AND lic_number = pay_lic_number
                AND pay_date >= lic_start
                AND pay_lic_number = i_lic_number
                AND pay_lsl_number = i_lsl_number
                AND pay_date BETWEEN i_fromdate AND i_todate;

      refund_t                       refund_t_for_mon%ROWTYPE;

      -- Cursor for all payments for the license in routine period and
      -- license currency is not equal to channel company currency
      --and refunds done after license start date
      CURSOR payment_for_curr_mon
      IS
         SELECT pay_number,
                NVL (pay_amount, 0) pay_amount,
                pay_lsl_number,
                pay_rate,
                pay_date,
                lic_start_rate
           FROM fid_payment,
                fid_license,
                fid_licensee,
                fid_company,
                fid_territory
          WHERE     pay_lic_number = lic_number
                AND lee_number = lic_lee_number
                AND UPPER (lic_status) = 'A'
                AND UPPER (pay_status) = 'P'
                AND pay_date >= lic_start
                AND lee_number = lic_lee_number
                AND com_number = lee_cha_com_number
                AND ter_code = com_ter_code
                AND ter_cur_code <> lic_currency
                AND lic_number = i_lic_number
                AND pay_lsl_number = i_lsl_number
                AND UPPER (pay_code) <> 'T'
                AND pay_amount < 0
                AND pay_date BETWEEN i_fromdate AND i_todate;

      CURSOR payment_to_settle_refund
      IS
         SELECT pay_number,
                pay_lic_number,
                pay_lsl_number,
                pay_amount,
                pay_source_number,
                pay_rate,
                pay_date,
                lic_start
           FROM (  SELECT pay_number,
                          pay_lic_number,
                          pay_lsl_number,
                          NVL (pay_amount, 0) pay_amount,
                          pay_source_number,
                          pay_rate,
                          pay_date,
                          lic_start
                     FROM fid_payment, fid_license
                    WHERE     pay_amount > 0
                          AND pay_status = 'P'
                          AND lic_number = pay_lic_number
                          AND pay_lic_number = i_lic_number
                          AND pay_lsl_number = i_lsl_number
                          AND pay_date <= i_todate
                 ORDER BY pay_date);

      payments_to_sett               payment_to_settle_refund%ROWTYPE;
      payment                        payment_for_curr_mon%ROWTYPE;
      payments_till_curr_months      NUMBER;
      refund_paym_till_curr_months   NUMBER;
      l_rem_refund_amount            NUMBER;
      rfd_amt_already_sett_for_pay   NUMBER;
      rfd_amt_now_sett_for_pay       NUMBER;
      --  total_rfd_amt_now_sett_for_pay   NUMBER                             := 0;
      l_pay_rate                     NUMBER;
   BEGIN
      OPEN refund_t_for_mon;

      LOOP
         FETCH refund_t_for_mon INTO refund_t;

         EXIT WHEN refund_t_for_mon%NOTFOUND;
         -- insert into refund settlement table
         insert_refund_settle (refund_t.pay_lic_number,
                               refund_t.pay_source_number,
                               refund_t.pay_lsl_number,
                               refund_t.pay_number,
                               -refund_t.pay_amount,
                               i_current_month,
                               i_current_year,
                               'Y',
                               i_user_id);
      END LOOP;

      -- loop end for -ve prepayment for the license with Code 'T' for routine period
      CLOSE refund_t_for_mon;

      -- Loop for the Cursor for all payments for the license in routine period and
      -- license currency is not equal to channel company currency
      OPEN payment_for_curr_mon;

      LOOP
         FETCH payment_for_curr_mon INTO payment;

         EXIT WHEN payment_for_curr_mon%NOTFOUND;

         IF payment.pay_amount < 0
         THEN
            l_rem_refund_amount := payment.pay_amount;

            OPEN payment_to_settle_refund;

            LOOP
               FETCH payment_to_settle_refund INTO payments_to_sett;

               EXIT WHEN payment_to_settle_refund%NOTFOUND;

               -- check if the refund amount is less than 0
               IF l_rem_refund_amount < 0
               THEN
                  rfd_amt_already_sett_for_pay := 0;

                  BEGIN
                     -- get the amount already settled for the month
                     SELECT SUM (frs_rfd_amount)
                       INTO rfd_amt_already_sett_for_pay
                       FROM x_fin_refund_settle
                      WHERE frs_year || LPAD (frs_month, 2, 0) <=
                               i_current_year || LPAD (i_current_month, 2, 0)
                            AND frs_lic_number = i_lic_number
                            AND frs_pay_number = payments_to_sett.pay_number;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        rfd_amt_already_sett_for_pay := 0;
                  END;

                  -- check if the payment amount is not equal to already settled amount
                  IF payments_to_sett.pay_amount <>
                        NVL (rfd_amt_already_sett_for_pay, 0)
                  THEN
                     -- check if the rem refund amount (payment amount - already settled amount)
                     -- greater than -ve to be refund aount
                     IF (payments_to_sett.pay_amount
                         - NVL (rfd_amt_already_sett_for_pay, 0)) >=
                           -l_rem_refund_amount
                     THEN
                        rfd_amt_now_sett_for_pay := -l_rem_refund_amount;
                        l_rem_refund_amount := 0;
                     ELSE
                        rfd_amt_now_sett_for_pay :=
                           payments_to_sett.pay_amount
                           - NVL (rfd_amt_already_sett_for_pay, 0);
                        l_rem_refund_amount :=
                           l_rem_refund_amount + rfd_amt_now_sett_for_pay;
                     END IF;

                     -- insert into refund settlement table
                     insert_refund_settle (payments_to_sett.pay_lic_number,
                                           payments_to_sett.pay_number,
                                           payments_to_sett.pay_lsl_number,
                                           payment.pay_number,
                                           rfd_amt_now_sett_for_pay,
                                           i_current_month,
                                           i_current_year,
                                           'Y',
                                           i_user_id);
                  END IF;
               END IF;
            END LOOP;       -- loop end for +ve prepayment before the pay date

            CLOSE payment_to_settle_refund;
         END IF;
      END LOOP;
   END calculate_refund_settlement;

   FUNCTION x_fin_amort_a_cost_calc (i_lic_start              IN DATE,
                                     i_lic_end                IN DATE,
                                     i_lic_price              IN NUMBER,
                                     i_amort_month            IN NUMBER,
                                     i_cost_till_last_month   IN NUMBER,
                                     i_calc_type              IN VARCHAR2)
      RETURN NUMBER
   AS
      l_cost_till_current_month   NUMBER;
      l_days_till_current_month   NUMBER;
      l_lic_period_in_days        NUMBER;
      l_amort_month               DATE;
      l_cost_for_month            NUMBER;
   BEGIN
      l_amort_month := TO_DATE (i_amort_month, 'RRRRMM');

      l_days_till_current_month :=
         (CASE
             WHEN LAST_DAY (l_amort_month) < i_lic_end
             THEN
                LAST_DAY (l_amort_month)
             ELSE
                i_lic_end
          END)
         - i_lic_start
         + 1;

      l_lic_period_in_days := (i_lic_end - i_lic_start) + 1;

      l_cost_till_current_month :=
         (i_lic_price / l_lic_period_in_days) * l_days_till_current_month;

      l_cost_for_month := l_cost_till_current_month - i_cost_till_last_month;

      RETURN l_cost_for_month;
   END x_fin_amort_a_cost_calc;

  --Finance Dev Phase I Zeshan [Start]
  --Sets all payments for given month as Payments/Prepayments
  PROCEDURE X_PRC_SET_PAY_TYPE(
      I_OPEN_MONTH       IN       DATE
  )
  AS
  cursor c_pay_data IS
    SELECT LIC_NUMBER, LIC_STATUS, LIC_START, LIC_ACCT_DATE, PAY_NUMBER, NVL(PAY_DATE,PAY_STATUS_DATE) PAY_DATE
     FROM  FID_PAYMENT, 
           FID_LICENSE
    WHERE  NVL(PAY_DATE, PAY_STATUS_DATE) >= I_OPEN_MONTH
      AND  NVL(PAY_DATE, PAY_STATUS_DATE) <= LAST_DAY(I_OPEN_MONTH)
      AND  PAY_LIC_NUMBER = LIC_NUMBER;
          
  L_PAY_DATA c_pay_data%ROWTYPE;
  
BEGIN

  OPEN c_pay_data;
  
  LOOP
      FETCH c_pay_data INTO L_PAY_DATA;
      EXIT WHEN c_pay_data%NOTFOUND;
      
      IF (
               L_PAY_DATA.LIC_STATUS = 'C'
            OR L_PAY_DATA.LIC_ACCT_DATE IS NULL
            OR L_PAY_DATA.PAY_DATE < L_PAY_DATA.LIC_START												
            OR L_PAY_DATA.LIC_START > LAST_DAY(I_OPEN_MONTH)						--LSD IN FUTURE MONTH
          )
      THEN
          UPDATE FID_PAYMENT
             SET PAY_TYPE = 'PR'
           WHERE PAY_NUMBER = L_PAY_DATA.PAY_NUMBER;
           
     ELSIF 
          (
            L_PAY_DATA.LIC_ACCT_DATE IS NOT NULL
            AND L_PAY_DATA.LIC_STATUS = 'A'
            AND (L_PAY_DATA.LIC_START <= I_OPEN_MONTH
                 OR L_PAY_DATA.PAY_DATE >= L_PAY_DATA.LIC_START)
          )THEN
          
          UPDATE FID_PAYMENT
             SET PAY_TYPE = 'PP'
           WHERE PAY_NUMBER = L_PAY_DATA.PAY_NUMBER;
          
      END IF;
      
  END LOOP;
  
END X_PRC_SET_PAY_TYPE;
  
  --Gets the Payment Movement for given license for the Open Month also calculates 
  --License and Local Currency payments.
  PROCEDURE x_prc_get_lic_mvmt_data(
    i_lic_number              IN              fid_license.lic_number%TYPE,
    i_lsl_number              IN              x_fin_lic_sec_lee.lsl_number%TYPE,
    i_prev_month_lsd          IN              DATE,
    o_lis_con_pay               OUT           NUMBER,
    o_lis_loc_pay               OUT           NUMBER,
    o_lis_pay_mov_flag          Out           VARCHAR2
  )
  AS
    CURSOR c_lic_data IS
      SELECT
            to_number(to_char(lic_start, 'YYYYMM')) AS lic_start_yyyymm,
            to_number(to_char(lic_acct_date, 'YYYYMM')) AS lic_acct_date_yyyymm,
            lic_start,
            lic_status
      FROM fid_license
      WHERE lic_number = i_lic_number
      AND EXISTS (SELECT 'Z'
                    FROM FID_PAYMENT
                   WHERE PAY_STATUS = 'P'
                     AND pay_lic_number = i_lic_number);
      
    l_lic_data c_lic_data%rowtype;
    
    l_go_live_yyyymm                NUMBER;
    
    l_open_month                    DATE;
    l_open_month_yyyymm             NUMBER;
    l_last_month_status             VARCHAR2(4);
    l_last_month_lsd_yyyymm         NUMBER := to_number(to_char(i_prev_month_lsd, 'YYYYMM'));
    l_in_out_flag                   VARCHAR2(1) := 'I';         --'I' is In and 'O' is Out
    
    l_go_live_in_om                 BOOLEAN := FALSE;           --Is Open month equal to Go Live Month?
    l_lic_accdt_in_om               BOOLEAN := FALSE;           --Is Acct Date in Open Month?
    
    l_lic_start_in_om               BOOLEAN := FALSE;           --Is LSD in Open Month?
    l_lic_start_in_cm               BOOLEAN := FALSE;           --Is LSD in Closed Month?
    l_lic_start_in_bm               BOOLEAN := FALSE;           --Is LSD in Budgeted Month?
    
    l_prev_lsd_in_om                BOOLEAN := FALSE;           --Is last month LSD in Open Month? or Is last month LSD = Current(Open) Month
    l_prev_lsd_in_cm                BOOLEAN := FALSE;           --Is last month LSD in Closed Month?
    l_prev_lsd_in_bm                BOOLEAN := FALSE;           --Is last month LSD in Budgeted Month?
    
    l_lic_cancel_in_cm              BOOLEAN := FALSE;           --Is License Cancelled in close month?
    l_lic_active_in_om              BOOLEAN := FALSE;           --Is License Active in Open Month?
    
BEGIN
      SELECT to_number(to_char((fim_year || lpad(fim_month,2,0)))), TO_DATE (fim_year || fim_month, 'YYYYMM')
        INTO l_open_month_yyyymm, l_open_month
        FROM fid_financial_month, fid_licensee
       WHERE fim_split_region = lee_split_region
             AND fim_status = 'O'
             AND lee_number = (SELECT lic_lee_number
                                 FROM fid_license
                                WHERE lic_number = i_lic_number);
            
      --Get previous month status of License
      BEGIN
          SELECT lsh_lic_status 
          INTO l_last_month_status
          FROM
          (
            SELECT lsh_lic_status
            FROM x_lic_status_history
            WHERE lsh_lic_number = i_lic_number
            AND lsh_status_yyyymm < l_open_month_yyyymm
            ORDER BY lsh_number DESC
          )
          WHERE ROWNUM = 1;
          
          EXCEPTION WHEN no_data_found
          THEN l_last_month_status := 'A';
      END;

      --Get Go Live month
      BEGIN
          SELECT TO_NUMBER(TO_CHAR(X_FNC_GET_FIN_I_LIVE_DATE,'RRRRMM'))
            INTO l_go_live_yyyymm
            FROM DUAL;
      END;
      
      OPEN c_lic_data;
        LOOP
        FETCH c_lic_data INTO l_lic_data;
        EXIT WHEN c_lic_data%notfound;
        END LOOP;
      CLOSE c_lic_data;
      
      --Is Open month equal to Go Live Month?
      IF l_go_live_yyyymm = l_open_month_yyyymm
      THEN
          l_go_live_in_om := TRUE;
      END IF;
      
      --Is Acct Date in Open Month?
      IF l_lic_data.lic_acct_date_yyyymm = l_open_month_yyyymm
      THEN
            l_lic_accdt_in_om := TRUE;
      END IF;
      
      --Is LSD in Open Month?
      IF l_lic_data.lic_start_yyyymm = l_open_month_yyyymm
      THEN
          l_lic_start_in_om := TRUE;
      --Is LSD in Closed Month?
      ELSIF l_lic_data.lic_start_yyyymm < l_open_month_yyyymm
      THEN
          l_lic_start_in_cm := TRUE;
      --Is LSD in Budgeted Month?
      ELSIF l_lic_data.lic_start_yyyymm > l_open_month_yyyymm
      THEN
          l_lic_start_in_bm := TRUE;
      END IF;
      
      --Is last month LSD in Open Month? or Is last month LSD = Current(Open) Month
      IF l_last_month_lsd_yyyymm = l_open_month_yyyymm
      THEN
          l_prev_lsd_in_om := TRUE;
      --Is last month LSD in Closed Month?
      ELSIF l_last_month_lsd_yyyymm < l_open_month_yyyymm
      THEN
          l_prev_lsd_in_cm := TRUE;
      --Is last month LSD in Budgeted Month?
      ELSIF l_last_month_lsd_yyyymm > l_open_month_yyyymm
      THEN
          l_prev_lsd_in_bm := TRUE;
      END IF;
      
      IF l_lic_data.lic_status = 'A'
      THEN
          l_lic_active_in_om := TRUE;
      END IF;
      
      IF l_last_month_status ='C'
      THEN
          l_lic_cancel_in_cm:= TRUE;
      END IF;
      
      --Cancelled License
      IF l_lic_active_in_om = FALSE
      THEN
          --Is current month = Go Live Month?
          IF l_go_live_in_om
          --Yes
          THEN
              x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,l_open_month,o_lis_con_pay,o_lis_loc_pay);
          --No
          ELSE
              --Is license cancelled in Current month? & --Is last month LSD >= current month ; Used inverse condition : Is last month LSD < current month
              IF NOT l_lic_cancel_in_cm AND l_last_month_lsd_yyyymm < l_open_month_yyyymm
              --Yes
              THEN
                  x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,l_open_month,o_lis_con_pay,o_lis_loc_pay);
              END IF;
          END IF;
      END IF;
      
      --Active License
      IF l_lic_active_in_om
      THEN
          IF l_lic_accdt_in_om
          THEN
              l_in_out_flag := 'O';
              
              IF l_lic_start_in_om
              THEN
                  x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_lic_data.lic_start-1),o_lis_con_pay,o_lis_loc_pay);
              ELSIF NOT l_lic_start_in_om
              THEN
                  x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_open_month-1),o_lis_con_pay,o_lis_loc_pay);
              END IF;
          ELSIF NOT l_lic_accdt_in_om
          THEN
              IF l_lic_cancel_in_cm
              THEN
                  IF l_go_live_in_om
                  THEN
                      IF l_lic_start_in_om
                      THEN
                          l_in_out_flag := 'O';
                          x_prc_get_mve_amt (i_lic_number,i_lsl_number,add_months((last_day(l_lic_data.lic_start)+1),-1),(l_lic_data.lic_start-1),o_lis_con_pay,o_lis_loc_pay);
                      ELSIF l_lic_start_in_bm
                      THEN
                          l_in_out_flag := 'I';
                          x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_open_month-1),o_lis_con_pay,o_lis_loc_pay);
                      END IF;
                  ELSIF NOT l_go_live_in_om AND l_lic_start_in_om
                  THEN
                      l_in_out_flag := 'O';
                      x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_lic_data.lic_start-1),o_lis_con_pay,o_lis_loc_pay);
                  ELSIF NOT l_go_live_in_om AND l_lic_start_in_cm
                  THEN
                      l_in_out_flag := 'O';
                      x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_open_month-1),o_lis_con_pay,o_lis_loc_pay);
                  END IF;
              ELSIF NOT l_lic_cancel_in_cm
              THEN
                  IF l_lic_start_in_om
                  THEN
                      l_in_out_flag := 'O';
                      IF l_go_live_in_om
                      THEN
                              x_prc_get_mve_amt (i_lic_number,i_lsl_number,add_months((last_day(l_lic_data.lic_start)+1),-1),(l_lic_data.lic_start-1),o_lis_con_pay,o_lis_loc_pay);
                      ELSIF NOT l_go_live_in_om
                      THEN
                          IF l_prev_lsd_in_cm
                          THEN
                              x_prc_get_mve_amt (i_lic_number,i_lsl_number,add_months((last_day(l_lic_data.lic_start)+1),-1),(l_lic_data.lic_start-1),o_lis_con_pay,o_lis_loc_pay);
                          ELSIF NOT l_prev_lsd_in_cm
                          THEN
                              x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_lic_data.lic_start-1),o_lis_con_pay,o_lis_loc_pay);
                          END IF;
                      END IF;
                  ELSIF NOT l_lic_start_in_om
                  THEN
                      IF l_lic_data.lic_start_yyyymm = l_last_month_lsd_yyyymm
                      THEN
                          IF l_go_live_in_om
                          THEN
                              IF l_lic_start_in_bm
                              THEN
                                  x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_open_month-1),o_lis_con_pay,o_lis_loc_pay);
                              END IF;
                          END IF;
                      ELSIF l_lic_data.lic_start_yyyymm <> l_last_month_lsd_yyyymm
                      THEN
                          IF l_go_live_in_om
                          THEN
                              IF l_lic_start_in_bm
                              THEN
                                  x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_open_month-1),o_lis_con_pay,o_lis_loc_pay);
                              END IF;
                          ELSIF NOT l_go_live_in_om
                          THEN
                              IF l_prev_lsd_in_cm
                              THEN
                                  IF l_lic_start_in_bm
                                  THEN
                                      x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_open_month-1),o_lis_con_pay,o_lis_loc_pay);
                                  END IF;
                              ELSIF NOT l_prev_lsd_in_cm
                              THEN
                                  l_in_out_flag := 'O';
                                  IF l_prev_lsd_in_om
                                  THEN
                                      IF l_lic_start_in_cm
                                      THEN
                                          x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_open_month-1),o_lis_con_pay,o_lis_loc_pay);
                                      END IF;
                                  ELSIF NOT l_prev_lsd_in_om
                                  THEN
                                      IF l_lic_start_in_cm
                                      THEN
                                          x_prc_get_mve_amt (i_lic_number,i_lsl_number,NULL,(l_open_month-1),o_lis_con_pay,o_lis_loc_pay);
                                      END IF;
                                  END IF;
                              END IF;
                          END IF;
                      END IF;
                  END IF;
              END IF;
          END IF;
      END IF;
      
      IF l_in_out_flag = 'I' AND nvl(o_lis_con_pay,0) = 0
      THEN
          o_lis_pay_mov_flag := 'N';
          o_lis_con_pay := 0;
          o_lis_loc_pay := 0;
      ELSIF l_in_out_flag = 'O'
      THEN
          o_lis_pay_mov_flag := l_in_out_flag;
          o_lis_con_pay := nvl(o_lis_con_pay,0);
          o_lis_loc_pay := nvl(o_lis_loc_pay,0);
      ELSIF l_in_out_flag = 'I'
      THEN
          o_lis_pay_mov_flag := l_in_out_flag;
          o_lis_con_pay := -1 * nvl(o_lis_con_pay,0);
          o_lis_loc_pay := -1 * nvl(o_lis_loc_pay,0);
      END IF;
      
      EXCEPTION WHEN OTHERS THEN NULL;
  
END x_prc_get_lic_mvmt_data;

  --Gets the effective payments for a given license and lsl number within a specified
  --period.
PROCEDURE x_prc_get_mve_amt(
          i_lic_number        IN          NUMBER,
          i_lsl_number        IN          x_fin_lic_sec_lee.lsl_number%TYPE,
          i_from_date         IN          DATE,
          i_to_date           IN          DATE,
          o_con_pay             OUT       NUMBER,
          o_lic_pay             OUT       NUMBER)
    AS
        l_count                 NUMBER := 0;
        licpay_con_paid_is      NUMBER := 0;
        l_refund_amt            NUMBER := 0;
    BEGIN
        SELECT SUM(nvl(pay_amount,0))
          INTO o_con_pay
          FROM fid_payment
         WHERE pay_lic_number = i_lic_number
           AND pay_lsl_number = i_lsl_number
           AND pay_status = 'P'
           AND nvl(pay_date,pay_status_date) BETWEEN nvl(i_from_date,nvl(pay_date,pay_status_date)) AND nvl(i_to_date,nvl(pay_date,pay_status_date));
         
        SELECT COUNT (*)
          INTO l_count
          FROM x_fin_refund_settle xfrs
         WHERE xfrs.frs_lic_number = i_lic_number;
        
        BEGIN
            IF l_count > 0
            THEN
               FOR i IN (SELECT fp.pay_number, fp.pay_amount, fp.pay_rate
                           FROM fid_payment fp,
                                fid_payment_type fpt,
                                x_fin_lic_sec_lee xfsl
                          WHERE fp.pay_lsl_number = xfsl.lsl_number
                            AND fp.pay_lsl_number = i_lsl_number
                            AND fp.pay_lic_number = i_lic_number
                            AND fp.pay_status = 'P'
                            AND fpt.pat_code = fp.pay_code
                            AND nvl(pay_date,pay_status_date) BETWEEN nvl(i_from_date,nvl(pay_date,pay_status_date)) AND nvl(i_to_date,nvl(pay_date,pay_status_date)))
               LOOP
                  IF (i.pay_amount < 0)
                  THEN
                     SELECT NVL (SUM (xfrs.frs_rfd_amount), 0)
                       INTO l_refund_amt
                       FROM x_fin_refund_settle xfrs
                      WHERE xfrs.frs_rfd_pay_number = i.pay_number;
      
                     licpay_con_paid_is := licpay_con_paid_is + (i.pay_amount + l_refund_amt) * i.pay_rate;
                  ELSIF (i.pay_amount > 0)
                  THEN
                     SELECT NVL (SUM (xfrs.frs_rfd_amount), 0)
                       INTO l_refund_amt
                       FROM x_fin_refund_settle xfrs, fid_payment fp
                      WHERE xfrs.frs_pay_number = i.pay_number
                        AND xfrs.frs_rfd_pay_number = fp.pay_number
                        AND xfrs.frs_lic_number = i_lic_number
                        AND nvl(pay_date,pay_status_date) BETWEEN nvl(i_from_date,nvl(pay_date,pay_status_date)) AND nvl(i_to_date,nvl(pay_date,pay_status_date));
      
                     licpay_con_paid_is := licpay_con_paid_is + (i.pay_amount - l_refund_amt) * i.pay_rate;
                  END IF;
               END LOOP;
            ELSE
               SELECT SUM (fp.pay_amount * fp.pay_rate)
                 INTO licpay_con_paid_is
                 FROM fid_payment fp, fid_payment_type fpt, x_fin_lic_sec_lee xfsl
                WHERE fp.pay_lsl_number = xfsl.lsl_number
                  AND fp.pay_lic_number = i_lic_number
                  AND fp.pay_lsl_number = i_lsl_number
                  AND fp.pay_status = 'P'
                  AND fpt.pat_code = fp.pay_code
                  AND nvl(pay_date,pay_status_date) BETWEEN nvl(i_from_date,nvl(pay_date,pay_status_date)) AND nvl(i_to_date,nvl(pay_date,pay_status_date))
                  AND fpt.pat_group = 'F';
            END IF;
            EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 o_lic_pay := 0;
         END;

        IF licpay_con_paid_is IS NULL
        THEN
           o_lic_pay := 0;
        ELSE
           o_lic_pay := licpay_con_paid_is;
        END IF;
	END;
	
  --Finance Dev Phase I [End]

end FID_COS_PK;
/