CREATE OR REPLACE PACKAGE         "PKG_TVA_DEALMEMO"
AS
/****************************************************************
REM Module         : Acquisition Module
REM Client         : MNET
REM File Name      : pkg_tva_dealmemo.sql
REM Form Name      : Deal Memo Maintenance
REM Purpose        : For maintening Deal memo
REM Author         : Jawahar Garg
REM Creation Date  : 13 Sep 2015
REM Type           : Database Package
REM Change History : Rewrite
****************************************************************/
   TYPE c_cursor_tva_dealmemo IS REF CURSOR;

   type varchar_array is table of varchar2(5000) index by pls_integer;
   dm_number tbl_tva_deal_memo.DM_N_DEAL_MEMO_NUMBER%TYPE DEFAULT NULL;

--****************************************************************
-- This procedure searches Deal memo.
--****************************************************************
   PROCEDURE prc_tva_search_dealmemo (
      i_dm_n_deal_memo_number   IN       VARCHAR2,
      i_con_v_short_name        IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_dm_amort_code           IN       tbl_tva_deal_memo.dm_v_amort_code%TYPE,
      i_dm_v_status             IN       tbl_tva_deal_memo.dm_v_status%TYPE,
      i_dm_n_type               IN       tbl_tva_deal_memo.dm_n_type%TYPE,
      i_dm_dt_start_date        IN       tbl_tva_deal_memo.dm_dt_deal_memo_date%TYPE,
      i_dm_dt_end_date          IN       tbl_tva_deal_memo.dm_dt_deal_memo_date%TYPE,
      i_entry_oper              IN       tbl_tva_deal_memo.dm_v_entry_oper%TYPE,
      o_searchdealmemo          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure searches Deal Memo Details.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dealmemo_details (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemodetails     OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo,
      o_viewdmmediatypes        OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure searches Deal Memo Programmes.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_programmes (
      i_dm_n_deal_memo_number    IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemoprogrammes   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo,
      o_viewdealmemolicenses     OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
      ,o_viewdealmemomedrights    OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo,          --Added by Jawahar
      o_viewdefaultmedrights     OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo            --Added by Jawahar
   );

--****************************************************************
-- This procedure searches Deal Memo Territories.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_territories (
      i_dm_n_deal_memo_number     IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemoterritories   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );
--****************************************************************
-- This procedure searches Deal Memo Minimum Guarantee Payment.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_minguarantee (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewminguarantee        OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure searches Deal Memo Overage Payment.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_overages (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewoverages            OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure searches Deal Memo Materials.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_materials (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemomaterials   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure searches Deal Memo History.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_history (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemohistory     OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Creates (Inserts) New Deal Memo.
-- This procedure input are Deal Memo parameters.
--****************************************************************
   PROCEDURE prc_tva_create_deal_memo (
      i_dm_n_con_number         IN       tbl_tva_deal_memo.dm_n_con_number%TYPE,
      i_dm_dt_deal_memo_date    IN       tbl_tva_deal_memo.dm_dt_deal_memo_date%TYPE,
      i_dm_n_memo_price         IN       tbl_tva_deal_memo.dm_n_memo_price%TYPE,
      i_dm_n_lee_number         IN       tbl_tva_deal_memo.dm_n_lee_number%TYPE,
      i_dm_v_currency           IN       tbl_tva_deal_memo.dm_v_currency%TYPE,
      i_dm_n_type               IN       tbl_tva_deal_memo.dm_n_type%TYPE,
      i_dm_v_amort_code         IN       tbl_tva_deal_memo.dm_v_amort_code%TYPE,
      i_dm_n_supp_com_number    IN       tbl_tva_deal_memo.dm_n_supp_com_number%TYPE,
      i_dm_n_con_com_number     IN       tbl_tva_deal_memo.dm_n_con_com_number%TYPE,
      i_dm_v_entry_oper         IN       tbl_tva_deal_memo.dm_v_entry_oper%TYPE,
      i_dm_bo_rev_cur           IN       tbl_tva_deal_memo.dm_bo_rev_cur%TYPE,                    --Added by Jwahar for TVOD_CR
      o_dm_n_deal_memo_number   OUT      tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_dm_v_status             OUT      tbl_tva_deal_memo.dm_v_status%TYPE
   );

--****************************************************************
-- This procedure Edits Deal Memo Details.
-- This procedure input are Deal Memo parameters.
--****************************************************************
   PROCEDURE prc_tva_update_deal_memo (
      i_dm_n_deal_memo_number        IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      i_dm_n_memo_price              IN       tbl_tva_deal_memo.dm_n_memo_price%TYPE,
      i_dm_n_con_number              IN       tbl_tva_deal_memo.dm_n_con_number%TYPE,
      i_dm_n_supp_com_number         IN       tbl_tva_deal_memo.dm_n_supp_com_number%TYPE,
      i_dm_n_con_com_number          IN       tbl_tva_deal_memo.dm_n_con_com_number%TYPE,
      i_dm_n_type                    IN       tbl_tva_deal_memo.dm_n_type%TYPE,
      i_dm_n_lee_number              IN       tbl_tva_deal_memo.dm_n_lee_number%TYPE,
      i_dm_v_currency                IN       tbl_tva_deal_memo.dm_v_currency%TYPE,
      i_dm_v_amort_code              IN       tbl_tva_deal_memo.dm_v_amort_code%TYPE,
      i_dm_c_broader_rights          IN       tbl_tva_deal_memo.dm_c_broader_rights%TYPE,
      i_dm_v_comments                IN       tbl_tva_deal_memo.dm_v_comments%TYPE,
      i_dm_dt_date_prior             IN       tbl_tva_deal_memo.dm_dt_date_prior%TYPE,
      i_dm_dt_date_not_later_than    IN       tbl_tva_deal_memo.dm_dt_date_not_later_than%TYPE,
      i_dm_v_material_other          IN       tbl_tva_deal_memo.dm_v_delivery_other%TYPE,
      i_dm_v_delivery_mode           IN       tbl_tva_deal_memo.dm_v_delivery_mode%TYPE,
      i_dm_v_delivery_cost           IN       tbl_tva_deal_memo.dm_v_delivery_cost%TYPE,
      i_dm_v_return_cost             IN       tbl_tva_deal_memo.dm_v_return_cost%TYPE,
      i_dm_v_del_return_info         IN       tbl_tva_deal_memo.dm_v_del_return_info%TYPE,
      i_dm_v_delivery_other          IN       tbl_tva_deal_memo.dm_v_delivery_other%TYPE,
      i_dm_v_modified_by             IN       tbl_tva_deal_memo.dm_v_modified_by%TYPE,
      i_dm_n_update_count            IN       tbl_tva_deal_memo.dm_n_update_count%TYPE,
      i_dm_bo_rev_cur                IN       tbl_tva_deal_memo.dm_bo_rev_cur%TYPE,                    --Added by Jwahar for TVOD_CR
      o_status                       OUT      NUMBER,
      o_updateddata                  OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo,
      o_updatedmmediatypes           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Inserts Deal Memo Programmes.
-- This procedure input are Deal Memo Programme parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_programme (
      i_dmprg_n_dm_number        IN       tbl_tva_dm_prog.dmprg_n_dm_number%TYPE,
      i_dmprg_c_premium          IN       tbl_tva_dm_prog.dmprg_c_premium%TYPE,
      i_dmprg_v_type             IN       tbl_tva_dm_prog.dmprg_v_type%TYPE,
      i_dmprg_n_gen_refno        IN       tbl_tva_dm_prog.dmprg_n_gen_refno%TYPE,
      i_gen_title                IN       fid_general.gen_title%TYPE,
      I_GEN_RELEASE_YEAR         in       FID_GENERAL.GEN_RELEASE_YEAR%type,
      i_dmprg_n_bo_rev_zar       IN       tbl_tva_dm_prog.dmprg_n_bo_rev_zar%TYPE,
      i_dmprg_n_bo_rev_usd       IN       tbl_tva_dm_prog.dmprg_n_bo_rev_usd%TYPE,
      i_dmprg_n_min_shelf_life   IN       tbl_tva_dm_prog.dmprg_n_min_shelf_life%TYPE,
      i_dmprg_dt_lvr             IN       tbl_tva_dm_prog.dmprg_dt_lvr%TYPE,
      i_dmprg_n_day_post_lvr     IN       tbl_tva_dm_prog.dmprg_n_day_post_lvr%TYPE,
      i_dmprg_v_formats          IN       tbl_tva_dm_prog.dmprg_v_formats%TYPE,
      i_dmprg_n_total_price      IN OUT   tbl_tva_dm_prog.dmprg_n_total_price%TYPE,
      i_dmprg_v_comments         IN       tbl_tva_dm_prog.dmprg_v_comments%TYPE,
      i_dmprg_v_entry_oper       IN       tbl_tva_dm_prog.dmprg_v_entry_oper%TYPE,
      I_DMPRG_V_PROG_CATEGORY    IN       VARCHAR2,
      i_dmprg_v_bo_category      IN       VARCHAR2,
      i_DMPRG_MIN_SHELF_life_ph	 IN       tbl_tva_dm_prog.DMPRG_MIN_SHELF_life_push%TYPE,       --Added by Jawahar
      i_DMPRG_MIN_SHELF_life_pl  IN       tbl_tva_dm_prog.DMPRG_MIN_SHELF_life_pull%TYPE,       --Added By Jawahar
      i_dmprg_bo_rev             IN       TBL_TVA_DM_PROG.dmprg_bo_rev%TYPE,
      o_gen_refno                OUT      fid_general.gen_refno%TYPE,
      o_dm_update_count          OUT      number,
      o_status                   OUT      tbl_tva_dm_prog.dmprg_n_number%TYPE
   );

--****************************************************************
-- This procedure Updates Deal Memo Programmes.
-- This procedure input are Deal Memo Programme parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_programme (
      i_dmprg_n_number           IN       tbl_tva_dm_prog.dmprg_n_number%TYPE,
      i_dmprg_c_premium          IN       tbl_tva_dm_prog.dmprg_c_premium%TYPE,
      i_dmprg_v_type             IN       tbl_tva_dm_prog.dmprg_v_type%TYPE,
      i_dmprg_n_gen_refno        IN       tbl_tva_dm_prog.dmprg_n_gen_refno%TYPE,
      i_dmprg_n_bo_rev_zar       IN       tbl_tva_dm_prog.dmprg_n_bo_rev_zar%TYPE,
      i_dmprg_n_bo_rev_usd       IN       tbl_tva_dm_prog.dmprg_n_bo_rev_usd%TYPE,
      i_dmprg_n_min_shelf_life   IN       tbl_tva_dm_prog.dmprg_n_min_shelf_life%TYPE,
      i_dmprg_dt_lvr             IN       tbl_tva_dm_prog.dmprg_dt_lvr%TYPE,
      i_dmprg_n_day_post_lvr     IN       tbl_tva_dm_prog.dmprg_n_day_post_lvr%TYPE,
      i_dmprg_v_formats          IN       tbl_tva_dm_prog.dmprg_v_formats%TYPE,
      i_dmprg_n_total_price      IN OUT   tbl_tva_dm_prog.dmprg_n_total_price%TYPE,
      i_dmprg_v_comments         IN       tbl_tva_dm_prog.dmprg_v_comments%TYPE,
      i_dmprg_v_modified_by      IN       tbl_tva_dm_prog.dmprg_v_modified_by%TYPE,
      i_dmprg_n_update_count     IN       tbl_tva_dm_prog.dmprg_n_update_count%TYPE,
      I_DMPRG_V_PROG_CATEGORY    IN       VARCHAR2,
      i_dmprg_v_bo_category      IN       VARCHAR2,
      i_DMPRG_MIN_SHELF_life_ph	 IN       tbl_tva_dm_prog.DMPRG_MIN_SHELF_life_push%TYPE,       --Added by Jawahar
      i_DMPRG_MIN_SHELF_life_pl  IN       tbl_tva_dm_prog.DMPRG_MIN_SHELF_life_pull%TYPE,       --Added By Jawahar
      i_dmprg_bo_rev             IN       TBL_TVA_DM_PROG.dmprg_bo_rev%TYPE,
      o_dm_update_count          OUT      number,
      o_status                   OUT      NUMBER,
      o_updateddata              OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Deletes Deal Memo Programmes.
-- This procedure input are Deal Memo Programme number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_programme (
      i_dmprg_n_number         IN       tbl_tva_dm_prog.dmprg_n_number%TYPE,
      i_dmprg_n_update_count   IN       tbl_tva_dm_prog.dmprg_n_update_count%TYPE,
      i_operator               IN       VARCHAR2,
      o_dm_update_count        OUT      number,
      o_status                 OUT      NUMBER,
      o_updateddata            OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Inserts Deal Memo Programme Allocations.
-- This procedure input are Deal Memo Programme Allocation parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_allocation (
      i_dmad_n_dmprg_number   IN       tbl_tva_dm_allocation_detail.dmad_n_dmprg_number%TYPE,
      i_dmad_n_lee_number     IN       tbl_tva_dm_allocation_detail.dmad_n_lee_number%TYPE,
      i_dmad_c_tba            IN       tbl_tva_dm_allocation_detail.DMAD_C_TBA%TYPE,
      i_dmad_dt_start         IN       tbl_tva_dm_allocation_detail.dmad_dt_start%TYPE,
      i_dmad_dt_end           IN       tbl_tva_dm_allocation_detail.dmad_dt_end%TYPE,
      i_dmad_n_amount         IN       tbl_tva_dm_allocation_detail.dmad_n_amount%TYPE,
      i_dmad_v_entry_oper     IN       tbl_tva_dm_allocation_detail.dmad_v_entry_oper%TYPE,
      i_DMAD_DAYS_POST_LVR    IN       tbl_tva_dm_allocation_detail.DMAD_DAYS_POST_LVR%TYPE,        --Added by Jawahar
      o_status                OUT      tbl_tva_dm_allocation_detail.dmad_n_number%TYPE
   );

--****************************************************************
-- This procedure Updates Deal Memo Programme Allocations.
-- This procedure input are Deal Memo Programme Allocation parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_allocation (
      i_dmad_n_number         IN       tbl_tva_dm_allocation_detail.dmad_n_number%TYPE,
      i_dmad_n_lee_number     IN       tbl_tva_dm_allocation_detail.dmad_n_lee_number%TYPE,
      i_dmad_c_tba            IN       tbl_tva_dm_allocation_detail.DMAD_C_TBA%TYPE,
      i_dmad_dt_start         IN       tbl_tva_dm_allocation_detail.dmad_dt_start%TYPE,
      i_dmad_dt_end           IN       tbl_tva_dm_allocation_detail.dmad_dt_end%TYPE,
      i_dmad_n_amount         IN       tbl_tva_dm_allocation_detail.dmad_n_amount%TYPE,
      i_dmad_v_modified_by    IN       tbl_tva_dm_allocation_detail.dmad_v_modified_by%TYPE,
      i_dmad_n_update_count   IN       tbl_tva_dm_allocation_detail.dmad_n_update_count%TYPE,
      i_DMAD_DAYS_POST_LVR    IN       tbl_tva_dm_allocation_detail.DMAD_DAYS_POST_LVR%TYPE,        --Added by Jawahar
      o_status                OUT      NUMBER,
      o_updateddata           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Deletes Deal Memo Programme Allocations.
-- This procedure input are Deal Memo Programme Allocation number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_allocation (
      i_dmad_n_number         IN       tbl_tva_dm_allocation_detail.dmad_n_number%TYPE,
      i_dmad_n_update_count   IN       tbl_tva_dm_allocation_detail.dmad_n_update_count%TYPE,
      i_operator              IN       VARCHAR2,
      o_status                OUT      NUMBER,
      o_updateddata           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Inserts Deal Memo Territories.
-- This procedure input are Deal Memo Territory parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_territory (
      i_dmm_n_dm_number    IN       tbl_tva_dm_territory.dmt_n_dm_number%TYPE,
      i_dmt_n_territory    IN       tbl_tva_dm_territory.dmt_n_territory%TYPE,
      i_dmt_v_rights       IN       tbl_tva_dm_territory.dmt_v_rights%TYPE,
      i_dmm_v_entry_oper   IN       tbl_tva_dm_territory.dmt_v_entry_oper%TYPE,
      i_dmt_is_link        IN       tbl_tva_dm_territory.dmt_v_is_linked%TYPE,
      o_status             OUT      tbl_tva_dm_territory.dmt_n_number%TYPE
   );

--****************************************************************
-- This procedure Updates Deal Memo Territories.
-- This procedure input are Deal Memo Territory parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_territory (
      i_dmt_n_number         IN       tbl_tva_dm_territory.dmt_n_number%TYPE,
      i_dmt_n_territory      IN       tbl_tva_dm_territory.dmt_n_territory%TYPE,
      i_dmt_v_rights         IN       tbl_tva_dm_territory.dmt_v_rights%TYPE,
      i_dmt_v_modified_by    IN       tbl_tva_dm_territory.dmt_v_modified_by%TYPE,
      i_dmt_n_update_count   IN       tbl_tva_dm_territory.dmt_n_update_count%TYPE,
      i_dmt_is_link          IN       tbl_tva_dm_territory.dmt_v_is_linked%TYPE,
      o_status               OUT      NUMBER,
      o_updateddata          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Deletes Deal Memo Territories.
-- This procedure input are Deal Memo Territory number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_territory (
      i_dmt_n_number         IN       tbl_tva_dm_territory.dmt_n_number%TYPE,
      i_dmt_n_update_count   IN       tbl_tva_dm_territory.dmt_n_update_count%TYPE,
      i_operator             IN       VARCHAR2,
      o_status               OUT      NUMBER,
      o_updateddata          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );
 --****************************************************************
-- This procedure Inserts Deal Memo Minimum Guarantee Payment.
-- This procedure input are Deal Memo Minimum Guarantee Payment Parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_minguarantee (
      i_dmmgpay_n_dm_number         IN       tbl_tva_dm_mg_payment.dmmgpay_n_dm_number%TYPE,
      i_dmmgpay_n_order             IN       tbl_tva_dm_mg_payment.dmmgpay_n_order%TYPE,
      i_dmmgpay_n_pay_percent       IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_percent%TYPE,
      i_dmmgpay_n_pay_amount        IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_amount%TYPE,
      i_dmmgpay_v_pay_code          IN       tbl_tva_dm_mg_payment.dmmgpay_v_pay_code%TYPE,
      i_dmmgpay_v_currency          IN       tbl_tva_dm_mg_payment.dmmgpay_v_currency%TYPE,
      i_dmmgpay_n_no_of_days        IN       tbl_tva_dm_mg_payment.dmmgpay_n_no_of_days%TYPE,
      i_dmmgpay_n_pay_rule_number   IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_rule_number%TYPE,
      i_dmmgpay_v_comments          IN       tbl_tva_dm_mg_payment.dmmgpay_v_comments%TYPE,
      i_dmmgpay_v_entry_oper        IN       tbl_tva_dm_mg_payment.dmmgpay_v_entry_oper%TYPE,
      o_status                      OUT      tbl_tva_dm_mg_payment.dmmgpay_n_number%TYPE
   );

--****************************************************************
-- This procedure Updates Deal Memo Minimum Guarantee Payment.
-- This procedure input are Deal Memo Minimum Guarantee Payment Parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_minguarantee (
      i_dmmgpay_n_number            IN       tbl_tva_dm_mg_payment.dmmgpay_n_number%TYPE,
      i_dmmgpay_n_order             IN       tbl_tva_dm_mg_payment.dmmgpay_n_order%TYPE,
      i_dmmgpay_n_pay_percent       IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_percent%TYPE,
      i_dmmgpay_n_pay_amount        IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_amount%TYPE,
      i_dmmgpay_v_pay_code          IN       tbl_tva_dm_mg_payment.dmmgpay_v_pay_code%TYPE,
      i_dmmgpay_v_currency          IN       tbl_tva_dm_mg_payment.dmmgpay_v_currency%TYPE,
      i_dmmgpay_n_no_of_days        IN       tbl_tva_dm_mg_payment.dmmgpay_n_no_of_days%TYPE,
      i_dmmgpay_n_pay_rule_number   IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_rule_number%TYPE,
      i_dmmgpay_v_comments          IN       tbl_tva_dm_mg_payment.dmmgpay_v_comments%TYPE,
      i_dmmgpay_v_modified_by       IN       tbl_tva_dm_mg_payment.dmmgpay_v_modified_by%TYPE,
      i_dmmgpay_n_update_count      IN       tbl_tva_dm_mg_payment.dmmgpay_n_update_count%TYPE,
      o_status                      OUT      NUMBER,
      o_updateddata                 OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Deletes Deal Memo Minimum Guarantee Payment.
-- This procedure input are Deal Memo Minimum Guarantee Payment Number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_minguarantee (
      i_dmmgpay_n_number         IN       tbl_tva_dm_mg_payment.dmmgpay_n_number%TYPE,
      i_dmmgpay_n_update_count   IN       tbl_tva_dm_mg_payment.dmmgpay_n_update_count%TYPE,
      i_operator                 IN       VARCHAR2,
      o_status                   OUT      NUMBER,
      o_updateddata              OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Inserts Deal Memo Overage Payment.
-- This procedure input are Deal Memo Overage Payment Parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_overage (
      i_dmpo_n_dm_number         IN       tbl_tva_dm_payment_overage.dmpo_n_dm_number%TYPE,
      i_dmpo_n_no_of_days        IN       tbl_tva_dm_payment_overage.dmpo_n_no_of_days%TYPE,
      i_dmpo_n_pay_rule_number   IN       tbl_tva_dm_payment_overage.dmpo_n_pay_rule_number%TYPE,
      i_dmpo_v_pay_code          IN       tbl_tva_dm_payment_overage.dmpo_v_pay_code%TYPE,
      i_dmmgpay_v_currency       IN       tbl_tva_dm_payment_overage.DMPO_V_CURRENCY%TYPE,
      i_dmpo_v_entry_oper        IN       tbl_tva_dm_payment_overage.dmpo_v_entry_oper%TYPE,
      o_status                   OUT      tbl_tva_dm_payment_overage.dmpo_n_number%TYPE
   );

--****************************************************************
-- This procedure Updates Deal Memo Overage Payment.
-- This procedure input are Deal Memo Overage Payment Parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_overage (
      i_dmpo_n_number            IN       tbl_tva_dm_payment_overage.dmpo_n_number%TYPE,
      i_dmpo_n_no_of_days        IN       tbl_tva_dm_payment_overage.dmpo_n_no_of_days%TYPE,
      i_dmpo_n_pay_rule_number   IN       tbl_tva_dm_payment_overage.dmpo_n_pay_rule_number%TYPE,
      i_dmpo_v_pay_code          IN       tbl_tva_dm_payment_overage.dmpo_v_pay_code%TYPE,
      i_dmmgpay_v_currency       IN       tbl_tva_dm_payment_overage.DMPO_V_CURRENCY%TYPE,
      i_dmpo_v_modified_by       IN       tbl_tva_dm_payment_overage.dmpo_v_modified_by%TYPE,
      i_dmpo_n_update_count      IN       tbl_tva_dm_payment_overage.dmpo_n_update_count%TYPE,
      o_status                   OUT      NUMBER,
      o_updateddata              OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Deletes Deal Memo Overage Payment.
-- This procedure input are Deal Memo Overage Payment Number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_overage (
      i_dmpo_n_number         IN       tbl_tva_dm_payment_overage.dmpo_n_number%TYPE,
      i_dmpo_n_update_count   IN       tbl_tva_dm_payment_overage.dmpo_n_update_count%TYPE,
      i_operator              IN       VARCHAR2,
      o_status                OUT      NUMBER,
      o_updateddata           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Inserts Deal Memo Materials.
-- This procedure input are Deal Memo Materials Parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_material (
      i_dmm_n_dm_number    IN       tbl_tva_dm_material.dmm_n_dm_number%TYPE,
      i_dmm_n_com_number   IN       tbl_tva_dm_material.dmm_n_com_number%TYPE,
      i_dmm_v_class        IN       tbl_tva_dm_material.dmm_v_class%TYPE,
      i_dmm_v_broadcast    IN       tbl_tva_dm_material.dmm_v_broadcast%TYPE,
      i_dmm_v_sound        IN       tbl_tva_dm_material.dmm_v_sound%TYPE,
      i_dmm_v_item         IN       tbl_tva_dm_material.dmm_v_item%TYPE,
      i_dmm_v_comments     IN       tbl_tva_dm_material.dmm_v_comments%TYPE,
      i_dmm_v_entry_oper   IN       tbl_tva_dm_material.dmm_v_entry_oper%TYPE,
      o_status             OUT      tbl_tva_dm_material.dmm_n_number%TYPE
   );

--****************************************************************
-- This procedure Updates Deal Memo Materials.
-- This procedure input are Deal Memo Materials Parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_material (
      i_dmm_n_number         IN       tbl_tva_dm_material.dmm_n_number%TYPE,
      i_dmm_n_com_number     IN       tbl_tva_dm_material.dmm_n_com_number%TYPE,
      i_dmm_v_class          IN       tbl_tva_dm_material.dmm_v_class%TYPE,
      i_dmm_v_broadcast      IN       tbl_tva_dm_material.dmm_v_broadcast%TYPE,
      i_dmm_v_sound          IN       tbl_tva_dm_material.dmm_v_sound%TYPE,
      i_dmm_v_item           IN       tbl_tva_dm_material.dmm_v_item%TYPE,
      i_dmm_v_comments       IN       tbl_tva_dm_material.dmm_v_comments%TYPE,
      i_dmm_v_modified_by    IN       tbl_tva_dm_material.dmm_v_modified_by%TYPE,
      i_dmm_n_update_count   IN       tbl_tva_dm_material.dmm_n_update_count%TYPE,
      o_status               OUT      NUMBER,
      o_updateddata          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure Deletes Deal Memo Materials.
-- This procedure input are Deal Memo Materials Number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_material (
      i_dmm_n_number         IN       tbl_tva_dm_material.dmm_n_number%TYPE,
      i_dmm_n_update_count   IN       tbl_tva_dm_material.dmm_n_update_count%TYPE,
      i_operator             IN       VARCHAR2,
      o_status               OUT      NUMBER,
      o_updateddata          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

--****************************************************************
-- This procedure returns programme title.
-- This procedure input are programme type and part of programme title.
--****************************************************************
   PROCEDURE prc_tva_gettitles (
      i_gentitle        IN       VARCHAR2,
      i_type            IN       VARCHAR2,
      o_programmedata   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo   --,
   );

--****************************************************************
-- This procedure Changes Deal Memo Status.
-- This procedure input are Deal Memo Materials Number and update count.
--****************************************************************
   PROCEDURE prc_change_dm_status (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      i_user_id                 IN       tbl_tva_deal_memo.dm_v_entry_oper%TYPE,
      i_status                  IN       VARCHAR2,
      o_dm_status               OUT      VARCHAR2,
      o_message                 OUT      VARCHAR2
   );

--****************************************************************
-- This procedure Executes Deal Memo.
--****************************************************************
   PROCEDURE prc_execute_deal_memo (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      i_user_id                 IN       VARCHAR2,
      o_dm_status               OUT      tbl_tva_deal_memo.dm_v_status%TYPE,
      o_message                 OUT      VARCHAR2,
      o_con_n_contract_number   OUT      tbl_tva_contract.con_n_contract_number%TYPE,
      o_con_v_short_name        OUT      tbl_tva_contract.con_v_short_name%TYPE
   );

--****************************************************************
-- This procedure Creates Deal Memo History.
-- This procedure input are Deal Memo History Parameters.
--****************************************************************
   PROCEDURE prc_tva_create_history (
      i_dmh_v_action       IN       tbl_tva_dm_history.dmh_v_action%TYPE,
      i_dmh_n_dm_number    IN       tbl_tva_dm_history.dmh_n_dm_number%TYPE,
      i_dm_n_type          IN       tbl_tva_deal_memo.dm_n_type%TYPE,
      i_dmh_v_entry_oper   IN       tbl_tva_dm_history.dmh_v_entry_oper%TYPE,
      o_dm_status          OUT      tbl_tva_deal_memo.dm_v_status%TYPE
   );

--****************************************************************
-- This procedure performs allocation and payment verification before Deal Memo execution.
--****************************************************************
   PROCEDURE prc_check_for_sign (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_message                 OUT      VARCHAR2
   );

--****************************************************************
-- This procedure gets called for each deal memo programme while deal memo execution.
--****************************************************************
   FUNCTION execute_dmt (
      p_dm_n_deal_memo_number   IN   NUMBER,
      p_user_id                 IN   VARCHAR2
   )
      RETURN NUMBER;

   --****************************************************************
-- This procedure Creates license.
--****************************************************************
   PROCEDURE create_lic (
      p_mode             IN   VARCHAR2,
      p_dmprg_n_number   IN   NUMBER,
      p_genrefno         IN   tbl_tva_license.lic_n_gen_refno%TYPE,
      p_connumber        IN   tbl_tva_license.lic_n_con_number%TYPE,
      p_liccost          IN   tbl_tva_license.lic_n_price%TYPE,
      p_user_id          IN   tbl_tva_license.lic_v_entry_oper%TYPE
   );

--****************************************************************
-- This procedure Creates Deal memo contract.
-- The function output is contract number.
--****************************************************************
   FUNCTION create_new_con (
      p_memid                   IN   tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      p_con_n_type              IN   tbl_tva_contract.con_n_type%TYPE,
      p_con_n_price             IN   tbl_tva_contract.con_n_price%TYPE,
      p_con_n_lee_number        IN   tbl_tva_contract.con_n_lee_number%TYPE,
      p_con_n_com_number        IN   tbl_tva_contract.con_n_com_number%TYPE,
      p_con_n_supp_com_number   IN   tbl_tva_contract.con_n_supp_com_number%TYPE,
      p_con_v_currency          IN   tbl_tva_contract.con_v_currency%TYPE,
      p_dm_format               IN   tbl_tva_dm_prog.DMPRG_V_FORMATS%type,
      p_user_id                 IN   tbl_tva_contract.con_v_entry_oper%TYPE
   )
      RETURN NUMBER;

--****************************************************************
-- This function performs allocation verification.
--****************************************************************
   FUNCTION check_allocation (i_dm_n_deal_memo_number IN NUMBER)
      RETURN NUMBER;

--****************************************************************
-- This function performs payment verification.
--****************************************************************
   FUNCTION check_payment (i_dm_n_deal_memo_number IN NUMBER)
      RETURN NUMBER;

--****************************************************************
-- This function returns licensee channel company type.
-- The procedure input is licensee number.
--****************************************************************
   FUNCTION licensee_status (the_licensee IN NUMBER)
      RETURN VARCHAR2;

 --****************************************************************
-- This procedure will insert into license territory .
--****************************************************************
   PROCEDURE license_ledger_init (
      p_licnumber   IN   tbl_tva_lic_territory.lict_v_lic_number%TYPE,
      p_dmnumber    IN   tbl_tva_dm_territory.dmt_n_dm_number%TYPE,
      p_liccost     IN   tbl_tva_lic_territory.lict_n_price%TYPE,
      p_user_id     IN   tbl_tva_lic_territory.lict_v_entry_oper%TYPE
   );

   --****************************************************************
-- This procedure will create record for license payment.
--****************************************************************
   PROCEDURE create_lic_pay (
      p_connumber               IN   tbl_tva_lic_payments.licp_n_con_number%TYPE,
      p_licnumber               IN   tbl_tva_lic_payments.licp_v_lic_number%TYPE,
      p_targetcom               IN   tbl_tva_lic_payments.licp_n_target_com_number%TYPE,
      p_sourcecom               IN   tbl_tva_lic_payments.licp_n_source_com_number%TYPE,
      p_liccost                 IN   NUMBER,
      p_dm_n_deal_memo_number   IN   NUMBER,
      p_dm_v_currency           IN   tbl_tva_lic_payments.licp_v_currency%TYPE,
      p_licp_v_entry_oper       IN   tbl_tva_lic_payments.licp_v_entry_oper%TYPE
   );

--****************************************************************
-- This procedure will create record for license
-- overage payment.
--****************************************************************
   PROCEDURE create_lic_pay_overage (
      p_connumber               IN   tbl_tva_lic_overages.lico_n_con_number%TYPE,
      p_licnumber               IN   tbl_tva_lic_overages.lico_v_lic_number%TYPE,
      p_dm_n_deal_memo_number   IN   NUMBER,
      p_lico_v_entry_oper       IN   tbl_tva_lic_overages.lico_v_entry_oper%TYPE
   );

--****************************************************************
-- This procedure checks if user has deal memo insert rights.
-- The procedure input is user id.
--****************************************************************
   PROCEDURE prc_check_user_insertrights (
      i_user_id          IN       VARCHAR2,
      i_meu_lee_number   IN       tbl_tva_dm_user.dmu_n_lee_number%TYPE,
      o_flag             OUT      NUMBER,
      o_message          OUT      VARCHAR2
   );

--****************************************************************
-- This procedure checks if user has deal memo update rights.
-- The procedure input is deal memo number and user id.
--****************************************************************
   PROCEDURE prc_check_user_updaterights (
      i_dm_n_deal_memo_number   IN       NUMBER,
      i_meu_lee_number          IN       tbl_tva_dm_user.dmu_n_lee_number%TYPE,
      i_user_id                 IN       VARCHAR2,
      o_flag                    OUT      NUMBER,
      o_message                 OUT      VARCHAR2
   );

   --****************************************************************
-- This procedure returns minimum shelf life corresponding to
-- contract number and BO revenue.
--****************************************************************
   PROCEDURE returnminshelflife (
      i_con_n_contract_number   IN       tbl_tva_contract.con_n_contract_number%TYPE,
      i_bo_n_revenue            IN       NUMBER,
      i_prog_category             IN       TBL_TVA_BOXOFFICE.BO_N_CATEGORY%type,
      o_minshelflife            OUT      tbl_tva_boxoffice.bo_n_min_shelf_life%TYPE
   );
	--****************************************************************
	-- This procedure will delete all territories corresponding to deal memo.
	--****************************************************************
	PROCEDURE prc_tva_delete_all_territories (
		i_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
		o_deleted            OUT      NUMBER
	);
	FUNCTION lic_startdate_validate (
		i_dmad_dt_start   IN   tbl_tva_dm_allocation_detail.dmad_dt_start%TYPE
	)
	RETURN NUMBER;

	--This procedure is used to validate end date
	FUNCTION lic_enddate_validate (
		i_dmad_dt_end   IN   tbl_tva_dm_allocation_detail.dmad_dt_end%TYPE
	)
	RETURN NUMBER;

	PROCEDURE PRC_TVA_VLD_BO_CURR (
		i_con_n_contract_number   IN   tbl_tva_contract.con_n_contract_number%TYPE,
		i_dm_n_number             IN   tbl_tva_deal_memo.DM_N_DEAL_MEMO_NUMBER%TYPE
	);
	PROCEDURE	PRC_TVA_VALD_BUY_PRIC_SINGPD
	(
		p_dmprg_n_dm_number	IN	NUMBER
		,p_connumber		IN	tbl_tva_license.lic_n_con_number%TYPE
		,p_check_flag		IN	NUMBER
	);
--
PROCEDURE x_prc_tva_insert_dm_lee (
      i_dm_number    IN       X_TVA_DM_LICENSEE.DML_DM_NUMBER%TYPE,
      i_lee_number   IN       X_TVA_DM_LICENSEE.DML_LEE_NUMBER%TYPE,
      i_entry_oper   IN       X_TVA_DM_LICENSEE.DML_ENTRY_OPER%TYPE,
      o_status       OUT      X_TVA_DM_LICENSEE.DML_MAP_ID%TYPE
   );

   PROCEDURE x_prc_tva_delete_dm_lee (
      i_DML_LEE_NUMBER         IN      X_TVA_DM_LICENSEE.DML_LEE_NUMBER%TYPE,
	  i_dm_number		   IN 		X_TVA_DM_LICENSEE.DML_DM_NUMBER%TYPE,
      i_entry_oper         IN       X_TVA_DM_LICENSEE.DML_ENTRY_OPER%TYPE,
      o_status             OUT      NUMBER,
      o_updateddata        OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

  PROCEDURE x_prc_tva_view_dm_lee (
    i_dm_number    IN       X_TVA_DM_LICENSEE.DML_DM_NUMBER%TYPE,
    o_dm_licensee_data   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );

  PROCEDURE x_prc_set_dm_number
                              (
                              i_dm_number                IN  tbl_tva_deal_memo.DM_N_DEAL_MEMO_NUMBER%TYPE
                              );
  FUNCTION x_fnc_get_dm_number RETURN tbl_tva_deal_memo.DM_N_DEAL_MEMO_NUMBER%TYPE;

PROCEDURE x_prc_add_deal_medplatmdevcomp
(
i_ald_id               		IN     TBL_TVA_DM_ALLOCATION_DETAIL.DMAD_N_NUMBER%TYPE,
i_med_DEV_PLATM_ID    		IN     varchar_array,
i_med_rights_on_device    IN     varchar_array,
i_med_comp_rights_id      IN     varchar_array,
i_med_IS_COMP_RIGHTS   		IN     varchar_array,
i_entry_oper           		IN     x_tv_memo_medplatdevcompat_map.MEM_MPDC_ENTRY_OPER%TYPE,
o_status                  OUT    NUMBER
);

  PROCEDURE x_prc_get_default_rights
  (
    i_con_short_name    IN     tbl_tva_contract.con_v_short_name%TYPE,
		o_dm_blank_rights      OUT sys_refcursor,
		o_def_rights           OUT sys_refcursor
	);

 PROCEDURE x_prc_get_prog_info
                              (
                               i_con_v_short_name        IN       tbl_tva_contract.con_v_short_name%TYPE,
                               o_prog_info  OUT sys_refcursor
                              );

  PROCEDURE x_prc_user_is_qa
  (
    i_company         IN      fid_company.com_short_name%TYPE,
    i_username        IN      men_user.usr_id%TYPE,
    i_licensee        IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    o_rights             OUT  VARCHAR2
  );

  PROCEDURE x_prc_get_default_territories
  (
    i_dm_number       IN      tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
    o_territory_data     OUT  c_cursor_tva_dealmemo
  );
  PROCEDURE x_prc_inst_lic_payplan
					   (
					       I_LICPP_DM_NUMBER      IN     X_TVA_LIC_PAYMENT_PLAN.LICPP_DM_NUMBER%TYPE,
						   I_LICPP_LIC_NUMBER     IN     X_TVA_LIC_PAYMENT_PLAN.LICPP_LIC_NUMBER%TYPE,
						   I_LIC_START_DATE		  IN 	 TBL_TVA_LICENSE.LIC_DT_START_DATE%TYPE,
						   i_entry_oper			  IN	 X_TVA_LIC_PAYMENT_PLAN.LICPP_ENTRY_OPER%TYPE
					   );

PROCEDURE x_prc_val_buy_price_allocation
										(
										 i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE
										);
PROCEDURE x_prc_get_dm_lee
                                                    (
                                                     i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
                                                     o_licensee_data                       OUT   sys_refcursor
                                                    );
 PROCEDURE x_prc_val_lvr_date  (
                                                            i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE
                                                           );
 PROCEDURE prc_tva_returnmediatypes (
      i_con_n_contract_number   IN       tbl_tva_contract.con_n_contract_number%TYPE,
      c_conmediatypes           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   );
END pkg_tva_dealmemo;

/


CREATE OR REPLACE PACKAGE BODY         "PKG_TVA_DEALMEMO"
AS
/****************************************************************
REM Module        : Acquisition Module
REM Client         : MNET
REM File Name        : pkg_tva_dealmemo.sql
REM Form Name        : Deal Memo Maintenance
REM Purpose         : For maintening Deal memo
REM Author        :  :Jawahar Garg
REM Creation Date   : 13 Sep 2015
REM Type            : Database Package
REM Change History  :Rewrite
****************************************************************/
--****************************************************************
-- This procedure searches Deal memo.
--****************************************************************
   PROCEDURE prc_tva_search_dealmemo (
      i_dm_n_deal_memo_number   IN       VARCHAR2,
      i_con_v_short_name        IN       tbl_tva_contract.con_v_short_name%TYPE,
      i_dm_amort_code           IN       tbl_tva_deal_memo.dm_v_amort_code%TYPE,
      i_dm_v_status             IN       tbl_tva_deal_memo.dm_v_status%TYPE,
      i_dm_n_type               IN       tbl_tva_deal_memo.dm_n_type%TYPE,
      i_dm_dt_start_date        IN       tbl_tva_deal_memo.dm_dt_deal_memo_date%TYPE,
      i_dm_dt_end_date          IN       tbl_tva_deal_memo.dm_dt_deal_memo_date%TYPE,
      i_entry_oper              IN       tbl_tva_deal_memo.dm_v_entry_oper%TYPE,
      o_searchdealmemo          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
      stmt_str            VARCHAR2 (5000);
      nextdate            tbl_tva_deal_memo.dm_dt_deal_memo_date%TYPE;
      l_searchcondition   NUMBER;
       l_lee_code_attr     varchar2(1);
   BEGIN
          select cod_attr
             INTO l_lee_code_attr
           from fid_code
        where cod_type = 'TVOD LEE USER BASE'
        and COD_VALUE != 'HEADER';

      l_searchcondition := 0;
      stmt_str :=
         'SELECT dealmemo.dm_n_deal_memo_number,  -- Deal memo number
                 contract.con_v_short_name,       -- Contract short name
                 company.com_name,                -- DM Supplier company name
                 dealmemo.dm_v_status,            -- Deal memo status
                 dealmemo.dm_n_type,             -- Deal memo type number
                 dealmemotype.deal_type,           -- Deal memo type
                 dealmemo.DM_DT_DEAL_MEMO_DATE,   -- Date
                 dealmemo.DM_V_AMORT_CODE,         -- Amort Code
                 dealmemo.DM_V_CURRENCY,            -- Currency
                 com.COM_SHORT_NAME contractentity,  -- Contract Entity
                 lee.TVOD_V_LEE_SHORT_NAME            -- Main Licensee
            FROM tbl_tva_deal_memo dealmemo,
                 tvod_deal_memo_type dealmemotype,
                 tbl_tva_contract contract,
                 fid_company company,
                 fid_company com,
                 tvod_licensee lee
           WHERE dealmemo.dm_n_con_number = contract.con_n_contract_number (+)
             AND dealmemotype.dm_type_id = dealmemo.dm_n_type
             AND dealmemo.dm_n_supp_com_number = company.com_number
             AND com.com_number = dealmemo.DM_N_CON_COM_NUMBER
             AND lee.TVOD_N_LEE_NUMBER = dealmemo.DM_N_LEE_NUMBER ';

      IF i_dm_dt_start_date IS NOT NULL AND i_dm_dt_end_date IS NOT NULL
      THEN
         l_searchcondition := 1;
         nextdate := i_dm_dt_end_date + 1;
         stmt_str :=
               stmt_str
            || ' AND dealmemo.dm_dt_deal_memo_date <> '
            || ''''
            || nextdate
            || ''''
            || ' AND dealmemo.dm_dt_deal_memo_date BETWEEN '
            || ''''
            || i_dm_dt_start_date
            || ''''
            || ' AND '
            || ''''
            || nextdate
            || '''';
      END IF;

      IF i_dm_n_type IS NOT NULL
      THEN
         l_searchcondition := 1;
         stmt_str :=
               stmt_str
            || ' AND dealmemo.dm_n_type = '
            || ''''
            || i_dm_n_type
            || '''';
      END IF;

      IF i_dm_v_status IS NOT NULL AND UPPER (i_dm_v_status) <> 'ALL'
      THEN
         l_searchcondition := 1;
         stmt_str :=
               stmt_str
            || ' AND UPPER(dealmemo.dm_v_status) = UPPER('
            || ''''
            || i_dm_v_status
            || ''''
            || ')';
      END IF;

      IF i_con_v_short_name IS NOT NULL
      THEN
         l_searchcondition := 1;
         stmt_str :=
               stmt_str
            || ' AND UPPER(contract.con_v_short_name) LIKE UPPER('
            || ''''
            || i_con_v_short_name
            || ''''
            || ')';
      END IF;

      IF i_dm_amort_code IS NOT NULL
      THEN
         l_searchcondition := 1;
         stmt_str :=
               stmt_str
            || ' AND UPPER(dealmemo.DM_V_AMORT_CODE) LIKE UPPER('
            || ''''
            || i_dm_amort_code
            || ''''
            || ')';
      END IF;

      IF i_dm_n_deal_memo_number IS NOT NULL
      THEN
         l_searchcondition := 1;
         stmt_str :=
               stmt_str
            || ' AND to_char(dealmemo.dm_n_deal_memo_number) LIKE '
            || ''''
            || i_dm_n_deal_memo_number
            || '''';
      END IF;

      IF l_searchcondition = 0
      THEN
         stmt_str := stmt_str || ' AND rownum < 501 ';
      END IF;



      IF l_lee_code_attr  = 'Y'
      THEN
           stmt_str :=
               stmt_str || 'AND exists (select 1 from tbl_tva_licensee_user where
                                          LEEU_V_USR_ID =' || '''' || i_entry_oper || '''' ||
                                          'and LEEU_N_LEE_NUMBER = DM_N_LEE_NUMBER
                                          and LEEU_V_SELECT_PRIV = ''Y'')';


      END IF;

      stmt_str :=
            stmt_str
         || ' ORDER BY dealmemo.dm_dt_deal_memo_date DESC, dealmemo.dm_n_deal_memo_number DESC';
      DBMS_OUTPUT.put_line ('stmt_str - ' || stmt_str);

      OPEN o_searchdealmemo FOR stmt_str;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_search_dealmemo;

--****************************************************************
-- This procedure searches Deal Memo Details.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dealmemo_details (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemodetails     OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo,
      o_viewdmmediatypes        OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      OPEN o_viewdealmemodetails FOR
          SELECT dealmemo.dm_n_deal_memo_number,           -- Deal memo number
                      contract.con_v_short_name,-- DM Contract short name
                      contract.con_v_name,                           -- DM Contract
                      supplier.com_name supplier_company,-- DM Supplier company
                      supplier.com_short_name supp_company_short_name,-- DM Supplier company short name
                      conentity.com_name contract_company,   -- DM Contract company
                      conentity.com_short_name con_company_short_name,-- DM Contract company short name
                      licensee.tvod_n_lee_number, licensee.tvod_v_lee_short_name,  -- DM licensee short name
                      licensee.tvod_v_lee_name,-- DM Licensee name
                      dealmemo.dm_v_status,   -- DM Status
                      dealmemo.dm_n_type,                                -- DM Type
                      dealmemo.dm_dt_deal_memo_date, -- Deal memo date
                      dealmemo.dm_n_memo_price, -- Deal memo price
                      dealmemo.dm_v_approver,-- Deal memo approver
                      dealmemo.dm_dt_approval_date,  -- Deal memo approval date
                      dealmemo.dm_v_buyer, -- Deal memo buyer
                      dealmemo.dm_dt_buyer_date,-- Deal memo buyer date
                      dealmemo.dm_v_delivery_mode, -- Deal memo delivery mode
                      dealmemo.dm_v_delivery_cost,  -- Deal memo delivery cost
                      dealmemo.dm_v_return_cost,-- Deal memo return cost
                      dealmemo.dm_v_del_return_info,-- Deal memo delivery return info
                      dealmemo.dm_v_delivery_other,-- Deal memo delivery other
                      dealmemo.dm_c_broader_rights, -- Deal memo broader rights
                      dealmemo.dm_c_open_tim_exbt_allowed, -- Deal memo open time exhibition allowed
                      dealmemo.dm_v_comments,-- Deal memo comments
                      dealmemo.dm_dt_date_prior,   -- Deal memo material date prior
                      dealmemo.dm_dt_date_not_later_than,-- Deal memo material date not later than
                      dealmemo.dm_v_material_other,     -- Deal memo material other
                      dealmemo.dm_v_currency, -- Deal memo currency
                      dealmemo.dm_v_amort_code,             -- Deal memo amort code
                      NVL (dealmemo.dm_n_update_count, 0) dm_n_update_count, -- Deal memo update count
                      dealmemo.dm_bo_rev_cur--Added by jawahar for TVOD CR.
         FROM   tbl_tva_deal_memo dealmemo,
                tbl_tva_contract contract,
                fid_company supplier,
                fid_company conentity,
                tvod_licensee licensee
          WHERE dealmemo.dm_n_con_number = contract.con_n_contract_number(+)
            AND dealmemo.dm_n_supp_com_number = supplier.com_number
            AND dealmemo.dm_n_con_com_number = conentity.com_number
            AND dealmemo.dm_n_lee_number = licensee.tvod_n_lee_number
            AND dealmemo.dm_n_deal_memo_number = i_dm_n_deal_memo_number;

      OPEN o_viewdmmediatypes FOR
         SELECT   mediatypes.media_type,
                  dmmediatypemapping.n_dm_medt_mapp_media_number
             FROM tvod_mediatypes mediatypes,
                  tbl_tva_dm_medt_mapping dmmediatypemapping
            WHERE dmmediatypemapping.n_dm_medt_mapp_media_number =
                                                      mediatypes.media_type_id
              AND dmmediatypemapping.n_dm_medt_mapp_dm_number =
                                                       i_dm_n_deal_memo_number
         ORDER BY dmmediatypemapping.n_dm_medt_mapp_media_number;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_view_dealmemo_details;

--****************************************************************
-- This procedure searches Deal Memo Programmes.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_programmes
   (
      i_dm_n_deal_memo_number    IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemoprogrammes   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo,
      o_viewdealmemolicenses     OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
    ,o_viewdealmemomedrights    OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo,          --Added by Jawahar
    o_viewdefaultmedrights     OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo            --Added by Jawahar
   )
   AS
   v_con_number                   tbl_tva_deal_memo.DM_N_CON_NUMBER%TYPE;
   v_dev_compt                    VARCHAR2(500);
   v_dm_rights                    VARCHAR2(5000);
   v_default_rights               VARCHAR2(5000);
   v_def_comp      				  VARCHAR2(5000);

   BEGIN
      OPEN o_viewdealmemoprogrammes FOR
         SELECT   dmprogramme.dmprg_n_number,                       -- DM Programme number
                  dmprogramme.dmprg_c_premium,                      -- DM Programme premium
                  dmprogramme.dmprg_v_type,                         -- DM Programme type
                  programme.gen_title,                              -- DM Programme title
                  dmprogramme.dmprg_n_gen_refno,                    -- DM Programme gen refno
                  dmprogramme.dmprg_n_bo_rev_zar,                   -- DM Programme box office revenue in zar
                  dmprogramme.dmprg_n_bo_rev_usd,                   -- DM Programme box office revenue in usd
                  dmprogramme.dmprg_n_min_shelf_life,               -- DM Programme minimum shelf life
                  dmprogramme.dmprg_dt_lvr,                         -- DM Programme local video release date
                  dmprogramme.dmprg_n_day_post_lvr,                 -- DM Programme days post lvr
                  dmprogramme.dmprg_v_formats,                      -- DM Programme formats
                  dmprogramme.dmprg_n_total_price,                  -- DM Programme total price
                  dmprogramme.dmprg_v_comments,                     -- DM Programme comments
                  dmprogramme.dmprg_n_bo_category,                  -- BO category number of pgm
                  bocat.PC_PGM_CATEGORY_CODE dmprg_v_prog_category, -- Programme category of pgm
                  DMPRG_V_SUB_CATEGORY BOC_V_CATEGORY,              -- BO CATEGORY
                  NVL (dmprogramme.dmprg_n_update_count,
                       0
                      ) DMPRG_N_UPDATE_COUNT,                       -- DM Programme update count,
                  PROGRAMME.GEN_RELEASE_YEAR GEN_RELEASE_YEAR,
                  dmprogramme.DMPRG_MIN_SHELF_life_push,              --Added by Jawahar
                  dmprogramme.DMPRG_MIN_SHELF_life_pull,              --Added By Jawahar
                  dmprogramme.dmprg_bo_rev,                           --Added By Jawahar
                  (SELECT nvl(bo_lvr_applicable,'N')
                     FROM tbl_tva_boxoffice
                    WHERE BO_N_CONTRACT_NUMBER = (SELECT dm_n_con_number
                                                    FROM tbl_tva_deal_memo
                                                   WHERE dm_n_deal_memo_number = dmprg_n_dm_number)
                      AND BO_N_CATEGORY = dmprogramme.dmprg_n_bo_category
                      AND BO_V_SUB_CATEGORY = dmprg_v_sub_category) bo_lvr_applicable
             FROM tbl_tva_dm_prog dmprogramme,
                  FID_GENERAL PROGRAMME,
                  SGY_PB_PGM_CATEGORY BOCAT
            where DMPROGRAMME.DMPRG_N_GEN_REFNO = PROGRAMME.GEN_REFNO(+)
              and BOCAT.PC_PGM_CATEGORY_CODE(+) = DMPROGRAMME.DMPRG_N_BO_CATEGORY
              AND dmprogramme.dmprg_n_dm_number = i_dm_n_deal_memo_number
         ORDER BY dmprogramme.dmprg_n_number;

      OPEN o_viewdealmemolicenses FOR
         SELECT   dmprogallocation.dmad_n_number,                 -- DM Programme allocation number
                  dmprogallocation.dmad_n_dmprg_number,           -- DM Programme number
                  dmprogallocation.dmad_n_lee_number,             -- DM Programme allocation licensee number
                  dmprogallocation.dmad_dt_start,                 -- DM Programme allocation start date
                  dmprogallocation.dmad_dt_end,                   -- DM Programme allocation end date
                  dmprogallocation.dmad_n_amount,                 -- DM Programme allocation amount
                  licensee.tvod_v_lee_short_name,                 -- DM Programme allocation licensee short name
                  dmprogallocation.dmad_c_tba,                    -- DM Programme allocation TBA
                  NVL
                     (dmprogallocation.dmad_n_update_count,
                      0
                     ) dmad_n_update_count,                       -- DM Programme allocation update count
                  dmprogallocation.DMAD_DAYS_POST_LVR             --Added by Jawahar
         FROM     tbl_tva_dm_allocation_detail dmprogallocation,
                  tvod_licensee licensee
            WHERE dmprogallocation.dmad_n_lee_number = licensee.tvod_n_lee_number
              AND dmprogallocation.dmad_n_dmprg_number IN ( SELECT dmprogramme.dmprg_n_number
                                                              FROM tbl_tva_dm_prog dmprogramme
                                                             WHERE dmprogramme.dmprg_n_dm_number = i_dm_n_deal_memo_number
                                                          )
         ORDER BY dmprogallocation.dmad_n_number;


        BEGIN
             SELECT DM_N_CON_NUMBER
               INTO v_con_number
               FROM tbl_tva_deal_memo
              WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
        v_con_number := NULL;
        END;


   x_prc_set_dm_number(i_dm_n_deal_memo_number);

   v_dev_compt := x_tv_fnc_get_compat;
   v_def_comp  := x_tv_fnc_get_def_compat;

   v_dm_rights := '
                   SELECT *
                    FROM(
                         SELECT DMPRG_N_DM_NUMBER,
                                DMAD_N_DMPRG_NUMBER,
                                MEM_MPDC_ALD_ID,
                                MEM_IS_COMP_RIGHTS,
                                Device_Code,
                                comp_code,
                                Platform_Code,
                                device_id,
                                Platform_desc,
                                RIGHTS_ON_DEVICE
                           FROM x_vw_deal_comp_map
                        )
                    pivot( MAX(mem_is_comp_rights) for comp_code in('||v_dev_compt||')
                    )';


   IF v_con_number IS NOT NULL
   THEN
       pkg_tva_contract.x_prc_set_con_number(v_con_number);

       v_default_rights   :=' SELECT *
                                FROM (SELECT
                                        DEVICE_CODE,
                                        PLATFORM_CODE,
                                        DEVICE_ID device_plat_id,
                                        COMP_CODE,
                                        con_is_comp_rights
                                FROM x_vw_cont_comp_map
                                )
                              pivot( MAX(con_is_comp_rights) for comp_code in('||v_def_comp||')
                              )';
   ELSE
       v_default_rights   := ' SELECT *
                                 FROM
                                    (
                                      SELECT Device_Code,
                                            Platform_Code,
                                            dev_plat_map_id as Device_Plat_Id,
                                            comp_code,
                                            dev_plat_comp_rights
                                       FROM X_VW_DEVICE_PLAT_DETAILS
                                      WHERE EXISTS ( SELECT 1
                                                      FROM X_CP_MEDPLATDEVCOMP_SERVC_MAP
                                                     where MPDCS_MPDC_ID  = plat_comp_map_id
                                                       and MPDCS_MED_SERVICE_CODE = ''TVOD''
                                                    )
                                    )
                               PIVOT (
                                      MAX(dev_plat_comp_rights) for comp_code in('||v_def_comp||')
                                     )';
   END IF;

   OPEN o_viewdealmemomedrights
   FOR v_dm_rights;

   OPEN o_viewdefaultmedrights
   FOR v_default_rights;

   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_view_dm_programmes;

--****************************************************************
-- This procedure searches Deal Memo Territories.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_territories (
      i_dm_n_deal_memo_number     IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemoterritories   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      OPEN o_viewdealmemoterritories FOR
         SELECT   dmterritory.dmt_n_number,     -- DM Territory mapping key
                  dmterritory.dmt_n_territory,  -- DM Territory number
                  territories.v_ter_name,       -- DM Territory name
                  territories.v_ter_code,       -- DM Territory code
                  dmterritory.dmt_v_rights,     -- DM Territory rights
                  codes.cod_description,        -- DM Territory rights code description
                  NVL (dmterritory.dmt_n_update_count, 0) dmt_n_update_count,-- DM Territory update count
                  dmterritory.dmt_v_is_linked dmt_v_is_linked
             FROM tbl_tva_dm_territory dmterritory,
                  tbl_tva_territory territories,
                  fid_code codes
            WHERE dmterritory.dmt_n_territory = territories.n_ter_number(+)
              AND codes.cod_value != 'HEADER'
              AND codes.cod_type = 'LIC_RGH_CODE'
              AND dmterritory.dmt_v_rights = codes.cod_value
              AND dmterritory.dmt_n_dm_number = i_dm_n_deal_memo_number
         ORDER BY territories.v_ter_code;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_view_dm_territories;
--****************************************************************
-- This procedure searches Deal Memo Minimum Guarantee Payment.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_minguarantee (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewminguarantee        OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      OPEN o_viewminguarantee FOR
         SELECT   dmmgpayment.dmmgpay_n_number,       -- DM MG Payment number
                                               dmmgpayment.dmmgpay_n_order,-- DM MG Payment order
                  dmmgpayment.dmmgpay_n_pay_percent, -- DM MG Payment percent
                  dmmgpayment.dmmgpay_v_pay_code,       -- DM MG Payment code
                  dmmgpayment.dmmgpay_n_pay_amount,   -- DM MG Payment amount
                  dmmgpayment.dmmgpay_n_no_of_days, -- DM MG Payment no. of days
                  dmmgpayment.dmmgpay_n_pay_rule_number, -- DM MG Payment rule number
                  dmmgpaytrule.dmmgpr_v_name,     -- DM MG Payment  rule name
                                             dmmgpaytrule.dmmgpr_v_formula,-- DM MG Payment formula
                  dmmgpayment.dmmgpay_v_comments, -- DM MG Payment comments
                  dmmgpayment.dmmgpay_v_currency,
                  NVL
                     (dmmgpayment.dmmgpay_n_update_count,
                      0
                     ) dmmgpay_n_update_count   -- DM MG Payment update count
             FROM tbl_tva_dm_mg_payment dmmgpayment,
                  tbl_tva_dm_mg_payment_rule dmmgpaytrule
            WHERE dmmgpayment.dmmgpay_n_pay_rule_number = dmmgpaytrule.dmmgpr_n_number(+)
              AND dmmgpayment.dmmgpay_n_dm_number = i_dm_n_deal_memo_number
         ORDER BY dmmgpayment.dmmgpay_n_order;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_view_dm_minguarantee;

--****************************************************************
-- This procedure searches Deal Memo Overage Payment.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_overages (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewoverages            OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      OPEN o_viewoverages FOR
          SELECT dmoapayment.dmpo_n_number,            -- DM OA Payment number -- DM OA Payment order
                      dmoapayment.dmpo_n_no_of_days,   -- DM OA Payment no. of days
                      dmoapayment.dmpo_n_pay_rule_number,     -- DM OA Payment rule
                      dmoapayrule.dmoapr_v_formula,      -- DM OA Payment rule name
                      dmoapayment.dmpo_v_pay_code,
                      dmoapayment.dmpo_v_currency,
                      NVL (dmoapayment.dmpo_n_update_count, 0) dmpo_n_update_count -- DM OA Payment update count
         FROM   tbl_tva_dm_payment_overage dmoapayment,
                tbl_tva_dm_oa_payment_rule dmoapayrule
          WHERE dmoapayment.dmpo_n_pay_rule_number = dmoapayrule.dmoapr_n_number(+)
            AND dmoapayment.dmpo_n_dm_number = i_dm_n_deal_memo_number;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_view_dm_overages;

--****************************************************************
-- This procedure searches Deal Memo Materials.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_materials (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemomaterials   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      OPEN o_viewdealmemomaterials FOR
          SELECT   dmmaterial.dmm_n_number,              -- DM Material number
                        dmmaterial.dmm_n_com_number,-- DM Material company number
                        company.com_name,                    -- DM Material company
                        dmmaterial.dmm_v_class, -- DM Material class
                        dmmaterial.dmm_v_broadcast,        -- DM Material broadcast
                        dmmaterial.dmm_v_sound,-- DM Material sound
                        dmmaterial.dmm_v_item,                  -- DM Material item
                        dmmaterial.dmm_v_comments,-- DM Material  comments
                        NVL (dmmaterial.dmm_n_update_count, 0) dmm_n_update_count-- DM Material update count
         FROM     tbl_tva_dm_material dmmaterial, fid_company company
            WHERE dmmaterial.dmm_n_com_number = company.com_number(+)
              AND dmmaterial.dmm_n_dm_number = i_dm_n_deal_memo_number
         ORDER BY company.com_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_view_dm_materials;

--****************************************************************
-- This procedure searches Deal Memo History.
-- This procedure input is Deal Memo Number.
--****************************************************************
   PROCEDURE prc_tva_view_dm_history (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_viewdealmemohistory     OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      OPEN o_viewdealmemohistory FOR
          SELECT   dmh_v_from_status,                        -- DM from status
                        dmh_v_action,                -- DM action
                        dmh_v_to_status,-- DM to status
                        dmh_dt_entry_date,                -- DM status changed date
                        dmh_v_entry_oper, -- DM status changed by
                        dmh_n_update_count               -- DM history update count
             FROM tbl_tva_dm_history
            WHERE dmh_n_dm_number = i_dm_n_deal_memo_number
         ORDER BY dmh_dt_entry_date;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_view_dm_history;

--****************************************************************
-- This procedure Creates (Inserts) New Deal Memo.
-- This procedure input are Deal Memo parameters.
--****************************************************************
   PROCEDURE prc_tva_create_deal_memo (
      i_dm_n_con_number         IN       tbl_tva_deal_memo.dm_n_con_number%TYPE,
      i_dm_dt_deal_memo_date    IN       tbl_tva_deal_memo.dm_dt_deal_memo_date%TYPE,
      i_dm_n_memo_price         IN       tbl_tva_deal_memo.dm_n_memo_price%TYPE,
      i_dm_n_lee_number         IN       tbl_tva_deal_memo.dm_n_lee_number%TYPE,
      i_dm_v_currency           IN       tbl_tva_deal_memo.dm_v_currency%TYPE,
      i_dm_n_type               IN       tbl_tva_deal_memo.dm_n_type%TYPE,
      i_dm_v_amort_code         IN       tbl_tva_deal_memo.dm_v_amort_code%TYPE,
      i_dm_n_supp_com_number    IN       tbl_tva_deal_memo.dm_n_supp_com_number%TYPE,
      i_dm_n_con_com_number     IN       tbl_tva_deal_memo.dm_n_con_com_number%TYPE,
      i_dm_v_entry_oper         IN       tbl_tva_deal_memo.dm_v_entry_oper%TYPE,
      i_dm_bo_rev_cur           IN       tbl_tva_deal_memo.dm_bo_rev_cur%TYPE,
      o_dm_n_deal_memo_number   OUT      tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_dm_v_status             OUT      tbl_tva_deal_memo.dm_v_status%TYPE
   )
   AS
      l_dm_n_deal_memo_number   NUMBER;
      o_dm_status               VARCHAR2 (20);
      l_dm_n_con_number         tbl_tva_deal_memo.dm_n_con_number%TYPE;
      l_dm_count                NUMBER;
      l_con_v_currency          tbl_tva_contract.con_v_currency%TYPE;
      l_con_n_contract_number   tbl_tva_contract.con_n_contract_number%TYPE;
      l_con_v_short_name        tbl_tva_contract.con_v_short_name%TYPE;
   BEGIN
      IF i_dm_n_con_number IS NOT NULL
      THEN
         SELECT con_v_currency
           INTO l_con_v_currency
           FROM tbl_tva_contract
          WHERE con_n_contract_number = i_dm_n_con_number;

         SELECT COUNT (dm_n_deal_memo_number)
           INTO l_dm_count
           FROM tbl_tva_deal_memo
          WHERE dm_n_con_number = i_dm_n_con_number;

         IF l_con_v_currency <> i_dm_v_currency AND l_dm_count > 0
         THEN
            raise_application_error (-20101,
                                        'Contract Currency '
                                     || l_con_v_currency
                                     || ' and Deal Memo Currency '
                                     || i_dm_v_currency
                                     || ' does not match'
                                    );
         ELSIF l_con_v_currency <> i_dm_v_currency AND l_dm_count = 0
         THEN
            UPDATE tbl_tva_contract
               SET con_v_currency = i_dm_v_currency
             WHERE con_n_contract_number = i_dm_n_con_number;
         END IF;
      END IF;

      IF i_dm_n_con_number = 0
      THEN
         l_dm_n_con_number := NULL;
      ELSE
         l_dm_n_con_number := i_dm_n_con_number;
      END IF;

      l_dm_n_deal_memo_number := get_seq ('SEQ_DM_N_DEAL_MEMO_NUMBER');
      pkg_tva_dealmemo.prc_tva_create_history ('NEW',
                                               l_dm_n_deal_memo_number,
                                               i_dm_n_type,
                                               i_dm_v_entry_oper,
                                               o_dm_status
                                              );

      INSERT INTO tbl_tva_deal_memo
                  (dm_n_deal_memo_number,
                   dm_n_con_number,
                   dm_n_supp_com_number,
                   dm_n_con_com_number,
                   dm_dt_deal_memo_date,
                   dm_n_memo_price,
                   dm_v_status,
                   dm_n_lee_number,
                   dm_v_currency,
                   dm_n_type,
                   dm_v_amort_code,
                   dm_dt_entry_date,
                   dm_v_entry_oper,
                   dm_n_update_count,
                   dm_dt_modified_on,
                   dm_v_modified_by,
                   dm_bo_rev_cur              --Added by jawahar for TVOD CR.
                  )
           VALUES (l_dm_n_deal_memo_number,
                   NVL (l_dm_n_con_number, NULL),
                   i_dm_n_supp_com_number,
                   i_dm_n_con_com_number,
                   i_dm_dt_deal_memo_date,
                   i_dm_n_memo_price,
                   o_dm_status,
                   i_dm_n_lee_number,
                   i_dm_v_currency,
                   i_dm_n_type,
                   i_dm_v_amort_code,
                   SYSDATE,
                   UPPER (i_dm_v_entry_oper),
                   0,
                   SYSDATE,
                   UPPER (i_dm_v_entry_oper),
                   i_dm_bo_rev_cur        --Added by jawahar for TVOD CR.
                  )
        RETURNING dm_n_deal_memo_number
             INTO l_dm_n_deal_memo_number;

      IF l_dm_n_deal_memo_number > 0
      THEN
         COMMIT;
         o_dm_v_status := o_dm_status;
         o_dm_n_deal_memo_number := l_dm_n_deal_memo_number;
      ELSE
         l_dm_n_deal_memo_number := -1;
         ROLLBACK;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_create_deal_memo;

--****************************************************************
-- This procedure Creates Deal memo contract.
--****************************************************************
   FUNCTION create_new_con (
      p_memid                   IN   tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      p_con_n_type              IN   tbl_tva_contract.con_n_type%TYPE,
      p_con_n_price             IN   tbl_tva_contract.con_n_price%TYPE,
      p_con_n_lee_number        IN   tbl_tva_contract.con_n_lee_number%TYPE,
      p_con_n_com_number        IN   tbl_tva_contract.con_n_com_number%TYPE,
      p_con_n_supp_com_number   IN   tbl_tva_contract.con_n_supp_com_number%TYPE,
      p_con_v_currency          IN   tbl_tva_contract.con_v_currency%TYPE,
      p_dm_format               IN   tbl_tva_dm_prog.dmprg_v_formats%TYPE,
      p_user_id                 IN   tbl_tva_contract.con_v_entry_oper%TYPE
   )
      RETURN NUMBER
   IS
      newconnumber                NUMBER;
      newconshortname             VARCHAR2 (15);
      newconname                  VARCHAR2 (15);
      systemident                 VARCHAR2 (2);
      --Added by Jawahar
      v_con_min_shelf_life_push     tbl_tva_contract.con_min_shelf_life_push%TYPE;
      v_con_min_shelf_life_pull     tbl_tva_contract.con_min_shelf_life_pull%TYPE;
      v_con_subs_vw_period          tbl_tva_contract.con_subs_vw_period%TYPE;
      v_con_shelf_space_per         tbl_tva_contract.con_shelf_space_per%TYPE;
   BEGIN
      DBMS_OUTPUT.put_line ('In contract insert');

      BEGIN
         SELECT spa_value
           INTO systemident
           FROM fid_system_parm
          WHERE spa_id = 'SYSTEM_ID';
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20118,'There is no System Identifier Set Up');
      END;

      /*Added By Jawahar*/
            SELECT MIN(DMPRG_MIN_SHELF_life_push),
                   MIN(DMPRG_MIN_SHELF_life_pull)
              INTO v_con_min_shelf_life_push,
                   v_con_min_shelf_life_pull
             FROM  TBL_TVA_DM_PROG
            WHERE DMPRG_N_DM_NUMBER = p_memid;
      /*End */


      DBMS_OUTPUT.put_line ('After spa value');
      newconnumber    := get_seq ('SEQ_CON_N_CONTRACT_NUMBER');
      newconshortname := TO_CHAR(SYSDATE,'YY')||'-'||LTRIM (TO_CHAR (newconnumber, '00000'),' ')|| '-'|| 'TVOD';

      DBMS_OUTPUT.put_line ('After con short name');
      newconname := newconshortname;
      DBMS_OUTPUT.put_line ('B4 contract insert');

      BEGIN
         INSERT INTO tbl_tva_contract
                     (con_n_contract_number,
                      con_v_name,
                      con_v_short_name,
                      con_n_com_number,
                      con_n_supp_com_number,
                      con_n_lee_number,
                      con_n_type,
                      con_v_status,
                      con_v_currency,
                      con_v_formats,
                      con_dt_start_date,
                      con_dt_end_date,
                      con_n_price,
                      con_v_comments,
                      con_dt_entry_date,
                      con_v_entry_oper,
                      con_n_update_count,
                      con_dt_modified_on,
                      con_v_modified_by,
                      /*Added by Jawahar */
                      CON_MIN_SHELF_LIFE_PUSH,
                      CON_MIN_SHELF_LIFE_PULL,
                      CON_SUBS_VW_PERIOD,
                      CON_SHELF_SPACE_PER
                      /*End */
                     )
              VALUES (newconnumber,
                      newconname,
                      newconshortname,
                      p_con_n_com_number,
                      p_con_n_supp_com_number,
                      p_con_n_lee_number,
                      p_con_n_type,
                      'A',
                      p_con_v_currency,
                      p_dm_format,
                      NULL,
                      NULL,
                      p_con_n_price,
                      NULL,
                      SYSDATE,
                      UPPER(p_user_id),
                      0,
                      SYSDATE,
                      UPPER(p_user_id),
                      /*Added by Jawahar*/--TODO addd values
                      v_con_min_shelf_life_push,
                      v_con_min_shelf_life_pull,
                      NULL,                                                 --TODO null for time being
                      NULL
                      /*End */
                     );

         DBMS_OUTPUT.put_line ('After contract insert');
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20601,SUBSTR (SQLERRM, 1, 200)|| ' - While creating new contract');
      END;

     /*Add device rights for newly created contract */--Jawahar

     INSERT INTO x_tv_con_medplatdevcompat_map (
                           CON_MPDC_ID,
                           CON_CONTRACT_NUMBER,
                           CON_MPDC_DEV_PLATM_ID,
                           CON_RIGHTS_ON_DEVICE,
                           CON_MPDC_COMP_RIGHTS_ID,
                           CON_IS_COMP_RIGHTS,
                           CON_IS_FEA_SER,
                           CON_MPDC_ENTRY_OPER,
                           CON_MPDC_ENTRY_DATE,
                           CON_MPDC_SERVICE_CODE,
                           CON_MPDC_UPDATE_COUNT)
               SELECT X_SEQ_CON_MPDC_ID.NEXTVAL,
                      newconnumber,
                      MEM_MPDC_DEV_PLATM_ID,
                      MEM_RIGHTS_ON_DEVICE,
                      MEM_MPDC_COMP_RIGHTS_ID,
                      NVL(MEM_IS_COMP_RIGHTS,'N'),
                      'FEA' MEM_MPDC_IS_FEA_SER,
                      MEM_MPDC_ENTRY_OPER,
                      SYSDATE,
                      MEM_MPDC_SERVICE_CODE,0
                FROM(
				select distinct mem_mpdc_dev_platm_id,
								mem_rights_on_device,
								mem_mpdc_comp_rights_id,
								mem_is_comp_rights,
								MEM_MPDC_SERVICE_CODE,
								MEM_MPDC_ENTRY_OPER
				 from x_tv_memo_medplatdevcompat_map
				where mem_mpdc_ald_id IN (
											select A.dmad_n_number
											from TBL_TVA_DM_ALLOCATION_DETAIL A ,TBL_TVA_DM_PROG B
											where A.dmad_n_dmprg_number = B.dmprg_n_number
											AND B.dmprg_n_dm_number = p_memid
										 )
				 AND mem_rights_on_device = 'Y'
				 AND mem_is_comp_rights = 'Y'
				 );


      /*END device rights for newly created contract */--Jawahar

      RETURN newconnumber;

  END create_new_con;
--****************************************************************
-- This procedure Edits Deal Memo Details.
-- This procedure input are Deal Memo parameters.
--****************************************************************
   PROCEDURE prc_tva_update_deal_memo (
      i_dm_n_deal_memo_number        IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      i_dm_n_memo_price              IN       tbl_tva_deal_memo.dm_n_memo_price%TYPE,
      i_dm_n_con_number              IN       tbl_tva_deal_memo.dm_n_con_number%TYPE,
      i_dm_n_supp_com_number         IN       tbl_tva_deal_memo.dm_n_supp_com_number%TYPE,
      i_dm_n_con_com_number          IN       tbl_tva_deal_memo.dm_n_con_com_number%TYPE,
      i_dm_n_type                    IN       tbl_tva_deal_memo.dm_n_type%TYPE,
      i_dm_n_lee_number              IN       tbl_tva_deal_memo.dm_n_lee_number%TYPE,
      i_dm_v_currency                IN       tbl_tva_deal_memo.dm_v_currency%TYPE,
      i_dm_v_amort_code              IN       tbl_tva_deal_memo.dm_v_amort_code%TYPE,
      I_DM_C_BROADER_RIGHTS          in       TBL_TVA_DEAL_MEMO.DM_C_BROADER_RIGHTS%type,
      i_dm_v_comments                IN       tbl_tva_deal_memo.dm_v_comments%TYPE,
      i_dm_dt_date_prior             IN       tbl_tva_deal_memo.dm_dt_date_prior%TYPE,
      i_dm_dt_date_not_later_than    IN       tbl_tva_deal_memo.dm_dt_date_not_later_than%TYPE,
      i_dm_v_material_other          IN       tbl_tva_deal_memo.dm_v_delivery_other%TYPE,
      i_dm_v_delivery_mode           IN       tbl_tva_deal_memo.dm_v_delivery_mode%TYPE,
      i_dm_v_delivery_cost           IN       tbl_tva_deal_memo.dm_v_delivery_cost%TYPE,
      i_dm_v_return_cost             IN       tbl_tva_deal_memo.dm_v_return_cost%TYPE,
      i_dm_v_del_return_info         IN       tbl_tva_deal_memo.dm_v_del_return_info%TYPE,
      i_dm_v_delivery_other          IN       tbl_tva_deal_memo.dm_v_delivery_other%TYPE,
      i_dm_v_modified_by             IN       tbl_tva_deal_memo.dm_v_modified_by%TYPE,
      i_dm_n_update_count            IN       tbl_tva_deal_memo.dm_n_update_count%TYPE,
      i_dm_bo_rev_cur                IN       tbl_tva_deal_memo.dm_bo_rev_cur%TYPE,                    --Added by Jwahar for TVOD_CR
      o_status                       OUT      NUMBER,
      o_updateddata                  OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo,
      o_updatedmmediatypes           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
      l_dm_n_con_number       tbl_tva_deal_memo.dm_n_con_number%TYPE;
      l_con_number            tbl_tva_deal_memo.dm_n_con_number%TYPE;
      l_con_v_formats         tbl_tva_contract.con_v_formats%TYPE;
      l_dmprg_n_total_price   tbl_tva_deal_memo.dm_n_memo_price%TYPE;
      l_con_v_currency        tbl_tva_contract.con_v_currency%TYPE;
      l_dm_count              NUMBER;
   BEGIN
      o_status := -1;

      SELECT NVL (dm_n_con_number, 0)
        INTO l_con_number
        FROM tbl_tva_deal_memo
       WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

      IF i_dm_n_con_number IS NOT NULL
      THEN
         SELECT con_v_currency
           INTO l_con_v_currency
           FROM tbl_tva_contract
          WHERE con_n_contract_number = i_dm_n_con_number;

         SELECT COUNT (dm_n_deal_memo_number)
           INTO l_dm_count
           FROM tbl_tva_deal_memo
          WHERE dm_n_con_number = i_dm_n_con_number
            AND dm_n_deal_memo_number <> i_dm_n_deal_memo_number;

         IF l_con_v_currency <> i_dm_v_currency AND l_dm_count > 0
         THEN
            raise_application_error (-20101,
                                        'Contract Currency '
                                     || l_con_v_currency
                                     || ' and Deal Memo Currency '
                                     || i_dm_v_currency
                                     || ' does not match'
                                    );
         ELSIF l_con_v_currency <> i_dm_v_currency AND l_dm_count = 0
         THEN
            UPDATE tbl_tva_contract
               SET con_v_currency = i_dm_v_currency
             WHERE con_n_contract_number = i_dm_n_con_number;
         END IF;
      END IF;

      IF i_dm_n_con_number = 0
      THEN
         l_dm_n_con_number := NULL;
      ELSE
         l_dm_n_con_number := i_dm_n_con_number;
      END IF;

      UPDATE tbl_tva_dm_mg_payment
         SET dmmgpay_v_currency = i_dm_v_currency,
             dmmgpay_v_modified_by = i_dm_v_modified_by,
             dmmgpay_dt_modified_on = SYSDATE
       WHERE dmmgpay_n_dm_number = i_dm_n_deal_memo_number;

      UPDATE    tbl_tva_deal_memo
            SET dm_n_memo_price = i_dm_n_memo_price,
                dm_n_con_number = l_dm_n_con_number,
                dm_n_supp_com_number = i_dm_n_supp_com_number,
                dm_n_con_com_number = i_dm_n_con_com_number,
                dm_n_type = i_dm_n_type,
                dm_n_lee_number = i_dm_n_lee_number,
                dm_v_currency = i_dm_v_currency,
                dm_v_amort_code = i_dm_v_amort_code,
                dm_dt_date_prior = i_dm_dt_date_prior,
                dm_dt_date_not_later_than = i_dm_dt_date_not_later_than,
                dm_v_material_other = i_dm_v_material_other,
                dm_v_delivery_mode = i_dm_v_delivery_mode,
                dm_v_delivery_cost = i_dm_v_delivery_cost,
                dm_v_return_cost = i_dm_v_return_cost,
                dm_v_del_return_info = i_dm_v_del_return_info,
                dm_v_delivery_other = i_dm_v_delivery_other,
                dm_v_modified_by = UPPER (i_dm_v_modified_by),
                dm_dt_modified_on = SYSDATE,
                dm_n_update_count = NVL (dm_n_update_count, 0) + 1,
                dm_bo_rev_cur   =   i_dm_bo_rev_cur                       --Added by Jwahar for TVOD_CR
          WHERE NVL (dm_n_update_count, 0) = i_dm_n_update_count
            AND dm_n_deal_memo_number = i_dm_n_deal_memo_number
      RETURNING dm_n_update_count
           INTO o_status;

      IF     (i_dm_n_type = 1)
         AND (l_dm_n_con_number <> l_con_number)
         AND (l_dm_n_con_number IS NOT NULL)
      THEN
         FOR i IN (SELECT dmprg_n_number, bo_n_min_guarantee,
                          bo_n_min_shelf_life
                     FROM tbl_tva_dm_prog, tbl_tva_boxoffice
                    WHERE dmprg_n_bo_category = bo_n_category
                      AND dmprg_v_sub_category = bo_v_sub_category
                      AND dmprg_n_dm_number = i_dm_n_deal_memo_number
                      AND bo_n_contract_number = i_dm_n_con_number)
         LOOP
            UPDATE tbl_tva_dm_prog
               SET dmprg_n_total_price = i.bo_n_min_guarantee,
                   dmprg_n_min_shelf_life = i.bo_n_min_shelf_life
             WHERE dmprg_n_number = i.dmprg_n_number;

            COMMIT;
         END LOOP;

         BEGIN
            SELECT NVL (SUM (NVL (dmprg_n_total_price, 0)), 0)
              INTO l_dmprg_n_total_price
              FROM tbl_tva_dm_prog
             WHERE dmprg_n_dm_number = i_dm_n_deal_memo_number;

            UPDATE tbl_tva_deal_memo
               SET dm_n_memo_price = l_dmprg_n_total_price
             WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;

         FOR i IN (SELECT dmmgpay_n_number, dmmgpay_n_pay_percent
                     FROM tbl_tva_dm_mg_payment
                    WHERE dmmgpay_n_dm_number = i_dm_n_deal_memo_number)
         LOOP
            UPDATE tbl_tva_dm_mg_payment
               SET dmmgpay_n_pay_amount =
                      ((l_dmprg_n_total_price * i.dmmgpay_n_pay_percent) / 100
                      )
             WHERE dmmgpay_n_number = i.dmmgpay_n_number;

            COMMIT;
         END LOOP;
      ELSIF     (i_dm_n_type = 1)
            AND (NVL (l_dm_n_con_number, 0) <> l_con_number)
            AND (l_dm_n_con_number IS NULL)
      THEN
         UPDATE tbl_tva_dm_prog
            SET dmprg_n_total_price = NULL,
                dmprg_n_min_shelf_life = NULL
          WHERE dmprg_n_dm_number = i_dm_n_deal_memo_number;

         UPDATE tbl_tva_deal_memo
            SET dm_n_memo_price = l_dmprg_n_total_price
          WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

         UPDATE tbl_tva_dm_mg_payment
            SET dmmgpay_n_pay_amount = 0
          WHERE dmmgpay_n_dm_number = i_dm_n_deal_memo_number;

         COMMIT;
      END IF;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dealmemo.dm_n_deal_memo_number, contract.con_v_short_name,
                   company.com_name, dealmemo.dm_v_status,
                   dealmemo.dm_n_type, dealmemo.dm_dt_deal_memo_date,
                   dealmemo.dm_n_memo_price, dealmemo.dm_v_approver,
                   dealmemo.dm_dt_approval_date, dealmemo.dm_v_buyer,
                   dealmemo.dm_dt_buyer_date, dealmemo.dm_v_delivery_mode,
                   dealmemo.dm_v_delivery_cost, dealmemo.dm_v_return_cost,
                   dealmemo.dm_v_del_return_info,
                   dealmemo.dm_v_delivery_other,
                   DEALMEMO.DM_C_BROADER_RIGHTS,
                   dealmemo.dm_v_comments, dealmemo.dm_dt_date_prior,
                   dealmemo.dm_dt_date_not_later_than,
                   dealmemo.dm_v_material_other,
                   dealmemo.dm_n_supp_com_number,
                   dealmemo.dm_n_con_com_number,
                   NVL (dealmemo.dm_n_update_count, 0) dm_n_update_count
              FROM tbl_tva_deal_memo dealmemo,
                   tbl_tva_contract contract,
                   fid_company company
             WHERE dealmemo.dm_n_con_number = contract.con_n_contract_number(+)
               AND contract.con_n_supp_com_number = company.com_number
               AND dealmemo.dm_n_deal_memo_number = i_dm_n_deal_memo_number;

         OPEN o_updatedmmediatypes FOR
            SELECT mediatypes.media_type,
                   dmmediatypemapping.n_dm_medt_mapp_media_number
              FROM tvod_mediatypes mediatypes,
                   tbl_tva_dm_medt_mapping dmmediatypemapping
             WHERE dmmediatypemapping.n_dm_medt_mapp_media_number =
                                                      mediatypes.media_type_id
               AND dmmediatypemapping.n_dm_medt_mapp_dm_number =
                                                       i_dm_n_deal_memo_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_update_deal_memo;

--****************************************************************
-- This procedure Inserts Deal Memo Programmes.
-- This procedure input are Deal Memo Programme parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_programme (
      i_dmprg_n_dm_number        IN       tbl_tva_dm_prog.dmprg_n_dm_number%TYPE,
      i_dmprg_c_premium          IN       tbl_tva_dm_prog.dmprg_c_premium%TYPE,
      i_dmprg_v_type             IN       tbl_tva_dm_prog.dmprg_v_type%TYPE,
      I_DMPRG_N_GEN_REFNO        in       TBL_TVA_DM_PROG.DMPRG_N_GEN_REFNO%type,
      I_GEN_TITLE                in       FID_GENERAL.GEN_TITLE%type,
      I_GEN_RELEASE_YEAR         in       FID_GENERAL.GEN_RELEASE_YEAR%type,
      i_dmprg_n_bo_rev_zar       IN       tbl_tva_dm_prog.dmprg_n_bo_rev_zar%TYPE,
      i_dmprg_n_bo_rev_usd       IN       tbl_tva_dm_prog.dmprg_n_bo_rev_usd%TYPE,
      i_dmprg_n_min_shelf_life   IN       tbl_tva_dm_prog.dmprg_n_min_shelf_life%TYPE,
      i_dmprg_dt_lvr             IN       tbl_tva_dm_prog.dmprg_dt_lvr%TYPE,
      i_dmprg_n_day_post_lvr     IN       tbl_tva_dm_prog.dmprg_n_day_post_lvr%TYPE,
      i_dmprg_v_formats          IN       tbl_tva_dm_prog.dmprg_v_formats%TYPE,
      i_dmprg_n_total_price      IN OUT   tbl_tva_dm_prog.dmprg_n_total_price%TYPE,
      i_dmprg_v_comments         IN       tbl_tva_dm_prog.dmprg_v_comments%TYPE,
      i_dmprg_v_entry_oper       IN       tbl_tva_dm_prog.dmprg_v_entry_oper%TYPE,
      i_dmprg_v_prog_category    IN       VARCHAR2,
      i_dmprg_v_bo_category      IN       VARCHAR2,
      i_DMPRG_MIN_SHELF_life_ph	 IN       tbl_tva_dm_prog.DMPRG_MIN_SHELF_life_push%TYPE,       --Added by Jawahar
      i_DMPRG_MIN_SHELF_life_pl  IN       tbl_tva_dm_prog.DMPRG_MIN_SHELF_life_pull%TYPE,       --Added By Jawahar
      i_dmprg_bo_rev             IN       TBL_TVA_DM_PROG.dmprg_bo_rev%TYPE,                    --Added By Jawahar
      o_gen_refno                OUT      fid_general.gen_refno%TYPE,
      o_dm_update_count          OUT      NUMBER,
      o_status                   OUT      tbl_tva_dm_prog.dmprg_n_number%TYPE
   )
   AS
      l_seryorn                  VARCHAR2 (1);
      l_liveyorn                 VARCHAR2 (1);
      l_dmprg_n_number           NUMBER;
      insertfailed               EXCEPTION;
      programmeinsertionfailed   EXCEPTION;
      l_gen_refno                NUMBER;
      countseries                NUMBER;
      l_boc_number               VARCHAR2 (30);
      l_dmprg_n_total_price      NUMBER;
      l_con_v_formats            VARCHAR2 (30);
      l_con_number               NUMBER;
      l_dm_type                  NUMBER;
      l_n_min_shelf_life         NUMBER;
      l_min_shelf_life_push      tbl_tva_contract.con_min_shelf_life_push%TYPE;
      l_min_shelf_life_pull      tbl_tva_contract.con_min_shelf_life_pull%TYPE;
      l_con_n_lff_min_gurantee   tbl_tva_contract.con_n_lff_min_gurantee%TYPE;
   BEGIN
      o_status := -1;
      l_gen_refno := -1;
      o_dm_update_count := 0;

      --Checking whether the programme type is series or live
      BEGIN
         SELECT NVL (cod_attr1, 'N') cod_attr1, NVL (cod_attr2, 'N')
                                                                    cod_attr2
           INTO l_seryorn, l_liveyorn
           FROM fid_code
          WHERE cod_type = 'GEN_TYPE' AND cod_value = i_dmprg_v_type;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_seryorn := 'N';
            l_liveyorn := 'N';
      END;

      BEGIN
         begin
            IF i_dmprg_v_prog_category IS NOT NULL
            then

            select PC_PGM_CATEGORY_CODE
                 into L_BOC_NUMBER
                 from sgy_pb_pgm_category
                where UPPER (PC_PGM_CATEGORY_CODE) = TRIM(UPPER (I_DMPRG_V_PROG_CATEGORY));

            END IF;
         END;

         BEGIN
            SELECT dm_n_con_number, dm_n_type
              INTO l_con_number, l_dm_type
              FROM tbl_tva_deal_memo
             WHERE dm_n_deal_memo_number = i_dmprg_n_dm_number;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
         END;

         SELECT COUNT (*)
           INTO countseries
           FROM fid_general
          WHERE UPPER (gen_title) LIKE UPPER (i_gen_title);

         IF (countseries > 0)
         THEN
            IF i_dmprg_n_gen_refno IS NOT NULL
            THEN
               o_gen_refno := i_dmprg_n_gen_refno;
            ELSE
               o_gen_refno := 0;
            END IF;
         ELSE
            o_gen_refno := 0;
         END IF;

         IF NVL (o_gen_refno, 0) = 0
         THEN
            IF i_dmprg_v_type IS NOT NULL
            THEN
               l_gen_refno := get_seq ('SEQ_GEN_REFNO');

               INSERT INTO fid_general
                           (gen_refno, gen_title,
                            gen_type, gen_stu_code, gen_category,
                            GEN_TITLE_WORKING, GEN_EVENT, GEN_SUBGENRE,
                            GEN_ENTRY_DATE, GEN_ENTRY_OPER, GEN_UPDATE_COUNT,
                            GEN_RELEASE_YEAR,
                            GEN_PROG_CATEGORY_CODE,
                            --GEN_BO_CATEGORY_CODE,
                            GEN_TVOD_BO_CATEGORY_CODE --Added by sushma K for BR_15_290_ENH_TVOD BO Category 
                           )
                    VALUES (l_gen_refno, UPPER (i_gen_title),
                            i_dmprg_v_type, '-', '-',
                            UPPER (I_GEN_TITLE), '-', '-',
                            sysdate, UPPER (I_DMPRG_V_ENTRY_OPER), 0,
                            I_GEN_RELEASE_YEAR,
                            trim(I_DMPRG_V_PROG_CATEGORY),
                            --trim(i_dmprg_v_bo_category),
                            trim(i_dmprg_v_bo_category)  --Added by sushma K for BR_15_290_ENH_TVOD BO Category
                           );

               IF SQL%ROWCOUNT <> 1
               THEN
                  RAISE programmeinsertionfailed;
               END IF;
            END IF;

            o_gen_refno := l_gen_refno;
         END IF;

        --Dev.R4 : TVOD : Start : [Devashish Raverkar]_[2016/01/28]
        --Validation : Minimum Shelf Life should not be less than define in Contract.
        IF l_con_number IS NOT NULL
        THEN
          SELECT con_min_shelf_life_push,
                 con_min_shelf_life_pull,
                 con_n_lff_min_gurantee
            INTO l_min_shelf_life_push,
                 l_min_shelf_life_pull,
                 l_con_n_lff_min_gurantee
            FROM tbl_tva_contract
           WHERE con_n_contract_number = l_con_number;

          IF l_min_shelf_life_push > i_dmprg_min_shelf_life_ph
            OR l_min_shelf_life_pull > i_dmprg_min_shelf_life_pl
          THEN
            raise_application_error(-20325,'Minimum Shelf Life should not be less than defined in the Contract.');
          END IF;
        END IF;

         l_dmprg_n_number := get_seq ('SEQ_DMPRG_N_NUMBER');

         IF l_dm_type = 1
         THEN
            BEGIN
               SELECT bo_n_min_guarantee, bo_n_min_shelf_life
                 INTO i_dmprg_n_total_price, l_n_min_shelf_life
                 FROM tbl_tva_boxoffice
                WHERE bo_n_category = l_boc_number
                  AND bo_v_sub_category = i_dmprg_v_bo_category
                  AND bo_n_contract_number = l_con_number;
            EXCEPTION
               WHEN NO_DATA_FOUND
               then
                  i_dmprg_n_total_price := l_con_n_lff_min_gurantee;
                  l_n_min_shelf_life := NULL;
               WHEN OTHERS
               THEN
                  NULL;
            END;
         ELSE
            l_n_min_shelf_life := i_dmprg_n_min_shelf_life;
         END IF;

         BEGIN
            INSERT INTO tbl_tva_dm_prog
                        (dmprg_n_number, dmprg_n_dm_number,
                         dmprg_c_premium, dmprg_v_type,
                         dmprg_n_gen_refno, dmprg_n_bo_rev_zar,
                         dmprg_n_bo_rev_usd, dmprg_n_min_shelf_life,
                         dmprg_dt_lvr, dmprg_n_day_post_lvr,
                         dmprg_v_formats, dmprg_n_total_price,
                         dmprg_v_comments, dmprg_dt_entry_date,
                         dmprg_v_entry_oper, dmprg_n_update_count,
                         dmprg_dt_modified_on, dmprg_v_modified_by,
                         dmprg_n_bo_category, dmprg_v_sub_category,
                         DMPRG_MIN_SHELF_life_push,                    --Added by Jawahar
                         DMPRG_MIN_SHELF_life_pull                      --Added by Jawahar
                         ,dmprg_bo_rev                  --Added By Jawahar
                        /*mei_first_epi_number, mei_episode_count,
                        mei_first_episode_price*/
                        )
                 VALUES (l_dmprg_n_number, i_dmprg_n_dm_number,
                         UPPER (i_dmprg_c_premium), UPPER (i_dmprg_v_type),
                         o_gen_refno, i_dmprg_n_bo_rev_zar,
                         i_dmprg_n_bo_rev_usd, l_n_min_shelf_life,
                         i_dmprg_dt_lvr, i_dmprg_n_day_post_lvr,
                         i_dmprg_v_formats, NVL (i_dmprg_n_total_price, 0),
                         I_DMPRG_V_COMMENTS, sysdate,
                         UPPER (I_DMPRG_V_ENTRY_OPER), 0,
                         sysdate, UPPER (I_DMPRG_V_ENTRY_OPER),
                         l_boc_number,
                         trim(i_dmprg_v_bo_category),
                         i_DMPRG_MIN_SHELF_life_ph,               --Added by Jawahar
                         i_DMPRG_MIN_SHELF_life_pl                --Added by Jawahar
                         ,i_dmprg_bo_rev                            --Added by Jawahar
                        /*1, 1,
                        NVL (i_dmprg_n_total_price, 0)*/
                        )



              RETURNING dmprg_n_number
                   INTO o_status;
         EXCEPTION
            WHEN OTHERS
            THEN
      dbms_output.put_line(l_dmprg_n_number|| i_dmprg_n_dm_number||
                         UPPER (i_dmprg_c_premium)|| UPPER (i_dmprg_v_type)||
                         o_gen_refno|| i_dmprg_n_bo_rev_zar||
                         i_dmprg_n_bo_rev_usd|| l_n_min_shelf_life||
                         i_dmprg_dt_lvr|| i_dmprg_n_day_post_lvr||
                         i_dmprg_v_formats|| NVL (i_dmprg_n_total_price,0)||
                         I_DMPRG_V_COMMENTS|| sysdate||
                         UPPER (I_DMPRG_V_ENTRY_OPER)||
                         sysdate|| UPPER (I_DMPRG_V_ENTRY_OPER)||
                         l_boc_number|| i_dmprg_v_bo_category  );
               raise_application_error
                                      (-20601,
                                          SUBSTR (SQLERRM, 1, 150)
                                       || ' - While storing deal memo programme');
         END;

         SELECT NVL (SUM (NVL (dmprg_n_total_price, 0)), 0)
           INTO l_dmprg_n_total_price
           FROM tbl_tva_dm_prog
          WHERE dmprg_n_dm_number = i_dmprg_n_dm_number;

         UPDATE    tbl_tva_deal_memo
               SET dm_n_memo_price = l_dmprg_n_total_price,
                   dm_v_modified_by = UPPER (i_dmprg_v_entry_oper),
                   dm_dt_modified_on = SYSDATE,
                   dm_n_update_count = NVL (dm_n_update_count, 0) + 1
             WHERE dm_n_deal_memo_number = i_dmprg_n_dm_number
         RETURNING dm_n_update_count
              INTO o_dm_update_count;

         FOR i IN (SELECT dmmgpay_n_number, dmmgpay_n_pay_percent
                     FROM tbl_tva_dm_mg_payment
                    WHERE dmmgpay_n_dm_number = i_dmprg_n_dm_number)
         LOOP
            UPDATE tbl_tva_dm_mg_payment
               SET dmmgpay_n_pay_amount =
                      ((l_dmprg_n_total_price * i.dmmgpay_n_pay_percent) / 100
                      )
             WHERE dmmgpay_n_number = i.dmmgpay_n_number;

            COMMIT;
         END LOOP;

         IF o_status > 0
         THEN
            COMMIT;
         ELSE
            RAISE insertfailed;
         END IF;
      EXCEPTION
         WHEN programmeinsertionfailed
         THEN
            ROLLBACK;
            raise_application_error (-20100,
                                        'Pragramme '
                                     || i_gen_title
                                     || ' insetion failed'
                                    );
         WHEN insertfailed
         THEN
            ROLLBACK;
            raise_application_error (-20100, 'Data Not Inserted');
      END;
   END prc_tva_insert_dm_programme;

--****************************************************************
-- This procedure Updates Deal Memo Programmes.
-- This procedure input are Deal Memo Programme parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_programme (
      i_dmprg_n_number           IN       tbl_tva_dm_prog.dmprg_n_number%TYPE,
      i_dmprg_c_premium          IN       tbl_tva_dm_prog.dmprg_c_premium%TYPE,
      i_dmprg_v_type             IN       tbl_tva_dm_prog.dmprg_v_type%TYPE,
      i_dmprg_n_gen_refno        IN       tbl_tva_dm_prog.dmprg_n_gen_refno%TYPE,
      i_dmprg_n_bo_rev_zar       IN       tbl_tva_dm_prog.dmprg_n_bo_rev_zar%TYPE,
      i_dmprg_n_bo_rev_usd       IN       tbl_tva_dm_prog.dmprg_n_bo_rev_usd%TYPE,
      i_dmprg_n_min_shelf_life   IN       tbl_tva_dm_prog.dmprg_n_min_shelf_life%TYPE,
      i_dmprg_dt_lvr             IN       tbl_tva_dm_prog.dmprg_dt_lvr%TYPE,
      i_dmprg_n_day_post_lvr     IN       tbl_tva_dm_prog.dmprg_n_day_post_lvr%TYPE,
      i_dmprg_v_formats          IN       tbl_tva_dm_prog.dmprg_v_formats%TYPE,
      i_dmprg_n_total_price      IN OUT   tbl_tva_dm_prog.dmprg_n_total_price%TYPE,
      i_dmprg_v_comments         IN       tbl_tva_dm_prog.dmprg_v_comments%TYPE,
      i_dmprg_v_modified_by      IN       tbl_tva_dm_prog.dmprg_v_modified_by%TYPE,
      i_dmprg_n_update_count     IN       tbl_tva_dm_prog.dmprg_n_update_count%TYPE,
      i_dmprg_v_prog_category    IN       VARCHAR2,
      i_dmprg_v_bo_category      IN       VARCHAR2,
      i_DMPRG_MIN_SHELF_life_ph	 IN       tbl_tva_dm_prog.DMPRG_MIN_SHELF_life_push%TYPE,       --Added by Jawahar
      i_DMPRG_MIN_SHELF_life_pl  IN       tbl_tva_dm_prog.DMPRG_MIN_SHELF_life_pull%TYPE,       --Added By Jawahar
      i_dmprg_bo_rev             IN       TBL_TVA_DM_PROG.dmprg_bo_rev%TYPE,                    --Added by Jawahar
      o_dm_update_count          OUT      NUMBER,
      o_status                   OUT      NUMBER,
      o_updateddata              OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
      l_boc_number            VARCHAR2 (30);
      l_con_v_formats         VARCHAR2 (30);
      l_con_number            NUMBER;
      l_dm_type               NUMBER;
      l_category              tbl_tva_dm_prog.dmprg_n_bo_category%TYPE;
      l_dmprg_n_total_price   tbl_tva_dm_prog.dmprg_n_total_price%TYPE;
      l_dm_n_total_price      tbl_tva_dm_prog.dmprg_n_total_price%TYPE;
      l_dmprg_n_dm_number     tbl_tva_dm_prog.dmprg_n_dm_number%TYPE;
      l_bo_sub_category       tbl_tva_dm_prog.dmprg_v_sub_category%TYPE;
      l_n_min_shelf_life      NUMBER;
      l_min_shelf_life_push      tbl_tva_contract.con_min_shelf_life_push%TYPE;
      l_min_shelf_life_pull      tbl_tva_contract.con_min_shelf_life_pull%TYPE;
      l_con_n_lff_min_gurantee   tbl_tva_contract.con_n_lff_min_gurantee%TYPE;
   BEGIN
      o_status := -1;
      o_dm_update_count := 0;

      begin
         IF i_dmprg_v_prog_category IS NOT NULL
         then
              select PC_PGM_CATEGORY_CODE
                 into L_BOC_NUMBER
                 from sgy_pb_pgm_category
                where UPPER (PC_PGM_CATEGORY_CODE) = TRIM(UPPER (I_DMPRG_V_PROG_CATEGORY));
         END IF;
      END;

      BEGIN
         SELECT dm_n_con_number, dm_n_type
           INTO l_con_number, l_dm_type
           FROM tbl_tva_deal_memo
          WHERE dm_n_deal_memo_number =
                                    (SELECT dmprg_n_dm_number
                                       FROM tbl_tva_dm_prog
                                      WHERE dmprg_n_number = i_dmprg_n_number);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 150));
      END;

      --Dev.R4 : TVOD : Start : [Devashish Raverkar]_[2016/01/28]
      --Validation : Minimum Shelf Life should not be less than define in Contract.
      IF l_con_number IS NOT NULL
      THEN
        SELECT con_min_shelf_life_push,
               con_min_shelf_life_pull,
               con_n_lff_min_gurantee
          INTO l_min_shelf_life_push,
               l_min_shelf_life_pull,
               l_con_n_lff_min_gurantee
          FROM tbl_tva_contract
         WHERE con_n_contract_number = l_con_number;

        IF l_min_shelf_life_push > i_dmprg_min_shelf_life_ph
          OR l_min_shelf_life_pull > i_dmprg_min_shelf_life_pl
        THEN
          raise_application_error(-20325,'Minimum Shelf Life should not be less than defined in the Contract.');
        END IF;
      END IF;
      --Dev.R4 : TVOD : End

      SELECT dmprg_n_bo_category, dmprg_v_sub_category, dmprg_n_total_price,
             dmprg_n_dm_number
        INTO l_category, l_bo_sub_category, l_dmprg_n_total_price,
             l_dmprg_n_dm_number
        FROM tbl_tva_dm_prog
       WHERE dmprg_n_number = i_dmprg_n_number;

      IF     l_dm_type = 1
         AND (l_category <> l_boc_number
              OR i_dmprg_v_bo_category <> l_bo_sub_category
             )
      THEN
         BEGIN
            SELECT bo_n_min_guarantee, bo_n_min_shelf_life
              INTO i_dmprg_n_total_price, l_n_min_shelf_life
              FROM tbl_tva_boxoffice
             WHERE bo_n_category = l_boc_number
               AND bo_v_sub_category = i_dmprg_v_bo_category
               AND bo_n_contract_number = l_con_number;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               i_dmprg_n_total_price := l_con_n_lff_min_gurantee;
               l_n_min_shelf_life := NULL;
            WHEN OTHERS
            THEN
               NULL;
         END;
      ELSE
         l_n_min_shelf_life := i_dmprg_n_min_shelf_life;
      end if;

      update FID_GENERAL
         set GEN_PROG_CATEGORY_CODE =  L_BOC_NUMBER
             --,GEN_BO_CATEGORY_CODE = I_DMPRG_V_BO_CATEGORY
             ,GEN_tvod_BO_CATEGORY_CODE = I_DMPRG_V_BO_CATEGORY --Added by Sushma for BR_15_290_ENH_TVOD BO Category
       where GEN_REFNO  = I_DMPRG_N_GEN_REFNO;

      UPDATE    tbl_tva_dm_prog
            SET dmprg_c_premium = i_dmprg_c_premium,
                dmprg_v_type = i_dmprg_v_type,
                dmprg_n_gen_refno = i_dmprg_n_gen_refno,
                dmprg_n_bo_rev_zar = i_dmprg_n_bo_rev_zar,
                dmprg_n_bo_rev_usd = i_dmprg_n_bo_rev_usd,
                dmprg_n_min_shelf_life = l_n_min_shelf_life,
                dmprg_dt_lvr = i_dmprg_dt_lvr,
                dmprg_n_day_post_lvr = i_dmprg_n_day_post_lvr,
                dmprg_v_formats = i_dmprg_v_formats,
                dmprg_n_total_price = i_dmprg_n_total_price,
                dmprg_v_comments = i_dmprg_v_comments,
                dmprg_v_modified_by = UPPER (i_dmprg_v_modified_by),
                dmprg_dt_modified_on = SYSDATE,
                dmprg_n_bo_category = l_boc_number,
                DMPRG_MIN_SHELF_life_push = i_DMPRG_MIN_SHELF_life_ph,   --Added by Jawahar
                DMPRG_MIN_SHELF_life_pull = i_DMPRG_MIN_SHELF_life_pl,   --Added By Jawahar
                dmprg_bo_rev            = i_dmprg_bo_rev,                 --Added By Jawahar
                dmprg_v_sub_category = i_dmprg_v_bo_category,
                dmprg_n_update_count = NVL (dmprg_n_update_count, 0) + 1
          WHERE NVL (dmprg_n_update_count, 0) = i_dmprg_n_update_count
            AND dmprg_n_number = i_dmprg_n_number
      RETURNING dmprg_n_update_count
           INTO o_status;

      IF NVL (l_dmprg_n_total_price, 0) <> NVL (i_dmprg_n_total_price, 0)
      THEN
         SELECT NVL (SUM (NVL (dmprg_n_total_price, 0)), 0)
           INTO l_dm_n_total_price
           FROM tbl_tva_dm_prog
          WHERE dmprg_n_dm_number = l_dmprg_n_dm_number;

         UPDATE    tbl_tva_deal_memo
               SET dm_n_memo_price = l_dm_n_total_price,
                   dm_v_modified_by = UPPER (i_dmprg_v_modified_by),
                   dm_dt_modified_on = SYSDATE,
                   dm_n_update_count = NVL (dm_n_update_count, 0) + 1
             WHERE dm_n_deal_memo_number = l_dmprg_n_dm_number
         RETURNING dm_n_update_count
              INTO o_dm_update_count;

         FOR i IN (SELECT dmmgpay_n_number, dmmgpay_n_pay_percent
                     FROM tbl_tva_dm_mg_payment
                    WHERE dmmgpay_n_dm_number = l_dmprg_n_dm_number)
         LOOP
            UPDATE tbl_tva_dm_mg_payment
               SET dmmgpay_n_pay_amount =
                       ((l_dm_n_total_price * i.dmmgpay_n_pay_percent) / 100
                       )
             WHERE dmmgpay_n_number = i.dmmgpay_n_number;

            COMMIT;
         END LOOP;
      END IF;

      IF o_status >= 0
      THEN
         COMMIT;
      END IF;            --by jawahar
      --ELSE
         OPEN o_updateddata FOR
            SELECT dmprogramme.dmprg_n_number, dmprogramme.dmprg_c_premium,
                   dmprogramme.dmprg_v_type, programme.gen_title,
                   dmprogramme.dmprg_n_gen_refno,
                   dmprogramme.dmprg_n_bo_rev_zar,
                   dmprogramme.dmprg_n_bo_rev_usd,
                   dmprogramme.dmprg_n_min_shelf_life,
                   dmprogramme.dmprg_dt_lvr,
                   dmprogramme.dmprg_n_day_post_lvr,
                   dmprogramme.dmprg_v_formats,
                   dmprogramme.dmprg_n_total_price,
                   dmprogramme.dmprg_v_comments,
                   NVL
                      (dmprogramme.dmprg_n_update_count,
                       0
                      ) dmprg_n_update_count,
                   DMPROGRAMME.DMPRG_N_BO_CATEGORY,
                   bocat.PC_PGM_CATEGORY_CODE dmprg_v_prog_category,
                   dmprg_v_sub_category,
                   DMPRG_MIN_SHELF_life_push,   --Added by Jawahar
                   DMPRG_MIN_SHELF_life_pull,  --Added By Jawahar
                   DMPRG_BO_REV
              FROM tbl_tva_dm_prog dmprogramme,
                   fid_general programme,
                SGY_PB_PGM_CATEGORY BOCAT
             WHERE dmprogramme.dmprg_n_gen_refno = programme.gen_refno
               AND dmprogramme.dmprg_n_number = i_dmprg_n_number
               AND dmprogramme.dmprg_n_bo_category = bocat.PC_PGM_CATEGORY_CODE;
      --END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_update_dm_programme;

--****************************************************************
-- This procedure Deletes Deal Memo Programmes.
-- This procedure input are Deal Memo Programme number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_programme (
      i_dmprg_n_number         IN       tbl_tva_dm_prog.dmprg_n_number%TYPE,
      i_dmprg_n_update_count   IN       tbl_tva_dm_prog.dmprg_n_update_count%TYPE,
      i_operator               IN       VARCHAR2,
      o_dm_update_count        OUT      NUMBER,
      o_status                 OUT      NUMBER,
      o_updateddata            OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
      l_dmprg_n_dm_number   tbl_tva_dm_prog.dmprg_n_dm_number%TYPE;
      l_dm_n_total_price    tbl_tva_dm_prog.dmprg_n_total_price%TYPE;
   BEGIN
      o_status := -1;
      o_dm_update_count := 0;

      SELECT dmprg_n_dm_number
        INTO l_dmprg_n_dm_number
        FROM tbl_tva_dm_prog
       WHERE dmprg_n_number = i_dmprg_n_number;

      DELETE      tbl_tva_dm_prog
            WHERE NVL (dmprg_n_update_count, 0) = i_dmprg_n_update_count
              AND dmprg_n_number = i_dmprg_n_number
        RETURNING dmprg_n_update_count
             INTO o_status;

      SELECT NVL (SUM (NVL (dmprg_n_total_price, 0)), 0)
        INTO l_dm_n_total_price
        FROM tbl_tva_dm_prog
       WHERE dmprg_n_dm_number = l_dmprg_n_dm_number;

      UPDATE    tbl_tva_deal_memo
            SET dm_n_memo_price = l_dm_n_total_price,
                dm_v_modified_by = UPPER (i_operator),
                dm_dt_modified_on = SYSDATE,
                dm_n_update_count = NVL (dm_n_update_count, 0) + 1
          WHERE dm_n_deal_memo_number = l_dmprg_n_dm_number
      RETURNING dm_n_update_count
           INTO o_dm_update_count;

      FOR i IN (SELECT dmmgpay_n_number, dmmgpay_n_pay_percent
                  FROM tbl_tva_dm_mg_payment
                 WHERE dmmgpay_n_dm_number = l_dmprg_n_dm_number)
      LOOP
         UPDATE tbl_tva_dm_mg_payment
            SET dmmgpay_n_pay_amount =
                       ((l_dm_n_total_price * i.dmmgpay_n_pay_percent) / 100
                       )
          WHERE dmmgpay_n_number = i.dmmgpay_n_number;

         COMMIT;
      END LOOP;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmprogramme.dmprg_n_number, dmprogramme.dmprg_c_premium,
                   dmprogramme.dmprg_v_type, programme.gen_title,
                   dmprogramme.dmprg_n_gen_refno,
                   dmprogramme.dmprg_n_bo_rev_zar,
                   dmprogramme.dmprg_n_bo_rev_usd,
                   dmprogramme.dmprg_n_min_shelf_life,
                   dmprogramme.dmprg_dt_lvr,
                   dmprogramme.dmprg_n_day_post_lvr,
                   dmprogramme.dmprg_v_formats,
                   dmprogramme.dmprg_n_total_price,
                   dmprogramme.dmprg_v_comments,
                   NVL
                      (dmprogramme.dmprg_n_update_count,
                       0
                      ) dmprg_n_update_count,
                   bocat.boc_v_category, dmprogramme.dmprg_n_bo_category,
                   dmprg_v_sub_category,
                   DMPRG_MIN_SHELF_life_push,   --Added by Jawahar
                   DMPRG_MIN_SHELF_life_pull  --Added By Jawahar
              FROM tbl_tva_dm_prog dmprogramme,
                   fid_general programme,
                   tvod_boxoffice_category bocat
             WHERE dmprogramme.dmprg_n_gen_refno = programme.gen_refno
               AND dmprogramme.dmprg_n_number = i_dmprg_n_number
               AND bocat.boc_n_number = dmprogramme.dmprg_n_bo_category;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_delete_dm_programme;

--****************************************************************
-- This procedure Inserts Deal Memo Programme Allocations.
-- This procedure input are Deal Memo Programme Allocation parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_allocation
   (
      i_dmad_n_dmprg_number   IN       tbl_tva_dm_allocation_detail.dmad_n_dmprg_number%TYPE,
      i_dmad_n_lee_number     IN       tbl_tva_dm_allocation_detail.dmad_n_lee_number%TYPE,
      i_dmad_c_tba            IN       tbl_tva_dm_allocation_detail.dmad_c_tba%TYPE,
      i_dmad_dt_start         IN       tbl_tva_dm_allocation_detail.dmad_dt_start%TYPE,
      i_dmad_dt_end           IN       tbl_tva_dm_allocation_detail.dmad_dt_end%TYPE,
      i_dmad_n_amount         IN       tbl_tva_dm_allocation_detail.dmad_n_amount%TYPE,
      i_dmad_v_entry_oper     IN       tbl_tva_dm_allocation_detail.dmad_v_entry_oper%TYPE,
      i_DMAD_DAYS_POST_LVR    IN       tbl_tva_dm_allocation_detail.DMAD_DAYS_POST_LVR%TYPE,          --added by jawahar
      o_status                OUT      tbl_tva_dm_allocation_detail.dmad_n_number%TYPE
   )
   AS
      l_dmad_n_number   NUMBER;
      insertfailed      EXCEPTION;
      l_start_date      DATE;
      l_end_date        DATE;
   BEGIN
      o_status := -1;
      l_dmad_n_number := get_seq ('SEQ_DMAD_N_NUMBER');

      IF pkg_tva_dealmemo.lic_enddate_validate (i_dmad_dt_end) = 1
      THEN
         raise_application_error
                 (-20601,
                  'License end date cannot be set in closed financial month.'
                 );
      ELSE
         BEGIN
            INSERT INTO tbl_tva_dm_allocation_detail
                        (dmad_n_number, dmad_n_dmprg_number,
                         dmad_n_lee_number, dmad_dt_start,
                         dmad_dt_end, dmad_c_tba, dmad_n_amount,
                         dmad_dt_entry_date, dmad_v_entry_oper,
                         dmad_n_update_count, dmad_dt_modified_on,
                         dmad_v_modified_by,
                         DMAD_DAYS_POST_LVR                     --Added by Jawahar
                        )
                 VALUES (l_dmad_n_number, i_dmad_n_dmprg_number,
                         I_DMAD_N_LEE_NUMBER,
                         DECODE(I_DMAD_C_TBA,'Y', TO_DATE ('31-12-2199',
                                                           'DD-MM-YYYY'
                                                          ),I_DMAD_DT_START),
                         DECODE(I_DMAD_C_TBA,'Y', TO_DATE ('31-12-2199',
                                                           'DD-MM-YYYY'
                                                          ),i_dmad_dt_end)
                        , i_dmad_c_tba, i_dmad_n_amount,
                         SYSDATE, UPPER (i_dmad_v_entry_oper),
                         0, SYSDATE,
                         UPPER (i_dmad_v_entry_oper),
                         i_DMAD_DAYS_POST_LVR                    --Added by Jawahar
                        )
              RETURNING dmad_n_number
                   INTO o_status;

            IF o_status > 0
            THEN
               COMMIT;
            ELSE
               RAISE insertfailed;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               ROLLBACK;
               o_status := -1;
               raise_application_error
                                     (-20100,
                                        SUBSTR (SQLERRM, 1, 200)
                                      - ' - While storing deal memo allocation'
                                     );
         END;
      END IF;
   EXCEPTION
      WHEN insertfailed
      THEN
         ROLLBACK;
         raise_application_error (-20100, 'Data Not Inserted');
   END prc_tva_insert_dm_allocation;

   --This procedure is used to validate start date
   FUNCTION lic_startdate_validate (
      i_dmad_dt_start   IN   tbl_tva_dm_allocation_detail.dmad_dt_start%TYPE
   )
      RETURN NUMBER
   AS
      l_lock_status    VARCHAR2 (5);
      e_closed_month   EXCEPTION;
      o_status         NUMBER;
      l_month          NUMBER;
      l_year           NUMBER;
   BEGIN
      l_month := TO_CHAR (i_dmad_dt_start, 'MM');
      l_year := TO_CHAR (i_dmad_dt_start, 'YYYY');
      o_status := 0;

	     select tfm_status
            INTO l_lock_status
          from x_tvf_financial_month
          where tfm_year = L_YEAR
          and tfm_month = L_MONTH;

      IF l_lock_status = 'C'
      THEN
         o_status := 1;
         RETURN o_status;
      ELSE
         o_status := 0;
         RETURN o_status;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         o_status := 0;
         RETURN o_status;
   END lic_startdate_validate;

   --This procedure is used to validate end date
   FUNCTION lic_enddate_validate (
      i_dmad_dt_end   IN   tbl_tva_dm_allocation_detail.dmad_dt_end%TYPE
   )
      RETURN NUMBER
   AS
      l_lock_status    VARCHAR2 (5);
      e_closed_month   EXCEPTION;
      o_status         NUMBER;
      l_month          NUMBER;
      l_year           NUMBER;
   BEGIN
      l_month := TO_CHAR (i_dmad_dt_end, 'MM');
      l_year := TO_CHAR (i_dmad_dt_end, 'YYYY');
      o_status := 0;

	     select tfm_status
            INTO l_lock_status
          from x_tvf_financial_month
          where tfm_year = L_YEAR
          and tfm_month = L_MONTH;

      IF l_lock_status = 'C'
      THEN
         o_status := 1;
         RETURN o_status;
      ELSE
         o_status := 0;
         RETURN o_status;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         o_status := 0;
         RETURN o_status;
   END lic_enddate_validate;

--****************************************************************
-- This procedure Updates Deal Memo Programme Allocations.
-- This procedure input are Deal Memo Programme Allocation parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_allocation (
      i_dmad_n_number         IN       tbl_tva_dm_allocation_detail.dmad_n_number%TYPE,
      i_dmad_n_lee_number     IN       tbl_tva_dm_allocation_detail.dmad_n_lee_number%TYPE,
      i_dmad_c_tba            IN       tbl_tva_dm_allocation_detail.dmad_c_tba%TYPE,
      i_dmad_dt_start         IN       tbl_tva_dm_allocation_detail.dmad_dt_start%TYPE,
      i_dmad_dt_end           IN       tbl_tva_dm_allocation_detail.dmad_dt_end%TYPE,
      i_dmad_n_amount         IN       tbl_tva_dm_allocation_detail.dmad_n_amount%TYPE,
      i_dmad_v_modified_by    IN       tbl_tva_dm_allocation_detail.dmad_v_modified_by%TYPE,
      i_dmad_n_update_count   IN       tbl_tva_dm_allocation_detail.dmad_n_update_count%TYPE,
      i_DMAD_DAYS_POST_LVR    IN       tbl_tva_dm_allocation_detail.DMAD_DAYS_POST_LVR%TYPE,
      o_status                OUT      NUMBER,
      o_updateddata           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      O_STATUS := -1;

      IF pkg_tva_dealmemo.lic_enddate_validate (i_dmad_dt_end) = 1
      THEN
         raise_application_error
                 (-20601,
                  'License end date cannot be set in closed financial month.'
                 );
      ELSE
         BEGIN
            UPDATE    tbl_tva_dm_allocation_detail
                  SET dmad_n_lee_number = i_dmad_n_lee_number,
                      dmad_dt_start = i_dmad_dt_start,
                      dmad_dt_end = i_dmad_dt_end,
                      dmad_n_amount = i_dmad_n_amount,
                      dmad_c_tba = i_dmad_c_tba,
                      dmad_v_modified_by = UPPER (i_dmad_v_modified_by),
                      dmad_dt_modified_on = SYSDATE,
                      dmad_n_update_count = NVL (dmad_n_update_count, 0) + 1,
                      DMAD_DAYS_POST_LVR   =i_DMAD_DAYS_POST_LVR     --Added by Jawahar
                WHERE NVL (dmad_n_update_count, 0) = i_dmad_n_update_count
                  AND dmad_n_number = i_dmad_n_number
            RETURNING dmad_n_update_count
                 INTO o_status;

            IF o_status >= 0
            THEN
               COMMIT;
            ELSE
               ROLLBACK;
            end if;

               OPEN o_updateddata FOR
                  SELECT dmprogallocation.dmad_n_number,
                         dmprogallocation.dmad_n_dmprg_number,
                         dmprogallocation.dmad_n_lee_number,
                         dmprogallocation.dmad_dt_start,
                         dmprogallocation.dmad_dt_end,
                         dmprogallocation.dmad_n_amount,
                         licensee.tvod_v_lee_short_name,
                         dmprogallocation.dmad_c_tba,
                         NVL
                            (dmprogallocation.dmad_n_update_count,
                             0
                            ) dmad_n_update_count,
                         dmprogallocation.DMAD_DAYS_POST_LVR                       --Added by Jawahar
                    FROM tbl_tva_dm_allocation_detail dmprogallocation,
                         tvod_licensee licensee
                   WHERE dmprogallocation.dmad_n_lee_number =
                                                    licensee.tvod_n_lee_number
                     AND dmprogallocation.dmad_n_number = i_dmad_n_number;
           -- END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
         END;
      END IF;
   END prc_tva_update_dm_allocation;

--****************************************************************
-- This procedure Deletes Deal Memo Programme Allocations.
-- This procedure input are Deal Memo Programme Allocation number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_allocation (
      i_dmad_n_number         IN       tbl_tva_dm_allocation_detail.dmad_n_number%TYPE,
      i_dmad_n_update_count   IN       tbl_tva_dm_allocation_detail.dmad_n_update_count%TYPE,
      i_operator              IN       VARCHAR2,
      o_status                OUT      NUMBER,
      o_updateddata           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      o_status := -1;

      DELETE X_TV_MEMO_MEDPLATDEVCOMPAT_MAP WHERE MEM_MPDC_ALD_ID = i_dmad_n_number; --Added by Jawahar

      DELETE      tbl_tva_dm_allocation_detail
            WHERE NVL (dmad_n_update_count, 0) = i_dmad_n_update_count
              AND dmad_n_number = i_dmad_n_number
        RETURNING dmad_n_update_count
             INTO o_status;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmprogallocation.dmad_n_number,
                   dmprogallocation.dmad_n_dmprg_number,
                   dmprogallocation.dmad_n_lee_number,
                   dmprogallocation.dmad_dt_start,
                   dmprogallocation.dmad_dt_end,
                   dmprogallocation.dmad_n_amount,
                   licensee.tvod_v_lee_short_name,
                   dmprogallocation.dmad_c_tba,
                   NVL
                      (dmprogallocation.dmad_n_update_count,
                       0
                      ) dmad_n_update_count,
                   dmprogallocation.DMAD_DAYS_POST_LVR                       --Added by Jawahar
              FROM tbl_tva_dm_allocation_detail dmprogallocation,
                   tvod_licensee licensee
             WHERE dmprogallocation.dmad_n_lee_number =
                                                    licensee.tvod_n_lee_number
               AND dmprogallocation.dmad_n_number = i_dmad_n_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_delete_dm_allocation;

--****************************************************************
-- This procedure Inserts Deal Memo Territories.
-- This procedure input are Deal Memo Territory parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_territory (
      i_dmm_n_dm_number    IN       tbl_tva_dm_territory.dmt_n_dm_number%TYPE,
      i_dmt_n_territory    IN       tbl_tva_dm_territory.dmt_n_territory%TYPE,
      i_dmt_v_rights       IN       tbl_tva_dm_territory.dmt_v_rights%TYPE,
      i_dmm_v_entry_oper   IN       tbl_tva_dm_territory.dmt_v_entry_oper%TYPE,
      i_dmt_is_link        IN       tbl_tva_dm_territory.dmt_v_is_linked%TYPE,
      o_status             OUT      tbl_tva_dm_territory.dmt_n_number%TYPE
   )
   AS
      l_dmt_n_number   NUMBER;
      insertfailed     EXCEPTION;
   BEGIN
      o_status := -1;
      l_dmt_n_number := get_seq ('SEQ_DMT_N_NUMBER');

      INSERT INTO tbl_tva_dm_territory
                  (dmt_n_number,
                   dmt_n_territory,
                   dmt_v_rights,
                   dmt_n_dm_number,
                   dmt_dt_entry_date,
                   dmt_v_entry_oper,
                   dmt_n_update_count,
                   dmt_v_is_linked,
                   dmt_dt_modified_on,
                   dmt_v_modified_by
                  )
           VALUES (l_dmt_n_number,
                   i_dmt_n_territory,
                   NVL(i_dmt_v_rights,'E'),
                   i_dmm_n_dm_number,
                   SYSDATE,
                   UPPER(i_dmm_v_entry_oper),
                   0,
                   UPPER(i_dmt_is_link),
                   SYSDATE,
                   UPPER(i_dmm_v_entry_oper)
                  )
        RETURNING dmt_n_number
             INTO o_status;

      IF o_status > 0
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
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := -1;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_insert_dm_territory;

--****************************************************************
-- This procedure Updates Deal Memo Territories.
-- This procedure input are Deal Memo Territory parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_territory (
      i_dmt_n_number         IN       tbl_tva_dm_territory.dmt_n_number%TYPE,
      i_dmt_n_territory      IN       tbl_tva_dm_territory.dmt_n_territory%TYPE,
      i_dmt_v_rights         IN       tbl_tva_dm_territory.dmt_v_rights%TYPE,
      i_dmt_v_modified_by    IN       tbl_tva_dm_territory.dmt_v_modified_by%TYPE,
      i_dmt_n_update_count   IN       tbl_tva_dm_territory.dmt_n_update_count%TYPE,
      i_dmt_is_link          IN       tbl_tva_dm_territory.dmt_v_is_linked%TYPE,
      o_status               OUT      NUMBER,
      o_updateddata          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      o_status := -1;

      UPDATE    tbl_tva_dm_territory
            SET dmt_n_territory = i_dmt_n_territory,
                dmt_v_rights = i_dmt_v_rights,
                dmt_v_modified_by = UPPER (dmt_v_modified_by),
                dmt_v_is_linked = UPPER (i_dmt_is_link),
                dmt_dt_modified_on = SYSDATE,
                dmt_n_update_count = NVL (dmt_n_update_count, 0) + 1
          WHERE NVL (dmt_n_update_count, 0) = i_dmt_n_update_count
            AND dmt_n_number = i_dmt_n_number
      RETURNING dmt_n_update_count
           INTO o_status;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmterritory.dmt_n_number, dmterritory.dmt_n_territory,
                   territories.v_ter_name, dmterritory.dmt_v_rights,
                   territories.v_ter_code, codes.cod_description,
                   NVL (dmterritory.dmt_n_update_count, 0)
                                                          dmt_n_update_count
              FROM tbl_tva_dm_territory dmterritory,
                   tbl_tva_territory territories,
                   fid_code codes
             WHERE dmterritory.dmt_n_territory = territories.n_ter_number
               AND dmterritory.dmt_n_number = i_dmt_n_number
               AND codes.cod_value != 'HEADER'
               AND codes.cod_type = 'LIC_RGH_CODE'
               AND dmterritory.dmt_v_rights = codes.cod_value;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_update_dm_territory;

--****************************************************************
-- This procedure Deletes Deal Memo Territories.
-- This procedure input are Deal Memo Territory number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_territory (
      i_dmt_n_number         IN       tbl_tva_dm_territory.dmt_n_number%TYPE,
      i_dmt_n_update_count   IN       tbl_tva_dm_territory.dmt_n_update_count%TYPE,
      i_operator             IN       VARCHAR2,
      o_status               OUT      NUMBER,
      o_updateddata          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      o_status := -1;

      DELETE      tbl_tva_dm_territory
            WHERE NVL (dmt_n_update_count, 0) = i_dmt_n_update_count
              AND dmt_n_number = i_dmt_n_number
        RETURNING NVL (dmt_n_update_count, 0)
             INTO o_status;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmterritory.dmt_n_number, dmterritory.dmt_n_territory,
                   territories.v_ter_name, dmterritory.dmt_v_rights,
                   territories.v_ter_code, codes.cod_description,
                   NVL (dmterritory.dmt_n_update_count, 0)
                                                          dmt_n_update_count
              FROM tbl_tva_dm_territory dmterritory,
                   tbl_tva_territory territories,
                   fid_code codes
             WHERE dmterritory.dmt_n_territory = territories.n_ter_number
               AND dmterritory.dmt_n_number = i_dmt_n_number
               AND codes.cod_value != 'HEADER'
               AND codes.cod_type = 'LIC_RGH_CODE'
               AND dmterritory.dmt_v_rights = codes.cod_value;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_delete_dm_territory;
 --****************************************************************
-- This procedure Inserts Deal Memo Minimum Guarantee Payment.
-- This procedure input are Deal Memo Minimum Guarantee Payment Parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_minguarantee (
      i_dmmgpay_n_dm_number         IN       tbl_tva_dm_mg_payment.dmmgpay_n_dm_number%TYPE,
      i_dmmgpay_n_order             IN       tbl_tva_dm_mg_payment.dmmgpay_n_order%TYPE,
      i_dmmgpay_n_pay_percent       IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_percent%TYPE,
      i_dmmgpay_n_pay_amount        IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_amount%TYPE,
      i_dmmgpay_v_pay_code          IN       tbl_tva_dm_mg_payment.dmmgpay_v_pay_code%TYPE,
      i_dmmgpay_v_currency          IN       tbl_tva_dm_mg_payment.dmmgpay_v_currency%TYPE,
      i_dmmgpay_n_no_of_days        IN       tbl_tva_dm_mg_payment.dmmgpay_n_no_of_days%TYPE,
      i_dmmgpay_n_pay_rule_number   IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_rule_number%TYPE,
      i_dmmgpay_v_comments          IN       tbl_tva_dm_mg_payment.dmmgpay_v_comments%TYPE,
      i_dmmgpay_v_entry_oper        IN       tbl_tva_dm_mg_payment.dmmgpay_v_entry_oper%TYPE,
      o_status                      OUT      tbl_tva_dm_mg_payment.dmmgpay_n_number%TYPE
   )
   AS
      l_dmmgpay_n_number   NUMBER;
      insertfailed         EXCEPTION;
   BEGIN
      o_status := -1;
      l_dmmgpay_n_number := get_seq ('SEQ_DMMGPAY_N_NUMBER');

      INSERT INTO tbl_tva_dm_mg_payment
                  (dmmgpay_n_number, dmmgpay_n_dm_number,
                   dmmgpay_n_order, dmmgpay_n_pay_percent,
                   dmmgpay_v_pay_code, dmmgpay_n_pay_amount,
                   dmmgpay_v_comments, dmmgpay_v_currency,
                   dmmgpay_n_no_of_days, dmmgpay_n_pay_rule_number,
                   dmmgpay_dt_entry_date, dmmgpay_v_entry_oper,
                   dmmgpay_n_update_count, dmmgpay_dt_modified_on,
                   dmmgpay_v_modified_by
                  )
           VALUES (l_dmmgpay_n_number, i_dmmgpay_n_dm_number,
                   i_dmmgpay_n_order, i_dmmgpay_n_pay_percent,
                   i_dmmgpay_v_pay_code, i_dmmgpay_n_pay_amount,
                   i_dmmgpay_v_comments, i_dmmgpay_v_currency,
                   i_dmmgpay_n_no_of_days, i_dmmgpay_n_pay_rule_number,
                   SYSDATE, UPPER (i_dmmgpay_v_entry_oper),
                   0, SYSDATE,
                   UPPER (i_dmmgpay_v_entry_oper)
                  )
        RETURNING dmmgpay_n_number
             INTO o_status;

      IF o_status > 0
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
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := -1;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_insert_dm_minguarantee;

--****************************************************************
-- This procedure Updates Deal Memo Minimum Guarantee Payment.
-- This procedure input are Deal Memo Minimum Guarantee Payment Parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_minguarantee (
      i_dmmgpay_n_number            IN       tbl_tva_dm_mg_payment.dmmgpay_n_number%TYPE,
      i_dmmgpay_n_order             IN       tbl_tva_dm_mg_payment.dmmgpay_n_order%TYPE,
      i_dmmgpay_n_pay_percent       IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_percent%TYPE,
      i_dmmgpay_n_pay_amount        IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_amount%TYPE,
      i_dmmgpay_v_pay_code          IN       tbl_tva_dm_mg_payment.dmmgpay_v_pay_code%TYPE,
      i_dmmgpay_v_currency          IN       tbl_tva_dm_mg_payment.dmmgpay_v_currency%TYPE,
      i_dmmgpay_n_no_of_days        IN       tbl_tva_dm_mg_payment.dmmgpay_n_no_of_days%TYPE,
      i_dmmgpay_n_pay_rule_number   IN       tbl_tva_dm_mg_payment.dmmgpay_n_pay_rule_number%TYPE,
      i_dmmgpay_v_comments          IN       tbl_tva_dm_mg_payment.dmmgpay_v_comments%TYPE,
      i_dmmgpay_v_modified_by       IN       tbl_tva_dm_mg_payment.dmmgpay_v_modified_by%TYPE,
      i_dmmgpay_n_update_count      IN       tbl_tva_dm_mg_payment.dmmgpay_n_update_count%TYPE,
      o_status                      OUT      NUMBER,
      o_updateddata                 OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      o_status := -1;

      UPDATE    tbl_tva_dm_mg_payment
            SET dmmgpay_n_order = i_dmmgpay_n_order,
                dmmgpay_n_pay_percent = i_dmmgpay_n_pay_percent,
                dmmgpay_n_pay_amount = i_dmmgpay_n_pay_amount,
                dmmgpay_v_pay_code = i_dmmgpay_v_pay_code,
                dmmgpay_v_currency = i_dmmgpay_v_currency,
                dmmgpay_n_no_of_days = i_dmmgpay_n_no_of_days,
                dmmgpay_n_pay_rule_number = i_dmmgpay_n_pay_rule_number,
                dmmgpay_v_comments = i_dmmgpay_v_comments,
                dmmgpay_v_modified_by = UPPER (i_dmmgpay_v_modified_by),
                dmmgpay_dt_modified_on = SYSDATE,
                dmmgpay_n_update_count = NVL (dmmgpay_n_update_count, 0) + 1
          WHERE NVL (dmmgpay_n_update_count, 0) = i_dmmgpay_n_update_count
            AND dmmgpay_n_number = i_dmmgpay_n_number
      RETURNING dmmgpay_n_update_count
           INTO o_status;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmmgpayment.dmmgpay_n_number, dmmgpayment.dmmgpay_n_order,
                   dmmgpayment.dmmgpay_n_pay_percent,
                   dmmgpayment.dmmgpay_v_pay_code,
                   dmmgpayment.dmmgpay_n_pay_amount,
                   dmmgpayment.dmmgpay_n_no_of_days,
                   dmmgpayment.dmmgpay_n_pay_rule_number,
                   dmmgpaytrule.dmmgpr_v_name, dmmgpaytrule.dmmgpr_v_formula,
                   dmmgpayment.dmmgpay_v_comments, dmmgpay_v_currency,
                   NVL
                      (dmmgpayment.dmmgpay_n_update_count,
                       0
                      ) dmmgpay_n_update_count
              FROM tbl_tva_dm_mg_payment dmmgpayment,
                   tbl_tva_dm_mg_payment_rule dmmgpaytrule
             WHERE dmmgpayment.dmmgpay_n_pay_rule_number = dmmgpaytrule.dmmgpr_n_number(+)
               AND dmmgpayment.dmmgpay_n_number = i_dmmgpay_n_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_update_dm_minguarantee;

--****************************************************************
-- This procedure Deletes Deal Memo Minimum Guarantee Payment.
-- This procedure input are Deal Memo Minimum Guarantee Payment Number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_minguarantee (
      i_dmmgpay_n_number         IN       tbl_tva_dm_mg_payment.dmmgpay_n_number%TYPE,
      i_dmmgpay_n_update_count   IN       tbl_tva_dm_mg_payment.dmmgpay_n_update_count%TYPE,
      i_operator                 IN       VARCHAR2,
      o_status                   OUT      NUMBER,
      o_updateddata              OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      o_status := -1;

      DELETE      tbl_tva_dm_mg_payment
            WHERE NVL (dmmgpay_n_update_count, 0) = i_dmmgpay_n_update_count
              AND dmmgpay_n_number = i_dmmgpay_n_number
        RETURNING NVL (dmmgpay_n_update_count, 0)
             INTO o_status;

      DBMS_OUTPUT.put_line ('o_status - ' || o_status);

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmmgpayment.dmmgpay_n_number, dmmgpayment.dmmgpay_n_order,
                   dmmgpayment.dmmgpay_n_pay_percent,
                   dmmgpayment.dmmgpay_v_pay_code,
                   dmmgpayment.dmmgpay_n_pay_amount,
                   dmmgpayment.dmmgpay_n_no_of_days,
                   dmmgpayment.dmmgpay_n_pay_rule_number,
                   dmmgpaytrule.dmmgpr_v_name, dmmgpaytrule.dmmgpr_v_formula,
                   dmmgpayment.dmmgpay_v_comments, dmmgpay_v_currency,
                   NVL
                      (dmmgpayment.dmmgpay_n_update_count,
                       0
                      ) dmmgpay_n_update_count
              FROM tbl_tva_dm_mg_payment dmmgpayment,
                   tbl_tva_dm_mg_payment_rule dmmgpaytrule
             WHERE dmmgpayment.dmmgpay_n_pay_rule_number = dmmgpaytrule.dmmgpr_n_number(+)
               AND dmmgpayment.dmmgpay_n_number = i_dmmgpay_n_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_delete_dm_minguarantee;

--****************************************************************
-- This procedure Inserts Deal Memo Overage Payment.
-- This procedure input are Deal Memo Overage Payment Parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_overage (
      i_dmpo_n_dm_number         IN       tbl_tva_dm_payment_overage.dmpo_n_dm_number%TYPE,
      i_dmpo_n_no_of_days        IN       tbl_tva_dm_payment_overage.dmpo_n_no_of_days%TYPE,
      i_dmpo_n_pay_rule_number   IN       tbl_tva_dm_payment_overage.dmpo_n_pay_rule_number%TYPE,
      i_dmpo_v_pay_code          IN       tbl_tva_dm_payment_overage.dmpo_v_pay_code%TYPE,
      i_dmmgpay_v_currency       IN       tbl_tva_dm_payment_overage.dmpo_v_currency%TYPE,
      i_dmpo_v_entry_oper        IN       tbl_tva_dm_payment_overage.dmpo_v_entry_oper%TYPE,
      o_status                   OUT      tbl_tva_dm_payment_overage.dmpo_n_number%TYPE
   )
   AS
      l_dmpo_n_number   NUMBER;
      insertfailed      EXCEPTION;
   BEGIN
      o_status := -1;
      l_dmpo_n_number := get_seq ('SEQ_DMPO_N_NUMBER');

      INSERT INTO tbl_tva_dm_payment_overage
                  (dmpo_n_number, dmpo_n_dm_number, dmpo_n_no_of_days,
                   dmpo_n_pay_rule_number, dmpo_v_pay_code,
                   dmpo_dt_entry_date, dmpo_v_entry_oper,
                   dmpo_n_update_count, dmpo_dt_modified_on,
                   dmpo_v_currency, dmpo_v_modified_by
                  )
           VALUES (l_dmpo_n_number, i_dmpo_n_dm_number, i_dmpo_n_no_of_days,
                   i_dmpo_n_pay_rule_number, i_dmpo_v_pay_code,
                   SYSDATE, UPPER (i_dmpo_v_entry_oper),
                   0, SYSDATE,
                   i_dmmgpay_v_currency, UPPER (i_dmpo_v_entry_oper)
                  )
        RETURNING dmpo_n_number
             INTO o_status;

      IF o_status > 0
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
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := -1;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_insert_dm_overage;

--****************************************************************
-- This procedure Updates Deal Memo Overage Payment.
-- This procedure input are Deal Memo Overage Payment Parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_overage (
      i_dmpo_n_number            IN       tbl_tva_dm_payment_overage.dmpo_n_number%TYPE,
      i_dmpo_n_no_of_days        IN       tbl_tva_dm_payment_overage.dmpo_n_no_of_days%TYPE,
      i_dmpo_n_pay_rule_number   IN       tbl_tva_dm_payment_overage.dmpo_n_pay_rule_number%TYPE,
      i_dmpo_v_pay_code          IN       tbl_tva_dm_payment_overage.dmpo_v_pay_code%TYPE,
      i_dmmgpay_v_currency       IN       tbl_tva_dm_payment_overage.dmpo_v_currency%TYPE,
      i_dmpo_v_modified_by       IN       tbl_tva_dm_payment_overage.dmpo_v_modified_by%TYPE,
      i_dmpo_n_update_count      IN       tbl_tva_dm_payment_overage.dmpo_n_update_count%TYPE,
      o_status                   OUT      NUMBER,
      o_updateddata              OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
      l_pay_rule_number   NUMBER;
   BEGIN
      o_status := -1;

      SELECT dmpo_n_pay_rule_number
        INTO l_pay_rule_number
        FROM tbl_tva_dm_payment_overage
       WHERE dmpo_n_number = i_dmpo_n_number;

      UPDATE    tbl_tva_dm_payment_overage
            SET dmpo_n_no_of_days = i_dmpo_n_no_of_days,
                dmpo_n_pay_rule_number =
                   DECODE (i_dmpo_n_pay_rule_number,
                           NULL, l_pay_rule_number,
                           i_dmpo_n_pay_rule_number
                          ),
                dmpo_v_modified_by = UPPER (i_dmpo_v_modified_by),
                dmpo_v_pay_code = i_dmpo_v_pay_code,
                dmpo_v_currency = i_dmmgpay_v_currency,
                dmpo_dt_modified_on = SYSDATE,
                dmpo_n_update_count = NVL (dmpo_n_update_count, 0) + 1
          WHERE NVL (dmpo_n_update_count, 0) = i_dmpo_n_update_count
            AND dmpo_n_number = i_dmpo_n_number
      RETURNING dmpo_n_update_count
           INTO o_status;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmoapayment.dmpo_n_number, dmoapayment.dmpo_n_no_of_days,
                   dmoapayment.dmpo_n_pay_rule_number,
                   dmoapayment.dmpo_v_pay_code, dmoapayrule.dmoapr_v_name,
                   dmpo_v_currency,
                   NVL (dmoapayment.dmpo_n_update_count,
                        0
                       ) dmpo_n_update_count
              FROM tbl_tva_dm_payment_overage dmoapayment,
                   tbl_tva_dm_oa_payment_rule dmoapayrule
             WHERE dmoapayment.dmpo_n_pay_rule_number =
                                                   dmoapayrule.dmoapr_n_number
               AND dmoapayment.dmpo_n_number = i_dmpo_n_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_update_dm_overage;

--****************************************************************
-- This procedure Deletes Deal Memo Overage Payment.
-- This procedure input are Deal Memo Overage Payment Number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_overage (
      i_dmpo_n_number         IN       tbl_tva_dm_payment_overage.dmpo_n_number%TYPE,
      i_dmpo_n_update_count   IN       tbl_tva_dm_payment_overage.dmpo_n_update_count%TYPE,
      i_operator              IN       VARCHAR2,
      o_status                OUT      NUMBER,
      o_updateddata           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      o_status := -1;

      DELETE      tbl_tva_dm_payment_overage
            WHERE NVL (dmpo_n_update_count, 0) = i_dmpo_n_update_count
              AND dmpo_n_number = i_dmpo_n_number
        RETURNING NVL (dmpo_n_update_count, 0)
             INTO o_status;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmoapayment.dmpo_n_number, dmoapayment.dmpo_n_no_of_days,
                   dmoapayment.dmpo_n_pay_rule_number,
                   dmoapayment.dmpo_v_pay_code, dmoapayrule.dmoapr_v_name,
                   dmpo_v_currency,
                   NVL (dmoapayment.dmpo_n_update_count,
                        0
                       ) dmpo_n_update_count
              FROM tbl_tva_dm_payment_overage dmoapayment,
                   tbl_tva_dm_oa_payment_rule dmoapayrule
             WHERE dmoapayment.dmpo_n_pay_rule_number = dmoapayrule.dmoapr_n_number(+)
               AND dmoapayment.dmpo_n_number = i_dmpo_n_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_delete_dm_overage;

--****************************************************************
-- This procedure Inserts Deal Memo Materials.
-- This procedure input are Deal Memo Materials Parameters.
--****************************************************************
   PROCEDURE prc_tva_insert_dm_material (
      i_dmm_n_dm_number    IN       tbl_tva_dm_material.dmm_n_dm_number%TYPE,
      i_dmm_n_com_number   IN       tbl_tva_dm_material.dmm_n_com_number%TYPE,
      i_dmm_v_class        IN       tbl_tva_dm_material.dmm_v_class%TYPE,
      i_dmm_v_broadcast    IN       tbl_tva_dm_material.dmm_v_broadcast%TYPE,
      i_dmm_v_sound        IN       tbl_tva_dm_material.dmm_v_sound%TYPE,
      i_dmm_v_item         IN       tbl_tva_dm_material.dmm_v_item%TYPE,
      i_dmm_v_comments     IN       tbl_tva_dm_material.dmm_v_comments%TYPE,
      i_dmm_v_entry_oper   IN       tbl_tva_dm_material.dmm_v_entry_oper%TYPE,
      o_status             OUT      tbl_tva_dm_material.dmm_n_number%TYPE
   )
   AS
      l_dmm_n_number   NUMBER;
      insertfailed     EXCEPTION;
   BEGIN
      o_status := -1;
      l_dmm_n_number := get_seq ('SEQ_DMM_N_NUMBER');

      INSERT INTO tbl_tva_dm_material
                  (dmm_n_number, dmm_n_dm_number, dmm_n_com_number,
                   dmm_v_class, dmm_v_broadcast, dmm_v_sound,
                   dmm_v_item, dmm_v_comments, dmm_dt_entry_date,
                   dmm_v_entry_oper, dmm_n_update_count, dmm_dt_modified_on,
                   dmm_v_modified_by
                  )
           VALUES (l_dmm_n_number, i_dmm_n_dm_number, i_dmm_n_com_number,
                   i_dmm_v_class, i_dmm_v_broadcast, i_dmm_v_sound,
                   i_dmm_v_item, i_dmm_v_comments, SYSDATE,
                   UPPER (i_dmm_v_entry_oper), 0, SYSDATE,
                   UPPER (i_dmm_v_entry_oper)
                  )
        RETURNING dmm_n_number
             INTO o_status;

      IF o_status > 0
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
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := -1;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_insert_dm_material;

--****************************************************************
-- This procedure Updates Deal Memo Materials.
-- This procedure input are Deal Memo Materials Parameters.
--****************************************************************
   PROCEDURE prc_tva_update_dm_material (
      i_dmm_n_number         IN       tbl_tva_dm_material.dmm_n_number%TYPE,
      i_dmm_n_com_number     IN       tbl_tva_dm_material.dmm_n_com_number%TYPE,
      i_dmm_v_class          IN       tbl_tva_dm_material.dmm_v_class%TYPE,
      i_dmm_v_broadcast      IN       tbl_tva_dm_material.dmm_v_broadcast%TYPE,
      i_dmm_v_sound          IN       tbl_tva_dm_material.dmm_v_sound%TYPE,
      i_dmm_v_item           IN       tbl_tva_dm_material.dmm_v_item%TYPE,
      i_dmm_v_comments       IN       tbl_tva_dm_material.dmm_v_comments%TYPE,
      i_dmm_v_modified_by    IN       tbl_tva_dm_material.dmm_v_modified_by%TYPE,
      i_dmm_n_update_count   IN       tbl_tva_dm_material.dmm_n_update_count%TYPE,
      o_status               OUT      NUMBER,
      o_updateddata          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      o_status := -1;

      UPDATE    tbl_tva_dm_material
            SET dmm_n_com_number = i_dmm_n_com_number,
                dmm_v_class = i_dmm_v_class,
                dmm_v_broadcast = i_dmm_v_broadcast,
                dmm_v_sound = i_dmm_v_sound,
                dmm_v_item = i_dmm_v_item,
                dmm_v_comments = i_dmm_v_comments,
                dmm_v_modified_by = UPPER (i_dmm_v_modified_by),
                dmm_dt_modified_on = SYSDATE,
                dmm_n_update_count = NVL (dmm_n_update_count, 0) + 1
          WHERE NVL (dmm_n_update_count, 0) = i_dmm_n_update_count
            AND dmm_n_number = i_dmm_n_number
      RETURNING dmm_n_update_count
           INTO o_status;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmmaterial.dmm_n_number, dmmaterial.dmm_n_com_number,
                   company.com_name, dmmaterial.dmm_v_class,
                   dmmaterial.dmm_v_broadcast, dmmaterial.dmm_v_sound,
                   dmmaterial.dmm_v_item, dmmaterial.dmm_v_comments,
                   NVL (dmmaterial.dmm_n_update_count, 0) dmm_n_update_count
              FROM tbl_tva_dm_material dmmaterial, fid_company company
             WHERE dmmaterial.dmm_n_com_number = company.com_number
               AND dmmaterial.dmm_n_number = i_dmm_n_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_update_dm_material;

--****************************************************************
-- This procedure Deletes Deal Memo Materials.
-- This procedure input are Deal Memo Materials Number and update count.
--****************************************************************
   PROCEDURE prc_tva_delete_dm_material (
      i_dmm_n_number         IN       tbl_tva_dm_material.dmm_n_number%TYPE,
      i_dmm_n_update_count   IN       tbl_tva_dm_material.dmm_n_update_count%TYPE,
      i_operator             IN       VARCHAR2,
      o_status               OUT      NUMBER,
      o_updateddata          OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      o_status := -1;

      DELETE      tbl_tva_dm_material
            WHERE NVL (dmm_n_update_count, 0) = i_dmm_n_update_count
              AND dmm_n_number = i_dmm_n_number
        RETURNING NVL (dmm_n_update_count, 0)
             INTO o_status;

      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT dmmaterial.dmm_n_number, dmmaterial.dmm_n_com_number,
                   company.com_name, dmmaterial.dmm_v_class,
                   dmmaterial.dmm_v_broadcast, dmmaterial.dmm_v_sound,
                   dmmaterial.dmm_v_item, dmmaterial.dmm_v_comments,
                   NVL (dmmaterial.dmm_n_update_count, 0) dmm_n_update_count
              FROM tbl_tva_dm_material dmmaterial, fid_company company
             WHERE dmmaterial.dmm_n_com_number = company.com_number
               AND dmmaterial.dmm_n_number = i_dmm_n_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_delete_dm_material;

--****************************************************************
-- This procedure returns programme title.
-- This procedure input are programme type and part of programme title.
--****************************************************************
   PROCEDURE prc_tva_gettitles (
      i_gentitle        IN       VARCHAR2,
      i_type            IN       VARCHAR2,
      o_programmedata   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
      l_genrefno   NUMBER        := 0;
      lcount       NUMBER        := -1;
      l_gentype    VARCHAR2 (20);
   BEGIN

      open O_PROGRAMMEDATA for
         select   GEN_REFNO, GEN_TYPE, GEN_TITLE,
                  GEN_RELEASE_YEAR,
                  GEN_PROG_CATEGORY_CODE,
                  GEN_BO_CATEGORY_CODE
             FROM fid_general
            WHERE UPPER (gen_title) LIKE UPPER (i_gentitle)
              AND UPPER (gen_type) LIKE UPPER (i_type)
         ORDER BY gen_title;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_gettitles;

--****************************************************************
-- This procedure Changes Deal Memo Status.
-- This procedure input are Deal Memo Materials Number and update count.
--****************************************************************
   PROCEDURE prc_change_dm_status (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      i_user_id                 IN       tbl_tva_deal_memo.dm_v_entry_oper%TYPE,
      i_status                  IN       VARCHAR2,
      o_dm_status               OUT      VARCHAR2,
      o_message                 OUT      VARCHAR2
   )
   AS
      l_message             VARCHAR2 (250);
      l_dm_current_status   VARCHAR2 (20);
      l_dm_n_type           VARCHAR2 (20);
      l_mem_buyer           VARCHAR2 (50);
      --l_mem_buyer_date     date;
      l_mem_approver        VARCHAR2 (50);
      l_signb               NUMBER;
      l_con_number          NUMBER;
      l_min_shelf_life_push tbl_tva_contract.con_min_shelf_life_push%TYPE;
      l_min_shelf_life_pull tbl_tva_contract.con_min_shelf_life_pull%TYPE;
   BEGIN
      IF i_dm_n_deal_memo_number IS NOT NULL
      THEN
         SELECT dm_v_status,                       -- Deal memo current status
                            dm_n_type,                       -- Deal memo type
                                      dm_n_con_number
           INTO l_dm_current_status, l_dm_n_type, l_con_number
           FROM tbl_tva_deal_memo
          WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

         dbms_output.put_line('current status' || l_dm_current_status ||
                              'dm type' || l_dm_n_type ||
                              'con number' || l_con_number);

         BEGIN
            IF i_status = 'RECOMMENDB'
            THEN
               BEGIN
                  IF l_dm_current_status IN ('REGISTERED','QAFAILED')
                  THEN
                     SELECT dmu_v_usr_id                      --Deal memo User
                       INTO l_mem_buyer
                       FROM tbl_tva_dm_user
                      WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id)
                        -- Logged in user
                        AND dmu_v_buyer = 'Y'
                        AND (dmu_n_lee_number,dmu_n_com_number) IN (
                               SELECT dm_n_lee_number,      -- Deal memo licensee
                                      dm_n_con_com_number
                                 FROM tbl_tva_deal_memo
                                WHERE dm_n_deal_memo_number =
                                                       i_dm_n_deal_memo_number);

                     pkg_tva_dealmemo.prc_tva_create_history
                                                     (i_status,
                                                      i_dm_n_deal_memo_number,
                                                      l_dm_n_type,
                                                      l_mem_buyer,
                                                      o_dm_status
                                                     );

                     -- Changing the deal memo status from 'REGIDTERED' to 'BUYER RECOMMENDED'
                     UPDATE tbl_tva_deal_memo
                        SET dm_v_status = 'BUYER RECOMMENDED',
                            dm_v_buyer = UPPER (l_mem_buyer),
                            dm_dt_buyer_date = SYSDATE
                      WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

                     COMMIT;
                     l_message := 'Memo RECOMMENDED. Commit complete.';
                     o_message := l_message;
                  ELSIF l_dm_current_status = 'EXECUTED'
                  THEN
                     l_message := 'ERROR: Deal is already executed.';
                     o_message := l_message;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_message :=
                           'You are not permitted to RECOMMEND the deal as buyer.';
                     --'ERROR: You are not permitted to sign deal memos.';
                     o_message := l_message;
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20601,
                                              SUBSTR (SQLERRM, 1, 250)
                                             );
               END;
            --Dev : TVOD Acquisition : Start : [Devashish Raverkar]_[2015/12/10]
            ELSIF i_status = 'QAPASS' OR i_status = 'QAFAIL'
            THEN
              BEGIN
                IF l_dm_current_status = 'BUYER RECOMMENDED'
                THEN
                  -- Checking if the deal is signed pd
                  SELECT dm_v_buyer
                    INTO l_mem_buyer
                    FROM tbl_tva_deal_memo
                   WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

                  IF l_mem_buyer IS NULL
                  THEN
                     l_message := 'ERROR: Buyer must RECOMMEND first';
                     o_message := l_message;
                  ELSE
                    -- Validating user - if the user can change deal memo status to 'QAPASSED' or 'QAFAILED'
                    SELECT dmu_v_usr_id                      --Deal memo User
                      INTO l_mem_buyer
                      FROM tbl_tva_dm_user
                     WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id)
                       -- Logged in user
                       AND dmu_v_qa = 'Y'
                       AND (dmu_n_lee_number,dmu_n_com_number) IN (
                              SELECT dm_n_lee_number,-- Deal memo licensee
                                     dm_n_con_com_number
                                FROM tbl_tva_deal_memo
                               WHERE dm_n_deal_memo_number =
                                                      i_dm_n_deal_memo_number);

                    pkg_tva_dealmemo.prc_tva_create_history
                                                       (i_status,
                                                        i_dm_n_deal_memo_number,
                                                        l_dm_n_type,
                                                        l_mem_buyer,
                                                        o_dm_status
                                                       );

                    -- Changing the deal memo status from 'BUYER RECOMMENDED' to 'QAPASSED' or 'QAFAILED'
                    UPDATE tbl_tva_deal_memo
                       SET dm_v_status = (CASE i_status WHEN 'QAPASS' THEN 'QAPASSED' WHEN 'QAFAIL' THEN 'QAFAILED' END),
                           dm_v_buyer = UPPER (l_mem_buyer),
                           dm_dt_buyer_date = SYSDATE
                     WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

                    COMMIT;

                    IF i_status = 'QAPASS'
                    THEN
                      l_message := 'Memo QA PASSED. Commit complete.';
                    ELSIF i_status = 'QAFAIL'
                    THEN
                      l_message := 'Memo rejected by the QA';
                    END IF;
                    o_message := l_message;
                  END IF;
                ELSIF l_dm_current_status = 'EXECUTED'
                THEN
                  l_message := 'ERROR: Deal is already executed.';
                  o_message := l_message;
                END IF;
              EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                  ROLLBACK;
                  IF i_status = 'QAPASS'
                  THEN
                    l_message := 'ERROR: You are not permitted to pass Sign QA on deal memo.';
                  ELSIF i_status = 'QAFAIL'
                  THEN
                    l_message := 'ERROR: You are not permitted to reject Sign QA on deal memo.';
                  END IF;
                  o_message := l_message;
                WHEN OTHERS
                THEN
                     raise_application_error (-20601,
                                              SUBSTR (SQLERRM, 1, 250)
                                             );
              END;
            --Dev : TVOD Acquisition : End
            ELSIF i_status = 'RECOMMENDPD'
            THEN
               BEGIN
                  --Validation for Buys Price Licenses (Anirudha)
                  IF l_dm_n_type = 1
                  THEN
                     prc_tva_vald_buy_pric_singpd (i_dm_n_deal_memo_number,
                                                   l_con_number,
                                                   0
                                                  );
                  END IF;

                  -- Checking if the deal is signed by buyer
                  SELECT dm_v_buyer
                    INTO l_mem_buyer
                    FROM tbl_tva_deal_memo
                   WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

                  IF l_mem_buyer IS NULL
                  THEN
                     l_message := 'ERROR: Buyer must RECOMMEND first.';
                     o_message := l_message;
                  ELSE
                     l_mem_approver := i_user_id;

                     -- Validating user - if the user can change deal memo status to 'PD RECOMMENDED'
                     SELECT dmu_v_usr_id                      --Deal memo User
                       INTO l_mem_approver
                       FROM tbl_tva_dm_user
                      WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id)
                        -- Logged in user
                        AND dmu_v_can_sign = 'Y'
                        AND (dmu_n_lee_number,dmu_n_com_number) IN (
                               SELECT dm_n_lee_number,    -- Deal memo licensee
                                      dm_n_con_com_number
                                 FROM tbl_tva_deal_memo
                                WHERE dm_n_deal_memo_number =
                                                       i_dm_n_deal_memo_number);

                     -- Validating if the deal memo status is 'BUYER RECOMMENDED' or 'QAPASSED'
                     SELECT COUNT (*)
                       INTO l_signb
                       FROM tbl_tva_deal_memo
                      WHERE dm_v_status IN ('BUYER RECOMMENDED','QAPASSED')
                        AND dm_n_deal_memo_number = i_dm_n_deal_memo_number;

                     -- Check if currenct status of deal memo is 'BUYER RECOMMENDED'
                     IF l_signb > 0
                     THEN
                        pkg_tva_dealmemo.prc_tva_create_history
                                                    (i_status,
                                                     --'SIGNB',
                                                     i_dm_n_deal_memo_number,
                                                     l_dm_n_type,
                                                     l_mem_approver,
                                                     o_dm_status
                                                    );

                        -- Changing the deal memo status from 'BUYER RECOMMENDED' to 'PD RECOMMENDED'
                        UPDATE tbl_tva_deal_memo
                           SET dm_v_status = 'PD RECOMMENDED',
                               dm_v_approver = UPPER (l_mem_approver),
                               dm_dt_approval_date = SYSDATE             --+ 1
                         WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

                        COMMIT;
                        l_message := 'Memo RECOMMENDED. Commit complete.';
                        o_message := l_message;
                     ELSE
                        l_message := 'Memo is not RECOMMENDED by the Buyer';
                        o_message := l_message;
                     END IF;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_message :=
                        'You are not permitted to RECOMMEND the deal as programme director.';
                     --'ERROR: You are not permitted to sign deal memos.';
                     o_message := l_message;
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20101,
                                              SUBSTR (sqlerrm, 1, 200)
                                             );
               END;
            ELSIF i_status = 'UNDO-RECOMMEND'
            THEN
               IF l_dm_current_status IN ('BUYER RECOMMENDED','QAPASSED')
               THEN
                  BEGIN
                     -- Validating user - if the user can unsign 'BUYER RECOMMENDED' deal memo
                     SELECT dmu_v_usr_id                      --Deal memo User
                       INTO l_mem_buyer
                       FROM tbl_tva_dm_user
                      WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id)
                        -- Logged in user
                        AND dmu_v_buyer = 'Y'
                        AND (dmu_n_lee_number,dmu_n_com_number) IN (
                               SELECT dm_n_lee_number,    -- Deal memo licensee
                                      dm_n_con_com_number
                                 FROM tbl_tva_deal_memo
                                WHERE dm_n_deal_memo_number =
                                                       i_dm_n_deal_memo_number);

                     -- Get the current status of deal memo
                     SELECT COUNT (*)
                       INTO l_signb
                       FROM tbl_tva_deal_memo
                      WHERE dm_v_status IN ('BUYER RECOMMENDED','QAPASSED')
                        AND dm_n_deal_memo_number = i_dm_n_deal_memo_number;

                     IF l_signb > 0
                     THEN
                        pkg_tva_dealmemo.prc_tva_create_history
                                                    (i_status,
                                                     --'SIGNPD',
                                                     i_dm_n_deal_memo_number,
                                                     l_dm_n_type,
                                                     i_user_id,
                                                     o_dm_status
                                                    );

                        -- Changing the deal memo status from 'BUYER RECOMMENDED' to 'REGISTERED'
                        UPDATE tbl_tva_deal_memo
                           SET dm_v_buyer = NULL,
                               dm_dt_buyer_date = NULL,
                               dm_v_status = o_dm_status       --'REGISTERED',
                         WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

                        COMMIT;
                        l_message := 'Memo UNDO RECOMMENDED by the Buyer';
                        o_message := l_message;
                     ELSE
                        l_message := 'Memo can not be UNDO RECOMMENDED by the Buyer';
                        o_message := l_message;
                     END IF;
                  -- END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'You are not permitted to UNDO RECOMMEND the deal as buyer.';
                        --'You are not permitted to unsign deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200)
                                                );
                  END;
               END IF;

               IF l_dm_current_status = 'PD RECOMMENDED'
               THEN
                  BEGIN
                     -- Validating user - if the user can unsign 'SIGNEPD' deal memo
                     SELECT dmu_v_usr_id                      --Deal memo User
                       INTO l_mem_approver
                       FROM tbl_tva_dm_user
                      WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id)
                        -- Logged in user
                        AND dmu_v_can_sign = 'Y'
                        AND (dmu_n_lee_number,dmu_n_com_number) IN (
                               SELECT dm_n_lee_number,    -- Deal memo licensee
                                      dm_n_con_com_number
                                 FROM tbl_tva_deal_memo
                                WHERE dm_n_deal_memo_number =
                                                       i_dm_n_deal_memo_number);

                     -- Get the current status of deal memo
                     SELECT COUNT (*)
                       INTO l_signb
                       FROM tbl_tva_deal_memo
                      WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number
                        AND dm_v_status = 'PD RECOMMENDED';

                     IF l_signb > 0
                     THEN
                        pkg_tva_dealmemo.prc_tva_create_history
                                                    (i_status,
                                                     --'UNSIGN',
                                                     i_dm_n_deal_memo_number,
                                                     l_dm_n_type,
                                                     i_user_id,
                                                     o_dm_status
                                                    );

                        -- Changing the deal memo status from 'PD RECOMMENDED' to 'BUYER RECOMMENDED'
                        UPDATE tbl_tva_deal_memo
                           SET dm_v_approver = NULL,
                               dm_dt_approval_date = NULL,
                               dm_v_status = o_dm_status          --'BUYER RECOMMENDED',
                         WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

                        COMMIT;
                        l_message := 'Memo UNDO RECOMMENDED by PD.';
                        o_message := l_message;
                     ELSE
                        l_message :=
                           'Memo can not be UNDO RECOMMENDED by the Program Director';
                        o_message := l_message;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_message :=
                           'You are not permitted to UNDO RECOMMEND the deal as programme director.';
                        --'You are not permitted to unsign deal memos.';
                        o_message := l_message;
                     WHEN OTHERS
                     THEN
                        raise_application_error (-20101,
                                                 SUBSTR (SQLERRM, 1, 200)
                                                );
                  END;
               END IF;
            ELSIF i_status = 'CHECK'
            THEN
              dbms_output.put_line('In check');
               IF l_dm_current_status != 'EXECUTED'
               THEN
                 dbms_output.put_line('IN l_dm_current_status != EXECUTED');
                --Dev.R4 : TVOD : Start : [Devashish Raverkar]_[2016/02/10]
                --Validation : Minimum Shelf Life should not be less than define in Contract.
                IF l_con_number IS NOT NULL
                THEN
                  SELECT con_min_shelf_life_push,
                         con_min_shelf_life_pull
                    INTO l_min_shelf_life_push,
                         l_min_shelf_life_pull
                    FROM tbl_tva_contract
                   WHERE con_n_contract_number = l_con_number;

                  FOR prog IN (SELECT dmprg_min_shelf_life_push,
                                   dmprg_min_shelf_life_pull
                              FROM tbl_tva_dm_prog
                             WHERE dmprg_n_dm_number = i_dm_n_deal_memo_number)
                  LOOP
                    IF l_min_shelf_life_push > prog.dmprg_min_shelf_life_push
                      OR l_min_shelf_life_pull > prog.dmprg_min_shelf_life_pull
                    THEN
                      raise_application_error(-20325,'Minimum Shelf Life should not be less than defined in the Contract.');
                    END IF;
                  END LOOP;
                END IF;
                --Dev.R4 : TVOD : End
                  --Validation for Buys Price Licenses (Anirudha)
                  IF l_dm_n_type = 1
                  THEN
                    dbms_output.put_line('IF l_dm_n_type = 1');

                     /*Added by Jawahar */
                     x_prc_val_lvr_date ( i_dm_n_deal_memo_number );
                     x_prc_val_buy_price_allocation ( i_dm_n_deal_memo_number );
                     /*End */

                     prc_tva_vald_buy_pric_singpd (i_dm_n_deal_memo_number,
                                                   l_con_number,
                                                   1
                                                  );
                     -- Validation for Bo Revenue Currency (Ajit)
                     prc_tva_vld_bo_curr (l_con_number,
                                          i_dm_n_deal_memo_number
                                         );
                  END IF;

                  -- Checking if the deal is signed by buyer
                  COMMIT;
                  o_dm_status := 'CHECKED';
                  l_message := 'Check for singing Deal Memo is complete.';
                  o_message := l_message;
                  dbms_output.put_line(l_message || ' '|| o_dm_status);
               ELSE
                  l_message := 'Deal is already executed.';
                  o_message := l_message;
               END IF;
            END IF;
         END;
      ELSE
         l_message := 'Select a deal memo first';
         o_message := l_message;
      END IF;
   END prc_change_dm_status;

--****************************************************************
-- This procedure Executes Deal Memo.
--****************************************************************
   PROCEDURE prc_execute_deal_memo (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      i_user_id                 IN       VARCHAR2,
      o_dm_status               OUT      tbl_tva_deal_memo.dm_v_status%TYPE,
      o_message                 OUT      VARCHAR2,
      o_con_n_contract_number   OUT      tbl_tva_contract.con_n_contract_number%TYPE,
      o_con_v_short_name        OUT      tbl_tva_contract.con_v_short_name%TYPE
   )
   AS
      theconnumber              NUMBER;
      secondconnumber           NUMBER;
      l_dm_status               VARCHAR2 (20);
      l_dm_lee_number           NUMBER;
      l_dm_n_type               NUMBER;
      l_dm_v_type               VARCHAR2 (50);
      l_dm_con_number           NUMBER;
      l_dm_n_con_com_number     NUMBER;
      l_dm_n_supp_com_number    NUMBER;
      l_dm_n_deal_memo_number   NUMBER;
      l_dm_type_id              NUMBER;
      l_flag                    NUMBER;
      l_dm_v_currency           VARCHAR2 (10);
      l_con_v_short_name        VARCHAR2 (30);
      l_message                 VARCHAR2 (250);
      o_dm_con_number           NUMBER;
      l_mem_con_price           tbl_tva_deal_memo.dm_n_memo_price%TYPE;
      l_dm_format               tbl_tva_dm_prog.dmprg_v_formats%TYPE;
      l_dm_format_count         NUMBER;
      l_superuser               VARCHAR2 (1);
      l_con_n_type              NUMBER;
      l_dm_n_con_number         NUMBER;
      l_con_n_contract_number   NUMBER;
      allocations_dont_addup    EXCEPTION;
      payments_dont_addup       EXCEPTION;
      contract_type_mismatch    EXCEPTION;
      PRAGMA EXCEPTION_INIT (allocations_dont_addup, -20115);
      PRAGMA EXCEPTION_INIT (payments_dont_addup, -20116);
   BEGIN
      BEGIN
         SELECT dealmemo.dm_v_status,                      -- Deal memo status
                                     dmtypes.deal_type,
                -- Deal memo type (String)
                dealmemo.dm_n_lee_number,                -- Deal memo licensee
                                         dealmemo.dm_n_con_number,
                -- Deal memo contract
                dealmemo.dm_n_memo_price,                   -- Deal memo price
                                         dealmemo.dm_n_type,
                -- DM type (Numeric)
                dealmemo.dm_n_con_com_number, dealmemo.dm_n_supp_com_number,
                dealmemo.dm_v_currency, dealmemo.dm_n_deal_memo_number,
                dealmemo.dm_n_type
           INTO l_dm_status, l_dm_v_type,
                l_dm_lee_number, l_dm_con_number,
                l_mem_con_price, l_dm_n_type,
                l_dm_n_con_com_number, l_dm_n_supp_com_number,
                l_dm_v_currency, l_dm_n_deal_memo_number,
                l_dm_type_id
           FROM tbl_tva_deal_memo dealmemo, tvod_deal_memo_type dmtypes
          WHERE dealmemo.dm_n_type = dmtypes.dm_type_id
            AND dealmemo.dm_n_deal_memo_number = i_dm_n_deal_memo_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20555, 'NO DATA FOUND1');
      END;

      --Checking for user rights
      BEGIN
         -- Validating user - if the user can execute deal memo
         SELECT dmu_v_superuser                               --Deal memo User
           INTO l_superuser
           FROM tbl_tva_dm_user
          WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id)     -- Logged in user
            AND dmu_v_superuser = 'Y'
            AND dmu_n_lee_number = l_dm_lee_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_message := 'You are not permitted to execute the deal.';
            raise_application_error (-20013, l_message);
      END;

      IF i_dm_n_deal_memo_number IS NULL
      THEN
         l_message := 'Please select a deal memo first';
         o_message := l_message;
      ELSE
         IF l_dm_v_type = 'VOD FIXED PRICE'
         THEN
            IF l_dm_con_number IS NULL
            THEN
               SELECT COUNT (DISTINCT dmprg_v_formats)
                 INTO l_dm_format_count
                 FROM tbl_tva_dm_prog
                WHERE dmprg_n_dm_number = i_dm_n_deal_memo_number;

               IF l_dm_format_count = 1
               THEN
                  SELECT DISTINCT dmprg_v_formats
                             INTO l_dm_format
                             FROM tbl_tva_dm_prog
                            WHERE dmprg_n_dm_number = i_dm_n_deal_memo_number;
               ELSE
                  l_dm_format := 'BOTH(HD and SD)';
               END IF;

               DBMS_OUTPUT.put_line ('inside con is null loop');
               l_con_n_contract_number :=
                  pkg_tva_dealmemo.create_new_con (i_dm_n_deal_memo_number,
                                                   l_dm_type_id,
                                                   l_mem_con_price,
                                                   l_dm_lee_number,
                                                   l_dm_n_con_com_number,
                                                   l_dm_n_supp_com_number,
                                                   l_dm_v_currency,
                                                   l_dm_format,
                                                   i_user_id
                                                  );
               DBMS_OUTPUT.put_line ('contract created');
            ELSE
               l_con_n_contract_number := l_dm_con_number;
            END IF;

            BEGIN
               UPDATE tbl_tva_deal_memo
                  SET dm_n_con_number = l_con_n_contract_number
                WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

               l_flag := SQL%ROWCOUNT;

               IF l_flag > 0
               THEN
                  COMMIT;
               ELSE
                  ROLLBACK;
               END IF;
            END;

            BEGIN
               SELECT con_v_short_name
                 INTO l_con_v_short_name
                 FROM tbl_tva_contract
                WHERE con_n_contract_number = l_con_n_contract_number;

               DBMS_OUTPUT.put_line ('In DM null - begin');
            EXCEPTION
               WHEN OTHERS
               THEN
                  raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
            END;
         ELSIF l_dm_v_type = 'VOD BUY PRICE'
         THEN
            IF l_dm_con_number IS NULL
            THEN
               raise_application_error (-20601,
                                        'Please link contract with deal.'
                                       );
            ELSE
               l_con_n_contract_number := l_dm_con_number;
            END IF;
         END IF;

         --Checking for deal memo type should be equal to contract type
         BEGIN
            IF l_dm_con_number IS NOT NULL
            THEN
               BEGIN
                  --Get contract type of dm contract
                  SELECT con_n_type
                    INTO l_con_n_type
                    FROM tbl_tva_contract
                   WHERE con_n_contract_number = l_dm_con_number;

                  IF l_con_n_type <> l_dm_n_type
                  THEN
                     RAISE contract_type_mismatch;
                  END IF;
               END;

               UPDATE tbl_tva_contract
                  SET con_n_price = l_mem_con_price,
                      con_v_modified_by = i_user_id
                WHERE con_n_contract_number = l_dm_con_number;
            END IF;

            theconnumber :=
               pkg_tva_dealmemo.execute_dmt (i_dm_n_deal_memo_number,
                                             i_user_id
                                            );
            secondconnumber := theconnumber;
            pkg_tva_dealmemo.prc_tva_create_history ('EXECUTE',
                                                     i_dm_n_deal_memo_number,
                                                     l_dm_n_type,
                                                     i_user_id,
                                                     o_dm_status
                                                    );

            -- Changing the deal memo status from 'PD RECOMMENDED' to 'EXECUTED'
            UPDATE tbl_tva_deal_memo
               SET dm_v_status = o_dm_status                      --'EXECUTED'
             WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;

            --For UID Generation
            INSERT INTO x_create_uid_for_deal (
                                                cud_mem_id,
                                                cud_uid_creating_status,
                                                cud_user_id,
                                                cud_is_tvod
                                              )
                                       VALUES (
                                                i_dm_n_deal_memo_number,
                                                'NEW',
                                                i_user_id,
                                                'T'
                                              );

            COMMIT;
            l_message := 'Deal memo executed';
            o_message := l_message;
            o_con_n_contract_number := l_con_n_contract_number;
            o_con_v_short_name := l_con_v_short_name;
         EXCEPTION
            WHEN contract_type_mismatch
            THEN
               l_message :=
                         'ERROR: The Contract type does not match deal type.';
               raise_application_error (-20013, l_message);
            WHEN allocations_dont_addup
            THEN
               l_message := 'ERROR: The Allocations on Page 1 do not add up.';
               raise_application_error (-20013, l_message);
            WHEN payments_dont_addup
            THEN
               l_message := 'ERROR: The payments do not add up.';
               raise_application_error (-20013, l_message);
            WHEN OTHERS
            THEN
               raise_application_error (-20601,
                                           SUBSTR (SQLERRM, 1, 200)
                                        || ' - While executing deal memo.'
                                       );
         END;
      END IF;

      SELECT con_v_short_name, con_n_contract_number
        INTO o_con_v_short_name, o_con_n_contract_number
        FROM tbl_tva_contract
       WHERE con_n_contract_number = l_con_n_contract_number;
   -- END;
   END prc_execute_deal_memo;

--****************************************************************
-- This procedure Inserts Deal Memo History.
-- This procedure input are Deal Memo History Parameters.
--****************************************************************
   PROCEDURE prc_tva_create_history (
      i_dmh_v_action       IN       tbl_tva_dm_history.dmh_v_action%TYPE,
      i_dmh_n_dm_number    IN       tbl_tva_dm_history.dmh_n_dm_number%TYPE,
      i_dm_n_type          IN       tbl_tva_deal_memo.dm_n_type%TYPE,
      i_dmh_v_entry_oper   IN       tbl_tva_dm_history.dmh_v_entry_oper%TYPE,
      o_dm_status          OUT      tbl_tva_deal_memo.dm_v_status%TYPE
   )
   AS
      CURSOR c_dm_history
      IS
         SELECT   dmh_v_from_status, dmh_v_to_status
             FROM tbl_tva_dm_history
            WHERE dmh_n_dm_number = i_dmh_n_dm_number
              AND dmh_v_action != 'UNDO-RECOMMEND'
         ORDER BY dmh_dt_entry_date DESC;

      history_not_found   EXCEPTION;
      l_hist_found        VARCHAR2 (1);
      l_message           VARCHAR2 (250);
      l_tsr_val           tvod_system_rules.tsr_value4%TYPE;
      l_dm_n_type         VARCHAR2 (5);
      l_dm_v_type         VARCHAR2 (50);
      l_dm_status         VARCHAR2 (100);
      l_dm_exist          NUMBER;
      l_dmh_n_number      NUMBER;
   BEGIN
      SELECT COUNT (dm_n_deal_memo_number)
        INTO l_dm_exist
        FROM tbl_tva_deal_memo
       WHERE dm_n_deal_memo_number = i_dmh_n_dm_number;

      --Checking if deal memo is newly created
      IF l_dm_exist > 0
      THEN
         SELECT dm_v_status, dm_n_type
           INTO l_dm_status, l_dm_n_type
           FROM tbl_tva_deal_memo
          WHERE dm_n_deal_memo_number = i_dmh_n_dm_number;
      ELSE
         l_dm_status := 'NEW';
         l_dm_n_type := i_dm_n_type;
      END IF;

      --Get deal memo type
      SELECT deal_type
        INTO l_dm_v_type
        FROM tvod_deal_memo_type
       WHERE dm_type_id = l_dm_n_type;

      --Getting status to be assigned to deal memo
      BEGIN
         SELECT tsr_value4
           INTO l_tsr_val
           FROM tvod_system_rules
          WHERE UPPER (tsr_type) = 'D'
            AND UPPER (tsr_code) = 'TVOD MEMO'
            AND UPPER (tsr_value1) = UPPER (l_dm_v_type)
            AND UPPER (tsr_value2) = UPPER (NVL (l_dm_status, 'NEW'))
            AND UPPER (tsr_value3) = UPPER (i_dmh_v_action);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_message := 'No data found in system rules.';
            RAISE history_not_found;
      END;

      IF l_tsr_val IS NULL
      THEN
         l_message :=
               'Action '
            || i_dmh_v_action
            || ' cannot be done when deal memo is in '
            || l_dm_status
            || ' status ';
         raise_application_error (-20228, l_message);
      END IF;

      IF l_tsr_val = 'HISTORY'
      THEN
         l_hist_found := 'N';

         FOR pre IN c_dm_history
         LOOP
            IF l_hist_found = 'Y'
            THEN
               EXIT;
            END IF;

            IF pre.dmh_v_to_status = l_dm_status
            THEN
               l_tsr_val := pre.dmh_v_from_status;
               l_hist_found := 'Y';
            END IF;
         END LOOP;

         IF l_hist_found = 'N'
         THEN
            l_message := 'Previous deal memo status could not be determined';
            RAISE history_not_found;
         END IF;
      END IF;

      --Creating deal memo history
      BEGIN
         l_dmh_n_number := get_seq ('SEQ_DMH_N_NUMBER');

         INSERT INTO tbl_tva_dm_history
                     (dmh_n_number, dmh_n_dm_number,
                      dmh_v_from_status, dmh_v_action, dmh_v_to_status,
                      dmh_dt_entry_date, dmh_v_entry_oper,
                      dmh_n_update_count, dmh_dt_modified_on,
                      dmh_v_modified_by
                     )
              VALUES (l_dmh_n_number, i_dmh_n_dm_number,
                      NVL (l_dm_status, 'NEW'), i_dmh_v_action, l_tsr_val,
                      SYSDATE, UPPER (i_dmh_v_entry_oper),
                      0, SYSDATE,
                      UPPER (i_dmh_v_entry_oper)
                     );

         o_dm_status := l_tsr_val;
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20601,
                                        SUBSTR (SQLERRM, 1, 200)
                                     || ' - While storing deal memo history.'
                                    );
      END;
   EXCEPTION
      WHEN history_not_found
      THEN
         raise_application_error (-20601, l_message);
      WHEN OTHERS
      THEN
         raise_application_error (-20601,
                                     SUBSTR (SQLERRM, 1, 200)
                                  || ' - While creating deal memo history.'
                                 );
   END prc_tva_create_history;

--****************************************************************
-- This procedure performs allocation and payment verification before Deal Memo execution.
--****************************************************************
   PROCEDURE prc_check_for_sign (
      i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_message                 OUT      VARCHAR2
   )
   AS
      l_message               VARCHAR2 (250);
      check_for_sign_failed   EXCEPTION;
   BEGIN
      o_message := '';

      --ALERT_SERIES;
      IF pkg_tva_dealmemo.check_allocation (i_dm_n_deal_memo_number) = -1
      THEN
         --DBMS_OUTPUT.put_line ('In prc_check_for_sign with check_alocation = -1');
         l_message := 'Allocations Do Not Add Up';
         o_message := l_message;
         RAISE check_for_sign_failed;
      END IF;

      IF pkg_tva_dealmemo.check_payment (i_dm_n_deal_memo_number) <> 0
      THEN
         l_message := 'Payments Do Not Add Up';
         o_message := l_message;
         RAISE check_for_sign_failed;
      END IF;

      o_message := 'Check for signing Deal Memo is complete.';
   EXCEPTION
      WHEN check_for_sign_failed
      THEN
         raise_application_error (-20601, l_message);
   END prc_check_for_sign;

   function EXECUTE_DMT
   (
      p_dm_n_deal_memo_number   IN   NUMBER,
      p_user_id                 IN   VARCHAR2
   )
      RETURN NUMBER
   IS
      CURSOR c_dealmemo (cp_dm_n_deal_memo_number NUMBER)
      IS
         SELECT dm_n_con_number, dm_n_lee_number, dm_n_con_com_number,
                dm_n_supp_com_number, dm_v_currency
           FROM tbl_tva_deal_memo
          WHERE dm_n_deal_memo_number = cp_dm_n_deal_memo_number;

      CURSOR c_dmprogrammes (cp_dm_number NUMBER)
      IS
         SELECT dmprg_n_gen_refno, dmprg_n_number, dmprg_n_total_price
           FROM tbl_tva_dm_prog, fid_code
          WHERE dmprg_n_dm_number = cp_dm_number
            AND cod_type = 'GEN_TYPE'
            AND cod_value = dmprg_v_type
            AND NVL (cod_attr1, ' ') != 'Y';

      CURSOR c_programme (cp_genrefno NUMBER)
      IS
         SELECT gen_title, gen_refno
           FROM fid_general
          WHERE gen_refno = cp_genrefno;

      programme          c_programme%ROWTYPE;
      theconnumber       NUMBER;
      p_con              NUMBER;
      conshort           VARCHAR2 (15);
      newconshortname1   VARCHAR2 (12);
      conshname          VARCHAR2 (12);
      origsernumber      NUMBER;
      systemident2       VARCHAR2 (2);
      maingenrefno       NUMBER;
      minlicstartdate    DATE;
      maxlicenddate      DATE;
      constartdate       DATE;
      conenddate         DATE;
   BEGIN
      -- for each deal memo (only one)...
      FOR dealmemo IN c_dealmemo (p_dm_n_deal_memo_number)
      LOOP
         theconnumber := dealmemo.dm_n_con_number;

         BEGIN
            SELECT con_v_short_name
              INTO conshort
              FROM tbl_tva_contract
             WHERE con_n_contract_number = theconnumber;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20601,
                                        'No Contract Short Name Found'
                                       );
         END;

         -- for each programme on the deal memo...
         FOR dmprogramme IN c_dmprogrammes (p_dm_n_deal_memo_number)
         LOOP
            OPEN c_programme (dmprogramme.dmprg_n_gen_refno);

            FETCH c_programme
             INTO programme;

            IF c_programme%FOUND
            THEN
               maingenrefno := programme.gen_refno;
            ELSE
               raise_application_error (-20117, 'Problem with First Title');
            END IF;

            CLOSE c_programme;

            create_lic
                  (pkg_tva_dealmemo.licensee_status (dealmemo.dm_n_lee_number),
                   dmprogramme.dmprg_n_number,
                   maingenrefno,
                   theconnumber,
                   dmprogramme.dmprg_n_total_price,
                   p_user_id
                  );
         END LOOP;

         --update the contract with lic start, end and accounting dates
         BEGIN
            BEGIN
               SELECT con_dt_start_date, con_dt_end_date
                 INTO constartdate, conenddate
                 FROM tbl_tva_contract
                WHERE con_n_contract_number = theconnumber;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;

            BEGIN
               SELECT MIN (lic_dt_start_date)
                 INTO minlicstartdate
                 FROM tbl_tva_license
                WHERE lic_n_con_number = theconnumber;

               SELECT MAX (lic_dt_end_date)
                 INTO maxlicenddate
                 FROM tbl_tva_license
                WHERE lic_n_con_number = theconnumber;

               IF (constartdate IS NULL) OR (minlicstartdate < constartdate)
               THEN
                  UPDATE tbl_tva_contract
                     SET con_dt_start_date = minlicstartdate,
                         con_v_modified_by = p_user_id,
                         con_dt_modified_on = SYSDATE
                   --con_acct_date = minlicstartdate
                  WHERE  con_n_contract_number = theconnumber;
               END IF;

               IF (conenddate IS NULL) OR (maxlicenddate > conenddate)
               THEN
                  UPDATE tbl_tva_contract
                     SET con_dt_end_date = maxlicenddate,
                         con_v_modified_by = p_user_id,
                         con_dt_modified_on = SYSDATE
                   WHERE con_n_contract_number = theconnumber;
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  raise_application_error (-20150,
                                           'Problem Updating Contract Dates'
                                          );
            END;
         END;
      END LOOP;

      RETURN 1;
   END execute_dmt;

--****************************************************************
-- This procedure Creates license.
--****************************************************************
   PROCEDURE create_lic (
      p_mode             IN   VARCHAR2,
      p_dmprg_n_number   IN   NUMBER,
      p_genrefno         IN   tbl_tva_license.lic_n_gen_refno%TYPE,
      p_connumber        IN   tbl_tva_license.lic_n_con_number%TYPE,
      p_liccost          IN   tbl_tva_license.lic_n_price%TYPE,
      p_user_id          IN   tbl_tva_license.lic_v_entry_oper%TYPE
   )
   IS
      CURSOR c_dmprogramme (cp_dmprg_n_number NUMBER)
      IS
         SELECT dmprg_n_dm_number,
                dmprg_n_number,
                dmprg_n_bo_rev_usd,
                dmprg_n_bo_rev_zar,
                dmprg_n_min_shelf_life,
                dmprg_v_formats,
                dmprg_dt_lvr,
                CASE WHEN dm_n_type = 1
                THEN
                (SELECT NVL(BO_LVR_APPLICABLE,'N') FROM tbl_tva_boxoffice WHERE bo_n_contract_number = p_connumber
                                 AND bo_v_sub_category =  dmprg_v_sub_category
                                 AND bo_n_category = dmprg_n_bo_category)
                ELSE
                'N'
                END
                as dmprg_bo_lvr_applicable,
                null as dmprg_n_day_post_lvr,               --TODO remove
                dmprg_v_type,
                dmprg_n_gen_refno,
                dmprg_n_total_price,
                dmprg_n_bo_category,
                dmprg_v_sub_category,
                dmprg_c_premium,                    --TODO check not in use
                DMPRG_MIN_SHELF_LIFE_PUSH,
                DMPRG_MIN_SHELF_LIFE_PULL,
                dm_n_lee_number,
                dm_n_deal_memo_number,
                dm_n_con_com_number,
                dm_v_amort_code,
                dm_n_supp_com_number,
                (SELECT deal_type
                  FROM tvod_deal_memo_type dmtypes
                WHERE dm_n_type = dmtypes.dm_type_id) deal_type,            --TODO
                dm_n_memo_price,
                dm_v_currency,
                dm_n_type
            FROM tbl_tva_dm_prog,
                tbl_tva_deal_memo,
                fid_code
          WHERE dmprg_n_number = p_dmprg_n_number
            AND cod_type = 'GEN_TYPE'
            AND cod_value = dmprg_v_type
            AND dmprg_n_dm_number = DM_N_DEAL_MEMO_NUMBER
            AND NVL (cod_attr1, ' ') != 'Y';

      CURSOR c_dmprogallocdetails (cp_dmprg_n_number NUMBER)
      IS
         SELECT DMAD_N_NUMBER,
                      dmad_n_dmprg_number,
                      DMAD_DAYS_POST_LVR,
                      dmad_n_lee_number,
                      dmad_n_amount,
                      dmad_dt_start,
                      dmad_dt_end,
                      NVL(dmad_c_tba,'N') AS dmad_c_tba
           FROM tbl_tva_dm_allocation_detail
          WHERE dmad_n_dmprg_number = cp_dmprg_n_number;


      licnumber                       NUMBER;
      newlicnumber                    VARCHAR2 (30);
      sublicensenumber                NUMBER;
      sublicenseeamount               NUMBER;
      contentstatus                   VARCHAR2 (2);
      targetcom                       NUMBER;
      sourcecom                       NUMBER;
      pricetouse                      NUMBER;
      latestfinish                    DATE;
      earlieststart                   DATE;
      theamortcode                    VARCHAR2 (12);
      licensee                        VARCHAR2 (4);
      lic_type                        VARCHAR2 (1);
      skip_license                    VARCHAR2 (1)                      := 'X';
      licstart                        DATE;
      licend                          DATE;
      endlic                          DATE;
      startlic                        DATE;
      leenum                          NUMBER;
      licgenref                       NUMBER;
      v_lic_status                    VARCHAR2 (1);
      lic_v_number                    VARCHAR2 (30);
      v_budget_code                   VARCHAR2 (4);
      l_lvr_n_dp_zar_hd               NUMBER;
      l_lvr_n_dp_zar_sd               NUMBER;
      l_lvr_n_dp_usd_hd               NUMBER;
      l_lvr_n_dp_usd_sd               NUMBER;
      l_lvr_n_exch_rate               NUMBER;
      l_lic_tba                       CHAR (1);
      l_bo_n_boxoffice_number         tbl_tva_boxoffice.bo_n_boxoffice_number%TYPE;
      l_lic_n_bo_category             tbl_tva_license.lic_n_bo_category%TYPE;
      l_lic_n_min_gurantee            NUMBER;
      l_lic_v_bo_revenue_currency     tbl_tva_license.lic_v_bo_revenue_currency%TYPE;
      l_lic_n_mg_exchange_rate        tbl_tva_license.lic_n_mg_exchange_rate%TYPE;
      l_bo_n_min_shelf_life           tbl_tva_boxoffice.bo_n_min_shelf_life%TYPE;
      l_dm_v_type                     VARCHAR2 (50);
      l_lic_n_price                   NUMBER;
      l_con_v_formats                 VARCHAR2 (20);
      l_bo_v_sub_category             VARCHAR2 (30);
      l_con_n_fee_formula_number      NUMBER;
      l_minshelflifeexists            NUMBER;
      l_n_lic_medt_mapp_number        NUMBER;
      l_lvr_n_revenue_share_percent   NUMBER;
      l_lff_rev_share_perc            tbl_tva_contract.con_n_lff_rev_share_perc%TYPE;
      l_lff_min_gurantee              tbl_tva_contract.con_n_lff_min_gurantee%TYPE;
      i_con_act_cur_cov_rule   tbl_tva_contract.con_act_cur_cov_rule%TYPE; --Added by Jawahar
      l_con_lvr_applicable            tbl_tva_contract.con_bo_lvr_applicable%TYPE;				--Added by Jawahar
      l_con_shelf_space_per           tbl_tva_contract.con_shelf_space_per%TYPE;				--Added by Jawahar
      l_CON_SUBS_VW_PERIOD     tbl_tva_contract.CON_SUBS_VW_PERIOD%TYPE; --Added by Jawahar
      l_CON_DP_PRICE_COV_RULE   tbl_tva_contract.CON_DP_PRICE_COV_RULE%TYPE; --Added by Jawahar
      l_CON_DP_EXCHANGE_RATE     tbl_tva_contract.CON_DP_EXCHANGE_RATE%TYPE; --Added by Jawahar
      l_con_day_and_date                    tbl_tva_contract.con_day_and_date%TYPE;--Added by Jawahar
	  l_lvr_con_cur_dp_rev_share_flg  tbl_tva_lvr.lvr_con_cur_dp_rev_share_flag%TYPE;
      l_CON_DP_REVIEW_DATE           tbl_tva_contract.CON_DP_REVIEW_DATE%TYPE;
      l_ap_review_date                tbl_tva_license.lic_dt_ap_review_date%TYPE;
      l_ap_usd_zar_rate               tbl_tva_license.lic_n_ap_usd_zar_rate%TYPE;
      l_ap_cov_rule                   tbl_tva_license.lic_n_ap_cov_rule%TYPE;
      l_ap_exch_rate_src              tbl_tva_license.lic_n_ap_exch_rate_src%TYPE;
      l_dp_review_date                tbl_tva_license.lic_dt_dp_review_date%TYPE;
      l_dp_usd_zar_rate               tbl_tva_license.lic_n_dp_usd_zar_rate%TYPE;
      l_dp_rev_share_flag             tbl_tva_license.lic_c_dp_rev_share_flag%TYPE;
      l_dp_cov_rule                   tbl_tva_license.lic_n_dp_cov_rule%TYPE;
      l_dmad_c_tba                    tbl_tva_dm_allocation_detail.dmad_c_tba%TYPE;
      insufficientcontractdata        EXCEPTION;
      undeterminedbocategory          EXCEPTION;
      currencynotmatching             EXCEPTION;
      l_tba_date                      DATE DEFAULT TO_DATE('31-12-2199','DD-MM-RRRR');        --Added by Jawahar
      v_gen_type               fid_general.gen_type%TYPE;
      v_gen_title                  fid_general.gen_title%TYPE;
      v_gen_refno                 fid_general.gen_refno%TYPE;

      v_lvr_rec                     tbl_tva_lvr%ROWTYPE;
      v_error_code              NUMBER := 0;
   BEGIN
              /*Added by Jawahar to get actual currency conversion rule */
              SELECT con_act_cur_cov_rule,
                            CON_SUBS_VW_PERIOD,
                            con_day_and_date,
                            con_shelf_space_per
                   INTO i_con_act_cur_cov_rule,
                             l_CON_SUBS_VW_PERIOD,
                             l_con_day_and_date,
                             l_con_shelf_space_per
                  FROM tbl_tva_contract
              WHERE con_n_contract_number = p_connumber;

      FOR dmprogramme IN c_dmprogramme (p_dmprg_n_number)
      LOOP
               l_dm_v_type := dmprogramme.deal_type;

              BEGIN
                 SELECT tvod_v_lee_short_name
                   INTO licensee
                   FROM tvod_licensee
                  WHERE tvod_n_lee_number = dmprogramme.dm_n_lee_number;
              EXCEPTION
                 WHEN OTHERS
                 THEN
                    licensee := 'XXX';
              END;

              SELECT gen_type,
                          gen_title,
                          gen_refno
              INTO    v_gen_type,
                          v_gen_title,
                          v_gen_refno
              FROM fid_general
              WHERE gen_refno = p_genrefno;

               BEGIN
                        SELECT cod_attr3
                            INTO v_budget_code
                          FROM fid_code
                        WHERE cod_type = 'GEN_TYPE'
                             AND cod_value = v_gen_type;
               EXCEPTION
                WHEN OTHERS THEN
                     NULL;
               END;

               IF v_budget_code IS NULL
               THEN
                  v_budget_code := v_gen_type;
               END IF;

               -- check adding up...
               -- Budgeting deal memo have no payments
               IF pkg_tva_dealmemo.check_allocation(dmprogramme.dmprg_n_dm_number) = -1
               THEN
                  raise_application_error (-20115,'Allocations do not add up');
               END IF;

               IF pkg_tva_dealmemo.check_payment(dmprogramme.dmprg_n_dm_number) <> 0
               THEN
                  raise_application_error (-20116, 'Payments do not add up');
               END IF;

               BEGIN
                  SELECT dm_n_type
                    INTO lic_type
                    FROM tbl_tva_deal_memo
                   WHERE dm_n_deal_memo_number = dmprogramme.dmprg_n_dm_number;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error(-20145,'No License Type Has Been Specified');
               END;

               BEGIN
                  SELECT MIN (dmad_dt_start), dmad_c_tba
                    INTO earlieststart, l_lic_tba
                    FROM tbl_tva_dm_allocation_detail
                   WHERE dmad_n_dmprg_number = dmprogramme.dmprg_n_number;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     earlieststart := SYSDATE;
               END;

               --TODO Remove it and add in above query
               BEGIN
                  SELECT MAX (dmad_dt_end)
                    INTO latestfinish
                    FROM tbl_tva_dm_allocation_detail
                   WHERE dmad_n_dmprg_number = dmprogramme.dmprg_n_number;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NULL;
               END;

               IF l_dm_v_type = 'VOD BUY PRICE'
               THEN
                  BEGIN
                             SELECT con_v_bo_currency,
                                    con_n_exchange_rate, con_v_formats,
                                    con_n_fee_formula_number, con_dt_ap_review_date,
                                    con_n_ap_usd_zar_rate, con_n_ap_cov_rule,
                                    con_n_lff_rev_share_perc,
                                    con_n_lff_min_gurantee, con_n_exch_rate_src,
                                    NVL(con_bo_lvr_applicable,'N'),      --Added by Jawahar
                                    con_shelf_space_per,										  --Added by Jawahar,
                                    CON_DP_PRICE_COV_RULE,
                                    CON_DP_REVIEW_DATE,
                                    CON_DP_EXCHANGE_RATE
                               INTO l_lic_v_bo_revenue_currency,
                                    l_lic_n_mg_exchange_rate, l_con_v_formats,
                                    l_con_n_fee_formula_number, l_ap_review_date,
                                    l_ap_usd_zar_rate, l_ap_cov_rule,
                                    l_lff_rev_share_perc,
                                    l_lff_min_gurantee, l_ap_exch_rate_src,
                                    l_con_lvr_applicable,                  --Added by Jawahar
                                    l_con_shelf_space_per,							 --Added by Jawahar
                                    l_CON_DP_PRICE_COV_RULE,
                                    l_CON_DP_REVIEW_DATE,
                                    l_CON_DP_EXCHANGE_RATE
                               FROM tbl_tva_contract
                              WHERE con_n_contract_number = p_connumber;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_lic_v_bo_revenue_currency := NULL;
                        l_lic_n_mg_exchange_rate := NULL;
                        l_lic_n_bo_category := NULL;
                        l_lic_n_min_gurantee := NULL;
                     WHEN OTHERS
                     THEN
                        raise_application_error(-20601,SUBSTR (SQLERRM, 1, 200)|| ' - While selecting box office currency');
                   END;

                  DBMS_OUTPUT.put_line('dmprogramme.dmprg_n_day_post_lvr - '|| dmprogramme.dmprg_n_day_post_lvr);
                  DBMS_OUTPUT.put_line('BO Currency - '|| l_lic_v_bo_revenue_currency);
                  DBMS_OUTPUT.put_line('Contract Format - '|| l_con_v_formats);

                  --Added by Jawahar
                  IF l_con_n_fee_formula_number IS NULL
                  THEN
                  raise_application_error(-20601,'Cannot execute deal as required data(License fee formula) for'||v_gen_title|| ' is not available on Contract.');
                  END IF;
                  --End


                 BEGIN
                    SELECT bo_n_boxoffice_number,
                           bo_n_category,
                           bo_n_min_guarantee,
                           bo_n_min_shelf_life,
                           bo_v_sub_category
                      INTO l_bo_n_boxoffice_number,
                           l_lic_n_bo_category,
                           l_lic_n_min_gurantee,
                           l_bo_n_min_shelf_life,
                           l_bo_v_sub_category
                      FROM tbl_tva_boxoffice
                     WHERE bo_n_contract_number = p_connumber
                       AND bo_v_sub_category =  dmprogramme.dmprg_v_sub_category
                       AND bo_n_category =  dmprogramme.dmprg_n_bo_category;
                 EXCEPTION
                    WHEN NO_DATA_FOUND
                    then
                      IF l_con_n_fee_formula_number IN (1,2)
                      THEN
                        raise_application_error(-20601,'Cannot execute deal as required data (BO Category,BO Minimum Guarantee and BO Minimum Shelf Life) for the Programme '|| v_gen_title|| ' is not available on Contract.' );
                        l_lic_n_bo_category := NULL;
                        L_LIC_N_MIN_GURANTEE := null;
                      END IF;
                    WHEN OTHERS
                    THEN
                       raise_application_error(-20601,' - While selecting box office category.');
                      END;

                    BEGIN
                              SELECT  dmprg_n_bo_category,
                                           dmprg_v_sub_category
                                 INTO  l_lic_n_bo_category,
                                           l_bo_v_sub_category
                               FROM tbl_tva_dm_prog
                              WHERE dmprg_n_number = p_dmprg_n_number;
                       EXCEPTION
                       WHEN NO_DATA_FOUND
                       THEN
                           l_lic_n_bo_category := NULL;
                           l_bo_v_sub_category := NULL;
                    END;

                IF   ( l_con_n_fee_formula_number = 1 OR l_con_n_fee_formula_number = 2)
                THEN
                   IF dmprogramme.dmprg_dt_lvr IS NOT NULL
                    THEN
                              FOR dm_allocation IN ( SELECT dmad_days_post_lvr,
                                                                                   ( SELECT  TVOD_V_LEE_SHORT_NAME FROM tvod_licensee where TVOD_N_LEE_NUMBER=  DMAD_N_LEE_NUMBER ) as lee_name
                                                                       FROM tbl_tva_dm_allocation_detail
                                                                     WHERE dmad_n_dmprg_number = dmprogramme.dmprg_n_number
                                                                           AND NVL(dmad_c_tba,'N') = 'N'
                                                                  )
                             LOOP
                                    BEGIN
                                              SELECT  lvr_n_revenue_share_percent,
                                                             lvr_n_dp_zar_hd,
                                                             lvr_n_dp_usd_hd,
                                                             lvr_n_dp_zar_sd,
                                                             lvr_n_dp_usd_sd,
                                                             lvr_n_exch_rate,
                                                             lvr_dt_dp_review_date,
                                                             lvr_n_dp_usd_zar,
                                                             lvr_c_dp_rev_share_flag,
                                                            lvr_con_cur_dp_rev_share_flag
                                                  INTO l_lvr_n_revenue_share_percent,
                                                            l_lvr_n_dp_zar_hd,
                                                            l_lvr_n_dp_usd_hd,
                                                            l_lvr_n_dp_zar_sd,
                                                            l_lvr_n_dp_usd_sd,
                                                            l_lvr_n_exch_rate,
                                                            l_dp_review_date,
                                                            l_dp_usd_zar_rate,
                                                            l_dp_rev_share_flag,
                                                            l_lvr_con_cur_dp_rev_share_flg
                                                FROM tbl_tva_lvr
                                              WHERE nvl(dm_allocation.dmad_days_post_lvr,0)
                                         BETWEEN lvr_n_lvr_from AND nvl(lvr_n_lvr_to,9999999999)
                                                   AND lvr_n_contract_number = p_connumber
                                                   AND lvr_n_bo_number = l_bo_n_boxoffice_number;
                                EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                              raise_application_error (-20601,'Cannot execute deal as required data(LVR share percent) is not available on Contract. DPLVR - ' || dm_allocation.dmad_days_post_lvr|| 'Con no - '|| p_connumber || ' BONo. - '|| l_bo_n_boxoffice_number );
                               END;
                          END LOOP;
                    END IF;     /*End if of  IF dmprogramme.dmprg_dt_lvr IS NOT NULL*/
                  END IF;       /* End if of   IF   ( l_con_n_fee_formula_number = 1 OR l_con_n_fee_formula_number = 2) */

               END IF;    /* End if of IF l_dm_v_type = 'VOD BUY PRICE' */

               IF p_mode = 'BC'
               THEN
                  IF l_dm_v_type = 'VOD FIXED PRICE'
                  THEN
                     l_lic_n_price := p_liccost;
                  ELSIF l_dm_v_type = 'VOD BUY PRICE'
                  THEN
                     IF   ( l_con_n_fee_formula_number = 4
                        OR l_con_n_fee_formula_number = 3)
                     THEN
                      l_lvr_n_revenue_share_percent := l_lff_rev_share_perc;

                                                  l_lic_n_price := CASE
                                                                           WHEN l_con_n_fee_formula_number = 3
                                                                           THEN p_liccost
                                                                           ELSE 0
                                                                           END;
                                   ELSE
                                      l_lic_n_price := p_liccost;
                                   END IF;
                        END IF;

                  licnumber := get_seq ('SEQ_LIC_N_NUMBER');
                  newlicnumber := licnumber || '-T';
                  v_lic_status := 'A';

                  INSERT INTO tbl_tva_license
                              (lic_v_number, lic_n_gen_refno,
                               lic_n_con_number, lic_n_lee_number,
                               lic_n_dm_type, lic_v_status,
                               lic_dt_start_date, lic_dt_end_date,
                               lic_v_currency,
                               lic_n_price, lic_v_comments,
                               lic_dt_account_date,
                               lic_dt_entry_date, lic_v_entry_oper,
                               lic_n_update_count, lic_n_dm_number,
                               lic_v_budget_type, lic_v_amort_code,
                               --lic_n_min_shelf_life,
                               lic_v_formats,
                               lic_dt_lvr,
                               lic_n_bo_rev_zar,
                               lic_n_bo_rev_usd,
                               lic_n_day_post_lvr,
                               lic_v_bo_revenue_currency,
                               lic_n_mg_exchange_rate, lic_n_bo_category,
                               lic_n_revenue_share_percent,
                               lic_dt_modified_on, lic_v_modified_by,
                               lic_v_bo_sub_category, lic_n_dp_zar_hd,
                               lic_n_dp_zar_sd, lic_n_dp_usd_hd,
                               lic_n_dp_usd_sd, lic_n_lvr_exch_rate,
                               lic_n_fee_formula_number,
                               lic_c_tba, lic_dt_ap_review_date,
                               lic_n_ap_usd_zar_rate, lic_n_ap_cov_rule,
                               lic_n_ap_exch_rate_src,
                               lic_dt_dp_review_date,
                               lic_n_dp_usd_zar_rate,
                               lic_c_dp_rev_share_flag,
                               lic_n_dp_cov_rule,
                               --lic_c_premium,
                               /*Added by Jawahar */
                               Lic_min_shelf_life_push,
                               Lic_min_shelf_life_pull,
                               Lic_subs_vw_period,
                               Lic_shelf_space_per,
                               Lic_lvr_applicable,
                               LIC_ACT_CUR_COV_RULE,
                               lic_min_guarantee,
                               LIC_con_cur_DP_REV_SHARE_FLAG,
                               lic_day_and_date
                               /*End */
                              )
                       VALUES (newlicnumber, p_genrefno,
                               p_connumber, dmprogramme.dm_n_lee_number,
                               dmprogramme.dm_n_type, v_lic_status,
                               earlieststart, latestfinish,
                               dmprogramme.dm_v_currency,
                               TRUNC (l_lic_n_price, 4), NULL,
                               DECODE (licensee, 'SPO', earlieststart, NULL),
                               SYSDATE, UPPER (p_user_id),
                               0, dmprogramme.dm_n_deal_memo_number,
                               v_budget_code, theamortcode,
                               --DECODE (l_dm_v_type, 'VOD BUY PRICE', l_bo_n_min_shelf_life,dmprogramme.dmprg_n_min_shelf_life),
                               dmprogramme.dmprg_v_formats,
                               dmprogramme.dmprg_dt_lvr,
                               dmprogramme.dmprg_n_bo_rev_zar,
                               dmprogramme.dmprg_n_bo_rev_usd,
                               dmprogramme.dmprg_n_day_post_lvr,  --TODO Jawahar Check
                               l_lic_v_bo_revenue_currency,
                               l_lic_n_mg_exchange_rate, l_lic_n_bo_category,
                               l_lvr_n_revenue_share_percent,
                               SYSDATE, UPPER (p_user_id),
                               l_bo_v_sub_category, l_lvr_n_dp_zar_hd,
                               l_lvr_n_dp_zar_sd, l_lvr_n_dp_usd_hd,
                               l_lvr_n_dp_usd_sd, l_lvr_n_exch_rate,
                               l_con_n_fee_formula_number,
                               NVL (l_lic_tba, 'N'), l_ap_review_date,
                               l_ap_usd_zar_rate, l_ap_cov_rule,
                               l_ap_exch_rate_src,
                               l_CON_DP_REVIEW_DATE,
                               l_CON_DP_EXCHANGE_RATE,
                               l_dp_rev_share_flag,
                               l_CON_DP_PRICE_COV_RULE,
                               --dmprogramme.dmprg_c_premium,
                               /*Added by Jawahar */
                                dmprogramme.DMPRG_MIN_SHELF_LIFE_PUSH,
                                dmprogramme.DMPRG_MIN_SHELF_LIFE_PULL,
                                l_CON_SUBS_VW_PERIOD,
                                l_con_shelf_space_per,
                                dmprogramme.dmprg_bo_lvr_applicable,
                                i_con_act_cur_cov_rule,
                                dmprogramme.dmprg_n_total_price,
                                l_lvr_con_cur_dp_rev_share_flg,
                                l_con_day_and_date
                                /*End */
                              );


               END IF;       /*End if of  : IF p_mode = 'BC' */

               -- perform allocations
               FOR dmprogallocdetail IN c_dmprogallocdetails (dmprogramme.dmprg_n_number)
               LOOP

                  BEGIN
                     SELECT  lic_dt_start_date,
                                    lic_dt_end_date,
                                    lic_n_lee_number,
                                    lic_n_gen_refno,
                                    lic_v_number
                           INTO licstart, licend,
                                    leenum,
                                    licgenref,
                                    lic_v_number
                       FROM  tbl_tva_license
                     WHERE  lic_n_lee_number = dmprogallocdetail.dmad_n_lee_number
                          AND  lic_n_gen_refno = v_gen_refno
                          AND  lic_n_dm_number = dmprogramme.dm_n_deal_memo_number;

                     skip_license := 'Y';
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        skip_license := 'N';
                     WHEN OTHERS
                     THEN
                        skip_license := 'Y';
                  END;


                  IF skip_license = 'N'
                  THEN
                     -- amortisation code
                     theamortcode := dmprogramme.dm_v_amort_code;

                    IF dmprogramme.dmprg_n_total_price != 0
                    THEN
                              sublicenseeamount :=p_liccost * (  dmprogallocdetail.dmad_n_amount/ dmprogramme.dmprg_n_total_price);
                    ELSE
                              sublicenseeamount := 0;
                    END IF;

                     pricetouse := sublicenseeamount;

                     IF p_mode = 'BC'
                     THEN
                        pkg_tva_dealmemo.license_ledger_init
                                             (sublicensenumber,
                                              dmprogramme.dm_n_deal_memo_number,
                                              pricetouse,
                                              p_user_id
                                             );
                     ELSIF p_mode = 'CC'
                     THEN
                              IF l_dm_v_type = 'VOD FIXED PRICE'
                              THEN
                                 l_lic_n_price := pricetouse;

                              ELSIF l_dm_v_type = 'VOD BUY PRICE'
                              THEN
                                         IF   ( l_con_n_fee_formula_number = 4
                                            OR l_con_n_fee_formula_number = 3)
                                         THEN
                                          l_lvr_n_revenue_share_percent := l_lff_rev_share_perc;

                                                        l_lic_n_price := CASE
                                                                                 WHEN l_con_n_fee_formula_number = 3
                                                                                 THEN pricetouse
                                                                                 ELSE 0
                                                                                 END;
                                         ELSE
                                            l_lic_n_price := pricetouse;
                                         END IF;

                              END IF;

                        IF l_dm_v_type = 'VOD BUY PRICE' AND dmprogallocdetail.dmad_c_tba = 'N'
                        THEN
                                  v_error_code  := x_pkg_lic_comm_proc.x_fnc_val_dp_rule
                                                                                      (
                                                                                      i_BO_N_BOXOFFICE_NUMBER          => l_bo_n_boxoffice_number,
                                                                                      i_lvr_applicable                                  => dmprogramme.dmprg_bo_lvr_applicable,
                                                                                      i_lic_n_fee_formula_number             => l_con_n_fee_formula_number,
                                                                                      i_lic_start_date                                  => dmprogallocdetail.dmad_dt_start,
                                                                                      i_lvr_date                                           => dmprogramme.dmprg_dt_lvr,
                                                                                      o_lvr_rec                                            => v_lvr_rec
                                                                                      );

                                    IF v_error_code  = -1 AND l_con_n_fee_formula_number IN (1,2)
                                    THEN
                                                raise_application_error (-20601,'Cannot execute deal as required data(LVR share percent) is not available on Contract. DPLVR - ' || dmprogallocdetail.dmad_days_post_lvr|| 'Con no - '|| p_connumber || ' BONo. - '|| l_bo_n_boxoffice_number );
                                    END IF;
                        END IF;

                        startlic := dmprogallocdetail.dmad_dt_start;
                        endlic := dmprogallocdetail.dmad_dt_end;
                        v_lic_status := 'A';
                        licnumber := get_seq ('SEQ_LIC_N_NUMBER');
                        l_lvr_n_revenue_share_percent := nvl(v_lvr_rec.lvr_n_revenue_share_percent,l_lff_rev_share_perc);
                        newlicnumber := licnumber || '-T';

                        INSERT INTO tbl_tva_license
                                    (lic_v_number, lic_n_gen_refno,
                                     lic_n_con_number,
                                     lic_n_lee_number,
                                     lic_n_dm_type, lic_v_status,
                                     lic_dt_start_date,
                                     lic_dt_end_date,
                                     lic_v_currency,
                                     lic_n_price, lic_v_comments,
                                     lic_dt_account_date,
                                     lic_dt_entry_date, lic_v_entry_oper,
                                     lic_n_update_count, lic_n_dm_number,
                                     lic_v_budget_type, lic_v_amort_code,
                                     --lic_n_min_shelf_life,
                                     lic_v_formats,
                                     lic_dt_lvr,
                                     lic_n_bo_rev_zar,
                                     lic_n_bo_rev_usd,
                                     lic_n_day_post_lvr,
                                     lic_v_bo_revenue_currency,
                                     lic_n_mg_exchange_rate,
                                     lic_n_bo_category,
                                     lic_n_revenue_share_percent,
                                     lic_dt_modified_on, lic_v_modified_by,
                                     lic_v_bo_sub_category, lic_n_dp_zar_hd,
                                     lic_n_dp_zar_sd, lic_n_dp_usd_hd,
                                     lic_n_dp_usd_sd, lic_n_lvr_exch_rate,
                                     lic_n_fee_formula_number,
                                     lic_c_tba,
                                     lic_dt_ap_review_date,
                                     lic_n_ap_usd_zar_rate,
                                     lic_n_ap_cov_rule,
                                     lic_n_ap_exch_rate_src,
                                     lic_dt_dp_review_date,
                                     lic_n_dp_usd_zar_rate,
                                     lic_c_dp_rev_share_flag,
                                     lic_n_dp_cov_rule,
                                     --lic_c_premium,
                                     /*Added by Jawahar */
                                     Lic_min_shelf_life_push,
                                     Lic_min_shelf_life_pull,
                                     Lic_subs_vw_period,
                                     Lic_shelf_space_per,
                                     Lic_lvr_applicable,
                                     LIC_ACT_CUR_COV_RULE,
                                     lic_min_guarantee,
                                     LIC_con_cur_DP_REV_SHARE_FLAG,
                                     lic_day_and_date
                                     /*End */
                                    )
                             VALUES (newlicnumber, p_genrefno,
                                     p_connumber,
                                     dmprogallocdetail.dmad_n_lee_number,
                                     dmprogramme.dm_n_type,
                                     v_lic_status,
                                     DECODE (dmprogallocdetail.dmad_c_tba,'Y',l_tba_date,dmprogallocdetail.dmad_dt_start ),
                                     DECODE (dmprogallocdetail.dmad_c_tba,  'Y', l_tba_date,dmprogallocdetail.dmad_dt_end),
                                     dmprogramme.dm_v_currency,
                                     TRUNC (l_lic_n_price, 4), NULL,
                                     DECODE (licensee,'SPO', dmprogallocdetail.dmad_dt_start,NULL),       --Jawahar TODO Check
                                     SYSDATE, UPPER (p_user_id),
                                     0, dmprogramme.dm_n_deal_memo_number,
                                     v_budget_code, theamortcode,
                                     --DECODE(l_dm_v_type,'VOD BUY PRICE', l_bo_n_min_shelf_life,dmprogramme.dmprg_n_min_shelf_life),
                                     dmprogramme.dmprg_v_formats,
                                     DECODE(dmprogramme.dmprg_bo_lvr_applicable,'Y',dmprogramme.dmprg_dt_lvr,NULL),
                                     dmprogramme.dmprg_n_bo_rev_zar,
                                     dmprogramme.dmprg_n_bo_rev_usd,
                                     --dmprogramme.dmprg_n_day_post_lvr,             --commented by Jawahar
                                     DECODE(dmprogramme.dmprg_bo_lvr_applicable,'Y',dmprogallocdetail.DMAD_DAYS_POST_LVR,NULL),           --Added by Jawahar
                                     l_lic_v_bo_revenue_currency,
                                     l_lic_n_mg_exchange_rate,
                                     l_lic_n_bo_category,
                                     l_lvr_n_revenue_share_percent,
                                     SYSDATE, UPPER (p_user_id),
                                     l_bo_v_sub_category,
                                     v_lvr_rec.LVR_N_DP_ZAR_HD,
                                     v_lvr_rec.LVR_N_DP_ZAR_SD,
                                     v_lvr_rec.LVR_N_DP_USD_HD,
                                     v_lvr_rec.LVR_N_DP_USD_SD,
                                     l_lvr_n_exch_rate,
                                     l_con_n_fee_formula_number,
                                     dmprogallocdetail.dmad_c_tba,
                                     l_ap_review_date,
                                     l_ap_usd_zar_rate,
                                     l_ap_cov_rule,
                                     l_ap_exch_rate_src,
                                     l_CON_DP_REVIEW_DATE,
                                     l_CON_DP_EXCHANGE_RATE,
                                     v_lvr_rec.LVR_C_DP_REV_SHARE_FLAG,
                                     l_CON_DP_PRICE_COV_RULE,
                                     --dmprogramme.dmprg_c_premium,
                                   /*Added by Jawahar */
                                     dmprogramme.DMPRG_MIN_SHELF_LIFE_PUSH,
                                     dmprogramme.DMPRG_MIN_SHELF_LIFE_PULL,
                                      l_CON_SUBS_VW_PERIOD,
                                     l_con_shelf_space_per,
                                     dmprogramme.dmprg_bo_lvr_applicable,
                                     i_con_act_cur_cov_rule,
                                     dmprogramme.dmprg_n_total_price,
                                     v_lvr_rec.LVR_CON_CUR_DP_REV_SHARE_FLAG,
                                     l_con_day_and_date
                                   /*End */
                                    );

                    /*Added by Jawahar to flow rights for each allocation for a prog */
                    INSERT INTO x_tv_lic_medplatdevcompat_map (
                                                                LIC_MPDC_ID,
                                                                LIC_MPDC_LIC_NUMBER,
                                                                LIC_MPDC_DEV_PLATM_ID,
                                                                LIC_RIGHTS_ON_DEVICE,
                                                                LIC_MPDC_COMP_RIGHTS_ID,
                                                                LIC_IS_COMP_RIGHTS,
                                                                LIC_MPDC_ENTRY_OPER,
                                                                LIC_MPDC_ENTRY_DATE,
                                                                LIC_MPDC_SERVICE_CODE
                                                                )
                         SELECT X_SEQ_TV_LIC_MPDC_ID.NEXTVAL,
                                newlicnumber,
                                MEM_MPDC_DEV_PLATM_ID,
                                MEM_RIGHTS_ON_DEVICE,
                                MEM_MPDC_COMP_RIGHTS_ID,
                                MEM_IS_COMP_RIGHTS,
                                UPPER (p_user_id),
                                SYSDATE,
                                MEM_MPDC_SERVICE_CODE
                           FROM x_tv_memo_medplatdevcompat_map
                          WHERE MEM_MPDC_ALD_ID = dmprogallocdetail.DMAD_N_NUMBER
                            AND NOT EXISTS( SELECT 1
                                              FROM x_tv_lic_medplatdevcompat_map
                                             WHERE LIC_MPDC_LIC_NUMBER = newlicnumber
                                               AND LIC_MPDC_DEV_PLATM_ID = MEM_MPDC_DEV_PLATM_ID
                                               AND LIC_MPDC_COMP_RIGHTS_ID = MEM_MPDC_COMP_RIGHTS_ID
                                               AND LIC_MPDC_SERVICE_CODE = MEM_MPDC_SERVICE_CODE
                                            )
                            AND NVL(MEM_RIGHTS_ON_DEVICE,'N') <> 'N';
                     --End Added by Jawahar to flow rights for each allocation for a prog

                     pkg_tva_dealmemo.license_ledger_init
                                              (newlicnumber,
                                               dmprogramme.dm_n_deal_memo_number,
                                               sublicenseeamount,
                                               p_user_id
                                              );
                     END IF;

                     -- Get the Company Type of the Contracting Entity i.e. is it a
                     -- Channel Company or a Buying Company
                     BEGIN
                        SELECT com_type
                          INTO contentstatus
                          FROM fid_company
                         WHERE com_number = dmprogramme.dm_n_con_com_number;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           contentstatus := 'CC';
                     END;

                     -- If the Contracting Entity is a buying company then the Target
                     -- company for the payments should be the Contracting Entity.  If
                     -- the Contracting Entity is a channel company then the Target
                     -- company for the payments should be the Supplier.
                     IF NVL (contentstatus, 'CC') = 'BC'
                     THEN
                        targetcom := dmprogramme.dm_n_con_com_number;
                     ELSE
                        targetcom := dmprogramme.dm_n_supp_com_number;
                     END IF;

                     -- Get the Company Number associated with the Licensee of the allocation
                     BEGIN
                        SELECT tvod_n_lee_cha_com_number
                          INTO sourcecom
                          FROM tvod_licensee
                         WHERE tvod_n_lee_number =
                                           dmprogallocdetail.dmad_n_lee_number;
                     END;

                        x_prc_inst_lic_payplan
                                      (
                                        I_LICPP_DM_NUMBER   =>  dmprogramme.dm_n_deal_memo_number,
                                        I_LICPP_LIC_NUMBER  =>   newlicnumber,
                                        I_LIC_START_DATE		=>   dmprogallocdetail.dmad_dt_start,
                                        i_entry_oper			  =>   p_user_id
                                      );

                     IF dmprogramme.deal_type = 'VOD FIXED PRICE'
                     THEN

                        IF pricetouse > 0
                        THEN

                           pkg_tva_dealmemo.create_lic_pay
                                             (p_connumber,
                                              newlicnumber,
                                              targetcom,
                                              sourcecom,
                                              pricetouse,
                                              dmprogramme.dm_n_deal_memo_number,
                                              dmprogramme.dm_v_currency,
                                              p_user_id
                                             );
                        END IF;
                     END IF;

                     IF dmprogramme.deal_type = 'VOD BUY PRICE'
                     THEN
                        pkg_tva_dealmemo.create_lic_pay_overage
                                             (p_connumber,
                                              newlicnumber,
                                              dmprogramme.dm_n_deal_memo_number,
                                              p_user_id
                                             );

                        -- If the License type is buy price
                        IF     l_lic_n_price IS NOT NULL
                           AND l_lic_n_price > 0
                        THEN
                           pkg_tva_dealmemo.create_lic_pay
                                             (p_connumber,
                                              newlicnumber,
                                              targetcom,
                                              sourcecom,
                                              pricetouse,
                                              dmprogramme.dm_n_deal_memo_number,
                                              dmprogramme.dm_v_currency,
                                              p_user_id
                                             );
                        END IF;

                     END IF;
                  END IF;

               END LOOP;     /*End of Allocation Detail Loop */
      END LOOP;              /* End of DM Programme Loop -- Can be removed? */
EXCEPTION
   WHEN OTHERS
   THEN
      raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END create_lic;
 --****************************************************************
-- This procedure will insert into license territory .
--****************************************************************
   PROCEDURE license_ledger_init (
      p_licnumber   IN   tbl_tva_lic_territory.lict_v_lic_number%TYPE,
      p_dmnumber    IN   tbl_tva_dm_territory.dmt_n_dm_number%TYPE,
      p_liccost     IN   tbl_tva_lic_territory.lict_n_price%TYPE,
      p_user_id     IN   tbl_tva_lic_territory.lict_v_entry_oper%TYPE
   )
   AS
      CURSOR c_dmterritories
      IS
         SELECT DISTINCT dmt_n_territory, dmt_v_rights
                    FROM tbl_tva_dm_territory
                   WHERE dmt_n_dm_number = p_dmnumber
                  and NVL(DMT_V_IS_LINKED,'N') = 'Y';

      l_lict_n_number         NUMBER;
      l_counter               NUMBER;
	  l_lee_ter_map_present   NUMBER;
   BEGIN
    FOR dmterritory IN c_dmterritories
    LOOP
	 SELECT count(1)
	   INTO l_lee_ter_map_present
	   FROM x_tva_lee_ter_map,
			tbl_tva_license
	  WHERE lic_n_lee_number = ltm_lee_number
		AND lic_v_number = p_licnumber
		AND ltm_ter_number = dmterritory.dmt_n_territory;

	 IF l_lee_ter_map_present > 0
	 THEN
		 BEGIN
            l_counter := 0;

            SELECT COUNT (8)
              INTO l_counter
              FROM tbl_tva_lic_territory
             WHERE lict_v_lic_number = p_licnumber
               AND lict_n_territory = dmterritory.dmt_n_territory;

            IF l_counter = 0
            THEN
               l_lict_n_number := get_seq ('SEQ_LICT_N_NUMBER');

               INSERT INTO tbl_tva_lic_territory
                           (lict_n_number, lict_v_lic_number,
                            lict_n_territory,
                            lict_v_rights, lict_n_price, lict_dt_entry_date,
                            lict_v_entry_oper, lict_n_update_count,
                            lict_dt_modified_on, lict_v_modified_by
                           )
                    VALUES (l_lict_n_number, p_licnumber,
                            dmterritory.dmt_n_territory,
                            dmterritory.dmt_v_rights, p_liccost, SYSDATE,
                            UPPER (p_user_id), 0,
                            SYSDATE, UPPER (p_user_id)
                           );
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error
                  (-20601,
                      SUBSTR (SQLERRM, 1, 200)
                   || ' In license_ledger_init while insert into tbl_tva_lic_territory'
                  );
         END;

         BEGIN
            UPDATE tbl_tva_lic_territory
               SET lict_n_price =
                       DECODE (dmterritory.dmt_v_rights,
                               'X', 0,
                               lict_n_price
                              ),
                   lict_v_modified_by = p_user_id,
                   lict_dt_modified_on = SYSDATE
             WHERE lict_n_territory = dmterritory.dmt_n_territory
               AND lict_v_lic_number = p_licnumber;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error
                  (-20601,
                      SUBSTR (SQLERRM, 1, 200)
                   || ' In license_ledger_init while update tbl_tva_lic_territory'
                  );
         END;
	 END IF;
    END LOOP;

      UPDATE tbl_tva_lic_territory
         SET lict_n_price = DECODE (lict_v_rights, 'X', 0, lict_n_price)
       WHERE lict_v_lic_number = p_licnumber;
   END license_ledger_init;

--****************************************************************
-- This function returns licensee channel company type.
-- The procedure input is licensee number.
--****************************************************************
   FUNCTION licensee_status (the_licensee IN NUMBER)
      RETURN VARCHAR2
   IS
-- PL/SQL Specification
      temp_status   VARCHAR2 (4);
-- PL/SQL Block
   BEGIN
      SELECT com_type
        INTO temp_status
        FROM fid_company, tvod_licensee
       WHERE com_number = tvod_n_lee_cha_com_number
         AND tvod_n_lee_number = the_licensee;

      RETURN temp_status;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20023, 'Cannot determine licensee status');
      WHEN OTHERS
      THEN
         raise_application_error (-20024,
                                  'unspecified error: licensee_status'
                                 );
   END licensee_status;

--****************************************************************
-- This function performs allocation verification.
--****************************************************************
   FUNCTION check_allocation (i_dm_n_deal_memo_number IN NUMBER)
      RETURN NUMBER
   IS
      theanswer         NUMBER;
      thewholeanswer    NUMBER;
      thesum            NUMBER;

      CURSOR c_dmprogrammes (cp_dm_n_deal_memo_number NUMBER)
      IS
         SELECT dmprg_n_number, dmprg_n_total_price
           FROM tbl_tva_dm_prog
          WHERE dmprg_n_dm_number = cp_dm_n_deal_memo_number;

      CURSOR get_dm_type
      IS
         SELECT dmtypes.deal_type
           FROM tbl_tva_deal_memo dealmemo, tvod_deal_memo_type dmtypes
          WHERE dealmemo.dm_n_type = dmtypes.dm_type_id
            AND dealmemo.dm_n_deal_memo_number = i_dm_n_deal_memo_number;

      v_dm_type         VARCHAR2 (20);
      programmeexists   NUMBER;
   BEGIN
      thewholeanswer := 1;
      programmeexists := 0;

      OPEN get_dm_type;

      FETCH get_dm_type
       INTO v_dm_type;

      CLOSE get_dm_type;

      FOR dmprogramme IN c_dmprogrammes (i_dm_n_deal_memo_number)
      LOOP
         IF programmeexists = 0
         THEN
            programmeexists := 1;
         END IF;

         IF UPPER (v_dm_type) = 'VOD FIXED PRICE'
         THEN
            SELECT SUM (dmad_n_amount)
              INTO thesum
              FROM tbl_tva_dm_allocation_detail
             WHERE dmad_n_dmprg_number = dmprogramme.dmprg_n_number;

            IF thesum IS NULL
            THEN
               theanswer := -1;
            ELSIF thesum <> dmprogramme.dmprg_n_total_price
            THEN
               theanswer := -1;
            ELSE
               theanswer := 1;
            END IF;
         ELSIF UPPER (v_dm_type) = 'VOD BUY PRICE'
         THEN
            SELECT COUNT (8)
              INTO thesum
              FROM tbl_tva_dm_allocation_detail
             WHERE dmad_n_dmprg_number = dmprogramme.dmprg_n_number;

            IF thesum = 0
            THEN
               theanswer := -1;
            ELSE
               theanswer := 1;
            END IF;
         END IF;

         IF theanswer = -1
         THEN
            thewholeanswer := -1;
            EXIT;
         END IF;
      END LOOP;

      IF programmeexists = 0
      THEN
         thewholeanswer := -1;
      END IF;

      RETURN thewholeanswer;
   END check_allocation;

--****************************************************************
-- This procedure will create record for license payment.
--****************************************************************
   PROCEDURE create_lic_pay (
      p_connumber               IN   tbl_tva_lic_payments.licp_n_con_number%TYPE,
      p_licnumber               IN   tbl_tva_lic_payments.licp_v_lic_number%TYPE,
      p_targetcom               IN   tbl_tva_lic_payments.licp_n_target_com_number%TYPE,
      p_sourcecom               IN   tbl_tva_lic_payments.licp_n_source_com_number%TYPE,
      p_liccost                 IN   NUMBER,
      p_dm_n_deal_memo_number   IN   NUMBER,
      p_dm_v_currency           IN   tbl_tva_lic_payments.licp_v_currency%TYPE,
      p_licp_v_entry_oper       IN   tbl_tva_lic_payments.licp_v_entry_oper%TYPE
   )
   AS
      CURSOR c_dmmgpayments
      IS
        SELECT dmmgpay_n_pay_amount, dmmgpay_v_currency, dmmgpay_v_pay_code,
                dmmgpay_n_pay_percent, dmmgpay_n_no_of_days,
                dmmgpay_n_pay_rule_number
                ,LICPP_NUMBER
           FROM tvod_payment_types
               ,tbl_tva_dm_mg_payment
               ,X_TVA_LIC_PAYMENT_PLAN
          WHERE dmmgpay_n_dm_number = p_dm_n_deal_memo_number
            and LICPP_LIC_NUMBER = p_licnumber
            and LICPP_ORDER_NUMBER = DMMGPAY_N_ORDER
            and DMMGPAY_N_DM_NUMBER = LICPP_DM_NUMBER
            AND pat_c_code = dmmgpay_v_pay_code;

      CURSOR tot_c
      IS
         SELECT SUM (dmmgpay_n_pay_amount)
           FROM tbl_tva_dm_mg_payment
          WHERE dmmgpay_n_dm_number = p_dm_n_deal_memo_number;

      l_licp_n_number             NUMBER;
      totalpay                    NUMBER;
      l_dm_v_type                 VARCHAR2 (50);
      l_licp_n_min_guarantee      NUMBER;
      l_dmmgpay_dt_pay_due_date   DATE;
      l_lic_dt_start_date         DATE;
      IS_TBA                     VARCHAR2(1)  ;
   BEGIN

      OPEN tot_c;

      FETCH tot_c
       INTO totalpay;

      FOR dmmgpayment IN c_dmmgpayments
      LOOP
         SELECT dmtypes.deal_type
           INTO l_dm_v_type
           FROM tvod_deal_memo_type dmtypes, tbl_tva_deal_memo dealmemo
          WHERE dealmemo.dm_n_type = dmtypes.dm_type_id
            AND dealmemo.dm_n_deal_memo_number = p_dm_n_deal_memo_number;

         IF l_dm_v_type = 'VOD FIXED PRICE'
         THEN
            l_licp_n_min_guarantee :=
               ROUND ((p_liccost * dmmgpayment.dmmgpay_n_pay_amount / totalpay
                      ),
                      2
                     );
         ELSIF l_dm_v_type = 'VOD BUY PRICE'
         THEN
            IF NVL (p_liccost, 0) > 0
            THEN
               l_licp_n_min_guarantee :=
                          p_liccost * dmmgpayment.dmmgpay_n_pay_percent / 100;
            END IF;
         END IF;

         SELECT lic_dt_start_date,LIC_C_TBA
           INTO l_lic_dt_start_date,IS_TBA
           FROM tbl_tva_license
          WHERE lic_v_number = p_licnumber;


       if NVL(IS_TBA,'N') = 'N'
       then
         l_dmmgpay_dt_pay_due_date :=
                        l_lic_dt_start_date + dmmgpayment.dmmgpay_n_no_of_days;
     else
       l_dmmgpay_dt_pay_due_date := TO_DATE('31-DEC-2199','DD-MON-RRRR');
     end if;


         l_licp_n_number := get_seq ('SEQ_LICP_N_NUMBER');

         BEGIN
            INSERT INTO tbl_tva_lic_payments
                        (licp_n_number, licp_n_source_com_number,
                         licp_n_target_com_number, licp_n_con_number,
                         licp_v_lic_number, licp_c_paid_status,
                         licp_n_amount, licp_dt_due_date,
                         licp_v_currency, licp_v_payment_code,
                         licp_dt_entry_date, licp_v_entry_oper,
                         licp_n_update_count, licp_dt_modified_on,
                         licp_v_modified_by,LICP_PAY_PLAN_NUMBER
                         ,LICP_DT_PAY_STATUS_DATE
                        )
                 VALUES (l_licp_n_number, p_sourcecom,
                         p_targetcom, p_connumber,
                         p_licnumber, 'N',
                         l_licp_n_min_guarantee, l_dmmgpay_dt_pay_due_date,
                         p_dm_v_currency,    --dmmgpayment.dmmgpay_v_currency,
                                         dmmgpayment.dmmgpay_v_pay_code,
                         SYSDATE, UPPER (p_licp_v_entry_oper),
                         0, SYSDATE,
                         UPPER (p_licp_v_entry_oper)
                         ,dmmgpayment.LICPP_NUMBER
                         ,SYSDATE
                        );
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20601,
                                           SUBSTR (SQLERRM, 1, 200)
                                        || ' - While creating license payments.'
                                       );
         END;
      END LOOP;

      CLOSE tot_c;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601,
                                     SUBSTR (SQLERRM, 1, 200)
                                  || ' In create_lic_pay'
                                 );
   END create_lic_pay;

--****************************************************************
-- This procedure will create record for license
-- overage payment.
--****************************************************************
   PROCEDURE create_lic_pay_overage (
      p_connumber               IN   tbl_tva_lic_overages.lico_n_con_number%TYPE,
      p_licnumber               IN   tbl_tva_lic_overages.lico_v_lic_number%TYPE,
      p_dm_n_deal_memo_number   IN   NUMBER,
      p_lico_v_entry_oper       IN   tbl_tva_lic_overages.lico_v_entry_oper%TYPE
   )
   IS
      l_lico_n_number   NUMBER;

      CURSOR c_dmoapayments
      IS
         SELECT dmpo_n_no_of_days, dmpo_n_pay_rule_number,
                                                          dmpo_v_pay_code
           FROM tbl_tva_dm_payment_overage
          WHERE dmpo_n_dm_number = p_dm_n_deal_memo_number;
   BEGIN
      FOR dmoapayment IN c_dmoapayments
      LOOP
         l_lico_n_number := get_seq ('SEQ_LICO_N_NUMBER');

         BEGIN
            INSERT INTO tbl_tva_lic_overages
                        (lico_n_number, lico_n_no_of_days,
                         lico_n_pay_rule_number,
                         lico_v_pay_code, lico_v_lic_number,
                         lico_n_con_number, lico_dt_entry_date,
                         lico_v_entry_oper, lico_n_update_count,
                         lico_dt_modified_on, lico_v_modified_by
                        )
                 VALUES (l_lico_n_number, dmoapayment.dmpo_n_no_of_days,
                         dmoapayment.dmpo_n_pay_rule_number,
                         dmoapayment.dmpo_v_pay_code, p_licnumber,
                         p_connumber, SYSDATE,
                         p_lico_v_entry_oper, 0,
                         SYSDATE, p_lico_v_entry_oper
                        );
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error
                  (-20601,
                      SUBSTR (SQLERRM, 1, 200)
                   || ' In create_lic_pay_overage while insert into tbl_tva_lic_overages'
                  );
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601,
                                     SUBSTR (SQLERRM, 1, 200)
                                  || ' In create_lic_pay_overage.'
                                 );
   END create_lic_pay_overage;

--****************************************************************
-- This function performs payment verification.
--****************************************************************
   FUNCTION check_payment (i_dm_n_deal_memo_number IN NUMBER)
      RETURN NUMBER
   IS
      CURSOR get_dm_type
      IS
         SELECT dmtypes.deal_type
           FROM tbl_tva_deal_memo dealmemo, tvod_deal_memo_type dmtypes
          WHERE dealmemo.dm_n_type = dmtypes.dm_type_id
            AND dealmemo.dm_n_deal_memo_number = i_dm_n_deal_memo_number;

      v_dm_type    VARCHAR2 (20);
      dmprice      NUMBER;
      dmprgsum     NUMBER;
      dmmgpaypct   NUMBER;
   BEGIN
      OPEN get_dm_type;

      FETCH get_dm_type
       INTO v_dm_type;

      CLOSE get_dm_type;

      -- ... if amounts are the same, returns 0; if a positive number is returned, payments are too much
      IF UPPER (v_dm_type) = 'VOD FIXED PRICE'
      THEN
         BEGIN
            SELECT NVL (SUM (dmmgpay_n_pay_amount), 0)
              INTO dmprice
              FROM tbl_tva_dm_mg_payment, tvod_payment_types
            WHERE  dmmgpay_n_dm_number = i_dm_n_deal_memo_number
               AND pat_c_code = dmmgpay_v_pay_code;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20000,
                                        'fatal error summing DM payments'
                                       );
         END;

         BEGIN
            SELECT NVL (SUM (dmprg_n_total_price), 0)
              INTO dmprgsum
              FROM tbl_tva_dm_prog
             WHERE dmprg_n_dm_number = i_dm_n_deal_memo_number;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20000,
                                        'fatal error summing DMPRG amounts'
                                       );
         END;

         RETURN (dmprice - dmprgsum);
      ELSIF UPPER (v_dm_type) = 'VOD BUY PRICE'
      THEN
         BEGIN
            SELECT NVL (SUM (dmmgpay_n_pay_percent), 0)
              INTO dmmgpaypct
              FROM tbl_tva_dm_mg_payment
             WHERE dmmgpay_n_dm_number = i_dm_n_deal_memo_number;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20000,
                                        'fatal error summing MG percents'
                                       );
         END;

     RETURN (100 - dmmgpaypct);
      END IF;
   END check_payment;

------------------------------------------------ PROCEDURE TO CHECK USER INSERT RIGHTS ----------------------------------------------------
--****************************************************************
-- This procedure checks if user has deal memo insert rights.
-- The procedure input is user id.
--****************************************************************
   PROCEDURE prc_check_user_insertrights (
      i_user_id          IN       VARCHAR2,
      i_meu_lee_number   IN       tbl_tva_dm_user.dmu_n_lee_number%TYPE,
      o_flag             OUT      NUMBER,
      o_message          OUT      VARCHAR2
   )
   AS
      l_flag      NUMBER         := 0;
      l_message   VARCHAR2 (500);
      norights    EXCEPTION;
   BEGIN
      o_flag := 1;

      SELECT COUNT (dmu_v_usr_id)
        INTO l_flag
        FROM tbl_tva_dm_user
       WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id);

      IF (NVL (l_flag, 0) = 0)
      THEN
         o_flag := 0;
         l_message := 'You are not a registered DEAL MEMO user.';
         RAISE norights;
      END IF;

      SELECT COUNT (dmu_v_usr_id)
        INTO l_flag
        FROM tbl_tva_dm_user
       WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id)
         AND dmu_n_lee_number = i_meu_lee_number;

      IF (NVL (l_flag, 0) = 0)
      THEN
         o_flag := 0;
         l_message :=
                     'You are not allowed to create deal with this licensee.';
         RAISE norights;
      END IF;
   EXCEPTION
      WHEN norights
      THEN
         o_message := l_message;
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_check_user_insertrights;

   ------------------------------------------------ PROCEDURE TO CHECK USER UPDATE RIGHTS ----------------------------------------------------
--****************************************************************
-- This procedure checks if user has deal memo update rights.
-- The procedure input is deal memo number and user id.
--****************************************************************
   PROCEDURE prc_check_user_updaterights (
      i_dm_n_deal_memo_number   IN       NUMBER,
      i_meu_lee_number          IN       tbl_tva_dm_user.dmu_n_lee_number%TYPE,
      i_user_id                 IN       VARCHAR2,
      o_flag                    OUT      NUMBER,
      o_message                 OUT      VARCHAR2
   )
   AS
      can_update          VARCHAR2 (1);
      l_dm_n_lee_number   NUMBER;
      l_flag              NUMBER         := 0;
      norights            EXCEPTION;
      l_message           VARCHAR2 (200);
   BEGIN
      o_flag := 1;

      BEGIN
         SELECT COUNT (dmu_v_usr_id)
           INTO l_flag
           FROM tbl_tva_dm_user
          WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id);

         --DBMS_OUTPUT.PUT_LINE('1' || l_flag);
         IF (NVL (l_flag, 0) = 0)
         THEN
            --DBMS_OUTPUT.PUT_LINE('2');
            o_flag := 0;
            l_message := 'You are not a registered DEAL MEMO user.';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            --DBMS_OUTPUT.PUT_LINE('3');
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      IF (NVL (l_flag, 0) <> 0)
      THEN
         BEGIN
            SELECT dm_n_lee_number
              INTO l_dm_n_lee_number
              FROM tbl_tva_deal_memo
             WHERE dm_n_deal_memo_number = i_dm_n_deal_memo_number;
         --DBMS_OUTPUT.PUT_LINE('4' || l_dm_n_lee_number);
         EXCEPTION
            WHEN OTHERS
            THEN
               --DBMS_OUTPUT.PUT_LINE('5');
               raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
         END;

         BEGIN
            SELECT dmu_v_can_update
              INTO can_update
              FROM tbl_tva_dm_user
             WHERE dmu_n_lee_number = l_dm_n_lee_number
               AND UPPER (dmu_v_usr_id) = UPPER (i_user_id);
         --DBMS_OUTPUT.PUT_LINE('6' || can_update);
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
            RAISE norights;
         END IF;

         SELECT COUNT (dmu_v_usr_id)
           INTO l_flag
           FROM tbl_tva_dm_user
          WHERE UPPER (dmu_v_usr_id) = UPPER (i_user_id)
            AND dmu_n_lee_number = i_meu_lee_number;

         IF (NVL (l_flag, 0) = 0)
         THEN
            o_flag := 0;
            l_message :=
                     'You are not allowed to update deal with this licensee.';
            RAISE norights;
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
         o_message := l_message;
   /*  WHEN OTHERS
     THEN
        raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));*/
   END prc_check_user_updaterights;

--****************************************************************
-- This procedure returns minimum shelf life corresponding to
-- contract number and BO revenue.
--****************************************************************
   PROCEDURE returnminshelflife (
      i_con_n_contract_number   IN       tbl_tva_contract.con_n_contract_number%TYPE,
      I_BO_N_REVENUE            in       number,
      i_prog_category             IN       TBL_TVA_BOXOFFICE.BO_N_CATEGORY%type,
      o_minshelflife            OUT      tbl_tva_boxoffice.bo_n_min_shelf_life%TYPE
   )
   AS
   BEGIN
      SELECT bo_n_min_shelf_life
        INTO o_minshelflife
        FROM tbl_tva_boxoffice
       WHERE i_bo_n_revenue BETWEEN bo_n_revenue_from AND bo_n_revenue_to
         AND bo_n_contract_number = i_con_n_contract_number
         AND bo_n_category = i_prog_category;

      IF o_minshelflife IS NULL
      THEN
         o_minshelflife := 0;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         o_minshelflife := 0;
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END returnminshelflife;

--****************************************************************
-- This procedure will delete all territories corresponding to deal memo.
--****************************************************************
   PROCEDURE prc_tva_delete_all_territories (
      i_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
      o_deleted            OUT      NUMBER
   )
   AS
      l_flag   NUMBER;
   BEGIN
      o_deleted := -1;

      DELETE FROM tbl_tva_dm_territory
            WHERE dmt_n_dm_number = i_deal_memo_number;

      COMMIT;
   EXCEPTION
    WHEN others
    THEN ROLLBACK;
      raise_application_error
                   (-20601,
                    'The territories could not be deleted, Please try again.'
                   );
   END prc_tva_delete_all_territories;

   PROCEDURE prc_tva_vld_bo_curr (
      i_con_n_contract_number   IN   tbl_tva_contract.con_n_contract_number%TYPE,
      i_dm_n_number             IN   tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE
   )
   AS
      CURSOR c_dmprogramme (cp_dmprg_dm_n_number NUMBER)
      IS
         SELECT dmprg_n_dm_number,
                dmprg_n_number,
                dmprg_n_bo_rev_usd,
                dmprg_n_bo_rev_zar,
                gen_title,
                DMPRG_N_BO_CATEGORY,
                DMPRG_V_SUB_CATEGORY,
                (SELECT  DM_BO_REV_CUR from tbl_tva_deal_memo WHERE DM_N_DEAL_MEMO_NUMBER = DMPRG_N_DM_NUMBER) as DM_BO_REV_CUR --Added by Jawahar
           FROM tbl_tva_dm_prog,
                fid_general gen
          WHERE gen.gen_refno = dmprg_n_gen_refno
            AND dmprg_n_dm_number = cp_dmprg_dm_n_number;

      l_con_v_bo_currency   VARCHAR2 (10);
      currencynotmatching   EXCEPTION;
      currencynopresent     EXCEPTION;
      l_bo_rev_currency     VARCHAR2 (10);
      l_gen_title           VARCHAR2 (120);
      l_CON_N_FEE_FORMULA_NUMBER  number;
      l_rev_amt              NUMBER;
      l_boc_number         NUMBER;
      l_total_cnt           NUMBER;

   BEGIN

    dbms_output.put_line('In prc_tva_vld_bo_curr');
      BEGIN
         SELECT con_v_bo_currency,CON_N_FEE_FORMULA_NUMBER
           INTO l_con_v_bo_currency,l_CON_N_FEE_FORMULA_NUMBER
           FROM tbl_tva_contract
          WHERE con_n_contract_number = i_con_n_contract_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20601, 'Invalid Contract');
      END;

      FOR dmprogramme IN c_dmprogramme (i_dm_n_number)
      LOOP
         l_gen_title := replace(dmprogramme.gen_title,':');

        IF l_CON_N_FEE_FORMULA_NUMBER = 1 OR l_CON_N_FEE_FORMULA_NUMBER = 2
        THEN
         IF
             dmprogramme.DM_BO_REV_CUR IS NULL        --Added by jawahar
         THEN
            RAISE currencynopresent;
         END IF;

         dbms_output.put_line('l_bo_rev_currency :' || l_bo_rev_currency);
         dbms_output.put_line('l_con_v_bo_currency :' || l_con_v_bo_currency);

         IF  dmprogramme.dm_bo_rev_cur != l_con_v_bo_currency  --Added By Jawahar
         THEN
             raise_application_error(-20601,'BO Revenue currency - '||dmprogramme.dm_bo_rev_cur || ' does not matches with contract BO Revenue currency - '||l_con_v_bo_currency);
         END IF;

         select dmprg_bo_rev
         into  l_rev_amt
         from  tbl_tva_dm_prog
         WHERE  dmprg_n_dm_number = i_dm_n_number
         and    dmprg_n_number =  dmprogramme.dmprg_n_number;

         dbms_output.put_line('Rev amt' || l_rev_amt);

         SELECT COUNT(BO_N_BOXOFFICE_NUMBER)
         INTO   l_total_cnt
         FROM   tbl_tva_boxoffice
         WHERE  BO_N_CONTRACT_NUMBER = i_con_n_contract_number
          AND bo_v_sub_category =  dmprogramme.dmprg_v_sub_category
          AND bo_n_category =   dmprogramme.dmprg_n_bo_category
         AND   l_rev_amt BETWEEN BO_N_REVENUE_FROM  AND nvl(BO_N_REVENUE_TO,999999999999999);

          dbms_output.put_line('total count' || l_total_cnt);

            IF l_total_cnt = 0 AND dmprogramme.dmprg_n_bo_category = 'CURRENT'
            THEN
              raise_application_error
            (-20601,
                'Prog. BO Revenue ' || l_bo_rev_currency || ' does not falls between range provided on contract for title '
                || l_gen_title);
            END IF;
     END IF;
      END LOOP;
      dbms_output.put_line('After endloop');

   EXCEPTION
      WHEN currencynopresent
      THEN

        if  l_CON_N_FEE_FORMULA_NUMBER in (3,4)
        then
              NULL;
        else
         raise_application_error
            (-20601,'BO Revenue is not available .');
        end if;
      /*WHEN currencynotmatching
      THEN
         IF  l_CON_N_FEE_FORMULA_NUMBER in (3,4)
         THEN
              NULL;
              dbms_output.put_line('in formula 3,4');
         ELSE
               dbms_output.put_line('in else');
                 IF l_con_v_bo_currency = 'USD'
                 THEN
                            raise_application_error
                               (-20601,
                                   'Prog. BO Revenue currency ZAR does not matches with contract BO Revenue currency USD for Title - '
                                || l_gen_title
                                || '.'
                               );

                 ELSE
                    raise_application_error
                       (-20601,
                           'Prog. BO Revenue currency USD does not matches with contract BO Revenue currency ZAR for Title - '
                        || l_gen_title
                        || '.'
                       );
                 END IF;
         END IF;*/

      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_vld_bo_curr;

   PROCEDURE prc_tva_vald_buy_pric_singpd (
      p_dmprg_n_dm_number   IN   NUMBER,
      p_connumber           IN   tbl_tva_license.lic_n_con_number%TYPE,
      p_check_flag          IN   NUMBER
   )
   IS
      CURSOR c_dmprogramme
      IS
         SELECT dmprg_n_dm_number, dmprg_n_number,
                    dmprg_n_gen_refno, gen_title, dmprg_n_bo_category,
                dmprg_v_sub_category, dmprg_dt_lvr
           FROM tbl_tva_dm_prog, fid_general
          WHERE dmprg_n_gen_refno = gen_refno
            AND dmprg_n_dm_number = p_dmprg_n_dm_number;

      l_bo_n_boxoffice_number   tbl_tva_boxoffice.bo_n_boxoffice_number%TYPE;
      l_con_v_bo_currency       tbl_tva_contract.con_v_bo_currency%TYPE;
      l_revenue_share_percent   tbl_tva_lvr.lvr_n_revenue_share_percent%TYPE;
      l_boc_v_category          tvod_boxoffice_category.boc_v_category%TYPE;
      l_dmad_c_tba              tbl_tva_dm_allocation_detail.dmad_c_tba%TYPE;
      l_licensee_fee_formula    NUMBER;

       v_min_lvr_n_lvr_from           tbl_tva_lvr.LVR_N_LVR_FROM%TYPE;
       v_max_lvr_n_lvr_to              tbl_tva_lvr.LVR_N_LVR_TO%TYPE;

   BEGIN
     dbms_output.put_line('in prc_tva_vald_buy_pric_singpd');

      BEGIN
         SELECT con_v_bo_currency, con_n_fee_formula_number
           INTO l_con_v_bo_currency, l_licensee_fee_formula
           FROM tbl_tva_contract
          WHERE con_n_contract_number = p_connumber;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            IF p_check_flag = 0
            THEN
               raise_application_error (-20601,'Cannot SINGPD deal as Contract. '|| p_connumber || ' is not available');
            ELSE
               raise_application_error (-20601,p_connumber|| ' Contract is not available');
            END IF;
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200) || ' - While selecting Contract Data');
      END;

   dbms_output.put_line('bo currency' || l_con_v_bo_currency || 'license fee formula' || l_licensee_fee_formula);

      FOR dmprogramme IN c_dmprogramme
      LOOP
         IF l_licensee_fee_formula = 1 OR l_licensee_fee_formula = 2
         then
           dbms_output.put_line(' IF l_licensee_fee_formula = 1 OR l_licensee_fee_formula = 2');

            SELECT PC_PGM_CATEGORY_CODE
              INTO l_boc_v_category
              from SGY_PB_PGM_CATEGORY
             WHERE PC_PGM_CATEGORY_CODE = dmprogramme.dmprg_n_bo_category;

            BEGIN
               SELECT bo_n_boxoffice_number
                 INTO l_bo_n_boxoffice_number
                 FROM tbl_tva_boxoffice
                WHERE bo_n_contract_number = p_connumber
                  AND bo_v_sub_category = dmprogramme.dmprg_v_sub_category
                  AND bo_n_category = dmprogramme.dmprg_n_bo_category;
            EXCEPTION
               WHEN NO_DATA_FOUND
               then
                  IF p_check_flag = 0
                  then
                        raise_application_error(-20601,'Cannot SINGPD deal as required data for Program Category - ' || l_boc_v_category || ' BO Category - ' || dmprogramme.dmprg_v_sub_category || ' is not available.');

                  else
                       raise_application_error (-20601,'Data of Program Category - ' || L_BOC_V_CATEGORY || ' And BO Category - '|| dmprogramme.dmprg_v_sub_category|| ' does not matches with data present on contract.');
                  END IF;
               WHEN OTHERS
               THEN
                  raise_application_error (-20601,  ' - While selecting box office category.');
            END;


           /*++++++++++++++++++++++++++++*/
           /*Added by Jawahar                           */
           /*Validate revenue share percent      */
           /*++++++++++++++++++++++++++++*/

              IF dmprogramme.dmprg_dt_lvr IS NOT NULL
              THEN
                       SELECT  min(lvr_n_lvr_from),
                                      MAX(lvr_n_lvr_to)
                            INTO v_min_lvr_n_lvr_from,
                                      v_max_lvr_n_lvr_to
                         FROM  tbl_tva_lvr
                       WHERE  lvr_n_contract_number = p_connumber
                            AND  lvr_n_bo_number = l_bo_n_boxoffice_number;

                        FOR dm_allocation IN ( SELECT dmad_days_post_lvr,
                                                                            ( SELECT  TVOD_V_LEE_SHORT_NAME FROM tvod_licensee where TVOD_N_LEE_NUMBER=  DMAD_N_LEE_NUMBER ) as lee_name
                                                                 FROM tbl_tva_dm_allocation_detail
                                                                WHERE dmad_n_dmprg_number = dmprogramme.dmprg_n_number
                                                                     AND NVL(dmad_c_tba,'N') = 'N'
                                                          )
                         LOOP

                              IF  NOT dm_allocation.dmad_days_post_lvr BETWEEN v_min_lvr_n_lvr_from AND v_max_lvr_n_lvr_to
                              THEN
                                         IF p_check_flag = 0
                                         THEN
                                            raise_application_error (-20601, 'Cannot SINGPD deal as LVR share percent is not available on Contract. Programme -' || dmprogramme.gen_title || ' DPLVR - ' ||dm_allocation.dmad_days_post_lvr);
                                         ELSE
                                            raise_application_error (-20601, 'LVR share percent is not available on Contract. Programme -'|| dmprogramme.gen_title|| '  and Licensee -'||dm_allocation.lee_name|| ' DPLVR - '|| dm_allocation.dmad_days_post_lvr);
                                         END IF;

                             END IF;

                        END LOOP;
             END IF;                              /*Enf if of IF dmprogramme.dmprg_dt_lvr IS NOT NULL */

         END IF;
      END LOOP;


   END prc_tva_vald_buy_pric_singpd;
--****************************************************************
-- This procedure Inserts Deal Memo Licensees.
--****************************************************************
PROCEDURE x_prc_tva_insert_dm_lee (
      i_dm_number    IN       X_TVA_DM_LICENSEE.DML_DM_NUMBER%TYPE,
      i_lee_number   IN       X_TVA_DM_LICENSEE.DML_LEE_NUMBER%TYPE,
      i_entry_oper   IN       X_TVA_DM_LICENSEE.DML_ENTRY_OPER%TYPE,
      o_status       OUT      X_TVA_DM_LICENSEE.DML_MAP_ID%TYPE
   )
   AS
      l_dmt_n_number   NUMBER;
      insertfailed     EXCEPTION;
   BEGIN
      o_status := -1;
      l_dmt_n_number := seq_dmr_n_number.NEXTVAL;


	  INSERT INTO X_TVA_DM_LICENSEE(
									DML_MAP_ID
									,DML_DM_NUMBER
									,DML_LEE_NUMBER
									,DML_ENTRY_OPER
                  ,DML_ENTRY_DATE
									)
						 VALUES	(
									l_dmt_n_number
									,i_dm_number
									,i_lee_number
									,i_entry_oper
									,SYSDATE
									)
        RETURNING DML_MAP_ID
             INTO o_status;

      IF o_status > 0
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
      WHEN OTHERS
      THEN
         ROLLBACK;
         o_status := -1;
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END x_prc_tva_insert_dm_lee;

    PROCEDURE x_prc_tva_delete_dm_lee (
      i_DML_LEE_NUMBER         IN      X_TVA_DM_LICENSEE.DML_LEE_NUMBER%TYPE,
	  i_dm_number		   IN 		X_TVA_DM_LICENSEE.DML_DM_NUMBER%TYPE,
      i_entry_oper         IN       X_TVA_DM_LICENSEE.DML_ENTRY_OPER%TYPE,
      o_status             OUT      NUMBER,
      o_updateddata        OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      o_status := -1;

     DELETE X_TVA_DM_LICENSEE
        WHERE DML_LEE_NUMBER = i_DML_LEE_NUMBER
        and DML_DM_NUMBER = i_dm_number;

         o_status := SQL%ROWCOUNT;


      IF o_status >= 0
      THEN
         COMMIT;
      ELSE
         OPEN o_updateddata FOR
            SELECT s1.DML_DM_NUMBER,
			       s2.TVOD_N_LEE_NUMBER,
                   s2.TVOD_V_LEE_NAME,
				   s2.TVOD_V_LEE_SHORT_NAME
              FROM X_TVA_DM_LICENSEE s1,
			       tvod_licensee s2
             WHERE s1.DML_LEE_NUMBER = s2.TVOD_N_LEE_NUMBER
			   AND s1.DML_DM_NUMBER = i_dm_number;
      END IF;
	  o_status := 0;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END x_prc_tva_delete_dm_lee;

   PROCEDURE x_prc_tva_view_dm_lee (
    i_dm_number    IN       X_TVA_DM_LICENSEE.DML_DM_NUMBER%TYPE,
    o_dm_licensee_data   OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )as
   BEGIN

   OPEN o_dm_licensee_data FOR
            SELECT s1.DML_DM_NUMBER,
			       s2.TVOD_N_LEE_NUMBER,
                   s2.TVOD_V_LEE_NAME,
				   s2.TVOD_V_LEE_SHORT_NAME
              FROM X_TVA_DM_LICENSEE s1,
			       tvod_licensee s2
             WHERE s1.DML_LEE_NUMBER = s2.TVOD_N_LEE_NUMBER
			   AND s1.DML_DM_NUMBER = i_dm_number
         order by TVOD_V_LEE_NAME;

   END x_prc_tva_view_dm_lee;

   PROCEDURE x_prc_set_dm_number
                              (
                              i_dm_number                IN  tbl_tva_deal_memo.DM_N_DEAL_MEMO_NUMBER%TYPE
                              )AS
    BEGIN
          pkg_tva_dealmemo.dm_number := i_dm_number;
    END x_prc_set_dm_number;

  FUNCTION x_fnc_get_dm_number

  RETURN tbl_tva_deal_memo.DM_N_DEAL_MEMO_NUMBER%TYPE
  AS
  BEGIN
         RETURN  pkg_tva_dealmemo.dm_number;
  END  x_fnc_get_dm_number;
PROCEDURE x_prc_add_deal_medplatmdevcomp
(
i_ald_id               		IN     TBL_TVA_DM_ALLOCATION_DETAIL.DMAD_N_NUMBER%TYPE,
i_med_DEV_PLATM_ID    		IN     varchar_array,
i_med_rights_on_device    IN     varchar_array,
i_med_comp_rights_id      IN     varchar_array,
i_med_IS_COMP_RIGHTS   		IN     varchar_array,
i_entry_oper           		IN     x_tv_memo_medplatdevcompat_map.MEM_MPDC_ENTRY_OPER%TYPE,
o_status                  OUT    NUMBER
)AS

l_flag           NUMBER;
l_memo_count     NUMBER;
l_media_Service  VARCHAR2 (20):= 'TVOD';

v_med_DEV_PLATM_ID    		    VARCHAR2(1000); --x_tv_memo_medplatdevcompat_map.MEM_MPDC_DEV_PLATM_ID%TYPE;
v_med_rights_on_device     	  VARCHAR2(1000); --x_tv_memo_medplatdevcompat_map.MEM_RIGHTS_ON_DEVICE%TYPE;
v_med_comp_rights_id      	  VARCHAR2(1000); --x_tv_memo_medplatdevcompat_map.MEM_MPDC_COMP_RIGHTS_ID%TYPE;
v_med_IS_COMP_RIGHTS   		    VARCHAR2(1000); --x_tv_memo_medplatdevcompat_map.MEM_IS_COMP_RIGHTS%TYPE;

 BEGIN

	FOR i IN i_med_DEV_PLATM_ID.FIRST..i_med_DEV_PLATM_ID.LAST
	LOOP
	    v_med_DEV_PLATM_ID    	:= i_med_DEV_PLATM_ID(i);
      v_med_rights_on_device  := i_med_rights_on_device(i);

      v_med_comp_rights_id    := i_med_comp_rights_id(i);
      v_med_IS_COMP_RIGHTS    := i_med_IS_COMP_RIGHTS(i);

        FOR j IN (
                 select a.med_comp_rights_id,
                        b.med_IS_COMP_RIGHTS
				From
                    (SELECT COLUMN_VALUE med_comp_rights_id, ROWNUM r
                              From Table (
                              Pkg_Pb_Media_Plat_Ser.Split_To_Char (v_med_comp_rights_id,','))
                    ) a
                    ,(SELECT COLUMN_VALUE med_IS_COMP_RIGHTS, ROWNUM r
                              From Table (
                              Pkg_Pb_Media_Plat_Ser.Split_To_Char (v_med_IS_COMP_RIGHTS,','))
                    ) B
                    where a.r = b.r
        )
        LOOP

		 SELECT COUNT (1)
           INTO l_memo_count
           FROM x_tv_memo_medplatdevcompat_map
          WHERE MEM_MPDC_ALD_ID = i_ald_id
            AND MEM_MPDC_DEV_PLATM_ID = v_med_DEV_PLATM_ID
            AND MEM_MPDC_COMP_RIGHTS_ID = j.med_comp_rights_id;


			  IF l_memo_count = 0
			  THEN
					INSERT
					  INTO x_tv_memo_medplatdevcompat_map (MEM_MPDC_ID,
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
							v_med_DEV_PLATM_ID,
							v_med_rights_on_device,
							j.med_comp_rights_id,
							j.med_IS_COMP_RIGHTS,
							i_entry_oper,
							SYSDATE,
							0,
							l_media_Service);

			  ELSE
					UPDATE x_tv_memo_medplatdevcompat_map
					   SET MEM_RIGHTS_ON_DEVICE = v_med_rights_on_device,
                 MEM_MPDC_COMP_RIGHTS_ID = j.med_comp_rights_id,
                 MEM_IS_COMP_RIGHTS = j.med_IS_COMP_RIGHTS,
                 MEM_MPDC_MODIFIED_BY = i_entry_oper,
                 MEM_MPDC_MODIFIED_ON = SYSDATE,
                 MEM_MPDC_UPDATE_COUNT = NVL(MEM_MPDC_UPDATE_COUNT,0) + 1
					 WHERE MEM_MPDC_ALD_ID = i_ald_id
					   AND MEM_MPDC_DEV_PLATM_ID = v_med_DEV_PLATM_ID
					   AND MEM_MPDC_COMP_RIGHTS_ID = j.med_comp_rights_id
					   AND MEM_MPDC_SERVICE_CODE = l_media_Service;
				 END IF;

		 END LOOP;

	  END LOOP;

      l_flag := SQL%ROWCOUNT;

      IF l_flag > 0
      THEN
          DELETE x_tv_memo_medplatdevcompat_map
           WHERE MEM_MPDC_ALD_ID = i_ald_id
             AND MEM_RIGHTS_ON_DEVICE ='N';

         COMMIT;
         o_status := 1;
      ELSE
         ROLLBACK;
         o_status := 0;
      END IF;
exception
when OTHERS THEN

RAISE_APPLICATION_ERROR(-20999,SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,200));

END x_prc_add_deal_medplatmdevcomp;

  PROCEDURE x_prc_get_default_rights
  (
    i_con_short_name    IN     tbl_tva_contract.con_v_short_name%TYPE,
		o_dm_blank_rights      OUT sys_refcursor,
		o_def_rights           OUT sys_refcursor
	)
  AS
    l_dev_compt      VARCHAR2(5000);
    l_default_rights VARCHAR2(5000);
    l_dm_rights      VARCHAR2(5000);
    l_def_comp       VARCHAR2(5000);
    l_con_number     NUMBER;
  BEGIN
    l_dev_compt := x_tv_fnc_get_compat;
    l_def_comp  := x_tv_fnc_get_def_compat;

    IF i_con_short_name IS NULL
    THEN
    l_default_rights
                          := ' SELECT *
                                 FROM
                                    (
                                      SELECT Device_Code,
                                            Platform_Code,
                                            dev_plat_map_id as Device_Plat_Id,
                                            comp_code,
                                            dev_plat_comp_rights
                                       FROM X_VW_DEVICE_PLAT_DETAILS
                                      WHERE EXISTS ( SELECT 1
                                                      FROM X_CP_MEDPLATDEVCOMP_SERVC_MAP
                                                     where MPDCS_MPDC_ID  = plat_comp_map_id
                                                       and MPDCS_MED_SERVICE_CODE = ''TVOD''
                                                    )
                                    )
                               PIVOT (
                                      MAX(dev_plat_comp_rights) for comp_code in('||l_def_comp||')
                                     )';
    ELSE
      SELECT con_n_contract_number
        INTO l_con_number
        FROM tbl_tva_contract
       WHERE con_v_short_name = i_con_short_name;

      pkg_tva_contract.x_prc_set_con_number(l_con_number);

      l_default_rights := 'SELECT *
                             FROM (SELECT device_code,
                                          platform_code,
                                          device_id device_plat_id,
                                          comp_code,
                                          con_is_comp_rights dev_plat_comp_rights
                                     FROM x_vw_cont_comp_map)
                             PIVOT (
                                    MAX(dev_plat_comp_rights) FOR comp_code in('||l_def_comp||')
                                   )';
    END IF;
   /*Blnk rihts to load first time */

      l_dm_rights   :=' SELECT *
                                 FROM
                                    (
                                      SELECT Device_Code,
                                            Platform_Code,
                                            dev_plat_map_id as device_id,
                                            comp_code,
                                            ''N'' dev_plat_comp_rights,
                                            ''N'' rights_on_device
                                       FROM X_VW_DEVICE_PLAT_DETAILS
                                      WHERE EXISTS ( SELECT 1
                                                      FROM X_CP_MEDPLATDEVCOMP_SERVC_MAP
                                                     where MPDCS_MPDC_ID  = plat_comp_map_id
                                                       and MPDCS_MED_SERVICE_CODE = ''TVOD''
                                                    )
                                    )
                               PIVOT (
                                      MAX(dev_plat_comp_rights) for comp_code in('||l_dev_compt||')
                                     )';

   OPEN o_dm_blank_rights
   for l_dm_rights;

   OPEN o_def_rights
    FOR l_default_rights;


  END x_prc_get_default_rights;

  PROCEDURE x_prc_get_prog_info
                              (
                               i_con_v_short_name        IN       tbl_tva_contract.con_v_short_name%TYPE,
                               o_prog_info  OUT sys_refcursor
                              )AS
	V_CON_N_FEE_FORMULA_NUMBER  NUMBER;
	v_bo_cnt 									  NUMBER;
  l_con_n_lff_min_gurantee    NUMBER;
   BEGIN

        SELECT con_n_fee_formula_number,
               con_n_lff_min_gurantee
				  INTO v_con_n_fee_formula_number,
               l_con_n_lff_min_gurantee
				  FROM tbl_tva_contract
				 WHERE con_v_short_name = i_con_v_short_name;

        SELECT count(1)
				  INTO v_bo_cnt
          FROM  tbl_tva_boxoffice ttb,
                tbl_tva_contract ttc
          WHERE ttb.bo_n_contract_number = ttc.con_n_contract_number
            AND ttc.con_v_short_name = i_con_v_short_name;

				IF v_bo_cnt > 0 OR V_CON_N_FEE_FORMULA_NUMBER IN (1,2)
				THEN
         OPEN o_prog_info FOR
         SELECT ttb.bo_n_category,
                ttb.bo_v_sub_category,
                ttb.bo_n_min_guarantee,
                ttc.con_v_short_name,
                nvl(ttb.bo_lvr_applicable,'N') as bo_lvr_applicable,
                ttc.con_min_shelf_life_push bo_n_min_shelf_push,
                ttc.con_min_shelf_life_pull bo_n_min_shelf_pull
          FROM  tbl_tva_boxoffice ttb,
                tbl_tva_contract ttc
          WHERE ttb.bo_n_contract_number = ttc.con_n_contract_number
            AND ttc.con_v_short_name = i_con_v_short_name;

				 ELSIF v_bo_cnt = 0 AND v_con_n_fee_formula_number IN (3,4)
				 THEN
				       OPEN o_prog_info FOR
           		SELECT pc_pgm_category_code  bo_n_category,
							       sbo_bo_category_code    bo_v_sub_category,
										 nvl(l_con_n_lff_min_gurantee,0) bo_n_min_guarantee,
										 i_con_v_short_name con_v_short_name,
                     'N' bo_lvr_applicable,
                     NULL bo_n_min_shelf_push,
                     NULL bo_n_min_shelf_pull
		            FROM sgy_pb_pgm_category , sgy_pb_bo_category
			        ORDER BY 1,2;
				 END IF;
   END x_prc_get_prog_info;

  PROCEDURE x_prc_user_is_qa
  (
    i_company         IN      fid_company.com_short_name%TYPE,
    i_username        IN      men_user.usr_id%TYPE,
    i_licensee        IN      tvod_licensee.tvod_v_lee_short_name%TYPE,
    o_rights             OUT  VARCHAR2
  )
  AS
  BEGIN
    SELECT nvl(dmu_v_qa,'N')
      INTO o_rights
      FROM tbl_tva_dm_user
     WHERE upper(dmu_v_usr_id) = upper(i_username)
       AND dmu_n_lee_number IN (SELECT tvod_n_lee_number    -- Deal memo licensee
                                  FROM tvod_licensee
                                 WHERE upper(tvod_v_lee_short_name) = upper(i_licensee))
       AND dmu_n_com_number IN (SELECT com_number
                                  FROM fid_company
                                 WHERE upper(com_short_name) = upper(i_company));
  EXCEPTION
    WHEN no_data_found
    THEN o_rights := 'N';
  END x_prc_user_is_qa;

  PROCEDURE x_prc_get_default_territories
  (
    i_dm_number       IN      tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
    o_territory_data     OUT  c_cursor_tva_dealmemo
  )
  AS
  BEGIN
    OPEN o_territory_data FOR
    SELECT tl.tvod_v_lee_name lee_name,
           tl.tvod_v_lee_short_name lee_short_name,
           tt.n_ter_number ter_num,
           tt.v_ter_name ter_name,
           tt.v_ter_code ter_code,
           tt.v_ter_cur_code ter_cur_code
      FROM tbl_tva_territory tt,
           tvod_licensee tl ,
           x_tva_lee_ter_map tm
     WHERE tl.tvod_n_lee_number = tm.ltm_lee_number
       AND tt.n_ter_number = tm.ltm_ter_number
       AND tl.tvod_n_lee_number IN (SELECT DISTINCT
                                           dmad_n_lee_number
                                      FROM tbl_tva_dm_allocation_detail,
                                           tbl_tva_dm_prog
                                     WHERE dmprg_n_number = dmad_n_dmprg_number
                                       AND dmprg_n_dm_number = i_dm_number)
  ORDER BY lee_short_name,
           v_ter_code;
  END x_prc_get_default_territories;

  PROCEDURE x_prc_inst_lic_payplan
					   (
               I_LICPP_DM_NUMBER      IN     X_TVA_LIC_PAYMENT_PLAN.LICPP_DM_NUMBER%TYPE,
						   I_LICPP_LIC_NUMBER     IN     X_TVA_LIC_PAYMENT_PLAN.LICPP_LIC_NUMBER%TYPE,
						   I_LIC_START_DATE		  IN 	 TBL_TVA_LICENSE.LIC_DT_START_DATE%TYPE,
						   i_entry_oper			  IN	 X_TVA_LIC_PAYMENT_PLAN.LICPP_ENTRY_OPER%TYPE
					   )AS

V_LICPP_DUE_DATE DATE;
is_TBA    varchar2(1);
BEGIN

   select  NVL(LIC_C_TBA,'N')
     INTo is_TBA
   from tbl_tva_license
   where  lic_v_number = I_LICPP_LIC_NUMBER;

	 FOR i IN (
			   SELECT 	DMMGPAY_N_NUMBER,
						DMMGPAY_N_ORDER,
						DMMGPAY_N_PAY_PERCENT,
						DMMGPAY_V_PAY_CODE,
						DMMGPAY_N_PAY_AMOUNT,
						DMMGPAY_V_COMMENTS,
						DMMGPAY_N_DM_NUMBER,
						DMMGPAY_V_CURRENCY,
						NVL(DMMGPAY_N_NO_OF_DAYS,0) AS DMMGPAY_N_NO_OF_DAYS,
						DMMGPAY_N_PAY_RULE_NUMBER
			     FROM   TBL_TVA_DM_MG_PAYMENT
				WHERE   DMMGPAY_N_DM_NUMBER = I_LICPP_DM_NUMBER
			 ORDER BY   DMMGPAY_N_ORDER
			  )
	 LOOP

		IF NVL(is_TBA,'N') = 'N'
    THEN
      V_LICPP_DUE_DATE := I_LIC_START_DATE + i.DMMGPAY_N_NO_OF_DAYS;
    ELSE
       V_LICPP_DUE_DATE := to_date('31-dec-2199','DD-MON-RRRR');
    END IF;


			INSERT
			INTO X_TVA_LIC_PAYMENT_PLAN
			  (
				LICPP_NUMBER,
				LICPP_ORDER_NUMBER,
				LICPP_DM_NUMBER,
				LICPP_LIC_NUMBER,
				LICPP_PAY_CURRENCY,
				LICPP_PAYMENT_CODE,
				LICPP_DUE_DATE,
				LICPP_NO_OF_DAYS,
				LICPP_PAY_RULE_NUMBER,
				LICPP_PAY_AMOUNT,
				LICPP_PAY_PERCENT,
				LICPP_ENTRY_OPER,
				LICPP_ENTRY_DATE,
				LICPP_MODIFIED_BY,
				LICPP_MODIFIED_ON,
				LICPP_UPDATE_COUNT
			  )
			  VALUES
			  (
				x_seq_lic_pay_plan.NEXTVAL,
				i.DMMGPAY_N_ORDER,
				I_LICPP_DM_NUMBER,
				I_LICPP_LIC_NUMBER,
				i.DMMGPAY_V_CURRENCY,
				i.DMMGPAY_V_PAY_CODE,
				V_LICPP_DUE_DATE,
				i.DMMGPAY_N_NO_OF_DAYS,
				i.DMMGPAY_N_PAY_RULE_NUMBER,
				NULL,
				i.DMMGPAY_N_PAY_PERCENT,
				i_entry_oper,
				SYSDATE,
				i_entry_oper,
				SYSDATE,
				0
			  );
	END LOOP;

EXCEPTION
WHEN OTHERS
THEN
   raise_application_error
	  (-20601,SUBSTR (SQLERRM, 1, 200)|| ' In x_prc_inst_lic_payplan while insert into X_TVA_LIC_PAYMENT_PLAN');
END x_prc_inst_lic_payplan;

 PROCEDURE  x_prc_val_buy_price_allocation
                                                                          (
                                                                           i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE
                                                                          )AS
  v_err_code                  NUMBER:=-1;
  v_dm_prog_cnt           NUMBER;
  v_allocation_amt        NUMBER;
  v_total_amt             NUMBER;
  v_diff_amt              NUMBER;
  BEGIN
            FOR dm_prog_rec IN ( SELECT tdp.dmprg_n_gen_refno,
                                                                tdp.DMPRG_N_NUMBER,
                                                                tdp.dmprg_n_total_price,
                                                                tdp.dmprg_n_bo_category,
                                                                tdp.dmprg_v_sub_category,
                                                                tdm.dm_n_con_number,
                                                                (SELECT gen_title FROM fid_general WHERE gen_refno = DMPRG_N_GEN_REFNO) as gen_title
                                                    FROM tbl_tva_dm_prog tdp,
                                                                tbl_tva_deal_memo  tdm
                                                  WHERE tdm.dm_n_deal_memo_number = i_dm_n_deal_memo_number
                                                       AND tdm.dm_n_deal_memo_number = tdp.dmprg_n_dm_number
                                                       AND upper(tdm.dm_v_status) <> 'EXECUTED'
                                                       AND tdm.dm_n_type  = 1      /*Buy Price Deal*/

                            )
           LOOP
                v_allocation_amt:=0;

                      SELECT  count(1)
                        INTO  v_dm_prog_cnt
                        FROM  tbl_tva_license
                       WHERE  LIC_N_CON_NUMBER = dm_prog_rec.DM_N_CON_NUMBER
                         AND  LIC_N_GEN_REFNO = dm_prog_rec.DMPRG_N_GEN_REFNO
                         AND  LIC_V_STATUS ='A';


                        SELECT NVL(SUM(DMAD_N_AMOUNT),0)
                          INTO v_allocation_amt
                          FROM tbl_tva_dm_allocation_detail
                         WHERE DMAD_N_DMPRG_NUMBER = dm_prog_rec.DMPRG_N_NUMBER;

                          IF v_dm_prog_cnt >0
                          THEN
                               IF NVL(v_allocation_amt,0) <> 0
                               THEN
                               RAISE_APPLICATION_ERROR (-20001,'Error:MG Allocation for Title - '||dm_prog_rec.gen_title || ' must be zero. Licenses already exists with allocation in contract ');
                               END IF;

								FOR i IN (SELECT  LIC_N_BO_CATEGORY  ,
												  LIC_V_BO_SUB_CATEGORY
											FROM  tbl_tva_license
										   WHERE  LIC_N_CON_NUMBER = dm_prog_rec.DM_N_CON_NUMBER
											 AND  LIC_N_GEN_REFNO = dm_prog_rec.DMPRG_N_GEN_REFNO
											 AND  LIC_V_STATUS ='A'
								)
								LOOP
										IF  ( i.LIC_N_BO_CATEGORY   <>  dm_prog_rec.dmprg_n_bo_category
										OR i.LIC_V_BO_SUB_CATEGORY <> dm_prog_rec.dmprg_v_sub_category
										)
										THEN
										RAISE_APPLICATION_ERROR (-20001,'Program and BO cat for '||dm_prog_rec.gen_title || ' is '||i.LIC_N_BO_CATEGORY ||' and '||i.LIC_V_BO_SUB_CATEGORY ||' respectively under this contract.');
										END IF;
								END LOOP;

                          ELSIF
                               NVL(v_allocation_amt,0) <> nvl(dm_prog_rec.dmprg_n_total_price,0)
                          THEN
                               IF   NVL(v_allocation_amt,0) > nvl(dm_prog_rec.dmprg_n_total_price,0)
                               THEN
                                    v_diff_amt:= ABS(v_allocation_amt - nvl(dm_prog_rec.dmprg_n_total_price,0));
                                    RAISE_APPLICATION_ERROR (-20001,'MG Allocation is over allocated by - '||v_diff_amt );
                               ELSE
                                     v_diff_amt:= ABS( nvl(dm_prog_rec.dmprg_n_total_price,0)- v_allocation_amt);
                                    RAISE_APPLICATION_ERROR (-20001,'MG Allocation is under allocated by - '||v_diff_amt );
                               END IF;
                          END IF;

           END LOOP;

  END x_prc_val_buy_price_allocation;

   PROCEDURE  x_prc_val_lvr_date  (
                                                            i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE
                                                           )AS
  BEGIN

                FOR i  IN ( SELECT
                                                tdp.dmprg_n_bo_category,
                                                tdp.dmprg_v_sub_category,
                                                tdp.DMPRG_DT_LVR,
                                                NVL(ttb.BO_LVR_APPLICABLE,'N') as BO_LVR_APPLICABLE
                                    FROM tbl_tva_dm_prog tdp,
                                                tbl_tva_deal_memo  tdm,
                                                tbl_tva_boxoffice ttb
                                  WHERE tdm.dm_n_deal_memo_number = i_dm_n_deal_memo_number
                                       AND tdm.dm_n_deal_memo_number = tdp.dmprg_n_dm_number
                                       AND tdm.DM_N_CON_NUMBER = ttb.BO_N_CONTRACT_NUMBER
                                       AND  tdp.dmprg_n_bo_category = ttb.BO_N_CATEGORY
                                       AND  tdp.dmprg_v_sub_category = ttb.BO_V_SUB_CATEGORY
                                )
                LOOP

                          IF (i.BO_LVR_APPLICABLE = 'Y' AND  i.DMPRG_DT_LVR IS NULL)
                          THEN
                                      RAISE_APPLICATION_ERROR (-20001,'Error:LVR date is required for Program - '||i.dmprg_n_bo_category||' and Bo Category - '||i.dmprg_v_sub_category||' .' );
                          ELSIF
                                    (i.BO_LVR_APPLICABLE = 'N' AND  i.DMPRG_DT_LVR IS NOT NULL)
                          THEN
                                      RAISE_APPLICATION_ERROR (-20001,'Error:LVR date is not applicable for Program - '||i.dmprg_n_bo_category||' and Bo Category - '||i.dmprg_v_sub_category||' .' );
                          END IF;

                END LOOP;

  END x_prc_val_lvr_date;

PROCEDURE x_prc_get_dm_lee
                                                    (
                                                     i_dm_n_deal_memo_number   IN       tbl_tva_deal_memo.dm_n_deal_memo_number%TYPE,
                                                     o_licensee_data                       OUT   sys_refcursor
                                                    )AS
BEGIN
        OPEN o_licensee_data
         FOR
        SELECT  TVOD_N_LEE_NUMBER ,
                        TVOD_V_LEE_SHORT_NAME AS lee_short_name,
                        TVOD_V_LEE_NAME AS lee_name
          FROM    tvod_licensee tl
        WHERE    tl.tvod_n_lee_number IN (SELECT DISTINCT
                                                                                dmad_n_lee_number
                                                                    FROM tbl_tva_dm_allocation_detail,
                                                                                tbl_tva_dm_prog
                                                                  WHERE dmprg_n_number = dmad_n_dmprg_number
                                                                       AND dmprg_n_dm_number = i_dm_n_deal_memo_number);
END x_prc_get_dm_lee;

   PROCEDURE prc_tva_returnmediatypes (
      i_con_n_contract_number   IN       tbl_tva_contract.con_n_contract_number%TYPE,
      c_conmediatypes           OUT      pkg_tva_dealmemo.c_cursor_tva_dealmemo
   )
   AS
   BEGIN
      OPEN c_conmediatypes FOR
         SELECT n_con_medt_mapp_media_number
           FROM tbl_tva_con_medt_mapping
          WHERE n_con_medt_mapp_con_number = i_con_n_contract_number;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_tva_returnmediatypes;

END pkg_tva_dealmemo;
/