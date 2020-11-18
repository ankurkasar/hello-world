CREATE OR REPLACE PACKAGE PKG_ADM_CM_DEALMEMO
AS
   /******************************************************************************
      NAME:       pkg_adm_cm_dealmemo.pks
      PURPOSE:

      REVISIONS:
      Ver        Date        Author                   Description
      ---------  ----------  ---------------         ------------------------------
      1.0        2/19/2010   Omkar Chavan/Nirupama R  1. Created this package.
   ******************************************************************************/
   TYPE cursor_data IS REF CURSOR;

   TYPE c_deal_memo_prog_details IS REF CURSOR;

   TYPE c_deal_memo_prog_details1 IS REF CURSOR;

   TYPE c_deal_memo_prog_details2 IS REF CURSOR;

   TYPE c_deal_memo_prog_details3 IS REF CURSOR;

   TYPE c_deal_memo_prog_details4 IS REF CURSOR;

   TYPE c_dm_review_cursor IS REF CURSOR;

   username   VARCHAR2 (100);

   TYPE t_in_list_tab IS TABLE OF VARCHAR2 (4000);

   PROCEDURE prc_adm_dmreview_search (
      i_mem_id               IN     VARCHAR2,          --sak_memo.mem_id%TYPE,
      i_mem_date             IN     sak_memo.mem_date%TYPE,
      i_mem_lee_short_name   IN     fid_licensee.lee_short_name%TYPE,
      i_com_short_name       IN     fid_company.com_short_name%TYPE,
      i_gen_title            IN     fid_general.gen_title%TYPE,
      i_gen_title_working    IN     fid_general.gen_title_working%TYPE,
      i_gen_category         IN     fid_general.gen_category%TYPE,
      i_gen_subgenre         IN     fid_general.gen_subgenre%TYPE,
      i_gen_event            IN     fid_general.gen_event%TYPE,
      i_ald_lee_short_name   IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount           IN     VARCHAR2,
      --sak_allocation_detail.ald_amount%TYPE,
      i_mei_episode_count    IN     VARCHAR2,
      --sak_memo_item.mei_episode_count%TYPE,
      i_ald_period_start     IN     sak_allocation_detail.ald_period_start%TYPE,
      i_ald_period_end       IN     sak_allocation_detail.ald_period_end%TYPE,
      i_ald_period_tba       IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_mem_buyer            IN     sak_memo.mem_buyer%TYPE,
      i_mem_approver         IN     sak_memo.mem_approver%TYPE,
      i_mem_status           IN     sak_memo.mem_status%TYPE,
      o_dm_review_cursor        OUT pkg_adm_cm_dealmemo.c_dm_review_cursor);

   PROCEDURE find_chs_cha_short_nm (i_chsnumber      IN     NUMBER,
                                    --i_chuval         IN       VARCHAR2,
                                    o_chsshortname      OUT VARCHAR2,
                                    o_chashortname      OUT VARCHAR2);

   ------------------------------------- PROCEDURE FOR SEARCH DEAL MOEMO --------------------------------------
   PROCEDURE prc_adm_cm_searchdealmemo (
      i_mem_id           IN     VARCHAR2,
      i_contractnumber   IN     fid_contract.con_short_name%TYPE,
      i_status           IN     sak_memo.mem_status%TYPE,
      i_amort_method     IN     sak_memo.mem_amort_method%TYPE,
      i_fromdate         IN     DATE,
      i_todate           IN     DATE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   ------------------------------------- PROCEDURE VIEW DETAILS FOR PARTICULAR DEAL MOEMO --------------------------------------
   PROCEDURE prc_adm_cm_viewdealmemodetails (
      i_mem_id               IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult          OUT pkg_adm_cm_dealmemo.cursor_data,
      --Bioscope Changes Added new cursor by Anirudha on 13/03/2012
      o_media_ser_plat_dtl      OUT pkg_adm_cm_dealmemo.cursor_data,
      o_costed_prog_type        OUT pkg_adm_cm_dealmemo.cursor_data, -- o_qa_supplier         OUT  pkg_adm_cm_dealmemo.cursor_data
      o_media_service           OUT pkg_adm_cm_dealmemo.cursor_data
	  --Added By Pravin to get The Roles list for detail screen
	  ,o_Role_List				OUT pkg_adm_cm_dealmemo.cursor_data
	  );

   ------------------------------------- ADD PROCEDURE FOR RIGHTS DEAL MOEMO --------------------------------------
   PROCEDURE prc_adm_cm_adddealmemo (
      i_contract                   IN     fid_contract.con_short_name%TYPE,
      i_mem_date                   IN     sak_memo.mem_date%TYPE,
      i_mem_currency               IN     sak_memo.mem_currency%TYPE,
      i_mem_type                   IN     sak_memo.mem_type%TYPE,
      i_licensor                   IN     fid_company.com_short_name%TYPE,
      i_contractentity             IN     fid_company.com_short_name%TYPE,
      i_mainlicensee               IN     fid_licensee.lee_short_name%TYPE,
      i_mem_amort_method           IN     sak_memo.mem_amort_method%TYPE,
      i_mem_align_ind              IN     sak_memo.mem_align_ind%TYPE,
      i_mem_mplex_ind              IN     sak_memo.mem_mplex_ind%TYPE,
      i_mem_con_price              IN     sak_memo.mem_con_price%TYPE,
      -- rights
      i_mem_broader_rights         IN     sak_memo.mem_broader_rights%TYPE,
      i_mem_otime_allowed          IN     sak_memo.mem_otime_allowed%TYPE,
      i_mem_otime_exclusive        IN     sak_memo.mem_otime_exclusive%TYPE,
      i_mem_otime_days             IN     sak_memo.mem_otime_days%TYPE,
      i_mem_paytv_days             IN     sak_memo.mem_paytv_days%TYPE,
      i_mem_other_services         IN     sak_memo.mem_other_services%TYPE,
      --
      i_mem_on_loan                IN     sak_memo.mem_on_loan%TYPE,
      i_mem_matls_return           IN     sak_memo.mem_matls_return%TYPE,
      i_mem_deliv_mode             IN     sak_memo.mem_deliv_mode%TYPE,
      i_mem_deliv_cost             IN     sak_memo.mem_deliv_cost%TYPE,
      i_mem_contract_form          IN     sak_memo.mem_contract_form%TYPE,
      -- Bioscope Changes Added below Parameter by Anirudha on 13/03/2012
      i_mem_time_shift_cha_flag    IN     sak_memo.mem_time_shift_cha_flag%TYPE,
      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
      i_mem_simulcast_cha_flag     IN     sak_memo.mem_simulcast_cha_flag%TYPE,
      /* PB (CR 12) : END */
      i_mem_entry_oper             IN     sak_memo.mem_entry_oper%TYPE,
      ii_mem_con_cost_per_hour     IN     sak_memo.mem_con_cost_per_hour%TYPE,
      ii_mem_con_hours             IN     sak_memo.mem_con_hours%TYPE,
      ii_mem_con_hours_remaining   IN     sak_memo.mem_con_hours_remaining%TYPE,
      i_mem_con_procure_type       IN     sak_memo.mem_con_procurement_type%TYPE,
      --BR_15_144 : Finance Warner Paymnet : START [05-10-2015] by Sushma
      --Added to implement UAT cr
      i_mem_mg_flag                IN     sak_memo.mem_is_mg_flag%TYPE,
      o_mem_id                        OUT sak_memo.mem_id%TYPE,
      o_mem_status                    OUT sak_memo.mem_status%TYPE);

   ----------------------------------------------- UPDATE PROCEDURE FOR DEAL MEMO -------------------------------------------------
   PROCEDURE prc_adm_cm_updatedealmemo (
      i_mem_id                     IN     sak_memo.mem_id%TYPE,
      --i_mem_date                  IN       sak_memo.mem_date%TYPE,
      i_licensor                   IN     fid_company.com_short_name%TYPE,
      i_contractentity             IN     fid_company.com_short_name%TYPE,
      i_mainlicensee               IN     fid_licensee.lee_short_name%TYPE,
      i_contract                   IN     fid_contract.con_short_name%TYPE,
      i_mem_broader_rights         IN     sak_memo.mem_broader_rights%TYPE,
      i_mem_otime_allowed          IN     sak_memo.mem_otime_allowed%TYPE,
      i_mem_on_loan                IN     sak_memo.mem_on_loan%TYPE,
      i_mem_matls_return           IN     sak_memo.mem_matls_return%TYPE,
      i_mem_deliv_mode             IN     sak_memo.mem_deliv_mode%TYPE,
      i_mem_deliv_cost             IN     sak_memo.mem_deliv_cost%TYPE,
      i_mem_contract_form          IN     sak_memo.mem_contract_form%TYPE,
      i_mem_currency               IN     sak_memo.mem_currency%TYPE,
      i_mem_type                   IN     sak_memo.mem_type%TYPE,
      i_mem_otime_exclusive        IN     sak_memo.mem_otime_exclusive%TYPE,
      i_mem_otime_days             IN     sak_memo.mem_otime_days%TYPE,
      i_mem_paytv_days             IN     sak_memo.mem_paytv_days%TYPE,
      i_mem_other_services         IN     sak_memo.mem_other_services%TYPE,
      i_mem_protection_other       IN     sak_memo.mem_protection_other%TYPE,
      i_mem_protection_except      IN     sak_memo.mem_protection_except%TYPE,
      --i_mem_payment_other         IN       sak_memo.mem_payment_other%TYPE,
      --i_mem_ban_number            IN       sak_memo.mem_ban_number%TYPE,
      i_mem_deliv_matls_prior      IN     sak_memo.mem_deliv_matls_prior%TYPE,
      i_mem_deliv_matls_by         IN     sak_memo.mem_deliv_matls_by%TYPE,
      i_mem_deliv_matls_other      IN     sak_memo.mem_deliv_matls_other%TYPE,
      i_mem_deliv_live_tech        IN     sak_memo.mem_deliv_live_tech%TYPE,
      i_mem_deliv_live_pub         IN     sak_memo.mem_deliv_live_pub%TYPE,
      i_mem_loan_info              IN     sak_memo.mem_loan_info%TYPE,
      i_mem_matls_return_other     IN     sak_memo.mem_matls_return_other%TYPE,
      i_mem_support_return         IN     sak_memo.mem_support_return%TYPE,
      i_mem_deliv_mode_other       IN     sak_memo.mem_deliv_mode_other%TYPE,
      i_mem_deliv_cost_other       IN     sak_memo.mem_deliv_cost_other%TYPE,
      i_mem_deliv_notes            IN     sak_memo.mem_deliv_notes%TYPE,
      i_mem_contract_form_other    IN     sak_memo.mem_contract_form_other%TYPE,
      i_mem_notes                  IN     sak_memo.mem_notes%TYPE,
      i_mem_comment                IN     sak_memo.mem_comment%TYPE,
      i_mem_approver               IN     sak_memo.mem_approver%TYPE,
      i_mem_approval_date          IN     sak_memo.mem_approval_date%TYPE,
      i_mem_buyer                  IN     sak_memo.mem_buyer%TYPE,
      i_mem_buyer_date             IN     sak_memo.mem_buyer_date%TYPE,
      i_mem_change_oper            IN     sak_memo.mem_change_oper%TYPE,
      i_mem_return_cost            IN     sak_memo.mem_return_cost%TYPE,
      i_mem_mplex_ind              IN     sak_memo.mem_mplex_ind%TYPE,
      i_mem_align_ind              IN     sak_memo.mem_align_ind%TYPE,
      i_mem_con_price              IN     sak_memo.mem_con_price%TYPE,
      /*
          i_mem_status                IN       sak_memo.mem_status%TYPE,
          i_mem_status_date           IN       sak_memo.mem_status_date%TYPE,
          i_mem_prime_time_start      IN       sak_memo.mem_prime_time_start%TYPE,
          i_mem_prime_time_end        IN       sak_memo.mem_prime_time_end%TYPE,
          i_mem_prime_max_runs        IN       sak_memo.mem_prime_max_runs%TYPE,
          i_mem_con_hours             IN       sak_memo.mem_con_hours%TYPE,
          i_mem_con_cost_per_hour     IN       sak_memo.mem_con_cost_per_hour%TYPE,
          i_mem_con_hours_remaining   IN       sak_memo.mem_con_hours_remaining%TYPE,
         i_mem_total_duration        IN       sak_memo.mem_total_duration%TYPE,
     */
      i_mem_amort_method           IN     sak_memo.mem_amort_method%TYPE,
      -- Bioscope Changes by Anirudha on 13/03/2012
      i_mem_time_shift_cha_flag    IN     sak_memo.mem_time_shift_cha_flag%TYPE,
      -- Bioscope Changes end
      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
      i_mem_simulcast_cha_flag     IN     sak_memo.mem_simulcast_cha_flag%TYPE,
      /* PB (CR 12) : END */
      i_mem_update_count           IN     sak_memo.mem_update_count%TYPE,
      ii_mem_con_cost_per_hour     IN     sak_memo.mem_con_cost_per_hour%TYPE,
      ii_mem_con_hours             IN     sak_memo.mem_con_hours%TYPE,
      ii_mem_con_hours_remaining   IN     sak_memo.mem_con_hours_remaining%TYPE,
      i_mem_con_procure_type       IN     sak_memo.mem_con_procurement_type%TYPE,
      --BR_15_144 : Finance Warner Paymnet : START [05-10-2015] by Sushma
      --Added to implement UAT cr
      i_mem_mg_flag                IN     sak_memo.mem_is_mg_flag%TYPE,
      --END
      o_mem_update_count              OUT sak_memo.mem_update_count%TYPE);

   -------------------------Added by nishant ----------------------------------------------------------
   PROCEDURE prc_add_dm_updt_ref_prog (
      i_mei_id                   IN     sak_memo_item.mei_id%TYPE,
      i_mei_mem_id               IN     sak_memo_item.mei_mem_id%TYPE,
      i_mem_type                 IN     sak_memo.mem_type%TYPE,
      i_title_show               IN     fid_general.gen_title%TYPE,
      i_genre                    IN     fid_general.gen_category%TYPE,
      i_sub_genre                IN     fid_general.gen_subgenre%TYPE,
      i_event                    IN     fid_general.gen_event%TYPE,
      i_gen_type                 IN     fid_general.gen_type%TYPE,
      i_mei_total_price          IN     sak_memo_item.mei_total_price%TYPE,
      i_licensor                 IN     fid_company.com_short_name%TYPE,
      i_user_id                  IN     fid_general.gen_entry_oper%TYPE,
      i_gen_duration_c           IN     fid_general.gen_duration_c%TYPE,
      i_mei_gen_refno            IN     sak_memo_item.mei_gen_refno%TYPE,
      i_gen_tertiary_genre       IN     fid_general.gen_tertiary_genre%TYPE,
      i_gen_bo_category_code     IN     fid_general.gen_bo_category_code%TYPE,
      i_gen_bo_revenue_usd       IN     fid_general.gen_bo_revenue_usd%TYPE,
      i_gen_bo_revenue_zar       IN     fid_general.gen_bo_revenue_zar%TYPE,
      i_gen_release_year         IN     fid_general.gen_release_year%TYPE,
      i_gen_prog_category_code   IN     fid_general.gen_prog_category_code%TYPE,
      i_premium_flag             IN     sak_memo_item.mei_premium_flag%TYPE,
      o_mei_gen_refno               OUT sak_memo_item.mei_gen_refno%TYPE,
      o_mem_con_price               OUT sak_memo.mem_con_price%TYPE --o_mem_update_count            OUT sak_memo.mem_update_count%TYPE
                                                                   );

   --------------------- End ---------------------------------------------------------------------------

   ----------------------------------------------- DELETE PROCEDURE FOR DEAL MEMO -------------------------------------------------
   PROCEDURE prc_adm_cm_deletedealmemo (
      i_mem_id             IN     sak_memo.mem_id%TYPE,
      i_mem_update_count   IN     sak_memo.mem_update_count%TYPE,
      o_dealmemodeleted       OUT NUMBER);

   ------------------------------------- SEARCH PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_viewlanguage (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   ------------------------------------- ADD PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_addlanguage (
      i_mla_mem_id       IN     sak_memo_lang_rights.mla_mem_id%TYPE,
      i_mla_lan_id       IN     sak_memo_lang_rights.mla_lan_id%TYPE,
      i_mla_original     IN     sak_memo_lang_rights.mla_original%TYPE,
      i_mla_dubbed       IN     sak_memo_lang_rights.mla_dubbed%TYPE,
      i_mla_subtitled    IN     sak_memo_lang_rights.mla_subtitled%TYPE,
      i_mla_voice_over   IN     sak_memo_lang_rights.mla_voice_over%TYPE,
      i_mla_supply       IN     sak_memo_lang_rights.mla_supply%TYPE,
      i_mla_cost         IN     sak_memo_lang_rights.mla_cost%TYPE,
      i_mla_notes        IN     sak_memo_lang_rights.mla_notes%TYPE,
      i_mla_entry_oper   IN     sak_memo_lang_rights.mla_entry_oper%TYPE,
      o_languageadded       OUT NUMBER);

   ------------------------------------- UPDATE PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_updtlanguage (
      i_mla_number         IN     sak_memo_lang_rights.mla_number%TYPE,
      i_mla_mem_id         IN     sak_memo_lang_rights.mla_mem_id%TYPE,
      i_mla_lan_id         IN     sak_memo_lang_rights.mla_lan_id%TYPE,
      i_mla_original       IN     sak_memo_lang_rights.mla_original%TYPE,
      i_mla_dubbed         IN     sak_memo_lang_rights.mla_dubbed%TYPE,
      i_mla_subtitled      IN     sak_memo_lang_rights.mla_subtitled%TYPE,
      i_mla_voice_over     IN     sak_memo_lang_rights.mla_voice_over%TYPE,
      i_mla_supply         IN     sak_memo_lang_rights.mla_supply%TYPE,
      i_mla_cost           IN     sak_memo_lang_rights.mla_cost%TYPE,
      i_mla_notes          IN     sak_memo_lang_rights.mla_notes%TYPE,
      i_mla_update_count   IN     sak_memo_lang_rights.mla_update_count%TYPE,
      o_languageupdated       OUT NUMBER);

   ------------------------------------- DELETE PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_dellanguage (
      i_mla_number         IN     sak_memo_lang_rights.mla_number%TYPE,
      i_mla_mem_id         IN     sak_memo_lang_rights.mla_mem_id%TYPE,
      i_mla_lan_id         IN     sak_memo_lang_rights.mla_lan_id%TYPE,
      i_mla_update_count   IN     sak_memo_lang_rights.mla_update_count%TYPE,
      o_languagedeleted       OUT NUMBER);

   ------------------------------------- DEFAULT LANGUAGES PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_default_languages (
      i_mem_id                   IN     sak_memo.mem_id%TYPE,
      o_defaultlanguagesresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   ----------------------- FUNCTION TO CHECK LANGUAGES EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_languageexists (
      i_mla_mem_id   IN sak_memo_lang_rights.mla_mem_id%TYPE,
      i_mla_lan_id   IN sak_memo_lang_rights.mla_lan_id%TYPE)
      RETURN NUMBER;

   ------------------------------------- VIEW HISTORY PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_viewhistory (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   ------------------------------------- SEARCH TERRITORIES LICENSED PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_viewterritorieslic (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   ------------------------------------- ADD TERRITORIES LICENSED PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_addterritorieslic (
      i_met_mem_id       IN     sak_memo_territory.met_mem_id%TYPE,
      i_met_ter_code     IN     sak_memo_territory.met_ter_code%TYPE,
      i_met_rights       IN     sak_memo_territory.met_rights%TYPE,
      i_met_entry_oper   IN     sak_memo_territory.met_entry_oper%TYPE,
      o_teradded            OUT NUMBER);

   ------------------------------------ UPDATE TERRITORIES LICENSED PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_updtterritorieslic (
      i_met_number         IN     sak_memo_territory.met_number%TYPE,
      i_met_mem_id         IN     sak_memo_territory.met_mem_id%TYPE,
      i_met_ter_code       IN     sak_memo_territory.met_ter_code%TYPE,
      i_met_rights         IN     sak_memo_territory.met_rights%TYPE,
      i_met_update_count   IN     sak_memo_territory.met_update_count%TYPE,
      o_terupdated            OUT NUMBER);

   ------------------------------------ DELETE TERRITORIES LICENSED PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_delterritorieslic (
      i_met_number         IN     sak_memo_territory.met_number%TYPE,
      i_met_mem_id         IN     sak_memo_territory.met_mem_id%TYPE,
      i_met_update_count   IN     sak_memo_territory.met_update_count%TYPE,
      o_terdeleted            OUT NUMBER);

   ------------------------------------- DEFAULT TERRITORIES PROCEDURE FOR TERRITORY TAB  --------------------------------------
   PROCEDURE prc_adm_cm_default_territories (
      i_mem_id                   IN     sak_memo.mem_id%TYPE,
      i_defaultrights            IN     sak_memo_territory.met_ter_code%TYPE,
      o_defaultterritoryresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   ----------------------- FUNCTION TO CHECK TERRITORY EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_territoryexists (
      i_met_mem_id     IN sak_memo_territory.met_mem_id%TYPE,
      i_met_ter_code   IN sak_memo_territory.met_ter_code%TYPE)
      RETURN NUMBER;

   ------------------------------------- SEARCH PROCEDURE FOR PROTECTION TAB  --------------------------------------------------
   PROCEDURE prc_adm_cm_viewprotection (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   ------------------------------------- ADD PROTECTION TAB PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_addprotection (
      i_mep_mem_id        IN     sak_memo_protection.mep_mem_id%TYPE,
      -- Sak memo ID
      i_mep_competitor    IN     sak_memo_protection.mep_competitor%TYPE,
      -- Competitor Code
      i_mep_comment       IN     sak_memo_protection.mep_comment%TYPE,
      -- Comments
      i_mep_entry_oper    IN     sak_memo_protection.mep_entry_oper%TYPE,
      -- Entry operator
      o_protectionadded      OUT NUMBER);

   ------------------------------------- UPDATE PROTECTION TAB PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_updtprotection (
      i_mep_number          IN     sak_memo_protection.mep_number%TYPE,
      -- Protection primary key number
      i_mep_mem_id          IN     sak_memo_protection.mep_mem_id%TYPE,
      -- Sak memo ID
      i_mep_competitor      IN     sak_memo_protection.mep_competitor%TYPE,
      -- Competitor Code
      i_mep_comment         IN     sak_memo_protection.mep_comment%TYPE,
      -- Comments
      i_mep_update_count    IN     sak_memo_protection.mep_update_count%TYPE,
      o_protectionupdated      OUT NUMBER);

   ------------------------------------- DELETE PROTECTION TAB PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_delprotection (
      i_mep_number          IN     sak_memo_protection.mep_number%TYPE,
      -- Protection primary key number
      i_mep_mem_id          IN     sak_memo_protection.mep_mem_id%TYPE,
      -- Sak Memo ID.
      i_mep_update_count    IN     sak_memo_protection.mep_update_count%TYPE,
      o_protectiondeleted      OUT NUMBER);

   ------------------------------------- DEFAULT PROTECTION PROCEDURE FOR PROTECTIONS TAB  --------------------------------------
   PROCEDURE prc_adm_cm_default_protection (
      i_mem_id                    IN     sak_memo.mem_id%TYPE,
      o_defaultprotectionresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   ----------------------- FUNCTION TO CHECK PROTECTION EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_protectionexists (
      i_mep_mem_id       IN sak_memo_protection.mep_mem_id%TYPE,
      i_mep_competitor   IN sak_memo_protection.mep_competitor%TYPE)
      RETURN NUMBER;

   -------------------------------------- PROCEDURE TO VIEW MATERIALS  -----------------------------------------
   PROCEDURE prc_adm_cm_viewdeliverymat (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   -------------------------------------- PROCEDURE TO ADD MATERIALS  -----------------------------------------
   PROCEDURE prc_adm_cm_adddeliverymat (
      i_mma_mem_id       IN     sak_memo_materials.mma_mem_id%TYPE,
      i_com_short_name   IN     fid_company.com_short_name%TYPE,
      i_mma_bcast_type   IN     sak_memo_materials.mma_bcast_type%TYPE,
      i_mma_item_class   IN     sak_memo_materials.mma_item_class%TYPE,
      i_mma_item         IN     sak_memo_materials.mma_item%TYPE,
      i_mma_sound_type   IN     sak_memo_materials.mma_sound_type%TYPE,
      i_mma_comment      IN     sak_memo_materials.mma_comment%TYPE,
      i_mma_entry_oper   IN     sak_memo_materials.mma_entry_oper%TYPE,
      o_mma_id              OUT sak_memo_materials.mma_id%TYPE);

   -------------------------------------- PROCEDURE TO UPDATE MATERIALS  -----------------------------------------
   PROCEDURE prc_adm_cm_updtdeliverymat (
      i_mma_id             IN     sak_memo_materials.mma_id%TYPE,
      i_mma_mem_id         IN     sak_memo_materials.mma_mem_id%TYPE,
      i_com_short_name     IN     fid_company.com_short_name%TYPE,
      i_mma_bcast_type     IN     sak_memo_materials.mma_bcast_type%TYPE,
      i_mma_item_class     IN     sak_memo_materials.mma_item_class%TYPE,
      i_mma_item           IN     sak_memo_materials.mma_item%TYPE,
      i_mma_sound_type     IN     sak_memo_materials.mma_sound_type%TYPE,
      i_mma_comment        IN     sak_memo_materials.mma_comment%TYPE,
      i_mma_update_count   IN     sak_memo_materials.mma_update_count%TYPE,
      o_materialupdated       OUT NUMBER);

   -------------------------------------- PROCEDURE TO DELETE MATERIALS  -----------------------------------------
   PROCEDURE prc_adm_cm_deletedeliverymat (
      i_mma_id             IN     sak_memo_materials.mma_id%TYPE,
      i_mma_mem_id         IN     sak_memo_materials.mma_mem_id%TYPE,
      i_mma_update_count   IN     sak_memo_materials.mma_update_count%TYPE,
      o_materialdeleted       OUT NUMBER);

   ----------------------- FUNCTION TO CHECK MATERAIL EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_materialexists (
      i_mma_mem_id       IN sak_memo_materials.mma_mem_id%TYPE,
      i_mma_com_number   IN sak_memo_materials.mma_com_number%TYPE,
      i_mma_bcast_type   IN sak_memo_materials.mma_bcast_type%TYPE,
      i_mma_item_class   IN sak_memo_materials.mma_item_class%TYPE,
      i_mma_item         IN sak_memo_materials.mma_item%TYPE,
      i_mma_sound_type   IN sak_memo_materials.mma_sound_type%TYPE)
      RETURN NUMBER;

   -------------------------------------- PROCEDURE TO VIEW PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_viewpayment (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   -------------------------------------- PROCEDURE TO ADD PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_addpayment (
      i_mpy_amount        IN     sak_memo_payment.mpy_amount%TYPE,
      i_mpy_cur_code      IN     sak_memo_payment.mpy_cur_code%TYPE,
      i_mpy_code          IN     sak_memo_payment.mpy_code%TYPE,
      i_mpy_mem_id        IN     sak_memo_payment.mpy_mem_id%TYPE,
      i_mpy_sort_order    IN     sak_memo_payment.mpy_sort_order%TYPE,
      i_mpy_due           IN     sak_memo_payment.mpy_due%TYPE,
      i_mpy_comment       IN     sak_memo_payment.mpy_comment%TYPE,
      i_mpy_pct_pay       IN     sak_memo_payment.mpy_pct_pay%TYPE,
      i_mpy_pay_month     IN     sak_memo_payment.mpy_pay_month%TYPE,
      i_mpy_entry_oper    IN     sak_memo_payment.mpy_entry_oper%TYPE,
      i_mpy_islastmonth   IN     sak_memo_payment.mpy_islastmonth%TYPE,
      -- FIN29: Abhinay_20140328 : Enter payment record for the last month in Payment Plan v1.0
      o_mpy_number           OUT sak_memo_payment.mpy_number%TYPE);

   ------------------------------------- PROCEDURE TO UPDATE PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_updtpayment (
      i_mpy_number         IN     sak_memo_payment.mpy_number%TYPE,
      i_mpy_mem_id         IN     sak_memo_payment.mpy_mem_id%TYPE,
      i_mpy_amount         IN     sak_memo_payment.mpy_amount%TYPE,
      i_mpy_cur_code       IN     sak_memo_payment.mpy_cur_code%TYPE,
      i_mpy_code           IN     sak_memo_payment.mpy_code%TYPE,
      i_mpy_sort_order     IN     sak_memo_payment.mpy_sort_order%TYPE,
      i_mpy_due            IN     sak_memo_payment.mpy_due%TYPE,
      i_mpy_comment        IN     sak_memo_payment.mpy_comment%TYPE,
      i_mpy_pct_pay        IN     sak_memo_payment.mpy_pct_pay%TYPE,
      i_mpy_pay_month      IN     sak_memo_payment.mpy_pay_month%TYPE,
      i_mpy_entry_oper     IN     sak_memo_payment.mpy_entry_oper%TYPE,
      i_mpy_islastmonth    IN     sak_memo_payment.mpy_islastmonth%TYPE,
      -- FIN29: Abhinay_20140328 : Enter payment record for the last month in Payment Plan v1.0
      i_mpy_update_count   IN     sak_memo_payment.mpy_update_count%TYPE,
      o_paymentupdated        OUT NUMBER);

   ------------------------------------- PROCEDURE TO DELETE PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_deletepayment (
      i_mpy_number         IN     sak_memo_payment.mpy_number%TYPE,
      i_mpy_mem_id         IN     sak_memo_payment.mpy_mem_id%TYPE,
      i_mpy_update_count   IN     sak_memo_payment.mpy_update_count%TYPE,
      i_mpy_entry_oper     IN     sak_memo_payment.MPY_ENTRY_OPER%TYPE,
      o_paymentdeleted        OUT NUMBER);

   ----------------------- FUNCTION TO CHECK PAYMENT EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_paymentexists (
      i_mpy_mem_id       IN sak_memo_payment.mpy_mem_id%TYPE,
      i_mpy_sort_order   IN sak_memo_payment.mpy_sort_order%TYPE)
      RETURN NUMBER;

   ---------------------------------------- SEARCH SERIES PROCEDURE ------------------------------------
   PROCEDURE prc_adm_cm_searchseries (
      i_mem_id         IN     sak_memo.mem_id%TYPE,
      i_mem_type       IN     sak_memo.mem_type%TYPE,
      i_ser_number     IN     fid_series.ser_number%TYPE,
      o_seasondata        OUT pkg_adm_cm_dealmemo.cursor_data,
      o_episodesdata      OUT pkg_adm_cm_dealmemo.cursor_data);

   ------------------------------------------------- GENERATE SERIES ----------------------------------------------------------
   PROCEDURE prc_adm_cm_generateepi (
      -- format of title
      i_serieschk         IN     CHAR,
      i_seriestitle       IN     VARCHAR2,
      i_seasonchk         IN     CHAR,
      i_seasontitle       IN     VARCHAR2,
      i_addtextchk        IN     CHAR,
      i_addtexttitle      IN     VARCHAR2,
      i_epichk            IN     CHAR,
      -- format of working title
      i_serieschk_wt      IN     CHAR,
      i_seasonchk_wt      IN     CHAR,
      i_addtextchk_wt     IN     CHAR,
      i_addtexttitle_wt   IN     VARCHAR2,
      i_epichk_wt         IN     CHAR,
      i_seasonnumber      IN     NUMBER,
      i_epi_count         IN     NUMBER,
      i_duration          IN     VARCHAR2,
      i_sporttype         IN     VARCHAR2,
      i_subgenre          IN     VARCHAR2,
      i_eventtype         IN     VARCHAR2,
      i_first_epi         IN     NUMBER,
      o_episodesdata         OUT pkg_adm_cm_dealmemo.cursor_data);

   -------------------------------------------- ADD SEASON PROCEDURE  --------------------------------------------------
   PROCEDURE prc_adm_cm_addseason (
      i_mem_id            IN     sak_memo.mem_id%TYPE,
      i_seriesnumber      IN     fid_series.ser_number%TYPE,
      i_season_title      IN     fid_series.ser_title%TYPE,
      i_season_number     IN     fid_series.ser_sea_number%TYPE,
      i_first_epi         IN     sak_memo_item.mei_first_epi_number%TYPE,
      i_epi_count         IN     sak_memo_item.mei_episode_count%TYPE,
      i_first_epi_price   IN     sak_memo_item.mei_first_episode_price%TYPE,
      i_user_id           IN     sak_memo_item.mei_entry_oper%TYPE,
      i_mei_total_price   IN     sak_memo_item.mei_total_price%TYPE,
      i_gen_type          IN     fid_general.gen_type%TYPE,
      -- PB CR-44 Mrunmayi 31-jul-2013
      i_premium_flag      IN     sak_memo_item.mei_premium_flag%TYPE,
      -- End
      --Added by nishant
      i_com_number        IN     fid_series.ser_sea_number%TYPE,
      i_release_year      IN     fid_series.ser_sea_number%TYPE,
     -- i_season_svod_rights IN    fid_series.ser_svod_rights%TYPE, --added by vikas srivastava
      --End
      o_season_added         OUT INTEGER);

   -------------------------------------------- UPDATE SEASON PROCEDURE  --------------------------------------------------
   PROCEDURE prc_adm_cm_updtseason (
      i_mem_id            IN     sak_memo.mem_id%TYPE,
      i_oldseasonnumber   IN     fid_series.ser_number%TYPE,
      i_first_epi         IN     sak_memo_item.mei_first_epi_number%TYPE,
      i_epi_count         IN     sak_memo_item.mei_episode_count%TYPE,
      i_first_epi_price   IN     sak_memo_item.mei_first_episode_price%TYPE,
      i_mei_total_price   IN     sak_memo_item.mei_total_price%TYPE,
      i_newseasonnumber   IN     fid_series.ser_number%TYPE,
      i_updateflag        IN     VARCHAR2,
      o_season_updated       OUT INTEGER);

   ------------------------------------------------- ADD EPISODES ----------------------------------------------------
   PROCEDURE prc_adm_cm_addepisodes (
      i_mem_id              IN     sak_memo.mem_id%TYPE,
      i_gen_type            IN     fid_general.gen_type%TYPE,
      i_gen_title           IN     fid_general.gen_title%TYPE,
      i_gen_title_working   IN     fid_general.gen_title_working%TYPE,
      i_genre               IN     fid_general.gen_category%TYPE,
      i_sub_genre           IN     fid_general.gen_subgenre%TYPE,
      i_event               IN     fid_general.gen_event%TYPE,
      i_gen_duration_c      IN     fid_general.gen_duration_c%TYPE,
      i_gencomment          IN     fid_general.gen_comment%TYPE,
      i_genepinumber        IN     fid_general.gen_epi_number%TYPE,
      i_gen_relic           IN     fid_general.gen_relic%TYPE,
      i_licensor            IN     fid_company.com_short_name%TYPE,
      i_user_id             IN     fid_general.gen_entry_oper%TYPE,
      i_seasonnumber        IN     fid_series.ser_number%TYPE,
      i_linkedseason        IN     fid_series.ser_number%TYPE,
      i_releaseyear         IN     fid_general.gen_release_year%TYPE,
      i_updateflag          IN     VARCHAR2,
      i_gen_run_order       IN     fid_general.gen_running_order%TYPE,
      --Abhinay_20140121
       i_GEN_SEA_EPI_NO    In     fid_general.GEN_SEA_EPI_NO%TYPE,---Added by rashmi 15-06-2016
      o_mei_gen_refno          OUT sak_memo_item.mei_gen_refno%TYPE);

   /*-------------------------------------------------- UPDATE EPISODES ----------------------------------------------------
      PROCEDURE prc_adm_cm_updtepisodes (
         i_mem_id              IN       sak_memo.mem_id%TYPE,
         --i_mem_status          IN       sak_memo.mem_status%TYPE,
         i_gen_title_working   IN       fid_general.gen_title_working%TYPE,
         i_gen_duration_c      IN       fid_general.gen_duration_c%TYPE,
         i_gencomment          IN       fid_general.gen_comment%TYPE,
         i_gen_relic           IN       fid_general.gen_relic%TYPE,
         i_gen_refno           IN       fid_general.gen_refno%TYPE,
         i_gen_update_count    IN       fid_general.gen_update_count%TYPE,
         i_seasonnumber        IN       fid_series.ser_number%TYPE,
         i_linkedseason        IN       fid_series.ser_number%TYPE,
         o_episode_updated     OUT      NUMBER
      ); */

   /*------------------------------------------------- DELETE EPISODES ----------------------------------------------------
   PROCEDURE prc_adm_cm_delepisodes (
      i_mem_id             IN       sak_memo.mem_id%TYPE,
      --i_mem_status         IN       sak_memo.mem_status%TYPE,
      i_gen_refno          IN       fid_general.gen_refno%TYPE,
      i_gen_update_count   IN       fid_general.gen_update_count%TYPE,
      i_seasonnumber       IN       fid_series.ser_number%TYPE,
      o_episode_deleted    OUT      NUMBER
   );
*/
   ------------------------------------------------------- SEARCH CPD DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_search_cpddetails (
      i_mem_id                IN     sak_memo.mem_id%TYPE,
      i_fcd_orig_ser_number   IN     fid_cpd_details.fcd_orig_ser_number%TYPE,
      o_dealmemoresult           OUT pkg_adm_cm_dealmemo.cursor_data);

   -------------------------------------------------------- ADD CPD DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_add_cpddetails (
      i_fcd_mem_id            IN     sak_memo.mem_id%TYPE,
      i_fcd_title             IN     fid_cpd_details.fcd_title%TYPE,
      i_fcd_price             IN     fid_cpd_details.fcd_price%TYPE,
      i_fcd_comments          IN     fid_cpd_details.fcd_comments%TYPE,
      i_fcd_per_year          IN     fid_cpd_details.fcd_per_year%TYPE,
      i_fcd_per_month         IN     fid_cpd_details.fcd_per_month%TYPE,
      i_fcd_end_year          IN     fid_cpd_details.fcd_end_year%TYPE,
      i_fcd_end_month         IN     fid_cpd_details.fcd_end_month%TYPE,
      i_fcd_orig_ser_number   IN     fid_cpd_details.fcd_orig_ser_number%TYPE,
      i_fcd_entry_oper        IN     fid_cpd_details.fcd_entry_oper%TYPE,
      i_fcd_con_short_name    IN     fid_cpd_details.fcd_con_short_name%TYPE,
      o_fcd_number               OUT NUMBER);

   ------------------------------------------------------- UPDATE CPD DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_updt_cpddetails (
      i_fcd_mem_id         IN     sak_memo.mem_id%TYPE,
      i_fcd_number         IN     fid_cpd_details.fcd_number%TYPE,
      i_fcd_title          IN     fid_cpd_details.fcd_title%TYPE,
      i_fcd_price          IN     fid_cpd_details.fcd_price%TYPE,
      i_fcd_comments       IN     fid_cpd_details.fcd_comments%TYPE,
      i_fcd_per_year       IN     fid_cpd_details.fcd_per_year%TYPE,
      i_fcd_per_month      IN     fid_cpd_details.fcd_per_month%TYPE,
      i_fcd_end_year       IN     fid_cpd_details.fcd_end_year%TYPE,
      i_fcd_end_month      IN     fid_cpd_details.fcd_end_month%TYPE,
      i_fcd_update_count   IN     fid_cpd_details.fcd_update_count%TYPE,
      o_fcd_updated           OUT NUMBER);

   ------------------------------------------------------- DELETE CPD DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_del_cpddetails (
      i_fcd_mem_id         IN     sak_memo.mem_id%TYPE,
      i_fcd_number         IN     fid_cpd_details.fcd_number%TYPE,
      i_fcd_update_count   IN     fid_cpd_details.fcd_update_count%TYPE,
      o_fcd_deleted           OUT NUMBER);

   ------------------------------------------------------- SEARCH LIVE ENENT DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_search_livedetails (
      i_fgl_gen_refno      IN     fid_gen_live.fgl_gen_refno%TYPE,
      o_fgl_venue             OUT fid_gen_live.fgl_venue%TYPE,
      o_fgl_location          OUT fid_gen_live.fgl_location%TYPE,
      o_fgl_live_date         OUT VARCHAR2,
      o_fgl_time              OUT VARCHAR2,
      o_fgl_update_count      OUT fid_gen_live.fgl_update_count%TYPE);

   ------------------------------------------------------- SAVE LIVE ENENT DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_save_livedetails (
      i_fgl_gen_refno       IN     fid_gen_live.fgl_gen_refno%TYPE,
      i_fgl_venue           IN     fid_gen_live.fgl_venue%TYPE,
      i_fgl_location        IN     fid_gen_live.fgl_location%TYPE,
      i_fgl_live_date       IN     fid_gen_live.fgl_live_date%TYPE,
      i_fgl_time            IN     VARCHAR2,
      i_fgl_update_count    IN     fid_gen_live.fgl_update_count%TYPE,
      i_fgl_entry_oper      IN     fid_gen_live.fgl_entry_oper%TYPE,
      o_livedetails_saved      OUT NUMBER);

   -------------------------------------------- PROCEDURE TO SEARCH BUDGET TITLES -----------------------------------------
   PROCEDURE prc_adm_cm_searchbudget (
      i_mem_id       IN     sak_memo.mem_id%TYPE,
      o_budgetdata      OUT pkg_adm_cm_dealmemo.cursor_data);

   -------------------------------------------- PROCEDURE TO MOVE BUDGET TITLES -----------------------------------------
   PROCEDURE prc_adm_cm_movebudget (
      i_source_mei_id            IN     sak_memo_item.mei_id%TYPE,
      i_source_mem_id            IN     sak_memo.mem_id%TYPE,
      i_source_genrefno          IN     fid_general.gen_refno%TYPE,
      i_target_mem_id            IN     sak_memo.mem_id%TYPE,
      i_source_mei_updatecount   IN     sak_memo_item.mei_update_count%TYPE,
      --
      i_source_mei_type          IN     sak_memo_item.mei_type%TYPE,
      i_source_mem_type          IN     sak_memo.mem_type%TYPE,
      i_target_mem_type          IN     sak_memo.mem_type%TYPE,
      i_source_mem_status        IN OUT sak_memo.mem_status%TYPE,
      i_target_mem_status        IN OUT sak_memo.mem_status%TYPE,
      i_entry_oper               IN     VARCHAR2,
      --
      o_movedstatus                 OUT NUMBER);

   -------------------------------------------- PROCEDURE TO UPDATE HISTORY WHILE MOVING BUDGET TITLES ----------------------------------
   PROCEDURE prc_adm_cm_derive_status (v_mem          IN     NUMBER,
                                       v_mem_stat     IN OUT VARCHAR2,
                                       i_entry_oper   IN     VARCHAR2);

   -------------------------------------------- PROCEDURE FOR MEM STATUS LOV ----------------------------------
   PROCEDURE prc_adm_cm_memstatus (
      o_memstatus OUT pkg_adm_cm_dealmemo.cursor_data);

   -------------------------------------------- PROCEDURE FOR CHA SHORT NAME LOV ----------------------------------
   PROCEDURE prc_adm_cm_chashortname (
      i_ald_chs_number   IN     NUMBER,
      o_chashortname        OUT pkg_adm_cm_dealmemo.cursor_data);

   ---------------------------------------- FUNCTION CHECK PAYMENT FOR AMERT PAYMENTS --------------------------------------
   FUNCTION fn_adm_cm_check_payment (p_memid IN NUMBER)
      RETURN NUMBER;

   -------------------------------------------- PROCEDURE FOR TO GET DURATION OF SEASON ----------------------------------
   PROCEDURE prc_adm_cm_getduration (i_mem_id          IN     NUMBER,
                                     i_mei_id          IN     NUMBER,
                                     o_totalduration      OUT VARCHAR2);

   -------------------------------------------- PROCEDURE TO GET PERCENT PAYMENT LOV ----------------------------------
   PROCEDURE prc_adm_cm_getpayamount (
      o_paydata OUT pkg_adm_cm_dealmemo.cursor_data);

   -------------------------------------------- PROCEDURE TO GET SERIES - NON SERIES TITLE LOV ----------------------------------
   PROCEDURE prc_adm_cm_gettitles (
      i_isseries         IN     CHAR,
      i_sertitle         IN     VARCHAR2,
      i_type             IN     VARCHAR2,
      o_seriesdata          OUT pkg_adm_cm_dealmemo.cursor_data,
      o_genrefno            OUT NUMBER,
      o_genre               OUT VARCHAR2,
      o_subgenre            OUT VARCHAR2,
      o_event               OUT VARCHAR2,
      o_gen_duration_c      OUT VARCHAR2,
      o_type                OUT VARCHAR2);

   ----------------------------NewRefNo Changes - Nishant--------------------
   PROCEDURE prc_adm_cm_gettitles_supp (
      i_isseries         IN     CHAR,
      i_sertitle         IN     VARCHAR2,
      i_type             IN     VARCHAR2,
      o_seriesdata          OUT pkg_adm_cm_dealmemo.cursor_data,
      o_genrefno            OUT NUMBER,
      o_genre               OUT VARCHAR2,
      o_subgenre            OUT VARCHAR2,
      o_event               OUT VARCHAR2,
      o_gen_duration_c      OUT VARCHAR2,
      o_type                OUT VARCHAR2);

   ------------------------------------------------------------------------------------------
   PROCEDURE prc_adm_cm_gettitles_bysupp (
      i_gen_title    IN     VARCHAR2,
      i_type         IN     VARCHAR2,
      i_com_number   IN     NUMBER,
      o_titledata       OUT pkg_adm_cm_dealmemo.cursor_data);

   PROCEDURE prc_adm_cm_update_year (i_gen_title    IN     VARCHAR2,
                                     i_type         IN     VARCHAR2,
                                     i_com_number   IN     NUMBER,
                                     i_rel_year     IN     NUMBER,
                                     o_success         OUT NUMBER);

   --------------------------------------------------------------------------------------------------------------------------------------------
   --------------------------------------------------------------------------------------------------------------------------------------------
   --------------------------------------------------------------------------------------------------------------------------------------------
   --------------------------------------------------------------------------------------------------------------------------------------------
   FUNCTION fn_convert_duration_c_n (p_durchar IN VARCHAR2)
      RETURN NUMBER;

   FUNCTION fn_convert_duration_n_c (p_durnumber IN NUMBER)
      RETURN VARCHAR2;

   PROCEDURE prc_dm_prog_search (
      i_mem_id                       IN     NUMBER,
      I_CON_SHORT_NAME               IN VARCHAR2,
      o_deal_memo_prog_details          OUT c_deal_memo_prog_details,
      o_dm_prog_alloc_details           OUT c_deal_memo_prog_details1,
      o_dm_prog_cha_cost_details        OUT c_deal_memo_prog_details2,
      /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added 2 new cursor which will return the values for catchup licensee grid */
      o_catchup_prog_alloc_details      OUT c_deal_memo_prog_details3,
      o_catchup_platform_details        OUT c_deal_memo_prog_details4,
      /* FINANCE (CFIN 3) :Pranay Kusumwal 22/02/2013 :Added  new cursor which will return the values for secondary licensee grid */
      o_sec_lee_alloc_details           OUT c_deal_memo_prog_details --CACQ14:Start : Sushma K 19-NOV-2014 : Added new cursor to return the media device rights which are present on media device and service maintenence
                                                                    ,
      O_CATCHUP_MED_RIGHTS_DETAILS      OUT C_DEAL_MEMO_PROG_DETAILS,
      --END

      --Dev.R1: CatchUp for All :[10. BR_15_272_UC_Super Stacking]_[Milan Shah]_[2015/12/24]: Start
      O_SUPERSTACK_RIGHTS               OUT SYS_REFCURSOR
      --Dev.R1: CatchUp for All: End

                                                                    );

   /* Catchup (CR 3) :Nilesh Pagdal 17/10/2012 : Added for Catch-Up media rights and platforms*/
   PROCEDURE prc_adm_catchup_platform (
      i_mem_id                       IN     NUMBER,
      o_catchup_prog_alloc_details      OUT c_deal_memo_prog_details4);

   PROCEDURE prc_add_dm_programme (
      i_mei_mem_id               IN     sak_memo_item.mei_mem_id%TYPE,
      i_mem_type                 IN     sak_memo.mem_type%TYPE,
      i_title_show               IN     fid_general.gen_title%TYPE,
      i_genre                    IN     fid_general.gen_category%TYPE,
      i_sub_genre                IN     fid_general.gen_subgenre%TYPE,
      i_event                    IN     fid_general.gen_event%TYPE,
      i_gen_type                 IN     fid_general.gen_type%TYPE,
      i_mei_total_price          IN     sak_memo_item.mei_total_price%TYPE,
      i_licensor                 IN     fid_company.com_short_name%TYPE,
      i_user_id                  IN     fid_general.gen_entry_oper%TYPE,
      i_gen_duration_c           IN     fid_general.gen_duration_c%TYPE,
      i_mei_gen_refno            IN     sak_memo_item.mei_gen_refno%TYPE,
      --Bioscope Changes Added new Parameter by Anirudha on 13/03/2012
      i_gen_tertiary_genre       IN     fid_general.gen_tertiary_genre%TYPE,
      i_gen_bo_category_code     IN     fid_general.gen_bo_category_code%TYPE,
      i_gen_bo_revenue_usd       IN     fid_general.gen_bo_revenue_usd%TYPE,
      i_gen_bo_revenue_zar       IN     fid_general.gen_bo_revenue_zar%TYPE,
      i_gen_release_year         IN     fid_general.gen_release_year%TYPE,
      i_gen_prog_category_code   IN     fid_general.gen_prog_category_code%TYPE,
      -- Bioscope Changes END
      -- PB CR-44 Mrunmayi 31-jul-2013
      i_premium_flag             IN     sak_memo_item.mei_premium_flag%TYPE,
      i_gen_SVOD_Rights          IN     fid_general.gen_svod_rights%TYPE,
      i_gen_express              IN     fid_general.gen_express%TYPE,
      i_gen_archive              IN     fid_general.GEN_ARCHIVE%TYPE,
      i_gen_catelogue            IN     fid_general.GEN_CATALOGUE%TYPE,
      -- End
      o_mei_gen_refno               OUT sak_memo_item.mei_gen_refno%TYPE,
      o_mei_id                      OUT sak_memo_item.mei_id%TYPE,
      o_mem_con_price               OUT sak_memo.mem_con_price%TYPE,
      o_mem_update_count            OUT sak_memo.mem_update_count%TYPE);

   PROCEDURE prc_update_dm_programme (
      i_mei_id                   IN     sak_memo_item.mei_id%TYPE,
      i_mei_mem_id               IN     sak_memo_item.mei_mem_id%TYPE,
      i_mem_type                 IN     sak_memo.mem_type%TYPE,
      i_title_show               IN     fid_general.gen_title%TYPE,
      i_genre                    IN     fid_general.gen_category%TYPE,
      i_sub_genre                IN     fid_general.gen_subgenre%TYPE,
      i_event                    IN     fid_general.gen_event%TYPE,
      i_gen_type                 IN     fid_general.gen_type%TYPE,
      i_gen_duration_c           IN     fid_general.gen_duration_c%TYPE,
      i_mei_gen_refno            IN     sak_memo_item.mei_gen_refno%TYPE,
      i_mei_total_price          IN     sak_memo_item.mei_total_price%TYPE,
      i_entryoper                IN     fid_general.gen_entry_oper%TYPE,
      -- Bioscope Changes Added below column by Anirudha on 13/03/2012
      i_gen_release_year         IN     fid_general.gen_release_year%TYPE,
      i_gen_tertiary_genre       IN     fid_general.gen_tertiary_genre%TYPE,
      i_gen_bo_category_code     IN     fid_general.gen_bo_category_code%TYPE,
      i_gen_bo_revenue_usd       IN     fid_general.gen_bo_revenue_usd%TYPE,
      i_gen_bo_revenue_zar       IN     fid_general.gen_bo_revenue_zar%TYPE,
      i_gen_prog_category_code   IN     fid_general.gen_prog_category_code%TYPE,
      -- Bioscope Changes End
      -- PB CR-44 Mrunmayi 31-jul-2013
      i_premium_flag             IN     sak_memo_item.mei_premium_flag%TYPE,
      -- End
      -- Devashish/Shantanu, 30/jan/2014
      --i_mem_update_count         IN     sak_memo.mem_update_count%TYPE,
      i_mei_update_count         IN     sak_memo_item.mei_update_count%TYPE,
      --End
      --i_mei_episode_count     IN       sak_memo_item.mei_episode_count%TYPE,
      i_gen_SVOD_Rights          IN     fid_general.gen_svod_rights%TYPE,
      i_gen_express              IN     fid_general.gen_express%TYPE,
      i_gen_archive              IN     fid_general.GEN_ARCHIVE%TYPE,
      i_gen_catelogue            IN     fid_general.GEN_CATALOGUE%TYPE,
      o_mem_con_price               OUT sak_memo.mem_con_price%TYPE,
      --o_mei_first_episode_price   OUT      sak_memo_item.mei_first_episode_price%TYPE,
      o_mem_update_count            OUT sak_memo.mem_update_count%TYPE,
      o_mei_update_count            OUT sak_memo_item.mei_update_count%TYPE);

   PROCEDURE prc_delete_program_details (
      i_mei_id             IN     sak_memo_item.mei_id%TYPE,
      i_mei_gen_refno      IN     sak_memo_item.mei_gen_refno%TYPE,
      i_mei_update_count   IN     sak_memo_item.mei_update_count%TYPE,
      o_deleted               OUT NUMBER);

   PROCEDURE prc_add_dm_alloc_details (
      i_mei_id              IN     sak_memo_item.mei_id%TYPE,
      i_mei_type_show       IN     sak_memo_item.mei_type_show%TYPE,
      i_mei_gen_refno       IN     sak_memo_item.mei_gen_refno%TYPE,
      i_lee_short_name      IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount          IN     sak_allocation_detail.ald_amount%TYPE,
      i_ald_exhib_days      IN     sak_allocation_detail.ald_exhib_days%TYPE,
      --i_cha_short_name     IN       fid_channel.cha_short_name%TYPE,
      i_cha_number          IN     fid_channel.cha_number%TYPE,
      i_ald_period_tba      IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_ald_period_start    IN     sak_allocation_detail.ald_period_start%TYPE,
      i_ald_period_end      IN     sak_allocation_detail.ald_period_end%TYPE,
      i_ald_black_days      IN     sak_allocation_detail.ald_black_days%TYPE,
      i_ald_cost_runs       IN     sak_allocation_detail.ald_cost_runs%TYPE,
      i_ald_max_runs_cha    IN     sak_allocation_detail.ald_max_runs_cha%TYPE,
      i_ald_max_runs_chs    IN     sak_allocation_detail.ald_max_runs_chs%TYPE,
      ---------------Dev:Africa free repeat:Hari_18-03-2013--------------------
      ---------------adding variables for free repeats and repeat period-------
      i_ald_free_repeat     IN     sak_allocation_detail.ald_free_repeat%TYPE,
      i_ald_repeat_period   IN     sak_allocation_detail.ald_repeat_period%TYPE,
      ---------------END Dev:Africa free repeat--------------------------------
      i_ald_months          IN     sak_allocation_detail.ald_months%TYPE,
      i_ald_lic_type        IN     sak_allocation_detail.ald_lic_type%TYPE,
      i_user_id             IN     sak_allocation_detail.ald_entry_oper%TYPE,
      i_ald_end_days        IN     sak_allocation_detail.ald_end_days%TYPE,
      -- BR_15_144- Warner Payment :Rashmi_Tijare:03-07-2015- added check box for min subs licensee
      i_ald_min_subs_fl     IN     sak_allocation_detail.ALD_MIN_GUA_FLAG%TYPE,
      --End:Warner Payment----
      o_ald_id                 OUT sak_allocation_detail.ald_id%TYPE);

   PROCEDURE prc_update_dm_alloc_details (
      i_mei_id              IN     sak_memo_item.mei_id%TYPE,
      i_ald_id              IN     sak_allocation_detail.ald_id%TYPE,
      i_mei_gen_refno       IN     sak_memo_item.mei_gen_refno%TYPE,
      i_mem_amort_method    IN     sak_memo.mem_amort_method%TYPE,
      i_lee_short_name      IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount          IN     sak_allocation_detail.ald_amount%TYPE,
      i_ald_exhib_days      IN     sak_allocation_detail.ald_exhib_days%TYPE,
      -- i_cha_short_name     IN       fid_channel.cha_short_name%TYPE,
      i_cha_number          IN     fid_channel.cha_number%TYPE,
      i_ald_period_tba      IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_ald_period_start    IN     sak_allocation_detail.ald_period_start%TYPE,
      i_ald_period_end      IN     sak_allocation_detail.ald_period_end%TYPE,
      -- i_ald_live_date      IN       sak_allocation_detail.ald_live_date%TYPE,
      i_ald_black_days      IN     sak_allocation_detail.ald_black_days%TYPE,
      --start: project BIOSCOPE ? PENDING CR?S: MANGESH_20121019
      --[PB_CR_64 update Cost runs,max cha,max chs]
      i_ald_cost_runs       IN     sak_allocation_detail.ald_cost_runs%TYPE,
      i_ald_max_runs_cha    IN     sak_allocation_detail.ald_max_runs_cha%TYPE,
      i_ald_max_runs_chs    IN     sak_allocation_detail.ald_max_runs_chs%TYPE,
      --END: Project Bioscope ? Pending CR?s:
      ---------------Dev:Africa free repeat:Hari_18-03-2013--------------------
      ---------------adding variables for free repeats and repeat period-------
      i_ald_free_repeat     IN     sak_allocation_detail.ald_free_repeat%TYPE,
      i_ald_repeat_period   IN     sak_allocation_detail.ald_repeat_period%TYPE,
      ---------------END Dev:Africa free repeat--------------------------------
      i_ald_months          IN     sak_allocation_detail.ald_months%TYPE,
      i_ald_lic_type        IN     sak_allocation_detail.ald_lic_type%TYPE,
      --i_user_id            IN   sak_allocation_detail.ald_entry_oper%TYPE,
      i_ald_end_days        IN     sak_allocation_detail.ald_end_days%TYPE,
      -- BR_15_144- Warner Payment :Rashmi_Tijare:03-07-2015- added check box for min subs licensee
      i_ald_min_subs_fl     IN     sak_allocation_detail.ALD_MIN_GUA_FLAG%TYPE,
      --End:Warner Payment----
      o_ald_update_count    IN OUT sak_allocation_detail.ald_update_count%TYPE);

   PROCEDURE prc_delete_dm_alloc_details (
      -- i_mei_id             IN       sak_memo_item.mei_id%TYPE,
      i_ald_id             IN     sak_allocation_detail.ald_id%TYPE,
      i_ald_update_count   IN     sak_allocation_detail.ald_update_count%TYPE,
      --i_chr_update_count   IN       sak_channel_runs.chr_update_count%TYPE,
      o_deleted               OUT NUMBER);

   PROCEDURE prc_add_dm_cha_runs (
      i_chr_ald_id         IN     sak_allocation_detail.ald_id%TYPE,
      i_cha_short_name     IN     fid_channel.cha_short_name%TYPE,
      i_chr_number_runs    IN     sak_channel_runs.chr_number_runs%TYPE,
      i_chr_costed_runs    IN     sak_channel_runs.chr_costed_runs%TYPE,
      i_user_id            IN     sak_channel_runs.chr_entry_oper%TYPE,
      i_chr_cost_channel   IN     sak_channel_runs.chr_cost_channel%TYPE,
      /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
      i_chr_max_runs_chr   IN     sak_channel_runs.chr_max_runs_chr%TYPE,
      /*PB (CR): END */
      o_chr_id                OUT sak_channel_runs.chr_id%TYPE);

   PROCEDURE prc_update_dm_cha_runs (
      i_chr_id             IN     sak_channel_runs.chr_id%TYPE,
      i_cha_short_name     IN     fid_channel.cha_short_name%TYPE,
      i_chr_number_runs    IN     sak_channel_runs.chr_number_runs%TYPE,
      i_chr_cost_channel   IN     sak_channel_runs.chr_cost_channel%TYPE,
      i_chr_costed_runs    IN     sak_channel_runs.chr_costed_runs%TYPE,
      i_chr_update_count   IN     sak_channel_runs.chr_update_count%TYPE,
      /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
      i_chr_max_runs_chr   IN     sak_channel_runs.chr_max_runs_chr%TYPE,
      /*PB (CR): END */
      o_chr_update_count      OUT sak_channel_runs.chr_update_count%TYPE);

   PROCEDURE prc_delete_dm_cha_runs (
      --i_chr_ald_id   IN   sak_allocation_detail.ald_id%TYPE,
      i_chr_id             IN     sak_channel_runs.chr_id%TYPE,
      i_chr_update_count   IN     sak_channel_runs.chr_update_count%TYPE,
      o_deleted               OUT NUMBER);

   PROCEDURE prc_check_allocations (
      i_mem_id     IN     sak_memo_item.mei_mem_id%TYPE,
      i_mem_type   IN     sak_memo.mem_type%TYPE,
      o_string        OUT VARCHAR2);

   PROCEDURE prc_check_cha_runs (i_mem_id IN NUMBER --sak_memo_item.mei_mem_id%TYPE
                                                   -- o_message   OUT      VARCHAR2
   );

   PROCEDURE prc_alert (i_alert_name      IN     VARCHAR2,
                        i_button_value    IN     VARCHAR2,
                        o_alert_message      OUT VARCHAR2 -- o_error_message   OUT      VARCHAR2
                                                         );

   PROCEDURE prc_check_live_date (i_mem_id    IN     sak_memo.mem_id%TYPE,
                                  o_message      OUT VARCHAR2);

   PROCEDURE check_amort_rules (
      i_mem_amort_method   IN sak_memo.mem_amort_method%TYPE,
      i_mem_align_ind      IN sak_memo.mem_align_ind%TYPE,
      i_mem_mplex_ind      IN sak_memo.mem_mplex_ind%TYPE);

   PROCEDURE prc_execute_deal_memo (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      i_user_id          IN     VARCHAR2,
      i_val              IN     VARCHAR2,
      i_is_t_exe         IN     VARCHAR2,
      o_con_short_name      OUT fid_contract.con_short_name%TYPE,
      o_mem_status          OUT sak_memo.mem_status%TYPE,
      o_message             OUT VARCHAR2);

   PROCEDURE prc_check_for_sign (i_mem_id    IN     sak_memo.mem_id%TYPE,
                                 o_message      OUT VARCHAR2);

   PROCEDURE prc_create_history (
      i_action       IN     VARCHAR2,
      i_mem_id       IN     sak_memo.mem_id%TYPE,
      i_mem_type     IN     sak_memo.mem_type%TYPE,
      i_user_id      IN     sak_memo.mem_entry_oper%TYPE,
      o_mem_status      OUT sak_memo.mem_status%TYPE,
      i_comment      IN     VARCHAR2 DEFAULT NULL,
        i_metadata_comment In  VARCHAR2 DEFAULT NULL--- Added by rasjmio30-03-2016
        );

   PROCEDURE prc_get_approval_info (i_mem_id              IN     sak_memo.mem_id%TYPE,
                                    o_mem_buyer              OUT VARCHAR2,
                                    o_mem_buyer_date         OUT DATE,
                                    o_mem_approver           OUT VARCHAR2,
                                    o_mem_approval_date      OUT DATE);

   PROCEDURE prc_change_dm_status (
      i_mem_id       IN     sak_memo.mem_id%TYPE,
      i_user_id      IN     sak_memo.mem_entry_oper%TYPE,
      i_status       IN     VARCHAR,
      o_mem_status      OUT VARCHAR2,
      o_message         OUT VARCHAR2,
      i_comment      IN     VARCHAR2 DEFAULT NULL,
      i_metadata_comment In  VARCHAR2 DEFAULT NULL);

   -------------------------------------------- PROCEDURE FOR ALERT PAYMENTS ----------------------------------------------------
   PROCEDURE alert_payments (
      i_mem_id         IN     sak_memo.mem_id%TYPE,
      i_mem_type       IN     sak_memo.mem_type%TYPE,
      i_mem_currency   IN     sak_memo.mem_currency%TYPE,
      o_message           OUT VARCHAR2);

   ------------------------------------------------ PROCEDURE TO CHECK USER AUTHENTICATION ----------------------------------------------------
   PROCEDURE prc_check_user_auth (i_user_id   IN     VARCHAR2,
                                  o_flag         OUT NUMBER,
                                  o_message      OUT VARCHAR2);

   -------------------------------------------- PROCEDURE TO CHECK USER AUTHENTICATION FOR UPDATE ----------------------------------------------
   PROCEDURE prc_check_user_auth_for_update (i_mem_id    IN     NUMBER,
                                             i_user_id   IN     VARCHAR2,
                                             o_flag         OUT NUMBER,
                                             o_message      OUT VARCHAR2);

   -------------/* CACQ3 Catchup :Pranay Kusumwal 18/10/2012 : Deal memo validations
   PROCEDURE prc_check_catchup_validation (i_mem_id IN sak_memo.mem_id%TYPE);

   ------------------------------------------------ PROCEDURE TO CHECK USER INSERT RIGHTS ----------------------------------------------------
   PROCEDURE prc_check_user_insertrights (i_user_id   IN     VARCHAR2,
                                          o_flag         OUT NUMBER);

   ------------------------------------------------ PROCEDURE TO CHECK USER UPDATE RIGHTS ----------------------------------------------------
   PROCEDURE prc_check_user_updaterights (i_mem_id    IN     NUMBER,
                                          i_user_id   IN     VARCHAR2,
                                          o_flag         OUT NUMBER);

   --- Bioscope Changes Added below SP by Anirudha on 20/03/2012
   PROCEDURE prc_copy_dm_prog_alloc (
      i_from_mei_id      IN     sak_allocation_detail.ald_mei_id%TYPE,
      i_to_mei_id_list   IN     VARCHAR2,
      i_entry_oper       IN     sak_allocation_detail.ald_entry_oper%TYPE,
      i_ald_id_list      IN     VARCHAR2,
      o_status              OUT NUMBER);

   PROCEDURE prc_check_cha_runs_rights (
      i_mem_id sak_memo_item.mei_mem_id%TYPE);

   PROCEDURE prc_check_prog_bo_category (
      i_mem_id sak_memo_item.mei_mem_id%TYPE);

   --Commented as per CR 55912 by Anirudha on 23/05/2012
   /*
   PROCEDURE prc_check_media_rights
   (
       i_mem_id    sak_memo_item.mei_mem_id%type
   ); */
   --End Commented as per CR 55912 by Anirudha on 23/05/2012

   -----------------------------------------------------

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for Deal memo making media service/plat implementation on programme level */
   PROCEDURE prc_srch_media_serv_plat (
      i_mem_id           IN     sak_memo_item.mei_mem_id%TYPE,
      i_mei_id           IN     sak_memo_item.mei_id%TYPE,
      o_search_details      OUT SYS_REFCURSOR);

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for Deal memo making media service/plat implementation on programme level */
   ---Procedure for deleting media service/platform---------
   PROCEDURE prc_delete_media_service_plat (i_mapp_id   IN     NUMBER,
                                            i_mem_id    IN     NUMBER,
                                            i_mei_id    IN     NUMBER,
                                            i_user_id   IN     VARCHAR2,
                                            o_status       OUT NUMBER);

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for Deal memo making media service/plat implementation on programme level */
   ---Procedure for inserting new media service/platform---------
   PROCEDURE prc_insert_media_service_plat (i_mapp_id   IN     NUMBER,
                                            i_mem_id    IN     NUMBER,
                                            i_mei_id    IN     NUMBER,
                                            i_user_id   IN     VARCHAR2,
                                            o_status       OUT NUMBER);

   /* PB (CR) : End */
   -------------------------------------------------------
   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   -------------------------------------- PROCEDURE TO add SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_viewsplitpayment (
      i_mem_id          IN     sak_memo.mem_id%TYPE,
      o_paymentresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for Deal memo making media service/plat implementation on programme level */
   ---Procedure for copying media service/platform---------
   PROCEDURE prc_copy_media_service_plat (i_mem_id_from      IN     NUMBER,
                                          i_mei_id_from      IN     NUMBER,
                                          i_mei_id_to_list   IN     VARCHAR2,
                                          i_user_id          IN     VARCHAR2,
                                          o_status              OUT NUMBER);

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   -------------------------------------- PROCEDURE TO add SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_addsplitpayment (
      i_mem_id           IN     sgy_sak_memo_split_payment.msp_mem_id%TYPE,
      i_sort_order       IN     sgy_sak_memo_split_payment.msp_sort_order%TYPE,
      i_month_num        IN     sgy_sak_memo_split_payment.msp_split_month_num%TYPE,
      i_comment          IN     sgy_sak_memo_split_payment.msp_comments%TYPE,
      i_pct_pay          IN     sgy_sak_memo_split_payment.msp_percent_payment%TYPE,
      i_entry_oper       IN     sgy_sak_memo_split_payment.msp_entry_oper%TYPE,
      o_success_number      OUT NUMBER);

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   ------------------------------------- PROCEDURE TO DELETE PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_deletesplitpayment (
      i_msp_id           IN     sgy_sak_memo_split_payment.msp_id%TYPE,
      i_mem_id           IN     sgy_sak_memo_split_payment.msp_mem_id%TYPE,
      o_paymentdeleted      OUT NUMBER);

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   ------------------------------------- PROCEDURE TO UPDATE PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_editsplitpayment (
      i_msp_id           IN     sgy_sak_memo_split_payment.msp_id%TYPE,
      i_mem_id           IN     sgy_sak_memo_split_payment.msp_mem_id%TYPE,
      i_sort_order       IN     sgy_sak_memo_split_payment.msp_sort_order%TYPE,
      i_month_num        IN     sgy_sak_memo_split_payment.msp_split_month_num%TYPE,
      i_comment          IN     sgy_sak_memo_split_payment.msp_comments%TYPE,
      i_pct_pay          IN     sgy_sak_memo_split_payment.msp_percent_payment%TYPE,
      i_entry_oper       IN     sgy_sak_memo_split_payment.msp_entry_oper%TYPE,
      o_success_number      OUT NUMBER);

   /* PB (CR) : End */
   FUNCTION qarequired (i_mem_id IN NUMBER)
      RETURN VARCHAR2;

   --- END Bioscope Changes Added below SP by Anirudha on 20/03/2012

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will ADD the values for catchup licensee grid ALLOCATION*/
   PROCEDURE prc_add_catchup_alloc_details (
      i_mei_id                  IN     sak_memo_item.mei_id%TYPE,
      -- i_mei_type_show      IN       sak_memo_item.mei_type_show%TYPE,
      i_mei_gen_refno           IN     sak_memo_item.mei_gen_refno%TYPE,
      i_lee_short_name          IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount              IN     sak_allocation_detail.ald_amount%TYPE,
      i_ald_exhib_days          IN     sak_allocation_detail.ald_exhib_days%TYPE,
      i_ald_period_tba          IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_ald_period_start        IN     sak_allocation_detail.ald_period_start%TYPE,
      --  i_cha_number         IN       fid_channel.cha_number%TYPE,
      i_ald_period_end          IN     sak_allocation_detail.ald_period_end%TYPE,
      i_ald_cost_runs           IN     sak_allocation_detail.ald_cost_runs%TYPE,
      i_ald_months              IN     sak_allocation_detail.ald_months%TYPE,
      i_user_id                 IN     sak_allocation_detail.ald_entry_oper%TYPE,
      i_ald_end_days            IN     sak_allocation_detail.ald_end_days%TYPE,
      i_ald_max_vp              IN     sak_allocation_detail.ald_max_vp%TYPE,
      i_ald_non_cons_month      IN     sak_allocation_detail.ald_non_cons_month%TYPE,
      --CACq14:start :Adde by sushma on 11-NOV-2014 to insert newly added fields in catch up allocation grid
      i_ALLOW_BEFORE_LNR        IN     sak_allocation_detail.ALD_ALLOW_BEFORE_LNR%TYPE,
      i_ALLOW_DAYS_BEFORE_LNR   IN     sak_allocation_detail.ALD_ALLOW_DAYS_BEFORE_LNR%TYPE,
      i_ALLOW_WITHOUT_LNR_REF   IN     sak_allocation_detail.ALD_ALLOW_WITHOUT_LNR_REF%TYPE, --END
      o_ald_id                     OUT sak_allocation_detail.ald_id%TYPE);

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will update the values for catchup licensee grid ALLOCATION*/
   PROCEDURE prc_upd_catchup_alloc_details (
      i_mei_id                  IN     sak_memo_item.mei_id%TYPE,
      i_ald_id                  IN     sak_allocation_detail.ald_id%TYPE,
      i_mei_gen_refno           IN     sak_memo_item.mei_gen_refno%TYPE,
      i_mem_amort_method        IN     sak_memo.mem_amort_method%TYPE,
      i_lee_short_name          IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount              IN     sak_allocation_detail.ald_amount%TYPE,
      i_ald_exhib_days          IN     sak_allocation_detail.ald_exhib_days%TYPE,
      i_ald_period_tba          IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_ald_period_start        IN     sak_allocation_detail.ald_period_start%TYPE,
      --  i_cha_number         IN       fid_channel.cha_number%TYPE,
      i_ald_period_end          IN     sak_allocation_detail.ald_period_end%TYPE,
      i_ald_months              IN     sak_allocation_detail.ald_months%TYPE,
      i_ald_end_days            IN     sak_allocation_detail.ald_end_days%TYPE,
      i_ald_max_vp              IN     sak_allocation_detail.ald_max_vp%TYPE,
      i_ald_non_cons_month      IN     sak_allocation_detail.ald_non_cons_month%TYPE,
      i_ald_cost_runs           IN     sak_allocation_detail.ald_cost_runs%TYPE,
      --CACq14:start :Adde by sushma on 11-NOV-2014 to insert newly added fields in catch up allocation grid
      i_ALLOW_BEFORE_LNR        IN     sak_allocation_detail.ALD_ALLOW_BEFORE_LNR%TYPE,
      i_ALLOW_DAYS_BEFORE_LNR   IN     sak_allocation_detail.ALD_ALLOW_DAYS_BEFORE_LNR%TYPE,
      i_ALLOW_WITHOUT_LNR_REF   IN     sak_allocation_detail.ALD_ALLOW_WITHOUT_LNR_REF%TYPE, --END
      o_ald_update_count        IN OUT sak_allocation_detail.ald_update_count%TYPE);

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will add the values for catchup licensee platform */
   PROCEDURE prc_add_catchup_platform (
      i_ald_id           IN     sak_allocation_detail.ald_id%TYPE,
      i_mapp_id          IN     sgy_pb_med_platm_service_map.mpsm_mapp_id%TYPE,
      o_sucess_integer      OUT NUMBER,
      o_plat_integer        OUT NUMBER);

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will edit the values for catchup licensee platform */
   PROCEDURE prc_update_catchup_platform (
      i_lee_plat_id      IN     x_cp_licensee_platform.cp_lee_plat_id%TYPE,
      --i_mapp_id in sgy_pb_med_platm_service_map.MPSM_MAPP_ID%type,
      o_sucess_integer      OUT NUMBER);

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will del the values for catchup licensee platform */
   PROCEDURE prc_delete_catchup_platform (
      i_lee_plat_id      IN     x_cp_licensee_platform.cp_lee_plat_id%TYPE,
      o_sucess_integer      OUT NUMBER);

   /* FINANCE (CFIN 3) :Pranay Kusumwal 22/02/2013 :Start*/
   PROCEDURE x_add_sec_lee_alloc_detail (
      i_mei_id           IN     x_fin_dm_sec_lee.dsl_mei_id%TYPE,
      i_lee_short_name   IN     fid_licensee.lee_short_name%TYPE,
      i_primary_lee      IN     fid_licensee.lee_short_name%TYPE,
      i_entry_oper       IN     x_fin_dm_sec_lee.dsl_entry_oper%TYPE,
      i_dsl_amount       IN     x_fin_dm_sec_lee.dsl_amount%TYPE,
      o_dsl_id              OUT x_fin_dm_sec_lee.dsl_number%TYPE);

   PROCEDURE x_update_sec_lee_alloc_detail (
      i_dsl_id             IN     x_fin_dm_sec_lee.dsl_number%TYPE,
      i_dsl_amount         IN     x_fin_dm_sec_lee.dsl_amount%TYPE,
      i_lee_short_name     IN     fid_licensee.lee_short_name%TYPE,
      --   i_is_primary         IN    x_fin_dm_sec_lee.DSL_IS_PRIMARY%type,
      i_dsl_mei_id         IN     x_fin_dm_sec_lee.dsl_mei_id%TYPE,
      o_dsl_update_count   IN OUT x_fin_dm_sec_lee.dsl_update_count%TYPE);

   PROCEDURE x_delete_x_lee_alloc_detail (
      i_dsl_id             IN     x_fin_dm_sec_lee.dsl_number%TYPE,
      i_dsl_update_count   IN     x_fin_dm_sec_lee.dsl_update_count%TYPE,
      o_deleted               OUT NUMBER);

   -- Hari mandal SAP -----------------------
   PROCEDURE x_fin_deal_price_rounding (i_mem_id NUMBER);

   FUNCTION setglobalvariable (i_user IN VARCHAR2)
      RETURN NUMBER;

   FUNCTION getglobalvariable
      RETURN VARCHAR2;

   ----- END --------------------------
   /* FINANCE (CFIN 3) :Pranay Kusumwal 22/02/2013 :END*/
   PROCEDURE x_prc_check_t_exec_rights (
      i_dm_number              IN     sak_memo.MEM_ID%TYPE,
      i_proc_type              IN     sak_memo.MEM_CON_PROCUREMENT_TYPE%TYPE,
      i_contract_number        IN     fid_contract.con_short_name%TYPE,
      i_user_id                IN     sak_memo.MEM_ENTRY_OPER%TYPE,
      o_t_exc_right               OUT VARCHAR2,
      o_t_exc_proc_type           OUT VARCHAR2 --Dev.R3 : UID_Placeholder CR : Start : [Devashish Raverkar]_[2014/06/02]
                                              ,
      o_t_exc_is_con_act_lic      OUT VARCHAR2);

   --Dev.R3 : UID_Placeholder CR : End :

   PROCEDURE X_prc_view_min_gurantee_plan (
      i_mem_id           IN     x_dm_mg_pay_plan.DMGP_DM_NUMBER%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data);

   PROCEDURE X_dm_prc_edit_min_gurante_plan (
      i_mem_id           IN     x_dm_mg_pay_plan.DMGP_DM_NUMBER%TYPE,
      i_split_month_no   IN     x_dm_mg_pay_plan.DMGP_SPLIT_MONTH_NO%TYPE,
      i_split_percent    IN     x_dm_mg_pay_plan.DMGP_SPLIT_PERCENT%TYPE,
      i_sort_order       IN     x_dm_mg_pay_plan.DMGP_SORT_ORDER%TYPE,
      i_split_comment    IN     x_dm_mg_pay_plan.DMGP_COMMENTS%TYPE,
      i_entry_oper       IN     x_dm_mg_pay_plan.DMGP_ENTRY_OP%TYPE,
      o_dmpg_number         OUT x_dm_mg_pay_plan.DMGP_NUMBER%TYPE);

   PROCEDURE X_dm_prc_upd_min_gurante_plan (
      i_split_number     IN     x_dm_mg_pay_plan.DMGP_NUMBER%TYPE,
      i_mem_id           IN     x_dm_mg_pay_plan.DMGP_DM_NUMBER%TYPE,
      i_split_month_no   IN     x_dm_mg_pay_plan.DMGP_SPLIT_MONTH_NO%TYPE,
      i_split_percent    IN     x_dm_mg_pay_plan.DMGP_SPLIT_PERCENT%TYPE,
      i_sort_order       IN     x_dm_mg_pay_plan.DMGP_SORT_ORDER%TYPE,
      i_split_comment    IN     x_dm_mg_pay_plan.DMGP_COMMENTS%TYPE,
      i_entry_oper       IN     x_dm_mg_pay_plan.DMGP_ENTRY_OP%TYPE,
      i_update_count     IN     x_dm_mg_pay_plan.DMGP_UPDATE_COUNT%TYPE,
      o_paymentupdated      OUT NUMBER);

   PROCEDURE X_dm_prc_del_min_gurante_plan (
      i_dmgp_number      IN     X_DM_MG_PAY_PLAN.DMGP_NUMBER%TYPE,
      i_dmgp_mem_id      IN     X_DM_MG_PAY_PLAN.DMGP_DM_NUMBER%TYPE,
      i_entry_oper       IN     x_dm_mg_pay_plan.DMGP_ENTRY_OP%TYPE,
      i_update_count     IN     X_DM_MG_PAY_PLAN.DMGP_UPDATE_COUNT%TYPE,
      o_paymentdeleted      OUT NUMBER);

   --CACQ14:Start : Added by sushma on 12-NOV-2014 to get the all media device rights                                               );
   PROCEDURE prc_get_med_dev_rights (
      i_CON_SHORT_NAME        IN     fid_contract.CON_SHORT_NAME%TYPE,
      i_is_fea_ser            IN     VARCHAR2,
      i_lee_short_name        IN     fid_licensee.lee_short_name%TYPE,
      o_get_med_rights           OUT pkg_adm_cm_dealmemo.cursor_data,
      o_get_med__dev_rights      OUT pkg_adm_cm_dealmemo.cursor_data);

   --CATCHUP:CACQ14: ADDed By SUSHMA K. on 11-nov-2014
   --To insert thecatch up  media device rights on deal level (program level)
   PROCEDURE prc_add_deal_medplatmdevcomp (
      i_ald_id               IN     sak_allocation_detail.ALD_ID%TYPE,
      i_MPDC_DEV_PLATM_ID    IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_DEV_PLATM_ID%TYPE,
      i_rights_on_device     IN     VARCHAR2,
      i_med_comp_rights      IN     VARCHAR2,
      i_med_IS_COMP_RIGHTS   IN     VARCHAR2,
      i_entry_oper           IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_ENTRY_OPER%TYPE,
      o_status                  OUT NUMBER);

   PROCEDURE prc_add_temp_con_rights (
      i_mem_id                  IN     sak_memo.mem_ID%TYPE,
      i_MPDC_DEV_PLATM_ID       IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_DEV_PLATM_ID%TYPE,
      i_rights_on_device        IN     VARCHAR2,
      i_med_comp_rights         IN     VARCHAR2,
      i_med_IS_COMP_RIGHTS      IN     VARCHAR2,
      i_is_fea_ser              IN     VARCHAR2,
      i_ALLOW_BEFORE_LNR        IN     X_CP_temp_ins_CON_MED_rights.CTI_ALLOW_BEFORE_LNR%TYPE,
      i_ALLOW_DAYS_BEFORE_LNR   IN     X_CP_temp_ins_CON_MED_rights.CTI_ALLOW_DAYS_BEFORE_LNR%TYPE,
      i_ALLOW_WITHOUT_LNR_REF   IN     X_CP_temp_ins_CON_MED_rights.CTI_ALLOW_WITHOUT_LNR_REF%TYPE,
      i_entry_oper              IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_ENTRY_OPER%TYPE,
      o_status                     OUT NUMBER);

   --END

   --- Added By RAshmi For DSTV
   PROCEDURE x_prc_add_con_right (
      i_mem_id             IN     sak_memo.mem_ID%TYPE,
      i_DRDT_DEV_ID        IN     VARCHAR2,
      i_rights_on_device   IN     VARCHAR2,
      i_entry_oper         IN     X_DSTV_TEMP_DATA_DEAL.DRDT_MODIFIED_BY%TYPE,
      o_status                OUT NUMBER);

   /****************************************************************
   Function to Split String using Delimiter
   ****************************************************************/
   FUNCTION split_to_char (p_list VARCHAR2, p_del VARCHAR2 := ',')
      RETURN t_in_list_tab
      PIPELINED;

   FUNCTION X_FUN_REMOVE_EXTRA_CHAR (I_TITLE FID_GENERAL.GEN_TITLE%TYPE)
      RETURN VARCHAR2;

   PROCEDURE x_prc_dup_title_check (
      i_title       IN     fid_general.GEN_TITLE%TYPE,
      i_pgm_type    IN     fid_general.GEN_TYPE%TYPE,
      i_prod_year          fid_general.GEN_RELEASE_YEAR%TYPE,
      o_search         OUT pkg_adm_cm_dealmemo.c_deal_memo_prog_details);

   --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
   FUNCTION X_FNC_GET_SCH_INFO (I_GEN_REFNO IN NUMBER)
      RETURN VARCHAR2;
--RDT End : Acquision Requirements BR_15_104

 -- CU4ALL Start : Deal Memo validation for Max No of VP [Shubhada Bongarde]
  Function X_FUN_MAX_VP_VALIDATION(
      i_mei_id IN NUMBER,
      i_ald_exhib_days IN NUMBER,
      i_mei_gen_refno IN NUMBER
  )RETURN  VARCHAR2;
-- CU4ALL End

PROCEDURE    X_PRC_SEND_METADATA_EMAIL(i_mem_id in number,
                                       i_user_id in varchar2,
                                       i_status in varchar2
                                       );
PROCEDURE X_PRC_GET_OPEN_MONTH (
							    I_LEE_SHORT_NAME IN  FID_LICENSEE.LEE_SHORT_NAME%TYPE,
							    OPEN_MONTH       OUT VARCHAR2
							   );

END pkg_adm_cm_dealmemo;
/
CREATE OR REPLACE PACKAGE BODY PKG_ADM_CM_DEALMEMO
AS
   /******************************************************************************
      NAME:       pkg_adm_cm_dealmemo.pkb
      PURPOSE:

      REVISIONS:
      Ver        Date        Author                   Description
      ---------  ----------  ---------------         ------------------------------------
      1.0        2/19/2010   Omkar Chavan/Nirupama R  1. Created this package.
   ******************************************************************************/

   ---------------------PROCEDURE FOR DEAL MEMO REVIEW--------------------------------------------------------------------------
   PROCEDURE prc_adm_dmreview_search (
      i_mem_id               IN     VARCHAR2,
      i_mem_date             IN     sak_memo.mem_date%TYPE,
      i_mem_lee_short_name   IN     fid_licensee.lee_short_name%TYPE,
      i_com_short_name       IN     fid_company.com_short_name%TYPE,
      i_gen_title            IN     fid_general.gen_title%TYPE,
      i_gen_title_working    IN     fid_general.gen_title_working%TYPE,
      i_gen_category         IN     fid_general.gen_category%TYPE,
      i_gen_subgenre         IN     fid_general.gen_subgenre%TYPE,
      i_gen_event            IN     fid_general.gen_event%TYPE,
      i_ald_lee_short_name   IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount           IN     VARCHAR2,
      --sak_allocation_detail.ald_amount%TYPE,
      i_mei_episode_count    IN     VARCHAR2,
      --sak_memo_item.mei_episode_count%TYPE,
      i_ald_period_start     IN     sak_allocation_detail.ald_period_start%TYPE,
      i_ald_period_end       IN     sak_allocation_detail.ald_period_end%TYPE,
      i_ald_period_tba       IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_mem_buyer            IN     sak_memo.mem_buyer%TYPE,
      i_mem_approver         IN     sak_memo.mem_approver%TYPE,
      i_mem_status           IN     sak_memo.mem_status%TYPE,
      o_dm_review_cursor        OUT pkg_adm_cm_dealmemo.c_dm_review_cursor)
   AS
      l_query_string              VARCHAR2 (20000);
      l_dm_status_change_golive   x_fin_configs.CONTENT%TYPE;
   BEGIN
      SELECT CONTENT
        INTO l_dm_status_change_golive
        FROM x_fin_configs
       WHERE KEY = 'DM_STATUS_CHNAGE_GOLIVE';

      /*l_query_string :=
         'SELECT mem_id, mem_date, mem_lee_short_name, com_short_name, gen_title,
       gen_title_working,  gen_category, gen_subgenre, gen_event,
       mei_episode_count, ald_lee_short_name, ald_amount,
       ald_period_tba,  mem_status, mem_buyer,mem_approver,
       ald_period_start_n ald_period_start, ald_period_end_n ald_period_end
       FROM (SELECT mem_id, mem_date, a.lee_short_name mem_lee_short_name,
               com_short_name, gen_title, gen_title_working, gen_refno,
               gen_category, gen_subgenre, gen_event, mei_episode_count,
               b.lee_short_name ald_lee_short_name, mem_currency, ald_amount,
               fgl_live_date, ald_period_start, ald_period_end,
               ald_period_tba, ald_months, ald_end_days, mem_status,
               mem_buyer, mem_approver, cod_attr1, cod_attr2,
               CASE
                  WHEN (ald_period_start IS NULL AND ald_period_tba != ''Y''
                       )
                     THEN fgl_live_date
                  ELSE ald_period_start
               END ald_period_start_n,
               CASE
                  WHEN ald_period_end IS NULL
                  AND ald_period_tba != ''Y''
                  AND ald_end_days IS NULL
                     THEN ADD_MONTHS (fgl_live_date, ald_months)
                  ELSE CASE
                  WHEN ald_period_end IS NULL
                  AND ald_period_tba != ''Y''
                  AND ald_months IS NULL
                     THEN fgl_live_date + ald_end_days
                  ELSE ald_period_end
               END
               END ald_period_end_n
          FROM sak_memo,
               sak_memo_item,
               sak_allocation_detail,
               fid_licensee a,
               fid_licensee b,
               fid_company,
               fid_general,
               fid_gen_live,
               fid_code
         WHERE mem_id = mei_mem_id(+)
           AND mei_id = ald_mei_id(+)
           AND mei_gen_refno = gen_ser_number
           AND gen_refno(+) = fgl_gen_refno
           AND mem_lee_number = a.lee_number(+)
           AND ald_lee_number = b.lee_number(+)
           AND mem_com_number = com_number
           AND cod_type = ''GEN_TYPE''
           AND cod_value = mei_type_show
           AND cod_attr1 = ''Y''
        UNION ALL
        SELECT mem_id, mem_date, a.lee_short_name mem_lee_short_name,
               com_short_name, gen_title, gen_title_working, gen_refno,
               gen_category, gen_subgenre, gen_event, mei_episode_count,
               b.lee_short_name ald_lee_short_name, mem_currency, ald_amount,
               fgl_live_date, ald_period_start, ald_period_end,
               ald_period_tba, ald_months, ald_end_days, mem_status,
               mem_buyer, mem_approver, cod_attr1, cod_attr2,
               CASE
                  WHEN (ald_period_start IS NULL AND ald_period_tba != ''Y''
                       )
                     THEN fgl_live_date
                  ELSE ald_period_start
               END ald_period_start_n,
               CASE
                  WHEN ald_period_end IS NULL
                  AND ald_period_tba != ''Y''
                  AND ald_end_days IS NULL
                     THEN ADD_MONTHS (fgl_live_date, ald_months)
                  ELSE CASE
                  WHEN ald_period_end IS NULL
                  AND ald_period_tba != ''Y''
                  AND ald_months IS NULL
                     THEN fgl_live_date + ald_end_days
                  ELSE ald_period_end
               END
               END ald_period_end_n
          FROM sak_memo,
               sak_memo_item,
               sak_allocation_detail,
               fid_licensee a,
               fid_licensee b,
               fid_company,
               fid_general,
               fid_gen_live,
               fid_code
         WHERE mem_id = mei_mem_id(+)
           AND mei_id = ald_mei_id(+)
           AND mei_gen_refno = gen_refno
           AND gen_refno(+) = fgl_gen_refno
           AND gen_ser_number IS NULL
           AND mem_lee_number = a.lee_number(+)
           AND ald_lee_number = b.lee_number(+)
           AND mem_com_number = com_number
           AND cod_type = ''GEN_TYPE''
           AND cod_value = mei_type_show
           AND cod_attr1 != ''Y'')  where rownum<=500';
      l_query_string :=
         'SELECT mem_id, mem_date, mem_lee_short_name, com_short_name, gen_title,
                   gen_title_working, gen_category, gen_subgenre, gen_event,
                   mei_episode_count, ald_lee_short_name, ald_amount, ald_period_tba,
                   mem_status, mem_buyer, mem_approver,
                   ald_period_start_n ald_period_start, ald_period_end_n ald_period_end
              FROM (SELECT mem_id, mem_date, a.lee_short_name mem_lee_short_name,
                           com_short_name, gen_title, gen_title_working, gen_refno,
                           gen_category, gen_subgenre, gen_event, mei_episode_count,
                           b.lee_short_name ald_lee_short_name, mem_currency, ald_amount,
                           NULL fgl_live_date, ald_period_start, ald_period_end,
                           ald_period_tba, ald_months, ald_end_days, mem_status,
                           mem_buyer, mem_approver, cod_attr1, cod_attr2,
                           NULL ald_period_start_n, NULL ald_period_end_n
                      FROM sak_memo,
                           sak_memo_item,
                           sak_allocation_detail,
                           fid_licensee a,
                           fid_licensee b,
                           fid_company,
                           fid_general,
                           --  fid_gen_live,
                           fid_code
                     WHERE mem_id = mei_mem_id(+)
                       AND mei_id = ald_mei_id(+)
                       AND mei_gen_refno = gen_ser_number
                       --AND gen_refno(+) = fgl_gen_refno
                       AND mem_lee_number = a.lee_number(+)
                       AND ald_lee_number = b.lee_number(+)
                       AND mem_com_number = com_number
                       AND cod_type = ''GEN_TYPE''
                       AND cod_value = mei_type_show
                       AND cod_attr1 = ''Y''
                    --and  mem_id =3137
                    UNION ALL
                    SELECT mem_id, mem_date, mem_lee_short_name, com_short_name,
                           gen_title, gen_title_working, gen_refno, gen_category,
                           gen_subgenre, gen_event, mei_episode_count, ald_lee_short_name,
                           mem_currency, ald_amount, fgl_live_date, ald_period_start,
                           ald_period_end, ald_period_tba, ald_months, ald_end_days,
                           mem_status, mem_buyer, mem_approver, cod_attr1, cod_attr2,
                           CASE
                              WHEN (ald_period_start IS NULL AND ald_period_tba != ''Y''
                                   )
                                 THEN fgl_live_date
                              ELSE ald_period_start
                           END ald_period_start_n,
                           CASE
                              WHEN ald_period_end IS NULL
                              AND ald_period_tba != ''Y''
                              AND ald_end_days IS NULL
                                 THEN ADD_MONTHS (fgl_live_date, ald_months)
                              ELSE CASE
                              WHEN ald_period_end IS NULL
                              AND ald_period_tba != ''Y''
                              AND ald_months IS NULL
                                 THEN fgl_live_date + ald_end_days
                              ELSE ald_period_end
                           END
                           END ald_period_end_n
                      FROM (SELECT mem_id, mem_date, a.lee_short_name mem_lee_short_name,
                                   com_short_name, gen_title, gen_title_working,
                                   gen_refno, gen_category, gen_subgenre, gen_event,
                                   mei_episode_count, b.lee_short_name ald_lee_short_name,
                                   mem_currency, ald_amount,
                                                            --fgl_live_date,
                                                            ald_period_start,
                                   ald_period_end, ald_period_tba, ald_months,
                                   ald_end_days, mem_status, mem_buyer, mem_approver,
                                   cod_attr1, cod_attr2
                              FROM sak_memo,
                                   sak_memo_item,
                                   sak_allocation_detail,
                                   fid_licensee a,
                                   fid_licensee b,
                                   fid_company,
                                   fid_general,
                                   -- fid_gen_live,
                                   fid_code
                             WHERE mem_id = mei_mem_id(+)
                               AND mei_id = ald_mei_id(+)
                               AND mei_gen_refno = gen_refno
                               --AND gen_refno(+) = fgl_gen_refno
                               AND gen_ser_number IS NULL
                               AND mem_lee_number = a.lee_number(+)
                               AND ald_lee_number = b.lee_number(+)
                               AND mem_com_number = com_number
                               AND cod_type = ''GEN_TYPE''
                               AND cod_value = mei_type_show
                               AND cod_attr1 != ''Y''
                                                   --and mem_id =3137
                           ) a
                           LEFT JOIN
                           (SELECT fgl_live_date, fgl_gen_refno
                              FROM fid_gen_live) b
                           ON a.gen_refno = b.fgl_gen_refno          --where  mem_id =3137
                           )
             WHERE ROWNUM <= 500';*/
      l_query_string :=
         'SELECT mem_id, mem_date, mem_lee_short_name,com_short_name, gen_title,
          gen_title_working, gen_refno, gen_category, gen_subgenre,
       gen_event, mei_episode_count,ald_lee_short_name,ald_amount, ald_period_tba,
       mem_status, mem_buyer, mem_approver,mem_currency,ald_months, ald_end_days,
       fgl_live_date,ald_period_start,ald_period_end,
        NVL((  SELECT ''N''
        FROM SAK_MEMO_HISTORY
        WHERE  mhi_action   =''EXECUTE''
        AND MHI_ENTRY_DATE < '''
         || l_dm_status_change_golive
         || '''
        AND MHI_FROM_STAT <> ''BUDGETED''
        AND MHI_MEM_ID = mem_id
        AND ROWNUM < 2
        ),''Y'')dm_status_change_aply
       from  (SELECT mem_id, mem_date, mem_lee_short_name,com_short_name, gen_title,
          gen_title_working, gen_refno, gen_category, gen_subgenre,
       gen_event, mei_episode_count,ald_lee_short_name,ald_amount, ald_period_tba,
       mem_status, mem_buyer, mem_approver,mem_currency,
       ald_months, ald_end_days,fgl_live_date,
       CASE
          WHEN (ald_period_start IS NULL AND ald_period_tba != ''Y''
               )
             THEN fgl_live_date
          ELSE ald_period_start
       END ald_period_start,
       CASE
          WHEN ald_period_end IS NULL
          AND ald_period_tba != ''Y''
          AND ald_end_days IS NULL
             THEN ADD_MONTHS (fgl_live_date, ald_months)
          ELSE CASE
          WHEN ald_period_end IS NULL
          AND ald_period_tba != ''Y''
          AND ald_months IS NULL
             THEN fgl_live_date + ald_end_days
          ELSE ald_period_end
       END
       END ald_period_end
  FROM (SELECT mem_id, mei_id, mem_date, mem_lee_short_name, com_short_name,
               mem_currency, mem_status, mem_buyer, mem_approver, gen_title,
               gen_title_working, gen_refno, gen_category, gen_subgenre,
               gen_event, mei_episode_count, cod_attr1, cod_attr2,
               fgl_live_date
          FROM (SELECT mem_id, mem_date, a.lee_short_name mem_lee_short_name,
                       com_short_name, mem_currency, mem_status, mem_buyer,
                       mem_approver
                  FROM sak_memo, fid_licensee a, fid_company
                 WHERE mem_lee_number = a.lee_number(+)
                   AND mem_lee_number = a.lee_number(+)
                   AND mem_com_number = com_number(+)) a
               LEFT JOIN
               (SELECT mei_mem_id, mei_id, gen_title, gen_title_working,
                       gen_ser_number gen_refno, gen_category, gen_subgenre,
                       gen_event, mei_episode_count, cod_attr1, cod_attr2,
                       NULL fgl_live_date
                  FROM sak_memo_item, fid_general, fid_code
                 WHERE mei_gen_refno = gen_ser_number
                   AND cod_type = ''GEN_TYPE''
                   AND cod_value = mei_type_show
                   AND cod_attr1 = ''Y''
                UNION
                SELECT mei_mem_id, mei_id, gen_title, gen_title_working,
                       gen_refno, gen_category, gen_subgenre, gen_event,
                       mei_episode_count, cod_attr1, cod_attr2, fgl_live_date
                  FROM (SELECT mei_mem_id, mei_id, gen_title,
                               gen_title_working, gen_refno, gen_category,
                               gen_subgenre, gen_event, mei_episode_count,
                               cod_attr1, cod_attr2
                          FROM sak_memo_item, fid_general, fid_code
                         WHERE mei_gen_refno = gen_refno
                           AND gen_ser_number IS NULL
                           AND cod_type = ''GEN_TYPE''
                           AND cod_value = mei_type_show
                           AND cod_attr1 != ''Y'') a
                       LEFT JOIN
                       (SELECT fgl_live_date, fgl_gen_refno
                          FROM fid_gen_live) b ON a.gen_refno =
                                                               b.fgl_gen_refno
                       ) b ON a.mem_id = b.mei_mem_id
               ) c
       LEFT JOIN
       (SELECT ald_mei_id, b.lee_short_name ald_lee_short_name, ald_amount,
               ald_period_start, ald_period_end, ald_period_tba, ald_months,
               ald_end_days
          FROM sak_allocation_detail, fid_licensee b
         WHERE ald_lee_number = b.lee_number) d ON mei_id = ald_mei_id WHERE 1=1';

      IF i_mem_id IS NOT NULL
      THEN
         l_query_string :=
            l_query_string || ' and  mem_id like ''' || i_mem_id || '''';
      END IF;

      IF i_mem_date IS NOT NULL
      THEN
         l_query_string :=
            l_query_string || ' and  mem_date like ''' || i_mem_date || '''';
      END IF;

      IF i_mem_lee_short_name IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  upper(mem_lee_short_name) like '''
            || UPPER (i_mem_lee_short_name)
            || '''';
      END IF;

      IF i_com_short_name IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  upper(com_short_name) like '''
            || UPPER (i_com_short_name)
            || '''';
      END IF;

      IF i_gen_title IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(gen_title) like '''
            || UPPER (i_gen_title)
            || '''';
      END IF;

      IF i_gen_title_working IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(gen_title_working) like '''
            || UPPER (i_gen_title_working)
            || '''';
      END IF;

      IF i_gen_category IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  upper(gen_category) like '''
            || UPPER (i_gen_category)
            || '''';
      END IF;

      IF i_gen_subgenre IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  upper(gen_subgenre) like '''
            || UPPER (i_gen_subgenre)
            || '''';
      END IF;

      IF i_gen_event IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  upper(gen_event)    like '''
            || UPPER (i_gen_event)
            || '''';
      END IF;

      IF i_ald_lee_short_name IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  upper(ald_lee_short_name)   like '''
            || UPPER (i_ald_lee_short_name)
            || '''';
      END IF;

      IF i_ald_amount IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and   ald_amount like '''
            || i_ald_amount
            || '''';
      END IF;

      IF i_mei_episode_count IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  mei_episode_count like '''
            || i_mei_episode_count
            || '''';
      END IF;

      IF i_ald_period_start IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  ald_period_start like '''
            || i_ald_period_start
            || '''';
      END IF;

      IF i_ald_period_end IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  ald_period_end  like '''
            || i_ald_period_end
            || '''';
      END IF;

      IF i_ald_period_tba = 'Y'                                  --IS NOT NULL
      THEN
         l_query_string :=
            l_query_string || ' and  upper(ald_period_tba) =''Y''';
      --     like '''
      -- || UPPER (i_ald_period_tba)
      --|| '''';
      END IF;

      IF i_mem_buyer IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(mem_buyer) like '''
            || UPPER (i_mem_buyer)
            || '''';
      END IF;

      IF i_mem_approver IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and upper(mem_approver) like '''
            || UPPER (i_mem_approver)
            || '''';
      END IF;

      IF i_mem_status IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and  upper(mem_status) like '''
            || UPPER (i_mem_status)
            || '''';
      END IF;

      l_query_string :=
         l_query_string
         || ' order by mem_id desc,mem_date desc) where  ROWNUM <= 10000';

      -- DBMS_OUTPUT.put_line (l_query_string);

      OPEN o_dm_review_cursor FOR l_query_string;
   END prc_adm_dmreview_search;

   ------------------------------------------PROCEDURE FOR FINDING CHANNEL SERVICE/CHANNEL SHORT NAME-------------------------------
   PROCEDURE find_chs_cha_short_nm (i_chsnumber      IN     NUMBER,
                                    --i_Chuval         in  varchar2,
                                    o_chsshortname      OUT VARCHAR2,
                                    o_chashortname      OUT VARCHAR2)
   AS
      CURSOR chsqry_c
      IS
         SELECT *
           FROM fid_channel_service
          WHERE chs_number = i_chsnumber;

      chsqry              chsqry_c%ROWTYPE;

      CURSOR chaqry_c
      IS
         SELECT *
           FROM fid_channel
          WHERE cha_number = i_chsnumber;

      chaqry              chaqry_c%ROWTYPE;
      chsnumberv          NUMBER;
      chsnamev            VARCHAR2 (40);
      chsshortnamev       VARCHAR2 (4);
      channel_not_found   EXCEPTION;
      l_message           VARCHAR2 (200);
   BEGIN
      IF i_chsnumber IS NOT NULL
      THEN
         /*
            We are being passed the Service number, hence we must be
            in a post-query situation.  Look first in the channel service
            table then, if not successful, in the channel table.
         */
         OPEN chsqry_c;

         FETCH chsqry_c INTO chsqry;

         IF chsqry_c%NOTFOUND
         THEN
            OPEN chaqry_c;

            FETCH chaqry_c INTO chaqry;

            IF chaqry_c%NOTFOUND
            THEN
               l_message := 'Invalid Service. Re-enter, or press <List>.';
            ELSE
               chsnamev := chaqry.cha_name;
               --chsshortnamev := chaqry.cha_short_name;
               o_chashortname := chaqry.cha_short_name;
            END IF;

            CLOSE chaqry_c;
         ELSE
            -- chsnamev      := chsqry.chs_name;
            --chsshortnamev := chsqry.chs_short_name;
            o_chsshortname := chsqry.chs_short_name;
         END IF;

         CLOSE chsqry_c;
      /*
       if ChsNameFld is not null then
        ChsNameFld:=chsnamev;
       end if;
       if ChsShortNameFld is not null then
        ChsShortNameFld:=chsshortnamev;
       end if;
     else

       open chsval_c;
       fetch chsval_c into chsval;
       if chsval_c%notfound then
          open chaval_c;
          fetch chaval_c into chaval;
          if chaval_c%notfound then
             l_message:='Invalid Service. Re-enter, or press <List>.';
             raise channel_not_found;
          else
             chsnumberv := chaval.cha_number;
             chsnamev   := chaval.cha_name;
          end if;
          close chaval_c;
       else
          chsnumberv := chsval.chs_number;
          chsnamev   := chsval.chs_name;
       end if;
       close chsval_c;

       if ChsNumberFld is not null then
         ChsNumberFld:=to_char(chsnumberv);
       end if;
       if ChsNameFld is not null then
         ChsNameFld:=chsnamev;
       end if;*/
      END IF;
   EXCEPTION
      WHEN channel_not_found
      THEN
         raise_application_error (20348, l_message);
   END find_chs_cha_short_nm;

   ------------------------------------- PROCEDURE FOR SEARCH DEAL MEMO --------------------------------------
   PROCEDURE prc_adm_cm_searchdealmemo (
      i_mem_id           IN     VARCHAR2,
      i_contractnumber   IN     fid_contract.con_short_name%TYPE,
      i_status           IN     sak_memo.mem_status%TYPE,
      i_amort_method     IN     sak_memo.mem_amort_method%TYPE,
      i_fromdate         IN     DATE,
      i_todate           IN     DATE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
      querystr                    VARCHAR2 (2000);
      l_connumber                 NUMBER := 0;
      l_fromdate                  DATE;
      l_todate                    DATE;
      l_dm_status_change_golive   x_fin_configs.CONTENT%TYPE;
   BEGIN
      /*IF (i_contractnumber IS NOT NULL)
      THEN
         SELECT con_number
           INTO l_connumber
           FROM fid_contract
          WHERE con_short_name = UPPER (i_contractnumber);
      END IF;*/

      SELECT CONTENT
        INTO l_dm_status_change_golive
        FROM x_fin_configs
       WHERE KEY = 'DM_STATUS_CHNAGE_GOLIVE';

      IF (TO_CHAR (i_fromdate, 'dd/mm/yyyy') = '01/01/0001')
      THEN
         l_fromdate := ADD_MONTHS (SYSDATE, -12000);
      ELSE
         l_fromdate := i_fromdate;
      END IF;

      IF (TO_CHAR (i_todate, 'dd/mm/yyyy') = '01/01/0001')
      THEN
         l_todate := SYSDATE;
      ELSE
         l_todate := i_todate;
      END IF;

      querystr :=
         'select * from (SELECT mem_id, con_short_name contract, f1.com_short_name licensor,
       f2.com_short_name contractentity, lee_short_name main_licensee,
       mem_amort_method method, mem_date,mem_status_date, mem_type type,
       mem_currency currency, mem_status status,
       NVL((  SELECT ''N''
              FROM SAK_MEMO_HISTORY
              WHERE  mhi_action   =''EXECUTE''
              AND MHI_ENTRY_DATE < '''
         || l_dm_status_change_golive
         || '''
              AND MHI_FROM_STAT <>''BUDGETED''
              AND MHI_MEM_ID = mem_id
              AND ROWNUM < 2
       ),''Y'')dm_status_change_aply,
       pkg_adm_cm_dealmemo.QARequired(mem_id)  qa_required,mem_con_procurement_type procurementtype
  FROM sak_memo, fid_contract, fid_licensee, fid_company f1, fid_company f2
 WHERE sak_memo.mem_con_number = fid_contract.con_number(+)
   AND sak_memo.mem_com_number = f1.com_number(+)
   AND sak_memo.mem_agy_com_number = f2.com_number(+)
   AND sak_memo.mem_lee_number = fid_licensee.lee_number(+)
   AND to_char(sak_memo.mem_date,''YYYYMMDD'') between to_char(to_date('''
         || TO_CHAR (L_FROMDATE, 'dd/mm/yyyy')
         || ''',''dd/mm/yyyy''),''YYYYMMDD'') and to_char(to_date('''
         || TO_CHAR (l_todate, 'dd/mm/yyyy')
         || ''',''dd/mm/yyyy''),''YYYYMMDD'')
   ';

      IF (i_mem_id IS NOT NULL)
      THEN
         querystr :=
            querystr || ' AND sak_memo.mem_id like ''' || i_mem_id || '''';
      END IF;

      IF (i_contractnumber IS NOT NULL)
      THEN
         querystr :=
               querystr
            || ' AND  fid_contract.con_short_name like ('''
            || i_contractnumber
            || ''')';
      END IF;

      IF (i_status IS NOT NULL)
      THEN
         querystr :=
               querystr
            || ' AND UPPER(sak_memo.mem_status) like UPPER('''
            || i_status
            || ''')';
      END IF;

      IF (i_amort_method IS NOT NULL)
      THEN
         querystr :=
               querystr
            || ' AND sak_memo.mem_amort_method like UPPER('''
            || i_amort_method
            || ''')';
      END IF;

      querystr :=
         querystr
         || ' Order By mem_date desc,mem_id desc) where rownum<1001 ';

      OPEN o_dealmemoresult FOR querystr;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20349, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_searchdealmemo;

   ------------------------------------- PROCEDURE TO VIEW DETAILS FOR PARTICULAR DEAL MEMO --------------------------------------
   PROCEDURE prc_adm_cm_viewdealmemodetails (
      i_mem_id               IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult          OUT pkg_adm_cm_dealmemo.cursor_data,
      --Bioscope Changes Added new cursor by Anirudha on 13/03/2012
      o_media_ser_plat_dtl      OUT pkg_adm_cm_dealmemo.cursor_data,
      o_costed_prog_type        OUT pkg_adm_cm_dealmemo.cursor_data, --  o_qa_supplier         OUT  pkg_adm_cm_dealmemo.cursor_data
      o_media_service           OUT pkg_adm_cm_dealmemo.cursor_data
	  --Added By Pravin to get The Roles list for detail screen
	  ,o_Role_List				OUT pkg_adm_cm_dealmemo.cursor_data
	  )
   AS
      l_lic_hours                 NUMBER := -1;
      l_con_hours                 NUMBER := -1;
      l_mem_con_hours             NUMBER := -1;
      l_mem_con_cost_per_hour     NUMBER := -1;
      l_mem_type                  VARCHAR2 (4);
      l_contract_price            NUMBER;
      l_dm_status_change_golive   x_fin_configs.CONTENT%TYPE;
   BEGIN
      BEGIN
         SELECT mem_type
           INTO l_mem_type
           FROM sak_memo
          WHERE mem_id = i_mem_id;

         SELECT CONTENT
           INTO l_dm_status_change_golive
           FROM x_fin_configs
          WHERE KEY = 'DM_STATUS_CHNAGE_GOLIVE';

         IF (l_mem_type = 'CPD')
         THEN
            SELECT mem_con_price
              INTO l_contract_price
              FROM sak_memo
             WHERE mem_id = i_mem_id;
         ELSIF (l_mem_type = 'CHC')
         THEN
            l_contract_price := NULL;
         ELSE
            l_contract_price := NULL;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT SUM (lic_price)
           INTO l_lic_hours
           FROM fid_contract, fid_license
          WHERE con_number = lic_con_number AND lic_mem_number = i_mem_id;

         IF l_lic_hours <> -1 OR l_lic_hours IS NOT NULL
         THEN
            BEGIN
               SELECT mem_con_hours, mem_con_cost_per_hour
                 INTO l_con_hours, l_mem_con_cost_per_hour
                 FROM sak_memo
                WHERE mem_id = i_mem_id;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_con_hours := 0;
                  l_mem_con_cost_per_hour := 0;
            END;

            IF (l_con_hours IS NOT NULL AND l_mem_con_cost_per_hour <> 0)
            THEN
               l_lic_hours :=
                  l_con_hours - (l_lic_hours / l_mem_con_cost_per_hour);
            END IF;
         ELSE
            BEGIN
               SELECT con_hours
                 INTO l_con_hours
                 FROM fid_contract, sak_memo
                WHERE sak_memo.mem_con_number = fid_contract.con_number
                      AND mem_id = i_mem_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_con_hours := 0;
               WHEN TOO_MANY_ROWS
               THEN
                  l_con_hours := 0;
            END;

            l_lic_hours := l_con_hours;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_lic_hours := 0;
      END;

      -- Added as l_lic_hours is not used byb MNet
      IF (l_mem_type = 'FLF' OR l_mem_type = 'ROY')
      THEN
         l_lic_hours := 0;
      END IF;

      OPEN o_dealmemoresult FOR
         SELECT mem_id,
                con_short_name contract,
                mem_date,
                mem_currency currency,
                mem_type TYPE,
                mem_status status,
                f1.com_short_name licensor,
                f1.com_name licensorname,
                f2.com_short_name contractentity,
                f2.com_name contractentityname,
                lee_short_name main_licensee,
                lee_name main_licenseename,
                mem_amort_method method,
                NVL (mem_align_ind, 'N') AS mem_align_ind,
                NVL (mem_mplex_ind, 'N') AS mem_mplex_ind,
                ROUND (mem_con_price, 4) mem_con_price,
                -- SS
                ROUND (l_contract_price, 4) "CONTRACT_PRICE",
                ROUND (mem_con_cost_per_hour, 4) mem_con_cost_per_hour,
                ROUND (mem_con_hours_remaining, 4) mem_con_hours_remaining,
                ROUND (mem_con_hours, 4) mem_con_hours,
                ROUND (l_lic_hours, 4) "LIC_HOURS",
                NVL (mem_broader_rights, 'N') AS mem_broader_rights,
                NVL (mem_otime_allowed, 'N') AS mem_otime_allowed,
                mem_otime_exclusive,
                mem_otime_days,
                mem_paytv_days,
                mem_other_services,
                mem_protection_other,
                mem_protection_except,
                mem_deliv_matls_prior,
                mem_deliv_matls_by,
                mem_deliv_matls_other,
                mem_deliv_live_tech,
                mem_deliv_live_pub,
                NVL (mem_on_loan, 'N') AS mem_on_loan,
                mem_loan_info,
                mem_matls_return,
                mem_matls_return_other,
                mem_support_return,
                mem_deliv_mode,
                mem_deliv_mode_other,
                mem_deliv_cost,
                mem_return_cost,
                mem_deliv_cost_other,
                mem_deliv_notes,
                mem_notes,
                mem_contract_form,
                mem_contract_form_other,
                mem_comment,
                mem_buyer,
                mem_buyer_date,
                mem_status_date,
                mem_approver,
                mem_approval_date --Bioscope changes Added below field by Anirudha on 13/03/2012
                                 ,
                mem_time_shift_cha_flag /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
                                       ,
                mem_simulcast_cha_flag                  /* PB (CR 12) : END */
                                      ,
                NVL (mem_update_count, 0) mem_update_count,
                f1.com_qa_required,
                /* PB (CR 40) :Pranay Kusumwal 26/09/2012 :Calculating the qa approval date and operator from History table */
                (SELECT mhi_entry_oper
                   FROM sak_memo_history
                  WHERE     mhi_mem_id = i_mem_id
                        AND mhi_action = 'QAPASS'
                        AND mhi_to_stat = 'QAPASSED'
                        AND mem_status IN
                               ('PD RECOMMENDED', 'QAPASSED', 'EXECUTED')
                        AND mhi_entry_date =
                               (SELECT MAX (mhi_entry_date)
                                  FROM sak_memo_history
                                 WHERE     mhi_mem_id = i_mem_id
                                       AND mhi_action = 'QAPASS'
                                       AND mhi_to_stat = 'QAPASSED'))
                   mhi_entry_oper,
                (SELECT MAX (mhi_entry_date)
                   FROM sak_memo_history
                  WHERE     mhi_mem_id = i_mem_id
                        AND mhi_action = 'QAPASS'
                        AND mhi_to_stat = 'QAPASSED'
                        AND mem_status IN
                               ('PD RECOMMENDED', 'QAPASSED', 'EXECUTED'))
                   mhi_entry_date,
                mem_con_procurement_type procurementtype,
                mem_is_t_exec,
                NVL (
                   (SELECT 'N'
                      FROM SAK_MEMO_HISTORY
                     WHERE     mhi_action = 'EXECUTE'
                           AND MHI_ENTRY_DATE < l_dm_status_change_golive
                           AND MHI_FROM_STAT <> 'BUDGETED'
                           AND MHI_MEM_ID = mem_id
                           AND ROWNUM < 2),
                   'Y')
                   dm_status_change_aply,               /* PB (CR 40) : END */
                DECODE (NVL (mem_con_number, 0),
                        0, mem_is_mg_flag,
                        CON_IS_MG_FLAG)
                   mem_is_mg_flag --BR_15_144 : Finance Warner Paymnet : START [05-10-2015] by Sushma
           FROM sak_memo,
                fid_contract,
                fid_licensee,
                fid_company f1,
                fid_company f2
          WHERE     sak_memo.mem_con_number = fid_contract.con_number(+)
                AND sak_memo.mem_com_number = f1.com_number(+)
                AND sak_memo.mem_agy_com_number = f2.com_number(+)
                AND sak_memo.mem_lee_number = fid_licensee.lee_number(+)
                AND mem_id = i_mem_id;

      OPEN o_media_ser_plat_dtl FOR /* PB (CR) :Pranay Kusumwal 21/06/2012 : Commenting the below code for CR or mdeal service/platform */
                                   SELECT NULL FROM DUAL;

      /*select    mpsm_mapp_id
          ,mpsm_mapp_service_code
          ,mpsm_mapp_platform_code
          ,(select 'Y'
          from    sgy_pb_dm_med_plat_service
          where    dmps_mapp_id = mpsm_mapp_id
          and    dmps_mem_id = i_mem_id
          ) Check_flag
      from   sgy_pb_med_platm_service_map
      order by mpsm_mapp_service_code,mpsm_mapp_platform_code
      ; */
      OPEN o_costed_prog_type FOR
         SELECT cpt_gen_type FROM sgy_pb_costed_prog_type;

      OPEN o_media_service FOR
         SELECT MS_MEDIA_SERVICE_CODE
           FROM SGY_PB_MEDIA_SERVICE
          WHERE MS_MEDIA_SERVICE_CODE NOT IN ('TVOD', 'PAYTV');

		--Added by Pravin to get Role list
		OPEN o_Role_List
		FOR
			SELECT r.rolename
				  ,r.description
			FROM fwk_roletask rt,
			ora_aspnet_roles r
			where r.roleid = rt.roleid
			and taskid = 3011;
		--Pravin [END]

   /*
  OPEN o_qa_supplier FOR
  select com_number,com_name,com_short_name
  from   fid_company
  where  com_qa_required ='Y'
  and    com_type = 'S'
  ;
  */
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20350, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_viewdealmemodetails;

   ----------------------------------------------- ADD PROCEDURE FOR DEAL MEMO --------------------------------------
   PROCEDURE prc_adm_cm_adddealmemo (
      i_contract                   IN     fid_contract.con_short_name%TYPE,
      i_mem_date                   IN     sak_memo.mem_date%TYPE,
      i_mem_currency               IN     sak_memo.mem_currency%TYPE,
      i_mem_type                   IN     sak_memo.mem_type%TYPE,
      i_licensor                   IN     fid_company.com_short_name%TYPE,
      i_contractentity             IN     fid_company.com_short_name%TYPE,
      i_mainlicensee               IN     fid_licensee.lee_short_name%TYPE,
      i_mem_amort_method           IN     sak_memo.mem_amort_method%TYPE,
      i_mem_align_ind              IN     sak_memo.mem_align_ind%TYPE,
      i_mem_mplex_ind              IN     sak_memo.mem_mplex_ind%TYPE,
      i_mem_con_price              IN     sak_memo.mem_con_price%TYPE,
      -- rights
      i_mem_broader_rights         IN     sak_memo.mem_broader_rights%TYPE,
      i_mem_otime_allowed          IN     sak_memo.mem_otime_allowed%TYPE,
      i_mem_otime_exclusive        IN     sak_memo.mem_otime_exclusive%TYPE,
      i_mem_otime_days             IN     sak_memo.mem_otime_days%TYPE,
      i_mem_paytv_days             IN     sak_memo.mem_paytv_days%TYPE,
      i_mem_other_services         IN     sak_memo.mem_other_services%TYPE,
      --
      i_mem_on_loan                IN     sak_memo.mem_on_loan%TYPE,
      i_mem_matls_return           IN     sak_memo.mem_matls_return%TYPE,
      i_mem_deliv_mode             IN     sak_memo.mem_deliv_mode%TYPE,
      i_mem_deliv_cost             IN     sak_memo.mem_deliv_cost%TYPE,
      i_mem_contract_form          IN     sak_memo.mem_contract_form%TYPE,
      -- Bioscope Changes Added below Parameter by Anirudha on 13/03/2012
      i_mem_time_shift_cha_flag    IN     sak_memo.mem_time_shift_cha_flag%TYPE,
      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
      i_mem_simulcast_cha_flag     IN     sak_memo.mem_simulcast_cha_flag%TYPE,
      /* PB (CR 12) : END */
      i_mem_entry_oper             IN     sak_memo.mem_entry_oper%TYPE,
      ii_mem_con_cost_per_hour     IN     sak_memo.mem_con_cost_per_hour%TYPE,
      ii_mem_con_hours             IN     sak_memo.mem_con_hours%TYPE,
      ii_mem_con_hours_remaining   IN     sak_memo.mem_con_hours_remaining%TYPE,
      i_mem_con_procure_type       IN     sak_memo.mem_con_procurement_type%TYPE,
      --BR_15_144 : Finance Warner Paymnet : START [05-10-2015] by Sushma
      --Added to implement UAT cr
      i_mem_mg_flag                IN     sak_memo.mem_is_mg_flag%TYPE,
      --END
      o_mem_id                        OUT sak_memo.mem_id%TYPE,
      o_mem_status                    OUT sak_memo.mem_status%TYPE)
   AS
      n_mem_id                    NUMBER;
      i_mem_com_number            NUMBER;
      i_mem_agy_com_number        NUMBER;
      i_mem_lee_number            NUMBER;
      i_mem_con_number            NUMBER;
      l_flag                      NUMBER;
      i_mem_con_hours             NUMBER;
      i_mem_con_hours_remaining   NUMBER;
      i_mem_con_cost_per_hour     NUMBER;
      o_status                    VARCHAR2 (12);
      l_o_flag                    NUMBER;
      l_message                   VARCHAR2 (200);
      norights                    EXCEPTION;
   BEGIN
      /* pkg_adm_cm_dealmemo.prc_check_user_auth (i_mem_entry_oper,
                                                l_o_flag,
                                                l_message
                                               );

       IF (l_o_flag = 0)
       THEN
          RAISE norights;
       END IF;

       SELECT get_seq ('SEQ_MEM_ID')
         INTO o_mem_id
         FROM DUAL;*/
      /* changed by khilesh chauhan for Vanilla on 14 May 2015 max(mem_id) +1 with  nvl( MAX (mem_id),0) + 1 */
      SELECT NVL (MAX (mem_id), 300000) + 1 INTO o_mem_id FROM sak_memo; -- FOR MEDIA24 START WITH 300001

      SELECT com_number
        INTO i_mem_com_number
        FROM fid_company
       WHERE com_short_name = UPPER (i_licensor);

      SELECT com_number
        INTO i_mem_agy_com_number
        FROM fid_company
       WHERE com_short_name = UPPER (i_contractentity);

      SELECT lee_number
        INTO i_mem_lee_number
        FROM fid_licensee
       WHERE lee_short_name = UPPER (i_mainlicensee);

      IF (i_contract IS NOT NULL)
      THEN
         SELECT con_number
           INTO i_mem_con_number
           FROM fid_contract
          WHERE UPPER (con_short_name) = UPPER (i_contract);
      END IF;

      ------- Added for Super Sport
      IF (i_mem_type = 'CHC')
      THEN
         /*BEGIN
            SELECT con_hours, con_hours_remaining,
                   con_cost_per_hour
              INTO i_mem_con_hours, i_mem_con_hours_remaining,
                   i_mem_con_cost_per_hour
              FROM fid_contract
             WHERE con_short_name = UPPER (i_contract);
         EXCEPTION
            WHEN OTHERS
            THEN
               i_mem_con_hours := 0;
               i_mem_con_hours_remaining := 0;
               i_mem_con_cost_per_hour := 0;
         END;*/
         i_mem_con_hours := ii_mem_con_hours;
         i_mem_con_hours_remaining := ii_mem_con_hours_remaining;
         i_mem_con_cost_per_hour := ii_mem_con_cost_per_hour;
      ELSIF (i_mem_type = 'CPD')
      THEN
         i_mem_con_hours := 0;
         i_mem_con_hours_remaining := 0;
         i_mem_con_cost_per_hour := 0;
      ELSE             ----------------------------------------------added NRR
         --:mem.mem_con_price := :mei.con_total_non_con;
         i_mem_con_cost_per_hour := 0;
         i_mem_con_hours := 0;
         i_mem_con_hours_remaining := 0;
      END IF;

      -------
      pkg_adm_cm_dealmemo.prc_create_history ('NEW',
                                              o_mem_id,
                                              i_mem_type,
                                              i_mem_entry_oper,
                                              o_status);

      --  DBMS_OUTPUT.put_line (1);

      INSERT INTO sak_memo (mem_id,
                            mem_con_number,
                            mem_date,
                            mem_currency,
                            mem_type,
                            mem_status,
                            mem_com_number,
                            mem_agy_com_number,
                            mem_lee_number,
                            mem_amort_method,
                            mem_mplex_ind,
                            mem_align_ind,
                            mem_con_price,
                            -- RIGHTS
                            mem_broader_rights,
                            mem_otime_allowed,
                            mem_otime_exclusive,
                            mem_otime_days,
                            mem_paytv_days,
                            mem_other_services,
                            --
                            mem_on_loan,
                            mem_matls_return,
                            mem_deliv_mode,
                            mem_deliv_cost,
                            mem_contract_form,
                            mem_entry_oper,
                            mem_oper,
                            mem_entry_date,
                            mem_update_count,
                            -- Added for SS
                            mem_con_hours,
                            mem_con_hours_remaining,
                            mem_con_cost_per_hour,
                            mem_time_shift_cha_flag,
                            mem_simulcast_cha_flag,
                            mem_con_procurement_type,
                            mem_is_mg_flag --BR_15_144 : Finance Warner Paymnet : START [05-10-2015] by Sushma
                                          )
           VALUES (o_mem_id,
                   i_mem_con_number,
                   i_mem_date,
                   i_mem_currency,
                   i_mem_type,
                   o_status,                                   --'REGISTERED',
                   i_mem_com_number,
                   i_mem_agy_com_number,
                   i_mem_lee_number,
                   i_mem_amort_method,
                   i_mem_mplex_ind,
                   i_mem_align_ind,
                   i_mem_con_price,
                   --RIGHTS
                   NVL (i_mem_broader_rights, 'N'),
                   NVL (i_mem_otime_allowed, 'N'),
                   i_mem_otime_exclusive,
                   i_mem_otime_days,
                   i_mem_paytv_days,
                   i_mem_other_services,
                   --
                   NVL (i_mem_on_loan, 'Y'),
                   NVL (i_mem_matls_return, '-'),
                   NVL (i_mem_deliv_mode, 'A'),
                   NVL (i_mem_deliv_cost, '-'),
                   NVL (i_mem_contract_form, 'SA'),
                   i_mem_entry_oper,
                   i_mem_entry_oper,
                   SYSDATE,
                   0,
                   -- Added for SS
                   i_mem_con_hours,
                   i_mem_con_hours_remaining,
                   i_mem_con_cost_per_hour,
                   i_mem_time_shift_cha_flag,
                   i_mem_simulcast_cha_flag,
                   i_mem_con_procure_type,
                   NVL (i_mem_mg_flag, 'N') --BR_15_144 : Finance Warner Paymnet : START [05-10-2015] by Sushma
                                           );

      --  DBMS_OUTPUT.put_line (2);
      --o_status := 'REGISTERED';
      /*insert into sak_memo_history (MHI_MEM_ID,MHI_FROM_STAT,MHI_ACTION,MHI_TO_STAT,MHI_ENTRY_DATE,MHI_ENTRY_OPER,MHI_UPDATE_COUNT)
      values (o_mem_id);*/
      l_flag := SQL%ROWCOUNT;

      IF (l_flag > 0)
      THEN
         --COMMIT;

         --
         --  DBMS_OUTPUT.put_line (2);
         o_mem_status := o_status;
         COMMIT;
      ELSE
         o_mem_id := 0;
         ROLLBACK;
      END IF;
   EXCEPTION
      WHEN norights
      THEN
         raise_application_error (-20601, l_message);
      WHEN OTHERS
      THEN
         raise_application_error (-20351, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_adddealmemo;

   ----------------------------------------------- UPDATE PROCEDURE FOR DEAL MEMO -------------------------------------------------
   PROCEDURE prc_adm_cm_updatedealmemo (
      i_mem_id                     IN     sak_memo.mem_id%TYPE,
      --i_mem_date                  IN       sak_memo.mem_date%TYPE,
      i_licensor                   IN     fid_company.com_short_name%TYPE,
      i_contractentity             IN     fid_company.com_short_name%TYPE,
      i_mainlicensee               IN     fid_licensee.lee_short_name%TYPE,
      i_contract                   IN     fid_contract.con_short_name%TYPE,
      i_mem_broader_rights         IN     sak_memo.mem_broader_rights%TYPE,
      i_mem_otime_allowed          IN     sak_memo.mem_otime_allowed%TYPE,
      i_mem_on_loan                IN     sak_memo.mem_on_loan%TYPE,
      i_mem_matls_return           IN     sak_memo.mem_matls_return%TYPE,
      i_mem_deliv_mode             IN     sak_memo.mem_deliv_mode%TYPE,
      i_mem_deliv_cost             IN     sak_memo.mem_deliv_cost%TYPE,
      i_mem_contract_form          IN     sak_memo.mem_contract_form%TYPE,
      i_mem_currency               IN     sak_memo.mem_currency%TYPE,
      i_mem_type                   IN     sak_memo.mem_type%TYPE,
      i_mem_otime_exclusive        IN     sak_memo.mem_otime_exclusive%TYPE,
      i_mem_otime_days             IN     sak_memo.mem_otime_days%TYPE,
      i_mem_paytv_days             IN     sak_memo.mem_paytv_days%TYPE,
      i_mem_other_services         IN     sak_memo.mem_other_services%TYPE,
      i_mem_protection_other       IN     sak_memo.mem_protection_other%TYPE,
      i_mem_protection_except      IN     sak_memo.mem_protection_except%TYPE,
      --i_mem_payment_other         IN       sak_memo.mem_payment_other%TYPE,
      --i_mem_ban_number            IN       sak_memo.mem_ban_number%TYPE,
      i_mem_deliv_matls_prior      IN     sak_memo.mem_deliv_matls_prior%TYPE,
      i_mem_deliv_matls_by         IN     sak_memo.mem_deliv_matls_by%TYPE,
      i_mem_deliv_matls_other      IN     sak_memo.mem_deliv_matls_other%TYPE,
      i_mem_deliv_live_tech        IN     sak_memo.mem_deliv_live_tech%TYPE,
      i_mem_deliv_live_pub         IN     sak_memo.mem_deliv_live_pub%TYPE,
      i_mem_loan_info              IN     sak_memo.mem_loan_info%TYPE,
      i_mem_matls_return_other     IN     sak_memo.mem_matls_return_other%TYPE,
      i_mem_support_return         IN     sak_memo.mem_support_return%TYPE,
      i_mem_deliv_mode_other       IN     sak_memo.mem_deliv_mode_other%TYPE,
      i_mem_deliv_cost_other       IN     sak_memo.mem_deliv_cost_other%TYPE,
      i_mem_deliv_notes            IN     sak_memo.mem_deliv_notes%TYPE,
      i_mem_contract_form_other    IN     sak_memo.mem_contract_form_other%TYPE,
      i_mem_notes                  IN     sak_memo.mem_notes%TYPE,
      i_mem_comment                IN     sak_memo.mem_comment%TYPE,
      i_mem_approver               IN     sak_memo.mem_approver%TYPE,
      i_mem_approval_date          IN     sak_memo.mem_approval_date%TYPE,
      i_mem_buyer                  IN     sak_memo.mem_buyer%TYPE,
      i_mem_buyer_date             IN     sak_memo.mem_buyer_date%TYPE,
      i_mem_change_oper            IN     sak_memo.mem_change_oper%TYPE,
      i_mem_return_cost            IN     sak_memo.mem_return_cost%TYPE,
      i_mem_mplex_ind              IN     sak_memo.mem_mplex_ind%TYPE,
      i_mem_align_ind              IN     sak_memo.mem_align_ind%TYPE,
      i_mem_con_price              IN     sak_memo.mem_con_price%TYPE,
      /*
          i_mem_status                IN       sak_memo.mem_status%TYPE,
          i_mem_status_date           IN       sak_memo.mem_status_date%TYPE,
          i_mem_prime_time_start      IN       sak_memo.mem_prime_time_start%TYPE,
          i_mem_prime_time_end        IN       sak_memo.mem_prime_time_end%TYPE,
          i_mem_prime_max_runs        IN       sak_memo.mem_prime_max_runs%TYPE,
          i_mem_con_hours             IN       sak_memo.mem_con_hours%TYPE,
          i_mem_con_cost_per_hour     IN       sak_memo.mem_con_cost_per_hour%TYPE,
          i_mem_con_hours_remaining   IN       sak_memo.mem_con_hours_remaining%TYPE,
         i_mem_total_duration        IN       sak_memo.mem_total_duration%TYPE,
     */
      i_mem_amort_method           IN     sak_memo.mem_amort_method%TYPE,
      -- Bioscope Changes by Anirudha on 13/03/2012
      i_mem_time_shift_cha_flag    IN     sak_memo.mem_time_shift_cha_flag%TYPE,
      -- Bioscope Changes end
      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
      i_mem_simulcast_cha_flag     IN     sak_memo.mem_simulcast_cha_flag%TYPE,
      /* PB (CR 12) : END */
      i_mem_update_count           IN     sak_memo.mem_update_count%TYPE,
      ii_mem_con_cost_per_hour     IN     sak_memo.mem_con_cost_per_hour%TYPE,
      ii_mem_con_hours             IN     sak_memo.mem_con_hours%TYPE,
      ii_mem_con_hours_remaining   IN     sak_memo.mem_con_hours_remaining%TYPE,
      i_mem_con_procure_type       IN     sak_memo.mem_con_procurement_type%TYPE,
      --BR_15_144 : Finance Warner Paymnet : START [05-10-2015] by Sushma
      --Added to implement UAT cr
      i_mem_mg_flag                IN     sak_memo.mem_is_mg_flag%TYPE,
      --END
      o_mem_update_count              OUT sak_memo.mem_update_count%TYPE)
   AS
      i_mem_com_number            NUMBER;
      i_mem_agy_com_number        NUMBER;
      i_mem_lee_number            NUMBER;
      i_mem_con_number            NUMBER;
      updatfailed                 EXCEPTION;
      l_flag                      NUMBER;
      l_o_flag                    NUMBER;
      l_message                   VARCHAR2 (200);
      norights                    EXCEPTION;
      l_paycount                  NUMBER := 0;
      ------Changes done for gen_refno------------------
      l_old_com_number            NUMBER;
      l_new_com_number            NUMBER;
      l_prg_exist                 NUMBER;
      l_gen_refno                 NUMBER;
      l_gen_title                 VARCHAR2 (120);
      l_gen_type                  VARCHAR2 (4);
      l_gen_duration              NUMBER;
      l_gen_duration_c            VARCHAR2 (11);
      l_gen_duration_s            VARCHAR2 (1);
      l_gen_supplier_com_number   NUMBER;
      l_gen_stu_code              VARCHAR2 (8);
      l_gen_category              VARCHAR2 (8);
      l_gen_entry_oper            VARCHAR2 (50);
      l_gen_title_working         VARCHAR2 (120);
      l_gen_event                 VARCHAR2 (10);
      l_gen_subgenre              VARCHAR2 (8);
      l_gen_update_count          NUMBER;
      l_gen_tertiary_genre        VARCHAR2 (8);
      l_gen_bo_category_code      VARCHAR2 (20);
      l_gen_bo_revenue_usd        NUMBER;
      l_gen_bo_revenue_zar        NUMBER;
      l_gen_release_year          NUMBER;
      l_gen_prog_category_code    VARCHAR2 (20);
      l_ser_number                NUMBER;
      l_series_yorn               NUMBER;
      l_ser_parent_number         NUMBER;
      l_ser_parent_no             NUMBER;
      l_ss_flag                      number := 0;
      l_mem_con_number            number ;
      -------End---------------------------------------
      -- Synergy Vanilla:Start [Nasreen Mulla]
      L_CONTENT                   X_FIN_CONFIGS.CONTENT%TYPE;
   -- Synergy Vanilla:end
   BEGIN
      --Code added to check if user has updated the Currency
      -- Start
      BEGIN
         SELECT COUNT (*)
           INTO l_paycount
           FROM sak_memo_payment
          WHERE mpy_mem_id = i_mem_id AND mpy_cur_code <> i_mem_currency;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_paycount := 0;
      END;

      IF l_paycount <> 0
      THEN
         UPDATE sak_memo_payment
            SET mpy_cur_code = i_mem_currency
          WHERE mpy_mem_id = i_mem_id AND mpy_cur_code <> i_mem_currency;
      END IF;


      SELECT com_number
        INTO i_mem_com_number
        FROM fid_company
       WHERE com_short_name = UPPER (i_licensor);

      ------Changes done for gen_refno------------------
      SELECT mem_com_number
        INTO l_old_com_number
        FROM sak_memo
       WHERE mem_id = i_mem_id;

      l_new_com_number := i_mem_com_number;

      ------End-----------------------
      SELECT com_number
        INTO i_mem_agy_com_number
        FROM fid_company
       WHERE com_short_name = UPPER (i_contractentity);

      SELECT lee_number
        INTO i_mem_lee_number
        FROM fid_licensee
       WHERE lee_short_name = UPPER (i_mainlicensee);

      IF (i_contract IS NOT NULL)
      THEN
         SELECT con_number
           INTO i_mem_con_number
           FROM fid_contract
          WHERE con_short_name = UPPER (i_contract);


          --Added by Milan Shah for CU4ALL
            SELECT nvl(mem_con_number,0) into l_mem_con_number FROM sak_memo where mem_id = i_mem_id;
            IF l_mem_con_number <> i_mem_con_number
            THEN
                l_ss_flag := 1;
            ELSE
                l_ss_flag :=0;
            END IF;
      --Ended By Milan Shah for CU4ALL
      END IF;

      UPDATE sak_memo
         SET mem_com_number = i_mem_com_number,
             mem_agy_com_number = i_mem_agy_com_number,
             mem_lee_number = i_mem_lee_number,
             mem_broader_rights = NVL (i_mem_broader_rights, 'N'),
             mem_otime_allowed = NVL (i_mem_otime_allowed, 'N'),
             mem_on_loan = NVL (i_mem_on_loan, 'Y'),
             mem_matls_return = NVL (i_mem_matls_return, '-'),
             mem_deliv_mode = NVL (i_mem_deliv_mode, 'A'),
             mem_deliv_cost = NVL (i_mem_deliv_cost, '-'),
             mem_contract_form = NVL (i_mem_contract_form, 'SA'),
             mem_currency = i_mem_currency,
             mem_type = i_mem_type,
             mem_otime_exclusive = i_mem_otime_exclusive,
             mem_otime_days = i_mem_otime_days,
             mem_paytv_days = i_mem_paytv_days,
             mem_other_services = i_mem_other_services,
             mem_protection_other = i_mem_protection_other,
             mem_protection_except = i_mem_protection_except,
             mem_deliv_matls_prior = i_mem_deliv_matls_prior,
             mem_deliv_matls_by = i_mem_deliv_matls_by,
             mem_deliv_matls_other = i_mem_deliv_matls_other,
             mem_deliv_live_tech = i_mem_deliv_live_tech,
             mem_deliv_live_pub = i_mem_deliv_live_pub,
             mem_loan_info = i_mem_loan_info,
             mem_matls_return_other = i_mem_matls_return_other,
             mem_support_return = i_mem_support_return,
             mem_deliv_mode_other = i_mem_deliv_mode_other,
             mem_deliv_cost_other = i_mem_deliv_cost_other,
             mem_deliv_notes = i_mem_deliv_notes,
             mem_contract_form_other = i_mem_contract_form_other,
             mem_notes = i_mem_notes,
             mem_comment = i_mem_comment,
             mem_approver = i_mem_approver,
             mem_approval_date = i_mem_approval_date,
             mem_buyer = i_mem_buyer,
             mem_buyer_date = i_mem_buyer_date,
             mem_con_number = i_mem_con_number,
             mem_change_oper = i_mem_change_oper,
             mem_change_date = SYSDATE,
             mem_return_cost = i_mem_return_cost,
             mem_mplex_ind = i_mem_mplex_ind,
             mem_align_ind = i_mem_align_ind,
             mem_con_price = i_mem_con_price,
             mem_amort_method = i_mem_amort_method,
             mem_con_cost_per_hour = ii_mem_con_cost_per_hour,
             mem_con_hours = ii_mem_con_hours,
             mem_con_hours_remaining = ii_mem_con_hours_remaining,
             -- Bioscope Changes by Anirudha on 13/03/2012
             mem_time_shift_cha_flag = i_mem_time_shift_cha_flag,
             -- Bioscope Changes end
             /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
             mem_simulcast_cha_flag = i_mem_simulcast_cha_flag,
             /* PB (CR 12) : END */
             /*********************************
                AUTHOR : Devashish/Shantanu
                DATE : 30/jan/2014
                Description : Modified Update Count Functionality

             **********************************/
             --mem_update_count = mem_update_count + 1,
             mem_con_procurement_type = i_mem_con_procure_type,
             mem_is_mg_flag = NVL (i_mem_mg_flag, 'N') --  --BR_15_144 : Finance Warner Paymnet : START [05-10-2015] by Sushma
       WHERE mem_id = i_mem_id;

      --AND mem_update_count = i_mem_update_count
      --RETURNING mem_update_count
      --     INTO l_flag;
      SELECT mem_update_count
        INTO l_flag
        FROM sak_memo
       WHERE mem_id = i_mem_id;

      IF (NVL (l_flag, 0) = NVL (i_mem_update_count, 0))
      THEN
         UPDATE sak_memo
            SET mem_update_count = NVL (mem_update_count, 0) + 1
          WHERE mem_id = i_mem_id;

         COMMIT;

         SELECT mem_update_count
           INTO l_flag
           FROM sak_memo
          WHERE mem_id = i_mem_id;

         o_mem_update_count := NVL (l_flag, 0);
      ELSE
         ROLLBACK;
         raise_application_error (
            -20417,
            'The deal details ' || 'are already modified by another user');
      END IF;

      /*****************End Update Count Functionality*************/
      --------------Changes done for new gen refno----------------------------
      BEGIN
         IF l_old_com_number <> l_new_com_number
         THEN
            FOR i IN (SELECT *
                        FROM sak_memo_item
                       WHERE mei_mem_id = i_mem_id)
            LOOP
               IF x_fnc_get_prog_type (i.mei_type_show) = 'Y'
               THEN
                  SELECT COUNT (*)
                    INTO l_series_yorn
                    FROM fid_series
                   WHERE     UPPER (ser_title) = UPPER (i.mei_title)
                         AND ser_number = i.mei_gen_refno
                         AND ser_parent_number = 0;

                  IF l_series_yorn > 0
                  THEN
                     SELECT COUNT (1)
                       INTO l_prg_exist
                       FROM fid_series
                      WHERE     UPPER (ser_title) = UPPER (i.mei_title)
                            AND UPPER (ser_type) = UPPER (i.mei_type_show)
                            AND ser_com_number = l_new_com_number
                            AND ser_parent_number = 0;

                     IF l_prg_exist > 0
                     THEN
                        SELECT ser_number
                          INTO l_ser_number
                          FROM fid_series
                         WHERE     UPPER (ser_title) = UPPER (i.mei_title)
                               AND UPPER (ser_type) = UPPER (i.mei_type_show)
                               AND ser_com_number = l_new_com_number
                               AND ser_parent_number = 0;

                        UPDATE sak_memo_item
                           SET mei_gen_refno = l_ser_number
                         WHERE mei_id = i.mei_id;
                     ELSE
                        l_ser_number := seq_ser_number.NEXTVAL;

                        INSERT INTO fid_series (Ser_Number,
                                                Ser_Title,
                                                Ser_Entry_Date,
                                                Ser_Entry_Oper,
                                                Ser_Parent_Number,
                                                Order_Title,
                                                Order_Number,
                                                Order_Season,
                                                Ser_Duration,
                                                Ser_Is_Deleted,
                                                SER_UPDATE_COUNT,
                                                Ser_Sea_Number,
                                                SER_US_PREMIER_DATE,
                                                Ser_Com_Number,
                                                Ser_Release_Year,
                                                SER_TYPE,
                                                Ser_Web_Title,
                                                Ser_Synopsis)
                           SELECT l_ser_number,
                                  ser_title,
                                  TRUNC (SYSDATE),
                                  ser_entry_oper,
                                  ser_parent_number,
                                  order_title,
                                  order_number,
                                  order_season,
                                  ser_duration,
                                  ser_is_deleted,
                                  ser_update_count,
                                  ser_sea_number,
                                  ser_us_premier_date,
                                  ser_release_year,
                                  ser_com_number,
                                  ser_type,
                                  SER_WEB_TITLE,
                                  SER_SYNOPSIS
                             FROM fid_series
                            WHERE ser_number = i.mei_gen_refno;

                        UPDATE sak_memo_item
                           SET mei_gen_refno = l_ser_number
                         WHERE mei_id = i.mei_id;
                     END IF;
                  ELSE
                     SELECT COUNT (1)
                       INTO l_prg_exist
                       FROM fid_series
                      WHERE     UPPER (ser_title) = UPPER (i.mei_title)
                            AND ser_type = i.mei_type_show
                            AND ser_com_number = l_new_com_number;

                     IF l_prg_exist > 0
                     THEN
                        SELECT ser_number
                          INTO l_ser_number
                          FROM fid_series
                         WHERE     UPPER (ser_title) = UPPER (i.mei_title)
                               AND ser_type = i.mei_type_show
                               AND ser_com_number = l_new_com_number;

                        ---Season number for the existing title in fid_series.
                        SELECT ser_parent_number
                          INTO l_ser_parent_number
                          FROM fid_series
                         WHERE ser_number = l_ser_number;

                        ---Series number for the existing title in fid_series.
                        SELECT ser_parent_number
                          INTO l_ser_parent_no
                          FROM fid_series
                         WHERE ser_number = i.mei_gen_refno;

                        ---Series number for the deal memo title.
                        UPDATE fid_series
                           SET ser_parent_number = l_ser_parent_number,
                               SER_ENTRY_DATE = SYSDATE -- changes by Rashmi_Tijare_20140804 for Phoenix
                         WHERE ser_parent_number = l_ser_parent_no;

                        ---Updating Series number for the deal memo title to Series number for the existing title in fid_series
                        ---for all seasons
                        UPDATE fid_series
                           SET ser_number = l_ser_parent_number,
                               SER_ENTRY_DATE = SYSDATE -- changes by Rashmi_Tijare_20140804 for Phoenix
                         WHERE ser_number = l_ser_parent_no;
                     ----Updating series number
                     ELSE
                        NULL;
                     END IF;
                  END IF;
               ELSE
                  SELECT COUNT (1)
                    INTO l_prg_exist
                    FROM fid_general
                   WHERE     UPPER (gen_title) = UPPER (i.mei_title)
                         AND gen_release_year = i.mei_release_year
                         AND gen_type = i.mei_type_show
                         AND gen_supplier_com_number = l_new_com_number;

                  IF l_prg_exist > 0
                  THEN
                     SELECT gen_refno
                       INTO l_gen_refno
                       FROM fid_general
                      --WHERE UPPER (gen_refno) = UPPER (i.mei_title)
                      WHERE     UPPER (gen_title) = UPPER (i.mei_title)
                            AND gen_release_year = i.mei_release_year
                            AND UPPER (gen_type) = UPPER (i.mei_type_show)
                            AND gen_supplier_com_number = l_new_com_number;

                     UPDATE sak_memo_item
                        SET mei_gen_refno = l_gen_refno
                      WHERE mei_id = i.mei_id;
                  ELSE
                     SELECT gen_title,
                            gen_type,
                            gen_duration,
                            gen_duration_c,
                            gen_duration_s,
                            gen_supplier_com_number,
                            gen_stu_code,
                            gen_category,
                            --  gen_entry_oper,
                            gen_title_working,
                            gen_event,
                            gen_subgenre,
                            gen_update_count,
                            gen_tertiary_genre,
                            gen_bo_category_code,
                            gen_bo_revenue_usd,
                            gen_bo_revenue_zar,
                            gen_release_year,
                            gen_prog_category_code
                       INTO l_gen_title,
                            l_gen_type,
                            l_gen_duration,
                            l_gen_duration_c,
                            l_gen_duration_s,
                            l_gen_supplier_com_number,
                            l_gen_stu_code,
                            l_gen_category,
                            --  l_gen_entry_oper,
                            l_gen_title_working,
                            l_gen_event,
                            l_gen_subgenre,
                            l_gen_update_count,
                            l_gen_tertiary_genre,
                            l_gen_bo_category_code,
                            l_gen_bo_revenue_usd,
                            l_gen_bo_revenue_zar,
                            l_gen_release_year,
                            l_gen_prog_category_code
                       FROM fid_general
                      WHERE gen_refno = i.mei_gen_refno;

                     -- Synergy Vanilla:Start [Nasreen Mulla]
                     SELECT CONTENT
                       INTO L_CONTENT
                       FROM X_FIN_CONFIGS
                      WHERE KEY = 'COMPANY_ID';

                     IF L_CONTENT = 1
                     THEN
                        l_gen_refno := get_seq ('SEQ_GEN_REFNO');
                     ELSE
                        l_gen_refno := get_seq ('SEQ_GEN_REFNO_M24');
                     END IF;

                     -- Synergy Vanilla:end

                     INSERT INTO fid_general (gen_refno,
                                              gen_title,
                                              gen_type,
                                              gen_duration,
                                              gen_duration_c,
                                              gen_duration_s,
                                              --gen_supplier_com_number,
                                              gen_stu_code,
                                              gen_category,
                                              gen_entry_date,
                                              gen_entry_oper,
                                              gen_title_working,
                                              gen_event,
                                              gen_subgenre,
                                              gen_update_count,
                                              gen_tertiary_genre,
                                              gen_bo_category_code,
                                              gen_bo_revenue_usd,
                                              gen_bo_revenue_zar,
                                              gen_release_year,
                                              gen_prog_category_code)
                          VALUES (l_gen_refno,
                                  l_gen_title,
                                  l_gen_type,
                                  l_gen_duration,
                                  l_gen_duration_c,
                                  l_gen_duration_s,
                                  --l_gen_supplier_com_number,
                                  --i_mem_com_number,
                                  l_gen_stu_code,
                                  l_gen_category,
                                  TRUNC (SYSDATE),
                                  --l_gen_entry_oper,
                                  i_mem_change_oper,
                                  l_gen_title_working,
                                  l_gen_event,
                                  l_gen_subgenre,
                                  l_gen_update_count,
                                  l_gen_tertiary_genre,
                                  l_gen_bo_category_code,
                                  l_gen_bo_revenue_usd,
                                  l_gen_bo_revenue_zar,
                                  l_gen_release_year,
                                  l_gen_prog_category_code);

                     UPDATE sak_memo_item
                        SET mei_gen_refno = l_gen_refno
                      WHERE mei_id = i.mei_id;
                  END IF;
               END IF;
            END LOOP;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            ROLLBACK;
            raise_application_error (-20555,
                                     'Error:' || SUBSTR (SQLERRM, 1, 200));
      END;

           --Added by Milan Shah for CU4ALL
        If l_ss_flag = 1
        THEN
           UPDATE x_cp_memo_superstack_rights SET MSR_SUPERSTACK_FLAG = 'N'
                  WHERE NOT EXISTS(
                                   SELECT CBR_BOUQUET_ID
                                   FROM X_CP_CON_BOUQ_SSTACK_RIGHTS
                                   WHERE CBR_BOUQUET_ID  = msr_bouquet_id
                                         AND CBR_SUPERSTACKRIGHTS = 'Y'
                                         AND cbr_con_number = i_mem_con_number
                                   )
                        AND MSR_SUPERSTACK_FLAG = 'Y'
                        AND MSR_ALD_NUMBER IN (select ald_ID
                                  from sak_memo_item
                                       ,sak_allocation_detail
                                  where mei_mem_id = i_mem_id
                                        and mei_id = ald_mei_id);
        END IF;
      --Ended by Milan Shah For CU4ALL

   --------------------------------End-------------------------
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20352, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20353, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_updatedealmemo;

   ---Added by Nishant ---------------------
   PROCEDURE prc_add_dm_updt_ref_prog (
      i_mei_id                   IN     sak_memo_item.mei_id%TYPE,
      i_mei_mem_id               IN     sak_memo_item.mei_mem_id%TYPE,
      i_mem_type                 IN     sak_memo.mem_type%TYPE,
      i_title_show               IN     fid_general.gen_title%TYPE,
      i_genre                    IN     fid_general.gen_category%TYPE,
      i_sub_genre                IN     fid_general.gen_subgenre%TYPE,
      i_event                    IN     fid_general.gen_event%TYPE,
      i_gen_type                 IN     fid_general.gen_type%TYPE,
      i_mei_total_price          IN     sak_memo_item.mei_total_price%TYPE,
      i_licensor                 IN     fid_company.com_short_name%TYPE,
      i_user_id                  IN     fid_general.gen_entry_oper%TYPE,
      i_gen_duration_c           IN     fid_general.gen_duration_c%TYPE,
      i_mei_gen_refno            IN     sak_memo_item.mei_gen_refno%TYPE,
      i_gen_tertiary_genre       IN     fid_general.gen_tertiary_genre%TYPE,
      i_gen_bo_category_code     IN     fid_general.gen_bo_category_code%TYPE,
      i_gen_bo_revenue_usd       IN     fid_general.gen_bo_revenue_usd%TYPE,
      i_gen_bo_revenue_zar       IN     fid_general.gen_bo_revenue_zar%TYPE,
      i_gen_release_year         IN     fid_general.gen_release_year%TYPE,
      i_gen_prog_category_code   IN     fid_general.gen_prog_category_code%TYPE,
      i_premium_flag             IN     sak_memo_item.mei_premium_flag%TYPE,
      o_mei_gen_refno               OUT sak_memo_item.mei_gen_refno%TYPE,
      o_mem_con_price               OUT sak_memo.mem_con_price%TYPE --o_mem_update_count            OUT sak_memo.mem_update_count%TYPE
                                                                   )
   AS
      l_seryorn           VARCHAR2 (1);
      l_liveyorn          VARCHAR2 (1);
      l_gen_refno         NUMBER;
      l_dur_number        NUMBER;
      l_dur_char          VARCHAR2 (15);
      l_dur_s             VARCHAR2 (1);
      l_hours             VARCHAR2 (10);
      l_minutes           VARCHAR2 (10);
      l_seconds           VARCHAR2 (10);
      l_gen_duration_c    VARCHAR2 (15);
      l_gen_duration      NUMBER;
      l_mei_total_price   NUMBER;
      countseries         NUMBER;
      l_com_number        NUMBER;
      l_o_flag            NUMBER;
      l_message           VARCHAR2 (200);
      norights            EXCEPTION;
      -- Synergy Vanilla:Start [Nasreen Mulla]
      L_CONTENT           X_FIN_CONFIGS.CONTENT%TYPE;
   -- Synergy Vanilla:End
   BEGIN
      BEGIN
         SELECT NVL (cod_attr1, 'N') cod_attr1,
                NVL (cod_attr2, 'N') cod_attr2
           INTO l_seryorn, l_liveyorn
           FROM fid_code
          WHERE cod_type = 'GEN_TYPE' AND cod_value = i_gen_type;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_seryorn := 'N';
            l_liveyorn := 'N';
      END;

      BEGIN
         SELECT fn_convert_duration_c_n (i_gen_duration_c)
           INTO l_gen_duration
           FROM DUAL;

         IF l_seryorn = 'Y'
         THEN
            SELECT COUNT (*)
              INTO countseries
              FROM fid_series
             WHERE ser_number = i_mei_gen_refno;

            IF (countseries > 0)
            THEN
               IF (i_mei_gen_refno <> 0)
               THEN
                  o_mei_gen_refno := i_mei_gen_refno;
               ELSE
                  o_mei_gen_refno := 0;
               END IF;
            --   DBMS_OUTPUT.put_line (' o_mei_gen_refno ' || o_mei_gen_refno);
            ELSE
               o_mei_gen_refno := 0;
            END IF;

            --Added by Nishant
            SELECT com_number
              INTO l_com_number
              FROM fid_company
             WHERE UPPER (com_short_name) LIKE UPPER (i_licensor);

            IF NVL (o_mei_gen_refno, 0) = 0
            THEN
               IF i_gen_type IS NOT NULL
               THEN
                  l_gen_refno := get_seq ('SEQ_SER_NUMBER');

                  --  DBMS_OUTPUT.put_line (' l_gen_refno ' || l_gen_refno);

                  INSERT INTO fid_series (ser_number,
                                          ser_title,
                                          ser_entry_date,
                                          ser_entry_oper,
                                          ser_parent_number,
                                          order_title,
                                          order_number,
                                          order_season,
                                          ser_duration,      --ser_is_deleted,
                                          ser_update_count  --Added by Nishant
                                                          -- Release Year, Com Number will not be entered in database from here
                                          )
                       VALUES (l_gen_refno,
                               UPPER (i_title_show),
                               SYSDATE,
                               i_user_id,
                               0,
                               UPPER (i_title_show),
                               -1,
                               '1',
                               l_gen_duration,                          --'N',
                               0                            --Added by Nishant
                                );
               END IF;

               o_mei_gen_refno := l_gen_refno;
            END IF;
         ELSE
            SELECT COUNT (*)
              INTO countseries
              FROM fid_general
             WHERE UPPER (gen_title) LIKE UPPER (i_title_show);

            IF (countseries > 0)
            THEN
               IF (i_mei_gen_refno <> 0)
               THEN
                  o_mei_gen_refno := i_mei_gen_refno;
               ELSE
                  o_mei_gen_refno := 0;
               END IF;
            ELSE
               o_mei_gen_refno := 0;
            END IF;

            ---------
            IF NVL (o_mei_gen_refno, 0) = 0
            THEN
               IF i_gen_type IS NOT NULL
               THEN
                  -- Synergy Vanilla:Start [Nasreen Mulla]
                  SELECT CONTENT
                    INTO L_CONTENT
                    FROM X_FIN_CONFIGS
                   WHERE KEY = 'COMPANY_ID';

                  IF L_CONTENT = 1
                  THEN
                     l_gen_refno := get_seq ('SEQ_GEN_REFNO');
                  ELSE
                     l_gen_refno := get_seq ('SEQ_GEN_REFNO_M24');
                  END IF;

                  -- Synergy Vanilla:End

                  IF l_gen_duration > 0
                  THEN
                     l_dur_s := 'A';
                  END IF;

                  SELECT com_number
                    INTO l_com_number
                    FROM fid_company
                   WHERE UPPER (com_short_name) LIKE UPPER (i_licensor);

                  INSERT INTO fid_general (gen_refno,
                                           gen_title,
                                           gen_type,
                                           gen_duration,
                                           gen_duration_c,
                                           gen_duration_s,
                                           --gen_supplier_com_number,
                                           gen_stu_code,
                                           gen_category,
                                           gen_entry_date,
                                           gen_entry_oper,
                                           gen_title_working,
                                           gen_event,
                                           gen_subgenre,
                                           gen_update_count,
                                           gen_tertiary_genre,
                                           gen_bo_category_code,
                                           gen_bo_revenue_usd,
                                           gen_bo_revenue_zar,
                                           gen_release_year,
                                           gen_prog_category_code)
                       VALUES (l_gen_refno,
                               UPPER (i_title_show),
                               i_gen_type,
                               l_gen_duration,
                               i_gen_duration_c,
                               l_dur_s,
                               --l_com_number,
                               '-',
                               NVL (i_genre, '-'),
                               SYSDATE,
                               i_user_id,
                               SUBSTR (UPPER (i_title_show), 1, 120),
                               NVL (i_event, '-'),
                               NVL (i_sub_genre, '-'),
                               0,
                               NVL (i_gen_tertiary_genre, '-'),
                               i_gen_bo_category_code,
                               i_gen_bo_revenue_usd,
                               i_gen_bo_revenue_zar,
                               i_gen_release_year,
                               i_gen_prog_category_code);
               END IF;

               o_mei_gen_refno := l_gen_refno;
            ELSE
               UPDATE fid_general
                  SET gen_bo_category_code = i_gen_bo_category_code,
                      gen_bo_revenue_usd = i_gen_bo_revenue_usd,
                      gen_bo_revenue_zar = i_gen_bo_revenue_zar,
                      gen_release_year = i_gen_release_year,
                      gen_prog_category_code = i_gen_prog_category_code
                WHERE gen_refno = o_mei_gen_refno;
            END IF;
         END IF;

         ---- update with new refno
         UPDATE sak_memo_item
            SET mei_gen_refno = l_gen_refno,
                mei_total_price = i_mei_total_price
          WHERE mei_mem_id = i_mei_mem_id AND mei_id = i_mei_id;

         COMMIT;

         IF (i_mem_type != 'CPD')
         THEN
            SELECT NVL (SUM (NVL (mei_total_price, 0)), 0)
              INTO l_mei_total_price
              FROM sak_memo_item
             WHERE mei_mem_id = i_mei_mem_id;

            -- DBMS_OUTPUT.put_line ('l_mei_total_price:  ' || l_mei_total_price);
            UPDATE sak_memo
               SET mem_con_price = l_mei_total_price
             --,mem_update_count = NVL (mem_update_count, 0) + 1
             WHERE mem_id = i_mei_mem_id;
         END IF;

         COMMIT;

         --DBMS_OUTPUT.put_line ('update');
         SELECT mem_con_price
           --, mem_update_count
           INTO o_mem_con_price
           --, o_mem_update_count
           FROM sak_memo
          WHERE mem_id = i_mei_mem_id;
      -- DBMS_OUTPUT.put_line (o_mem_con_price || ', ' || o_mem_update_count);
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
      END;
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_add_dm_updt_ref_prog;

   ----------End---------------------------------------------

   ----------------------------------------------- DELETE PROCEDURE FOR DEAL MEMO -------------------------------------------------
   PROCEDURE prc_adm_cm_deletedealmemo (
      i_mem_id             IN     sak_memo.mem_id%TYPE,
      i_mem_update_count   IN     sak_memo.mem_update_count%TYPE,
      o_dealmemodeleted       OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
   BEGIN
      --RETURNING ent_update_count
      --INTO l_flag;
      l_flag := 0;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_dealmemodeleted := 1;
      ELSE
         RAISE deldatfailed;
      END IF;
   EXCEPTION
      WHEN deldatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20354, 'Data Not Deleted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20355, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_deletedealmemo;

   ------------------------------------- SEARCH PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_viewlanguage (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_dealmemoresult FOR
           SELECT mem_id,
                  mla_lan_id,
                  NVL (mla_original, 'N') AS mla_original,
                  NVL (mla_dubbed, 'N') AS mla_dubbed,
                  NVL (mla_subtitled, 'N') AS mla_subtitled,
                  NVL (mla_voice_over, 'N') AS mla_voice_over,
                  mla_supply,
                  mla_cost,
                  mla_notes,
                  NVL (mla_update_count, 0) AS mla_update_count,
                  mla_number
             FROM sak_memo, sak_memo_lang_rights
            WHERE mem_id = mla_mem_id AND mem_id = i_mem_id
         ORDER BY mem_id, mla_lan_id;
   --AND NVL (mla_is_deleted, 'N') = 'N';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20356, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_viewlanguage;

   ------------------------------------- ADD PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_addlanguage (
      i_mla_mem_id       IN     sak_memo_lang_rights.mla_mem_id%TYPE,
      i_mla_lan_id       IN     sak_memo_lang_rights.mla_lan_id%TYPE,
      i_mla_original     IN     sak_memo_lang_rights.mla_original%TYPE,
      i_mla_dubbed       IN     sak_memo_lang_rights.mla_dubbed%TYPE,
      i_mla_subtitled    IN     sak_memo_lang_rights.mla_subtitled%TYPE,
      i_mla_voice_over   IN     sak_memo_lang_rights.mla_voice_over%TYPE,
      i_mla_supply       IN     sak_memo_lang_rights.mla_supply%TYPE,
      i_mla_cost         IN     sak_memo_lang_rights.mla_cost%TYPE,
      i_mla_notes        IN     sak_memo_lang_rights.mla_notes%TYPE,
      i_mla_entry_oper   IN     sak_memo_lang_rights.mla_entry_oper%TYPE,
      o_languageadded       OUT NUMBER)
   AS
      l_flag                 NUMBER;
      fieldsalreadypresent   EXCEPTION;
      l_o_flag               NUMBER;
      l_message              VARCHAR2 (200);
      norights               EXCEPTION;
   BEGIN
      /*pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_mla_mem_id,
                                                          i_mla_entry_oper,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF;*/
      IF (fnc_adm_languageexists (i_mla_mem_id, i_mla_lan_id) = 0)
      THEN
         o_languageadded := get_seq ('SEQ_MLA_NUMBER');

         INSERT INTO sak_memo_lang_rights (mla_number,
                                           mla_mem_id,
                                           mla_lan_id,
                                           mla_original,
                                           mla_dubbed,
                                           mla_subtitled,
                                           mla_voice_over,
                                           mla_supply,
                                           mla_cost,
                                           mla_notes,
                                           mla_entry_oper,
                                           mla_entry_date,
                                           mla_update_count)
              VALUES (o_languageadded,
                      i_mla_mem_id,
                      i_mla_lan_id,
                      i_mla_original,
                      i_mla_dubbed,
                      i_mla_subtitled,
                      i_mla_voice_over,
                      i_mla_supply,
                      i_mla_cost,
                      i_mla_notes,
                      i_mla_entry_oper,
                      SYSDATE,
                      0);

         l_flag := SQL%ROWCOUNT;

         IF (l_flag > 0)
         THEN
            COMMIT;
         ELSE
            o_languageadded := 0;
            ROLLBACK;
         END IF;
      ELSE
         RAISE fieldsalreadypresent;
      END IF;
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (
            -20357,
            'Language for Deal Memo is already present.');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20358, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_addlanguage;

   ------------------------------------- UPDATE PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_updtlanguage (
      i_mla_number         IN     sak_memo_lang_rights.mla_number%TYPE,
      i_mla_mem_id         IN     sak_memo_lang_rights.mla_mem_id%TYPE,
      i_mla_lan_id         IN     sak_memo_lang_rights.mla_lan_id%TYPE,
      i_mla_original       IN     sak_memo_lang_rights.mla_original%TYPE,
      i_mla_dubbed         IN     sak_memo_lang_rights.mla_dubbed%TYPE,
      i_mla_subtitled      IN     sak_memo_lang_rights.mla_subtitled%TYPE,
      i_mla_voice_over     IN     sak_memo_lang_rights.mla_voice_over%TYPE,
      i_mla_supply         IN     sak_memo_lang_rights.mla_supply%TYPE,
      i_mla_cost           IN     sak_memo_lang_rights.mla_cost%TYPE,
      i_mla_notes          IN     sak_memo_lang_rights.mla_notes%TYPE,
      i_mla_update_count   IN     sak_memo_lang_rights.mla_update_count%TYPE,
      o_languageupdated       OUT NUMBER)
   AS
      updatfailed            EXCEPTION;
      l_flag                 NUMBER;
      l_count                NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
      l_o_flag               NUMBER;
      l_message              VARCHAR2 (200);
      norights               EXCEPTION;
   BEGIN
      /* pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_mla_mem_id,
                                                          i_mem_change_oper,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF; */
      IF (fnc_adm_languageexists (i_mla_mem_id, i_mla_lan_id) > 0)
      THEN
         SELECT COUNT (mla_number)
           INTO l_count
           FROM sak_memo_lang_rights
          WHERE     mla_mem_id = i_mla_mem_id
                AND mla_number = i_mla_number
                AND mla_lan_id = i_mla_lan_id;

         -- AND NVL (mla_is_deleted, 'N') = 'N';
         IF (l_count = 1)
         THEN
            o_languageupdated := -1;
         ELSE
            RAISE fieldsalreadypresent;
         END IF;
      ELSE
         o_languageupdated := -1;
      END IF;

      IF (o_languageupdated = -1)
      THEN
         UPDATE sak_memo_lang_rights
            SET mla_original = i_mla_original,
                mla_dubbed = i_mla_dubbed,
                mla_subtitled = i_mla_subtitled,
                mla_voice_over = i_mla_voice_over,
                mla_supply = i_mla_supply,
                mla_cost = i_mla_cost,
                mla_notes = i_mla_notes
          --mla_update_count = NVL (mla_update_count, 0) + 1
          WHERE     mla_mem_id = i_mla_mem_id
                AND mla_lan_id = i_mla_lan_id
                AND mla_number = i_mla_number;

         --AND NVL (mla_update_count, 0) = i_mla_update_count;
         --RETURNING mla_update_count
         --INTO l_flag;
         /* AUTHOR : Devashish/Shantanu
            DATE: 30/jan/2014
            Description : Update Count Functionality Modified
         */
         SELECT mla_update_count
           INTO l_flag
           FROM sak_memo_lang_rights
          WHERE     mla_mem_id = i_mla_mem_id
                AND mla_lan_id = i_mla_lan_id
                AND mla_number = i_mla_number;

         IF (NVL (l_flag, 0) = NVL (i_mla_update_count, 0))
         THEN
            UPDATE sak_memo_lang_rights
               SET mla_update_count = NVL (mla_update_count, 0) + 1
             WHERE     mla_mem_id = i_mla_mem_id
                   AND mla_lan_id = i_mla_lan_id
                   AND mla_number = i_mla_number;

            COMMIT;

            SELECT mla_update_count
              INTO o_languageupdated
              FROM sak_memo_lang_rights
             WHERE     mla_mem_id = i_mla_mem_id
                   AND mla_lan_id = i_mla_lan_id
                   AND mla_number = i_mla_number;
         ELSE
            ROLLBACK;
            raise_application_error (
               -20325,
               'Language details are being modified' || ' by other user');
         END IF;
      /*****************************End of the Update count Functionality***************************/

      /*IF (l_flag <> 0)
      THEN
         COMMIT;
         o_languageupdated := l_flag;
      ELSE
         RAISE updatfailed;
      END IF;*/
      END IF;
   EXCEPTION
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (
            -20359,
            'Language for Deal Memo is already present.');
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20360, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20361, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_updtlanguage;

   ------------------------------------- DELETE PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_dellanguage (
      i_mla_number         IN     sak_memo_lang_rights.mla_number%TYPE,
      i_mla_mem_id         IN     sak_memo_lang_rights.mla_mem_id%TYPE,
      i_mla_lan_id         IN     sak_memo_lang_rights.mla_lan_id%TYPE,
      i_mla_update_count   IN     sak_memo_lang_rights.mla_update_count%TYPE,
      o_languagedeleted       OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
      l_o_flag       NUMBER;
      l_message      VARCHAR2 (200);
      norights       EXCEPTION;
   BEGIN
      /*pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_mem_id,
                                                         i_mem_change_oper,
                                                         l_o_flag,
                                                         l_message
                                                        );

     IF (l_o_flag = 0)
     THEN
        RAISE norights;
     END IF;*/
      DELETE FROM sak_memo_lang_rights
            WHERE     mla_mem_id = i_mla_mem_id
                  AND mla_lan_id = i_mla_lan_id
                  AND mla_number = i_mla_number
                  AND NVL (mla_update_count, 0) = i_mla_update_count;

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_languagedeleted := l_flag;
      ELSE
         RAISE deldatfailed;
      END IF;
   EXCEPTION
      WHEN deldatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20362, 'Data Not Deleted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20363, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_dellanguage;

   ------------------------------------- DEFAULT LANGUAGES PROCEDURE FOR LANGUAGE TAB  --------------------------------------
   PROCEDURE prc_adm_cm_default_languages (
      i_mem_id                   IN     sak_memo.mem_id%TYPE,
      o_defaultlanguagesresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      BEGIN
         DELETE FROM sak_memo_lang_rights
               WHERE mla_mem_id = i_mem_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      COMMIT;

      -- Code commented as per Desire's request.
      /*OPEN o_defaultlanguagesresult FOR
         SELECT DISTINCT mei_mem_id, lat_lan_id, 'N' AS mla_original,
                         'N' mla_dubbed, 'Y' AS mla_subtitled,
                         'N' AS mla_voice_over, 'L' AS mla_supply,
                         'C' mla_cost, NULL AS mla_notes
                    FROM sak_language_territory,
                         fid_channel_territory,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_language
                   WHERE ald_mei_id = mei_id
                     AND mei_mem_id = i_mem_id
                     AND cht_ter_code = lat_ter_code
                     AND lat_lan_id = lan_id
                     AND cht_cha_number IN (
                            SELECT csc_cha_number
                              FROM fid_channel_service_channel
                             WHERE csc_chs_number = ald_chs_number
                            UNION
                            SELECT chs_cha_number
                              FROM fid_channel_service
                             WHERE chs_number = ald_chs_number
                            UNION
                            SELECT cha_number
                              FROM fid_channel
                             WHERE cha_number = ald_chs_number)
         UNION */
      OPEN o_defaultlanguagesresult FOR
           SELECT DISTINCT i_mem_id,
                           'ENG' AS lat_lan_id,
                           'N' AS mla_original,
                           'N' mla_dubbed,
                           'Y' AS mla_subtitled,
                           'N' AS mla_voice_over,
                           'L' AS mla_supply,
                           'C' mla_cost,
                           NULL AS mla_notes
             FROM sak_memo_lang_rights
            WHERE NOT EXISTS
                     (SELECT 1
                        FROM sak_memo_lang_rights
                       WHERE mla_mem_id = i_mem_id AND mla_lan_id = 'ENG')
         ORDER BY lat_lan_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20364, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_default_languages;

   ----------------------- FUNCTION TO CHECK LANGUAGES EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_languageexists (
      i_mla_mem_id   IN sak_memo_lang_rights.mla_mem_id%TYPE,
      i_mla_lan_id   IN sak_memo_lang_rights.mla_lan_id%TYPE)
      RETURN NUMBER
   AS
      flag   NUMBER;
   BEGIN
      flag := 0;

      SELECT COUNT (mla_number)
        INTO flag
        FROM sak_memo_lang_rights
       WHERE mla_mem_id = i_mla_mem_id AND mla_lan_id = i_mla_lan_id;

      -- AND NVL (mla_is_deleted, 'N') = 'N';
      RETURN flag;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN OTHERS
      THEN
         raise_application_error (-20364, SUBSTR (SQLERRM, 1, 200));
   END fnc_adm_languageexists;

   ------------------------------------------- VIEW HISTORY PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_viewhistory (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
      l_dm_status_change_golive   x_fin_configs.CONTENT%TYPE;
   BEGIN
      SELECT CONTENT
        INTO l_dm_status_change_golive
        FROM x_fin_configs
       WHERE KEY = 'DM_STATUS_CHNAGE_GOLIVE';

      OPEN o_dealmemoresult FOR
           SELECT a.mem_id,
                  b.mhi_from_stat,
                  b.mhi_action,
                  b.mhi_to_stat,
                  b.mhi_entry_date,
                  b.mhi_entry_oper,
                  NVL (b.mhi_update_count, 0) AS mhi_update_count,
                --  b.mhi_comment ,
                  decode(b.mhi_action,'QAFAIL',b.mhi_comment,b.mhi_meta_comment)mhi_comment,---added by rashmi deal meta data cr
                  NVL (
                     (SELECT 'N'
                        FROM SAK_MEMO_HISTORY
                       WHERE     mhi_action = 'EXECUTE'
                             AND MHI_ENTRY_DATE < l_dm_status_change_golive
                             AND MHI_FROM_STAT <> 'BUDGETED'
                             AND MHI_MEM_ID = mem_id
                             AND ROWNUM < 2),
                     'Y')
                     dm_status_change_aply
             -- NVL (b.mhi_is_deleted, 'N') AS mhi_is_deleted
             FROM sak_memo a, sak_memo_history b
            WHERE b.mhi_mem_id = a.mem_id AND a.mem_id = i_mem_id
         --AND NVL (a.mem_is_deleted, 'N') = 'N'
         ORDER BY b.mhi_entry_date;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20365, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_viewhistory;

   ------------------------------------- SEARCH TERRITORIES LICENSED PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_viewterritorieslic (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_dealmemoresult FOR
           SELECT met_number,
                  met_mem_id,
                  met_ter_code,
                  ter_name,
                  met_rights,
                  mec_description,
                  NVL (met_update_count, 0) met_update_count
             FROM sak_memo_territory, fid_territory, sak_memo_code
            WHERE     met_ter_code = ter_code
                  AND met_rights = mec_value
                  AND mec_type = 'MET_RIGHTS'
                  -- AND NVL (met_is_deleted, 'N') = 'N'
                  AND met_mem_id = i_mem_id
         ORDER BY met_ter_code;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20366, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_viewterritorieslic;

   ------------------------------------- ADD TERRITORIES LICENSED PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_addterritorieslic (
      i_met_mem_id       IN     sak_memo_territory.met_mem_id%TYPE,
      i_met_ter_code     IN     sak_memo_territory.met_ter_code%TYPE,
      i_met_rights       IN     sak_memo_territory.met_rights%TYPE,
      i_met_entry_oper   IN     sak_memo_territory.met_entry_oper%TYPE,
      o_teradded            OUT NUMBER)
   AS
      l_flag                 NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
      l_o_flag               NUMBER;
      l_message              VARCHAR2 (200);
      norights               EXCEPTION;
   BEGIN
      /*pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_met_mem_id,
                                                          i_met_entry_oper,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF;*/
      IF (fnc_adm_territoryexists (i_met_mem_id, i_met_ter_code) = 0)
      THEN
         SELECT get_seq ('SEQ_MET_NUMBER') INTO o_teradded FROM DUAL;

         INSERT INTO sak_memo_territory (met_number,
                                         met_mem_id,
                                         met_ter_code,
                                         met_rights,
                                         met_entry_oper,
                                         met_entry_date,
                                         met_update_count)
              VALUES (o_teradded,
                      i_met_mem_id,
                      i_met_ter_code,
                      i_met_rights,
                      i_met_entry_oper,
                      SYSDATE,
                      0);

         l_flag := SQL%ROWCOUNT;

         IF (l_flag <> 0)
         THEN
            COMMIT;
         END IF;
      ELSE
         RAISE fieldsalreadypresent;
      END IF;
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (-20367,
                                  'Territory for Deal Memo already present.');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20368, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_addterritorieslic;

   ------------------------------------ UPDATE TERRITORIES LICENSED PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_updtterritorieslic (
      i_met_number         IN     sak_memo_territory.met_number%TYPE,
      i_met_mem_id         IN     sak_memo_territory.met_mem_id%TYPE,
      i_met_ter_code       IN     sak_memo_territory.met_ter_code%TYPE,
      i_met_rights         IN     sak_memo_territory.met_rights%TYPE,
      i_met_update_count   IN     sak_memo_territory.met_update_count%TYPE,
      o_terupdated            OUT NUMBER)
   AS
      updatfailed            EXCEPTION;
      l_flag                 NUMBER;
      l_count                NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
   BEGIN
      IF (fnc_adm_territoryexists (i_met_mem_id, i_met_ter_code) > 0)
      THEN
         SELECT COUNT (met_number)
           INTO l_count
           FROM sak_memo_territory
          WHERE     met_mem_id = i_met_mem_id
                AND met_ter_code = i_met_ter_code
                AND met_number = i_met_number;

         -- AND NVL (met_is_deleted, 'N') = 'N';
         IF (l_count = 1)
         THEN
            o_terupdated := -1;
         ELSE
            RAISE fieldsalreadypresent;
         END IF;
      ELSE
         o_terupdated := -1;
      END IF;

      IF (o_terupdated = -1)
      THEN
         UPDATE sak_memo_territory
            SET met_ter_code = i_met_ter_code, met_rights = i_met_rights
          --met_update_count = NVL (met_update_count, 0) + 1
          WHERE met_mem_id = i_met_mem_id AND met_number = i_met_number;

         --AND NVL (met_update_count, 0) = i_met_update_count
         --RETURNING met_update_count
         --INTO l_flag;
         /*
         AUTHOR : Devashish/Shantanu,
         DATE : 30/jan/2014,
         Description : Update Count Functionality Modified
         */
         SELECT met_update_count
           INTO l_flag
           FROM sak_memo_territory
          WHERE met_mem_id = i_met_mem_id AND met_number = i_met_number;

         IF (NVL (l_flag, 0) = NVL (i_met_update_count, 0))
         THEN
            UPDATE sak_memo_territory
               SET met_update_count = NVL (met_update_count, 0) + 1
             WHERE met_mem_id = i_met_mem_id AND met_number = i_met_number;

            COMMIT;

            SELECT met_update_count
              INTO o_terupdated
              FROM sak_memo_territory
             WHERE met_mem_id = i_met_mem_id AND met_number = i_met_number;
         ELSE
            ROLLBACK;
            raise_application_error (
               -20325,
               'Territory details are being modified' || ' by other user');
         END IF;
      /************************End Of the Update count Functionality*******************/

      /*IF (l_flag <> 0)
      THEN
         COMMIT;
         o_terupdated := l_flag;
      ELSE
         RAISE updatfailed;
      END IF;*/
      END IF;
   EXCEPTION
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (-20369,
                                  'Territory for Deal Memo already present.');
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20370, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20371, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_updtterritorieslic;

   ------------------------------------ DELETE TERRITORIES LICENSED PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_delterritorieslic (
      i_met_number         IN     sak_memo_territory.met_number%TYPE,
      i_met_mem_id         IN     sak_memo_territory.met_mem_id%TYPE,
      i_met_update_count   IN     sak_memo_territory.met_update_count%TYPE,
      o_terdeleted            OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
   BEGIN
      o_terdeleted := -1;

      DELETE FROM sak_memo_territory
            WHERE     met_mem_id = i_met_mem_id
                  AND met_number = i_met_number
                  AND NVL (met_update_count, 0) = i_met_update_count;

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_terdeleted := 1;
      ELSE
         RAISE deldatfailed;
      END IF;
   EXCEPTION
      WHEN deldatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20372, 'Data Not Deleted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20373, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_delterritorieslic;

   ------------------------------------- DEFAULT TERRITORIES PROCEDURE FOR TERRITORY TAB  --------------------------------------
   PROCEDURE prc_adm_cm_default_territories (
      i_mem_id                   IN     sak_memo.mem_id%TYPE,
      i_defaultrights            IN     sak_memo_territory.met_ter_code%TYPE,
      o_defaultterritoryresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
      l_rightsdesc               VARCHAR2 (50);
      l_mem_amort_method         sak_memo.mem_amort_method%TYPE;
      l_is_linear_lee_present    NUMBER;
      l_is_catcup_lee_present    NUMBER;
      l_lee_number_rsa           fid_licensee.lee_number%TYPE;
      l_lee_number_afr           fid_licensee.lee_number%TYPE;
      l_alloc_present            NUMBER;
      l_lee_region_both_flag     VARCHAR2 (1);
      l_afr_count                NUMBER;       -- added on 11 JUn 2015 Vanilla
      l_int_count                NUMBER;      -- added on  11 JUn 2015 Vanilla
      l_catchup_rsa_count        NUMBER;      -- added on  11 JUn 2015 Vanilla
      l_catchup_afr_count        NUMBER;      -- added on  11 JUn 2015 Vanilla
      l_svod_afr_count           NUMBER;      -- added on  11 JUn 2015 Vanilla
      l_svod_int_count           NUMBER;      -- added on  11 JUn 2015 Vanilla
      l_lee_media_service_code   VARCHAR2 (10); -- added on  11 JUn 2015 Vanilla
      l_lee_region_id            NUMBER;       -- added on 11 JUn 2015 Vanilla
      L_LEE_T36A                  NUMBER;
      L_LEE_NOT_T36A      NUMBER;
   BEGIN
      -- Added by khilesh Chauhan 11 Jun 2015 Vanilla
      --[23-jun-205][Jawahar.Garg]Added 3rd party catchup licensee.
      BEGIN
         l_catchup_afr_count := 0;
         l_catchup_rsa_count := 0;
         l_svod_int_count := 0;
         l_svod_afr_count := 0;

         FOR i
            IN (  SELECT FID_LICENSEE.LEE_MEDIA_SERVICE_CODE,
                         fid_licensee.lee_region_id,
                         (CASE
                             WHEN LEE_MEDIA_SERVICE_CODE IN
                                     ('CATCHUP', 'CATCHUP3P')
                                  AND LEE_REGION_ID = 1
                             THEN
                                1
                             ELSE
                                0
                          END)
                            CATCHUP_AFR_COUNT,
                         (CASE
                             WHEN lee_media_service_code IN
                                     ('CATCHUP', 'CATCHUP3P')
                                  AND lee_region_id = 2
                             THEN
                                1
                             ELSE
                                0
                          END)
                            CATCHUP_RSA_COUNT,
                         (CASE
                             WHEN lee_media_service_code NOT IN
                                     ('CATCHUP', 'CATCHUP3P')
                                  AND lee_region_id != 2
                             THEN
                                1
                             ELSE
                                0
                          END)
                            SVOD_INT_COUNT,
                         (CASE
                             WHEN LEE_MEDIA_SERVICE_CODE NOT IN
                                     ('CATCHUP', 'CATCHUP3P')
                                  AND LEE_REGION_ID = 2
                             THEN
                                1
                             ELSE
                                0
                          END)
                            SVOD_AFR_COUNT
                    FROM sak_allocation_detail,
                         sak_memo_item,
                         SAK_MEMO,
                         FID_LICENSEE
                   WHERE     ALD_MEI_ID = MEI_ID
                         AND MEI_MEM_ID = MEM_ID
                         AND MEI_MEM_ID = i_mem_id
                         AND LEE_NUMBER = ALD_LEE_NUMBER
                         AND LEE_MEDIA_SERVICE_CODE NOT IN ('PAYTV', 'TVOD')
                GROUP BY LEE_MEDIA_SERVICE_CODE, FID_LICENSEE.LEE_REGION_ID)
         LOOP
            IF i.lee_region_id = 1
            THEN
               l_catchup_afr_count :=
                  l_catchup_afr_count + i.catchup_afr_count;
            --dbms_output.put_line('catchup_afr_count  :' || i.catchup_afr_count);-- from dual;
            ELSIF i.lee_region_id = 2
            THEN
               l_catchup_rsa_count :=
                  l_catchup_rsa_count + i.catchup_rsa_count;
               l_svod_afr_count := l_svod_afr_count + i.svod_afr_count;
            --dbms_output.put_line('catchup_rsa_count  :' ||i.catchup_rsa_count);
            --dbms_output.put_line('svod_afr_count  :'||i.svod_afr_count);
            ELSIF i.lee_region_id != 2
            THEN
               l_svod_int_count := l_svod_int_count + i.svod_int_count;
            --dbms_output.put_line('l_svod_int_count  :'||l_svod_int_count);
            END IF;
         END LOOP;

         l_lee_media_service_code := NVL (l_lee_media_service_code, '');
         l_lee_region_id := NVL (l_lee_region_id, 0);
         l_catchup_afr_count := NVL (l_catchup_afr_count, 0);
         l_catchup_rsa_count := NVL (l_catchup_rsa_count, 0);
         l_svod_int_count := NVL (l_svod_int_count, 0);
      EXCEPTION
         WHEN OTHERS
         THEN
            l_lee_media_service_code := NVL (l_lee_media_service_code, '');
            l_lee_region_id := NVL (l_lee_region_id, 0);
            l_catchup_afr_count := NVL (l_catchup_afr_count, 0);
            l_catchup_rsa_count := NVL (l_catchup_rsa_count, 0);
            l_svod_int_count := NVL (l_svod_int_count, 0);
      END;

      BEGIN
         DELETE FROM sak_memo_territory
               WHERE met_mem_id = i_mem_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      COMMIT;

      IF (i_defaultrights = 'E')
      THEN
         l_rightsdesc := 'Exclusive';
      ELSIF (i_defaultrights = 'N')
      THEN
         l_rightsdesc := 'Non-Exclusive';
      ELSE
         l_rightsdesc := 'No Rights';
      END IF;

      BEGIN
         SELECT mem_amort_method
           INTO l_mem_amort_method
           FROM sak_memo
          WHERE mem_id = i_mem_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20011, 'AMORT METHOD NOT PREASENT');
      END;

      SELECT COUNT (1)
        INTO l_alloc_present
        FROM sak_allocation_detail,
             sak_memo_item,
             sak_memo,
             fid_licensee
       WHERE     ald_mei_id = mei_id
             AND mei_mem_id = mem_id
             AND lee_number = ald_lee_number
             AND mei_mem_id = i_mem_id;

      /*BEGIN
      SELECT lee_region_both_flag
      INTO  l_lee_region_both_flag
      FROM sak_allocation_detail,
           sak_memo_item,
           sak_memo,
           fid_licensee
     WHERE     ald_mei_id = mei_id
           AND mei_mem_id = mem_id
           AND lee_number = ald_lee_number
           AND mei_mem_id = i_mem_id;
      EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
          l_lee_region_both_flag:='N';
          END;*/

      IF l_alloc_present > 0
      THEN                              --Added to fix table 0 not found issue
         /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added the logic to populate all the territories as default if only catchup licensee is selected */
         BEGIN
            SELECT COUNT (*)
              INTO l_is_linear_lee_present
              FROM sak_allocation_detail,
                   sak_memo_item,
                   sak_memo,
                   fid_licensee
             WHERE     ald_mei_id = mei_id
                   AND mei_mem_id = mem_id
                   AND lee_number = ald_lee_number
                   AND mei_mem_id = i_mem_id
                   -- added by khilesh 11 JUn 2015 Vanilla
                   -- AND NVL (lee_media_service_code, '#') not in ('CATCHUP','SVOD');
                   AND NVL (lee_media_service_code, '#') NOT IN
                          (SELECT ms_media_service_code
                             FROM sgy_pb_media_service
                            WHERE ms_media_service_code NOT IN
                                     ('PAYTV', 'TVOD'));

            /*Neeraj Basliyal 12-06-13 : Catchup Cannot Execute With? All The Terriotories Of The World P1. */
            SELECT COUNT (*)
              INTO l_is_catcup_lee_present
              FROM sak_allocation_detail,
                   sak_memo_item,
                   sak_memo,
                   fid_licensee
             WHERE     ald_mei_id = mei_id
                   AND mei_mem_id = mem_id
                   AND lee_number = ald_lee_number
                   AND mei_mem_id = i_mem_id
                   -- added by khilesh 11 JUn 2015 Vanilla
                   --AND NVL (lee_media_service_code, '#') in( 'CATCHUP','SVOD');
                   AND NVL (lee_media_service_code, '#') IN
                          (SELECT ms_media_service_code
                             FROM sgy_pb_media_service
                            WHERE ms_media_service_code NOT IN
                                     ('PAYTV', 'TVOD'));

            /* Catchup :12-JUN-13 :if only one catchup licensee is selected */
            /* PB CR Mrunmayi kusurkar : Now user needs that with linear all catchup territories with respect to region should be populated.
            So done changes accomadate that.
            */
            IF l_is_catcup_lee_present > 0
            THEN
               BEGIN
                  SELECT ald_lee_number
                    INTO l_lee_number_rsa
                    FROM sak_allocation_detail,
                         sak_memo_item,
                         sak_memo,
                         fid_licensee
                   WHERE     ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND lee_number = ald_lee_number
                         AND mei_mem_id = i_mem_id
                         AND (ald_lee_number IN
                                 (SELECT lee_number
                                    FROM fid_licensee
                                   WHERE lee_region_id = 2
                                         AND Lee_media_service_code IN
                                                ('CATCHUP', 'CATCHUP3P'))
                              ---= 467 added by khilesh chauhan 11 Jun 2015 Vanilla
                              -- added by khilesh 11 JUn 2015 Vanilla
                              OR (NVL (lee_media_service_code, '#') NOT IN
                                     ('PAYTV', 'CATCHUP', 'TVOD', 'CATCHUP3P')
                                  AND lee_region_id = 3))
                         AND ROWNUM < 2;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_lee_number_rsa := 0;
               END;

               BEGIN
                  SELECT ald_lee_number
                    INTO l_lee_number_afr
                    FROM sak_allocation_detail,
                         sak_memo_item,
                         sak_memo,
                         fid_licensee
                   WHERE     ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND lee_number = ald_lee_number
                         AND mei_mem_id = i_mem_id
                         AND (ald_lee_number IN
                                 (SELECT lee_number
                                    FROM fid_licensee
                                   WHERE lee_region_id = 1
                                         AND Lee_media_service_code IN
                                                ('CATCHUP', 'CATCHUP3P'))
                              --= 468 Added by khilesh Chauhan 11 Jun 2015 Vanilla
                              -- added by khilesh 11 JUn 2015 Vanilla
                              OR (NVL (lee_media_service_code, '#') NOT IN
                                     ('PAYTV', 'CATCHUP', 'TVOD', 'CATCHUP3P')
                                  AND lee_region_id = 2))
                         AND ROWNUM < 2;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_lee_number_afr := 0;
               END;

               -- added by khilesh 11 JUn 2015 Vanilla

               SELECT COUNT (1)
                 INTO l_afr_count
                 FROM fid_licensee
                WHERE lee_media_service_code NOT IN
                         ('PAYTV', 'CATCHUP', 'TVOD', 'CATCHUP3P')
                      AND lee_region_id = 2
                      AND lee_number = l_lee_number_afr;

               SELECT COUNT (1)
                 INTO l_int_count
                 FROM fid_licensee
                WHERE lee_media_service_code NOT IN
                         ('PAYTV', 'CATCHUP', 'TVOD', 'CATCHUP3P')
                      AND lee_region_id = 3
                      AND lee_number = l_lee_number_rsa;
            END IF;
         /*Neeraj Basliyal 12-06-13 : Catchup Cannot Execute With? All The Terriotories Of The World P1. */
         END;

/* Srart - Added for cu4ALL */
SELECT
sum((case WHEN LEE_SHORT_NAME='T36A' THEN 1 ELSE 0 END)),
sum((case WHEN LEE_SHORT_NAME!='T36A' THEN 1 ELSE 0 END))
INTO L_LEE_T36A,
L_LEE_NOT_T36A
FROM sak_allocation_detail,
sak_memo_item,
SAK_MEMO,
FID_LICENSEE
WHERE     ALD_MEI_ID = MEI_ID
AND MEI_MEM_ID = MEM_ID
AND MEI_MEM_ID = i_mem_id
AND LEE_NUMBER = ALD_LEE_NUMBER
AND LEE_MEDIA_SERVICE_CODE NOT IN ('PAYTV', 'TVOD');
--AND LEE_SHORT_NAME='T36A';
--GROUP BY LEE_MEDIA_SERVICE_CODE,LEE_SHORT_NAME, FID_LICENSEE.LEE_REGION_ID;
/*End - Added for cu4ALL */


         /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :END */
         IF l_mem_amort_method <> 'D'
         THEN
            IF (l_is_linear_lee_present > 0 AND l_is_catcup_lee_present = 0) -- If only linear lee is present
            THEN
               OPEN o_defaultterritoryresult FOR
                    SELECT DISTINCT i_mem_id AS i_mem_id,
                                    i_defaultrights AS i_defaultrights,
                                    l_rightsdesc rightdesc,
                                    cht_ter_code,
                                    ter_name
                      FROM fid_channel_territory,
                           fid_territory,
                           sak_allocation_detail,
                           sak_memo_item,
                           sak_memo
                     WHERE     cht_ter_code = ter_code
                           AND ald_mei_id = mei_id
                           AND mei_mem_id = mem_id
                           AND mem_id = i_mem_id
                           AND SYSDATE BETWEEN cht_ter_start_dt
                                           AND cht_ter_end_dt
                           AND cht_cha_number IN
                                  (SELECT csc_cha_number
                                     FROM fid_channel_service_channel
                                    WHERE csc_chs_number = ald_chs_number
                                          AND SYSDATE BETWEEN csc_start_dt
                                                          AND csc_end_dt
                                   UNION
                                   SELECT chs_cha_number
                                     FROM fid_channel_service
                                    WHERE chs_number = ald_chs_number
                                   UNION
                                   SELECT cha_number
                                     FROM fid_channel
                                    WHERE cha_number = ald_chs_number)
                  ORDER BY cht_ter_code;
            /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added the logic to populate all the territories as default if only catchup licensee is selected */
            /*Neeraj Basliyal 12-06-13 : Catchup Cannot Execute With? All The Terriotories Of The World P1. */
            ELSIF (l_is_catcup_lee_present > 0 AND l_catchup_rsa_count >= 1
                   OR l_svod_int_count >= 1 ---AND l_lee_number_rsa IN (467,492) added by khilesh chauhan 11 Jun 2015 Vanilla
                                           AND l_is_linear_lee_present > 0) -- if both cp and linear present and cp is RSA
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  cht_ter_code,
                                  ter_name
                    FROM fid_channel_territory,
                         fid_territory,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     cht_ter_code = ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND SYSDATE BETWEEN cht_ter_start_dt
                                         AND cht_ter_end_dt
                         AND cht_cha_number IN
                                (SELECT csc_cha_number
                                   FROM fid_channel_service_channel
                                  WHERE csc_chs_number = ald_chs_number
                                        AND SYSDATE BETWEEN csc_start_dt
                                                        AND csc_end_dt
                                 UNION
                                 SELECT chs_cha_number
                                   FROM fid_channel_service
                                  WHERE chs_number = ald_chs_number
                                 UNION
                                 SELECT cha_number
                                   FROM fid_channel
                                  WHERE cha_number = ald_chs_number)
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           DECODE (l_lee_number_rsa,
                                                   492, 3,
                                                   2));
            -- hard coded to get the catchup territories for lee = CRSA
            ELSIF (l_is_catcup_lee_present > 0 AND l_catchup_afr_count >= 1
                   OR l_svod_afr_count >= 1 --AND l_lee_number_afr IN( 468,491) Added by khilesh Chauhan 11 Jun 2015 Vanilla
                                           AND l_is_linear_lee_present > 0) -- if both cp and linear present and cp is AFR
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  cht_ter_code,
                                  ter_name
                    FROM fid_channel_territory,
                         fid_territory,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     cht_ter_code = ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND SYSDATE BETWEEN cht_ter_start_dt
                                         AND cht_ter_end_dt
                         AND cht_cha_number IN
                                (SELECT csc_cha_number
                                   FROM fid_channel_service_channel
                                  WHERE csc_chs_number = ald_chs_number
                                        AND SYSDATE BETWEEN csc_start_dt
                                                        AND csc_end_dt
                                 UNION
                                 SELECT chs_cha_number
                                   FROM fid_channel_service
                                  WHERE chs_number = ald_chs_number
                                 UNION
                                 SELECT cha_number
                                   FROM fid_channel
                                  WHERE cha_number = ald_chs_number)
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN (SELECT reg_code
                                                        FROM fid_region
                                                       WHERE reg_id = 1);
            ELSIF (    l_is_catcup_lee_present > 0
                   AND l_is_linear_lee_present = 0
                   -- added by khilesh 11 JUn 2015 Vanilla
                   AND (l_catchup_afr_count >= 1 OR l_afr_count >= 0)
                   AND (l_catchup_rsa_count >= 1 OR l_int_count >= 0))
            -- AND (l_lee_number_afr = 468 OR l_afr_count > 0)
            -- AND (l_lee_number_rsa = 467 OR l_int_count > 0)) -- if cp present and cp is both AFR and AFR
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           (CASE
                                               WHEN l_lee_number_rsa IN
                                                       (SELECT lee_number
                                                          FROM fid_licensee
                                                         WHERE lee_media_service_code NOT IN
                                                                  ('PAYTV',
                                                                   'CATCHUP',
                                                                   'TVOD',
                                                                   'CATCHUP3P')
                                                               AND lee_region_id =
                                                                      3)
                                               THEN
                                                  3
                                               ELSE
                                                  0
                                            END))
                  -- added by khilesh 11 JUn 2015 Vanilla
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           (CASE
                                               WHEN l_catchup_afr_count > 0
                                               THEN
                                                  1
                                               WHEN l_afr_count > 0
                                               THEN
                                                  1
                                               ELSE
                                                  NULL
                                            END))                       --= 1)
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           (CASE
                                               WHEN l_catchup_rsa_count > 0
                                               THEN
                                                  2
                                               WHEN l_afr_count > 0
                                               THEN
                                                  2
                                               ELSE
                                                  NULL
                                            END)); --= 2); -- added by khilesh 11 JUn 2015 Vanilla
            ELSIF (    l_is_catcup_lee_present > 0
                   AND l_is_linear_lee_present = 0
                   AND (l_catchup_rsa_count >= 1 OR l_int_count >= 0))
            --   AND (l_lee_number_rsa = 467 OR l_int_count > 0))  -- if cp present and cp is RSA
            -- added by khilesh 11 JUn 2015 Vanilla
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           (CASE
                                               WHEN l_lee_number_rsa IN
                                                       (SELECT lee_number
                                                          FROM fid_licensee
                                                         WHERE lee_media_service_code NOT IN
                                                                  ('PAYTV',
                                                                   'CATCHUP',
                                                                   'TVOD',
                                                                   'CATCHUP3P')
                                                               AND lee_region_id =
                                                                      3)
                                               THEN
                                                  3
                                               ELSE
                                                  2
                                            END));
            -- added by khilesh 11 JUn 2015 Vanilla
            ELSIF (    l_is_catcup_lee_present > 0
                   AND l_is_linear_lee_present = 0
                   AND (l_catchup_afr_count >= 1 OR l_afr_count >= 0)) -- Added by khilesh Chauhan 11 Jun 2015 Vanilla
            -- AND (l_lee_number_afr = 468 OR l_afr_count > 0))  -- if cp present and cp is AFR
            ---- added by khilesh 11 JUn 2015 Vanilla
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN (SELECT reg_code
                                                        FROM fid_region
                                                       WHERE reg_id = 1)
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN (SELECT reg_code
                                                        FROM fid_region
                                                       WHERE reg_id = 2);
            -- added by khilesh 11 JUn 2015 Vanilla
            ELSIF (                          --  l_lee_number_afr IN( 468,491)
                       -- AND l_lee_number_rsa IN (467,492)
                       (l_catchup_afr_count >= 1 OR l_svod_afr_count >= 1)
                   AND (l_catchup_rsa_count >= 1 OR l_svod_int_count >= 1)
                   AND l_is_linear_lee_present > 0)
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  cht_ter_code,
                                  ter_name
                    FROM fid_channel_territory,
                         fid_territory,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     cht_ter_code = ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND SYSDATE BETWEEN cht_ter_start_dt
                                         AND cht_ter_end_dt
                         AND cht_cha_number IN
                                (SELECT csc_cha_number
                                   FROM fid_channel_service_channel
                                  WHERE csc_chs_number = ald_chs_number
                                        AND SYSDATE BETWEEN csc_start_dt
                                                        AND csc_end_dt
                                 UNION
                                 SELECT chs_cha_number
                                   FROM fid_channel_service
                                  WHERE chs_number = ald_chs_number
                                 UNION
                                 SELECT cha_number
                                   FROM fid_channel
                                  WHERE cha_number = ald_chs_number)
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           DECODE (l_lee_number_rsa,
                                                   492, 3,
                                                   2))
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN (SELECT reg_code
                                                        FROM fid_region
                                                       WHERE reg_id = 1);
            END IF;
         ELSE
            --     RAISE_APPLICATION_ERROR (-20374, 'in afr' ||L_IS_LINEAR_LEE_PRESENT || '-' ||  L_IS_CATCUP_LEE_PRESENT || '-- ' || L_LEE_NUMBER_AFR || '--' || L_LEE_NUMBER_RSA );
            IF (l_is_linear_lee_present > 0 AND l_is_catcup_lee_present = 0) -- If only linear lee is present
            THEN
               OPEN o_defaultterritoryresult FOR
                    SELECT DISTINCT i_mem_id AS i_mem_id,
                                    i_defaultrights AS i_defaultrights,
                                    l_rightsdesc rightdesc,
                                    cht_ter_code,
                                    ter_name
                      FROM fid_channel_territory,
                           fid_territory,
                           sak_allocation_detail,
                           sak_memo_item,
                           sak_memo
                     WHERE     cht_ter_code = ter_code
                           AND ald_mei_id = mei_id
                           AND mei_mem_id = mem_id
                           AND mem_id = i_mem_id
                           AND SYSDATE BETWEEN cht_ter_start_dt
                                           AND cht_ter_end_dt
                           AND cht_cha_number IN
                                  (SELECT csc_cha_number
                                     FROM fid_channel_service_channel
                                    WHERE csc_chs_number = ald_chs_number
                                          AND SYSDATE BETWEEN csc_start_dt
                                                          AND csc_end_dt
                                   UNION
                                   SELECT chs_cha_number
                                     FROM fid_channel_service
                                    WHERE chs_number = ald_chs_number)
                  ORDER BY cht_ter_code;
            /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added the logic to populate all the territories as default if only catchup licensee is selected */
            /*Neeraj Basliyal 12-06-13 : Catchup Cannot Execute With? All The Terriotories Of The World P1. */
            ELSIF (    l_is_catcup_lee_present > 0
                   AND (l_catchup_rsa_count >= 1 OR l_svod_int_count >= 1)
                   --AND l_lee_number_rsa IN( 467,492)
                   AND l_is_linear_lee_present > 0
                   AND l_catchup_afr_count = 0 --Added by Jawahar [09-Jul-2015] If lin and cp both present and only RSA allocation is there
                                              )
            -- and l_lee_region_both_flag ='N') -- if both cp and linear present and cp is RSA
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  cht_ter_code,
                                  ter_name
                    FROM fid_channel_territory,
                         fid_territory,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     cht_ter_code = ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND SYSDATE BETWEEN cht_ter_start_dt
                                         AND cht_ter_end_dt
                         AND cht_cha_number IN
                                (SELECT csc_cha_number
                                   FROM fid_channel_service_channel
                                  WHERE csc_chs_number = ald_chs_number
                                        AND SYSDATE BETWEEN csc_start_dt
                                                        AND csc_end_dt
                                 UNION
                                 SELECT chs_cha_number
                                   FROM fid_channel_service
                                  WHERE chs_number = ald_chs_number)
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           DECODE (l_lee_number_rsa,
                                                   492, 3,
                                                   2));
            -- hard coded to get the catchup territories for lee = CRSA
            ELSIF (    l_is_catcup_lee_present > 0
                   AND (l_catchup_afr_count >= 1 OR l_svod_afr_count >= 1)
                   -- AND l_lee_number_afr IN (468,491) -- Added by khilesh Chauhan 11 jun 2015 Vanilla
                   AND l_catchup_rsa_count = 0 --Added by Jawahar [09-Jul-2015] If lin and cp both present and only RSA allocation is there
                   AND l_is_linear_lee_present > 0)
            -- and l_lee_region_both_flag ='N') -- if both cp and linear present and cp is AFR
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  cht_ter_code,
                                  ter_name
                    FROM fid_channel_territory,
                         fid_territory,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     cht_ter_code = ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND SYSDATE BETWEEN cht_ter_start_dt
                                         AND cht_ter_end_dt
                         AND cht_cha_number IN
                                (SELECT csc_cha_number
                                   FROM fid_channel_service_channel
                                  WHERE csc_chs_number = ald_chs_number
                                        AND SYSDATE BETWEEN csc_start_dt
                                                        AND csc_end_dt
                                 UNION
                                 SELECT chs_cha_number
                                   FROM fid_channel_service
                                  WHERE chs_number = ald_chs_number)
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN (SELECT reg_code
                                                        FROM fid_region
                                                       WHERE reg_id = 1);
            ELSIF (    l_is_catcup_lee_present > 0
                   AND l_is_linear_lee_present = 0
                   AND (l_catchup_afr_count >= 1 OR l_svod_afr_count >= 1)
                   AND (l_catchup_rsa_count >= 1 OR l_svod_int_count >= 1))
            -- AND l_lee_number_afr IN( 468,491) -- Added by khilesh Chauhan 11 Jun 2015 Vanilla
            -- AND l_lee_number_rsa IN (467,492))  -- if cp present and cp is both AFR and AFR
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           DECODE (l_lee_number_rsa,
                                                   492, 3,
                                                   2))
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN (SELECT reg_code
                                                        FROM fid_region
                                                       WHERE reg_id = 1);
            ELSIF (    l_is_catcup_lee_present > 0
                   AND l_is_linear_lee_present = 0
                   AND (l_catchup_rsa_count >= 1 OR l_svod_int_count >= 1))
            --AND l_lee_number_rsa IN (467,492)) Added by khilesh chauhan 11 JUn 2015 Vanilla
            --and l_lee_region_both_flag ='N')  -- if cp present and cp is RSA
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           DECODE (l_lee_number_rsa,
                                                   492, 3,
                                                   2));
            ELSIF (    l_is_catcup_lee_present > 0
                   AND l_is_linear_lee_present = 0
                   AND (l_catchup_afr_count >= 1 OR l_svod_afr_count >= 1))
            --   AND l_lee_number_afr IN (468,491)) Added by khilesh chauhan 11 Jun 2011 Vanilla
            -- and l_lee_region_both_flag ='N')  -- if cp present and cp is AFR
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN (SELECT reg_code
                                                        FROM fid_region
                                                       WHERE reg_id = 1);
            ELSIF ( ( (l_catchup_afr_count >= 1 OR l_svod_afr_count >= 1)
                     AND (l_catchup_rsa_count >= 1 OR l_svod_int_count >= 1)
                     --( l_lee_number_afr IN( 468,491)
                     --       AND l_lee_number_rsa IN( 467,492))
                     OR l_lee_region_both_flag = 'Y')
                   AND l_is_linear_lee_present > 0)
            THEN
               OPEN o_defaultterritoryresult FOR
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  cht_ter_code,
                                  ter_name
                    FROM fid_channel_territory,
                         fid_territory,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     cht_ter_code = ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND SYSDATE BETWEEN cht_ter_start_dt
                                         AND cht_ter_end_dt
                         AND cht_cha_number IN
                                (SELECT csc_cha_number
                                   FROM fid_channel_service_channel
                                  WHERE csc_chs_number = ald_chs_number
                                        AND SYSDATE BETWEEN csc_start_dt
                                                        AND csc_end_dt
                                 UNION
                                 SELECT chs_cha_number
                                   FROM fid_channel_service
                                  WHERE chs_number = ald_chs_number)
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code cht_ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN
                                (SELECT reg_code
                                   FROM fid_region
                                  WHERE reg_id =
                                           DECODE (l_lee_number_rsa,
                                                   492, 3,
                                                   2))
                  UNION
                  SELECT DISTINCT i_mem_id AS i_mem_id,
                                  i_defaultrights AS i_defaultrights,
                                  l_rightsdesc rightdesc,
                                  ter.ter_code,
                                  ter.ter_name
                    FROM fid_territory_region mapp,
                         fid_territory ter,
                         sak_allocation_detail,
                         sak_memo_item,
                         sak_memo
                   WHERE     mapp.ter_code = ter.ter_code
                         AND ald_mei_id = mei_id
                         AND mei_mem_id = mem_id
                         AND mem_id = i_mem_id
                         AND mapp.ter_parent_code IN (SELECT reg_code
                                                        FROM fid_region
                                                       WHERE reg_id = 1);
            END IF;
	 /*Start -cu4All */
            IF L_LEE_T36A>0 and L_LEE_NOT_T36A=0 THEN
                OPEN o_defaultterritoryresult FOR
                SELECT
                DISTINCT
                i_mem_id AS i_mem_id,
                i_defaultrights AS i_defaultrights,
                l_rightsdesc rightdesc,
                ter.ter_code cht_ter_code,
                ter.ter_name
                FROM fid_territory_region mapp,
                fid_territory ter
                WHERE mapp.ter_code = ter.ter_code
                AND ter.TER_CODE IN ('ANG','MOZ');
          END IF;
 	 /*END -cu4All */
         END IF;
      ELSE
         OPEN o_defaultterritoryresult FOR
            SELECT '' i_mem_id,
                   '' i_defaultrights,
                   '' rightdesc,
                   '' cht_ter_code,
                   '' ter_name
              FROM DUAL
             WHERE 1 = -1;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20374, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_default_territories;

   ----------------------- FUNCTION TO CHECK TERRITORY EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_territoryexists (
      i_met_mem_id     IN sak_memo_territory.met_mem_id%TYPE,
      i_met_ter_code   IN sak_memo_territory.met_ter_code%TYPE)
      RETURN NUMBER
   AS
      flag   NUMBER;
   BEGIN
      flag := 0;

      SELECT COUNT (met_number)
        INTO flag
        FROM sak_memo_territory
       WHERE met_mem_id = i_met_mem_id AND met_ter_code = i_met_ter_code;

      --AND NVL (met_is_deleted, 'N') = 'N';
      RETURN flag;
   END fnc_adm_territoryexists;

   ------------------------------------- SEARCH PROCEDURE FOR PROTECTION TAB  --------------------------------------
   PROCEDURE prc_adm_cm_viewprotection (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_dealmemoresult FOR
           SELECT mep_number,
                  mep_competitor,
                  mec_description,
                  mep_comment,
                  NVL (mep_update_count, 0) mep_update_count
             FROM sak_memo_protection, sak_memo_code
            WHERE     mep_competitor = mec_value
                  AND mec_type = 'MEP_COMPETITOR'
                  AND mep_mem_id = i_mem_id
         ORDER BY mep_competitor;
   --AND NVL (mep_is_deleted, 'N') = 'N';
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20375, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_viewprotection;

   ------------------------------------- ADD PROTECTION TAB PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_addprotection (
      i_mep_mem_id        IN     sak_memo_protection.mep_mem_id%TYPE,
      -- Sak memo ID
      i_mep_competitor    IN     sak_memo_protection.mep_competitor%TYPE,
      -- Competitor Code
      i_mep_comment       IN     sak_memo_protection.mep_comment%TYPE,
      -- Comments
      i_mep_entry_oper    IN     sak_memo_protection.mep_entry_oper%TYPE,
      -- Entry operatot
      o_protectionadded      OUT NUMBER)
   AS
      l_flag                 NUMBER := -1;
      l_pcount               NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
      l_o_flag               NUMBER;
      l_message              VARCHAR2 (200);
      norights               EXCEPTION;
   BEGIN
      /*pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_mep_mem_id,
                                                          i_mep_entry_oper,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF;*/
      IF (fnc_adm_protectionexists (i_mep_mem_id, i_mep_competitor) = 0)
      THEN
         SELECT get_seq ('SEQ_MEP_NUMBER') INTO o_protectionadded FROM DUAL;

         INSERT INTO sak_memo_protection (mep_number,
                                          mep_mem_id,
                                          mep_competitor,
                                          mep_comment,
                                          mep_entry_oper,
                                          mep_entry_date,
                                          mep_update_count)
              VALUES (o_protectionadded,
                      i_mep_mem_id,
                      i_mep_competitor,
                      i_mep_comment,
                      i_mep_entry_oper,
                      SYSDATE,
                      0);

         l_flag := SQL%ROWCOUNT;

         IF (l_flag <> 0)
         THEN
            COMMIT;
         END IF;
      ELSE
         RAISE fieldsalreadypresent;
      END IF;
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (
            -20376,
            'Competitor for the Deal Memo is already present.');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20377, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_addprotection;

   ------------------------------------- UPDATE PROTECTION TAB PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_updtprotection (
      i_mep_number          IN     sak_memo_protection.mep_number%TYPE,
      -- Protection primary key number
      i_mep_mem_id          IN     sak_memo_protection.mep_mem_id%TYPE,
      -- Sak memo ID
      i_mep_competitor      IN     sak_memo_protection.mep_competitor%TYPE,
      -- Competitor Code
      i_mep_comment         IN     sak_memo_protection.mep_comment%TYPE,
      -- Comments
      i_mep_update_count    IN     sak_memo_protection.mep_update_count%TYPE,
      o_protectionupdated      OUT NUMBER)
   AS
      updatfailed            EXCEPTION;
      l_flag                 NUMBER;
      l_count                NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
   BEGIN
      IF (fnc_adm_protectionexists (i_mep_mem_id, i_mep_competitor) > 0)
      THEN
         SELECT COUNT (mep_number)
           INTO l_count
           FROM sak_memo_protection
          WHERE     mep_mem_id = i_mep_mem_id
                AND mep_competitor = i_mep_competitor
                AND mep_number = i_mep_number;

         -- AND NVL (mep_is_deleted, 'N') = 'N';
         IF (l_count = 1)
         THEN
            o_protectionupdated := -1;
         ELSE
            RAISE fieldsalreadypresent;
         END IF;
      ELSE
         o_protectionupdated := -1;
      END IF;

      IF (o_protectionupdated = -1)
      THEN
         UPDATE sak_memo_protection
            SET mep_competitor = i_mep_competitor,
                mep_comment = i_mep_comment
          --mep_update_count = NVL (mep_update_count, 0) + 1
          WHERE mep_mem_id = i_mep_mem_id AND mep_number = i_mep_number;

         -- AND NVL (mep_update_count, 0) = i_mep_update_count
         -- RETURNING mep_update_count
         --INTO l_flag;
         /*
           AUTHOR : Devashish/Shantanu,
           DATE : 30/jan/2014,
           Description : Update Count Functionality Modified
         */
         SELECT mep_update_count
           INTO l_flag
           FROM sak_memo_protection
          WHERE mep_mem_id = i_mep_mem_id AND mep_number = i_mep_number;

         IF (NVL (l_flag, 0) = NVL (i_mep_update_count, 0))
         THEN
            UPDATE sak_memo_protection
               SET mep_update_count = NVL (mep_update_count, 0) + 1
             WHERE mep_mem_id = i_mep_mem_id AND mep_number = i_mep_number;

            COMMIT;

            SELECT mep_update_count
              INTO o_protectionupdated
              FROM sak_memo_protection
             WHERE mep_mem_id = i_mep_mem_id AND mep_number = i_mep_number;
         ELSE
            ROLLBACK;
            raise_application_error (
               -20325,
               'Protection details are being modified by other user');
         END IF;
      /************************End Of the Update count Functionality*******************/
      /* IF (l_flag <> 0)
       THEN
          COMMIT;
          o_protectionupdated := l_flag;
       ELSE
          RAISE updatfailed;
       END IF;*/
      ELSE
         RAISE fieldsalreadypresent;
      END IF;
   EXCEPTION
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (
            -20378,
            'Competitor for the Deal Memo is already present.');
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20379, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20380, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_updtprotection;

   ------------------------------------- DELETE PROTECTION TAB PROCEDURE   --------------------------------------
   PROCEDURE prc_adm_cm_delprotection (
      i_mep_number          IN     sak_memo_protection.mep_number%TYPE,
      -- Protection primary key number
      i_mep_mem_id          IN     sak_memo_protection.mep_mem_id%TYPE,
      -- Sak Memo ID.
      i_mep_update_count    IN     sak_memo_protection.mep_update_count%TYPE,
      o_protectiondeleted      OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
   BEGIN
      o_protectiondeleted := -1;

      DELETE FROM sak_memo_protection
            WHERE     mep_mem_id = i_mep_mem_id
                  AND mep_number = i_mep_number
                  AND NVL (mep_update_count, 0) = i_mep_update_count;

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_protectiondeleted := 1;
      ELSE
         RAISE deldatfailed;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN deldatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20381, 'Data Not Deleted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20382, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_delprotection;

   ------------------------------------- DEFAULT PROTECTION PROCEDURE FOR PROTECTIONS TAB  --------------------------------------
   PROCEDURE prc_adm_cm_default_protection (
      i_mem_id                    IN     sak_memo.mem_id%TYPE,
      o_defaultprotectionresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      BEGIN
         DELETE FROM sak_memo_protection
               WHERE mep_mem_id = i_mem_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      COMMIT;

      OPEN o_defaultprotectionresult FOR
           SELECT DISTINCT mei_mem_id,
                           pde_competitor,
                           mec_description,
                           NULL "Comment"
             FROM sak_protection_default,
                  sak_allocation_detail,
                  sak_memo_item,
                  sak_memo_code
            WHERE     ald_mei_id = mei_id
                  AND mec_value = pde_competitor
                  AND mec_type = 'MEP_COMPETITOR'
                  AND mei_mem_id = i_mem_id
                  AND pde_chs_number = ald_chs_number
         ORDER BY pde_competitor;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20383, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_default_protection;

   ----------------------- FUNCTION TO CHECK PROTECTION EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_protectionexists (
      i_mep_mem_id       IN sak_memo_protection.mep_mem_id%TYPE,
      i_mep_competitor   IN sak_memo_protection.mep_competitor%TYPE)
      RETURN NUMBER
   AS
      flag   NUMBER;
   BEGIN
      flag := 0;

      SELECT COUNT (mep_number)
        INTO flag
        FROM sak_memo_protection
       WHERE mep_mem_id = i_mep_mem_id AND mep_competitor = i_mep_competitor;

      --AND NVL (mep_is_deleted, 'N') = 'N';
      RETURN flag;
   END fnc_adm_protectionexists;

   -------------------------------------- PROCEDURE TO VIEW MATERIALS  -----------------------------------------
   PROCEDURE prc_adm_cm_viewdeliverymat (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_dealmemoresult FOR
           SELECT mma_id,
                  com_short_name,
                  mma_item_class,
                  (SELECT mec_long_desc
                     FROM sak_memo_code
                    WHERE mec_type = 'MMA_ITEM_CLASS'
                          AND mec_value = mma_item_class)
                     mma_item_class_desc,
                  mma_bcast_type,
                  (SELECT mec_long_desc
                     FROM sak_memo_code
                    WHERE mec_type = 'MMA_BCAST_TYPE'
                          AND mec_value = mma_bcast_type)
                     mma_bcast_type_desc,
                  mma_sound_type,
                  (SELECT mec_long_desc
                     FROM sak_memo_code
                    WHERE mec_type = 'MMA_SOUND_TYPE'
                          AND mec_value = mma_sound_type)
                     mma_sound_type_desc,
                  mma_item,
                  (SELECT mec_long_desc
                     FROM sak_memo_code
                    WHERE mec_type = 'MMA_ITEM' AND mec_value = mma_item)
                     mma_item_desc,
                  mma_comment,
                  --   NVL (mma_is_deleted, 'N') mma_is_deleted,
                  NVL (mma_update_count, 0) mma_update_count
             FROM sak_memo_materials, fid_company
            WHERE mma_com_number = com_number AND mma_mem_id = i_mem_id
         --AND NVL (mma_is_deleted, 'N') = 'N'
         ORDER BY com_short_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20384, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_viewdeliverymat;

   -------------------------------------- PROCEDURE TO ADD MATERIALS  -----------------------------------------
   PROCEDURE prc_adm_cm_adddeliverymat (
      i_mma_mem_id       IN     sak_memo_materials.mma_mem_id%TYPE,
      i_com_short_name   IN     fid_company.com_short_name%TYPE,
      i_mma_bcast_type   IN     sak_memo_materials.mma_bcast_type%TYPE,
      i_mma_item_class   IN     sak_memo_materials.mma_item_class%TYPE,
      i_mma_item         IN     sak_memo_materials.mma_item%TYPE,
      i_mma_sound_type   IN     sak_memo_materials.mma_sound_type%TYPE,
      i_mma_comment      IN     sak_memo_materials.mma_comment%TYPE,
      i_mma_entry_oper   IN     sak_memo_materials.mma_entry_oper%TYPE,
      o_mma_id              OUT sak_memo_materials.mma_id%TYPE)
   AS
      fieldsalreadypresent   EXCEPTION;
      l_com_number           NUMBER;
      l_flag                 NUMBER := 0;
      l_o_flag               NUMBER;
      l_message              VARCHAR2 (200);
      norights               EXCEPTION;
   BEGIN
      /*pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_mma_mem_id,
                                                          i_mma_entry_oper,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF;*/
      BEGIN
         SELECT com_number
           INTO l_com_number
           FROM fid_company
          WHERE com_short_name = UPPER (i_com_short_name);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      /*IF (fnc_adm_materialexists (i_mma_mem_id,
                                  l_com_number,
                                  i_mma_bcast_type,
                                  i_mma_item_class,
                                  i_mma_item,
                                  i_mma_sound_type
                                 ) = 0
         )
      THEN*/
      o_mma_id := get_seq ('SEQ_MMA_ID');

      INSERT INTO sak_memo_materials (mma_id,
                                      mma_mem_id,
                                      mma_com_number,
                                      mma_bcast_type,
                                      mma_item_class,
                                      mma_item,
                                      mma_sound_type,
                                      mma_comment,
                                      mma_entry_oper,
                                      mma_entry_date,
                                      mma_update_count)
           VALUES (o_mma_id,
                   i_mma_mem_id,
                   l_com_number,
                   i_mma_bcast_type,
                   i_mma_item_class,
                   i_mma_item,
                   i_mma_sound_type,
                   i_mma_comment,
                   i_mma_entry_oper,
                   SYSDATE,
                   0);

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
      END IF;
   /*ELSE
      RAISE fieldsalreadypresent;
   END IF; */
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (
            -20385,
            'Materials with same property is already present.');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20386, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_adddeliverymat;

   -------------------------------------- PROCEDURE TO UPDATE MATERIALS  -----------------------------------------
   PROCEDURE prc_adm_cm_updtdeliverymat (
      i_mma_id             IN     sak_memo_materials.mma_id%TYPE,
      i_mma_mem_id         IN     sak_memo_materials.mma_mem_id%TYPE,
      i_com_short_name     IN     fid_company.com_short_name%TYPE,
      i_mma_bcast_type     IN     sak_memo_materials.mma_bcast_type%TYPE,
      i_mma_item_class     IN     sak_memo_materials.mma_item_class%TYPE,
      i_mma_item           IN     sak_memo_materials.mma_item%TYPE,
      i_mma_sound_type     IN     sak_memo_materials.mma_sound_type%TYPE,
      i_mma_comment        IN     sak_memo_materials.mma_comment%TYPE,
      i_mma_update_count   IN     sak_memo_materials.mma_update_count%TYPE,
      o_materialupdated       OUT NUMBER)
   AS
      l_flag                 NUMBER;
      l_count                NUMBER := -1;
      l_com_number           NUMBER;
      fieldsalreadypresent   EXCEPTION;
      updatfailed            EXCEPTION;
   BEGIN
      BEGIN
         SELECT com_number
           INTO l_com_number
           FROM fid_company
          WHERE com_short_name = UPPER (i_com_short_name);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      /*IF (fnc_adm_materialexists (i_mma_mem_id,
                                  l_com_number,
                                  i_mma_bcast_type,
                                  i_mma_item_class,
                                  i_mma_item,
                                  i_mma_sound_type
                                 ) > 0
         )
      THEN
         SELECT COUNT (mma_id)
           INTO l_count
           FROM sak_memo_materials
          WHERE mma_mem_id = i_mma_mem_id
            AND mma_com_number = l_com_number
            AND mma_bcast_type = i_mma_bcast_type
            AND mma_item_class = i_mma_item_class
            AND mma_item = i_mma_item
            AND mma_sound_type = i_mma_sound_type
            AND mma_id = i_mma_id;

         IF (l_count = 1)
         THEN
            o_materialupdated := -1;
         ELSE
            RAISE fieldsalreadypresent;
         END IF;
      ELSE
         o_materialupdated := -1;
      END IF;

      IF (o_materialupdated = -1)
      THEN*/
      UPDATE sak_memo_materials
         SET mma_com_number = l_com_number,
             mma_bcast_type = i_mma_bcast_type,
             mma_item_class = i_mma_item_class,
             mma_item = i_mma_item,
             mma_sound_type = i_mma_sound_type,
             mma_comment = i_mma_comment
       --mma_update_count = NVL (mma_update_count, 0) + 1
       WHERE mma_id = i_mma_id AND mma_mem_id = i_mma_mem_id;

      --AND NVL (mma_update_count, 0) = i_mma_update_count
      --RETURNING mma_update_count
      --INTO l_flag;
      /*
        AUTHOR : Devashish/Shantanu,
        DATE : 30/jan/2014,
        Description : Update Count Functionality Modified
      */
      SELECT mma_update_count
        INTO l_flag
        FROM sak_memo_materials
       WHERE mma_id = i_mma_id AND mma_mem_id = i_mma_mem_id;

      IF (NVL (l_flag, 0) = NVL (i_mma_update_count, 0))
      THEN
         UPDATE sak_memo_materials
            SET mma_update_count = NVL (mma_update_count, 0) + 1
          WHERE mma_id = i_mma_id AND mma_mem_id = i_mma_mem_id;

         COMMIT;

         SELECT mma_update_count
           INTO o_materialupdated
           FROM sak_memo_materials
          WHERE mma_id = i_mma_id AND mma_mem_id = i_mma_mem_id;
      ELSE
         ROLLBACK;
         raise_application_error (
            -20325,
            'Delievery details are being modified by other user');
      END IF;
   /************************End Of the Update count Functionality*******************/

   /*IF (l_flag <> 0)
      THEN
         COMMIT;
         o_materialupdated := l_flag;
      ELSE
         RAISE updatfailed;
      END IF;*/
   /*ELSE
      RAISE fieldsalreadypresent;
   END IF;*/
   EXCEPTION
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (
            -20387,
            'Materials with same property is already present.');
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20388, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20389, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_updtdeliverymat;

   -------------------------------------- PROCEDURE TO DELETE MATERIALS  -----------------------------------------
   PROCEDURE prc_adm_cm_deletedeliverymat (
      i_mma_id             IN     sak_memo_materials.mma_id%TYPE,
      i_mma_mem_id         IN     sak_memo_materials.mma_mem_id%TYPE,
      i_mma_update_count   IN     sak_memo_materials.mma_update_count%TYPE,
      o_materialdeleted       OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
   BEGIN
      o_materialdeleted := -1;

      DELETE FROM sak_memo_materials
            WHERE     mma_id = i_mma_id
                  AND mma_mem_id = i_mma_mem_id
                  AND NVL (mma_update_count, 0) = i_mma_update_count;

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_materialdeleted := 1;
      ELSE
         RAISE deldatfailed;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN deldatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20390, 'Data Not Deleted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20391, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_deletedeliverymat;

   ----------------------- FUNCTION TO CHECK MATERAIL EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_materialexists (
      i_mma_mem_id       IN sak_memo_materials.mma_mem_id%TYPE,
      i_mma_com_number   IN sak_memo_materials.mma_com_number%TYPE,
      i_mma_bcast_type   IN sak_memo_materials.mma_bcast_type%TYPE,
      i_mma_item_class   IN sak_memo_materials.mma_item_class%TYPE,
      i_mma_item         IN sak_memo_materials.mma_item%TYPE,
      i_mma_sound_type   IN sak_memo_materials.mma_sound_type%TYPE)
      RETURN NUMBER
   AS
      flag   NUMBER;
   BEGIN
      flag := 0;

      SELECT COUNT (mma_id)
        INTO flag
        FROM sak_memo_materials
       WHERE     mma_mem_id = i_mma_mem_id
             AND mma_com_number = i_mma_com_number
             AND mma_bcast_type = i_mma_bcast_type
             AND mma_item_class = i_mma_item_class
             AND mma_item = i_mma_item
             AND mma_sound_type = i_mma_sound_type;

      RETURN flag;
   END fnc_adm_materialexists;

   -------------------------------------- PROCEDURE TO VIEW PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_viewpayment (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_dealmemoresult FOR
           SELECT mpy_number,
                  mpy_mem_id,
                  mpy_sort_order,
                  mpy_pay_month,
                  TRUNC (mpy_pct_pay, 4) mpy_pct_pay,
                  TRUNC (mpy_amount, 4) mpy_amount,
                  mpy_code,
                  mpy_due,
                  mpy_comment,
                  NVL (mpy_update_count, 0) AS mpy_update_count,
                  mpy_islastmonth
             --FIN29: Abhinay_20140328 : Enter payment record for the last month in Payment Plan v1.0
             -- NVL (mpy_is_deleted, 'N') AS mpy_is_deleted
             FROM sak_memo_payment
            WHERE sak_memo_payment.mpy_mem_id = i_mem_id
         ORDER BY mpy_mem_id, mpy_sort_order;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20392, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_viewpayment;

   -------------------------------------- PROCEDURE TO ADD PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_addpayment (
      i_mpy_amount        IN     sak_memo_payment.mpy_amount%TYPE,
      i_mpy_cur_code      IN     sak_memo_payment.mpy_cur_code%TYPE,
      i_mpy_code          IN     sak_memo_payment.mpy_code%TYPE,
      i_mpy_mem_id        IN     sak_memo_payment.mpy_mem_id%TYPE,
      i_mpy_sort_order    IN     sak_memo_payment.mpy_sort_order%TYPE,
      i_mpy_due           IN     sak_memo_payment.mpy_due%TYPE,
      i_mpy_comment       IN     sak_memo_payment.mpy_comment%TYPE,
      i_mpy_pct_pay       IN     sak_memo_payment.mpy_pct_pay%TYPE,
      i_mpy_pay_month     IN     sak_memo_payment.mpy_pay_month%TYPE,
      i_mpy_entry_oper    IN     sak_memo_payment.mpy_entry_oper%TYPE,
      i_mpy_islastmonth   IN     sak_memo_payment.mpy_islastmonth%TYPE,
      -- FIN29: Abhinay_20140328 : Enter payment record for the last month in Payment Plan v1.0
      o_mpy_number           OUT sak_memo_payment.mpy_number%TYPE)
   AS
      l_flag                 NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
      percentexceeded        EXCEPTION;
      amountexceeded         EXCEPTION;
      l_paypercentsum        NUMBER := 0;
      l_payamountsum         NUMBER := 0;
      l_dmamountsum          NUMBER := 0;
      l_o_flag               NUMBER;
      l_message              VARCHAR2 (200);
      norights               EXCEPTION;
   BEGIN
      /*pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_mpy_mem_id,
                                                          i_mpy_entry_oper,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF;*/
      IF (fnc_adm_paymentexists (i_mpy_mem_id, i_mpy_sort_order) = 0)
      THEN
         BEGIN
            SELECT SUM (mpy_pct_pay)
              INTO l_paypercentsum
              FROM sak_memo_payment
             WHERE mpy_mem_id = i_mpy_mem_id;

            SELECT SUM (mpy_amount)
              INTO l_payamountsum
              FROM sak_memo_payment
             WHERE mpy_mem_id = i_mpy_mem_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_paypercentsum := 0;
               l_payamountsum := 0;
               NULL;
         END;

         BEGIN
            SELECT mem_con_price
              INTO l_dmamountsum
              FROM sak_memo
             WHERE mem_id = i_mpy_mem_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_dmamountsum := 0;
               NULL;
         END;

         l_paypercentsum := l_paypercentsum + TRUNC (i_mpy_pct_pay, 4);
         l_payamountsum := l_payamountsum + TRUNC (i_mpy_amount, 4);

         IF (l_payamountsum <> l_dmamountsum)
         THEN
            -- Added as if Amount is not equal then not necessary to check for
            IF (l_paypercentsum > 100)
            THEN
               RAISE percentexceeded;
            END IF;
         END IF;

         IF (l_payamountsum > l_dmamountsum)
         THEN
            RAISE amountexceeded;
         END IF;

         o_mpy_number := get_seq ('SEQ_MPY_NUMBER');

         INSERT INTO sak_memo_payment (mpy_number,
                                       mpy_amount,
                                       mpy_cur_code,
                                       mpy_code,
                                       mpy_mem_id,
                                       mpy_sort_order,
                                       mpy_due,
                                       mpy_comment,
                                       mpy_pct_pay,
                                       mpy_pay_month,
                                       mpy_entry_oper,
                                       mpy_islastmonth,
                                       -- FIN29: Abhinay_20140328 : Enter payment record for the last month in Payment Plan v1.0
                                       mpy_entry_date,
                                       mpy_update_count)
              VALUES (o_mpy_number,
                      TRUNC (i_mpy_amount, 4),
                      i_mpy_cur_code,
                      i_mpy_code,
                      i_mpy_mem_id,
                      i_mpy_sort_order,
                      i_mpy_due,
                      i_mpy_comment,
                      TRUNC (i_mpy_pct_pay, 4),
                      i_mpy_pay_month,
                      i_mpy_entry_oper,
                      i_mpy_islastmonth,
                      -- FIN29: Abhinay_20140328 : Enter payment record for the last month in Payment Plan v1.0
                      SYSDATE,
                      0);

         l_flag := SQL%ROWCOUNT;

         IF (l_flag <> 0)
         THEN
            COMMIT;
         END IF;
      ELSE
         RAISE fieldsalreadypresent;
      END IF;
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (-20393,
                                  'Order Number for Payment Already Exist.');
      WHEN percentexceeded
      THEN
         ROLLBACK;
         raise_application_error (
            -20394,
            'Payment Percent cannot be greater than 100 percent.');
      WHEN amountexceeded
      THEN
         ROLLBACK;
         raise_application_error (
            -20394,
            'Payment Amount cannot be greater than Deal Memo value.');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_addpayment;

   ------------------------------------- PROCEDURE TO UPDATE PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_updtpayment (
      i_mpy_number         IN     sak_memo_payment.mpy_number%TYPE,
      i_mpy_mem_id         IN     sak_memo_payment.mpy_mem_id%TYPE,
      i_mpy_amount         IN     sak_memo_payment.mpy_amount%TYPE,
      i_mpy_cur_code       IN     sak_memo_payment.mpy_cur_code%TYPE,
      i_mpy_code           IN     sak_memo_payment.mpy_code%TYPE,
      i_mpy_sort_order     IN     sak_memo_payment.mpy_sort_order%TYPE,
      i_mpy_due            IN     sak_memo_payment.mpy_due%TYPE,
      i_mpy_comment        IN     sak_memo_payment.mpy_comment%TYPE,
      i_mpy_pct_pay        IN     sak_memo_payment.mpy_pct_pay%TYPE,
      i_mpy_pay_month      IN     sak_memo_payment.mpy_pay_month%TYPE,
      i_mpy_entry_oper     IN     sak_memo_payment.mpy_entry_oper%TYPE,
      i_mpy_islastmonth    IN     sak_memo_payment.mpy_islastmonth%TYPE,
      -- FIN29: Abhinay_20140328 : Enter payment record for the last month in Payment Plan v1.0
      i_mpy_update_count   IN     sak_memo_payment.mpy_update_count%TYPE,
      o_paymentupdated        OUT NUMBER)
   AS
      l_flag                 NUMBER;
      l_count                NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
      updatfailed            EXCEPTION;
   BEGIN
      IF (fnc_adm_paymentexists (i_mpy_mem_id, i_mpy_sort_order) > 0)
      THEN
         BEGIN
            SELECT COUNT (mpy_number)
              INTO l_count
              FROM sak_memo_payment
             WHERE     mpy_mem_id = i_mpy_mem_id
                   AND mpy_sort_order = i_mpy_sort_order
                   AND mpy_number = i_mpy_number;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         IF (l_count = 1)
         THEN
            o_paymentupdated := -1;
         ELSE
            RAISE fieldsalreadypresent;
         END IF;
      ELSE
         o_paymentupdated := -1;
      END IF;

      IF (o_paymentupdated = -1)
      THEN
         UPDATE sak_memo_payment
            SET mpy_amount = TRUNC (i_mpy_amount, 4),
                mpy_cur_code = i_mpy_cur_code,
                mpy_code = i_mpy_code,
                mpy_sort_order = i_mpy_sort_order,
                mpy_due = i_mpy_due,
                mpy_comment = i_mpy_comment,
                mpy_pct_pay = TRUNC (i_mpy_pct_pay, 4),
                mpy_pay_month = i_mpy_pay_month,
                mpy_islastmonth = i_mpy_islastmonth
          -- FIN29: Abhinay_20140328 : Enter payment record for the last month in Payment Plan v1.0
          --mpy_update_count = NVL (mpy_update_count, 0) + 1
          WHERE mpy_mem_id = i_mpy_mem_id AND mpy_number = i_mpy_number;

         --AND NVL (mpy_update_count, 0) = i_mpy_update_count
         --RETURNING mpy_update_count
         --INTO l_flag;
         /*
          AUTHOR : Devashish/Shantanu,
          DATE : 30/jan/2014,
          Description : Update Count Functionality Modified
         */
         SELECT mpy_update_count
           INTO l_flag
           FROM sak_memo_payment
          WHERE mpy_mem_id = i_mpy_mem_id AND mpy_number = i_mpy_number;

         IF (NVL (l_flag, 0) = NVL (i_mpy_update_count, 0))
         THEN
            UPDATE sak_memo_payment
               SET mpy_update_count = NVL (mpy_update_count, 0) + 1
             WHERE mpy_mem_id = i_mpy_mem_id AND mpy_number = i_mpy_number;

            COMMIT;

            SELECT mpy_update_count
              INTO o_paymentupdated
              FROM sak_memo_payment
             WHERE mpy_mem_id = i_mpy_mem_id AND mpy_number = i_mpy_number;
         ELSE
            ROLLBACK;
            raise_application_error (
               -20017,
               'Payment details are being changed by other user');
         END IF;
      /************************End Of the Update count Functionality*******************/
      /*IF (l_flag <> 0)
      THEN
         COMMIT;
         o_paymentupdated := l_flag;
      ELSE
         RAISE updatfailed;
      END IF;*/
      ELSE
         RAISE fieldsalreadypresent;
      END IF;
   EXCEPTION
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (-20395,
                                  'Order Number for Payment Already Exist.');
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20396, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20397, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_updtpayment;

   ------------------------------------- PROCEDURE TO DELETE PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_deletepayment (
      i_mpy_number         IN     sak_memo_payment.mpy_number%TYPE,
      i_mpy_mem_id         IN     sak_memo_payment.mpy_mem_id%TYPE,
      i_mpy_update_count   IN     sak_memo_payment.mpy_update_count%TYPE,
      i_mpy_entry_oper     IN     sak_memo_payment.MPY_ENTRY_OPER%TYPE,
      o_paymentdeleted        OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
      l_count        NUMBER;
      l_entry_oper   sak_memo_payment.MPY_ENTRY_OPER%TYPE;
   BEGIN
      o_paymentdeleted := -1;

      /*   select ALD_MIN_GUA_FLAG
           into l_gua_flag
           from sak_allocation_detail
         where ald_mei_id in(select mei_id from sak_memo_item where mei_mem_id = i_mpy_mem_id );

         Delete x_dm_mg_pay_plan where dmgp_dm_number = i_mpy_mem_id;
         */

      SELECT pkg_cm_username.SetUserName (i_mpy_entry_oper)
        INTO l_entry_oper
        FROM DUAL;


      BEGIN
         /* Warner Payment :Rashmi Tijare :21-07-2015 :Start*/
         DELETE x_dm_mg_pay_plan
          WHERE dmgp_dm_number = i_mpy_mem_id;

         /* Warner Payment :Rashmi Tijare :21-07-2015 :End*/
         DELETE FROM sak_memo_payment
               WHERE     mpy_mem_id = i_mpy_mem_id
                     AND mpy_number = i_mpy_number
                     AND NVL (mpy_update_count, 0) = i_mpy_update_count;
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
   END prc_adm_cm_deletepayment;

   ----------------------- FUNCTION TO CHECK PAYMENT EXISTS FOR SAK MEMO --------------------------------
   FUNCTION fnc_adm_paymentexists (
      i_mpy_mem_id       IN sak_memo_payment.mpy_mem_id%TYPE,
      i_mpy_sort_order   IN sak_memo_payment.mpy_sort_order%TYPE)
      RETURN NUMBER
   AS
      flag   NUMBER;
   BEGIN
      flag := 0;

      SELECT COUNT (mpy_number)
        INTO flag
        FROM sak_memo_payment
       WHERE mpy_mem_id = i_mpy_mem_id AND mpy_sort_order = i_mpy_sort_order;

      RETURN flag;
   END fnc_adm_paymentexists;

   ---------------------------------------------------- SEARCH SERIES PROCEDURE --------------------------------------------
   PROCEDURE prc_adm_cm_searchseries (
      i_mem_id         IN     sak_memo.mem_id%TYPE,
      i_mem_type       IN     sak_memo.mem_type%TYPE,
      i_ser_number     IN     fid_series.ser_number%TYPE,
      o_seasondata        OUT pkg_adm_cm_dealmemo.cursor_data,
      o_episodesdata      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
      l_seriesnumber    NUMBER;
      l_nextepinumber   NUMBER;
      l_otherprice      NUMBER;
      l_val             NUMBER;
      l_sportgenre      VARCHAR2 (50);
      l_subgenre        VARCHAR2 (50);
      l_event           VARCHAR2 (50);
      l_first_price     NUMBER := 0;
      l_total_price     NUMBER := 0;
      l_epi_count       NUMBER:=0;
   BEGIN
      BEGIN
         SELECT ser_parent_number,SER_SEA_EPI_COUNT
           INTO l_seriesnumber,l_epi_count
           FROM fid_series
          WHERE ser_number = i_ser_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_seriesnumber := 0;
            l_epi_count := 0;
      END;

      IF (l_seriesnumber = 0)
      THEN
         -- When Series is linked.
         OPEN o_seasondata FOR
              SELECT c.ser_number series_ser_number,
                     c.ser_title series_title,
                     b.ser_number season_ser_number,
                     b.ser_title season_title,
                     /* PB (CR P3) : Mangesh_20120910 : Added a new field season number*/
                     b.ser_sea_number season_number,
                     TO_CHAR (mei_first_episode_price) first_episode_price,
                     TO_CHAR (mei_total_price) mei_total_price,
                     NVL (MIN (a.gen_epi_number), 0) first_epi_number,
                     c.ser_svod_rights
                FROM fid_series b,
                     fid_series c,
                     fid_general a,
                     sak_memo_item
               WHERE     c.ser_number = b.ser_parent_number(+)
                     AND b.ser_number = a.gen_ser_number(+)
                     AND mei_gen_refno = i_ser_number
                     AND c.ser_number = i_ser_number
                     AND mei_mem_id = i_mem_id
            GROUP BY c.ser_number,
                     c.ser_title,
                     b.ser_number,
                     b.ser_title,
                     mei_first_episode_price,
                     mei_total_price,
                     b.ser_sea_number,
					 c.ser_svod_rights;
      --a.gen_epi_number; // Group by commented by Ajit to fix multiple entries of Season Title
      ELSE
         BEGIN
            SELECT mei_first_episode_price, mei_total_price
              INTO l_first_price, l_total_price
              FROM sak_memo_item
             WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_ser_number;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;

         -- When Season is Linked
         OPEN o_seasondata FOR
              SELECT t.series_ser_number,
                     t.series_title,
                     t.season_ser_number,
                     /* PB (CR P3) : Mangesh_20120910 : Added a new field season number*/
                     t.season_title,
                     t.season_number,
                     TO_CHAR (mei_first_episode_price) first_episode_price,
                     TO_CHAR (mei_total_price) mei_total_price,
                     t.first_epi_number,
                     t.ser_svod_rights
                FROM (  SELECT c.ser_number series_ser_number,
                               c.ser_title series_title,
                               b.ser_number season_ser_number,
                               b.ser_title season_title,
                               /* PB (CR P3) : Mangesh_20120910 : Added a new field season number*/
                               b.ser_sea_number season_number,
                               NVL (MIN (a.gen_epi_number), 0) first_epi_number,
                               b.ser_svod_rights
                          FROM fid_series b, fid_series c, fid_general a
                         WHERE     c.ser_number = b.ser_parent_number(+)
                               AND b.ser_number = a.gen_ser_number(+)
                               AND c.ser_number = l_seriesnumber
                      GROUP BY c.ser_number,
                               c.ser_title,
                               b.ser_number,
                               b.ser_title,
                               b.ser_sea_number --,A.gen_epi_number // Group by commented by Ajit to fix multiple entries of Season Title
                              ,b.ser_svod_rights



			       ) t,
                     sak_memo_item,
                     fid_general d
               WHERE     t.season_ser_number = d.gen_ser_number(+)
                     AND t.season_ser_number = mei_gen_refno(+)
                     AND mei_mem_id = i_mem_id
                     AND mei_gen_refno = i_ser_number
            GROUP BY t.series_ser_number,
                     t.series_title,
                     t.season_ser_number,
                     t.season_title,
                     t.season_number,
                     t.first_epi_number,
                     t.season_title,
                     t.season_number,
                     mei_first_episode_price,
                     mei_total_price,
                     t.ser_svod_rights
            UNION
              SELECT c.ser_number series_ser_number,
                     c.ser_title series_title,
                     b.ser_number season_ser_number,
                     b.ser_title season_title,
                     /* PB (CR P3) : Mangesh_20120910 : Added a new field season number*/
                     b.ser_sea_number season_number,
                     TO_CHAR (l_first_price) AS first_episode_price,
                     TO_CHAR (l_total_price) AS mei_total_price,
                     NVL (MIN (a.gen_epi_number), 0) first_epi_number,
                     b.ser_svod_rights
                FROM fid_series b, fid_series c, fid_general a
               WHERE     c.ser_number = b.ser_parent_number(+)
                     AND b.ser_number = a.gen_ser_number(+)
                     AND c.ser_number = l_seriesnumber
                     AND b.ser_number <> i_ser_number
            GROUP BY c.ser_number,
                     c.ser_title,
                     b.ser_number,
                     b.ser_title,
                     b.ser_sea_number,
                     l_first_price,
                     l_total_price --a.gen_epi_number // Group by commented by Ajit to fix multiple entries of Season Title
                     ,b.ser_svod_rights;
      END IF;

      IF (l_seriesnumber = 0)
      THEN
         l_seriesnumber := i_ser_number;
      END IF;

      OPEN o_episodesdata FOR
           SELECT DISTINCT
                  c.ser_number series_ser_number,
                  c.ser_title series_title,
                  b.ser_number season_ser_number,
                  b.ser_title season_title,
                  a.gen_refno gen_refno,
                  a.gen_epi_number episode_number,
                  a.gen_title_working episode_working_title,
                  a.gen_title episode_title,
                  -- a.gen_duration_c gen_duration,
                  CASE
                     WHEN a.gen_duration_c = '::' THEN '00:00:00'
                     ELSE a.gen_duration_c
                  END
                     gen_duration,
                  a.gen_running_order runningorder,
                  -- Abhinay_20140120 : As per requirement on Deal Memo Maintenance
                  a.gen_category gen_category,
                  a.gen_subgenre gen_subgenre,
                  a.gen_event gen_event,
                  d.fgl_venue venue,
                  d.fgl_location LOCATION,
                  d.fgl_live_date live_date,
                  d.fgl_time live_time,
                  NVL (a.gen_update_count, 0) gen_update_count,
                  --
                  --NVL (b.ser_update_count, 0) ser_update_count,

                  --
                  MAX (e.lic_mem_number) lic_mem_number,
                  NVL (a.gen_relic, 'N') gen_relic,
                  a.gen_comment,
                  a.gen_svod_rights,
                  --added by milind trim function and one spce for Seson Episode number_30_06_2016
                 DECODE(nvl(a.gen_sea_epi_update,'N'),'Y',a.gen_sea_epi_no,trim(a.gen_sea_epi_no)||' '||(select distinct SER_SEA_EPI_COUNT from fid_series where ser_number =a.gen_ser_number)) gen_sea_epi_no,
                a.gen_sea_epi_update--- added by rashmi 14-06-2016--- added by rashmi 14-06-2016---added by rashmi15-06-2016
             FROM fid_general a,
                  fid_series b,
                  fid_series c,
                  fid_gen_live d,
                  fid_license e
            WHERE     b.ser_number = a.gen_ser_number(+)
                  AND c.ser_number = b.ser_parent_number(+)
                  AND a.gen_refno = d.fgl_gen_refno(+)
                  AND a.gen_refno = e.lic_gen_refno(+)
                  AND c.ser_number = l_seriesnumber
         GROUP BY c.ser_number,
                  c.ser_title,
                  b.ser_number,
                  b.ser_title,
                  a.gen_refno,
                  a.gen_epi_number,
                  a.gen_title_working,
                  a.gen_title,
                  a.gen_duration_c,
                  a.gen_running_order,
                  -- Abhinay_20140120 : As per requirement on Deal Memo Maintenance
                  a.gen_category,
                  a.gen_subgenre,
                  a.gen_event,
                  d.fgl_venue,
                  d.fgl_location,
                  d.fgl_live_date,
                  d.fgl_time,
                  a.gen_update_count,
                  a.gen_relic,
                  a.gen_comment,
                  a.gen_svod_rights,
                  a.gen_sea_epi_no,
                  a.gen_sea_epi_update,
                  a.gen_ser_number
         ORDER BY a.gen_epi_number;
   --b.ser_update_count;
   /*OPEN o_seasondata FOR
      SELECT  t.series_ser_number, t.series_title, t.season_ser_number,
               t.season_title, t.first_epi_number,
               mei_first_episode_price first_episode_price,
               mei_total_price,
               (MAX (d.gen_epi_number) + 1) next_epi_number,
               MAX (d.gen_duration_c) DURATION
          FROM (SELECT   c.ser_number series_ser_number,
                         c.ser_title series_title,
                         b.ser_number season_ser_number,
                         b.ser_title season_title,
                         NVL (MIN (a.gen_epi_number), 0) first_epi_number
                    FROM fid_series b, fid_series c, fid_general a
                   WHERE c.ser_number = b.ser_parent_number(+)
                     AND b.ser_number = a.gen_ser_number(+)
                     AND c.ser_number = l_seriesnumber
                GROUP BY c.ser_number,
                         c.ser_title,
                         b.ser_number,
                         b.ser_title) t,
               sak_memo_item,
               fid_general d
         WHERE t.season_ser_number = d.gen_ser_number(+)
               AND t.season_ser_number = mei_gen_refno(+)
               --and mei_mem_id is null
      GROUP BY t.series_ser_number,
               t.series_title,
               t.season_ser_number,
               t.season_title,
               t.first_epi_number,
               mei_first_episode_price,
               mei_total_price
           having count(t.season_title) = 1
     union
     SELECT  t.series_ser_number, t.series_title, t.season_ser_number,
               t.season_title, t.first_epi_number,
               mei_first_episode_price first_episode_price,
               mei_total_price,
               (MAX (d.gen_epi_number) + 1) next_epi_number,
               MAX (d.gen_duration_c) DURATION
          FROM (SELECT   c.ser_number series_ser_number,
                         c.ser_title series_title,
                         b.ser_number season_ser_number,
                         b.ser_title season_title,
                         NVL (MIN (a.gen_epi_number), 0) first_epi_number
                    FROM fid_series b, fid_series c, fid_general a
                   WHERE c.ser_number = b.ser_parent_number(+)
                     AND b.ser_number = a.gen_ser_number(+)
                     AND c.ser_number = l_seriesnumber
                GROUP BY c.ser_number,
                         c.ser_title,
                         b.ser_number,
                         b.ser_title) t,
               sak_memo_item,
               fid_general d
         WHERE t.season_ser_number = d.gen_ser_number(+)
               AND t.season_ser_number = mei_gen_refno(+)
               and mei_mem_id = i_mem_id
      GROUP BY t.series_ser_number,
               t.series_title,
               t.season_ser_number,
               t.season_title,
               t.first_epi_number,
               mei_first_episode_price,
               mei_total_price;*/

   --mei_update_count,d.gen_update_count;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20400, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_searchseries;

   ------------------------------------------------- GENERATE SERIES ----------------------------------------------------------
   PROCEDURE prc_adm_cm_generateepi (
      -- format of title
      i_serieschk         IN     CHAR,
      i_seriestitle       IN     VARCHAR2,
      i_seasonchk         IN     CHAR,
      i_seasontitle       IN     VARCHAR2,
      i_addtextchk        IN     CHAR,
      i_addtexttitle      IN     VARCHAR2,
      i_epichk            IN     CHAR,
      -- format of working title
      i_serieschk_wt      IN     CHAR,
      i_seasonchk_wt      IN     CHAR,
      i_addtextchk_wt     IN     CHAR,
      i_addtexttitle_wt   IN     VARCHAR2,
      i_epichk_wt         IN     CHAR,
      i_seasonnumber      IN     NUMBER,
      i_epi_count         IN     NUMBER,
      i_duration          IN     VARCHAR2,
      i_sporttype         IN     VARCHAR2,
      i_subgenre          IN     VARCHAR2,
      i_eventtype         IN     VARCHAR2,
      i_first_epi         IN     NUMBER,
      o_episodesdata         OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
      epexist         NUMBER := -1;
      firstepiexist   NUMBER := -1;
      minepi          NUMBER := -1;
      runord          NUMBER := -1;
      -- Abhinay 6Feb2014 : RunningOrder implementation for Scheduler
      countrec        NUMBER := 1;
      e_title         VARCHAR2 (1000);
      e_numbers       VARCHAR2 (100);
      e_title_wt      VARCHAR2 (100);
      e_numbers_wt    VARCHAR2 (100);
      v_ret           t_epi_table;
      l_sea_epi       VARCHAR2(70);
      l_season_no     varchar2(100);
      e_sea_number    varchar2(100);
      l_count        number  ;
      l_epi_count       number :=0;
   BEGIN
      v_ret := t_epi_table ();

      BEGIN
         SELECT COUNT (gen_epi_number)
           INTO epexist
           FROM fid_general
          WHERE gen_ser_number = i_seasonnumber;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;




	   BEGIN
          select ser_Sea_number
          into l_season_no
          from fid_series where
          ser_number = i_seasonnumber;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF epexist > 0
      THEN
         ---
         BEGIN
            SELECT COUNT (gen_epi_number)
              INTO firstepiexist
              FROM fid_general
             WHERE gen_ser_number = i_seasonnumber
                   AND gen_epi_number = i_first_epi;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         IF firstepiexist = 0
         THEN
            minepi := i_first_epi;
         ELSE
            ---
            BEGIN
               SELECT MAX (gen_epi_number)
                 INTO minepi
                 FROM fid_general
                WHERE gen_ser_number = i_seasonnumber;

               minepi := minepi + 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         ---
         END IF;
      ---
      ELSE
         -- minepi := 1;
         minepi := i_first_epi;
      END IF;

      /* Abhinay 6Feb2014 : RunningOrder implementation for Scheduler */
      BEGIN
         SELECT NVL (MAX (gen_running_order), 0)
           INTO runord
           FROM fid_general
          WHERE gen_ser_number = i_seasonnumber;

         runord := runord + 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      /* Abhinay 6Feb2014 : END */

      -- format for title
      IF (i_serieschk = 'Y' OR i_serieschk = 'y')
      THEN
         e_title := e_title || ' ' || i_seriestitle;
      END IF;

      IF (i_seasonchk = 'Y' OR i_seasonchk = 'y')
      THEN
         e_title := e_title || ' ' || i_seasontitle;
      END IF;

      IF (i_addtextchk = 'Y' OR i_addtextchk = 'y')
      THEN
         e_title := e_title || ' ' || i_addtexttitle;
      END IF;

      -- format for working title
      IF (i_serieschk_wt = 'Y' OR i_serieschk_wt = 'y')
      THEN
         e_title_wt := e_title_wt || ' ' || i_seriestitle;
      END IF;

      IF (i_seasonchk_wt = 'Y' OR i_seasonchk_wt = 'y')
      THEN
         e_title_wt := e_title_wt || ' ' || i_seasontitle;
      END IF;

      IF (i_addtextchk_wt = 'Y' OR i_addtextchk_wt = 'y')
      THEN
         e_title_wt := e_title_wt || ' ' || i_addtexttitle_wt;
      END IF;

      e_title := TRIM (e_title);
      e_title_wt := TRIM (e_title_wt);

      --while COUNTREC <= i_epi_count loop
      FOR countrec IN 1 .. i_epi_count
      LOOP
         --  insert into A value
         --  select MINEPI,i_seriestext||i_seasontext from dual;
         -- commit;
         IF (i_epichk = 'Y' OR i_epichk = 'y')
         THEN
            e_numbers := '';
            e_sea_number:='';

            IF LENGTH (minepi) = 1
            THEN
               e_numbers := ('000' || minepi);
               e_sea_number:= minepi;
            ELSE
               IF LENGTH (minepi) = 2
               THEN
                  e_numbers := ('00' || minepi);
                  e_sea_number:=minepi;
               ELSE
                  IF LENGTH (minepi) = 3
                  THEN
                     e_numbers := ('0' || minepi);
                     e_sea_number:= minepi;
                  ELSE
                     e_numbers := (minepi);
                     e_sea_number:= minepi;
                  END IF;
               END IF;
            END IF;
         --E_TITLE := E_TITLE || ' ' || E_NUMBERS;
         END IF;

         IF (i_epichk_wt = 'Y' OR i_epichk_wt = 'y')
         THEN
            e_numbers_wt := '';

            IF LENGTH (minepi) = 1
            THEN
               e_numbers_wt := ('000' || minepi);
            ELSE
               IF LENGTH (minepi) = 2
               THEN
                  e_numbers_wt := ('00' || minepi);
               ELSE
                  IF LENGTH (minepi) = 3
                  THEN
                     e_numbers_wt := ('0' || minepi);
                  ELSE
                     e_numbers_wt := (minepi);
                  END IF;
               END IF;
            END IF;
         --E_TITLE := E_TITLE || ' ' || E_NUMBERS;
         END IF;

         v_ret.EXTEND;
         v_ret (countrec) :=
            t_col (minepi,
                   e_title || ' ' || e_numbers,
                   e_title_wt || ' ' || e_numbers_wt,
                   i_duration,
                   runord,
                   -- Abhinay 6Feb2014 : RunningOrder implementation for Scheduler
                   i_sporttype,
                   i_subgenre,
                   i_eventtype,
                  'S'||l_season_no||': ' ||e_sea_number ||' of '||(i_epi_count +epexist));
         minepi := minepi + 1;
         runord := runord + 1;
      -- Abhinay 6Feb2014 : RunningOrder implementation for Scheduler
      --COUNTREC := COUNTREC + 1;
      END LOOP;
       BEgin
           select count (1), SER_SEA_EPI_COUNT
              into l_count ,l_epi_count
           from fid_series
               where ser_number = i_seasonnumber
               group by SER_SEA_EPI_COUNT;
     Exception
              WHEN NO_DATA_FOUND
              THEN
               l_count:=0;
               l_epi_count:=0;
      ENd;


      /*
       variable d refcursor
        exec pkg_tmp_seriesom.prc_adm_cm_generateepi('y','series','y','season','N','bb','Y','y','n','y','bb','Y',100,5,'00:10:00','-','-','-',:d)
        print :d

      open o_episodesdata for
      select * from A order by 1; */
      OPEN o_episodesdata FOR SELECT * FROM TABLE (v_ret);
   END prc_adm_cm_generateepi;

   -------------------------------------------- ADD SEASON PROCEDURE  --------------------------------------------------
   PROCEDURE prc_adm_cm_addseason (
      i_mem_id            IN     sak_memo.mem_id%TYPE,
      i_seriesnumber      IN     fid_series.ser_number%TYPE,
      i_season_title      IN     fid_series.ser_title%TYPE,
      i_season_number     IN     fid_series.ser_sea_number%TYPE,
      i_first_epi         IN     sak_memo_item.mei_first_epi_number%TYPE,
      i_epi_count         IN     sak_memo_item.mei_episode_count%TYPE,
      i_first_epi_price   IN     sak_memo_item.mei_first_episode_price%TYPE,
      i_user_id           IN     sak_memo_item.mei_entry_oper%TYPE,
      i_mei_total_price   IN     sak_memo_item.mei_total_price%TYPE,
      i_gen_type          IN     fid_general.gen_type%TYPE,
      -- PB CR-44 Mrunmayi 31-jul-2013
      i_premium_flag      IN     sak_memo_item.mei_premium_flag%TYPE,
      -- End
      --Added by nishant
      i_com_number        IN     fid_series.ser_sea_number%TYPE,
      i_release_year      IN     fid_series.ser_sea_number%TYPE,
     -- i_season_svod_rights IN    fid_series.ser_svod_rights%TYPE,
      --End
      o_season_added         OUT INTEGER)
   AS
      l_exist     NUMBER := -1;
      l_parent    NUMBER := 0;
      l_o_flag    NUMBER;
      l_message   VARCHAR2 (200);
      norights    EXCEPTION;
   BEGIN
      /*pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_mem_id,
                                                          i_user_id,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF;*/
      SELECT ser_parent_number
        INTO l_parent
        FROM fid_series
       WHERE ser_number = i_seriesnumber;

      IF (l_parent = 0)
      THEN
         l_parent := i_seriesnumber;
      END IF;

      o_season_added := get_seq ('SEQ_SER_NUMBER');

      /* PB (CR P3) : Mangesh_20120910 : Added a new field season number*/
      INSERT INTO fid_series (ser_number,
                              ser_title,
                              ser_entry_date,
                              ser_entry_oper,
                              ser_parent_number,
                              order_title,
                              order_number,
                              order_season,
                              ser_duration,
                              ser_update_count,
                              ser_sea_number,
                              --Added by nishant
                              ser_com_number,
                              ser_release_year
                             )
           --End

           VALUES (o_season_added,
                   i_season_title,
                   SYSDATE,
                   i_user_id,
                   l_parent,
                   (SELECT ser_title
                      FROM fid_series
                     WHERE ser_number = i_seriesnumber),
                   0,
                   i_season_title,
                   0,
                   0,
                   UPPER (i_season_number)                  --Added by nishant
                                          ,
                   i_com_number,
                   i_release_year
                   );

      /* PB (CR P3) : End */
      BEGIN
         SELECT COUNT (mei_mem_id)
           INTO l_exist
           FROM sak_memo_item
          WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_seriesnumber;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF (l_exist = 0)
      THEN
         INSERT INTO sak_memo_item (mei_id,
                                    mei_mem_id,
                                    mei_gen_refno,
                                    mei_first_epi_number,
                                    mei_episode_count,
                                    mei_total_price,
                                    mei_first_episode_price,
                                    mei_type_show,
                                    mei_entry_oper,
                                    mei_entry_date,
                                    mei_update_count,
                                    mei_live_ind,
                                    mei_supp_fee          -- PB CR-44 Mrunmayi
                                                ,
                                    mei_premium_flag                    -- end
                                                    )
              VALUES (get_seq ('SEQ_MEI_ID'),
                      i_mem_id,
                      o_season_added,
                      i_first_epi,
                      i_epi_count,
                      i_mei_total_price,
                      i_first_epi_price,
                      i_gen_type,
                      i_user_id,
                      SYSDATE,
                      0,
                      'N/A',
                      'N'                                 -- PB CR-44 Mrunmayi
                         ,
                      i_premium_flag                                    -- end
                                    );
      ELSE
         UPDATE sak_memo_item
            SET mei_gen_refno = o_season_added,
                mei_first_epi_number = 1,
                mei_episode_count = 0,
                mei_total_price = i_mei_total_price,
                mei_first_episode_price = i_first_epi_price,
                mei_premium_flag = i_premium_flag
          WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_seriesnumber;
      END IF;

      /*UPDATE fid_series
         SET ser_duration = (SELECT SUM (gen_duration)
                               FROM fid_general
                              WHERE gen_ser_number = i_seasonnumber)
      WHERE  ser_number = i_seasonnumber;*/
      COMMIT;
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20401, SUBSTR (SQLERRM, 1, 150));
   END prc_adm_cm_addseason;

   -------------------------------------------- UPDATE SEASON PROCEDURE  --------------------------------------------------
   PROCEDURE prc_adm_cm_updtseason (
      i_mem_id            IN     sak_memo.mem_id%TYPE,
      i_oldseasonnumber   IN     fid_series.ser_number%TYPE,
      i_first_epi         IN     sak_memo_item.mei_first_epi_number%TYPE,
      i_epi_count         IN     sak_memo_item.mei_episode_count%TYPE,
      i_first_epi_price   IN     sak_memo_item.mei_first_episode_price%TYPE,
      i_mei_total_price   IN     sak_memo_item.mei_total_price%TYPE,
      i_newseasonnumber   IN     fid_series.ser_number%TYPE,
      i_updateflag        IN     VARCHAR2,
      o_season_updated       OUT INTEGER)
   AS
      l_flag   NUMBER := -1;
   BEGIN
      IF (i_updateflag = 'Y')       --(i_oldseasonnumber <> i_newseasonnumber)
      THEN
         UPDATE sak_memo_item
            SET mei_first_episode_price = i_first_epi_price,
                mei_total_price = i_mei_total_price,
                mei_episode_count = i_epi_count,
                mei_first_epi_number = i_first_epi,
                mei_gen_refno = i_newseasonnumber,
                mei_duration_number =
                   NVL ( (SELECT SUM (gen_duration)
                            FROM fid_general
                           WHERE gen_ser_number = i_newseasonnumber),
                        0)
          WHERE     mei_mem_id = i_mem_id
                AND mei_gen_refno = i_oldseasonnumber
                AND ROWNUM = 1;
      ELSE
         UPDATE sak_memo_item
            SET mei_first_episode_price = i_first_epi_price,
                mei_total_price = i_mei_total_price,
                mei_episode_count = i_epi_count,
                mei_first_epi_number = i_first_epi
          WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_oldseasonnumber;
      END IF;

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         o_season_updated := l_flag;
         COMMIT;
      ELSE
         o_season_updated := 0;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20402, SUBSTR (SQLERRM, 1, 150));
   END prc_adm_cm_updtseason;

   ------------------------------------------------- ADD EPISODES ----------------------------------------------------
   PROCEDURE prc_adm_cm_addepisodes (
      i_mem_id              IN     sak_memo.mem_id%TYPE,
      i_gen_type            IN     fid_general.gen_type%TYPE,
      i_gen_title           IN     fid_general.gen_title%TYPE,
      i_gen_title_working   IN     fid_general.gen_title_working%TYPE,
      i_genre               IN     fid_general.gen_category%TYPE,
      i_sub_genre           IN     fid_general.gen_subgenre%TYPE,
      i_event               IN     fid_general.gen_event%TYPE,
      i_gen_duration_c      IN     fid_general.gen_duration_c%TYPE,
      i_gencomment          IN     fid_general.gen_comment%TYPE,
      i_genepinumber        IN     fid_general.gen_epi_number%TYPE,
      i_gen_relic           IN     fid_general.gen_relic%TYPE,
      i_licensor            IN     fid_company.com_short_name%TYPE,
      i_user_id             IN     fid_general.gen_entry_oper%TYPE,
      i_seasonnumber        IN     fid_series.ser_number%TYPE,
      i_linkedseason        IN     fid_series.ser_number%TYPE,
      i_releaseyear         IN     fid_general.gen_release_year%TYPE,
      -->Project Bioscope :: By Vikram Bansod _ 10-May-2012
      i_updateflag          IN     VARCHAR2,
      i_gen_run_order       IN     fid_general.gen_running_order%TYPE,
      --Abhinay_20140121
      i_GEN_SEA_EPI_NO    In     fid_general.GEN_SEA_EPI_NO%TYPE,
      o_mei_gen_refno          OUT sak_memo_item.mei_gen_refno%TYPE)
   AS
      l_dur_number       NUMBER;
      l_dur_char         VARCHAR2 (10);
      l_dur_s            VARCHAR2 (1);
      l_hours            VARCHAR2 (10);
      l_minutes          VARCHAR2 (10);
      l_seconds          VARCHAR2 (10);
      --l_exist             NUMBER        := 0;
      l_o_flag           NUMBER;
      l_message          VARCHAR2 (200);
      norights           EXCEPTION;
      l_count_relic      NUMBER := 0;
      l_gen_relic_new    fid_general.gen_relic%TYPE;
      l_gen_relic_null   NUMBER := 0;
      l_mem_con_procurement_type sak_memo.mem_con_procurement_type%type;
      l_GEN_ARCHIVE fid_general.GEN_ARCHIVE%type;
      -- Synergy Vanilla:Start [Nasreen Mulla]
      L_CONTENT          X_FIN_CONFIGS.CONTENT%TYPE;
      l_svod_rights      varchar2(100);
   -- Synergy Vanilla:end
    l_Sea_Epi_Total NUMBER;
   BEGIN
      /*pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_mem_id,
                                                          i_user_id,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF;*/
      --o_mei_gen_refno := get_seq ('SEQ_GEN_REFNO');
      -- l_dur_number := fn_convert_duration_c_n (i_gen_duration_c);
      -- Synergy Vanilla:Start [Nasreen Mulla]

      select mem_con_procurement_type
      into l_mem_con_procurement_type
      from sak_memo where mem_id = i_mem_id
      ;

      if l_mem_con_procurement_type in ('IN HOUSE PRODUCTION','COMMISSIONED')
      then
            l_GEN_ARCHIVE := 'Y';
      end if;

      SELECT CONTENT
        INTO L_CONTENT
        FROM X_FIN_CONFIGS
       WHERE KEY = 'COMPANY_ID';
   /*Svod Rights changes*/
       SELECT ser_svod_rights
       Into l_svod_rights
       FROM fid_series
       where ser_number = i_seasonnumber
       and ser_parent_number > 0;
    /*End Svod Rights*/
      IF L_CONTENT = 1
      THEN
         o_mei_gen_refno := get_seq ('SEQ_GEN_REFNO');
      ELSE
         o_mei_gen_refno := get_seq ('SEQ_GEN_REFNO_M24');
      END IF;

      -- Synergy Vanilla:End
      l_dur_number :=
           (SUBSTR (i_gen_duration_c, 1, 2) * 90000)
         + (SUBSTR (i_gen_duration_c, 4, 2) * 1500)
         + (SUBSTR (i_gen_duration_c, 7, 2) * 25);
      l_dur_char := i_gen_duration_c;
      l_hours := SUBSTR (l_dur_char, 1, 2);
      l_minutes := SUBSTR (l_dur_char, 4, 2);
      l_seconds := SUBSTR (l_dur_char, 7, 2);
      l_dur_char := (l_hours || ':' || l_minutes || ':' || l_seconds);

      IF l_dur_number > 0
      THEN
         l_dur_s := 'A';
      END IF;

      -- Start Newly Added. If users adds the executed season but wit gen-relic as null then while adding new episodes check if he has relicensed the episodes for this season.
      /*
          BEGIN
                select count(*)  into l_gen_relic_null from fid_general,fid_license
                    where lic_gen_refno = gen_refno
                    and gen_relic is null
                    and gen_ser_number = i_seasonnumber;
          EXCEPTION
                when others then
                    l_gen_relic_null :=0;
          END;

        IF l_gen_relic_null > 0 THEN
            l_gen_relic_new := 'N' ;
        ELSE
            BEGIN
                select count(*) INTO l_gen_relic_null from fid_general
                where gen_relic = 'Y'
                    and gen_ser_number = i_seasonnumber;
            EXCEPTION
                WHEN OTHERS THEN
                    l_gen_relic_null :=0;
            END;

            IF l_gen_relic_null > 0 THEN
                l_gen_relic_new := 'N';
            ELSE
                l_gen_relic_new := 'Y';
            END IF;
        END IF;
        */
      -- End

      -- Add Episode information in fid_general table.
      INSERT INTO fid_general (gen_refno,
                               gen_title,
                               gen_type,
                               gen_duration,
                               gen_release_year,
                               --> Project Bioscope :: By Vikram Bansod _ 10-May-2012
                               gen_relic,
                               gen_duration_c,
                               gen_duration_s,
                               gen_supplier_com_number,
                               gen_ser_number,
                               gen_stu_code,
                               gen_category,
                               gen_title_working,
                               gen_event,
                               gen_subgenre,
                               gen_epi_number,
                               gen_comment,
                               gen_update_count,
                               gen_entry_date,
                               gen_entry_oper,
                               gen_relic_new,
                               gen_running_order,          -- Abhinay_20140121
                               gen_web_title --#region Abhinay_2jun214 : Web title functionality
                               ,gen_svod_rights
                               ,GEN_ARCHIVE
			       ,GEN_SEA_EPI_NO
                                            )
           VALUES (o_mei_gen_refno,
                   i_gen_title,
                   i_gen_type,
                   l_dur_number,
                   i_releaseyear,
                   --> Project Bioscope :: By Vikram Bansod _ 10-May-2012
                   i_gen_relic,
                   l_dur_char,
                   l_dur_s,
                   (SELECT com_number
                      FROM fid_company
                     WHERE com_short_name = UPPER (i_licensor)),
                   i_seasonnumber,
                   '-',
                   NVL (i_genre, '-'),
                   i_gen_title_working,
                   NVL (i_event, '-'),
                   NVL (i_sub_genre, '-'),
                   i_genepinumber,
                   i_gencomment,
                   0,
                   SYSDATE,
                   i_user_id,
                   'Y',
                   i_gen_run_order                         -- Abhinay_20140121
                                  ,
                   (SELECT SER_WEB_TITLE
                      FROM FID_SERIES
                     WHERE ser_number = i_seasonnumber) --#region Abhinay_2jun214 : Web title functionality
                    ,l_svod_rights
                    ,l_GEN_ARCHIVE
		    ,i_GEN_SEA_EPI_NO --- Added by Rashmi 15/06/2016
                    );

      BEGIN
         SELECT NVL (COUNT (gen_refno), 0)
           INTO l_count_relic
           FROM fid_general
          WHERE gen_ser_number = i_seasonnumber AND gen_relic = 'Y';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_count_relic := 0;
         WHEN OTHERS
         THEN
            l_count_relic := 0;
      END;

      IF (i_updateflag != 'Y')             --(i_linkedseason = i_seasonnumber)
      THEN
         IF (l_count_relic > 0)
         THEN
            UPDATE sak_memo_item
               SET mei_episode_count =
                      (SELECT COUNT (gen_refno)
                         FROM fid_general
                        WHERE gen_ser_number = i_seasonnumber),
                   mei_duration_number =
                      (SELECT SUM (gen_duration)
                         FROM fid_general
                        WHERE gen_ser_number = i_seasonnumber
                              AND gen_relic = 'Y')
             WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_seasonnumber;
         ELSE
            UPDATE sak_memo_item
               SET mei_episode_count =
                      (SELECT COUNT (gen_refno)
                         FROM fid_general
                        WHERE gen_ser_number = i_seasonnumber),
                   mei_duration_number =
                      (SELECT SUM (gen_duration)
                         FROM fid_general
                        WHERE gen_ser_number = i_seasonnumber)
             WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_seasonnumber;
         END IF;
      ELSE
         IF (l_count_relic > 0)
         THEN
            UPDATE sak_memo_item
               SET mei_episode_count =
                      (SELECT COUNT (gen_refno)
                         FROM fid_general
                        WHERE gen_ser_number = i_seasonnumber),
                   mei_duration_number =
                      (SELECT SUM (gen_duration)
                         FROM fid_general
                        WHERE gen_ser_number = i_seasonnumber
                              AND gen_relic = 'Y'),
                   mei_gen_refno = i_seasonnumber
             WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_linkedseason;
         ELSE
            UPDATE sak_memo_item
               SET mei_episode_count =
                      (SELECT COUNT (gen_refno)
                         FROM fid_general
                        WHERE gen_ser_number = i_seasonnumber),
                   mei_duration_number =
                      (SELECT SUM (gen_duration)
                         FROM fid_general
                        WHERE gen_ser_number = i_seasonnumber),
                   mei_gen_refno = i_seasonnumber
             WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_linkedseason;
         END IF;
      END IF;
----
 BEGIN
         select Count(*) into l_Sea_Epi_Total
       from FID_GENERAL where GEN_SER_NUMBER = i_seasonnumber;
              update fid_series
			   set SER_SEA_EPI_COUNT = l_Sea_Epi_Total
				WHERE ser_number = i_seasonnumber;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_Sea_Epi_Total := 0;
         WHEN OTHERS
         THEN
            l_Sea_Epi_Total := 0;
      END;

      COMMIT;
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20403, SUBSTR (SQLERRM, 1, 150));
   END prc_adm_cm_addepisodes;

   /*------------------------------------------------- UPDATE EPISODES ----------------------------------------------------
      PROCEDURE prc_adm_cm_updtepisodes (
         i_mem_id              IN       sak_memo.mem_id%TYPE,
         --i_mem_status          IN       sak_memo.mem_status%TYPE,
         i_gen_title_working   IN       fid_general.gen_title_working%TYPE,
         i_gen_duration_c      IN       fid_general.gen_duration_c%TYPE,
         i_gencomment          IN       fid_general.gen_comment%TYPE,
         i_gen_relic           IN       fid_general.gen_relic%TYPE,
         i_gen_refno           IN       fid_general.gen_refno%TYPE,
         i_gen_update_count    IN       fid_general.gen_update_count%TYPE,
         i_seasonnumber        IN       fid_series.ser_number%TYPE,
         i_linkedseason        IN       fid_series.ser_number%TYPE,
         o_episode_updated     OUT      NUMBER
      )
      AS
         updatfailed    EXCEPTION;
         errortext      VARCHAR2 (100);
         l_flag         NUMBER                     := 0;
         i_mem_status   sak_memo.mem_status%TYPE;
         l_dur_number   NUMBER                     := 0;
      BEGIN
         IF (i_gen_duration_c IS NOT NULL)
         THEN
            l_dur_number :=
                 (SUBSTR (i_gen_duration_c, 1, 2) * 90000)
               + (SUBSTR (i_gen_duration_c, 4, 2) * 1500)
               + (SUBSTR (i_gen_duration_c, 7, 2) * 25);
         END IF;

         SELECT mem_status
           INTO i_mem_status
           FROM sak_memo
          WHERE mem_id = i_mem_id;

         IF (   i_mem_status = 'REGISTERED'
             OR i_mem_status = 'BUYER RECOMMENDED'
             OR i_mem_status = 'BUDGETED'
             OR i_mem_status = 'BEXECUTED'
            )
         THEN
            UPDATE    fid_general
                  SET gen_title_working = i_gen_title_working,
                      gen_duration_c = i_gen_duration_c,
                      gen_duration = l_dur_number,
                      gen_comment = i_gencomment,
                      gen_relic = i_gen_relic,
                      gen_update_count = NVL (gen_update_count, 0) + 1
                WHERE gen_ser_number = i_seasonnumber
                  AND gen_refno = i_gen_refno
                  AND NVL (gen_update_count, 0) = i_gen_update_count
            RETURNING gen_update_count
                 INTO l_flag;

            IF (l_flag <> 0)
            THEN
               o_episode_updated := l_flag;
               l_flag := 0;
            ELSE
               errortext := 'Data Not Updated';
               RAISE updatfailed;
            END IF;

            --UPDATE fid_series SET ser_duration = (SELECT SUM (gen_duration) FROM fid_general WHERE gen_ser_number = i_seasonnumber)
            --WHERE ser_number = i_seasonnumber;
            IF (i_linkedseason = i_seasonnumber)
            THEN
               UPDATE sak_memo_item
                  SET mei_duration_number =
                         (SELECT SUM (gen_duration)
                            FROM fid_general
                           WHERE gen_ser_number = i_seasonnumber
                             AND gen_relic = 'Y')
                WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_seasonnumber;
            ELSE
               UPDATE sak_memo_item
                  SET mei_episode_count =
                                         (SELECT COUNT (gen_refno)
                                            FROM fid_general
                                           WHERE gen_ser_number = i_seasonnumber),
                      mei_duration_number =
                         (SELECT SUM (gen_duration)
                            FROM fid_general
                           WHERE gen_ser_number = i_seasonnumber
                             AND gen_relic = 'Y'),
                      mei_gen_refno = i_seasonnumber
                WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_seasonnumber;
                                                                --i_linkedseason;
            END IF;

            COMMIT;
         ELSE
            errortext :=
                  'Deal Memo Cannot be edited as its status is ' || i_mem_status;
            RAISE updatfailed;
         END IF;
      EXCEPTION
         WHEN updatfailed
         THEN
            ROLLBACK;
            raise_application_error (-20404, errortext);
         WHEN OTHERS
         THEN
            ROLLBACK;
            raise_application_error (-20405, SUBSTR (SQLERRM, 1, 200));
      END prc_adm_cm_updtepisodes; */

   /*------------------------------------------------- DELETE EPISODES ----------------------------------------------------
   PROCEDURE prc_adm_cm_delepisodes (
      i_mem_id             IN       sak_memo.mem_id%TYPE,
      --i_mem_status         IN       sak_memo.mem_status%TYPE,
      i_gen_refno          IN       fid_general.gen_refno%TYPE,
      i_gen_update_count   IN       fid_general.gen_update_count%TYPE,
      i_seasonnumber       IN       fid_series.ser_number%TYPE,
      o_episode_deleted    OUT      NUMBER
   )
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
      errortext      VARCHAR2 (200);
      i_mem_status   sak_memo.mem_status%TYPE;
      l_errortext    VARCHAR2 (20);
   BEGIN
      SELECT mem_status
        INTO i_mem_status
        FROM sak_memo
       WHERE mem_id = i_mem_id;

      IF (   i_mem_status = 'REGISTERED'
          OR i_mem_status = 'BUYER RECOMMENDED'
          OR i_mem_status = 'BUDGETED'
          OR i_mem_status = 'BEXECUTED'
         )
      THEN
         BEGIN
            DELETE FROM fid_general
                  WHERE gen_refno = i_gen_refno
                    AND NVL (gen_update_count, 0) = i_gen_update_count;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         l_flag := SQL%ROWCOUNT;

         IF (l_flag <> 0)
         THEN
            COMMIT;

            UPDATE sak_memo_item
               SET mei_episode_count =
                                      (SELECT COUNT (gen_refno)
                                         FROM fid_general
                                        WHERE gen_ser_number = i_seasonnumber)
             WHERE mei_mem_id = i_mem_id AND mei_gen_refno = i_seasonnumber;

            UPDATE fid_series
               SET ser_duration = (SELECT SUM (gen_duration)
                                     FROM fid_general
                                    WHERE gen_ser_number = i_seasonnumber)
             WHERE ser_number = i_seasonnumber;

            COMMIT;
            o_episode_deleted := l_flag;
         ELSE
            errortext := 'Data Not deleted';
            RAISE deldatfailed;
         END IF;
      ELSE
         errortext :=
               'Deal Memo Cannot be edited as its status is ' || i_mem_status;
         RAISE deldatfailed;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN deldatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20406, errortext);
      WHEN OTHERS
      THEN
         l_errortext := SUBSTR (SQLERRM, 1, 9);

         IF (l_errortext = 'ORA-02292')
         THEN
            raise_application_error
                         (-20601,
                          'Episodes are being refernced. So cannot delete it'
                         );
         ELSE
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
         END IF;
   END prc_adm_cm_delepisodes;*/

   ------------------------------------------------------- SEARCH CPD DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_search_cpddetails (
      i_mem_id                IN     sak_memo.mem_id%TYPE,
      i_fcd_orig_ser_number   IN     fid_cpd_details.fcd_orig_ser_number%TYPE,
      o_dealmemoresult           OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_dealmemoresult FOR
         SELECT fid_cpd_details.fcd_number,
                fid_cpd_details.fcd_title,
                fid_cpd_details.fcd_price,
                fid_cpd_details.fcd_per_month,
                fid_cpd_details.fcd_per_year,
                fid_cpd_details.fcd_end_month,
                fid_cpd_details.fcd_end_year,
                fid_cpd_details.fcd_comments,
                NVL (fcd_update_count, 0) fcd_update_count
           FROM fid_cpd_details
          WHERE fid_cpd_details.fcd_mem_id = i_mem_id
                AND fid_cpd_details.fcd_orig_ser_number =
                       i_fcd_orig_ser_number;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20408, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_ss_search_cpddetails;

   ------------------------------------------------------- ADD CPD DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_add_cpddetails (
      i_fcd_mem_id            IN     sak_memo.mem_id%TYPE,
      i_fcd_title             IN     fid_cpd_details.fcd_title%TYPE,
      i_fcd_price             IN     fid_cpd_details.fcd_price%TYPE,
      i_fcd_comments          IN     fid_cpd_details.fcd_comments%TYPE,
      i_fcd_per_year          IN     fid_cpd_details.fcd_per_year%TYPE,
      i_fcd_per_month         IN     fid_cpd_details.fcd_per_month%TYPE,
      i_fcd_end_year          IN     fid_cpd_details.fcd_end_year%TYPE,
      i_fcd_end_month         IN     fid_cpd_details.fcd_end_month%TYPE,
      i_fcd_orig_ser_number   IN     fid_cpd_details.fcd_orig_ser_number%TYPE,
      i_fcd_entry_oper        IN     fid_cpd_details.fcd_entry_oper%TYPE,
      i_fcd_con_short_name    IN     fid_cpd_details.fcd_con_short_name%TYPE,
      o_fcd_number               OUT NUMBER)
   AS
      TYPE fcd_details IS RECORD
      (
         i_fcd_mei_id       fid_cpd_details.fcd_mei_id%TYPE,
         i_fcd_orig_title   fid_cpd_details.fcd_orig_title%TYPE,
         i_fcd_con_number   fid_cpd_details.fcd_con_number%TYPE
      );
   BEGIN
      o_fcd_number := get_seq ('SEQ_CPD_NUMBER');

      INSERT INTO fid_cpd_details (fcd_mem_id,
                                   fcd_con_short_name,
                                   fcd_title,
                                   fcd_price,
                                   fcd_comments,
                                   fcd_orig_title,
                                   fcd_orig_ser_number,
                                   fcd_per_year,
                                   fcd_per_month,
                                   fcd_mei_id,
                                   fcd_number,
                                   fcd_con_number,
                                   fcd_end_year,
                                   fcd_end_month,
                                   fcd_entry_oper,
                                   fcd_entry_date,
                                   fcd_update_count)
           VALUES (
                     i_fcd_mem_id,
                     i_fcd_con_short_name,
                     i_fcd_title,
                     i_fcd_price,
                     i_fcd_comments,
                     (SELECT ser_title
                        FROM fid_series
                       WHERE fid_series.ser_number = i_fcd_orig_ser_number),
                     i_fcd_orig_ser_number,
                     i_fcd_per_year,
                     i_fcd_per_month,
                     (SELECT mei_id
                        FROM sak_memo_item
                       WHERE mei_mem_id = i_fcd_mem_id
                             AND mei_gen_refno = i_fcd_orig_ser_number),
                     o_fcd_number,
                     (SELECT con_number
                        FROM fid_contract
                       WHERE con_short_name = i_fcd_con_short_name),
                     i_fcd_end_year,
                     i_fcd_end_month,
                     i_fcd_entry_oper,
                     SYSDATE,
                     0);

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20409, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_ss_add_cpddetails;

   ------------------------------------------------------- UPDATE CPD DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_updt_cpddetails (
      i_fcd_mem_id         IN     sak_memo.mem_id%TYPE,
      i_fcd_number         IN     fid_cpd_details.fcd_number%TYPE,
      i_fcd_title          IN     fid_cpd_details.fcd_title%TYPE,
      i_fcd_price          IN     fid_cpd_details.fcd_price%TYPE,
      i_fcd_comments       IN     fid_cpd_details.fcd_comments%TYPE,
      i_fcd_per_year       IN     fid_cpd_details.fcd_per_year%TYPE,
      i_fcd_per_month      IN     fid_cpd_details.fcd_per_month%TYPE,
      i_fcd_end_year       IN     fid_cpd_details.fcd_end_year%TYPE,
      i_fcd_end_month      IN     fid_cpd_details.fcd_end_month%TYPE,
      i_fcd_update_count   IN     fid_cpd_details.fcd_update_count%TYPE,
      o_fcd_updated           OUT NUMBER)
   AS
      updatfailed   EXCEPTION;
      l_flag        NUMBER;
   BEGIN
         UPDATE fid_cpd_details
            SET fcd_title = i_fcd_title,
                fcd_price = i_fcd_price,
                fcd_comments = i_fcd_comments,
                fcd_per_year = i_fcd_per_year,
                fcd_per_month = i_fcd_per_month,
                fcd_end_year = i_fcd_end_year,
                fcd_end_month = i_fcd_end_month,
                fcd_update_count = NVL (fcd_update_count, 0) + 1
          WHERE     fcd_number = i_fcd_number
                AND fcd_mem_id = i_fcd_mem_id
                AND NVL (fcd_update_count, 0) = i_fcd_update_count
      RETURNING fcd_update_count
           INTO l_flag;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_fcd_updated := l_flag;
      ELSE
         RAISE updatfailed;
      END IF;
   EXCEPTION
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20410, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20411, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_ss_updt_cpddetails;

   ------------------------------------------------------- DELETE CPD DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_del_cpddetails (
      i_fcd_mem_id         IN     sak_memo.mem_id%TYPE,
      i_fcd_number         IN     fid_cpd_details.fcd_number%TYPE,
      i_fcd_update_count   IN     fid_cpd_details.fcd_update_count%TYPE,
      o_fcd_deleted           OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
   BEGIN
      DELETE FROM fid_cpd_details
            WHERE     fcd_number = i_fcd_number
                  AND fcd_mem_id = i_fcd_mem_id
                  AND NVL (fcd_update_count, 0) = i_fcd_update_count;

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_fcd_deleted := l_flag;
      ELSE
         RAISE deldatfailed;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN deldatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20412, 'Data Not Deleted');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20413, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_ss_del_cpddetails;

   ------------------------------------------------------- SEARCH LIVE ENENT DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_search_livedetails (
      i_fgl_gen_refno      IN     fid_gen_live.fgl_gen_refno%TYPE,
      o_fgl_venue             OUT fid_gen_live.fgl_venue%TYPE,
      o_fgl_location          OUT fid_gen_live.fgl_location%TYPE,
      o_fgl_live_date         OUT VARCHAR2,
      o_fgl_time              OUT VARCHAR2,
      o_fgl_update_count      OUT fid_gen_live.fgl_update_count%TYPE)
   AS
   BEGIN
      SELECT fgl_venue,
             fgl_location,
             TO_CHAR (fgl_live_date, 'dd/mon/yyyy'),
             (   LTRIM (TO_CHAR (FLOOR (fgl_time / 90000), '09'))
              || ':'
              || LTRIM (TO_CHAR (FLOOR (MOD (fgl_time, 90000) / 1500), '09'))),
             --REPLACE (TO_CHAR (SUBSTR (fgl_time / 3600, 1, 5)), '.', ':'),
             NVL (fgl_update_count, 0) fgl_update_count
        INTO o_fgl_venue,
             o_fgl_location,
             o_fgl_live_date,
             o_fgl_time,
             o_fgl_update_count
        FROM fid_gen_live
       WHERE fgl_gen_refno = i_fgl_gen_refno;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         o_fgl_venue := NULL;
         o_fgl_location := NULL;
         o_fgl_live_date := TO_CHAR (SYSDATE, 'dd/mon/yyyy');
         o_fgl_time := NULL;
         o_fgl_update_count := 0;
      WHEN OTHERS
      THEN
         raise_application_error (-20414, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_ss_search_livedetails;

   ------------------------------------------------------- SAVE LIVE ENENT DETAILS ----------------------------------------------------
   PROCEDURE prc_adm_ss_save_livedetails (
      i_fgl_gen_refno       IN     fid_gen_live.fgl_gen_refno%TYPE,
      i_fgl_venue           IN     fid_gen_live.fgl_venue%TYPE,
      i_fgl_location        IN     fid_gen_live.fgl_location%TYPE,
      i_fgl_live_date       IN     fid_gen_live.fgl_live_date%TYPE,
      i_fgl_time            IN     VARCHAR2,
      i_fgl_update_count    IN     fid_gen_live.fgl_update_count%TYPE,
      i_fgl_entry_oper      IN     fid_gen_live.fgl_entry_oper%TYPE,
      o_livedetails_saved      OUT NUMBER)
   AS
      l_exist       NUMBER := 0;
      l_flag        NUMBER;
      updatfailed   EXCEPTION;
      l_fgltime     NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (1)
           INTO l_exist
           FROM fid_gen_live
          WHERE fgl_gen_refno = i_fgl_gen_refno;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      /*l_fgltime :=
         TO_NUMBER (  (  SUBSTR (i_fgl_time, 1, 2)
                       + SUBSTR (i_fgl_time, 4, 2) * 0.01
                      )
                    * 3600
                   ); */
      l_fgltime :=
         TO_NUMBER (
            (SUBSTR (i_fgl_time, 1, 2) * 90000)
            + (SUBSTR (i_fgl_time, 4, 2) * 1500));

      IF (l_exist = 0)
      THEN
         INSERT INTO fid_gen_live (fgl_gen_refno,
                                   fgl_venue,
                                   fgl_location,
                                   fgl_live_date,
                                   fgl_time,
                                   fgl_entry_oper,
                                   fgl_entry_date,
                                   fgl_update_count)
              VALUES (i_fgl_gen_refno,
                      i_fgl_venue,
                      i_fgl_location,
                      i_fgl_live_date,
                      l_fgltime,
                      i_fgl_entry_oper,
                      SYSDATE,
                      0);

         l_flag := SQL%ROWCOUNT;

         IF (l_flag <> 0)
         THEN
            COMMIT;
            o_livedetails_saved := l_flag;
         END IF;
      ELSE
            UPDATE fid_gen_live
               SET fgl_venue = i_fgl_venue,
                   fgl_location = i_fgl_location,
                   fgl_live_date = i_fgl_live_date,
                   fgl_time = l_fgltime,
                   fgl_update_count = NVL (fgl_update_count, 0) + 1
             WHERE fgl_gen_refno = i_fgl_gen_refno
                   AND NVL (fgl_update_count, 0) = i_fgl_update_count
         RETURNING fgl_update_count
              INTO l_flag;

         IF (l_flag <> 0)
         THEN
            COMMIT;
            o_livedetails_saved := l_flag;
         ELSE
            RAISE updatfailed;
         END IF;
      END IF;
   EXCEPTION
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20415, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20416, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_ss_save_livedetails;

   -------------------------------------------- PROCEDURE TO SEARCH BUDGET TITLES -----------------------------------------
   PROCEDURE prc_adm_cm_searchbudget (
      i_mem_id       IN     sak_memo.mem_id%TYPE,
      o_budgetdata      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
      l_querystr   VARCHAR2 (5000);
   BEGIN
      l_querystr :=
         '
         SELECT   mem_id, mem_date, mem_lee_short_name main_licensee,
                  com_short_name licensor, gen_title title,
                  ald_lee_short_name Lee, ald_amount amount,
                  ald_period_start start_date, ald_period_end end_date
             FROM (SELECT mem_id, mem_date,
                          a.lee_short_name mem_lee_short_name, com_short_name,
                          gen_title, gen_title_working, gen_refno,
                          gen_category, gen_subgenre, gen_event,
                          mei_episode_count,
                          b.lee_short_name ald_lee_short_name, mem_currency,
                          ald_amount, ald_period_start, ald_period_end,
                          ald_period_tba, ald_months, ald_end_days,
                          mem_status, mem_buyer, mem_approver, cod_attr1,
                          cod_attr2
                     FROM sak_memo,
                          sak_memo_item,
                          sak_allocation_detail,
                          fid_licensee a,
                          fid_licensee b,
                          fid_company,
                          fid_general,
                          fid_code
                    WHERE mem_id = mei_mem_id(+)
                      AND mei_id = ald_mei_id(+)
                      AND mei_gen_refno = gen_ser_number(+)
                      AND mem_lee_number = a.lee_number(+)
                      AND ald_lee_number = b.lee_number(+)
                      AND mem_com_number = com_number
                      AND cod_value(+) = mei_type_show )
             WHERE mem_status IN (''BUDGETED'', ''BEXECUTED'')';

      --AND cod_type = ''GEN_TYPE''
      --AND cod_attr1 = ''Y''
      /*            UNION ALL
                  SELECT mem_id, mem_date,
                         a.lee_short_name mem_lee_short_name, com_short_name,
                         gen_title, gen_title_working, gen_refno,
                         gen_category, gen_subgenre, gen_event,
                         mei_episode_count,
                         b.lee_short_name ald_lee_short_name, mem_currency,
                         ald_amount, ald_period_start, ald_period_end,
                         ald_period_tba, ald_months, ald_end_days,
                         mem_status, mem_buyer, mem_approver, cod_attr1,
                         cod_attr2
                    FROM sak_memo,
                         sak_memo_item,
                         sak_allocation_detail,
                         fid_licensee a,
                         fid_licensee b,
                         fid_company,
                         fid_general,
                         fid_code
                   WHERE mem_id = mei_mem_id(+)
                     AND mei_id = ald_mei_id(+)
                     AND mei_gen_refno = gen_refno(+)
                     AND mem_lee_number = a.lee_number(+)
                     AND ald_lee_number = b.lee_number(+)
                     AND mem_com_number = com_number
                     AND cod_type = ''GEN_TYPE''
                     AND cod_value = mei_type_show
                     AND cod_attr1 != ''Y'')
           WHERE mem_status IN (''BUDGETED'', ''BEXECUTED'')'; */
      IF (i_mem_id <> 0)
      THEN
         l_querystr := l_querystr || ' AND mem_id = ''' || i_mem_id || '''';
         l_querystr := l_querystr || ' Order By 3,2,1 ASC ';
      ELSE
         l_querystr := l_querystr || ' Order By 3,2,1 ASC ';
      END IF;

      OPEN o_budgetdata FOR l_querystr;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20417, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_searchbudget;

   -------------------------------------------- PROCEDURE TO MOVE BUDGET TITLES -----------------------------------------
   PROCEDURE prc_adm_cm_movebudget (
      i_source_mei_id            IN     sak_memo_item.mei_id%TYPE,
      i_source_mem_id            IN     sak_memo.mem_id%TYPE,
      i_source_genrefno          IN     fid_general.gen_refno%TYPE,
      i_target_mem_id            IN     sak_memo.mem_id%TYPE,
      i_source_mei_updatecount   IN     sak_memo_item.mei_update_count%TYPE,
      --
      i_source_mei_type          IN     sak_memo_item.mei_type%TYPE,
      i_source_mem_type          IN     sak_memo.mem_type%TYPE,
      i_target_mem_type          IN     sak_memo.mem_type%TYPE,
      i_source_mem_status        IN OUT sak_memo.mem_status%TYPE,
      i_target_mem_status        IN OUT sak_memo.mem_status%TYPE,
      i_entry_oper               IN     VARCHAR2,
      --
      o_movedstatus                 OUT NUMBER)
   AS
      l_flag          NUMBER := -1;
      l_movedfailed   EXCEPTION;
      l_errortext     VARCHAR2 (200);
   BEGIN
      IF (i_source_mem_type <> i_target_mem_type)
      THEN
         l_errortext :=
            'Can only move titles between deal memos of the same type';
         RAISE l_movedfailed;
      ELSE
            UPDATE sak_memo_item
               SET mei_mem_id = i_target_mem_id,
                   mei_update_count = NVL (mei_update_count, 0) + 1
             WHERE     mei_mem_id = i_source_mem_id
                   AND mei_gen_refno = i_source_genrefno
                   AND mei_id = i_source_mei_id
                   AND NVL (mei_update_count, 0) = i_source_mei_updatecount
         RETURNING mei_update_count
              INTO l_flag;

         IF (l_flag <> 0)
         THEN
            COMMIT;

            BEGIN
               UPDATE sak_memo
                  SET mem_con_price =
                         (SELECT SUM (mei_total_price)
                            FROM sak_memo_item
                           WHERE mei_mem_id = i_target_mem_id)
                WHERE mem_id = i_target_mem_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            BEGIN
               UPDATE sak_memo
                  SET mem_con_price =
                         (SELECT SUM (mei_total_price)
                            FROM sak_memo_item
                           WHERE mei_mem_id = i_source_mem_id)
                WHERE mem_id = i_source_mem_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            BEGIN
               UPDATE fid_cpd_details
                  SET fcd_mem_id = i_target_mem_id
                WHERE fcd_mei_id = i_source_mei_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF i_source_mei_type <> 'SER'
            THEN
               BEGIN
                  UPDATE fid_license
                     SET lic_mem_number = i_target_mem_id
                   WHERE lic_mem_number = i_source_mem_id
                         AND lic_gen_refno = i_source_genrefno;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;
            ELSE
               BEGIN
                  UPDATE fid_license
                     SET lic_mem_number = i_target_mem_id
                   WHERE lic_mem_number = i_source_mem_id
                         AND lic_gen_refno IN
                                (SELECT gen_refno
                                   FROM fid_general
                                  WHERE gen_ser_number = i_source_genrefno);
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;
            END IF;

            pkg_adm_cm_dealmemo.prc_adm_cm_derive_status (
               i_source_mem_id,
               i_source_mem_status,
               i_entry_oper);
            pkg_adm_cm_dealmemo.prc_adm_cm_derive_status (
               i_target_mem_id,
               i_target_mem_status,
               i_entry_oper);
            COMMIT;
            o_movedstatus := 1;
         ELSE
            l_errortext := 'Move Failed';
            RAISE l_movedfailed;
         END IF;
      END IF;
   EXCEPTION
      WHEN l_movedfailed
      THEN
         ROLLBACK;
         raise_application_error (-20418, l_errortext);
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20419, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_movebudget;

   -------------------------------------------- PROCEDURE TO UPDATE HISTORY WHILE MOVING BUDGET TITLES ----------------------------------
   PROCEDURE prc_adm_cm_derive_status (v_mem          IN     NUMBER,
                                       v_mem_stat     IN OUT VARCHAR2,
                                       i_entry_oper   IN     VARCHAR2)
   IS
      v_items   NUMBER := 0;
      v_lics    NUMBER := -1;
   BEGIN
      BEGIN
         SELECT COUNT (lic_number)
           INTO v_lics
           FROM fid_license
          WHERE lic_mem_number = v_mem;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --IF NVL (v_lics, 0) > 0
      IF v_lics > 0
      THEN
         IF v_mem_stat <> 'BEXECUTED'
         THEN
            UPDATE sak_memo
               SET mem_status = 'BEXECUTED'
             WHERE mem_id = v_mem;

            INSERT INTO sak_memo_history (mhi_mem_id,
                                          mhi_from_stat,
                                          mhi_action,
                                          mhi_to_stat,
                                          mhi_entry_date,
                                          mhi_entry_oper)
                 VALUES (v_mem,
                         v_mem_stat,
                         'MOVE',
                         'BEXECUTED',
                         SYSDATE,
                         i_entry_oper);

            v_mem_stat := 'BEXECUTED';
         END IF;
      ELSE
         BEGIN
            SELECT COUNT (mei_id)
              INTO v_items
              FROM sak_memo_item
             WHERE mei_mem_id = v_mem;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         --IF NVL (v_items, 0) = 0
         IF v_items = 0
         THEN
            IF v_mem_stat <> 'REGISTERED'
            THEN
               UPDATE sak_memo
                  SET mem_status = 'REGISTERED'
                WHERE mem_id = v_mem;

               INSERT INTO sak_memo_history (mhi_mem_id,
                                             mhi_from_stat,
                                             mhi_action,
                                             mhi_to_stat,
                                             mhi_entry_date,
                                             mhi_entry_oper)
                    VALUES (v_mem,
                            v_mem_stat,
                            'MOVE',
                            'REGISTERED',
                            SYSDATE,
                            i_entry_oper);

               v_mem_stat := 'REGISTERED';
            END IF;
         ELSE
            IF v_mem_stat <> 'BUDGETED'
            THEN
               UPDATE sak_memo
                  SET mem_status = 'BUDGETED'
                WHERE mem_id = v_mem;

               INSERT INTO sak_memo_history (mhi_mem_id,
                                             mhi_from_stat,
                                             mhi_action,
                                             mhi_to_stat,
                                             mhi_entry_date,
                                             mhi_entry_oper)
                    VALUES (v_mem,
                            v_mem_stat,
                            'MOVE',
                            'BUDGETED',
                            SYSDATE,
                            i_entry_oper);

               v_mem_stat := 'BUDGETED';
            END IF;
         END IF;
      END IF;

      COMMIT;
   END prc_adm_cm_derive_status;

   -------------------------------------------- PROCEDURE FOR MEM STATUS LOV ----------------------------------
   PROCEDURE prc_adm_cm_memstatus (
      o_memstatus OUT pkg_adm_cm_dealmemo.cursor_data)
   IS
   BEGIN
      OPEN o_memstatus FOR
         SELECT DISTINCT (fsr_value2)
           FROM fid_system_rules
          WHERE     fsr_type = 'D'
                AND fsr_code = 'MEMO'
                AND fsr_value2 <> 'HISTORY'
         UNION
         SELECT DISTINCT (fsr_value4) fsr_value4
           FROM fid_system_rules
          WHERE     fsr_type = 'D'
                AND fsr_code = 'MEMO'
                AND fsr_value4 <> 'HISTORY'
         ORDER BY 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20420, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_memstatus;

   -------------------------------------------- PROCEDURE FOR CHA SHORT NAME LOV ----------------------------------
   PROCEDURE prc_adm_cm_chashortname (
      i_ald_chs_number   IN     NUMBER,
      o_chashortname        OUT pkg_adm_cm_dealmemo.cursor_data)
   IS
   BEGIN
      OPEN o_chashortname FOR
         SELECT cha_short_name,
                cha_name,
                cha_number -- Bioscope Changes by Anirudha on 15/03/2012 start
                          --Commented as per CR 55912 by Anirudha on 23/05/2012
                          /*,(select MPSM_MAPP_SERVICE_CODE
                            from   sgy_pb_med_platm_service_map
                            where  mpsm_mapp_id = cha_mpsm_mapp_id
                            ) cha_media_ser_code
                               ,(select MPSM_MAPP_PLATFORM_CODE
                            from   sgy_pb_med_platm_service_map
                            where  mpsm_mapp_id = cha_mpsm_mapp_id
                            ) cha_media_plat_code
                             , cha_mpsm_mapp_id
                           */
                          --END Commented as per CR 55912 by Anirudha on 23/05/2012
                ,
                NVL (cha_roy_flag, 'N') cha_roy_flag
           -- Bioscope Changes end
           FROM fid_channel, fid_channel_service_channel
          WHERE cha_number = csc_cha_number
                AND csc_chs_number = i_ald_chs_number
                AND SYSDATE BETWEEN NVL (csc_start_dt, SYSDATE)
                                AND csc_end_dt
         UNION
         SELECT cha_short_name,
                cha_name,
                cha_number -- Bioscope Changes by Anirudha on 15/03/2012 start
                          --Commented as per CR 55912 by Anirudha on 23/05/2012
                          /*,(select MPSM_MAPP_SERVICE_CODE
                         from   sgy_pb_med_platm_service_map
                         where  MPSM_MAPP_ID = CHA_MPSM_MAPP_ID
                         ) cha_media_ser_code
                            ,(select MPSM_MAPP_PLATFORM_CODE
                         from   sgy_pb_med_platm_service_map
                         where  MPSM_MAPP_ID = CHA_MPSM_MAPP_ID
                         ) cha_media_plat_code
                          ,cha_mpsm_mapp_id
                          */
                          --End Commented as per CR 55912 by Anirudha on 23/05/2012
                ,
                NVL (cha_roy_flag, 'N') cha_roy_flag
           -- Bioscope Changes end
           FROM fid_channel, fid_channel_service
          WHERE cha_number = chs_cha_number AND chs_number = i_ald_chs_number;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20421, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_chashortname;

   ---------------------------------------- FUNCTION CHECK PAYMENT FOR AMERT PAYMENTS --------------------------------------
   FUNCTION fn_adm_cm_check_payment (p_memid IN NUMBER)
      RETURN NUMBER
   IS
      v_mem_type   VARCHAR2 (3);
      mpysum       NUMBER;
      meisum       NUMBER;
      mpypct       NUMBER;
   BEGIN
      SELECT mem_type
        INTO v_mem_type
        FROM sak_memo
       WHERE mem_id = p_memid;

      IF v_mem_type IN ('FLF', 'CHC')
      THEN
         BEGIN
            SELECT NVL (SUM (mpy_amount), 0)
              INTO mpysum
              FROM sak_memo_payment, fid_payment_type
             WHERE     mpy_mem_id = p_memid
                   AND pat_code = mpy_code
                   AND pat_group = 'F';
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20422, 'Error summing DM payments');
         END;

         BEGIN
            SELECT NVL (SUM (mei_total_price), 0)
              INTO meisum
              FROM sak_memo_item
             WHERE mei_mem_id = p_memid;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20423, 'Error summing MEI amounts');
         END;

         RETURN (mpysum - meisum);
      -- ... if amounts are the same, returns 0; if a positive number is returned, payments are too much
      ELSIF v_mem_type = 'ROY'
      THEN
         BEGIN
            SELECT SUM (mpy_pct_pay)
              INTO mpypct
              FROM sak_memo_payment
             WHERE mpy_mem_id = p_memid;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20424, 'Error summing MPY percents');
         END;

         RETURN (100 - mpypct);
      ELSIF v_mem_type = 'CPD'
      THEN
         BEGIN
            SELECT NVL (SUM (mpy_amount), 0)
              INTO mpysum
              FROM sak_memo_payment, fid_payment_type
             WHERE     mpy_mem_id = p_memid
                   AND pat_code = mpy_code
                   AND pat_group = 'F';
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20425, 'Error summing DM payments');
         END;

         BEGIN
            SELECT NVL (mem_con_price, 0)
              INTO meisum
              FROM sak_memo
             WHERE mem_id = p_memid;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20426,
                                        'Error Concerning MEM amounts');
         END;

         RETURN (mpysum - meisum);
      -- ... if amounts are the same, returns 0; if a positive number is returned, payments are too much
      END IF;
   END;

   -------------------------------------------- PROCEDURE TO GET DURATION OF SEASON ----------------------------------
   PROCEDURE prc_adm_cm_getduration (i_mem_id          IN     NUMBER,
                                     i_mei_id          IN     NUMBER,
                                     o_totalduration      OUT VARCHAR2)
   AS
      l_totalduration   NUMBER := 0;
   BEGIN
      SELECT mei_duration_number
        INTO l_totalduration
        FROM sak_memo_item
       WHERE mei_mem_id = i_mem_id AND mei_id = i_mei_id;

      --AND mei_gen_refno = i_seasonnumber;
      IF (l_totalduration = 0 OR l_totalduration IS NULL)
      THEN
         o_totalduration := '0000:00:00';
      ELSE
         o_totalduration := fn_convert_duration_n_c (l_totalduration);
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END;

   -------------------------------------------- PROCEDURE TO GET PERCENT PAYMENT LOV ----------------------------------
   PROCEDURE prc_adm_cm_getpayamount (
      o_paydata OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_paydata FOR
           SELECT ser_title, mei_total_price
             FROM sak_memo_item, fid_series
            WHERE mei_gen_refno = ser_number
         ORDER BY ser_title;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END;

   -------------------------------------------- PROCEDURE TO GET SERIES - NON SERIES TITLE LOV ----------------------------------
   PROCEDURE prc_adm_cm_gettitles (
      i_isseries         IN     CHAR,
      i_sertitle         IN     VARCHAR2,
      i_type             IN     VARCHAR2,
      o_seriesdata          OUT pkg_adm_cm_dealmemo.cursor_data,
      o_genrefno            OUT NUMBER,
      o_genre               OUT VARCHAR2,
      o_subgenre            OUT VARCHAR2,
      o_event               OUT VARCHAR2,
      o_gen_duration_c      OUT VARCHAR2,
      o_type                OUT VARCHAR2)
   AS
      l_genrefno         NUMBER := 0;
      lcount             NUMBER := -1;
      l_genre            VARCHAR2 (20);
      l_subgenre         VARCHAR2 (20);
      l_event            VARCHAR2 (20);
      l_gen_duration_c   VARCHAR2 (20);
      l_type             VARCHAR2 (5);
   BEGIN
      IF ( (i_isseries = 'Y') OR (i_isseries = 'y'))
      THEN
         IF (INSTR (i_sertitle, '%') > 0)
         THEN
            -- Bioscope Changes added new columns by Anirudha 13/03/2012
            OPEN o_seriesdata FOR
                 SELECT ser_number,
                        ser_title,
                        0 gen_refno,
                        ' ' gen_type,
                        ' ' gen_title,
                        ' ' gen_category,
                        ' ' gen_subgenre,
                        ' ' gen_tertiary_genre,
                        ' ' gen_event,
                        ' ' gen_duration_c,
                        ' ' gen_bo_category_code,
                        ' ' gen_prog_category_code,
                        0 gen_bo_revenue_usd,
                        0 gen_bo_revenue_zar,
                        --Commented by nishant
                        --' ' gen_release_year
                        --Added by nishant
                        ser_com_number "gen_supplier_com_number",
                        NVL ( (SELECT com_short_name
                                 FROM fid_company
                                WHERE com_number = ser_com_number),
                             '')
                           "supplier_name",
                        ser_release_year "gen_release_year"
                   /* NVL ((SELECT mei_type_show
                           FROM sak_memo_item
                          WHERE mei_gen_refno = ser_number),
                        ''
                       ) "gen_type" */
                   --End-------
                   FROM fid_series
                  WHERE UPPER (ser_title) LIKE UPPER (i_sertitle) -- AND UPPER (ser_type) LIKE UPPER (i_type)
                        AND ser_parent_number = 0
               ORDER BY ser_title;
         ELSE
            BEGIN
               SELECT COUNT (ser_number)
                 INTO lcount
                 FROM fid_series
                WHERE UPPER (ser_title) LIKE UPPER (i_sertitle)
                      AND ser_parent_number = 0;           -- Added afterwards

               IF (lcount > 1)
               THEN
                  o_genrefno := -1;
               ELSE
                  SELECT ser_number
                    INTO l_genrefno
                    FROM fid_series
                   --Commented and modified by nishant
                   WHERE     UPPER (ser_title) LIKE UPPER (i_sertitle) --WHERE     UPPER (ser_title)= UPPER (i_sertitle)
                         AND ser_parent_number = 0         -- Added afterwards
                         AND ROWNUM = 1;

                  o_genrefno := l_genrefno;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      ELSE
         IF (INSTR (i_sertitle, '%') > 0)
         THEN
            -- Bioscope Changes added new columns by Anirudha 13/03/2012
            OPEN o_seriesdata FOR
                 SELECT 0 ser_number,
                        ' ' ser_title,
                        gen_refno,
                        gen_type,
                        gen_title,
                        gen_category,
                        gen_subgenre,
                        gen_tertiary_genre,
                        gen_event,
                        gen_duration_c,
                        gen_bo_category_code,
                        gen_prog_category_code,
                        gen_bo_revenue_usd,
                        gen_bo_revenue_zar,
                        gen_release_year                   ---Added by Nishant
                                        ,
                        gen_supplier_com_number,
                        NVL ( (SELECT com_short_name
                                 FROM fid_company
                                WHERE com_number = gen_supplier_com_number),
                             '')
                           "supplier_name"
                   FROM fid_general
                  --Commented and modified by nishant
                  WHERE UPPER (Gen_Title) LIKE UPPER (I_Sertitle) --WHERE UPPER (gen_title) = UPPER (i_sertitle)
                        --AND UPPER (gen_type) LIKE UPPER (i_type)      --15Apr2015: New Req. :Jawahar :Comented
                        AND X_FNC_GET_PROG_TYPE (gen_type) = 'N' --15Apr2015: New Req. :Jawahar :LOV should display all non-series titles
               ORDER BY gen_title;
         ELSE
            BEGIN
               SELECT COUNT (gen_refno)
                 INTO lcount
                 FROM fid_general
                WHERE UPPER (gen_title) LIKE UPPER (i_sertitle);

               IF (lcount > 1)
               THEN
                  o_genrefno := -1;
               ELSE
                  SELECT gen_refno,
                         NVL (gen_category, '-'),
                         NVL (gen_subgenre, '-'),
                         NVL (gen_event, '-'),
                         NVL (gen_duration_c, '0000:00:00'),
                         gen_type
                    INTO l_genrefno,
                         l_genre,
                         l_subgenre,
                         l_event,
                         l_gen_duration_c,
                         l_type
                    FROM fid_general
                   WHERE UPPER (gen_title) LIKE UPPER (i_sertitle)
                         AND ROWNUM = 1;

                  o_genrefno := l_genrefno;
                  o_genre := l_genre;
                  o_subgenre := l_subgenre;
                  o_event := l_event;
                  o_gen_duration_c := l_gen_duration_c;
                  o_type := l_type;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END;

   ----------------------------------------------------------------------------------------------------------------------------------------
   PROCEDURE prc_adm_cm_gettitles_supp (
      i_isseries         IN     CHAR,
      i_sertitle         IN     VARCHAR2,
      i_type             IN     VARCHAR2,
      o_seriesdata          OUT pkg_adm_cm_dealmemo.cursor_data,
      o_genrefno            OUT NUMBER,
      o_genre               OUT VARCHAR2,
      o_subgenre            OUT VARCHAR2,
      o_event               OUT VARCHAR2,
      o_gen_duration_c      OUT VARCHAR2,
      o_type                OUT VARCHAR2)
   AS
      lcount   NUMBER := -1;
   BEGIN
      IF ( (i_isseries = 'Y') OR (i_isseries = 'y'))
      THEN
         OPEN o_seriesdata FOR
              SELECT ser_number,
                     ser_title,
                     0 gen_refno,
                     ' ' gen_type,
                     ' ' gen_title,
                     ' ' gen_category,
                     ' ' gen_subgenre,
                     ' ' gen_tertiary_genre,
                     ' ' gen_event,
                     ' ' gen_duration_c,
                     ' ' gen_bo_category_code,
                     ' ' gen_prog_category_code,
                     0 gen_bo_revenue_usd,
                     0 gen_bo_revenue_zar,
                     --Commented by nishant
                     --' ' gen_release_year
                     --Added by nishant
                     ser_com_number "gen_supplier_com_number",
                     NVL ( (SELECT com_short_name
                              FROM fid_company
                             WHERE com_number = ser_com_number),
                          '')
                        "supplier_name",
                     ser_release_year "gen_release_year"
                /*
                ,NVL ((SELECT mei_type_show
                        FROM sak_memo_item
                       WHERE mei_gen_refno = ser_number), '')
                                                             "gen_type" */
                --End-------
                FROM fid_series
               WHERE UPPER (ser_title) = UPPER (i_sertitle) --AND UPPER (ser_type) LIKE UPPER (i_type)
                     AND ser_parent_number = 0
            ORDER BY ser_title;
      ELSE
         OPEN o_seriesdata FOR
              SELECT 0 ser_number,
                     ' ' ser_title,
                     gen_refno,
                     gen_type,
                     gen_title,
                     gen_category,
                     gen_subgenre,
                     gen_tertiary_genre,
                     gen_event,
                     gen_duration_c,
                     gen_bo_category_code,
                     gen_prog_category_code,
                     gen_bo_revenue_usd,
                     gen_bo_revenue_zar,
                     gen_release_year                      ---Added by Nishant
                                     ,
                     gen_supplier_com_number,
                     NVL ( (SELECT com_short_name
                              FROM fid_company
                             WHERE com_number = gen_supplier_com_number),
                          '')
                        "supplier_name"
                FROM fid_general
               --Commented and modified by nishant
               WHERE UPPER (Gen_Title) = UPPER (I_Sertitle) --WHERE UPPER (gen_title) = UPPER (i_sertitle)
                     --AND UPPER (gen_type) LIKE UPPER (i_type)                           --15Apr2015: New Req. :Jawahar :Commented
                     AND X_Fnc_Get_Prog_Type (Gen_Type) = 'N' --15Apr2015: New Req. :Jawahar :LOV should display all non-series titles
            ORDER BY gen_title;
      END IF;
   END prc_adm_cm_gettitles_supp;

   PROCEDURE prc_adm_cm_gettitles_bysupp (
      i_gen_title    IN     VARCHAR2,
      i_type         IN     VARCHAR2,
      i_com_number   IN     NUMBER,
      o_titledata       OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_titledata FOR
         SELECT 0 ser_number,
                ' ' ser_title,
                gen_refno,
                gen_type,
                gen_title,
                gen_category,
                gen_subgenre,
                gen_tertiary_genre,
                gen_event,
                gen_duration_c,
                gen_bo_category_code,
                gen_prog_category_code,
                gen_bo_revenue_usd,
                gen_bo_revenue_zar,
                gen_release_year                           ---Added by Nishant
                                ,
                gen_supplier_com_number,
                NVL ( (SELECT com_short_name
                         FROM fid_company
                        WHERE com_number = gen_supplier_com_number),
                     '')
                   "supplier_name"
           FROM fid_general
          WHERE     UPPER (gen_title) = UPPER (i_gen_title)
                AND UPPER (gen_type) = UPPER (i_type)
                AND gen_supplier_com_number = i_com_number;
   END prc_adm_cm_gettitles_bysupp;

   PROCEDURE prc_adm_cm_update_year (i_gen_title    IN     VARCHAR2,
                                     i_type         IN     VARCHAR2,
                                     i_com_number   IN     NUMBER,
                                     i_rel_year     IN     NUMBER,
                                     o_success         OUT NUMBER)
   AS
   BEGIN
      UPDATE fid_general
         SET gen_release_year = i_rel_year
       WHERE     UPPER (gen_title) = UPPER (i_gen_title)
             AND UPPER (gen_type) = UPPER (i_type)
             AND gen_supplier_com_number = i_com_number;

      o_success := 1;
      COMMIT;
   END prc_adm_cm_update_year;

   ----------------------------------------------------------------------------------------------------------------------------------------
   ----------------------------------------------------------------------------------------------------------------------------------------
   ----------------------------------------------------------------------------------------------------------------------------------------

   ------------------------------------- FUNCTION FOR CONVERTING TIME IN SECONDS ----------------------------------------------------------
   FUNCTION fn_convert_duration_c_n (p_durchar IN VARCHAR2)
      RETURN NUMBER
   IS
      duration_number   NUMBER;
   BEGIN
      duration_number :=
           (SUBSTR (p_durchar, 1, 4) * 90000)
         + (SUBSTR (p_durchar, 6, 2) * 1500)
         + (SUBSTR (p_durchar, 9, 2) * 25);
      RETURN (duration_number);
   END;

   ------------------------------------- FUNCTION FOR CONVERTING TIME IN SECONDS TO CHARACTER------------------------------------------------
   FUNCTION fn_convert_duration_n_c (p_durnumber IN NUMBER)
      RETURN VARCHAR2
   IS
      duration_char   VARCHAR2 (11);
   BEGIN
      IF NVL (p_durnumber, 0) != 0
      THEN
         duration_char :=
            LTRIM (TO_CHAR (FLOOR (p_durnumber / 90000), '0009')) || ':'
            || LTRIM (
                  TO_CHAR (FLOOR (MOD (p_durnumber, 90000) / 1500), '09'))
            || ':'
            || LTRIM (TO_CHAR (FLOOR (MOD (p_durnumber, 1500) / 25), '09'));
      END IF;

      RETURN (duration_char);
   END;

   ------------------------------------- PROCEDURE FOR SEARCH PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_dm_prog_search (
      i_mem_id                       IN     NUMBER,
      I_CON_SHORT_NAME               IN VARCHAR2,
      o_deal_memo_prog_details          OUT c_deal_memo_prog_details,
      o_dm_prog_alloc_details           OUT c_deal_memo_prog_details1,
      o_dm_prog_cha_cost_details        OUT c_deal_memo_prog_details2,
      /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added 2 new cursor which will return the values for catchup licensee grid */
      o_catchup_prog_alloc_details      OUT c_deal_memo_prog_details3,
      o_catchup_platform_details        OUT c_deal_memo_prog_details4,
      /* FINANCE (CFIN 3) :Pranay Kusumwal 22/02/2013 :Added  new cursor which will return the values for secondary licensee grid */
      o_sec_lee_alloc_details           OUT c_deal_memo_prog_details --CACQ14:Start : Sushma K 19-NOV-2014 : Added new cursor to return the media device rights which are present on media device and service maintenence
                                                                    ,
      o_catchup_med_rights_details      OUT c_deal_memo_prog_details,
      --END
       --Dev.R1: CatchUp for All :[10. BR_15_272_UC_Super Stacking]_[Milan Shah]_[2015/12/24]: Start
      O_SUPERSTACK_RIGHTS               OUT SYS_REFCURSOR)
      --Dev.R1: CatchUp for All: End                                                              )
   AS
      no_season_for_series   EXCEPTION;
      l_string               CLOB;
      l_string1              CLOB;
      l_string2              CLOB;
      l_string_memo          CLOB;
      l_string_med           CLOB;
      l_con_number           NUMBER;
      l_mem_status           VARCHAR2 (20);
      l_mem_date             DATE;
      l_catchup_date         DATE;
      l_is_cp_flag           VARCHAR2 (1);
      l_mem_status_date      DATE;
      l_media_service        VARCHAR2 (10);
   BEGIN
      BEGIN
         SELECT TO_DATE (content)
           INTO l_catchup_date
           FROM x_fin_configs
          WHERE key = 'CATCH-UP_LIVE_DATE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_catchup_date := SYSDATE;
      END;



      --CACQ14: Start: Sushma K : 20-NOV-2014: Added to get the contract number for that deal
      BEGIN
         SELECT NVL (MEM_CON_NUMBER, 0),
                mem_status,
                mem_date,
                NVL (mem_status_Date, SYSDATE)
           INTO l_con_number,
                l_mem_status,
                l_mem_date,
                l_mem_status_date
           FROM sak_memo
          WHERE MEM_ID = i_mem_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_con_number := 0;
      END;

      --Below coded added to view past executed deal with old catchup platform details only.
      IF l_mem_status = 'EXECUTED' AND l_mem_status_date <= l_catchup_date
      THEN
         l_is_cp_flag := 'Y';
      END IF;

      -- end
      ----------------------------------------------------------------------------------------for program details
      OPEN o_deal_memo_prog_details FOR
         SELECT mei_id,
                mei_gen_refno,
                gen_title,
                'NON SERIES' series,
                mei_type_show,
                NVL (cod_attr1, 'N') seryorn,
                NVL (cod_attr2, 'N') liveyorn,
                NVL (gen_category, '-') gen_category,
                NVL (gen_subgenre, '-') gen_subgenre,
                NVL (gen_event, '-') gen_event,
                fn_convert_duration_n_c (gen_duration) derived_time,
                mei_total_price,
                mei_update_count,
                -1 AS cntepi -- Bioscope Changes Added new field by Anirudha on 13/03/2012
                            ,
                TO_CHAR (gen_release_year) gen_release_year,
                l_mem_status mem_status,
                l_mem_status_date mem_status_Date,
                gen_prog_category_code,
                gen_bo_category_code,
                TO_CHAR (gen_bo_revenue_usd) gen_bo_revenue_usd,
                TO_CHAR (gen_bo_revenue_zar) gen_bo_revenue_zar,
                gen_tertiary_genre                 --Added By Pravin_201301012
                                  ,
                (SELECT con_catchup_flag
                   FROM sak_memo, fid_contract                --,sak_memo_item
                  WHERE con_number = mem_con_number AND mem_id = i_mem_id --AND MEI_MEM_ID = MEM_ID
                                                                         )
                   catchup_flag,
                mei_premium_flag,
                mei_is_t_exec --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
                             ,
                X_FNC_GET_SCH_INFO (gen_refno) on_sch_flag
				-- ADDED By Pravin to get FLAGs
                ,gen_svod_rights
                ,'0' ser_sea_number
                ,GEN_ARCHIVE
                ,gen_express
                ,GEN_CATALOGUE
				--Pravin End
           --RDT End : Acquision Requirements BR_15_104
           --End
           FROM sak_memo_item, fid_general, fid_code
          WHERE     mei_gen_refno = gen_refno
                AND cod_type = 'GEN_TYPE'      -- AND gen_type = mei_type_show
                AND cod_value = mei_type_show
                And Mei_Mem_Id = I_Mem_Id          --------for program details
                and nvl(cod_attr1,'N') = 'N'
         UNION
         SELECT DISTINCT
                mei_id,
                mei_gen_refno,
                gen_title,
                series,
                mei_type_show,
                seryorn,
                liveyorn,
                NVL (gen_category, '-') gen_category,
                NVL (gen_subgenre, '-') gen_subgenre,
                NVL (gen_event, '-') gen_event,
                derived_time,
                mei_total_price,
                mei_update_count,
                cntepi,
                -- Commented by nishant
                /*(SELECT TO_CHAR (MAX (gen_release_year))
                   FROM fid_general
                  WHERE gen_ser_number = mei_gen_refno)
                   gen_release_year, */
                --Added by nishant
                TO_CHAR (gen_release_year) gen_release_year,
                l_mem_status mem_status,
                l_mem_status_date mem_status_Date,
                (SELECT TO_CHAR (MAX (gen_prog_category_code))
                   FROM fid_general
                  WHERE gen_ser_number = mei_gen_refno)
                   gen_prog_category_code,
                (SELECT TO_CHAR (MAX (gen_bo_category_code))
                   FROM fid_general
                  WHERE gen_ser_number = mei_gen_refno)
                   gen_bo_category_code,
                (SELECT TO_CHAR (MAX (gen_bo_revenue_usd))
                   FROM fid_general
                  WHERE gen_ser_number = mei_gen_refno)
                   gen_bo_revenue_usd,
                (SELECT TO_CHAR (MAX (gen_bo_revenue_zar))
                   FROM fid_general
                  WHERE gen_ser_number = mei_gen_refno)
                   gen_bo_revenue_zar                 ----,'' gen_release_year
                                     ----,'' gen_prog_category_code
                                     ----,'' gen_bo_category_code
                                     ----,'' gen_bo_revenue_usd
                                     ----,'' gen_bo_revenue_zar
                ,
                NVL (gen_tertiary_genre, '_') gen_tertiary_genre --Added By Pravin_201301012
                                                                ,
                (SELECT con_catchup_flag
                   FROM sak_memo, fid_contract                --,sak_memo_item
                  WHERE con_number = mem_con_number AND mem_id = i_mem_id --AND MEI_MEM_ID = MEM_ID
                                                                         )
                   catchup_flag,
                mei_premium_flag,
                mei_is_t_exec                                            --End
     --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
                ,
                on_sch_flag
           --RDT End : Acquision Requirements BR_15_104
                ,decode(gen_svod_rights,null,ser_svod_rights,gen_svod_rights)
                ,ser_sea_number
                ,GEN_ARCHIVE -- ADDED By Pravin to get Archive FLAG
                ,gen_express
                ,GEN_CATALOGUE
           FROM (SELECT DISTINCT
                        mei_id,
                        mei_gen_refno,
                        fs.ser_title gen_title,
                        --Added by Nishant
                        fs.ser_release_year gen_release_year,
                        NVL ( (SELECT ser_title
                                 FROM fid_series
                                WHERE ser_number = fs.ser_parent_number),
                             '')
                           series                      -- fs1.ser_title series
                                 ,
                        mei_type_show,
                        NVL (cod_attr1, 'N') seryorn,
                        NVL (cod_attr2, 'N') liveyorn,
                        fn_convert_duration_n_c (mei_duration_number)
                           derived_time,
                        mei_total_price,
                        mei_update_count,
                        NVL ( (SELECT COUNT (1)
                                 FROM fid_general
                                WHERE gen_ser_number = mei_gen_refno),
                             0)
                           cntepi,
                        mei_premium_flag,
                        mei_is_t_exec --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
                                     ,
                        X_FNC_GET_SCH_INFO (mei_gen_refno) on_sch_flag
						--RDT End : Acquision Requirements BR_15_104
						--Added By Pravin to get Archive and SVOD RIGHTS
             ,ser_svod_rights
             ,ser_sea_number
						/*,(	select GEN_ARCHIVE
							from fid_general
							where ser_number = gen_ser_number(+)
						) GEN_ARCHIVE
						,(	select GEN_EXPRESS
							from fid_general
							where ser_number = gen_ser_number(+)
						) GEN_EXPRESS
            ,(	select GEN_CATALOGUE
							from fid_general
							where ser_number = gen_ser_number(+)
						) gen_catalogue */

						--Pravin END
                   FROM sak_memo_item
						, fid_series fs
						, fid_code
                  WHERE     mei_gen_refno = fs.ser_number(+)
                        --------for series details
                        AND cod_type = 'GEN_TYPE'
                        And Cod_Value = Mei_Type_Show
                        and nvl(cod_attr1,'N') = 'Y'
                        -- AND fs1.ser_number = fs.ser_parent_number
                        AND mei_mem_id = i_mem_id) a,
                (  SELECT gen_ser_number,
                          COUNT (DISTINCT NVL (gen_category, '-')),
                          CASE
                             WHEN COUNT (DISTINCT NVL (gen_category, '-')) > 1
                             THEN
                                'VARIOUS'
                             ELSE
                                gen_category
                          END
                             gen_category,
                          COUNT (DISTINCT NVL (gen_subgenre, '-')),
                          CASE
                             WHEN COUNT (DISTINCT NVL (gen_subgenre, '-')) > 1
                             THEN
                                'VARIOUS'
                             ELSE
                                gen_subgenre
                          END
                             gen_subgenre,
                          COUNT (DISTINCT NVL (gen_event, '-')),
                          CASE
                             WHEN COUNT (DISTINCT NVL (gen_event, '-')) > 1
                             THEN
                                'VARIOUS'
                             ELSE
                                gen_event
                          END
                             gen_event,
                          COUNT (DISTINCT NVL (gen_tertiary_genre, '-')),
                          CASE
                             WHEN COUNT (
                                     DISTINCT NVL (gen_tertiary_genre, '-')) >
                                     1
                             THEN
                                'VARIOUS'
                             ELSE
                                gen_tertiary_genre
                          END
                             gen_tertiary_genre ,
                             gen_svod_rights,
                             GEN_ARCHIVE,
                             gen_express,
                             GEN_CATALOGUE
                     FROM fid_general
                    WHERE gen_ser_number IN (SELECT mei_gen_refno
                                               FROM sak_memo_item
                                              WHERE mei_mem_id = i_mem_id)
                 GROUP BY gen_ser_number,
                          gen_category,
                          gen_subgenre,
                          gen_svod_rights,
                          GEN_ARCHIVE,
                          gen_express,
                          GEN_CATALOGUE,
                          gen_event,
                          gen_tertiary_genre) b
          WHERE a.mei_gen_refno = b.gen_ser_number(+);

      ------------------------------------------------------------------------------------for allocation details
      OPEN o_dm_prog_alloc_details FOR
         SELECT ald_id,
                ald_mei_id,
                lee_short_name lee,
                ald_amount allocation,
                ald_exhib_days chs_runs,
                ald_black_days,
                '' cha_ser_name,
                ald_chs_number,
                ald_period_tba,
                ald_lic_type,
                ald_period_start,
                ald_period_end,
                ald_months,
                ald_end_days,
                ald_cost_runs,
                ald_max_runs_chs,
                ald_max_runs_cha,
                cha_short_name,
                ald_update_count,
                ald_lee_number,
                lee_bioscope_flag,
                ---------------Dev:Africa free repeat:Hari_18-03-2013--------------------
                --------------adding columns for free repeats and repeat period---------
                ald_free_repeat,
                ald_repeat_period,
                ---------------END Dev:Africa free repeat--------------------------------
                ald_is_t_exec,
                ALD_MIN_GUA_FLAG
           FROM sak_allocation_detail,
                sak_memo_item,
                sak_memo,
                fid_licensee,
                fid_channel
          WHERE     ald_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND lee_number = ald_lee_number
                AND ald_chs_number = cha_number
                AND mei_mem_id = i_mem_id
                AND NOT EXISTS
                           (SELECT 'X'
                              FROM fid_channel
                             WHERE cha_number IN
                                      (SELECT chs_number
                                         FROM fid_channel_service
                                        WHERE chs_number = ald_chs_number))
         UNION
         SELECT ald_id,
                ald_mei_id,
                lee_short_name lee,
                ald_amount allocation,
                ald_exhib_days chs_runs,
                ald_black_days,
                chs_short_name cha_ser_name,
                ald_chs_number,
                ald_period_tba,
                ald_lic_type,
                ald_period_start,
                ald_period_end,
                ald_months,
                ald_end_days,
                ald_cost_runs,
                ald_max_runs_chs,
                ald_max_runs_cha,
                '' cha_short_name,
                ald_update_count,
                ald_lee_number,
                lee_bioscope_flag,
                ---------------Dev:Africa free repeat:Hari_18-03-2013--------------------
                --------------adding columns for free repeats and repeat period---------
                ald_free_repeat,
                ald_repeat_period,
                ---------------END Dev:Africa free repeat--------------------------------
                ald_is_t_exec,
                ALD_MIN_GUA_FLAG
           FROM sak_allocation_detail,
                sak_memo_item,
                sak_memo,
                fid_licensee,
                fid_channel_service
          WHERE     ald_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND lee_number = ald_lee_number
                AND ald_chs_number = chs_number
                AND mei_mem_id = i_mem_id;

      /*SELECT DISTINCT ald_id, ald_mei_id, lee, allocation, chs_runs,
                      ald_black_days, cha_ser_name, ald_chs_number,
                      ald_period_tba, ald_lic_type, ald_period_start,
                      ald_period_end, ald_months, ald_end_days,
                      ald_cost_runs, ald_max_runs_chs, ald_max_runs_cha,
                      cha_ser_name, '' cha_name, ald_update_count
                 FROM (SELECT DISTINCT ald_id, ald_mei_id,
                                       lee_short_name lee,
                                       ald_amount allocation,
                                       ald_exhib_days chs_runs,
                                       ald_black_days, ald_chs_number,
                                       ald_period_tba, ald_lic_type,
                                       ald_period_start, ald_period_end,
                                       ald_months, ald_end_days,
                                       ald_cost_runs, ald_max_runs_chs,
                                       ald_max_runs_cha, ald_update_count
                                  FROM sak_memo_item,
                                       sak_allocation_detail,
                                       fid_licensee,
                                       fid_general,
                                       fid_channel,
                                       fid_company
                                 WHERE lee_cha_com_number = com_number
                                   AND com_type = 'CC'
                                   AND lee_number = ald_lee_number
                                   AND mei_id = ald_mei_id
                                   AND mei_gen_refno = gen_refno
                                   AND mei_mem_id = i_mem_id
                       UNION
                       SELECT DISTINCT ald_id, ald_mei_id,
                                       lee_short_name lee,
                                       ald_amount allocation,
                                       ald_exhib_days chs_runs,
                                       ald_black_days, ald_chs_number,
                                       ald_period_tba, ald_lic_type,
                                       ald_period_start, ald_period_end,
                                       ald_months, ald_end_days,
                                       ald_cost_runs, ald_max_runs_chs,
                                       ald_max_runs_cha, ald_update_count
                                  FROM sak_memo_item,
                                       sak_allocation_detail,
                                       fid_licensee,
                                       fid_channel,
                                       fid_series fs,
                                       fid_general,
                                       fid_company
                                 WHERE lee_cha_com_number = com_number
                                   AND com_type = 'CC'
                                   AND lee_number = ald_lee_number
                                   AND mei_id = ald_mei_id
                                   AND mei_gen_refno = fs.ser_number
                                   AND fs.ser_number = gen_ser_number
                                   AND fs.ser_parent_number <> 0
                                   AND mei_mem_id = i_mem_id) a,
                      (SELECT chs_number, chs_short_name cha_ser_name,
                              '' cha_name
                         FROM fid_channel_service) b
                WHERE a.ald_chs_number = b.chs_number
      UNION
      SELECT DISTINCT ald_id, ald_mei_id, lee, allocation, chs_runs,
                      ald_black_days, cha_ser_name, ald_chs_number,
                      ald_period_tba, ald_lic_type, ald_period_start,
                      ald_period_end, ald_months, ald_end_days,
                      ald_cost_runs, ald_max_runs_chs, ald_max_runs_cha,
                      cha_ser_name, cha_name, ald_update_count
                 FROM (SELECT DISTINCT ald_id, ald_mei_id,
                                       lee_short_name lee,
                                       ald_amount allocation,
                                       ald_exhib_days chs_runs,
                                       ald_black_days, ald_chs_number,
                                       ald_period_tba, ald_lic_type,
                                       ald_period_start, ald_period_end,
                                       ald_months, ald_end_days,
                                       ald_cost_runs, ald_max_runs_chs,
                                       ald_max_runs_cha, ald_update_count
                                  FROM sak_memo_item,
                                       sak_allocation_detail,
                                       fid_licensee,
                                       fid_general,
                                       fid_channel,
                                       fid_company
                                 WHERE lee_cha_com_number = com_number
                                   AND com_type = 'CC'
                                   AND lee_number = ald_lee_number
                                   AND mei_id = ald_mei_id
                                   AND mei_gen_refno = gen_refno
                                   AND mei_mem_id = i_mem_id
                       UNION
                       SELECT DISTINCT ald_id, ald_mei_id,
                                       lee_short_name lee,
                                       ald_amount allocation,
                                       ald_exhib_days chs_runs,
                                       ald_black_days, ald_chs_number,
                                       ald_period_tba, ald_lic_type,
                                       ald_period_start, ald_period_end,
                                       ald_months, ald_end_days,
                                       ald_cost_runs, ald_max_runs_chs,
                                       ald_max_runs_cha, ald_update_count
                                  FROM sak_memo_item,
                                       sak_allocation_detail,
                                       fid_licensee,
                                       fid_channel,
                                       fid_series fs,
                                       fid_general,
                                       fid_company
                                 WHERE lee_cha_com_number = com_number
                                   AND com_type = 'CC'
                                   AND lee_number = ald_lee_number
                                   AND mei_id = ald_mei_id
                                   AND mei_gen_refno = fs.ser_number
                                   AND fs.ser_number = gen_ser_number
                                   AND fs.ser_parent_number <> 0
                                   AND mei_mem_id = i_mem_id) a,
                      (SELECT cha_number, '' cha_ser_name,
                              cha_short_name cha_name
                         FROM fid_channel) b
                WHERE a.ald_chs_number = b.cha_number;*/

      ---------------------------------------------------------------------------------------------for cha runs and cost details
      OPEN o_dm_prog_cha_cost_details FOR
         SELECT chr_id,
                chr_ald_id,
                cha_short_name cha,
                chr_number_runs runs,
                chr_cost_channel COST,
                chr_costed_runs                         --Bioscope Changes end
                               /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
                ,
                chr_max_runs_chr                             /*PB (CR): END */
                                ,
                chr_update_count /* ISSUE:-0055552:Pranay Kusumwal 27/12/2012 : Added for Mantis ID:-0055552 */
                                ,
                cha_roy_flag /* ISSUE:-0055552:Pranay Kusumwal 27/12/2012 : end */
                            ,
                chr_is_t_exec
           FROM sak_channel_runs,
                sak_allocation_detail,
                sak_memo_item,
                sak_memo,
                fid_channel
          WHERE     ald_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND ald_id = chr_ald_id
                AND cha_number = chr_cha_number
                AND mei_mem_id = i_mem_id;

      /*SELECT DISTINCT chr_id, chr_ald_id, cha_short_name cha,
                      chr_number_runs runs, chr_cost_channel COST,
                      chr_update_count
                 FROM sak_memo_item,
                      sak_allocation_detail,
                      fid_general,
                      sak_channel_runs,
                      fid_channel
                WHERE mei_id = ald_mei_id
                  AND mei_gen_refno = gen_refno
                  AND ald_id = chr_ald_id
                  AND cha_number = chr_cha_number
                  AND mei_mem_id = i_mem_id
      ----for program cha runs cost details
      UNION
      SELECT DISTINCT chr_id, chr_ald_id, cha_short_name cha,
                      chr_number_runs runs, chr_cost_channel COST,
                      chr_update_count
                 FROM sak_memo_item,
                      sak_allocation_detail,
                      fid_channel,
                      sak_channel_runs,
                      fid_series fs,
                      fid_general
                WHERE mei_id = ald_mei_id
                  AND mei_gen_refno = fs.ser_number
                  AND fs.ser_number = gen_ser_number
                  AND ald_id = chr_ald_id
                  AND cha_number = chr_cha_number
                  AND fs.ser_parent_number <> 0
                  AND mei_mem_id = i_mem_id;*/
      -----------for series cha runs cost details

      /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new cursor which will return the values for catchup licensee grid */
      OPEN o_catchup_prog_alloc_details FOR
         /* SELECT ald_id, ald_mei_id, lee_short_name lee, ald_amount allocation,
                 ald_exhib_days max_vp, ald_period_tba, ald_lic_type,
                 ald_period_start, ald_period_end, ald_months, ald_end_days,
                 ald_cost_runs costed_vp,
                 cha_short_name, ald_update_count, ald_lee_number,ALD_MAX_VP,ALD_NON_CONS_MONTH
            FROM sak_allocation_detail,
                 sak_memo_item,
                 sak_memo,
                 fid_licensee--,
                 --fid_channel
           WHERE ald_mei_id = mei_id
             AND mei_mem_id = mem_id
             AND lee_number = ald_lee_number
             --AND ald_chs_number = cha_number
             AND mei_mem_id = i_mem_id
             AND nvl(lee_media_service_code,'#') ='CATCHUP'
           --  AND NOT EXISTS ( SELECT 'X' FROM fid_channel where cha_number in ( select chs_number from fid_channel_service where chs_number=ald_chs_number))
          UNION */
         SELECT ald_id,
                ald_mei_id,
                LEE_SHORT_NAME LEE,
                LEE_MEDIA_SERVICE_CODE, --[22-jun-2015] [Jawahar.garg]-Added for 3rd party cp
                ald_amount allocation,
                ald_exhib_days max_vp,
                ald_period_tba,
                ald_lic_type,
                ald_period_start,
                ald_period_end,
                ald_months,
                ald_end_days,
                ald_cost_runs costed_vp,
                '' cha_short_name,
                ald_update_count,
                ald_lee_number,
                ald_max_vp,
                ald_non_cons_month,
                ald_is_t_exec --CACQ14:Start : added by sushma for newly added fileds on 07-NOV-2014
                             ,
                ALD_ALLOW_BEFORE_LNR,
                ALD_ALLOW_DAYS_BEFORE_LNR,
                ALD_ALLOW_WITHOUT_LNR_REF,
                (CASE
                    WHEN (SELECT COUNT (1)
                            FROM x_cp_memo_medplatdevcompat_map
                           WHERE MEM_MPDC_ALD_ID = ald_id) > 0
                    THEN
                       'Y'
                    ELSE
                       'N'
                 END)
                   Med_Device_Rights_flag
           --CACQ14: END
           FROM sak_allocation_detail,
                sak_memo_item,
                sak_memo,
                fid_licensee
          --fid_channel_service
          WHERE     ald_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND lee_number = ald_lee_number
                --AND ald_chs_number = chs_number
                --  AND NVL (lee_media_service_code, '#') in ( 'CATCHUP','SVOD')
                AND NVL (lee_media_service_code, '#') IN
                       (SELECT ms_media_service_code
                          FROM sgy_pb_media_service
                         WHERE ms_media_service_code NOT IN ('PAYTV', 'TVOD'))
                AND mei_mem_id = i_mem_id;

      BEGIN
         SELECT DISTINCT lee_media_service_code
           INTO l_media_service
           FROM sak_allocation_detail,
                sak_memo_item,
                sak_memo,
                fid_licensee
          --fid_channel_service
          WHERE     ald_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND lee_number = ald_lee_number
                --AND ald_chs_number = chs_number
                --  AND NVL (lee_media_service_code, '#') in ( 'CATCHUP','SVOD')
                AND NVL (lee_media_service_code, '#') IN
                       (SELECT ms_media_service_code
                          FROM sgy_pb_media_service
                         WHERE ms_media_service_code NOT IN ('PAYTV', 'TVOD'))
                AND mei_mem_id = i_mem_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF l_is_cp_flag = 'Y'
      THEN
         OPEN o_catchup_platform_details FOR
              SELECT ald_id cp_lee_plat_ald_id,
                     mpsm_mapp_id,
                     mpsm_mapp_service_code,
                     mpsm_mapp_platform_code,
                     (SELECT cp_lee_plat_id
                        FROM x_cp_licensee_platform
                       WHERE cp_lee_plat_ald_id = ald_id
                             AND cp_lee_plat_mpsm_mapp_id = mpsm_mapp_id)
                        cp_lee_plat_id,
                     (SELECT cp_lee_plat_is_t_exec
                        FROM x_cp_licensee_platform
                       WHERE cp_lee_plat_ald_id = ald_id
                             AND cp_lee_plat_mpsm_mapp_id = mpsm_mapp_id)
                        mpsm_is_t_exec
                FROM sak_allocation_detail,
                     sak_memo_item,
                     fid_licensee,
                     sgy_pb_med_platm_service_map
               WHERE     ald_mei_id = mei_id
                     AND ald_lee_number = lee_number
                     AND mei_mem_id = i_mem_id
                     AND mpsm_mapp_service_code = 'CATCHUP'
                     AND NVL (lee_media_service_code, '#') = 'CATCHUP'
            ORDER BY ald_id, cp_lee_plat_ald_id;
      ELSE
         --CACQ14:Start : Sushma K 19-NOV-2014 :Added new cursor to return the media device rights at deal level and parent level
         l_string_memo :=
            'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.MEM_RIGHTS_ON_DEVICE,
                            a.MEM_MPDC_DEV_PLATM_ID,
                            a.MEM_MPDC_ALD_ID,
                            ';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_UI_SEQ)
         LOOP
            l_string_memo :=
                  l_string_memo
               || 'NVL( ( select  (case when MEM_MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and MEM_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_memo_medplatdevcompat_map b,x_cp_media_dev_platm_map  where MEM_MPDC_DEV_PLATM_ID = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MEM_MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || '''  and MEM_MPDC_ALD_ID = a.MEM_MPDC_ALD_ID),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,';
         END LOOP;

         l_string_memo :=
            l_string_memo
            || 'a.MEM_MPDC_UPDATE_COUNT  from (select MDP_MAP_DEV_ID,
                                            (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                            (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            MEM_RIGHTS_ON_DEVICE
                                            ,MEM_MPDC_DEV_PLATM_ID
                                            ,SUM(MEM_MPDC_UPDATE_COUNT) MEM_MPDC_UPDATE_COUNT,MEM_MPDC_ALD_ID
                                          from   x_cp_memo_medplatdevcompat_map,x_cp_media_dev_platm_map ,
                                                 sak_allocation_detail,sak_memo_item
                                          where MEM_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                            and MEM_MPDC_ALD_ID = ALD_ID
                                            and ALD_MEI_ID = MEI_ID
                                            and MEI_MEM_ID = '''
            || i_mem_id
            || '''
                                           group by MDP_MAP_DEV_ID
                                                    ,MDP_MAP_PLATM_CODE
                                                    ,MEM_MPDC_DEV_PLATM_ID
                                                    --MEM_MPDC_UPDATE_COUNT
                                                    ,MEM_MPDC_ALD_ID,MEM_RIGHTS_ON_DEVICE

                                                 )a';
         l_string_med := 'UNION select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.RIGHTS_ON_DEVICE,
                            a.MPDC_DEV_PLATM_ID,
                            0 MEM_MPDC_ALD_ID,';

         IF UPPER (l_mem_status) = 'EXECUTED'
         THEN
            FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                          FROM x_cp_media_device_compat
                      ORDER BY MDC_UI_SEQ)
            LOOP
               l_string_med :=
                     l_string_med
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

            l_string_med :=
               l_string_med
               || 'a.MPDC_UPDATE_COUNT  from (select
                                            MDP_MAP_DEV_ID,
                                            (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                            (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            ''N'' RIGHTS_ON_DEVICE
                                            ,MPDC_DEV_PLATM_ID
                                            ,SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT,0 MEM_MPDC_ALD_ID
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                                and MPDCS_MED_SERVICE_CODE = '''
               || l_media_service
               || '''
                                                AND MDP_ENTRY_DATE <= '''
               || l_mem_status_date
               || '''
                                                group by  MDP_MAP_DEV_ID
                                                    ,MDP_MAP_PLATM_CODE
                                                    ,MPDC_DEV_PLATM_ID
                                                   -- ,MPDC_UPDATE_COUNT
                                                 )a';
         ELSE
            FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                          FROM x_cp_media_device_compat
                      ORDER BY MDC_UI_SEQ)
            LOOP
               l_string_med :=
                     l_string_med
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

            l_string_med :=
               l_string_med
               || 'a.MPDC_UPDATE_COUNT  from (select
                                            MDP_MAP_DEV_ID,
                                            (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                            (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            ''N'' RIGHTS_ON_DEVICE
                                            ,MPDC_DEV_PLATM_ID
                                            ,SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT,0 MEM_MPDC_ALD_ID
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                                and MPDCS_MED_SERVICE_CODE = '''
               || l_media_service
               || '''
                                                group by  MDP_MAP_DEV_ID
                                                    ,MDP_MAP_PLATM_CODE
                                                    ,MPDC_DEV_PLATM_ID
                                                   -- ,MPDC_UPDATE_COUNT
                                                 )a';
         END IF;

         l_string := l_string_memo || ' ' || l_string_med;

        --  DBMS_OUTPUT.PUT_LINE(l_string);

         OPEN o_catchup_platform_details FOR l_string;
      END IF;

      --Below cursor is return the values which are media rights are present on media device and service maintenence.

      IF l_con_number = 0
      THEN
         l_string := 'select a.Med_dev_code,
                              a.Med_dev_desc,
                              a.med_platm_code,
                              a.med_platm_desc,
                              a.Rights_On_device,
                              a.CON_IS_FEA_SER,
                              a.MPDC_DEV_PLATM_ID,';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_UI_SEQ)
         LOOP
            l_string :=
                  l_string
               || 'NVL( ( select  (case when MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || '''  ),''N'')   '
               || i.MDC_CODE
               || '_Media_Rights ,';
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
                                             '' ''  CON_IS_FEA_SER
                                          from  x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map,x_cp_medplatdevcomp_servc_map
                                          where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                          and   MPDCS_MPDC_ID  =  MPDC_ID
                                          and MPDCS_MED_SERVICE_CODE = '''
            || l_media_service
            || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a';
      ELSE
         l_string1 := 'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.Rights_On_device,
                            a.CON_IS_FEA_SER,
                            a.MPDC_DEV_PLATM_ID
                            ,';

         FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                       FROM x_cp_media_device_compat
                   ORDER BY MDC_UI_SEQ)
         LOOP
            l_string1 :=
                  l_string1
               || 'NVL( ( select  (case when CON_MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and CON_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_con_medplatmdevcompat_map b,x_cp_media_dev_platm_map  where CON_MPDC_DEV_PLATM_ID = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.CON_MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || ''' and CON_IS_FEA_SER = a.CON_IS_FEA_SER and CON_CONTRACT_NUMBER = '''
               || l_con_number
               || '''),''N'')   '
               || i.MDC_CODE
               || '_Media_Rights ,';
         END LOOP;

         l_string1 :=
            l_string1
            || 'a.CON_MPDC_UPDATE_COUNT  from (select MDP_MAP_DEV_ID,
                                           (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            CON_RIGHTS_ON_DEVICE Rights_On_device,
                                            CON_IS_FEA_SER
                                            ,CON_MPDC_DEV_PLATM_ID MPDC_DEV_PLATM_ID
                                            ,SUM(CON_MPDC_UPDATE_COUNT) CON_MPDC_UPDATE_COUNT
                                          from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = '''
            || l_con_number
            || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,CON_IS_FEA_SER,CON_RIGHTS_ON_DEVICE,CON_MPDC_DEV_PLATM_ID

                                                 )a';
         l_string2 := 'UNION select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.RIGHTS_ON_DEVICE,
                            a.IS_FEA_SER,
                            a.MPDC_DEV_PLATM_ID,
                            ';

         IF UPPER (l_mem_status) = 'EXECUTED'
         THEN
            FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                          FROM x_cp_media_device_compat
                      ORDER BY MDC_UI_SEQ)
            LOOP
               l_string2 :=
                     l_string2
                  || 'NVL( ( select  (case when MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''),''N'')   '
                  || i.MDC_CODE
                  || '_Media_Rights ,';
            END LOOP;

            l_string2 :=
               l_string2
               || 'a.MPDC_UPDATE_COUNT  from (select MDP_MAP_DEV_ID,
                                           (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            '' '' RIGHTS_ON_DEVICE,
                                            '' '' IS_FEA_SER
                                            ,MPDC_DEV_PLATM_ID
                                            ,SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                                and MPDCS_MED_SERVICE_CODE = '''
               || l_media_service
               || '''
                                                 AND MDP_ENTRY_DATE <= '''
               || l_mem_status_date
               || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                 )a';
         ELSE
            FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                          FROM x_cp_media_device_compat
                      ORDER BY MDC_UI_SEQ)
            LOOP
               l_string2 :=
                     l_string2
                  || 'NVL( ( select  (case when MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || ''' and MPDC_IS_COMP_RIGHTS = ''Y'' then ''Y'' else ''N'' end) from x_cp_med_platm_dev_compat_map b,x_cp_media_dev_platm_map  where MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID and MDP_MAP_DEV_ID = a.MDP_MAP_DEV_ID and MDP_MAP_PLATM_CODE = a.med_platm_code and b.MPDC_COMP_RIGHTS_ID = '''
                  || i.MDC_ID
                  || '''),''N'')   '
                  || i.MDC_CODE
                  || '_Media_Rights ,';
            END LOOP;

            l_string2 :=
               l_string2
               || 'a.MPDC_UPDATE_COUNT  from (select MDP_MAP_DEV_ID,
                                           (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                           (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            '' '' RIGHTS_ON_DEVICE,
                                            '' '' IS_FEA_SER
                                            ,MPDC_DEV_PLATM_ID
                                            ,SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                               and MPDCS_MED_SERVICE_CODE = '''
               || l_media_service
               || '''
                                                -- AND MDP_ENTRY_DATE <= '''
               || l_mem_date
               || '''
                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                 )a';
         END IF;

         l_string := l_string1 || ' ' || l_string2;
      END IF;

      --      dbms_output.put_line(l_string);

      OPEN o_catchup_med_rights_details FOR l_string;

      --END

      /*
          SELECT  MPSM_MAPP_SERVICE_CODE,
                MPSM_MAPP_PLA
          ,
          (        select 'Y'
                from    X_CP_LICENSEE_PLATFORM,
                sak_allocation_detail,
                sak_memo_item,
                sak_memo
                where  MPSM_MAPP_ID=CP_LEE_PLAT_MPSM_MAPP_ID
                and    CP_LEE_PLAT_ALD_ID=ald_id
                and     ald_mei_id = mei_id
                AND     mei_mem_id = mem_id
          and     mei_mem_id = i_mem_id
                ) Check_flag
          ,CP_LEE_PLAT_ALD_ID
          ,CP_LEE_PLAT_ID
          from   sgy_pb_med_platm_service_map,
                X_CP_LICENSEE_PLATFORM
          where MPSM_MAPP_SERVICE_CODE ='CATCHUP'
          and   MPSM_MAPP_ID=CP_LEE_PLAT_MPSM_MAPP_ID(+)
            order by mpsm_mapp_service_code,mpsm_mapp_platform_code; */

      /* Catchup (CR 3) :END */
      /* FINANCE (CFIN 3) :Pranay Kusumwal 22/02/2013 :Start*/
      ------------------------------------------------------------------------------------for Secondary licensee allocation details
      OPEN o_sec_lee_alloc_details FOR
         SELECT dsl_number,
                dsl_mei_id,
                dsl_lee_number,
                (SELECT lee_short_name
                   FROM fid_licensee
                  WHERE lee_number = a.dsl_lee_number)
                   lee_short_name,
                dsl_is_primary,
                dsl_amount,
                dsl_update_count,
                dsl_primary_lee,
                dsl_is_t_exec
           FROM x_fin_dm_sec_lee a, sak_memo_item, sak_memo
          WHERE     dsl_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND mei_mem_id = i_mem_id
                AND NVL (DSL_IS_PRIMARY, '#') <> 'Y';


        IF I_CON_SHORT_NAME=''  OR  I_CON_SHORT_NAME IS NULL THEN

      OPEN O_SUPERSTACK_RIGHTS FOR
      SELECT * FROM (SELECT DISTINCT (SELECT LEE_SHORT_NAME FROM FID_LICENSEE WHERE LEE_NUMBER=ALD_LEE_NUMBER)LEE_SHORT_NAME
                       ,ALD_LEE_NUMBER
                       ,(SELECT SER_TITLE FROM FID_SERIES WHERE SER_NUMBER=MEI_GEN_REFNO) SER_TITLE
                       ,MEI_GEN_REFNO SER_NUMBER
                       ,CB_NAME
                       ,CB_ID MSR_BOUQUET_ID
                       ,nvl(MSR_SUPERSTACK_FLAG,'N') MSR_SUPERSTACK_FLAG
                       ,'Y' CBM_CON_BOUQ_RIGHTS
                       ,DECODE(MEM_STATUS,'EXECUTED','Y','N') IS_EXECUTED
                       ,'N' IS_SCHEDULED
                       ,CB_RANK
                    FROM X_CP_MEMO_SUPERSTACK_RIGHTS abc
                      ,SAK_MEMO
                      ,SAK_MEMO_ITEM
                      ,SAK_ALLOCATION_DETAIL
                      ,x_cp_bouquet
                    WHERE MEM_ID=MEI_MEM_ID
                          AND MEI_ID=ALD_MEI_ID
                          AND MEM_ID=i_mem_id
                          AND MSR_ALD_NUMBER = ALD_ID
                          AND CB_BOUQ_PARENT_ID IS NULL
                          AND MEI_GEN_REFNO = MSR_SEA_NUMBER
                          AND CB_ID = MSR_BOUQUET_ID(+)
                          AND CB_AD_FLAG = 'A'
                          AND ALD_LEE_NUMBER IN(select lee_number  from fid_licensee where LEE_MEDIA_SERVICE_CODE in('CATCHUP','CATCHUP3P'))
                          AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP
                          WHERE CMM_BOUQ_MS_CODE IN(select LEE_MEDIA_SERVICE_CODE from fid_licensee
                                                       WHERE lee_number in(select ALD_LEE_NUMBER from SAK_ALLOCATION_DETAIL
                                                                                WHERE ALD_MEI_ID IN((SELECT MEI_ID FROM sak_memo_item
                                                                                        WHERE MEI_MEM_ID = i_mem_id))))AND CMM_BOUQ_MS_RIGHTS ='Y')
                    UNION
                    SELECT DISTINCT (SELECT LEE_SHORT_NAME FROM FID_LICENSEE WHERE LEE_NUMBER=ALD_LEE_NUMBER)LEE_SHORT_NAME
                       ,ALD_LEE_NUMBER
                       ,(SELECT SER_TITLE FROM FID_SERIES WHERE SER_NUMBER=MEI_GEN_REFNO) SER_TITLE
                       ,MEI_GEN_REFNO SER_NUMBER
                       ,CB_NAME
                       ,CB_ID MSR_BOUQUET_ID
                       ,'N' MSR_SUPERSTACK_FLAG
                       ,'Y' CBM_CON_BOUQ_RIGHTS
                       ,DECODE(MEM_STATUS,'EXECUTED','Y','N') IS_EXECUTED
                       ,'N' IS_SCHEDULED
                       ,CB_RANK
                    FROM  SAK_MEMO
                        ,SAK_MEMO_ITEM
                        ,SAK_ALLOCATION_DETAIL
                        ,x_cp_bouquet
                  WHERE MEM_ID=MEI_MEM_ID
                        AND MEI_ID=ALD_MEI_ID
                        AND MEM_ID=i_mem_id
                        AND CB_BOUQ_PARENT_ID IS NULL
                        AND CB_AD_FLAG = 'A'
                         AND ALD_LEE_NUMBER IN(select lee_number  from fid_licensee where LEE_MEDIA_SERVICE_CODE in('CATCHUP','CATCHUP3P'))
                       AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP

                      WHERE CMM_BOUQ_MS_CODE IN(select LEE_MEDIA_SERVICE_CODE from fid_licensee
                                                       WHERE lee_number in(select ALD_LEE_NUMBER from SAK_ALLOCATION_DETAIL
                                                                                WHERE ALD_MEI_ID IN((SELECT MEI_ID FROM sak_memo_item
                                                                                        WHERE MEI_MEM_ID = i_mem_id))))AND CMM_BOUQ_MS_RIGHTS ='Y')
                        AND  MEI_GEN_REFNO not in(SELECT msr_sea_number from  X_CP_MEMO_SUPERSTACK_RIGHTS where MSR_ald_number In(ald_id) ))
                        ORDER BY cb_rank;

      /*SELECT DISTINCT
          (SELECT LEE_SHORT_NAME FROM FID_LICENSEE WHERE LEE_NUMBER=ALD_LEE_NUMBER)LEE_SHORT_NAME
          ,ALD_LEE_NUMBER
          ,(SELECT SER_TITLE FROM FID_SERIES WHERE SER_NUMBER=MEI_GEN_REFNO) SER_TITLE
          ,MEI_GEN_REFNO SER_NUMBER
          ,CB_NAME
          ,CB_RANK
          , CB_ID MSR_BOUQUET_ID
          ,NVL((select distinct MSR_SUPERSTACK_FLAG from X_CP_MEMO_SUPERSTACK_RIGHTS
            WHERE MSR_BOUQUET_ID = CB_ID
            AND MSR_SEA_NUMBER = MEI_GEN_REFNO
            and msr_ald_number = g.msr_ald_number),'N')MSR_SUPERSTACK_FLAG
           --,NVL(CBM_CON_BOUQ_RIGHTS,'N')CBM_CON_BOUQ_RIGHTS
           ,'Y' CBM_CON_BOUQ_RIGHTS
            ,DECODE(MEM_STATUS,'EXECUTED','Y','N') IS_EXECUTED
            ,'N' IS_SCHEDULED
          FROM
          X_CP_BOUQUET
          ,(SELECT * FROM X_CP_MEMO_SUPERSTACK_RIGHTS WHERE
          MSR_ALD_NUMBER IN (SELECT ALD_ID  FROM
                    SAK_MEMO, SAK_MEMO_ITEM, SAK_ALLOCATION_DETAIL
                    WHERE
                    MEM_ID=MEI_MEM_ID
                    AND MEI_ID=ALD_MEI_ID
                    AND MEM_ID=i_mem_id-- 24350 --23020
                   -- AND MEM_CON_NUMBER=(SELECT CON_NUMBER FROM FID_CONTRACT WHERE CON_SHORT_NAME = I_CON_SHORT_NAME) --56001 --63195
                    ))g
          ,(SELECT -99 CBM_ID, -99 CBM_CON_NUMBER, -99 CBM_BOUQUE_ID from dual
          union
          SELECT CBM_ID,CBM_CON_NUMBER,CBM_BOUQUE_ID  from X_CON_BOUQUE_MAPP
          ) X_CON_BOUQUE_MAPP
          ,(SELECT ALD_LEE_NUMBER,MEI_GEN_REFNO,MEM_STATUS,MEM_CON_NUMBER FROM
                    SAK_MEMO, SAK_MEMO_ITEM, SAK_ALLOCATION_DETAIL
                    WHERE
                    MEM_ID=MEI_MEM_ID
                    AND MEI_ID=ALD_MEI_ID
                    AND MEM_ID=i_mem_id --24350 -- 23020
                   -- AND MEM_CON_NUMBER=(SELECT CON_NUMBER FROM FID_CONTRACT WHERE CON_SHORT_NAME = I_CON_SHORT_NAME) --56001 --63195
                    AND ALD_LEE_NUMBER IN (SELECT LEE_NUMBER FROM FID_LICENSEE
                              WHERE LEE_NUMBER IN (SELECT LEE_NUMBER FROM FID_LICENSEE WHERE LEE_MEDIA_SERVICE_CODE IN('CATCHUP','CATCHUP3P')))
                    ) ab
          WHERE
          CB_BOUQ_PARENT_ID IS NULL
          AND CB_ID = MSR_BOUQUET_ID(+)
          AND CB_AD_FLAG = 'A'
          AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP WHERE CMM_BOUQ_MS_CODE IN('CATCHUP','CATCHUP3P')AND CMM_BOUQ_MS_RIGHTS ='Y')
          Order by CB_RANK;*/

      ELSE

      OPEN O_SUPERSTACK_RIGHTS FOR
      SELECT * FROM (SELECT DISTINCT (SELECT LEE_SHORT_NAME FROM FID_LICENSEE WHERE LEE_NUMBER=ALD_LEE_NUMBER)LEE_SHORT_NAME
             ,ALD_LEE_NUMBER
             ,(SELECT SER_TITLE FROM FID_SERIES WHERE SER_NUMBER=MEI_GEN_REFNO) SER_TITLE
             ,MEI_GEN_REFNO SER_NUMBER
             ,CB_NAME
             ,CB_ID MSR_BOUQUET_ID
             ,nvl(MSR_SUPERSTACK_FLAG,'N') MSR_SUPERSTACK_FLAG
            ,(NVL((select CBR_SUPERSTACKRIGHTS FROM X_CP_CON_BOUQ_SSTACK_RIGHTS WHERE CBR_CON_NUMBER =(SELECT CON_NUMBER FROM FID_CONTRACT WHERE CON_SHORT_NAME = I_CON_SHORT_NAME)
                    AND CBR_BOUQUET_ID =CB_ID),'N'))CBM_CON_BOUQ_RIGHTS
             ,DECODE(MEM_STATUS,'EXECUTED','Y','N') IS_EXECUTED
             ,'N' IS_SCHEDULED
             ,CB_RANK
        FROM X_CP_MEMO_SUPERSTACK_RIGHTS abc
            ,SAK_MEMO
            ,SAK_MEMO_ITEM
            ,SAK_ALLOCATION_DETAIL
            ,x_cp_bouquet
        WHERE MEM_ID=MEI_MEM_ID
              AND MEI_ID=ALD_MEI_ID
              AND MEM_ID=i_mem_id
              AND MSR_ALD_NUMBER = ALD_ID
              AND CB_BOUQ_PARENT_ID IS NULL
              AND MEI_GEN_REFNO = MSR_SEA_NUMBER
              AND CB_ID = MSR_BOUQUET_ID(+)
              AND CB_AD_FLAG = 'A'
              AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP
                      WHERE CMM_BOUQ_MS_CODE IN(select LEE_MEDIA_SERVICE_CODE from fid_licensee
                                                       WHERE lee_number in(select ALD_LEE_NUMBER from SAK_ALLOCATION_DETAIL
                                                                                WHERE ALD_MEI_ID IN((SELECT MEI_ID FROM sak_memo_item
                                                                                        WHERE MEI_MEM_ID = i_mem_id))))AND CMM_BOUQ_MS_RIGHTS ='Y')
        UNION
        SELECT DISTINCT (SELECT LEE_SHORT_NAME FROM FID_LICENSEE WHERE LEE_NUMBER=ALD_LEE_NUMBER)LEE_SHORT_NAME
             ,ALD_LEE_NUMBER
             ,(SELECT SER_TITLE FROM FID_SERIES WHERE SER_NUMBER=MEI_GEN_REFNO) SER_TITLE
             ,MEI_GEN_REFNO SER_NUMBER
             ,CB_NAME
             ,CB_ID MSR_BOUQUET_ID
             ,'N' MSR_SUPERSTACK_FLAG
             ,(NVL((select CBR_SUPERSTACKRIGHTS FROM X_CP_CON_BOUQ_SSTACK_RIGHTS WHERE CBR_CON_NUMBER =(SELECT CON_NUMBER FROM FID_CONTRACT WHERE CON_SHORT_NAME = I_CON_SHORT_NAME)
                    AND CBR_BOUQUET_ID =CB_ID),'N'))CBM_CON_BOUQ_RIGHTS
             ,DECODE(MEM_STATUS,'EXECUTED','Y','N') IS_EXECUTED
             ,'N' IS_SCHEDULED
             ,CB_RANK
          FROM  SAK_MEMO
              ,SAK_MEMO_ITEM
              ,SAK_ALLOCATION_DETAIL
              ,x_cp_bouquet
          WHERE MEM_ID=MEI_MEM_ID
                AND MEI_ID=ALD_MEI_ID
                AND MEM_ID=i_mem_id
                AND CB_BOUQ_PARENT_ID IS NULL
                AND CB_AD_FLAG = 'A'
                AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP
                      WHERE CMM_BOUQ_MS_CODE IN(select LEE_MEDIA_SERVICE_CODE from fid_licensee
                                                       WHERE lee_number in(select ALD_LEE_NUMBER from SAK_ALLOCATION_DETAIL
                                                                                WHERE ALD_MEI_ID IN((SELECT MEI_ID FROM sak_memo_item
                                                                                        WHERE MEI_MEM_ID = i_mem_id))))AND CMM_BOUQ_MS_RIGHTS ='Y')
                AND  MEI_GEN_REFNO not in(SELECT msr_sea_number from  X_CP_MEMO_SUPERSTACK_RIGHTS where MSR_ald_number In(ald_id) ))
                ORDER by cb_rank;

      /*SELECT DISTINCT
          (SELECT LEE_SHORT_NAME FROM FID_LICENSEE WHERE LEE_NUMBER=ALD_LEE_NUMBER)LEE_SHORT_NAME
          ,ALD_LEE_NUMBER
          ,(SELECT SER_TITLE FROM FID_SERIES WHERE SER_NUMBER=MEI_GEN_REFNO) SER_TITLE
          ,MEI_GEN_REFNO SER_NUMBER
          ,CB_NAME
          ,CB_RANK
          , CB_ID MSR_BOUQUET_ID
           ,NVL((select distinct MSR_SUPERSTACK_FLAG from X_CP_MEMO_SUPERSTACK_RIGHTS
            WHERE MSR_BOUQUET_ID = CB_ID
            AND MSR_SEA_NUMBER = MEI_GEN_REFNO),'N')MSR_SUPERSTACK_FLAG
          --,nvl(MSR_SUPERSTACK_FLAG,'N') MSR_SUPERSTACK_FLAG
          -- ,NVL(CBM_CON_BOUQ_RIGHTS,'N')CBM_CON_BOUQ_RIGHTS
          --,'Y' CBM_CON_BOUQ_RIGHTS
          ,NVL((SELECT DISTINCT NVL(CSR_SUPERSTACK_FLAG,'N')  FROM X_CP_CON_SUPERSTACK_RIGHTS WHERE CSR_CON_NUMBER = MEM_CON_NUMBER AND CSR_BOUQUET_ID= CB_ID),'N')CBM_CON_BOUQ_RIGHTS
          ,DECODE(MEM_STATUS,'EXECUTED','Y','N') IS_EXECUTED
            ,'N' IS_SCHEDULED
          FROM
          X_CP_BOUQUET
          ,(SELECT * FROM X_CP_MEMO_SUPERSTACK_RIGHTS WHERE
          MSR_ALD_NUMBER IN (SELECT ALD_ID  FROM
                    SAK_MEMO, SAK_MEMO_ITEM, SAK_ALLOCATION_DETAIL
                    WHERE
                    MEM_ID=MEI_MEM_ID
                    AND MEI_ID=ALD_MEI_ID
                    AND MEM_ID=i_mem_id-- 24350 --23020
                    AND MEM_CON_NUMBER=(SELECT CON_NUMBER FROM FID_CONTRACT WHERE CON_SHORT_NAME = I_CON_SHORT_NAME) --56001 --63195
                    ))
          ,X_CON_BOUQUE_MAPP
          ,(SELECT ALD_LEE_NUMBER,MEI_GEN_REFNO,MEM_STATUS,MEM_CON_NUMBER  FROM
                    SAK_MEMO, SAK_MEMO_ITEM, SAK_ALLOCATION_DETAIL
                    WHERE
                    MEM_ID=MEI_MEM_ID
                    AND MEI_ID=ALD_MEI_ID
                    AND MEM_ID=i_mem_id --24350 -- 23020
                    AND MEM_CON_NUMBER=(SELECT CON_NUMBER FROM FID_CONTRACT WHERE CON_SHORT_NAME = I_CON_SHORT_NAME) --56001 --63195
                    AND ALD_LEE_NUMBER IN (SELECT LEE_NUMBER FROM FID_LICENSEE
                              WHERE LEE_NUMBER IN (SELECT LEE_NUMBER FROM FID_LICENSEE WHERE LEE_MEDIA_SERVICE_CODE IN('CATCHUP','CATCHUP3P')))
                    ) ab
          WHERE
          CB_BOUQ_PARENT_ID IS NULL
          AND CB_ID = MSR_BOUQUET_ID(+)
          AND CB_AD_FLAG = 'A'
          AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP WHERE CMM_BOUQ_MS_CODE IN('CATCHUP','CATCHUP3P')AND CMM_BOUQ_MS_RIGHTS ='Y')
          ORDER BY CB_RANK;*/
        END IF;
   END prc_dm_prog_search;

   ------------------------------------- PROCEDURE FOR ADD PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_add_dm_programme (
      i_mei_mem_id               IN     sak_memo_item.mei_mem_id%TYPE,
      i_mem_type                 IN     sak_memo.mem_type%TYPE,
      i_title_show               IN     fid_general.gen_title%TYPE,
      i_genre                    IN     fid_general.gen_category%TYPE,
      i_sub_genre                IN     fid_general.gen_subgenre%TYPE,
      i_event                    IN     fid_general.gen_event%TYPE,
      i_gen_type                 IN     fid_general.gen_type%TYPE,
      i_mei_total_price          IN     sak_memo_item.mei_total_price%TYPE,
      i_licensor                 IN     fid_company.com_short_name%TYPE,
      i_user_id                  IN     fid_general.gen_entry_oper%TYPE,
      i_gen_duration_c           IN     fid_general.gen_duration_c%TYPE,
      i_mei_gen_refno            IN     sak_memo_item.mei_gen_refno%TYPE,
      --Bioscope Changes Added new Parameter by Anirudha on 13/03/2012
      i_gen_tertiary_genre       IN     fid_general.gen_tertiary_genre%TYPE,
      i_gen_bo_category_code     IN     fid_general.gen_bo_category_code%TYPE,
      i_gen_bo_revenue_usd       IN     fid_general.gen_bo_revenue_usd%TYPE,
      i_gen_bo_revenue_zar       IN     fid_general.gen_bo_revenue_zar%TYPE,
      i_gen_release_year         IN     fid_general.gen_release_year%TYPE,
      i_gen_prog_category_code   IN     fid_general.gen_prog_category_code%TYPE,
      -- Bioscope Changes END
      -- PB CR Mrunmayi
      i_premium_flag             IN     sak_memo_item.mei_premium_flag%TYPE,
      i_gen_SVOD_Rights          IN     fid_general.gen_svod_rights%TYPE,
	    i_gen_express              IN     fid_general.gen_express%TYPE,
      i_gen_archive              IN     fid_general.GEN_ARCHIVE%TYPE,
      i_gen_catelogue            IN     fid_general.GEN_CATALOGUE%TYPE,
      -- End
      o_mei_gen_refno               OUT sak_memo_item.mei_gen_refno%TYPE,
      o_mei_id                      OUT sak_memo_item.mei_id%TYPE,
      o_mem_con_price               OUT sak_memo.mem_con_price%TYPE,
      o_mem_update_count            OUT sak_memo.mem_update_count%TYPE)
   AS
      l_seryorn           VARCHAR2 (1);
      l_liveyorn          VARCHAR2 (1);
      l_gen_refno         NUMBER;
      l_dur_number        NUMBER;
      l_dur_char          VARCHAR2 (15);
      l_dur_s             VARCHAR2 (1);
      l_hours             VARCHAR2 (10);
      l_minutes           VARCHAR2 (10);
      l_seconds           VARCHAR2 (10);
      l_gen_duration_c    VARCHAR2 (15);
      l_gen_duration      NUMBER;
      l_mei_total_price   NUMBER;
      countseries         NUMBER;
      l_com_number        NUMBER;
      l_o_flag            NUMBER;
      l_message           VARCHAR2 (200);
      norights            EXCEPTION;
      -- Synergy Vanilla:Start [Nasreen Mulla]
      L_CONTENT           X_FIN_CONFIGS.CONTENT%TYPE;
   -- Synergy Vanilla:End
   BEGIN
      /*pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_mei_mem_id,
                                                          i_user_id,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF; */
      BEGIN
         SELECT NVL (cod_attr1, 'N') cod_attr1,
                NVL (cod_attr2, 'N') cod_attr2
           INTO l_seryorn, l_liveyorn
           FROM fid_code
          WHERE cod_type = 'GEN_TYPE' AND cod_value = i_gen_type;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_seryorn := 'N';
            l_liveyorn := 'N';
      END;

      --DBMS_OUTPUT.put_line ('1'||l_seryorn||' '|| l_liveyorn );
      BEGIN
         SELECT fn_convert_duration_c_n (i_gen_duration_c)
           INTO l_gen_duration
           FROM DUAL;

         IF l_seryorn = 'Y'
         THEN
            SELECT COUNT (*)
              INTO countseries
              FROM fid_series
             WHERE ser_number = i_mei_gen_refno;

            --WHERE UPPER (ser_title) LIKE UPPER (i_title_show);
            IF (countseries > 0)
            THEN
               IF (i_mei_gen_refno <> 0)
               THEN
                  o_mei_gen_refno := i_mei_gen_refno;
               ELSE
                  o_mei_gen_refno := 0;
               END IF;
            --o_mei_gen_refno := i_mei_gen_refno;
            --   DBMS_OUTPUT.put_line (' o_mei_gen_refno ' || o_mei_gen_refno);
            -- Commented the Below code because User is sending the refNo.through UI.
            ELSE
               o_mei_gen_refno := 0;
            END IF;

            --Added by Nishant
            SELECT com_number
              INTO l_com_number
              FROM fid_company
             WHERE UPPER (com_short_name) LIKE UPPER (i_licensor);

            IF NVL (o_mei_gen_refno, 0) = 0
            THEN
               IF i_gen_type IS NOT NULL
               THEN
                  l_gen_refno := get_seq ('SEQ_SER_NUMBER');

                  --  DBMS_OUTPUT.PUT_LINE (' l_gen_refno ' || l_gen_refno);
                  --RDT:[Media Ops_MOP_CR_12.1]_[Milind_2014-08-20]_[Set null for i_gen_release_year and l_com_number]:start
                  INSERT INTO fid_series (ser_number,
                                          ser_title,
                                          ser_entry_date,
                                          ser_entry_oper,
                                          ser_parent_number,
                                          order_title,
                                          order_number,
                                          order_season,
                                          ser_duration,      --ser_is_deleted,
                                          ser_update_count,  --Added by Nishant
                                          ser_svod_rights,   -- added by Vikas Srivastava
                                          ser_type)
                       VALUES (l_gen_refno,
                               UPPER (i_title_show),
                               SYSDATE,
                               i_user_id,
                               0,
                               UPPER (i_title_show),
                               -1,
                               '1',
                               l_gen_duration,                          --'N',
                               0                            --Added by Nishant
                                ,
                               i_gen_SVOD_Rights,
                               --Supplier field is not to be sent while insert : Commneted by Milind
                               --Release Year is not associated with series now : Commneted by Milind
                               I_GEN_TYPE);
               --RDT:[Media Ops]_[Milind_2014-08-20]:End
               END IF;

               o_mei_gen_refno := l_gen_refno;
            END IF;
         ELSE
            SELECT COUNT (*)
              INTO countseries
              FROM fid_general
             WHERE UPPER (gen_title) LIKE UPPER (i_title_show);

            IF (countseries > 0)
            THEN
               IF (i_mei_gen_refno <> 0)
               THEN
                  o_mei_gen_refno := i_mei_gen_refno;
               ELSE
                  o_mei_gen_refno := 0;
               END IF;
            ELSE
               o_mei_gen_refno := 0;
            END IF;

            --DBMS_OUTPUT.put_line ('3' || o_mei_gen_refno);

            ---------
            IF NVL (o_mei_gen_refno, 0) = 0
            THEN
               IF i_gen_type IS NOT NULL
               THEN
                  -- Synergy Vanilla:Start [Nasreen Mulla]
                  SELECT CONTENT
                    INTO L_CONTENT
                    FROM X_FIN_CONFIGS
                   WHERE KEY = 'COMPANY_ID';

                  IF L_CONTENT = 1
                  THEN
                     l_gen_refno := get_seq ('SEQ_GEN_REFNO');
                  ELSE
                     l_gen_refno := get_seq ('SEQ_GEN_REFNO_M24');
                  END IF;

                  -- Synergy Vanilla:end
                  IF l_gen_duration > 0
                  THEN
                     l_dur_s := 'A';
                  END IF;

                  --DBMS_OUTPUT.put_line ('l_dur_s :' || l_dur_s);
                  SELECT com_number
                    INTO l_com_number
                    FROM fid_company
                   WHERE UPPER (com_short_name) LIKE UPPER (i_licensor);

                  --DBMS_OUTPUT.put_line ('com no :');
                  --DBMS_OUTPUT.put_line ('com no : ' || l_com_number);
                  INSERT INTO fid_general (
										   gen_refno,
                                           gen_title,
                                           gen_type,
                                           gen_duration,
                                           gen_duration_c,
                                           gen_duration_s,
                                           gen_stu_code,
                                           gen_category,
                                           gen_entry_date,
                                           gen_entry_oper,
                                           gen_title_working,
                                           gen_event,
                                           gen_subgenre,
                                           gen_update_count,
                                           gen_tertiary_genre,
                                           gen_bo_category_code,
                                           gen_bo_revenue_usd,
                                           gen_bo_revenue_zar,
                                           gen_release_year,
                                           gen_prog_category_code,
                                           gen_svod_rights,
										   gen_express,
										   GEN_ARCHIVE,
										   GEN_CATALOGUE,
										   GEN_EMBARGO_CONTENT
										   ,GEN_CNT_RELEASE_UID
										   )
                       VALUES 	(
										   l_gen_refno,
										   UPPER (i_title_show),
										   i_gen_type,
										   l_gen_duration,
										   i_gen_duration_c,
										   l_dur_s,
										   --Supplier field is not to be sent while insert : Commneted by Milind
										   '-',
										   NVL (i_genre, '-'),
										   SYSDATE,
										   i_user_id,
										   SUBSTR (UPPER (i_title_show), 1, 120),
										   NVL (i_event, '-'),
										   NVL (i_sub_genre, '-'),
										   0,
										   NVL (i_gen_tertiary_genre, '-'),
										   i_gen_bo_category_code,
										   i_gen_bo_revenue_usd,
										   i_gen_bo_revenue_zar,
										   i_gen_release_year,
										   i_gen_prog_category_code,
										   i_gen_SVOD_Rights,
										   i_gen_express,
										   i_gen_archive,
										   i_gen_catelogue,
										   decode(i_gen_express,'Y','Y','N')
										   ,decode(i_gen_express,'Y','Y','N')
								);
               END IF;

               o_mei_gen_refno := l_gen_refno;
            ELSE
               UPDATE fid_general
                  SET gen_bo_category_code = i_gen_bo_category_code,
                      gen_bo_revenue_usd = i_gen_bo_revenue_usd,
                      gen_bo_revenue_zar = i_gen_bo_revenue_zar,
                      gen_release_year = i_gen_release_year,
                      gen_prog_category_code = i_gen_prog_category_code,
                      gen_svod_rights = i_gen_SVOD_Rights,
					  gen_express = i_gen_express,
					  gen_archive = i_gen_archive,
					  gen_catalogue = i_gen_catelogue
					  ,GEN_EMBARGO_CONTENT = decode(i_gen_express,'N',GEN_EMBARGO_CONTENT,'Y')
					  ,GEN_CNT_RELEASE_UID = decode(i_gen_express,'N',GEN_CNT_RELEASE_UID,'Y')
                WHERE gen_refno = o_mei_gen_refno;
            END IF;
         END IF;

         o_mei_id := get_seq ('SEQ_MEI_ID');

         INSERT INTO sak_memo_item (mei_id,
                                    mei_mem_id,
                                    mei_gen_refno,
                                    mei_first_epi_number,
                                    mei_episode_count,
                                    mei_total_price,
                                    mei_first_episode_price,
                                    mei_type_show,
                                    mei_live_ind,
                                    mei_supp_fee,
                                    mei_entry_oper,
                                    mei_entry_date           --mei_is_deleted,
                                                  -- PB CR-44 Mrunmayi
                                    ,
                                    mei_premium_flag,                   -- end
                                    --------------Changes done for new gen refno----------------------------
                                    mei_release_year,
                                    mei_mem_com_number,
                                    mei_title -----------------------End------------------------------------------
                                             )
              VALUES (o_mei_id,
                      i_mei_mem_id,
                      o_mei_gen_refno,
                      1,
                      1,
                      NVL (i_mei_total_price, 0),
                      NVL (i_mei_total_price, 0),
                      -----1, to chk license price
                      i_gen_type,
                      'N/A',
                      'N',
                      i_user_id,
                      SYSDATE                                           --'N',
                             -- PB CR-44 Mrunmayi
                      ,
                      i_premium_flag,                                   -- end
                      i_gen_release_year,
                      l_com_number,
                      UPPER (i_title_show));

         COMMIT;

         IF (i_mem_type != 'CPD')
         THEN
            SELECT NVL (SUM (NVL (mei_total_price, 0)), 0)
              INTO l_mei_total_price
              FROM sak_memo_item
             WHERE mei_mem_id = i_mei_mem_id;

            -- DBMS_OUTPUT.put_line ('l_mei_total_price:  ' || l_mei_total_price);
            UPDATE sak_memo
               SET mem_con_price = l_mei_total_price,
                   mem_update_count = NVL (mem_update_count, 0) + 1
             WHERE mem_id = i_mei_mem_id;
         END IF;

         COMMIT;

         --DBMS_OUTPUT.put_line ('update');
         SELECT mem_con_price, mem_update_count
           INTO o_mem_con_price, o_mem_update_count
           FROM sak_memo
          WHERE mem_id = i_mei_mem_id;
      -- DBMS_OUTPUT.put_line (o_mem_con_price || ', ' || o_mem_update_count);
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
      END;
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_add_dm_programme;

   ------------------------------------- PROCEDURE FOR UPDATE PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_update_dm_programme (
      i_mei_id                   IN     sak_memo_item.mei_id%TYPE,
      i_mei_mem_id               IN     sak_memo_item.mei_mem_id%TYPE,
      i_mem_type                 IN     sak_memo.mem_type%TYPE,
      i_title_show               IN     fid_general.gen_title%TYPE,
      i_genre                    IN     fid_general.gen_category%TYPE,
      i_sub_genre                IN     fid_general.gen_subgenre%TYPE,
      i_event                    IN     fid_general.gen_event%TYPE,
      i_gen_type                 IN     fid_general.gen_type%TYPE,
      i_gen_duration_c           IN     fid_general.gen_duration_c%TYPE,
      i_mei_gen_refno            IN     sak_memo_item.mei_gen_refno%TYPE,
      i_mei_total_price          IN     sak_memo_item.mei_total_price%TYPE,
      i_entryoper                IN     fid_general.gen_entry_oper%TYPE,
      -- Bioscope Changes Added below column by Anirudha on 13/03/2012
      i_gen_release_year         IN     fid_general.gen_release_year%TYPE,
      i_gen_tertiary_genre       IN     fid_general.gen_tertiary_genre%TYPE,
      i_gen_bo_category_code     IN     fid_general.gen_bo_category_code%TYPE,
      i_gen_bo_revenue_usd       IN     fid_general.gen_bo_revenue_usd%TYPE,
      i_gen_bo_revenue_zar       IN     fid_general.gen_bo_revenue_zar%TYPE,
      i_gen_prog_category_code   IN     fid_general.gen_prog_category_code%TYPE,
      -- Bioscope Changes End
      -- PB CR-44 Mrunmayi 31-jul-2013
      i_premium_flag             IN     sak_memo_item.mei_premium_flag%TYPE,
      -- End
      -- Devashish/Shantanu, 30/jan/2014
      --i_mem_update_count         IN     sak_memo.mem_update_count%TYPE,
      i_mei_update_count         IN     sak_memo_item.mei_update_count%TYPE,
      -- End
	  i_gen_SVOD_Rights          IN     fid_general.gen_svod_rights%TYPE,
	  i_gen_express              IN     fid_general.gen_express%TYPE,
	  i_gen_archive              IN     fid_general.GEN_ARCHIVE%TYPE,
      i_gen_catelogue            IN     fid_general.GEN_CATALOGUE%TYPE,
      --i_mei_episode_count     IN       sak_memo_item.mei_episode_count%TYPE,
      o_mem_con_price               OUT sak_memo.mem_con_price%TYPE,
      --o_mei_first_episode_price   OUT      sak_memo_item.mei_first_episode_price%TYPE,
      o_mem_update_count            OUT sak_memo.mem_update_count%TYPE,
      o_mei_update_count            OUT sak_memo_item.mei_update_count%TYPE -- o_fcd_update_count out fid_cpd_details.ffcd_update_count%TYPE
                                                                           )
   AS
      l_seryorn                   VARCHAR2 (1);
      l_liveyorn                  VARCHAR2 (1);
      l_countlive                 NUMBER;
      l_dur_char                  VARCHAR2 (15);
      l_gen_duration_c            VARCHAR2 (15) := '';
      l_gen_duration              NUMBER := 0;
      l_dur_s                     VARCHAR2 (1);
      l_mei_total_price           NUMBER;
      l_mei_episode_count         NUMBER;
      l_mei_first_episode_price   NUMBER;
      l_episode_present           NUMBER; --- added by vikas Srivastava
      l_ser_parent_count          NUMBER;  --- added by vikas Srivastava
      l_mei_gen_refno             sak_memo_item.mei_gen_refno%TYPE;
      -- Devashish/Shantanu , 30/jan/2014
      --l_mem_update_count          sak_memo.mem_update_count%TYPE;
      l_mei_update_count          sak_memo_item.mei_update_count%TYPE;
   --End
   BEGIN
      SELECT mei_gen_refno
        INTO l_mei_gen_refno
        FROM sak_memo_item
       WHERE mei_id = i_mei_id;

      BEGIN
         SELECT NVL (cod_attr1, 'N') cod_attr1,
                NVL (cod_attr2, 'N') cod_attr2
           INTO l_seryorn, l_liveyorn
           FROM fid_code
          WHERE cod_type = 'GEN_TYPE' AND cod_value = i_gen_type;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_seryorn := 'N';
            l_liveyorn := 'N';
      END;

      BEGIN
         --dur_char4  := LPAD(TO_CHAR(:gen_duration_x),6,'0');
         --         SELECT    SUBSTR (i_gen_duration_c,
         --                           (LENGTH (i_gen_duration_c) - 7),
         --                           2
         --                          )
         --                || SUBSTR (i_gen_duration_c,
         --                           (LENGTH (i_gen_duration_c) - 4),
         --                           2
         --                          )
         --                || SUBSTR (i_gen_duration_c,
         --                           (LENGTH (i_gen_duration_c) - 1),
         --                           2
         --                          )
         --           INTO l_gen_duration_c
         --           FROM DUAL;

         --insert into A(error) values (sysdate ||l_gen_duration_c);commit;
         --         SELECT    SUBSTR (i_gen_duration_c,
         --                           (LENGTH (i_gen_duration_c) - 7),
         --                           2
         --                          )
         --                || ':'
         --                || SUBSTR (i_gen_duration_c,
         --                           (LENGTH (i_gen_duration_c) - 4),
         --                           2
         --                          )
         --                || ':'
         --                || SUBSTR (i_gen_duration_c,
         --                           (LENGTH (i_gen_duration_c) - 1),
         --                           2
         --                          )
         --           INTO l_dur_char
         --           FROM DUAL;

         --l_gen_duration := convert_duration_c_n_noframe (l_gen_duration_c);
         --         l_gen_duration := convert_duration_c_n (l_gen_duration_c);
         SELECT fn_convert_duration_c_n (TO_CHAR (i_gen_duration_c))
           INTO l_gen_duration
           FROM DUAL;

         IF l_gen_duration > 0
         THEN
            l_dur_s := 'A';
         END IF;

         IF l_seryorn <> 'Y'
         THEN
            --           SELECT convert_duration_c_n_noframe (l_gen_duration_c)
            --             INTO l_gen_duration
            --             FROM DUAL;

            --            SELECT convert_duration_c_n (l_gen_duration_c)
            --              INTO l_gen_duration
            --              FROM DUAL;
            UPDATE fid_general
               SET gen_duration = l_gen_duration,
                   gen_duration_c = i_gen_duration_c,
                   gen_duration_s = l_dur_s,
                   gen_category = NVL (i_genre, '-'),
                   gen_subgenre = NVL (i_sub_genre, '-'),
                   gen_release_year = i_gen_release_year,
                   gen_tertiary_genre = NVL (i_gen_tertiary_genre, '-'),
                   gen_bo_category_code = i_gen_bo_category_code,
                   gen_bo_revenue_usd = i_gen_bo_revenue_usd,
                   gen_bo_revenue_zar = i_gen_bo_revenue_zar,
                   gen_prog_category_code = i_gen_prog_category_code,
                   gen_event = NVL (i_event, '-'),
                   gen_entry_oper = i_entryoper,
				   --Added By Pravin for SVOD changes
				   gen_svod_rights = i_gen_SVOD_Rights,
				   gen_express = i_gen_express,
				   GEN_ARCHIVE = i_gen_archive,
				   gen_catalogue = i_gen_catelogue,
				   --Pravin End
           --added by vikas srivastava for svod rights
           GEN_EMBARGO_CONTENT = decode(i_gen_express,'N',GEN_EMBARGO_CONTENT,'Y'),
           GEN_CNT_RELEASE_UID = decode(i_gen_express,'N',GEN_CNT_RELEASE_UID,'Y'),
           -- vikas end
                   gen_update_count = NVL (gen_update_count, 0) + 1
             WHERE gen_refno = l_mei_gen_refno AND gen_type = i_gen_type;
         ELSE
            UPDATE fid_series
               SET ser_duration = l_gen_duration,
                   ser_update_count = NVL (ser_update_count, 0) + 1,
                   SER_ENTRY_DATE = SYSDATE --, -- changes by Rashmi_Tijare_20140804 for Phoenix
                   --ser_svod_rights = i_gen_SVOD_Rights  -- added by vikas srivastava
             WHERE ser_number = l_mei_gen_refno;
         END IF;

         /* Added by vikas Srivastava*/
      BEGIN
       SELECT count(1) INTO l_ser_parent_count
         FROM fid_series
       WHERE ser_number = l_mei_gen_refno;
          IF(l_seryorn ='Y' AND l_ser_parent_count >0)
            THEN
             UPDATE fid_series
               SET ser_svod_rights = i_gen_SVOD_Rights
               WHERE ser_number = l_mei_gen_refno;
          END IF;
       SELECT COUNT (*) INTO l_episode_present
        FROM fid_general
       WHERE gen_ser_number = l_mei_gen_refno;
         IF (l_seryorn ='Y' AND l_episode_present > 0)
		       THEN
		         UPDATE fid_general
			         SET  gen_svod_rights = i_gen_SVOD_Rights,
                    gen_express = i_gen_express,
                    gen_catalogue =i_gen_catelogue,
                    gen_archive = i_gen_archive,
                    GEN_EMBARGO_CONTENT = decode(i_gen_express,'N',GEN_EMBARGO_CONTENT,'Y'),
                    GEN_CNT_RELEASE_UID = decode(i_gen_express,'N',GEN_CNT_RELEASE_UID,'Y')
            WHERE gen_refno IN (SELECT gen_refno FROM fid_general WHERE gen_ser_number = l_mei_gen_refno);
		  END IF;
      END;

    /* end by vikas Srivastava*/
         IF i_mem_type = 'FLF' AND l_seryorn = 'Y'
         THEN
            SELECT mei_episode_count
              INTO l_mei_episode_count
              FROM sak_memo_item
             WHERE mei_id = i_mei_id;

            IF l_mei_episode_count = 0
            THEN
               l_mei_first_episode_price := i_mei_total_price;
            ELSE
               l_mei_first_episode_price :=
                  i_mei_total_price / l_mei_episode_count;
            END IF;
         ELSE
            l_mei_first_episode_price := i_mei_total_price;
         END IF;

         IF l_seryorn = 'Y'
         THEN
            UPDATE sak_memo_item                                     -- SERIES
               SET mei_total_price = i_mei_total_price,
                   mei_gen_refno = i_mei_gen_refno,
                   --   mei_first_episode_price = l_mei_first_episode_price,
                   -- mei_update_count = NVL (mei_update_count, 0) + 1,
                   mei_premium_flag = i_premium_flag
             WHERE mei_id = i_mei_id;
         ELSE
            UPDATE sak_memo_item                               -- NON - SERIES
               SET mei_total_price = i_mei_total_price,
                   mei_gen_refno = i_mei_gen_refno,
                   mei_first_episode_price = l_mei_first_episode_price,
                   --mei_update_count = NVL (mei_update_count, 0) + 1,
                   mei_premium_flag = i_premium_flag
             WHERE mei_id = i_mei_id;
         END IF;

         /*
         AUTHOR : Devashish/Shantanu,
         DATE : 30/jan/2014,
         Description : Update Count Functionality Modified
         */
         SELECT mei_update_count
           INTO l_mei_update_count
           FROM sak_memo_item
          WHERE mei_id = i_mei_id;

         IF (l_mei_update_count = i_mei_update_count)
         THEN
            UPDATE sak_memo_item
               SET mei_update_count = mei_update_count + 1
             WHERE mei_id = i_mei_id;

            COMMIT;

            SELECT mei_update_count
              INTO o_mei_update_count
              FROM sak_memo_item
             WHERE mei_id = i_mei_id;
         ELSE
            ROLLBACK;
            raise_application_error (
               -20325,
               'Deal item details are being changed by other user');
         END IF;

         /************************End Of the Update count Functionality*******************/
         SELECT NVL (SUM (mei_total_price), 0)
           INTO l_mei_total_price
           FROM sak_memo_item
          WHERE mei_mem_id = i_mei_mem_id;

            UPDATE sak_memo
               SET mem_con_price = l_mei_total_price,
                   mem_update_count = NVL (mem_update_count, 0) + 1
             WHERE mem_id = i_mei_mem_id
         RETURNING mem_update_count
              INTO o_mem_update_count;

         /*
           AUTHOR : Devashish/Shantanu,
           DATE : 30/jan/2014,
           Description : Update Count Functionality Modified
         */

         /*SELECT mem_update_count
          INTO l_mem_update_count
          FROM sak_memo
          WHERE mem_id = i_mei_mem_id;

         IF(i_mem_update_count = i_mem_update_count)
          THEN
           UPDATE sak_memo
           SET mem_update_count = mem_update_count + 1
           WHERE mem_id = i_mei_mem_id;

         COMMIT;

           SELECT mem_update_count
           INTO o_mem_update_count
           FROM sak_memo
           WHERE mem_id = i_mei_mem_id;

         ELSE
           ROLLBACK;
           raise_application_error(-20325,'Deal details are being changed by other user for given ' || i_mei_mem_id ||
                                   'please refresh the screen');
         END IF;*/
         /************************End Of the Update count Functionality*******************/
         o_mem_con_price := l_mei_total_price;

         SELECT mei_update_count                   --, mei_first_episode_price
           INTO o_mei_update_count               --, o_mei_first_episode_price
           FROM sak_memo_item
          WHERE mei_id = i_mei_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20010, SUBSTR (SQLERRM, 1, 150));
         WHEN OTHERS
         THEN
            raise_application_error (-20010, SUBSTR (SQLERRM, 1, 150));
      END;
   END prc_update_dm_programme;

   ------------------------------------- PROCEDURE FOR DELETE PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_delete_program_details (
      i_mei_id             IN     sak_memo_item.mei_id%TYPE,
      i_mei_gen_refno      IN     sak_memo_item.mei_gen_refno%TYPE,
      i_mei_update_count   IN     sak_memo_item.mei_update_count%TYPE,
      o_deleted               OUT NUMBER)
   AS
      l_flag   NUMBER;
   BEGIN
      BEGIN
         DELETE FROM sak_channel_runs
               WHERE chr_ald_id IN
                        (SELECT ald_id
                           FROM sak_allocation_detail
                          WHERE ald_mei_id IN
                                   (SELECT mei_id
                                      FROM sak_memo_item
                                     WHERE mei_id = i_mei_id
                                           AND NVL (mei_update_count, 0) =
                                                  NVL (i_mei_update_count, 0)));
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      DELETE X_CP_LICENSEE_PLATFORM
       WHERE CP_LEE_PLAT_ALD_ID IN (SELECT ald_id
                                      FROM sak_allocation_detail
                                     WHERE ald_mei_id = i_mei_id);

      DELETE X_CP_MEMO_MEDPLATDEVCOMPAT_MAP
       WHERE MEM_MPDC_ALD_ID IN (SELECT ald_id
                                   FROM sak_allocation_detail
                                  WHERE ald_mei_id = i_mei_id);

      BEGIN
         DELETE FROM sak_allocation_detail
               WHERE ald_mei_id IN
                        (SELECT mei_id
                           FROM sak_memo_item
                          WHERE mei_id = i_mei_id
                                AND NVL (mei_update_count, 0) =
                                       NVL (i_mei_update_count, 0));
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      BEGIN
         DELETE FROM fid_gen_live f
               WHERE f.fgl_gen_refno = i_mei_gen_refno;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      DELETE X_FIN_DM_SEC_LEE
       WHERE DSL_MEI_ID = i_mei_id;

      DELETE FROM sak_memo_item
            WHERE NVL (mei_update_count, 0) = NVL (i_mei_update_count, 0)
                  AND mei_id = i_mei_id;

      --- Added By RAshmi For aquisition 13-+10-2015
      DELETE X_DSTV_RIGHTS_NOW_DATA_DEAL
       WHERE DRNDD_MEI_ID = i_mei_id;

      ---- End Aquistion By RAshmi 13-10-2015

      l_flag := SQL%ROWCOUNT;
      o_deleted := l_flag;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_delete_program_details;

   ------------------------------------- PROCEDURE FOR ADD ALLOCATIONS FOR PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_add_dm_alloc_details (
      i_mei_id              IN     sak_memo_item.mei_id%TYPE,
      i_mei_type_show       IN     sak_memo_item.mei_type_show%TYPE,
      i_mei_gen_refno       IN     sak_memo_item.mei_gen_refno%TYPE,
      i_lee_short_name      IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount          IN     sak_allocation_detail.ald_amount%TYPE,
      i_ald_exhib_days      IN     sak_allocation_detail.ald_exhib_days%TYPE,
      --i_cha_short_name     IN       fid_channel.cha_short_name%TYPE,
      i_cha_number          IN     fid_channel.cha_number%TYPE,
      i_ald_period_tba      IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_ald_period_start    IN     sak_allocation_detail.ald_period_start%TYPE,
      i_ald_period_end      IN     sak_allocation_detail.ald_period_end%TYPE,
      i_ald_black_days      IN     sak_allocation_detail.ald_black_days%TYPE,
      i_ald_cost_runs       IN     sak_allocation_detail.ald_cost_runs%TYPE,
      i_ald_max_runs_cha    IN     sak_allocation_detail.ald_max_runs_cha%TYPE,
      i_ald_max_runs_chs    IN     sak_allocation_detail.ald_max_runs_chs%TYPE,
      ---------------Dev:Africa free repeat:Hari_18-03-2013--------------------
      ---------------adding variables for free repeats and repeat period-------
      i_ald_free_repeat     IN     sak_allocation_detail.ald_free_repeat%TYPE,
      i_ald_repeat_period   IN     sak_allocation_detail.ald_repeat_period%TYPE,
      ---------------END Dev:Africa free repeat--------------------------------
      i_ald_months          IN     sak_allocation_detail.ald_months%TYPE,
      i_ald_lic_type        IN     sak_allocation_detail.ald_lic_type%TYPE,
      i_user_id             IN     sak_allocation_detail.ald_entry_oper%TYPE,
      i_ald_end_days        IN     sak_allocation_detail.ald_end_days%TYPE,
      -- BR_15_144- Warner Payment :Rashmi_Tijare:03-07-2015- added check box for min subs licensee
      i_ald_min_subs_fl     IN     sak_allocation_detail.ALD_MIN_GUA_FLAG%TYPE,
      --End:Warner Payment----
      o_ald_id                 OUT sak_allocation_detail.ald_id%TYPE)
   AS
      l_alloc_exists       NUMBER;
      l_cha_number         NUMBER;
      l_date               DATE;
      l_time               NUMBER;
      l_message            VARCHAR2 (200);
      l_lee_number         NUMBER;
      alloc_exists         EXCEPTION;
      live_info_required   EXCEPTION;
      l_o_flag             NUMBER;
      l_message            VARCHAR2 (200);
      norights             EXCEPTION;
   BEGIN
      /* pkg_adm_cm_dealmemo.prc_check_user_auth_for_update (i_met_mem_id,
                                                          i_met_entry_oper,
                                                          l_o_flag,
                                                          l_message
                                                         );

      IF (l_o_flag = 0)
      THEN
         RAISE norights;
      END IF; */
      SELECT lee_number
        INTO l_lee_number
        FROM fid_licensee                                      --, fid_company
       WHERE        --lee_cha_com_number = com_number  AND com_type = 'CC' AND
            lee_short_name = i_lee_short_name;

      -- DBMS_OUTPUT.put_line ('i_lee_short_name:' || l_lee_number);
      /*SELECT cha_number
        INTO l_cha_number
        FROM (SELECT cha_number
                FROM fid_channel
               WHERE cha_short_name = i_cha_short_name
              UNION
              SELECT chs_number
                FROM fid_channel_service
               WHERE chs_short_name = i_cha_short_name);*/

      -- DBMS_OUTPUT.put_line ('l_cha_number :' || l_cha_number);
      SELECT COUNT (*)
        INTO l_alloc_exists
        FROM sak_allocation_detail
       WHERE     ald_chs_number = i_cha_number
             AND ald_lee_number = l_lee_number
             AND ald_mei_id = i_mei_id;

      -- DBMS_OUTPUT.put_line ('l_alloc_exists :' || l_alloc_exists);
      IF (l_alloc_exists = 0)
      THEN
         o_ald_id := get_seq ('SEQ_ALD_ID');

         INSERT INTO sak_allocation_detail (ald_id,
                                            ald_mei_id,
                                            ald_lee_number,
                                            ald_amount,
                                            ald_exhib_days,
                                            ald_chs_number,
                                            ald_period_tba,
                                            ald_period_start,
                                            ald_period_end,  -- ald_live_date,
                                            ald_black_days,
                                            ald_cost_runs,
                                            ald_max_runs_cha,
                                            ---------------Dev:Africa free repeat:Hari_18-03-2013--------------------
                                            ald_max_runs_chs,
                                            ald_free_repeat,
                                            ald_repeat_period,
                                            ald_months,
                                            ald_lic_type,
                                            ---------------END Dev:Africa free repeat--------------------------------
                                            ald_end_days,
                                            ald_entry_oper,
                                            ald_entry_date,
                                            --ald_is_deleted,
                                            ald_update_count,
                                            --Warner Payment:Rashmi:03-07-2015:insertion of min subs licensee flag
                                            ALD_MIN_GUA_FLAG)
              VALUES (o_ald_id,
                      i_mei_id,
                      l_lee_number,
                      i_ald_amount,
                      i_ald_exhib_days,
                      i_cha_number,
                      i_ald_period_tba,
                      i_ald_period_start,
                      i_ald_period_end,                     --i_ald_live_date,
                      i_ald_black_days,
                      i_ald_cost_runs,
                      i_ald_max_runs_cha,
                      ---------------Dev:Africa free repeat:Hari_18-03-2013--------------------
                      i_ald_max_runs_chs,
                      i_ald_free_repeat,
                      i_ald_repeat_period,
                      i_ald_months,
                      i_ald_lic_type,
                      ---------------END Dev:Africa free repeat--------------------------------
                      i_ald_end_days,
                      i_user_id,
                      SYSDATE,
                      --'N',
                      0,
                      --Warner Payment:Rashmi:03-07-2015
                      i_ald_min_subs_fl);

         /* DBMS_OUTPUT.put_line (   o_ald_id
                                || ' ,'
                                || i_mei_id
                                || ' ,'
                                || l_lee_number
                                || ' ,'
                                || i_ald_amount
                                || ' ,'
                                || i_ald_exhib_days
                                || ' ,'
                                || l_cha_number
                                || ' ,'
                                || i_ald_period_tba
                                || ' ,'
                                || i_ald_period_start
                                || ' ,'
                                || i_ald_period_end
                                || ' ,'
                                ||                           --i_ald_live_date,
                                   i_ald_black_days
                                || ' ,'
                                || i_ald_cost_runs
                                || ' ,'
                                || i_ald_max_runs_cha
                                || ' ,'
                                || i_ald_max_runs_chs
                                || ' ,'
                                || i_ald_months
                                || ' ,'
                                || i_ald_lic_type
                                || ' ,'
                                || i_ald_end_days
                                || ' ,'
                                || i_user_id
                              );*/
         ---Pure Finance:Start:[Hari Mandal]_[09/05/2013]
         INSERT INTO x_fin_dm_sec_lee (dsl_number,
                                       dsl_mei_id,
                                       dsl_lee_number,
                                       dsl_is_primary,
                                       dsl_amount,
                                       dsl_entry_oper,
                                       dsl_entry_date,
                                       dsl_update_count,
                                       dsl_primary_lee)
              VALUES (seq_dsl_id.NEXTVAL,
                      i_mei_id,
                      l_lee_number,
                      'Y',
                      i_ald_amount,
                      i_user_id,
                      SYSDATE,
                      0,
                      l_lee_number);

         COMMIT;
      ELSE
         RAISE alloc_exists;
      END IF;
   EXCEPTION
      WHEN alloc_exists
      THEN
         raise_application_error (
            -20001,
            'Allocation already exists for this Licensee');
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_add_dm_alloc_details;

   ------------------------------------- PROCEDURE FOR UPDATE ALLOCATIONS FOR PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_update_dm_alloc_details (
      i_mei_id              IN     sak_memo_item.mei_id%TYPE,
      i_ald_id              IN     sak_allocation_detail.ald_id%TYPE,
      i_mei_gen_refno       IN     sak_memo_item.mei_gen_refno%TYPE,
      i_mem_amort_method    IN     sak_memo.mem_amort_method%TYPE,
      i_lee_short_name      IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount          IN     sak_allocation_detail.ald_amount%TYPE,
      i_ald_exhib_days      IN     sak_allocation_detail.ald_exhib_days%TYPE,
      -- i_cha_short_name     IN       fid_channel.cha_short_name%TYPE,
      i_cha_number          IN     fid_channel.cha_number%TYPE,
      i_ald_period_tba      IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_ald_period_start    IN     sak_allocation_detail.ald_period_start%TYPE,
      i_ald_period_end      IN     sak_allocation_detail.ald_period_end%TYPE,
      -- i_ald_live_date      IN       sak_allocation_detail.ald_live_date%TYPE,
      i_ald_black_days      IN     sak_allocation_detail.ald_black_days%TYPE,
      --start: project BIOSCOPE ? PENDING CR?S: MANGESH_20121019
      --[PB_CR_64 update Cost runs,max cha,max chs]
      i_ald_cost_runs       IN     sak_allocation_detail.ald_cost_runs%TYPE,
      i_ald_max_runs_cha    IN     sak_allocation_detail.ald_max_runs_cha%TYPE,
      i_ald_max_runs_chs    IN     sak_allocation_detail.ald_max_runs_chs%TYPE,
      --END: Project Bioscope ? Pending CR?s:
      ---------------Dev:Africa free repeat:Hari_18-03-2013--------------------
      ---------------adding variables for free repeats and repeat period-------
      i_ald_free_repeat     IN     sak_allocation_detail.ald_free_repeat%TYPE,
      i_ald_repeat_period   IN     sak_allocation_detail.ald_repeat_period%TYPE,
      ---------------END Dev:Africa free repeat--------------------------------
      i_ald_months          IN     sak_allocation_detail.ald_months%TYPE,
      i_ald_lic_type        IN     sak_allocation_detail.ald_lic_type%TYPE,
      --i_user_id            IN   sak_allocation_detail.ald_entry_oper%TYPE,
      i_ald_end_days        IN     sak_allocation_detail.ald_end_days%TYPE,
      -- BR_15_144- Warner Payment :Rashmi_Tijare:03-07-2015- added check box for min subs licensee
      i_ald_min_subs_fl     IN     sak_allocation_detail.ALD_MIN_GUA_FLAG%TYPE,
      --End:Warner Payment----
      o_ald_update_count    IN OUT sak_allocation_detail.ald_update_count%TYPE)
   AS
      l_lee_number         NUMBER;
      -- l_cha_number    NUMBER;
      l_ald_lee_number     NUMBER;
      l_ald_chs_number     NUMBER;
      l_alloc_exists       NUMBER;
      l_rec_exists         NUMBER;
      update_failed        EXCEPTION;
      alloc_exists         EXCEPTION;
      l_original_lee       NUMBER;
      l_original_ammount   NUMBER;
      --Dev.R3 : Placeholder : Start : [Devashish_Raverkar]_[2014/05/13]
      l_min_sch_date       DATE;
      l_max_sch_date       DATE;
      --Dev.R3 : Placeholder : End :
      -- Devashish/Shantanu , 30/jan/2014
      l_ald_update_count   sak_allocation_detail.ald_update_count%TYPE;
      l_mei_type_show      sak_memo_item.mei_type_show%TYPE;
      l_mei_mem_id         sak_memo_item.mei_mem_id%TYPE;
      l_Ser_NonSer         VARCHAR2 (10);
      l_sch_count          NUMBER;
      l_tba_sch_count      NUMBER;
   --End
   BEGIN
      SELECT lee_number
        INTO l_lee_number
        FROM fid_licensee, fid_company
       WHERE     lee_cha_com_number = com_number
             AND com_type = 'CC'
             AND lee_short_name = i_lee_short_name;


      --Dev.R3 : Placeholder : Start : [Devashish_Raverkar]_[2014/05/13]
      --Check Schedule before updating allocation details

      SELECT mei_type_show, mei_mem_id
        INTO l_mei_type_show, l_mei_mem_id
        FROM sak_memo_item
       WHERE mei_id = i_mei_id;

      l_Ser_NonSer := X_FNC_GET_PROG_TYPE (l_mei_type_show);

      IF l_Ser_NonSer = 'N'
      THEN
         SELECT COUNT (*)
           INTO l_sch_count
           FROM fid_license, fid_schedule
          WHERE sch_lic_number = lic_number
                AND sch_date NOT BETWEEN i_ald_period_start
                                     AND i_ald_period_end
                AND lic_mem_number = l_mei_mem_id
                AND lic_gen_refno = i_mei_gen_refno
                AND lic_lee_number = l_lee_number;
      ELSE
         SELECT COUNT (*)
           INTO l_sch_count
           FROM fid_license, fid_general, fid_schedule
          WHERE lic_gen_refno = gen_refno AND sch_lic_number = lic_number
                AND sch_date NOT BETWEEN i_ald_period_start
                                     AND i_ald_period_end
                AND lic_mem_number = l_mei_mem_id
                AND gen_ser_number = i_mei_gen_refno
                AND lic_lee_number = l_lee_number;
      END IF;

      IF l_sch_count > 0
      THEN
         raise_application_error (
            -20013,
            'T License is scheduled. The Scheduled date should be between start date and end date!');
      END IF;

      IF l_Ser_NonSer = 'N'
      THEN
         SELECT COUNT (*)
           INTO l_tba_sch_count
           FROM fid_license,
                fid_schedule,
                sak_memo_item,
                sak_allocation_detail
          WHERE     lic_mem_number = mei_mem_id
                AND sch_lic_number = lic_number
                AND mei_id = ald_mei_id
                AND lic_lee_Number = ald_lee_number
                AND lic_gen_refno = i_mei_gen_refno
                AND lic_status = 'T'
                AND i_ald_period_tba = 'Y'
                AND ald_id = i_ald_id
                AND mei_mem_id = l_mei_mem_id;
      ELSE
         SELECT COUNT (*)
           INTO l_tba_sch_count
           FROM fid_license,
                fid_schedule,
                sak_memo_item,
                sak_allocation_detail,
                fid_general
          WHERE     lic_mem_number = mei_mem_id
                AND sch_lic_number = lic_number
                AND mei_id = ald_mei_id
                AND lic_lee_Number = ald_lee_number
                AND lic_gen_refno = gen_refno
                AND gen_ser_number = i_mei_gen_refno
                AND lic_status = 'T'
                AND i_ald_period_tba = 'Y'
                AND ald_id = i_ald_id
                AND mei_mem_id = l_mei_mem_id;
      END IF;

      IF l_tba_sch_count > 0
      THEN
         raise_application_error (
            -20013,
            'T License already Scheduled. You can not change its start date and end date to TBA! ');
      END IF;

      --Dev.R3 : Placeholder : End :
      /*SELECT cha_number
        INTO l_cha_number
        FROM (SELECT cha_number
                FROM fid_channel
               WHERE cha_short_name = i_cha_short_name
              UNION
              SELECT chs_number
                FROM fid_channel_service
               WHERE chs_short_name = i_cha_short_name);*/
      ---CFIN3 added the below code for Finance validation PRANAY KUSUMWAL 23/02/2014
      SELECT ald_lee_number
        INTO l_original_lee
        FROM sak_allocation_detail
       WHERE ald_mei_id = i_mei_id AND ald_id = i_ald_id;

      SELECT ald_amount
        INTO l_original_ammount
        FROM sak_allocation_detail
       WHERE ald_mei_id = i_mei_id AND ald_id = i_ald_id;

      ----END   PRANAY KUSUMWAL   23/02/2013
      SELECT COUNT (1)
        INTO l_rec_exists
        FROM sak_allocation_detail
       WHERE     ald_id = i_ald_id
             AND ald_mei_id = i_mei_id
             AND ald_update_count = o_ald_update_count;

      SELECT COUNT (1)
        INTO l_alloc_exists
        FROM sak_allocation_detail
       WHERE     ald_mei_id = i_mei_id
             AND ald_lee_number = l_lee_number
             AND ald_chs_number = i_cha_number
             AND ald_id <> i_ald_id;

      IF (l_rec_exists = 1)
      THEN
         IF l_alloc_exists >= 1
         THEN
            RAISE alloc_exists;
         ELSE
            UPDATE sak_allocation_detail
               SET ald_lee_number = l_lee_number,
                   ald_amount = i_ald_amount,
                   ald_exhib_days = i_ald_exhib_days,
                   ald_chs_number = i_cha_number,
                   ald_period_tba = i_ald_period_tba,
                   ald_period_start = i_ald_period_start,
                   ald_period_end = i_ald_period_end,
                   -- ald_live_date = i_ald_live_date,
                   ald_black_days = i_ald_black_days,
                   --start: project BIOSCOPE ? PENDING CR?S: MANGESH_20121019
                   --[PB_CR_64 update Cost runs,max cha,max chs]
                   ald_cost_runs = i_ald_cost_runs,
                   ald_max_runs_cha = i_ald_max_runs_cha,
                   ald_max_runs_chs = i_ald_max_runs_chs,
                   --END: Project Bioscope ? Pending CR?s:
                   ---------------Dev:Africa free repeat:Hari_18-03-2013--------------------
                   ald_free_repeat = i_ald_free_repeat,
                   ald_repeat_period = i_ald_repeat_period,
                   ---------------END Dev:Africa free repeat--------------------------------
                   ald_months = i_ald_months,
                   ald_lic_type = i_ald_lic_type,
                   ald_end_days = i_ald_end_days,
                   -- BR_15_144- Warner Payment :Rashmi_Tijare:03-07-2015- Updation of min subs licensee
                   ALD_MIN_GUA_FLAG = i_ald_min_subs_fl
             --End:Warner Payment----
             --ald_update_count = ald_update_count + 1
             WHERE ald_mei_id = i_mei_id AND ald_id = i_ald_id;

            --AND ald_update_count = o_ald_update_count
            --RETURNING ald_update_count
            --INTO o_ald_update_count;

            /*
              AUTHOR : Devashish/Shantanu,
              DATE : 30/jan/2014,
              Description : Update Count Functionality Modified
            */
            SELECT ald_update_count
              INTO l_ald_update_count
              FROM sak_allocation_detail
             WHERE ald_mei_id = i_mei_id AND ald_id = i_ald_id;

            IF (l_ald_update_count = o_ald_update_count)
            THEN
               UPDATE sak_allocation_detail
                  SET ald_update_count = ald_update_count + 1
                WHERE ald_mei_id = i_mei_id AND ald_id = i_ald_id;

               COMMIT;

               SELECT ald_update_count
                 INTO o_ald_update_count
                 FROM sak_allocation_detail
                WHERE ald_mei_id = i_mei_id AND ald_id = i_ald_id;
            ELSE
               ROLLBACK;
               raise_application_error (
                  -20326,
                  'Other user has been modified some data regarding Allocation');
            END IF;

            /************************End Of the Update count Functionality*******************/
            IF o_ald_update_count > 0
            THEN
               ---CFIN3 added the below code for Finance validation PRANAY KUSUMWAL 23/02/2014
               IF l_original_lee <> l_lee_number
               THEN
                  UPDATE x_fin_dm_sec_lee
                     SET dsl_lee_number = l_lee_number,
                         dsl_primary_lee = l_lee_number
                   WHERE     dsl_is_primary = 'Y'
                         AND dsl_mei_id = i_mei_id
                         AND dsl_primary_lee = l_original_lee;

                  UPDATE x_fin_dm_sec_lee
                     SET dsl_primary_lee = l_lee_number
                   WHERE     dsl_is_primary = 'N'
                         AND dsl_mei_id = i_mei_id
                         AND dsl_primary_lee = l_original_lee;
               END IF;

               IF l_original_ammount <> i_ald_amount
               THEN
                  UPDATE x_fin_dm_sec_lee
                     SET dsl_amount = i_ald_amount
                   WHERE     dsl_is_primary = 'Y'
                         AND dsl_mei_id = i_mei_id
                         AND dsl_primary_lee = l_original_lee;
               END IF;

               ----END   PRANAY KUSUMWAL   23/02/2013
               COMMIT;
            ELSE
               RAISE update_failed;
            END IF;
         END IF;
      END IF;
   EXCEPTION
      WHEN alloc_exists
      THEN
         raise_application_error (
            -20001,
            'Allocation already exists for this Licensee');
      WHEN update_failed
      THEN
         raise_application_error (
            -20013,
            'Update Failed' || SUBSTR (SQLERRM, 1, 150));
      WHEN OTHERS
      THEN
         raise_application_error (-20013, SUBSTR (SQLERRM, 1, 150));
   END prc_update_dm_alloc_details;

   ------------------------------------- PROCEDURE FOR DELETE ALLOCATIONS FOR PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_delete_dm_alloc_details (
      -- i_mei_id             IN       sak_memo_item.mei_id%TYPE,
      i_ald_id             IN     sak_allocation_detail.ald_id%TYPE,
      i_ald_update_count   IN     sak_allocation_detail.ald_update_count%TYPE,
      --i_chr_update_count   IN       sak_channel_runs.chr_update_count%TYPE,
      o_deleted               OUT NUMBER)
   AS
      l_flag           NUMBER;
      l_original_lee   NUMBER;
      l_original_mei   NUMBER;
   BEGIN
      BEGIN
         DELETE FROM sak_channel_runs
               WHERE chr_ald_id = i_ald_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      ---CFIN3 added the below code for Finance validation PRANAY KUSUMWAL 23/02/2014
      SELECT ald_lee_number, ald_mei_id
        INTO l_original_lee, l_original_mei
        FROM sak_allocation_detail
       WHERE ald_id = i_ald_id;

      DELETE FROM x_fin_dm_sec_lee
            WHERE     dsl_is_primary = 'Y'
                  AND dsl_mei_id = l_original_mei
                  AND dsl_lee_number = l_original_lee;

      --CACQ14: Start :SUSHMA K ON 14-NOV-2014 To delete the media device rights on deal level
      DELETE FROM x_cp_memo_medplatdevcompat_map
            WHERE MEM_MPDC_ALD_ID = i_ald_id;

      --END

      DELETE x_cp_licensee_platform
       WHERE cp_lee_plat_ald_id = i_ald_id;

      ---CFIN3 END PRANAY KUSUMWAL 23/02/2014
      DELETE FROM sak_allocation_detail
            WHERE NVL (ald_update_count, 0) = NVL (i_ald_update_count, 0) --  AND ald_mei_id = i_mei_id
                  AND ald_id = i_ald_id;

      l_flag := SQL%ROWCOUNT;
      o_deleted := l_flag;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_delete_dm_alloc_details;

   ------------------------------------- PROCEDURE FOR ADD CHANNEL RUNS FOR ALLOCATIONS OF PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_add_dm_cha_runs (
      i_chr_ald_id         IN     sak_allocation_detail.ald_id%TYPE,
      i_cha_short_name     IN     fid_channel.cha_short_name%TYPE,
      i_chr_number_runs    IN     sak_channel_runs.chr_number_runs%TYPE,
      i_chr_costed_runs    IN     sak_channel_runs.chr_costed_runs%TYPE,
      i_user_id            IN     sak_channel_runs.chr_entry_oper%TYPE,
      i_chr_cost_channel   IN     sak_channel_runs.chr_cost_channel%TYPE,
      /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
      i_chr_max_runs_chr   IN     sak_channel_runs.chr_max_runs_chr%TYPE,
      /*PB (CR): END */
      o_chr_id                OUT sak_channel_runs.chr_id%TYPE)
   AS
      l_cha_number          NUMBER;
      l_chr_found           NUMBER;
      channel_runs_exists   EXCEPTION;
      l_o_flag              NUMBER;
      l_message             VARCHAR2 (200);
      norights              EXCEPTION;
   BEGIN
      SELECT cha_number
        INTO l_cha_number
        FROM fid_channel
       WHERE cha_short_name = i_cha_short_name;

      SELECT COUNT (chr_ald_id)
        INTO l_chr_found
        FROM sak_channel_runs
       WHERE chr_ald_id = i_chr_ald_id AND chr_cha_number = l_cha_number;

      --  DBMS_OUTPUT.put_line ('l_cha_number: ' || l_cha_number);
      --  DBMS_OUTPUT.put_line ('l_chr_found: ' || l_chr_found);

      IF l_chr_found = 0
      THEN
         o_chr_id := get_seq ('SEQ_CHR_NUMBER');

         INSERT INTO sak_channel_runs (chr_id,
                                       chr_ald_id,
                                       chr_cha_number,
                                       chr_number_runs,
                                       chr_cost_channel,
                                       chr_entry_oper,
                                       --Bioscope Changes by Anirudha on 15/03/2012 :start
                                       chr_costed_runs,
                                       --Bioscope Changes end
                                       chr_entry_date,      -- chr_is_deleted,
                                       /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
                                       chr_max_runs_chr,
                                       /*PB (CR): END */
                                       chr_update_count)
              VALUES (o_chr_id,
                      i_chr_ald_id,
                      l_cha_number,
                      i_chr_number_runs,
                      i_chr_cost_channel,
                      i_user_id,
                      --Bioscope Changes by Anirudha on 15/03/2012 start
                      i_chr_costed_runs,
                      --Bioscope Changes end
                      SYSDATE,                                          --'N',
                      /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
                      i_chr_max_runs_chr,
                      /*PB (CR): END */
                      0);

         COMMIT;
      --DBMS_OUTPUT.put_line ('inserted');
      ELSE
         RAISE channel_runs_exists;
      END IF;
   EXCEPTION
      WHEN channel_runs_exists
      THEN
         raise_application_error (-20011,
                                  'Record already exists for this Channel');
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_add_dm_cha_runs;

   ------------------------------------- PROCEDURE FOR UPDATE CHANNEL RUNS FOR ALLOCATIONS OF PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_update_dm_cha_runs (
      i_chr_id             IN     sak_channel_runs.chr_id%TYPE,
      i_cha_short_name     IN     fid_channel.cha_short_name%TYPE,
      i_chr_number_runs    IN     sak_channel_runs.chr_number_runs%TYPE,
      i_chr_cost_channel   IN     sak_channel_runs.chr_cost_channel%TYPE,
      i_chr_costed_runs    IN     sak_channel_runs.chr_costed_runs%TYPE,
      i_chr_update_count   IN     sak_channel_runs.chr_update_count%TYPE,
      /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
      i_chr_max_runs_chr   IN     sak_channel_runs.chr_max_runs_chr%TYPE,
      /*PB (CR): END */
      o_chr_update_count      OUT sak_channel_runs.chr_update_count%TYPE)
   AS
      l_message            VARCHAR2 (150);
      chr_update_count     NUMBER;
      l_cha_number         NUMBER;
      l_total_for_chs      NUMBER;
      l_ald_max_runs_cha   NUMBER;
      l_ald_max_runs_chs   NUMBER;
      l_ald_exhib_days     NUMBER;
      l_mem_mplex_ind      VARCHAR2 (1);
      l_mem_align_ind      VARCHAR2 (1);
      l_mem_amort_method   VARCHAR2 (1);
      updatefailed         EXCEPTION;
   BEGIN
      --PB_CR mangesh_20122911:initialized o_chr_update_count
      o_chr_update_count := -1;

      --PB_CR END
      /*
         SELECT mem_mplex_ind, mem_align_ind, mem_amort_method
           INTO l_mem_mplex_ind, l_mem_align_ind, l_mem_amort_method
           FROM sak_memo
          WHERE mem_id IN (SELECT ald_mei_id
                             FROM sak_allocation_detail
                            WHERE ald_id IN (SELECT chr_ald_id
                                               FROM sak_channel_runs
                                              WHERE chr_id = i_chr_id));

         SELECT ald_max_runs_cha
           INTO l_ald_max_runs_cha
           FROM sak_allocation_detail
          WHERE ald_id IN (SELECT chr_ald_id
                             FROM sak_channel_runs
                            WHERE chr_id = i_chr_id);

         IF i_chr_number_runs > NVL (l_ald_max_runs_cha, 0)
         THEN
            l_message :=
               'Number of runs cannot exceed the maximum specified for the Channel.';
            raise_application_error (-20016, 'Error: ' || l_message);
         END IF;
   */
      /**/
      ---------to be checked at UI
      /*
            BEGIN
               IF l_total_for_chs > NVL (l_ald_max_runs_chs, 0)
               THEN
                  l_message :=
                     'Number of runs cannot exceed the maximum specified for the Channel Service.';
                  raise_application_error (-20017, 'Error: ' || l_message);
               END IF;
      */
      SELECT cha_number
        INTO l_cha_number
        FROM fid_channel
       WHERE cha_short_name = i_cha_short_name;

      UPDATE sak_channel_runs
         SET chr_cha_number = l_cha_number,
             chr_number_runs = i_chr_number_runs,
             chr_cost_channel = i_chr_cost_channel,
             --Bioscope Changes by Anirudha on 15/03/2012 start
             chr_costed_runs = i_chr_costed_runs,
             --Bioscope Changes end
             --chr_update_count = chr_update_count + 1,
             /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
             chr_max_runs_chr = i_chr_max_runs_chr
       /*PB (CR): END */
       WHERE chr_id = i_chr_id;

      --AND chr_update_count = i_chr_update_count
      -- RETURNING chr_update_count
      --INTO o_chr_update_count;

      --COMMIT;
      /*********************************
         AUTHOR : Devashish/Shantanu
         DATE : 30/jan/2014
         Description : Modified Update Count Functionality

      **********************************/
      IF NVL (i_chr_id, 0) <> 0
      THEN
         SELECT chr_update_count
           INTO chr_update_count
           FROM sak_channel_runs
          WHERE chr_id = i_chr_id;

         IF (chr_update_count = i_chr_update_count)
         THEN
            UPDATE sak_channel_runs
               SET chr_update_count = chr_update_count + 1
             WHERE chr_id = i_chr_id;

            COMMIT;

            SELECT chr_update_count
              INTO o_chr_update_count
              FROM sak_channel_runs
             WHERE chr_id = i_chr_id;
         ELSE
            ROLLBACK;
            raise_application_error (
               -20005,
               'Channel run details are already changed by other user');
         END IF;
      END IF;
   /*****************End of Update Count Functionality*******************/

   /*      IF (i_chr_update_count = o_chr_update_count)
      THEN
         RAISE updatefailed;
      END IF;
   EXCEPTION
      WHEN updatefailed
      THEN
         raise_application_error (-20013, 'Update Failed !');
      WHEN OTHERS
      THEN
         raise_application_error (-20013, SUBSTR (SQLERRM, 1, 150));*/
   --END;
   /*
         BEGIN
            SELECT SUM (chr_number_runs)
              INTO l_total_for_chs
              FROM sak_channel_runs
             WHERE chr_ald_id IN (SELECT chr_ald_id
                                    FROM sak_channel_runs
                                   WHERE chr_id = i_chr_id);

            IF NVL (l_mem_mplex_ind, 'Y') = 'N'
               AND NVL (l_mem_align_ind, 'N') = 'N'
            THEN
               l_ald_exhib_days := l_total_for_chs;

               UPDATE sak_allocation_detail
                  SET ald_exhib_days = l_ald_exhib_days,
                      ald_update_count = ald_update_count + 1
                WHERE ald_id IN (SELECT chr_ald_id
                                   FROM sak_channel_runs
                                  WHERE chr_id = i_chr_id)
                  AND ald_update_count = i_ald_update_count;

               COMMIT;
               o_ald_exhib_days := l_ald_exhib_days;
            END IF;

            SELECT ald_update_count
              INTO o_ald_update_count
              FROM sak_allocation_detail
             WHERE ald_id IN (SELECT chr_ald_id
                                FROM sak_channel_runs
                               WHERE chr_id = i_chr_id);

            SELECT chr_update_count
              INTO o_chr_update_count
              FROM sak_channel_runs
             WHERE chr_id = i_chr_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20013, SUBSTR (SQLERRM, 1, 150));
         END;
         */
   END prc_update_dm_cha_runs;

   ------------------------------------- PROCEDURE FOR DELETE CHANNEL RUNS FOR ALLOCATIONS OF PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_delete_dm_cha_runs (
      -- i_chr_ald_id   IN   sak_allocation_detail.ald_id%TYPE,
      i_chr_id             IN     sak_channel_runs.chr_id%TYPE,
      i_chr_update_count   IN     sak_channel_runs.chr_update_count%TYPE,
      o_deleted               OUT NUMBER)
   AS
      l_flag   NUMBER;
   BEGIN
      DELETE FROM sak_channel_runs
            WHERE chr_id = i_chr_id
                  AND NVL (chr_update_count, 0) = NVL (i_chr_update_count, 0);

      --and chr_ald_id = i_chr_ald_id;
      l_flag := SQL%ROWCOUNT;

      IF l_flag <> 0
      THEN
         o_deleted := l_flag;
         COMMIT;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_delete_dm_cha_runs;

   ------------------------------------- PROCEDURE FOR CHECK CHANNEL ALLOCATIONS OF PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_check_allocations (
      i_mem_id     IN     sak_memo_item.mei_mem_id%TYPE,
      i_mem_type   IN     sak_memo.mem_type%TYPE,
      o_string        OUT VARCHAR2)
   AS
      l_total_amount          NUMBER;
      l_error                 VARCHAR2 (1);
      mem_id                  NUMBER;
      l_gen_title             VARCHAR2 (40);
      l_message               VARCHAR2 (200);
      allocation_chk_failed   EXCEPTION;

      CURSOR c_sak_mei
      IS
         SELECT mei_total_price, mei_id, gen_title
           FROM sak_memo_item, fid_general
          WHERE mei_gen_refno = gen_refno AND mei_mem_id = i_mem_id;
   BEGIN
      l_error := 'N';

      FOR items IN c_sak_mei
      LOOP
         -- Prepare the error message...
         IF LENGTH (items.gen_title) <= 20
         THEN
            l_gen_title := items.gen_title;
         ELSE
            l_gen_title := SUBSTR (items.gen_title, 1, 20) || '...';
         END IF;

         -- Flat-fees must all add up...
         IF i_mem_type = 'FLF'
         THEN
            BEGIN
               SELECT NVL (SUM (ald_amount), 0)
                 INTO l_total_amount
                 FROM sak_allocation_detail
                WHERE ald_mei_id = items.mei_id;
            END;

            IF l_total_amount IS NULL
            THEN
               l_message :=
                     'WARNING: "'
                  || l_gen_title
                  || '" has no allocations specified. ';
               --l_error := 'Y';
               o_string := l_message;
               --EXIT;
               RAISE allocation_chk_failed;
            ELSIF l_total_amount > items.mei_total_price
            THEN
               l_message :=
                  'WARNING: "' || l_gen_title || '" overallocated ' || ' by '
                  || TO_CHAR (l_total_amount - items.mei_total_price,
                              '999999999.9990');
               -- l_error := 'Y';
               o_string := l_message;
               --EXIT;
               RAISE allocation_chk_failed;
            ELSIF l_total_amount < items.mei_total_price
            THEN
               l_message :=
                     'WARNING: "'
                  || l_gen_title
                  || '" underallocated '
                  || ' by '
                  || TO_CHAR (items.mei_total_price - l_total_amount,
                              '999999999.9990');
               -- l_error := 'Y';
               o_string := l_message;
               --EXIT;
               RAISE allocation_chk_failed;
            END IF;
         -- Royalties must all be the same
         ELSIF i_mem_type = 'ROY'
         THEN
            DECLARE
               CURSOR c_sak_alloc_diff_amt
               IS
                  SELECT ald_mei_id
                    FROM sak_allocation_detail
                   WHERE ald_mei_id = items.mei_id
                         AND items.mei_total_price <> ald_amount;

               l_sak_alloc_diff_amt   c_sak_alloc_diff_amt%ROWTYPE;
            BEGIN
               OPEN c_sak_alloc_diff_amt;

               FETCH c_sak_alloc_diff_amt INTO l_sak_alloc_diff_amt;

               IF c_sak_alloc_diff_amt%FOUND
               THEN
                  l_message :=
                     'WARNING: Price-per-subscriber inconsistent for '
                     || l_gen_title;
                  -- l_error := 'Y';
                  o_string := l_message;
                  --EXIT;
                  RAISE allocation_chk_failed;
               END IF;

               CLOSE c_sak_alloc_diff_amt;
            END;
         END IF;
      END LOOP;

      o_string := 'Allocations check complete';
   EXCEPTION
      WHEN allocation_chk_failed
      THEN
         raise_application_error (-20601, l_message);
   END prc_check_allocations;

   ------------------------------------- PROCEDURE FOR CHECK CHANNEL RUNS FOR ALLOCATIONS OF PROGRAMS IN DEAL MEMO --------------------------------------
   PROCEDURE prc_check_cha_runs (i_mem_id IN NUMBER)
   AS
      CURSOR c_program
      IS
         SELECT mei_id, mei_type_show, mei_gen_refno
           FROM sak_memo_item
          WHERE mei_mem_id = i_mem_id;

      l_seryorn            VARCHAR2 (10);
      l_liveyorn           VARCHAR2 (10);
      l_mem_type           VARCHAR2 (30);
      l_mem_mplex_ind      VARCHAR2 (10);
      l_mem_align_ind      VARCHAR2 (10);
      l_message            VARCHAR2 (500);
      l_mem_amort_method   VARCHAR2 (10);
      was_check_error      VARCHAR2 (10);
      v_ald_start          DATE;
      l_go_live_date       DATE;
   BEGIN
      ---- CONSIDERATION FOR 5+2 COSTING RULE GO_LIVE DATE
      SELECT TO_DATE (C.CONTENT)
        INTO l_go_live_date
        FROM X_FIN_CONFIGS C
       --  WHERE C.KEY = 'COSTING_5+2_GO_LIVE_DATE';
       WHERE C.ID = 6;

      FOR c_program_rec IN c_program
      LOOP
         SELECT NVL (cod_attr1, 'N'), NVL (cod_attr2, 'N')
           INTO l_seryorn, l_liveyorn
           FROM fid_code
          WHERE cod_type = 'GEN_TYPE'
                AND cod_value = c_program_rec.mei_type_show;

         --DBMS_OUTPUT.PUT_LINE();
         SELECT mem_type,
                mem_mplex_ind,
                mem_align_ind,
                mem_amort_method
           INTO l_mem_type,
                l_mem_mplex_ind,
                l_mem_align_ind,
                l_mem_amort_method
           FROM sak_memo
          WHERE mem_id = i_mem_id;

         DECLARE
            -----here i have added ald_amount and ALD_COST_RUNS  to check if the allocation  is 0 and and cost runs is 0 then no need to tick cost indicator and check
            CURSOR get_mei
            IS
               SELECT ald_id,
                      lee_short_name,
                      gen_title,
                      NVL (ald_amount, 0),
                      ald_cost_runs,
                      ALD_PERIOD_START
                 FROM sak_memo_item,
                      sak_allocation_detail,
                      fid_general,
                      fid_licensee
                WHERE     mei_mem_id = i_mem_id
                      AND ald_mei_id = mei_id
                      AND ald_lee_number = lee_number
                      AND mei_gen_refno = gen_refno
                      --   AND NVL (lee_media_service_code, '#') not in ( 'CATCHUP','SVOD');
                      AND NVL (lee_media_service_code, '#') NOT IN
                             (SELECT ms_media_service_code
                                FROM sgy_pb_media_service
                               WHERE ms_media_service_code NOT IN
                                        ('PAYTV', 'TVOD'));



            v_ald_id          NUMBER;
            v_gen_title       VARCHAR2 (120);
            v_lee_short       VARCHAR2 (4);
            v_ald_amount      sak_allocation_detail.ald_amount%TYPE;
            v_ald_cost_runs   sak_allocation_detail.ald_cost_runs%TYPE;

            CURSOR cnt_cha_runs
            IS
               SELECT COUNT (*)
                 FROM sak_channel_runs
                WHERE chr_ald_id = v_ald_id;

            v_cnt_cha         NUMBER;

            CURSOR cnt_cost_cha_runs
            IS
               SELECT COUNT (*)
                 FROM sak_channel_runs
                WHERE chr_ald_id = v_ald_id AND chr_cost_channel = 'Y';

            v_cnt_cost        NUMBER;
         BEGIN
            IF l_seryorn = 'N'
            THEN
               IF NVL (l_mem_mplex_ind, 'Y') = 'N'
                  AND NVL (l_mem_align_ind, 'N') = 'N'
               THEN
                  OPEN get_mei;

                  LOOP
                     FETCH get_mei
                     INTO v_ald_id,
                          v_lee_short,
                          v_gen_title,
                          v_ald_amount,
                          v_ald_cost_runs,
                          v_ald_start;

                     EXIT WHEN get_mei%NOTFOUND;

                     OPEN cnt_cha_runs;

                     FETCH cnt_cha_runs INTO v_cnt_cha;

                     --   DBMS_OUTPUT.PUT_LINE (2);

                     IF v_cnt_cha = 0
                     THEN
                        l_message :=
                           'ERROR: At least one channel must be specified for channel runs on programme '
                           || v_gen_title
                           || ' for licensee '
                           || v_lee_short;
                        was_check_error := 'Y';
                     ELSE
                        IF l_mem_type = 'ROY' AND l_mem_amort_method != 'E'
                        THEN
                           IF v_ald_amount > 0
                           THEN
                              OPEN cnt_cost_cha_runs;

                              FETCH cnt_cost_cha_runs INTO v_cnt_cost;

                              IF v_cnt_cost = 0
                                 AND l_go_live_date > v_ald_start
                              THEN
                                 l_message :=
                                    'ERROR: At least one channel must be specified for costing on programme '
                                    || v_gen_title
                                    || ' for licensee '
                                    || v_lee_short;
                                 was_check_error := 'Y';
                              END IF;

                              CLOSE cnt_cost_cha_runs;
                           END IF;

                           IF v_ald_amount = 0 AND v_ald_cost_runs > 0
                           THEN
                              IF l_go_live_date > v_ald_start
                              THEN
                                 raise_application_error (
                                    -20601,
                                    'ERROR: Allocation must be specified if costed runs present on programme '
                                    || v_gen_title
                                    || ' for licensee '
                                    || v_lee_short);
                              END IF;

                              OPEN cnt_cost_cha_runs;

                              FETCH cnt_cost_cha_runs INTO v_cnt_cost;

                              IF v_cnt_cost = 0
                                 AND l_go_live_date > v_ald_start
                              THEN
                                 l_message :=
                                    'ERROR: At least one channel must be specified for costing on programme '
                                    || v_gen_title
                                    || ' for licensee '
                                    || v_lee_short;
                                 was_check_error := 'Y';
                              END IF;

                              CLOSE cnt_cost_cha_runs;
                           END IF;
                        END IF;
                     END IF;

                     CLOSE cnt_cha_runs;
                  END LOOP;

                  IF was_check_error = 'Y'
                  THEN
                     raise_application_error (-20601, l_message);
                  END IF;

                  CLOSE get_mei;
               END IF;
            END IF;
         END;

         DECLARE
            CURSOR chk_cha_runs
            IS
               SELECT gen_title, ald_max_runs_cha, chr_number_runs
                 FROM sak_memo_item,
                      sak_allocation_detail,
                      sak_channel_runs,
                      fid_general
                WHERE     mei_mem_id = i_mem_id
                      AND mei_id = ald_mei_id
                      AND ald_id = chr_ald_id
                      AND ald_max_runs_cha < chr_number_runs
                      AND mei_gen_refno = gen_refno;

            v_gen_title   VARCHAR2 (120);
            v_max_cha     NUMBER;
            v_cha_runs    NUMBER;
         BEGIN
            IF l_seryorn = 'N'
            THEN
               BEGIN
                  OPEN chk_cha_runs;

                  LOOP
                     FETCH chk_cha_runs
                     INTO v_gen_title, v_max_cha, v_cha_runs;

                     EXIT WHEN chk_cha_runs%NOTFOUND;
                     l_message :=
                           'Programme '
                        || v_gen_title
                        || ' has Channel Runs greater than specified maximum';
                     was_check_error := 'Y';
                     raise_application_error (-20601, l_message);
                  END LOOP;

                  CLOSE chk_cha_runs;
               END;
            END IF;
         END;

         BEGIN
            DECLARE
               CURSOR get_meis
               IS
                  SELECT ald_id,
                         lee_short_name,
                         gen_title,
                         ald_amount,
                         ald_cost_runs
                    FROM sak_memo_item,
                         sak_allocation_detail,
                         fid_general,
                         fid_licensee
                   WHERE     mei_mem_id = i_mem_id
                         AND ald_mei_id = mei_id
                         AND ald_lee_number = lee_number
                         AND mei_gen_refno = gen_ser_number
                         -- Catchup Change on 27-OCT-2012 by Anirudha
                         --  AND NVL (lee_media_service_code, '#') not in ( 'CATCHUP','SVOD') -- End change
                         AND NVL (lee_media_service_code, '#') NOT IN
                                (SELECT ms_media_service_code
                                   FROM sgy_pb_media_service
                                  WHERE ms_media_service_code NOT IN
                                           ('PAYTV', 'TVOD'));

               v_ald_id          NUMBER;
               v_gen_title       VARCHAR2 (120);
               v_lee_short       VARCHAR2 (4);
               l_ald_amount      sak_allocation_detail.ald_amount%TYPE;
               l_ald_cost_runs   sak_allocation_detail.ald_cost_runs%TYPE;

               CURSOR cnt_cha_runs
               IS
                  SELECT COUNT (*)
                    FROM sak_channel_runs
                   WHERE chr_ald_id = v_ald_id;

               v_cnt_cha         NUMBER;

               CURSOR cnt_cost_cha_runs
               IS
                  SELECT COUNT (*)
                    FROM sak_channel_runs
                   WHERE chr_ald_id = v_ald_id AND chr_cost_channel = 'Y';

               v_cnt_cost        NUMBER;
            BEGIN
               IF l_seryorn = 'Y'
               THEN
                  IF NVL (l_mem_mplex_ind, 'Y') = 'N'
                     AND NVL (l_mem_align_ind, 'N') = 'N'
                  THEN
                     OPEN get_meis;

                     LOOP
                        FETCH get_meis
                        INTO v_ald_id,
                             v_lee_short,
                             v_gen_title,
                             l_ald_amount,
                             l_ald_cost_runs;

                        EXIT WHEN get_meis%NOTFOUND;

                        OPEN cnt_cha_runs;

                        FETCH cnt_cha_runs INTO v_cnt_cha;

                        IF v_cnt_cha = 0
                        THEN
                           l_message :=
                              'ERROR: At least one channel must be specified for channel runs on programme '
                              || v_gen_title
                              || ' for licensee '
                              || v_lee_short;
                           was_check_error := 'Y';
                        ELSE
                           IF l_mem_type = 'ROY'
                           THEN
                              IF l_ald_amount > 0
                              THEN
                                 OPEN cnt_cost_cha_runs;

                                 FETCH cnt_cost_cha_runs INTO v_cnt_cost;

                                 IF v_cnt_cost = 0
                                    AND l_go_live_date > v_ald_start
                                 THEN
                                    l_message :=
                                       'ERROR: At least one channel must be specified for costing on programme '
                                       || v_gen_title
                                       || ' for licensee '
                                       || v_lee_short;
                                    was_check_error := 'Y';
                                 END IF;

                                 CLOSE cnt_cost_cha_runs;
                              END IF;

                              IF l_ald_amount = 0 AND l_ald_cost_runs > 0
                              THEN
                                 IF l_go_live_date > v_ald_start
                                 THEN
                                    raise_application_error (
                                       -20601,
                                       'ERROR: Allocation must be specified if costed runs present on programme '
                                       || v_gen_title
                                       || ' for licensee '
                                       || v_lee_short);
                                 END IF;

                                 OPEN cnt_cost_cha_runs;

                                 FETCH cnt_cost_cha_runs INTO v_cnt_cost;

                                 IF v_cnt_cost = 0
                                    AND l_go_live_date > v_ald_start
                                 THEN
                                    l_message :=
                                       'ERROR: At least one channel must be specified for costing on programme '
                                       || v_gen_title
                                       || ' for licensee '
                                       || v_lee_short;
                                    was_check_error := 'Y';
                                 END IF;

                                 CLOSE cnt_cost_cha_runs;
                              END IF;
                           END IF;
                        END IF;

                        CLOSE cnt_cha_runs;
                     END LOOP;

                     IF was_check_error = 'Y'
                     THEN
                        raise_application_error (-20601, l_message);
                     END IF;

                     CLOSE get_meis;
                  END IF;
               END IF;
            END;
         END;

         DECLARE
            CURSOR chk_cha_runss
            IS
               SELECT gen_title, ald_max_runs_cha, chr_number_runs
                 FROM sak_memo_item,
                      sak_allocation_detail,
                      sak_channel_runs,
                      fid_general
                WHERE     mei_mem_id = i_mem_id
                      AND mei_id = ald_mei_id
                      AND ald_id = chr_ald_id
                      AND ald_max_runs_cha < chr_number_runs
                      AND mei_gen_refno = gen_ser_number;

            v_gen_title   VARCHAR2 (120);
            v_max_cha     NUMBER;
            v_cha_runs    NUMBER;
         BEGIN
            IF l_seryorn = 'Y'
            THEN
               BEGIN
                  OPEN chk_cha_runss;

                  LOOP
                     FETCH chk_cha_runss
                     INTO v_gen_title, v_max_cha, v_cha_runs;

                     EXIT WHEN chk_cha_runss%NOTFOUND;
                     l_message :=
                           'Programme '
                        || v_gen_title
                        || ' has Channel Runs greater than specified maximum';
                     was_check_error := 'Y';
                     raise_application_error (-20601, l_message);
                  END LOOP;

                  CLOSE chk_cha_runss;
               END;
            END IF;
         END;
      END LOOP;
   END prc_check_cha_runs;

   /*   i_mem_id    IN       sak_memo_item.mei_mem_id%TYPE,
      o_message   OUT      VARCHAR2
   )
   AS
      CURSOR c_program
      IS
         SELECT mei_id, mei_type_show, mei_gen_refno
           FROM sak_memo_item
          WHERE mei_mem_id = i_mem_id;

      l_cnt_cha_runs            NUMBER;
      l_cnt_cha_cost            NUMBER;
      -- l_was_check_error   VARCHAR2 (1)   := 'N';
      l_message                 VARCHAR2 (250);
      l_seryorn                 VARCHAR2 (1);
      l_liveyorn                VARCHAR2 (1);
      l_cha_runs_chk            NUMBER;
      l_mem_mplex_ind           VARCHAR2 (1);
      l_mem_align_ind           VARCHAR2 (1);
      l_mem_type                VARCHAR2 (5);
      channel_runs_chk_failed   EXCEPTION;
   BEGIN
      FOR c_program_rec IN c_program
      LOOP
         SELECT NVL (cod_attr1, 'N'), NVL (cod_attr2, 'N')
           INTO l_seryorn, l_liveyorn
           FROM fid_code
          WHERE cod_type = 'GEN_TYPE'
            AND cod_value = c_program_rec.mei_type_show;

         IF l_seryorn = 'N'
         THEN
            SELECT mem_type, mem_mplex_ind, mem_align_ind
              INTO l_mem_type, l_mem_mplex_ind, l_mem_align_ind
              FROM sak_memo
             WHERE mem_id = i_mem_id;

            IF     NVL (l_mem_mplex_ind, 'Y') = 'N'
               AND NVL (l_mem_align_ind, 'N') = 'N'
            THEN
               FOR c_allocations_p IN (SELECT ald_id, lee_short_name,
                                              gen_title
                                         FROM sak_memo_item,
                                              sak_allocation_detail,
                                              fid_general,
                                              fid_licensee
                                        WHERE mei_mem_id = i_mem_id
                                          AND mei_id = ald_mei_id
                                          AND ald_lee_number = lee_number
                                          AND mei_gen_refno = gen_refno
                      -- Catchup Change on 27-OCT-2012 by Anirudha
                      AND nvl(lee_media_service_code,'#') <> 'CATCHUP'
                      -- End change

                                          AND mei_gen_refno = c_program_rec.mei_gen_refno
                                          )
               LOOP
                  SELECT COUNT (*)
                    INTO l_cnt_cha_runs
                    FROM sak_channel_runs
                   WHERE chr_ald_id = c_allocations_p.ald_id;

                  IF l_cnt_cha_runs = 0
                  THEN
                     l_message :=
                           'ERROR: At least one channel must be specified for channel runs on programme '
                        || c_allocations_p.gen_title
                        || ' for licensee '
                        || c_allocations_p.lee_short_name;
                     o_message := l_message;
                     -- EXIT;
                     RAISE channel_runs_chk_failed;
                  --l_was_check_error := 'Y';
                  ELSE
                     IF l_mem_type = 'ROY'
                     THEN
                        BEGIN
                           SELECT COUNT (*)
                             INTO l_cnt_cha_cost
                             FROM sak_channel_runs
                            WHERE chr_ald_id = c_allocations_p.ald_id
                              AND chr_cost_channel = 'Y';

                           IF l_cnt_cha_cost = 0
                           THEN
                              l_message :=
                                    'ERROR: At least one channel must be specified for costing on programme '
                                 || c_allocations_p.gen_title
                                 || ' for licensee '
                                 || c_allocations_p.lee_short_name;
                              --l_was_check_error := 'Y';
                              o_message := l_message;
                              --EXIT;
                              RAISE channel_runs_chk_failed;
                           END IF;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              NULL;
                        END;
                     END IF;
                  END IF;

                  SELECT COUNT (ald_id)
                    INTO l_cha_runs_chk          --, lee_short_name, gen_title
                    FROM                                      --sak_memo_item,
                         sak_allocation_detail,
                         --fid_general,
                         sak_channel_runs                     --, fid_licensee
                   WHERE ald_id = c_allocations_p.ald_id
                     --mei_mem_id = i_mem_id
                     AND ald_id = chr_ald_id
                     --AND ald_lee_number = lee_number
                     --AND mei_gen_refno =c_programs.mei_gen_refno
                     AND ald_max_runs_cha < chr_number_runs;

                  IF l_cha_runs_chk > 0
                  THEN
                     l_message :=
                        'Programme
                               has Channel Runs greater than specified maximum';
                     --l_was_check_error := 'Y';
                     o_message := l_message;
                     --EXIT;
                     RAISE channel_runs_chk_failed;
                  END IF;
               END LOOP;
            END IF;
         ELSE
            FOR c_allocations_s IN (SELECT ald_id, lee_short_name, gen_title
                                      FROM sak_memo_item,
                                           sak_allocation_detail,
                                           fid_general,
                                           fid_licensee
                                     WHERE mei_mem_id = i_mem_id
                                       AND mei_id = ald_mei_id
                                       AND ald_lee_number = lee_number
                                       AND mei_gen_refno = gen_ser_number
                                       -- Catchup Change on 27-OCT-2012 by Anirudha
                                       AND nvl(lee_media_service_code,'#') <> 'CATCHUP'
                                       -- End change
                                       AND mei_gen_refno = c_program_rec.mei_gen_refno
                                       )
            LOOP
               SELECT COUNT (*)
                 INTO l_cnt_cha_runs
                 FROM sak_channel_runs
                WHERE chr_ald_id = c_allocations_s.ald_id;

               IF l_cnt_cha_runs = 0
               THEN
                  l_message :=
                        'ERROR: At least one channel must be specified for channel runs on programme '
                     -- || c_allocations_s.gen_title
                     || ' for licensee '
                     || c_allocations_s.lee_short_name;
                  --l_was_check_error := 'Y';
                  o_message := l_message;
                  --EXIT;
                  RAISE channel_runs_chk_failed;
               ELSE
                  IF l_mem_type = 'ROY'
                  THEN
                     BEGIN
                        SELECT COUNT (*)
                          INTO l_cnt_cha_cost
                          FROM sak_channel_runs
                         WHERE chr_ald_id = c_allocations_s.ald_id
                           AND chr_cost_channel = 'Y';

                        IF l_cnt_cha_cost = 0
                        THEN
                           l_message :=
                                 'ERROR: At least one channel must be specified for costing on programme '
                              -- || c_allocations_s.gen_title
                              || ' for licensee '
                              || c_allocations_s.lee_short_name;
                           --l_was_check_error := 'Y';
                           o_message := l_message;
                           --EXIT;
                           RAISE channel_runs_chk_failed;
                        END IF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           NULL;
                     END;
                  END IF;
               END IF;

               SELECT COUNT (ald_id)
                 INTO l_cha_runs_chk             --, lee_short_name, gen_title
                 FROM                                         --sak_memo_item,
                      sak_allocation_detail,
                                            --fid_general,
                                            sak_channel_runs  --, fid_licensee
                WHERE ald_id = c_allocations_s.ald_id  --mei_mem_id = i_mem_id
                  AND ald_id = chr_ald_id
                  --AND ald_lee_number = lee_number
                  --AND mei_gen_refno =c_programs.mei_gen_refno
                  AND ald_max_runs_cha < chr_number_runs;

               IF l_cha_runs_chk > 0
               THEN
                  l_message :=
                     'Programme
                             has Channel Runs greater than specified maximum';
                  --l_was_check_error := 'Y';
                  o_message := l_message;
                  -- EXIT;
                  RAISE channel_runs_chk_failed;
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      l_message := 'Channel Runs Check Complete';
      o_message := l_message;
   --o_message := '';
   --DBMS_OUTPUT.put_line ('chk cha runs');
   EXCEPTION
      WHEN channel_runs_chk_failed
      THEN
         raise_application_error (-20601, l_message);*/
   -- END prc_check_cha_runs;


   /*   i_mem_id    IN       sak_memo_item.mei_mem_id%TYPE,
      o_message   OUT      VARCHAR2
   )
   AS
      CURSOR c_program
      IS
         SELECT mei_id, mei_type_show, mei_gen_refno
           FROM sak_memo_item
          WHERE mei_mem_id = i_mem_id;

      l_cnt_cha_runs            NUMBER;
      l_cnt_cha_cost            NUMBER;
      -- l_was_check_error   VARCHAR2 (1)   := 'N';
      l_message                 VARCHAR2 (250);
      l_seryorn                 VARCHAR2 (1);
      l_liveyorn                VARCHAR2 (1);
      l_cha_runs_chk            NUMBER;
      l_mem_mplex_ind           VARCHAR2 (1);
      l_mem_align_ind           VARCHAR2 (1);
      l_mem_type                VARCHAR2 (5);
      channel_runs_chk_failed   EXCEPTION;
   BEGIN
      FOR c_program_rec IN c_program
      LOOP
         SELECT NVL (cod_attr1, 'N'), NVL (cod_attr2, 'N')
           INTO l_seryorn, l_liveyorn
           FROM fid_code
          WHERE cod_type = 'GEN_TYPE'
            AND cod_value = c_program_rec.mei_type_show;

         IF l_seryorn = 'N'
         THEN
            SELECT mem_type, mem_mplex_ind, mem_align_ind
              INTO l_mem_type, l_mem_mplex_ind, l_mem_align_ind
              FROM sak_memo
             WHERE mem_id = i_mem_id;

            IF     NVL (l_mem_mplex_ind, 'Y') = 'N'
               AND NVL (l_mem_align_ind, 'N') = 'N'
            THEN
               FOR c_allocations_p IN (SELECT ald_id, lee_short_name,
                                              gen_title
                                         FROM sak_memo_item,
                                              sak_allocation_detail,
                                              fid_general,
                                              fid_licensee
                                        WHERE mei_mem_id = i_mem_id
                                          AND mei_id = ald_mei_id
                                          AND ald_lee_number = lee_number
                                          AND mei_gen_refno = gen_refno
                      -- Catchup Change on 27-OCT-2012 by Anirudha
                      AND nvl(lee_media_service_code,'#') <> 'CATCHUP'
                      -- End change

                                          AND mei_gen_refno = c_program_rec.mei_gen_refno
                                          )
               LOOP
                  SELECT COUNT (*)
                    INTO l_cnt_cha_runs
                    FROM sak_channel_runs
                   WHERE chr_ald_id = c_allocations_p.ald_id;

                  IF l_cnt_cha_runs = 0
                  THEN
                     l_message :=
                           'ERROR: At least one channel must be specified for channel runs on programme '
                        || c_allocations_p.gen_title
                        || ' for licensee '
                        || c_allocations_p.lee_short_name;
                     o_message := l_message;
                     -- EXIT;
                     RAISE channel_runs_chk_failed;
                  --l_was_check_error := 'Y';
                  ELSE
                     IF l_mem_type = 'ROY'
                     THEN
                        BEGIN
                           SELECT COUNT (*)
                             INTO l_cnt_cha_cost
                             FROM sak_channel_runs
                            WHERE chr_ald_id = c_allocations_p.ald_id
                              AND chr_cost_channel = 'Y';

                           IF l_cnt_cha_cost = 0
                           THEN
                              l_message :=
                                    'ERROR: At least one channel must be specified for costing on programme '
                                 || c_allocations_p.gen_title
                                 || ' for licensee '
                                 || c_allocations_p.lee_short_name;
                              --l_was_check_error := 'Y';
                              o_message := l_message;
                              --EXIT;
                              RAISE channel_runs_chk_failed;
                           END IF;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              NULL;
                        END;
                     END IF;
                  END IF;

                  SELECT COUNT (ald_id)
                    INTO l_cha_runs_chk          --, lee_short_name, gen_title
                    FROM                                      --sak_memo_item,
                         sak_allocation_detail,
                         --fid_general,
                         sak_channel_runs                     --, fid_licensee
                   WHERE ald_id = c_allocations_p.ald_id
                     --mei_mem_id = i_mem_id
                     AND ald_id = chr_ald_id
                     --AND ald_lee_number = lee_number
                     --AND mei_gen_refno =c_programs.mei_gen_refno
                     AND ald_max_runs_cha < chr_number_runs;

                  IF l_cha_runs_chk > 0
                  THEN
                     l_message :=
                        'Programme
                               has Channel Runs greater than specified maximum';
                     --l_was_check_error := 'Y';
                     o_message := l_message;
                     --EXIT;
                     RAISE channel_runs_chk_failed;
                  END IF;
               END LOOP;
            END IF;
         ELSE
            FOR c_allocations_s IN (SELECT ald_id, lee_short_name, gen_title
                                      FROM sak_memo_item,
                                           sak_allocation_detail,
                                           fid_general,
                                           fid_licensee
                                     WHERE mei_mem_id = i_mem_id
                                       AND mei_id = ald_mei_id
                                       AND ald_lee_number = lee_number
                                       AND mei_gen_refno = gen_ser_number
                                       -- Catchup Change on 27-OCT-2012 by Anirudha
                                       AND nvl(lee_media_service_code,'#') <> 'CATCHUP'
                                       -- End change
                                       AND mei_gen_refno = c_program_rec.mei_gen_refno
                                       )
            LOOP
               SELECT COUNT (*)
                 INTO l_cnt_cha_runs
                 FROM sak_channel_runs
                WHERE chr_ald_id = c_allocations_s.ald_id;

               IF l_cnt_cha_runs = 0
               THEN
                  l_message :=
                        'ERROR: At least one channel must be specified for channel runs on programme '
                     -- || c_allocations_s.gen_title
                     || ' for licensee '
                     || c_allocations_s.lee_short_name;
                  --l_was_check_error := 'Y';
                  o_message := l_message;
                  --EXIT;
                  RAISE channel_runs_chk_failed;
               ELSE
                  IF l_mem_type = 'ROY'
                  THEN
                     BEGIN
                        SELECT COUNT (*)
                          INTO l_cnt_cha_cost
                          FROM sak_channel_runs
                         WHERE chr_ald_id = c_allocations_s.ald_id
                           AND chr_cost_channel = 'Y';

                        IF l_cnt_cha_cost = 0
                        THEN
                           l_message :=
                                 'ERROR: At least one channel must be specified for costing on programme '
                              -- || c_allocations_s.gen_title
                              || ' for licensee '
                              || c_allocations_s.lee_short_name;
                           --l_was_check_error := 'Y';
                           o_message := l_message;
                           --EXIT;
                           RAISE channel_runs_chk_failed;
                        END IF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           NULL;
                     END;
                  END IF;
               END IF;

               SELECT COUNT (ald_id)
                 INTO l_cha_runs_chk             --, lee_short_name, gen_title
                 FROM                                         --sak_memo_item,
                      sak_allocation_detail,
                                            --fid_general,
                                            sak_channel_runs  --, fid_licensee
                WHERE ald_id = c_allocations_s.ald_id  --mei_mem_id = i_mem_id
                  AND ald_id = chr_ald_id
                  --AND ald_lee_number = lee_number
                  --AND mei_gen_refno =c_programs.mei_gen_refno
                  AND ald_max_runs_cha < chr_number_runs;

               IF l_cha_runs_chk > 0
               THEN
                  l_message :=
                     'Programme
                             has Channel Runs greater than specified maximum';
                  --l_was_check_error := 'Y';
                  o_message := l_message;
                  -- EXIT;
                  RAISE channel_runs_chk_failed;
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      l_message := 'Channel Runs Check Complete';
      o_message := l_message;
   --o_message := '';
   --DBMS_OUTPUT.put_line ('chk cha runs');
   EXCEPTION
      WHEN channel_runs_chk_failed
      THEN
         raise_application_error (-20601, l_message);*/
   -- END prc_check_cha_runs;

   ------------------------------------- PROCEDURE FOR ALERTS IN DEAL MEMO -----------------------------------------------------------------
   PROCEDURE prc_alert (i_alert_name      IN     VARCHAR2,
                        i_button_value    IN     VARCHAR2,
                        o_alert_message      OUT VARCHAR2 -- o_error_message   OUT      VARCHAR2
                                                         )
   AS
   BEGIN
      IF i_alert_name = 'ONLYSERIES'
      THEN
         o_alert_message :=
            'This Is A Series. No Season Has Been Added. Do You Want To Add A Season Now?';
      ELSIF i_alert_name = 'NODURATION'
      THEN
         o_alert_message :=
            'You have Not Specified a Duration. Do You Want To Continue Anyway?';
      ELSIF i_alert_name = 'NOSERIES'
      THEN
         o_alert_message :=
            'You have Said Yes To Creating A Series But Have Not Added A Season. Either Delete The Series Or Add A Season Title Before Saving ';
      ELSIF i_alert_name = 'NOGENRE'
      THEN
         o_alert_message :=
            'You Have Not Specified A Genre/Sporting Type. Do You Want To Continue Anyway?';
      ELSIF i_alert_name = 'NOEVENT'
      THEN
         o_alert_message :=
            'You Have Not Specified A Event. Do You Want To Continue Anyway?';
      ELSIF i_alert_name = 'NOSUBGENRE'
      THEN
         o_alert_message :=
            'You Have Not Specified A Sub Genre. Do You Want To Continue Anyway?';
      ELSIF i_alert_name = 'COSTOVER'
      THEN
         o_alert_message :=
            'Your Programme Costs Have Exceeded The Contract Cost. Do You Still Want To Save The Form?';
      ELSIF i_alert_name = 'NOSELECTION'
      THEN
         o_alert_message :=
            'You Have Not Specified The Episode Title Selection - Please Do So Before Generating';
      ELSIF i_alert_name = 'HOURSOVER'
      THEN
         o_alert_message :=
            'You Have Exceeded the Number of Hours Allocated to This Contract. Do You Still Want To Save The Deal?';
      ELSIF i_alert_name = 'NOCREATE'
      THEN
         o_alert_message := 'Do You Want To Save The New Series?';
      ELSIF i_alert_name = 'PARENT'
      THEN
         o_alert_message :=
            'You Cannot Add Episodes to A series. Please Select A Season Title ';
      ELSIF i_alert_name = 'SECONDSEASON'
      THEN
         o_alert_message := 'You Have Already Added A Season Title  ';
      ELSIF i_alert_name = 'EPINUMBER'
      THEN
         o_alert_message :=
            'Episode Numbers Already Exist. Check The Last Episode Number For This Season';
      ELSIF i_alert_name = 'SER_TITLE'
      THEN
         o_alert_message :=
            'There are no programmes that match this hint.
Would you like the system to create a programme
of this title right now,using a set of default values?
(Can be edited later using Programme Maintenance)';
      ELSIF i_alert_name = 'SEASONEXIST'
      THEN
         o_alert_message := 'A Season Title Already Exists with this Title';
      ELSIF i_alert_name = 'GEN_TITLE'
      THEN
         o_alert_message :=
            'There are no programmes that match this hint.
Would you like the system to create a programme
of this title right now,using a set of default values?
(Can be edited later using Programme Maintenance)';
      ELSIF i_alert_name = 'EXEC_DEAL'
      THEN
         o_alert_message := 'Some periods are TBA.
Do you still wish to execute?';
      ELSIF i_alert_name = 'CHK_ALLOC'
      THEN
         o_alert_message := 'The allocations are incorrect.
Do you want to correct them now?';
      ELSIF i_alert_name = 'PAY_DIFF'
      THEN
         o_alert_message :=
            'The Fee Payments do not add up to the Flat-Fee Costs on page 1.
Do you want to correct them?';
      ELSIF i_alert_name = 'PCT_DIFF'
      THEN
         o_alert_message := 'The Payment percentages do not add up to 100%.
Do you want to correct them?';
      ELSIF i_alert_name = 'SAVE'
      THEN
         o_alert_message := 'Are You Sure You Want To Save Your Changes?';
      ELSIF i_alert_name = 'NOTSEASON'
      THEN
         o_alert_message :=
            'You are changing a Series Title not A Season Title - Please Select the Correct Node';
      END IF;
   END prc_alert;

   ------------------------------------- PROCEDURE FOR EXECUTING DEAL MEMO ----------------------------------------------------------------
   PROCEDURE prc_execute_deal_memo (
      i_mem_id           IN     sak_memo.mem_id%TYPE,
      i_user_id          IN     VARCHAR2,
      i_val              IN     VARCHAR2,
      i_is_t_exe         IN     VARCHAR2,
      o_con_short_name      OUT fid_contract.con_short_name%TYPE,
      o_mem_status          OUT sak_memo.mem_status%TYPE,
      o_message             OUT VARCHAR2)
   AS
      theconnumber                NUMBER;
      al_button                   NUMBER;
      secondconnumber             NUMBER;
      serdone                     NUMBER := 0;
      feadone                     NUMBER := 0;
      l_mem_status                VARCHAR2 (25);
      l_mem_lee_number            NUMBER;
      l_mei_id                    NUMBER;
      l_mei_type_show             VARCHAR2 (4);
      l_mem_type                  VARCHAR2 (4);
      l_mem_con_number            NUMBER;
      o_mem_con_number            NUMBER;
      l_message                   VARCHAR2 (250);
      l_con_short_name            VARCHAR2 (4);
      l_cnt_tba                   NUMBER;
      l_cnt_relic                 NUMBER;
      l_mem_con_price             sak_memo.mem_con_price%TYPE;
      l_mem_con_hours             sak_memo.mem_con_hours%TYPE;
      l_mem_con_cost_per_hour     sak_memo.mem_con_cost_per_hour%TYPE;
      l_mem_con_hours_remaining   sak_memo.mem_con_hours_remaining%TYPE;
      no_deal_execution           EXCEPTION;
      allocations_dont_addup      EXCEPTION;
      l_mei_gen_refno             NUMBER;
      l_mem_con_proc_type         VARCHAR2 (100);
      payments_dont_addup         EXCEPTION;
      PRAGMA EXCEPTION_INIT (allocations_dont_addup, -20115);
      PRAGMA EXCEPTION_INIT (payments_dont_addup, -20116);
      l_count                     NUMBER;
      L_NCF_USER_ROLE_CNT         NUMBER;
      --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
      L_CON_STATUS                VARCHAR2 (1);
      L_A_LIC_CNT                 NUMBER;
      l_t_exec_rights             NUMBER;
      L_LSR_ID                    NUMBER;
      L_CSR_ID                    NUMBER;
      l_str                       varchar2(1000); -- CU4ALL : Shubhada Bongarde [22 Jan 2015]
      l_str1                      varchar2(1000); -- CU4ALL : Shubhada Bongarde [22 Jan 2015]
      l_con_number                NUMBER;         -- CU4ALL : Shubhada Bongarde [22 Jan 2015]
      l_uncheck_bouquet1          varchar2(1000);  -- CU4ALL : milan shah [23 Jan 2015]
      l_uncheck_bouquet           varchar2(1000);  -- CU4ALL : milan shah [23 Jan 2015]
      L_CBM_ID                    NUMBER;         -- CU4ALL : milan shah [23 Jan 2015]
      L_MAX_RANK                  NUMBER;         -- CU4ALL : milan shah [23 Jan 2015]
      --RDT End : Acquision Requirements BR_15_104
      ------Dev:Pure Finance:Start:_[Hari Mandal]_[25/03/2013]--------------------------------------------------

      ------comment below variables as split payment done in create_roy_pay procedure--------------------------
      -- l_lsp_id number;
      --  L_START date ;
      --  L_END date;
      --   O_DUE_DATE date;
      --- O_DUE_DATE DATE ;
      -----------Dev:Pure Finance:End--------------------------------------------------------------------------
      CURSOR item1
      IS
         SELECT mei_id, mei_type_show, NVL (cod_attr1, 'N') seryorn
           FROM sak_memo_item, fid_code
          WHERE     cod_type = 'GEN_TYPE'
                AND cod_value = mei_type_show
                AND mei_mem_id = i_mem_id;

      l_superuser                 VARCHAR2 (1) := ' ';
   BEGIN
      SELECT mem_status,
             mem_type,
             mem_lee_number,
             mem_con_number,
             mem_con_price,
             mem_con_hours,
             mem_con_cost_per_hour,
             mem_con_hours_remaining
        INTO l_mem_status,
             l_mem_type,
             l_mem_lee_number,
             l_mem_con_number,
             l_mem_con_price,
             l_mem_con_hours,
             l_mem_con_cost_per_hour,
             l_mem_con_hours_remaining
        FROM sak_memo
       WHERE mem_id = i_mem_id;

      /*      IF i_is_t_exe ='Y'
           THEN
               --Changes done by Pranay for Mel's Issue raised during RDT ACQ CRs UAT
                    sELECT COUNT (*)
                     INTO l_t_exec_rights
                     FROM sak_memo_user
                    WHERE UPPER (MEU_USR_ID) = i_user_id AND meu_texecute = 'Y'
                      AND meu_lee_number = l_mem_lee_number;

                    if l_t_exec_rights=0
                    then
                       l_message := 'You are not permitted to Texecute deal memos.';
                       raise_application_error (-20013, l_message);
                    end if;
                   --Changes by Pranay End
           END IF;*/

      --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]

      IF L_MEM_CON_NUMBER IS NOT NULL
      THEN
         SELECT CON_STATUS
           INTO L_CON_STATUS
           FROM FID_CONTRACT
          WHERE CON_NUMBER = L_MEM_CON_NUMBER;

         IF L_CON_STATUS = 'T'
         THEN
            IF I_IS_T_EXE = 'Y'
            THEN
               SELECT COUNT (1)
                 INTO L_A_LIC_CNT
                 FROM FID_CONTRACT, FID_LICENSE
                WHERE     LIC_CON_NUMBER = CON_NUMBER
                      AND CON_NUMBER = L_MEM_CON_NUMBER
                      AND lic_mem_number <> i_mem_id
                      AND LIC_STATUS = 'A';

               IF L_A_LIC_CNT > 0
               THEN
                  RAISE_APPLICATION_ERROR (
                     -20688,
                     'Cannot Texecute the deal, as Active licenses are available');
               END IF;
            ELSIF NVL (I_IS_T_EXE, 'N') = 'N'
            THEN
               SELECT COUNT (1)
                 INTO L_A_LIC_CNT
                 FROM FID_CONTRACT, FID_LICENSE
                WHERE     LIC_CON_NUMBER = CON_NUMBER
                      AND CON_NUMBER = L_MEM_CON_NUMBER
                      AND lic_mem_number <> i_mem_id
                      AND LIC_STATUS = 'T';

               IF L_A_LIC_CNT > 0
               THEN
                  RAISE_APPLICATION_ERROR (
                     -20688,
                     'Cannot Execute the deal, as Tlicenses are available');
               END IF;
            END IF;
         ELSIF L_CON_STATUS = 'A'
         THEN
            IF I_IS_T_EXE = 'Y'
            THEN
               SELECT COUNT (1)
                 INTO L_A_LIC_CNT
                 FROM FID_CONTRACT, FID_LICENSE
                WHERE     LIC_CON_NUMBER = CON_NUMBER
                      AND CON_NUMBER = L_MEM_CON_NUMBER
                      AND lic_mem_number <> i_mem_id
                      AND LIC_STATUS = 'A';

               IF L_A_LIC_CNT > 0
               THEN
                  RAISE_APPLICATION_ERROR (
                     -20688,
                     'Cannot Texecute the deal, as Active licenses are available');
               END IF;
            ELSIF NVL (I_IS_T_EXE, 'N') = 'N'
            THEN
               SELECT COUNT (1)
                 INTO L_A_LIC_CNT
                 FROM FID_CONTRACT, FID_LICENSE
                WHERE     LIC_CON_NUMBER = CON_NUMBER
                      AND CON_NUMBER = L_MEM_CON_NUMBER
                      AND lic_mem_number <> i_mem_id
                      AND LIC_STATUS = 'T';

               IF L_A_LIC_CNT > 0
               THEN
                  RAISE_APPLICATION_ERROR (
                     -20688,
                     'Cannot Execute the deal, as Tlicenses are available');
               END IF;
            END IF;
         END IF;
      END IF;

      --RDT End : Acquision Requirements BR_15_104

      ---Pure Finance:Start:[Hari Mandal]_[9/5/2013]
      ---Added for checking channel allocation for ncf deal

      IF i_is_t_exe = 'Y'
      THEN
         pkg_adm_cm_dealmemo.prc_check_catchup_validation (i_mem_id);
      END IF;

      IF l_mem_status IN ('NCF')
      THEN
         FOR i IN (SELECT mei_id
                     FROM sak_memo_item
                    WHERE mei_mem_id = i_mem_id)
         LOOP
            FOR j IN (SELECT ald_id
                        FROM sak_allocation_detail
                       WHERE ald_mei_id = i.mei_id AND ald_chs_number > 0)
            LOOP
               SELECT COUNT (1)
                 INTO l_count
                 FROM sak_channel_runs
                WHERE chr_ald_id = j.ald_id;

               IF l_count = 0
               THEN
                  raise_application_error (
                     -20567,
                     'For NCF Deal Runs Per Channel are required');
               END IF;
            END LOOP;
         END LOOP;

         SELECT COUNT (*)
           INTO L_NCF_USER_ROLE_CNT
           FROM Ora_Aspnet_Users A,
                Ora_Aspnet_Roles B,
                Ora_Aspnet_Usersinroles C,
                men_user e
          WHERE     A.Userid = C.Userid
                AND C.Roleid = B.Roleid
                AND UPPER (E.Usr_Ad_Loginid) = UPPER (A.Username)
                AND Rolename IN ('EXECUTE NCF DEAL', 'Admin')
                AND UPPER (Usr_Id) LIKE UPPER (i_user_id);

         IF L_NCF_USER_ROLE_CNT = 0
         THEN
            l_message := 'You are not permitted to execute NCF deal memos.';
            raise_application_error (-20013, l_message);
         END IF;
      END IF;

      /* SELECT mei_id, mei_type_show
         INTO l_mei_id, l_mei_type_show
         FROM sak_memo_item
        WHERE mei_mem_id = i_mem_id;*/
      SELECT COUNT (*)
        INTO l_cnt_relic
        FROM fid_general
       WHERE gen_ser_number IN (SELECT mei_gen_refno
                                  FROM sak_memo_item
                                 WHERE mei_mem_id = i_mem_id)
             AND gen_relic = 'Y';

      IF     l_mem_status IN ('BUDGETED', 'BEXECUTED')
         AND l_cnt_relic > 0
         AND NVL (i_is_t_exe, 'N') <> 'Y'
      THEN
         l_message := 'Error: Cannot Relicense When In Budgeted Mode';
         raise_application_error (-20013, l_message);
      END IF;

      BEGIN
         --Prod.Support: Start: Superuser right should not be checked for Texecute
         IF NVL (i_is_t_exe, 'N') <> 'Y'
         THEN /*    Added condition  to skip superuser check for TExecute deals  */
            IF l_mem_status <> 'BUDGETED'
            /*    Added condition for executing BUDGETED deal with BUYER Rights  */
            THEN
               SELECT meu_superuser
                 INTO l_superuser
                 FROM sak_memo_user
                WHERE     UPPER (meu_usr_id) = UPPER (i_user_id)
                      AND meu_superuser = 'Y'
                      AND meu_lee_number = l_mem_lee_number;
            ELSE
               SELECT meu_buyer
                 INTO l_superuser
                 FROM sak_memo_user
                WHERE     UPPER (meu_usr_id) = UPPER (i_user_id)
                      AND meu_buyer = 'Y'
                      AND meu_lee_number = l_mem_lee_number;
            END IF;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_message := 'ERROR: You are not permitted to execute deal memos.';
            raise_application_error (-20013, l_message);
      END;

      --Prod.Support: End



      IF i_mem_id IS NULL
      THEN
         l_message := 'Please select a deal memo first';
      ELSE
         BEGIN
            BEGIN
               SELECT COUNT (*)
                 INTO l_cnt_tba
                 FROM sak_allocation_detail, sak_memo_item
                WHERE     mei_mem_id = i_mem_id
                      AND ald_mei_id = mei_id
                      AND ald_period_tba = 'Y';
            EXCEPTION
               WHEN OTHERS
               THEN
                  raise_application_error (-20013, SUBSTR (SQLERRM, 1, 200));
            END;

            IF l_cnt_tba != 0
            THEN
               --pkg_adm_cm_dealmemo.prc_alert ('EXEC_DEAL', i_val, o_message);
               IF i_val = 'N'
               THEN
                  --al_button := Show_Alert('EXEC_DEAL');
                  --if al_button = ALERT_BUTTON2 THEN
                  l_message :=
                     'Some periods are TBA. Deal Memo is not executed';
                  RAISE no_deal_execution;
               ELSE
                  NULL;
               END IF;
            --end if;
            END IF;

            -- taken care of by system_rule for type.   check_not_executed;
            IF l_mem_con_number IS NOT NULL
            THEN
               IF l_mem_type NOT IN ('CPD', 'CHC')
               THEN
                  UPDATE fid_contract
                     SET con_price = l_mem_con_price,
                         con_entry_oper = i_user_id
                   WHERE con_number = l_mem_con_number;
               ELSIF l_mem_type = 'CPD'
               THEN
                  UPDATE fid_contract
                     SET con_price = l_mem_con_price,
                         con_entry_oper = i_user_id
                   WHERE con_number = l_mem_con_number;
               ELSIF l_mem_type = 'CHC'
               THEN
                  UPDATE fid_contract
                     SET con_price = l_mem_con_price,
                         con_hours = l_mem_con_hours,
                         con_cost_per_hour = l_mem_con_cost_per_hour,
                         con_hours_remaining = l_mem_con_hours_remaining,
                         con_entry_oper = i_user_id
                   WHERE con_number = l_mem_con_number;
               END IF;
            END IF;

            --l_message:= 'Executing Deal...';
            FOR items IN item1
            LOOP
               -- DBMS_OUTPUT.put_line ('in loop');
               IF items.seryorn = 'Y' AND serdone <= 0
               THEN
                  theconnumber :=
                     pkg_adm_fid_mem_pk_ser2.execute_dms (i_mem_id,
                                                          i_user_id,
                                                          secondconnumber,
                                                          i_is_t_exe);

                  UPDATE fid_general
                     SET gen_supplier_com_number =
                            (SELECT mem_com_number
                               FROM sak_memo
                              WHERE mem_id = i_mem_id)
                   WHERE gen_ser_number IN (SELECT mei_gen_refno
                                              FROM sak_memo_item
                                             WHERE mei_mem_id = i_mem_id);

                  /* RDT :Content Ordering :Neeraj 30_JAN_15 : Updating deal memo number in Dummy Title table  */
                  UPDATE X_GEN_ORDER_TITLE
                     SET GOT_MEM_NUMBER = i_mem_id
                   WHERE got_gen_refno IN
                            (SELECT gen_Refno
                               FROM fid_general
                              WHERE gen_ser_number IN
                                       (SELECT mei_gen_refno
                                          FROM sak_memo_item
                                         WHERE mei_mem_id = i_mem_id))
                         AND GOT_MEM_NUMBER = 0;

                  /* RDT :Content Ordering :Neeraj 30_JAN_15 : Updating deal memo number in Dummy Title table   */

                  ---changes end
                  IF i_is_t_exe = 'Y'
                  THEN
                     UPDATE sak_memo
                        SET mem_is_t_exec = 'Y'
                      WHERE mem_id = i_mem_id;
                  END IF;

                  serdone := 1;
               END IF;

               secondconnumber := theconnumber;

               IF items.seryorn != 'Y' AND feadone <= 0
               THEN
                  theconnumber :=
                     pkg_adm_fid_mem_pk2.execute_dmt (i_mem_id,
                                                      i_user_id,
                                                      secondconnumber,
                                                      i_is_t_exe);

                  UPDATE fid_general
                     SET gen_supplier_com_number =
                            (SELECT mem_com_number
                               FROM sak_memo
                              WHERE mem_id = i_mem_id)
                   WHERE gen_refno IN (SELECT mei_gen_refno
                                         FROM sak_memo_item
                                        WHERE mei_mem_id = i_mem_id);

                  /* RDT :Content Ordering :Neeraj 30_JAN_15 : Updating deal memo number in Dummy Title table  */
                  UPDATE X_GEN_ORDER_TITLE
                     SET GOT_MEM_NUMBER = i_mem_id
                   WHERE got_gen_refno IN (SELECT mei_gen_refno
                                             FROM sak_memo_item
                                            WHERE mei_mem_id = i_mem_id)
                         AND GOT_MEM_NUMBER = 0;

                  /* RDT :Content Ordering :Neeraj 30_JAN_15 : Updating deal memo number in Dummy Title table  */

                  IF i_is_t_exe = 'Y'
                  THEN
                     UPDATE sak_memo
                        SET mem_is_t_exec = 'Y'
                      WHERE mem_id = i_mem_id;
                  END IF;

                  feadone := 1;
               END IF;

               secondconnumber := theconnumber;
            END LOOP;

            -----------------Deal price rounding by Hari Mandal-----------
            IF l_mem_type <> 'ROY'
            THEN
               pkg_adm_cm_dealmemo.x_fin_deal_price_rounding (i_mem_id);
            END IF;

            --------------------------------------------------------------

            -- DBMS_OUTPUT.put_line (theconnumber);
            IF l_mem_con_number IS NULL
            THEN
               UPDATE sak_memo
                  SET mem_con_number = theconnumber
                WHERE mem_id = i_mem_id;

               -- DBMS_OUTPUT.put_line ('******');
               BEGIN
                  SELECT theconnumber, con_short_name
                    INTO o_mem_con_number, o_con_short_name
                    FROM fid_contract
                   WHERE con_number = secondconnumber;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20601,
                                              SUBSTR (SQLERRM, 1, 200));
               END;
            END IF;

            IF i_is_t_exe = 'Y'
            THEN
               pkg_adm_cm_dealmemo.prc_create_history ('TEXECUTE',
                                                       i_mem_id,
                                                       l_mem_type,
                                                       i_user_id,
                                                       o_mem_status);
            ELSE
               pkg_adm_cm_dealmemo.prc_create_history ('EXECUTE',
                                                       i_mem_id,
                                                       l_mem_type,
                                                       i_user_id,
                                                       o_mem_status);
            END IF;

            UPDATE sak_memo
               SET mem_status = o_mem_status, mem_status_date = SYSDATE --'EXECUTED'
             WHERE mem_id = i_mem_id;

            COMMIT;


        --Dev.R1: CatchUp for All :[10. BR_15_272_UC_Super Stacking]_[Milan Shah]_[2016/01/04]: Start
        IF l_mem_con_number IS NULL
        THEN


            --commit;
            -- flow of superstack rights/default right(PREMIUM) from Deal to fid_contract

                SELECT listagg(CB_NAME, ',') within group (order by CB_NAME) INTO l_str1
                FROM (select DISTINCT CB_NAME
                              FROM SAK_MEMO,
                                   SAK_MEMO_ITEM,
                                   SAK_ALLOCATION_DETAIL,
                                   X_CP_MEMO_SUPERSTACK_RIGHTS,
                                   x_cp_bouquet
                             WHERE MEM_ID=MEI_MEM_ID
                               AND MEI_ID=ALD_MEI_ID
                               AND msr_ald_number = ald_id
                               AND MSR_SUPERSTACK_FLAG = 'Y'
                               AND MEM_ID=i_mem_id
                               AND MSR_BOUQUET_ID = CB_ID
                      );

                select (listagg(CB_NAME, ',') within group (order by CB_NAME)) INTO l_uncheck_bouquet1
                FROM x_cp_bouquet
                WHERE CB_NAME NOT IN(SELECT t1.COL1 COL FROM((SELECT rownum r2,COLUMN_VALUE  col1 FROM TABLE(X_CP_SUPERSTACK_RIGHTS.split_to_char(l_str1,','))) t1))
                AND CB_BOUQ_PARENT_ID IS NULL
                AND CB_AD_FLAG = 'A'
                AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP
                              WHERE CMM_BOUQ_MS_CODE IN(select LEE_MEDIA_SERVICE_CODE from fid_licensee
                                                               WHERE lee_number in(select ALD_LEE_NUMBER from SAK_ALLOCATION_DETAIL
                                                                                         WHERE ALD_MEI_ID IN((SELECT MEI_ID FROM sak_memo_item
                                                                                               WHERE MEI_MEM_ID = i_mem_id))))AND CMM_BOUQ_MS_RIGHTS ='Y');

            /*FOR I IN
            (
              SELECT distinct MEM_CON_NUMBER,  MSR_BOUQUET_ID,MSR_SUPERSTACK_FLAG
                FROM SAK_MEMO, SAK_MEMO_ITEM, SAK_ALLOCATION_DETAIL, X_CP_MEMO_SUPERSTACK_RIGHTS
               WHERE MEM_ID=MEI_MEM_ID
                 AND MEI_ID=ALD_MEI_ID
                 AND msr_ald_number = ald_id
                 AND MSR_SUPERSTACK_FLAG = 'Y'
                 AND MEM_ID=i_mem_id
            )
            LOOP
                  --dbms_output.put_line (I.MSR_BOUQUET_ID);
                      SELECT cb_name
                        INTO  l_str
                      FROM x_cp_bouquet
                      WHERE CB_ID = I.MSR_BOUQUET_ID
                        AND CB_BOUQ_PARENT_ID IS NULL
                        AND CB_AD_FLAG = 'A';
                  l_str1 := l_str1||','||l_str;
                  --dbms_output.put_line ('l_str : '||ltrim(l_str1,','));
            END LOOP;*/


            SELECT MEM_CON_NUMBER
              INTO l_con_number
              FROM SAK_MEMO
             WHERE MEM_ID = i_mem_id;

            IF l_str1 IS NOT NULL
            THEN
              --l_str1 := ltrim(l_str1,',');
--              UPDATE FID_CONTRACT
--                 SET CON_BOUQUET_RIGHTS = l_str1
--               WHERE CON_NUMBER = l_con_number;

              FOR BOUQUET IN
              (
                SELECT t1.COL1 COL FROM(
                (SELECT rownum r2,COLUMN_VALUE  col1 FROM TABLE(X_CP_SUPERSTACK_RIGHTS.split_to_char(l_str1,','))) t1)
              )
              LOOP
                  IF BOUQUET.COL IS NOT NULL
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
                      ,CBM_MODIFIED_BY
                      ,CBM_MODIFIED_DATE
                  )
                  VALUES
                  (
                    L_CBM_ID
                    ,l_con_number
                    ,(SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_NAME = BOUQUET.COL AND CB_AD_FLAG='A' AND CB_BOUQ_PARENT_ID IS NULL)
                    ,'Y'
                    ,i_user_id
                    ,SYSDATE
                    ,null
                    ,null
                  );
                  END IF;
               END LOOP;

              --l_uncheck_bouquet1 := ltrim(l_uncheck_bouquet1,',');
              FOR BOUQUET IN
              (
                SELECT t1.COL1 COL FROM(
                (SELECT rownum r2,COLUMN_VALUE  col1 FROM TABLE(X_CP_SUPERSTACK_RIGHTS.split_to_char(l_uncheck_bouquet1,','))) t1)
              )
              LOOP
                  IF BOUQUET.COL IS NOT NULL
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
                      ,CBM_MODIFIED_BY
                      ,CBM_MODIFIED_DATE
                  )
                  VALUES
                  (
                    L_CBM_ID
                    ,l_con_number
                    ,(SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_NAME = BOUQUET.COL AND CB_AD_FLAG='A' AND CB_BOUQ_PARENT_ID IS NULL)
                    ,'N'
                    ,i_user_id
                    ,SYSDATE
                    ,null
                    ,null
                  );
                  END IF;
               END LOOP;
            ELSE

              FOR I IN
              (
                  SELECT CB_NAME,CB_ID,CB_RANK
                  FROM X_CP_BOUQUET
                  WHERE CB_BOUQ_PARENT_ID IS NULL
                  AND CB_AD_FLAG = 'A'
                  AND CB_RANk =1
              )
              LOOP
                    IF I.CB_RANK = 1
                    then
--                    UPDATE FID_CONTRACT
--                       SET CON_BOUQUET_RIGHTS = I.CB_NAME
--                     WHERE CON_NUMBER = l_con_number;

                     SELECT X_SEQ_CON_BOUQUET_MAPP.nextval INTO L_CBM_ID FROM Dual;
                        INSERT INTO X_CON_BOUQUE_MAPP
                        (
                            CBM_ID
                            ,CBM_CON_NUMBER
                            ,CBM_BOUQUE_ID
                            ,CBM_CON_BOUQ_RIGHTS
                            ,CBM_ENTRY_OPER
                            ,CBM_ENTRY_DATE
                            ,CBM_MODIFIED_BY
                            ,CBM_MODIFIED_DATE
                        )
                        VALUES
                        (
                          L_CBM_ID
                          ,l_con_number
                          ,I.CB_ID
                          ,'Y'
                          ,i_user_id
                          ,SYSDATE
                          ,null
                          ,null
                        );
                      ELSE
                     SELECT X_SEQ_CON_BOUQUET_MAPP.nextval INTO L_CBM_ID FROM Dual;
                        INSERT INTO X_CON_BOUQUE_MAPP
                        (
                            CBM_ID
                            ,CBM_CON_NUMBER
                            ,CBM_BOUQUE_ID
                            ,CBM_CON_BOUQ_RIGHTS
                            ,CBM_ENTRY_OPER
                            ,CBM_ENTRY_DATE
                            ,CBM_MODIFIED_BY
                            ,CBM_MODIFIED_DATE
                        )
                        VALUES
                        (
                          L_CBM_ID
                          ,l_con_number
                          ,I.CB_ID
                          ,'N'
                          ,i_user_id
                          ,SYSDATE
                          ,null
                          ,null
                        );
                    END IF;
             END LOOP;
            END IF;

            SELECT max(CB_RANK) INTO L_MAX_RANK FROM X_CP_BOUQUET,X_CON_BOUQUE_MAPP
            WHERE CBM_BOUQUE_ID =CB_ID AND CBM_CON_NUMBER = l_con_number AND CBM_CON_BOUQ_RIGHTS ='Y';

            UPDATE X_CON_BOUQUE_MAPP SET CBM_CON_BOUQ_RIGHTS ='Y'
            WHERE CBM_CON_NUMBER = l_con_number
            AND CBM_BOUQUE_ID in (SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_RANK < L_MAX_RANK);



      END IF;


      COMMIT;
          --Deal To license SupserStack rights flow on deal execution
      FOR I IN
      (
          SELECT DISTINCT
          (SELECT LIC_NUMBER FROM FID_LICENSE WHERE LIC_GEN_REFNO=MSR_GEN_REFNO AND LIC_LEE_NUMBER=MSR_LEE_NUMBER) LIC_NUMBER
          --(SELECT LIC_NUMBER FROM FID_LICENSE ,SAK_MEMO WHERE LIC_CON_NUMBER = MEM_CON_NUMBER AND LIC_LEE_NUMBER = MSR_LEE_NUMBER AND MEM_ID = i_mem_id) LIC_NUMBER
          ,MSR_LEE_NUMBER
          ,MSR_BOUQUET_ID
          ,MSR_SUPERSTACK_FLAG
          ,SYSDATE LSR_ENTRY_DATE
          ,i_user_id LSR_ENTRY_OPER
          ,SYSDATE LSR_MODIFY_DATE
          ,i_user_id LSR_MODIFY_OPER
          FROM X_CP_MEMO_SUPERSTACK_RIGHTS
          WHERE
            MSR_ALD_NUMBER IN
            (
                SELECT ALD_ID FROM
                SAK_MEMO, SAK_MEMO_ITEM, SAK_ALLOCATION_DETAIL
                WHERE
                MEM_ID=MEI_MEM_ID
                AND MEI_ID=ALD_MEI_ID
                AND MEM_ID=i_mem_id
            )
      )
      LOOP
          DELETE FROM X_CP_LIC_SUPERSTACK_RIGHTS WHERE LSR_LIC_NUMBER = I.LIC_NUMBER
          AND LSR_BOUQUET_ID = I.MSR_BOUQUET_ID AND LSR_LEE_NUMBER=I.MSR_LEE_NUMBER;

          SELECT X_SEQ_LIC_SUPERSTACK_RIGHTS.nextval INTO L_LSR_ID FROM DUAL;
          INSERT INTO X_CP_LIC_SUPERSTACK_RIGHTS
          (
              LSR_ID
              ,LSR_LIC_NUMBER
              ,LSR_LEE_NUMBER
              ,LSR_BOUQUET_ID
              ,LSR_SUPERSTACK_FLAG
              ,LSR_ENTRY_DATE
              ,LSR_ENTRY_OPER
              ,LSR_MODIFY_DATE
              ,LSR_MODIFY_OPER
              ,LSR_UPDATE_COUNT
          )
          VALUES
          (
                L_LSR_ID
                ,I.LIC_NUMBER
                ,I.MSR_LEE_NUMBER
                ,I.MSR_BOUQUET_ID
                ,I.MSR_SUPERSTACK_FLAG
                ,I.LSR_ENTRY_DATE
                ,I.LSR_ENTRY_OPER
                ,I.LSR_MODIFY_DATE
                ,I.LSR_MODIFY_OPER
                ,0
           );
      END LOOP;


      --Deal To Contract SupserStack rights for new series on deal execution
      FOR I IN
      (
          SELECT DISTINCT
            (SELECT MEM_CON_NUMBER FROM
                SAK_MEMO, SAK_MEMO_ITEM, SAK_ALLOCATION_DETAIL
            WHERE
                MEM_ID=MEI_MEM_ID
                AND MEI_ID=ALD_MEI_ID
                AND MSR_ALD_NUMBER=ALD_ID) CON_NUMBER
            ,MSR_LEE_NUMBER
            ,MSR_BOUQUET_ID
            ,MSR_SUPERSTACK_FLAG
            ,MSR_SEA_NUMBER
            ,SYSDATE CSR_ENTRY_DATE
            ,i_user_id CSR_ENTRY_OPER
            ,SYSDATE CSR_MODIFY_DATE
            ,i_user_id CSR_MODIFY_OPER

              FROM
                X_CP_MEMO_SUPERSTACK_RIGHTS
              WHERE
              MSR_ALD_NUMBER IN
              (
                  SELECT ALD_ID FROM
                  SAK_MEMO, SAK_MEMO_ITEM, SAK_ALLOCATION_DETAIL
                  WHERE
                  MEM_ID=MEI_MEM_ID
                  AND MEI_ID=ALD_MEI_ID
                  AND MEM_ID=i_mem_id
              )
        )
        LOOP
            DELETE FROM x_cp_con_superstack_rights
            WHERE csr_con_number = I.CON_NUMBER
                  and csr_sea_number = I.MSR_SEA_NUMBER
                  and csr_lee_number = I.MSR_LEE_NUMBER
                  and csr_bouquet_id = I.MSR_BOUQUET_ID;

            SELECT X_SEQ_CON_SUPERSTACK_RIGHTS.nextval INTO L_CSR_ID from dual;
            INSERT INTO X_CP_CON_SUPERSTACK_RIGHTS
            (
              CSR_ID
              ,CSR_CON_NUMBER
              ,CSR_LEE_NUMBER
              ,CSR_BOUQUET_ID
              ,CSR_SUPERSTACK_FLAG
              ,CSR_ENTRY_DATE
              ,CSR_ENTRY_OPER
              ,CSR_MODIFY_DATE
              ,CSR_MODIFY_OPER
              ,CSR_SEA_NUMBER
            )
            VALUES
            (
              L_CSR_ID
              ,I.CON_NUMBER
              ,I.MSR_LEE_NUMBER
              ,I.MSR_BOUQUET_ID
              ,I.MSR_SUPERSTACK_FLAG
              ,I.CSR_ENTRY_DATE
              ,I.CSR_ENTRY_OPER
              ,I.CSR_MODIFY_DATE
              ,I.CSR_MODIFY_OPER
              ,I.MSR_SEA_NUMBER
           );
         END LOOP;

        delete from X_CP_CON_BOUQ_SSTACK_RIGHTS where CBR_CON_NUMBER = l_con_number;

         INSERT INTO X_CP_CON_BOUQ_SSTACK_RIGHTS
         (
                CBR_ID
                ,CBR_BOUQUET_ID
                ,CBR_SUPERSTACKRIGHTS
                ,CBR_UPDATE_COUNT
                ,CBR_ENTRY_OPER
                ,CBR_ENTRY_DATE
                ,CBR_MODIFY_OPER
                ,CBR_MODIFY_DATE
                ,CBR_CON_NUMBER
         )
         SELECT SEQ_CON_BOUQ_SSTACK_RIGHTS.nextval,
                CSR_BOUQUET_ID,
                Superstack_rights,
                0,
                CSR_ENTRY_OPER,
                csr_entry_date,
                null,
                null,
                CSR_CON_NUMBER
        FROM (select distinct CSR_BOUQUET_ID,
                     (CASE
                     WHEN
                        (select count(1) from X_CP_CON_SUPERSTACK_RIGHTS where CSR_CON_NUMBER=l_con_number
                                          and CSR_BOUQUET_ID = abc.CSR_BOUQUET_ID AND csr_superstack_flag ='Y')>0
                      THEN
                          'Y'
                      ELSE
                          'N'
                      END)Superstack_rights,
                     CSR_ENTRY_OPER,
                     csr_entry_date,
                     CSR_CON_NUMBER
               FROM x_cp_con_superstack_rights abc
               where csr_con_number = l_con_number);


      COMMIT;
      --Dev.R1: CatchUp for All: End





            /* PB (CR) :Pranay Kusumwal 21/06/2012 : Added for inserting the data in license table for new payment terms for royalty */
            -----Dev:Pure Finance:Start:_[Hari Mandal]_[25/03/2013]--
            ----comment below variables as split payment done in create_roy_pay proced
            /*BEGIN
                    FOR i IN (SELECT lic_number
                                FROM fid_license
                               WHERE lic_mem_number = i_mem_id)
                    LOOP
                       SELECT lic_start, lic_end
                         INTO l_start, l_end
                         FROM fid_license
                        WHERE lic_number = i.lic_number;

                       FOR j IN (SELECT msp_split_month_num, msp_percent_payment
                                   FROM sgy_sak_memo_split_payment
                                  WHERE msp_mem_id = i_mem_id)
                       LOOP
                          l_lsp_id := seq_lic_split_payment.NEXTVAL;
                          pkg_alic_cm_licensemaintenance.calc_pay_month
                                                           (l_start,
                                                            l_end,
                                                            NULL,
                                                            j.msp_split_month_num,
                                                            o_due_date
                                                           );

                          INSERT INTO sgy_lic_split_payment
                                      (lsp_id, lsp_lic_number,
                                       lsp_split_month_num,
                                       lsp_percent_payment, lsp_entry_oper,
                                       lsp_entry_date, lsp_due_date
                                      )
                               VALUES (l_lsp_id, i.lic_number,
                                       j.msp_split_month_num,
                                       j.msp_percent_payment, i_user_id,
                                       SYSDATE, o_due_date
                                      );
                       END LOOP;
                    END LOOP;
                 EXCEPTION
                    WHEN OTHERS
                    THEN
                       raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
                 END;*/

            -------Dev:Pure Finance:End---------------
            /* PB (CR) END */
            IF i_is_t_exe = 'Y'
            THEN
               L_MESSAGE := 'Deal memo Texecuted';

               --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
               UPDATE FID_CONTRACT
                  SET CON_STATUS = 'T'
                WHERE CON_NUMBER = NVL (L_MEM_CON_NUMBER, SECONDCONNUMBER);
            --RDT END : Acquision Requirements BR_15_104
            ELSE
               L_MESSAGE := 'Deal memo executed';

               --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
               UPDATE FID_CONTRACT
                  SET CON_STATUS = 'A'
                WHERE CON_NUMBER = NVL (L_MEM_CON_NUMBER, SECONDCONNUMBER);
            --RDT END : Acquision Requirements BR_15_104
            END IF;

            o_message := l_message;

            --start - CVS Performance issue  for UID creation while deal execution
            IF l_mem_status IN ('BUDGETED', 'BEXECUTED')
               AND NVL (i_is_t_exe, 'N') <> 'Y'
            THEN
               NULL;
            ELSE
               BEGIN
                  INSERT
                    INTO X_CREATE_UID_FOR_DEAL (cud_mem_id,
                                                cud_uid_creating_status,
                                                cud_user_id)
                  VALUES (i_mem_id, 'NEW', i_user_id);

                  COMMIT;
               /*DBMS_SCHEDULER.CREATE_JOB (
                  job_name     => 'UID_' || i_mem_id,
                  job_type     => 'PLSQL_BLOCK',
                  JOB_ACTION   => 'begin
               X_PRC_CREATE_UID_FOR_DEAL('
                                 || i_mem_id
                                 || ','''
                                 || i_user_id
                                 || ''');
               end;',
                  start_date   => SYSDATE,
                  --repeat_interval => 'INTERVAL=1',
                  end_date     => NULL,
                  enabled      => TRUE,
                  comments     => ' ');
               DBMS_OUTPUT.put_line (
                  'JOB inputs ------ ' || i_mem_id || i_user_id);
               DBMS_OUTPUT.put_line ('JOB CREATED #####');*/
               END;
            END IF;
         -- end

         EXCEPTION
            WHEN no_deal_execution
            THEN
               ROLLBACK;
               raise_application_error (-20001, l_message);
            WHEN allocations_dont_addup
            THEN
               ROLLBACK;
               l_message := 'ERROR: The Allocations on Page 1 do not add up.';
               raise_application_error (-20013, l_message);
            WHEN payments_dont_addup
            THEN
               ROLLBACK;
               l_message := 'ERROR: The payments do not add up.';
               raise_application_error (-20013, l_message);
            WHEN OTHERS
            THEN
               ROLLBACK;
               raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
         END;
      END IF;
   END prc_execute_deal_memo;

   ------------------------------------- PROCEDURE FOR CHECK LIVE DATE DEAL MEMO ----------------------------------------------------------------
   PROCEDURE prc_check_live_date (i_mem_id    IN     sak_memo.mem_id%TYPE,
                                  o_message      OUT VARCHAR2)
   AS
      testdate               DATE;
      testtime               NUMBER;
      l_message              VARCHAR2 (200);
      live_date_chk_failed   EXCEPTION;
   BEGIN
      FOR mei_rec IN (SELECT mei_gen_refno
                        FROM sak_memo_item
                       WHERE mei_mem_id = i_mem_id)
      LOOP
         FOR gen
            IN (SELECT gen_refno
                  FROM fid_general, fid_code
                 WHERE     gen_ser_number = mei_rec.mei_gen_refno
                       AND gen_type = cod_value
                       AND cod_type = 'GEN_TYPE'
                       AND cod_attr2 = 'Y')
         LOOP
            BEGIN
               SELECT fgl_live_date, fgl_time
                 INTO testdate, testtime
                 FROM fid_gen_live
                WHERE fgl_gen_refno = gen.gen_refno;

               IF testdate IS NULL OR testtime IS NULL
               THEN
                  l_message :=
                     'ERROR: You Have To Specify A Live date And Time For License Period';
                  o_message := l_message;
                  --EXIT;
                  RAISE live_date_chk_failed;
               END IF;
            EXCEPTION
               WHEN live_date_chk_failed
               THEN
                  raise_application_error (-20601, l_message);
               WHEN OTHERS
               THEN
                  l_message :=
                     'ERROR: You Have To Specify A Live date And Time For Live Series';
                  o_message := l_message;
                  raise_application_error (-20601, l_message);
            --EXIT;
            END;
         END LOOP;
      END LOOP;
   END prc_check_live_date;

   ---------TO BE USED AT UI LEVEL---------------------------------------------------------------------------------------------------------------------
   PROCEDURE check_amort_rules (
      i_mem_amort_method   IN sak_memo.mem_amort_method%TYPE,
      i_mem_align_ind      IN sak_memo.mem_align_ind%TYPE,
      i_mem_mplex_ind      IN sak_memo.mem_mplex_ind%TYPE)
   AS
   BEGIN
      NULL;
   END check_amort_rules;

   ------------------------------------- PROCEDURE FOR CHECK FOR SIGN OF DEAL MEMO ------------------------------------------------------------------------
   PROCEDURE prc_check_for_sign (i_mem_id    IN     sak_memo.mem_id%TYPE,
                                 o_message      OUT VARCHAR2)
   AS
      l_message               VARCHAR2 (250);
      check_for_sign_failed   EXCEPTION;
      l_mem_status            sak_memo.mem_status%TYPE;
   BEGIN
      ---Dev2:Pure Finance:Start:[Hari Mandal]_[2013/04/01]_[For NCF Deal no check for sign validation]
      SELECT mem_status
        INTO l_mem_status
        FROM sak_memo
       WHERE mem_id = i_mem_id;

      IF l_mem_status IN ('NCF', 'NCFExecuted')
      THEN
         NULL;
      ELSE
         --ALERT_SERIES;
         IF fid_deal_mem_pk.check_allocation (i_mem_id) = -1
         THEN
            l_message := 'Allocations Do Not Add Up';
            o_message := l_message;
            RAISE check_for_sign_failed;
         --ELSE
         -- o_message := '';
         END IF;

         --IF (o_message IS NULL)      THEN
         IF fid_deal_mem_pk.check_payment (i_mem_id) <> 0
         THEN
            l_message := 'Payments Do Not Add Up';
            o_message := l_message;
            RAISE check_for_sign_failed;
         --ELSE
         -- o_message := '';
         END IF;

         -- IF (o_message IS NULL)       THEN
         --pkg_adm_cm_dealmemo.prc_check_cha_runs (i_mem_id, o_message);
         pkg_adm_cm_dealmemo.prc_check_cha_runs (i_mem_id);
         pkg_adm_cm_dealmemo.prc_check_catchup_validation (i_mem_id);
      -- END IF;
      END IF;

      ---Dev2:Pure Finance:End------------------------------------------
      o_message := 'Check for Recommending Deal Memo is complete.';
   --DBMS_OUTPUT.put_line ('chk for sign');
   EXCEPTION
      WHEN check_for_sign_failed
      THEN
         raise_application_error (-20601, l_message);
   END prc_check_for_sign;

   ------------------------------------- PROCEDURE FOR CREATING HISTORY OF DEAL MEMO ----------------------------------------------------------------
   PROCEDURE prc_create_history (
      i_action       IN     VARCHAR2,
      i_mem_id       IN     sak_memo.mem_id%TYPE,
      i_mem_type     IN     sak_memo.mem_type%TYPE,
      i_user_id      IN     sak_memo.mem_entry_oper%TYPE,
      o_mem_status      OUT sak_memo.mem_status%TYPE,
      i_comment      IN     VARCHAR2 DEFAULT NULL,
       i_metadata_comment In  VARCHAR2 DEFAULT NULL--- Added by rasjmio30-03-2016
       )
   AS
      CURSOR c_history
      IS
           SELECT mhi_from_stat, mhi_to_stat
             FROM sak_memo_history
            WHERE mhi_mem_id = i_mem_id AND mhi_action != 'UNDO-RECOMMEND'
         ORDER BY mhi_entry_date DESC;

      history_not_found   EXCEPTION;
      l_hist_found        VARCHAR2 (1);
      l_message           VARCHAR2 (250);
      l_fsr_val           fid_system_rules.fsr_value4%TYPE;
      l_mem_type          VARCHAR2 (5);
      l_mem_status        sak_memo.mem_status%TYPE;
      l_dm_exist          NUMBER;
      l_qa_req            VARCHAR2 (5);
      l_meta_flag          VARCHAR2 (5);
      l_lee_number        number;
   BEGIN
      SELECT COUNT (*)
        INTO l_dm_exist
        FROM sak_memo
       WHERE mem_id = i_mem_id;

      -- DBMS_OUTPUT.put_line ('l_dm_exist' || l_dm_exist);

      IF l_dm_exist > 0
      THEN
         SELECT mem_status, mem_type,MEM_LEE_NUMBER
           INTO l_mem_status, l_mem_type,l_lee_number
           FROM sak_memo
          WHERE mem_id = i_mem_id;
      ELSE
         l_mem_status := 'NEW';
         l_mem_type := i_mem_type;
      END IF;
      --insert into temp_table values (l_mem_status);
      --commit;
      begin

      select MEU_METADATAQA_FLAG
      into l_meta_flag
      from sak_memo_user
    where MEU_METADATAQA_FLAG ='Y'
     and meu_usr_id = i_user_id
      and meu_lee_number in (select lee_number from fid_licensee where LEE_METADATAQA_FLAG ='Y'and meu_lee_number= l_lee_number);

      exception
      when no_data_found
      then l_meta_flag:='N';
      end;

      /*
        BEGIN
          SELECT NVL (mem_status, NULL)--, mem_type
            INTO l_mem_status--, l_mem_type
            FROM sak_memo
           WHERE mem_id = i_mem_id;
           exception
           when no_data_found then
           l_mem_status:=null;
       END;*/
      --  DBMS_OUTPUT.put_line ('in history' || i_mem_id || l_mem_status);
      l_qa_req := pkg_adm_cm_dealmemo.qarequired (i_mem_id);

      IF     l_qa_req = 'Y'
         AND i_action = 'UNDO-RECOMMEND'
         AND l_mem_status = 'PD RECOMMENDED'
      THEN
         BEGIN
            SELECT fsr_value4
              INTO l_fsr_val
              FROM fid_system_rules
             WHERE     fsr_type = 'D'
                   AND fsr_code = 'MEMO'
                   AND fsr_value1 = l_mem_type
                   AND fsr_value2 = NVL (l_mem_status, 'NEW')
                   AND fsr_value3 = i_action
                   AND fsr_value5 = l_qa_req;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_message := 'No data found in system rules.';
               RAISE history_not_found;
            when too_many_rows
            then
              SELECT fsr_value4
              INTO l_fsr_val
              FROM fid_system_rules
             WHERE     fsr_type = 'D'
                   AND fsr_code = 'MEMO'
                   AND fsr_value1 = l_mem_type
                   AND fsr_value2 = NVL (l_mem_status, 'NEW')
                   AND fsr_value3 = i_action
                   AND fsr_value5 = l_qa_req
                   ANd nvl(fsr_meta_flag,'N') = l_meta_flag;
         END;
      ELSE
         BEGIN
            SELECT fsr_value4
              INTO l_fsr_val
              FROM fid_system_rules
             WHERE     fsr_type = 'D'
                   AND fsr_code = 'MEMO'
                   AND fsr_value1 = l_mem_type
                   AND fsr_value2 = NVL (l_mem_status, 'NEW')
                   AND fsr_value3 = i_action
                   AND fsr_value5 IS NULL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_message := 'No data found in system rules.';
               RAISE history_not_found;
        when too_many_rows
            then
            SELECT fsr_value4
              INTO l_fsr_val
              FROM fid_system_rules
             WHERE     fsr_type = 'D'
                   AND fsr_code = 'MEMO'
                   AND fsr_value1 = l_mem_type
                   AND fsr_value2 = NVL (l_mem_status, 'NEW')
                   AND fsr_value3 = i_action
                   AND fsr_value5 IS NULL
                    ANd nvl(fsr_meta_flag,'N') = l_meta_flag;
         END;
      END IF;

      --   DBMS_OUTPUT.put_line ('fsr_value4' || l_fsr_val);

      --DBMS_OUTPUT.put_line ('in history' || i_mem_id);
      --DBMS_OUTPUT.put_line ('in history1' || i_mem_id || l_mem_status);
      /*DBMS_OUTPUT.put_line (   'in history2'
                            || i_mem_id
                            || l_mem_status
                            || l_fsr_val
                           );*/
      IF l_fsr_val IS NULL
      THEN
         l_message :=
               'Action '
            || i_action
            || ' cannot be done when deal memo is in '
            || l_mem_status
            || ' status ';
         --DBMS_OUTPUT.put_line (l_message);
         raise_application_error (-20228, l_message);
      END IF;

      --DBMS_OUTPUT.put_line ('1:' || l_message);
      IF l_fsr_val = 'HISTORY'
      THEN
         l_hist_found := 'N';

         FOR pre IN c_history
         LOOP
            --DBMS_OUTPUT.put_line ('in loop');
            IF l_hist_found = 'Y'
            THEN
               EXIT;
            END IF;

            IF pre.mhi_to_stat = l_mem_status
            THEN
               IF pre.mhi_from_stat = 'QAFAILED'
               THEN
                  l_fsr_val := 'REGISTERED';
               ELSE
                  l_fsr_val := pre.mhi_from_stat;
               END IF;

               l_hist_found := 'Y';
            END IF;
         END LOOP;

         --DBMS_OUTPUT.put_line ('outside loop'||l_hist_found );
         IF l_hist_found = 'N'
         THEN
            --DBMS_OUTPUT.put_line ('outside loop 1111'||l_hist_found );
            l_message := 'Previous deal memo status could not be determined';
            RAISE history_not_found;
         --raise_application_error (-20228, l_message);
         END IF;
      END IF;

      --DBMS_OUTPUT.put_line (   i_mem_id);
      /* || ' , '
       || NVL (l_mem_status, 'NEW')
       || ' , '
       || i_action
       || ' , '
       || l_fsr_val
       || ' , '
       || SYSDATE
       || ' , '
       || i_user_id
       || ' , '
       || 0
      );*/
      BEGIN
         INSERT INTO sak_memo_history (mhi_mem_id,
                                       mhi_from_stat,
                                       mhi_action,
                                       mhi_to_stat,
                                       mhi_entry_date,
                                       mhi_entry_oper,
                                       mhi_update_count,
                                       mhi_comment,
                                       mhi_meta_comment --added by rashmi 30-03-2016
                                       )
              VALUES (i_mem_id,
                      NVL (l_mem_status, 'NEW'),
                      i_action,
                      l_fsr_val,
                      SYSDATE,
                      i_user_id,
                      0,
                      i_comment,
                      i_metadata_comment
                      );
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      --DBMS_OUTPUT.put_line ('   333333333');
      -- COMMIT;
      o_mem_status := l_fsr_val;
   --o_mem_status_date := SYSDATE;
   EXCEPTION
      WHEN history_not_found
      THEN
         raise_application_error (-20601, l_message);
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_create_history;

   PROCEDURE prc_get_approval_info (i_mem_id              IN     sak_memo.mem_id%TYPE,
                                    o_mem_buyer              OUT VARCHAR2,
                                    o_mem_buyer_date         OUT DATE,
                                    o_mem_approver           OUT VARCHAR2,
                                    o_mem_approval_date      OUT DATE)
   AS
   BEGIN
      SELECT NVL (mem_buyer, ''),
             NVL (mem_buyer_date, ''),
             NVL (mem_approver, ''),
             NVL (mem_approval_date, '')
        INTO o_mem_buyer,
             o_mem_buyer_date,
             o_mem_approver,
             o_mem_approval_date
        FROM sak_memo
       WHERE mem_id = i_mem_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   ------------------------------------- PROCEDURE TO CHANGE STATUS OF DEAL MEMO ----------------------------------------------------------------
   PROCEDURE prc_change_dm_status (
      i_mem_id       IN     sak_memo.mem_id%TYPE,
      i_user_id      IN     sak_memo.mem_entry_oper%TYPE,
      i_status       IN     VARCHAR,
      o_mem_status      OUT VARCHAR2,
      o_message         OUT VARCHAR2,
      i_comment      IN     VARCHAR2 DEFAULT NULL,
       i_metadata_comment In  VARCHAR2 DEFAULT NULL)
   AS
      l_mem_approver             VARCHAR2 (30);
      l_mem_rejecter             VARCHAR2 (30);
      l_mem_approval_date        DATE;
      l_mem_buyer                VARCHAR2 (30);
      l_lics                     NUMBER;
      l_signb                    NUMBER;
      l_message                  VARCHAR2 (250);
      l_current_status           VARCHAR2 (25);
      l_mem_buyer_date           DATE;
      l_mem_type                 VARCHAR2 (4);
      l_is_budgeted              NUMBER;
      l_budgeted_cnt             NUMBER;
      memo_not_signed_by_buyer   EXCEPTION;
      memo_cannot_be_unsigned    EXCEPTION;
      ---Dev:Non Costed Filler:Start:[Hari Mandal]_[25/03/2013]--------------------
      l_mem_con_price            sak_memo.mem_con_price%TYPE;
      l_mei_id                   sak_memo_item.mei_id%TYPE;
      l_mei_total_price          sak_memo_item.mei_total_price%TYPE;
      l_ald_amount               sak_allocation_detail.ald_amount%TYPE;
      l_dsl_amount               x_fin_dm_sec_lee.dsl_amount%TYPE;
	  l_cnt_ser                  number;
	  l_cnt                      number;
      l_com_qa_reqd              VArchar2(1);
   ---Dev:Non Costed Filler:END--------------------------------------------------
	--Pravin - Add condition for Episodes
	l_Mei_gen_refno             Number;
	CURSOR gen_c (cp_genrefno NUMBER)
				  IS
					SELECT *
					FROM fid_general
					WHERE gen_ser_number = cp_genrefno;

	gen                 gen_c%ROWTYPE;
	--Pravin - End
   BEGIN
      -- Place security stuff here
      IF i_mem_id IS NOT NULL
      THEN
         SELECT mem_status, mem_type, mem_con_price
           INTO l_current_status, l_mem_type, l_mem_con_price
           FROM sak_memo
          WHERE mem_id = i_mem_id;

         SELECT COUNT (*)
           INTO l_is_budgeted
           FROM sak_memo_history
          WHERE mhi_mem_id = i_mem_id AND mhi_to_stat = 'BUDGETED';

          BEgin
            select   nvl(com_qa_required,'N')
              into l_com_qa_reqd
             from fid_company ,
                   sak_memo
                   where com_number = mem_com_number
                   and mem_id = i_mem_id;
                 Exception
                   when no_data_found
                   then
                    l_com_qa_reqd := 'N';
                End;

               -- insert into temp_table values(' l_com_qa_reqd'||l_com_qa_reqd);
         BEGIN
            IF i_status = 'RECOMMENDB'
            THEN
               BEGIN
					--Pravin


                 for l_series in (select ser_number,nvl(ser_parent_number,0)ser_parent_number,ser_title
                                      --into l_cnt_ser
                                  from fid_series where ser_number in (select mei_gen_refno
                                                                         from sak_memo_item
                                                                        where mei_mem_id =i_mem_id
                                                                       AND X_FNC_GET_PROG_TYPE(MEI_TYPE_SHOW)='Y'))
                  Loop
                       select count(1)
                         into l_cnt
                       from fid_general where gen_ser_number = l_series.ser_number;


                         IF l_cnt = 0
                          THEN
                            if l_series.ser_parent_number > 0
                             then
                              raise_application_error (
                                -20601,
                               'ERROR: Episode(s) are missing for Season '||l_series.ser_title);
                            else
                              raise_application_error (
                               -20601,
                              'ERROR: Season(s) are missing for Series '||l_series.ser_title);
                           end if;
                         END IF;

                   end loop;

					--Pravin End

                  IF l_current_status IN
                        ('REGISTERED', 'BUDGETED', 'BEXECUTED', 'TEXECUTED','METADATA QAFAILED')
                  THEN
                     pkg_adm_cm_dealmemo.prc_check_cha_runs_rights (i_mem_id);
                     -- Commented asper CR 55912 by Anirudha on 23/05/2012
                     /*pkg_adm_cm_dealmemo.prc_check_media_rights(i_mem_id);

                     if l_Is_budgeted = 0
                     then
                         pkg_adm_cm_dealmemo.prc_check_prog_bo_category(i_mem_id);
                     end if;
                     */
                     -- END Commented asper CR 55912 by Anirudha on 23/05/2012
                     pkg_adm_cm_dealmemo.prc_check_for_sign (i_mem_id,
                                                             o_message);
                     /* CACQ3 Catchup :Pranay Kusumwal 18/10/2012 :Calling SP for catchup Deal memo validations */
                     pkg_adm_cm_dealmemo.prc_check_catchup_validation (
                        i_mem_id);

                     --    DBMS_OUTPUT.put_line ('000000000');

                     BEGIN
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_buyer, l_mem_buyer_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               AND meu_buyer = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           l_message :=
                              'ERROR: You are not permitted to sign deal memos.';
                           o_message := l_message;
                     END;

                     IF l_mem_buyer IS NOT NULL
                     THEN
                        --    DBMS_OUTPUT.put_line ('   11111111111');
                        --COMMIT;
                        pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                                --'RECOMMENDB',
                                                                i_mem_id,
                                                                l_mem_type,
                                                                i_user_id,
                                                                o_mem_status);

                        UPDATE sak_memo
                           SET mem_status = 'BUYER RECOMMENDED',
                               mem_buyer = l_mem_buyer,
                               mem_buyer_date = SYSDATE
                         --mem_update_count = NVL (mem_update_count, 0) + 1 --Commented by Omkar
                         WHERE mem_id = i_mem_id;

                        --     DBMS_OUTPUT.put_line ('   222222222222');

                        IF l_com_qa_reqd = 'N'
                        then
                        X_PRC_SEND_METADATA_EMAIL(i_mem_id, i_user_id,null);
                       end if;
                        l_message := 'Memo Recommended. Commit complete.';
                        o_message := l_message;
                     END IF;
                      COMMIT;

                  ------------------ADDED BY PRANAY FOR SIGNED QA CR  ------------------------
                  ELSIF l_current_status = 'QAFAILED'
                  THEN
                     pkg_adm_cm_dealmemo.prc_check_for_sign (i_mem_id,
                                                             o_message);

                     --   DBMS_OUTPUT.put_line ('000000000');

                     BEGIN
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_buyer, l_mem_buyer_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               AND meu_buyer = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           l_message :=
                              'ERROR: You are not permitted to recommend deal memos.';
                           o_message := l_message;
                     END;

                     IF l_mem_buyer IS NOT NULL
                     THEN
                        --      DBMS_OUTPUT.put_line ('   11111111111');
                        --COMMIT;
                        pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                                --'RECOMMENDB',
                                                                i_mem_id,
                                                                l_mem_type,
                                                                i_user_id,
                                                                o_mem_status);

                        UPDATE sak_memo
                           SET mem_status = 'BUYER RECOMMENDED',
                               mem_buyer = l_mem_buyer,
                               mem_buyer_date = SYSDATE
                         --mem_update_count = NVL (mem_update_count, 0) + 1 --Commented by Omkar
                         WHERE mem_id = i_mem_id;

                        --   DBMS_OUTPUT.put_line ('   222222222222');
                        COMMIT;
                        l_message := 'Memo Recommended. Commit complete.';
                        o_message := l_message;
                     END IF;
                  -------------------------changes by pranay for signed QA end  ---------------------
                  --END IF;
                  END IF;
               --END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     raise_application_error (-20601, 'No Data Found 1');
                  --SUBSTR (SQLERRM, 1, 250)
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20601,
                                              SUBSTR (SQLERRM, 1, 250));
               END;
            ELSIF i_status = 'RECOMMENDPD'
            THEN
               IF l_current_status = 'QAPASSED'
               THEN
                  BEGIN
                     pkg_adm_cm_dealmemo.prc_check_cha_runs_rights (i_mem_id);
                     --  Commented asper CR 55912 by Anirudha on 23/05/2012
                     /*pkg_adm_cm_dealmemo.prc_check_media_rights(i_mem_id);

                     if l_Is_budgeted = 0
                     then
                         pkg_adm_cm_dealmemo.prc_check_prog_bo_category(i_mem_id);
                     end if;
                     */
                     -- END Commented asper CR 55912 by Anirudha on 23/05/2012
                     pkg_adm_cm_dealmemo.prc_check_for_sign (i_mem_id,
                                                             o_message);

                     SELECT mem_buyer
                       INTO l_mem_buyer
                       FROM sak_memo
                      WHERE mem_id = i_mem_id;

                     IF l_mem_buyer IS NULL
                     THEN
                        l_message := 'ERROR: Buyer must recommend first.';
                        o_message := l_message;
                     ELSE
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_approver, l_mem_approval_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               AND meu_can_sign = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);

                        SELECT COUNT (*)
                          INTO l_signb
                          FROM sak_memo, fid_company
                         WHERE     com_number = mem_com_number
                               AND mem_id = i_mem_id
                               AND mem_status <> 'QAPASSED'
                               AND com_qa_required = 'Y';

                        IF l_signb = 0
                        THEN
                           pkg_adm_cm_dealmemo.prc_create_history (
                              i_status,
                              --'RECOMMENDPD',
                              i_mem_id,
                              l_mem_type,
                              i_user_id,
                              o_mem_status);

                           UPDATE sak_memo
                              SET mem_status = 'PD RECOMMENDED',
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;

                           COMMIT;
                           l_message := 'Memo Recommended. Commit complete.';
                           o_message := l_message;
                        --DBMS_OUTPUT.put_line (l_message);
                        ELSE
                           l_message := 'Memo is not passed by the QA';
                           o_message := l_message;
                        END IF;
                     END IF;
                  --END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'ERROR: You are not permitted to recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
               ELSif l_current_status = 'METADATA QAPASSED'
               THEN
                  BEGIN
                     pkg_adm_cm_dealmemo.prc_check_cha_runs_rights (i_mem_id);
                     pkg_adm_cm_dealmemo.prc_check_for_sign (i_mem_id,
                                                             o_message);
                   -- insert into temp_table values ('pkk');
                    commit;
                     SELECT mem_buyer
                       INTO l_mem_buyer
                       FROM sak_memo
                      WHERE mem_id = i_mem_id;

                     IF l_mem_buyer IS NULL
                     THEN
                        l_message := 'ERROR: Buyer must recommend first.';
                        o_message := l_message;
                     ELSE
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_approver, l_mem_approval_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               AND meu_can_sign = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);

                        SELECT COUNT (*)
                          INTO l_signb
                          FROM sak_memo, fid_company
                         WHERE     com_number = mem_com_number
                               AND mem_id = i_mem_id
                               AND mem_status <> 'QAPASSED'
                               AND com_qa_required = 'Y';

                        IF l_signb >= 0
                        THEN
                           pkg_adm_cm_dealmemo.prc_create_history (
                              i_status,
                              --'RECOMMENDPD',
                              i_mem_id,
                              l_mem_type,
                              i_user_id,
                              o_mem_status);

                           UPDATE sak_memo
                              SET mem_status = 'PD RECOMMENDED',
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;

                           COMMIT;
                           l_message := 'Memo Recommended. Commit complete.';
                           o_message := l_message;
                        --DBMS_OUTPUT.put_line (l_message);
                        ELSE
                           l_message := 'Memo is not passed by the QA';
                           o_message := l_message;
                        END IF;
                     END IF;
                  --END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'ERROR: You are not permitted to recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
              /* ELSE
                  BEGIN
                     pkg_adm_cm_dealmemo.prc_check_for_sign (i_mem_id,
                                                             o_message);

                     SELECT mem_buyer
                       INTO l_mem_buyer
                       FROM sak_memo
                      WHERE mem_id = i_mem_id;

                     IF l_mem_buyer IS NULL
                     THEN
                        l_message := 'ERROR: Buyer must recommend first.';
                     ELSE
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_approver, l_mem_approval_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               AND meu_can_sign = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);

                        SELECT COUNT (*)
                          INTO l_signb
                          FROM sak_memo, fid_company
                         WHERE     com_number = mem_com_number
                               AND mem_id = i_mem_id
                               AND mem_status <> 'QAPASSED'
                               AND com_qa_required = 'Y'
                               AND NOT EXISTS
                                          (SELECT 1
                                             FROM sak_memo_history
                                            WHERE mhi_mem_id = i_mem_id
                                                  AND (mhi_from_stat =
                                                          'BUDGETED'
                                                       OR mhi_to_stat =
                                                             'BUDGETED'));

                        IF l_signb = 0
                        THEN
                           pkg_adm_cm_dealmemo.prc_create_history (
                              i_status,
                              --'RECOMMENDPD',
                              i_mem_id,
                              l_mem_type,
                              i_user_id,
                              o_mem_status);

                           UPDATE sak_memo
                              SET mem_status = 'PD RECOMMENDED',
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;

                           COMMIT;
                           l_message := 'Memo Recommended. Commit complete.';
                           o_message := l_message;
                        --DBMS_OUTPUT.put_line (l_message);
                        ELSE
                           l_message := 'Memo is not passed by the MetadatQA';
                           o_message := l_message;
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'ERROR: You are not permitted to recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;*/
               else
                  BEGIN
                     pkg_adm_cm_dealmemo.prc_check_for_sign (i_mem_id,
                                                             o_message);

                     SELECT mem_buyer
                       INTO l_mem_buyer
                       FROM sak_memo
                      WHERE mem_id = i_mem_id;

                     IF l_mem_buyer IS NULL
                     THEN
                        l_message := 'ERROR: Buyer must recommend first.';
                     ELSE
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_approver, l_mem_approval_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               AND meu_can_sign = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);

                        SELECT COUNT (*)
                          INTO l_signb
                          FROM sak_memo, fid_company
                         WHERE     com_number = mem_com_number
                               AND mem_id = i_mem_id
                               AND mem_status <> 'QAPASSED'
                               AND com_qa_required = 'Y'
                               AND NOT EXISTS
                                          (SELECT 1
                                             FROM sak_memo_history
                                            WHERE mhi_mem_id = i_mem_id
                                                  AND (mhi_from_stat =
                                                          'BUDGETED'
                                                       OR mhi_to_stat =
                                                             'BUDGETED'));

                        IF l_signb = 0
                        THEN
                           pkg_adm_cm_dealmemo.prc_create_history (
                              i_status,
                              --'RECOMMENDPD',
                              i_mem_id,
                              l_mem_type,
                              i_user_id,
                              o_mem_status);

                           UPDATE sak_memo
                              SET mem_status = 'PD RECOMMENDED',
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;

                           COMMIT;
                           l_message := 'Memo Recommended. Commit complete.';
                           o_message := l_message;
                        --DBMS_OUTPUT.put_line (l_message);
                        ELSE
                           l_message := 'Memo is not passed by the QA';
                           o_message := l_message;
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'ERROR: You are not permitted to recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
               END IF;



               ----Code added by rashmi31-03-2015
           				   ELSIF i_status = 'METADATA QAPASS'
            THEN
               IF l_current_status = 'BUYER RECOMMENDED'
               THEN
                  BEGIN
                     SELECT mem_buyer
                       INTO l_mem_buyer
                       FROM sak_memo
                      WHERE mem_id = i_mem_id;

                     IF l_mem_buyer IS NULL
                     THEN
                        l_message := 'ERROR: Buyer must recommend first.';
                     ELSE
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_approver, l_mem_approval_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                                 AND  meu_buyer = 'Y'
                              -- AND meu_signqa = 'Y' --- commented on 5-52016
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);

                        SELECT COUNT (*)
                          INTO l_signb
                          FROM sak_memo
                         WHERE mem_id = i_mem_id
                               AND mem_status = 'BUYER RECOMMENDED';

                        IF l_signb > 0
                        THEN
                           pkg_adm_cm_dealmemo.prc_create_history (
                              i_status,
                              --'RECOMMENDPD',
                              i_mem_id,
                              l_mem_type,
                              i_user_id,
                              o_mem_status);

                           --DBMS_OUTPUT.put_line (3);
                           UPDATE sak_memo
                              SET mem_status = 'METADATA QAPASSED',
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;

                           COMMIT;
                           l_message := 'Memo METADATA QA PASSED. Commit complete.';
                           o_message := l_message;

                           --Added By Pravin to send an Email once Metadata QA Passed
                           X_PRC_SEND_METADATA_EMAIL(i_mem_id,i_user_id,'METADATA QAPASSED');
                           --Pravin - End
                        --DBMS_OUTPUT.put_line (l_message);
                        ELSE
                           l_message := 'Memo is not METADATA QA PASSED.';
                           o_message := l_message;
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                             'ERROR: You are not permitted to recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
               END IF;

               ---added by rashmi now
                         IF l_current_status = 'QAPASSED'
               THEN
                  BEGIN
                     pkg_adm_cm_dealmemo.prc_check_cha_runs_rights (i_mem_id);

                     -- END Commented asper CR 55912 by Anirudha on 23/05/2012
                     pkg_adm_cm_dealmemo.prc_check_for_sign (i_mem_id,
                                                             o_message);

                     SELECT mem_buyer
                       INTO l_mem_buyer
                       FROM sak_memo
                      WHERE mem_id = i_mem_id;

                     IF l_mem_buyer IS NULL
                     THEN
                        l_message := 'ERROR: Buyer must recommend first.';
                        o_message := l_message;
                     ELSE
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_approver, l_mem_approval_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               AND meu_can_sign = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);

                        SELECT COUNT (*)
                          INTO l_signb
                          FROM sak_memo, fid_company
                         WHERE     com_number = mem_com_number
                               AND mem_id = i_mem_id
                               AND mem_status <> 'QAPASSED'
                               AND com_qa_required = 'Y';

                        IF l_signb = 0
                        THEN
                           pkg_adm_cm_dealmemo.prc_create_history (
                              i_status,
                              --'RECOMMENDPD',
                              i_mem_id,
                              l_mem_type,
                              i_user_id,
                              o_mem_status);

                          commit;
                           UPDATE sak_memo
                              SET mem_status = 'METADATA QAPASSED',
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;

                           COMMIT;
                           l_message := 'Memo METADATA QA PASSED. Commit complete.';
                           o_message := l_message;

                           --Added By Pravin to send an Email once Metadata QA Passed
                           X_PRC_SEND_METADATA_EMAIL(i_mem_id,i_user_id,'METADATA QAPASSED');
                           --Pravin - End
                        --DBMS_OUTPUT.put_line (l_message);
                        ELSE
                           l_message := 'Memo is not METADATA QA PASSED.';
                           o_message := l_message;
                        END IF;
                     END IF;
                  --END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'ERROR: You are not permitted to recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
		  End if;
               -----end rashmi now


                  ELSIF i_status = 'METADATA QAFAIL'
            THEN
               IF l_current_status = 'BUYER RECOMMENDED'
               THEN
                  BEGIN
                     SELECT mem_buyer
                       INTO l_mem_buyer
                       FROM sak_memo
                      WHERE mem_id = i_mem_id;

                     IF l_mem_buyer IS NULL
                     THEN
                        l_message := 'ERROR: Buyer must recommend first.';
                     ELSE
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_approver, l_mem_approval_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               --AND meu_signqa = 'Y'
                               AND meu_buyer = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);

                        SELECT COUNT (*)
                          INTO l_signb
                          FROM sak_memo
                         WHERE mem_id = i_mem_id
                               AND mem_status = 'BUYER RECOMMENDED';

                        IF l_signb > 0
                        THEN
                           pkg_adm_cm_dealmemo.prc_create_history (
                              i_status,
                              --'RECOMMENDPD',
                              i_mem_id,
                              l_mem_type,
                              i_user_id,
                              o_mem_status,
                              null,
							  i_metadata_comment);

                           --DBMS_OUTPUT.put_line (3);
                           UPDATE sak_memo
                              SET mem_status = 'METADATA QAFAILED',
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;

                           COMMIT;
                           l_message := 'Memo rejected by the Metadata QA.';
                           o_message := l_message;

                           --Added By Pravin to send an Email once Metadata QA Passed
                           X_PRC_SEND_METADATA_EMAIL(i_mem_id,i_user_id,'METADATA QAFAILED');
                           --Pravin - End
                        --DBMS_OUTPUT.put_line (l_message);
                        ELSE
                           l_message := 'Memo is not recommended by the Buyer';
                           o_message := l_message;
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                             'ERROR: You are not permitted to recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
               END IF;
                IF l_current_status = 'QAPASSED'
               THEN
                  BEGIN
                     pkg_adm_cm_dealmemo.prc_check_cha_runs_rights (i_mem_id);

                     pkg_adm_cm_dealmemo.prc_check_for_sign (i_mem_id,
                                                             o_message);

                     SELECT mem_buyer
                       INTO l_mem_buyer
                       FROM sak_memo
                      WHERE mem_id = i_mem_id;

                     IF l_mem_buyer IS NULL
                     THEN
                        l_message := 'ERROR: Buyer must recommend first.';
                        o_message := l_message;
                     ELSE
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_approver, l_mem_approval_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               AND meu_can_sign = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);

                        SELECT COUNT (*)
                          INTO l_signb
                          FROM sak_memo, fid_company
                         WHERE     com_number = mem_com_number
                               AND mem_id = i_mem_id
                               AND mem_status <> 'QAPASSED'
                               AND com_qa_required = 'Y';

                        IF l_signb = 0
                        THEN
                           pkg_adm_cm_dealmemo.prc_create_history (
                              i_status,
                              --'RECOMMENDPD',
                              i_mem_id,
                              l_mem_type,
                              i_user_id,
                              o_mem_status,
                              null,
                              i_metadata_comment);

                           UPDATE sak_memo
                              SET mem_status = 'METADATA QAFAILED',
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;

                           COMMIT;
                           l_message := 'Memo rejected by the Metadata QA.';
                           o_message := l_message;

                           --Added By Pravin to send an Email once Metadata QA Passed
                           X_PRC_SEND_METADATA_EMAIL(i_mem_id,i_user_id,'METADATA QAFAILED');
                           --Pravin - End
                        --DBMS_OUTPUT.put_line (l_message);
                        ELSE
                           l_message := 'Memo is not passed by the Metadata QA';
                           o_message := l_message;
                        END IF;
                     END IF;
                  --END IF;
                 EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'ERROR: You are not permitted to recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
                End if;

               ---code end rashmi
            ----------------------------------------------------------------------------
            -------------------------Code added by Pranay for Signed QA Start-----------
            ----------------------------------------------------------------------------
            ELSIF i_status = 'QAPASS'
            THEN
               IF l_current_status = 'BUYER RECOMMENDED'
               THEN
                  BEGIN
                     SELECT mem_buyer
                       INTO l_mem_buyer
                       FROM sak_memo
                      WHERE mem_id = i_mem_id;

                     IF l_mem_buyer IS NULL
                     THEN
                        l_message := 'ERROR: Buyer must recommend first.';
                     ELSE
                        SELECT meu_usr_id, SYSDATE
                          INTO l_mem_approver, l_mem_approval_date
                          FROM sak_memo_user
                         WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                               AND meu_signqa = 'Y'
                               AND meu_lee_number IN
                                      (SELECT mem_lee_number
                                         FROM sak_memo
                                        WHERE mem_id = i_mem_id);

                        SELECT COUNT (*)
                          INTO l_signb
                          FROM sak_memo
                         WHERE mem_id = i_mem_id
                               AND mem_status = 'BUYER RECOMMENDED';

                        IF l_signb > 0
                        THEN
                           pkg_adm_cm_dealmemo.prc_create_history (
                              i_status,
                              --'RECOMMENDPD',
                              i_mem_id,
                              l_mem_type,
                              i_user_id,
                              o_mem_status);

                           --DBMS_OUTPUT.put_line (3);
                           UPDATE sak_memo
                              SET mem_status = 'QAPASSED',
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;


                           l_message := 'Memo QA PASSED. Commit complete.';
                           o_message := l_message;
                           X_PRC_SEND_METADATA_EMAIL(i_mem_id,i_user_id,null);
                           COMMIT;
                        --DBMS_OUTPUT.put_line (l_message);
                        ELSE
                           l_message := 'Memo is not recommended by the Buyer';
                           o_message := l_message;
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'ERROR: You are not permitted to pass Sign QA on deal memo.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
               END IF;
            ELSIF i_status = 'QAFAIL' --AND l_current_status = 'PD RECOMMENDED'
            THEN
               IF l_current_status = 'BUYER RECOMMENDED'
               THEN
                  BEGIN
                     -- BEGIN
                     SELECT meu_usr_id
                       INTO l_mem_rejecter
                       FROM sak_memo_user
                      WHERE     UPPER (meu_usr_id) = UPPER (i_user_id)
                            AND meu_signqa = 'Y'
                            AND meu_lee_number IN (SELECT mem_lee_number
                                                     FROM sak_memo
                                                    WHERE mem_id = i_mem_id);

                     SELECT COUNT (*)
                       INTO l_signb
                       FROM sak_memo
                      WHERE mem_id = i_mem_id
                            AND mem_status = 'BUYER RECOMMENDED';

                     IF l_signb > 0
                     THEN
                        pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                                --'RECOMMENDPD',
                                                                i_mem_id,
                                                                l_mem_type,
                                                                i_user_id,
                                                                o_mem_status,
                                                                i_comment);

                        UPDATE sak_memo
                           SET mem_status = 'QAFAILED',
                               mem_approver = l_mem_rejecter,
                               mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                          + 1
                         WHERE mem_id = i_mem_id;

                        COMMIT;
                        l_message := 'Memo  rejected by the QA';
                        o_message := l_message;
                     ELSE
                        l_message :=
                           'Memo can not be Undo-Recommend by the Buyer';
                        o_message := l_message;
                     END IF;
                  -- END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'You are not permitted to reject Sign QA on deal memo.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
               END IF;
            ELSIF i_status = 'UNDO-RECOMMEND' --AND l_current_status = 'PD RECOMMENDED'
            THEN
               IF l_current_status = 'QAPASSED'
               THEN
                  BEGIN
                     -- BEGIN
                     SELECT meu_usr_id
                       INTO l_mem_buyer
                       FROM sak_memo_user
                      WHERE     UPPER (meu_usr_id) = UPPER (i_user_id)
                            AND meu_buyer = 'Y'
                            AND meu_lee_number IN (SELECT mem_lee_number
                                                     FROM sak_memo
                                                    WHERE mem_id = i_mem_id);

                     SELECT COUNT (*)
                       INTO l_signb
                       FROM sak_memo
                      WHERE mem_id = i_mem_id AND mem_status = 'QAPASSED';

                     IF l_signb > 0
                     THEN
                        pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                                --'RECOMMENDPD',
                                                                i_mem_id,
                                                                l_mem_type,
                                                                i_user_id,
                                                                o_mem_status);

                        UPDATE sak_memo
                           SET mem_buyer = NULL,
                               mem_buyer_date = NULL,
                               mem_status = o_mem_status       --'REGISTERED',
                         --mem_update_count = mem_update_count + 1 -- Commented By Omkar
                         WHERE mem_id = i_mem_id;

                        COMMIT;
                        l_message := 'Memo  Undo-Recommended by the Buyer';
                        o_message := l_message;
                     ELSE
                        l_message :=
                           'Memo can not be Undo-Recommended by the Buyer';
                        o_message := l_message;
                     END IF;
                  -- END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'You are not permitted to Undo-Recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
               END IF;

               IF l_current_status = 'PD RECOMMENDED'
               --DBMS_OUTPUT.PUT_LINE('PRANAYK');
               THEN
                  --ELSIF i_status = 'UNSIGNPD'  THEN  --AND l_current_status = 'PD RECOMMENDED'
                  BEGIN
                     --BEGIN
                     SELECT meu_usr_id
                       INTO l_mem_buyer
                       FROM sak_memo_user
                      WHERE     UPPER (meu_usr_id) = UPPER (i_user_id)
                            AND meu_buyer = 'Y'
                            AND meu_lee_number IN (SELECT mem_lee_number
                                                     FROM sak_memo
                                                    WHERE mem_id = i_mem_id);

                     /*EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           l_message :=
                                'You are not permitted to unsign deal memos.';
                           o_message := l_message;
                     END;*/

                     --   DBMS_OUTPUT.put_line (1);
                     SELECT COUNT (*)
                       INTO l_signb
                       FROM sak_memo
                      WHERE mem_id = i_mem_id
                            AND mem_status = 'PD RECOMMENDED';

                     --DBMS_OUTPUT.put_line (1||l_signb);
                     IF l_signb > 0
                     THEN
                        pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                                --'UNDO-RECOMMEND',
                                                                i_mem_id,
                                                                l_mem_type,
                                                                i_user_id,
                                                                o_mem_status);

                         --dbms_output.put_line('rat');
                           UPDATE sak_memo
                              SET mem_status = o_mem_status,
                                  mem_approver = l_mem_approver,
                                  mem_approval_date = SYSDATE --mem_update_count = NVL (mem_update_count, 0) -- Commented By Omkar
                                                             + 1
                            WHERE mem_id = i_mem_id;

                        --         DBMS_OUTPUT.put_line (3);
                        COMMIT;
                        l_message := 'Memo  Undo-Recommended by the Buyer';
                        o_message := l_message;
                     ELSE
                        l_message :=
                           'Memo can not be Undo-Recommended by the Buyer';
                        o_message := l_message;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'You are not permitted to Undo-Recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));--- commented by rashmi
                  END;
                  end if;
              IF l_current_status = 'METADATA QAPASSED'

               THEN
                  BEGIN
                     -- BEGIN
                     SELECT meu_usr_id
                       INTO l_mem_buyer
                       FROM sak_memo_user
                      WHERE     UPPER (meu_usr_id) = UPPER (i_user_id)
                            AND meu_buyer = 'Y'
                            AND meu_lee_number IN (SELECT mem_lee_number
                                                     FROM sak_memo
                                                    WHERE mem_id = i_mem_id);

                     SELECT COUNT (*)
                       INTO l_signb
                       FROM sak_memo
                      WHERE mem_id = i_mem_id AND mem_status = 'METADATA QAPASSED';

                     IF l_signb > 0
                     THEN
                    -- insert into temp_table values('pk');
                     commit;
                        pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                                --'RECOMMENDPD',
                                                                i_mem_id,
                                                                l_mem_type,
                                                                i_user_id,
                                                                o_mem_status);



                         UPDATE sak_memo
                           SET mem_buyer = NULL,
                               mem_buyer_date = NULL,
                               mem_status = o_mem_status       --'REGISTERED',
                         --mem_update_count = mem_update_count + 1 -- Commented By Omkar
                         WHERE mem_id = i_mem_id;

                        COMMIT;
                        l_message := 'Memo  Undo-Recommended by the Buyer';
                        o_message := l_message;
                     ELSE
                        l_message :=
                           'Memo can not be Undo-Recommended by the Buyer';
                        o_message := l_message;
                     END IF;
                  -- END IF;
                EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'You are not permitted to Undo-Recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));--- commented by rashmi
                  END;
               END IF;

               ----------------------------------------------------------------------
               -------------------------Code added by Pranay for Signed QA end--------
               ----------------------------------------------------------------------
               IF l_current_status = 'BUYER RECOMMENDED'
               THEN
                  BEGIN
                     -- BEGIN
                     SELECT meu_usr_id
                       INTO l_mem_buyer
                       FROM sak_memo_user
                      WHERE     UPPER (meu_usr_id) = UPPER (i_user_id)
                            AND meu_buyer = 'Y'
                            AND meu_lee_number IN (SELECT mem_lee_number
                                                     FROM sak_memo
                                                    WHERE mem_id = i_mem_id);

                     SELECT COUNT (*)
                       INTO l_signb
                       FROM sak_memo
                      WHERE mem_id = i_mem_id
                            AND mem_status = 'BUYER RECOMMENDED';

                     IF l_signb > 0
                     THEN
                        pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                                --'RECOMMENDPD',
                                                                i_mem_id,
                                                                l_mem_type,
                                                                i_user_id,
                                                                o_mem_status);

                        UPDATE sak_memo
                           SET mem_buyer = NULL,
                               mem_buyer_date = NULL,
                               mem_status = o_mem_status       --'REGISTERED',
                         --mem_update_count = mem_update_count + 1 -- Commented By Omkar
                         WHERE mem_id = i_mem_id;

                        COMMIT;
                        l_message := 'Memo  Undo-Recommended by the Buyer';
                        o_message := l_message;
                     ELSE
                        l_message :=
                           'Memo can not be Undo-Recommended by the Buyer';
                        o_message := l_message;
                     END IF;
                  -- END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'You are not permitted to Undo-Recommend deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200));
                  END;
               END IF;
            /*            IF l_current_status = 'PD RECOMMENDED'
                         --DBMS_OUTPUT.PUT_LINE('PRANAYK');
                        THEN
                           --ELSIF i_status = 'UNSIGNPD'  THEN  --AND l_current_status = 'PD RECOMMENDED'
                           BEGIN
                              --BEGIN
                              SELECT meu_usr_id
                                INTO l_mem_approver
                                FROM sak_memo_user
                               WHERE UPPER (meu_usr_id) = UPPER (i_user_id)
                                 AND meu_can_sign = 'Y'
                                 AND meu_lee_number IN (SELECT mem_lee_number
                                                          FROM sak_memo
                                                         WHERE mem_id = i_mem_id);

                              /*EXCEPTION
                                 WHEN NO_DATA_FOUND
                                 THEN
                                    l_message :=
                                         'You are not permitted to unsign deal memos.';
                                    o_message := l_message;
                              END;

                              --   DBMS_OUTPUT.put_line (1);
                              SELECT COUNT (*)
                                INTO l_signb
                                FROM sak_memo
                               WHERE mem_id = i_mem_id AND mem_status = 'PD RECOMMENDED';

         --DBMS_OUTPUT.put_line (1||l_signb);
                              IF l_signb > 0
                              THEN
                                 pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                                         --'UNDO-RECOMMEND',
                                                                         i_mem_id,
                                                                         l_mem_type,
                                                                         i_user_id,
                                                                         o_mem_status
                                                                        );

         --DBMS_OUTPUT.put_line (2);
                                 UPDATE sak_memo
                                    SET mem_approver = NULL,
                                        mem_approval_date = NULL,
                                        mem_status = o_mem_status          --'BUYER RECOMMENDED',
                                  --mem_update_count = mem_update_count + 1 -- Commented By Omkar
                                 WHERE  mem_id = i_mem_id;

         DBMS_OUTPUT.put_line (3);
                                 COMMIT;
                                 l_message := 'Memo unsigned. Commit complete.';
                                 o_message := l_message;
                              ELSE
                                 l_message :=
                                    'Memo can not be unsigned by the Program Director';
                                 o_message := l_message;
                              END IF;
                           EXCEPTION
                              WHEN NO_DATA_FOUND
                              THEN
                                 l_message :=
                                         'You are not permitted to unsign deal memos.';
                                 o_message := l_message;
                              WHEN OTHERS
                              THEN
                                 raise_application_error (-20101,
                                                          SUBSTR (SQLERRM, 1, 200)
                                                         );
                           END;
                        END IF; */
            ELSIF i_status = 'UNBUDGET'
            THEN
               BEGIN
                  SELECT COUNT (*)
                    INTO l_lics
                    FROM fid_license
                   WHERE lic_mem_number = i_mem_id;

                  IF l_lics > 0
                  THEN
                     l_message :=
                        'Deal has been executed , cannot mark as un-budgeted';
                     o_message := l_message;
                  END IF;

                  pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                          --'UNBUDGET',
                                                          i_mem_id,
                                                          l_mem_type,
                                                          i_user_id,
                                                          o_mem_status);

                  UPDATE sak_memo
                     SET mem_status = 'REGISTERED'
                   WHERE mem_id = i_mem_id;

                  COMMIT;
                  l_message :=
                     'Memo has been changed to previous status. Commit complete.';
                  o_message := l_message;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20101,
                                              SUBSTR (SQLERRM, 1, 200));
               END;
            ELSIF i_status = 'BUDGET'
            THEN
               BEGIN
                  IF l_current_status = 'REGISTERED'
                  THEN
                     pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                             --'BUDGET',
                                                             i_mem_id,
                                                             l_mem_type,
                                                             i_user_id,
                                                             o_mem_status);

                     UPDATE sak_memo
                        SET mem_status = 'BUDGETED'
                      WHERE mem_id = i_mem_id;

                     COMMIT;
                     l_message := 'Memo in budgeting state. Commit complete.';
                     o_message := l_message;
                  END IF;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20601,
                                              SUBSTR (SQLERRM, 1, 200));
               END;
            ---------------Dev:Non Costed Filler:Start:[Hari Mandal]_[2013/03/20]--------------------
            ---------------when status will change to NCF--------------------------------------------
            ELSIF i_status = 'RECOMMENDNCF'
            THEN
               BEGIN
                  IF l_current_status = 'REGISTERED'
                  THEN
                     IF l_mem_type = 'ROY'
                     THEN
                        raise_application_error (
                           -20389,
                           'Deal Memo type must be FLF for NCF type Deal');
                     END IF;

                     SELECT NVL (SUM (mei_total_price), 0)
                       INTO l_mei_total_price
                       FROM sak_memo_item
                      WHERE mei_mem_id = i_mem_id;

                     IF l_mei_total_price > 0
                     THEN
                        raise_application_error (
                           -20390,
                           'Deal memo total price should be 0 for NCF type Deal ');
                     END IF;

                     SELECT NVL (SUM (ald_amount), 0)
                       INTO l_ald_amount
                       FROM sak_allocation_detail
                      WHERE ald_mei_id IN (SELECT mei_id
                                             FROM sak_memo_item
                                            WHERE mei_mem_id = i_mem_id);

                     IF l_ald_amount > 0
                     THEN
                        raise_application_error (
                           -20391,
                           'Deal memo linear license allocation price should be 0 for NCF type Deal ');
                     END IF;

                     SELECT NVL (SUM (dsl_amount), 0)
                       INTO l_dsl_amount
                       FROM x_fin_dm_sec_lee
                      WHERE dsl_mei_id IN (SELECT mei_id
                                             FROM sak_memo_item
                                            WHERE mei_mem_id = i_mem_id)
                            AND dsl_is_primary <> 'Y';

                     IF l_dsl_amount > 0
                     THEN
                        raise_application_error (
                           -20392,
                           'Deal memo secondary license allocation price should be 0 for NCF type Deal ');
                     END IF;

                     pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                             i_mem_id,
                                                             l_mem_type,
                                                             i_user_id,
                                                             o_mem_status);

                     UPDATE sak_memo
                        SET mem_status = o_mem_status
                      WHERE mem_id = i_mem_id;

                     COMMIT;
                     l_message := 'Memo in NCF state. Commit complete.';
                     o_message := l_message;
                  END IF;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20601,
                                              SUBSTR (SQLERRM, 1, 200));
               END;
            -----------------when status will change from NCF to Registered---------------------------------
            ELSIF i_status = 'UNNCF'
            THEN
               BEGIN
                  IF l_current_status = 'NCF'
                  THEN
                     pkg_adm_cm_dealmemo.prc_create_history (i_status,
                                                             i_mem_id,
                                                             l_mem_type,
                                                             i_user_id,
                                                             o_mem_status);

                     UPDATE sak_memo
                        SET mem_status = o_mem_status
                      WHERE mem_id = i_mem_id;

                     COMMIT;
                     l_message :=
                        'Memo has been changed to previous status. Commit complete.';
                     o_message := l_message;
                  END IF;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20601,
                                              SUBSTR (SQLERRM, 1, 200));
               END;
            ----------------Dev:Non Costed Filler :End-----------------------------------------------------
            END IF;
         END;
      ELSE
         l_message := 'Select a deal memo first';
         o_message := l_message;
      END IF;
   END prc_change_dm_status;

   /*PROCEDURE prc_approve_memo_buyer (
      i_mem_id    IN   sak_memo.mem_id%TYPE,
      i_user_id   IN   NUMBER
   )
   AS
      l_mem_buyer         NUMBER;
      l_mem_buyer_date    DATE;
      l_message           VARCHAR2 (250);
      o_mem_status        VARCHAR2 (20);
      o_mem_status_date   DATE;
   BEGIN
      pkg_adm_cm_dealmemo.prc_check_for_sign (i_mem_id);

      BEGIN
         SELECT meu_usr_id, SYSDATE
           INTO l_mem_buyer, l_mem_buyer_date
           FROM sak_memo_user
          WHERE meu_usr_id = i_user_id
            AND meu_buyer = 'Y'
            AND meu_lee_number IN (SELECT mem_lee_number
                                     FROM sak_memo
                                    WHERE mem_id = i_mem_id);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_message := 'ERROR: You are not permitted to sign deal memos.';
            raise_application_error (-20228, l_message);
      END;

      pkg_adm_cm_dealmemo.prc_create_history ('RECOMMENDB',
                                              i_mem_id,
                                              i_user_id,
                                              o_mem_status,
                                              o_mem_status_date
                                             );
      -- update sak_memo set mem_status='' where mem_id=i_mem_id;
      l_message := 'Memo signed. Commit complete.';
   END prc_approve_memo_buyer;
*/

   -------------------------------------------- PROCEDURE FOR ALERT PAYMENTS ----------------------------------------------------
   PROCEDURE alert_payments (
      i_mem_id         IN     sak_memo.mem_id%TYPE,
      i_mem_type       IN     sak_memo.mem_type%TYPE,
      i_mem_currency   IN     sak_memo.mem_currency%TYPE,
      o_message           OUT VARCHAR2)
   IS
      tot_pct         NUMBER;
      paydifference   NUMBER;
   BEGIN
      IF i_mem_type IN ('FLF', 'CHC')
      THEN
         paydifference := fid_deal_mem_pk.check_payment (i_mem_id);

         IF paydifference > 0
         THEN
            o_message :=
                  'WARNING: Payments are '
               || TO_CHAR (ABS (paydifference))
               || ' '
               || i_mem_currency
               || ' greater than Deal Memo value.';
         ELSIF paydifference < 0
         THEN
            o_message :=
                  'WARNING: Payments are '
               || TO_CHAR (ABS (paydifference))
               || ' '
               || i_mem_currency
               || ' less than the Deal Memo value.';
         END IF;

         IF paydifference <> 0
         THEN
            o_message :=
               'The Fee Payments do not add up to the Flat-Fee Costs on page 1.Do you want to correct them ';
         END IF;
      ELSIF i_mem_type = 'ROY'
      THEN
         SELECT SUM (mpy_pct_pay)
           INTO tot_pct
           FROM sak_memo_payment
          WHERE mpy_mem_id = i_mem_id;

         IF tot_pct != 100
         THEN
            o_message :=
               'The Payment percentages do not add up to 100%. Do you want to correct them?';
         END IF;
      ELSIF i_mem_type = 'CPD'
      THEN
         paydifference := fid_deal_mem_pk.check_payment (i_mem_id);

         IF paydifference > 0
         THEN
            o_message :=
                  'WARNING: Payments are '
               || TO_CHAR (ABS (paydifference))
               || ' '
               || i_mem_currency
               || ' greater than Deal Memo value.';
         ELSIF paydifference < 0
         THEN
            o_message :=
                  'WARNING: Payments are '
               || TO_CHAR (ABS (paydifference))
               || ' '
               || i_mem_currency
               || ' less than the Deal Memo value.';
         END IF;

         IF paydifference <> 0
         THEN
            o_message :=
               'The Fee Payments do not add up to the Flat-Fee Costs on page 1.Do you want to correct them ';
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END;

   ------------------------------------------------ PROCEDURE TO CHECK USER AUTHENTICATION ----------------------------------------------------
   PROCEDURE prc_check_user_auth (i_user_id   IN     VARCHAR2,
                                  o_flag         OUT NUMBER,
                                  o_message      OUT VARCHAR2)
   AS
      l_flag   NUMBER := 0;
   BEGIN
      BEGIN
         SELECT COUNT (meu_usr_id)
           INTO l_flag
           FROM sak_memo_user
          WHERE UPPER (meu_usr_id) = UPPER (i_user_id);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_flag := 0;
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      IF (l_flag = 0)
      THEN
         o_flag := 0;
         o_message := 'You are not a registered DEAL MEMO user';
      ELSE
         o_flag := 1;
         o_message := NULL;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END;

   -------------------------------------------- PROCEDURE TO CHECK USER AUTHENTICATION FOR UPDATE ----------------------------------------------
   PROCEDURE prc_check_user_auth_for_update (i_mem_id    IN     NUMBER,
                                             i_user_id   IN     VARCHAR2,
                                             o_flag         OUT NUMBER,
                                             o_message      OUT VARCHAR2)
   AS
      can_update         VARCHAR2 (1);
      l_mem_lee_number   NUMBER;
      l_flag             NUMBER := 0;
   BEGIN
      BEGIN
         SELECT COUNT (meu_usr_id)
           INTO l_flag
           FROM sak_memo_user
          WHERE UPPER (meu_usr_id) = UPPER (i_user_id);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            o_flag := 0;
            o_message := 'You are not a registered DEAL MEMO user.';
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      IF (NVL (l_flag, 0) <> 0)
      THEN
         BEGIN
            SELECT mem_lee_number
              INTO l_mem_lee_number
              FROM sak_memo
             WHERE mem_id = i_mem_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               o_flag := 0;
               o_message := 'No Licensee exist for Deal Memo.';
         END;

         BEGIN
            SELECT meu_can_update
              INTO can_update
              FROM sak_memo_user
             WHERE meu_lee_number = l_mem_lee_number
                   AND UPPER (meu_usr_id) = UPPER (i_user_id);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               o_flag := 0;
               o_message :=
                  'You are not allowed to update Deal Memos for this Licensee.';
         END;

         IF can_update != 'Y'
         THEN
            o_flag := 0;
            o_message :=
               'You are not allowed to update Deal Memos for this Licensee.';
         END IF;
      ELSE
         o_flag := 0;
         o_message := 'You are not a registered DEAL MEMO user.';
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END;

   ---------------------
   /* CACQ3 Catchup :Pranay Kusumwal 18/10/2012 : Deal memo validations :Start*/
   PROCEDURE prc_check_catchup_validation (i_mem_id IN sak_memo.mem_id%TYPE)
   AS
      l_mem_con_number               sak_memo.mem_con_number%TYPE;
      l_mem_type                     sak_memo.mem_type%TYPE;
      l_sch_after_prem_linr_fea      fid_contract.con_sch_after_prem_linr_fea%TYPE;
      l_sch_after_prem_linr_ser      fid_contract.con_sch_after_prem_linr_ser%TYPE;
      l_not_allow_aft_x_start_lic    fid_contract.con_not_allow_aft_x_start_lic%TYPE;
      l_not_allow_bef_x_end_lic_dt   fid_contract.con_not_allow_bef_x_end_lic_dt%TYPE;
      l_sch_within_x_frm_ply_fea     fid_contract.con_sch_within_x_frm_ply_fea%TYPE;
      l_sch_within_x_frm_ply_ser     fid_contract.con_sch_within_x_frm_ply_ser%TYPE;
      l_ald_period_tba               sak_allocation_detail.ald_period_tba%TYPE;
      l_ald_period_start             sak_allocation_detail.ald_period_start%TYPE;
      l_ald_period_end               sak_allocation_detail.ald_period_end%TYPE;
      l_linear_allc_cnt              NUMBER;
      l_linear_lic_cnt               NUMBER;
      l_lee_region_cnt               NUMBER;
      l_is_lic_present               NUMBER;
      l_is_ser                       NUMBER;
      l_con_name                     VARCHAR2 (20);
      l_is_linear_present            NUMBER;
      l_is_linear_lee_present        NUMBER;
      l_is_linear_other_deal         NUMBER;
      L_SVOD_IS_PLT                  NUMBER;
      L_IS_SVOD                      NUMBER;
      --CU4ALL START
      L_CON_SCH_LIN_SER_CHA VARCHAR2(1);
      L_CON_SCH_AFT_PREM_LINR_SER_BO  NUMBER;
      L_CBM_CON_BOUQ_RIGHTS NUMBER;
      l_ser_title     VARCHAR2(500);
      L_MEM_CON_NUMBER1      NUMBER;
      l_buq_active           VARCHAR2(1);
      l_buq_prem_linr        varchar2(1);
      l_buq_rank        number;
      --CU4ALL END
   BEGIN

           /* CU4ALL START */

    /*  SELECT CON_SCH_LIN_SER_CHA,CON_SCH_AFT_PREM_LINR_SER_BOUQ,CBM_CON_BOUQ_RIGHTS
      INTO L_CON_SCH_LIN_SER_CHA,L_CON_SCH_AFT_PREM_LINR_SER_BO,L_CBM_CON_BOUQ_RIGHTS
        FROM FID_CONTRACT,SAK_MEMO,X_CON_BOUQUE_MAPP
        WHERE CON_NUMBER=MEM_CON_NUMBER
        AND MEM_CON_NUMBER=i_mem_id
        AND CBM_BOUQUE_ID =(SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_RANK=1);

        IF  (L_CON_SCH_LIN_SER_CHA IS NOT NULL AND L_CON_SCH_AFT_PREM_LINR_SER_BO IS NOT NULL AND L_CBM_CON_BOUQ_RIGHTS IS NOT NULL) THEN
        for i in (SELECT LIC_NUMBER,LIC_MAX_VIEWING_PERIOD FROM FID_LICENSE WHERE LIC_MEM_NUMBER=i_mem_id )
        loop
          IF i.LIC_MAX_VIEWING_PERIOD >= 2 THEN
              SELECT SER_TITLE into l_ser_title FROM FID_SERIES WHERE SER_NUMBER=(SELECT GEN_SER_NUMBER FROM FID_GENERAL WHERE GEN_REFNO=(SELECT LIC_GEN_REFNO FROM FID_LICENSE WHERE LIC_NUMBER=i.LIC_NUMBER));
              raise_application_error(-20601,'Viewing period cannot be more than 2 for the '||l_ser_title);
          END IF;
        END loop;
        END IF;

      SELECT CON_SCH_LIN_SER_CHA,CON_SCH_AFT_PREM_LINR_SER_BOUQ,CBM_CON_BOUQ_RIGHTS
      INTO L_CON_SCH_LIN_SER_CHA,L_CON_SCH_AFT_PREM_LINR_SER_BO,L_CBM_CON_BOUQ_RIGHTS
        FROM FID_CONTRACT,SAK_MEMO,X_CON_BOUQUE_MAPP
        WHERE CON_NUMBER=MEM_CON_NUMBER
        AND MEM_CON_NUMBER=i_mem_id
        AND CBM_BOUQUE_ID =(SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_RANK=1);

        IF  (L_CON_SCH_LIN_SER_CHA IS NOT NULL AND L_CON_SCH_AFT_PREM_LINR_SER_BO IS NOT NULL AND L_CBM_CON_BOUQ_RIGHTS IS NOT NULL) THEN
        for i in (SELECT LIC_NUMBER,LIC_MAX_VIEWING_PERIOD FROM FID_LICENSE WHERE LIC_MEM_NUMBER=i_mem_id )
        loop
          IF i.LIC_MAX_VIEWING_PERIOD >= 2 THEN
              SELECT SER_TITLE into l_ser_title FROM FID_SERIES WHERE SER_NUMBER=(SELECT GEN_SER_NUMBER FROM FID_GENERAL WHERE GEN_REFNO=(SELECT LIC_GEN_REFNO FROM FID_LICENSE WHERE LIC_NUMBER=i.LIC_NUMBER));
              raise_application_error(-20601,'Viewing period cannot be more than 1 for the '||l_ser_title);
          END IF;
        END loop;
        END IF;
     */
      /* CU4ALL END */



      BEGIN
         SELECT NVL (mem_con_number, 9999999), mem_type
           INTO l_mem_con_number, l_mem_type
           FROM sak_allocation_detail,
                sak_memo_item,
                sak_memo,
                fid_licensee
          WHERE     ald_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND lee_number = ald_lee_number
                AND mei_mem_id = i_mem_id
                AND NVL (lee_media_service_code, '#') = 'CATCHUP'
                AND ROWNUM < 2;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_mem_con_number := -1;
      END;

      IF l_mem_con_number <> -1
      THEN
         BEGIN
            SELECT NVL (con_sch_after_prem_linr_fea, 'N'),
                   NVL (con_sch_after_prem_linr_ser, 'N'),
                   NVL (con_not_allow_aft_x_start_lic, 0),
                   NVL (con_not_allow_bef_x_end_lic_dt, 0),
                   NVL (con_sch_within_x_frm_ply_fea, 0),
                   NVL (con_sch_within_x_frm_ply_ser, 0)
              INTO l_sch_after_prem_linr_fea,
                   l_sch_after_prem_linr_ser,
                   l_not_allow_aft_x_start_lic,
                   l_not_allow_bef_x_end_lic_dt,
                   l_sch_within_x_frm_ply_fea,
                   l_sch_within_x_frm_ply_ser
              FROM fid_contract
             WHERE con_number = l_mem_con_number;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_sch_after_prem_linr_fea := 'N';
               l_sch_after_prem_linr_ser := 'N';
               l_not_allow_aft_x_start_lic := 0;
               l_not_allow_bef_x_end_lic_dt := 0;
               l_sch_within_x_frm_ply_fea := 0;
               l_sch_within_x_frm_ply_ser := 0;
         END;

         ----The below code checks if in catchup licensee grid more than one licensee for a single region is enetered
         ---although this is a hypothetical case as the LOV will take care of this validation
         BEGIN
              SELECT COUNT (*)
                INTO l_lee_region_cnt
                FROM sak_allocation_detail, sak_memo_item, fid_licensee
               WHERE     ald_mei_id = mei_id
                     AND ald_lee_number = lee_number
                     AND mei_mem_id = i_mem_id
                     AND NVL (lee_media_service_code, '#') = 'CATCHUP'
            GROUP BY ald_mei_id, mei_gen_refno, lee_region_id
              HAVING COUNT (*) > 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_lee_region_cnt := 0;
         END;

         IF l_lee_region_cnt > 0
         THEN
            raise_application_error (
               -20321,
               'Only a single catchup licensee is allowed for each region in Catchup Licensee allocation grid');
         END IF;

         FOR i
            IN (SELECT ald_cost_runs,
                       ald_amount,
                       ald_exhib_days,
                       ald_max_vp,
                       mei_type_show mei_type,
                       lee_short_name,
                       NVL ( (SELECT gen_title
                                FROM fid_general
                               WHERE gen_refno = mei_gen_refno),
                            (SELECT ser_title
                               FROM fid_series
                              WHERE ser_number = mei_gen_refno))
                          gen_title,
                       (SELECT COUNT (*)
                          FROM x_cp_memo_medplatdevcompat_map
                         WHERE MEM_MPDC_ALD_ID = ald_id
                               AND mem_rights_on_device <> 'N')
                          lee_plt_right_cnt
                  /*x_cp_licensee_platform
                 WHERE cp_lee_plat_ald_id = ald_id)*/

                  FROM sak_allocation_detail, sak_memo_item, fid_licensee
                 WHERE     ald_mei_id = mei_id
                       AND lee_number = ald_lee_number
                       AND mei_mem_id = i_mem_id
                       AND NVL (lee_media_service_code, '#') = 'CATCHUP')
         LOOP

         -- CU4AALL START
--         SELECT MEM_CON_NUMBER INTO L_MEM_CON_NUMBER1 FROM SAK_MEMO WHERE MEM_ID=i_mem_id;
--         IF L_MEM_CON_NUMBER1 IS NULL THEN
--          L_CON_SCH_LIN_SER_CHA :='';
--          L_CON_SCH_AFT_PREM_LINR_SER_BO :='';
--          L_CBM_CON_BOUQ_RIGHTS:='';
--         ELSE
--         BEGIN
--            SELECT CON_SCH_LIN_SER_CHA,CON_SCH_AFT_PREM_LINR_SER_BOUQ,CBM_CON_BOUQ_RIGHTS
--                INTO L_CON_SCH_LIN_SER_CHA,L_CON_SCH_AFT_PREM_LINR_SER_BO,L_CBM_CON_BOUQ_RIGHTS
--                  FROM FID_CONTRACT,SAK_MEMO,X_CON_BOUQUE_MAPP
--                  WHERE CON_NUMBER=MEM_CON_NUMBER
--                 -- AND MEM_CON_NUMBER=i_mem_id
--                 AND MEM_ID=i_mem_id
--                  AND CBM_BOUQUE_ID =(SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_RANK=1);
--                  EXCEPTION WHEN OTHERS THEN
--                   L_CON_SCH_LIN_SER_CHA :='';
--                  L_CON_SCH_AFT_PREM_LINR_SER_BO :='';
--                  L_CBM_CON_BOUQ_RIGHTS:='';
--                  END;
--         END IF;
         --CU4ALL END


            IF i.ald_exhib_days < 1
            THEN
               raise_application_error (
                  -20321,
                  'In the Catch-up Licensee Allocation, Max No. of Viewing Period should be greater than 0 for the Lee - '
                  || i.lee_short_name
                  || ' of Title - '
                  || REPLACE (i.gen_title, ':', '-'));
            END IF;

            IF l_mem_type = 'ROY'
            THEN
               IF i.ald_amount > 0
               THEN
                  raise_application_error (
                     -20321,
                     'For ROY deal catch-up allocation should be zero for Lee - '
                     || i.lee_short_name
                     || ' of Title - '
                     || REPLACE (i.gen_title, ':', '-'));
                /* COMMENTED BY MILAN FOR Cu4ALL
                 ELSE
                  IF (i.mei_type = 'SER' AND l_sch_after_prem_linr_ser = 'Y')
                     OR (i.mei_type <> 'SER'
                         AND l_sch_after_prem_linr_fea = 'Y')
                  THEN
                     IF i.ald_exhib_days <> 1
                     THEN
                        raise_application_error (
                           -20321,
                           'In the Catch-up Allocation, Max No. of Viewing Period should be 1 for Lee - '
                           || i.lee_short_name
                           || ' of Title - '
                           || REPLACE (i.gen_title, ':', '-'));
                     END IF;

                     IF i.ald_cost_runs NOT IN (0, 1)
                     THEN
                        raise_application_error (
                           -20321,
                           'In the Catch-up Allocation, Costed Viewing Period should be 0 or 1 for Lee - '
                           || i.lee_short_name
                           || ' of Title - '
                           || REPLACE (i.gen_title, ':', '-'));
                     END IF;
                  END IF;
               END IF;
            ELSE
               IF (i.mei_type = 'SER' AND l_sch_after_prem_linr_ser = 'Y')
                  OR (i.mei_type <> 'SER' AND l_sch_after_prem_linr_fea = 'Y')
               THEN
                  IF i.ald_exhib_days <> 1
                  THEN
                     raise_application_error (
                        -20321,
                        'In the Catch-up Allocation, Max No. of Viewing Period should be 1 for Lee - '
                        || i.lee_short_name
                        || ' of Title - '
                        || REPLACE (i.gen_title, ':', '-'));
                  END IF;

                  IF i.ald_cost_runs = 0 AND i.ald_amount > 0
                  THEN
                     raise_application_error (
                        -20321,
                        'In the Catch-up Allocation, Costed Viewing Period should be greater than 0 for Lee - '
                        || i.lee_short_name
                        || ' of Title - '
                        || REPLACE (i.gen_title, ':', '-'));
                  END IF;*/
               END IF;
            END IF;


               --Added by Milan Shah for CU4ALL. Viewing period validation
             IF((x_fnc_get_prog_type(i.mei_type)) = 'Y') --viewing period validation for series title
                THEN
                  BEGIN
                      select cb_ad_flag,con_sch_after_prem_linr_ser,cb_rank
                        INTO l_buq_active,l_buq_prem_linr,l_buq_rank
                      from  fid_contract
                            ,x_cp_bouquet
                      where  con_number = l_mem_con_number
                            AND con_sch_aft_prem_linr_ser_bouq = cb_id;

                      EXCEPTION WHEN NO_DATA_FOUND  THEN
                          l_buq_active:='D';
                          l_buq_prem_linr :='N';
                          l_buq_rank:=0;
                   END;
                   IF l_buq_rank = 1 AND l_buq_active = 'A' AND l_buq_prem_linr = 'Y'
                   THEN
                      IF i.ald_exhib_days > 2
                      THEN
                          raise_application_error (-20321,'Viewing period cannot be more than 2 for the Lee - '||i.lee_short_name||' of Title -'||i.gen_title||'');
                      END IF;
                   ELSIF l_buq_rank != 1 AND l_buq_active = 'A' AND l_buq_prem_linr = 'Y'
                   THEN
                        IF i.ald_exhib_days > 1
                        THEN
                         raise_application_error (-20321,'Viewing period cannot be more than 1 for the Lee - '||i.lee_short_name||' of Title -'||i.gen_title||'');
                        END IF;
                   ELSIF (l_buq_prem_linr = 'Y') AND (l_buq_rank = 0 OR l_buq_rank is null)
                   THEN
                        IF i.ald_exhib_days > 1
                        THEN
                         raise_application_error (-20321,'Viewing period cannot be more than 1 for the Lee - '||i.lee_short_name||' of Title -'||i.gen_title||'');
                        END IF;
                   END IF;
                ELSE        --viewing period validation for feature title
                      IF l_sch_after_prem_linr_fea ='Y'
                      THEN
                          IF i.ald_exhib_days > 1
                          THEN
                            raise_application_error (-20995,'Viewing period cannot be more than 1 for the Lee - '||i.lee_short_name||' of Title -'||i.gen_title||'');
                                            --for the Lee-'|| i.lee_short_name || ' of Title - '|| REPLACE (i.gen_title, ':', '-'));
                          END IF;
                      END IF;
                END IF;

            --end by Milan Shah


            IF i.ald_exhib_days < i.ald_cost_runs
            THEN
               raise_application_error (
                  -20321,
                  'In the Catch-up Allocation, Costed Viewing Period should be less than or equal to Max No. of Viewing Period for the Lee - '
                  || i.lee_short_name
                  || ' of Title - '
                  || REPLACE (i.gen_title, ':', '-'));
            END IF;

            IF (i.mei_type = 'SER'
                AND l_sch_within_x_frm_ply_ser > i.ald_max_vp)
               OR (i.mei_type <> 'SER'
                   AND l_sch_within_x_frm_ply_fea > i.ald_max_vp)
            THEN
               raise_application_error (
                  -20321,
                  'Max Viewing Days should be greater than sch within X days from the playout on linear for the Lee - '
                  || i.lee_short_name
                  || ' of Title - '
                  || REPLACE (i.gen_title, ':', '-'));
            END IF;

            IF i.lee_plt_right_cnt < 1
            THEN
               raise_application_error (
                  -20321,
                  'In the Catch-up Licensee Allocation, atleast one platform is required for the Lee - '
                  || i.lee_short_name
                  || ' of Title - '
                  || REPLACE (i.gen_title, ':', '-'));
            END IF;
         END LOOP;

         FOR j
            IN (SELECT ald_period_tba,
                       mei_id,
                       ald_period_start,
                       ald_period_end,
                       lee_short_name,
                       lee_region_id,
                       mei_gen_refno,
                       ald_max_vp,
                       ALD_ALLOW_WITHOUT_LNR_REF,
                       NVL ( (SELECT gen_title
                                FROM fid_general
                               WHERE gen_refno = mei_gen_refno),
                            (SELECT ser_title
                               FROM fid_series
                              WHERE ser_number = mei_gen_refno))
                          gen_title,
                       mei_type_show
                  FROM sak_allocation_detail, sak_memo_item, fid_licensee
                 WHERE     ald_mei_id = mei_id
                       AND lee_number = ald_lee_number
                       AND mei_mem_id = i_mem_id
                       AND NVL (lee_media_service_code, '#') = 'CATCHUP')
         LOOP
            BEGIN
               SELECT ald_period_tba, ald_period_start, ald_period_end
                 INTO l_ald_period_tba, l_ald_period_start, l_ald_period_end
                 FROM (  SELECT ald_period_tba,
                                ald_period_start,
                                ald_period_end
                           FROM sak_allocation_detail,
                                sak_memo_item,
                                fid_licensee
                          WHERE     ald_mei_id = mei_id
                                AND lee_number = ald_lee_number
                                AND mei_mem_id = i_mem_id
                                AND mei_id = j.mei_id
                                AND (lee_region_id = j.lee_region_id
                                     OR lee_region_both_flag LIKE 'Y')
                                AND lee_number <> 319
                                AND NVL (lee_media_service_code, '#') <>
                                       'CATCHUP'
                       ORDER BY ald_period_start)
                WHERE ROWNUM < 2;

               l_linear_allc_cnt := 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_linear_allc_cnt := 0;
            END;

            /* CACQ3 Catchup :Pranay Kusumwal 30/10/2012 : Validation User would not able to create license for the same Licensee and title under same contract.*/
            BEGIN
               SELECT COUNT (lic_number)
                 INTO l_is_lic_present
                 FROM fid_license
                WHERE lic_con_number = l_mem_con_number
                      AND lic_gen_refno = j.mei_gen_refno
                      AND lic_lee_number =
                             (SELECT lee_number
                                FROM fid_licensee
                               WHERE lee_short_name = j.lee_short_name)
                      AND NVL (lic_catchup_flag, 'N') = 'Y'
                      AND lic_mem_number <> i_mem_id
                      --Check date also to fall
                      AND (j.ald_period_start BETWEEN lic_start AND lic_end
                           OR j.ald_period_end BETWEEN lic_start AND lic_end);

               SELECT con_short_name
                 INTO l_con_name
                 FROM fid_contract
                WHERE con_number = l_mem_con_number;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_con_name := NULL;
            END;

            IF l_is_lic_present > 0
            THEN
               raise_application_error (
                  -20321,
                     'A catchup license for the same Lee - '
                  || j.lee_short_name
                  || ' , title - '
                  || REPLACE (j.gen_title, ':', '-')
                  || ' and Contract - '
                  || l_con_name
                  || ' is already present.');
            END IF;


            SELECT COUNT (*)
              INTO l_is_linear_lee_present
              FROM sak_allocation_detail, sak_memo_item, fid_licensee
             WHERE     mei_id = j.mei_id
                   AND mei_id = ald_mei_id
                   AND lee_number = ald_lee_number
                   AND mei_mem_id = i_mem_id
                   AND NVL (lee_media_service_code, '#') <> 'CATCHUP';



            /* CACQ3 Catchup :Pranay Kusumwal 30/10/2012 : Validation End */
            IF l_is_linear_lee_present > 0
            THEN
               IF l_linear_allc_cnt = 0 AND l_mem_con_number = 9999999
               THEN
                  raise_application_error (
                     -20321,
                     'Could not find a linear licensee in the allocation grid of the same region for Lee - '
                     || j.lee_short_name);
               ELSIF l_linear_allc_cnt = 0 AND l_mem_con_number <> 9999999
               THEN
                  BEGIN
                     l_is_ser := 0;

                     SELECT COUNT (*)
                       INTO l_is_ser
                       FROM fid_code
                      WHERE     cod_type = 'GEN_TYPE'
                            AND cod_attr1 = 'Y'
                            AND cod_value = j.mei_type_show;

                     IF l_is_ser <> 0
                     THEN
                        SELECT lic_start, lic_end, lic_period_tba
                          INTO l_ald_period_start,
                               l_ald_period_end,
                               l_ald_period_tba
                          FROM (  SELECT lic_start, lic_end, lic_period_tba
                                    FROM fid_license, fid_licensee
                                   WHERE lic_lee_number = lee_number
                                         AND lic_con_number = l_mem_con_number
                                         AND lic_gen_refno IN
                                                (SELECT gen_refno
                                                   FROM fid_general
                                                  WHERE gen_ser_number =
                                                           j.mei_gen_refno)
                                         AND lic_status IN ('A', 'T')
                                         AND (lee_region_id = j.lee_region_id
                                              OR lee_region_both_flag LIKE 'Y')
                                         AND NVL (lic_catchup_flag, 'N') <> 'Y'
                                         AND lic_lee_number <> 319
                                         AND lee_media_service_code = 'PAYTV'
                                ORDER BY lic_start)
                         WHERE ROWNUM < 2;

                        l_linear_lic_cnt := 1;
                     ELSE
                        SELECT lic_start, lic_end, lic_period_tba
                          INTO l_ald_period_start,
                               l_ald_period_end,
                               l_ald_period_tba
                          FROM (  SELECT lic_start, lic_end, lic_period_tba
                                    FROM fid_license, fid_licensee
                                   WHERE     lic_lee_number = lee_number
                                         AND lic_con_number = l_mem_con_number
                                         AND lic_gen_refno = j.mei_gen_refno
                                         AND lic_status IN ('A', 'T')
                                         AND (lee_region_id = j.lee_region_id
                                              OR lee_region_both_flag LIKE 'Y')
                                         AND NVL (lic_catchup_flag, 'N') <> 'Y'
                                         AND lic_lee_number <> 319
                                         AND lee_media_service_code = 'PAYTV'
                                ORDER BY lic_start)
                         WHERE ROWNUM < 2;

                        l_linear_lic_cnt := 1;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_linear_lic_cnt := 0;
                  END;



                  IF l_linear_lic_cnt = 0
                  THEN
                     raise_application_error (
                        -20321,
                        'Could not find a linear license of the same region for Lee - '
                        || j.lee_short_name
                        || ' of Title '
                        || REPLACE (j.gen_title, ':', '-'));
                  END IF;
               END IF;
            ELSE
               SELECT COUNT (*)
                 INTO l_is_linear_other_deal
                 FROM sak_allocation_detail, sak_memo_item, fid_licensee
                WHERE     ald_mei_id = mei_id
                      AND mei_gen_refno = j.mei_gen_refno
                      AND lee_number = ald_lee_number
                      AND mei_mem_id IN
                             (SELECT mem_id
                                FROM sak_memo
                               WHERE mem_con_number = l_mem_con_number)
                      AND NVL (lee_media_service_code, '#') <> 'CATCHUP';

               IF l_is_linear_other_deal = 0
               THEN
                  SELECT COUNT (*)
                    INTO l_is_linear_present
                    FROM sak_allocation_detail, sak_memo_item, fid_licensee
                   WHERE     ald_mei_id = mei_id
                         AND lee_number = ald_lee_number
                         AND mei_mem_id = i_mem_id
                         AND NVL (lee_media_service_code, '#') = 'CATCHUP'
                         AND NVL (ALD_ALLOW_WITHOUT_LNR_REF, 'N') = 'N';

                  IF l_is_linear_present > 0
                  THEN
                     raise_application_error (
                        -20321,
                        'The Allow without Linear reference tick box in not ticked for  - '
                        || j.lee_short_name
                        || ' of Title '
                        || REPLACE (j.gen_title, ':', '-'));
                  END IF;
               END IF;
            END IF;

            IF l_linear_allc_cnt > 0 OR l_linear_lic_cnt > 0
            THEN
               --    if    j.ald_period_tba <> l_ald_period_tba
               IF l_ald_period_tba = 'Y' AND j.ald_period_tba = 'N'
               THEN
                  raise_application_error (
                     -20321,
                     'For a TBA linear license the corresponding cathup license of Lee '
                     || j.lee_short_name
                     || ' and Title '
                     || REPLACE (j.gen_title, ':', '-')
                     || ' should also be TBA.');
               END IF;

               IF (l_ald_period_start + l_not_allow_aft_x_start_lic) >
                     j.ald_period_start
                  AND NVL (j.ALD_ALLOW_WITHOUT_LNR_REF, 'N') <> 'Y'
               THEN
                  raise_application_error (
                     -20321,
                        'The Start/End date of Catch Up License of Lee '
                     || j.lee_short_name
                     || ' and Title '
                     || REPLACE (j.gen_title, ':', '-')
                     || '  should fall within the Linear Start/End date');
               END IF;

               IF (l_ald_period_end - l_not_allow_bef_x_end_lic_dt) <
                     j.ald_period_end
                  AND NVL (j.ALD_ALLOW_WITHOUT_LNR_REF, 'N') <> 'Y'
               THEN
                  raise_application_error (
                     -20321,
                        'The Start/End date of Catch Up License of Lee '
                     || j.lee_short_name
                     || ' and Title '
                     || REPLACE (j.gen_title, ':', '-')
                     || ' should fall within the Linear Start/End date');
               END IF;

               IF (j.ald_period_end - j.ald_period_start) + 1 < j.ald_max_vp
               THEN
                  raise_application_error (
                     -20321,
                     'The diffrence of Catch Up License start and end date of Lee '
                     || j.lee_short_name
                     || ' and Title '
                     || REPLACE (j.gen_title, ':', '-')
                     || ' should be greater than Max Viewing Days');
               END IF;
            END IF;
         END LOOP;
      ELSE                         --- introduced the else part for SVOD DEALS
         SELECT COUNT (*)
           INTO l_is_svod
           FROM sak_allocation_detail,
                sak_memo_item,
                sak_memo,
                fid_licensee
          WHERE     ald_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND lee_number = ald_lee_number
                AND mei_mem_id = i_mem_id
                AND NVL (lee_media_service_code, '#') = 'SVOD'
                AND ROWNUM < 2;

         IF L_IS_SVOD > 0
         THEN
            SELECT COUNT (*)
              INTO L_SVOD_IS_PLT
              FROM x_cp_memo_medplatdevcompat_map,
                   sak_allocation_detail,
                   sak_memo_item,
                   FID_LICENSEE
             WHERE     MEM_MPDC_ALD_ID = ald_id
                   AND mem_rights_on_device <> 'N'
                   AND lee_number = ald_lee_number
                   AND ald_mei_id = mei_id
                   AND mei_mem_id = i_mem_id
                   AND NVL (lee_media_service_code, '#') = 'SVOD';

            IF L_SVOD_IS_PLT < 1
            THEN
               raise_application_error (
                  -20321,
                  'In the Media Service Licensee Allocation, atleast one platform is required for SVOD deals');
            END IF;
         END IF;
      END IF;
   END prc_check_catchup_validation;

   ------------------------------------------------ PROCEDURE TO CHECK USER INSERT RIGHTS ----------------------------------------------------
   PROCEDURE prc_check_user_insertrights (i_user_id   IN     VARCHAR2,
                                          o_flag         OUT NUMBER)
   AS
      l_flag     NUMBER := 0;
      norights   EXCEPTION;
   BEGIN
      o_flag := 1;

      SELECT COUNT (meu_usr_id)
        INTO l_flag
        FROM sak_memo_user
       WHERE UPPER (meu_usr_id) = UPPER (i_user_id);

      IF (NVL (l_flag, 0) = 0)
      THEN
         o_flag := 0;
         RAISE norights;
      END IF;
   EXCEPTION
      WHEN norights
      THEN
         raise_application_error (-20601,
                                  'You are not a registered DEAL MEMO user.');
      WHEN NO_DATA_FOUND
      THEN
         o_flag := 0;
         raise_application_error (-20601,
                                  'You are not a registered DEAL MEMO user.');
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END;

   ------------------------------------------------ PROCEDURE TO CHECK USER UPDATE RIGHTS ----------------------------------------------------
   PROCEDURE prc_check_user_updaterights (i_mem_id    IN     NUMBER,
                                          i_user_id   IN     VARCHAR2,
                                          o_flag         OUT NUMBER)
   AS
      can_update         VARCHAR2 (1);
      l_mem_lee_number   NUMBER;
      l_flag             NUMBER := 0;
      norights           EXCEPTION;
      l_message          VARCHAR2 (200);
   BEGIN
      o_flag := 1;

      BEGIN
         SELECT COUNT (meu_usr_id)
           INTO l_flag
           FROM sak_memo_user
          WHERE UPPER (meu_usr_id) = UPPER (i_user_id);

         IF (NVL (l_flag, 0) = 0)
         THEN
            o_flag := 0;
            RAISE norights;
         END IF;
      EXCEPTION
         WHEN norights
         THEN
            raise_application_error (
               -20601,
               'You are not a registered DEAL MEMO user.');
         WHEN NO_DATA_FOUND
         THEN
            o_flag := 0;
            raise_application_error (
               -20601,
               'You are not a registered DEAL MEMO user.');
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      IF (NVL (l_flag, 0) <> 0)
      THEN
         BEGIN
            SELECT mem_lee_number
              INTO l_mem_lee_number
              FROM sak_memo
             WHERE mem_id = i_mem_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               o_flag := 0;
               l_message := 'No Licensee exist for Deal Memo.';
            WHEN OTHERS
            THEN
               raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
         END;

         BEGIN
            SELECT meu_can_update
              INTO can_update
              FROM sak_memo_user
             WHERE meu_lee_number = l_mem_lee_number
                   AND UPPER (meu_usr_id) = UPPER (i_user_id);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               o_flag := 0;
               l_message :=
                  'You are not allowed to update Deal Memos for this Licensee.';
            WHEN OTHERS
            THEN
               raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
         END;

         IF can_update != 'Y'
         THEN
            o_flag := 0;
            l_message :=
               'You are not allowed to update Deal Memos for this Licensee.';
         END IF;
      ELSE
         o_flag := 0;
         l_message := 'You are not a registered DEAL MEMO user.';
      END IF;

      IF (l_message <> ' ')
      THEN
         o_flag := 0;
         RAISE norights;
      END IF;
   EXCEPTION
      WHEN norights
      THEN
         raise_application_error (-20601, l_message);
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END;

   --- Bioscope Changes Added below SP by Anirudha on 20/03/2012
   PROCEDURE prc_copy_dm_prog_alloc (
      i_from_mei_id      IN     sak_allocation_detail.ald_mei_id%TYPE,
      i_to_mei_id_list   IN     VARCHAR2,
      i_entry_oper       IN     sak_allocation_detail.ald_entry_oper%TYPE,
      i_ald_id_list      IN     VARCHAR2,
      o_status              OUT NUMBER)
   AS
      --CATCHUP:CACQ14: Added by SHANTANU A. for update catchup licensee device rights
      l_ald_to_count           NUMBER;
      l_ald_count              NUMBER;
      l_ald_to_id              NUMBER;
      l_memo_date              DATE;
      l_cp_live_date           DATE;
      --CATCHUP: CACQ14: END
      l_ald_id                 sak_allocation_detail.ald_id%TYPE;
      l_chr_costed_runs        sak_channel_runs.chr_costed_runs%TYPE;
      l_mem_id                 sak_memo.mem_id%TYPE;
      l_mem_type_trgt          VARCHAR2 (50);
      l_mem_type_src           VARCHAR2 (50);
      l_is_catchup             NUMBER;
      l_is_tick                NUMBER;
      l_ald_cost_runs          NUMBER;
      l_con_number             NUMBER;
      l_ald_max_vp             NUMBER;
      l_ald_amount             NUMBER;
      l_chr_id                 NUMBER;
      l_gen_type_cnt           NUMBER;
      l_mem_status             sak_memo.mem_status%TYPE;
      l_string                 VARCHAR2 (2000);
      l_string2                VARCHAR2 (2000);
      l_string3                VARCHAR2 (2000);
      l_mei_to_id              VARCHAR2 (2000);
      --START: Project Bioscope ? Pending CR?s: mangesh_20121019
      --[PB_CR_47/l_chr_costed_runs to be null when BIOSCOPELICENSEFLAG=N]
      l_is_bioscope_lee_flag   VARCHAR (1);
      --END: Project Bioscope ? Pending CR?s:
      l_ald_id_list            VARCHAR2 (2000);
      l_mei_to_id2             VARCHAR2 (2000);
      l_catch_up               VARCHAR2 (20);
      l_cp_count               NUMBER := 0;
      l_lnr_count              NUMBER := 0;
      l_sp_count               NUMBER := 0;
      l_is_svod_alloc          NUMBER;
      l_is_catchup_alloc       NUMBER;
      l_is_linear_alloc        NUMBER;
      l_sec_lic_lee            NUMBER := 0;
      l_memo                   NUMBER;
      l_count_contract         NUMBER;
      l_is_Series              VARCHAR2 (1);
      l_is_svod                NUMBER := 0;
      L_IS_cp                  NUMBER := 0;
      l_dest_mg_flag           VARCHAR2 (1);
      l_src_mg_flag            VARCHAR2 (1);
      l_mg_flag                NUMBER;
      L_dealnumber             number;  --added by Milan Shah For CU4ALL
      L_Seriesnumber           number;  --added by Milan Shah For CU4ALL
      L_Success                number;  --added by Milan Shah For CU4ALL
      l_count                  number;  --added by Milan Shah For CU4ALL
      L_CON_PRESENT            varchar2(100); --Added by Milan Shah For CU4ALL
      l_bouquet_string         varchar2(1000); --added by Milan Shah for CU4ALL
      l_superstack_y           varchar2(150);
   BEGIN
      o_status := -1;
      l_string := i_to_mei_id_list;
      l_string3 := i_ald_id_list;

      --    DBMS_OUTPUT.put_line ('o_status - ' || o_status);
      --Warner Payment : Added by sushma on 14-10-2015
      /*SELECT NVL (mem_is_mg_flag, 'N')
        INTO l_dest_mg_flag
        FROM sak_memo, sak_memo_item
       WHERE mem_id = mei_mem_id
             AND mei_id IN
                    (SELECT COLUMN_VALUE
                       FROM TABLE (
                               x_pkg_cp_sch_grid.split_to_char (
                                  i_to_mei_id_list,
                                  ',')));
        */

      SELECT NVL (mem_is_mg_flag, 'N')
        INTO l_dest_mg_flag
        FROM Sak_Memo
       WHERE Mem_Id IN
                (SELECT mei_Mem_Id
                   FROM sak_memo_item,
                        TABLE (
                           X_Pkg_Cp_Sch_Grid.Split_To_Char (I_To_Mei_Id_List,
                                                            ','))
                  WHERE Mei_Id = COLUMN_VALUE);



      -- DBMS_OUTPUT.put_line ('l_dest_mg_flag' || l_dest_mg_flag);

      SELECT NVL (mem_is_mg_flag, 'N')
        INTO l_src_mg_flag
        FROM sak_memo, sak_memo_item
       WHERE mem_id = mei_mem_id AND mei_id = i_from_mei_id;

      --  DBMS_OUTPUT.put_line ('l_src_mg_flag' || l_src_mg_flag);

      IF (l_src_mg_flag = 'Y' AND l_dest_mg_flag = 'N')
         OR (l_src_mg_flag = 'N' AND l_dest_mg_flag = 'Y')
      THEN
         l_mg_flag := 1;
      --   DBMS_OUTPUT.put_line ('l_mg_flag' || l_mg_flag);
      END IF;

      WHILE l_string3 IS NOT NULL
      LOOP
         IF INSTR (l_string3, ',') > 0
         THEN
            l_mei_to_id2 := SUBSTR (l_string3, 1, INSTR (l_string3, ',') - 1);
            l_string3 :=
               SUBSTR (l_string3,
                       INSTR (l_string3, ',') + 1,
                       LENGTH (l_string3));
         ELSE
            l_mei_to_id2 := l_string3;
            l_string3 := NULL;
         END IF;

         SELECT COUNT (*)
           INTO l_is_catchup_alloc
           FROM fid_licensee
          WHERE NVL (lee_media_service_code, '#') = 'CATCHUP'
                AND lee_number = (SELECT ald_lee_number
                                    FROM sak_allocation_detail
                                   WHERE ald_id = l_mei_to_id2);

         SELECT COUNT (*)
           INTO l_is_linear_alloc
           FROM fid_licensee
          WHERE --NVL (lee_media_service_code, '#') NOT IN ( 'CATCHUP','SVOD')
               NVL (lee_media_service_code, '#') NOT IN
                   (SELECT ms_media_service_code
                      FROM sgy_pb_media_service
                     WHERE ms_media_service_code NOT IN ('PAYTV', 'TVOD'))
                AND lee_number = (SELECT ald_lee_number
                                    FROM sak_allocation_detail
                                   WHERE ald_id = l_mei_to_id2);

         SELECT COUNT (*)
           INTO l_is_svod_alloc
           FROM fid_licensee
          WHERE NVL (lee_media_service_code, '#') = 'SVOD'
                AND lee_number = (SELECT ald_lee_number
                                    FROM sak_allocation_detail
                                   WHERE ald_id = l_mei_to_id2);

         -- DBMS_OUTPUT.put_line (l_mei_to_id2);

         l_cp_count := l_cp_count + l_is_catchup_alloc;
         l_lnr_count := l_lnr_count + l_is_linear_alloc;
         l_sp_count := l_sp_count + l_is_svod_alloc;
      END LOOP;

      SELECT COUNT (*)
        INTO L_IS_cp
        FROM sak_allocation_detail
       WHERE ald_mei_id IN
                (SELECT COLUMN_VALUE
                   FROM TABLE (
                           x_pkg_cp_sch_grid.split_to_char (i_to_mei_id_list,
                                                            ',')))
             AND ald_lee_number IN
                    (SELECT lee_number
                       FROM fid_licensee
                      WHERE NVL (lee_media_service_code, '#') = 'CATCHUP');

      SELECT COUNT (*)
        INTO L_IS_SVOD
        FROM sak_allocation_detail
       WHERE ald_mei_id IN
                (SELECT COLUMN_VALUE
                   FROM TABLE (
                           x_pkg_cp_sch_grid.split_to_char (i_to_mei_id_list,
                                                            ',')))
             AND ald_lee_number IN
                    (SELECT lee_number
                       FROM fid_licensee
                      WHERE NVL (lee_media_service_code, '#') = 'SVOD');

      IF (l_cp_count > 0 AND l_is_svod > 0)
         OR (l_sp_count > 0 AND L_IS_cp > 0)
      THEN
         raise_application_error (
            -20613,
            'Allocation is not copied since source and destination deal are not of SVOD type');
      END IF;

      WHILE l_string IS NOT NULL
      LOOP
         IF INSTR (l_string, ',') > 0
         THEN
            l_mei_to_id := SUBSTR (l_string, 1, INSTR (l_string, ',') - 1);
            l_string :=
               SUBSTR (l_string,
                       INSTR (l_string, ',') + 1,
                       LENGTH (l_string));
         ELSE
            l_mei_to_id := l_string;
            l_string := NULL;
         END IF;

         l_string2 := i_ald_id_list;

         SELECT COUNT (gen_type)
           INTO l_gen_type_cnt
           FROM fid_general
          WHERE gen_type IN
                   (SELECT cpt_gen_type FROM sgy_pb_costed_prog_type)
                AND gen_refno IN (SELECT mei_gen_refno
                                    FROM sak_memo_item
                                   WHERE mei_id = l_mei_to_id);

         IF l_cp_count > 0 AND l_lnr_count > 0
         THEN
            DELETE FROM sak_channel_runs
                  WHERE chr_ald_id IN (SELECT ald_id
                                         FROM sak_allocation_detail
                                        WHERE ald_mei_id = l_mei_to_id);

            DELETE FROM x_cp_licensee_platform
                  WHERE cp_lee_plat_ald_id IN
                           (SELECT ald_id
                              FROM sak_allocation_detail
                             WHERE ald_mei_id = l_mei_to_id);

            --CATCHUP:CACQ14: Start:[SHANTANU A.]
            -- delete all records of media rights before update new
            DELETE FROM x_cp_memo_medplatdevcompat_map
                  WHERE mem_mpdc_ald_id IN (SELECT ald_id
                                              FROM sak_allocation_detail
                                             WHERE ald_mei_id = l_mei_to_id);

            --CATCHUP:[END]
            --Added by Milan Shah CU4ALL
            DELETE FROM x_cp_memo_superstack_rights where msr_ald_number in (select ALD_ID FROM sak_allocation_detail
                  WHERE ald_mei_id = l_mei_to_id);
            --Ended by Milan Shah CU4ALL

            DELETE FROM sak_allocation_detail
                  WHERE ald_mei_id = l_mei_to_id;

            ---Dev2:Pure Finance:Start:[Hari Mandal]_[13/04/2013]
            DELETE FROM x_fin_dm_sec_lee
                  WHERE dsl_mei_id = l_mei_to_id;
         ---Dev2:Pure Finance:End-----------------------------
         ELSIF l_cp_count > 0 AND l_lnr_count = 0
         THEN
            DELETE FROM sak_channel_runs
                  WHERE chr_ald_id IN
                           (SELECT ald_id
                              FROM sak_allocation_detail
                             WHERE ald_mei_id = l_mei_to_id
                                   AND ald_lee_number IN
                                          (SELECT lee_number
                                             FROM fid_licensee
                                            WHERE NVL (
                                                     lee_media_service_code,
                                                     '#') = 'CATCHUP'));

            DELETE FROM x_cp_licensee_platform
                  WHERE cp_lee_plat_ald_id IN
                           (SELECT ald_id
                              FROM sak_allocation_detail
                             WHERE ald_mei_id = l_mei_to_id
                                   AND ald_lee_number IN
                                          (SELECT lee_number
                                             FROM fid_licensee
                                            WHERE NVL (
                                                     lee_media_service_code,
                                                     '#') = 'CATCHUP'));

            --CATCHUP:CACQ14: [SHANTANU A.]_24-nov-2014
            -- delete all records of catchup media rights before update new
            DELETE FROM x_cp_memo_medplatdevcompat_map
                  WHERE MEM_MPDC_ALD_ID IN
                           (SELECT ald_id
                              FROM sak_allocation_detail
                             WHERE ald_mei_id = l_mei_to_id
                                   AND ald_lee_number IN
                                          (SELECT lee_number
                                             FROM fid_licensee
                                            WHERE NVL (
                                                     lee_media_service_code,
                                                     '#') = 'CATCHUP'));

            --CATCHUP:CACQ14:[END]

            DELETE FROM sak_allocation_detail
                  WHERE ald_mei_id = l_mei_to_id
                        AND ald_lee_number IN (SELECT lee_number
                                                 FROM fid_licensee
                                                WHERE NVL (
                                                         lee_media_service_code,
                                                         '#') = 'CATCHUP');

            DELETE FROM x_fin_dm_sec_lee
                  WHERE dsl_mei_id = l_mei_to_id;
         ELSIF l_cp_count = 0 AND l_lnr_count > 0
         THEN
            DELETE FROM sak_channel_runs
                  WHERE chr_ald_id IN
                           (SELECT ald_id
                              FROM sak_allocation_detail
                             WHERE ald_mei_id = l_mei_to_id
                                   AND ald_lee_number IN
                                          (SELECT lee_number
                                             FROM fid_licensee
                                            WHERE NVL (
                                                     lee_media_service_code,
                                                     '#') <> 'CATCHUP'));

            /*DELETE FROM x_cp_licensee_platform
                  WHERE cp_lee_plat_ald_id IN
                           (SELECT ald_id
                              FROM sak_allocation_detail
                             WHERE ald_mei_id = l_mei_to_id
                                   AND ald_lee_number IN
                                          (SELECT lee_number
                                             FROM fid_licensee
                                            WHERE NVL (
                                                     lee_media_service_code,
                                                     '#') <> 'CATCHUP'));*/
            --CATCHUP:CACQ14: [SHANTANU A.]_24-nov-2014
            -- delete all records of catchup media rights before update new
            DELETE FROM x_cp_memo_medplatdevcompat_map
                  WHERE MEM_MPDC_ALD_ID IN
                           (SELECT ald_id
                              FROM sak_allocation_detail
                             WHERE ald_mei_id = l_mei_to_id
                                   AND ald_lee_number IN
                                          (SELECT lee_number
                                             FROM fid_licensee
                                            WHERE NVL (
                                                     lee_media_service_code,
                                                     '#') <> 'CATCHUP'));

            --CATCHUP:CACQ14:[END]

            DELETE FROM sak_allocation_detail
                  WHERE ald_mei_id = l_mei_to_id
                        AND ald_lee_number IN (SELECT lee_number
                                                 FROM fid_licensee
                                                WHERE NVL (
                                                         lee_media_service_code,
                                                         '#') <> 'CATCHUP');

            ---Dev2:Pure Finance:Start:[Hari Mandal]_[13/04/2013]
            DELETE FROM x_fin_dm_sec_lee
                  WHERE dsl_mei_id = l_mei_to_id;
         ELSIF l_sp_count > 0
         THEN
            DELETE FROM x_cp_memo_medplatdevcompat_map
                  WHERE MEM_MPDC_ALD_ID IN
                           (SELECT ald_id
                              FROM sak_allocation_detail
                             WHERE ald_mei_id = l_mei_to_id
                                   AND ald_lee_number IN
                                          (SELECT lee_number
                                             FROM fid_licensee
                                            WHERE NVL (
                                                     lee_media_service_code,
                                                     '#') = 'SVOD'));

            --CATCHUP:CACQ14:[END]

            DELETE FROM sak_allocation_detail
                  WHERE ald_mei_id = l_mei_to_id
                        AND ald_lee_number IN (SELECT lee_number
                                                 FROM fid_licensee
                                                WHERE NVL (
                                                         lee_media_service_code,
                                                         '#') = 'SVOD');
         ---Dev2:Pure Finance:End-----------------------------
         END IF;

         ---Dev2:Pure Finance:Start:[Hari Mandal]_[13/04/2013]

         --check if data exist for secondry license
         SELECT COUNT (*)
           INTO l_sec_lic_lee
           FROM x_fin_dm_sec_lee
          WHERE dsl_mei_id = i_from_mei_id;

         --ADDED IF SOURCE DEAL DOES NOT CONTAIN ANY ENTYR IN SEC LICENSEE TABLE
         IF l_sec_lic_lee = 0
         THEN
            FOR k IN (SELECT ald_mei_id,
                             ald_lee_number,
                             ald_amount,
                             ald_entry_oper,
                             ald_entry_date,
                             ald_update_count
                        FROM sak_allocation_detail
                       WHERE ald_mei_id = i_from_mei_id)
            LOOP
               INSERT INTO x_fin_dm_sec_lee (dsl_number,
                                             dsl_mei_id,
                                             dsl_lee_number,
                                             dsl_is_primary,
                                             dsl_amount,
                                             dsl_entry_oper,
                                             dsl_entry_date,
                                             dsl_update_count,
                                             dsl_primary_lee)
                    VALUES (seq_dsl_id.NEXTVAL,
                            l_mei_to_id,
                            k.ald_lee_number,
                            'Y',
                            k.ald_amount,
                            i_entry_oper,
                            SYSDATE,
                            k.ald_update_count,
                            k.ald_lee_number);
            END LOOP;
         ELSE
            FOR k IN (SELECT dsl_number,
                             dsl_mei_id,
                             dsl_lee_number,
                             dsl_is_primary,
                             dsl_amount,
                             dsl_entry_oper,
                             dsl_entry_date,
                             dsl_update_count,
                             dsl_primary_lee
                        FROM x_fin_dm_sec_lee
                       WHERE dsl_mei_id = i_from_mei_id)
            LOOP
               INSERT INTO x_fin_dm_sec_lee (dsl_number,
                                             dsl_mei_id,
                                             dsl_lee_number,
                                             dsl_is_primary,
                                             dsl_amount,
                                             dsl_entry_oper,
                                             dsl_entry_date,
                                             dsl_update_count,
                                             dsl_primary_lee)
                    VALUES (seq_dsl_id.NEXTVAL,
                            l_mei_to_id,
                            k.dsl_lee_number,
                            k.dsl_is_primary,
                            k.dsl_amount,
                            i_entry_oper,
                            SYSDATE,
                            k.dsl_update_count,
                            k.dsl_primary_lee);
            END LOOP;
         END IF;

         ---Dev2:Pure Finance:End-----------------------------
         WHILE l_string2 IS NOT NULL
         LOOP
            IF INSTR (l_string2, ',') > 0
            THEN
               l_ald_id_list :=
                  SUBSTR (l_string2, 1, INSTR (l_string2, ',') - 1);
               l_string2 :=
                  SUBSTR (l_string2,
                          INSTR (l_string2, ',') + 1,
                          LENGTH (l_string2));
            ELSE
               l_ald_id_list := l_string2;
               l_string2 := NULL;
            END IF;

            --      DBMS_OUTPUT.put_line (l_ald_id_list);

            FOR i
               IN (SELECT ald_id,
                          ald_mei_id,
                          ald_lee_number,
                          ald_amount,
                          ald_exhib_days,
                          ald_chs_number,
                          ald_period_tba,
                          ald_period_start,
                          ald_period_end,
                          ald_live_date,
                          ald_black_days,
                          ald_cost_runs,
                          ald_max_runs_cha,
                          ald_max_runs_chs,
                          ald_months,
                          ald_lic_type,
                          ald_end_days,
                          ald_entry_oper,
                          ald_entry_date,
                          ald_is_deleted,
                          ald_update_count, --Catchup Impacted items:Pranay Kusumwal :added the below columns for catchup licenses.
                          ald_max_vp,
                          ald_non_cons_month,
                          ALD_ALLOW_BEFORE_LNR, --CATCHUP:CACQ14:START_Columns added by SHANATN A. for catchup validations
                          ALD_ALLOW_DAYS_BEFORE_LNR,
                          ALD_ALLOW_WITHOUT_LNR_REF,
                          --CATCHUP:CACQ14:[END]
                          ALD_MIN_GUA_FLAG        ---Warner Payment 10-07-2015
                     FROM sak_allocation_detail
                    WHERE ald_mei_id = i_from_mei_id
                          AND ald_id = l_ald_id_list --Commented by Pravin - catchup licenses should be copy
                                                    /*AND     ald_lee_number not in ( select lee_number
                                                                                    from fid_licensee
                                                                                        where nvl(lee_media_service_code,'N') = 'CATCHUP'
                                                                                        )*/
                  )
            LOOP
               --    DBMS_OUTPUT.put_line ('pk');

               SELECT COUNT (*)
                 INTO l_is_catchup
                 FROM fid_licensee
                WHERE lee_number = i.ald_lee_number
                      AND NVL (lee_media_service_code, 'N') = 'CATCHUP';

               SELECT COUNT (*)
                 INTO l_is_svod
                 FROM fid_licensee
                WHERE lee_number = i.ald_lee_number
                      AND NVL (lee_media_service_code, 'N') = 'SVOD';



               SELECT mem_type
                 INTO l_mem_type_src
                 FROM sak_memo_item, sak_memo
                WHERE mem_id = mei_mem_id AND mei_id = i_from_mei_id;

               SELECT mem_type, mem_con_number
                 INTO l_mem_type_trgt, l_con_number
                 FROM sak_memo_item, sak_memo
                WHERE mem_id = mei_mem_id AND mei_id = l_mei_to_id;

               SELECT COUNT (*)
                 INTO l_is_tick
                 FROM fid_contract
                WHERE con_number = l_con_number
                      AND (NVL (con_sch_after_prem_linr_fea, 'N') = 'Y'
                           OR NVL (con_sch_after_prem_linr_ser, 'N') = 'Y');

               IF     TRIM (l_mem_type_src) = 'FLF'
                  AND TRIM (l_mem_type_trgt) = 'ROY'
                  AND l_is_catchup > 0
               THEN
                  --        DBMS_OUTPUT.put_line ('****in flf to roy');
                  l_ald_amount := 0;
                  l_ald_cost_runs := 0;
                  l_ald_max_vp := i.ald_exhib_days;
               ELSE
                  l_ald_amount := i.ald_amount;
                  l_ald_cost_runs := i.ald_cost_runs;
                  l_ald_max_vp := i.ald_exhib_days;
               END IF;

               IF l_is_tick > 0 AND l_is_catchup > 0
               THEN
                  IF l_mem_type_trgt = 'FLF'
                  THEN
                     --        DBMS_OUTPUT.put_line ('****1');
                     l_ald_cost_runs := 1;
                     l_ald_max_vp := 1;
                  ELSIF l_mem_type_trgt = 'ROY'
                  THEN
                     --          DBMS_OUTPUT.put_line ('****2');
                     l_ald_cost_runs := 0;
                     l_ald_max_vp := 1;
                  ELSE
                     --           DBMS_OUTPUT.put_line ('****3');
                     l_ald_cost_runs := i.ald_cost_runs;
                     l_ald_max_vp := i.ald_exhib_days;
                  END IF;
               END IF;



               --START: Project Bioscope ? Pending CR?s: mangesh_20121019
               --[PB_CR_47/l_chr_costed_runs to be null when BIOSCOPELICENSEFLAG=N]
               SELECT NVL (lee_bioscope_flag, 'N')
                 INTO l_is_bioscope_lee_flag
                 FROM fid_licensee
                WHERE lee_number = i.ald_lee_number;

               --     raise_application_error (-20601, 'no insert');
               --END: Project Bioscope ? Pending CR?s:
               l_ald_id := get_seq ('SEQ_ALD_ID');

               INSERT INTO sak_allocation_detail (ald_id,
                                                  ald_mei_id,
                                                  ald_lee_number,
                                                  ald_amount,
                                                  ald_exhib_days,
                                                  ald_chs_number,
                                                  ald_period_tba,
                                                  ald_period_start,
                                                  ald_period_end,
                                                  ald_live_date,
                                                  ald_black_days,
                                                  ald_cost_runs,
                                                  ald_max_runs_cha,
                                                  ald_max_runs_chs,
                                                  ald_months,
                                                  ald_lic_type,
                                                  ald_end_days,
                                                  ald_entry_oper,
                                                  ald_entry_date,
                                                  ald_is_deleted,
                                                  ald_update_count --Catchup Impacted items:Pranay Kusumwal :added the below columns for catchup licenses.
                                                                  ,
                                                  ald_max_vp,
                                                  ald_non_cons_month,
                                                  ALD_ALLOW_BEFORE_LNR,
                                                  ALD_ALLOW_DAYS_BEFORE_LNR,
                                                  ALD_ALLOW_WITHOUT_LNR_REF,
                                                  ALD_MIN_GUA_FLAG --- Warner Payment: Min Gurantee Flag
                                                                  )
                    VALUES (
                              l_ald_id,
                              l_mei_to_id,
                              i.ald_lee_number,
                              l_ald_amount,
                              l_ald_max_vp,
                              i.ald_chs_number,
                              i.ald_period_tba,
                              i.ald_period_start,
                              i.ald_period_end,
                              i.ald_live_date,
                              i.ald_black_days,
                              l_ald_cost_runs,
                              i.ald_max_runs_cha,
                              i.ald_max_runs_chs,
                              i.ald_months,
                              i.ald_lic_type,
                              i.ald_end_days,
                              i_entry_oper,
                              SYSDATE,
                              i.ald_is_deleted,
                              i.ald_update_count --Catchup Impacted items:Pranay Kusumwal :added the below columns for catchup licenses.
                                                ,
                              i.ald_max_vp,
                              i.ald_non_cons_month,
                              i.ALD_ALLOW_BEFORE_LNR, --Catchup:CACQ14:insert values of the new column added by [SHANTANU A.]
                              i.ALD_ALLOW_DAYS_BEFORE_LNR,
                              i.ALD_ALLOW_WITHOUT_LNR_REF,
                              (CASE
                                  WHEN l_mg_flag = 1 THEN 'N' --Added by sushma on 14-10-2015
                                  ELSE i.ALD_MIN_GUA_FLAG
                               END));

               --CATCHUP:CACQ14:[END]
               /* Catchup-R2 :Pranay Kusumwal 18/01/2013 : Added for implementing Catchup Impact */
               --Added the code below for copying the Platform for Catchup Lee
               SELECT NVL (lee_media_service_code, 'N')
                 INTO l_catch_up
                 FROM fid_licensee
                WHERE lee_number = i.ald_lee_number;

               --     dbms_output.put_line('insert');
               IF l_catch_up = 'CATCHUP'
               THEN
                  SELECT NVL (mem_status_date, SYSDATE), mem_id
                    INTO l_memo_date, l_memo
                    FROM sak_memo
                   WHERE mem_id = (SELECT mei_mem_id
                                     FROM sak_memo_item
                                    WHERE mei_id = i_from_mei_id);

                  SELECT CONTENT
                    INTO l_cp_live_date
                    FROM x_fin_configs
                   WHERE KEY = 'CATCH-UP_LIVE_DATE';

                  --          dbms_output.put_line(l_memo_date);
                  --           dbms_output.put_line(l_cp_live_date);
                  SELECT X_FNC_GET_PROG_TYPE (mei_type_show)
                    INTO l_is_Series
                    FROM sak_memo_item
                   WHERE mei_id = l_mei_to_id;

                  IF l_is_Series = 'Y'
                  THEN
                     SELECT COUNT (*)
                       INTO l_count_contract
                       FROM x_cp_con_medplatmdevcompat_map
                      WHERE     CON_CONTRACT_NUMBER = l_con_number
                            AND CON_IS_FEA_SER <> 'FEA'
                            AND CON_RIGHTS_ON_DEVICE = 'Y';
                  ELSE
                     SELECT COUNT (*)
                       INTO l_count_contract
                       FROM x_cp_con_medplatmdevcompat_map
                      WHERE     CON_CONTRACT_NUMBER = l_con_number
                            AND CON_IS_FEA_SER <> 'SER'
                            AND CON_RIGHTS_ON_DEVICE = 'Y';
                  END IF;

                  IF l_memo_date > l_cp_live_date
                  THEN
                     IF l_con_number IS NULL
                     THEN
                        INSERT INTO x_cp_memo_medplatdevcompat_map (
                                       MEM_MPDC_ID,
                                       MEM_MPDC_ALD_ID,
                                       MEM_MPDC_DEV_PLATM_ID,
                                       MEM_RIGHTS_ON_DEVICE,
                                       MEM_MPDC_COMP_RIGHTS_ID,
                                       MEM_IS_COMP_RIGHTS,
                                       MEM_MPDC_ENTRY_OPER,
                                       MEM_MPDC_ENTRY_DATE,
                                       MEM_MPDC_MODIFIED_BY,
                                       MEM_MPDC_MODIFIED_ON,
                                       MEM_MPDC_UPDATE_COUNT,
                                       MEM_MPDC_SERVICE_CODE)
                           SELECT X_SEQ_MEM_MPDC_ID.NEXTVAL,
                                  l_ald_id,
                                  MEM_MPDC_DEV_PLATM_ID,
                                  MEM_RIGHTS_ON_DEVICE,
                                  MEM_MPDC_COMP_RIGHTS_ID,
                                  MEM_IS_COMP_RIGHTS,
                                  i_entry_oper,
                                  SYSDATE,
                                  NULL,
                                  NULL,
                                  0,
                                  MEM_MPDC_SERVICE_CODE
                             FROM x_cp_memo_medplatdevcompat_map
                            WHERE MEM_MPDC_ALD_ID = i.ald_id;
                     --CATCHUP:CACQ14: added by [SHANTANU A.]_22-nov-2014 for update catchup devie rights at programme allocation level
                     ELSIF l_is_Series = 'Y' AND l_count_contract > 0
                     THEN
                        INSERT INTO x_cp_memo_medplatdevcompat_map (
                                       MEM_MPDC_ID,
                                       MEM_MPDC_ALD_ID,
                                       MEM_MPDC_DEV_PLATM_ID,
                                       MEM_RIGHTS_ON_DEVICE,
                                       MEM_MPDC_COMP_RIGHTS_ID,
                                       MEM_IS_COMP_RIGHTS,
                                       MEM_MPDC_ENTRY_OPER,
                                       MEM_MPDC_ENTRY_DATE,
                                       MEM_MPDC_MODIFIED_BY,
                                       MEM_MPDC_MODIFIED_ON,
                                       MEM_MPDC_UPDATE_COUNT,
                                       MEM_MPDC_SERVICE_CODE)
                           SELECT X_SEQ_MEM_MPDC_ID.NEXTVAL,
                                  l_ald_id,
                                  MEM_MPDC_DEV_PLATM_ID,
                                  MEM_RIGHTS_ON_DEVICE,
                                  MEM_MPDC_COMP_RIGHTS_ID,
                                  MEM_IS_COMP_RIGHTS,
                                  i_entry_oper,
                                  SYSDATE,
                                  NULL,
                                  NULL,
                                  0,
                                  MEM_MPDC_SERVICE_CODE
                             FROM x_cp_memo_medplatdevcompat_map
                            WHERE MEM_MPDC_ALD_ID = i.ald_id;

                        /*AND EXISTS
                               (SELECT 1
                                  FROM x_cp_con_medplatmdevcompat_map
                                 WHERE CON_CONTRACT_NUMBER =
                                          l_con_number
                                       AND CON_IS_FEA_SER = 'SER'
                                       AND CON_RIGHTS_ON_DEVICE =
                                       'Y'
                                       AND CON_MPDC_DEV_PLATM_ID =
                                              MEM_MPDC_DEV_PLATM_ID
                                       AND CON_MPDC_COMP_RIGHTS_ID =
                                              MEM_MPDC_COMP_RIGHTS_ID);*/
                        /*

                        update x_cp_memo_medplatdevcompat_map
                        set
                        MEM_RIGHTS_ON_DEVICE=(select CON_RIGHTS_ON_DEVICE from x_cp_con_medplatmdevcompat_map where CON_CONTRACT_NUMBER =
                                                      l_con_number
                                                   AND CON_IS_FEA_SER = 'SER' and CON_MPDC_DEV_PLATM_ID =
                                                          MEM_MPDC_DEV_PLATM_ID
                                                   AND CON_MPDC_COMP_RIGHTS_ID =
                                                          MEM_MPDC_COMP_RIGHTS_ID  ),
                        MEM_IS_COMP_RIGHTS= (select CON_IS_COMP_RIGHTS from x_cp_con_medplatmdevcompat_map where CON_CONTRACT_NUMBER =
                                                      l_con_number
                                                   AND CON_IS_FEA_SER = 'SER' and CON_MPDC_DEV_PLATM_ID =
                                                          MEM_MPDC_DEV_PLATM_ID
                                                   AND CON_MPDC_COMP_RIGHTS_ID =
                                                          MEM_MPDC_COMP_RIGHTS_ID  )
                        where MEM_MPDC_ALD_ID = i.ald_id;*/
                        UPDATE x_cp_memo_medplatdevcompat_map
                           SET MEM_RIGHTS_ON_DEVICE = 'N',
                               MEM_IS_COMP_RIGHTS = 'N'
                         WHERE NOT EXISTS
                                      (SELECT 1
                                         FROM x_cp_con_medplatmdevcompat_map
                                        WHERE CON_CONTRACT_NUMBER =
                                                 l_con_number
                                              AND CON_IS_FEA_SER <> 'FEA'
                                              AND CON_RIGHTS_ON_DEVICE = 'Y'
                                              AND CON_MPDC_DEV_PLATM_ID =
                                                     MEM_MPDC_DEV_PLATM_ID
                                              AND CON_MPDC_COMP_RIGHTS_ID =
                                                     MEM_MPDC_COMP_RIGHTS_ID
                                              AND con_IS_COMP_RIGHTS =
                                                     MEM_IS_COMP_RIGHTS)
                               AND MEM_MPDC_ALD_ID = l_ald_id;
                     ELSIF l_is_Series <> 'Y' AND l_count_contract > 0
                     THEN
                        INSERT INTO x_cp_memo_medplatdevcompat_map (
                                       MEM_MPDC_ID,
                                       MEM_MPDC_ALD_ID,
                                       MEM_MPDC_DEV_PLATM_ID,
                                       MEM_RIGHTS_ON_DEVICE,
                                       MEM_MPDC_COMP_RIGHTS_ID,
                                       MEM_IS_COMP_RIGHTS,
                                       MEM_MPDC_ENTRY_OPER,
                                       MEM_MPDC_ENTRY_DATE,
                                       MEM_MPDC_MODIFIED_BY,
                                       MEM_MPDC_MODIFIED_ON,
                                       MEM_MPDC_UPDATE_COUNT,
                                       MEM_MPDC_SERVICE_CODE)
                           SELECT X_SEQ_MEM_MPDC_ID.NEXTVAL,
                                  l_ald_id,
                                  MEM_MPDC_DEV_PLATM_ID,
                                  MEM_RIGHTS_ON_DEVICE,
                                  MEM_MPDC_COMP_RIGHTS_ID,
                                  MEM_IS_COMP_RIGHTS,
                                  i_entry_oper,
                                  SYSDATE,
                                  NULL,
                                  NULL,
                                  0,
                                  MEM_MPDC_SERVICE_CODE
                             FROM x_cp_memo_medplatdevcompat_map
                            WHERE MEM_MPDC_ALD_ID = i.ald_id;

                        /*  AND EXISTS
                                 (SELECT 1
                                    FROM x_cp_con_medplatmdevcompat_map
                                   WHERE CON_CONTRACT_NUMBER =
                                            l_con_number
                                         AND CON_IS_FEA_SER <> 'SER'
                                         AND CON_RIGHTS_ON_DEVICE =
                                         'Y'
                                         AND CON_MPDC_DEV_PLATM_ID =
                                                MEM_MPDC_DEV_PLATM_ID
                                         AND CON_MPDC_COMP_RIGHTS_ID =
                                                MEM_MPDC_COMP_RIGHTS_ID);*/


                        UPDATE x_cp_memo_medplatdevcompat_map
                           SET MEM_RIGHTS_ON_DEVICE = 'N',
                               MEM_IS_COMP_RIGHTS = 'N'
                         WHERE NOT EXISTS
                                      (SELECT 1
                                         FROM x_cp_con_medplatmdevcompat_map
                                        WHERE CON_CONTRACT_NUMBER =
                                                 l_con_number
                                              AND CON_IS_FEA_SER <> 'SER'
                                              AND CON_RIGHTS_ON_DEVICE = 'Y'
                                              AND CON_MPDC_DEV_PLATM_ID =
                                                     MEM_MPDC_DEV_PLATM_ID
                                              AND CON_MPDC_COMP_RIGHTS_ID =
                                                     MEM_MPDC_COMP_RIGHTS_ID
                                              AND con_IS_COMP_RIGHTS =
                                                     MEM_IS_COMP_RIGHTS)
                               AND MEM_MPDC_ALD_ID = l_ald_id;
                     /*  FOR J IN (SELECT * FROM x_cp_con_medplatmdevcompat_map WHERE CON_CONTRACT_NUMBER =
                                                      l_con_number
                                                   AND CON_IS_FEA_SER = 'FEA'
                                                   AND CON_MPDC_SERVICE_CODE='CATCHUP')
                                                   LOOP

                         UPDATE  x_cp_memo_medplatdevcompat_map
                          SET  MEM_RIGHTS_ON_DEVICE=
                           J.CON_RIGHTS_ON_DEVICE,
                           MEM_IS_COMP_RIGHTS=J.CON_IS_COMP_RIGHTS
                          WHERE  MEM_MPDC_ALD_ID = I.ald_id
                          AND MEM_MPDC_DEV_PLATM_ID=J.CON_MPDC_DEV_PLATM_ID
                          AND MEM_MPDC_COMP_RIGHTS_ID=J.CON_MPDC_COMP_RIGHTS_ID;
                          END LOOP;

                         /*
                        update x_cp_memo_medplatdevcompat_map
                        set
                        MEM_RIGHTS_ON_DEVICE=(select nvl(CON_RIGHTS_ON_DEVICE,'N') from x_cp_con_medplatmdevcompat_map where CON_CONTRACT_NUMBER =
                                                      l_con_number
                                                   AND CON_IS_FEA_SER = 'FEA' and CON_MPDC_DEV_PLATM_ID =
                                                          MEM_MPDC_DEV_PLATM_ID
                                                   AND CON_MPDC_COMP_RIGHTS_ID =
                                                          MEM_MPDC_COMP_RIGHTS_ID  ),
                        MEM_IS_COMP_RIGHTS= (select NVL(CON_IS_COMP_RIGHTS,'N') from x_cp_con_medplatmdevcompat_map where CON_CONTRACT_NUMBER =
                                                      l_con_number
                                                   AND CON_IS_FEA_SER = 'FEA' and CON_MPDC_DEV_PLATM_ID =
                                                          MEM_MPDC_DEV_PLATM_ID
                                                   AND CON_MPDC_COMP_RIGHTS_ID =
                                                          MEM_MPDC_COMP_RIGHTS_ID  )
                        where MEM_MPDC_ALD_ID = i.ald_id;   */
                     ELSE
                        /*raise_application_error (
                           -20613,
                           'Catch Up Allocation is not copied since destination deal is not having rights at contract level');*/
                        NULL;
                     END IF;
                  ELSE
                     /*raise_application_error (
                        -20613,
                        'Catch Up Allocation is not copied since source deal is having rights at Platform level');*/
                     NULL;
                  END IF;
               /*l_count := sql%rowcount;

                                             IF l_count > 0
                                             THEN
                                                 commit;
                                                 o_status :=1;
                                             ELSE
                                                 rollback;
                                                 o_status :=0;
                                             END IF;*/


               /*INSERT INTO x_cp_licensee_platform (
                              cp_lee_plat_id,
                              cp_lee_plat_ald_id,
                              cp_lee_plat_mpsm_mapp_id)
                  (SELECT x_cp_lee_plat_seq.NEXTVAL,
                          l_ald_id,
                          cp_lee_plat_mpsm_mapp_id
                     FROM x_cp_licensee_platform
                    WHERE cp_lee_plat_ald_id = i.ald_id);*/

               --CATCHUP:CACQ14: [END]
               END IF;

               IF l_catch_up = 'SVOD'
               THEN
                  SELECT X_FNC_GET_PROG_TYPE (mei_type_show)
                    INTO l_is_Series
                    FROM sak_memo_item
                   WHERE mei_id = l_mei_to_id;

                  IF l_is_Series = 'Y'
                  THEN
                     SELECT COUNT (*)
                       INTO l_count_contract
                       FROM x_cp_con_medplatmdevcompat_map
                      WHERE     CON_CONTRACT_NUMBER = l_con_number
                            AND CON_IS_FEA_SER <> 'FEA'
                            AND CON_RIGHTS_ON_DEVICE = 'Y';
                  ELSE
                     SELECT COUNT (*)
                       INTO l_count_contract
                       FROM x_cp_con_medplatmdevcompat_map
                      WHERE     CON_CONTRACT_NUMBER = l_con_number
                            AND CON_IS_FEA_SER <> 'SER'
                            AND CON_RIGHTS_ON_DEVICE = 'Y';
                  END IF;

                  IF l_con_number IS NULL
                  THEN
                     INSERT INTO x_cp_memo_medplatdevcompat_map (
                                    MEM_MPDC_ID,
                                    MEM_MPDC_ALD_ID,
                                    MEM_MPDC_DEV_PLATM_ID,
                                    MEM_RIGHTS_ON_DEVICE,
                                    MEM_MPDC_COMP_RIGHTS_ID,
                                    MEM_IS_COMP_RIGHTS,
                                    MEM_MPDC_ENTRY_OPER,
                                    MEM_MPDC_ENTRY_DATE,
                                    MEM_MPDC_MODIFIED_BY,
                                    MEM_MPDC_MODIFIED_ON,
                                    MEM_MPDC_UPDATE_COUNT,
                                    MEM_MPDC_SERVICE_CODE)
                        SELECT X_SEQ_MEM_MPDC_ID.NEXTVAL,
                               l_ald_id,
                               MEM_MPDC_DEV_PLATM_ID,
                               MEM_RIGHTS_ON_DEVICE,
                               MEM_MPDC_COMP_RIGHTS_ID,
                               MEM_IS_COMP_RIGHTS,
                               i_entry_oper,
                               SYSDATE,
                               NULL,
                               NULL,
                               0,
                               MEM_MPDC_SERVICE_CODE
                          FROM x_cp_memo_medplatdevcompat_map
                         WHERE MEM_MPDC_ALD_ID = i.ald_id;
                  --CATCHUP:CACQ14: added by [SHANTANU A.]_22-nov-2014 for update catchup devie rights at programme allocation level
                  ELSIF l_is_Series = 'Y' AND l_count_contract > 0
                  THEN
                     INSERT INTO x_cp_memo_medplatdevcompat_map (
                                    MEM_MPDC_ID,
                                    MEM_MPDC_ALD_ID,
                                    MEM_MPDC_DEV_PLATM_ID,
                                    MEM_RIGHTS_ON_DEVICE,
                                    MEM_MPDC_COMP_RIGHTS_ID,
                                    MEM_IS_COMP_RIGHTS,
                                    MEM_MPDC_ENTRY_OPER,
                                    MEM_MPDC_ENTRY_DATE,
                                    MEM_MPDC_MODIFIED_BY,
                                    MEM_MPDC_MODIFIED_ON,
                                    MEM_MPDC_UPDATE_COUNT,
                                    MEM_MPDC_SERVICE_CODE)
                        SELECT X_SEQ_MEM_MPDC_ID.NEXTVAL,
                               l_ald_id,
                               MEM_MPDC_DEV_PLATM_ID,
                               MEM_RIGHTS_ON_DEVICE,
                               MEM_MPDC_COMP_RIGHTS_ID,
                               MEM_IS_COMP_RIGHTS,
                               i_entry_oper,
                               SYSDATE,
                               NULL,
                               NULL,
                               0,
                               MEM_MPDC_SERVICE_CODE
                          FROM x_cp_memo_medplatdevcompat_map
                         WHERE MEM_MPDC_ALD_ID = i.ald_id;


                     UPDATE x_cp_memo_medplatdevcompat_map
                        SET MEM_RIGHTS_ON_DEVICE = 'N',
                            MEM_IS_COMP_RIGHTS = 'N'
                      WHERE NOT EXISTS
                                   (SELECT 1
                                      FROM x_cp_con_medplatmdevcompat_map
                                     WHERE CON_CONTRACT_NUMBER = l_con_number
                                           AND CON_IS_FEA_SER <> 'FEA'
                                           AND CON_RIGHTS_ON_DEVICE = 'Y'
                                           AND CON_MPDC_DEV_PLATM_ID =
                                                  MEM_MPDC_DEV_PLATM_ID
                                           AND CON_MPDC_COMP_RIGHTS_ID =
                                                  MEM_MPDC_COMP_RIGHTS_ID
                                           AND con_IS_COMP_RIGHTS =
                                                  MEM_IS_COMP_RIGHTS)
                            AND MEM_MPDC_ALD_ID = l_ald_id;
                  ELSIF l_is_Series <> 'Y' AND l_count_contract > 0
                  THEN
                     INSERT INTO x_cp_memo_medplatdevcompat_map (
                                    MEM_MPDC_ID,
                                    MEM_MPDC_ALD_ID,
                                    MEM_MPDC_DEV_PLATM_ID,
                                    MEM_RIGHTS_ON_DEVICE,
                                    MEM_MPDC_COMP_RIGHTS_ID,
                                    MEM_IS_COMP_RIGHTS,
                                    MEM_MPDC_ENTRY_OPER,
                                    MEM_MPDC_ENTRY_DATE,
                                    MEM_MPDC_MODIFIED_BY,
                                    MEM_MPDC_MODIFIED_ON,
                                    MEM_MPDC_UPDATE_COUNT,
                                    MEM_MPDC_SERVICE_CODE)
                        SELECT X_SEQ_MEM_MPDC_ID.NEXTVAL,
                               l_ald_id,
                               MEM_MPDC_DEV_PLATM_ID,
                               MEM_RIGHTS_ON_DEVICE,
                               MEM_MPDC_COMP_RIGHTS_ID,
                               MEM_IS_COMP_RIGHTS,
                               i_entry_oper,
                               SYSDATE,
                               NULL,
                               NULL,
                               0,
                               MEM_MPDC_SERVICE_CODE
                          FROM x_cp_memo_medplatdevcompat_map
                         WHERE MEM_MPDC_ALD_ID = i.ald_id;



                     UPDATE x_cp_memo_medplatdevcompat_map
                        SET MEM_RIGHTS_ON_DEVICE = 'N',
                            MEM_IS_COMP_RIGHTS = 'N'
                      WHERE NOT EXISTS
                                   (SELECT 1
                                      FROM x_cp_con_medplatmdevcompat_map
                                     WHERE CON_CONTRACT_NUMBER = l_con_number
                                           AND CON_IS_FEA_SER <> 'SER'
                                           AND CON_RIGHTS_ON_DEVICE = 'Y'
                                           AND CON_MPDC_DEV_PLATM_ID =
                                                  MEM_MPDC_DEV_PLATM_ID
                                           AND CON_MPDC_COMP_RIGHTS_ID =
                                                  MEM_MPDC_COMP_RIGHTS_ID
                                           AND con_IS_COMP_RIGHTS =
                                                  MEM_IS_COMP_RIGHTS)
                            AND MEM_MPDC_ALD_ID = l_ald_id;
                  END IF;
               END IF;



               /* Catchup-R2 :Pranay Kusumwal 18/01/2013 : END */
               FOR j IN (SELECT chr_ald_id,
                                chr_cha_number,
                                chr_number_runs,
                                chr_cost_channel,
                                chr_is_deleted,
                                chr_update_count,
                                chr_costed_runs                  -- Sanjeevani
                                               ,
                                chr_max_runs_chr
                           FROM sak_channel_runs
                          WHERE chr_ald_id = i.ald_id)
               LOOP
                  --START: Project Bioscope ? Pending CR?s: mangesh_20121019
                  --[PB_CR_47/l_chr_costed_runs to be null when BIOSCOPELICENSEFLAG=N]
                  IF l_gen_type_cnt > 0 AND l_is_bioscope_lee_flag = 'Y'
                  THEN
                     l_chr_costed_runs := j.chr_costed_runs;
                  ELSE
                     l_chr_costed_runs := NULL;
                  END IF;

                  --END: Project Bioscope ? Pending CR?s:
                  l_chr_id := get_seq ('SEQ_CHR_NUMBER');

                  INSERT INTO sak_channel_runs (chr_ald_id,
                                                chr_cha_number,
                                                chr_number_runs,
                                                chr_cost_channel,
                                                chr_entry_oper,
                                                chr_entry_date,
                                                chr_is_deleted,
                                                chr_update_count,
                                                chr_id,
                                                chr_costed_runs --START: Project Bioscope ? Pending CR?s: sanjeevani_20121107
                                                               --[PB_CR_47/CHR_MAX_RUNS_CHR Added to Copy allocation]
                                                ,
                                                chr_max_runs_chr --END: Project Bioscope ? Pending CR?s:
                                                                )
                       VALUES (l_ald_id,
                               j.chr_cha_number,
                               j.chr_number_runs,
                               j.chr_cost_channel,
                               i_entry_oper,
                               SYSDATE,
                               j.chr_is_deleted,
                               j.chr_update_count,
                               l_chr_id,
                               l_chr_costed_runs --START: Project Bioscope ? Pending CR?s: sanjeevani_20121107
                                                --[PB_CR_47/CHR_MAX_RUNS_CHR Added to Copy allocation]
                               ,
                               j.chr_max_runs_chr --END: Project Bioscope ? Pending CR?s:
                                                 );
               END LOOP;
                      update x_cp_memo_medplatdevcompat_map A
                      set A.mem_rights_on_device ='Y'
                      where  A.mem_mpdc_ald_id = l_ald_id
                      AND A.mem_rights_on_device ='N'
                      and exists ( select 1 from x_cp_memo_medplatdevcompat_map B
                      WHERE B.MEM_RIGHTS_ON_DEVICE ='Y'
                      AND B.MEM_MPDC_DEV_PLATM_ID = A.MEM_MPDC_DEV_PLATM_ID
                      AND B.mem_mpdc_ald_id = A.mem_mpdc_ald_id
                      );
            END LOOP;
         END LOOP;
      END LOOP;

      --Start Milan Shah CU4ALL copy superstacking rights
      FOR SOURCE_SUPERSTACK IN
      (
          select concat_column(cb_name) Bouquet,lee_short_name licensee
          FROM
          (
            select DISTINCT cb_name,lee_short_name
            from sak_allocation_detail
                 ,x_cp_memo_superstack_rights
                 ,x_cp_bouquet
                 ,fid_licensee
            where ald_mei_id = i_from_mei_id
                  AND ald_id = msr_ald_number
                  AND cb_id = msr_bouquet_id
                  and msr_superstack_flag = 'Y'
                  and ald_lee_number = lee_number
                  and ald_lee_number in(SELECT lee_number FROM fid_licensee where LEE_MEDIA_SERVICE_CODE in('CATCHUP','CATCHUP3P'))
          )
          group by lee_short_name
       )
       LOOP
            FOR destinations IN
            (
                (SELECT COLUMN_VALUE DEST_MEI_ID FROM TABLE(X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR(i_to_mei_id_list,',')))
            )
            LOOP
                  l_superstack_y :='';
                  l_bouquet_string :='';
                  SELECT mei_mem_id,mei_gen_refno INTO L_dealnumber,L_Seriesnumber
                  FROM sak_memo_item
                  WHERE mei_id = destinations.DEST_MEI_ID;

                  FOR bouq IN
                  (
                      (SELECT COLUMN_VALUE COL1 FROM TABLE(X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR(SOURCE_SUPERSTACK.Bouquet,',')))
                  )
                  LOOP
                      if bouq.COL1 is not null
                      then
                          select mem_con_number into L_CON_PRESENT from sak_memo where mem_id = L_dealnumber;
                          IF L_CON_PRESENT is NOT NULL
                          THEN
                                SELECT COUNT(1) into l_count
                                FROM  X_CP_CON_BOUQ_SSTACK_RIGHTS
                                      ,x_cp_bouquet
                                where CBR_CON_NUMBER = (select mem_con_number from sak_memo where mem_id = L_dealnumber)
                                      AND CB_ID = CBR_BOUQUET_ID
                                      AND CB_NAME = bouq.COL1
                                      AND CBR_SUPERSTACKRIGHTS = 'Y';
                              if l_count > 0
                              then
                                   l_superstack_y := l_superstack_y||bouq.COL1||',';
                                   --X_CP_SUPERSTACK_RIGHTS.X_MEMO_INSERT_RIGHTS(L_dealnumber,L_Seriesnumber,SOURCE_SUPERSTACK.licensee,bouq.COL1,i_entry_oper,L_Success);
--                              else
--                                  l_bouquet_string := l_bouquet_string ||bouq.COL1 ||',';
                              end if;
                          else
                               l_superstack_y := l_superstack_y||bouq.COL1||',';
                              --X_CP_SUPERSTACK_RIGHTS.X_MEMO_INSERT_RIGHTS(L_dealnumber,L_Seriesnumber,SOURCE_SUPERSTACK.licensee,bouq.COL1,i_entry_oper,L_Success);
                          end if;
                      end if;
                  END LOOP;
                  if l_superstack_y is not null
                  then
                      l_superstack_y := rtrim(l_superstack_y,',');
                      X_CP_SUPERSTACK_RIGHTS.X_MEMO_INSERT_RIGHTS(L_dealnumber,L_Seriesnumber,SOURCE_SUPERSTACK.licensee,l_superstack_y,i_entry_oper,L_Success);
                  end if;
            END LOOP;
       END LOOP;

      --End Milan Shah CU4ALL

      COMMIT;
      o_status := 1;
   --   DBMS_OUTPUT.put_line ('o_status - ' || o_status);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END prc_copy_dm_prog_alloc;

   --- Bioscope Changes Added by Anirudha on 17/04/2012 to validate ROY Check
   PROCEDURE prc_check_cha_runs_rights (
      i_mem_id sak_memo_item.mei_mem_id%TYPE)
   AS
      l_dmps_mapp_id     NUMBER;
      l_cha_short_name   fid_channel.cha_short_name%TYPE;
      l_mem_type         sak_memo.mem_type%TYPE;
   BEGIN
      SELECT mem_type
        INTO l_mem_type
        FROM sak_memo
       WHERE mem_id = i_mem_id;

      --Commented as per CR 55912 by Anirudha on 23/05/2012
      /*
      FOR i IN
      (    SELECT chr_cha_number
              ,cha_mpsm_mapp_id
          FROM   sak_channel_runs
              ,fid_channel
          WHERE  cha_number = chr_cha_number
          AND    chr_ald_id in (    SELECT ald_id
                      FROM sak_allocation_detail
                      WHERE ald_mei_id IN (    SELECT mei_id
                                  FROM sak_memo_item
                                  WHERE mei_mem_id =i_mem_id )) --2432
                                  )
      LOOP
          BEGIN
              select    dmps_mapp_id
              into    l_dmps_mapp_id
              from    sgy_pb_dm_med_plat_service
              where    dmps_mem_id = i_mem_ID
              and    dmps_mapp_id = i.cha_mpsm_mapp_id
              ;
          EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
              select cha_short_name
              into   l_cha_short_name
              from   fid_channel
              where  cha_number = i.chr_cha_number
              ;
              raise_application_error (-20601,'The '||l_cha_short_name|| '  allocated channel do not have Media rights please set rights to deal');
          END;
      END LOOP;
      */
      --End Commented as per CR 55912 by Anirudha on 23/05/2012
      IF l_mem_type = 'ROY'
      THEN
         FOR j
            IN (SELECT chr_cha_number, cha_short_name
                  FROM sak_channel_runs, fid_channel
                 WHERE cha_number = chr_cha_number AND cha_roy_flag <> 'Y'
                       AND chr_ald_id IN
                              (SELECT ald_id
                                 FROM sak_allocation_detail
                                WHERE ald_mei_id IN
                                         (SELECT mei_id
                                            FROM sak_memo_item
                                           WHERE mei_mem_id = i_mem_id)) --2432
                                                                        )
         LOOP
            raise_application_error (
               -20602,
               'The allocated Channel ' || j.cha_short_name
               || ' in channel runs requires Royalty rights for Royalty Deals');
         END LOOP;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END prc_check_cha_runs_rights;

   PROCEDURE prc_check_prog_bo_category (
      i_mem_id sak_memo_item.mei_mem_id%TYPE)
   AS
      l_dmps_mapp_id             NUMBER;
      l_cha_short_name           fid_channel.cha_short_name%TYPE;
      l_gen_title                fid_general.gen_title%TYPE;
      l_gen_type                 fid_general.gen_type%TYPE;
      l_gen_prog_category_code   fid_general.gen_prog_category_code%TYPE;
      l_gen_bo_category_code     fid_general.gen_bo_category_code%TYPE;
      l_gen_bo_revenue_usd       fid_general.gen_bo_revenue_usd%TYPE;
   BEGIN
      FOR i IN (SELECT mei_id, mei_gen_refno
                  FROM sak_memo_item
                 WHERE mei_mem_id = i_mem_id                            --2432
                                            )
      LOOP
         SELECT gen_title,
                gen_type,
                gen_prog_category_code,
                gen_bo_category_code,
                gen_bo_revenue_usd
           INTO l_gen_title,
                l_gen_type,
                l_gen_prog_category_code,
                l_gen_bo_category_code,
                l_gen_bo_revenue_usd
           FROM fid_general
          WHERE gen_refno = i.mei_gen_refno
                AND gen_type IN
                       (SELECT cpt_gen_type FROM sgy_pb_costed_prog_type);

         IF (l_gen_prog_category_code IS NULL) AND (l_gen_type = 'TV')
         THEN
            raise_application_error (
               -20602,
               'For ' || REPLACE (l_gen_title, ':', '-')
               || ' the fields Prog. Category is  mandatory since Prog. Type is TV.');
         END IF;

         IF (   l_gen_prog_category_code IS NULL
             OR l_gen_bo_category_code IS NULL
             OR l_gen_bo_revenue_usd IS NULL)
            AND (l_gen_type = 'FEA' OR l_gen_type = 'LIB')
         THEN
            raise_application_error (
               -20602,
               'For ' || REPLACE (l_gen_title, ':', '-')
               || ' the fields Prog. Category, BO Category, BO Revenue USD are mandatory since Prog. Type is FEA or LIB.');
         END IF;
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END prc_check_prog_bo_category;

   -- Commented as per CR 55912 by Anirudha on 23/05/2012
   /*PROCEDURE prc_check_media_rights
   (
       i_mem_id    sak_memo_item.mei_mem_id%type
   )
   AS
       l_dmps_mapp_id number;
       l_cha_short_name  fid_channel.cha_short_name%type;
   BEGIN
       FOR i IN
       (    SELECT chr_cha_number
               ,cha_mpsm_mapp_id
           FROM   sak_channel_runs
               ,fid_channel
           WHERE  cha_number = chr_cha_number
           AND    chr_ald_id in (    SELECT ald_id
                       FROM sak_allocation_detail
                       WHERE ald_mei_id IN (    SELECT mei_id
                                   FROM sak_memo_item
                                   WHERE mei_mem_id =i_mem_id )) --2432
                                   )
       LOOP
           BEGIN
               select    dmps_mapp_id
               into    l_dmps_mapp_id
               from    sgy_pb_dm_med_plat_service
               where    dmps_mem_id = i_mem_ID
               and    dmps_mapp_id = i.cha_mpsm_mapp_id
               ;
           EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
               select cha_short_name
               into   l_cha_short_name
               from   fid_channel
               where  cha_number = i.chr_cha_number
               ;
               raise_application_error (-20601,'The '||l_cha_short_name|| '  allocated channel do not have Media rights please set rights to deal');
           END;
       END LOOP;
   EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
       NULL;
   END prc_check_media_rights;
   */
   --End Commented as per CR 55912 by Anirudha on 23/05/2012
   --- END Bioscope Changes Added by Anirudha on 17/04/2012 to validate ROY Check

   --- Bioscope Changes Added by Nilesh on 17/04/2012 to get QA Required----
   FUNCTION qarequired (i_mem_id IN NUMBER)
      RETURN VARCHAR2
   IS
      l_qa_req   VARCHAR2 (1);
   BEGIN
      DECLARE
         l_qa_req_flag   NUMBER;
         l_count         NUMBER;
         l_qa_req        VARCHAR2 (1);
      BEGIN
         l_qa_req_flag := 0;
         l_qa_req := '';

         SELECT COUNT (*)
           INTO l_qa_req_flag
           FROM fid_company fc, sak_memo sm
          WHERE     fc.com_number = sm.mem_com_number
                AND fc.com_qa_required = 'Y'
                AND fc.com_type = 'S'
                AND sm.mem_id = i_mem_id;

         IF l_qa_req_flag > 0
         THEN
            l_qa_req := 'Y';
         ELSE
            l_qa_req := 'N';
         END IF;

         RETURN (l_qa_req);
      END;
   END qarequired;

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for Deal memo making media service/plat implementation on programme level */
   PROCEDURE prc_srch_media_serv_plat (
      i_mem_id           IN     sak_memo_item.mei_mem_id%TYPE,
      i_mei_id           IN     sak_memo_item.mei_id%TYPE,
      o_search_details      OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_search_details FOR
           SELECT mpsm_mapp_id,
                  mpsm_mapp_service_code,
                  mpsm_mapp_platform_code,
                  (SELECT 'Y'
                     FROM sgy_pb_dm_med_plat_serv
                    WHERE     dmps_mapp_id = mpsm_mapp_id
                          AND dmps_mem_id = i_mem_id
                          AND dmps_mei_id = i_mei_id)
                     check_flag
             FROM sgy_pb_med_platm_service_map
         ORDER BY mpsm_mapp_service_code, mpsm_mapp_platform_code;
   END prc_srch_media_serv_plat;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for Deal memo making media service/plat implementation on programme level */
   --Added for inserting new media service/platform---
   PROCEDURE prc_insert_media_service_plat (i_mapp_id   IN     NUMBER,
                                            i_mem_id    IN     NUMBER,
                                            i_mei_id    IN     NUMBER,
                                            i_user_id   IN     VARCHAR2,
                                            o_status       OUT NUMBER)
   AS
      l_dmps_id            NUMBER;
      l_lmps_id            NUMBER;
      l_dup_record_error   VARCHAR2 (300);
      l_rec_count          NUMBER;
   BEGIN
      o_status := -1;

      SELECT COUNT (*)
        INTO l_rec_count
        FROM sgy_pb_dm_med_plat_serv
       WHERE     dmps_mem_id = i_mem_id
             AND dmps_mapp_id = i_mapp_id
             AND dmps_mei_id = i_mei_id;

      IF l_rec_count = 0
      THEN
         l_dmps_id := seq_pb_dm_med_plat_service.NEXTVAL;

         BEGIN
            INSERT INTO sgy_pb_dm_med_plat_serv (dmps_id,
                                                 dmps_mem_id,
                                                 dmps_mapp_id,
                                                 dmps_entry_oper,
                                                 dmps_entry_date,
                                                 dmps_mei_id)
                 VALUES (l_dmps_id,
                         i_mem_id,
                         i_mapp_id,
                         i_user_id,
                         SYSDATE,
                         i_mei_id);
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               SELECT    'Media Service '
                      || mpsm_mapp_service_code
                      || ' and Media Platform '
                      || mpsm_mapp_platform_code
                 INTO l_dup_record_error
                 FROM sgy_pb_med_platm_service_map
                WHERE mpsm_mapp_id = i_mapp_id;

               raise_application_error (
                  -20349,
                  l_dup_record_error
                  || ' Combination alredy exist for this Deal.');
            WHEN OTHERS
            THEN
               raise_application_error (-20349, SUBSTR (SQLERRM, 1, 200));
         END;
      END IF;

      COMMIT;
      o_status := 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20349, SUBSTR (SQLERRM, 1, 200));
   END prc_insert_media_service_plat;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for Deal memo making media service/plat implementation on programme level */
   ---Procedure for deleting media service/platform---------
   PROCEDURE prc_delete_media_service_plat (i_mapp_id   IN     NUMBER,
                                            i_mem_id    IN     NUMBER,
                                            i_mei_id    IN     NUMBER,
                                            i_user_id   IN     VARCHAR2,
                                            o_status       OUT NUMBER)
   AS
      l_flag   NUMBER;
   BEGIN
      DELETE sgy_pb_dm_med_plat_serv
       WHERE     dmps_mem_id = i_mem_id
             AND dmps_mapp_id = i_mapp_id
             AND dmps_mei_id = i_mei_id;

      l_flag := SQL%ROWCOUNT;

      IF l_flag <> 0
      THEN
         o_status := 1;
         COMMIT;
      ELSE
         o_status := -1;
         ROLLBACK;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20349, SUBSTR (SQLERRM, 1, 200));
   END prc_delete_media_service_plat;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for Deal memo making media service/plat implementation on programme level */
   ---Procedure for copying media service/platform---------
   PROCEDURE prc_copy_media_service_plat (i_mem_id_from      IN     NUMBER,
                                          i_mei_id_from      IN     NUMBER,
                                          i_mei_id_to_list   IN     VARCHAR2,
                                          i_user_id          IN     VARCHAR2,
                                          o_status              OUT NUMBER)
   AS
      l_dmps_id     sgy_pb_dm_med_plat_serv.dmps_id%TYPE;
      l_string      VARCHAR2 (200);
      l_string2     VARCHAR2 (200);
      l_mei_to_id   VARCHAR2 (200);
      l_mapp_id     NUMBER;
   BEGIN
      o_status := -1;
      l_string2 := i_mei_id_to_list;

      WHILE (l_string2 IS NOT NULL)
      LOOP
         IF INSTR (l_string2, ',') > 0
         THEN
            l_mei_to_id := SUBSTR (l_string2, 1, INSTR (l_string2, ',') - 1);
            l_string2 :=
               SUBSTR (l_string2,
                       INSTR (l_string2, ',') + 1,
                       LENGTH (l_string2));
         --      DBMS_OUTPUT.put_line (l_mei_to_id);
         --     DBMS_OUTPUT.put_line (l_string2);
         ELSE
            l_mei_to_id := l_string2;
            l_string2 := NULL;
         END IF;

         ---deleting the previous media/plat associated with the deal
         DELETE FROM sgy_pb_dm_med_plat_serv
               WHERE dmps_mem_id = i_mem_id_from
                     AND dmps_mei_id = l_mei_to_id;

         COMMIT;

         --  INSERTING VALUES OF THE GIVEN DEAL TO THE LIST OF DEALS SELECTED
         FOR i
            IN (SELECT dmps_mapp_id
                  FROM sgy_pb_dm_med_plat_serv
                 WHERE dmps_mem_id = i_mem_id_from
                       AND dmps_mei_id = i_mei_id_from)
         LOOP
            SELECT seq_pb_dm_med_plat_service.NEXTVAL
              INTO l_dmps_id
              FROM DUAL;

            INSERT INTO sgy_pb_dm_med_plat_serv (dmps_id,
                                                 dmps_mem_id,
                                                 dmps_mapp_id,
                                                 dmps_entry_oper,
                                                 dmps_entry_date,
                                                 dmps_mei_id)
                 VALUES (l_dmps_id,
                         i_mem_id_from,
                         i.dmps_mapp_id,
                         i_user_id,
                         SYSDATE,
                         l_mei_to_id);
         END LOOP;
      END LOOP;

      COMMIT;
      o_status := 1;
   --    DBMS_OUTPUT.put_line ('o_status - ' || o_status);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END prc_copy_media_service_plat;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   -------------------------------------- PROCEDURE TO add SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_viewsplitpayment (
      i_mem_id          IN     sak_memo.mem_id%TYPE,
      o_paymentresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_paymentresult FOR
         SELECT msp_id,
                msp_mem_id,
                msp_split_month_num,
                msp_percent_payment,
                msp_sort_order,
                msp_entry_oper,
                msp_entry_date,
                msp_comments
           FROM sgy_sak_memo_split_payment
          WHERE msp_mem_id = i_mem_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20392, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_viewsplitpayment;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   -------------------------------------- PROCEDURE TO add SPLIT PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_addsplitpayment (
      i_mem_id           IN     sgy_sak_memo_split_payment.msp_mem_id%TYPE,
      i_sort_order       IN     sgy_sak_memo_split_payment.msp_sort_order%TYPE,
      i_month_num        IN     sgy_sak_memo_split_payment.msp_split_month_num%TYPE,
      i_comment          IN     sgy_sak_memo_split_payment.msp_comments%TYPE,
      i_pct_pay          IN     sgy_sak_memo_split_payment.msp_percent_payment%TYPE,
      i_entry_oper       IN     sgy_sak_memo_split_payment.msp_entry_oper%TYPE,
      o_success_number      OUT NUMBER)
   AS
      percentexceeded   EXCEPTION;
      l_paypercentsum   NUMBER := 0;
      l_flag            NUMBER;
      l_msp_id          NUMBER;
   BEGIN
      o_success_number := 0;

      BEGIN
         SELECT SUM (msp_percent_payment)
           INTO l_paypercentsum
           FROM sgy_sak_memo_split_payment
          WHERE msp_mem_id = i_mem_id;
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

      SELECT seq_split_payment.NEXTVAL INTO l_msp_id FROM DUAL;

      INSERT INTO sgy_sak_memo_split_payment (msp_id,
                                              msp_mem_id,
                                              msp_split_month_num,
                                              msp_percent_payment,
                                              msp_sort_order,
                                              msp_entry_oper,
                                              msp_entry_date,
                                              msp_comments)
           VALUES (l_msp_id,
                   i_mem_id,
                   i_month_num,
                   i_pct_pay,
                   i_sort_order,
                   i_entry_oper,
                   SYSDATE,
                   i_comment);

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_success_number := l_msp_id;
      END IF;
   EXCEPTION
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
   END prc_adm_cm_addsplitpayment;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   ------------------------------------- PROCEDURE TO UPDATE PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_editsplitpayment (
      i_msp_id           IN     sgy_sak_memo_split_payment.msp_id%TYPE,
      i_mem_id           IN     sgy_sak_memo_split_payment.msp_mem_id%TYPE,
      i_sort_order       IN     sgy_sak_memo_split_payment.msp_sort_order%TYPE,
      i_month_num        IN     sgy_sak_memo_split_payment.msp_split_month_num%TYPE,
      i_comment          IN     sgy_sak_memo_split_payment.msp_comments%TYPE,
      i_pct_pay          IN     sgy_sak_memo_split_payment.msp_percent_payment%TYPE,
      i_entry_oper       IN     sgy_sak_memo_split_payment.msp_entry_oper%TYPE,
      o_success_number      OUT NUMBER)
   AS
      l_flag                 NUMBER;
      l_count                NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
      updatfailed            EXCEPTION;
   BEGIN
      BEGIN
         SELECT COUNT (msp_id)
           INTO l_count
           FROM sgy_sak_memo_split_payment
          WHERE     msp_mem_id = i_mem_id
                AND msp_sort_order = i_sort_order
                AND msp_id = i_msp_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF (l_count = 1)
      THEN
         o_success_number := -1;
      ELSE
         RAISE fieldsalreadypresent;
      END IF;

      IF (o_success_number = -1)
      THEN
            UPDATE sgy_sak_memo_split_payment
               SET msp_split_month_num = i_month_num,
                   msp_percent_payment = i_pct_pay,
                   msp_sort_order = i_sort_order,
                   msp_entry_oper = i_entry_oper,
                   msp_entry_date = SYSDATE,
                   msp_comments = i_comment
             WHERE msp_mem_id = i_mem_id AND msp_id = i_msp_id
         RETURNING msp_id
              INTO l_flag;

         IF (l_flag <> 0)
         THEN
            COMMIT;
            o_success_number := l_flag;
         ELSE
            RAISE updatfailed;
         END IF;
      ELSE
         RAISE fieldsalreadypresent;
      END IF;
   EXCEPTION
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (-20395,
                                  'Order Number for Payment Already Exist.');
      WHEN updatfailed
      THEN
         ROLLBACK;
         raise_application_error (-20396, 'Data Not Updated');
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20397, SUBSTR (SQLERRM, 1, 200));
   END prc_adm_cm_editsplitpayment;

   /* PB (CR) : End */

   /* PB (CR) :Pranay Kusumwal 18/06/2012 : Added for CR for new payment terms for royalty */
   ------------------------------------- PROCEDURE TO DELETE PAYMENT -----------------------------------------
   PROCEDURE prc_adm_cm_deletesplitpayment (
      i_msp_id           IN     sgy_sak_memo_split_payment.msp_id%TYPE,
      i_mem_id           IN     sgy_sak_memo_split_payment.msp_mem_id%TYPE,
      o_paymentdeleted      OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
   BEGIN
      o_paymentdeleted := -1;

      BEGIN
         DELETE FROM sgy_sak_memo_split_payment
               WHERE msp_id = i_msp_id AND msp_mem_id = i_mem_id;
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
   END prc_adm_cm_deletesplitpayment;

   /* PB (CR) : End */

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will ADD the values for catchup licensee grid ALLOCATION*/
   PROCEDURE prc_add_catchup_alloc_details (
      i_mei_id                  IN     sak_memo_item.mei_id%TYPE,
      -- i_mei_type_show      IN       sak_memo_item.mei_type_show%TYPE,
      i_mei_gen_refno           IN     sak_memo_item.mei_gen_refno%TYPE,
      i_lee_short_name          IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount              IN     sak_allocation_detail.ald_amount%TYPE,
      i_ald_exhib_days          IN     sak_allocation_detail.ald_exhib_days%TYPE,
      i_ald_period_tba          IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_ald_period_start        IN     sak_allocation_detail.ald_period_start%TYPE,
      --   i_cha_number         IN       fid_channel.cha_number%TYPE,
      i_ald_period_end          IN     sak_allocation_detail.ald_period_end%TYPE,
      i_ald_cost_runs           IN     sak_allocation_detail.ald_cost_runs%TYPE,
      i_ald_months              IN     sak_allocation_detail.ald_months%TYPE,
      i_user_id                 IN     sak_allocation_detail.ald_entry_oper%TYPE,
      i_ald_end_days            IN     sak_allocation_detail.ald_end_days%TYPE,
      i_ald_max_vp              IN     sak_allocation_detail.ald_max_vp%TYPE,
      i_ald_non_cons_month      IN     sak_allocation_detail.ald_non_cons_month%TYPE,
      --CACq14:start :Adde by sushma on 11-NOV-2014 to insert newly added fields in catch up allocation grid
      i_ALLOW_BEFORE_LNR        IN     sak_allocation_detail.ALD_ALLOW_BEFORE_LNR%TYPE,
      i_ALLOW_DAYS_BEFORE_LNR   IN     sak_allocation_detail.ALD_ALLOW_DAYS_BEFORE_LNR%TYPE,
      i_ALLOW_WITHOUT_LNR_REF   IN     sak_allocation_detail.ALD_ALLOW_WITHOUT_LNR_REF%TYPE, --END
      o_ald_id                     OUT sak_allocation_detail.ald_id%TYPE)
   AS
      l_alloc_exists       NUMBER;
      l_cha_number         NUMBER;
      l_date               DATE;
      l_time               NUMBER;
      l_message            VARCHAR2 (200);
      l_lee_number         NUMBER;
      alloc_exists         EXCEPTION;
      live_info_required   EXCEPTION;
      l_o_flag             NUMBER;
      l_message            VARCHAR2 (200);
      l_func_max_vp_rslt   VARCHAR2(1);
      L_SERIES_TITLE       varchar2(120);
      norights             EXCEPTION;
   BEGIN
      SELECT lee_number
        INTO l_lee_number
        FROM fid_licensee
       WHERE lee_short_name = i_lee_short_name;

      /*   SELECT COUNT (*)
           INTO l_alloc_exists
           FROM sak_allocation_detail
          WHERE
          ald_chs_number = i_cha_number          AND
          ald_lee_number = l_lee_number
            AND ald_mei_id = i_mei_id;

         IF (l_alloc_exists = 0)
         THEN */
      o_ald_id := get_seq ('SEQ_ALD_ID');

      INSERT INTO sak_allocation_detail (ald_id,
                                         ald_mei_id,
                                         ald_lee_number,
                                         ald_amount,
                                         ald_exhib_days,
                                         ald_period_tba,
                                         ald_period_start,
                                         ald_period_end,
                                         ald_cost_runs,
                                         ald_months,
                                         ald_end_days,
                                         ald_entry_oper,
                                         ald_entry_date,
                                         ald_max_vp,
                                         ald_non_cons_month,
                                         ald_update_count,
                                         ald_black_days --CACq14:start :Adde by sushma on 11-NOV-2014 to insert newly added fields in catch up allocation grid
                                                       ,
                                         ALD_ALLOW_BEFORE_LNR,
                                         ALD_ALLOW_DAYS_BEFORE_LNR,
                                         ALD_ALLOW_WITHOUT_LNR_REF       --End
                                                                  )
           VALUES (o_ald_id,
                   i_mei_id,
                   l_lee_number,
                   i_ald_amount,
                   i_ald_exhib_days,
                   i_ald_period_tba,
                   i_ald_period_start,
                   i_ald_period_end,
                   i_ald_cost_runs,
                   i_ald_months,
                   i_ald_end_days,
                   i_user_id,
                   SYSDATE,
                   i_ald_max_vp,
                   i_ald_non_cons_month,
                   --'N',
                   0,
                   0 --CACq14:start :Adde by sushma on 11-NOV-2014 to insert newly added fields in catch up allocation grid
                    ,
                   i_ALLOW_BEFORE_LNR,
                   i_ALLOW_DAYS_BEFORE_LNR,
                   i_ALLOW_WITHOUT_LNR_REF                               --END
                                          );

      DELETE x_fin_dm_sec_lee
       WHERE dsl_mei_id = i_mei_id AND dsl_lee_number = l_lee_number;

      ---Dev2:Pure Finance:Start:[Hari Mandal]_[18/4/2013]
      INSERT INTO x_fin_dm_sec_lee (dsl_number,
                                    dsl_mei_id,
                                    dsl_lee_number,
                                    dsl_is_primary,
                                    dsl_amount,
                                    dsl_entry_oper,
                                    dsl_entry_date,
                                    dsl_update_count,
                                    dsl_primary_lee)
           VALUES (seq_dsl_id.NEXTVAL,
                   i_mei_id,
                   l_lee_number,
                   'Y',
                   i_ald_amount,
                   i_user_id,
                   SYSDATE,
                   0,
                   l_lee_number);

      ---Dev2:Pure Finance:End-----------------------------
      COMMIT;
   /* ELSE
       RAISE alloc_exists;
    END IF;*/
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         raise_application_error (
            -20001,
               'Duplicate Licensee for deal '
            || i_mei_id
            || ' l_lee_number '
            || l_lee_number);
      WHEN alloc_exists
      THEN
         raise_application_error (
            -20001,
            'Allocation already exists for this Licensee');
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_add_catchup_alloc_details;

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will update the values for catchup licensee grid ALLOCATION*/
   PROCEDURE prc_upd_catchup_alloc_details (
      i_mei_id                  IN     sak_memo_item.mei_id%TYPE,
      i_ald_id                  IN     sak_allocation_detail.ald_id%TYPE,
      i_mei_gen_refno           IN     sak_memo_item.mei_gen_refno%TYPE,
      i_mem_amort_method        IN     sak_memo.mem_amort_method%TYPE,
      i_lee_short_name          IN     fid_licensee.lee_short_name%TYPE,
      i_ald_amount              IN     sak_allocation_detail.ald_amount%TYPE,
      i_ald_exhib_days          IN     sak_allocation_detail.ald_exhib_days%TYPE,
      i_ald_period_tba          IN     sak_allocation_detail.ald_period_tba%TYPE,
      i_ald_period_start        IN     sak_allocation_detail.ald_period_start%TYPE,
      --  i_cha_number         IN       fid_channel.cha_number%TYPE,
      i_ald_period_end          IN     sak_allocation_detail.ald_period_end%TYPE,
      i_ald_months              IN     sak_allocation_detail.ald_months%TYPE,
      i_ald_end_days            IN     sak_allocation_detail.ald_end_days%TYPE,
      i_ald_max_vp              IN     sak_allocation_detail.ald_max_vp%TYPE,
      i_ald_non_cons_month      IN     sak_allocation_detail.ald_non_cons_month%TYPE,
      i_ald_cost_runs           IN     sak_allocation_detail.ald_cost_runs%TYPE,
      --CACq14:start :Adde by sushma on 11-NOV-2014 to insert newly added fields in catch up allocation grid
      i_ALLOW_BEFORE_LNR        IN     sak_allocation_detail.ALD_ALLOW_BEFORE_LNR%TYPE,
      i_ALLOW_DAYS_BEFORE_LNR   IN     sak_allocation_detail.ALD_ALLOW_DAYS_BEFORE_LNR%TYPE,
      i_ALLOW_WITHOUT_LNR_REF   IN     sak_allocation_detail.ALD_ALLOW_WITHOUT_LNR_REF%TYPE, --END
      o_ald_update_count        IN OUT sak_allocation_detail.ald_update_count%TYPE)
   AS
      l_lee_number        NUMBER;
      -- l_cha_number    NUMBER;
      l_ald_lee_number    NUMBER;
      l_ald_chs_number    NUMBER;
      l_alloc_exists      NUMBER;
      l_rec_exists        NUMBER;
      update_failed       EXCEPTION;
      alloc_exists        EXCEPTION;
      l_original_lee      NUMBER;
      l_original_amount   NUMBER;
      l_func_max_vp_rslt  VARCHAR2(1);
      L_SERIES_TITLE      VARCHAR2(120);
   BEGIN
      SELECT lee_number
        INTO l_lee_number
        FROM fid_licensee, fid_company
       WHERE     lee_cha_com_number = com_number
             AND com_type = 'CC'
             AND lee_short_name = i_lee_short_name;

      SELECT COUNT (1)
        INTO l_rec_exists
        FROM sak_allocation_detail
       WHERE     ald_id = i_ald_id
             AND ald_mei_id = i_mei_id
             AND ald_update_count = o_ald_update_count;

      SELECT ald_lee_number
        INTO l_original_lee
        FROM sak_allocation_detail
       WHERE ald_mei_id = i_mei_id AND ald_id = i_ald_id;

      SELECT ald_amount
        INTO l_original_amount
        FROM sak_allocation_detail
       WHERE ald_mei_id = i_mei_id AND ald_id = i_ald_id;

      /*  select  COUNT(1) into  L_ALLOC_EXISTS
        from    sak_allocation_detail
        where       ALD_MEI_ID = I_MEI_ID and ALD_LEE_NUMBER = L_LEE_NUMBER
         and   ALD_CHS_NUMBER = I_CHA_NUMBER and ald_id<>i_ald_id     ;*/
      IF (l_rec_exists = 1)
      THEN
            /*if L_ALLOC_EXISTS >= 1 then
             RAISE alloc_exists;
             else*/
            UPDATE sak_allocation_detail
               SET ald_lee_number = l_lee_number,
                   ald_amount = i_ald_amount,
                   ald_exhib_days = i_ald_exhib_days,
                   ald_period_tba = i_ald_period_tba,
                   ald_period_start = i_ald_period_start,
                   ald_period_end = i_ald_period_end,
                   ald_months = i_ald_months,
                   ald_end_days = i_ald_end_days,
                   ald_max_vp = i_ald_max_vp,
                   ald_non_cons_month = i_ald_non_cons_month,
                   ald_update_count = ald_update_count + 1,
                   ald_cost_runs = i_ald_cost_runs --CACq14:start :Adde by sushma on 11-NOV-2014 to insert newly added fields in catch up allocation grid
                                                  ,
                   ALD_ALLOW_BEFORE_LNR = i_ALLOW_BEFORE_LNR,
                   ALD_ALLOW_DAYS_BEFORE_LNR = i_ALLOW_DAYS_BEFORE_LNR,
                   ALD_ALLOW_WITHOUT_LNR_REF = i_ALLOW_WITHOUT_LNR_REF  -- END
             WHERE     ald_mei_id = i_mei_id
                   AND ald_id = i_ald_id
                   AND ald_update_count = o_ald_update_count
         RETURNING ald_update_count
              INTO o_ald_update_count;

         IF o_ald_update_count > 0
         THEN
            IF l_original_amount <> i_ald_amount
            THEN
               UPDATE x_fin_dm_sec_lee
                  SET dsl_amount = i_ald_amount
                WHERE     dsl_is_primary = 'Y'
                      AND dsl_mei_id = i_mei_id
                      AND dsl_primary_lee = l_original_lee;
            END IF;

            IF l_original_lee <> l_lee_number
            THEN
               UPDATE x_fin_dm_sec_lee
                  SET dsl_lee_number = l_lee_number,
                      dsl_primary_lee = l_lee_number
                WHERE     dsl_is_primary = 'Y'
                      AND dsl_mei_id = i_mei_id
                      AND dsl_primary_lee = l_original_lee;
            END IF;

            COMMIT;
         ELSE
            RAISE update_failed;
         END IF;
      -- end if;
      END IF;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         raise_application_error (
            -20002,
            'Allocation already exists for this Licensee');
      WHEN alloc_exists
      THEN
         raise_application_error (
            -20001,
            'Allocation already exists for this Licensee');
      WHEN update_failed
      THEN
         raise_application_error (
            -20013,
            'Update Failed' || SUBSTR (SQLERRM, 1, 150));
      WHEN OTHERS
      THEN
         raise_application_error (-20013, SUBSTR (SQLERRM, 1, 150));
   END prc_upd_catchup_alloc_details;

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will add the values for catchup licensee platform */
   PROCEDURE prc_add_catchup_platform (
      i_ald_id           IN     sak_allocation_detail.ald_id%TYPE,
      i_mapp_id          IN     sgy_pb_med_platm_service_map.mpsm_mapp_id%TYPE,
      o_sucess_integer      OUT NUMBER,
      o_plat_integer        OUT NUMBER)
   AS
      l_cp_id   NUMBER;
      l_flag    NUMBER;
   BEGIN
      SELECT x_cp_lee_plat_seq.NEXTVAL INTO l_cp_id FROM DUAL;

      INSERT
        INTO x_cp_licensee_platform (cp_lee_plat_id,
                                     cp_lee_plat_ald_id,
                                     cp_lee_plat_mpsm_mapp_id)
      VALUES (l_cp_id, i_ald_id, i_mapp_id);

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_sucess_integer := i_ald_id;
         o_plat_integer := l_cp_id;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_add_catchup_platform;

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will edit the values for catchup licensee platform */
   PROCEDURE prc_update_catchup_platform (
      i_lee_plat_id      IN     x_cp_licensee_platform.cp_lee_plat_id%TYPE,
      --i_mapp_id in sgy_pb_med_platm_service_map.MPSM_MAPP_ID%type,
      o_sucess_integer      OUT NUMBER)
   AS
      l_flag        NUMBER;
      updatfailed   EXCEPTION;
   BEGIN
      DELETE FROM x_cp_licensee_platform
            WHERE cp_lee_plat_id = i_lee_plat_id
        /*UPDATE X_CP_LICENSEE_PLATFORM
        SET CP_LEE_PLAT_MPSM_MAPP_ID = null
        where CP_LEE_PLAT_ID=i_lee_plat_id*/
        RETURNING cp_lee_plat_id
             INTO l_flag;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_sucess_integer := l_flag;
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
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_update_catchup_platform;

   /* Catchup (CR 3) :Pranay Kusumwal 08/10/2012 :Added a new SP which will del the values for catchup licensee platform */
   PROCEDURE prc_delete_catchup_platform (
      i_lee_plat_id      IN     x_cp_licensee_platform.cp_lee_plat_id%TYPE,
      o_sucess_integer      OUT NUMBER)
   AS
      l_flag         NUMBER;
      deldatfailed   EXCEPTION;
   BEGIN
      DELETE x_cp_licensee_platform
       WHERE cp_lee_plat_id = i_lee_plat_id;

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
         o_sucess_integer := 1;
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
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END prc_delete_catchup_platform;

   /* Catchup (CR 3) :Nilesh Pagdal 17/10/2012 : Added for Catch-Up media rights and platforms*/
   PROCEDURE prc_adm_catchup_platform (
      i_mem_id                       IN     NUMBER,
      o_catchup_prog_alloc_details      OUT c_deal_memo_prog_details4)
   AS
   BEGIN
      OPEN o_catchup_prog_alloc_details FOR
         SELECT cp_lee_plat_ald_id,
                mpsm_mapp_id,
                mpsm_mapp_service_code,
                mpsm_mapp_platform_code,
                cp_lee_plat_id
           FROM (SELECT ald_id cp_lee_plat_ald_id,
                        mpsm_mapp_id,
                        mpsm_mapp_service_code,
                        mpsm_mapp_platform_code,
                        (SELECT cp_lee_plat_id
                           FROM x_cp_licensee_platform
                          WHERE cp_lee_plat_ald_id = ald_id
                                AND cp_lee_plat_mpsm_mapp_id = mpsm_mapp_id)
                           cp_lee_plat_id
                   FROM sak_allocation_detail,
                        sak_memo_item,
                        fid_licensee,
                        sgy_pb_med_platm_service_map
                  WHERE     ald_mei_id = mei_id
                        AND ald_lee_number = lee_number
                        AND mei_mem_id = i_mem_id
                        AND mpsm_mapp_service_code = 'CATCHUP'
                        AND NVL (lee_media_service_code, '#') = 'CATCHUP'
                 UNION
                 SELECT NULL cp_lee_plat_ald_id,
                        mpsm_mapp_id,
                        mpsm_mapp_service_code,
                        mpsm_mapp_platform_code,
                        NULL cp_lee_plat_id
                   FROM sgy_pb_med_platm_service_map
                  WHERE mpsm_mapp_service_code = 'CATCHUP')
          WHERE cp_lee_plat_id IS NULL;
   END prc_adm_catchup_platform;

   ------------------------------------------------------
   /* FINANCE (CFIN 3) :Pranay Kusumwal 22/02/2013 :Start*/
   PROCEDURE x_add_sec_lee_alloc_detail (
      i_mei_id           IN     x_fin_dm_sec_lee.dsl_mei_id%TYPE,
      i_lee_short_name   IN     fid_licensee.lee_short_name%TYPE,
      i_primary_lee      IN     fid_licensee.lee_short_name%TYPE,
      i_entry_oper       IN     x_fin_dm_sec_lee.dsl_entry_oper%TYPE,
      i_dsl_amount       IN     x_fin_dm_sec_lee.dsl_amount%TYPE,
      o_dsl_id              OUT x_fin_dm_sec_lee.dsl_number%TYPE)
   AS
      l_alloc_exists      NUMBER;
      l_message           VARCHAR2 (200);
      l_lee_number        NUMBER;
      l_lee_number_prim   NUMBER;
      alloc_exists        EXCEPTION;
      l_split_reg_prim    NUMBER;
      l_cha_com_prim      NUMBER;
      l_split_reg         NUMBER;
      l_cha_com           NUMBER;
      l_dsl_number        NUMBER;
   BEGIN
      o_dsl_id := -1;

      SELECT lee_number, lee_split_region, lee_cha_com_number
        INTO l_lee_number, l_split_reg, l_cha_com
        FROM fid_licensee
       WHERE lee_short_name = i_lee_short_name;

      SELECT lee_number, lee_split_region, lee_cha_com_number
        INTO l_lee_number_prim, l_split_reg_prim, l_cha_com_prim
        FROM fid_licensee
       WHERE lee_short_name = i_primary_lee;

      /*SELECT COUNT (*)
        INTO l_alloc_exists
        FROM x_fin_dm_sec_lee
       WHERE dsl_lee_number = l_lee_number
         AND dsl_mei_id = i_mei_id
         AND dsl_is_primary <> 'Y';*/

      /*if (l_alloc_exists = 0)
      THEN*/
      IF (l_split_reg = l_split_reg_prim) AND (l_cha_com = l_cha_com_prim)
      THEN
         SELECT seq_dsl_id.NEXTVAL INTO l_dsl_number FROM DUAL;

         --l_dsl_number := get_seq ('seq_dsl_id');
         INSERT INTO x_fin_dm_sec_lee (dsl_number,
                                       dsl_mei_id,
                                       dsl_lee_number,
                                       dsl_is_primary,
                                       dsl_amount,
                                       dsl_entry_oper,
                                       dsl_entry_date,
                                       dsl_update_count,
                                       dsl_primary_lee)
              VALUES (l_dsl_number,
                      i_mei_id,
                      l_lee_number,
                      'N',
                      i_dsl_amount,
                      i_entry_oper,
                      SYSDATE,
                      0,
                      l_lee_number_prim);

         o_dsl_id := l_dsl_number;
         COMMIT;
      ELSE
         raise_application_error (
            -20001,
            'The Channel Company and Region of Secondary licensee should be same as that of Primary licensee.');
      END IF;
   /* ELSE
       raise alloc_exists;
    END IF;*/
   EXCEPTION
      /*WHEN alloc_exists
      THEN
         raise_application_error
                               (-20001,
                                'Allocation already exists for this Licensee'
                               );*/
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END x_add_sec_lee_alloc_detail;

   PROCEDURE x_update_sec_lee_alloc_detail (
      i_dsl_id             IN     x_fin_dm_sec_lee.dsl_number%TYPE,
      i_dsl_amount         IN     x_fin_dm_sec_lee.dsl_amount%TYPE,
      i_lee_short_name     IN     fid_licensee.lee_short_name%TYPE,
      --   i_is_primary       IN    x_fin_dm_sec_lee.DSL_IS_PRIMARY%type,
      i_dsl_mei_id         IN     x_fin_dm_sec_lee.dsl_mei_id%TYPE,
      o_dsl_update_count   IN OUT x_fin_dm_sec_lee.dsl_update_count%TYPE)
   AS
      l_lee_number         NUMBER;
      l_ald_lee_number     NUMBER;
      l_alloc_exists       NUMBER;
      l_rec_exists         NUMBER;
      -- Devashish/Shantanu, 30/jan/2014
      l_dsl_update_count   x_fin_dm_sec_lee.dsl_update_count%TYPE;
      --End
      update_failed        EXCEPTION;
      alloc_exists         EXCEPTION;
   BEGIN
      SELECT lee_number
        INTO l_lee_number
        FROM fid_licensee, fid_company
       WHERE     lee_cha_com_number = com_number
             AND com_type = 'CC'
             AND lee_short_name = i_lee_short_name;

      SELECT COUNT (1)
        INTO l_rec_exists
        FROM x_fin_dm_sec_lee
       WHERE     dsl_number = i_dsl_id
             AND dsl_mei_id = i_dsl_mei_id
             AND dsl_update_count = o_dsl_update_count;

      /*SELECT COUNT (1)
        INTO l_alloc_exists
        FROM x_fin_dm_sec_lee
       WHERE dsl_mei_id = i_dsl_mei_id
         AND dsl_lee_number = l_lee_number
         AND dsl_number <> i_dsl_id;*/
      IF (l_rec_exists = 1)
      THEN
         /*IF l_alloc_exists >= 1
         THEN
            raise alloc_exists;
         ELSE*/
         UPDATE x_fin_dm_sec_lee
            SET dsl_lee_number = l_lee_number, dsl_amount = i_dsl_amount
          --dsl_update_count = dsl_update_count + 1
          WHERE i_dsl_mei_id = i_dsl_mei_id AND dsl_number = i_dsl_id;

         --AND dsl_update_count = o_dsl_update_count
         --RETURNING dsl_update_count
         --INTO o_dsl_update_count;

         /*
            AUTHOR : Devashish/Shantanu,
            DATE : 30/jan/2014,
            Description : Update Count Functionality Modified
          */
         SELECT dsl_update_count
           INTO l_dsl_update_count
           FROM x_fin_dm_sec_lee
          WHERE i_dsl_mei_id = i_dsl_mei_id AND dsl_number = i_dsl_id;

         IF (l_dsl_update_count = o_dsl_update_count)
         THEN
            UPDATE x_fin_dm_sec_lee
               SET dsl_update_count = dsl_update_count + 1
             WHERE i_dsl_mei_id = i_dsl_mei_id AND dsl_number = i_dsl_id;

            COMMIT;

            SELECT dsl_update_count
              INTO o_dsl_update_count
              FROM x_fin_dm_sec_lee
             WHERE i_dsl_mei_id = i_dsl_mei_id AND dsl_number = i_dsl_id;
         ELSE
            ROLLBACK;
            raise_application_error (
               -20327,
               'Seconadry licensee allocation details has been changed by other user');
         END IF;

         /************************End Of the Update count Functionality*******************/
         IF o_dsl_update_count > 0
         THEN
            COMMIT;
         ELSE
            RAISE update_failed;
         END IF;
      -- END IF;
      END IF;
   EXCEPTION
      /*WHEN alloc_exists
      THEN
         raise_application_error
                               (-20001,
                                'Allocation already exists for this Licensee'
                               );*/
      WHEN update_failed
      THEN
         raise_application_error (
            -20013,
            'Update Failed' || SUBSTR (SQLERRM, 1, 150));
      WHEN OTHERS
      THEN
         raise_application_error (-20013, SUBSTR (SQLERRM, 1, 150));
   END x_update_sec_lee_alloc_detail;

   PROCEDURE x_delete_x_lee_alloc_detail (
      i_dsl_id             IN     x_fin_dm_sec_lee.dsl_number%TYPE,
      i_dsl_update_count   IN     x_fin_dm_sec_lee.dsl_update_count%TYPE,
      o_deleted               OUT NUMBER)
   AS
      l_flag   NUMBER;
   BEGIN
      DELETE FROM x_fin_dm_sec_lee
            WHERE NVL (dsl_update_count, 0) = NVL (i_dsl_update_count, 0)
                  AND dsl_number = i_dsl_id;

      l_flag := SQL%ROWCOUNT;
      o_deleted := l_flag;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
   END x_delete_x_lee_alloc_detail;

   /* FINANCE (CFIN 3) :Pranay Kusumwal 22/02/2013 :END*/
   PROCEDURE x_fin_deal_price_rounding (i_mem_id NUMBER)
   AS
      l_total_lic_price   NUMBER;
      l_extra_deal_amt    NUMBER;
      l_lic_number        NUMBER;
      l_total_lee_price   NUMBER;
      l_extra_lic_amt     NUMBER;
      l_total_pay_price   NUMBER;
      l_extra_pay_amt     NUMBER;
      l_pay_number        NUMBER;
      l_number            NUMBER;
   BEGIN
      SELECT pkg_adm_cm_dealmemo.setglobalvariable ('DMG')
        INTO l_number
        FROM DUAL;

      /*select mem_con_price into l_deal_price from sak_memo where mem_id=i_mem_id;
      select sum(round(lic_price,2)) into l_total_lic_price from fid_license where lic_mem_number=i_mem_id;
      l_extra_deal_amt := l_total_lic_price - l_deal_price ;
      if l_extra_deal_amt <> 0
      then
      select min(lic_number) into l_lic_number from fid_license where lic_mem_number=i_mem_id;
      update fid_license set lic_price = round(lic_price,2) - l_extra_deal_amt
      where lic_number=l_lic_number ;
      end if;*/
      FOR d IN (SELECT mei_id, mei_gen_refno, mei_type_show
                  FROM sak_memo_item
                 WHERE mei_mem_id = i_mem_id)
      LOOP
         FOR k IN (  SELECT dsl_primary_lee, SUM (dsl_amount) licensee_amt
                       FROM x_fin_dm_sec_lee
                      WHERE dsl_mei_id = d.mei_id
                   GROUP BY dsl_primary_lee)
         LOOP
            IF d.mei_type_show = 'FEA'
            THEN
               SELECT SUM (ROUND (lic_price, 2))
                 INTO l_total_lic_price
                 FROM fid_license
                WHERE     lic_mem_number = i_mem_id
                      AND lic_lee_number = k.dsl_primary_lee
                      AND lic_gen_refno = d.mei_gen_refno;
            ELSE
               SELECT SUM (ROUND (lic_price, 2))
                 INTO l_total_lic_price
                 FROM fid_license
                WHERE lic_mem_number = i_mem_id
                      AND lic_lee_number = k.dsl_primary_lee
                      AND lic_gen_refno IN
                             (SELECT gen_refno
                                FROM fid_general
                               WHERE gen_ser_number = d.mei_gen_refno);
            END IF;

            l_extra_deal_amt := l_total_lic_price - k.licensee_amt;

            IF l_extra_deal_amt <> 0
            THEN
               IF d.mei_type_show = 'FEA'
               THEN
                  SELECT MIN (lic_number)
                    INTO l_lic_number
                    FROM fid_license
                   WHERE     lic_mem_number = i_mem_id
                         AND lic_lee_number = k.dsl_primary_lee
                         AND lic_gen_refno = d.mei_gen_refno
                         AND lic_price > 0
                         AND lic_price > l_extra_deal_amt;
               ELSE
                  SELECT MIN (lic_number)
                    INTO l_lic_number
                    FROM fid_license
                   WHERE lic_mem_number = i_mem_id
                         AND lic_lee_number = k.dsl_primary_lee
                         AND lic_gen_refno IN
                                (SELECT gen_refno
                                   FROM fid_general
                                  WHERE gen_ser_number = d.mei_gen_refno)
                         AND lic_price > 0
                         AND lic_price > l_extra_deal_amt;
               END IF;

               UPDATE fid_license
                  SET lic_price = ROUND (lic_price, 2) - l_extra_deal_amt
                WHERE lic_number = l_lic_number;
            END IF;
         END LOOP;
      END LOOP;

      FOR i IN (SELECT lic_number, ROUND (lic_price, 2) lic_price
                  FROM fid_license
                 WHERE lic_mem_number = i_mem_id)
      LOOP
         SELECT SUM (ROUND (lsl_lee_price, 2))
           INTO l_total_lee_price
           FROM x_fin_lic_sec_lee
          WHERE lsl_lic_number = i.lic_number;

         l_extra_lic_amt := l_total_lee_price - i.lic_price;

         IF l_extra_lic_amt <> 0
         THEN
            UPDATE x_fin_lic_sec_lee
               SET lsl_lee_price = ROUND (lsl_lee_price, 2) - l_extra_lic_amt
             WHERE lsl_lic_number = i.lic_number AND lsl_is_primary = 'Y';
         END IF;

         FOR j IN (SELECT lsl_number, ROUND (lsl_lee_price, 2) lsl_lee_price
                     FROM x_fin_lic_sec_lee
                    WHERE lsl_lic_number = i.lic_number)
         LOOP
            SELECT SUM (pay_amount)
              INTO l_total_pay_price
              FROM fid_payment
             WHERE pay_lic_number = i.lic_number
                   AND pay_lsl_number = j.lsl_number;

            l_extra_pay_amt := l_total_pay_price - j.lsl_lee_price;

            IF l_extra_pay_amt <> 0
            THEN
               SELECT MIN (pay_number)
                 INTO l_pay_number
                 FROM fid_payment
                WHERE pay_lic_number = i.lic_number
                      AND pay_lsl_number = j.lsl_number;

               UPDATE fid_payment
                  SET pay_amount = pay_amount - l_extra_pay_amt
                WHERE pay_number = l_pay_number;
            END IF;
         END LOOP;
      END LOOP;

      SELECT pkg_adm_cm_dealmemo.setglobalvariable (NULL)
        INTO l_number
        FROM DUAL;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20345, SUBSTR (SQLERRM, 1, 200));
   END x_fin_deal_price_rounding;

   FUNCTION setglobalvariable (i_user IN VARCHAR2)
      RETURN NUMBER
   IS
      val   NUMBER;
   BEGIN
      val := 0;
      username := i_user;
      RETURN (val);
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20040, SUBSTR (1, 200, SQLERRM));
   END;

   FUNCTION getglobalvariable
      RETURN VARCHAR2
   IS
      usrname   VARCHAR2 (100);
   BEGIN
      usrname := username;
      RETURN usrname;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   PROCEDURE x_prc_check_t_exec_rights (
      i_dm_number              IN     sak_memo.MEM_ID%TYPE,
      i_proc_type              IN     sak_memo.MEM_CON_PROCUREMENT_TYPE%TYPE,
      i_contract_number        IN     fid_contract.con_short_name%TYPE,
      i_user_id                IN     sak_memo.MEM_ENTRY_OPER%TYPE,
      o_t_exc_right               OUT VARCHAR2,
      o_t_exc_proc_type           OUT VARCHAR2 --Dev.R3 : UID_Placeholder CR : Start : [Devashish Raverkar]_[2014/06/02]
                                              ,
      o_t_exc_is_con_act_lic      OUT VARCHAR2 --Dev.R3 : UID_Placeholder CR : End :
                                              )
   AS
      l_count           NUMBER;
      --l_count_prc NUMBER;
      l_proc_is_t_exc   fid_code.cod_attr%TYPE;
      l_count_lic_act   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM sak_memo_user
       WHERE     UPPER (MEU_USR_ID) = i_user_id
             AND meu_texecute = 'Y'
             AND meu_lee_number = (SELECT mem_lee_number
                                     FROM sak_memo
                                    WHERE MEM_ID = i_dm_number); -- changes done by nasreen

      /*select count(*)
      into l_count_prc
      from sak_memo
      where exists (select 1 from fid_code
        where cod_type like 'PROCUREMENT_TYPE'
        and cod_value = upper(MEM_CON_PROCUREMENT_TYPE)
        and cod_attr ='Y'
        )
      and MEM_ID =i_dm_number
      ;*/

      SELECT cod_attr
        INTO l_proc_is_t_exc
        FROM fid_code
       WHERE cod_type LIKE 'PROCUREMENT_TYPE'
             AND cod_value = UPPER (i_proc_type);

      --Dev.R3 : UID_Placeholder CR : Start : [Devashish Raverkar]_[2014/06/02]
      SELECT COUNT (*)
        INTO l_count_lic_act
        FROM fid_license
       WHERE lic_status = 'A'
             AND lic_con_number IN
                    (SELECT con_number
                       FROM fid_contract
                      WHERE con_short_name = i_contract_number);

      --Dev.R3 : UID_Placeholder CR : End :

      IF l_count > 0
      THEN
         o_t_exc_right := 'Y';
      ELSE
         o_t_exc_right := 'N';
      END IF;

      o_t_exc_proc_type := l_proc_is_t_exc;

      /*if l_count_prc >0
      then
       o_t_exc_proc_type := 'Y';
      else
       o_t_exc_proc_type := 'N';
      end if;*/

      --Dev.R3 : UID_Placeholder CR : Start : [Devashish Raverkar]_[2014/06/02]
      IF l_count_lic_act > 0
      THEN
         o_t_exc_is_con_act_lic := 'N';
      ELSE
         o_t_exc_is_con_act_lic := 'Y';
      END IF;
   --Dev.R3 : UID_Placeholder CR : End :

   END x_prc_check_t_exec_rights;

   -------------------------------------------------------

   /*BR_15_144- Warner Payment :Rashmi_Tijare:06-07-2015- added for royalty search details for min guranteeplan grid */
   PROCEDURE X_prc_view_min_gurantee_plan (
      i_mem_id           IN     x_dm_mg_pay_plan.DMGP_DM_NUMBER%TYPE,
      o_dealmemoresult      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
   BEGIN
      OPEN o_dealmemoresult FOR
           SELECT DMGP_NUMBER,
                  DMGP_SORT_ORDER,
                  DMGP_SPLIT_MONTH_NO,
                  DMGP_SPLIT_PERCENT,
                  DMGP_COMMENTS,
                  DMGP_UPDATE_COUNT
             FROM x_dm_mg_pay_plan
            WHERE DMGP_DM_NUMBER = i_mem_id
         ORDER BY dmgp_sort_order ASC;
   EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         raise_application_error (-20392, SUBSTR (SQLERRM, 1, 200));
   END X_prc_view_min_gurantee_plan;

   PROCEDURE X_dm_prc_edit_min_gurante_plan (
      i_mem_id           IN     x_dm_mg_pay_plan.DMGP_DM_NUMBER%TYPE,
      i_split_month_no   IN     x_dm_mg_pay_plan.DMGP_SPLIT_MONTH_NO%TYPE,
      i_split_percent    IN     x_dm_mg_pay_plan.DMGP_SPLIT_PERCENT%TYPE,
      i_sort_order       IN     x_dm_mg_pay_plan.DMGP_SORT_ORDER%TYPE,
      i_split_comment    IN     x_dm_mg_pay_plan.DMGP_COMMENTS%TYPE,
      i_entry_oper       IN     x_dm_mg_pay_plan.DMGP_ENTRY_OP%TYPE,
      o_dmpg_number         OUT x_dm_mg_pay_plan.DMGP_NUMBER%TYPE)
   AS
      l_flag                 NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
      percentexceeded        EXCEPTION;
      l_paypercentsum        NUMBER := 0;
      l_o_flag               NUMBER;
      l_message              VARCHAR2 (200);
      norights               EXCEPTION;
   BEGIN
      BEGIN
         SELECT SUM (DMGP_SPLIT_PERCENT) + i_split_percent
           INTO l_paypercentsum
           FROM x_dm_mg_pay_plan
          WHERE DMGP_DM_NUMBER = i_mem_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_paypercentsum := 0;

            NULL;
      END;

      /*  Select i_split_month_no */

      IF (l_paypercentsum > 100)
      THEN
         RAISE percentexceeded;
      END IF;

      o_dmpg_number := SEQ_X_DMGP_NUMBER.NEXTVAL;

      INSERT INTO x_dm_mg_pay_plan (DMGP_NUMBER,
                                    DMGP_DM_NUMBER,
                                    DMGP_SORT_ORDER,
                                    DMGP_SPLIT_MONTH_NO,
                                    DMGP_SPLIT_PERCENT,
                                    DMGP_COMMENTS,
                                    DMGP_ENTRY_OP,
                                    DMGP_ENTRY_DATE)
           VALUES (o_dmpg_number,
                   i_mem_id,
                   i_sort_order,
                   i_split_month_no,
                   i_split_percent,
                   i_split_comment,
                   i_entry_oper,
                   SYSDATE);

      l_flag := SQL%ROWCOUNT;

      IF (l_flag <> 0)
      THEN
         COMMIT;
      ELSE
         RAISE fieldsalreadypresent;
      END IF;
   EXCEPTION
      WHEN norights
      THEN
         ROLLBACK;
         raise_application_error (-20601, l_message);
      WHEN fieldsalreadypresent
      THEN
         ROLLBACK;
         raise_application_error (-20393,
                                  'Order Number for Payment Already Exist.');
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
   END X_dm_prc_edit_min_gurante_plan;

   -- END BR_15_144
   PROCEDURE X_dm_prc_upd_min_gurante_plan (
      i_split_number     IN     x_dm_mg_pay_plan.DMGP_NUMBER%TYPE,
      i_mem_id           IN     x_dm_mg_pay_plan.DMGP_DM_NUMBER%TYPE,
      i_split_month_no   IN     x_dm_mg_pay_plan.DMGP_SPLIT_MONTH_NO%TYPE,
      i_split_percent    IN     x_dm_mg_pay_plan.DMGP_SPLIT_PERCENT%TYPE,
      i_sort_order       IN     x_dm_mg_pay_plan.DMGP_SORT_ORDER%TYPE,
      i_split_comment    IN     x_dm_mg_pay_plan.DMGP_COMMENTS%TYPE,
      i_entry_oper       IN     x_dm_mg_pay_plan.DMGP_ENTRY_OP%TYPE,
      i_update_count     IN     x_dm_mg_pay_plan.DMGP_UPDATE_COUNT%TYPE,
      o_paymentupdated      OUT NUMBER)
   AS
      l_flag                 NUMBER;
      l_count                NUMBER := -1;
      fieldsalreadypresent   EXCEPTION;
      updatfailed            EXCEPTION;
   BEGIN
      BEGIN
         SELECT COUNT (DMGP_NUMBER)
           INTO l_count
           FROM x_dm_mg_pay_plan
          WHERE DMGP_DM_NUMBER = i_mem_id AND DMGP_NUMBER = i_split_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF (l_count = 1)
      THEN
         o_paymentupdated := -1;
      /*ELSE
         RAISE fieldsalreadypresent;*/
      END IF;


      IF (o_paymentupdated = -1)
      THEN
         UPDATE x_dm_mg_pay_plan
            SET DMGP_SPLIT_MONTH_NO = i_split_month_no,
                DMGP_SPLIT_PERCENT = i_split_percent,
                DMGP_COMMENTS = i_split_comment,
                DMGP_SORT_ORDER = i_sort_order,
                DMGP_ENTRY_OP = i_entry_oper
          WHERE DMGP_DM_NUMBER = i_mem_id AND DMGP_NUMBER = i_split_number;


         SELECT DMGP_UPDATE_COUNT
           INTO l_flag
           FROM x_dm_mg_pay_plan
          WHERE DMGP_DM_NUMBER = i_mem_id AND DMGP_NUMBER = i_split_number;

         IF (NVL (l_flag, 0) = NVL (i_update_count, 0))
         THEN
            UPDATE x_dm_mg_pay_plan
               SET DMGP_UPDATE_COUNT = NVL (DMGP_UPDATE_COUNT, 0) + 1
             WHERE DMGP_DM_NUMBER = i_mem_id AND DMGP_NUMBER = i_split_number;

            COMMIT;

            SELECT DMGP_UPDATE_COUNT
              INTO o_paymentupdated
              FROM x_dm_mg_pay_plan
             WHERE DMGP_DM_NUMBER = i_mem_id AND DMGP_NUMBER = i_split_number;
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
   END X_dm_prc_upd_min_gurante_plan;

   PROCEDURE X_dm_prc_del_min_gurante_plan (
      i_dmgp_number      IN     X_DM_MG_PAY_PLAN.DMGP_NUMBER%TYPE,
      i_dmgp_mem_id      IN     X_DM_MG_PAY_PLAN.DMGP_DM_NUMBER%TYPE,
      i_entry_oper       IN     x_dm_mg_pay_plan.DMGP_ENTRY_OP%TYPE,
      i_update_count     IN     X_DM_MG_PAY_PLAN.DMGP_UPDATE_COUNT%TYPE,
      o_paymentdeleted      OUT NUMBER)
   AS
      deldatfailed   EXCEPTION;
      l_flag         NUMBER;
      V_OPERATOR     VARCHAR2 (60);
   BEGIN
      o_paymentdeleted := -1;


      SELECT pkg_cm_username.SetUserName (i_entry_oper)
        INTO V_OPERATOR
        FROM DUAL;

      BEGIN
         DELETE FROM X_DM_MG_PAY_PLAN
               WHERE     DMGP_DM_NUMBER = i_dmgp_mem_id
                     AND DMGP_NUMBER = i_dmgp_number
                     AND NVL (DMGP_UPDATE_COUNT, 0) = i_update_count;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      l_flag := SQL%ROWCOUNT;

      DBMS_OUTPUT.PUT_LINE ('l_flag' || l_flag);

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
   END X_dm_prc_del_min_gurante_plan;

   ---End Warner Payments
   --CACQ14:Start : Added by sushma on 12-NOV-2014 to get the all media device rights
   PROCEDURE prc_get_med_dev_rights (
      i_CON_SHORT_NAME        IN     fid_contract.CON_SHORT_NAME%TYPE,
      i_is_fea_ser            IN     VARCHAR2,
      i_lee_short_name        IN     fid_licensee.lee_short_name%TYPE,
      O_GET_MED_RIGHTS           OUT PKG_ADM_CM_DEALMEMO.CURSOR_DATA,
      o_get_med__dev_rights      OUT pkg_adm_cm_dealmemo.cursor_data)
   AS
      l_con_number               NUMBER;
      l_string                   CLOB;
      l_string1                  CLOB;
      l_string2                  CLOB;
      l_is_fea                   VARCHAR2 (1);
      L_MEDIA_CODE               sgy_pb_media_service.MS_MEDIA_SERVICE_CODE%TYPE;
      l_con_media_service_code   sgy_pb_media_service.MS_MEDIA_SERVICE_CODE%TYPE;
   BEGIN
      BEGIN
         SELECT con_number, MS_MEDIA_SERVICE_CODE
           INTO l_con_number, l_con_media_service_code
           FROM fid_contract, sgy_pb_media_service
          WHERE con_short_name = i_CON_SHORT_NAME
                AND MS_MEDIA_SERVICE_FLAG = con_catchup_Flag;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_con_number := 0;
      END;

      BEGIN
         SELECT LEE_MEDIA_SERVICE_CODE
           INTO L_MEDIA_CODE
           FROM FID_LICENSEE
          WHERE LEE_SHORT_NAME = i_lee_short_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            L_MEDIA_CODE := l_con_media_service_code;
      END;


      SELECT X_FNC_GET_PROG_TYPE (i_is_fea_ser) INTO l_is_fea FROM DUAL;

      l_string := 'select a.Med_dev_code,
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
         || 'a.MPDC_UPDATE_COUNT from (select  MDP_MAP_DEV_ID,
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
         || L_MEDIA_CODE
         || '''

                                          group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a';

      OPEN o_get_med__dev_rights FOR l_string;


      IF l_con_number = 0
      THEN
         OPEN o_get_med_rights FOR l_string;
      ELSIF l_is_fea = 'N' AND l_con_number > 0
      THEN
         l_string := 'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.Rights_On_device,
                            a.CON_IS_FEA_SER,
                            a.MPDC_DEV_PLATM_ID,
                            a.CON_CONTRACT_NUMBER,
                            a.med_device_sch_flag,';

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
               || l_con_number
               || '''),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,';
         END LOOP;

         l_string :=
            l_string
            || 'a.CON_MPDC_UPDATE_COUNT  from (select
                                             MDP_MAP_DEV_ID,
                                            (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                            (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            NVL(CON_RIGHTS_ON_DEVICE,''N'') Rights_On_device,
                                            CON_IS_FEA_SER
                                            ,CON_MPDC_DEV_PLATM_ID MPDC_DEV_PLATM_ID
                                            ,SUM(CON_MPDC_UPDATE_COUNT) CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER,''N'' med_device_sch_flag
                                          from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = '''
            || l_con_number
            || '''
                                          and  CON_IS_FEA_SER = ''FEA''

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
            || 'a.MPDC_UPDATE_COUNT  from (select
                                            MDP_MAP_DEV_ID,
                                            (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                            (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            '' '' RIGHTS_ON_DEVICE,
                                            ''FEA'' IS_FEA_SER
                                            ,MPDC_DEV_PLATM_ID
                                            ,SUM(MPDC_UPDATE_COUNT) MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,''N'' med_device_sch_flag
                                          from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                 and   MPDCS_MPDC_ID  =  MPDC_ID
                                                and MPDCS_MED_SERVICE_CODE = '''
            || L_MEDIA_CODE
            || '''

                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a';

         L_String2 := L_String || ' ' || L_String1;

         --INSERT INTO TEST_TABLE VALUES(L_STRING2);

         OPEN o_get_med_rights FOR l_string2;
      ELSIF l_is_fea = 'Y' AND l_con_number > 0
      THEN
         l_string := 'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.Rights_On_device,
                            a.CON_IS_FEA_SER,
                            a.MPDC_DEV_PLATM_ID,
                            a.CON_CONTRACT_NUMBER,
                            a.med_device_sch_flag,';

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
               || l_con_number
               || '''),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ' ,';
         END LOOP;

         l_string :=
            l_string
            || 'a.CON_MPDC_UPDATE_COUNT  from (select
                                            MDP_MAP_DEV_ID,
                                            (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_code,
                                            (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID ) Med_dev_desc,
                                            MDP_MAP_PLATM_CODE med_platm_code,
                                            (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                            CON_RIGHTS_ON_DEVICE  Rights_On_device,
                                            CON_IS_FEA_SER
                                            ,CON_MPDC_DEV_PLATM_ID  MPDC_DEV_PLATM_ID
                                            ,SUM(CON_MPDC_UPDATE_COUNT) CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER,''N'' med_device_sch_flag
                                          from  x_cp_con_medplatmdevcompat_map,x_cp_media_dev_platm_map
                                          where CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                                          and CON_CONTRACT_NUMBER  = '''
            || l_con_number
            || '''
                                          and  CON_IS_FEA_SER = ''SER''

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
            || 'a.MPDC_UPDATE_COUNT  from (select
                                             MDP_MAP_DEV_ID,
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
            || L_MEDIA_CODE
            || '''

                                           group by MDP_MAP_DEV_ID,
                                                    MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                    --,MPDC_UPDATE_COUNT
                                                 )a';
         l_string2 := l_string || ' ' || l_string1;


         OPEN o_get_med_rights FOR l_string2;
      END IF;
   END prc_get_med_dev_rights;

   --CATCHUP:CACQ14: ADDed By SUSHMA K. on 11-nov-2014
   --To insert thecatch up  media device rights on deal level (program level)
   PROCEDURE prc_add_deal_medplatmdevcomp (
      i_ald_id               IN     sak_allocation_detail.ALD_ID%TYPE,
      i_MPDC_DEV_PLATM_ID    IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_DEV_PLATM_ID%TYPE,
      i_rights_on_device     IN     VARCHAR2,
      i_med_comp_rights      IN     VARCHAR2,
      i_med_IS_COMP_RIGHTS   IN     VARCHAR2,
      i_entry_oper           IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_ENTRY_OPER%TYPE,
      o_status                  OUT NUMBER)
   AS
      l_flag            NUMBER;
      l_memo_count      NUMBER;
      l_media_Service   VARCHAR2 (20);
   BEGIN
      SELECT NVL (lee_media_service_code, '#')
        INTO l_media_Service
        FROM sak_allocation_detail, fid_licensee
       WHERE ald_lee_number = lee_number AND ald_id = i_ald_id;


      SELECT COUNT (1)
        INTO l_memo_count
        FROM x_cp_memo_medplatdevcompat_map
       WHERE MEM_MPDC_ALD_ID = i_ald_id
             AND MEM_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID;


      IF l_memo_count = 0
      THEN
         FOR i
            IN (SELECT COLUMN_VALUE, ROWNUM r
                  FROM TABLE (
                          PKG_PB_MEDIA_PLAT_SER.split_to_char (
                             i_med_comp_rights,
                             ',')))
         LOOP
            INSERT
              INTO x_cp_memo_medplatdevcompat_map (MEM_MPDC_ID,
                                                   MEM_MPDC_ALD_ID,
                                                   MEM_MPDC_DEV_PLATM_ID,
                                                   MEM_RIGHTS_ON_DEVICE,
                                                   MEM_MPDC_COMP_RIGHTS_ID,
                                                   MEM_IS_COMP_RIGHTS,
                                                   MEM_MPDC_ENTRY_OPER,
                                                   MEM_MPDC_ENTRY_DATE,
                                                   MEM_MPDC_UPDATE_COUNT,
                                                   MEM_MPDC_SERVICE_CODE)
            VALUES (X_SEQ_MEM_MPDC_ID.NEXTVAL,
                    i_ald_id,
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
                    l_media_Service);
         END LOOP;
      ELSE
         FOR i
            IN (SELECT COLUMN_VALUE, ROWNUM r
                  FROM TABLE (
                          PKG_PB_MEDIA_PLAT_SER.split_to_char (
                             i_med_comp_rights,
                             ',')))
         LOOP
            UPDATE x_cp_memo_medplatdevcompat_map
               SET MEM_RIGHTS_ON_DEVICE = i_rights_on_device,
                   MEM_MPDC_COMP_RIGHTS_ID =
                      (SELECT COLUMN_VALUE
                         FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                  FROM TABLE (
                                          PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                             i_med_comp_rights,
                                             ','))) a)
                        WHERE r = i.r),
                   MEM_IS_COMP_RIGHTS =
                      (SELECT COLUMN_VALUE
                         FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                  FROM TABLE (
                                          PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                             i_med_IS_COMP_RIGHTS,
                                             ','))) a)
                        WHERE r = i.r),
                   MEM_MPDC_MODIFIED_BY = i_entry_oper,
                   MEM_MPDC_MODIFIED_ON = SYSDATE,
                   MEM_MPDC_UPDATE_COUNT = MEM_MPDC_UPDATE_COUNT + 1
             WHERE     MEM_MPDC_ALD_ID = i_ald_id
                   AND MEM_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID
                   AND MEM_MPDC_COMP_RIGHTS_ID = i.COLUMN_VALUE
                   AND MEM_MPDC_SERVICE_CODE = l_media_Service;
         END LOOP;
      END IF;

      l_flag := SQL%ROWCOUNT;

      IF l_flag > 0
      THEN
         COMMIT;
         o_status := 1;
      ELSE
         ROLLBACK;
         o_status := 0;
      END IF;
   END prc_add_deal_medplatmdevcomp;

   PROCEDURE prc_add_temp_con_rights (
      i_mem_id                  IN     sak_memo.mem_ID%TYPE,
      i_MPDC_DEV_PLATM_ID       IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_DEV_PLATM_ID%TYPE,
      i_rights_on_device        IN     VARCHAR2,
      i_med_comp_rights         IN     VARCHAR2,
      i_med_IS_COMP_RIGHTS      IN     VARCHAR2,
      i_is_fea_ser              IN     VARCHAR2,
      i_ALLOW_BEFORE_LNR        IN     X_CP_temp_ins_CON_MED_rights.CTI_ALLOW_BEFORE_LNR%TYPE,
      i_ALLOW_DAYS_BEFORE_LNR   IN     X_CP_temp_ins_CON_MED_rights.CTI_ALLOW_DAYS_BEFORE_LNR%TYPE,
      i_ALLOW_WITHOUT_LNR_REF   IN     X_CP_temp_ins_CON_MED_rights.CTI_ALLOW_WITHOUT_LNR_REF%TYPE,
      i_entry_oper              IN     x_cp_con_medplatmdevcompat_map.CON_MPDC_ENTRY_OPER%TYPE,
      o_status                     OUT NUMBER)
   AS
      l_flag            NUMBER;
      l_memo_count      NUMBER;
      l_catchup_count   NUMBER := 0;
      l_svod_count      NUMBER := 0;
      L_MEDIA_SERVICE   VARCHAR2 (20);
   BEGIN
      SELECT COUNT (*)
        INTO l_catchup_count
        FROM sak_allocation_detail,
             sak_memo_item,
             sak_memo,
             fid_licensee
       WHERE     ald_mei_id = mei_id
             AND mei_mem_id = mem_id
             AND lee_number = ald_lee_number
             AND MEI_MEM_ID = I_MEM_ID
             AND NVL (lee_media_service_code, 'LINEAR') IN
                    (SELECT MS_MEDIA_SERVICE_CODE
                       FROM SGY_PB_MEDIA_SERVICE
                      WHERE MS_MEDIA_SERVICE_PARENT = 'CATCHUP'); --[23-jun-2015][Jawahar.Garg] --added catchup 3rd party media service


      BEGIN
         SELECT DISTINCT lee_media_service_code
           INTO L_MEDIA_SERVICE
           FROM sak_allocation_detail,
                sak_memo_item,
                sak_memo,
                fid_licensee
          WHERE     ald_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND lee_number = ald_lee_number
                AND mei_mem_id = i_mem_id
                AND NVL (lee_media_service_code, 'LINEAR') IN
                       (SELECT MS_MEDIA_SERVICE_CODE
                          FROM SGY_PB_MEDIA_SERVICE
                         WHERE --MS_MEDIA_SERVICE_CODE not in ('PAYTV','TVOD','CATCHUP'))   --[23-jun-2015][Jawahar.Garg] Commented
                              MS_MEDIA_SERVICE_PARENT = 'SVOD'); --[23-jun-2015][Jawahar.Garg] Added parent identifier for media services

         l_svod_count := 1;    --[14-Jul-2015]Added to set SVOD count variable
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            --l_media_service := 'LINEAR';     --Commented and added null to avoid FK constraint for X_CP_CON_MEDPLATMDEVCOMPAT_MAP
            l_media_service := '';
      END;


      IF l_catchup_count > 0
      THEN
         -- L_MEDIA_SERVICE := 'CATCHUP';
         SELECT DISTINCT lee_media_service_code
           INTO L_MEDIA_SERVICE
           FROM SAK_ALLOCATION_DETAIL,
                sak_memo_item,
                sak_memo,
                fid_licensee
          WHERE     ald_mei_id = mei_id
                AND mei_mem_id = mem_id
                AND lee_number = ald_lee_number
                AND MEI_MEM_ID = I_MEM_ID
                AND NVL (lee_media_service_code, 'LINEAR') IN
                       (SELECT MS_MEDIA_SERVICE_CODE
                          FROM SGY_PB_MEDIA_SERVICE
                         WHERE MS_MEDIA_SERVICE_PARENT = 'CATCHUP');
      END IF;

      SELECT COUNT (1)
        INTO l_memo_count
        FROM X_CP_temp_ins_CON_MED_rights
       WHERE     CTI_MEM_ID = i_mem_id
             AND CTI_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID
             AND CTI_IS_FEA_SER = i_is_fea_ser;

      /* Added If condition to insert data only if media service is catchup or other SVOD service*/
      IF (L_CATCHUP_COUNT > 0 OR L_SVOD_COUNT > 0)
      THEN
         IF l_memo_count = 0
         THEN
            FOR i
               IN (SELECT COLUMN_VALUE, ROWNUM r
                     FROM TABLE (
                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                i_med_comp_rights,
                                ',')))
            LOOP
               INSERT
                 INTO X_CP_temp_ins_CON_MED_rights (CTI_MEM_ID,
                                                    CTI_MPDC_DEV_PLATM_ID,
                                                    CTI_RIGHTS_ON_DEVICE,
                                                    CTI_MPDC_COMP_RIGHTS_ID,
                                                    CTI_IS_COMP_RIGHTS,
                                                    CTI_IS_FEA_SER,
                                                    CTI_MPDC_ENTRY_OPER,
                                                    CTI_MPDC_ENTRY_DATE,
                                                    CTI_MPDC_UPDATE_COUNT,
                                                    CTI_MPDC_SERVICE_CODE,
                                                    CTI_ALLOW_BEFORE_LNR,
                                                    CTI_ALLOW_DAYS_BEFORE_LNR,
                                                    CTI_ALLOW_WITHOUT_LNR_REF)
               VALUES (i_mem_id,
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
                       i_is_fea_ser,
                       i_entry_oper,
                       SYSDATE,
                       0,
                       L_MEDIA_SERVICE,
                       i_ALLOW_BEFORE_LNR,
                       i_ALLOW_DAYS_BEFORE_LNR,
                       i_ALLOW_WITHOUT_LNR_REF);
            END LOOP;
         ELSE
            FOR i
               IN (SELECT COLUMN_VALUE, ROWNUM r
                     FROM TABLE (
                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                i_med_comp_rights,
                                ',')))
            LOOP
               UPDATE X_CP_temp_ins_CON_MED_rights
                  SET CTI_RIGHTS_ON_DEVICE = i_rights_on_device,
                      CTI_MPDC_COMP_RIGHTS_ID =
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_med_comp_rights,
                                                ','))) a)
                           WHERE r = i.r),
                      CTI_IS_COMP_RIGHTS =
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_med_IS_COMP_RIGHTS,
                                                ','))) a)
                           WHERE r = i.r),
                      CTI_MPDC_MODIFIED_BY = i_entry_oper,
                      CTI_MPDC_MODIFIED_ON = SYSDATE,
                      CTI_ALLOW_BEFORE_LNR = i_ALLOW_BEFORE_LNR,
                      CTI_ALLOW_DAYS_BEFORE_LNR = i_ALLOW_DAYS_BEFORE_LNR,
                      CTI_ALLOW_WITHOUT_LNR_REF = i_ALLOW_WITHOUT_LNR_REF,
                      CTI_MPDC_UPDATE_COUNT = CTI_MPDC_UPDATE_COUNT + 1
                WHERE     CTI_MEM_ID = i_mem_id
                      AND CTI_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID
                      AND CTI_MPDC_COMP_RIGHTS_ID = i.COLUMN_VALUE
                      AND CTI_IS_FEA_SER = i_is_fea_ser
                      AND CTI_MPDC_SERVICE_CODE = L_MEDIA_SERVICE;
            END LOOP;
         END IF;                               --[14-Jul-2015]Added by Jawahar
      END IF;

      l_flag := SQL%ROWCOUNT;

      IF l_flag > 0
      THEN
         COMMIT;
         o_status := 1;
      ELSE
         ROLLBACK;
         o_status := 0;
      END IF;
   END prc_add_temp_con_rights;

   --RDT start : Acquision Requirements BR_15_244 [Rashmi_Tijare][18/09/2015]
   PROCEDURE x_prc_add_con_right (
      i_mem_id             IN     sak_memo.mem_ID%TYPE,
      i_DRDT_DEV_ID        IN     VARCHAR2,
      i_rights_on_device   IN     VARCHAR2,
      i_entry_oper         IN     X_DSTV_TEMP_DATA_DEAL.DRDT_MODIFIED_BY%TYPE,
      o_status                OUT NUMBER)
   AS
      l_is_rights_on_device   VARCHAR2 (3);
      deal_num_exist          NUMBER;
      l_DRDT_NUMBER           NUMBER;
      l_flag                  NUMBER;
      l_md_code               VARCHAR2 (20);
      l_count                 NUMBER;
   BEGIN
      SELECT COUNT (1)
        INTO deal_num_exist
        FROM X_DSTV_TEMP_DATA_DEAL
       WHERE DRDT_MEM_ID = i_mem_id;

      IF deal_num_exist = 0
      THEN
         FOR i
            IN (SELECT COLUMN_VALUE, ROWNUM r
                  FROM TABLE (
                          PKG_PB_MEDIA_PLAT_SER.split_to_char (i_DRDT_DEV_ID,
                                                               ',')))
         LOOP
            DBMS_OUTPUT.put_line ('In Loop');


            INSERT INTO X_DSTV_TEMP_DATA_DEAL (DRDT_MEM_ID,
                                               DRDT_DEV_ID,
                                               DRDT_DEV_RIGHTS,
                                               DRDT_MODIFIED_BY,
                                               DRDT_ENTRY_DATE)
                 VALUES (i_mem_id,
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_DRDT_DEV_ID,
                                                ','))) a)
                           WHERE r = i.r),
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_rights_on_device,
                                                ','))) a)
                           WHERE r = i.r),
                         i_entry_oper,
                         SYSDATE);
         END LOOP;
      ELSE                                                    -- update rights
         DELETE X_DSTV_TEMP_DATA_DEAL
          WHERE DRDT_MEM_ID = i_mem_id;

         FOR l
            IN (SELECT COLUMN_VALUE, ROWNUM r
                  FROM TABLE (
                          PKG_PB_MEDIA_PLAT_SER.split_to_char (i_DRDT_DEV_ID,
                                                               ',')))
         LOOP
            INSERT INTO X_DSTV_TEMP_DATA_DEAL (DRDT_MEM_ID,
                                               DRDT_DEV_ID,
                                               DRDT_DEV_RIGHTS,
                                               DRDT_MODIFIED_BY,
                                               DRDT_ENTRY_DATE)
                 VALUES (i_mem_id,
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_DRDT_DEV_ID,
                                                ','))) a)
                           WHERE r = l.r),
                         (SELECT COLUMN_VALUE
                            FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                     FROM TABLE (
                                             PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                i_rights_on_device,
                                                ','))) a)
                           WHERE r = l.r),
                         i_entry_oper,
                         SYSDATE);
         END LOOP;
      END IF;

      FOR k IN (  SELECT mdp_map_platm_code
                    FROM x_cp_media_dev_platm_map
                GROUP BY mdp_map_platm_code)
      LOOP
         SELECT COUNT (1)
           INTO l_count
           FROM X_DSTV_TEMP_DATA_DEAL
          WHERE DRDT_MEM_ID = i_mem_id AND DRDT_DEV_RIGHTS = 'Y'
                AND DRDT_DEV_ID IN
                       (SELECT mdp_map_id
                          FROM x_cp_media_dev_platm_map
                         WHERE mdp_map_platm_code = k.mdp_map_platm_code);

         IF l_count > 0
         THEN
            UPDATE X_DSTV_TEMP_DATA_DEAL
               SET DRDT_PLAT_RIGHTS = 'Y'
             WHERE DRDT_MEM_ID = i_mem_id
                   AND DRDT_DEV_ID IN
                          (SELECT mdp_map_id
                             FROM x_cp_media_dev_platm_map
                            WHERE mdp_map_platm_code = k.mdp_map_platm_code);
         ELSE
            UPDATE X_DSTV_TEMP_DATA_DEAL
               SET DRDT_PLAT_RIGHTS = 'N'
             WHERE DRDT_MEM_ID = i_mem_id
                   AND DRDT_DEV_ID IN
                          (SELECT mdp_map_id
                             FROM x_cp_media_dev_platm_map
                            WHERE mdp_map_platm_code = k.mdp_map_platm_code);
         END IF;
      END LOOP;

      O_Status := 1;
      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_status := -1;
         ROLLBACK;
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END x_prc_add_con_right;

   --RDT End : Acquision Requirements BR_15_244 [Rashmi_Tijare][18/09/2015]
   /****************************************************************
       Function to Split String using Delimiter
       ****************************************************************/
   FUNCTION split_to_char (p_list VARCHAR2, p_del VARCHAR2 := ',')
      RETURN t_in_list_tab
      PIPELINED
   IS
      l_idx    PLS_INTEGER;
      l_list   VARCHAR2 (32767) := p_list;
   BEGIN
      LOOP
         l_idx := INSTR (l_list, p_del);

         IF l_idx > 0
         THEN
            PIPE ROW (SUBSTR (l_list, 1, l_idx - 1));
            l_list := SUBSTR (l_list, l_idx + LENGTH (p_del));
         ELSE
            PIPE ROW (l_list);
            EXIT;
         END IF;
      END LOOP;

      RETURN;
   END split_to_char;

   FUNCTION X_FUN_REMOVE_EXTRA_CHAR (I_TITLE FID_GENERAL.GEN_TITLE%TYPE)
      RETURN VARCHAR2
   IS
      O_TITLE   FID_GENERAL.GEN_TITLE%TYPE;
   BEGIN
      SELECT UPPER (
                RTRIM (
                   LTRIM (
                      REGEXP_REPLACE (
                         REGEXP_REPLACE (
                            REGEXP_REPLACE (
                               (SELECT RTRIM (
                                          XMLAGG (
                                             XMLELEMENT (e, mytext || ' ')).EXTRACT (
                                             '//text()',
                                             ' '))
                                  FROM (SELECT mytext
                                          FROM (    SELECT REGEXP_SUBSTR (
                                                              TRANSLATE (
                                                                 I_TITLE,
                                                                 'a''"><',
                                                                 'a'),
                                                              '[^ ]+',
                                                              1,
                                                              LEVEL)
                                                              AS mytext
                                                      FROM DUAL
                                                CONNECT BY REGEXP_SUBSTR (
                                                              TRANSLATE (
                                                                 I_TITLE,
                                                                 'a''"><',
                                                                 'a'),
                                                              '[^ ]+',
                                                              1,
                                                              LEVEL)
                                                              IS NOT NULL)
                                         WHERE mytext NOT IN
                                                  ('A', 'AN', 'THE'))),
                               '(^(the|a|an) )|( (the|a|an) )',
                               ' ',
                               1,
                               0,
                               'i'),
                            '[^[:alnum:] ]+',
                            '',
                            1,
                            0,
                            'i'),
                         '( ){2,}+',
                         ' ',
                         1,
                         0,
                         'i'))))
        INTO O_TITLE
        FROM DUAL;

      RETURN O_TITLE;
   END;

   PROCEDURE x_prc_dup_title_check (
      i_title       IN     fid_general.GEN_TITLE%TYPE,
      i_pgm_type    IN     fid_general.GEN_TYPE%TYPE,
      i_prod_year          fid_general.GEN_RELEASE_YEAR%TYPE,
      o_search         OUT pkg_adm_cm_dealmemo.c_deal_memo_prog_details)
   AS
      l_title          VARCHAR2 (100);
      l_sorted_title   VARCHAR2 (100);
      l_stmnt          VARCHAR2 (32767);
      l_stmnt_ser      VARCHAR2 (32767);
      l_stmnt_nonser   VARCHAR2 (32767);
      l_count          NUMBER := 0;
      l_pgm_type       fid_general.GEN_TYPE%TYPE;
   BEGIN
      l_sorted_title := PKG_ADM_CM_DEALMEMO.X_FUN_REMOVE_EXTRA_CHAR (i_title);

      DBMS_OUTPUT.put_line ('Sorted Input Title : ' || l_sorted_title);

      l_pgm_type := X_FNC_GET_PROG_TYPE (i_pgm_type);


      IF l_pgm_type = 'Y' OR i_pgm_type IS NULL
      THEN
         l_stmnt_ser :=
            'select gen_title,
                        gen_type,
                        ser_title,
                        gen_release_year,
                        gen_refno,
                        gen_supplier_com_number,
                        supplier_name,
                        gen_subgenre,
                        gen_category,
                        gen_tertiary_genre,
                        gen_event,
                        gen_duration_c,
                        gen_prog_category_code,
                        gen_bo_category_code,
                        gen_bo_revenue_zar,
                        gen_bo_revenue_usd,
                        percent_match,
                        gen_svod_rights,
						null gen_express,
                        null gen_catalogue,
                        null gen_archive
                        from
                        (
                        SELECT
                        ser_title gen_title,
                        ser_type gen_type,
                        ''SERIES'' ser_title,
                        ser_release_year gen_release_year,
                        ser_number gen_refno,
                        ser_com_number gen_supplier_com_number,
                        NVL ( (SELECT com_short_name
                                 FROM fid_company
                                WHERE com_number = ser_com_number),
                             '''')
                           supplier_name,
                        '' '' gen_subgenre,
                        '' '' gen_category,
                        '' '' gen_tertiary_genre,
                        '' '' gen_event,
                        '' '' gen_duration_c,
                        '' '' gen_prog_category_code,
                        '' '' gen_bo_category_code,
                        0 gen_bo_revenue_zar,
                        0 gen_bo_revenue_usd,
                        UTL_MATCH.JARO_WINKLER_SIMILARITY('
            || ''''
            || l_sorted_title
            || ''''
            || ',ser_title_dup) percent_match
                ,decode((select gen_svod_rights from fid_general where gen_ser_number = gen_refno and rownum  = 1),
                                null,
                                ser_svod_rights,
                                (select gen_svod_rights from fid_general where gen_ser_number = gen_refno and rownum  = 1)
                              ) gen_svod_rights
                   FROM fid_series
                  WHERE
                        ser_parent_number = 0
                  )WHERE percent_match >=70
                        ';
      END IF;

      IF i_pgm_type IS NULL OR l_pgm_type = 'N'
      THEN
         l_stmnt_nonser :=
            'select gen_title,
                        gen_type,
                        ser_title,
                        gen_release_year,
                        gen_refno,
                        gen_supplier_com_number,
                        supplier_name,
                        gen_subgenre,
                        gen_category,
                        gen_tertiary_genre,
                        gen_event,
                        gen_duration_c,
                        gen_prog_category_code,
                        gen_bo_category_code,
                        gen_bo_revenue_zar,
                        gen_bo_revenue_usd,
                        percent_match,
                        gen_svod_rights,
                        gen_express,
                        gen_catalogue,
                        gen_archive
                        from
                        (
                        SELECT
                        gen_title,
                        gen_type,
                        ''NON-SERIES'' ser_title,
                        gen_release_year,
                        gen_refno,
                        gen_supplier_com_number,
                        NVL ( (SELECT com_short_name
                                 FROM fid_company
                                WHERE com_number = gen_supplier_com_number),
                             '''')
                           supplier_name,
                        gen_subgenre,
                        gen_category,
                        gen_tertiary_genre,
                        gen_event,
                        gen_duration_c,
                        gen_prog_category_code,
                        gen_bo_category_code,
                        gen_bo_revenue_zar,
                        gen_bo_revenue_usd,
                        UTL_MATCH.JARO_WINKLER_SIMILARITY('
            || ''''
            || l_sorted_title
            || ''''
            || ',gen_title_dup) percent_match
              ,gen_svod_rights
              ,gen_express
              ,gen_catalogue
              ,gen_archive
                   FROM fid_general
                  Where
                   GEN_TYPE IN (select cod_value from fid_code where cod_attr1=''N'')
              )WHERE percent_match >=70

                  ';
      END IF;



      IF i_prod_year IS NOT NULL
      THEN
         IF l_pgm_type = 'Y'
         THEN
            l_stmnt_ser :=
                  l_stmnt_ser
               || 'and NVL(gen_release_year,0) in('
               || ''
               || i_prod_year
               || ''
               || ',0)';
         ELSE
            l_stmnt_nonser :=
                  l_stmnt_nonser
               || ' and NVL(gen_release_year,0) in ('
               || ''
               || i_prod_year
               || ''
               || ',0)';
         END IF;
      END IF;


      IF l_pgm_type = 'Y'
      THEN
         l_stmnt := l_stmnt_SER || 'order by percent_match desc';
      ELSE
         l_stmnt := l_stmnt_nonser || 'order by percent_match desc';
      END IF;

      IF i_pgm_type IS NULL
      THEN
         l_stmnt :=
               l_stmnt_SER
            || ' UNION '
            || l_stmnt_nonser
            || 'order by percent_match desc';
      END IF;

     -- DBMS_OUTPUT.put_line (l_stmnt);

      OPEN o_search FOR l_stmnt;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END x_prc_dup_title_check;

   --RDT Start : Acquision Requirements BR_15_104 [Anuja_Shinde][18/09/2015]
   FUNCTION X_FNC_GET_SCH_INFO (I_GEN_REFNO IN NUMBER)
      RETURN VARCHAR2
   AS
      l_cnt        NUMBER;
      l_sch_flag   VARCHAR2 (1);
   BEGIN
      SELECT DECODE (COUNT (1), 0, 'N', 'Y')
        INTO l_sch_flag
        FROM fid_schedule
       WHERE sch_lic_number IN (SELECT lic_number
                                  FROM fid_license
                                 WHERE lic_gen_refno = I_GEN_REFNO);

      RETURN l_sch_flag;
   END X_FNC_GET_SCH_INFO;
--RDT End : Acquision Requirements BR_15_104

-- CU4ALL Start : Deal Memo validation for Max No of VP [Shubhada Bongarde]
  Function X_FUN_MAX_VP_VALIDATION(
      i_mei_id IN NUMBER,
      i_ald_exhib_days IN NUMBER,
      i_mei_gen_refno IN NUMBER
  )RETURN  VARCHAR2
  as
      l_flag               varchar2(1) ;
      l_gen_type           NUMBER;  -- Addde by Shubhada Bongarde For CU4ALL
      l_mem_id             NUMBER;  -- Addde by Shubhada Bongarde For CU4ALL
      l_no_bouquet         NUMBER;  -- Addde by Shubhada Bongarde For CU4ALL
      l_buq_rank           VARCHAR(200);  -- Addde by Shubhada Bongarde For CU4ALL
      l_buq_active         VARCHAR(1);  -- Addde by Shubhada Bongarde For CU4ALL
      l_buq_prem_linr      VARCHAR(1);  -- Addde by Shubhada Bongarde For CU4ALL

  BEGIN
    l_flag := 'N';
   NULL;
   -- CU4ALL: Deal Memo Validation for Max no of VP : Start : By Shubhada Bongarde
--        SELECT  distinct gen_type INTO l_gen_type
--          FROM fid_general
--         WHERE gen_ser_number = i_mei_gen_refno;

          SELECT COUNT(1)
            INTO l_gen_type
            FROM FID_SERIES
           WHERE SER_NUMBER = i_mei_gen_refno;


        --dbms_output.put_line('gen_type'||l_gen_type);

        IF l_gen_type > 0
        THEN
          SELECT count(1) INTO l_no_bouquet
            FROM sak_memo_item mei,
                 sak_memo mem,
                 x_con_bouque_mapp cbm
           WHERE mei.mei_mem_id = mem.mem_id
             AND mem.mem_con_number =  cbm.cbm_con_number
             AND mei.mei_id = i_mei_id;--87094;

          IF l_no_bouquet > 1
          THEN
            BEGIN
            SELECT cb.cb_ad_flag,fc.con_sch_after_prem_linr_ser,cb.cb_rank
              INTO  l_buq_active , l_buq_prem_linr,l_buq_rank
              FROM sak_memo_item mei,
                   sak_memo mem,
                   fid_contract fc,
                   x_cp_bouquet cb
             WHERE mei.mei_mem_id = mem.mem_id
               AND mem.mem_con_number = fc.con_number
               AND fc.con_sch_aft_prem_linr_ser_bouq = cb.cb_id
               AND mei.mei_id = i_mei_id;--87094;
            EXCEPTION WHEN NO_DATA_FOUND  THEN
            l_buq_active:='D';
            l_buq_prem_linr :='N';
            l_buq_rank:=0;
            END;
            IF l_buq_rank = 1 AND l_buq_active = 'A' AND l_buq_prem_linr = 'Y'
            THEN
              IF i_ald_exhib_days > 2
              THEN
                l_flag := 'P'; -- Validation if Premium bouquet selected
                RETURN l_flag;
              END IF;
            ELSIF l_buq_rank != 1 AND l_buq_active = 'A' AND l_buq_prem_linr = 'Y'
            THEN
              IF i_ald_exhib_days > 1
              THEN
                l_flag := 'C'; -- validation if compact bouquet is selected
                RETURN l_flag;
              END IF;
              else
                  l_flag :='N';
                  return l_flag;
            END IF;
          END IF;
        END IF;

    RETURN l_flag;

  END X_FUN_MAX_VP_VALIDATION;
-- CU4ALL End

PROCEDURE            X_PRC_SEND_METADATA_EMAIL(i_mem_id in number,
                                              i_user_id in varchar2,
                                              i_status in varchar2

  )
 AS
      L_MAIL_CONN     UTL_SMTP.CONNECTION;
      L_SMTP_SERVER   varchar2 (100);
      l_recipient     VARCHAR2 (6000);
      L_MAILFROM      varchar2 (1000);
      O_SUCESS        number;
      arr_email       email_ary_big       := email_ary_big (6000);
      arr_Ccemail     simplearray         := simplearray (6000);
      p_html_msg      CLOB;
      l_html          CLOB;
      L_SUBJECT       varchar2(5000) := 'Metadata(QA) DM '|| i_mem_id;
      l_lee_number   number;
      l_mailfrom_user  varchar2(5000);
      l_usr_name    varchar2(5000);
      l_metadata_Status varchar2(1000);
      L_Cc_Recipient varchar2(5000);
      L_Rejection_Comment varchar2(1000);
      L_To_Recipient VARCHAR2 (6000);
begin

 NULL;
     --  var := CHR (38) || 'nbsp;';

      -- Get the SMTP server ip from fwk_appparameter table
      SELECT "Content"
        INTO l_smtp_server
        FROM fwk_appparameter
       WHERE KEY = 'SMTPServer';

	--Added By Pravin For Metadata QA Passed/Failed Email
    if i_status in ('METADATA QAPASSED','METADATA QAFAILED')
    Then
        Begin
            SELECT LISTAGG(usr_email_id, ',')
            WITHIN GROUP (ORDER BY usr_email_id)
            into L_To_Recipient
            FROM men_user
            where usr_id in
            (
              select mhi_entry_oper
              from sak_memo_history
              where mhi_mem_id = i_mem_id
              and mhi_to_stat = 'REGISTERED'
              and mhi_action = 'NEW'
            )
            and usr_email_id is not null;
            Exception
            When NO_DATA_FOUND
            then
                raise_application_error(-20601,'Please Configure Email Id');
        End;

        Begin
            --SELECT  wm_concat(usr_email_id)
            SELECT LISTAGG(usr_email_id, ',')
            WITHIN GROUP (ORDER BY usr_email_id)
            into L_Cc_Recipient
            FROM men_user
            where usr_id in
            (
              select DISTINCT mhi_entry_oper
              from sak_memo_history
              where mhi_mem_id = i_mem_id
              and mhi_to_stat IN('BUYER RECOMMENDED','QAPASSED')
            )
            and usr_email_id is not null;
            Exception
            When NO_DATA_FOUND
            then
                raise_application_error(-20601,'Please Configure Email Id');
        End;

        If L_Cc_Recipient is not null
        Then
            L_Cc_Recipient := L_Cc_Recipient || ',Sonia.Raubenheimer@multichoice.co.za,Raven.Moonsamy@multichoice.co.za';

            If L_To_Recipient is not null
            Then
              l_recipient := L_To_Recipient || ',' || L_Cc_Recipient;
            Else
              l_recipient :=  L_Cc_Recipient;
            End If;
        Elsif L_To_Recipient is not null
        Then
            l_recipient := L_To_Recipient ;
        End If;


        Begin
            SELECT usr_email_id,usr_name
            into l_mailfrom_user,l_usr_name
            FROM men_user
            where upper(usr_id) = upper(i_user_id)
            and usr_email_id is not null;
            Exception
            When NO_DATA_FOUND
            then
                raise_application_error(-20601,'Please Configure Email Id');
        End;
    Else
		--Pravin -> End
        SELECT MEM_LEE_NUMBER
        into
             l_lee_number
               FROM sak_memo
              WHERE mem_id = i_mem_id;


          -- Get the recipient, subject, mailfrom from sgy_email table
        Begin
            --SELECT  wm_concat(usr_email_id)
            SELECT LISTAGG(usr_email_id, ',')
            WITHIN GROUP (ORDER BY usr_email_id)
            into L_To_Recipient
            FROM men_user
            where usr_id in
            (
              select meu_usr_id
              from sak_memo_user,fid_licensee
              where MEU_METADATAQA_FLAG = 'Y'
              and meu_lee_number = lee_number
              and meu_lee_number = l_lee_number
              and LEE_METADATAQA_FLAG ='Y'
			  --order by meu_usr_id
            )
            and usr_email_id is not null;
            l_recipient := L_To_Recipient;
            Exception
            When NO_DATA_FOUND
            then
              Rollback;
            raise_application_error(-20601,'Please Configure Email Id');
        End;

        Begin
           SELECT  wm_concat(usr_email_id),usr_name
              into l_mailfrom_user,l_usr_name
          FROM men_user
          where usr_id in
            (select meu_usr_id
               from sak_memo_user
             where meu_lee_number = l_lee_number
             and meu_usr_id = i_user_id
            )
            and usr_email_id is not null
            group by usr_name;
           Exception

            When NO_DATA_FOUND
            then
             Rollback;
            raise_application_error(-20601,'Please Configure Email Id' );
        End;
      End If;

      if l_recipient is not null
      then
          l_mailfrom:= l_mailfrom_user;

          -- Get the ',' seperated emailids as array

          arr_email := GET_EMAIL_IDS(l_recipient, ',');
          l_mail_conn := UTL_SMTP.open_connection (l_smtp_server, 25);
          UTL_SMTP.helo (l_mail_conn, l_smtp_server);
          UTL_SMTP.MAIL (L_MAIL_CONN, L_MAILFROM);
     --   UTL_SMTP.rcpt (l_mail_conn, l_recipient);

         --dbms_output.put_line('arr_email.count ' || arr_email.count);
         for i in 1 .. arr_email.count - 1
         loop
             utl_smtp.rcpt (l_mail_conn, '' || arr_email (i) || '' );
         END LOOP;
                            --Added By Pravin For Metadata QA Passed/Failed Email
                        /*
                        If L_Cc_Recipient is not null
                        Then
                            l_recipient := substr(l_recipient,0,instr(l_recipient,',',1,1)-1);
                        End If;
                        */

                        UTL_SMTP.open_data (l_mail_conn);

                        if L_To_Recipient is not null
                        Then
                          UTL_SMTP.write_data(l_mail_conn, 'To: ' || L_To_Recipient || UTL_TCP.crlf);
                        End If;

                        If L_Cc_Recipient is not null
                        Then
                            UTL_SMTP.write_data(l_mail_conn, 'Cc: ' || L_Cc_Recipient|| UTL_TCP.crlf);
                        End If;

                        select decode(i_status,'METADATA QAPASSED','Passed for ','METADATA QAFAILED','Failed for ',null)
                        into l_metadata_Status
                        from dual;
                        --Pravin End

                        UTL_SMTP.write_data (l_mail_conn,
                                      'Subject:'
                                   || 'Metadata (QA) '
                                   || l_metadata_Status
                                   || 'DM '|| i_mem_id
                                   || UTL_TCP.crlf
                                  );
                        UTL_SMTP.write_data (l_mail_conn,
                                   'Content-Type: text/html' || UTL_TCP.crlf
                                  );
              UTL_SMTP.write_data (l_mail_conn, UTL_TCP.crlf || '');
              UTL_SMTP.write_data (l_mail_conn, 'Hi There, ');
              utl_smtp.write_data (l_mail_conn, ' <BR>');
              UTL_SMTP.write_data (l_mail_conn, '<BR>' || UTL_TCP.crlf);

              If i_status = 'METADATA QAPASSED'
              Then
                  P_HTML_MSG := 'Please note that Metadata QA for Deal Memo '|| i_mem_id ||' is Passed.';
              Elsif i_status = 'METADATA QAFAILED'
              Then
                  SELECT *
                  Into L_Rejection_Comment
                  FROM
                  (
                    Select InitCap(mhi_meta_comment)
                    From sak_memo_history
                    Where mhi_mem_id = I_Mem_Id
                    AND Upper(mhi_to_stat) in('METADATA QAFAILED','METADATAQAFAILED')
                    And upper(mhi_entry_oper) = upper(i_user_id)
                    order by mhi_entry_date desc
                  )
                  Where Rownum < 2;

                  P_HTML_MSG := 'Please note that Metadata QA for Deal Memo '|| i_mem_id ||' is Failed.';
                  P_HTML_MSG := P_HTML_MSG ||
                                '<BR>Reason of Rejection: ' || L_Rejection_Comment;
              Else
               P_HTML_MSG := 'Please note that Deal Memo '|| i_mem_id ||' is ready to be Metadata Checked.';
              End If;

              l_usr_name := INITCAP(REPLACE(l_usr_name,'.',' '));

              UTL_SMTP.write_data (l_mail_conn, p_html_msg || UTL_TCP.crlf);

              UTL_SMTP.write_data (l_mail_conn, '<BR>');
              UTL_SMTP.write_data (l_mail_conn, '<BR><BR>');
              UTL_SMTP.write_data (l_mail_conn, 'Regards,<BR>');
              UTL_SMTP.write_data (l_mail_conn, l_usr_name);
              UTL_SMTP.write_data (l_mail_conn, '<BR><BR>');
              UTL_SMTP.write_data
                 (l_mail_conn,
                  '**************This is an auto generated email.**************'
                 );

        l_html := NULL;

       UTL_SMTP.close_data (l_mail_conn);
       UTL_SMTP.quit (l_mail_conn);

    END IF;

   END X_PRC_SEND_METADATA_EMAIL;
---Finace Dev Phase I [Start] [Ankur Kasar.]
PROCEDURE X_PRC_GET_OPEN_MONTH (
							    I_LEE_SHORT_NAME IN  FID_LICENSEE.LEE_SHORT_NAME%TYPE,
							    OPEN_MONTH       OUT VARCHAR2
							   )AS
BEGIN
  SELECT TO_CHAR(TO_DATE(FIM_YEAR||LPAD(FIM_MONTH,2,0)||01,'YYYYMMDD'),'DD-MM-RRRR') INTO OPEN_MONTH FROM FID_FINANCIAL_MONTH 
   WHERE FIM_STATUS = 'O'
     AND FIM_SPLIT_REGION =(SELECT LEE_SPLIT_REGION FROM FID_LICENSEE WHERE LEE_NUMBER =
                                                        (select LEE_NUMBER from FID_LICENSEE WHERE LEE_SHORT_NAME =I_LEE_SHORT_NAME ));
  
end X_PRC_GET_OPEN_MONTH;
---Finace Dev Phase I [End] [Ankur Kasar.]
END pkg_adm_cm_dealmemo;
/
