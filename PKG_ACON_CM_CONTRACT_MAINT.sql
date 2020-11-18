CREATE OR REPLACE PACKAGE PKG_ACON_CM_CONTRACT_MAINT
AS
   /******************************************************************************
      NAME:       pkg_acon_cm_contract_maint.pks
      PURPOSE:    This package is used for Contract Maintenance Screen
      REVISIONS:
      Ver        Date         Author                 Description
      ---------  ----------  ---------------        ------------------------------------
      1.0        2/24/2010   Nirupama Ranananvare         1. Created this package.
   ******************************************************************************/
   TYPE c_contracts_cursor IS REF CURSOR;

   FUNCTION get_calc_method (i_calc_method IN VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE prc_contract_search (
      i_con_name             IN     fid_contract.con_name%TYPE,
      i_con_short_name       IN     fid_contract.con_short_name%TYPE,
      i_sup_com_short_name   IN     fid_company.com_short_name%TYPE,
      -- i_cont_entity_com_short_name   IN       fid_company.com_short_name%TYPE,
      i_con_calc_type        IN     fid_contract.con_calc_type%TYPE,
      i_lee_short_name       IN     fid_licensee.lee_short_name%TYPE,
      i_con_status           IN     fid_contract.con_status%TYPE,
      i_c_procurement_type   IN     fid_contract.con_procurement_type%TYPE,
      o_contracts_data          OUT pkg_acon_cm_contract_maint.c_contracts_cursor);

   PROCEDURE prc_contract_details_search (
      i_con_number                 IN     fid_contract.con_number%TYPE,
      i_service_flag                  IN  fid_contract.con_Catchup_flag%type,
      o_contracts_detail_data         OUT pkg_acon_cm_contract_maint.c_contracts_cursor--ACQ:CACQ14:Start:[Sushma K]_[2014/10/14]
      ,
      O_con_medplatmdevcompatmap      OUT pkg_acon_cm_contract_maint.c_contracts_cursor,
      o_con_med_dev_rights            OUT pkg_acon_cm_contract_maint.c_contracts_cursor--end
       --CU4ALL Start :BR_15_239_ENH_Contract Maintenance  [Anuja_Shinde][09/12/2015]
      ,O_CON_BOUQUET_RIGHTS           OUT PKG_ACON_CM_CONTRACT_MAINT.C_CONTRACTS_CURSOR
      --CU4ALL END
      );

   PROCEDURE prc_add_contract_details (
      i_con_name                       IN     fid_contract.con_name%TYPE,
      i_con_com_number                 IN     fid_contract.con_com_number%TYPE,
      i_con_agy_com_number             IN     fid_contract.con_agy_com_number%TYPE,
      i_con_lee_number                 IN     fid_contract.con_lee_number%TYPE,
      i_con_calc_type                  IN     fid_contract.con_calc_type%TYPE,
      i_con_currency                   IN     fid_contract.con_currency%TYPE,
      i_con_min_subscriber             IN     fid_contract.con_min_subscriber%TYPE,
      i_con_start_date                 IN     fid_contract.con_start_date%TYPE,
      i_con_end_date                   IN     fid_contract.con_end_date%TYPE,
      i_con_exh_day_start              IN     VARCHAR2,
      i_con_exh_day_runs               IN     fid_contract.con_exh_day_runs%TYPE,
      i_con_prime_time_start           IN     VARCHAR2,
      i_con_prime_time_end             IN     VARCHAR2,
      i_con_mux_ind                    IN     fid_contract.con_mux_ind%TYPE,
      i_con_align_ind                  IN     fid_contract.con_align_ind%TYPE,
      i_con_prime_time_type            IN     fid_contract.con_prime_time_type%TYPE,
      i_con_prime_time_pd_limit        IN     fid_contract.con_prime_time_pd_limit%TYPE,
      i_con_prime_max_runs             IN     fid_contract.con_prime_max_runs%TYPE,
      i_con_prime_max_runs_perc        IN     fid_contract.con_prime_max_runs_perc%TYPE,
      i_con_prime_time_level           IN     fid_contract.con_prime_time_level%TYPE,
      i_con_comment                    IN     fid_contract.con_comment%TYPE,
      i_con_exh_day_comment            IN     fid_contract.con_exh_day_comment%TYPE,
      i_user_id                        IN     fid_contract.con_entry_oper%TYPE,
      i_con_roy_calc_method            IN     fid_contract.con_roy_calc_method%TYPE,
      i_con_category                   IN     fid_contract.con_category%TYPE,
      i_con_price                      IN     fid_contract.con_price%TYPE,
      i_con_renew_date                 IN     fid_contract.con_renew_date%TYPE,
      i_con_short_name                 IN     fid_contract.con_short_name%TYPE,
      i_con_status                     IN     fid_contract.con_status%TYPE,
      i_con_date                       IN     fid_contract.con_date%TYPE,
      i_acc_date                       IN     fid_contract.con_acct_date%TYPE,
      i_license_period                 IN     fid_contract.con_license_period%TYPE,
      -- Project Bioscope Changes start
      i_con_exhibition_per_day         IN     fid_contract.con_exhibition_per_day%TYPE,
      i_con_limit_per_service          IN     fid_contract.con_limit_per_service%TYPE,
      i_con_limit_per_channel          IN     fid_contract.con_limit_per_channel%TYPE,
      -- Project Bioscope Changes end.
      /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
      i_c_catchup_flag                 IN     fid_contract.con_catchup_flag%TYPE,
      i_c_max_fee_subs                 IN     fid_contract.con_max_fee_subs%TYPE,
      i_c_ad_promo_cha_brand_restr     IN     fid_contract.con_ad_promo_cha_brand_restr%TYPE,
      i_c_max_perc_content_restr       IN     fid_contract.con_max_perc_content_restr%TYPE,
      i_c_min_of_major_studio_restr    IN     fid_contract.con_min_of_major_studio_restr%TYPE,
      i_c_not_allow_aft_x_start_lic    IN     fid_contract.con_not_allow_aft_x_start_lic%TYPE,
      i_c_not_allow_bef_x_end_lic_dt   IN     fid_contract.con_not_allow_bef_x_end_lic_dt%TYPE,
      i_c_other_rules                  IN     fid_contract.con_other_rules%TYPE,
      i_c_mud_restriction              IN     fid_contract.con_mud_restriction%TYPE,
      i_c_trans_tech_restr             IN     fid_contract.con_trans_tech_restr%TYPE,
      i_c_studio_pre_roll_notice_req   IN     fid_contract.con_studio_pre_roll_notice_req%TYPE,
      i_c_sch_within_x_frm_ply_fea     IN     fid_contract.con_sch_within_x_frm_ply_fea%TYPE,
      i_c_sch_within_x_frm_ply_ser     IN     fid_contract.con_sch_within_x_frm_ply_ser%TYPE,
      i_c_sch_after_prem_linr_fea      IN     fid_contract.con_sch_after_prem_linr_fea%TYPE,
      i_c_sch_after_prem_linr_ser      IN     fid_contract.con_sch_after_prem_linr_ser%TYPE,
      i_c_sch_no_epi_restr_ser_seson   IN     fid_contract.con_sch_no_epi_restr_ser_seson%TYPE,
      i_c_sch_x_day_before_linr_fea    IN     fid_contract.con_sch_x_day_before_linr_fea%TYPE,
      i_c_sch_x_day_before_linr_ser    IN     fid_contract.con_sch_x_day_before_linr_ser%TYPE,
      i_c_sch_x_day_bef_linr_val_fea   IN     fid_contract.con_sch_x_day_bef_linr_val_fea%TYPE,
      I_C_SCH_X_DAY_BEF_LINR_VAL_SER   IN     FID_CONTRACT.CON_SCH_X_DAY_BEF_LINR_VAL_SER%TYPE,
      i_CON_TBA_SER_SCHEDULE_FLAG      IN     FID_CONTRACT.CON_TBA_SER_SCHEDULE_FLAG%TYPE,
      i_c_procurement_type             IN     fid_contract.con_procurement_type%TYPE,
      /* Dev1: Catch-up R1:End  */
      /* Dev2: Rand Devaluation:Start:Sushma K_2014/15/09  */
      i_c_rand_devaluation_flag        IN     fid_contract.CON_DEVALUATION_FLAG%TYPE,
      /* Dev2: Rand Devaluation:End  */
      /* ACQ:CACQ:Start:Sushma K_2014/16/10  */
      i_con_SCH_WITHOUT_LINR_REF_FEA   IN     fid_contract.CON_SCH_WITHOUT_LINR_REF_FEA%TYPE,
      i_con_SCH_WITHOUT_LINR_REF_SER   IN     fid_contract.CON_SCH_WITHOUT_LINR_REF_SER%TYPE,
      /* ACQ:CACQ:End  */
	  --Warner Payment : Added by sushma to implement UAT cr
      I_CON_MG_FLAG                    IN     FID_CONTRACT.CON_IS_MG_FLAG%TYPE
	  --END
         --CU4ALL Start :BR_15_239_ENH_Contract Maintenance  [Anuja_Shinde][09/12/2015]
     ,I_CON_BOUQUET_RIGHTS               IN    VARCHAR2
     ,I_CON_COMPACT_VP_RUNS_FEA          IN    FID_CONTRACT.CON_COMPACT_VP_RUNS_FEA%TYPE
     ,I_CON_ALLOW_RING_FENCE_FEA         IN     FID_CONTRACT.CON_ALLOW_RING_FENCE_FEA%TYPE
     ,I_CON_ALLOW_RING_FENCE_SER	       IN     FID_CONTRACT.CON_ALLOW_RING_FENCE_SER%TYPE
     ,I_CON_SCH_AFT_PREM_SER_BOUQ	 IN     FID_CONTRACT.CON_SCH_AFT_PREM_LINR_SER_BOUQ%TYPE
     ,I_CON_SCH_LIN_SER_CHA	             IN     FID_CONTRACT.CON_SCH_LIN_SER_CHA%TYPE
     ,I_CON_ALLOW_EXH_WEEK_TIER_SER	     IN     FID_CONTRACT.CON_ALLOW_EXH_WEEK_TIER_SER%TYPE ,
      --CU4ALL END
      o_con_number                        OUT fid_contract.con_number%TYPE,
      o_con_short_name                    OUT fid_contract.con_short_name%TYPE);

   --Dev2: Pure Finance :Start:[FIN 10-Contract maintenance]_[ANUJASHINDE]_[2013/2/23]
   PROCEDURE prc_contract_curr_validate (
      i_con_number        IN     FID_CONTRACT.CON_NUMBER%TYPE,
      i_con_currency      IN     fid_contract.con_currency%TYPE,
      i_allowchangeflag   IN     VARCHAR2,
      o_flagmsg              OUT NUMBER -- flagcurrnotsame         out VARCHAR2
                                       );

   --Dev2: Pure Finance :End

   PROCEDURE prc_update_contract_details (
      i_con_number                     IN     fid_contract.con_number%TYPE,
      i_con_name                       IN     fid_contract.con_name%TYPE,
      i_con_com_number                 IN     fid_contract.con_com_number%TYPE,
      i_con_agy_com_number             IN     fid_contract.con_agy_com_number%TYPE,
      i_con_lee_number                 IN     fid_contract.con_lee_number%TYPE,
      i_con_calc_type                  IN     fid_contract.con_calc_type%TYPE,
      i_con_currency                   IN     fid_contract.con_currency%TYPE,
      i_con_min_subscriber             IN     fid_contract.con_min_subscriber%TYPE,
      i_con_start_date                 IN     fid_contract.con_start_date%TYPE,
      i_con_end_date                   IN     fid_contract.con_end_date%TYPE,
      i_con_exh_day_start              IN     VARCHAR2,
      i_con_exh_day_runs               IN     fid_contract.con_exh_day_runs%TYPE,
      i_con_prime_time_start           IN     VARCHAR2,
      i_con_prime_time_end             IN     VARCHAR2,
      i_con_mux_ind                    IN     fid_contract.con_mux_ind%TYPE,
      i_con_align_ind                  IN     fid_contract.con_align_ind%TYPE,
      i_con_prime_time_type            IN     fid_contract.con_prime_time_type%TYPE,
      i_con_prime_time_pd_limit        IN     fid_contract.con_prime_time_pd_limit%TYPE,
      i_con_prime_max_runs             IN     fid_contract.con_prime_max_runs%TYPE,
      i_con_prime_max_runs_perc        IN     fid_contract.con_prime_max_runs_perc%TYPE,
      i_con_prime_time_level           IN     fid_contract.con_prime_time_level%TYPE,
      i_con_comment                    IN     fid_contract.con_comment%TYPE,
      i_con_exh_day_comment            IN     fid_contract.con_exh_day_comment%TYPE,
      i_con_roy_calc_method            IN     fid_contract.con_roy_calc_method%TYPE,
      i_con_update_count               IN     fid_contract.con_update_count%TYPE,
      i_con_category                   IN     fid_contract.con_category%TYPE,
      i_con_price                      IN     fid_contract.con_price%TYPE,
      i_con_renew_date                 IN     fid_contract.con_renew_date%TYPE,
      i_con_short_name                 IN     fid_contract.con_short_name%TYPE,
      i_con_status                     IN     fid_contract.con_status%TYPE,
      i_con_date                       IN     fid_contract.con_date%TYPE,
      i_acc_date                       IN     fid_contract.con_acct_date%TYPE,
      i_license_period                 IN     fid_contract.con_license_period%TYPE,
      i_processclicked                 IN     VARCHAR2,
      -- Project Bioscope Changes start
      i_con_exhibition_per_day         IN     fid_contract.con_exhibition_per_day%TYPE,
      i_con_limit_per_service          IN     fid_contract.con_limit_per_service%TYPE,
      i_con_limit_per_channel          IN     fid_contract.con_limit_per_channel%TYPE,
      -- Project Bioscope Changes end.
      i_entryoper                      IN     fid_contract.con_entry_oper%TYPE,
      /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
      i_c_catchup_flag                 IN     fid_contract.con_catchup_flag%TYPE,
      i_c_max_fee_subs                 IN     fid_contract.con_max_fee_subs%TYPE,
      i_c_ad_promo_cha_brand_restr     IN     fid_contract.con_ad_promo_cha_brand_restr%TYPE,
      i_c_max_perc_content_restr       IN     fid_contract.con_max_perc_content_restr%TYPE,
      i_c_min_of_major_studio_restr    IN     fid_contract.con_min_of_major_studio_restr%TYPE,
      i_c_not_allow_aft_x_start_lic    IN     fid_contract.con_not_allow_aft_x_start_lic%TYPE,
      i_c_not_allow_bef_x_end_lic_dt   IN     fid_contract.con_not_allow_bef_x_end_lic_dt%TYPE,
      i_c_other_rules                  IN     fid_contract.con_other_rules%TYPE,
      i_c_mud_restriction              IN     fid_contract.con_mud_restriction%TYPE,
      i_c_trans_tech_restr             IN     fid_contract.con_trans_tech_restr%TYPE,
      i_c_studio_pre_roll_notice_req   IN     fid_contract.con_studio_pre_roll_notice_req%TYPE,
      i_c_sch_within_x_frm_ply_fea     IN     fid_contract.con_sch_within_x_frm_ply_fea%TYPE,
      i_c_sch_within_x_frm_ply_ser     IN     fid_contract.con_sch_within_x_frm_ply_ser%TYPE,
      i_c_sch_after_prem_linr_fea      IN     fid_contract.con_sch_after_prem_linr_fea%TYPE,
      i_c_sch_after_prem_linr_ser      IN     fid_contract.con_sch_after_prem_linr_ser%TYPE,
      i_c_sch_no_epi_restr_ser_seson   IN     fid_contract.con_sch_no_epi_restr_ser_seson%TYPE,
      i_c_sch_x_day_before_linr_fea    IN     fid_contract.con_sch_x_day_before_linr_fea%TYPE,
      i_c_sch_x_day_before_linr_ser    IN     fid_contract.con_sch_x_day_before_linr_ser%TYPE,
      i_c_sch_x_day_bef_linr_val_fea   IN     fid_contract.con_sch_x_day_bef_linr_val_fea%TYPE,
      I_C_SCH_X_DAY_BEF_LINR_VAL_SER   IN     FID_CONTRACT.CON_SCH_X_DAY_BEF_LINR_VAL_SER%TYPE,
      i_CON_TBA_SER_SCHEDULE_FLAG      IN     FID_CONTRACT.CON_TBA_SER_SCHEDULE_FLAG%TYPE,
      i_c_procurement_type             IN     fid_contract.con_procurement_type%TYPE,
      /* Dev1: Catch-up R1:End  */
      /* Dev2: Rand Devaluation:Start:Sushma K_2014/15/09  */
      i_c_rand_devaluation_flag        IN     fid_contract.CON_DEVALUATION_FLAG%TYPE,
      /* Dev2: Rand Devaluation:End  */
      /* ACQ:CACQ:Start:Sushma K_2014/16/10  */
      i_con_SCH_WITHOUT_LINR_REF_FEA   IN     fid_contract.CON_SCH_WITHOUT_LINR_REF_FEA%TYPE,
      i_con_SCH_WITHOUT_LINR_REF_SER   IN     fid_contract.CON_SCH_WITHOUT_LINR_REF_SER%TYPE,
      i_con_lic_update_fea             IN     VARCHAR2,
      i_con_lic_update_ser             IN     VARCHAR2,
      i_con_lic_update_x_days_fea      IN     VARCHAR2,--CP : CACQ14:add for popup box confirmation YES/NO
      i_con_lic_update_x_days_ser      IN     VARCHAR2,--CP : CACQ14:add for popup box confirmation YES/NO
      /*  i_rights_on_device_fea              IN     X_CP_CON_MEDPLATMDEVCOMPAT_MAP.CON_RIGHTS_ON_DEVICE%type,
         i_rights_on_device_ser              IN     X_CP_CON_MEDPLATMDEVCOMPAT_MAP.CON_RIGHTS_ON_DEVICE%type,
         i_med_comp_is_rights_fea            IN     varchar2,
         i_med_comp_is_rights_ser            IN     varchar2,
         i_is_fea_ser                     IN     varchar2,
         i_mpdc_dev_platm_id              IN       NUMBER,
           o_sch_count                      OUT      NUMBER,*/
      /* ACQ:CACQ:End  */
      i_con_mg_flag                    IN     fid_contract.con_is_mg_flag%TYPE, --BR_15_144 Warner Payment Term - START on [28-09-2015]  by sushma
       I_CON_BOUQUET_RIGHTS               IN    VARCHAR2
     ,I_CON_COMPACT_VP_RUNS_FEA          IN    FID_CONTRACT.CON_COMPACT_VP_RUNS_FEA%TYPE
     ,I_CON_ALLOW_RING_FENCE_FEA         IN     FID_CONTRACT.CON_ALLOW_RING_FENCE_FEA%TYPE
     ,I_CON_ALLOW_RING_FENCE_SER	       IN     FID_CONTRACT.CON_ALLOW_RING_FENCE_SER%TYPE
     ,I_CON_SCH_AFT_PREM_SER_BOUQ	        IN     FID_CONTRACT.CON_SCH_AFT_PREM_LINR_SER_BOUQ%TYPE
     ,I_CON_SCH_LIN_SER_CHA	             IN     FID_CONTRACT.CON_SCH_LIN_SER_CHA%TYPE
     ,I_CON_ALLOW_EXH_WEEK_TIER_SER	     IN     FID_CONTRACT.CON_ALLOW_EXH_WEEK_TIER_SER%TYPE ,
      o_con_short_name                    OUT fid_contract.con_short_name%TYPE,
      o_con_update_count                  OUT fid_contract.con_update_count%TYPE,
      o_filename                          OUT VARCHAR2,
      o_sch_present_past                  OUT VARCHAR2,
      o_sch_exist_fea                     OUT VARCHAR2,
      o_sch_exist_ser                     OUT VARCHAR2,
      o_sch_exist_bef_x_days_fea          OUT VARCHAR2,
      o_sch_exist_bef_x_days_ser          OUT VARCHAR2);

   PROCEDURE prc_get_contractfile_data (
      i_con_number       IN     NUMBER,
      o_contracts_data      OUT pkg_acon_cm_contract_maint.c_contracts_cursor);

   PROCEDURE prc_delete_contract_details (
      i_con_number       IN     fid_contract.con_number%TYPE,
      o_con_is_deleted      OUT NUMBER);

   PROCEDURE prc_check_contract_licenses (
      i_con_number                IN     NUMBER,
      i_con_short_name            IN     VARCHAR2,
      i_con_prime_time_start      IN     VARCHAR2,
      i_con_prime_time_end        IN     VARCHAR2,
      i_con_prime_max_runs        IN     NUMBER,
      i_con_prime_max_runs_perc   IN     NUMBER,
      i_con_prime_time_level      IN     VARCHAR2,
      i_con_prime_time_pd_limit   IN     VARCHAR2,
      i_con_prime_time_type       IN     VARCHAR2,
      -- i_userid                    IN       VARCHAR2,
      o_file_name                    OUT VARCHAR2,
      o_error_found                  OUT VARCHAR2);

   PROCEDURE prc_validate_primetime (
      i_con_number                IN     NUMBER,
      i_lic_number                IN     NUMBER,
      i_to_period                 IN     DATE,
      i_con_prime_time_start      IN     VARCHAR2,
      i_con_prime_time_end        IN     VARCHAR2,
      i_con_prime_time_type       IN     VARCHAR2,
      i_con_prime_time_pd_limit   IN     VARCHAR2,
      i_file                      IN     UTL_FILE.file_type,
      o_error                        OUT VARCHAR2 -- o_file      OUT      VARCHAR2
                                                 );

   PROCEDURE prc_setup_pt (i_lic_number                IN NUMBER,
                           i_con_prime_time_start      IN NUMBER,
                           i_con_prime_time_end        IN NUMBER,
                           i_con_prime_max_runs_perc   IN NUMBER,
                           i_con_prime_max_runs        IN NUMBER,
                           i_con_prime_time_level      IN VARCHAR2 --i_userid                    IN   VARCHAR2
                                                                  );

   PROCEDURE prc_delete_pt (i_lic_number IN NUMBER);

   --Dev2: Rand Devaulation :Start:[FIN 34- Rand Devaluation info]_[Sushma K]_[2014/06/10]
   PROCEDURE prc_insert_rd_info (
      I_CON_NUMBER           IN     x_rand_devaluation_info.rdi_con_number%TYPE,
      I_BENCH_MARK_FLAG      IN     x_rand_devaluation_info.rdi_bench_mark_flag%TYPE,
      I_BM_UPPER             IN     x_rand_devaluation_info.rdi_bm_lower%TYPE,
      I_BM_LOWER             IN     x_rand_devaluation_info.rdi_bm_lower%TYPE,
      I_BM_REFERENCE         IN     x_rand_devaluation_info.rdi_bm_reference%TYPE,
      I_BM_DEVIATION         IN     x_rand_devaluation_info.rdi_bm_deviation%TYPE,
      I_SHARE_SUP            IN     x_rand_devaluation_info.rdi_share_sup%TYPE,
      I_DISCOUNT_THRESHOLD   IN     x_rand_devaluation_info.rdi_discount_threshold%TYPE,
      I_EXH_RATE_SOURCE      IN     x_rand_devaluation_info.rdi_exh_rate_source%TYPE,
      I_REVIEW_DATE_CALC     IN     x_rand_devaluation_info.rdi_review_date_calc%TYPE,
      I_FIXED_DATE           IN     VARCHAR2, --x_rand_devaluation_info.rdi_fixed_date%TYPE,
      I_PAY_MONTH_1          IN     x_rand_devaluation_info.rdi_pay_month_1%TYPE,
      I_LAST_DAY_FLAG        IN     x_rand_devaluation_info.rdi_last_day_flag%TYPE,
      I_PAY_MONTH_2          IN     x_rand_devaluation_info.rdi_pay_month_2%TYPE,
      I_NO_PAST_MON          IN     x_rand_devaluation_info.rdi_no_past_mon%TYPE,
      I_ACC_TYPE             IN     x_rand_devaluation_info.rdi_acc_type%TYPE,
      I_SELECT_MON           IN     x_rand_devaluation_info.rdi_select_mon%TYPE,
      I_ACC_FLAG             IN     x_rand_devaluation_info.rdi_acc_flag%TYPE,
      I_IS_SUNDAY_HOLIDAY    IN     x_rand_devaluation_info.rdi_is_sunday_holiday%TYPE,
      I_ENTRY_OPER           IN     x_rand_devaluation_info.rdi_entry_oper%TYPE,
      --I_ENTRY_DATE              IN   x_rand_devaluation_info.rdi_entry_date%TYPE,
      -- I_MODIFY_BY               IN   x_rand_devaluation_info.rdi_modify_by%TYPE,
      --  I_MODIFY_ON               IN   x_rand_devaluation_info.rdi_modify_on%TYPE,
      -- I_DEVALUATION_FLAG        IN   x_rand_devaluation_info.rdi_DEVALUATION_FLAG%TYPE,
      O_DATA_INSERTED           OUT NUMBER);

   PROCEDURE prc_rd_con_search (
      i_con_number       IN     NUMBER,
      O_con_rd_details      OUT pkg_acon_cm_contract_maint.c_contracts_cursor);

   PROCEDURE prc_rd_con_delete (i_con_number IN NUMBER);

   --Dev2: Rand Devaulation :End
   --ACQ:CACQ14 :Start:[Sushma K]_[2014/10/14]
   /*procedure prc_get_con_medplatmdevcomp_details
   (
    i_con_number     IN NUMBER
   );*/

   PROCEDURE prc_add_con_medplatmdevcomp (
      i_con_number           IN     fid_contract.con_number%TYPE,
      i_MPDC_DEV_PLATM_ID    IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_DEV_PLATM_ID%TYPE,
      i_rights_on_device     IN     VARCHAR2,
      i_IS_FEA_SER           IN     x_cp_con_medplatmdevcompat_map.CON_IS_FEA_SER%TYPE,
      i_med_comp_rights      IN     VARCHAR2, --x_cp_med_platm_dev_compat_map.MPDC_COMP_RIGHTS%type,
      i_med_IS_COMP_RIGHTS   IN     VARCHAR2, --x_cp_med_platm_dev_compat_map.MPDC_IS_COMP_RIGHTS%type,
      i_entry_oper           IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_ENTRY_OPER%TYPE,
	  i_con_catchup_flag	 IN		fid_Contract.con_catchup_flag%type,
      o_status                  OUT NUMBER);
/*procedure prc_update_rights_on_device
(
  i_rights_on_device_fea      IN    x_cp_con_medplatmdevcompat_map.CON_RIGHTS_ON_DEVICE%TYPE,
  i_rights_on_device_ser      IN    x_cp_con_medplatmdevcompat_map.CON_RIGHTS_ON_DEVICE%TYPE,
  i_med_comp_is_rights_fea    IN    varchar2,
  i_med_comp_is_rights_ser    IN    varchar2,
  i_con_number                IN    fid_contraCT.CON_NUMBER%TYPE,
  i_mpdc_dev_platm_id         IN    NUMBER,
  i_entryoper                 IN    fid_contract.con_entry_oper%type
);*/

--ACQ:CACQ14 :END*/

   --Dev.R5 : SVOD Enhancements : Start : [Devashish Raverkar]_[2015/04/22]
   PROCEDURE x_prc_con_rights_search (
      i_con_number                 IN     fid_contract.con_number%TYPE,
      i_service_flag               IN     fid_contract.con_Catchup_flag%TYPE,
      o_con_medplatmdevcompatmap      OUT pkg_acon_cm_contract_maint.c_contracts_cursor,
      o_con_med_dev_rights            OUT pkg_acon_cm_contract_maint.c_contracts_cursor);
--Dev.R5 : SVOD Enhancements : End

END pkg_acon_cm_contract_maint;
/
CREATE OR REPLACE PACKAGE BODY PKG_ACON_CM_CONTRACT_MAINT
AS
   /******************************************************************************
      NAME:       pkg_acon_cm_contract_maint.pkb
      PURPOSE:    This package is used for Contract Maintenance Screen
      REVISIONS:
      Ver        Date         Author                 Description
      ---------  ----------  ---------------        ------------------------------------
      1.0        2/24/2010   Nirupama Ranananvare         1. Created this package.
   ******************************************************************************/
   FUNCTION get_calc_method (i_calc_method IN VARCHAR2)
      RETURN VARCHAR2
   AS
      l_message             VARCHAR2 (200);
      invalid_calc_method   EXCEPTION;
   BEGIN
      IF NVL (i_calc_method, '-1') = '-1'
      THEN
         RETURN ('Not relevant');
      ELSIF i_calc_method = 'A'
      THEN
         RETURN ('Standard calculation');
      ELSIF i_calc_method = 'B'
      THEN
         RETURN ('50% at start, 50% end.');
      ELSIF i_calc_method = 'C'
      THEN
         RETURN ('Amortisation Type C');
      ELSE
         l_message :=
            'Calc Method must be either of ''A'', ''B'', ''C'' or '' ''';
         RETURN (l_message);
         RAISE invalid_calc_method;
      END IF;
   /* if i_calc_method = 'Not relevant' then
       return('-');
    elsif i_calc_method = 'Standard calculation' then
       return('A');
    elsif i_calc_method = '50% at start, 50% end.' then
      return('B');
    elsif i_calc_method = 'Amortisation Type C' then
       return('C');
      end if;*/
   EXCEPTION
      WHEN invalid_calc_method
      THEN
         raise_application_error (-20642, l_message);
   END get_calc_method;

   PROCEDURE prc_contract_search (
      i_con_name             IN     fid_contract.con_name%TYPE,
      i_con_short_name       IN     fid_contract.con_short_name%TYPE,
      i_sup_com_short_name   IN     fid_company.com_short_name%TYPE,
      --i_cont_entity_com_short_name   IN       fid_company.com_short_name%TYPE,
      i_con_calc_type        IN     fid_contract.con_calc_type%TYPE,
      i_lee_short_name       IN     fid_licensee.lee_short_name%TYPE,
      i_con_status           IN     fid_contract.con_status%TYPE,
      i_c_procurement_type   IN     fid_contract.con_procurement_type%TYPE,
      o_contracts_data          OUT pkg_acon_cm_contract_maint.c_contracts_cursor)
   AS
      l_query_string   VARCHAR2 (2000);
   BEGIN
      l_query_string :=
         'SELECT
                trim(upper(con_name)) con_name,
                con_short_name,con_number,
                fcs.com_short_name supp_com_short_name,
                fcce.com_short_name cont_entity_com_short_name,
                fl.lee_short_name licensee_sh_name,
                con_calc_type,
                con_status,
               /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
                --con_catchup_flag,
                -- Dev.R5 : SVOD Enhancements : Start : [Devashish_Raverkar]_[2015/05/07]
                CASE
                WHEN NVL(con_catchup_flag,''N'') IN (''Y'',''N'',''C'')            -- Dev :3rd Party Catchup Implementation:[Jawahar_Garg]_[29-Jun-2015]-Added C for catchup flag
                THEN NVL(con_catchup_flag,''N'')
                ELSE (SELECT ms_media_service_code
                        FROM sgy_pb_media_service
                       WHERE ms_media_service_flag = con_catchup_flag)
                END con_catchup_flag,
                -- Dev.R5 : SVOD Enhancements : End
               /* Dev1: Catch-up R1:End  */
               con_procurement_type
          FROM fid_contract fc, fid_company fcs, fid_company fcce, fid_licensee fl
          WHERE fcs.com_number(+) = con_com_number
            AND fcce.com_number(+) = con_agy_com_number
            AND fl.lee_number(+) = con_lee_number ';

      IF i_con_name IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and trim(upper(con_name)) like'''
            || TRIM (UPPER (i_con_name))
            || '''';
      END IF;

      IF i_con_short_name IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(con_short_name) like '''
            || UPPER (i_con_short_name)
            || '''';
      END IF;

      IF i_sup_com_short_name IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(fcs.com_short_name) like '''
            || UPPER (i_sup_com_short_name)
            || '''';
      END IF;

      /*
            IF i_cont_entity_com_short_name IS NOT NULL
            THEN
               l_query_string :=
                     l_query_string
                  || ' and upper(fcce.com_short_name) like '''
                  || UPPER (i_cont_entity_com_short_name)
                  || '''';
            END IF;*/
      IF i_lee_short_name IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(fl.lee_short_name) like '''
            || UPPER (i_lee_short_name)
            || '''';
      END IF;

      IF i_con_calc_type IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(con_calc_type) like'''
            || UPPER (i_con_calc_type)
            || '''';
      END IF;

      IF i_con_status IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(con_status) like '''
            || UPPER (i_con_status)
            || '''';
      END IF;

      IF i_c_procurement_type IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(con_procurement_type) like '''
            || UPPER (i_c_procurement_type)
            || '''';
      END IF;

      l_query_string :=
         l_query_string || ' order by con_short_name , trim(upper(con_name))';

      --DBMS_OUTPUT.put_line (l_query_string);

      OPEN o_contracts_data FOR l_query_string;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_contract_search;

   PROCEDURE prc_contract_details_search (
      i_con_number                 IN     fid_contract.con_number%TYPE,
      i_service_flag               IN     fid_contract.con_Catchup_flag%TYPE,
      o_contracts_detail_data         OUT pkg_acon_cm_contract_maint.c_contracts_cursor --ACQ:CACQ14:Start:[Sushma K]_[2014/10/14]
                                                                                       ,
      O_con_medplatmdevcompatmap      OUT PKG_ACON_CM_CONTRACT_MAINT.c_contracts_cursor,
      o_con_med_dev_rights            OUT PKG_ACON_CM_CONTRACT_MAINT.c_contracts_cursor --end
      --CU4ALL Start :BR_15_239_ENH_Contract Maintenance  [Anuja_Shinde][09/12/2015]
      ,O_CON_BOUQUET_RIGHTS           OUT PKG_ACON_CM_CONTRACT_MAINT.C_CONTRACTS_CURSOR
      --CU4ALL END
     )
   AS
      l_con_count        NUMBER;
      l_string           CLOB;
      l_string1          CLOB;
      l_string2          CLOB;
      l_string3          CLOB;
      l_catchup_flag     fid_contract.con_catchup_flag%TYPE; -- added on 23/03/2015 -- to check SVOD flag also
      l_media_ser_code   VARCHAR2 (50); -- added on 24/03/2015 -- to check SVOD media service also
      L_BOUQUET_RIGHTS  VARCHAR2(500);
   BEGIN
      l_catchup_flag := NVL (i_service_flag, 'N');

      IF i_service_flag IS NOT NULL
      THEN
         SELECT MS_MEDIA_SERVICE_CODE
           INTO l_media_ser_code
           FROM SGY_PB_MEDIA_SERVICE
          WHERE ms_media_service_flag = i_service_flag;
      ELSE
         BEGIN
            select MS_MEDIA_SERVICE_CODE,
                   MS_MEDIA_SERVICE_FLAG                    --[27-Jul-2015][Jawahar_garg]Initialized l_catchup_flag [System is somehow allowing to check the schedule without linear reference checkbox for the Catch Up license which is linked to linear license.]
              into L_MEDIA_SER_CODE,
                   l_catchup_flag                           --[27-Jul-2015][Jawahar_garg]Initialized l_catchup_flag [System is somehow allowing to check the schedule without linear reference checkbox for the Catch Up license which is linked to linear license.]
              FROM fid_contract, SGY_PB_MEDIA_SERVICE
             where MS_MEDIA_SERVICE_FLAG = CON_CATCHUP_FLAG
               AND con_number = i_con_number;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_media_ser_code := NULL;
         END;
      END IF;

      -- added on 24/03/2015 -- to check SVOD media service also

      --ACQ:CACQ14:Start:[Sushma K]_[2014/10/14]
      SELECT COUNT (1)
        INTO l_con_count
        FROM x_cp_con_medplatmdevcompat_map
       WHERE CON_CONTRACT_NUMBER = i_con_number;

      -- SVOD changes (not used from now on) : Start
      IF    l_con_count = 0
         OR (l_con_count <> 0 AND i_service_flag IS NOT NULL)
         OR (l_con_count = 0 AND i_service_flag IS NULL)
      THEN
         l_string := 'select a.Med_dev_code,
                              a.Med_dev_desc,
                              a.med_platm_code,
                              a.med_platm_desc,
                              a.Rights_On_device,
                              a.MPDC_DEV_PLATM_ID,
                              a.med_device_sch_flag,
                              ';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_UI_SEQ /*MDC_ID*/)
         LOOP
            l_string :=
                  l_string
               || 'NVL( ( select  (case when MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || '''  ),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,';
         END LOOP;

         l_string :=
            l_string
            || 'a.MPDC_UPDATE_COUNT from (select MDP_MAP_DEV_ID,
                                            (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                             ''N'' Rights_On_device,
                                             SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT,
                                             MPDC_DEV_PLATM_ID,
                                             ''N''  med_device_sch_flag
                                          from  x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map,x_cp_medplatdevcomp_servc_map
                                          where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                          and   MPDCS_MPDC_ID  =  MPDC_ID
                                          and MPDCS_MED_SERVICE_CODE = '''
            || l_media_ser_code
            || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a'; -- added on 24/03/2015 -- to check SVOD media service also
      ELSE
         l_string := 'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.CON_RIGHTS_ON_DEVICE,
                            a.CON_IS_FEA_SER,
                            a.CON_MPDC_DEV_PLATM_ID,
                            a.CON_CONTRACT_NUMBER,
                            a.med_device_sch_flag
                            ,';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_UI_SEQ)
         LOOP
            l_string :=
                  l_string
               || 'NVL( ( select  (case when CON_MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and CON_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_con_medplatmdevcompat_map b,x_cp_media_dev_platm_map  where CON_MPDC_DEV_PLATM_ID = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.CON_MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and CON_IS_FEA_SER = a.CON_IS_FEA_SER and CON_CONTRACT_NUMBER = '''
               || i_con_number
               || '''),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,';
         END LOOP;

         l_string :=
            l_string
            || 'a.CON_MPDC_UPDATE_COUNT  from (select MDP_MAP_DEV_ID,
                                           (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            CON_RIGHTS_ON_DEVICE,
                                            CON_IS_FEA_SER
                                            ,CON_MPDC_DEV_PLATM_ID
                                            ,SUM(CON_MPDC_UPDATE_COUNT) CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER
                                            ,DECODE(CON_IS_FEA_SER,''FEA'',(case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              and   lic_catchup_flag = '''
            || l_catchup_flag
            || '''
                                                              and   X_FNC_GET_PROG_TYPE(lic_budget_code) <> ''Y''
                                                              and lic_con_number = '''
            || i_con_number ---- added on 23/03/2015 -- to check SVOD flag also
            || '''
                                                              )
                                                  AND TO_CHAR (plt_sch_start_date, ''RRRRMM'') IN
                                                                         (SELECT fim_year || lpad(FIM_MONTH,2,0)
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                  /*AND TO_CHAR (plt_sch_start_date,''rrrr'') IN
                                                                         (SELECT FIM_YEAR
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))*/
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID) > 0 THEN  ''Y''  else ''N'' END )
                                                ,(case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              and   lic_catchup_flag = '''
            || l_catchup_flag
            || '''
                                                              and   X_FNC_GET_PROG_TYPE(lic_budget_code) = ''Y''
                                                              and lic_con_number = '''
            || i_con_number  -- added on 23/03/2015 -- to check SVOD flag also
            || '''
                                                              )
                                                  AND TO_CHAR (plt_sch_start_date, ''RRRRMM'') IN
                                                                         (SELECT fim_year || lpad(FIM_MONTH,2,0)
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                  /*AND TO_CHAR (plt_sch_start_date,''rrrr'') IN
                                                                         (SELECT FIM_YEAR
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))*/
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID) > 0 THEN  ''Y''  else ''N'' END )) med_device_sch_flag
                                          from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = '''
            || i_con_number
            || '''
                                          and con_mpdc_service_code = '''
            || l_media_ser_code
            || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,CON_IS_FEA_SER,CON_RIGHTS_ON_DEVICE,CON_MPDC_DEV_PLATM_ID
                                                    --,CON_MPDC_UPDATE_COUNT
                                                    ,CON_CONTRACT_NUMBER
                                                 )a';
         /*FOR contract IN(SELECT md_id
            FROM x_cp_media_device MINUS
            SELECT DISTINCT mdp_map_dev_id FROM  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          WHERE CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          AND CON_CONTRACT_NUMBER  = i_con_number)*/
         --LOOP
         l_string1 :=
            'UNION select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.RIGHTS_ON_DEVICE,
                            a.IS_FEA_SER,
                            a.MPDC_DEV_PLATM_ID,
                            0 CON_CONTRACT_NUMBER,a.med_device_sch_flag,';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_UI_SEQ)
         LOOP
            l_string1 :=
                  l_string1
               || 'NVL( ( select  (case when MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || '''),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,';
         END LOOP;

         l_string1 :=
            l_string1
            || 'a.MPDC_UPDATE_COUNT  from (select MDP_MAP_DEV_ID,
                                           (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            '' '' RIGHTS_ON_DEVICE,
                                            '' '' IS_FEA_SER
                                            ,MPDC_DEV_PLATM_ID
                                            ,SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,''N'' med_device_sch_flag
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                                and MPDCS_MED_SERVICE_CODE = '''
            || l_media_ser_code
            || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a'; -- added on 24/03/2015 -- to check SVOD media service also
      --END LOOP;
      END IF;


      l_string3 := 'select a.Med_dev_code,
                              a.Med_dev_desc,
                              a.med_platm_code,
                              a.med_platm_desc,
                              a.Rights_On_device,
                              a.MPDC_DEV_PLATM_ID,
                              a.med_device_sch_flag,';

      FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                    FROM x_cp_media_device_compat
                ORDER BY MDC_UI_SEQ)
      LOOP
         l_string3 :=
               l_string3
            || 'NVL( ( select  (case when MPDC_COMP_RIGHTS_ID = '''
            || i.MDC_ID
            || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS_ID = '''
            || i.MDC_ID
            || '''  ),''N'')   '
            || i.MDC_CODE
            || '_Media_Rights ,';
      END LOOP;

      l_string3 :=
         l_string3
         || 'a.MPDC_UPDATE_COUNT from (select MDP_MAP_DEV_ID,
                                           (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                             ''N'' Rights_On_device,
                                             SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT,
                                             MPDC_DEV_PLATM_ID,
                                             ''N''  med_device_sch_flag
                                          from  x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map,x_cp_medplatdevcomp_servc_map
                                          where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                          and   MPDCS_MPDC_ID  =  MPDC_ID
                                          and MPDCS_MED_SERVICE_CODE = '''
         || l_media_ser_code
         || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a';

      l_string2 := l_string || ' ' || l_string1;

      --DBMS_OUTPUT.PUT_LINE ('l_string2' || l_string2);

      --   DBMS_OUTPUT.PUT_LINE('l_string3' || l_string3);

      OPEN O_con_medplatmdevcompatmap FOR l_string2;

      OPEN o_con_med_dev_rights FOR l_string3;

      --ACQ:CACQ14:END:[Sushma K]_[2014/10/14]
      -- SVOD changes (not used from now on) : End

      OPEN o_contracts_detail_data FOR
         SELECT con_number,
                con_name,
                con_short_name,
                --Dev2: Pure Finance :Start:[FIN 10-Contract maintenance]_[ANUJASHINDE]_[2013/2/22]
                --[to identify if contact id ED applicable adn to get Contact effectve Date for that contact]
                con_ed_applicable_flag,
                con_con_effective_date,
                ter_code supp_country_code,
                ter_name supp_country_desc,
                ter_fun_cur_code supp_currency,
                --Dev2: Pure Finance : End
                fcs.com_short_name supp_com_short_name,
                con_com_number,
                con_category,
                (SELECT cod_description
                   FROM fid_code
                  WHERE     cod_type = 'GEN_CATEGORY'
                        AND cod_value != 'HEADER'
                        AND cod_value = con_category)
                   category_descr,
                con_price,
                con_renew_date,
                fcs.com_name supp_com_name,
                fcce.com_short_name cont_entity_com_short_name,
                con_agy_com_number,
                fcce.com_name cont_entity_com_name,
                fl.lee_short_name licensee_sh_name,
                con_lee_number,
                fl.lee_name licensee_name,
                con_calc_type,
                fcode_contyp.cod_description cod_description,
                fcode_contyp.cod_description,
                con_date,
                con_status,
                fcode_status.cod_description,
                con_mux_ind,
                con_align_ind,
                con_start_date,
                con_end_date,                             --con_exh_day_start,
                (NVL (
                    LPAD (TO_CHAR (FLOOR ( (con_exh_day_start) / 3600)),
                          2,
                          0),
                    '--'))
                || ':'
                || (NVL (
                       LPAD (
                          TO_CHAR (
                             FLOOR (MOD (con_exh_day_start, 3600) / 60)),
                          2,
                          0),
                       '--'))
                   con_exh_dy_statr_time,
                con_exh_day_runs,
                con_exh_day_comment,
                con_license_period,
                con_currency,
                con_acct_date,
                con_min_subscriber,
                con_roy_calc_method,
                pkg_acon_cm_contract_maint.get_calc_method (
                   con_roy_calc_method)
                   roy_calc_method,
                con_comment,                          -- con_prime_time_start,
                (NVL (
                    LPAD (TO_CHAR (FLOOR ( (con_prime_time_start) / 3600)),
                          2,
                          0),
                    '--'))
                || ':'
                || (NVL (
                       LPAD (
                          TO_CHAR (
                             FLOOR (MOD (con_prime_time_start, 3600) / 60)),
                          2,
                          0),
                       '--'))
                   con_prime_time_start_t,
                --con_prime_time_end,
                (NVL (
                    LPAD (TO_CHAR (FLOOR ( (con_prime_time_end) / 3600)),
                          2,
                          0),
                    '--'))
                || ':'
                || (NVL (
                       LPAD (
                          TO_CHAR (
                             FLOOR (MOD (con_prime_time_end, 3600) / 60)),
                          2,
                          0),
                       '--'))
                   con_prime_time_end_t,
                con_prime_time_type,
                con_prime_time_pd_limit,
                con_prime_max_runs,
                con_prime_max_runs_perc,
                con_prime_time_level,
                (SELECT NVL (MAX (lic_rate), 0)
                   FROM fid_license
                  WHERE lic_con_number = con_number)
                   exchange_rate,
                -- Bioscope Changes by Anirudha start
                con_exhibition_per_day,
                con_limit_per_service,
                con_limit_per_channel,
                --Bioscope Changes End
                con_update_count,
                --,TIME_STARTED,TIME_ENDED
                /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
                -- Dev.R5 : SVOD Enhancements : Start : [Devashish Raverkar]_[2015/05/07]
                --con_catchup_flag,
                case
                WHEN NVL(con_catchup_flag,'N') IN ('Y','N','C')       -- Dev :3rd Party Catchup Implementation:[Jawahar_Garg]_[29-Jun-2015]-Added C for catchup flag
                THEN NVL(con_catchup_flag,'N')
                ELSE (SELECT ms_media_service_code
                        FROM sgy_pb_media_service
                       WHERE ms_media_service_flag = con_catchup_flag)
                END con_catchup_flag,
                -- Dev.R5 : SVOD Enhancements : End
                (SELECT COUNT (1)
                   FROM fid_license
                  WHERE     lic_con_number = i_con_number
                        --AND NVL (lic_catchup_flag, 'N') = 'Y'
                        AND NVL (lic_catchup_flag, 'N') = l_catchup_flag              -- added on 23/03/2015 -- to check SVOD flag also
                        AND NVL (lic_catchup_flag, 'N') in ('Y','S','C')              -- -- Dev :3rd Party Catchup Implementation:[Jawahar_Garg]_[29-Jun-2015]-Added C for catchup flag
						AND lic_status = 'A')
                   is_catchup,
                con_max_fee_subs,
                con_ad_promo_cha_brand_restr,
                con_max_perc_content_restr,
                con_min_of_major_studio_restr,
                con_not_allow_aft_x_start_lic,
                con_not_allow_bef_x_end_lic_dt,
                con_other_rules,
                con_mud_restriction,
                con_trans_tech_restr,
                con_studio_pre_roll_notice_req,
                con_sch_within_x_frm_ply_fea,
                con_sch_within_x_frm_ply_ser,
                con_sch_after_prem_linr_fea,
                con_sch_after_prem_linr_ser,
                con_sch_no_epi_restr_ser_seson,
                con_sch_x_day_before_linr_fea,
                con_sch_x_day_before_linr_ser,
                con_sch_x_day_bef_linr_val_fea,
                con_sch_x_day_bef_linr_val_ser,
                con_tba_ser_schedule_flag,
                con_procurement_type,
                --Dev2: Rand Devaulation :Start:[FIN 34- Rand Devaluation info]_[Sushma K]_[2014/06/10]
                fc.CON_DEVALUATION_FLAG,
                rdi.*                             /* Dev1: Catch-up R1:End  */
                     --ACQ:CACQ:start : Sushma K : 2014-OCT-16
                ,
                CON_SCH_WITHOUT_LINR_REF_FEA,
                CON_SCH_WITHOUT_LINR_REF_SER,
                (CASE
                    WHEN (SELECT COUNT (1)
                            FROM x_cp_con_medplatmdevcompat_map
                           WHERE CON_CONTRACT_NUMBER = i_con_number) > 0
                    THEN
                       'Y'
                    ELSE
                       'N'
                 END)
                   Med_Device_Rights_flag,
                (CASE
                    WHEN (SELECT COUNT (1)
                            FROM fid_license
                           WHERE lic_con_number = i_con_number) > 0
                    THEN
                       'Y'
                    ELSE
                       'N'
                 END)
                   con_is_lic_present,
                CON_IS_MG_FLAG
           --ACQ:END
           --CU4ALL Start :BR_15_239_ENH_Contract Maintenance  [Anuja_Shinde][09/12/2015]
           ,CON_COMPACT_VP_RUNS_FEA
           ,CON_ALLOW_RING_FENCE_FEA
           ,CON_ALLOW_RING_FENCE_SER
           ,CON_SCH_AFT_PREM_LINR_SER_BOUQ
           ,CON_SCH_LIN_SER_CHA
           ,Con_Allow_Exh_Week_Tier_Ser
           ,(Select (Case When Count(1)>0 Then 'Y' Else 'N' End)
              From Fid_Company Where Com_Internal = 'S'
              and com_number = fc.con_com_number
              And Com_Number Not In (1400, 55906,50186)
              ) CON_STUDIO_FLAG,
           --CU4ALL END
           --Finance Dev Phase I Zeshan [Start]
           (
             CASE 
              WHEN EXISTS
              (
                  SELECT 'Z'
                  FROM fid_license, fid_payment
                  WHERE lic_number = pay_lic_number
                  AND pay_status in ('P','T')
                  AND lic_con_number = fc.con_number
                  UNION ALL
                  SELECT 'Z'
                  FROM fid_license
                  WHERE TO_NUMBER(TO_CHAR (LIC_ACCT_DATE, 'RRRRMM')) < ( 
                            SELECT TO_NUMBER (fim_year || lpad(fim_month,2,0))
                              FROM fid_financial_month, fid_licensee
                             WHERE fim_split_region = lee_split_region
                               AND fim_status = 'O'
                               AND lee_number = lic_lee_number)
              )
              THEN 'N'
              ELSE 'Y'
              END
            ) con_currency_edit
           --Finance Dev Phase I [End]
           FROM fid_contract fc,
                fid_company fcs,
                --Dev2: Pure Finance :Start:[FIN 10-Contract maintenance]_[ANUJASHINDE]_[2013/2/22]
                fid_territory ter,
                --Dev2: Pure Finance :End
                fid_company fcce,
                fid_licensee fl,
                fid_code fcode_status,
                fid_code fcode_contyp,
                X_RAND_DEVALUATION_INFO rdi       --Dev2: Rand Devaulation:End
          WHERE     fcs.com_number(+) = con_com_number
                AND fcce.com_number(+) = con_agy_com_number
                --Dev2: Pure Finance :Start:[FIN 10-Contract maintenance]_[ANUJASHINDE]_[2013/2/22]
                AND ter.ter_code = fcs.com_ter_code
                --Dev2: Pure Finance :End
                AND fl.lee_number(+) = con_lee_number
                AND fcode_status.cod_value = con_status
                AND fcode_status.cod_type = 'CON_STATUS'
                AND fcode_contyp.cod_type = 'CON_CALC_TYPE'
                AND fcode_contyp.cod_value = con_calc_type
                AND con_number = i_con_number
                AND fc.con_number = rdi.rdi_con_number(+);
   
      --added By Milan Shah CU4ALL
      open O_CON_BOUQUET_RIGHTS for
      select CB_ID,
             CB_NAME,
             CB_RANK,
             CB_SHORT_CODE,
             CBM_CON_BOUQ_RIGHTS,
             CMM_BOUQ_MS_CODE,
             CMM_BOUQ_MS_RIGHTS,

              (select (case when count(1)>0 then 'Y' else 'N' END)
               from x_cp_play_list,x_cp_plt_terr_bouq
               where plt_lic_number IN(select lic_number from fid_license where lic_con_number = i_con_number)
                      AND PTB_BOUQUET_ID = CB_ID
                      AND PTB_PLT_ID = plt_id
                      AND (plt_sch_end_date >=(SELECT (TO_DATE(LPAD(FIM_MONTH,'2','0')||FIM_YEAR,'MMYYYY'))FROM FID_FINANCIAL_MONTH
                              WHERE FIM_STATUS ='O' AND FIM_SPLIT_REGION = 1)
            Or Plt_Sch_End_Date >=(Select (To_Date(Lpad(Fim_Month,'2','0')||Fim_Year,'MMYYYY'))From Fid_Financial_Month
                                  Where Fim_Status ='O' And Fim_Split_Region = 2))) Is_Scheduled,
            (Select (case when count(1)>0 then 'Y' else 'N' END)
              From  X_Cp_Con_Superstack_Rights Csr
                  Where Csr.Csr_Bouquet_Id = CB_ID
                  And Csr.Csr_Superstack_Flag = 'Y'
                  AND CSR_CON_NUMBER = i_con_number) IsSuperStacking

        from   X_CON_BOUQUE_MAPP,
             X_CP_BOUQUET,
             x_cp_bouquet_ms_mapp
        where CB_BOUQ_PARENT_ID is null
            AND CMM_BOUQ_ID = CB_ID
            and CBM_BOUQUE_ID = CB_ID
            AND CBM_CON_NUMBER = i_con_number
            And CB_AD_FLAG='A'
    UNION
      SELECT CB_ID,
             CB_NAME,
             CB_RANK,
             CB_SHORT_CODE,
             (CASE WHEN CB_RANK = 1 THEN 'Y' ELSE 'N' END) CBM_CON_BOUQ_RIGHTS,
             CMM_BOUQ_MS_CODE,
             CMM_BOUQ_MS_RIGHTS,
             'N' Is_Scheduled,
             'N' IsSuperStacking
       from  X_CP_BOUQUET,
             x_cp_bouquet_ms_mapp
       WHERE CB_BOUQ_PARENT_ID is null
             AND CMM_BOUQ_ID = CB_ID
             And CB_AD_FLAG='A'
             AND CB_ID NOT IN
            (
                select CB_ID
                from  X_CON_BOUQUE_MAPP,
                      X_CP_BOUQUET
                where CB_BOUQ_PARENT_ID is null
                      and CBM_BOUQUE_ID = CB_ID
                      AND CBM_CON_NUMBER = i_con_number
            )
          ORDER BY CB_RANK;
    --CU4ALL END

   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_contract_details_search;

   PROCEDURE prc_add_contract_details (
      i_con_name                       IN     fid_contract.con_name%TYPE,
      i_con_com_number                 IN     fid_contract.con_com_number%TYPE,
      i_con_agy_com_number             IN     fid_contract.con_agy_com_number%TYPE,
      i_con_lee_number                 IN     fid_contract.con_lee_number%TYPE,
      i_con_calc_type                  IN     fid_contract.con_calc_type%TYPE,
      i_con_currency                   IN     fid_contract.con_currency%TYPE,
      i_con_min_subscriber             IN     fid_contract.con_min_subscriber%TYPE,
      i_con_start_date                 IN     fid_contract.con_start_date%TYPE,
      i_con_end_date                   IN     fid_contract.con_end_date%TYPE,
      i_con_exh_day_start              IN     VARCHAR2,
      i_con_exh_day_runs               IN     fid_contract.con_exh_day_runs%TYPE,
      i_con_prime_time_start           IN     VARCHAR2,
      i_con_prime_time_end             IN     VARCHAR2,
      i_con_mux_ind                    IN     fid_contract.con_mux_ind%TYPE,
      i_con_align_ind                  IN     fid_contract.con_align_ind%TYPE,
      i_con_prime_time_type            IN     fid_contract.con_prime_time_type%TYPE,
      i_con_prime_time_pd_limit        IN     fid_contract.con_prime_time_pd_limit%TYPE,
      i_con_prime_max_runs             IN     fid_contract.con_prime_max_runs%TYPE,
      i_con_prime_max_runs_perc        IN     fid_contract.con_prime_max_runs_perc%TYPE,
      i_con_prime_time_level           IN     fid_contract.con_prime_time_level%TYPE,
      i_con_comment                    IN     fid_contract.con_comment%TYPE,
      i_con_exh_day_comment            IN     fid_contract.con_exh_day_comment%TYPE,
      i_user_id                        IN     fid_contract.con_entry_oper%TYPE,
      i_con_roy_calc_method            IN     fid_contract.con_roy_calc_method%TYPE,
      i_con_category                   IN     fid_contract.con_category%TYPE,
      i_con_price                      IN     fid_contract.con_price%TYPE,
      i_con_renew_date                 IN     fid_contract.con_renew_date%TYPE,
      i_con_short_name                 IN     fid_contract.con_short_name%TYPE,
      i_con_status                     IN     fid_contract.con_status%TYPE,
      i_con_date                       IN     fid_contract.con_date%TYPE,
      i_acc_date                       IN     fid_contract.con_acct_date%TYPE,
      i_license_period                 IN     fid_contract.con_license_period%TYPE,
      -- Project Bioscope Changes start Anirudha
      i_con_exhibition_per_day         IN     fid_contract.con_exhibition_per_day%TYPE,
      i_con_limit_per_service          IN     fid_contract.con_limit_per_service%TYPE,
      i_con_limit_per_channel          IN     fid_contract.con_limit_per_channel%TYPE,
      -- Project Bioscope Changes end.
      /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
      i_c_catchup_flag                 IN     fid_contract.con_catchup_flag%TYPE,
      i_c_max_fee_subs                 IN     fid_contract.con_max_fee_subs%TYPE,
      i_c_ad_promo_cha_brand_restr     IN     fid_contract.con_ad_promo_cha_brand_restr%TYPE,
      i_c_max_perc_content_restr       IN     fid_contract.con_max_perc_content_restr%TYPE,
      i_c_min_of_major_studio_restr    IN     fid_contract.con_min_of_major_studio_restr%TYPE,
      i_c_not_allow_aft_x_start_lic    IN     fid_contract.con_not_allow_aft_x_start_lic%TYPE,
      i_c_not_allow_bef_x_end_lic_dt   IN     fid_contract.con_not_allow_bef_x_end_lic_dt%TYPE,
      i_c_other_rules                  IN     fid_contract.con_other_rules%TYPE,
      i_c_mud_restriction              IN     fid_contract.con_mud_restriction%TYPE,
      i_c_trans_tech_restr             IN     fid_contract.con_trans_tech_restr%TYPE,
      i_c_studio_pre_roll_notice_req   IN     fid_contract.con_studio_pre_roll_notice_req%TYPE,
      i_c_sch_within_x_frm_ply_fea     IN     fid_contract.con_sch_within_x_frm_ply_fea%TYPE,
      i_c_sch_within_x_frm_ply_ser     IN     fid_contract.con_sch_within_x_frm_ply_ser%TYPE,
      i_c_sch_after_prem_linr_fea      IN     fid_contract.con_sch_after_prem_linr_fea%TYPE,
      i_c_sch_after_prem_linr_ser      IN     fid_contract.con_sch_after_prem_linr_ser%TYPE,
      i_c_sch_no_epi_restr_ser_seson   IN     fid_contract.con_sch_no_epi_restr_ser_seson%TYPE,
      i_c_sch_x_day_before_linr_fea    IN     fid_contract.con_sch_x_day_before_linr_fea%TYPE,
      i_c_sch_x_day_before_linr_ser    IN     fid_contract.con_sch_x_day_before_linr_ser%TYPE,
      i_c_sch_x_day_bef_linr_val_fea   IN     fid_contract.con_sch_x_day_bef_linr_val_fea%TYPE,
      i_c_sch_x_day_bef_linr_val_ser   IN     fid_contract.con_sch_x_day_bef_linr_val_ser%TYPE,
      i_con_tba_ser_schedule_flag      IN     fid_contract.con_tba_ser_schedule_flag%TYPE,
      i_c_procurement_type             IN     fid_contract.con_procurement_type%TYPE,
      /* Dev1: Catch-up R1:End  */
      /* Dev2: Rand Devaluation:Start:Sushma K_2014/15/09  */
      i_c_rand_devaluation_flag        IN     fid_contract.CON_DEVALUATION_FLAG%TYPE,
      /* Dev2: Rand Devaluation:End  */
      /* ACQ:CACQ:Start:Sushma K_2014/16/10  */
      i_con_SCH_WITHOUT_LINR_REF_FEA   IN     fid_contract.CON_SCH_WITHOUT_LINR_REF_FEA%TYPE,
      i_con_SCH_WITHOUT_LINR_REF_SER   IN     fid_contract.CON_SCH_WITHOUT_LINR_REF_SER%TYPE,
      /* ACQ:CACQ:End  */
      I_CON_MG_FLAG                    IN     FID_CONTRACT.CON_IS_MG_FLAG%TYPE --Warner Payment : Added by sushma
     --CU4ALL Start :BR_15_239_ENH_Contract Maintenance  [Anuja_Shinde][09/12/2015]
     ,I_CON_BOUQUET_RIGHTS               IN    VARCHAR2
     ,I_CON_COMPACT_VP_RUNS_FEA          IN    FID_CONTRACT.CON_COMPACT_VP_RUNS_FEA%TYPE
     ,I_CON_ALLOW_RING_FENCE_FEA         IN     FID_CONTRACT.CON_ALLOW_RING_FENCE_FEA%TYPE
     ,I_CON_ALLOW_RING_FENCE_SER	       IN     FID_CONTRACT.CON_ALLOW_RING_FENCE_SER%TYPE
     ,I_CON_SCH_AFT_PREM_SER_BOUQ	 IN     FID_CONTRACT.CON_SCH_AFT_PREM_LINR_SER_BOUQ%TYPE
     ,I_CON_SCH_LIN_SER_CHA	             IN     FID_CONTRACT.CON_SCH_LIN_SER_CHA%TYPE
     ,I_CON_ALLOW_EXH_WEEK_TIER_SER	     IN     FID_CONTRACT.CON_ALLOW_EXH_WEEK_TIER_SER%TYPE ,
      --CU4ALL END
      o_con_number                        OUT fid_contract.con_number%TYPE,
      o_con_short_name                    OUT fid_contract.con_short_name%TYPE)
   AS
      l_con_number             NUMBER;
      l_con_short_name         VARCHAR2 (12);
      l_systemid               VARCHAR2 (2);
      l_con_exh_day_start      NUMBER;
      l_con_prime_time_start   NUMBER;
      l_con_prime_time_end     NUMBER;
      l_contract_exist         NUMBER;
      L_CBM_ID                  NUMBER;
      L_CON_SCH_AFT_PREM_SER_BOUQ NUMBER;
      contract_exists          EXCEPTION;
      L_COUNT                 number;--added by Milan Shah
      v_operator              number;
   BEGIN
      --insert into test1 values('i_con_SCH_WITHOUT_LINR_REF_FEA' || i_con_SCH_WITHOUT_LINR_REF_FEA);
      -- insert into test1 values('i_con_SCH_WITHOUT_LINR_REF_SER' || i_con_SCH_WITHOUT_LINR_REF_SER);
      --commit;
     IF I_CON_SCH_AFT_PREM_SER_BOUQ = 0
     THEN
        L_CON_SCH_AFT_PREM_SER_BOUQ :=null;
      ELSE
       L_CON_SCH_AFT_PREM_SER_BOUQ := I_CON_SCH_AFT_PREM_SER_BOUQ;
      END IF;
      IF i_con_short_name IS NULL
      THEN
      /*  changed by khilesh chauhan for Vanilla on 14 May 2015 Max(con_number)+1 with nvl( MAX (con_number),0) + 1*/
         SELECT nvl( MAX (con_number),0) + 1 INTO l_con_number FROM fid_contract;

         --get_seq ('SEQ_CON_NUMBER');
         --l_con_number := get_seq ('SEQ_CON_NUMBER');
         SELECT spa_value
           INTO l_systemid
           FROM fid_system_parm
          WHERE spa_id = 'SYSTEM_ID';

         l_con_short_name :=
               TO_CHAR (SYSDATE, 'YY')
            || '-'
            || LTRIM (TO_CHAR (l_con_number, '099999'))
            || '-'
            || l_systemid;
      ELSE
         SELECT COUNT (con_short_name)
           INTO l_contract_exist
           FROM fid_contract
          WHERE con_short_name = UPPER (i_con_short_name);

         IF l_contract_exist > 0
         THEN
            RAISE contract_exists;
         ELSE
            l_con_short_name := i_con_short_name;
         END IF;
      END IF;

      l_con_exh_day_start :=
         TO_NUMBER (
            (SUBSTR (i_con_exh_day_start, 1, 2) * 3600)
            + (SUBSTR (i_con_exh_day_start, 4, 2) * 60));
      l_con_prime_time_start :=
         TO_NUMBER (
            (SUBSTR (i_con_prime_time_start, 1, 2) * 3600)
            + (SUBSTR (i_con_prime_time_start, 4, 2) * 60));
      l_con_prime_time_end :=
         TO_NUMBER (
            (SUBSTR (i_con_prime_time_end, 1, 2) * 3600)
            + (SUBSTR (i_con_prime_time_end, 4, 2) * 60));

      -- l_con_number := get_seq ('SEQ_CON_NUMBER');
      INSERT INTO fid_contract (con_number,
                                con_name,
                                con_short_name,
                                con_com_number,
                                con_agy_com_number,
                                con_lee_number,
                                con_calc_type,
                                con_currency,
                                con_min_subscriber,
                                con_start_date,
                                con_end_date,
                                con_date,
                                con_status,
                                con_comment,
                                con_exh_day_comment,
                                con_mux_ind,
                                con_align_ind,
                                con_exh_day_start,
                                con_exh_day_runs,
                                --con_prime_time,
                                con_prime_time_start,
                                con_prime_time_end,
                                con_roy_calc_method,
                                con_prime_max_runs,
                                con_prime_time_type,
                                con_prime_time_pd_limit,
                                con_prime_time_level,
                                con_prime_max_runs_perc,
                                con_entry_date,
                                con_entry_oper,
                                --con_is_deleted,
                                con_update_count,
                                con_category,
                                con_price,
                                con_renew_date,
                                con_acct_date,
                                con_license_period,
                                con_exhibition_per_day,
                                con_limit_per_service,
                                con_limit_per_channel,
                                /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
                                con_catchup_flag,
                                con_max_fee_subs,
                                con_ad_promo_cha_brand_restr,
                                con_max_perc_content_restr,
                                con_min_of_major_studio_restr,
                                con_not_allow_aft_x_start_lic,
                                con_not_allow_bef_x_end_lic_dt,
                                con_other_rules,
                                con_mud_restriction,
                                con_trans_tech_restr,
                                con_studio_pre_roll_notice_req,
                                con_sch_within_x_frm_ply_fea,
                                con_sch_within_x_frm_ply_ser,
                                con_sch_after_prem_linr_fea,
                                con_sch_after_prem_linr_ser,
                                con_sch_no_epi_restr_ser_seson,
                                con_sch_x_day_before_linr_fea,
                                con_sch_x_day_before_linr_ser,
                                con_sch_x_day_bef_linr_val_fea,
                                con_sch_x_day_bef_linr_val_ser,
                                con_tba_ser_schedule_flag,
                                con_procurement_type /* Dev1: Catch-up R1:End  */
                                                    ,
                                CON_DEVALUATION_FLAG /* Dev2: Rand Devaluation:start-End  */
                                                    --ACQ:CACQ:START: SUSHMA K : 2014-oct-16
                                ,
                                CON_SCH_WITHOUT_LINR_REF_FEA,
                                CON_SCH_WITHOUT_LINR_REF_SER,   --ACQ:CACQ:END
                                CON_IS_MG_FLAG --    --BR_15_144 Warner Payment Term - START on [28-09-2015]  by sushma

                             ,CON_COMPACT_VP_RUNS_FEA
                                       ,CON_ALLOW_RING_FENCE_FEA
                                       ,CON_ALLOW_RING_FENCE_SER
                                       ,CON_SCH_AFT_PREM_LINR_SER_BOUQ
                                       ,CON_SCH_LIN_SER_CHA
                                       ,CON_ALLOW_EXH_WEEK_TIER_SER

                                                            )
           VALUES (l_con_number,
                   i_con_name,
                   l_con_short_name,
                   i_con_com_number,
                   i_con_agy_com_number,
                   i_con_lee_number,
                   i_con_calc_type,
                   i_con_currency,
                   i_con_min_subscriber,
                   i_con_start_date,
                   i_con_end_date,
                   i_con_date,
                   i_con_status,
                   i_con_comment,
                   i_con_exh_day_comment,
                   i_con_mux_ind,
                   i_con_align_ind,
                   l_con_exh_day_start,
                   i_con_exh_day_runs,
                   -- l_con_prime_time,
                   l_con_prime_time_start,
                   l_con_prime_time_end,
                   i_con_roy_calc_method,
                   i_con_prime_max_runs,
                   i_con_prime_time_type,
                   i_con_prime_time_pd_limit,
                   i_con_prime_time_level,
                   i_con_prime_max_runs_perc,
                   SYSDATE,
                   i_user_id,                                           --'0',
                   0,
                   i_con_category,
                   i_con_price,
                   i_con_renew_date,
                   i_acc_date,
                   i_license_period,
                   i_con_exhibition_per_day,
                   i_con_limit_per_service,
                   i_con_limit_per_channel,
                   /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
		   -- Dev Start:3rd Party Catchup Implementation:[Jawahar_Garg]_[29-Jun-2015]-Added C for catchup flag
                   case
                   when I_CON_AGY_COM_NUMBER =  56224     --If contract entity is MCA set 3rd party cp flag
                   then
                   'C'
                   else
                   I_C_CATCHUP_FLAG
                   END,
		   -- Dev End:3rd Party Catchup Implementation
                   i_c_max_fee_subs,
                   i_c_ad_promo_cha_brand_restr,
                   i_c_max_perc_content_restr,
                   i_c_min_of_major_studio_restr,
                   i_c_not_allow_aft_x_start_lic,
                   i_c_not_allow_bef_x_end_lic_dt,
                   i_c_other_rules,
                   i_c_mud_restriction,
                   i_c_trans_tech_restr,
                   i_c_studio_pre_roll_notice_req,
                   i_c_sch_within_x_frm_ply_fea,
                   i_c_sch_within_x_frm_ply_ser,
                   i_c_sch_after_prem_linr_fea,
                   i_c_sch_after_prem_linr_ser,
                   i_c_sch_no_epi_restr_ser_seson,
                   i_c_sch_x_day_before_linr_fea,
                   i_c_sch_x_day_before_linr_ser,
                   i_c_sch_x_day_bef_linr_val_fea,
                   i_c_sch_x_day_bef_linr_val_ser,
                   NVL (i_con_tba_ser_schedule_flag, 'N'),
                   i_c_procurement_type           /* Dev1: Catch-up R1:End  */
                                       ,
                   NVL (i_c_rand_devaluation_flag, 'N') /* Dev2: Rand Devaluation:Start-End  */
                                                       ,
                   NVL (i_con_SCH_WITHOUT_LINR_REF_FEA, 'N'),
                     NVL (i_con_SCH_WITHOUT_LINR_REF_SER, 'N'),
                     I_CON_MG_FLAG --    --BR_15_144 Warner Payment Term - START on [28-09-2015]  by sushma

                   ,I_CON_COMPACT_VP_RUNS_FEA
                   ,I_CON_ALLOW_RING_FENCE_FEA
                   ,I_CON_ALLOW_RING_FENCE_SER
                   ,L_CON_SCH_AFT_PREM_SER_BOUQ
                   ,I_CON_SCH_LIN_SER_CHA
                   ,I_CON_ALLOW_EXH_WEEK_TIER_SER);
--
--                    INSERT INTO X_CON_BOUQUE_MAPP
--                    (
--                      CBM_ID
--                      ,CBM_CON_NUMBER
--                      ,CBM_BOUQUE_ID
--                      ,CBM_CON_BOUQ_RIGHTS
--                      ,CBM_ENTRY_OPER
--                      ,CBM_ENTRY_DATE
--                    )
--                    SELECT CBM_ID,CBM_CON_NUMBER,
--                    (SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_NAME=BOUQUET AND CB_BOUQ_PARENT_ID is null) BOUQUET_ID
--                      ,'Y',i_user_id,SYSDATE
--                    FROM
--                      (SELECT (SELECT nvl(MAX(CBM_ID),0) + 1 FROM X_CON_BOUQUE_MAPP) CBM_ID,l_con_number CBM_CON_NUMBER FROM DUAL) t1,
--                      --(SELECT COLUMN_VALUE  BOUQUET FROM TABLE(X_CP_SUPERSTACK_RIGHTS.split_to_char('Premium,Extra,Compact',','))) t2;
--                      (SELECT COLUMN_VALUE  BOUQUET FROM TABLE(X_CP_SUPERSTACK_RIGHTS.split_to_char(I_CON_BOUQUET_RIGHTS,','))) t2;
--
          IF i_c_catchup_flag = 'Y'
          THEN
                FOR I IN
                (
                    SELECT CB_NAME FROM x_cp_bouquet
                    WHERE CB_AD_FLAG='A'
                    AND cb_bouq_parent_id is null
                    MINUS
                    (SELECT COLUMN_VALUE COL1 FROM TABLE(X_PKG_VOD_REJECTED_TITLES.split_to_char(I_CON_BOUQUET_RIGHTS,',')))
                )
                LOOP
                    SELECT COUNT(1) INTO L_COUNT FROM X_CP_CON_SUPERSTACK_RIGHTS,x_cp_bouquet
                    where CSR_CON_NUMBER = l_con_number
                    AND csr_bouquet_id =CB_ID
                    AND CB_NAME = I.CB_NAME
                    and CSR_SUPERSTACK_FLAG ='Y';

                    IF L_COUNT >0
                    THEN
                        raise_application_error(-20666,'Super stack rights are present for selected bouquet. Kindly remove Super Stack rights for the selected bouquet first');
                    END IF;
                END LOOP;

                  DELETE FROM X_CON_BOUQUE_MAPP WHERE CBM_CON_NUMBER=l_con_number;
                  FOR I IN
                  (

                        (select cb_id
                                ,cb_name BOUQUET
                         From   x_cp_bouquet
                                ,(SELECT COLUMN_VALUE COL1 FROM TABLE(X_PKG_VOD_REJECTED_TITLES.split_to_char(I_CON_BOUQUET_RIGHTS,',')))
                         where  cb_name = COL1
                                AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP
                                          WHERE CMM_BOUQ_MS_CODE IN (select MS_MEDIA_SERVICE_CODE from fid_contract,sgy_pb_media_service
                                                      where MS_MEDIA_SERVICE_FLAG=CON_CATCHUP_FLAG
                                                        AND CON_NUMBER =l_con_number)AND CMM_BOUQ_MS_RIGHTS ='Y')
                               AND CB_AD_FLAG = 'A'
                               AND cb_bouq_parent_id is null
                         )
                            --SELECT T1.COL1 BOUQUET FROM
                      --(
                        --(SELECT COLUMN_VALUE COL1 FROM TABLE(X_PKG_VOD_REJECTED_TITLES.split_to_char(I_CON_BOUQUET_RIGHTS,','))) T1
                      --)
                  )
                  LOOP
                      IF I.BOUQUET IS NOT NULL
                      THEN
                      SELECT X_SEQ_CON_BOUQUET_MAPP.nextval INTO L_CBM_ID FROM Dual;

                      SELECT pkg_cm_username.SetUserName (i_user_id) into V_OPERATOR FROM DUAL;
                      INSERT INTO X_CON_BOUQUE_MAPP
                      (
                        CBM_ID
                        ,CBM_CON_NUMBER
                        ,CBM_BOUQUE_ID
                        ,CBM_CON_BOUQ_RIGHTS
                        ,CBM_ENTRY_OPER
                        ,CBM_ENTRY_DATE
                      )
                      VALUES
                      (
                        L_CBM_ID
                        ,l_con_number
                        ,(SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_NAME = I.BOUQUET AND CB_BOUQ_PARENT_ID is null AND CB_AD_FLAG='A')
                        ,'Y'
                        ,i_user_id
                        ,SYSDATE
                      );
                      END IF;
                  END LOOP;

          END IF;

      COMMIT;
      o_con_number := l_con_number;
      o_con_short_name := l_con_short_name;
   EXCEPTION
      WHEN contract_exists
      THEN
         raise_application_error (
            -20666,
            'Contract Short Name already exists,Please enter another');
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_add_contract_details;

   --Dev2: Pure Finance :Start:[FIN 10-Contract maintenance]_[ANUJASHINDE]_[2013/2/23]
   PROCEDURE prc_contract_curr_validate (
      i_con_number        IN     fid_contract.con_number%TYPE,
      i_con_currency      IN     fid_contract.con_currency%TYPE,
      i_allowchangeflag   IN     VARCHAR2,
      o_flagmsg              OUT NUMBER)
   AS
      ismonthopen           VARCHAR2 (1 BYTE);
      count_lic             NUMBER;
      openmonth             NUMBER;
      openyear              NUMBER;
      cnt_lic_in_open_mon   NUMBER;
      openstrt              DATE;
      openlast              DATE;
      cnt                   NUMBER;
      cnt_same_curr         NUMBER;
      cnt_null_pay_date     NUMBER;
   BEGIN
      o_flagmsg := 0;

      IF i_allowchangeflag = 'false'
      THEN
         --DBMS_OUTPUT.put_line ('flase condition chk');

         SELECT COUNT (1)
           INTO cnt_null_pay_date
           FROM fid_payment
          WHERE     pay_con_number = i_con_number
                AND pay_status = 'P'
                AND pay_date IS NOT NULL;

         --DBMS_OUTPUT.put_line ('cnt_null_pay_date-' || cnt_null_pay_date);

         SELECT COUNT (1)
           INTO cnt
           FROM fid_financial_month
          WHERE fim_status = 'O';

         IF cnt >= 2                                      -- to get open month
         THEN
            SELECT LPAD (fim_month, 2, 0), fim_year
              INTO openmonth, openyear
              FROM fid_financial_month
             WHERE fim_status = 'O'
                   AND fim_split_region =
                          (SELECT lee_split_region
                             FROM fid_contract, fid_licensee
                            WHERE con_lee_number = lee_number
                                  AND con_number = i_con_number);
         ELSE
            SELECT LPAD (fim_month, 2, 0), fim_year
              INTO openmonth, openyear
              FROM fid_financial_month
             WHERE fim_status = 'O';
         END IF;

         --DBMS_OUTPUT.put_line ('open month' || openmonth);

         SELECT TRUNC (
                   TO_DATE (LPAD (openmonth, 2, 0) || openyear, 'mmyyyy'),
                   'MON')
           INTO openstrt
           FROM DUAL;                               -- first day of open month

         SELECT LAST_DAY (
                   TO_DATE (LPAD (openmonth, 2, 0) || openyear, 'mmyyyy'))
           INTO openlast
           FROM DUAL;                                -- last day of open month

         IF (cnt_null_pay_date > 0)
         THEN
            SELECT COUNT (1)
              INTO count_lic
              FROM fid_payment
             WHERE pay_lic_number IN (SELECT lic_number
                                        FROM fid_license
                                       WHERE lic_con_number = i_con_number)
                   AND pay_status = 'P';

            --DBMS_OUTPUT.put_line (count_lic || 'count lic');

            IF count_lic > 0
            THEN
               SELECT COUNT (1)
                 INTO cnt_lic_in_open_mon       -- if any lic is in open month
                 FROM fid_payment
                WHERE pay_lic_number IN
                         (SELECT lic_number
                            FROM fid_license
                           WHERE lic_con_number = i_con_number)
                      AND pay_status = 'P'
                      AND pay_date NOT BETWEEN openstrt AND openlast;

               --DBMS_OUTPUT.put_line (
                --  cnt_lic_in_open_mon || 'count of lic in open month');

               IF cnt_lic_in_open_mon > 0
               THEN
                  o_flagmsg := 2;
               -- returns 2 when paid date is in closed month
               ELSE
                  SELECT COUNT (1)
                    INTO cnt_same_curr
                    FROM fid_payment
                   WHERE     pay_con_number = i_con_number
                         AND pay_status = 'P'
                         AND pay_cur_code != i_con_currency;

                  IF cnt_same_curr > 0
                  THEN
                     o_flagmsg := 1;
                  -- return 1 when con and pay currencies are not same
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;

      --DBMS_OUTPUT.put_line (o_flagmsg);
   END prc_contract_curr_validate;

   --Dev2: Pure Finance :End
   PROCEDURE prc_update_contract_details (
      i_con_number                     IN     fid_contract.con_number%TYPE,
      i_con_name                       IN     fid_contract.con_name%TYPE,
      i_con_com_number                 IN     fid_contract.con_com_number%TYPE,
      i_con_agy_com_number             IN     fid_contract.con_agy_com_number%TYPE,
      i_con_lee_number                 IN     fid_contract.con_lee_number%TYPE,
      i_con_calc_type                  IN     fid_contract.con_calc_type%TYPE,
      i_con_currency                   IN     fid_contract.con_currency%TYPE,
      i_con_min_subscriber             IN     fid_contract.con_min_subscriber%TYPE,
      i_con_start_date                 IN     fid_contract.con_start_date%TYPE,
      i_con_end_date                   IN     fid_contract.con_end_date%TYPE,
      i_con_exh_day_start              IN     VARCHAR2,
      i_con_exh_day_runs               IN     fid_contract.con_exh_day_runs%TYPE,
      i_con_prime_time_start           IN     VARCHAR2,
      i_con_prime_time_end             IN     VARCHAR2,
      i_con_mux_ind                    IN     fid_contract.con_mux_ind%TYPE,
      i_con_align_ind                  IN     fid_contract.con_align_ind%TYPE,
      i_con_prime_time_type            IN     fid_contract.con_prime_time_type%TYPE,
      i_con_prime_time_pd_limit        IN     fid_contract.con_prime_time_pd_limit%TYPE,
      i_con_prime_max_runs             IN     fid_contract.con_prime_max_runs%TYPE,
      i_con_prime_max_runs_perc        IN     fid_contract.con_prime_max_runs_perc%TYPE,
      i_con_prime_time_level           IN     fid_contract.con_prime_time_level%TYPE,
      i_con_comment                    IN     fid_contract.con_comment%TYPE,
      i_con_exh_day_comment            IN     fid_contract.con_exh_day_comment%TYPE,
      i_con_roy_calc_method            IN     fid_contract.con_roy_calc_method%TYPE,
      i_con_update_count               IN     fid_contract.con_update_count%TYPE,
      i_con_category                   IN     fid_contract.con_category%TYPE,
      i_con_price                      IN     fid_contract.con_price%TYPE,
      i_con_renew_date                 IN     fid_contract.con_renew_date%TYPE,
      i_con_short_name                 IN     fid_contract.con_short_name%TYPE,
      i_con_status                     IN     fid_contract.con_status%TYPE,
      i_con_date                       IN     fid_contract.con_date%TYPE,
      i_acc_date                       IN     fid_contract.con_acct_date%TYPE,
      i_license_period                 IN     fid_contract.con_license_period%TYPE,
      i_processclicked                 IN     VARCHAR2,
      -- Project Bioscope Changes start
      i_con_exhibition_per_day         IN     fid_contract.con_exhibition_per_day%TYPE,
      i_con_limit_per_service          IN     fid_contract.con_limit_per_service%TYPE,
      i_con_limit_per_channel          IN     fid_contract.con_limit_per_channel%TYPE,
      -- Project Bioscope Changes end.
      i_entryoper                      IN     fid_contract.con_entry_oper%TYPE,
      /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
      i_c_catchup_flag                 IN     fid_contract.con_catchup_flag%TYPE,
      i_c_max_fee_subs                 IN     fid_contract.con_max_fee_subs%TYPE,
      i_c_ad_promo_cha_brand_restr     IN     fid_contract.con_ad_promo_cha_brand_restr%TYPE,
      i_c_max_perc_content_restr       IN     fid_contract.con_max_perc_content_restr%TYPE,
      i_c_min_of_major_studio_restr    IN     fid_contract.con_min_of_major_studio_restr%TYPE,
      i_c_not_allow_aft_x_start_lic    IN     fid_contract.con_not_allow_aft_x_start_lic%TYPE,
      i_c_not_allow_bef_x_end_lic_dt   IN     fid_contract.con_not_allow_bef_x_end_lic_dt%TYPE,
      i_c_other_rules                  IN     fid_contract.con_other_rules%TYPE,
      i_c_mud_restriction              IN     fid_contract.con_mud_restriction%TYPE,
      i_c_trans_tech_restr             IN     fid_contract.con_trans_tech_restr%TYPE,
      i_c_studio_pre_roll_notice_req   IN     fid_contract.con_studio_pre_roll_notice_req%TYPE,
      i_c_sch_within_x_frm_ply_fea     IN     fid_contract.con_sch_within_x_frm_ply_fea%TYPE,
      i_c_sch_within_x_frm_ply_ser     IN     fid_contract.con_sch_within_x_frm_ply_ser%TYPE,
      i_c_sch_after_prem_linr_fea      IN     fid_contract.con_sch_after_prem_linr_fea%TYPE,
      i_c_sch_after_prem_linr_ser      IN     fid_contract.con_sch_after_prem_linr_ser%TYPE,
      i_c_sch_no_epi_restr_ser_seson   IN     fid_contract.con_sch_no_epi_restr_ser_seson%TYPE,
      i_c_sch_x_day_before_linr_fea    IN     fid_contract.con_sch_x_day_before_linr_fea%TYPE,
      i_c_sch_x_day_before_linr_ser    IN     fid_contract.con_sch_x_day_before_linr_ser%TYPE,
      i_c_sch_x_day_bef_linr_val_fea   IN     fid_contract.con_sch_x_day_bef_linr_val_fea%TYPE,
      i_c_sch_x_day_bef_linr_val_ser   IN     fid_contract.con_sch_x_day_bef_linr_val_ser%TYPE,
      i_con_tba_ser_schedule_flag      IN     fid_contract.con_tba_ser_schedule_flag%TYPE,
      i_c_procurement_type             IN     fid_contract.con_procurement_type%TYPE,
      /* Dev1: Catch-up R1:End  */
      /* Dev2: Rand Devaluation:Start:Sushma K_2014/15/09  */
      i_c_rand_devaluation_flag        IN     fid_contract.CON_DEVALUATION_FLAG%TYPE,
      /* Dev2: Rand Devaluation:End  */
      /* ACQ:CACQ:Start:Sushma K_2014/16/10  */
      i_con_SCH_WITHOUT_LINR_REF_FEA   IN     fid_contract.CON_SCH_WITHOUT_LINR_REF_FEA%TYPE,
      i_con_SCH_WITHOUT_LINR_REF_SER   IN     fid_contract.CON_SCH_WITHOUT_LINR_REF_SER%TYPE,
      i_con_lic_update_fea             IN     VARCHAR2,
      i_con_lic_update_ser             IN     VARCHAR2,
      i_con_lic_update_x_days_fea      IN     VARCHAR2, --CP : CACQ14:add for popup box confirmation YES/NO
      i_con_lic_update_x_days_ser      IN     VARCHAR2, --CP : CACQ14:add for popup box confirmation YES/NO
      /*  i_rights_on_device_fea              IN     X_CP_CON_MEDPLATMDEVCOMPAT_MAP.CON_RIGHTS_ON_DEVICE%type,
        i_rights_on_device_ser              IN     X_CP_CON_MEDPLATMDEVCOMPAT_MAP.CON_RIGHTS_ON_DEVICE%type,
        i_med_comp_is_rights_fea            IN     varchar2,
        i_med_comp_is_rights_ser            IN     varchar2,
        i_is_fea_ser                     IN     varchar2,
        i_mpdc_dev_platm_id              IN       NUMBER,
        o_sch_count                      OUT      NUMBER,**/
      /* ACQ:CACQ:End  */
     --BR_15_144 Warner Payment Term - START on [28-09-2015]  by sushma
      i_con_mg_flag                    IN     fid_contract.con_is_mg_flag%TYPE,
      --
      I_CON_BOUQUET_RIGHTS               IN    VARCHAR2
     ,I_CON_COMPACT_VP_RUNS_FEA          IN    FID_CONTRACT.CON_COMPACT_VP_RUNS_FEA%TYPE
     ,I_CON_ALLOW_RING_FENCE_FEA         IN     FID_CONTRACT.CON_ALLOW_RING_FENCE_FEA%TYPE
     ,I_CON_ALLOW_RING_FENCE_SER	       IN     FID_CONTRACT.CON_ALLOW_RING_FENCE_SER%TYPE
     ,I_CON_SCH_AFT_PREM_SER_BOUQ	        IN     FID_CONTRACT.CON_SCH_AFT_PREM_LINR_SER_BOUQ%TYPE
     ,I_CON_SCH_LIN_SER_CHA	             IN     FID_CONTRACT.CON_SCH_LIN_SER_CHA%TYPE
     ,I_CON_ALLOW_EXH_WEEK_TIER_SER	     IN     FID_CONTRACT.CON_ALLOW_EXH_WEEK_TIER_SER%TYPE ,
      --
      o_con_short_name                    OUT fid_contract.con_short_name%TYPE,
      o_con_update_count                  OUT fid_contract.con_update_count%TYPE,
      o_filename                          OUT VARCHAR2,
      o_sch_present_past                  OUT VARCHAR2,
      o_sch_exist_fea                     OUT VARCHAR2,
      o_sch_exist_ser                     OUT VARCHAR2,
      o_sch_exist_bef_x_days_fea          OUT VARCHAR2,
      o_sch_exist_bef_x_days_ser          OUT VARCHAR2)
   AS
      l_con_short_name             VARCHAR2 (12);
      l_contract_exist             NUMBER;
      l_systemid                   VARCHAR2 (2);
      l_con_number                 NUMBER;
      contract_short_name_exists   EXCEPTION;
      o_error_found                VARCHAR2 (2000);
      l_after_start                NUMBER;
      l_lnr_lic_start              DATE;
      l_lnr_lic_end                DATE;
      l_lnr_lic_no                 NUMBER;
      l_before_start               NUMBER;
      l_is_schdled                 NUMBER;
      l_is_catchup                 NUMBER;
      l_series_x                   NUMBER;
      l_min_vp_ser                 NUMBER;
      l_min_vp_fea                 NUMBER;
      l_fea_x                      NUMBER;
      l_fea_lnr_x                  NUMBER;
      l_ser_lnr_x                  NUMBER;
      l_bin_upd                    NUMBER;
      l_upd_lnr_lic_start          DATE;
      l_upd_lnr_lic_end            DATE;
      l_prem_lnr_start_fea         VARCHAR2 (1);
      l_prem_lnr_start_ser         VARCHAR2 (1);
      l_min_vp_is_1_fea            NUMBER;
      l_min_vp_is_1_ser            NUMBER;
      lnr_lic_strt                 DATE;
      lnr_lic_end                  DATE;
      lnr_lic_number               NUMBER;
      lnr_lic_tba                  fid_license.lic_period_tba%TYPE;
      l_lic_start                  fid_license.lic_start%TYPE;
      l_lic_end                    fid_license.lic_end%TYPE;
      l_lic_lee_number             fid_license.lic_lee_number%TYPE;
      l_lic_gen_refno              fid_license.lic_gen_refno%TYPE;
      l_lee_region_id              fid_licensee.lee_region_id%TYPE;
      l_sch_number                 fid_schedule.sch_number%TYPE;
      l_plt_sch_number             x_cp_play_list.plt_sch_number%TYPE;
      l_plt_sch_start_date         x_cp_play_list.plt_sch_start_date%TYPE;
      l_bin_sch_number             x_cp_schedule_bin.bin_sch_number%TYPE;
      l_bin_view_start_date        x_cp_schedule_bin.bin_view_start_date%TYPE;
      l_bin_lic_number             x_cp_schedule_bin.bin_lic_number%TYPE;
      l_bin_id                     x_cp_schedule_bin.bin_id%TYPE;
      l_bin_sch_from_time          x_cp_schedule_bin.bin_sch_from_time%TYPE;
      l_bin_sch_end_time           x_cp_schedule_bin.bin_sch_end_time%TYPE;
      l_tba_ser_schedule_flag      fid_contract.con_tba_ser_schedule_flag%TYPE;
      l_plt_count                  NUMBER;
      l_tba_ser_schedule_cnt       NUMBER;
      l_con_sch_no_epi_restr_ser   NUMBER;
      l_ser_number                 NUMBER;
      L_SER_SCHEDULE_CNT           NUMBER;
      l_CON_UPDATE_COUNT           NUMBER;
      l_sch_start                  NUMBER;
      l_sch_start_ser              NUMBER;
      --Dev2: Pure Finance :Start:[FIN 10-Contract maintenance]_[ANUJASHINDE]_[2013/2/21]
      PAY_CURR_OLD                 VARCHAR2 (5);
      con_curr_old                 VARCHAR2 (5);
      --Dev2: Pure Finance :End
      /* ACQ:CACQ:Start:Sushma K_2014/21/10  */
      l_cp_lic_sch                 NUMBER;
      l_fea_flag                   VARCHAR2 (1);
      l_ser_flag                   VARCHAR2 (1);
      l_sch_date                   DATE;
      l_sch_time                   DATE;
      l_min_sch_time               DATE;
      l_sch_count                  NUMBER;
      l_sch_premier_count          NUMBER;
      l_rights_on_device_fea       VARCHAR2 (1);
      l_rights_on_device_ser       VARCHAR2 (1);
      l_device_rights_fea          VARCHAR2 (10);
      l_device_rights_ser          VARCHAR2 (10);
      l_med_device                 VARCHAR2 (10);
      l_med_platm_code             VARCHAR2 (10);
      l_sch_exist_ser              NUMBER;
      l_sch_exist_fea              NUMBER;
      l_sch_lic_number             NUMBER;
      l_min_sch_date               DATE;
      l_sch_count_new              NUMBER;
      l_con_mem_cnt                NUMBER;
      l_con_mem_list               VARCHAR2 (100);
      l_con_is_mg_flag             VARCHAR2 (1);
      l_lic_count                  NUMBER;
      --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
      L_CON_STATUS                 VARCHAR2 (1);
      L_T_LIC_CNT                  NUMBER;
      L_CBM_ID                     NUMBER;
      L_CON_SCH_AFT_PREM_SER_BOUQ number;
      L_COUNT                     number;     --added by Milan Shah
      L_RIGHT                     varchar2(1);
       V_OPERATOR          number ;
      --RDT End : Acquision Requirements BR_15_104
      /* ACQ:CACQ:End  */
      ---this cursor will bring all the catchup license based on the contract
      CURSOR catchup_lic
      IS
           SELECT lic_start,
                  lic_end,
                  lic_number,
                  lic_budget_code,
                  lic_period_tba,
                  lee_region_id,
                  gen_refno
             FROM fid_license,
                  fid_contract,
                  fid_licensee,
                  fid_general
            WHERE     lic_con_number = con_number
                  AND lic_status = 'A'
                  --AND NVL (lic_catchup_flag, 'N') = 'Y'
                  AND NVL (lic_catchup_flag, 'N') = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
                  AND con_number = i_con_number
                  AND gen_refno = lic_gen_refno
                  AND lic_lee_number = lee_number
         -- and con_lee_number=lee_number
         ORDER BY lic_start;

      ---this cursor will bring all the catchup license based on the contract but of type Series
      CURSOR catchup_lic_ser
      IS
           SELECT lic_start,
                  lic_end,
                  lic_number,
                  lic_budget_code
             FROM fid_license,
                  fid_contract,
                  fid_licensee,
                  fid_general
            WHERE     lic_con_number = con_number
                  AND lic_status = 'A'
                  --AND NVL (lic_catchup_flag, 'N') = 'Y'
                  AND NVL (lic_catchup_flag, 'N') = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
                  AND con_number = i_con_number
                  AND gen_refno = lic_gen_refno
                  AND lic_lee_number = lee_number
                  AND X_FNC_GET_PROG_TYPE (lic_budget_code) = 'Y'
         -- and con_lee_number=lee_number
         ORDER BY lic_start;

      ---this cursor will bring all the catchup license based on the contract but of type other than series
      CURSOR catchup_lic_fea
      IS
           SELECT lic_start,
                  lic_end,
                  lic_number,
                  lic_budget_code
             FROM fid_license,
                  fid_contract,
                  fid_licensee,
                  fid_general
            WHERE     lic_con_number = con_number
                  AND lic_status = 'A'
                  --AND NVL (lic_catchup_flag, 'N') = 'Y'
                  AND NVL (lic_catchup_flag, 'N') = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
                  AND con_number = i_con_number
                  AND gen_refno = lic_gen_refno
                  AND lic_lee_number = lee_number
                  AND X_FNC_GET_PROG_TYPE (lic_budget_code) <> 'Y'
         -- and con_lee_number=lee_number
         ORDER BY lic_start;
   BEGIN
    IF I_CON_SCH_AFT_PREM_SER_BOUQ = 0
     THEN
        L_CON_SCH_AFT_PREM_SER_BOUQ :=null;
      ELSE
       L_CON_SCH_AFT_PREM_SER_BOUQ := I_CON_SCH_AFT_PREM_SER_BOUQ;
      END IF;
      --CATCHUP:CACQ14:START:change for a popup message by SHANTANU A.
      o_sch_exist_fea := 'Y';
      o_sch_exist_ser := 'Y';
      o_sch_exist_bef_x_days_fea := 'Y';
      o_sch_exist_bef_x_days_ser := 'Y';
      o_sch_present_past := 'Y';

      --CATCHUP:CACQ14:[END]

        SELECT pkg_cm_username.SetUserName (i_entryoper)
       into V_OPERATOR
      FROM DUAL;

      SELECT NVL (con_tba_ser_schedule_flag, 'N')
        INTO l_tba_ser_schedule_flag
        FROM fid_contract
       WHERE con_number = i_con_number;

      IF l_tba_ser_schedule_flag = 'Y' AND i_con_tba_ser_schedule_flag = 'N'
      THEN
         SELECT COUNT (*)
           INTO l_tba_ser_schedule_cnt
           FROM fid_license
          WHERE lic_cp_tba_sch_flg = 'Y' AND lic_con_number = i_con_number;

         IF l_tba_ser_schedule_cnt > 0
         THEN
            raise_application_error (
               -20666,
               'TBA license of this contract is already scheduled. hence cannot uncheck "Allow TBA to schedule" check box.');
         END IF;
      END IF;

      --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
      --Validate when Edit "T"/"A"  Contact Status
      SELECT CON_SHORT_NAME, CON_STATUS
        INTO l_con_short_name, l_con_status
        FROM fid_contract
       WHERE con_number = i_con_number;

      IF L_CON_STATUS <> I_CON_STATUS
      THEN
         --CHANGING STATUS FROM "T" TO "A"
         IF L_CON_STATUS = 'T' AND I_CON_STATUS = 'A'
         THEN
            SELECT COUNT (1)
              INTO L_T_LIC_CNT
              FROM FID_CONTRACT, FID_LICENSE
             WHERE     LIC_CON_NUMBER = CON_NUMBER
                   AND con_number = i_con_number
                   AND LIC_STATUS = 'T'
                   AND con_status IN ('T', 'A');

            IF L_T_LIC_CNT > 0
            THEN
               RAISE_APPLICATION_ERROR (
                  -20688,
                  'Contract contains T licenses. Cannot save status as "A"');
            END IF;
         ELSIF L_CON_STATUS = 'A' AND I_CON_STATUS = 'T' --CHANGING STATUS FROM "A" TO "T"
         THEN
            SELECT COUNT (1)
              INTO L_T_LIC_CNT
              FROM FID_CONTRACT, FID_LICENSE
             WHERE     LIC_CON_NUMBER = CON_NUMBER
                   AND CON_NUMBER = I_CON_NUMBER
                   AND LIC_STATUS = 'A'
                   AND CON_STATUS IN ('T', 'A');

            IF L_T_LIC_CNT > 0
            THEN
               RAISE_APPLICATION_ERROR (
                  -20688,
                  'Cannot save status as "T" as contract has licenses other than TLicenses in it');
            END IF;
         END IF;
      END IF;

      --RDT End : Acquision Requirements BR_15_104

      DELETE FROM fid_con_log
            WHERE con_number = i_con_number;

      COMMIT;

      IF (i_processclicked = 'Y')
      THEN
         prc_check_contract_licenses (i_con_number,
                                      i_con_short_name,
                                      i_con_prime_time_start,
                                      i_con_prime_time_end,
                                      i_con_prime_max_runs,
                                      i_con_prime_max_runs_perc,
                                      i_con_prime_time_level,
                                      i_con_prime_time_pd_limit,
                                      i_con_prime_time_type,
                                      o_filename,
                                      o_error_found);
      END IF;

      /* Catchup (CACQ 16) :Pranay Kusumwal 12/10/2012 :Validations for CATCHUP FIELDS */

      ---- calculating the min(max vp) for all the licenses of SERIES type
      --will be validated against x days from playout on linear(ser)
      SELECT MIN (lic_max_viewing_period)
        INTO l_min_vp_ser
        FROM fid_license,
             fid_contract,
             fid_licensee,
             fid_general
       WHERE     lic_con_number = con_number
             AND lic_status = 'A'
             --AND NVL (lic_catchup_flag, 'N') = 'Y'
             AND NVL (lic_catchup_flag, 'N') = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
             AND con_number = i_con_number
             AND gen_refno = lic_gen_refno
             AND lic_lee_number = lee_number
             AND lic_budget_code = 'SER';

      ---- calculating the min(max vp) for all the licenses of FEA type
      --will be validated against x days from playout on linear(fea)
      SELECT MIN (lic_max_viewing_period)
        INTO l_min_vp_fea
        FROM fid_license,
             fid_contract,
             fid_licensee,
             fid_general
       WHERE     lic_con_number = con_number
             AND lic_status = 'A'
             --AND NVL (lic_catchup_flag, 'N') = 'Y'
             AND NVL (lic_catchup_flag, 'N') = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
             AND con_number = i_con_number
             AND gen_refno = lic_gen_refno
             AND lic_lee_number = lee_number
             AND lic_budget_code <> 'SER';

      --this will check if any lic is present which have MX VP not equal to 1  for fea
      ---if present and the Schedule after Premiere broadcast on first linear channel is changed from uncheck to check throw error
      SELECT COUNT (lic_showing_int)
        INTO l_min_vp_is_1_fea
        FROM fid_license,
             fid_contract,
             fid_licensee,
             fid_general
       WHERE     lic_con_number = con_number
             AND lic_status = 'A'
             --AND NVL (lic_catchup_flag, 'N') = 'Y'
             AND NVL (lic_catchup_flag, 'N') = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
             AND con_number = i_con_number
             AND gen_refno = lic_gen_refno
             AND lic_showing_LIC > 1
             AND lic_lee_number = lee_number
             AND X_FNC_GET_PROG_TYPE (lic_budget_code) <> 'Y';

      --this will check if any lic is present which have MX VP not equal to 1  for ser
      ---if present and the Schedule after Premiere broadcast on first linear channel is changed from uncheck to check throw error
      SELECT COUNT (lic_showing_int)
        INTO l_min_vp_is_1_ser
        FROM fid_license,
             fid_contract,
             fid_licensee,
             fid_general
       WHERE     lic_con_number = con_number
             AND lic_status = 'A'
             --AND NVL (lic_catchup_flag, 'N') = 'Y'
             AND NVL (lic_catchup_flag, 'N') = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
             AND con_number = i_con_number
             AND gen_refno = lic_gen_refno
             AND lic_showing_LIC > 1
             AND lic_lee_number = lee_number
             AND X_FNC_GET_PROG_TYPE (lic_budget_code) = 'Y';

      --- these will bring all the fields on which validations are required
      SELECT NVL (con_not_allow_aft_x_start_lic, 0),
             NVL (con_not_allow_bef_x_end_lic_dt, 0),
             NVL (con_sch_within_x_frm_ply_ser, 0),
             NVL (con_sch_within_x_frm_ply_fea, 0),
             NVL (con_sch_x_day_bef_linr_val_ser, 0),
             NVL (con_sch_x_day_bef_linr_val_fea, 0),
             NVL (con_sch_after_prem_linr_fea, 'N'),
             NVL (con_sch_after_prem_linr_ser, 'N'),
             NVL (con_sch_x_day_before_linr_fea, 'N'),
             NVL (con_sch_x_day_before_linr_ser, 'N'),
             con_sch_no_epi_restr_ser_seson,
             NVL (con_is_mg_flag, 'N')
        INTO l_after_start,
             l_before_start,
             l_series_x,
             l_fea_x,
             l_ser_lnr_x,
             l_fea_lnr_x,
             l_prem_lnr_start_fea,
             l_prem_lnr_start_ser,
             l_fea_flag,
             l_ser_flag,
             l_con_sch_no_epi_restr_ser,
             l_con_is_mg_flag --BR_15_144 – Warner Payment Term - START on [28-09-2015]  by sushma
        FROM fid_contract
       WHERE con_number = i_con_number;

        ---the count checks if there are catchup licenses present inside the contract and will only check validations  then.
        SELECT COUNT (*)
          INTO l_is_catchup
          FROM fid_license,
               fid_contract,
               fid_licensee,
               fid_general
         WHERE     lic_con_number = con_number
               AND lic_status = 'A'
               --AND NVL (lic_catchup_flag, 'N') = 'Y'
               AND NVL (lic_catchup_flag, 'N') = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
               AND con_number = i_con_number
               AND gen_refno = lic_gen_refno
               AND lic_lee_number = lee_number
      ORDER BY lic_start;

      --Dev2: Pure Finance :Start:[FIN 10-Contract maintenance]_[ANUJASHINDE]_[2013/2/21]
      BEGIN
         SELECT DISTINCT pay_cur_code
           INTO pay_curr_old
           FROM fid_payment
          WHERE pay_con_number = i_con_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            pay_curr_old := '999';
      END;

      BEGIN
         SELECT CON_CURRENCY
           INTO con_curr_old
           FROM FID_CONTRACT
          WHERE con_number = i_con_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            CON_CURR_OLD := '999';
      END;

      --Dev2: Pure Finance :End
      --BR_15_144 – Warner Payment Term - START on [29-09-2015]  by sushma
      --Added ti implement the UAT Cr
      IF l_con_is_mg_flag = 'Y' AND i_con_mg_flag = 'N'
      THEN
         SELECT COUNT (1)
           INTO l_lic_count
           FROM fid_license
          WHERE lic_con_number = i_con_number
                AND NVL (lic_min_subs_flag, 'N') = 'Y';

         IF l_lic_count = 0
         THEN
            SELECT COUNT (1)
              INTO l_con_mem_cnt
              FROM sak_memo a, sak_memo_item, sak_allocation_detail
             WHERE     mem_id = mei_mem_id
                   AND mei_id = ald_mei_id
                   AND mem_con_number = i_con_number
                   AND mem_status != 'EXECUTED'
                   AND (NVL (ALD_MIN_GUA_FLAG, 'N') = 'Y'
                        OR EXISTS
                              (SELECT 1
                                 FROM x_dm_mg_pay_plan
                                WHERE dmgp_dm_number = mem_id));

            IF l_con_mem_cnt > 0
            THEN
               SELECT concat_column (mem_id)
                 INTO l_con_mem_list
                 FROM (SELECT DISTINCT (mem_id)
                         FROM sak_memo a,
                              sak_memo_item,
                              sak_allocation_detail
                        WHERE     mem_id = mei_mem_id
                              AND mei_id = ald_mei_id
                              AND mem_con_number = i_con_number
                              AND mem_status != 'EXECUTED'
                              AND (NVL (ALD_MIN_GUA_FLAG, 'N') = 'Y'
                                   OR EXISTS
                                         (SELECT 1
                                            FROM x_dm_mg_pay_plan
                                           WHERE dmgp_dm_number = mem_id)));

               raise_application_error (
                  -20205,
                     'Deals '
                  || l_con_mem_list
                  || ' has MG related info.Could not update.');
            END IF;
         ELSE
            RAISE_application_error (
               -20205,
               'MG licenses are present for the contract. Cannot Update');
         END IF;
      END IF;

      IF l_con_is_mg_flag = 'N' AND i_con_mg_flag = 'Y'
      THEN
         SELECT COUNT (1)
           INTO l_lic_count
           FROM fid_license
          WHERE     lic_con_number = i_con_number
                AND NVL (lic_min_subs_flag, 'N') = 'N'
                AND NVL (lic_catchup_flag, 'N') = 'N';

         IF l_lic_count > 0
         THEN
            RAISE_application_error (
               -20205,
               'Non-MG licenses are present for the contract. Cannot Update');
         END IF;
      END IF;

      IF l_is_catchup > 0
      THEN
         /*  select lic_start, lic_end, lic_number
           into lnr_lic_strt,lnr_lic_end,lnr_lic_number
           from
           (SELECT lic_start, lic_end, lic_number, lic_budget_code
           FROM fid_license,
           fid_contract,
           fid_licensee,
           fid_general
           WHERE lic_con_number = con_number
           AND lic_status = 'A'
           AND NVL (lic_catchup_flag, 'N') = 'N'
           AND con_number = i_con_number
           AND gen_refno = lic_gen_refno
           AND lic_lee_number = lee_number
           --and con_lee_number=lee_number
           ORDER BY lic_start)
           where rownum < 2; */

         ---- the two checks will check if the Schedule after Premiere broadcast on first linear channel is changed from uncheck to check
         ---and will throw error if Max VP is not equal to 1 for any of the license
         IF (                               /*l_prem_lnr_start_fea = 'N' AND*/
             i_c_sch_after_prem_linr_fea = 'Y')
         THEN
            FOR cur_lea IN catchup_lic_fea
            LOOP
               SELECT COUNT (*)
                 INTO l_sch_exist_fea
                 FROM x_cp_play_list
                WHERE plt_lic_number IN (cur_lea.lic_number);

               IF l_sch_exist_fea > 0
               THEN
                  CONTINUE;
               END IF;
            END LOOP;

            IF l_sch_exist_fea > 0
            THEN
               BEGIN
                  FOR i
                     IN (  SELECT lic_start,
                                  lic_end,
                                  lic_number,
                                  lic_budget_code,
                                  lic_period_tba,
                                  lee_region_id,
                                  gen_refno,
                                  lic_max_viewing_period
                             FROM fid_license,
                                  fid_contract,
                                  fid_licensee,
                                  fid_general
                            WHERE lic_con_number = con_number
                                  AND lic_status = 'A'
                                  --AND NVL (lic_catchup_flag, 'N') = 'Y'
                                  AND NVL (lic_catchup_flag, 'N') =
                                         i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
                                  AND con_number = i_con_number
                                  AND gen_refno = lic_gen_refno
                                  AND lic_lee_number = lee_number
                                  --and lic_sch_aft_prem_linear = 'Y'
                                  AND X_FNC_GET_PROG_TYPE (lic_budget_code) <>
                                         'Y'
                         ORDER BY lic_start)
                  LOOP
                     BEGIN
                        SELECT COUNT (DISTINCT plt_sch_number)
                          INTO l_plt_sch_number
                          FROM x_cp_play_list
                         WHERE plt_lic_number = i.lic_number;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           l_plt_sch_number := 0;
                     END;

                     IF l_plt_sch_number > 1
                     THEN
                        CONTINUE;
                     END IF;
                  END LOOP;

                  IF l_plt_sch_number > 1
                  THEN
                     raise_application_error (
                        -20666,
                        'There are more than one schedule present of one or more licenses of the contract.'); --END
                  ELSE
                     FOR cur_lea IN catchup_lic_fea
                     LOOP
                        SELECT (TO_DATE (
                                   TO_CHAR (sch_fin_actual_date,
                                            'DD-MM-RRRR')
                                   || ' '
                                   || convert_time_n_c (sch_time),
                                   'DD-MM-RRRR HH24:MI:SS'))
                          INTO l_sch_time
                          FROM fid_schedule
                         WHERE sch_number IN
                                  (SELECT plt_sch_number
                                     FROM x_cp_play_list
                                    WHERE plt_lic_number = cur_lea.lic_number);

                        SELECT MIN (
                                  TO_DATE (
                                     TO_CHAR (sch_fin_actual_date,
                                              'DD-MM-RRRR')
                                     || ' '
                                     || convert_time_n_c (sch_time),
                                     'DD-MM-RRRR HH24:MI:SS'))
                          INTO l_min_sch_time
                          FROM fid_schedule
                         WHERE sch_gen_refno =
                                  (SELECT lic_gen_refno
                                     FROM fid_license
                                    WHERE lic_number = cur_lea.LIC_NUMBER);

                        IF (l_sch_time <> l_min_sch_time)
                        THEN
                           CONTINUE;
                        END IF;
                     END LOOP;

                     IF (l_sch_time <> l_min_sch_time)
                     THEN
                        raise_application_error (
                           -20555,
                           'Catchup schedule is already present wrt non-premiere schedule');
                     -- ELSE (has to add parameter to populate the license update changes confirmation;)
                     END IF;
                  END IF;
               --END LOOP;
               END;
            ELSE
               IF (l_min_vp_is_1_fea > 0)
               THEN
                  /* raise_application_error
                     (-20666,
                      'Max No. of viewing period is not 1. Schedule after Premiere broadcast on first linear channel cannot be changed to checked'
                     );*/
                  /* ACQ:CACQ:Start:Sushma K_2014/27/10  */
                  raise_application_error (
                     -20666,
                     'One or more licenses having more than one VP');    --END
               -- ELSE (has to add parameter to populate the license update changes confirmation;
               END IF;
            END IF;
         /* ACQ:CACQ:Start:Sushma K_2014/21/10  */
         /*IF (l_min_vp_is_1_fea > 1 OR l_min_vp_is_1_fea = 0)*/
         --THEN
         /*raise_application_error
            (-20666,
             'Max No. of viewing period is not 1. Schedule after Premiere broadcast on first linear channel cannot be changed to checked'
            );*/
         /* ACQ:CACQ:Start:Sushma K_2014/27/10  */
         /*raise_application_error (
            -20666,
            'One or more licenses having more than one VP');       --END
      ELSE
         BEGIN
            FOR i
               IN (  SELECT lic_start,
                            lic_end,
                            lic_number,
                            lic_budget_code,
                            lic_period_tba,
                            lee_region_id,
                            gen_refno,
                            lic_max_viewing_period
                       FROM fid_license,
                            fid_contract,
                            fid_licensee,
                            fid_general
                      WHERE     lic_con_number = con_number
                            AND lic_status = 'A'
                            AND NVL (lic_catchup_flag, 'N') = 'Y'
                            AND con_number = i_con_number
                            AND gen_refno = lic_gen_refno
                            AND lic_lee_number = lee_number
                            --and lic_sch_aft_prem_linear = 'Y'
                            AND lic_budget_code <> 'SER'
                   ORDER BY lic_start)
            LOOP
               BEGIN
                  SELECT COUNT (DISTINCT plt_sch_number)
                    INTO l_plt_sch_number
                    FROM x_cp_play_list
                   WHERE plt_lic_number = i.lic_number;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_plt_sch_number := 0;
               END;

               IF l_plt_sch_number > 1
               THEN
                  /*raise_application_error
                     (-20666,
                      ' This license is already scheduled more than 2 . Can not check Premier.'*/
         --);*/
         /* ACQ:CACQ:Start:Sushma K_2014/27/10  */
         /*raise_application_error (
            -20666,
            ' There are more than one schedule present of one or more licenses of the contract.'); --END
      ELSE
         NULL;*/
         --need to update the license for  that contract

         --Start : Commented by sushma after had a discussion with pranay on 05-nov-2014
         /*BEGIN
            SELECT bin_view_start_date, bin_sch_number,
                   bin_lic_number, bin_id,
                   bin_sch_from_time, bin_sch_end_time
              INTO l_bin_view_start_date, l_bin_sch_number,
                   l_bin_lic_number, l_bin_id,
                   l_bin_sch_from_time, l_bin_sch_end_time
              FROM (SELECT   bin_view_start_date,
                             bin_sch_number, bin_lic_number,
                             bin_id, bin_sch_from_time,
                             bin_sch_end_time
                        FROM x_cp_schedule_bin
                       WHERE bin_lic_number = i.lic_number
                    ORDER BY bin_view_start_date)
             WHERE ROWNUM < 2;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_bin_id := 0;
         END;

         IF l_bin_id > 0
         THEN
            BEGIN
               SELECT COUNT (plt_id)
                 INTO l_plt_count
                 FROM x_cp_play_list
                WHERE plt_lic_number = i.lic_number
                  AND plt_sch_number <> l_bin_sch_number;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_plt_count := 0;
            END;

            IF l_plt_count > 0
            THEN
               UPDATE x_cp_play_list
                  SET plt_sch_number = l_bin_sch_number,
                      plt_sch_start_date =
                                          l_bin_view_start_date,
                      plt_sch_end_date =
                           l_bin_view_start_date
                         + (i.lic_max_viewing_period - 1),
                      plt_sch_from_time = l_bin_sch_from_time,
                      plt_sch_end_time = l_bin_sch_end_time,
                      plt_bin_id = l_bin_id
                WHERE plt_lic_number = l_bin_lic_number;
            END IF;

            UPDATE x_cp_linear_sch_audit
               SET sca_sch_is_process = 'N'
             WHERE sca_action = 'I'
               AND sca_lic_number =
                         (SELECT sch_lic_number
                            FROM fid_schedule
                           WHERE sch_number = l_bin_sch_number)
               AND sca_sch_number <> l_bin_sch_number;

            DELETE FROM x_cp_schedule_bin
                  WHERE bin_sch_number <> l_bin_sch_number
                    AND bin_lic_number = l_bin_lic_number;

            UPDATE x_cp_schedule_bin
               SET bin_is_schedule_flag = 'Y'
             WHERE bin_sch_number = l_bin_sch_number
               AND bin_lic_number = l_bin_lic_number;
         END IF;*/
         --END
         /*END IF;
      END LOOP;
   END;
END IF;*/

         END IF;

         IF (                               /*l_prem_lnr_start_ser = 'N' AND*/
             i_c_sch_after_prem_linr_ser = 'Y')
         THEN
            FOR cur_ser IN catchup_lic_ser
            LOOP
               SELECT COUNT (*)
                 INTO l_sch_exist_ser
                 FROM x_cp_play_list
                WHERE plt_lic_number IN (cur_ser.lic_number);

               IF l_sch_exist_ser > 0
               THEN
                  --l_lic_number := cur_ser.lic_number;
                  CONTINUE;
               END IF;
            END LOOP;

            IF l_sch_exist_ser > 0
            THEN
               BEGIN
                  FOR i
                     IN (  SELECT lic_start,
                                  lic_end,
                                  lic_number,
                                  lic_budget_code
                             --lic_period_tba,
                             --lee_region_id,
                             --gen_refno,
                             --lic_max_viewing_period
                             FROM fid_license,
                                  fid_contract,
                                  fid_licensee,
                                  fid_general
                            WHERE lic_con_number = con_number
                                  AND lic_status = 'A'
                                  --AND NVL (lic_catchup_flag, 'N') = 'Y'
                                  AND NVL (lic_catchup_flag, 'N') =
                                         i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
                                  AND con_number = i_con_number
                                  AND gen_refno = lic_gen_refno
                                  AND lic_lee_number = lee_number
                                  --and lic_sch_aft_prem_linear = 'Y'
                                  AND X_FNC_GET_PROG_TYPE (lic_budget_code) =
                                         'Y'
                         ORDER BY lic_start)
                  LOOP
                     BEGIN
                        SELECT COUNT (DISTINCT plt_sch_number)
                          INTO l_plt_sch_number
                          FROM x_cp_play_list
                         WHERE plt_lic_number = i.lic_number;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           l_plt_sch_number := 0;
                     END;

                     IF l_plt_sch_number > 1
                     THEN
                        CONTINUE;
                     END IF;
                  END LOOP;

                  IF l_plt_sch_number > 1
                  THEN
                     raise_application_error (
                        -20666,
                        ' There are more than one schedule present of one or more licenses of the contract.'); --END
                  ELSE
                     FOR cur_ser IN catchup_lic_ser
                     LOOP
                        SELECT COUNT (*)
                          INTO l_sch_count_new
                          FROM fid_schedule
                         WHERE sch_number IN
                                  (SELECT plt_sch_number
                                     FROM x_cp_play_list
                                    WHERE plt_lic_number = cur_ser.lic_number);

                        IF l_sch_count_new > 0
                        THEN
                           SELECT (TO_DATE (
                                      TO_CHAR (sch_fin_actual_date,
                                               'DD-MM-RRRR')
                                      || ' '
                                      || convert_time_n_c (sch_time),
                                      'DD-MM-RRRR HH24:MI:SS'))
                             INTO l_sch_time
                             FROM fid_schedule
                            WHERE sch_number IN
                                     (SELECT plt_sch_number
                                        FROM x_cp_play_list
                                       WHERE plt_lic_number =
                                                cur_ser.lic_number);

                           SELECT MIN (
                                     TO_DATE (
                                        TO_CHAR (sch_fin_actual_date,
                                                 'DD-MM-RRRR')
                                        || ' '
                                        || convert_time_n_c (sch_time),
                                        'DD-MM-RRRR HH24:MI:SS'))
                             INTO l_min_sch_time
                             FROM fid_schedule
                            WHERE sch_gen_refno =
                                     (SELECT lic_gen_refno
                                        FROM fid_license
                                       WHERE lic_number = cur_ser.LIC_NUMBER);

                           IF (l_sch_time <> l_min_sch_time)
                           THEN
                              CONTINUE;
                           END IF;
                        END IF;
                     END LOOP;

                     IF (l_sch_time <> l_min_sch_time)
                     THEN
                        raise_application_error (
                           -20555,
                           'Catchup schedule is already present wrt non-premiere schedule');
                     -- ELSE (has to add parameter to populate the license update changes confirmation;)
                     END IF;
                  END IF;
               -- END LOOP;
               END;
            ELSE
               IF (l_min_vp_is_1_ser > 0)
               THEN
                  /* raise_application_error
                     (-20666,
                      'Max No. of viewing period is not 1. Schedule after Premiere broadcast on first linear channel cannot be changed to checked'
                     );*/
                  /* ACQ:CACQ:Start:Sushma K_2014/27/10  */
                  raise_application_error (
                     -20666,
                     'One or more licenses having more than one VP');    --END
               -- ELSE (has to add parameter to populate the license update changes confirmation;
               END IF;
            END IF;
         END IF;

         --CACQ14: Start : Added by sushma K on 13-NOV-2014 to update the sch afeter permier,sch before x days and sch x day before value
         -- opening cursor which will bring all the catchup licenses for that contract

         /*FOR cur_lea IN catchup_lic_fea
             LOOP

                UPDATE fid_license
                   SET lic_sch_aft_prem_linear =  i_c_sch_after_prem_linr_fea,
                       LIC_SCH_BEF_X_DAY = i_c_sch_x_day_before_linr_fea,
                       LIC_SCH_BEF_X_DAY_VALUE = i_c_sch_x_day_bef_linr_val_fea

                 WHERE lic_catchup_flag = 'Y'
                   AND lic_number = cur_lea.lic_number
                   and LIC_BUDGET_CODE <> 'SER' ;
          END LOOP;

          FOR cur_ser IN catchup_lic_ser
             LOOP
                UPDATE fid_license
                   SET lic_sch_aft_prem_linear =  i_c_sch_after_prem_linr_ser,
                       LIC_SCH_BEF_X_DAY = i_c_sch_x_day_before_linr_ser,
                       LIC_SCH_BEF_X_DAY_VALUE = i_c_sch_x_day_bef_linr_val_ser
                 WHERE lic_catchup_flag = 'Y'
                   AND lic_number = cur_ser.lic_number
                   and LIC_BUDGET_CODE  = 'SER' ;
          END LOOP;*/

         /*IF i_con_lic_update_fea = 'Y' --OR i_con_lic_update_x_days_fea = 'Y'
         THEN
           FOR cur_lea IN catchup_lic_fea
           LOOP

              UPDATE fid_license
                 SET lic_sch_aft_prem_linear =  i_c_sch_after_prem_linr_fea
                     --LIC_SCH_BEF_X_DAY = i_c_sch_x_day_before_linr_fea,
                     --LIC_SCH_BEF_X_DAY_VALUE = i_c_sch_x_day_bef_linr_val_fea

               WHERE lic_catchup_flag = 'Y'
                 AND lic_number = cur_lea.lic_number
                 and X_FNC_GET_PROG_TYPE(LIC_BUDGET_CODE) <> 'Y' ;
           END LOOP;
       END IF;

        IF i_con_lic_update_ser = 'Y' --OR i_con_lic_update_x_days_ser = 'Y'
        THEN
           FOR cur_ser IN catchup_lic_ser
           LOOP
              UPDATE fid_license
                 SET lic_sch_aft_prem_linear =  i_c_sch_after_prem_linr_ser
                     --LIC_SCH_BEF_X_DAY = i_c_sch_x_day_before_linr_ser,
                     --LIC_SCH_BEF_X_DAY_VALUE = i_c_sch_x_day_bef_linr_val_ser
               WHERE lic_catchup_flag = 'Y'
                 AND lic_number = cur_ser.lic_number
                 and X_FNC_GET_PROG_TYPE(LIC_BUDGET_CODE)  = 'Y' ;
           END LOOP;
          END IF;*/

         ----VALIDATION for schedule before x days before playout on linear(fea) for contract maintenance
         --Catchup CACQ:14 [SHANTANU A.]_28-oct-2014

         --dbms_output.put_line(o_sch_present_past);
         --o_sch_present_past := 'Y';
         IF (i_c_sch_x_day_before_linr_fea <> l_fea_flag)
            OR (i_c_sch_x_day_bef_linr_val_fea <> l_fea_lnr_x)
         THEN
            IF (i_c_sch_x_day_before_linr_fea = 'Y')
            THEN
               --No of days decreased check?
               IF l_fea_lnr_x > i_c_sch_x_day_bef_linr_val_fea
               THEN
                  FOR cur_lea IN catchup_lic_fea
                  LOOP
                     SELECT COUNT (*)
                       INTO l_cp_lic_sch
                       FROM x_cp_play_list
                      WHERE plt_lic_number IN (cur_lea.lic_number);

                     IF l_cp_lic_sch > 0
                     THEN
                        CONTINUE;
                     END IF;
                  END LOOP;

                  IF l_cp_lic_sch > 0
                  THEN
                     FOR i
                        IN (  SELECT lic_start,
                                     lic_end,
                                     lic_number,
                                     lic_budget_code
                                FROM fid_license,
                                     fid_contract,
                                     fid_licensee,
                                     fid_general
                               WHERE lic_con_number = con_number
                                     AND lic_status = 'A'
                                     --AND NVL (lic_catchup_flag, 'N') = 'Y'
                                     AND NVL (lic_catchup_flag, 'N') =
                                            i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
                                     AND con_number = i_con_number
                                     AND gen_refno = lic_gen_refno
                                     AND lic_lee_number = lee_number
                                     AND X_FNC_GET_PROG_TYPE (lic_budget_code) <>
                                            'Y'
                            -- and con_lee_number=lee_number
                            ORDER BY lic_start)
                     LOOP
                        SELECT MIN (sch_date)
                          INTO l_sch_date
                          FROM fid_schedule
                         WHERE sch_number IN
                                  (SELECT plt_sch_number
                                     FROM x_cp_play_list
                                    WHERE plt_lic_number = i.lic_number);

                        SELECT COUNT (*)
                          INTO l_sch_count
                          FROM fid_schedule, x_cp_play_list
                         WHERE plt_sch_number = sch_number
                               AND sch_number IN
                                      (SELECT plt_sch_number
                                         FROM x_cp_play_list
                                        WHERE plt_lic_number = i.lic_number)
                               AND plt_lic_number = i.lic_number
                               AND (TO_DATE (plt_sch_start_date,
                                             'dd-mm-rrrr')) <
                                      TRUNC (
                                         TO_DATE (l_sch_date, 'dd-mm-rrrr'))
                                      - i_c_sch_x_day_bef_linr_val_fea;

                        --AND plt_sch_start_date > SYSDATE;
                        IF l_sch_count > 0
                        THEN
                           CONTINUE;
                        END IF;
                     END LOOP;

                     IF l_sch_count > 0
                     THEN
                        FOR cur_lea IN catchup_lic_fea
                        LOOP
                           SELECT COUNT (*)
                             INTO l_sch_start
                             FROM x_cp_play_list
                            WHERE plt_lic_number IN (cur_lea.lic_number)
                                  AND plt_sch_start_date > SYSDATE;

                           IF l_sch_start > 0
                           THEN
                              CONTINUE;
                           END IF;
                        END LOOP;

                        IF l_sch_start > 0
                        THEN
                           --o_sch_present_past := 'Y';
                           raise_application_error (
                              -20603,
                              'Delete the schedules present in the future before proceeding');
                        ELSE
                           o_sch_present_past := 'N';
                        END IF;
                     ELSE
                        o_sch_exist_bef_x_days_fea := 'N';
                     --ROLLBACK;
                     END IF;
                  ELSE
                     o_sch_exist_fea := 'N';
                  --ROLLBACK;
                  END IF;
               END IF;
            -- ADD for Uncheck schedule 'X' days before linear schedule CACQ: 14 [Shantanu_Aggarwal]
            ELSE
               --dbms_output.put_line(o_sch_present_past);
               --o_sch_present_past := 'Y';
               FOR cur_lea IN catchup_lic_fea
               LOOP
                  SELECT MIN (sch_date)
                    INTO l_sch_date
                    FROM fid_schedule
                   WHERE sch_number IN
                            (SELECT plt_sch_number
                               FROM x_cp_play_list
                              WHERE plt_lic_number = cur_lea.lic_number);

                  SELECT COUNT (*)
                    INTO l_sch_count
                    FROM x_cp_play_list, fid_schedule
                   WHERE plt_sch_number = sch_number
                         AND sch_number IN
                                (SELECT plt_sch_number
                                   FROM x_cp_play_list
                                  WHERE plt_lic_number = cur_lea.lic_number)
                         AND plt_lic_number = cur_lea.lic_number
                         AND plt_sch_start_date < l_sch_date;

                  --AND plt_sch_start_date > SYSDATE;
                  IF l_sch_count > 0
                  THEN
                     CONTINUE;
                  END IF;
               END LOOP;

               IF l_sch_count > 0
               THEN
                  FOR cur_lea IN catchup_lic_fea
                  LOOP
                     SELECT COUNT (*)
                       INTO l_sch_start
                       FROM x_cp_play_list
                      WHERE plt_lic_number IN (cur_lea.lic_number)
                            AND plt_sch_start_date > SYSDATE;

                     IF l_sch_start > 0
                     THEN
                        CONTINUE;
                     END IF;
                  END LOOP;

                  IF l_sch_start > 0
                  THEN
                     --o_sch_present_past := 'Y';
                     raise_application_error (
                        -20654,
                        'Delete the schedules present in future before procceding');
                  ELSE
                     o_sch_present_past := 'N';
                  END IF;
               END IF;
            END IF;
         END IF;

         ----VALIDATION for schedule x days before playout on linear(ser) for contract maintenance
         --Catchup CACQ:14 [SHANTANU A.]_28-oct-2014
         /*SELECT con_sch_x_day_before_linr_ser
           INTO l_ser_flag
           FROM fid_contract
          WHERE con_number = i_con_number;*/

         --o_sch_present_past := 'Y';
         --dbms_output.put_line(o_sch_present_past);
         IF (i_c_sch_x_day_before_linr_ser <> l_ser_flag)
            OR (i_c_sch_x_day_bef_linr_val_ser <> l_ser_lnr_x)
         THEN
            IF (i_c_sch_x_day_before_linr_ser = 'Y')
            THEN
               --No of days decreased?
               IF l_ser_lnr_x > i_c_sch_x_day_bef_linr_val_ser
               THEN
                  FOR cur_ser IN catchup_lic_ser
                  LOOP
                     SELECT COUNT (*)
                       INTO l_cp_lic_sch
                       FROM x_cp_play_list
                      WHERE plt_lic_number = cur_ser.lic_number;

                     IF l_cp_lic_sch > 0
                     THEN
                        CONTINUE;
                     END IF;
                  END LOOP;

                  IF l_cp_lic_sch > 0
                  THEN
                     FOR i
                        IN (  SELECT lic_start,
                                     lic_end,
                                     lic_number,
                                     lic_budget_code
                                FROM fid_license,
                                     fid_contract,
                                     fid_licensee,
                                     fid_general
                               WHERE lic_con_number = con_number
                                     AND lic_status = 'A'
                                     --AND NVL (lic_catchup_flag, 'N') = 'Y'
                                     AND NVL (lic_catchup_flag, 'N') =
                                            i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
                                     AND con_number = i_con_number
                                     AND gen_refno = lic_gen_refno
                                     AND lic_lee_number = lee_number
                                     AND X_FNC_GET_PROG_TYPE (lic_budget_code) =
                                            'Y'
                            -- and con_lee_number=lee_number
                            ORDER BY lic_start)
                     LOOP
                        SELECT MIN (sch_date)
                          INTO l_sch_date
                          FROM fid_schedule
                         WHERE sch_number IN
                                  (SELECT plt_sch_number
                                     FROM x_cp_play_list
                                    WHERE plt_lic_number = i.lic_number);

                        SELECT COUNT (*)
                          INTO l_sch_count
                          FROM fid_schedule, x_cp_play_list
                         WHERE plt_sch_number = sch_number
                               AND sch_number IN
                                      (SELECT plt_sch_number
                                         FROM x_cp_play_list
                                        WHERE plt_lic_number = i.lic_number)
                               AND plt_lic_number = i.lic_number
                               AND (TO_DATE (plt_sch_start_date,
                                             'dd-mm-rrrr')) <
                                      TRUNC (
                                         TO_DATE (l_sch_date, 'dd-mm-rrrr'))
                                      - i_c_sch_x_day_bef_linr_val_ser;

                        IF l_sch_count > 0
                        THEN
                           CONTINUE;
                        END IF;
                     END LOOP;

                     IF l_sch_count > 0
                     THEN
                        FOR cur_ser IN catchup_lic_ser
                        LOOP
                           SELECT COUNT (*)
                             INTO l_sch_start_ser
                             FROM x_cp_play_list
                            WHERE plt_lic_number = cur_ser.lic_number
                                  AND plt_sch_start_date > SYSDATE;

                           IF l_sch_start_ser > 0
                           THEN
                              CONTINUE;
                           END IF;
                        END LOOP;

                        IF l_sch_start_ser > 0
                        THEN
                           o_sch_present_past := 'Y';
                           raise_application_error (
                              -20603,
                              'Delete the schedules present in the future before proceeding');
                        ELSE
                           o_sch_present_past := 'N';
                        END IF;
                     ELSE
                        o_sch_exist_bef_x_days_ser := 'N';
                        ROLLBACK;
                     END IF;
                  ELSE
                     o_sch_exist_ser := 'N';
                     ROLLBACK;
                  END IF;
               END IF;
            -- ADD for Uncheck schedule 'X' days before linear schedule CACQ: 14 [Shantanu_Aggarwal]
            ELSE
               FOR cur_ser IN catchup_lic_ser
               LOOP
                  SELECT MIN (sch_date)
                    INTO l_sch_date
                    FROM fid_schedule
                   WHERE sch_number IN
                            (SELECT plt_sch_number
                               FROM x_cp_play_list
                              WHERE plt_lic_number = cur_ser.lic_number);

                  SELECT COUNT (*)
                    INTO l_sch_count
                    FROM x_cp_play_list, fid_schedule
                   WHERE plt_sch_number = sch_number
                         AND sch_number IN
                                (SELECT plt_sch_number
                                   FROM x_cp_play_list
                                  WHERE plt_lic_number = cur_ser.lic_number)
                         AND plt_lic_number = cur_ser.lic_number
                         AND plt_sch_start_date < l_sch_date;

                  --AND plt_sch_start_date > SYSDATE;
                  IF l_sch_count > 0
                  THEN
                     CONTINUE;
                  END IF;
               END LOOP;

               IF l_sch_count > 0
               THEN
                  FOR cur_ser IN catchup_lic_ser
                  LOOP
                     SELECT COUNT (*)
                       INTO l_sch_start_ser
                       FROM x_cp_play_list
                      WHERE plt_lic_number = cur_ser.lic_number
                            AND plt_sch_start_date > SYSDATE;

                     IF l_sch_start_ser > 0
                     THEN
                        CONTINUE;
                     END IF;
                  END LOOP;

                  IF l_sch_start_ser > 0
                  THEN
                     raise_application_error (
                        -20654,
                        'Delete the schedules present in future before procceding');
                  ELSE
                     o_sch_present_past := 'N';
                  END IF;
               END IF;
            END IF;
         END IF;

         IF o_sch_exist_fea = 'Y' AND o_sch_exist_bef_x_days_fea = 'Y'
         THEN
            IF i_con_lic_update_x_days_fea = 'Y'
               AND i_con_lic_update_fea = 'Y'
            THEN
               FOR cur_lea IN catchup_lic_fea
               LOOP
                  UPDATE fid_license
                     SET lic_sch_aft_prem_linear = i_c_sch_after_prem_linr_fea,
                         LIC_SCH_BEF_X_DAY = i_c_sch_x_day_before_linr_fea,
                         LIC_SCH_BEF_X_DAY_VALUE =
                            i_c_sch_x_day_bef_linr_val_fea
                   WHERE     lic_catchup_flag = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
                         AND lic_number = cur_lea.lic_number
                         AND X_FNC_GET_PROG_TYPE (LIC_BUDGET_CODE) <> 'Y';
               END LOOP;
            END IF;
         END IF;

         IF o_sch_exist_ser = 'Y' AND o_sch_exist_bef_x_days_ser = 'Y'
         THEN
            IF i_con_lic_update_x_days_ser = 'Y'
               AND i_con_lic_update_ser = 'Y'
            THEN
               FOR cur_ser IN catchup_lic_ser
               LOOP
                  UPDATE fid_license
                     SET lic_sch_aft_prem_linear = i_c_sch_after_prem_linr_ser,
                         LIC_SCH_BEF_X_DAY = i_c_sch_x_day_before_linr_ser,
                         LIC_SCH_BEF_X_DAY_VALUE =
                            i_c_sch_x_day_bef_linr_val_ser
                   WHERE                              --lic_catchup_flag = 'Y'
                        lic_catchup_flag = i_c_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
                         AND lic_number = cur_ser.lic_number
                         AND X_FNC_GET_PROG_TYPE (LIC_BUDGET_CODE) = 'Y';
               END LOOP;
            END IF;
         END IF;

         -- CATCHUP END_[Shantanu Aggarwal]
         -- opening cursor which will bring all the catchup licenses for that contract
         FOR cur_values IN catchup_lic
         LOOP
            /*UPDATE fid_license
               SET lic_sch_aft_prem_linear =
                      DECODE (cur_values.lic_budget_code,
                              'SER', i_c_sch_after_prem_linr_ser,
                              i_c_sch_after_prem_linr_fea
                             ),
                  -- Catchup:CACQ:14 updation at license level_[05-nov-2014]_[SHANTANU A.]
                   LIC_SCH_BEF_X_DAY =
                      DECODE(cur_values.lic_budget_code,
                              'SER', l_ser_flag,
                              l_fea_flag
                             ),
                   LIC_SCH_BEF_X_DAY_VALUE=
                      DECODE(cur_values.lic_budget_code,
                              'SER', i_c_sch_x_day_bef_linr_val_ser,
                              i_c_sch_x_day_bef_linr_val_fea
                             )
                 -- Catchup:CACQ:14 updation at license level_[05-nov-2014]_END
             WHERE lic_catchup_flag = 'Y'
               AND lic_number = cur_values.lic_number;*/

            BEGIN
               SELECT lic_start,
                      lic_end,
                      lic_number,
                      lic_period_tba
                 INTO lnr_lic_strt,
                      lnr_lic_end,
                      lnr_lic_number,
                      lnr_lic_tba
                 FROM (  SELECT lic_start,
                                lic_end,
                                lic_number,
                                lic_period_tba
                           FROM fid_license, fid_licensee
                          WHERE     lic_lee_number = lee_number
                                AND lic_status = 'A'
                                AND lee_region_id = cur_values.lee_region_id
                                AND lic_con_number = i_con_number
                                AND lic_gen_refno = cur_values.gen_refno
                                AND NVL (lic_catchup_flag, 'N') = 'N'
                                AND lic_lee_number <> 319
                       ORDER BY lic_start)
                WHERE ROWNUM < 2;
            EXCEPTION
               WHEN OTHERS
               THEN
                  lnr_lic_number := 0;
            END;

            ----VALIDATION for Not allwd after x no of days field
            IF NVL (l_after_start, 0) <>
                  NVL (i_c_not_allow_aft_x_start_lic, 0)
               AND lnr_lic_tba <> 'Y'
            THEN
               IF (cur_values.lic_start <
                      (lnr_lic_strt + NVL (i_c_not_allow_aft_x_start_lic, 0)))
                  AND cur_values.lic_period_tba <> 'Y'
               THEN
                  raise_application_error (
                     -20666,
                     'The license ' || cur_values.lic_number
                     || ' is already created for this contract which violates the start date. Cannot Update');
               END IF;
            END IF;

            ----VALIDATION for Not allwd after x no of days field
            IF NVL (l_before_start, 0) <>
                  NVL (i_c_not_allow_bef_x_end_lic_dt, 0)
               AND lnr_lic_tba <> 'Y'
            THEN
               IF (cur_values.lic_end >
                      (lnr_lic_end - NVL (i_c_not_allow_bef_x_end_lic_dt, 0)))
                  AND cur_values.lic_period_tba <> 'Y'
               THEN
                  raise_application_error (
                     -20666,
                     'The license ' || cur_values.lic_number
                     || ' is already created for this contract which violates the end date. Cannot Update');
               END IF;
            END IF;
         END LOOP;

         --schedule with x days from playout on linear(fea)  should not be greater than the min MAX VP
         IF (NVL (i_c_sch_within_x_frm_ply_fea, 0) > l_min_vp_fea)
         THEN
            raise_application_error (
               -20666,
               'The no. of days under Features, for the field Schedule within X days from playout on linear cannot be greater than the viewing period of Catch Up license. Cannot Update');
         END IF;

         ---OPENING CURSOR WHICH WILL BRING THE CATCHUP LICENSES FOR ALL THE FEA TYPE FOR THIS CONTRACT
         FOR cur_lea IN catchup_lic_fea
         LOOP
            ----VALIDATION for schedule with x days from playout on linear(fea)
            IF l_fea_x <> NVL (i_c_sch_within_x_frm_ply_fea, 0)
            THEN
               FOR i
                  IN (SELECT plt_sch_start_date, sch_date
                        FROM x_cp_play_list, fid_schedule
                       WHERE plt_sch_number = sch_number
                             AND plt_lic_number = cur_lea.lic_number)
               LOOP
                  IF (i.plt_sch_start_date - i.sch_date) >
                        NVL (i_c_sch_within_x_frm_ply_fea, 0)
                  THEN
                     raise_application_error (
                        -20666,
                        'For programme type Features, the associated license  '
                        || cur_lea.lic_number
                        || ' has been scheduled. The field Schedule X days before playout on linear cannot be updated.');
                  END IF;
               END LOOP;
            /*
            for i in (select sch_date from fid_schedule where sch_number in (select PLT_SCH_NUMBER from X_CP_PLAY_LIST where PLT_LIC_NUMBER = cur_lea.lic_number))
            loop
                for j in (select PLT_SCH_START_DATE from X_CP_PLAY_LIST where PLT_LIC_NUMBER = cur_lea.lic_number)
                loop
                    if j.PLT_SCH_START_DATE  between (i.sch_date ) and (i.sch_date + nvl(i_c_sch_within_x_frm_ply_fea,0))
                    then
                      null;
                    else
                        raise_application_error(-20666,'Based on linear fea type The associated title '||cur_lea.lic_number ||'  is scheduled beyond the updated Schedule Dates.Cannot Update' );
                    end if;
                end loop;
            end loop;
            */
            END IF;
         ----VALIDATION for schedule before x days from playout on linear(fea)
         /*IF l_fea_lnr_x <> NVL (i_c_sch_x_day_bef_linr_val_fea, 0)
         THEN
            ---caluclating the linear schedule date of the catchup license
            FOR i
               IN (SELECT plt_sch_start_date, sch_date
                     FROM x_cp_play_list, fid_schedule
                    WHERE plt_sch_number = sch_number
                          AND plt_lic_number = cur_lea.lic_number)
            LOOP
               IF (i.sch_date - i.plt_sch_start_date) >
                     NVL (i_c_sch_x_day_bef_linr_val_fea, 0)
               THEN
                  raise_application_error (
                     -20666,
                     'For programme type Features, the associated license  '
                     || cur_lea.lic_number
                     || ' has been scheduled.
                       The field Schedule X days before playout on linear cannot be updated.');
               END IF;
            END LOOP;

            FOR t
               IN (SELECT bin_id, bin_view_start_date, sch_date
                     FROM x_cp_schedule_bin, fid_schedule
                    WHERE bin_sch_number = sch_number
                          AND bin_lic_number = cur_lea.lic_number)
            LOOP
               UPDATE x_cp_schedule_bin
                  SET bin_view_start_date =
                         t.sch_date
                         - NVL (i_c_sch_x_day_bef_linr_val_fea, 0)
                WHERE bin_id = t.bin_id;
            END LOOP;
         /* for i in (select sch_date from fid_schedule where sch_number in (select PLT_SCH_NUMBER from X_CP_PLAY_LIST where PLT_LIC_NUMBER = cur_lea.lic_number))
       loop
 ---checking all the playlist entries of the catchup license
           for j in (select PLT_SCH_START_DATE from X_CP_PLAY_LIST where PLT_LIC_NUMBER = cur_lea.lic_number)
           loop
               if j.PLT_SCH_START_DATE between (i.sch_date - nvl(i_c_sch_x_day_bef_linr_val_fea,0)) and (i.sch_date )
               then
                   raise_application_error(-20666,'Based on linear fea type x The associated title '||cur_lea.lic_number ||'  is scheduled beyond the updated Schedule Dates.Cannot Update' );

               else
                   for t in (select BIN_ID,BIN_VIEW_start_DATE from x_cp_schedule_bin where BIN_LIC_NUMBER=cur_lea.lic_number )
                   loop
                       update x_cp_schedule_bin SET BIN_VIEW_start_DATE = i.sch_date - nvl(i_c_sch_x_day_bef_linr_val_fea,0)
                       WHERE BIN_ID=t.BIN_ID;
                   END LOOP;
               end if;
           end loop;
       end loop; */

         END LOOP;

         --schedule with x days from playout on linear(ser)  should not be greater than the min MAX VP
         IF (NVL (i_c_sch_within_x_frm_ply_ser, 0) > l_min_vp_ser)
         THEN
            raise_application_error (
               -20666,
               'The no. of days under Series, for the field Schedule within X days from playout on linear cannot be greater than the viewing period of Catch Up license. Cannot Update');
         END IF;

         ---OPENING CURSOR WHICH WILL BRING THE CATCHUP LICENSES FOR ALL THE SER TYPE FOR THIS CONTRACT
         FOR cur_ser IN catchup_lic_ser
         LOOP
            ----VALIDATION for schedule with x days from playout on linear(SERIES)
            IF NVL (l_series_x, 0) <> NVL (i_c_sch_within_x_frm_ply_ser, 0)
            THEN
               FOR i
                  IN (SELECT plt_sch_start_date, sch_date
                        FROM x_cp_play_list, fid_schedule
                       WHERE plt_sch_number = sch_number
                             AND plt_lic_number = cur_ser.lic_number)
               LOOP
                  IF (i.plt_sch_start_date - i.sch_date) >
                        NVL (i_c_sch_within_x_frm_ply_ser, 0)
                  THEN
                     raise_application_error (
                        -20666,
                        'For programme type Series, the associated license  '
                        || cur_ser.lic_number
                        || ' is scheduled beyond the updated Schedule Dates. Cannot Update');
                  END IF;
               END LOOP;
            END IF;
         ----VALIDATION for schedule with x days before playout on linear(ser)
         /*IF NVL (l_ser_lnr_x, 0) <>
               NVL (i_c_sch_x_day_bef_linr_val_ser, 0)
         THEN
            FOR i
               IN (SELECT plt_sch_start_date, sch_date
                     FROM x_cp_play_list, fid_schedule
                    WHERE plt_sch_number = sch_number
                          AND plt_lic_number = cur_ser.lic_number)
            LOOP
               IF (i.sch_date - i.plt_sch_start_date) >
                     NVL (i_c_sch_x_day_bef_linr_val_ser, 0)
               THEN
                  raise_application_error (
                     -20666,
                     'For programme type Series, the associated license  '
                     || cur_ser.lic_number
                     || ' has been scheduled.
                       The field Schedule X days before playout on linear cannot be updated.');
               END IF;
            END LOOP;

            FOR t
               IN (SELECT bin_id, bin_view_start_date, sch_date
                     FROM x_cp_schedule_bin, fid_schedule
                    WHERE bin_sch_number = sch_number
                          AND bin_lic_number = cur_ser.lic_number)
            LOOP
               UPDATE x_cp_schedule_bin
                  SET bin_view_start_date =
                         t.sch_date
                         - NVL (i_c_sch_x_day_bef_linr_val_ser, 0)
                WHERE bin_id = t.bin_id;
            END LOOP;*/
         /*
         for i in (select sch_date from fid_schedule where sch_number in (select PLT_SCH_NUMBER from X_CP_PLAY_LIST where PLT_LIC_NUMBER =cur_ser.lic_number))
         loop
           for j in (select PLT_SCH_START_DATE from X_CP_PLAY_LIST where PLT_LIC_NUMBER =cur_ser.lic_number)
           loop
             if j.PLT_SCH_START_DATE between (i.sch_date - nvl(i_c_sch_x_day_bef_linr_val_ser,0)) and (i.sch_date )
             then
                 raise_application_error(-20666,'Based on linear ser type x The associated title '||cur_ser.lic_number ||'  is scheduled beyond the updated Schedule Dates.Cannot Update' );

             ELSE
                 for t in (select BIN_ID,BIN_VIEW_start_DATE from x_cp_schedule_bin where BIN_LIC_NUMBER=cur_ser.lic_number )
                 loop
                      update x_cp_schedule_bin SET BIN_VIEW_start_DATE = i.sch_date - nvl(i_c_sch_x_day_bef_linr_val_ser,0)
                      WHERE BIN_ID=t.BIN_ID;
                 END LOOP;
             end if;
           end loop;
         end loop;
         */
         --END IF;
         END LOOP;

         IF i_c_sch_no_epi_restr_ser_seson < l_con_sch_no_epi_restr_ser
         THEN
            SELECT MAX (l_lic_count)
              INTO l_ser_schedule_cnt
              FROM (  SELECT COUNT (lic_number) l_lic_count,
                             gen_refno,
                             plt_sch_start_date
                        FROM fid_license, fid_general, x_cp_play_list
                       WHERE     lic_gen_refno = gen_refno
                             AND lic_number = plt_lic_number
                             AND lic_con_number = 59916
                             AND lic_budget_code = 'SER'
                    GROUP BY gen_refno, plt_sch_start_date);

            IF l_ser_schedule_cnt > i_c_sch_no_epi_restr_ser_seson
            THEN
               raise_application_error (
                  -20666,
                  'Max No of Episode is greater than "Number of Episode Restriction" value. Cannot Update');
            END IF;
         END IF;
      --CACQ14:Start:SUSHMA K on 28-10-2014
      /* select MDP_MAP_DEV_CODE,MDP_MAP_PLATM_CODE
          INTO l_med_device,l_med_platm_code
         from x_cp_media_dev_platm_map
         where MDP_MAP_ID = i_mpdc_dev_platm_id;

    --Validation for rights on device feild For Fea(Features)
      select distinct CON_RIGHTS_ON_DEVICE INTO l_rights_on_device_fea
       from X_CP_CON_MEDPLATMDEVCOMPAT_MAP
      where CON_CONTRACT_NUMBER = i_con_number
      and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
      and   CON_IS_FEA_SER = 'FEA';

    IF i_rights_on_device_fea = 'Y'  and l_rights_on_device_fea = 'N'
    THEN
      for i in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_fea,',')) )
      LOOP
           UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
              set CON_RIGHTS_ON_DEVICE = i_rights_on_device_fea,
                  CON_IS_COMP_RIGHTS =  i.column_value,
                  CON_MPDC_MODIFIED_BY = i_entryoper,
                  CON_MPDC_MODIFIED_ON = sysdate,
                  CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
           where CON_CONTRACT_NUMBER = i_con_number
           and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
           and   CON_IS_FEA_SER  = 'FEA';

           --NEED TO UPDATE THE RESPECTIVE CATCH UP LICNESE OF THE CONTRACT  (Check the rights on device on all the catch up licenses of that contract)
       end loop;

    elsiF i_rights_on_device_fea = 'N'  and l_rights_on_device_fea = 'Y'
    THEN
     -- Need to check wheather any schedule present for catch up license of that contract in open\bugeted month
       IF l_sch_count > 0
       THEN
        raise_application_error(-20666,'Catch Up license of this contract is scheduled on this media device.So cannot uncheck.');
       else
          UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
            set CON_RIGHTS_ON_DEVICE = i_rights_on_device_fea,
                CON_IS_COMP_RIGHTS = 'N',
                CON_MPDC_MODIFIED_BY = i_entryoper,
                CON_MPDC_MODIFIED_ON = sysdate,
                CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
         where CON_CONTRACT_NUMBER = i_con_number
          and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
         and   CON_IS_FEA_SER  = 'FEA' ;

         --NEED TO UPDATE THE RESPECTIVE CATCH UP LICNESE OF THE CONTRACT  (un Check the rights on device and device rights on all the catch up licenses of that contract)
       END IF;

    END IF;

     --Validation for rights on device feild For SER(Series)
    select CON_RIGHTS_ON_DEVICE INTO l_rights_on_device_ser
       from X_CP_CON_MEDPLATMDEVCOMPAT_MAP
      where CON_CONTRACT_NUMBER = i_con_number
      and   CON_IS_FEA_SER = 'SER';

   IF i_rights_on_device_ser = 'Y'  and l_rights_on_device_ser = 'N'
   THEN
      for i in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_ser,',')) )
      LOOP
           UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
              set CON_RIGHTS_ON_DEVICE = i_rights_on_device_ser,
                  CON_IS_COMP_RIGHTS =  i.column_value,
                  CON_MPDC_MODIFIED_BY = i_entryoper,
                  CON_MPDC_MODIFIED_ON = sysdate,
                  CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
           where CON_CONTRACT_NUMBER = i_con_number
            and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
           and   CON_IS_FEA_SER  = 'SER';

            --NEED TO UPDATE THE RESPECTIVE CATCH UP LICNESE OF THE CONTRACT  (Check the rights on device on all the catch up licenses of that contract)
       end loop;

   elsiF i_rights_on_device_ser = 'N'  and l_rights_on_device_ser = 'Y'
   THEN
     -- Need to check wheather any schedule present for catch up license of that contract in open\bugeted month
       IF l_sch_count > 0
       THEN
        raise_application_error(-20666,'Catch Up license of this contract is scheduled on this media device.So cannot uncheck.');
       else
          UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
            set CON_RIGHTS_ON_DEVICE = i_rights_on_device_ser,
                CON_IS_COMP_RIGHTS = 'N',
                CON_MPDC_MODIFIED_BY = i_entryoper,
                CON_MPDC_MODIFIED_ON = sysdate,
                CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
         where CON_CONTRACT_NUMBER = i_con_number
          and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
         and   CON_IS_FEA_SER  = 'SER' ;

          --NEED TO UPDATE THE RESPECTIVE CATCH UP LICNESE OF THE CONTRACT  (un Check the rights on device and device rights on all the catch up licenses of that contract)
       END IF;

   END IF;

   --Validation for device on rights fiels for FEA
  select wm_concat(con_is_comp_rights) INTO  l_device_rights_fea
    from X_CP_CON_MEDPLATMDEVCOMPAT_MAP
    where con_contract_number = i_con_number
    and con_is_fea_ser = 'FEA'
    and con_mpdc_dev_platm_id = i_mpdc_dev_platm_id;

  FOR i in (( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(l_device_rights_fea,',')) ))
  LOOP
    for j in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_FEA,',')) )
     LOOP
      IF i.column_value = 'N' and  j.column_value = 'Y'
       THEN
          UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
            set CON_RIGHTS_ON_DEVICE = i_rights_on_device_FEA,
                CON_IS_COMP_RIGHTS = j.column_value,
                CON_MPDC_MODIFIED_BY = i_entryoper,
                CON_MPDC_MODIFIED_ON = sysdate,
                CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
         where CON_CONTRACT_NUMBER = i_con_number
          and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
         and   CON_IS_FEA_SER  = 'FEA' ;

       ELSif i.column_value = 'Y' and  j.column_value = 'N'
       THEN
       --Need to check wheather the any schedule present for license of that contract
        IF l_sch_count > 0
        THEN
          raise_application_error(-20666,'Catch Up license of this contract is scheduled on '|| l_med_device ||'.So cannot uncheck.');
        else
         o_sch_count := 0;
         --NEED TO UNCHECK THE DEVICE RIGNHTS ON ALL CATCH UP LICENSES OF THAT CONTRACT WHEN EVER USER CLICKS ON YES IN POP UP WHICH IS APPEAR ON SCREEN IN FRONT END
         END IF;
       END IF;
    END LOOP;
  END LOOP;


   --Validation for device on rights fielD for ser
  select wm_concat(con_is_comp_rights) INTO  l_device_rights_ser
    from X_CP_CON_MEDPLATMDEVCOMPAT_MAP
    where con_contract_number = i_con_number
    and con_is_fea_ser = 'SER'
    and con_mpdc_dev_platm_id = i_mpdc_dev_platm_id;

  FOR i in (( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(l_device_rights_SER,',')) ))
  LOOP
    for j in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_ser,',')) )
     LOOP
      IF i.column_value = 'N' and  j.column_value = 'Y'
       THEN
          UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
            set CON_RIGHTS_ON_DEVICE = i_rights_on_device_ser,
                CON_IS_COMP_RIGHTS = j.column_value,
                CON_MPDC_MODIFIED_BY = i_entryoper,
                CON_MPDC_MODIFIED_ON = sysdate,
                CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
         where CON_CONTRACT_NUMBER = i_con_number
          and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
         and   CON_IS_FEA_SER  = 'FEA' ;

       ELSif i.column_value = 'Y' and  j.column_value = 'N'
       THEN
       --Need to check wheather the any schedule present for license of that contract
        IF l_sch_count > 0
        THEN
          raise_application_error(-20666,'Catch Up license of this contract is scheduled on '|| l_med_device ||'.So cannot uncheck.');
        else
         o_sch_count := 0;
         --NEED TO UNCHECK THE DEVICE RIGNHTS ON ALL CATCH UP LICENSES OF THAT CONTRACT WHEN EVER USER CLICKS ON YES IN POP UP WHICH IS APPEAR ON SCREEN IN FRONT END
         END IF;
       END IF;
    END LOOP;
  END LOOP;
    --CACQ14:END:SUSHMA K on 28-10-2014     */

      END IF;
      --Added by Milan Shah - CU4ALL

      FOR I IN
      (
          SELECT CB_NAME FROM x_cp_bouquet
          WHERE CB_AD_FLAG='A'
          AND cb_bouq_parent_id is null
          MINUS
          (SELECT COLUMN_VALUE COL1 FROM TABLE(X_PKG_VOD_REJECTED_TITLES.split_to_char(I_CON_BOUQUET_RIGHTS,',')))
      )
      LOOP
          SELECT COUNT(1) INTO L_COUNT FROM X_CP_CON_SUPERSTACK_RIGHTS,x_cp_bouquet
          where CSR_CON_NUMBER = i_con_number
          AND csr_bouquet_id =CB_ID
          AND CB_NAME = I.CB_NAME
          and CSR_SUPERSTACK_FLAG ='Y';

          IF L_COUNT >0
          THEN
              raise_application_error(-20666,'Super stack rights are present for selected bouquet. Kindly remove Super Stack rights for the selected bouquet first');
          END IF;
      END LOOP;
    --End Milan Shah
      /* Catchup (CACQ 16) :Pranay Kusumwal 12/10/2012 :END */
      IF NVL (i_con_short_name, '#') <> (l_con_short_name)
      THEN
         --  DBMS_OUTPUT.put_line ('1');

         IF i_con_short_name IS NOT NULL
         THEN
            --  DBMS_OUTPUT.put_line ('2');

            SELECT COUNT (con_short_name)
              INTO l_contract_exist
              FROM fid_contract
             WHERE con_short_name = UPPER (i_con_short_name);

            IF l_contract_exist > 0
            THEN
               --    DBMS_OUTPUT.put_line ('3');
               RAISE contract_short_name_exists;
            ELSE
               --  DBMS_OUTPUT.put_line ('4');

               UPDATE fid_contract
                  SET con_name = i_con_name,
                      con_com_number = i_con_com_number,
                      con_agy_com_number = i_con_agy_com_number,
                      con_lee_number = i_con_lee_number,
                      con_calc_type = i_con_calc_type,
                      con_currency = i_con_currency,
                      con_min_subscriber = i_con_min_subscriber,
                      con_start_date = i_con_start_date,
                      con_end_date = i_con_end_date,
                      con_exh_day_start =
                         TO_NUMBER (
                            (SUBSTR (i_con_exh_day_start, 1, 2) * 3600)
                            + (SUBSTR (i_con_exh_day_start, 4, 2) * 60)),
                      con_exh_day_runs = i_con_exh_day_runs,
                      con_prime_time_start =
                         TO_NUMBER (
                            (SUBSTR (i_con_prime_time_start, 1, 2) * 3600)
                            + (SUBSTR (i_con_prime_time_start, 4, 2) * 60)),
                      con_prime_time_end =
                         TO_NUMBER (
                            (SUBSTR (i_con_prime_time_end, 1, 2) * 3600)
                            + (SUBSTR (i_con_prime_time_end, 4, 2) * 60)),
                      con_mux_ind = i_con_mux_ind,
                      con_align_ind = i_con_align_ind,
                      con_prime_time_type = i_con_prime_time_type,
                      con_prime_time_pd_limit = i_con_prime_time_pd_limit,
                      con_prime_max_runs = i_con_prime_max_runs,
                      con_prime_max_runs_perc = i_con_prime_max_runs_perc,
                      con_prime_time_level = i_con_prime_time_level,
                      con_comment = i_con_comment,
                      con_exh_day_comment = i_con_exh_day_comment,
                      con_roy_calc_method = i_con_roy_calc_method,
                      --con_update_count = NVL (i_con_update_count, 0) + 1,
                      con_category = i_con_category,
                      con_price = i_con_price,
                      con_renew_date = i_con_renew_date,
                      con_short_name = i_con_short_name,
                      con_status = i_con_status,
                      con_date = i_con_date,
                      con_acct_date = i_acc_date,
                      con_license_period = i_license_period,
                      con_exhibition_per_day = i_con_exhibition_per_day,
                      con_limit_per_service = i_con_limit_per_service,
                      con_limit_per_channel = i_con_limit_per_channel,
                      con_entry_oper = i_entryoper,
                      /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
                      con_catchup_flag = i_c_catchup_flag,
                      con_max_fee_subs = i_c_max_fee_subs,
                      con_ad_promo_cha_brand_restr =
                         i_c_ad_promo_cha_brand_restr,
                      con_max_perc_content_restr = i_c_max_perc_content_restr,
                      con_min_of_major_studio_restr =
                         i_c_min_of_major_studio_restr,
                      con_not_allow_aft_x_start_lic =
                         i_c_not_allow_aft_x_start_lic,
                      con_not_allow_bef_x_end_lic_dt =
                         i_c_not_allow_bef_x_end_lic_dt,
                      con_other_rules = i_c_other_rules,
                      con_mud_restriction = i_c_mud_restriction,
                      con_trans_tech_restr = i_c_trans_tech_restr,
                      con_studio_pre_roll_notice_req =
                         i_c_studio_pre_roll_notice_req,
                      con_sch_within_x_frm_ply_fea =
                         i_c_sch_within_x_frm_ply_fea,
                      con_sch_within_x_frm_ply_ser =
                         i_c_sch_within_x_frm_ply_ser,
                      con_sch_after_prem_linr_fea =
                         i_c_sch_after_prem_linr_fea,
                      con_sch_after_prem_linr_ser =
                         i_c_sch_after_prem_linr_ser,
                      con_sch_no_epi_restr_ser_seson =
                         i_c_sch_no_epi_restr_ser_seson,
                      con_sch_x_day_before_linr_fea =
                         i_c_sch_x_day_before_linr_fea,
                      con_sch_x_day_before_linr_ser =
                         i_c_sch_x_day_before_linr_ser,
                      con_sch_x_day_bef_linr_val_fea =
                         i_c_sch_x_day_bef_linr_val_fea,
                      con_sch_x_day_bef_linr_val_ser =
                         i_c_sch_x_day_bef_linr_val_ser,
                      con_tba_ser_schedule_flag = i_con_tba_ser_schedule_flag,
                      con_procurement_type = i_c_procurement_type /* Dev1: Catch-up R1:End  */
                                                                 ,
                      /* Dev2: Rand Devaluation:Start:Sushma K_2014/09/16  */
                      CON_DEVALUATION_FLAG = i_c_rand_devaluation_flag --/* Dev2:Rand Devalaution:End  */
                                                                      --CACQ14:Start: Sushma K-2014/11/04
                      ,
                      CON_SCH_WITHOUT_LINR_REF_FEA =
                         i_con_SCH_WITHOUT_LINR_REF_FEA,
                      CON_SCH_WITHOUT_LINR_REF_SER =
                         i_con_SCH_WITHOUT_LINR_REF_SER,
                      con_is_mg_flag = i_con_mg_flag --BR_15_144 ¿ Warner Payment Term - START on [28-09-2015]  by sushma
                --CACQ: END

          ,CON_COMPACT_VP_RUNS_FEA=I_CON_COMPACT_VP_RUNS_FEA
           ,CON_ALLOW_RING_FENCE_FEA=I_CON_ALLOW_RING_FENCE_FEA
           ,CON_ALLOW_RING_FENCE_SER	=I_CON_ALLOW_RING_FENCE_SER
           ,CON_SCH_AFT_PREM_LINR_SER_BOUQ	=L_CON_SCH_AFT_PREM_SER_BOUQ
           ,CON_SCH_LIN_SER_CHA	=I_CON_SCH_LIN_SER_CHA
           ,CON_ALLOW_EXH_WEEK_TIER_SER=I_CON_ALLOW_EXH_WEEK_TIER_SER

                WHERE con_number = i_con_number;

               --AND con_update_count = NVL (i_con_update_count, 0);

               UPDATE sak_memo
                  SET mem_con_procurement_type = i_c_procurement_type
                WHERE mem_con_number = i_con_number
                      AND mem_status = 'REGISTERED';

               --------------RDT Audit Changes for Update Count------------------
               SELECT CON_UPDATE_COUNT          -----take current update count
                 INTO l_CON_UPDATE_COUNT
                 FROM FID_CONTRACT
                WHERE con_number = i_con_number;



               IF NVL (i_con_update_count, 0) = NVL (l_CON_UPDATE_COUNT, 0) -----check input update count with current update count for that gen_ref number  if equal then  increament update count
               THEN
                  UPDATE FID_CONTRACT
                     SET CON_UPDATE_COUNT = CON_UPDATE_COUNT + 1
                   WHERE con_number = i_con_number;

                  COMMIT;

                  SELECT CON_UPDATE_COUNT -----take latest update count after commit
                    INTO l_CON_UPDATE_COUNT
                    FROM FID_CONTRACT
                   WHERE con_number = i_con_number;

                  o_con_update_count := NVL (l_CON_UPDATE_COUNT, 0);
               ELSE
                  raise_application_error (
                     -20001,
                        'The contract details for contract - '
                     || i_con_name
                     || ' is already modified by another user.');
               END IF;

               ------------RDT Audit Changes End------------------------

               o_con_short_name := i_con_short_name;
            END IF;

            --DBMS_OUTPUT.put_line ('5');
         ELSE
            --DBMS_OUTPUT.put_line ('6');
            l_con_number := get_seq ('SEQ_CON_NUMBER');

            SELECT spa_value
              INTO l_systemid
              FROM fid_system_parm
             WHERE spa_id = 'SYSTEM_ID';

            l_con_short_name :=
                  TO_CHAR (SYSDATE, 'YY')
               || '-'
               || LTRIM (TO_CHAR (l_con_number, '099999'))
               || '-'
               || l_systemid;
            --DBMS_OUTPUT.put_line ('6' || l_con_short_name);

            UPDATE fid_contract
               SET con_name = i_con_name,
                   con_com_number = i_con_com_number,
                   con_agy_com_number = i_con_agy_com_number,
                   con_lee_number = i_con_lee_number,
                   con_calc_type = i_con_calc_type,
                   con_currency = i_con_currency,
                   con_min_subscriber = i_con_min_subscriber,
                   con_start_date = i_con_start_date,
                   con_end_date = i_con_end_date,
                   con_exh_day_start =
                      TO_NUMBER (
                         (SUBSTR (i_con_exh_day_start, 1, 2) * 3600)
                         + (SUBSTR (i_con_exh_day_start, 4, 2) * 60)),
                   con_exh_day_runs = i_con_exh_day_runs,
                   con_prime_time_start =
                      TO_NUMBER (
                         (SUBSTR (i_con_prime_time_start, 1, 2) * 3600)
                         + (SUBSTR (i_con_prime_time_start, 4, 2) * 60)),
                   con_prime_time_end =
                      TO_NUMBER (
                         (SUBSTR (i_con_prime_time_end, 1, 2) * 3600)
                         + (SUBSTR (i_con_prime_time_end, 4, 2) * 60)),
                   con_mux_ind = i_con_mux_ind,
                   con_align_ind = i_con_align_ind,
                   con_prime_time_type = i_con_prime_time_type,
                   con_prime_time_pd_limit = i_con_prime_time_pd_limit,
                   con_prime_max_runs = i_con_prime_max_runs,
                   con_prime_max_runs_perc = i_con_prime_max_runs_perc,
                   con_prime_time_level = i_con_prime_time_level,
                   con_comment = i_con_comment,
                   con_exh_day_comment = i_con_exh_day_comment,
                   con_roy_calc_method = i_con_roy_calc_method,
                   --con_update_count = NVL (i_con_update_count, 0) + 1,
                   con_category = i_con_category,
                   con_price = i_con_price,
                   con_renew_date = i_con_renew_date,
                   con_short_name = l_con_short_name,
                   con_status = i_con_status,
                   con_date = i_con_date,
                   con_acct_date = i_acc_date,
                   con_license_period = i_license_period,
                   con_exhibition_per_day = i_con_exhibition_per_day,
                   con_limit_per_service = i_con_limit_per_service,
                   con_limit_per_channel = i_con_limit_per_channel,
                   con_entry_oper = i_entryoper,
                   /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
                   con_catchup_flag = i_c_catchup_flag,
                   con_max_fee_subs = i_c_max_fee_subs,
                   con_ad_promo_cha_brand_restr = i_c_ad_promo_cha_brand_restr,
                   con_max_perc_content_restr = i_c_max_perc_content_restr,
                   con_min_of_major_studio_restr =
                      i_c_min_of_major_studio_restr,
                   con_not_allow_aft_x_start_lic =
                      i_c_not_allow_aft_x_start_lic,
                   con_not_allow_bef_x_end_lic_dt =
                      i_c_not_allow_bef_x_end_lic_dt,
                   con_other_rules = i_c_other_rules,
                   con_mud_restriction = i_c_mud_restriction,
                   con_trans_tech_restr = i_c_trans_tech_restr,
                   con_studio_pre_roll_notice_req =
                      i_c_studio_pre_roll_notice_req,
                   con_sch_within_x_frm_ply_fea = i_c_sch_within_x_frm_ply_fea,
                   con_sch_within_x_frm_ply_ser = i_c_sch_within_x_frm_ply_ser,
                   con_sch_after_prem_linr_fea = i_c_sch_after_prem_linr_fea,
                   con_sch_after_prem_linr_ser = i_c_sch_after_prem_linr_ser,
                   con_sch_no_epi_restr_ser_seson =
                      i_c_sch_no_epi_restr_ser_seson,
                   con_sch_x_day_before_linr_fea =
                      i_c_sch_x_day_before_linr_fea,
                   con_sch_x_day_before_linr_ser =
                      i_c_sch_x_day_before_linr_ser,
                   con_sch_x_day_bef_linr_val_fea =
                      i_c_sch_x_day_bef_linr_val_fea,
                   con_sch_x_day_bef_linr_val_ser =
                      i_c_sch_x_day_bef_linr_val_ser,
                   con_tba_ser_schedule_flag = i_con_tba_ser_schedule_flag,
                   con_procurement_type = i_c_procurement_type,
                   /* Dev1: Catch-up R1:End  */
                   /* Dev2: Rand Devaluation:Start:Sushma K_2014/09/16  */
                   CON_DEVALUATION_FLAG = i_c_rand_devaluation_flag --/* Dev2:Rand Devalaution:End  */
                                                                   --CACQ14:Start: Sushma K-2014/11/04
                   ,
                   CON_SCH_WITHOUT_LINR_REF_FEA =
                      i_con_SCH_WITHOUT_LINR_REF_FEA,
                   CON_SCH_WITHOUT_LINR_REF_SER =
                      i_con_SCH_WITHOUT_LINR_REF_FEA,
                   con_is_mg_flag = i_con_mg_flag --BR_15_144 Warner Payment Term - START on [28-09-2015]  by sushma
             --CACQ: END

          ,CON_COMPACT_VP_RUNS_FEA=I_CON_COMPACT_VP_RUNS_FEA
           ,CON_ALLOW_RING_FENCE_FEA=I_CON_ALLOW_RING_FENCE_FEA
           ,CON_ALLOW_RING_FENCE_SER	=I_CON_ALLOW_RING_FENCE_SER
           ,CON_SCH_AFT_PREM_LINR_SER_BOUQ	=L_CON_SCH_AFT_PREM_SER_BOUQ
           ,CON_SCH_LIN_SER_CHA	=I_CON_SCH_LIN_SER_CHA
           ,CON_ALLOW_EXH_WEEK_TIER_SER=I_CON_ALLOW_EXH_WEEK_TIER_SER
             WHERE con_number = i_con_number;

            --AND con_update_count = NVL (i_con_update_count, 0);

            UPDATE sak_memo
               SET mem_con_procurement_type = i_c_procurement_type
             WHERE mem_con_number = i_con_number
                   AND mem_status = 'REGISTERED';

            ----------------------RDT Audit Changes for Update Count------------------------------------
            SELECT CON_UPDATE_COUNT             -----take current update count
              INTO l_CON_UPDATE_COUNT
              FROM FID_CONTRACT
             WHERE con_number = i_con_number;

            IF NVL (i_con_update_count, 0) = NVL (l_CON_UPDATE_COUNT, 0) -----check input update count with current update count for that gen_ref number  if equal then  increament update count
            THEN
               UPDATE FID_CONTRACT
                  SET CON_UPDATE_COUNT = NVL (CON_UPDATE_COUNT, 0) + 1
                WHERE con_number = i_con_number;

               COMMIT;

               SELECT CON_UPDATE_COUNT -----take latest update count after commit
                 INTO l_CON_UPDATE_COUNT
                 FROM FID_CONTRACT
                WHERE con_number = i_con_number;

               o_con_update_count := NVL (l_CON_UPDATE_COUNT, 0);
            ELSE
               raise_application_error (
                  -20001,
                     'The contract details for contract - '
                  || i_con_name
                  || ' is already modified by another user.');
            END IF;

            --------------------RDT Audit Changes End----------------------


            o_con_short_name := l_con_short_name;
         END IF;

         --DBMS_OUTPUT.put_line ('7');
      ELSE
         --DBMS_OUTPUT.put_line ('8');
         /*  l_con_number := get_seq ('SEQ_CON_NUMBER');
           SELECT spa_value
             INTO l_systemid
             FROM fid_system_parm
            WHERE spa_id = 'SYSTEM_ID';
           l_con_short_name :=
                 TO_CHAR (SYSDATE, 'YY')
              || '-'
              || LTRIM (TO_CHAR (l_con_number, '099999'))
              || '-'
              || l_systemid;*/
         UPDATE fid_contract
            SET con_name = i_con_name,
                con_com_number = i_con_com_number,
                con_agy_com_number = i_con_agy_com_number,
                con_lee_number = i_con_lee_number,
                con_calc_type = i_con_calc_type,
                con_currency = i_con_currency,
                con_min_subscriber = i_con_min_subscriber,
                con_start_date = i_con_start_date,
                con_end_date = i_con_end_date,
                con_exh_day_start =
                   TO_NUMBER (
                      (SUBSTR (i_con_exh_day_start, 1, 2) * 3600)
                      + (SUBSTR (i_con_exh_day_start, 4, 2) * 60)),
                con_exh_day_runs = i_con_exh_day_runs,
                con_prime_time_start =
                   TO_NUMBER (
                      (SUBSTR (i_con_prime_time_start, 1, 2) * 3600)
                      + (SUBSTR (i_con_prime_time_start, 4, 2) * 60)),
                con_prime_time_end =
                   TO_NUMBER (
                      (SUBSTR (i_con_prime_time_end, 1, 2) * 3600)
                      + (SUBSTR (i_con_prime_time_end, 4, 2) * 60)),
                con_mux_ind = i_con_mux_ind,
                con_align_ind = i_con_align_ind,
                con_prime_time_type = i_con_prime_time_type,
                con_prime_time_pd_limit = i_con_prime_time_pd_limit,
                con_prime_max_runs = i_con_prime_max_runs,
                con_prime_max_runs_perc = i_con_prime_max_runs_perc,
                con_prime_time_level = i_con_prime_time_level,
                con_comment = i_con_comment,
                con_exh_day_comment = i_con_exh_day_comment,
                con_roy_calc_method = i_con_roy_calc_method,
                --con_update_count = NVL (i_con_update_count, 0) + 1,
                con_category = i_con_category,
                con_price = i_con_price,
                con_renew_date = i_con_renew_date,
                con_short_name = i_con_short_name,
                con_status = i_con_status,
                con_date = i_con_date,
                con_acct_date = i_acc_date,
                con_license_period = i_license_period,
                con_exhibition_per_day = i_con_exhibition_per_day,
                con_limit_per_service = i_con_limit_per_service,
                con_limit_per_channel = i_con_limit_per_channel,
                con_entry_oper = i_entryoper,
                /* Dev1: Catch-up R1:Start:CACQ16_KrishanY_2012/10/04  */
                con_catchup_flag = i_c_catchup_flag,
                con_max_fee_subs = i_c_max_fee_subs,
                con_ad_promo_cha_brand_restr = i_c_ad_promo_cha_brand_restr,
                con_max_perc_content_restr = i_c_max_perc_content_restr,
                con_min_of_major_studio_restr = i_c_min_of_major_studio_restr,
                con_not_allow_aft_x_start_lic = i_c_not_allow_aft_x_start_lic,
                con_not_allow_bef_x_end_lic_dt =
                   i_c_not_allow_bef_x_end_lic_dt,
                con_other_rules = i_c_other_rules,
                con_mud_restriction = i_c_mud_restriction,
                con_trans_tech_restr = i_c_trans_tech_restr,
                con_studio_pre_roll_notice_req =
                   i_c_studio_pre_roll_notice_req,
                con_sch_within_x_frm_ply_fea = i_c_sch_within_x_frm_ply_fea,
                con_sch_within_x_frm_ply_ser = i_c_sch_within_x_frm_ply_ser,
                con_sch_after_prem_linr_fea = i_c_sch_after_prem_linr_fea,
                con_sch_after_prem_linr_ser = i_c_sch_after_prem_linr_ser,
                con_sch_no_epi_restr_ser_seson =
                   i_c_sch_no_epi_restr_ser_seson,
                con_sch_x_day_before_linr_fea = i_c_sch_x_day_before_linr_fea,
                con_sch_x_day_before_linr_ser = i_c_sch_x_day_before_linr_ser,
                con_sch_x_day_bef_linr_val_fea =
                   i_c_sch_x_day_bef_linr_val_fea,
                con_sch_x_day_bef_linr_val_ser =
                   i_c_sch_x_day_bef_linr_val_ser,
                con_tba_ser_schedule_flag = i_con_tba_ser_schedule_flag,
                con_procurement_type = i_c_procurement_type,
                /* Dev1: Catch-up R1:End  */
                /* Dev2: Rand Devaluation:Start:Sushma K_2014/09/16  */
                CON_DEVALUATION_FLAG = i_c_rand_devaluation_flag --/* Dev2:Rand Devalaution:End  */
                                                                --CACQ14:Start: Sushma K-2014/11/04
                ,
                CON_SCH_WITHOUT_LINR_REF_FEA = i_con_SCH_WITHOUT_LINR_REF_FEA,
                CON_SCH_WITHOUT_LINR_REF_SER = i_con_SCH_WITHOUT_LINR_REF_SER,
                con_is_mg_flag = i_con_mg_flag --BR_15_144 Warner Payment Term - START on [28-09-2015]  by sushma
          --CACQ: END


          ,CON_COMPACT_VP_RUNS_FEA=I_CON_COMPACT_VP_RUNS_FEA
           ,CON_ALLOW_RING_FENCE_FEA=I_CON_ALLOW_RING_FENCE_FEA
           ,CON_ALLOW_RING_FENCE_SER	=I_CON_ALLOW_RING_FENCE_SER
           ,CON_SCH_AFT_PREM_LINR_SER_BOUQ	=L_CON_SCH_AFT_PREM_SER_BOUQ
           ,CON_SCH_LIN_SER_CHA	=I_CON_SCH_LIN_SER_CHA
           ,CON_ALLOW_EXH_WEEK_TIER_SER=I_CON_ALLOW_EXH_WEEK_TIER_SER
          WHERE con_number = i_con_number;

         -- AND con_update_count = NVL (i_con_update_count, 0);

         UPDATE sak_memo
            SET mem_con_procurement_type = i_c_procurement_type
          WHERE mem_con_number = i_con_number AND mem_status = 'REGISTERED';

         --CATCHUP: changes start for CACQ14: SHANTANU A.
         /*IF
         UPDATE fid_contract
         SET con_sch_x_day_bef_linr_val_fea =
                  i_c_sch_x_day_bef_linr_val_fea,
               con_sch_x_day_bef_linr_val_ser =
                  i_c_sch_x_day_bef_linr_val_ser
         WHERE con_number = i_con_number;
         --CACTHUP:CACQ14_END*/
         ----------------------RDT Audit Changes for Update Count------------------------------------
         SELECT CON_UPDATE_COUNT                -----take current update count
           INTO l_CON_UPDATE_COUNT
           FROM FID_CONTRACT
          WHERE con_number = i_con_number;

         IF NVL (i_con_update_count, 0) = NVL (l_CON_UPDATE_COUNT, 0) -----check input update count with current update count for that gen_ref number  if equal then  increament update count
         THEN
            UPDATE FID_CONTRACT
               SET CON_UPDATE_COUNT = NVL (CON_UPDATE_COUNT, 0) + 1
             WHERE con_number = i_con_number;

            COMMIT;

            SELECT CON_UPDATE_COUNT -----take latest update count after commit
              INTO l_CON_UPDATE_COUNT
              FROM FID_CONTRACT
             WHERE con_number = i_con_number;

            o_con_update_count := NVL (l_CON_UPDATE_COUNT, 0);
         ELSE
            raise_application_error (
               -20001,
                  'The contract details for contract - '
               || i_con_name
               || ' is already modified by another user.');
         END IF;

         --------------------RDT Audit Changes End----------------------


         o_con_short_name := l_con_short_name;
      END IF;

      --DBMS_OUTPUT.put_line ('9');
      --DBMS_OUTPUT.put_line ('o_error_found' || o_error_found);

      --Dev2: Pure Finance :Start:[FIN 10-Contract maintenance]_[ANUJASHINDE]_[2013/2/22]

      IF (UPPER (CON_CURR_OLD) <> UPPER (I_CON_CURRENCY))
      THEN
         IF (UPPER (pay_curr_old) <> UPPER (i_con_currency))
         THEN
            --[to set the payment currency as per the new contract currency on change]
            UPDATE fid_payment
               SET pay_cur_code = i_con_currency,
                   pay_entry_date = SYSDATE,
                   pay_entry_oper = i_entryoper
             WHERE pay_con_number = i_con_number
               AND pay_status NOT IN ('P','I');

            --[to set the license currency as per the new contract currency on change]
            UPDATE fid_license
               SET lic_currency = i_con_currency,
                   lic_entry_date = SYSDATE,
                   lic_entry_oper = i_entryoper
             WHERE LIC_CON_NUMBER = I_CON_NUMBER;
         END IF;
      END IF;

      --Dev2: Pure Finance :End

      IF (i_processclicked = 'Y')
      THEN
         IF (o_error_found != 'Y')
         THEN
            COMMIT;

            SELECT con_update_count
              INTO o_con_update_count
              FROM fid_contract
             WHERE con_number = i_con_number;
         ELSE
            ROLLBACK;

            SELECT con_update_count
              INTO o_con_update_count
              FROM fid_contract
             WHERE con_number = i_con_number;
         END IF;
      ELSE
         COMMIT;

         SELECT con_update_count
           INTO o_con_update_count
           FROM fid_contract
          WHERE con_number = i_con_number;
      END IF;

      --DBMS_OUTPUT.put_line ('10');
      --DBMS_OUTPUT.put_line ('o_con_update_count: ' || o_con_update_count);

    /*  INSERT INTO X_CON_BOUQUE_MAPP(CBM_ID,CBM_CON_NUMBER,CBM_BOUQUE_ID,CBM_CON_BOUQ_RIGHTS,CBM_MODIFIED_BY,CBM_MODIFIED_DATE)
        SELECT CBM_ID,CBM_CON_NUMBER,
        (SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_NAME=BOUQUET) BOUQUET_ID
        ,'Y',i_entryoper,SYSDATE
        FROM
        (SELECT (SELECT nvl(MAX(CBM_ID),0) + 1 FROM X_CON_BOUQUE_MAPP) CBM_ID
        ,i_con_number CBM_CON_NUMBER
        FROM DUAL) t1,
        (SELECT COLUMN_VALUE  BOUQUET FROM TABLE(X_CP_SUPERSTACK_RIGHTS.split_to_char('Premium,Extra,Compact',','))) t2;
       */
--       FOR I IN (
--        SELECT ROWNUM RN,CBM_ID,CBM_CON_NUMBER,
--        (SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_NAME=BOUQUET) BOUQUET_ID
--        ,'Y' CBM_CON_BOUQ_RIGHTS,i_entryoper CBM_MODIFIED_BY,SYSDATE CBM_MODIFIED_DATE
--        FROM
--        (SELECT (SELECT nvl(MAX(CBM_ID),0) FROM X_CON_BOUQUE_MAPP) CBM_ID
--        ,i_con_number CBM_CON_NUMBER
--        FROM DUAL) t1,
--        (SELECT COLUMN_VALUE  BOUQUET FROM TABLE(X_CP_SUPERSTACK_RIGHTS.split_to_char(I_CON_BOUQUET_RIGHTS,','))) t2)
--      LOOP
--      INSERT INTO X_CON_BOUQUE_MAPP(CBM_ID,CBM_CON_NUMBER,CBM_BOUQUE_ID,CBM_CON_BOUQ_RIGHTS,CBM_MODIFIED_BY,CBM_MODIFIED_DATE)
--      VALUES
--      (I.CBM_ID+I.rn,I.CBM_CON_NUMBER,I.BOUQUET_ID,I.CBM_CON_BOUQ_RIGHTS,I.CBM_MODIFIED_BY,I.CBM_MODIFIED_DATE);
--      END LOOP;
      /* SELECT pkg_cm_username.SetUserName (i_entryoper)
       into V_OPERATOR
      FROM DUAL;

        DELETE FROM X_CON_BOUQUE_MAPP WHERE CBM_CON_NUMBER=i_con_number;

        FOR I IN
        (
            SELECT T1.COL1 BOUQUET FROM
            (
              (SELECT COLUMN_VALUE COL1 FROM TABLE(X_PKG_VOD_REJECTED_TITLES.split_to_char(I_CON_BOUQUET_RIGHTS,','))) T1
            )
        )
        LOOP
            IF I.BOUQUET IS NOT NULL
            THEN
            SELECT X_SEQ_CON_BOUQUET_MAPP.nextval INTO L_CBM_ID FROM Dual;

            SELECT pkg_cm_username.SetUserName (i_entryoper)
       into V_OPERATOR
      FROM DUAL;
            INSERT INTO X_CON_BOUQUE_MAPP
          (
              CBM_ID
              ,CBM_CON_NUMBER
              ,CBM_BOUQUE_ID
              ,CBM_CON_BOUQ_RIGHTS
              ,CBM_ENTRY_OPER
              ,CBM_ENTRY_DATE
            )
            VALUES
            (
              L_CBM_ID
              ,i_con_number
              ,(SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_NAME = I.BOUQUET AND CB_BOUQ_PARENT_ID is null AND CB_AD_FLAG='A')
              ,'Y'
              ,i_entryoper
              ,SYSDATE
            );
            END IF;
        END LOOP;*/
        DELETE FROM X_CON_BOUQUE_MAPP WHERE CBM_CON_NUMBER=i_con_number;
        FOR I IN
        (
            (select cb_id
                    ,cb_name
             From   x_cp_bouquet
                    ,(SELECT COLUMN_VALUE COL1 FROM TABLE(X_PKG_VOD_REJECTED_TITLES.split_to_char(I_CON_BOUQUET_RIGHTS,',')))
            where cb_name = COL1
                  AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP
                        WHERE CMM_BOUQ_MS_CODE IN (select MS_MEDIA_SERVICE_CODE from fid_contract,sgy_pb_media_service
                                                      where MS_MEDIA_SERVICE_FLAG=CON_CATCHUP_FLAG
                                                        AND CON_NUMBER =i_con_number)AND CMM_BOUQ_MS_RIGHTS ='Y')
                    AND CB_AD_FLAG = 'A'
                    AND x_cp_bouquet.cb_bouq_parent_id is null
            )
        )
        LOOP
            SELECT pkg_cm_username.SetUserName (i_entryoper)into V_OPERATOR FROM DUAL;

            BEGIN
                SELECT CBM_CON_BOUQ_RIGHTS INTO L_RIGHT from X_CON_BOUQUE_MAPP where cbm_con_number = i_con_number and CBM_BOUQUE_ID = I.cb_id and rownum>2;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                L_RIGHT := 'I';
            END;

            IF L_RIGHT= 'N'
            THEN

                UPDATE X_CON_BOUQUE_MAPP
                SET   CBM_CON_BOUQ_RIGHTS = 'Y'
                      ,CBM_MODIFIED_BY = i_entryoper
                      ,CBM_MODIFIED_DATE = SYSDATE
                WHERE CBM_CON_NUMBER = i_con_number
                AND CBM_BOUQUE_ID = I.cb_id;

            ELSIF L_RIGHT = 'I'
            THEN

                SELECT X_SEQ_CON_BOUQUET_MAPP.nextval INTO L_CBM_ID FROM Dual;
                INSERT INTO X_CON_BOUQUE_MAPP
                (
                     CBM_ID
                    ,CBM_CON_NUMBER
                    ,CBM_BOUQUE_ID
                    ,CBM_CON_BOUQ_RIGHTS
                    ,CBM_ENTRY_OPER
                    ,CBM_ENTRY_DATE
                )
                VALUES
               (
                    L_CBM_ID
                    ,i_con_number
                    ,I.cb_id
                    ,'Y'
                    ,i_entryoper
                    ,SYSDATE
               );
            END IF;
        END LOOP;


        FOR J IN
        (
          (select cb_id,cb_name From x_cp_bouquet
            where cb_name NOT IN ((SELECT COLUMN_VALUE COL1 FROM TABLE(X_PKG_VOD_REJECTED_TITLES.split_to_char(I_CON_BOUQUET_RIGHTS,','))))
            and cb_ad_flag = 'A'
            and x_cp_bouquet.cb_bouq_parent_id is null
            and CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP
                        WHERE CMM_BOUQ_MS_CODE IN (select MS_MEDIA_SERVICE_CODE from fid_contract,sgy_pb_media_service
                                                      where MS_MEDIA_SERVICE_FLAG=CON_CATCHUP_FLAG
                                                        AND CON_NUMBER =i_con_number)AND CMM_BOUQ_MS_RIGHTS ='Y'))
        )
        LOOP
            SELECT pkg_cm_username.SetUserName (i_entryoper)into V_OPERATOR FROM DUAL;

            BEGIN
              SELECT CBM_CON_BOUQ_RIGHTS INTO L_RIGHT from X_CON_BOUQUE_MAPP where cbm_con_number = i_con_number and CBM_BOUQUE_ID = J.cb_id and rownum>2;
            EXCEPTION WHEN NO_DATA_FOUND THEN
            L_RIGHT := 'N';
            END;
            IF L_RIGHT = 'Y'
            THEN
                UPDATE X_CON_BOUQUE_MAPP
                SET   CBM_CON_BOUQ_RIGHTS = 'N'
                      ,CBM_MODIFIED_BY = i_entryoper
                      ,CBM_MODIFIED_DATE = SYSDATE
                WHERE CBM_CON_NUMBER = i_con_number
                AND CBM_BOUQUE_ID = J.cb_id;
            END IF;
        END LOOP;



   EXCEPTION
      WHEN contract_short_name_exists
      THEN
         raise_application_error (
            -20666,
            'Contract Short Name already exists,Please enter another');
   /*   WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));*/
   END prc_update_contract_details;

   PROCEDURE prc_get_contractfile_data
   (
      i_con_number       IN     NUMBER,
      o_contracts_data      OUT pkg_acon_cm_contract_maint.c_contracts_cursor)
   AS
   BEGIN
      OPEN o_contracts_data FOR
         SELECT s_data
           FROM fid_con_log
          WHERE con_number = i_con_number;
   END prc_get_contractfile_data;

   PROCEDURE prc_delete_contract_details (
      i_con_number       IN     fid_contract.con_number%TYPE,
      o_con_is_deleted      OUT NUMBER)
   AS
      l_record_exist   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_record_exist
        FROM fid_contract
       WHERE con_number = i_con_number;

      IF l_record_exist > 0
      THEN
         DELETE FROM fid_contract
               WHERE con_number = i_con_number;

         COMMIT;
         o_con_is_deleted := 1;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20643, 'This contract can not be found.');
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_delete_contract_details;

   PROCEDURE prc_check_contract_licenses (
      i_con_number                IN     NUMBER,
      i_con_short_name            IN     VARCHAR2,
      i_con_prime_time_start      IN     VARCHAR2,
      i_con_prime_time_end        IN     VARCHAR2,
      i_con_prime_max_runs        IN     NUMBER,
      i_con_prime_max_runs_perc   IN     NUMBER,
      i_con_prime_time_level      IN     VARCHAR2,
      i_con_prime_time_pd_limit   IN     VARCHAR2,
      i_con_prime_time_type       IN     VARCHAR2,
      -- i_userid                    IN       VARCHAR2,
      o_file_name                    OUT VARCHAR2,
      o_error_found                  OUT VARCHAR2)
   AS
      perc_com                      NUMBER;
      l_cnt                         NUMBER := 0;
      l_time_started                DATE;

      CURSOR c_license
      IS
           SELECT lic_number
             FROM fid_license
            WHERE lic_con_number = i_con_number
         --and lic_number in  (432155,432156,432157,432158)
		      and NVL(lic_catchup_flag, 'N') = 'N'             --Jawahar-16Mar2015 P1 issue. Filtered cp licenses as channel service is not applicable for cp.
         ORDER BY lic_number;

      l_file_name                   VARCHAR2 (30);
      o_file                        UTL_FILE.file_type;
      l_lic_count                   NUMBER;
      l_date                        DATE := TO_DATE ('31-DEC-2010', 'DD-MON-YYYY');
      l_re_insert                   VARCHAR2 (1) := ' ';
      l_message                     VARCHAR2 (500);
      l_con_prime_time_start        NUMBER;
      l_con_prime_time_end          NUMBER;
      l_con_prime_max_runs          NUMBER;
      l_con_prime_max_runs_perc     NUMBER;
      l_con_prime_time_level        VARCHAR2 (6);
      -- l_con_prime_time_level_s      VARCHAR2 (6);
      l_con_prime_time_start_s      NUMBER;
      l_con_prime_time_end_s        NUMBER;
      l_con_prime_max_runs_s        NUMBER;
      l_con_prime_max_runs_perc_s   NUMBER;
      l_con_prime_time_level_s      VARCHAR2 (6);
      l_errors                      VARCHAR2 (1);
      l_time_ended                  DATE;
      l_errorstring                 VARCHAR2 (1000);
   BEGIN
      --DBMS_OUTPUT.put_line ('99');

      SELECT con_prime_time_start,
             con_prime_time_end,
             con_prime_max_runs,
             con_prime_max_runs_perc,
             con_prime_time_level
        INTO l_con_prime_time_start,
             l_con_prime_time_end,
             l_con_prime_max_runs,
             l_con_prime_max_runs_perc,
             l_con_prime_time_level
        FROM fid_contract
       WHERE con_number = i_con_number AND con_short_name = i_con_short_name;

      l_con_prime_time_start_s :=
         TO_NUMBER (
            (SUBSTR (i_con_prime_time_start, 1, 2) * 3600)
            + (SUBSTR (i_con_prime_time_start, 4, 2) * 60));
      l_con_prime_time_end_s :=
         TO_NUMBER (
            (SUBSTR (i_con_prime_time_end, 1, 2) * 3600)
            + (SUBSTR (i_con_prime_time_end, 4, 2) * 60));
      l_file_name := 'PTIME-' || i_con_short_name;
      -- l_con_prime_time_start_s := l_con_prime_time_start;
      --l_con_prime_time_end_s := l_con_prime_time_end;
      l_con_prime_max_runs_s := i_con_prime_max_runs;
      l_con_prime_max_runs_perc_s := i_con_prime_max_runs_perc;
      l_con_prime_time_level_s := i_con_prime_time_level;
      --DBMS_OUTPUT.put_line ('10');
      --DBMS_OUTPUT.put_line ('10' || l_file_name);

      BEGIN
         SELECT COUNT (*)
           INTO l_lic_count
           FROM fid_license
          WHERE lic_con_number = i_con_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --DBMS_OUTPUT.put_line ('11' || l_lic_count);
      --l_store_file := 'c:\mpack40\logfiles\PTIME-'||i_con_short_name;
      -- reset_prog_bar;
      -- :control.perc_complete := null;
      -- set_application_property(CURSOR_STYLE,'BUSY');
      -- message('Working...');
      -- l_time_started := TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS');
      DBMS_OUTPUT.put_line ('file:' || l_file_name);
      --commented code on 1st june 2011 for the schedulers cannot schedule, the prime time rules are not calculating correctly,
      --she has not utilized all the runs and is trying to schedule in prime time and it is saying her runs have been exceeded.
      /*  o_file := UTL_FILE.fopen ('ROUTINES', l_file_name, 'w');
         SELECT directory_path || '\' || l_file_name
           INTO o_file_name
           FROM all_directories
          WHERE directory_name = 'ROUTINES';*/
      --DBMS_OUTPUT.put_line ('10*');

      -- Commented as File to be created on Local Drive
      /* UTL_FILE.put_line (o_file,
                             'Prime Time validation started at '
                          || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS')
                         ); */
      INSERT INTO fid_con_log (con_number, s_data)
           VALUES (
                     i_con_number,
                     'Prime Time validation started at'
                     || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

      --
      /*************************************************************************************************************/
      /* If prime time start and end were changed to 0, set indicator to delete all prime time records for         */
      /* licenses in this contract.                                                                                */
      /*************************************************************************************************************/
      DBMS_OUTPUT.put_line (
         'l_con_prime_time_start ' || l_con_prime_time_start);
      DBMS_OUTPUT.put_line (
         'l_con_prime_time_start_s  ' || l_con_prime_time_start_s);

      IF NVL (l_con_prime_time_start, 0) <> NVL (l_con_prime_time_start_s, 0)
         AND NVL (l_con_prime_time_start_s, 0) > 0
      THEN
         DBMS_OUTPUT.put_line ('l_re_insert D1 ' || l_re_insert);
         l_re_insert := 'D';
      END IF;

      DBMS_OUTPUT.put_line (
         'l_con_prime_time_end   ' || l_con_prime_time_end);
      DBMS_OUTPUT.put_line (
         'l_con_prime_time_end_s   ' || l_con_prime_time_end_s);

      IF NVL (l_con_prime_time_end, 0) <> NVL (l_con_prime_time_end_s, 0)
         AND NVL (l_con_prime_time_end_s, 0) > 0
      THEN
         DBMS_OUTPUT.put_line ('l_re_insert D2 ' || l_re_insert);
         l_re_insert := 'D';
      END IF;

      DBMS_OUTPUT.put_line (
         'l_con_prime_max_runs   ' || l_con_prime_max_runs);
      DBMS_OUTPUT.put_line (
         'l_con_prime_max_runs_s   ' || l_con_prime_max_runs_s);
      DBMS_OUTPUT.put_line (
         'l_con_prime_max_runs_perc   ' || l_con_prime_max_runs_perc);
      DBMS_OUTPUT.put_line (
         'l_con_prime_max_runs_perc_s   ' || l_con_prime_max_runs_perc_s);
      DBMS_OUTPUT.put_line (
         'l_con_prime_time_level   ' || l_con_prime_time_level);
      DBMS_OUTPUT.put_line (
         'l_con_prime_time_level_s   ' || l_con_prime_time_level_s);

      IF NVL (l_con_prime_max_runs, 0) <> NVL (l_con_prime_max_runs_s, 0)
         OR NVL (l_con_prime_max_runs_perc, 0) <>
               NVL (l_con_prime_max_runs_perc_s, 0)
         OR NVL (l_con_prime_time_level, ' ') <>
               NVL (l_con_prime_time_level_s, ' ')
      THEN
         DBMS_OUTPUT.put_line ('l_re_insert Y ' || l_re_insert);
         l_re_insert := 'Y';
      END IF;

      DBMS_OUTPUT.put_line ('l_re_insert ' || l_re_insert);
      o_error_found := 'N';

      FOR lic IN c_license
      LOOP
         IF l_re_insert = 'Y'
         THEN
            DBMS_OUTPUT.put_line ('B9*******' || lic.lic_number);
            pkg_acon_cm_contract_maint.prc_setup_pt (
               lic.lic_number,
               l_con_prime_time_start,
               l_con_prime_time_end,
               l_con_prime_max_runs_perc,
               l_con_prime_max_runs,
               l_con_prime_time_level_s                              -- i_userid
                                     );
            --DBMS_OUTPUT.put_line ('A9*******' || lic.lic_number);
         END IF;

         --DBMS_OUTPUT.put_line ('10*******' || lic.lic_number);

         IF l_re_insert = 'D'
         THEN
            DBMS_OUTPUT.put_line ('B10*******' || lic.lic_number);
            pkg_acon_cm_contract_maint.prc_delete_pt (lic.lic_number);
            DBMS_OUTPUT.put_line ('A10*******' || lic.lic_number);
         END IF;

         DBMS_OUTPUT.put_line ('B11*******' || lic.lic_number);
         pkg_acon_cm_contract_maint.prc_validate_primetime (
            i_con_number,
            lic.lic_number,
            l_date,
            l_con_prime_time_start,
            l_con_prime_time_end,
            i_con_prime_time_type,
            i_con_prime_time_pd_limit,
            o_file,
            l_errors                                                -- ,o_file
                    );
         DBMS_OUTPUT.put_line ('A11*******' || lic.lic_number);

         IF l_errors = 'Y'
         THEN
            o_error_found := 'Y';
         ELSE
            o_error_found := 'N';
         END IF;

         l_cnt := l_cnt + 1;
         perc_com := TRUNC (l_cnt / l_lic_count * 100);
      --:control.perc_complete := to_char(perc_com)||'% complete';
      -- set_prog_bar(perc_com);
      --:control.work_lic_number := con.lic_number;
      END LOOP;

      DBMS_OUTPUT.put_line ('10*******val_pT');

      --l_time_ended := TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS');
      /*UTL_FILE.put_line (o_file,
                            'Prime Time validation ended at '
                         || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS')
                        );
      UTL_FILE.fclose (o_file); */
      INSERT INTO fid_con_log (con_number, s_data)
           VALUES (
                     i_con_number,
                     'Prime Time validation ended at '
                     || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
   EXCEPTION
      WHEN OTHERS
      THEN
         /*UTL_FILE.put_line
                         (o_file,
                             'Prime Time validation ended UNSUCCESSFULLY at '
                          || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS')
                         );*/
         INSERT INTO fid_con_log (con_number, s_data)
              VALUES (
                        i_con_number,
                        'Prime Time validation ended UNSUCCESSFULLY at '
                        || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

         /*UTL_FILE.put_line (o_file,
                            '    with error ' || SQLCODE || ' ' || SQLERRM
                           ); */
         l_errorstring := ' with error ' || SQLCODE || ' ' || SQLERRM;

         INSERT INTO fid_con_log (con_number, s_data)
              VALUES (i_con_number, l_errorstring);

         --UTL_FILE.fclose (o_file);
         -- l_time_ended := TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS');
         l_message := 'Validation completed unsuccessfully.';
         raise_application_error (-20100, SQLCODE || ' ' || SQLERRM);
   END prc_check_contract_licenses;

   PROCEDURE prc_validate_primetime (
      i_con_number                IN     NUMBER,
      i_lic_number                IN     NUMBER,
      i_to_period                 IN     DATE,
      i_con_prime_time_start      IN     VARCHAR2,
      i_con_prime_time_end        IN     VARCHAR2,
      i_con_prime_time_type       IN     VARCHAR2,
      i_con_prime_time_pd_limit   IN     VARCHAR2,
      i_file                      IN     UTL_FILE.file_type,
      o_error                        OUT VARCHAR2 -- o_file      OUT      VARCHAR2
                                                 )
   AS
      /*-------------------------------------------------------------------------------*/
      /*--    Function   : Validate whether license answers to primetime rules         */
      /*-------------------------------------------------------------------------------*/
      CURSOR c_pt_rule
      IS
           SELECT *
             FROM fid_pt_service_channel_vw
            WHERE lps_lic_number = i_lic_number
         -- in (432155,432156,432157,432158)--
         ORDER BY 1, 2;

      l_cha_number   VARCHAR2 (5) := '%';
      v_dura         NUMBER := 0;
      v_cnt          NUMBER := 0;
      v_day_cnt      NUMBER := 0;

      CURSOR c_get_duration
      IS
         SELECT gen_refno,
                gen_title_working,
                gen_duration,
                gen_duration_c,
                gen_duration_s,
                lic_status,
                chs_short_name
           FROM fid_general, fid_license, fid_channel_service
          WHERE     lic_number = i_lic_number -- in (432155,432156,432157,432158) --= i_lic_number
                AND chs_number = lic_chs_number
                AND gen_refno = lic_gen_refno;

      r_dur          c_get_duration%ROWTYPE;

      /***********************************************************************************************/
      /*- Prime Time Type 'PTIN' where a programme that starts between prime time start and end time */
      /*- is considered prime time, except on the last minute. If programme start before start times */
      /*- and run into or over end time, it is  not a prime time run.                                */
      /***********************************************************************************************/
      CURSOR get_sch1
      IS
           SELECT sch_number,
                  cha_short_name,
                  sch_date,
                  ism_sch.sec2char (sch_time) con_time,
                  sch_time
             FROM fid_schedule, fid_channel
            WHERE sch_lic_number = i_lic_number --  in (432155,432156,432157,432158)--= i_lic_number
                                               AND sch_date <= i_to_period
                  AND (sch_time >= i_con_prime_time_start
                       AND sch_time < i_con_prime_time_end)
                  AND sch_cha_number LIKE l_cha_number
                  AND cha_number = sch_cha_number
         ORDER BY sch_date, sch_time;

      /***********************************************************************************************/
      /*- Prime Time Type 'PTDUR' where a programme that starts between prime time start and end time*/
      /*- is considered prime time, except on the last minute. If programme start before start time  */
      /*- and run over by 30 minutes or more, it is a prime time run.                                */
      /***********************************************************************************************/
      CURSOR get_sch2
      IS
         SELECT sch_number,
                cha_short_name,
                sch_date,
                ism_sch.sec2char (sch_time) con_time,
                sch_time
           FROM fid_schedule, fid_channel
          WHERE sch_lic_number = i_lic_number -- in (432155,432156,432157,432158)--= i_lic_number
                                             AND sch_date <= i_to_period
                AND (sch_time >= i_con_prime_time_start
                     AND sch_time < i_con_prime_time_end)
                AND sch_cha_number LIKE l_cha_number
                AND cha_number = sch_cha_number
         UNION
         SELECT sch_number,
                cha_short_name,
                sch_date,
                ism_sch.sec2char (sch_time) con_time,
                sch_time
           FROM fid_schedule, fid_channel
          WHERE sch_lic_number = i_lic_number -- in (432155,432156,432157,432158)--= i_lic_number
                                             AND sch_date <= i_to_period
                AND (sch_time < i_con_prime_time_start
                     AND (sch_time + v_dura) >=
                            (i_con_prime_time_start + 1800))
                AND sch_cha_number LIKE l_cha_number
                AND cha_number = sch_cha_number
         ORDER BY 3, 5;

      /***********************************************************************************************/
      /*- Count the number of prime time runs per day per service, if the limit specifies 'N', then  */
      /*- report on the licenses on the schedule that exceeds the limit of 1 pt a day/service.       */
      /***********************************************************************************************/
      CURSOR get_limit1
      IS
           SELECT COUNT (*) tot, sch_date
             FROM fid_schedule
            WHERE sch_lic_number = i_lic_number -- in (432155,432156,432157,432158)--= i_lic_number
                                               AND sch_date <= i_to_period
                  AND (sch_time >= i_con_prime_time_start
                       AND sch_time < i_con_prime_time_end)
         GROUP BY sch_date
           HAVING COUNT (*) > 1
         ORDER BY sch_date;

      CURSOR get_limit2
      IS
           SELECT COUNT (*) tot, sch_date
             FROM fid_schedule
            WHERE sch_lic_number = i_lic_number -- in (432155,432156,432157,432158)--= i_lic_number
                                               AND sch_date <= i_to_period
                  AND (sch_time >= i_con_prime_time_start
                       AND sch_time < i_con_prime_time_end)
         GROUP BY sch_date
           HAVING COUNT (*) > 1
         UNION
           SELECT COUNT (*) tot, sch_date
             FROM fid_schedule
            WHERE sch_lic_number = i_lic_number -- in (432155,432156,432157,432158)--= i_lic_number
                                               AND sch_date <= i_to_period
                  AND (sch_time < i_con_prime_time_start
                       AND (sch_time + v_dura) >=
                              (i_con_prime_time_start + 1800))
         GROUP BY sch_date
           HAVING COUNT (*) > 1
         ORDER BY 2;

      --l_cha_number number;
      l_message      VARCHAR2 (500);
      l_time_ended   DATE;
      l_line         VARCHAR2 (500);
      l_file         UTL_FILE.file_type;
   BEGIN
      /***********************************************************************************************/
      /*- Read contract to get prime time restriction rules                                          */
      /***********************************************************************************************/
      IF NVL (i_con_prime_time_start, 0) = 0
         AND NVL (i_con_prime_time_end, 0) = 0
      THEN
         RETURN;
      END IF;

      IF NVL (i_con_prime_time_type, ' ') = ' '
      THEN
         l_message := 'Contract has no prime time type';
         -- l_time_ended := TO_DATE(TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
         raise_application_error (-20601, l_message);
      END IF;

      OPEN c_get_duration;

      FETCH c_get_duration INTO r_dur;

      IF c_get_duration%NOTFOUND
      THEN
         l_message := 'License/Programme not found';
         --l_time_ended := TO_DATE( TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
         raise_application_error (-20601, l_message);
      ELSE
         CLOSE c_get_duration;

         IF NVL (r_dur.gen_duration, 0) = 0
         THEN
            v_dura := 0;
         ELSE
            v_dura := (r_dur.gen_duration / 25);
         END IF;
      END IF;

      /***********************************************************************************************/
      /*- Read rules to validate, ignore licenses in budget status.                                  */
      /***********************************************************************************************/
      v_cnt := 0;
      v_day_cnt := 0;

      FOR pt IN c_pt_rule
      LOOP
         v_cnt := 0;

         IF pt.lpc_cha_number IS NULL
         THEN
            l_cha_number := '%';
         ELSE
            l_cha_number := TO_CHAR (pt.lpc_cha_number);
         END IF;

         IF i_con_prime_time_type = 'PTIN'
         THEN
            FOR sch IN get_sch1
            LOOP
               v_cnt := v_cnt + 1;

               IF v_cnt > NVL (pt.max_runs, pt.tot_max_runs)
               THEN
                  o_error := 'Y';
                  l_line :=
                        i_lic_number
                     || ' '
                     || SUBSTR (r_dur.gen_title_working, 1, 50)
                     || ' on '
                     || sch.cha_short_name
                     || ' on '
                     || sch.sch_date
                     || ','
                     || sch.con_time
                     || ' exceeds max prime time runs of '
                     || NVL (pt.max_runs, pt.tot_max_runs);

                  -- UTL_FILE.put_line (i_file, l_line);
                  INSERT INTO fid_con_log (con_number, s_data)
                       VALUES (i_con_number, l_line);
               END IF;
            END LOOP;
         ELSIF i_con_prime_time_type = 'PTDUR'
         THEN
            FOR sch IN get_sch2
            LOOP
               v_cnt := v_cnt + 1;

               IF v_cnt > NVL (pt.max_runs, pt.tot_max_runs)
               THEN
                  o_error := 'Y';

                  /*UTL_FILE.put_line (i_file,
                                        i_lic_number
                                     || ' '
                                     || SUBSTR (r_dur.gen_title_working, 1,
                                                50)
                                     || ' on '
                                     || sch.cha_short_name
                                     || ' on '
                                     || sch.sch_date
                                     || ','
                                     || sch.con_time
                                     || ' exceeds max prime time runs of '
                                     || NVL (pt.max_runs, pt.tot_max_runs)
                                    ); */
                  INSERT INTO fid_con_log (con_number, s_data)
                       VALUES (
                                 i_con_number,
                                    i_lic_number
                                 || ' '
                                 || SUBSTR (r_dur.gen_title_working, 1, 50)
                                 || ' on '
                                 || sch.cha_short_name
                                 || ' on '
                                 || sch.sch_date
                                 || ','
                                 || sch.con_time
                                 || ' exceeds max prime time runs of '
                                 || NVL (pt.max_runs, pt.tot_max_runs));

                  NULL;
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      IF i_con_prime_time_pd_limit = 'Y'
      THEN
         IF i_con_prime_time_type = 'PTIN'
         THEN
            FOR lim IN get_limit1
            LOOP
               o_error := 'Y';

               /*UTL_FILE.put_line
                            (i_file,
                                i_lic_number
                             || ' '
                             || SUBSTR (r_dur.gen_title_working, 1, 50)
                             || ' on '
                             || lim.sch_date
                             || ','
                             || ' exceeds more than one run per day per service'
                            ); */
               INSERT INTO fid_con_log (con_number, s_data)
                    VALUES (
                              i_con_number,
                                 i_lic_number
                              || ' '
                              || SUBSTR (r_dur.gen_title_working, 1, 50)
                              || ' on '
                              || lim.sch_date
                              || ','
                              || ' exceeds more than one run per day per service');

               NULL;
            END LOOP;
         ELSIF i_con_prime_time_type = 'PTDUR'
         THEN
            FOR lim IN get_limit2
            LOOP
               o_error := 'Y';

               /*UTL_FILE.put_line
                            (i_file,
                                i_lic_number
                             || ' '
                             || SUBSTR (r_dur.gen_title_working, 1, 50)
                             || ' on '
                             || lim.sch_date
                             || ','
                             || ' exceeds more than one run per day per service'
                            ); */
               INSERT INTO fid_con_log (con_number, s_data)
                    VALUES (
                              i_con_number,
                                 i_lic_number
                              || ' '
                              || SUBSTR (r_dur.gen_title_working, 1, 50)
                              || ' on '
                              || lim.sch_date
                              || ','
                              || ' exceeds more than one run per day per service');

               NULL;
            END LOOP;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20111, SQLERRM);
   --<<thatsit>>
   -- NULL;
   END prc_validate_primetime;

   PROCEDURE prc_setup_pt (i_lic_number                IN NUMBER,
                           i_con_prime_time_start      IN NUMBER,
                           i_con_prime_time_end        IN NUMBER,
                           i_con_prime_max_runs_perc   IN NUMBER,
                           i_con_prime_max_runs        IN NUMBER,
                           i_con_prime_time_level      IN VARCHAR2 -- i_userid                    IN   VARCHAR2
                                                                  )
   AS
      /*-------------------------------------------------------------------------------*/
      /*--    Function   : Setup prime time tables from contract rules                 */
      /*-------------------------------------------------------------------------------*/
      l_perc         VARCHAR2 (1) := ' ';
      l_seq_lps      NUMBER := 0;
      l_seq_lpc      NUMBER := 0;
      l_max_runs     NUMBER := 0;
      l_table        VARCHAR2 (100) := ' ';

      CURSOR c_get_lcr
      IS
         SELECT lcr_lic_number, lcr_cha_number, lcr_runs_allocated
           FROM fid_license_channel_runs
          WHERE lcr_lic_number = i_lic_number;

      --in (432155,432156,432157,432158);-- = i_lic_number;
      CURSOR c_get_lic
      IS
         SELECT lic_amort_code,
                lic_showing_int,
                lic_chs_number,
                lic_con_number
           FROM fid_license
          WHERE lic_number = i_lic_number;

      --in (432155,432156,432157,432158);-- = i_lic_number;
      r_lic          c_get_lic%ROWTYPE;
      l_message      VARCHAR2 (500);
      l_time_ended   DATE;
   BEGIN
      /******************************************************************************************/
      /*- Read license and then contract to get prime time restriction rules                    */
      /******************************************************************************************/
      OPEN c_get_lic;

      FETCH c_get_lic INTO r_lic;

      CLOSE c_get_lic;

      /************************************/
      /*- Return if no times are loaded   */
      /************************************/
      IF NVL (i_con_prime_time_start, 0) = 0
         AND NVL (i_con_prime_time_end, 0) = 0
      THEN
         l_message :=
            'No validation can be done, because there is no prime start and end time';
         RETURN;
      END IF;

      IF NVL (i_con_prime_max_runs_perc, 0) = 0
         AND NVL (i_con_prime_max_runs, 0) > 0
      THEN
         l_perc := 'N';
      ELSIF NVL (i_con_prime_max_runs_perc, 0) > 0
            AND NVL (i_con_prime_max_runs, 0) = 0
      THEN
         l_perc := 'Y';
      ELSIF NVL (i_con_prime_max_runs_perc, 0) = 0
            AND NVL (i_con_prime_max_runs, 0) = 0
      THEN
         l_perc := 'N';
      ELSIF NVL (i_con_prime_max_runs_perc, 0) > 0
            AND NVL (i_con_prime_max_runs, 0) > 0
      THEN
         l_message :=
            'Max runs and percentage is entered, only use one of them';
         -- l_time_ended := TO_DATE(TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
         raise_application_error (-20601, l_message);
      END IF;

      /**************************************************************************************/
      /*- Delete excisting PT records for license                                           */
      /**************************************************************************************/
      BEGIN
         DELETE FROM fid_license_pt_service
               WHERE lps_lic_number = i_lic_number;

         DELETE FROM fid_license_pt_channel
               WHERE lpc_lic_number = i_lic_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      /**************************************************************************************/
      /*- Leave the max runs on the service table null for new b/rule, because it goes down */
      /*- to channel level.                                                                 */
      /**************************************************************************************/
      l_max_runs := 0;
      DBMS_OUTPUT.put_line ('r_lic.lic_amort_code ' || r_lic.lic_amort_code);

      IF r_lic.lic_amort_code = 'D'
      THEN
         IF NVL (i_con_prime_time_level, ' ') = 'SRVCE'
         THEN
            IF l_perc = 'Y'
            THEN
               l_max_runs :=
                  TRUNC (
                     NVL (r_lic.lic_showing_int, 0)
                     * (i_con_prime_max_runs_perc / 100));
            ELSE
               l_max_runs := NVL (i_con_prime_max_runs, 0);
            END IF;
         ELSE
            l_max_runs := NULL;
         END IF;
      ELSE
         IF l_perc = 'Y'
         THEN
            l_max_runs :=
               TRUNC (
                  NVL (r_lic.lic_showing_int, 0)
                  * (i_con_prime_max_runs_perc / 100));
         ELSE
            l_max_runs := NVL (i_con_prime_max_runs, 0);
         END IF;
      END IF;

      DBMS_OUTPUT.put_line ('l_max_runs ' || l_max_runs);

      /******************************************************************************************/
      /*- Insert fid_license_pt_service and channel when amort code ='D' and level channel,     */
      /*- else only service.                                                                    */
      /******************************************************************************************/
      BEGIN
         SELECT seq_lps_number.NEXTVAL INTO l_seq_lps FROM DUAL;

         l_table := 'FID_LICENSE_PT_SERVICE';

         INSERT INTO fid_license_pt_service (lps_number,
                                             lps_lic_number,
                                             lps_chs_number,
                                             lps_max_runs,
                                             lps_entry_date,
                                             lps_is_deleted,
                                             lps_update_count --, lps_entry_oper
                                                             )
              VALUES (l_seq_lps,
                      i_lic_number,
                      r_lic.lic_chs_number,
                      l_max_runs,
                      SYSDATE,
                      0,
                      0                                           --, i_userid
                       );

         DBMS_OUTPUT.put_line (
               l_seq_lps
            || ','
            || i_lic_number
            || ','
            || r_lic.lic_chs_number
            || ','
            || l_max_runs);

         IF r_lic.lic_amort_code = 'D'
            AND NVL (i_con_prime_time_level, ' ') = 'CHANL'
         THEN
            l_table := 'FID_LICENSE_PT_CHANNEL';

            FOR r_lcr IN c_get_lcr
            LOOP
               l_max_runs := 0;

               IF l_perc = 'Y'
               THEN
                  l_max_runs :=
                     TRUNC (
                        NVL (r_lcr.lcr_runs_allocated, 0)
                        * (i_con_prime_max_runs_perc / 100));
               ELSE
                  l_max_runs := NVL (i_con_prime_max_runs, 0);
               END IF;

               SELECT seq_lpc_number.NEXTVAL INTO l_seq_lpc FROM DUAL;

               INSERT INTO fid_license_pt_channel (lpc_number,
                                                   lpc_lps_number,
                                                   lpc_lic_number,
                                                   lpc_cha_number,
                                                   lpc_max_runs,
                                                   lpc_entry_date,
                                                   lpc_is_deleted,
                                                   lpc_update_count --,lpc_entry_oper
                                                                   )
                    VALUES (l_seq_lpc,
                            l_seq_lps,
                            i_lic_number,
                            r_lcr.lcr_cha_number,
                            l_max_runs,
                            SYSDATE,
                            0,
                            0                                      --,i_userid
                             );

               DBMS_OUTPUT.put_line (
                     l_seq_lpc
                  || ','
                  || i_lic_number
                  || ','
                  || r_lcr.lcr_cha_number
                  || ','
                  || l_max_runs);
            END LOOP;
         END IF;

         COMMIT;
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            l_message := 'Duplicate on ' || l_table;
            -- l_time_ended := TO_DATE(TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
            raise_application_error (-20601, l_message);
         WHEN VALUE_ERROR
         THEN
            l_message := 'Value error on ' || l_table;
            --  l_time_ended := TO_DATE(TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
            raise_application_error (-20601, l_message);
         WHEN OTHERS
         THEN
            l_message := 'Some error on ' || l_table;
            -- l_time_ended := TO_DATE(TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
            raise_application_error (-20601, l_message);
      END;
   END prc_setup_pt;

   PROCEDURE prc_delete_pt (i_lic_number IN NUMBER)
   AS
   BEGIN
      DELETE FROM fid_license_pt_service
            WHERE lps_lic_number = i_lic_number;

      DELETE FROM fid_license_pt_channel
            WHERE lpc_lic_number = i_lic_number;

      COMMIT;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         raise_application_error (-20112, SQLERRM);
   END prc_delete_pt;

   --Dev2: Rand Devaulation :Start:[FIN 34- Rand Devaluation info]_[Sushma K]_[2014/06/10]
   --This procedure is used to store/update the rand devaluation info details contract wise.
   PROCEDURE prc_insert_rd_info (
      I_CON_NUMBER           IN     x_rand_devaluation_info.rdi_con_number%TYPE,
      I_BENCH_MARK_FLAG      IN     x_rand_devaluation_info.rdi_bench_mark_flag%TYPE,
      I_BM_UPPER             IN     x_rand_devaluation_info.rdi_bm_lower%TYPE,
      I_BM_LOWER             IN     x_rand_devaluation_info.rdi_bm_lower%TYPE,
      I_BM_REFERENCE         IN     x_rand_devaluation_info.rdi_bm_reference%TYPE,
      I_BM_DEVIATION         IN     x_rand_devaluation_info.rdi_bm_deviation%TYPE,
      I_SHARE_SUP            IN     x_rand_devaluation_info.rdi_share_sup%TYPE,
      I_DISCOUNT_THRESHOLD   IN     x_rand_devaluation_info.rdi_discount_threshold%TYPE,
      I_EXH_RATE_SOURCE      IN     x_rand_devaluation_info.rdi_exh_rate_source%TYPE,
      I_REVIEW_DATE_CALC     IN     x_rand_devaluation_info.rdi_review_date_calc%TYPE,
      I_FIXED_DATE           IN     VARCHAR2, --x_rand_devaluation_info.rdi_fixed_date%TYPE,
      I_PAY_MONTH_1          IN     x_rand_devaluation_info.rdi_pay_month_1%TYPE,
      I_LAST_DAY_FLAG        IN     x_rand_devaluation_info.rdi_last_day_flag%TYPE,
      I_PAY_MONTH_2          IN     x_rand_devaluation_info.rdi_pay_month_2%TYPE,
      I_NO_PAST_MON          IN     x_rand_devaluation_info.rdi_no_past_mon%TYPE,
      I_ACC_TYPE             IN     x_rand_devaluation_info.rdi_acc_type%TYPE,
      I_SELECT_MON           IN     x_rand_devaluation_info.rdi_select_mon%TYPE,
      I_ACC_FLAG             IN     x_rand_devaluation_info.rdi_acc_flag%TYPE,
      I_IS_SUNDAY_HOLIDAY    IN     x_rand_devaluation_info.rdi_is_sunday_holiday%TYPE,
      I_ENTRY_OPER           IN     x_rand_devaluation_info.rdi_entry_oper%TYPE,
      -- I_ENTRY_DATE              IN   x_rand_devaluation_info.rdi_entry_date%TYPE,
      -- I_MODIFY_BY               IN   x_rand_devaluation_info.rdi_modify_by%TYPE,
      --I_MODIFY_ON               IN   x_rand_devaluation_info.rdi_modify_on%TYPE,
      -- I_DEVALUATION_FLAG        IN   x_rand_devaluation_info.rdi_DEVALUATION_FLAG%TYPE,
      O_DATA_INSERTED           OUT NUMBER)
   AS
      l_con_exist          NUMBER;
      l_rowcount           NUMBER;
      L_RDI_NUMBER         NUMBER;
      l_rdi_count          NUMBER;
      L_DEVALUATION_FLAG   VARCHAR2 (1);
   BEGIN
      --NULL;
      SELECT COUNT (1)
        INTO l_con_exist
        FROM X_RAND_DEVALUATION_INFO
       WHERE rdi_con_number = I_CON_NUMBER;

      IF l_con_exist = 0
      THEN
         SELECT NVL (CON_DEVALUATION_FLAG, 'N')
           INTO L_DEVALUATION_FLAG
           FROM fid_contract
          WHERE CON_NUMBER = I_CON_NUMBER;

         IF L_DEVALUATION_FLAG = 'Y'
         THEN
            L_RDI_NUMBER := x_seq_rd_info.NEXTVAL;

            INSERT INTO X_RAND_DEVALUATION_INFO (RDI_NUMBER,
                                                 RDI_CON_NUMBER,
                                                 RDI_BENCH_MARK_FLAG,
                                                 RDI_BM_UPPER,
                                                 RDI_BM_LOWER,
                                                 RDI_BM_REFERENCE,
                                                 RDI_BM_DEVIATION,
                                                 RDI_SHARE_SUP,
                                                 RDI_DISCOUNT_THRESHOLD,
                                                 RDI_EXH_RATE_SOURCE,
                                                 RDI_REVIEW_DATE_CALC,
                                                 RDI_FIXED_DATE,
                                                 RDI_PAY_MONTH_1,
                                                 RDI_LAST_DAY_FLAG,
                                                 RDI_PAY_MONTH_2,
                                                 RDI_NO_PAST_MON,
                                                 RDI_ACC_TYPE,
                                                 RDI_SELECT_MON,
                                                 RDI_ACC_FLAG,
                                                 RDI_IS_SUNDAY_HOLIDAY,
                                                 RDI_ENTRY_OPER,
                                                 RDI_ENTRY_DATE,
                                                 RDI_MODIFY_BY,
                                                 RDI_MODIFY_ON,
                                                 RDI_UPDATE_COUNT --RDI_DEVALUATION_FLAG
                                                                 )
                 VALUES (L_RDI_NUMBER,                --x_seq_rd_info.nextval,
                         I_CON_NUMBER,
                         I_BENCH_MARK_FLAG,
                         I_BM_UPPER,
                         I_BM_LOWER,
                         I_BM_REFERENCE,
                         I_BM_DEVIATION,
                         I_SHARE_SUP,
                         I_DISCOUNT_THRESHOLD,
                         I_EXH_RATE_SOURCE,
                         I_REVIEW_DATE_CALC,
                         TO_DATE (I_FIXED_DATE, 'DD-MM-YYYY'),
                         I_PAY_MONTH_1,
                         I_LAST_DAY_FLAG,
                         I_PAY_MONTH_2,
                         I_NO_PAST_MON,
                         I_ACC_TYPE,
                         I_SELECT_MON,
                         I_ACC_FLAG,
                         I_IS_SUNDAY_HOLIDAY,
                         I_ENTRY_OPER,
                         SYSDATE,
                         NULL,                                  --I_MODIFY_BY,
                         NULL,                                  --I_MODIFY_ON,
                         0                           --     I_DEVALUATION_FLAG
                          );

            IF I_SELECT_MON IS NOT NULL
            THEN
               FOR i
                  IN (SELECT TO_CHAR (
                                ADD_MONTHS (
                                   TO_DATE (
                                      I_SELECT_MON
                                      || TO_CHAR (SYSDATE, 'YYYY'),
                                      'Monthyyyy'),
                                   ROWNUM),
                                'Mon')
                                FROMMONTH,
                             ROWNUM FROMNO
                        FROM user_objects
                       WHERE ADD_MONTHS (
                                TO_DATE (
                                   I_SELECT_MON || TO_CHAR (SYSDATE, 'YYYY'),
                                   'Monthyyyy'),
                                ROWNUM) <
                                ADD_MONTHS (
                                   TO_DATE (
                                      I_SELECT_MON
                                      || TO_CHAR (SYSDATE, 'YYYY'),
                                      'Monthyyyy'),
                                   13))
               LOOP
                  BEGIN
                     DBMS_OUTPUT.PUT_LINE (
                        L_RDI_NUMBER || ',' || I.FROMNO || ',' || I.FROMMONTH);

                     INSERT
                       INTO x_rd_acc_month_info (RDAM_RDI_NUMBER,
                                                 RDAM_MONTH_NO,
                                                 RDAM_MONTH_NAME)
                     VALUES (L_RDI_NUMBER, I.FROMNO, I.FROMMONTH);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        DBMS_OUTPUT.PUT_LINE (SQLERRM);
                  END;
               END LOOP;
            END IF;
         END IF;
      ELSE
         SELECT rdi_number
           INTO L_RDI_NUMBER
           FROM X_RAND_DEVALUATION_INFO
          WHERE RDI_CON_NUMBER = I_CON_NUMBER;


         DBMS_OUTPUT.PUT_LINE ('L_RDI_NUMBER' || L_RDI_NUMBER);

         SELECT COUNT (1)
           INTO l_rdi_count
           FROM x_rd_acc_month_info
          WHERE RDAM_RDI_NUMBER = L_RDI_NUMBER;

         DBMS_OUTPUT.PUT_LINE ('l_rdi_count' || l_rdi_count);


         IF I_SELECT_MON IS NOT NULL
         THEN
            FOR i
               IN (SELECT TO_CHAR (
                             ADD_MONTHS (
                                TO_DATE (
                                   I_SELECT_MON || TO_CHAR (SYSDATE, 'YYYY'),
                                   'Monthyyyy'),
                                ROWNUM),
                             'Mon')
                             FROMMONTH,
                          ROWNUM FROMNO
                     FROM user_objects
                    WHERE ADD_MONTHS (
                             TO_DATE (
                                I_SELECT_MON || TO_CHAR (SYSDATE, 'YYYY'),
                                'Monthyyyy'),
                             ROWNUM) <
                             ADD_MONTHS (
                                TO_DATE (
                                   I_SELECT_MON || TO_CHAR (SYSDATE, 'YYYY'),
                                   'Monthyyyy'),
                                13))
            LOOP
               BEGIN
                  DBMS_OUTPUT.PUT_LINE (
                     L_RDI_NUMBER || ',' || I.FROMNO || ',' || I.FROMMONTH);

                  IF l_rdi_count = 0
                  THEN
                     INSERT
                       INTO x_rd_acc_month_info (RDAM_RDI_NUMBER,
                                                 RDAM_MONTH_NO,
                                                 RDAM_MONTH_NAME)
                     VALUES (L_RDI_NUMBER, I.FROMNO, I.FROMMONTH);
                  ELSE
                     UPDATE x_rd_acc_month_info
                        SET RDAM_MONTH_NO = I.FROMNO,
                            RDAM_MONTH_NAME = I.FROMMONTH
                      WHERE RDAM_RDI_NUMBER = L_RDI_NUMBER
                            AND RDAM_MONTH_NO = I.FROMNO;
                  END IF;
               /* INSERT INTO x_rd_acc_month_info(RDAM_RDI_NUMBER,
                                                RDAM_MONTH_NO,
                                                RDAM_MONTH_NAME)
                                        values (L_RDI_NUMBER,
                                                I.FROMNO,
                                                I.FROMMONTH
                                                );*/

               EXCEPTION
                  WHEN OTHERS
                  THEN
                     DBMS_OUTPUT.PUT_LINE (SQLERRM);
               END;
            END LOOP;
         END IF;

         UPDATE X_RAND_DEVALUATION_INFO
            SET RDI_BENCH_MARK_FLAG = I_BENCH_MARK_FLAG,
                RDI_BM_UPPER = I_BM_UPPER,
                RDI_BM_LOWER = I_BM_LOWER,
                RDI_BM_REFERENCE = I_BM_REFERENCE,
                RDI_BM_DEVIATION = I_BM_DEVIATION,
                RDI_SHARE_SUP = I_SHARE_SUP,
                RDI_DISCOUNT_THRESHOLD = I_DISCOUNT_THRESHOLD,
                RDI_EXH_RATE_SOURCE = I_EXH_RATE_SOURCE,
                RDI_REVIEW_DATE_CALC = I_REVIEW_DATE_CALC,
                RDI_FIXED_DATE = TO_DATE (I_FIXED_DATE, 'DD-MM-YYYY'),
                RDI_PAY_MONTH_1 = I_PAY_MONTH_1,
                RDI_LAST_DAY_FLAG = I_LAST_DAY_FLAG,
                RDI_PAY_MONTH_2 = I_PAY_MONTH_2,
                RDI_NO_PAST_MON = I_NO_PAST_MON,
                RDI_ACC_TYPE = I_ACC_TYPE,
                RDI_SELECT_MON = I_SELECT_MON,
                RDI_ACC_FLAG = I_ACC_FLAG,
                RDI_IS_SUNDAY_HOLIDAY = I_IS_SUNDAY_HOLIDAY,
                RDI_MODIFY_BY = I_ENTRY_OPER,
                RDI_MODIFY_ON = SYSDATE,
                RDI_UPDATE_COUNT = RDI_UPDATE_COUNT + 1
          -- RDI_DEVALUATION_FLAG  = I_DEVALUATION_FLAG
          WHERE RDI_CON_NUMBER = I_CON_NUMBER;
      /*ELSE
       prc_rd_con_delete(I_CON_NUMBER);   */
      END IF;

      --END IF;

      IF SQL%ROWCOUNT > 0
      THEN
         COMMIT;
         O_DATA_INSERTED := 1;
      ELSE
         O_DATA_INSERTED := 0;
      END IF;
   END prc_insert_rd_info;

   ----This procedure is used to get the rand devaluation info for particular contract
   PROCEDURE prc_rd_con_search (
      i_con_number       IN     NUMBER,
      O_con_rd_details      OUT pkg_acon_cm_contract_maint.c_contracts_cursor)
   AS
   BEGIN
      OPEN O_con_rd_details FOR
         SELECT rd.*, a.CON_DEVALUATION_FLAG
           FROM X_RAND_DEVALUATION_INFO rd, fid_contract a
          WHERE rdi_con_number = con_number AND rdi_con_number = i_con_number;
   END prc_rd_con_search;

   PROCEDURE prc_rd_con_delete (i_con_number IN NUMBER)
   AS
   BEGIN
      DELETE FROM X_RAND_DEVALUATION_INFO
            WHERE rdi_con_number = i_con_number;
   END prc_rd_con_delete;

   --Dev2: Rand Devaulation :End

   --ACQ:CACQ14 :Start:[Sushma K]_[2014/10/14]

	PROCEDURE prc_add_con_medplatmdevcomp (
		i_con_number           IN     fid_contract.con_number%TYPE,
		i_MPDC_DEV_PLATM_ID    IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_DEV_PLATM_ID%TYPE,
		i_rights_on_device     IN     VARCHAR2,
		i_IS_FEA_SER           IN     x_cp_con_medplatmdevcompat_map.CON_IS_FEA_SER%TYPE,
		i_med_comp_rights      IN     VARCHAR2, --x_cp_med_platm_dev_compat_map.MPDC_COMP_RIGHTS%type,
		i_med_IS_COMP_RIGHTS   IN     VARCHAR2, --x_cp_med_platm_dev_compat_map.MPDC_IS_COMP_RIGHTS%type,
		i_entry_oper           IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_ENTRY_OPER%TYPE,
		i_con_catchup_flag     IN     fid_Contract.con_catchup_flag%TYPE,
		o_status                  OUT NUMBER)
	AS
		con_exist        NUMBER;
		l_CON_MPDC_ID    NUMBER;
		l_flag           NUMBER;
		l_lic_present    NUMBER;
		l_con_count      NUMBER;
		l_dm_device_cnt	 NUMBER;
		l_catchup_flag   SGY_PB_MEDIA_SERVICE.MS_MEDIA_SERVICE_CODE%TYPE;
	BEGIN
		select MS_MEDIA_SERVICE_CODE
		into l_catchup_flag
		from SGY_PB_MEDIA_SERVICE
		where MS_MEDIA_SERVICE_FLAG = i_con_catchup_flag;

		FOR i
		IN (	select a.med_comp_rights,b.med_IS_COMP_RIGHTS
				From
				(SELECT COLUMN_VALUE med_comp_rights, ROWNUM r
									From Table (
									Pkg_Pb_Media_Plat_Ser.Split_To_Char (i_med_comp_rights,','))
				) a
				,(SELECT COLUMN_VALUE med_IS_COMP_RIGHTS, ROWNUM r
									From Table (
									Pkg_Pb_Media_Plat_Ser.Split_To_Char (i_med_IS_COMP_RIGHTS,','))
				) B
				where a.r = b.r
			)
		LOOP
			l_CON_MPDC_ID := X_SEQ_CON_MPDC_ID.NEXTVAL;

			SELECT COUNT (1)
			INTO l_con_count
			FROM x_cp_con_medplatmdevcompat_map
			WHERE  CON_CONTRACT_NUMBER = i_con_number
			AND CON_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID
			AND CON_MPDC_COMP_RIGHTS_ID = i.med_comp_rights
			AND CON_IS_FEA_SER = i_IS_FEA_SER;

			IF l_con_count = 0
			THEN
				INSERT
				INTO x_cp_con_medplatmdevcompat_map (
						CON_MPDC_ID,
						CON_CONTRACT_NUMBER,
						CON_MPDC_DEV_PLATM_ID,
						CON_RIGHTS_ON_DEVICE,
						CON_MPDC_COMP_RIGHTS_ID,
						CON_IS_COMP_RIGHTS,
						CON_IS_FEA_SER,
						CON_MPDC_ENTRY_OPER,
						CON_MPDC_ENTRY_DATE,
						CON_MPDC_UPDATE_COUNT,
						CON_MPDC_SERVICE_CODE)
				VALUES (l_CON_MPDC_ID,
						i_con_number,
						i_MPDC_DEV_PLATM_ID,
						i_rights_on_device,
						i.med_comp_rights,
						i.med_IS_COMP_RIGHTS,
						i_IS_FEA_SER,
						i_entry_oper,
						SYSDATE,
						0,
						l_catchup_flag);
			else
				UPDATE x_cp_con_medplatmdevcompat_map
				SET CON_RIGHTS_ON_DEVICE = i_rights_on_device,
					CON_IS_COMP_RIGHTS = i.med_IS_COMP_RIGHTS,
					CON_MPDC_MODIFIED_BY = i_entry_oper,
					CON_MPDC_MODIFIED_ON = SYSDATE
				WHERE  CON_CONTRACT_NUMBER = i_con_number
				AND CON_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID
				AND CON_IS_FEA_SER = i_IS_FEA_SER
				AND CON_MPDC_COMP_RIGHTS_ID = i.med_comp_rights
				;
			END IF;

			FOR k
			IN (SELECT MEM_ID, MEI_ID, ALD_ID
				FROM sak_memo,
					 fid_contract,
					 sak_memo_item,
					 sak_allocation_detail
				WHERE     mem_id = MEI_MEM_ID
					 AND ALD_MEI_ID = MEI_ID
					 AND MEM_CON_NUMBER = con_number
					 AND mem_con_number = i_con_number
					 AND mem_status not in ('EXECUTED','NCFExecuted')
					 AND CON_CATCHUP_FLAG = i_con_catchup_flag --in ('Y','S')  -- 19/03/15 for SVOD added 'S'
					 AND X_FNC_GET_PROG_TYPE (MEI_TYPE_SHOW) = decode(i_IS_FEA_SER,'SER','Y','N')
				)
			LOOP
				select count(1)
				into l_dm_device_cnt
				from x_cp_memo_medplatdevcompat_map
				WHERE MEM_MPDC_ALD_ID = k.ALD_ID
				AND MEM_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
				AND MEM_MPDC_COMP_RIGHTS_ID = i.med_comp_rights
				;
				if l_dm_device_cnt = 0
				then
					Insert Into X_Cp_Memo_Medplatdevcompat_Map
					(
						MEM_MPDC_ID
						,Mem_Mpdc_Ald_Id
						,MEM_MPDC_DEV_PLATM_ID
						,Mem_Rights_On_Device
						,MEM_MPDC_COMP_RIGHTS_ID
						,Mem_Is_Comp_Rights
						,MEM_MPDC_ENTRY_OPER
						,Mem_Mpdc_Entry_Date
						,Mem_Mpdc_Update_Count
						,Mem_Mpdc_Service_Code
					)
					Values
					(	X_SEQ_MEM_MPDC_ID.NEXTVAL
						,k.ALD_ID
						,i_mpdc_dev_platm_id
						,i_rights_on_device
						,i.med_comp_rights
						,i.med_IS_COMP_RIGHTS
						,i_entry_oper
						,SYSDATE
						,0
						,l_catchup_flag
					);
				else
					UPDATE x_cp_memo_medplatdevcompat_map
					SET MEM_RIGHTS_ON_DEVICE = i_rights_on_device,
						MEM_IS_COMP_RIGHTS = i.med_IS_COMP_RIGHTS,
						MEM_MPDC_MODIFIED_BY = i_entry_oper,
						MEM_MPDC_MODIFIED_ON = SYSDATE,
						MEM_MPDC_UPDATE_COUNT = MEM_MPDC_UPDATE_COUNT + 1
					WHERE MEM_MPDC_ALD_ID = k.ALD_ID
					AND MEM_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
					AND MEM_MPDC_COMP_RIGHTS_ID = i.med_comp_rights
					;
				end if;
			END LOOP;

			FOR j
			IN (SELECT lic_number
				FROM fid_license,
					fid_contract,
					fid_licensee,
					fid_general
				WHERE lic_con_number = con_number
				AND lic_status = 'A'
				AND NVL (lic_catchup_flag, 'N') =  i_con_catchup_flag -- added on 23/03/2015 -- to check SVOD flag also
				AND con_number = i_con_number
				AND gen_refno = lic_gen_refno
				AND lic_lee_number = lee_number
				AND X_FNC_GET_PROG_TYPE (lic_budget_code) = decode(i_IS_FEA_SER,'SER','Y','N')
				)
			LOOP
				SELECT COUNT (*)
				INTO l_lic_present
				FROM x_cp_lic_medplatmdevcompat_map
				WHERE     LIC_MPDC_LIC_NUMBER = j.lic_number
				AND LIC_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
				AND LIC_MPDC_COMP_RIGHTS_ID = i.med_comp_rights
				;
				--raise_application_error (-20600, 'l_lic_present ' || l_lic_present);
				 IF l_lic_present = 0
				 THEN
					INSERT INTO x_cp_lic_medplatmdevcompat_map
					(  LIC_MPDC_ID,
					   LIC_MPDC_LIC_NUMBER,
					   LIC_MPDC_DEV_PLATM_ID,
					   LIC_RIGHTS_ON_DEVICE,
					   LIC_MPDC_COMP_RIGHTS_ID,
					   LIC_IS_COMP_RIGHTS,
					   LIC_MPDC_ENTRY_OPER,
					   LIC_MPDC_ENTRY_DATE,
					   LIC_MPDC_MODIFIED_BY,
					   LIC_MPDC_MODIFIED_ON,
					   LIC_MPDC_UPDATE_COUNT,
					   LIC_MPDC_SERVICE_CODE
					)
					values
					(	X_SEQ_LIC_MPDC_ID.NEXTVAL,
						j.lic_number,
						I_Mpdc_Dev_Platm_Id,
						i_rights_on_device,
						i.med_comp_rights,
						'N',
						i_entry_oper,
						SYSDATE,
						NULL,
						NULL,
						0,
						l_catchup_flag
					);
				 ELSE
					UPDATE x_cp_lic_medplatmdevcompat_map
					SET LIC_RIGHTS_ON_DEVICE = i_rights_on_device,
						LIC_IS_COMP_RIGHTS = decode(i.med_IS_COMP_RIGHTS,'N','N',LIC_IS_COMP_RIGHTS),
						LIC_MPDC_MODIFIED_BY = i_entry_oper,
						LIC_MPDC_MODIFIED_ON = SYSDATE,
						LIC_MPDC_UPDATE_COUNT =	LIC_MPDC_UPDATE_COUNT + 1
					WHERE LIC_MPDC_LIC_NUMBER = j.lic_number
					AND LIC_MPDC_DEV_PLATM_ID =	i_mpdc_dev_platm_id
					AND LIC_MPDC_COMP_RIGHTS_ID = i.med_comp_rights
					;
				END IF;
			END LOOP;
		END LOOP;
		COMMIT;
        o_status := 1;
	END prc_add_con_medplatmdevcomp;
   /*procedure prc_update_rights_on_device
   (
     i_rights_on_device_fea      IN    x_cp_con_medplatmdevcompat_map.CON_RIGHTS_ON_DEVICE%TYPE,
     i_rights_on_device_ser      IN    x_cp_con_medplatmdevcompat_map.CON_RIGHTS_ON_DEVICE%TYPE,
     i_med_comp_is_rights_fea    IN    varchar2,
     i_med_comp_is_rights_ser    IN    varchar2,
     i_con_number                IN    fid_contraCT.CON_NUMBER%TYPE,
     i_mpdc_dev_platm_id         IN    NUMBER,
     i_entryoper                 IN    fid_contract.con_entry_oper%type
   )
   AS
    l_rights_on_device_fea    VARCHAR2(1);
    l_rights_on_device_ser    VARCHAR2(1);
    l_med_device              VARCHAR2(50);
    l_med_platm_code          VARCHAR2(50);
    l_device_rights_fea       VARCHAR2(50);
    l_device_rights_ser       VARCHAR2(50);
   BEGIN

    --CACQ14:Start:SUSHMA K on 28-10-2014
              select MDP_MAP_DEV_CODE,MDP_MAP_PLATM_CODE
                  INTO l_med_device,l_med_platm_code
                 from x_cp_media_dev_platm_map
                 where MDP_MAP_ID = i_mpdc_dev_platm_id;

            --Validation for rights on device feild For Fea(Features)
              select distinct CON_RIGHTS_ON_DEVICE INTO l_rights_on_device_fea
               from X_CP_CON_MEDPLATMDEVCOMPAT_MAP
              where CON_CONTRACT_NUMBER = i_con_number
              and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
              and   CON_IS_FEA_SER = 'FEA';

            IF i_rights_on_device_fea = 'Y'  and l_rights_on_device_fea = 'N'
            THEN
              for i in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_fea,',')) )
              LOOP
                   UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                      set CON_RIGHTS_ON_DEVICE = i_rights_on_device_fea,
                          CON_IS_COMP_RIGHTS =  i.column_value,
                          CON_MPDC_MODIFIED_BY = i_entryoper,
                          CON_MPDC_MODIFIED_ON = sysdate,
                          CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
                   where CON_CONTRACT_NUMBER = i_con_number
                   and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
                   and   CON_IS_FEA_SER  = 'FEA';
               end loop;
                --NEED TO UPDATE THE RESPECTIVE CATCH UP LICNESE OF THE CONTRACT  (Check the rights on device on all the catch up licenses of that contract)
               For i in (   SELECT    lic_number
                              FROM fid_license, fid_contract, fid_licensee, fid_general
                             WHERE lic_con_number = con_number
                               AND lic_status = 'A'
                               AND NVL (lic_catchup_flag, 'N') = 'Y'
                               AND con_number = i_con_number
                               AND gen_refno = lic_gen_refno
                               AND lic_lee_number = lee_number
                               AND lic_budget_code <> 'SER' )
                 LOOP
                    for j in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_fea,',')) )
                    LOOP
                        update x_cp_lic_medplatmdevcompat_map
                        set LIC_RIGHTS_ON_DEVICE  = i_rights_on_device_fea,
                        LIC_MPDC_COMP_RIGHTS      = j.column_value,
                        LIC_MPDC_MODIFIED_BY    =  i_entryoper,
                        LIC_MPDC_MODIFIED_ON   =  sysdate,
                        LIC_MPDC_UPDATE_COUNT = LIC_MPDC_UPDATE_COUNT + 1
                       where LIC_MPDC_LIC_NUMBER = i.lic_number
                       and   LIC_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id;
                   END LOOP;
                 END LOOP;

            elsiF i_rights_on_device_fea = 'N'  and l_rights_on_device_fea = 'Y'
            THEN
                  UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                    set CON_RIGHTS_ON_DEVICE = i_rights_on_device_fea,
                        CON_IS_COMP_RIGHTS = 'N',
                        CON_MPDC_MODIFIED_BY = i_entryoper,
                        CON_MPDC_MODIFIED_ON = sysdate,
                        CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
                 where CON_CONTRACT_NUMBER = i_con_number
                  and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
                 and   CON_IS_FEA_SER  = 'FEA' ;

                 --NEED TO UPDATE THE RESPECTIVE CATCH UP LICNESE OF THE CONTRACT  (un Check the rights on device and device rights on all the catch up licenses of that contract)
                For i in (   SELECT    lic_number
                              FROM fid_license, fid_contract, fid_licensee, fid_general
                             WHERE lic_con_number = con_number
                               AND lic_status = 'A'
                               AND NVL (lic_catchup_flag, 'N') = 'Y'
                               AND con_number = i_con_number
                               AND gen_refno = lic_gen_refno
                               AND lic_lee_number = lee_number
                               AND lic_budget_code <> 'SER' )
                 LOOP
                        update x_cp_lic_medplatmdevcompat_map
                        set LIC_RIGHTS_ON_DEVICE  = i_rights_on_device_fea,
                        LIC_MPDC_COMP_RIGHTS      = 'N',
                        LIC_MPDC_MODIFIED_BY    =  i_entryoper,
                        LIC_MPDC_MODIFIED_ON   =  sysdate,
                        LIC_MPDC_UPDATE_COUNT = LIC_MPDC_UPDATE_COUNT + 1
                       where LIC_MPDC_LIC_NUMBER = i.lic_number
                       and   LIC_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id;
                   END LOOP;
            END IF;

             --Validation for rights on device feild For SER(Series)
            select CON_RIGHTS_ON_DEVICE INTO l_rights_on_device_ser
               from X_CP_CON_MEDPLATMDEVCOMPAT_MAP
              where CON_CONTRACT_NUMBER = i_con_number
              and   CON_IS_FEA_SER = 'SER';

           IF i_rights_on_device_ser = 'Y'  and l_rights_on_device_ser = 'N'
           THEN
              for i in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_ser,',')) )
              LOOP
                   UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                      set CON_RIGHTS_ON_DEVICE = i_rights_on_device_ser,
                          CON_IS_COMP_RIGHTS =  i.column_value,
                          CON_MPDC_MODIFIED_BY = i_entryoper,
                          CON_MPDC_MODIFIED_ON = sysdate,
                          CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
                   where CON_CONTRACT_NUMBER = i_con_number
                    and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
                   and   CON_IS_FEA_SER  = 'SER';
               end loop;
          --NEED TO UPDATE THE RESPECTIVE CATCH UP LICNESE OF THE CONTRACT  (Check the rights on device on all the catch up licenses of that contract)
               For i in (   SELECT    lic_number
                              FROM fid_license, fid_contract, fid_licensee, fid_general
                             WHERE lic_con_number = con_number
                               AND lic_status = 'A'
                               AND NVL (lic_catchup_flag, 'N') = 'Y'
                               AND con_number = i_con_number
                               AND gen_refno = lic_gen_refno
                               AND lic_lee_number = lee_number
                               AND lic_budget_code = 'SER' )
                 LOOP
                    for j in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_SER,',')) )
                    LOOP
                        update x_cp_lic_medplatmdevcompat_map
                        set LIC_RIGHTS_ON_DEVICE  = i_rights_on_device_ser,
                        LIC_MPDC_COMP_RIGHTS      = j.column_value,
                        LIC_MPDC_MODIFIED_BY    =  i_entryoper,
                        LIC_MPDC_MODIFIED_ON   =  sysdate,
                        LIC_MPDC_UPDATE_COUNT = LIC_MPDC_UPDATE_COUNT + 1
                       where LIC_MPDC_LIC_NUMBER = i.lic_number
                       and   LIC_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id;
                   END LOOP;
                 END LOOP;

           elsiF i_rights_on_device_ser = 'N'  and l_rights_on_device_ser = 'Y'
           THEN

                  UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                    set CON_RIGHTS_ON_DEVICE = i_rights_on_device_ser,
                        CON_IS_COMP_RIGHTS = 'N',
                        CON_MPDC_MODIFIED_BY = i_entryoper,
                        CON_MPDC_MODIFIED_ON = sysdate,
                        CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
                 where CON_CONTRACT_NUMBER = i_con_number
                  and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
                 and   CON_IS_FEA_SER  = 'SER' ;
          --NEED TO UPDATE THE RESPECTIVE CATCH UP LICNESE OF THE CONTRACT  (un Check the rights on device and device rights on all the catch up licenses of that contract)
                For i in (   SELECT    lic_number
                              FROM fid_license, fid_contract, fid_licensee, fid_general
                             WHERE lic_con_number = con_number
                               AND lic_status = 'A'
                               AND NVL (lic_catchup_flag, 'N') = 'Y'
                               AND con_number = i_con_number
                               AND gen_refno = lic_gen_refno
                               AND lic_lee_number = lee_number
                               AND lic_budget_code = 'SER' )
                 LOOP
                        update x_cp_lic_medplatmdevcompat_map
                        set LIC_RIGHTS_ON_DEVICE  = i_rights_on_device_fea,
                        LIC_MPDC_COMP_RIGHTS      = 'N',
                        LIC_MPDC_MODIFIED_BY    =  i_entryoper,
                        LIC_MPDC_MODIFIED_ON   =  sysdate,
                        LIC_MPDC_UPDATE_COUNT = LIC_MPDC_UPDATE_COUNT + 1
                       where LIC_MPDC_LIC_NUMBER = i.lic_number
                       and   LIC_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id;
                   END LOOP;

           END IF;

           --Validation for device on rights fiels for FEA
          select wm_concat(con_is_comp_rights) INTO  l_device_rights_fea
            from X_CP_CON_MEDPLATMDEVCOMPAT_MAP
            where con_contract_number = i_con_number
            and con_is_fea_ser = 'FEA'
            and con_mpdc_dev_platm_id = i_mpdc_dev_platm_id;

          FOR i in (( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(l_device_rights_fea,',')) ))
          LOOP
            for j in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_FEA,',')) )
             LOOP
                IF i.column_value = 'N' and  j.column_value = 'Y'
                 THEN
                    UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                      set CON_RIGHTS_ON_DEVICE = i_rights_on_device_FEA,
                          CON_IS_COMP_RIGHTS = j.column_value,
                          CON_MPDC_MODIFIED_BY = i_entryoper,
                          CON_MPDC_MODIFIED_ON = sysdate,
                          CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
                   where CON_CONTRACT_NUMBER = i_con_number
                    and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
                   and   CON_IS_FEA_SER  = 'FEA' ;

               ELSif i.column_value = 'Y' and  j.column_value = 'N'
               THEN
                 --NEED TO UNCHECK THE DEVICE RIGNHTS ON ALL CATCH UP LICENSES OF THAT CONTRACT WHEN EVER USER CLICKS ON YES IN POP UP WHICH IS APPEAR ON SCREEN IN FRONT END
                NULL;
               END IF;
            END LOOP;
          END LOOP;


           --Validation for device on rights fielD for ser
          select wm_concat(con_is_comp_rights) INTO  l_device_rights_ser
            from X_CP_CON_MEDPLATMDEVCOMPAT_MAP
            where con_contract_number = i_con_number
            and con_is_fea_ser = 'SER'
            and con_mpdc_dev_platm_id = i_mpdc_dev_platm_id;

          FOR i in (( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(l_device_rights_SER,',')) ))
          LOOP
            for j in ( select column_value,rownum r from table (PKG_PB_MEDIA_PLAT_SER.split_to_char(i_med_comp_is_rights_ser,',')) )
             LOOP
              IF i.column_value = 'N' and  j.column_value = 'Y'
               THEN
                  UPDATE X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                    set CON_RIGHTS_ON_DEVICE = i_rights_on_device_ser,
                        CON_IS_COMP_RIGHTS = j.column_value,
                        CON_MPDC_MODIFIED_BY = i_entryoper,
                        CON_MPDC_MODIFIED_ON = sysdate,
                        CON_MPDC_UPDATE_COUNT = CON_MPDC_UPDATE_COUNT + 1
                 where CON_CONTRACT_NUMBER = i_con_number
                  and   CON_MPDC_DEV_PLATM_ID = i_mpdc_dev_platm_id
                 and   CON_IS_FEA_SER  = 'FEA' ;

               ELSif i.column_value = 'Y' and  j.column_value = 'N'
               THEN
                 --NEED TO UNCHECK THE DEVICE RIGNHTS ON ALL CATCH UP LICENSES OF THAT CONTRACT WHEN EVER USER CLICKS ON YES IN POP UP WHICH IS APPEAR ON SCREEN IN FRONT END
                 null;
               END IF;
            END LOOP;
          END LOOP;
            --CACQ14:END:SUSHMA K on 28-10-2014

   end prc_update_rights_on_device; */

   --ACQ:CACQ14 :END*/

   --Dev.R5 : SVOD Enhancements : Start : [Devashish Raverkar]_[2015/04/22]
   PROCEDURE x_prc_con_rights_search (
      i_con_number                 IN     fid_contract.con_number%TYPE,
      i_service_flag               IN     fid_contract.con_Catchup_flag%TYPE,
      o_con_medplatmdevcompatmap      OUT pkg_acon_cm_contract_maint.c_contracts_cursor,
      o_con_med_dev_rights            OUT pkg_acon_cm_contract_maint.c_contracts_cursor)
   AS
      l_con_count        NUMBER;
      l_string           CLOB;
      l_string1          CLOB;
      l_string2          CLOB;
      l_string3          CLOB;
      l_catchup_flag     fid_contract.con_catchup_flag%TYPE; -- added on 23/03/2015 -- to check SVOD flag also
      l_media_ser_code   VARCHAR2 (50);
   BEGIN
      l_catchup_flag := NVL (i_service_flag, 'N');

      IF i_service_flag IS NOT NULL
      THEN
         SELECT DECODE (i_service_flag,  'Y', 'CATCHUP',  'S', 'SVOD')
           INTO l_media_ser_code
           FROM DUAL;
      ELSE
         BEGIN
            SELECT DECODE (con_catchup_flag,  'Y', 'CATCHUP',  'S', 'SVOD')
              INTO l_media_ser_code
              FROM fid_contract
             WHERE con_number = i_con_number;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_media_ser_code := NULL;
         END;
      END IF;

      SELECT COUNT (1)
        INTO l_con_count
        FROM x_cp_con_medplatmdevcompat_map
       WHERE CON_CONTRACT_NUMBER = i_con_number;

      IF    l_con_count = 0
         OR (l_con_count <> 0 AND i_service_flag IS NOT NULL)
         OR (l_con_count = 0 AND i_service_flag IS NULL)
      THEN
         l_string := 'select a.Med_dev_code,
                              a.Med_dev_desc,
                              a.med_platm_code,
                              a.med_platm_desc,
                              a.Rights_On_device,
                              a.MPDC_DEV_PLATM_ID,
                              a.med_device_sch_flag,
                              ';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_ID)
         LOOP
            l_string :=
                  l_string
               || 'NVL( ( select  (case when MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || '''  ),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,';
         END LOOP;

         l_string :=
            l_string
            || 'a.MPDC_UPDATE_COUNT from (select MDP_MAP_DEV_ID,
                                            (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                             ''N'' Rights_On_device,
                                             SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT,
                                             MPDC_DEV_PLATM_ID,
                                             ''N''  med_device_sch_flag
                                          from  x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map,x_cp_medplatdevcomp_servc_map
                                          where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                          and   MPDCS_MPDC_ID  =  MPDC_ID
                                          and MPDCS_MED_SERVICE_CODE = '''
            || l_media_ser_code
            || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a'; -- added on 24/03/2015 -- to check SVOD media service also
      ELSE
         l_string := 'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.CON_RIGHTS_ON_DEVICE,
                            a.CON_IS_FEA_SER,
                            a.CON_MPDC_DEV_PLATM_ID,
                            a.CON_CONTRACT_NUMBER,
                            a.med_device_sch_flag
                            ,';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_ID)
         LOOP
            l_string :=
                  l_string
               || 'NVL( ( select  (case when CON_MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and CON_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_con_medplatmdevcompat_map b,x_cp_media_dev_platm_map  where CON_MPDC_DEV_PLATM_ID = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.CON_MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and CON_IS_FEA_SER = a.CON_IS_FEA_SER and CON_CONTRACT_NUMBER = '''
               || i_con_number
               || '''),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,';
         END LOOP;

         l_string :=
            l_string
            || 'a.CON_MPDC_UPDATE_COUNT  from (select MDP_MAP_DEV_ID,
                                           (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            CON_RIGHTS_ON_DEVICE,
                                            CON_IS_FEA_SER
                                            ,CON_MPDC_DEV_PLATM_ID
                                            ,SUM(CON_MPDC_UPDATE_COUNT) CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER
                                            ,DECODE(CON_IS_FEA_SER,''FEA'',(case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              and   lic_catchup_flag = '''
            || l_catchup_flag
            || '''
                                                              and   X_FNC_GET_PROG_TYPE(lic_budget_code) <> ''Y''
                                                              and lic_con_number = '''
            || i_con_number ---- added on 23/03/2015 -- to check SVOD flag also
            || '''
                                                              )
                                                  AND TO_CHAR (plt_sch_start_date, ''mm'') IN
                                                                         (SELECT FIM_MONTH
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                  AND TO_CHAR (plt_sch_start_date,''yyyy'') IN
                                                                         (SELECT FIM_YEAR
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID) > 0 THEN  ''Y''  else ''N'' END )
                                                ,(case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              and   lic_catchup_flag = '''
            || l_catchup_flag
            || '''
                                                              and   X_FNC_GET_PROG_TYPE(lic_budget_code) = ''Y''
                                                              and lic_con_number = '''
            || i_con_number  -- added on 23/03/2015 -- to check SVOD flag also
            || '''
                                                              )
                                                  AND TO_CHAR (plt_sch_start_date, ''mm'') IN
                                                                         (SELECT FIM_MONTH
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                  AND TO_CHAR (plt_sch_start_date,''yyyy'') IN
                                                                         (SELECT FIM_YEAR
                                                                            FROM fid_financial_month
                                                                           WHERE fim_status IN (''B'', ''O''))
                                                and PLT_DEV_ID = MDP_MAP_DEV_ID) > 0 THEN  ''Y''  else ''N'' END )) med_device_sch_flag
                                          from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = '''
            || i_con_number
            || '''
                                          and con_mpdc_service_code = '''
            || l_media_ser_code
            || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,CON_IS_FEA_SER,CON_RIGHTS_ON_DEVICE,CON_MPDC_DEV_PLATM_ID
                                                    --,CON_MPDC_UPDATE_COUNT
                                                    ,CON_CONTRACT_NUMBER
                                                 )a';

         l_string1 :=
            'UNION select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.RIGHTS_ON_DEVICE,
                            a.IS_FEA_SER,
                            a.MPDC_DEV_PLATM_ID,
                            0 CON_CONTRACT_NUMBER,a.med_device_sch_flag,';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_ID)
         LOOP
            l_string1 :=
                  l_string1
               || 'NVL( ( select  (case when MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || '''),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,';
         END LOOP;

         l_string1 :=
            l_string1
            || 'a.MPDC_UPDATE_COUNT  from (select MDP_MAP_DEV_ID,
                                           (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            '' '' RIGHTS_ON_DEVICE,
                                            '' '' IS_FEA_SER
                                            ,MPDC_DEV_PLATM_ID
                                            ,SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,''N'' med_device_sch_flag
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                                and MPDCS_MED_SERVICE_CODE = '''
            || l_media_ser_code
            || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a'; -- added on 24/03/2015 -- to check SVOD media service also
      END IF;


      l_string3 := 'select a.Med_dev_code,
                              a.Med_dev_desc,
                              a.med_platm_code,
                              a.med_platm_desc,
                              a.Rights_On_device,
                              a.MPDC_DEV_PLATM_ID,
                              a.med_device_sch_flag,';

      FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE
                    FROM x_cp_media_device_compat
                ORDER BY MDC_ID)
      LOOP
         l_string3 :=
               l_string3
            || 'NVL( ( select  (case when MPDC_COMP_RIGHTS_ID = '''
            || i.MDC_ID
            || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS_ID = '''
            || i.MDC_ID
            || '''  ),''N'')   '
            || i.MDC_CODE
            || '_Media_Rights ,';
      END LOOP;

      l_string3 :=
         l_string3
         || 'a.MPDC_UPDATE_COUNT from (select MDP_MAP_DEV_ID,
                                           (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                             ''N'' Rights_On_device,
                                             SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT,
                                             MPDC_DEV_PLATM_ID,
                                             ''N''  med_device_sch_flag
                                          from  x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map,x_cp_medplatdevcomp_servc_map
                                          where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                          and   MPDCS_MPDC_ID  =  MPDC_ID
                                          and MPDCS_MED_SERVICE_CODE = '''
         || l_media_ser_code
         || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a';

      l_string2 := l_string || ' ' || l_string1;

      --DBMS_OUTPUT.PUT_LINE ('l_string2' || l_string2);

      --DBMS_OUTPUT.PUT_LINE('l_string3' || l_string3);

      OPEN O_con_medplatmdevcompatmap FOR l_string2;

      OPEN o_con_med_dev_rights FOR l_string3;
   END x_prc_con_rights_search;
--Dev.R5 : SVOD Enhancements : End

END pkg_acon_cm_contract_maint;
/