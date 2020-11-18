CREATE OR REPLACE PACKAGE PKG_ALIC_MN_MAGIC_LIC_COPIER
AS
   /******************************************************************************
      NAME:       pkg_alic_mn_magic_lic_copier
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        3/5/2010             1. Created this package.
      --These procedures need to called in update
      --prc_update_ledger;
      --prc_update_channel_runs;
      -- prc_update_license
      -- prc_update_payment_months
      --prc_update_history

   ******************************************************************************/
   TYPE c_lic_search_data IS REF CURSOR;

   TYPE c_lic_search_cha_alloc_data IS REF CURSOR;

   TYPE c_lic_search_territory_data IS REF CURSOR;

   -- Pure finance : Aditya Gupta
   TYPE c_cursor_alic_mn_mgc_lic_cpr IS REF CURSOR;

   TYPE c_cursor_lic_magic_copier is REF cursor;

   -- End
   PROCEDURE prc_licence_search (
      i_lic_number      IN     VARCHAR2,
      i_lic_gen_refno   IN     VARCHAR2,
      i_gen_title       IN     fid_general.gen_title%TYPE,
      o_lic_data           OUT pkg_alic_mn_magic_lic_copier.c_lic_search_data);

   PROCEDURE prc_licence_details_search (
      i_lic_number                   IN     VARCHAR2,
    --   i_lic_gen_refno     IN       VARCHAR2,
      o_lic_detail_data              OUT pkg_alic_mn_magic_lic_copier.c_lic_search_data,
      o_lic_cha_alloc_data           OUT pkg_alic_mn_magic_lic_copier.c_lic_search_cha_alloc_data,
      o_lic_territory_data           OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
            --:Cursor will bring the media device rights at license level
      o_lic_meddevplat_rights        OUT sys_refcursor,
      o_lic_medplatmdevcompat_dtls   OUT sys_refcursor,
      o_costed_prog_type             OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
      o_searchmediasermediaplat      OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
      o_media_service               out  pkg_alic_mn_magic_lic_copier.c_cursor_lic_magic_copier,
      --Dev.R1: CatchUp for All :[BR_15_272_UC_Super Stacking]_[Milan Shah]_[2016/01/04]: Start
      O_SUPERSTACK_RIGHTS              OUT SYS_REFCURSOR );
   --Dev.R1: CatchUp for All: End
   PROCEDURE prc_update_ledger (
      i_lic_number        IN     fid_license.lic_number%TYPE,
      i_lic_chs_number    IN     fid_license.lic_chs_number%TYPE,
      i_lic_lee_number    IN     fid_license.lic_lee_number%TYPE,
      i_lic_con_number    IN     fid_license.lic_con_number%TYPE,
      i_gen_ser_number    IN     fid_general.gen_ser_number%TYPE,
      i_terr_code         IN     fid_license_ledger.lil_ter_code%TYPE,
      i_contract_series   IN     VARCHAR2,
      i_terr_action       IN     VARCHAR2,
      i_lcp_rgh_code      IN     VARCHAR2,
      i_user_id           IN     VARCHAR2,
      -- i_lcp_ter_code      IN       VARCHAR2,
      i_flag              IN     NUMBER,
      o_status               OUT NUMBER);

   PROCEDURE prc_update_license (
      i_lic_number            IN     NUMBER,
      i_lic_lee_number        IN     NUMBER,
      i_lic_lee_number_new    IN     NUMBER,
      i_lic_chs_number        IN     NUMBER,
      i_lic_chs_number_new    IN     NUMBER,
      i_lic_con_number        IN     NUMBER,
      i_lic_con_number_new    IN     NUMBER,
      i_lic_gen_refno         IN     VARCHAR2,
      i_lic_price             IN     NUMBER,
      i_lic_markup_percent    IN     NUMBER,
      i_lic_start             IN     DATE,
      i_lic_end               IN     DATE,
      i_lic_period_tba        IN     VARCHAR2,
      -- Project Bioscope : Ajit_20120319 : Time Shift Flag added
      i_timeshiftchannel      IN     VARCHAR2,
      -- Project Bioscope : Ajit_20120319 : End
      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
      i_simulcastchannel      IN     VARCHAR2,
      /* PB (CR 12) :END */
      i_lic_currency          IN     VARCHAR2,
      -- i_lic_rate             IN       NUMBER,
      i_lic_showing_int       IN     NUMBER,
      i_lic_showing_lic       IN     NUMBER,
      i_lic_max_cha           IN     NUMBER,
      i_lic_max_chs           IN     NUMBER,
      i_lic_amort_code        IN     VARCHAR2,
      i_lic_budget_code       IN     VARCHAR2,
      i_contract_series       IN     VARCHAR2,
      i_entry_oper            IN     VARCHAR2,
      /* Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012 */
      i_max_vp_in_days        IN     fid_license.lic_max_viewing_period%TYPE,
      i_sch_aft_prem_linear   IN     fid_license.lic_sch_aft_prem_linear%TYPE,
      i_non_cons_month        IN     fid_license.lic_non_cons_month%TYPE,
      /* Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012 */

      -- Dev2: Non Costed Fillers: Start:[]_[ADITYA GUPTA]_[2013/3/15]
      -- [Modifications for incorporating Non-Costed Fillers changes]
      i_lic_free_rpt          IN     fid_license.lic_free_rpt%TYPE,
      i_lic_rpt_period        IN     fid_license.lic_rpt_period%TYPE,
      ---- Dev2: Non Costed Fillers: End
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : check for transfer_payment operation
      i_trnsfr_pmnt_flag      IN     VARCHAR2,
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : end
      o_count                    OUT NUMBER,
      o_status                   OUT NUMBER);


   PROCEDURE prc_calc_pay_month (i_split_region       IN     NUMBER,
                                 i_lic_start          IN     DATE,
                                 i_lic_end            IN     DATE,
                                 i_lic_period_tba     IN     VARCHAR2,
                                 i_lpy_pay_month_no   IN     NUMBER,
                                 o_lpy_pay_month         OUT DATE);

   PROCEDURE prc_update_payment_months (
      i_lic_number        IN     NUMBER,
      i_lic_lee_number    IN     NUMBER,
      i_lic_con_number    IN     NUMBER,
      i_lic_chs_number    IN     NUMBER,
      i_lic_gen_refno     IN     VARCHAR2,
      i_gen_ser_number    IN     fid_general.gen_ser_number%TYPE,
      i_lic_start         IN     DATE,
      i_lic_end           IN     DATE,
      i_contract_series   IN     VARCHAR2,
      i_entry_oper        IN     VARCHAR2,
      o_status               OUT NUMBER);

   PROCEDURE prc_update_channel_runs (
      i_lic_number             IN     NUMBER,
      i_lic_lee_number         IN     NUMBER,
      i_lic_con_number         IN     NUMBER,
      i_lic_chs_number         IN     NUMBER,
      i_ccp_cha_number         IN     NUMBER,
      i_lic_gen_refno          IN     VARCHAR2,
      i_gen_ser_number         IN     fid_general.gen_ser_number%TYPE,
      i_contract_series        IN     VARCHAR2,
      i_cha_action             IN     VARCHAR2,
      i_ccp_cost_ind           IN     VARCHAR2,
      i_ccp_runs_allocated     IN     NUMBER,
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 :license start to check with go live
      i_lic_start              IN     DATE,
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : End
      --PB CR 61 Mangesh 20121102:Max cha added
      i_ccp_max_cha_number     IN     NUMBER,
      --PB CR END
      -- Project Bioscope : Ajit_20120319 : Costed Runs added
      i_runsallocatedcosted    IN     NUMBER,
      -- Project Bioscope : Ajit_20120319 : End
      -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
      i_runsallocatedcosted2   IN     NUMBER,
      -- Project Bioscope CR 47 : Mangesh_20121122 : End
      i_user_id                IN     VARCHAR2,
      i_flag                   IN     NUMBER,
      o_status                    OUT NUMBER);

   PROCEDURE prc_update_history (i_lic_number        IN     NUMBER,
                                 i_lic_lee_number    IN     NUMBER,
                                 i_lic_con_number    IN     NUMBER,
                                 i_lic_chs_number    IN     NUMBER,
                                 i_lic_gen_refno     IN     VARCHAR2,
                                 i_gen_ser_number    IN     NUMBER,
                                 i_histflag          IN     VARCHAR2,
                                 i_contract_series   IN     VARCHAR2,
                                 i_user_id           IN     VARCHAR2,
                                 o_status               OUT NUMBER);

   PROCEDURE prc_populate_lic_lil (i_lic_number   IN NUMBER,
                                   i_user_id      IN VARCHAR2);

   PROCEDURE prc_populate_lic_lcr (i_lic_number   IN NUMBER,
                                   i_user_id      IN VARCHAR2);

   PROCEDURE prc_populate_new_lil (i_lic_number           IN     NUMBER,
                                   i_lic_chs_number       IN     NUMBER,
                                   i_nbt_default_rights   IN     VARCHAR2,
                                   i_lic_price            IN     NUMBER,
                                   i_lic_price_code       IN     VARCHAR2,
                                   o_lcp_lic_number          OUT NUMBER,
                                   o_lcp_ter_code            OUT VARCHAR2,
                                   o_lcp_rgh_code            OUT VARCHAR2,
                                   o_lcp_price_code          OUT VARCHAR2,
                                   o_lcp_price               OUT NUMBER,
                                   o_lcp_adjust_factor       OUT NUMBER,
                                   o_lcp_con_forecast        OUT NUMBER,
                                   o_lcp_loc_forecast        OUT NUMBER,
                                   o_lcp_con_calc            OUT NUMBER,
                                   o_lcp_loc_calc            OUT NUMBER,
                                   o_lcp_con_actual          OUT NUMBER,
                                   o_lcp_loc_actual          OUT NUMBER,
                                   o_lcp_con_adjust          OUT NUMBER,
                                   o_lcp_loc_adjust          OUT NUMBER,
                                   o_lcp_comment             OUT VARCHAR2,
                                   o_message                 OUT VARCHAR2);

   PROCEDURE prc_delete_lic_cha_runs_copier (i_lic_number       IN NUMBER,
                                             i_ccp_cha_number   IN NUMBER);

   PROCEDURE prc_insert_lic_cha_runs_copier (
      i_lic_number           IN NUMBER,
      i_ccp_cha_number       IN NUMBER,
      i_ccp_cost_ind         IN VARCHAR2,
      i_ccp_runs_allocated   IN NUMBER,
      -- Project Bioscope Added below parameter by Anirudha 21/03/2012
      i_ccp_costed_runs      IN NUMBER,
      --PB CR 61 Mangesh 20121102:Max cha added
      /* i_ccp_max_cha_number   IN   NUMBER,
       --PB CR END
       i_ccp_costed_runs2     IN   NUMBER,*/
      i_user_id              IN VARCHAR2);

   PROCEDURE prc_delete_lic_ledger_copier (i_lic_number     IN NUMBER,
                                           i_lcp_ter_code   IN VARCHAR2,
                                           i_lcp_rgh_code   IN VARCHAR2);

   PROCEDURE prc_insert_lic_ledger_copier (i_lic_number     IN NUMBER,
                                           i_lcp_ter_code   IN VARCHAR2,
                                           i_lcp_rgh_code   IN VARCHAR2,
                                           i_user_id        IN VARCHAR2);

   PROCEDURE prc_update_media_ser_plat (
      i_lic_number           IN     fid_license.lic_number%TYPE,
      i_lmps_mapp_id         IN     sgy_pb_lic_med_plat_service.lmps_mapp_id%TYPE,
      i_contract_series      IN     CHAR,
      i_insert_delete_flag   IN     CHAR,
      i_lic_con_number       IN     fid_license.lic_con_number%TYPE,
      i_entry_oper           IN     sgy_pb_lic_med_plat_service.lmps_entry_oper%TYPE,
      o_status                  OUT NUMBER);

   PROCEDURE prc_alic_cm_validatestartdate (
      i_licnumber   IN fid_license.lic_number%TYPE,
      i_licstart    IN fid_license.lic_start%TYPE);

   PROCEDURE prc_alic_cm_validateenddate (
      i_licnumber   IN fid_license.lic_number%TYPE,
      i_licend      IN fid_license.lic_end%TYPE);

   /* Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012 */

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

   /* Catchup CACQ11 : END */

   -- Dev2: pure Finance: Start:[Magic License Copier]_[ADITYA GUPTA]_[2013/3/16]
   -- [Magic License Copier Search Screen modifications for incorporating changes in Sec Licensees]
   PROCEDURE prc_search_lee_allocation (
      i_lic_number   IN     x_fin_lic_sec_lee.lsl_lic_number%TYPE,
      o_sec_lee         OUT pkg_alic_mn_magic_lic_copier.c_cursor_alic_mn_mgc_lic_cpr);

   PROCEDURE prc_populate_sec_lee_copier (i_lic_number   IN NUMBER,
                                          i_user_id      IN VARCHAR2);

   PROCEDURE prc_updt_chnl_runs_sec_lee (
      i_lsl_number           IN     NUMBER,
      i_lic_number           IN     NUMBER,
      i_lic_lee_number       IN     NUMBER,
      i_lic_sec_lee_number   IN     NUMBER,
      i_lic_sec_lee_price    IN     NUMBER,
      i_lic_con_number       IN     NUMBER,
      i_lic_chs_number       IN     NUMBER,
      i_gen_ser_number       IN     fid_general.gen_ser_number%TYPE,
      i_contract_series      IN     VARCHAR2,
      i_cha_action           IN     VARCHAR2,
      i_user_id              IN     VARCHAR2,
      o_status                  OUT x_fin_lic_sec_lee.lsl_update_count%TYPE);

   -- Dev2: Pure Finance: Start
   PROCEDURE X_prc_trf_pay_series_search (
      i_con_number          IN     fid_contract.con_number%TYPE,
      i_lic_number          IN     fid_license.lic_number%TYPE,
      i_gen_refno           IN     FID_GENERAL.GEN_REFNO%TYPE,
      i_licensee            IN     FID_LICENSEE.LEE_NUMBER%TYPE,
      i_catch_up_flag       IN     FID_LICENSE.LIC_CATCHUP_FLAG%TYPE,
      o_src_series_search      OUT SYS_REFCURSOR,
      o_dst_series_search      OUT SYS_REFCURSOR);

   PROCEDURE x_prc_process_trf_payment (
      i_src_lic_no      IN     fid_license.lic_number%TYPE,
      i_src_licensee    IN     fid_licensee.lee_number%TYPE,
      i_dst_licensee    IN     fid_licensee.lee_number%TYPE,
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_con_no          IN     fid_contract.con_number%TYPE,
      i_entry_oper      IN     fid_payment.pay_entry_oper%TYPE,
      I_PAY_COMMENT     IN     FID_PAYMENT.PAY_COMMENT%TYPE,
      i_catch_up_flag   IN     FID_LICENSE.LIC_CATCHUP_FLAG%TYPE,
      o_success_flag       OUT NUMBER);

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

   PROCEDURE x_prc_process_trf_pmnt_compl (
      i_src_lic_no      IN     fid_license.lic_number%TYPE,
      i_src_licensee    IN     fid_licensee.lee_number%TYPE,
      i_dst_licensee    IN     fid_licensee.lee_number%TYPE,
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_con_no          IN     fid_contract.con_number%TYPE,
      i_entry_oper      IN     fid_payment.pay_entry_oper%TYPE,
      I_PAY_COMMENT     IN     FID_PAYMENT.PAY_COMMENT%TYPE,
      i_catch_up_flag   IN     FID_LICENSE.LIC_CATCHUP_FLAG%TYPE,
      o_success_flag       OUT NUMBER);

   --CATCHUP:CACQ14: Start_[SHANTANU A.]_14-nov-2014
   --Following procedure will copy the med device rights to the other licenses of same contract no.

   PROCEDURE x_prc_cp_cpymedrght_mgclic_cpr (
      i_src_lic_number       IN     fid_license.lic_number%TYPE,
      i_MPDC_DEV_PLATM_ID    IN     x_cp_lic_medplatmdevcompat_map.lic_mpdc_dev_platm_id%TYPE,
      i_rights_on_device     IN     VARCHAR2,
      i_med_comp_rights      IN     VARCHAR2,
      i_med_IS_COMP_RIGHTS   IN     VARCHAR2,
      i_contract_series      IN     VARCHAR2,
      i_entry_oper           IN     VARCHAR2,
      o_status                  OUT NUMBER);
--CATCHUP_[END]
   PROCEDURE X_PRC_CHECK_LIC_IS_CANCLE (
                                      I_CONTRACT_SERIES IN VARCHAR2,
                                      I_CON_NUMBER      IN NUMBER,
                                      I_LEE_NUMBER      IN NUMBER,
                                      I_GEN_REFNO       IN NUMBER,
                                      O_STATUS          OUT VARCHAR2
                                      );
-- PROCEDURE prc_update_license_two (
--      i_lic_number            IN     NUMBER,
--      i_lic_lee_number        IN     NUMBER,
--      i_lic_lee_number_new    IN     NUMBER,
--      i_lic_chs_number        IN     NUMBER,
--      i_lic_chs_number_new    IN     NUMBER,
--      i_lic_con_number        IN     NUMBER,
--      i_lic_con_number_new    IN     NUMBER,
--      i_lic_gen_refno         IN     VARCHAR2,
--      i_lic_price             IN     NUMBER,
--      i_lic_markup_percent    IN     NUMBER,
--      i_lic_start             IN     DATE,
--      i_lic_end               IN     DATE,
--      i_lic_period_tba        IN     VARCHAR2,
--      -- Project Bioscope : Ajit_20120319 : Time Shift Flag added
--      i_timeshiftchannel      IN     VARCHAR2,
--      -- Project Bioscope : Ajit_20120319 : End
--      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
--      i_simulcastchannel      IN     VARCHAR2,
--      /* PB (CR 12) :END */
--      i_lic_currency          IN     VARCHAR2,
--      -- i_lic_rate             IN       NUMBER,
--      i_lic_showing_int       IN     NUMBER,
--      i_lic_showing_lic       IN     NUMBER,
--      i_lic_max_cha           IN     NUMBER,
--      i_lic_max_chs           IN     NUMBER,
--      i_lic_amort_code        IN     VARCHAR2,
--      i_lic_budget_code       IN     VARCHAR2,
--      i_contract_series       IN     VARCHAR2,
--      i_entry_oper            IN     VARCHAR2,
--      /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
--      i_max_vp_in_days        IN     fid_license.lic_max_viewing_period%TYPE,
--      i_sch_aft_prem_linear   IN     fid_license.lic_sch_aft_prem_linear%TYPE,
--      i_non_cons_month        IN     fid_license.lic_non_cons_month%TYPE,
--      /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
--
--      -- Dev2: Non Costed Fillers: Start:[]_[ADITYA GUPTA]_[2013/3/15]
--      -- [Modifications for incorporating Non-Costed Fillers changes]
--      i_lic_free_rpt          IN     fid_license.lic_free_rpt%TYPE,
--      i_lic_rpt_period        IN     fid_license.lic_rpt_period%TYPE,
--      ---- Dev2: Non Costed Fillers: End
--      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : check for transfer_payment operation
--      i_trnsfr_pmnt_flag      IN     VARCHAR2,
--      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : end
--      o_count                    OUT NUMBER,
--      o_status                   OUT NUMBER);

END pkg_alic_mn_magic_lic_copier;
/
CREATE OR REPLACE PACKAGE BODY PKG_ALIC_MN_MAGIC_LIC_COPIER
AS
   /******************************************************************************
      NAME:       pkg_alic_mn_magic_lic_copier
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        3/5/2010             1. Created this package.
   ******************************************************************************/
   PROCEDURE prc_licence_search (
      i_lic_number      IN     VARCHAR2,
      i_lic_gen_refno   IN     VARCHAR2,
      i_gen_title       IN     fid_general.gen_title%TYPE,
      o_lic_data           OUT pkg_alic_mn_magic_lic_copier.c_lic_search_data)
   AS
      l_query_string   VARCHAR2 (4000);
   BEGIN
      l_query_string :=
         'SELECT lic_number, lic_gen_refno, a.gen_title, a.gen_ser_number, epicount,
       lee_short_name,con_short_name, chs_short_name, cha_short_name ,LIC_CATCHUP_FLAG,
       con_name,

       lic_update_count
  FROM (SELECT lic_number, lic_gen_refno, fg.gen_title, fg.gen_ser_number,
               lee_short_name, con_short_name, (SELECT chs_short_name FROM fid_channel_service WHERE chs_number = lic_chs_number)chs_short_name,
               (SELECT cha_short_name FROM fid_channel WHERE cha_number =(select CHS_CHA_NUMBER from fid_channel_service where chs_number= lic_chs_number))  cha_short_name, con_name,

               -- Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012
             NVL(LIC_CATCHUP_FLAG,''N'')LIC_CATCHUP_FLAG,
               lic_update_count
          FROM fid_license,
               fid_general fg,
               fid_licensee,
               fid_contract

         WHERE lic_gen_refno = fg.gen_refno
           AND con_number = lic_con_number

      ---- Dev2: Non Costed Fillers: Start:[Magic License Copier]_[ADITYA GUPTA]_[2013/3/15]
      ---- [Magic License Copier Search Screen modifications for incorporating Non-Costed Fillers changes]

AND lee_number(+) = lic_lee_number and LIC_STATUS not in (''I'',''F'',''T'',''C'') )

           ---- Dev2: Non Costed Fillers: End
           ---- CP R1 Mrunmayi Kusurkar


               --    AND NVL(lic_catchup_flag,''N'') = ''N''
                 -- END
       /* UNION
        SELECT lic_number, lic_gen_refno, fg.gen_title, fg.gen_ser_number,
               lee_short_name, con_short_name, '''' chs_short_name,
               (SELECT cha_short_name FROM fid_channel WHERE cha_number = lic_chs_number)cha_short_name, con_name,
               -- Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012
             NVL(LIC_CATCHUP_FLAG,''N'')LIC_CATCHUP_FLAG,
               lic_update_count

          FROM fid_license,
               fid_general fg,
               fid_licensee,
               fid_contract

         WHERE lic_gen_refno = fg.gen_refno
           AND con_number = lic_con_number

            ---- CP R1 Mrunmayi Kusurkar
      -- AND NVL(lic_catchup_flag,''N'') = ''N''
         -- END
           AND lee_number = lic_lee_number and LIC_STATUS<>''I'') */ a left join
       (SELECT   gen_ser_number, COUNT (*) epicount
            FROM fid_general
        GROUP BY gen_ser_number) b
 on b.gen_ser_number = a.gen_ser_number   where rownum<500
';

      IF i_lic_number IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and lic_number like '''
            || i_lic_number
            || '''';
      END IF;

      IF i_lic_gen_refno IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and lic_gen_refno like '''
            || i_lic_gen_refno
            || '''';
      END IF;

      IF i_gen_title IS NOT NULL
      THEN
         l_query_string :=
               l_query_string
            || ' and gen_title like '''
            || UPPER (i_gen_title)
            || '''';
      END IF;

      --DBMS_OUTPUT.put_line (l_query_string);

      OPEN o_lic_data FOR l_query_string;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_licence_search;

   PROCEDURE prc_licence_details_search (
      i_lic_number                   IN     VARCHAR2,
     -- i_lic_gen_refno     IN       VARCHAR2,
      o_lic_detail_data                 OUT pkg_alic_mn_magic_lic_copier.c_lic_search_data,
      o_lic_cha_alloc_data              OUT pkg_alic_mn_magic_lic_copier.c_lic_search_cha_alloc_data,
      o_lic_territory_data              OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
      --:Cursor will bring the media device rights at license level
      o_lic_meddevplat_rights           OUT SYS_REFCURSOR,
      o_lic_medplatmdevcompat_dtls      OUT SYS_REFCURSOR,
      o_costed_prog_type                OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
      o_searchmediasermediaplat         OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
      o_media_service                   OUT pkg_alic_mn_magic_lic_copier.c_cursor_lic_magic_copier,
      --Dev.R1: CatchUp for All :[BR_15_272_UC_Super Stacking]_[Milan Shah]_[2016/01/04]: Start
      O_SUPERSTACK_RIGHTS              OUT SYS_REFCURSOR)
      --Dev.R1: CatchUp for All: End
   AS
      --CATCHUP : CACQ14: [SHANTANU A.]_[14-nov-2014]

      l_con_count           NUMBER;
      l_lic_count           NUMBER;
      l_con_number          NUMBER;
      l_lic_fea_ser         VARCHAR2 (5);
      l_string              CLOB;
      l_string1             CLOB;
      l_string2             CLOB;
      l_string3             CLOB;
      l_string4             CLOB;
      l_string5             CLOB;
      l_catchup_live_date   DATE;
      l_on_plylist          VARCHAR2 (1) := 'N';
      l_plt_count           NUMBER;
      l_catchup_flag        VARCHAR2 (10);
   --CATCHUP: [END]

   BEGIN
      -- DBMS_OUTPUT.ENABLE (100000);

      SELECT lic_con_number,
             (SELECT s.ms_media_service_code /*Swapnil: 09-jun-2015 for SVOD*/
                FROM sgy_pb_media_service s
               WHERE s.ms_media_service_flag = NVL (lic_catchup_flag, 'N'))
        INTO l_con_number, l_catchup_flag
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT COUNT (*)
        INTO l_con_count
        FROM x_cp_con_medplatmdevcompat_map
       WHERE CON_CONTRACT_NUMBER = l_con_number;

      SELECT COUNT (1)
        INTO l_lic_count
        FROM x_cp_lic_medplatmdevcompat_map
       WHERE LIC_MPDC_LIC_NUMBER = i_lic_number;

      SELECT TO_DATE (content)
        INTO l_catchup_live_date
        FROM x_fin_configs
       WHERE KEY = 'CATCH-UP_LIVE_DATE';       /*Swapnil Will need to change*/

      SELECT lic_budget_code
        INTO l_lic_fea_ser
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT COUNT (*)
        INTO l_plt_count
        FROM x_cp_play_list
       WHERE     plt_lic_number = i_lic_number
             AND PLT_SCH_START_DATE < TRUNC (l_catchup_live_date, 'MON')
             AND NOT EXISTS
                    (SELECT 1
                       FROM x_cp_lic_medplatmdevcompat_map
                      WHERE lic_mpdc_lic_number = plt_lic_number); --ver 1.1 Added

      IF l_plt_count > 0
      THEN
         l_on_plylist := 'Y';
      END IF;


      OPEN o_lic_detail_data FOR
         SELECT lic_number,
                lic_gen_refno,
                a.gen_title,
                NVL (a.gen_ser_number, 0) gen_ser_number,
                NVL (epicount, 0) epicount,
                lee_short_name,
                chs_short_name,
                cha_short_name,
                con_short_name,
                con_name,
                lic_chs_number,
                lic_currency,
                ROUND (lic_price, 4) lic_price,
                lic_markup_percent,
                lic_start,
                lic_end,
                lic_period_tba,
                lic_budget_code,
                lic_amort_code,
                NVL (lic_showing_int, 0) exh_days,
                NVL (lic_showing_lic, 0) amort_exh,
                lic_max_chs,
                /* PB(CR 61):Mangesh 20121023:Allowed Null for lic_max_cha*/
                lic_max_cha lic_max_cha,
                /*PB(CR 61) end*/
                NVL (lic_update_count, 0) lic_update_count,
                lic_con_number,
                lic_lee_number,
                --,lic_rate
                -- Project Bioscope : Ajit_20120314 : Premier flag, Time Shift flag added
                lic_time_shift_cha_flag,
                /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
                lic_simulcast_cha_flag,
                /* PB (CR 12) :END */
                lic_premium_flag,
                lic_type,
                costed_gen_type_flag /* PB (CR 6) :Pranay Kusumwal 18/07/2012 : Added for calculating the budgeting status of license */
                                    ,
                lic_status           -- Project Bioscope : Ajit_20120314 : End
                          /* Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012 */
                ,
                lic_non_cons_month,
                lic_sch_aft_prem_linear,
                lic_catchup_flag,
                lic_max_viewing_period,
                lic_free_rpt,
                lic_rpt_period           /* Catchup CACQ11 : END 21/03/2012 */
                              ,
                x_fun_is_primary (lic_number) is_secondary_flag,
                l_on_plylist l_on_plylist,
                (SELECT com_name
                   FROM fid_Company
                  WHERE com_number = con_com_number)
                   SUPPLIER,
                CON_SCH_AFTER_PREM_LINR, --CATCHUP:CACQ14:Added by SHANTANU A._06/01/2015
                --Finance Dev Phase I Zeshan [Start]
                (SELECT TO_DATE (fim_year || fim_month, 'YYYYMM')
                  FROM fid_financial_month, fid_licensee
                 WHERE fim_split_region = lee_split_region
                       AND fim_status = 'O'
                       AND lee_number = (SELECT lic_lee_number
                                           FROM fid_license
                                          WHERE lic_number = i_lic_number)) OPEN_MONTH
                --Finance Dev Phase I [End]
           FROM    (SELECT lic_number,
                           lic_gen_refno,
                           fg.gen_title,
                           fg.gen_ser_number,
                           lee_short_name,
                           con_short_name,
                           (SELECT chs_short_name
                              FROM fid_channel_service
                             WHERE chs_number = lic_chs_number)
                              chs_short_name,
                           (SELECT cha_short_name
                              FROM fid_channel
                             WHERE cha_number =
                                      (SELECT chs_cha_number
                                         FROM fid_channel_service
                                        WHERE chs_number = lic_chs_number))
                              cha_short_name,
                           con_name,
                           lic_chs_number,
                           lic_currency,
                           lic_price,
                           lic_markup_percent,
                           lic_start,
                           lic_end,
                           lic_period_tba,
                           lic_budget_code,
                           lic_amort_code,
                           lic_showing_int,
                           lic_showing_lic,
                           lic_max_chs,
                           lic_max_cha,
                           lic_update_count,
                           lic_con_number,
                           lic_lee_number,
                           --,lic_rate
                           -- Project Bioscope : Ajit_20120314 : Premier flag, Time Shift flag added
                           lic_time_shift_cha_flag,
                           /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
                           lic_simulcast_cha_flag,
                           /* PB (CR 12) :END */
                           lic_premium_flag,
                           lic_type,
                           NVL ( (SELECT 'Y'
                                    FROM sgy_pb_costed_prog_type
                                   WHERE cpt_gen_type = fg.gen_type),
                                'N')
                              costed_gen_type_flag /* PB (CR 6) :Pranay Kusumwal 18/07/2012 : Added for calculating the budgeting status of license */
                                                  ,
                           lic_status,
                           /* Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012 */
                           NVL (lic_catchup_flag, 'N') lic_catchup_flag,
                           lic_max_viewing_period,
                           NVL (lic_sch_aft_prem_linear, 'N')
                              lic_sch_aft_prem_linear,
                           lic_non_cons_month,
                           lic_free_rpt,
                           lic_rpt_period /* Catchup CACQ11 : END 21/03/2012 */
                                         -- Project Bioscope : Ajit_20120314 : End
                           ,
                           con_com_number,
                           --CATCHUP:CACQ14:Added by SHANTANU A._06/01/2015_start
                           DECODE (
                              X_FNC_GET_PROG_TYPE (l_lic_fea_ser),
                              'Y', (SELECT NVL (CON_SCH_AFTER_PREM_LINR_SER,
                                                'N')
                                      FROM fid_contract
                                     WHERE con_number = l_con_number),
                              (SELECT NVL (CON_SCH_AFTER_PREM_LINR_FEA, 'N')
                                 FROM fid_contract
                                WHERE con_number = l_con_number))
                              "CON_SCH_AFTER_PREM_LINR"
                      --CATCHUP_END
                      FROM fid_license,
                           fid_general fg,
                           fid_licensee,
                           fid_contract
                     WHERE     lic_gen_refno = fg.gen_refno
                           AND con_number = lic_con_number
                           -- AND chs_number = lic_chs_number
                           AND lee_number(+) = lic_lee_number --and  lic_number = i_lic_number
                                                             /* Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012 */
                                                             --  commenting the union clause as it messes up the data because of chs_number
                                                             -- instead adding the subquery inside a single select statement
                                                             /*  UNION
                                                               SELECT lic_number, lic_gen_refno, fg.gen_title,
                                                                      fg.gen_ser_number, lee_short_name, con_short_name,
                                                                      '' chs_short_name,
                                                                      (SELECT cha_short_name FROM fid_channel WHERE cha_number =(select CHS_CHA_NUMBER from fid_channel_service where chs_number= lic_chs_number))cha_short_name, con_name,
                                                                      lic_chs_number, lic_currency, lic_price,
                                                                      lic_markup_percent, lic_start, lic_end,
                                                                      lic_period_tba, lic_budget_code, lic_amort_code,
                                                                      lic_showing_int, lic_showing_lic, lic_max_chs,
                                                                      lic_max_cha, lic_update_count, lic_con_number,
                                                                      lic_lee_number,
                                                                      --,lic_rate
                                                                      -- Project Bioscope : Ajit_20120314 : Premier flag, Time Shift flag added
                                                                      LIC_TIME_SHIFT_CHA_FLAG,
                                                                      --PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality
                                                                      lic_simulcast_cha_flag,
                                                                       -- PB (CR 12) :END
                                                                      LIC_PREMIUM_FLAG,
                                                                      lic_type,
                                                                      nvl(( select 'Y'
                                                                      from     sgy_pb_costed_prog_type
                                                                      where cpt_gen_type =  fg.gen_type
                                                                      ),'N') costed_gen_type_flag
                                                                      -- Project Bioscope : Ajit_20120314 : End
                                                                      --PB (CR 6) :Pranay Kusumwal 18/07/2012 : Added for calculating the budgeting status of license
                                                                      ,LIC_STATUS,
                                                                      -- Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012
                                                                      NVL(LIC_CATCHUP_FLAG,'N')LIC_CATCHUP_FLAG
                                                                      ,LIC_MAX_VIEWING_PERIOD
                                                                      ,NVL(LIC_SCH_AFT_PREM_LINEAR,'N')LIC_SCH_AFT_PREM_LINEAR
                                                                      ,NVL(LIC_NON_CONS_MONTH,'N')LIC_NON_CONS_MONTH
                                                                      -- Catchup CACQ11 : END 21/03/2012
                                                                  FROM fid_license,
                                                                  fid_general fg,
                                                                  fid_licensee,
                                                                  fid_contract
                                                                  WHERE lic_gen_refno = fg.gen_refno
                                                                  AND con_number = lic_con_number
                                                                  -- AND cha_number = lic_chs_number
                                                                  AND lee_number(+) = lic_lee_number
                                                                  --AND lic_number = i_lic_number
                                                              */
                   ) a
                LEFT JOIN
                   (  SELECT gen_ser_number, COUNT (*) epicount
                        FROM fid_general
                    GROUP BY gen_ser_number) b
                ON b.gen_ser_number = a.gen_ser_number
          WHERE lic_number = i_lic_number;

      OPEN o_lic_cha_alloc_data FOR
         SELECT lcr_cha_number,
                cha_short_name,
                lcr_runs_allocated,
                lcr_cost_ind,
                lcr_update_count,
                /* PB (CR 16) :Pranay Kusumwal 06/07/2012 : Added for new MAX CHA column functionality */
                lcr_max_runs_cha,
                ( (SELECT COUNT (sch_number)
                     FROM fid_schedule
                    WHERE     sch_type = 'P'
                          AND sch_lic_number = lcr_lic_number
                          AND sch_cha_number = lcr_cha_number
                          AND sch_date BETWEEN lcr_sch_start_date
                                           AND lcr_sch_end_date
                          AND sch_date <=
                                 (SELECT LAST_DAY (
                                            MAX (
                                               TO_DATE (
                                                  fim_year || fim_month,
                                                  'YYYYMM')))
                                    FROM fid_financial_month
                                   WHERE fim_status = 'C'))
                 + (SELECT COUNT (sch_number)
                      FROM fid_schedule
                     WHERE     sch_type = 'P'
                           AND sch_lic_number = lcr_lic_number
                           AND sch_cha_number = lcr_cha_number
                           AND sch_date BETWEEN lcr_sch_start_date2
                                            AND lcr_sch_end_date2
                           AND sch_date <=
                                  (SELECT LAST_DAY (
                                             MAX (
                                                TO_DATE (
                                                   fim_year || fim_month,
                                                   'YYYYMM')))
                                     FROM fid_financial_month
                                    WHERE fim_status = 'C')))
                   total_costed_used_runs,
                (NVL (flcrc.lcr_cha_costed_runs, 0)
                 + NVL (flcrc.lcr_cha_costed_runs2, 0))
                   total_costed_runs,
                --PB_CR_47:mangesh_22-11-2012:added columns for  bioscope and african rule
                flcrc.lcr_cha_costed_runs,
                flcrc.lcr_cha_costed_runs2,
                --PB_CR 47 End
                fc.cha_roy_flag
           FROM fid_license, fid_channel fc, fid_license_channel_runs flcrc
          WHERE     lcr_cha_number = cha_number
                AND flcrc.lcr_lic_number(+) = lic_number
                AND lic_number = i_lic_number;

      OPEN o_lic_territory_data FOR
         SELECT lil_ter_code,
                lil_rgh_code,
                INITCAP (cod_description) cod_description,
                lil_update_count
           FROM fid_license, fid_license_ledger fllc, fid_code
          WHERE     fllc.lil_lic_number(+) = lic_number
                AND cod_value = lil_rgh_code
                AND cod_type = 'LIC_RGH_CODE'
                AND lic_number = i_lic_number
				ORDER BY lil_ter_code ASC
				;

      -- Project Bioscope  Anirudha   New Cursor for Media Service, Media Platform


      OPEN o_costed_prog_type FOR
         SELECT cpt_gen_type FROM sgy_pb_costed_prog_type;



      -- Project Bioscope  End

      --CATCHUP : CACQ14: [SHANTANU A.]_[14-nov-2014]
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
            || ''' "ServiceCode",--LIC_MPDC_SERVICE_CODE,
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
            || ''' CON_MPDC_SERVICE_CODE,''N'' med_device_sch_flag
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
                                    a.CON_MPDC_SERVICE_CODE "ServiceCode", --"LIC_MPDC_SERVICE_CODE"
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
            and CON_IS_FEA_SER = ''SER'' and CON_CONTRACT_NUMBER = '''
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
                                                   (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                                   (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                                    MDP_MAP_PLATM_CODE med_platm_code,
                                                    (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                                     CON_RIGHTS_ON_DEVICE
                                                    ,CON_MPDC_DEV_PLATM_ID
                                                    ,0 CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE,
                                                    (case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              and   lic_catchup_flag = ''Y''
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
                                                   (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                                   (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                                    MDP_MAP_PLATM_CODE med_platm_code,
                                                    (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                                    ''N'' RIGHTS_ON_DEVICE
                                                    ,MPDC_DEV_PLATM_ID
                                                    ,0 MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,'''
                  || l_catchup_flag
                  || ''' CON_MPDC_SERVICE_CODE,''N'' med_device_sch_flag
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

                                                            MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID order by MDP_MAP_DEV_ID

                                                         )a');
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
                                    a.CON_MPDC_SERVICE_CODE "ServiceCode",--"LIC_MPDC_SERVICE_CODE"
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
                                                   (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
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
                                                              and   lic_catchup_flag = ''Y''
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
                                                   (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                                   (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                                    MDP_MAP_PLATM_CODE med_platm_code,
                                                    (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                                    ''N'' RIGHTS_ON_DEVICE
                                                    ,MPDC_DEV_PLATM_ID
                                                    ,0 MPDC_UPDATE_COUNT,0 LIC_MPDC_LIC_NUMBER,''CATCHUP'' CON_MPDC_SERVICE_CODE,''N'' med_device_sch_flag
                                                  from   x_cp_med_platm_dev_compat_map,x_cp_media_dev_platm_map ,x_cp_medplatdevcomp_servc_map
                                                        where MPDC_DEV_PLATM_ID = MDP_MAP_ID
                                                         and   MPDCS_MPDC_ID  =  MPDC_ID
                                                        and MPDCS_MED_SERVICE_CODE = '''
                  || l_catchup_flag
                  || '''
                                                        and MDP_MAP_DEV_ID = '''
                  || contract.md_id
                  || '''
                                                   group by MDP_MAP_DEV_ID,
                                                            MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                            order by MDP_MAP_DEV_ID
                                                         )a');
            END LOOP;
         END IF;
      END IF;

  /*    IF l_lic_count = 0
      THEN
         IF (X_FNC_GET_PROG_TYPE (l_lic_fea_ser)) = 'Y'
         THEN
            l_string3 :=
               'select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.CON_RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.CON_MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            a.CON_CONTRACT_NUMBER "LIC_MPDC_LIC_NUMBER",
                            a.CON_MPDC_SERVICE_CODE "ServiceCode",--"LIC_MPDC_SERVICE_CODE",
                            0 NoOfVPUsed ,--NO_of_VP_used,
                            a.med_device_sch_flag,';

            FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE
                          FROM x_cp_media_device_compat
                      ORDER BY MDC_ID)
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
                                                              and   lic_catchup_flag = ''Y''
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
            FOR contract
               IN (SELECT DISTINCT md_id FROM x_cp_media_device
                   MINUS
                   SELECT DISTINCT mdp_map_dev_id
                     FROM x_cp_con_medplatmdevcompat_map,
                          x_cp_media_dev_platm_map
                    WHERE     CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                          AND CON_CONTRACT_NUMBER = l_con_number
                          AND CON_IS_FEA_SER = 'SER')
            LOOP
               l_string4 :=
                  l_string4
                  || ' UNION select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            0 LIC_MPDC_LIC_NUMBER,
                            '''
                  || l_catchup_flag
                  || ''' ServiceCode ,--LIC_MPDC_SERVICE_CODE,
                            0 NoOfVPUsed ,-- NO_of_VP_used,
                            a.med_device_sch_flag,';

               FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE
                             FROM x_cp_media_device_compat
                         ORDER BY MDC_ID)
               LOOP
                  l_string4 :=
                        l_string4
                     || '''N'''
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
                            0 NoOfVPUsed,-- NO_of_VP_used,
                            a.med_device_sch_flag,';

            FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE
                          FROM x_cp_media_device_compat
                      ORDER BY MDC_ID)
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
                                            ,0 CON_MPDC_UPDATE_COUNT,CON_CONTRACT_NUMBER,CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,
                                            (case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              and   lic_catchup_flag = ''Y''
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
            FOR contract
               IN (SELECT DISTINCT md_id FROM x_cp_media_device
                   MINUS
                   SELECT DISTINCT mdp_map_dev_id
                     FROM x_cp_con_medplatmdevcompat_map,
                          x_cp_media_dev_platm_map
                    WHERE     CON_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                          AND CON_CONTRACT_NUMBER = l_con_number
                          AND CON_IS_FEA_SER <> 'SER')
            LOOP
               --dbms_output.put_line(contract.md_id);
               l_string4 :=
                  l_string4
                  || ' UNION select a.Med_dev_code,
                            a.Med_dev_desc,
                            a.med_platm_code,
                            a.med_platm_desc,
                            a.RIGHTS_ON_DEVICE "LIC_RIGHTS_ON_DEVICE",
                            a.MPDC_DEV_PLATM_ID "LIC_MPDC_DEV_PLATM_ID",
                            0 LIC_MPDC_LIC_NUMBER,
                            '''
                  || l_catchup_flag
                  || ''' ServiceCode,--LIC_MPDC_SERVICE_CODE,
                            0 NoOfVPUsed ,--NO_of_VP_used,
                            a.med_device_sch_flag,';

               FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE
                             FROM x_cp_media_device_compat
                         ORDER BY MDC_ID)
               LOOP
                  l_string4 :=
                        l_string4
                     || '''N'''
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
                                            ,0 MPDC_UPDATE_COUNT,0 CON_CONTRACT_NUMBER,''CATCHUP'' CON_MPDC_SERVICE_CODE,0 NO_of_VP_used,''N'' med_device_sch_flag
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
                                                 )a';
            END LOOP;
         END IF;
      ELSE */
         l_string3 :=
            'select a.Med_dev_code,
                                    a.Med_dev_desc,
                                    a.med_platm_code,
                                    a.med_platm_desc,
                                    a.LIC_RIGHTS_ON_DEVICE,
                                    a.LIC_MPDC_DEV_PLATM_ID,
                                    a.LIC_MPDC_LIC_NUMBER,
                                    a.LIC_MPDC_SERVICE_CODE ServiceCode,
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
                    and b.LIC_MPDC_COMP_RIGHTS_ID = '''
               || i.MDC_ID
               || '''
                    and LIC_MPDC_LIC_NUMBER = '''
               || i_lic_number
               || '''),''N'')   '
               || i.MDC_CODE
               || '_Dynamic_'
               || i.MDC_ID
               || ',';
         END LOOP;

         l_string3 :=
            l_string3
            || 'a.LIC_MPDC_UPDATE_COUNT  from (select
                                                   MDP_MAP_DEV_ID,
                                                   (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_code,
                                                   (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                                    MDP_MAP_PLATM_CODE med_platm_code,
                                                    (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                                LIC_RIGHTS_ON_DEVICE
                                                ,LIC_MPDC_DEV_PLATM_ID
                                                    ,0 LIC_MPDC_UPDATE_COUNT,LIC_MPDC_LIC_NUMBER,LIC_MPDC_SERVICE_CODE,
                                                    (case when (select count(1) from x_cp_play_list where plt_lic_number in ( select lic_number
                                                              from fid_license
                                                                    ,fid_general
                                                                    ,fid_licensee
                                                              where lic_gen_refno = gen_refno
                                                              and   lic_lee_number = lee_number
                                                              and   lic_catchup_flag = ''Y''
                                                              and lic_number = '''
            || i_lic_number
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
            || i_lic_number
            || '''
                                                   group by MDP_MAP_DEV_ID,
                                                            MDP_MAP_PLATM_CODE,LIC_RIGHTS_ON_DEVICE,LIC_MPDC_DEV_PLATM_ID,LIC_MPDC_LIC_NUMBER,LIC_MPDC_SERVICE_CODE
                                                         order by MDP_MAP_DEV_ID)a';

         --changes for issue#:89357-start-17/12/2014-SHANTANU A.
         FOR j
            IN (SELECT md_id FROM x_cp_media_device
                MINUS
                SELECT DISTINCT mdp_map_dev_id
                  FROM x_cp_lic_medplatmdevcompat_map,
                       x_cp_media_dev_platm_map
                 WHERE LIC_MPDC_DEV_PLATM_ID(+) = MDP_MAP_ID
                       AND LIC_MPDC_LIC_NUMBER = i_lic_number)
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
               || ''' LIC_MPDC_SERVICE_CODE,
                                    ''N'' med_device_sch_flag,';

            FOR i IN (  SELECT DISTINCT MDC_ID, MDC_CODE,MDC_UI_SEQ
                          FROM x_cp_media_device_compat
                      ORDER BY MDC_UI_SEQ)
            LOOP
               dbms_lob.append(
                     l_string4
                  , '''N'''
                  || i.MDC_CODE
                  || '_Dynamic_'
                  || i.MDC_ID
                  || ',');
            END LOOP;

            dbms_lob.append(
               l_string4
               , 'a.MPDC_UPDATE_COUNT "LIC_MPDC_UPDATE_COUNT"
                                          from (select
                                                   MDP_MAP_DEV_ID,
                                                   (select MD_CODE from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID)Med_dev_code,
                                                   (select MD_DESC from x_cp_media_device where MD_ID = MDP_MAP_DEV_ID) Med_dev_desc,
                                                    MDP_MAP_PLATM_CODE med_platm_code,
                                                    (select MP_MEDIA_PLATFORM_DESC from sgy_pb_media_platform where MP_MEDIA_PLATFORM_CODE =  MDP_MAP_PLATM_CODE ) med_platm_desc,
                                                    ''N'' RIGHTS_ON_DEVICE
                                                    ,MPDC_DEV_PLATM_ID
                                                    ,0 MPDC_UPDATE_COUNT,0 LIC_MPDC_LIC_NUMBER,''CATCHUP'' LIC_MPDC_SERVICE_CODE,''N'' med_device_sch_flag
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
                                                   MDP_MAP_PLATM_CODE,MPDC_DEV_PLATM_ID
                                                   order by MDP_MAP_DEV_ID
                                                         )a');
         END LOOP;
   --   END IF;

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
      l_string5 := l_string3 || ' ' || l_string4;

      --      DBMS_OUTPUT.PUT_LINE ('l_string2 : ' || l_string2);
      --      DBMS_OUTPUT.PUT_LINE ('l_string5 : ' || l_string5);

      OPEN o_lic_medplatmdevcompat_dtls FOR l_string2;

      OPEN o_lic_meddevplat_rights FOR l_string5;

      OPEN o_searchmediasermediaplat FOR
         SELECT lmps_mapp_id lmps_id,
                lmps_lic_number,
                mpsm_mapp_service_code,
                mpsm_mapp_platform_code,
                'Y' check_flag
           FROM sgy_pb_lic_med_plat_service, sgy_pb_med_platm_service_map
          WHERE mpsm_mapp_id = lmps_mapp_id
                AND lmps_lic_number = i_lic_number;

      --added by rashmi 25-06-2015
      OPEN o_media_service FOR
         SELECT ms_media_service_flag, MS_MEDIA_SERVICE_CODE
           FROM SGY_PB_MEDIA_SERVICE
          WHERE MS_MEDIA_SERVICE_CODE NOT IN ('TVOD', 'PAYTV', 'CATCHUP');
   --CATCHUP_[END]

     --Dev.R1: CatchUp for All :[BR_15_272_UC_Super Stacking]_[Milan Shah]_[2016/01/04]: Start
       OPEN O_SUPERSTACK_RIGHTS
       FOR
       SELECT DISTINCT CB_NAME
              ,CB_ID
              ,CB_RANK
             -- ,NVL(LSR_SUPERSTACK_FLAG,'N') LSR_SUPERSTACK_FLAG
             ,nvl((SELECT LSR_SUPERSTACK_FLAG FROM X_CP_LIC_SUPERSTACK_RIGHTS WHERE LSR_LIC_NUMBER=LIC_NUMBER AND LSR_BOUQUET_ID = CB_ID),'N') LSR_SUPERSTACK_FLAG
             ,(PKG_ALIC_CM_LICENSEMAINTENANCE.x_fnc_cal_viewing_days(i_lic_number,CB_ID)) SCH_VIEWING_DAYS
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
                            CSR_CON_NUMBER = (SELECT LIC_CON_NUMBER FROM FID_LICENSE WHERE LIC_NUMBER = i_lic_number)
                            AND CSR_BOUQUET_ID = CB_ID
                          )>0
                          AND 'Y' = NVL((SELECT distinct CSR_SUPERSTACK_FLAG FROM X_CP_CON_SUPERSTACK_RIGHTS
                                    WHERE CSR_CON_NUMBER = (SELECT LIC_CON_NUMBER FROM FID_LICENSE WHERE LIC_NUMBER = i_lic_number ) AND CSR_BOUQUET_ID = CB_ID
                                    AND CSR_SEA_NUMBER = (SELECT GEN_SER_NUMBER FROM FID_GENERAL WHERE GEN_REFNO = (SELECT LIC_GEN_REFNO FROM FID_LICENSE WHERE LIC_NUMBER =i_lic_number ))),'N')
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
        AND LIC_NUMBER = i_lic_number
       AND CB_ID IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP
                      WHERE CMM_BOUQ_MS_CODE IN(select LEE_MEDIA_SERVICE_CODE from fid_license,fid_licensee
                                                          where lic_number = i_lic_number AND lic_lee_number = lee_number)AND CMM_BOUQ_MS_RIGHTS ='Y')
        ORDER BY CB_RANK;


         /*SELECT DISTINCT
              CB_NAME
              ,CB_ID
              ,NVL(LSR_SUPERSTACK_FLAG,'N') LSR_SUPERSTACK_FLAG
              ,NVL(To_char(PLT_SCH_END_DATE - PLT_SCH_START_DATE),'NA')  SCH_VIEWING_DAYS
              ,(
                CASE
                    WHEN
                      CB_ID  IN (SELECT CMM_BOUQ_ID FROM X_CP_BOUQUET_MS_MAPP)
                    THEN
                      CASE
                        WHEN
                          (SELECT COUNT(1) FROM X_CP_CON_SUPERSTACK_RIGHTS
                          WHERE
                          CSR_CON_NUMBER = (SELECT LIC_CON_NUMBER FROM FID_LICENSE WHERE LIC_NUMBER = i_lic_number)
                          AND CSR_BOUQUET_ID = CB_ID)>0
                        THEN
                          CASE
                            WHEN
                                PLT_IS_SCH_ON_BOUQ = 'Y' AND LSR_SUPERSTACK_FLAG = 'Y'
                            THEN
                              'N'
                            WHEN
                              PLT_IS_SCH_ON_BOUQ = 'N' AND LSR_SUPERSTACK_FLAG IN ('Y','N')
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
        FROM
        FID_LICENSE
        ,X_CP_BOUQUET
        ,X_CP_LIC_SUPERSTACK_RIGHTS
        ,X_CP_PLAY_LIST
        ,X_CP_BOUQUET_MS_MAPP
      WHERE
        LIC_NUMBER =i_lic_number
        AND CB_ID = LSR_BOUQUET_ID(+)
        AND PLT_LIC_NUMBER(+) = LIC_NUMBER
        AND CMM_BOUQ_ID(+)=CB_ID
        AND CB_BOUQ_PARENT_ID IS NULL;*/

   --Dev.R1: CatchUp for All: End
   /* EXCEPTION
       WHEN OTHERS
       THEN
          raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));*/
   END prc_licence_details_search;

   PROCEDURE prc_update_ledger (
      i_lic_number        IN     fid_license.lic_number%TYPE,
      i_lic_chs_number    IN     fid_license.lic_chs_number%TYPE,
      i_lic_lee_number    IN     fid_license.lic_lee_number%TYPE,
      i_lic_con_number    IN     fid_license.lic_con_number%TYPE,
      i_gen_ser_number    IN     fid_general.gen_ser_number%TYPE,
      i_terr_code         IN     fid_license_ledger.lil_ter_code%TYPE,
      i_contract_series   IN     VARCHAR2,
      i_terr_action       IN     VARCHAR2,
      i_lcp_rgh_code      IN     VARCHAR2,
      i_user_id           IN     VARCHAR2,
      -- i_lcp_ter_code      IN       VARCHAR2,
      i_flag              IN     NUMBER,
      o_status               OUT NUMBER)
   AS
      l_count              NUMBER;
      l_count1             NUMBER;
      l_con_catchup_flag   fid_contract.con_catchup_flag%TYPE;
      /* CURSOR c_lic
       IS
          SELECT lic_number, lic_price
            FROM fid_license
           WHERE (   (    (NVL (i_contract_series, 'X') = 'S')
                      AND (lic_con_number = i_lic_con_number)
                      AND (lic_gen_refno IN (
                                        SELECT gen_refno
                                          FROM fid_general
                                         WHERE gen_ser_number =
                                                               i_gen_ser_number)
                          )
                     )
                  OR (    (NVL (i_contract_series, 'X') = 'C')
                      AND lic_con_number = i_lic_con_number
                     )
                 )
             AND lic_chs_number = i_lic_chs_number
             AND lic_lee_number = i_lic_lee_number;*/
      l_ter_exist          NUMBER;
   BEGIN
      /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
      SELECT con_catchup_flag
        INTO l_con_catchup_flag
        FROM fid_license, fid_contract
       WHERE lic_con_number = con_number AND lic_number = i_lic_number;

      /* Catchup CACQ11 : eND  03/12/2012 */
      IF i_terr_action = 'D'
      THEN
         ---DBMS_OUTPUT.put_line ('1');
         pkg_alic_mn_magic_lic_copier.prc_populate_lic_lil (i_lic_number,
                                                            i_user_id);

         -- DBMS_OUTPUT.put_line ('2');

         /*IF l_con_catchup_flag = 'Y' or l_con_catchup_flag = 'S'*/
         -- 19/03/15 for SVOD added 'S'
         /*Above If condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
         IF NVL (l_con_catchup_flag, 'N') <> 'N'
         /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
         THEN
            FOR rec_lic
               IN (SELECT lic_number, lic_price
                     FROM fid_license
                    WHERE ( ( (NVL (i_contract_series, 'X') = 'S')
                             AND (lic_con_number = i_lic_con_number)
                             AND (lic_gen_refno IN
                                     (SELECT gen_refno
                                        FROM fid_general
                                       WHERE gen_ser_number =
                                                i_gen_ser_number)))
                           OR ( (NVL (i_contract_series, 'X') = 'C')
                               AND lic_con_number = i_lic_con_number))
                          --AND lic_chs_number = i_lic_chs_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                               )       --c_lic
            LOOP
               FOR terr_rec
                  IN (SELECT lcp_lic_number,
                             lcp_ter_code,
                             lcp_rgh_code,
                             lcp_price_code,
                             lcp_price,
                             lcp_adjust_factor,
                             lcp_comment
                        FROM fid_lic_ledger_copier
                       WHERE lcp_lic_number = i_lic_number
                             AND lcp_ter_code = i_terr_code)
               LOOP
                  SELECT COUNT (lil_ter_code)
                    INTO l_ter_exist
                    FROM fid_license_ledger
                   WHERE lil_lic_number = rec_lic.lic_number
                         AND lil_ter_code = terr_rec.lcp_ter_code;

                  -- DBMS_OUTPUT.put_line ('3:' || l_ter_exist);

                  IF l_ter_exist > 0
                  THEN
                     DELETE FROM fid_license_ledger
                           WHERE lil_lic_number = rec_lic.lic_number
                                 AND lil_ter_code = terr_rec.lcp_ter_code;
                  END IF;
               END LOOP;
            END LOOP;
         ELSE
            FOR rec_lic
               IN (SELECT lic_number, lic_price
                     FROM fid_license
                    WHERE ( ( (NVL (i_contract_series, 'X') = 'S')
                             AND (lic_con_number = i_lic_con_number)
                             AND (lic_gen_refno IN
                                     (SELECT gen_refno
                                        FROM fid_general
                                       WHERE gen_ser_number =
                                                i_gen_ser_number)))
                           OR ( (NVL (i_contract_series, 'X') = 'C')
                               AND lic_con_number = i_lic_con_number))
                          AND lic_chs_number = i_lic_chs_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                               )       --c_lic
            LOOP
               FOR terr_rec
                  IN (SELECT lcp_lic_number,
                             lcp_ter_code,
                             lcp_rgh_code,
                             lcp_price_code,
                             lcp_price,
                             lcp_adjust_factor,
                             lcp_comment
                        FROM fid_lic_ledger_copier
                       WHERE lcp_lic_number = i_lic_number
                             AND lcp_ter_code = i_terr_code)
               LOOP
                  SELECT COUNT (lil_ter_code)
                    INTO l_ter_exist
                    FROM fid_license_ledger
                   WHERE lil_lic_number = rec_lic.lic_number
                         AND lil_ter_code = terr_rec.lcp_ter_code;

                  -- DBMS_OUTPUT.put_line ('3:' || l_ter_exist);

                  IF l_ter_exist > 0
                  THEN
                     DELETE FROM fid_license_ledger
                           WHERE lil_lic_number = rec_lic.lic_number
                                 AND lil_ter_code = terr_rec.lcp_ter_code;
                  END IF;
               END LOOP;
            END LOOP;
         END IF;

         -- DBMS_OUTPUT.put_line ('4');
         COMMIT;
      ELSIF i_terr_action = 'U'
      THEN
         pkg_alic_mn_magic_lic_copier.prc_populate_lic_lil (i_lic_number,
                                                            i_user_id);

         SELECT COUNT (*)
           INTO l_count
           FROM fid_lic_ledger_copier
          WHERE lcp_lic_number = i_lic_number AND lcp_ter_code = i_terr_code;

         --and LCP_RGH_CODE=i_LCP_RGH_CODE
         IF l_count > 0
         THEN
            UPDATE fid_lic_ledger_copier
               SET lcp_rgh_code = i_lcp_rgh_code
             --lcp_price = NVL (i_lic_price, 0)
             WHERE lcp_lic_number = i_lic_number
                   AND lcp_ter_code = i_terr_code;

            COMMIT;
         END IF;

         /*IF l_con_catchup_flag = 'Y' or l_con_catchup_flag = 'S'*/
         -- 19/03/15 for SVOD added 'S'
         /*Above If condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
         IF NVL (l_con_catchup_flag, 'N') <> 'N'
         /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
         THEN
            FOR rec_lic
               IN (SELECT lic_number, lic_price
                     FROM fid_license
                    WHERE ( ( (NVL (i_contract_series, 'X') = 'S')
                             AND (lic_con_number = i_lic_con_number)
                             AND (lic_gen_refno IN
                                     (SELECT gen_refno
                                        FROM fid_general
                                       WHERE gen_ser_number =
                                                i_gen_ser_number)))
                           OR ( (NVL (i_contract_series, 'X') = 'C')
                               AND lic_con_number = i_lic_con_number))
                          --  AND lic_chs_number = i_lic_chs_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                               )       --c_lic
            LOOP
               --DBMS_OUTPUT.put_line ('1' || l_ter_exist);
               FOR terr_rec IN (SELECT lcp_lic_number,
                                       lcp_ter_code,
                                       lcp_rgh_code,
                                       lcp_price_code,
                                       lcp_price,
                                       lcp_adjust_factor,
                                       lcp_comment
                                  FROM fid_lic_ledger_copier
                                 WHERE lcp_lic_number = i_lic_number)
               LOOP
                  --DBMS_OUTPUT.put_line ('2');
                  SELECT COUNT (lil_ter_code)
                    INTO l_ter_exist
                    FROM fid_license_ledger
                   WHERE lil_lic_number = rec_lic.lic_number
                         AND lil_ter_code = terr_rec.lcp_ter_code;

                  IF l_ter_exist > 0
                  THEN
                     -- DBMS_OUTPUT.put_line ('3');
                     UPDATE fid_license_ledger
                        SET lil_rgh_code = terr_rec.lcp_rgh_code,
                            lil_price =
                               DECODE (terr_rec.lcp_rgh_code,
                                       'X', 0,
                                       rec_lic.lic_price)
                      WHERE lil_lic_number = rec_lic.lic_number
                            AND lil_ter_code = terr_rec.lcp_ter_code;
                  END IF;
               END LOOP;
            END LOOP;
         ELSE
            FOR rec_lic
               IN (SELECT lic_number, lic_price
                     FROM fid_license
                    WHERE ( ( (NVL (i_contract_series, 'X') = 'S')
                             AND (lic_con_number = i_lic_con_number)
                             AND (lic_gen_refno IN
                                     (SELECT gen_refno
                                        FROM fid_general
                                       WHERE gen_ser_number =
                                                i_gen_ser_number)))
                           OR ( (NVL (i_contract_series, 'X') = 'C')
                               AND lic_con_number = i_lic_con_number))
                          AND lic_chs_number = i_lic_chs_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                               )       --c_lic
            LOOP
               --DBMS_OUTPUT.put_line ('1' || l_ter_exist);
               FOR terr_rec IN (SELECT lcp_lic_number,
                                       lcp_ter_code,
                                       lcp_rgh_code,
                                       lcp_price_code,
                                       lcp_price,
                                       lcp_adjust_factor,
                                       lcp_comment
                                  FROM fid_lic_ledger_copier
                                 WHERE lcp_lic_number = i_lic_number)
               LOOP
                  --DBMS_OUTPUT.put_line ('2');
                  SELECT COUNT (lil_ter_code)
                    INTO l_ter_exist
                    FROM fid_license_ledger
                   WHERE lil_lic_number = rec_lic.lic_number
                         AND lil_ter_code = terr_rec.lcp_ter_code;

                  IF l_ter_exist > 0
                  THEN
                     -- DBMS_OUTPUT.put_line ('3');
                     UPDATE fid_license_ledger
                        SET lil_rgh_code = terr_rec.lcp_rgh_code,
                            lil_price =
                               DECODE (terr_rec.lcp_rgh_code,
                                       'X', 0,
                                       rec_lic.lic_price)
                      WHERE lil_lic_number = rec_lic.lic_number
                            AND lil_ter_code = terr_rec.lcp_ter_code;
                  END IF;
               END LOOP;
            END LOOP;
         END IF;
      --DBMS_OUTPUT.put_line ('4');
      ELSIF i_terr_action = 'A'
      THEN
         -- DBMS_OUTPUT.put_line ('2');
         pkg_alic_mn_magic_lic_copier.prc_populate_lic_lil (i_lic_number,
                                                            i_user_id);

         SELECT COUNT (*)
           INTO l_count
           FROM fid_lic_ledger_copier
          WHERE lcp_lic_number = i_lic_number AND lcp_ter_code = i_terr_code;

         -- DBMS_OUTPUT.put_line ('2' || l_count);

         --and LCP_RGH_CODE=i_LCP_RGH_CODE
         IF l_count = 0
         THEN
            INSERT INTO fid_lic_ledger_copier (lcp_lic_number,
                                               lcp_ter_code,
                                               lcp_rgh_code,
                                               lcp_price_code,
                                               lcp_price,
                                               lcp_adjust_factor,
                                               lcp_con_forecast,
                                               lcp_loc_forecast,
                                               lcp_con_calc,
                                               lcp_loc_calc,
                                               lcp_con_actual,
                                               lcp_loc_actual,
                                               lcp_con_adjust,
                                               lcp_loc_adjust,
                                               lcp_is_deleted,
                                               lcp_update_count,
                                               lcp_entry_oper,
                                               lcp_entry_date)
                 VALUES (i_lic_number,
                         i_terr_code,
                         i_lcp_rgh_code,
                         '-',
                         0,
                         1,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0,
                         0,
                         i_user_id,
                         SYSDATE);

            COMMIT;
         END IF;

         /*IF l_con_catchup_flag = 'Y' or l_con_catchup_flag = 'S'*/
         -- 19/03/15 for SVOD added 'S'
         /*Above If condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
         IF NVL (l_con_catchup_flag, 'N') <> 'N'
         /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
         THEN
            FOR rec_lic
               IN (SELECT lic_number, lic_price
                     FROM fid_license
                    WHERE ( ( (NVL (i_contract_series, 'X') = 'S')
                             AND (lic_con_number = i_lic_con_number)
                             AND (lic_gen_refno IN
                                     (SELECT gen_refno
                                        FROM fid_general
                                       WHERE gen_ser_number =
                                                i_gen_ser_number)))
                           OR ( (NVL (i_contract_series, 'X') = 'C')
                               AND lic_con_number = i_lic_con_number))
                          -- AND lic_chs_number = i_lic_chs_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                               )       --c_lic
            LOOP
               FOR terr_rec IN (SELECT lcp_lic_number,
                                       lcp_ter_code,
                                       lcp_rgh_code,
                                       lcp_price_code,
                                       lcp_price,
                                       lcp_adjust_factor,
                                       lcp_comment
                                  FROM fid_lic_ledger_copier
                                 WHERE lcp_lic_number = i_lic_number)
               LOOP
                  SELECT COUNT (*)
                    INTO l_count1
                    FROM fid_license_ledger
                   WHERE lil_lic_number = rec_lic.lic_number
                         AND lil_ter_code = terr_rec.lcp_ter_code;

                  -- DBMS_OUTPUT.put_line ('22 ' || l_count1);

                  --and LCP_RGH_CODE=i_LCP_RGH_CODE
                  IF l_count1 = 0
                  THEN
                     INSERT INTO fid_license_ledger (lil_lic_number,
                                                     lil_ter_code,
                                                     lil_rgh_code,
                                                     lil_price_code,
                                                     lil_price,
                                                     lil_adjust_factor,
                                                     lil_con_forecast,
                                                     lil_loc_forecast,
                                                     lil_con_calc,
                                                     lil_loc_calc,
                                                     lil_con_actual,
                                                     lil_loc_actual,
                                                     lil_con_adjust,
                                                     lil_loc_adjust,
                                                     lil_comment,
                                                     lil_is_deleted,
                                                     lil_update_count,
                                                     lil_entry_oper,
                                                     lil_entry_date)
                          VALUES (
                                    rec_lic.lic_number,
                                    terr_rec.lcp_ter_code,
                                    terr_rec.lcp_rgh_code,
                                    terr_rec.lcp_price_code,
                                    DECODE (terr_rec.lcp_rgh_code,
                                            'X', 0,
                                            rec_lic.lic_price),
                                    terr_rec.lcp_adjust_factor,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    terr_rec.lcp_comment,
                                    0,
                                    0,
                                    i_user_id,
                                    SYSDATE);
                  END IF;
               END LOOP;
            END LOOP;
         ELSE
            FOR rec_lic
               IN (SELECT lic_number, lic_price
                     FROM fid_license
                    WHERE ( ( (NVL (i_contract_series, 'X') = 'S')
                             AND (lic_con_number = i_lic_con_number)
                             AND (lic_gen_refno IN
                                     (SELECT gen_refno
                                        FROM fid_general
                                       WHERE gen_ser_number =
                                                i_gen_ser_number)))
                           OR ( (NVL (i_contract_series, 'X') = 'C')
                               AND lic_con_number = i_lic_con_number))
                          AND lic_chs_number = i_lic_chs_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                               )       --c_lic
            LOOP
               FOR terr_rec IN (SELECT lcp_lic_number,
                                       lcp_ter_code,
                                       lcp_rgh_code,
                                       lcp_price_code,
                                       lcp_price,
                                       lcp_adjust_factor,
                                       lcp_comment
                                  FROM fid_lic_ledger_copier
                                 WHERE lcp_lic_number = i_lic_number)
               LOOP
                  SELECT COUNT (*)
                    INTO l_count1
                    FROM fid_license_ledger
                   WHERE lil_lic_number = rec_lic.lic_number
                         AND lil_ter_code = terr_rec.lcp_ter_code;

                  -- DBMS_OUTPUT.put_line ('22 ' || l_count1);

                  --and LCP_RGH_CODE=i_LCP_RGH_CODE
                  IF l_count1 = 0
                  THEN
                     INSERT INTO fid_license_ledger (lil_lic_number,
                                                     lil_ter_code,
                                                     lil_rgh_code,
                                                     lil_price_code,
                                                     lil_price,
                                                     lil_adjust_factor,
                                                     lil_con_forecast,
                                                     lil_loc_forecast,
                                                     lil_con_calc,
                                                     lil_loc_calc,
                                                     lil_con_actual,
                                                     lil_loc_actual,
                                                     lil_con_adjust,
                                                     lil_loc_adjust,
                                                     lil_comment,
                                                     lil_is_deleted,
                                                     lil_update_count,
                                                     lil_entry_oper,
                                                     lil_entry_date)
                          VALUES (
                                    rec_lic.lic_number,
                                    terr_rec.lcp_ter_code,
                                    terr_rec.lcp_rgh_code,
                                    terr_rec.lcp_price_code,
                                    DECODE (terr_rec.lcp_rgh_code,
                                            'X', 0,
                                            rec_lic.lic_price),
                                    terr_rec.lcp_adjust_factor,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    terr_rec.lcp_comment,
                                    0,
                                    0,
                                    i_user_id,
                                    SYSDATE);
                  END IF;
               END LOOP;
            END LOOP;
         END IF;
      ELSIF i_terr_action = 'R'
      THEN
         pkg_alic_mn_magic_lic_copier.prc_populate_lic_lil (i_lic_number,
                                                            i_user_id);

         IF i_flag = 0
         THEN
            DELETE fid_lic_ledger_copier
             WHERE lcp_lic_number = i_lic_number;

            COMMIT;
         END IF;

         SELECT COUNT (*)
           INTO l_count
           FROM fid_lic_ledger_copier
          WHERE lcp_lic_number = i_lic_number AND lcp_ter_code = i_terr_code;

         -- DBMS_OUTPUT.put_line ('2' || l_count);

         --and LCP_RGH_CODE=i_LCP_RGH_CODE
         IF l_count = 0
         THEN
            BEGIN
               INSERT INTO fid_lic_ledger_copier (lcp_lic_number,
                                                  lcp_ter_code,
                                                  lcp_rgh_code,
                                                  lcp_price_code,
                                                  lcp_price,
                                                  lcp_adjust_factor,
                                                  lcp_con_forecast,
                                                  lcp_loc_forecast,
                                                  lcp_con_calc,
                                                  lcp_loc_calc,
                                                  lcp_con_actual,
                                                  lcp_loc_actual,
                                                  lcp_con_adjust,
                                                  lcp_loc_adjust,
                                                  lcp_is_deleted,
                                                  lcp_update_count,
                                                  lcp_entry_oper,
                                                  lcp_entry_date)
                    VALUES (i_lic_number,
                            i_terr_code,
                            i_lcp_rgh_code,
                            '-',
                            0,
                            1,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            i_user_id,
                            SYSDATE);
            EXCEPTION
               WHEN OTHERS
               THEN
                  raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
            END;

            COMMIT;
         END IF;

         /*IF l_con_catchup_flag = 'Y' or l_con_catchup_flag = 'S'*/
         -- 19/03/15 for SVOD added 'S'
         /*Above If condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
         IF NVL (l_con_catchup_flag, 'N') <> 'N'
         /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
         THEN
            FOR rec_lic
               IN (SELECT lic_number, lic_price
                     FROM fid_license
                    WHERE ( ( (NVL (i_contract_series, 'X') = 'S')
                             AND (lic_con_number = i_lic_con_number)
                             AND (lic_gen_refno IN
                                     (SELECT gen_refno
                                        FROM fid_general
                                       WHERE gen_ser_number =
                                                i_gen_ser_number)))
                           OR ( (NVL (i_contract_series, 'X') = 'C')
                               AND lic_con_number = i_lic_con_number))
                          -- AND lic_chs_number = i_lic_chs_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                               )       --c_lic
            LOOP
               --DBMS_OUTPUT.put_line ('2');
               DELETE fid_license_ledger
                WHERE lil_lic_number = rec_lic.lic_number;

               COMMIT;

               BEGIN
                  INSERT INTO fid_license_ledger (lil_lic_number,
                                                  lil_ter_code,
                                                  lil_rgh_code,
                                                  lil_price_code,
                                                  lil_price,
                                                  lil_adjust_factor,
                                                  lil_con_forecast,
                                                  lil_loc_forecast,
                                                  lil_con_calc,
                                                  lil_loc_calc,
                                                  lil_con_actual,
                                                  lil_loc_actual,
                                                  lil_con_adjust,
                                                  lil_loc_adjust,
                                                  lil_comment,
                                                  lil_is_deleted,
                                                  lil_update_count,
                                                  lil_entry_oper,
                                                  lil_entry_date)
                     SELECT rec_lic.lic_number,
                            lcp_ter_code,
                            lcp_rgh_code,
                            lcp_price_code,
                            DECODE (lcp_rgh_code, 'X', 0, rec_lic.lic_price),
                            lcp_adjust_factor,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            lcp_comment,
                            0,
                            0,
                            i_user_id,
                            SYSDATE
                       FROM fid_lic_ledger_copier
                      WHERE lcp_lic_number = i_lic_number;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20010,
                                              SUBSTR (SQLERRM, 1, 200));
               END;
            END LOOP;
         ELSE
            FOR rec_lic
               IN (SELECT lic_number, lic_price
                     FROM fid_license
                    WHERE ( ( (NVL (i_contract_series, 'X') = 'S')
                             AND (lic_con_number = i_lic_con_number)
                             AND (lic_gen_refno IN
                                     (SELECT gen_refno
                                        FROM fid_general
                                       WHERE gen_ser_number =
                                                i_gen_ser_number)))
                           OR ( (NVL (i_contract_series, 'X') = 'C')
                               AND lic_con_number = i_lic_con_number))
                          AND lic_chs_number = i_lic_chs_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                               )       --c_lic
            LOOP
               --DBMS_OUTPUT.put_line ('2');
               DELETE fid_license_ledger
                WHERE lil_lic_number = rec_lic.lic_number;

               COMMIT;

               BEGIN
                  INSERT INTO fid_license_ledger (lil_lic_number,
                                                  lil_ter_code,
                                                  lil_rgh_code,
                                                  lil_price_code,
                                                  lil_price,
                                                  lil_adjust_factor,
                                                  lil_con_forecast,
                                                  lil_loc_forecast,
                                                  lil_con_calc,
                                                  lil_loc_calc,
                                                  lil_con_actual,
                                                  lil_loc_actual,
                                                  lil_con_adjust,
                                                  lil_loc_adjust,
                                                  lil_comment,
                                                  lil_is_deleted,
                                                  lil_update_count,
                                                  lil_entry_oper,
                                                  lil_entry_date)
                     SELECT rec_lic.lic_number,
                            lcp_ter_code,
                            lcp_rgh_code,
                            lcp_price_code,
                            DECODE (lcp_rgh_code, 'X', 0, rec_lic.lic_price),
                            lcp_adjust_factor,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            lcp_comment,
                            0,
                            0,
                            i_user_id,
                            SYSDATE
                       FROM fid_lic_ledger_copier
                      WHERE lcp_lic_number = i_lic_number;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     raise_application_error (-20010,
                                              SUBSTR (SQLERRM, 1, 200));
               END;
            END LOOP;
         END IF;
      END IF;

      COMMIT;
      --o_status := 1;
      o_status := SQL%ROWCOUNT;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_status := 0;
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_update_ledger;

   PROCEDURE prc_update_license (
      i_lic_number            IN     NUMBER,
      i_lic_lee_number        IN     NUMBER,
      i_lic_lee_number_new    IN     NUMBER,
      i_lic_chs_number        IN     NUMBER,
      i_lic_chs_number_new    IN     NUMBER,
      i_lic_con_number        IN     NUMBER,
      i_lic_con_number_new    IN     NUMBER,
      i_lic_gen_refno         IN     VARCHAR2,
      i_lic_price             IN     NUMBER,
      i_lic_markup_percent    IN     NUMBER,
      i_lic_start             IN     DATE,
      i_lic_end               IN     DATE,
      i_lic_period_tba        IN     VARCHAR2,
      -- Project Bioscope : Ajit_20120319 : Time Shift Flag added
      i_timeshiftchannel      IN     VARCHAR2,
      -- Project Bioscope : Ajit_20120319 : End
      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
      i_simulcastchannel      IN     VARCHAR2,
      /* PB (CR 12) :END */
      i_lic_currency          IN     VARCHAR2,
      -- i_lic_rate           IN     NUMBER,
      i_lic_showing_int       IN     NUMBER,
      i_lic_showing_lic       IN     NUMBER,
      i_lic_max_cha           IN     NUMBER,
      i_lic_max_chs           IN     NUMBER,
      i_lic_amort_code        IN     VARCHAR2,
      i_lic_budget_code       IN     VARCHAR2,
      i_contract_series       IN     VARCHAR2,
      i_entry_oper            IN     VARCHAR2,
      /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
      i_max_vp_in_days        IN     fid_license.lic_max_viewing_period%TYPE,
      i_sch_aft_prem_linear   IN     fid_license.lic_sch_aft_prem_linear%TYPE,
      i_non_cons_month        IN     fid_license.lic_non_cons_month%TYPE,
      /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */

      -- Dev2: Non Costed Fillers: Start:[]_[ADITYA GUPTA]_[2013/3/15]
      -- [Modifications for incorporating Non-Costed Fillers changes]
      i_lic_free_rpt          IN     fid_license.lic_free_rpt%TYPE,
      i_lic_rpt_period        IN     fid_license.lic_rpt_period%TYPE,
      ---- Dev2: Non Costed Fillers: End
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : check for transfer_payment operation
      i_trnsfr_pmnt_flag      IN     VARCHAR2,
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140506 : end
      o_count                    OUT NUMBER,
      o_status                   OUT NUMBER)
   AS
      l_is_catchup                   VARCHAR2 (1);
      l_message                      VARCHAR2 (200);
      l_rat_rate                     NUMBER;
      l_lic_currency                 VARCHAR2 (3);
      l_ser_number                   NUMBER;
      select_contract_or_series      EXCEPTION;
      l_max_closed                   NUMBER;
      l_max_month                    NUMBER;
      l_showing_lic                  NUMBER;
      l_tba_flag                     NUMBER;
      o_lic_price                    fid_license.lic_price%TYPE;
      o_lic_markup_percent           fid_license.lic_markup_percent%TYPE;
      o_lic_lee_number_new           fid_license.lic_lee_number%TYPE;
      o_lic_chs_number_new           fid_license.lic_chs_number%TYPE;
      o_lic_start                    fid_license.lic_start%TYPE;
      o_lic_end                      fid_license.lic_end%TYPE;
      o_lic_period_tba               fid_license.lic_period_tba%TYPE;
      o_lic_currency                 fid_license.lic_currency%TYPE;
      o_rat_rate                     fid_license.lic_rate%TYPE;
      o_lic_showing_int              fid_license.lic_showing_int%TYPE;
      o_lic_showing_lic              fid_license.lic_showing_lic%TYPE;
      o_lic_max_cha                  fid_license.lic_max_cha%TYPE;
      o_lic_max_chs                  fid_license.lic_max_chs%TYPE;
      o_lic_amort_code               fid_license.lic_amort_code%TYPE;
      o_lic_budget_code              fid_license.lic_budget_code%TYPE;
      o_entry_oper                   fid_license.lic_entry_oper%TYPE;
      o_lic_con_number               fid_license.lic_con_number%TYPE;
      exh_exceed_failed              EXCEPTION;
      l_con_catchup_flag             fid_contract.con_catchup_flag%TYPE;
      l_changed_date_flag            VARCHAR2 (30);
      l_maxvp_used                   NUMBER;
      l_schedule_flag                CHAR (1);
      l_cnt                          NUMBER;
      --nishant
      srccontractcurrency            VARCHAR2 (10);
      destcontractcurrency           VARCHAR2 (10);
      /* PB (CR 6) :Pranay Kusumwal 18/07/2012 : Added for validation for Amort Exhibitions */
      count_exh                      NUMBER;
      /* PB (CR 6) :Pranay Kusumwal 18/07/2012 : end */
      ---- ADDED ON 08022012
      l_lic_start                    fid_license.lic_start%TYPE;
      l_lic_end                      fid_license.lic_end%TYPE;
      l_lic_number                   fid_license.lic_number%TYPE;
      l_lee_region_id                fid_licensee.lee_region_id%TYPE;
      l_cp_flg                       fid_license.lic_catchup_flag%TYPE;
      l_con_number                   fid_contract.con_number%TYPE;
      l_lic_gen_refno                fid_license.lic_gen_refno%TYPE;
      l_lnr_lic_start                fid_license.lic_start%TYPE;
      l_lnr_lic_end                  fid_license.lic_end%TYPE;
      l_lnr_lic_number               fid_license.lic_number%TYPE;
      l_lnr_lic_period_tba           fid_license.lic_period_tba%TYPE;
      l_lee_number                   fid_licensee.lee_number%TYPE;
      l_lic_showing_lic              fid_license.lic_showing_lic%TYPE;
      l_lic_showing_int              fid_license.lic_showing_int%TYPE;
      l_lic_max_viewing_period       fid_license.lic_max_viewing_period%TYPE;
      l_consecative_flag             fid_license.lic_non_cons_month%TYPE;
      l_lic_budget_code              fid_license.lic_budget_code%TYPE;
      l_sch_aft_prem_linear          fid_license.lic_sch_aft_prem_linear%TYPE;
      l_sch_within_x_frm_ply_ser     fid_contract.con_sch_within_x_frm_ply_ser%TYPE;
      l_sch_within_x_frm_ply_fea     fid_contract.con_sch_within_x_frm_ply_fea%TYPE;
      l_not_allow_aft_x_start_lic    fid_contract.con_not_allow_aft_x_start_lic%TYPE;
      l_not_allow_bef_x_end_lic_dt   fid_contract.con_not_allow_bef_x_end_lic_dt%TYPE;
      l_lic_period_tba               fid_license.lic_period_tba%TYPE;
      l_schedule_count               NUMBER;
      l_date_diff                    NUMBER;
      t_day                          NUMBER;
      l_sch_number                   fid_schedule.sch_number%TYPE;
      l_plt_sch_number               x_cp_play_list.plt_sch_number%TYPE;
      l_plt_sch_start_date           x_cp_play_list.plt_sch_start_date%TYPE;
      l_bin_sch_number               x_cp_schedule_bin.bin_sch_number%TYPE;
      l_bin_view_start_date          x_cp_schedule_bin.bin_view_start_date%TYPE;
      l_bin_lic_number               x_cp_schedule_bin.bin_lic_number%TYPE;
      l_bin_id                       x_cp_schedule_bin.bin_id%TYPE;
      l_bin_sch_from_time            x_cp_schedule_bin.bin_sch_from_time%TYPE;
      l_bin_sch_end_time             x_cp_schedule_bin.bin_sch_end_time%TYPE;
      l_plt_count                    NUMBER;
      l_total_allocated_runs         NUMBER;
      l_lic_showing_int_new          NUMBER;
      ------Dev2: Pure Finance:Start:[Nishant Ankam]_[26/06/2013]-----------------
      l_prev_lee_number              NUMBER;
      l_prev_lic_region              NUMBER;
      l_prev_lic_cha_comp            NUMBER;
      l_new_lic_region               NUMBER;
      l_new_lic_cha_comp             NUMBER;
      is_catchup_flag                VARCHAR2 (1);
      l_sec_lee_count                NUMBER;
      l_not_in_count                 NUMBER;
      ------Dev2:Pure Finance:End:[Nishant Ankam]_[26/06/2013]--------------------
      ----- DEV3: SAP Implementation:Start:<24/7/2013>:<payment plan on cancellation of licenses>
      l_paid_amt                     NUMBER;
      l_number                       NUMBER;
      l_count                        NUMBER;
      l_count1                       NUMBER;
      l_flag1                        VARCHAR2 (10);
      l_remain_amt                   NUMBER;
      targetcom                      NUMBER;
      l_mem_agy_com_number           NUMBER;
      l_mem_com_number               NUMBER;
      sourcecom                      NUMBER;
      contentstatus                  VARCHAR2 (5);
      l_notpaid_amt                  NUMBER;
      l_notpaid_amt1                 NUMBER;
      l_total_pay_price              NUMBER;
      l_extra_pay_amt                NUMBER;
      l_pay_number                   NUMBER;
      l_lsl_number                   NUMBER;
      l_lic_price                    NUMBER;
      -----  DEV3: SAP Implementation : End : <24/07/2013>------------------------
      ---------------------------------------------------Finance P1
      l_cha_schedule_exits           NUMBER;
      l_channel_name                 VARCHAR2 (20);
      l_tot_schedule_exits           NUMBER;
      --------------------------------------------------------------
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414 : Go live date of costing 5+2
      v_go_live_crc_date             DATE;
      l_costed_runs                  X_FIN_COSTING_RULE_CONFIG%ROWTYPE;
      amortexhnotexists              EXCEPTION;
      l_min_lic_start                DATE;
      l_max_lic_start                DATE;
      /*Swapnil 11-jun-2015 For SVOD*/
      l_media_service_code   sgy_pb_media_service.ms_media_service_code%TYPE;

	----Start[15-Jun-2016][Jawahar.Garg]Changes done for FINCR
	l_lic_number_ary  			x_pkg_common_var.number_array;
	l_gen_title_ary    			x_pkg_common_var.varchar_array;
	l_old_lic_start_ary			x_pkg_common_var.date_array;
	l_new_lic_start_ary			x_pkg_common_var.date_array;
	l_con_name_ary				x_pkg_common_var.varchar_array;
	l_con_short_name_ary		x_pkg_common_var.varchar_array;
	l_lic_lee_number_ary		x_pkg_common_var.number_array;
	----End[15-Jun-2016][Jawahar.Garg]Changes done for FINCR

      CURSOR get_costed_runs
      IS
         SELECT *
           FROM X_FIN_COSTING_RULE_CONFIG
          WHERE     crc_lic_start_from <= i_lic_start
                AND crc_lic_start_to >= i_lic_start
                AND crc_costed_runs = i_lic_showing_lic;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414: End

      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140502 : variables for obtaining insert and delete status
      l_status_ins                   NUMBER := 1;
      l_status_del                   NUMBER := 1;
      transfer_pmnt_failure          EXCEPTION;


   --Dev2: Costing 5+2 Rules :Aditya Gupta_20140502 : End
   BEGIN

         --Start[15-Jun-2016][Jawahar.Garg]Changes done for FINCR
       BEGIN
  SELECT   
        LIC_NUMBER,
        gen_title,
        LIC_START,
        i_lic_start,
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
		 WHERE  ( (i_contract_series = 'S'
		        AND lic_con_number = i_lic_con_number
			AND lic_gen_refno IN (SELECT gen_refno FROM fid_general WHERE gen_ser_number =
																			( SELECT gen_ser_number  FROM fid_general   WHERE gen_refno = i_lic_gen_refno)))
							OR (i_contract_series = 'C'
			AND lic_con_number = i_lic_con_number)
		 )
		AND lic_lee_number = i_lic_lee_number
		AND fl.lic_gen_refno = fg.gen_refno
		AND fl.lic_con_number = fc.con_number
		AND lic_status NOT IN ('I','T')
		AND LIC_WRITEOFF_MARK = 'Y';
	EXCEPTION
	WHEN NO_DATA_FOUND
	THEN
	NULL;
	END;
	--End [15-Jun-2016][Jawahar.Garg]Changes done for FINCR

      SELECT NVL (lic_catchup_flag, 'N')
        INTO l_is_catchup
        FROM fid_license
       WHERE lic_number = i_lic_number;

      BEGIN
         SELECT lic_currency
           INTO l_lic_currency
           FROM fid_license
          WHERE lic_number = i_lic_number
                AND lic_lee_number = i_lic_lee_number;
      -- AND lic_chs_number = i_lic_chs_number;
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      /*Swapnil 11-jun-2015 to get service code for SVOD*/
      BEGIN
         SELECT s.ms_media_service_code
           INTO l_media_service_code
           FROM sgy_pb_media_service s
          WHERE s.ms_media_service_flag = NVL (l_is_catchup, 'N');
      EXCEPTION
         WHEN OTHERS
         THEN
            l_media_service_code := NULL;
      END;

      --DBMS_OUTPUT.put_line ('111111111');

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414 : Go live date of costing 5+2
      SELECT TO_DATE (content)
        INTO v_go_live_crc_date
        FROM x_fin_configs
       WHERE ID = 6;

      IF (i_lic_start >= v_go_live_crc_date)
      THEN
         IF (NVL (i_lic_showing_lic, 0) > 0)
         THEN
            BEGIN
               OPEN get_costed_runs;

               FETCH get_costed_runs INTO l_costed_runs;

               IF get_costed_runs%NOTFOUND
               THEN
                  RAISE amortexhnotexists;
               END IF;

               CLOSE get_costed_runs;
            EXCEPTION
               WHEN amortexhnotexists
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

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140414: End

      ---Added by nishant ankam
      --- Validation :- Source And Destination Currency should be same
      IF i_lic_con_number <> i_lic_con_number_new
      THEN
         SELECT con_currency
           INTO srccontractcurrency
           FROM fid_contract
          WHERE con_number = i_lic_con_number;

         SELECT con_currency
           INTO destcontractcurrency
           FROM fid_contract
          WHERE con_number = i_lic_con_number_new;

         IF (srccontractcurrency <> destcontractcurrency)
         THEN
            raise_application_error (
               -20100,
               'Destination Currency should be same as of Source Currency');
         END IF;
      END IF;

      ----------------Dev2: Pure Finance:Start:[Nishant Ankam]_[26/06/2013]------------------------------------------------------------
      SELECT lic_lee_number
        INTO l_prev_lee_number
        FROM fid_license
       WHERE lic_number = i_lic_number;

      BEGIN
         SELECT lic_catchup_flag
           INTO is_catchup_flag
           FROM fid_license
          WHERE lic_number = i_lic_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            is_catchup_flag := 'N';
      END;

      --CATCHUP:CACQ14: validation for schedule after premiere broadcast on first linear channel_[SHANTANU A.]
      --Start_[05/01/2015]

      /*IF l_is_catchup in( 'Y','S')*/
      /*Above If condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
      IF NVL (l_is_catchup, 'N') <> 'N'
      THEN
         x_pkg_cp_lic_updte_validation.x_prc_cp_mgclic_chk_validation (
            i_lic_number,
            i_lic_showing_lic,
            i_sch_aft_prem_linear);
      END IF;

      --CATCHUP_[END]

      IF ( (l_prev_lee_number <> i_lic_lee_number_new) /*AND NVL (is_catchup_flag,'N') <> 'Y'*/
   /*Above AND condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
           AND NVL (is_catchup_flag, 'N') = 'N')
      THEN
         -- DBMS_OUTPUT.put_line ('in condition');

         BEGIN
            SELECT COUNT (*)
              INTO l_sec_lee_count
              FROM x_fin_lic_sec_lee
             WHERE lsl_lic_number = i_lic_number;

            IF l_sec_lee_count > 1
            THEN
               SELECT lee_split_region, lee_cha_com_number
                 INTO l_prev_lic_region, l_prev_lic_cha_comp
                 FROM fid_licensee
                WHERE lee_number = l_prev_lee_number;

               SELECT lee_split_region, lee_cha_com_number
                 INTO l_new_lic_region, l_new_lic_cha_comp
                 FROM fid_licensee
                WHERE lee_number = i_lic_lee_number_new;

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
                WHERE lsl_lic_number = i_lic_number
                      AND lsl_lee_number = i_lic_lee_number_new;

               IF (l_not_in_count > 0)
               THEN
                  raise_application_error (
                     -20100,
                     'Licensee already belongs to primary licensee');
               END IF;
            END IF;
         END;
      END IF;

      -------Dev2:Pure Finance:End:[Nishant Ankam]_[26/06/2013]----------------------------------------------------------------
      SELECT lic_price,
             lic_markup_percent,
             lic_lee_number,
             lic_chs_number,
             lic_start,
             lic_end,
             lic_period_tba,
             lic_currency,
             lic_rate,
             lic_showing_int,
             lic_showing_lic,
             lic_max_cha,
             lic_max_chs,
             lic_amort_code,
             lic_budget_code,
             lic_entry_oper,
             lic_con_number                                --,con_catchup_flag
                           ,
             NVL (lic_catchup_flag, 'N')
        INTO o_lic_price,
             o_lic_markup_percent,
             o_lic_lee_number_new,
             o_lic_chs_number_new,
             o_lic_start,
             o_lic_end,
             o_lic_period_tba,
             o_lic_currency,
             o_rat_rate,
             o_lic_showing_int,
             o_lic_showing_lic,
             o_lic_max_cha,
             o_lic_max_chs,
             o_lic_amort_code,
             o_lic_budget_code,
             o_entry_oper,
             o_lic_con_number,
             l_con_catchup_flag
        FROM fid_license, fid_contract
       WHERE lic_con_number = con_number AND lic_number = i_lic_number;

      SELECT NVL (SUM (lcr_runs_allocated), 0)
        INTO l_total_allocated_runs
        FROM fid_license_channel_runs
       WHERE lcr_lic_number = i_lic_number;

      IF (o_lic_showing_int = i_lic_showing_int)
      THEN
         IF l_total_allocated_runs <> i_lic_showing_int
         THEN
            l_lic_showing_int_new := l_total_allocated_runs;
         ELSE
            l_lic_showing_int_new := i_lic_showing_int;
         END IF;
      ELSE
         l_lic_showing_int_new := i_lic_showing_int;
      END IF;

      -- DBMS_OUTPUT.put_line (1 || l_lic_currency);

      BEGIN
         IF NVL (TRIM (l_lic_currency), 'XXX') !=
               NVL (TRIM (i_lic_currency), 'XYX')
         THEN
            SELECT rat_rate
              INTO l_rat_rate
              FROM fid_exchange_rate
             WHERE rat_cur_code = i_lic_currency AND rat_cur_code_2 = 'SAR';
         ELSE
            l_rat_rate := 0;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_message := 'Exchange Rate not found for this Currency';
            raise_application_error (-20010, l_message);
         WHEN OTHERS
         THEN
            o_status := 0;
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      BEGIN
         --  DBMS_OUTPUT.put_line (l_rat_rate);

         /* PB (CR 6) :Pranay Kusumwal 18/07/2012 : Added for validation for Amort Exhibitions */
         BEGIN
            SELECT NVL (lic_showing_lic, 0)
              INTO l_showing_lic
              FROM fid_license
             WHERE lic_number = i_lic_number;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_showing_lic := NULL;
            WHEN OTHERS
            THEN
               raise_application_error (-20602, SUBSTR (SQLERRM, 1, 200));
         END;

         SELECT COUNT (*)
           INTO count_exh
           FROM fid_schedule
          WHERE TO_DATE (sch_per_year || sch_per_month, 'YYYYMM') IN
                   (SELECT TO_DATE (fim_year || fim_month, 'YYYYMM')
                      FROM fid_financial_month
                     WHERE fim_status = 'C')
                AND sch_lic_number = i_lic_number
                AND sch_type = 'P';

         IF l_showing_lic <> i_lic_showing_lic
         THEN
            IF i_lic_showing_lic < count_exh
            THEN
               RAISE exh_exceed_failed;
            END IF;
         END IF;

         ------ DEV3: SAP Implementation:Start:<24/7/2013>:<payment plan changes for catchup licenses>-------
         /*IF l_con_catchup_flag = 'Y' or l_con_catchup_flag = 'S'*/
         -- 19/03/15 for SVOD added 'S'
         /*Above If condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
         IF NVL (l_con_catchup_flag, 'N') <> 'N'
         THEN
            SELECT gen_ser_number
              INTO l_ser_number
              FROM fid_general
             WHERE gen_refno = i_lic_gen_refno;

---fincr need
            FOR rec_lic
               IN (SELECT lic_number, lic_price
                     FROM fid_license
                    WHERE ( (i_contract_series = 'S'
                             AND lic_con_number = i_lic_con_number
                             AND lic_gen_refno IN
                                    (SELECT gen_refno
                                       FROM fid_general
                                      WHERE gen_ser_number = l_ser_number))
                           OR (i_contract_series = 'C'
                               AND lic_con_number = i_lic_con_number))
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_status NOT IN ('I', 'T'))
            LOOP
               SELECT lic_price
                 INTO l_lic_price
                 FROM fid_license
                WHERE lic_number = rec_lic.lic_number;

               IF i_lic_price <> l_lic_price
               THEN
                  SELECT lsl_number
                    INTO l_lsl_number
                    FROM x_fin_lic_sec_lee
                   WHERE lsl_lic_number = rec_lic.lic_number;

                  --------License price change functionality through procedure--------------------------------------------------------------
                  BEGIN
                     x_prc_lic_price_change (rec_lic.lic_number,
                                             l_lsl_number,
                                             i_lic_lee_number,
                                             l_lic_price,
                                             i_lic_price,
                                             i_entry_oper,
                                             i_trnsfr_pmnt_flag);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        raise_application_error (
                           -20555,
                           'Error in price change'
                           || SUBSTR (SQLERRM, 1, 200));
                  END;
               ---------End functionality---------------------------------------------------------------------------------------------------
               END IF;
            /* IF l_lic_price = 0
             THEN
                SELECT mem_agy_com_number, mem_com_number
                  INTO l_mem_agy_com_number, l_mem_com_number
                  FROM sak_memo
                 WHERE mem_id IN (SELECT lic_mem_number
                                    FROM fid_license
                                   WHERE lic_number = rec_lic.lic_number);

                SELECT lic_con_number, lic_currency
                  INTO l_con_number, l_lic_currency
                  FROM fid_license
                 WHERE lic_number = rec_lic.lic_number;

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
                             pay_lic_number, pay_status,
                             pay_status_date, pay_amount, pay_cur_code,
                             pay_rate, pay_code, pay_due, pay_reference,
                             pay_comment, pay_supplier_invoice,
                             pay_entry_date, pay_entry_oper,
                             pay_month_no, pay_lsl_number,
                             pay_original_payment, pay_payment_pct
                            )
                     VALUES (seq_pay_number.NEXTVAL, sourcecom,
                             targetcom, l_con_number,
                             rec_lic.lic_number, 'N',
                             SYSDATE, i_lic_price, l_lic_currency,
                             NULL, 'G', TRUNC (SYSDATE), NULL,
                             NULL, NULL,
                             SYSDATE, i_entry_oper,
                             NULL, l_lsl_number,
                             'Y', 100
                            );
             ELSIF i_lic_price = 0
             THEN
                SELECT COUNT (*)
                  INTO l_cnt
                  FROM fid_payment
                 WHERE pay_lsl_number = l_lsl_number AND pay_status = 'P';

                SELECT pkg_cm_username.setusername (i_entry_oper)
                  INTO l_number
                  FROM DUAL;

                DELETE FROM fid_payment
                      WHERE pay_lsl_number = l_lsl_number
                        AND pay_status = 'N';

                IF l_cnt > 0
                THEN
                   SELECT NVL (SUM (pay_amount), 0)
                     INTO l_paid_amt
                     FROM fid_payment
                    WHERE pay_lsl_number = l_lsl_number
                      AND pay_status = 'P';

                   FOR pay IN (SELECT pay_source_com_number,
                                      pay_target_com_number,
                                      pay_con_number, pay_cur_code,
                                      pay_code, pay_amount, pay_status,
                                      pay_due, pay_month_no,
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
                                      pay_con_number,
                                      pay_lic_number, pay_status,
                                      pay_status_date, pay_amount,
                                      pay_cur_code, pay_rate,
                                      pay_code,
                                      pay_due, pay_reference,
                                      pay_comment,
                                      pay_supplier_invoice,
                                      pay_entry_date, pay_entry_oper,
                                      pay_month_no,
                                      pay_lsl_number,
                                      pay_original_payment,
                                      pay_payment_pct
                                     )
                              VALUES (seq_pay_number.NEXTVAL,
                                      pay.pay_source_com_number,
                                      pay.pay_target_com_number,
                                      pay.pay_con_number,
                                      rec_lic.lic_number, 'N',
                                      SYSDATE, -l_paid_amt,
                                      pay.pay_cur_code, NULL,
                                      pay.pay_code,
                                      LAST_DAY (TRUNC (SYSDATE)), NULL,
                                         'Refund Required owing to Price Change on '
                                      || TO_CHAR (TRUNC (SYSDATE),
                                                  'DD-Mon-RRRR'
                                                 ),
                                      NULL,
                                      SYSDATE, i_entry_oper,
                                      pay.pay_month_no,
                                      pay.pay_lsl_number,
                                      'Y',
                                      NULL
                                     );
                      EXCEPTION
                         WHEN OTHERS
                         THEN
                            raise_application_error (-20601,
                                                     SUBSTR (SQLERRM,
                                                             1,
                                                             200
                                                            )
                                                    );
                      END;
                   END LOOP;
                END IF;
             ELSIF i_lic_price > l_lic_price
             THEN
                ----for all paid payment
                SELECT COUNT (*)
                  INTO l_count
                  FROM fid_payment
                 WHERE pay_lic_number = rec_lic.lic_number
                   AND pay_lsl_number = l_lsl_number
                   AND pay_status = 'N';

                IF l_count = 0
                THEN
                   l_flag1 := 'paid';
                END IF;

                SELECT COUNT (*)
                  INTO l_count1
                  FROM fid_payment
                 WHERE pay_lic_number = rec_lic.lic_number
                   AND pay_lsl_number = l_lsl_number
                   AND pay_status = 'P';

                IF l_count1 = 0
                THEN
                   l_flag1 := 'notpaid';
                END IF;

                IF l_flag1 = 'paid'    ---for all paid payment(scenario3)
                THEN
                   FOR pay IN (SELECT pay_source_com_number,
                                      pay_target_com_number,
                                      pay_con_number, pay_cur_code,
                                      pay_code, pay_amount, pay_status,
                                      pay_due, pay_month_no,
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
                                      pay_con_number,
                                      pay_lic_number, pay_status,
                                      pay_status_date,
                                      pay_amount,
                                      pay_cur_code, pay_rate,
                                      pay_code,
                                      pay_due, pay_reference,
                                      pay_comment,
                                      pay_supplier_invoice,
                                      pay_entry_date, pay_entry_oper,
                                      pay_month_no,
                                      pay_lsl_number,
                                      pay_original_payment,
                                      pay_payment_pct
                                     )
                              VALUES (seq_pay_number.NEXTVAL,
                                      pay.pay_source_com_number,
                                      pay.pay_target_com_number,
                                      pay.pay_con_number,
                                      rec_lic.lic_number, 'N',
                                      SYSDATE,
                                      (i_lic_price - l_lic_price
                                      ),
                                      pay.pay_cur_code, NULL,
                                      pay.pay_code,
                                      LAST_DAY (TRUNC (SYSDATE)), NULL,
                                         'Additional Payment owing to Price Change on '
                                      || TO_CHAR (TRUNC (SYSDATE),
                                                  'DD-Mon-RRRR'
                                                 ),
                                      NULL,
                                      SYSDATE, i_entry_oper,
                                      pay.pay_month_no,
                                      pay.pay_lsl_number,
                                      'Y',
                                      NULL
                                     );
                      EXCEPTION
                         WHEN OTHERS
                         THEN
                            raise_application_error (-20601,
                                                     SUBSTR (SQLERRM,
                                                             1,
                                                             200
                                                            )
                                                    );
                      END;
                   END LOOP;
                ELSIF l_flag1 = 'notpaid'
                ---for all paid payment(scenario4)
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
                                ROUND (  i_lic_price
                                       * (pay.pay_amount / l_notpaid_amt1
                                         ),
                                       2
                                      ),
                             pay_comment =
                                   'Updated Payment owing to Price Change on '
                                || TO_CHAR (TRUNC (SYSDATE),
                                            'DD-Mon-RRRR'
                                           )
                       WHERE pay_number = pay.pay_number;
                   END LOOP;
                ELSE                       ---for scenario1 and scenario2
                   SELECT SUM (pay_amount)
                     INTO l_paid_amt
                     FROM fid_payment
                    WHERE pay_lsl_number = l_lsl_number
                      AND pay_status = 'P';

                   SELECT SUM (pay_amount)
                     INTO l_notpaid_amt1
                     FROM fid_payment
                    WHERE pay_lsl_number = l_lsl_number
                      AND pay_status = 'N';

                   FOR pay IN (SELECT pay_number, pay_amount
                                 FROM fid_payment
                                WHERE pay_lsl_number = l_lsl_number
                                  AND pay_status = 'N')
                   LOOP
                      UPDATE fid_payment
                         SET pay_amount =
                                ROUND (  i_lic_price
                                       * (  pay.pay_amount
                                          / (l_paid_amt + l_notpaid_amt1
                                            )
                                         ),
                                       2
                                      ),
                             pay_comment =
                                   'Updated Payment owing to Price Change on '
                                || TO_CHAR (TRUNC (SYSDATE),
                                            'DD-Mon-RRRR'
                                           )
                       WHERE pay_number = pay.pay_number;
                   END LOOP;

                   SELECT SUM (pay_amount)
                     INTO l_notpaid_amt
                     FROM fid_payment
                    WHERE pay_lsl_number = l_lsl_number
                      AND pay_status = 'N';

                   l_remain_amt :=
                               i_lic_price
                               - (l_paid_amt + l_notpaid_amt);

                   FOR pay IN (SELECT pay_source_com_number,
                                      pay_target_com_number,
                                      pay_con_number, pay_cur_code,
                                      pay_code, pay_amount, pay_status,
                                      pay_due, pay_month_no,
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
                                      pay_con_number,
                                      pay_lic_number, pay_status,
                                      pay_status_date, pay_amount,
                                      pay_cur_code, pay_rate,
                                      pay_code,
                                      pay_due, pay_reference,
                                      pay_comment,
                                      pay_supplier_invoice,
                                      pay_entry_date, pay_entry_oper,
                                      pay_month_no,
                                      pay_lsl_number,
                                      pay_original_payment,
                                      pay_payment_pct
                                     )
                              VALUES (seq_pay_number.NEXTVAL,
                                      pay.pay_source_com_number,
                                      pay.pay_target_com_number,
                                      pay.pay_con_number,
                                      rec_lic.lic_number, 'N',
                                      SYSDATE, l_remain_amt,
                                      pay.pay_cur_code, NULL,
                                      pay.pay_code,
                                      LAST_DAY (TRUNC (SYSDATE)), NULL,
                                         'Additional Payment owing to Price Change on '
                                      || TO_CHAR (TRUNC (SYSDATE),
                                                  'DD-Mon-RRRR'
                                                 ),
                                      NULL,
                                      SYSDATE, i_entry_oper,
                                      pay.pay_month_no,
                                      pay.pay_lsl_number,
                                      'Y',
                                      NULL
                                     );
                      EXCEPTION
                         WHEN OTHERS
                         THEN
                            raise_application_error (-20601,
                                                     SUBSTR (SQLERRM,
                                                             1,
                                                             200
                                                            )
                                                    );
                      END;
                   END LOOP;
                END IF;
             ELSE
                ------for licensee allocation less than already allocated
                --  if i_lic_price < l_lic_price
                -- then
                ----for all paid payment
                SELECT COUNT (*)
                  INTO l_count
                  FROM fid_payment
                 WHERE pay_lic_number = rec_lic.lic_number
                   AND pay_lsl_number = l_lsl_number
                   AND pay_status = 'N';

                IF l_count = 0
                THEN
                   l_flag1 := 'paid';
                END IF;

                SELECT COUNT (*)
                  INTO l_count1
                  FROM fid_payment
                 WHERE pay_lic_number = rec_lic.lic_number
                   AND pay_lsl_number = l_lsl_number
                   AND pay_status = 'P';

                IF l_count1 = 0
                THEN
                   l_flag1 := 'notpaid';
                END IF;

                IF l_flag1 = 'paid'   ----for all paid payment(scenario7)
                THEN
                   FOR pay IN (SELECT pay_source_com_number,
                                      pay_target_com_number,
                                      pay_con_number, pay_cur_code,
                                      pay_code, pay_amount, pay_status,
                                      pay_due, pay_month_no,
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
                                      pay_con_number,
                                      pay_lic_number, pay_status,
                                      pay_status_date,
                                      pay_amount,
                                      pay_cur_code, pay_rate,
                                      pay_code,
                                      pay_due, pay_reference,
                                      pay_comment,
                                      pay_supplier_invoice,
                                      pay_entry_date, pay_entry_oper,
                                      pay_month_no,
                                      pay_lsl_number,
                                      pay_original_payment,
                                      pay_payment_pct
                                     )
                              VALUES (seq_pay_number.NEXTVAL,
                                      pay.pay_source_com_number,
                                      pay.pay_target_com_number,
                                      pay.pay_con_number,
                                      rec_lic.lic_number, 'N',
                                      SYSDATE,
                                      (i_lic_price - l_lic_price
                                      ),
                                      pay.pay_cur_code, NULL,
                                      pay.pay_code,
                                      LAST_DAY (TRUNC (SYSDATE)), NULL,
                                         'Refund Required owing to Price Change on '
                                      || TO_CHAR (TRUNC (SYSDATE),
                                                  'DD-Mon-RRRR'
                                                 ),
                                      NULL,
                                      SYSDATE, i_entry_oper,
                                      pay.pay_month_no,
                                      pay.pay_lsl_number,
                                      'Y',
                                      NULL
                                     );
                      EXCEPTION
                         WHEN OTHERS
                         THEN
                            raise_application_error (-20601,
                                                     SUBSTR (SQLERRM,
                                                             1,
                                                             200
                                                            )
                                                    );
                      END;
                   END LOOP;
                ELSIF l_flag1 = 'notpaid'
                ----for all not paid payment(scenario8)
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
                                ROUND (  i_lic_price
                                       * (pay.pay_amount / l_notpaid_amt
                                         ),
                                       2
                                      ),
                             pay_comment =
                                   'Updated Payment owing to Price Change on '
                                || TO_CHAR (TRUNC (SYSDATE),
                                            'DD-Mon-RRRR'
                                           )
                       WHERE pay_number = pay.pay_number;
                   END LOOP;
                ELSE                       ---for scenario5 and scenario6
                   SELECT SUM (pay_amount)
                     INTO l_paid_amt
                     FROM fid_payment
                    WHERE pay_lsl_number = l_lsl_number
                      AND pay_status = 'P';

                   l_remain_amt := i_lic_price - l_paid_amt;

                   ----------------when new price is less than total paid price
                   IF l_remain_amt < 0
                   THEN
                      SELECT pkg_cm_username.setusername (i_entry_oper)
                        INTO l_number
                        FROM DUAL;

                      DELETE FROM fid_payment
                            WHERE pay_lsl_number = l_lsl_number
                              AND pay_status = 'N';

                      FOR pay IN (SELECT pay_source_com_number,
                                         pay_target_com_number,
                                         pay_con_number, pay_cur_code,
                                         pay_code, pay_amount,
                                         pay_status, pay_due,
                                         pay_month_no, pay_lsl_number
                                    FROM fid_payment
                                   WHERE pay_lsl_number = l_lsl_number
                                     AND ROWNUM < 2)
                      LOOP
                         INSERT INTO fid_payment
                                     (pay_number,
                                      pay_source_com_number,
                                      pay_target_com_number,
                                      pay_con_number,
                                      pay_lic_number, pay_status,
                                      pay_status_date, pay_amount,
                                      pay_cur_code, pay_rate,
                                      pay_code,
                                      pay_due, pay_reference,
                                      pay_comment,
                                      pay_supplier_invoice,
                                      pay_entry_date, pay_entry_oper,
                                      pay_month_no,
                                      pay_lsl_number,
                                      pay_original_payment,
                                      pay_payment_pct
                                     )
                              VALUES (seq_pay_number.NEXTVAL,
                                      pay.pay_source_com_number,
                                      pay.pay_target_com_number,
                                      pay.pay_con_number,
                                      rec_lic.lic_number, 'N',
                                      SYSDATE, l_remain_amt,
                                      pay.pay_cur_code, NULL,
                                      pay.pay_code,
                                      LAST_DAY (TRUNC (SYSDATE)), NULL,
                                         'Refund Required owing to Price Change on '
                                      || TO_CHAR (TRUNC (SYSDATE),
                                                  'DD-Mon-RRRR'
                                                 ),
                                      NULL,
                                      SYSDATE, i_entry_oper,
                                      pay.pay_month_no,
                                      pay.pay_lsl_number,
                                      'Y',
                                      NULL
                                     );
                      END LOOP;
                   ELSE
                      ---------------when new price is greater than than total paid price
                      SELECT SUM (pay_amount)
                        INTO l_notpaid_amt
                        FROM fid_payment
                       WHERE pay_lsl_number = l_lsl_number
                         AND pay_status = 'N';

                      FOR pay IN (SELECT pay_number, pay_amount
                                    FROM fid_payment
                                   WHERE pay_lsl_number = l_lsl_number
                                     AND pay_status = 'N')
                      LOOP
                         UPDATE fid_payment
                            SET pay_amount =
                                   ROUND (  l_remain_amt
                                          * (  pay.pay_amount
                                             / l_notpaid_amt
                                            ),
                                          2
                                         ),
                                pay_comment =
                                      'Updated Payment owing to Price Change on '
                                   || TO_CHAR (TRUNC (SYSDATE),
                                               'DD-Mon-RRRR'
                                              )
                          WHERE pay_number = pay.pay_number;
                      END LOOP;
                   END IF;
                END IF;
             END IF;

             -----rounding off payment up to 2 decimal-------------------------
             SELECT SUM (pay_amount)
               INTO l_total_pay_price
               FROM fid_payment
              WHERE pay_lic_number = rec_lic.lic_number
                AND pay_lsl_number = l_lsl_number;

             l_extra_pay_amt := l_total_pay_price - i_lic_price;

             IF l_extra_pay_amt <> 0
             THEN
                SELECT MIN (pay_number)
                  INTO l_pay_number
                  FROM fid_payment
                 WHERE pay_lic_number = rec_lic.lic_number
                   AND pay_lsl_number = l_lsl_number
                   AND pay_status = 'N';

                UPDATE fid_payment
                   SET pay_amount = pay_amount - l_extra_pay_amt
                 WHERE pay_number = l_pay_number;
             END IF;
          -------end rounding off------------------------------------------
          END IF;*/
            END LOOP;
         END IF;

         ------ DEV3: SAP Implementation:End:<24/7/2013>-----------------------------



         /* PB (CR 6) :Pranay Kusumwal 18/07/2012 :end */
         IF NVL (TRIM (i_contract_series), 'X') = 'C'
         THEN
            --  DBMS_OUTPUT.put_line ('in contract');

            /*  UPDATE fid_license
                 SET lic_price = decode(i_lic_price,
                     lic_markup_percent = i_lic_markup_percent,
                     lic_lee_number = i_lic_lee_number_new,
                     lic_chs_number = i_lic_chs_number_new,
                     lic_start = i_lic_start,
                     lic_end = i_lic_end,
                     --lic_period_tba= DECODE(oldpertba,newpertba,lic_period_tba,newpertba),
                     lic_period_tba = i_lic_period_tba,
                     lic_currency = i_lic_currency,
                     lic_rate = l_rat_rate,
                     lic_showing_int = i_lic_showing_int,
                     lic_showing_lic = i_lic_showing_lic,
                     lic_max_cha = i_lic_max_cha,
                     lic_max_chs = i_lic_max_chs,
                     lic_amort_code = i_lic_amort_code,
                     lic_budget_code = i_lic_budget_code,
                     lic_entry_oper = i_entry_oper
               WHERE                             --lic_number = i_lic_number AND
                     lic_con_number = i_lic_con_number
                 AND lic_lee_number = i_lic_lee_number
                 AND lic_chs_number = i_lic_chs_number
                 AND lic_status <> 'I';  */

            /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
            /*IF l_con_catchup_flag = 'Y' or l_con_catchup_flag = 'S'*/
            -- 19/03/15 for SVOD added 'S'
            /*Above If condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
            IF NVL (l_con_catchup_flag, 'N') <> 'N'
            THEN
               /*Swapnil on 10-jun-2015 for SVOD */
               IF NVL (l_con_catchup_flag, 'N') = 'Y'
               THEN
                  SELECT ( (SELECT COUNT (DISTINCT plt_sch_number)
                              FROM x_cp_play_list
                             WHERE plt_lic_number = aa.lic_number
                                   AND PLT_LICENSE_FLAG = l_con_catchup_flag)
                          + DECODE (
                               ab.lee_short_name,
                               'CAFR', (SELECT COUNT (sch_number)
                                          FROM fid_schedule
                                         WHERE sch_lic_number = aa.lic_number),
                               DECODE (
                                  (SELECT COUNT (sch_number)
                                     FROM fid_schedule
                                    WHERE sch_lic_number = aa.lic_number),
                                  0, (SELECT COUNT (sch_number)
                                        FROM fid_schedule, fid_license
                                       WHERE sch_lic_number = lic_number
                                             AND lic_lee_number = 319
                                             AND lic_gen_refno =
                                                    aa.lic_gen_refno
                                             AND lic_con_number =
                                                    aa.lic_con_number),
                                  (SELECT COUNT (sch_number)
                                     FROM fid_schedule
                                    WHERE sch_lic_number = aa.lic_number))))
                    INTO l_maxvp_used
                    FROM fid_license aa, fid_licensee ab
                   WHERE aa.lic_lee_number = ab.lee_number
                         AND aa.lic_number = i_lic_number;
               ELSE
                  SELECT (SELECT COUNT (DISTINCT plt_sch_number)
                            FROM x_cp_play_list
                           WHERE plt_lic_number = aa.lic_number
                                 AND PLT_LICENSE_FLAG = l_con_catchup_flag)
                    INTO l_maxvp_used
                    FROM fid_license aa, fid_licensee ab
                   WHERE aa.lic_lee_number = ab.lee_number
                         AND aa.lic_number = i_lic_number;
               END IF;

               /*Swapnil on 10-jun-2015 for SVOD ends here*/

               --Dev2: Costing 5+2 Rules :Vihal Patel_20140506 : Validation check for update with respect to license start date
               SELECT MIN (lic_start)
                 INTO l_min_lic_start
                 FROM fid_license
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_status <> 'I'
                      AND lic_status <> 'C';

               SELECT MAX (lic_start)
                 INTO l_max_lic_start
                 FROM fid_license
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_status <> 'I'
                      AND lic_status <> 'C';

               IF (l_min_lic_start IS NOT NULL
                   AND l_max_lic_start IS NOT NULL)
               THEN
                  IF (i_lic_start >= v_go_live_crc_date)
                  THEN
                     NULL;
                  /*IF (l_min_lic_start < v_go_live_crc_date
                      AND l_max_lic_start > v_go_live_crc_date)
                  THEN
                     ROLLBACK;
                     o_status := '-1';
                     raise_application_error (
                        -20601,
                        'Licenses have different costing rule applicable to them, cannot be copied.');
                  END IF;*/
                  ELSE
                     IF (l_max_lic_start >= v_go_live_crc_date)
                     THEN
                        ROLLBACK;
                        o_status := '-1';
                        raise_application_error (
                           -20601,
                           'Licenses have different costing rule applicable to them, cannot be copied.');
                     END IF;
                  END IF;
               END IF;

               --Dev2: Costing 5+2 Rules :Vihal Patel_20140506 : End

               FOR z
                  IN (SELECT lic_number, lic_period_tba
                        FROM fid_license
                       WHERE lic_con_number = i_lic_con_number
                             AND lic_lee_number = i_lic_lee_number)
               LOOP
                  IF o_lic_period_tba <> i_lic_period_tba
                  THEN
                     prc_cp_tbachanged (z.lic_number, l_tba_flag);
                  ----NULL;
                  END IF;
               END LOOP;

               IF i_lic_period_tba = 'Y'
               THEN
                  SELECT COUNT (0)
                    INTO l_cnt
                    FROM x_cp_play_list
                   WHERE plt_lic_number = i_lic_number
                         AND PLT_LICENSE_FLAG = l_con_catchup_flag;

                  IF l_cnt = 0
                  THEN
                     l_schedule_flag := 'N';
                  ELSE
                     l_schedule_flag := 'Y';
                  END IF;

                  IF l_schedule_flag = 'Y'
                  THEN
                     raise_application_error (
                        -20601,
                           'The license '
                        || i_lic_number
                        || ' is scheduled.Cannot change period to TBA.');
                  END IF;
               END IF;

               IF i_lic_showing_int < l_maxvp_used
               THEN
                  raise_application_error (
                     -20102,
                     'The Max No. of Viewing Periods cannot be less than the No. of Viewing Periods used.');
               END IF;

               x_pkg_cp_license_upd_validate.prc_cp_lic_before_upd_valid (
                  i_lic_number,
                  i_lic_start,
                  i_lic_end,
                  i_lic_chs_number_new,
                  NULL,
                  i_max_vp_in_days,
                  i_sch_aft_prem_linear,
                  i_non_cons_month,
                  i_lic_price,
                  i_lic_showing_int,
                  i_lic_showing_lic,
                  i_lic_amort_code,
                  i_lic_period_tba,
                  i_entry_oper);

               IF i_lic_start != o_lic_start OR i_lic_end != o_lic_end
               THEN
                  SELECT NVL (lic_catchup_flag, 'N'),
                         lic_start,
                         lic_end,
                         lic_con_number,
                         lic_gen_refno,
                         lic_lee_number,
                         lic_showing_lic,
                         lic_showing_int,
                         lic_max_viewing_period,
                         lic_non_cons_month,
                         lic_budget_code,
                         lic_sch_aft_prem_linear,
                         NVL (con_sch_within_x_frm_ply_fea, 0),
                         NVL (con_sch_within_x_frm_ply_ser, 0),
                         NVL (con_not_allow_aft_x_start_lic, 0),
                         NVL (con_not_allow_bef_x_end_lic_dt, 0),
                         lic_period_tba,
                         lee_region_id
                    INTO l_cp_flg,
                         l_lic_start,
                         l_lic_end,
                         l_con_number,
                         l_lic_gen_refno,
                         l_lee_number,
                         l_lic_showing_lic,
                         l_lic_showing_int,
                         l_lic_max_viewing_period,
                         l_consecative_flag,
                         l_lic_budget_code,
                         l_sch_aft_prem_linear,
                         l_sch_within_x_frm_ply_fea,
                         l_sch_within_x_frm_ply_ser,
                         l_not_allow_aft_x_start_lic,
                         l_not_allow_bef_x_end_lic_dt,
                         l_lic_period_tba,
                         l_lee_region_id
                    FROM fid_license, fid_contract, fid_licensee
                   WHERE     lic_con_number = con_number
                         AND lee_number = lic_lee_number
                         AND lic_number = i_lic_number;

                  BEGIN
                     SELECT lic_start,
                            lic_end,
                            lic_number,
                            lic_period_tba
                       INTO l_lnr_lic_start,
                            l_lnr_lic_end,
                            l_lnr_lic_number,
                            l_lnr_lic_period_tba
                       FROM (  SELECT lic_start,
                                      lic_end,
                                      lic_number,
                                      lic_period_tba
                                 FROM fid_license, fid_licensee
                                WHERE     lic_lee_number = lee_number
                                      AND lee_region_id = l_lee_region_id
                                      AND lic_con_number = l_con_number
                                      AND lic_status = 'A'
                                      AND lic_gen_refno = l_lic_gen_refno
                                      AND NVL (lic_catchup_flag, 'N') = 'N'
                                      AND lic_lee_number <> 319
                             ORDER BY lic_start)
                      WHERE ROWNUM < 2;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  END;

                  IF i_lic_period_tba <> 'Y'
                  THEN
                     IF (i_lic_start <
                            (l_lnr_lic_start + l_not_allow_aft_x_start_lic)
                         OR i_lic_end >
                               (l_lnr_lic_end - l_not_allow_bef_x_end_lic_dt))
                        /*Swapnil 11-jun-2015 Added the below condition for SVOD*/
                        AND NVL (l_con_catchup_flag, 'N') = 'Y'
                     THEN
                        raise_application_error (
                           -20102,
                           ' Catchup license should fall between Linear License Start Date and End Date. ');
                     END IF;
                  END IF;
               END IF;

               --  DBMS_OUTPUT.put_line ('in contractT');

               FOR z
                  IN (SELECT lic_number, lic_start, lic_end
                        FROM fid_license
                       WHERE lic_con_number = i_lic_con_number
                             AND lic_lee_number = i_lic_lee_number)
               LOOP
                  IF o_lic_start <> i_lic_start
                  THEN
                     prc_alic_cm_validatestartdate (z.lic_number,
                                                    i_lic_start);
                  END IF;

                  IF o_lic_end <> i_lic_end
                  THEN
                     prc_alic_cm_validateenddate (z.lic_number, i_lic_end);
                  END IF;
               END LOOP;

               UPDATE fid_license
                  SET lic_price =
                         DECODE (o_lic_price,
                                 i_lic_price, lic_price,
                                 i_lic_price),
                      lic_markup_percent =
                         DECODE (o_lic_markup_percent,
                                 i_lic_markup_percent, lic_markup_percent,
                                 i_lic_markup_percent),
                      lic_lee_number = i_lic_lee_number_new,
                      lic_chs_number = NULL,
                      lic_start =
                         DECODE (o_lic_start,
                                 i_lic_start, lic_start,
                                 i_lic_start),
                      lic_end =
                         DECODE (o_lic_end, i_lic_end, lic_end, i_lic_end),
                      lic_period_tba =
                         DECODE (o_lic_period_tba,
                                 i_lic_period_tba, lic_period_tba,
                                 i_lic_period_tba),
                      lic_currency = i_lic_currency,
                      lic_rate =
                         DECODE (o_lic_currency,
                                 i_lic_currency, lic_rate,
                                 l_rat_rate),
                      lic_showing_int =
                         DECODE (o_lic_showing_int,
                                 i_lic_showing_int, lic_showing_int,
                                 i_lic_showing_int),
                      lic_showing_lic =
                         DECODE (o_lic_showing_lic,
                                 i_lic_showing_lic, lic_showing_lic,
                                 i_lic_showing_lic),
                      lic_max_cha =
                         DECODE (o_lic_max_cha,
                                 i_lic_max_cha, lic_max_cha,
                                 i_lic_max_cha),
                      lic_max_chs =
                         DECODE (o_lic_max_chs,
                                 i_lic_max_chs, lic_max_chs,
                                 i_lic_max_chs),
                      lic_amort_code =
                         DECODE (o_lic_amort_code,
                                 i_lic_amort_code, lic_amort_code,
                                 i_lic_amort_code),
                      lic_budget_code =
                         DECODE (o_lic_budget_code,
                                 i_lic_budget_code, lic_budget_code,
                                 i_lic_budget_code),
                      lic_entry_oper = i_entry_oper,
                      -- Project Bioscope : Ajit_20120319 : Time Shift Flag added
                      lic_time_shift_cha_flag = i_timeshiftchannel,
                      -- Project Bioscope : Ajit_20120319 : End
                      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
                      lic_simulcast_cha_flag = i_simulcastchannel /* PB (CR 12) :END */
                                                                 /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
                      ,
                      lic_max_viewing_period = i_max_vp_in_days,
                      lic_sch_aft_prem_linear = i_sch_aft_prem_linear,
                      lic_non_cons_month = i_non_cons_month,
                      /* Catchup CACQ11 : End 03/12/2012 */

                      -- Dev2: Non Costed Fillers: Start:[Magic License Copier]_[ADITYA GUPTA]_[2013/3/15]
                      -- [Magic License Copier Search Screen modifications for incorporating Non-Costed Fillers changes]
                      lic_free_rpt = i_lic_free_rpt,
                      lic_rpt_period = i_lic_rpt_period
                -- Dev2: Non Costed Fillers: End
                WHERE                          --lic_number = i_lic_number AND
                     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      -- AND lic_chs_number = i_lic_chs_number
                      AND lic_status NOT IN ('C', 'I', 'T');

               -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
               o_count := SQL%ROWCOUNT;
            --   DBMS_OUTPUT.put_line ('pQ');
            --   DBMS_OUTPUT.put_line (l_con_catchup_flag);
            ELSE
               FOR z
                  IN (SELECT lic_number, lic_start, lic_end
                        FROM fid_license
                       WHERE lic_con_number = i_lic_con_number
                             AND lic_lee_number = i_lic_lee_number)
               LOOP
                  IF o_lic_start <> i_lic_start
                  THEN
                     prc_alic_cm_validatestartdate (z.lic_number,
                                                    i_lic_start);
                  END IF;

                  IF o_lic_end <> i_lic_end
                  THEN
                     prc_alic_cm_validateenddate (z.lic_number, i_lic_end);
                  END IF;
               END LOOP;

               --   DBMS_OUTPUT.put_line ('in contractTT');
               --   DBMS_OUTPUT.put_line (i_lic_chs_number_new);

               --Dev2: Costing 5+2 Rules :Vihal Patel_20140506 : Validation check for update with respect to license start date
               SELECT MIN (lic_start)
                 INTO l_min_lic_start
                 FROM fid_license
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_status <> 'I'
                      AND lic_status <> 'C';

               SELECT MAX (lic_start)
                 INTO l_max_lic_start
                 FROM fid_license
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_status <> 'I'
                      AND lic_status <> 'C';

               IF (l_min_lic_start IS NOT NULL
                   AND l_max_lic_start IS NOT NULL)
               THEN
                  IF (i_lic_start >= v_go_live_crc_date)
                  THEN
                     /*  IF (l_min_lic_start < v_go_live_crc_date
                           AND l_max_lic_start > v_go_live_crc_date)
                       THEN
                          ROLLBACK;
                          o_status := '-1';
                          raise_application_error (
                             -20601,
                             'Licenses have different costing rule applicable to them, cannot be copied.');
                       END IF;*/
                     NULL;
                  ELSE
                     IF (l_max_lic_start >= v_go_live_crc_date)
                     THEN
                        ROLLBACK;
                        o_status := '-1';
                        raise_application_error (
                           -20601,
                           'Licenses have different costing rule applicable to them, cannot be copied.');
                     END IF;
                  END IF;
               END IF;

               --Dev2: Costing 5+2 Rules :Vihal Patel_20140506 : End

               UPDATE fid_license
                  SET lic_price =
                         DECODE (o_lic_price,
                                 i_lic_price, lic_price,
                                 i_lic_price),
                      lic_markup_percent =
                         DECODE (o_lic_markup_percent,
                                 i_lic_markup_percent, lic_markup_percent,
                                 i_lic_markup_percent),
                      lic_lee_number = i_lic_lee_number_new,
                      lic_chs_number = i_lic_chs_number_new,
                      lic_start =
                         DECODE (o_lic_start,
                                 i_lic_start, lic_start,
                                 i_lic_start),
                      lic_end =
                         DECODE (o_lic_end, i_lic_end, lic_end, i_lic_end),
                      lic_period_tba =
                         DECODE (o_lic_period_tba,
                                 i_lic_period_tba, lic_period_tba,
                                 i_lic_period_tba),
                      lic_currency = i_lic_currency,
                      lic_rate =
                         DECODE (o_lic_currency,
                                 i_lic_currency, lic_rate,
                                 l_rat_rate),
                      lic_showing_int = l_lic_showing_int_new,
                      ----decode(o_lic_showing_int,i_lic_showing_int,lic_showing_int,i_lic_showing_int),
                      lic_showing_lic =
                         DECODE (o_lic_showing_lic,
                                 i_lic_showing_lic, lic_showing_lic,
                                 i_lic_showing_lic),
                      lic_max_cha =
                         DECODE (o_lic_max_cha,
                                 i_lic_max_cha, lic_max_cha,
                                 i_lic_max_cha),
                      lic_max_chs =
                         DECODE (o_lic_max_chs,
                                 i_lic_max_chs, lic_max_chs,
                                 i_lic_max_chs),
                      lic_amort_code =
                         DECODE (o_lic_amort_code,
                                 i_lic_amort_code, lic_amort_code,
                                 i_lic_amort_code),
                      lic_budget_code =
                         DECODE (o_lic_budget_code,
                                 i_lic_budget_code, lic_budget_code,
                                 i_lic_budget_code),
                      lic_entry_oper = i_entry_oper,
                      -- Project Bioscope : Ajit_20120319 : Time Shift Flag added
                      lic_time_shift_cha_flag = i_timeshiftchannel,
                      -- Project Bioscope : Ajit_20120319 : End
                      /* PB (CR 12) :Pranay Kusumwal 06/07/2012 : Added for Simulcast channel capturing functionality */
                      lic_simulcast_cha_flag = i_simulcastchannel /* PB (CR 12) :END */
                                                                 /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
                      ,
                      lic_max_viewing_period = i_max_vp_in_days,
                      lic_sch_aft_prem_linear = i_sch_aft_prem_linear,
                      lic_non_cons_month = i_non_cons_month,
                      /* Catchup CACQ11 : End 03/12/2012 */

                      -- Dev2: Non Costed Fillers: Start:[Magic License Copier]_[ADITYA GUPTA]_[2013/3/15]
                      -- [Magic License Copier Search Screen modifications for incorporating Non-Costed Fillers changes]
                      lic_free_rpt = i_lic_free_rpt,
                      lic_rpt_period = i_lic_rpt_period
                -- Dev2: Non Costed Fillers: End
                WHERE                          --lic_number = i_lic_number AND
                     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_status NOT IN ('C', 'I', 'T');

               -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
               o_count := SQL%ROWCOUNT;
            END IF;

            IF i_lic_max_cha != o_lic_max_cha
            THEN
               FOR i IN (SELECT lcr_cha_number
                           FROM fid_license_channel_runs
                          WHERE lcr_lic_number = i_lic_number)
               LOOP
                  BEGIN
                     SELECT COUNT (0)
                       INTO l_cha_schedule_exits
                       FROM fid_schedule
                      WHERE sch_lic_number = i_lic_number
                            AND sch_cha_number = i.lcr_cha_number;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        l_cha_schedule_exits := 0;
                  END;

                  IF l_cha_schedule_exits > i_lic_max_cha
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
            END IF;

            IF i_lic_max_chs != o_lic_max_chs
            THEN
               BEGIN
                  SELECT COUNT (0)
                    INTO l_tot_schedule_exits
                    FROM fid_schedule
                   WHERE sch_lic_number = i_lic_number;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_tot_schedule_exits := 0;
               END;

               IF l_tot_schedule_exits > i_lic_max_chs
               THEN
                  ROLLBACK;
                  o_status := '-1';
                  raise_application_error (
                     -20366,
                     'Max Chs cannot be less than total scheduled runs');
               END IF;
            END IF;

            IF i_lic_start != o_lic_start AND i_lic_end != o_lic_end
            THEN
               l_changed_date_flag := 'BOTH';
            ELSIF i_lic_start != o_lic_start
            THEN
               l_changed_date_flag := 'START';
            ELSIF i_lic_end != o_lic_end
            THEN
               l_changed_date_flag := 'END';
            END IF;

            --  DBMS_OUTPUT.put_line ('pkkH');
            --   DBMS_OUTPUT.put_line (l_changed_date_flag);

            FOR i
               IN (SELECT lic_number, lic_period_tba, lic_start
                     FROM fid_license
                    WHERE     lic_con_number = i_lic_con_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_chs_number = i_lic_chs_number
                          AND lic_status NOT IN ('I', 'T'))
            LOOP
               --  DBMS_OUTPUT.put_line ('pkk');
               --  DBMS_OUTPUT.put_line (l_changed_date_flag);
               x_pkg_cp_license_upd_validate.prc_cp_lic_after_upd_valid (
                  i.lic_number,
                  i.lic_period_tba,
                  i.lic_start,
                  l_changed_date_flag,
                  i_entry_oper);
            END LOOP;
         /* end */
         -- DBMS_OUTPUT.put_line ('pkkHQ');
         --  DBMS_OUTPUT.put_line (l_con_catchup_flag);
         --             if l_con_catchup_flag ='Y'
         --             then
         ELSIF NVL (TRIM (i_contract_series), 'X') = 'S'
         THEN
            -- DBMS_OUTPUT.put_line ('in series');

            BEGIN
               SELECT gen_ser_number
                 INTO l_ser_number
                 FROM fid_general
                WHERE gen_refno = i_lic_gen_refno;
            -- DBMS_OUTPUT.put_line (l_ser_number);
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN OTHERS
               THEN
                  raise_application_error (-20602, SUBSTR (SQLERRM, 1, 200));
            END;

            /*       UPDATE fid_license
                      SET lic_price = i_lic_price,
                          lic_markup_percent = i_lic_markup_percent,
                          lic_lee_number = i_lic_lee_number_new,
                          lic_chs_number = i_lic_chs_number_new,
                          lic_start = i_lic_start,
                          lic_end = i_lic_end,
                          -- lic_period_tba     = DECODE(oldpertba,newpertba,lic_period_tba,newpertba),
                          lic_period_tba = i_lic_period_tba,
                          lic_currency = i_lic_currency,
                          lic_rate = l_rat_rate,
                          lic_showing_int = i_lic_showing_int,
                          lic_showing_lic = i_lic_showing_lic,
                          lic_max_cha = i_lic_max_cha,
                          lic_max_chs = i_lic_max_chs,
                          lic_amort_code = i_lic_amort_code,
                          lic_budget_code = i_lic_budget_code,
                          lic_con_number = i_lic_con_number_new,
                          lic_entry_oper = i_entry_oper
                    WHERE                 --lic_number != i_lic_number            AND
                          lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_status <> 'I'
                      AND lic_gen_refno IN (SELECT gen_refno
                                              FROM fid_general
                                             WHERE gen_ser_number = l_ser_number
                                                                                -- AND gen_refno != i_lic_gen_refno
                          );
                */
            /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
            /*IF l_con_catchup_flag in( 'Y','S')*/
            /*Above If condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
            IF NVL (l_con_catchup_flag, 'N') <> 'N'
            THEN
               /*Swapnil on 10-jun-2015 for SVOD */
               IF NVL (l_con_catchup_flag, 'N') = 'Y'
               THEN
                  SELECT ( (SELECT COUNT (DISTINCT plt_sch_number)
                              FROM x_cp_play_list
                             WHERE plt_lic_number = aa.lic_number
                                   AND PLT_LICENSE_FLAG = l_con_catchup_flag)
                          + DECODE (
                               ab.lee_short_name,
                               'CAFR', (SELECT COUNT (sch_number)
                                          FROM fid_schedule
                                         WHERE sch_lic_number = aa.lic_number),
                               DECODE (
                                  (SELECT COUNT (sch_number)
                                     FROM fid_schedule
                                    WHERE sch_lic_number = aa.lic_number),
                                  0, (SELECT COUNT (sch_number)
                                        FROM fid_schedule, fid_license
                                       WHERE sch_lic_number = lic_number
                                             AND lic_lee_number = 319
                                             AND lic_gen_refno =
                                                    aa.lic_gen_refno
                                             AND lic_con_number =
                                                    aa.lic_con_number),
                                  (SELECT COUNT (sch_number)
                                     FROM fid_schedule
                                    WHERE sch_lic_number = aa.lic_number))))
                    INTO l_maxvp_used
                    FROM fid_license aa, fid_licensee ab
                   WHERE aa.lic_lee_number = ab.lee_number
                         AND aa.lic_number = i_lic_number;
               ELSE
                  SELECT (SELECT COUNT (DISTINCT plt_sch_number)
                            FROM x_cp_play_list
                           WHERE plt_lic_number = aa.lic_number
                                 AND PLT_LICENSE_FLAG = l_con_catchup_flag)
                    INTO l_maxvp_used
                    FROM fid_license aa, fid_licensee ab
                   WHERE aa.lic_lee_number = ab.lee_number
                         AND aa.lic_number = i_lic_number;
               END IF;

               /*Swapnil on 10-jun-2015 for SVOD ends here*/

               --Dev2: Costing 5+2 Rules :Vihal Patel_20140506 : Validation check for update with respect to license start date
               SELECT MIN (lic_start)
                 INTO l_min_lic_start
                 FROM fid_license
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_status <> 'I'
                      AND lic_status <> 'C'
                      AND lic_gen_refno IN
                             (SELECT gen_refno
                                FROM fid_general
                               WHERE gen_ser_number = l_ser_number);

               SELECT MAX (lic_start)
                 INTO l_max_lic_start
                 FROM fid_license
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_status <> 'I'
                      AND lic_status <> 'C'
                      AND lic_gen_refno IN
                             (SELECT gen_refno
                                FROM fid_general
                               WHERE gen_ser_number = l_ser_number);

               IF (l_min_lic_start IS NOT NULL
                   AND l_max_lic_start IS NOT NULL)
               THEN
                  IF (i_lic_start >= v_go_live_crc_date)
                  THEN
                     /* IF (l_min_lic_start < v_go_live_crc_date
                          AND l_max_lic_start > v_go_live_crc_date)
                      THEN
                         ROLLBACK;
                         o_status := '-1';
                         raise_application_error (
                            -20601,
                            'Licenses have different costing rule applicable to them, cannot be copied.');
                      END IF;*/
                     NULL;
                  ELSE
                     IF (l_max_lic_start >= v_go_live_crc_date)
                     THEN
                        ROLLBACK;
                        o_status := '-1';
                        raise_application_error (
                           -20601,
                           'Licenses have different costing rule applicable to them, cannot be copied.');
                     END IF;
                  END IF;
               END IF;

               --Dev2: Costing 5+2 Rules :Vihal Patel_20140506 : End

               FOR z
                  IN (SELECT lic_number, lic_period_tba
                        FROM fid_license
                       WHERE lic_con_number = i_lic_con_number
                             AND lic_lee_number = i_lic_lee_number
                             AND lic_gen_refno IN
                                    (SELECT gen_refno
                                       FROM fid_general
                                      WHERE gen_ser_number = l_ser_number -- AND gen_refno     != i_lic_gen_refno
                                                                         ))
               LOOP
                  IF o_lic_period_tba <> i_lic_period_tba
                  THEN
                     prc_cp_tbachanged (z.lic_number, l_tba_flag);
                  ----null;
                  END IF;
               END LOOP;

               IF i_lic_showing_int < l_maxvp_used
               THEN
                  raise_application_error (
                     -20102,
                     'The Max No. of Viewing Periods cannot be less than the No. of Viewing Periods used.');
               END IF;

               IF i_lic_period_tba = 'Y'
               THEN
                  SELECT COUNT (0)
                    INTO l_cnt
                    FROM x_cp_play_list
                   WHERE plt_lic_number = i_lic_number
                         AND PLT_LICENSE_FLAG = l_con_catchup_flag;

                  IF l_cnt = 0
                  THEN
                     l_schedule_flag := 'N';
                  ELSE
                     l_schedule_flag := 'Y';
                  END IF;

                  IF l_schedule_flag = 'Y'
                  THEN
                     raise_application_error (
                        -20601,
                           'The license '
                        || i_lic_number
                        || ' is scheduled.Cannot change period to TBA.');
                  END IF;
               END IF;

               x_pkg_cp_license_upd_validate.prc_cp_lic_before_upd_valid (
                  i_lic_number,
                  i_lic_start,
                  i_lic_end,
                  i_lic_chs_number_new,
                  NULL,
                  i_max_vp_in_days,
                  i_sch_aft_prem_linear,
                  i_non_cons_month,
                  i_lic_price,
                  i_lic_showing_int,
                  i_lic_showing_lic,
                  i_lic_amort_code,
                  i_lic_period_tba,
                  i_entry_oper);

               FOR z
                  IN (SELECT lic_number, lic_start, lic_end
                        FROM fid_license
                       WHERE lic_con_number = i_lic_con_number
                             AND lic_lee_number = i_lic_lee_number
                             AND lic_gen_refno IN
                                    (SELECT gen_refno
                                       FROM fid_general
                                      WHERE gen_ser_number = l_ser_number -- AND gen_refno     != i_lic_gen_refno
                                                                         ))
               LOOP
                  IF o_lic_start <> i_lic_start
                  THEN
                     prc_alic_cm_validatestartdate (z.lic_number,
                                                    i_lic_start);
                  END IF;

                  IF o_lic_end <> i_lic_end
                  THEN
                     prc_alic_cm_validateenddate (z.lic_number, i_lic_end);
                  END IF;
               END LOOP;

               UPDATE fid_license
                  SET lic_price =
                         DECODE (o_lic_price,
                                 i_lic_price, lic_price,
                                 i_lic_price),
                      lic_markup_percent =
                         DECODE (o_lic_markup_percent,
                                 i_lic_markup_percent, lic_markup_percent,
                                 i_lic_markup_percent),
                      lic_lee_number = i_lic_lee_number_new,
                      lic_chs_number = NULL,
                      lic_start =
                         DECODE (o_lic_start,
                                 i_lic_start, lic_start,
                                 i_lic_start),
                      lic_end =
                         DECODE (o_lic_end, i_lic_end, lic_end, i_lic_end),
                      lic_period_tba =
                         DECODE (o_lic_period_tba,
                                 i_lic_period_tba, lic_period_tba,
                                 i_lic_period_tba),
                      lic_currency = i_lic_currency,
                      lic_showing_int =
                         DECODE (o_lic_showing_int,
                                 i_lic_showing_int, lic_showing_int,
                                 i_lic_showing_int),
                      lic_showing_lic =
                         DECODE (o_lic_showing_lic,
                                 i_lic_showing_lic, lic_showing_lic,
                                 i_lic_showing_lic),
                      lic_max_cha =
                         DECODE (o_lic_max_cha,
                                 i_lic_max_cha, lic_max_cha,
                                 i_lic_max_cha),
                      lic_max_chs =
                         DECODE (o_lic_max_chs,
                                 i_lic_max_chs, lic_max_chs,
                                 i_lic_max_chs),
                      lic_amort_code =
                         DECODE (o_lic_amort_code,
                                 i_lic_amort_code, lic_amort_code,
                                 i_lic_amort_code),
                      lic_budget_code =
                         DECODE (o_lic_budget_code,
                                 i_lic_budget_code, lic_budget_code,
                                 i_lic_budget_code),
                      lic_con_number = i_lic_con_number_new,
                      lic_entry_oper = i_entry_oper /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
                                                   ,
                      lic_max_viewing_period = i_max_vp_in_days,
                      lic_sch_aft_prem_linear = i_sch_aft_prem_linear,
                      lic_non_cons_month = i_non_cons_month,
                      /* Catchup CACQ11 : End 03/12/2012 */

                      -- Dev2: Non Costed Fillers: Start:[Magic License Copier]_[ADITYA GUPTA]_[2013/3/15]
                      -- [Magic License Copier Search Screen modifications for incorporating Non-Costed Fillers changes]
                      lic_free_rpt = i_lic_free_rpt,
                      lic_rpt_period = i_lic_rpt_period
                -- Dev2: Non Costed Fillers: End
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      -- AND lic_chs_number = i_lic_chs_number
                      AND lic_status NOT IN ('C', 'I', 'T')
                      -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                      AND lic_gen_refno IN
                             (SELECT gen_refno
                                FROM fid_general
                               WHERE gen_ser_number = l_ser_number -- AND gen_refno     != i_lic_gen_refno
                                                                  );

               o_count := SQL%ROWCOUNT;
            ELSE
               -- DBMS_OUTPUT.put_line (l_ser_number);

               --Dev2: Costing 5+2 Rules :Vihal Patel_20140506 : Validation check for update with respect to license start date
               SELECT MIN (lic_start)
                 INTO l_min_lic_start
                 FROM fid_license
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_status <> 'I'
                      AND lic_status <> 'C'
                      AND lic_gen_refno IN
                             (SELECT gen_refno
                                FROM fid_general
                               WHERE gen_ser_number = l_ser_number);

               SELECT MAX (lic_start)
                 INTO l_max_lic_start
                 FROM fid_license
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_status <> 'I'
                      AND lic_status <> 'C'
                      AND lic_gen_refno IN
                             (SELECT gen_refno
                                FROM fid_general
                               WHERE gen_ser_number = l_ser_number);

               IF (l_min_lic_start IS NOT NULL
                   AND l_max_lic_start IS NOT NULL)
               THEN
                  IF (i_lic_start >= v_go_live_crc_date)
                  THEN
                     NULL;
                  /*                    IF (l_min_lic_start < v_go_live_crc_date
                                           AND l_max_lic_start > v_go_live_crc_date)
                                       THEN
                                          ROLLBACK;
                                          o_status := '-1';
                                          raise_application_error (
                                             -20601,
                                             'Licenses have different costing rule applicable to them, cannot be copied.');
                                       END IF;*/
                  ELSE
                     IF (l_max_lic_start >= v_go_live_crc_date)
                     THEN
                        ROLLBACK;
                        o_status := '-1';
                        raise_application_error (
                           -20601,
                           'Licenses have different costing rule applicable to them, cannot be copied.');
                     END IF;
                  END IF;
               END IF;

               --Dev2: Costing 5+2 Rules :Vihal Patel_20140506 : End

               FOR z
                  IN (SELECT lic_number, lic_start, lic_end
                        FROM fid_license
                       WHERE lic_con_number = i_lic_con_number
                             AND lic_lee_number = i_lic_lee_number
                             AND lic_gen_refno IN
                                    (SELECT gen_refno
                                       FROM fid_general
                                      WHERE gen_ser_number = l_ser_number -- AND gen_refno     != i_lic_gen_refno
                                                                         ))
               LOOP
                  IF o_lic_start <> i_lic_start
                  THEN
                     prc_alic_cm_validatestartdate (z.lic_number,
                                                    i_lic_start);
                  END IF;

                  IF o_lic_end <> i_lic_end
                  THEN
                     prc_alic_cm_validateenddate (z.lic_number, i_lic_end);
                  END IF;
               END LOOP;

               UPDATE fid_license
                  SET lic_price =
                         DECODE (o_lic_price,
                                 i_lic_price, lic_price,
                                 i_lic_price),
                      lic_markup_percent =
                         DECODE (o_lic_markup_percent,
                                 i_lic_markup_percent, lic_markup_percent,
                                 i_lic_markup_percent),
                      lic_lee_number = i_lic_lee_number_new,
                      lic_chs_number = i_lic_chs_number_new,
                      lic_start =
                         DECODE (o_lic_start,
                                 i_lic_start, lic_start,
                                 i_lic_start),
                      lic_end =
                         DECODE (o_lic_end, i_lic_end, lic_end, i_lic_end),
                      lic_period_tba =
                         DECODE (o_lic_period_tba,
                                 i_lic_period_tba, lic_period_tba,
                                 i_lic_period_tba),
                      lic_currency = i_lic_currency,
                      lic_showing_int = l_lic_showing_int_new,
                      ---decode(o_lic_showing_int,i_lic_showing_int,lic_showing_int,i_lic_showing_int),
                      lic_showing_lic =
                         DECODE (o_lic_showing_lic,
                                 i_lic_showing_lic, lic_showing_lic,
                                 i_lic_showing_lic),
                      lic_max_cha =
                         DECODE (o_lic_max_cha,
                                 i_lic_max_cha, lic_max_cha,
                                 i_lic_max_cha),
                      lic_max_chs =
                         DECODE (o_lic_max_chs,
                                 i_lic_max_chs, lic_max_chs,
                                 i_lic_max_chs),
                      lic_amort_code =
                         DECODE (o_lic_amort_code,
                                 i_lic_amort_code, lic_amort_code,
                                 i_lic_amort_code),
                      lic_budget_code =
                         DECODE (o_lic_budget_code,
                                 i_lic_budget_code, lic_budget_code,
                                 i_lic_budget_code),
                      lic_con_number = i_lic_con_number_new,
                      lic_entry_oper = i_entry_oper /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
                                                   ,
                      lic_max_viewing_period = i_max_vp_in_days,
                      lic_sch_aft_prem_linear = i_sch_aft_prem_linear,
                      lic_non_cons_month = i_non_cons_month,
                      /* Catchup CACQ11 : End 03/12/2012 */

                      -- Dev2: Non Costed Fillers: Start:[Magic License Copier]_[ADITYA GUPTA]_[2013/3/15]
                      -- [Magic License Copier Search Screen modifications for incorporating Non-Costed Fillers changes]
                      lic_free_rpt = i_lic_free_rpt,
                      lic_rpt_period = i_lic_rpt_period
                -- Dev2: Non Costed Fillers: End
                WHERE     lic_con_number = i_lic_con_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_status NOT IN ('C', 'I', 'T')
                      -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                      AND lic_gen_refno IN
                             (SELECT gen_refno
                                FROM fid_general
                               WHERE gen_ser_number = l_ser_number -- AND gen_refno     != i_lic_gen_refno
                                                                  );

               o_count := SQL%ROWCOUNT;
            END IF;

            /* end */
            IF i_lic_start != o_lic_start AND i_lic_end != o_lic_end
            THEN
               l_changed_date_flag := 'BOTH';
            ELSIF i_lic_start != o_lic_start
            THEN
               l_changed_date_flag := 'START';
            ELSIF i_lic_end != o_lic_end
            THEN
               l_changed_date_flag := 'END';
            END IF;

            FOR i
               IN (SELECT lic_number, lic_period_tba, lic_start
                     FROM fid_license
                    WHERE     lic_con_number = i_lic_con_number
                          AND lic_lee_number = i_lic_lee_number
                          AND lic_chs_number = i_lic_chs_number
                          AND lic_status NOT IN ('I', 'T')
                          AND lic_gen_refno IN
                                 (SELECT gen_refno
                                    FROM fid_general
                                   WHERE gen_ser_number = l_ser_number -- and gen_refno     != i_lic_gen_refno
                                                                      ))
            LOOP
               x_pkg_cp_license_upd_validate.prc_cp_lic_after_upd_valid (
                  i.lic_number,
                  i.lic_period_tba,
                  i.lic_start,
                  l_changed_date_flag,
                  i_entry_oper);
            END LOOP;
         ELSE
            l_message := 'Updates are not permitted unless (C)ontract
              or (S)eries is selected';
            RAISE select_contract_or_series;
         END IF;
      EXCEPTION
         WHEN exh_exceed_failed
         THEN
            raise_application_error (
               -20100,
               'The value of amortisation Exh should not be less than the Sum of Exh in closed financial month');
         WHEN OTHERS
         THEN
            raise_application_error (-20603, SUBSTR (SQLERRM, 1, 200));
      END;

      --o_count := SQL%ROWCOUNT;

      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140502 : Calling fid_payment transactions for final commit
      IF (i_trnsfr_pmnt_flag = 'Y')
      THEN
         x_prc_alic_cm_trnsfr_pmt_ins (i_entry_oper, l_status_ins);
         x_prc_alic_cm_trnsfr_pmt_del (i_entry_oper, l_status_del);
      END IF;

      IF (l_status_ins = 1 AND l_status_del = 1)
      THEN
         COMMIT;
      ELSE
         RAISE transfer_pmnt_failure;
      END IF;

      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140502 : End
      o_status := 1;

	--Jawahar.garg added sp to send reversal mail.
	IF i_lic_start != o_lic_start AND l_lic_number_ary.COUNT > 0
	THEN
	 X_PKG_SEND_LIC_REV_MAIL.X_PRC_CHK_LIC_REV (
		I_LIC_NUMBER	      => l_lic_number_ary,
		I_TITLE               => l_gen_title_ary,
		I_LEE_NUMBER          => l_lic_lee_number_ary,
		I_OLD_LIC_START	      => l_old_lic_start_ary,
		I_NEW_LIC_START	      => l_new_lic_start_ary,
		I_CON_SHORT_NAME      => l_con_short_name_ary,
		I_CON_NAME            => l_con_name_ary,
		I_USER		      => i_entry_oper
	 );
	END IF;

   EXCEPTION
      WHEN select_contract_or_series
      THEN
         raise_application_error (-20010, l_message);
      WHEN exh_exceed_failed
      THEN
         raise_application_error (
            -20100,
            'The value of amortisation Exh should not be less than the Sum of Exh in closed financial month');
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140502 : Exception for final commit failure
      WHEN transfer_pmnt_failure
      THEN
         raise_application_error (
            -20100,
            'Tranfer Payment from Source to Destination license unsuccessful.');
      --Dev2: Costing 5+2 Rules :Aditya Gupta_20140502 : End
      WHEN OTHERS
      THEN
         o_status := 0;
         raise_application_error (-20604, SUBSTR (SQLERRM, 1, 200));
   END prc_update_license;

   PROCEDURE prc_update_payment_months (
      i_lic_number        IN     NUMBER,
      i_lic_lee_number    IN     NUMBER,
      i_lic_con_number    IN     NUMBER,
      i_lic_chs_number    IN     NUMBER,
      i_lic_gen_refno     IN     VARCHAR2,
      i_gen_ser_number    IN     fid_general.gen_ser_number%TYPE,
      i_lic_start         IN     DATE,
      i_lic_end           IN     DATE,
      i_contract_series   IN     VARCHAR2,
      i_entry_oper        IN     VARCHAR2,
      o_status               OUT NUMBER)
   AS
      CURSOR c_lic
      IS
         SELECT lic_number, lic_price
           FROM fid_license
          WHERE ( ( (NVL (i_contract_series, 'X') = 'S')
                   AND (lic_con_number = i_lic_con_number)
                   AND (lic_gen_refno IN
                           (SELECT gen_refno
                              FROM fid_general
                             WHERE gen_ser_number = i_gen_ser_number)))
                 OR ( (NVL (i_contract_series, 'X') = 'C')
                     AND lic_con_number = i_lic_con_number))
                AND lic_chs_number = i_lic_chs_number
                AND lic_lee_number = i_lic_lee_number
                AND lic_status NOT IN ('C', 'I', 'T');

      -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
      CURSOR lpy_c
      IS
         SELECT *
           FROM fid_license_payment_months
          WHERE lpy_lic_number = i_lic_number AND lpy_paid_ind = 'N';

      v_pay_month      DATE;
      l_split_region   fid_licensee.lee_split_region%TYPE;
   BEGIN
      ---Dev2:Pure Finance:Start:[Hari_Mandal]_[19/4/2013]
      SELECT lee_split_region
        INTO l_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_lic_number);

      ---Dev2:Pure Finance:End--------------------------
      IF NVL (i_contract_series, 'X') = 'C'
      THEN
         FOR lic IN c_lic
         LOOP
            FOR lpy IN lpy_c
            LOOP
               pkg_alic_mn_magic_lic_copier.prc_calc_pay_month (
                  l_split_region,
                  i_lic_start,
                  i_lic_end,
                  'N',
                  lpy.lpy_pay_month_no,
                  v_pay_month);

               UPDATE fid_license_payment_months
                  SET lpy_pay_month = v_pay_month,
                      lpy_entry_oper = i_entry_oper,
                      lpy_entry_date = SYSDATE
                WHERE lpy_number = lpy.lpy_number;
            END LOOP;
         END LOOP;
      ELSIF NVL (i_contract_series, 'X') = 'S'
      THEN
         FOR lic IN c_lic
         LOOP
            FOR lpy IN lpy_c
            LOOP
               pkg_alic_mn_magic_lic_copier.prc_calc_pay_month (
                  l_split_region,
                  i_lic_start,
                  i_lic_end,
                  'N',
                  lpy.lpy_pay_month_no,
                  v_pay_month);

               UPDATE fid_license_payment_months
                  SET lpy_pay_month = v_pay_month,
                      lpy_entry_oper = i_entry_oper,
                      lpy_entry_date = SYSDATE
                WHERE lpy_number = lpy.lpy_number;
            END LOOP;
         END LOOP;
      END IF;

      COMMIT;
      o_status := 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_status := 0;
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_update_payment_months;

   PROCEDURE prc_calc_pay_month (i_split_region       IN     NUMBER,
                                 i_lic_start          IN     DATE,
                                 i_lic_end            IN     DATE,
                                 i_lic_period_tba     IN     VARCHAR2,
                                 i_lpy_pay_month_no   IN     NUMBER,
                                 o_lpy_pay_month         OUT DATE)
   AS
      CURSOR get_fin_month
      IS
         SELECT TO_DATE ('01' || LPAD (fim_month, 2, 0) || fim_year,
                         'DDMMYYYY')
           FROM fid_financial_month
          WHERE fim_status = 'O'
                AND NVL (fim_split_region, 1) =
                       DECODE (fim_split_region, NULL, 1, i_split_region);

      v_add_month   DATE;
      v_cur_month   DATE;
      l_message     VARCHAR2 (200);
   BEGIN
      OPEN get_fin_month;

      FETCH get_fin_month INTO v_cur_month;

      IF get_fin_month%NOTFOUND
      THEN
         l_message :=
            'No financial month open. Contact your database supervisor.';
         raise_application_error (-20100, SUBSTR (SQLERRM, 200));
      END IF;

      v_add_month :=
         TO_DATE (
            '01-'
            || TO_CHAR (ADD_MONTHS (i_lic_start, i_lpy_pay_month_no - 1),
                        'MON-YYYY'),
            'DD-MON-YYYY');

      IF i_lic_period_tba = 'Y'
      THEN
         o_lpy_pay_month := NULL;
      ELSE
         IF v_add_month < v_cur_month
         THEN
            o_lpy_pay_month := v_cur_month;
         ELSE
            IF v_add_month > i_lic_end
            THEN
               IF i_lic_end < v_cur_month
               THEN
                  o_lpy_pay_month := v_cur_month;
               ELSE
                  o_lpy_pay_month := i_lic_end;
               END IF;
            ELSE
               o_lpy_pay_month := v_add_month;
            END IF;
         END IF;

         o_lpy_pay_month :=
            TO_DATE ('01-' || TO_CHAR (o_lpy_pay_month, 'MON-YYYY'),
                     'DD-MON-YYYY');
      END IF;
   END prc_calc_pay_month;

   PROCEDURE prc_update_channel_runs (
      i_lic_number             IN     NUMBER,
      i_lic_lee_number         IN     NUMBER,
      i_lic_con_number         IN     NUMBER,
      i_lic_chs_number         IN     NUMBER,
      i_ccp_cha_number         IN     NUMBER,
      i_lic_gen_refno          IN     VARCHAR2,
      i_gen_ser_number         IN     fid_general.gen_ser_number%TYPE,
      i_contract_series        IN     VARCHAR2,
      i_cha_action             IN     VARCHAR2,
      i_ccp_cost_ind           IN     VARCHAR2,
      i_ccp_runs_allocated     IN     NUMBER,
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 :license start to check with go live
      i_lic_start              IN     DATE,
      --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : End
      --PB CR 61 Mangesh 20121102:Max cha added
      i_ccp_max_cha_number     IN     NUMBER,
      --PB CR END
      -- Project Bioscope : Ajit_20120319 : Costed Runs added  uncommented by mangesh_20122211 Impacted from Pb_CR_47
      i_runsallocatedcosted    IN     NUMBER,
      -- Project Bioscope : Ajit_20120319 : End
      -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
      i_runsallocatedcosted2   IN     NUMBER,
      -- Project Bioscope CR 47 : Mangesh_20121122 : End
      i_user_id                IN     VARCHAR2,
      i_flag                   IN     NUMBER,
      o_status                    OUT NUMBER)
   AS
      schedule_exists      EXCEPTION;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : Variable declaration
      v_go_live_crc_date   DATE;
      l_min_lic_start      DATE;
      l_max_lic_start      DATE;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : End

      CURSOR c_lic
      IS
         SELECT lic_number, lic_price
           FROM fid_license
          WHERE ( (i_contract_series = 'S'
                   AND lic_con_number = i_lic_con_number
                   AND lic_gen_refno IN
                          (SELECT gen_refno
                             FROM fid_general
                            WHERE gen_ser_number = i_gen_ser_number))
                 OR (i_contract_series = 'C'
                     AND lic_con_number = i_lic_con_number))
                AND lic_chs_number = i_lic_chs_number
                AND lic_lee_number = i_lic_lee_number
                AND lic_status NOT IN ('C', 'I', 'T');

      -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
      CURSOR get_exist_cha
      IS
         SELECT *
           FROM fid_license_channel_runs
          WHERE lcr_lic_number = i_lic_number;

      CURSOR check_cha_exist
      IS
         SELECT lcr_cha_number
           FROM fid_license_channel_runs
          WHERE lcr_lic_number = i_lic_number
                AND lcr_cha_number = i_ccp_cha_number;

      CURSOR check_sch_exist
      IS
         SELECT 1
           FROM fid_schedule
          WHERE sch_lic_number = i_lic_number
                AND sch_cha_number = i_ccp_cha_number;

      -- Added by Omkar
      CURSOR chk_check_cha_exist (clic_number NUMBER, ccha_number NUMBER)
      IS
         SELECT lcr_cha_number
           FROM fid_license_channel_runs
          WHERE lcr_lic_number = clic_number AND lcr_cha_number = ccha_number;

      CURSOR chk_check_sch_exist (clic_number NUMBER, ccha_number NUMBER)
      IS
         SELECT 1
           FROM fid_schedule
          WHERE sch_lic_number = clic_number AND sch_cha_number = ccha_number;

      l_count              NUMBER;
      l_cha_number         NUMBER;
      l_sch_exist          NUMBER;
      l_sch_cha_exist      NUMBER;
      i_cha_name           VARCHAR2 (10);
      l_message            VARCHAR2 (200);
      l_channel_exists     NUMBER;
      l_flag               NUMBER;
   BEGIN
      l_sch_exist := 0;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : Go live date of costing 5+2
      SELECT TO_DATE (content)
        INTO v_go_live_crc_date
        FROM x_fin_configs
       WHERE ID = 6;

      --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : End

      IF i_cha_action = 'D'
      THEN
         pkg_alic_mn_magic_lic_copier.prc_populate_lic_lcr (i_lic_number,
                                                            i_user_id);

         FOR rec_lic IN c_lic
         LOOP
            FOR ccp
               IN (SELECT *
                     FROM fid_lic_channel_runs_copier
                    WHERE ccp_lic_number = i_lic_number
                          AND ccp_cha_number = i_ccp_cha_number)
            LOOP
               OPEN chk_check_cha_exist (rec_lic.lic_number,
                                         ccp.ccp_cha_number);

               FETCH chk_check_cha_exist INTO l_cha_number;

               IF chk_check_cha_exist%FOUND
               THEN
                  OPEN chk_check_sch_exist (rec_lic.lic_number,
                                            ccp.ccp_cha_number);

                  FETCH chk_check_sch_exist INTO l_sch_exist;

                  IF chk_check_sch_exist%NOTFOUND
                  THEN
                     pkg_cm_username.username :=
                        pkg_cm_username.setusername (i_user_id);

                     DELETE FROM fid_license_channel_runs
                           WHERE lcr_lic_number = rec_lic.lic_number
                                 AND lcr_cha_number = ccp.ccp_cha_number;
                  /*  DBMS_OUTPUT.put_line (
                          'Lic number = '
                       || rec_lic.lic_number
                       || ' chan number = '
                       || ccp.ccp_cha_number);
                   */
                  END IF;

                  CLOSE chk_check_sch_exist;
               END IF;

               CLOSE chk_check_cha_exist;
            END LOOP;
         END LOOP;
      ELSIF i_cha_action = 'U'
      THEN
         pkg_alic_mn_magic_lic_copier.prc_populate_lic_lcr (i_lic_number,
                                                            i_user_id);

         --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : Validation on update
         SELECT MIN (lic_start)
           INTO l_min_lic_start
           FROM fid_license
          WHERE ( (i_contract_series = 'S'
                   AND lic_con_number = i_lic_con_number
                   AND lic_gen_refno IN
                          (SELECT gen_refno
                             FROM fid_general
                            WHERE gen_ser_number = i_gen_ser_number))
                 OR (i_contract_series = 'C'
                     AND lic_con_number = i_lic_con_number))
                AND lic_chs_number = i_lic_chs_number
                AND lic_lee_number = i_lic_lee_number
                AND lic_status <> 'I'
                AND lic_status <> 'C';

         SELECT MAX (lic_start)
           INTO l_max_lic_start
           FROM fid_license
          WHERE ( (i_contract_series = 'S'
                   AND lic_con_number = i_lic_con_number
                   AND lic_gen_refno IN
                          (SELECT gen_refno
                             FROM fid_general
                            WHERE gen_ser_number = i_gen_ser_number))
                 OR (i_contract_series = 'C'
                     AND lic_con_number = i_lic_con_number))
                AND lic_chs_number = i_lic_chs_number
                AND lic_lee_number = i_lic_lee_number
                AND lic_status <> 'I'
                AND lic_status <> 'C';

         IF (l_min_lic_start IS NOT NULL AND l_max_lic_start IS NOT NULL)
         THEN
            IF (i_lic_start >= v_go_live_crc_date)
            THEN
               NULL;
            /*
             IF (l_min_lic_start < v_go_live_crc_date
                  AND l_max_lic_start > v_go_live_crc_date)
              THEN
                 ROLLBACK;
                 o_status := '-1';
                 raise_application_error (
                    -20601,
                    'Licenses have different costing rule applicable to them, cannot be copied.');
              END IF;*/
            ELSE
               IF (l_max_lic_start >= v_go_live_crc_date)
               THEN
                  ROLLBACK;
                  o_status := '-1';
                  raise_application_error (
                     -20601,
                     'Licenses have different costing rule applicable to them, cannot be copied.');
               END IF;
            END IF;
         END IF;

         --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : End

         SELECT COUNT (*)
           INTO l_count
           FROM fid_lic_channel_runs_copier
          WHERE ccp_lic_number = i_lic_number
                AND ccp_cha_number = i_ccp_cha_number;

         IF l_count > 0
         THEN
            UPDATE fid_lic_channel_runs_copier
               SET ccp_runs_allocated = i_ccp_runs_allocated,
                   ccp_cost_ind = i_ccp_cost_ind,
                   -- Project Bioscope : Anirudha 21/03/2012 : Costed Runs added
                   ccp_costed_runs = i_runsallocatedcosted,
                   -- Project Bioscope End
                   --PB CR 61 mangesh 20121102 :Added new column Max cha number
                   ccp_max_cha_number = i_ccp_max_cha_number,
                   --PB CR END
                   -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                   ccp_costed_runs2 = i_runsallocatedcosted2
             -- Project Bioscope CR 47 : Mangesh_20121122 : End
             WHERE ccp_lic_number = i_lic_number
                   AND ccp_cha_number = i_ccp_cha_number;

            COMMIT;
         END IF;

         FOR rec_lic IN c_lic
         LOOP
            FOR ccp IN (SELECT *
                          FROM fid_lic_channel_runs_copier
                         WHERE ccp_lic_number = i_lic_number)
            LOOP
               OPEN check_cha_exist;

               FETCH check_cha_exist INTO l_cha_number;

               IF check_cha_exist%FOUND
               THEN
                  UPDATE fid_license_channel_runs
                     SET lcr_runs_allocated = ccp.ccp_runs_allocated,
                         lcr_cost_ind = ccp.ccp_cost_ind,
                         lcr_entry_oper = i_user_id,
                         lcr_entry_date = SYSDATE,
                         -- Project Bioscope : Ajit_20120319 : Costed Runs added
                         lcr_cha_costed_runs = ccp.ccp_costed_runs,
                         -- Project Bioscope : Ajit_20120319 : End
                         --PB CR 61 mangesh 20121102 :Added new column Max cha number
                         lcr_max_runs_cha = ccp.ccp_max_cha_number,
                         --PB CR END
                         -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                         lcr_cha_costed_runs2 = ccp.ccp_costed_runs2
                   -- Project Bioscope CR 47 : Mangesh_20121122 : End
                   WHERE lcr_lic_number = rec_lic.lic_number
                         AND lcr_cha_number = ccp.ccp_cha_number;

                  COMMIT;
               END IF;

               CLOSE check_cha_exist;
            END LOOP;
         END LOOP;
      ELSIF i_cha_action = 'A'
      THEN
         /*  DBMS_OUTPUT.put_line (
                 '1***:'
              || i_ccp_cha_number
              || ' '
              || i_lic_lee_number
              || ' '
              || i_lic_chs_number);
              */
         pkg_alic_mn_magic_lic_copier.prc_populate_lic_lcr (i_lic_number,
                                                            i_user_id);

         --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : Validation on update
         SELECT MIN (lic_start)
           INTO l_min_lic_start
           FROM fid_license
          WHERE ( (i_contract_series = 'S'
                   AND lic_con_number = i_lic_con_number
                   AND lic_gen_refno IN
                          (SELECT gen_refno
                             FROM fid_general
                            WHERE gen_ser_number = i_gen_ser_number))
                 OR (i_contract_series = 'C'
                     AND lic_con_number = i_lic_con_number))
                AND lic_chs_number = i_lic_chs_number
                AND lic_lee_number = i_lic_lee_number
                AND lic_status <> 'I'
                AND lic_status <> 'C';

         SELECT MAX (lic_start)
           INTO l_max_lic_start
           FROM fid_license
          WHERE ( (i_contract_series = 'S'
                   AND lic_con_number = i_lic_con_number
                   AND lic_gen_refno IN
                          (SELECT gen_refno
                             FROM fid_general
                            WHERE gen_ser_number = i_gen_ser_number))
                 OR (i_contract_series = 'C'
                     AND lic_con_number = i_lic_con_number))
                AND lic_chs_number = i_lic_chs_number
                AND lic_lee_number = i_lic_lee_number
                AND lic_status <> 'I'
                AND lic_status <> 'C';

         IF (l_min_lic_start IS NOT NULL AND l_max_lic_start IS NOT NULL)
         THEN
            IF (i_lic_start >= v_go_live_crc_date)
            THEN
               NULL;
            /*
           IF (l_min_lic_start < v_go_live_crc_date
               AND l_max_lic_start > v_go_live_crc_date)
           THEN
              ROLLBACK;
              o_status := '-1';
              raise_application_error (
                 -20601,
                 'Licenses have different costing rule applicable to them, cannot be copied.');
           END IF;*/
            ELSE
               IF (l_max_lic_start >= v_go_live_crc_date)
               THEN
                  ROLLBACK;
                  o_status := '-1';
                  raise_application_error (
                     -20601,
                     'Licenses have different costing rule applicable to them, cannot be copied.');
               END IF;
            END IF;
         END IF;

         --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : End

         SELECT COUNT (*)
           INTO l_count
           FROM fid_lic_channel_runs_copier
          WHERE ccp_lic_number = i_lic_number
                AND ccp_cha_number = i_ccp_cha_number;

         -- DBMS_OUTPUT.put_line ('lcnt' || l_count);

         IF l_count = 0
         THEN
            INSERT INTO fid_lic_channel_runs_copier (ccp_lic_number,
                                                     ccp_cha_number,
                                                     ccp_runs_allocated,
                                                     ccp_cost_ind,
                                                     ccp_entry_oper,
                                                     ccp_entry_date,
                                                     ccp_is_deleted,
                                                     ccp_update_count,
                                                     -- Project Bioscope  Anirudha 21/03/2012  Costed Runs added
                                                     ccp_costed_runs,
                                                     ---- Project Bioscope End
                                                     --PB_CR 61 Mangesh 20121102 :Max cha added
                                                     ccp_max_cha_number,
                                                     --PB CR END
                                                     -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                                                     ccp_costed_runs2 -- Project Bioscope CR 47 : Mangesh_20121122 : End
                                                                     )
                 VALUES (i_lic_number,
                         i_ccp_cha_number,
                         i_ccp_runs_allocated,
                         i_ccp_cost_ind,
                         i_user_id,
                         SYSDATE,
                         0,
                         0,
                         i_runsallocatedcosted,
                         i_ccp_max_cha_number,
                         --PB CR 61 mangesh 20121102 :Added new column Max cha number
                         -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                         i_runsallocatedcosted2 -- Project Bioscope CR 47 : Mangesh_20121122 : End
                                               );

            COMMIT;
         --  DBMS_OUTPUT.put_line ('2');
         END IF;

         FOR rec_lic IN c_lic
         LOOP
            --  DBMS_OUTPUT.put_line ('11*:' || rec_lic.lic_number);

            FOR ccp IN (SELECT *
                          FROM fid_lic_channel_runs_copier
                         WHERE ccp_lic_number = i_lic_number)
            LOOP
               /*OPEN check_cha_exist;

               FETCH check_cha_exist
                INTO l_cha_number;

               IF check_cha_exist%NOTFOUND
               THEN*/
               SELECT COUNT (lcr_cha_number)
                 INTO l_channel_exists
                 FROM fid_license_channel_runs
                WHERE lcr_lic_number = rec_lic.lic_number
                      AND lcr_cha_number = ccp.ccp_cha_number;

               IF l_channel_exists = 0
               THEN
                  INSERT
                    INTO fid_license_channel_runs (lcr_number,
                                                   lcr_lic_number,
                                                   lcr_cha_number,
                                                   lcr_runs_allocated,
                                                   lcr_cost_ind,
                                                   lcr_entry_oper,
                                                   lcr_entry_date,
                                                   -- Project Bioscope : Ajit_20120319 : Costed Runs added  uncommented by mangesh_20121123 PB CR 47 impacted item
                                                   lcr_cha_costed_runs,
                                                   -- Project Bioscope : Ajit_20120319 : End
                                                   --PB_CR 61 mangesh_20121102 :MAx cha added
                                                   lcr_max_runs_cha,
                                                   --PB_CR END
                                                   -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                                                   lcr_cha_costed_runs2 -- Project Bioscope CR 47 : Mangesh_20121122 : End
                                                                       )
                  VALUES (get_seq ('SEQ_LCR_NUMBER'),
                          rec_lic.lic_number,
                          ccp.ccp_cha_number,
                          ccp.ccp_runs_allocated,
                          ccp.ccp_cost_ind,
                          i_user_id,
                          SYSDATE,
                          -- Project Bioscope : Ajit_20120319 : Costed Runs added
                          ccp.ccp_costed_runs,
                          -- Project Bioscope : Ajit_20120319 : End
                          ccp.ccp_max_cha_number,
                          --PB CR 61 mangesh 20121102 :Added new column Max cha number
                          -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                          ccp.ccp_costed_runs2 -- Project Bioscope CR 47 : Mangesh_20121122 : End
                                              );

                  COMMIT;
               END IF;
            --CLOSE check_cha_exist;
            END LOOP;
         END LOOP;
      ELSIF i_cha_action = 'R'
      THEN
         --DBMS_OUTPUT.put_line ('1' );
         pkg_alic_mn_magic_lic_copier.prc_populate_lic_lcr (i_lic_number,
                                                            i_user_id);

         --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : Validation on update
         SELECT MIN (lic_start)
           INTO l_min_lic_start
           FROM fid_license
          WHERE ( (i_contract_series = 'S'
                   AND lic_con_number = i_lic_con_number
                   AND lic_gen_refno IN
                          (SELECT gen_refno
                             FROM fid_general
                            WHERE gen_ser_number = i_gen_ser_number))
                 OR (i_contract_series = 'C'
                     AND lic_con_number = i_lic_con_number))
                AND lic_chs_number = i_lic_chs_number
                AND lic_lee_number = i_lic_lee_number
                AND lic_status <> 'I'
                AND lic_status <> 'C';

         SELECT MAX (lic_start)
           INTO l_max_lic_start
           FROM fid_license
          WHERE ( (i_contract_series = 'S'
                   AND lic_con_number = i_lic_con_number
                   AND lic_gen_refno IN
                          (SELECT gen_refno
                             FROM fid_general
                            WHERE gen_ser_number = i_gen_ser_number))
                 OR (i_contract_series = 'C'
                     AND lic_con_number = i_lic_con_number))
                AND lic_chs_number = i_lic_chs_number
                AND lic_lee_number = i_lic_lee_number
                AND lic_status <> 'I'
                AND lic_status <> 'C';

         IF (l_min_lic_start IS NOT NULL AND l_max_lic_start IS NOT NULL)
         THEN
            IF (i_lic_start >= v_go_live_crc_date)
            THEN
               NULL;
            /*IF (l_min_lic_start < v_go_live_crc_date
                 AND l_max_lic_start > v_go_live_crc_date)
             THEN
                ROLLBACK;
                o_status := '-1';
                raise_application_error (
                   -20601,
                   'Licenses have different costing rule applicable to them, cannot be copied.');
             END IF; */
            ELSE
               IF (l_max_lic_start >= v_go_live_crc_date)
               THEN
                  ROLLBACK;
                  o_status := '-1';
                  raise_application_error (
                     -20601,
                     'Licenses have different costing rule applicable to them, cannot be copied.');
               END IF;
            END IF;
         END IF;

         --Dev2: Costing 5+2 Rules :Vihal Patel_20140516 : End

         /* l_flag:=0;
          if  l_flag=0 then
             pkg_alic_mn_magic_lic_copier.prc_update_channel_runs(i_lic_number ,i_lic_lee_number,i_lic_con_number,i_lic_chs_number,i_ccp_cha_number,i_lic_gen_refno,
    i_gen_ser_number,i_contract_series,'D',i_ccp_cost_ind,i_ccp_runs_allocated,i_user_id,o_status);
    end if;*/
         IF i_flag = 0
         THEN
            DELETE fid_lic_channel_runs_copier
             WHERE ccp_lic_number = i_lic_number;

            FOR rec_lic IN c_lic
            LOOP
               --DBMS_OUTPUT.put_line ('2' );
               FOR lcr IN get_exist_cha
               LOOP
                  --DBMS_OUTPUT.put_line ('3' );
                  OPEN check_sch_exist;

                  FETCH check_sch_exist INTO l_sch_exist;

                  --DBMS_OUTPUT.put_line ('4' || l_sch_exist);
                  IF check_sch_exist%NOTFOUND
                  THEN
                     NULL;
                  END IF;

                  CLOSE check_sch_exist;
               END LOOP;

               IF NVL (l_sch_exist, 0) != 0
               THEN
                  l_message :=
                     'Schedules exist for channels on this license. Cannot replace new channels';
                  --DBMS_OUTPUT.put_line ('4 chk'|| l_message);
                  RAISE schedule_exists;
               ELSE
                  DELETE fid_license_channel_runs
                   WHERE lcr_lic_number = rec_lic.lic_number;
               --COMMIT;
               --DBMS_OUTPUT.put_line ('4 deleted' );
               END IF;
            END LOOP;

            COMMIT;
         END IF;

         SELECT COUNT (*)
           INTO l_count
           FROM fid_lic_channel_runs_copier
          WHERE ccp_lic_number = i_lic_number
                AND ccp_cha_number = i_ccp_cha_number;

         -- DBMS_OUTPUT.put_line ('lcnt' || l_count);

         --if l_flag=1 then
         IF l_count = 0
         THEN
            INSERT INTO fid_lic_channel_runs_copier (ccp_lic_number,
                                                     ccp_cha_number,
                                                     ccp_runs_allocated,
                                                     ccp_cost_ind,
                                                     ccp_entry_oper,
                                                     ccp_entry_date,
                                                     ccp_is_deleted,
                                                     ccp_update_count,
                                                     ccp_costed_runs,
                                                     --PB_CR 61 mangesh_20121102 :MAx cha added
                                                     ccp_max_cha_number,
                                                     --PB CR END
                                                     -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                                                     ccp_costed_runs2 -- Project Bioscope CR 47 : Mangesh_20121122 : End
                                                                     )
                 VALUES (i_lic_number,
                         i_ccp_cha_number,
                         i_ccp_runs_allocated,
                         i_ccp_cost_ind,
                         i_user_id,
                         SYSDATE,
                         0,
                         0,
                         i_runsallocatedcosted,
                         i_ccp_max_cha_number,
                         --PB CR 61 mangesh 20121102 :Added new column Max cha number
                         -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                         i_runsallocatedcosted2 -- Project Bioscope CR 47 : Mangesh_20121122 : End
                                               );

            COMMIT;
         END IF;

         -- DBMS_OUTPUT.put_line ('2');

         FOR rec_lic IN c_lic
         LOOP
            --DBMS_OUTPUT.put_line ('2' );
            FOR lcr IN get_exist_cha
            LOOP
               --DBMS_OUTPUT.put_line ('3' );
               OPEN check_sch_exist;

               FETCH check_sch_exist INTO l_sch_exist;

               --DBMS_OUTPUT.put_line ('4' || l_sch_exist);
               IF check_sch_exist%NOTFOUND
               THEN
                  NULL;
               END IF;

               CLOSE check_sch_exist;
            END LOOP;

            /* IF NVL (l_sch_exist, 0) != 0
             THEN
                l_message :=
                   'Schedules exist for channels on this license. Cannot replace new channels';
                --DBMS_OUTPUT.put_line ('4 chk'|| l_message);
                RAISE schedule_exists;
             ELSE
                DELETE      fid_license_channel_runs
                      WHERE lcr_lic_number = rec_lic.lic_number;

                COMMIT;
             --DBMS_OUTPUT.put_line ('4 deleted' );
             END IF;*/
            IF NVL (l_sch_exist, 0) != 0
            THEN
               l_message :=
                  'Schedules exist for channels on this license. Cannot replace new channels';
               -- DBMS_OUTPUT.put_line ('4 chk' || l_message);
               RAISE schedule_exists;
            ELSE
               DELETE fid_license_channel_runs
                WHERE lcr_lic_number = rec_lic.lic_number;

               COMMIT;

               INSERT INTO fid_license_channel_runs (lcr_number,
                                                     lcr_lic_number,
                                                     lcr_cha_number,
                                                     lcr_runs_allocated,
                                                     lcr_cost_ind,
                                                     lcr_entry_oper,
                                                     lcr_entry_date,
                                                     -- Project Bioscope  Anirudha 21/03/2012 : Costed Runs added   uncomented by mangesh_20121123 PB_CR_47:Impacted item form LIcense Mainetaince
                                                     lcr_cha_costed_runs,
                                                     -- Project Bioscope End
                                                     --PB_CR 61 Mangesh 20121102 :Max cha number
                                                     lcr_max_runs_cha,
                                                     --PB_CR END
                                                     -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                                                     lcr_cha_costed_runs2 -- Project Bioscope CR 47 : Mangesh_20121122 : End
                                                                         )
                  SELECT get_seq ('SEQ_LCR_NUMBER'),
                         rec_lic.lic_number,
                         ccp_cha_number,
                         ccp_runs_allocated,
                         ccp_cost_ind,
                         i_user_id,
                         SYSDATE,
                         ccp_costed_runs,
                         ccp_max_cha_number,
                         --PB CR 61 mangesh 20121102 :Added new column Max cha number
                         -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                         ccp_costed_runs2
                    -- Project Bioscope CR 47 : Mangesh_20121122 : End
                    FROM fid_lic_channel_runs_copier
                   WHERE ccp_lic_number = i_lic_number;

               COMMIT;
            --DBMS_OUTPUT.put_line ('4 inserted');
            END IF;
         END LOOP;
      END IF;

      COMMIT;
      o_status := 1;
   EXCEPTION
      WHEN schedule_exists
      THEN
         raise_application_error (-20100, l_message);
      WHEN OTHERS
      THEN
         o_status := 0;
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_update_channel_runs;

   PROCEDURE prc_update_history (i_lic_number        IN     NUMBER,
                                 i_lic_lee_number    IN     NUMBER,
                                 i_lic_con_number    IN     NUMBER,
                                 i_lic_chs_number    IN     NUMBER,
                                 i_lic_gen_refno     IN     VARCHAR2,
                                 i_gen_ser_number    IN     NUMBER,
                                 i_histflag          IN     VARCHAR2,
                                 i_contract_series   IN     VARCHAR2,
                                 i_user_id           IN     VARCHAR2,
                                 o_status               OUT NUMBER)
   AS
   BEGIN
      IF NVL (i_histflag, 'N') = 'Y'
      THEN
         IF NVL (i_contract_series, 'X') = 'C'
         THEN
            DELETE fid_license_history
             WHERE                        --lih_lic_number != i_lic_number AND
                  lih_lic_number IN
                      (SELECT lic_number
                         FROM fid_license
                        WHERE     lic_con_number = i_lic_con_number
                              AND lic_chs_number = i_lic_chs_number
                              AND lic_lee_number = i_lic_lee_number);

            INSERT INTO fid_license_history (lih_lic_number,
                                             lih_code,
                                             lih_date,
                                             lih_comment,
                                             lih_entry_oper,
                                             lih_entry_date)
               SELECT lic_number,
                      lih_code,
                      lih_date,
                      lih_comment,
                      i_user_id,
                      SYSDATE
                 FROM fid_license_history, fid_license
                WHERE     lic_con_number = i_lic_con_number
                      --AND lic_number != i_lic_number
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_lee_number = i_lic_lee_number
                      AND lih_lic_number = i_lic_number;
         ELSIF NVL (i_contract_series, 'X') = 'S'
         THEN
            DELETE fid_license_history
             WHERE                        --lih_lic_number != i_lic_number AND
                  lih_lic_number IN
                      (SELECT lic_number
                         FROM fid_license, fid_general
                        WHERE     gen_ser_number = i_gen_ser_number
                              AND lic_gen_refno = i_lic_gen_refno
                              AND lic_con_number = i_lic_con_number
                              AND lic_chs_number = i_lic_chs_number
                              AND lic_lee_number = i_lic_lee_number);

            INSERT INTO fid_license_history (lih_lic_number,
                                             lih_code,
                                             lih_date,
                                             lih_comment,
                                             lih_entry_oper,
                                             lih_entry_date)
               SELECT lic_number,
                      lih_code,
                      lih_date,
                      lih_comment,
                      i_user_id,
                      SYSDATE
                 FROM fid_license_history, fid_general, fid_license
                WHERE                        --lic_number != i_lic_number  AND
                     lic_con_number = i_lic_con_number
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_lee_number = i_lic_lee_number
                      AND gen_refno = i_lic_gen_refno
                      AND gen_ser_number = i_gen_ser_number
                      AND lih_lic_number = i_lic_number;
         END IF;
      END IF;

      COMMIT;
      o_status := 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_status := 0;
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_update_history;

    /* This procedure populates the License Ledger block with all the
relevant Territories for the Channel Service */
   PROCEDURE prc_populate_lic_lil (i_lic_number   IN NUMBER,
                                   i_user_id      IN VARCHAR2)
   AS
      CURSOR cht_c
      IS
         SELECT *
           FROM fid_license_ledger
          WHERE lil_lic_number = i_lic_number;
   BEGIN
      DELETE FROM fid_lic_ledger_copier
            WHERE lcp_lic_number = i_lic_number;

      FOR lit IN cht_c
      LOOP
         INSERT INTO fid_lic_ledger_copier
              VALUES (lit.lil_lic_number,
                      lit.lil_ter_code,
                      lit.lil_rgh_code,
                      lit.lil_price_code,
                      lit.lil_price,
                      lit.lil_adjust_factor,
                      lit.lil_con_forecast,
                      lit.lil_loc_forecast,
                      lit.lil_con_calc,
                      lit.lil_loc_calc,
                      lit.lil_con_actual,
                      lit.lil_loc_actual,
                      lit.lil_con_adjust,
                      lit.lil_loc_adjust,
                      lit.lil_comment,
                      i_user_id,
                      SYSDATE,
                      0,
                      0);
      END LOOP;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_populate_lic_lil;

   /*This procedure populates the License Ledger block with all the
relevant Territories for the Channel Service */

   --to be called on key next block of 'NBT_DEFAULT_RIGHTS 'item
   PROCEDURE prc_populate_new_lil (i_lic_number           IN     NUMBER,
                                   i_lic_chs_number       IN     NUMBER,
                                   i_nbt_default_rights   IN     VARCHAR2,
                                   i_lic_price            IN     NUMBER,
                                   i_lic_price_code       IN     VARCHAR2,
                                   o_lcp_lic_number          OUT NUMBER,
                                   o_lcp_ter_code            OUT VARCHAR2,
                                   o_lcp_rgh_code            OUT VARCHAR2,
                                   o_lcp_price_code          OUT VARCHAR2,
                                   o_lcp_price               OUT NUMBER,
                                   o_lcp_adjust_factor       OUT NUMBER,
                                   o_lcp_con_forecast        OUT NUMBER,
                                   o_lcp_loc_forecast        OUT NUMBER,
                                   o_lcp_con_calc            OUT NUMBER,
                                   o_lcp_loc_calc            OUT NUMBER,
                                   o_lcp_con_actual          OUT NUMBER,
                                   o_lcp_loc_actual          OUT NUMBER,
                                   o_lcp_con_adjust          OUT NUMBER,
                                   o_lcp_loc_adjust          OUT NUMBER,
                                   o_lcp_comment             OUT VARCHAR2,
                                   o_message                 OUT VARCHAR2)
   AS
      CURSOR cht_c
      IS
         SELECT DISTINCT cht_ter_code
           FROM fid_channel_territory
          WHERE EXISTS
                   (SELECT NULL
                      FROM fid_channel
                     WHERE cha_number = i_lic_chs_number
                           AND cha_number = cht_cha_number
                    UNION
                    SELECT NULL
                      FROM fid_channel_service
                     WHERE chs_number = i_lic_chs_number
                           AND chs_cha_number = cht_cha_number
                    UNION
                    SELECT NULL
                      FROM fid_channel_service_channel
                     WHERE csc_chs_number = i_lic_chs_number
                           AND csc_cha_number = cht_cha_number);

      l_message   VARCHAR2 (200);
   BEGIN
      FOR lit IN cht_c
      LOOP
         o_lcp_lic_number := i_lic_number;
         o_lcp_ter_code := lit.cht_ter_code;
         o_lcp_rgh_code := i_nbt_default_rights;
         o_lcp_price_code := NVL (i_lic_price_code, '-');
         o_lcp_price := i_lic_price;
         o_lcp_adjust_factor := 1;
         o_lcp_con_forecast := 0;
         o_lcp_loc_forecast := 0;
         o_lcp_con_calc := 0;
         o_lcp_loc_calc := 0;
         o_lcp_con_actual := 0;
         o_lcp_loc_actual := 0;
         o_lcp_con_adjust := 0;
         o_lcp_loc_adjust := 0;
         o_lcp_comment := '<CREATED BY MAGIC SCREEN>';
      -- NEXT_RECORD;
      END LOOP;

      -- FIRST_RECORD;
      o_message := 'Change default rights as necessary';
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_populate_new_lil;

   /* This procedure populates the License Ledger block with all the
relevant Territories for the Channel Service */
   PROCEDURE prc_populate_lic_lcr (i_lic_number   IN NUMBER,
                                   i_user_id      IN VARCHAR2)
   AS
      CURSOR lcr_c
      IS
         SELECT *
           FROM fid_license_channel_runs
          WHERE lcr_lic_number = i_lic_number;
   BEGIN
      -- DBMS_OUTPUT.put_line ('1' );
      DELETE FROM fid_lic_channel_runs_copier
            WHERE ccp_lic_number = i_lic_number;

      COMMIT;

      --DBMS_OUTPUT.put_line ('1 deleted' );
      FOR lit IN lcr_c
      LOOP
         INSERT INTO fid_lic_channel_runs_copier
              VALUES (lit.lcr_lic_number,
                      lit.lcr_cha_number,
                      lit.lcr_runs_allocated,
                      lit.lcr_cost_ind,
                      i_user_id,
                      SYSDATE,
                      0,
                      0,
                      lit.lcr_cha_costed_runs,
                      lit.lcr_max_runs_cha --PB_CR_61 MAngesh 20121102 added new field Max cha runs
                                          -- Project Bioscope CR 47 : Mangesh_20121122 : Added as impacted item from License Maintainance
                      ,
                      lit.lcr_cha_costed_runs2);
      -- Project Bioscope CR 47 : Mangesh_20121122 : End
      END LOOP;

      --DBMS_OUTPUT.put_line ('1 inserted');
      COMMIT;
   /*EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20010, SUBSTR (SQLERRM, 1,200));*/
   END prc_populate_lic_lcr;

   PROCEDURE prc_delete_lic_cha_runs_copier (i_lic_number       IN NUMBER,
                                             i_ccp_cha_number   IN NUMBER)
   AS
      l_rec_found   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_rec_found
        FROM fid_lic_channel_runs_copier
       WHERE ccp_lic_number = i_lic_number
             AND ccp_cha_number = i_ccp_cha_number;

      IF l_rec_found > 0
      THEN
         DELETE FROM fid_lic_channel_runs_copier
               WHERE ccp_lic_number = i_lic_number
                     AND ccp_cha_number = i_ccp_cha_number;

         COMMIT;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20010, 'Record does not exists');
      WHEN OTHERS
      THEN
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_delete_lic_cha_runs_copier;

   PROCEDURE prc_delete_lic_ledger_copier (i_lic_number     IN NUMBER,
                                           i_lcp_ter_code   IN VARCHAR2,
                                           i_lcp_rgh_code   IN VARCHAR2)
   AS
      l_rec_found   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_rec_found
        FROM fid_lic_ledger_copier
       WHERE     lcp_lic_number = i_lic_number
             AND lcp_ter_code = i_lcp_ter_code
             AND lcp_rgh_code = i_lcp_rgh_code;

      IF l_rec_found > 0
      THEN
         DELETE FROM fid_lic_ledger_copier
               WHERE     lcp_lic_number = i_lic_number
                     AND lcp_ter_code = i_lcp_ter_code
                     AND lcp_rgh_code = i_lcp_rgh_code;

         COMMIT;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20010, 'Record does not exists');
      WHEN OTHERS
      THEN
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_delete_lic_ledger_copier;

   PROCEDURE prc_insert_lic_cha_runs_copier (
      i_lic_number           IN NUMBER,
      i_ccp_cha_number       IN NUMBER,
      i_ccp_cost_ind         IN VARCHAR2,
      i_ccp_runs_allocated   IN NUMBER,
      -- Project Bioscope Added below parameter by Anirudha 21/03/2012
      i_ccp_costed_runs      IN NUMBER,
      /* --PB CR 61 Mangesh 20121102:Max cha added
       i_ccp_max_cha_number   IN   NUMBER,
       --PB CR END
       i_ccp_costed_runs2     IN   NUMBER,*/
      i_user_id              IN VARCHAR2)
   AS
      l_count   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM fid_lic_channel_runs_copier
       WHERE ccp_lic_number = i_lic_number
             AND ccp_cha_number = i_ccp_cha_number;

      -- DBMS_OUTPUT.put_line ('lcnt' || l_count);

      IF l_count = 0
      THEN
         --PB CR 61 Mangesh_20121102:Column names specified in Insert as two new fileds added to fid_lic_channel_runs_copier Table
         INSERT INTO fid_lic_channel_runs_copier (ccp_lic_number,
                                                  ccp_cha_number,
                                                  ccp_runs_allocated,
                                                  ccp_cost_ind,
                                                  ccp_entry_oper,
                                                  ccp_entry_date,
                                                  ccp_is_deleted,
                                                  ccp_update_count,
                                                  ccp_costed_runs)
              VALUES (i_lic_number,
                      i_ccp_cha_number,
                      i_ccp_runs_allocated,
                      i_ccp_cost_ind,
                      i_user_id,
                      SYSDATE,
                      0,
                      0,
                      i_ccp_costed_runs);
      --PB CR 61 END
      END IF;

      COMMIT;
   END;

   PROCEDURE prc_insert_lic_ledger_copier (i_lic_number     IN NUMBER,
                                           i_lcp_ter_code   IN VARCHAR2,
                                           i_lcp_rgh_code   IN VARCHAR2,
                                           i_user_id        IN VARCHAR2)
   AS
      l_count   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_count
        FROM fid_lic_ledger_copier
       WHERE lcp_lic_number = i_lic_number AND lcp_ter_code = i_lcp_ter_code;

      --DBMS_OUTPUT.put_line ('2' || l_count);

      --and LCP_RGH_CODE=i_LCP_RGH_CODE
      IF l_count = 0
      THEN
         INSERT INTO fid_lic_ledger_copier (lcp_lic_number,
                                            lcp_ter_code,
                                            lcp_rgh_code,
                                            lcp_price_code,
                                            lcp_price,
                                            lcp_adjust_factor,
                                            lcp_con_forecast,
                                            lcp_loc_forecast,
                                            lcp_con_calc,
                                            lcp_loc_calc,
                                            lcp_con_actual,
                                            lcp_loc_actual,
                                            lcp_con_adjust,
                                            lcp_loc_adjust,
                                            lcp_is_deleted,
                                            lcp_update_count,
                                            lcp_entry_oper,
                                            lcp_entry_date)
              VALUES (i_lic_number,
                      i_lcp_ter_code,
                      i_lcp_rgh_code,
                      '-',
                      0,
                      1,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      0,
                      i_user_id,
                      SYSDATE);

         COMMIT;
      END IF;
   END;

   PROCEDURE prc_update_media_ser_plat (
      i_lic_number           IN     fid_license.lic_number%TYPE,
      i_lmps_mapp_id         IN     sgy_pb_lic_med_plat_service.lmps_mapp_id%TYPE,
      i_contract_series      IN     CHAR,
      i_insert_delete_flag   IN     CHAR,
      i_lic_con_number       IN     fid_license.lic_con_number%TYPE,
      i_entry_oper           IN     sgy_pb_lic_med_plat_service.lmps_entry_oper%TYPE,
      o_status                  OUT NUMBER)
   AS
      l_ser_number           fid_general.gen_ser_number%TYPE;
      l_lic_chs_number       fid_license.lic_chs_number%TYPE;
      l_lic_lee_number       fid_license.lic_lee_number%TYPE;
      l_con_catchup_flag     fid_contract.con_catchup_flag%TYPE;
      l_lmps_id              NUMBER;
      l_count                NUMBER;
      l_cnt                  NUMBER;
      l_cnt2                 NUMBER;
      futurescheduleexists   EXCEPTION;
   BEGIN
      /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
      SELECT con_catchup_flag
        INTO l_con_catchup_flag
        FROM fid_license, fid_contract
       WHERE lic_con_number = con_number AND lic_number = i_lic_number;

      /* Catchup CACQ11 : eND  03/12/2012 */
      o_status := -1;

      BEGIN
         SELECT gen_ser_number
           INTO l_ser_number
           FROM fid_general
          WHERE gen_refno = (SELECT lic_gen_refno
                               FROM fid_license
                              WHERE lic_number = i_lic_number);

         SELECT lic_chs_number, lic_lee_number
           INTO l_lic_chs_number, l_lic_lee_number
           FROM fid_license
          WHERE lic_number = i_lic_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
         WHEN OTHERS
         THEN
            raise_application_error (-20602, SUBSTR (SQLERRM, 1, 200));
      END;

      /*IF l_con_catchup_flag = 'Y' or l_con_catchup_flag = 'Y'*/
      -- 19/03/15 for SVOD added 'S'
      /*Above If condition changed by Swapnil on 09-jun-2015 for SVOD as below*/
      IF NVL (l_con_catchup_flag, 'N') <> 'N'
      /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
      THEN
         FOR i
            IN (SELECT lic_number
                  FROM fid_license
                 WHERE ( (i_contract_series = 'S'
                          AND lic_con_number = i_lic_con_number
                          AND lic_gen_refno IN
                                 (SELECT gen_refno
                                    FROM fid_general
                                   WHERE gen_ser_number = l_ser_number))
                        OR (i_contract_series = 'C'
                            AND lic_con_number = i_lic_con_number))
                       --AND lic_chs_number = l_lic_chs_number
                       AND lic_lee_number = l_lic_lee_number
                       AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                            )
         LOOP
            SELECT COUNT (lmps_id)
              INTO l_count
              FROM sgy_pb_lic_med_plat_service
             WHERE     lmps_lic_number = i.lic_number
                   AND lmps_mapp_id = i_lmps_mapp_id
                   AND i_insert_delete_flag = 'I';

            IF l_count = 0
            THEN
               IF i_insert_delete_flag = 'I'
               THEN
                  l_lmps_id := seq_pb_lic_med_plat_service.NEXTVAL;

                  INSERT INTO sgy_pb_lic_med_plat_service (lmps_id,
                                                           lmps_lic_number,
                                                           lmps_mapp_id,
                                                           lmps_entry_oper,
                                                           lmps_entry_date)
                       VALUES (l_lmps_id,
                               i.lic_number,
                               i_lmps_mapp_id,
                               i_entry_oper,
                               TRUNC (SYSDATE));
               ELSE
                  /* Catchup CACQ11 : added by Pranay Kusumwal 03/12/2012 */
                  SELECT COUNT (1)
                    INTO l_cnt
                    FROM x_cp_play_list
                   WHERE     plt_sch_end_date >= SYSDATE
                         AND plt_lic_number = i_lic_number
                         AND PLT_LICENSE_FLAG = l_con_catchup_flag;

                  SELECT COUNT (1)
                    INTO l_cnt2
                    FROM x_cp_schedule_bin
                   WHERE     bin_view_end_date >= SYSDATE
                         AND bin_lic_number = i_lic_number
                         AND BIN_LICENSE_FLAG = l_con_catchup_flag;

                  IF l_cnt > 0 OR l_cnt2 > 0
                  THEN
                     RAISE futurescheduleexists;
                  END IF;

                  /* Catchup CACQ11 : END 03/12/2012 */
                  DELETE FROM sgy_pb_lic_med_plat_service
                        WHERE lmps_lic_number = i.lic_number
                              AND lmps_mapp_id = i_lmps_mapp_id;
               END IF;
            END IF;
         END LOOP;

         COMMIT;
      ELSE
         /*IF l_count = 0
         THEN*/
         /*Swapnil seems logically incorrect need to check*/
         FOR i
            IN (SELECT lic_number
                  FROM fid_license
                 WHERE ( (i_contract_series = 'S'
                          AND lic_con_number = i_lic_con_number
                          AND lic_gen_refno IN
                                 (SELECT gen_refno
                                    FROM fid_general
                                   WHERE gen_ser_number = l_ser_number))
                        OR (i_contract_series = 'C'
                            AND lic_con_number = i_lic_con_number))
                       AND lic_chs_number = l_lic_chs_number
                       AND lic_lee_number = l_lic_lee_number
                       AND lic_status NOT IN ('C', 'I', 'T') -- Neeraj Basliyal : 13-06-12 : Please fix this issue P2 on cancelled licenese as it will affect the forex entries going forward
                                                            )
         LOOP
            SELECT COUNT (lmps_id)
              INTO l_count
              FROM sgy_pb_lic_med_plat_service
             WHERE     lmps_lic_number = i.lic_number
                   AND lmps_mapp_id = i_lmps_mapp_id
                   AND i_insert_delete_flag = 'I';

            IF l_count = 0
            THEN
               IF i_insert_delete_flag = 'I'
               THEN
                  l_lmps_id := seq_pb_lic_med_plat_service.NEXTVAL;

                  INSERT INTO sgy_pb_lic_med_plat_service (lmps_id,
                                                           lmps_lic_number,
                                                           lmps_mapp_id,
                                                           lmps_entry_oper,
                                                           lmps_entry_date)
                       VALUES (l_lmps_id,
                               i.lic_number,
                               i_lmps_mapp_id,
                               i_entry_oper,
                               TRUNC (SYSDATE));
               ELSE
                  DELETE FROM sgy_pb_lic_med_plat_service
                        WHERE lmps_lic_number = i.lic_number
                              AND lmps_mapp_id = i_lmps_mapp_id;
               END IF;
            END IF;
         END LOOP;

         COMMIT;
      /*END IF;*/
      END IF;

      o_status := 1;
   EXCEPTION
      WHEN futurescheduleexists
      THEN
         raise_application_error (
            -20601,
            'This license is already Scheduled or is present in Bin. Cannot Delete the Media Rights .');
   END prc_update_media_ser_plat;

   --****************************************************************
   -- This procedure validates license start date.
   -- This procedure input is license Number and modified license end date.
   -- REM Client - MNET
   --****************************************************************
   PROCEDURE prc_alic_cm_validatestartdate (
      i_licnumber   IN fid_license.lic_number%TYPE,
      i_licstart    IN fid_license.lic_start%TYPE)
   AS
      CURSOR c1
      IS
         SELECT 'X'
           FROM Fid_Schedule
          WHERE sch_fin_actual_date < I_Licstart --sch_date < i_licstart 15Apr2015:Issue :Jawahar : Allowing to schedule after lic_end date for midnight schedule after 12. Used sch_fin_actual_date.
                AND sch_lic_number = i_licnumber;

      dummy            VARCHAR2 (1);
      scheduleexists   EXCEPTION;
   BEGIN
      COMMIT;

      OPEN c1;

      FETCH c1 INTO dummy;

      IF c1%FOUND
      THEN
         RAISE scheduleexists;
      END IF;

      CLOSE c1;
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
      i_licnumber   IN fid_license.lic_number%TYPE,
      i_licend      IN fid_license.lic_end%TYPE)
   AS
      CURSOR c1
      IS
         SELECT 'X'
           FROM Fid_Schedule
          WHERE TO_DATE (
                      TO_CHAR (sch_fin_actual_date, 'DD-MON-RRRR')
                   || ' '
                   || CONVERT_TIME_N_C (SCH_TIME),
                   'DD-MON-RRRR HH24:MI:SS') >=
                   TO_DATE (i_licend || ' ' || '20:00:00',
                            'DD-MON-RRRR HH24:MI:SS') --sch_date > i_licend --7May2015:Jawahar:Business req: Not allowed to schedule before 4 hrs of lic end date
                AND sch_lic_number = i_licnumber;

      dummy            VARCHAR2 (1);
      scheduleexists   EXCEPTION;
   BEGIN
      OPEN c1;

      FETCH c1 INTO dummy;

      IF c1%FOUND
      THEN
         RAISE scheduleexists;
      END IF;

      CLOSE c1;
   EXCEPTION
      WHEN scheduleexists
      THEN
         raise_application_error (-20601,
                                  'License is scheduled after this date.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_alic_cm_validateenddate;

   /* Catchup CACQ11 : added by Pranay Kusumwal 21/03/2012 */
   --****************************************************************
   -- This procedure validates license start date for catch up.
   --****************************************************************
   PROCEDURE prc_cp_validatestartdate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licstart    IN     fid_license.lic_start%TYPE,
      o_status         OUT NUMBER)
   AS
      CURSOR c1
      IS
         SELECT 'X'
           FROM x_cp_play_list
          WHERE plt_sch_start_date < i_licstart
                AND plt_lic_number = i_licnumber;

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
   END prc_cp_validatestartdate;

   -- This procedure validates license end date of catch up..
   PROCEDURE prc_cp_validateenddate (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      i_licend      IN     fid_license.lic_end%TYPE,
      o_status         OUT NUMBER)
   AS
      CURSOR c1
      IS
         SELECT 'X'
           FROM x_cp_play_list
          WHERE plt_sch_end_date > i_licend AND plt_lic_number = i_licnumber;

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
   END prc_cp_validateenddate;

   --****************************************************************
   -- This procedure validates license status C.
   -- for catch up.
   --****************************************************************
   PROCEDURE prc_cp_validatelicstatus (
      i_licnumber   IN     fid_license.lic_number%TYPE,
      o_status         OUT NUMBER)
   AS
      l_count          NUMBER;
      costexists       EXCEPTION;
      scheduleexists   EXCEPTION;
      cost_total       NUMBER;
      asset_value      NUMBER;
   BEGIN
      SELECT COUNT (1)
        INTO l_count
        FROM x_cp_play_list
       WHERE plt_lic_number = i_licnumber;

      IF l_count > 0
      THEN
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
               'The license '
            || i_licnumber
            || ' was scheduled.Cannot change period to TBA.');
      WHEN futurescheduleexists
      THEN
         raise_application_error (
            -20601,
            'This license  ' || i_licnumber
            || ' is Scheduled. Delete Scheduled entries before changing it to TBA.');
      WHEN OTHERS
      THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END prc_cp_tbachanged;

   /* Catchup CACQ11 : end*/

   ---- Dev2: pure Finance: Start:[Magic License Copier]_[ADITYA GUPTA]_[2013/3/16]
   ---- [Magic License Copier Search Screen modifications for incorporating changes in Sec Licensees]
   PROCEDURE prc_search_lee_allocation (
      i_lic_number   IN     x_fin_lic_sec_lee.lsl_lic_number%TYPE,
      o_sec_lee         OUT pkg_alic_mn_magic_lic_copier.c_cursor_alic_mn_mgc_lic_cpr)
   AS
   BEGIN
      OPEN o_sec_lee FOR
         /* SELECT
                 LSL_NUMBER,
                 LSL_LEE_NUMBER,
                ( select lee_short_name
                   from fid_licensee
                  where LEE_NUMBER = LSL_LEE_NUMBER )  LSL_LEE_NAME,
                 lsl_lee_price,
                 LSL_IS_PRIMARY,
                 LSL_UPDATE_COUNT
           FROM X_FIN_LIC_SEC_LEE
          WHERE LSL_LIC_NUMBER = i_lic_number;*/
         SELECT sec_lee.lsl_number,
                sec_lee.lsl_lee_number,
                (SELECT lsl_lee_number
                   FROM x_fin_lic_sec_lee
                  WHERE lsl_is_primary = 'Y'
                        AND lsl_lic_number = i_lic_number)
                   "Primary_Lee",
                (SELECT lee_short_name
                   FROM fid_licensee
                  WHERE lee_number = lsl_lee_number)
                   lsl_lee_name,
                sec_lee.lsl_lee_price,
                sec_lee.lsl_is_primary,
                sec_lee.lsl_update_count,
                lic.lic_con_number,
                lic.lic_chs_number,
                NVL (gen.gen_ser_number, 0) "GEN_SER_NUMBER"
           FROM x_fin_lic_sec_lee sec_lee,
                fid_general gen,
                fid_contract con,
                fid_license lic,
                fid_channel_service chs
          WHERE     sec_lee.lsl_lic_number = i_lic_number
                AND lic.lic_number = sec_lee.lsl_lic_number
                AND lic.lic_gen_refno = gen.gen_refno
                AND lic.lic_con_number = con.con_number
                AND lic.lic_chs_number = chs.chs_number;
   END prc_search_lee_allocation;

   PROCEDURE prc_populate_sec_lee_copier (i_lic_number   IN NUMBER,
                                          i_user_id      IN VARCHAR2)
   AS
      CURSOR lcr_c
      IS
         SELECT *
           FROM x_fin_lic_sec_lee
          WHERE lsl_lic_number = i_lic_number;
   BEGIN
      DELETE FROM x_fin_lic_sec_lee_copier
            WHERE slc_lic_number = i_lic_number;

      COMMIT;

      FOR lit IN lcr_c
      LOOP
         INSERT INTO x_fin_lic_sec_lee_copier
              VALUES (lit.lsl_number,
                      lit.lsl_lic_number,
                      lit.lsl_lee_number,
                      lit.lsl_lee_price,
                      i_user_id,
                      SYSDATE,
                      0,
                      NULL,
                      NULL);
      END LOOP;

      COMMIT;
   END prc_populate_sec_lee_copier;

   PROCEDURE prc_updt_chnl_runs_sec_lee (
      i_lsl_number           IN     NUMBER,
      i_lic_number           IN     NUMBER,
      i_lic_lee_number       IN     NUMBER,
      i_lic_sec_lee_number   IN     NUMBER,
      i_lic_sec_lee_price    IN     NUMBER,
      i_lic_con_number       IN     NUMBER,
      i_lic_chs_number       IN     NUMBER,
      i_gen_ser_number       IN     fid_general.gen_ser_number%TYPE,
      i_contract_series      IN     VARCHAR2,
      i_cha_action           IN     VARCHAR2,
      i_user_id              IN     VARCHAR2,
      o_status                  OUT x_fin_lic_sec_lee.lsl_update_count%TYPE)
   AS
      CURSOR c_lic
      IS
         SELECT lic_number, lic_price
           FROM fid_license
          WHERE ( (i_contract_series = 'S'
                   AND lic_con_number = i_lic_con_number
                   AND lic_gen_refno IN
                          (SELECT gen_refno
                             FROM fid_general
                            WHERE gen_ser_number = i_gen_ser_number))
                 OR (i_contract_series = 'C'
                     AND lic_con_number = i_lic_con_number))
                AND lic_chs_number = i_lic_chs_number
                AND lic_lee_number = i_lic_lee_number
                AND lic_status NOT IN ('I', 'T', 'C');

      CURSOR chk_check_lee_exist (clic_number NUMBER, clee_number NUMBER)
      IS
         SELECT lsl_lee_number
           FROM x_fin_lic_sec_lee
          WHERE lsl_lic_number = clic_number AND lsl_lee_number = clee_number;

      l_count                     NUMBER;
      l_cnt                       NUMBER;
      l_lee_number                NUMBER;
      l_lsl_number                NUMBER;
      l_prmry_region              NUMBER;
      l_sec_region                NUMBER;
      l_pay_status                NUMBER;
      deletefailed                EXCEPTION;
      updatefailed                EXCEPTION;
      l_split_region              fid_licensee.lee_split_region%TYPE;
      l_closed_month              DATE;
      l_lic_number                fid_license.lic_number%TYPE;
      l_con_forcast               NUMBER;
      l_old_lee_number            NUMBER;
      l_lee_exits_per_lic         BOOLEAN := FALSE;
      l_licensee_changed          BOOLEAN := FALSE;
      l_sec_lee_count             NUMBER;
      l_lee_insrt_chk             NUMBER;
      l_d_lsl_number              NUMBER;
      ----changes done for finance CRs---------------------
      l_lee_price                 NUMBER;
      o_count                     NUMBER;
      l_count1                    NUMBER;
      l_flag                      VARCHAR2 (10);
      l_paid_amt                  NUMBER;
      l_remain_amt                NUMBER;
      targetcom                   NUMBER;
      l_mem_agy_com_number        NUMBER;
      l_mem_com_number            NUMBER;
      sourcecom                   NUMBER;
      contentstatus               VARCHAR2 (5);
      l_con_number                NUMBER;
      l_notpaid_amt               NUMBER;
      l_notpaid_amt1              NUMBER;
      l_number                    NUMBER;
      l_lic_currency              VARCHAR2 (5);
      totalpay                    NUMBER;
      o_lsl_number                NUMBER;
      l_primary_lee_old           NUMBER;
      l_primary_lee_new           NUMBER;
      l_lic_lsl_number            NUMBER;
      l_total_pay_price           NUMBER;
      l_pay_number                NUMBER;
      l_extra_pay_amt             NUMBER;
      o_lsl_number1               NUMBER;
      l_ren_number                NUMBER;
      L_Status2                   NUMBER := -1;
      l_notpaid_amt_bef_sysdate   NUMBER := 0;
   -------END------------------------
   BEGIN
      o_status := -1;
      pkg_alic_mn_magic_lic_copier.prc_populate_sec_lee_copier (i_lic_number,
                                                                i_user_id);

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

      SELECT COUNT (*)
        INTO l_count
        FROM x_fin_lic_sec_lee_copier
       WHERE slc_lic_number = i_lic_number AND slc_lsl_number = i_lsl_number;

      IF i_cha_action = 'U'
      THEN
         IF (i_lic_sec_lee_number <> 0)
         THEN
            SELECT lsl_lee_number
              INTO l_old_lee_number
              FROM x_fin_lic_sec_lee
             WHERE lsl_number = i_lsl_number;

            -- DBMS_OUTPUT.put_line ('l_old_lee_number :' || l_old_lee_number);
            --  DBMS_OUTPUT.put_line (
            --     'i_lic_sec_lee_number :' || i_lic_sec_lee_number);

            --check if licensee has been changed
            IF l_old_lee_number <> i_lic_sec_lee_number
            THEN
               l_licensee_changed := TRUE;
            ELSE
               l_licensee_changed := FALSE;
            END IF;

            IF (l_prmry_region = l_sec_region)
            THEN
               IF l_count > 0
               THEN
                  IF l_licensee_changed = TRUE
                  THEN
                     --DBMS_OUTPUT.put_line ( 'inside l_licensee_changed = TRUE 1');

                     UPDATE x_fin_lic_sec_lee_copier
                        SET slc_lee_number = i_lic_sec_lee_number,
                            slc_lee_price = ROUND (i_lic_sec_lee_price, 4)
                      WHERE slc_lic_number = i_lic_number
                            AND slc_lsl_number = i_lsl_number;
                  ELSE
                     --- DBMS_OUTPUT.put_line ('inside l_licensee_changed = FALSE');

                     UPDATE x_fin_lic_sec_lee_copier
                        SET slc_lee_price = ROUND (i_lic_sec_lee_price, 4)
                      WHERE slc_lic_number = i_lic_number
                            AND slc_lsl_number = i_lsl_number;
                  END IF;

                  COMMIT;
               END IF;

               ---- DEV3: SAP Implementation:Start:<24/7/2013>:<payment plan on cancellation of licenses>
               /*SELECT lsl_lee_price
                   INTO l_lee_price
                   from x_fin_lic_sec_lee
                  WHERE lsl_number = i_lsl_number;*/

               ---- DEV3: SAP Implementation:End:<24/7/2013>---------------------
               FOR rec_lic IN c_lic
               LOOP
                  ---- DEV3: SAP Implementation:Start:<24/7/2013>:<payment plan on cancellation of licenses>
                  /* select lsl_lee_number into l_primary_lee_old from x_fin_lic_sec_lee where lsl_lic_number=i_lic_number
                     and lsl_is_primary ='Y';

                   select lsl_lee_number into l_primary_lee_new from x_fin_lic_sec_lee where lsl_lic_number=rec_lic.lic_number
                   and lsl_is_primary ='Y';

               if (l_primary_lee_old = l_primary_lee_new)
               then*/
                  BEGIN
                     SELECT lsl_number, lsl_lee_price
                       INTO l_lic_lsl_number, l_lee_price
                       FROM x_fin_lic_sec_lee
                      WHERE lsl_lic_number = rec_lic.lic_number
                            AND lsl_lee_number = i_lic_sec_lee_number;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        /* PKG_ALIC_CM_LICENSEMAINTENANCE.prc_add_lee_allocation(rec_lic.lic_number,i_lic_sec_lee_number,0,'N',i_user_id,sysdate,l_status2);
                         if (l_status2 <> -1) then
                         SELECT lsl_number, lsl_lee_price
                          INTO l_lic_lsl_number, l_lee_price
                          FROM x_fin_lic_sec_lee
                         WHERE lsl_lic_number = rec_lic.lic_number
                               AND lsl_lee_number = i_lic_sec_lee_number;
                         end if;      */
                        BEGIN
                           SELECT lsl_number, lsl_lee_price
                             INTO l_lic_lsl_number, l_lee_price
                             FROM x_fin_lic_sec_lee
                            WHERE lsl_lic_number = rec_lic.lic_number
                                  AND lsl_lee_number = l_old_lee_number; --i_lic_sec_lee_number;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              l_lic_lsl_number := -1;
                        END;
                  END;

                  IF l_lic_lsl_number <> -1
                  THEN
                     IF i_lic_sec_lee_price <> l_lee_price
                     THEN
                        IF l_lee_price = 0                 ----for scenario 12
                        THEN
                           SELECT mem_agy_com_number, mem_com_number
                             INTO l_mem_agy_com_number, l_mem_com_number
                             FROM sak_memo
                            WHERE mem_id IN
                                     (SELECT lic_mem_number
                                        FROM fid_license
                                       WHERE lic_number = rec_lic.lic_number);

                           SELECT lic_con_number, lic_currency
                             INTO l_con_number, l_lic_currency
                             FROM fid_license
                            WHERE lic_number = rec_lic.lic_number;

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
                                VALUES (seq_pay_number.NEXTVAL,
                                        sourcecom,
                                        targetcom,
                                        l_con_number,
                                        rec_lic.lic_number,
                                        'N',
                                        SYSDATE,
                                        i_lic_sec_lee_price,
                                        l_lic_currency,
                                        NULL,
                                        'G',
                                        TRUNC (SYSDATE),
                                        NULL,
                                        NULL,
                                        NULL,
                                        SYSDATE,
                                        i_user_id,
                                        NULL,
                                        l_lic_lsl_number,
                                        'Y',
                                        100);
                        ELSIF i_lic_sec_lee_price = 0
                        THEN
                           SELECT COUNT (*)
                             INTO o_count
                             FROM fid_payment
                            WHERE pay_lsl_number = l_lic_lsl_number
                                  AND pay_status = 'P';

                           SELECT pkg_cm_username.setusername (i_user_id)
                             INTO l_number
                             FROM DUAL;

                           DELETE FROM fid_payment
                                 WHERE pay_lsl_number = l_lic_lsl_number
                                       AND pay_status = 'N';

                           IF o_count > 0
                           THEN
                              SELECT NVL (SUM (pay_amount), 0)
                                INTO l_paid_amt
                                FROM fid_payment
                               WHERE pay_lsl_number = l_lic_lsl_number
                                     AND pay_status = 'P';

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
                                      WHERE pay_lsl_number = l_lic_lsl_number
                                            AND ROWNUM < 2)
                              LOOP
                                 BEGIN
                                    IF l_paid_amt <> 0
                                    THEN
                                       INSERT
                                         INTO fid_payment (
                                                 pay_number,
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
                                                 rec_lic.lic_number,
                                                 'N',
                                                 SYSDATE,
                                                 -l_paid_amt,
                                                 pay.pay_cur_code,
                                                 NULL,
                                                 pay.pay_code,
                                                 LAST_DAY (TRUNC (SYSDATE)),
                                                 NULL,
                                                 'Refund Required owing to Price Change on '
                                                 || TO_CHAR (TRUNC (SYSDATE),
                                                             'DD-Mon-RRRR'),
                                                 NULL,
                                                 SYSDATE,
                                                 i_user_id,
                                                 pay.pay_month_no,
                                                 pay.pay_lsl_number,
                                                 'Y',
                                                 NULL);
                                    END IF;
                                 EXCEPTION
                                    WHEN OTHERS
                                    THEN
                                       raise_application_error (
                                          -20601,
                                          SUBSTR (SQLERRM, 1, 200));
                                 END;
                              END LOOP;
                           END IF;
                        ELSIF i_lic_sec_lee_price > l_lee_price
                        THEN
                           ----for all paid payment
                           SELECT COUNT (*)
                             INTO o_count
                             FROM fid_payment
                            WHERE     pay_lic_number = rec_lic.lic_number
                                  AND pay_lsl_number = l_lic_lsl_number
                                  AND pay_status = 'N';

                           IF o_count = 0
                           THEN
                              l_flag := 'paid';
                           END IF;

                           SELECT COUNT (*)
                             INTO l_count1
                             FROM fid_payment
                            WHERE     pay_lic_number = rec_lic.lic_number
                                  AND pay_lsl_number = l_lic_lsl_number
                                  AND pay_status = 'P';

                           IF l_count1 = 0
                           THEN
                              l_flag := 'notpaid';
                           END IF;

                           IF l_flag = 'paid' ---for all paid payment(scenario3)
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
                                      WHERE pay_lsl_number = l_lic_lsl_number
                                            AND ROWNUM < 2)
                              LOOP
                                 BEGIN
                                    INSERT
                                      INTO fid_payment (
                                              pay_number,
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
                                              rec_lic.lic_number,
                                              'N',
                                              SYSDATE,
                                              (i_lic_sec_lee_price
                                               - l_lee_price),
                                              pay.pay_cur_code,
                                              NULL,
                                              pay.pay_code,
                                              LAST_DAY (TRUNC (SYSDATE)),
                                              NULL,
                                              'Additional Payment owing to Price Change on '
                                              || TO_CHAR (TRUNC (SYSDATE),
                                                          'DD-Mon-RRRR'),
                                              NULL,
                                              SYSDATE,
                                              i_user_id,
                                              pay.pay_month_no,
                                              pay.pay_lsl_number,
                                              'Y',
                                              NULL);
                                 EXCEPTION
                                    WHEN OTHERS
                                    THEN
                                       raise_application_error (
                                          -20601,
                                          SUBSTR (SQLERRM, 1, 200));
                                 END;
                              END LOOP;
                           ELSIF l_flag = 'notpaid'
                           ---for all paid payment(scenario4)
                           THEN
                              SELECT SUM (pay_amount)
                                INTO l_notpaid_amt1
                                FROM fid_payment
                               WHERE pay_lsl_number = l_lic_lsl_number;

                              FOR pay
                                 IN (SELECT pay_number, pay_amount
                                       FROM fid_payment
                                      WHERE pay_lsl_number = l_lic_lsl_number)
                              LOOP
                                 UPDATE fid_payment
                                    SET pay_amount =
                                           ROUND (
                                              i_lic_sec_lee_price
                                              * (pay.pay_amount
                                                 / l_notpaid_amt1),
                                              2),
                                        pay_comment =
                                           'Updated Payment owing to Price Change on '
                                           || TO_CHAR (TRUNC (SYSDATE),
                                                       'DD-Mon-RRRR')
                                  WHERE pay_number = pay.pay_number;
                              END LOOP;
                           ELSE                 ---for scenario1 and scenario2
                              SELECT SUM (pay_amount)
                                INTO l_paid_amt
                                FROM fid_payment
                               WHERE pay_lsl_number = l_lic_lsl_number
                                     AND pay_status = 'P';

                              SELECT SUM (pay_amount)
                                INTO l_notpaid_amt1
                                FROM fid_payment
                               WHERE pay_lsl_number = l_lic_lsl_number
                                     AND pay_status = 'N';

                              FOR pay
                                 IN (SELECT pay_number, pay_amount
                                       FROM fid_payment
                                      WHERE pay_lsl_number = l_lic_lsl_number
                                            AND pay_status = 'N')
                              LOOP
                                 UPDATE fid_payment
                                    SET pay_amount =
                                           ROUND (
                                              i_lic_sec_lee_price
                                              * (pay.pay_amount
                                                 / (l_paid_amt
                                                    + l_notpaid_amt1)),
                                              2),
                                        pay_comment =
                                           'Updated Payment owing to Price Change on '
                                           || TO_CHAR (TRUNC (SYSDATE),
                                                       'DD-Mon-RRRR')
                                  WHERE pay_number = pay.pay_number;
                              END LOOP;

                              SELECT SUM (pay_amount)
                                INTO l_notpaid_amt
                                FROM fid_payment
                               WHERE pay_lsl_number = l_lic_lsl_number
                                     AND pay_status = 'N';

                              l_remain_amt :=
                                 i_lic_sec_lee_price
                                 - (l_paid_amt + l_notpaid_amt);

                              SELECT NVL (SUM (Pay_Amount), 0)
                                INTO l_notpaid_amt_bef_sysdate
                                FROM fid_payment
                               WHERE pay_lsl_number = l_lic_lsl_number
                                     AND pay_status = 'N'
                                     AND TO_CHAR (Pay_Due, 'YYYYMMDD') <=
                                            TO_CHAR (SYSDATE, 'YYYYMMDD') --To_Char(Sysdate,'YYYYMMDD')
                                                                         ;

                              IF L_Remain_Amt <> 0
                              THEN
                                 IF l_notpaid_amt_bef_sysdate = 0
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
                                            WHERE pay_lsl_number =
                                                     l_lic_lsl_number
                                                  AND ROWNUM < 2)
                                    LOOP
                                       BEGIN
                                          INSERT
                                            INTO fid_payment (
                                                    pay_number,
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
                                                    rec_lic.lic_number,
                                                    'N',
                                                    SYSDATE,
                                                    l_remain_amt,
                                                    pay.pay_cur_code,
                                                    NULL,
                                                    pay.pay_code,
                                                    LAST_DAY (
                                                       TRUNC (SYSDATE)),
                                                    NULL,
                                                    'Additional Payment owing to Price Change on '
                                                    || TO_CHAR (
                                                          TRUNC (SYSDATE),
                                                          'DD-Mon-RRRR'),
                                                    NULL,
                                                    SYSDATE,
                                                    i_user_id,
                                                    pay.pay_month_no,
                                                    pay.pay_lsl_number,
                                                    'Y',
                                                    NULL);
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             raise_application_error (
                                                -20601,
                                                SUBSTR (SQLERRM, 1, 200));
                                       END;
                                    END LOOP;
                                 ELSE
                                    SELECT Pay_Number
                                      INTO l_pay_number
                                      FROM (SELECT Pay_Due,
                                                   Pay_Number,
                                                   ROWNUM L_Rownum
                                              FROM (  SELECT pay_due,
                                                             pay_number
                                                        FROM Fid_Payment
                                                       WHERE pay_lsl_number =
                                                                l_lic_lsl_number
                                                             AND TO_CHAR (
                                                                    Pay_Due,
                                                                    'YYYYMMDD') <=
                                                                    TO_CHAR (
                                                                       SYSDATE,
                                                                       'YYYYMMDD') --To_Char(Sysdate,'YYYYMMDD')
                                                             AND pay_status =
                                                                    'N'
                                                    ORDER BY Pay_Due DESC,
                                                             Pay_Number DESC))
                                     WHERE L_Rownum = 1;

                                    UPDATE fid_payment
                                       SET pay_amount =
                                              pay_amount + l_remain_amt,
                                           pay_comment =
                                              'Updated Payment owing to Price Change on '
                                              || TO_CHAR (TRUNC (SYSDATE),
                                                          'DD-Mon-RRRR'),
                                           pay_entry_oper = i_user_id,
                                           Pay_Entry_Date = SYSDATE
                                     WHERE Pay_Number = L_Pay_Number
                                           AND pay_status = 'N';
                                 END IF;
                              END IF;
                           END IF;
                        ELSE
                           ------for licensee allocation less than already allocated
                           --  if i_lic_sec_lee_price < l_lee_price
                           -- then
                           ----for all paid payment
                           SELECT COUNT (*)
                             INTO o_count
                             FROM fid_payment
                            WHERE     pay_lic_number = rec_lic.lic_number
                                  AND pay_lsl_number = l_lic_lsl_number
                                  AND pay_status = 'N';

                           IF o_count = 0
                           THEN
                              l_flag := 'paid';
                           END IF;

                           SELECT COUNT (*)
                             INTO l_count1
                             FROM fid_payment
                            WHERE     pay_lic_number = rec_lic.lic_number
                                  AND pay_lsl_number = l_lic_lsl_number
                                  AND pay_status = 'P';

                           IF l_count1 = 0
                           THEN
                              l_flag := 'notpaid';
                           END IF;

                           IF l_flag = 'paid' ----for all paid payment(scenario7)
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
                                      WHERE pay_lsl_number = l_lic_lsl_number
                                            AND ROWNUM < 2)
                              LOOP
                                 BEGIN
                                    IF (i_lic_sec_lee_price - l_lee_price) <>
                                          0
                                    THEN
                                       INSERT
                                         INTO fid_payment (
                                                 pay_number,
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
                                                 rec_lic.lic_number,
                                                 'N',
                                                 SYSDATE,
                                                 (i_lic_sec_lee_price
                                                  - l_lee_price),
                                                 pay.pay_cur_code,
                                                 NULL,
                                                 pay.pay_code,
                                                 LAST_DAY (TRUNC (SYSDATE)),
                                                 NULL,
                                                 'Refund Required owing to Price Change on '
                                                 || TO_CHAR (TRUNC (SYSDATE),
                                                             'DD-Mon-RRRR'),
                                                 NULL,
                                                 SYSDATE,
                                                 i_user_id,
                                                 pay.pay_month_no,
                                                 pay.pay_lsl_number,
                                                 'Y',
                                                 NULL);
                                    END IF;
                                 EXCEPTION
                                    WHEN OTHERS
                                    THEN
                                       raise_application_error (
                                          -20601,
                                          SUBSTR (SQLERRM, 1, 200));
                                 END;
                              END LOOP;
                           ELSIF l_flag = 'notpaid'
                           ----for all not paid payment(scenario8)
                           THEN
                              SELECT SUM (pay_amount)
                                INTO l_notpaid_amt
                                FROM fid_payment
                               WHERE pay_lsl_number = l_lic_lsl_number;

                              FOR pay
                                 IN (SELECT pay_number, pay_amount
                                       FROM fid_payment
                                      WHERE pay_lsl_number = l_lic_lsl_number)
                              LOOP
                                 UPDATE fid_payment
                                    SET pay_amount =
                                           ROUND (
                                              i_lic_sec_lee_price
                                              * (pay.pay_amount
                                                 / l_notpaid_amt),
                                              2),
                                        pay_comment =
                                           'Updated Payment owing to Price Change on '
                                           || TO_CHAR (TRUNC (SYSDATE),
                                                       'DD-Mon-RRRR')
                                  WHERE pay_number = pay.pay_number;
                              END LOOP;
                           ELSE                 ---for scenario5 and scenario6
                              SELECT SUM (pay_amount)
                                INTO l_paid_amt
                                FROM fid_payment
                               WHERE pay_lsl_number = l_lic_lsl_number
                                     AND pay_status = 'P';

                              l_remain_amt := i_lic_sec_lee_price - l_paid_amt;

                              ----------------when new price is less than total paid price
                              IF l_remain_amt < 0
                              THEN
                                 SELECT pkg_cm_username.setusername (
                                           i_user_id)
                                   INTO l_number
                                   FROM DUAL;

                                 DELETE FROM fid_payment
                                       WHERE pay_lsl_number =
                                                l_lic_lsl_number
                                             AND pay_status = 'N';

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
                                         WHERE pay_lsl_number =
                                                  l_lic_lsl_number
                                               AND ROWNUM < 2)
                                 LOOP
                                    IF l_remain_amt <> 0
                                    THEN
                                       INSERT
                                         INTO fid_payment (
                                                 pay_number,
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
                                                 rec_lic.lic_number,
                                                 'N',
                                                 SYSDATE,
                                                 l_remain_amt,
                                                 pay.pay_cur_code,
                                                 NULL,
                                                 pay.pay_code,
                                                 LAST_DAY (TRUNC (SYSDATE)),
                                                 NULL,
                                                 'Refund Required owing to Price Change on '
                                                 || TO_CHAR (TRUNC (SYSDATE),
                                                             'DD-Mon-RRRR'),
                                                 NULL,
                                                 SYSDATE,
                                                 i_user_id,
                                                 pay.pay_month_no,
                                                 pay.pay_lsl_number,
                                                 'Y',
                                                 NULL);
                                    END IF;
                                 END LOOP;
                              ELSE
                                 ---------------when new price is less than than total paid price
                                 SELECT SUM (pay_amount)
                                   INTO l_notpaid_amt
                                   FROM fid_payment
                                  WHERE pay_lsl_number = l_lic_lsl_number
                                        AND pay_status = 'N';

                                 FOR pay
                                    IN (SELECT pay_number, pay_amount
                                          FROM fid_payment
                                         WHERE pay_lsl_number =
                                                  l_lic_lsl_number
                                               AND pay_status = 'N')
                                 LOOP
                                    UPDATE fid_payment
                                       SET pay_amount =
                                              ROUND (
                                                 l_remain_amt
                                                 * (pay.pay_amount
                                                    / l_notpaid_amt),
                                                 2),
                                           pay_comment =
                                              'Updated Payment owing to Price Change on '
                                              || TO_CHAR (TRUNC (SYSDATE),
                                                          'DD-Mon-RRRR')
                                     WHERE pay_number = pay.pay_number;
                                 END LOOP;
                              END IF;
                           END IF;
                        END IF;

                        -----rounding off payment up to 2 decimal-------------------------
                        SELECT SUM (pay_amount)
                          INTO l_total_pay_price
                          FROM fid_payment
                         WHERE pay_lic_number = rec_lic.lic_number
                               AND pay_lsl_number = l_lic_lsl_number;

                        l_extra_pay_amt :=
                           l_total_pay_price - i_lic_sec_lee_price;

                        IF l_extra_pay_amt <> 0
                        THEN
                           SELECT MIN (pay_number)
                             INTO l_pay_number
                             FROM fid_payment
                            WHERE     pay_lic_number = rec_lic.lic_number
                                  AND pay_lsl_number = l_lic_lsl_number
                                  AND pay_status = 'N';

                           UPDATE fid_payment
                              SET pay_amount = pay_amount - l_extra_pay_amt
                            WHERE pay_number = l_pay_number;
                        END IF;
                     END IF;
                  END IF;

                  -------end rounding off------------------------------------------
                  ---- DEV3: SAP Implementation:End:<24/7/2013>---------------------
                  --check if licensee has been changed
                  IF l_licensee_changed = TRUE
                  THEN
                     --check if the secondry licensee alredy exist for the license
                     --if it exits the dont update the licensee else
                     --update the licensee
                     -- DBMS_OUTPUT.put_line ('inside l_licensee_changed = TRUE 2');

                     SELECT COUNT (*)
                       INTO l_sec_lee_count
                       FROM x_fin_lic_sec_lee
                      WHERE lsl_lic_number = rec_lic.lic_number
                            AND lsl_lee_number = i_lic_sec_lee_number;

                     IF l_sec_lee_count = 0
                     THEN
                        l_lee_exits_per_lic := FALSE;
                     ELSE
                        l_lee_exits_per_lic := TRUE;
                     END IF;
                  ELSE
                     l_lee_exits_per_lic := FALSE;
                  END IF;

                  FOR slc IN (SELECT *
                                FROM x_fin_lic_sec_lee_copier
                               WHERE slc_lic_number = i_lic_number)
                  LOOP
                     --check if licensee has been changed

                     --check if licensee already exist
                     IF l_licensee_changed = TRUE
                     THEN
                        -- DBMS_OUTPUT.put_line ('inside l_licensee_changed = TRUE');
                        -- DBMS_OUTPUT.put_line ('l_old_lee_number : ' || l_old_lee_number);

                        OPEN chk_check_lee_exist (rec_lic.lic_number,
                                                  l_old_lee_number);
                     ELSE
                        -- DBMS_OUTPUT.put_line ('inside l_licensee_changed = FALSE');
                        -- DBMS_OUTPUT.put_line ('slc.SLC_LEE_NUMBER : ' || slc.slc_lee_number);

                        OPEN chk_check_lee_exist (rec_lic.lic_number,
                                                  slc.slc_lee_number);
                     END IF;

                     FETCH chk_check_lee_exist INTO l_lee_number;

                     --DBMS_OUTPUT.put_line ('rec_lic.lic_number = ' || rec_lic.lic_number);

                     IF chk_check_lee_exist%FOUND
                     THEN
                        -- DBMS_OUTPUT.put_line ('inside chk_check_lee_exist%FOUND');

                        IF l_licensee_changed = TRUE
                           AND l_lee_exits_per_lic = FALSE
                        THEN
                           --  DBMS_OUTPUT.put_line ('inside l_licensee_changed = TRUE and l_lee_exits_per_lic = FALSE');
                           --  DBMS_OUTPUT.put_line ('slc.SLC_LEE_NUMBER ::' || slc.slc_lee_number);
                           --   DBMS_OUTPUT.put_line ('l_old_lee_number ::' || l_old_lee_number);

                           SELECT COUNT (*)
                             INTO l_lee_insrt_chk
                             FROM x_fin_lic_sec_lee
                            WHERE lsl_lee_number = slc.slc_lee_number
                                  AND lsl_lic_number = rec_lic.lic_number;

                           IF (l_lee_insrt_chk = 0)
                           THEN
                              UPDATE x_fin_lic_sec_lee
                                 SET lsl_lee_number = slc.slc_lee_number,
                                     lsl_lee_price =
                                        ROUND (slc.slc_lee_price, 2),
                                     lsl_modified_by = i_user_id,
                                     lsl_modified_on = SYSDATE
                               WHERE lsl_lic_number = rec_lic.lic_number
                                     AND lsl_lee_number = l_old_lee_number;
                           END IF;
                        ELSIF l_licensee_changed = TRUE
                              AND l_lee_exits_per_lic = TRUE
                        THEN
                           --DBMS_OUTPUT.put_line ('inside l_licensee_changed = TRUE and l_lee_exits_per_lic = TRUE');

                           UPDATE x_fin_lic_sec_lee
                              SET lsl_lee_price = ROUND (slc.slc_lee_price, 2),
                                  lsl_modified_by = i_user_id,
                                  lsl_modified_on = SYSDATE
                            WHERE lsl_lic_number = rec_lic.lic_number
                                  AND lsl_lee_number = l_old_lee_number;
                        ELSE
                           -- DBMS_OUTPUT.put_line (' inside no licensee changed ');

                           UPDATE x_fin_lic_sec_lee
                              SET lsl_lee_price = ROUND (slc.slc_lee_price, 2),
                                  lsl_modified_by = i_user_id,
                                  lsl_modified_on = SYSDATE
                            WHERE lsl_lic_number = rec_lic.lic_number
                                  AND lsl_lee_number = slc.slc_lee_number;
                        END IF;

                        --AND LSL_NUMBER = slc.SLC_LSL_NUMBER;
                        COMMIT;
                        o_status := 1;
                     --            END IF;
                     END IF;

                     CLOSE chk_check_lee_exist;
                  END LOOP;
               END LOOP;
            ELSE
               raise_application_error (
                  -20103,
                  'Licensee is not under primary licensee region');
               o_status := -1;
            END IF;
         END IF;
      ELSIF i_cha_action = 'A'
      THEN
         -- DBMS_OUTPUT.put_line ('inside A :');

         /*   SELECT COUNT (*)
                    INTO l_cnt
                    FROM x_fin_lic_sec_lee_copier
                   WHERE SLC_LIC_NUMBER = i_lic_number
                     AND SLC_LEE_NUMBER = i_lic_sec_lee_number ;
           */
         IF (l_prmry_region = l_sec_region)
         THEN
            IF l_count = 0
            THEN
               -- DBMS_OUTPUT.put_line ('inside lcount = 0  :');

               INSERT INTO x_fin_lic_sec_lee_copier
                    VALUES (i_lsl_number,
                            i_lic_number,
                            i_lic_sec_lee_number,
                            ROUND (i_lic_sec_lee_price, 4),
                            i_user_id,
                            SYSDATE,
                            0,
                            NULL,
                            NULL);

               COMMIT;
            END IF;

            FOR rec_lic IN c_lic
            LOOP
               -- DBMS_OUTPUT.put_line ('inside 1st FOR licenses loop  :');

               FOR slc IN (SELECT *
                             FROM x_fin_lic_sec_lee_copier
                            WHERE slc_lic_number = i_lic_number)
               LOOP
                  -- DBMS_OUTPUT.put_line ('inside 2nd FOR copier loop  :');

                  SELECT COUNT (lsl_number)
                    INTO l_lsl_number
                    FROM x_fin_lic_sec_lee
                   WHERE lsl_lic_number = rec_lic.lic_number
                         AND lsl_number = slc.slc_lsl_number;

                  IF l_lsl_number = 0
                  THEN
                     -- DBMS_OUTPUT.put_line ('inside l_lsl_number = 0  :');
                     -- DBMS_OUTPUT.put_line ('rec_lic.lic_number = ' || rec_lic.lic_number);

                     SELECT COUNT (*)
                       INTO l_cnt
                       FROM x_fin_lic_sec_lee
                      WHERE lsl_lic_number = rec_lic.lic_number
                            AND lsl_lee_number = slc.slc_lee_number;

                     IF l_cnt = 0
                     THEN
                        IF (slc.slc_lee_number <> 0)
                        THEN
                           INSERT INTO x_fin_lic_sec_lee (lsl_number,
                                                          lsl_lic_number,
                                                          lsl_lee_number,
                                                          lsl_lee_price,
                                                          lsl_entry_oper,
                                                          lsl_entry_date,
                                                          lsl_update_count,
                                                          lsl_is_primary)
                                VALUES (x_seq_lic_sec_lee.NEXTVAL,
                                        rec_lic.lic_number,
                                        slc.slc_lee_number,
                                        ROUND (slc.slc_lee_price, 2),
                                        i_user_id,
                                        SYSDATE,
                                        0,
                                        'N');

                           ----- DEV3: SAP Implementation:Start:<24/7/2013>:<payment plan on addition of licensee>
                           IF i_lic_sec_lee_price <> 0
                           THEN
                              SELECT lsl_number
                                INTO o_lsl_number
                                FROM x_fin_lic_sec_lee
                               WHERE lsl_lic_number = i_lic_number
                                     AND lsl_is_primary = 'Y';

                              SELECT ROUND (NVL (SUM (pay_amount), 0), 2)
                                INTO totalpay
                                FROM fid_payment
                               WHERE pay_lsl_number = o_lsl_number;

                              FOR lsl_c
                                 IN (SELECT lsl_number, lsl_lee_price
                                       FROM x_fin_lic_sec_lee
                                      WHERE lsl_lic_number =
                                               rec_lic.lic_number
                                            AND lsl_lee_number =
                                                   slc.slc_lee_number)
                              LOOP
                                 o_lsl_number1 := lsl_c.lsl_number;

                                 FOR pay
                                    IN (SELECT pay_source_com_number,
                                               pay_target_com_number,
                                               pay_con_number,
                                               pay_cur_code,
                                               pay_code,
                                               pay_amount,
                                               pay_status,
                                               pay_due,
                                               pay_month_no
                                          FROM fid_payment
                                         WHERE pay_lsl_number = o_lsl_number)
                                 LOOP
                                    BEGIN
                                       INSERT
                                         INTO fid_payment (
                                                 pay_number,
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
                                                 rec_lic.lic_number,
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
                                                 DECODE (
                                                    pay.pay_status,
                                                    'P', LAST_DAY (
                                                            TRUNC (SYSDATE)),
                                                    pay.pay_due),
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 SYSDATE,
                                                 i_user_id,
                                                 pay.pay_month_no,
                                                 lsl_c.lsl_number,
                                                 'Y',
                                                 (  pay.pay_amount
                                                  * 100
                                                  / totalpay));
                                    EXCEPTION
                                       WHEN OTHERS
                                       THEN
                                          raise_application_error (
                                             -20601,
                                             SUBSTR (SQLERRM, 1, 200));
                                    END;
                                 END LOOP;
                              END LOOP;

                              -----rounding off payment up to 2 decimal-------------------------
                              SELECT SUM (pay_amount)
                                INTO l_total_pay_price
                                FROM fid_payment
                               WHERE pay_lic_number = rec_lic.lic_number
                                     AND pay_lsl_number = o_lsl_number1;

                              l_extra_pay_amt :=
                                 l_total_pay_price - i_lic_sec_lee_price;

                              IF l_extra_pay_amt <> 0
                              THEN
                                 SELECT MIN (pay_number)
                                   INTO l_pay_number
                                   FROM fid_payment
                                  WHERE pay_lic_number = rec_lic.lic_number
                                        AND pay_lsl_number = o_lsl_number1
                                        AND pay_status = 'N';

                                 UPDATE fid_payment
                                    SET pay_amount =
                                           pay_amount - l_extra_pay_amt
                                  WHERE pay_number = l_pay_number;
                              END IF;
                           END IF;

                           -------end rounding off------------------------------------------
                           ---- DEV3: SAP Implementation:End:<24/7/2013>---------------------
                           o_status := 1;
                        END IF;
                     ELSE
                        NULL;
                     END IF;
                  END IF;
               END LOOP;
            END LOOP;

            COMMIT;
         ELSE
            raise_application_error (
               -20103,
               'Licensee is not under primary licensee region');
            o_status := -1;
         END IF;
      ELSIF i_cha_action = 'D'
      THEN
         FOR rec_lic IN c_lic
         LOOP
            FOR slc
               IN (SELECT *
                     FROM x_fin_lic_sec_lee_copier
                    WHERE slc_lic_number = i_lic_number
                          AND slc_lsl_number = i_lsl_number)
            LOOP
               OPEN chk_check_lee_exist (rec_lic.lic_number,
                                         slc.slc_lee_number);

               FETCH chk_check_lee_exist INTO l_lee_number;

               IF chk_check_lee_exist%FOUND
               THEN
                  SELECT COUNT (pay_status)
                    INTO l_pay_status
                    FROM fid_payment
                   WHERE pay_lsl_number = slc.slc_lsl_number
                         AND pay_status = 'P';

                  IF l_pay_status > 0
                  THEN
                     RAISE deletefailed;
                  ELSE
                     SELECT lee_split_region
                       INTO l_split_region
                       FROM fid_licensee
                      WHERE lee_number IN
                               (SELECT lic_lee_number
                                  FROM fid_license
                                 WHERE lic_number = rec_lic.lic_number);

                     SELECT MAX (
                               TO_DATE (fim_year || LPAD (fim_month, 2, 0),
                                        'RRRRMM'))
                       INTO l_closed_month
                       FROM fid_financial_month
                      WHERE fim_status = 'C'
                            AND fim_split_region = l_split_region;

                     SELECT NVL (SUM (lis_con_forecast), 0)
                       INTO l_con_forcast
                       FROM fid_license_sub_ledger
                      WHERE lis_lic_number = rec_lic.lic_number
                            AND TO_DATE (
                                   lis_per_year || LPAD (lis_per_month, 2, 0),
                                   'RRRRMM') <= l_closed_month;

                     --DBMS_OUTPUT.put_line (' l_con_forcast ::' || l_con_forcast);

                     IF l_con_forcast > 0
                     THEN
                        RAISE deletefailed;
                     ELSE
                        l_ren_number :=
                           pkg_cm_username.setusername (i_user_id);

                        -- DBMS_OUTPUT.put_line (' rec_lic.lic_number ::' || rec_lic.lic_number);
                        -- DBMS_OUTPUT.put_line (' slc.SLC_LSL_NUMBER ::' || slc.slc_lsl_number);

                        BEGIN
                           SELECT lsl_number
                             INTO l_d_lsl_number
                             FROM x_fin_lic_sec_lee
                            WHERE lsl_lic_number = rec_lic.lic_number
                                  AND lsl_lee_number = slc.slc_lee_number;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              l_d_lsl_number := 0;
                        END;

                        DELETE FROM fid_payment
                              WHERE pay_lsl_number = l_d_lsl_number;

                        DELETE FROM fid_license_sub_ledger
                              WHERE lis_lsl_number = l_d_lsl_number;

                        DELETE FROM x_fin_unrealized_forex
                              WHERE unf_lsl_number = l_d_lsl_number;

                        DELETE FROM x_fin_lic_sec_lee
                              WHERE     lsl_lic_number = rec_lic.lic_number
                                    AND lsl_lee_number = slc.slc_lee_number
                                    AND lsl_is_primary = 'N';

                        COMMIT;
                        o_status := 1;
                     END IF;
                  END IF;
               END IF;

               CLOSE chk_check_lee_exist;
            END LOOP;
         END LOOP;
      END IF;
   EXCEPTION
      WHEN deletefailed
      THEN
         raise_application_error (-20601, 'This licensee cannot be deleted.');
      WHEN updatefailed
      THEN
         raise_application_error (
            -20601,
            'This licensee is Paid. Only Unpaid licensees can be updated.');
   END prc_updt_chnl_runs_sec_lee;

   ---- Dev2: Pure Finance: End

   PROCEDURE X_prc_trf_pay_series_search (
      i_con_number          IN     fid_contract.con_number%TYPE,
      i_lic_number          IN     fid_license.lic_number%TYPE,
      i_gen_refno           IN     FID_GENERAL.GEN_REFNO%TYPE,
      i_licensee            IN     FID_LICENSEE.LEE_NUMBER%TYPE,
      i_catch_up_flag       IN     FID_LICENSE.LIC_CATCHUP_FLAG%TYPE,
      o_src_series_search      OUT SYS_REFCURSOR,
      o_dst_series_search      OUT SYS_REFCURSOR)
   AS
   BEGIN
      IF (NVL (i_catch_up_flag, 'N') = 'N') --(i_catch_up_flag = 'N' OR i_catch_up_flag IS NULL)/*Swapnil minimized condition*/
      THEN
         /*for Source*/
         OPEN o_src_series_search FOR
              SELECT B.LEE_NUMBER,
                     B.LEE_SHORT_NAME,
                     E.CHS_SHORT_NAME,
                     F.CON_NUMBER,
                     (SELECT com_short_name
                        FROM fid_company f1
                       WHERE f1.com_number = f.con_com_number)
                        com_short_name,
                     F.con_short_name,
                     D.GEN_EPI_NUMBER,
                     A.LIC_NUMBER,
                     D.GEN_TITLE,
                     LIC_PRICE,
                     X_FNC_GET_LIC_PAIDAMT (A.LIC_NUMBER, C.LSL_NUMBER)
                        PAID_AMT,
                     (SELECT SER_TITLE
                        FROM FID_SERIES
                       WHERE SER_NUMBER = D.GEN_SER_NUMBER)
                        SEASON_TITLE
                FROM FID_LICENSE A,
                     FID_LICENSEE B,
                     X_FIN_LIC_SEC_LEE C,
                     FID_CHANNEL_SERVICE E,
                     FID_CONTRACT F,
                     FID_GENERAL D
               WHERE     D.GEN_REFNO = A.LIC_GEN_REFNO
                     AND D.GEN_SER_NUMBER = (SELECT GEN_SER_NUMBER
                                               FROM FID_GENERAL
                                              WHERE GEN_REFNO = I_GEN_REFNO)
                     AND F.CON_NUMBER = i_con_number
                     AND B.LEE_NUMBER = i_licensee
                     AND a.lic_chs_number = e.chs_number
                     AND A.LIC_CON_NUMBER = F.CON_NUMBER
                     AND A.LIC_NUMBER = C.LSL_LIC_NUMBER
                     AND B.LEE_NUMBER = C.LSL_LEE_NUMBER
                     AND NVL (A.LIC_CATCHUP_FLAG, 'N') =
                            NVL (i_catch_up_flag, 'N')
                     AND B.LEE_SHORT_NAME NOT LIKE 'TVOD'
            ORDER BY D.GEN_EPI_NUMBER;

         /*for Destination*/
         OPEN o_dst_series_search FOR
            SELECT c.lee_number,
                   c.gen_ser_number,
                   c.lee_short_name,
                   c.chs_short_name,
                   0 lic_mem_number,                     --  c.lic_mem_number,
                   DECODE (ROWNUM, 1, 'true', 'false') first_row_flag,
                   c.lic_count
              FROM (  SELECT b.lee_number,
                             b.gen_ser_number,
                             b.lee_short_name,
                             b.chs_short_name,
                             --    b.lic_mem_number,
                             COUNT (b.lic_number) lic_count
                        FROM (SELECT a.* --, DECODE (ROWNUM, 1, 'true', 'false') first_row_flag
                                FROM (  SELECT DISTINCT b.lee_number,
                                                        d.gen_ser_number,
                                                        b.lee_short_name,
                                                        e.chs_short_name,
                                                        --   a.lic_mem_number,
                                                        a.lic_number
                                          -- ,DECODE (ROWNUM, 1, 'true', 'false') first_row_flag
                                          FROM FID_LICENSE A,
                                               FID_LICENSEE B,
                                               X_FIN_LIC_SEC_LEE C,
                                               FID_CHANNEL_SERVICE E,
                                               FID_CONTRACT F,
                                               FID_GENERAL D
                                         WHERE D.GEN_REFNO = A.LIC_GEN_REFNO
                                               AND D.GEN_SER_NUMBER =
                                                      (SELECT GEN_SER_NUMBER
                                                         FROM FID_GENERAL
                                                        WHERE GEN_REFNO =
                                                                 I_GEN_REFNO)
                                               AND F.CON_NUMBER = i_con_number
                                               AND B.LEE_NUMBER <> i_licensee
                                               AND a.lic_chs_number =
                                                      e.chs_number
                                               AND A.LIC_CON_NUMBER =
                                                      F.CON_NUMBER
                                               AND A.LIC_NUMBER =
                                                      C.LSL_LIC_NUMBER
                                               AND B.LEE_NUMBER =
                                                      C.LSL_LEE_NUMBER
                                               AND A.lic_price = 0
                                               AND NVL (A.LIC_CATCHUP_FLAG, 'N') =
                                                      NVL (i_catch_up_flag, 'N')
                                               AND 0 =
                                                      (SELECT NVL (
                                                                 SUM (pay_amount),
                                                                 0)
                                                         FROM fid_payment p
                                                        WHERE p.pay_lic_number =
                                                                 a.lic_number
                                                              AND p.pay_status =
                                                                     'P')
                                               AND B.LEE_SHORT_NAME NOT LIKE
                                                      'TVOD'
                                               AND c.lsl_is_primary = 'Y'
                                      ORDER BY LEE_SHORT_NAME) a) b
                    GROUP BY b.lee_number,
                             b.gen_ser_number,
                             b.lee_short_name,
                             b.chs_short_name                              --,
                                             --   b.lic_mem_number
                   ) c;
      ELSE
         /*for Source*/
         OPEN o_src_series_search FOR
              SELECT B.LEE_NUMBER,
                     B.LEE_SHORT_NAME,
                     NULL CHS_SHORT_NAME,
                     F.CON_NUMBER,
                     (SELECT com_short_name
                        FROM fid_company f1
                       WHERE f1.com_number = f.con_com_number)
                        com_short_name,
                     F.con_short_name,
                     D.GEN_EPI_NUMBER,
                     A.LIC_NUMBER,
                     D.GEN_TITLE,
                     LIC_PRICE,
                     X_FNC_GET_LIC_PAIDAMT (A.LIC_NUMBER, C.LSL_NUMBER)
                        PAID_AMT,
                     (SELECT SER_TITLE
                        FROM FID_SERIES
                       WHERE SER_NUMBER = D.GEN_SER_NUMBER)
                        SEASON_TITLE
                FROM FID_LICENSE A,
                     FID_LICENSEE B,
                     X_FIN_LIC_SEC_LEE C,
                     FID_CONTRACT F,
                     FID_GENERAL D
               WHERE     D.GEN_REFNO = A.LIC_GEN_REFNO
                     AND D.GEN_SER_NUMBER = (SELECT GEN_SER_NUMBER
                                               FROM FID_GENERAL
                                              WHERE GEN_REFNO = I_GEN_REFNO)
                     AND F.CON_NUMBER = i_con_number
                     AND B.LEE_NUMBER = i_licensee
                     AND A.LIC_CON_NUMBER = F.CON_NUMBER
                     AND A.LIC_NUMBER = C.LSL_LIC_NUMBER
                     AND B.LEE_NUMBER = C.LSL_LEE_NUMBER
                     AND NVL (A.LIC_CATCHUP_FLAG, 'N') =
                            NVL (i_catch_up_flag, 'N')
                     AND B.LEE_SHORT_NAME NOT LIKE 'TVOD'
            ORDER BY D.GEN_EPI_NUMBER;

         /*for Destination*/
         OPEN o_dst_series_search FOR
            SELECT c.lee_number,
                   c.gen_ser_number,
                   c.lee_short_name,
                   c.chs_short_name,
                   0 lic_mem_number,                  --     c.lic_mem_number,
                   DECODE (ROWNUM, 1, 'true', 'false') first_row_flag,
                   c.lic_count
              FROM (  SELECT b.lee_number,
                             b.gen_ser_number,
                             b.lee_short_name,
                             b.chs_short_name,
                             --    b.lic_mem_number,
                             COUNT (b.lic_number) lic_count
                        FROM (SELECT a.* --, DECODE (ROWNUM, 1, 'true', 'false') first_row_flag
                                FROM (  SELECT DISTINCT b.lee_number,
                                                        d.gen_ser_number,
                                                        b.lee_short_name,
                                                        NULL chs_short_name,
                                                        --        a.lic_mem_number,
                                                        a.lic_number
                                          -- ,DECODE (ROWNUM, 1, 'true', 'false') first_row_flag
                                          FROM FID_LICENSE A,
                                               FID_LICENSEE B,
                                               X_FIN_LIC_SEC_LEE C,
                                               FID_CONTRACT F,
                                               FID_GENERAL D
                                         WHERE D.GEN_REFNO = A.LIC_GEN_REFNO
                                               AND D.GEN_SER_NUMBER =
                                                      (SELECT GEN_SER_NUMBER
                                                         FROM FID_GENERAL
                                                        WHERE GEN_REFNO =
                                                                 I_GEN_REFNO)
                                               AND F.CON_NUMBER = i_con_number
                                               AND B.LEE_NUMBER <> i_licensee
                                               AND A.LIC_CON_NUMBER =
                                                      F.CON_NUMBER
                                               AND A.LIC_NUMBER =
                                                      C.LSL_LIC_NUMBER
                                               AND B.LEE_NUMBER =
                                                      C.LSL_LEE_NUMBER
                                               AND A.lic_price = 0
                                               AND NVL (A.LIC_CATCHUP_FLAG, 'N') =
                                                      NVL (i_catch_up_flag, 'N')
                                               AND 0 =
                                                      (SELECT NVL (
                                                                 SUM (pay_amount),
                                                                 0)
                                                         FROM fid_payment p
                                                        WHERE p.pay_lic_number =
                                                                 a.lic_number
                                                              AND p.pay_status =
                                                                     'P')
                                               AND B.LEE_SHORT_NAME NOT LIKE
                                                      'TVOD'
                                               AND c.lsl_is_primary = 'Y'
                                      ORDER BY LEE_SHORT_NAME) a) b
                    GROUP BY b.lee_number,
                             b.gen_ser_number,
                             b.lee_short_name,
                             b.chs_short_name                              --,
                                             --  b.lic_mem_number
                   ) c;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE_APPLICATION_ERROR (-20001, 'System Error');
   END X_prc_trf_pay_series_search;

   PROCEDURE x_prc_process_trf_payment (
      i_src_lic_no      IN     fid_license.lic_number%TYPE,
      i_src_licensee    IN     fid_licensee.lee_number%TYPE,
      i_dst_licensee    IN     fid_licensee.lee_number%TYPE,
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_con_no          IN     fid_contract.con_number%TYPE,
      i_entry_oper      IN     fid_payment.pay_entry_oper%TYPE,
      I_PAY_COMMENT     IN     FID_PAYMENT.PAY_COMMENT%TYPE,
      i_catch_up_flag   IN     FID_LICENSE.LIC_CATCHUP_FLAG%TYPE,
      o_success_flag       OUT NUMBER)
   IS
      /******************************************************************************************
      NAME:       Fnc_Xfer_licpri_process
      PURPOSE:    This function is used to process license price transfer from one series to another series
      *******************************************************************************************/
      v_ret_val                  NUMBER;
      v_dst_lic_no               fid_license.lic_number%TYPE;
      v_dst_lsl_no               fid_license.lic_number%TYPE;
      v_srs_ep_cnt               NUMBER := 0;
      v_dst_ep_cnt               NUMBER := 0;
      l_neg_paid_payments_cnt    NUMBER;
      l_sql_srring               VARCHAR (100);
      l_neg_paid_payments_list   CLOB;
      l_Last_Comma               NUMBER;
   BEGIN
      IF NVL (i_catch_up_flag, 'N') = 'N' --(i_catch_up_flag = 'N' OR i_catch_up_flag IS NULL)/*Swapnil minimized condition*/
      THEN
         FOR j
            IN (  SELECT A.LIC_NUMBER LIC_NUMBER
                    FROM FID_LICENSE A,
                         FID_LICENSEE B,
                         X_FIN_LIC_SEC_LEE C,
                         FID_CHANNEL_SERVICE E,
                         FID_CONTRACT F,
                         FID_GENERAL D
                   WHERE D.GEN_REFNO = A.LIC_GEN_REFNO
                         AND D.GEN_SER_NUMBER =
                                (SELECT GEN_SER_NUMBER
                                   FROM FID_GENERAL
                                  WHERE GEN_REFNO = i_gen_refno)
                         AND F.CON_NUMBER = i_con_no
                         AND B.LEE_NUMBER = i_src_licensee
                         AND a.lic_chs_number = e.chs_number
                         AND A.LIC_CON_NUMBER = F.CON_NUMBER
                         AND A.LIC_NUMBER = C.LSL_LIC_NUMBER
                         AND B.LEE_NUMBER = C.LSL_LEE_NUMBER
                         AND NVL (A.LIC_CATCHUP_FLAG, 'N') =
                                NVL (i_catch_up_flag, 'N')
                ORDER BY D.GEN_EPI_NUMBER)
         LOOP
            /*  IF x_fun_is_primary (j.lic_number) = 'Y'
              THEN
                 raise_application_error (
                    -20007,
                    'Cannot transfer license price as one or some of the licenses belonging to the season has a secondary licensee assigned to it ');
              END IF; */

            SELECT COUNT (1)
              INTO l_neg_paid_payments_cnt
              FROM fid_payment p
             WHERE     p.pay_lic_number = j.lic_number
                   AND p.pay_status = 'P'
                   AND p.pay_amount < 0;

            IF l_neg_paid_payments_cnt > 0
            THEN
               /* raise_application_error (
                   -20002,
                   'Negative paid payments exist for one of the source licenses');*/
               l_neg_paid_payments_list :=
                  l_neg_paid_payments_list || j.lic_number || ' , ';
            END IF;
         END LOOP;

         l_Last_Comma := NVL (INSTR (l_neg_paid_payments_list, ',', -1), 0);
         l_neg_paid_payments_list :=
            SUBSTR (l_neg_paid_payments_list, 1, l_Last_Comma - 1);

         IF l_neg_paid_payments_list IS NOT NULL
         THEN
            raise_application_error (
               -20002,
               'Negative paid payments exist for the source licenses '
               || l_neg_paid_payments_list);
         END IF;
      ELSE
         FOR j
            IN (  SELECT A.LIC_NUMBER LIC_NUMBER
                    FROM FID_LICENSE A,
                         FID_LICENSEE B,
                         X_FIN_LIC_SEC_LEE C,
                         FID_CONTRACT F,
                         FID_GENERAL D
                   WHERE D.GEN_REFNO = A.LIC_GEN_REFNO
                         AND D.GEN_SER_NUMBER =
                                (SELECT GEN_SER_NUMBER
                                   FROM FID_GENERAL
                                  WHERE GEN_REFNO = i_gen_refno)
                         AND F.CON_NUMBER = i_con_no
                         AND B.LEE_NUMBER = i_src_licensee
                         AND A.LIC_CON_NUMBER = F.CON_NUMBER
                         AND A.LIC_NUMBER = C.LSL_LIC_NUMBER
                         AND B.LEE_NUMBER = C.LSL_LEE_NUMBER
                         AND NVL (A.LIC_CATCHUP_FLAG, 'N') =
                                NVL (i_catch_up_flag, 'N')
                ORDER BY D.GEN_EPI_NUMBER)
         LOOP
            /* IF x_fun_is_primary (j.lic_number) = 'Y'
             THEN
                raise_application_error (
                   -20007,
                   'Cannot transfer license price as one or some of the licenses belonging to the season has a secondary licensee assigned to it ');
             END IF; */

            SELECT COUNT (1)
              INTO l_neg_paid_payments_cnt
              FROM fid_payment p
             WHERE     p.pay_lic_number = j.lic_number
                   AND p.pay_status = 'P'
                   AND p.pay_amount < 0;

            IF l_neg_paid_payments_cnt > 0
            THEN
               /* raise_application_error (
                  -20002,
                  'Negative paid payments exist for one of the source licenses');*/
               l_neg_paid_payments_list :=
                  l_neg_paid_payments_list || j.lic_number || ' , ';
            END IF;
         END LOOP;

         l_Last_Comma := NVL (INSTR (l_neg_paid_payments_list, ',', -1), 0);
         l_neg_paid_payments_list :=
            SUBSTR (l_neg_paid_payments_list, 1, l_Last_Comma - 1);

         IF l_neg_paid_payments_list IS NOT NULL
         THEN
            raise_application_error (
               -20002,
               'Negative paid payments exist for the source licenses '
               || l_neg_paid_payments_list);
         END IF;
      END IF;

      /*       for j in (
               SELECT lic_number, lic_price
                 FROM fid_license
                WHERE ( (i_contract_series = 'S'
                         AND lic_con_number = i_lic_con_number
                         AND lic_gen_refno IN
                                (SELECT gen_refno
                                   FROM fid_general
                                  WHERE gen_ser_number = i_gen_ser_number))
                       OR (i_contract_series = 'C'
                           AND lic_con_number = i_lic_con_number))
                      AND lic_chs_number = i_lic_chs_number
                      AND lic_lee_number = i_src_licensee
                      AND lic_status <> 'I' )
             loop

             if x_fun_is_primary(j.lic_number) = 'Y' then
                raise_application_error (
                  -20007,
                  'Cannot transfer license price as one or some of the licenses belonging to the season has a secondary licensee assigned to it ');
             end if;

             SELECT COUNT (1)
              INTO l_neg_paid_payments_cnt
              FROM fid_payment p
             WHERE     p.pay_lic_number = j.lic_number
                   AND p.pay_status = 'P'
                   AND p.pay_amount < 0;

             IF l_neg_paid_payments_cnt > 0
               THEN
                 raise_application_error (
                  -20002,
                  'Negative paid payments exist for one of the source licenses');
             END IF;

             end loop;*/

      SELECT COUNT (1)
        INTO v_srs_ep_cnt
        FROM fid_general F1, fid_license f2
       WHERE     f1.gen_refno = f2.lic_gen_refno
             AND f2.lic_con_number = i_con_no
             AND f1.gen_ser_number = (SELECT gen_ser_number
                                        FROM fid_general
                                       WHERE gen_refno = i_gen_refno)
             AND f2.lic_lee_number = i_src_licensee;

      SELECT COUNT (1)
        INTO v_dst_ep_cnt
        FROM fid_general F1, fid_license f2
       WHERE     f1.gen_refno = f2.lic_gen_refno
             AND f2.lic_con_number = i_con_no
             AND f1.gen_ser_number = (SELECT gen_ser_number
                                        FROM fid_general
                                       WHERE gen_refno = i_gen_refno)
             AND f2.lic_lee_number = i_dst_licensee;

      IF v_srs_ep_cnt <> v_dst_ep_cnt
      THEN
         RAISE_APPLICATION_ERROR (
            -20002,
            'Source no of Episodes does not match with Dest no of Episodes');
      END IF;

      l_sql_srring := 'truncate table X_GTT_FID_PAYMENT_TEMP';

      EXECUTE IMMEDIATE l_sql_srring;

      FOR I
         IN ( /*SELECT f1.gen_refno
                  ,f2.lic_number
                  ,f3.lsl_number
               FROM  fid_general f1
                     ,fid_license f2
                     ,fid_contract f4
                     ,x_fin_lic_sec_lee f3
              WHERE  f1.gen_refno=f2.lic_gen_refno
                AND  f3.lsl_lic_number=f2.lic_number
                        AND  f4.con_number= f2.lic_con_number
                AND  f1.gen_ser_number=(SELECT gen_ser_number from fid_general where gen_refno=i_gen_refno)
                        AND  f4.con_number = i_con_no
                        AND EXISTS ( SELECT 1
                                           FROM fid_licensee h
                             WHERE h.lee_number    = f3.lsl_lee_number
                             and lee_short_name     = i_src_licensee
                           )

  above cursor reduced as below */
             SELECT l.lic_gen_refno gen_refno,
                    l.lic_number lic_number,
                    s.lsl_number,
                    s.lsl_lee_price lsl_lee_price,
                    l.lic_showing_lic lic_showing_lic
               FROM fid_license l, x_fin_lic_sec_lee s, fid_general g
              WHERE     l.lic_number = s.lsl_lic_number
                    AND g.gen_refno = l.lic_gen_refno
                    AND g.gen_ser_number = (SELECT gen_ser_number
                                              FROM fid_general
                                             WHERE gen_refno = i_gen_refno)
                    AND l.lic_con_number = i_con_no
                    AND s.lsl_lee_number = i_src_licensee)
      LOOP
         SELECT f2.lic_number, f3.lsl_number
           INTO v_dst_lic_no, v_dst_lsl_no
           FROM fid_general f1,
                fid_license f2,
                fid_contract f4,
                x_fin_lic_sec_lee f3
          WHERE     f1.gen_refno = f2.lic_gen_refno
                AND f3.lsl_lic_number = f2.lic_number
                AND f4.con_number = f2.lic_con_number
                AND f1.gen_refno = i.gen_refno
                AND f4.con_number = i_con_no
                AND EXISTS
                       (SELECT 1
                          FROM fid_licensee h
                         WHERE h.lee_number = f3.lsl_lee_number
                               AND h.lee_number = i_dst_licensee);

         x_prc_alic_cm_transfer_payment (
            i_src_lic_no        => i.lic_number,               --i_src_lic_no,
            i_dst_lic_no        => v_dst_lic_no,
            i_pay_comment       => i_pay_comment,
            i_entry_date        => SYSDATE,
            I_ENTRY_OPER        => I_ENTRY_OPER,
            i_lsl_lee_price     => i.lsl_lee_price,
            i_lic_showing_lic   => i.lic_showing_lic,
            o_success_flag      => o_success_flag);
      END LOOP;
   END x_prc_process_trf_payment;

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
      --  l_sql_srring       VARCHAR (100);
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

         /*   UPDATE x_fin_lic_sec_lee
               SET lsl_lee_price = i_lsl_lee_price
             WHERE lsl_lic_number = i_dst_lic_no;

            COMMIT;

            UPDATE fid_license
               SET lic_showing_lic = i_lic_showing_lic,
                   lic_price =
                      (SELECT SUM (lsl_lee_price)
                         FROM x_fin_lic_sec_lee
                        WHERE lsl_lic_number = i_dst_lic_no)
             WHERE lic_number = i_dst_lic_no;  */

         /*  l_sql_srring := 'truncate table X_GTT_FID_PAYMENT_TEMP';

           EXECUTE IMMEDIATE l_sql_srring; */

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
                         PAY_MGP_NUMBER,
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

         INSERT INTO fid_payment (PAY_NUMBER,
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
                                  PAY_PAYMENT_PCT)
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
                   FPT_PAY_PAYMENT_PCT
              FROM X_GTT_FID_PAYMENT_TEMP
             WHERE FPT_OPER_FLAG = 'I';


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

      SELECT l.lic_start,
             l.lic_showing_lic,
             l.lic_currency,
             l.lic_end,
             l.lic_status
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
            'License Start Date of one of the destination license falls before Go-live date of 5+2 Costing rule implementation');
      END IF;

      IF l_src_lic_start_date < l_go_live_date
      THEN
         raise_application_error (
            -20001,
            'License Start Date of one of the source license falls before Go-live date of 5+2 Costing rule implementation');
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
                  'One of the source license has license start date before 5+2 go_live date. ');
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
                  'One of the destination license has license start date before 5+2 go_live date. ');
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

      IF l_paid_payment <> 0
      THEN
         raise_application_error (
            -20003,
            'Sum of paid payments does not equal 0 for one of the destination licenses');
      END IF;

      IF l_neg_paid_payments_cnt > 0
      THEN
         raise_application_error (
            -20002,
            'Negative paid payments exist for one of the licenses');
      END IF;

      IF l_dst_lic_runs_alloc < l_amort_exh_src
      THEN
         raise_application_error (
            -20004,
            'Amortization Exh of one of the source licenses exceeds the total runs of destination license. Please select another licensee');
      END IF;

      /*  IF l_is_primary_flag = 'Y'
        THEN
           raise_application_error (
              -20005,
              'Cannot transfer license price as one or some of the licenses belonging to the season has a secondary licensee assigned to it');
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

      IF ( (l_src_lic_end_date < l_current_month) OR (l_src_lic_status = 'I'))
      THEN
         raise_application_error (
            -20007,
            'Cannot transfer license price as one of the source license is Expired/Inactive');
      END IF;

      IF ( (l_dst_lic_end_date < l_current_month) OR (l_dst_lic_status = 'I'))
      THEN
         raise_application_error (
            -20007,
            'Cannot transfer license price as one of the destination license is Expired/Inactive');
      END IF;
   END x_prc_alic_cm_trf_validation;

   PROCEDURE x_prc_process_trf_pmnt_compl (
      i_src_lic_no      IN     fid_license.lic_number%TYPE,
      i_src_licensee    IN     fid_licensee.lee_number%TYPE,
      i_dst_licensee    IN     fid_licensee.lee_number%TYPE,
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_con_no          IN     fid_contract.con_number%TYPE,
      i_entry_oper      IN     fid_payment.pay_entry_oper%TYPE,
      I_PAY_COMMENT     IN     FID_PAYMENT.PAY_COMMENT%TYPE,
      i_catch_up_flag   IN     FID_LICENSE.LIC_CATCHUP_FLAG%TYPE,
      o_success_flag       OUT NUMBER)
   IS
      v_dst_lic_no   fid_license.lic_number%TYPE;
      l_amount       NUMBER := 0;
   BEGIN
      o_success_flag := -1;

      FOR z
         IN (SELECT l.lic_gen_refno gen_refno,
                    l.lic_number lic_number,
                    s.lsl_number,
                    s.lsl_lee_price lsl_lee_price,
                    l.lic_showing_lic lic_showing_lic
               FROM fid_license l, x_fin_lic_sec_lee s, fid_general g
              WHERE     l.lic_number = s.lsl_lic_number
                    AND g.gen_refno = l.lic_gen_refno
                    AND g.gen_ser_number = (SELECT gen_ser_number
                                              FROM fid_general
                                             WHERE gen_refno = i_gen_refno)
                    AND l.lic_con_number = i_con_no
                    AND s.lsl_lee_number = i_src_licensee
                    AND lic_status NOT IN ('T', 'I', 'C'))
      LOOP
         BEGIN
            SELECT f2.lic_number
              INTO v_dst_lic_no
              FROM fid_general f1,
                   fid_license f2,
                   fid_contract f4,
                   x_fin_lic_sec_lee f3
             WHERE     f1.gen_refno = f2.lic_gen_refno
                   AND f3.lsl_lic_number = f2.lic_number
                   AND f4.con_number = f2.lic_con_number
                   AND f1.gen_refno = z.gen_refno
                   AND f4.con_number = i_con_no
                   AND EXISTS
                          (SELECT 1
                             FROM fid_licensee h
                            WHERE h.lee_number = f3.lsl_lee_number
                                  AND h.lee_number = i_dst_licensee);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_dst_lic_no := 0;
         END;

         IF v_dst_lic_no <> 0
         THEN
            /* for i in ( select lsl_number,lsl_lee_price,lsl_lee_number
                          from x_fin_lic_sec_lee
                         where lsl_lic_number = z.lic_number
                           and lsl_is_primary = 'N')
             loop
                            UPDATE x_fin_lic_sec_lee
                               SET lsl_lee_price = i.lsl_lee_price
                             WHERE lsl_lic_number = v_dst_lic_no
                               and lsl_lee_number = i.lsl_lee_number ;
             end loop;

              for i in ( select lsl_number,lsl_lee_price,lsl_lee_number
                          from x_fin_lic_sec_lee
                         where lsl_lic_number = z.lic_number
                           and lsl_is_primary = 'Y')
             loop

                            UPDATE x_fin_lic_sec_lee
                               SET lsl_lee_price = i.lsl_lee_price
                             WHERE lsl_lic_number = v_dst_lic_no
                               and lsl_lee_number = ( select lsl_lee_number from x_fin_lic_sec_lee
                                                                          where lsl_lic_number = v_dst_lic_no
                                                                            and lsl_is_primary = 'Y') ;




             end loop; */

            FOR i IN (SELECT lsl_number
                        FROM x_fin_lic_sec_lee
                       WHERE lsl_lic_number = v_dst_lic_no)
            LOOP
               BEGIN
                  SELECT NVL (SUM (NVL (pay_amount, 0)), 0)
                    INTO l_amount
                    FROM fid_payment
                   WHERE pay_lsl_number = i.lsl_number
                         AND pay_lic_number = v_dst_lic_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_amount := -1;
               END;

               IF l_amount <> -1
               THEN
                  UPDATE x_fin_lic_sec_lee
                     SET lsl_lee_price = l_amount
                   WHERE lsl_number = i.lsl_number;
               END IF;
            END LOOP;

            COMMIT;

            UPDATE fid_license
               SET lic_showing_lic = z.lic_showing_lic,
                   lic_price =
                      (SELECT SUM (lsl_lee_price)
                         FROM x_fin_lic_sec_lee
                        WHERE lsl_lic_number = v_dst_lic_no)
             WHERE lic_number = v_dst_lic_no;

            COMMIT;
            o_success_flag := 1;
         END IF;

         FOR i IN (SELECT lsl_number
                     FROM x_fin_lic_sec_lee
                    WHERE lsl_lic_number = z.lic_number)
         LOOP
            BEGIN
               SELECT NVL (SUM (NVL (pay_amount, 0)), 0)
                 INTO l_amount
                 FROM fid_payment
                WHERE pay_lsl_number = i.lsl_number
                      AND pay_lic_number = z.lic_number;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_amount := -1;
            END;

            IF l_amount <> -1
            THEN
               UPDATE x_fin_lic_sec_lee
                  SET lsl_lee_price = l_amount
                WHERE lsl_number = i.lsl_number;
            END IF;

            COMMIT;

            UPDATE fid_license
               SET lic_price =
                      (SELECT SUM (lsl_lee_price)
                         FROM x_fin_lic_sec_lee
                        WHERE lsl_lic_number = z.lic_number)
             WHERE lic_number = z.lic_number;
         END LOOP;

         COMMIT;
      END LOOP;
   END x_prc_process_trf_pmnt_compl;

   --CATCHUP:CACQ14: Start_[SHANTANU A.]_14-nov-2014
   --Following procedure will copy the med device rights to the other licenses of same contract no/program type.
   PROCEDURE x_prc_cp_cpymedrght_mgclic_cpr (
      i_src_lic_number       IN     fid_license.lic_number%TYPE,
      i_MPDC_DEV_PLATM_ID    IN     x_cp_lic_medplatmdevcompat_map.lic_mpdc_dev_platm_id%TYPE,
      i_rights_on_device     IN     VARCHAR2,
      i_med_comp_rights      IN     VARCHAR2,
      i_med_IS_COMP_RIGHTS   IN     VARCHAR2,
      i_contract_series      IN     VARCHAR2,
      i_entry_oper           IN     VARCHAR2,
      o_status                  OUT NUMBER)
   AS
      l_con_number                NUMBER;
      l_lic_count                 NUMBER;
      l_fea_ser                   VARCHAR2 (5);
      l_lic_number                VARCHAR2 (5000);
      l_sch_count                 NUMBER;
      l_count                     NUMBER;
      l_plt_dev_id                NUMBER;
      l_plt_sch_start_date        DATE;

      --Ver 1.1 Start
      L_LIC_MPDC_COMP_RIGHTS_ID   X_CP_LIC_MEDPLATMDEVCOMPAT_MAP.LIC_MPDC_COMP_RIGHTS_ID%TYPE;
      L_LIC_IS_COMP_RIGHTS        X_CP_LIC_MEDPLATMDEVCOMPAT_MAP.LIC_IS_COMP_RIGHTS%TYPE;
      L_RIGHTS_ON_DEVICE          NUMBER := 0;

      --Ver 1.1 End
      CURSOR catchup_lic_ser
      IS
         SELECT lic_number,
                lic_catchup_flag,
                --ver 1.1 start
                DECODE (X_FNC_GET_PROG_TYPE (LIC_BUDGET_CODE),
                        'Y', 'SER',
                        'N', 'FEA',
                        NULL)
                   AS PROG_TYPE,
                CON_NUMBER
           --ver 1.1 End
           FROM fid_license, fid_contract, fid_general
          WHERE ( (i_contract_series = 'S'
                   AND gen_ser_number =
                          (SELECT gen_ser_number
                             FROM fid_general
                            WHERE gen_refno =
                                     (SELECT lic_gen_refno
                                        FROM fid_license
                                       WHERE lic_number = i_src_lic_number))
                   AND X_FNC_GET_PROG_TYPE (lic_budget_code) = 'Y')
                 OR (i_contract_series = 'C'
                     AND lic_con_number =
                            (SELECT lic_con_number
                               FROM fid_license
                              WHERE lic_number = i_src_lic_number))
                    AND X_FNC_GET_PROG_TYPE (lic_budget_code) = 'Y')
                AND LIC_CON_NUMBER = con_number
                AND lic_gen_refno = gen_refno
                AND NVL (lic_catchup_flag, 'N') =
                       (SELECT NVL (lic_catchup_flag, 'N')
                          FROM fid_license
                         WHERE lic_number = i_src_lic_number)
                AND lic_status NOT IN ('I', 'T') /*Swapnil to check Inactive license*/
                --Ver 1.1 Start[17-Jul-2015][Jawahar.Garg]Added licensee filter to update the rights for other licenses having same licensee of being modified license
                AND LIC_LEE_NUMBER = (SELECT LIC_LEE_NUMBER
                                        FROM FID_LICENSE
                                       WHERE LIC_NUMBER = I_SRC_LIC_NUMBER);



      CURSOR catchup_lic_fea
      IS
         SELECT lic_number,
                --ver 1.1 start
                DECODE (X_FNC_GET_PROG_TYPE (LIC_BUDGET_CODE),
                        'Y', 'SER',
                        'N', 'FEA',
                        NULL)
                   AS PROG_TYPE,
                CON_NUMBER                                       --ver 1.1 End
                          ,
                lic_catchup_flag
           FROM fid_license, fid_contract, fid_general
          WHERE ( (i_contract_series = 'S'
                   AND gen_ser_number =
                          (SELECT gen_ser_number
                             FROM fid_general
                            WHERE gen_refno =
                                     (SELECT lic_gen_refno
                                        FROM fid_license
                                       WHERE lic_number = i_src_lic_number)))
                 OR (i_contract_series = 'C'
                     AND lic_con_number =
                            (SELECT lic_con_number
                               FROM fid_license
                              WHERE lic_number = i_src_lic_number))
                    AND X_FNC_GET_PROG_TYPE (lic_budget_code) <> 'Y')
                AND lic_gen_refno = gen_refno
                AND lic_con_number = con_number
                AND NVL (lic_catchup_flag, 'N') =
                       (SELECT NVL (lic_catchup_flag, 'N')
                          FROM fid_license
                         WHERE lic_number = i_src_lic_number)
                AND lic_status NOT IN ('I', 'T') /*Swapnil to check Inactive licensec*/
                --Ver 1.1 Start[17-Jul-2015][Jawahar.Garg]Added licensee filter to update the rights for other licenses having same licensee of being modified license
                AND LIC_LEE_NUMBER = (SELECT LIC_LEE_NUMBER
                                        FROM FID_LICENSE
                                       WHERE LIC_NUMBER = I_SRC_LIC_NUMBER);
   BEGIN
      SELECT lic_con_number
        INTO l_con_number
        FROM fid_license
       WHERE lic_number = i_src_lic_number;


      SELECT lic_budget_code
        INTO l_fea_ser
        FROM fid_license
       WHERE lic_number = i_src_lic_number;


      IF X_FNC_GET_PROG_TYPE (l_fea_ser) = 'Y'
      THEN
         FOR cur_ser IN catchup_lic_ser
         LOOP
            -- DBMS_OUTPUT.PUT_LINE (cur_ser.lic_number);
            SELECT COUNT (*)
              INTO l_count
              FROM x_cp_play_list
             WHERE plt_lic_number = cur_ser.lic_number
                   AND plt_license_flag = cur_ser.lic_catchup_flag;

            IF l_count > 0
            THEN
               --DBMS_OUTPUT.PUT_LINE (1);
               FOR dev
                  IN (SELECT plt_dev_id,
                             plt_sch_start_date,
                             (SELECT s.ms_media_service_code /*Swapnil: 16-jun-2015 for SVOD*/
                                FROM sgy_pb_media_service s
                               WHERE s.ms_media_service_flag =
                                        NVL (plt_license_flag, 'Y'))
                                media_service_code
                        FROM x_cp_play_list
                       WHERE plt_lic_number = cur_ser.lic_number
                             AND plt_license_flag = cur_ser.lic_catchup_flag)
               LOOP
                  SELECT COUNT (1)
                    INTO l_sch_count
                    FROM x_cp_play_list
                   WHERE dev.plt_dev_id =
                            (SELECT MDP_MAP_DEV_ID
                               FROM x_cp_media_dev_platm_map
                              WHERE MDP_MAP_ID = i_MPDC_DEV_PLATM_ID)
                         AND TO_CHAR (
                                TO_DATE (dev.plt_sch_start_date, 'dd-mon-yy'),
                                'mm') IN
                                (SELECT FIM_MONTH
                                   FROM fid_financial_month
                                  WHERE FIM_STATUS IN ('B', 'O'))
                         AND TO_CHAR (
                                TO_DATE (dev.plt_sch_start_date, 'dd-mon-yy'),
                                'yyyy') IN
                                (SELECT FIM_YEAR
                                   FROM fid_financial_month
                                  WHERE FIM_STATUS IN ('B', 'O'))
                         AND plt_lic_number = cur_ser.lic_number;

                  IF l_sch_count = 0
                  THEN
                     SELECT COUNT (1)
                       INTO l_lic_count
                       FROM x_cp_lic_medplatmdevcompat_map
                      WHERE LIC_MPDC_LIC_NUMBER = cur_ser.lic_number
                            AND LIC_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID;

                     IF l_lic_count = 0
                     THEN
                        FOR i
                           IN (SELECT COLUMN_VALUE, ROWNUM r
                                 FROM TABLE (
                                         PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                            i_med_comp_rights,
                                            ',')))
                        LOOP
                           --DBMS_OUTPUT.PUT_LINE('insertion of : '||cur_ser.lic_number);



                           --ver 1.1 start
                           SELECT COLUMN_VALUE
                             INTO L_LIC_MPDC_COMP_RIGHTS_ID
                             FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                      FROM TABLE (
                                              PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                 i_med_comp_rights,
                                                 ','))) A)
                            WHERE r = i.r;

                           SELECT COLUMN_VALUE
                             INTO l_LIC_IS_COMP_RIGHTS
                             FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                      FROM TABLE (
                                              PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                 i_med_IS_COMP_RIGHTS,
                                                 ','))) A)
                            WHERE r = i.r;

                           IF I_CONTRACT_SERIES = 'C'
                              AND I_RIGHTS_ON_DEVICE = 'Y'
                           THEN
                              SELECT COUNT (1)
                                INTO L_RIGHTS_ON_DEVICE
                                FROM X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                               WHERE CON_CONTRACT_NUMBER = CUR_SER.CON_NUMBER
                                     AND CON_MPDC_DEV_PLATM_ID =
                                            I_MPDC_DEV_PLATM_ID
                                     AND CON_RIGHTS_ON_DEVICE =
                                            I_RIGHTS_ON_DEVICE
                                     AND CON_MPDC_COMP_RIGHTS_ID =
                                            L_LIC_MPDC_COMP_RIGHTS_ID
                                     AND CON_IS_FEA_SER = cur_ser.prog_type
                                     AND ( (L_LIC_IS_COMP_RIGHTS = 'Y'
                                            AND CON_IS_COMP_RIGHTS = 'Y')
                                          OR (L_LIC_IS_COMP_RIGHTS = 'N'));
                           ELSE
                              L_RIGHTS_ON_DEVICE := 1;
                           END IF;

                           IF L_RIGHTS_ON_DEVICE = 1
                           THEN
                              --ver 1.1 End

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
                                        LIC_MPDC_MODIFIED_BY,
                                        LIC_MPDC_MODIFIED_ON,
                                        LIC_MPDC_UPDATE_COUNT,
                                        LIC_MPDC_SERVICE_CODE)
                              VALUES (
                                        X_SEQ_LIC_MPDC_ID.NEXTVAL,
                                        cur_ser.lic_number,
                                        i_MPDC_DEV_PLATM_ID,
                                        I_RIGHTS_ON_DEVICE,
                                        --ver 1.1 start
                                        /*commented
                                        (SELECT COLUMN_VALUE
                                           FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                                    FROM TABLE (
                                                            PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                               i_med_comp_rights,
                                                               ','))) a)
                                          WHERE R = I.R)*/
                                        L_LIC_MPDC_COMP_RIGHTS_ID,
                                        /*
                                       (SELECT COLUMN_VALUE
                                          FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                                   FROM TABLE (
                                                           PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                              i_med_IS_COMP_RIGHTS,
                                                              ','))) a)
                                         WHERE r = i.r)*/
                                        L_LIC_IS_COMP_RIGHTS,
                                        --ver 1.1 End
                                        i_entry_oper,
                                        SYSDATE,
                                        NULL,
                                        NULL,
                                        0,
                                        (SELECT lee_media_service_code
                                           FROM fid_licensee
                                          WHERE lee_number IN
                                                   (SELECT lic_lee_number
                                                      FROM fid_license
                                                     WHERE lic_number =
                                                              i_src_lic_number)));
                           END IF;
                        END LOOP;
                     ELSE
                        FOR i
                           IN (SELECT COLUMN_VALUE, ROWNUM r
                                 FROM TABLE (
                                         PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                            i_med_comp_rights,
                                            ',')))
                        LOOP
                           --DBMS_OUTPUT.PUT_LINE('updation of : '||cur_ser.lic_number);

                           --ver 1.1 start
                           SELECT COLUMN_VALUE
                             INTO L_LIC_MPDC_COMP_RIGHTS_ID
                             FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                      FROM TABLE (
                                              PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                 i_med_comp_rights,
                                                 ','))) A)
                            WHERE r = i.r;

                           SELECT COLUMN_VALUE
                             INTO l_LIC_IS_COMP_RIGHTS
                             FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                      FROM TABLE (
                                              PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                 i_med_IS_COMP_RIGHTS,
                                                 ','))) A)
                            WHERE r = i.r;

                           IF I_CONTRACT_SERIES = 'C'
                              AND I_RIGHTS_ON_DEVICE = 'Y'
                           THEN
                              SELECT COUNT (1)
                                INTO L_RIGHTS_ON_DEVICE
                                FROM X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                               WHERE CON_CONTRACT_NUMBER = CUR_SER.CON_NUMBER
                                     AND CON_MPDC_DEV_PLATM_ID =
                                            I_MPDC_DEV_PLATM_ID
                                     AND CON_RIGHTS_ON_DEVICE =
                                            I_RIGHTS_ON_DEVICE
                                     AND CON_MPDC_COMP_RIGHTS_ID =
                                            L_LIC_MPDC_COMP_RIGHTS_ID
                                     AND CON_IS_FEA_SER = cur_ser.prog_type
                                     AND ( (L_LIC_IS_COMP_RIGHTS = 'Y'
                                            AND CON_IS_COMP_RIGHTS = 'Y')
                                          OR (L_LIC_IS_COMP_RIGHTS = 'N'));
                           ELSE
                              L_RIGHTS_ON_DEVICE := 1;
                           END IF;

                           IF L_RIGHTS_ON_DEVICE = 1
                           THEN
                              --ver 1.1 end

                              UPDATE x_cp_lic_medplatmdevcompat_map
                                 SET LIC_RIGHTS_ON_DEVICE = i_rights_on_device,
                                     LIC_IS_COMP_RIGHTS =      --ver 1.1 start
                                        l_LIC_IS_COMP_RIGHTS,
                                     /*  (SELECT COLUMN_VALUE
                                          FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                                   FROM TABLE (
                                                           PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                              i_med_IS_COMP_RIGHTS,
                                                              ','))) a)
                                         WHERE R = I.R)*/
                                     --ver 1.1 end
                                     LIC_MPDC_MODIFIED_BY = i_entry_oper,
                                     LIC_MPDC_MODIFIED_ON = SYSDATE,
                                     LIC_MPDC_UPDATE_COUNT =
                                        NVL (LIC_MPDC_UPDATE_COUNT, 0) + 1
                               WHERE LIC_MPDC_LIC_NUMBER = cur_ser.lic_number
                                     AND LIC_MPDC_DEV_PLATM_ID =
                                            I_MPDC_DEV_PLATM_ID
                                     AND LIC_MPDC_COMP_RIGHTS_ID =
                                            I.COLUMN_VALUE;
                           END IF;                             --ver 1.1 Added
                        END LOOP;
                     END IF;
                  ELSE
                     raise_application_error (
                        -20600,
                           /*Swapnil: 16-jun-2015 for SVOD*/
                           'Cannot uncheck the rights as one of the '
                        || dev.media_service_code
                        || ' licenses is on schedule');
                  --'One of the '||dev.media_service_code||' licenses of the season of the episode is scheduled on media device in open/budget month, so cant uncheck');
                  END IF;
               END LOOP;
            ELSE
               --DBMS_OUTPUT.PUT_LINE (0);
               SELECT COUNT (1)
                 INTO l_lic_count
                 FROM x_cp_lic_medplatmdevcompat_map
                WHERE LIC_MPDC_LIC_NUMBER = cur_ser.lic_number
                      AND LIC_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID;

               IF l_lic_count = 0
               THEN
                  FOR i
                     IN (SELECT COLUMN_VALUE, ROWNUM r
                           FROM TABLE (
                                   PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                      i_med_comp_rights,
                                      ',')))
                  LOOP
                     --DBMS_OUTPUT.PUT_LINE('insertion of : '||cur_ser.lic_number);

                     --ver 1.1 start
                     SELECT COLUMN_VALUE
                       INTO L_LIC_MPDC_COMP_RIGHTS_ID
                       FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                FROM TABLE (
                                        PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                           i_med_comp_rights,
                                           ','))) A)
                      WHERE r = i.r;

                     SELECT COLUMN_VALUE
                       INTO l_LIC_IS_COMP_RIGHTS
                       FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                FROM TABLE (
                                        PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                           i_med_IS_COMP_RIGHTS,
                                           ','))) A)
                      WHERE r = i.r;

                     IF I_CONTRACT_SERIES = 'C' AND I_RIGHTS_ON_DEVICE = 'Y'
                     THEN
                        SELECT COUNT (1)
                          INTO L_RIGHTS_ON_DEVICE
                          FROM X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                         WHERE CON_CONTRACT_NUMBER = CUR_SER.CON_NUMBER
                               AND CON_MPDC_DEV_PLATM_ID =
                                      I_MPDC_DEV_PLATM_ID
                               AND CON_RIGHTS_ON_DEVICE = I_RIGHTS_ON_DEVICE
                               AND CON_MPDC_COMP_RIGHTS_ID =
                                      L_LIC_MPDC_COMP_RIGHTS_ID
                               AND CON_IS_FEA_SER = cur_ser.prog_type
                               AND ( (L_LIC_IS_COMP_RIGHTS = 'Y'
                                      AND CON_IS_COMP_RIGHTS = 'Y')
                                    OR (L_LIC_IS_COMP_RIGHTS = 'N'));
                     ELSE
                        L_RIGHTS_ON_DEVICE := 1;
                     END IF;

                     IF L_RIGHTS_ON_DEVICE = 1
                     THEN
                        --ver 1.1 End

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
                                  LIC_MPDC_MODIFIED_BY,
                                  LIC_MPDC_MODIFIED_ON,
                                  LIC_MPDC_UPDATE_COUNT,
                                  LIC_MPDC_SERVICE_CODE)
                        VALUES (
                                  X_SEQ_LIC_MPDC_ID.NEXTVAL,
                                  cur_ser.lic_number,
                                  i_MPDC_DEV_PLATM_ID,
                                  I_RIGHTS_ON_DEVICE,
                                  --ver 1.1 start
                                  /*(SELECT COLUMN_VALUE
                                     FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                              FROM TABLE (
                                                      PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                         i_med_comp_rights,
                                                         ','))) a)
                                    WHERE r = i.r)*/
                                  L_LIC_MPDC_COMP_RIGHTS_ID,
                                  /*(SELECT COLUMN_VALUE
                                     FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                              FROM TABLE (
                                                      PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                         i_med_IS_COMP_RIGHTS,
                                                         ','))) a)
                                    WHERE R = I.R)*/
                                  l_LIC_IS_COMP_RIGHTS,
                                  i_entry_oper,
                                  SYSDATE,
                                  NULL,
                                  NULL,
                                  0,
                                  (SELECT lee_media_service_code
                                     FROM fid_licensee
                                    WHERE lee_number IN
                                             (SELECT lic_lee_number
                                                FROM fid_license
                                               WHERE lic_number =
                                                        I_SRC_LIC_NUMBER)));
                     END IF;
                  END LOOP;
               ELSE
                  --DBMS_OUTPUT.PUT_LINE ('update');
                  FOR i
                     IN (SELECT COLUMN_VALUE, ROWNUM r
                           FROM TABLE (
                                   PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                      i_med_comp_rights,
                                      ',')))
                  LOOP
                     --DBMS_OUTPUT.PUT_LINE('updation of : '||cur_ser.lic_number);
                     --ver 1.1 start
                     SELECT COLUMN_VALUE
                       INTO L_LIC_MPDC_COMP_RIGHTS_ID
                       FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                FROM TABLE (
                                        PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                           i_med_comp_rights,
                                           ','))) A)
                      WHERE r = i.r;

                     SELECT COLUMN_VALUE
                       INTO l_LIC_IS_COMP_RIGHTS
                       FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                FROM TABLE (
                                        PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                           i_med_IS_COMP_RIGHTS,
                                           ','))) A)
                      WHERE r = i.r;

                     IF I_CONTRACT_SERIES = 'C' AND I_RIGHTS_ON_DEVICE = 'Y'
                     THEN
                        SELECT COUNT (1)
                          INTO L_RIGHTS_ON_DEVICE
                          FROM X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                         WHERE CON_CONTRACT_NUMBER = CUR_SER.CON_NUMBER
                               AND CON_MPDC_DEV_PLATM_ID =
                                      I_MPDC_DEV_PLATM_ID
                               AND CON_RIGHTS_ON_DEVICE = I_RIGHTS_ON_DEVICE
                               AND CON_MPDC_COMP_RIGHTS_ID =
                                      L_LIC_MPDC_COMP_RIGHTS_ID
                               AND CON_IS_FEA_SER = cur_ser.prog_type
                               AND ( (L_LIC_IS_COMP_RIGHTS = 'Y'
                                      AND CON_IS_COMP_RIGHTS = 'Y')
                                    OR (L_LIC_IS_COMP_RIGHTS = 'N'));
                     ELSE
                        L_RIGHTS_ON_DEVICE := 1;
                     END IF;

                     IF L_RIGHTS_ON_DEVICE = 1
                     THEN
                        --ver 1.1 end
                        UPDATE x_cp_lic_medplatmdevcompat_map
                           SET LIC_RIGHTS_ON_DEVICE = i_rights_on_device,
                               LIC_IS_COMP_RIGHTS =            --ver 1.1 start
                                                   l_LIC_IS_COMP_RIGHTS,
                               /*
                               (SELECT COLUMN_VALUE
                                  FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                           FROM TABLE (
                                                   PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                      i_med_IS_COMP_RIGHTS,
                                                      ','))) a)
                                 WHERE r = i.r)*/
                               --ver 1.1 End,
                               LIC_MPDC_MODIFIED_BY = i_entry_oper,
                               LIC_MPDC_MODIFIED_ON = SYSDATE,
                               LIC_MPDC_UPDATE_COUNT =
                                  NVL (LIC_MPDC_UPDATE_COUNT, 0) + 1
                         WHERE LIC_MPDC_LIC_NUMBER = cur_ser.lic_number
                               AND LIC_MPDC_DEV_PLATM_ID =
                                      i_MPDC_DEV_PLATM_ID
                               AND LIC_MPDC_COMP_RIGHTS_ID = I.COLUMN_VALUE;
                     END IF;                                   --ver 1.1 added
                  END LOOP;
               END IF;
            END IF;
         END LOOP;
      ELSE
         FOR cur_fea IN catchup_lic_fea
         LOOP
            --DBMS_OUTPUT.pUT_LINE(cur_fea.lic_number);
            SELECT COUNT (*)
              INTO l_count
              FROM x_cp_play_list
             WHERE plt_lic_number = cur_fea.lic_number
                   AND plt_license_flag = cur_fea.lic_catchup_flag;

            IF l_count > 0
            THEN
               FOR j
                  IN (SELECT plt_dev_id,
                             plt_sch_start_date,
                             (SELECT s.ms_media_service_code /*Swapnil: 16-jun-2015 for SVOD*/
                                FROM sgy_pb_media_service s
                               WHERE s.ms_media_service_flag =
                                        NVL (plt_license_flag, 'Y'))
                                media_service_code
                        FROM x_cp_play_list
                       WHERE plt_lic_number = cur_fea.lic_number
                             AND plt_license_flag = cur_fea.lic_catchup_flag)
               LOOP
                  SELECT COUNT (1)
                    INTO l_sch_count
                    FROM x_cp_play_list
                   WHERE j.plt_dev_id =
                            (SELECT MDP_MAP_DEV_ID
                               FROM x_cp_media_dev_platm_map
                              WHERE MDP_MAP_ID = i_MPDC_DEV_PLATM_ID)
                         AND TO_CHAR (
                                TO_DATE (j.plt_sch_start_date, 'dd-mon-yy'),
                                'mm') IN
                                (SELECT FIM_MONTH
                                   FROM fid_financial_month
                                  WHERE FIM_STATUS IN ('B', 'O'))
                         AND TO_CHAR (
                                TO_DATE (j.plt_sch_start_date, 'dd-mon-yy'),
                                'yyyy') IN
                                (SELECT FIM_YEAR
                                   FROM fid_financial_month
                                  WHERE FIM_STATUS IN ('B', 'O'))
                         AND plt_lic_number = cur_fea.lic_number;

                  IF l_sch_count = 0
                  THEN
                     SELECT COUNT (1)
                       INTO l_lic_count
                       FROM x_cp_lic_medplatmdevcompat_map
                      WHERE LIC_MPDC_LIC_NUMBER = cur_fea.lic_number
                            AND LIC_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID;

                     IF l_lic_count = 0
                     THEN
                        FOR i
                           IN (SELECT COLUMN_VALUE, ROWNUM r
                                 FROM TABLE (
                                         PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                            i_med_comp_rights,
                                            ',')))
                        LOOP
                           --DBMS_OUTPUT.PUT_LINE (
                           --'insertion of : ' || cur_fea.lic_number);
                           --ver 1.1 start
                           SELECT COLUMN_VALUE
                             INTO L_LIC_MPDC_COMP_RIGHTS_ID
                             FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                      FROM TABLE (
                                              PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                 i_med_comp_rights,
                                                 ','))) A)
                            WHERE r = i.r;

                           SELECT COLUMN_VALUE
                             INTO l_LIC_IS_COMP_RIGHTS
                             FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                      FROM TABLE (
                                              PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                 i_med_IS_COMP_RIGHTS,
                                                 ','))) A)
                            WHERE r = i.r;

                           IF I_CONTRACT_SERIES = 'C'
                              AND I_RIGHTS_ON_DEVICE = 'Y'
                           THEN
                              SELECT COUNT (1)
                                INTO L_RIGHTS_ON_DEVICE
                                FROM X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                               WHERE CON_CONTRACT_NUMBER = cur_fea.CON_NUMBER
                                     AND CON_MPDC_DEV_PLATM_ID =
                                            I_MPDC_DEV_PLATM_ID
                                     AND CON_RIGHTS_ON_DEVICE =
                                            I_RIGHTS_ON_DEVICE
                                     AND CON_MPDC_COMP_RIGHTS_ID =
                                            L_LIC_MPDC_COMP_RIGHTS_ID
                                     AND CON_IS_FEA_SER = cur_fea.prog_type
                                     AND ( (L_LIC_IS_COMP_RIGHTS = 'Y'
                                            AND CON_IS_COMP_RIGHTS = 'Y')
                                          OR (L_LIC_IS_COMP_RIGHTS = 'N'));
                           ELSE
                              L_RIGHTS_ON_DEVICE := 1;
                           END IF;

                           IF L_RIGHTS_ON_DEVICE = 1
                           THEN
                              --ver 1.1 End

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
                                        LIC_MPDC_MODIFIED_BY,
                                        LIC_MPDC_MODIFIED_ON,
                                        LIC_MPDC_UPDATE_COUNT,
                                        LIC_MPDC_SERVICE_CODE)
                              VALUES (
                                        X_SEQ_LIC_MPDC_ID.NEXTVAL,
                                        cur_fea.lic_number,
                                        i_MPDC_DEV_PLATM_ID,
                                        I_RIGHTS_ON_DEVICE,
                                        --ver 1.1 start
                                        /*(SELECT COLUMN_VALUE
                                           FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                                    FROM TABLE (
                                                            PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                               i_med_comp_rights,
                                                               ','))) a)
                                          WHERE r = i.r)*/
                                        L_LIC_MPDC_COMP_RIGHTS_ID,
                                        /*(SELECT COLUMN_VALUE
                                           FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                                    FROM TABLE (
                                                            PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                               i_med_IS_COMP_RIGHTS,
                                                               ','))) a)
                                          WHERE R = I.R)*/
                                        l_LIC_IS_COMP_RIGHTS,
                                        --ver 1.1 end
                                        i_entry_oper,
                                        SYSDATE,
                                        NULL,
                                        NULL,
                                        0,
                                        (SELECT lee_media_service_code
                                           FROM fid_licensee
                                          WHERE lee_number IN
                                                   (SELECT lic_lee_number
                                                      FROM fid_license
                                                     WHERE lic_number =
                                                              I_SRC_LIC_NUMBER)));
                           END IF;
                        END LOOP;
                     ELSE
                        FOR i
                           IN (SELECT COLUMN_VALUE, ROWNUM r
                                 FROM TABLE (
                                         PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                            i_med_comp_rights,
                                            ',')))
                        LOOP
                           --DBMS_OUTPUT.PUT_LINE('updation of : '||cur_ser.lic_number);
                           --ver 1.1 start
                           SELECT COLUMN_VALUE
                             INTO L_LIC_MPDC_COMP_RIGHTS_ID
                             FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                      FROM TABLE (
                                              PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                 i_med_comp_rights,
                                                 ','))) A)
                            WHERE r = i.r;

                           SELECT COLUMN_VALUE
                             INTO l_LIC_IS_COMP_RIGHTS
                             FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                      FROM TABLE (
                                              PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                 i_med_IS_COMP_RIGHTS,
                                                 ','))) A)
                            WHERE r = i.r;

                           IF I_CONTRACT_SERIES = 'C'
                              AND I_RIGHTS_ON_DEVICE = 'Y'
                           THEN
                              SELECT COUNT (1)
                                INTO L_RIGHTS_ON_DEVICE
                                FROM X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                               WHERE CON_CONTRACT_NUMBER = cur_fea.CON_NUMBER
                                     AND CON_MPDC_DEV_PLATM_ID =
                                            I_MPDC_DEV_PLATM_ID
                                     AND CON_RIGHTS_ON_DEVICE =
                                            I_RIGHTS_ON_DEVICE
                                     AND CON_MPDC_COMP_RIGHTS_ID =
                                            L_LIC_MPDC_COMP_RIGHTS_ID
                                     AND CON_IS_FEA_SER = cur_fea.prog_type
                                     AND ( (L_LIC_IS_COMP_RIGHTS = 'Y'
                                            AND CON_IS_COMP_RIGHTS = 'Y')
                                          OR (L_LIC_IS_COMP_RIGHTS = 'N'));
                           ELSE
                              L_RIGHTS_ON_DEVICE := 1;
                           END IF;

                           IF L_RIGHTS_ON_DEVICE = 1
                           THEN
                              --ver 1.1 end
                              UPDATE x_cp_lic_medplatmdevcompat_map
                                 SET LIC_RIGHTS_ON_DEVICE = i_rights_on_device,
                                     LIC_IS_COMP_RIGHTS =      --ver 1.1 Start
                                        l_LIC_IS_COMP_RIGHTS,
                                     /*
                                     (SELECT COLUMN_VALUE
                                        FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                                 FROM TABLE (
                                                         PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                            i_med_IS_COMP_RIGHTS,
                                                            ','))) a)
                                       WHERE r = i.r)*/
                                     --ver 1.1 end
                                     LIC_MPDC_MODIFIED_BY = i_entry_oper,
                                     LIC_MPDC_MODIFIED_ON = SYSDATE,
                                     LIC_MPDC_UPDATE_COUNT =
                                        NVL (LIC_MPDC_UPDATE_COUNT, 0) + 1
                               WHERE LIC_MPDC_LIC_NUMBER = cur_fea.lic_number
                                     AND LIC_MPDC_DEV_PLATM_ID =
                                            i_MPDC_DEV_PLATM_ID
                                     AND LIC_MPDC_COMP_RIGHTS_ID =
                                            I.COLUMN_VALUE;
                           END IF;                             --ver 1.1 added
                        END LOOP;
                     END IF;
                  ELSE
                     raise_application_error (
                        -20987,
                           /*Swapnil: 16-jun-2015 for SVOD*/
                           'Cannot uncheck the rights as one of the '
                        || j.media_service_code
                        || ' licenses is on schedule');
                  --'One of the '||j.media_service_code||' license of contract is scheduled on media device in open/budgeted month,so cant uncheck');
                  END IF;
               END LOOP;
            ELSE
               SELECT COUNT (1)
                 INTO l_lic_count
                 FROM x_cp_lic_medplatmdevcompat_map
                WHERE LIC_MPDC_LIC_NUMBER = cur_fea.lic_number
                      AND LIC_MPDC_DEV_PLATM_ID = i_MPDC_DEV_PLATM_ID;

               IF l_lic_count = 0
               THEN
                  FOR i
                     IN (SELECT COLUMN_VALUE, ROWNUM r
                           FROM TABLE (
                                   PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                      i_med_comp_rights,
                                      ',')))
                  LOOP
                     --DBMS_OUTPUT.PUT_LINE (
                     --'insertion of : ' || cur_fea.lic_number);

                     --ver 1.1 start
                     SELECT COLUMN_VALUE
                       INTO L_LIC_MPDC_COMP_RIGHTS_ID
                       FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                FROM TABLE (
                                        PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                           i_med_comp_rights,
                                           ','))) A)
                      WHERE r = i.r;

                     SELECT COLUMN_VALUE
                       INTO l_LIC_IS_COMP_RIGHTS
                       FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                FROM TABLE (
                                        PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                           i_med_IS_COMP_RIGHTS,
                                           ','))) A)
                      WHERE r = i.r;

                     IF I_CONTRACT_SERIES = 'C' AND I_RIGHTS_ON_DEVICE = 'Y'
                     THEN
                        SELECT COUNT (1)
                          INTO L_RIGHTS_ON_DEVICE
                          FROM X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                         WHERE CON_CONTRACT_NUMBER = cur_fea.CON_NUMBER
                               AND CON_MPDC_DEV_PLATM_ID =
                                      I_MPDC_DEV_PLATM_ID
                               AND CON_RIGHTS_ON_DEVICE = I_RIGHTS_ON_DEVICE
                               AND CON_MPDC_COMP_RIGHTS_ID =
                                      L_LIC_MPDC_COMP_RIGHTS_ID
                               AND CON_IS_FEA_SER = cur_fea.prog_type
                               AND ( (L_LIC_IS_COMP_RIGHTS = 'Y'
                                      AND CON_IS_COMP_RIGHTS = 'Y')
                                    OR (L_LIC_IS_COMP_RIGHTS = 'N'));
                     ELSE
                        L_RIGHTS_ON_DEVICE := 1;
                     END IF;

                     IF L_RIGHTS_ON_DEVICE = 1
                     THEN
                        --ver 1.1 End
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
                                  LIC_MPDC_MODIFIED_BY,
                                  LIC_MPDC_MODIFIED_ON,
                                  LIC_MPDC_UPDATE_COUNT,
                                  LIC_MPDC_SERVICE_CODE)
                        VALUES (
                                  X_SEQ_LIC_MPDC_ID.NEXTVAL,
                                  cur_fea.lic_number,
                                  i_MPDC_DEV_PLATM_ID,
                                  I_RIGHTS_ON_DEVICE,
                                  --ver 1.1 start
                                  /*(SELECT COLUMN_VALUE
                                     FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                              FROM TABLE (
                                                      PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                         i_med_comp_rights,
                                                         ','))) a)
                                  WHERE r = i.r)*/
                                  L_LIC_MPDC_COMP_RIGHTS_ID,
                                  /*(SELECT COLUMN_VALUE
                                     FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                              FROM TABLE (
                                                      PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                         i_med_IS_COMP_RIGHTS,
                                                         ','))) a)
                                    WHERE R = I.R)*/
                                  l_LIC_IS_COMP_RIGHTS,
                                  --ver 1.1 End
                                  i_entry_oper,
                                  SYSDATE,
                                  NULL,
                                  NULL,
                                  0,
                                  (SELECT lee_media_service_code
                                     FROM fid_licensee
                                    WHERE lee_number IN
                                             (SELECT lic_lee_number
                                                FROM fid_license
                                               WHERE lic_number =
                                                        I_SRC_LIC_NUMBER)));
                     END IF;                                   --ver 1.1 added
                  END LOOP;
               ELSE
                  FOR i
                     IN (SELECT COLUMN_VALUE, ROWNUM r
                           FROM TABLE (
                                   PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                      i_med_comp_rights,
                                      ',')))
                  LOOP
                     --DBMS_OUTPUT.PUT_LINE('updation of : '||cur_ser.lic_number);
                     --ver 1.1 start
                     SELECT COLUMN_VALUE
                       INTO L_LIC_MPDC_COMP_RIGHTS_ID
                       FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                FROM TABLE (
                                        PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                           i_med_comp_rights,
                                           ','))) A)
                      WHERE r = i.r;

                     SELECT COLUMN_VALUE
                       INTO l_LIC_IS_COMP_RIGHTS
                       FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                FROM TABLE (
                                        PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                           i_med_IS_COMP_RIGHTS,
                                           ','))) A)
                      WHERE r = i.r;

                     IF I_CONTRACT_SERIES = 'C' AND I_RIGHTS_ON_DEVICE = 'Y'
                     THEN
                        SELECT COUNT (1)
                          INTO L_RIGHTS_ON_DEVICE
                          FROM X_CP_CON_MEDPLATMDEVCOMPAT_MAP
                         WHERE CON_CONTRACT_NUMBER = CUR_FEA.CON_NUMBER
                               AND CON_MPDC_DEV_PLATM_ID =
                                      I_MPDC_DEV_PLATM_ID
                               AND CON_RIGHTS_ON_DEVICE = I_RIGHTS_ON_DEVICE
                               AND CON_MPDC_COMP_RIGHTS_ID =
                                      L_LIC_MPDC_COMP_RIGHTS_ID
                               AND CON_IS_FEA_SER = cur_fea.prog_type
                               AND ( (L_LIC_IS_COMP_RIGHTS = 'Y'
                                      AND CON_IS_COMP_RIGHTS = 'Y')
                                    OR (L_LIC_IS_COMP_RIGHTS = 'N'));
                     ELSE
                        L_RIGHTS_ON_DEVICE := 1;
                     END IF;

                     IF L_RIGHTS_ON_DEVICE = 1
                     THEN
                        --ver 1.1 end
                        UPDATE x_cp_lic_medplatmdevcompat_map
                           SET LIC_RIGHTS_ON_DEVICE = I_RIGHTS_ON_DEVICE,
                               LIC_IS_COMP_RIGHTS =            --ver 1.1 start
                                                   l_LIC_IS_COMP_RIGHTS,
                               /*
                                 (SELECT COLUMN_VALUE
                                    FROM ((SELECT COLUMN_VALUE, ROWNUM r
                                             FROM TABLE (
                                                     PKG_PB_MEDIA_PLAT_SER.split_to_char (
                                                        i_med_IS_COMP_RIGHTS,
                                                        ','))) a)
                                   WHERE r = i.r)
                               */
                               --ver 1.1 end
                               LIC_MPDC_MODIFIED_BY = i_entry_oper,
                               LIC_MPDC_MODIFIED_ON = SYSDATE,
                               LIC_MPDC_UPDATE_COUNT =
                                  NVL (LIC_MPDC_UPDATE_COUNT, 0) + 1
                         WHERE LIC_MPDC_LIC_NUMBER = cur_fea.lic_number
                               AND LIC_MPDC_DEV_PLATM_ID =
                                      I_MPDC_DEV_PLATM_ID
                               AND LIC_MPDC_COMP_RIGHTS_ID = I.COLUMN_VALUE;
                     END IF;                                   --ver 1.1 added
                  END LOOP;
               END IF;
            END IF;
         END LOOP;
      END IF;

      IF SQL%ROWCOUNT = 0
      THEN
         --ROLLBACK;
         o_status := 0;
      ELSE
         COMMIT;
         o_status := 1;
      END IF;
   END;
--CATCHUP_[END]
/*Dev.R1: Finace DEV Phase 1 :[BR_1609_707_Pre-payment In and Out Report]_[Ankur Kasar]_[2016/11/05]: Start*/
/*This Function Check if contract have cancled license then it return N else Return Y*/
 PROCEDURE X_PRC_CHECK_LIC_IS_CANCLE (
      I_CONTRACT_SERIES IN VARCHAR2,
      I_CON_NUMBER      IN NUMBER,
      I_LEE_NUMBER      IN NUMBER,
      I_GEN_REFNO       IN NUMBER,
      O_STATUS          OUT VARCHAR2
   )
   AS
    L_LIC_IS_CANCLE  VARCHAR2(56);
   BEGIN
    SELECT DECODE( COUNT(1),0,'N','Y') INTO L_LIC_IS_CANCLE
      FROM fid_license
     WHERE ( (i_contract_series = 'S'
             AND lic_con_number = I_CON_NUMBER
             AND lic_gen_refno IN
                    (SELECT gen_refno
                       FROM fid_general
                      WHERE gen_ser_number = ( SELECT gen_ser_number              
                                                 FROM fid_general
                                                WHERE gen_refno = I_GEN_REFNO)))
           OR (i_contract_series = 'C'
               AND lic_con_number = I_CON_NUMBER))
          AND lic_lee_number = I_LEE_NUMBER
          AND lic_status = 'C';
  
         O_STATUS := L_LIC_IS_CANCLE;       
         
END X_PRC_CHECK_LIC_IS_CANCLE;
/*Dev.R1: Finace DEV Phase 1 :[BR_1609_707_Pre-payment In and Out Report]_[Ankur Kasar]_[2016/11/05]: End*/
END PKG_ALIC_MN_MAGIC_LIC_COPIER;
/
