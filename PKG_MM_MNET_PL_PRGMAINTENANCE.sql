CREATE OR REPLACE PACKAGE         PKG_MM_MNET_PL_PRGMAINTENANCE
AS
   /**************************************************************************
   REM Module  : Media Management- PROGRAM LIBRARY
   REM Client  : MNET
   REM File Name  : PKG_MM_MNET_PL_PRGMAINTENANCE
   REM Purpose : Program Maintainance
   REM Written By : Neeraj
   REM Updated By    : Vinayak
   REM Date : 29-01-2010
   REM Type : Database Package
   REM Change History  : Created
   REM **************************************************************************/
   TYPE c_cursor_prg IS REF CURSOR;

   TYPE c_cursor_tapeformat IS REF CURSOR;

   TYPE synopsis_dtls IS TABLE OF number INDEX BY PLS_INTEGER;
   TYPE synopsis_dtls_text IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;

   --THE PROCEDURE INSERT PROGRAM INSERTS THE PROGRAM (HEADER) FOR MNET
   PROCEDURE pck_mm_mnet_pl_insertprogram (
      -- I_GEN_DURATION  IN FID_GENERAL.GEN_DURATION%TYPE,
      i_gen_title                      IN     fid_general.gen_title%TYPE,
      i_gen_title_working              IN     fid_general.gen_title_working%TYPE,
      -- Add by
      /*
      DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
      Parameters

            i_gen_sub_title           IN       fid_general.gen_sub_title%TYPE,
            i_gen_music_title         IN       fid_general.gen_music_title%TYPE,
            i_gen_poem_title          IN       fid_general.gen_poem_title%TYPE,
            i_gen_web_title           IN       fid_general.GEN_WEB_TITLE%TYPE,
            i_gen_stu_code            IN       fid_general.gen_stu_code%TYPE,
            i_gen_colour              IN       fid_general.gen_colour%TYPE,
            i_gen_code                IN       fid_general.gen_code%TYPE,
            5 check boxes
            i_gen_widescreen          IN       fid_general.gen_widescreen%TYPE,
            i_gen_cat_complete        IN       fid_general.gen_cat_complete%TYPE,
            i_gen_nfa_copy            IN       fid_general.gen_nfa_copy%TYPE,
            i_gen_tx_digitized        IN       fid_general.gen_tx_digitized%TYPE,
            i_gen_archive             IN       fid_general.gen_archive%TYPE,
            Live tab
            i_fgl_venue               IN       fid_gen_live.fgl_venue%TYPE,
            i_fgl_location            IN       fid_gen_live.fgl_location%TYPE,
            i_fgl_live_date           IN       fid_gen_live.fgl_live_date%TYPE,
            In Add info Tab
            i_gen_copy_restrictions   IN       fid_general.gen_copy_restrictions%TYPE,
            i_gen_abstract            IN       fid_general.gen_abstract%TYPE,
            DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
            */
      i_gen_category                   IN     fid_general.gen_category%TYPE,
      i_gen_rating_mpaa                IN     fid_general.gen_rating_mpaa%TYPE,
      i_gen_subgenre                   IN     fid_general.gen_subgenre%TYPE,
      i_gen_rating_int                 IN     fid_general.gen_rating_int%TYPE,
      i_gen_quality                    IN     fid_general.gen_quality%TYPE,
      i_gen_series                     IN     fid_general.gen_series%TYPE,
      i_gen_spoken_lang                IN     fid_general.gen_sub_title%TYPE,
      i_gen_type                       IN     fid_general.gen_type%TYPE,
      i_gen_release_year               IN     fid_general.gen_release_year%TYPE,
      i_gen_nationality                IN     fid_general.gen_nationality%TYPE,
      i_gen_duration_c                 IN     fid_general.gen_duration_c%TYPE,
      i_gen_duration_s                 IN     fid_general.gen_duration_s%TYPE,
      --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
      I_GEN_DURATION_PGA               IN     fid_general.GEN_PGA_DURATION%TYPE,
      --DEV.R4:Inventory Mining:End
      i_gen_epi_number                 IN     fid_general.gen_epi_number%TYPE,
      i_gen_award                      IN     fid_general.gen_award%TYPE,
      i_gen_target_group               IN     fid_general.gen_target_group%TYPE,
      -- Prod.Support : SVOD : Start : [Devashish Raverkar]_[2015-03-20]
      i_gen_sec_target_group           IN     fid_general.gen_sec_target_group%TYPE,
      -- Prod.Support : SVOD : End
      --Catch and PB CR[SCH 32][Mangesh Gulhane][13-AUG-13][Added column for AFR writeoff]
      i_gen_is_afr_writeoff            IN     fid_general.gen_is_afr_writeoff%TYPE,
      i_gen_is_day_time_rest           IN     fid_general.gen_is_day_time_rest%TYPE,
      --Catch and PB CR END
      i_flag_metadata_verified         IN     fid_general.gen_metadata_verified%TYPE,
      -- #region Abhinay_230512014 : New Field Metadata Verified
      i_gen_comment                    IN     fid_general.gen_comment%TYPE,
      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :i_supp_short_name removed for -Restricting creation of duplicate Titles on Programme Maintenance */
      i_gen_re_tx_warning              IN     fid_general.gen_re_tx_warning%TYPE,
      --kunal : START 02-03-2015 Production Number
      i_gen_production_number          IN     fid_general.gen_production_number%TYPE,
      --kunal : END Production Number
         ---  START: EPG Phase 1 : [11-06-2016] : [SUSHMA K]
     --commented below input parameters
     /* i_syn_syt_id_local               IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_syt_id_full                IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsis_full              IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsis_local             IN     fid_synopsis.syn_synopsis%TYPE,
      --**************TVOD-Added********************************
      i_syn_synopsisid_web             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_web        IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsisid_mob             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_mob        IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsisid_epg             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_epg        IN     fid_synopsis.syn_synopsis%TYPE,
      --**************TVOD-END***********************************
      --Added by Pravin_20130111 - Supplier synopsis
      i_syn_synopsisid_supplier        IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_supplier   IN     fid_synopsis.syn_synopsis%TYPE,*/
      --Pravin -End
      --END LEPG Pahse 1
      i_tap_title                      IN     fid_tape.tap_title%TYPE,
      i_tap_type                       IN     fid_tape.tap_type%TYPE,
      i_tap_format                     IN     fid_tape.tap_format%TYPE,
      i_tap_barcode                    IN     fid_tape.tap_barcode%TYPE,
      i_entry_oper                     IN     fid_general.gen_entry_oper%TYPE,
      --**************Bioscope-Added********************************
      i_imdb_rating                    IN     NUMBER,
      i_ar_rating                      IN     VARCHAR2,
      i_expert_rating                  IN     VARCHAR2,
      i_bo_category                    IN     VARCHAR2,
      i_usd_revenue                    IN     NUMBER,
      i_zar_revenue                    IN     NUMBER,
      i_final_grade                    IN     VARCHAR2,
      i_gen_prog_category_code         IN     VARCHAR2,
      i_gen_catchup_category           IN     VARCHAR2, -- Added by Rashmi for catchu Cr
      i_gen_catchup_priority           IN     VARCHAR2, --Added By rashmi for catchup Cr
      i_gen_tertiary_genre             IN     VARCHAR2,
      i_web_title                      IN     fid_general.gen_web_title%TYPE,
      --**************Bioscop-END***********************************
      ----Added for web title ------------------------------------------
      --START: PROJECT BIOSCOPE ? PENDING CR?S: 20121003
      -- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
      i_gen_mood                       IN     fid_general.gen_mood%TYPE,
      i_gen_link_poster_art            IN     fid_general.gen_link_poster_art%TYPE,
      -- Add by
      --DEV4: Programme Acceptance (Release 12) : Start :  : <17-06-2013> : <Refer PGA01 document>
      i_gen_tags                       IN     fid_general.gen_tags%TYPE,
      i_gen_africa_type_duration_c     IN     fid_general.gen_africa_type_duration_c%TYPE,
      i_gen_africa_type_duration_s     IN     fid_general.gen_africa_type_duration_s%TYPE -- i_GEN_AFRICA_TYPE_DURATION    IN  fid_general.GEN_AFRICA_TYPE_DURATION%TYPE,
                                                                                         ,
      i_report_name                    IN     x_movie_content_report.mcr_report_name%TYPE,
      i_copy                           IN     x_movie_content_report.mcr_copy%TYPE,
      i_pfb_rating                     IN     x_movie_content_report.mcr_fpb_rating%TYPE,
      i_themes                         IN     x_movie_content_report.mcr_themes%TYPE,
      i_bad_language                   IN     x_movie_content_report.mcr_bad_language%TYPE,
      i_violence                       IN     x_movie_content_report.mcr_violence%TYPE,
      i_horror                         IN     x_movie_content_report.mcr_horror_suspence%TYPE,
      i_sex                            IN     x_movie_content_report.mcr_sex%TYPE,
      i_drugs                          IN     x_movie_content_report.mcr_drugs%TYPE,
      i_prejudice                      IN     x_movie_content_report.mcr_prejudice%TYPE,
      i_correctives                    IN     x_movie_content_report.mcr_correctives%TYPE,
      i_any_special_warnings           IN     x_movie_content_report.mcr_any_special_warnings%TYPE,
      i_summary_reasons                IN     x_movie_content_report.mcr_reasons_for_recoomended%TYPE,
      i_validation                     IN     VARCHAR2,
      i_nudity                         IN     x_movie_content_report.mcr_nudity%TYPE,
      i_mcr_location                   IN     x_movie_content_report.mcr_location%TYPE,
      i_mcr_afrc_reg_rating            IN     x_movie_content_report.mcr_afrc_reg_rating%TYPE,
      i_mcr_date_received              IN     x_movie_content_report.mcr_date_received%TYPE,
      i_mcr_date_viewed                IN     x_movie_content_report.mcr_date_viewed%TYPE,
      i_buyer_feedback                 IN     x_movie_content_report.mcr_buyer_feedback%TYPE,
      i_mcr_synopsis                   IN     x_movie_content_report.mcr_synopsis%TYPE,
      i_watershed_restriction          IN     x_movie_content_report.mcr_watershed_restriction%TYPE,
      i_sub_title_language             IN     x_movie_content_report.mcr_sub_title_language%TYPE,
      i_mcr_programe_type              IN     x_movie_content_report.mcr_programe_type%TYPE,
      i_mcr_year_of_production         IN     x_movie_content_report.mcr_year_of_production%TYPE,
      i_mcr_language                   IN     x_movie_content_report.mcr_programe_type%TYPE,
      i_mcr_distributor                IN     x_movie_content_report.mcr_language%TYPE,
      i_mcr_primary_genre              IN     x_movie_content_report.mcr_primary_genre%TYPE,
      i_mcr_cast                       IN     x_movie_content_report.mcr_cast%TYPE,
      i_mcr_director                   IN     x_movie_content_report.mcr_director%TYPE,
      i_mcr_producer                   IN     x_movie_content_report.mcr_producer%TYPE,
      i_mcr_dom_age_restrictions       IN     x_movie_content_report.mcr_dom_age_restrictions%TYPE,
      i_mcr_afr_age_restrictions       IN     x_movie_content_report.mcr_afr_age_restrictions%TYPE,
      i_mcr_tx_date                    IN     x_movie_content_report.mcr_tx_date%TYPE,
      i_mcr_africa_tx                  IN     x_movie_content_report.mcr_africa_tx%TYPE,
      i_mcr_target_audience            IN     x_movie_content_report.mcr_target_audience%TYPE,
      --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
      i_aka_title                      IN     fid_general.gen_aka_title%TYPE,
      i_gen_SVOD_Express               IN     FID_GENERAL.GEN_SVOD_EXPRESS%TYPE,--bhagyashri
      /* Svod rights by Vikas Srivastava*/
      i_gen_SVOD_Rights                 IN    fid_general.GEN_SVOD_RIGHTS%TYPE,
      i_gen_express                     IN    fid_general.GEN_EXPRESS%TYPE,
      i_gen_catalogue                   IN    fid_general.GEN_CATALOGUE%TYPE,
       i_cnt_release_uid                IN     FID_GENERAL.GEN_CNT_RELEASE_UID%TYPE,--Added by Zeshan for 10Digit UID CR
      /*END Svod rights */
      /*START :Scheduling CRs [ANKUR KASAR]*/
      I_AITW_CHA_NUMBER                IN   x_pkg_common_var.number_array,
      I_AITW_IS_DAY_TIME               IN   x_pkg_common_var.varchar_array,
      I_AITW_START_TIME                IN   x_pkg_common_var.varchar_array,
      I_AITW_END_TIME                  IN   x_pkg_common_var.varchar_array,
      I_AITW_CHANGE_STATUS             IN   x_pkg_common_var.varchar_array,
      I_CAT_START_TIME                 IN   x_pkg_common_var.varchar_array,
      I_CAT_END_TIME                   IN   x_pkg_common_var.varchar_array,
      I_AITW_PRG_N_SCH_CHANNEL         IN   FID_GENERAL.GEN_PRG_N_SCH_CHANNEL%TYPE,
      I_GEN_SCH_ARF_CUSTM              IN   FID_GENERAL.GEN_SCH_ARF_CUSTM%TYPE,
      I_GEN_TAP_SEQ_NO                 IN   FID_GENERAL.GEN_TAP_SEQ_NO%TYPE,
      I_GEN_ADDINFO_COMMENTS           IN   FID_GENERAL.GEN_ADDINFO_COMMENTS%TYPE,
      /*END :Scheduling CRs [ANKUR KASAR]*/
      I_GEN_TVOD_BO_CATEGORY_CODE       IN     fid_general.GEN_TVOD_BO_CATEGORY_CODE%type, --Added by sushma
      o_rpt_id                            OUT x_movie_content_report.mcr_report_id%TYPE -- DEV4: Programme Acceptance (Release 12) : End :  : <17-06-2013 >
                                       --END: PROJECT BIOSCOPE ? PENDING CR?S:
      ,
      o_gen_refno                         OUT fid_general.gen_refno%TYPE,
      o_gen_tx_warnning                OUT FID_GENERAL.GEN_RE_TX_WARNING%TYPE
      );

   --PROCEDURE UPDATE PROGRAM UPDATES THE PROGRAM FOR MNET
   PROCEDURE pck_mm_mnet_pl_updateprogram (
      i_gen_title                      IN     fid_general.gen_title%TYPE,
      i_gen_title_working              IN     fid_general.gen_title_working%TYPE,
      /*
      DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
      i_gen_sub_title           IN       fid_general.gen_sub_title%TYPE,
      i_gen_music_title         IN       fid_general.gen_music_title%TYPE,
      i_gen_poem_title          IN       fid_general.gen_poem_title%TYPE,
      i_gen_stu_code            IN       fid_general.gen_stu_code%TYPE,
      i_gen_colour              IN       fid_general.gen_colour%TYPE,
      i_gen_code                IN       fid_general.gen_code%TYPE,
      ----Added for web title
      i_gen_web_title           IN       fid_general.GEN_WEB_TITLE%TYPE,
      5 check boxes
      i_gen_widescreen          IN       fid_general.gen_widescreen%TYPE,
      i_gen_cat_complete        IN       fid_general.gen_cat_complete%TYPE,
      i_gen_nfa_copy            IN       fid_general.gen_nfa_copy%TYPE,
      i_gen_tx_digitized        IN       fid_general.gen_tx_digitized%TYPE,
      i_gen_archive             IN       fid_general.gen_archive%TYPE,
      Live tab
      --I_FGL_GEN_REFNO in FID_GEN_LIVE.FGL_GEN_REFNO%TYPE,
      i_fgl_venue               IN       fid_gen_live.fgl_venue%TYPE,
      i_fgl_location            IN       fid_gen_live.fgl_location%TYPE,
      i_fgl_live_date           IN       fid_gen_live.fgl_live_date%TYPE,
      i_fgl_time                IN       fid_gen_live.fgl_time%TYPE,
      In Add info Tab
      i_gen_copy_restrictions   IN       fid_general.gen_copy_restrictions%TYPE,
      i_gen_abstract            IN       fid_general.gen_abstract%TYPE,
      DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
      */
      i_gen_category                   IN     fid_general.gen_category%TYPE,
      i_gen_rating_mpaa                IN     fid_general.gen_rating_mpaa%TYPE,
      i_gen_subgenre                   IN     fid_general.gen_subgenre%TYPE,
      i_gen_rating_int                 IN     fid_general.gen_rating_int%TYPE,
      i_gen_quality                    IN     fid_general.gen_quality%TYPE,
      i_gen_series                     IN     fid_general.gen_series%TYPE,
      i_gen_spoken_lang                IN     fid_general.gen_sub_title%TYPE,
      i_gen_refno                      IN     fid_general.gen_refno%TYPE,
      i_gen_parent_refno               IN     fid_general.gen_parent_refno%TYPE,
      i_gen_type                       IN     fid_general.gen_type%TYPE,
      i_gen_release_year               IN     fid_general.gen_release_year%TYPE,
      i_gen_nationality                IN     fid_general.gen_nationality%TYPE,
      i_gen_duration_c                 IN     fid_general.gen_duration_c%TYPE,
      i_gen_duration_s                 IN     fid_general.gen_duration_s%TYPE,
      --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
      I_GEN_DURATION_PGA               IN     fid_general.GEN_PGA_DURATION%TYPE,
      --DEV.R4:Inventory Mining:End
      i_gen_epi_number                 IN     fid_general.gen_epi_number%TYPE,
      i_gen_award                      IN     fid_general.gen_award%TYPE,
      i_gen_target_group               IN     fid_general.gen_target_group%TYPE,
      -- Prod.Support : SVOD : Start : [Devashish Raverkar]_[2015-03-20]
      i_gen_sec_target_group           IN     fid_general.gen_sec_target_group%TYPE,
      -- Prod.Support : SVOD : End
      --Catch and PB CR[SCH 32][Mangesh Gulhane][13-AUG-13][Added column for AFR writeoff]
      i_gen_is_afr_writeoff            IN     fid_general.gen_is_afr_writeoff%TYPE,
      i_gen_is_day_time_rest           IN     fid_general.gen_is_day_time_rest%TYPE,
      --Catch and PB CR END
      i_flag_metadata_verified         IN     fid_general.gen_metadata_verified%TYPE,
      -- #region Abhinay_230512014 : New Field Metadata Verified
      --#region 6March2015: EmbargoContent Save Logic Change
      i_is_embargo                     IN     fid_general.gen_embargo_content%TYPE,
      i_prog_embargo                   IN     fid_general.gen_embargo_content%TYPE,
      --#endregion 6March2015
      I_IS_PROG_CINEMA_EMBARGO         IN     fid_general.gen_is_cinema_embargo_content%TYPE,--Onsite.Dev:Bhagyashri
      i_gen_comment                    IN     fid_general.gen_comment%TYPE,
      --I_GEN_SUPPLIER_COM_NUMBER  IN FID_GENERAL.GEN_SUPPLIER_COM_NUMBER%TYPE,
      i_gen_re_tx_warning              IN     fid_general.gen_re_tx_warning%TYPE,
      --kunal : START 02-03-2015 Production Number
      i_gen_production_number          IN     fid_general.gen_production_number%TYPE,
      --kunal : END Production Number
      --I_GEN_TITLE_EPISODE   IN FID_GENERAL.GEN_TITLE_EPISODE%TYPE,
      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :i_supp_short_name removed for -Restricting creation of duplicate Titles on Programme Maintenance */
      --SYN_GEN_REFNO      in FID_SYNOPSIS.SYN_GEN_REFNO%TYPE,
          ---  START: EPG Phase 1 : [11-06-2016] : [SUSHMA K]
     --commented below input parameters
    /*  i_syn_synopsis_local             IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsis_full              IN     fid_synopsis.syn_synopsis%TYPE,
      i_synopsis_id_local              IN     fid_synopsis.syn_syt_id%TYPE,
      i_synopsis_id_full               IN     fid_synopsis.syn_syt_id%TYPE,
      --**************TVOD-Added********************************
      i_syn_synopsisid_web             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_web        IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsisid_mob             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_mob        IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsisid_epg             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_epg        IN     fid_synopsis.syn_synopsis%TYPE,
      --**************TVOD-END***********************************
      -- Added by Pravin_20130111- Supplier Synopsis
      i_syn_synopsisid_supplier        IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_supplier   IN     fid_synopsis.syn_synopsis%TYPE,*/
      --End
      --END :EPG Phase 1
      -- I_PRO_TITLE    in FID_PRODUCTION.PRO_TITLE%TYPE,
      -- I_PRO_STATUS      in FID_PRODUCTION.PRO_STATUS%TYPE,
      i_tap_title                      IN     fid_tape.tap_title%TYPE,
      i_tap_type                       IN     fid_tape.tap_type%TYPE,
      i_tap_format                     IN     fid_tape.tap_format%TYPE,
      i_tap_barcode                    IN     fid_tape.tap_barcode%TYPE,
      i_entry_oper                     IN     fid_general.gen_entry_oper%TYPE,
      --**************Bioscope-Added********************************
      i_imdb_rating                    IN     NUMBER,
      i_ar_rating                      IN     VARCHAR2,
      i_expert_rating                  IN     VARCHAR2,
      i_bo_category                    IN     VARCHAR2,
      i_usd_revenue                    IN     NUMBER,
      i_zar_revenue                    IN     NUMBER,
      i_final_grade                    IN     VARCHAR2,
      i_gen_prog_category_code         IN     VARCHAR2,
      i_gen_tertiary_genre             IN     VARCHAR2,
      i_web_title                      IN     fid_general.gen_web_title%TYPE,
      --**************Bioscop-END***********************************
      --START: PROJECT BIOSCOPE ? PENDING CR?S: Mangesh Gulhane_20121003
      -- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
      i_gen_mood                       IN     fid_general.gen_mood%TYPE,
      i_gen_link_poster_art            IN     fid_general.gen_link_poster_art%TYPE,
      --END: PROJECT BIOSCOPE ? PENDING CR?S:
      --RDT Start Phoneix req [14-05-2014][Kiran]
      i_AttributeModifiedDateTime      IN     VARCHAR2,
      --RDT end Phoneix req [14-05-2014][Kiran]
      --DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
      i_gen_tags                       IN     fid_general.gen_tags%TYPE,
      i_gen_africa_type_duration_c     IN     fid_general.gen_africa_type_duration_c%TYPE,
      i_gen_africa_type_duration_s     IN     fid_general.gen_africa_type_duration_s%TYPE,
      i_gen_update_cnt                 IN     NUMBER,
      i_report_name                    IN     x_movie_content_report.mcr_report_name%TYPE,
      i_copy                           IN     x_movie_content_report.mcr_copy%TYPE,
      i_pfb_rating                     IN     x_movie_content_report.mcr_fpb_rating%TYPE,
      i_themes                         IN     x_movie_content_report.mcr_themes%TYPE,
      i_bad_language                   IN     x_movie_content_report.mcr_bad_language%TYPE,
      i_violence                       IN     x_movie_content_report.mcr_violence%TYPE,
      i_horror                         IN     x_movie_content_report.mcr_horror_suspence%TYPE,
      i_sex                            IN     x_movie_content_report.mcr_sex%TYPE,
      i_drugs                          IN     x_movie_content_report.mcr_drugs%TYPE,
      i_prejudice                      IN     x_movie_content_report.mcr_prejudice%TYPE,
      i_correctives                    IN     x_movie_content_report.mcr_correctives%TYPE,
      i_any_special_warnings           IN     x_movie_content_report.mcr_any_special_warnings%TYPE,
      i_summary_reasons                IN     x_movie_content_report.mcr_reasons_for_recoomended%TYPE,
      i_nudity                         IN     x_movie_content_report.mcr_nudity%TYPE,
      i_validation                     IN     VARCHAR2,
      i_mcr_report_id                  IN     x_movie_content_report.mcr_report_name%TYPE,
      i_mcr_location                   IN     x_movie_content_report.mcr_location%TYPE,
      i_mcr_afrc_reg_rating            IN     x_movie_content_report.mcr_afrc_reg_rating%TYPE,
      i_mcr_date_received              IN     x_movie_content_report.mcr_date_received%TYPE,
      i_mcr_date_viewed                IN     x_movie_content_report.mcr_date_viewed%TYPE,
      i_mcr_buyer_feedback             IN     x_movie_content_report.mcr_buyer_feedback%TYPE,
      i_mcr_synopsis                   IN     x_movie_content_report.mcr_synopsis%TYPE,
      i_mcr_watershed_restriction      IN     x_movie_content_report.mcr_watershed_restriction%TYPE,
      i_mcr_sub_title_language         IN     x_movie_content_report.mcr_sub_title_language%TYPE,
      i_upd_cnt                        IN     x_movie_content_report.mcr_update_count%TYPE,
      o_rid                               OUT NUMBER,
      i_mcr_programe_type              IN     x_movie_content_report.mcr_programe_type%TYPE,
      i_mcr_year_of_production         IN     x_movie_content_report.mcr_year_of_production%TYPE,
      i_mcr_language                   IN     x_movie_content_report.mcr_programe_type%TYPE,
      i_mcr_distributor                IN     x_movie_content_report.mcr_language%TYPE,
      i_mcr_primary_genre              IN     x_movie_content_report.mcr_primary_genre%TYPE,
      i_mcr_cast                       IN     x_movie_content_report.mcr_cast%TYPE,
      i_mcr_director                   IN     x_movie_content_report.mcr_director%TYPE,
      i_mcr_producer                   IN     x_movie_content_report.mcr_producer%TYPE,
      i_mcr_dom_age_restrictions       IN     x_movie_content_report.mcr_dom_age_restrictions%TYPE,
      i_mcr_afr_age_restrictions       IN     x_movie_content_report.mcr_afr_age_restrictions%TYPE,
      i_mcr_tx_date                    IN     x_movie_content_report.mcr_tx_date%TYPE,
      i_mcr_africa_tx                  IN     x_movie_content_report.mcr_africa_tx%TYPE,
      i_mcr_target_audience            IN     x_movie_content_report.mcr_target_audience%TYPE,
      i_season_synopsis                IN     fid_series.ser_synopsis%TYPE,
      i_series_synopsis                IN     fid_series.ser_synopsis%TYPE,
      --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
      i_aka_title                      IN     fid_general.gen_aka_title%TYPE,
      i_gen_catchup_category           IN     fid_general.GEN_CATCHUP_CATEGORY%TYPE, --added for CATCHUP:CACQ14:_[SHANTANU A.]_[12/01/2015]
      i_gen_catchup_priority           IN     FID_GENERAL.GEN_CATCHUP_PRIORITY%TYPE, ---added For CATCHUP CR[Rashmi T][25-03-2015]
      i_gen_SVOD_Express               IN     FID_GENERAL.GEN_SVOD_EXPRESS%TYPE,--bhagyashri
      i_gen_SVOD_Rights                IN     fid_general.GEN_SVOD_RIGHTS%TYPE,
      i_is_update_all_episode          IN     VARCHAR2,
      i_gen_express                    IN     VARCHAR2,
      i_update_all_epi_exp             IN     VARCHAR2,
      i_gen_catalogue                  IN     VARCHAR2,
      i_update_all_epi_cata            IN     VARCHAR2,
      i_cnt_release_uid                IN     FID_GENERAL.GEN_CNT_RELEASE_UID%TYPE,--Added by Zeshan for 10Digit UID CR
     /*START :Scheduling CRs [ANKUR KASAR]*/
      I_AITW_NUMBER                    IN   x_pkg_common_var.number_array,
      I_AITW_CHA_NUMBER                IN   x_pkg_common_var.number_array,
      I_AITW_IS_DAY_TIME               IN   x_pkg_common_var.varchar_array,
      I_AITW_START_TIME                IN   x_pkg_common_var.varchar_array,
      I_AITW_END_TIME                  IN   x_pkg_common_var.varchar_array,
      I_AITW_CHANGE_STATUS             IN   x_pkg_common_var.varchar_array,
      I_CAT_START_TIME                 IN   x_pkg_common_var.varchar_array,
      I_CAT_END_TIME                   IN   x_pkg_common_var.varchar_array,
      I_AITW_PRG_N_SCH_CHANNEL         IN   FID_GENERAL.GEN_PRG_N_SCH_CHANNEL%TYPE,
      I_GEN_SCH_ARF_CUSTM              IN   FID_GENERAL.GEN_SCH_ARF_CUSTM%TYPE,
      I_GEN_TAP_SEQ_NO                 IN   FID_GENERAL.GEN_TAP_SEQ_NO%TYPE,
      I_GEN_ADDINFO_COMMENTS           IN   FID_GENERAL.GEN_ADDINFO_COMMENTS%TYPE,
      /*END :Scheduling CRs [ANKUR KASAR]*/
       i_is_prog_archive_embargo         IN     fid_general.gen_is_archive_embargo_content%TYPE,
      I_GEN_TVOD_BO_CATEGORY_CODE       IN     fid_general.GEN_TVOD_BO_CATEGORY_CODE%type, --Added by sushma
      o_updated                        OUT NUMBER,
      o_gen_updatecount                OUT NUMBER
      );

   --PROCEDURE SEARCH PROGRAM SEARCH THE PROGRAM BASED ON GIVEN CRITERIA
   PROCEDURE pck_mnet_pl_searchprogram (
      i_gen_title               IN     fid_general.gen_title%TYPE,
      i_gen_title_working       IN     fid_general.gen_title_working%TYPE,
      /*
      -- DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
      i_gen_stu_code         IN       fid_general.gen_stu_code%TYPE,
      i_gen_colour           IN       fid_general.gen_colour%TYPE,
      i_gen_widescreen       IN       fid_general.gen_widescreen%TYPE,
      i_gen_cat_complete     IN       fid_general.gen_cat_complete%TYPE,
      i_gen_archive          IN       fid_general.gen_archive%TYPE,
      i_gen_nfa_copy         IN       fid_general.gen_nfa_copy%TYPE,
      i_gen_tx_digitized     IN       fid_general.gen_tx_digitized%TYPE,
      -- DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
      */
      i_gen_category            IN     fid_general.gen_category%TYPE,
      i_gen_rating_mpaa         IN     fid_general.gen_rating_mpaa%TYPE,
      i_gen_subgenre            IN     fid_general.gen_subgenre%TYPE,
      i_gen_quality             IN     fid_general.gen_quality%TYPE,
      i_gen_series              IN     fid_general.gen_series%TYPE,
      i_gen_spoken_lang         IN     fid_general.gen_spoken_lang%TYPE,
      i_gen_refno               IN     fid_general.gen_refno%TYPE,
      i_gen_type                IN     fid_general.gen_type%TYPE,
      i_gen_nationality         IN     fid_general.gen_nationality%TYPE,
      i_gen_epi_number          IN     fid_general.gen_epi_number%TYPE,
      i_gen_target_group        IN     fid_general.gen_target_group%TYPE,
      /* RDT :MOP_CR_12.8 :Abhishek Mor 21/08/2014 :I_SUPP_SHORT_NAME removed-Impact of Requirement on other screens */
      i_programmedurationc      IN     fid_general.gen_duration_c%TYPE,
      i_release_year            IN     fid_general.gen_release_year%TYPE,
      i_tertiary_genre          IN     fid_general.gen_tertiary_genre%TYPE,
      i_embargo                 IN     fid_general.GEN_EMBARGO_CONTENT%TYPE, --#region Abhinay_1oct14: Embargo Content Implementation
      --kunal : START 02-03-2015: Production Number
      i_gen_production_number   IN     fid_general.gen_production_number%TYPE,
      --kunal : END Production Number
	  i_gen_epg_content_id		IN		fid_general.gen_epg_content_id%type,
    i_uid                  IN     fid_tape.tap_barcode%TYPE,
      o_programdetails             OUT SYS_REFCURSOR);

   --PROCEDURE SEARCHPRGDETAIL SEARCHED ALL THE 8 TABS BELOW AFTER THE USE SELECT PERTICULAR PROGRAM
   PROCEDURE pck_mm_mnet_pl_searchprgdetail (
      i_gen_refno                    IN     fid_general.gen_refno%TYPE,
      o_programdetails                  OUT SYS_REFCURSOR,
      o_livedetails                     OUT SYS_REFCURSOR,
      o_librarydetails                  OUT SYS_REFCURSOR,
      o_synopsisdetails                 OUT SYS_REFCURSOR,
      o_castdetails                     OUT SYS_REFCURSOR,
      o_locaprogdetails                 OUT SYS_REFCURSOR,
      o_promodetails                    OUT SYS_REFCURSOR,
      o_filedetails                     OUT SYS_REFCURSOR,
      o_proddetails                     OUT SYS_REFCURSOR,
      o_supplierdetails                 OUT SYS_REFCURSOR,
      o_link_count                      OUT SYS_REFCURSOR,
      --added for bioscope
      o_rating_details                  OUT SYS_REFCURSOR,
      -- Add by
      --DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
      o_mcr                             OUT SYS_REFCURSOR,
      o_pga_time_code                   OUT SYS_REFCURSOR --DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
                                                         --RDT Start Phoneix req [08-052014][Kiran]
      ,
      o_sch_count                       OUT SYS_REFCURSOR,
      --RDT end Phoneix req [08-052014][Kiran]
      --RDT :MOP_CR_12.5 :Abhishek Mor 19/08/2014-Add Supplier Tab on Programme Maintenance-Start
      o_PrgTitle_Supplier_Details       OUT SYS_REFCURSOR,
      --RDT :MOP_CR_12.5 :Abhishek Mor 19/08/2014-Add Supplier Tab on Programme Maintenance-End
      --RDT :Release 10:NEERAJ 22/09/2014-Add Translated Titles Tab on Programme Maintenance-START
      o_PrgTitle_translated_titles      OUT SYS_REFCURSOR,
      --RDT :Release 10 :NEERAJ 22/09/2014-Add Translated Titles Tab on Programme Maintenance-End
      /*Clearleap Release*/
      o_Catchup_VOD_dtl                 OUT SYS_REFCURSOR,
     --media ops CR nasreen mulla
      O_NOTES_DETAILS                   OUT SYS_REFCURSOR
      ,O_GET_VOD_HISTORY_DETAILS        OUT SYS_REFCURSOR
	  --Added By Pravin to get The Roles list for detail screen
      ,o_Role_List					     OUT SYS_REFCURSOR
      ,o_editlist_details        OUT SYS_REFCURSOR   -- CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]
      ,o_prg_maintaince_add_info OUT SYS_REFCURSOR
	  );

   -- Add by
   --DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
   PROCEDURE x_prc_serch_audit_mcr (i_month       IN     VARCHAR2,
                                    i_year        IN     NUMBER,
                                    i_user_name   IN     VARCHAR2,
                                    res              OUT SYS_REFCURSOR);

   --DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
   PROCEDURE pck_mm_mnet_pl_searchprogram (
      i_gen_title            IN     fid_general.gen_title%TYPE,
      i_gen_title_working    IN     fid_general.gen_title_working%TYPE,
      i_gen_stu_code         IN     fid_general.gen_stu_code%TYPE,
      i_gen_category         IN     fid_general.gen_category%TYPE,
      i_gen_rating_mpaa      IN     fid_general.gen_rating_mpaa%TYPE,
      i_gen_subgenre         IN     fid_general.gen_subgenre%TYPE,
      i_gen_quality          IN     fid_general.gen_quality%TYPE,
      i_gen_colour           IN     fid_general.gen_colour%TYPE,
      i_gen_series           IN     fid_general.gen_series%TYPE,
      i_gen_spoken_lang      IN     fid_general.gen_spoken_lang%TYPE,
      i_gen_refno            IN     fid_general.gen_refno%TYPE,
      i_gen_type             IN     fid_general.gen_type%TYPE,
      i_gen_nationality      IN     fid_general.gen_nationality%TYPE,
      i_gen_epi_number       IN     fid_general.gen_epi_number%TYPE,
      i_gen_target_group     IN     fid_general.gen_target_group%TYPE,
      i_gen_widescreen       IN     fid_general.gen_widescreen%TYPE,
      i_gen_cat_complete     IN     fid_general.gen_cat_complete%TYPE,
      i_gen_archive          IN     fid_general.gen_archive%TYPE,
      i_gen_nfa_copy         IN     fid_general.gen_nfa_copy%TYPE,
      i_gen_tx_digitized     IN     fid_general.gen_tx_digitized%TYPE,
      i_supp_short_name      IN     fid_company.com_short_name%TYPE,
      i_programmedurationc   IN     fid_general.gen_duration_c%TYPE,
      i_release_year         IN     fid_general.gen_release_year%TYPE,
      i_tertiary_genre       IN     fid_general.gen_tertiary_genre%TYPE,
      o_programdetails          OUT SYS_REFCURSOR);

   PROCEDURE pck_mm_mnet_pl_deleteprogram (
      i_gen_refno        IN     fid_general.gen_refno%TYPE,
      i_entry_oper       IN     fid_general.gen_entry_oper%TYPE,
      o_programdeleted      OUT NUMBER);

   --
   PROCEDURE pck_mm_mnet_pl_searchprglink (
      i_gen_working_title   IN     fid_general.gen_title_working%TYPE,
      i_gen_title           IN     fid_general.gen_title%TYPE,
      i_gen_refno           IN     VARCHAR2,
      i_lic_number          IN     fid_license.lic_number%TYPE,
      o_returnprogram          OUT SYS_REFCURSOR,
      o_returnlicense          OUT SYS_REFCURSOR,
      o_returnchannel          OUT SYS_REFCURSOR);

   PROCEDURE pck_mm_mnet_pl_searchtapelink (
      i_tap_title            IN     fid_tape.tap_title%TYPE,
      i_tap_status           IN     fid_tape.tap_match_status%TYPE,
      i_tap_type             IN     fid_tape.tap_type%TYPE,
      i_tap_num              IN     fid_tape.tap_barcode%TYPE,
      o_tapedetail              OUT SYS_REFCURSOR,
      o_tapesegmentdetails      OUT pkg_mm_mnet_pl_prgmaintenance.c_cursor_prg,
      --UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[24-01-2014]
      o_uid_excp                OUT VARCHAR2             --UID_Generation: End
                                            );

   PROCEDURE pck_mm_mnet_pl_linktitles (
      i_tap_tile             IN     fid_tape.tap_title%TYPE,
      i_tap_number           IN     fid_tape.tap_number%TYPE,
      i_gen_refno            IN     fid_general.gen_refno%TYPE,
      i_txm_id               IN     sgy_mn_txm_details.txm_id%TYPE,
      i_pronumber            IN     fid_production.pro_number%TYPE,
      i_lic_number           IN     fid_license.lic_number%TYPE,
      i_cha_list             IN     VARCHAR2,
      i_tap_pro_num          IN     fid_tape.tap_pro_number%TYPE,
      i_match_status         IN     fid_tape.tap_match_status%TYPE,
      i_linkflag             IN     VARCHAR2,
      i_entry_oper           IN     fid_tape.tap_entry_oper%TYPE,
      o_tapedetails             OUT pkg_mm_mnet_pl_prgmaintenance.c_cursor_prg,
      o_tapesegmentdetails      OUT pkg_mm_mnet_pl_prgmaintenance.c_cursor_prg --commented by mangesh [11-SEP-13] no reference found on UI
                                                                              --,
                                                                              -- o_tapesegmentdetails OUT pkg_mm_mnet_pl_prgmaintenance.c_cursor_prg
      );

   PROCEDURE prc_insert_loc_ter_info (
      i_gen_refno         IN     fid_general.gen_refno%TYPE,
      i_loc_ter_code      IN     fid_general_local.loc_ter_code%TYPE,
      i_loc_release_the   IN     fid_general_local.loc_release_the%TYPE,
      i_loc_release_vid   IN     fid_general_local.loc_release_vid%TYPE,
      i_loc_release_tv    IN     fid_general_local.loc_release_tv%TYPE,
      i_loc_comment       IN     fid_general_local.loc_comment%TYPE,
      i_loc_title         IN     fid_general_local.loc_title%TYPE,
      i_entry_oper        IN     fid_general_local.loc_entry_oper%TYPE,
      o_success              OUT NUMBER);

   PROCEDURE prc_insertcast (
      i_gen_refno    IN     fid_general.gen_refno%TYPE,
      i_cas_role     IN     fid_general_cast.cas_role%TYPE,
      i_cas_award    IN     fid_general_cast.cas_award%TYPE,
      i_cas_name     IN     fid_general_cast.cas_name%TYPE,
      i_cas_order    IN     fid_general_cast.cas_order%TYPE,
      i_entry_oper   IN     fid_general_cast.cas_entry_oper%TYPE,
      o_success         OUT NUMBER);

   PROCEDURE prc_insertfiles (
      i_genrefno      IN     fid_general.gen_refno%TYPE,
      i_afi_file_id   IN     fid_attach_file.afi_file_id%TYPE,
      i_entry_oper    IN     fid_attach_file.afi_entry_oper%TYPE,
      o_success          OUT NUMBER);

   PROCEDURE prc_updatecast (
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_cas_role        IN     fid_general_cast.cas_role%TYPE,
      i_cas_award       IN     fid_general_cast.cas_award%TYPE,
      i_cas_name        IN     fid_general_cast.cas_name%TYPE,
      i_cas_order       IN     fid_general_cast.cas_order%TYPE,
      i_cas_unique_id   IN     fid_general_cast.cas_unique_id%TYPE,
      i_entry_oper      IN     fid_general_cast.cas_entry_oper%TYPE,
      o_success            OUT NUMBER);

   PROCEDURE prc_updatelocal (
      i_loc_gen_refno     IN     fid_general_local.loc_gen_refno%TYPE,
      i_loc_ter_code      IN     fid_general_local.loc_ter_code%TYPE,
      i_loc_release_the   IN     fid_general_local.loc_release_the%TYPE,
      i_loc_release_vid   IN     fid_general_local.loc_release_vid%TYPE,
      i_loc_release_tv    IN     fid_general_local.loc_release_tv%TYPE,
      i_loc_comment       IN     fid_general_local.loc_comment%TYPE,
      i_loc_title         IN     fid_general_local.loc_title%TYPE,
      i_loc_unique_id     IN     fid_general_local.loc_unique_id%TYPE,
      i_entry_oper        IN     fid_general_local.loc_entry_oper%TYPE,
      o_success              OUT NUMBER);

   PROCEDURE prc_updatefiles (
      i_genrefno      IN     fid_general.gen_refno%TYPE,
      i_afi_file_id   IN     fid_attach_file.afi_file_id%TYPE,
      i_entry_oper    IN     fid_attach_file.afi_entry_oper%TYPE,
      o_success          OUT NUMBER);

   PROCEDURE prc_deletecast (
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_cas_role        IN     fid_general_cast.cas_role%TYPE,
      i_cas_name        IN     fid_general_cast.cas_name%TYPE,
      i_cas_award       IN     fid_general_cast.cas_award%TYPE,
      i_cas_unique_id   IN     fid_general_cast.cas_unique_id%TYPE,
      --Dev.R10 : Audit on Programme Maintenance : Start : [Devashish Raverkar]_[2015/10/08]
      i_cas_entry_oper  IN     fid_general_cast.cas_entry_oper%TYPE,
      --Dev.R10 : Audit on Programme Maintenance : End
      o_success            OUT NUMBER);

   PROCEDURE prc_deletelocal (
      i_loc_gen_refno   IN     fid_general_local.loc_gen_refno%TYPE,
      i_tercode         IN     fid_general_local.loc_ter_code%TYPE,
      i_localtitle      IN     fid_general_local.loc_title%TYPE,
      i_loc_unique_id   IN     fid_general_local.loc_unique_id%TYPE,
      o_success            OUT NUMBER);

   PROCEDURE prc_deletefiles (i_genrefno   IN     fid_general.gen_refno%TYPE,
                              o_success       OUT NUMBER);

   FUNCTION get_duration (i_duration VARCHAR)
      RETURN VARCHAR;

   --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
   FUNCTION is_tvod_prog (i_genrefno NUMBER)
      RETURN NUMBER;

   --Dev3: TVOD_CR: END :[TVOD_CR]
   --- Add by
   --DEV4: Programme Acceptance (Release 12) : Start :  : <17-06-2013> : <Refer PGA01 document>
   PROCEDURE pck_mm_mnet_pl_searchtxwarning (
      i_gen_refno           IN     fid_general.gen_refno%TYPE DEFAULT 0,
      o_programe_schedule      OUT SYS_REFCURSOR);

   PROCEDURE x_prc_search_mcr (
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_report_id       IN     x_movie_content_report.mcr_report_id%TYPE,
      o_movie_content      OUT SYS_REFCURSOR);

   ---DEV4: Programme Acceptance (Release 12) : Start :  : <17-06-2013> : <Refer PGA01 document>
   PROCEDURE x_prc_delete_pga_time_code (i_pga_tc_id IN NUMBER);

   PROCEDURE x_prc_insert_pga_time_code (i_mcr_report_id   IN NUMBER,
                                         i_part            IN VARCHAR2,
                                         i_segment         IN VARCHAR2,
                                         i_start_of_mesg   IN VARCHAR2,
                                         i_end_of_mesg     IN VARCHAR2,
                                         i_comment         IN VARCHAR2,
                                         i_entry_oper      IN VARCHAR2);

   FUNCTION x_fnu_time_calculate (i_stime VARCHAR2, i_etime VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE x_prc_update_pga_time_code (i_pga_tc_id       IN NUMBER,
                                         i_part            IN VARCHAR2,
                                         i_segment         IN VARCHAR2,
                                         i_start_of_mesg   IN VARCHAR2,
                                         i_end_of_mesg     IN VARCHAR2,
                                         i_comment         IN VARCHAR2,
                                         i_upd_oper        IN VARCHAR2,
                                         i_upt_cnt         IN NUMBER);

   -- DEV4: Programme Acceptance (Release 12) : End :  : <17-06-2013 >
   PROCEDURE x_prc_store_ardome_information (
      i_lic_number      IN     VARCHAR2,
      i_tape_number     IN     NUMBER,
      i_item_id         IN     VARCHAR2,
      i_tape_id         IN     VARCHAR2,
      i_tape_entry_id   IN     VARCHAR2,
      o_updated            OUT NUMBER);

   PROCEDURE x_prc_get_ardome_details (
      i_tape_number      IN     NUMBER,
      i_lic_number       IN     VARCHAR2,
      i_link_flag        IN     VARCHAR2,
      o_ardome_details      OUT SYS_REFCURSOR);

   PROCEDURE x_prc_get_kill_date (i_gen_refno        IN     NUMBER,
                                  i_lic_number       IN     VARCHAR2,
                                  o_ardome_details      OUT SYS_REFCURSOR);

   PROCEDURE x_prc_get_uid_kill_date (
      i_tapenumber       IN     NUMBER,
      o_ardome_details      OUT SYS_REFCURSOR);

   PROCEDURE x_prc_get_ardome_audit_entry (
      i_entry_date       IN     DATE,
      o_ardome_details      OUT SYS_REFCURSOR);

   --On air yogesh start
   PROCEDURE x_prc_save_version_synopsis (
      i_gen_refno                     IN     NUMBER,
      i_syn_synopsisid_version        IN     NUMBER,
      i_syn_ver_lang_id               IN     NUMBER,
      i_syn_synopsisdetails_version   IN     VARCHAR2,
      i_syn_login_user                IN     VARCHAR2,
      o_success                          OUT NUMBER);

   PROCEDURE x_prc_search_ver_synopsis (i_gen_refno   IN     NUMBER,
                                        o_ver_syn        OUT SYS_REFCURSOR);

   --On air yogesh end

   --UID_Generation: Start:[MOP_UID_06]_[Anuja_Shinde]_[12-26-2013]
   PROCEDURE x_prc_mm_save_libmaterialdtls (
      i_gen_refno        IN     fid_general.gen_refno%TYPE,
      i_unique_id        IN     fid_tape.tap_barcode%TYPE,
      i_uid_status       IN     x_uid_status.uid_status%TYPE,
      i_uid_comment      IN     fid_tape.tap_comment%TYPE,
      i_update_count     IN     fid_tape.tap_update_count%TYPE,
      i_syn_login_user   IN     fid_tape.tap_entry_oper%TYPE,
      i_age_restriction  IN     fid_tape.tap_age_restriction%TYPE, -- CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]_[start]
      i_tap_cp_area      IN     fid_tape.tap_cp_area%TYPE,
      i_tap_cp_work_instruction IN fid_tape.tap_cp_work_instruction%TYPE,-- CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]_[end]
      o_return_rec          OUT SYS_REFCURSOR,
      o_result              OUT NUMBER);

   PROCEDURE x_prc_email_dtls_pga_reject (
      i_action                 IN     VARCHAR2,
      o_return_email_details      OUT SYS_REFCURSOR);

   --UID_Generation: End

   --#region Abhinay_1oct14: Embargo Content Implementation

   PROCEDURE pck_mm_mnet_get_embargodet (
      i_genref    IN     fid_general.gen_refno%TYPE,
      i_embargo   IN     fid_general.gen_embargo_content%TYPE,
      o_cursor       OUT SYS_REFCURSOR);

   PROCEDURE pck_mm_mnet_del_mapping (
      i_tapenumber IN fid_tape.tap_number%TYPE);

   --#region: NEW CHANGES IN EMBARGO @ 20 Nov 2014

   PROCEDURE pck_mm_mnet_get_arddet (
      i_tapenumber   IN     fid_tape.tap_number%TYPE,
      o_cursor          OUT SYS_REFCURSOR);

   --#endregion: NEW CHANGES IN EMBARGO @ 20 Nov 2014


   --#region Abhinay_1dec14 : Ardome Issues Fix

   PROCEDURE pck_mm_mnet_save_synergy (i_tape            IN     NUMBER,
                                       i_item_id         IN     VARCHAR2,
                                       i_tape_id         IN     VARCHAR2,
                                       i_tape_entry_id   IN     VARCHAR2,
                                       o_success            OUT NUMBER);

   PROCEDURE pck_mm_mnet_save_synergy_Prod (
      i_tape            IN     NUMBER,
      i_item_id         IN     VARCHAR2,
      i_tape_id         IN     VARCHAR2,
      i_tape_entry_id   IN     VARCHAR2,
      o_success            OUT NUMBER);

   --#endregion Abhinay_1dec14 : Ardome Issues Fix

   FUNCTION FUN_CONVERT_DURATION_C_N (p_durchar IN VARCHAR2)
      RETURN NUMBER;

   --Translated Titles tab: Start:[RDT release 10]_[Neeraj Basliyal]_[09-26-2014]
   PROCEDURE prc_insertTranslatedTitle (
      i_gen_refno        IN     fid_general.gen_refno%TYPE,
      i_trans_language   IN     x_fid_general_alt_title.trans_language%TYPE,
      i_trans_name       IN     x_fid_general_alt_title.trans_name%TYPE,
      i_entry_oper       IN     x_fid_general_alt_title.trans_entry_oper%TYPE,
      i_transGenre_Id    IN     X_TRANSLATED_GENRE.XTG_GENRE_ID%TYPE,
      o_success          OUT NUMBER,
      o_delall_status    IN OUT VARCHAR2);

   PROCEDURE prc_updateTranslatedTitle (
      i_gen_refno         IN     fid_general.gen_refno%TYPE,
      i_trans_language    IN     x_fid_general_alt_title.trans_language%TYPE,
      i_trans_name        IN     x_fid_general_alt_title.trans_name%TYPE,
      i_trans_unique_id   IN     x_fid_general_alt_title.trans_unique_id%TYPE,
      i_entry_oper        IN     x_fid_general_alt_title.trans_entry_oper%TYPE,
      o_success              OUT NUMBER);

   PROCEDURE prc_DeleteTranslatedTitle (
      i_gen_refno   IN     fid_general.gen_refno%TYPE,
      o_success        OUT NUMBER);

   -- Added by Sandip
   PROCEDURE PCK_UPDATE_ARDOME_ITEM_ID (I_TAPE_BARCODE   IN     VARCHAR2,
                                        I_ITEM_ID        IN     VARCHAR2,
                                        O_SUCCESS           OUT NUMBER);
--Translated Titles tab: End
   /*Added by Swapnil Malvi on 12-Mar-2015 for Clearleap Release*/
   /*To save VOD Tab data*/
   PROCEDURE Prc_Save_VOD_Details (
      i_pvd_uid_lang_id          IN     x_prog_vod_details.pvd_uid_lang_id%TYPE,
      i_pvd_gen_refno            IN     x_prog_vod_details.pvd_gen_refno%TYPE,
      i_pvd_gen_title            IN     x_prog_vod_details.pvd_gen_title%TYPE,
      i_pvd_pvr_title            IN     x_prog_vod_details.pvd_pvr_title%TYPE,
      i_pvd_show_type            IN     x_prog_vod_details.pvd_show_type%TYPE,
      i_pvd_themes               IN     VARCHAR2,
      i_pvd_primary_genre        IN     VARCHAR2,
      i_pvd_secondary_genre      IN     VARCHAR2,
      i_pvd_actors               IN     x_prog_vod_details.pvd_actors%TYPE,
      i_pvd_directors            IN     x_prog_vod_details.pvd_directors%TYPE,
      i_pvd_title_synopsis       IN     x_prog_vod_details.pvd_title_synopsis%TYPE,
      i_svd_ser_title            IN     x_ser_vod_details.svd_ser_title%TYPE,
      i_svd_synopsis_ser         IN     x_ser_vod_details.svd_synopsis%TYPE,
      i_svd_synopsis             IN     x_ser_vod_details.svd_synopsis%TYPE,
      i_pvd_afr_title_synopsis   IN     x_prog_vod_details.PVD_AFR_TITLE_SYNOPSIS%TYPE,
      i_svd_afr_synopsis_ser     IN     x_ser_vod_details.svd_afr_synopsis%TYPE,
      i_svd_afr_synopsis         IN     x_ser_vod_details.svd_afr_synopsis%TYPE,
      i_svd_entry_oper           IN     x_ser_vod_details.svd_entry_oper%TYPE,
      /*Start: Added by sushma on 11-07-2016 for EPG Vod chnages to maintain the synopsis versin*/
      i_title_ver                IN     x_prog_vod_details.PVD_SYN_VERSION%TYPE,
      i_season_ver               IN     x_ser_vod_details.SVD_SYN_VERSION%TYPE,
      i_ser_ver                  IN     x_ser_vod_details.SVD_SYN_VERSION%TYPE, --END
      o_sucess_flag              OUT    NUMBER);

   /*Added by Khilesh on 19-Mar-2015 for Clearleap Release*/
/*Cursors for Language List and for Fields with Character length*/
   PROCEDURE x_prc_lang_list_n_field_limits (o_field_limits     OUT SYS_REFCURSOR,
                                             o_language_lists   OUT SYS_REFCURSOR);

     PROCEDURE X_PRC_GET_SABC_COUNT(I_TAP_BARCODE   IN      fid_tape.tap_barcode%TYPE,
                                        O_COUNT  OUT     number);



/*Function to get Given title is series or not*/
   FUNCTION X_FNC_PROG_IS_SER (I_GEN_REFNO NUMBER)
     RETURN VARCHAR2;

-- for media ops CR - Nasreen Mulla
PROCEDURE x_prc_add_title_note
      (
        i_gen_refno      IN x_gen_notes.XGT_GEN_REFNO%TYPE,
        i_comment        IN x_gen_notes.XGT_COMMENT%TYPE,
        i_entry_operator IN x_gen_notes.XGT_ENTRY_OPER%TYPE,
        o_return_result out NUMBER
      );

    PROCEDURE x_prc_search_title_linkednotes
      (
        i_gen_refno IN fid_general.gen_refno%TYPE,
        o_details out sys_refcursor);
-- for media ops CR - Nasreen Mulla

-------------------------BR_15_178 Updatable Asset and Sub Title on reforming Broadcast Title-----------------------------------------------------------------------------------
    PROCEDURE x_prc_update_asset_title
      (
        i_gen_refno IN fid_general.gen_refno%TYPE,
        i_asset_title IN FID_GENERAL.GEN_TITLE_WORKING%TYPE,
        i_entry_opr IN FID_AUDIT.AUD_ENTRY_OPER%TYPE,
        o_details out NUMBER
      );

      /*CU4ALL START : [ANUJA SHINDE]_[09/01/2016]*/
	PROCEDURE X_PRC_SAVE_VOD_HISTORY_CMNT
	(
	      i_PVDH_ID in number,
	      i_gen_refno in number,
	      i_comment in varchar2,
	      i_user_name in varchar2,
	      O_RESULT  OUT NUMBER
	);

	PROCEDURE PRC_SAVE_VOD_DETAILS_COLOR (
       i_PROG_uid_lang_id          IN     number,
      i_PROG_gen_refno            IN     number,
      i_PROG_gen_title            IN     VARCHAR2,
      i_PROG_pvr_title            IN     VARCHAR2,
      I_PROG_SHOW_TYPE            IN     VARCHAR2,
     -- i_PROG_themes               IN     VARCHAR2,
      --i_PROG_primary_genre        IN     VARCHAR2,
      --i_PROG_secondary_genre      IN     VARCHAR2,
      I_PROG_ACTORS               IN     VARCHAR2,
      i_PROG_directors            IN     VARCHAR2,
      I_PROG_TITLE_SYNOPSIS       IN     VARCHAR2,
     -- i_PROG_ser_title            IN     VARCHAR2,
      i_PROG_synopsis_ser         IN     VARCHAR2,
      I_PROG_SYNOPSIS             IN     VARCHAR2,
     -- i_PROG_afr_title_synopsis   IN     VARCHAR2,
     -- i_PROG_afr_synopsis_ser     IN     VARCHAR2,
    --  i_PROG_afr_synopsis         IN     VARCHAR2,*/
      I_PROG_ENTRY_OPER           IN     VARCHAR2,
      o_sucess_flag              OUT    NUMBER);

	PROCEDURE X_PRC_GET_WAVE_HOLDBACK_DATA
	(
		I_GEN_REFNO 	IN  FID_GENERAL.GEN_REFNO%TYPE,
		o_details 		out sys_refcursor
	);

	PROCEDURE X_PRC_SAVE_WAVE_HOLDBACK_DATA
	(
		I_GEN_REFNO 	IN  FID_GENERAL.GEN_REFNO%TYPE,
		I_Wh_number 	IN  X_Waive_Holdback.Wh_number%TYPE,
		I_PLATFORM		IN	SGY_PB_MEDIA_SERVICE.MS_MEDIA_SERVICE_CODE%TYPE,
		I_WINDOW_START	IN	X_Waive_Holdback.Wh_Window_Start%TYPE,
		I_WINDOW_END	IN	X_Waive_Holdback.Wh_Window_End%TYPE,
		I_Comment		IN	X_Waive_Holdback.Wh_Comment%TYPE,
		I_OPERATION		IN	VARCHAR2,
		I_USER			IN	VARCHAR2,
		O_SUCCESS		OUT NUMBER
	);
-- procedure to Save edit list pop-up details for CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]_[start]
  PROCEDURE X_PRC_SAVE_EDIT_LIST_CSTMZTN
	(
		I_tap_barcode 	IN  fid_tape.tap_barcode %TYPE,
		I_gen_refno 	IN  fid_general.gen_refno%TYPE,
		I_SNO           IN  NUMBER,
		is_applied_OtherVersion IN VARCHAR2,
		i_group    IN  x_cont_version.ver_group%TYPE,
                I_elc_id        IN  X_EDIT_LIST_CUSTOMIZATION.elc_id%TYPE,
		I_comments		IN	X_EDIT_LIST_CUSTOMIZATION.elc_Comments%TYPE,
		I_timecode_in	IN	X_EDIT_LIST_CUSTOMIZATION.elc_timecode_in%TYPE,
		I_timecode_out	IN	X_EDIT_LIST_CUSTOMIZATION.elc_timecode_out%TYPE,
		I_duration      IN  X_EDIT_LIST_CUSTOMIZATION.elc_duration%type,
		I_operation     IN  VARCHAR2,
     I_Is_First_Record in varchar2,
		O_SUCCESS		    OUT NUMBER
	);
-- procedure to send mails to PGA users for CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]_[start]
  PROCEDURE  X_PRC_SEND_WORKORDER_EMAIL(i_gen_refno in number,
                                        i_tap_barcode_list varchar2,
                                        i_user_id in varchar2,
                                        O_SUCCESS		    OUT NUMBER

  );
-- procedure to fetch edit list pop-up details for CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]_[start]
   PROCEDURE X_PRC_GET_EDIT_LIST_CSTMZTN
	(
		i_gen_refno     IN  FID_GENERAL.GEN_REFNO%TYPE,
    i_tap_barcode   IN  FID_TAPE.TAP_BARCODE%TYPE,
		o_editlist_details OUT sys_refcursor,
     o_frm_barcode      OUT sys_refcursor
	);

--EPG :[BR_15_352_Miscellaneous Changes Related to EPG]_[Sushma Komulla]_[ 08-06-2016]
Procedure x_prc_insert_synopsis
(
  i_gen_refno    IN  fid_general.gen_refno%type,
  i_sys_id       IN  synopsis_dtls,
  i_sys_lang_id  IN  synopsis_dtls,
  i_sys_ver_name IN  synopsis_dtls_text,
  i_sys_desc     IN  synopsis_dtls_text,
  i_is_ser       IN  varchar2,
  i_syt_id       IN  synopsis_dtls,
  i_entry_oper   IN  varchar2,
  O_status       OUT NUMBER
);

Procedure x_prc_get_syn_details
(
  i_gen_refno    IN  fid_general.gen_refno%type,
  i_cpy_frm_linear  IN  varchar2,
  O_title_syn    OUT sys_refcursor,
  O_season_syn    OUT sys_refcursor,
  O_series_syn    OUT sys_refcursor
);
Procedure x_prc_get_update_dtls
(
  i_gen_refno       IN   fid_general.gen_refno%type,
  o_synopsi_dtls    OUT  sys_refcursor,
  o_vod_dtls        OUT  sys_refcursor,
  o_vod_title_syn   OUT  sys_refcursor,
  o_vod_season_syn  OUT  sys_refcursor,
  o_vod_ser_syn     OUT  sys_refcursor
);
--EPG :END
END pkg_mm_mnet_pl_prgmaintenance;
/


CREATE OR REPLACE PACKAGE BODY         PKG_MM_MNET_PL_PRGMAINTENANCE
AS                                                           --PCK_MM_MNET_PL_
   PROCEDURE pck_mm_mnet_pl_insertprogram (
      -- I_GEN_DURATION  IN FID_GENERAL.GEN_DURATION%TYPE,
      i_gen_title                      IN     fid_general.gen_title%TYPE,
      i_gen_title_working              IN     fid_general.gen_title_working%TYPE,
      -- Add by
      /*
      DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
      Parameters
      i_gen_sub_title           IN       fid_general.gen_sub_title%TYPE,
      i_gen_music_title         IN       fid_general.gen_music_title%TYPE,
      i_gen_poem_title          IN       fid_general.gen_poem_title%TYPE,
      i_gen_web_title           IN       fid_general.GEN_WEB_TITLE%TYPE,
      i_gen_stu_code            IN       fid_general.gen_stu_code%TYPE,
      i_gen_colour              IN       fid_general.gen_colour%TYPE,
      i_gen_code                IN       fid_general.gen_code%TYPE,
      5 check boxes
      i_gen_widescreen          IN       fid_general.gen_widescreen%TYPE,
      i_gen_cat_complete        IN       fid_general.gen_cat_complete%TYPE,
      i_gen_nfa_copy            IN       fid_general.gen_nfa_copy%TYPE,
      i_gen_tx_digitized        IN       fid_general.gen_tx_digitized%TYPE,
      i_gen_archive             IN       fid_general.gen_archive%TYPE,
      Live tab
      i_fgl_venue               IN       fid_gen_live.fgl_venue%TYPE,
      i_fgl_location            IN       fid_gen_live.fgl_location%TYPE,
      i_fgl_live_date           IN       fid_gen_live.fgl_live_date%TYPE,
      In Add info Tab
      i_gen_copy_restrictions   IN       fid_general.gen_copy_restrictions%TYPE,
      i_gen_abstract            IN       fid_general.gen_abstract%TYPE,
      DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
      */
      i_gen_category                   IN     fid_general.gen_category%TYPE,
      i_gen_rating_mpaa                IN     fid_general.gen_rating_mpaa%TYPE,
      i_gen_subgenre                   IN     fid_general.gen_subgenre%TYPE,
      i_gen_rating_int                 IN     fid_general.gen_rating_int%TYPE,
      i_gen_quality                    IN     fid_general.gen_quality%TYPE,
      i_gen_series                     IN     fid_general.gen_series%TYPE,
      i_gen_spoken_lang                IN     fid_general.gen_sub_title%TYPE,
      i_gen_type                       IN     fid_general.gen_type%TYPE,
      i_gen_release_year               IN     fid_general.gen_release_year%TYPE,
      i_gen_nationality                IN     fid_general.gen_nationality%TYPE,
      i_gen_duration_c                 IN     fid_general.gen_duration_c%TYPE,
      i_gen_duration_s                 IN     fid_general.gen_duration_s%TYPE,
      --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
      I_GEN_DURATION_PGA               IN     fid_general.GEN_PGA_DURATION%TYPE,
      --DEV.R4:Inventory Mining:End
      i_gen_epi_number                 IN     fid_general.gen_epi_number%TYPE,
      i_gen_award                      IN     fid_general.gen_award%TYPE,
      i_gen_target_group               IN     fid_general.gen_target_group%TYPE,
      -- Prod.Support : SVOD : Start : [Devashish Raverkar]_[2015-03-20]
      i_gen_sec_target_group           IN     fid_general.gen_sec_target_group%TYPE,
      -- Prod.Support : SVOD : End
      --Catch and PB CR[SCH 32][Mangesh Gulhane][13-AUG-13][Added column for AFR writeoff]
      i_gen_is_afr_writeoff            IN     fid_general.gen_is_afr_writeoff%TYPE,
      i_gen_is_day_time_rest           IN     fid_general.gen_is_day_time_rest%TYPE,
      --Catch and PB CR END
      i_flag_metadata_verified         IN     fid_general.gen_metadata_verified%TYPE,
      -- #region Abhinay_230512014 : New Field Metadata Verified
      i_gen_comment                    IN     fid_general.gen_comment%TYPE,
      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :i_supp_short_name removed for -Restricting creation of duplicate Titles on Programme Maintenance */
      i_gen_re_tx_warning              IN     fid_general.gen_re_tx_warning%TYPE,
      --kunal : START 02-03-2015 Production Number
      i_gen_production_number          IN     fid_general.gen_production_number%TYPE,
      --kunal : END Production Number
     ---  START: EPG Phase 1 : [11-06-2016] : [SUSHMA K]
     --commented below input parameters
      /*i_syn_syt_id_local               IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_syt_id_full                IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsis_full              IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsis_local             IN     fid_synopsis.syn_synopsis%TYPE,
      --**************TVOD-Added********************************
      i_syn_synopsisid_web             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_web        IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsisid_mob             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_mob        IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsisid_epg             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_epg        IN     fid_synopsis.syn_synopsis%TYPE,
      --**************TVOD-END***********************************
      --Added by Pravin_20130111 - Supplier synopsis
      i_syn_synopsisid_supplier        IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_supplier   IN     fid_synopsis.syn_synopsis%TYPE,*/
      --Pravin -End
       ---  END: EPG Phase 1
      i_tap_title                      IN     fid_tape.tap_title%TYPE,
      i_tap_type                       IN     fid_tape.tap_type%TYPE,
      i_tap_format                     IN     fid_tape.tap_format%TYPE,
      i_tap_barcode                    IN     fid_tape.tap_barcode%TYPE,
      i_entry_oper                     IN     fid_general.gen_entry_oper%TYPE,
      --**************Bioscope-Added********************************
      i_imdb_rating                    IN     NUMBER,
      i_ar_rating                      IN     VARCHAR2,
      i_expert_rating                  IN     VARCHAR2,
      i_bo_category                    IN     VARCHAR2,
      i_usd_revenue                    IN     NUMBER,
      i_zar_revenue                    IN     NUMBER,
      i_final_grade                    IN     VARCHAR2,
      i_gen_prog_category_code         IN     VARCHAR2,
      i_gen_catchup_category           IN     VARCHAR2, -- Added by Rashmi for catchu Cr
      i_gen_catchup_priority           IN     VARCHAR2, --Added By rashmi for catchup Cr
      i_gen_tertiary_genre             IN     VARCHAR2,
      i_web_title                      IN     fid_general.gen_web_title%TYPE,
      --**************Bioscop-END***********************************
      ----Added for web title ------------------------------------------
      --START: PROJECT BIOSCOPE ? PENDING CR?S: 20121003
      -- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
      i_gen_mood                       IN     fid_general.gen_mood%TYPE,
      i_gen_link_poster_art            IN     fid_general.gen_link_poster_art%TYPE,
      -- Add by
      --DEV4: Programme Acceptance (Release 12) : Start :  : <17-06-2013> : <Refer PGA01 document>
      i_gen_tags                       IN     fid_general.gen_tags%TYPE,
      i_gen_africa_type_duration_c     IN     fid_general.gen_africa_type_duration_c%TYPE,
      i_gen_africa_type_duration_s     IN     fid_general.gen_africa_type_duration_s%TYPE -- i_GEN_AFRICA_TYPE_DURATION    IN  fid_general.GEN_AFRICA_TYPE_DURATION%TYPE,
                                                                                         ,
      i_report_name                    IN     x_movie_content_report.mcr_report_name%TYPE,
      i_copy                           IN     x_movie_content_report.mcr_copy%TYPE,
      i_pfb_rating                     IN     x_movie_content_report.mcr_fpb_rating%TYPE,
      i_themes                         IN     x_movie_content_report.mcr_themes%TYPE,
      i_bad_language                   IN     x_movie_content_report.mcr_bad_language%TYPE,
      i_violence                       IN     x_movie_content_report.mcr_violence%TYPE,
      i_horror                         IN     x_movie_content_report.mcr_horror_suspence%TYPE,
      i_sex                            IN     x_movie_content_report.mcr_sex%TYPE,
      i_drugs                          IN     x_movie_content_report.mcr_drugs%TYPE,
      i_prejudice                      IN     x_movie_content_report.mcr_prejudice%TYPE,
      i_correctives                    IN     x_movie_content_report.mcr_correctives%TYPE,
      i_any_special_warnings           IN     x_movie_content_report.mcr_any_special_warnings%TYPE,
      i_summary_reasons                IN     x_movie_content_report.mcr_reasons_for_recoomended%TYPE,
      i_validation                     IN     VARCHAR2,
      i_nudity                         IN     x_movie_content_report.mcr_nudity%TYPE,
      i_mcr_location                   IN     x_movie_content_report.mcr_location%TYPE,
      i_mcr_afrc_reg_rating            IN     x_movie_content_report.mcr_afrc_reg_rating%TYPE,
      i_mcr_date_received              IN     x_movie_content_report.mcr_date_received%TYPE,
      i_mcr_date_viewed                IN     x_movie_content_report.mcr_date_viewed%TYPE,
      i_buyer_feedback                 IN     x_movie_content_report.mcr_buyer_feedback%TYPE,
      i_mcr_synopsis                   IN     x_movie_content_report.mcr_synopsis%TYPE,
      i_watershed_restriction          IN     x_movie_content_report.mcr_watershed_restriction%TYPE,
      i_sub_title_language             IN     x_movie_content_report.mcr_sub_title_language%TYPE,
      i_mcr_programe_type              IN     x_movie_content_report.mcr_programe_type%TYPE,
      i_mcr_year_of_production         IN     x_movie_content_report.mcr_year_of_production%TYPE,
      i_mcr_language                   IN     x_movie_content_report.mcr_programe_type%TYPE,
      i_mcr_distributor                IN     x_movie_content_report.mcr_language%TYPE,
      i_mcr_primary_genre              IN     x_movie_content_report.mcr_primary_genre%TYPE,
      i_mcr_cast                       IN     x_movie_content_report.mcr_cast%TYPE,
      i_mcr_director                   IN     x_movie_content_report.mcr_director%TYPE,
      i_mcr_producer                   IN     x_movie_content_report.mcr_producer%TYPE,
      i_mcr_dom_age_restrictions       IN     x_movie_content_report.mcr_dom_age_restrictions%TYPE,
      i_mcr_afr_age_restrictions       IN     x_movie_content_report.mcr_afr_age_restrictions%TYPE,
      i_mcr_tx_date                    IN     x_movie_content_report.mcr_tx_date%TYPE,
      i_mcr_africa_tx                  IN     x_movie_content_report.mcr_africa_tx%TYPE,
      i_mcr_target_audience            IN     x_movie_content_report.mcr_target_audience%TYPE,
      --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
      i_aka_title                      IN     fid_general.gen_aka_title%TYPE,
      i_gen_SVOD_Express               IN     FID_GENERAL.GEN_SVOD_EXPRESS%TYPE,--bhagyashri
      /* Svod rights by Vikas Srivastava*/
      i_gen_SVOD_Rights                 IN    fid_general.GEN_SVOD_RIGHTS%TYPE,
      i_gen_express                     IN    fid_general.GEN_EXPRESS%TYPE,
       i_gen_catalogue                   IN    fid_general.GEN_CATALOGUE%TYPE,
       i_cnt_release_uid                IN     FID_GENERAL.GEN_CNT_RELEASE_UID%TYPE,--Added by Zeshan for 10Digit UID CR
      /*END Svod rights */
       /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
      I_AITW_CHA_NUMBER                IN   x_pkg_common_var.number_array,
      I_AITW_IS_DAY_TIME               IN   x_pkg_common_var.varchar_array,
      I_AITW_START_TIME                IN   x_pkg_common_var.varchar_array,
      I_AITW_END_TIME                  IN   x_pkg_common_var.varchar_array,
      I_AITW_CHANGE_STATUS             IN   x_pkg_common_var.varchar_array,
      I_CAT_START_TIME                 IN   x_pkg_common_var.varchar_array,
      I_CAT_END_TIME                   IN   x_pkg_common_var.varchar_array,
      I_AITW_PRG_N_SCH_CHANNEL         IN   FID_GENERAL.GEN_PRG_N_SCH_CHANNEL%TYPE,
      I_GEN_SCH_ARF_CUSTM              IN   FID_GENERAL.GEN_SCH_ARF_CUSTM%TYPE,
      I_GEN_TAP_SEQ_NO                 IN   FID_GENERAL.GEN_TAP_SEQ_NO%TYPE,
      I_GEN_ADDINFO_COMMENTS           IN   FID_GENERAL.GEN_ADDINFO_COMMENTS%TYPE,
      /*END :Scheduling CR Implementation [ANKUR KASAR]*/
      I_GEN_TVOD_BO_CATEGORY_CODE       IN     fid_general.GEN_TVOD_BO_CATEGORY_CODE%type, --Added by sushma

      o_rpt_id                         OUT x_movie_content_report.mcr_report_id%TYPE -- DEV4: Programme Acceptance (Release 12) : End :  : <17-06-2013 >
                                       --END: PROJECT BIOSCOPE ? PENDING CR?S:
      ,
      o_gen_refno                      OUT fid_general.gen_refno%TYPE,
      o_gen_tx_warnning                OUT FID_GENERAL.GEN_RE_TX_WARNING%TYPE/*Scheduling CRs Implementation [ANKUR KASAR]*/
      )
   AS
      l_genrefno        NUMBER;
      l_tapnumber       NUMBER;
      l_pronumber       NUMBER;
      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :l_comnumber removed for -Restricting creation of duplicate Titles on Programme Maintenance */
      --Add by PGA to get unique report id from  Sequence
      l_mcr_report_id   NUMBER;
      --MANDATORYVALUES EXCEPTION;
      --Added by Nishant
      l_title_count     NUMBER;
      -- changes for media 24 start
          l_content x_fin_configs.content%type;
      -- changes for media 24 end
      /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[20-09-2016]*/
      l_str              VARCHAR2(4000);
      l_gen_txt_warnning VARCHAR2(4000) := null;
      l_count            NUMBER:=0;
      NOT_SUTABLE_REGION EXCEPTION;
      WATERSHED_TIME_IS_NOT_DEFINE  EXCEPTION;
      L_CHA_NUMBER        NUMBER;
      L_START_TIME        NUMBER;
      L_END_TIME          NUMBER;
      L_CAT_START_TIME    NUMBER;
      L_CAT_END_TIME      NUMBER;
      L_TX_WARNNING       VARCHAR2(4000);
      L_CHANNEL_NOT_SCH   VARCHAR2(1024);
      L_CHA_NO            VARCHAR2(1024);
      L_ARF_CUSTM         VARCHAR2(1024);
      L_SEQ_NO            VARCHAR2(1024);
      L_CNT               NUMBER;
      /*Dev.R1: Scheduling CR Implementation: END:*/
   BEGIN
      --- Start - Validate title with supplier and release year exists - nishant ankam
      l_title_count := 0;

      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */

      IF (x_fnc_get_prog_type (i_gen_type) = 'N')
      THEN
         SELECT COUNT (*)
           INTO l_title_count
           FROM fid_general
          WHERE     UPPER (gen_title) = UPPER (i_gen_title)
                /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */
                AND gen_release_year = i_gen_release_year
                AND UPPER (gen_type) = UPPER (i_gen_type);
      ELSE
         SELECT COUNT (*)
           INTO l_title_count
           FROM fid_series
          WHERE UPPER (ser_title) = UPPER (i_gen_title) /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */
                                                       AND ser_release_year = i_gen_release_year;
      END IF;

      IF l_title_count > 0
      THEN
         raise_application_error (-20100, 'Can not create duplicate titles.');
      END IF;

      ---End - Validate title with supplier and release year exists - nishant ankam
       -- Synergy Vanilla:Start [Nasreen Mulla]
         select content into l_content from
         x_fin_configs where key = 'COMPANY_ID';
        -- Synergy Vanilla:End
      IF l_content = 1 then

        SELECT seq_gen_refno.NEXTVAL INTO l_genrefno FROM DUAL;
       -- Synergy Vanilla:Start [Nasreen Mulla]
      ELSE
         SELECT SEQ_GEN_REFNO_M24.NEXTVAL INTO l_genrefno FROM DUAL;
       -- Synergy Vanilla:End
      END IF;
      o_gen_refno := l_genrefno;

      SELECT seq_tap_number.NEXTVAL INTO l_tapnumber FROM DUAL;

      SELECT seq_pro_number.NEXTVAL INTO l_pronumber FROM DUAL;

      --L_GEN_REFNO:=get_seq('SEQ_GEN_REFNO');
      ----DBMS_OUTPUT.PUT_LINE(L_GENREFNO);
      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */

      IF (i_gen_title IS NOT NULL AND i_gen_type IS NOT NULL --AND i_gen_stu_code IS NOT NULL
                                              --AND i_gen_category IS NOT NULL
         )
      THEN
         BEGIN
            INSERT INTO fid_general (                                -- Add by
                                     /*
                                     DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
                                     Colums
                                     , gen_stu_code
                                     , gen_colour
                                     , gen_code
                                     , gen_widescreen
                                     , gen_sub_title
                                     , gen_music_title
                                     , gen_poem_title
                                     , gen_copy_restrictions
                                     , gen_abstract
                                     , gen_nfa_copy
                                     , gen_cat_complete
                                     , gen_tx_digitized
                                     , gen_archive
                                     , gen_web_title
                                     DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
                                     */
                                     gen_refno,
                                     gen_title,
                                     gen_type,
                                     gen_category,
                                     gen_release_year,
                                     gen_nationality,
                                     gen_rating_mpaa,
                                     gen_rating_int,
                                     gen_quality,
                                     gen_duration_c,
                                     gen_duration_s,
                                     gen_series,
                                     gen_award,
                                     gen_comment,
                                     gen_epi_number,
                                     gen_title_working,
                                     gen_subgenre,
                                     /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */
                                     gen_spoken_lang,
                                     gen_target_group,
                                     -- Prod.Support : SVOD : Start : [Devashish Raverkar]_[2015-03-20]
                                     gen_sec_target_group,
                                     -- Prod.Support : SVOD : End
                                     gen_re_tx_warning,
                                     gen_entry_oper,
                                     gen_entry_date,
                                     gen_duration,
                                     gen_rating_imdb,
                                     gen_rating_ar,
                                     gen_rating_expert_meta_critic,
                                     gen_bo_category_code,
                                     gen_bo_revenue_usd,
                                     gen_bo_revenue_zar,
                                     gen_final_grade,
                                     gen_prog_category_code,
                                     gen_catchup_category, -- Added by Rashmi for catchup Cr
                                     gen_catchup_priority, -- Added by Rashmi for catchu cr
                                     gen_tertiary_genre,
                                     gen_web_title,
                                     gen_mood,
                                     gen_link_poster_art,
                                     gen_tags,
                                     gen_africa_type_duration_c,
                                     gen_africa_type_duration_s,
                                     gen_africa_type_duration,
                                     gen_is_afr_writeoff,
                                     gen_is_day_time_rest,
                                     gen_metadata_verified --#region Abhinay_230512014 : New Field Metadata Verified
                                                          --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
                                     ,
                                     gen_aka_title --kunal : START 02-03-2015 Production Number
                                                  ,
                                     gen_production_number --kunal : END Production Number
 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
                                     ,
                                     GEN_PGA_DURATION --DEV.R4:Inventory Mining:End
                                     ,GEN_SVOD_EXPRESS --bhagyashri
                                     ,gen_svod_rights  --rdt svod rights vikas Srivastava
                                     ,gen_express
                                     ,gen_embargo_content
                                     ,gen_catalogue    -- end svod rights vikas Srivastava
                                     ,GEN_CNT_RELEASE_UID   --Added by Zeshan for 10Digit UID CR
                                     ,GEN_TVOD_BO_CATEGORY_CODE
                                     /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
                                     ,GEN_SCH_ARF_CUSTM
                                     ,GEN_TAP_SEQ_NO
                                     ,GEN_ADDINFO_COMMENTS
                                     ,GEN_PRG_N_SCH_CHANNEL
                                     /*Dev.R1: Scheduling CR Implementation: END:*/
                                                     )
                 VALUES (
                           l_genrefno,
                           i_gen_title,
                           i_gen_type                                -- Add by
                                     /*
                                     DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
                                     , NVL (i_gen_stu_code, '-')
                                     , substr(i_gen_colour,1,2)
                                     , i_gen_code
                                     , i_gen_widescreen
                                     , i_gen_sub_title
                                     , i_gen_music_title
                                     , i_gen_poem_title
                                     , i_gen_copy_restrictions
                                     , i_gen_abstract
                                     , i_gen_nfa_copy
                                     , i_gen_cat_complete
                                     , i_gen_tx_digitized
                                     , i_gen_archive
                                     , i_gen_web_title
                                     DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
                                     */
                           ,
                           NVL (i_gen_category, '-'),
                           i_gen_release_year,
                           i_gen_nationality,
                           i_gen_rating_mpaa,
                           i_gen_rating_int,
                           i_gen_quality,
                           i_gen_duration_c,
                           i_gen_duration_s,
                           i_gen_series,
                           i_gen_award,
                           i_gen_comment,
                           i_gen_epi_number,
                           i_gen_title_working,
                           i_gen_subgenre,
                           /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */
                           i_gen_spoken_lang,
                           i_gen_target_group,
                           -- Prod.Support : SVOD : Start : [Devashish Raverkar]_[2015-03-20]
                           i_gen_sec_target_group,
                           -- Prod.Support : SVOD : End
                           i_gen_re_tx_warning,
                           i_entry_oper,
                           SYSDATE,
                           (  (SUBSTR (i_gen_duration_c, 1, 2) * 90000)
                            + (SUBSTR (i_gen_duration_c, 4, 2) * 1500)
                            + (SUBSTR (i_gen_duration_c, 7, 2) * 25)),
                           i_imdb_rating,
                           i_ar_rating,
                           i_expert_rating,
                           i_bo_category,
                           i_usd_revenue,
                           i_zar_revenue,
                           i_final_grade,
                           i_gen_prog_category_code,
                           i_gen_catchup_category, -- Added by Rashmi for catchup Cr
                           i_gen_catchup_priority, -- Added by Rashmi for catchup Cr
                           i_gen_tertiary_genre,
                           i_web_title --START: PROJECT BIOSCOPE ? PENDING CR?S: Mangesh Gulhane_20121003
                                      -- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
                           ,
                           i_gen_mood,
                           i_gen_link_poster_art,
                           i_gen_tags,
                           i_gen_africa_type_duration_c,
                           i_gen_africa_type_duration_s,
                           (  (SUBSTR (i_gen_duration_c, 1, 2) * 90000)
                            + (SUBSTR (i_gen_duration_c, 4, 2) * 1500)
                            + (SUBSTR (i_gen_duration_c, 7, 2) * 25)) --END: PROJECT BIOSCOPE ? PENDING CR?S:
                                                                     ,
                           --Catch and PB CR[SCH 32][Mangesh Gulhane][13-AUG-13][Added column for AFR writeoff]
                           i_gen_is_afr_writeoff,
                           i_gen_is_day_time_rest        --Catch and PB CR END
                                                 ,
                           NVL (i_flag_metadata_verified, 'N') --#region Abhinay_230512014 : New Field Metadata Verified
                                                              --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
                           ,
                           i_aka_title --kunal : START 02-03-2015 Production Number
                                      ,
                           i_gen_production_number --kunal : END Production Number
 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
                           ,
                           I_GEN_DURATION_PGA    --DEV.R4:Inventory Mining:End
                          ,i_gen_SVOD_Express    --bhagyashri
                          ,i_gen_SVOD_Rights    -- added by vikas Srivastava
                          ,i_gen_express
                          ,decode(i_gen_express,'Y','Y','N')
                          ,i_gen_catalogue
                          ,i_cnt_release_uid    --Added by Zeshan for 10Digit UID CR
                          ,i_GEN_TVOD_BO_CATEGORY_CODE
                          /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
                          ,I_GEN_SCH_ARF_CUSTM
                          ,I_GEN_TAP_SEQ_NO
                          ,I_GEN_ADDINFO_COMMENTS
                          ,I_AITW_PRG_N_SCH_CHANNEL
                          /*Dev.R1: Scheduling CR Implementation: END:*/
                          );
         /* EXCEPTION
         WHEN others
         then
         if sqlcode = -1
         then
         raise_application_error(-20100,'The record already exists.');
         else
         raise_application_error(-20101,'An error occurred. Please contact your administrator with the following message : '||sqlerrm);
         end if; */
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20108, SQLERRM);
         END;
      END IF;

     ---  START: EPG Phase 1 : [11-06-2016] : [SUSHMA K]
     --commented below code
    /*  IF (i_syn_syt_id_local = 1)
      THEN
         INSERT INTO fid_synopsis (syn_gen_refno,
                                   syn_syt_id,
                                   syn_synopsis,
                                   syn_entry_oper,
                                   syn_entry_date,
                                   SYN_ID)
              VALUES (l_genrefno,
                      i_syn_syt_id_local,
                      i_syn_synopsis_local,
                      i_entry_oper,
                      SYSDATE,
                      x_seq_syn_id.nextval
                    );
      END IF;

      IF (i_syn_syt_id_full = 2)
      THEN
         INSERT INTO fid_synopsis (syn_gen_refno,
                                   syn_syt_id,
                                   syn_synopsis,
                                   syn_entry_oper,
                                   syn_entry_date,
                                   SYN_ID)
              VALUES (l_genrefno,
                      i_syn_syt_id_full,
                      i_syn_synopsis_full,
                      i_entry_oper,
                      SYSDATE,
                      x_seq_syn_id.nextval);
      END IF;

      --**************************TVOD-Added***************************************
      IF (i_syn_synopsisid_web = 3)
      THEN
         INSERT INTO fid_synopsis (syn_gen_refno,
                                   syn_syt_id,
                                   syn_synopsis,
                                   syn_entry_oper,
                                   syn_entry_date,
                                   syn_id)
              VALUES (l_genrefno,
                      i_syn_synopsisid_web,
                      i_syn_synopsisdetails_web,
                      USER,
                      SYSDATE,
                       x_seq_syn_id.nextval);
      END IF;

      IF (i_syn_synopsisid_mob = 4)
      THEN
         INSERT INTO fid_synopsis (syn_gen_refno,
                                   syn_syt_id,
                                   syn_synopsis,
                                   syn_entry_oper,
                                   syn_entry_date,
                                   syn_id)
              VALUES (l_genrefno,
                      i_syn_synopsisid_mob,
                      i_syn_synopsisdetails_mob,
                      USER,
                      SYSDATE,
                       x_seq_syn_id.nextval);
      END IF;

      IF (i_syn_synopsisid_epg = 5)
      THEN
         INSERT INTO fid_synopsis (syn_gen_refno,
                                   syn_syt_id,
                                   syn_synopsis,
                                   syn_entry_oper,
                                   syn_entry_date,
                                   syn_id)
              VALUES (l_genrefno,
                      i_syn_synopsisid_epg,
                      i_syn_synopsisdetails_epg,
                      USER,
                      SYSDATE,
                       x_seq_syn_id.nextval);
      END IF;

      --**************************TVOD-END***************************************
      --Added by Pravin_20130111 -Supplier synopsis
      IF (i_syn_synopsisid_supplier = 6)
      THEN
         INSERT INTO fid_synopsis (syn_gen_refno,
                                   syn_syt_id,
                                   syn_synopsis,
                                   syn_entry_oper,
                                   syn_entry_date,
                                   syn_id)
              VALUES (l_genrefno,
                      i_syn_synopsisid_supplier,
                      i_syn_synopsisdetails_supplier,
                      USER,
                      SYSDATE,
                       x_seq_syn_id.nextval);
      END IF;*/
   --END : EPG Phase 1:

      --End - Pravin_20130111
      INSERT
        INTO fid_gen_live (                                          -- Add by
                           /*
                           DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
                           Columns
                           , fgl_venue
                           , fgl_location
                           , fgl_live_date
                           , fgl_time
                           DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
                           */
                           fgl_gen_refno, fgl_entry_oper, fgl_entry_date)
      VALUES (                                                       -- Add by
              /*
              DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
              , i_fgl_venue
              , i_fgl_location
              , i_fgl_live_date
              , i_fgl_time
              DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
              */
              l_genrefno, i_entry_oper, SYSDATE);

      /*
      INSERT INTO fid_production
      (pro_gen_refno ,  pro_title
      ,pro_number ,  fid_production.pro_status
      ,pro_entry_date   ,  pro_entry_oper
      )
      VALUES
      (l_genrefno ,  i_gen_title
      ,l_pronumber   ,  'N'
      ,SYSDATE ,  USER
      );
      */
      IF (    i_tap_title IS NOT NULL
          AND i_tap_format IS NOT NULL
          AND i_tap_type IS NOT NULL)
      THEN
         INSERT INTO fid_tape (tap_number,
                               tap_title,
                               tap_type,
                               tap_format,
                               tap_barcode,
                               tap_pro_number,
                               tap_entry_date,
                               tap_entry_oper)
              VALUES (l_tapnumber,
                      i_tap_title,
                      i_tap_format,
                      i_tap_type,
                      i_tap_barcode,
                      l_pronumber,
                      SYSDATE,
                      i_entry_oper);
      END IF;

      -- Add by
      /*
      DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
      */
      o_rpt_id := 0;

      IF (i_validation = 'add')
      THEN
         BEGIN
            l_mcr_report_id := x_seq_mcr_report_id.NEXTVAL;

            INSERT INTO x_movie_content_report (mcr_report_id,
                                                mcr_report_gen_ref_no,
                                                mcr_report_name,
                                                mcr_copy,
                                                mcr_fpb_rating,
                                                mcr_themes,
                                                mcr_violence,
                                                mcr_bad_language,
                                                mcr_created_by,
                                                mcr_created_date,
                                                mcr_update_count,
                                                mcr_horror_suspence,
                                                mcr_sex,
                                                mcr_nudity,
                                                mcr_drugs,
                                                mcr_prejudice,
                                                mcr_correctives,
                                                mcr_any_special_warnings,
                                                mcr_reasons_for_recoomended,
                                                mcr_location,
                                                mcr_afrc_reg_rating,
                                                mcr_date_received,
                                                mcr_date_viewed,
                                                mcr_buyer_feedback,
                                                mcr_synopsis,
                                                mcr_watershed_restriction,
                                                mcr_sub_title_language,
                                                mcr_programe_type,
                                                mcr_year_of_production,
                                                mcr_language,
                                                mcr_distributor,
                                                mcr_primary_genre,
                                                mcr_cast,
                                                mcr_director,
                                                mcr_producer,
                                                mcr_dom_age_restrictions,
                                                mcr_afr_age_restrictions,
                                                mcr_tx_date,
                                                mcr_africa_tx,
                                                mcr_target_audience)
                 VALUES (l_mcr_report_id,
                         l_genrefno,
                         i_report_name,
                         i_copy,
                         i_pfb_rating,
                         i_themes,
                         i_violence,
                         i_bad_language,
                         i_entry_oper,
                         SYSDATE,
                         0,
                         i_horror,
                         i_sex,
                         i_nudity,
                         i_drugs,
                         i_prejudice,
                         i_correctives,
                         i_any_special_warnings,
                         i_summary_reasons,
                         i_mcr_location,
                         i_mcr_afrc_reg_rating,
                         i_mcr_date_received,
                         i_mcr_date_viewed,
                         i_buyer_feedback,
                         i_mcr_synopsis,
                         i_watershed_restriction,
                         i_sub_title_language,
                         i_mcr_programe_type,
                         i_mcr_year_of_production,
                         i_mcr_language,
                         i_mcr_distributor,
                         i_mcr_primary_genre,
                         i_mcr_cast,
                         i_mcr_director,
                         i_mcr_producer,
                         i_mcr_dom_age_restrictions,
                         i_mcr_afr_age_restrictions,
                         i_mcr_tx_date,
                         i_mcr_africa_tx,
                         i_mcr_target_audience);

            COMMIT;
            o_rpt_id := l_mcr_report_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_rpt_id := 0;
               raise_application_error (-20108, SQLERRM);
         END;
      END IF;

      /*
      DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
      */
      COMMIT;

 /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
     IF (i_gen_title IS NOT NULL AND i_gen_type IS NOT NULL) --AND i_gen_stu_code IS NOT NULL                                       --AND i_gen_category IS NOT NULL
      THEN
        IF I_AITW_CHA_NUMBER(1) IS NULL AND I_AITW_IS_DAY_TIME(1) IS NULL AND I_AITW_START_TIME(1) IS NULL AND I_AITW_END_TIME(1) IS NULL AND I_AITW_CHANGE_STATUS(1) IS NULL
        THEN
          NULL;
        ELSE

          BEGIN
             FOR i IN 1.. I_AITW_CHA_NUMBER.COUNT
          LOOP
            --CHEKING DAY_TIME CHECKBOX IS CHECKED OR NOT
               BEGIN
                IF I_AITW_IS_DAY_TIME(i) = 'Y'
                 THEN
                    L_START_TIME := NULL;
                    L_END_TIME   := NULL;
                    L_CAT_START_TIME :=NULL;
                    L_CAT_END_TIME :=NULL;
                 ELSE
                    L_START_TIME := CONVERT_TIME_C_N(I_AITW_START_TIME(i)) ;
                    L_END_TIME   := CONVERT_TIME_C_N(I_AITW_END_TIME(i)) ;
                    L_CAT_START_TIME := CONVERT_TIME_C_N(I_CAT_START_TIME(i)) ;
                    L_CAT_END_TIME := CONVERT_TIME_C_N(I_CAT_END_TIME(i)) ;
                END IF;
              EXCEPTION
                WHEN NO_DATA_FOUND
                  THEN
                    RAISE NOT_SUTABLE_REGION;
              END;
            --INSERTING DATA FROM ADD_INFO TAB WITH MULTIPLE VALUES
               insert into X_ADD_INFO_TX_WARNNING
                    (
                        AITW_NUMBER
                       ,AITW_GEN_REFNO
                       ,AITW_CHA_NUMBER
                       ,AITW_IS_DAY_TIME
                       ,AITW_START_TIME
                       ,AITW_END_TIME
                       ,AITW_CAT_START_TIME
                       ,AITW_CAT_END_TIME
                       ,AITW_OPRAT_FLAG
                       ,AITW_CREATED_ON
                       ,AITW_CREATED_BY
                    )
                    values
                    (
                         X_SEQ_AITW_NUMBER.NEXTVAL
                        ,l_genrefno
                        ,I_AITW_CHA_NUMBER(I)
                        ,I_AITW_IS_DAY_TIME(i)
                        ,L_START_TIME
                        ,L_END_TIME
                        ,L_CAT_START_TIME
                        ,L_CAT_END_TIME
                        ,I_AITW_CHANGE_STATUS(i)
                        ,SYSDATE
                        ,i_entry_oper

                    );

           END LOOP;
           END;

        END IF;
      END IF;

     BEGIN
        update fid_general set GEN_RE_TX_WARNING_Add_info = l_gen_txt_warnning where GEN_REFNO = l_genrefno;
     EXCEPTION
      WHEN OTHERS
       THEN
        raise_application_error (-20108, SQLERRM);
     END;
        BEGIN
          FOR i IN
          (
              SELECT GEN_PRG_N_SCH_CHANNEL,GEN_SCH_ARF_CUSTM,GEN_TAP_SEQ_NO,GEN_ADDINFO_COMMENTS
              FROM fid_general
              WHERE gen_REfno = l_genrefno
          )
          LOOP
              IF i.gen_prg_n_sch_channel IS NOT NULL
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Programme not suitable for broadcast in '||i.gen_prg_n_sch_channel||',';
              END IF;

              IF i.GEN_SCH_ARF_CUSTM IS NOT NULL
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule Africa Customization is '||i.GEN_SCH_ARF_CUSTM||',';
              END IF;

              IF i.GEN_TAP_SEQ_NO IS NOT NULL
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Please schedule associated slide '||i.GEN_TAP_SEQ_NO||',';
              END IF;

              IF i.GEN_ADDINFO_COMMENTS IS NOT NULL
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Comments : '||i.GEN_ADDINFO_COMMENTS||',';
              END IF;
          END LOOP;

          FOR i IN
          (
              SELECT aitw_gen_refno,aitw_cha_number,cha_name,aitw_start_time,aitw_end_Time,aitw_is_Day_time
              FROM x_add_info_tx_warnning,fid_channel
              WHERE aitw_gen_Refno =l_genrefno
                    AND cha_number(+) = aitw_cha_number
          )
          LOOP
              IF i.aitw_cha_number = -1 AND i.aitw_is_Day_time = 'Y'
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule on rest all channels within day time,';
              END IF;

              IF i.aitw_cha_number = -1 AND i.aitw_is_Day_time <> 'Y'
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule on rest all channels on '||convert_time_n_c(i.aitw_start_time)||' and '||convert_time_n_c(i.aitw_end_Time)||',';
              END IF;

              IF i.aitw_cha_number <> -1 AND i.aitw_is_Day_time = 'Y'
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule on '||i.cha_name||' within day time,';
              END IF;

              IF i.aitw_cha_number <> -1 AND i.aitw_is_Day_time <> 'Y'
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule on '||i.cha_name||' '||convert_time_n_c(i.aitw_start_time)||' and '||convert_time_n_c(i.aitw_end_Time)||',';
              END IF;
          END LOOP;
        END;

          BEGIN
             UPDATE fid_general SET GEN_RE_TX_WARNING_add_info = SUBSTR(l_gen_txt_warnning, 1, LENGTH(l_gen_txt_warnning) - 1)
             where GEN_REFNO = l_genrefno;
          EXCEPTION
          WHEN OTHERS
           THEN
              raise_application_error (-20108, SQLERRM);
          END;
          COMMIT;

         BEGIN
            select CASE WHEN
                    GEN_RE_TX_WARNING IS NOT NULL THEN GEN_RE_TX_WARNING||','
                    ELSE
                    GEN_RE_TX_WARNING
                    END ||GEN_RE_TX_WARNING
                    INTO o_gen_tx_warnning  FROM FID_GENERAL WHERE GEN_REFNO = l_genrefno;
         EXCEPTION
         WHEN no_data_found
         THEN
           o_gen_tx_warnning := 'NA';
         END;
       commit;
      /*[End] Scheduling CR Implementation*/
   EXCEPTION
   --OCCURE WHEN CHANNEL TRY TO SCHEDULE OF NOT SUITABLE CHANNEL.
      WHEN NOT_SUTABLE_REGION
        THEN
        rollback;
         raise_application_error
            (-20016,
             'Selected programme cannot be scheduled on '||I_AITW_PRG_N_SCH_CHANNEL||' region.'
            );
       WHEN WATERSHED_TIME_IS_NOT_DEFINE
        THEN
        rollback;
         raise_application_error
            (-20016,'Please define watershed time for program .');
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END pck_mm_mnet_pl_insertprogram;


   PROCEDURE pck_mm_mnet_pl_updateprogram (
      i_gen_title                      IN     fid_general.gen_title%TYPE,
      i_gen_title_working              IN     fid_general.gen_title_working%TYPE,
      -- Add by
      /*
      DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
      i_gen_sub_title           IN       fid_general.gen_sub_title%TYPE,
      i_gen_music_title         IN       fid_general.gen_music_title%TYPE,
      i_gen_poem_title          IN       fid_general.gen_poem_title%TYPE,
      i_gen_stu_code            IN       fid_general.gen_stu_code%TYPE,
      i_gen_colour              IN       fid_general.gen_colour%TYPE,
      i_gen_code                IN       fid_general.gen_code%TYPE,
      ----Added for web title
      i_gen_web_title           IN       fid_general.GEN_WEB_TITLE%TYPE,
      5 check boxes
      i_gen_widescreen          IN       fid_general.gen_widescreen%TYPE,
      i_gen_cat_complete        IN       fid_general.gen_cat_complete%TYPE,
      i_gen_nfa_copy            IN       fid_general.gen_nfa_copy%TYPE,
      i_gen_tx_digitized        IN       fid_general.gen_tx_digitized%TYPE,
      i_gen_archive             IN       fid_general.gen_archive%TYPE,
      Live tab
      --I_FGL_GEN_REFNO in FID_GEN_LIVE.FGL_GEN_REFNO%TYPE,
      i_fgl_venue               IN       fid_gen_live.fgl_venue%TYPE,
      i_fgl_location            IN       fid_gen_live.fgl_location%TYPE,
      i_fgl_live_date           IN       fid_gen_live.fgl_live_date%TYPE,
      i_fgl_time                IN       fid_gen_live.fgl_time%TYPE,
      In Add info Tab
      i_gen_copy_restrictions   IN       fid_general.gen_copy_restrictions%TYPE,
      i_gen_abstract            IN       fid_general.gen_abstract%TYPE,
      DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
      */
      i_gen_category                   IN     fid_general.gen_category%TYPE,
      i_gen_rating_mpaa                IN     fid_general.gen_rating_mpaa%TYPE,
      i_gen_subgenre                   IN     fid_general.gen_subgenre%TYPE,
      i_gen_rating_int                 IN     fid_general.gen_rating_int%TYPE,
      i_gen_quality                    IN     fid_general.gen_quality%TYPE,
      i_gen_series                     IN     fid_general.gen_series%TYPE,
      i_gen_spoken_lang                IN     fid_general.gen_sub_title%TYPE,
      i_gen_refno                      IN     fid_general.gen_refno%TYPE,
      i_gen_parent_refno               IN     fid_general.gen_parent_refno%TYPE,
      i_gen_type                       IN     fid_general.gen_type%TYPE,
      i_gen_release_year               IN     fid_general.gen_release_year%TYPE,
      i_gen_nationality                IN     fid_general.gen_nationality%TYPE,
      i_gen_duration_c                 IN     fid_general.gen_duration_c%TYPE,
      i_gen_duration_s                 IN     fid_general.gen_duration_s%TYPE,
      --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
      I_GEN_DURATION_PGA               IN     fid_general.GEN_PGA_DURATION%TYPE,
      --DEV.R4:Inventory Mining:End
      i_gen_epi_number                 IN     fid_general.gen_epi_number%TYPE,
      i_gen_award                      IN     fid_general.gen_award%TYPE,
      i_gen_target_group               IN     fid_general.gen_target_group%TYPE,
      -- Prod.Support : SVOD : Start : [Devashish Raverkar]_[2015-03-20]
      i_gen_sec_target_group           IN     fid_general.gen_sec_target_group%TYPE,
      -- Prod.Support : SVOD : End
      --Catch and PB CR[SCH 32][Mangesh Gulhane][13-AUG-13][Added column for AFR writeoff]
      i_gen_is_afr_writeoff            IN     fid_general.gen_is_afr_writeoff%TYPE,
      i_gen_is_day_time_rest           IN     fid_general.gen_is_day_time_rest%TYPE,
      --Catch and PB CR END
      i_flag_metadata_verified         IN     fid_general.gen_metadata_verified%TYPE,
      -- #region Abhinay_230512014 : New Field Metadata Verified
      --#region 6March2015: EmbargoContent Save Logic Change
      i_is_embargo                     IN     fid_general.gen_embargo_content%TYPE,
      i_prog_embargo                   IN     fid_general.gen_embargo_content%TYPE,
      --#endregion 6March2015
      I_IS_PROG_CINEMA_EMBARGO         IN     fid_general.gen_is_cinema_embargo_content%TYPE,--Onsite.Dev:BR_15_327
      i_gen_comment                    IN     fid_general.gen_comment%TYPE,
      --I_GEN_SUPPLIER_COM_NUMBER  IN FID_GENERAL.GEN_SUPPLIER_COM_NUMBER%TYPE,
      i_gen_re_tx_warning              IN     fid_general.gen_re_tx_warning%TYPE,
      --kunal : START 02-03-2015 Production Number
      i_gen_production_number          IN     fid_general.gen_production_number%TYPE,
      --kunal : END Production Number
      --I_GEN_TITLE_EPISODE   IN FID_GENERAL.GEN_TITLE_EPISODE%TYPE,
      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :i_supp_short_name removed for -Restricting creation of duplicate Titles on Programme Maintenance */
      --SYN_GEN_REFNO      in FID_SYNOPSIS.SYN_GEN_REFNO%TYPE,
    /*  i_syn_synopsis_local             IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsis_full              IN     fid_synopsis.syn_synopsis%TYPE,
      i_synopsis_id_local              IN     fid_synopsis.syn_syt_id%TYPE,
      i_synopsis_id_full               IN     fid_synopsis.syn_syt_id%TYPE,
      --**************TVOD-Added********************************
      i_syn_synopsisid_web             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_web        IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsisid_mob             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_mob        IN     fid_synopsis.syn_synopsis%TYPE,
      i_syn_synopsisid_epg             IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_epg        IN     fid_synopsis.syn_synopsis%TYPE,
      --**************TVOD-END***********************************
      -- Added by Pravin_20130111- Supplier Synopsis
      i_syn_synopsisid_supplier        IN     fid_synopsis.syn_syt_id%TYPE,
      i_syn_synopsisdetails_supplier   IN     fid_synopsis.syn_synopsis%TYPE,*/
      --End
      -- I_PRO_TITLE    in FID_PRODUCTION.PRO_TITLE%TYPE,
      -- I_PRO_STATUS      in FID_PRODUCTION.PRO_STATUS%TYPE,
      i_tap_title                      IN     fid_tape.tap_title%TYPE,
      i_tap_type                       IN     fid_tape.tap_type%TYPE,
      i_tap_format                     IN     fid_tape.tap_format%TYPE,
      i_tap_barcode                    IN     fid_tape.tap_barcode%TYPE,
      i_entry_oper                     IN     fid_general.gen_entry_oper%TYPE,
      --**************Bioscope-Added********************************
      i_imdb_rating                    IN     NUMBER,
      i_ar_rating                      IN     VARCHAR2,
      i_expert_rating                  IN     VARCHAR2,
      i_bo_category                    IN     VARCHAR2,
      i_usd_revenue                    IN     NUMBER,
      i_zar_revenue                    IN     NUMBER,
      i_final_grade                    IN     VARCHAR2,
      i_gen_prog_category_code         IN     VARCHAR2,
      i_gen_tertiary_genre             IN     VARCHAR2,
      ----Added for web title
      i_web_title                      IN     fid_general.gen_web_title%TYPE,
      --**************Bioscop-END***********************************
      --START: PROJECT BIOSCOPE ? PENDING CR?S: Mangesh Gulhane_20121003
      -- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
      i_gen_mood                       IN     fid_general.gen_mood%TYPE,
      i_gen_link_poster_art            IN     fid_general.gen_link_poster_art%TYPE,
      --END: PROJECT BIOSCOPE ? PENDING CR?S:
      --RDT Start Phoneix req [14-05-2014][Kiran]
      i_attributemodifieddatetime      IN     VARCHAR2,
      --RDT end Phoneix req [14-05-2014][Kiran]
      -- Add by
      --DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
      i_gen_tags                       IN     fid_general.gen_tags%TYPE,
      i_gen_africa_type_duration_c     IN     fid_general.gen_africa_type_duration_c%TYPE,
      i_gen_africa_type_duration_s     IN     fid_general.gen_africa_type_duration_s%TYPE,
      i_gen_update_cnt                 IN     NUMBER,
      i_report_name                    IN     x_movie_content_report.mcr_report_name%TYPE,
      i_copy                           IN     x_movie_content_report.mcr_copy%TYPE,
      i_pfb_rating                     IN     x_movie_content_report.mcr_fpb_rating%TYPE,
      i_themes                         IN     x_movie_content_report.mcr_themes%TYPE,
      i_bad_language                   IN     x_movie_content_report.mcr_bad_language%TYPE,
      i_violence                       IN     x_movie_content_report.mcr_violence%TYPE,
      i_horror                         IN     x_movie_content_report.mcr_horror_suspence%TYPE,
      i_sex                            IN     x_movie_content_report.mcr_sex%TYPE,
      i_drugs                          IN     x_movie_content_report.mcr_drugs%TYPE,
      i_prejudice                      IN     x_movie_content_report.mcr_prejudice%TYPE,
      i_correctives                    IN     x_movie_content_report.mcr_correctives%TYPE,
      i_any_special_warnings           IN     x_movie_content_report.mcr_any_special_warnings%TYPE,
      i_summary_reasons                IN     x_movie_content_report.mcr_reasons_for_recoomended%TYPE,
      i_nudity                         IN     x_movie_content_report.mcr_nudity%TYPE,
      i_validation                     IN     VARCHAR2,
      i_mcr_report_id                  IN     x_movie_content_report.mcr_report_name%TYPE,
      i_mcr_location                   IN     x_movie_content_report.mcr_location%TYPE,
      i_mcr_afrc_reg_rating            IN     x_movie_content_report.mcr_afrc_reg_rating%TYPE,
      i_mcr_date_received              IN     x_movie_content_report.mcr_date_received%TYPE,
      i_mcr_date_viewed                IN     x_movie_content_report.mcr_date_viewed%TYPE,
      i_mcr_buyer_feedback             IN     x_movie_content_report.mcr_buyer_feedback%TYPE,
      i_mcr_synopsis                   IN     x_movie_content_report.mcr_synopsis%TYPE,
      i_mcr_watershed_restriction      IN     x_movie_content_report.mcr_watershed_restriction%TYPE,
      i_mcr_sub_title_language         IN     x_movie_content_report.mcr_sub_title_language%TYPE,
      i_upd_cnt                        IN     x_movie_content_report.mcr_update_count%TYPE,
      o_rid                               OUT NUMBER,
      i_mcr_programe_type              IN     x_movie_content_report.mcr_programe_type%TYPE,
      i_mcr_year_of_production         IN     x_movie_content_report.mcr_year_of_production%TYPE,
      i_mcr_language                   IN     x_movie_content_report.mcr_programe_type%TYPE,
      i_mcr_distributor                IN     x_movie_content_report.mcr_language%TYPE,
      i_mcr_primary_genre              IN     x_movie_content_report.mcr_primary_genre%TYPE,
      i_mcr_cast                       IN     x_movie_content_report.mcr_cast%TYPE,
      i_mcr_director                   IN     x_movie_content_report.mcr_director%TYPE,
      i_mcr_producer                   IN     x_movie_content_report.mcr_producer%TYPE,
      i_mcr_dom_age_restrictions       IN     x_movie_content_report.mcr_dom_age_restrictions%TYPE,
      i_mcr_afr_age_restrictions       IN     x_movie_content_report.mcr_afr_age_restrictions%TYPE,
      i_mcr_tx_date                    IN     x_movie_content_report.mcr_tx_date%TYPE,
      i_mcr_africa_tx                  IN     x_movie_content_report.mcr_africa_tx%TYPE,
      i_mcr_target_audience            IN     x_movie_content_report.mcr_target_audience%TYPE,
      i_season_synopsis                IN     fid_series.ser_synopsis%TYPE,
      i_series_synopsis                IN     fid_series.ser_synopsis%TYPE,
      --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
      i_aka_title                      IN     fid_general.gen_aka_title%TYPE,
      i_gen_catchup_category           IN     fid_general.GEN_CATCHUP_CATEGORY%TYPE, --added for CATCHUP:CACQ14:_[SHANTANU A.]_[12/01/2015]
      I_GEN_CATCHUP_PRIORITY           IN     FID_GENERAL.GEN_CATCHUP_PRIORITY%TYPE, ---added For CATCHUP CR[Rashmi T][25-03-2015]
      i_gen_SVOD_Express               IN     FID_GENERAL.GEN_SVOD_EXPRESS%TYPE,
      i_gen_SVOD_Rights                IN     fid_general.GEN_SVOD_RIGHTS%TYPE,----- added for CR Svod Rights[Vikas Srivastava] [12-04-2016]
      /* BR_15_168_UC_LicensedContents for CR Svod Rights[Vikas Srivastava] [19-04-2016] */
      i_is_update_all_episode          IN     VARCHAR2,
      i_gen_express                    IN     VARCHAR2,
      i_update_all_epi_exp             IN     VARCHAR2,
      i_gen_catalogue                  IN     VARCHAR2,
      i_update_all_epi_cata            IN     VARCHAR2,
      i_cnt_release_uid                IN     FID_GENERAL.GEN_CNT_RELEASE_UID%TYPE,--Added by Zeshan for 10Digit UID CR
      /* End BR_15_168_UC_LicensedContents for CR Svod Rights[Vikas Srivastava] [19-04-2016] */
      /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
      I_AITW_NUMBER                    IN   x_pkg_common_var.number_array,
      I_AITW_CHA_NUMBER                IN   x_pkg_common_var.number_array,
      I_AITW_IS_DAY_TIME               IN   x_pkg_common_var.varchar_array,
      I_AITW_START_TIME                IN   x_pkg_common_var.varchar_array,
      I_AITW_END_TIME                  IN   x_pkg_common_var.varchar_array,
      I_AITW_CHANGE_STATUS             IN   x_pkg_common_var.varchar_array,
      I_CAT_START_TIME                 IN   x_pkg_common_var.varchar_array,
      I_CAT_END_TIME                   IN   x_pkg_common_var.varchar_array,
      I_AITW_PRG_N_SCH_CHANNEL         IN   FID_GENERAL.GEN_PRG_N_SCH_CHANNEL%TYPE,
      I_GEN_SCH_ARF_CUSTM              IN   FID_GENERAL.GEN_SCH_ARF_CUSTM%TYPE,
      I_GEN_TAP_SEQ_NO                 IN   FID_GENERAL.GEN_TAP_SEQ_NO%TYPE,
      I_GEN_ADDINFO_COMMENTS           IN   FID_GENERAL.GEN_ADDINFO_COMMENTS%TYPE,
      /*END :Scheduling CR Implementation [ANKUR KASAR]*/
      i_is_prog_archive_embargo         IN     fid_general.gen_is_archive_embargo_content%TYPE,--Onsite.Dev:Added by Milind_25_Oct_2016
      i_GEN_TVOD_BO_CATEGORY_CODE      IN     fid_general.GEN_TVOD_BO_CATEGORY_CODE%type,
      o_updated                        OUT NUMBER,
      o_gen_updatecount                OUT NUMBER
      )
   AS


      --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
      l_gen_pga_duration             VARCHAR2 (11);
      --DEV.R4:Inventory Mining:End
      l_genrefno                     NUMBER;
      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :l_comnumber removed for -Restricting creation of duplicate Titles on Programme Maintenance */
      l_pronumber                    NUMBER;
      l_refno                        NUMBER;
      l_text                         VARCHAR2 (100);
      l_fgl_count                    NUMBER;
      l_fp_count                     NUMBER;
      l_full_count                   NUMBER;
      l_local_count                  NUMBER;
      l_full_count_exist             NUMBER;
      l_local_count_exist            NUMBER;
      l_fs_count                     NUMBER;
      l_gen_type                     VARCHAR2 (20);
      l_gen_refno_exsists            NUMBER;
      e_no_data                      EXCEPTION;
      --**************TVOD-Added********************************
      l_tvod_lic_count               NUMBER;
      l_linear_lic_count             NUMBER;
      e_tvod_license_found           EXCEPTION;
      e_license_found                EXCEPTION;
      --**************TVOD-END********************************
      s_check                        NUMBER;
      n_check                        NUMBER;
      channel_type                   NUMBER;
      i_schtime                      NUMBER;
      len_duration                   NUMBER;
      old_gen_rating                 VARCHAR (10);
      --[Release 12 and 17]: Start : [Mangesh Gulhane]<22-AUG-13>
      l_old_gen_rating_afr           VARCHAR2 (15);
      l_old_afr_wrt_flag             VARCHAR2 (1) := 'N';
      l_is_wrtoff_cha_sch            BOOLEAN := FALSE;
      l_cha_list                     VARCHAR2 (2000);
      --[Release 12 and 17]:End
      count_ts                       NUMBER;
      --Add by  to get unique report id from  Sequence
      l_mcr_report_id                NUMBER;
      --MANDATORYVALUES EXCEPTION;
      --[Release 12 and 17]: Start : [Anuja_shinde]<20/08/2013>
      --added to set the flag if "Duration or Africa tape duration" is updated.
      l_gen_duration_c               VARCHAR2 (11);
      l_gen_africa_type_duration_c   VARCHAR2 (11);
      l_old_day_time_rest            VARCHAR2 (1);
      l_day_rest_sch                 NUMBER;
      l_gen_update_count             NUMBER;
      --[Release 12 and 17]:End
      --RDT Start Phoneix Req [Kiran][07-05-2014]
      l_duration_number              NUMBER;
      l_gen_dur_diff                 NUMBER;
      l_temp_time                    NUMBER := NULL;
      l_old_duration_c               fid_general.gen_duration_c%TYPE;
      l_new_duration_c               fid_general.gen_duration_c%TYPE;
      l_gen_dur_old                  fid_general.gen_duration_c%TYPE;
      l_gen_duration_old             fid_general.gen_duration%TYPE;
      l_gen_rat_mpaa_old             fid_general.gen_rating_mpaa%TYPE;
      l_gen_rat_int_old              fid_general.gen_rating_int%TYPE;
      l_sch_time                     fid_schedule.sch_time%TYPE;
      l_sch_date                     fid_schedule.sch_date%TYPE;
      l_cha_short_name               fid_channel.cha_short_name%TYPE;
      l_sch_end_old                  fid_schedule.sch_end_time%TYPE;
      l_gen_dur_new                  fid_general.gen_duration_c%TYPE;
      l_gen_rat_mpaa_new             fid_general.gen_rating_mpaa%TYPE;
      l_gen_rat_int_new              fid_general.gen_rating_int%TYPE;
      l_title_count                  NUMBER;
      l_gen_ser_number               fid_series.ser_number%TYPE;
      l_ser_parent_number            fid_series.ser_parent_number%TYPE;
      l_gen_title                    fid_general.gen_title%TYPE;
      l_gen_release_year             fid_general.gen_release_year%TYPE;
      --RDT End Phoneix Req [Kiran][07-05-2014]
      --#region 6March2015: EmbargoContent Save Logic Change
      l_number                       NUMBER;
	    l_is_synopsis_editor				   NUMBER;
      /* BR_15_168_UC_LicensedContents for CR Svod Rights[Vikas Srivastava] [19-04-2016] */
      l_is_series_flag               VARCHAR2(2);
      l_gen_release_svod             VARCHAR2(10);
      l_gen_svod_rights              fid_general.gen_svod_rights%TYPE;
       /* BR_15_168_UC_LicensedContents for CR Svod Rights[Vikas Srivastava] [19-04-2016] */
    /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[15-09-2016]*/
      l_str                        VARCHAR2(4000);
      l_gen_txt_warnning           VARCHAR2(4000);
      l_count                      NUMBER:=0;
      NOT_SUTABLE_REGION           EXCEPTION;
      WATERSHED_TIME_IS_NOT_DEFINE EXCEPTION;
      L_CHA_NUMBER                 NUMBER;
      L_START_TIME                 NUMBER;
      L_END_TIME                   NUMBER;
      L_CAT_START_TIME             NUMBER;
      L_CAT_END_TIME             NUMBER;
      L_WATER_END_TIME             NUMBER;
      L_WATER_START_TIME           NUMBER;
      L_CHANNEL_NOT_SCH            VARCHAR2(1024);
      L_CHA_NO                     VARCHAR2(1024);
      L_ARF_CUSTM                  VARCHAR2(1024);
      L_SEQ_NO                     VARCHAR2(1024);
      L_CNT                        NUMBER;
      L_CHANNEL_NAME               VARCHAR2(1024);
      L_PRG_RATING                 NUMBER;
      L_OPEN_MONTH                 DATE;
      L_COUNT_REGION               NUMBER;
      /*Dev.R1: Scheduling CR Implementation: END:*/
      l_rating_exception_count     NUMBER;
      l_day_time_start  			fid_mpaa_time_slot.mts_time_from_n%type;
      l_day_time_end 			    fid_mpaa_time_slot.mts_time_to_n%type;
      l_mts_time_from_c 			fid_mpaa_time_slot.mts_time_from_c%type;
      l_mts_time_to_c 			  fid_mpaa_time_slot.mts_time_to_c%type;
      l_rating 				        fid_general.gen_rating_int%type;
     --#endregion 6March2015
     l_watershed_from        DATE;
     l_watershed_to          DATE;
     l_higher_rating         VARCHAR2(1);
     l_cat_crossing          VARCHAR2(1);
     l_watershed_crossing    VARCHAR2(1);
     l_extra_duration        NUMBER;
     l_wat_from_num          NUMBER;
     l_Wat_to_num            NUMBER;
     l_time_shft_cat         NUMBER;
     l_is_all_channel_present VARCHAR2(1);
     l_cat_start_time_num        NUMBER;
     l_cat_end_time_num          NUMBER;
     l_cha_name               VARCHAR2(100);
     l_cha_number_array     t_num_tbl := t_num_tbl();
     l_sch_from       DATE;
     l_Sch_to         DATE;
     i_watershed_from  NUMBER;
     i_watershed_end   NUMBER;
	 l_gen_tx_old number;
     l_cha_wtrshed_cat_from   NUMBER;
     l_cha_wtrshed_cat_to     NUMBER;
   BEGIN
   FOR i IN I_AITW_CHA_NUMBER.FIRST .. I_AITW_CHA_NUMBER.LAST
      LOOP
        l_cha_number_array.Extend;
        l_cha_number_array(i) := I_AITW_CHA_NUMBER(i);
   END LOOP;
    l_gen_txt_warnning := null;--Ankur Kasar[scheduling CR's]
		o_gen_updatecount := i_gen_update_cnt;
		o_updated := 0;

    l_rating_exception_count := 0;
      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */
      -- commented because for some gen refno in fid_production we get more than one pro number then we get exact fetch error
      /*
      IF (i_gen_refno IS NOT NULL)
      THEN
      BEGIN
      SELECT pro_number
      INTO l_pronumber
      FROM fid_production
      WHERE pro_gen_refno = i_gen_refno;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_pronumber := NULL;
      l_text := l_text || 'Production Number.';
      END;
      END IF;
      */
      ----DBMS_OUTPUT.PUT_LINE(L_PRONUMBER);

      --#region 6March2015: EmbargoContent Save Logic Change

      if i_gen_express <> 'Y'
      Then
          SELECT COUNT (*)
            INTO l_number
            FROM sgy_mn_lic_tape_cha_mapp, fid_general, fid_tape
           WHERE     gen_refno = ltcm_gen_refno
                 AND tap_number = ltcm_tap_number
                 AND gen_refno = i_gen_refno;

          IF (i_is_embargo = 'Y')
          THEN
             IF (l_number = 0)
             THEN
                raise_application_error (
                   -20622, 'Can not check as Embargo Content because Channel License Mapping is not available for this Title.');
             END IF;
          END IF;
      End If;

      --#endregion 6March2015
      --*****************TVOD-Added MEDIA MANAGEMENT CODE ADDED If programme is deleted through license deltion alreday and the user is still trying to update that record
      BEGIN
         SELECT COUNT (gen_refno)
           INTO l_gen_refno_exsists
           FROM fid_general
          WHERE gen_refno = i_gen_refno;

         IF (l_gen_refno_exsists = 0)
         THEN
            RAISE e_no_data;
         END IF;
      EXCEPTION
         WHEN e_no_data
         THEN
            raise_application_error (-20102, 'Programme not found');
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20102, 'No Data Found');
      END;

      BEGIN
         SELECT gen_type
           INTO l_gen_type
           FROM fid_general
          WHERE gen_refno = i_gen_refno;
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
      END;

      SELECT UPPER (gen_title), gen_release_year, UPPER (gen_type)
        INTO l_gen_title, l_gen_release_year, l_gen_type
        FROM fid_general
       WHERE gen_refno = i_gen_refno;


      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section added - violating rule for MOP_CR-12 */
      l_title_count := 0;

      IF (x_fnc_get_prog_type (i_gen_type) = 'N')
      THEN
         SELECT COUNT (*)
           INTO l_title_count
           FROM fid_general
          WHERE     UPPER (gen_title) = UPPER (i_gen_title)
                AND gen_release_year = i_gen_release_year
                AND UPPER (gen_type) = UPPER (i_gen_type)
                AND gen_refno <> i_gen_refno;
      ELSE
         SELECT COUNT (*)
           INTO l_title_count
           FROM fid_series
          WHERE     UPPER (ser_title) = UPPER (i_gen_title)
                AND ser_release_year = i_gen_release_year
                AND ser_number <> (SELECT gen_ser_number
                                     FROM fid_general
                                    WHERE gen_refno = i_gen_refno);
      END IF;

      IF l_title_count > 0
         AND (   UPPER (i_gen_title) <> l_gen_title
              OR i_gen_release_year <> l_gen_release_year
              OR UPPER (i_gen_type) <> l_gen_type)
      THEN
         raise_application_error (-20110, 'Cannot create duplicate titles.');
      END IF;


      SELECT gen_duration_c,
					 NVL (gen_rating_mpaa, 0),
					 NVL (gen_rating_int, 0),
					 gen_duration,
					 (case when nvl(GEN_RE_TX_WARNING,' ') = ' '  then 0  else length(GEN_RE_TX_WARNING) end)
				INTO l_gen_dur_old,
					 l_gen_rat_mpaa_old,
					 l_gen_rat_int_old,
					 l_gen_duration_old,
					 l_gen_tx_old
				FROM fid_general
			   WHERE gen_refno = i_gen_refno;



      /* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section added - violating rule for MOP_CR-12 */

   -- Prod.Support_[CallId]_[Seperation logic for Saving Of Synopsis and Programme Basic Information]
   -- Check if user has Synopis_editor role

        Select Count(1)
        into l_is_synopsis_editor
        FROM ora_aspnet_usersinroles ur,
              Ora_Aspnet_Users Usr,
              Ora_Aspnet_Roles Rl,
              men_user MU
        where usr.userid = ur.userid
        And   Rl.Roleid = Ur.Roleid
        And Upper (Usr.Username) Like Upper(Mu.Usr_Ad_Loginid)
        And   Upper(Rl.Rolename) = 'SYNOPSIS_EDITOR'
        And  Upper(Mu.Usr_Id) Like Upper ('%'||I_Entry_Oper||'%')
        ;

        Select Count(1)
        into l_rating_exception_count
        FROM ora_aspnet_usersinroles ur,
              Ora_Aspnet_Users Usr,
              Ora_Aspnet_Roles Rl,
              men_user MU
        where usr.userid = ur.userid
        And   Rl.Roleid = Ur.Roleid
        And Upper (Usr.Username) Like Upper(Mu.Usr_Ad_Loginid)
        And   Upper(Rl.Rolename) = 'RATING EXCEPTION'
        And  Upper(Mu.Usr_Id) Like Upper ('%'||I_Entry_Oper||'%');


		if l_is_synopsis_editor = 0
		then
			  BEGIN
				 --TVOD- This condition added to check If any programme has license assign to it, then after some time if user is
				 -- trying to chnage/update its Type as trailer (TRA) then system should not allowed to chnage. Since trailer do not have licenses they are free.
				 --Check has for bothe linear as well TVOD license.
				 IF (i_gen_type = 'TRA')
				 THEN
					--TVOD License checking
					SELECT COUNT (lic_v_number)
					  INTO l_tvod_lic_count
					  FROM fid_general, tbl_tva_license
					 WHERE lic_n_gen_refno = gen_refno AND gen_refno = i_gen_refno;

					--Linear License checking
					SELECT COUNT (lic_number)
					  INTO l_linear_lic_count
					  FROM fid_general, fid_license
					 WHERE lic_gen_refno = gen_refno AND gen_refno = i_gen_refno;
				 END IF;

				 IF (l_tvod_lic_count > 0)
				 THEN
					RAISE e_tvod_license_found;
				 END IF;

				 IF (l_linear_lic_count > 0)
				 THEN
					RAISE e_license_found;
				 END IF;
			  EXCEPTION
				 WHEN e_tvod_license_found
				 THEN
					raise_application_error (
					   -20102,
					   'Can not update Type as trailer as this programme already assign license to it. Please choose another Type.');
				 WHEN e_license_found
				 THEN
					raise_application_error (
					   -20103,
					   'Can not update Type as trailer as this programme already assign license to it. Please choose another Type.');
				 WHEN NO_DATA_FOUND
				 THEN
					raise_application_error (-20102, 'No Data Found');
			  END;

			  --*************************TVOD-END**********************************************************
			  ------Bioscope changes Start Pranay Kusumwal 14/05/2012------
			  ------Added for checking the age restriction on Channel based search------
			  SELECT gen_rating_mpaa,
					 gen_rating_int,
					 gen_is_afr_writeoff,
					 NVL (gen_is_day_time_rest, 'N')
				INTO old_gen_rating,
					 l_old_gen_rating_afr,
					 l_old_afr_wrt_flag,
					 l_old_day_time_rest
				FROM fid_general
			   WHERE gen_refno = i_gen_refno;

				IF (NVL (old_gen_rating, -1) <> NVL (i_gen_rating_mpaa, -1)
				OR NVL (l_old_gen_rating_afr, -1) <> NVL (i_gen_rating_int, -1))
				THEN

					IF l_rating_exception_count = 0
					THEN
          -- [Scheduling CR implementation]_[Milan Shah]_[28-Sep-2016] : START
						FOR i
						IN (SELECT sch_time
									,sch_end_time
									,cha_genre_type
									,cha_number
									,cha_region_id
                  ,sch_number
									,NVL (cha_is_single_feed, 'N') cha_is_single_feed
							FROM fid_schedule, fid_license,fid_channel
							WHERE sch_lic_number = lic_number
							and sch_cha_number = cha_number
							AND lic_gen_refno = i_gen_refno
              and to_char(sch_date,'RRRRMM') >= to_char(sysdate,'RRRRMM')
						)
						LOOP

							IF (i.cha_region_id = 2	OR UPPER (i.cha_is_single_feed) = 'Y')
							THEN
									l_rating := NVL (i_gen_rating_mpaa,i_gen_rating_int);
								else
									l_rating := NVL (i_gen_rating_int, i_gen_rating_mpaa);
							END IF;
              BEGIN

                SELECT NVL(cod_attr,'N') INTO l_higher_rating
                FROM fid_code
                WHERE cod_type = 'GEN_RATING'
                      AND cod_value = l_rating;
                exception when no_data_found
                then
                l_higher_rating :='N';
              END;

              IF l_higher_rating = 'Y'
              THEN
                  BEGIN
                      SELECT xraem_time_diff_in_sec INTO l_extra_duration
                      FROM x_Rating_Add_Extra_Min
                      WHERE xraem_cha_number = I.cha_number
                            AND xraem_rating = l_rating;
                      EXCEPTION WHEN no_Data_found
                      THEN
                          l_extra_duration :=0;
                  END;
                  BEGIN
                      SELECT convert_time_c_n(to_char(to_Date(X_FNC_GET_HHMMSS_DURATION(cha_wtrshed_cat_from),'HH24:MI:SS')+l_extra_duration/86400,'hh24:mi:ss')),
                             Convert_time_c_n(X_FNC_GET_HHMMSS_DURATION(cha_wtrshed_cat_to)),
                             NVL(cha_time_shft_cat,0)
                      INTO l_wat_from_num,l_Wat_to_num,l_time_shft_cat
                      FROM fid_channel
                      WHERE cha_number = I.cha_number;

                      EXCEPTION WHEN NO_DATA_FOUND
                      THEN
                        SELECT convert_time_c_n(cod_attr),
                               convert_time_c_n(cod_attr1),0
                        INTO l_wat_from_num,l_Wat_to_num,l_time_shft_cat
                        FROM fid_Code
                        WHERE cod_type = 'WATERSHED_TIME';
                  END;
                  IF l_wat_from_num IS NULL OR l_Wat_to_num IS NULL
                  THEN
                    SELECT convert_time_c_n(cod_attr),
                             convert_time_c_n(cod_attr1),0
                      INTO l_wat_from_num,l_Wat_to_num,l_time_shft_cat
                      FROM fid_Code
                      WHERE cod_type = 'WATERSHED_TIME';
                  END IF;
                  BEGIN
                    BEGIN
                        SELECT 'N'
                        INTO   l_is_all_channel_present
                        FROM   X_ADD_INFO_TX_WARNNING
                        WHERE  AITW_CHA_NUMBER  = I.cha_number
                               AND AITW_GEN_REFNO   = i_gen_refno;
                        EXCEPTION WHEN no_Data_found THEN

                          BEGIN
                              SELECT 'Y'
                              INTO l_is_all_channel_present
                              FROM   X_ADD_INFO_TX_WARNNING
                              WHERE  AITW_CHA_NUMBER  = -1
                                    AND AITW_GEN_REFNO   = i_gen_Refno;

                              EXCEPTION when no_Data_found THEN
                                  l_is_all_channel_present := 'N';
                          END;
                     END;
                  END;
                  IF l_is_all_channel_present = 'N'
                  THEN
                    BEGIN
                           SELECT NVL(aitw_cat_start_time,l_wat_from_num),NVL(aitw_cat_end_time,l_Wat_to_num)
                            INTO l_cat_start_time_num,l_cat_end_time_num
                            FROM x_add_info_tx_warnning
                            WHERE aitw_gen_refno= i_gen_Refno
                                  AND aitw_cha_number = I.cha_number;
                    EXCEPTION WHEN no_data_found
                    THEN
                        l_cat_start_time_num := l_wat_from_num;
                        l_cat_end_time_num   := l_Wat_to_num;
                    END;
                  ELSE
                    BEGIN

                            SELECT aitw_start_time+(nvl(l_time_shft_cat,0)*60)
                                   ,aitw_end_time+(nvl(l_time_shft_cat,0)*60)
                            INTO l_cat_start_time_num,l_cat_end_time_num
                            FROM x_add_info_tx_warnning
                            WHERE aitw_gen_refno= i_gen_Refno
                                  AND aitw_cha_number = -1;
                            EXCEPTION WHEN no_data_found
                            THEN
                                l_cat_start_time_num := l_wat_from_num;
                                l_cat_end_time_num   := l_Wat_to_num;
                        END;
                  END IF;
                  SELECT x_fun_is_watershed_crossing(l_cat_start_time_num,l_cat_end_time_num,I.sch_time,I.sch_end_Time) INTO l_cat_crossing
                  FROM dual;

                  SELECT x_fun_is_watershed_crossing(l_wat_from_num,l_wat_to_num,I.sch_time,I.sch_end_Time) INTO l_watershed_crossing
                  FROM dual;

                  IF l_cat_crossing = 'Y' AND l_watershed_crossing = 'Y'
                  THEN
                        raise_application_error(-20622,'Cannot update as programme is already on schedule between '||CONVERT_TIME_N_C(l_wat_to_num)||' and '||convert_time_n_c(l_wat_from_num)||'');
                  END IF;
               END IF;
              /* Commented for - [Scheduling CR implementation]_[Milan Shah]_[28-Sep-2016] : START
              if  l_rating = 'R18'
              then
                  l_rating := 'R18';

              elsif l_rating like '%18%'
              then
                  l_rating := '18';
              elsif l_rating like '%16%' and (l_rating like '%S%' OR l_rating like '%N%')
              then
                  l_rating := '16';
              else
                    l_rating := 'NA';
              end if;

							IF i.cha_genre_type IS NULL
							THEN
								for k in
								(	select mts_time_from_n,mts_time_to_n,replace(mts_time_from_c,':00:00','00') mts_time_from_c,replace(mts_time_to_c,':00:00','00') mts_time_to_c
									--into l_day_time_start,l_day_time_end,l_mts_time_from_c,l_mts_time_to_c
									from fid_mpaa_time_slot
									where l_rating like mts_rating
									and exists(select 1 from dual where i.sch_time between (mts_time_from_n +1) and (mts_time_to_n - 1)
												union
												select 1 from dual where i.sch_end_time between (mts_time_from_n +1) and (mts_time_to_n - 1)
												)
								)
								loop
									raise_application_error(-20622,'This program is already scheduled between '|| k.mts_time_from_c ||' and '||k.mts_time_to_c||', so the given rating cannot be updated ');
								end loop;
							END IF;
              Commented for - [Scheduling CR implementation]_[Milan Shah]_[28-Sep-2016] : END  */
						END LOOP;
					END IF;
				END IF;
			  --[Release 12 and 17]: Start : [Mangesh Gulhane]<22-AUG-13> added africa writeoff flag
				IF  (NVL (l_old_afr_wrt_flag, 'N') <> NVL (i_gen_is_afr_writeoff, 'N')) and l_rating_exception_count =0
				THEN
					SELECT wm_concat (cha_name)
					INTO l_cha_list
					FROM (SELECT DISTINCT cha_name
							FROM fid_channel, fid_schedule, fid_license
							WHERE     sch_cha_number = cha_number
							AND sch_lic_number = lic_number
							AND lic_gen_refno = i_gen_refno
							AND cha_region_id = 1
							AND NVL (cha_is_single_feed, 'N') <> 'Y'
							);

				 IF l_cha_list IS NOT NULL
				 THEN
					raise_application_error (
					   -20622,
					   'This program is africa writeoff and is already scheduled on  '
					   || l_cha_list
					   || ' channels');
				 END IF;
			  END IF;

				IF l_old_day_time_rest = 'N'  AND NVL (i_gen_is_day_time_rest, 'N') = 'Y' AND l_rating_exception_count = 0
				THEN
					select mts_time_from_n +1 ,mts_time_to_n -1,replace(mts_time_from_c,':00:00','00') mts_time_from_c,replace(mts_time_to_c,':00:00','00') mts_time_to_c
					into l_day_time_start,l_day_time_end,l_mts_time_from_c,l_mts_time_to_c
					from fid_mpaa_time_slot
					where mts_rating = 'DAY_TIME'
					;

					SELECT COUNT (*)
					INTO l_day_rest_sch
					FROM fid_schedule, fid_license
					WHERE sch_lic_number = lic_number AND lic_gen_refno = i_gen_refno
					AND exists(select 1 from dual where sch_time between l_day_time_start and l_day_time_end
								union
								select 1 from dual where sch_end_time between l_day_time_start and l_day_time_end
								);

					IF l_day_rest_sch > 0
					THEN
						raise_application_error (-20622,'The Program is Already scheduled during '||l_mts_time_from_c||' and '||l_mts_time_to_c||' Day/Prime Time.');
					END IF;
				END IF;
        /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
        BEGIN
            SELECT MIN(to_date(fim_year|| lpad(fim_month,2,0),'rrrrmm')  )INTO L_OPEN_MONTH
            FROM  fid_financial_month, fid_license,fid_licensee
                   WHERE lic_gen_refno = i_gen_refno
                    AND lic_lee_number = lee_number
                    AND FID_FINANCIAL_MONTH.FIM_SPLIT_REGION =fid_licensee.lee_region_id
                    AND FID_FINANCIAL_MONTH.fim_status = 'O';

        EXCEPTION WHEN OTHERS
        THEN
        L_OPEN_MONTH := trunc(SYSDATE);
        END;
        BEGIN
            select GEN_PRG_N_SCH_CHANNEL INTO L_CHANNEL_NOT_SCH from FID_GENERAL where GEN_REFNO = l_genrefno AND GEN_PRG_N_SCH_CHANNEL IS NOT NULL AND ROWNUM<2;
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
          L_CHANNEL_NOT_SCH := NULL;
        END;

        IF L_CHANNEL_NOT_SCH <> I_AITW_PRG_N_SCH_CHANNEL
        THEN
        FOR J IN(select SCH_NUMBER,SCH_CHA_NUMBER,SCH_TIME,SCH_END_TIME
                            from fid_schedule
                            where sch_gen_refno= i_gen_refno
                              AND SCH_DATE >= L_OPEN_MONTH)
        LOOP
           RAISE_APPLICATION_ERROR
             (-20001,'Cannot Update Region of Programme as it is Schduled on Macro Scheduler ');
        END LOOP;
        ELSE
         begin
         select nvl(count(1),0) INTO L_COUNT_REGION
             from fid_schedule fs,fid_channel fc
            where FS.SCH_CHA_NUMBER = FC.CHA_NUMBER
              and FS.SCH_DATE >= L_OPEN_MONTH
              AND FS.SCH_GEN_REFNO =i_gen_refno
              AND FC.CHA_SPLIT_REGION = (SELECT REG_ID FROM FID_REGION WHERE REG_CODE = I_AITW_PRG_N_SCH_CHANNEL);
        exception when others
        then
          L_COUNT_REGION :=0;
        end;
         IF L_COUNT_REGION <> 0
         THEN
           RAISE_APPLICATION_ERROR
             (-20001,'You Can Not Update Region of Programme. It is Schdule on Macro Scheduler ');
         END IF;
      END IF;
     BEGIN
            IF I_AITW_CHA_NUMBER(1) IS NOT NULL
            THEN
                FOR i IN 1.. I_AITW_CHA_NUMBER.COUNT
                LOOP
                    IF I_AITW_CHANGE_STATUS(i) = 'U'
                    THEN
                        IF I_AITW_IS_DAY_TIME(i) <> 'Y' AND I_AITW_CHA_NUMBER(i) <> -1
                        THEN
                            BEGIN
                                SELECT aitw_cat_start_time,aitw_cat_end_time
                                INTO i_watershed_from,i_watershed_end
                                FROM X_ADD_INFO_TX_WARNNING
                                WHERE aitw_gen_Refno = i_gen_refno
                                      AND aitw_cha_number = I_AITW_CHA_NUMBER(i);
                                EXCEPTION when NO_DATA_FOUND THEN
                                        i_watershed_from := NULL;
                                        i_watershed_end := NULL;
                            END;

                            IF i_watershed_from IS NOT NULL AND i_watershed_end IS NOT NULL
                            THEN
                                FOR j IN
                                (
                                    SELECT SCH_CHA_NUMBER,
                                           sch_time,
                                           sch_end_time,
                                           sch_gen_Refno
                                    FROM   fid_schedule
                                    WHERE  sch_gen_refno= i_gen_refno
                                           AND SCH_CHA_NUMBER = I_AITW_CHA_NUMBER(i)
                                           AND SCH_DATE >= L_OPEN_MONTH
                                )
                                LOOP
                                    l_watershed_from := CASE WHEN i_watershed_from < convert_time_c_n('12:00:00')
                                                             THEN to_date(Convert_time_n_c(i_watershed_from),'hh24:mi:ss') + 1
                                                             ELSE to_date(Convert_time_n_c(i_watershed_from),'hh24:mi:ss')
                                                        END;

                                    l_watershed_to   := CASE WHEN i_watershed_end < i_watershed_from
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr') || ' ' ||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')+1
                                                             WHEN i_watershed_end < convert_time_c_n('12:00:00') AND i_watershed_from > convert_time_c_n('12:00:00')
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')+1
                                                             ELSE to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' ' ||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')
                                                        END;

                                    l_sch_from       := (CASE WHEN j.sch_time < convert_time_c_n('12:00:00') AND i_watershed_from > convert_time_c_n('12:00:00')
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_time ),'dd-mm-rrrr hh24:mi:ss')+1
                                                              ELSE to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_time ),'dd-mm-rrrr hh24:mi:ss')
                                                         END)+1/86400;

                                    l_Sch_to         := (CASE WHEN j.sch_end_time < j.sch_time
                                                                  THEN to_date(to_char(l_sch_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_end_time),'dd-mm-rrrr hh24:mi:ss')+1
                                                              ELSE to_date(to_char(l_sch_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_end_time),'dd-mm-rrrr hh24:mi:ss')
                                                         END)-1/86400;

                                    IF ((l_sch_from BETWEEN l_watershed_from AND l_watershed_to)
                                            AND (l_sch_to BETWEEN l_watershed_from AND l_watershed_to))
                                    THEN
                                          SELECT x_fun_is_watershed_crossing(CONVERT_TIME_C_N(I_CAT_START_TIME(i)),CONVERT_TIME_C_N(I_CAT_END_TIME(i)),j.sch_time,j.sch_end_time)
                                          INTO l_cat_crossing
                                          FROM dual;

                                          IF l_cat_crossing = 'Y'
                                          THEN
                                            SELECT cha_name,convert_time_c_s(decode(cha_wtrshed_cat_from,NULL,NULL,cha_wtrshed_cat_from || ':00')),convert_time_c_s(decode(cha_wtrshed_cat_to,NULL,NULL,cha_wtrshed_cat_to || ':00'))
                                              INTO l_cha_name,l_cha_wtrshed_cat_from,l_cha_wtrshed_cat_to
                                              FROM fid_channel
                                             WHERE cha_number = i_aitw_cha_number(i);

                                            IF x_fun_is_watershed_crossing(l_cha_wtrshed_cat_from,l_cha_wtrshed_cat_to,j.sch_time,j.sch_end_time) = 'Y'
                                            THEN
                                               raise_application_error(-20016,'Cannot update as title will violate defined watershed period on '||l_cha_name||' Channel.');
                                            END IF;
                                          END IF;
                                    END IF;
                                END LOOP;
                           END IF;
                        END IF;
                        IF I_AITW_CHA_NUMBER(i) = -1 AND I_AITW_IS_DAY_TIME(i) <> 'Y'
                        THEN
                            FOR j IN
                            (
                                SELECT SCH_CHA_NUMBER,
                                       sch_time,
                                       sch_end_time,
                                       sch_gen_Refno
                                FROM   fid_schedule
                                WHERE  sch_gen_refno= i_gen_refno
                                       AND SCH_CHA_NUMBER NOT IN(SELECT column_value FROM TABLE(l_cha_number_array))
                                       AND SCH_DATE >= L_OPEN_MONTH
                            )
                            LOOP
                                  SELECT NVL(cha_time_shft_cat,0)
                                  INTO l_time_shft_cat
                                  FROM fid_channel
                                  WHERE cha_number = j.sch_cha_number;

                                BEGIN
                                    SELECT aitw_start_time+(nvl(l_time_shft_cat,0)*60),aitw_end_time+(nvl(l_time_shft_cat,0)*60)
                                    INTO i_watershed_from,i_watershed_end
                                    FROM X_ADD_INFO_TX_WARNNING
                                    WHERE aitw_gen_Refno = i_gen_refno
                                          AND aitw_cha_number = -1;
                                    EXCEPTION when NO_DATA_FOUND THEN
                                            i_watershed_from := NULL;
                                            i_watershed_end := NULL;
                                END;
                                IF i_watershed_from IS NOT NULL AND i_watershed_end IS NOT NULL
                                THEN
                                    l_watershed_from := CASE WHEN i_watershed_from < convert_time_c_n('12:00:00')
                                                             THEN to_date(Convert_time_n_c(i_watershed_from),'hh24:mi:ss') + 1
                                                             ELSE to_date(Convert_time_n_c(i_watershed_from),'hh24:mi:ss')
                                                        END;

                                    l_watershed_to   := CASE WHEN i_watershed_end < i_watershed_from
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr') || ' ' ||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')+1
                                                             WHEN i_watershed_end < convert_time_c_n('12:00:00') AND i_watershed_from > convert_time_c_n('12:00:00')
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')+1
                                                             ELSE to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' ' ||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')
                                                        END;

                                    l_sch_from       := (CASE WHEN j.sch_time < convert_time_c_n('12:00:00') AND i_watershed_from > convert_time_c_n('12:00:00')
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_time ),'dd-mm-rrrr hh24:mi:ss')+1
                                                              ELSE to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_time ),'dd-mm-rrrr hh24:mi:ss')
                                                         END)+1/86400;

                                    l_Sch_to         := (CASE WHEN j.sch_end_time < j.sch_time
                                                                  THEN to_date(to_char(l_sch_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_end_time),'dd-mm-rrrr hh24:mi:ss')+1
                                                              ELSE to_date(to_char(l_sch_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_end_time),'dd-mm-rrrr hh24:mi:ss')
                                                         END)-1/86400;

                                    IF ((l_sch_from BETWEEN l_watershed_from AND l_watershed_to)
                                            AND (l_sch_to BETWEEN l_watershed_from AND l_watershed_to))
                                    THEN
                                          SELECT x_fun_is_watershed_crossing(CONVERT_TIME_C_N(I_AITW_START_TIME(i))+(nvl(l_time_shft_cat,0)*60),CONVERT_TIME_C_N(I_AITW_END_TIME(i))+(nvl(l_time_shft_cat,0)*60),j.sch_time,j.sch_end_time)
                                          INTO l_cat_crossing
                                          FROM dual;

                                          IF  l_cat_crossing = 'Y'
                                          THEN
                                              SELECT cha_name INTO l_cha_name
                                              FROM fid_channel WHERE cha_number = j.SCH_CHA_NUMBER;

                                              raise_application_error(-20016,'Cannot update as title will violate defined watershed period on '||l_cha_name||' Channel.');
                                          END IF;
                                      END IF;
                                END IF;
                            END LOOP;
                        END IF;

                    ELSIF I_AITW_CHANGE_STATUS(i) = 'D'
                    THEN
                         IF I_AITW_CHA_NUMBER(i) <> -1
                         THEN
                              BEGIN
                                  SELECT aitw_cat_start_time,aitw_cat_end_time
                                  INTO i_watershed_from,i_watershed_end
                                  FROM X_ADD_INFO_TX_WARNNING
                                  WHERE aitw_gen_Refno = i_gen_refno
                                        AND aitw_cha_number = I_AITW_CHA_NUMBER(i);
                                  EXCEPTION when NO_DATA_FOUND THEN
                                          i_watershed_from := NULL;
                                          i_watershed_end := NULL;
                              END;
                              IF i_watershed_from IS NOT NULL AND i_watershed_end IS NOT NULL
                              THEN
                                  FOR j IN
                                  (
                                      SELECT SCH_CHA_NUMBER,
                                             sch_time,
                                             sch_end_time,
                                             sch_gen_Refno
                                      FROM   fid_schedule
                                      WHERE  sch_gen_refno= i_gen_refno
                                             AND SCH_CHA_NUMBER = I_AITW_CHA_NUMBER(i)
                                             AND SCH_DATE >= L_OPEN_MONTH
                                  )
                                  LOOP
                                      l_watershed_from := CASE WHEN i_watershed_from < convert_time_c_n('12:00:00')
                                                             THEN to_date(Convert_time_n_c(i_watershed_from),'hh24:mi:ss') + 1
                                                             ELSE to_date(Convert_time_n_c(i_watershed_from),'hh24:mi:ss')
                                                        END;

                                    l_watershed_to   := CASE WHEN i_watershed_end < i_watershed_from
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr') || ' ' ||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')+1
                                                             WHEN i_watershed_end < convert_time_c_n('12:00:00') AND i_watershed_from > convert_time_c_n('12:00:00')
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')+1
                                                             ELSE to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' ' ||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')
                                                        END;

                                    l_sch_from       := (CASE WHEN j.sch_time < convert_time_c_n('12:00:00') AND i_watershed_from > convert_time_c_n('12:00:00')
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_time ),'dd-mm-rrrr hh24:mi:ss')+1
                                                              ELSE to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_time ),'dd-mm-rrrr hh24:mi:ss')
                                                         END)+1/86400;

                                    l_Sch_to         := (CASE WHEN j.sch_end_time < j.sch_time
                                                                  THEN to_date(to_char(l_sch_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_end_time),'dd-mm-rrrr hh24:mi:ss')+1
                                                              ELSE to_date(to_char(l_sch_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_end_time),'dd-mm-rrrr hh24:mi:ss')
                                                         END)-1/86400;

                                        IF ((l_sch_from BETWEEN l_watershed_from AND l_watershed_to)
                                            AND (l_sch_to BETWEEN l_watershed_from AND l_watershed_to))
                                        THEN
                                            SELECT cha_name,convert_time_c_s(decode(cha_wtrshed_cat_from,NULL,NULL,cha_wtrshed_cat_from || ':00')),convert_time_c_s(decode(cha_wtrshed_cat_to,NULL,NULL,cha_wtrshed_cat_to || ':00'))
                                              INTO l_cha_name,l_cha_wtrshed_cat_from,l_cha_wtrshed_cat_to
                                              FROM fid_channel
                                             WHERE cha_number = i_aitw_cha_number(i);

                                            IF x_fun_is_watershed_crossing(l_cha_wtrshed_cat_from,l_cha_wtrshed_cat_to,j.sch_time,j.sch_end_time) = 'Y'
                                            THEN
                                               raise_application_error(-20016,'Cannot delete as title will violate defined watershed period on '||l_cha_name||' channel');
                                            END IF;
                                      END IF;
                                  END LOOP;--schedule loop delete
                                END IF;
                          END IF;

                          IF I_AITW_CHA_NUMBER(i) = -1
                          THEN
                            FOR j IN
                            (
                                SELECT SCH_CHA_NUMBER,
                                       sch_time,
                                       sch_end_time,
                                       sch_gen_Refno
                                FROM   fid_schedule
                                WHERE  sch_gen_refno= i_gen_refno
                                       AND SCH_CHA_NUMBER NOT IN(SELECT column_value FROM TABLE(l_cha_number_array))
                                       AND SCH_DATE >= L_OPEN_MONTH
                            )
                            LOOP
                                  SELECT NVL(cha_time_shft_cat,0)
                                  INTO l_time_shft_cat
                                  FROM fid_channel
                                  WHERE cha_number = j.sch_cha_number;

                                  BEGIN
                                      SELECT aitw_start_time+(nvl(l_time_shft_cat,0)*60),aitw_end_time+(nvl(l_time_shft_cat,0)*60)
                                      INTO i_watershed_from,i_watershed_end
                                      FROM X_ADD_INFO_TX_WARNNING
                                      WHERE aitw_gen_Refno = i_gen_refno
                                            AND aitw_cha_number = -1;
                                      EXCEPTION when NO_DATA_FOUND THEN
                                              i_watershed_from := NULL;
                                              i_watershed_end := NULL;
                                  END;
                                  IF i_watershed_from IS NOT NULL AND i_watershed_end IS NOT NULL
                                  THEN
                                      l_watershed_from := CASE WHEN i_watershed_from < convert_time_c_n('12:00:00')
                                                             THEN to_date(Convert_time_n_c(i_watershed_from),'hh24:mi:ss') + 1
                                                             ELSE to_date(Convert_time_n_c(i_watershed_from),'hh24:mi:ss')
                                                        END;

                                      l_watershed_to   := CASE WHEN i_watershed_end < i_watershed_from
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr') || ' ' ||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')+1
                                                             WHEN i_watershed_end < convert_time_c_n('12:00:00') AND i_watershed_from > convert_time_c_n('12:00:00')
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')+1
                                                             ELSE to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' ' ||Convert_time_n_c(i_watershed_end),'dd-mm-rrrr hh24:mi:ss')
                                                        END;

                                      l_sch_from       := (CASE WHEN j.sch_time < convert_time_c_n('12:00:00') AND i_watershed_from > convert_time_c_n('12:00:00')
                                                                  THEN to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_time ),'dd-mm-rrrr hh24:mi:ss')+1
                                                              ELSE to_date(to_char(l_watershed_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_time ),'dd-mm-rrrr hh24:mi:ss')
                                                         END)+1/86400;

                                      l_Sch_to         := (CASE WHEN j.sch_end_time < j.sch_time
                                                                  THEN to_date(to_char(l_sch_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_end_time),'dd-mm-rrrr hh24:mi:ss')+1
                                                              ELSE to_date(to_char(l_sch_from,'dd-mm-rrrr')||' '||Convert_time_n_c(j.sch_end_time),'dd-mm-rrrr hh24:mi:ss')
                                                         END)-1/86400;

                                  IF ((l_sch_from BETWEEN l_watershed_from AND l_watershed_to)
                                            AND (l_sch_to BETWEEN l_watershed_from AND l_watershed_to))
                                  THEN
                                      SELECT cha_name INTO l_cha_name
                                      FROM fid_channel WHERE cha_number = j.SCH_CHA_NUMBER;

                                      raise_application_error(-20016,'Cannot delete as title will violate defined watershed period on '||l_cha_name||' Channel.');
                                  END IF;
                                END IF;
                            END LOOP;
                        END IF;
                    END IF; -- Status check end if;
                END LOOP;--Arraylist end loop;
            END IF;--empty array list end if;
        END;
        /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/

			  --[Release 12 and 17]: Start : [Anuja_shinde]<20/08/2013>
			  SELECT NVL (gen_duration_c, 0),
					 gen_africa_type_duration_c,
					 gen_update_count --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
									 ,
					 NVL (gen_pga_duration, '0')
				--DEV.R4:Inventory Mining:End
				INTO l_gen_duration_c,
					 l_gen_africa_type_duration_c,
					 l_gen_update_count,
					 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
					 l_gen_pga_duration
				--DEV.R4:Inventory Mining:End
				FROM fid_general
			   WHERE gen_refno = i_gen_refno;

			  --[Release 12 and 17]:End

			  --RDT Start Phoneix Req [Kiran][07-05-2014]
			  SELECT gen_duration_c,
					 NVL (gen_rating_mpaa, 0),
					 NVL (gen_rating_int, 0),
					 gen_duration--,   (case when GEN_RE_TX_WARNING = null or GEN_RE_TX_WARNING = '' then 0  else length(GEN_RE_TX_WARNING) end)
				INTO l_gen_dur_old,
					 l_gen_rat_mpaa_old,
					 l_gen_rat_int_old,
					 l_gen_duration_old--, l_gen_tx_old
				FROM fid_general
			   WHERE gen_refno = i_gen_refno;

			  --RDT end Phoneix Req [Kiran][07-05-2014]

			  ------Bioscope changes End Pranay Kusumwal 14/05/2012------
			  ---changes by pranay start---
			  ---To resolve the issue when appending 00 in the gen_duration and saving----
			  SELECT LENGTH (i_gen_duration_c) INTO len_duration FROM DUAL;

			  IF len_duration = 8
			  THEN
				 --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
				 IF (pkg_mm_mnet_pl_prgmaintenance.is_tvod_prog (i_gen_refno) = 1)
				 THEN
					UPDATE tbl_tva_dm_prog
					   SET dmprg_n_bo_category = i_gen_prog_category_code
					 WHERE dmprg_n_gen_refno = i_gen_refno;
				 END IF;

				 --Dev3: TVOD_CR: END :[TVOD_CR]
				 UPDATE fid_general fg
					-- Add by
					/*
					DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
					Colums
					gen_stu_code = NVL (i_gen_stu_code, fg.gen_stu_code),
					gen_colour = NVL (substr(i_gen_colour,1,2), fg.gen_colour),
					gen_code = NVL (i_gen_code, fg.gen_code),
					gen_sub_title = NVL (i_gen_sub_title, fg.gen_sub_title),
					gen_music_title = NVL (i_gen_music_title, fg.gen_music_title),
					gen_widescreen = NVL (i_gen_widescreen, fg.gen_widescreen),
					gen_poem_title = NVL (i_gen_poem_title, fg.gen_poem_title),
					gen_copy_restrictions = NVL (i_gen_copy_restrictions, fg.gen_copy_restrictions),
					gen_abstract = NVL (i_gen_abstract, fg.gen_abstract),
					gen_nfa_copy = NVL (i_gen_nfa_copy, fg.gen_nfa_copy),
					gen_cat_complete = NVL (i_gen_cat_complete, fg.gen_cat_complete),
					gen_tx_digitized = NVL (i_gen_tx_digitized, fg.gen_tx_digitized),
					gen_archive = NVL (i_gen_archive, fg.gen_archive),
					gen_web_title = i_gen_web_title,
					DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
					*/
					SET gen_title = NVL (i_gen_title, fg.gen_title),
						gen_title_working =
						   NVL (i_gen_title_working, fg.gen_title_working),
						gen_category = NVL (i_gen_category, fg.gen_category),
						gen_subgenre = i_gen_subgenre,
						-- NVL (i_gen_subgenre, fg.gen_subgenre),   RDT Audit
						gen_rating_mpaa = i_gen_rating_mpaa,
						--NVL (i_gen_rating_mpaa, fg.gen_rating_mpaa),RDT Audit
						gen_rating_int = i_gen_rating_int,
						-- NVL (i_gen_rating_int, fg.gen_rating_int),RDT Pheonix
						gen_quality = NVL (i_gen_quality, fg.gen_quality),
						gen_spoken_lang = NVL (i_gen_spoken_lang, fg.gen_spoken_lang),
						gen_series = NVL (i_gen_series, fg.gen_series),
						gen_type = NVL (i_gen_type, fg.gen_type),
						gen_release_year =
						   NVL (i_gen_release_year, fg.gen_release_year),
						gen_nationality = NVL (i_gen_nationality, fg.gen_nationality),
						gen_duration_c = NVL (i_gen_duration_c, fg.gen_duration_c),
						gen_duration_s = NVL (i_gen_duration_s, fg.gen_duration_s),
						gen_epi_number = NVL (i_gen_epi_number, fg.gen_epi_number),
						gen_award = NVL (i_gen_award, fg.gen_award),
						gen_target_group =
						   NVL (i_gen_target_group, fg.gen_target_group),
						-- Prod.Support : SVOD : Start : [Devashish Raverkar]_[2015-03-20]
						gen_sec_target_group =
						   NVL (i_gen_sec_target_group, fg.gen_sec_target_group),
						-- Prod.Support : SVOD : End
						gen_comment = NVL (i_gen_comment, fg.gen_comment),
						/* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */
						gen_re_tx_warning = decode(l_gen_tx_old, 0, null, i_gen_re_tx_warning),
						--gen_re_tx_warning = l_gen_txt_warnning,--REMOVED BY [--Ankur Kasar[scheduling CR's IMPLEMENATTION]]
						gen_entry_oper = i_entry_oper,
						gen_entry_date = SYSDATE,
						--###Bioscope added###-----
						gen_rating_imdb = i_imdb_rating,
						gen_rating_ar = i_ar_rating,
						gen_rating_expert_meta_critic = i_expert_rating,
						gen_bo_category_code = i_bo_category,
						gen_bo_revenue_usd = i_usd_revenue,
						gen_bo_revenue_zar = i_zar_revenue,
						gen_final_grade = i_final_grade,
						gen_prog_category_code = i_gen_prog_category_code,
						gen_tertiary_genre = i_gen_tertiary_genre,
						gen_web_title = i_web_title,
						-- kunal 02-03-2015 START: Production Number
						gen_production_number = i_gen_production_number,
						-- kunal : END Production Number
						--START: PROJECT BIOSCOPE ? PENDING CR?S: Mangesh Gulhane_20121003
						-- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
						gen_mood = i_gen_mood,
						gen_link_poster_art = i_gen_link_poster_art,
						--END: PROJECT BIOSCOPE ? PENDING CR?S:
						--Catch and PB CR[SCH 32][Mangesh Gulhane][13-AUG-13][Added column for AFR writeoff]
						gen_is_afr_writeoff = NVL (i_gen_is_afr_writeoff, 'N'),
						gen_is_day_time_rest = NVL (i_gen_is_day_time_rest, 'N'),
						--Catch and PB CR END
						gen_metadata_verified = NVL (i_flag_metadata_verified, 'N'),
						--#region Abhinay_230512014 : New Field Metadata Verified
						--------
						gen_duration =
						   (  (SUBSTR (i_gen_duration_c, 1, 2) * 90000)
							+ (SUBSTR (i_gen_duration_c, 4, 2) * 1500)
							+ (SUBSTR (i_gen_duration_c, 7, 2) * 25)),
						--gen_update_count = gen_update_count + 1,
						-- Add by
						---- DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
						gen_tags = i_gen_tags,
						gen_africa_type_duration_c = i_gen_africa_type_duration_c,
						gen_africa_type_duration_s = i_gen_africa_type_duration_s,
						gen_africa_type_duration =
						   (  (SUBSTR (i_gen_duration_c, 1, 2) * 90000)
							+ (SUBSTR (i_gen_duration_c, 4, 2) * 1500)
							+ (SUBSTR (i_gen_duration_c, 7, 2) * 25)) ---- DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
																	 --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
						,
						gen_aka_title = i_aka_title,
						gen_catchup_category = i_gen_catchup_category -- added for CATCHUP:SHANTANU A._[12/01/2015]
																	 ,
						gen_catchup_priority = i_gen_catchup_priority, -- added for CATCHUP CR: Rashmi[25-03-2015]
						gen_embargo_content =
						   DECODE (gen_embargo_content,
								   i_prog_embargo, gen_embargo_content,
								   i_prog_embargo)             --#endregion 6March2015
		 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
						,
            GEN_IS_CINEMA_EMBARGO_CONTENT = DECODE (GEN_IS_CINEMA_EMBARGO_CONTENT,I_IS_PROG_CINEMA_EMBARGO,
                                            GEN_IS_CINEMA_EMBARGO_CONTENT,I_IS_PROG_CINEMA_EMBARGO),--Onsite.Dev:BR_15_327

						GEN_PGA_DURATION = I_GEN_DURATION_PGA,
            --bhagyashri
            GEN_SVOD_EXPRESS = i_gen_SVOD_Express,
				  --DEV.R4:Inventory Mining:End
            GEN_CNT_RELEASE_UID = i_cnt_release_uid   --Added by Zeshan for 10Digit UID CR
	    ,GEN_IS_ARCHIVE_EMBARGO_CONTENT = DECODE (GEN_IS_ARCHIVE_EMBARGO_CONTENT,I_IS_PROG_ARCHIVE_EMBARGO,
                                            GEN_IS_ARCHIVE_EMBARGO_CONTENT,I_IS_PROG_ARCHIVE_EMBARGO) --Onsite.Dev:Added by Milind_25_10_2016
           , GEN_TVOD_BO_CATEGORY_CODE  = i_GEN_TVOD_BO_CATEGORY_CODE

            /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
           ,GEN_SCH_ARF_CUSTM    =  I_GEN_SCH_ARF_CUSTM
           ,GEN_TAP_SEQ_NO       =  I_GEN_TAP_SEQ_NO
           ,GEN_ADDINFO_COMMENTS =  I_GEN_ADDINFO_COMMENTS
           ,GEN_PRG_N_SCH_CHANNEL = I_AITW_PRG_N_SCH_CHANNEL
            /*Dev.R1: Scheduling CR Implementation: END */
				  WHERE gen_refno = i_gen_refno;

				 --RDT Start Phoneix Req [Kiran][07-05-2014]
				 SELECT pkg_mm_mnet_pl_prgmaintenance.fun_convert_duration_c_n (
						   l_gen_dur_old),
						pkg_mm_mnet_pl_prgmaintenance.fun_convert_duration_c_n (
						   i_gen_duration_c)
				   INTO l_old_duration_c, l_new_duration_c
				   FROM DUAL;

				 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[11-03-2015]
				 IF ( (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_duration_c), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (i_gen_duration_c), 0))
					 AND (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_pga_duration), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (I_GEN_DURATION_PGA), 0)))
				 THEN                                                          -- both
					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'PGA Duration');
				 ELSIF (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_pga_duration), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (I_GEN_DURATION_PGA), 0))
				 THEN                                                           -- PGA
					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'PGA Duration');
				 ELSIF (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_duration_c), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (i_gen_duration_c), 0))
				 THEN                                                     -- estimated
					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'Estimated Duration');
				 END IF;

				 --DEV.R4:Inventory Mining:End
				 FOR i
					IN (SELECT gen_refno,
							   sch_number,
							   sch_lic_number,
							   sch_time,
							   sch_end_time,
							   sch_date,
							   cha_short_name
						  FROM fid_schedule,
							   fid_general,
							   fid_license,
							   fid_channel
						 WHERE     sch_lic_number = lic_number
							   AND lic_gen_refno = gen_refno
							   AND cha_number = sch_cha_number
							   AND gen_refno = i_gen_refno
							   AND sch_date >=  TRUNC(SYSDATE) )
				 LOOP
					--  raise_application_error(-20000,'l_old_duration_c '||l_old_duration_c  || ' l_new_duration_c ' ||l_new_duration_c);
					/*IF (i.sch_time + l_new_duration_c) >= 86400 --commented by Nasreen
					THEN
					   --DBMS_OUTPUT.put_line (' in greater than 86400');
					   l_temp_time := (i.sch_time + l_new_duration_c) - 86400;
					   --DBMS_OUTPUT.put_line (   ' in greater than 86400 temp time'
											 || ' '
											 || l_temp_time
											);

					   UPDATE fid_schedule
						  SET sch_end_time = l_temp_time
						WHERE sch_lic_number = i.sch_lic_number
						  AND sch_number = i.sch_number;
					ELSE
					   --DBMS_OUTPUT.put_line (' in else not greater than 86400');
					   l_temp_time := (i.sch_time + l_new_duration_c);
					   --DBMS_OUTPUT.put_line
									  (   ' in else not greater than 86400 temp time'
									   || ' '
									   || l_temp_time
									  );

					   UPDATE fid_schedule
						  SET sch_end_time = l_temp_time
						WHERE sch_lic_number = i.sch_lic_number
						  AND sch_number = i.sch_number;
					END IF; */

					SELECT gen_duration_c,
						   NVL (gen_rating_mpaa, 0),
						   NVL (gen_rating_int, 0)
					  INTO l_gen_dur_new, l_gen_rat_mpaa_new, l_gen_rat_int_new
					  FROM fid_general
					 WHERE gen_refno = i_gen_refno;

					/* BEGIN -- commented by Nasreen
						IF l_gen_dur_old != l_gen_dur_new
						THEN
						   INSERT INTO x_prg_change_history
									   (prg_gen_refno, prg_sch_time, prg_sch_date,
										prg_lic_number, prg_cha_name,
										prg_modified_attribute, prg_old_value,
										prg_new_value, prg_entry_operator,
										prg_entry_date
									   )
								VALUES (i.gen_refno, i.sch_time, i.sch_date,
										i.sch_lic_number, i.cha_short_name,
										'Programme duration ', l_gen_dur_old,
										l_gen_dur_new, i_entry_oper,
										i_attributemodifieddatetime
									   );
						END IF;
					 EXCEPTION
						WHEN OTHERS
						THEN
						   NULL;
					 END;*/

					BEGIN
					   --  raise_application_error(-20000,'l_GEN_RAT_MPAA_old '||l_GEN_RAT_MPAA_old||'l_GEN_RAT_MPAA_NEW '||l_GEN_RAT_MPAA_NEW );
					   IF l_gen_rat_mpaa_old != l_gen_rat_mpaa_new
					   THEN
						  INSERT INTO x_prg_change_history (prg_gen_refno,
															prg_sch_time,
															prg_sch_date,
															prg_lic_number,
															prg_cha_name,
															prg_modified_attribute,
															prg_old_value,
															prg_new_value,
															prg_entry_operator,
															prg_entry_date)
							   VALUES (i.gen_refno,
									   i.sch_time,
									   i.sch_date,
									   i.sch_lic_number,
									   i.cha_short_name,
									   'Domestic Age Restriction',
									   l_gen_rat_mpaa_old,
									   l_gen_rat_mpaa_new,
									   i_entry_oper,
									   i_attributemodifieddatetime);
					   END IF;
					/*   EXCEPTION
					   WHEN OTHERS THEN
						 NULL;*/
					END;

					BEGIN
					   IF l_gen_rat_int_old != l_gen_rat_int_new
					   THEN
						  INSERT INTO x_prg_change_history (prg_gen_refno,
															prg_sch_time,
															prg_sch_date,
															prg_lic_number,
															prg_cha_name,
															prg_modified_attribute,
															prg_old_value,
															prg_new_value,
															prg_entry_operator,
															prg_entry_date)
							   VALUES (i.gen_refno,
									   i.sch_time,
									   i.sch_date,
									   i.sch_lic_number,
									   i.cha_short_name,
									   'Africa Age Restriction',
									   l_gen_rat_int_old,
									   l_gen_rat_int_new,
									   i_entry_oper,
									   i_attributemodifieddatetime);
					   END IF;
					/*  EXCEPTION
					  WHEN OTHERS THEN
						NULL;*/
					END;
				 END LOOP;
			  --RDT END Phoneix Req [Kiran][07-05-2014]
			  ELSIF len_duration = 9
			  THEN
				 --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
				 IF (pkg_mm_mnet_pl_prgmaintenance.is_tvod_prog (i_gen_refno) = 1)
				 THEN
					UPDATE tbl_tva_dm_prog
					   SET dmprg_n_bo_category = i_gen_prog_category_code
					 WHERE dmprg_n_gen_refno = i_gen_refno;
				 END IF;

				 --Dev3: TVOD_CR: END :[TVOD_CR]
				 UPDATE fid_general fg
					-- Add by
					/*
					DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
					Colums
					gen_stu_code = NVL (i_gen_stu_code, fg.gen_stu_code),
					gen_colour = NVL (substr(i_gen_colour,1,2), fg.gen_colour),
					gen_code = NVL (i_gen_code, fg.gen_code),
					gen_widescreen = NVL (i_gen_widescreen, fg.gen_widescreen),
					gen_sub_title = NVL (i_gen_sub_title, fg.gen_sub_title),
					gen_music_title = NVL (i_gen_music_title, fg.gen_music_title),
					gen_poem_title = NVL (i_gen_poem_title, fg.gen_poem_title),
					gen_copy_restrictions =   NVL (i_gen_copy_restrictions, fg.gen_copy_restrictions),
					gen_abstract = NVL (i_gen_abstract, fg.gen_abstract),
					gen_nfa_copy = NVL (i_gen_nfa_copy, fg.gen_nfa_copy),
					gen_cat_complete = NVL (i_gen_cat_complete, fg.gen_cat_complete),
					gen_tx_digitized = NVL (i_gen_tx_digitized, fg.gen_tx_digitized),
					gen_archive = NVL (i_gen_archive, fg.gen_archive),
					gen_web_title = i_gen_web_title,
					DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
					*/
					SET                                 --GEN_DURATION=I_GEN_DURATION,
					   gen_title = NVL (i_gen_title, fg.gen_title),
						gen_title_working =
						   NVL (i_gen_title_working, fg.gen_title_working),
						gen_category = NVL (i_gen_category, fg.gen_category),
						gen_subgenre = i_gen_subgenre,
						-- NVL (i_gen_subgenre, fg.gen_subgenre),   RDT Audit
						gen_rating_mpaa = i_gen_rating_mpaa,
						--NVL (i_gen_rating_mpaa, fg.gen_rating_mpaa),RDT Audit
						gen_rating_int = NVL (i_gen_rating_int, fg.gen_rating_int),
						gen_quality = NVL (i_gen_quality, fg.gen_quality),
						gen_spoken_lang = NVL (i_gen_spoken_lang, fg.gen_spoken_lang),
						gen_series = NVL (i_gen_series, fg.gen_series),
						--gen_parent_refno = NVL (i_gen_parent_refno, fg.gen_parent_refno),
						gen_type = NVL (i_gen_type, fg.gen_type),
						gen_release_year =
						   NVL (i_gen_release_year, fg.gen_release_year),
						gen_nationality = NVL (i_gen_nationality, fg.gen_nationality),
						gen_duration_c = NVL (i_gen_duration_c, fg.gen_duration_c),
						gen_duration_s = NVL (i_gen_duration_s, fg.gen_duration_s),
						gen_epi_number = NVL (i_gen_epi_number, fg.gen_epi_number),
						gen_award = NVL (i_gen_award, fg.gen_award),
						gen_target_group =
						   NVL (i_gen_target_group, fg.gen_target_group),
						gen_comment = NVL (i_gen_comment, fg.gen_comment),
						/* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */
						gen_re_tx_warning = decode(l_gen_tx_old, 0, null, i_gen_re_tx_warning),
						--gen_re_tx_warning = l_gen_txt_warnning,--REMOVED BY [--Ankur Kasar[scheduling CR's IMPLEMENATTION]]
						gen_entry_oper = i_entry_oper,
						gen_entry_date = SYSDATE,
						--###Bioscope added###-----
						gen_rating_imdb = i_imdb_rating,
						gen_rating_ar = i_ar_rating,
						gen_rating_expert_meta_critic = i_expert_rating,
						gen_bo_category_code = i_bo_category,
						gen_bo_revenue_usd = i_usd_revenue,
						gen_bo_revenue_zar = i_zar_revenue,
						gen_final_grade = i_final_grade,
						gen_prog_category_code = i_gen_prog_category_code,
						gen_tertiary_genre = i_gen_tertiary_genre,
						gen_web_title = i_web_title,
						-- kunal 02-03-2015 START: Production Number
						gen_production_number = i_gen_production_number,
						-- kunal : END Production Number
						--START: PROJECT BIOSCOPE ? PENDING CR?S: Mangesh Gulhane_20121003
						-- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
						gen_mood = i_gen_mood,
						gen_link_poster_art = i_gen_link_poster_art,
						--END: PROJECT BIOSCOPE ? PENDING CR?S:
						--Catch and PB CR[SCH 32][Mangesh Gulhane][13-AUG-13][Added column for AFR writeoff]
						gen_is_afr_writeoff = NVL (i_gen_is_afr_writeoff, 'N'),
						gen_is_day_time_rest = NVL (i_gen_is_day_time_rest, 'N'),
						--Catch and PB CR END
						gen_metadata_verified = NVL (i_flag_metadata_verified, 'N'),
						--#region Abhinay_230512014 : New Field Metadata Verified
						--------
						gen_duration =
						   (  (SUBSTR (i_gen_duration_c, 1, 3) * 90000)
							+ (SUBSTR (i_gen_duration_c, 5, 2) * 1500)
							+ (SUBSTR (i_gen_duration_c, 8, 2) * 25)),
						--gen_update_count = gen_update_count + 1,
						-- Add by
						---- DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
						gen_tags = i_gen_tags,
						gen_africa_type_duration_c = i_gen_africa_type_duration_c,
						gen_africa_type_duration_s = i_gen_africa_type_duration_s,
						gen_africa_type_duration =
						   (  (SUBSTR (i_gen_duration_c, 1, 2) * 90000)
							+ (SUBSTR (i_gen_duration_c, 4, 2) * 1500)
							+ (SUBSTR (i_gen_duration_c, 7, 2) * 25)) ---- DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
																	 --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
						,
						gen_aka_title = i_aka_title,
						gen_catchup_category = i_gen_catchup_category -- added for CATCHUP:SHANTANU A._[12/01/2015]
																	 ,
						gen_catchup_priority = i_gen_catchup_priority -- added by Rashmi:CATCHUPCR[25-03-2015]
																	 ,
						gen_embargo_content =
						   DECODE (gen_embargo_content,
								   i_prog_embargo, gen_embargo_content,
								   i_prog_embargo)             --#endregion 6March2015
		 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
						,
            GEN_IS_CINEMA_EMBARGO_CONTENT = DECODE (GEN_IS_CINEMA_EMBARGO_CONTENT,I_IS_PROG_CINEMA_EMBARGO,
                                            GEN_IS_CINEMA_EMBARGO_CONTENT,I_IS_PROG_CINEMA_EMBARGO),--Onsite.Dev:BR_15_327
						GEN_PGA_DURATION = I_GEN_DURATION_PGA
				  --DEV.R4:Inventory Mining:End
            --bhagyashri
          ,  GEN_SVOD_EXPRESS = i_gen_SVOD_Express
          , GEN_CNT_RELEASE_UID = i_cnt_release_uid   --Added by Zeshan for 10Digit UID CR

	  ,GEN_IS_ARCHIVE_EMBARGO_CONTENT = DECODE (GEN_IS_ARCHIVE_EMBARGO_CONTENT,I_IS_PROG_ARCHIVE_EMBARGO,
                                            GEN_IS_ARCHIVE_EMBARGO_CONTENT,I_IS_PROG_ARCHIVE_EMBARGO) --Onsite.Dev:Added by Milind_25_10_2016   --Added by Zeshan for 10Digit UID CR
          ,GEN_TVOD_BO_CATEGORY_CODE  = i_GEN_TVOD_BO_CATEGORY_CODE
	   /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
          ,GEN_SCH_ARF_CUSTM    =  I_GEN_SCH_ARF_CUSTM
          ,GEN_TAP_SEQ_NO       =  I_GEN_TAP_SEQ_NO
          ,GEN_ADDINFO_COMMENTS =  I_GEN_ADDINFO_COMMENTS
          ,GEN_PRG_N_SCH_CHANNEL = I_AITW_PRG_N_SCH_CHANNEL
           /*Dev.R1: Scheduling CR Implementation: END */
				  WHERE gen_refno = i_gen_refno;

				 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[11-03-2015]
				 IF ( (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_duration_c), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (i_gen_duration_c), 0))
					 AND (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_pga_duration), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (I_GEN_DURATION_PGA), 0)))
				 THEN                                                          -- both
					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'PGA Duration');
				 ELSIF (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_pga_duration), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (I_GEN_DURATION_PGA), 0))
				 THEN                                                           -- PGA
					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'PGA Duration');
				 ELSIF (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_duration_c), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (i_gen_duration_c), 0))
				 THEN                                                     -- estimated
					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'Estimated Duration');
				 END IF;

				 --DEV.R4:Inventory Mining:End

				 --RDT Start Phoneix Req [Kiran][07-05-2014]
				 SELECT pkg_mm_mnet_pl_prgmaintenance.fun_convert_duration_c_n (
						   l_gen_dur_old),
						pkg_mm_mnet_pl_prgmaintenance.fun_convert_duration_c_n (
						   i_gen_duration_c)
				   INTO l_old_duration_c, l_new_duration_c
				   FROM DUAL;

				 FOR i
					IN (SELECT gen_refno,
							   sch_number,
							   sch_lic_number,
							   sch_time,
							   sch_end_time,
							   sch_date,
							   cha_short_name
						  FROM fid_schedule,
							   fid_general,
							   fid_license,
							   fid_channel
						 WHERE     sch_lic_number = lic_number
							   AND lic_gen_refno = gen_refno
							   AND cha_number = sch_cha_number
							   AND gen_refno = i_gen_refno
							   AND sch_date >= TRUNC(SYSDATE))
				 LOOP
					/*IF (i.sch_time + l_new_duration_c) >= 86400 --commented by Nasreen
					THEN
					   --DBMS_OUTPUT.put_line (' in greater than 86400');
					   l_temp_time := (i.sch_time + l_new_duration_c) - 86400;
					   --DBMS_OUTPUT.put_line (   ' in greater than 86400 temp time'
											 || ' '
											 || l_temp_time
											);

					   UPDATE fid_schedule
						  SET sch_end_time = l_temp_time
						WHERE sch_lic_number = i.sch_lic_number
						  AND sch_number = i.sch_number;
					ELSE
					   --DBMS_OUTPUT.put_line (' in else not greater than 86400');
					   l_temp_time := (i.sch_time + l_new_duration_c);
					   --DBMS_OUTPUT.put_line (
							 ' in else not greater than 86400 temp time'
						  || ' '
						  || l_temp_time);

					   UPDATE fid_schedule
						  SET sch_end_time = l_temp_time
						WHERE sch_lic_number = i.sch_lic_number
						  AND sch_number = i.sch_number;
					END IF;*/

					SELECT gen_duration_c,
						   NVL (gen_rating_mpaa, 0),
						   NVL (gen_rating_int, 0)
					  INTO l_gen_dur_new, l_gen_rat_mpaa_new, l_gen_rat_int_new
					  FROM fid_general
					 WHERE gen_refno = i_gen_refno;

					/*BEGIN -commented by Nasreen
					   IF l_gen_dur_old != l_gen_dur_new
					   THEN
						  INSERT INTO x_prg_change_history
									  (prg_gen_refno, prg_sch_time, prg_sch_date,
									   prg_lic_number, prg_cha_name,
									   prg_modified_attribute, prg_old_value,
									   prg_new_value, prg_entry_operator,
									   prg_entry_date
									  )
							   VALUES (i.gen_refno, i.sch_time, i.sch_date,
									   i.sch_lic_number, i.cha_short_name,
									   'Programme duration ', l_gen_dur_old,
									   l_gen_dur_new, i_entry_oper,
									   i_attributemodifieddatetime
									  );
					   END IF;
					EXCEPTION
					   WHEN OTHERS
					   THEN
						  NULL;
					END;*/

					BEGIN
					   IF l_gen_rat_mpaa_old != l_gen_rat_mpaa_new
					   THEN
						  INSERT INTO x_prg_change_history (prg_gen_refno,
															prg_sch_time,
															prg_sch_date,
															prg_lic_number,
															prg_cha_name,
															prg_modified_attribute,
															prg_old_value,
															prg_new_value,
															prg_entry_operator,
															prg_entry_date)
							   VALUES (i.gen_refno,
									   i.sch_time,
									   i.sch_date,
									   i.sch_lic_number,
									   i.cha_short_name,
									   'Domestic Age Restriction',
									   l_gen_rat_mpaa_old,
									   l_gen_rat_mpaa_new,
									   i_entry_oper,
									   i_attributemodifieddatetime);
					   --insert into x_temp values('Inside else i.sch_end_time '||l_GEN_RAT_MPAA_NEW ||'l_gen_dur_diff '||l_GEN_RAT_MPAA_NEW );
					   END IF;
					EXCEPTION
					   WHEN OTHERS
					   THEN
						  NULL;
					END;

					BEGIN
					   IF l_gen_rat_int_old != l_gen_rat_int_new
					   THEN
						  INSERT INTO x_prg_change_history (prg_gen_refno,
															prg_sch_time,
															prg_sch_date,
															prg_lic_number,
															prg_cha_name,
															prg_modified_attribute,
															prg_old_value,
															prg_new_value,
															prg_entry_operator,
															prg_entry_date)
							   VALUES (i.gen_refno,
									   i.sch_time,
									   i.sch_date,
									   i.sch_lic_number,
									   i.cha_short_name,
									   'Africa Age Restriction',
									   l_gen_rat_int_old,
									   l_gen_rat_int_new,
									   i_entry_oper,
									   i_attributemodifieddatetime);
					   END IF;
					EXCEPTION
					   WHEN OTHERS
					   THEN
						  NULL;
					END;
				 END LOOP;
			  --RDT End Phoneix Req [Kiran][07-05-2014]
			  ELSIF len_duration = 10
			  THEN
				 --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
				 IF (pkg_mm_mnet_pl_prgmaintenance.is_tvod_prog (i_gen_refno) = 1)
				 THEN
					UPDATE tbl_tva_dm_prog
					   SET dmprg_n_bo_category = i_gen_prog_category_code
					 WHERE dmprg_n_gen_refno = i_gen_refno;
				 END IF;

				 --Dev3: TVOD_CR: END :[TVOD_CR]
				 UPDATE fid_general fg
					-- Add by
					/*
					DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
					Colums
					gen_stu_code = NVL (i_gen_stu_code, fg.gen_stu_code),
					gen_colour = NVL (substr(i_gen_colour,1,2), fg.gen_colour),
					gen_code = NVL (i_gen_code, fg.gen_code),
					gen_widescreen = NVL (i_gen_widescreen, fg.gen_widescreen),
					gen_sub_title = NVL (i_gen_sub_title, fg.gen_sub_title),
					gen_music_title = NVL (i_gen_music_title, fg.gen_music_title),
					gen_poem_title = NVL (i_gen_poem_title, fg.gen_poem_title),
					gen_copy_restrictions =  NVL (i_gen_copy_restrictions, fg.gen_copy_restrictions),
					gen_abstract = NVL (i_gen_abstract, fg.gen_abstract),
					gen_nfa_copy = NVL (i_gen_nfa_copy, fg.gen_nfa_copy),
					gen_cat_complete = NVL (i_gen_cat_complete, fg.gen_cat_complete),
					gen_tx_digitized = NVL (i_gen_tx_digitized, fg.gen_tx_digitized),
					gen_archive = NVL (i_gen_archive, fg.gen_archive),
					gen_web_title = i_gen_web_title,
					DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
					*/
					SET                                 --GEN_DURATION=I_GEN_DURATION,
					   gen_title = NVL (i_gen_title, fg.gen_title),
						gen_title_working =
						   NVL (i_gen_title_working, fg.gen_title_working),
						gen_category = NVL (i_gen_category, fg.gen_category),
						gen_subgenre = i_gen_subgenre,
						-- NVL (i_gen_subgenre, fg.gen_subgenre),   RDT Audit
						gen_rating_mpaa = i_gen_rating_mpaa,
						--NVL (i_gen_rating_mpaa, fg.gen_rating_mpaa),RDT Audit
						gen_rating_int = NVL (i_gen_rating_int, fg.gen_rating_int),
						gen_quality = NVL (i_gen_quality, fg.gen_quality),
						gen_spoken_lang = NVL (i_gen_spoken_lang, fg.gen_spoken_lang),
						gen_series = NVL (i_gen_series, fg.gen_series),
						--gen_parent_refno = NVL (i_gen_parent_refno, fg.gen_parent_refno),
						gen_type = NVL (i_gen_type, fg.gen_type),
						gen_release_year =
						   NVL (i_gen_release_year, fg.gen_release_year),
						gen_nationality = NVL (i_gen_nationality, fg.gen_nationality),
						gen_duration_c = NVL (i_gen_duration_c, fg.gen_duration_c),
						gen_duration_s = NVL (i_gen_duration_s, fg.gen_duration_s),
						gen_epi_number = NVL (i_gen_epi_number, fg.gen_epi_number),
						gen_award = NVL (i_gen_award, fg.gen_award),
						gen_target_group =
						   NVL (i_gen_target_group, fg.gen_target_group),
						gen_comment = NVL (i_gen_comment, fg.gen_comment),
						/* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */
						gen_re_tx_warning = decode(l_gen_tx_old, 0, null, i_gen_re_tx_warning),
					--	gen_re_tx_warning = l_gen_txt_warnning,--REMOVED BY [--Ankur Kasar[scheduling CR's IMPLEMENATTION]]
						gen_entry_oper = i_entry_oper,
						gen_entry_date = SYSDATE,
						--###Bioscope added###-----
						gen_rating_imdb = i_imdb_rating,
						gen_rating_ar = i_ar_rating,
						gen_rating_expert_meta_critic = i_expert_rating,
						gen_bo_category_code = i_bo_category,
						gen_bo_revenue_usd = i_usd_revenue,
						gen_bo_revenue_zar = i_zar_revenue,
						gen_final_grade = i_final_grade,
						gen_prog_category_code = i_gen_prog_category_code,
						gen_tertiary_genre = i_gen_tertiary_genre,
						gen_web_title = i_web_title,
						-- kunal 02-03-2015 START: Production Number
						gen_production_number = i_gen_production_number,
						-- kunal : END Production Number
						--START: PROJECT BIOSCOPE ? PENDING CR?S: Mangesh Gulhane_20121003
						-- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
						gen_mood = i_gen_mood,
						gen_link_poster_art = i_gen_link_poster_art,
						--END: PROJECT BIOSCOPE ? PENDING CR?S:
						--Catch and PB CR[SCH 32][Mangesh Gulhane][13-AUG-13][Added column for AFR writeoff]
						gen_is_afr_writeoff = NVL (i_gen_is_afr_writeoff, 'N'),
						gen_is_day_time_rest = NVL (i_gen_is_day_time_rest, 'N'),
						--Catch and PB CR END
						gen_metadata_verified = NVL (i_flag_metadata_verified, 'N'),
						--#region Abhinay_230512014 : New Field Metadata Verified
						--------
						gen_duration =
						   (  (SUBSTR (i_gen_duration_c, 1, 4) * 90000)
							+ (SUBSTR (i_gen_duration_c, 6, 2) * 1500)
							+ (SUBSTR (i_gen_duration_c, 9, 2) * 25)),
						--gen_update_count = gen_update_count + 1,
						-- Add by
						---- DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
						gen_tags = i_gen_tags,
						gen_africa_type_duration_c = i_gen_africa_type_duration_c,
						gen_africa_type_duration_s = i_gen_africa_type_duration_s,
						gen_africa_type_duration =
						   (  (SUBSTR (i_gen_duration_c, 1, 2) * 90000)
							+ (SUBSTR (i_gen_duration_c, 4, 2) * 1500)
							+ (SUBSTR (i_gen_duration_c, 7, 2) * 25)) ---- DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
																	 --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
						,
						gen_aka_title = i_aka_title,
						gen_catchup_category = i_gen_catchup_category -- added for CATCHUP:SHANTANU A._[12/01/2015]
																	 ,
						gen_catchup_priority = i_gen_catchup_priority -- added by Rashmi:CATCHUPCR[25-03-2015]
																	 --#region 6March2015: EmbargoContent Save Logic Change
						,
						gen_embargo_content =
						   DECODE (gen_embargo_content,
								   i_prog_embargo, gen_embargo_content,
								   i_prog_embargo)             --#endregion 6March2015
		 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
						,

            GEN_IS_CINEMA_EMBARGO_CONTENT = DECODE (GEN_IS_CINEMA_EMBARGO_CONTENT,I_IS_PROG_CINEMA_EMBARGO,
                                            GEN_IS_CINEMA_EMBARGO_CONTENT,I_IS_PROG_CINEMA_EMBARGO),--Onsite.Dev:BR_15_327

						GEN_PGA_DURATION = I_GEN_DURATION_PGA
				  --DEV.R4:Inventory Mining:End
            --bhagyashri
          ,  GEN_SVOD_EXPRESS = i_gen_SVOD_Express
          ,  GEN_CNT_RELEASE_UID = i_cnt_release_uid    --Added by Zeshan for 10Digit UID CR

	    ,  GEN_IS_ARCHIVE_EMBARGO_CONTENT = DECODE (GEN_IS_ARCHIVE_EMBARGO_CONTENT,I_IS_PROG_ARCHIVE_EMBARGO,
                                            GEN_IS_ARCHIVE_EMBARGO_CONTENT,I_IS_PROG_ARCHIVE_EMBARGO) --Onsite.Dev:Added by Milind_25_10_2016
          ,GEN_TVOD_BO_CATEGORY_CODE  = i_GEN_TVOD_BO_CATEGORY_CODE
	   /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
          ,GEN_SCH_ARF_CUSTM    =  I_GEN_SCH_ARF_CUSTM
          ,GEN_TAP_SEQ_NO       =  I_GEN_TAP_SEQ_NO
          ,GEN_ADDINFO_COMMENTS =  I_GEN_ADDINFO_COMMENTS
          ,GEN_PRG_N_SCH_CHANNEL = I_AITW_PRG_N_SCH_CHANNEL
           /*Dev.R1: Scheduling CR Implementation: END */
				  WHERE gen_refno = i_gen_refno;

				 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[11-03-2015]
				 IF ( (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_duration_c), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (i_gen_duration_c), 0))
					 AND (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_pga_duration), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (I_GEN_DURATION_PGA), 0)))
				 THEN                                                          -- both
					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'PGA Duration');
				 ELSIF (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_pga_duration), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (I_GEN_DURATION_PGA), 0))
				 THEN                                                           -- PGA
					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'PGA Duration');
				 ELSIF (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_duration_c), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (i_gen_duration_c), 0))
				 THEN                                                     -- estimated
					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'Estimated Duration');
				 END IF;

				 --RDT Start Phoneix Req [Kiran][07-05-2014]
				 SELECT pkg_mm_mnet_pl_prgmaintenance.fun_convert_duration_c_n (
						   l_gen_dur_old),
						pkg_mm_mnet_pl_prgmaintenance.fun_convert_duration_c_n (
						   i_gen_duration_c)
				   INTO l_old_duration_c, l_new_duration_c
				   FROM DUAL;

				 FOR i
					IN (SELECT gen_refno,
							   sch_number,
							   sch_lic_number,
							   sch_time,
							   sch_end_time,
							   sch_date,
							   cha_short_name,
							   --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
							   cha_number
						  --DEV.R4:Inventory Mining:End
						  FROM fid_schedule,
							   fid_general,
							   fid_license,
							   fid_channel
						 WHERE     sch_lic_number = lic_number
							   AND lic_gen_refno = gen_refno
							   AND cha_number = sch_cha_number
							   AND gen_refno = i_gen_refno
							   AND sch_date >= TRUNC(SYSDATE))
				 LOOP
					/*IF (i.sch_time + l_new_duration_c) >= 86400  -- commented by Nasreen
					THEN
					   --DBMS_OUTPUT.put_line (' in greater than 86400');
					   l_temp_time := (i.sch_time + l_new_duration_c) - 86400;
					   --DBMS_OUTPUT.put_line (   ' in greater than 86400 temp time'
											 || ' '
											 || l_temp_time
											);

					   UPDATE fid_schedule
						  SET sch_end_time = l_temp_time
						WHERE sch_lic_number = i.sch_lic_number
						  AND sch_number = i.sch_number;
					ELSE
					   --DBMS_OUTPUT.put_line (' in else not greater than 86400');
					   l_temp_time := (i.sch_time + l_new_duration_c);
					   --DBMS_OUTPUT.put_line
									  (   ' in else not greater than 86400 temp time'
									   || ' '
									   || l_temp_time
									  );

					   UPDATE fid_schedule
						  SET sch_end_time = l_temp_time
						WHERE sch_lic_number = i.sch_lic_number
						  AND sch_number = i.sch_number;
					END IF;*/

					SELECT gen_duration_c,
						   NVL (gen_rating_mpaa, 0),
						   NVL (gen_rating_int, 0)
					  INTO l_gen_dur_new, l_gen_rat_mpaa_new, l_gen_rat_int_new
					  FROM fid_general
					 WHERE gen_refno = i_gen_refno;

					/*BEGIN  --commented by Nasreen
					   IF l_gen_dur_old != l_gen_dur_new
					   THEN
						  INSERT INTO x_prg_change_history
									  (prg_gen_refno, prg_sch_time, prg_sch_date,
									   prg_lic_number, prg_cha_name,
									   prg_modified_attribute, prg_old_value,
									   prg_new_value, prg_entry_operator,
									   prg_entry_date
									  )
							   VALUES (i.gen_refno, i.sch_time, i.sch_date,
									   i.sch_lic_number, i.cha_short_name,
									   'Programme duration ', l_gen_dur_old,
									   l_gen_dur_new, i_entry_oper,
									   i_attributemodifieddatetime
									  );
					   END IF;
					EXCEPTION
					   WHEN OTHERS
					   THEN
						  NULL;
					END; */

					BEGIN
					   IF l_gen_rat_mpaa_old != l_gen_rat_mpaa_new
					   THEN
						  INSERT INTO x_prg_change_history (prg_gen_refno,
															prg_sch_time,
															prg_sch_date,
															prg_lic_number,
															prg_cha_name,
															prg_modified_attribute,
															prg_old_value,
															prg_new_value,
															prg_entry_operator,
															prg_entry_date)
							   VALUES (i.gen_refno,
									   i.sch_time,
									   i.sch_date,
									   i.sch_lic_number,
									   i.cha_short_name,
									   'Domestic Age Restriction',
									   l_gen_rat_mpaa_old,
									   l_gen_rat_mpaa_new,
									   i_entry_oper,
									   i_attributemodifieddatetime);
					   END IF;
					EXCEPTION
					   WHEN OTHERS
					   THEN
						  NULL;
					END;

					BEGIN
					   IF l_gen_rat_int_old != l_gen_rat_int_new
					   THEN
						  INSERT INTO x_prg_change_history (prg_gen_refno,
															prg_sch_time,
															prg_sch_date,
															prg_lic_number,
															prg_cha_name,
															prg_modified_attribute,
															prg_old_value,
															prg_new_value,
															prg_entry_operator,
															prg_entry_date)
							   VALUES (i.gen_refno,
									   i.sch_time,
									   i.sch_date,
									   i.sch_lic_number,
									   i.cha_short_name,
									   'Africa Age Restriction',
									   l_gen_rat_int_old,
									   l_gen_rat_int_new,
									   i_entry_oper,
									   i_attributemodifieddatetime);
					   END IF;
					EXCEPTION
					   WHEN OTHERS
					   THEN
						  NULL;
					END;
				 END LOOP;
			  --RDT End Phoneix Req [Kiran][07-05-2014]
			  ELSIF len_duration IS NULL
			  THEN
				 --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
				 IF (pkg_mm_mnet_pl_prgmaintenance.is_tvod_prog (i_gen_refno) = 1)
				 THEN
					UPDATE tbl_tva_dm_prog
					   SET dmprg_n_bo_category = i_gen_prog_category_code
					 WHERE dmprg_n_gen_refno = i_gen_refno;
				 END IF;

				 --Dev3: TVOD_CR: END :[TVOD_CR]
				 UPDATE fid_general fg
					-- Add by
					/*
					DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
					Colums
					gen_stu_code = NVL (i_gen_stu_code, fg.gen_stu_code),
					gen_colour = NVL (substr(i_gen_colour,1,2), fg.gen_colour),
					gen_code = NVL (i_gen_code, fg.gen_code),
					gen_widescreen = NVL (i_gen_widescreen, fg.gen_widescreen),
					gen_sub_title = NVL (i_gen_sub_title, fg.gen_sub_title),
					gen_music_title = NVL (i_gen_music_title, fg.gen_music_title),
					gen_poem_title = NVL (i_gen_poem_title, fg.gen_poem_title),
					gen_copy_restrictions =  NVL (i_gen_copy_restrictions, fg.gen_copy_restrictions),
					gen_abstract = NVL (i_gen_abstract, fg.gen_abstract),
					gen_nfa_copy = NVL (i_gen_nfa_copy, fg.gen_nfa_copy),
					gen_cat_complete = NVL (i_gen_cat_complete, fg.gen_cat_complete),
					gen_tx_digitized = NVL (i_gen_tx_digitized, fg.gen_tx_digitized),
					gen_archive = NVL (i_gen_archive, fg.gen_archive),
					gen_web_title = i_gen_web_title,
					DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
					*/
					SET                                 --GEN_DURATION=I_GEN_DURATION,
					   gen_title = NVL (i_gen_title, fg.gen_title),
						gen_title_working =
						   NVL (i_gen_title_working, fg.gen_title_working),
						gen_category = NVL (i_gen_category, fg.gen_category),
						gen_subgenre = i_gen_subgenre,
						-- NVL (i_gen_subgenre, fg.gen_subgenre),   RDT Audit
						gen_rating_mpaa = i_gen_rating_mpaa,
						--NVL (i_gen_rating_mpaa, fg.gen_rating_mpaa),RDT Audit
						gen_rating_int = NVL (i_gen_rating_int, fg.gen_rating_int),
						gen_quality = NVL (i_gen_quality, fg.gen_quality),
						gen_spoken_lang = NVL (i_gen_spoken_lang, fg.gen_spoken_lang),
						gen_series = NVL (i_gen_series, fg.gen_series),
						--gen_parent_refno = NVL (i_gen_parent_refno, fg.gen_parent_refno),
						gen_type = NVL (i_gen_type, fg.gen_type),
						gen_release_year =
						   NVL (i_gen_release_year, fg.gen_release_year),
						gen_nationality = NVL (i_gen_nationality, fg.gen_nationality),
						gen_duration_c = NVL (i_gen_duration_c, fg.gen_duration_c),
						gen_duration_s = NVL (i_gen_duration_s, fg.gen_duration_s),
						gen_epi_number = NVL (i_gen_epi_number, fg.gen_epi_number),
						gen_award = NVL (i_gen_award, fg.gen_award),
						gen_target_group =
						   NVL (i_gen_target_group, fg.gen_target_group),
						gen_comment = NVL (i_gen_comment, fg.gen_comment),
						/* RDT :MOP_CR_12.2 :Abhishek Mor 06/08/2014 :code section removed for -Restricting creation of duplicate Titles on Programme Maintenance */
						gen_re_tx_warning =  decode(l_gen_tx_old, 0, null, i_gen_re_tx_warning),
						--gen_re_tx_warning = l_gen_txt_warnning,--REMOVED BY [--Ankur Kasar[scheduling CR's IMPLEMENATTION]]
						gen_entry_oper = i_entry_oper,
						gen_entry_date = SYSDATE,
						--###Bioscope added###-----
						gen_rating_imdb = i_imdb_rating,
						gen_rating_ar = i_ar_rating,
						gen_rating_expert_meta_critic = i_expert_rating,
						gen_bo_category_code = i_bo_category,
						gen_bo_revenue_usd = i_usd_revenue,
						gen_bo_revenue_zar = i_zar_revenue,
						gen_final_grade = i_final_grade,
						gen_prog_category_code = i_gen_prog_category_code,
						gen_tertiary_genre = i_gen_tertiary_genre,
						gen_web_title = i_web_title,
						-- kunal 02-03-2015 START: Production Number
						gen_production_number = i_gen_production_number,
						-- kunal : END Production Number
						--START: PROJECT BIOSCOPE ? PENDING CR?S: Mangesh Gulhane_20121003
						-- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
						gen_mood = i_gen_mood,
						gen_link_poster_art = i_gen_link_poster_art,
						--END: PROJECT BIOSCOPE ? PENDING CR?S:
						--Catch and PB CR[SCH 32][Mangesh Gulhane][13-AUG-13][Added column for AFR writeoff]
						gen_is_afr_writeoff = NVL (i_gen_is_afr_writeoff, 'N'),
						gen_is_day_time_rest = NVL (i_gen_is_day_time_rest, 'N'),
						--Catch and PB CR END
						gen_metadata_verified = NVL (i_flag_metadata_verified, 'N'),
						--#region Abhinay_230512014 : New Field Metadata Verified
						--------
						gen_duration = i_gen_duration_c,
						--gen_update_count = gen_update_count + 1,
						-- Add by
						---- DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
						gen_tags = i_gen_tags,
						gen_africa_type_duration_c = i_gen_africa_type_duration_c,
						gen_africa_type_duration_s = i_gen_africa_type_duration_s,
						gen_africa_type_duration =
						   (  (SUBSTR (i_gen_duration_c, 1, 2) * 90000)
							+ (SUBSTR (i_gen_duration_c, 4, 2) * 1500)
							+ (SUBSTR (i_gen_duration_c, 7, 2) * 25)) ---- DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
																	 --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
						,
						gen_aka_title = i_aka_title,
						gen_catchup_category = i_gen_catchup_category -- added for CATCHUP:SHANTANU A._[12/01/2015]
																	 ,
						gen_catchup_priority = i_gen_catchup_priority -- added by Rashmi:CATCHUPCR[25-03-2015]
																	 --#region 6March2015: EmbargoContent Save Logic Change
						,
						gen_embargo_content =
						   DECODE (gen_embargo_content,
								   i_prog_embargo, gen_embargo_content,
								   i_prog_embargo)             --#endregion 6March2015
		 --DEV.R4:Synergy M-Net:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
						,
            GEN_IS_CINEMA_EMBARGO_CONTENT = DECODE (GEN_IS_CINEMA_EMBARGO_CONTENT,I_IS_PROG_CINEMA_EMBARGO,
                                            GEN_IS_CINEMA_EMBARGO_CONTENT,I_IS_PROG_CINEMA_EMBARGO),--Onsite.Dev:BR_15_327
						GEN_PGA_DURATION = I_GEN_DURATION_PGA
				  --DEV.R4:Synergy M-Net:End
            --bhagyashri
          ,  GEN_SVOD_EXPRESS = i_gen_SVOD_Express
          ,  GEN_CNT_RELEASE_UID = i_cnt_release_uid    --Added by Zeshan for 10Digit UID CR

	   ,  GEN_IS_ARCHIVE_EMBARGO_CONTENT = DECODE (GEN_IS_ARCHIVE_EMBARGO_CONTENT,I_IS_PROG_ARCHIVE_EMBARGO,
                                            GEN_IS_ARCHIVE_EMBARGO_CONTENT,I_IS_PROG_ARCHIVE_EMBARGO) --Onsite.Dev:Added by Milind_25_10_2016
          ,GEN_TVOD_BO_CATEGORY_CODE  = i_GEN_TVOD_BO_CATEGORY_CODE
	   /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[31-08-2016]*/
          ,GEN_SCH_ARF_CUSTM    =  I_GEN_SCH_ARF_CUSTM
          ,GEN_TAP_SEQ_NO       =  I_GEN_TAP_SEQ_NO
          ,GEN_ADDINFO_COMMENTS =  I_GEN_ADDINFO_COMMENTS
          ,GEN_PRG_N_SCH_CHANNEL = I_AITW_PRG_N_SCH_CHANNEL
           /*Dev.R1: Scheduling CR Implementation: END */
				  WHERE gen_refno = i_gen_refno;
			  END IF;

         /* BR_15_168_UC_LicensedContents for CR Svod Rights[Vikas Srivastava] [19-04-2016] */

   BEGIN
          SELECT cod_attr1
             INTO l_is_series_flag
          FROM fid_general, fid_code
          WHERE gen_type = cod_value
            AND cod_type = 'GEN_TYPE'
            AND gen_refno = i_gen_refno;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
            l_is_series_flag := 'N';
    END;


     IF(l_is_series_flag ='Y')
      THEN
        /* Udated all episode for a series with same category and priority by vikas Srivastava [31 Mar 2016]*/
          UPDATE fid_general
             SET gen_catchup_category = i_gen_catchup_category,
                 gen_catchup_priority = i_gen_catchup_priority
           WHERE gen_refno IN (SELECT gen_refno FROM fid_general WHERE gen_ser_number IN (
                                 SELECT gen_ser_number FROM fid_general WHERE gen_refno =i_gen_refno));
             /* End Udated all episode for a series with same category and priority by vikas Srivastava [31 Mar 2016] */
    END IF;
			  SELECT gen_update_count                       --added by Kiran RDT Audit
				INTO l_gen_update_count
				FROM fid_general
			   WHERE gen_refno = i_gen_refno;

			  IF NVL (i_gen_update_cnt, 0) = NVL (l_gen_update_count, 0)
			  --added by Kiran
			  THEN
				 UPDATE fid_general
					SET gen_update_count = NVL (gen_update_count, 0) + 1
				  WHERE gen_refno = i_gen_refno -- RETURNING GEN_UPDATE_COUNT into o_gen_updatecount
											   ;

				 COMMIT;

				 --  else
				 SELECT gen_update_count                              --added by Kiran
				   INTO l_gen_update_count
				   FROM fid_general
				  WHERE gen_refno = i_gen_refno;

				 o_gen_updatecount := NVL (l_gen_update_count, 0);

				 --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[11-03-2015]
				 IF ( (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_duration_c), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (i_gen_duration_c), 0))
					 AND (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_pga_duration), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (I_GEN_DURATION_PGA), 0)))
				 THEN                                                          -- both

					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'PGA Duration');
				 ELSIF (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_pga_duration), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (I_GEN_DURATION_PGA), 0))
				 THEN                                                           -- PGA

					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'PGA Duration');
				 ELSIF (NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (l_gen_duration_c), 0) != NVL (X_PKG_CP_PLAY_LIST.fun_convert_duration_c_n (i_gen_duration_c), 0)) -- estimated
				 THEN

					X_PKG_UPDATE_SCHEDULE.x_prc_get_tap_number (i_gen_refno,
																'Estimated Duration');
				 END IF;
			  --DEV.R4:Inventory Mining:End
			  ELSE
				 raise_application_error (
					-20001,
					   'The program details for programme refno - '
					|| i_gen_refno
					|| ' is already modified by another user.');
			  END IF;

			  --ELSE

			  --raise_application_error(-20001,'The program details for programme refno - '|| i_gen_refno || ' is already modified by another user.');

			  --end if;

			  ----changes by pranay end
			  -- Code added by Omkar for the issue reported by Desire
			  -- Code Started.
			  UPDATE sak_memo_item smi
				 SET mei_type_show = NVL (i_gen_type, smi.mei_type_show)
			   WHERE mei_gen_refno = i_gen_refno AND mei_type_show = l_gen_type;

			  -- Code Ended.
			  l_text := l_text || 'Programme Information Block';
		end if; -- Synopis_editor role check end

    -- Special case added by Sandip to handle short form Synopsis
    If I_gen_comment Is Not Null  And l_is_synopsis_editor = 1 Then
      update fid_general fg
      set gen_comment = NVL (i_gen_comment, fg.gen_comment),
          gen_entry_oper = i_entry_oper,
          gen_entry_date = SYSDATE
      WHERE gen_refno = i_gen_refno;

          SELECT gen_update_count                              --added by Kiran
				   INTO l_gen_update_count
				   FROM fid_general
				  WHERE gen_refno = i_gen_refno;

          IF NVL (i_gen_update_cnt, 0) = NVL (l_gen_update_count, 0)
            --added by Kiran
            THEN
             UPDATE fid_general
              SET gen_update_count = NVL (gen_update_count, 0) + 1
              WHERE gen_refno = i_gen_refno -- RETURNING GEN_UPDATE_COUNT into o_gen_updatecount
                             ;

             COMMIT;

             --  else
             SELECT gen_update_count                              --added by Kiran
               INTO l_gen_update_count
               FROM fid_general
              WHERE gen_refno = i_gen_refno;

             o_gen_updatecount := NVL (l_gen_update_count, 0);
         ELSE
             raise_application_error (
              -20001,
                 'The program details for programme refno - '
              || i_gen_refno
              || ' is already modified by another user.');
        END IF;

    END IF;
    -- Chnages By Sandip : End

    /*  SELECT COUNT (*)
        INTO l_local_count
        FROM fid_synopsis
       WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 1;

      IF (l_local_count = 0)
      THEN
         IF (i_synopsis_id_local = 1)
         THEN
            BEGIN
               SELECT COUNT (0)
                 INTO l_local_count_exist
                 FROM fid_synopsis
                WHERE syn_gen_refno = i_gen_refno AND syn_syt_id IS NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_local_count_exist := 0;
            END;

            IF l_local_count_exist > 0
            THEN
               UPDATE fid_synopsis fs
                  SET syn_synopsis = i_syn_synopsis_local,
                      -- NVL (i_syn_synopsis_local, fs.syn_synopsis),
                      syn_syt_id = NVL (i_synopsis_id_local, fs.syn_syt_id),
                      --Dev.R10 : Audit on Program Maintenance : Start : [Devashish Raverkar]_[2015/10/09]
                      --syn_entry_oper = i_entry_oper,
                      --syn_entry_date = SYSDATE,
                      syn_modified_by = i_entry_oper,
                      syn_modified_date = sysdate,
                      --Dev.R10 : Audit on Program Maintenance : End
                      syn_update_count = syn_update_count + 1
                WHERE syn_gen_refno = i_gen_refno
                      AND NVL (fs.syn_syt_id, i_synopsis_id_local) = 1;
            ELSE
               INSERT INTO fid_synopsis (syn_gen_refno,
                                         syn_syt_id,
                                         syn_synopsis,
                                         syn_entry_oper,
                                         syn_entry_date,
                                         syn_id)
                    VALUES (i_gen_refno,
                            i_synopsis_id_local,
                            i_syn_synopsis_local,
                            i_entry_oper,
                            SYSDATE,
                             x_seq_syn_id.nextval);
            END IF;
         END IF;
      ELSE
         IF (i_synopsis_id_local = 1)
         THEN
            UPDATE fid_synopsis fs
               SET syn_synopsis = i_syn_synopsis_local,
                   --NVL (i_syn_synopsis_local, fs.syn_synopsis),
                   syn_syt_id = NVL (i_synopsis_id_local, fs.syn_syt_id),
                   --Dev.R10 : Audit on Program Maintenance : Start : [Devashish Raverkar]_[2015/10/09]
                   --syn_entry_oper = i_entry_oper,
                   --syn_entry_date = SYSDATE,
                   syn_modified_by = i_entry_oper,
                   syn_modified_date = sysdate,
                   --Dev.R10 : Audit on Program Maintenance : End
                   syn_update_count = syn_update_count + 1
             WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 1;
         END IF;
      END IF;

      SELECT COUNT (*)
        INTO l_full_count
        FROM fid_synopsis
       WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 2;

      IF (l_full_count = 0)
      THEN
         IF (i_synopsis_id_full = 2)
         THEN
            BEGIN
               SELECT COUNT (0)
                 INTO l_full_count_exist
                 FROM fid_synopsis
                WHERE syn_gen_refno = i_gen_refno AND syn_syt_id IS NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_full_count_exist := 0;
            END;

            IF l_full_count_exist > 0
            THEN
               UPDATE fid_synopsis fs
                  SET syn_synopsis = i_syn_synopsis_full,
                      --NVL (i_syn_synopsis_full, fs.syn_synopsis),
                      syn_syt_id = NVL (i_synopsis_id_full, fs.syn_syt_id),
                      --Dev.R10 : Audit on Program Maintenance : Start : [Devashish Raverkar]_[2015/10/09]
                      --syn_entry_oper = i_entry_oper,
                      --syn_entry_date = SYSDATE,
                      syn_modified_by = i_entry_oper,
                      syn_modified_date = sysdate,
                      --Dev.R10 : Audit on Program Maintenance : End
                      syn_update_count = syn_update_count + 1
                WHERE syn_gen_refno = i_gen_refno
                      AND NVL (fs.syn_syt_id, i_synopsis_id_full) = 2;
            ELSE
               INSERT INTO fid_synopsis (syn_gen_refno,
                                         syn_syt_id,
                                         syn_synopsis,
                                         syn_entry_oper,
                                         syn_entry_date,
                                         syn_id)
                    VALUES (i_gen_refno,
                            i_synopsis_id_full,
                            i_syn_synopsis_full,
                            i_entry_oper,
                            SYSDATE,
                             x_seq_syn_id.nextval);
            END IF;
         END IF;
      ELSE
         IF (i_synopsis_id_full = 2)
         THEN
            UPDATE fid_synopsis fs
               SET syn_synopsis = i_syn_synopsis_full,
                   ----NVL (i_syn_synopsis_full, fs.syn_synopsis),
                   syn_syt_id = NVL (i_synopsis_id_full, fs.syn_syt_id),
                   --Dev.R10 : Audit on Program Maintenance : Start : [Devashish Raverkar]_[2015/10/09]
                   --syn_entry_oper = i_entry_oper,
                   --syn_entry_date = SYSDATE,
                   syn_modified_by = i_entry_oper,
                   syn_modified_date = sysdate,
                   --Dev.R10 : Audit on Program Maintenance : End
                   syn_update_count = syn_update_count + 1
             WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 2;
         END IF;
      END IF;

      --******************************TVOD-Added*********************************************
      SELECT COUNT (*)
        INTO l_local_count
        FROM fid_synopsis
       WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 3;

      IF (l_local_count = 0)
      THEN
         IF (i_syn_synopsisid_web = 3)
         THEN
            INSERT INTO fid_synopsis (syn_gen_refno,
                                      syn_syt_id,
                                      syn_synopsis,
                                      syn_entry_oper,
                                      syn_entry_date,
                                      syn_id)
                 VALUES (i_gen_refno,
                         i_syn_synopsisid_web,
                         i_syn_synopsisdetails_web,
                         USER,
                         SYSDATE,
                          x_seq_syn_id.nextval);
         END IF;
      ELSE
         IF (i_syn_synopsisid_web = 3)
         THEN
            UPDATE fid_synopsis fs
               SET syn_synopsis =
                      NVL (i_syn_synopsisdetails_web, fs.syn_synopsis),
                   syn_syt_id = NVL (i_syn_synopsisid_web, fs.syn_syt_id),
                   --Dev.R10 : Audit on Program Maintenance : Start : [Devashish Raverkar]_[2015/10/09]
                   --syn_entry_oper = USER,
                   --syn_entry_date = SYSDATE,
                   syn_modified_by = i_entry_oper,
                   syn_modified_date = sysdate,
                   --Dev.R10 : Audit on Program Maintenance : End
                   syn_update_count = syn_update_count + 1
             WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 3;
         END IF;
      END IF;

      SELECT COUNT (*)
        INTO l_local_count
        FROM fid_synopsis
       WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 4;

      IF (l_local_count = 0)
      THEN
         IF (i_syn_synopsisid_mob = 4)
         THEN
            INSERT INTO fid_synopsis (syn_gen_refno,
                                      syn_syt_id,
                                      syn_synopsis,
                                      syn_entry_oper,
                                      syn_entry_date,
                                      syn_id)
                 VALUES (i_gen_refno,
                         i_syn_synopsisid_mob,
                         i_syn_synopsisdetails_mob,
                         USER,
                         SYSDATE,
                          x_seq_syn_id.nextval);
         END IF;
      ELSE
         IF (i_syn_synopsisid_mob = 4)
         THEN
            UPDATE fid_synopsis fs
               SET syn_synopsis =
                      NVL (i_syn_synopsisdetails_mob, fs.syn_synopsis),
                   syn_syt_id = NVL (i_syn_synopsisid_mob, fs.syn_syt_id),
                   --Dev.R10 : Audit on Program Maintenance : Start : [Devashish Raverkar]_[2015/10/09]
                   --syn_entry_oper = USER,
                   --syn_entry_date = SYSDATE,
                   syn_modified_by = i_entry_oper,
                   syn_modified_date = sysdate,
                   --Dev.R10 : Audit on Program Maintenance : End
                   syn_update_count = syn_update_count + 1
             WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 4;
         END IF;
      END IF;

      SELECT COUNT (*)
        INTO l_local_count
        FROM fid_synopsis
       WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 5;

      IF (l_local_count = 0)
      THEN
         IF (i_syn_synopsisid_epg = 5)
         THEN
            INSERT INTO fid_synopsis (syn_gen_refno,
                                      syn_syt_id,
                                      syn_synopsis,
                                      syn_entry_oper,
                                      syn_entry_date,
                                      syn_id)
                 VALUES (i_gen_refno,
                         i_syn_synopsisid_epg,
                         i_syn_synopsisdetails_epg,
                         USER,
                         SYSDATE,
                          x_seq_syn_id.nextval);
         END IF;
      ELSE
         IF (i_syn_synopsisid_epg = 5)
         THEN
            UPDATE fid_synopsis fs
               SET syn_synopsis =
                      NVL (i_syn_synopsisdetails_epg, fs.syn_synopsis),
                   syn_syt_id = NVL (i_syn_synopsisid_epg, fs.syn_syt_id),
                   --Dev.R10 : Audit on Program Maintenance : Start : [Devashish Raverkar]_[2015/10/09]
                   --syn_entry_oper = USER,
                   --syn_entry_date = SYSDATE,
                   syn_modified_by = i_entry_oper,
                   syn_modified_date = sysdate,
                   --Dev.R10 : Audit on Program Maintenance : End
                   syn_update_count = syn_update_count + 1
             WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 5;
         END IF;
      END IF;

      --*****************************TVOD-END************************************************
      --Added by Pravin_20130111[Supplier Synopsis]
      SELECT COUNT (*)
        INTO l_local_count
        FROM fid_synopsis
       WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 6;

      IF (l_local_count = 0)
      THEN
         IF (i_syn_synopsisid_supplier = 6)
         THEN
            INSERT INTO fid_synopsis (syn_gen_refno,
                                      syn_syt_id,
                                      syn_synopsis,
                                      syn_entry_oper,
                                      syn_entry_date,
                                      syn_id)
                 VALUES (i_gen_refno,
                         i_syn_synopsisid_supplier,
                         i_syn_synopsisdetails_supplier,
                         USER,
                         SYSDATE,
                          x_seq_syn_id.nextval);
         END IF;
      ELSE
         IF (i_syn_synopsisid_supplier = 6)
         THEN
            UPDATE fid_synopsis fs
               SET syn_synopsis =
                      NVL (i_syn_synopsisdetails_supplier, fs.syn_synopsis),
                   syn_syt_id = NVL (i_syn_synopsisid_supplier, fs.syn_syt_id),
                   --Dev.R10 : Audit on Program Maintenance : Start : [Devashish Raverkar]_[2015/10/09]
                   --syn_entry_oper = USER,
                   --syn_entry_date = SYSDATE,
                   syn_modified_by = i_entry_oper,
                   syn_modified_date = sysdate,
                   --Dev.R10 : Audit on Program Maintenance : End
                   syn_update_count = syn_update_count + 1
             WHERE syn_gen_refno = i_gen_refno AND syn_syt_id = 6;
         END IF;
      END IF;*/

      --Pravin- End
      SELECT COUNT (*)
        INTO l_fs_count
        FROM fid_synopsis
       WHERE syn_gen_refno = i_gen_refno;

     -- --DBMS_OUTPUT.put_line ('COUNT AFTER INSERT ' || l_fs_count);

      SELECT COUNT (*)
        INTO l_fgl_count
        FROM fid_gen_live
       WHERE fgl_gen_refno = i_gen_refno;

      IF (l_fgl_count = 0)
      THEN
         INSERT
           INTO fid_gen_live (fgl_gen_refno --, fgl_venue, fgl_location ,fgl_live_date, fgl_time
                                           , fgl_entry_oper, fgl_entry_date)
         VALUES (i_gen_refno -- , i_fgl_venue,i_fgl_location,i_fgl_live_date, i_fgl_time
                            , i_entry_oper, SYSDATE);
      ELSE
         UPDATE fid_gen_live fglive
            SET             --fgl_venue = NVL (i_fgl_venue, fglive.fgl_venue),
              --     fgl_location = NVL (i_fgl_location, fglive.fgl_location),
            --    fgl_live_date = NVL (i_fgl_live_date, fglive.fgl_live_date),
                           --    fgl_time = NVL (i_fgl_time, fglive.fgl_time),
                fgl_entry_oper = i_entry_oper,
                fgl_entry_date = SYSDATE,
                fgl_update_count = fgl_update_count + 1
          WHERE fgl_gen_refno = i_gen_refno;
      END IF;

      /* SELECT COUNT(*)
      INTO L_FP_COUNT
      FROM fid_production
      WHERE pro_gen_refno= i_gen_refno;
      IF (L_FP_COUNT = 0 )
      THEN
      INSERT INTO fid_production
      (pro_gen_refno   ,  pro_title
      ,pro_number   ,  fid_production.pro_status
      ,pro_entry_date  ,  pro_entry_oper
      )
      VALUES
      (i_gen_refno  ,  i_gen_title
      ,l_pronumber  ,  'N'
      ,SYSDATE   ,  GET_OS_USER
      );
      ELSE */
      UPDATE fid_production fp
         SET                                        --PRO_NUMBER=I_PRO_NUMBER,
            pro_title = NVL (i_gen_title, fp.pro_title),
             pro_status = 'N',
             pro_entry_oper = i_entry_oper,
             pro_entry_date = SYSDATE,
             pro_update_count = pro_update_count + 1
       WHERE pro_gen_refno = i_gen_refno;

      l_text := l_text || 'PROD ';

      -- END IF ;
      /*
      IF l_pronumber IS NOT NULL
      THEN
      ----DBMS_OUTPUT.PUT_LINE('PRODUCTION');
      UPDATE fid_tape ft
      SET tap_title = NVL (i_tap_title, ft.tap_title),
      tap_type = NVL (i_tap_type, ft.tap_type),
      TAP_ENTRY_OPER =  i_entry_oper,
      TAP_ENTRY_DATE =  SYSDATE,
      tap_format = NVL (i_tap_format, ft.tap_format),
      tap_update_count = tap_update_count + 1
      WHERE tap_pro_number = l_pronumber;
      END IF;
      */
      IF (i_gen_refno IS NOT NULL AND i_tap_title IS NOT NULL)
      THEN
         FOR chk_pro_no_in_fid_prod IN (SELECT pro_number
                                          FROM fid_production
                                         WHERE pro_gen_refno = i_gen_refno)
         LOOP
            BEGIN
               IF chk_pro_no_in_fid_prod.pro_number IS NOT NULL
               THEN
                  ----DBMS_OUTPUT.PUT_LINE('PRODUCTION');
                  UPDATE fid_tape ft
                     SET tap_title = NVL (i_tap_title, ft.tap_title),
                         tap_type = NVL (i_tap_type, ft.tap_type),
                         -- TAP_ENTRY_OPER =  i_entry_oper,
                         -- TAP_ENTRY_DATE =  SYSDATE,
                         tap_format = NVL (i_tap_format, ft.tap_format),
                         tap_update_count = tap_update_count + 1
                   WHERE tap_pro_number = chk_pro_no_in_fid_prod.pro_number;
               END IF;
            END;
         END LOOP;
      END IF;

      -- --DBMS_OUTPUT.PUT_LINE('TAPE');
      o_updated := 1;
      -- Add by
      /*
      DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
      */
      o_rid := 0;

      IF (i_validation = 'add')
      THEN
         BEGIN
            l_mcr_report_id := x_seq_mcr_report_id.NEXTVAL;

            INSERT INTO x_movie_content_report (mcr_report_id,
                                                mcr_report_gen_ref_no,
                                                mcr_report_name,
                                                mcr_copy,
                                                mcr_fpb_rating,
                                                mcr_themes,
                                                mcr_violence,
                                                mcr_bad_language,
                                                mcr_created_by,
                                                mcr_created_date,
                                                mcr_update_count,
                                                mcr_horror_suspence,
                                                mcr_sex,
                                                mcr_nudity,
                                                mcr_drugs,
                                                mcr_prejudice,
                                                mcr_correctives,
                                                mcr_any_special_warnings,
                                                mcr_reasons_for_recoomended,
                                                mcr_location,
                                                mcr_afrc_reg_rating,
                                                mcr_date_received,
                                                mcr_date_viewed,
                                                mcr_buyer_feedback,
                                                mcr_synopsis,
                                                mcr_watershed_restriction,
                                                mcr_sub_title_language,
                                                mcr_programe_type,
                                                mcr_year_of_production,
                                                mcr_language,
                                                mcr_distributor,
                                                mcr_primary_genre,
                                                mcr_cast,
                                                mcr_director,
                                                mcr_producer,
                                                mcr_dom_age_restrictions,
                                                mcr_afr_age_restrictions,
                                                mcr_tx_date,
                                                mcr_africa_tx,
                                                mcr_target_audience)
                 VALUES (l_mcr_report_id,
                         i_gen_refno,
                         i_report_name,
                         i_copy,
                         i_pfb_rating,
                         i_themes,
                         i_violence,
                         i_bad_language,
                         i_entry_oper,
                         SYSDATE,
                         0,
                         i_horror,
                         i_sex,
                         i_nudity,
                         i_drugs,
                         i_prejudice,
                         i_correctives,
                         i_any_special_warnings,
                         i_summary_reasons,
                         i_mcr_location,
                         i_mcr_afrc_reg_rating,
                         i_mcr_date_received,
                         i_mcr_date_viewed,
                         i_mcr_buyer_feedback,
                         i_mcr_synopsis,
                         i_mcr_watershed_restriction,
                         i_mcr_sub_title_language,
                         i_mcr_programe_type,
                         i_mcr_year_of_production,
                         i_mcr_language,
                         i_mcr_distributor,
                         i_mcr_primary_genre,
                         i_mcr_cast,
                         i_mcr_director,
                         i_mcr_producer,
                         i_mcr_dom_age_restrictions,
                         i_mcr_afr_age_restrictions,
                         i_mcr_tx_date,
                         i_mcr_africa_tx,
                         i_mcr_target_audience);

            COMMIT;
            o_rid := l_mcr_report_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_rid := 0;
               raise_application_error (-20108, SQLERRM);
         END;
      ELSIF (i_validation = 'modified')
      THEN
         BEGIN
            UPDATE x_movie_content_report
               SET mcr_report_gen_ref_no = i_gen_refno,
                   mcr_report_name = i_report_name,
                   mcr_copy = i_copy,
                   mcr_fpb_rating = i_pfb_rating,
                   mcr_themes = i_themes,
                   mcr_violence = i_violence,
                   mcr_bad_language = i_bad_language,
                   mcr_horror_suspence = i_horror,
                   mcr_sex = i_sex,
                   mcr_nudity = i_nudity,
                   mcr_drugs = i_drugs,
                   mcr_prejudice = i_prejudice,
                   mcr_correctives = i_correctives,
                   mcr_any_special_warnings = i_any_special_warnings,
                   mcr_reasons_for_recoomended = i_summary_reasons,
                   mcr_update_count = mcr_update_count + 1,
                   mcr_date_received = i_mcr_date_received,
                   mcr_date_viewed = i_mcr_date_viewed,
                   mcr_buyer_feedback = i_mcr_buyer_feedback,
                   mcr_synopsis = i_mcr_synopsis,
                   mcr_watershed_restriction = i_mcr_watershed_restriction,
                   mcr_sub_title_language = i_mcr_sub_title_language,
                   mcr_programe_type = i_mcr_programe_type,
                   mcr_year_of_production = i_mcr_year_of_production,
                   mcr_language = i_mcr_language,
                   mcr_distributor = i_mcr_distributor,
                   mcr_primary_genre = i_mcr_primary_genre,
                   mcr_cast = i_mcr_cast,
                   mcr_director = i_mcr_director,
                   mcr_producer = i_mcr_producer,
                   mcr_dom_age_restrictions = i_mcr_dom_age_restrictions,
                   mcr_afr_age_restrictions = i_mcr_afr_age_restrictions,
                   mcr_tx_date = i_mcr_tx_date,
                   mcr_africa_tx = i_mcr_africa_tx,
                   mcr_location = i_mcr_location,
                   mcr_afrc_reg_rating = i_mcr_afrc_reg_rating,
                   mcr_target_audience = i_mcr_target_audience
             WHERE mcr_report_id = i_mcr_report_id
                   AND mcr_update_count = i_upd_cnt;

            COMMIT;
            o_rid := i_mcr_report_id;

            INSERT
              INTO x_movie_content_report_history (mcrh_history_report_id,
                                                   mcrh_last_modified_by,
                                                   mcrh_last_modified_on)
            VALUES (i_mcr_report_id, i_entry_oper, SYSDATE);

            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_rid := 0;
               ROLLBACK;
               raise_application_error (
                  -20102,
                  'Update unsuccessful There was an error in '
                  || i_validation);
         END;
      END IF;

      /*
      DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
      */
      -- Synergy Enhancement : Start :  : <09-07-2014 >
      BEGIN
         SELECT NVL (gen_ser_number, 0)
           INTO l_gen_ser_number
           FROM fid_general
          WHERE gen_refno = i_gen_refno;

         IF l_gen_ser_number > 0
         THEN
            BEGIN
               SELECT NVL (ser_parent_number, 0)
                 INTO l_ser_parent_number
                 FROM fid_series
                WHERE ser_number = l_gen_ser_number;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_ser_parent_number := -1;
            END;

          --Dev.R10 : Audit on Programme Maintenance : Start : [Devashish Raverkar]_[2015/11/13]
          pkg_cm_username.setgenrefno(i_gen_refno);
          --Dev.R10 : Audit on Programme Maintenance : End

            IF l_ser_parent_number > 0
            THEN
               --Dev.R10 : Audit on Programme Maintenance : Start : [Devashish Raverkar]_[2015/10/08]
               UPDATE fid_series
                  SET ser_synopsis = i_season_synopsis,
                      ser_modified_by = i_entry_oper,
                      ser_modified_date = sysdate
                WHERE ser_number = l_gen_ser_number;

               UPDATE fid_series
                  SET ser_synopsis = i_series_synopsis,
                      ser_modified_by = i_entry_oper,
                      ser_modified_date = sysdate
                WHERE ser_number = l_ser_parent_number;
            ELSE
               IF l_ser_parent_number <> -1
               THEN
                  UPDATE fid_series
                     SET ser_synopsis = i_series_synopsis,
                         ser_modified_by = i_entry_oper,
                         ser_modified_date = sysdate
                   WHERE ser_number = l_gen_ser_number;
               --Dev.R10 : Audit on Programme Maintenance : End
               END IF;
            END IF;
         END IF;

            /* BR_15_168_UC_LicensedContents for CR Svod Rights[Vikas Srivastava] [19-04-2016] */

    BEGIN
          SELECT cod_attr1
             INTO l_is_series_flag
          FROM fid_general, fid_code
          WHERE gen_type = cod_value
            AND cod_type = 'GEN_TYPE'
            AND gen_refno = i_gen_refno;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
            l_is_series_flag := 'N';
    END;

    /* RDT : BR_15_356 ENCH Changes [by Vikas Srivastava ]*/

   IF l_is_synopsis_editor = 0
     THEN
      IF l_is_series_flag='Y'
        THEN
          IF (i_update_all_epi_exp ='Y' AND i_gen_express = 'Y')
            THEN
              UPDATE fid_general
              SET gen_express = i_gen_express
                  ,gen_embargo_content = 'Y'
				  ,GEN_CNT_RELEASE_UID = 'Y'
              WHERE gen_ser_number IN (SELECT gen_ser_number FROM fid_general WHERE gen_refno =i_gen_refno);
         ELSE
            UPDATE fid_general
            SET gen_express = i_gen_express
				,GEN_CNT_RELEASE_UID = decode(i_cnt_release_uid,'N',i_cnt_release_uid,i_prog_embargo)
            WHERE gen_refno = i_gen_refno;
         END IF;
     ELSE
        UPDATE fid_general
        SET gen_express = i_gen_express
			,GEN_CNT_RELEASE_UID = decode(i_cnt_release_uid,'N',i_cnt_release_uid,i_prog_embargo)
        WHERE gen_refno = i_gen_refno;
   END IF;

   IF l_is_series_flag='Y'
   THEN
       IF (i_update_all_epi_cata ='Y')
       THEN
            UPDATE fid_general
            SET gen_catalogue = i_gen_catalogue
            WHERE gen_ser_number IN (SELECT gen_ser_number FROM fid_general WHERE gen_refno =i_gen_refno);
       ELSE
           UPDATE fid_general
           SET  gen_catalogue = i_gen_catalogue
           WHERE gen_refno = i_gen_refno;
     END IF;
     ELSE
        UPDATE fid_general
        SET gen_catalogue = i_gen_catalogue
        WHERE gen_refno = i_gen_refno;
   END IF;

   commit;

   /* END RDT : BR_15_356 ENCH Changes [by Vikas Srivastava ]*/

  BEGIN
   SELECT gen_svod_rights
          ,gen_release_svod
   INTO l_gen_svod_rights
        ,l_gen_release_svod
   FROM fid_general
   WHERE gen_refno = i_gen_refno;

  IF (l_gen_release_svod	<> 'Y' OR l_gen_release_svod IS NULL)
    THEN
        IF (l_is_series_flag ='Y')
           THEN
              IF (i_is_update_all_episode ='Y' )
              THEN
                   UPDATE fid_general
                      SET gen_svod_rights = i_gen_SVOD_Rights
                    WHERE gen_refno IN (SELECT gen_refno FROM fid_general WHERE gen_ser_number IN (
                                 SELECT gen_ser_number FROM fid_general WHERE gen_refno =i_gen_refno));
              ELSE
                UPDATE fid_general
                   SET gen_svod_rights = i_gen_SVOD_Rights
                 WHERE gen_refno =i_gen_refno;
              END IF;
         ELSE
             UPDATE fid_general
             SET gen_svod_rights = i_gen_SVOD_Rights
             where gen_refno =i_gen_refno;
        END IF;
    ELSE
      IF (i_gen_SVOD_Rights <> 'NO SVOD RIGHTS')
      THEN
          IF l_is_series_flag ='Y'
          THEN
              IF (i_is_update_all_episode ='Y' AND i_gen_SVOD_Rights IS NOT NULL)
              THEN
                  UPDATE fid_general
                  SET gen_svod_rights = i_gen_SVOD_Rights
                  WHERE gen_ser_number IN ( SELECT gen_ser_number FROM fid_general WHERE gen_refno =i_gen_refno);
              ELSE
                UPDATE fid_general
                   SET gen_svod_rights = i_gen_SVOD_Rights
                 WHERE gen_refno =i_gen_refno;
              END IF;
          ELSE
              UPDATE fid_general
              SET gen_svod_rights = i_gen_SVOD_Rights
              where gen_refno =i_gen_refno;
          END IF;
      ELSE
          IF l_gen_svod_rights IS NOT NULL OR i_gen_SVOD_Rights = 'NO SVOD RIGHTS'
          THEN
               raise_application_error (
					       -20001,
					   'Programme is already released to SHOWMAX, '
					   || 'Cannot update SVOD Rights');
          END IF;
      END IF;
  END IF;
  END;
 END IF;

  /* BR_15_168_UC_LicensedContents for CR Svod Rights[Vikas Srivastava] [19-04-2016] */
      END;
      -- Synergy Enhancement : End :  : <09-07-2014 >

      /*Dev.R1: Scheduling CR Implementation: END:*/

       BEGIN
              IF I_AITW_CHA_NUMBER(1) IS NOT NULL
              THEN
                  FOR i IN 1.. I_AITW_CHA_NUMBER.COUNT
                  LOOP
                      IF I_AITW_IS_DAY_TIME(i) = 'Y'
                      THEN
                          L_START_TIME     := NULL;
                          L_END_TIME       := NULL;
                          L_CAT_START_TIME := NULL;
                          L_CAT_END_TIME   := NULL;
                      ELSE
                          L_START_TIME     := CONVERT_TIME_C_N(I_AITW_START_TIME(i));
                          L_END_TIME       := CONVERT_TIME_C_N(I_AITW_END_TIME(i));
                          L_CAT_START_TIME := CONVERT_TIME_C_N(I_CAT_START_TIME(i));
                          L_CAT_END_TIME   := CONVERT_TIME_C_N(I_CAT_END_TIME(i));
                      END IF;


                      IF I_AITW_CHANGE_STATUS(i) = 'I'
                      THEN
                           insert into X_ADD_INFO_TX_WARNNING
                              (
                                  AITW_NUMBER
                                 ,AITW_GEN_REFNO
                                 ,AITW_CHA_NUMBER
                                 ,AITW_IS_DAY_TIME
                                 ,AITW_START_TIME
                                 ,AITW_END_TIME
                                 ,AITW_CAT_START_TIME
                                 ,AITW_CAT_END_TIME
                                 ,AITW_OPRAT_FLAG
                                 ,AITW_CREATED_ON
                                 ,AITW_CREATED_BY
                              )
                              values
                              (
                                   X_SEQ_AITW_NUMBER.NEXTVAL
                                  ,i_gen_refno
                                  ,I_AITW_CHA_NUMBER(i)
                                  ,I_AITW_IS_DAY_TIME(i)
                                  ,L_START_TIME
                                  ,L_END_TIME
                                  ,L_CAT_START_TIME
                                  ,L_CAT_END_TIME
                                  ,I_AITW_CHANGE_STATUS(i)
                                  ,SYSDATE
                                  ,i_entry_oper
                              );
                      END IF;

                      IF I_AITW_CHANGE_STATUS(i) = 'U'
                      THEN
                          update X_ADD_INFO_TX_WARNNING
                              set AITW_CHA_NUMBER  = I_AITW_CHA_NUMBER(i)
                                 ,AITW_IS_DAY_TIME = I_AITW_IS_DAY_TIME(i)
                                 ,AITW_START_TIME  = L_START_TIME
                                 ,AITW_END_TIME    = L_END_TIME
                                 ,AITW_CAT_START_TIME = L_CAT_START_TIME
                                 ,AITW_CAT_END_TIME = L_CAT_END_TIME
                                 ,AITW_UPDATED_BY  = i_entry_oper
                                 ,AITW_UPDATED_ON  = SYSDATE
                                 ,AITW_OPRAT_FLAG  = I_AITW_CHANGE_STATUS(i)
                            where AITW_NUMBER = I_AITW_NUMBER(I);
                      END IF;

                      IF I_AITW_CHANGE_STATUS(i) = 'D'
                      THEN
                          DELETE FROM X_ADD_INFO_TX_WARNNING WHERE AITW_GEN_REFNO= i_gen_refno AND  AITW_CHA_NUMBER =I_AITW_CHA_NUMBER(i);
                      END IF;

                  END LOOP;
              END IF;
          END;
          COMMIT;


        BEGIN
          FOR i IN
          (
              SELECT GEN_PRG_N_SCH_CHANNEL,GEN_SCH_ARF_CUSTM,GEN_TAP_SEQ_NO,GEN_ADDINFO_COMMENTS
              FROM fid_general
              WHERE gen_REfno = i_gen_refno
          )
          LOOP

              IF i.gen_prg_n_sch_channel IS NOT NULL
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Programme not suitable for broadcast in '||i.gen_prg_n_sch_channel||',';
              END IF;

              IF i.GEN_SCH_ARF_CUSTM IS NOT NULL
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule Africa Customization is '||i.GEN_SCH_ARF_CUSTM||',';
              END IF;

              IF i.GEN_TAP_SEQ_NO IS NOT NULL
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Please schedule associated slide '||i.GEN_TAP_SEQ_NO||',';
              END IF;

              IF i.GEN_ADDINFO_COMMENTS IS NOT NULL
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Comments : '||i.GEN_ADDINFO_COMMENTS||',';
              END IF;
          END LOOP;

          FOR i IN
          (
              SELECT aitw_gen_refno,aitw_cha_number,cha_name,aitw_start_time,aitw_end_Time,aitw_is_Day_time
              FROM x_add_info_tx_warnning,fid_channel
              WHERE aitw_gen_Refno =i_gen_refno
                    AND cha_number(+) = aitw_cha_number
          )
          LOOP
              IF i.aitw_cha_number = -1 AND i.aitw_is_Day_time = 'Y'
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule on rest all channels within day time,';
              END IF;

              IF i.aitw_cha_number = -1 AND i.aitw_is_Day_time <> 'Y'
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule on rest all channels on '||convert_time_n_c(i.aitw_start_time)||' and '||convert_time_n_c(i.aitw_end_Time)||',';
              END IF;

              IF i.aitw_cha_number <> -1 AND i.aitw_is_Day_time = 'Y'
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule on '||i.cha_name||' within day time,';
              END IF;

              IF i.aitw_cha_number <> -1 AND i.aitw_is_Day_time <> 'Y'
              THEN
                  l_gen_txt_warnning := l_gen_txt_warnning||'Schedule on '||i.cha_name||' '||convert_time_n_c(i.aitw_start_time)||' and '||convert_time_n_c(i.aitw_end_Time)||',';
              END IF;
          END LOOP;
        END;

          BEGIN
             UPDATE fid_general SET GEN_RE_TX_WARNING_add_info = SUBSTR(l_gen_txt_warnning, 1, LENGTH(l_gen_txt_warnning) - 1)
             where GEN_REFNO = i_gen_refno;
          EXCEPTION
          WHEN OTHERS
           THEN
              raise_application_error (-20108, SQLERRM);
          END;
          COMMIT;

--        EXCEPTION
--        WHEN OTHERS
--        THEN
--            raise_application_error (-20108, SQLERRM);
--
--        END;
--        COMMIT;
--      END ;

   END pck_mm_mnet_pl_updateprogram;

   PROCEDURE pck_mm_mnet_pl_searchprogram (
      i_gen_title            IN     fid_general.gen_title%TYPE,
      i_gen_title_working    IN     fid_general.gen_title_working%TYPE,
      i_gen_stu_code         IN     fid_general.gen_stu_code%TYPE,
      i_gen_category         IN     fid_general.gen_category%TYPE,
      i_gen_rating_mpaa      IN     fid_general.gen_rating_mpaa%TYPE,
      i_gen_subgenre         IN     fid_general.gen_subgenre%TYPE,
      i_gen_quality          IN     fid_general.gen_quality%TYPE,
      i_gen_colour           IN     fid_general.gen_colour%TYPE,
      i_gen_series           IN     fid_general.gen_series%TYPE,
      i_gen_spoken_lang      IN     fid_general.gen_spoken_lang%TYPE,
      i_gen_refno            IN     fid_general.gen_refno%TYPE,
      i_gen_type             IN     fid_general.gen_type%TYPE,
      i_gen_nationality      IN     fid_general.gen_nationality%TYPE,
      i_gen_epi_number       IN     fid_general.gen_epi_number%TYPE,
      i_gen_target_group     IN     fid_general.gen_target_group%TYPE,
      i_gen_widescreen       IN     fid_general.gen_widescreen%TYPE,
      i_gen_cat_complete     IN     fid_general.gen_cat_complete%TYPE,
      i_gen_archive          IN     fid_general.gen_archive%TYPE,
      i_gen_nfa_copy         IN     fid_general.gen_nfa_copy%TYPE,
      i_gen_tx_digitized     IN     fid_general.gen_tx_digitized%TYPE,
      i_supp_short_name      IN     fid_company.com_short_name%TYPE,
      i_programmedurationc   IN     fid_general.gen_duration_c%TYPE,
      i_release_year         IN     fid_general.gen_release_year%TYPE,
      i_tertiary_genre       IN     fid_general.gen_tertiary_genre%TYPE,
      o_programdetails          OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_programdetails FOR
           SELECT gen_duration,
                  gen_title,
                  gen_title_working,
                  gen_sub_title,
                  gen_music_title,
                  gen_poem_title,
                  supp_short_name,
                  supp_name,
                  gen_stu_code,
                  stu_name,
                  gen_category,
                  category_desc,
                  gen_subgenre,
                  gen_rating_mpaa,
                  gen_quality,
                  gen_colour,
                  gen_code,
                  gen_spoken_lang,
                  gen_series,
                  colour_desc,
                  code_desc,
                  series_desc,
                  gen_refno,
                  gen_parent_refno,
                  gen_type,
                  gen_release_year,
                  gen_nationality,
                  gen_duration_c,
                  gen_duration_s,
                  gen_epi_number,
                  gen_award,
                  gen_target_group,
                  gen_widescreen,
                  gen_cat_complete,
                  gen_archive,
                  gen_nfa_copy,
                  gen_tx_digitized,
                  gen_comment,
                  gen_supplier_com_number,
                  gen_tertiary_genre,
                  spoken_lang_desc,
                  gen_copy_restrictions,
                  gen_re_tx_warning,
                  gen_abstract,
                  gen_update_count --TVOD-Added gen_update_count parameter by dhnanjay
                                                                     -- Add by
 --DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
                  ,
                  keywords,
                  africa_type_duration_c,
                  africa_type_duration_s
             -- DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
             FROM (SELECT a.gen_duration,
                          a.gen_title,
                          a.gen_title_working,
                          a.gen_sub_title,
                          a.gen_music_title,
                          a.gen_poem_title,
                          NVL (
                             (SELECT b.com_short_name
                                FROM fid_company b
                               WHERE a.gen_supplier_com_number = b.com_number),
                             '')
                             supp_short_name,
                          NVL (
                             (SELECT b.com_name
                                FROM fid_company b
                               WHERE a.gen_supplier_com_number = b.com_number),
                             '')
                             supp_name,
                          a.gen_stu_code,
                          (SELECT g.stu_name
                             FROM fid_studio g
                            WHERE g.stu_code = a.gen_stu_code)
                             stu_name,
                          a.gen_category,
                          (SELECT f.cod_description
                             FROM fid_code f
                            WHERE f.cod_type = 'gen_category'
                                  AND f.cod_value = a.gen_category)
                             category_desc,
                          a.gen_subgenre,
                          a.gen_rating_mpaa,
                          a.gen_quality,
                          a.gen_colour,
                          a.gen_code,
                          a.gen_spoken_lang,
                          a.gen_series,
                          (SELECT h.cod_description
                             FROM fid_code h
                            WHERE h.cod_value = a.gen_colour
                                  AND h.cod_type = 'gen_colour')
                             colour_desc,
                          (SELECT i.cod_description
                             FROM fid_code i
                            WHERE i.cod_value = a.gen_code
                                  AND i.cod_type = 'gen_code')
                             code_desc,
                          NVL (
                             (SELECT j.cod_description
                                FROM fid_code j
                               WHERE j.cod_value = a.gen_series
                                     AND j.cod_type = 'gen_series'),
                             '')
                             series_desc,
                          a.gen_refno,
                          a.gen_parent_refno,
                          a.gen_type,
                          a.gen_release_year,
                          a.gen_nationality,
                          a.gen_duration_c,
                          a.gen_duration_s,
                          a.gen_epi_number,
                          a.gen_award,
                          a.gen_target_group,
                          a.gen_widescreen,
                          a.gen_cat_complete,
                          a.gen_archive,
                          a.gen_nfa_copy,
                          a.gen_tx_digitized,
                          a.gen_comment,
                          a.gen_supplier_com_number,
                          (SELECT k.lan_name
                             FROM sak_language k
                            WHERE k.lan_id = a.gen_spoken_lang)
                             spoken_lang_desc,
                          a.gen_copy_restrictions,
                          a.gen_re_tx_warning,
                          a.gen_abstract,
                          a.gen_tertiary_genre,
                          a.gen_update_count                      --TVOD-Added
                                            -- Add by
                                            --DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
                          ,
                          a.gen_tags keywords,
                          a.gen_africa_type_duration_c africa_type_duration_c,
                          a.gen_africa_type_duration_s africa_type_duration_s
                     -- DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
                     FROM fid_general a)
            WHERE gen_title LIKE
                     DECODE (UPPER (i_gen_title),
                             '', gen_title,
                             UPPER (i_gen_title))
                  AND gen_title_working LIKE
                         DECODE (UPPER (i_gen_title_working),
                                 '', gen_title_working,
                                 UPPER (i_gen_title_working))
                  AND gen_stu_code LIKE
                         DECODE (UPPER (i_gen_stu_code),
                                 '', gen_stu_code,
                                 UPPER (i_gen_stu_code))
                  AND gen_category LIKE
                         DECODE (UPPER (i_gen_category),
                                 '', gen_category,
                                 UPPER (i_gen_category))
                  AND NVL (gen_rating_mpaa, 0) LIKE
                         DECODE (UPPER (i_gen_rating_mpaa),
                                 '', NVL (gen_rating_mpaa, 0),
                                 UPPER (i_gen_rating_mpaa))
                  AND NVL (gen_subgenre, 0) LIKE
                         DECODE (UPPER (i_gen_subgenre),
                                 '', NVL (gen_subgenre, 0),
                                 UPPER (i_gen_subgenre))
                  AND NVL (gen_quality, 0) LIKE
                         DECODE (UPPER (i_gen_quality),
                                 '', NVL (gen_quality, 0),
                                 UPPER (i_gen_quality))
                  AND NVL (UPPER (gen_colour), 0) LIKE
                         DECODE (UPPER (i_gen_colour),
                                 '', NVL (gen_colour, 0),
                                 UPPER (i_gen_colour))
                  AND NVL (gen_series, 0) LIKE
                         DECODE (UPPER (i_gen_series),
                                 '', NVL (gen_series, 0),
                                 UPPER (i_gen_series))
                  AND NVL (gen_spoken_lang, 0) LIKE
                         DECODE (UPPER (i_gen_spoken_lang),
                                 '', NVL (gen_spoken_lang, 0),
                                 UPPER (i_gen_spoken_lang))
                  AND gen_refno LIKE
                         DECODE (i_gen_refno, '', gen_refno, i_gen_refno)
                  AND gen_type LIKE
                         DECODE (UPPER (i_gen_type),
                                 '', gen_type,
                                 UPPER (i_gen_type))
                  AND NVL (gen_nationality, 0) LIKE
                         DECODE (UPPER (i_gen_nationality),
                                 '', NVL (gen_nationality, 0),
                                 UPPER (i_gen_nationality))
                  AND NVL (gen_epi_number, 0) =
                         DECODE (i_gen_epi_number,
                                 '', NVL (gen_epi_number, 0),
                                 i_gen_epi_number)
                  AND NVL (gen_target_group, 0) LIKE
                         DECODE (UPPER (i_gen_target_group),
                                 '', NVL (gen_target_group, 0),
                                 UPPER (i_gen_target_group))
                  AND NVL (gen_widescreen, 0) LIKE
                         DECODE (UPPER (i_gen_widescreen),
                                 '', NVL (gen_widescreen, 0),
                                 UPPER (i_gen_widescreen))
                  AND NVL (gen_cat_complete, 0) LIKE
                         DECODE (UPPER (i_gen_cat_complete),
                                 '', NVL (gen_cat_complete, 0),
                                 UPPER (i_gen_cat_complete))
                  AND NVL (gen_archive, 0) LIKE
                         DECODE (UPPER (i_gen_archive),
                                 '', NVL (gen_archive, 0),
                                 UPPER (i_gen_archive))
                  AND NVL (gen_nfa_copy, 0) LIKE
                         DECODE (UPPER (i_gen_nfa_copy),
                                 '', NVL (gen_nfa_copy, 0),
                                 UPPER (i_gen_nfa_copy))
                  AND NVL (gen_tx_digitized, 0) LIKE
                         DECODE (UPPER (i_gen_tx_digitized),
                                 '', NVL (gen_tx_digitized, 0),
                                 UPPER (i_gen_tx_digitized))
                  AND NVL (gen_duration_c, 0) LIKE
                         DECODE (i_programmedurationc,
                                 '', NVL (gen_duration_c, 0),
                                 i_programmedurationc)
                  AND NVL (gen_release_year, 0) =
                         DECODE (i_release_year,
                                 '', NVL (gen_release_year, 0),
                                 i_release_year)
                  AND NVL (supp_short_name, 0) LIKE
                         DECODE (UPPER (i_supp_short_name),
                                 '', NVL (supp_short_name, 0),
                                 UPPER (i_supp_short_name))
                  AND NVL (gen_tertiary_genre, 0) LIKE
                         DECODE (i_tertiary_genre,
                                 '', NVL (gen_tertiary_genre, 0),
                                 i_tertiary_genre)
                  AND ROWNUM < 501
         ORDER BY gen_title;
   --TVOD-Added Exception block added by Dhnanjay
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001,
                                  'No records matching the search criteria.');
      WHEN OTHERS
      THEN
         raise_application_error (-20002,
                                  'An error occurred. Message: ' || SQLERRM);
   END pck_mm_mnet_pl_searchprogram;

   PROCEDURE pck_mm_mnet_pl_searchprgdetail (
      i_gen_refno                    IN     fid_general.gen_refno%TYPE,
      o_programdetails                  OUT SYS_REFCURSOR,
      o_livedetails                     OUT SYS_REFCURSOR,
      o_librarydetails                  OUT SYS_REFCURSOR,
      o_synopsisdetails                 OUT SYS_REFCURSOR,
      o_castdetails                     OUT SYS_REFCURSOR,
      o_locaprogdetails                 OUT SYS_REFCURSOR,
      o_promodetails                    OUT SYS_REFCURSOR,
      o_filedetails                     OUT SYS_REFCURSOR,
      o_proddetails                     OUT SYS_REFCURSOR,
      o_supplierdetails                 OUT SYS_REFCURSOR,
      o_link_count                      OUT SYS_REFCURSOR,
      --added for bioscope
      o_rating_details                  OUT SYS_REFCURSOR,
      -- Add by
      --DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
      o_mcr                             OUT SYS_REFCURSOR,
      o_pga_time_code                   OUT SYS_REFCURSOR --DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
                                                         --RDT Start Phoneix req [08-052014][Kiran]
      ,
      o_sch_count                       OUT SYS_REFCURSOR,
      --RDT end Phoneix req [08-052014][Kiran]
      --RDT :MOP_CR_12.5 :Abhishek Mor 19/08/2014-Add Supplier Tab on Programme Maintenance-Start
      o_PrgTitle_Supplier_Details       OUT SYS_REFCURSOR,
      --RDT :MOP_CR_12.5 :Abhishek Mor 19/08/2014-Add Supplier Tab on Programme Maintenance-End
      --RDT :Release 10 :NEERAJ 22/09/2014-Add Translated Titles Tab on Programme Maintenance-START
      o_PrgTitle_translated_titles      OUT SYS_REFCURSOR,
      --RDT :Release 10 :NEERAJ 22/09/2014-Add Translated Titles Tab on Programme Maintenance-End

      /*Added by Swapnil Malvi on 15-Mar-2015 for Clearleap Release*/
      o_Catchup_VOD_dtl                 OUT SYS_REFCURSOR              /*END*/
      -- media Ops CR - Nasreen Mulla
      ,o_notes_details               out sys_refcursor
      ,O_GET_VOD_HISTORY_DETAILS              OUT SYS_REFCURSOR
	  --Added By Pravin to get The Roles list for detail screen
	  ,o_Role_List						            OUT SYS_REFCURSOR
    ,o_editlist_details                 OUT SYS_REFCURSOR  -- CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]_[start]
    ,o_prg_maintaince_add_info          OUT SYS_REFCURSOR  -- SCHEDULING CR's IMPLEMENTAION[ankur kasar]
	  )
   AS
      --RDT Start Phoneix req [08-052014][Kiran]
      l_sch_num_count       NUMBER;
      --RDT end Phoneix req [08-052014][Kiran]
      l_gen_ser_number      fid_general.gen_ser_number%TYPE;
      l_season_synopsis     fid_series.ser_synopsis%TYPE;
      l_series_synopsis     fid_series.ser_synopsis%TYPE;
      l_ser_parent_number   fid_series.ser_parent_number%TYPE;
      l_gen_ser_count       NUMBER;
      l_gen_no              NUMBER;
      l_epi_count             NUMBER;
   BEGIN
      SELECT NVL (gen_ser_number, 0)
        INTO l_gen_ser_number
        FROM fid_general
       WHERE gen_refno = i_gen_refno;

         ---added by rashmi
   select SER_SEA_EPI_COUNT
     into l_epi_count
     from fid_series
     where ser_number = l_gen_ser_number;
     ----added by rashmi:end

      IF l_gen_ser_number > 0
      THEN
         BEGIN
            SELECT ser_synopsis, NVL (ser_parent_number, 0)
              INTO l_season_synopsis, l_ser_parent_number
              FROM fid_series
             WHERE ser_number = l_gen_ser_number;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_series_synopsis := NULL;
               l_season_synopsis := NULL;
         END;

         IF l_ser_parent_number > 0
         THEN
            BEGIN
               SELECT ser_synopsis
                 INTO l_series_synopsis
                 FROM fid_series
                WHERE ser_number = l_ser_parent_number;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_series_synopsis := l_season_synopsis;
                  l_season_synopsis := NULL;
            END;
         ELSE
            l_series_synopsis := l_season_synopsis;
            l_season_synopsis := NULL;
         END IF;
      END IF;

      -- Add by
      /*
      DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
      */
      OPEN o_mcr FOR
           SELECT mcr_report_id,
                  mcr_report_gen_ref_no,
                  mcr_report_name,
                  mcr_copy,
                  mcr_fpb_rating,
                  mcr_themes,
                  mcr_violence,
                  mcr_bad_language,
                  mcr_created_by,
                  mcr_created_date,
                  mcr_update_count,
                  mcr_horror_suspence,
                  mcr_sex,
                  mcr_nudity,
                  mcr_drugs,
                  mcr_prejudice,
                  mcr_correctives,
                  mcr_any_special_warnings,
                  mcr_reasons_for_recoomended,
                  mcrh.mcrh_last_modified_by,
                  mcrh.mcrh_last_modified_on,
                  mcr.mcr_update_count,
                  mcr.mcr_location,
                  mcr.mcr_afrc_reg_rating,
                  mcr.mcr_date_received,
                  mcr.mcr_date_viewed,
                  mcr.mcr_buyer_feedback,
                  mcr.mcr_synopsis,
                  mcr.mcr_watershed_restriction,
                  mcr.mcr_sub_title_language,
                  mcr.mcr_programe_type,
                  mcr.mcr_year_of_production,
                  mcr.mcr_language,
                  mcr.mcr_distributor,
                  mcr.mcr_primary_genre,
                  mcr.mcr_cast,
                  mcr.mcr_director,
                  mcr.mcr_producer,
                  mcr.mcr_dom_age_restrictions,
                  mcr.mcr_afr_age_restrictions,
                  mcr.mcr_tx_date,
                  mcr.mcr_africa_tx,
                  mcr.mcr_target_audience
             FROM x_movie_content_report mcr,
                  x_movie_content_report_history mcrh
            WHERE mcr.mcr_report_gen_ref_no = i_gen_refno
                  AND mcrh.mcrh_history_report_id(+) = mcr.mcr_report_id
                  AND (mcrh.mcrh_last_modified_on IS NULL
                       OR mcrh.mcrh_last_modified_on =
                             (SELECT MAX (h.mcrh_last_modified_on)
                                FROM x_movie_content_report_history h
                               WHERE mcrh.mcrh_history_report_id =
                                        h.mcrh_history_report_id))
         ORDER BY (CASE
                      WHEN NVL (mcrh.mcrh_last_modified_on,
                                TO_DATE ('01-jan-0001')) > mcr_created_date
                      THEN
                         mcrh.mcrh_last_modified_on
                      ELSE
                         mcr_created_date
                   END) DESC;

      OPEN o_pga_time_code FOR
         SELECT xpgtc.pga_time_code_id "TIME_CODE_REPORT_ID",
                xpgtc.pgatc_mcr_report_id "TIME_CODE_MCR_REPORT_ID",
                xpgtc.pgatc_part "TIME_CODE_PART",
                xpgtc.pgatc_segment "TIME_CODE_SEGMENT",
                xpgtc.pgatc_start_of_mesg "TIME_CODE_START_OF_MESG",
                xpgtc.pgatc_end_of_mesg "TIME_CODE_END_OF_MESG",
                xpgtc.pgatc_comment "TIME_CODE_COMMENT" --need to do calcultion
                                                       ,
                xpgtc.pgatc_end_of_mesg "TIME_CODE_DURATION",
                xpgtc.pgatc_update_count "UPDATE_COUNT"
           FROM x_progrmm_acceptance_time_code xpgtc,
                x_movie_content_report mcr
          WHERE mcr.mcr_report_gen_ref_no = i_gen_refno
                AND mcr.mcr_report_id = xpgtc.pgatc_mcr_report_id;

      --DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
      OPEN o_programdetails FOR
         SELECT gen_title,
                gen_title_working,
                gen_sub_title,
                gen_music_title,
                gen_update_count,
                gen_poem_title,
                gen_stu_code,
                gen_category,
                gen_subgenre,
                gen_rating_mpaa,
                gen_rating_int,
                gen_quality,
                gen_colour,
                gen_code,
                gen_spoken_lang,
                gen_series,
                gen_refno,
                gen_parent_refno,
                gen_type,
                gen_release_year,
                gen_nationality,
                gen_duration_c,
                --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[17-02-2015]
                GEN_PGA_DURATION,
                --DEV.R4:Inventory Mining:End
                gen_duration_s,
                gen_epi_number,
                gen_award,
                gen_target_group,
                -- Prod.Support : SVOD : Start : [Devashish Raverkar]_[2015-03-20]
                gen_sec_target_group,
                -- Prod.Support : SVOD : End
                gen_widescreen,
                gen_cat_complete,
                gen_archive,
                gen_nfa_copy,
                gen_tx_digitized,
                gen_comment,
                gen_supplier_com_number,
                gen_copy_restrictions,
                case when
                   (SELECT (CASE WHEN count(1)>0 THEN 'Y' ELSE 'N' END)
                    FROM fid_general,fid_code
                    WHERE gen_Refno = gen_Refno
                          AND (GEN_RATING_MPAA = COD_VALUE OR GEN_RATING_INT = COD_VALUE)
                          AND cod_attr = 'Y'
                          AND cod_type = 'GEN_RATING') = 'Y'
                then
                CASE WHEN
                      gen_re_tx_warning IS NOT NULl and gen_re_tx_warning_add_info IS NOT NULL
                      THEN gen_re_tx_warning||','
                      ELSE gen_re_tx_warning
                END||gen_re_tx_warning_add_info
                else
                 NULL
                end gen_re_tx_warning,
                gen_abstract,
                gen_tags,
                gen_africa_type_duration_c,
                gen_africa_type_duration_s                --added for bioscope
                                          ,
                gen_prog_category_code,
                gen_tertiary_genre,
                gen_web_title --START: PROJECT BIOSCOPE ? PENDING CR?S: Mangesh Gulhane_20121003
                /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[01-09-2016]*/
               ,GEN_SCH_ARF_CUSTM
               ,GEN_TAP_SEQ_NO
               ,GEN_ADDINFO_COMMENTS
               ,GEN_PRG_N_SCH_CHANNEL
               ,(SELECT (CASE WHEN count(1)>0 THEN 'Y' ELSE 'N' END)
                 FROM fid_general,fid_code
                 WHERE gen_Refno = gen_Refno
                       AND (GEN_RATING_MPAA = COD_VALUE OR GEN_RATING_INT = COD_VALUE)
                       AND cod_attr = 'Y'
                       AND cod_type = 'GEN_RATING') GEN_RATING
               /*Dev.R1: Scheduling CR Implementation: END*/
 -- PB CR 54/ Add two new fields Moods and Link for Poster Art in Program Maintainance Screen
                ,
                gen_mood,
				 (select count(*)
                     from fid_license
                     where lic_status = 'A'
                     and lic_gen_refno = gen_refno)lic_act_count,--- Added By Rashmi For Bulk Uid Generation Dt 25-08-2015
                gen_link_poster_art    --END: PROJECT BIOSCOPE ? PENDING CR?S:
                                                                     -- Add by
 --DEV4: Programme Acceptance (Release 12) : Start :  : <11-06-2013> : <Refer PGA01 document>
                ,
                --ACQ and PC CRS [SCH 32][Mangesh Gulhane][Added column for afr writeoff]
                NVL (GEN_IS_AFR_WRITEOFF, 'N') GEN_IS_AFR_WRITEOFF,
                --bhagyashri
                NVL (GEN_SVOD_EXPRESS, 'N') GEN_SVOD_EXPRESS,
                NVL (gen_is_day_time_rest, 'N') gen_is_day_time_rest,
                --ACQ and PC CRS end
                NVL (gen_metadata_verified, 'N') gen_metadata_verified,
                -- #region Abhinay_230512014 : New Field Metadata Verified
                NVL (GEN_EMBARGO_CONTENT, 'N') GEN_EMBARGO_CONTENT, -- #region Abhinay_1oct14: Embargo Content Implementation
                NVL (GEN_IS_CINEMA_EMBARGO_CONTENT, 'N') GEN_IS_CINEMA_EMBARGO_CONTENT, --Onsite.Dev:BR_15_327
                GEN_US_BROADC_DATE,
                GEN_US_BROADC_TIME, -- #region Abhinay_1oct14: Embargo Content Implementation
                NVL (GEN_CE_VERSION_CONTENT, 'N') GEN_CE_VERSION_CONTENT, -- #region Kunal Mujumdar_06jan15: Africa Customization
                (SELECT COUNT (*)
                   FROM fid_tape
                  WHERE tap_title = gen_title
                        AND (tap_uid_version = 'HD - CE'
                             OR tap_uid_version = 'SD - CE'))
                   GEN_CE_VERSION_COUNT, -- #region KunalMujumdar_06jan15: Africa Customization
                --Added by Pravin for CD version Automation
                NVL (GEN_CD_VERSION_CONTENT, 'N') GEN_CD_VERSION_CONTENT,
                (SELECT COUNT (*)
                   FROM fid_tape
                  WHERE tap_title = gen_title
                        AND (tap_uid_version = 'HD - CD'
                             OR tap_uid_version = 'SD - CD'))
                   GEN_CD_VERSION_COUNT,
                --Pravin - End
                gen_title "TITLE",
                gen_title_working "EPISODE_TITLE",
                gen_epi_number "EPISODE_NUMBER",
                (SELECT a.ser_title
                   FROM fid_series a,
                        (SELECT ser_title, ser_parent_number
                           FROM fid_series
                          WHERE ser_number = (SELECT gen_ser_number
                                                FROM fid_general
                                               WHERE gen_refno = i_gen_refno)) b
                  WHERE b.ser_parent_number = a.ser_number)
                   "SERIES_TITLE",
                (SELECT b.ser_title
                   FROM fid_series a,
                        (SELECT ser_title, ser_parent_number
                           FROM fid_series
                          WHERE ser_number = (SELECT gen_ser_number
                                                FROM fid_general
                                               WHERE gen_refno = i_gen_refno)) b
                  WHERE b.ser_parent_number = a.ser_number)
                   "SEASON_TITLE",
                ser_sea_number "SEASON_NUMBER",
                l_series_synopsis l_series_synopsis,
                l_season_synopsis l_season_synopsis --DEV4: Programme Acceptance (Release 12) : End :  : <11-06-2013 >
                                                   --Abhishek Mor-Synergy RDT : Release 10: Capture AKA title for EPG - AKA Title added
                ,
                gen_aka_title,
                gen_catchup_category    --added for CATCHUP:CACQ14:shantanu a.
                                    ,
                gen_catchup_priority  -- added by Rashmi:CATCHUPCR[25-03-2015]
                                    --kunal : START 02-03-2015 Production Number
                ,
                Gen_Production_Number
                ,GEN_EPG_CONTENT_ID EPGContentId
           --kunal : END Production Number
           ,GEN_RELEASE_SVOD --RDT :[BR_15_309_Content_CR]_[Rashmi_Tijare]_[ 09-02-2016] :RDT
           ,DECODE(GEN_CNT_RELEASE_UID,NULL,'N',GEN_CNT_RELEASE_UID) GEN_CNT_RELEASE_UID --Added by Zeshan for 10Digit UID CR
           , NVL (GEN_IS_ARCHIVE_EMBARGO_CONTENT, 'N') GEN_IS_ARCHIVE_EMBARGO_CONTENT --Onsite.Dev:Added by Milind_25_10_2016
	     --EPG :[BR_15_363]_[Sushma K]_[ 08-07-2016] EPG
           ,(select PVD_GEN_TITLE from  X_PROG_VOD_DETAILS where PVD_GEN_REFNO =  GEN_REFNO and PVD_UID_LANG_ID= NVL(1,0) and PVD_GEN_TITLE is not null ) EPG_title
          ,(select SVD_SER_TITLE from X_SER_VOD_DETAILS where SVD_SER_NUMBER = gen_ser_number and SVD_UID_LANG_ID= NVL(1,0) and SVD_SER_TITLE  is not null ) EPG_season_Title
          --EPG : END
	   /*CR  SVOD_Rights RDT:[BR_15_168] Vikas Srivastava[12-04-2016] */
           ,GEN_SVOD_RIGHTS --CR  SVOD_Rights RDT:[BR_15_168] Vikas Srivastava[12-04-2016]
           ,gen_catalogue
           ,gen_express
           ,DECODE(nvl(gen_sea_epi_update,'N'),'Y',gen_sea_epi_no,trim(gen_sea_epi_no)||' '||l_epi_count)gen_sea_epi_no --added by rashmi 14-06-2016
           ,(SELECT cod_attr1
                FROM fid_code
              WHERE gen_type = cod_value
              AND cod_type = 'GEN_TYPE'
              AND gen_refno = i_gen_refno)AS l_is_series_flag --CR  SVOD_Rights RDT:[BR_15_168] Vikas Srivastava[12-04-2016]
           FROM fid_general, fid_series
          WHERE gen_refno = i_gen_refno AND ser_number(+) = gen_ser_number;
         /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[01-09-2016]*/
            OPEN o_prg_maintaince_add_info FOR
                 select AITW_NUMBER ,
                        AITW_GEN_REFNO ,
                        CASE WHEN AITW_CHA_NUMBER = -1
                        THEN
                          (SELECT 'ALL' FROM DUAL)
                        ELSE
                           (SELECT CHA_SHORT_NAME FROM FID_CHANNEL WHERE CHA_NUMBER = AITW_CHA_NUMBER)
                        END AS CHA_SHORT_NAME,

                        CASE WHEN AITW_IS_DAY_TIME = 'Y'
                        THEN
                          (SELECT NULL FROM DUAL)
                        ELSE
                          ( convert_time_n_c(AITW_START_TIME))
                        END AS AITW_START_TIME,

                         CASE WHEN AITW_IS_DAY_TIME = 'Y'
                        THEN
                          (SELECT NULL FROM DUAL)
                        ELSE
                          (convert_time_n_c(AITW_END_TIME))
                        END AS AITW_END_TIME,
                        AITW_CHA_NUMBER,
                        AITW_IS_DAY_TIME,
                        AITW_OPRAT_FLAG,
                       convert_time_n_c(aitw_cat_start_time) CAT_START_TIME,
                      convert_time_n_c(aitw_cat_END_time)   CAT_END_TIME
                    from X_ADD_INFO_TX_WARNNING
                   where AITW_GEN_REFNO = i_gen_refno;
        /*Dev.R1: Scheduling CR Implementation: END*/
      OPEN o_livedetails FOR
         SELECT fgl_time,
                fgl_venue,
                fgl_location,
                fgl_live_date
           FROM fid_gen_live
          WHERE (fgl_gen_refno = i_gen_refno);

      ----DBMS_OUTPUT.put_line ('LIVE DETAILS CURSOR');
      OPEN o_synopsisdetails FOR
               SELECT NVL (syn_syt_id, 1) ID,
               /* DECODE (syn_syt_id,
                        1, syn_synopsis,
                        2, syn_synopsis,
                        3, syn_synopsis,
                        4, syn_synopsis,
                        5, syn_synopsis,
                        --Added by Pravin
                        6, syn_synopsis,
                        --End
                        --OA-04 Version
                        7, syn_synopsis                            --End OA-04
                       )*/
                   syn_synopsis synopsis,
                syn_ver_lang_id,
                --EPG :[BR_15_352_Miscellaneous Changes Related to EPG]_[Sushma Komulla]_[ 07-06-2016]
                (select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) syn_lang_name,
                SYN_LANG_ID,
                SYN_VER_NAME,
                SYN_ID,
                SYN_QA_STATUS_ID,
                (select QASP_STATUS from x_epg_inv_QAStatus_priority where QASP_ID = SYN_QA_STATUS_ID) qa_status,
                SYN_ENTRY_DATE,
                SYN_MODIFIED_DATE
                --EPG:END
           FROM fid_synopsis
          WHERE syn_gen_refno in ( i_gen_refno,l_gen_ser_number,l_ser_parent_number);

      OPEN o_librarydetails FOR
         SELECT tap_title,
                (SELECT com_short_name
                   FROM fid_company
                  WHERE com_number =
                           (SELECT MAX (tap_com_number)
                              FROM fid_tape, sgy_mn_lic_tape_cha_mapp
                             WHERE tap_number = ltcm_tap_number
                                   AND ltcm_gen_refno = i_gen_refno))
                   supplier,
                tap_format,
                NVL (tap_uid_version, tap_type) tap_type            --tap_type
                                                        ,
                tap_barcode,
                tape_duration_n (tap_number) DURATION,
                pkg_mm_mnet_pl_prgmaintenance.get_duration (
                   tape_duration_n (tap_number))
                   formated_duration --Dev.R1: UID_Generation: Start:[MOP_UID_06]_[Anuja_Shinde]_[12-26-2013]
                                    --Added two columns  STATUS and COMMENTS for library tab
                ,
                --DEV.R4:Synergy M-Net:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[16-02-2015]
                x_fun_get_material_duration (tap_barcode) material_duration,
                --DEV.R4:Synergy M-Net:End
                (SELECT uid_status
                   FROM x_uid_status
                  WHERE uid_status_id = tap_uid_status_id)
                   status,
              --- Dev: BR_15-087 Mandatory Milestone requirement[suresh.k]
                (select uid_mandatory_status_seq from X_UID_STATUS
                    WHERE uid_status_id = tap_uid_status_id) CURR_SEQUENCE,
                X_FNC_PRV_MANDATORY(tap_uid_status_id,tap_type) PREV_MN_SEQ,
                X_FNC_NEXT_MANDATORY(tap_uid_status_id,tap_type) NEXT_MN_SEQ,
                tap_comment comments,
                tap_title_second "SUB_TITLE",
                tap_uid_version "VERSION",
                tap_aspect_ratio "ASPECT_RATIO",
                tap_uid_audio "AUDIO",
                tap_update_count,
                NULL tap_uid_wss,
                NULL tap_uid_visual_resolution,
                NULL tap_uid_hi,
           --Dev.R1: UID_Generation: End
                -- Dev : Trello Replacement : Start : [BR_15_275]_[Devashish Raverkar]_[2015/11/04]
                'N' tap_is_dvsad,
                'N' tap_is_mne,
                'N' tap_is_int_hi,
                -- Dev : Trello Replacement : End
                --  CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016][Start]
                (CASE WHEN tap_uid_version = 'HD - CE' THEN nvl(TAP_CP_AREA,'POST PRODUCTION')
                      WHEN tap_uid_version = 'SD - CE' THEN nvl(TAP_CP_AREA,'POST PRODUCTION')
                      WHEN tap_uid_version = 'HD - CD' THEN nvl(TAP_CP_AREA,'POST PRODUCTION')
                      WHEN tap_uid_version = 'SD - CD' THEN nvl(TAP_CP_AREA,'POST PRODUCTION')
                      ELSE TAP_CP_AREA
                 END)TAP_AREA,   --  CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]
                (CASE WHEN tap_uid_version = 'HD - CE' THEN nvl(TAP_CP_WORK_INSTRUCTION,'EDIT')
                      WHEN tap_uid_version = 'SD - CE' THEN nvl(TAP_CP_WORK_INSTRUCTION,'EDIT')
                      WHEN tap_uid_version = 'HD - CD' THEN nvl(TAP_CP_WORK_INSTRUCTION,'EDIT')
                      WHEN tap_uid_version = 'SD - CD' THEN nvl(TAP_CP_WORK_INSTRUCTION,'EDIT')
                      ELSE TAP_CP_WORK_INSTRUCTION
                 END) WORK_INSTRUCTION,
                 TAP_AGE_RESTRICTION,
                 (SELECT ver_group
                    FROM x_cont_version
                  WHERE ver_name =NVL (tap_uid_version, tap_type))group_name
                  --  CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016][End]
           FROM fid_pro_tap_vw
          WHERE pro_gen_refno = i_gen_refno
         UNION
         SELECT tap_title,
                (SELECT com_short_name
                   FROM fid_company
                  WHERE com_number =
                           (SELECT MAX (tap_com_number)
                              FROM fid_tape, sgy_mn_lic_tape_cha_mapp
                             WHERE tap_number = ltcm_tap_number
                                   AND ltcm_gen_refno = i_gen_refno))
                   supplier,
                tap_format,
                NVL (tap_uid_version, tap_type) tap_type            --tap_type
                                                        ,
                tap_barcode,
                tape_duration_n (tap_number) DURATION,
                pkg_mm_mnet_pl_prgmaintenance.get_duration (
                   tape_duration_n (tap_number))
                   formated_duration --Dev.R1: UID_Generation: Start:[MOP_UID_06]_[Anuja_Shinde]_[12-26-2013]
                      --Added two columns  STATUS and COMMENTS for library tab
 --DEV.R4:Synergy M-Net:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[16-02-2015]
                ,
                x_fun_get_material_duration (tap_barcode) material_duration --DEV.R4:Synergy M-Net:End
                                                                           ,
                (SELECT uid_status
                   FROM x_uid_status
                  WHERE uid_status_id = tap_uid_status_id)
                   status,
              --- Dev: BR_15-087 Mandatory Milestone requirement[suresh.k]
                   (select uid_mandatory_status_seq from X_UID_STATUS
                    WHERE uid_status_id = tap_uid_status_id) CURR_SEQUENCE,
                X_FNC_PRV_MANDATORY(tap_uid_status_id,tap_type) PREV_MN_SEQ,
                X_FNC_NEXT_MANDATORY(tap_uid_status_id,tap_type) NEXT_MN_SEQ,
                tap_comment comments,
                tap_title_second "SUB_TITLE",
                tap_uid_version "VERSION",
                tap_aspect_ratio "ASPECT_RATIO",
                tap_uid_audio "AUDIO",
                tap_update_count,
                tap_uid_wss,
                tap_uid_visual_resolution,
                tap_uid_hi,
           --Dev.R1: UID_Generation: End
                -- Dev : Trello Replacement : Start : [BR_15_275]_[Devashish Raverkar]_[2015/11/04]
                tap_is_dvsad,
                tap_is_mne,
                tap_is_int_hi,
                -- Dev : Trello Replacement : End
                --  CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016][Start]
                (CASE WHEN tap_uid_version = 'HD - CE' THEN nvl(TAP_CP_AREA,'POST PRODUCTION')
                      WHEN tap_uid_version = 'SD - CE' THEN nvl(TAP_CP_AREA,'POST PRODUCTION')
                      WHEN tap_uid_version = 'HD - CD' THEN nvl(TAP_CP_AREA,'POST PRODUCTION')
                      WHEN tap_uid_version = 'SD - CD' THEN nvl(TAP_CP_AREA,'POST PRODUCTION')
                      ELSE TAP_CP_AREA
                 END)TAP_AREA,   --  CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]
                (CASE WHEN tap_uid_version = 'HD - CE' THEN nvl(TAP_CP_WORK_INSTRUCTION,'EDIT')
                      WHEN tap_uid_version = 'SD - CE' THEN nvl(TAP_CP_WORK_INSTRUCTION,'EDIT')
                      WHEN tap_uid_version = 'HD - CD' THEN nvl(TAP_CP_WORK_INSTRUCTION,'EDIT')
                      WHEN tap_uid_version = 'SD - CD' THEN nvl(TAP_CP_WORK_INSTRUCTION,'EDIT')
                      ELSE TAP_CP_AREA
                 END) WORK_INSTRUCTION,    -- END CD and CE automation ver 1.0
                 TAP_AGE_RESTRICTION,
                 (SELECT ver_group
                    FROM x_cont_version
                  WHERE ver_name =NVL (tap_uid_version, tap_type))group_name
                  --  CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016][End]
           FROM sgy_mn_lic_tape_cha_mapp, fid_general, fid_tape
          WHERE     ltcm_gen_refno = gen_refno
                AND tap_number = ltcm_tap_number
                AND gen_refno = i_gen_refno;

      ----DBMS_OUTPUT.put_line ('LIBRARY DETAILS CURSOR');
      OPEN o_locaprogdetails FOR
         SELECT loc_gen_refno,
                loc_ter_code,
                loc_title,
                loc_release_the,
                loc_release_vid,
                loc_release_tv,
                loc_comment,
                loc_unique_id
           FROM fid_general_local
          WHERE loc_gen_refno = i_gen_refno;

      ----DBMS_OUTPUT.put_line ('LOCAL DETAILS CURSOR');
      OPEN o_filedetails FOR
         SELECT afi_number, afi_file_id
           FROM fid_attach_file
          WHERE afi_gen_refno = i_gen_refno;

      ----DBMS_OUTPUT.put_line ('FILE DETAILS CURSOR');
      OPEN o_castdetails FOR
         SELECT cas_role,
                cas_name,
                cas_order,
                cas_award,
                (SELECT cod_description
                   FROM fid_code
                  WHERE cod_value = cas_award AND cod_type = 'CAS_AWARD')
                   description,
                cas_unique_id
           FROM fid_general_cast
          WHERE cas_gen_refno = i_gen_refno;

      ----DBMS_OUTPUT.put_line ('CAST DETAILS CURSOR');
      OPEN o_promodetails FOR
         SELECT ppr_library_id,
                ppr_promo_type,
                ppr_number,
                ppr_status,
                ppr_comments
           FROM fid_promo_programme
          WHERE ppr_gen_refno = i_gen_refno;

      ----DBMS_OUTPUT.put_line ('PROMO DETAILS CURSOR');
      OPEN o_proddetails FOR
         SELECT *
           FROM fid_production
          WHERE pro_gen_refno = i_gen_refno;

      OPEN o_supplierdetails FOR
         SELECT *
           FROM fid_company
          WHERE com_number = (SELECT gen_supplier_com_number
                                FROM fid_general
                               WHERE gen_refno = i_gen_refno);

      OPEN o_link_count FOR
         SELECT COUNT (*) AS "Tape_Link_Counter"
           FROM fid_tape
          WHERE tap_pro_number IN (SELECT pro_number
                                     FROM fid_production
                                    WHERE pro_gen_refno = i_gen_refno)
                AND tap_match_status = 'LK';

      OPEN o_rating_details FOR
         SELECT gen_rating_imdb,
                gen_rating_ar,
                gen_rating_expert_meta_critic,
                gen_bo_category_code,
                gen_bo_revenue_usd,
                gen_bo_revenue_zar,
                gen_final_grade,
                GEN_TVOD_BO_CATEGORY_CODE
           FROM fid_general
          WHERE gen_refno = i_gen_refno;

      --RDT Start Phoneix req [08-052014][Kiran]
      SELECT COUNT (sch_number)
        INTO l_sch_num_count
        FROM fid_schedule, fid_general, fid_license
       WHERE     sch_lic_number = lic_number
             AND lic_gen_refno = gen_refno
             AND sch_date > SYSDATE
             AND gen_refno = i_gen_refno;

      IF l_sch_num_count > 0
      THEN
         OPEN o_sch_count FOR SELECT 1 "sch_count" FROM DUAL;
      ELSE
         OPEN o_sch_count FOR SELECT 0 "sch_count" FROM DUAL;
      END IF;

      --RDT end Phoneix req [08-052014][Kiran]
      --RDT :MOP_CR_12.5 :Abhishek Mor 19/08/2014-Add Supplier Tab on Programme Maintenance-Start
      SELECT COUNT (gen_ser_number)
        INTO l_gen_ser_count
        FROM fid_general
       WHERE gen_refno = i_gen_refno;

      IF (l_gen_ser_count > 0)
      THEN
         SELECT gen_ser_number
           INTO l_gen_no
           FROM fid_general
          WHERE gen_refno = i_gen_refno;
      ELSE
         l_gen_no := i_gen_refno;
      END IF;

      OPEN o_PrgTitle_Supplier_Details FOR
         WITH SQL_QUERY
              AS (SELECT COM_NAME com_n,
                         con_short_name con_n,
                         com_number,
                         mem_id mem_i,
                         mhi_entry_date dt
                    FROM sak_memo_history,
                         sak_memo,
                         sak_memo_item,
                         fid_company,
                         fid_contract
                   WHERE     mhi_mem_id = mem_id
                         AND mei_mem_id = mem_id
                         AND mei_gen_refno = l_gen_no
                         AND mhi_action = 'EXECUTE'
                         AND mem_com_number = COM_NUMBER
                         AND mem_con_number = con_number
                  UNION ALL
                  SELECT DISTINCT COM_NAME com_n,
                                  NULL con_n,
                                  com_number,
                                  0 mem_i,
                                  tap_entry_date dt
                    FROM sgy_mn_lic_tape_cha_mapp,
                         fid_tape,
                         fid_general,
                         fid_company f4
                   WHERE     LTCM_TAP_NUMBER = tap_number
                         AND ltcm_gen_refno = gen_refno
                         AND COM_NUMBER = tap_com_number
                         AND gen_refno = l_gen_no
                         AND tap_uid_mem_number = 0
                         AND NOT EXISTS
                                    (SELECT 1
                                       FROM sak_memo_history,
                                            sak_memo,
                                            sak_memo_item,
                                            fid_company f3,
                                            fid_contract
                                      WHERE     mhi_mem_id = mem_id
                                            AND mei_mem_id = mem_id
                                            AND mei_gen_refno = l_gen_no
                                            AND mhi_action = 'EXECUTE'
                                            AND mem_com_number = COM_NUMBER
                                            AND mem_con_number = con_number
                                            AND f4.com_number = f3.com_number)
                  UNION ALL
                  SELECT DISTINCT COM_NAME com_n,
                                  NULL con_n,
                                  com_number,
                                  0 mem_i,
                                  tap_entry_date dt
                    FROM sgy_mn_lic_tape_cha_mapp,
                         fid_tape,
                         fid_license,
                         fid_company f4
                   WHERE     LTCM_TAP_NUMBER = tap_number
                         AND ltcm_lic_number = lic_number
                         AND COM_NUMBER = tap_com_number
                         AND lic_gen_refno = l_gen_no
                         AND tap_uid_mem_number = 0
                         AND NOT EXISTS
                                    (SELECT 1
                                       FROM sak_memo_history,
                                            sak_memo,
                                            sak_memo_item,
                                            fid_company f2,
                                            fid_contract
                                      WHERE     mhi_mem_id = mem_id
                                            AND mei_mem_id = mem_id
                                            AND mei_gen_refno = l_gen_no
                                            AND mhi_action = 'EXECUTE'
                                            AND mem_com_number = COM_NUMBER
                                            AND mem_con_number = con_number
                                            AND f4.com_number = f2.com_number))
           SELECT com_n,
                  con_n,
                  mem_i,
                  dt dt_max
             FROM SQL_QUERY
            WHERE (com_n, dt) IN (  SELECT com_n, MAX (dt)
                                      FROM SQL_QUERY
                                  GROUP BY com_n)
         ORDER BY dt DESC;

      --RDT :MOP_CR_12.5 :Abhishek Mor 19/08/2014-Add Supplier Tab on Programme Maintenance-End

      --RDT :Release 10 :NEERAJ 22/09/2014-Add Translated Titles Tab on Programme Maintenance-START

      OPEN o_PrgTitle_translated_titles FOR
         SELECT GT.TRANS_UNIQUE_ID, GT.TRANS_LANGUAGE, GT.TRANS_NAME,TG.XTG_GENRE_DESC,GT.TRANS_GENRE_ID
           FROM X_FID_GENERAL_ALT_TITLE GT
           LEFT JOIN X_TRANSLATED_GENRE TG
           ON GT.TRANS_GENRE_ID = TG.XTG_GENRE_ID
          WHERE trans_gen_refno = i_gen_refno;

      ----DBMS_OUTPUT.put_line ('translated Titles CURSOR');
      --RDT :MOP_CR_12.5 :NEERAJ 22/09/2014-Add Translated Titles Tab on Programme Maintenance-START

      /*Added by Swapnil Malvi on 15-Mar-2015 for Clearleap Release*/
      OPEN O_CATCHUP_VOD_DTL FOR
           SELECT VOD_DET.*,
                   PVTC_GEN_TITLE GEN_TITLE_COLOR,
                   PVTC_PVR_TITLE PVR_TITLE_COLOR,
                   PVTC_SHOW_TYPE SHOW_TYPE_COLOR,
                   PVTC_THEMES THEMES_COLOR,
                   PVTC_PRIMARY_GENRE PRIMARY_GENRE_COLOR,
                   PVTC_SECONDARY_GENRE SECONDARY_GENRE_COLOR,
                   PVTC_ACTORS ACTORS_COLOR,
                   PVTC_DIRECTORS DIRECTORS_COLOR,
                   PVTC_TITLE_SYNOPSIS TITLE_SYNOPSIS_COLOR,
                   PVTC_AFR_TITLE_SYNOPSIS AFR_TITLE_SYNOPSIS_COLOR,
                   PVTC_SYNOPSIS SYNOPSIS_SEA_COLOR,
                   PVTC_AFR_SYNOPSIS AFR_SYNOPSIS_SEA_COLOR,
                   PVTC_SYNOPSIS_SER SYNOPSIS_SER_COLOR,
                   PVTC_AFR_SYNOPSIS_SER AFR_SYNOPSIS_SER_COLOR,
                   pvtc_ser_title ser_title_color
            from ( SELECT UID_LANG_ID,
                        (SELECT L.UID_LANG_DESC
                           FROM X_UID_LANGUAGE L
                          WHERE L.UID_LANG_ID = A.UID_LANG_ID)
                           UID_LANG,
                  PVD.PVD_GEN_REFNO,
                  PVD.PVD_GEN_TITLE,
                  PVD.PVD_PVR_TITLE,
                  decode(is_series_flag,'Y',SER.SVD_SHOW_TYPE,pvd.PVD_SHOW_TYPE)PVD_SHOW_TYPE,
                  decode(is_series_flag,'Y',SER.SVD_THEMES,pvd.PVD_THEMES)PVD_THEMES,
                  decode(is_series_flag,'Y',SER.SVD_PRIMARY_GENRE,pvd.PVD_PRIMARY_GENRE)PVD_PRIMARY_GENRE,
                  (CASE WHEN is_series_flag = 'Y'
                    THEN
                      rtrim((SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_VALUE || ','))
                      .EXTRACT('//text()'),
                      ',') CAS_NAME
                      FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
                      WHERE COD_TYPE = 'VOD_GENRE'
                      AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
                      AND D.GD_GEN_REFNO = ser.SVD_SER_NUMBER
                      AND D.GD_IS_SERIES_FLAG = 'Y'
                      AND D.GD_LANG_ID = pvd.PVD_UID_LANG_ID),
                      ',')
                  ELSE
                      rtrim((SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_VALUE || ','))
                      .EXTRACT('//text()'),
                      ',') CAS_NAME
                      FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
                      WHERE COD_TYPE = 'VOD_GENRE'
                      AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
                      AND D.GD_GEN_REFNO = pvd.PVD_GEN_REFNO
                      AND D.GD_LANG_ID = pvd.PVD_UID_LANG_ID),
                      ',')
                  END)PVD_SECONDARY_GENRE,
                  (CASE WHEN is_series_flag = 'Y'
                    THEN
                      rtrim((SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_ATTR1 || ','))
                      .EXTRACT('//text()'),
                      ',') CAS_NAME
                      FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
                      WHERE COD_TYPE = 'VOD_GENRE'
                      AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
                      AND D.GD_GEN_REFNO = ser.SVD_SER_NUMBER
                      AND D.GD_IS_SERIES_FLAG = 'Y'
                      AND D.GD_LANG_ID = pvd.PVD_UID_LANG_ID),
                      ',')
                  ELSE
                      rtrim((SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_ATTR1 || ','))
                      .EXTRACT('//text()'),
                      ',') CAS_NAME
                      FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
                      WHERE COD_TYPE = 'VOD_GENRE'
                      AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
                      AND D.GD_GEN_REFNO = pvd.PVD_GEN_REFNO
                      AND D.GD_LANG_ID = pvd.PVD_UID_LANG_ID),
                      ',')
                  END)PVD_SECONDARY_GENRE_CODE,
                  /* Please Do not Remove the Commentted Code.
                  If Required We need to Undo the Changes.
                  Comment Added By khilesh Chauhan for Clear Leap Integration 14.04.2015
                  ----------------------------------------------------
                  rtrim(nvl(PVD.PVD_ACTORS,
                      (SELECT RTRIM(XMLAGG(XMLELEMENT(C,replace(CAS_NAME,',','')||',')).EXTRACT('//text()'),',') CAS_NAME
                        FROM   FID_GENERAL_CAST
                        WHERE  CAS_ROLE in ('ACTOR','ACTRESS')
                        AND  CAS_GEN_REFNO = PVD.PVD_GEN_REFNO)
                   ),',')PVD_ACTORS
                  ,rtrim(NVL(PVD.PVD_DIRECTORS,
                       (SELECT RTRIM(XMLAGG(XMLELEMENT(C,replace(CAS_NAME,',','')||',')).EXTRACT('//text()'),',') CAS_NAME
                        FROM   FID_GENERAL_CAST
                        WHERE CAS_ROLE ='DIRECT'
                        AND  CAS_GEN_REFNO = PVD.PVD_GEN_REFNO)
                   ),',')PVD_DIRECTORS,--
                   ---
                    ( case
                      when PVD_TITLE_SYNOPSIS is not null then
                      PVD_TITLE_SYNOPSIS
                                       when PVD_UID_LANG_ID=5 then
                      null
                       when pkg_mm_mnet_pl_prgmaintenance.X_FNC_PROG_IS_SER(PVD_GEN_REFNO)='Y' then
                      (select syn_synopsis from fid_synopsis where SYN_GEN_REFNO=PVD_GEN_REFNO and SYN_SYT_ID=6)
                     when pkg_mm_mnet_pl_prgmaintenance.X_FNC_PROG_IS_SER(PVD_GEN_REFNO)='N' then
                      (select syn_synopsis from fid_synopsis where SYN_GEN_REFNO=PVD_GEN_REFNO and SYN_SYT_ID=1)
                      end )PVD_TITLE_SYNOPSIS,
                      PVD_AFR_TITLE_SYNOPSIS,
                     ( case
                    when SEA.SVD_SYNOPSIS is not null then
                    SEA.SVD_SYNOPSIS
                                    when PVD_UID_LANG_ID=5 then
                      null
                    when  pkg_mm_mnet_pl_prgmaintenance.X_FNC_PROG_IS_SER(PVD_GEN_REFNO)='Y' then
                      (select syn_synopsis from fid_synopsis where SYN_GEN_REFNO=PVD_GEN_REFNO and SYN_SYT_ID=1)
                    end )SVD_SYNOPSIS_SEA,
                    SEA.SVD_AFR_SYNOPSIS SVD_AFR_SYNOPSIS_SEA
                    ,
                    ( case
                    when SER.SVD_SYNOPSIS is not null then
                    SER.SVD_SYNOPSIS
                                    when PVD_UID_LANG_ID=5 then
                      null
                    when  pkg_mm_mnet_pl_prgmaintenance.X_FNC_PROG_IS_SER(PVD_GEN_REFNO)='Y' then
                      (select syn_synopsis from fid_synopsis where SYN_GEN_REFNO=PVD_GEN_REFNO and SYN_SYT_ID=1)
                     end )SVD_SYNOPSIS_SER,
                    SER.SVD_AFR_SYNOPSIS SVD_AFR_SYNOPSIS_SER
                  ----------------------------------------------------
                  Commentted Code End Here
                  */
                  PVD.PVD_ACTORS,
                  PVD.PVD_DIRECTORS,
                  PVD_TITLE_SYNOPSIS,
                  PVD_AFR_TITLE_SYNOPSIS,
                  SEA.SVD_SYNOPSIS SVD_SYNOPSIS_SEA,
                  SEA.SVD_AFR_SYNOPSIS SVD_AFR_SYNOPSIS_SEA,
                  SER.SVD_SYNOPSIS SVD_SYNOPSIS_SER,
                  SER.SVD_AFR_SYNOPSIS SVD_AFR_SYNOPSIS_SER,
                  SEA.SVD_SER_TITLE,
                ---  SEA.SVD_SER_TITLE season_epg_title,  --added by sushma
                  pvd.PVD_SYN_VERSION pvd_title_ver,
                  SEA.SVD_SYN_VERSION SVD_season_ver,
                  SER.SVD_SYN_VERSION SVD_series_ver
             FROM X_UID_LANGUAGE A,
                  (SELECT l.uid_lang_id PVD_UID_LANG_ID,
                          g.gen_refno PVD_GEN_REFNO,
                          PVD_GEN_TITLE,
                          PVD_PVR_TITLE,
                          PVD_SHOW_TYPE,
                          PVD_THEMES,
                          PVD_PRIMARY_GENRE,
                          PVD_SECONDARY_GENRE,
                          PVD_ACTORS,
                          PVD_DIRECTORS,
                          PVD_TITLE_SYNOPSIS,
                          PVD_AFR_TITLE_SYNOPSIS,
                          gen_ser_number,
                          nvl((	SELECT cod_attr1
                                FROM fid_code WHERE cod_type = 'GEN_TYPE'
                                AND cod_value != 'HEADER'
                                AND UPPER(cod_value) = UPPER(g.gen_type)
                          ),'N') is_series_flag,
                          PVD_SYN_VERSION --Added by sushma
                     FROM X_PROG_VOD_DETAILS, fid_general g, x_uid_language l
                    WHERE g.gen_refno = PVD_GEN_REFNO(+)
                          AND l.uid_lang_id =
                                 NVL (pvd_uid_lang_id, l.uid_lang_id)
                          AND NVL (UID_LANG_IS_CATCHUP_VOD, 'N') = 'Y'
                          AND g.gen_refno = i_gen_refno
                                                       ) PVD,
                  (SELECT svd_ser_number,SVD_SER_TITLE,
                          SVD_SYNOPSIS SVD_SYNOPSIS,
                          SVD_AFR_SYNOPSIS SVD_AFR_SYNOPSIS,
                          SVD_UID_LANG_ID,
                          SVD_SYN_VERSION --Added by sushma
                     FROM X_SER_VOD_DETAILS
                    WHERE SVD_SER_NUMBER = l_gen_ser_number
                                                           ) SEA,
                  (SELECT svd_ser_number,
                          SVD_SER_TITLE,
                          SVD_SYNOPSIS,
                          SVD_AFR_SYNOPSIS,
                          SVD_UID_LANG_ID,
                          SVD_THEMES,
                          SVD_PRIMARY_GENRE,
                          SVD_SHOW_TYPE,
                          SVD_SYN_VERSION --Added by sushma
                     FROM X_SER_VOD_DETAILS
                    WHERE SVD_SER_NUMBER = l_ser_parent_number
                                                              ) SER
            WHERE     NVL (A.UID_LANG_IS_CATCHUP_VOD, 'N') = 'Y'
                  AND UID_LANG_ID = PVD_UID_LANG_ID(+)
                  AND UID_LANG_ID = SEA.SVD_UID_LANG_ID(+)
                  AND UID_LANG_ID = SER.SVD_UID_LANG_ID(+)
                  ) VOD_DET  ,
                  /*CU4ALL START : [ANUJA SHINDE]_[09/01/2016]*/
                  X_PROG_VOD_TAB_COLOR VOD_COLOR
            WHERE PVD_GEN_REFNO = PVTC_GEN_REFNO(+)
              and UID_LANG_ID = pvtc_uid_lang_id(+)
         ORDER BY UID_LANG_ID;
--   media Ops CR - Nasreen Mulla
    OPEN o_notes_details FOR
    SELECT XGT_ID,XGT_COMMENT,XGT_ENTRY_OPER,XGT_ENTRY_DATE
    FROM x_gen_notes--nasreen mulla
    WHERE XGT_GEN_REFNO = i_gen_refno
    ORDER BY XGT_ENTRY_DATE DESC;
    --   media Ops CR - Nasreen Mulla end
   /*END*/

    --CU4ALL :START Anuja Shinde
     OPEN o_GET_VOD_HISTORY_details FOR

            select PVDH_ID,LANG_NAME,FIELD_NAME,UPDATED_FROM,UPDATED_TO,USER_NAME,MOD_DATE,MOD_TIME,COMMENTS
                         from  (SELECT   PVDH_ID,
                                   UID_LANG_DESC LANG_NAME
                                  ,PVDH_FIELD_NAME FIELD_NAME
                                  ,PVDH_FROM_VALUE UPDATED_FROM
                                  ,PVDH_TO_VALUE UPDATED_TO
                                  ,PVDH_ENTRY_OPER USER_NAME
                                  ,PVDH_ENTRY_DATE MOD_DATE
                                  ,PVDH_ENTRY_TIME MOD_TIME
                                  ,PVDH_COMMENTS COMMENTS
                           FROM X_PROG_VOD_DETAIL_HISTORY,X_PROG_VOD_DETAILS,X_UID_LANGUAGE
                          WHERE PVDH_PVD_NUMBER = PVD_NUMBER
                            AND PVD_GEN_REFNO = I_GEN_REFNO
                            AND UID_LANG_ID = PVD_UID_LANG_ID
                         UNION
                          SELECT   PVDH_ID,
                                   UID_LANG_DESC LANG_NAME
                                  ,PVDH_FIELD_NAME FIELD_NAME
                                  ,PVDH_FROM_VALUE UPDATED_FROM
                                  ,PVDH_TO_VALUE UPDATED_TO
                                  ,PVDH_ENTRY_OPER USER_NAME
                                  ,PVDH_ENTRY_DATE MOD_DATE
                                  ,PVDH_ENTRY_TIME MOD_TIME
                                  ,PVDH_COMMENTS COMMENTS
                           FROM X_PROG_VOD_DETAIL_HISTORY,X_SER_VOD_DETAILS,X_UID_LANGUAGE
                          WHERE PVDH_PVD_NUMBER = SVD_NUMBER
                            AND SVD_SER_NUMBER = (SELECT GEN_SER_NUMBER FROM FID_GENERAL WHERE GEN_REFNO = I_GEN_REFNO)
                            AND UID_LANG_ID = SVD_UID_LANG_ID
                 UNION
                            SELECT  PVDH_ID,
                                     UID_LANG_DESC LANG_NAME
                                    ,PVDH_FIELD_NAME FIELD_NAME
                                    ,PVDH_FROM_VALUE UPDATED_FROM
                                    ,PVDH_TO_VALUE UPDATED_TO
                                    ,PVDH_ENTRY_OPER USER_NAME
                                    ,PVDH_ENTRY_DATE MOD_DATE
                                    ,PVDH_ENTRY_TIME MOD_TIME
                                    ,PVDH_COMMENTS COMMENTS
                             from X_PROG_VOD_DETAIL_HISTORY,X_SER_VOD_DETAILS,X_UID_LANGUAGE
                            WHERE PVDH_PVD_NUMBER = SVD_NUMBER
                              AND SVD_SER_NUMBER = (SELECT SER_PARENT_NUMBER FROM FID_GENERAL,FID_SERIES
                                                  WHERE GEN_SER_NUMBER = SER_NUMBER
                                                     AND GEN_REFNO = I_GEN_REFNO)
                              AND UID_LANG_ID = SVD_UID_LANG_ID
                     )  order by MOD_DATE Desc;

					 --Added by Pravin to get Role list
					 OPEN o_Role_List
					 FOR
						SELECT r.rolename
							  ,r.description
						FROM fwk_roletask rt,
						ora_aspnet_roles r
						where r.roleid = rt.roleid
						and taskid = 1051;
					--Pravin [END]

          --Vikas_20160615[BR_15_355_UC_CE and CD Version automation_v1] Added New REFCURSOR  to Get edit list customization data [Start]
          OPEN o_editlist_details
          FOR
             SELECT elc_sno,
	            elc_id,
                    elc_tap_barcode,
                    elc_gen_refno,
                    elc_comments,
                    elc_timecode_in,
                    elc_timecode_out,
                    elc_duration,
                    ver_group
              FROM x_edit_list_customization,x_cont_version
              WHERE ELC_VERSION_NUMBER =VER_ID
              AND elc_gen_refno =	I_gen_refno;

       --Vikas_20160615[BR_15_355_UC_CE and CD Version automation_v1] Added New REFCURSOR  to Get edit list customization data [END]
   END pck_mm_mnet_pl_searchprgdetail;

   PROCEDURE pck_mm_mnet_pl_deleteprogram (
      i_gen_refno        IN     fid_general.gen_refno%TYPE,
      i_entry_oper       IN     fid_general.gen_entry_oper%TYPE,
      o_programdeleted      OUT NUMBER)
   AS
      fieldhasreference      EXCEPTION;
      i_countref             NUMBER;
      l_ser_number           NUMBER;
      l_deal_memo_prg        NUMBER;
      l_pro_number           fid_production.pro_number%TYPE;
      l_tape_cnt             NUMBER;
      l_sched_c              NUMBER;
      l_lic_c                NUMBER;
      l_deal_memo_prg_cnt    NUMBER;
      program_pesent_in_dm   EXCEPTION;
      l_number               NUMBER;
      l_gen_epi_count        Number;
   BEGIN
      o_programdeleted := -1;

      SELECT pkg_cm_username.setusername (i_entry_oper)
        INTO l_number
        FROM DUAL;

      BEGIN
         SELECT gen_ser_number
           INTO l_ser_number
           FROM fid_general
          WHERE gen_refno = i_gen_refno;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20103,
                                     'The Episode number does not exist.');
      END;

      BEGIN
         SELECT COUNT (sch_gen_refno)
           INTO l_sched_c
           FROM fid_schedule, fid_license
          WHERE sch_lic_number = lic_number AND lic_gen_refno = i_gen_refno;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_sched_c := 0;
      END;

      IF l_sched_c > 0
      THEN
         raise_application_error (
            -20104,
            'This Programme has been scheduled currently. Hence it cannot be deleted.');
      END IF;

      BEGIN
         SELECT COUNT (lic_gen_refno)
           INTO l_lic_c
           FROM fid_license
          WHERE lic_gen_refno = i_gen_refno;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_lic_c := 0;
      END;

      --DBMS_OUTPUT.put_line ('Lice count ' || l_lic_c);

      IF l_lic_c > 0
      THEN
         raise_application_error (
            -20105,
            'A License exists for this Episode/Programme. Hence cannot delete this Episode/Programme.');
      END IF;

      /* IF l_ser_number IS NULL
      THEN
      SELECT COUNT (mei_mem_id)
      INTO l_deal_memo_prg
      FROM sak_memo_item mei
      WHERE mei.mei_gen_refno = i_gen_refno;
      ELSE
      SELECT COUNT (mei_mem_id)
      INTO l_deal_memo_prg
      FROM sak_memo_item mei
      WHERE mei.mei_gen_refno = l_ser_number;
      END IF;*/
      IF l_ser_number IS NULL
      THEN
         SELECT COUNT (mei_mem_id)
           INTO l_deal_memo_prg_cnt
           FROM sak_memo_item mei, sak_memo
          WHERE     mem_id = mei_mem_id
                AND mem_status IN ('EXECUTED', 'BEXECUTED')
                AND mei.mei_gen_refno = i_gen_refno;
      ELSE
         SELECT COUNT (mei_mem_id)
           INTO l_deal_memo_prg_cnt
           FROM sak_memo_item mei, sak_memo, fid_license
          WHERE     mem_id = mei_mem_id
                AND mem_status IN ('EXECUTED', 'BEXECUTED')
                AND mei.mei_gen_refno = l_ser_number
                AND lic_gen_refno = i_gen_refno;
      END IF;

      /* IF l_deal_memo_prg_cnt != 0
      THEN
      -- raise_application_error(-20106,'A Deal Memo is Executed for this Episode/Programme. Hence cannot delete this Episode/Programme.');
      RAISE program_pesent_in_dm;
      END IF;*/
      IF l_deal_memo_prg_cnt = 0
      THEN
         SELECT COUNT (tap_title)
           INTO i_countref
           FROM fid_tape ft, fid_production fp, fid_general fg
          WHERE     ft.tap_pro_number = fp.pro_number
                AND fg.gen_refno = fp.pro_gen_refno
                AND fp.pro_gen_refno = i_gen_refno;

         BEGIN
            SELECT pro_number
              INTO l_pro_number
              FROM fid_production
             WHERE pro_gen_refno = i_gen_refno;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_pro_number := 0;
         END;

         --DBMS_OUTPUT.put_line ('PROD NUMBER : ' || l_pro_number);

         IF l_pro_number = 0
         THEN
            NULL;
         ELSE
            BEGIN
               SELECT COUNT (tap_number)
                 INTO l_tape_cnt
                 FROM fid_tape
                WHERE tap_pro_number = l_pro_number;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_tape_cnt := 0;
            END;
         END IF;

         --Dev.R1: UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[24-01-2014]
         --Renamed Tape to Media Asset
         --DBMS_OUTPUT.put_line ('MEDIA ASSET COUNT : ' || l_tape_cnt);

         IF l_pro_number = 0
         THEN
            NULL;
         ELSE
            IF l_tape_cnt > 0
            THEN
               raise_application_error (
                  -20106,
                  'A Media Asset is linked to this Programme. Hence cannot delete this Programme.');
            --Dev.R1: UID_Generation: End
            ELSE
               DELETE FROM fid_production
                     WHERE pro_number = l_pro_number;

               --DBMS_OUTPUT.put_line ('PRODUCTION DELETED');
            END IF;
         END IF;

         IF i_countref = 0
         THEN
            DELETE FROM fid_promo_programme
                  WHERE ppr_gen_refno = i_gen_refno;

            -- ------DBMS_OUTPUT.PUT_LINE('Deleted Changed IS_DELETED');
            DELETE FROM fid_gen_live
                  WHERE fgl_gen_refno = i_gen_refno;

            DELETE FROM fid_attach_file
                  WHERE afi_gen_refno = i_gen_refno;

            DELETE FROM fid_general_local
                  WHERE loc_gen_refno = i_gen_refno;

            DELETE FROM fid_synopsis
                  WHERE syn_gen_refno = i_gen_refno;

            DELETE FROM fid_general_cast
                  WHERE cas_gen_refno = i_gen_refno;

            DELETE FROM fid_programme_element
                  WHERE pre_gen_refno = i_gen_refno;

            /*Added by Swapnil Malvi on 20-Mar-2015 for Clearleap Release*/
            DELETE FROM x_prog_vod_details v
                  WHERE v.pvd_gen_refno = i_gen_refno;

            /*END*/

            /*Dev.R1: Scheduling CR Implementation: Start:[BR_15_314_Schedule higher rated on daytime_1.0]_[Ankur Kasar]_[01-09-2016]*/
              DELETE FROM X_ADD_INFO_TX_WARNNING
                    WHERE AITW_GEN_REFNO =  i_gen_refno;
            /*Dev.R1: Scheduling CR Implementation: END*/
            DELETE FROM fid_general
                  WHERE gen_refno = i_gen_refno;


                   -----deede by rashmi 20-06-2016:start
            SELECT count (gen_epi_number)
              INTO l_gen_epi_count
              FROM fid_general
             WHERE gen_ser_number =l_ser_number;


         update fid_Series
         set SER_SEA_EPI_COUNT = l_gen_epi_count
         where ser_number =l_ser_number;
  --------------by rashmi 20-06-2016:End


            COMMIT;
            o_programdeleted := 1;
         ELSE
            RAISE fieldhasreference;
         END IF;
      ELSE
         RAISE program_pesent_in_dm;
      END IF;
   EXCEPTION
      WHEN program_pesent_in_dm
      THEN
         NULL;
         raise_application_error (
            -20107,
            'This Programme is linked to a Deal Memo and hence cannot be deleted.');
      WHEN fieldhasreference
      THEN
         ROLLBACK;
         --Dev.R1: UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[24-01-2014]
         --Renamed Tape to Media Asset
         raise_application_error (
            -20108,
            'A Media Asset is linked to this Programme. Hence cannot delete this Programme.');
   --Dev.R1: UID_Generation: End
   END pck_mm_mnet_pl_deleteprogram;

   PROCEDURE pck_mm_mnet_pl_searchprglink (
      i_gen_working_title   IN     fid_general.gen_title_working%TYPE,
      i_gen_title           IN     fid_general.gen_title%TYPE,
      i_gen_refno           IN     VARCHAR2,
      i_lic_number          IN     fid_license.lic_number%TYPE,
      o_returnprogram          OUT SYS_REFCURSOR,
      o_returnlicense          OUT SYS_REFCURSOR,
      o_returnchannel          OUT SYS_REFCURSOR)
   AS
      l_lic_count   NUMBER;
      str           VARCHAR2 (5000);
      str1          VARCHAR2 (5000);
      str2          VARCHAR2 (5000);
   BEGIN
      /*
      select count(lic_number)
      into    l_lic_count
      from fid_license
      ,fid_general
      where gen_refno = lic_gen_refno
      and gen_title_working LIKE NVL (i_gen_working_title, '%')
      and lic_number  = decode(i_lic_number,'',lic_number,i_lic_number)
      and to_char(lic_gen_refno) like decode(i_gen_refno,'',to_char(gen_refno),i_gen_refno)
      ;
      if l_lic_count =0
      then
      raise_application_error(-20108,'No License available for this Genrefno, hence no record found.');
      end if;
      */
      str :=
         'SELECT gen_title pro_title
,gen_title_working
,pro_number
,gen_refno pro_gen_refno
,gen_release_year,
gen_supplier_com_number, gen_category,
gen_subgenre,
fid_code.cod_description gen_type,
parentseries.ser_title series_title,
series.ser_title season_title,
fid_company.com_short_name supplier_name,
count(fid_tape.tap_pro_number) total_count
FROM fid_general
INNER JOIN fid_production ON fid_general.gen_refno = fid_production.pro_gen_refno
LEFT OUTER JOIN fid_code ON fid_general.gen_type = fid_code.cod_value AND fid_code.cod_type = ''GEN_TYPE''
LEFT OUTER JOIN fid_series series ON fid_general.gen_ser_number = series.ser_number
LEFT OUTER JOIN fid_series parentseries ON series.ser_parent_number = parentseries.ser_number
LEFT OUTER JOIN fid_company ON fid_general.gen_supplier_com_number = fid_company.com_number
LEFT OUTER JOIN fid_tape ON fid_production.pro_number = fid_tape.tap_pro_number
--GROUP BY tap_pro_number) b ON a.pro_number = b.tap_pro_number
WHERE gen_title_working LIKE NVL ('''
         || i_gen_working_title
         || ''', ''%'')
and  to_char(gen_refno) LIKE decode ('''
         || i_gen_refno
         || ''','''',to_char(gen_refno),'''
         || i_gen_refno
         || ''')';

      IF i_lic_number IS NOT NULL
      THEN
         str :=
               str
            || '
and  gen_refno in ( select lic_gen_refno
from fid_license
where lic_number = decode('''
            || i_lic_number
            || ''','''',lic_number,'''
            || i_lic_number
            || ''')
-- CP R2 mrunmayi kusurkar
and NVL(lic_catchup_flag,''N'') = ''N''
-- end
)';
      END IF;

      str :=
         str
         || '
  GROUP BY gen_title, gen_title_working, pro_number, gen_refno, gen_release_year, gen_supplier_com_number, gen_category, gen_subgenre, fid_code.cod_description, parentseries.ser_title, series.ser_title, fid_company.com_short_name
  ORDER BY gen_refno,pro_gen_refno,gen_title';
      --DBMS_OUTPUT.put_line (str);

      OPEN o_returnprogram FOR str;

      str1 :=
            'select lic_number
,gen_title_working
,gen_refno
,( select chs_short_name
from fid_channel_service
where chs_number = lic_chs_number
) chs_short_name
,lic_status
,lic_start
,lic_end
from fid_license
,fid_general
where gen_refno = lic_gen_refno
-- CP R2 mrunmayi kusurkar
and NVL(lic_catchup_flag,''N'') = ''N''
-- end
and gen_title_working LIKE NVL ('''
         || i_gen_working_title
         || ''', ''%'')
and lic_number  = decode('''
         || i_lic_number
         || ''','''',lic_number,'''
         || i_lic_number
         || ''')
and to_char(lic_gen_refno) like decode('''
         || i_gen_refno
         || ''','''',to_char(gen_refno),'''
         || i_gen_refno
         || ''')';

      OPEN o_returnlicense FOR str1;

      --DBMS_OUTPUT.put_line (str1);
      /*
      str2 := 'select lic_number
      ,csc_cha_number
      ,( select cha_name
      from fid_channel
      where cha_number = csc_cha_number
      ) cha_name
      from fid_general
      ,fid_channel_service_channel
      ,fid_license
      where gen_refno = lic_gen_refno
      and lic_chs_number = csc_chs_number
      and gen_title_working LIKE NVL ('''||i_gen_working_title||''', ''%'')
      and lic_number  = decode('''||i_lic_number||''','''',lic_number,'''||i_lic_number||''')
      and to_char(lic_gen_refno) LIKE  decode('''||i_gen_refno||''','''',to_char(gen_refno),'''||i_gen_refno||''')
      order by lic_number'
      ;
      */
      str2 :=
         'select lic_number
,csc_cha_number
,( select cha_name
from fid_channel
where cha_number = csc_cha_number
) cha_name
from fid_general
,( select csc_cha_number ,csc_chs_number
from
(
select csc_cha_number ,csc_chs_number from fid_channel_service_channel
UNION
SELECT chs_cha_number,chs_number  FROM fid_channel_service
)
)
,fid_license
where gen_refno = lic_gen_refno
and  lic_chs_number = csc_chs_number
-- CP R2 mrunmayi kusurkar
and NVL(lic_catchup_flag,''N'') = ''N''
-- end
and  gen_title_working LIKE NVL ('''
         || i_gen_working_title
         || ''', ''%'')
and  lic_number  = decode('''
         || i_lic_number
         || ''','''',lic_number,'''
         || i_lic_number
         || ''')
and  to_char(lic_gen_refno) LIKE  decode('''
         || i_gen_refno
         || ''','''',to_char(gen_refno),'''
         || i_gen_refno
         || ''')
order by lic_number';
      --DBMS_OUTPUT.put_line (str2);

      OPEN o_returnchannel FOR str2;

      --DBMS_OUTPUT.put_line (str2);
   END pck_mm_mnet_pl_searchprglink;

   PROCEDURE pck_mm_mnet_pl_searchtapelink (
      i_tap_title            IN     fid_tape.tap_title%TYPE,
      i_tap_status           IN     fid_tape.tap_match_status%TYPE,
      i_tap_type             IN     fid_tape.tap_type%TYPE,
      i_tap_num              IN     fid_tape.tap_barcode%TYPE,
      o_tapedetail              OUT SYS_REFCURSOR,
      o_tapesegmentdetails      OUT pkg_mm_mnet_pl_prgmaintenance.c_cursor_prg,
      --UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[24-01-2014]
      o_uid_excp                OUT VARCHAR2             --UID_Generation: End
                                            )
   AS
      querystr             VARCHAR2 (9000);
      --UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[24-01-2014]
      l_uid_exists_count   NUMBER;
      l_temp_msg           VARCHAR2 (500);
      l_umd_uid_length     NUMBER;
   BEGIN
      --UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[24-01-2014]
      l_temp_msg := '';

      IF i_tap_num IS NOT NULL
      THEN
         SELECT COUNT (1)
           INTO l_uid_exists_count
           FROM fid_tape
          WHERE tap_barcode = i_tap_num AND NVL (tap_is_uid, 'N') = 'Y' --and length(i_tap_num) = l_umd_uid_length
                                                                       ;

         IF l_uid_exists_count > 0
         THEN
            l_temp_msg :=
               'For searched parameter UID details can be viewed on UID Maintenance screen.';
         END IF;
      END IF;

      --UID_Generation: End
      querystr :=
         'SELECT tap_number
          ,tap_title
          ,TAP_PRO_NUMBER
,tap_type
          ,tap_match_status
          ,tap_barcode
          ,( select ltcm_lic_number
          from sgy_mn_lic_tape_cha_mapp
          where ltcm_tap_number = tap_number
          and rownum < 2
          ) LIC_NUMBER
          ,TAP_FORMAT_TYPE
          ,TAP_LENGTH
          ,tap_type
         /* --Dev.R1: UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[16-01-2014]
          ,DECODE(UID_STATUS,''Title Associated'',null,''Asset Associated'',TAP_FORMAT_TYPE,'''') TAP_FORMAT_TYPE
          ,DECODE(UID_STATUS,''Title Associated'',null,''Asset Associated'',TAP_LENGTH,'''') TAP_LENGTH
          ,DECODE(UID_STATUS,''Title Associated'',null,''Asset Associated'',nvl(tap_uid_version,tap_type),'''') tap_type
          --Dev.R1: UID_Generation: End*/
          ,tap_aspect_ratio
          ,(
          select ltcm_link_date
          from sgy_mn_lic_tape_cha_mapp
          where ltcm_tap_number = tap_number
          and rownum < 2
          ) link_date
          ,(
          select ltcm_item_id
          from sgy_mn_lic_tape_cha_mapp
          where ltcm_tap_number = tap_number
          and rownum < 2
          ) ITEM_ID
          ,TAP_FORMAT

      FROM fid_tape
      --Dev.R1: UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[16-01-2014]
           --,x_uid_status
     -- where UID_STATUS_ID = TAP_UID_STATUS_ID
      --Dev.R1: UID_Generation: End
      where ROWNUM < 1001
      and nvl(TAP_IS_UID,''N'') =''N''
      and length(tap_barcode) <= 8';

      IF (i_tap_title IS NOT NULL)
      THEN
         querystr :=
               querystr
            || ' AND UPPER(tap_title) like UPPER(''%'
            || i_tap_title
            || '%'')';
      END IF;

      IF (i_tap_status IS NOT NULL)
      THEN
         querystr :=
               querystr
            || ' AND UPPER(tap_match_status) like UPPER('''
            || i_tap_status
            || ''')';
      END IF;

      IF (i_tap_type IS NOT NULL)
      THEN
         querystr :=
               querystr
            || ' AND UPPER(tap_type) like UPPER('''
            || i_tap_type
            || ''')';
      END IF;

      IF (i_tap_num IS NOT NULL AND i_tap_num <> '00000000')
      THEN
         querystr :=
               querystr
            || ' AND UPPER(tap_barcode) like UPPER('''
            || i_tap_num
            || ''')';
      END IF;

      querystr := querystr || ' ORDER BY tap_pro_number';
      --DBMS_OUTPUT.put_line (querystr);
      --UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[24-01-2014]
      o_uid_excp := l_temp_msg;

      --UID_Generation: End
      OPEN o_tapedetail FOR querystr;

      querystr :=
         'SELECT fid_tape_segment.tas_tap_number AS TapeNumber,
         fid_programme_element.pre_title AS SegmentTitle,
         fid_tape_segment.tas_segment AS SegementSequence,
         fid_tape_segment.tas_som AS SOM,
         fid_tape_segment.tas_eom AS EOM,
         LTRIM (TO_CHAR (FLOOR (fid_programme_element.pre_duration / 90000), ''09'')) || '':'' ||
          LTRIM (TO_CHAR (FLOOR (MOD (fid_programme_element.pre_duration, 90000) / 1500),''09'')) || '':'' ||
          LTRIM (TO_CHAR (FLOOR (MOD (fid_programme_element.pre_duration, 1500) / 25),''09'')) || '':'' ||
          LTRIM (TO_CHAR (MOD (pre_duration, 25), ''09'')) AS SegmentDuration,
         fid_tape_segment.tas_audio_1 "AudioTrack1",
         fid_tape_segment.tas_audio_2 "AudioTrack2",
         fid_tape_segment.tas_audio_3 "AudioTrack3",
         fid_tape_segment.tas_audio_4 "AudioTrack4"
         FROM fid_tape_segment
         INNER JOIN fid_programme_element
         ON fid_tape_segment.tas_pre_number = fid_programme_element.pre_number
         WHERE fid_tape_segment.tas_tap_number in
         (
            SELECT tap_number
            FROM fid_tape
            WHERE ROWNUM < 1001 ';

      IF (i_tap_title IS NOT NULL)
      THEN
         querystr :=
               querystr
            || ' AND UPPER(tap_title) like UPPER('''
            || i_tap_title
            || ''')';
      END IF;

      IF (i_tap_status IS NOT NULL)
      THEN
         querystr :=
               querystr
            || ' AND UPPER(tap_match_status) like UPPER('''
            || i_tap_status
            || ''')';
      END IF;

      IF (i_tap_type IS NOT NULL)
      THEN
         querystr :=
               querystr
            || ' AND UPPER(tap_type) like UPPER('''
            || i_tap_type
            || ''')';
      END IF;

      IF (i_tap_num IS NOT NULL AND i_tap_num <> '00000000')
      THEN
         querystr :=
               querystr
            || ' AND UPPER(tap_barcode) like UPPER('''
            || i_tap_num
            || ''')';
      END IF;

      querystr :=
         querystr || ')
         ORDER BY fid_tape_segment.tas_tap_number';
      --DBMS_OUTPUT.put_line (querystr);

      OPEN o_tapesegmentdetails FOR querystr;
   /* OPEN o_tapedetail FOR
   SELECT tap_number, tap_title, tap_pro_number, tap_type,
   tap_match_status, tap_barcode, tap_format_type, tap_length
   FROM fid_tape
   WHERE tap_title LIKE NVL (i_tap_title, '%')
   AND tap_match_status LIKE NVL (i_tap_status, '%')
   AND tap_type LIKE NVL (i_tap_type, '%')
   AND tap_barcode LIKE NVL (i_tap_num, '%')
   AND ROWNUM < 501; */
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END pck_mm_mnet_pl_searchtapelink;

   PROCEDURE pck_mm_mnet_pl_linktitles (
      i_tap_tile             IN     fid_tape.tap_title%TYPE,
      i_tap_number           IN     fid_tape.tap_number%TYPE,
      i_gen_refno            IN     fid_general.gen_refno%TYPE,
      i_txm_id               IN     sgy_mn_txm_details.txm_id%TYPE,
      i_pronumber            IN     fid_production.pro_number%TYPE,
      i_lic_number           IN     fid_license.lic_number%TYPE,
      i_cha_list             IN     VARCHAR2,
      i_tap_pro_num          IN     fid_tape.tap_pro_number%TYPE,
      i_match_status         IN     fid_tape.tap_match_status%TYPE,
      i_linkflag             IN     VARCHAR2,
      i_entry_oper           IN     fid_tape.tap_entry_oper%TYPE,
      o_tapedetails             OUT pkg_mm_mnet_pl_prgmaintenance.c_cursor_prg,
      o_tapesegmentdetails      OUT pkg_mm_mnet_pl_prgmaintenance.c_cursor_prg)
   AS
      l_pronumber                 NUMBER;
      l_flag                      NUMBER;
      l_progennumber              NUMBER;
      l_tap_number                NUMBER;
      l_tappronumber              NUMBER;
      o_success                   NUMBER;
      l_fid_tape_pro_number_chk   NUMBER;
      l_cha_number                NUMBER;
      l_cha_list                  VARCHAR2 (100);
      l_error_lic                 VARCHAR2 (10);
      l_error_tap                 VARCHAR2 (10);
      l_ltcm_tap_number_cnt       NUMBER;
      l_ltcm_lic_number_cnt       NUMBER;
      l_ltcm_id                   NUMBER;
      l_txm_count                 NUMBER;
      l_cnt                       NUMBER := 1;
      l_frm_id                    NUMBER := 0;
      l_txm_id                    NUMBER := 0;
      valuesnotentered            EXCEPTION;
      l_tap_type                  fid_tape.tap_type%TYPE;
      l_match_status              fid_tape.tap_match_status%TYPE;
      l_entry_oper                VARCHAR2 (50);
      l_ardomeid                  VARCHAR (30);
      l_fam_id                    NUMBER;
      l_tmpvar                    NUMBER;
      l_tap_number1               NUMBER;
      l_ver_id                    NUMBER;
   BEGIN
      l_fid_tape_pro_number_chk := i_tap_pro_num;
      l_flag := 0;
      /*SELECT tap_number
      INTO l_tap_number
      FROM fid_tape
      WHERE tap_title LIKE i_tap_tile;
      */
      l_tap_number := i_tap_number;
      l_pronumber := i_pronumber;
      l_tappronumber := i_tap_pro_num;
      l_match_status := i_match_status;
      l_cha_list := i_cha_list;
      l_entry_oper := pkg_cm_username.setusername (i_entry_oper);

      BEGIN
         SELECT pro_gen_refno
           INTO l_progennumber
           FROM fid_production
          WHERE pro_number = l_pronumber;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20007, l_pronumber || SQLERRM);
      END;

      -- Start : Logic For storing ArdomeID into X_FID_ARDOME_MAPP
      BEGIN
         IF i_linkflag = 'UNLINK'
         THEN
            BEGIN
               SELECT fam_item_id
                 INTO l_tmpvar
                 FROM x_fid_ardome_mapp
                WHERE fam_tap_number = i_tap_number;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_tmpvar := 0;
            END;

            BEGIN
               SELECT ltcm_item_id
                 INTO l_ardomeid
                 FROM sgy_mn_lic_tape_cha_mapp
                WHERE ltcm_tap_number = i_tap_number AND ROWNUM < 2;

               --DBMS_OUTPUT.put_line (l_tmpvar);

               IF     l_tmpvar <= 0
                  AND l_ardomeid IS NOT NULL
                  AND LENGTH (l_ardomeid) > 0
               THEN
                  l_fam_id := x_fid_ardome_mapp_id_seq.NEXTVAL;

                  INSERT INTO x_fid_ardome_mapp (fam_id,
                                                 fam_tap_number,
                                                 fam_item_id,
                                                 fam_link_date,
                                                 fam_entry_oper)
                       VALUES (l_fam_id,
                               i_tap_number,
                               l_ardomeid,
                               SYSDATE,
                               i_entry_oper);
               ELSE
                  IF l_ardomeid IS NOT NULL AND LENGTH (l_ardomeid) > 0
                  THEN
                     UPDATE x_fid_ardome_mapp
                        SET fam_item_id = l_ardomeid,
                            fam_link_date = SYSDATE,
                            fam_entry_oper = i_entry_oper
                      WHERE fam_tap_number = i_tap_number;
                  END IF;
               END IF;

            END;
         END IF;
      END;

      -- End:

      /*SELECT pro_number
      INTO l_pronumber
      FROM fid_production
      WHERE pro_gen_refno = l_progennumber;*/
      /* --logic for count of linked tapes
      select count(*)
      into  o_count
      from fid_tape
      where tap_pro_number =l_tap_number;
      */
      --Unlinking Logic
      IF l_pronumber IS NULL
      THEN
         raise_application_error (
            -20980,
            'Please query/choose a Production Title first');
      ELSE
         -- --DBMS_OUTPUT.put_line ('l_pronumber' || l_pronumber || ' ' || l_flag);
         IF     i_tap_pro_num != i_pronumber
            AND i_match_status IS NULL
            AND i_linkflag = 'UNLINK'
         THEN
            -- l_tappronumber := i_pronumber;
            l_match_status := 'LK-B';

            UPDATE fid_tape
               SET tap_pro_number = i_pronumber,
                   tap_match_status = l_match_status,
                   --   TAP_ENTRY_OPER = i_entry_oper,
                   --   TAP_ENTRY_DATE = SYSDATE,
                   tap_update_count = tap_update_count + 1
             WHERE tap_number = l_tap_number;

            UPDATE fid_programme_element
               SET pre_gen_refno = l_progennumber,
                   pre_pro_number = i_pronumber,
                   pre_entry_oper = i_entry_oper,
                   pre_entry_date = SYSDATE,
                   pre_update_count = pre_update_count + 1
             WHERE pre_number IN (SELECT tas_pre_number
                                    FROM fid_tape_segment
                                   WHERE tas_tap_number = l_tap_number);

            DELETE FROM sgy_mn_lic_tape_cha_mapp
                  WHERE ltcm_tap_number = l_tap_number;

            UPDATE sgy_mn_txm_details
               SET txm_tape_no = '',
                   txm_prod_link_date = '',
                   txm_prod_link_by = '',
                   txm_lic_number = ''
             WHERE txm_tape_no = l_tap_number;

            UPDATE sgy_mn_frm_details
               SET frm_tape_no = '',
                   frm_prod_link_date = '',
                   frm_prod_link_by = '',
                   frm_lic_number = ''
             WHERE frm_tape_no = l_tap_number;

            o_success := 1;
         -- l_flag := 1;
         ----DBMS_OUTPUT.put_line ('l_pronumber' || l_pronumber || ' '| l_flag );
         /* elsif I_Match_Status='LK-B' and i_linkflag='UNLINK' then
         l_flag:=1;
         --- l_tappronumber := L_fid_tape_pro_number_chk;*/
         ELSE
            l_match_status := NULL;

            UPDATE fid_tape
               SET tap_pro_number = l_fid_tape_pro_number_chk,
                   tap_match_status = l_match_status,
                   --   TAP_ENTRY_OPER = i_entry_oper,
                   --   TAP_ENTRY_DATE = SYSDATE,
                   tap_update_count = tap_update_count + 1
             WHERE tap_number = i_tap_number;

            UPDATE fid_programme_element
               SET pre_gen_refno = l_progennumber,
                   pre_pro_number = l_pronumber,
                   pre_entry_oper = i_entry_oper,
                   pre_entry_date = SYSDATE,
                   pre_update_count = pre_update_count + 1
             WHERE pre_number IN (SELECT tas_pre_number
                                    FROM fid_tape_segment
                                   WHERE tas_tap_number = i_tap_number);

            IF i_linkflag = 'UNLINK'
            THEN
               DELETE FROM sgy_mn_lic_tape_cha_mapp
                     WHERE ltcm_tap_number = i_tap_number;

               /*    --Start : update media version on future schedules if barcode is prod linked  (Content version scheduling change)
               FOR i IN (SELECT DISTINCT sch_lic_number, sch_cha_number
                                    FROM fid_schedule, fid_license
                                   WHERE sch_lic_number = lic_number
                                     AND lic_gen_refno = l_progennumber
                                     AND TO_DATE (sch_date) >
                                                             TO_DATE (SYSDATE))
               LOOP
                  pkg_ssc_scheduling.x_prc_get_bestfit_media_ver
                                                           (i.sch_cha_number,
                                                            i.sch_lic_number,
                                                            l_ver_id,
                                                            l_tap_number1
                                                           );

                  IF i_tap_number = l_tap_number1
                  THEN
                     UPDATE fid_schedule
                        SET sch_ver_id = l_ver_id,
                            sch_tap_number = l_tap_number1
                      WHERE TO_DATE (sch_date) > TO_DATE (SYSDATE)
                        AND sch_cha_number = i.sch_cha_number
                        AND sch_lic_number = i.sch_lic_number;
                  END IF;

               END LOOP;
            --End  : update media version on future schedules if barcode is prod linked  (Content version scheduling change)*/
               UPDATE sgy_mn_txm_details
                  SET txm_tape_no = '',
                      txm_prod_link_date = '',
                      txm_prod_link_by = '',
                      txm_lic_number = ''
                WHERE txm_tape_no = l_tap_number;

               UPDATE sgy_mn_frm_details
                  SET frm_tape_no = '',
                      frm_prod_link_date = '',
                      frm_prod_link_by = '',
                      frm_lic_number = ''
                WHERE frm_tape_no = l_tap_number;
            END IF;

            o_success := 1;
         END IF;
      END IF;

      --DBMS_OUTPUT.put_line ('checking 1');

      IF i_linkflag = 'LINK'
      THEN
         IF i_lic_number IS NULL
         THEN
            --DBMS_OUTPUT.put_line ('checking inside');
            raise_application_error (
               -20077,
               'You can not link title without License');
         END IF;

         --DBMS_OUTPUT.put_line ('checking 2');

         SELECT tap_type
           INTO l_tap_type
           FROM fid_tape
          WHERE tap_number = i_tap_number;

         SELECT COUNT (ltcm_tap_number)
           INTO l_ltcm_tap_number_cnt
           FROM sgy_mn_lic_tape_cha_mapp, fid_tape
          WHERE     ltcm_tap_number = tap_number
                AND tap_type = 'FRM'
                AND ltcm_tap_number = i_tap_number;

         SELECT COUNT (ltcm_lic_number)
           INTO l_ltcm_lic_number_cnt
           FROM sgy_mn_lic_tape_cha_mapp, fid_tape
          WHERE     ltcm_tap_number = tap_number
                AND tap_type = 'FRM'
                AND ltcm_lic_number = i_lic_number;

         SELECT COUNT (*)
           INTO l_txm_count
           FROM sgy_mn_lic_tape_cha_mapp, fid_tape
          WHERE     tap_type = 'TXM'
                AND ltcm_tap_number = tap_number
                AND ltcm_lic_number = i_lic_number
                AND ltcm_tap_number = i_tap_number;

         IF (l_tap_type = 'FRM' AND (l_ltcm_tap_number_cnt > 0))
            OR (l_tap_type = 'TXM' AND (l_txm_count > 0))
         THEN
            SELECT DISTINCT ltcm_lic_number
              INTO l_error_lic
              FROM sgy_mn_lic_tape_cha_mapp, fid_tape
             WHERE     ltcm_tap_number = tap_number
                   AND tap_type = l_tap_type
                   AND ltcm_tap_number = i_tap_number;

            --Dev.R1: UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[24-01-2014]
            --Renamed Tape to Media Asset
            raise_application_error (
               -20109,
               'Media Asset is already Linked with License No - '
               || l_error_lic);
         --Dev.R1: UID_Generation: End
         /*        if l_ltcm_tap_number_cnt > 0 AND l_ltcm_lic_number_cnt = 0
         then
         select distinct LTCM_LIC_NUMBER
         into  l_error_lic
         from   sgy_mn_lic_tape_cha_mapp
         ,fid_tape
         where    ltcm_tap_number = tap_number
         and    tap_type = l_tap_type
         and    ltcm_tap_number = i_tap_number
         ;
         raise_application_error (-20109,'Tape is already Linked with License No - '|| l_error_lic);
         elsif    l_ltcm_tap_number_cnt = 0 AND l_ltcm_lic_number_cnt > 0
         then
         select tap_barcode
         into  l_error_tap
         from fid_tape
         where tap_number in
         (
         select distinct LTCM_TAP_NUMBER
         from   sgy_mn_lic_tape_cha_mapp
         ,fid_tape
         where   ltcm_tap_number = tap_number
         and    tap_type = l_tap_type
         and    ltcm_lic_number = i_lic_number
         );
         raise_application_error (-20109,'License is already Linked with Tape No - '|| l_error_tap);
         else
         select distinct LTCM_LIC_NUMBER
         into  l_error_lic
         from   sgy_mn_lic_tape_cha_mapp
         ,fid_tape
         where    ltcm_tap_number = tap_number
         and    tap_type = l_tap_type
         and    ltcm_tap_number = i_tap_number
         ;
         select tap_barcode
         into  l_error_tap
         from fid_tape
         where tap_number in
         (
         select distinct LTCM_TAP_NUMBER
         from   sgy_mn_lic_tape_cha_mapp
         ,fid_tape
         where   ltcm_tap_number = tap_number
         and    tap_type = l_tap_type
         and    ltcm_lic_number = i_lic_number
         and    rownum < 2
         );
         raise_application_error (-20109,'Tape is already Linked with '|| l_error_lic||' License AND This License is already Linked with '|| l_error_tap||' Tape.');
         end if;
         */
         ELSE
            UPDATE fid_tape
               SET tap_pro_number = i_pronumber,
                   tap_match_status = 'LK',
                   --tap_entry_oper = i_entry_oper,
                   --tap_entry_date = SYSDATE,
                   tap_update_count = tap_update_count + 1
             WHERE tap_number = i_tap_number;

            UPDATE fid_programme_element
               SET pre_gen_refno = l_progennumber,
                   pre_pro_number = l_pronumber,
                   pre_entry_oper = i_entry_oper,
                   pre_entry_date = SYSDATE,
                   pre_update_count = pre_update_count + 1
             WHERE pre_number IN (SELECT tas_pre_number
                                    FROM fid_tape_segment
                                   WHERE tas_tap_number = i_tap_number);

            WHILE l_cnt <> 0
            LOOP
               IF INSTR (l_cha_list, ',') = 0
               THEN
                  l_cha_number := l_cha_list;
                  l_cnt := 0;
               ELSE
                  l_cha_number :=
                     SUBSTR (l_cha_list, 1, INSTR (l_cha_list, ',') - 1);
                  l_cha_list :=
                     SUBSTR (l_cha_list, INSTR (l_cha_list, ',') + 1);
                  l_cnt := NVL (LENGTH (l_cha_list), 0);
               END IF;

               l_ltcm_id := seq_ltcm_id.NEXTVAL;

               INSERT INTO sgy_mn_lic_tape_cha_mapp (ltcm_id,
                                                     ltcm_tap_number,
                                                     ltcm_lic_number,
                                                     ltcm_cha_number,
                                                     ltcm_link_date,
                                                     ltcm_entry_oper)
                    VALUES (l_ltcm_id,
                            i_tap_number,
                            i_lic_number,
                            l_cha_number,
                            SYSDATE,
                            i_entry_oper);
            /*  --Start : update media version on future schedules if barcode is prod linked  (Content version scheduling change)
              FOR i IN (SELECT DISTINCT sch_lic_number, sch_cha_number
                                   FROM fid_schedule, fid_license
                                  WHERE sch_lic_number = lic_number
                                    AND lic_gen_refno = l_progennumber
                                    AND TO_DATE (sch_date) >
                                                            TO_DATE (SYSDATE))
              LOOP
                 pkg_ssc_scheduling.x_prc_get_bestfit_media_ver
                                                          (i.sch_cha_number,
                                                           i.sch_lic_number,
                                                           l_ver_id,
                                                           l_tap_number1
                                                          );

                 IF i_tap_number = l_tap_number1
                 THEN
                    UPDATE fid_schedule
                       SET sch_ver_id = l_ver_id,
                           sch_tap_number = l_tap_number1
                     WHERE TO_DATE (sch_date) > TO_DATE (SYSDATE)
                       AND sch_cha_number = i.sch_cha_number
                       AND sch_lic_number = i.sch_lic_number;
                 END IF;
              -- l_rowsupdated := l_rowsupdated + SQL%ROWCOUNT;
              END LOOP;
           --End  : update media version on future schedules if barcode is prod linked  (Content version scheduling change)*/
            END LOOP;

            BEGIN
               SELECT tap_type
                 INTO l_tap_type
                 FROM fid_tape
                WHERE tap_number = i_tap_number;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF i_txm_id = 0 AND l_tap_type = 'FRM'
            THEN
               BEGIN
                  SELECT frm_id
                    INTO l_frm_id
                    FROM sgy_mn_frm_details
                   WHERE     frm_gen_refno = i_gen_refno
                         AND frm_tape_no IS NULL
                         AND ROWNUM < 2;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_frm_id := 0;
               END;
            ELSIF i_txm_id > 0 AND l_tap_type = 'FRM'
            THEN
               l_frm_id := i_txm_id;
            ELSIF i_txm_id = 0 AND l_tap_type = 'TXM'
            THEN
               BEGIN
                  SELECT txm_id
                    INTO l_txm_id
                    FROM sgy_mn_txm_details
                   WHERE     txm_gen_refno = i_gen_refno
                         AND txm_tape_no IS NULL
                         AND ROWNUM < 2;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     l_txm_id := 0;
               END;
            ELSE
               l_txm_id := i_txm_id;
            END IF;

            IF l_tap_type = 'FRM' AND l_frm_id > 0
            THEN
               l_entry_oper := pkg_cm_username.setusername (i_entry_oper);

               UPDATE sgy_mn_frm_details
                  SET frm_prod_link_date = TRUNC (SYSDATE),
                      frm_prod_link_by = i_entry_oper,
                      frm_tape_no = i_tap_number,
                      frm_lic_number = i_lic_number
                WHERE frm_id = l_frm_id;
            END IF;

            IF l_tap_type = 'TXM' AND l_txm_id > 0
            THEN
               l_entry_oper := pkg_cm_username.setusername (i_entry_oper);

               UPDATE sgy_mn_txm_details
                  SET txm_prod_link_date = TRUNC (SYSDATE),
                      txm_prod_link_by = i_entry_oper,
                      txm_tape_no = i_tap_number,
                      txm_lic_number = i_lic_number
                WHERE txm_id = l_txm_id;
            END IF;

            o_success := 1;
         END IF;
      END IF;

      IF o_success = 1
      THEN
         COMMIT;

         --Start : update media version on future schedules if barcode is prod linked  (Content version scheduling change)
         FOR i
            IN (SELECT DISTINCT sch_lic_number, sch_cha_number,sch_time -- KHILESH Trello 4/11/2015
                  FROM fid_schedule, fid_license
                 WHERE sch_lic_number = lic_number
                       AND lic_gen_refno = l_progennumber
                       -- RDT Issue fix for Content Version : Start
                       AND ( (TO_DATE (
                                    sch_date
                                 || ' '
                                 || convert_time_n_c (sch_time),
                                 'DD-MON-RRRR HH24:MI:SS') >= SYSDATE
                              AND sch_date LIKE SYSDATE)
                            OR (TO_DATE (
                                      (sch_date + 1)
                                   || ' '
                                   || convert_time_n_c (sch_time),
                                   'DD-MON-RRRR HH24:MI:SS') >= SYSDATE
                                AND sch_time >= 0
                                AND sch_time <
                                       (SELECT cha_sch_start_time
                                          FROM fid_channel
                                         WHERE cha_number =
                                                  fid_schedule.sch_cha_number)
                                AND sch_date LIKE SYSDATE)
                            OR sch_date > SYSDATE) -- RDT Issue fix for Content Version : End
                                                  )
         LOOP
            pkg_ssc_scheduling.x_prc_get_bestfit_media_ver (i.sch_cha_number,
                                                            i.sch_lic_number,
                                                            i.sch_time, -- KHILESH Trello 4/11/2015
                                                            l_ver_id,
                                                            l_tap_number1);

            --  IF i_tap_number = l_tap_number1   THEN
            UPDATE fid_schedule
               SET sch_ver_id = l_ver_id, sch_tap_number = l_tap_number1
             -- RDT Issue fix for Content Version : Start
             WHERE ( (TO_DATE (
                         sch_date || ' ' || convert_time_n_c (sch_time),
                         'DD-MON-RRRR HH24:MI:SS') >= SYSDATE
                      AND sch_date LIKE SYSDATE)
                    OR (    TO_DATE (
                                  (sch_date + 1)
                               || ' '
                               || convert_time_n_c (sch_time),
                               'DD-MON-RRRR HH24:MI:SS') >= SYSDATE
                        AND sch_time >= 0
                        AND sch_time < (SELECT cha_sch_start_time
                                          FROM fid_channel
                                         WHERE cha_number = i.sch_cha_number)
                        AND sch_date LIKE SYSDATE)
                    OR sch_date > SYSDATE)
                   -- RDT Issue fix for Content Version : End
                   AND sch_cha_number = i.sch_cha_number
                   AND sch_lic_number = i.sch_lic_number;
         --  END IF;
         END LOOP;

         COMMIT;

         --End  : update media version on future schedules if barcode is prod linked  (Content version scheduling change)
         OPEN o_tapedetails FOR
            SELECT o_success success,
                   tap_number,
                   tap_title,
                   tap_pro_number,
                   tap_type,
                   tap_match_status,
                   tap_barcode,
                   (SELECT ltcm_lic_number
                      FROM sgy_mn_lic_tape_cha_mapp
                     WHERE ltcm_tap_number = tap_number AND ROWNUM < 2)
                      lic_number,
                   tap_format_type,
                   tap_length,
                   tap_aspect_ratio,
                   (SELECT ltcm_link_date
                      FROM sgy_mn_lic_tape_cha_mapp
                     WHERE ltcm_tap_number = tap_number AND ROWNUM < 2)
                      link_date,
                   (SELECT ltcm_item_id
                      FROM sgy_mn_lic_tape_cha_mapp
                     WHERE ltcm_tap_number = tap_number AND ROWNUM < 2)
                      item_id,
                   tap_format
              FROM fid_tape
             WHERE tap_number = i_tap_number;

         OPEN o_tapesegmentdetails FOR
              SELECT fid_tape_segment.tas_tap_number AS tapenumber,
                     fid_programme_element.pre_title AS segmenttitle,
                     fid_tape_segment.tas_segment AS segementsequence,
                     fid_tape_segment.tas_som AS som,
                     fid_tape_segment.tas_eom AS eom,
                     LTRIM (
                        TO_CHAR (
                           FLOOR (fid_programme_element.pre_duration / 90000),
                           '09'))
                     || ':'
                     || LTRIM (
                           TO_CHAR (
                              FLOOR (
                                 MOD (fid_programme_element.pre_duration,
                                      90000)
                                 / 1500),
                              '09'))
                     || ':'
                     || LTRIM (
                           TO_CHAR (
                              FLOOR (
                                 MOD (fid_programme_element.pre_duration, 1500)
                                 / 25),
                              '09'))
                     || ':'
                     || LTRIM (TO_CHAR (MOD (pre_duration, 25), '09'))
                        AS segmentduration,
                     fid_tape_segment.tas_audio_1 "AudioTrack1",
                     fid_tape_segment.tas_audio_2 "AudioTrack2",
                     fid_tape_segment.tas_audio_3 "AudioTrack3",
                     fid_tape_segment.tas_audio_4 "AudioTrack4"
                FROM    fid_tape_segment
                     INNER JOIN
                        fid_programme_element
                     ON fid_tape_segment.tas_pre_number =
                           fid_programme_element.pre_number
               WHERE fid_tape_segment.tas_tap_number = i_tap_number
            ORDER BY fid_tape_segment.tas_segment,
                     fid_programme_element.pre_title;
      ELSE
         o_success := -1;
         RAISE valuesnotentered;
      END IF;
   EXCEPTION
      WHEN valuesnotentered
      THEN
         ROLLBACK;
         --Dev.R1: UID_Generation: Start:[MOP_UID_11]_[Anuja_Shinde]_[24-01-2014]
         --Renamed Tape to Media Asset
         raise_application_error (
            -20109,
            'Please select a Programme and Media Asset title.');
   --Dev.R1: UID_Generation: End
   END pck_mm_mnet_pl_linktitles;

   PROCEDURE prc_insert_loc_ter_info (
      i_gen_refno         IN     fid_general.gen_refno%TYPE,
      i_loc_ter_code      IN     fid_general_local.loc_ter_code%TYPE,
      i_loc_release_the   IN     fid_general_local.loc_release_the%TYPE,
      i_loc_release_vid   IN     fid_general_local.loc_release_vid%TYPE,
      i_loc_release_tv    IN     fid_general_local.loc_release_tv%TYPE,
      i_loc_comment       IN     fid_general_local.loc_comment%TYPE,
      i_loc_title         IN     fid_general_local.loc_title%TYPE,
      i_entry_oper        IN     fid_general_local.loc_entry_oper%TYPE,
      o_success              OUT NUMBER)
   AS
      l_temp   NUMBER;
   BEGIN
      SELECT seq_loc_unique_id.NEXTVAL INTO l_temp FROM DUAL;

      INSERT INTO fid_general_local (loc_gen_refno,
                                     loc_ter_code,
                                     loc_release_the,
                                     loc_release_vid,
                                     loc_release_tv,
                                     loc_comment,
                                     loc_entry_oper,
                                     loc_entry_date,
                                     loc_title,
                                     loc_unique_id)
           VALUES (i_gen_refno,
                   i_loc_ter_code,
                   i_loc_release_the,
                   i_loc_release_vid,
                   i_loc_release_tv,
                   i_loc_comment,
                   i_entry_oper,
                   SYSDATE,
                   i_loc_title,
                   l_temp);

      o_success := l_temp;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END prc_insert_loc_ter_info;

   PROCEDURE prc_insertcast (
      i_gen_refno    IN     fid_general.gen_refno%TYPE,
      i_cas_role     IN     fid_general_cast.cas_role%TYPE,
      i_cas_award    IN     fid_general_cast.cas_award%TYPE,
      i_cas_name     IN     fid_general_cast.cas_name%TYPE,
      i_cas_order    IN     fid_general_cast.cas_order%TYPE,
      i_entry_oper   IN     fid_general_cast.cas_entry_oper%TYPE,
      o_success         OUT NUMBER)
   AS
      l_temp_no   NUMBER;
   BEGIN
      SELECT seq_cas_unique_id.NEXTVAL INTO l_temp_no FROM DUAL;

      INSERT INTO fid_general_cast (cas_gen_refno,
                                    cas_role,
                                    cas_name,
                                    cas_award,
                                    cas_order,
                                    cas_entry_oper,
                                    cas_entry_date,
                                    cas_unique_id)
           VALUES (i_gen_refno,
                   i_cas_role,
                   i_cas_name,
                   i_cas_award,
                   i_cas_order,
                   i_entry_oper,
                   SYSDATE,
                   l_temp_no);

      o_success := l_temp_no;

      IF l_temp_no > 0
      then
        commit;
       x_prc_ins_upd_vod_cast_dtls(i_gen_refno, i_entry_oper);
      END IF;

   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END prc_insertcast;

   PROCEDURE prc_insertfiles (
      i_genrefno      IN     fid_general.gen_refno%TYPE,
      i_afi_file_id   IN     fid_attach_file.afi_file_id%TYPE,
      i_entry_oper    IN     fid_attach_file.afi_entry_oper%TYPE,
      o_success          OUT NUMBER)
   AS
   BEGIN
      o_success := 1;

      INSERT INTO fid_attach_file (afi_number,
                                   afi_gen_refno,
                                   afi_file_id,
                                   afi_entry_oper,
                                   afi_entry_date)
           VALUES (seq_afi_number.NEXTVAL,
                   i_genrefno,
                   i_afi_file_id,
                   i_entry_oper,
                   SYSDATE);
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END;

   PROCEDURE prc_updatecast (
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_cas_role        IN     fid_general_cast.cas_role%TYPE,
      i_cas_award       IN     fid_general_cast.cas_award%TYPE,
      i_cas_name        IN     fid_general_cast.cas_name%TYPE,
      i_cas_order       IN     fid_general_cast.cas_order%TYPE,
      i_cas_unique_id   IN     fid_general_cast.cas_unique_id%TYPE,
      i_entry_oper      IN     fid_general_cast.cas_entry_oper%TYPE,
      o_success            OUT NUMBER)
   AS
      l_count     NUMBER;
      l_temp_no   NUMBER;
   BEGIN
      o_success := 1;

      SELECT COUNT (*)
        INTO l_count
        FROM fid_general_cast
       WHERE cas_unique_id = i_cas_unique_id;

      IF (l_count = 0)
      THEN
         BEGIN
            SELECT seq_cas_unique_id.NEXTVAL INTO l_temp_no FROM DUAL;

            INSERT INTO fid_general_cast (cas_gen_refno,
                                          cas_role,
                                          cas_name,
                                          cas_award,
                                          cas_order,
                                          cas_entry_oper,
                                          cas_entry_date,
                                          cas_unique_id)
                 VALUES (i_gen_refno,
                         i_cas_role,
                         i_cas_name,
                         i_cas_award,
                         i_cas_order,
                         i_entry_oper,
                         SYSDATE,
                         l_temp_no);

            o_success := l_temp_no;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_success := 0;
         END;
      ELSE
         BEGIN
            UPDATE fid_general_cast fgc
               SET cas_role = NVL (i_cas_role, fgc.cas_role),
                   cas_award = NVL (i_cas_award, fgc.cas_award),
                   cas_name = NVL (i_cas_name, fgc.cas_name),
                   --Dev.R10 : Audit on Programme Maintenance : Start : [Devashish Raverkar]_[2015/10/08]
                   cas_modified_by = i_entry_oper,
                   cas_modified_date = SYSDATE,
                   --Dev.R10 : Audit on Programme Maintenance : End
                   cas_update_count = NVL (cas_update_count, 0) + 1,
                   cas_order=i_cas_order
             WHERE cas_unique_id = i_cas_unique_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_success := 0;
         END;
      END IF;


      IF o_success > 0
      then
       commit;
       x_prc_ins_upd_vod_cast_dtls(i_gen_refno, i_entry_oper);
      END IF;


   END;

   PROCEDURE prc_updatelocal (
      i_loc_gen_refno     IN     fid_general_local.loc_gen_refno%TYPE,
      i_loc_ter_code      IN     fid_general_local.loc_ter_code%TYPE,
      i_loc_release_the   IN     fid_general_local.loc_release_the%TYPE,
      i_loc_release_vid   IN     fid_general_local.loc_release_vid%TYPE,
      i_loc_release_tv    IN     fid_general_local.loc_release_tv%TYPE,
      i_loc_comment       IN     fid_general_local.loc_comment%TYPE,
      i_loc_title         IN     fid_general_local.loc_title%TYPE,
      i_loc_unique_id     IN     fid_general_local.loc_unique_id%TYPE,
      i_entry_oper        IN     fid_general_local.loc_entry_oper%TYPE,
      o_success              OUT NUMBER)
   AS
   BEGIN
      o_success := 1;

      UPDATE fid_general_local fgl
         SET loc_ter_code = NVL (i_loc_ter_code, fgl.loc_ter_code),
             loc_title = NVL (i_loc_title, fgl.loc_title),
             loc_release_the = NVL (i_loc_release_the, fgl.loc_release_the),
             loc_release_vid = NVL (i_loc_release_vid, fgl.loc_release_vid),
             loc_release_tv = NVL (i_loc_release_tv, fgl.loc_release_tv),
             loc_comment = NVL (i_loc_comment, fgl.loc_comment),
             loc_entry_oper = i_entry_oper,
             loc_entry_date = SYSDATE,
             loc_update_count = NVL (loc_update_count, 0) + 1
       WHERE loc_unique_id = i_loc_unique_id;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END;

   PROCEDURE prc_updatefiles (
      i_genrefno      IN     fid_general.gen_refno%TYPE,
      i_afi_file_id   IN     fid_attach_file.afi_file_id%TYPE,
      i_entry_oper    IN     fid_attach_file.afi_entry_oper%TYPE,
      o_success          OUT NUMBER)
   AS
   BEGIN
      o_success := 1;

      UPDATE fid_attach_file
         SET afi_file_id = i_afi_file_id,
             afi_entry_oper = i_entry_oper,
             afi_entry_date = SYSDATE,
             afi_update_count = afi_update_count + 1
       WHERE afi_gen_refno = i_genrefno;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END;

   PROCEDURE prc_deletecast (
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_cas_role        IN     fid_general_cast.cas_role%TYPE,
      i_cas_name        IN     fid_general_cast.cas_name%TYPE,
      i_cas_award       IN     fid_general_cast.cas_award%TYPE,
      i_cas_unique_id   IN     fid_general_cast.cas_unique_id%TYPE,
      --Dev.R10 : Audit on Programme Maintenance : Start : [Devashish Raverkar]_[2015/10/08]
      i_cas_entry_oper  IN     fid_general_cast.cas_entry_oper%TYPE,
      --Dev.R10 : Audit on Programme Maintenance : End
      o_success            OUT NUMBER)
   AS
    l_data    NUMBER;
   BEGIN
      o_success := 1;

      l_data := pkg_cm_username.setusername(i_cas_entry_oper);
      DELETE FROM fid_general_cast
            WHERE cas_unique_id = i_cas_unique_id;
   /*cas_gen_refno = i_gen_refno
   AND cas_role = i_cas_role
   AND cas_name = i_cas_name;*/
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END;

   PROCEDURE prc_deletelocal (
      i_loc_gen_refno   IN     fid_general_local.loc_gen_refno%TYPE,
      i_tercode         IN     fid_general_local.loc_ter_code%TYPE,
      i_localtitle      IN     fid_general_local.loc_title%TYPE,
      i_loc_unique_id   IN     fid_general_local.loc_unique_id%TYPE,
      o_success            OUT NUMBER)
   AS
   BEGIN
      o_success := 1;

      DELETE FROM fid_general_local fgl
            WHERE loc_unique_id = i_loc_unique_id;
   /*loc_gen_refno = i_loc_gen_refno
   AND loc_ter_code = i_tercode
   AND loc_title = i_localtitle;*/
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END;

   PROCEDURE prc_deletefiles (i_genrefno   IN     fid_general.gen_refno%TYPE,
                              o_success       OUT NUMBER)
   AS
   BEGIN
      o_success := 1;

      DELETE FROM fid_attach_file
            WHERE afi_gen_refno = i_genrefno;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END;

   FUNCTION get_duration (i_duration VARCHAR)
      RETURN VARCHAR
   AS
      l_temp         NUMBER;
      l_duration_n   NUMBER;
      l_duration_p   VARCHAR2 (50);
      l_duration     VARCHAR2 (50) := 'X';
   BEGIN
      l_temp := 1;
      l_duration_p := i_duration;

      WHILE LENGTH (l_duration_p) >= 0
      LOOP
         IF l_duration = 'X'
         THEN
            l_duration := SUBSTR (l_duration_p, 1, 2);
         ELSE
            l_duration := l_duration || ':' || SUBSTR (l_duration_p, 1, 2);
         END IF;

         l_duration_p := SUBSTR (l_duration_p, 3);
      END LOOP;

      IF l_duration = 'X'
      THEN
         l_duration := '';
      END IF;

      RETURN l_duration;
   END;

   --Dev3: TVOD_CR: Start:[TVOD_CR]_[Anuja Shinde]_[28-Jun-2013]
   FUNCTION is_tvod_prog (i_genrefno NUMBER)
      RETURN NUMBER
   AS
      o_result   NUMBER;
      v_temp     NUMBER;
   BEGIN
      o_result := 0;

      SELECT COUNT (1)
        INTO v_temp
        FROM tbl_tva_dm_prog
       WHERE dmprg_n_gen_refno = i_genrefno;

      IF v_temp > 0
      THEN
         o_result := 1;
      END IF;

      RETURN o_result;
   END;

   --Dev3: TVOD_CR: END :[TVOD_CR]

   -- Add by
   --Procedure to get scheduling and email information
   PROCEDURE pck_mm_mnet_pl_searchtxwarning (
      i_gen_refno           IN     fid_general.gen_refno%TYPE DEFAULT 0,
      o_programe_schedule      OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_programe_schedule FOR
         SELECT fc.cha_name channel_name,
                fs.sch_lic_number license_number,
                fs.sch_date schedule_date,
                fs.sch_time start_time,
                fs.sch_end_time end_time
           FROM fid_schedule fs, fid_channel fc, fid_license fl
          WHERE     fs.sch_lic_number = fl.lic_number
                AND fl.lic_gen_refno = i_gen_refno
                AND fc.cha_number = fs.sch_cha_number;
   --   --DBMS_OUTPUT.put_line (sqlstmnt);
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END pck_mm_mnet_pl_searchtxwarning;

   -- Add by
   --DEV4: Programme Acceptance (Release 12) : Start :  <17-06-2013> : <Refer PGA01 document>
   PROCEDURE x_prc_search_mcr (
      i_gen_refno       IN     fid_general.gen_refno%TYPE,
      i_report_id       IN     x_movie_content_report.mcr_report_id%TYPE,
      o_movie_content      OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_movie_content FOR
         SELECT fg.gen_title "gen_title",
                fg.gen_duration_c "gen_duration",
                mcr.mcr_report_name "report_name",
                mcr.mcr_created_by "Created_By",
                mcr.mcr_created_date "Created_date",
                mcr.mcr_fpb_rating "FPB_rating",
                mcr.mcr_themes "themes",
                mcr.mcr_violence "violence",
                mcr.mcr_bad_language "bad_language",
                mcr.mcr_copy "copy",
                mcr.mcr_horror_suspence "Horror_suspense",
                mcr.mcr_sex "sex",
                mcr.mcr_drugs "Drugs",
                mcr.mcr_prejudice "Prejudice",
                mcr.mcr_correctives "Correctives",
                mcr.mcr_any_special_warnings "Any_Special_warnings",
                mcr.mcr_nudity "Nudity",
                mcr.mcr_reasons_for_recoomended "classification",
                mcrh.mcrh_last_modified_by "last_Modified_by",
                mcrh.mcrh_last_modified_on "last_Modified_on",
                mcr.mcr_target_audience "Target_AUDIENCE",
                mcr.mcr_dom_age_restrictions "DOM_AGE_RESTIOCTION",
                mcr.mcr_afr_age_restrictions "AFR_AGE_RESTIOCTION",
                mcr.mcr_distributor "distributor",
                mcr.mcr_tx_date "tx_date",
                mcr.mcr_synopsis "synopsis",
                mcr.mcr_cast "CST",
                mcr.mcr_director "Director",
                mcr.mcr_primary_genre "genre",
                mcr.mcr_reasons_for_recoomended "summary_of_reasons",
                mcr.mcr_sub_title_language "SUB_TITLE_LANGUAGE",
                mcr.mcr_watershed_restriction "WATERSHED_RESTRICTION",
                mcr.mcr_afrc_reg_rating "AFR_REG_RATING",
                mcr.mcr_date_received "DATE_RECEIVED",
                mcr.mcr_date_viewed "DATE_VIEWED",
                mcr.mcr_buyer_feedback "BUYER_FEEDBACK",
                mcr.mcr_location "LOCATION",
                tcode.pgatc_part "TIME_CODE_PART",
                tcode.pgatc_segment "TIME_CODE_SEGMENT",
                tcode.pgatc_start_of_mesg "TIME_CODE_ST_O_MSG",
                tcode.pgatc_end_of_mesg "TIME_CODE_END_O_MSG",
                tcode.pgatc_comment "TIME_CODE_COMMENT",
                pkg_mm_mnet_pl_prgmaintenance.x_fnu_time_calculate (
                   pgatc_start_of_mesg,
                   pgatc_end_of_mesg)
                   "TIME_CODE_DURATION",
                mcr.mcr_producer "PRODUCER",
                fg.gen_title_working "EPISODE TITLE",
                fg.gen_epi_number "EPISODE",
                mcr.mcr_programe_type "PROGRAMME_TYPE",
                mcr.mcr_language "LANGUAGE",
                (SELECT a.ser_title
                   FROM fid_series a,
                        (SELECT ser_title, ser_parent_number
                           FROM fid_series
                          WHERE ser_number = (SELECT gen_ser_number
                                                FROM fid_general
                                               WHERE gen_refno = i_gen_refno)) b
                  WHERE b.ser_parent_number = a.ser_number)
                   "SERIES_TITLE",
                (SELECT b.ser_title
                   FROM fid_series a,
                        (SELECT ser_title, ser_parent_number
                           FROM fid_series
                          WHERE ser_number = (SELECT gen_ser_number
                                                FROM fid_general
                                               WHERE gen_refno = i_gen_refno)) b
                  WHERE b.ser_parent_number = a.ser_number)
                   "SEASON_TITLE",
                (SELECT ser_sea_number
                   FROM fid_series
                  WHERE ser_number = (SELECT gen_ser_number
                                        FROM fid_general
                                       WHERE gen_refno = i_gen_refno))
                   "SEASON_NUMBER",
                mcr.mcr_afr_age_restrictions "AFR_AGE_RESTRICTIONS",
                mcr.mcr_year_of_production "PRODUCTION_YEAR",
                mcr.mcr_africa_tx "AFR_TX",
                fg.gen_type "PM_PROGRAMME_TYPE"
           FROM fid_general fg,
                x_movie_content_report mcr,
                x_movie_content_report_history mcrh,
                x_progrmm_acceptance_time_code tcode
          WHERE     mcrh.mcrh_history_report_id(+) = mcr.mcr_report_id
                AND fg.gen_refno(+) = mcr.mcr_report_gen_ref_no
                AND mcr.mcr_report_id = i_report_id
                AND mcr.mcr_report_gen_ref_no = i_gen_refno
                AND tcode.pgatc_mcr_report_id(+) = mcr.mcr_report_id
                AND (mcrh.mcrh_last_modified_on IS NULL
                     OR mcrh.mcrh_last_modified_on =
                           (SELECT MAX (h.mcrh_last_modified_on)
                              FROM x_movie_content_report_history h
                             WHERE mcrh.mcrh_history_report_id =
                                      h.mcrh_history_report_id));
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_search_mcr;

   ---Procedure for serch audit of x movie content report
   PROCEDURE x_prc_serch_audit_mcr (i_month       IN     VARCHAR2,
                                    i_year        IN     NUMBER,
                                    i_user_name   IN     VARCHAR2,
                                    res              OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN res FOR
           SELECT mcr.mcr_report_name "Report Title",
                  fg.gen_title "Programme Title",
                  mcr.mcr_created_by "Created By",
                  mcr.mcr_created_date "Created Date",
                  mcrh.mcrh_last_modified_by "Last Edited By",
                  mcrh.mcrh_last_modified_on "Last Edited Date",
                  (SELECT MAX (tab_entry_date)
                     FROM fid_general,
                          fid_production,
                          fid_tape,
                          fid_tape_booking
                    WHERE     tap_pro_number = pro_number
                          AND gen_refno = pro_gen_refno
                          AND tap_number = tab_tap_number
                          AND gen_refno = mcr.mcr_report_gen_ref_no)
                     "Tape Booked out Date"
             FROM x_movie_content_report mcr,
                  x_movie_content_report_history mcrh,
                  fid_general fg
            WHERE     UPPER (mcr.mcr_created_by) LIKE NVL (i_user_name, '%')
                  AND fg.gen_refno = mcr.mcr_report_gen_ref_no
                  AND TO_NUMBER (TO_CHAR (mcr_created_date, 'YYYY')) = i_year
                  AND TO_CHAR (mcr_created_date, 'MM') = i_month
                  AND mcrh.mcrh_history_report_id(+) = mcr.mcr_report_id
                  AND (mcrh.mcrh_last_modified_on IS NULL
                       OR mcrh.mcrh_last_modified_on =
                             (SELECT MAX (h.mcrh_last_modified_on)
                                FROM x_movie_content_report_history h
                               WHERE mcrh.mcrh_history_report_id =
                                        h.mcrh_history_report_id))
         ORDER BY (CASE
                      WHEN NVL (mcrh.mcrh_last_modified_on,
                                TO_DATE ('01-jan-0001')) > mcr_created_date
                      THEN
                         mcrh.mcrh_last_modified_on
                      ELSE
                         mcr_created_date
                   END) DESC;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_serch_audit_mcr;

   -- DEV4: Programme Acceptance (Release 12) : End :  : <17-06-2013 >
   PROCEDURE pck_mnet_pl_searchprogram (
      i_gen_title               IN     fid_general.gen_title%TYPE,
      i_gen_title_working       IN     fid_general.gen_title_working%TYPE,
      -- Add by
      /*
      -- DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
      i_gen_stu_code         IN       fid_general.gen_stu_code%TYPE,
      i_gen_colour           IN       fid_general.gen_colour%TYPE,
      i_gen_widescreen       IN       fid_general.gen_widescreen%TYPE,
      i_gen_cat_complete     IN       fid_general.gen_cat_complete%TYPE,
      i_gen_archive          IN       fid_general.gen_archive%TYPE,
      i_gen_nfa_copy         IN       fid_general.gen_nfa_copy%TYPE,
      i_gen_tx_digitized     IN       fid_general.gen_tx_digitized%TYPE,
      -- DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 > */
      i_gen_category            IN     fid_general.gen_category%TYPE,
      i_gen_rating_mpaa         IN     fid_general.gen_rating_mpaa%TYPE,
      i_gen_subgenre            IN     fid_general.gen_subgenre%TYPE,
      i_gen_quality             IN     fid_general.gen_quality%TYPE,
      i_gen_series              IN     fid_general.gen_series%TYPE,
      i_gen_spoken_lang         IN     fid_general.gen_spoken_lang%TYPE,
      i_gen_refno               IN     fid_general.gen_refno%TYPE,
      i_gen_type                IN     fid_general.gen_type%TYPE,
      i_gen_nationality         IN     fid_general.gen_nationality%TYPE,
      i_gen_epi_number          IN     fid_general.gen_epi_number%TYPE,
      i_gen_target_group        IN     fid_general.gen_target_group%TYPE,
      /* RDT :MOP_CR_12.8 :Abhishek Mor 21/08/2014 :I_SUPP_SHORT_NAME removed-Impact of Requirement on other screens */
      i_programmedurationc      IN     fid_general.gen_duration_c%TYPE,
      i_release_year            IN     fid_general.gen_release_year%TYPE,
      i_tertiary_genre          IN     fid_general.gen_tertiary_genre%TYPE,
      i_embargo                 IN     fid_general.GEN_EMBARGO_CONTENT%TYPE, --#region Abhinay_1oct14: Embargo Content Implementation
      --kunal : START 02-03-2015: Production Number
      i_gen_production_number   IN     fid_general.gen_production_number%TYPE,
	  i_gen_epg_content_id		IN		fid_general.gen_epg_content_id%type,
      --kunal : END Production Number
      i_uid                  IN     fid_tape.tap_barcode%TYPE,
      o_programdetails             OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_programdetails FOR
           SELECT gen_duration,
                  gen_title,
                  gen_title_working,
                  gen_sub_title,
                  --kunal : START 02-03-2015 Production Number
                  gen_production_number,
                  --kunal : END Production Number
                  gen_music_title,
                  gen_poem_title,
                  supp_short_name,
                  supp_name,                                   --gen_stu_code,
                  stu_name,
                  gen_category,
                  category_desc,
                  gen_subgenre,
                  gen_rating_mpaa,
                  gen_quality,
                  gen_colour,
                  gen_code,
                  gen_spoken_lang,
                  gen_series,
                  colour_desc,
                  code_desc,
                  series_desc,
                  gen_refno,
                  gen_parent_refno,
                  gen_type,
                  gen_release_year,
                  gen_nationality,
                  gen_duration_c,
                  gen_duration_s,
                  gen_epi_number,
                  gen_award,
                  gen_target_group,
                  gen_widescreen,
                  gen_cat_complete,
                  gen_archive,
                  gen_nfa_copy,
                  gen_tx_digitized,
                  gen_comment,
                  gen_supplier_com_number,
                  gen_tertiary_genre,
                  spoken_lang_desc,
                  gen_copy_restrictions,
                  gen_re_tx_warning gen_abstract,
                  gen_update_count,
                  GEN_EMBARGO_CONTENT,
                  GEN_US_BROADC_DATE,
                  GEN_US_BROADC_TIME, --#region Abhinay_1oct14: Embargo Content Implementation
                  (SELECT COD_ATTR1
                     FROM fid_code
                    WHERE     cod_type = 'GEN_TYPE'
                          AND cod_value != 'HEADER'
                          AND cod_value = gen_type)
                     IS_SERIES_FLAG,
                  DECODE(GEN_CNT_RELEASE_UID,NULL,'N',GEN_CNT_RELEASE_UID) GEN_CNT_RELEASE_UID,
					 GEN_EPG_CONTENT_ID EPGContentId
             --TVOD-Added gen_update_count parameter by dhnanjay
             FROM (SELECT a.gen_duration,
                          a.gen_title,
                          a.gen_title_working,
                          --kunal : START 02-03-2015 Production Number
                          gen_production_number,
                          --kunal : END Production Number
                          a.gen_sub_title,
                          a.gen_music_title,
                          a.gen_poem_title,
                          NVL (
                             (SELECT b.com_short_name
                                FROM fid_company b
                               WHERE a.gen_supplier_com_number = b.com_number),
                             '')
                             supp_short_name,
                          NVL (
                             (SELECT b.com_name
                                FROM fid_company b
                               WHERE a.gen_supplier_com_number = b.com_number),
                             '')
                             supp_name,
                          --    a.gen_stu_code,
                          (SELECT g.stu_name
                             FROM fid_studio g
                            WHERE g.stu_code = a.gen_stu_code)
                             stu_name,
                          a.gen_category,
                          (SELECT f.cod_description
                             FROM fid_code f
                            WHERE f.cod_type = 'gen_category'
                                  AND f.cod_value = a.gen_category)
                             category_desc,
                          a.gen_subgenre,
                          a.gen_rating_mpaa,
                          a.gen_quality,
                          a.gen_colour,
                          a.gen_code,
                          a.gen_spoken_lang,
                          a.gen_series,
                          (SELECT h.cod_description
                             FROM fid_code h
                            WHERE h.cod_value = a.gen_colour
                                  AND h.cod_type = 'gen_colour')
                             colour_desc,
                          (SELECT i.cod_description
                             FROM fid_code i
                            WHERE i.cod_value = a.gen_code
                                  AND i.cod_type = 'gen_code')
                             code_desc,
                          NVL (
                             (SELECT j.cod_description
                                FROM fid_code j
                               WHERE j.cod_value = a.gen_series
                                     AND j.cod_type = 'gen_series'),
                             '')
                             series_desc,
                          a.gen_refno,
                          a.gen_parent_refno,
                          a.gen_type,
                          a.gen_release_year,
                          a.gen_nationality,
                          a.gen_duration_c,
                          a.gen_duration_s,
                          a.gen_epi_number,
                          a.gen_award,
                          a.gen_target_group,
                          a.gen_widescreen,
                          a.gen_cat_complete,
                          a.gen_archive,
                          a.gen_nfa_copy,
                          a.gen_tx_digitized,
                          a.gen_comment,
                          a.gen_supplier_com_number,
                          (SELECT k.lan_name
                             FROM sak_language k
                            WHERE k.lan_id = a.gen_spoken_lang)
                             spoken_lang_desc,
                          a.gen_copy_restrictions,
                          a.gen_re_tx_warning,
                          a.gen_abstract,
                          a.gen_tertiary_genre,
                          a.gen_update_count                      --TVOD-Added
                                            -- Add by
                                            --DEV4: Programme Acceptance (Release 12) : Start :  : <19-06-2013> : <Refer PGA01 document>
                          ,
                          a.GEN_EMBARGO_CONTENT, --#region Abhinay_1oct14: Embargo Content Implementation
                          a.GEN_US_BROADC_DATE, --#region Abhinay_1oct14: Embargo Content Implementation
                          a.GEN_US_BROADC_TIME, --#region Abhinay_1oct14: Embargo Content Implementation
                          a.gen_tags keywords,
                          a.gen_africa_type_duration_c africa_type_duration_c,
                          a.gen_africa_type_duration_s africa_type_duration_s,
                          a.GEN_CNT_RELEASE_UID,
						  a.GEN_EPG_CONTENT_ID
                     -- DEV4: Programme Acceptance (Release 12) : End :  : <19-06-2013 >
                     FROM fid_general a
                     WHERE (
                        (i_uid IS NOT NULL
                      AND gen_refno = (SELECT gen_Refno FROM X_VW_ALL_BARCODE WHERE TAP_BARCODE = i_uid) )
                      OR i_uid is null))
            WHERE gen_title LIKE
                     DECODE (UPPER (i_gen_title),
                             '', gen_title,
                             UPPER (i_gen_title))
                  AND gen_title_working LIKE
                         DECODE (UPPER (i_gen_title_working),
                                 '', gen_title_working,
                                 UPPER (i_gen_title_working))
                  /*        AND gen_stu_code LIKE
                  DECODE (UPPER (i_gen_stu_code),
                  '', gen_stu_code,
                  UPPER (i_gen_stu_code)
                  )  */
                  AND gen_category LIKE
                         DECODE (UPPER (i_gen_category),
                                 '', gen_category,
                                 UPPER (i_gen_category))
                  AND NVL (gen_rating_mpaa, 0) LIKE
                         DECODE (UPPER (i_gen_rating_mpaa),
                                 '', NVL (gen_rating_mpaa, 0),
                                 UPPER (i_gen_rating_mpaa))
                  AND NVL (gen_subgenre, 0) LIKE
                         DECODE (UPPER (i_gen_subgenre),
                                 '', NVL (gen_subgenre, 0),
                                 UPPER (i_gen_subgenre))
                  AND NVL (gen_quality, 0) LIKE
                         DECODE (UPPER (i_gen_quality),
                                 '', NVL (gen_quality, 0),
                                 UPPER (i_gen_quality))
                  /*     AND NVL (upper(gen_colour), 0) LIKE
                  DECODE ( UPPER (i_gen_colour),
                  '', NVL (gen_colour, 0),
                  UPPER (i_gen_colour)
                  ) */
                  AND NVL (gen_series, 0) LIKE
                         DECODE (UPPER (i_gen_series),
                                 '', NVL (gen_series, 0),
                                 UPPER (i_gen_series))
                  AND NVL (gen_spoken_lang, 0) LIKE
                         DECODE (UPPER (i_gen_spoken_lang),
                                 '', NVL (gen_spoken_lang, 0),
                                 UPPER (i_gen_spoken_lang))
                  AND gen_refno LIKE
                         DECODE (i_gen_refno, '', gen_refno, i_gen_refno)
                  AND gen_type LIKE
                         DECODE (UPPER (i_gen_type),
                                 '', gen_type,
                                 UPPER (i_gen_type))
                  AND NVL (gen_nationality, 0) LIKE
                         DECODE (UPPER (i_gen_nationality),
                                 '', NVL (gen_nationality, 0),
                                 UPPER (i_gen_nationality))
                  AND NVL (gen_epi_number, 0) =
                         DECODE (i_gen_epi_number,
                                 '', NVL (gen_epi_number, 0),
                                 i_gen_epi_number)
                  AND NVL (gen_target_group, 0) LIKE
                         DECODE (UPPER (i_gen_target_group),
                                 '', NVL (gen_target_group, 0),
                                 UPPER (i_gen_target_group))
                  /* AND NVL (gen_widescreen, 0) LIKE
                  DECODE (UPPER (i_gen_widescreen),
                  '', NVL (gen_widescreen, 0),
                  UPPER (i_gen_widescreen)
                  )
                  AND NVL (gen_cat_complete, 0) LIKE
                  DECODE (UPPER (i_gen_cat_complete),
                  '', NVL (gen_cat_complete, 0),
                  UPPER (i_gen_cat_complete)
                  )
                  AND NVL (gen_archive, 0) LIKE
                  DECODE (UPPER (i_gen_archive),
                  '', NVL (gen_archive, 0),
                  UPPER (i_gen_archive)
                  )
                  AND NVL (gen_nfa_copy, 0) LIKE
                  DECODE (UPPER (i_gen_nfa_copy),
                  '', NVL (gen_nfa_copy, 0),
                  UPPER (i_gen_nfa_copy)
                  )
                  AND NVL (gen_tx_digitized, 0) LIKE
                  DECODE (UPPER (i_gen_tx_digitized),
                  '', NVL (gen_tx_digitized, 0),
                  UPPER (i_gen_tx_digitized)
                  ) */
                  AND NVL (gen_duration_c, 0) LIKE
                         DECODE (i_programmedurationc,
                                 '', NVL (gen_duration_c, 0),
                                 i_programmedurationc)
                  AND NVL (gen_release_year, 0) =
                         DECODE (i_release_year,
                                 '', NVL (gen_release_year, 0),
                                 i_release_year)
                  /* RDT :MOP_CR_12.8 :Abhishek Mor 21/08/2014 :I_SUPP_SHORT_NAME removed-Impact of Requirement on other screens */
                  AND NVL (gen_tertiary_genre, 0) LIKE
                         DECODE (i_tertiary_genre,
                                 '', NVL (gen_tertiary_genre, 0),
                                 i_tertiary_genre)
                  -- #region Abhinay_1oct14: Embargo Content Implementation

                  AND NVL (GEN_EMBARGO_CONTENT, 'N') =
                         DECODE (UPPER (i_embargo),
                                 '', NVL (GEN_EMBARGO_CONTENT, 'N'),
                                 UPPER (i_embargo))
                  -- #endregion Abhinay_1oct14

                  --kunal : START 02-03-2015 Production Number
                  AND NVL (GEN_PRODUCTION_NUMBER, 'X') LIKE
                         DECODE (UPPER (i_gen_production_number),
                                 '', NVL (GEN_PRODUCTION_NUMBER, 'X'),
                                 UPPER (i_gen_production_number))
				 AND upper(NVL (gen_epg_content_id, 'X')) LIKE
                         DECODE (UPPER (i_gen_epg_content_id),
                                 '', upper(NVL (gen_epg_content_id, 'X')),
                                 UPPER (i_gen_epg_content_id))
                 --kunal : END Production Number
                  AND ROWNUM < 501
         ORDER BY gen_refno;                                      --gen_title;
   --TVOD-Added Exception block added by Dhnanjay
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001,
                                  'No records matching the search criteria.');
      WHEN OTHERS
      THEN
         raise_application_error (-20002,
                                  'An error occurred. Message: ' || SQLERRM);
   END pck_mnet_pl_searchprogram;

   --- Add by
   --DEV4: Programme Acceptance (Release 12) : Start :  : <17-06-2013> : <Refer PGA01 document>
   ----- Function to calcuate time return time duration
   FUNCTION x_fnu_time_calculate (i_stime VARCHAR2, i_etime VARCHAR2)
      RETURN VARCHAR2
   AS
      lstime        NUMBER;
      letime        NUMBER;
      ltimenumber   NUMBER := 0;
      lftime        VARCHAR2 (10) := ' ';
   BEGIN
      lstime :=
         TO_NUMBER (
              (SUBSTR (i_stime, 1, 2) * 3600)
            + (SUBSTR (i_stime, 4, 2) * 60)
            + (SUBSTR (i_stime, 7, 2) * 1));
      letime :=
         TO_NUMBER (
              (SUBSTR (i_etime, 1, 2) * 3600)
            + (SUBSTR (i_etime, 4, 2) * 60)
            + (SUBSTR (i_etime, 7, 2) * 1));
      ltimenumber := letime - lstime;

      IF ltimenumber >= 0
      THEN
         lftime :=
               LTRIM (TO_CHAR (FLOOR ( (ltimenumber) / 3600), '09'))
            || ':'
            || LTRIM (TO_CHAR (FLOOR (MOD (ltimenumber, 3600) / 60), '09'))
            || ':'
            || LTRIM (TO_CHAR (FLOOR (MOD (ltimenumber, 60)), '09'));
      ELSE
         lftime := ' ';
      END IF;

      ----DBMS_OUTPUT.put_line (ltimenumber);
      RETURN lftime;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN lftime;
   END x_fnu_time_calculate;

   -------Procedure for delete recordes
   PROCEDURE x_prc_delete_pga_time_code (i_pga_tc_id IN NUMBER)
   IS
   BEGIN
      DELETE FROM x_progrmm_acceptance_time_code
            WHERE pga_time_code_id = i_pga_tc_id;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_delete_pga_time_code;

   -------Procedure for Insert time code
   PROCEDURE x_prc_insert_pga_time_code (i_mcr_report_id   IN NUMBER,
                                         i_part            IN VARCHAR2,
                                         i_segment         IN VARCHAR2,
                                         i_start_of_mesg   IN VARCHAR2,
                                         i_end_of_mesg     IN VARCHAR2,
                                         i_comment         IN VARCHAR2,
                                         i_entry_oper      IN VARCHAR2)
   AS
      ltc_id   NUMBER;
   BEGIN
      ltc_id := x_seq_pga_time_code_id.NEXTVAL;

      INSERT INTO x_progrmm_acceptance_time_code (pga_time_code_id,
                                                  pgatc_mcr_report_id,
                                                  pgatc_part,
                                                  pgatc_segment,
                                                  pgatc_start_of_mesg,
                                                  pgatc_end_of_mesg,
                                                  pgatc_comment,
                                                  pgatc_entry_oper,
                                                  pgatc_entry_date,
                                                  pgatc_update_count,
                                                  pgatc_modify_on,
                                                  pgatc_modify_by)
           VALUES (ltc_id,
                   i_mcr_report_id,
                   i_part,
                   i_segment,
                   i_start_of_mesg,
                   i_end_of_mesg,
                   i_comment,
                   i_entry_oper,
                   SYSDATE,
                   0,
                   SYSDATE,
                   i_entry_oper);

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_insert_pga_time_code;

   -------Procedure for Update time code
   PROCEDURE x_prc_update_pga_time_code (i_pga_tc_id       IN NUMBER,
                                         i_part            IN VARCHAR2,
                                         i_segment         IN VARCHAR2,
                                         i_start_of_mesg   IN VARCHAR2,
                                         i_end_of_mesg     IN VARCHAR2,
                                         i_comment         IN VARCHAR2,
                                         i_upd_oper        IN VARCHAR2,
                                         i_upt_cnt         IN NUMBER)
   AS
   BEGIN
      UPDATE x_progrmm_acceptance_time_code
         SET pgatc_part = i_part,
             pgatc_segment = i_segment,
             pgatc_start_of_mesg = i_start_of_mesg,
             pgatc_end_of_mesg = i_end_of_mesg,
             pgatc_comment = i_comment,
             pgatc_update_count = pgatc_update_count + 1,
             pgatc_modify_on = SYSDATE,
             pgatc_modify_by = i_upd_oper
       WHERE pga_time_code_id = i_pga_tc_id
             AND pgatc_update_count = i_upt_cnt;

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_update_pga_time_code;

   ---- DEV4: Programme Acceptance (Release 12) : End :  : <17-06-2013 >
   PROCEDURE x_prc_store_ardome_information (
      i_lic_number      IN     VARCHAR2,
      i_tape_number     IN     NUMBER,
      i_item_id         IN     VARCHAR2,
      i_tape_id         IN     VARCHAR2,
      i_tape_entry_id   IN     VARCHAR2,
      o_updated            OUT NUMBER)
   AS
   BEGIN
      o_updated := 0;

      IF NVL (i_lic_number, 0) <= 0
      THEN
         BEGIN
            UPDATE sgy_mn_lic_tape_cha_mapp
               SET ltcm_item_id = i_item_id,
                   ltcm_tape_id = i_tape_id,
                   ltcm_tape_entry_id = i_tape_entry_id
             WHERE sgy_mn_lic_tape_cha_mapp.ltcm_tap_number = i_tape_number;
         END;
      ELSE
         BEGIN
            UPDATE sgy_mn_lic_tape_cha_mapp
               SET ltcm_item_id = i_item_id,
                   ltcm_tape_id = i_tape_id,
                   ltcm_tape_entry_id = i_tape_entry_id
             WHERE sgy_mn_lic_tape_cha_mapp.ltcm_lic_number = i_lic_number
                   AND sgy_mn_lic_tape_cha_mapp.ltcm_tap_number =
                          i_tape_number;
         END;
      END IF;

      COMMIT;
      o_updated := 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_store_ardome_information;

   PROCEDURE x_prc_get_ardome_details (
      i_tape_number      IN     NUMBER,
      i_lic_number       IN     VARCHAR2,
      i_link_flag        IN     VARCHAR2,
      o_ardome_details      OUT SYS_REFCURSOR)
   AS
   BEGIN
      IF i_link_flag = 'UNLINK'
      THEN
         OPEN o_ardome_details FOR
            SELECT ltcm_item_id, ltcm_tape_id, ltcm_tape_entry_id
              FROM sgy_mn_lic_tape_cha_mapp
             WHERE ltcm_tap_number = i_tape_number
                   AND ltcm_lic_number = i_lic_number;
      END IF;

      IF i_link_flag = 'LINK'
      THEN
         OPEN o_ardome_details FOR
            SELECT fam_item_id ltcm_item_id,
                   NULL ltcm_tape_id,
                   NULL ltcm_tape_entry_id
              FROM x_fid_ardome_mapp
             WHERE fam_tap_number = i_tape_number;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_get_ardome_details;

   PROCEDURE x_prc_get_kill_date (i_gen_refno        IN     NUMBER,
                                  i_lic_number       IN     VARCHAR2,
                                  o_ardome_details      OUT SYS_REFCURSOR)
   AS
   BEGIN
      IF i_gen_refno IS NULL OR LENGTH (i_gen_refno) <= 0 OR i_gen_refno = 0
      THEN
         OPEN o_ardome_details FOR
            SELECT TO_CHAR (MAX (lic_end), 'DD-MM-YYYY') lic_end
              FROM fid_license
             WHERE lic_gen_refno = (SELECT lic_gen_refno
                                      FROM fid_license
                                     WHERE lic_number = i_lic_number);
      ELSE
         OPEN o_ardome_details FOR
            SELECT TO_CHAR (MAX (lic_end), 'DD-MM-YYYY') lic_end
              FROM fid_license
             WHERE lic_gen_refno = i_gen_refno;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_get_kill_date;

   PROCEDURE x_prc_get_uid_kill_date (
      i_tapenumber       IN     NUMBER,
      o_ardome_details      OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_ardome_details FOR
         SELECT TO_CHAR (tap_uid_end_date, 'DD-MM-YYYY') tap_uid_end_date
           FROM fid_tape
          WHERE tap_number = i_tapenumber;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_get_uid_kill_date;

   PROCEDURE x_prc_get_ardome_audit_entry (
      i_entry_date       IN     DATE,
      o_ardome_details      OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_ardome_details FOR
         SELECT DISTINCT ltcm_tap_number,
                         ltcm_item_id,
                         ltcm_lic_number,
                         'N' tap_is_uid,
                         NULL tap_uid_end_date, tap_barcode
           FROM x_fid_ardome_audit au, sgy_mn_lic_tape_cha_mapp sgymap, fid_tape t
          WHERE au.faa_lic_number = sgymap.ltcm_lic_number and t.tap_number = sgymap.ltcm_tap_number
                AND TO_CHAR (faa_entry_date, 'DD-MON-YYYY') =
                       TO_CHAR (SYSDATE - 3, 'DD-MON-YYYY')
                AND sgymap.ltcm_item_id IS NOT NULL
         UNION ALL
         SELECT DISTINCT
                ltcm_tap_number,
                ltcm_item_id,
                NVL (ltcm_lic_number, 0) ltcm_lic_number,
                NVL (tap_is_uid, 'N') tap_is_uid,
                TO_CHAR (tap_uid_end_date, 'DD-MM-YYYY') tap_uid_end_date, tap_barcode
           FROM sgy_mn_lic_tape_cha_mapp sgymap,
                x_fid_ardome_audit au,
                fid_tape ft
          WHERE au.faa_tap_number = sgymap.ltcm_tap_number
                AND sgymap.ltcm_tap_number = ft.tap_number
                AND TO_CHAR (faa_entry_date, 'DD-MON-YYYY') =
                       TO_CHAR (SYSDATE - 3, 'DD-MON-YYYY')
                AND sgymap.ltcm_item_id IS NOT NULL;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END x_prc_get_ardome_audit_entry;

   PROCEDURE x_prc_save_version_synopsis (
      i_gen_refno                     IN     NUMBER,
      i_syn_synopsisid_version        IN     NUMBER,
      i_syn_ver_lang_id               IN     NUMBER,
      i_syn_synopsisdetails_version   IN     VARCHAR2,
      i_syn_login_user                IN     VARCHAR2,
      o_success                          OUT NUMBER)
   AS
      l_local_count    NUMBER;
      o_success_flag   NUMBER;
   BEGIN
      o_success_flag := -1;
      --DBMS_OUTPUT.put_line ('Begin. ');

      SELECT COUNT (*)
        INTO l_local_count
        FROM fid_synopsis
       WHERE     syn_gen_refno = i_gen_refno
             AND syn_syt_id = 7
             AND syn_ver_lang_id = i_syn_ver_lang_id;

      --DBMS_OUTPUT.put_line ('Begin.- l_local_count ' || l_local_count);
      --DBMS_OUTPUT.put_line ('Begin.- i_syn_ver_lang_id ' || i_syn_ver_lang_id);

      ----DBMS_OUTPUT.put_line ('Begin. ' );
      IF (l_local_count = 0)
      THEN
         ----DBMS_OUTPUT.put_line ('Begin.- i_syn_SynopsisID_Version '||i_syn_SynopsisID_Version );
         IF (i_syn_synopsisid_version = 7)
         THEN
            INSERT INTO fid_synopsis (syn_gen_refno,
                                      syn_syt_id,
                                      syn_ver_lang_id,
                                      syn_synopsis,
                                      syn_entry_oper,
                                      syn_entry_date,
                                      syn_id)
                 VALUES (i_gen_refno,
                         i_syn_synopsisid_version,
                         i_syn_ver_lang_id,
                         i_syn_synopsisdetails_version,
                         i_syn_login_user,
                         SYSDATE,
                          x_seq_syn_id.nextval);

            o_success_flag := 1;
         END IF;
      ELSE
         IF (i_syn_synopsisid_version = 7)
         THEN
            --DBMS_OUTPUT.put_line ('updating');

            UPDATE fid_synopsis fs
               SET syn_synopsis = i_syn_synopsisdetails_version,
                   --NVL ( i_syn_synopsisdetails_version, fs.syn_synopsis),
                   syn_syt_id = NVL (i_syn_synopsisid_version, fs.syn_syt_id),
                   --Dev.R10 : Audit on Program Maintenance : Start : [Devashish Raverkar]_[2015/10/09]
                   --syn_entry_oper = i_entry_oper,
                   --syn_entry_date = SYSDATE,
                   syn_modified_by = i_syn_login_user,
                   syn_modified_date = sysdate,
                   --Dev.R10 : Audit on Program Maintenance : End
                   syn_update_count = syn_update_count + 1
             WHERE     syn_gen_refno = i_gen_refno
                   AND syn_syt_id = 7
                   AND syn_ver_lang_id = i_syn_ver_lang_id;

            --DBMS_OUTPUT.put_line ('aft update');
            o_success_flag := 1;
         END IF;
      END IF;

      IF (o_success_flag = 1)
      THEN
         COMMIT;
      ELSE
         ROLLBACK;
      END IF;
   END x_prc_save_version_synopsis;

   PROCEDURE x_prc_search_ver_synopsis (i_gen_refno   IN     NUMBER,
                                        o_ver_syn        OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_ver_syn FOR
         SELECT *
           FROM fid_synopsis
          WHERE syn_syt_id = 7 AND syn_gen_refno = i_gen_refno;
   END x_prc_search_ver_synopsis;

   --UID_Generation: Start:[MOP_UID_06]_[Anuja_Shinde]_[12-26-2013]
   PROCEDURE x_prc_mm_save_libmaterialdtls (
      i_gen_refno        IN     fid_general.gen_refno%TYPE,
      i_unique_id        IN     fid_tape.tap_barcode%TYPE,
      i_uid_status       IN     x_uid_status.uid_status%TYPE,
      i_uid_comment      IN     fid_tape.tap_comment%TYPE,
      i_update_count     IN     fid_tape.tap_update_count%TYPE,
      i_syn_login_user   IN     fid_tape.tap_entry_oper%TYPE,
      i_age_restriction  IN     fid_tape.tap_age_restriction%TYPE,-- CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[17-06-2016]
      i_tap_cp_area      IN     fid_tape.tap_cp_area%TYPE,    -- CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]
      i_tap_cp_work_instruction IN fid_tape.tap_cp_work_instruction%TYPE,-- CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[02-06-2016]
      o_return_rec          OUT SYS_REFCURSOR,
      o_result              OUT NUMBER)
   AS
      l_record_updated       NUMBER;
      v_operator             NUMBER;
      l_tap_update_count     NUMBER;
      l_tap_expired          VARCHAR2 (1);
      l_tap_associated       NUMBER;
      --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[16-03-2015]
      l_tap_uid_status_old   NUMBER;
      l_tap_number           NUMBER;
      l_tap_uid_status_new   NUMBER;
   ---DEV.R4:Inventory Mining:End
      l_is_content_associated NUMBER := 0;
   BEGIN
      o_result := 0;

      SELECT pkg_cm_username.setusername (i_syn_login_user)
        INTO v_operator
        FROM DUAL;

      SELECT tap_update_count,
             tap_is_expired                              --, tap_uid_status_id
                           --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[16-03-2015]
             ,
             tap_number,
             tap_uid_status_id
        ---DEV.R4:Inventory Mining:End
        INTO l_tap_update_count,
             l_tap_expired                               -- , l_tap_uid_status
                          --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[[16-03-2015]
             ,
             l_tap_number,
             l_tap_uid_status_old
        --DEV.R4:Inventory Mining:End
        FROM fid_tape
       WHERE tap_barcode = i_unique_id;

      --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[[16-03-2015]
      SELECT uid_status_id
        INTO l_tap_uid_status_new
        FROM x_uid_status
       WHERE TRIM (uid_status) = TRIM (i_uid_status);

      --DEV.R4:Inventory Mining:End

      IF (l_tap_expired = 'Y')
      THEN
         raise_application_error (
            -20001,
            'UID is Expaired update not allowed for UID' || '' || i_unique_id || '');
      END IF;

      IF l_tap_uid_status_old in (8,11) and l_tap_uid_status_new <> 13
      THEN
         raise_application_error (-20001, i_unique_id ||' UID is NonTX you can not active.');
      END IF;

      --Pravin_20150526 - Onsite Dev - Making milestone content associated Mandatory
      if(l_tap_uid_status_old = l_tap_uid_status_new)
      then
          l_is_content_associated := 1;
      elsif (X_FNC_IS_CONTENT_ASSOCIATED(i_unique_id))
      then
          l_is_content_associated := 1;
      end if;
      IF(l_is_content_associated = 1)
      THEN
      --Pravin_20150526 - Onsite Dev - Making milestone content associated Mandatory
      IF( NVL (i_update_count, 0) = NVL (l_tap_update_count, 0))
      THEN
         UPDATE fid_tape
            SET tap_comment = i_uid_comment,
                tap_age_restriction = i_age_restriction, -- CD and CE automation ver 1.0 [ref with BR_15_355 UC and CE]_[VIKAS SRIVASTAVA]_[17-06-2016]
                tap_cp_area = i_tap_cp_area,
	        tap_cp_work_instruction = i_tap_cp_work_instruction,--end CD and CE automation ver 1.0
                tap_uid_status_id =
                   (SELECT uid_status_id
                      FROM x_uid_status
                     WHERE TRIM (uid_status) = TRIM (i_uid_status)),
                tap_uid_status_updated_on = SYSDATE,
                tap_uid_status_updated_by = i_syn_login_user,
                tap_modify_on = SYSDATE,
                tap_uid_schedulable =
                   (SELECT (CASE
                               WHEN i_uid_status = 'PGA Non-TX'
                                    OR i_uid_status = 'QC Non-TX'
                               THEN
                                  'N'
                               ELSE
                                  'Y'
                            END)
                      FROM DUAL),
                tap_update_count = NVL (tap_update_count, 0) + 1
          WHERE tap_barcode = i_unique_id;

         -- and     nvl(TAP_UPDATE_COUNT,0) = I_UPDATE_COUNT;
         l_record_updated := SQL%ROWCOUNT;

         IF (l_tap_uid_status_old != l_tap_uid_status_new)
         THEN
            --DEV.R4:Inventory Mining:Start[Ref with MOP_ENH_01]_[Nasreen Mulla]_[11-03-2015]
            X_PKG_UPDATE_SCHEDULE.x_prc_get_gen_ref (l_tap_number,
                                                     'Material Duration');
         --DEV.R4:Inventory Mining:End
         END IF;

         IF l_record_updated > 0
         THEN
            COMMIT;
            o_result := l_record_updated;

            OPEN o_return_rec FOR
               SELECT tap_barcode,
                      tap_uid_status_id,
                      tap_uid_schedulable,
                      tap_update_count
                 FROM fid_tape
                WHERE tap_barcode = i_unique_id;

            --DBMS_OUTPUT.put_line ('updated record for UID -' || i_unique_id);
         ELSE
            l_record_updated := -1;
            ROLLBACK;
            raise_application_error (-20351, 'Failed to update record');
            --DBMS_OUTPUT.put_line ('failed to updated record for UID -' || i_unique_id);
         END IF;

         o_result := l_record_updated;
      ELSE
         raise_application_error (
            -20001,
               'The Library Material for Unique ID - '
            || i_unique_id
            || ' is already modified by another user.');
      END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20350, SUBSTR (SQLERRM, 1, 200));
   END x_prc_mm_save_libmaterialdtls;

   --added for auto-generated email to video library in case of PGA Reject
   PROCEDURE x_prc_email_dtls_pga_reject (
      i_action                 IN     VARCHAR2,
      o_return_email_details      OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_return_email_details FOR
         SELECT *
           FROM sgy_email
          WHERE UPPER (action) = UPPER (i_action);
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20350, SUBSTR (SQLERRM, 1, 200));
   END x_prc_email_dtls_pga_reject;

   --UID_Generation: End

   --#region Abhinay_1oct14: Embargo Content Implementation

   PROCEDURE pck_mm_mnet_get_embargodet (
      i_genref    IN     fid_general.gen_refno%TYPE,
      i_embargo   IN     fid_general.gen_embargo_content%TYPE,
      o_cursor       OUT SYS_REFCURSOR)
   AS
      l_embargo_content   VARCHAR2 (1);
      l_number            NUMBER;
   BEGIN
      /*
           Select NVL(gen_embargo_content,'N')
            INTO l_embargo_content
            from fid_general
            where gen_refno = i_genref;

           select count(*)
           INTO l_number
            from sgy_mn_lic_tape_cha_mapp ,fid_general, fid_tape
            where gen_refno = ltcm_gen_refno
            and tap_number = ltcm_tap_number
            and gen_refno = i_genref;

            If ( NVL(l_embargo_content,'N') != NVL(i_embargo,'N') )
              THEN

              if(l_number > 0)
                THEN

                 UPDATE fid_general
                 set gen_embargo_content = i_embargo
                 where gen_refno = i_genref;

              END IF;
              OPEN o_cursor FOR

                  select LTCM_GEN_REFNO,LTCM_TAP_NUMBER,LTCM_ITEM_ID,LTCM_TAPE_ID,LTCM_TAPE_ENTRY_ID,tap_barcode,GEN_EMBARGO_CONTENT
                  from sgy_mn_lic_tape_cha_mapp ,fid_general, fid_tape
                  where gen_refno = ltcm_gen_refno
                  and tap_number = ltcm_tap_number
                  and gen_refno = i_genref;

            END IF;
      */

      -- #region 6March2015: EmbargoContent Save Logic Change

      SELECT NVL (gen_embargo_content, 'N')
        INTO l_embargo_content
        FROM fid_general
       WHERE gen_refno = i_genref;

      /* If ( NVL(l_embargo_content,'N') != NVL(i_embargo,'N') )
           THEN
   */
      OPEN o_cursor FOR
         SELECT LTCM_GEN_REFNO,
                LTCM_TAP_NUMBER,
                LTCM_ITEM_ID,
                LTCM_TAPE_ID,
                LTCM_TAPE_ENTRY_ID,
                tap_barcode,
                GEN_EMBARGO_CONTENT,
                GEN_IS_CINEMA_EMBARGO_CONTENT,--Onsite.Dev:BR_15_327
                GEN_IS_ARCHIVE_EMBARGO_CONTENT,--OnSite.Dev Archive Embargo
                TAP_VIZ_ITEM_ASSET_ID
           FROM sgy_mn_lic_tape_cha_mapp, fid_general, fid_tape
          WHERE     gen_refno = ltcm_gen_refno
                AND tap_number = ltcm_tap_number
                AND gen_refno = i_genref;
   -- END IF;

   -- #endregion 6March2015


   END pck_mm_mnet_get_embargodet;

   PROCEDURE pck_mm_mnet_del_mapping (
      i_tapenumber IN fid_tape.tap_number%TYPE)
   AS
   BEGIN
      UPDATE sgy_mn_lic_tape_cha_mapp
         SET ltcm_tape_entry_id = NULL
       WHERE ltcm_tap_number = i_tapenumber;
   END pck_mm_mnet_del_mapping;

   --#endregion Abhinay_1oct14

   --#region: NEW CHANGES IN EMBARGO @ 20 Nov 2014

   PROCEDURE pck_mm_mnet_get_arddet (
      i_tapenumber   IN     fid_tape.tap_number%TYPE,
      o_cursor          OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_cursor FOR
         SELECT LTCM_TAP_NUMBER,
                tap_barcode,
                ltcm_item_id,
                ltcm_tape_id,
                LTCM_TAPE_ENTRY_ID
           FROM sgy_mn_lic_tape_cha_mapp, fid_tape
          WHERE ltcm_tap_number = tap_number
                AND ltcm_tap_number = i_tapenumber;
   END pck_mm_mnet_get_arddet;

   --#endregion: NEW CHANGES IN EMBARGO @ 20 Nov 2014

   --#region Abhinay_1dec14 : Ardome Issues Fix

   PROCEDURE pck_mm_mnet_save_synergy (i_tape            IN     NUMBER,
                                       i_item_id         IN     VARCHAR2,
                                       i_tape_id         IN     VARCHAR2,
                                       i_tape_entry_id   IN     VARCHAR2,
                                       o_success            OUT NUMBER)
   AS
      o_success_flag   NUMBER;
   BEGIN
      o_success_flag := 0;

      UPDATE sgy_mn_lic_tape_cha_mapp
         SET LTCM_ITEM_ID = i_item_id,
             LTCM_TAPE_ID = i_tape_id,
             LTCM_TAPE_ENTRY_ID = i_tape_entry_id
       WHERE LTCM_TAP_NUMBER = i_tape;

      COMMIT;
      o_success_flag := 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END pck_mm_mnet_save_synergy;

   PROCEDURE pck_mm_mnet_save_synergy_Prod (
      i_tape            IN     NUMBER,
      i_item_id         IN     VARCHAR2,
      i_tape_id         IN     VARCHAR2,
      i_tape_entry_id   IN     VARCHAR2,
      o_success            OUT NUMBER)
   AS
      o_success_flag   NUMBER;
      o_exist          NUMBER;
   BEGIN
      o_success_flag := 0;

      SELECT COUNT (*)
        INTO o_exist
        FROM sgy_mn_lic_tape_cha_mapp
       WHERE ltcm_tap_number = i_tape;

      IF (o_exist > 0)
      THEN
         UPDATE sgy_mn_lic_tape_cha_mapp
            SET LTCM_ITEM_ID = i_item_id,
                LTCM_TAPE_ID = i_tape_id,
                LTCM_TAPE_ENTRY_ID = i_tape_entry_id
          WHERE LTCM_TAP_NUMBER = i_tape;

         COMMIT;
         o_success_flag := 1;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20108, SQLERRM);
   END pck_mm_mnet_save_synergy_Prod;

   --#endregion Abhinay_1dec14 : Ardome Issues Fix

   FUNCTION fun_convert_duration_c_n (p_durchar IN VARCHAR2)
      RETURN NUMBER
   IS
      duration_number   NUMBER;
      l_durchar         VARCHAR2 (50);
   BEGIN
      duration_number :=
           (SUBSTR (p_durchar, 1, INSTR (p_durchar, ':') - 1) * 3600)
         + (SUBSTR (p_durchar, INSTR (p_durchar, ':') + 1, 2) * 60)
         + SUBSTR (p_durchar,
                   INSTR (p_durchar,
                          ':',
                          1,
                          2)
                   + 1,
                   2);
      RETURN (duration_number);
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN 0;
   END fun_convert_duration_c_n;

   --Translated Titles tab: Start:[RDT release 10]_[Neeraj Basliyal]_[09-26-2014]
   PROCEDURE prc_insertTranslatedTitle (
      i_gen_refno        IN     fid_general.gen_refno%TYPE,
      i_trans_language   IN     x_fid_general_alt_title.trans_language%TYPE,
      i_trans_name       IN     x_fid_general_alt_title.trans_name%TYPE,
      i_entry_oper       IN     x_fid_general_alt_title.trans_entry_oper%TYPE,
      i_transGenre_Id    IN     X_TRANSLATED_GENRE.XTG_GENRE_ID%TYPE,
      o_success             OUT NUMBER,
      o_delall_status    IN OUT VARCHAR2)
   AS
      l_temp_no     NUMBER;
      l_title_cnt   NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_title_cnt
        FROM x_fid_general_alt_title
       WHERE TRANS_GEN_REFNO = i_gen_refno;

      IF l_title_cnt > 0 AND o_delall_status = 'N'
      THEN
         DELETE FROM x_fid_general_alt_title
               WHERE TRANS_GEN_REFNO = i_gen_refno;
      END IF;

      SELECT X_SEQ_TRANS_ID.NEXTVAL INTO l_temp_no FROM DUAL;


      INSERT INTO x_fid_general_alt_title (TRANS_GEN_REFNO,
                                           TRANS_LANGUAGE,
                                           TRANS_NAME,
                                           TRANS_ENTRY_OPER,
                                           TRANS_ENTRY_DATE,
                                           TRANS_UNIQUE_ID,
                                           TRANS_GENRE_ID)
           VALUES (i_gen_refno,
                   i_trans_language,
                   i_trans_name,
                   i_entry_oper,
                   SYSDATE,
                   l_temp_no,
                   i_transGenre_Id);

      o_success := l_temp_no;
      o_delall_status := 'Y';
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END prc_insertTranslatedTitle;

   PROCEDURE prc_updateTranslatedTitle (
      i_gen_refno         IN     fid_general.gen_refno%TYPE,
      i_trans_language    IN     x_fid_general_alt_title.trans_language%TYPE,
      i_trans_name        IN     x_fid_general_alt_title.trans_name%TYPE,
      i_trans_unique_id   IN     x_fid_general_alt_title.trans_unique_id%TYPE,
      i_entry_oper        IN     x_fid_general_alt_title.trans_entry_oper%TYPE,
      o_success              OUT NUMBER)
   AS
      l_count     NUMBER;
      l_temp_no   NUMBER;
   BEGIN
      o_success := 1;

      SELECT COUNT (*)
        INTO l_count
        FROM x_fid_general_alt_title
       WHERE trans_unique_id = i_trans_unique_id;

      IF (l_count = 0)
      THEN
         BEGIN
            SELECT X_SEQ_TRANS_ID.NEXTVAL INTO l_temp_no FROM DUAL;

            INSERT INTO x_fid_general_alt_title (trans_gen_refno,
                                                 trans_language,
                                                 trans_name,
                                                 trans_entry_oper,
                                                 trans_entry_date,
                                                 trans_unique_id)
                 VALUES (i_gen_refno,
                         i_trans_language,
                         i_trans_name,
                         i_entry_oper,
                         SYSDATE,
                         l_temp_no);

            o_success := l_temp_no;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_success := 0;
         END;
      ELSE
         BEGIN
            UPDATE x_fid_general_alt_title fgt
               SET trans_language = NVL (i_trans_language, fgt.trans_language),
                   trans_name = NVL (i_trans_name, fgt.trans_name),
                   trans_entry_oper = i_entry_oper,
                   trans_entry_date = SYSDATE,
                   trans_update_count = NVL (trans_update_count, 0) + 1
             WHERE trans_unique_id = i_trans_unique_id;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_success := 0;
         END;
      END IF;
   END prc_updateTranslatedTitle;

   PROCEDURE prc_DeleteTranslatedTitle (
      i_gen_refno   IN     fid_general.gen_refno%TYPE,
      o_success        OUT NUMBER)
   AS
   BEGIN
      DELETE FROM x_fid_general_alt_title
            WHERE TRANS_GEN_REFNO = i_gen_refno;

      o_success := 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END prc_DeleteTranslatedTitle;

   --Translated Titles tab: End

   PROCEDURE PCK_UPDATE_ARDOME_ITEM_ID (i_tape_barcode   IN     VARCHAR2,
                                        i_item_id        IN     VARCHAR2,
                                        o_success           OUT NUMBER)
   AS
   BEGIN
      IF i_tape_barcode IS NOT NULL
      THEN
         UPDATE X_FID_ARDOME_MAPP
            SET FAM_ITEM_ID = NVL (i_item_id, NULL)
          WHERE FAM_TAP_NUMBER = (SELECT TAP_NUMBER
                                    FROM FID_TAPE
                                   WHERE TAP_BARCODE = i_tape_barcode);

         o_success := 1;
         COMMIT;
      ELSE
         o_success := 0;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_success := 0;
   END PCK_UPDATE_ARDOME_ITEM_ID;

   /*Added by Swapnil Malvi on 12-Mar-2015 for Clearleap Release*/
   /*To save VOD Tab data*/
   PROCEDURE Prc_Save_VOD_Details (
      i_pvd_uid_lang_id          IN     x_prog_vod_details.pvd_uid_lang_id%TYPE,
      i_pvd_gen_refno            IN     x_prog_vod_details.pvd_gen_refno%TYPE,
      i_pvd_gen_title            IN     x_prog_vod_details.pvd_gen_title%TYPE,
      i_pvd_pvr_title            IN     x_prog_vod_details.pvd_pvr_title%TYPE,
      i_pvd_show_type            IN     x_prog_vod_details.pvd_show_type%TYPE,
      i_pvd_themes               IN     VARCHAR2,
      i_pvd_primary_genre        IN     VARCHAR2,
      i_pvd_secondary_genre      IN     VARCHAR2,
      i_pvd_actors               IN     x_prog_vod_details.pvd_actors%TYPE,
      i_pvd_directors            IN     x_prog_vod_details.pvd_directors%TYPE,
      i_pvd_title_synopsis       IN     x_prog_vod_details.pvd_title_synopsis%TYPE,
      i_svd_ser_title            IN     x_ser_vod_details.svd_ser_title%TYPE,
      i_svd_synopsis_ser         IN     x_ser_vod_details.svd_synopsis%TYPE,
      i_svd_synopsis             IN     x_ser_vod_details.svd_synopsis%TYPE,
      i_pvd_afr_title_synopsis   IN     x_prog_vod_details.PVD_AFR_TITLE_SYNOPSIS%TYPE,
      i_svd_afr_synopsis_ser     IN     x_ser_vod_details.svd_afr_synopsis%TYPE,
      i_svd_afr_synopsis         IN     x_ser_vod_details.svd_afr_synopsis%TYPE,
      i_svd_entry_oper           IN     x_ser_vod_details.svd_entry_oper%TYPE,
        /*Start: Added by sushma on 11-07-2016 for EPG Vod chnages to maintain the synopsis versin*/
      i_title_ver                IN     x_prog_vod_details.PVD_SYN_VERSION%TYPE,
      i_season_ver               IN     x_ser_vod_details.SVD_SYN_VERSION%TYPE,
      i_ser_ver                  IN     x_ser_vod_details.SVD_SYN_VERSION%TYPE, --END
      o_sucess_flag              OUT    NUMBER)
   AS
      l_is_series_flag      VARCHAR2 (2);
      l_gen_ser_number      fid_general.gen_ser_number%TYPE;
      l_pvd_number          x_prog_vod_details.pvd_number%TYPE;
      l_ser_number          fid_series.ser_number%TYPE;
      l_ser_parent_number   fid_series.ser_parent_number%TYPE;
      l_svd_number          X_SER_VOD_DETAILS.svd_number%TYPE;
      --CU4ALL [ANUJA SHINDE]
      L_CNT                 NUMBER;
      L_SEC_GENRE           varchar2(2000);
      L_SEC_GENRE_NEW        VARCHAR2(2000);
     -- L_PVD_NUMBER          NUMBER;
      l_records_presents    NUMBER;
         l_cast_update_flag    char(1);
      l_old_actor           VARCHAR2(255);
      l_old_direct           VARCHAR2(150);
   BEGIN
      BEGIN
         SELECT cod_attr1
           INTO l_is_series_flag
           FROM fid_general, fid_code
          WHERE gen_type = cod_value
            AND cod_type = 'GEN_TYPE'
            AND gen_refno = i_pvd_gen_refno;

         SELECT COUNT (1)
           INTO l_cnt
           FROM x_prog_vod_details
          WHERE pvd_gen_refno = i_pvd_gen_refno
            AND pvd_uid_lang_id = i_pvd_uid_lang_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_is_series_flag := 'N';
      END;


   ---Added by Sushma on 14-jul-2016 for EPG Phase 1 for VOD changes
        --get the ols cast value comapre it with new one and update the is cast updated flaf to 'Y'
       BEGIN
          select pvd_actors,pvd_directors
            INTO l_old_actor,l_old_direct
           from X_PROG_VOD_DETAILS
           where pvd_gen_refno = i_pvd_gen_refno
            AND pvd_uid_lang_id = i_pvd_uid_lang_id;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
           l_old_actor := NULL;
           l_old_direct := NULL;
         END;

         IF (l_old_actor != i_pvd_actors) or (l_old_direct != i_pvd_directors)
         THEN
           l_cast_update_flag := 'Y' ;
         END IF;
            ---END

       IF  l_is_series_flag='Y'
      THEN/*If VOD data doesn't exists then Insert data in X_PROG_VOD_DETAILS */
         BEGIN
              FOR l_records IN (select gen_refno from fid_general
                                 where gen_ser_number IN (SELECT gen_ser_number FROM fid_general
                                 WHERE gen_refno = i_pvd_gen_refno)) LOOP
         SELECT count(1) into l_records_presents FROM X_PROG_VOD_DETAILS WHERE  pvd_gen_refno = l_records.gen_refno AND pvd_uid_lang_id=i_pvd_uid_lang_id;
         IF l_records_presents =0
         THEN
         INSERT INTO X_PROG_VOD_DETAILS
                      (pvd_number,
                       pvd_uid_lang_id,
                       pvd_gen_refno,
                       pvd_gen_title,
                       pvd_pvr_title,
                       pvd_show_type,
                       pvd_themes,
                       pvd_primary_genre,
                       pvd_actors,
                       pvd_directors,
                       pvd_title_synopsis,
                       pvd_entry_date,
                       pvd_entry_oper ,
                       PVD_AFR_TITLE_SYNOPSIS
                      )
              VALUES  (X_SEQ_PROG_VOD_DETAILS_PK.NEXTVAL,
                      i_pvd_uid_lang_id,
                      l_records.gen_refno,
                      DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_gen_title,null),
                      DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_pvr_title,null),
                      DECODE(l_is_series_flag,'Y',NULL,i_pvd_show_type),
                      DECODE(l_is_series_flag,'Y',NULL,i_pvd_themes),
                      DECODE(l_is_series_flag,'Y',NULL,i_pvd_primary_genre),
                      --DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_show_type,null),
                      --DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_themes,null),
                      --DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_primary_genre,null),
                      i_pvd_actors,
                      i_pvd_directors,
                      DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_title_synopsis,null),
                      SYSDATE,
                      i_svd_entry_oper,
                      DECODE(l_records.gen_refno,i_pvd_gen_refno,i_PVD_AFR_TITLE_SYNOPSIS,null)
                      );
          ELSE
              UPDATE X_PROG_VOD_DETAILS
                SET pvd_gen_title = DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_gen_title,pvd_gen_title),
                    pvd_pvr_title =  DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_pvr_title,pvd_pvr_title),
                    pvd_show_type = DECODE(l_is_series_flag,'Y',NULL,i_pvd_show_type),
                    pvd_themes = DECODE(l_is_series_flag,'Y',NULL,i_pvd_themes),
                    pvd_primary_genre = DECODE(l_is_series_flag,'Y',NULL,i_pvd_primary_genre),
                    pvd_actors = i_pvd_actors,
                    pvd_directors = DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_directors,pvd_directors) ,
                    pvd_title_synopsis = DECODE(l_records.gen_refno,i_pvd_gen_refno,i_pvd_title_synopsis,pvd_title_synopsis),
                    PVD_AFR_TITLE_SYNOPSIS = DECODE(l_records.gen_refno,i_pvd_gen_refno,i_PVD_AFR_TITLE_SYNOPSIS,null),
                    PVD_SYN_VERSION = i_title_ver,
                    PVD_UPDATE_COUNT = NVL(PVD_UPDATE_COUNT,0) +1,
                    PVD_MODIFY_OPER = i_svd_entry_oper,
                    pvd_is_update_flag = l_cast_update_flag,
                    PVD_MODIFY_DATE = SYSDATE
                WHERE
                    pvd_gen_refno = l_records.gen_refno
                    AND pvd_uid_lang_id =  i_pvd_uid_lang_id;
           END IF;
         END LOOP;
      END;
    END IF;

     IF l_is_series_flag ='N'
     THEN
       IF l_cnt = 0
        THEN/*If VOD data doesn't exists then Insert data in X_PROG_VOD_DETAILS*/
           INSERT INTO X_PROG_VOD_DETAILS
                      (pvd_number,
                       pvd_uid_lang_id,
                       pvd_gen_refno,
                       pvd_gen_title,
                       pvd_pvr_title,
                       pvd_show_type,
                       pvd_themes,
                       pvd_primary_genre,
                       pvd_actors,
                       pvd_directors,
                       pvd_title_synopsis,
                       pvd_entry_date,
                       pvd_entry_oper,
                       PVD_AFR_TITLE_SYNOPSIS
		       ---Added by Sushma on 14-jul-2016 for EPG Phase 1 for VOD changes
                       ,PVD_SYN_VERSION
                       ,pvd_is_update_flag
                       --END
                      )
              VALUES (X_SEQ_PROG_VOD_DETAILS_PK.NEXTVAL,
                      i_pvd_uid_lang_id,
                      i_pvd_gen_refno,
                      i_pvd_gen_title,
                      i_pvd_pvr_title,
                      DECODE(l_is_series_flag,'Y',NULL,i_pvd_show_type),
                      DECODE(l_is_series_flag,'Y',NULL,i_pvd_themes),
                      DECODE(l_is_series_flag,'Y',NULL,i_pvd_primary_genre),
                      i_pvd_actors,
                      i_pvd_directors,
                      i_pvd_title_synopsis,
                      SYSDATE,
                      i_svd_entry_oper,
                      i_PVD_AFR_TITLE_SYNOPSIS
                      ---Added by Sushma on 14-jul-2016 for EPG Phase 1 for VOD changes
                      ,i_title_ver
                      ,'N'
                      );
        ELSE/*If VOD data exists then Update data from X_PROG_VOD_DETAILS*/
         UPDATE X_PROG_VOD_DETAILS
            SET pvd_gen_title          = i_pvd_gen_title,
                pvd_pvr_title          = i_pvd_pvr_title,
                pvd_show_type          = DECODE(l_is_series_flag,'Y',NULL,i_pvd_show_type),
                pvd_themes             = DECODE(l_is_series_flag,'Y',NULL,i_pvd_themes),
                pvd_primary_genre      = DECODE(l_is_series_flag,'Y',NULL,i_pvd_primary_genre),
                pvd_actors             = i_pvd_actors,
                pvd_directors          = i_pvd_directors,
                pvd_title_synopsis     = i_pvd_title_synopsis,
                PVD_AFR_TITLE_SYNOPSIS = i_pvd_afr_title_synopsis,
                PVD_MODIFY_DATE        = SYSDATE,
                PVD_MODIFY_OPER        = i_svd_entry_oper,
                PVD_UPDATE_COUNT       = NVL (PVD_UPDATE_COUNT, 0) + 1,
                  ---Added by Sushma on 14-jul-2016 for EPG Phase 1 for VOD changes
                PVD_SYN_VERSION = i_title_ver ,
                pvd_is_update_flag = l_cast_update_flag
                --END
          WHERE pvd_gen_refno       = i_pvd_gen_refno
                AND pvd_uid_lang_id = i_pvd_uid_lang_id;
          END IF;
      END IF;

      IF l_is_series_flag = 'Y'
      THEN/*If Title is a series,get series number and season number*/
         SELECT ser_number, ser_parent_number
           INTO l_ser_number, l_ser_parent_number
           FROM fid_general, fid_series
          WHERE gen_ser_number = ser_number
            AND gen_refno = i_pvd_gen_refno;

         IF l_ser_number IS NOT NULL AND l_ser_parent_number IS NOT NULL
         THEN/*Check if data exists for season*/
            SELECT COUNT (1)
              INTO l_cnt
              FROM X_SER_VOD_DETAILS
             WHERE svd_ser_number = l_ser_number
               AND svd_uid_lang_id = i_pvd_uid_lang_id;

            IF l_cnt = 0
            THEN/*If not exists, Insert it*/
               INSERT INTO X_SER_VOD_DETAILS
                          ( svd_number,
                            svd_ser_number,
                            svd_uid_lang_id,
                            svd_synopsis,
                            svd_afr_synopsis,
                            svd_entry_date,
                            svd_entry_oper,
                            SVD_SYN_VERSION
                          )
                    VALUES (X_SEQ_SER_VOD_DETAILS_PK.NEXTVAL,
                            l_ser_number,
                            i_pvd_uid_lang_id,
                            i_svd_synopsis,
                            i_svd_afr_synopsis,
                            SYSDATE,
                            i_svd_entry_oper,
                            i_season_ver
                            );
            ELSE/*If exists, Update it*/
               UPDATE X_SER_VOD_DETAILS
                  SET svd_synopsis     = i_svd_synopsis,
                      svd_afr_synopsis = i_svd_afr_synopsis,
                      SVD_MODIFY_DATE  = SYSDATE,
                      SVD_MODIFY_OPER  = i_svd_entry_oper,
                      SVD_UPDATE_COUNT = NVL (SVD_UPDATE_COUNT, 0) + 1,
                      SVD_SER_TITLE    = i_svd_ser_title,
                      SVD_SYN_VERSION = i_season_ver
                WHERE svd_uid_lang_id    = i_pvd_uid_lang_id
                      AND svd_ser_number = l_ser_number;
            END IF;

             /* Update all episode added by vikas srivastava [30 Mar 2016]*/
               SELECT  gen_ser_number  INTO l_gen_ser_number
                FROM  fid_general , x_prog_vod_details
            WHERE pvd_gen_refno=gen_refno
            AND pvd_gen_refno =i_pvd_gen_refno
            AND pvd_uid_lang_id=i_pvd_uid_lang_id;

            IF(l_is_series_flag ='Y')
             THEN
                UPDATE X_PROG_VOD_DETAILS
                  SET pvd_actors             = i_pvd_actors
                  --,pvd_directors          = i_pvd_directors
                WHERE pvd_gen_refno  IN (SELECT gen_refno FROM fid_general WHERE gen_ser_number =l_gen_ser_number) --i_pvd_gen_refno
                AND pvd_uid_lang_id = i_pvd_uid_lang_id;
             END IF;

            /* end Update all episode */

            /*Check if data exists for series*/
            SELECT COUNT (1)
              INTO l_cnt
              FROM X_SER_VOD_DETAILS
             WHERE svd_ser_number = l_ser_parent_number
               AND svd_uid_lang_id = i_pvd_uid_lang_id;

            IF l_cnt = 0
            THEN/*If not exists, Insert it*/
               INSERT INTO X_SER_VOD_DETAILS
                          ( svd_number,
                            svd_ser_number,
                            svd_ser_title,
                            svd_uid_lang_id,
                            svd_synopsis,
                            svd_afr_synopsis,
                            svd_entry_date,
                            svd_entry_oper,
                            SVD_THEMES,
                            SVD_PRIMARY_GENRE,
                            SVD_SHOW_TYPE,
                            SVD_SYN_VERSION
                           )
                    VALUES (X_SEQ_SER_VOD_DETAILS_PK.NEXTVAL,
                            l_ser_parent_number,
                            i_svd_ser_title,
                            i_pvd_uid_lang_id,
                            i_svd_synopsis_ser,
                            i_svd_afr_synopsis_ser,
                            SYSDATE,
                            i_svd_entry_oper,
                            i_pvd_themes,
                            i_pvd_primary_genre,
                            i_pvd_show_type,
                            i_ser_ver
                           );
            ELSE/*If exists, Update it*/
               UPDATE X_SER_VOD_DETAILS
                  SET svd_synopsis     = i_svd_synopsis_ser,
                      svd_afr_synopsis = i_svd_afr_synopsis_ser,
                      SVD_MODIFY_DATE  = SYSDATE,
                      SVD_MODIFY_OPER  = i_svd_entry_oper,
                      SVD_UPDATE_COUNT = NVL (SVD_UPDATE_COUNT, 0) + 1,
                      SVD_SER_TITLE      = i_svd_ser_title,
                      SVD_THEMES         =i_pvd_themes,
                      SVD_PRIMARY_GENRE  =i_pvd_primary_genre,
                      SVD_SHOW_TYPE      =i_pvd_show_type,
                      SVD_SYN_VERSION = i_ser_ver
                WHERE svd_uid_lang_id    = i_pvd_uid_lang_id
                      AND svd_ser_number = l_ser_parent_number;
            END IF;
         ELSIF l_ser_number IS NOT NULL AND l_ser_parent_number IS NULL
         THEN/*It is a Series without Season, check if record exists*/
            SELECT COUNT (1)
              INTO l_cnt
              FROM X_SER_VOD_DETAILS
             WHERE svd_ser_number = l_ser_number
               AND svd_uid_lang_id = i_pvd_uid_lang_id;

            IF l_cnt = 0
            THEN/*If not exists, Insert it*/
               INSERT INTO X_SER_VOD_DETAILS
                          ( svd_number,
                            svd_ser_number,
                            svd_ser_title,
                            svd_uid_lang_id,
                            svd_synopsis,
                            svd_afr_synopsis,
                            svd_entry_date,
                            svd_entry_oper,
                            SVD_THEMES,
                            SVD_PRIMARY_GENRE,
                            SVD_SHOW_TYPE,
                            SVD_SYN_VERSION
                          )
                    VALUES (X_SEQ_SER_VOD_DETAILS_PK.NEXTVAL,
                            l_ser_parent_number,
                            i_svd_ser_title,
                            i_pvd_uid_lang_id,
                            i_svd_synopsis_ser,
                            i_svd_afr_synopsis_ser,
                            SYSDATE,
                            i_svd_entry_oper,
                            i_pvd_themes,
                            i_pvd_primary_genre,
                            i_pvd_show_type
                            ,i_ser_ver
                            );
            ELSE/*If exists, Update it*/
               UPDATE X_SER_VOD_DETAILS
                  SET svd_synopsis     = i_svd_synopsis_ser,
                      svd_afr_synopsis = i_svd_afr_synopsis_ser,
                      SVD_MODIFY_DATE  = SYSDATE,
                      SVD_MODIFY_OPER  = i_svd_entry_oper,
                      SVD_UPDATE_COUNT = NVL (SVD_UPDATE_COUNT, 0) + 1,
                      SVD_SER_TITLE    = i_svd_ser_title,
                      SVD_THEMES         =i_pvd_themes,
                      SVD_PRIMARY_GENRE  =i_pvd_primary_genre,
                      SVD_SHOW_TYPE      =i_pvd_show_type,
                      SVD_SYN_VERSION = i_ser_ver
                WHERE svd_uid_lang_id    = i_pvd_uid_lang_id
                      AND svd_ser_number = l_ser_parent_number;
            END IF;
         END IF;
      END IF;
      /*Delete and Re-insert Genre Details for that title in X_PROG_VOD_GENRE_DETAILS*/
       if nvl(l_is_series_flag,'N') <> 'Y'
	     then

              --CU4ALL START :[ANUJA SHINDE]
               SELECT  LISTAGG (COD_VALUE,',') WITHIN GROUP (ORDER BY COD_ATTR1)
                INTO L_SEC_GENRE
               FROM FID_CODE WHERE COD_TYPE = 'VOD_GENRE' AND COD_ATTR1 IN (
               SELECT GD_GENRE_MAPP_ID
               FROM X_PROG_VOD_GENRE_DETAILS
               WHERE  GD_GEN_REFNO = i_pvd_gen_refno
               AND GD_LANG_ID = i_pvd_uid_lang_id);

              SELECT PVD_NUMBER INTO L_PVD_NUMBER FROM X_PROG_VOD_DETAILS
              WHERE PVD_GEN_REFNO = i_pvd_gen_refno
              AND PVD_UID_LANG_ID = i_pvd_uid_lang_id;

                 select LISTAGG (COD_VALUE,',') within group (order by COD_ATTR1)
                  INTO L_SEC_GENRE_NEW
                  from FID_CODE
                 where COD_TYPE = 'VOD_GENRE'
                 and COD_ATTR1 in  (select column_value
                                         FROM TABLE (X_PKG_CM_SPLIT_STRING.split_to_char(i_pvd_secondary_genre)));

                 ---CU4ALL END

      			  DELETE FROM X_PROG_VOD_GENRE_DETAILS
      					WHERE GD_GEN_REFNO = i_pvd_gen_refno
      					  AND GD_LANG_ID = i_pvd_uid_lang_id;

      			  INSERT INTO X_PROG_VOD_GENRE_DETAILS (GD_GEN_REFNO,GD_LANG_ID,GD_GENRE_MAPP_ID,GD_IS_SERIES_FLAG)
      				 SELECT i_pvd_gen_refno, i_pvd_uid_lang_id, COLUMN_VALUE,'N'
      				   FROM TABLE (X_PKG_CM_SPLIT_STRING.split_to_char (i_pvd_secondary_genre))
      					   ,fid_code
      				  WHERE COLUMN_VALUE = cod_attr1 AND COD_TYPE = 'VOD_GENRE'
      					AND cod_attr2 IN(SELECT COLUMN_VALUE
      									   FROM TABLE (X_PKG_CM_SPLIT_STRING.split_to_char (i_pvd_themes)));
                 --CU4ALL : START [ANUJA SHINDE]
                 IF L_SEC_GENRE_NEW <> L_SEC_GENRE THEN
             X_PRC_INSERT_PROG_VOD_HISTORY (L_PVD_NUMBER,
                                            i_pvd_uid_lang_id,
                                            ' Secondary Genre',
                                            L_SEC_GENRE,
                                            L_SEC_GENRE_NEW,
                                            i_svd_entry_oper,
                                            NULL
                                            );
             END IF;
	     	else
              --CU4ALL START :[ANUJA SHINDE]
               SELECT  LISTAGG (COD_VALUE,',') WITHIN GROUP (ORDER BY COD_ATTR1)
                INTO L_SEC_GENRE
               FROM FID_CODE WHERE COD_TYPE = 'VOD_GENRE' AND COD_ATTR1 IN (
               SELECT GD_GENRE_MAPP_ID
               FROM X_PROG_VOD_GENRE_DETAILS
               WHERE  GD_GEN_REFNO = nvl(l_ser_parent_number,l_ser_number)
               AND GD_LANG_ID = i_pvd_uid_lang_id);

                 select LISTAGG (COD_VALUE,',') within group (order by COD_ATTR1)
                  INTO L_SEC_GENRE_NEW
                  from FID_CODE
                 where COD_TYPE = 'VOD_GENRE'
                 and COD_ATTR1 in  (select column_value
                                         FROM TABLE (X_PKG_CM_SPLIT_STRING.split_to_char(i_pvd_secondary_genre)));

                 ---CU4ALL END

      			  DELETE FROM X_PROG_VOD_GENRE_DETAILS
      					WHERE GD_GEN_REFNO = nvl(l_ser_parent_number,l_ser_number)
      					  AND GD_LANG_ID = i_pvd_uid_lang_id
      					  AND GD_IS_SERIES_FLAG ='Y'
      					  ;

      			  INSERT INTO X_PROG_VOD_GENRE_DETAILS (GD_GEN_REFNO,GD_LANG_ID,GD_GENRE_MAPP_ID,GD_IS_SERIES_FLAG)
      				 SELECT nvl(l_ser_parent_number,l_ser_number), i_pvd_uid_lang_id, COLUMN_VALUE,'Y'
      				   FROM TABLE (X_PKG_CM_SPLIT_STRING.split_to_char (i_pvd_secondary_genre))
      					   ,fid_code
      				  WHERE COLUMN_VALUE = cod_attr1 AND COD_TYPE = 'VOD_GENRE'
      					AND cod_attr2 IN(SELECT COLUMN_VALUE
      									   FROM TABLE (X_PKG_CM_SPLIT_STRING.split_to_char (i_pvd_themes)));



              --CU4ALL : START [ANUJA SHINDE]
               IF L_SEC_GENRE_NEW <> L_SEC_GENRE THEN
               --INSERT INTO TEMP_TABLE VALUES ('TEMP '||nvl(l_ser_parent_number,l_ser_number));

             X_PRC_INSERT_PROG_VOD_HISTORY (nvl(l_ser_parent_number,l_ser_number),
                                            i_pvd_uid_lang_id,
                                            ' Secondary Genre',
                                            L_SEC_GENRE,
                                            L_SEC_GENRE_NEW,
                                            i_svd_entry_oper,
                                            NULL
                                            );
                END IF;
  --Milan Shah
  --END IF;

		end if;
      COMMIT;
      o_sucess_flag := 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_sucess_flag := -1;
         raise_application_error (-20002,'An error occurred. Message: ' || SQLERRM);
   END Prc_Save_VOD_Details;

   /*END*/

   /*Added by Khilesh on 19-Mar-2015 for Clearleap Release*/
/*Cursors for Language List and for Fields with Character length*/
   PROCEDURE x_prc_lang_list_n_field_limits (o_field_limits   OUT SYS_REFCURSOR,
                                             o_language_lists OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN o_field_limits FOR
         SELECT FIELD_NAME, MAX_CHAR_SIZE FROM x_vod_field_limits;

      OPEN o_language_lists FOR
           SELECT UID_LANG_ID, UID_LANG_DESC
             FROM x_uid_language
            WHERE NVL (uid_lang_is_catchup_vod, 'N') = 'Y'
         ORDER BY UID_LANG_ID;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         raise_application_error (-00001, 'Territory Already Present');
      WHEN OTHERS
      THEN
         raise_application_error (-20002, 'Error while inserting Territory');
   END x_prc_lang_list_n_field_limits;


PROCEDURE X_PRC_GET_SABC_COUNT (
                        I_TAP_BARCODE   IN      fid_tape.tap_barcode%TYPE,
                        O_COUNT         OUT     NUMBER)
   AS
   l_gen_refno number;
   BEGIN
      IF I_TAP_BARCODE IS NOT NULL
      THEN

        SELECT X_FUN_GEN_REFNO_OF_TAPE(I_TAP_BARCODE)
        INTO l_gen_refno
       FROM DUAL;

         IF I_TAP_BARCODE IS NOT NULL
         then
             select count(*)
             INTO O_COUNT
              from fid_license lic, fid_contract con, fid_company com
              where lic.lic_con_number = con.con_number
                  and con.con_com_number = com.com_number
                  and com.com_short_name = 'SABC'
                  and lic.lic_gen_refno = l_gen_refno;

                  --O_COUNT := 0;
         ELSE
             O_COUNT := 0;
         END IF;

      ELSE
         O_COUNT := 0;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         O_COUNT := 0;
   end X_PRC_GET_SABC_COUNT;


/*Function to get Given title is series or not*/
   FUNCTION X_FNC_PROG_IS_SER (I_GEN_REFNO NUMBER)
      RETURN VARCHAR2
   AS
      L_IS_SERIES   VARCHAR2 (1);
      l_prog_type   VARCHAR2 (20);
   BEGIN
      SELECT GEN_TYPE
        INTO L_PROG_TYPE
        FROM FID_GENERAL
       WHERE GEN_REFNO = I_GEN_REFNO;

      BEGIN
         SELECT cod_attr1
           INTO l_is_series
           FROM fid_code
          WHERE cod_type = 'GEN_TYPE'
            AND cod_value != 'HEADER'
            AND UPPER (cod_value) = UPPER (l_prog_type);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_is_series := 'N';
      END;

      RETURN L_IS_SERIES;
   END X_FNC_PROG_IS_SER;
/*END*/

-- for media ops CR -Nasreen Mulla
PROCEDURE x_prc_add_title_note
      (
        i_gen_refno      IN x_gen_notes.XGT_GEN_REFNO%TYPE,
        i_comment        IN x_gen_notes.XGT_COMMENT%TYPE,
        i_entry_operator IN x_gen_notes.XGT_ENTRY_OPER%TYPE,
        o_return_result out NUMBER
      )
    AS
      l_flag NUMBER;
    BEGIN
      o_return_result := -1;
      INSERT
      INTO x_gen_notes
        (
          XGT_ID,
          XGT_GEN_REFNO,
          XGT_COMMENT,
          XGT_ENTRY_OPER,
          XGT_ENTRY_DATE
        )
        VALUES
        (
          x_seq_GEN_NOTES.nextval,
          i_gen_refno,
          i_comment,
          i_entry_operator,
          SYSDATE
        );

      l_flag     := SQL%rowcount;
      IF ( l_flag > 0 ) THEN
        COMMIT;
        o_return_result := 1;
      ELSE
        ROLLBACK;
      END IF;
    exception
    WHEN others THEN
      ROLLBACK;
      raise_application_error (-20601, substr (sqlerrm, 1, 200));
    END x_prc_add_title_note;

    PROCEDURE x_prc_search_title_linkednotes
      (
        i_gen_refno IN fid_general.gen_refno%TYPE,
        o_details out sys_refcursor)
    IS
    BEGIN
      OPEN o_details FOR
    SELECT XGT_ID,XGT_COMMENT,XGT_ENTRY_OPER,XGT_ENTRY_DATE
    FROM x_gen_notes
    WHERE XGT_GEN_REFNO = i_gen_refno
    ORDER BY XGT_ENTRY_DATE DESC;
    END x_prc_search_title_linkednotes;
-- end media ops CR

-------------------------BR_15_178 Updatable Asset and Sub Title on reforming Broadcast Title-----------------------------------------------------------------------------------
    PROCEDURE x_prc_update_asset_title
      (
        i_gen_refno IN fid_general.gen_refno%TYPE,
        i_asset_title IN FID_GENERAL.GEN_TITLE_WORKING%TYPE,
        i_entry_opr IN FID_AUDIT.AUD_ENTRY_OPER%TYPE,
        o_details out NUMBER)
    IS
      temp                 NUMBER;
    BEGIN
      SELECT pkg_cm_username.setusername (i_entry_opr) INTO temp FROM DUAL;
      update fid_tape
      set TAP_TITLE = i_asset_title
          ,TAP_TITLE_SECOND = i_asset_title
      where tap_number in(select tap_number
                          from fid_tape
                              ,sgy_mn_lic_tape_cha_mapp
                        where  ltcm_tap_number=tap_number
                        and    ltcm_gen_refno = i_gen_refno
                        and    nvl(TAP_IS_UID,'N') ='Y'
                        UNION ALL
                        select tap_number
                          from sgy_mn_lic_tape_cha_mapp
                              ,Fid_License
                              ,Fid_Tape
                        where lic_number = ltcm_lic_number
                        and   lic_gen_refno = i_gen_refno
                        and   tap_number = ltcm_tap_number
                        and   nvl(TAP_IS_UID,'N') ='Y'
                        );
      O_DETAILS:=1;
      EXCEPTION WHEN OTHERS
      THEN
       O_DETAILS:=0;
       raise;
    END x_prc_update_asset_title;

    --anuja CU4ALL
PROCEDURE X_PRC_SAVE_VOD_HISTORY_CMNT
(
      i_PVDH_ID in number,
      i_gen_refno in number,
      i_comment in varchar2,
      i_user_name in varchar2,
      o_result  out number
)
AS
BEGIN
        o_result := 0;

        update X_PROG_VOD_DETAIL_HISTORY
        set PVDH_COMMENTS = i_comment,
            PVDH_modified_OPER = i_user_name,
            PVDH_modified_DATE = sysdate
          where   PVDH_ID = i_PVDH_ID;

         if sql%rowcount > 0
         THEN
               o_result := 1;
               commit;
          else
               o_result := -1;
          end if;

END X_PRC_SAVE_VOD_HISTORY_CMNT;

PROCEDURE PRC_SAVE_VOD_DETAILS_COLOR (
      i_PROG_uid_lang_id          IN      number,
      i_PROG_gen_refno            IN     number,
      i_PROG_gen_title            IN     VARCHAR2,
      i_PROG_pvr_title            IN     VARCHAR2,
      I_PROG_SHOW_TYPE            IN     VARCHAR2,
     -- i_PROG_themes               IN     VARCHAR2,
      --i_PROG_primary_genre        IN     VARCHAR2,
      --i_PROG_secondary_genre      IN     VARCHAR2,
      I_PROG_ACTORS               IN     VARCHAR2,
      i_PROG_directors            IN     VARCHAR2,
      I_PROG_TITLE_SYNOPSIS       IN     VARCHAR2,
     -- i_PROG_ser_title            IN     VARCHAR2,
      i_PROG_synopsis_ser         IN     VARCHAR2,
      I_PROG_SYNOPSIS             IN     VARCHAR2,
     -- i_PROG_afr_title_synopsis   IN     VARCHAR2,
     -- i_PROG_afr_synopsis_ser     IN     VARCHAR2,
    --  i_PROG_afr_synopsis         IN     VARCHAR2,*/
      I_PROG_ENTRY_OPER           IN     VARCHAR2,
      o_sucess_flag              OUT    NUMBER)
  as

  begin

  o_sucess_flag := 0;

  delete from X_PROG_VOD_TAB_COLOR where pvtc_uid_lang_id = i_PROG_uid_lang_id and pvtc_gen_refno = i_PROG_gen_refno;

   INSERT INTO X_PROG_VOD_TAB_COLOR
  (
       PVTC_UID_LANG_ID
      ,PVTC_GEN_REFNO
      ,PVTC_GEN_TITLE
      ,PVTC_PVR_TITLE
      ,PVTC_SHOW_TYPE
      ,PVTC_ACTORS
      ,PVTC_DIRECTORS
      ,PVTC_TITLE_SYNOPSIS
      ,PVTC_SYNOPSIS_SER
      ,PVTC_SYNOPSIS
      ,PVTC_ENTRY_OPER
      ,PVTC_ENTRY_DATE
  )
  VALUES(
       I_PROG_UID_LANG_ID,
       i_PROG_gen_refno,
       I_PROG_GEN_TITLE,
       I_PROG_PVR_TITLE,
       I_PROG_SHOW_TYPE,
       I_PROG_ACTORS,
       I_PROG_DIRECTORS,
       I_PROG_TITLE_SYNOPSIS,
       I_PROG_SYNOPSIS_SER,
       I_PROG_SYNOPSIS,
       I_PROG_ENTRY_OPER,
       SYSDATE
      );

  /*INSERT INTO X_PROG_VOD_TAB_COLOR
  (
       PVTC_UID_LANG_ID
      ,PVTC_GEN_REFNO
      ,PVTC_GEN_TITLE
      ,PVTC_PVR_TITLE
      ,PVTC_SHOW_TYPE
      --,PVTC_THEMES
     -- ,PVTC_PRIMARY_GENRE
     -- ,PVTC_SECONDARY_GENRE
      ,PVTC_ACTORS
      ,PVTC_DIRECTORS
      ,PVTC_TITLE_SYNOPSIS
      --,PVTC_SER_TITLE
      ,PVTC_SYNOPSIS_SER
      ,PVTC_SYNOPSIS
      --,PVTC_AFR_TITLE_SYNOPSIS
      --,PVTC_AFR_SYNOPSIS_SER
      --,PVTC_AFR_SYNOPSIS
      ,PVTC_ENTRY_OPER
      ,PVTC_ENTRY_DATE
  )
  VALUES(
      I_PROG_UID_LANG_ID,
      i_PROG_gen_refno,
      (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_GEN_TITLE),
      (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_PVR_TITLE),
      (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_SHOW_TYPE),
      --(SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_THEMES),
     -- (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_PRIMARY_GENRE),
      --(SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_SECONDARY_GENRE),
      (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_ACTORS),
      (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_DIRECTORS),
      (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_TITLE_SYNOPSIS),
     -- (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_SER_TITLE),
      (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_SYNOPSIS_SER),
      (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_SYNOPSIS),
     -- (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_AFR_TITLE_SYNOPSIS),
     -- (SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_AFR_SYNOPSIS_SER),
      --(SELECT PVCD_RGB_VALUE FROM X_PROG_VOD_COLOR_DETAILS WHERE PVCD_COLOR_NAME = I_PROG_AFR_SYNOPSIS),
      I_PROG_ENTRY_OPER,
      SYSDATE
      );*/

  o_sucess_flag := 1;
  COMMIT;


  EXCEPTION
  WHEN OTHERS THEN
    o_sucess_flag := -1;
  raise_application_error(-20199,substr(sqlerrm,1,200));

  end PRC_SAVE_VOD_DETAILS_COLOR;

	--Pravin_20160413[BR_15_168] - Added New procedure to Get and Save the Waive Holdback data [Start]
	PROCEDURE X_PRC_SAVE_WAVE_HOLDBACK_DATA
	(
		I_GEN_REFNO 	IN  FID_GENERAL.GEN_REFNO%TYPE,
		I_Wh_number 	IN  X_Waive_Holdback.Wh_number%TYPE,
		I_PLATFORM		IN	SGY_PB_MEDIA_SERVICE.MS_MEDIA_SERVICE_CODE%TYPE,
		I_WINDOW_START	IN	X_Waive_Holdback.Wh_Window_Start%TYPE,
		I_WINDOW_END	IN	X_Waive_Holdback.Wh_Window_End%TYPE,
		I_Comment		IN	X_Waive_Holdback.Wh_Comment%TYPE,
		I_OPERATION		IN	VARCHAR2,
		I_USER			IN	VARCHAR2,
		O_SUCCESS		OUT NUMBER
	)
	AS
		l_number number;
	BEGIN
		O_SUCCESS := 0;
		IF I_OPERATION = 'I'
		then
			l_number := seq_waive_holdback.nextval;
			insert into X_Waive_Holdback
						(
							Wh_number
							,Wh_Gen_RefNo
							,Wh_Platform
							,Wh_Window_Start
							,Wh_Window_End
							,Wh_Comment
							,WH_ENTRY_OPERATOR
							,WH_ENTRY_DATE
						)
				values	(
							l_number
							,I_GEN_REFNO
							,I_PLATFORM
							,I_WINDOW_START
							,I_WINDOW_END
							,I_Comment
							,I_USER
							,SYSDATE
						);
			O_SUCCESS := l_number;
		elsif I_OPERATION = 'U'
		then
			update X_Waive_Holdback
			set	Wh_Platform = I_PLATFORM,
				Wh_Window_Start = I_WINDOW_START,
				Wh_Window_End = I_WINDOW_END,
				Wh_Comment = I_Comment,
				WH_MODIFY_BY = I_USER,
				WH_MODIFY_DATE = SYSDATE
			where Wh_Gen_RefNo = I_GEN_REFNO
			and wh_number = I_Wh_number;
			O_SUCCESS := I_Wh_number;
		else
			delete from X_Waive_Holdback
			where Wh_Gen_RefNo = I_GEN_REFNO
			and wh_number = I_Wh_number;
			O_SUCCESS := I_Wh_number;
		end if;
	END X_PRC_SAVE_WAVE_HOLDBACK_DATA;

	PROCEDURE X_PRC_GET_WAVE_HOLDBACK_DATA
	(
		I_GEN_REFNO 	IN  FID_GENERAL.GEN_REFNO%TYPE,
		o_details 		out sys_refcursor
	)
	AS
	BEGIN
	OPEN o_details
	FOR
		SELECT 	Wh_number
				,Wh_Gen_RefNo
				,Wh_Platform
				,Wh_Window_Start
				,Wh_Window_End
				,Wh_Comment
		FROM X_Waive_Holdback
		where Wh_Gen_RefNo = I_GEN_REFNO;

	END X_PRC_GET_WAVE_HOLDBACK_DATA;
	--Pravin[BR_15_168] - Added New procedure to Get and save the Waive Holdback data [End]
  --Vikas_20160615[BR_15_355_UC_CE and CD Version automation_v1] - Added New procedure to Get and Save the edit list customization data [Start]
  PROCEDURE X_PRC_SAVE_EDIT_LIST_CSTMZTN
	(
		I_tap_barcode 	IN  fid_tape.tap_barcode %TYPE,
		I_gen_refno 	IN  fid_general.gen_refno%TYPE,
		I_SNO           IN  NUMBER,
		is_applied_OtherVersion IN VARCHAR2,
		i_group    IN  x_cont_version.ver_group%TYPE,
    I_elc_id        IN  X_EDIT_LIST_CUSTOMIZATION.elc_id%TYPE,
		I_comments		IN	X_EDIT_LIST_CUSTOMIZATION.elc_Comments%TYPE,
		I_timecode_in	IN	X_EDIT_LIST_CUSTOMIZATION.elc_timecode_in%TYPE,
		I_timecode_out	IN	X_EDIT_LIST_CUSTOMIZATION.elc_timecode_out%TYPE,
		I_duration      IN  X_EDIT_LIST_CUSTOMIZATION.elc_duration%type,
		I_operation     IN  VARCHAR2,
    I_Is_First_Record in varchar2,
		O_SUCCESS		    OUT NUMBER
	)
	AS
	 l_number NUMBER;
	 l_ver_id number;
   l_ver_group VARCHAR2(20);
   l_tap_uid_version varchar2(20);
   BEGIN
	    O_SUCCESS := 0;

	  IF I_operation = 'I' AND is_applied_OtherVersion = 'Y'
        THEN
        DELETE FROM X_EDIT_LIST_CUSTOMIZATION
        WHERE elc_gen_refno = i_gen_refno
        and elc_version_group = i_group AND I_Is_First_Record ='Y';
		 FOR l_records IN  (SELECT tap_barcode, ver_id, ver_group,tap_uid_version,tap_type
                            FROM fid_pro_tap_vw JOIN x_cont_version
                         ON tap_uid_version = ver_name
                         WHERE pro_gen_refno = i_gen_refno
                         AND ver_group = i_group
                          UNION
                        SELECT tap_barcode, ver_id, ver_group,tap_uid_version,tap_type
                             FROM sgy_mn_lic_tape_cha_mapp, fid_general, fid_tape JOIN x_cont_version
                         ON ver_name = tap_uid_version
                         WHERE     ltcm_gen_refno = gen_refno
                         AND tap_number = ltcm_tap_number
                         AND gen_refno = i_gen_refno
                         AND ver_group = i_group)
         LOOP
          l_number := seq_edit_list_customization.nextval;
		     insert into X_EDIT_LIST_CUSTOMIZATION
						    (
                  elc_id
                 ,elc_SNO
							   ,elc_tap_barcode
							   ,elc_gen_refno
							   ,elc_Comments
							   ,elc_timecode_in
							   ,elc_timecode_out
							   ,elc_duration
							   ,elc_version_number
                 ,elc_version_name
                 ,elc_version_group
						    )
            values
               (
                l_number
                ,I_SNO
                ,l_records.tap_barcode
                ,I_gen_refno
							  ,I_comments
							  ,I_timecode_in
							  ,I_timecode_out
							  ,I_duration
							  ,l_records.ver_id
                ,l_records.tap_uid_version
                ,l_records.ver_group
						  );
      END LOOP;

      ELSIF I_operation = 'I' AND is_applied_OtherVersion <> 'Y'
       THEN
       DELETE FROM X_EDIT_LIST_CUSTOMIZATION
        WHERE elc_gen_refno = i_gen_refno
        and elc_tap_barcode = i_tap_barcode and I_Is_First_Record='Y';
        SELECT ver_id,ver_group,tap_uid_version
            INTO l_ver_id,l_ver_group,l_tap_uid_version
          FROM (SELECT tap_barcode, ver_id, ver_group,tap_uid_version
                   FROM fid_pro_tap_vw JOIN x_cont_version
                  ON tap_uid_version = ver_name
                  WHERE pro_gen_refno = i_gen_refno
                  AND tap_barcode = I_tap_barcode
                  AND ver_group = i_group
                    UNION
                SELECT tap_barcode, ver_id, ver_group,tap_uid_version
                   FROM sgy_mn_lic_tape_cha_mapp, fid_general, fid_tape JOIN x_cont_version
                ON ver_name = tap_uid_version
               WHERE     ltcm_gen_refno = gen_refno
               AND tap_number = ltcm_tap_number
               AND gen_refno = i_gen_refno
               AND ver_group = i_group
               AND tap_barcode = I_tap_barcode);

         l_number := seq_edit_list_customization.nextval;
		     insert into X_EDIT_LIST_CUSTOMIZATION
						    (
                  elc_id
                 ,elc_SNO
							   ,elc_tap_barcode
							   ,elc_gen_refno
							   ,elc_Comments
							   ,elc_timecode_in
							   ,elc_timecode_out
							   ,elc_duration
                 ,elc_version_number
                 ,elc_version_name
                 ,elc_version_group
						    )
			   values
              (
                l_number
                ,I_SNO
                ,I_tap_barcode
							  ,I_gen_refno
							  ,I_comments
							  ,I_timecode_in
							  ,I_timecode_out
							  ,I_duration
                ,l_ver_id
                ,l_tap_uid_version
                ,l_ver_group
						  );
      ELSIF I_operation = 'D' AND is_applied_OtherVersion = 'Y'
       THEN
	       DELETE FROM X_EDIT_LIST_CUSTOMIZATION
			     WHERE elc_gen_refno = I_gen_refno
           AND elc_version_group = i_group;

       ELSIF  I_operation = 'D' AND is_applied_OtherVersion <> 'Y'
        THEN
         DELETE FROM X_EDIT_LIST_CUSTOMIZATION
			     WHERE elc_gen_refno = I_gen_refno
           AND elc_tap_barcode = i_tap_barcode;
	 END IF;
      COMMIT;
    	O_SUCCESS := 1;
    EXCEPTION
      WHEN OTHERS
      THEN
         O_SUCCESS := -1;
         raise_application_error (-20002,'An error occurred. Message: ' || SQLERRM);

END X_PRC_SAVE_EDIT_LIST_CSTMZTN;
 --Vikas_20160615[BR_15_355_UC_CE and CD Version automation_v1] - Added New procedure to Get and Save the edit list customization data [Start]
 PROCEDURE X_PRC_GET_EDIT_LIST_CSTMZTN
	(
		i_gen_refno     IN  FID_GENERAL.GEN_REFNO%TYPE,
    i_tap_barcode   IN  FID_TAPE.TAP_BARCODE%TYPE,
		o_editlist_details OUT sys_refcursor,
    o_frm_barcode      OUT sys_refcursor
	)
	AS
	BEGIN
	OPEN o_editlist_details
    FOR
                      SELECT elc_sno,
                             elc_id,
                             elc_tap_barcode,
                             elc_gen_refno,
                             elc_comments,
                             elc_timecode_in,
                             elc_timecode_out,
                             elc_duration
                       FROM x_edit_list_customization
                      WHERE elc_gen_refno =	i_gen_refno
                      AND   elc_tap_barcode = i_tap_barcode;
   OPEN o_frm_barcode
     FOR
                  SELECT  NVL (tap_uid_version, tap_type) tap_type,            --tap_type
                          tap_barcode AS FRM_Barcode
                    FROM fid_pro_tap_vw
                  WHERE pro_gen_refno = i_gen_refno
                  AND tap_type = 'FRM' and rownum=1
                    UNION
                 SELECT NVL (tap_uid_version, tap_type) tap_type,            --tap_type                                         ,
                        tap_barcode AS FRM_Barcode
                   FROM sgy_mn_lic_tape_cha_mapp, fid_general, fid_tape
                WHERE     ltcm_gen_refno = gen_refno
                AND tap_number = ltcm_tap_number
                AND gen_refno = i_gen_refno
                and tap_type='FRM';

	END X_PRC_GET_EDIT_LIST_CSTMZTN;

  --Vikas_20160615[BR_15_355_UC_CE and CD Version automation_v1] - Added New procedure to Get and Save the edit list customization data [Start]
  PROCEDURE     X_PRC_SEND_WORKORDER_EMAIL( i_gen_refno in number,
                                            i_tap_barcode_list varchar2,
                                            i_user_id in varchar2,
                                            O_SUCCESS out number

  )
 AS
      L_MAIL_CONN     UTL_SMTP.CONNECTION;
      L_SMTP_SERVER   varchar2 (100);
      l_recipient     VARCHAR2 (6000);
      L_MAILFROM      varchar2 (1000);
      O_SUCESS        number;
      o_send_to_process  number;
      arr_email       email_ary_big       := email_ary_big (6000);
     -- l_body          VARCHAR2(2000);
      p_html_msg      CLOB;
      l_html          CLOB;
      L_SUBJECT       varchar2(5000) := 'Work Order generated for programme ';
      l_mailfrom_user  varchar2(5000);
      l_usr_name    varchar2(5000);
      l_tap_title    VARCHAR2(200);
      l_tap_frm_number     varchar2(100);
      l_tap_barcode  varchar2(100);
      l_min_sch_date       varchar2(50);
      L_To_Recipient VARCHAR2 (10000);
      L_MAIL_BODY varchar2(32767);

begin

     o_sucess :=0;
      SELECT "Content"
        INTO l_smtp_server
        FROM fwk_appparameter
       WHERE KEY = 'SMTPServer';


        L_To_Recipient:='Zithulele.Dhladhla@mnet.co.za,Mpho.Nemakonde@mnet.co.za,Sandra.Geldenhuys@mnet.co.za,Oscar.Machaba@mnet.co.za,Nadine.Ackermann@mnet.co.za,Carmen.Bok@multichoice.co.za,Sonia.Raubenheimer@multichoice.co.za';

       --Changed as suggested by Shreyoshi 30_08_2016
       /* Begin
            SELECT LISTAGG(usr_email_id, ',')
            WITHIN GROUP (ORDER BY usr_email_id)
            into L_To_Recipient
            FROM men_user
            where usr_id in
            (
              select upper(substr(oaus.username,instr(oaus.username,'\')+1))
                from ORA_ASPNET_USERSINROLES oau,ORA_ASPNET_ROLES ora,ORA_ASPNET_USERS oaus
              where oau.roleid = ora.roleid
              and oaus.userid = oau.userid
              and ora.rolename in ('MEDIA_COORDINATOR','PROGACCEPTANCE')

            )
            and usr_email_id is not null;
            Exception
            When NO_DATA_FOUND
            then
                raise_application_error(-20601,'Please Configure Email Id');
        End;*/

        BEGIN
          IF i_tap_barcode_list IS NOT NULL
           THEN
            SELECT tap_title,
                   TAP_PARENT_UID_NUMBER
               INTO l_tap_title,
                    l_tap_frm_number
              FROM fid_tape
            WHERE tap_barcode IN (SELECT REGEXP_SUBSTR(i_tap_barcode_list, '[^,]+', 1, LEVEL) AS tap_barcode
              FROM dual
            CONNECT BY REGEXP_SUBSTR(i_tap_barcode_list, '[^,]+', 1, LEVEL) IS NOT NULL) and rownum=1;

            SELECT LISTAGG(tap_uid_version, ',') WITHIN GROUP (ORDER BY tap_uid_version)
              INTO l_tap_barcode
              FROM fid_tape
            WHERE tap_barcode in (SELECT REGEXP_SUBSTR(i_tap_barcode_list, '[^,]+', 1, LEVEL) AS tap_barcode
              FROM dual
            CONNECT BY REGEXP_SUBSTR(i_tap_barcode_list, '[^,]+', 1, LEVEL) IS NOT NULL);
            SELECT to_char(min(sch_date),'DD-MON-YYYY') INTO l_min_sch_date
             FROM fid_schedule
            WHERE sch_gen_refno=i_gen_refno and sch_date >=trunc(sysdate);
         END IF;
        END;


        IF L_To_Recipient is not null
        THEN
            l_recipient := L_To_Recipient ;
        END IF;


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

       l_mail_body := '
    <html>
    <head>
      <style>
      table, th, td {border: 1px solid black; border-collapse: collapse;}
      th, td { padding: 10px; }
      td ,B { font-size: 100%;}
      </style>
      </head>
      <body>
        <table border="1">
          <tr>
            <th><b>UID (TXMs)</b></th>
            <th><b>UID Type</b></th>
            <th><b>Status</b></th>
          </tr>';

     for i in
        (
           select tap_barcode,
                TAP_UID_VERSION,
                (SELECT uid_status
                FROM x_uid_status
                WHERE uid_status_id = tap_uid_status_id)status,
                TAP_UPDATE_COUNT
                FROM fid_tape
                where tap_barcode in (SELECT REGEXP_SUBSTR(i_tap_barcode_list, '[^,]+', 1, LEVEL) AS tap_barcode
                FROM dual
                CONNECT BY REGEXP_SUBSTR(i_tap_barcode_list, '[^,]+', 1, LEVEL) IS NOT NULL)

        )
        loop
      X_PKG_MM_CONTENTORDER.prc_cont_proc_send_to_process(i.tap_barcode,i_user_id,i.TAP_UPDATE_COUNT,o_send_to_process);
      l_mail_body := l_mail_body || '
          <tr>
            <td>' || i.tap_barcode || '</td>
            <td>' || i.TAP_UID_VERSION || '</td>
            <td>' || i.status || '</td>
          </tr>';
       END LOOP;
       l_mail_body := l_mail_body || '
        </table>
        </body>
			  </html>';

      if l_recipient is not null
      then
          l_mailfrom:= l_mailfrom_user;
          arr_email := GET_EMAIL_IDS(l_recipient, ',');
          l_mail_conn := UTL_SMTP.open_connection (l_smtp_server, 25);
          UTL_SMTP.helo (l_mail_conn, l_smtp_server);
          UTL_SMTP.MAIL (L_MAIL_CONN, L_MAILFROM);
         for i in 1 .. arr_email.count - 1
         loop
             utl_smtp.rcpt (l_mail_conn, '' || arr_email (i) || '' );
         END LOOP;

                        UTL_SMTP.open_data (l_mail_conn);

                        if L_To_Recipient is not null
                        Then
                          UTL_SMTP.write_data(l_mail_conn, 'To: ' || L_To_Recipient || UTL_TCP.crlf);
                        End If;
                        UTL_SMTP.write_data (l_mail_conn,
                                      'Subject:'
                                   || L_SUBJECT ||' '
                                   || l_tap_title
                                   || ' to create '|| l_tap_barcode||' versions'
                                   || UTL_TCP.crlf
                                  );
                        UTL_SMTP.write_data (l_mail_conn,
                                   'Content-Type: text/html' || UTL_TCP.crlf
                                  );
              UTL_SMTP.write_data (l_mail_conn, UTL_TCP.crlf || '');
              UTL_SMTP.write_data (l_mail_conn, 'Hi There, ');
              utl_smtp.write_data (l_mail_conn, ' <BR>');
              UTL_SMTP.write_data (l_mail_conn, '<BR>' || UTL_TCP.crlf);

              P_HTML_MSG := L_SUBJECT ||l_tap_title || ' to create '|| l_tap_barcode ||' versions. Kindly see the Edit List on UID Status screen
                               and do the required edit. <BR> <BR>
							   FRM to be used - '||l_tap_frm_number||' <BR>
							   TX date of programme - '||l_min_sch_date||' <BR><BR>
                 <b>UIDs- </b><br>'|| l_mail_body
                  ;



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
       O_SUCCESS :=o_send_to_process;
       commit;
     END IF;

   END X_PRC_SEND_WORKORDER_EMAIL;
  --[END]Vikas_20160615[BR_15_355_UC_CE and CD Version automation_v1] - Added New procedure to Get and Save the edit list customization data


-- Dev : BR_15_351_UC EPG Phase 1 : Start : [BR_15_351]_[Sushma KOmulla]_[2016/10/06]
Procedure x_prc_insert_synopsis
(
  i_gen_refno    IN  fid_general.gen_refno%type,
  i_sys_id       IN  synopsis_dtls, --Synopsis id
  i_sys_lang_id  IN  synopsis_dtls,
  i_sys_ver_name IN  synopsis_dtls_text,
  i_sys_desc     IN  synopsis_dtls_text,
  i_is_ser       IN  varchar2,
  i_syt_id       IN  synopsis_dtls, --Primary key of synopsis table
  i_entry_oper   IN  varchar2,
  O_status       OUT NUMBER
)
AS
v_lang_id        NUMBER;
v_ver_name       varchar2(50);
v_syn_text       Varchar2(1000);
v_syt_id         NUMBER;
l_synopsis_count NUMBER;
l_gen_refno      NUMBER;
l_ser_id         Varchar2(50);
l_is_ser          Varchar2(1);
l_insert_vod_flag  Varchar2(1);
is_first_synopsis   NUMBER;
l_old_synopsis      Varchar2(4000);
l_syn_number        number;
BEGIN
   O_status := 0;

  -- select concat_column(syt_id) INTO l_ser_id from fid_synopsis_type where syt_type in ('Epg Series Synopsis','Epg Season Synopsis');

  for i in i_sys_id.first..i_sys_id.last
  loop
     IF   i_sys_id(i) in (7,12) and i_is_ser = 'Y'
     THEN
        select gen_ser_number INTO l_gen_refno from fid_general where gen_refno = i_gen_refno ;
        l_is_ser := 'Y';
     ELSIF i_sys_id(i) in (11,13) and i_is_ser = 'Y'
     THEN
        select ser_parent_number
           INTO l_gen_refno
        from fid_series where ser_number =  ( select gen_ser_number
                                                                  from fid_general where gen_refno = i_gen_refno
                                                                );
        l_is_ser := 'Y';
     ELSE
        l_gen_refno := i_gen_refno;
        l_is_ser := 'N';
     END IF;

     v_lang_id := i_sys_lang_id(i);
     v_ver_name := i_sys_ver_name(i);
     v_syn_text := i_sys_desc(i);
     v_syt_id := i_syt_id(i);

     select count(1)
       INTo is_first_synopsis
     from fid_synopsis
     where syn_gen_refno = l_gen_refno
     and syn_syt_id = i_sys_id(i)
     and SYN_LANG_ID = v_lang_id;

     l_insert_vod_flag := case when is_first_synopsis = 0 then 'Y'  else 'N' end;


      IF v_syt_id = 0
      THEN
       BEGIN
         l_syn_number := x_seq_syn_id.nextval;

        INSERT INTO fid_synopsis (syn_gen_refno,
                                  syn_syt_id,
                                  syn_synopsis,
                                  syn_entry_oper,
                                  syn_entry_date,
                                  syn_id,
                                  SYN_IS_SER,
                                  SYN_LANG_ID,
                                  SYN_VER_NAME,
                                  SYN_QA_STATUS_ID
                                )
             VALUES (l_gen_refno,
                     i_sys_id(i),
                     v_syn_text,
                     i_entry_oper,
                     SYSDATE,
                     l_syn_number,
                     l_is_ser,
                     v_lang_id,
                     v_ver_name,
                     (select QASP_ID from x_epg_inv_QAStatus_priority where QASP_STATUS = 'Not Sent' )
                     )
                returning l_syn_number INTO O_status;
          EXCEPTION
          WHEN DUP_VAL_ON_INDEX
          THEN
            RAISE_APPLICATION_ERROR(-20201,'This combination already exists.');
          END;

           IF O_status > 0
           THEN
                x_prc_insert_update_vod_syn
                  (
                    i_gen_refno => l_gen_refno,
                    i_syn_id  => i_sys_id(i),
                    i_lang_id   => v_lang_id,
                    i_version_name  => v_ver_name,
                    i_synopsis      => v_syn_text,
                    i_old_epg_syn  => NULL,
                    i_entry_oper  => i_entry_oper,
                    i_is_ser     =>  l_is_ser,
                    i_insert_flag  => l_insert_vod_flag
                  );
            END IF;
      ELSE

        select syn_synopsis
           INTO l_old_synopsis
         from fid_synopsis where syn_id = v_syt_id;

         UPDATE fid_synopsis fs
               SET syn_synopsis =  v_syn_text,
                   syn_modified_by = i_entry_oper,
                   syn_modified_date = sysdate,
                   syn_update_count = syn_update_count + 1
             WHERE syn_id = v_syt_id
              returning syn_update_count INTO O_status;

            IF O_status > 0
            THEN
               x_prc_insert_update_vod_syn
                    (
                      i_gen_refno => l_gen_refno,
                      i_syn_id  => i_sys_id(i),
                      i_lang_id   => v_lang_id,
                      i_version_name  => v_ver_name,
                      i_synopsis      => v_syn_text,
                      i_old_epg_syn  => l_old_synopsis,
                      i_entry_oper  => i_entry_oper,
                      i_is_ser     =>  l_is_ser,
                      i_insert_flag  => l_insert_vod_flag
                    );
            END IF;
      END IF;
   END LOOP;

   O_Status := Sql%Rowcount;
   COMMIT;
/*EXCEPTION
WHEN others then
raise_application_error(-20201,SQLERRM);  */
END x_prc_insert_synopsis;

Procedure x_prc_get_syn_details
(
  i_gen_refno       IN  fid_general.gen_refno%type,
  i_cpy_frm_linear  IN  varchar2,--added for copy from linear flag to get the refresh data from synopsis
  O_title_syn       OUT sys_refcursor,
  O_season_syn      OUT sys_refcursor,
  O_series_syn      OUT sys_refcursor
)
AS
l_season_number   NUMBER;
l_ser_number      NUMBER;
BEGIN
  BEGIN
   select ser_number ,ser_parent_number
      INTO l_season_number,l_ser_number
     from fid_series
    where ser_number = (select distinct gen_ser_number from fid_general where gen_refno = i_gen_refno);
  EXCEPTION
  WHEN NO_data_found
  THEN
    l_season_number := 0 ;
    l_ser_number := 0;
  END;

    IF i_cpy_frm_linear = 'N'
    THEN
         OPEN O_title_syn for
          select  SYN_GEN_REFNO
                 ,SYN_SYT_ID "ID"
                 ,SYN_SYNOPSIS SYNOPSIS
                 ,(select uid_lang_id from x_uid_language where uid_epg_lang_id = SYN_LANG_ID ) SYN_LANG_ID
                 ,(select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) SYN_LANG_NAME
                 ,SYN_VER_NAME
                 ,0 prior_column
                 ,SYN_id
          from fid_Synopsis where syn_gen_refno = i_gen_refno
          and syn_syt_id = (select syt_id from fid_synopsis_type where SYT_TYPE = 'VOD EPG Synopsis')
          and  exists (select 1 from  X_UID_LANGUAGE where UID_EPG_LANG_ID = SYN_LANG_ID and NVL(UID_LANG_IS_CATCHUP_VOD,'N') = 'Y' )
          and not exists (select 1
                         from x_prog_vod_details,X_UID_LANGUAGE
                          where pvd_gen_refno = i_gen_refno
                          and UID_LANG_ID = PVD_UID_LANG_ID
                          and  UID_EPG_LANG_ID = SYN_LANG_ID
                          and  PVD_SYN_VERSION = SYN_VER_NAME)
          union all
          select  PVD_GEN_REFNO
                  ,null "ID"
                  ,PVD_TITLE_SYNOPSIS
                  ,PVD_UID_LANG_ID
                  ,(select UID_LANG_DESC from x_uid_language where UID_LANG_ID = PVD_UID_LANG_ID) SYN_LANG_NAME
                  ,PVD_SYN_VERSION
                  ,1 prior_column
                  ,NULL  SYN_id
          from x_prog_vod_details where pvd_gen_refno = i_gen_refno and PVD_TITLE_SYNOPSIS is not null
          order by prior_column desc, SYN_id;


        OPEN O_season_syn for
          select  SYN_GEN_REFNO
                 ,SYN_SYT_ID "ID"
                 ,SYN_SYNOPSIS SYNOPSIS
                 ,(select uid_lang_id from x_uid_language where uid_epg_lang_id = SYN_LANG_ID ) SYN_LANG_ID
                 ,(select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) SYN_LANG_NAME
                 ,SYN_VER_NAME
                 ,0 prior_column
                  ,SYN_id
          from fid_Synopsis where syn_gen_refno = l_season_number
          and syn_syt_id = (select syt_id from fid_synopsis_type where SYT_TYPE = 'VOD Season Synopsis')
          and  exists (select 1 from  X_UID_LANGUAGE where UID_EPG_LANG_ID = SYN_LANG_ID and NVL(UID_LANG_IS_CATCHUP_VOD,'N') = 'Y' )
           and not exists (select 1
                         from x_ser_vod_details,X_UID_LANGUAGE
                          where SVD_SER_NUMBER = l_season_number
                          and UID_LANG_ID = SVD_UID_LANG_ID
                          and  UID_EPG_LANG_ID = SYN_LANG_ID
                          and  SVD_SYN_VERSION = SYN_VER_NAME)
          union all
          select  SVD_SER_NUMBER
                  ,null "ID"
                  ,SVD_SYNOPSIS SYNOPSIS
                  ,SVD_UID_LANG_ID
                  ,(select UID_LANG_DESC from x_uid_language where UID_LANG_ID = SVD_UID_LANG_ID) SYN_LANG_NAME
                  ,SVD_SYN_VERSION
                  ,1 prior_column
                  ,null SYN_id
          from x_ser_vod_details where SVD_SER_NUMBER = l_season_number and SVD_SYNOPSIS is not null
          order by prior_column desc,SYN_id;

        OPEN O_series_syn for
          select  SYN_GEN_REFNO
                 ,SYN_SYT_ID "ID"
                 ,SYN_SYNOPSIS SYNOPSIS
                 ,(select uid_lang_id from x_uid_language where uid_epg_lang_id = SYN_LANG_ID ) SYN_LANG_ID
                 ,(select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) SYN_LANG_NAME
                 ,SYN_VER_NAME
                 ,0 prior_column
                 ,SYN_id
          from fid_Synopsis where syn_gen_refno = l_ser_number
          and syn_syt_id = (select syt_id from fid_synopsis_type where SYT_TYPE = 'VOD Series Synopsis')
          and  exists (select 1 from  X_UID_LANGUAGE where UID_EPG_LANG_ID = SYN_LANG_ID and NVL(UID_LANG_IS_CATCHUP_VOD,'N') = 'Y' )
          and not exists (select 1
                            from x_ser_vod_details,X_UID_LANGUAGE
                              where SVD_SER_NUMBER = l_ser_number
                              and UID_LANG_ID = SVD_UID_LANG_ID
                              and  UID_EPG_LANG_ID = SYN_LANG_ID
                              and  SVD_SYN_VERSION = SYN_VER_NAME)
          union all
          select  SVD_SER_NUMBER
                  ,null "ID"
                  ,SVD_SYNOPSIS SYNOPSIS
                  ,SVD_UID_LANG_ID
                  ,(select UID_LANG_DESC from x_uid_language where UID_LANG_ID = SVD_UID_LANG_ID) SYN_LANG_NAME
                  ,SVD_SYN_VERSION
                  ,1 prior_column
                  ,null SYN_id
          from x_ser_vod_details where SVD_SER_NUMBER = l_ser_number and SVD_SYNOPSIS is not null
          order by prior_column desc,SYN_id;
    ELSE
       OPEN O_title_syn for
         select a.*,case when rnk = 1 then 1 else 0 end prior_column
         from(
          select  SYN_GEN_REFNO
                 ,SYN_SYT_ID "ID"
                 ,SYN_SYNOPSIS SYNOPSIS
                 ,(select uid_lang_id from x_uid_language where uid_epg_lang_id = SYN_LANG_ID ) SYN_LANG_ID
                 ,(select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) SYN_LANG_NAME
                 ,SYN_VER_NAME
                 ,SYN_id
                 ,dense_rank() over( partition by SYN_LANG_ID order by syn_id desc,SYN_MODIFIED_DATE desc ) rnk
          from fid_Synopsis where syn_gen_refno = i_gen_refno
           and syn_syt_id = (select syt_id from fid_synopsis_type where SYT_TYPE = 'VOD EPG Synopsis')
           and  exists (select 1 from  X_UID_LANGUAGE where UID_EPG_LANG_ID = SYN_LANG_ID and NVL(UID_LANG_IS_CATCHUP_VOD,'N') = 'Y' )
           order by syn_id desc,SYN_MODIFIED_DATE desc ) a;

       OPEN O_season_syn for
        select a.*,case when rnk = 1 then 1 else 0 end prior_column
         from(
          select  SYN_GEN_REFNO
                 ,SYN_SYT_ID "ID"
                 ,SYN_SYNOPSIS SYNOPSIS
                 ,(select uid_lang_id from x_uid_language where uid_epg_lang_id = SYN_LANG_ID ) SYN_LANG_ID
                 ,(select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) SYN_LANG_NAME
                 ,SYN_VER_NAME
                 ,SYN_id
                 ,dense_rank() over( partition by SYN_LANG_ID order by syn_id desc,SYN_MODIFIED_DATE desc ) rnk
          from fid_Synopsis where syn_gen_refno = l_season_number
          and syn_syt_id = (select syt_id from fid_synopsis_type where SYT_TYPE = 'VOD Season Synopsis')
          and  exists (select 1 from  X_UID_LANGUAGE where UID_EPG_LANG_ID = SYN_LANG_ID and NVL(UID_LANG_IS_CATCHUP_VOD,'N') = 'Y' )
          order by syn_id desc,SYN_MODIFIED_DATE desc ) A ;

        OPEN O_series_syn for
        select a.*,case when rnk = 1 then 1 else 0 end prior_column
         from(
          select  SYN_GEN_REFNO
                 ,SYN_SYT_ID "ID"
                 ,SYN_SYNOPSIS SYNOPSIS
                 ,(select uid_lang_id from x_uid_language where uid_epg_lang_id = SYN_LANG_ID ) SYN_LANG_ID
                 ,(select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) SYN_LANG_NAME
                 ,SYN_VER_NAME
                 ,SYN_id
                 ,dense_rank() over( partition by SYN_LANG_ID order by syn_id desc,SYN_MODIFIED_DATE desc ) rnk
          from fid_Synopsis where syn_gen_refno = l_ser_number
          and syn_syt_id = (select syt_id from fid_synopsis_type where SYT_TYPE = 'VOD Series Synopsis')
          and  exists (select 1 from  X_UID_LANGUAGE where UID_EPG_LANG_ID = SYN_LANG_ID and NVL(UID_LANG_IS_CATCHUP_VOD,'N') = 'Y' )
          order by syn_id desc,SYN_MODIFIED_DATE desc ) A;
    END IF;

END x_prc_get_syn_details;

Procedure x_prc_get_update_dtls
(
  i_gen_refno       IN   fid_general.gen_refno%type,
  o_synopsi_dtls    OUT  sys_refcursor,
  o_vod_dtls        OUT  sys_refcursor,
  o_vod_title_syn   OUT  sys_refcursor,
  o_vod_season_syn  OUT  sys_refcursor,
  o_vod_ser_syn     OUT  sys_refcursor
)
AS
l_season_number   NUMBER;
l_ser_number      NUMBER;
BEGIN
  BEGIN
   select ser_number ,ser_parent_number
      INTO l_season_number,l_ser_number
     from fid_series
    where ser_number = (select distinct gen_ser_number from fid_general where gen_refno = i_gen_refno);
  EXCEPTION
  WHEN NO_data_found
  THEN
    l_season_number := 0 ;
    l_ser_number := 0;
  END;

     OPEN o_synopsi_dtls for
       SELECT   NVL (syn_syt_id, 1) ID,
                syn_synopsis synopsis,
                syn_ver_lang_id,
                (select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) syn_lang_name,
                SYN_LANG_ID,
                SYN_VER_NAME,
                SYN_ID,
                SYN_QA_STATUS_ID,
                (select QASP_STATUS from x_epg_inv_QAStatus_priority where QASP_ID = SYN_QA_STATUS_ID) qa_status,
                SYN_ENTRY_DATE,
                SYN_MODIFIED_DATE
           FROM fid_synopsis
          WHERE syn_gen_refno in ( i_gen_refno,l_season_number,l_ser_number);

     OPEn o_vod_dtls for
       SELECT VOD_DET.*,
                   PVTC_GEN_TITLE GEN_TITLE_COLOR,
                   PVTC_PVR_TITLE PVR_TITLE_COLOR,
                   PVTC_SHOW_TYPE SHOW_TYPE_COLOR,
                   PVTC_THEMES THEMES_COLOR,
                   PVTC_PRIMARY_GENRE PRIMARY_GENRE_COLOR,
                   PVTC_SECONDARY_GENRE SECONDARY_GENRE_COLOR,
                   PVTC_ACTORS ACTORS_COLOR,
                   PVTC_DIRECTORS DIRECTORS_COLOR,
                   PVTC_TITLE_SYNOPSIS TITLE_SYNOPSIS_COLOR,
                   PVTC_AFR_TITLE_SYNOPSIS AFR_TITLE_SYNOPSIS_COLOR,
                   PVTC_SYNOPSIS SYNOPSIS_SEA_COLOR,
                   PVTC_AFR_SYNOPSIS AFR_SYNOPSIS_SEA_COLOR,
                   PVTC_SYNOPSIS_SER SYNOPSIS_SER_COLOR,
                   PVTC_AFR_SYNOPSIS_SER AFR_SYNOPSIS_SER_COLOR,
                   pvtc_ser_title ser_title_color
            from ( SELECT  UID_LANG_ID,
                        (SELECT L.UID_LANG_DESC
                           FROM X_UID_LANGUAGE L
                          WHERE L.UID_LANG_ID = A.UID_LANG_ID)
                           UID_LANG,
                  PVD.PVD_GEN_REFNO,
                  PVD.PVD_GEN_TITLE,
                  PVD.PVD_PVR_TITLE,
                  decode(is_series_flag,'Y',SER.SVD_SHOW_TYPE,pvd.PVD_SHOW_TYPE)PVD_SHOW_TYPE,
                  decode(is_series_flag,'Y',SER.SVD_THEMES,pvd.PVD_THEMES)PVD_THEMES,
                  decode(is_series_flag,'Y',SER.SVD_PRIMARY_GENRE,pvd.PVD_PRIMARY_GENRE)PVD_PRIMARY_GENRE,
                  (CASE WHEN is_series_flag = 'Y'
                    THEN
                      rtrim((SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_VALUE || ','))
                      .EXTRACT('//text()'),
                      ',') CAS_NAME
                      FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
                      WHERE COD_TYPE = 'VOD_GENRE'
                      AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
                      AND D.GD_GEN_REFNO = ser.SVD_SER_NUMBER
                      AND D.GD_IS_SERIES_FLAG = 'Y'
                      AND D.GD_LANG_ID = pvd.PVD_UID_LANG_ID),
                      ',')
                  ELSE
                      rtrim((SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_VALUE || ','))
                      .EXTRACT('//text()'),
                      ',') CAS_NAME
                      FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
                      WHERE COD_TYPE = 'VOD_GENRE'
                      AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
                      AND D.GD_GEN_REFNO = pvd.PVD_GEN_REFNO
                      AND D.GD_LANG_ID = pvd.PVD_UID_LANG_ID),
                      ',')
                  END)PVD_SECONDARY_GENRE,
                  (CASE WHEN is_series_flag = 'Y'
                    THEN
                      rtrim((SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_ATTR1 || ','))
                      .EXTRACT('//text()'),
                      ',') CAS_NAME
                      FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
                      WHERE COD_TYPE = 'VOD_GENRE'
                      AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
                      AND D.GD_GEN_REFNO = ser.SVD_SER_NUMBER
                      AND D.GD_IS_SERIES_FLAG = 'Y'
                      AND D.GD_LANG_ID = pvd.PVD_UID_LANG_ID),
                      ',')
                  ELSE
                      rtrim((SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_ATTR1 || ','))
                      .EXTRACT('//text()'),
                      ',') CAS_NAME
                      FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
                      WHERE COD_TYPE = 'VOD_GENRE'
                      AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
                      AND D.GD_GEN_REFNO = pvd.PVD_GEN_REFNO
                      AND D.GD_LANG_ID = pvd.PVD_UID_LANG_ID),
                      ',')
                  END)PVD_SECONDARY_GENRE_CODE,
                  PVD.PVD_ACTORS,
                  PVD.PVD_DIRECTORS,
                  PVD_TITLE_SYNOPSIS,
                  PVD_AFR_TITLE_SYNOPSIS,
                  SEA.SVD_SYNOPSIS SVD_SYNOPSIS_SEA,
                  SEA.SVD_AFR_SYNOPSIS SVD_AFR_SYNOPSIS_SEA,
                  SER.SVD_SYNOPSIS SVD_SYNOPSIS_SER,
                  SER.SVD_AFR_SYNOPSIS SVD_AFR_SYNOPSIS_SER,
                  SER.SVD_SER_TITLE,
                  pvd.PVD_SYN_VERSION pvd_title_ver,
                  SEA.SVD_SYN_VERSION SVD_season_ver,
                  SER.SVD_SYN_VERSION SVD_series_ver
             FROM X_UID_LANGUAGE A,
                  (SELECT l.uid_lang_id PVD_UID_LANG_ID,
                          g.gen_refno PVD_GEN_REFNO,
                          PVD_GEN_TITLE,
                          PVD_PVR_TITLE,
                          PVD_SHOW_TYPE,
                          PVD_THEMES,
                          PVD_PRIMARY_GENRE,
                          PVD_SECONDARY_GENRE,
                          PVD_ACTORS,
                          PVD_DIRECTORS,
                          PVD_TITLE_SYNOPSIS,
                          PVD_AFR_TITLE_SYNOPSIS,
                          gen_ser_number,
                          nvl((	SELECT cod_attr1
                                FROM fid_code WHERE cod_type = 'GEN_TYPE'
                                AND cod_value != 'HEADER'
                                AND UPPER(cod_value) = UPPER(g.gen_type)
                          ),'N') is_series_flag,
                          PVD_SYN_VERSION --Added by sushma
                     FROM X_PROG_VOD_DETAILS, fid_general g, x_uid_language l
                    WHERE g.gen_refno = PVD_GEN_REFNO(+)
                          AND l.uid_lang_id =
                                 NVL (pvd_uid_lang_id, l.uid_lang_id)
                          AND NVL (UID_LANG_IS_CATCHUP_VOD, 'N') = 'Y'
                          AND g.gen_refno = i_gen_refno
                                                       ) PVD,
                  (SELECT svd_ser_number,
                          SVD_SYNOPSIS SVD_SYNOPSIS,
                          SVD_AFR_SYNOPSIS SVD_AFR_SYNOPSIS,
                          SVD_UID_LANG_ID,
                          SVD_SYN_VERSION --Added by sushma
                     FROM X_SER_VOD_DETAILS
                    WHERE SVD_SER_NUMBER = l_season_number
                                                           ) SEA,
                  (SELECT svd_ser_number,
                          SVD_SER_TITLE,
                          SVD_SYNOPSIS,
                          SVD_AFR_SYNOPSIS,
                          SVD_UID_LANG_ID,
                          SVD_THEMES,
                          SVD_PRIMARY_GENRE,
                          SVD_SHOW_TYPE,
                          SVD_SYN_VERSION --Added by sushma
                     FROM X_SER_VOD_DETAILS
                    WHERE SVD_SER_NUMBER = l_ser_number
                                                              ) SER
            WHERE     NVL (A.UID_LANG_IS_CATCHUP_VOD, 'N') = 'Y'
                  AND UID_LANG_ID = PVD_UID_LANG_ID(+)
                  AND UID_LANG_ID = SEA.SVD_UID_LANG_ID(+)
                  AND UID_LANG_ID = SER.SVD_UID_LANG_ID(+)
                  ) VOD_DET  ,
                  /*CU4ALL START : [ANUJA SHINDE]_[09/01/2016]*/
                  X_PROG_VOD_TAB_COLOR VOD_COLOR
            WHERE PVD_GEN_REFNO = PVTC_GEN_REFNO(+)
              and UID_LANG_ID = pvtc_uid_lang_id(+)
         ORDER BY UID_LANG_ID;

      OPEN o_vod_title_syn for
          select  SYN_GEN_REFNO
                 ,SYN_SYT_ID "ID"
                 ,SYN_SYNOPSIS SYNOPSIS
                 ,(select uid_lang_id from x_uid_language where uid_epg_lang_id = SYN_LANG_ID ) SYN_LANG_ID
                 ,(select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) SYN_LANG_NAME
                 ,SYN_VER_NAME
                 ,0 prior_column
                 ,SYN_id
          from fid_Synopsis where syn_gen_refno = i_gen_refno
          and syn_syt_id = (select syt_id from fid_synopsis_type where SYT_TYPE = 'VOD EPG Synopsis')
          and  exists (select 1 from  X_UID_LANGUAGE where UID_EPG_LANG_ID = SYN_LANG_ID and NVL(UID_LANG_IS_CATCHUP_VOD,'N') = 'Y' )
          and not exists (select 1
                         from x_prog_vod_details,X_UID_LANGUAGE
                          where pvd_gen_refno = i_gen_refno
                          and UID_LANG_ID = PVD_UID_LANG_ID
                          and  UID_EPG_LANG_ID = SYN_LANG_ID
                          and  PVD_SYN_VERSION = SYN_VER_NAME)
          union all
          select  PVD_GEN_REFNO
                  ,null "ID"
                  ,PVD_TITLE_SYNOPSIS
                  ,PVD_UID_LANG_ID
                  ,(select UID_LANG_DESC from x_uid_language where UID_LANG_ID = PVD_UID_LANG_ID) SYN_LANG_NAME
                  ,PVD_SYN_VERSION
                  ,1 prior_column
                  ,NULL  SYN_id
          from x_prog_vod_details where pvd_gen_refno = i_gen_refno and PVD_TITLE_SYNOPSIS is not null
          order by prior_column desc, SYN_id;


  OPEN o_vod_season_syn for
    select  SYN_GEN_REFNO
           ,SYN_SYT_ID "ID"
           ,SYN_SYNOPSIS SYNOPSIS
           ,(select uid_lang_id from x_uid_language where uid_epg_lang_id = SYN_LANG_ID ) SYN_LANG_ID
           ,(select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) SYN_LANG_NAME
           ,SYN_VER_NAME
           ,0 prior_column
            ,SYN_id
    from fid_Synopsis where syn_gen_refno = l_season_number
    and syn_syt_id = (select syt_id from fid_synopsis_type where SYT_TYPE = 'VOD Season Synopsis')
    and  exists (select 1 from  X_UID_LANGUAGE where UID_EPG_LANG_ID = SYN_LANG_ID and NVL(UID_LANG_IS_CATCHUP_VOD,'N') = 'Y' )
     and not exists (select 1
                   from x_ser_vod_details,X_UID_LANGUAGE
                    where SVD_SER_NUMBER = l_season_number
                    and UID_LANG_ID = SVD_UID_LANG_ID
                    and  UID_EPG_LANG_ID = SYN_LANG_ID
                    and  SVD_SYN_VERSION = SYN_VER_NAME)
    union all
    select  SVD_SER_NUMBER
            ,null "ID"
            ,SVD_SYNOPSIS SYNOPSIS
            ,SVD_UID_LANG_ID
            ,(select UID_LANG_DESC from x_uid_language where UID_LANG_ID = SVD_UID_LANG_ID) SYN_LANG_NAME
            ,SVD_SYN_VERSION
            ,1 prior_column
            ,null SYN_id
    from x_ser_vod_details where SVD_SER_NUMBER = l_season_number and SVD_SYNOPSIS is not null
    order by prior_column desc,SYN_id;

  OPEN o_vod_ser_syn for
    select  SYN_GEN_REFNO
           ,SYN_SYT_ID "ID"
           ,SYN_SYNOPSIS SYNOPSIS
           ,(select uid_lang_id from x_uid_language where uid_epg_lang_id = SYN_LANG_ID ) SYN_LANG_ID
           ,(select LANG_NAME from X_TBL_MM_LANGUAGES where LANG_ID = SYN_LANG_ID) SYN_LANG_NAME
           ,SYN_VER_NAME
           ,0 prior_column
           ,SYN_id
    from fid_Synopsis where syn_gen_refno = l_ser_number
    and syn_syt_id = (select syt_id from fid_synopsis_type where SYT_TYPE = 'VOD Series Synopsis')
    and  exists (select 1 from  X_UID_LANGUAGE where UID_EPG_LANG_ID = SYN_LANG_ID and NVL(UID_LANG_IS_CATCHUP_VOD,'N') = 'Y' )
    and not exists (select 1
                      from x_ser_vod_details,X_UID_LANGUAGE
                        where SVD_SER_NUMBER = l_ser_number
                        and UID_LANG_ID = SVD_UID_LANG_ID
                        and  UID_EPG_LANG_ID = SYN_LANG_ID
                        and  SVD_SYN_VERSION = SYN_VER_NAME)
    union all
    select  SVD_SER_NUMBER
            ,null "ID"
            ,SVD_SYNOPSIS SYNOPSIS
            ,SVD_UID_LANG_ID
            ,(select UID_LANG_DESC from x_uid_language where UID_LANG_ID = SVD_UID_LANG_ID) SYN_LANG_NAME
            ,SVD_SYN_VERSION
            ,1 prior_column
            ,null SYN_id
    from x_ser_vod_details where SVD_SER_NUMBER = l_ser_number and SVD_SYNOPSIS is not null
    order by prior_column desc,SYN_id;


END x_prc_get_update_dtls;

-- Dev : BR_15_351_UC EPG Phase 1 : END

END PKG_MM_MNET_PL_PRGMAINTENANCE;
/