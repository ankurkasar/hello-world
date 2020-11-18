CREATE OR REPLACE PACKAGE PKG_ALIC_CM_LICENSEMAINTENANCE
AS
   /****************************************************************
   REM Module        : Acquisition Module
   REM Client          : MNET and SS
   REM File Name        : pkg_alic_cm_licensemaintenance.sql
   REM Form Name        : License Maintenance
   REM Purpose         : For maintening License
   REM Author        : Karim Ajani
   REM Creation Date   : 08 Apr 2010
   REM Type            : Database Package
   REM Change History  :
   ****************************************************************/
   TYPE c_cursor_alic_cm_licmaintenanc IS REF CURSOR;

   --15_FIN_06_ENH_Cancel Season in one attempt_v1.0
   TYPE lic_number_ary IS TABLE OF VARCHAR2 (20) INDEX BY PLS_INTEGER;

   TYPE lic_details IS TABLE OF VARCHAR2 (32767) INDEX BY PLS_INTEGER;
   --15_FIN_06_ENH_Cancel Season in one attempt_v1.0

   --****************************************************************
   -- This procedure searches License
   -- REM Client - MNET and SS
   --****************************************************************
   PROCEDURE prc_alic_cm_searchlicense (
      i_gentitle            IN     fid_license_vw.gen_title%TYPE,
      i_licnumber           IN     VARCHAR2,
      i_conshortname        IN     fid_license_vw.con_short_name%TYPE,
      i_licmemnumber        IN     VARCHAR2,
      i_licstart            IN     VARCHAR2,
      i_licend              IN     VARCHAR2,
      i_lictype             IN     fid_license_vw.lic_type%TYPE,
      i_leeshortname        IN     fid_license_vw.lee_short_name%TYPE,
      i_licstatus           IN     fid_license_vw.lic_status%TYPE,
      i_licchsnumber        IN     fid_license_vw.lic_chs_number%TYPE,
      -- PB CR Mrunmayi
      i_supplier_category   IN     fid_company.com_internal%TYPE,
      -- end
      i_gen_ref_no          IN     fid_license_vw.gen_refno%TYPE,
      o_searchlicense       OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   --****************************************************************
   -- This procedure searches License Details.
   -- This procedure input is License Number.
   -- REM Client - MNET and SS
   --****************************************************************
   PROCEDURE prc_alic_cm_licensedetail (
      i_licnumber                  IN     fid_license.lic_number%TYPE,
      o_licensedetail                 OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      -- Project Bioscope : Ajit_20120314 : New Cursor for Media Service, Media Platform
      o_searchmediasermediaplat       OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_costed_prog_type              OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc, -- Project Bioscope : Ajit_20120314 : End
      -- Project 5_2 : Aditya Gupta_20140606 : New Cursor for 5_2 requirement for closed months costed runs per channel
      o_costed_closed_cha_lic         OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc, -- Project 5_2 : End
      -- CATCHUP : CACQ:14 fro license rights detail load_{SHANTANU A.}
      O_lic_medplatmdevcompatmap      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_lic_med_dev_rights            OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_media_service                 out  pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,

   -- CATCHUP: END
   --Dev.R1: CatchUp for All :[BR_15_272_UC_Super Stacking]_[Milan Shah]_[2015/12/29]: Start
      O_SUPERSTACK_RIGHTS              OUT SYS_REFCURSOR );
   --Dev.R1: CatchUp for All: End
   --****************************************************************
   -- This procedure edits License Details.
   -- It uses license number and update count for updating record.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_editlicensedetail (
      i_licnumber                 IN     fid_license.lic_number%TYPE,
      i_licleenumber              IN     fid_license.lic_lee_number%TYPE,
      i_licchsnumber              IN     fid_license.lic_chs_number%TYPE,
      i_licexternalref            IN     fid_license.lic_external_ref%TYPE,
      i_licstatus                 IN     fid_license.lic_status%TYPE,
      -- Project Bioscope : Ajit_20120316 : premium and Time Shift Flag added
      i_premier                   IN     fid_license.lic_premium_flag%TYPE,
      --License On Hold : Deepak_20120827 :on hold flag added
      i_onhold                    IN     fid_license.lic_on_hold_flag%TYPE,
      ----DEV.RDT: PHOENIX REQUIREMENT: START:Phoenix_04_Marking_License_as_Feed_NEERAJ_2014/03/21]
      i_licfeed                   IN     fid_license.lic_feed_flag%TYPE,
      ----DEV.RDT: PHOENIX REQUIREMENT: END------------------------
      i_timeshiftchannel          IN     fid_license.lic_time_shift_cha_flag%TYPE,
      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
      i_simulcastchannel                 fid_license.lic_simulcast_cha_flag%TYPE,
      /* PB (CR 12) : END */
      -- Project Bioscope : Ajit_20120316 : End
      -- CP R1 mrunmayi kusurkar
      i_max_vp_in_days            IN     fid_license.lic_max_viewing_period%TYPE,
      i_sch_aft_prem_linear       IN     fid_license.lic_sch_aft_prem_linear%TYPE,
      --CATCHUP : CACQ:14 add new validation parameters for catchup license [SHANTANU A.]_[08-oct-2014]
      i_sch_x_days_bef_linr       IN     fid_license.lic_sch_bef_x_day%TYPE,
      i_sch_x_days_bef_linr_val   IN     fid_license.lic_sch_bef_x_day_value%TYPE,
      i_sch_without_linr_ref      IN     fid_license.lic_sch_without_lin_ref%TYPE,
      --CATCHUP : CACQ:14 add new validation parameters for catchup license [SHANTANU A.]_[END]
      i_non_cons_month            IN     fid_license.lic_non_cons_month%TYPE,
      i_catchup_upd_cnt           IN     fid_license.lic_update_count%TYPE,
      -- end
      i_licstart                  IN     fid_license.lic_start%TYPE,
      i_licend                    IN     fid_license.lic_end%TYPE,
      i_licperiodtba              IN     fid_license.lic_period_tba%TYPE,
      i_licpricecode              IN     fid_license.lic_price_code%TYPE,
      i_licbudgetcode             IN     fid_license.lic_budget_code%TYPE,
      i_licprice                  IN     fid_license.lic_price%TYPE,
      i_licmarkuppercent          IN     fid_license.lic_markup_percent%TYPE,
      i_licshowingint             IN     fid_license.lic_showing_int%TYPE,
      i_licshowinglic             IN     fid_license.lic_showing_lic%TYPE,
      i_licamortcode              IN     fid_license.lic_amort_code%TYPE,
      i_licmaxchs                 IN     fid_license.lic_max_chs%TYPE,
      i_licmaxcha                 IN     fid_license.lic_max_cha%TYPE,
      i_licexclusive              IN     fid_license.lic_exclusive%TYPE,
      i_licminsubscriber          IN     fid_license.lic_min_subscriber%TYPE,
      i_licminguarantee           IN     fid_license.lic_min_guarantee%TYPE,
      i_liccomment                IN     fid_license.lic_comment%TYPE,
      i_licupdatecount            IN     fid_license.lic_update_count%TYPE,
      i_lic_rate                  IN     fid_license.lic_rate%TYPE,
      i_entryoper                 IN     fid_license.lic_entry_oper%TYPE,
      -- Pure Finance : Nishant Ankam Africa Free Repeat
      i_nooffreereps              IN     fid_license.lic_free_rpt%TYPE,
      i_repperiod                 IN     fid_license.lic_rpt_period%TYPE,
      -- end
      -- PB CR Mrunmayi
      i_bo_category               IN     fid_general.gen_bo_category_code%TYPE,
      -- END
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : check for transfer_payment operation
      i_trnsfr_pmnt_flag          IN     VARCHAR2,
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : end
       ---BR_15_144:Warner Payment: Rashmi Tijare_20150107:Addition of Checkboxes
      i_min_gurantee_lic          IN     fid_license.LIC_MIN_GUARANTEE_FLAG%type,
      i_min_gurantee_sub          IN     fid_license.lic_min_subs_flag %type,
      --Warner Payment End
      --RDT Start : Acquision Requirements BR_15_244 [Rashmi_Tijare][14/10/2015]
      i_is_dstv_right              In     fid_license.lic_is_dstv_right%TYPE,
      i_dstv_flag                 In Varchar2,
--RDT End : Acquision Requirements BR_15_244 [Rashmi_Tijare][14/10/2015]
--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
       i_lic_details  in pkg_alic_cm_licensemaintenance.lic_details,
--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
      o_status                       OUT NUMBER,
      o_paymonthno                   OUT NUMBER,
      o_sch_lic_present_past       OUT VARCHAR2);
  
   --Finance Dev Phase I Zeshan [Start]   
   --****************************************************************
   --This procedure logs license status history details
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE X_PRC_MANAGE_LIC_HISTORY(
    I_LIC_NUMBER        IN        NUMBER,
    I_LIC_START         IN        DATE,
    I_LIC_END           IN        DATE,
    I_LIC_STATUS        IN        VARCHAR2,
    I_LIC_LEE_NUMBER    IN        NUMBER,
    I_LIC_ENTRY_OPER    IN        VARCHAR2
   );
   --Finance Dev Phase I [End]
  
   --****************************************************************
   -- This procedure searches Channel Allocation.
   -- This procedure input is license Number and Contract Prime Time Level.
   -- REM Client - MNET and SS
   --****************************************************************
   PROCEDURE prc_alic_cm_searchchnlallocat (
      i_lcrlicnumber              IN     fid_license_channel_runs.lcr_lic_number%TYPE,
      i_conprimetimelevel         IN     fid_contract.con_prime_time_level%TYPE,
      o_searchchannelallocation      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   --****************************************************************
   -- This procedure inserts Channel Allocation.
   -- REM Client - MNET
   --****************************************************************

   -----------------------------------------------------------------------
--Warner Payment :Rashmi Tijare.10:07-2015
--Popup for minimum Gurantee
-------------------------------------------------------------------

Procedure prc_alic_cm_mingurantee_popup
(
i_prog_title     IN fid_general.gen_title%TYPE,
 i_contract_no    IN     fid_contract.con_number%TYPE,
 i_mem_id         IN   sak_memo.mem_id%TYPE,
 o_data           out sys_refcursor
 );

   -----------------------------------------------------------------------
--Warner Payment :Rashmi Tijare.10:07-2015
-------------------------------------------------------------------

Procedure prc_alic_cm_mingurantee_update
(

i_old_lic_number    In fid_license.lic_number%type,
i_new_lic_number    In  fid_license.lic_number%type,
o_data              out number
);
   PROCEDURE prc_alic_cm_addchnlallocat (
      i_lcrlicnumber         IN     fid_license_channel_runs.lcr_lic_number%TYPE,
      i_lcrchanumber         IN     fid_license_channel_runs.lcr_cha_number%TYPE,
      i_lcrrunsallocated     IN     fid_license_channel_runs.lcr_runs_allocated%TYPE,
      -- Project Bioscope : Ajit_20120316 : Allocation Costed Runs added
      i_allocationscosted    IN     fid_license_channel_runs.lcr_cha_costed_runs%TYPE,
      i_allocationscosted2   IN     fid_license_channel_runs.lcr_cha_costed_runs2%TYPE,
      -- Project Bioscope : Ajit_20120316 : End
      /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
      i_lcr_max_runs_cha     IN     fid_license_channel_runs.lcr_max_runs_cha%TYPE,
      i_lcrrunsused          IN     fid_license_channel_runs.lcr_runs_used%TYPE,
      i_lcrcostind           IN     fid_license_channel_runs.lcr_cost_ind%TYPE,
      i_lcrpostexhruns       IN     fid_license_channel_runs.lcr_post_exh_runs%TYPE,
      i_lcrentryoper         IN     fid_license_channel_runs.lcr_entry_oper%TYPE,
      o_status                  OUT NUMBER);

   --****************************************************************
   -- This procedure deletes Channel Allocation.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_deletechnlallocat (
      i_lcrnumber        IN     fid_license_channel_runs.lcr_number%TYPE,
      i_lcrlicnumber     IN     fid_license_channel_runs.lcr_lic_number%TYPE,
      i_lcrchanumber     IN     fid_license_channel_runs.lcr_cha_number%TYPE,
      i_lcrupdatecount   IN     fid_license_channel_runs.lcr_update_count%TYPE,
      i_entryoper        IN     fid_license.lic_entry_oper%TYPE,
      o_status              OUT NUMBER);

   --****************************************************************
   -- This procedure updates Channel Allocation details.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_editchnlallocat (
      i_lcrnumber            IN     fid_license_channel_runs.lcr_number%TYPE,
      i_lcrlicnumber         IN     fid_license_channel_runs.lcr_lic_number%TYPE,
      i_lcrchanumber         IN     fid_license_channel_runs.lcr_cha_number%TYPE,
      i_lcrrunsallocated     IN     fid_license_channel_runs.lcr_runs_allocated%TYPE,
      -- Project Bioscope : Ajit_20120316 : Allocation Costed Runs added
      i_allocationscosted    IN     fid_license_channel_runs.lcr_cha_costed_runs%TYPE,
      i_allocationscosted2   IN     fid_license_channel_runs.lcr_cha_costed_runs2%TYPE,
      -- Project Bioscope : Ajit_20120316 : End
      /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
      i_lcr_max_runs_cha     IN     fid_license_channel_runs.lcr_max_runs_cha%TYPE,
      i_lcrcostind           IN     fid_license_channel_runs.lcr_cost_ind%TYPE,
      i_lcrupdatecount       IN     fid_license_channel_runs.lcr_update_count%TYPE,
      i_entry_oper           IN     fid_license_channel_runs.lcr_entry_oper%TYPE,
      o_status                  OUT NUMBER);

   --****************************************************************
   -- This procedure searches Territory Pricing.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_searchterrypricing (
      i_lillicnumber             IN     fid_license_ledger.lil_lic_number%TYPE,
      o_searchterritorypricing      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   --****************************************************************
   -- This procedure updates Territory Pricing details.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_editterrypricing (
      i_lillicnumber      IN     fid_license_ledger.lil_lic_number%TYPE,
      i_liltercode        IN     fid_license_ledger.lil_ter_code%TYPE,
      i_lilrghcode        IN     fid_license_ledger.lil_rgh_code%TYPE,
      i_lilpricecode      IN     fid_license_ledger.lil_price_code%TYPE,
      i_price             IN     fid_license_ledger.lil_price%TYPE,
      i_liladjustfactor   IN     fid_license_ledger.lil_adjust_factor%TYPE,
      i_lilupdatecount    IN     fid_license_ledger.lil_update_count%TYPE,
      o_status               OUT NUMBER);

   --****************************************************************
   -- This procedure searches License History.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_searchlichistory (
      i_lihlicnumber           IN     fid_license_history.lih_lic_number%TYPE,
      o_searchlicensehistory      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   --****************************************************************
   -- This procedure inserts License History.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_addlichistory (
      i_lihlicnumber   IN     fid_license_history.lih_lic_number%TYPE,
      i_lihcode        IN     fid_license_history.lih_code%TYPE,
      i_lihdate        IN     fid_license_history.lih_date%TYPE,
      i_lihcomment     IN     fid_license_history.lih_comment%TYPE,
      i_lihentryoper   IN     fid_license_history.lih_entry_oper%TYPE,
      o_status            OUT NUMBER);

   --****************************************************************
   -- This procedure updates License History details.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_editlichistory (
      i_lihnumber        IN     fid_license_history.lih_number%TYPE,
      i_lihcode          IN     fid_license_history.lih_code%TYPE,
      i_lihdate          IN     fid_license_history.lih_date%TYPE,
      i_lihcomment       IN     fid_license_history.lih_comment%TYPE,
      i_lihupdatecount   IN     fid_license_history.lih_update_count%TYPE,
      o_status              OUT NUMBER);

   --****************************************************************
   -- This procedure deletes License History.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_deletelichistory (
      i_lihnumber        IN     fid_license_history.lih_number%TYPE,
      i_lihupdatecount   IN     fid_license_history.lih_update_count%TYPE,
      o_status              OUT NUMBER);

   --****************************************************************
   -- This procedure searches License Royalty Plan.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_searchroyalpayplan (
      i_lpylicnumber               IN     fid_license_payment_months.lpy_lic_number%TYPE,
      o_searchroyaltypaymentplan      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_searchroypayperterritory      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_searchroyalmgpayterritory  OUT   Sys_refcursor
      );


   /* Warner Payment 13-07-2015:Added for  Minimum Gurantee Payment Grid */

   Procedure prc_alic_cm_srchminguapayplan
   (
   i_licnumber        In x_fin_mg_pay_plan.MGP_LIC_NUMBER%type,
   --i_dmgp_number      In   x_fin_mg_pay_plan.mgp_number%type,
   o_lic_payment_plan  out sys_refcursor,
   o_royalpay         Out  sys_refcursor
   );

Procedure prc_alic_cm_add_mingua
  (i_lic_number In  x_fin_mg_pay_plan.mgp_lic_number%TYPE,
   i_month_no    In  x_fin_mg_pay_plan.MGP_PAY_MONTH_NO%TYPE,
   i_pay_mon     In   x_fin_mg_pay_plan.mgp_pay_month%TYPE,
   i_percent    In  x_fin_mg_pay_plan.mgp_pay_percent%TYPE,
    i_entry_oper  IN  x_fin_mg_pay_plan.mgp_entry_oper%TYPE,
   o_status     Out  x_fin_mg_pay_plan.mgp_number%TYPE
  );
Procedure prc_alic_cm_upd_minguarantee
  (i_licnum  In   x_fin_mg_pay_plan.mgp_lic_number%TYPE,
   i_mgp_number  In   x_fin_mg_pay_plan.mgp_number%TYPE,
   i_month_no    In   x_fin_mg_pay_plan.MGP_PAY_MONTH_NO%TYPE,
   i_pay_mon     In   x_fin_mg_pay_plan.mgp_pay_month%TYPE,
   i_percent     In   x_fin_mg_pay_plan.mgp_pay_percent%TYPE,
   i_entry_oper       IN  x_fin_mg_pay_plan.mgp_entry_oper%TYPE,
    i_update_count  IN     x_fin_mg_pay_plan.MGP_UPDATE_COUNT%TYPE,
   o_paymentupdated      OUT NUMBER
  );
 PROCEDURE prc_alic_cm_del_mingua (
      i_mgp_number      IN     x_fin_mg_pay_plan.mgp_number%TYPE,
      i_lic_number        In     x_fin_mg_pay_plan.mgp_lic_number%TYPE,
       i_entry_oper  IN  x_fin_mg_pay_plan.mgp_entry_oper%TYPE,
      i_update_count     IN     x_fin_mg_pay_plan.MGP_UPDATE_COUNT%TYPE,
      o_paymentdeleted      OUT NUMBER);

   /* PB (CR) :Pranay Kusumwal 21/06/2012 : Added for CR for new payment terms for royalty */
   -------------------------------------- PROCEDURE TO view SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_alic_cm_searchsplitpay (
      i_licnumber      IN     fid_license_payment_months.lpy_lic_number%TYPE,
      o_splitpayment      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 21/06/2012 : Added for editing  new payment terms for royalty */
   -------------------------------------- PROCEDURE TO Add SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_alic_cm_insertsplitpayment (
      i_lic_number       IN     sgy_lic_split_payment.lsp_lic_number%TYPE,
      i_month_num        IN     sgy_lic_split_payment.lsp_split_month_num%TYPE,
      i_pct_pay          IN     sgy_lic_split_payment.lsp_percent_payment%TYPE,
      i_entry_oper       IN     sgy_lic_split_payment.lsp_entry_oper%TYPE,
      -- Dev2: Pure Finance :Start:[Licence Maintenance Details]_[ADITYA GUPTA]_[2013/3/22]
      -- [License Maintenance Details Screen modifications]
      i_lpy_number       IN     sgy_lic_split_payment.lsp_lpy_number%TYPE,
      -- Dev2: Pure Finance :End
      o_success_number      OUT NUMBER);

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   ------------------------------------- PROCEDURE TO DELETE PAYMENT -----------------------------------------
   PROCEDURE prc_alic_cm_deletesplitpayment (
      i_lsp_id           IN     sgy_lic_split_payment.lsp_id%TYPE,
      i_lic_number       IN     sgy_lic_split_payment.lsp_lic_number%TYPE,
      o_paymentdeleted      OUT NUMBER);

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 21/06/2012 : Added for editing  new payment terms for royalty */
   -------------------------------------- PROCEDURE TO view SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_alic_cm_editsplitpayment (
      i_lsp_id           IN     sgy_lic_split_payment.lsp_id%TYPE,
      i_lic_number       IN     sgy_lic_split_payment.lsp_lic_number%TYPE,
      i_month_num        IN     sgy_lic_split_payment.lsp_split_month_num%TYPE,
      i_pct_pay          IN     sgy_lic_split_payment.lsp_percent_payment%TYPE,
      i_entry_oper       IN     sgy_lic_split_payment.lsp_entry_oper%TYPE,
      -- Dev2: Pure Finance :Start:[Licence Maintenance Details]_[ADITYA GUPTA]_[2013/3/22]
      -- [License Maintenance Details Screen modifications]
      i_lpy_number       IN     sgy_lic_split_payment.lsp_lpy_number%TYPE,
      -- Dev2: Pure Finance :End
      o_success_number      OUT NUMBER);

   --****************************************************************
   -- This procedure updates License Royalty Plan details.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_editroyalpayplan (
      i_lpynumber        IN     fid_license_payment_months.lpy_number%TYPE,
      i_lpylicnumber     IN     fid_license_payment_months.lpy_lic_number%TYPE,
      i_lpypaymonthno    IN     fid_license_payment_months.lpy_pay_month_no%TYPE,
      i_lpypaymonth      IN     fid_license_payment_months.lpy_pay_month%TYPE,
      i_lpypaypercent    IN     fid_license_payment_months.lpy_pay_percent%TYPE,
      i_lpycurcode       IN     fid_license_payment_months.lpy_cur_code%TYPE,
      i_lpypaycode       IN     fid_license_payment_months.lpy_pay_code%TYPE,
      i_lpyupdatecount   IN     fid_license_payment_months.lpy_update_count%TYPE,
      i_entryoper        IN     fid_license_payment_months.lpy_entry_oper%TYPE,
      o_status              OUT NUMBER);

   ----Added for Biscope by Pranay Kusumwal 08/05/2012   Start---
   -----Updating Month and Date--------
   PROCEDURE prc_alic_cm_updateroyplandate (
      i_lpynumber        IN     fid_license_payment_months.lpy_number%TYPE,
      i_lpylicnumber     IN     fid_license_payment_months.lpy_lic_number%TYPE,
      i_lpypaymonthno    IN     fid_license_payment_months.lpy_pay_month_no%TYPE,
      i_lpypayislastmonth    IN     fid_license_payment_months.lpy_pay_islastmonth%TYPE,--Onsite.Dev:BR_15_321
      i_lpypaymonth      IN     fid_license_payment_months.lpy_pay_month%TYPE,
      i_lpyupdatecount   IN     fid_license_payment_months.lpy_update_count%TYPE,
      i_entryoper        IN     fid_license_payment_months.lpy_entry_oper%TYPE,
      o_status              OUT NUMBER);

   -------Bioscope changes end By Pranay Kusumwal------------

   --****************************************************************
   -- This procedure searches License Payment Schedule Plan.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_searchpayschedule (
      i_licnumber        IN     fid_license_vw.lic_number%TYPE,
      o_searchlicenses      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   --****************************************************************
   -- This procedure validates license status C.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_validatelicstatus (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      o_status         OUT NUMBER);

   --****************************************************************
   -- This procedure validates license TBA.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_tbachanged (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      o_status         OUT NUMBER);

   --****************************************************************
   -- This procedure validates license start date.
   -- This procedure input is license Number and modified license end date.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_validatestartdate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licstart    IN     fid_license.lic_start%TYPE,
      o_status         OUT NUMBER);

   --****************************************************************
   -- This procedure validates license end date.
   -- This procedure input is license Number and modified license end date.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_validateenddate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licend      IN     fid_license.lic_end%TYPE,
      o_status         OUT NUMBER);

   --****************************************************************
   -- This procedure is for LOV.
   -- REM Client - MNET and SS
   --****************************************************************
   PROCEDURE prc_alic_cm_channelservice (
      o_chansrvcname OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   --****************************************************************
   -- This procedure is for LOV.
   -- REM Client - MNET and SS
   --****************************************************************
   PROCEDURE prc_alic_cm_lcrchashortname (
      i_licchsnumber      IN     fid_license.lic_chs_number%TYPE,
      o_lcrchashortname      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   --****************************************************************
   -- This procedure is default.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE calc_pay_month (l_split_region    IN     NUMBER,
                             l_lic_start       IN     DATE,
                             l_lic_end         IN     DATE,
                             l_lic_tba         IN     VARCHAR2,
                             l_lpy_month_no    IN     NUMBER,
                             l_lpy_pay_month      OUT DATE);

   -- #############################################
   ---- CP R1 Mrunmayi kusurkar

   -- This procedure validates license start date for catch up.
   PROCEDURE prc_cp_validatestartdate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licstart    IN     fid_license.lic_start%TYPE,
      o_status         OUT NUMBER);

   -- This procedure validates license end date of catch up..
   PROCEDURE prc_cp_validateenddate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licend      IN     fid_license.lic_end%TYPE,
      o_status         OUT NUMBER);

   -- This procedure validates license status C.
   -- for catch up.
   PROCEDURE prc_cp_validatelicstatus (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      o_status         OUT NUMBER);

   -- This procedure validates catchup license TBA.
   PROCEDURE prc_cp_tbachanged (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      o_status         OUT NUMBER);

   -- end....
   --########################################################

   ---- Pure Finance - Start --Changes for FIN3 by Nishant Ankam
   PROCEDURE prc_search_lee_allocation (
      i_lic_number   IN     x_fin_lic_sec_lee.lsl_lic_number%TYPE,
      o_sec_lee         OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   PROCEDURE prc_add_lee_allocation (
      i_lic_number           IN     x_fin_lic_sec_lee.lsl_lic_number%TYPE,
      i_lic_lee_number       IN     x_fin_lic_sec_lee.lsl_lee_number%TYPE,
      i_lic_lee_alloc        IN     x_fin_lic_sec_lee.lsl_lee_price%TYPE,
      i_lee_is_primary       IN     x_fin_lic_sec_lee.lsl_is_primary%TYPE,
      i_lic_lee_entry_opr    IN     x_fin_lic_sec_lee.lsl_entry_oper%TYPE,
      i_lic_lee_entry_date   IN     x_fin_lic_sec_lee.lsl_entry_date%TYPE,
      o_status                  OUT NUMBER);

   PROCEDURE prc_update_lee_allocation (
      i_lic_number          IN     x_fin_lic_sec_lee.lsl_lee_number%TYPE,
      i_lic_lsl_number      IN     x_fin_lic_sec_lee.lsl_number%TYPE,
      i_lic_lee_number      IN     x_fin_lic_sec_lee.lsl_lee_number%TYPE,
      i_lic_lee_alloc       IN     x_fin_lic_sec_lee.lsl_lee_price%TYPE,
      i_lic_is_primary      IN     x_fin_lic_sec_lee.lsl_is_primary%TYPE,
      i_lic_modified_by     IN     x_fin_lic_sec_lee.lsl_modified_by%TYPE,
      i_lic_modified_date   IN     x_fin_lic_sec_lee.lsl_modified_on%TYPE,
      i_update_count        IN     x_fin_lic_sec_lee.lsl_update_count%TYPE,
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : check for transfer_payment operation
      i_trnsfr_pmnt_flag    IN     VARCHAR2,
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : end
      o_cursor_lee_alloc       OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_update_count           OUT x_fin_lic_sec_lee.lsl_update_count%TYPE);

   PROCEDURE prc_delete_lee_allocation (
      i_lic_lsl_number   IN     x_fin_lic_sec_lee.lsl_number%TYPE,
      i_update_count     IN     x_fin_lic_sec_lee.lsl_update_count%TYPE,
      i_entry_oper       IN     x_fin_lic_sec_lee.lsl_entry_oper%TYPE,
      o_update_count        OUT x_fin_lic_sec_lee.lsl_update_count%TYPE,
      o_success             OUT NUMBER);

   PROCEDURE prc_spot_rate_details (
      i_lic_number        IN     x_fin_lic_sec_lee.lsl_lic_number%TYPE,
      o_cursor_prepaymt      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_cursor_remlib        OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   -- Start :Abhinay_20Mar2014 :: Email Notification on License cancellation

--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
PROCEDURE prc_lic_canc_email_in_bulk (
      i_lic_details in pkg_alic_cm_licensemaintenance.lic_details,
      o_cursor          OUT CLOB) ;
--15_FIN_06_ENH_Cancel Season in one attempt_v1.0

   PROCEDURE prc_lic_canc_email (
      i_lic_number   IN     fid_license.lic_number%TYPE,
      i_gen_refno    IN     fid_general.gen_refno%TYPE,
      o_cursor          OUT varchar2);

   -- END :

   --- End -- changes for FIN3 by Nishant Ankam
   FUNCTION x_fun_costed_channel (
      i_licnumber        IN fid_license.lic_number%TYPE,
      i_cha_number       IN fid_channel.cha_number%TYPE,
      i_sch_start_date   IN fid_license_channel_runs.lcr_sch_start_date%TYPE,
      i_sch_end_date     IN fid_license_channel_runs.lcr_sch_end_date%TYPE)
      RETURN NUMBER;

   FUNCTION x_fnc_get_lic_paidamt (
      i_lic_number IN FID_LICENSE.lic_number%TYPE)
      RETURN NUMBER;

   PROCEDURE x_prc_alic_cm_desti_lic_search (
      i_lic_no              FID_LICENSE.lic_number%TYPE,
      i_gen_refno           fid_general.gen_refno%TYPE,
      i_lee_no              fid_licensee.lee_number%TYPE,
      i_contract_no         fid_contract.con_number%TYPE,
      i_series_flag         VARCHAR2,
      i_catch_up_flag       FID_LICENSE.LIC_CATCHUP_FLAG%TYPE,
      o_data_out        OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

   FUNCTION x_fun_is_primary (I_LIC_NO NUMBER)
      RETURN VARCHAR2;

   PROCEDURE x_prc_alic_cm_transfer_payment (
      i_src_lic_no            FID_LICENSE.lic_number%TYPE,
      i_dst_lic_no            FID_LICENSE.lic_number%TYPE,
      i_pay_comment           VARCHAR2,
      i_entry_date            DATE,
      i_entry_oper            VARCHAR2,
      i_lsl_lee_price         FID_LICENSE.lic_price%TYPE,
      i_lic_showing_lic       FID_LICENSE.lic_showing_lic%TYPE,
      o_success_flag      OUT NUMBER);

   PROCEDURE x_prc_alic_cm_trf_validation (
      i_src_lic_no    FID_LICENSE.lic_number%TYPE,
      i_dst_lic_no    FID_LICENSE.lic_number%TYPE);

   PROCEDURE x_prc_alic_cm_trnsfr_pmt_ins (i_username   IN     VARCHAR2,
                                           o_status        OUT NUMBER);

   PROCEDURE x_prc_alic_cm_trnsfr_pmt_del (i_username   IN     VARCHAR2,
                                           o_status        OUT NUMBER);

   --CATCHUP:CACQ14:Start:[SHANTANU A.]_13-nov-2104
   --Following procedure will update the catchup device rights at licens level
   PROCEDURE x_prc_cp_upd_lic_medplatdevcmp (
      i_lic_number           IN     fid_contract.con_number%TYPE,
      i_MPDC_DEV_PLATM_ID    IN     x_cp_lic_medplatmdevcompat_map.LIC_MPDC_DEV_PLATM_ID%TYPE,
      i_rights_on_device     IN     VARCHAR2,
      i_med_comp_rights      IN     VARCHAR2,
      i_med_IS_COMP_RIGHTS   IN     VARCHAR2,
      i_entry_oper           IN     x_cp_lic_medplatmdevcompat_map.LIC_MPDC_ENTRY_OPER%TYPE,
      o_status                  OUT NUMBER);
--CATCHUP:CACQ14:[END]

--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
   PROCEDURE x_prc_alic_episode_details(
       i_lic_number   IN  number,
       i_lee_number in number,
       i_con_number in number,
       i_flag in varchar2,
       i_gen_ser_number number
      ,o_series_data  OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc
      ,o_episodes     OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc);

      PROCEDURE x_prc_alic_validatelicstatus (
      i_licnumber_list   IN     PKG_ALIC_CM_LICENSEMAINTENANCE.lic_number_ary,
      o_status         OUT clob);

  --Start by Milan Shah for CU4ALL
  FUNCTION x_fnc_cal_viewing_days (I_Lic_number in number,I_Bouquet_id in number)
      RETURN number;
  --End Milan Shah

END pkg_alic_cm_licensemaintenance;
/
CREATE OR REPLACE PACKAGE BODY PKG_ALIC_CM_LICENSEMAINTENANCE
AS
   /****************************************************************
   REM Module        : Acquisition Module
   REM Client          : MNET
   REM File Name        : pkg_alic_cm_licensemaintenance.sql
   REM Form Name        : License Maintenance
   REM Purpose         : For maintening License
   REM Author        : Karim Ajani
   REM Creation Date   : 08 Apr 2010
   REM Type            : Database Package
   REM Change History  :
   ****************************************************************/

   --****************************************************************
   -- This procedure searches License
   --****************************************************************
   PROCEDURE prc_alic_cm_searchlicense (
      i_gentitle            IN     fid_license_vw.gen_title%TYPE,
      i_licnumber           IN     VARCHAR2,
      i_conshortname        IN     fid_license_vw.con_short_name%TYPE,
      i_licmemnumber        IN     VARCHAR2,
      i_licstart            IN     VARCHAR2,
      i_licend              IN     VARCHAR2,
      i_lictype             IN     fid_license_vw.lic_type%TYPE,
      i_leeshortname        IN     fid_license_vw.lee_short_name%TYPE,
      i_licstatus           IN     fid_license_vw.lic_status%TYPE,
      i_licchsnumber        IN     fid_license_vw.lic_chs_number%TYPE,
      -- PB CR Mrunmayi
      i_supplier_category   IN     fid_company.com_internal%TYPE,
      -- end
      i_gen_ref_no          IN     fid_license_vw.gen_refno%TYPE,
      o_searchlicense       OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
      stmt_str   VARCHAR2 (5000);
   BEGIN
      stmt_str :=
         'SELECT flv.gen_title, flv.lic_number, flv.con_short_name, flv.lic_mem_number,
         flv.lic_start, flv.lic_end, flv.lic_type, flv.lee_short_name, flv.gen_refno,
         flv.lic_lee_number, flv.lic_chs_number, flv.lic_con_number, flv.lic_status,
         NVL((SELECT chs_short_name FROM fid_channel_service WHERE chs_number = flv.lic_chs_number),
        (SELECT cha_short_name FROM fid_channel WHERE cha_number = flv.lic_chs_number)) "Channel/Service"
       -- CP R1 mrunmayi kusurkar
        ,NVL(lic.LIC_CATCHUP_FLAG,''N'') LIC_CATCHUP_FLAG
       -- END
       -- PB CR mrunmayi kusurkar 29-jul-2013
       ,(select com_internal from fid_company where com_number = FLV.CON_COM_NUMBER and com_type = ''S'')supp_categary
       -- end
       ,(SELECT MS_MEDIA_SERVICE_CODE FROM sgy_pb_media_service WHERE MS_MEDIA_SERVICE_FLAG = lic.LIC_CATCHUP_FLAG) lic_media_service
       --Added by sushma on 15-09-2015
       --Adde for UAT cr:0101014: identifier of MG on Lic Maint Search
       ,LIC_MIN_GUARANTEE_FLAG
       ,LIC_MIN_SUBS_FLAG
       --END 15-09-2015
       ,flv.lee_region_id
       FROM fid_license_vw flv,
     -- ** CP R1 mrunmayi kusurkar
         fid_license lic
       WHERE 1=1
       AND lic.lic_number = flv.lic_number';

      IF i_lictype IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(flv.lic_type) LIKE UPPER('
            || ''''
            || i_lictype
            || ''''
            || ')';
      END IF;

      IF i_licstatus IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(flv.lic_status) LIKE UPPER('
            || ''''
            || i_licstatus
            || ''''
            || ')';
      END IF;

      IF i_licmemnumber IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(flv.lic_mem_number) LIKE UPPER('
            || ''''
            || i_licmemnumber
            || ''''
            || ')';
      END IF;

      IF i_gentitle IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(flv.gen_title) LIKE UPPER('
            || ''''
            || i_gentitle
            || ''''
            || ')';
      END IF;

      IF i_licstart IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(TO_CHAR(flv.lic_start,'
            || ''''
            || 'DD-MON-RRRR'
            || ''''
            || ')) LIKE UPPER('
            || ''''
            || i_licstart
            || ''''
            || ')';
      END IF;

      IF i_licend IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(TO_CHAR(flv.lic_end,'
            || ''''
            || 'DD-MON-RRRR'
            || ''''
            || ')) LIKE UPPER('
            || ''''
            || i_licend
            || ''''
            || ')';
      END IF;

      IF i_leeshortname IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(flv.lee_short_name) LIKE UPPER('
            || ''''
            || i_leeshortname
            || ''''
            || ')';
      END IF;

      IF i_conshortname IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(flv.con_short_name) = UPPER('
            || ''''
            || i_conshortname
            || ''''
            || ')';
      END IF;

      IF i_licchsnumber IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(flv.lic_chs_number) = UPPER('
            || ''''
            || i_licchsnumber
            || ''''
            || ')';
      END IF;

      IF i_licnumber IS NOT NULL
      THEN
         stmt_str :=
               stmt_str
            || ' AND UPPER(flv.lic_number) LIKE UPPER('
            || ''''
            || i_licnumber
            || ''''
            || ')';
      END IF;

      IF i_supplier_category IS NOT NULL
      THEN
         stmt_str :=
            stmt_str
            || ' AND FLV.CON_COM_NUMBER IN (select com_number
                                    from fid_company
                                    where com_type = ''S''
                                    AND com_internal like UPPER('''
            || i_supplier_category
            || '''))';
      END IF;
   --Add Gen Ref column-Ashok Jagtap
    IF nvl(i_gen_ref_no,0) <> 0
      THEN
         stmt_str :=
               stmt_str
            || ' AND flv.gen_refno='
            || ''''
            || i_gen_ref_no
            || '''';
      END IF;
   --End
      IF     i_lictype IS NULL
         AND i_licstatus IS NULL
         AND i_licmemnumber IS NULL
         AND i_gentitle IS NULL
         AND i_licstart IS NULL
         AND i_licend IS NULL
         AND i_leeshortname IS NULL
         AND i_conshortname IS NULL
         AND i_licchsnumber IS NULL
         AND i_licnumber IS NULL
         AND i_supplier_category IS NULL
         and nvl(i_gen_ref_no,0) = 0
      THEN
         stmt_str :=
            stmt_str
            || ' AND rownum <= 10000  ORDER BY flv.gen_title, flv.lic_number';
      -- DBMS_OUTPUT.put_line (stmt_str);
      ELSE
         stmt_str :=
            stmt_str
            || ' AND rownum <= 15000  ORDER BY flv.gen_title, flv.lic_number';
      END IF;

     -- DBMS_OUTPUT.put_line (stmt_str);

      OPEN o_searchlicense FOR stmt_str;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_searchlicense;

   --****************************************************************
   -- This procedure searches License Details.
   -- This procedure input is License Number.
   --****************************************************************
   PROCEDURE prc_alic_cm_licensedetail (
      i_licnumber                  IN     fid_license.lic_number%TYPE,
      o_licensedetail                 OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      -- Project Bioscope : Ajit_20120314 : New Cursor for Media Service, Media Platform
      o_searchmediasermediaplat       OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_costed_prog_type              OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc, -- Project Bioscope : Ajit_20120314 : End
      -- Project 5_2 : Aditya Gupta_20140606 : New Cursor for 5_2 requirement for closed months costed runs per channel
      o_costed_closed_cha_lic         OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc, -- Project 5_2 : End
      -- CATCHUP : CACQ:14 for license rights detail load_{SHANTANU A.}
      O_lic_medplatmdevcompatmap      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_lic_med_dev_rights            OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_media_service                 OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
    --CATCHUP: END                                                                                              )
    --Dev.R1: CatchUp for All :[BR_15_272_UC_Super Stacking]_[Milan Shah]_[2015/12/29]: Start
      O_SUPERSTACK_RIGHTS              OUT SYS_REFCURSOR )
   --Dev.R1: CatchUp for All: End
   AS
      --ADD for CATCHUP: CACQ:14 [SHANTANU A.]_13-nov-2014
      l_lic_fea_ser         VARCHAR2 (10);
      l_md_id               NUMBER;
      l_con_count           NUMBER;
      l_con_number          NUMBER;
      l_lic_count           NUMBER;
      l_string              CLOB;
      l_string1             CLOB;
      l_string2             CLOB;
      l_string3             CLOB;
      l_string4             CLOB;
      l_string5             CLOB;
      --CATCHUP_[END]
      stmt_str              CLOB;
      v_go_live_date        DATE;
      l_lic_start_date      DATE;
      ratedetail            VARCHAR (1);
      l_open_month          DATE;
      l_catchup_live_date   DATE;
      l_on_plylist          VARCHAR2 (1) := 'N';
      l_plt_count           NUMBER;
      l_catchup_flag        VARCHAR2 (10);
   BEGIN
      DBMS_OUTPUT.ENABLE (1000000);

      -- ADD for CATCHUP: CACQ:14 [SHANTANU A.]_13-nov-2014
      SELECT lic_con_number,
             (SELECT MS_MEDIA_SERVICE_CODE
                FROM sgy_pb_media_service
               WHERE MS_MEDIA_SERVICE_flag = NVL (lic_catchup_flag, 'N'))
        INTO l_con_number, l_catchup_flag
        FROM fid_license
       WHERE lic_number = i_licnumber;

      SELECT COUNT (1)
        INTO l_lic_count
        FROM x_cp_lic_medplatmdevcompat_map
       WHERE LIC_MPDC_LIC_NUMBER = i_licnumber;

      SELECT COUNT (*)
        INTO l_con_count
        FROM x_cp_con_medplatmdevcompat_map
       WHERE CON_CONTRACT_NUMBER = l_con_number;

      SELECT lic_budget_code
        INTO l_lic_fea_ser
        FROM fid_license
       WHERE lic_number = i_licnumber;

      --CATCHUP_[END]
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      SELECT TO_DATE (content)
        INTO l_catchup_live_date
        FROM x_fin_configs
       WHERE KEY = 'CATCH-UP_LIVE_DATE';

      SELECT COUNT (*)
        INTO l_plt_count
        FROM x_cp_play_list
       WHERE     plt_lic_number = i_licnumber
             AND PLT_sch_START_date < TRUNC (l_catchup_live_date, 'MON')
             AND NOT EXISTS
                    (SELECT 1
                       FROM x_cp_lic_medplatmdevcompat_map
                      WHERE lic_mpdc_lic_number = plt_lic_number);

      IF l_plt_count > 0
      THEN
         l_on_plylist := 'Y';
      END IF;

      SELECT lic_start
        INTO l_lic_start_date
        FROM fid_license
       WHERE lic_number = i_licnumber;

      IF (l_lic_start_date < v_go_live_date)
      THEN
         ratedetail := 'Y';
      ELSE
         ratedetail := 'N';
      END IF;

      -- Project 5_2 : Aditya Gupta_20140606 : New Cursor for 5_2 requirement for closed months costed runs per channel
      SELECT TO_DATE (fim_year || fim_month, 'YYYYMM')
        INTO l_open_month
        FROM fid_financial_month, fid_licensee
       WHERE     fim_split_region = lee_split_region
             AND fim_status = 'O'
             AND lee_number = (SELECT lic_lee_number
                                 FROM fid_license
                                WHERE lic_number = i_licnumber);

      stmt_str :=
         'SELECT fl.lic_number, fg.gen_title, fg.gen_title_working,
                fc.con_short_name, fc.con_name, fle.lee_short_name,
                fle.lee_name, fl.lic_gen_refno, fl.lic_mem_number,
                fl.lic_status, fl.lic_start, fl.lic_end, fl.lic_acct_date,
                fl.lic_period_tba, fl.lic_type, fg.gen_type, fl.lic_currency,
                ROUND(fl.lic_rate,4) lic_rate, ROUND(fl.lic_price,4) lic_price,
        fl.lic_markup_percent,
                fl.lic_min_subscriber, fl.lic_min_guarantee, fl.lic_comment,
                fl.lic_play_status, fl.lic_showing_first, fl.lic_showing_last,
                fl.lic_showing_paid, fl.lic_showing_free, fl.lic_exclusive,
                fl.lic_chs_number, fl.lic_lee_number, fl.lic_con_number,
                fl.lic_entry_date, fl.lic_entry_oper, fl.lic_lic_number,
                fl.lic_external_ref, fl.lic_showing_int, fl.lic_max_chs,
                fl.lic_max_cha, fl.lic_showing_lic, fl.lic_amort_code,
                fl.lic_price_code, fl.lic_budget_code, fc.con_prime_max_runs,
                fc.con_prime_time_type, fc.con_prime_time_pd_limit,
                fc.con_prime_time_level, fc.con_prime_max_runs_perc,
                fc.con_prime_time_start, fc.con_prime_time_end,
                nvl(fl.lic_update_count,0) lic_update_count,'''
         || l_on_plylist
         || ''' l_on_plylist,

                fl.LIC_WRITEOFF lic_writeoff_mark,

                 --15_FIN_06_ENH_Cancel Season in one attempt_v1.0
         fg.gen_ser_number,
         --15_FIN_06_ENH_Cancel Season in one attempt_v1.0
                --- flag to identify live date and enable/disable rate detail --
                '''
         || ratedetail
         || ''' ratedetail,


                -- Project Bioscope : Ajit_20120314 : Premier flag, Exh days, Limit Per Day, channel, service added
                fl.lic_time_shift_cha_flag,
                fle.LEE_BIOSCOPE_FLAG,
 /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */

                fl.lic_simulcast_cha_flag,
  /* PB (CR 12) :END */

                fl.lic_premium_flag,
 -- Dev8: RDT :Start:[ACQCR2]_[Deepak]_[27-Aug-2013]
                --on hold flag
                fl.lic_on_hold_flag,
                ----DEV.RDT: PHOENIX REQUIREMENT: START:Phoenix_04_Marking_License_as_Feed_NEERAJ_2014/03/21]
                nvl(fl.lic_feed_flag,''N'') lic_feed_flag,
                ----DEV.RDT: PHOENIX REQUIREMENT: END------------------------
                fc.con_exhibition_per_day,
                fc.con_prime_time_pd_limit,
                fc.con_limit_per_service,
                fle.LEE_BIOSCOPE_FLAG,
                fc.con_limit_per_channel,
                 nvl(( select ''Y''
                  from     sgy_pb_costed_prog_type
                  where cpt_gen_type =  fl.lic_budget_code
                   ),''N'' ) costed_gen_type_flag,
                -- Project Bioscope : Ajit_20120314 : End
       NVL((SELECT chs_short_name FROM fid_channel_service WHERE chs_number = FL.lic_chs_number),
            (SELECT cha_short_name FROM fid_channel WHERE cha_number = FL.lic_chs_number)) "Short Name",
       NVL((SELECT chs_name FROM fid_channel_service WHERE chs_number = FL.lic_chs_number),
            (SELECT cha_name FROM fid_channel WHERE cha_number = FL.lic_chs_number)) "Name",
  -- ** CP R1 mrunmayi kusurkar
          NVL(fl.LIC_CATCHUP_FLAG,''N'')LIC_CATCHUP_FLAG
          ,fl.LIC_MAX_VIEWING_PERIOD
          ,NVL(fl.LIC_SCH_AFT_PREM_LINEAR,''N'')LIC_SCH_AFT_PREM_LINEAR
          ,NVL(fl.LIC_NON_CONS_MONTH,''N'')LIC_NON_CONS_MONTH
         /*,(  select     (    select count(distinct plt_sch_number)  from X_CP_PLAY_LIST  where PLT_LIC_NUMBER = aa.lic_number ) +
                       (  select count(sch_number)   from fid_schedule    where sch_lic_number = aa.lic_number )
               from fid_license aa
               where lic_number = fl.lic_number
             ) "No Of viewing periods used" */
         ,(  select     (select COUNT(distinct PLT_SCH_NUMBER)  from X_CP_PLAY_LIST  where PLT_LIC_NUMBER = AA.LIC_NUMBER ) +
                  DECODE(ab.lee_short_name,''CAFR'',(select COUNT(SCH_NUMBER)   from FID_SCHEDULE where SCH_LIC_NUMBER = AA.LIC_NUMBER)
                   ,DECODE((select COUNT(SCH_NUMBER)   from FID_SCHEDULE where SCH_LIC_NUMBER = AA.LIC_NUMBER),0
                  ,(select COUNT(SCH_NUMBER) from FID_SCHEDULE ,FID_LICENSE  where SCH_LIC_NUMBER = LIC_NUMBER and LIC_LEE_NUMBER = 319 and LIC_GEN_REFNO = AA.LIC_GEN_REFNO
                  and lic_con_number=AA.lic_con_number)
                  ,(select COUNT(SCH_NUMBER)   from FID_SCHEDULE where SCH_LIC_NUMBER = AA.LIC_NUMBER))
                  )
             from fid_license aa
              ,FID_LICENSEE AB
             where aa.LIC_LEE_NUMBER = ab.LEE_NUMBER
             and AA.LIC_NUMBER = FL.LIC_NUMBER
           ) "No Of viewing periods used"
             , fl.lic_update_count cp_update_cnt,
           fle.lee_region_id ,
  -- ** end
      (SELECT cod_description FROM fid_code WHERE cod_type='
         || ''''
         || 'LIC_PRICE_CODE'
         || ''''
         || ' AND cod_value <> '
         || ''''
         || 'HEADER'
         || ''''
         || ' AND UPPER(cod_value) = UPPER(FL.LIC_PRICE_CODE)) "Price Code Desc",
      (SELECT cod_description FROM fid_code WHERE cod_type='
         || ''''
         || 'LIC_TYPE'
         || ''''
         || '  AND cod_value <> '
         || ''''
         || 'HEADER'
         || ''''
         || '  AND UPPER(cod_value) = UPPER(FL.LIC_TYPE)) "Type Code Desc",
      (SELECT cod_description FROM fid_code WHERE cod_type='
         || ''''
         || 'LIC_STATUS'
         || ''''
         || '  AND cod_value <> '
         || ''''
         || 'HEADER'
         || ''''
         || '  AND UPPER(cod_value) = UPPER(FL.LIC_STATUS)) "Status Code Desc",
      (SELECT cod_description FROM fid_code WHERE cod_type='
         || ''''
         || 'LIC_PLAY_STATUS'
         || ''''
         || '  AND cod_value <> '
         || ''''
         || 'HEADER'
         || ''''
         || '  AND UPPER(cod_value) = UPPER(FL.LIC_PLAY_STATUS)) "Play Status Code Desc",
          DECODE (fc.con_prime_time_level ,'
         || ''''
         || 'SRVCE'
         || ''''
         || ',fid_primetime_pk.cnt_pt_runs('
         || i_licnumber
         || ', to_date('
         || ''''
         || '31-DEC-2199'
         || ''''
         || ','
         || ''''
         || 'DD-MON-YYYY'
         || ''''
         || '), 0),NULL) "PT runs for sevice"
         /*Project Start - AfricaFreeRuns: Nishant Ankam */
         ,LIC_FREE_RPT
         ,LIC_RPT_PERIOD
         /*Project End - AfricaFreeRuns: Nishant Ankam */
         -- Added new column for PB CR Mrunmayi -------
         ,fg.GEN_BO_CATEGORY_CODE
         -- end
         ,(SELECT  COD_DESCRIPTION
         FROM FID_COMPANY ,FID_CODE
         WHERE COM_NUMBER = CON_COM_NUMBER
         AND COD_TYPE = ''COM_INTERNAL'' AND COD_VALUE != ''HEADER''
         and cod_value = com_internal
         and com_type = ''S'')supp_categary
         ,X_FUN_GET_SEASON_TITLE(fg.gen_ser_number) SEASON_TITLE
         --15_FIN_06_ENH_Cancel Season in one attempt_v1.0
         ,fg.gen_ser_number
         --15_FIN_06_ENH_Cancel Season in one attempt_v1.0
         ,X_FNC_GET_PROG_TYPE(FG.GEN_TYPE)IS_SERIES_FLAG
         ,(select com_name from fid_Company where com_number = con_com_number )SUPPLIER
         ,NVL(pkg_alic_cm_licensemaintenance.x_fnc_get_lic_paidamt(fl.lic_number),0) PAID_AMOUNT
         ,PKG_ALIC_CM_LICENSEMAINTENANCE.x_fun_is_primary(fl.lic_number)is_secondary_flag
         -- CATCHUP:CACQ14: Start_[SHANTANU A.]_20-nov-2014
         -- Add three columns of the contract of respective catchup license for validations
         ,lic_is_dstv_right --- Added By RAshmi For DSTV Aquisition 14-101-2015
         ,NVL(fl.LIC_SCH_WITHOUT_LIN_REF,''N'') "LIC_SCH_WITHOUT_LIN_REF"
         ,NVL(fl.LIC_SCH_BEF_X_DAY,''N'') "LIC_SCH_BEF_X_DAY"
         ,fl.LIC_SCH_BEF_X_DAY_VALUE "LIC_SCH_BEF_X_DAY_VALUE"
         ,DECODE('''
         || X_FNC_GET_PROG_TYPE (l_lic_fea_ser)
         || ''',''Y'',(select NVL(CON_SCH_AFTER_PREM_LINR_SER,''N'') from fid_contract where con_number = '''
         || l_con_number
         || ''')
                                      ,(SELECT NVL(CON_SCH_AFTER_PREM_LINR_FEA,''N'') from fid_contract where con_number = '''
         || l_con_number
         || ''')) "CON_SCH_AFTER_PREM_LINR"
         ,DECODE('''
         || X_FNC_GET_PROG_TYPE (l_lic_fea_ser)
         || ''',''Y'',(select NVL(CON_SCH_X_DAY_BEFORE_LINR_SER,''N'') from fid_contract where con_number = '''
         || l_con_number
         || ''')
                                      ,(SELECT NVL(CON_SCH_X_DAY_BEFORE_LINR_FEA,''N'') from fid_contract where con_number = '''
         || l_con_number
         || ''')) "CON_SCH_X_DAY_BEFORE_LINR"
         ,DECODE('''
         || X_FNC_GET_PROG_TYPE (l_lic_fea_ser)
         || ''',''Y'',(select NVL(CON_SCH_X_DAY_BEF_LINR_VAL_SER,0) from fid_contract where con_number = '''
         || l_con_number
         || ''')
                                      ,(SELECT NVL(CON_SCH_X_DAY_BEF_LINR_VAL_FEA,0) from fid_contract where con_number = '''
         || l_con_number
         || ''')) "CON_SCH_X_DAY_BEF_LINR_VAL"
         ,DECODE('''
         || X_FNC_GET_PROG_TYPE (l_lic_fea_ser)
         || ''',''Y'',(select NVL(CON_SCH_WITHOUT_LINR_REF_SER,''N'') from fid_contract where con_number = '''
         || l_con_number
         || ''')
                                      ,(SELECT NVL(CON_SCH_WITHOUT_LINR_REF_FEA,''N'') from fid_contract where con_number = '''
         || l_con_number
         || ''')) "CON_SCH_WITHOUT_LINR_REF",

        --CATCHUP:CACQ14: [END]
        --Warner Payments :Rashmi Tijare :09-07-15
        fl.LIC_MIN_GUARANTEE_FLAG,
        fl.LIC_MIN_SUBS_FLAG,
        --Changed by sushma on 15-09-2015 to solve UAT issue
        (case when  fl.LIC_MIN_GUARANTEE_FLAG = ''N'' THEN 0 else fc.CON_MIN_SUBSCRIBER END) CON_MIN_SUBSCRIBER,
        --END
        ROUND( (case when  fl.LIC_MIN_GUARANTEE_FLAG = ''N'' THEN 0 else fc.CON_MIN_SUBSCRIBER END) * fl.lic_price,2) "Min_Gurantee",
        --Warner End
        --Finance Dev Phase I Zeshan [Start]
        '''|| l_open_month ||''' OPEN_MONTH
        --Finance Dev Phase I [End]
    FROM fid_license fl,
                fid_general fg,
                fid_contract fc,
                fid_licensee fle
          WHERE fl.lic_gen_refno = fg.gen_refno
            AND fl.lic_con_number = fc.con_number
            AND fl.lic_lee_number = fle.lee_number
            AND fl.lic_number = '
         || i_licnumber;

      ---DBMS_OUTPUT.put_line (stmt_str);

      OPEN o_licensedetail FOR stmt_str;

      --CATCHUP:CACQ:14- Start_[SHANTANU A.]_13-nov-2014
      IF l_con_count = 0
      THEN
         l_string :=
            'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            0 LIC_MPDC_LIC_NUMBER,
                            '''
            || l_catchup_flag
            || ''' LIC_MPDC_SERVICE_CODE,
                            0 NO_of_VP_used,
                            a.med_device_sch_flag,';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_UI_SEQ)
         LOOP
            l_string := l_string || '''N''' || i.MDC_CODE || '_MEDIA_RIGHTS,';
         END LOOP;

         dbms_lob.append(
            l_string
            , 'a.MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT"  from (select
                                           MDP_MAP_DEV_ID,
                                           (SELECT MD_CODE from x_cp_media_device WHERE MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            '' '' RIGHTS_ON_DEVICE
                                            ,MPDC_DEV_PLATM_ID
                                            ,0 MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,'''
            || l_catchup_flag
            || ''' CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,''N'' med_device_sch_flag
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                                and MPDCS_MED_SERVICE_CODE = '''
            || l_catchup_flag
            || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID order by MDP_MAP_DEV_ID
                                                 )a');
      ELSE
         IF (X_FNC_GET_PROG_TYPE (l_lic_fea_ser)) = 'Y'
         THEN
            l_string :=
               'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.CON_RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.CON_MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            a.CON_CONTRACT_NUMBER "LIC_MPDC_LIC_NUMBER",
                            a.CON_MPDC_SERVICE_CODE "LIC_MPDC_SERVICE_CODE",
                            0 NO_of_VP_used,
                            a.med_device_sch_flag,';

            FOR i
               IN (SELECT DISTINCT MDC_ID, MDC_CODE
                     FROM x_cp_media_device_compat)
            LOOP
               l_string :=
                     l_string
                  || 'NVL( ( select  (case when CON_MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''
            and CON_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_con_medplatmdevcompat_map b
            ,x_cp_media_dev_platm_map  where CON_MPDC_DEV_PLATM_ID = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID
            and MDP_MAP_PLATM_CODE = a.med_platm_code and b.CON_MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''
            and CON_IS_FEA_SER = ''SER'' and CON_CONTRACT_NUMBER = '''
                  || l_con_number
                  || '''),''N'')
            '
                  || i.MDC_CODE
                  || '_MEDIA_RIGHTS,';
            END LOOP;

            l_string :=
               l_string
               || 'a.CON_MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT"  from (select
                                           MDP_MAP_DEV_ID,
                                           (SELECT MD_CODE FROM x_cp_media_device WHERE MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                             CON_RIGHTS_ON_DEVICE
                                            ,CON_MPDC_DEV_PLATM_ID
                                            ,0 CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,
                                            (case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              /* start nasreen*/
                                                               --and   lic_catchup_flag in ( ''Y'',''S'')
                                                              and NVL (lee_media_service_code, ''LINEAR'') in( select MS_MEDIA_SERVICE_CODE from
                                                              sgy_pb_media_service
                                                              where MS_MEDIA_SERVICE_CODE
                                                              not in (''PAYTV'',''TVOD''))
                                                              /*end nasreen*/
                                                              and lic_con_number = '''
               || l_con_number
               || '''
                                                              )
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''), ''mm'') IN
                                                                         (SELECT FIM_MONTH
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''),''yyyy'') IN
                                                                         (SELECT FIM_YEAR
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID) > 0 THEN  ''Y''  else ''N'' END ) med_device_sch_flag
                                          from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = '''
               || l_con_number
               || '''
                                          and CON_IS_FEA_SER = ''SER''
                                           group by MDP_MAP_DEV_ID,
                                                 MDP_MAP_PLATM_CODE,CON_RIGHTS_ON_DEVICE,CON_MPDC_DEV_PLATM_ID,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE
                                                order by MDP_MAP_DEV_ID)a';

            --changes for issue#:89357-start-17/12/2014-SHANTANU A.
            --19/03/15 for SVOD added 'S'
            FOR contract
               IN (SELECT md_id FROM x_cp_media_device
                   MINUS
                   SELECT DISTINCT mdp_map_dev_id
                     FROM x_cp_con_medplatmdevcompat_map,
                          x_cp_media_dev_platm_map
                    WHERE     CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                          AND CON_CONTRACT_NUMBER = l_con_number
                          AND CON_IS_FEA_SER = 'SER')
            LOOP
               l_string1 :=
                  l_string1
                  || ' UNION select a.Med_dev_code,
                              a.Med_dev_desc,
                              a.med_platm_code,
                              a.med_platm_desc,
                              a.RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                              a.MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                              0 LIC_MPDC_LIC_NUMBER,
                              '''
                  || l_catchup_flag
                  || ''' LIC_MPDC_SERVICE_CODE,
                              0 NO_of_VP_used,
                              a.med_device_sch_flag,';

               FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                             FROM x_cp_media_device_compat
                         ORDER BY MDC_UI_SEQ)
               LOOP
                  l_string1 :=
                     l_string1 || '''N''' || i.MDC_CODE || '_MEDIA_RIGHTS,';
               END LOOP;

              dbms_lob.append(
                  l_string1
                  , 'a.MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT"  from (select
                                             MDP_MAP_DEV_ID,
                                             (SELECT MD_CODE from x_cp_media_device WHERE MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                             (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                              MDP_MAP_PLATM_CODE med_platm_code,
                                              (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                              ''N'' RIGHTS_ON_DEVICE
                                              ,MPDC_DEV_PLATM_ID
                                              ,0 MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,'''
                  || l_catchup_flag
                  || ''' CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,''N'' med_device_sch_flag
                                            from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                  where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                   and   MPDCS_MPDC_ID  =  MPDC_ID
                                                  and MPDCS_MED_SERVICE_CODE = '''
                  || l_catchup_flag
                  || '''
                                                  and MDP_MAP_DEV_ID = '''
                  || contract.md_id
                  || ''' --change for issue: 89357
                                             group by MDP_MAP_DEV_ID,
                                                      MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                   order by MDP_MAP_DEV_ID)a');
            END LOOP;
         ELSE
            l_string :=
               'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.CON_RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.CON_MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            a.CON_CONTRACT_NUMBER "LIC_MPDC_LIC_NUMBER",
                            a.CON_MPDC_SERVICE_CODE "LIC_MPDC_SERVICE_CODE",
                            0 NO_of_VP_used,
                            a.med_device_sch_flag,';

            FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                          FROM x_cp_media_device_compat
                      ORDER BY MDC_UI_SEQ)
            LOOP
               l_string :=
                     l_string
                  || 'NVL( ( select  (case when CON_MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''
            and CON_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_con_medplatmdevcompat_map b
            ,x_cp_media_dev_platm_map  where CON_MPDC_DEV_PLATM_ID = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID
            and MDP_MAP_PLATM_CODE = a.med_platm_code and b.CON_MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''
            and CON_IS_FEA_SER <> ''SER'' and CON_CONTRACT_NUMBER = '''
                  || l_con_number
                  || '''),''N'')
            '
                  || i.MDC_CODE
                  || '_MEDIA_RIGHTS,';
            END LOOP;

            l_string :=
               l_string
               || 'a.CON_MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT" from (select
                                           MDP_MAP_DEV_ID,
                                           (SELECT MD_CODE FROM x_cp_media_device WHERE MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            CON_RIGHTS_ON_DEVICE
                                            ,CON_MPDC_DEV_PLATM_ID
                                            ,0 CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,
                                            (case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              /* start nasreen*/
                                                               --and   lic_catchup_flag in ( ''Y'',''S'')
                                                              and NVL (lee_media_service_code, ''LINEAR'') in( select MS_MEDIA_SERVICE_CODE from
                                                              sgy_pb_media_service
                                                              where MS_MEDIA_SERVICE_CODE
                                                              not in (''PAYTV'',''TVOD''))
                                                              /*end nasreen*/
                                                              and lic_con_number = '''
               || l_con_number
               || '''
                                                              )
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''), ''mm'') IN
                                                                         (SELECT FIM_MONTH
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''),''yyyy'') IN
                                                                         (SELECT FIM_YEAR
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID) > 0 THEN  ''Y''  else ''N'' END ) med_device_sch_flag
                                          from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = '''
               || l_con_number
               || '''
                                          and CON_IS_FEA_SER <> ''SER''
                                           group by MDP_MAP_DEV_ID,
                                                 MDP_MAP_PLATM_CODE,CON_RIGHTS_ON_DEVICE,CON_MPDC_DEV_PLATM_ID,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE
                                                order by MDP_MAP_DEV_ID)a';

            --changes for issue#:89357-start-17/12/2014-SHANTANU A.
            --19/03/15 for SVOD added 'S'
            FOR contract
               IN (SELECT md_id FROM x_cp_media_device
                   MINUS
                   SELECT DISTINCT mdp_map_dev_id
                     FROM x_cp_con_medplatmdevcompat_map,
                          x_cp_media_dev_platm_map
                    WHERE     CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                          AND CON_CONTRACT_NUMBER = l_con_number
                          AND CON_IS_FEA_SER <> 'SER')
            LOOP
               l_string1 :=
                  l_string1
                  || ' UNION select a.Med_dev_code,
                                a.Med_dev_desc,
                                a.med_platm_code,
                                a.med_platm_desc,
                                a.RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                                a.MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                                0 LIC_MPDC_LIC_NUMBER,
                                '''
                  || l_catchup_flag
                  || ''' LIC_MPDC_SERVICE_CODE,
                                0 NO_of_VP_used,
                                a.med_device_sch_flag,';

               FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                             FROM x_cp_media_device_compat
                         ORDER BY MDC_UI_SEQ)
               LOOP
                  l_string1 :=
                     l_string1 || '''N''' || i.MDC_CODE || '_MEDIA_RIGHTS,';
               END LOOP;

               dbms_lob.append(
                  l_string1
                  , 'a.MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT"  from (select
                                               MDP_MAP_DEV_ID,
                                               (SELECT MD_CODE from x_cp_media_device WHERE MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                               (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                                MDP_MAP_PLATM_CODE med_platm_code,
                                                (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                                ''N'' RIGHTS_ON_DEVICE
                                                ,MPDC_DEV_PLATM_ID
                                                ,0 MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,'''
                  || l_catchup_flag
                  || ''' CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,''N'' med_device_sch_flag
                                              from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                    where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                     and   MPDCS_MPDC_ID  =  MPDC_ID
                                                    and MPDCS_MED_SERVICE_CODE = '''
                  || l_catchup_flag
                  || '''
                                                    and MDP_MAP_DEV_ID = '''
                  || contract.md_id
                  || ''' --changes for issue#:89357
                                               group by MDP_MAP_DEV_ID,
                                                        MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID order by MDP_MAP_DEV_ID
                                                     )a');
            END LOOP;
         END IF;
      END IF;

      /*IF l_lic_count = 0
      THEN
          IF (X_FNC_GET_PROG_TYPE(l_lic_fea_ser)) = 'Y'
          THEN
            l_string3 :=
               'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.CON_RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.CON_MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            a.CON_CONTRACT_NUMBER "LIC_MPDC_LIC_NUMBER",
                            a.CON_MPDC_SERVICE_CODE "ServiceCode" ,--"LIC_MPDC_SERVICE_CODE",
                            0 NoOfVPUsed ,--NO_of_VP_used,
                            a.med_device_sch_flag,';

            FOR i
               IN (SELECT DISTINCT MDC_ID, MDC_CODE
                     FROM x_cp_media_device_compat ORDER BY MDC_ID)
            LOOP
               l_string3 :=
                     l_string3
                  || 'NVL( ( select  (case when CON_MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''
            and CON_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_con_medplatmdevcompat_map b
            ,x_cp_media_dev_platm_map  where CON_MPDC_DEV_PLATM_ID = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID
            and MDP_MAP_PLATM_CODE = a.med_platm_code and b.CON_MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''
            and CON_IS_FEA_SER = ''SER'' and CON_CONTRACT_NUMBER = '''
                  || l_con_number
                  || '''),''N'')
            '
                  || i.MDC_CODE
                || '_Dynamic_'
                || i.MDC_ID
                || ' ,';
            END LOOP;

            l_string3 :=
               l_string3
               || 'a.CON_MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT"  from (select
                                           MDP_MAP_DEV_ID,
                                           (SELECT MD_CODE FROM x_cp_media_device WHERE MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                             CON_RIGHTS_ON_DEVICE
                                            ,CON_MPDC_DEV_PLATM_ID
                                            ,0 CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,
                                            (case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              and   lic_catchup_flag in ( ''Y'',''S'')
                                                              and lic_con_number = '''||l_con_number||'''
                                                              )
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''), ''mm'') IN
                                                                         (SELECT FIM_MONTH
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''),''yyyy'') IN
                                                                         (SELECT FIM_YEAR
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID) > 0 THEN  ''Y''  else ''N'' END ) med_device_sch_flag
                                          from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = '''
               || l_con_number
               || '''
                                          and CON_IS_FEA_SER = ''SER''
                                           group by MDP_MAP_DEV_ID,
                                                 MDP_MAP_PLATM_CODE,CON_RIGHTS_ON_DEVICE,CON_MPDC_DEV_PLATM_ID,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE
                                                 order by MDP_MAP_DEV_ID)a';
            --changes for issue#:89357-start-17/12/2014-SHANTANU A.
            --19/03/15 for SVOD added 'S'
            FOR contract IN (SELECT DISTINCT md_id FROM x_cp_media_device MINUS
            SELECT DISTINCT mdp_map_dev_id FROM  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          WHERE CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          AND CON_CONTRACT_NUMBER  = l_con_number
                                          AND CON_IS_FEA_SER = 'SER')
            LOOP
            l_string4 := l_string4||
               ' UNION select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            0 LIC_MPDC_LIC_NUMBER,
                            '''||l_catchup_flag||''' "ServiceCode", --LIC_MPDC_SERVICE_CODE,
                            0 NoOfVPUsed,--NO_of_VP_used,
                            a.med_device_sch_flag,';

             FOR i
             IN (SELECT DISTINCT MDC_ID, MDC_CODE
                  FROM x_cp_media_device_compat ORDER BY MDC_ID)
             LOOP
             l_string4 :=
               l_string4 || '''N'''
                || i.MDC_CODE
                || '_Dynamic_'
                || i.MDC_ID
                || ' ,';
             END LOOP;

             l_string4 :=
              l_string4
              || 'a.MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT"  from (select
                                           MDP_MAP_DEV_ID,
                                           (SELECT MD_CODE from x_cp_media_device WHERE MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            ''N'' RIGHTS_ON_DEVICE
                                            ,MPDC_DEV_PLATM_ID
                                            ,0 MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,'''||l_catchup_flag||''' CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,''N'' med_device_sch_flag
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                                and MPDCS_MED_SERVICE_CODE = '''||l_catchup_flag||'''
                                                and MDP_MAP_DEV_ID = '''||contract.md_id||''' --changes for issue#:89357
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID order by MDP_MAP_DEV_ID
                                                 )a';
          END LOOP;
         ELSE
            l_string3 :=
               'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.CON_RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.CON_MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            a.CON_CONTRACT_NUMBER "LIC_MPDC_LIC_NUMBER",
                            a.CON_MPDC_SERVICE_CODE "ServiceCode",--"LIC_MPDC_SERVICE_CODE",
                            0 NoOfVPUsed,--NO_of_VP_used,
                            a.med_device_sch_flag,';

             FOR i
               IN (SELECT DISTINCT MDC_ID, MDC_CODE
                     FROM x_cp_media_device_compat ORDER BY MDC_ID)
             LOOP
               l_string3 :=
                     l_string3
                  || 'NVL( ( select  (case when CON_MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''
            and CON_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_con_medplatmdevcompat_map b
            ,x_cp_media_dev_platm_map  where CON_MPDC_DEV_PLATM_ID = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID
            and MDP_MAP_PLATM_CODE = a.med_platm_code and b.CON_MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''
            and CON_IS_FEA_SER <> ''SER'' and CON_CONTRACT_NUMBER = '''
                  || l_con_number
                  || '''),''N'')
            '
                  || i.MDC_CODE
                || '_Dynamic_'
                || i.MDC_ID
                || ' ,';
            END LOOP;

            l_string3 :=
               l_string3
               || 'a.CON_MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT" from (select
                                           MDP_MAP_DEV_ID,
                                           (SELECT MD_CODE FROM x_cp_media_device WHERE MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            CON_RIGHTS_ON_DEVICE
                                            ,CON_MPDC_DEV_PLATM_ID
                                            ,0 CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE,0 NoOfVPUsed,--NO_of_VP_used,
                                            (case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              and   lic_catchup_flag in ( ''Y'',''S'')
                                                              and lic_con_number = '''||l_con_number||'''
                                                              )
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''), ''mm'') IN
                                                                         (SELECT FIM_MONTH
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''),''yyyy'') IN
                                                                         (SELECT FIM_YEAR
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID) > 0 THEN  ''Y''  else ''N'' END ) med_device_sch_flag
                                          from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = '''
               || l_con_number
               || '''
                                          and CON_IS_FEA_SER <> ''SER''
                                           group by MDP_MAP_DEV_ID,
                                                 MDP_MAP_PLATM_CODE,CON_RIGHTS_ON_DEVICE,CON_MPDC_DEV_PLATM_ID,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE
                                                order by MDP_MAP_DEV_ID)a';
            --changes for issue#:89357-start-17/12/2014-SHANTANU A.
            --19/03/15 for SVOD added 'S'
             FOR contract IN (select distinct md_id from x_cp_media_device MINUS
             select distinct mdp_map_dev_id from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = l_con_number
                                          and CON_IS_FEA_SER <> 'SER')
             LOOP
             l_string4 := l_string4||
               ' UNION select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            0 LIC_MPDC_LIC_NUMBER,
                            '''||l_catchup_flag||''' LIC_MPDC_SERVICE_CODE,
                            0 NoOfVPUsed,--NO_of_VP_used,
                            a.med_device_sch_flag,';

             FOR i
              IN (SELECT DISTINCT MDC_ID, MDC_CODE
                  FROM x_cp_media_device_compat ORDER BY MDC_ID)
             LOOP
              l_string4 :=
               l_string4 || '''N'''
                || i.MDC_CODE
                || '_Dynamic_'
                || i.MDC_ID
                || ' ,';
           END LOOP;

           l_string4 :=
             l_string4
              || 'a.MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT"  from (select
                                           MDP_MAP_DEV_ID,
                                           (SELECT MD_CODE from x_cp_media_device WHERE MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            ''N'' RIGHTS_ON_DEVICE
                                            ,MPDC_DEV_PLATM_ID
                                            ,0 MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,'''||l_catchup_flag||''' CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,''N'' med_device_sch_flag
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                                and MPDCS_MED_SERVICE_CODE = '''||l_catchup_flag||'''
                                                and MDP_MAP_DEV_ID = '''||contract.md_id||''' --changes for issue#:89357
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID order by MDP_MAP_DEV_ID
                                                 )a';
            END LOOP;
          END IF;
     -- ELSE*/
      l_string3 :=
         'select a.Med_dev_code,
                                a.Med_dev_desc,
                                a.med_platm_code,
                                a.med_platm_desc,
                                a.LIC_RIGHTS_ON_DEVICE,
                                a.LIC_MPDC_DEV_PLATM_ID,
                                a.LIC_MPDC_LIC_NUMBER,
                                a.LIC_MPDC_SERVICE_CODE "ServiceCode",
                                a.NO_of_VP_used NoOfVPUsed,
                                a.med_device_sch_flag,';

      FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                    FROM x_cp_media_device_compat
                ORDER BY MDC_UI_SEQ)
      LOOP
         l_string3 :=
               l_string3
            || 'NVL( ( select  (case when LIC_MPDC_COMP_RIGHTS_ID = '''
            || i.MDC_ID
            || '''
                and LIC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_lic_medplatmdevcompat_map b,
                x_cp_media_dev_platm_map  where LIC_MPDC_DEV_PLATM_ID = MDP_MAP_ID
                and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code
                  /*and  b.LIC_MPDC_COMP_RIGHTS_ID=a.LIC_MPDC_COMP_RIGHTS_ID*/
                and b.LIC_MPDC_COMP_RIGHTS_ID = '''
            || i.MDC_ID
            || '''
                and LIC_MPDC_LIC_NUMBER = '''
            || i_licnumber
            || '''),''N'')   '
            || i.MDC_CODE
            || '_Dynamic_'
            || i.MDC_ID
            || ' ,';
      END LOOP;

      dbms_lob.append(
         l_string3
         , 'a.LIC_MPDC_UPDATE_COUNT  from (select
                                               MDP_MAP_DEV_ID,
                                               (SELECT MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                               (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                                MDP_MAP_PLATM_CODE med_platm_code,
                                                (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                                LIC_RIGHTS_ON_DEVICE
                                                ,LIC_MPDC_DEV_PLATM_ID
                                                --,lic_mpdc_comp_rights_id
                                                ,0 LIC_MPDC_UPDATE_COUNT,LIC_MPDC_LIC_NUMBER,LIC_MPDC_SERVICE_CODE,
                                                (select count(1) from x_cp_play_list
                                                where plt_lic_number = '''
         || i_licnumber
         || '''
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID)NO_of_VP_used ,
                                                (case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              /* start nasreen*/
                                                               --and   lic_catchup_flag in ( ''Y'',''S'')
                                                              and NVL (lee_media_service_code, ''LINEAR'') in( select MS_MEDIA_SERVICE_CODE from
                                                              sgy_pb_media_service
                                                              where MS_MEDIA_SERVICE_CODE
                                                              not in (''PAYTV'',''TVOD''))
                                                              /*end nasreen*/
                                                              and   lic_number = '''
         || i_licnumber
         || '''
                                                              )
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''), ''mm'') IN
                                                                         (SELECT FIM_MONTH
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                  AND TO_CHAR (TO_DATE (plt_sch_start_date, ''dd-mon-yy''),''yyyy'') IN
                                                                         (SELECT FIM_YEAR
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID) > 0 THEN  ''Y''  else ''N'' END ) med_device_sch_flag
                                              from  x_cp_lic_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                              where LIC_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                              and LIC_MPDC_LIC_NUMBER  = '''
         || i_licnumber
         || '''
                                               group by MDP_MAP_DEV_ID,
                                                        MDP_MAP_PLATM_CODE,LIC_RIGHTS_ON_DEVICE/*,lic_mpdc_comp_rights_id*/,LIC_MPDC_DEV_PLATM_ID,LIC_MPDC_LIC_NUMBER,LIC_MPDC_SERVICE_CODE
                                                     order by MDP_MAP_DEV_ID)a');

      --changes for issue#:89357-start-17/12/2014-SHANTANU A.
      --19/03/15 for SVOD added 'S'
      FOR j
         IN (SELECT md_id FROM x_cp_media_device
             MINUS
             SELECT DISTINCT mdp_map_dev_id
               FROM x_cp_lic_medplatmdevcompat_map, x_cp_media_dev_platm_map
              WHERE LIC_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                    AND LIC_MPDC_LIC_NUMBER = i_licnumber)
      LOOP
         --change for issue#:89357
         l_string4 :=
               l_string4
            || ' UNION select a.Med_dev_code,
                                a.Med_dev_desc,
                                a.med_platm_code,
                                a.med_platm_desc,
                                a.RIGHTS_ON_DEVICE,
                                a.MPDC_DEV_PLATM_ID,
                                0 LIC_MPDC_LIC_NUMBER,
                                '''
            || l_catchup_flag
            || ''' "ServiceCode",--LIC_MPDC_SERVICE_CODE,
                                0 NoOfVPUsed,''N'' med_device_sch_flag,';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_UI_SEQ)
         LOOP
           dbms_lob.append(
            l_string4, '''N'''
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,');
         END LOOP;

          dbms_lob.append(
            l_string4
            , 'a.MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT"
                                          from (select
                                               MDP_MAP_DEV_ID,
                                               (SELECT MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                               (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                                MDP_MAP_PLATM_CODE med_platm_code,
                                                (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                                ''N'' RIGHTS_ON_DEVICE
                                                ,MPDC_DEV_PLATM_ID
                                                ,0 MPDC_UPDATE_COUNT,0 LIC_MPDC_LIC_NUMBER,'''
            || l_catchup_flag
            || ''' LIC_MPDC_SERVICE_CODE,0 NO_of_VP_used ,''N'' med_device_sch_flag
                                              from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                    where MPDC_DEV_PLATM_ID =  MDP_MAP_ID
                                                     and   MPDCS_MPDC_ID    =  MPDC_ID
                                                    and MPDCS_MED_SERVICE_CODE = '''
            || l_catchup_flag
            || '''
                                                    and MDP_MAP_DEV_ID = '''
            || j.md_id
            || ''' --changes for issue#:89357
                                               group by MDP_MAP_DEV_ID,
                                               MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID order by MDP_MAP_DEV_ID
                                             )a');
      END LOOP;

      -- END IF;


      /*l_string3 := 'select a.Med_dev_code,
                              a.Med_dev_desc,
                              a.med_platm_code,
                              a.med_platm_desc,
                              a.Rights_On_device,
                              a.MPDC_DEV_PLATM_ID,
                              a.med_device_sch_flag,';

           for i  in (select distinct MDC_CODE from  x_cp_media_device_compat )
            LOOP
              l_string3 := l_string3 || 'NVL( ( select  (case when MPDC_COMP_RIGHTS = ''' || i. MDC_CODE || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_CODE = a.Med_dev_code and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS = ''' || i. MDC_CODE || '''  ),''N'')   ' || i. MDC_CODE || '_Media_Rights ,' ;
            END LOOP;

               l_string3 := l_string3 || 'a.MPDC_UPDATE_COUNT from (select
                                           MDP_MAP_DEV_CODE Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_CODE = MDP_MAP_DEV_CODE ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                             ''N'' Rights_On_device,
                                             MPDC_UPDATE_COUNT,
                                             MPDC_DEV_PLATM_ID,
                                             ''N''  med_device_sch_flag
                                          from  x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map,x_cp_medplatdevcomp_servc_map
                                          where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                          and   MPDCS_MPDC_ID  =  MPDC_ID
                                          and MPDCS_MED_SERVICE_CODE = ''CATCHUP''
                                           group by MDP_MAP_DEV_CODE,
                                                --  MD_DESC,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID,MPDC_UPDATE_COUNT
                                                 -- MP_MEDIA_PLATFORM_DESC
                                                 )a';*/

      l_string2 := l_string || ' ' || l_string1;
      --   DBMS_OUTPUT.PUT_LINE (l_string2);
      l_string5 := l_string3 || ' ' || l_string4;

      --DBMS_OUTPUT.PUT_LINE (l_string2);                        --Month End issue Commented as giving numeric or value error .Jawahar:[06-Mar-15]
      --DBMS_OUTPUT.PUT_LINE ('l_string5' || l_string5);
      --DBMS_OUTPUT.PUT_LINE (l_string2);                        --Month End issue Commented as giving numeric or value error .Jawahar:[06-Mar-15]

      OPEN O_lic_medplatmdevcompatmap FOR l_string2;


      OPEN o_lic_med_dev_rights FOR l_string5;

      --CATCHUP_[END]
      --commented by: [SHANTANU A.] for CACQ:14
      -- Project Bioscope : Ajit_20120314 : New Cursor for Media Service, Media Platform
      /* OPEN o_searchmediasermediaplat FOR
          SELECT lmps_mapp_id lmps_id, lmps_lic_number, mpsm_mapp_service_code,
                 mpsm_mapp_platform_code, 'Y' check_flag
                 -- CatchUp R1 : mrunmayi kusurkar
                 ,(SELECT COUNT (1)
                    FROM x_cp_play_list
                   WHERE plt_lic_number = i_licnumber
                     AND plt_plat_code = mpsm_mapp_platform_code
                     ) no_of_vp_used
            -- end
          FROM   sgy_pb_lic_med_plat_service, sgy_pb_med_platm_service_map
           WHERE mpsm_mapp_id = lmps_mapp_id AND lmps_lic_number = i_licnumber;
     */
      OPEN o_costed_prog_type FOR
         SELECT cpt_gen_type FROM sgy_pb_costed_prog_type;

      OPEN o_searchmediasermediaplat FOR
         SELECT lmps_mapp_id lmps_id,
                lmps_lic_number,
                mpsm_mapp_service_code,
                mpsm_mapp_platform_code,
                'Y' check_flag               -- CatchUp R1 : mrunmayi kusurkar
                              ,
                (SELECT COUNT (1)
                   FROM x_cp_play_list
                  WHERE plt_lic_number = i_licnumber
                        AND plt_plat_code = mpsm_mapp_platform_code)
                + DECODE (
                     ab.lee_short_name,
                     'CAFR', (SELECT COUNT (sch_number)
                                FROM fid_schedule
                               WHERE sch_lic_number = aa.lic_number),
                     DECODE (
                        mpsm_mapp_platform_code,
                        'PVR', (SELECT COUNT (sch_number)
                                  FROM fid_schedule
                                 WHERE sch_lic_number = aa.lic_number),
                        (SELECT COUNT (sch_number)
                           FROM fid_schedule, fid_license
                          WHERE     sch_lic_number = lic_number
                                AND lic_lee_number = 319
                                AND lic_gen_refno = aa.lic_gen_refno
                                AND lic_con_number = aa.lic_con_number)))
                   no_of_vp_used
           -- end
           FROM sgy_pb_lic_med_plat_service,
                sgy_pb_med_platm_service_map,
                fid_license aa,
                fid_licensee ab
          WHERE     mpsm_mapp_id = lmps_mapp_id
                AND aa.lic_number = lmps_lic_number
                AND aa.lic_lee_number = ab.lee_number
                AND lmps_lic_number = i_licnumber;

      -- Project Bioscope : Ajit_20120314 : End

      OPEN o_costed_closed_cha_lic FOR
           SELECT cha_short_name "Channel", COUNT (*) "Closed_Months_Costed"
             FROM fid_schedule, fid_channel
            WHERE     sch_lic_number = i_licnumber
                  AND sch_cha_number = cha_number
                  AND sch_date < l_open_month
                  AND sch_type = 'P'
         GROUP BY cha_short_name
         ORDER BY cha_short_name;

      OPEN o_media_service FOR
         SELECT ms_media_service_flag, MS_MEDIA_SERVICE_CODE
           FROM SGY_PB_MEDIA_SERVICE
          WHERE     --MS_MEDIA_SERVICE_CODE NOT IN ('TVOD','PAYTV','CATCHUP');
               MS_MEDIA_SERVICE_PARENT = 'SVOD'; --Added parent media service type for SVOD.
   -- Project 5_2 : End

   --Dev.R1: CatchUp for All :[BR_15_272_UC_Super Stacking]_[Milan Shah]_[2015/12/29]: Start
       OPEN O_SUPERSTACK_RIGHTS     FOR
       SELECT DISTINCT CB_NAME
              ,CB_ID
              ,CB_RANK
             -- ,NVL(LSR_SUPERSTACK_FLAG,'N') LSR_SUPERSTACK_FLAG
             ,nvl((SELECT LSR_SUPERSTACK_FLAG FROM X_CP_LIC_SUPERSTACK_RIGHTS WHERE LSR_LIC_NUMBER=LIC_NUMBER AND LSR_BOUQUET_ID = CB_ID),'N') LSR_SUPERSTACK_FLAG
             ,nvl((PKG_ALIC_CM_LICENSEMAINTENANCE.x_fnc_cal_viewing_days(i_licnumber,CB_ID)),LIC_MAX_VIEWING_PERIOD) SCH_VIEWING_DAYS
             --,ceil (nvl((PLT_SCH_END_DATE - PLT_SCH_START_DATE),LIC_MAX_VIEWING_PERIOD)) SCH_VIEWING_DAYS
              --nvl((PLT_SCH_END_DATE - PLT_SCH_START_DATE),LIC_MAX_VIEWING_PERIOD)
             --  LIC_MAX_VIEWING_PERIOD SCH_VIEWING_DAYS
              ,(
                CASE
                    WHEN
                      CB_ID  IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP)
                    THEN
                      CASE
                        WHEN
                          (
                            SELECT COUNT(1) FROM X_CP_CON_SUPERSTACK_RIGHTS WHERE
                            CSR_CON_NUMBER = (SELECT LIC_CON_NUMBER FROM FID_LICENSE WHERE LIC_NUMBER = i_licnumber)
                            AND CSR_BOUQUET_ID = CB_ID
                          )>0
                          AND 'Y' = NVL((SELECT distinct CSR_SUPERSTACK_FLAG FROM X_CP_CON_SUPERSTACK_RIGHTS
                                    WHERE CSR_CON_NUMBER = (SELECT LIC_CON_NUMBER FROM FID_LICENSE WHERE LIC_NUMBER = i_licnumber ) AND CSR_BOUQUET_ID = CB_ID
                                    AND CSR_SEA_NUMBER = (SELECT GEN_SER_NUMBER FROM FID_GENERAL WHERE GEN_REFNO = (SELECT LIC_GEN_REFNO FROM FID_LICENSE WHERE LIC_NUMBER =i_licnumber ))),'N')
                        THEN
                          CASE
                            WHEN
                                (SELECT COUNT(1) FROM X_CP_PLT_TERR_BOUQ WHERE ptb_plt_id = XCPL.PLT_ID AND ptb_bouquet_id = CB_ID) > 0 AND (SELECT NVL(LSR_SUPERSTACK_FLAG,'N') FROM X_CP_LIC_SUPERSTACK_RIGHTS WHERE LSR_LIC_NUMBER=LIC_NUMBER AND LSR_BOUQUET_ID = CB_ID) = 'Y'
                            THEN
                              'N'
                            WHEN
                              (SELECT COUNT(1) FROM X_CP_PLT_TERR_BOUQ WHERE ptb_plt_id = XCPL.PLT_ID AND ptb_bouquet_id = CB_ID) = 0 AND (SELECT NVL(LSR_SUPERSTACK_FLAG,'N') FROM X_CP_LIC_SUPERSTACK_RIGHTS WHERE LSR_LIC_NUMBER=LIC_NUMBER AND LSR_BOUQUET_ID = CB_ID) IN ('Y','N')
                            THEN
                              'Y'
                            ELSE
                              'N'
                            END
                        ELSE
                          'N'
                    END
                ELSE
                'N'
              END
            )EDITABLE_FLAG
            ,(SELECT NVL(LSR_UPDATE_COUNT,0) FROM X_CP_LIC_SUPERSTACK_RIGHTS WHERE LSR_LIC_NUMBER=LIC_NUMBER AND LSR_BOUQUET_ID = CB_ID) LSR_UPDATE_COUNT
            ,(select
                    (case
                       when
                         count(1)>0
                       then
                          'Y'
                        else
                          'N'
                       END)
             from x_cp_play_list,X_CP_PLT_TERR_BOUQ
             where plt_lic_number = i_licnumber
                   and plt_id = ptb_plt_id
                   and PTB_BOUQUET_ID = CB_id
                   and PLT_SCH_END_DATE >= (SELECT (TO_DATE(LPAD(FIM_MONTH,'2','0')||FIM_YEAR,'MMYYYY'))FROM FID_FINANCIAL_MONTH
                              WHERE FIM_STATUS ='O' AND FIM_SPLIT_REGION = PLT_REG_CODE))is_scheduled
        FROM
        FID_LICENSE
        ,X_CP_BOUQUET
       -- ,X_CP_LIC_SUPERSTACK_RIGHTS
        ,X_CP_PLAY_LIST XCPL
        ,X_CP_BOUQUET_MS_MAPP
      WHERE
        --LSR_LIC_NUMBER = 983131
       -- AND CB_ID = LSR_BOUQUET_ID(+)
         PLT_LIC_NUMBER(+) = LIC_NUMBER
        AND CMM_BOUQ_ID(+)=CB_ID
        AND CB_BOUQ_PARENT_ID IS NULL
        AND LIC_NUMBER = i_licnumber
        AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP
                      WHERE CMM_BOUQ_MS_CODE IN(select LEE_MEDIA_SERVICE_CODE from fid_license,fid_licensee
                                                          where lic_number = i_licnumber AND lic_lee_number = lee_number)AND CMM_BOUQ_MS_RIGHTS ='Y')
        ORDER BY CB_RANK;



   --Dev.R1: CatchUp for All: End


   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (stmt_str);
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_licensedetail;

   --****************************************************************
   -- This procedure searches Channel Allocation.
   -- This procedure input is license Number and Contract Prime Time Level.
   --****************************************************************
   PROCEDURE prc_alic_cm_searchchnlallocat (
      i_lcrlicnumber              IN     fid_license_channel_runs.lcr_lic_number%TYPE,
      i_conprimetimelevel         IN     fid_contract.con_prime_time_level%TYPE,
      o_searchchannelallocation      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
      l_split_region   fid_licensee.lee_split_region%TYPE;
   BEGIN
      SELECT lee_split_region
        INTO l_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_lcrlicnumber);

      --DBMS_OUTPUT.put_line ('l_split_region:' || l_split_region);

      OPEN o_searchchannelallocation FOR
         SELECT flcr.lcr_number,
                flcr.lcr_lic_number,
                flcr.lcr_cha_number,
                flcr.lcr_runs_allocated,
                flcr.lcr_runs_used,
                flcr.lcr_cost_ind,
                flcr.lcr_post_exh_runs,
                fc.cha_short_name,
                flcr.lcr_runs_remaining,
                flcr.lcr_costing_runs,
                /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
                flcr.lcr_max_runs_cha,
                DECODE (
                   i_conprimetimelevel,
                   'CHANL', fid_primetime_pk.cnt_pt_runs (
                               i_lcrlicnumber,
                               TO_DATE ('31-DEC-2199', 'DD-MON-YYYY'),
                               flcr.lcr_cha_number),
                   NULL)
                   "PT Runs",
                NVL (flcr.lcr_update_count, 0) lcr_update_count,
                -- Project Bioscope : Ajit_20120313 : Media Service, Media Platform, Scheduling Window Start and End Date added
                flcr.lcr_cha_costed_runs,
                ---Commenting out the media service/platform changes for CR----
                /* (select mpsm_mapp_service_code
                 from    sgy_pb_med_platm_service_map
                 where mpsm_mapp_id = fc.cha_mpsm_mapp_id) cha_media_ser_code,
                 (select mpsm_mapp_platform_code
                 from    sgy_pb_med_platm_service_map
                 where mpsm_mapp_id = fc.cha_mpsm_mapp_id) cha_media_plat_code,
                 cha_mpsm_mapp_id, */
                TO_CHAR (flcr.lcr_sch_start_date, 'DD-Mon-YYYY')
                   lcr_sch_start_date,
                TO_CHAR (flcr.lcr_sch_end_date, 'DD-Mon-YYYY')
                   lcr_sch_end_date,
                ---PB_CR08 Bioscope changes by Pranay Kusumwal 04/06/2012---
                ---adding the new scheduling windows,costed runs used and total----
                TO_CHAR (flcr.lcr_sch_start_date2, 'DD-Mon-YYYY')
                   lcr_sch_start_date2,
                TO_CHAR (flcr.lcr_sch_end_date2, 'DD-Mon-YYYY')
                   lcr_sch_end_date2,
                cha_roy_flag,
                flcr.lcr_cha_costed_runs2,
                pkg_alic_cm_licensemaintenance.x_fun_costed_channel (
                   flcr.lcr_lic_number,
                   flcr.lcr_cha_number,
                   flcr.lcr_sch_start_date,
                   flcr.lcr_sch_end_date)
                   costed_runs_used,
                (SELECT COUNT (sch_number)
                   FROM fid_schedule
                  WHERE     sch_type = 'P'
                        AND sch_lic_number = flcr.lcr_lic_number
                        AND sch_cha_number = flcr.lcr_cha_number
                        AND sch_date BETWEEN flcr.lcr_sch_start_date2
                                         AND flcr.lcr_sch_end_date2
                        AND sch_date <=
                               (SELECT LAST_DAY (
                                          MAX (
                                             TO_DATE (fim_year || fim_month,
                                                      'YYYYMM')))
                                  FROM fid_financial_month
                                 WHERE fim_status = 'C'
                                       AND NVL (fim_split_region, 1) =
                                              DECODE (fim_split_region,
                                                      NULL, 1,
                                                      l_split_region)))
                   costed_runs_used2,
                (NVL (flcr.lcr_cha_costed_runs, 0)
                 + NVL (flcr.lcr_cha_costed_runs2, 0))
                   total_costed_runs,
                ( (pkg_alic_cm_licensemaintenance.x_fun_costed_channel (
                      flcr.lcr_lic_number,
                      flcr.lcr_cha_number,
                      flcr.lcr_sch_start_date,
                      flcr.lcr_sch_end_date)
                   + (SELECT COUNT (sch_number)
                        FROM fid_schedule
                       WHERE     sch_type = 'P'
                             AND sch_lic_number = flcr.lcr_lic_number
                             AND sch_cha_number = flcr.lcr_cha_number
                             AND sch_date BETWEEN flcr.lcr_sch_start_date2
                                              AND flcr.lcr_sch_end_date2
                             AND sch_date <=
                                    (SELECT LAST_DAY (
                                               MAX (
                                                  TO_DATE (
                                                     fim_year || fim_month,
                                                     'YYYYMM')))
                                       FROM fid_financial_month
                                      WHERE fim_status = 'C'
                                            AND NVL (fim_split_region, 1) =
                                                   DECODE (fim_split_region,
                                                           NULL, 1,
                                                           l_split_region)))))
                   total_costed_used_runs
           -- Project Bioscope : Ajit_20120313 : End
           FROM fid_license_channel_runs flcr, fid_channel fc
          WHERE flcr.lcr_cha_number = cha_number
                AND flcr.lcr_lic_number = i_lcrlicnumber;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
        -- DBMS_OUTPUT.PUT_LINE (SQLERRM);
   END prc_alic_cm_searchchnlallocat;

   --****************************************************************
   -- This procedure edits License Details.
   -- It uses license number and update count for updating record.
   --****************************************************************
    PROCEDURE prc_alic_cm_editlicensedetail (
      i_licnumber                 IN     fid_license.lic_number%TYPE,
      i_licleenumber              IN     fid_license.lic_lee_number%TYPE,
      i_licchsnumber              IN     fid_license.lic_chs_number%TYPE,
      i_licexternalref            IN     fid_license.lic_external_ref%TYPE,
      i_licstatus                 IN     fid_license.lic_status%TYPE,
      -- Project Bioscope : Ajit_20120316 : premium and Time Shift Flag added
      i_premier                   IN     fid_license.lic_premium_flag%TYPE,
      --Dev8:RDT:Start:{DEEPAK]_[27/08/2013]--Added on hold flag
      i_onhold                    IN     fid_license.lic_on_hold_flag%TYPE,
      ----DEV.RDT: PHOENIX REQUIREMENT: START:Phoenix_04_Marking_License_as_Feed_NEERAJ_2014/03/21]
      i_licfeed                   IN     fid_license.lic_feed_flag%TYPE,
      ----DEV.RDT: PHOENIX REQUIREMENT: END------------------------
      i_timeshiftchannel          IN     fid_license.lic_time_shift_cha_flag%TYPE,
      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
      i_simulcastchannel                 fid_license.lic_simulcast_cha_flag%TYPE,
      /* PB (CR 12) : END */
      -- Project Bioscope : Ajit_20120316 : End
      -- CP R1 mrunmayi kusurkar
      i_max_vp_in_days            IN     fid_license.lic_max_viewing_period%TYPE,
      i_sch_aft_prem_linear       IN     fid_license.lic_sch_aft_prem_linear%TYPE,
      --CATCHUP : CACQ:14 add new validation parameters for catchup license [SHANTANU A.]_[08-oct-2014]
      i_sch_x_days_bef_linr       IN     fid_license.lic_sch_bef_x_day%TYPE,
      i_sch_x_days_bef_linr_val   IN     fid_license.lic_sch_bef_x_day_value%TYPE,
      i_sch_without_linr_ref      IN     fid_license.lic_sch_without_lin_ref%TYPE,
      --CATCHUP : CACQ:14 add new validation parameters for catchup license [SHANTANU A.]_[END]
      i_non_cons_month            IN     fid_license.lic_non_cons_month%TYPE,
      i_catchup_upd_cnt           IN     fid_license.lic_update_count%TYPE,
      -- end
      i_licstart                  IN     fid_license.lic_start%TYPE,
      i_licend                    IN     fid_license.lic_end%TYPE,
      i_licperiodtba              IN     fid_license.lic_period_tba%TYPE,
      i_licpricecode              IN     fid_license.lic_price_code%TYPE,
      i_licbudgetcode             IN     fid_license.lic_budget_code%TYPE,
      i_licprice                  IN     fid_license.lic_price%TYPE,
      i_licmarkuppercent          IN     fid_license.lic_markup_percent%TYPE,
      i_licshowingint             IN     fid_license.lic_showing_int%TYPE,
      i_licshowinglic             IN     fid_license.lic_showing_lic%TYPE,
      i_licamortcode              IN     fid_license.lic_amort_code%TYPE,
      i_licmaxchs                 IN     fid_license.lic_max_chs%TYPE,
      i_licmaxcha                 IN     fid_license.lic_max_cha%TYPE,
      i_licexclusive              IN     fid_license.lic_exclusive%TYPE,
      i_licminsubscriber          IN     fid_license.lic_min_subscriber%TYPE,
      i_licminguarantee           IN     fid_license.lic_min_guarantee%TYPE,
      i_liccomment                IN     fid_license.lic_comment%TYPE,
      i_licupdatecount            IN     fid_license.lic_update_count%TYPE,
      i_lic_rate                  IN     fid_license.lic_rate%TYPE,
      i_entryoper                 IN     fid_license.lic_entry_oper%TYPE,
      /*Project AfricaFreeRuns:Start : Nishant Ankam , two fields added */
      i_nooffreereps              IN     fid_license.lic_free_rpt%TYPE,
      i_repperiod                 IN     fid_license.lic_rpt_period%TYPE,
      /*Project AfricaFreeRuns:End : Nishant Ankam , two fields added */
      -- PB CR Mrunmayi
      i_bo_category               IN     fid_general.gen_bo_category_code%TYPE,
      -- END
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : check for transfer_payment operation
      i_trnsfr_pmnt_flag          IN     VARCHAR2,
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : end
      ---BR_15_144:Warner Payment: Rashmi Tijare_20150107:Addition of Checkboxes
      i_min_gurantee_lic          IN     fid_license.LIC_MIN_GUARANTEE_FLAG%TYPE,
      i_min_gurantee_sub          IN     fid_license.lic_min_subs_flag%TYPE,
      --Warner Payment End
      --RDT Start : Acquision Requirements BR_15_244 [Rashmi_Tijare][14/10/2015]
      i_is_dstv_right              In     fid_license.lic_is_dstv_right%TYPE,
      i_dstv_flag                 In Varchar2,
--RDT End : Acquision Requirements BR_15_244 [Rashmi_Tijare][14/10/2015]
--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
      i_lic_details  in pkg_alic_cm_licensemaintenance.lic_details,
--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
      o_status                       OUT NUMBER,
      o_paymonthno                   OUT NUMBER,
      o_sch_lic_present_past         OUT VARCHAR2)
   AS
      CURSOR get_db_status
      IS
         SELECT lic_status
           FROM fid_license
          WHERE lic_number = i_licnumber;

      /* PB (CR 6) :Pranay Kusumwal 18/07/2012 : Added for validation for Amort Exhibitions */
      count_exh                        NUMBER;
      /* PB (CR 6) :Pranay Kusumwal 18/07/2012 : end */
      v_db_status                      VARCHAR2 (4);
      cost_total                       NUMBER;
      l_con_number                     NUMBER;
      l_con_start_date                 DATE;
      l_con_end_date                   DATE;
      ------Added by Nishant-----------------
      l_prev_lee_number                NUMBER;
      l_prev_lic_region                NUMBER;
      l_prev_lic_cha_comp              NUMBER;
      l_new_lic_region                 NUMBER;
      l_new_lic_cha_comp               NUMBER;
      is_catchup_flag                  VARCHAR2 (1);
      l_sec_lee_count                  NUMBER;
      l_not_in_count                   NUMBER;

      ------End-------------------
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411 : Go live date of costing 5+2
      v_go_live_crc_date               DATE;
      l_costed_runs                    X_FIN_COSTING_RULE_CONFIG%ROWTYPE;
      costedrunexists                  EXCEPTION;
      l_is_bio_true                    CHAR (1);


--START BR_15_005 FINCR ANKUR KASAR : ADDED LOCAL ARRAY.
      v_lic_num_array           x_pkg_common_var.number_array;
      v_lee_num_array           x_pkg_common_var.number_array;
      v_lic_old_start           x_pkg_common_var.date_array;
      v_lic_new_start           x_pkg_common_var.date_array;
      v_lic_genref_num_array    x_pkg_common_var.number_array;
      v_lic_con_num_array       x_pkg_common_var.number_array;
--END BR_15_005 FINCR ANKUR KASAR :
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411: End

      --Warner Payment :start
        l_subs_flag    varchar2(1);
        --end

      CURSOR get_asset_sub_ledger (
         I_Fim_Year     Number,
         I_Fim_Month    Number,
         l_licnumber    number
         )
      IS
           -----Dev:Pure Finance:Start:{Hari Mandal]_[28/03/2013]--------
           SELECT lis_lic_number,
                  lis_lsl_number,
                  lis_ter_code,
                  NVL (SUM (lis_con_forecast), 0) lis_con_forecast,
                  NVL (SUM (lis_loc_forecast), 0) lis_loc_forecast,
                  NVL (SUM (lis_con_actual), 0) lis_con_actual,
                  NVL (SUM (lis_con_adjust), 0) lis_con_adjust,
                  NVL (SUM (lis_con_writeoff), 0) lis_con_writeoff,
                  NVL (SUM (lis_loc_actual), 0) lis_loc_actual,
                  NVL (SUM (lis_loc_adjust), 0) lis_loc_adjust,
                  NVL (SUM (lis_loc_writeoff), 0) lis_loc_writeoff,
                  NVL (SUM (lis_pv_con_forecast), 0) lis_pv_con_forecast,
                  NVL (SUM (lis_pv_loc_forecast), 0) lis_pv_loc_forecast,
                  NVL (SUM (lis_pv_con_inv_actual), 0) lis_pv_con_inv_actual,
                  NVL (SUM (lis_pv_con_liab_actual), 0) lis_pv_con_liab_actual,
                  NVL (SUM (lis_pv_loc_inv_actual), 0) lis_pv_loc_inv_actual,
                  NVL (SUM (lis_pv_loc_liab_actual), 0) lis_pv_loc_liab_actual,
                  NVL (SUM (lis_ed_loc_forecast), 0) lis_ed_loc_forecast,
                  NVL (SUM (lis_ed_loc_actual), 0) lis_ed_loc_actual,
                  NVL (SUM (lis_con_unforseen_cost), 0) lis_con_unforseen_cost,
                  NVL (SUM (lis_loc_unforseen_cost), 0) lis_loc_unforseen_cost,
                  --added by sushma/swapnil to reverse the mg adjustment value for warner payment while cancel the license on 22-07-2015
                  NVL(SUM(LIS_ASSET_ADJ_VALUE),0) lis_mg_asset_value,
                  NVL(SUM(LIS_MG_PV_CON_FORECAST),0) LIS_MG_PV_CON_FORECAST,
                  NVL(SUM(LIS_MG_PV_LOC_FORECAST),0) LIS_MG_PV_LOC_FORECAST,
                  NVL(SUM(LIS_LOC_ASSET_ADJ_VALUE),0) LIS_LOC_ASSET_ADJ_VALUE,
				  NVL(SUM(Lis_Mg_Pv_Con_Liab),0) Lis_Mg_Pv_Con_Liab ,
				  NVL(SUM(LIS_MG_PV_LOC_LIAB),0) LIS_MG_PV_LOC_LIAB
                  --end
             FROM fid_license_sub_ledger
            WHERE lis_lic_number = l_licnumber
            AND lis_per_year || LPAD (lis_per_month, 2, 0) < I_FIM_YEAR || LPAD (I_FIM_MONTH, 2, 0)
         GROUP BY lis_lic_number, lis_lsl_number, lis_ter_code;
        /* GROUP BY LIS_LIC_NUMBER, LIS_LSL_NUMBER, LIS_TER_CODE,LIS_CON_FORECAST,lis_loc_forecast,
         LIS_CON_ACTUAL,LIS_CON_ADJUST, LIS_CON_WRITEOFF,LIS_LOC_ACTUAL,LIS_LOC_ADJUST,LIS_LOC_WRITEOFF,LIS_PV_CON_FORECAST,LIS_PV_LOC_FORECAST,LIS_PV_CON_INV_ACTUAL,LIS_PV_CON_LIAB_ACTUAL,LIS_PV_LOC_INV_ACTUAL,
         lis_pv_loc_liab_actual,lis_ed_loc_forecast,lis_ed_loc_actual,lis_con_unforseen_cost,lis_loc_unforseen_cost, LIS_ASSET_ADJ_VALUE,LIS_MG_PV_CON_FORECAST,LIS_MG_PV_LOC_FORECAST,LIS_LOC_ASSET_ADJ_VALUE;
		*/
      -----Dev:Pure Finance:End------------------------------------------
      v_ter_code                       VARCHAR2 (3);
      v_forecast                       NUMBER;
      l_flag                           INTEGER := -1;
      asset_value                      NUMBER;

      CURSOR get_licdate_status
      IS
         SELECT lic_start,
                lic_end,
                lic_period_tba,
                lic_price
           FROM fid_license
          WHERE lic_number = i_licnumber;

      l_licstart                       DATE;
      l_licend                         DATE;
      l_licperiodtba                   VARCHAR2 (20);
      l_licprice                       NUMBER;

      CURSOR lpy_c
      IS
         SELECT *
           FROM fid_license_payment_months
          WHERE lpy_paid_ind = 'N' AND lpy_lic_number = i_licnumber;

       -- WArner Payment :Rashmi Tijare :11-08-2015:START
    CURSOR lmg_c
      IS
         SELECT *
           FROM x_fin_mg_pay_plan
          WHERE nvl(MGP_IS_CALC,'N') = 'N' AND nvl(MGP_IS_PAID,'N') ='N' AND MGP_LIC_NUMBER = i_licnumber;

          -- WArner Payment :Rashmi Tijare :11-08-2015:END

      CURSOR get_db_status_cancel_lic
      IS
         SELECT lic_status, lic_cancel_date
           FROM fid_license
          WHERE lic_number = i_licnumber;

      o_sch_present                    VARCHAR2 (1); --CATCHUP:CACQ414:START_SHANTANU A.
      v_pay_month                      DATE;
      v_pay_month_no                  NUMBER; --Onsite.Dev:BR_15_321
      l_pay_month_no_exists           NUMBER; --Onsite.Dev:BR_15_321
      v_endstarttbaupdated             NUMBER;
      updatefailed                     EXCEPTION;
      exh_exceed_failed                EXCEPTION;
      l_max_closed                     NUMBER;
      l_max_month                      NUMBER;
      l_showing_lic                    NUMBER;
      l_tot_schedule_exits             NUMBER;
      l_cha_schedule_exits             NUMBER;
      l_channel_name                   VARCHAR2 (10);
      -- CP R1 mrunmayi kusurkar
      l_lic_start                      fid_license.lic_start%TYPE;
      l_lic_end                        fid_license.lic_end%TYPE;
      --15_FIN_06_ENH_Cancel Season in one attempt_v1.0
      l_lic_end_old                        fid_license.lic_end%TYPE;
      l_lic_price_old                    fid_license.lic_price%TYPE;
      l_rows_affected number;
      canclefailed exception;
      --15_FIN_06_ENH_Cancel Season in one attempt_v1.0
      l_lic_catchup_flag               fid_license.lic_catchup_flag%TYPE;
      l_changed_date_flag              VARCHAR2 (30);
      l_cha_exists_for_service_count   NUMBER;
      l_cha_short_name                 fid_channel.cha_short_name%TYPE;
      l_chs_short_name                 fid_channel_service.chs_short_name%TYPE;
      l_old_lic_chs_number             fid_channel_service.chs_number%TYPE;
      l_lic_max_viewing_period         fid_license.lic_max_viewing_period%TYPE;
      l_lic_cp_tba_sch_flg             fid_license.lic_cp_tba_sch_flg%TYPE;
      -- end
      -----Dev:Pure Finance:Start:{Hari Mandal]_[28/03/2013]--------
      i_split_region                   fid_licensee.lee_split_region%TYPE;
      l_fim_year                       NUMBER;
      l_fim_month                      NUMBER;
      i_cancel_date                    DATE;
      i_last_date                      DATE;
      -----Dev:Pure Finance:End------------------------------------------
      -----Dev:Pure Finance:Start:{ADITYA GUPTA]_[8/05/2013]--------
      l_lic_status                     VARCHAR2 (4);
      --Dev8:RDT:Start:{DEEPAK]_[27/08/2013]
      l_future_sch_count               NUMBER;
      -----Dev:Pure Finance:End------------------------------------------
      -----Dev:Pure Finance:End------------------------------------------
      l_gen_refno                      NUMBER;
      ----- dev3: sap implementation : start : <24/07/2013> : <requirement description>
      l_paid_amt                       NUMBER;
      l_number                         NUMBER;
      l_cnt                            NUMBER;
      l_count                          NUMBER;
      l_count1                         NUMBER;
      l_flag1                          VARCHAR2 (10);
      l_remain_amt                     NUMBER;
      targetcom                        NUMBER;
      l_mem_agy_com_number             NUMBER;
      l_mem_com_number                 NUMBER;
      sourcecom                        NUMBER;
      contentstatus                    VARCHAR2 (5);
      l_lic_currency                   VARCHAR2 (5);
      l_notpaid_amt                    NUMBER;
      l_notpaid_amt1                   NUMBER;
      l_total_pay_price                NUMBER;
      l_extra_pay_amt                  NUMBER;
      l_pay_number                     NUMBER;
      l_lsl_number                     NUMBER;
      l_lic_price                      NUMBER;
      l_lic_existing_status            fid_license.lic_status%TYPE;
      l_old_lic_cancel_date            fid_license.lic_Cancel_date%TYPE;
      l_lic_licstatus                  fid_license.lic_status%TYPE;
      l_split_pay_month                fid_license_payment_months.lpy_pay_month%TYPE;
      v_endstartmgupdated             NUMBER;
      l_open_date                     DAte;
      v_add_month                     DAte;
      l_end                           DAte;
      l_pay_month                     NUMBER;
      l_pay_mg_month                  NUMBER;
      l_title                         varchar2(100);
      l_lee_name                      varchar2(20);
      i_month_no                      Number;

      -----  DEV3: SAP Implementation : End : <24/07/2013>------------------------

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411 : Cursor for amort exh present in costing rule config
      CURSOR get_costed_runs
      IS
         SELECT *
           FROM X_FIN_COSTING_RULE_CONFIG
          WHERE     crc_lic_start_from <= i_licstart
                AND crc_lic_start_to >= i_licstart
                AND crc_costed_runs = i_licshowinglic;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411: End

      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140430 : variables for obtaining insert and delete status
      l_status_ins                     NUMBER := 1;
      l_status_del                     NUMBER := 1;
      l_dst_lic                        NUMBER;
      l_pay_amount                     NUMBER;
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140430 : End
      l_old_lic_start                  DATE;
      l_old_lic_end                    DATE;
      l_lee_bioscope_flag              CHAR (1);
      l_gen_type                       CHAR (10);
      l_lic_amort                      CHAR (10);
      l_get_bioscope_flag              CHAR (1);
      /* start nasreen */
      licensee_code_count              NUMBER := 0;
      /*end */

      --BR_15_144:Warner Payment -start
      l_lic_type                       fid_license.lic_type%TYPE;
   --end
           --Added by Jawahar.Garg for FINCR
			l_LIC_WRITEOFF_MARK             fid_license.LIC_WRITEOFF_MARK%TYPE; --ADDED BY ANKUR KASAR (FINCR NOTIFICATION MAIL)
			l_LIC_GEN_REFNO                 fid_license.LIC_GEN_REFNO%TYPE;     --ADDED BY ANKUR KASAR (FINCR NOTIFICATION MAIL)
			l_lic_number_ary  		x_pkg_common_var.number_array;
			l_gen_title_ary    		x_pkg_common_var.varchar_array;
			l_old_lic_start_ary		x_pkg_common_var.date_array;
			l_new_lic_start_ary		x_pkg_common_var.date_array;
			l_con_name_ary			x_pkg_common_var.varchar_array;
			l_con_short_name_ary		x_pkg_common_var.varchar_array;
			l_lic_lee_number_ary		x_pkg_common_var.number_array;
		--Added by Jawahar.Garg for FINCR
    l_media_service_code      fid_licensee.lee_media_service_code%TYPE;
   BEGIN
      SELECT lic_start, lic_end
        INTO l_old_lic_start, l_old_lic_end
        FROM fid_license
       WHERE lic_number = i_licnumber;
        --Start[15-Jun-2016][Jawahar.Garg]Changes done for FINCR
	BEGIN
		SELECT   	LIC_NUMBER,
				gen_title,
				LIC_START,
				i_licstart,
				con_name,
				con_short_name,
				lic_lee_number
		BULK
		COLLECT
		INTO
				l_lic_number_ary ,
				l_gen_title_ary,
				l_old_lic_start_ary,
				l_new_lic_start_ary,
				l_con_name_ary,
				l_con_short_name_ary,
				l_lic_lee_number_ary
		FROM    fid_license fl,
			fid_general fg,
			fid_contract fc
		WHERE lic_number = i_licnumber
		  AND fl.lic_gen_refno = fg.gen_refno
		  AND fl.lic_con_number = fc.con_number
		  AND lic_status NOT IN ('I','T')
		  AND LIC_WRITEOFF_MARK = 'Y';
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	NULL;
	END;
			--End [15-Jun-2016][Jawahar.Garg]Changes done for FINCR

      o_status := 0;
      o_paymonthno := 0;
      v_endstarttbaupdated := 0;
      v_endstartmgupdated :=0;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411 : Go live date of costing 5+2
      SELECT TO_DATE (content)
        INTO v_go_live_crc_date
        FROM x_fin_configs
       WHERE ID = 6;

      SELECT SUM (pay_amount)
        INTO l_pay_amount
        FROM fid_payment
       WHERE pay_lic_number = i_licnumber;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411: End

--RDT Start : Acquision Requirements BR_15_104 [Rashmi_Tijare][14/10/2015]
      Select lic_con_number
      into l_con_number
      from fid_license
      where lic_number = i_licnumber;
  --RDT End: Acquision Requirements BR_15_104 [Rashmi_Tijare][14/10/2015]

      -- CP R1 mrunmayi kusurkar
      SELECT lic_start,
             lic_end,
             NVL (lic_catchup_flag, 'N'),
             lic_chs_number
        INTO l_lic_start,
             l_lic_end,
             l_lic_catchup_flag,
             l_old_lic_chs_number
        FROM fid_license
       WHERE lic_number = i_licnumber;

      ---Dev2:Pure Finance:Start:[Hari_Mandal]_[19/4/2013]
      SELECT lee_split_region
        INTO i_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_licnumber);

      SELECT fim_year, fim_month
        INTO l_fim_year, l_fim_month
        FROM fid_financial_month
       WHERE fim_status = 'O'
             AND NVL (fim_split_region, 1) =
                    DECODE (fim_split_region, NULL, 1, i_split_region);

      SELECT LAST_DAY (
                TO_DATE ('01' || LPAD (fim_month, 2, 0) || fim_year,
                         'DDMMYYYY'))
        INTO i_last_date
        FROM fid_financial_month
       WHERE fim_status = 'O'
             AND NVL (fim_split_region, 1) =
                    DECODE (fim_split_region, NULL, 1, i_split_region);

      /*
   NOC :
   If license is cancelled in next month of open financial month, cancel_date will be last date of open financial month
   NEERAJ : KARIM : 18-12-2013
   */
      /*
      IF TRUNC (SYSDATE) < i_last_date
      THEN
         i_cancel_date := TRUNC (SYSDATE);
      ELSE
         i_cancel_date := i_last_date;
      END IF;
      */
      OPEN get_db_status_cancel_lic;

      FETCH get_db_status_cancel_lic
      INTO l_lic_existing_status, l_old_lic_cancel_date;

      CLOSE get_db_status_cancel_lic;

      IF l_lic_existing_status = 'C'
      THEN
         i_cancel_date := l_old_lic_cancel_date;
      ELSE
         IF i_licstatus = 'C'
         THEN
            IF TRUNC (SYSDATE) < i_last_date
            THEN
               i_cancel_date := TRUNC (SYSDATE);
            ELSE
               i_cancel_date := i_last_date;
            END IF;
         END IF;
      END IF;

      IF l_lic_existing_status = 'C'
      THEN
         l_lic_licstatus := 'C';
      ELSE
         l_lic_licstatus := i_licstatus;
      END IF;

      ---Dev2:Pure Finance:End--------------------------

      -- end

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411 : License start date check with GO live date
      IF (i_licstart >= v_go_live_crc_date) AND l_lic_amort <> 'A'
      THEN
         IF (NVL (i_licshowinglic, 0) > 0)
         THEN
            BEGIN
               OPEN get_costed_runs;

               FETCH get_costed_runs INTO l_costed_runs;

               IF get_costed_runs%NOTFOUND
               THEN
                  RAISE costedrunexists;
               END IF;

               CLOSE get_costed_runs;
            EXCEPTION
               WHEN costedrunexists
               THEN
                  raise_application_error (
                     -20601,
                     'Costing rule for the Amort Exh. is not defined on Costing Rule Configuration screen.');
               WHEN OTHERS
               THEN
                  raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
            END;
         END IF;
      END IF;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411: End

      IF l_old_lic_chs_number <> i_licchsnumber
      THEN
         FOR cha_cur IN (SELECT lcr_cha_number
                           FROM fid_license_channel_runs
                          WHERE lcr_lic_number = i_licnumber)
         LOOP
            SELECT cha_short_name
              INTO l_cha_short_name
              FROM fid_channel
             WHERE cha_number = cha_cur.lcr_cha_number;

            SELECT chs_short_name
              INTO l_chs_short_name
              FROM fid_channel_service
             WHERE chs_number = i_licchsnumber;

            SELECT COUNT (0)
              INTO l_cha_exists_for_service_count
              FROM (SELECT chs_cha_number
                      FROM fid_channel_service
                     WHERE chs_cha_number = cha_cur.lcr_cha_number
                           AND chs_number = i_licchsnumber
                    UNION
                    SELECT csc_cha_number
                      FROM fid_channel_service_channel
                     WHERE csc_cha_number = cha_cur.lcr_cha_number
                           AND csc_chs_number = i_licchsnumber);

            IF l_cha_exists_for_service_count = 0
            THEN
               raise_application_error (
                  -20016,
                  'Some of the Allocated Channels do not belong to service '
                  || l_chs_short_name);
            END IF;
         END LOOP;
      END IF;

--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
for lic in i_lic_details.first .. i_lic_details.last
loop
      IF  X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),2) = 'C' --i_licstatus = 'C'
      THEN

         select lic_status,lic_cancel_date ,lic_end,round(lic_price,5)
         INTO l_lic_existing_status, l_old_lic_cancel_date,l_lic_end_old,l_lic_price_old
         from fid_license
         where lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1);
        -- OPEN get_db_status;

        -- FETCH get_db_status INTO v_db_status;

          IF l_lic_existing_status = 'C'
          THEN
             i_cancel_date := l_old_lic_cancel_date;
          ELSE
             IF X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),2) = 'C'--i_licstatus = 'C'
             THEN
                IF TRUNC (SYSDATE) < i_last_date
                THEN
                   i_cancel_date := TRUNC (SYSDATE);
                ELSE
                   i_cancel_date := i_last_date;
                END IF;
             END IF;
          END IF;

         IF l_lic_existing_status != 'C' --v_db_status != 'C'
         THEN
            /*
         NOC :
         sum till cancelled date.
         NEERAJ : KARIM : 18-12-2013
         */
            SELECT SUM (lis_con_actual + lis_con_adjust),
                   SUM (lis_con_forecast)
              INTO cost_total, asset_value
              FROM fid_license_sub_ledger
             WHERE lis_lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1)--i_licnumber
                   AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                          TO_CHAR (i_last_date, 'YYYYMM');

            DELETE FROM fid_license_sub_ledger
                  WHERE lis_lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1)--i_licnumber
                        AND lis_per_year || LPAD (lis_per_month, 2, 0) >=
                               TO_CHAR (i_last_date, 'YYYYMM');

            IF asset_value != 0
            Then
               FOR i IN get_asset_sub_ledger (l_fim_year, l_fim_month,X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1))
               LOOP
                  BEGIN
                     DELETE FROM fid_license_sub_ledger
                           WHERE     lis_per_month = l_fim_month
                                 AND lis_per_year = l_fim_year
                                 AND lis_ter_code = i.lis_ter_code
                                 And Lis_Lsl_Number = I.Lis_Lsl_Number
                                 AND lis_lic_number = i.lis_lic_number;--i_licnumber;

                     INSERT
                       INTO fid_license_sub_ledger (lis_lic_number,
                                                    lis_ter_code,
                                                    lis_per_year,
                                                    lis_per_month,
                                                    lis_price,
                                                    lis_adjust_factor,
                                                    lis_rate,
                                                    lis_paid_exhibition,
                                                    lis_con_forecast,
                                                    lis_loc_forecast,
                                                    lis_con_calc,
                                                    lis_loc_calc,
                                                    lis_con_actual,
                                                    lis_loc_actual,
                                                    lis_con_adjust,
                                                    lis_loc_adjust,
                                                    lis_adjust_comment,
                                                    lis_markup_adjust,
                                                    lis_number,
                                                    lis_entry_date,
                                                    lis_entry_oper,
                                                    -----Dev:Pure Finance:Start:{Hari Mandal]_[28/03/2013]--------
                                                    lis_lsl_number,
                                                    lis_pv_con_forecast,
                                                    lis_pv_loc_forecast,
                                                    lis_pv_con_inv_actual,
                                                    lis_pv_con_liab_actual,
                                                    lis_pv_loc_inv_actual,
                                                    lis_pv_loc_liab_actual,
                                                    lis_ed_loc_forecast,
                                                    lis_ed_loc_actual,
                                                    lis_con_unforseen_cost,
                                                    lis_loc_unforseen_cost, ------------Dev:Pure Finance:End-----------------------------------------------
                                                    lis_con_writeoff,
                                                    lis_loc_writeoff,
                                                    --added by sushma/swapnil to reverse the mg adjustment value for warner payment while cancel the license on 22-07-2015
                                                    lis_asset_adj_value,
                                                    LIS_MG_PV_CON_FORECAST,
                                                    LIS_MG_PV_LOC_FORECAST,
                                                    LIS_LOC_ASSET_ADJ_VALUE,
                                                    Lis_Mg_Pv_Con_Liab ,
                                                    LIS_MG_PV_LOC_LIAB,
                                                    --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/23]
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
                     VALUES (i.lis_lic_number,
                             i.lis_ter_code,
                             l_fim_year,
                             l_fim_month,
                             0,
                             0,
                             0,
                             0,
                             i.lis_con_forecast * -1,
                             -----Dev:Pure Finance:Start:{Hari Mandal]_[28/03/2013]--------
                             i.lis_loc_forecast * -1,
                             0,
                             0,
                             i.lis_con_actual * -1,
                             i.lis_loc_actual * -1,
                             0,
                             0,
                             'License Cancellation',
                             0,
                             seq_fid_license_sub_ledger.NEXTVAL,
                             SYSDATE,
                             i_entryoper,
                             i.lis_lsl_number,
                             i.lis_pv_con_forecast * -1,
                             i.lis_pv_loc_forecast * -1,
                             i.lis_pv_con_inv_actual * -1,
                             i.lis_pv_con_liab_actual * -1,
                             i.lis_pv_loc_inv_actual * -1,
                             i.lis_pv_loc_liab_actual * -1,
                             i.lis_ed_loc_forecast * -1,
                             i.lis_ed_loc_actual * -1,
                             i.lis_con_unforseen_cost * -1,
                             i.lis_loc_unforseen_cost * -1, ------------Dev:Pure Finance:End-----------------------------------------------
                             i.lis_con_writeoff * -1,
                             i.lis_loc_writeoff * -1,
                              --added by sushma/swapnil to reverse the mg adjustment value for warner payment while cancel the license on 22-07-2015
                             i.lis_mg_asset_value * -1,
                             i.LIS_MG_PV_CON_FORECAST * -1,
                             i.LIS_MG_PV_LOC_FORECAST * -1,
                             i.LIS_LOC_ASSET_ADJ_VALUE * -1,
                             i.Lis_Mg_Pv_Con_Liab * -1,
                             i.LIS_MG_PV_LOC_LIAB * -1,
                             --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/23]
                             'CL',
                             --Dev : Fin CR : End
                             --Finance Dev Phase I Zeshan [Start]
                             (SELECT lic_currency from fid_license where lic_number = i_licnumber),
                             (SELECT CON_COM_NUMBER FROM FID_LICENSE, FID_CONTRACT WHERE LIC_CON_NUMBER = CON_NUMBER AND LIC_NUMBER = i_licnumber),
                             i_licstatus,
                             'N',
                             0,
                             0
                             --Finance Dev Phase I [End]
                             );
                  EXCEPTION
                     WHEN DUP_VAL_ON_INDEX
                     THEN
                        UPDATE fid_license_sub_ledger
                           SET lis_con_forecast = i.lis_con_forecast * -1,
                               lis_loc_forecast = i.lis_loc_forecast * -1,
                               lis_con_actual = i.lis_con_actual * -1,
                               lis_loc_actual = i.lis_loc_actual * -1,
                               lis_pv_con_forecast =
                                  i.lis_pv_con_forecast * -1,
                               lis_pv_loc_forecast =
                                  i.lis_pv_loc_forecast * -1,
                               lis_pv_con_inv_actual =
                                  i.lis_pv_con_inv_actual * -1,
                               lis_pv_con_liab_actual =
                                  i.lis_pv_con_liab_actual * -1,
                               lis_pv_loc_inv_actual =
                                  i.lis_pv_loc_inv_actual * -1,
                               lis_pv_loc_liab_actual =
                                  i.lis_pv_loc_liab_actual * -1,
                               lis_ed_loc_forecast =
                                  i.lis_ed_loc_forecast * -1,
                               lis_ed_loc_actual = i.lis_ed_loc_actual * -1,
                               lis_con_unforseen_cost =
                                  i.lis_con_unforseen_cost * -1,
                               lis_loc_unforseen_cost =
                                  i.lis_loc_unforseen_cost * -1,
                               lis_con_writeoff = i.lis_con_writeoff * -1,
                               lis_loc_writeoff = i.lis_loc_writeoff * -1,
                               lis_adjust_comment = 'License Cancellation',
                            --added by sushma/swapnil to reverse the mg adjustment value for warner payment while cancel the license on 22-07-2015
                               lis_asset_adj_value =  i.lis_mg_asset_value * -1,
                               LIS_MG_PV_CON_FORECAST = i.LIS_MG_PV_CON_FORECAST * -1,
                               LIS_MG_PV_LOC_FORECAST = i.LIS_MG_PV_LOC_FORECAST * -1,
                               LIS_LOC_ASSET_ADJ_VALUE = i.LIS_LOC_ASSET_ADJ_VALUE * -1,
                               Lis_Mg_Pv_Con_Liab   = i.Lis_Mg_Pv_Con_Liab * -1,
                               LIS_MG_PV_LOC_LIAB  = i.LIS_MG_PV_LOC_LIAB * -1,
                               --Dev : Fin CR : Start : [Devashish Raverkar]_[2016/05/23]
                               lis_reval_flag = 'CL',
                               --Dev : Fin CR : End
                               --end
                               lis_entry_oper = i_entryoper,
                               --Finance Dev Phase I Zeshan [Start]
                               lis_lic_cur = (SELECT lic_currency from fid_license where lic_number = i_licnumber),
                               lis_lic_com_number = (SELECT CON_COM_NUMBER FROM FID_LICENSE, FID_CONTRACT WHERE LIC_CON_NUMBER = CON_NUMBER AND LIC_NUMBER = i_licnumber),
                               lis_lic_status = i_licstatus,
                               lis_pay_mov_flag = NVL(lis_pay_mov_flag,'N'),
                               lis_con_pay = NVL(lis_con_pay,0),
                               lis_loc_pay = NVL(lis_loc_pay,0)
                               --Finance Dev Phase I [End]
						WHERE     lis_per_month = l_fim_month
						AND lis_per_year = l_fim_year
						AND lis_ter_code = i.lis_ter_code
						AND lis_lsl_number = i.lis_lsl_number
						AND lis_lic_number = i.lis_lic_number;--i_licnumber;
                  END;
               END LOOP;
            END IF;
         END IF;

         ----- DEV3: SAP Implementation:Start:<24/7/2013>:<payment plan on cancellation of licenses>(scenario9,10,11)
         SELECT COUNT (*)
           INTO l_cnt
           FROM fid_payment
          WHERE pay_lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1)--i_licnumber
          AND pay_status = 'P';

         SELECT pkg_cm_username.setusername (i_entryoper)
           INTO l_number
           FROM DUAL;

         DELETE FROM fid_payment
               WHERE pay_lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1)--i_licnumber
               AND pay_status = 'N';

         IF l_cnt > 0
         THEN
            SELECT NVL (SUM (pay_amount), 0)
              INTO l_paid_amt
              FROM fid_payment
             WHERE pay_lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1)--i_licnumber
             AND pay_status = 'P';

            IF l_paid_amt <> 0
            THEN
               FOR pay
                  IN (SELECT pay_source_com_number,
                             pay_target_com_number,
                             pay_con_number,
                             pay_cur_code,
                             pay_code,
                             pay_amount,
                             pay_status,
                             pay_due,
                             pay_month_no,
                             pay_lsl_number
                        FROM fid_payment
                       WHERE pay_lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1)--i_licnumber
                       AND ROWNUM < 2)
               LOOP
                  BEGIN
                     INSERT INTO fid_payment (pay_number,
                                              pay_source_com_number,
                                              pay_target_com_number,
                                              pay_con_number,
                                              pay_lic_number,
                                              pay_status,
                                              pay_status_date,
                                              pay_amount,
                                              pay_cur_code,
                                              pay_rate,
                                              pay_code,
                                              pay_due,
                                              pay_reference,
                                              pay_comment,
                                              pay_supplier_invoice,
                                              pay_entry_date,
                                              pay_entry_oper,
                                              pay_month_no,
                                              pay_lsl_number,
                                              pay_original_payment,
                                              pay_payment_pct)
                          VALUES (
                                    seq_pay_number.NEXTVAL,
                                    pay.pay_source_com_number,
                                    pay.pay_target_com_number,
                                    pay.pay_con_number,
                                    X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1),--i_licnumber,
                                    'N',
                                    SYSDATE,
                                    -l_paid_amt,
                                    pay.pay_cur_code,
                                    NULL,
                                    'G',
                                    LAST_DAY (TRUNC (SYSDATE)),
                                    NULL,
                                    'Refund Required owing to Price Change on '
                                    || TO_CHAR (TRUNC (SYSDATE),
                                                'DD-Mon-RRRR'),
                                    NULL,
                                    SYSDATE,
                                    i_entryoper,
                                    pay.pay_month_no,
                                    pay.pay_lsl_number,
                                    'Y',
                                    NULL);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20601,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
               END LOOP;
            END IF;
         END IF;
      ----- DEV3: SAP Implementation:End:<24/7/2013>:-------------------------------------
       UPDATE fid_license
            SET
			    lic_status = UPPER (X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),2)),
                lic_price = DECODE (X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),2), 'C', 0, i_licprice),
                lic_comment = 'CANCELLED ON '||''''||to_char(i_cancel_date,'dd-Mon-rrrr hh:mi:ss')||''''||', ORIGINAL PRICE: '''||l_lic_price_old||' '||UPPER (X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),3)),
                lic_entry_oper = i_entryoper,
                lic_cancel_date = i_cancel_date,
				        lic_showing_lic = 0,
                lic_showing_int = 0,
                lic_update_count = decode(X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1), i_licnumber ,lic_update_count,lic_update_count +1)
           WHERE lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1)
           and  lic_update_count = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),4)
          ;

      l_rows_affected := sql%rowcount;

      if l_rows_affected = 0 then
          raise canclefailed;
      end if;

	   UPDATE x_fin_lic_sec_lee
       SET lsl_lee_price = 0
       WHERE lsl_lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1)
       AND X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),2) = 'C';
      END IF;
END LOOP;
--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
      OPEN get_licdate_status;

      FETCH get_licdate_status
      INTO l_licstart, l_licend, l_licperiodtba, l_licprice;

      IF    l_licstart != i_licstart
         OR l_licend != i_licend
         OR l_licperiodtba != i_licperiodtba
      THEN

         FOR lpy IN lpy_c
         LOOP
            v_endstarttbaupdated := 1;
            v_pay_month_no:= 0;
            l_pay_month_no_exists :=0;
        --Start :Onsite.Dev:BR_15_321 Update Month No for if LPY_PAY_ISLASTMONTH is true
          IF (NVL (upper(lpy.LPY_PAY_ISLASTMONTH), 'FALSE')<>'FALSE')
          THEN
	     v_pay_month_no := ROUND (MONTHS_BETWEEN (LAST_DAY (i_licend),
	                              ADD_MONTHS (LAST_DAY (i_licstart), -1) + 1));

          --Onsite.Dev:BR_15_321 check payments :LPY_PAY_ISLASTMONTH is true
           SELECT COUNT (1)
           INTO l_pay_month_no_exists
           FROM fid_license_payment_months
          WHERE lpy_lic_number = i_licnumber and NVL (upper(LPY_PAY_ISLASTMONTH), 'FALSE')<>'TRUE'
             and lpy_pay_month_no = v_pay_month_no;


            IF l_pay_month_no_exists > 0
            THEN
               raise_application_error (
                  -20016,
                  'Two payments fall in same month. Cannot update License Period.');
		  END IF;

          UPDATE fid_license_payment_months
               SET lpy_pay_month_no= v_pay_month_no,
                   lpy_entry_oper = i_entryoper,
                   lpy_entry_date = SYSDATE
             WHERE lpy_number = lpy.lpy_number;
          END IF;

          IF (v_pay_month_no=0)
          THEN
          v_pay_month_no:=lpy.lpy_pay_month_no;
          END IF;

         --End :Onsite.Dev:BR_15_321 Update Month No for if LPY_PAY_ISLASTMONTH is true


            calc_pay_month (i_split_region,
                            i_licstart,
                            i_licend,
                            NVL (i_licperiodtba, 'N'),
                            v_pay_month_no,
                            v_pay_month);


            UPDATE fid_license_payment_months
               SET lpy_pay_month = v_pay_month,
                   lpy_entry_oper = i_entryoper,
                   lpy_entry_date = SYSDATE
             WHERE lpy_number = lpy.lpy_number;

            FOR split_pay_month_loop
               IN (SELECT *
                     FROM SGY_LIC_SPLIT_PAYMENT
                    WHERE LSP_LPY_NUMBER = lpy.lpy_number)
            LOOP
               UPDATE SGY_LIC_SPLIT_PAYMENT
                  SET LSP_DUE_DATE =
                         ADD_MONTHS (
                            i_licstart,
                            split_pay_month_loop.LSP_SPLIT_MONTH_NUM - 1),
                      LSP_ENTRY_OPER = i_entryoper,
                      LSP_ENTRY_DATE = SYSDATE
                WHERE LSP_ID = split_pay_month_loop.lsp_id;
            END LOOP;
         END LOOP;

    --Warner_Payment :Rashmi Tijare :Updation for Month in Min Gurantee After lic_start Change :Start
           FOR lmg IN lmg_c
               LOOP

                  v_endstartmgupdated := 1;
                  /*Calculating date when inserted ew payment plan in grid */
             calc_pay_month (i_split_region,
                                  i_licstart,
                                  i_licend,
                                  NVL (i_licperiodtba, 'N'),
                                  lmg.MGP_PAY_MONTH_NO,
                                  v_pay_month);

              --added by sushma on 03-aug-2015
              --to check the entered pay month is fall in close or open month
              /*Select MGP_PAY_MONTH_NO into i_month_no
              from x_fin_mg_pay_plan
              where   MGP_LIC_NUMBER = i_licnumber
              And  MGP_NUMBER = lmg.MGP_NUMBER;*/

                /*SELECT TO_DATE ('01' || LPAD (fim_month, 2, 0) || fim_year,'DDMMYYYY')
                  INTO l_open_date
                 FROM fid_financial_month
                WHERE fim_status = 'O'
                      AND NVL (FIM_SPLIT_REGION, 1) =
                             DECODE (i_split_region, NULL, 1, i_split_region);*/

            /*v_add_month :=
                  TO_DATE (
                     '01-'
                     || TO_CHAR (ADD_MONTHS (i_licstart, lmg.MGP_PAY_MONTH_NO - 1),
                                 'MON-YYYY'),
                     'DD-MON-YYYY');*/

                       update x_fin_mg_pay_plan
                    SET MGP_PAY_MONTH = v_pay_month,
                        MGP_ENTRY_OPER =i_entryoper,
                        MGP_ENTRY_DATE= sysdate
                      Where MGP_NUMBER = lmg.MGP_NUMBER;

            /*IF v_add_month < l_open_date
               THEN
               Rollback;
                 raise_application_error (
                     -20018,
                     'Entered plan month is in close month.So plan can not be updated');
               ELSIF v_add_month > l_end
               THEN
                Rollback;
                 raise_application_error (
                     -20019,
                     'Entered plan month is in out of LED.So plan can not be updated');
               ELSE
                  SELECT COUNT (1)
                    INTO l_pay_month
                    FROM fid_license_payment_months
                   WHERE lpy_pay_month = v_add_month
                         AND lpy_lic_number = i_licnumber;*/

                    /*SELECT count(1)
                     into l_pay_mg_month
                       FROM x_fin_mg_pay_plan
                      WHERE MGP_PAY_MONTH = lmg.mgp_pay_month--v_pay_month
                            AND MGP_LIC_NUMBER = i_licnumber;*/

                  /*IF  l_pay_mg_month >1
                  THEN
                    Rollback;
                      raise_application_error (
                           -20601,
                           'Values captured in Payment Month and Minimum Guarantee Payment Month'|| CHR(10) || ' for '||l_title|| ' and lee '||l_lee_name|| ' must be unique');
                  END IF;*/

               --END IF;
                  END LOOP;

            --Below loop added by swapnil on 20-08-2015
           FOR lmg IN lmg_c
           LOOP
                SELECT COUNT (1)
                    INTO l_pay_month
                    FROM fid_license_payment_months
                   WHERE lpy_pay_month = lmg.mgp_pay_month
                         AND lpy_lic_number = i_licnumber;

                    SELECT count(1)
                     into l_pay_mg_month
                       FROM x_fin_mg_pay_plan
                      WHERE MGP_PAY_MONTH = lmg.mgp_pay_month--v_pay_month
                            AND MGP_LIC_NUMBER = i_licnumber;

                  IF (l_pay_month >= 1 and  l_pay_mg_month >=1) or l_pay_mg_month >1
                  THEN
                    Rollback;
                      raise_application_error (
                           -20601,
                           'Values captured in Payment Month and Minimum Guarantee Payment Month must be unique.');
                           --lmg.mgp_pay_month||'l_pay_month '||l_pay_month||' l_pay_mg_month'||l_pay_mg_month);
                  END IF;
           END LOOP;


            Commit;          --Warner_Payment :Rashmi Tijare :Updation for Month in Min Gurantee After lic_start Change :End
      END IF;




      IF l_licprice != i_licprice
      THEN
         UPDATE fid_license_ledger
            SET lil_price = DECODE (lil_rgh_code, 'X', 0, i_licprice)
          WHERE lil_lic_number = i_licnumber;
      END IF;



      /* PB (CR 6) :Pranay Kusumwal 18/07/2012 : Added for validation for Amort Exhibitions */
      SELECT NVL (lic_showing_lic, 0)
        INTO l_showing_lic
        FROM fid_license
       WHERE lic_number = i_licnumber;

      SELECT COUNT (*)
        INTO count_exh
        FROM fid_schedule
       WHERE TO_DATE (sch_per_year || sch_per_month, 'YYYYMM') IN
                (SELECT TO_DATE (fim_year || fim_month, 'YYYYMM')
                   FROM fid_financial_month
                  WHERE fim_status = 'C'
                        AND NVL (fim_split_region, 1) =
                               DECODE (fim_split_region,
                                       NULL, 1,
                                       i_split_region))
             AND sch_lic_number = i_licnumber
             AND sch_type = 'P';

      IF l_showing_lic <> i_licshowinglic
      THEN
         IF i_licshowinglic < count_exh
         THEN
            RAISE exh_exceed_failed;
         END IF;
      END IF;

      FOR i IN (SELECT lcr_cha_number
                  FROM fid_license_channel_runs
                 WHERE lcr_lic_number = i_licnumber)
      LOOP
         BEGIN
            SELECT COUNT (0)
              INTO l_cha_schedule_exits
              FROM fid_schedule
             WHERE sch_lic_number = i_licnumber
                   AND sch_cha_number = i.lcr_cha_number;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_cha_schedule_exits := 0;
         END;

         IF l_cha_schedule_exits > i_licmaxcha
         THEN
            ROLLBACK;
            o_status := '-1';

            SELECT cha_short_name
              INTO l_channel_name
              FROM fid_channel
             WHERE cha_number = i.lcr_cha_number;

            raise_application_error (
               -20366,
               'Max Cha cannot be less than scheduled runs on channel -'
               || l_channel_name);
         END IF;
      END LOOP;

      BEGIN
         SELECT COUNT (0)
           INTO l_tot_schedule_exits
           FROM fid_schedule
          WHERE sch_lic_number = i_licnumber;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_tot_schedule_exits := 0;
      END;

      IF l_tot_schedule_exits > i_licmaxchs
      THEN
         ROLLBACK;
         o_status := '-1';
         raise_application_error (
            -20366,
            'Max Chs cannot be less than total scheduled runs');
      END IF;

      /* PB (CR 6) :Pranay Kusumwal 18/07/2012 :end */
      /* start nasreen*/
      SELECT COUNT (*)
        INTO licensee_code_count
        FROM fid_licensee, fid_license
       WHERE lee_number = lic_lee_number AND lic_number = i_licnumber
             AND NVL (lee_media_service_code, 'N') IN
                    (SELECT MS_MEDIA_SERVICE_CODE
                       FROM sgy_pb_media_service
                      WHERE MS_MEDIA_SERVICE_code NOT IN ('PAYTV', 'TVOD'));

      /* Anirudha Kulkarni : CP R1   */
      IF licensee_code_count > 0            --l_lic_catchup_flag in ( 'Y','S')
      THEN
         /* end nasreen*/
         --CATCHUP:CACQ14: Start_[SHANTANU A.]_[18-nov-2014]
         --New package which check all the validations for catchup licenses.
         --19/03/15 for SVOD added 'S'
         x_pkg_cp_lic_updte_validation.x_prc_cp_bef_upd_validation (
            i_licnumber,
            i_licshowingint,
            i_sch_aft_prem_linear,
            i_sch_x_days_bef_linr,
            i_sch_x_days_bef_linr_val,
            o_sch_present);
         --CATCHUP:CACQ14:[END]
         x_pkg_cp_license_upd_validate.prc_cp_lic_before_upd_valid (
            i_licnumber,
            i_licstart,
            i_licend,
            i_licchsnumber,
            i_licstatus,
            i_max_vp_in_days,
            i_sch_aft_prem_linear,
            i_non_cons_month,
            i_licprice,
            i_licshowingint,
            i_licshowinglic,
            i_licamortcode,
            NVL (i_licperiodtba, 'N'),
            i_entryoper);
      END IF;

      o_sch_lic_present_past := o_sch_present;

      /* end */
      SELECT lic_max_viewing_period, lic_cp_tba_sch_flg
        INTO l_lic_max_viewing_period, l_lic_cp_tba_sch_flg
        FROM fid_license
       WHERE lic_number = i_licnumber;

      -------------------Dev:Pure Finance:Start:[ADITYA GUPTA]_[8/05/2013]------------------------------------------------------
      SELECT lic_status
        INTO l_lic_status
        FROM fid_license
       WHERE lic_number = i_licnumber;

      IF ( (l_lic_status = 'F') AND (UPPER (i_licstatus) <> 'F')
          OR (l_lic_status <> 'F') AND (UPPER (i_licstatus) = 'F'))
      THEN
         raise_application_error (
            -20100,
            ' Updation Not Allowed in the License Status ');
      END IF;

      -------------------Dev:Pure Finance:End:[ADITYA GUPTA]_[8/05/2013]------------------------------------------------------

      ----------------Dev2: Pure Finance:Start:[Nishant Ankam]_[26/06/2013]------------------------------------------------------------
      SELECT lic_lee_number
        INTO l_prev_lee_number
        FROM fid_license
       WHERE lic_number = i_licnumber;

      SELECT lic_catchup_flag
        INTO is_catchup_flag
        FROM fid_license
       WHERE lic_number = i_licnumber;

      IF ( (l_prev_lee_number <> i_licleenumber) AND licensee_code_count > 0) --NVL (is_catchup_flag, 'N') not in ( 'Y','S'))
      --19/03/15 for SVOD added 'S'
      THEN
        -- DBMS_OUTPUT.put_line ('in condition');

         BEGIN
            SELECT COUNT (*)
              INTO l_sec_lee_count
              FROM x_fin_lic_sec_lee
             WHERE lsl_lic_number = i_licnumber;

            IF l_sec_lee_count > 1
            THEN
               SELECT lee_split_region, lee_cha_com_number
                 INTO l_prev_lic_region, l_prev_lic_cha_comp
                 FROM fid_licensee
                WHERE lee_number = l_prev_lee_number;

             --  DBMS_OUTPUT.put_line ('Prev values');
             --  DBMS_OUTPUT.put_line (l_prev_lic_region);
              -- DBMS_OUTPUT.put_line (l_prev_lic_cha_comp);

               SELECT lee_split_region, lee_cha_com_number
                 INTO l_new_lic_region, l_new_lic_cha_comp
                 FROM fid_licensee
                WHERE lee_number = i_licleenumber;

             --  DBMS_OUTPUT.put_line ('New values');
             --  DBMS_OUTPUT.put_line (l_new_lic_region);
            --   DBMS_OUTPUT.put_line (l_new_lic_cha_comp);

               IF ( (l_prev_lic_region <> l_new_lic_region)
                   OR (l_prev_lic_cha_comp <> l_new_lic_cha_comp))
               THEN
                  raise_application_error (
                     -20100,
                     'Licensee does not belong to same channel company and/or region');
               END IF;

               SELECT COUNT (*)
                 INTO l_not_in_count
                 FROM x_fin_lic_sec_lee
                WHERE lsl_lic_number = i_licnumber
                      AND lsl_lee_number = i_licleenumber;

               IF (l_not_in_count > 0)
               THEN
                  raise_application_error (
                     -20100,
                     'Licensee already belongs to primary licensee');
               END IF;
            END IF;
         END;
      END IF;

      ------ DEV3: SAP Implementation:Start:<24/7/2013>:<payment plan changes for catchup licenses>-------
      SELECT lic_price
        INTO l_lic_price
        FROM fid_license
       WHERE lic_number = i_licnumber;

      IF i_licleenumber IN (467, 468) AND i_licprice <> l_lic_price
      THEN
         SELECT lsl_number
           INTO l_lsl_number
           FROM x_fin_lic_sec_lee
          WHERE lsl_lic_number = i_licnumber;

         ------PAYMENT PLAN CHANGE PROCEDURE IMPLEMENTATION-------------------------------
         BEGIN
            x_prc_lic_price_change (i_licnumber,
                                    l_lsl_number,
                                    i_licleenumber,
                                    l_lic_price,
                                    i_licprice,
                                    i_entryoper,
                                    i_trnsfr_pmnt_flag);
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (
                  -20555,
                  'Error in price change' || SUBSTR (SQLERRM, 1, 200));
         END;
      END IF;

      ------------END PROCEDURE IMPLEMENTATION--------------------------------------------
      /*  IF l_lic_price = 0
        THEN
           SELECT mem_agy_com_number, mem_com_number
             INTO l_mem_agy_com_number, l_mem_com_number
             FROM sak_memo
            WHERE mem_id IN (SELECT lic_mem_number
                               FROM fid_license
                              WHERE lic_number = i_licnumber);

           SELECT lic_con_number, lic_currency
             INTO l_con_number, l_lic_currency
             FROM fid_license
            WHERE lic_number = i_licnumber;

           SELECT lee_cha_com_number
             INTO sourcecom
             FROM fid_licensee
            WHERE lee_number = i_licleenumber;

           SELECT com_type
             INTO contentstatus
             FROM fid_company
            WHERE com_number = l_mem_agy_com_number;

           IF NVL (contentstatus, 'CC') = 'BC'
           THEN
              targetcom := l_mem_agy_com_number;
           ELSE
              targetcom := l_mem_com_number;
           END IF;

           INSERT INTO fid_payment
                       (pay_number, pay_source_com_number,
                        pay_target_com_number, pay_con_number,
                        pay_lic_number, pay_status, pay_status_date,
                        pay_amount, pay_cur_code, pay_rate, pay_code,
                        pay_due, pay_reference, pay_comment,
                        pay_supplier_invoice, pay_entry_date,
                        pay_entry_oper, pay_month_no, pay_lsl_number,
                        pay_original_payment, pay_payment_pct
                       )
                VALUES (seq_pay_number.NEXTVAL, sourcecom,
                        targetcom, l_con_number,
                        i_licnumber, 'N', SYSDATE,
                        i_licprice, l_lic_currency, NULL, 'G',
                        TRUNC (SYSDATE), NULL, NULL,
                        NULL, SYSDATE,
                        i_entryoper, NULL, l_lsl_number,
                        'Y', 100
                       );
        ELSIF i_licprice = 0
        THEN
           SELECT COUNT (*)
             INTO l_cnt
             FROM fid_payment
            WHERE pay_lsl_number = l_lsl_number AND pay_status = 'P';

           SELECT pkg_cm_username.setusername (i_entryoper)
             INTO l_number
             FROM DUAL;

           DELETE FROM fid_payment
                 WHERE pay_lsl_number = l_lsl_number AND pay_status = 'N';

           IF l_cnt > 0
           THEN
              SELECT NVL (SUM (pay_amount), 0)
                INTO l_paid_amt
                FROM fid_payment
               WHERE pay_lsl_number = l_lsl_number AND pay_status = 'P';

              FOR pay IN (SELECT pay_source_com_number,
                                 pay_target_com_number, pay_con_number,
                                 pay_cur_code, pay_code, pay_amount,
                                 pay_status, pay_due, pay_month_no,
                                 pay_lsl_number
                            FROM fid_payment
                           WHERE pay_lsl_number = l_lsl_number AND ROWNUM < 2)
              LOOP
                 BEGIN
                    INSERT INTO fid_payment
                                (pay_number,
                                 pay_source_com_number,
                                 pay_target_com_number,
                                 pay_con_number, pay_lic_number,
                                 pay_status, pay_status_date, pay_amount,
                                 pay_cur_code, pay_rate, pay_code,
                                 pay_due, pay_reference,
                                 pay_comment,
                                 pay_supplier_invoice, pay_entry_date,
                                 pay_entry_oper, pay_month_no,
                                 pay_lsl_number, pay_original_payment,
                                 pay_payment_pct
                                )
                         VALUES (seq_pay_number.NEXTVAL,
                                 pay.pay_source_com_number,
                                 pay.pay_target_com_number,
                                 pay.pay_con_number, i_licnumber,
                                 'N', SYSDATE, -l_paid_amt,
                                 pay.pay_cur_code, NULL, pay.pay_code,
                                 LAST_DAY (TRUNC (SYSDATE)), NULL,
                                    'Refund Required owing to Price Change on '
                                 || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                 NULL, SYSDATE,
                                 i_entryoper, pay.pay_month_no,
                                 pay.pay_lsl_number, 'Y',
                                 NULL
                                );
                 EXCEPTION
                    WHEN OTHERS
                    THEN
                       raise_application_error (-20601,
                                                SUBSTR (SQLERRM, 1, 200)
                                               );
                 END;
              END LOOP;
           END IF;
        ELSIF i_licprice > l_lic_price
        THEN
           ----for all paid payment
           SELECT COUNT (*)
             INTO l_count
             FROM fid_payment
            WHERE pay_lic_number = i_licnumber
              AND pay_lsl_number = l_lsl_number
              AND pay_status = 'N';

           IF l_count = 0
           THEN
              l_flag1 := 'paid';
           END IF;

           SELECT COUNT (*)
             INTO l_count1
             FROM fid_payment
            WHERE pay_lic_number = i_licnumber
              AND pay_lsl_number = l_lsl_number
              AND pay_status = 'P';

           IF l_count1 = 0
           THEN
              l_flag1 := 'notpaid';
           END IF;

           IF l_flag1 = 'paid'             ---for all paid payment(scenario3)
           THEN
              FOR pay IN (SELECT pay_source_com_number,
                                 pay_target_com_number, pay_con_number,
                                 pay_cur_code, pay_code, pay_amount,
                                 pay_status, pay_due, pay_month_no,
                                 pay_lsl_number
                            FROM fid_payment
                           WHERE pay_lsl_number = l_lsl_number
                                 AND ROWNUM < 2)
              LOOP
                 BEGIN
                    INSERT INTO fid_payment
                                (pay_number,
                                 pay_source_com_number,
                                 pay_target_com_number,
                                 pay_con_number, pay_lic_number,
                                 pay_status, pay_status_date, pay_amount,
                                 pay_cur_code, pay_rate, pay_code,
                                 pay_due, pay_reference,
                                 pay_comment,
                                 pay_supplier_invoice, pay_entry_date,
                                 pay_entry_oper, pay_month_no,
                                 pay_lsl_number, pay_original_payment,
                                 pay_payment_pct
                                )
                         VALUES (seq_pay_number.NEXTVAL,
                                 pay.pay_source_com_number,
                                 pay.pay_target_com_number,
                                 pay.pay_con_number, i_licnumber,
                                 'N', SYSDATE, (i_licprice - l_lic_price),
                                 pay.pay_cur_code, NULL, pay.pay_code,
                                 LAST_DAY (TRUNC (SYSDATE)), NULL,
                                    'Additional Payment owing to Price Change on '
                                 || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                 NULL, SYSDATE,
                                 i_entryoper, pay.pay_month_no,
                                 pay.pay_lsl_number, 'Y',
                                 NULL
                                );
                 EXCEPTION
                    WHEN OTHERS
                    THEN
                       raise_application_error (-20601,
                                                SUBSTR (SQLERRM, 1, 200)
                                               );
                 END;
              END LOOP;
           ELSIF l_flag1 = 'notpaid'       ---for all paid payment(scenario4)
           THEN
              SELECT SUM (pay_amount)
                INTO l_notpaid_amt1
                FROM fid_payment
               WHERE pay_lsl_number = l_lsl_number;

              FOR pay IN (SELECT pay_number, pay_amount
                            FROM fid_payment
                           WHERE pay_lsl_number = l_lsl_number)
              LOOP
                 UPDATE fid_payment
                    SET pay_amount =
                           ROUND (  i_licprice
                                  * (pay.pay_amount / l_notpaid_amt1),
                                  2
                                 ),
                        pay_comment =
                              'Updated Payment owing to Price Change on '
                           || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR')
                  WHERE pay_number = pay.pay_number;
              END LOOP;
           ELSE                                ---for scenario1 and scenario2
              SELECT SUM (pay_amount)
                INTO l_paid_amt
                FROM fid_payment
               WHERE pay_lsl_number = l_lsl_number AND pay_status = 'P';

              SELECT SUM (pay_amount)
                INTO l_notpaid_amt1
                FROM fid_payment
               WHERE pay_lsl_number = l_lsl_number AND pay_status = 'N';

              FOR pay IN (SELECT pay_number, pay_amount
                            FROM fid_payment
                           WHERE pay_lsl_number = l_lsl_number
                             AND pay_status = 'N')
              LOOP
                 UPDATE fid_payment
                    SET pay_amount =
                           ROUND (  i_licprice
                                  * (  pay.pay_amount
                                     / (l_paid_amt + l_notpaid_amt1)
                                    ),
                                  2
                                 ),
                        pay_comment =
                              'Updated Payment owing to Price Change on '
                           || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR')
                  WHERE pay_number = pay.pay_number;
              END LOOP;

              SELECT SUM (pay_amount)
                INTO l_notpaid_amt
                FROM fid_payment
               WHERE pay_lsl_number = l_lsl_number AND pay_status = 'N';

              l_remain_amt := i_licprice - (l_paid_amt + l_notpaid_amt);

              FOR pay IN (SELECT pay_source_com_number,
                                 pay_target_com_number, pay_con_number,
                                 pay_cur_code, pay_code, pay_amount,
                                 pay_status, pay_due, pay_month_no,
                                 pay_lsl_number
                            FROM fid_payment
                           WHERE pay_lsl_number = l_lsl_number AND ROWNUM < 2)
              LOOP
                 BEGIN
                    INSERT INTO fid_payment
                                (pay_number,
                                 pay_source_com_number,
                                 pay_target_com_number,
                                 pay_con_number, pay_lic_number,
                                 pay_status, pay_status_date, pay_amount,
                                 pay_cur_code, pay_rate, pay_code,
                                 pay_due, pay_reference,
                                 pay_comment,
                                 pay_supplier_invoice, pay_entry_date,
                                 pay_entry_oper, pay_month_no,
                                 pay_lsl_number, pay_original_payment,
                                 pay_payment_pct
                                )
                         VALUES (seq_pay_number.NEXTVAL,
                                 pay.pay_source_com_number,
                                 pay.pay_target_com_number,
                                 pay.pay_con_number, i_licnumber,
                                 'N', SYSDATE, l_remain_amt,
                                 pay.pay_cur_code, NULL, pay.pay_code,
                                 LAST_DAY (TRUNC (SYSDATE)), NULL,
                                    'Additional Payment owing to Price Change on '
                                 || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                 NULL, SYSDATE,
                                 i_entryoper, pay.pay_month_no,
                                 pay.pay_lsl_number, 'Y',
                                 NULL
                                );
                 EXCEPTION
                    WHEN OTHERS
                    THEN
                       raise_application_error (-20601,
                                                SUBSTR (SQLERRM, 1, 200)
                                               );
                 END;
              END LOOP;
           END IF;
        ELSE
           ------for licensee allocation less than already allocated
           --  if i_licprice < l_lic_price
           -- then
           ----for all paid payment
           SELECT COUNT (*)
             INTO l_count
             FROM fid_payment
            WHERE pay_lic_number = i_licnumber
              AND pay_lsl_number = l_lsl_number
              AND pay_status = 'N';

           IF l_count = 0
           THEN
              l_flag1 := 'paid';
           END IF;

           SELECT COUNT (*)
             INTO l_count1
             FROM fid_payment
            WHERE pay_lic_number = i_licnumber
              AND pay_lsl_number = l_lsl_number
              AND pay_status = 'P';

           IF l_count1 = 0
           THEN
              l_flag1 := 'notpaid';
           END IF;

           IF l_flag1 = 'paid'            ----for all paid payment(scenario7)
           THEN
              FOR pay IN (SELECT pay_source_com_number,
                                 pay_target_com_number, pay_con_number,
                                 pay_cur_code, pay_code, pay_amount,
                                 pay_status, pay_due, pay_month_no,
                                 pay_lsl_number
                            FROM fid_payment
                           WHERE pay_lsl_number = l_lsl_number
                                 AND ROWNUM < 2)
              LOOP
                 BEGIN
                    INSERT INTO fid_payment
                                (pay_number,
                                 pay_source_com_number,
                                 pay_target_com_number,
                                 pay_con_number, pay_lic_number,
                                 pay_status, pay_status_date, pay_amount,
                                 pay_cur_code, pay_rate, pay_code,
                                 pay_due, pay_reference,
                                 pay_comment,
                                 pay_supplier_invoice, pay_entry_date,
                                 pay_entry_oper, pay_month_no,
                                 pay_lsl_number, pay_original_payment,
                                 pay_payment_pct
                                )
                         VALUES (seq_pay_number.NEXTVAL,
                                 pay.pay_source_com_number,
                                 pay.pay_target_com_number,
                                 pay.pay_con_number, i_licnumber,
                                 'N', SYSDATE, (i_licprice - l_lic_price),
                                 pay.pay_cur_code, NULL, pay.pay_code,
                                 LAST_DAY (TRUNC (SYSDATE)), NULL,
                                    'Refund Required owing to Price Change on '
                                 || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                 NULL, SYSDATE,
                                 i_entryoper, pay.pay_month_no,
                                 pay.pay_lsl_number, 'Y',
                                 NULL
                                );
                 EXCEPTION
                    WHEN OTHERS
                    THEN
                       raise_application_error (-20601,
                                                SUBSTR (SQLERRM, 1, 200)
                                               );
                 END;
              END LOOP;
           ELSIF l_flag1 = 'notpaid'  ----for all not paid payment(scenario8)
           THEN
              SELECT SUM (pay_amount)
                INTO l_notpaid_amt
                FROM fid_payment
               WHERE pay_lsl_number = l_lsl_number;

              FOR pay IN (SELECT pay_number, pay_amount
                            FROM fid_payment
                           WHERE pay_lsl_number = l_lsl_number)
              LOOP
                 UPDATE fid_payment
                    SET pay_amount =
                           ROUND (  i_licprice
                                  * (pay.pay_amount / l_notpaid_amt),
                                  2
                                 ),
                        pay_comment =
                              'Updated Payment owing to Price Change on '
                           || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR')
                  WHERE pay_number = pay.pay_number;
              END LOOP;
           ELSE                                ---for scenario5 and scenario6
              SELECT SUM (pay_amount)
                INTO l_paid_amt
                FROM fid_payment
               WHERE pay_lsl_number = l_lsl_number AND pay_status = 'P';

              l_remain_amt := i_licprice - l_paid_amt;

              ----------------when new price is less than total paid price
              IF l_remain_amt < 0
              THEN
                 SELECT pkg_cm_username.setusername (i_entryoper)
                   INTO l_number
                   FROM DUAL;

                 DELETE FROM fid_payment
                       WHERE pay_lsl_number = l_lsl_number
                         AND pay_status = 'N';

                 FOR pay IN (SELECT pay_source_com_number,
                                    pay_target_com_number, pay_con_number,
                                    pay_cur_code, pay_code, pay_amount,
                                    pay_status, pay_due, pay_month_no,
                                    pay_lsl_number
                               FROM fid_payment
                              WHERE pay_lsl_number = l_lsl_number
                                AND ROWNUM < 2)
                 LOOP
                    INSERT INTO fid_payment
                                (pay_number,
                                 pay_source_com_number,
                                 pay_target_com_number,
                                 pay_con_number, pay_lic_number,
                                 pay_status, pay_status_date, pay_amount,
                                 pay_cur_code, pay_rate, pay_code,
                                 pay_due, pay_reference,
                                 pay_comment,
                                 pay_supplier_invoice, pay_entry_date,
                                 pay_entry_oper, pay_month_no,
                                 pay_lsl_number, pay_original_payment,
                                 pay_payment_pct
                                )
                         VALUES (seq_pay_number.NEXTVAL,
                                 pay.pay_source_com_number,
                                 pay.pay_target_com_number,
                                 pay.pay_con_number, i_licnumber,
                                 'N', SYSDATE, l_remain_amt,
                                 pay.pay_cur_code, NULL, pay.pay_code,
                                 LAST_DAY (TRUNC (SYSDATE)), NULL,
                                    'Refund Required owing to Price Change on '
                                 || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                 NULL, SYSDATE,
                                 i_entryoper, pay.pay_month_no,
                                 pay.pay_lsl_number, 'Y',
                                 NULL
                                );
                 END LOOP;
              ELSE
                 ---------------when new price is greater than than total paid price
                 SELECT SUM (pay_amount)
                   INTO l_notpaid_amt
                   FROM fid_payment
                  WHERE pay_lsl_number = l_lsl_number AND pay_status = 'N';

                 FOR pay IN (SELECT pay_number, pay_amount
                               FROM fid_payment
                              WHERE pay_lsl_number = l_lsl_number
                                AND pay_status = 'N')
                 LOOP
                    UPDATE fid_payment
                       SET pay_amount =
                              ROUND (  l_remain_amt
                                     * (pay.pay_amount / l_notpaid_amt),
                                     2
                                    ),
                           pay_comment =
                                 'Updated Payment owing to Price Change on '
                              || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR')
                     WHERE pay_number = pay.pay_number;
                 END LOOP;
              END IF;
           END IF;
        END IF;

        -----rounding off payment up to 2 decimal-------------------------
        SELECT SUM (pay_amount)
          INTO l_total_pay_price
          FROM fid_payment
         WHERE pay_lic_number = i_licnumber AND pay_lsl_number = l_lsl_number;

        l_extra_pay_amt := l_total_pay_price - i_licprice;

        IF l_extra_pay_amt <> 0
        THEN
           SELECT MIN (pay_number)
             INTO l_pay_number
             FROM fid_payment
            WHERE pay_lic_number = i_licnumber
              AND pay_lsl_number = l_lsl_number
              AND pay_status = 'N';

           UPDATE fid_payment
              SET pay_amount = pay_amount - l_extra_pay_amt
            WHERE pay_number = l_pay_number;
        END IF;
     -------end rounding off------------------------------------------
     END IF;*/

      ----------------------- PB CR Mrunmayi --------------------
      IF l_lic_status = 'A'
      THEN
         SELECT lic_gen_refno
           INTO l_gen_refno
           FROM fid_license
          WHERE lic_number = i_licnumber;

         UPDATE fid_general
            SET gen_bo_category_code = i_bo_category
          WHERE gen_refno = l_gen_refno;
      END IF;

      -----------END ---------------------------------------------

      -- Dev8: RDT :Start:[License On Hold]_[Deepak]_[27-Aug-2013]
      --Check if licence is schedule in future
      SELECT COUNT (sch_number)
        INTO l_future_sch_count
        FROM fid_schedule
       WHERE     sch_lic_number = i_licnumber
             AND sch_date >= SYSDATE
             AND i_onhold = 'Y';

  --warner PAyment start :Rashmi Tijare

     select lic_min_subs_flag
     into l_subs_flag
     from fid_license
     where lic_number = i_licnumber;
  --warner End
      -- Dev8: RDT :End:[License On Hold]_[Deepak]_[27-Aug-2013]
      IF (NVL (l_future_sch_count, 0) <= 0)
      THEN
         ------ DEV3: SAP Implementation:End:<24/7/2013>-----------------------------
         -------Dev2:Pure Finance:End:[Nishant Ankam]_[26/06/2013]-----------------------------------------------------------------
         UPDATE fid_license
            SET lic_lee_number = i_licleenumber,
                lic_chs_number = i_licchsnumber,
                lic_external_ref = i_licexternalref,
                lic_status = UPPER (i_licstatus),
                lic_start = i_licstart,
                lic_end = i_licend,
                lic_period_tba = UPPER (i_licperiodtba),
                lic_price_code = i_licpricecode,
                lic_budget_code = UPPER (i_licbudgetcode),
                lic_price = DECODE (i_licstatus, 'C', 0, i_licprice),
                lic_rate = i_lic_rate,
                lic_markup_percent = i_licmarkuppercent,
                lic_showing_int = i_licshowingint,
                lic_showing_lic = i_licshowinglic,
                lic_amort_code = UPPER (i_licamortcode),
                lic_max_chs = i_licmaxchs,
                lic_max_cha = i_licmaxcha,
                lic_exclusive = UPPER (i_licexclusive),
                --lic_min_subscriber = i_licminsubscriber,
                --lic_min_guarantee = i_licminguarantee,
                lic_comment = UPPER (i_liccomment),
                --lic_update_count = NVL (lic_update_count, 0) + 1,
                lic_entry_oper = i_entryoper,
                -- Project Bioscope : Ajit_20120316 : premium and Time Shift Flag added
                lic_premium_flag = i_premier,
                -- Dev8: RDT :Start:[License On Hold]_[Deepak]_[27-Aug-2013]
                lic_on_hold_flag = i_onhold,
                ----DEV.RDT: PHOENIX REQUIREMENT: START:Phoenix_04_Marking_License_as_Feed_NEERAJ_2014/03/21]
                lic_feed_flag = i_licfeed,
                ----DEV.RDT: PHOENIX REQUIREMENT: END------------------------
                lic_time_shift_cha_flag = i_timeshiftchannel,
                /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
                lic_simulcast_cha_flag = i_simulcastchannel,
                /* PB (CR 12) : END */
                -- Project Bioscope : Ajit_20120316 : End
                -- Catch Up R1 mrunmayi kusurkar
                lic_max_viewing_period = i_max_vp_in_days,
                lic_sch_aft_prem_linear = i_sch_aft_prem_linear,
                --CATCHUP : CACQ:14 update value of new validation parameters for catchup license [SHANTANU A.]_[08-oct-2014]
                lic_sch_bef_x_day = i_sch_x_days_bef_linr,
                lic_sch_bef_x_day_value = i_sch_x_days_bef_linr_val,
                lic_sch_without_lin_ref = i_sch_without_linr_ref,
                --CATCHUP : CACQ:14 update value of new validation parameters for catchup license [SHANTANU A.]_[END]
                lic_non_cons_month = i_non_cons_month,
                -------------Dev2:Pure Finance:Start:[Hari Mandal]_[28/03/2013]:added for cancellation date--------------
                lic_cancel_date =
                   DECODE (l_lic_licstatus, 'C', i_cancel_date, NULL),
                -------------Dev2:Pure Finance:End------------------------------------------------------------------------
                -- end

                -------------Dev2:Pure Finance/AfricaFreeRepeats:Start:[Nishant Ankam]_[28/03/2013]:added fields for free repeats--------------
                lic_free_rpt = i_nooffreereps,
                lic_rpt_period = i_repperiod,
                -------------Dev2:Pure Finance/AfricaFreeRepeats:Start:[Nishant Ankam]_[28/03/2013]:added fields for free repeats--------------
                /* WHERE     NVL (lic_update_count, 0) = i_licupdatecount
                       AND lic_number = i_licnumber
                 RETURNING NVL (lic_update_count, 0)
                      INTO l_flag; */

                ---Warner Payment Start ---
                LIC_MIN_GUARANTEE_FLAG = i_min_gurantee_lic,
                lic_min_subs_flag = i_min_gurantee_sub          ----13-07-2015
          ---Warner Payment End ---
          WHERE lic_number = i_licnumber;


         --Warner Payment Start :Rashmi Tijare

    IF  l_subs_flag = 'N'
       THEN
         UPDATE fid_license
         SET lic_min_subscriber = i_licminsubscriber,
         lic_min_guarantee = i_licminguarantee
         WHERE lic_number = i_licnumber;
    Else
           UPDATE fid_license
            SET lic_min_subscriber = 0, lic_min_guarantee = 0
            WHERE lic_number = i_licnumber;
     End if;


--Warner End
         SELECT NVL (lee_bioscope_flag, '#')
           INTO l_lee_bioscope_flag
           FROM fid_licensee
          WHERE lee_number = (SELECT lic_lee_number
                                FROM fid_license
                               WHERE lic_number = i_licnumber);

         SELECT NVL (lic_budget_code, 'x'), NVL (lic_amort_code, 'y')
           INTO l_gen_type, l_lic_amort
           FROM fid_license
          WHERE lic_number = i_licnumber;

         /* IF     l_lee_bioscope_flag = 'Y'
             AND l_gen_type IN ('FEA', 'TV', 'LIB')
             AND l_lic_amort = 'D'
          THEN*/
         IF l_old_lic_start <> i_licstart OR i_licend <> l_old_lic_end
         THEN
            UPDATE fid_license_channel_runs
               SET LCR_SCH_START_DATE = i_licstart,
                   LCR_SCH_END_DATE = i_licend,
                   LCR_SCH_START_DATE2 = NULL,
                   LCR_SCH_END_DATE2 = NULL
             WHERE lcr_lic_number = i_licnumber;
         --END IF;
         END IF;

         --------------------RDT Audit Changes by Abhijt Deshpande---------------------
         SELECT lic_update_count
           INTO o_status
           FROM fid_license
          WHERE lic_number = i_licnumber;

         IF NVL (i_licupdatecount, 0) = NVL (o_status, 0)
         THEN
            UPDATE fid_license
               SET lic_update_count = NVL (lic_update_count, 0) + 1
             WHERE lic_number = i_licnumber;

            --COMMIT;

            SELECT lic_update_count -----take latest update count after commit
              INTO o_status
              FROM fid_license
             WHERE lic_number = i_licnumber;
         ELSE
            raise_application_error (
               -20001,
                  'The License details for License - '
               || i_licnumber
               || ' is already modified by another user.');
         END IF;
      --------------Changed End(Abhijit)--------------------------
      ELSE
         raise_application_error (
            -20100,
            'License cannot be put on hold as it is scheduled in future.
              Kindly remove the future schedules and try again.');
      END IF;

      ------Dev8:RDT:END:{DEEPAK]_[27/08/2013]


      UPDATE x_fin_lic_sec_lee
         SET lsl_lee_price = 0
       WHERE lsl_lic_number = i_licnumber AND i_licstatus = 'C';

      /* Anirudha Kulkarni : Catch UP R1 31-oct-2012  */
      IF i_licstart != l_lic_start AND i_licend != l_lic_end
      THEN
         l_changed_date_flag := 'BOTH';
      ELSIF i_licstart != l_lic_start
      THEN
         l_changed_date_flag := 'START';
      ELSIF i_licend != l_lic_end
      THEN
         l_changed_date_flag := 'END';
      END IF;

      IF l_lic_max_viewing_period <> i_max_vp_in_days
         AND l_lic_cp_tba_sch_flg = 'Y'
      THEN
         x_pkg_cp_license_upd_validate.prc_cp_lic_change_vp_days (
            i_licnumber,
            i_max_vp_in_days,
            i_licstart,
            i_licend);
      END IF;

      BEGIN
        SELECT lee_media_service_code
          INTO l_media_service_code
          FROM fid_licensee,
               fid_license
         WHERE lic_lee_number = lee_number
           AND lic_number = i_licnumber;
      END;

      IF l_media_service_code <> 'TVOD'
      THEN
        x_pkg_cp_license_upd_validate.prc_cp_lic_after_upd_valid (
           i_licnumber,
           NVL (i_licperiodtba, 'N'),
           i_licstart,
           l_changed_date_flag,
           i_entryoper);
      END IF;
      /* end */


      x_pkg_cp_license_upd_validate.prc_cp_lic_after_upd_valid (
         i_licnumber,
         NVL (i_licperiodtba, 'N'),
         i_licstart,
         l_changed_date_flag,
         i_entryoper);

      --IF (l_flag > 0)
      IF (o_status > 0)
      THEN
         --Dev2: Costing 5+2 Rules :Aditya Gupta_20140430 : Calling fid_payment transactions for final commit
         IF (i_trnsfr_pmnt_flag = 'Y')
         THEN
            x_prc_alic_cm_trnsfr_pmt_ins (i_entryoper, l_status_ins);
            x_prc_alic_cm_trnsfr_pmt_del (i_entryoper, l_status_del);
         END IF;

         IF (l_status_ins = 1 AND l_status_del = 1)
         THEN
            BEGIN
               SELECT FPT_PAY_LIC_NUMBER
                 INTO l_dst_lic
                 FROM X_GTT_FID_PAYMENT_TEMP
                WHERE     FPT_OPER_FLAG = 'I'
                      AND FPT_PAY_AMOUNT > 0
                      AND ROWNUM < 2;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_dst_lic := 0;
            END;

            IF l_dst_lic <> 0
            THEN
               COMMIT;

               FOR i
                  IN (SELECT lsl_number, lsl_lee_price, lsl_lee_number
                        FROM x_fin_lic_sec_lee
                       WHERE lsl_lic_number = i_licnumber
                             AND lsl_is_primary = 'N')
               LOOP
                  IF i.lsl_lee_price <> 0
                  THEN
                     IF licensee_code_count > 0 --l_lic_catchup_flag in ( 'Y','S')
                     THEN
                        --19/03/15 for SVOD added 'S'
                        SELECT SUM (fpt_pay_amount)
                          INTO l_pay_amount
                          FROM X_GTT_FID_PAYMENT_TEMP
                         WHERE fpt_pay_lic_number = l_dst_lic
                               AND fpt_pay_lsl_number =
                                      (SELECT lsl_number
                                         FROM x_fin_lic_sec_lee
                                        WHERE lsl_lic_number = l_dst_lic
                                              AND lsl_lee_number =
                                                     i.lsl_lee_number);

                        UPDATE x_fin_lic_sec_lee
                           SET lsl_lee_price = l_pay_amount
                         WHERE lsl_lic_number = l_dst_lic
                               AND lsl_lee_number = i.lsl_lee_number;
                     ELSE
                        UPDATE x_fin_lic_sec_lee
                           SET lsl_lee_price = i.lsl_lee_price
                         WHERE lsl_lic_number = l_dst_lic
                               AND lsl_lee_number = i.lsl_lee_number;
                     END IF;
                  END IF;
               END LOOP;

               FOR i
                  IN (SELECT lsl_number, lsl_lee_price, lsl_lee_number
                        FROM x_fin_lic_sec_lee
                       WHERE lsl_lic_number = i_licnumber
                             AND lsl_is_primary = 'Y')
               LOOP
                  IF licensee_code_count > 0 --l_lic_catchup_flag in ( 'Y','S')
                  THEN
                     --19/03/15 for SVOD added 'S'
                     SELECT SUM (fpt_pay_amount)
                       INTO l_pay_amount
                       FROM X_GTT_FID_PAYMENT_TEMP
                      WHERE fpt_pay_lic_number = l_dst_lic
                            AND fpt_pay_lsl_number =
                                   (SELECT lsl_number
                                      FROM x_fin_lic_sec_lee
                                     WHERE lsl_lic_number = l_dst_lic
                                           AND lsl_is_primary = 'Y');

                     UPDATE x_fin_lic_sec_lee
                        SET lsl_lee_price = l_pay_amount
                      WHERE lsl_lic_number = l_dst_lic
                            AND lsl_lee_number =
                                   (SELECT lsl_lee_number
                                      FROM x_fin_lic_sec_lee
                                     WHERE lsl_lic_number = l_dst_lic
                                           AND lsl_is_primary = 'Y');
                  ELSE
                     UPDATE x_fin_lic_sec_lee
                        SET lsl_lee_price = i.lsl_lee_price
                      WHERE lsl_lic_number = l_dst_lic
                            AND lsl_lee_number =
                                   (SELECT lsl_lee_number
                                      FROM x_fin_lic_sec_lee
                                     WHERE lsl_lic_number = l_dst_lic
                                           AND lsl_is_primary = 'Y');
                  END IF;
               END LOOP;

               /*   if l_lic_catchup_flag = 'Y' then

                      UPDATE x_fin_lic_sec_lee
                           SET lsl_lee_price = l_pay_amount
                         WHERE lsl_lic_number = l_dst_lic;
                  else

                   UPDATE x_fin_lic_sec_lee
                           SET lsl_lee_price = (select lsl_lee_price from x_fin_lic_sec_lee where lsl_lic_number = i_licnumber
                                                                                              and rownum < 2
                            )
                         WHERE lsl_lic_number = l_dst_lic;

                  end if;*/

               COMMIT;

               UPDATE fid_license
                  SET lic_showing_lic = i_licshowinglic,
                      lic_price =
                         (SELECT SUM (lsl_lee_price)
                            FROM x_fin_lic_sec_lee
                           WHERE lsl_lic_number = l_dst_lic)
                WHERE lic_number = l_dst_lic;



            END IF;

            COMMIT;
         ELSE
            RAISE updatefailed;
         END IF;


         --RDT Start : Acquision Requirements BR_15_244 [Rashmi_Tijare][14/10/2015]
      If  nvl(i_is_dstv_right,'N') ='Y'    and    nvl(i_dstv_flag,'N') = 'N'
         then

         update fid_license
         set lic_is_dstv_right = 'Y'
          WHERE lic_number = i_licnumber;

         Elsif nvl(i_is_dstv_right,'N') ='N'    and    nvl(i_dstv_flag,'N') = 'N'
          then

          update fid_license
         set lic_is_dstv_right = 'N'
          WHERE lic_number = i_licnumber;

           Elsif nvl(i_is_dstv_right,'N') ='Y'    and    nvl(i_dstv_flag,'N') = 'Y'
           then
            update fid_license
         set lic_is_dstv_right = 'Y'
          WHERE lic_number in (select lic_number from fid_license,fid_general where lic_con_number =l_con_number
          and lic_gen_refno = gen_refno
         ) ;

           Elsif nvl(i_is_dstv_right,'N') ='N'    and    nvl(i_dstv_flag,'N') = 'Y'
           then
            update fid_license
         set lic_is_dstv_right = 'N'
          WHERE lic_number in (select lic_number from fid_license,fid_general where lic_con_number =l_con_number
          and lic_gen_refno = gen_refno
         ) ;

        End if;

         --RDT End : Acquision Requirements BR_15_244 [Rashmi_Tijare][14/10/2015]

         --Dev2: Costing 5+2 Rules :Aditya Gupta_20140430 : End

         SELECT lic_con_number
           INTO l_con_number
           FROM fid_license
          WHERE lic_number = i_licnumber;

         SELECT con_start_date, con_end_date
           INTO l_con_start_date, l_con_end_date
           FROM fid_contract
          WHERE con_number = l_con_number;

         IF (i_licstart < l_con_start_date) OR (l_con_start_date IS NULL)
         THEN
            UPDATE fid_contract
               SET con_start_date = i_licstart,
                   con_entry_oper = i_entryoper,
                   con_entry_date = SYSDATE
             WHERE con_number = l_con_number;
         END IF;

         IF (i_licend > l_con_end_date) OR (l_con_end_date IS NULL)
         THEN
            UPDATE fid_contract
               SET con_end_date = i_licend,
                   con_entry_oper = i_entryoper,
                   con_entry_date = SYSDATE
             WHERE con_number = l_con_number;
         END IF;

         ---BR_15_144:Warner Payment: Rashmi Tijare_20150107:Updation of fields:Start
         /*   IF l_lic_type ='ROY'
            THEN
               UPDATE fid_license
                 SET LIC_MIN_GUARANTEE_FLAG = i_min_gurantee_lic,
                     lic_min_subs_flag = i_min_gurantee_sub
                     where lic_number =i_licnumber;
              commit;
            End IF;*/
         ---BR_15_144:Warner Payment: Rashmi Tijare_20150107:Updation of fields:End

	 If nvl(i_is_dstv_right,'N') = 'N'
         Then
             delete X_DSTV_RIGHTS_NOW_DATA_LIC
             where DRND_LIC_NUMBER = i_licnumber;
           End if;
	 COMMIT;

         --o_status := l_flag;
         IF v_endstarttbaupdated = 1
         THEN
            BEGIN
               SELECT lpy_pay_month_no
                 INTO o_paymonthno
                 FROM fid_license_payment_months
                WHERE lpy_paid_ind = 'N'
                      AND lpy_number = (  SELECT MIN (lpy_number)
                                            FROM fid_license_payment_months
                                           WHERE lpy_lic_number = i_licnumber
                                        GROUP BY lpy_lic_number);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  o_paymonthno := 0;
               WHEN OTHERS
               THEN
                  o_paymonthno := 0;
            END;
         END IF;
      ELSE
         RAISE updatefailed;
      END IF;
    --Jawahar.Garg added sp to send reversal mail.
         IF l_old_lic_start_ary.COUNT > 0
		 THEN
		     IF l_old_lic_start_ary(1) != i_licstart
		     THEN
					 X_PKG_SEND_LIC_REV_MAIL.X_PRC_CHK_LIC_REV (
						I_LIC_NUMBER		  => l_lic_number_ary,
						I_TITLE               => l_gen_title_ary,
						I_LEE_NUMBER          => l_lic_lee_number_ary,
						I_OLD_LIC_START		  => l_old_lic_start_ary,
						I_NEW_LIC_START		  => l_new_lic_start_ary,
						I_CON_SHORT_NAME      => l_con_short_name_ary,
						I_CON_NAME            => l_con_name_ary,
						I_USER				  => i_entryoper
					 );
			 END IF;
		 END IF;
    --Jawahar.Garg added sp to send reversal mail.
   EXCEPTION
    --15_FIN_06_ENH_Cancel Season in one attempt_v1.0
      when canclefailed then
         raise_application_error(-20018,'Please refresh the screen ,Data has been modified by another user');
     --15_FIN_06_ENH_Cancel Season in one attempt_v1.0
      WHEN updatefailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Updated');
      WHEN exh_exceed_failed
      THEN
         raise_application_error (
            -20100,
            'The value of amortisation Exh should not be less than the Sum of Exh in closed financial month');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_editlicensedetail;
   -----------------------------------------------------------------------
   --Warner Payment :Rashmi Tijare.10:07-2015
   --Added for Minimum gurantee popup
   -------------------------------------------------------------------
   
   --Finance Dev Phase I Zeshan [Start]   
   --****************************************************************
   --This procedure logs license status history details
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE X_PRC_MANAGE_LIC_HISTORY(
    I_LIC_NUMBER        IN        NUMBER,
    I_LIC_START         IN        DATE,
    I_LIC_END           IN        DATE,
    I_LIC_STATUS        IN        VARCHAR2,
    I_LIC_LEE_NUMBER    IN        NUMBER,
    I_LIC_ENTRY_OPER    IN        VARCHAR2
   )
  as
    L_LICH_NUMBER       NUMBER;
    L_LIC_STATUS        VARCHAR2(4);
    
    L_OPEN_MONTH        NUMBER;
  BEGIN
      
      SELECT TO_NUMBER (fim_year || LPAD(fim_month,2,0))
          INTO L_OPEN_MONTH
          FROM fid_financial_month, fid_licensee
         WHERE fim_split_region = lee_split_region
           AND fim_status = 'O'
           AND lee_number = I_LIC_LEE_NUMBER;
                              
      BEGIN
        INSERT INTO X_LIC_STATUS_HISTORY
              (
                LSH_NUMBER,
                LSH_LIC_NUMBER,
                LSH_LIC_START,
                LSH_LIC_END,
                LSH_LIC_STATUS,
                LSH_STATUS_DATE,
                LSH_STATUS_YYYYMM,
                LSH_LIC_ENTRY_OPER
              )
        VALUES 
              (
                X_SEQ_LSH_NUMBER.NEXTVAL, 
                I_LIC_NUMBER,
                I_LIC_START,
                I_LIC_END,
                I_LIC_STATUS, 
                SYSDATE, 
                L_OPEN_MONTH, 
                I_LIC_ENTRY_OPER
              );
                    
        EXCEPTION WHEN DUP_VAL_ON_INDEX
        THEN
            
            SELECT LSH_NUMBER, LSH_LIC_STATUS
            INTO L_LICH_NUMBER, L_LIC_STATUS
            FROM X_LIC_STATUS_HISTORY
            WHERE LSH_LIC_NUMBER = I_LIC_NUMBER
            AND LSH_STATUS_YYYYMM = L_OPEN_MONTH;
            
            IF L_LIC_STATUS <> I_LIC_STATUS
            THEN
                DELETE FROM X_LIC_STATUS_HISTORY
                WHERE LSH_NUMBER = L_LICH_NUMBER;
            END IF;
      END;

  END X_PRC_MANAGE_LIC_HISTORY;
  --Finance Dev Phase I [End]

   PROCEDURE prc_alic_cm_mingurantee_popup (
      i_prog_title    IN     fid_general.gen_title%TYPE,
      i_contract_no   IN     fid_contract.con_number%TYPE,
      i_mem_id        IN     sak_memo.mem_id%TYPE,
      o_data             OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_data FOR
         SELECT lic_min_guarantee_flag, lic_number, lee_short_name
           FROM fid_license,
                fid_general,
                sak_memo,
                fid_contract,
                fid_licensee
          WHERE     gen_refno = lic_gen_refno
                AND con_lee_number = mem_lee_number
                AND lic_con_number = con_number
                AND lic_lee_number = lee_number
                AND lic_mem_number = mem_id
                AND gen_title = i_prog_title
                AND con_number = i_contract_no
                AND mem_id = i_mem_id
                --Addeed by sushma on 14-09-2015
                --to avoid the catch up license in mg transfer pop up on lic maint screen
                and NVL(LIC_CATCHUP_FLAG,'N') = 'N';
                --END
   END prc_alic_cm_mingurantee_popup;

   -----------------------------------------------------------------------
   --Warner Payment :Rashmi Tijare.10:07-2015
   -------------------------------------------------------------------

   PROCEDURE prc_alic_cm_mingurantee_update (
      i_old_lic_number   IN     fid_license.lic_number%TYPE,
      i_new_lic_number   IN     fid_license.lic_number%TYPE,
      o_data                OUT NUMBER)
   AS
      l_count1   NUMBER;
      l_count2   NUMBER;
   BEGIN
      SELECT COUNT (lic_number)
        INTO l_count1
        FROM fid_license
       WHERE lic_number = i_old_lic_number;

      SELECT COUNT (lic_number)
        INTO l_count2
        FROM fid_license
       WHERE lic_number = i_new_lic_number;

      IF l_count1 <> 0 AND l_count2 <> 0
      THEN
         UPDATE fid_license
            SET lic_min_guarantee_flag = 'N'
          WHERE lic_number = i_old_lic_number;

         UPDATE fid_license
            SET lic_min_guarantee_flag = 'Y'
          WHERE lic_number = i_new_lic_number;

         COMMIT;
         o_data := 1;
      ELSE
         o_data := -1;
      END IF;
   END prc_alic_cm_mingurantee_update;

   --****************************************************************
   -- This procedure inserts Channel Allocation.
   --****************************************************************
   PROCEDURE prc_alic_cm_addchnlallocat (
      i_lcrlicnumber         IN     fid_license_channel_runs.lcr_lic_number%TYPE,
      i_lcrchanumber         IN     fid_license_channel_runs.lcr_cha_number%TYPE,
      i_lcrrunsallocated     IN     fid_license_channel_runs.lcr_runs_allocated%TYPE,
      -- Project Bioscope : Ajit_20120316 : Allocation Costed Runs added
      i_allocationscosted    IN     fid_license_channel_runs.lcr_cha_costed_runs%TYPE,
      i_allocationscosted2   IN     fid_license_channel_runs.lcr_cha_costed_runs2%TYPE,
      -- Project Bioscope : Ajit_20120316 : End
      /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
      i_lcr_max_runs_cha     IN     fid_license_channel_runs.lcr_max_runs_cha%TYPE,
      i_lcrrunsused          IN     fid_license_channel_runs.lcr_runs_used%TYPE,
      i_lcrcostind           IN     fid_license_channel_runs.lcr_cost_ind%TYPE,
      i_lcrpostexhruns       IN     fid_license_channel_runs.lcr_post_exh_runs%TYPE,
      i_lcrentryoper         IN     fid_license_channel_runs.lcr_entry_oper%TYPE,
      o_status                  OUT NUMBER)
   AS
      channelalreadyexists       EXCEPTION;
      insertfailed               EXCEPTION;
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411 : Go live date of costing 5+2
      v_go_live_crc_date         DATE;
      l_lic_start_date           DATE;
      allocationscostedexists    EXCEPTION;
      allocationscosted2exists   EXCEPTION;
      lcrcostindexists           EXCEPTION;
      l_costed_closed            NUMBER;
      l_open_month               DATE;
      l_cha_short_name           VARCHAR2 (5);
   --Dev2: Costing 5+2 Rules :Vihal Patel_20140411: End
   BEGIN
      o_status := 0;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411 : Go live date of costing 5+2
      SELECT lic_start
        INTO l_lic_start_date
        FROM fid_license
       WHERE lic_number = i_lcrlicnumber;

      SELECT TO_DATE (content)
        INTO v_go_live_crc_date
        FROM x_fin_configs
       WHERE ID = 6;

      SELECT TO_DATE (fim_year || fim_month, 'YYYYMM')
        INTO l_open_month
        FROM fid_financial_month, fid_licensee
       WHERE     fim_split_region = lee_split_region
             AND fim_status = 'O'
             AND lee_number = (SELECT lic_lee_number
                                 FROM fid_license
                                WHERE lic_number = i_lcrlicnumber);

      SELECT CHA_SHORT_NAME
        INTO l_cha_short_name
        FROM fid_channel
       WHERE cha_number = i_lcrchanumber;

      IF (l_lic_start_date >= v_go_live_crc_date)
      THEN
         IF (NVL (i_allocationscosted, 0) > 0)
         THEN
            RAISE allocationscostedexists;
         END IF;

         IF (NVL (i_allocationscosted2, 0) > 0)
         THEN
            RAISE allocationscosted2exists;
         END IF;

         IF (i_lcrcostind = 'Y')
         THEN
            RAISE lcrcostindexists;
         END IF;
      END IF;

      SELECT COUNT (sch_number)
        INTO l_costed_closed
        FROM fid_schedule
       WHERE     sch_lic_number = NVL (i_lcrlicnumber, -1)
             AND sch_cha_number = i_lcrchanumber
             AND sch_date < l_open_month
             AND sch_type = 'P';

      IF (l_lic_start_date < v_go_live_crc_date)
      THEN
         IF (l_costed_closed > i_allocationscosted)
         THEN
            ROLLBACK;
            o_status := '-1';
            raise_application_error (
               -20601,
                  'For Channel '
               || l_cha_short_name
               || ', allocated costed runs is less than already costed runs.');
         END IF;
      END IF;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140411: End

      SELECT COUNT (*)
        INTO o_status
        FROM fid_license_channel_runs
       WHERE lcr_cha_number = i_lcrchanumber
             AND lcr_lic_number = i_lcrlicnumber;

      IF o_status > 0
      THEN
         RAISE channelalreadyexists;
      END IF;

      o_status := 0;

      INSERT INTO fid_license_channel_runs (lcr_number,
                                            lcr_lic_number,
                                            lcr_cha_number,
                                            lcr_runs_allocated,
                                            lcr_runs_used,
                                            lcr_cost_ind,
                                            lcr_post_exh_runs,
                                            lcr_entry_oper,
                                            lcr_entry_date,
                                            /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
                                            lcr_max_runs_cha,
                                            lcr_update_count,
                                            -- Project Bioscope : Ajit_20120316 : Allocation Costed Runs added
                                            lcr_cha_costed_runs,
                                            lcr_cha_costed_runs2 -- Project Bioscope : Ajit_20120316 : End
                                                                )
           VALUES (seq_lcr_number.NEXTVAL,
                   i_lcrlicnumber,
                   i_lcrchanumber,
                   i_lcrrunsallocated,
                   i_lcrrunsused,
                   UPPER (i_lcrcostind),
                   i_lcrpostexhruns,
                   i_lcrentryoper,
                   SYSDATE,
                   /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
                   i_lcr_max_runs_cha,
                   0,
                   -- Project Bioscope : Ajit_20120316 : Allocation Costed Runs added
                   i_allocationscosted,
                   i_allocationscosted2 -- Project Bioscope : Ajit_20120316 : End
                                       )
        RETURNING lcr_number
             INTO o_status;

      IF (o_status > 0)
      THEN
         COMMIT;
      ELSE
         RAISE insertfailed;
      END IF;
   EXCEPTION
      WHEN channelalreadyexists
      THEN
         o_status := 0;
         raise_application_error (
            -20610,
            'Record has already been inserted. Channel already exists for license.');
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414 : Go live date of costing 5+2
      WHEN allocationscostedexists
      THEN
         raise_application_error (-20610,
                                  'Sch Wnd 1 costed run should be 0.');
      WHEN allocationscosted2exists
      THEN
         raise_application_error (-20610,
                                  'Sch Wnd 2 costed run should be 0.');
      WHEN lcrcostindexists
      THEN
         raise_application_error (-20610,
                                  'Cost indicator should be unchecked.');
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414: End
      WHEN insertfailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Inserted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := -1;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_addchnlallocat;

   --****************************************************************
   -- This procedure deletes Channel Allocation.
   --****************************************************************
   PROCEDURE prc_alic_cm_deletechnlallocat (
      i_lcrnumber        IN     fid_license_channel_runs.lcr_number%TYPE,
      i_lcrlicnumber     IN     fid_license_channel_runs.lcr_lic_number%TYPE,
      i_lcrchanumber     IN     fid_license_channel_runs.lcr_cha_number%TYPE,
      i_lcrupdatecount   IN     fid_license_channel_runs.lcr_update_count%TYPE,
      i_entryoper        IN     fid_license.lic_entry_oper%TYPE,
      o_status              OUT NUMBER)
   AS
      scheduledexists   EXCEPTION;
      deletefailed      EXCEPTION;
      l_number          NUMBER;
   BEGIN
      o_status := 0;

      SELECT pkg_cm_username.setusername (i_entryoper)
        INTO l_number
        FROM DUAL;

      SELECT COUNT (*)
        INTO o_status
        FROM fid_schedule
       WHERE sch_cha_number = i_lcrchanumber
             AND sch_lic_number = i_lcrlicnumber;

      IF o_status > 0
      THEN
         RAISE scheduledexists;
      END IF;

      o_status := 0;

         DELETE fid_license_channel_runs
          WHERE NVL (lcr_update_count, 0) = i_lcrupdatecount
                AND lcr_number = i_lcrnumber
      RETURNING lcr_lic_number
           INTO o_status;

      IF o_status > 0
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
         RAISE deletefailed;
      END IF;
   EXCEPTION
      WHEN deletefailed
      THEN
         ROLLBACK;
         o_status := 0;
         raise_application_error (-20100, 'Record Not Deleted');
      WHEN scheduledexists
      THEN
         ROLLBACK;
         o_status := 0;
         raise_application_error (
            -20100,
            'There are schedule entries for this license and channel, first delete from schedule.');
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := -1;

         IF (SUBSTR (SQLERRM, 1, 9) = 'ORA-02292')
         THEN
            raise_application_error (-20601, 'Child record exists.');
         ELSE
            raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
         END IF;
   END prc_alic_cm_deletechnlallocat;

   --****************************************************************
   -- This procedure updates Channel Allocation details.
   --****************************************************************
   PROCEDURE prc_alic_cm_editchnlallocat (
      i_lcrnumber            IN     fid_license_channel_runs.lcr_number%TYPE,
      i_lcrlicnumber         IN     fid_license_channel_runs.lcr_lic_number%TYPE,
      i_lcrchanumber         IN     fid_license_channel_runs.lcr_cha_number%TYPE,
      i_lcrrunsallocated     IN     fid_license_channel_runs.lcr_runs_allocated%TYPE,
      -- Project Bioscope : Ajit_20120316 : Allocation Costed Runs added
      i_allocationscosted    IN     fid_license_channel_runs.lcr_cha_costed_runs%TYPE,
      i_allocationscosted2   IN     fid_license_channel_runs.lcr_cha_costed_runs2%TYPE,
      -- Project Bioscope : Ajit_20120316 : End
      /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
      i_lcr_max_runs_cha     IN     fid_license_channel_runs.lcr_max_runs_cha%TYPE,
      i_lcrcostind           IN     fid_license_channel_runs.lcr_cost_ind%TYPE,
      i_lcrupdatecount       IN     fid_license_channel_runs.lcr_update_count%TYPE,
      i_entry_oper           IN     fid_license_channel_runs.lcr_entry_oper%TYPE,
      o_status                  OUT NUMBER)
   AS
      updatefailed               EXCEPTION;
      l_schedule_exits           NUMBER;
      l_channel_name             VARCHAR2 (10);
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414 : Go live date of costing 5+2
      v_go_live_crc_date         DATE;
      l_lic_start_date           DATE;
      allocationscostedexists    EXCEPTION;
      allocationscosted2exists   EXCEPTION;
      lcrcostindexists           EXCEPTION;
      l_costed_closed            NUMBER;
      l_open_month               DATE;
      l_cha_short_name           VARCHAR2 (5);
      l_lcr_costing_runs         fid_license_channel_runs.lcr_costing_runs%TYPE;
      l_lcr_cha_costed_runs2     fid_license_channel_runs.lcr_cha_costed_runs2%TYPE;
      l_lcr_sch_end_date2        fid_license_channel_runs.lcr_sch_end_date2%TYPE;
      l_lcr_sch_end_date         fid_license_channel_runs.lcr_sch_end_date%TYPE;
   --Dev2: Costing 5+2 Rules :Vihal Patel_20140414: End
   BEGIN
      o_status := 0;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414 : Go live date of costing 5+2
      SELECT lic_start
        INTO l_lic_start_date
        FROM fid_license
       WHERE lic_number = i_lcrlicnumber;

      SELECT TO_DATE (content)
        INTO v_go_live_crc_date
        FROM x_fin_configs
       WHERE ID = 6;

      SELECT TO_DATE (fim_year || fim_month, 'YYYYMM')
        INTO l_open_month
        FROM fid_financial_month, fid_licensee
       WHERE     fim_split_region = lee_split_region
             AND fim_status = 'O'
             AND lee_number = (SELECT lic_lee_number
                                 FROM fid_license
                                WHERE lic_number = i_lcrlicnumber);

      SELECT CHA_SHORT_NAME
        INTO l_cha_short_name
        FROM fid_channel
       WHERE cha_number = i_lcrchanumber;

      IF (l_lic_start_date >= v_go_live_crc_date)
      THEN
         IF (NVL (i_allocationscosted, 0) > 0)
         THEN
            RAISE allocationscostedexists;
         END IF;

         IF (NVL (i_allocationscosted2, 0) > 0)
         THEN
            RAISE allocationscosted2exists;
         END IF;

         IF (i_lcrcostind = 'Y')
         THEN
            RAISE lcrcostindexists;
         END IF;
      END IF;

      SELECT lcr_costing_runs, lcr_cha_costed_runs2
        INTO l_lcr_costing_runs, l_lcr_cha_costed_runs2
        FROM fid_license_channel_runs
       WHERE lcr_number = i_lcrnumber;

      IF l_lcr_costing_runs <> i_allocationscosted
      THEN
         SELECT COUNT (sch_number)
           INTO l_costed_closed
           FROM fid_schedule
          WHERE     sch_lic_number = NVL (i_lcrlicnumber, -1)
                AND sch_cha_number = i_lcrchanumber
                AND sch_date < l_open_month
                AND sch_date <= l_lcr_sch_end_date
                AND sch_type = 'P';

         IF (l_lic_start_date < v_go_live_crc_date)
         THEN
            IF (l_costed_closed > i_allocationscosted)
            THEN
               ROLLBACK;
               o_status := '-1';
               raise_application_error (
                  -20601,
                  'For Channel ' || l_cha_short_name
                  || ', allocated costed runs is less than already costed runs.');
            END IF;
         END IF;
      ELSIF l_lcr_cha_costed_runs2 <> i_allocationscosted2
      THEN
         SELECT COUNT (sch_number)
           INTO l_costed_closed
           FROM fid_schedule
          WHERE     sch_lic_number = NVL (i_lcrlicnumber, -1)
                AND sch_cha_number = i_lcrchanumber
                AND sch_date < l_open_month
                AND sch_date > l_lcr_sch_end_date
                AND sch_date <= l_lcr_sch_end_date2
                AND sch_type = 'P';

         IF (l_lic_start_date < v_go_live_crc_date)
         THEN
            IF (l_costed_closed > i_allocationscosted)
            THEN
               ROLLBACK;
               o_status := '-1';
               raise_application_error (
                  -20601,
                  'For Channel ' || l_cha_short_name
                  || ', allocated costed runs is less than already costed runs.');
            END IF;
         END IF;
      END IF;

         --Dev2: Costing 5+2 Rules :Vihal Patel_20140414: End

         UPDATE fid_license_channel_runs
            SET lcr_runs_allocated = i_lcrrunsallocated,
                lcr_cost_ind = UPPER (i_lcrcostind),
                lcr_entry_oper = i_entry_oper,
                lcr_entry_date = SYSDATE,
                lcr_update_count = NVL (lcr_update_count, 0) + 1,
                /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
                lcr_max_runs_cha = i_lcr_max_runs_cha,
                -- Project Bioscope : Ajit_20120316 : Allocation Costed Runs added
                lcr_cha_costed_runs = i_allocationscosted,
                lcr_cha_costed_runs2 = i_allocationscosted2
          -- Project Bioscope : Ajit_20120316 : End
          WHERE NVL (lcr_update_count, 0) = i_lcrupdatecount
                AND lcr_number = i_lcrnumber
      RETURNING lcr_update_count
           INTO o_status;

      IF o_status > 0
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
         RAISE updatefailed;
      END IF;
   EXCEPTION
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414 : Go live date of costing 5+2
      WHEN allocationscostedexists
      THEN
         raise_application_error (-20610,
                                  'Sch Wnd 1 costed run should be 0.');
      WHEN allocationscosted2exists
      THEN
         raise_application_error (-20610,
                                  'Sch Wnd 2 costed run should be 0.');
      WHEN lcrcostindexists
      THEN
         raise_application_error (-20610,
                                  'Cost indicator should be unchecked.');
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414: End
      WHEN updatefailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := '-1';
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_editchnlallocat;

   --****************************************************************
   -- This procedure searches Territory Pricing.
   -- This procedure input is license Number.
   --****************************************************************
   PROCEDURE prc_alic_cm_searchterrypricing (
      i_lillicnumber             IN     fid_license_ledger.lil_lic_number%TYPE,
      o_searchterritorypricing      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
   BEGIN
      OPEN o_searchterritorypricing FOR
           SELECT fll.lil_lic_number,
                  fll.lil_con_forecast,
                  fll.lil_con_actual,
                  fll.lil_loc_adjust,
                  fll.lil_ter_code,
                  fll.lil_rgh_code,
                  fll.lil_price_code,
                  ROUND (fll.lil_price, 4) lil_price,
                  fll.lil_adjust_factor,
                  fc.cod_description,
                  NVL (fll.lil_update_count, 0) lil_update_count
             FROM fid_license_ledger fll, fid_code fc
            WHERE     fc.cod_value <> 'HEADER'
                  AND fc.cod_type = 'LIC_RGH_CODE'
                  AND fc.cod_value = fll.lil_rgh_code
                  AND fll.lil_lic_number = i_lillicnumber
         ORDER BY fll.lil_ter_code;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_searchterrypricing;

   --****************************************************************
   -- This procedure updates Territory Pricing details.
   --****************************************************************
   PROCEDURE prc_alic_cm_editterrypricing (
      i_lillicnumber      IN     fid_license_ledger.lil_lic_number%TYPE,
      i_liltercode        IN     fid_license_ledger.lil_ter_code%TYPE,
      i_lilrghcode        IN     fid_license_ledger.lil_rgh_code%TYPE,
      i_lilpricecode      IN     fid_license_ledger.lil_price_code%TYPE,
      i_price             IN     fid_license_ledger.lil_price%TYPE,
      i_liladjustfactor   IN     fid_license_ledger.lil_adjust_factor%TYPE,
      i_lilupdatecount    IN     fid_license_ledger.lil_update_count%TYPE,
      o_status               OUT NUMBER)
   AS
      updatefailed   EXCEPTION;
   BEGIN
      o_status := 0;

         UPDATE fid_license_ledger
            SET lil_rgh_code = UPPER (i_lilrghcode),
                lil_price_code = i_lilpricecode,
                lil_price = i_price,
                lil_adjust_factor = i_liladjustfactor,
                lil_update_count = NVL (lil_update_count, 0) + 1
          WHERE     NVL (lil_update_count, 0) = i_lilupdatecount
                AND UPPER (lil_ter_code) = UPPER (i_liltercode)
                AND lil_lic_number = i_lillicnumber
      RETURNING lil_update_count
           INTO o_status;

      IF o_status > 0
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
         RAISE updatefailed;
      END IF;
   EXCEPTION
      WHEN updatefailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := '-1';
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_editterrypricing;

   --****************************************************************
   -- This procedure searches License History.
   -- This procedure input is license Number.
   --****************************************************************
   PROCEDURE prc_alic_cm_searchlichistory (
      i_lihlicnumber           IN     fid_license_history.lih_lic_number%TYPE,
      o_searchlicensehistory      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
   BEGIN
      OPEN o_searchlicensehistory FOR
           SELECT flh.lih_number,
                  flh.lih_lic_number,
                  flh.lih_code,
                  flh.lih_date,
                  flh.lih_comment,
                  fd.cod_description,
                  NVL (flh.lih_update_count, 0) lih_update_count
             FROM fid_license_history flh, fid_code fd
            WHERE     fd.cod_value != 'HEADER'
                  AND fd.cod_type = 'LIH_CODE'
                  AND fd.cod_value(+) = flh.lih_code
                  AND flh.lih_lic_number = i_lihlicnumber
         ORDER BY lih_date;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_searchlichistory;

   --****************************************************************
   -- This procedure inserts License History.
   --****************************************************************
   PROCEDURE prc_alic_cm_addlichistory (
      i_lihlicnumber   IN     fid_license_history.lih_lic_number%TYPE,
      i_lihcode        IN     fid_license_history.lih_code%TYPE,
      i_lihdate        IN     fid_license_history.lih_date%TYPE,
      i_lihcomment     IN     fid_license_history.lih_comment%TYPE,
      i_lihentryoper   IN     fid_license_history.lih_entry_oper%TYPE,
      o_status            OUT NUMBER)
   AS
      eventalreadyexists   EXCEPTION;
      insertfailed         EXCEPTION;
   BEGIN
      o_status := -1;

      SELECT COUNT (*)
        INTO o_status
        FROM fid_license_history
       WHERE UPPER (lih_code) = UPPER (i_lihcode)
             AND lih_lic_number = i_lihlicnumber;

      IF o_status > 0
      THEN
         RAISE eventalreadyexists;
      END IF;

      INSERT INTO fid_license_history (lih_number,
                                       lih_lic_number,
                                       lih_code,
                                       lih_date,
                                       lih_comment,
                                       lih_entry_oper,
                                       lih_entry_date,
                                       lih_update_count)
           VALUES (seq_lih_number.NEXTVAL,
                   i_lihlicnumber,
                   UPPER (i_lihcode),
                   i_lihdate,
                   i_lihcomment,
                   i_lihentryoper,
                   SYSDATE,
                   0)
        RETURNING lih_number
             INTO o_status;

      IF o_status > 0
      THEN
         COMMIT;
      ELSE
         RAISE insertfailed;
      END IF;
   EXCEPTION
      WHEN eventalreadyexists
      THEN
         o_status := 0;
         raise_application_error (
            -20610,
            'Record has already been inserted. Event history already exists for license.');
      WHEN insertfailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Inserted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := -1;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_addlichistory;

   --****************************************************************
   -- This procedure updates License History details.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_editlichistory (
      i_lihnumber        IN     fid_license_history.lih_number%TYPE,
      i_lihcode          IN     fid_license_history.lih_code%TYPE,
      i_lihdate          IN     fid_license_history.lih_date%TYPE,
      i_lihcomment       IN     fid_license_history.lih_comment%TYPE,
      i_lihupdatecount   IN     fid_license_history.lih_update_count%TYPE,
      o_status              OUT NUMBER)
   AS
      eventalreadyexists   EXCEPTION;
      updatefailed         EXCEPTION;
   BEGIN
      SELECT COUNT (*)
        INTO o_status
        FROM fid_license_history
       WHERE     lih_number <> i_lihnumber
             AND UPPER (lih_code) = UPPER (i_lihcode)
             AND lih_lic_number = (SELECT lih_lic_number
                                     FROM fid_license_history
                                    WHERE lih_number = i_lihnumber);

      IF o_status > 0
      THEN
         RAISE eventalreadyexists;
      END IF;

         UPDATE fid_license_history
            SET lih_code = UPPER (i_lihcode),
                lih_date = i_lihdate,
                lih_comment = i_lihcomment,
                lih_update_count = NVL (lih_update_count, 0) + 1
          WHERE NVL (lih_update_count, 0) = i_lihupdatecount
                AND lih_number = i_lihnumber
      RETURNING lih_update_count
           INTO o_status;

      IF o_status > 0
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
         RAISE updatefailed;
      END IF;
   EXCEPTION
      WHEN eventalreadyexists
      THEN
         o_status := 0;
         raise_application_error (
            -20610,
            'Record has already been inserted. Event history already exists for license.');
      WHEN updatefailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := '-1';
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_editlichistory;

   --****************************************************************
   -- This procedure deletes License History.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_deletelichistory (
      i_lihnumber        IN     fid_license_history.lih_number%TYPE,
      i_lihupdatecount   IN     fid_license_history.lih_update_count%TYPE,
      o_status              OUT NUMBER)
   AS
      deletefailed   EXCEPTION;
   BEGIN
      o_status := 0;

      DELETE FROM fid_license_history
            WHERE NVL (lih_update_count, 0) = i_lihupdatecount
                  AND lih_number = i_lihnumber
        RETURNING lih_number
             INTO o_status;

      IF o_status > 0
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
         RAISE deletefailed;
      END IF;
   EXCEPTION
      WHEN deletefailed
      THEN
         ROLLBACK;
         o_status := 0;
         raise_application_error (-20100, 'Record Not Deleted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := -1;

         IF (SUBSTR (SQLERRM, 1, 9) = 'ORA-02292')
         THEN
            raise_application_error (-20601, 'Child record exists.');
         ELSE
            raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
         END IF;
   END prc_alic_cm_deletelichistory;

   --****************************************************************
   -- This procedure searches License Royalty Plan.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_searchroyalpayplan (
      i_lpylicnumber               IN     fid_license_payment_months.lpy_lic_number%TYPE,
      o_searchroyaltypaymentplan      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_searchroypayperterritory      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_searchroyalmgpayterritory  OUT   Sys_refcursor)
   AS
      i_split_region   fid_licensee.lee_split_region%TYPE;
   BEGIN
      ---Dev2:Pure Finance:Start:[Hari_Mandal]_[19/4/2013]
      SELECT lee_split_region
        INTO i_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_lpylicnumber);

      ---Dev2:Pure Finance:End--------------------------
      OPEN o_searchroyaltypaymentplan FOR
           SELECT flpm.lpy_number,
                  flpm.lpy_lic_number,
                  flpm.lpy_pay_month_no,
                  flpm.lpy_pay_month,
                  flpm.lpy_pay_percent,
                  flpm.lpy_cur_code,
                  flpm.lpy_pay_code,
                  flpm.lpy_paid_ind,
                  flpm.lpy_price_used,
                  (SELECT 'Y'
                     FROM fid_financial_month
                    WHERE     fim_year = TO_CHAR (flpm.lpy_pay_month, 'YYYY')
                          AND fim_month = TO_CHAR (flpm.lpy_pay_month, 'MM')
                          AND fim_status = 'C'
                          AND NVL (fim_split_region, 1) =
                                 DECODE (fim_split_region,
                                         NULL, 1,
                                         i_split_region))
                     monthclosed,
                  flpm.lpy_mup_percent,
                  fpt.pat_desc,
                  NVL (flpm.lpy_update_count, 0) lpy_update_count,
                  flpm.lpy_pay_islastmonth --Onsite.Dev:BR_15_321
             FROM fid_license_payment_months flpm, fid_payment_type fpt
            WHERE fpt.pat_code = flpm.lpy_pay_code
                  AND flpm.lpy_lic_number = i_lpylicnumber
         ORDER BY flpm.lpy_pay_month_no;

      --- Commented and replaced by Pranay Kusumwal 10/07/2013 for PURE FINANCE Code changes as handed over by Vinayak Nikam
      /* OPEN o_searchroypayperterritory FOR
          SELECT   0 lpl_number, lpl_lpy_number, lpl_ter_code, lpl_subs_used,
                   lpl_calc_month, lpl_subs_year, lpl_adjustment,
                   SUM (lpl_paid_excl_mup) lpl_paid_excl_mup,
                   SUM (lpl_paid_amount) lpl_paid_amount,
                   NVL (lpl_update_count, 0) lpl_update_count
              FROM fid_license_payment_ledger
             WHERE lpl_lpy_number IN (SELECT lpy_number
                                        FROM fid_license_payment_months
                                       WHERE lpy_lic_number = i_lpylicnumber)
          GROUP BY 0,
                   lpl_lpy_number,
                   lpl_ter_code,
                   lpl_subs_used,
                   lpl_calc_month,
                   lpl_subs_year,
                   lpl_adjustment,
                   NVL (lpl_update_count, 0)
          ORDER BY lpl_ter_code;*/
      /*
               SELECT lpl_number, lpl_lpy_number, lpl_ter_code, lpl_subs_used,
                      lpl_paid_excl_mup, lpl_paid_amount,
                      NVL (lpl_update_count, 0) lpl_update_count
                 FROM fid_license_payment_ledger
                WHERE lpl_lpy_number IN (SELECT lpy_number
                                           FROM fid_license_payment_months
                                          WHERE lpy_lic_number = i_lpylicnumber)
                Order by lpl_ter_code;*/
      OPEN o_searchroypayperterritory FOR
           SELECT 0 lpl_number,
                  lpl_lpy_number,
                  lpl_ter_code,
                  DECODE (NVL (lpl_adjustment, 'N'), 'Y', NULL, lpl_subs_used)
                     lpl_subs_used,
                  --lpl_subs_used,
                  lpl_calc_month,
                  lpl_subs_year,
                  lpl_adjustment,
                  lpl_calc_year,
                  SUM (lpl_paid_excl_mup) lpl_paid_excl_mup,
                  SUM (lpl_paid_amount) lpl_paid_amount,
                  NVL (lpl_update_count, 0) lpl_update_count
             FROM fid_license_payment_ledger
            WHERE lpl_lpy_number IN (SELECT lpy_number
                                       FROM fid_license_payment_months
                                      WHERE lpy_lic_number = i_lpylicnumber)
         GROUP BY 0,
                  lpl_lpy_number,
                  lpl_calc_year,
                  lpl_ter_code,
                  lpl_subs_used,
                  lpl_calc_month,
                  lpl_subs_year,
                  lpl_adjustment,
                  NVL (Lpl_Update_Count, 0)
         ORDER BY lpl_ter_code;

    /*Added  a cursor license territory plan for Warner Payment :15-07-2015 :RAshmi Tijare*/

       Open o_searchroyalmgpayterritory for

      --Commented by sushma on 25-08-2015
      --To show below information at month wise instead of territory
       /*SELECT lis_per_month "Month",
       lis_per_year "Year",
       lis_mean_subscriber "Mean_Average",
       LIS_CON_FORECAST "Asset_Value_Reopening",
       LIS_ASSET_ADJ_VALUE "Revaluation",
       (SELECT SUM (MSA_PRICE_CHG_ADJ_VAL + MSA_DUR_CHG_ADJ_VAL)
          FROM x_fin_mg_asset_adj
         WHERE msa_lic_number = i_lpylicnumber)
          "Change",
       0 "Total"
  FROM fid_license_sub_ledger
 WHERE lis_lic_number = i_lpylicnumber;
      -- GROUP BY lis_per_month, lis_per_year;*/


   select   to_char(to_date( a.lis_per_month,'MM'),'Mon') "Month",
            --a.lis_per_month  "Month",
            a.lis_per_year "Year",
            a.Mean_Average "Mean_Average",
            a.Asset_Value_Reopening + a.Price_adj_opening "Asset_Value_Reopening",
            a.Revaluation "Revaluation",
            ROUND(a.price_dur_change,4)  "Change",
            ROUND((NVL(Asset_Value_Reopening,0)+ NVL(a.Price_adj_opening,0) + NVL(price_dur_change,0) + NVL(Revaluation,0)),4)  "Total", --"Closing Balance"
            ROUND(( NVL((select sum(lis_con_forecast) from fid_license_sub_ledger where lis_lic_number = i_lpylicnumber),0)
                  - NVL((select SUM(PAY_AMOUNT) from fid_payment where pay_lic_number = i_lpylicnumber and pay_status = 'P'),0)
            ),4) "Running_Total"
          from (
                   SELECT
                         lis_per_month ,
                         lis_per_year ,
                         LIS_LIC_START,
                         SUM(lis_mean_subscriber)  Mean_Average,
                           NVL( (select SUM(LIS_ASSET_ADJ_VALUE) from fid_license_sub_ledger fls
                                where fls.lis_lic_number = i_lpylicnumber
                            and lis_per_year|| lpad(lis_per_month,2,0) < to_char((to_date(1||'-'||lpad(flsd.lis_per_month,2,0) || flsd.lis_per_year ,'DD-MM-YYYY')),'YYYYMM') ),0)
                            Asset_Value_Reopening,
                             NVL( (select SUM(MSA_CON_TOT_ADJ_VALUE) from x_fin_mg_asset_adj fmsa
                                where fmsa.msa_lic_number = i_lpylicnumber
                            and to_number(msa_adj_year||lpad(msa_adj_month,2,0)) < to_char((to_date(1||'-'||lpad(flsd.lis_per_month,2,0) || flsd.lis_per_year ,'DD-MM-YYYY')),'YYYYMM') ),0)
                                 Price_adj_opening,
                         SUM(LIS_ASSET_ADJ_VALUE)  Revaluation,
                           ( select NVL(SUM(MSA_CON_TOT_ADJ_VALUE),0)
                                              from x_fin_mg_asset_adj
                                            where MSA_LIC_NUMBER = i_lpylicnumber --flsd.lis_lic_number
                                           -- and to_number(MSA_CALC_YEAR || lpad(MSA_CALC_MONTH,2,0)) <=   to_number( flsd.lis_per_year || lpad(flsd.lis_per_month,2,0))
                                          and to_number(msa_adj_year||lpad(msa_adj_month,2,0)) =   to_number( flsd.lis_per_year || lpad(flsd.lis_per_month,2,0) )
                                            )  price_dur_change
                       /* NVL( (SELECT SUM (MSA_PRICE_CHG_ADJ_VAL + MSA_DUR_CHG_ADJ_VAL)
                            FROM x_fin_mg_asset_adj
                           WHERE msa_lic_number = 893395
                           AND MSA_calc_YEAR || lpad(MSA_calc_MONTH,2,0) <= lis_per_year || lpad(lis_per_month,2,0)  ),0) price_dur_change*/
                    FROM fid_license_sub_ledger flsd
                   WHERE lis_lic_number = i_lpylicnumber
                         GROUP BY lis_per_month, lis_per_year,lis_lic_number,LIS_LIC_START )a
          order by  a.lis_per_year ASC,a.lis_per_month ASC ;


   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_searchroyalpayplan;

   /* Warner Payment 13-07-2015:RAshmi Tijare :Added for  Minimum Gurantee Payment and Minimum gurantee Payment Plan Grid:Start*/

   PROCEDURE prc_alic_cm_srchminguapayplan (
      i_licnumber          IN     x_fin_mg_pay_plan.MGP_LIC_NUMBER%TYPE,
      o_lic_payment_plan      OUT SYS_REFCURSOR,
      o_royalpay              OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_lic_payment_plan FOR
         SELECT mgp_number,
                mgp_pay_month_no,
                mgp_pay_month,
                mgp_is_calc,
                mgp_is_paid,
                mgp_pay_percent,
                mgp_update_count
           FROM x_fin_mg_pay_plan
          WHERE mgp_lic_number = i_licnumber;


      OPEN o_royalpay FOR
         SELECT mgpl_number,
                mgpl_mgp_number,
                mgpl_mg_amount,
                mgpl_paid_amount,
                to_char(to_date(mgpl_calc_month,'MM'),'Mon') mgpl_calc_month,
                mgpl_calc_year,
                mgpl_adjustment,
                --pay_amount "Total_Paid",
                --Changes done by sushma
                (select sum(pay_amount) from fid_payment
                          where pay_lic_number = i_licnumber
                          and pay_mgp_number = mgp_number and NVL(pay_status,'N') = 'P'
                          and to_number(pay_calc_year || lpad(pay_calc_month,2,0)) = to_number(mgpl_calc_year || lpad(mgpl_calc_month,2,0)) ) "Total_Paid",
                --Commented by sushma on 25-08-2015
                --No need to show the running total here
              /* ((select sum(lis_con_forecast) from fid_license_sub_ledger where lis_lic_number =i_licnumber)
                    -(select sum(pay_amount) from fid_payment,x_fin_mg_pay_plan where mgp_number =PAY_MGP_NUMBER and pay_lic_number =i_licnumber)) "Running_Total",*/
                  mgpl_subs_used CON_MIN_SUBSCRIBER
           FROM x_fin_mg_pay_ledger
               ,x_fin_mg_pay_plan
          WHERE  mgpl_mgp_number =mgp_number
            And mgp_lic_number = i_licnumber
           /* group by
              mgpl_number,
                mgpl_mgp_number,
                mgpl_mg_amount,
                mgpl_paid_amount,
                mgpl_calc_month,
                mgpl_calc_year,
                mgpl_adjustment,
                mgpl_subs_used,
                mgp_number
   --         And pay_mgp_number = mgp_number
     --       AND PAY_LIC_NUMBER= lic_number*/
     ;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_srchminguapayplan;

   /* Procedure to add minimum gurantee pay plan */


   PROCEDURE prc_alic_cm_add_mingua (
      i_lic_number   IN     x_fin_mg_pay_plan.mgp_lic_number%TYPE,
      i_month_no     IN     x_fin_mg_pay_plan.MGP_PAY_MONTH_NO%TYPE,
      i_pay_mon      IN     x_fin_mg_pay_plan.mgp_pay_month%TYPE,
      i_percent      IN     x_fin_mg_pay_plan.mgp_pay_percent%TYPE,
       i_entry_oper  IN  x_fin_mg_pay_plan.mgp_entry_oper%TYPE,
      o_status          OUT x_fin_mg_pay_plan.mgp_number%TYPE)
   AS
      l_flag            NUMBER := -1;
      insertfailed      EXCEPTION;
      percentexceeded   EXCEPTION;
      l_paypercentsum   NUMBER;
      i_split_region    fid_licensee.lee_split_region%TYPE;
      l_start           DATE;
      l_end             DATE;
      o_due_date        DATE;
   BEGIN
      BEGIN
         SELECT SUM (mgp_pay_percent) + i_percent
           INTO l_paypercentsum
           FROM x_fin_mg_pay_plan
          WHERE mgp_lic_number = i_lic_number;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_paypercentsum := 0;

            NULL;
      END;

      IF (l_paypercentsum > 100)
      THEN
         RAISE percentexceeded;
      END IF;


      SELECT lic_start, lic_end
        INTO l_start, l_end
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT lee_split_region
        INTO i_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_lic_number);

      /*Calculating date when inserted ew payment plan in grid */
      calc_pay_month (i_split_region,
                      l_start,
                      l_end,
                      NULL,
                      i_month_no,
                      o_due_date);

      O_status := SEQ_MGP_NUMBER.NEXTVAL;


      INSERT INTO x_fin_mg_pay_plan (mgp_number,
                                     mgp_lic_number,
                                     MGP_PAY_MONTH_NO,
                                     mgp_pay_month,
                                     mgp_pay_percent,
                                     mgp_entry_oper,
                                     MGP_ENTRY_DATE)
           VALUES (O_status,
                   i_lic_number,
                   i_month_no,
                   i_pay_mon,
                   i_percent,
                   i_entry_oper,
                   sysdate);


      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
      ELSE
         RAISE insertfailed;
      END IF;
   EXCEPTION
      WHEN insertfailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Inserted');
      WHEN percentexceeded
      THEN
         ROLLBACK;
         raise_application_error (
            -20394,
            'Payment Percent cannot be greater than 100 percent.');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_add_mingua;
/*Procedure to Update min gurantee plan Warner Payment :15-07-2015 :RAshmi Tijare*/
   PROCEDURE prc_alic_cm_upd_minguarantee (
      i_licnum           IN     x_fin_mg_pay_plan.mgp_lic_number%TYPE,
      i_mgp_number       IN     x_fin_mg_pay_plan.mgp_number%TYPE,
      i_month_no         IN     x_fin_mg_pay_plan.MGP_PAY_MONTH_NO%TYPE,
      i_pay_mon          IN     x_fin_mg_pay_plan.mgp_pay_month%TYPE,
      i_percent          IN     x_fin_mg_pay_plan.mgp_pay_percent%TYPE,
       i_entry_oper       IN  x_fin_mg_pay_plan.mgp_entry_oper%TYPE,
      i_update_count     IN     x_fin_mg_pay_plan.MGP_UPDATE_COUNT%TYPE,
      o_paymentupdated      OUT NUMBER)
   AS
      l_count       NUMBER;
      l_flag        NUMBER;
      updatfailed   EXCEPTION;
      i_split_region    fid_licensee.lee_split_region%TYPE;
      l_start           DATE;
      l_end             DATE;
      o_due_date        DATE;
      l_open_date       DATE;
      v_add_month       DATE;
      l_pay_month       NUMBER;
      l_pay_mg_month    NUMBER;
      l_lee_name        varchar2(1);
      l_title           varchar2(100);
   BEGIN
      BEGIN
         SELECT COUNT (mgp_number)
           INTO l_count
           FROM x_fin_mg_pay_plan
          WHERE mgp_lic_number = i_licnum AND mgp_number = i_mgp_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF (l_count = 1)
      THEN
         o_paymentupdated := -1;
      END IF;

      IF (o_paymentupdated = -1)
      THEN

         SELECT lic_start, lic_end
        INTO l_start, l_end
        FROM fid_license,fid_general
       wHERE gen_refNo = lic_gen_refno
       and  lic_number = i_licnum;

      SELECT lee_split_region
        INTO i_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_licnum);

      /*Calculating date when inserted ew payment plan in grid */
       calc_pay_month (i_split_region,
                      l_start,
                      l_end,
                      NULL,
                      i_month_no,
                      o_due_date);

        --added by sushma on 03-aug-2015
        --to check the entered pay month is fall in close or open month
          SELECT TO_DATE ('01' || LPAD (fim_month, 2, 0) || fim_year,'DDMMYYYY')
            INTO l_open_date
           FROM fid_financial_month
          WHERE fim_status = 'O'
                AND NVL (FIM_SPLIT_REGION, 1) =
                       DECODE (i_split_region, NULL, 1, i_split_region);

         /*v_add_month :=
            TO_DATE (
               '01-'
               || TO_CHAR (ADD_MONTHS (l_start, i_month_no - 1),
                           'MON-YYYY'),
               'DD-MON-YYYY');

         IF v_add_month < l_open_date
         THEN
           raise_application_error (
               -20018,
               'Entered plan month is in close month.So plan can not be updated');
         ELSIF v_add_month > l_end
         THEN
           raise_application_error (
               -20019,
               'Entered plan month is in out of LED.So plan can not be updated');
         ELSE*/

            SELECT COUNT (1)
              INTO l_pay_month
              FROM fid_license_payment_months
             WHERE lpy_pay_month = v_add_month
                   AND lpy_lic_number = i_licnum;

              SELECT count(1)
               into l_pay_mg_month
                 FROM x_fin_mg_pay_plan
                WHERE MGP_PAY_MONTH = v_add_month
                      AND MGP_LIC_NUMBER = i_licnum;

            IF l_pay_month >= 1 or l_pay_mg_month >=1
            THEN
                raise_application_error (
                     -20601,
                     'Values captured in Payment Month or Minimum Guarantee Payment Month must be unique');
            END IF;

        -- END IF;
         --END

         UPDATE x_fin_mg_pay_plan
            SET MGP_PAY_MONTH_NO = i_month_no,
                mgp_pay_month = i_pay_mon,
                mgp_pay_percent = i_percent,
                mgp_entry_oper = i_entry_oper
          WHERE mgp_lic_number = i_licnum AND mgp_number = i_mgp_number;




         SELECT MGP_UPDATE_COUNT
           INTO l_flag
           FROM x_fin_mg_pay_plan
          WHERE mgp_lic_number = i_licnum AND mgp_number = i_mgp_number;

         IF (NVL (l_flag, 0) = NVL (i_update_count, 0))
         THEN
            UPDATE x_fin_mg_pay_plan
               SET MGP_UPDATE_COUNT = NVL (MGP_UPDATE_COUNT, 0) + 1
             WHERE mgp_lic_number = i_licnum AND mgp_number = i_mgp_number;

            COMMIT;

            SELECT MGP_UPDATE_COUNT
              INTO o_paymentupdated
              FROM x_fin_mg_pay_plan
             WHERE mgp_lic_number = i_licnum AND mgp_number = i_mgp_number;
         ELSE
            ROLLBACK;
            raise_application_error (
               -20017,
               'Payment details are being changed by other user');
         END IF;
      END IF;
   EXCEPTION
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20396, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20397, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_upd_minguarantee;
/*Procedure to del min gurantee plan Warner Payment :15-07-2015 :RAshmi Tijare*/
   PROCEDURE prc_alic_cm_del_mingua (
      i_mgp_number       IN     x_fin_mg_pay_plan.mgp_number%TYPE,
      i_lic_number       IN     x_fin_mg_pay_plan.mgp_lic_number%TYPE,
       i_entry_oper      IN     x_fin_mg_pay_plan.mgp_entry_oper%TYPE,
      i_update_count     IN     x_fin_mg_pay_plan.MGP_UPDATE_COUNT%TYPE,
      o_paymentdeleted      OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
      V_OPERATOR     Varchar2(70);
   BEGIN
      o_paymentdeleted := -1;

      SELECT pkg_cm_username.SetUserName (i_entry_oper)
        INTO V_OPERATOR
      FROM DUAL;

      BEGIN
         DELETE FROM x_fin_mg_pay_plan
               WHERE     mgp_lic_number = i_lic_number
                     AND mgp_number = i_mgp_number
                     AND NVL (MGP_UPDATE_COUNT, 0) = i_update_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_paymentdeleted := 1;
      ELSE
         RAISE deldatfailed;
      END IF;
   EXCEPTION
      WHEN deldatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20398, 'Data Not Deleted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20399, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_del_mingua;

   ---End Warner Payments



   /* PB (CR) :Pranay Kusumwal 21/06/2012 : Added for editing  new payment terms for royalty */
   -------------------------------------- PROCEDURE TO Add SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_alic_cm_insertsplitpayment (
      i_lic_number       IN     sgy_lic_split_payment.lsp_lic_number%TYPE,
      i_month_num        IN     sgy_lic_split_payment.lsp_split_month_num%TYPE,
      i_pct_pay          IN     sgy_lic_split_payment.lsp_percent_payment%TYPE,
      i_entry_oper       IN     sgy_lic_split_payment.lsp_entry_oper%TYPE,
      -- Pure Finance : Aditya Gupta
      i_lpy_number       IN     sgy_lic_split_payment.lsp_lpy_number%TYPE,
      -- end
      o_success_number      OUT NUMBER)
   AS
      insertfailed         EXCEPTION;
      l_flag               NUMBER;
      l_lsp_id             NUMBER;
      l_start              DATE;
      l_end                DATE;
      o_due_date           DATE;
      i_split_region       fid_licensee.lee_split_region%TYPE;
      l_split_pay_exists   NUMBER;
   BEGIN
      SELECT lic_start, lic_end
        INTO l_start, l_end
        FROM fid_license
       WHERE lic_number = i_lic_number;

      ---Dev2:Pure Finance:Start:[Hari_Mandal]_[19/4/2013]
      SELECT lee_split_region
        INTO i_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_lic_number);

      ---Dev2:Pure Finance:End--------------------------
      calc_pay_month (i_split_region,
                      l_start,
                      l_end,
                      NULL,
                      i_month_num,
                      o_due_date);
    --  DBMS_OUTPUT.put_line (o_due_date);
      l_lsp_id := seq_lic_split_payment.NEXTVAL;

      INSERT INTO sgy_lic_split_payment (lsp_id,
                                         lsp_lic_number,
                                         lsp_split_month_num,
                                         lsp_percent_payment,
                                         lsp_entry_oper,
                                         lsp_entry_date,
                                         lsp_due_date,
                                         -- Dev2: Pure Finance :Start:[Licence Maintenance Details]_[ADITYA GUPTA]_[2013/3/22]
                                         -- [License Maintenance Details Screen modifications]
                                         lsp_lpy_number -- Dev2: Pure Finance :End
                                                       )
           VALUES (l_lsp_id,
                   i_lic_number,
                   i_month_num,
                   i_pct_pay,
                   i_entry_oper,
                   SYSDATE,
                   o_due_date,
                   -- Dev2: Pure Finance :Start:[Licence Maintenance Details]_[ADITYA GUPTA]_[2013/3/22]
                   -- [License Maintenance Details Screen modifications]
                   i_lpy_number                     -- Dev2: Pure Finance :End
                               )
        RETURNING lsp_id
             INTO l_flag;

      IF (l_flag <> 0)
      THEN
         --Changes Done on 21-Feb-2014 by Hari Mandal
         --Setting lsp_is_split field to Y for split paymnets as it is used in Royalty Payment on Commencement date Report
         SELECT COUNT (1)
           INTO l_split_pay_exists
           FROM sgy_lic_split_payment
          WHERE lsp_lic_number = i_lic_number
                AND lsp_lpy_number = i_lpy_number;

         IF l_split_pay_exists > 0
         THEN
            UPDATE fid_license_payment_months
               SET lpy_is_split = 'Y',
                   lpy_entry_oper = i_entry_oper,
                   lpy_entry_date = SYSDATE
             WHERE lpy_number = i_lpy_number
                   AND lpy_lic_number = i_lic_number;
         END IF;

         ---------------------------End----------------------------------------------------
         COMMIT;
         o_success_number := l_flag;
      ELSE
         RAISE insertfailed;
      END IF;
   EXCEPTION
      WHEN insertfailed
      THEN
         ROLLBACK;
         raise_application_error (-20396, 'Data Not Inserted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20397, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_insertsplitpayment;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 21/06/2012 : Added for CR for new payment terms for royalty */
   -------------------------------------- PROCEDURE TO view SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_alic_cm_searchsplitpay (
      i_licnumber      IN     fid_license_payment_months.lpy_lic_number%TYPE,
      o_splitpayment      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
      l_lic_start      DATE;
      i_split_region   fid_licensee.lee_split_region%TYPE;
   BEGIN
      SELECT lic_start
        INTO l_lic_start
        FROM fid_license
       WHERE lic_number = i_licnumber;

      ---Dev2:Pure Finance:Start:[Hari_Mandal]_[19/4/2013]
      SELECT lee_split_region
        INTO i_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_licnumber);

      ---Dev2:Pure Finance:End--------------------------
      OPEN o_splitpayment FOR
           SELECT b.lsp_id lsp_id,
                  b.lsp_lic_number lsp_lic_number,
                  b.lsp_split_month_num lsp_split_month_num,
                  (b.lsp_due_date) split_month,
                  b.lsp_percent_payment lsp_percent_payment,
                  (SELECT 'Y'
                     FROM fid_financial_month
                    WHERE     fim_year = TO_CHAR (b.lsp_due_date, 'YYYY')
                          AND fim_month = TO_CHAR (b.lsp_due_date, 'MM')
                          AND fim_status <> 'C'
                          AND NVL (fim_split_region, 1) =
                                 DECODE (fim_split_region,
                                         NULL, 1,
                                         i_split_region))
                     iseditalbe,
                  (SELECT COUNT (*)
                     -- Abhinay_ACQ9 - Viewing paidnot-paid payments for Royalty licenses v1.0
                     FROM fid_payment
                    WHERE     pay_lic_number = b.lsp_lic_number
                          AND pay_split_id = b.lsp_id
                          AND pay_lic_number = i_licnumber
                          AND pay_status = 'P')
                     counts
             FROM sgy_lic_split_payment b
            WHERE lsp_lic_number = i_licnumber
         ORDER BY b.lsp_split_month_num;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_searchsplitpay;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   ------------------------------------- PROCEDURE TO DELETE PAYMENT -----------------------------------------
   PROCEDURE prc_alic_cm_deletesplitpayment (
      i_lsp_id           IN     sgy_lic_split_payment.lsp_id%TYPE,
      i_lic_number       IN     sgy_lic_split_payment.lsp_lic_number%TYPE,
      o_paymentdeleted      OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
   BEGIN
      o_paymentdeleted := -1;

      BEGIN
         DELETE FROM sgy_lic_split_payment
               WHERE lsp_id = i_lsp_id AND lsp_lic_number = i_lic_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_paymentdeleted := 1;
      ELSE
         RAISE deldatfailed;
      END IF;
   EXCEPTION
      WHEN deldatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20398, 'Data Not Deleted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20399, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_deletesplitpayment;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 21/06/2012 : Added for editing  new payment terms for royalty */
   -------------------------------------- PROCEDURE TO view SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_alic_cm_editsplitpayment (
      i_lsp_id           IN     sgy_lic_split_payment.lsp_id%TYPE,
      i_lic_number       IN     sgy_lic_split_payment.lsp_lic_number%TYPE,
      i_month_num        IN     sgy_lic_split_payment.lsp_split_month_num%TYPE,
      i_pct_pay          IN     sgy_lic_split_payment.lsp_percent_payment%TYPE,
      i_entry_oper       IN     sgy_lic_split_payment.lsp_entry_oper%TYPE,
      -- Pure Finance : Aditya Gupta
      i_lpy_number       IN     sgy_lic_split_payment.lsp_lpy_number%TYPE,
      -- end
      o_success_number      OUT NUMBER)
   AS
      updatfailed      EXCEPTION;
      l_flag           NUMBER;
      l_start          DATE;
      l_end            DATE;
      o_due_date       DATE;
      i_split_region   fid_licensee.lee_split_region%TYPE;
   BEGIN
      SELECT lic_start, lic_end
        INTO l_start, l_end
        FROM fid_license
       WHERE lic_number = i_lic_number;

      ---Dev2:Pure Finance:Start:[Hari_Mandal]_[19/4/2013]
      SELECT lee_split_region
        INTO i_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_lic_number);

      ---Dev2:Pure Finance:End--------------------------
      calc_pay_month (i_split_region,
                      l_start,
                      l_end,
                      NULL,
                      i_month_num,
                      o_due_date);

         UPDATE sgy_lic_split_payment
            SET lsp_split_month_num = i_month_num,
                lsp_percent_payment = i_pct_pay,
                lsp_entry_oper = i_entry_oper,
                lsp_due_date = o_due_date,
                lsp_entry_date = SYSDATE,
                -- Dev2: Pure Finance :Start:[Licence Maintenance Details]_[ADITYA GUPTA]_[2013/3/22]
                -- [License Maintenance Details Screen modifications]
                lsp_lpy_number = i_lpy_number,
                lsp_paid_ind = 'N'
          -- Dev2: Pure Finance :End
          WHERE lsp_lic_number = i_lic_number AND lsp_id = i_lsp_id
      RETURNING lsp_id
           INTO l_flag;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_success_number := l_flag;
      ELSE
         RAISE updatfailed;
      END IF;
   EXCEPTION
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20396, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20397, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_editsplitpayment;

   /* PB (CR) : End */

   --****************************************************************
   -- This procedure updates License Royalty Plan details.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_editroyalpayplan (
      i_lpynumber        IN     fid_license_payment_months.lpy_number%TYPE,
      i_lpylicnumber     IN     fid_license_payment_months.lpy_lic_number%TYPE,
      i_lpypaymonthno    IN     fid_license_payment_months.lpy_pay_month_no%TYPE,
      i_lpypaymonth      IN     fid_license_payment_months.lpy_pay_month%TYPE,
      i_lpypaypercent    IN     fid_license_payment_months.lpy_pay_percent%TYPE,
      i_lpycurcode       IN     fid_license_payment_months.lpy_cur_code%TYPE,
      i_lpypaycode       IN     fid_license_payment_months.lpy_pay_code%TYPE,
      i_lpyupdatecount   IN     fid_license_payment_months.lpy_update_count%TYPE,
      i_entryoper        IN     fid_license_payment_months.lpy_entry_oper%TYPE,
      o_status              OUT NUMBER)
   AS
      CURSOR lictype
      IS
         SELECT lic_type
           FROM fid_license
          WHERE lic_number = i_lpylicnumber;

      l_lictype           fid_license.lic_type%TYPE;

      CURSOR lpypaidind
      IS
         SELECT lpy_paid_ind
           FROM fid_license_payment_months
          WHERE lpy_number = i_lpynumber;

      l_lpypaidind        fid_license_payment_months.lpy_paid_ind%TYPE;
      nonroyaltylicense   EXCEPTION;
      updatefailed        EXCEPTION;
      paidtransaction     EXCEPTION;
   BEGIN
      OPEN lictype;

      FETCH lictype INTO l_lictype;

      IF UPPER (l_lictype) = 'ROY'
      THEN
         OPEN lpypaidind;

         FETCH lpypaidind INTO l_lpypaidind;

         IF NVL (l_lpypaidind, 'N') <> 'Y'
         THEN
               UPDATE fid_license_payment_months
                  SET lpy_pay_month_no = i_lpypaymonthno,
                      lpy_pay_month = i_lpypaymonth,
                      lpy_pay_percent = i_lpypaypercent,
                      lpy_cur_code = UPPER (i_lpycurcode),
                      lpy_pay_code = UPPER (i_lpypaycode),
                      lpy_entry_oper = i_entryoper,
                      lpy_entry_date = SYSDATE,
                      lpy_update_count = NVL (lpy_update_count, 0) + 1
                WHERE NVL (lpy_update_count, 0) = i_lpyupdatecount
                      AND lpy_number = i_lpynumber
            RETURNING lpy_update_count
                 INTO o_status;

            IF o_status > 0
            THEN
               COMMIT;
            ELSE
               ROLLBACK;
               RAISE updatefailed;
            END IF;
         ELSE
            RAISE paidtransaction;
         END IF;
      ELSE
         RAISE nonroyaltylicense;
      END IF;
   EXCEPTION
      WHEN nonroyaltylicense
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Non royalty license. No update.');
      WHEN paidtransaction
      THEN
         ROLLBACK;
         raise_application_error (
            -20100,
            'Warning - Payment Date cannot be changed for Paid transaction.');
      WHEN updatefailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := '-1';
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_editroyalpayplan;

   ----Added for Biscope by Pranay Kusumwal 08/05/2012   Start---
   -----Updating Month and Date--------
   PROCEDURE prc_alic_cm_updateroyplandate (
      i_lpynumber        IN     fid_license_payment_months.lpy_number%TYPE,
      i_lpylicnumber     IN     fid_license_payment_months.lpy_lic_number%TYPE,
      i_lpypaymonthno    IN     fid_license_payment_months.lpy_pay_month_no%TYPE,
      i_lpypayislastmonth    IN     fid_license_payment_months.lpy_pay_islastmonth%TYPE, --Onsite.Dev:BR_15_321
      i_lpypaymonth      IN     fid_license_payment_months.lpy_pay_month%TYPE,
      i_lpyupdatecount   IN     fid_license_payment_months.lpy_update_count%TYPE,
      i_entryoper        IN     fid_license_payment_months.lpy_entry_oper%TYPE,
      o_status              OUT NUMBER)
   AS
      CURSOR lictype
      IS
         SELECT lic_type
           FROM fid_license
          WHERE lic_number = i_lpylicnumber;

      l_lictype           fid_license.lic_type%TYPE;

      CURSOR lpypaidind
      IS
         SELECT lpy_paid_ind
           FROM fid_license_payment_months
          WHERE lpy_number = i_lpynumber;

      l_lpypaidind        fid_license_payment_months.lpy_paid_ind%TYPE;
      nonroyaltylicense   EXCEPTION;
      updatefailed        EXCEPTION;
      closedmonth         EXCEPTION;
      -- Dev2: Pure Finance: Start:[Licence Maintenance]_[ADITYA GUPTA]_[2013/3/25]
      -- [License Maintenance Screen modifications for incorporating check for due-date to be in open financial month]
      l_pay_due           DATE;
      l_fim_status        VARCHAR (1);
      l_split_region      fid_licensee.lee_split_region%TYPE;
      l_closed_month      NUMBER;
   -- Dev2: Pure Finance: End
   BEGIN
      SELECT lee_split_region
        INTO l_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_lpylicnumber);

      SELECT COUNT (*)
        INTO l_closed_month
        FROM fid_financial_month
       WHERE fim_status = 'C'
             AND i_lpypaymonth BETWEEN TO_DATE (fim_year || fim_month,
                                                'RRRRMM')
                                   AND LAST_DAY (
                                          TO_DATE (fim_year || fim_month,
                                                   'RRRRMM'))
             AND NVL (fim_split_region, 1) =
                    DECODE (fim_split_region, NULL, 1, l_split_region);

      IF l_closed_month > 0
      THEN
         RAISE closedmonth;
      END IF;

      OPEN lictype;

      FETCH lictype INTO l_lictype;

      IF UPPER (l_lictype) = 'ROY'
      THEN
         OPEN lpypaidind;

         FETCH lpypaidind INTO l_lpypaidind;

         -- Dev2: Pure Finance: Start:[Licence Maintenance]_[ADITYA GUPTA]_[2013/3/25]
         -- [License Maintenance Screen modifications for incorporating check for due-date to be in open financial month]
         SELECT lpy_pay_month
           INTO l_pay_due
           FROM fid_license_payment_months
          WHERE lpy_lic_number = i_lpylicnumber AND lpy_number = i_lpynumber;

         --DBMS_OUTPUT.put_line ('l_pay_due:' || l_pay_due);

         /* SELECT fim_status
            INTO l_fim_status
            FROM fid_financial_month
           WHERE fim_month = TO_CHAR (l_pay_due, 'MM')
                 AND fim_year = TO_CHAR (l_pay_due, 'YYYY')
                 AND fim_split_region =
                        (SELECT lee_split_region
                           FROM fid_licensee
                          WHERE lee_number =
                                   (SELECT lic_lee_number
                                      from fid_license
                                     WHERE lic_number = i_lpylicnumber));*/

         -- Dev2: Pure Finance: End
         IF ( (NVL (l_lpypaidind, 'N') <> 'Y'))
         -- Dev2: Pure Finance: Start:[Licence Maintenance]_[ADITYA GUPTA]_[2013/3/25]
         -- [License Maintenance Screen modifications for incorporating check for due-date to be in open financial month]
         -- Dev2: Pure Finance: End
         THEN
            SELECT COUNT (*)
              INTO l_closed_month
              FROM fid_financial_month
             WHERE fim_status = 'C'
                   AND l_pay_due BETWEEN TO_DATE (fim_year || fim_month,
                                                  'RRRRMM')
                                     AND LAST_DAY (
                                            TO_DATE (fim_year || fim_month,
                                                     'RRRRMM'))
                   AND NVL (fim_split_region, 1) =
                          DECODE (fim_split_region, NULL, 1, l_split_region);

            --DBMS_OUTPUT.put_line ('l_closed_month:' || l_closed_month);

            IF l_closed_month > 0
            THEN
               RAISE closedmonth;
            END IF;

               UPDATE fid_license_payment_months
                  SET lpy_pay_month_no = i_lpypaymonthno,
                      lpy_pay_month = i_lpypaymonth,
                      lpy_pay_islastmonth= i_lpypayislastmonth,--Onsite.Dev:BR_15_321
                      lpy_entry_oper = i_entryoper,
                      lpy_entry_date = SYSDATE,
                      lpy_update_count = NVL (lpy_update_count, 0) + 1,
                      -- Dev2: Pure Finance: Start:[Licence Maintenance]_[ADITYA GUPTA]_[2013/3/25]
                      -- [License Maintenance Screen modifications for incorporating check for due-date to be in open financial month]
                      lpy_paid_ind = 'N'
                -- Dev2: Pure Finance: End
                WHERE NVL (lpy_update_count, 0) = i_lpyupdatecount
                      AND lpy_number = i_lpynumber
            RETURNING lpy_update_count
                 INTO o_status;
         ---Pure Finance:Start:[Hari Mandal]_[24/05/2013]
         ELSE
            SELECT COUNT (*)
              INTO l_closed_month
              FROM fid_financial_month
             WHERE fim_status = 'C'
                   AND l_pay_due BETWEEN TO_DATE (fim_year || fim_month,
                                                  'RRRRMM')
                                     AND LAST_DAY (
                                            TO_DATE (fim_year || fim_month,
                                                     'RRRRMM'))
                   AND NVL (fim_split_region, 1) =
                          DECODE (fim_split_region, NULL, 1, l_split_region);

            --DBMS_OUTPUT.put_line ('l_closed_month:' || l_closed_month);

            IF l_closed_month > 0
            THEN
               RAISE closedmonth;
            END IF;

               UPDATE fid_license_payment_months
                  SET lpy_pay_month_no = i_lpypaymonthno,
                      lpy_pay_month = i_lpypaymonth,
                      lpy_pay_islastmonth= i_lpypayislastmonth,--Onsite.Dev:BR_15_321
                      lpy_entry_oper = i_entryoper,
                      lpy_entry_date = SYSDATE,
                      lpy_paid_ind = 'N',
                      lpy_update_count = NVL (lpy_update_count, 0) + 1
                WHERE NVL (lpy_update_count, 0) = i_lpyupdatecount
                      AND lpy_number = i_lpynumber
            RETURNING lpy_update_count
                 INTO o_status;
         END IF;

         UPDATE sgy_lic_split_payment
            SET lsp_paid_ind = 'N', lsp_due_date = i_lpypaymonth
          WHERE lsp_lpy_number = i_lpynumber
                AND lsp_lic_number = i_lpylicnumber;

         ---Pure Finance:End-----------------------------
         IF o_status > 0
         THEN
            COMMIT;
         ELSE
            ROLLBACK;
            RAISE updatefailed;
         END IF;
      --  ELSE
      --  raise paidtransaction;
      --  end if;
      ELSE
         RAISE nonroyaltylicense;
      END IF;
   EXCEPTION
      WHEN nonroyaltylicense
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Non royalty license. No update.');
      WHEN closedmonth
      THEN
         ROLLBACK;
         raise_application_error (
            -20100,
            'The payment month is in closed financial month');
      WHEN updatefailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := '-1';
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_updateroyplandate;

   -------Bioscope changes end By Pranay Kusumwal------------

   --****************************************************************
   -- This procedure searches License Payment Schedule Plan.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_searchpayschedule (
      i_licnumber        IN     fid_license_vw.lic_number%TYPE,
      o_searchlicenses      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
   BEGIN
      OPEN o_searchlicenses FOR
           SELECT flv.lic_status,
                  flv.gen_title,
                  (SELECT ROUND (SUM (lsl_lee_price), 4)
                     FROM x_fin_lic_sec_lee
                    WHERE lsl_lic_number = i_licnumber)
                     lic_price,
                  -- round (flv.lic_price, 4) lic_price,
                  flv.lic_currency,
                  (SELECT lee_short_name
                     FROM fid_licensee
                    WHERE lee_number = lsl.lsl_lee_number)
                     lee_short_name,
                  flv.lic_type,
                  flv.lic_con_number,
                  flv.lic_lee_number,
                  flv.con_short_name,
                  flv.lic_number,
                  fp.pay_lic_number,
                  fp.pay_number,
                  fp.pay_entry_oper,
                  fp.pay_entry_date,
                  fp.pay_con_number,
                  fp.pay_source_com_number,
                  fp.pay_target_com_number,
                  fp.pay_cur_code,
                  ROUND (fp.pay_rate, 4) pay_rate,
                  fp.pay_code,
                  fp.pay_amount,
                  fp.pay_due,
                  fp.pay_date,
                  fp.pay_status,
                  fp.pay_status_date,
                  fp.pay_comment,
                  fp.pay_reference,
                  fpt.pat_desc,
                  ----FIN8 Added by nishant --
                  fp.pay_month_no                                       ---end
                                 ---Dev2:Pure Finance:Start:[Hari Mandal]_[12/04/2013]------
                  ,
                  fp.PAY_MNET_REFERENCE -- #region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
             FROM fid_license_vw flv,
                  fid_payment fp,
                  fid_payment_type fpt,
                  x_fin_lic_sec_lee lsl
            WHERE     fpt.pat_code = fp.pay_code
                  AND fp.pay_cur_code = flv.lic_currency
                  AND fp.pay_con_number = flv.lic_con_number
                  AND flv.lic_number = lsl.lsl_lic_number
                  AND fp.pay_lsl_number = lsl.lsl_number
                  ---Dev2:Pure Finance:End------------------------------------------
                  AND fp.pay_lic_number = lsl.lsl_lic_number
                  AND fp.pay_lic_number = flv.lic_number
                  AND flv.lic_number = i_licnumber
         ORDER BY flv.lic_con_number,
                  flv.gen_title,
                  flv.lic_number,
                  fp.pay_due;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_searchpayschedule;

   --****************************************************************
   -- This procedure validates license status C.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_validatelicstatus (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      o_status         OUT NUMBER)
   AS
      CURSOR get_sched
      IS
         SELECT sch_date, sch_cha_number
           FROM fid_schedule
          WHERE sch_lic_number = i_licnumber;

      v_sch_date       DATE;
      v_sch_cha        NUMBER;

      CURSOR get_cha_name
      IS
         SELECT cha_short_name
           FROM fid_channel
          WHERE cha_number = v_sch_cha;

      v_cha_name       VARCHAR2 (4);
      scheduleexists   EXCEPTION;
      costexists       EXCEPTION;
      cost_total       NUMBER;
      asset_value      NUMBER;
   BEGIN
      OPEN get_sched;

      FETCH get_sched
      INTO v_sch_date, v_sch_cha;

      IF get_sched%FOUND
      THEN
         o_status := -1;

         OPEN get_cha_name;

         FETCH get_cha_name INTO v_cha_name;

         RAISE scheduleexists;
      END IF;

      SELECT SUM (lis_con_actual + lis_con_adjust), SUM (lis_con_forecast)
        INTO cost_total, asset_value
        FROM fid_license_sub_ledger
       WHERE lis_lic_number = i_licnumber;

      IF cost_total != 0
      THEN
         o_status := -1;
         RAISE costexists;
      END IF;

      o_status := 1;
   EXCEPTION
      WHEN scheduleexists
      THEN
         raise_application_error (
            -20601,
               'This license is scheduled for channel '
            || v_cha_name
            || ' on '
            || v_sch_date
            || ' - No cancel allowed.');
      WHEN costexists
      THEN
         raise_application_error (
            -20601,
            'This license has been costed - No cancel allowed.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_validatelicstatus;

   --****************************************************************
   -- This procedure validates license TBA.
   -- This procedure input is license Number.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_tbachanged (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      o_status         OUT NUMBER)
   AS
      CURSOR get_sched_past
      IS
         SELECT sch_date, sch_cha_number
           FROM fid_schedule
          WHERE sch_date < SYSDATE AND sch_lic_number = i_licnumber;

      CURSOR get_sched_future
      IS
         SELECT sch_date, sch_cha_number
           FROM fid_schedule
          WHERE sch_date >= SYSDATE AND sch_lic_number = i_licnumber;

      v_sch_date             DATE;
      v_sch_cha              NUMBER;

      CURSOR get_cha_name
      IS
         SELECT cha_short_name
           FROM fid_channel
          WHERE cha_number = v_sch_cha;

      v_cha_name             VARCHAR2 (4);
      pastscheduleexists     EXCEPTION;
      futurescheduleexists   EXCEPTION;
   BEGIN
      OPEN get_sched_past;

      FETCH get_sched_past
      INTO v_sch_date, v_sch_cha;

      IF get_sched_past%FOUND
      THEN
         OPEN get_cha_name;

         FETCH get_cha_name INTO v_cha_name;

         CLOSE get_cha_name;

         o_status := -1;
         RAISE pastscheduleexists;
      ELSE
         OPEN get_sched_future;

         FETCH get_sched_future
         INTO v_sch_date, v_sch_cha;

         IF get_sched_future%FOUND
         THEN
            OPEN get_cha_name;

            FETCH get_cha_name INTO v_cha_name;

            CLOSE get_cha_name;

            o_status := -1;
            RAISE futurescheduleexists;
         END IF;
      END IF;

      o_status := 1;
   EXCEPTION
      WHEN pastscheduleexists
      THEN
         raise_application_error (
            -20601,
               'This license was scheduled for channel '
            || v_cha_name
            || ' on '
            || v_sch_date
            || ' - Cannot change period to TBA.');
      WHEN futurescheduleexists
      THEN
         raise_application_error (
            -20601,
               'This license is scheduled for channel '
            || v_cha_name
            || ' on '
            || v_sch_date
            || ' - Delete schedule entries before period change');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_tbachanged;

   --****************************************************************
   -- This procedure validates license start date.
   -- This procedure input is license Number and modified license end date.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_validatestartdate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licstart    IN     fid_license.lic_start%TYPE,
      o_status         OUT NUMBER)
   AS
      CURSOR c1
      IS
         SELECT 'X'
           FROM fid_schedule
          WHERE sch_fin_actual_date < i_licstart --sch_date < i_licstart 15Apr2015:Issue :Jawahar : Allowing to schedule after lic_end date for midnight schedule after 12. Used sch_fin_actual_date.
                AND sch_lic_number = i_licnumber;

      dummy            VARCHAR2 (1);
      scheduleexists   EXCEPTION;
   BEGIN
      OPEN c1;

      FETCH c1 INTO dummy;

      IF c1%FOUND
      THEN
         o_status := -1;
         RAISE scheduleexists;
      END IF;

      CLOSE c1;

      o_status := 1;
   EXCEPTION
      WHEN scheduleexists
      THEN
         raise_application_error (-20601,
                                  'License is scheduled before this date.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_validatestartdate;

   --****************************************************************
   -- This procedure validates license end date.
   -- This procedure input is license Number and modified license end date.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_validateenddate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licend      IN     fid_license.lic_end%TYPE,
      o_status         OUT NUMBER)
   AS
      CURSOR c1
      IS
         SELECT 'X'
           FROM Fid_Schedule
          Where To_Date (
                   to_char(sch_fin_actual_date,'DD-MON-RRRR') || ' ' || CONVERT_TIME_N_C (SCH_TIME),
                   'DD-MON-RRRR HH24:MI:SS') >=
                   To_Date (To_Char(I_Licend,'DD-MON-RRRR') || ' ' || '20:00:00',
                            'DD-MON-RRRR HH24:MI:SS') --sch_date > i_licend --7May2015:Jawahar:Business req: Not allowed to schedule before 4 hrs of lic end date
                AND sch_lic_number = i_licnumber;

      dummy            VARCHAR2 (1);
      scheduleexists   EXCEPTION;
   BEGIN
      OPEN c1;

      FETCH c1 INTO dummy;

      IF c1%FOUND
      THEN
         o_status := -1;
         RAISE scheduleexists;
      END IF;

      CLOSE c1;

      o_status := 1;
   EXCEPTION
      WHEN scheduleexists
      THEN
         raise_application_error (-20601,
                                  'License is scheduled after this date.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_validateenddate;

   --****************************************************************
   -- This procedure is for LOV.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_channelservice (
      o_chansrvcname OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
   BEGIN
      OPEN o_chansrvcname FOR
         SELECT chs_short_name, 'Service ' || chs_name
           FROM fid_channel_service
         UNION
         SELECT cha_short_name, 'Channel ' || cha_name FROM fid_channel
         ORDER BY 2, 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_channelservice;

   --****************************************************************
   -- This procedure is for LOV.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_lcrchashortname (
      i_licchsnumber      IN     fid_license.lic_chs_number%TYPE,
      o_lcrchashortname      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
   BEGIN
      OPEN o_lcrchashortname FOR
         SELECT cha_short_name, cha_name, cha_number
           FROM fid_channel, fid_channel_service_channel
          WHERE cha_number = csc_cha_number
                AND csc_chs_number = i_licchsnumber
         UNION
         SELECT cha_short_name, cha_name, cha_number
           FROM fid_channel, fid_channel_service
          WHERE cha_number = chs_cha_number AND chs_number = i_licchsnumber;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_lcrchashortname;

   --****************************************************************
   -- This procedure is default.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE calc_pay_month (l_split_region    IN     NUMBER,
                             l_lic_start       IN     DATE,
                             l_lic_end         IN     DATE,
                             l_lic_tba         IN     VARCHAR2,
                             l_lpy_month_no    IN     NUMBER,
                             l_lpy_pay_month      OUT DATE)
   IS
      CURSOR get_fin_month
      IS
         SELECT TO_DATE ('01' || LPAD (fim_month, 2, 0) || fim_year,
                         'DDMMYYYY')
           FROM fid_financial_month
          WHERE fim_status = 'O'
                AND NVL (fim_split_region, 1) =
                       DECODE (fim_split_region, NULL, 1, l_split_region);

      v_add_month             DATE;
      v_cur_month             DATE;
      financialmonthnotopen   EXCEPTION;
   BEGIN
      OPEN get_fin_month;

      FETCH get_fin_month INTO v_cur_month;

      IF get_fin_month%NOTFOUND
      THEN
         RAISE financialmonthnotopen;
      END IF;

      IF NVL (l_lic_tba, 'N') = 'Y'
      THEN
         l_lpy_pay_month := NULL;
      ELSE
         v_add_month :=
            TO_DATE (
               '01-'
               || TO_CHAR (ADD_MONTHS (l_lic_start, l_lpy_month_no - 1),
                           'MON-YYYY'),
               'DD-MON-YYYY');



         IF v_add_month < v_cur_month
         THEN
            ---l_lpy_pay_month := v_add_month;
            l_lpy_pay_month := v_cur_month;

         ELSE
            IF v_add_month > l_lic_end
            THEN
               IF l_lic_end < v_cur_month
               THEN
                  l_lpy_pay_month := v_cur_month;

               ELSE
                  l_lpy_pay_month := l_lic_end;

               END IF;
            ELSE
               l_lpy_pay_month := v_add_month;
            END IF;
         END IF;


         l_lpy_pay_month :=
            TO_DATE ('01-' || TO_CHAR (l_lpy_pay_month, 'MON-YYYY'),
                     'DD-MON-YYYY');
      END IF;
   EXCEPTION
      WHEN financialmonthnotopen
      THEN
         raise_application_error (
            -20601,
            'No financial month open. Contact your database supervisor.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END calc_pay_month;

   --****************************************************************
   -- This procedure validates license start date for catch up.
   -- CP R1 mrunmayi kusurkar
   --****************************************************************
   PROCEDURE prc_cp_validatestartdate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licstart    IN     fid_license.lic_start%TYPE,
      o_status         OUT NUMBER)
   AS
      l_media_ser_code   VARCHAR2 (25);

      CURSOR c1
      IS
         SELECT 'X'
           FROM x_cp_play_list
          WHERE plt_sch_start_date < i_licstart
                AND plt_lic_number = i_licnumber;

      dummy              VARCHAR2 (1);
      scheduleexists     EXCEPTION;
   BEGIN
      OPEN c1;

      SELECT MS_MEDIA_SERVICE_CODE
        INTO l_media_ser_code
        FROM fid_license, SGY_PB_MEDIA_SERVICE
       WHERE ms_media_service_flag = lic_catchup_flag
             AND lic_number = i_licnumber;

      FETCH c1 INTO dummy;

      IF c1%FOUND
      THEN
         o_status := -1;
         RAISE scheduleexists;
      END IF;

      CLOSE c1;

      o_status := 1;
   EXCEPTION
      WHEN scheduleexists
      THEN
         raise_application_error (
            -20601,
            l_media_ser_code || ' License is scheduled before this date.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_cp_validatestartdate;

   -- This procedure validates license end date of catch up..
   PROCEDURE prc_cp_validateenddate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licend      IN     fid_license.lic_end%TYPE,
      o_status         OUT NUMBER)
   AS
      l_media_ser_code   VARCHAR2 (25);

      CURSOR c1
      IS
         SELECT 'X'
           FROM x_cp_play_list
          WHERE plt_sch_end_date > i_licend AND plt_lic_number = i_licnumber;

      dummy              VARCHAR2 (1);
      scheduleexists     EXCEPTION;
   BEGIN
      OPEN c1;

      SELECT MS_MEDIA_SERVICE_CODE                                 --by rashmi
        INTO l_media_ser_code
        FROM fid_license, SGY_PB_MEDIA_SERVICE
       WHERE ms_media_service_flag = lic_catchup_flag
             AND lic_number = i_licnumber;

      FETCH c1 INTO dummy;

      IF c1%FOUND
      THEN
         o_status := -1;
         RAISE scheduleexists;
      END IF;

      CLOSE c1;

      o_status := 1;
   EXCEPTION
      WHEN scheduleexists
      THEN
         raise_application_error (
            -20601,
            l_media_ser_code || ' License is scheduled after this date.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_cp_validateenddate;

   --****************************************************************
   -- This procedure validates license status C.
   -- for catch up.
   --****************************************************************
   PROCEDURE prc_cp_validatelicstatus (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      o_status         OUT NUMBER)
   AS
      l_count            NUMBER;
      costexists         EXCEPTION;
      scheduleexists     EXCEPTION;
      cost_total         NUMBER;
      asset_value        NUMBER;
      -- Dev.R5 : SVOD Implementation : Start : [SVOD Finance]_[Shubhada Bongarde]_[2015/04/17]
      l_amort_code       VARCHAR2 (1);
      -- Dev.R5 : SVOD Implementation : End
      l_media_ser_code   VARCHAR2 (25); --SACQ02 :SVOD_CR[Rashmi Tijare][08/06/2015]
   BEGIN
      SELECT COUNT (1)
        INTO l_count
        FROM x_cp_play_list
       WHERE plt_lic_number = i_licnumber;

      -- Dev.R5 : SVOD Implementation : Start : [SVOD Finance]_[Shubhada Bongarde]_[2015/04/17]
      SELECT lic_amort_code
        INTO l_amort_code
        FROM fid_license
       WHERE lic_number = i_licnumber;

      -- Dev.R5 : SVOD Implementation : End
      IF l_count > 0
      THEN
         RAISE scheduleexists;
      END IF;

      -- Dev.R5 : SVOD Implementation : Start : [SVOD Finance]_[Shubhada Bongarde]_[2015/04/17]
      IF l_amort_code <> 'A'
      THEN
         -- Dev.R5 : SVOD Implementation : End
         SELECT SUM (lis_con_actual + lis_con_adjust), SUM (lis_con_forecast)
           INTO cost_total, asset_value
           FROM fid_license_sub_ledger
          WHERE lis_lic_number = i_licnumber;

         IF cost_total != 0
         THEN
            o_status := -1;
            RAISE costexists;
         END IF;
      END IF;

      o_status := 1;
   EXCEPTION
      WHEN scheduleexists
      THEN
         raise_application_error (
            -20601,
            'This license is scheduled. No cancel allowed.');
      WHEN costexists
      THEN
         raise_application_error (
            -20601,
            'This license has been costed - No cancel allowed.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_cp_validatelicstatus;

   --****************************************************************
   -- This procedure validates catchup license TBA.
   --****************************************************************
   PROCEDURE prc_cp_tbachanged (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      o_status         OUT NUMBER)
   AS
      l_cnt                  NUMBER;
      l_cnt1                 NUMBER;
      pastscheduleexists     EXCEPTION;
      futurescheduleexists   EXCEPTION;
   BEGIN
      SELECT COUNT (1)
        INTO l_cnt
        FROM x_cp_play_list
       WHERE plt_sch_start_date < SYSDATE AND plt_lic_number = i_licnumber;

      SELECT COUNT (1)
        INTO l_cnt1
        FROM x_cp_play_list
       WHERE plt_sch_end_date >= SYSDATE AND plt_lic_number = i_licnumber;

      IF l_cnt > 0
      THEN
         RAISE pastscheduleexists;
      END IF;

      IF l_cnt1 > 0
      THEN
         RAISE futurescheduleexists;
      END IF;

      o_status := 1;
   EXCEPTION
      WHEN pastscheduleexists
      THEN
         raise_application_error (
            -20601,
            'This license was scheduled.Cannot change period to TBA.');
      WHEN futurescheduleexists
      THEN
         raise_application_error (
            -20601,
            'This license is Scheduled. Delete Scheduled entries before changing it to TBA.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_cp_tbachanged;

   -- ***************end

   ---- Start -- changes for FIN3 by Nishant Ankam
   PROCEDURE prc_search_lee_allocation (
      i_lic_number   IN     x_fin_lic_sec_lee.lsl_lic_number%TYPE,
      o_sec_lee         OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
   BEGIN
      OPEN o_sec_lee FOR
         SELECT lsl_number,
                lsl_lee_number,
                (SELECT lee_short_name
                   FROM fid_licensee
                  WHERE lee_number = lsl_lee_number)
                   lsl_lee_name,
                ROUND (lsl_lee_price, 4) lsl_lee_price,
                lsl_is_primary,
                lsl_update_count
           FROM x_fin_lic_sec_lee
          WHERE lsl_lic_number = i_lic_number;
   END;

   PROCEDURE prc_add_lee_allocation (
      i_lic_number           IN     x_fin_lic_sec_lee.lsl_lic_number%TYPE,
      i_lic_lee_number       IN     x_fin_lic_sec_lee.lsl_lee_number%TYPE,
      i_lic_lee_alloc        IN     x_fin_lic_sec_lee.lsl_lee_price%TYPE,
      i_lee_is_primary       IN     x_fin_lic_sec_lee.lsl_is_primary%TYPE,
      i_lic_lee_entry_opr    IN     x_fin_lic_sec_lee.lsl_entry_oper%TYPE,
      i_lic_lee_entry_date   IN     x_fin_lic_sec_lee.lsl_entry_date%TYPE,
      o_status                  OUT NUMBER)
   AS
      l_status            NUMBER;
      --
      --l_prmry_lee_no NUMBER;
      l_prmry_region      NUMBER;
      l_sec_region        NUMBER;
      l_get_sequence      NUMBER;
      l_mem_number        NUMBER;
      l_lsl_number        x_fin_lic_sec_lee.lsl_number%TYPE;
      totalpay            NUMBER;
      l_lsl_number1       NUMBER;
      l_total_pay_price   NUMBER;
      l_extra_pay_amt     NUMBER;
      l_pay_number        NUMBER;
   BEGIN
      SELECT lee_split_region
        INTO l_prmry_region
        FROM fid_licensee
       WHERE lee_number IN
                (SELECT lsl_lee_number
                   FROM x_fin_lic_sec_lee
                  WHERE lsl_is_primary = 'Y'
                        AND lsl_lic_number = i_lic_number);

      SELECT lee_split_region
        INTO l_sec_region
        FROM fid_licensee
       WHERE lee_number = i_lic_lee_number;

      SELECT x_seq_lic_sec_lee.NEXTVAL INTO l_get_sequence FROM DUAL;

      IF (l_prmry_region = l_sec_region)
      THEN
         INSERT INTO x_fin_lic_sec_lee
              VALUES (l_get_sequence,
                      i_lic_number,
                      i_lic_lee_number,
                      i_lic_lee_alloc,
                      i_lee_is_primary,
                      i_lic_lee_entry_opr,
                      i_lic_lee_entry_date,
                      0,
                      NULL,
                      -- modified by
                      NULL                                      -- modified on
                          );

         l_status := SQL%ROWCOUNT;
      ELSE
         raise_application_error (
            -20103,
            'Licensee is not under primary licensee region');
         o_status := -1;
      END IF;

      IF (l_status <> 0)
      THEN
         COMMIT;
         o_status := l_get_sequence;
      ELSE
         ROLLBACK;
         raise_application_error (-20103, 'Not inserted successfully.');
         o_status := -1;
      END IF;

      SELECT lic_mem_number
        INTO l_mem_number
        FROM fid_license
       WHERE lic_number = i_lic_number;

      IF i_lic_lee_alloc <> 0
      THEN
         SELECT lsl_number
           INTO l_lsl_number
           FROM x_fin_lic_sec_lee
          WHERE lsl_lic_number = i_lic_number AND lsl_is_primary = 'Y';

         SELECT ROUND (NVL (SUM (pay_amount), 0), 2)
           INTO totalpay
           FROM fid_payment
          WHERE pay_lsl_number = l_lsl_number;

         FOR lsl_c
            IN (SELECT lsl_number, lsl_lee_price
                  FROM x_fin_lic_sec_lee
                 WHERE lsl_lic_number = i_lic_number
                       AND lsl_lee_number = i_lic_lee_number)
         LOOP
            l_lsl_number1 := lsl_c.lsl_number;

            FOR pay IN (SELECT pay_source_com_number,
                               pay_target_com_number,
                               pay_con_number,
                               pay_cur_code,
                               pay_code,
                               pay_amount,
                               pay_status,
                               pay_due,
                               pay_month_no
                          FROM fid_payment
                         WHERE pay_lsl_number = l_lsl_number)
            LOOP
               BEGIN
                  INSERT INTO fid_payment (pay_number,
                                           pay_source_com_number,
                                           pay_target_com_number,
                                           pay_con_number,
                                           pay_lic_number,
                                           pay_status,
                                           pay_status_date,
                                           pay_amount,
                                           pay_cur_code,
                                           pay_rate,
                                           pay_code,
                                           pay_due,
                                           pay_reference,
                                           pay_comment,
                                           pay_supplier_invoice,
                                           pay_entry_date,
                                           pay_entry_oper,
                                           pay_month_no,
                                           pay_lsl_number,
                                           pay_original_payment,
                                           pay_payment_pct)
                       VALUES (
                                 seq_pay_number.NEXTVAL,
                                 pay.pay_source_com_number,
                                 pay.pay_target_com_number,
                                 pay.pay_con_number,
                                 i_lic_number,
                                 'N',
                                 SYSDATE,
                                 ROUND (
                                    (  lsl_c.lsl_lee_price
                                     * (pay.pay_amount)
                                     / totalpay),
                                    2),
                                 pay.pay_cur_code,
                                 NULL,
                                 pay.pay_code,
                                 DECODE (pay.pay_status,
                                         'P', LAST_DAY (TRUNC (SYSDATE)),
                                         pay.pay_due),
                                 NULL,
                                 NULL,
                                 NULL,
                                 SYSDATE,
                                 i_lic_lee_entry_opr,
                                 pay.pay_month_no,
                                 lsl_c.lsl_number,
                                 'Y',
                                 (pay.pay_amount * 100 / totalpay));
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20601,
                                              SUBSTR (SQLERRM, 1, 200));
               END;
            END LOOP;
         END LOOP;

         -----rounding off payment up to 2 decimal-------------------------
         SELECT SUM (pay_amount)
           INTO l_total_pay_price
           FROM fid_payment
          WHERE pay_lic_number = i_lic_number
                AND pay_lsl_number = l_lsl_number1;

         l_extra_pay_amt := l_total_pay_price - i_lic_lee_alloc;

         IF l_extra_pay_amt <> 0
         THEN
            SELECT MIN (pay_number)
              INTO l_pay_number
              FROM fid_payment
             WHERE     pay_lic_number = i_lic_number
                   AND pay_lsl_number = l_lsl_number1
                   AND pay_status = 'N';

            UPDATE fid_payment
               SET pay_amount = pay_amount - l_extra_pay_amt
             WHERE pay_number = l_pay_number;
         END IF;

         -------end rounding off------------------------------------------
         COMMIT;
      END IF;
   END;

   PROCEDURE prc_update_lee_allocation (
      i_lic_number          IN     x_fin_lic_sec_lee.lsl_lee_number%TYPE,
      i_lic_lsl_number      IN     x_fin_lic_sec_lee.lsl_number%TYPE,
      i_lic_lee_number      IN     x_fin_lic_sec_lee.lsl_lee_number%TYPE,
      i_lic_lee_alloc       IN     x_fin_lic_sec_lee.lsl_lee_price%TYPE,
      i_lic_is_primary      IN     x_fin_lic_sec_lee.lsl_is_primary%TYPE,
      i_lic_modified_by     IN     x_fin_lic_sec_lee.lsl_modified_by%TYPE,
      i_lic_modified_date   IN     x_fin_lic_sec_lee.lsl_modified_on%TYPE,
      i_update_count        IN     x_fin_lic_sec_lee.lsl_update_count%TYPE,
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : check for transfer_payment operation
      i_trnsfr_pmnt_flag    IN     VARCHAR2,
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : end
      o_cursor_lee_alloc       OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_update_count           OUT x_fin_lic_sec_lee.lsl_update_count%TYPE)
   AS
      l_prmry_region         NUMBER;
      l_sec_region           NUMBER;
      l_update_status        NUMBER;
      updatefailed           EXCEPTION;
      l_pay_status           NUMBER;
      l_lee_price            NUMBER;
      l_count                NUMBER;
      l_count1               NUMBER;
      l_flag                 VARCHAR2 (10);
      l_paid_amt             NUMBER;
      l_remain_amt           NUMBER;
      targetcom              NUMBER;
      l_mem_agy_com_number   NUMBER;
      l_mem_com_number       NUMBER;
      sourcecom              NUMBER;
      contentstatus          VARCHAR2 (5);
      l_con_number           NUMBER;
      l_lic_currency         VARCHAR2 (5);
      l_notpaid_amt          NUMBER;
      l_notpaid_amt1         NUMBER;
      l_number               NUMBER;
      l_total_pay_price      NUMBER;
      l_extra_pay_amt        NUMBER;
      l_pay_number           NUMBER;
      l_cnt                  NUMBER;
      l_lsl_update_count     NUMBER;
      l_lic_price            NUMBER;
      l_new_con_number       NUMBER;
   BEGIN
      l_update_status := -1;

      -------------finance CRs change by hari-----------------------------------------------------
      SELECT lsl_lee_price
        INTO l_lee_price
        FROM x_fin_lic_sec_lee
       WHERE lsl_number = i_lic_lsl_number;

      IF l_lee_price <> i_lic_lee_alloc
      THEN
         ------PAYMENT PLAN CHANGE PROCEDURE IMPLEMENTATION------------------------------------------------
         BEGIN
            x_prc_lic_price_change (i_lic_number,
                                    i_lic_lsl_number,
                                    i_lic_lee_number,
                                    l_lee_price,
                                    i_lic_lee_alloc,
                                    i_lic_modified_by,
                                    i_trnsfr_pmnt_flag);
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (
                  -20555,
                  'Error in price change' || SUBSTR (SQLERRM, 1, 200));
         END;
      END IF;

      -----------END PROCEDURE IMPLEMENTATION-------------------------------------------------------------
      /* IF l_lee_price <> i_lic_lee_alloc
       THEN
          IF l_lee_price = 0                               ----for scenario 12
          THEN
             SELECT mem_agy_com_number, mem_com_number
               INTO l_mem_agy_com_number, l_mem_com_number
               FROM sak_memo
              WHERE mem_id IN (SELECT lic_mem_number
                                 FROM fid_license
                                WHERE lic_number = i_lic_number);

             SELECT lic_con_number, lic_currency, lic_price
               INTO l_con_number, l_lic_currency, l_lic_price
               FROM fid_license
              WHERE lic_number = i_lic_number;

             SELECT lee_cha_com_number
               INTO sourcecom
               FROM fid_licensee
              WHERE lee_number = i_lic_lee_number;

             SELECT com_type
               INTO contentstatus
               FROM fid_company
              WHERE com_number = l_mem_agy_com_number;

             IF NVL (contentstatus, 'CC') = 'BC'
             THEN
                targetcom := l_mem_agy_com_number;
             ELSE
                targetcom := l_mem_com_number;
             END IF;

             INSERT INTO fid_payment
                         (pay_number, pay_source_com_number,
                          pay_target_com_number, pay_con_number,
                          pay_lic_number, pay_status, pay_status_date,
                          pay_amount, pay_cur_code, pay_rate, pay_code,
                          pay_due, pay_reference, pay_comment,
                          pay_supplier_invoice, pay_entry_date,
                          pay_entry_oper, pay_month_no, pay_lsl_number,
                          pay_original_payment, pay_payment_pct
                         )
                  VALUES (seq_pay_number.NEXTVAL, sourcecom,
                          targetcom, l_con_number,
                          i_lic_number, 'N', SYSDATE,
                          i_lic_lee_alloc, l_lic_currency, NULL, 'G',
                          TRUNC (SYSDATE), NULL, NULL,
                          NULL, SYSDATE,
                          i_lic_modified_by, NULL, i_lic_lsl_number,
                          'Y', 100
                         );
          ELSIF i_lic_lee_alloc = 0
          THEN
             SELECT COUNT (*)
               INTO l_cnt
               FROM fid_payment
              WHERE pay_lsl_number = i_lic_lsl_number AND pay_status = 'P';

             SELECT pkg_cm_username.setusername (i_lic_modified_by)
               INTO l_number
               FROM DUAL;

            -- COMMNENTED FOR NEW TRANSFER LOGIC
          --  DELETE FROM fid_payment
           --       WHERE pay_lsl_number = i_lic_lsl_number
             --           AND pay_status = 'N';


             IF l_cnt > 0
             THEN
                SELECT NVL (SUM (pay_amount), 0)
                  INTO l_paid_amt
                  FROM fid_payment
                 WHERE pay_lsl_number = i_lic_lsl_number AND pay_status = 'P';

                FOR pay IN (SELECT pay_source_com_number,
                                   pay_target_com_number, pay_con_number,
                                   pay_cur_code, pay_code, pay_amount,
                                   pay_status, pay_due, pay_month_no,
                                   pay_lsl_number
                              FROM fid_payment
                             WHERE pay_lsl_number = i_lic_lsl_number
                               AND ROWNUM < 2)
                LOOP
                   BEGIN
                      INSERT INTO fid_payment
                                  (pay_number,
                                   pay_source_com_number,
                                   pay_target_com_number,
                                   pay_con_number, pay_lic_number,
                                   pay_status, pay_status_date, pay_amount,
                                   pay_cur_code, pay_rate, pay_code,
                                   pay_due, pay_reference,
                                   pay_comment,
                                   pay_supplier_invoice, pay_entry_date,
                                   pay_entry_oper, pay_month_no,
                                   pay_lsl_number, pay_original_payment,
                                   pay_payment_pct
                                  )
                           VALUES (seq_pay_number.NEXTVAL,
                                   pay.pay_source_com_number,
                                   pay.pay_target_com_number,
                                   pay.pay_con_number, i_lic_number,
                                   'N', SYSDATE, -l_paid_amt,
                                   pay.pay_cur_code, NULL, pay.pay_code,
                                   LAST_DAY (TRUNC (SYSDATE)), NULL,
                                      'Refund Required owing to Price Change on '
                                   || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                   NULL, SYSDATE,
                                   i_lic_modified_by, pay.pay_month_no,
                                   pay.pay_lsl_number, 'Y',
                                   NULL
                                  );
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                         raise_application_error (-20601,
                                                  SUBSTR (SQLERRM, 1, 200)
                                                 );
                   END;
                END LOOP;
             END IF;
          ELSIF i_lic_lee_alloc > l_lee_price
          THEN
             ----for all paid payment
             SELECT COUNT (*)
               INTO l_count
               FROM fid_payment
              WHERE pay_lic_number = i_lic_number
                AND pay_lsl_number = i_lic_lsl_number
                AND pay_status = 'N';

             IF l_count = 0
             THEN
                l_flag := 'paid';
             END IF;

             SELECT COUNT (*)
               INTO l_count1
               FROM fid_payment
              WHERE pay_lic_number = i_lic_number
                AND pay_lsl_number = i_lic_lsl_number
                AND pay_status = 'P';

             IF l_count1 = 0
             THEN
                l_flag := 'notpaid';
             END IF;

             IF l_flag = 'paid'              ---for all paid payment(scenario3)
             THEN
                FOR pay IN (SELECT pay_source_com_number,
                                   pay_target_com_number, pay_con_number,
                                   pay_cur_code, pay_code, pay_amount,
                                   pay_status, pay_due, pay_month_no,
                                   pay_lsl_number
                              FROM fid_payment
                             WHERE pay_lsl_number = i_lic_lsl_number
                               AND ROWNUM < 2)
                LOOP
                   BEGIN
                      INSERT INTO fid_payment
                                  (pay_number,
                                   pay_source_com_number,
                                   pay_target_com_number,
                                   pay_con_number, pay_lic_number,
                                   pay_status, pay_status_date,
                                   pay_amount,
                                   pay_cur_code, pay_rate, pay_code,
                                   pay_due, pay_reference,
                                   pay_comment,
                                   pay_supplier_invoice, pay_entry_date,
                                   pay_entry_oper, pay_month_no,
                                   pay_lsl_number, pay_original_payment,
                                   pay_payment_pct
                                  )
                           VALUES (seq_pay_number.NEXTVAL,
                                   pay.pay_source_com_number,
                                   pay.pay_target_com_number,
                                   pay.pay_con_number, i_lic_number,
                                   'N', SYSDATE,
                                   (i_lic_lee_alloc - l_lee_price
                                   ),
                                   pay.pay_cur_code, NULL, pay.pay_code,
                                   LAST_DAY (TRUNC (SYSDATE)), NULL,
                                      'Additional Payment owing to Price Change on '
                                   || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                   NULL, SYSDATE,
                                   i_lic_modified_by, pay.pay_month_no,
                                   pay.pay_lsl_number, 'Y',
                                   NULL
                                  );
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                         raise_application_error (-20601,
                                                  SUBSTR (SQLERRM, 1, 200)
                                                 );
                   END;
                END LOOP;
             ELSIF l_flag = 'notpaid'        ---for all paid payment(scenario4)
             THEN
                SELECT SUM (pay_amount)
                  INTO l_notpaid_amt1
                  FROM fid_payment
                 WHERE pay_lsl_number = i_lic_lsl_number;

                FOR pay IN (SELECT pay_number, pay_amount
                              FROM fid_payment
                             WHERE pay_lsl_number = i_lic_lsl_number)
                LOOP
                   UPDATE fid_payment
                      SET pay_amount =
                             ROUND (  i_lic_lee_alloc
                                    * (pay.pay_amount / l_notpaid_amt1),
                                    2
                                   ),
                          pay_comment =
                                'Updated Payment owing to Price Change on '
                             || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR')
                    WHERE pay_number = pay.pay_number;
                END LOOP;
             ELSE                                ---for scenario1 and scenario2
                SELECT SUM (pay_amount)
                  INTO l_paid_amt
                  FROM fid_payment
                 WHERE pay_lsl_number = i_lic_lsl_number AND pay_status = 'P';

                SELECT SUM (pay_amount)
                  INTO l_notpaid_amt1
                  FROM fid_payment
                 WHERE pay_lsl_number = i_lic_lsl_number AND pay_status = 'N';

                FOR pay IN (SELECT pay_number, pay_amount
                              FROM fid_payment
                             WHERE pay_lsl_number = i_lic_lsl_number
                               AND pay_status = 'N')
                LOOP
                   UPDATE fid_payment
                      SET pay_amount =
                             ROUND (  i_lic_lee_alloc
                                    * (  pay.pay_amount
                                       / (l_paid_amt + l_notpaid_amt1)
                                      ),
                                    2
                                   ),
                          pay_comment =
                                'Updated Payment owing to Price Change on '
                             || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR')
                    WHERE pay_number = pay.pay_number;
                END LOOP;

                SELECT SUM (pay_amount)
                  INTO l_notpaid_amt
                  FROM fid_payment
                 WHERE pay_lsl_number = i_lic_lsl_number AND pay_status = 'N';

                l_remain_amt := i_lic_lee_alloc - (l_paid_amt + l_notpaid_amt);

                FOR pay IN (SELECT pay_source_com_number,
                                   pay_target_com_number, pay_con_number,
                                   pay_cur_code, pay_code, pay_amount,
                                   pay_status, pay_due, pay_month_no,
                                   pay_lsl_number
                              FROM fid_payment
                             WHERE pay_lsl_number = i_lic_lsl_number
                               AND ROWNUM < 2)
                LOOP
                   BEGIN
                      INSERT INTO fid_payment
                                  (pay_number,
                                   pay_source_com_number,
                                   pay_target_com_number,
                                   pay_con_number, pay_lic_number,
                                   pay_status, pay_status_date, pay_amount,
                                   pay_cur_code, pay_rate, pay_code,
                                   pay_due, pay_reference,
                                   pay_comment,
                                   pay_supplier_invoice, pay_entry_date,
                                   pay_entry_oper, pay_month_no,
                                   pay_lsl_number, pay_original_payment,
                                   pay_payment_pct
                                  )
                           VALUES (seq_pay_number.NEXTVAL,
                                   pay.pay_source_com_number,
                                   pay.pay_target_com_number,
                                   pay.pay_con_number, i_lic_number,
                                   'N', SYSDATE, l_remain_amt,
                                   pay.pay_cur_code, NULL, pay.pay_code,
                                   LAST_DAY (TRUNC (SYSDATE)), NULL,
                                      'Additional Payment owing to Price Change on '
                                   || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                   NULL, SYSDATE,
                                   i_lic_modified_by, pay.pay_month_no,
                                   pay.pay_lsl_number, 'Y',
                                   NULL
                                  );
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                         raise_application_error (-20601,
                                                  SUBSTR (SQLERRM, 1, 200)
                                                 );
                   END;
                END LOOP;
             END IF;
          ELSE
             ------for licensee allocation less than already allocated
             --  if i_lic_lee_alloc < l_lee_price
             -- then
             ----for all paid payment
             SELECT COUNT (*)
               INTO l_count
               FROM fid_payment
              WHERE pay_lic_number = i_lic_number
                AND pay_lsl_number = i_lic_lsl_number
                AND pay_status = 'N';

             IF l_count = 0
             THEN
                l_flag := 'paid';
             END IF;

             SELECT COUNT (*)
               INTO l_count1
               FROM fid_payment
              WHERE pay_lic_number = i_lic_number
                AND pay_lsl_number = i_lic_lsl_number
                AND pay_status = 'P';

             IF l_count1 = 0
             THEN
                l_flag := 'notpaid';
             END IF;

             IF l_flag = 'paid'             ----for all paid payment(scenario7)
             THEN
                FOR pay IN (SELECT pay_source_com_number,
                                   pay_target_com_number, pay_con_number,
                                   pay_cur_code, pay_code, pay_amount,
                                   pay_status, pay_due, pay_month_no,
                                   pay_lsl_number
                              FROM fid_payment
                             WHERE pay_lsl_number = i_lic_lsl_number
                               AND ROWNUM < 2)
                LOOP
                   BEGIN
                      INSERT INTO fid_payment
                                  (pay_number,
                                   pay_source_com_number,
                                   pay_target_com_number,
                                   pay_con_number, pay_lic_number,
                                   pay_status, pay_status_date,
                                   pay_amount,
                                   pay_cur_code, pay_rate, pay_code,
                                   pay_due, pay_reference,
                                   pay_comment,
                                   pay_supplier_invoice, pay_entry_date,
                                   pay_entry_oper, pay_month_no,
                                   pay_lsl_number, pay_original_payment,
                                   pay_payment_pct
                                  )
                           VALUES (seq_pay_number.NEXTVAL,
                                   pay.pay_source_com_number,
                                   pay.pay_target_com_number,
                                   pay.pay_con_number, i_lic_number,
                                   'N', SYSDATE,
                                   (i_lic_lee_alloc - l_lee_price
                                   ),
                                   pay.pay_cur_code, NULL, pay.pay_code,
                                   LAST_DAY (TRUNC (SYSDATE)), NULL,
                                      'Refund Required owing to Price Change on '
                                   || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                   NULL, SYSDATE,
                                   i_lic_modified_by, pay.pay_month_no,
                                   pay.pay_lsl_number, 'Y',
                                   NULL
                                  );
                   EXCEPTION
                      WHEN OTHERS
                      THEN
                         raise_application_error (-20601,
                                                  SUBSTR (SQLERRM, 1, 200)
                                                 );
                   END;
                END LOOP;
             ELSIF l_flag = 'notpaid'   ----for all not paid payment(scenario8)
             THEN
                SELECT SUM (pay_amount)
                  INTO l_notpaid_amt
                  FROM fid_payment
                 WHERE pay_lsl_number = i_lic_lsl_number;

                FOR pay IN (SELECT pay_number, pay_amount
                              FROM fid_payment
                             WHERE pay_lsl_number = i_lic_lsl_number)
                LOOP
                   UPDATE fid_payment
                      SET pay_amount =
                             ROUND (  i_lic_lee_alloc
                                    * (pay.pay_amount / l_notpaid_amt),
                                    2
                                   ),
                          pay_comment =
                                'Updated Payment owing to Price Change on '
                             || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR')
                    WHERE pay_number = pay.pay_number;
                END LOOP;
             ELSE                                ---for scenario5 and scenario6
                SELECT SUM (pay_amount)
                  INTO l_paid_amt
                  FROM fid_payment
                 WHERE pay_lsl_number = i_lic_lsl_number AND pay_status = 'P';

                l_remain_amt := i_lic_lee_alloc - l_paid_amt;

                ----------------when new price is less than total paid price
                IF l_remain_amt < 0
                THEN
                   SELECT pkg_cm_username.setusername (i_lic_modified_by)
                     INTO l_number
                     FROM DUAL;

                   DELETE FROM fid_payment
                         WHERE pay_lsl_number = i_lic_lsl_number
                           AND pay_status = 'N';

                   FOR pay IN (SELECT pay_source_com_number,
                                      pay_target_com_number, pay_con_number,
                                      pay_cur_code, pay_code, pay_amount,
                                      pay_status, pay_due, pay_month_no,
                                      pay_lsl_number
                                 FROM fid_payment
                                WHERE pay_lsl_number = i_lic_lsl_number
                                  AND ROWNUM < 2)
                   LOOP
                      INSERT INTO fid_payment
                                  (pay_number,
                                   pay_source_com_number,
                                   pay_target_com_number,
                                   pay_con_number, pay_lic_number,
                                   pay_status, pay_status_date, pay_amount,
                                   pay_cur_code, pay_rate, pay_code,
                                   pay_due, pay_reference,
                                   pay_comment,
                                   pay_supplier_invoice, pay_entry_date,
                                   pay_entry_oper, pay_month_no,
                                   pay_lsl_number, pay_original_payment,
                                   pay_payment_pct
                                  )
                           VALUES (seq_pay_number.NEXTVAL,
                                   pay.pay_source_com_number,
                                   pay.pay_target_com_number,
                                   pay.pay_con_number, i_lic_number,
                                   'N', SYSDATE, l_remain_amt,
                                   pay.pay_cur_code, NULL, pay.pay_code,
                                   LAST_DAY (TRUNC (SYSDATE)), NULL,
                                      'Refund Required owing to Price Change on '
                                   || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR'),
                                   NULL, SYSDATE,
                                   i_lic_modified_by, pay.pay_month_no,
                                   pay.pay_lsl_number, 'Y',
                                   NULL
                                  );
                   END LOOP;
                ELSE
                   ---------------when new price is less than than total paid price
                   SELECT SUM (pay_amount)
                     INTO l_notpaid_amt
                     FROM fid_payment
                    WHERE pay_lsl_number = i_lic_lsl_number
                          AND pay_status = 'N';

                   FOR pay IN (SELECT pay_number, pay_amount
                                 FROM fid_payment
                                WHERE pay_lsl_number = i_lic_lsl_number
                                  AND pay_status = 'N')
                   LOOP
                      UPDATE fid_payment
                         SET pay_amount =
                                ROUND (  l_remain_amt
                                       * (pay.pay_amount / l_notpaid_amt),
                                       2
                                      ),
                             pay_comment =
                                   'Updated Payment owing to Price Change on '
                                || TO_CHAR (TRUNC (SYSDATE), 'DD-Mon-RRRR')
                       WHERE pay_number = pay.pay_number;
                   END LOOP;
                END IF;
             END IF;
          END IF;

          -----rounding off payment up to 2 decimal-------------------------
          SELECT SUM (pay_amount)
            INTO l_total_pay_price
            FROM fid_payment
           WHERE pay_lic_number = i_lic_number
             AND pay_lsl_number = i_lic_lsl_number;

          l_extra_pay_amt := l_total_pay_price - i_lic_lee_alloc;

          IF l_extra_pay_amt <> 0
          THEN
             SELECT MIN (pay_number)
               INTO l_pay_number
               FROM fid_payment
              WHERE pay_lic_number = i_lic_number
                AND pay_lsl_number = i_lic_lsl_number
                AND pay_status = 'N';

             UPDATE fid_payment
                SET pay_amount = pay_amount - l_extra_pay_amt
              WHERE pay_number = l_pay_number;
          END IF;
       -------end rounding off------------------------------------------
       END IF;*/

      -------------END finance CRs change by hari-----------------------------------------------------
      SELECT lee_split_region
        INTO l_prmry_region
        FROM fid_licensee
       WHERE lee_number IN
                (SELECT lsl_lee_number
                   FROM x_fin_lic_sec_lee
                  WHERE lsl_is_primary = 'Y'
                        AND lsl_lic_number = i_lic_number);

      -- Change it to License No.
      SELECT lee_split_region
        INTO l_sec_region
        FROM fid_licensee
       WHERE lee_number = i_lic_lee_number;

      IF l_prmry_region = l_sec_region
      THEN
         UPDATE x_fin_lic_sec_lee
            SET lsl_lee_number = i_lic_lee_number,
                lsl_lee_price = i_lic_lee_alloc,
                lsl_is_primary = i_lic_is_primary,
                lsl_modified_by = i_lic_modified_by,
                lsl_modified_on = i_lic_modified_date
          --lsl_update_count = NVL (lsl_update_count, 0) + 1
          WHERE lsl_number = i_lic_lsl_number;

         /*AND NVL (lsl_update_count, 0) = i_update_count
   RETURNING lsl_update_count
        INTO o_update_count;*/
         ----------------------RDT Audit Changes for Update Count------------------------------------
         SELECT lsl_update_count
           INTO l_lsl_update_count
           FROM x_fin_lic_sec_lee
          WHERE lsl_number = i_lic_lsl_number;

         IF NVL (i_update_count, 0) = NVL (l_lsl_update_count, 0)  --RDT audit
         THEN
            UPDATE x_fin_lic_sec_lee
               SET lsl_update_count = NVL (lsl_update_count, 0) + 1
             WHERE lsl_number = i_lic_lsl_number;

            COMMIT;

            SELECT lsl_update_count
              INTO l_lsl_update_count
              FROM x_fin_lic_sec_lee
             WHERE lsl_number = i_lic_lsl_number;

            o_update_count := NVL (l_lsl_update_count, 0);
         ELSE
            raise_application_error (
               -20001,
                  'The license details for license number - '
               || i_lic_number
               || ' is already modified by another user');
         END IF;

         --------------------RDT Audit Changes End----------------------

         --Delete this
        -- DBMS_OUTPUT.put_line (' o_update_count ::' || o_update_count);
         l_update_status := SQL%ROWCOUNT;
        -- DBMS_OUTPUT.put_line (' l_update_status ::' || l_update_status);
      ELSE
         raise_application_error (
            -20103,
            'Licensee is not under primary licensee region');
         l_update_status := -1;
      END IF;

      IF l_update_status > 0
      THEN
         SELECT lic_con_number, lic_currency, lic_price
           INTO l_new_con_number, l_lic_currency, l_lic_price
           FROM fid_license
          WHERE lic_number = i_lic_number;

         IF l_lee_price <> i_lic_lee_alloc
         THEN
            x_budrvp_budget_pck.x_budget_upd_lic (i_lic_number,
                                                  'Price',
                                                  l_lic_price,
                                                  NULL,
                                                  ' ',
                                                  i_lic_modified_by,
                                                  l_new_con_number);
         END IF;
      END IF;
   /*  IF (l_update_status > 0)
     THEN
        COMMIT;
     ELSE
        ROLLBACK;
        raise_application_error (-20103, 'Not updated successfully.');
     END IF;*/
   EXCEPTION
      WHEN updatefailed
      THEN
         raise_application_error (
            -20601,
            'This licensee is Paid. Only Unpaid licensees can be updated.');
   END;

   PROCEDURE prc_delete_lee_allocation (
      i_lic_lsl_number   IN     x_fin_lic_sec_lee.lsl_number%TYPE,
      i_update_count     IN     x_fin_lic_sec_lee.lsl_update_count%TYPE,
      i_entry_oper       IN     x_fin_lic_sec_lee.lsl_entry_oper%TYPE,
      o_update_count        OUT x_fin_lic_sec_lee.lsl_update_count%TYPE,
      o_success             OUT NUMBER)
   AS
      l_delete_status   NUMBER;
      deletefailed      EXCEPTION;
      l_pay_status      NUMBER;
      l_split_region    fid_licensee.lee_split_region%TYPE;
      l_closed_month    DATE;
      l_lic_number      fid_license.lic_number%TYPE;
      l_con_forcast     NUMBER;
   BEGIN
      l_delete_status := -1;
      o_success := -1;

      SELECT lsl_lic_number
        INTO l_lic_number
        FROM x_fin_lic_sec_lee
       WHERE lsl_number = i_lic_lsl_number;

      SELECT lee_split_region
        INTO l_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = l_lic_number);

      SELECT MAX (TO_DATE (fim_year || LPAD (fim_month, 2, 0), 'RRRRMM'))
        INTO l_closed_month
        FROM fid_financial_month
       WHERE fim_status = 'C' AND fim_split_region = l_split_region;

      SELECT NVL (SUM (lis_con_forecast), 0)
        INTO l_con_forcast
        FROM fid_license_sub_ledger
       WHERE lis_lic_number = l_lic_number
             AND TO_DATE (lis_per_year || LPAD (lis_per_month, 2, 0),
                          'RRRRMM') <= l_closed_month;

     -- DBMS_OUTPUT.put_line (' l_con_forcast ::' || l_con_forcast);

      SELECT COUNT (pay_status)
        INTO l_pay_status
        FROM fid_payment
       WHERE pay_lsl_number = i_lic_lsl_number AND pay_status = 'P';

      IF (l_pay_status > 0)
      THEN
         RAISE deletefailed;
      ELSE
         IF l_con_forcast > 0
         THEN
            RAISE deletefailed;
         ELSE
            pkg_cm_username.username :=
               pkg_cm_username.setusername (i_entry_oper);

            DELETE FROM fid_payment
                  WHERE pay_lsl_number = i_lic_lsl_number;

            DELETE FROM fid_license_sub_ledger
                  WHERE lis_lsl_number = i_lic_lsl_number;

            DELETE FROM x_fin_unrealized_forex
                  WHERE unf_lsl_number = i_lic_lsl_number;

            DELETE FROM x_fin_lic_sec_lee
                  WHERE lsl_number = i_lic_lsl_number
                        AND NVL (lsl_update_count, 0) = i_update_count
              RETURNING lsl_update_count
                   INTO o_update_count;

            l_delete_status := SQL%ROWCOUNT;
         END IF;
      END IF;

      IF (l_delete_status <> 0)
      THEN
         COMMIT;
         o_success := 1;
      ELSE
         ROLLBACK;
      END IF;
   EXCEPTION
      WHEN deletefailed
      THEN
         raise_application_error (-20601, 'This licensee cannot be deleted.');
   END;

   PROCEDURE prc_spot_rate_details (
      i_lic_number        IN     x_fin_lic_sec_lee.lsl_lic_number%TYPE,
      o_cursor_prepaymt      OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc,
      o_cursor_remlib        OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
   BEGIN
      OPEN o_cursor_prepaymt FOR
         SELECT pay_date,
                pay_rate,
                pay_amount,
                fl.lic_start,
                fl.lic_currency,
                (SELECT ter_cur_code
                   FROM fid_territory ft,
                        fid_company fc,
                        fid_licensee fl,
                        fid_license fle
                  WHERE     ft.ter_code = fc.com_ter_code
                        AND fc.com_number = fl.lee_cha_com_number
                        AND fl.lee_number = fle.lic_lee_number
                        AND fle.lic_number = i_lic_number)
                   ter_cur_code
           FROM fid_payment py, fid_license fl
          WHERE     py.pay_lic_number = fl.lic_number
                AND fl.lic_number = i_lic_number
                AND py.pay_date < fl.lic_start
                AND UPPER (pay_status) = 'P';

      OPEN o_cursor_remlib FOR
         SELECT lic_start,
                lic_start_rate,
                ( (SELECT ROUND (NVL (SUM (lis_con_forecast), 0), 2)
                     FROM fid_license_sub_ledger
                    WHERE lis_lic_number = i_lic_number)
                 - (SELECT NVL (SUM (pay_amount), 0)
                      FROM fid_payment
                     WHERE     pay_date < lic_start
                           AND pay_lic_number = i_lic_number
                           AND UPPER (pay_status) = 'P'))
                   amount,
                (SELECT ter_cur_code
                   FROM fid_territory ft,
                        fid_company fc,
                        fid_licensee fl,
                        fid_license fle
                  WHERE     ft.ter_code = fc.com_ter_code
                        AND fc.com_number = fl.lee_cha_com_number
                        AND fl.lee_number = fle.lic_lee_number
                        AND fle.lic_number = i_lic_number)
                   ter_cur_code,
                lic_currency
           FROM fid_license
          WHERE lic_number = i_lic_number;
   END prc_spot_rate_details;

   -- Start :Abhinay_20Mar2014 :: Email Notification on License cancellation

--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
PROCEDURE prc_lic_canc_email_in_bulk (
      i_lic_details in pkg_alic_cm_licensemaintenance.lic_details,
      o_cursor          OUT CLOB)
      as
      l_stmnt CLOB;
      l_flag varchar2(1);
      l_lic_status varchar2(1);
      l_lic_gen_refno number;
      begin

      for lic in i_lic_details.first..i_lic_details.last
      loop

          select lic_gen_refno
          into l_lic_gen_refno
          from fid_license where lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1);

          prc_lic_canc_email(X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1),l_lic_gen_refno,l_flag);
      -- DBMS_OUTPUT.PUT_LINE('l_flag'||l_flag);


        select lic_status
          into l_lic_status
          from fid_license where lic_number = X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1);

        if l_flag = 'Y' and l_lic_status = 'C'THEN
        l_stmnt:=X_PKG_MM_UID_MAINTENANCE.x_fnc_split_data(i_lic_details(lic),1)||','||l_stmnt;
        END IF;
      end loop;
     -- DBMS_OUTPUT.PUT_LINE('l_stmnt'||l_lic_gen_refno);
      IF l_stmnt IS NOT NULL THEN
        o_cursor := l_stmnt;
      ELSE
        l_stmnt:=empty_clob();
        o_cursor := l_stmnt;
      END IF;
end prc_lic_canc_email_in_bulk;
--15_FIN_06_ENH_Cancel Season in one attempt_v1.0

   PROCEDURE prc_lic_canc_email (
      i_lic_number   IN     fid_license.lic_number%TYPE,
      i_gen_refno    IN     fid_general.gen_refno%TYPE,
      o_cursor          OUT varchar2)
   AS
      out_Result   VARCHAR2 (5);
      l_gen        NUMBER;
      l_lic        NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_gen
        FROM sgy_mn_lic_tape_cha_mapp
       WHERE ltcm_gen_refno = i_gen_refno;

      IF (l_gen > 0)
      THEN
         out_Result := 'Y';
      ELSE
         SELECT COUNT (*)
           INTO l_lic
           FROM sgy_mn_lic_tape_cha_mapp
          WHERE ltcm_lic_number = i_lic_number;

         IF (l_lic > 0)
         THEN
            out_Result := 'Y';
         ELSE
            out_Result := 'N';
         END IF;
      END IF;

      o_cursor := out_Result ;
   END prc_lic_canc_email;

   -- END :

   ---- End -- Changes for FIN3 by Nishant Ankam
   FUNCTION x_fun_costed_channel (
      i_licnumber        IN fid_license.lic_number%TYPE,
      i_cha_number       IN fid_channel.cha_number%TYPE,
      i_sch_start_date   IN fid_license_channel_runs.lcr_sch_start_date%TYPE,
      i_sch_end_date     IN fid_license_channel_runs.lcr_sch_end_date%TYPE)
      RETURN NUMBER
   AS
      l_split_region   fid_licensee.lee_split_region%TYPE;
      v_go_live_date   DATE;
      l_start_date     fid_license.lic_start%TYPE;
      count_exh        NUMBER;
   BEGIN
      SELECT lic_start
        INTO l_start_date
        FROM fid_license
       WHERE lic_number = i_licnumber;

      SELECT lee_split_region
        INTO l_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_licnumber);

      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      IF l_start_date < v_go_live_date
      THEN
         SELECT COUNT (*)
           INTO count_exh
           FROM fid_schedule
          WHERE     sch_type = 'P'
                AND sch_lic_number = i_licnumber
                AND sch_cha_number = i_cha_number
                AND sch_date BETWEEN NVL (i_sch_start_date, sch_date)
                                 AND NVL (i_sch_end_date, sch_date)
                AND sch_date <=
                       (SELECT LAST_DAY (
                                  MAX (
                                     TO_DATE (fim_year || fim_month,
                                              'YYYYMM')))
                          FROM fid_financial_month
                         WHERE fim_status = 'C'
                               AND NVL (fim_split_region, -1) =
                                      DECODE (fim_split_region,
                                              NULL, -1,
                                              l_split_region));
      ELSE
         SELECT COUNT (*)
           INTO count_exh
           FROM x_fin_cost_schedules
          WHERE csh_lic_number = i_licnumber
                AND csh_cha_number = i_cha_number
                AND csh_sch_date BETWEEN NVL (i_sch_start_date, csh_sch_date)
                                     AND NVL (i_sch_end_date, csh_sch_date)
                AND csh_sch_date <=
                       (SELECT LAST_DAY (
                                  MAX (
                                     TO_DATE (fim_year || fim_month,
                                              'YYYYMM')))
                          FROM fid_financial_month
                         WHERE fim_status = 'C'
                               AND NVL (fim_split_region, -1) =
                                      DECODE (fim_split_region,
                                              NULL, -1,
                                              l_split_region));
      END IF;

      RETURN count_exh;
   EXCEPTION
      WHEN OTHERS
      THEN
         count_exh := 0;
         RETURN count_exh;
   END;

   FUNCTION x_fnc_get_lic_paidamt (
      i_lic_number IN FID_LICENSE.lic_number%TYPE)
      RETURN NUMBER
   AS
      v_out_paid_amt   NUMBER;
   BEGIN
      SELECT SUM (NVL (f1.PAY_AMOUNT, 0))
        INTO v_out_paid_amt
        FROM FID_PAYMENT F1
       WHERE F1.PAY_LIC_NUMBER = i_lic_number AND F1.PAY_STATUS = 'P';

      RETURN v_out_paid_amt;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END X_FNC_GET_LIC_PAIDAMT;

   PROCEDURE x_prc_alic_cm_desti_lic_search (
      i_lic_no              FID_LICENSE.lic_number%TYPE,
      i_gen_refno           fid_general.gen_refno%TYPE,
      i_lee_no              fid_licensee.lee_number%TYPE,
      i_contract_no         fid_contract.con_number%TYPE,
      i_series_flag         VARCHAR2,
      i_catch_up_flag       FID_LICENSE.LIC_CATCHUP_FLAG%TYPE,
      o_data_out        OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
   BEGIN
      IF (i_catch_up_flag = 'N' OR i_catch_up_flag IS NULL)
      THEN
         OPEN o_data_out FOR
            SELECT destsearch.*,
                   DECODE (ROWNUM, 1, 'true', 'false') first_row_flag
              FROM (  SELECT e.lee_short_name,
                             l.lic_number,
                             g.gen_title,
                             s.chs_short_name,
                             x_fun_is_primary (l.lic_number) is_secondary_flag,
                             e.lee_number
                        FROM fid_license l,
                             fid_general g,
                             FID_LICENSEE e,
                             fid_channel_service s
                       WHERE     g.gen_refno = l.lic_gen_refno
                             AND l.lic_chs_number = s.chs_number
                             AND l.lic_lee_number = e.lee_number
                             AND l.lic_number <> i_lic_no
                             AND g.gen_refno = i_gen_refno
                             AND l.lic_con_number = i_contract_no
                             AND l.lic_price = 0
                             AND NVL (L.LIC_CATCHUP_FLAG, 'N') =
                                    NVL (i_catch_up_flag, 'N')
                             AND 0 =
                                    (SELECT NVL (SUM (pay_amount), 0)
                                       FROM fid_payment p
                                      WHERE p.pay_lic_number = l.lic_number
                                            AND p.pay_status = 'P')
                    ORDER BY l.lic_number) destsearch;
      ELSE
         --DBMS_OUTPUT.put_line ('inside catch up');

         OPEN o_data_out FOR
            SELECT destsearch.*,
                   DECODE (ROWNUM, 1, 'true', 'false') first_row_flag
              FROM (  SELECT e.lee_short_name,
                             l.lic_number,
                             g.gen_title,
                             NULL chs_short_name,
                             x_fun_is_primary (l.lic_number) is_secondary_flag,
                             e.lee_number
                        FROM fid_license l, fid_general g, FID_LICENSEE e
                       WHERE     g.gen_refno = l.lic_gen_refno
                             AND l.lic_lee_number = e.lee_number
                             AND l.lic_number <> i_lic_no
                             AND g.gen_refno = i_gen_refno
                             AND l.lic_con_number = i_contract_no
                             AND l.lic_price = 0
                             AND NVL (L.LIC_CATCHUP_FLAG, 'N') =
                                    NVL (i_catch_up_flag, 'N')
                             AND 0 =
                                    (SELECT NVL (SUM (pay_amount), 0)
                                       FROM fid_payment p
                                      WHERE p.pay_lic_number = l.lic_number
                                            AND p.pay_status = 'P')
                    ORDER BY l.lic_number) destsearch;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END x_prc_alic_cm_desti_lic_search;

   FUNCTION x_fun_is_primary (I_LIC_NO NUMBER)
      RETURN VARCHAR2
   IS
      L_CNT   NUMBER;
   --L_FLAG VARCHAR2;
   BEGIN
      SELECT COUNT (1)
        INTO L_CNT
        FROM X_FIN_LIC_SEC_LEE C
       WHERE c.lsl_is_primary = 'N' AND c.lsl_lic_number = I_LIC_NO;

      IF l_cnt > 0
      THEN
         RETURN 'Y';
      ELSE
         RETURN 'N';
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN NULL;
   END x_fun_is_primary;

   PROCEDURE x_prc_alic_cm_transfer_payment (
      i_src_lic_no            FID_LICENSE.lic_number%TYPE,
      i_dst_lic_no            FID_LICENSE.lic_number%TYPE,
      i_pay_comment           VARCHAR2,
      i_entry_date            DATE,
      i_entry_oper            VARCHAR2,
      i_lsl_lee_price         FID_LICENSE.lic_price%TYPE,
      i_lic_showing_lic       FID_LICENSE.lic_showing_lic%TYPE,
      o_success_flag      OUT NUMBER)
   AS
      l_cnt               NUMBER;
      l_seq_val           NUMBER;
      l_sql_srring        VARCHAR (100);
      l_number            NUMBER;
      l_pay_lsl_number    NUMBER;
      l_pay_lsl_number2   NUMBER;
      l_dest_count        NUMBER;
      l_get_sequence      NUMBER;
      value_large         EXCEPTION;
      PRAGMA EXCEPTION_INIT (value_large, -12899);
   BEGIN
      x_prc_alic_cm_trf_validation (i_src_lic_no, i_dst_lic_no);

      SELECT lsl_number
        INTO l_pay_lsl_number
        FROM x_fin_lic_sec_lee
       WHERE lsl_lic_number = i_dst_lic_no AND lsl_is_primary = 'Y';

      SELECT COUNT (1)
        INTO l_cnt
        FROM fid_payment p
       WHERE     p.pay_lic_number = i_src_lic_no
             AND p.pay_status = 'P'
             AND p.pay_amount < 0;

      IF l_cnt = 0
      THEN
         SELECT PKG_CM_USERNAME.SetUserName (i_entry_oper)
           INTO l_number
           FROM DUAL;

         /*     UPDATE x_fin_lic_sec_lee
                 SET lsl_lee_price = i_lsl_lee_price
               WHERE lsl_lic_number = i_dst_lic_no;

           --   COMMIT;

              UPDATE fid_license
                 SET lic_showing_lic = i_lic_showing_lic,
                     lic_price =
                        (SELECT SUM (lsl_lee_price)
                           FROM x_fin_lic_sec_lee
                          WHERE lsl_lic_number = i_dst_lic_no)
               WHERE lic_number = i_dst_lic_no;  */

         /*  l_sql_srring := 'truncate table X_GTT_FID_PAYMENT_TEMP';

           EXECUTE IMMEDIATE l_sql_srring; */

         DELETE FROM X_GTT_FID_PAYMENT_TEMP;

         FOR d IN (SELECT lsl_number,
                          lsl_is_primary,
                          lsl_lee_number,
                          lsl_lee_price
                     FROM x_fin_lic_sec_lee
                    WHERE lsl_lic_number = i_src_lic_no)
         LOOP
            IF d.lsl_is_primary = 'Y'
            THEN
               FOR c
                  IN (SELECT p.*
                        FROM fid_payment p
                       WHERE p.pay_lic_number = i_src_lic_no
                             AND p.pay_lsl_number = d.lsl_number)
               LOOP
                  IF c.pay_status = 'P'
                  THEN
                     ----Insert Source
                     INSERT
                       INTO X_GTT_FID_PAYMENT_TEMP (FPT_PAY_NUMBER,
                                                    FPT_PAY_SOURCE_COM_NUMBER,
                                                    FPT_PAY_TARGET_COM_NUMBER,
                                                    FPT_PAY_CON_NUMBER,
                                                    FPT_PAY_LIC_NUMBER,
                                                    FPT_PAY_STATUS,
                                                    FPT_PAY_STATUS_DATE,
                                                    FPT_PAY_AMOUNT,
                                                    FPT_PAY_CUR_CODE,
                                                    FPT_PAY_RATE,
                                                    FPT_PAY_CODE,
                                                    FPT_PAY_DUE,
                                                    FPT_PAY_REFERENCE,
                                                    FPT_PAY_COMMENT,
                                                    FPT_PAY_SUPPLIER_INVOICE,
                                                    FPT_PAY_ENTRY_DATE,
                                                    FPT_PAY_ENTRY_OPER,
                                                    FPT_PAY_MARKUP_PERCENT,
                                                    FPT_PAY_FCD_NUMBER,
                                                    FPT_PAY_IS_DELETED,
                                                    FPT_PAY_UPDATE_COUNT,
                                                    FPT_PAY_DATE,
                                                    FPT_PAY_LSL_NUMBER,
                                                    FPT_PAY_MONTH_NO,
                                                    FPT_PAY_SOURCE_NUMBER,
                                                    FPT_PAY_LPY_NUMBER,
                                                    FPT_PAY_SPLIT_ID,
                                                    FPT_PAY_CALC_MONTH,
                                                    FPT_PAY_CALC_YEAR,
                                                    FPT_PAY_SUBS_MONTH,
                                                    FPT_PAY_SUBS_YEAR,
                                                    FPT_PAY_PAY_MONTH,
                                                    FPT_PAY_PAY_YEAR,
                                                    FPT_PAY_ORIGINAL_PAYMENT,
                                                    FPT_PAY_PAYMENT_PCT,
                                                    FPT_OPER_FLAG)
                     VALUES (seq_pay_number.NEXTVAL,
                             c.PAY_SOURCE_COM_NUMBER,
                             c.PAY_TARGET_COM_NUMBER,
                             c.PAY_CON_NUMBER,
                             c.PAY_LIC_NUMBER,
                             'P',                              --c.PAY_STATUS,
                             i_entry_date,                --c.PAY_STATUS_DATE,
                             -c.PAY_AMOUNT,
                             c.PAY_CUR_CODE,
                             c.PAY_RATE,
                             'T',
                             c.PAY_DUE,
                             '',                            --c.PAY_REFERENCE,
                             i_pay_comment,
                             c.PAY_SUPPLIER_INVOICE,
                             i_entry_date,
                             i_entry_oper,
                             c.PAY_MARKUP_PERCENT,
                             c.PAY_FCD_NUMBER,
                             c.PAY_IS_DELETED,
                             c.PAY_UPDATE_COUNT,
                             i_entry_date,
                             c.PAY_LSL_NUMBER,
                             c.PAY_MONTH_NO,
                             c.PAY_NUMBER,
                             c.PAY_LPY_NUMBER,
                             c.PAY_SPLIT_ID,
                             c.PAY_CALC_MONTH,
                             c.PAY_CALC_YEAR,
                             c.PAY_SUBS_MONTH,
                             c.PAY_SUBS_YEAR,
                             c.PAY_PAY_MONTH,
                             c.PAY_PAY_YEAR,
                             c.PAY_ORIGINAL_PAYMENT,
                             c.PAY_PAYMENT_PCT,
                             'I');

                     --Insert Destination
                     INSERT
                       INTO X_GTT_FID_PAYMENT_TEMP (FPT_PAY_NUMBER,
                                                    FPT_PAY_SOURCE_COM_NUMBER,
                                                    FPT_PAY_TARGET_COM_NUMBER,
                                                    FPT_PAY_CON_NUMBER,
                                                    FPT_PAY_LIC_NUMBER,
                                                    FPT_PAY_STATUS,
                                                    FPT_PAY_STATUS_DATE,
                                                    FPT_PAY_AMOUNT,
                                                    FPT_PAY_CUR_CODE,
                                                    FPT_PAY_RATE,
                                                    FPT_PAY_CODE,
                                                    FPT_PAY_DUE,
                                                    FPT_PAY_REFERENCE,
                                                    FPT_PAY_COMMENT,
                                                    FPT_PAY_SUPPLIER_INVOICE,
                                                    FPT_PAY_ENTRY_DATE,
                                                    FPT_PAY_ENTRY_OPER,
                                                    FPT_PAY_MARKUP_PERCENT,
                                                    FPT_PAY_FCD_NUMBER,
                                                    FPT_PAY_IS_DELETED,
                                                    FPT_PAY_UPDATE_COUNT,
                                                    FPT_PAY_DATE,
                                                    FPT_PAY_LSL_NUMBER,
                                                    FPT_PAY_MONTH_NO,
                                                    FPT_PAY_SOURCE_NUMBER,
                                                    FPT_PAY_LPY_NUMBER,
                                                    FPT_PAY_SPLIT_ID,
                                                    FPT_PAY_CALC_MONTH,
                                                    FPT_PAY_CALC_YEAR,
                                                    FPT_PAY_SUBS_MONTH,
                                                    FPT_PAY_SUBS_YEAR,
                                                    FPT_PAY_PAY_MONTH,
                                                    FPT_PAY_PAY_YEAR,
                                                    FPT_PAY_ORIGINAL_PAYMENT,
                                                    FPT_PAY_PAYMENT_PCT,
                                                    FPT_OPER_FLAG)
                     VALUES (seq_pay_number.NEXTVAL,
                             c.PAY_SOURCE_COM_NUMBER,
                             c.PAY_TARGET_COM_NUMBER,
                             c.PAY_CON_NUMBER,
                             i_dst_lic_no,
                             'P',                              --c.PAY_STATUS,
                             i_entry_date,                --c.PAY_STATUS_DATE,
                             c.PAY_AMOUNT,
                             c.PAY_CUR_CODE,
                             c.PAY_RATE,
                             'T',
                             c.PAY_DUE,
                             '',                            --c.PAY_REFERENCE,
                             i_pay_comment,
                             c.PAY_SUPPLIER_INVOICE,
                             i_entry_date,
                             i_entry_oper,
                             c.PAY_MARKUP_PERCENT,
                             c.PAY_FCD_NUMBER,
                             c.PAY_IS_DELETED,
                             c.PAY_UPDATE_COUNT,
                             i_entry_date,
                             l_pay_lsl_number,            -- c.PAY_LSL_NUMBER,
                             c.PAY_MONTH_NO,
                             c.PAY_NUMBER,
                             c.PAY_LPY_NUMBER,
                             c.PAY_SPLIT_ID,
                             c.PAY_CALC_MONTH,
                             c.PAY_CALC_YEAR,
                             c.PAY_SUBS_MONTH,
                             c.PAY_SUBS_YEAR,
                             c.PAY_PAY_MONTH,
                             c.PAY_PAY_YEAR,
                             c.PAY_ORIGINAL_PAYMENT,
                             c.PAY_PAYMENT_PCT,
                             'I');
                  ELSIF c.pay_status = 'N'
                  THEN
                     IF c.pay_amount <> 0
                     THEN
                        --Insert Not paid payment Destination
                        INSERT
                          INTO X_GTT_FID_PAYMENT_TEMP (
                                  FPT_PAY_NUMBER,
                                  FPT_PAY_SOURCE_COM_NUMBER,
                                  FPT_PAY_TARGET_COM_NUMBER,
                                  FPT_PAY_CON_NUMBER,
                                  FPT_PAY_LIC_NUMBER,
                                  FPT_PAY_STATUS,
                                  FPT_PAY_STATUS_DATE,
                                  FPT_PAY_AMOUNT,
                                  FPT_PAY_CUR_CODE,
                                  FPT_PAY_RATE,
                                  FPT_PAY_CODE,
                                  FPT_PAY_DUE,
                                  FPT_PAY_REFERENCE,
                                  FPT_PAY_COMMENT,
                                  FPT_PAY_SUPPLIER_INVOICE,
                                  FPT_PAY_ENTRY_DATE,
                                  FPT_PAY_ENTRY_OPER,
                                  FPT_PAY_MARKUP_PERCENT,
                                  FPT_PAY_FCD_NUMBER,
                                  FPT_PAY_IS_DELETED,
                                  FPT_PAY_UPDATE_COUNT,
                                  FPT_PAY_DATE,
                                  FPT_PAY_LSL_NUMBER,
                                  FPT_PAY_MONTH_NO,
                                  FPT_PAY_SOURCE_NUMBER,
                                  FPT_PAY_LPY_NUMBER,
                                  FPT_PAY_SPLIT_ID,
                                  FPT_PAY_CALC_MONTH,
                                  FPT_PAY_CALC_YEAR,
                                  FPT_PAY_SUBS_MONTH,
                                  FPT_PAY_SUBS_YEAR,
                                  FPT_PAY_PAY_MONTH,
                                  FPT_PAY_PAY_YEAR,
                                  FPT_PAY_ORIGINAL_PAYMENT,
                                  FPT_PAY_PAYMENT_PCT,
                                  FPT_OPER_FLAG)
                        VALUES (seq_pay_number.NEXTVAL,
                                c.PAY_SOURCE_COM_NUMBER,
                                c.PAY_TARGET_COM_NUMBER,
                                c.PAY_CON_NUMBER,
                                i_dst_lic_no,
                                'N',
                                i_entry_date,             --c.PAY_STATUS_DATE,
                                c.pay_amount,
                                c.PAY_CUR_CODE,
                                c.PAY_RATE,
                                'G',                            -- c.PAY_CODE,
                                c.PAY_DUE,                     --i_entry_date,
                                '',                         --c.PAY_REFERENCE,
                                i_pay_comment,
                                c.PAY_SUPPLIER_INVOICE,
                                i_entry_date,
                                i_entry_oper,
                                c.PAY_MARKUP_PERCENT,
                                c.PAY_FCD_NUMBER,
                                c.PAY_IS_DELETED,
                                c.PAY_UPDATE_COUNT,
                                NULL,
                                l_pay_lsl_number,         -- c.PAY_LSL_NUMBER,
                                c.PAY_MONTH_NO,
                                c.PAY_NUMBER,
                                c.PAY_LPY_NUMBER,
                                c.PAY_SPLIT_ID,
                                c.PAY_CALC_MONTH,
                                c.PAY_CALC_YEAR,
                                c.PAY_SUBS_MONTH,
                                c.PAY_SUBS_YEAR,
                                c.PAY_PAY_MONTH,
                                c.PAY_PAY_YEAR,
                                c.PAY_ORIGINAL_PAYMENT,
                                c.PAY_PAYMENT_PCT,
                                'I');
                     END IF;
                  END IF;
               END LOOP;
            ELSIF d.lsl_is_primary = 'N'
            THEN
               IF d.lsl_lee_price <> 0
               THEN
                  SELECT COUNT (*)
                    INTO l_dest_count
                    FROM x_fin_lic_sec_lee
                   WHERE lsl_lic_number = i_dst_lic_no
                         AND lsl_lee_number = d.lsl_lee_number;

                  IF l_dest_count = 0
                  THEN
                     SELECT x_seq_lic_sec_lee.NEXTVAL
                       INTO l_get_sequence
                       FROM DUAL;

                     INSERT INTO x_fin_lic_sec_lee
                          VALUES (l_get_sequence,
                                  i_dst_lic_no,
                                  d.lsl_lee_number,
                                  d.lsl_lee_price,
                                  'N',
                                  'SYSTEM',
                                  SYSDATE,
                                  0,
                                  NULL,
                                  NULL);

                     FOR c
                        IN (SELECT p.*
                              FROM fid_payment p
                             WHERE p.pay_lic_number = i_src_lic_no
                                   AND p.pay_lsl_number = d.lsl_number)
                     LOOP
                        IF c.pay_status = 'P'
                        THEN
                           ----Insert Source
                           INSERT
                             INTO X_GTT_FID_PAYMENT_TEMP (
                                     FPT_PAY_NUMBER,
                                     FPT_PAY_SOURCE_COM_NUMBER,
                                     FPT_PAY_TARGET_COM_NUMBER,
                                     FPT_PAY_CON_NUMBER,
                                     FPT_PAY_LIC_NUMBER,
                                     FPT_PAY_STATUS,
                                     FPT_PAY_STATUS_DATE,
                                     FPT_PAY_AMOUNT,
                                     FPT_PAY_CUR_CODE,
                                     FPT_PAY_RATE,
                                     FPT_PAY_CODE,
                                     FPT_PAY_DUE,
                                     FPT_PAY_REFERENCE,
                                     FPT_PAY_COMMENT,
                                     FPT_PAY_SUPPLIER_INVOICE,
                                     FPT_PAY_ENTRY_DATE,
                                     FPT_PAY_ENTRY_OPER,
                                     FPT_PAY_MARKUP_PERCENT,
                                     FPT_PAY_FCD_NUMBER,
                                     FPT_PAY_IS_DELETED,
                                     FPT_PAY_UPDATE_COUNT,
                                     FPT_PAY_DATE,
                                     FPT_PAY_LSL_NUMBER,
                                     FPT_PAY_MONTH_NO,
                                     FPT_PAY_SOURCE_NUMBER,
                                     FPT_PAY_LPY_NUMBER,
                                     FPT_PAY_SPLIT_ID,
                                     FPT_PAY_CALC_MONTH,
                                     FPT_PAY_CALC_YEAR,
                                     FPT_PAY_SUBS_MONTH,
                                     FPT_PAY_SUBS_YEAR,
                                     FPT_PAY_PAY_MONTH,
                                     FPT_PAY_PAY_YEAR,
                                     FPT_PAY_ORIGINAL_PAYMENT,
                                     FPT_PAY_PAYMENT_PCT,
                                     FPT_OPER_FLAG)
                           VALUES (seq_pay_number.NEXTVAL,
                                   c.PAY_SOURCE_COM_NUMBER,
                                   c.PAY_TARGET_COM_NUMBER,
                                   c.PAY_CON_NUMBER,
                                   c.PAY_LIC_NUMBER,
                                   'P',                        --c.PAY_STATUS,
                                   i_entry_date,          --c.PAY_STATUS_DATE,
                                   -c.PAY_AMOUNT,
                                   c.PAY_CUR_CODE,
                                   c.PAY_RATE,
                                   'T',
                                   c.PAY_DUE,
                                   '',                      --c.PAY_REFERENCE,
                                   i_pay_comment,
                                   c.PAY_SUPPLIER_INVOICE,
                                   i_entry_date,
                                   i_entry_oper,
                                   c.PAY_MARKUP_PERCENT,
                                   c.PAY_FCD_NUMBER,
                                   c.PAY_IS_DELETED,
                                   c.PAY_UPDATE_COUNT,
                                   i_entry_date,
                                   c.PAY_LSL_NUMBER,
                                   c.PAY_MONTH_NO,
                                   c.PAY_NUMBER,
                                   c.PAY_LPY_NUMBER,
                                   c.PAY_SPLIT_ID,
                                   c.PAY_CALC_MONTH,
                                   c.PAY_CALC_YEAR,
                                   c.PAY_SUBS_MONTH,
                                   c.PAY_SUBS_YEAR,
                                   c.PAY_PAY_MONTH,
                                   c.PAY_PAY_YEAR,
                                   c.PAY_ORIGINAL_PAYMENT,
                                   c.PAY_PAYMENT_PCT,
                                   'I');

                           --Insert Destination
                           INSERT
                             INTO X_GTT_FID_PAYMENT_TEMP (
                                     FPT_PAY_NUMBER,
                                     FPT_PAY_SOURCE_COM_NUMBER,
                                     FPT_PAY_TARGET_COM_NUMBER,
                                     FPT_PAY_CON_NUMBER,
                                     FPT_PAY_LIC_NUMBER,
                                     FPT_PAY_STATUS,
                                     FPT_PAY_STATUS_DATE,
                                     FPT_PAY_AMOUNT,
                                     FPT_PAY_CUR_CODE,
                                     FPT_PAY_RATE,
                                     FPT_PAY_CODE,
                                     FPT_PAY_DUE,
                                     FPT_PAY_REFERENCE,
                                     FPT_PAY_COMMENT,
                                     FPT_PAY_SUPPLIER_INVOICE,
                                     FPT_PAY_ENTRY_DATE,
                                     FPT_PAY_ENTRY_OPER,
                                     FPT_PAY_MARKUP_PERCENT,
                                     FPT_PAY_FCD_NUMBER,
                                     FPT_PAY_IS_DELETED,
                                     FPT_PAY_UPDATE_COUNT,
                                     FPT_PAY_DATE,
                                     FPT_PAY_LSL_NUMBER,
                                     FPT_PAY_MONTH_NO,
                                     FPT_PAY_SOURCE_NUMBER,
                                     FPT_PAY_LPY_NUMBER,
                                     FPT_PAY_SPLIT_ID,
                                     FPT_PAY_CALC_MONTH,
                                     FPT_PAY_CALC_YEAR,
                                     FPT_PAY_SUBS_MONTH,
                                     FPT_PAY_SUBS_YEAR,
                                     FPT_PAY_PAY_MONTH,
                                     FPT_PAY_PAY_YEAR,
                                     FPT_PAY_ORIGINAL_PAYMENT,
                                     FPT_PAY_PAYMENT_PCT,
                                     FPT_OPER_FLAG)
                           VALUES (seq_pay_number.NEXTVAL,
                                   c.PAY_SOURCE_COM_NUMBER,
                                   c.PAY_TARGET_COM_NUMBER,
                                   c.PAY_CON_NUMBER,
                                   i_dst_lic_no,
                                   'P',                        --c.PAY_STATUS,
                                   i_entry_date,          --c.PAY_STATUS_DATE,
                                   c.PAY_AMOUNT,
                                   c.PAY_CUR_CODE,
                                   c.PAY_RATE,
                                   'T',
                                   c.PAY_DUE,
                                   '',                      --c.PAY_REFERENCE,
                                   i_pay_comment,
                                   c.PAY_SUPPLIER_INVOICE,
                                   i_entry_date,
                                   i_entry_oper,
                                   c.PAY_MARKUP_PERCENT,
                                   c.PAY_FCD_NUMBER,
                                   c.PAY_IS_DELETED,
                                   c.PAY_UPDATE_COUNT,
                                   i_entry_date,
                                   l_get_sequence,        -- c.PAY_LSL_NUMBER,
                                   c.PAY_MONTH_NO,
                                   c.PAY_NUMBER,
                                   c.PAY_LPY_NUMBER,
                                   c.PAY_SPLIT_ID,
                                   c.PAY_CALC_MONTH,
                                   c.PAY_CALC_YEAR,
                                   c.PAY_SUBS_MONTH,
                                   c.PAY_SUBS_YEAR,
                                   c.PAY_PAY_MONTH,
                                   c.PAY_PAY_YEAR,
                                   c.PAY_ORIGINAL_PAYMENT,
                                   c.PAY_PAYMENT_PCT,
                                   'I');
                        ELSIF c.pay_status = 'N'
                        THEN
                           IF c.pay_amount <> 0
                           THEN
                              --Insert Not paid payment Destination
                              INSERT
                                INTO X_GTT_FID_PAYMENT_TEMP (
                                        FPT_PAY_NUMBER,
                                        FPT_PAY_SOURCE_COM_NUMBER,
                                        FPT_PAY_TARGET_COM_NUMBER,
                                        FPT_PAY_CON_NUMBER,
                                        FPT_PAY_LIC_NUMBER,
                                        FPT_PAY_STATUS,
                                        FPT_PAY_STATUS_DATE,
                                        FPT_PAY_AMOUNT,
                                        FPT_PAY_CUR_CODE,
                                        FPT_PAY_RATE,
                                        FPT_PAY_CODE,
                                        FPT_PAY_DUE,
                                        FPT_PAY_REFERENCE,
                                        FPT_PAY_COMMENT,
                                        FPT_PAY_SUPPLIER_INVOICE,
                                        FPT_PAY_ENTRY_DATE,
                                        FPT_PAY_ENTRY_OPER,
                                        FPT_PAY_MARKUP_PERCENT,
                                        FPT_PAY_FCD_NUMBER,
                                        FPT_PAY_IS_DELETED,
                                        FPT_PAY_UPDATE_COUNT,
                                        FPT_PAY_DATE,
                                        FPT_PAY_LSL_NUMBER,
                                        FPT_PAY_MONTH_NO,
                                        FPT_PAY_SOURCE_NUMBER,
                                        FPT_PAY_LPY_NUMBER,
                                        FPT_PAY_SPLIT_ID,
                                        FPT_PAY_CALC_MONTH,
                                        FPT_PAY_CALC_YEAR,
                                        FPT_PAY_SUBS_MONTH,
                                        FPT_PAY_SUBS_YEAR,
                                        FPT_PAY_PAY_MONTH,
                                        FPT_PAY_PAY_YEAR,
                                        FPT_PAY_ORIGINAL_PAYMENT,
                                        FPT_PAY_PAYMENT_PCT,
                                        FPT_OPER_FLAG)
                              VALUES (seq_pay_number.NEXTVAL,
                                      c.PAY_SOURCE_COM_NUMBER,
                                      c.PAY_TARGET_COM_NUMBER,
                                      c.PAY_CON_NUMBER,
                                      i_dst_lic_no,
                                      'N',
                                      i_entry_date,       --c.PAY_STATUS_DATE,
                                      c.pay_amount,
                                      c.PAY_CUR_CODE,
                                      c.PAY_RATE,
                                      'G',                      -- c.PAY_CODE,
                                      c.PAY_DUE,               --i_entry_date,
                                      '',                   --c.PAY_REFERENCE,
                                      i_pay_comment,
                                      c.PAY_SUPPLIER_INVOICE,
                                      i_entry_date,
                                      i_entry_oper,
                                      c.PAY_MARKUP_PERCENT,
                                      c.PAY_FCD_NUMBER,
                                      c.PAY_IS_DELETED,
                                      c.PAY_UPDATE_COUNT,
                                      NULL,
                                      l_get_sequence,     -- c.PAY_LSL_NUMBER,
                                      c.PAY_MONTH_NO,
                                      c.PAY_NUMBER,
                                      c.PAY_LPY_NUMBER,
                                      c.PAY_SPLIT_ID,
                                      c.PAY_CALC_MONTH,
                                      c.PAY_CALC_YEAR,
                                      c.PAY_SUBS_MONTH,
                                      c.PAY_SUBS_YEAR,
                                      c.PAY_PAY_MONTH,
                                      c.PAY_PAY_YEAR,
                                      c.PAY_ORIGINAL_PAYMENT,
                                      c.PAY_PAYMENT_PCT,
                                      'I');
                           END IF;
                        END IF;
                     END LOOP;
                  ELSE
                     SELECT lsl_number
                       INTO l_pay_lsl_number2
                       FROM x_fin_lic_sec_lee
                      WHERE lsl_lic_number = i_dst_lic_no
                            AND lsl_lee_number = d.lsl_lee_number;

                     FOR c
                        IN (SELECT p.*
                              FROM fid_payment p
                             WHERE p.pay_lic_number = i_src_lic_no
                                   AND p.pay_lsl_number = d.lsl_number)
                     LOOP
                        IF c.pay_status = 'P'
                        THEN
                           ----Insert Source
                           INSERT
                             INTO X_GTT_FID_PAYMENT_TEMP (
                                     FPT_PAY_NUMBER,
                                     FPT_PAY_SOURCE_COM_NUMBER,
                                     FPT_PAY_TARGET_COM_NUMBER,
                                     FPT_PAY_CON_NUMBER,
                                     FPT_PAY_LIC_NUMBER,
                                     FPT_PAY_STATUS,
                                     FPT_PAY_STATUS_DATE,
                                     FPT_PAY_AMOUNT,
                                     FPT_PAY_CUR_CODE,
                                     FPT_PAY_RATE,
                                     FPT_PAY_CODE,
                                     FPT_PAY_DUE,
                                     FPT_PAY_REFERENCE,
                                     FPT_PAY_COMMENT,
                                     FPT_PAY_SUPPLIER_INVOICE,
                                     FPT_PAY_ENTRY_DATE,
                                     FPT_PAY_ENTRY_OPER,
                                     FPT_PAY_MARKUP_PERCENT,
                                     FPT_PAY_FCD_NUMBER,
                                     FPT_PAY_IS_DELETED,
                                     FPT_PAY_UPDATE_COUNT,
                                     FPT_PAY_DATE,
                                     FPT_PAY_LSL_NUMBER,
                                     FPT_PAY_MONTH_NO,
                                     FPT_PAY_SOURCE_NUMBER,
                                     FPT_PAY_LPY_NUMBER,
                                     FPT_PAY_SPLIT_ID,
                                     FPT_PAY_CALC_MONTH,
                                     FPT_PAY_CALC_YEAR,
                                     FPT_PAY_SUBS_MONTH,
                                     FPT_PAY_SUBS_YEAR,
                                     FPT_PAY_PAY_MONTH,
                                     FPT_PAY_PAY_YEAR,
                                     FPT_PAY_ORIGINAL_PAYMENT,
                                     FPT_PAY_PAYMENT_PCT,
                                     FPT_OPER_FLAG)
                           VALUES (seq_pay_number.NEXTVAL,
                                   c.PAY_SOURCE_COM_NUMBER,
                                   c.PAY_TARGET_COM_NUMBER,
                                   c.PAY_CON_NUMBER,
                                   c.PAY_LIC_NUMBER,
                                   'P',                        --c.PAY_STATUS,
                                   i_entry_date,          --c.PAY_STATUS_DATE,
                                   -c.PAY_AMOUNT,
                                   c.PAY_CUR_CODE,
                                   c.PAY_RATE,
                                   'T',
                                   c.PAY_DUE,
                                   '',                      --c.PAY_REFERENCE,
                                   i_pay_comment,
                                   c.PAY_SUPPLIER_INVOICE,
                                   i_entry_date,
                                   i_entry_oper,
                                   c.PAY_MARKUP_PERCENT,
                                   c.PAY_FCD_NUMBER,
                                   c.PAY_IS_DELETED,
                                   c.PAY_UPDATE_COUNT,
                                   i_entry_date,
                                   c.PAY_LSL_NUMBER,
                                   c.PAY_MONTH_NO,
                                   c.PAY_NUMBER,
                                   c.PAY_LPY_NUMBER,
                                   c.PAY_SPLIT_ID,
                                   c.PAY_CALC_MONTH,
                                   c.PAY_CALC_YEAR,
                                   c.PAY_SUBS_MONTH,
                                   c.PAY_SUBS_YEAR,
                                   c.PAY_PAY_MONTH,
                                   c.PAY_PAY_YEAR,
                                   c.PAY_ORIGINAL_PAYMENT,
                                   c.PAY_PAYMENT_PCT,
                                   'I');

                           --Insert Destination
                           INSERT
                             INTO X_GTT_FID_PAYMENT_TEMP (
                                     FPT_PAY_NUMBER,
                                     FPT_PAY_SOURCE_COM_NUMBER,
                                     FPT_PAY_TARGET_COM_NUMBER,
                                     FPT_PAY_CON_NUMBER,
                                     FPT_PAY_LIC_NUMBER,
                                     FPT_PAY_STATUS,
                                     FPT_PAY_STATUS_DATE,
                                     FPT_PAY_AMOUNT,
                                     FPT_PAY_CUR_CODE,
                                     FPT_PAY_RATE,
                                     FPT_PAY_CODE,
                                     FPT_PAY_DUE,
                                     FPT_PAY_REFERENCE,
                                     FPT_PAY_COMMENT,
                                     FPT_PAY_SUPPLIER_INVOICE,
                                     FPT_PAY_ENTRY_DATE,
                                     FPT_PAY_ENTRY_OPER,
                                     FPT_PAY_MARKUP_PERCENT,
                                     FPT_PAY_FCD_NUMBER,
                                     FPT_PAY_IS_DELETED,
                                     FPT_PAY_UPDATE_COUNT,
                                     FPT_PAY_DATE,
                                     FPT_PAY_LSL_NUMBER,
                                     FPT_PAY_MONTH_NO,
                                     FPT_PAY_SOURCE_NUMBER,
                                     FPT_PAY_LPY_NUMBER,
                                     FPT_PAY_SPLIT_ID,
                                     FPT_PAY_CALC_MONTH,
                                     FPT_PAY_CALC_YEAR,
                                     FPT_PAY_SUBS_MONTH,
                                     FPT_PAY_SUBS_YEAR,
                                     FPT_PAY_PAY_MONTH,
                                     FPT_PAY_PAY_YEAR,
                                     FPT_PAY_ORIGINAL_PAYMENT,
                                     FPT_PAY_PAYMENT_PCT,
                                     FPT_OPER_FLAG)
                           VALUES (seq_pay_number.NEXTVAL,
                                   c.PAY_SOURCE_COM_NUMBER,
                                   c.PAY_TARGET_COM_NUMBER,
                                   c.PAY_CON_NUMBER,
                                   i_dst_lic_no,
                                   'P',                        --c.PAY_STATUS,
                                   i_entry_date,          --c.PAY_STATUS_DATE,
                                   c.PAY_AMOUNT,
                                   c.PAY_CUR_CODE,
                                   c.PAY_RATE,
                                   'T',
                                   c.PAY_DUE,
                                   '',                      --c.PAY_REFERENCE,
                                   i_pay_comment,
                                   c.PAY_SUPPLIER_INVOICE,
                                   i_entry_date,
                                   i_entry_oper,
                                   c.PAY_MARKUP_PERCENT,
                                   c.PAY_FCD_NUMBER,
                                   c.PAY_IS_DELETED,
                                   c.PAY_UPDATE_COUNT,
                                   i_entry_date,
                                   l_pay_lsl_number2,     -- c.PAY_LSL_NUMBER,
                                   c.PAY_MONTH_NO,
                                   c.PAY_NUMBER,
                                   c.PAY_LPY_NUMBER,
                                   c.PAY_SPLIT_ID,
                                   c.PAY_CALC_MONTH,
                                   c.PAY_CALC_YEAR,
                                   c.PAY_SUBS_MONTH,
                                   c.PAY_SUBS_YEAR,
                                   c.PAY_PAY_MONTH,
                                   c.PAY_PAY_YEAR,
                                   c.PAY_ORIGINAL_PAYMENT,
                                   c.PAY_PAYMENT_PCT,
                                   'I');
                        ELSIF c.pay_status = 'N'
                        THEN
                           IF c.pay_amount <> 0
                           THEN
                              --Insert Not paid payment Destination
                              INSERT
                                INTO X_GTT_FID_PAYMENT_TEMP (
                                        FPT_PAY_NUMBER,
                                        FPT_PAY_SOURCE_COM_NUMBER,
                                        FPT_PAY_TARGET_COM_NUMBER,
                                        FPT_PAY_CON_NUMBER,
                                        FPT_PAY_LIC_NUMBER,
                                        FPT_PAY_STATUS,
                                        FPT_PAY_STATUS_DATE,
                                        FPT_PAY_AMOUNT,
                                        FPT_PAY_CUR_CODE,
                                        FPT_PAY_RATE,
                                        FPT_PAY_CODE,
                                        FPT_PAY_DUE,
                                        FPT_PAY_REFERENCE,
                                        FPT_PAY_COMMENT,
                                        FPT_PAY_SUPPLIER_INVOICE,
                                        FPT_PAY_ENTRY_DATE,
                                        FPT_PAY_ENTRY_OPER,
                                        FPT_PAY_MARKUP_PERCENT,
                                        FPT_PAY_FCD_NUMBER,
                                        FPT_PAY_IS_DELETED,
                                        FPT_PAY_UPDATE_COUNT,
                                        FPT_PAY_DATE,
                                        FPT_PAY_LSL_NUMBER,
                                        FPT_PAY_MONTH_NO,
                                        FPT_PAY_SOURCE_NUMBER,
                                        FPT_PAY_LPY_NUMBER,
                                        FPT_PAY_SPLIT_ID,
                                        FPT_PAY_CALC_MONTH,
                                        FPT_PAY_CALC_YEAR,
                                        FPT_PAY_SUBS_MONTH,
                                        FPT_PAY_SUBS_YEAR,
                                        FPT_PAY_PAY_MONTH,
                                        FPT_PAY_PAY_YEAR,
                                        FPT_PAY_ORIGINAL_PAYMENT,
                                        FPT_PAY_PAYMENT_PCT,
                                        FPT_OPER_FLAG)
                              VALUES (seq_pay_number.NEXTVAL,
                                      c.PAY_SOURCE_COM_NUMBER,
                                      c.PAY_TARGET_COM_NUMBER,
                                      c.PAY_CON_NUMBER,
                                      i_dst_lic_no,
                                      'N',
                                      i_entry_date,       --c.PAY_STATUS_DATE,
                                      c.pay_amount,
                                      c.PAY_CUR_CODE,
                                      c.PAY_RATE,
                                      'G',                      -- c.PAY_CODE,
                                      c.PAY_DUE,               --i_entry_date,
                                      '',                   --c.PAY_REFERENCE,
                                      i_pay_comment,
                                      c.PAY_SUPPLIER_INVOICE,
                                      i_entry_date,
                                      i_entry_oper,
                                      c.PAY_MARKUP_PERCENT,
                                      c.PAY_FCD_NUMBER,
                                      c.PAY_IS_DELETED,
                                      c.PAY_UPDATE_COUNT,
                                      NULL,
                                      l_pay_lsl_number2,  -- c.PAY_LSL_NUMBER,
                                      c.PAY_MONTH_NO,
                                      c.PAY_NUMBER,
                                      c.PAY_LPY_NUMBER,
                                      c.PAY_SPLIT_ID,
                                      c.PAY_CALC_MONTH,
                                      c.PAY_CALC_YEAR,
                                      c.PAY_SUBS_MONTH,
                                      c.PAY_SUBS_YEAR,
                                      c.PAY_PAY_MONTH,
                                      c.PAY_PAY_YEAR,
                                      c.PAY_ORIGINAL_PAYMENT,
                                      c.PAY_PAYMENT_PCT,
                                      'I');
                           END IF;
                        END IF;
                     END LOOP;
                  END IF;
               END IF;
            END IF;
         END LOOP;

         /*    delete from fid_payment p
             where p.pay_lic_number = i_src_lic_no
             and p.pay_status='N'; */


         FOR d IN (SELECT lsl_number,
                          lsl_is_primary,
                          lsl_lee_number,
                          lsl_lee_price
                     FROM x_fin_lic_sec_lee
                    WHERE lsl_lic_number = i_src_lic_no)
         LOOP
            IF d.lsl_lee_price <> 0
            THEN
               INSERT INTO X_GTT_FID_PAYMENT_TEMP
                  SELECT PAY_NUMBER,
                         PAY_SOURCE_COM_NUMBER,
                         PAY_TARGET_COM_NUMBER,
                         PAY_CON_NUMBER,
                         PAY_LIC_NUMBER,
                         PAY_STATUS,
                         PAY_STATUS_DATE,
                         PAY_AMOUNT,
                         PAY_CUR_CODE,
                         PAY_RATE,
                         PAY_CODE,
                         PAY_DUE,
                         PAY_REFERENCE,
                         PAY_COMMENT,
                         PAY_SUPPLIER_INVOICE,
                         PAY_ENTRY_DATE,
                         PAY_ENTRY_OPER,
                         PAY_MARKUP_PERCENT,
                         PAY_FCD_NUMBER,
                         PAY_IS_DELETED,
                         PAY_UPDATE_COUNT,
                         PAY_DATE,
                         PAY_LSL_NUMBER,
                         PAY_MONTH_NO,
                         PAY_SOURCE_NUMBER,
                         PAY_LPY_NUMBER,
                         PAY_SPLIT_ID,
                         PAY_CALC_MONTH,
                         PAY_CALC_YEAR,
                         PAY_SUBS_MONTH,
                         PAY_SUBS_YEAR,
                         PAY_PAY_MONTH,
                         PAY_PAY_YEAR,
                         PAY_ORIGINAL_PAYMENT,
                         PAY_PAYMENT_PCT,
                         'D',
                         PAY_MGP_NUMBER, ----- Warner Payment 14-07-2015:ADded By Rashmi Tijare
                         PAY_EXCH_OPER
                    FROM FID_PAYMENT p
                   WHERE     p.pay_lic_number = i_src_lic_no
                         AND p.pay_status = 'N'
                         AND p.pay_lsl_number = d.lsl_number;
            END IF;
         END LOOP;
      -- commit;
      ELSE
         raise_application_error (
            -20010,
            'Negative paid payments exists,hence transfer of license price is not allowed');
         o_success_flag := -1;
      END IF;

      o_success_flag := 1;
   EXCEPTION
      WHEN value_large
      THEN
         o_success_flag := -1;
         raise_application_error (
            -20011,
            'Input Value too large for column Comments ');
      WHEN OTHERS
      THEN
         o_success_flag := -1;
         raise_application_error (-20011, SQLERRM);
   END x_prc_alic_cm_transfer_payment;


   PROCEDURE x_prc_alic_cm_trnsfr_pmt_ins (i_username   IN     VARCHAR2,
                                           o_status        OUT NUMBER)
   AS
      l_count    NUMBER;
      l_number   NUMBER;
   BEGIN
      o_status := -1;

      SELECT COUNT (*)
        INTO l_count
        FROM X_GTT_FID_PAYMENT_TEMP
       WHERE FPT_OPER_FLAG = 'I';

      IF (l_count > 0)
      THEN
         SELECT PKG_CM_USERNAME.SetUserName (i_username)
           INTO l_number
           FROM DUAL;
          --Finance Dev Phase I Zeshan [Start] [Added column names for insert operation]
         INSERT INTO fid_payment
                   (PAY_NUMBER,
                    PAY_SOURCE_COM_NUMBER,
                    PAY_TARGET_COM_NUMBER,
                    PAY_CON_NUMBER,
                    PAY_LIC_NUMBER,
                    PAY_STATUS,
                    PAY_STATUS_DATE,
                    PAY_AMOUNT,
                    PAY_CUR_CODE,
                    PAY_RATE,
                    PAY_CODE,
                    PAY_DUE,
                    PAY_REFERENCE,
                    PAY_COMMENT,
                    PAY_SUPPLIER_INVOICE,
                    PAY_ENTRY_DATE,
                    PAY_ENTRY_OPER,
                    PAY_MARKUP_PERCENT,
                    PAY_FCD_NUMBER,
                    PAY_IS_DELETED,
                    PAY_UPDATE_COUNT,
                    PAY_DATE,
                    PAY_LSL_NUMBER,
                    PAY_MONTH_NO,
                    PAY_SOURCE_NUMBER,
                    PAY_LPY_NUMBER,
                    PAY_SPLIT_ID,
                    PAY_CALC_MONTH,
                    PAY_CALC_YEAR,
                    PAY_SUBS_MONTH,
                    PAY_SUBS_YEAR,
                    PAY_PAY_MONTH,
                    PAY_PAY_YEAR,
                    PAY_ORIGINAL_PAYMENT,
                    PAY_PAYMENT_PCT,
                    PAY_MNET_REFERENCE,
                    PAY_MGP_NUMBER,
                    PAY_EXCH_OPER)
            SELECT FPT_PAY_NUMBER,
                   FPT_PAY_SOURCE_COM_NUMBER,
                   FPT_PAY_TARGET_COM_NUMBER,
                   FPT_PAY_CON_NUMBER,
                   FPT_PAY_LIC_NUMBER,
                   FPT_PAY_STATUS,
                   FPT_PAY_STATUS_DATE,
                   FPT_PAY_AMOUNT,
                   FPT_PAY_CUR_CODE,
                   FPT_PAY_RATE,
                   FPT_PAY_CODE,
                   FPT_PAY_DUE,
                   FPT_PAY_REFERENCE,
                   FPT_PAY_COMMENT,
                   FPT_PAY_SUPPLIER_INVOICE,
                   FPT_PAY_ENTRY_DATE,
                   FPT_PAY_ENTRY_OPER,
                   FPT_PAY_MARKUP_PERCENT,
                   FPT_PAY_FCD_NUMBER,
                   FPT_PAY_IS_DELETED,
                   FPT_PAY_UPDATE_COUNT,
                   FPT_PAY_DATE,
                   FPT_PAY_LSL_NUMBER,
                   FPT_PAY_MONTH_NO,
                   FPT_PAY_SOURCE_NUMBER,
                   FPT_PAY_LPY_NUMBER,
                   FPT_PAY_SPLIT_ID,
                   FPT_PAY_CALC_MONTH,
                   FPT_PAY_CALC_YEAR,
                   FPT_PAY_SUBS_MONTH,
                   FPT_PAY_SUBS_YEAR,
                   FPT_PAY_PAY_MONTH,
                   FPT_PAY_PAY_YEAR,
                   FPT_PAY_ORIGINAL_PAYMENT,
                   FPT_PAY_PAYMENT_PCT,
                   NULL, -- Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                   FPT_PAY_MGP_NUMBER, ----- Warner Payment 14-07-2015:ADded By Rashmi Tijare
                   FPT_PAY_EXCH_OPER--- Added By Rashmi For Spot Exchange Routine
              FROM X_GTT_FID_PAYMENT_TEMP
             WHERE FPT_OPER_FLAG = 'I';
              --Finance Dev Phase I [End]

         IF SQL%ROWCOUNT > 0
         THEN
            o_status := 1;
         -- commit;
         ELSE
            o_status := -1;
            ROLLBACK;
         END IF;
      ELSE
         o_status := 1;
      END IF;
   END;


   PROCEDURE x_prc_alic_cm_trnsfr_pmt_del (i_username   IN     VARCHAR2,
                                           o_status        OUT NUMBER)
   AS
      l_count    NUMBER;
      l_number   NUMBER;
   BEGIN
      o_status := -1;

      SELECT COUNT (*)
        INTO l_count
        FROM X_GTT_FID_PAYMENT_TEMP
       WHERE FPT_OPER_FLAG = 'D';

      IF (l_count > 0)
      THEN
         SELECT PKG_CM_USERNAME.SetUserName (i_username)
           INTO l_number
           FROM DUAL;

         DELETE FROM fid_payment
               WHERE pay_number IN (SELECT FPT_PAY_NUMBER
                                      FROM X_GTT_FID_PAYMENT_TEMP
                                     WHERE FPT_OPER_FLAG = 'D');

         IF SQL%ROWCOUNT > 0
         THEN
            o_status := 1;
         -- commit;
         ELSE
            o_status := -1;
            ROLLBACK;
         END IF;
      ELSE
         o_status := 1;
      END IF;
   END;


   PROCEDURE x_prc_alic_cm_trf_validation (
      i_src_lic_no    FID_LICENSE.lic_number%TYPE,
      i_dst_lic_no    FID_LICENSE.lic_number%TYPE)
   AS
      l_dst_lic_start_date         DATE;
      l_src_lic_start_date         DATE;
      l_src_costing_rule_from_dt   DATE;
      l_src_costing_rule_to_dt     DATE;
      l_dst_costing_rule_from_dt   DATE;
      l_dst_costing_rule_to_dt     DATE;
      l_go_live_date               DATE;
      l_neg_paid_payments_cnt      NUMBER;
      l_paid_payment               NUMBER;
      l_dst_lic_runs_alloc         NUMBER;
      l_amort_exh_src              NUMBER;
      l_amort_exh_dst              NUMBER;
      l_is_primary_flag            CHAR (1);
      l_dst_cost_schedules         NUMBER;
      l_dst_lic_currency           fid_license.lic_currency%TYPE;
      l_src_lic_currency           fid_license.lic_currency%TYPE;
      l_dst_lic_end_date           DATE;
      l_src_lic_end_date           DATE;
      l_current_month              DATE;
      l_dst_lic_status             fid_license.lic_status%TYPE;
      l_src_lic_status             fid_license.lic_status%TYPE;
   BEGIN
      SELECT L.LIC_START,
             l.lic_showing_int,
             lic_showing_lic,
             L.lic_currency,
             l.lic_end,
             l.lic_status
        INTO l_dst_lic_start_date,
             l_dst_lic_runs_alloc,
             l_amort_exh_dst,
             l_dst_lic_currency,
             l_dst_lic_end_date,
             l_dst_lic_status
        FROM FID_LICENSE L
       WHERE L.LIC_NUMBER = i_dst_lic_no;

      SELECT TO_DATE (
                   '01'
                || '-'
                || TO_CHAR (SYSDATE, 'MON')
                || '-'
                || TO_CHAR (SYSDATE, 'YYYY'))
        INTO l_current_month
        FROM DUAL;

      ---- CONSIDERATION FOR 5+2 COSTING RULE GO_LIVE DATE
      SELECT TO_DATE (C.CONTENT)
        INTO l_go_live_date
        FROM X_FIN_CONFIGS C
       --  WHERE C.KEY = 'COSTING_5+2_GO_LIVE_DATE';
       WHERE C.ID = 6;

      SELECT COUNT (1)
        INTO l_neg_paid_payments_cnt
        FROM fid_payment p
       WHERE     p.pay_lic_number = i_src_lic_no
             AND p.pay_status = 'P'
             AND p.pay_amount < 0;

      SELECT SUM (p.pay_amount)
        INTO l_paid_payment
        FROM fid_payment p
       WHERE p.pay_lic_number = i_dst_lic_no AND p.pay_status = 'P';

      SELECT L.LIC_START,
             L.LIC_SHOWING_LIC,
             L.LIC_CURRENCY,
             L.LIC_END,
             L.LIC_STATUS
        INTO l_src_lic_start_date,
             l_amort_exh_src,
             l_src_lic_currency,
             l_src_lic_end_date,
             l_src_lic_status
        FROM fid_license l
       WHERE l.lic_number = i_src_lic_no;

      IF l_dst_lic_start_date < l_go_live_date
      THEN
         raise_application_error (
            -20001,
            'License Start Date of destination license falls before Go-live date of 5+2 Costing rule implementation');
      END IF;

      IF l_amort_exh_src <> 0
      THEN
         BEGIN
            SELECT r.crc_lic_start_from, r.crc_lic_start_to
              INTO l_src_costing_rule_from_dt, l_src_costing_rule_to_dt
              FROM x_fin_costing_rule_config r
             WHERE r.crc_costed_runs = l_amort_exh_src                     --7
                   AND l_src_lic_start_date BETWEEN r.crc_lic_start_from
                                                AND r.crc_lic_start_to;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20001,
                  'No Costing Rule defined for the source license ');
         END;
      END IF;

      IF l_amort_exh_dst <> 0
      THEN
         BEGIN
            SELECT r.crc_lic_start_from, r.crc_lic_start_to
              INTO l_dst_costing_rule_from_dt, l_dst_costing_rule_to_dt
              FROM x_fin_costing_rule_config r
             WHERE r.crc_costed_runs = l_amort_exh_dst                     --7
                   AND l_dst_lic_start_date BETWEEN r.crc_lic_start_from
                                                AND r.crc_lic_start_to;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20001,
                  'No Costing Rule defined for the destination license ');
         END;
      ELSE
         l_dst_costing_rule_from_dt := l_dst_lic_start_date;
         l_dst_costing_rule_to_dt := TO_DATE ('31-DEC-2199');
      END IF;

      SELECT CASE WHEN COUNT (1) > 0 THEN 'Y' ELSE 'N' END CASE
        INTO l_is_primary_flag
        FROM X_FIN_LIC_SEC_LEE C
       WHERE c.lsl_is_primary = 'N' AND c.lsl_lic_number = i_dst_lic_no;

      SELECT COUNT (csh_number)
        INTO l_dst_cost_schedules
        FROM x_fin_cost_schedules
       WHERE csh_lic_number = i_dst_lic_no;

      IF l_amort_exh_dst <> 0
      THEN
         IF (l_src_costing_rule_from_dt <> l_dst_costing_rule_from_dt
             OR l_src_costing_rule_to_dt <> l_dst_costing_rule_to_dt --OR l_amort_exh_src <> l_amort_exh_dst
                                                                    )
         THEN
            raise_application_error (
               -20001,
               'Source and destination licenses lie under different costing rules ');
         END IF;
      ELSE
         IF (l_dst_costing_rule_from_dt < l_src_costing_rule_from_dt
             AND l_dst_costing_rule_to_dt < l_src_costing_rule_from_dt)
            OR (l_dst_costing_rule_from_dt > l_src_costing_rule_to_dt
                AND l_dst_costing_rule_to_dt > l_src_costing_rule_to_dt)
         THEN
            raise_application_error (
               -20001,
               'Source and destination licenses lie under different costing rules ');
         END IF;
      END IF;

      IF l_neg_paid_payments_cnt > 0
      THEN
         raise_application_error (
            -20002,
            'Negative paid payments are present on the Source license '
            || i_src_lic_no);
      END IF;

      IF l_paid_payment <> 0
      THEN
         raise_application_error (
            -20003,
            'Sum of paid payments do not equal 0 for destination license');
      END IF;

      IF l_dst_lic_runs_alloc < l_amort_exh_src
      THEN
         raise_application_error (
            -20004,
            'Amortization Exh of source license exceeds the total runs of destination license. Please select another license');
      END IF;

      /*   IF l_is_primary_flag = 'Y'
         THEN
            raise_application_error (
               -20005,
               'Selected license has a secondary licensee assigned to it. Please select another license.');
         END IF; */

      IF l_dst_cost_schedules > l_amort_exh_src
      THEN
         raise_application_error (
            -20007,
            'Selected license has more costed schedules than source Amo Exh. ');
      END IF;

      IF l_dst_lic_currency <> l_src_lic_currency
      THEN
         raise_application_error (
            -20007,
            'Source and destination license must have same currency. ');
      END IF;

      /* IF x_fun_is_primary (i_src_lic_no) = 'Y'
       THEN
          raise_application_error (
             -20007,
             'Cannot transfer license price as source license has a secondary licensee assigned to it.');
       END IF; */

     -- DBMS_OUTPUT.PUT_LINE ('l_src_lic_end_date ' || L_SRC_LIC_END_DATE);
      --DBMS_OUTPUT.PUT_LINE ('l_src_lic_status ' || L_SRC_LIC_STATUS);
      --DBMS_OUTPUT.PUT_LINE ('l_dst_lic_end_date ' || L_DST_LIC_END_DATE);
     -- DBMS_OUTPUT.put_line ('l_dst_lic_status ' || l_dst_lic_status);


      IF ( (l_src_lic_end_date < l_current_month) OR (l_src_lic_status = 'I'))
      THEN
         raise_application_error (
            -20007,
            'Cannot transfer license price as source license is Expired/Inactive');
      END IF;

      IF ( (l_dst_lic_end_date < l_current_month) OR (l_dst_lic_status = 'I'))
      THEN
         raise_application_error (
            -20007,
            'Cannot transfer license price as destination license is Expired/Inactive');
      END IF;
   END x_prc_alic_cm_trf_validation;

   --CATCHUP:CACQ14:Start:[SHANTANU A.]_13-nov-2104
   --Following procedure will update the catchup device rights at licens level
   PROCEDURE x_prc_cp_upd_lic_medplatdevcmp (
      i_lic_number           IN     fid_contract.con_number%TYPE,
      i_MPDC_DEV_PLATM_ID    IN     x_cp_lic_medplatmdevcompat_map.LIC_MPDC_DEV_PLATM_ID%TYPE,
      i_rights_on_device     IN     VARCHAR2,
      i_med_comp_rights      IN     VARCHAR2,
      i_med_IS_COMP_RIGHTS   IN     VARCHAR2,
      i_entry_oper           IN     x_cp_lic_medplatmdevcompat_map.LIC_MPDC_ENTRY_OPER%TYPE,
      o_status                  OUT NUMBER)
   AS
      l_is_fea_ser            VARCHAR2 (5);
      l_is_rights_on_device   VARCHAR2 (3);
      lic_exist               NUMBER;
      l_LIC_MPDC_ID           NUMBER;
      l_flag                  NUMBER;
      l_md_code               VARCHAR2 (20);
      l_con_number            NUMBER;
   BEGIN
      SELECT lic_budget_code
        INTO l_is_fea_ser
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT lic_con_number
        INTO l_con_number
        FROM fid_license
       WHERE LIC_NUMBER = i_lic_number;

      BEGIN
         IF (X_FNC_GET_PROG_TYPE (l_is_fea_ser) = 'Y')
         THEN
            SELECT DISTINCT CON_RIGHTS_ON_DEVICE
              INTO l_is_rights_on_device
              FROM x_cp_con_medplatmdevcompat_map
             WHERE     CON_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID
                   AND CON_CONTRACT_NUMBER = l_con_number
                   AND CON_IS_FEA_SER = 'SER';
         ELSE
            SELECT DISTINCT CON_RIGHTS_ON_DEVICE
              INTO l_is_rights_on_device
              FROM x_cp_con_medplatmdevcompat_map
             WHERE     CON_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID
                   AND CON_CONTRACT_NUMBER = l_con_number
                   AND CON_IS_FEA_SER <> 'SER';
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_is_rights_on_device := 'N';
      END;

      IF (l_is_rights_on_device = i_rights_on_device)
      THEN
         SELECT COUNT (1)
           INTO lic_exist
           FROM x_cp_lic_medplatmdevcompat_map
          WHERE LIC_MPDC_LIC_NUMBER = i_lic_number
                AND LIC_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID;

         IF lic_exist = 0
         THEN
            FOR i
               IN (SELECT COLUMN_VALUE, ROWNUM r
                     FROM TABLE (
                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                i_med_comp_rights,
                                ',')))
            LOOP
              -- DBMS_OUTPUT.put_line ('In Loop');
               l_LIC_MPDC_ID := X_SEQ_LIC_MPDC_ID.NEXTVAL;

               INSERT
                 INTO x_cp_lic_medplatmdevcompat_map (
                         LIC_MPDC_ID,
                         LIC_MPDC_LIC_NUMBER,
                         LIC_MPDC_DEV_PLATM_ID,
                         LIC_RIGHTS_ON_DEVICE,
                         LIC_MPDC_COMP_RIGHTS_ID,
                         LIC_IS_COMP_RIGHTS,
                         LIC_MPDC_ENTRY_OPER,
                         LIC_MPDC_ENTRY_DATE,
                         LIC_MPDC_UPDATE_COUNT,
                         LIC_MPDC_SERVICE_CODE)
               VALUES (
                         l_LIC_MPDC_ID,
                         i_lic_number,
                         i_MPDC_DEV_PLATM_ID,
                         i_rights_on_device,
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_med_comp_rights,
                                                ','))) a)
                           WHERE r = i.r),
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_med_IS_COMP_RIGHTS,
                                                ','))) a)
                           WHERE r = i.r),
                         i_entry_oper,
                         SYSDATE,
                         0,
                         (SELECT LEE_MEDIA_SERVICE_CODE
                            FROM fid_licensee
                           WHERE lee_number IN
                                    (SELECT lic_lee_number
                                       FROM fid_license
                                      WHERE lic_number = i_lic_number)));
            END LOOP;
         ELSE
            FOR i
               IN (SELECT COLUMN_VALUE, ROWNUM r
                     FROM TABLE (
                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                i_med_comp_rights,
                                ',')))
            LOOP
               --DBMS_OUTPUT.put_line ('IN update loop');

               UPDATE x_cp_lic_medplatmdevcompat_map
                  SET LIC_RIGHTS_ON_DEVICE = i_rights_on_device,
                      LIC_IS_COMP_RIGHTS =
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_med_IS_COMP_RIGHTS,
                                                ','))) a)
                           WHERE r = i.r),
                      LIC_MPDC_MODIFIED_BY = i_entry_oper,
                      LIC_MPDC_MODIFIED_ON = SYSDATE,
                      LIC_MPDC_UPDATE_COUNT =
                         NVL (LIC_MPDC_UPDATE_COUNT, 0) + 1
                WHERE     LIC_MPDC_LIC_NUMBER = i_lic_number
                      AND LIC_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID
                      AND LIC_MPDC_COMP_RIGHTS_ID = i.COLUMN_VALUE;
            END LOOP;
         END IF;
      ELSIF (l_is_rights_on_device = 'Y' AND i_rights_on_device = 'N'
             OR l_is_rights_on_device = 'N' AND i_rights_on_device = 'Y')
      THEN
         SELECT COUNT (1)
           INTO lic_exist
           FROM x_cp_lic_medplatmdevcompat_map
          WHERE LIC_MPDC_LIC_NUMBER = i_lic_number
                AND LIC_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID;

         IF lic_exist = 0
         THEN
            FOR i
               IN (SELECT COLUMN_VALUE, ROWNUM r
                     FROM TABLE (
                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                i_med_comp_rights,
                                ',')))
            LOOP
              -- DBMS_OUTPUT.put_line ('In Loop');
               l_LIC_MPDC_ID := X_SEQ_LIC_MPDC_ID.NEXTVAL;

               INSERT
                 INTO x_cp_lic_medplatmdevcompat_map (
                         LIC_MPDC_ID,
                         LIC_MPDC_LIC_NUMBER,
                         LIC_MPDC_DEV_PLATM_ID,
                         LIC_RIGHTS_ON_DEVICE,
                         LIC_MPDC_COMP_RIGHTS_ID,
                         LIC_IS_COMP_RIGHTS,
                         LIC_MPDC_ENTRY_OPER,
                         LIC_MPDC_ENTRY_DATE,
                         LIC_MPDC_UPDATE_COUNT,
                         LIC_MPDC_SERVICE_CODE)
               VALUES (
                         l_LIC_MPDC_ID,
                         i_lic_number,
                         i_MPDC_DEV_PLATM_ID,
                         i_rights_on_device,
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_med_comp_rights,
                                                ','))) a)
                           WHERE r = i.r),
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_med_IS_COMP_RIGHTS,
                                                ','))) a)
                           WHERE r = i.r),
                         i_entry_oper,
                         SYSDATE,
                         0,
                         (SELECT LEE_MEDIA_SERVICE_CODE
                            FROM fid_licensee
                           WHERE lee_number IN
                                    (SELECT lic_lee_number
                                       FROM fid_license
                                      WHERE lic_number = i_lic_number)));
            END LOOP;
         ELSE
            FOR i
               IN (SELECT COLUMN_VALUE, ROWNUM r
                     FROM TABLE (
                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                i_med_comp_rights,
                                ',')))
            LOOP
              -- DBMS_OUTPUT.put_line ('IN update loop');

               UPDATE x_cp_lic_medplatmdevcompat_map
                  SET LIC_RIGHTS_ON_DEVICE = i_rights_on_device,
                      LIC_IS_COMP_RIGHTS =
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_med_IS_COMP_RIGHTS,
                                                ','))) a)
                           WHERE r = i.r),
                      LIC_MPDC_MODIFIED_BY = i_entry_oper,
                      LIC_MPDC_MODIFIED_ON = SYSDATE,
                      LIC_MPDC_UPDATE_COUNT =
                         NVL (LIC_MPDC_UPDATE_COUNT, 0) + 1
                WHERE     LIC_MPDC_LIC_NUMBER = i_lic_number
                      AND LIC_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID
                      AND LIC_MPDC_COMP_RIGHTS_ID = i.COLUMN_VALUE;
            END LOOP;
         END IF;
      ELSE
         SELECT MD_CODE
           INTO l_md_code
           FROM x_cp_media_device
          WHERE md_id IN (SELECT MDP_MAP_DEV_ID
                            FROM x_cp_media_dev_platm_map
                           WHERE MDP_MAP_ID = i_MPDC_DEV_PLATM_ID);

         raise_application_error (
            -20555,
            'License can''t violate the contract media device rights condition for '
            || l_md_code
            || '');
      END IF;

      l_flag := SQL%ROWCOUNT;

      IF l_flag <> 0
      THEN
         COMMIT;
         o_status := 1;
      ELSE
         --ROLLBACK;
         o_status := 0;
      END IF;
   END x_prc_cp_upd_lic_medplatdevcmp;
--CATCHUP:CACQ14:[END]

--15_FIN_06_ENH_Cancel Season in one attempt_v1.0
   PROCEDURE x_prc_alic_episode_details(
       i_lic_number IN  number,
       i_lee_number in number,
       i_con_number in number,
       i_flag in varchar2,
       i_gen_ser_number number
      ,o_series_data  OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc
      ,o_episodes  OUT pkg_alic_cm_licensemaintenance.c_cursor_alic_cm_licmaintenanc)
   AS
   l_stmnt CLOB;
   BEGIN

      OPEN o_series_data FOR
      select sea.ser_number
            ,ser.ser_title "Series Title"
            ,sea.ser_title "Season Title"
            ,lee_short_name "Licensee"
            ,lee_number
            ,(select COM_NAME from fid_company where com_number = CON_COM_NUMBER) "Supplier"
      from fid_license
          ,fid_general
          ,fid_series sea
          ,fid_licensee
          ,fid_series ser
          ,fid_contract
      where lic_gen_refno=gen_refno
        and sea.ser_number=gen_ser_number
        and sea.ser_parent_number=ser.ser_number
        and lic_lee_number=lee_number
        and lic_con_number = con_number
        and lic_con_number = i_con_number
        and lic_number=I_LIC_NUMBER;


      l_stmnt := '
       select gen_epi_number "Episode #"
            ,lic_number "License #"
            ,gen_title "Episode"
            ,lic_start "License Start Date"
            ,lic_end "License End Date"
            ,gen_refno
            ,lic_update_count
      from fid_general
          ,fid_license
      where lic_gen_refno=gen_refno
      and gen_ser_number= ('|| ''''|| i_gen_ser_number || ''''|| ')
      and lic_con_number = ('|| ''''|| i_con_number|| ''''|| ')
      and LIC_LEE_NUMBER = ('|| ''''|| i_lee_number|| ''''|| ')
      ';

      if i_flag = 'Y' THEN
      l_stmnt := l_stmnt || 'and lic_status in (''A'',''F'')
      ';
      end if;
       l_stmnt := l_stmnt || 'order by gen_epi_number';

      --DBMS_OUTPUT.PUT_LINE(l_stmnt);
      OPEN o_episodes FOR l_stmnt;

   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));

   END x_prc_alic_episode_details;

PROCEDURE x_prc_alic_validatelicstatus (
      i_licnumber_list   IN     PKG_ALIC_CM_LICENSEMAINTENANCE.lic_number_ary,
      o_status         OUT clob)
   AS

      l_sch_date       DATE;
      l_cha_name       VARCHAR2 (4);
      l_cha_number     number;
      costexists       EXCEPTION;
      cost_total       NUMBER:=1;
      asset_value      NUMBER;
      l_stmnt clob;
      l_count_schedule number:=1;
BEGIN

FOR I IN 1..i_licnumber_list.LAST
loop
      l_count_schedule := 1;

      begin
       SELECT min(sch_date), sch_cha_number
        into l_sch_date,l_cha_number
        FROM fid_schedule
        WHERE sch_lic_number = i_licnumber_list(i)
        group by sch_cha_number;

       select cha_short_name into l_cha_name from fid_channel where cha_number = l_cha_number;

        exception
        when no_data_found then
           l_count_schedule :=-1;
      end;
         --DBMS_OUTPUT.PUT_LINE('l_count_schedule' || l_count_schedule);
       if l_count_schedule >0 then
         l_stmnt :=l_stmnt||'License '||''||i_licnumber_list(i)||''||' is scheduled for channel '||''||l_cha_name||''||' on '||''||l_sch_date||''||' - No cancel allowed./?';
      --   DBMS_OUTPUT.PUT_LINE('l_stmnt' || l_stmnt);
       END IF;

      begin
      SELECT SUM (lis_con_actual + lis_con_adjust), SUM (lis_con_forecast)
        INTO cost_total, asset_value
        FROM fid_license_sub_ledger
       WHERE lis_lic_number = i_licnumber_list(i);
       exception
        when no_data_found then
           l_count_schedule :=-1;
      end;

      IF cost_total != 0 and l_count_schedule = -1
      THEN
            l_stmnt :=l_stmnt||'License '||''||i_licnumber_list(i)||''||' has been costed - No cancel allowed./?';
      END IF;
end loop;

     -- DBMS_OUTPUT.PUT_LINE('l_stmnt' || l_stmnt);
      if l_stmnt is not null then
        o_status := l_stmnt;
      ELSE
        o_status :=empty_clob();
      end if;

END x_prc_alic_validatelicstatus;
--15_FIN_06_ENH_Cancel Season in one attempt_v1.0

--Start by Milan Shah for CU4ALL
  FUNCTION x_fnc_cal_viewing_days (I_Lic_number in number,I_Bouquet_id in number)
      RETURN number
      IS
      L_Max_days  number;
      BEGIN
--          select (case when
--                         NVL(max((ptb_pvr_end_date - ptb_pvr_start_date)),0)>NVL(max((ptb_ott_end_date-ptb_ott_start_date)),0)
--                      THEN
--                          ceil(NVL(max((ptb_pvr_end_date - ptb_pvr_start_date)),0))
--                      ELSE
--                          ceil(NVL(max((ptb_ott_end_date-ptb_ott_start_date)),0))
--                      END
--                  )Max_date INTO L_Max_days
--          from x_cp_plt_terr_bouq
--               ,x_cp_play_list
--          where plt_id = ptb_plt_id
--                and plt_lic_number = I_Lic_number
--                and PTB_BOUQUET_ID = I_Bouquet_id;


          select ( ceil(max(PLT_SCH_END_DATE) -max(PLT_SCH_START_DATE)))Max_date INTO L_Max_days
          from x_cp_plt_terr_bouq
               ,x_cp_play_list
          where plt_id = ptb_plt_id
                and plt_lic_number = I_Lic_number
                and PTB_BOUQUET_ID = I_Bouquet_id;

          return (case when L_Max_days = 0 then null else L_Max_days end);
      END x_fnc_cal_viewing_days;
  --End Milan Shah
END pkg_alic_cm_licensemaintenance;
/