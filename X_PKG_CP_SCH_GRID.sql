CREATE OR REPLACE PACKAGE            "X_PKG_CP_SCH_GRID"
AS
   /****************************************************************
   REM Module           : Common
   REM Client           : MNET
   REM File Name        : X_PKG_CP_SCH_GRID.sql
   REM Form Name        : CatchUp Schedule Grid
   REM Purpose          : CatchUp Schedule Grid Screen Working
   REM Author           : Devashish Raverkar
   REM Creation Date    : 12 Jan 2015
   REM Type             : Database Package
   REM Change History   :
   ****************************************************************/

   TYPE x_cur_sch_grid IS REF CURSOR;

   TYPE t_in_list_tab IS TABLE OF VARCHAR2 (4000);
   l_error_message varchar2(200);

   /****************************************************************
   CatchUp Schedule Grid Search
   Note : 1) Only Premier Schedule condition is handeled on UI side
   ****************************************************************/
   PROCEDURE prc_schedule_grid_search (
      I_Sch_Month            IN     DATE,
      i_is_Include_Rec_Sch   IN     VARCHAR2,
      i_Content_Type         IN     VARCHAR2,
      I_IS_ONLY_PREMIER      in     varchar2,
      I_PROG_TITLE           in     FID_GENERAL.GEN_TITLE%type,
      i_Media_Devices        IN     NUMBER,
      i_Include_Blackout     IN     VARCHAR2,
      i_Region               IN     fid_licensee.lee_split_region%TYPE,
      i_media_service        IN     VARCHAR2,
      I_ENTRY_OPER           IN     VARCHAR2,
      --Dev.R1: CatchUp for All :[BR_15_235_ENH_Modify Schedule Metadata_v2 0]_[Milan Shah]_[2015/12/28]: Start
      I_SCH_STRT_PAST_MON    IN     VARCHAR2,
     I_PRIMARY_BOUQUET      IN     NUMBER,
      i_lee_number           in     number,
      --Dev.R1: CatchUp for All: End [Milan Shah]
      o_config_data          OUT    X_PKG_CP_SCH_GRID.x_cur_sch_grid,
      o_media_devices        OUT    X_PKG_CP_SCH_GRID.x_cur_sch_grid,
      o_sch_chk_data         OUT    X_PKG_CP_SCH_GRID.x_cur_sch_grid);

   /****************************************************************
   Open Month Check
   ****************************************************************/
   PROCEDURE PRC_is_SCHEDULE_CHECK (
      I_Sch_Month      IN     DATE,
      I_SPLIT_REGION   IN     fid_financial_month.fim_split_region%TYPE,
      o_config_data       OUT VARCHAR2);

   /****************************************************************
   CatchUp Device Rights
   ****************************************************************/
   PROCEDURE x_prc_lic_device_rights (
      I_Sch_Month            IN     DATE,
      i_is_Include_Rec_Sch   IN     VARCHAR2,
      i_Content_Type         IN     VARCHAR2,
      i_is_Only_Premier      IN     VARCHAR2,
      i_Prog_Title           IN     fid_general.gen_title%TYPE,
      i_Media_Devices        IN     NUMBER,
      i_Include_Blackout     IN     VARCHAR2,
      i_Region               IN     fid_licensee.lee_split_region%TYPE,
      i_media_service        IN     VARCHAR2,                                       --ver 1.0 added
      i_entry_oper           IN     VARCHAR2,                                       --ver 1.0 added
      o_dev_rights           OUT    X_PKG_CP_SCH_GRID.x_cur_sch_grid,
      o_compatibility        OUT    X_PKG_CP_SCH_GRID.x_cur_sch_grid,
      o_media_devices        OUT    X_PKG_CP_SCH_GRID.x_cur_sch_grid);

   /****************************************************************
   Delete License from Schedule Grid
   ****************************************************************/
   PROCEDURE x_prc_delete_lic_from_grid (i_lic_number   IN     NUMBER,
                                         i_sch_number   IN     NUMBER,
                                         i_bin_id       IN     NUMBER,
                                         i_reg_code     IN     NUMBER,
                                         i_entry_oper   IN     VARCHAR2,
                                         o_status          OUT NUMBER);

   /****************************************************************
   CatchUp Schedule License
   ****************************************************************/
   PROCEDURE x_prc_add_to_playlist (i_lic_number        IN     NUMBER,
                                    i_reg_code          IN     NUMBER,
                                    i_bin_id            IN     NUMBER,
                                    i_dev_ids           IN     VARCHAR2,
                                    i_scr_dev           IN     NUMBER,
                                    i_start_dates       IN     VARCHAR2,
                                    i_end_dates         IN     VARCHAR2,
                                    i_push_start_date   IN     DATE, -- Changes By Rashmi Tijare For CHP_CR3 PullVod
                                    i_pull_start_date   IN     DATE, -- Changes By Rashmi Tijare For CHP_CR3 PullVod
																		i_push_end_date   	IN     DATE, -- Changes By Devashish Raverkar
                                    i_pull_end_date   	IN     DATE, -- Changes By Devashish Raverkar
                                    I_UPDATE_COUNT      in     number,
                                    i_entry_oper        IN     VARCHAR2,
                                    --cu4all : start [ANUJA SHINDE]
                                    I_IS_DEVICE_CAP_CHECKED   IN VARCHAR2,
                                    i_Sch_Month    in     date,
                                    I_IS_GRID_DATE_MODIFIED IN VARCHAR2,
                                    --CU4ALL : END
                                    o_status               OUT NUMBER);

   /****************************************************************
   License Modification for TBA License
   ****************************************************************/
   PROCEDURE x_prc_modify_tba_cp_lic (i_lic_number   IN     NUMBER,
                                      i_bin_id       IN     NUMBER,
                                      i_start_date   IN     DATE,
                                      i_end_date     IN     DATE,
                                      o_status          OUT NUMBER);

   /****************************************************************
   Reversal of License Modification for TBA License
   ****************************************************************/
   PROCEDURE x_prc_modify_tba_cp_lic_no_sch (i_lic_number   IN     NUMBER,
                                             i_bin_id       IN     NUMBER,
                                             o_status          OUT NUMBER);

   /****************************************************************
   Function to get Schedule Start Date
   ****************************************************************/
   FUNCTION x_fnc_calc_start_date (i_lic_number                IN NUMBER,
                                   i_bin_id                IN NUMBER,
                                   i_dev_id                    IN NUMBER,
                                   i_sch_month                 IN DATE,
                                   i_premier_flag              IN VARCHAR2,
                                   i_lic_max_viewing_period    IN NUMBER,
                                   i_lic_sch_without_lin_ref   IN VARCHAR2,
                                   i_lic_budget_code           IN VARCHAR2,
                                   i_lic_gen_refno             IN NUMBER,
                                   i_lic_sch_bef_x_day         IN VARCHAR2,
                                   i_lic_sch_bef_x_day_value   IN NUMBER,
                                   i_lic_start                 IN DATE,
                                   i_lic_end                   IN DATE,
                                   i_sch_fin_actual_date       IN DATE,
                                   i_sch_time                  IN NUMBER,
                                   i_sch_end_time              IN NUMBER,
                                   i_cha_region_id             IN NUMBER,
                                   i_lic_period_tba            IN VARCHAR2,
                                   i_bin_view_start_date       IN DATE)
      RETURN VARCHAR2;

   /****************************************************************
   Function to get Schedule End Date
   ****************************************************************/
   FUNCTION x_fnc_calc_end_date (i_lic_number                IN NUMBER,
                                 i_bin_id                IN NUMBER,
                                 i_dev_id                    IN NUMBER,
                                 i_sch_month                 IN DATE,
                                 i_premier_flag              IN VARCHAR2,
                                 i_lic_max_viewing_period    IN NUMBER,
                                 i_lic_sch_without_lin_ref   IN VARCHAR2,
                                 i_lic_budget_code           IN VARCHAR2,
                                 i_lic_gen_refno             IN NUMBER,
                                 i_lic_sch_bef_x_day         IN VARCHAR2,
                                 i_lic_sch_bef_x_day_value   IN NUMBER,
                                 i_lic_start                 IN DATE,
                                 i_lic_end                   IN DATE,
                                 i_gen_duration_c            IN NUMBER,
                                 i_sch_fin_actual_date       IN DATE,
                                 i_sch_time                  IN NUMBER,
                                 i_sch_end_time              IN NUMBER,
                                 i_cha_region_id             IN NUMBER,
                                 i_lic_period_tba            IN VARCHAR2,
                                 i_bin_view_start_date       IN DATE,
                                 i_bin_view_end_date         IN DATE,
                                 i_sch_start_date_time       IN VARCHAR2)
      RETURN VARCHAR2;

   /****************************************************************
   Function to Check Validation
   ****************************************************************/
   FUNCTION x_fnc_lic_valid_check (i_lic_number           IN NUMBER,
                                   i_bin_id               IN NUMBER,
                                   i_plt_sch_start_date   IN DATE,
                                   i_plt_sch_end_date     IN DATE,
                                   i_dev_id               IN NUMBER,
                                   i_plt_entry_oper       IN VARCHAR2)
      RETURN NUMBER;

   /****************************************************************
   Function to Split String using Delimiter
   ****************************************************************/
   FUNCTION split_to_char (p_list VARCHAR2, p_del VARCHAR2 := ',')
      RETURN t_in_list_tab
      PIPELINED;

    /*Added by Swapnil Malvi on 13-Mar-2015 for Clearleap Release*/
   PROCEDURE x_prc_uid_list (i_lic_number    fid_license.lic_number%type,
                             o_uid_list  OUT SYS_REFCURSOR
                            );

   PROCEDURE x_prc_uid_terr_list (i_sbu_bin_id     IN  x_cp_sch_bin_uid.sbu_bin_id%TYPE,
                                  i_sbu_uid        IN  VARCHAR2,
                                  o_uid_list       OUT SYS_REFCURSOR,
                                  o_territory_list OUT SYS_REFCURSOR
                                 );

   PROCEDURE x_prc_insert_sch_bin_uid ( i_sbu_bin_id      IN  x_cp_sch_bin_uid.sbu_bin_id%TYPE,
                                        i_sbu_tap_barcode IN  VARCHAR2,
                                        o_sucess_flag     OUT NUMBER
                                      );

   PROCEDURE x_prc_insert_sch_bin_ter ( i_sbt_bin_id   IN  x_cp_sch_bin_territory.sbt_bin_id%TYPE,
                                        i_sbt_ter_code IN  VARCHAR2,
                                        i_sbt_lang_id  IN  x_cp_sch_bin_territory.sbt_lang_id%TYPE,
                                        i_sbt_uid      IN  VARCHAR2,
                                        o_sucess_flag  OUT NUMBER
                                      );

   /*Added by Swapnil Malvi on 23-Mar-2015 for Clearleap Release */
   PROCEDURE X_Prc_Save_VOD_Data (i_sch_cha_number IN  NUMBER,
                                  i_sch_date       IN  DATE,
                                  i_sch_time       IN  VARCHAR2,
                                  i_bin_id         IN  x_cp_sch_bin_uid.sbu_bin_id%TYPE,
                                  i_uid            IN  VARCHAR2,
                                  O_SUCESS_FLAG    OUT NUMBER
                                 );
/*END*/

--CU4ALL : START : [ANUJA_SHINDE] [06/01/2016]
PROCEDURE X_PRC_LOAD_TERR_BOUQUET_DATA
(
 I_BIN_ID in number,
 I_BIN_LIC_NUMBER IN NUMBER,
  i_dev_ids         IN      VARCHAR2,
     i_entry_oper      IN       VARCHAR2,
 O_TERR_DATA OUT SYS_REFCURSOR,
 O_PRIMARY_BOUQ_DATA OUT SYS_REFCURSOR,
 O_SUB_BOUQ_DATA          OUT SYS_REFCURSOR,
 O_MEDIA_DEV_DATA         OUT SYS_REFCURSOR,
 O_MEDIA_DEV_DATA_DEFAULT OUT SYS_REFCURSOR
 ,O_SUB_BOUQ_DATA_DEFAULT  OUT SYS_REFCURSOR
 ,O_COMP_RIGHTS_FOR_LIC    OUT SYS_REFCURSOR
 ,O_SUPERSTACK_AVAIL_DATES OUT SYS_REFCURSOR
);

PROCEDURE X_PRC_SAVE_TERR_BOUQUET_DATA (
  I_BIN_ID                 IN     NUMBER,
  I_BIN_LIC_NUMBER         IN     NUMBER,
  I_PLT_ID                 IN     NUMBER,
  I_TER_CODE               IN     VARCHAR2,
  I_TER_IE_FLAG            IN     VARCHAR2,
  I_BOUQ_ID                IN     NUMBER,
  I_BOUQ_RIGHTS_FLAG       IN     VARCHAR2,
  I_BOUQ_SUPER_STACK_RIGHTS IN    VARCHAR2,
  I_SUB_BOUQ_ID_LIST       IN     VARCHAR2,
  I_DEV_ID                 IN     NUMBER,
  I_DEVICE_RIGHTS_FLAG     IN     VARCHAR2,
  I_DEV_COMP_ID_LIST       in     varchar2,
  I_DEV_COMP_RIGHTS_LIST   in     varchar2,
  I_PVR_START_DATE         IN     DATE,
  I_PVR_END_DATE           in     date,
  I_OTT_START_DATE         IN     DATE,
  I_OTT_END_DATE           in     date,
  I_SCH_NOTES              IN     VARCHAR2,
  I_USER_MADE_CHANGES      IN     VARCHAR2,
  I_ENTRY_OPER             in     varchar2,
  I_UPDATE_COUNT           IN     NUMBER,
  O_MEDIA_DEV_DATA         OUT    NUMBER
  );

function X_GET_COMP_RIGHTS_FOR_DEV
(
  I_BIN_LIC_NUMBER in number,
  I_LIC_DEV_ID in number,
  I_MDC_ID in number
) return varchar2;

FUNCTION x_fun_get_CP_compat return varchar2;

PROCEDURE X_PRC_COPY_CONFIG_SEARCH (
      I_Sch_Month            IN     DATE,
      i_is_Include_Rec_Sch   IN     VARCHAR2,
      i_Content_Type         IN     VARCHAR2,
      i_is_Only_Premier      IN     VARCHAR2,
      i_Prog_Title           IN     fid_general.gen_title%TYPE,
      i_Media_Devices        IN     NUMBER,
      i_Include_Blackout     IN     VARCHAR2,
      i_Region               IN     fid_licensee.lee_split_region%TYPE,
      i_media_service        IN     VARCHAR2,
      I_ENTRY_OPER           IN     VARCHAR2,
      I_SCH_STRT_PAST_MON    IN     VARCHAR2,
      I_PRIMARY_BOUQUET      IN     NUMBER,
      i_lee_number           IN     NUMBER,
      o_config_data          OUT 	X_PKG_CP_SCH_GRID.x_cur_sch_grid);

PROCEDURE x_cp_prc_del_log;

PROCEDURE X_PRC_COPY_SCH
(
	I_LIC_NUMBER      		IN      	NUMBER,
  I_BIN_ID          		IN 	   	  	NUMBER,
	I_SRC_TER				      IN			VARCHAR2,
	I_DEST_TER				    IN			VARCHAR2,
	I_BOUQUET				      IN			VARCHAR2,
  I_User                IN        	Varchar2,
  O_RESULT              OUT      	NUMBER
) ;

PROCEDURE X_PRC_COPY_LOG_RPT
(
  I_SRC_TITLE       IN      VARCHAR2,
  I_MEDIA_SERVICE    IN      VARCHAR2,
  I_SCH_PLAN_MONTH  IN      DATE,
  O_LOG             OUT     SYS_REFCURSOR
);
PROCEDURE X_CP_COPY_SCH_CONFIG
(
    I_SRC_LIC_NUMBER      	IN      	NUMBER,
    I_SRC_BIN_ID          	IN 	   	  NUMBER,
    I_SRC_TITLE			      IN        VARCHAR2,
    I_DEST_LIC_NUMBER     IN       	NUMBER,
    I_DEST_BIN_ID     	  IN       	NUMBER,
    I_DEST_TITLE		      IN        VARCHAR2,
    i_Sch_Month		        IN        DATE,
    i_media_service		    IN        VARCHAR2,
    I_Region		          In        Varchar2,
    I_User                In        Varchar2,
    O_RESULT             OUT      	NUMBER
);
PROCEDURE X_CP_INSERT_VALIDATION
(
    I_SRC_LIC_NUMBER      IN      	NUMBER,
    I_SRC_TITLE			      IN        VARCHAR2,
    I_DEST_LIC_NUMBER     IN       	NUMBER,
    I_DEST_TITLE		      IN        VARCHAR2,
    i_Region		          IN        VARCHAR2,
    i_Sch_Month		        IN        DATE,
    I_STATUS              IN        varchar2,
    I_MESSAGE             IN        varchar2,
    I_User                In        Varchar2
);
--CU4ALL : END


--CU4ALL : START : ANUJA SHINDE
PROCEDURE X_PRC_SCHEDULE_ON_TERR_BOUQ (
          I_BIN_ID                 IN     NUMBER,
          I_BIN_LIC_NUMBER         IN     NUMBER,
          I_PLT_ID                 IN     NUMBER,
          I_DEV_ID                 IN     NUMBER,
          I_DEV_GRID_FLAG          IN     VARCHAR2,
          I_START_DATE             IN     DATE,
          I_END_DATE               IN     DATE,
          I_PUSH_START_DATE        IN     DATE,
          I_PULL_START_DATE        IN     DATE,
          I_PUSH_END_DATE   	     IN     DATE,
          i_pull_end_date   	     IN     DATE,
          I_START_TIME             IN     NUMBER,
          I_end_time               IN     NUMBER,
          I_ENTRY_OPER             IN     VARCHAR2,
          I_UPDATE_COUNT           IN     NUMBER
          );

PROCEDURE X_PRC_GET_SCHEDULED_DATA
(
I_BIN_ID                 IN     NUMBER,
I_BIN_LIC_NUMBER         IN     NUMBER,
O_SCH_DATA               OUT    X_PKG_CP_SCH_GRID.x_cur_sch_grid
);


 PROCEDURE X_PRC_UPDATE_SUPERSTACK_SCH
 (
          I_BIN_ID                 IN     NUMBER,
          I_BIN_LIC_NUMBER         IN     NUMBER,
          I_PLT_ID                 IN     NUMBER,
          I_DEV_ID                 IN     NUMBER,
          I_DEV_GRID_FLAG          IN     VARCHAR2,
          I_START_DATE             IN     DATE,
          I_END_DATE               IN     DATE,
          I_PUSH_START_DATE        IN     DATE,
          I_PULL_START_DATE        IN     DATE,
          I_PUSH_END_DATE   	     IN     DATE,
          i_pull_end_date   	     IN     DATE,
          I_START_TIME             IN     NUMBER,
          I_end_time               IN     NUMBER
  );
PROCEDURE x_prc_clr_temp_table_data
(
    i_lic_number      IN      NUMBER,
    i_bin_id          IN      NUMBER,
    i_dev_ids         IN      VARCHAR2,
    i_entry_oper      IN      varchar2
);

function X_FUN_GET_LIC_DELIEVERY_METHOD
(
I_DEV_ID in number,
i_lic_number in number
)RETURN VARCHAR2 ;
--CU4ALL : END
END X_PKG_CP_SCH_GRID;
/


CREATE OR REPLACE PACKAGE BODY            "X_PKG_CP_SCH_GRID"
AS
   /****************************************************************
   CatchUp Schedule Grid Search
   Note : 1) Only Premier Schedule condition is handeled on UI side
   ****************************************************************/
   /*-------------------------------------------------------------------------------------------------
      REVISIONS:
      Ver        Date          Author                  Description
      ---------  ----------    ---------------         --------------------------------------------------
      1.0           15-Jun-2015   Jawahar Garg                    [CATCHUP CR] New requirement.3rd Party Catchup CR.
                                                     Created 3rd Party catchup media service 'CATCHUP2'.
   --------------------------------------------------------------------------------------------------*/
   PROCEDURE PRC_SCHEDULE_GRID_SEARCH (
      I_Sch_Month            IN     DATE,
      i_is_Include_Rec_Sch   IN     VARCHAR2,
      i_Content_Type         IN     VARCHAR2,
      i_is_Only_Premier      IN     VARCHAR2,
      i_Prog_Title           IN     fid_general.gen_title%TYPE,
      i_Media_Devices        IN     NUMBER,
      i_Include_Blackout     IN     VARCHAR2,
      i_Region               IN     fid_licensee.lee_split_region%TYPE,
      i_media_service        IN     VARCHAR2,
      I_ENTRY_OPER           IN     VARCHAR2,
      --Dev.R1: CatchUp for All :[BR_15_235_ENH_Modify Schedule Metadata_v2 0]_[Milan Shah]_[2015/12/28]: Start
      I_SCH_STRT_PAST_MON    IN     VARCHAR2,
      I_PRIMARY_BOUQUET      IN     NUMBER,
      i_lee_number           IN     NUMBER,
      --Dev.R1: CatchUp for All: End [Milan Shah]
      O_CONFIG_DATA             OUT X_PKG_CP_SCH_GRID.X_CUR_SCH_GRID,
      O_MEDIA_DEVICES           OUT X_PKG_CP_SCH_GRID.X_CUR_SCH_GRID,
      O_SCH_CHK_DATA            OUT X_PKG_CP_SCH_GRID.X_CUR_SCH_GRID)
   AS
      L_LIC_QUERY              VARCHAR2 (30000) := '';
      l_schedule_query         VARCHAR2 (30000);
      l_fea_blackout_days      NUMBER;
      l_ser_blackout_days      NUMBER;
      l_content_type           VARCHAR2 (1);
      l_sch_start_date         DATE;
      l_sch_end_date           DATE;
      l_plan_year_mon          NUMBER;
      l_media_devices_list     VARCHAR2 (1000); -- Added by khilesh Chauhan 21 April 2015
      L_SCHEDULE_QUERY_PIVOT   VARCHAR2 (30000); -- Added by khilesh Chauhan 21 April 2015
      L_SCH_START              VARCHAR2 (1);
      L_lee_number             NUMBER;
      L_CU4ALL_LIVE_DATE       DATE;
      L_SCH_STRT_PAST_MON      VARCHAR2 (1) := 'Y';
   BEGIN
      BEGIN
         SELECT pa_black_out_period_movies, pa_black_out_period_ser
           INTO l_fea_blackout_days, l_ser_blackout_days
           FROM x_cp_planning_attributes;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_fea_blackout_days := 0;
            l_ser_blackout_days := 0;
      END;

      l_sch_start_date := TRUNC (I_Sch_Month, 'MONTH');
      l_sch_end_date := LAST_DAY (I_Sch_Month);

      l_plan_year_mon := TO_NUMBER (TO_CHAR (I_Sch_Month, 'RRRRMM'));

      IF UPPER (i_Content_Type) = 'FEA'
      THEN
         l_content_type := 'N';
      ELSIF UPPER (i_Content_Type) = 'SER'
      THEN
         l_content_type := 'Y';
      END IF;

      --Added by Milan Shah   CU4ALL
      SELECT "CONTENT"
        INTO L_CU4ALL_LIVE_DATE
        FROM X_FIN_CONFIGS
       WHERE "KEY" = 'CU4ALL_LIVE_DATE';

      IF TO_NUMBER (TO_CHAR (I_Sch_Month, 'RRRRMM')) = to_number(to_char(to_date(L_CU4ALL_LIVE_DATE,'DD-MON-RRRR'),'RRRRMM'))
      THEN
         L_SCH_STRT_PAST_MON := 'N';
      END IF;

      --ended by Milan Shah   CU4ALL
      --DBMS_OUTPUT.ENABLE(500000);

      l_lic_query :=
         'SELECT
      bin.bin_lic_number csg_lic_number,
      (select LEE_SHORT_NAME from fid_licensee where LEE_NUMBER =(SElect LIC_lee_number from fid_license WHERE lic_number = bin.bin_lic_number))LICENSEE, --Added by milan for CU4ALL
      bin.bin_sch_number csg_sch_number,
      fg.gen_title csg_gen_Title,
      (SELECT REG_CODE FROM FID_REGION WHERE REG_ID = bin.BIN_REG_CODE) CRS_REGION_CODE,
      fl.lic_end lic_end,
      fg.gen_type csg_gen_Type,
      fg.gen_release_year,
      --fg.gen_ser_number, -- Changes By Rashmi for Catchup Cr
      (SELECT ser_sea_number
       FROM fid_series
       WHERE ser_number = fg.gen_ser_number) ser_sea_number,
      fg.gen_running_order, -- Changes By Rashmi for Catchup Cr
      CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''Y''
           THEN (SELECT order_title
                 FROM fid_series
                 WHERE ser_number = fg.gen_ser_number)
      ELSE NULL
      END ser_title,
      fg.gen_epi_number,
      DECODE(x_fnc_get_prog_type(fl.lic_budget_code),''N'',''FEATURES'',''SERIES'') csg_content_type,
      fg.gen_duration_c csg_duration,
      fg.gen_category csg_pri_genre,
      (CASE WHEN bin.bin_reg_code = 1
            THEN fg.gen_rating_int
            WHEN bin.bin_reg_code = 2
            THEN fg.gen_rating_mpaa
      END) csg_age_restriction,
      to_char(bin.bin_view_start_date,''DD-MON-YYYY'') csg_sch_avail_date_from,
      to_char(bin.bin_view_end_date,''DD-MON-YYYY'') csg_sch_avail_date_to,
      fs.sch_lic_number csg_linear_lic
      /* CU4ALL - START : ANUJA SHINDE */
     ,( CASE WHEN
          (SELECT to_number(to_char(min(plt_sch_start_date),''RRRRMM'')) FROM X_CP_PLAY_LIST
          WHERE PLT_LIC_NUMBER=bin.BIN_LIC_NUMBER AND PLT_BIN_ID=BIN.BIN_ID)<(SELECT to_number(to_char(MAX((TO_DATE(LPAD(FIM_MONTH,''2'',''0'')||FIM_YEAR,''MMYYYY''))),''RRRRMM''))
                                        FROM FID_FINANCIAL_MONTH
                                        WHERE FIM_STATUS =''O''
                                        AND FIM_SPLIT_REGION = bin.bin_reg_code)
          THEN
          ''Y''
          ELSE
          ''N''
          END
        )IsScheduleInPastMonth,

      (SELECT (CASE WHEN BIN_SUPERSTACK_AVAIL_FROM IS NULL THEN ''N'' ELSE ''Y'' END)ISUPERTSTACK FROM X_cp_schedule_bin WHERE BIN_LIC_NUMBER =bin.bin_lic_number AND BIN_ID = bin.bin_id)IsSuperStackingLicense,
      --''Y'' IsSuperStackingLicense,
      (SELECT BIN_SUPERSTACK_AVAIL_FROM FROM X_cp_schedule_bin WHERE BIN_LIC_NUMBER =bin.bin_lic_number AND BIN_ID = bin.bin_id)CSG_SS_SCH_AVAIL_DATE_FROM,
      --SYSDATE CSG_SS_SCH_AVAIL_DATE_FROM,
      (SELECT BIN_SUPERSTACK_AVAIL_TO FROM X_cp_schedule_bin WHERE BIN_LIC_NUMBER =bin.bin_lic_number AND BIN_ID = bin.bin_id) CSG_SS_SCH_AVAIL_DATE_TO,
      --SYSDATE CSG_SS_SCH_AVAIL_DATE_TO,
      /* CU4ALL - END : ANUJA SHINDE */
/*Added by Swapnil Malvi on 17-Mar-2015 for Clearleap Release*/
      nvl((select cha_short_name
             from fid_channel
             where cha_number=fs.sch_cha_number
            ),(select v.vch_short_name
               from x_vod_channel v
               where v.vch_number=bin.bin_sch_cha_number)
             ) csg_linear_cha_num,
      to_char(nvl(fs.sch_fin_actual_date,bin.bin_sch_date),''DD-MON-YYYY'')csg_linear_sch_Date,
      nvl(convert_time_n_c(nvl(fs.sch_time,bin.bin_linear_sch_time)),NULL) csg_linear_Sch_time,
      (select RTRIM(XMLAGG(XMLELEMENT(C,u.sbu_tap_barcode||'','')).EXTRACT(''//text()''),'','')uids
      --wm_concat(u.sbu_tap_barcode)uids
        from x_cp_sch_bin_uid u
        where u.sbu_bin_id=bin.bin_id)uids,
/*END*/
      (CASE WHEN x_fnc_title_is_premier(fg.gen_refno,bin.bin_reg_code,fs.sch_fin_actual_date,fs.sch_time) = ''Y''
      THEN ''Yes''
      ELSE ''No''
      END) csg_is_Premier,
      ( CASE WHEN (SELECT COUNT(1)
        FROM x_cp_play_list
        WHERE plt_bin_id = bin.bin_id
        AND plt_lic_number = bin.bin_lic_number
        AND '
         || l_plan_year_mon
         || ' BETWEEN to_number(to_char(plt_sch_start_date,''RRRRMM'')) AND to_number(to_char(plt_sch_end_date,''RRRRMM''))
       ) > 0
      THEN ''Yes''
      ELSE ''No''
      END) csg_on_Schedule,
      (CASE
          WHEN x_fnc_title_is_blackout(fg.gen_refno,X_FNC_GET_PROG_TYPE(fl.lic_budget_code),bin.bin_view_start_date,bin.bin_view_end_date,'
         || l_fea_blackout_days
         || ','
         || l_ser_blackout_days
         || ',bin.bin_reg_code) = ''Y''
          THEN ''Yes''
          ELSE ''No''
       END) csg_in_Blackout_period,
      fl.lic_showing_int csg_Viewing_Period,
      (SELECT COUNT(distinct plt_sch_number)
       FROM x_cp_play_list
       WHERE plt_lic_number = fl.lic_number
      )csg_Viewing_Period_Used,
      -- Changes By Rashmi Tijare For CHP_CR3 PullVod Start
       (Case
         When BIN_VIEW_START_DATE is not null then
          (Case
         when cspa_Catchup_category is not null Then
          ''Y''
         Else
          ''N''
       END) Else null End) catchupplanningattributeexists,
       (CASE WHEN (SELECT count(1) FROM x_cp_play_list WHERE plt_bin_id = bin.bin_id AND plt_dev_id IN (SELECT md_id FROM x_cp_media_device WHERE md_vod_applicable = ''Y'')) > 0
                         THEN(Case
                        when (select plt_push_start_date
                 from x_cp_play_list
                where plt_bin_id = bin.bin_id
                  and rownum < 2) is not null and
              (select plt_pull_start_date
                 from x_cp_play_list
                where plt_bin_id = bin.bin_id
                  and rownum < 2) is not null Then
          ''BOTH''
         when (select plt_pull_start_date
                 from x_cp_play_list
                where plt_bin_id = bin.bin_id
                  and rownum < 2) is not null THEN
          ''PULL''
         when (select plt_push_start_date
                 from x_cp_play_list
                where plt_bin_id = bin.bin_id
                  and rownum < 2) is not null Then
          ''PUSH''
       END)
             ELSE NULL
             END) csg_catchup_planning_attribute,
       (CASE WHEN (SELECT count(1) FROM x_cp_play_list WHERE plt_bin_id = bin.bin_id AND plt_dev_id IN (SELECT md_id FROM x_cp_media_device WHERE md_vod_applicable = ''Y'')) > 0
                         THEN(CASE WHEN (SELECT count(1) FROM x_cp_play_list WHERE plt_bin_id = bin.bin_id AND rownum < 2) > 0
                                             THEN (SELECT to_char(plt_push_start_date,''DD-Mon-RRRR HH24:MI:SS'')
                                                         FROM x_cp_play_list
                                                         WHERE plt_bin_id = bin.bin_id
                                                         AND rownum < 2
                                                        )
                                    ELSE NULL
                                     /*(CASE When BIN_VIEW_START_DATE is not null then
                                        X_FUN_CP_IS_PUSH_DAYS(cspa_Catchup_category, bin.bin_sch_number)
                                     Else
                                        null
                                        End)*/
                                    END)
             ELSE NULL
             END) csg_pushstartdate,
             (CASE WHEN (SELECT count(1) FROM x_cp_play_list WHERE plt_bin_id = bin.bin_id AND plt_dev_id IN (SELECT md_id FROM x_cp_media_device WHERE md_vod_applicable = ''Y'')) > 0
                         THEN(CASE WHEN (SELECT count(1) FROM x_cp_play_list WHERE plt_bin_id = bin.bin_id AND rownum < 2) > 0
                                             THEN (SELECT to_char(plt_push_end_date,''DD-Mon-RRRR HH24:MI:SS'')
                                                         FROM x_cp_play_list
                                                         WHERE plt_bin_id = bin.bin_id
                                                         AND rownum < 2
                                                        )
                                    ELSE NULL
                                    END)
             ELSE NULL
             END) csg_push_end_date,
       (CASE WHEN (SELECT count(1) FROM x_cp_play_list WHERE plt_bin_id = bin.bin_id AND plt_dev_id IN (SELECT md_id FROM x_cp_media_device WHERE md_vod_applicable = ''Y'')) > 0
                         THEN(CASE WHEN (SELECT count(1) FROM x_cp_play_list WHERE plt_bin_id = bin.bin_id AND rownum < 2) > 0
                                             THEN (SELECT to_char(plt_pull_start_date,''DD-Mon-RRRR HH24:MI:SS'')
                                                         FROM x_cp_play_list
                                                         WHERE plt_bin_id = bin.bin_id
                                                         AND rownum < 2
                                                        )
                                    ELSE NULL
                                         /*(CASE When BIN_VIEW_START_DATE is not null then
                                            X_FUN_CP_IS_PULL_DAYS(cspa_Catchup_category,
                                                                                     bin.bin_lic_number,
                                                                                        bin.bin_sch_number)
                                         Else
                                            null
                                     End)*/
                                    END)
             ELSE NULL
             END) csg_pull_start_date,
             (CASE WHEN (SELECT count(1) FROM x_cp_play_list WHERE plt_bin_id = bin.bin_id AND plt_dev_id IN (SELECT md_id FROM x_cp_media_device WHERE md_vod_applicable = ''Y'')) > 0
                         THEN(CASE WHEN (SELECT count(1) FROM x_cp_play_list WHERE plt_bin_id = bin.bin_id AND rownum < 2) > 0
                                             THEN (SELECT to_char(plt_pull_end_date,''DD-Mon-RRRR HH24:MI:SS'')
                                                         FROM x_cp_play_list
                                                         WHERE plt_bin_id = bin.bin_id
                                                         AND rownum < 2
                                                        )
                                    ELSE NULL
                                    END)
             ELSE NULL
             END) csg_pull_end_date,
             cspa_push,
             /*CASE WHEN (SELECT count(1) FROM x_cp_lic_medplatmdevcompat_map INNER JOIN x_cp_media_dev_platm_map ON mdp_map_id = lic_mpdc_dev_platm_id INNER JOIN x_cp_media_device ON md_id = mdp_map_dev_id INNER JOIN x_cp_media_device_compat ON mdc_id = lic_mpdc_comp_rights_id WHERE md_id IN (SELECT md_id FROM x_cp_media_device WHERE md_vod_applicable = ''Y'') AND mdc_code = ''PUSH'' AND lic_is_comp_rights = ''Y'' AND lic_mpdc_lic_number = bin.bin_lic_number) > 0
                        THEN ''Y''
                        ELSE ''N''
             END csg_push_rights,
             CASE WHEN (SELECT count(1) FROM x_cp_lic_medplatmdevcompat_map INNER JOIN x_cp_media_dev_platm_map ON mdp_map_id = lic_mpdc_dev_platm_id INNER JOIN x_cp_media_device ON md_id = mdp_map_dev_id INNER JOIN x_cp_media_device_compat ON mdc_id = lic_mpdc_comp_rights_id WHERE md_id IN (SELECT md_id FROM x_cp_media_device WHERE md_vod_applicable = ''Y'') AND mdc_code IN (''DOWNLOADSD'',''DOWNLOADHD'',''STREAMINGSD'',''STREAMINGHD'') AND lic_is_comp_rights = ''Y'' AND lic_mpdc_lic_number = bin.bin_lic_number) > 0
                        THEN ''Y''
                        ELSE ''N''
             END csg_pull_rights,*/
             /*Added by milan shah For CU4ALL*/
             (CASE WHEN
                     (SELECT COUNT(1) FROM x_cp_media_device_compat,
                                   x_cp_lic_medplatmdevcompat_map
                     WHERE mdc_delivery_method = ''PUSH''
                           AND lic_mpdc_lic_number = bin.bin_lic_number
                           AND mdc_id = LIC_MPDC_COMP_RIGHTS_ID
                           AND LIC_IS_COMP_RIGHTS = ''Y'')>0
                  THEN
                      ''Y''
                  ELSE
                      ''N''
                  END)csg_push_rights,

                  (CASE WHEN
                  (SELECT COUNT(1)
                  FROM   x_cp_media_device_compat
                        ,x_cp_lic_medplatmdevcompat_map
                  WHERE  mdc_delivery_method = ''PULL''
                         AND lic_mpdc_lic_number =bin.bin_lic_number
                         AND mdc_id = LIC_MPDC_COMP_RIGHTS_ID
                         AND LIC_IS_COMP_RIGHTS = ''Y'')>0
                   THEN
                      ''Y''
                   ELSE
                      ''N''
                   END)csg_pull_rights,
                   /*End milan shah */
-- Changes By Rashmi Tijare For CHP_CR3 PullVod End
      bin.bin_reg_code csg_region_id,
      bin.bin_id,
      fg.gen_catchup_category,
      bin_update_Count csg_update_Count,
      bin_created_on csg_entry_Date,
      bin_created_by csg_entry_oper,
      bin_modified_by csg_modified_by,
     -- bin_modified_on csg_modified_on
    -- (select  max(IAR_SCH_CREATED) from X_CL_IXS_API_RELEASE where  iar_status <> ''F'' and iar_session_id in (select CRS_SESSION_ID from x_cl_release_schedule where CRS_LIC_NUMBER = bin.bin_lic_number )) csg_modified_on,
     (select max(CRS_entry_date) from x_cl_release_schedule where CRS_LIC_NUMBER = bin.bin_lic_number )csg_modified_on,---Added By Rashmi for Vod Changes
        
 (SELECT   LTCM_item_ID
           FROM fid_tape t, 
                sgy_mn_lic_tape_cha_mapp m
                      WHERE m.ltcm_tap_number = t.tap_number
                            AND m.ltcm_lic_number =bin.bin_lic_number
                            --  AND Tap_Uid_Version = ''FRM''
                              and tap_IS_EXPIRED =''N''
                          --    AND NVL(t.TAP_IS_UID,''N'')=''N'' 
                            and fs.SCH_TAP_NUMBER=t.tap_number
                           AND tap_uid_status_id <> 13
                           AND ROWNUM < 2         
         UNION
                 SELECT   LTCM_item_ID
                       FROM fid_tape t,
                            sgy_mn_lic_tape_cha_mapp m
                             WHERE     m.ltcm_tap_number = t.tap_number
                                       AND m.ltcm_gen_refno = fl.lic_gen_refno
                                       AND fl.lic_number = bin.bin_lic_number
                                       -- AND Tap_Uid_Version = ''FRM''
                                        and tap_IS_EXPIRED =''N''
                                      --  AND NVL(t.TAP_IS_UID,''N'')=''Y''
                                        and fs.SCH_TAP_NUMBER=t.tap_number
                                       AND tap_uid_status_id <> 13
                                       AND ROWNUM < 2 )ARDOME_ID ---Added by Rashmi for Vod Changes
    FROM x_cp_schedule_bin bin,
      fid_general fg,
      fid_schedule fs,
      fid_license fl,
      x_cp_catchupsch_plan_attr';

      IF I_PRIMARY_BOUQUET > 0
      THEN
         l_lic_query := l_lic_query || ',X_CP_SCH_BOUQUET_MAPP';
      END IF;

      l_lic_query :=
         l_lic_query
         || ' WHERE bin.bin_sch_number = fs.sch_number(+)
                                  AND fl.lic_gen_refno = fg.gen_refno
                                  AND bin.bin_lic_number = fl.lic_number
                                  --AND fs.sch_number = fl.lic_sch_number
                                  /*CU4ALL : START : [ANUJA_SHINDE][14/01/2015]*/
                               and lic_lee_number = decode('
         || i_lee_number
         || ',0,lic_lee_number,'
         || i_lee_number
         || ')
                                  AND fg.gen_catchup_category = cspa_Catchup_category (+)
                                  AND NVL(bin.on_schedule_grid,''N'') = ''Y''
                                  AND NVL(fl.lic_catchup_flag,''N'') IN ( SELECT ms_media_service_flag
                                                                            FROM x_vw_usr_ser_map
                                                                           WHERE x_usm_user_id = '''
         || i_entry_oper
         || '''
                                                                             AND ms_media_service_code like '''
         || i_media_service
         || '''
                                                                             AND ms_media_service_parent = ''CATCHUP''
                                                                         )--ver 1.0 added
                                  AND bin.bin_reg_code LIKE DECODE('''
         || i_Region
         || ''',0,''%'','''
         || i_Region
         || ''')
                                  AND '
         || l_plan_year_mon
         || ' BETWEEN to_number(to_char(bin_view_start_date,''RRRRMM'')) AND to_number(to_char(bin_view_end_date,''RRRRMM''))
                                  AND EXISTS (SELECT 1
                                              FROM fid_code
                                              WHERE cod_type=''GEN_TYPE''
                                              AND cod_value <> ''HEADER''
                                              AND cod_value = fg.gen_type
                                              AND UPPER(cod_attr1) LIKE UPPER(DECODE('''
         || i_Content_Type
         || ''',''%'',''%'','''
         || l_content_type
         || ''')))
                                      AND UPPER(gen_title) LIKE UPPER(DECODE(:a,'''',''%'',:b))
                                  ';


      l_schedule_query := 'SELECT
        bin.bin_lic_number,
        bin.bin_id
      FROM x_cp_schedule_bin bin,
        fid_general fg,
        fid_schedule fs,
        fid_license fl';

      IF I_PRIMARY_BOUQUET > 0
      THEN
         l_schedule_query := l_schedule_query || ',X_CP_SCH_BOUQUET_MAPP';
      END IF;

      l_schedule_query :=
         l_schedule_query
         || ' WHERE bin.bin_sch_number = fs.sch_number(+)
                                  AND fl.lic_gen_refno = fg.gen_refno
                                  AND bin.bin_lic_number = fl.lic_number
                                  AND NVL(bin.on_schedule_grid,''N'') = ''Y''
                                  AND NVL(fl.lic_catchup_flag,''N'') IN ( SELECT ms_media_service_flag
                                                                            FROM x_vw_usr_ser_map
                                                                           WHERE x_usm_user_id = '''
         || i_entry_oper
         || '''
                                                                             AND ms_media_service_code like '''
         || i_media_service
         || '''
                                                                             AND ms_media_service_parent = ''CATCHUP''
                                                                        )--ver 1.0 added
                                  AND bin.bin_reg_code LIKE DECODE('''
         || i_Region
         || ''',''0'',''%'','''
         || i_Region
         || ''')
                                  AND '
         || l_plan_year_mon
         || ' BETWEEN to_number(to_char(bin_view_start_date,''RRRRMM'')) AND to_number(to_char(bin_view_end_date,''RRRRMM''))
                                  AND EXISTS (SELECT 1
                                              FROM fid_code
                                              WHERE cod_type=''GEN_TYPE''
                                              AND cod_value <> ''HEADER''
                                              AND cod_value = fg.gen_type
                                              AND UPPER(cod_attr1) LIKE UPPER(DECODE('''
         || i_Content_Type
         || ''',''%'',''%'','''
         || l_content_type
         || ''')))
                                    AND UPPER(gen_title) LIKE UPPER(DECODE(:a,'''',''%'',:b))
                                ';

      IF I_PRIMARY_BOUQUET > 0
      THEN
         l_lic_query :=
               l_lic_query
            || 'AND Bin.bin_id = SBM_BIN_ID
                                      AND SBM_BOUQUET_ID = '
            || I_PRIMARY_BOUQUET;

         l_schedule_query :=
               l_schedule_query
            || 'AND Bin.bin_id = SBM_BIN_ID
                                      AND SBM_BOUQUET_ID = '
            || I_PRIMARY_BOUQUET;
      END IF;

      IF NVL (i_is_Include_Rec_Sch, 'N') = 'N' AND NVL(I_SCH_STRT_PAST_MON,'N') = 'N'
      THEN
         l_lic_query :=
            l_lic_query
            || 'AND NOT EXISTS ( SELECT plt_lic_number
                                                      FROM x_cp_play_list vcpl
                                                      WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                      AND vcpl.plt_sch_number = bin.bin_sch_number
                                                      AND ('
            || l_plan_year_mon
            || ' BETWEEN to_number(to_char(plt_sch_start_date,''RRRRMM'')) AND to_number(to_char(plt_sch_end_date,''RRRRMM'')))
                                                      AND plt_dev_id LIKE DECODE('''
            || i_Media_Devices
            || ''',''0'',''%'','''
            || i_Media_Devices
            || ''')
                                                   )
      ';

         l_schedule_query :=
            l_schedule_query
            || 'AND NOT EXISTS ( SELECT plt_lic_number
                                                                FROM x_cp_play_list vcpl
                                                                WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                                AND vcpl.plt_sch_number = bin.bin_sch_number
                                                                AND ('
            || l_plan_year_mon
            || ' BETWEEN to_number(to_char(plt_sch_start_date,''RRRRMM'')) AND to_number(to_char(plt_sch_end_date,''RRRRMM'')))
                                                                AND plt_dev_id LIKE DECODE('''
            || i_Media_Devices
            || ''',''0'',''%'','''
            || i_Media_Devices
            || ''')
                                                   )
      ';
      ELSE
         -- CatchUp Scheduling : Start : [Devashish Raverkar]_[2015/03/09]

         IF NVL (I_SCH_STRT_PAST_MON, 'N') = 'Y'
            AND L_SCH_STRT_PAST_MON = 'Y'
         THEN
            l_lic_query :=
               l_lic_query
               || 'AND NOT EXISTS ( SELECT 1
                                                      FROM x_cp_play_list vcpl
                                                      WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                      AND vcpl.plt_bin_id = bin.bin_id
                                                      GROUP BY vcpl.plt_bin_id
                                                      HAVING(
            ('
               || l_plan_year_mon
               || ' >  to_number(to_char(max(vcpl.plt_sch_end_date),''RRRRMM'')))
            OR
            ('
               || l_plan_year_mon
               || ' <  to_number(to_char(min(vcpl.plt_sch_start_date),''RRRRMM'')))
                                                   ))
      ';

            l_schedule_query :=
               l_schedule_query
               || 'AND NOT EXISTS ( SELECT 1
                                                      FROM x_cp_play_list vcpl
                                                      WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                      AND vcpl.plt_bin_id = bin.bin_id
                                                      GROUP BY vcpl.plt_bin_id
                                                      HAVING(
            ('
               || l_plan_year_mon
               || ' >  to_number(to_char(max(vcpl.plt_sch_end_date),''RRRRMM'')))
            OR
            ('
               || l_plan_year_mon
               || ' <  to_number(to_char(min(vcpl.plt_sch_start_date),''RRRRMM'')))
                                                   ))
      ';
         ELSE
            -- Removing Licenses Scheduled in month different than planned month.
            l_lic_query :=
               l_lic_query
               || 'AND NOT EXISTS ( SELECT 1
                                                      FROM x_cp_play_list vcpl
                                                      WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                      AND vcpl.plt_bin_id = bin.bin_id
                                                      GROUP BY vcpl.plt_bin_id
                                                      HAVING ('
               || l_plan_year_mon
               || ' <>  to_number(to_char(min(vcpl.plt_sch_start_date),''RRRRMM'')))
                                                   )
      ';

            l_schedule_query :=
               l_schedule_query
               || 'AND NOT EXISTS ( SELECT 1
                                                      FROM x_cp_play_list vcpl
                                                      WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                      AND vcpl.plt_bin_id = bin.bin_id
                                                      GROUP BY vcpl.plt_bin_id
                                                      HAVING ('
               || l_plan_year_mon
               || ' <>  to_number(to_char(min(vcpl.plt_sch_start_date),''RRRRMM'')))
                                                   )
      ';
         END IF;
      -- CatchUp Scheduling : End :
      END IF;



      IF NVL (i_is_Include_Rec_Sch, 'N') = 'Y'
         AND NVL (i_Include_Blackout, 'N') = 'N'
      THEN
         l_lic_query :=
            l_lic_query
            || 'AND NOT EXISTS (SELECT plt_lic_number FROM x_cp_play_list vcpl, fid_license fli
                                                      WHERE vcpl.plt_lic_number = fli.lic_number
                                                      AND fli.lic_gen_refno = fg.gen_refno
                                                      AND NVL(fli.lic_catchup_flag,''N'') IN ( SELECT ms_media_service_flag
                                                                                                 FROM x_vw_usr_ser_map
                                                                                                WHERE x_usm_user_id = '''
            || i_entry_oper
            || '''
                                                                                                  AND ms_media_service_code like '''
            || i_media_service
            || '''
                                                                                                  AND ms_media_service_parent = ''CATCHUP''
                                                                                              )--ver 1.0 added
                                                      AND vcpl.plt_reg_code = bin.bin_reg_code
                                                      AND ((trim(vcpl.plt_sch_start_date) BETWEEN CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                          THEN bin.bin_view_start_date - '
            || l_fea_blackout_days
            || '
                                                                                                                     ELSE bin.bin_view_start_date - '
            || l_ser_blackout_days
            || '
                                                                                                                     END AND bin.bin_view_start_date - 1)
                                                      OR (trim(vcpl.plt_sch_end_date) BETWEEN CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                          THEN bin.bin_view_start_date - '
            || l_fea_blackout_days
            || '
                                                                                                                     ELSE bin.bin_view_start_date - '
            || l_ser_blackout_days
            || '
                                                                                                                     END AND bin.bin_view_start_date - 1)
                                                      OR (trim(vcpl.plt_sch_start_date) BETWEEN bin.bin_view_end_date + 1 AND CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                                               THEN bin.bin_view_end_date + '
            || l_fea_blackout_days
            || '
                                                                                                                                          ELSE bin.bin_view_end_date + '
            || l_ser_blackout_days
            || '
                                                                                                                                          END)
                                                      OR (trim(vcpl.plt_sch_end_date) BETWEEN bin.bin_view_end_date + 1 AND CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                                               THEN bin.bin_view_end_date + '
            || l_fea_blackout_days
            || '
                                                                                                                                          ELSE bin.bin_view_end_date + '
            || l_ser_blackout_days
            || '
                                                                                                                                          END))
                                                   )
      ';

         l_schedule_query :=
            l_schedule_query
            || 'AND NOT EXISTS (SELECT plt_lic_number FROM x_cp_play_list vcpl, fid_license fli
                                                      WHERE vcpl.plt_lic_number = fli.lic_number
                                                      AND fli.lic_gen_refno = fg.gen_refno
                                                      AND NVL(fli.lic_catchup_flag,''N'') IN ( SELECT ms_media_service_flag
                                                                                                FROM x_vw_usr_ser_map
                                                                                               WHERE x_usm_user_id = '''
            || i_entry_oper
            || '''
                                                                                                 AND ms_media_service_code like '''
            || i_media_service
            || '''
                                                                                                 AND ms_media_service_parent = ''CATCHUP''
                                                                                             )--ver 1.0 added
                                                      AND vcpl.plt_reg_code = bin.bin_reg_code
                                                      AND ((trim(vcpl.plt_sch_start_date) BETWEEN CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                          THEN bin.bin_view_start_date - '
            || l_fea_blackout_days
            || '
                                                                                                                     ELSE bin.bin_view_start_date - '
            || l_ser_blackout_days
            || '
                                                                                                                     END AND bin.bin_view_start_date - 1)
                                                      OR (trim(vcpl.plt_sch_end_date) BETWEEN CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                          THEN bin.bin_view_start_date - '
            || l_fea_blackout_days
            || '
                                                                                                                     ELSE bin.bin_view_start_date - '
            || l_ser_blackout_days
            || '
                                                                                                                     END AND bin.bin_view_start_date - 1)
                                                      OR (trim(vcpl.plt_sch_start_date) BETWEEN bin.bin_view_end_date + 1 AND CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                                               THEN bin.bin_view_end_date + '
            || l_fea_blackout_days
            || '
                                                                                                                                          ELSE bin.bin_view_end_date + '
            || l_ser_blackout_days
            || '
                                                                                                                                          END)
                                                      OR (trim(vcpl.plt_sch_end_date) BETWEEN bin.bin_view_end_date + 1 AND CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                                               THEN bin.bin_view_end_date + '
            || l_fea_blackout_days
            || '
                                                                                                                                          ELSE bin.bin_view_end_date + '
            || l_ser_blackout_days
            || '
                                                                                                                                          END))
                                                   )
      ';
      END IF;

      -- Only Premier Schedule condition is handeled on UI side : Start
      /*IF NVL(i_is_Only_Premier,'N') = 'Y'
      THEN
        l_lic_query := l_lic_query || 'AND NOT EXISTS (SELECT 1
              FROM fid_channel,
                   fid_schedule
              WHERE cha_number = sch_cha_number
              AND sch_gen_refno = fg.gen_refno
              AND cha_region_id LIKE DECODE(''' || i_Region || ''',''0'',''%'',''' || i_Region || ''')
              GROUP BY sch_gen_refno
              HAVING min(to_date(to_char(sch_fin_actual_date,''DD-MM-RRRR'') || '' '' || convert_time_n_c(sch_time),''DD-MM-RRRR HH24:MI:SS'')) <> to_date(to_char(fs.sch_fin_actual_date,''DD-MM-RRRR'') || '' '' || convert_time_n_c(fs.sch_time),''DD-MM-RRRR HH24:MI:SS''))
        ';

        l_schedule_query := l_schedule_query || 'AND EXISTS (SELECT 1
              FROM fid_channel,
                   fid_schedule,
                   fid_general,
                   fid_license
              WHERE cha_number = sch_cha_number
              AND sch_lic_number = lic_number
              AND gen_refno = lic_gen_refno
              AND gen_refno = fg.gen_refno
              AND cha_region_id LIKE DECODE(''' || i_Region || ''',''0'',''%'',''' || i_Region || ''')
              GROUP BY cha_number,cha_region_id,gen_refno
              HAVING min(sch_fin_actual_date) = fs.sch_fin_actual_date)
        ';

        l_lic_query := l_lic_query || ' AND x_pkg_cp_planning.x_fnc_title_is_premier(fg.gen_refno,fs.sch_fin_actual_date,fs.sch_time) = ''Y''';

        l_schedule_query := l_schedule_query || ' AND x_pkg_cp_planning.x_fnc_title_is_premier(fg.gen_refno,fs.sch_fin_actual_date,fs.sch_time) = ''Y''';
      END IF;*/
      -- Only Premier Schedule condition is handeled on UI side : End

      --l_lic_query := l_lic_query || ' ORDER BY fg.gen_title';

      --DBMS_OUTPUT.PUT_LINE ('QUERY : ' || l_lic_query);

      OPEN o_config_data FOR l_lic_query USING i_Prog_Title, i_Prog_Title;

      l_schedule_query :=
         'SELECT lic_mpdc_lic_number,
       bin_sch_number,
       PLT_UPDATE_COUNT,
       mdp_map_dev_id,
       lic_is_on_schedule,
       sch_start_date_time,
       X_PKG_CP_SCH_GRID.x_fnc_calc_end_date (lic_mpdc_lic_number,
                                          bin_id,
                                          mdp_map_dev_id,
                                          TO_DATE ('''
         || l_sch_start_date
         || ''', ''DD-MM-RR''),
                                          premier_flag,
                                          lic_max_viewing_period,
                                          lic_sch_without_lin_ref,
                                          lic_budget_code,
                                          lic_gen_refno,
                                          lic_sch_bef_x_day,
                                          lic_sch_bef_x_day_value,
                                          lic_start,
                                          lic_end,
                                          gen_duration_c,
                                          sch_fin_actual_date,
                                          sch_time,
                                          sch_end_time,
                                          cha_region_id,
                                          lic_period_tba,
                                          bin_view_start_date,
                                          bin_view_end_date,
                                          sch_start_date_time)
          sch_end_date_time
  FROM (SELECT lic_mpdc_lic_number,
               bin_id,
                bin_sch_number,
               NVL (
                  (SELECT PLT_UPDATE_COUNT
                     FROM x_cp_play_list
                    WHERE     plt_lic_number = lic_mpdc_lic_number
                          AND plt_dev_id = mdp_map_dev_id
                          AND plt_bin_id = bin_id),
                  0)
                  AS PLT_UPDATE_COUNT,
               mdp_map_dev_id,
               lic_is_on_schedule,
               X_PKG_CP_SCH_GRID.x_fnc_calc_start_date (lic_mpdc_lic_number,bin_id,mdp_map_dev_id,TO_DATE ('''
         || l_sch_start_date
         || ''', ''DD-MM-RR''),
               premier_flag,
               lic_max_viewing_period,
               lic_sch_without_lin_ref,
               lic_budget_code,
               lic_gen_refno,
               lic_sch_bef_x_day,
               lic_sch_bef_x_day_value,
               lic_start,
               lic_end,
               sch_fin_actual_date,
               sch_time,
               sch_end_time,
               cha_region_id,
               lic_period_tba,
               bin_view_start_date)
               sch_start_date_time,
               lic_max_viewing_period,
               lic_sch_without_lin_ref,
               lic_budget_code,
               lic_gen_refno,
               lic_sch_bef_x_day,
               lic_sch_bef_x_day_value,
               lic_start,
               lic_end,
               gen_duration_c,
               sch_fin_actual_date,
               sch_time,
               sch_end_time,
               cha_region_id,
               lic_period_tba,
               bin_view_start_date,
               bin_view_end_date,
               premier_flag
          FROM (SELECT dev_rigts_in_vw.*
                  FROM (SELECT  bin_id,
                               bin_sch_number,
                               lic_mpdc_lic_number,
                               mdp_map_dev_id,
                               MAX(CASE
                                  WHEN (SELECT COUNT (1)
                                          FROM x_cp_play_list
                                         WHERE plt_lic_number =
                                                  lic_mpdc_lic_number
                                               AND plt_dev_id =
                                                      mdp_map_dev_id
                                               AND plt_sch_number =
                                                      bin_sch_number
                                            /*   AND ('
         || l_plan_year_mon
         || ' BETWEEN TO_NUMBER ( TO_CHAR (plt_sch_start_date,''RRRRMM''))
                                                                               AND TO_NUMBER (TO_CHAR (plt_sch_end_date,''RRRRMM'')))
                                               */
                                                                         ) >
                                          0
                                  THEN
                                     ''Y''
                                  ELSE
                                     ''N''
                               END)
                                  lic_is_on_schedule,
                               lic_max_viewing_period,
                               lic_sch_without_lin_ref,
                               lic_budget_code,
                               lic_gen_refno,
                               lic_sch_bef_x_day,
                               lic_sch_bef_x_day_value,
                               lic_start,
                               lic_end,
                               MAX(fun_convert_duration_c_n (gen_duration_c))
                                  gen_duration_c,
                               sch_fin_actual_date,
                               sch_time,
                               sch_end_time,
                               cha_region_id,
                               lic_period_tba,
                               bin_view_start_date,
                               bin_view_end_date,
                               MAX(x_fnc_title_is_premier(fl.lic_gen_refno,fc.cha_region_id,fs.sch_date,fs.sch_time)) premier_flag
                          FROM x_cp_lic_medplatmdevcompat_map,
                               x_cp_media_dev_platm_map,
                               x_cp_schedule_bin,
                               fid_license fl,
                               fid_general fg,
                               fid_Schedule fs,
                               fid_channel fc
                         WHERE     lic_mpdc_dev_platm_id = MDP_MAP_ID
                               AND bin_lic_number = LIC_MPDC_LIC_NUMBER
                               AND LIC_MPDC_LIC_NUMBER = fl.lic_number
                               AND fl.lic_gen_refno = fg.gen_refno
                               AND fs.sch_number(+) = bin_Sch_number
                               AND fc.cha_number(+) = fs.sch_cha_number
                               AND lic_rights_on_device = ''Y''
                               AND lic_is_comp_rights = ''Y''
                               /*CU4ALL : START : [ANUJA_SHINDE][14/01/2015]*/
                               and lic_lee_number = decode('
         || i_lee_number
         || ',0,lic_lee_number,'
         || i_lee_number
         || ')
                               AND mdp_map_dev_id LIKE
                                      DECODE ('''
         || i_Media_Devices
         || ''',''0'',''%'','''
         || i_Media_Devices
         || ''')
                               AND (bin_lic_number, bin_id) IN
                                      (
                                      '
         || l_schedule_query
         || '
                                      )
                                                             GROUP BY bin_sch_number,bin_id,lic_mpdc_lic_number,mdp_map_dev_id,
                               lic_max_viewing_period,
                               lic_sch_without_lin_ref,
                               lic_budget_code,
                               lic_gen_refno,
                               lic_sch_bef_x_day,
                               lic_sch_bef_x_day_value,
                               lic_start,
                               lic_end,
                               sch_fin_actual_date,
                               sch_time,
                               sch_end_time,
                               cha_region_id,
                               lic_period_tba,
                               bin_view_start_date,
                               bin_view_end_date) dev_rigts_in_vw))
                          ';

      --DBMS_OUTPUT.PUT_LINE('l_schedule_query : ' || l_schedule_query);

      -- OPEN o_sch_chk_data FOR l_schedule_query
      --    USING i_Prog_Title, i_Prog_Title;

      OPEN o_media_devices FOR
           SELECT md_id, md_code, md_desc
             FROM x_cp_media_device,
                  x_cp_med_platm_dev_compat_map,
                  x_cp_medplatdevcomp_servc_map,
                  x_cp_media_dev_platm_map
            WHERE     mdp_map_dev_id = md_id
                  AND mpdc_dev_platm_id = mdp_map_id
                  AND mpdcs_mpdc_id = mpdc_id
                  --AND UPPER (mpdcs_med_service_code) = 'CATCHUP'               --ver 1.0 commented
                  -- for CATCHUP3P
                  AND UPPER (mpdcs_med_service_code) IN
                         (SELECT ms_media_service_code
                            FROM sgy_pb_media_service
                           WHERE ms_media_service_parent = 'CATCHUP'
                                 AND ms_media_service_code LIKE i_media_service --ver 1.0 Added
                                                                               ) --ver 1.0 Added
                  AND md_id LIKE
                         DECODE (TO_CHAR (i_Media_Devices),
                                 '0', '%',
                                 TO_CHAR (i_Media_Devices))
         GROUP BY md_id, md_code, md_desc;

      /* Added by khilesh Chauhan 21 April 2015

                      ------ by khilesh
              */
      FOR mediaDevice
         IN (  SELECT                                                 --md_id,
                                                                     --md_code
                      '''' || md_code || '''' || ',' md_code
                 -- md_desc
                 FROM x_cp_media_device,
                      x_cp_med_platm_dev_compat_map,
                      x_cp_medplatdevcomp_servc_map,
                      x_cp_media_dev_platm_map
                WHERE     mdp_map_dev_id = md_id
                      AND mpdc_dev_platm_id = mdp_map_id
                      AND mpdcs_mpdc_id = mpdc_id
                      AND UPPER (mpdcs_med_service_code)      -- for CATCHUP3P
                                                        IN
                             (SELECT ms_media_service_code
                                FROM sgy_pb_media_service
                               WHERE ms_media_service_parent = 'CATCHUP'
                                     AND ms_media_service_code LIKE
                                            i_media_service    --ver 1.0 Added
                                                           ) --= UPPER(i_media_service)--Added by [Swapnali.Belose]_[SVOD Enhancements]_[17.04.2015]
                      AND md_id LIKE
                             DECODE (TO_CHAR (i_Media_Devices),
                                     '0', '%',
                                     TO_CHAR (i_Media_Devices))
             GROUP BY md_id, md_code, md_desc)
      LOOP
         l_media_devices_list := l_media_devices_list || mediaDevice.md_code;
      END LOOP;

      l_media_devices_list := RTRIM (l_media_devices_list, ',');
      --dbms_output.put_line('l_media_devices_list '|| l_media_devices_list);
      -- dbms_output.put_line('l_schedule_query '|| l_schedule_query);

      l_schedule_query_pivot := l_schedule_query;
      l_schedule_query_pivot :=
         'select * from
        (select LIC_MPDC_LIC_NUMBER,BIN_SCH_NUMBER,PLT_UPDATE_COUNT,
        (select md_code from x_cp_media_device where md_id=mdp_map_dev_id) MDP_MAP_DEV,
        LIC_IS_ON_SCHEDULE,SCH_START_DATE_TIME,SCH_END_DATE_TIME from
        ('
         || l_schedule_query_pivot
         || '))
        pivot (
        max(SCH_START_DATE_TIME) as DYN_StartDate,
        max(SCH_END_DATE_TIME) as DYN_EndDate,
        max(NVL(PLT_UPDATE_COUNT,0)) as DYN_UpdateCount,
        max(NVL(LIC_IS_ON_SCHEDULE,0)) as DYN_Lic_Is_Sch
        for MDP_MAP_DEV in ('
         || l_media_devices_list
         || '))';

      -- DBMS_OUTPUT.put_line ('PIVOT : ' || l_schedule_query_pivot);


      OPEN o_sch_chk_data FOR l_schedule_query_pivot
         USING i_Prog_Title, i_Prog_Title;
   --------


   /* End */

   EXCEPTION     --Added by [Swapnali.Belose]_[SVOD Enhancements]_[20.04.2015]
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20111,
            'Data is not available for ' || i_media_service);
   END prc_schedule_grid_search;

   /****************************************************************
   Open Month Check
   ****************************************************************/
   PROCEDURE PRC_IS_SCHEDULE_CHECK (
      I_Sch_Month      IN     DATE,
      I_SPLIT_REGION   IN     fid_financial_month.fim_split_region%TYPE,
      O_CONFIG_DATA       OUT VARCHAR2)
   AS
      L_OPEN_MONTH    DATE;
      l_lock_status   VARCHAR2 (10);
   BEGIN
      SELECT TO_DATE (fim_year || fim_month, 'YYYYMM')
        INTO L_OPEN_MONTH
        FROM fid_financial_month
       WHERE fim_status = 'O' AND fim_split_region = I_SPLIT_REGION;

      SELECT scl_lock_status
        INTO l_lock_status
        FROM fid_schedule_lock
       WHERE     scl_cha_number = I_SPLIT_REGION
             AND scl_per_year = 1
             AND scl_per_month = 1;
   END PRC_is_SCHEDULE_CHECK;

   /****************************************************************
   CatchUp Device Rights
   ****************************************************************/
   PROCEDURE X_PRC_LIC_DEVICE_RIGHTS (
      I_Sch_Month            IN     DATE,
      i_is_Include_Rec_Sch   IN     VARCHAR2,
      i_Content_Type         IN     VARCHAR2,
      i_is_Only_Premier      IN     VARCHAR2,
      i_Prog_Title           IN     fid_general.gen_title%TYPE,
      i_Media_Devices        IN     NUMBER,
      i_Include_Blackout     IN     VARCHAR2,
      i_Region               IN     fid_licensee.lee_split_region%TYPE,
      i_media_service        IN     VARCHAR2,                  --ver 1.0 added
      i_entry_oper           IN     VARCHAR2,                  --ver 1.0 added
      o_dev_rights              OUT X_PKG_CP_SCH_GRID.x_cur_sch_grid,
      o_compatibility           OUT X_PKG_CP_SCH_GRID.x_cur_sch_grid,
      o_media_devices           OUT X_PKG_CP_SCH_GRID.x_cur_sch_grid)
   AS
      l_schedule_query      CLOB;
      l_fea_blackout_days   NUMBER;
      l_ser_blackout_days   NUMBER;
      l_content_type        VARCHAR2 (1);
      l_sch_start_date      DATE;
      l_sch_end_date        DATE;
      l_plan_year_mon       NUMBER;
   BEGIN
      BEGIN
         SELECT pa_black_out_period_movies, pa_black_out_period_ser
           INTO l_fea_blackout_days, l_ser_blackout_days
           FROM x_cp_planning_attributes;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_fea_blackout_days := 0;
            l_ser_blackout_days := 0;
      END;

      l_sch_start_date := TRUNC (I_Sch_Month, 'MONTH');
      l_sch_end_date := LAST_DAY (I_Sch_Month);
      l_plan_year_mon := TO_NUMBER (TO_CHAR (I_Sch_Month, 'RRRRMM'));

      IF UPPER (i_Content_Type) = 'FEA'
      THEN
         l_content_type := 'N';
      ELSIF UPPER (i_Content_Type) = 'SER'
      THEN
         l_content_type := 'Y';
      END IF;

      l_schedule_query :=
         'SELECT
        bin.bin_lic_number
      FROM x_cp_schedule_bin bin,
        fid_general fg,
        fid_schedule fs,
        fid_license fl
      WHERE bin.bin_sch_number = fs.sch_number(+)
      AND fl.lic_gen_refno = fg.gen_refno
      AND bin.bin_lic_number = fl.lic_number
      AND NVL(bin.on_schedule_grid,''N'') = ''Y''
      --AND NVL(fl.lic_catchup_flag,''N'') = ''Y''   --ver 1.0 commented
      AND NVL(fl.lic_catchup_flag,''N'') IN ( SELECT ms_media_service_flag
                                                FROM x_vw_usr_ser_map
                                               WHERE x_usm_user_id = '''
         || i_entry_oper
         || '''
                                                 AND ms_media_service_code like '''
         || i_media_service
         || '''
                                                 AND ms_media_service_parent = ''CATCHUP''
                                            )--ver 1.0 added IN condition
      AND bin.bin_reg_code LIKE DECODE('''
         || i_Region
         || ''',''0'',''%'','''
         || i_Region
         || ''')
      AND '
         || l_plan_year_mon
         || ' BETWEEN to_number(to_char(bin_view_start_date,''RRRRMM'')) AND to_number(to_char(bin_view_end_date,''RRRRMM''))
      AND EXISTS (SELECT 1
                  FROM fid_code
                  WHERE cod_type=''GEN_TYPE''
                  AND cod_value <> ''HEADER''
                  AND cod_value = fg.gen_type
                  AND UPPER(cod_attr1) LIKE UPPER(DECODE('''
         || i_Content_Type
         || ''',''%'',''%'','''
         || l_content_type
         || ''')))
        AND UPPER(gen_title) LIKE UPPER(DECODE(:a,'''',''%'',:b))
    ';

      IF NVL (i_is_Include_Rec_Sch, 'N') = 'N'
      THEN
         l_schedule_query :=
            l_schedule_query
            || 'AND NOT EXISTS ( SELECT plt_lic_number
                                                                FROM x_cp_play_list vcpl
                                                                WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                                AND vcpl.plt_bin_id = bin.bin_id
                                                                AND ('
            || l_plan_year_mon
            || ' BETWEEN to_number(to_char(plt_sch_start_date,''RRRRMM'')) AND to_number(to_char(plt_sch_end_date,''RRRRMM'')))
                                                                AND plt_dev_id LIKE DECODE('''
            || i_Media_Devices
            || ''',''0'',''%'','''
            || i_Media_Devices
            || ''')
                                                   )
      ';
      END IF;



      IF NVL (i_Include_Blackout, 'N') = 'N'
         AND NVL (i_is_Include_Rec_Sch, 'N') = 'Y'
      THEN
         l_schedule_query :=
            l_schedule_query
            || 'AND NOT EXISTS (SELECT plt_lic_number FROM x_cp_play_list vcpl, fid_license fli
                                                      WHERE vcpl.plt_lic_number = fli.lic_number
                                                      AND fli.lic_gen_refno = fg.gen_refno
                                                      AND NVL(fli.lic_catchup_flag,''N'') IN ( SELECT ms_media_service_flag
                                                                                                 FROM x_vw_usr_ser_map
                                                                                                WHERE x_usm_user_id = '''
            || i_entry_oper
            || '''
                                                                                                  AND ms_media_service_code like '''
            || i_media_service
            || '''
                                                                                                  AND ms_media_service_parent = ''CATCHUP''
                                                                                              )--ver 1.0 added IN condition
                                                      AND vcpl.plt_reg_code = bin.bin_reg_code
                                                      AND ((trim(vcpl.plt_sch_start_date) BETWEEN CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                          THEN bin.bin_view_start_date - '
            || l_fea_blackout_days
            || '
                                                                                                                     ELSE bin.bin_view_start_date - '
            || l_ser_blackout_days
            || '
                                                                                                                     END AND bin.bin_view_start_date - 1)
                                                      OR (trim(vcpl.plt_sch_end_date) BETWEEN CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                          THEN bin.bin_view_start_date - '
            || l_fea_blackout_days
            || '
                                                                                                                     ELSE bin.bin_view_start_date - '
            || l_ser_blackout_days
            || '
                                                                                                                     END AND bin.bin_view_start_date - 1)
                                                      OR (trim(vcpl.plt_sch_start_date) BETWEEN bin.bin_view_end_date + 1 AND CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                                               THEN bin.bin_view_end_date + '
            || l_fea_blackout_days
            || '
                                                                                                                                          ELSE bin.bin_view_end_date + '
            || l_ser_blackout_days
            || '
                                                                                                                                          END)
                                                      OR (trim(vcpl.plt_sch_end_date) BETWEEN bin.bin_view_end_date + 1 AND CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                                               THEN bin.bin_view_end_date + '
            || l_fea_blackout_days
            || '
                                                                                                                                          ELSE bin.bin_view_end_date + '
            || l_ser_blackout_days
            || '
                                                                                                                                          END))
                                                   )
      ';
      END IF;

      -- Only Premier Schedule condition is handeled on UI side : Start
      /*IF NVL(i_is_Only_Premier,'N') = 'Y'
      THEN
        l_schedule_query := l_schedule_query || 'AND EXISTS (SELECT 1
              FROM fid_channel,
                   fid_schedule,
                   fid_general,
                   fid_license
              WHERE cha_number = sch_cha_number
              AND sch_lic_number = lic_number
              AND gen_refno = lic_gen_refno
              AND gen_refno = fg.gen_refno
              AND cha_region_id LIKE DECODE(''' || i_Region || ''',''0'',''%'',''' || i_Region || ''')
              GROUP BY cha_number,cha_region_id,gen_refno
              HAVING min(sch_fin_actual_date) = fs.sch_fin_actual_date)
        ';

        l_schedule_query := l_schedule_query || ' AND x_pkg_cp_planning.x_fnc_title_is_premier(fg.gen_refno,fs.sch_fin_actual_date,fs.sch_time) = ''Y''';
      END IF;*/
      -- Only Premier Schedule condition is handeled on UI side : End

      l_schedule_query :=
         'SELECT lic_mpdc_lic_number,
                            mdp_map_dev_id,
                            lic_rights_on_device,
                            lic_mpdc_comp_rights_id,
                            lic_is_comp_rights,
                            NVL(lic_mpdc_update_count,0) lic_mpdc_update_count
                          FROM x_cp_lic_medplatmdevcompat_map,
                            x_cp_media_dev_platm_map
                          WHERE lic_mpdc_dev_platm_id = MDP_MAP_ID
                          AND lic_mpdc_lic_number IN ('
         || l_schedule_query
         || ')
                          ORDER BY lic_mpdc_lic_number,mdp_map_dev_id
                          ';

      --DBMS_OUTPUT.PUT_LINE('QUERY : ' || l_schedule_query);

      OPEN o_dev_rights FOR l_schedule_query USING i_Prog_Title, i_Prog_Title;

      OPEN o_compatibility FOR
         SELECT mdc_id, mdc_code, mdc_desc FROM x_cp_media_device_compat;

      OPEN O_MEDIA_DEVICES FOR
           SELECT DISTINCT md_id, md_code, md_desc
             FROM x_cp_media_device,
                  x_cp_med_platm_dev_compat_map,
                  x_cp_medplatdevcomp_servc_map,
                  x_cp_media_dev_platm_map
            WHERE     mdp_map_dev_id = md_id
                  AND mpdc_dev_platm_id = mdp_map_id
                  AND MPDCS_MPDC_ID = MPDC_ID
                  AND UPPER (mpdcs_med_service_code) IN
                         (SELECT S1.MS_MEDIA_SERVICE_CODE
                            FROM SGY_PB_MEDIA_SERVICE S1
                           WHERE S1.MS_MEDIA_SERVICE_PARENT = 'CATCHUP'
                                 AND MS_MEDIA_SERVICE_CODE LIKE i_media_service)
         GROUP BY md_id, md_code, md_desc;
   END x_prc_lic_device_rights;

   /****************************************************************
   Delete License from Schedule Grid
   ****************************************************************/
   PROCEDURE x_prc_delete_lic_from_grid (i_lic_number   IN     NUMBER,
                                         i_sch_number   IN     NUMBER,
                                         i_bin_id       IN     NUMBER,
                                         i_reg_code     IN     NUMBER,
                                         i_entry_oper   IN     VARCHAR2,
                                         o_status          OUT NUMBER)
   AS
      l_lic_count    NUMBER;
      v_sch_number   NUMBER;
      p_open_month   date;             --Added by Milan Shah for CU4ALL
      l_is_present   number;           --Added by Milan Shah for CU4ALL
      l_max_vp       number;           --Added by Milan Shah for CU4ALL
      l_without_lin_flag  VARCHAR2(1); --Added by Milan Shah for CU4ALL
      l_lin_lic_number    NUMBER;
   BEGIN
      SELECT COUNT (1)
        INTO l_lic_count
        FROM x_cp_play_list
       WHERE     plt_bin_id = i_bin_id
             AND plt_lic_number = i_lic_number
             AND i_reg_code = plt_reg_code;

      IF l_lic_count > 0
      THEN
         raise_application_error (
            -20325,
               'Cannot delete as schedule is present for license '
            || i_lic_number
            || '.');
      END IF;

      SELECT bin_sch_number
        INTO v_sch_number
        FROM x_cp_schedule_bin
       WHERE bin_lic_number = i_lic_number AND bin_id = i_bin_id;

      IF SIGN (v_sch_number) = 1
      THEN
         /*CU4ALL START : ANUJA SHINDE*/
         DELETE FROM X_CP_PLT_SUBBOUQ_MAPP_TEMP
               WHERE CPST_PTB_ID IN
                        (SELECT PTBT_ID
                           FROM X_CP_PLAY_LIST_TEMP, X_CP_PLT_TERR_BOUQ_TEMP
                          WHERE     PLTT_ID = PTBT_PLT_ID
                                AND PLTT_BIN_ID = i_bin_id
                                AND PLTT_LIC_NUMBER = i_lic_number);


         DELETE FROM X_CP_PLT_DEVCOMP_RIGHTS_TEMP
               WHERE CDCR_PTBT_ID IN
                        (SELECT PTBT_ID
                           FROM X_CP_PLAY_LIST_TEMP, X_CP_PLT_TERR_BOUQ_TEMP
                          WHERE     PLTT_ID = PTBT_PLT_ID
                                AND PLTT_BIN_ID = i_bin_id
                                AND PLTT_LIC_NUMBER = i_lic_number);

         DELETE FROM X_CP_PLT_TERR_BOUQ_TEMP
               WHERE PTBT_PLT_ID IN
                        (SELECT PLTT_ID
                           FROM X_CP_PLAY_LIST_TEMP
                          WHERE PLTT_BIN_ID = i_bin_id
                                AND PLTT_LIC_NUMBER = i_lic_number);

         DELETE FROM X_CP_PLAY_LIST_TEMP
               WHERE PLTT_BIN_ID = I_BIN_ID
                     AND PLTT_LIC_NUMBER = i_lic_number;

         /*CU4ALL END*/
         UPDATE x_cp_schedule_bin
            SET on_schedule_grid = 'N',
                bin_modified_on = SYSDATE,
                bin_modified_by = i_entry_oper
          WHERE bin_lic_number = i_lic_number AND bin_id = i_bin_id;

        BEGIN
          SELECT sch_lic_number
            INTO l_lin_lic_number
            FROM fid_schedule
           WHERE sch_number = v_sch_number;
          
          SELECT nvl(lic_showing_int,0)
            INTO l_max_vp
            FROM fid_license
           WHERE lic_number = i_lic_number;
           
          SELECT TO_DATE (fim_year || fim_month, 'YYYYMM')
            INTO p_open_month
            FROM fid_financial_month
           WHERE fim_status = 'O' AND fim_split_region = i_reg_code;
        END;

        IF l_max_vp - x_pkg_cp_update_bin.x_fnc_utilized_lic_cnt (i_lic_number,p_open_month) > 0
        THEN
          SELECT COUNT (*)
            INTO l_is_present
            FROM x_cp_latest_bin_lic
           WHERE lbl_lic_number = l_lin_lic_number;

          IF l_is_present = 0
          THEN
            INSERT INTO x_cp_latest_bin_lic
            VALUES (X_SEQ_LBL_NUMBER.NEXTVAL, l_lin_lic_number, SYSDATE);
          ELSE
            UPDATE x_cp_latest_bin_lic
               SET lbl_entry_date = SYSDATE
             WHERE lbl_lic_number = l_lin_lic_number;
          END IF;
        END IF;
        
         IF SQL%ROWCOUNT = 0
         THEN
            raise_application_error (
               -20325,
               'Record already updated by another user, kindly refresh the screen.');
         END IF;
      ELSE
         /*CU4ALL START : ANUJA SHINDE*/
         /* delete from X_CP_PLT_SUBBOUQ_MAPP_TEMP
         where CPST_PTB_ID in (select PTBT_ID from X_CP_PLAY_LIST_TEMP,X_CP_PLT_TERR_BOUQ_TEMP
                            where PLTT_ID =  PTBT_PLT_ID
                            and  PLTT_BIN_ID = i_bin_id
                            AND PLTT_LIC_NUMBER = i_lic_number);


         delete from X_CP_PLT_DEVCOMP_RIGHTS_TEMP
          where CDCR_PTBT_ID in (select PTBT_ID from X_CP_PLAY_LIST_TEMP,X_CP_PLT_TERR_BOUQ_TEMP
                            where PLTT_ID =  PTBT_PLT_ID
                            and  PLTT_BIN_ID = i_bin_id
                            AND PLTT_LIC_NUMBER = i_lic_number );

           delete from X_CP_PLT_TERR_BOUQ_TEMP
            where PTBT_PLT_ID in (select PLTT_ID from X_CP_PLAY_LIST_TEMP
                            where PLTT_BIN_ID = i_bin_id
                            AND PLTT_LIC_NUMBER = i_lic_number);

           delete from X_CP_PLAY_LIST_TEMP
            where  PLTT_BIN_ID = i_bin_id
              AND  PLTT_LIC_NUMBER = i_lic_number;*/
         /*CU4ALL END*/

         DELETE FROM x_cp_schedule_bin
               WHERE bin_lic_number = i_lic_number AND bin_id = i_bin_id;

           --Added by Milan Shah For CU4ALL
      select nvl(LIC_showing_int,0),NVL(LIC_SCH_WITHOUT_LIN_REF,'N') into l_max_vp,l_without_lin_flag
      from fid_license
      where LIC_NUMBER=i_lic_number;

      SELECT TO_DATE (fim_year || fim_month, 'YYYYMM') INTO p_open_month
      FROM fid_financial_month
      WHERE fim_status = 'O' AND fim_split_region = i_reg_code;

      IF l_without_lin_flag = 'Y'
      THEN
          IF l_max_vp - X_PKG_CP_UPDATE_BIN.x_fnc_utilized_lic_cnt (i_lic_number,p_open_month) > 0
            THEN
                SELECT COUNT (*) INTO l_is_present
                FROM x_cp_latest_bin_lic
                WHERE lbl_lic_number = i_lic_number;

                IF l_is_present = 0
                THEN
                  INSERT INTO x_cp_latest_bin_lic
                  VALUES (X_SEQ_LBL_NUMBER.NEXTVAL, i_lic_number, SYSDATE);
                ELSE
                  UPDATE x_cp_latest_bin_lic
                  SET lbl_entry_Date = SYSDATE
                  WHERE lbl_lic_number = i_lic_number;
                END IF;
            END IF;
      END IF;
      --Ended by Milan Shah


         IF SQL%ROWCOUNT = 0
         THEN
            raise_application_error (
               -20325,
               'Record already updated by another user, kindly refresh the screen.');
         END IF;
      END IF;

      COMMIT;

      o_status := 1;
   END x_prc_delete_lic_from_grid;

   /****************************************************************
   CatchUp Schedule License
   ****************************************************************/
   PROCEDURE X_PRC_ADD_TO_PLAYLIST (
      i_lic_number              IN     NUMBER,
      i_reg_code                IN     NUMBER,
      i_bin_id                  IN     NUMBER,
      i_dev_ids                 IN     VARCHAR2,
      i_scr_dev                 IN     NUMBER,
      i_start_dates             IN     VARCHAR2,
      i_end_dates               IN     VARCHAR2,
      i_push_start_date         IN     DATE, -- Changes By Rashmi Tijare For CHP_CR3 PullVod
      i_pull_start_date         IN     DATE, -- Changes By Rashmi Tijare For CHP_CR3 PullVod
      i_push_end_date           IN     DATE,  -- Changes By Devashish Raverkar
      i_pull_end_date           IN     DATE,  -- Changes By Devashish Raverkar
      I_UPDATE_COUNT            IN     NUMBER,
      i_entry_oper              IN     VARCHAR2,
      --cu4all : start [ANUJA SHINDE]
      I_IS_DEVICE_CAP_CHECKED   IN     VARCHAR2,
      I_SCH_MONTH               IN     DATE,        /*for golive date impact*/
      I_IS_GRID_DATE_MODIFIED   IN     VARCHAR2,
      --CU4ALL : END
      O_STATUS                     OUT NUMBER)
   AS
      validation_exception   EXCEPTION;
      PRAGMA EXCEPTION_INIT (validation_exception, -20325);
      l_lic_sch_count        PLS_INTEGER;
      l_start_date           DATE;
      l_end_date             DATE;
      l_start_time           PLS_INTEGER;
      l_end_time             PLS_INTEGER;
      l_sch_number           PLS_INTEGER;
      l_bin_entry_date       DATE;
      already_updated        EXCEPTION;
      l_update_count         PLS_INTEGER;
      l_open_month           DATE;
      l_dev_ids              VARCHAR2 (100) := RTRIM (i_dev_ids, ',');
      l_update_flag          PLS_INTEGER;
      l_tba_count            PLS_INTEGER;
      l_min_start_date       DATE;
      l_max_end_date         DATE;
      l_sch_date             DATE;
      l_sch_end_date         DATE;
      o_prc_result           PLS_INTEGER;
      v_MDP_MAP_PLATM_CODE   X_CP_MEDIA_DEV_PLATM_MAP.MDP_MAP_PLATM_CODE%TYPE;
      L_EXP_START_DATE       DATE;
      L_EXP_END_DATE         DATE;
      L_EXP_SCH_PRESENT      PLS_INTEGER;
      --CU4ALL : START [ANUJA_SHINDE]
      L_PLT_ID_SEQ            NUMBER;
      L_CU4ALL_LIVE_DATE      DATE;
      L_CU4ALL_FLAG           varchar2(1);
      L_IS_SER                varchar2(1);
      l_bin_cnt number;
      l_max_vp number;
      l_is_present number;
      l_lin_lic_number  number;
      l_without_lin_flag    varchar2(1); --added by milan shah for CU4ALL
      p_open_month    date; --Added by Milan Shah for CU4ALL
   BEGIN
      L_ERROR_MESSAGE := NULL;


      --CU4ALL : START [ANUJA_SHINDE]

      SELECT "CONTENT"
        INTO L_CU4ALL_LIVE_DATE
        FROM X_FIN_CONFIGS
       WHERE "KEY" = 'CU4ALL_LIVE_DATE';



      IF TO_NUMBER (TO_CHAR (I_Sch_Month, 'RRRRMM')) >=
            TO_NUMBER (TO_CHAR (L_CU4ALL_LIVE_DATE, 'RRRRMM'))
      THEN
         L_CU4ALL_FLAG := 'Y';
      ELSE
         L_CU4ALL_FLAG := 'N';
      END IF;

      --CU4ALL : END

      SELECT MIN (TO_DATE (COLUMN_VALUE, 'DD-MM-RRRR HH24:MI:SS'))
        INTO l_min_start_date
        FROM TABLE (
                X_PKG_CP_SCH_GRID.split_to_char (RTRIM (i_start_dates, ','),
                                                 ','));

      SELECT MAX (TO_DATE (COLUMN_VALUE, 'DD-MM-RRRR HH24:MI:SS'))
        INTO l_max_end_date
        FROM TABLE (
                X_PKG_CP_SCH_GRID.split_to_char (RTRIM (i_end_dates, ','),
                                                 ','));

      X_PKG_CP_SCH_GRID.x_prc_modify_tba_cp_lic (i_lic_number,
                                                 i_bin_id,
                                                 l_min_start_date,
                                                 l_max_end_date,
                                                 o_prc_result);

      --cu4all : start [ANUJA SHINDE]

      IF L_CU4ALL_FLAG = 'Y'
      THEN
         UPDATE X_CP_PLT_TERR_BOUQ_TEMP
            SET PTBT_PLT_DEV_RIGHTS = 'N'--,PTBT_BOUQUET_RIGHTS = 'N'
                                         --,PTBT_TER_IE_FLAG = 'E'
                ,
                PTBT_PVR_START_DATE = NULL,
                PTBT_PVR_END_DATE = NULL,
                PTBT_OTT_START_DATE = NULL,
                PTBT_OTT_END_DATE = NULL
          WHERE PTBT_PLT_ID IN
                   (SELECT PLTT_ID
                      FROM X_CP_PLAY_LIST_TEMP
                     WHERE PLTT_LIC_NUMBER = I_LIC_NUMBER
                           AND PLTT_BIN_ID = I_BIN_ID
                           AND PLTT_DEV_ID NOT IN
                                  (SELECT COLUMN_VALUE
                                     FROM TABLE (
                                             X_PKG_CP_SCH_GRID.SPLIT_TO_CHAR (
                                                L_DEV_IDS,
                                                ','))));

         NULL;
      END IF;

      --CU4ALL : END

      FOR device
         IN (SELECT dev_id COLUMN_VALUE, dev_date_flag, dev_rw r
               FROM (SELECT COLUMN_VALUE dev_id, ROWNUM dev_rw
                       FROM TABLE (
                               X_PKG_CP_SCH_GRID.SPLIT_TO_CHAR (L_DEV_IDS,
                                                                ','))) DEV,
                    (SELECT COLUMN_VALUE dev_date_flag, ROWNUM date_rw
                       FROM TABLE (
                               X_PKG_CP_SCH_GRID.SPLIT_TO_CHAR (
                                  I_IS_GRID_DATE_MODIFIED,
                                  ','))) DEV_DATE_FLAG
              WHERE dev_rw = date_rw)
      LOOP
         IF device.COLUMN_VALUE IS NOT NULL
         THEN
            SELECT COUNT (1)
              INTO l_lic_sch_count
              FROM x_cp_play_list
             WHERE     plt_lic_number = i_lic_number
                   AND plt_bin_id = i_bin_id
                   AND plt_reg_code = i_reg_code
                   AND plt_dev_id = device.COLUMN_VALUE;

            SELECT TO_DATE (COLUMN_VALUE, 'DD-MM-RRRR HH24:MI:SS')
              INTO l_start_date
              FROM (SELECT COLUMN_VALUE, ROWNUM r
                      FROM TABLE (
                              X_PKG_CP_SCH_GRID.split_to_char (i_start_dates,
                                                               ',')))
             WHERE r = device.r;

            SELECT TO_DATE (COLUMN_VALUE, 'DD-MM-RRRR HH24:MI:SS')
              INTO l_end_date
              FROM (SELECT COLUMN_VALUE, ROWNUM r
                      FROM TABLE (
                              X_PKG_CP_SCH_GRID.split_to_char (i_end_dates,
                                                               ',')))
             WHERE r = device.r;

            l_start_time :=
               convert_time_c_n (TO_CHAR (l_start_date, 'HH24:MI:SS'));
            l_end_time :=
               convert_time_c_n (TO_CHAR (l_end_date, 'HH24:MI:SS'));

            SELECT bin_created_on, bin_sch_number
              INTO l_bin_entry_date, l_sch_number
              FROM x_cp_schedule_bin
             WHERE bin_id = i_bin_id;

            IF l_sch_number IS NULL
            THEN
               l_sch_number := X_SEQ_SCH_REFNUM.NEXTVAL;
            END IF;

            SELECT TO_DATE (fim_year || fim_month, 'RRRRMM')
              INTO l_open_month
              FROM fid_financial_month
             WHERE UPPER (fim_status) = 'O' AND fim_split_region = i_reg_code;


            SELECT bin_view_start_date
              INTO l_sch_date
              FROM x_cp_schedule_bin
             WHERE BIN_id = i_bin_id;

            SELECT bin_view_end_date
              INTO l_sch_end_date
              FROM x_cp_schedule_bin
             WHERE BIN_id = i_bin_id;

            l_update_flag := 0;

            IF l_lic_sch_count > 0
            THEN
               IF X_PKG_CP_SCH_GRID.x_fnc_lic_valid_check (
                     i_lic_number,
                     i_bin_id,
                     l_start_date,
                     l_end_date,
                     device.COLUMN_VALUE,
                     i_entry_oper) = 1
               THEN
                  IF l_start_date > l_end_date
                  THEN
                     l_error_message :=
                        'Schedule start date is greater than Schedule end date';
                     raise_application_error (
                        -20325,
                        'Schedule start date is greater than Schedule end date');
                  /* Validations added by Rashmi For Catchup Cr Start*/
                  /*ELSIF TRUNC (i_push_start_date) < TRUNC (l_sch_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PUSH Start Date can not be less than Schedule Avail Date From.');
                  ELSIF TRUNC (i_push_start_date) > TRUNC (l_sch_end_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PUSH Start Date can not be greater than Schedule Avail Date To.');
                  ELSIF TRUNC (i_pull_start_date) < TRUNC (l_sch_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PULL Start Date can not be less than Schedule Avail Date From.');
                  ELSIF TRUNC (i_pull_start_date) > TRUNC (l_sch_end_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PULL Start Date can not be greater than Schedule Avail Date From.');
                  ELSIF TRUNC (i_pull_start_date) < TRUNC (i_push_start_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PULL Start Date can not be less than PUSH Start Date for');*/
                  /* Validations added by Rashmi For Catchup Cr End*/
                  END IF;

                     UPDATE x_cp_play_list
                        SET plt_sch_start_date = l_start_date,
                            plt_sch_end_date = l_end_date,
                            plt_sch_from_time = l_start_time,
                            plt_sch_end_time = l_end_time,
                            /*plt_push_start_date = i_push_start_date, -- Added By Rashmi For Catchup Cr
                            plt_pull_start_date = i_pull_start_date, -- Added By Rashmi For Catchup Cr*/
                            plt_modified_by = i_entry_oper,
                            plt_modified_on = SYSDATE,
                            plt_update_count = NVL (plt_update_count, 0) + 1
                      WHERE     plt_lic_number = i_lic_number
                            AND plt_bin_id = i_bin_id
                            AND plt_reg_code = i_reg_code
                            AND plt_dev_id = device.COLUMN_VALUE
                  RETURNING plt_update_count
                       INTO l_update_count;

                  --CU4ALL : START [ANUJA SHINDE]
                  IF L_CU4ALL_FLAG = 'Y'
                  THEN
                     SELECT PLT_ID
                       INTO L_PLT_ID_SEQ
                       FROM X_CP_PLAY_LIST
                      WHERE     plt_lic_number = i_lic_number
                            AND plt_bin_id = i_bin_id
                            AND PLT_REG_CODE = I_REG_CODE
                            AND plt_dev_id = device.COLUMN_VALUE;


                     X_PRC_SCHEDULE_ON_TERR_BOUQ (I_BIN_ID,
                                                  i_lic_number,
                                                  l_plt_id_seq,
                                                  DEVICE.COLUMN_VALUE,
                                                  DEVICE.dev_date_flag,
                                                  L_START_DATE,
                                                  L_END_DATE,
                                                  I_PUSH_START_DATE,
                                                  I_PULL_START_DATE,
                                                  I_PUSH_END_DATE,
                                                  I_PULL_END_DATE,
                                                  L_START_TIME,
                                                  l_end_time,
                                                  I_ENTRY_OPER,
                                                  I_UPDATE_COUNT);

                     /*CU4ALL START :ANUJA SHINDE*/
                     SELECT X_FNC_GET_PROG_TYPE (LIC_BUDGET_CODE)
                       INTO L_IS_SER
                       FROM FID_LICENSE
                      WHERE LIC_NUMBER = I_LIC_NUMBER;

                     IF L_IS_SER = 'Y'
                     THEN
                        X_PRC_UPDATE_SUPERSTACK_SCH (I_BIN_ID,
                                                     i_lic_number,
                                                     l_plt_id_seq,
                                                     DEVICE.COLUMN_VALUE,
                                                     DEVICE.dev_date_flag,
                                                     L_START_DATE,
                                                     L_END_DATE,
                                                     I_PUSH_START_DATE,
                                                     I_PULL_START_DATE,
                                                     I_PUSH_END_DATE,
                                                     I_PULL_END_DATE,
                                                     L_START_TIME,
                                                     L_END_TIME);
                     END IF;
                  /*CU4ALL END */

                  END IF;

                  --CU4ALL : END

                  IF l_update_count = 0
                  THEN
                     RAISE already_updated;
                  END IF;

                  IF l_update_flag = 0
                  THEN
                     l_update_flag := 1;
                  END IF;
               END IF;
            ELSE
               IF X_PKG_CP_SCH_GRID.x_fnc_lic_valid_check (
                     i_lic_number,
                     i_bin_id,
                     l_start_date,
                     l_end_date,
                     device.COLUMN_VALUE,
                     i_entry_oper) = 1
               THEN
                  IF l_start_date > l_end_date
                  THEN
                     l_error_message :=
                        'Schedule start date is greater than Schedule end date';
                     raise_application_error (
                        -20325,
                        'Schedule start date is greater than Schedule end date');
                  /* Validations added by Rashmi For Catchup Cr Start*/
                  /*ELSIF TRUNC (i_push_start_date) < TRUNC (l_sch_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PUSH Start Date can not be less than Schedule Avail Date From.');
                  ELSIF TRUNC (i_push_start_date) > TRUNC (l_sch_end_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PUSH Start Date can not be greater than Schedule Avail Date To.');
                  ELSIF TRUNC (i_pull_start_date) < TRUNC (l_sch_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PULL Start Date can not be less than Schedule Avail Date From.');
                  ELSIF TRUNC (i_pull_start_date) > TRUNC (l_sch_end_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PULL Start Date can not be greater than Schedule Avail Date From.');
                  ELSIF TRUNC (i_pull_start_date) < TRUNC (i_push_start_date)
                  THEN
                     raise_application_error (
                        -20325,
                        'PULL Start Date can not be less than PUSH Start Date for');*/
                  /* Validations added by Rashmi For Catchup Cr End*/
                  END IF;

                  BEGIN
                     SELECT MDP_MAP_PLATM_CODE
                       INTO v_MDP_MAP_PLATM_CODE
                       FROM X_CP_MEDIA_DEV_PLATM_MAP
                      WHERE MDP_MAP_DEV_ID = device.COLUMN_VALUE;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        L_Error_Message :=
                           'Device map id is not found for device - '
                           || Device.COLUMN_VALUE;
                        raise_application_error (
                           -20325,
                           'Device map id is not found for device - '
                           || device.COLUMN_VALUE);
                  END;

                  --CU4ALL : START [ANUJA_SHINDE]
                  L_PLT_ID_SEQ := X_SEQ_PLAY_LIST.NEXTVAL;

                  INSERT INTO x_cp_play_list (plt_id,
                                              plt_reg_code,
                                              plt_plat_code,
                                              plt_lic_number,
                                              plt_sch_number,
                                              plt_sch_start_date,
                                              plt_sch_end_date,
                                              /*plt_push_start_date, -- Changes By Rashmi Tijare For CHP_CR3 PullVod
                                              plt_pull_start_date, -- Changes By Rashmi Tijare For CHP_CR3 PullVod*/
                                              plt_sch_from_time,
                                              plt_sch_end_time,
                                              plt_sch_type,
                                              plt_bin_id,
                                              plt_bin_added_date,
                                              plt_update_count,
                                              plt_created_by,
                                              plt_created_on,
                                              plt_modified_by,
                                              PLT_MODIFIED_ON,
                                              PLT_DEV_ID,
                                              PLT_LICENSE_FLAG)
                       VALUES (l_plt_id_seq,
                               i_reg_code,
                               v_MDP_MAP_PLATM_CODE,
                               i_lic_number,
                               l_sch_number,
                               l_start_date,
                               l_end_date,
                               /*i_push_start_date, -- Changes By Rashmi Tijare For CHP_CR3 PullVod Start
                               i_pull_start_date, -- Changes By Rashmi Tijare For CHP_CR3 PullVod Start*/
                               l_start_time,
                               l_end_time,
                               'P',
                               i_bin_id,
                               l_bin_entry_date,
                               0,
                               i_entry_oper,
                               SYSDATE,
                               NULL,
                               NULL,
                               DEVICE.COLUMN_VALUE,
                               --'Y' commented ver 1.0
                               (SELECT lic_catchup_flag
                                  FROM fid_license
                                 WHERE lic_number = i_lic_number) --ver 1.0 added
                                                                 );

                  --CU4ALL : START [ANUJA SHINDE]
                  IF L_CU4ALL_FLAG = 'Y'
                  THEN
                     X_PRC_SCHEDULE_ON_TERR_BOUQ (I_BIN_ID,
                                                  i_lic_number,
                                                  l_plt_id_seq,
                                                  DEVICE.COLUMN_VALUE,
                                                  DEVICE.dev_date_flag,
                                                  L_START_DATE,
                                                  L_END_DATE,
                                                  I_PUSH_START_DATE,
                                                  I_PULL_START_DATE,
                                                  I_PUSH_END_DATE,
                                                  I_PULL_END_DATE,
                                                  L_START_TIME,
                                                  l_end_time,
                                                  I_ENTRY_OPER,
                                                  I_UPDATE_COUNT);
                  END IF;

                  /*CU4ALL START :ANUJA SHINDE*/
                  SELECT X_FNC_GET_PROG_TYPE (LIC_BUDGET_CODE)
                    INTO L_IS_SER
                    FROM FID_LICENSE
                   WHERE LIC_NUMBER = I_LIC_NUMBER;

                  IF L_IS_SER = 'Y'
                  THEN
                     X_PRC_UPDATE_SUPERSTACK_SCH (I_BIN_ID,
                                                  i_lic_number,
                                                  l_plt_id_seq,
                                                  DEVICE.COLUMN_VALUE,
                                                  DEVICE.dev_date_flag,
                                                  L_START_DATE,
                                                  L_END_DATE,
                                                  I_PUSH_START_DATE,
                                                  I_PULL_START_DATE,
                                                  I_PUSH_END_DATE,
                                                  I_PULL_END_DATE,
                                                  L_START_TIME,
                                                  L_END_TIME);
                  END IF;

                  /*CU4ALL END */
                  --CU4ALL : END

                  IF l_update_flag = 0
                  THEN
                     l_update_flag := 1;
                  END IF;
               END IF;
            END IF;
         END IF;
      END LOOP;

      --Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/05]
      --Bouquet Auto-Scheduling
      IF L_CU4ALL_FLAG = 'N'
      THEN
         x_pkg_cp_manage_bouquet.x_prc_cp_auto_bqt_sch (i_lic_number,
                                                        I_BIN_ID,
                                                        l_sch_number,
                                                        O_PRC_RESULT);
      END IF;

      --Dev.R14 : Catchup 4 All Intrim : End

          /*IF l_dev_ids IS NOT NULL OR l_dev_ids <> ''
THEN
  DELETE FROM x_cp_play_list
  WHERE plt_lic_number = i_lic_number
  AND plt_bin_id = i_bin_id
  AND plt_reg_code = i_reg_code
  AND plt_dev_id NOT IN (SELECT COLUMN_VALUE FROM TABLE(X_PKG_CP_SCH_GRID.split_to_char(l_dev_ids,',')));
ELSE
  DELETE FROM x_cp_play_list
  WHERE plt_lic_number = i_lic_number
  AND plt_bin_id = i_bin_id
  AND plt_reg_code = i_reg_code;
END IF;*/

      IF NVL (i_scr_dev, 0) = 0
      THEN
         IF l_dev_ids IS NOT NULL OR l_dev_ids <> ''
         THEN
            --CU4ALL : START : ANUJA SHINDE
            IF L_CU4ALL_FLAG = 'Y'
            THEN
               DELETE FROM X_CP_PLT_DEVCOMP_RIGHTS
                     WHERE CDCR_PTBT_ID IN
                              (SELECT PTB_ID
                                 FROM X_CP_PLAY_LIST, X_CP_PLT_TERR_BOUQ
                                WHERE     PLT_ID = PTB_PLT_ID
                                      AND PLT_LIC_NUMBER = i_lic_number
                                      AND PLT_BIN_ID = I_BIN_ID
                                      AND plt_dev_id NOT IN
                                             (SELECT COLUMN_VALUE
                                                FROM TABLE (
                                                        X_PKG_CP_SCH_GRID.split_to_char (
                                                           l_dev_ids,
                                                           ','))));

               DELETE FROM X_CP_PLT_DEV_SUBBOUQ_MAPP
                     WHERE CPS_PTB_ID IN
                              (SELECT PTB_ID
                                 FROM X_CP_PLAY_LIST, X_CP_PLT_TERR_BOUQ
                                WHERE     PLT_ID = PTB_PLT_ID
                                      AND PLT_LIC_NUMBER = i_lic_number
                                      AND PLT_BIN_ID = I_BIN_ID
                                      AND PLT_DEV_ID NOT IN
                                             (SELECT COLUMN_VALUE
                                                FROM TABLE (
                                                        X_PKG_CP_SCH_GRID.split_to_char (
                                                           l_dev_ids,
                                                           ','))));

               DELETE FROM X_CP_PLT_TERR_BOUQ
                     WHERE PTB_PLT_ID IN
                              (SELECT PLT_ID
                                 FROM X_CP_PLAY_LIST
                                WHERE PLT_LIC_NUMBER = i_lic_number
                                      AND PLT_BIN_ID = I_BIN_ID
                                      AND plt_dev_id NOT IN
                                             (SELECT COLUMN_VALUE
                                                FROM TABLE (
                                                        X_PKG_CP_SCH_GRID.split_to_char (
                                                           l_dev_ids,
                                                           ','))));
            END IF;

            --CU4ALL : END

            DELETE FROM x_cp_play_list
                  WHERE     plt_lic_number = i_lic_number
                        AND plt_bin_id = i_bin_id
                        AND plt_reg_code = i_reg_code
                        AND plt_dev_id NOT IN
                               (SELECT COLUMN_VALUE
                                  FROM TABLE (
                                          X_PKG_CP_SCH_GRID.split_to_char (
                                             l_dev_ids,
                                             ',')));
         ELSE
            --CU4ALL : START : ANUJA SHINDE
            IF L_CU4ALL_FLAG = 'Y'
            THEN
               DELETE FROM X_CP_PLT_DEVCOMP_RIGHTS
                     WHERE CDCR_PTBT_ID IN
                              (SELECT PTB_ID
                                 FROM X_CP_PLAY_LIST, X_CP_PLT_TERR_BOUQ
                                WHERE     PLT_ID = PTB_PLT_ID
                                      AND PLT_LIC_NUMBER = i_lic_number
                                      AND PLT_BIN_ID = I_BIN_ID);

               DELETE FROM X_CP_PLT_DEV_SUBBOUQ_MAPP
                     WHERE CPS_PTB_ID IN
                              (SELECT PTB_ID
                                 FROM X_CP_PLAY_LIST, X_CP_PLT_TERR_BOUQ
                                WHERE     PLT_ID = PTB_PLT_ID
                                      AND PLT_LIC_NUMBER = i_lic_number
                                      AND PLT_BIN_ID = I_BIN_ID);

               UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                  SET PTBT_PLT_DEV_RIGHTS = 'N'--,PTBT_BOUQUET_RIGHTS = 'N'
                                               --,PTBT_TER_IE_FLAG = 'E'
                      ,
                      PTBT_PVR_START_DATE = NULL,
                      PTBT_PVR_END_DATE = NULL,
                      PTBT_OTT_START_DATE = NULL,
                      PTBT_OTT_END_DATE = NULL
                WHERE PTBT_PLT_ID IN
                         (SELECT PLTT_ID
                            FROM X_CP_PLAY_LIST_TEMP
                           WHERE PLTT_LIC_NUMBER = I_LIC_NUMBER
                                 AND PLTT_BIN_ID = I_BIN_ID);


               DELETE FROM X_CP_PLT_TERR_BOUQ
                     WHERE PTB_PLT_ID IN
                              (SELECT PLT_ID
                                 FROM X_CP_PLAY_LIST
                                WHERE PLT_LIC_NUMBER = i_lic_number
                                      AND PLT_BIN_ID = I_BIN_ID);
            END IF;

            --CU4ALL : END

            DELETE FROM x_cp_play_list
                  WHERE     plt_lic_number = i_lic_number
                        AND plt_bin_id = i_bin_id
                        AND plt_reg_code = i_reg_code;
         END IF;
      ELSE
         IF NVL (l_dev_ids, 0) = 0
         THEN
            --CU4ALL : START : ANUJA SHINDE
            IF L_CU4ALL_FLAG = 'Y'
            THEN
               DELETE FROM X_CP_PLT_DEVCOMP_RIGHTS
                     WHERE CDCR_PTBT_ID IN
                              (SELECT PTB_ID
                                 FROM X_CP_PLAY_LIST, X_CP_PLT_TERR_BOUQ
                                WHERE     PLT_ID = PTB_PLT_ID
                                      AND PLT_LIC_NUMBER = I_LIC_NUMBER
                                      AND PLT_BIN_ID = I_BIN_ID
                                      AND plt_dev_id = i_scr_dev);

               DELETE FROM X_CP_PLT_DEV_SUBBOUQ_MAPP
                     WHERE CPS_PTB_ID IN
                              (SELECT PTB_ID
                                 FROM X_CP_PLAY_LIST, X_CP_PLT_TERR_BOUQ
                                WHERE     PLT_ID = PTB_PLT_ID
                                      AND PLT_LIC_NUMBER = I_LIC_NUMBER
                                      AND PLT_BIN_ID = I_BIN_ID
                                      AND plt_dev_id = i_scr_dev);

               DELETE FROM X_CP_PLT_TERR_BOUQ
                     WHERE PTB_PLT_ID IN
                              (SELECT PLT_ID
                                 FROM X_CP_PLAY_LIST
                                WHERE     PLT_LIC_NUMBER = i_lic_number
                                      AND PLT_BIN_ID = I_BIN_ID
                                      AND plt_dev_id = i_scr_dev);
            END IF;

            --CU4ALL : END

            DELETE FROM x_cp_play_list
                  WHERE     plt_lic_number = i_lic_number
                        AND plt_bin_id = i_bin_id
                        AND plt_reg_code = i_reg_code
                        AND plt_dev_id = i_scr_dev;
         END IF;
      END IF;

      --Start : Update PUSH/PULL VOD Start and End Date with Validation : [Devashish Raverkar]_[2015/07/15]
      BEGIN
         SELECT plt_sch_start_date, plt_sch_end_date
           INTO l_exp_start_date, l_exp_end_date
           FROM x_cp_play_list
          WHERE     plt_lic_number = i_lic_number
                AND plt_bin_id = i_bin_id
                AND plt_reg_code = i_reg_code
                AND plt_dev_id = (SELECT md_id
                                    FROM x_cp_media_device
                                   WHERE md_code = 'EXP');

         l_exp_sch_present := 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_exp_sch_present := 0;
      END;

      IF l_exp_sch_present <> 0
      THEN
         IF i_push_start_date < l_exp_start_date
         THEN
            L_Error_Message :=
               'PUSH Start Date can not be less than device Schedule Start Date';
            raise_application_error (
               -20325,
               'PUSH Start Date can not be less than device Schedule Start Date');
         ELSIF i_push_start_date > l_exp_end_date
         THEN
            L_Error_Message :=
               'PUSH Start Date can not be greater than device Schedule End Date';
            raise_application_error (
               -20325,
               'PUSH Start Date can not be greater than device Schedule End Date');
         ELSIF i_pull_start_date < l_exp_start_date
         THEN
            L_Error_Message :=
               'PULL Start Date can not be less than device Schedule Start Date';
            raise_application_error (
               -20325,
               'PULL Start Date can not be less than device Schedule Start Date');
         ELSIF i_pull_start_date > l_exp_end_date
         THEN
            L_Error_Message :=
               'PULL Start Date can not be greater than device Schedule End Date';
            raise_application_error (
               -20325,
               'PULL Start Date can not be greater than device Schedule End Date');
         ELSIF i_push_start_date > i_push_end_date
         THEN
            L_Error_Message :=
               'PUSH Start Date can not be greater than PUSH End Date';
            raise_application_error (
               -20325,
               'PUSH Start Date can not be greater than PUSH End Date');
         ELSIF i_pull_start_date > i_pull_end_date
         THEN
            L_Error_Message :=
               'PULL Start Date can not be greater than PULL End Date';
            raise_application_error (
               -20325,
               'PULL Start Date can not be greater than PULL End Date');
         ELSIF i_push_end_date > l_exp_end_date
         THEN
            L_Error_Message :=
               'PUSH End Date can not be greater than device Schedule End Date';
            raise_application_error (
               -20325,
               'PUSH End Date can not be greater than device Schedule End Date');
         ELSIF i_pull_end_date > l_exp_end_date
         THEN
            L_Error_Message :=
               'PULL End Date can not be greater than device Schedule End Date';
            raise_application_error (
               -20325,
               'PULL End Date can not be greater than device Schedule End Date');
         END IF;

         UPDATE x_cp_play_list
            SET plt_push_start_date = i_push_start_date,
                plt_pull_start_date = i_pull_start_date,
                plt_push_end_date = i_push_end_date,
                plt_pull_end_date = i_pull_end_date
          WHERE     plt_lic_number = i_lic_number
                AND plt_bin_id = i_bin_id
                AND plt_reg_code = i_reg_code;
      END IF;

      --End : Update PUSH/PULL VOD Start and End Date with Validation

      X_PKG_CP_SCH_GRID.x_prc_modify_tba_cp_lic_no_sch (i_lic_number,
                                                        i_bin_id,
                                                        o_prc_result);

      O_STATUS := 1;
      --Added by Milan Shah For CU4ALL
      select nvl(LIC_showing_int,0),NVL(LIC_SCH_WITHOUT_LIN_REF,'N') into l_max_vp,l_without_lin_flag
      from fid_license
      where LIC_NUMBER=i_lic_number;

      SELECT TO_DATE (fim_year || fim_month, 'YYYYMM') INTO p_open_month
      FROM fid_financial_month
      WHERE fim_status = 'O' AND fim_split_region = i_reg_code;

      IF l_without_lin_flag = 'N'
      THEN
          select count(1) into l_bin_cnt
          from X_CP_SCHEDULE_BIN
          where BIN_LIC_NUMBER = i_lic_number;

          BEGIN
            select sch_lic_number into l_lin_lic_number
            from x_cp_schedule_bin
                 ,fid_schedule
            where bin_id = i_bin_id
                  and sch_number = bin_sch_number;
            EXCEPTION WHEN NO_DATA_FOUND THEN
            l_lin_lic_number := 0;
          END;

          IF l_lin_lic_number <> 0
          THEN
              IF l_bin_cnt>1 and l_max_vp=2
              THEN
                  SELECT COUNT (*) INTO l_is_present
                  FROM x_cp_latest_bin_lic
                  WHERE lbl_lic_number = l_lin_lic_number;

                  IF l_is_present = 0
                  THEN
                      INSERT INTO x_cp_latest_bin_lic
                      VALUES (X_SEQ_LBL_NUMBER.NEXTVAL, l_lin_lic_number, SYSDATE);
                  ELSE
                      UPDATE x_cp_latest_bin_lic
                      SET lbl_entry_Date = SYSDATE
                      WHERE lbl_lic_number = l_lin_lic_number;
                  END IF;
              END IF;
          END IF;
      ELSE
          IF l_max_vp - X_PKG_CP_UPDATE_BIN.x_fnc_utilized_lic_cnt (i_lic_number,p_open_month) > 0
            THEN
                SELECT COUNT (*) INTO l_is_present
                FROM x_cp_latest_bin_lic
                WHERE lbl_lic_number = i_lic_number;

                IF l_is_present = 0
                THEN
                  INSERT INTO x_cp_latest_bin_lic
                  VALUES (X_SEQ_LBL_NUMBER.NEXTVAL, i_lic_number, SYSDATE);
                ELSE
                  UPDATE x_cp_latest_bin_lic
                  SET lbl_entry_Date = SYSDATE
                  WHERE lbl_lic_number = i_lic_number;
                END IF;
            END IF;
      END IF;
      --Ended by Milan Shah
      commit;
  EXCEPTION
      WHEN already_updated
      THEN
         ROLLBACK;
         raise_application_error (
            -20338,
            'Record already updated, please refresh the screen');
      WHEN validation_exception
      THEN
         ROLLBACK;
         RAISE_APPLICATION_ERROR (-20338, SUBSTR (SQLERRM, 1, 300));
      WHEN OTHERS
      THEN
         ROLLBACK;
         O_Status := -1;

         IF l_error_message IS NOT NULL
         THEN
            Raise_Application_Error (-20338, l_error_message);
         ELSE
            RAISE_APPLICATION_ERROR (-20338, SUBSTR (SQLERRM, 1, 300));
         END IF;
   END x_prc_add_to_playlist;

   PROCEDURE X_PRC_UPDATE_SUPERSTACK_SCH (I_BIN_ID            IN NUMBER,
                                          I_BIN_LIC_NUMBER    IN NUMBER,
                                          I_PLT_ID            IN NUMBER,
                                          I_DEV_ID            IN NUMBER,
                                          I_DEV_GRID_FLAG     IN VARCHAR2,
                                          I_START_DATE        IN DATE,
                                          I_END_DATE          IN DATE,
                                          I_PUSH_START_DATE   IN DATE,
                                          I_PULL_START_DATE   IN DATE,
                                          I_PUSH_END_DATE     IN DATE,
                                          i_pull_end_date     IN DATE,
                                          I_START_TIME        IN NUMBER,
                                          I_END_TIME          IN NUMBER)
   AS
      L_IS_SS_RYTS       NUMBER;
      L_SS_AVAIL_FROM    DATE;
      L_SS_AVAIL_TO      DATE;
      L_GEN_SER_NUMBER   NUMBER;
      L_LIC_LEE_NUMBER   NUMBER;
      L_DEL_METHOD       VARCHAR2 (100);
      l_lic_con_number   number;
      l_BIN_SCH_NUMBER   number;
      l_bouq_premier     varchar2(1);
   BEGIN
      SELECT GEN_SER_NUMBER, LIC_LEE_NUMBER , lic_con_number
        INTO l_gen_ser_number, l_LIC_LEE_NUMBER,l_lic_con_number
        FROM FID_LICENSE, FID_GENERAL
       WHERE GEN_REFNO = LIC_GEN_REFNO AND LIC_NUMBER = I_BIN_LIC_NUMBER;

      SELECT COUNT (1)
        INTO L_IS_SS_RYTS
        FROM X_CP_PLT_TERR_BOUQ, X_CP_PLAY_LIST
       WHERE     PLT_ID = PTB_PLT_ID
             AND PLT_LIC_NUMBER = I_BIN_LIC_NUMBER
             AND PLT_BIN_ID = I_BIN_ID
             AND PTB_BOUQ_SUPERS_RIGHTS = 'Y';

      SELECT BIN_SUPERSTACK_AVAIL_FROM, BIN_SUPERSTACK_AVAIL_TO,BIN_SCH_NUMBER
        INTO L_SS_AVAIL_FROM, L_SS_AVAIL_TO,l_BIN_SCH_NUMBER
        FROM X_CP_SCHEDULE_BIN
       WHERE BIN_LIC_NUMBER = I_BIN_LIC_NUMBER AND bin_id = I_BIN_ID;

      SELECT X_PKG_CP_UPDATE_BIN.x_fnc_is_premier_sch_on_bouq((SELECT sch_lic_number from fid_schedule where sch_number = l_BIN_SCH_NUMBER)
                                                ,l_BIN_SCH_NUMBER
                                                ,(select sch_cha_number from fid_schedule where sch_number = l_BIN_SCH_NUMBER)) INTO l_bouq_premier FROM DUAL;

      -- SELECT X_FUN_GET_lic_DELIEVERY_METHOD(I_DEV_ID,I_BIN_LIC_NUMBER ) INTO L_DEL_METHOD FROM DUAL;

      IF L_IS_SS_RYTS > 0 AND l_bouq_premier = 'Y'
      THEN
         FOR L_SS_SCH /*Loop to update actual table entries*/
            IN (SELECT PLT_ID,
                       PLT_LIC_NUMBER,
                       PLT_BIN_ID,
                       PLT_PULL_END_DATE,
                       PLT_SCH_END_DATE,
                       PTB_BOUQUET_ID,
                       PTB_OTT_END_DATE,
                       PTB_PLT_ID,
                       PTB_TER_CODE,
                       PTB_PVR_END_DATE,
                       PLT_PUSH_END_DATE
                  FROM FID_LICENSE,
                       FID_GENERAL,
                       X_CP_PLAY_LIST,
                       X_CP_PLT_TERR_BOUQ
                 WHERE     GEN_REFNO = LIC_GEN_REFNO
                       AND PLT_LIC_NUMBER = LIC_NUMBER
                       AND PLT_ID = PTB_PLT_ID
                       AND GEN_SER_NUMBER = l_gen_ser_number
                       AND LIC_CATCHUP_FLAG = 'Y'
                       AND LIC_NUMBER <> I_BIN_LIC_NUMBER
                       AND TRUNC (PLT_SCH_END_DATE) >= TRUNC (SYSDATE)
                       AND LIC_LEE_NUMBER = L_LIC_LEE_NUMBER
                       AND PTB_BOUQ_SUPERS_RIGHTS = 'Y'
                       AND PLT_BIN_ID IN (SELECT BIN_ID FROM X_CP_SCHEDULE_BIN
                                           where BIN_LIC_NUMBER in (SELECT lic_number
                                                                    FROM fid_license
                                                                    where lic_catchup_flag IN ('Y','C')
                                                                          AND lic_con_number =l_lic_con_number
                                                                          AND lic_gen_refno in (select gen_refno
                                                                                                from fid_general,
                                                                                                      (SELECT gen_ser_number ser_number,gen_epi_number epi_number
                                                                                                       from fid_schedule
                                                                                                            ,fid_general
                                                                                                        where sch_number = l_BIN_SCH_NUMBER
                                                                                                              and gen_refno = sch_gen_Refno
                                                                                                      )sch
                                                                                                where gen_ser_number = sch.ser_number
                                                                                                      and gen_epi_number <=sch.epi_number
                                                                                                )
                                                                      )
                                                AND X_PKG_CP_UPDATE_BIN.x_fnc_is_premier_sch_on_bouq((SELECT sch_lic_number from fid_schedule where sch_number = bin_sch_number)
                                                ,bin_sch_number,
                                                (select sch_cha_number from fid_schedule where sch_number = l_BIN_SCH_NUMBER)) = 'Y')
                                                )
         LOOP
            IF L_SS_SCH.PLT_PULL_END_DATE IS NULL
               AND L_SS_SCH.PLT_PUSH_END_DATE IS NULL  /* for normal devices*/
            THEN /*update ott en dates only when schedule on both pvr and ott or only ott*/
               UPDATE X_CP_PLAY_LIST
                  SET PLT_SCH_END_DATE = I_END_DATE,
                      PLT_SCH_END_TIME = convert_time_c_n(to_char(I_END_DATE,'HH24:MI:SS'))
                WHERE     PLT_ID = L_SS_SCH.PLT_ID
                      AND PLT_LIC_NUMBER = L_SS_SCH.PLT_LIC_NUMBER
                      AND PLT_BIN_ID = L_SS_SCH.PLT_BIN_ID;

               UPDATE X_CP_PLT_TERR_BOUQ
                  SET PTB_OTT_END_DATE = I_END_DATE,
                      PTB_SCH_OTT_END_TIME = convert_time_c_n(to_char(I_END_DATE,'HH24:MI:SS'))
                WHERE     PTB_BOUQUET_ID = L_SS_SCH.PTB_BOUQUET_ID
                      AND PTB_TER_CODE = L_SS_SCH.PTB_TER_CODE
                      AND PTB_PLT_ID = L_SS_SCH.PTB_PLT_ID
                      AND PTB_OTT_END_DATE IS NOT NULL;

               /*update ott en dates only when schedule only on pvr*/
               UPDATE X_CP_PLT_TERR_BOUQ
                  SET PTB_PVR_END_DATE = I_END_DATE,
                      PTB_SCH_PVR_END_TIME = convert_time_c_n(to_char(I_END_DATE,'HH24:MI:SS'))
                WHERE     PTB_BOUQUET_ID = L_SS_SCH.PTB_BOUQUET_ID
                      AND PTB_TER_CODE = L_SS_SCH.PTB_TER_CODE
                      AND PTB_PLT_ID = L_SS_SCH.PTB_PLT_ID
                      AND PTB_PVR_END_DATE IS NOT NULL
                      AND PTB_OTT_END_DATE IS NULL;
            ELSIF L_SS_SCH.PLT_PULL_END_DATE IS NOT NULL /* for both compatible devices like explora*/
            THEN
               UPDATE X_CP_PLAY_LIST
                  SET PLT_PULL_END_DATE = I_END_DATE,
                      PLT_SCH_END_DATE = I_END_DATE,
                      PLT_SCH_END_TIME = convert_time_c_n(to_char(I_END_DATE,'HH24:MI:SS'))
                WHERE     PLT_ID = L_SS_SCH.PLT_ID
                      AND PLT_LIC_NUMBER = L_SS_SCH.PLT_LIC_NUMBER
                      AND PLT_BIN_ID = L_SS_SCH.PLT_BIN_ID;

               UPDATE X_CP_PLT_TERR_BOUQ
                  SET PTB_OTT_END_DATE = I_END_DATE,
                      PTB_SCH_OTT_END_TIME = convert_time_c_n(to_char(I_END_DATE,'HH24:MI:SS'))
                WHERE     PTB_BOUQUET_ID = L_SS_SCH.PTB_BOUQUET_ID
                      AND PTB_TER_CODE = L_SS_SCH.PTB_TER_CODE
                      AND PTB_PLT_ID = L_SS_SCH.PTB_PLT_ID;
            ELSIF L_SS_SCH.PLT_PULL_END_DATE IS NULL
                  AND L_SS_SCH.PLT_PUSH_END_DATE IS NOT NULL
            THEN
               UPDATE X_CP_PLAY_LIST
                  SET PLT_PUSH_END_DATE = I_END_DATE,
                      PLT_SCH_END_DATE = I_END_DATE,
                      PLT_SCH_END_TIME = convert_time_c_n(to_char(I_END_DATE,'HH24:MI:SS'))
                WHERE     PLT_ID = L_SS_SCH.PLT_ID
                      AND PLT_LIC_NUMBER = L_SS_SCH.PLT_LIC_NUMBER
                      AND PLT_BIN_ID = L_SS_SCH.PLT_BIN_ID;

               UPDATE X_CP_PLT_TERR_BOUQ
                  SET PTB_PVR_END_DATE = I_END_DATE,
                      PTB_SCH_PVR_END_TIME = convert_time_c_n(to_char(I_END_DATE,'HH24:MI:SS'))
                WHERE     PTB_BOUQUET_ID = L_SS_SCH.PTB_BOUQUET_ID
                      AND PTB_TER_CODE = L_SS_SCH.PTB_TER_CODE
                      AND PTB_PLT_ID = L_SS_SCH.PTB_PLT_ID;
            /* ELSE
              update   X_CP_PLAY_LIST
                   set   PLT_SCH_END_DATE = I_END_DATE
                 where   PLT_ID         = L_SS_SCH.PLT_ID
                   and   PLT_LIC_NUMBER = L_SS_SCH.PLT_LIC_NUMBER
                   and   PLT_BIN_ID     = L_SS_SCH.PLT_BIN_ID;*/
            END IF;
         END LOOP;

         FOR L_TEMP_SS_SCH IN
         (
            SELECT  PTBT_ID,
                    PLTT_LIC_NUMBER,
                    PLTT_BIN_ID,
                    PTBT_BOUQUET_ID,
                    PTBT_PLT_ID,
                    PTBT_TER_CODE,
                    PTBT_PVR_END_DATE,
                    PTBT_OTT_END_DATE
            FROM
                    FID_LICENSE,
                    FID_GENERAL,
                    X_CP_PLAY_LIST_TEMP,
                    X_CP_PLT_TERR_BOUQ_TEMP
            WHERE
                    GEN_REFNO = LIC_GEN_REFNO
                    AND PLTT_LIC_NUMBER = LIC_NUMBER
                    AND PLTT_ID = PTBT_PLT_ID
                    AND GEN_SER_NUMBER = l_gen_ser_number
                    AND LIC_CATCHUP_FLAG = 'Y'
                    AND LIC_NUMBER <> I_BIN_LIC_NUMBER
                    AND LIC_LEE_NUMBER = L_LIC_LEE_NUMBER
                    AND PTBT_BOUQ_SUPERS_RIGHTS = 'Y'
                    AND PLTT_BIN_ID IN (SELECT BIN_ID FROM X_CP_SCHEDULE_BIN
                                           where BIN_LIC_NUMBER in (SELECT lic_number
                                                                    FROM fid_license
                                                                    where lic_catchup_flag IN ('Y','C')
                                                                          AND lic_con_number = l_lic_con_number
                                                                          AND lic_gen_refno in (select gen_refno
                                                                                                from fid_general,
                                                                                                      (SELECT gen_ser_number ser_number,gen_epi_number epi_number
                                                                                                       from fid_schedule
                                                                                                            ,fid_general
                                                                                                        where sch_number = l_BIN_SCH_NUMBER
                                                                                                              and gen_refno = sch_gen_Refno
                                                                                                      )sch
                                                                                                where gen_ser_number = sch.ser_number
                                                                                                      and gen_epi_number <=sch.epi_number
                                                                                                )
                                                                      )
                                                AND X_PKG_CP_UPDATE_BIN.x_fnc_is_premier_sch_on_bouq((SELECT sch_lic_number from fid_schedule where sch_number = bin_sch_number)
                                                ,bin_sch_number,
                                                (select sch_cha_number from fid_schedule where sch_number = l_BIN_SCH_NUMBER)) = 'Y')
         )
         LOOP


                      UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                        SET PTBT_OTT_END_DATE = I_END_DATE,
                            PTBT_SCH_OTT_END_TIME = convert_time_c_n(to_char(I_END_DATE,'HH24:MI:SS'))
                      WHERE
                            PTBT_ID = L_TEMP_SS_SCH.PTBT_ID
                            AND PTBT_OTT_END_DATE IS NOT NULL;
                            --PTBT_BOUQUET_ID = L_TEMP_SS_SCH.PTBT_BOUQUET_ID
                            --AND PTB_TER_CODE = L_TEMP_SS_SCH.PTBT_TER_CODE
                            --AND PTB_PLT_ID = L_SS_SCH.PTB_PLT_ID

                     UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                        SET PTBT_PVR_END_DATE = I_END_DATE,
                            PTBT_SCH_PVR_END_TIME = convert_time_c_n(to_char(I_END_DATE,'HH24:MI:SS'))
                      WHERE
                            PTBT_ID = L_TEMP_SS_SCH.PTBT_ID
                            AND PTBT_PVR_END_DATE IS NOT NULL
                            AND PTBT_OTT_END_DATE IS NULL;
                            --PTB_BOUQUET_ID = L_SS_SCH.PTB_BOUQUET_ID
                            --AND PTB_TER_CODE = L_SS_SCH.PTB_TER_CODE
                            --AND PTB_PLT_ID = L_SS_SCH.PTB_PLT_ID

         END LOOP;
      END IF;
   END X_PRC_UPDATE_SUPERSTACK_SCH;

   /****************************************************************
   License Modification for TBA License
   ****************************************************************/
   PROCEDURE x_prc_modify_tba_cp_lic (i_lic_number   IN     NUMBER,
                                      i_bin_id       IN     NUMBER,
                                      i_start_date   IN     DATE,
                                      i_end_date     IN     DATE,
                                      o_status          OUT NUMBER)
   AS
      l_lic_sch_count             PLS_INTEGER;
      l_tba_count                 PLS_INTEGER;
      l_lic_sch_without_lin_ref   VARCHAR2 (1);
      l_lic_period_tba            VARCHAR2 (1);
      l_lic_sch_bef_x_day         VARCHAR2 (1);
      l_lic_sch_bef_x_day_value   PLS_INTEGER;
      l_lic_gen_refno             PLS_INTEGER;
      l_sch_time                  PLS_INTEGER;
      l_sch_date                  DATE;
      l_avail_date_from           DATE;
      l_avail_date_to             DATE;
      l_days_in_vp                PLS_INTEGER;
      l_is_prem_flag              VARCHAR2 (1);
      l_flag                      PLS_INTEGER;
      l_bin_reg_code              PLS_INTEGER;
   BEGIN
      IF i_start_date IS NULL OR i_end_date IS NULL
      THEN
         RETURN;
      END IF;

      SELECT COUNT (1)
        INTO l_lic_sch_count
        FROM x_cp_play_list
       WHERE plt_lic_number = i_lic_number AND plt_bin_id = i_bin_id;

      IF l_lic_sch_count = 0
      THEN
         BEGIN
            SELECT lic_sch_without_lin_ref,
                   lic_period_tba,
                   lic_sch_bef_x_day,
                   lic_sch_bef_x_day_value,
                   lic_gen_refno,
                   lic_max_viewing_period
              INTO l_lic_sch_without_lin_ref,
                   l_lic_period_tba,
                   l_lic_sch_bef_x_day,
                   l_lic_sch_bef_x_day_value,
                   l_lic_gen_refno,
                   l_days_in_vp
              FROM fid_license, fid_contract
             WHERE lic_con_number = con_number
                   AND NVL (lic_catchup_flag, 'N') IN
                          (SELECT s1.ms_media_service_flag
                             FROM sgy_pb_media_service s1
                            WHERE s1.ms_media_service_parent = 'CATCHUP') --ver 1.0 added IN condition
                   AND NVL (lic_period_tba, 'N') = 'Y'
                   AND NVL (con_tba_ser_schedule_flag, 'N') = 'Y'
                   AND lic_number = i_lic_number;

            l_tba_count := 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_tba_count := 0;
         END;

         IF (l_tba_count > 0)
         THEN
            IF (TRUNC (i_start_date) + l_days_in_vp) > TRUNC (i_end_date)
            THEN
               raise_application_error (
                  -20325,
                  'Max Viewing Days should fall within CatchUp License Start Date and End Date.');
            END IF;

            UPDATE fid_license
               SET lic_start = TRUNC (i_start_date),
                   lic_end = TRUNC (i_end_date),
                   lic_period_tba = 'N',
                   lic_cp_tba_modified = TRUNC (SYSDATE),
                   lic_entry_oper = 'SYSADMIN',
                   lic_update_count = NVL (lic_update_count, 0) + 1
             WHERE lic_number = i_lic_number;

            IF SQL%ROWCOUNT = 0
            THEN
               l_flag := 0;
               raise_application_error (
                  -20004,
                  'Not Able to Update License Start and End.');
            ELSE
               l_flag := 1;
            END IF;

            BEGIN
               SELECT sch_fin_actual_date, sch_time, bin_reg_code
                 INTO l_sch_date, l_sch_time, l_bin_reg_code
                 FROM x_cp_schedule_bin, fid_schedule
                WHERE bin_sch_number = sch_number AND bin_id = i_bin_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_sch_date := NULL;
                  l_sch_time := NULL;
            END;

            l_is_prem_flag :=
               x_fnc_title_is_premier (l_lic_gen_refno,
                                       l_bin_reg_code,
                                       l_sch_date,
                                       l_sch_time);

            l_avail_date_from :=
               x_pkg_cp_update_bin.x_fnc_get_avail_period_from (
                  l_lic_sch_without_lin_ref,
                  l_is_prem_flag,
                  'N',
                  l_lic_sch_bef_x_day,
                  l_lic_sch_bef_x_day_value,
                  l_sch_date,
                  i_start_date);

            l_avail_date_to :=
               x_pkg_cp_update_bin.x_fnc_get_avail_period_to (
                  l_lic_sch_without_lin_ref,
                  l_is_prem_flag,
                  l_lic_sch_bef_x_day,
                  l_days_in_vp,
                  l_sch_date,
                  i_end_date);

            UPDATE x_cp_schedule_bin
               SET bin_view_start_date = TRUNC (l_avail_date_from),
                   bin_view_end_date = TRUNC (l_avail_date_to),
                   bin_modified_by = 'SYSADMIN',
                   bin_modified_on = SYSDATE,
                   bin_update_count = NVL (bin_update_count, 0) + 1
             WHERE bin_id = i_bin_id;

            IF SQL%ROWCOUNT = 0
            THEN
               raise_application_error (
                  -20004,
                  'Record is modified by another user, Please refresh the screen.');
            END IF;

            o_status := 1;
         ELSE
            o_status := 0;
         END IF;
      END IF;
   END x_prc_modify_tba_cp_lic;

   /****************************************************************
   Reversal of License Modification for TBA License
   ****************************************************************/
   PROCEDURE x_prc_modify_tba_cp_lic_no_sch (i_lic_number   IN     NUMBER,
                                             i_bin_id       IN     NUMBER,
                                             o_status          OUT NUMBER)
   AS
      l_lic_sch_count             PLS_INTEGER;
      l_tba_count                 PLS_INTEGER;
      l_lic_sch_without_lin_ref   VARCHAR2 (1);
      l_lic_period_tba            VARCHAR2 (1);
      l_lic_sch_bef_x_day         VARCHAR2 (1);
      l_lic_sch_bef_x_day_value   PLS_INTEGER;
      l_lic_gen_refno             PLS_INTEGER;
      l_days_in_vp                PLS_INTEGER;
      l_sch_date                  DATE;
      l_sch_time                  PLS_INTEGER;
      l_is_prem_flag              VARCHAR2 (1);
      l_avail_date_from           DATE;
      l_avail_date_to             DATE;
      l_bin_reg_code              PLS_INTEGER;
   BEGIN
      SELECT COUNT (1)
        INTO l_lic_sch_count
        FROM x_cp_play_list
       WHERE plt_lic_number = i_lic_number AND plt_bin_id = i_bin_id;

      IF l_lic_sch_count = 0
      THEN
         BEGIN
            SELECT lic_sch_without_lin_ref,
                   lic_period_tba,
                   lic_sch_bef_x_day,
                   lic_sch_bef_x_day_value,
                   lic_gen_refno,
                   lic_max_viewing_period
              INTO l_lic_sch_without_lin_ref,
                   l_lic_period_tba,
                   l_lic_sch_bef_x_day,
                   l_lic_sch_bef_x_day_value,
                   l_lic_gen_refno,
                   l_days_in_vp
              FROM fid_license, fid_contract
             WHERE lic_con_number = con_number
                   AND NVL (lic_catchup_flag, 'N') IN
                          (SELECT s1.ms_media_service_flag
                             FROM sgy_pb_media_service s1
                            WHERE s1.ms_media_service_parent = 'CATCHUP') --ver 1.0 added IN condition
                   AND NVL (lic_period_tba, 'N') = 'N'
                   AND NVL (con_tba_ser_schedule_flag, 'N') = 'Y'
                   AND lic_cp_tba_modified IS NOT NULL
                   AND lic_number = i_lic_number;

            l_tba_count := 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_tba_count := 0;
         END;

         IF l_tba_count > 0
         THEN
            UPDATE fid_license
               SET lic_period_tba = 'Y',
                   lic_cp_tba_modified = NULL,
                   lic_start = '31-Dec-2199',
                   lic_end = '31-Dec-2199',
                   lic_entry_oper = 'SYSADMIN',
                   lic_update_count = NVL (lic_update_count, 0) + 1
             WHERE lic_number = i_lic_number;

            BEGIN
               SELECT sch_fin_actual_date, sch_time, bin_reg_code
                 INTO l_sch_date, l_sch_time, l_bin_reg_code
                 FROM x_cp_schedule_bin, fid_schedule
                WHERE bin_sch_number = sch_number AND bin_id = i_bin_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_sch_date := NULL;
                  l_sch_time := NULL;
            END;

            l_is_prem_flag :=
               x_fnc_title_is_premier (l_lic_gen_refno,
                                       l_bin_reg_code,
                                       l_sch_date,
                                       l_sch_time);

            l_avail_date_from :=
               x_pkg_cp_update_bin.x_fnc_get_avail_period_from (
                  l_lic_sch_without_lin_ref,
                  l_is_prem_flag,
                  'Y',
                  l_lic_sch_bef_x_day,
                  l_lic_sch_bef_x_day_value,
                  l_sch_date,
                  '31-Dec-2199');

            l_avail_date_to :=
               x_pkg_cp_update_bin.x_fnc_get_avail_period_to (
                  l_lic_sch_without_lin_ref,
                  l_is_prem_flag,
                  l_lic_sch_bef_x_day,
                  l_days_in_vp,
                  l_sch_date,
                  '31-Dec-2199');

            UPDATE x_cp_schedule_bin
               SET bin_view_start_date = l_avail_date_from,
                   bin_view_end_date = l_avail_date_to,
                   bin_modified_by = 'SYSADMIN',
                   bin_modified_on = SYSDATE,
                   bin_update_count = NVL (bin_update_count, 0) + 1
             WHERE bin_id = i_bin_id;

            o_status := 1;
         ELSE
            o_status := 0;
         END IF;
      ELSE
         o_status := 0;
      END IF;
   END x_prc_modify_tba_cp_lic_no_sch;

   /****************************************************************
   Function to get Schedule Start Date
   ****************************************************************/
   FUNCTION x_fnc_calc_start_date (i_lic_number                IN NUMBER,
                                   i_bin_id                IN NUMBER,
                                   i_dev_id                    IN NUMBER,
                                   i_sch_month                 IN DATE,
                                   i_premier_flag              IN VARCHAR2,
                                   i_lic_max_viewing_period    IN NUMBER,
                                   i_lic_sch_without_lin_ref   IN VARCHAR2,
                                   i_lic_budget_code           IN VARCHAR2,
                                   i_lic_gen_refno             IN NUMBER,
                                   i_lic_sch_bef_x_day         IN VARCHAR2,
                                   i_lic_sch_bef_x_day_value   IN NUMBER,
                                   i_lic_start                 IN DATE,
                                   i_lic_end                   IN DATE,
                                   i_sch_fin_actual_date       IN DATE,
                                   i_sch_time                  IN NUMBER,
                                   i_sch_end_time              IN NUMBER,
                                   i_cha_region_id             IN NUMBER,
                                   i_lic_period_tba            IN VARCHAR2,
                                   i_bin_view_start_date       IN DATE)
      RETURN VARCHAR2
   AS
      l_sch_date                  DATE;
      l_sch_time                  PLS_INTEGER;
      l_dev_time_mov              PLS_INTEGER;
      l_dev_time_ser              PLS_INTEGER;
      l_cod_value                 VARCHAR2 (1);
      l_sch_end_date              DATE;
      l_sch_count                 PLS_INTEGER;
      l_lic_duration              PLS_INTEGER;
      l_return                    VARCHAR2 (30);
      l_plan_year_mon             PLS_INTEGER;
      l_sch_end_time              PLS_INTEGER;
      l_first_day                 DATE;
      l_lic_start                 DATE;
      l_lic_period_tba            VARCHAR2 (1);
      l_lic_budget_code           VARCHAR2 (5);
      l_lic_sch_bef_x_day         VARCHAR2 (1);
      l_lic_sch_bef_x_day_value   PLS_INTEGER;
      l_lic_gen_refno             PLS_INTEGER;
      l_cha_region_id             PLS_INTEGER;
      l_lic_is_premier            VARCHAR2 (1);
      l_gen_duration_c            PLS_INTEGER;
      l_sch_number number;
   BEGIN
      l_plan_year_mon := TO_NUMBER (TO_CHAR (i_sch_month, 'RRRRMM'));
      l_first_day := TRUNC (i_sch_month, 'MONTH');

      BEGIN
         SELECT plt_sch_start_date, plt_sch_from_time,plt_sch_number
           INTO l_sch_date, l_sch_time,l_sch_number
           FROM x_cp_play_list
          WHERE     plt_lic_number = i_lic_number
                AND plt_bin_id = i_bin_id
                AND plt_dev_id = i_dev_id /*AND l_plan_year_mon >= to_number(to_char(plt_sch_start_date,'RRRRMM'))
                                          AND l_plan_year_mon <= to_number(to_char(plt_sch_end_date,'RRRRMM'))*/
                                         ;

         l_sch_count := 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_sch_count := 0;
         WHEN OTHERS
         THEN
            RAISE_APPLICATION_ERROR (-20007, SQLERRM);
      END;

      IF l_sch_count = 0
      THEN
         IF SIGN (l_sch_number) = 1
         THEN
            BEGIN
               /*SELECT sch_fin_actual_date,
                      sch_gen_refno,
                      sch_time,
                      sch_end_time,
                      cha_region_id
                 INTO l_sch_date,
                      l_lic_gen_refno,
                      l_sch_time,
                      l_sch_end_time,
                      l_cha_region_id
                 FROM fid_channel,
                      fid_schedule
                WHERE cha_number = sch_cha_number
                  AND sch_number = i_sch_number;

               l_lic_is_premier := x_fnc_title_is_premier(l_lic_gen_refno,l_cha_region_id,l_sch_date,l_sch_time);*/

               l_sch_date := i_sch_fin_actual_date;
               l_sch_time := i_sch_time;
               l_sch_end_time := i_sch_end_time;
               l_cha_region_id := l_cha_region_id;
               l_lic_is_premier := i_premier_flag;
            /*EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN raise_application_error(-20003,SQLERRM);*/
            END;
         ELSE
            /*SELECT bin_view_start_date,
           '0'
      INTO l_sch_date,
           l_sch_time
      FROM x_cp_schedule_bin
             WHERE bin_sch_number = i_sch_number
       AND bin_lic_number = i_lic_number;*/

            l_sch_date := i_bin_view_start_date;
            l_sch_time := 0;

            IF l_first_day > l_sch_date
            THEN
               l_sch_date := l_first_day;
            END IF;
         END IF;

         BEGIN
              SELECT MAX (mpdc_sch_start_aft_lnr_sch_mov),
                     MAX (mpdc_sch_start_aft_lnr_sch_ser)
                INTO l_dev_time_mov, l_dev_time_ser
                FROM x_cp_med_platm_dev_compat_map, x_cp_media_dev_platm_map
               WHERE mpdc_dev_platm_id = mdp_map_id
                     AND mdp_map_dev_id = i_dev_id
            GROUP BY mdp_map_dev_id /*,
                      mpdc_sch_start_aft_lnr_sch_mov,
                                      mpdc_sch_start_aft_lnr_sch_ser*/
                                   ;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (-20004, SQLERRM);
         END;

         /*SELECT lic_start,
                lic_period_tba,
                lic_budget_code,
                lic_sch_bef_x_day,
                lic_sch_bef_x_day_value,
                lic_gen_refno
           INTO l_lic_start,
                l_lic_period_tba,
                l_lic_budget_code,
                l_lic_sch_bef_x_day,
                l_lic_sch_bef_x_day_value,
                l_lic_gen_refno
           FROM fid_license
          WHERE lic_number = i_lic_number;*/

         l_lic_start := i_lic_start;
         l_lic_period_tba := i_lic_period_tba;
         l_lic_budget_code := i_lic_budget_code;
         l_lic_sch_bef_x_day := i_lic_sch_bef_x_day;
         l_lic_sch_bef_x_day_value := i_lic_sch_bef_x_day_value;
         l_lic_gen_refno := i_lic_gen_refno;

         SELECT convert_time_c_s (NVL (gen_duration_c, '00:00:00'))
           INTO l_gen_duration_c
           FROM fid_general
          WHERE gen_refno = l_lic_gen_refno;

         l_cod_value := x_fnc_get_prog_type (l_lic_budget_code);

         IF NVL (l_lic_sch_bef_x_day, 'N') = 'Y'
            AND NVL (l_lic_is_premier, 'N') = 'Y'
         THEN
            IF NVL (l_lic_period_tba, 'N') = 'Y'
            THEN
               l_sch_end_time := l_sch_time + l_gen_duration_c;

               WHILE l_sch_end_time > 86399
               LOOP
                  IF l_sch_end_time > 86399
                  THEN
                     l_sch_end_time := l_sch_end_time - 86399;
                     l_sch_date := l_sch_date + 1;
                  ELSE
                     l_sch_end_time := l_sch_end_time;
                  END IF;
               END LOOP;

               l_sch_date :=
                  TO_DATE (
                        TO_CHAR (l_sch_date, 'DD/MM/RRRR')
                     || ' '
                     || convert_time_n_c (l_sch_end_time),
                     'DD/MM/RRRR HH24:MI:SS')
                  - l_lic_sch_bef_x_day_value;
            ELSE
               l_sch_date :=
                  GREATEST (
                     TO_DATE (
                           TO_CHAR (l_sch_date, 'DD/MM/RRRR')
                        || ' '
                        || convert_time_n_c (l_sch_end_time),
                        'DD/MM/RRRR HH24:MI:SS')
                     - l_lic_sch_bef_x_day_value,
                     l_lic_start);
            END IF;

            l_sch_time := l_sch_end_time;
         ELSE
            IF l_cod_value = 'N'
            THEN
               IF l_sch_end_time IS NULL
               THEN
                  l_sch_time := l_sch_time        /*+ NVL(l_dev_time_mov,60)*/
                                          ;
               ELSE
                  l_sch_time := l_sch_end_time + NVL (l_dev_time_mov, 60);
               END IF;
            ELSE
               IF l_sch_end_time IS NULL
               THEN
                  l_sch_time := l_sch_time        /*+ NVL(l_dev_time_ser,60)*/
                                          ;
               ELSE
                  l_sch_time := l_sch_end_time + NVL (l_dev_time_ser, 60);
               END IF;
            END IF;

            IF l_sch_time > 86399
            THEN
               IF l_cod_value = 'N'
               THEN
                  l_sch_date :=
                     l_sch_date + NVL (FLOOR (l_dev_time_mov / 86399), 0);

                  l_sch_time := l_sch_time + MOD (l_dev_time_mov, 86399);
               ELSE
                  l_sch_date :=
                     l_sch_date + NVL (FLOOR (l_dev_time_ser / 86399), 0);

                  l_sch_time := l_sch_time + MOD (l_dev_time_ser, 86399);
               END IF;

               WHILE l_sch_time > 86399
               LOOP
                  IF l_sch_time > 86399
                  THEN
                     l_sch_time := l_sch_time - 86399;
                     l_sch_date := l_sch_date + 1;
                  ELSE
                     l_sch_time := l_sch_time;
                  END IF;
               END LOOP;
            END IF;

            IF NVL (l_lic_period_tba, 'N') = 'N'
            THEN
               IF TO_DATE (
                        TO_CHAR (l_sch_date, 'DD/MM/RRRR')
                     || ' '
                     || convert_time_n_c (l_sch_time),
                     'DD/MM/RRRR HH24:MI:SS') < l_lic_start
               THEN
                  --l_sch_date := GREATEST(to_date(to_char(l_sch_date,'DD/MM/RRRR') || ' ' || convert_time_n_c(l_sch_time),'DD/MM/RRRR HH24:MI:SS'),l_lic_start);
                  l_sch_date := l_lic_start;
                  l_sch_time := 0;
               END IF;
            END IF;
         END IF;

         l_return :=
               TO_CHAR (l_sch_date, 'DD-Mon-RRRR')
            || ' '
            || convert_time_n_c (l_sch_time);
      ELSE
         l_return :=
               TO_CHAR (l_sch_date, 'DD-Mon-RRRR')
            || ' '
            || convert_time_n_c (l_sch_time);
      END IF;

      RETURN l_return;
   END x_fnc_calc_start_date;

   /****************************************************************
   Function to get Schedule End Date
   ****************************************************************/
   FUNCTION x_fnc_calc_end_date (i_lic_number                IN NUMBER,
                                 i_bin_id                IN NUMBER,
                                 i_dev_id                    IN NUMBER,
                                 i_sch_month                 IN DATE,
                                 i_premier_flag              IN VARCHAR2,
                                 i_lic_max_viewing_period    IN NUMBER,
                                 i_lic_sch_without_lin_ref   IN VARCHAR2,
                                 i_lic_budget_code           IN VARCHAR2,
                                 i_lic_gen_refno             IN NUMBER,
                                 i_lic_sch_bef_x_day         IN VARCHAR2,
                                 i_lic_sch_bef_x_day_value   IN NUMBER,
                                 i_lic_start                 IN DATE,
                                 i_lic_end                   IN DATE,
                                 i_gen_duration_c            IN NUMBER,
                                 i_sch_fin_actual_date       IN DATE,
                                 i_sch_time                  IN NUMBER,
                                 i_sch_end_time              IN NUMBER,
                                 i_cha_region_id             IN NUMBER,
                                 i_lic_period_tba            IN VARCHAR2,
                                 i_bin_view_start_date       IN DATE,
                                 i_bin_view_end_date         IN DATE,
                                 i_sch_start_date_time       IN VARCHAR2)
      RETURN VARCHAR2
   AS
      l_sch_date                  DATE;
      l_sch_time                  PLS_INTEGER;
      l_max_vp                    PLS_INTEGER;
      l_lic_sch_wo_lin_ref        VARCHAR2 (1);
      l_dev_vp_mov                PLS_INTEGER;
      l_dev_vp_ser                PLS_INTEGER;
      l_cod_value                 VARCHAR2 (1);
      l_sch_end_date              DATE;
      l_sch_count                 PLS_INTEGER;
      l_return                    VARCHAR2 (30);
      l_plan_year_mon             PLS_INTEGER;
      l_lic_budget_code           fid_license.lic_budget_code%TYPE;
      l_cp_start_date             VARCHAR2 (100);
      l_sch_end_date_1            DATE;
      l_sch_end_date_2            DATE;
      l_sch_end_date_3            DATE;
      l_sch_end_date_4            DATE;
      l_lic_end                   DATE;
      l_lic_gen_refno             PLS_INTEGER;
      l_gen_duration_c            PLS_INTEGER;
      l_dev_vp                    PLS_INTEGER;
      l_sch_end_time              PLS_INTEGER;
      l_lic_sch_bef_x_day         VARCHAR2 (1);
      l_lic_sch_bef_x_day_value   PLS_INTEGER;
      l_cha_region_id             PLS_INTEGER;
      l_lic_is_premier            VARCHAR2 (1);
      l_sch_number  NUMBER;
   BEGIN
      l_plan_year_mon := TO_NUMBER (TO_CHAR (i_sch_month, 'RRRRMM'));

      BEGIN
         SELECT plt_sch_end_date, plt_sch_end_time,plt_sch_number
           INTO l_sch_date, l_sch_time,l_sch_number
           FROM x_cp_play_list
          WHERE     plt_lic_number = i_lic_number
                AND plt_bin_id = i_bin_id
                AND plt_dev_id = i_dev_id /*AND l_plan_year_mon >= to_number(to_char(plt_sch_start_date,'RRRRMM'))
                                          AND l_plan_year_mon <= to_number(to_char(plt_sch_end_date,'RRRRMM'))*/
                                         ;

         l_sch_count := 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_sch_count := 0;
         WHEN OTHERS
         THEN
            RAISE_APPLICATION_ERROR (-20007, SQLERRM);
      END;

      IF l_sch_count = 0
      THEN
         --            dbms_output.put_line('not in play list');

         IF SIGN (l_sch_number) = 1
         THEN
            BEGIN
               /*SELECT sch_fin_actual_date,
                      sch_gen_refno,
                      sch_time,
                      sch_end_time,
                      cha_region_id
                 INTO l_sch_date,
                      l_lic_gen_refno,
                      l_sch_time,
                      l_sch_end_time,
                      l_cha_region_id
                 FROM fid_channel,
                      fid_schedule
                WHERE cha_number = sch_cha_number
                  AND sch_number = i_sch_number;

               l_lic_is_premier := x_fnc_title_is_premier(l_lic_gen_refno,l_cha_region_id,l_sch_date,l_sch_time);*/

               l_sch_date := i_sch_fin_actual_date;
               l_sch_time := i_sch_time;
               l_sch_end_time := i_sch_end_time;
               l_cha_region_id := l_cha_region_id;
               l_lic_is_premier := i_premier_flag;
            /*EXCEPTION
                        WHEN NO_DATA_FOUND
              THEN RAISE_APPLICATION_ERROR(-20003,SQLERRM);*/
            END;
         ELSE
            /*SELECT bin_view_start_date, bin_view_end_date, '0'
            INTO l_sch_date, l_sch_end_date, l_sch_time
            FROM x_cp_schedule_bin
            WHERE bin_sch_number = i_sch_number
            AND bin_lic_number = i_lic_number;*/
            l_sch_date := i_bin_view_start_date;
            l_sch_end_date := i_bin_view_end_date;
            l_sch_time := 0;
         END IF;

         BEGIN
              SELECT MAX (mpdc_sch_expiry_in_days_mov),
                     MAX (mpdc_sch_expiry_in_days_ser)
                INTO l_dev_vp_mov, l_dev_vp_ser
                FROM x_cp_med_platm_dev_compat_map, x_cp_media_dev_platm_map
               WHERE mpdc_dev_platm_id = mdp_map_id
                     AND mdp_map_dev_id = i_dev_id
            GROUP BY mdp_map_dev_id /*,
                      mpdc_sch_expiry_in_days_mov,
                                      mpdc_sch_expiry_in_days_ser*/
                                   ;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RAISE_APPLICATION_ERROR (-20004, SQLERRM);
         END;

         BEGIN
            /*SELECT lic_max_viewing_period,
           lic_sch_without_lin_ref,
           lic_budget_code,
           lic_gen_refno,
           lic_sch_bef_x_day,
           lic_sch_bef_x_day_value,
           lic_end
      INTO l_max_vp,
           l_lic_sch_wo_lin_ref,
           l_lic_budget_code,
           l_lic_gen_refno,
           l_lic_sch_bef_x_day,
           l_lic_sch_bef_x_day_value,
           l_lic_end
      FROM fid_license
             WHERE lic_number = i_lic_number;*/

            l_max_vp := i_lic_max_viewing_period;
            l_lic_sch_wo_lin_ref := i_lic_sch_without_lin_ref;
            l_lic_budget_code := i_lic_budget_code;
            l_lic_gen_refno := i_lic_gen_refno;
            l_lic_sch_bef_x_day := i_lic_sch_bef_x_day;
            l_lic_sch_bef_x_day_value := i_lic_sch_bef_x_day_value;
            l_lic_end := i_lic_end;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (-20004, SUBSTR (SQLERRM, 11, 200));
         END;

         l_cod_value := x_fnc_get_prog_type (l_lic_budget_code);

         --l_cp_start_date := X_PKG_CP_SCH_GRID.x_fnc_calc_start_date(i_lic_number,i_sch_number,i_dev_id,i_sch_month);
         l_cp_start_date := i_sch_start_date_time;

         IF l_cod_value = 'N'
         THEN
            l_dev_vp := l_dev_vp_mov;
         ELSE
            l_dev_vp := l_dev_vp_ser;
         END IF;

         IF NVL (l_lic_sch_bef_x_day, 'N') = 'Y'
            AND NVL (l_lic_is_premier, 'N') = 'Y'
         THEN
            l_sch_end_date_1 :=
               TO_DATE (l_cp_start_date, 'DD-Mon-RRRR HH24:MI:SS') + l_dev_vp;
            l_sch_end_date_2 :=
               TO_DATE (l_cp_start_date, 'DD-Mon-RRRR HH24:MI:SS') + l_max_vp;
            l_sch_end_date_3 :=
               TO_DATE (
                     TO_CHAR (l_sch_date, 'DD/MM/RRRR')
                  || ' '
                  || convert_time_n_c (l_sch_end_time),
                  'DD/MM/RRRR HH24:MI:SS')
               + l_max_vp;

            l_sch_time := l_sch_end_time;

            IF NVL (l_dev_vp, 0) = 0
            THEN
               l_sch_end_date :=
                  LEAST (l_sch_end_date_2, l_sch_end_date_3, l_lic_end);
            ELSE
               l_sch_end_date :=
                  LEAST (l_sch_end_date_1,
                         l_sch_end_date_2,
                         l_sch_end_date_3,
                         l_lic_end);
            END IF;
         ELSIF NVL (l_lic_sch_wo_lin_ref, 'N') <> 'Y'
         THEN
            l_sch_end_date_1 :=
               TO_DATE (l_cp_start_date, 'DD-Mon-RRRR HH24:MI:SS') + l_dev_vp;

            SELECT MAX (bin_view_end_date)
              INTO l_sch_end_date_4
              FROM x_cp_schedule_bin
             WHERE     bin_id = i_bin_id
                   AND bin_lic_number = i_lic_number
                   AND on_schedule_grid = 'Y';

            /*SELECT fun_convert_duration_c_n(gen_duration_c)
              INTO l_gen_duration_c
              FROM fid_general
             WHERE gen_refno = l_lic_gen_refno;*/

            l_gen_duration_c := i_gen_duration_c;

            IF l_sch_end_time IS NULL
            THEN
               l_sch_time := l_sch_time + l_gen_duration_c;
            ELSE
               l_sch_time := l_sch_end_time;
            END IF;

            l_sch_date := l_sch_date + l_max_vp;

            WHILE l_sch_time > 86399
            LOOP
               IF l_sch_time > 86399
               THEN
                  l_sch_time := l_sch_time - 86399;
                  l_sch_date := l_sch_date + 1;
               ELSE
                  l_sch_time := l_sch_time;
               END IF;
            END LOOP;

            l_sch_end_date_2 :=
               TO_DATE (
                     TO_CHAR (l_sch_date, 'DD/MM/RRRR')
                  || ' '
                  || convert_time_n_c (l_sch_time),
                  'DD/MM/RRRR HH24:MI:SS');

            IF NVL (l_dev_vp, 0) <> 0
            THEN
               l_sch_end_date :=
                  LEAST (l_sch_end_date_1,
                         l_sch_end_date_2,
                         l_sch_end_date_4);
            ELSE
               l_sch_end_date := LEAST (l_sch_end_date_2, l_sch_end_date_4);
            END IF;
         ELSE
            IF NVL (l_dev_vp, 0) <> 0
            THEN
               l_sch_end_date :=
                  LEAST (
                     (TO_DATE (l_cp_start_date, 'DD-Mon-RRRR HH24:MI:SS')
                      + l_max_vp),
                     (TO_DATE (l_cp_start_date, 'DD-Mon-RRRR HH24:MI:SS')
                      + l_dev_vp),
                     l_sch_end_date);
            ELSE
               l_sch_end_date :=
                  LEAST (
                     (TO_DATE (l_cp_start_date, 'DD-Mon-RRRR HH24:MI:SS')
                      + l_max_vp),
                     l_sch_end_date);
            END IF;
         END IF;

         l_return :=
               TO_CHAR (l_sch_end_date, 'DD-Mon-RRRR')
            || ' '
            || convert_time_n_c (l_sch_time);
      ELSE
         l_return :=
               TO_CHAR (l_sch_date, 'DD-Mon-RRRR')
            || ' '
            || convert_time_n_c (l_sch_time);
      END IF;

      RETURN l_return;
   END x_fnc_calc_end_date;

   /****************************************************************
   Function to Check Validation
   ****************************************************************/
   FUNCTION x_fnc_lic_valid_check (i_lic_number           IN NUMBER,
                                   i_bin_id               IN NUMBER,
                                   i_plt_sch_start_date   IN DATE,
                                   i_plt_sch_end_date     IN DATE,
                                   i_dev_id               IN NUMBER,
                                   i_plt_entry_oper       IN VARCHAR2)
      RETURN NUMBER
   AS
      l_catchup_lic_con_number    PLS_INTEGER;
      l_catchup_lic_gen_refno     PLS_INTEGER;
      l_catchup_lic_reg_code      PLS_INTEGER;
      l_catchup_lic_status        VARCHAR2 (1);
      l_catchup_lic_vp            PLS_INTEGER;
      l_catchup_lic_vp_used       PLS_INTEGER;
      l_catchup_lic_start         DATE;
      l_catchup_lic_end           DATE;
      l_catchup_gen_type          VARCHAR2 (4);
      l_catchup_bin_view_start    DATE;
      l_catchup_bin_view_end      DATE;
      l_linear_lic_con_number     PLS_INTEGER;
      l_linear_lic_gen_refno      PLS_INTEGER;
      l_linear_lic_reg_code       PLS_INTEGER;
      l_linear_lic_sch_number     PLS_INTEGER;
      l_linear_lic_sch_date       DATE;
      l_linear_lic_sch_time       PLS_INTEGER;
      l_linear_lic_sch_end_time   PLS_INTEGER;
      l_linear_premier_date       DATE;
      l_plt_vp_used               PLS_INTEGER;
      l_lic_non_cons_month        VARCHAR2 (1);
      l_lic_cons_month_cnt        PLS_INTEGER;
      l_con_sch_no_epi_seson      PLS_INTEGER;
      l_ser_number                PLS_INTEGER;
      l_ser_schedule_cnt          PLS_INTEGER;
      l_lic_sch_bef_x_day         VARCHAR2 (1);
      l_lic_sch_bef_x_day_value   PLS_INTEGER;
      l_return_flag               PLS_INTEGER;
      l_close_month_sch_cnt       PLS_INTEGER;
      l_lock_month_cnt            PLS_INTEGER;
      l_super_user_cnt            PLS_INTEGER;
      l_dev_vp                    PLS_INTEGER;
      l_dev_vp_mov                PLS_INTEGER;
      l_dev_vp_ser                PLS_INTEGER;
      l_dev_code                  VARCHAR2 (10);
      l_lic_sch_aft_prem_linear   VARCHAR2 (1);
      l_lic_max_viewing_period    PLS_INTEGER;
      l_RESULT                    PLS_INTEGER; --Jawahar:20Mar2015 to fix P1 episode restriction is not working
      l_ss_avail_date_to          DATE;                             /*CU4ALL*/
      l_ss_count                  NUMBER;                           /*CU4ALL*/
      l_last_lin_schedule         number;     --added by milan shah. CU4ALL
      l_lst_epi_genrefno          number;     --added by Milan Shah. CU4ALL
      l_gen_ser_number            number;     --added by Milan Shah. CU4ALL
      l_ss_avail_to               date;       --added by Milan Shah. CU4ALL
   BEGIN
      SELECT bin_sch_number,
             bin_reg_code,
             bin_view_start_date,
             bin_view_end_date,
             BIN_SUPERSTACK_AVAIL_TO
        INTO l_linear_lic_sch_number,
             l_catchup_lic_reg_code,
             l_catchup_bin_view_start,
             l_catchup_bin_view_end,
             l_ss_avail_date_to                                     /*CU4ALL*/
        FROM x_cp_schedule_bin
       WHERE bin_id = i_bin_id;

      SELECT lic_gen_refno,
             lic_con_number,
             lic_status,
             lic_showing_int,
             lic_non_cons_month,
             lic_sch_bef_x_day,
             lic_sch_bef_x_day_value,
             lic_budget_code,
             lic_start,
             lic_end,
             lic_sch_aft_prem_linear,
             lic_max_viewing_period
        INTO l_catchup_lic_gen_refno,
             l_catchup_lic_con_number,
             l_catchup_lic_status,
             l_catchup_lic_vp,
             l_lic_non_cons_month,
             l_lic_sch_bef_x_day,
             l_lic_sch_bef_x_day_value,
             l_catchup_gen_type,
             l_catchup_lic_start,
             l_catchup_lic_end,
             l_lic_sch_aft_prem_linear,
             l_lic_max_viewing_period
        FROM fid_license
       WHERE lic_number = i_lic_number
             AND NVL (lic_catchup_flag, 'N') IN
                    (SELECT s1.ms_media_service_flag
                       FROM sgy_pb_media_service s1
                      WHERE s1.ms_media_service_parent = 'CATCHUP'); --ver 1.0 added IN condition

      SELECT COUNT (1)
        INTO l_ss_count
        FROM x_cp_play_list_temp, x_cp_plt_terr_bouq_temp
       WHERE     pltt_id = ptbt_plt_id
             AND pltt_lic_number = i_lic_number
             AND pltt_bin_id = i_bin_id
             AND ptbt_bouq_supers_rights = 'Y';

      BEGIN
      SELECT gen_ser_number INTO l_gen_ser_number
      FROM x_cp_schedule_bin
           ,fid_schedule
           ,fid_general
      WHERE bin_id = i_bin_id
            and sch_number = bin_sch_number
            and gen_refno = sch_gen_refno;
      EXCEPTION WHEN NO_DATA_FOUND THEN
          l_gen_ser_number := 0;
      END;

      BEGIN
      SELECT gen_refno into l_lst_epi_genrefno
      FROM
        (
          SELECT gen_refno
          FROM fid_general
          where gen_ser_number = l_gen_ser_number
          order by gen_epi_number desc
        )
      where rownum <2;
       EXCEPTION WHEN NO_DATA_FOUND THEN
          l_lst_epi_genrefno := 0;
      END;

      BEGIN
          select count(1) into l_last_lin_schedule
          from fid_schedule
          where sch_gen_refno = l_lst_epi_genrefno;
      EXCEPTION WHEN NO_DATA_FOUND THEN
          l_last_lin_schedule :=0;
      END;

      select BIN_SUPERSTACK_AVAIL_TO INTO l_ss_avail_to
      from x_cp_schedule_bin where bin_id = i_bin_id;

      IF SIGN (l_linear_lic_sch_number) = 1
      THEN
         SELECT lic_gen_refno,
                lic_con_number,
                sch_fin_actual_date,
                sch_time,
                sch_end_time
           INTO l_linear_lic_gen_refno,
                l_linear_lic_con_number,
                l_linear_lic_sch_date,
                l_linear_lic_sch_time,
                l_linear_lic_sch_end_time
           FROM fid_license, fid_schedule
          WHERE lic_number = sch_lic_number
                AND sch_number = l_linear_lic_sch_number;

         SELECT cha_region_id
           INTO l_linear_lic_reg_code
           FROM fid_channel, fid_schedule
          WHERE cha_number = sch_cha_number
                AND sch_number = l_linear_lic_sch_number;
      ELSE
         l_linear_lic_gen_refno := l_catchup_lic_gen_refno;
         l_linear_lic_con_number := l_catchup_lic_con_number;
         l_linear_lic_reg_code := l_catchup_lic_reg_code;
      END IF;

      -- Schedule Period between lic_start and lic_end and bin_view_start and bin_view_end : Start
      IF TRUNC (i_plt_sch_start_date) < TRUNC (l_catchup_lic_start)
         OR TRUNC (i_plt_sch_start_date) > TRUNC (l_catchup_lic_end)
      THEN
         l_error_message :=
               'Schedule start date should be between '
            || TO_DATE (l_catchup_lic_start, 'DD-Mon-RRRR')
            || ' and '
            || TO_DATE (L_Catchup_Lic_End, 'DD-Mon-RRRR');
         raise_application_error (
            -20325,
               'Schedule start date should be between '
            || TO_DATE (l_catchup_lic_start, 'DD-Mon-RRRR')
            || ' and '
            || TO_DATE (l_catchup_lic_end, 'DD-Mon-RRRR'));
      ELSIF (TRUNC (i_plt_sch_end_date) < TRUNC (l_catchup_lic_start)
             OR TRUNC (i_plt_sch_end_date) > TRUNC (l_catchup_lic_end))
            AND l_ss_count < 1
      THEN
         L_Error_Message :=
               'Schedule end date should be between '
            || TO_DATE (l_catchup_lic_start, 'DD-Mon-RRRR')
            || ' and '
            || TO_DATE (l_catchup_lic_end, 'DD-Mon-RRRR');
         raise_application_error (
            -20325,
               'Schedule end date should be between '
            || TO_DATE (l_catchup_lic_start, 'DD-Mon-RRRR')
            || ' and '
            || TO_DATE (l_catchup_lic_end, 'DD-Mon-RRRR'));
      ELSIF TRUNC (i_plt_sch_start_date) < TRUNC (l_catchup_bin_view_start)
            OR TRUNC (i_plt_sch_start_date) > TRUNC (l_catchup_bin_view_end)
      THEN
         L_Error_Message :=
               'Schedule start date should be between '
            || TO_DATE (l_catchup_bin_view_start, 'DD-Mon-RRRR')
            || ' and '
            || TO_DATE (l_catchup_bin_view_end, 'DD-Mon-RRRR');
         raise_application_error (
            -20325,
               'Schedule start date should be between '
            || TO_DATE (l_catchup_bin_view_start, 'DD-Mon-RRRR')
            || ' and '
            || TO_DATE (l_catchup_bin_view_end, 'DD-Mon-RRRR'));
      ELSIF (TRUNC (i_plt_sch_end_date) < TRUNC (l_catchup_bin_view_start)
             OR TRUNC (i_plt_sch_end_date) > TRUNC (l_catchup_bin_view_end))
            AND l_ss_count < 1
      THEN
         L_Error_Message :=
               'Schedule end date should be between '
            || TO_DATE (l_catchup_bin_view_start, 'DD-Mon-RRRR')
            || ' and '
            || TO_DATE (l_catchup_bin_view_end, 'DD-Mon-RRRR');
         raise_application_error (
            -20325,
               'Schedule end date should be between '
            || TO_DATE (l_catchup_bin_view_start, 'DD-Mon-RRRR')
            || ' and '
            || TO_DATE (l_catchup_bin_view_end, 'DD-Mon-RRRR'));
      END IF;

      -- Schedule Period between lic_start and lic_end and bin_view_start and bin_view_end : End

      IF NVL (l_lic_sch_bef_x_day, 'N') = 'Y'
      THEN
         IF i_plt_sch_start_date <
               l_linear_lic_sch_date - l_lic_sch_bef_x_day_value
         THEN
            L_Error_Message :=
               'Schedule start date cannot be less than '
               || TO_CHAR (L_Linear_Lic_Sch_Date - L_Lic_Sch_Bef_X_Day_Value,
                           'DD-Mon-RRRR');
            raise_application_error (
               -20325,
               'Schedule start date cannot be less than '
               || TO_CHAR (l_linear_lic_sch_date - l_lic_sch_bef_x_day_value,
                           'DD-Mon-RRRR')
               || '.');
         END IF;
      END IF;

      -- Schedule After Linear Premier Broadcast Only : Start
      IF NVL (l_lic_sch_aft_prem_linear, 'N') = 'Y'
         AND SIGN (l_linear_lic_sch_number) = 1
      THEN
         l_linear_premier_date :=
            TO_DATE (
               x_pkg_cp_planning.x_fnc_get_premier_date (
                  l_linear_lic_gen_refno,
                  l_catchup_lic_reg_code),
               'DD-MM-RRRR HH24:MI:SS');

         IF l_linear_premier_date <>
               TO_DATE (
                     TO_CHAR (l_linear_lic_sch_date, 'DD-MM-RRRR')
                  || ' '
                  || convert_time_n_c (l_linear_lic_sch_time),
                  'DD-MM-RRRR HH24:MI:SS')
         THEN
            L_Error_Message := 'Schedule should be premier only';
            raise_application_error (-20325,
                                     'Schedule should be premier only');
         ELSE
            IF TO_DATE (
                     TO_CHAR (l_linear_lic_sch_date, 'DD-MM-RRRR')
                  || ' '
                  || convert_time_n_c (l_linear_lic_sch_end_time),
                  'DD-MM-RRRR HH24:MI:SS') >= i_plt_sch_start_date
            THEN
               L_Error_Message :=
                  'Schedule start should be after linear schedule''s end';
               raise_application_error (
                  -20325,
                  'Schedule start should be after linear schedule''s end');
            END IF;
         END IF;
      END IF;

      -- Schedule After Linear Premier Broadcast Only : End

      -- Exceeding Viewing Days : Start
      IF (to_date(TO_CHAR (i_plt_sch_end_date, 'DD-MM-RRRR'),'DD-MM-RRRR') >to_date(TO_CHAR ( (i_plt_sch_start_date + l_lic_max_viewing_period),'DD-MM-RRRR'),'DD-MM-RRRR'))
         AND l_ss_count < 1
      THEN
         L_Error_Message := 'Schedule exceeding max viewing days';
         raise_application_error (-20325,
                                  'Schedule exceeding max viewing days');
      END IF;

      /*validation for super stacked titles - Milan Shah [CU4ALL]*/
      IF l_ss_count >= 1
          THEN
              IF l_last_lin_schedule > 0
              THEN
               --to_char((i_plt_sch_start_date + l_lic_max_viewing_period),'DD-MM-RRRR'))
                  IF (to_Date(to_char(i_plt_sch_end_date,'DD-MM-RRRR'),'DD-MM-RRRR') > to_date(to_char(l_ss_avail_to,'DD-MM-RRRR'),'DD-MM-RRRR'))
                  THEN
                     L_Error_Message := 'Schedule exceeding max viewing days';
                     raise_application_error (-20325,'Schedule exceeding max viewing days');
                   END IF;

              END IF;

          END IF;

      -- Exceeding Viewing Days : End

      SELECT COUNT (DISTINCT plt_sch_number)
        INTO l_plt_vp_used
        FROM x_cp_play_list
       WHERE plt_lic_number = i_lic_number AND plt_bin_id <> i_bin_id;

      SELECT con_sch_no_epi_restr_ser_seson
        INTO l_con_sch_no_epi_seson
        FROM fid_contract
       WHERE con_number = l_catchup_lic_con_number;

      l_catchup_lic_vp_used := l_plt_vp_used;

      SELECT COUNT (1)
        INTO l_close_month_sch_cnt
        FROM fid_financial_month
       WHERE fim_status = 'C'
             AND i_plt_sch_start_date BETWEEN TO_DATE (fim_year || fim_month,
                                                       'RRRRMM')
                                          AND LAST_DAY (
                                                 TO_DATE (
                                                    fim_year || fim_month,
                                                    'RRRRMM'))
             AND NVL (fim_split_region, 1) =
                    DECODE (fim_split_region,
                            NULL, 1,
                            l_catchup_lic_reg_code);

      IF l_close_month_sch_cnt > 0
      THEN
         L_Error_Message :=
            'Programme cannot be scheduled as the financial month is closed';
         raise_application_error (
            -20325,
            'Programme cannot be scheduled as the financial month is closed');
      ELSE
         SELECT COUNT (1)
           INTO l_lock_month_cnt
           FROM fid_financial_month
          WHERE fim_status <> 'C' AND fim_is_sup_sch = 'Y'
                AND (i_plt_sch_start_date BETWEEN TO_DATE (
                                                     fim_year || fim_month,
                                                     'RRRRMM')
                                              AND LAST_DAY (
                                                     TO_DATE (
                                                        fim_year || fim_month,
                                                        'RRRRMM'))
                     OR i_plt_sch_end_date BETWEEN TO_DATE (
                                                      fim_year || fim_month,
                                                      'RRRRMM')
                                               AND LAST_DAY (
                                                      TO_DATE (
                                                         fim_year
                                                         || fim_month,
                                                         'RRRRMM')));

         SELECT COUNT (1)
           INTO l_super_user_cnt
           FROM men_user a, ora_aspnet_users b, ora_aspnet_usersinroles c
          WHERE     UPPER (b.username) = UPPER (a.usr_ad_loginid)
                AND b.userid = c.userid
                AND c.roleid = 'FF2834032051481D8A83835702586D68'
                AND a.usr_login = i_plt_entry_oper;

         IF l_lock_month_cnt > 0 AND l_super_user_cnt = 0
         THEN
            L_Error_Message :=
               'As the financial month is locked, playlist can be edited by Super Scheduler only';
            raise_application_error (
               -20325,
               'As the financial month is locked, playlist can be edited by Super Scheduler only');
         END IF;
      END IF;

      IF l_lic_non_cons_month = 'Y'
      THEN
         SELECT COUNT (DISTINCT plt_sch_number)
           INTO l_lic_cons_month_cnt
           FROM fid_license, x_cp_play_list
          WHERE     plt_lic_number = lic_number
                AND plt_dev_id = i_dev_id
                AND lic_status IN ('A', 'T')
                AND lic_number = i_lic_number
                AND (TO_CHAR (ADD_MONTHS (plt_sch_start_date, 1), 'YYYYMM') =
                        TO_CHAR (i_plt_sch_start_date, 'YYYYMM')
                     OR TO_CHAR (ADD_MONTHS (plt_sch_start_date, -1),
                                 'YYYYMM') =
                           TO_CHAR (i_plt_sch_start_date, 'YYYYMM'));

         IF l_lic_cons_month_cnt > 0
         THEN
            L_Error_Message :=
               'Programme cannot be scheduled in consecutive months';
            raise_application_error (
               -20325,
               'Programme cannot be scheduled in consecutive months');
         END IF;
      END IF;

      IF x_fnc_get_prog_type (l_catchup_gen_type) = 'Y'
      THEN
         SELECT DECODE (ser_parent_number, 0, ser_number, ser_parent_number)
           INTO l_ser_number
           FROM fid_series, fid_general, fid_license
          WHERE     gen_ser_number = ser_number
                AND gen_refno = lic_gen_refno
                AND lic_status IN ('A', 'T')
                AND lic_number = i_lic_number;

         SELECT --COUNT (distinct plt_sch_number)         /*Commented Jawahar:20Mar2015 to fix P1 episode restriction is not working*/
               COUNT (plt_sch_number) /*Added Jawahar:20Mar2015 to fix P1 episode restriction is not working*/
           INTO l_ser_schedule_cnt
           FROM x_cp_play_list
          WHERE plt_dev_id = i_dev_id /*Uncommented Jawahar:20Mar2015 to fix P1 episode restriction is not working*/
                                      ----Changes By Pranay Kusumwal to fix P1
                 AND plt_reg_code = l_catchup_lic_reg_code
                ---- Changes by Pranay Kusumwal End

                AND (TO_CHAR (plt_sch_start_date, 'MM/DD/RRRR HH12:MI:SS AM') BETWEEN TO_CHAR (
                                                                                         i_plt_sch_start_date,
                                                                                         'MM/DD/RRRR HH12:MI:SS AM')
                                                                                  AND TO_CHAR (
                                                                                         i_plt_sch_end_date,
                                                                                         'MM/DD/RRRR HH12:MI:SS AM')
                     OR TO_CHAR (plt_sch_end_date,
                                 'MM/DD/RRRR HH12:MI:SS AM') BETWEEN TO_CHAR (
                                                                        i_plt_sch_start_date,
                                                                        'MM/DD/RRRR HH12:MI:SS AM')
                                                                 AND TO_CHAR (
                                                                        i_plt_sch_end_date,
                                                                        'MM/DD/RRRR HH12:MI:SS AM'))
                AND plt_lic_number IN
                       (SELECT lic_number
                          FROM fid_series, fid_general, fid_license
                         WHERE     gen_ser_number = ser_number
                               AND gen_refno = lic_gen_refno
                               AND lic_status IN ('A', 'T')
                               AND ser_number = l_ser_number
                        UNION
                        SELECT lic_number
                          FROM fid_series, fid_general, fid_license
                         WHERE     gen_ser_number = ser_number
                               AND gen_refno = lic_gen_refno
                               AND lic_status IN ('A', 'T')
                               AND ser_parent_number = l_ser_number);

         IF l_ser_schedule_cnt > l_con_sch_no_epi_seson
         THEN
            /*Jawahar:20Mar2015 to fix P1 episode restriction is not working
                ----Changes By Pranay Kusumwal to fix P1
                raise_application_error(-20325,'Programme cannot be scheduled. As no.of episodes restriction is violating for the contract');
                ---- Changes by Pranay Kusumwal End
            */

            l_RESULT :=
               X_FNC_OVERLAP_SCH_CNT (
                  I_CATCHUP_LIC_REG_CODE   => l_catchup_lic_reg_code,
                  I_plt_dev_id             => i_dev_id,
                  I_PLT_SCH_START_DATE     => i_plt_sch_start_date,
                  I_PLT_SCH_END_DATE       => i_plt_sch_end_date,
                  I_SER_NUMBER             => l_ser_number,
                  I_CON_SCH_NO_EPI_SESON   => l_con_sch_no_epi_seson);

            IF l_RESULT = -1
            THEN
               raise_application_error (
                  -20325,
                  'Programme cannot be scheduled. As no.of episodes restriction is violating for the contract');
            END IF;
         --END : Jawahar:20Mar2015 to fix P1 episode restriction is not working
         END IF;
      END IF;

      IF l_catchup_lic_gen_refno = l_linear_lic_gen_refno
         AND l_catchup_lic_con_number = l_linear_lic_con_number
      THEN
         IF l_catchup_lic_reg_code = l_linear_lic_reg_code
         THEN
            IF l_catchup_lic_status = 'A'
            THEN
               IF (l_catchup_lic_vp - l_catchup_lic_vp_used) > 0
               THEN
                  l_return_flag := 1;
               ELSE
                  L_Error_Message :=
                     'Catchup license viewing period is exceeding max viewing period';
                  raise_application_error (
                     -20325,
                     'Catchup license viewing period is exceeding max viewing period');
               END IF;
            ELSE
               L_Error_Message := 'Catchup License is not active';
               raise_application_error (-20325,
                                        'Catchup License is not active');
            END IF;
         ELSE
            L_Error_Message :=
               'CatchUp License''s Region Does not match with linear';
            raise_application_error (
               -20325,
               'CatchUp License''s Region Does not match with linear');
         END IF;
      ELSE
         /*L_Error_Message :=
            'CatchUp License''s contract number does not match';
         raise_application_error (
            -20325,
            'CatchUp License''s contract number does not match');*/
        l_return_flag := 1;
      END IF;

      RETURN l_return_flag;
   END x_fnc_lic_valid_check;

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

   /*Added by Swapnil Malvi on 13-Mar-2015 for Clearleap Release
   Begin*/
   /*Cursor for UIDs List on Schedule Grid*/
   PROCEDURE x_prc_uid_list (i_lic_number       fid_license.lic_number%TYPE,
                             o_uid_list     OUT SYS_REFCURSOR)
   AS
      l_is_CRSA_flag   VARCHAR2 (1);
   BEGIN
      SELECT DECODE (lee_short_name, 'CRSA', 'Y', 'N')
        INTO l_is_CRSA_flag
        FROM fid_license, fid_licensee
       WHERE lic_lee_number = lee_number AND lic_number = i_lic_number;

      OPEN o_uid_list FOR
         SELECT Tap_Barcode,
                Tap_Title,
                Tap_Title_Second,
                Tap_Uid_Version,
                (CASE
                    WHEN Tap_Uid_Version = 'FRM'
                         AND NVL (t.tap_uid_lang_id, 0) = 0
                    THEN
                       1
                    ELSE
                       /*RDT : Start [Anuja Shinde]_[29/07/2015]
                         Fixed issue not to allow to select two UID's of english lang and UID's with lang id 0/null*/
                       DECODE (t.tap_uid_lang_id, 0, 1, t.tap_uid_lang_id)
                 END)
                   uid_lang_id,
                (SELECT uid_lang_desc
                   FROM x_uid_language
                  WHERE uid_lang_id = t.tap_uid_lang_id)
                   Uid_Lang_Desc,
                (SELECT uid_status
                   FROM x_uid_status
                  WHERE uid_status_id = t.tap_uid_status_id)
                   Uid_Status,
                Tap_Ingest_Status,
                l_is_CRSA_flag is_CRSA_flag
           FROM fid_tape t, sgy_mn_lic_tape_cha_mapp m, x_uid_language
          WHERE m.ltcm_tap_number = t.tap_number
                AND m.ltcm_lic_number = i_lic_number
                AND DECODE (TAP_UID_LANG_ID, 0, 1, TAP_UID_LANG_ID) =
                       UID_LANG_ID
                AND NVL (UID_LANG_IS_CATCHUP_VOD, 'N') = 'Y'
                --Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/05]
                --Excluding Expired UID's
                AND tap_uid_status_id <> 13
         --Dev.R14 : Catchup 4 All Intrim : End
         UNION
         SELECT Tap_Barcode,
                Tap_Title,
                Tap_Title_Second,
                Tap_Uid_Version,
                (CASE
                    WHEN Tap_Uid_Version = 'FRM'
                         AND NVL (t.tap_uid_lang_id, 0) = 0
                    THEN
                       1
                    ELSE
                       /*RDT : Start [Anuja Shinde]_[29/07/2015]
                       Fixed issue not to allow to select two UID's of english lang and UID's with lang id 0/null*/
                       DECODE (t.tap_uid_lang_id, 0, 1, t.tap_uid_lang_id)
                 END)
                   uid_lang_id,
                (SELECT uid_lang_desc
                   FROM x_uid_language
                  WHERE uid_lang_id = t.tap_uid_lang_id)
                   Uid_Lang_Desc,
                (SELECT uid_status
                   FROM x_uid_status
                  WHERE uid_status_id = t.tap_uid_status_id)
                   Uid_Status,
                Tap_Ingest_Status,
                l_is_CRSA_flag is_CRSA_flag
           FROM fid_tape t,
                sgy_mn_lic_tape_cha_mapp m,
                fid_license,
                x_uid_language
          WHERE     m.ltcm_tap_number = t.tap_number
                AND m.ltcm_gen_refno = lic_gen_refno
                AND lic_number = i_lic_number
                AND DECODE (TAP_UID_LANG_ID, 0, 1, TAP_UID_LANG_ID) =
                       UID_LANG_ID
                AND NVL (UID_LANG_IS_CATCHUP_VOD, 'N') = 'Y'
                --Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/05]
                --Excluding Expired UID's
                AND tap_uid_status_id <> 13;
   --Dev.R14 : Catchup 4 All Intrim : End
   END X_Prc_UID_List;

   /*Cursors for Manage Territories Screen that pops up on Territories View Rights Button
     on Schedule grid*/
   PROCEDURE x_prc_uid_terr_list (
      i_sbu_bin_id       IN     x_cp_sch_bin_uid.sbu_bin_id%TYPE,
      i_sbu_uid          IN     VARCHAR2,
      o_uid_list            OUT SYS_REFCURSOR,
      o_territory_list      OUT SYS_REFCURSOR)
   AS
      l_eng_count        NUMBER;
      l_portu_count      NUMBER;
      l_uid_lang_exist	VARCHAR2 (400);
	  l_uid_lang_notexist VARCHAR2 (400);
      l_lee_short_name   VARCHAR2 (50);
   BEGIN
		SELECT Lee_Short_Name
		INTO l_lee_short_name
		FROM X_Cp_Schedule_Bin, Fid_License, Fid_Licensee
		WHERE     Bin_Lic_Number = Lic_Number
		AND Lic_Lee_Number = Lee_Number
		AND Bin_Id = I_Sbu_Bin_Id;

		SELECT COUNT ( (CASE WHEN sbt_lang_id = 1 THEN 1 END)) ENG,
			 COUNT ( (CASE WHEN sbt_lang_id = 5 THEN 1 END)) prot
		INTO l_eng_count, l_portu_count
		FROM X_CP_SCH_BIN_TERRITORY
		WHERE sbt_bin_id = i_sbu_bin_id;

		OPEN o_uid_list FOR
		SELECT tap_barcode UID_NO,
		UID_LANG_DESC UID_LANG,
		NVL (UID_LANG_ID, 1) UID_LANG_ID
		FROM fid_tape, x_uid_language
		WHERE DECODE (TAP_UID_LANG_ID, 0, 1, TAP_UID_LANG_ID) = UID_LANG_ID
		AND NVL (UID_LANG_IS_CATCHUP_VOD, 'N') = 'Y'
		AND TAP_BARCODE IN
			   (SELECT COLUMN_VALUE
				  FROM TABLE (
						  X_PKG_CM_SPLIT_STRING.split_to_char (
							 i_sbu_uid)))
		UNION ALL
		SELECT NULL UID_NO, UID_LANG_DESC UID_LANG, UID_LANG_ID
		FROM x_uid_language
		WHERE     UID_LANG_ID = 1
		AND NVL (UID_LANG_IS_CATCHUP_VOD, 'N') = 'Y'
		AND NVL (LENGTH (i_sbu_uid), 0) = 0
		ORDER BY UID_LANG_ID;

		SELECT wm_concat (NVL (LANG_ID_exist, 1)) LANG_ID_exist
				,wm_concat (NVL (LANG_ID_notexist, 1)) LANG_ID_notexist
		INTO l_uid_lang_exist
			,l_uid_lang_notexist
		from(	select (case when SBT_LANG_ID is not null then UID_LANG_ID end) LANG_ID_exist
						,(case when SBT_LANG_ID is null then UID_LANG_ID end) LANG_ID_notexist
				FROM fid_tape, x_uid_language
					,(	select distinct SBT_LANG_ID
						FROM X_CP_SCH_BIN_TERRITORY
						WHERE sbt_bin_id = i_sbu_bin_id
						)x
				WHERE DECODE (TAP_UID_LANG_ID, 0, 1, TAP_UID_LANG_ID) = UID_LANG_ID
				and SBT_LANG_ID (+) = UID_LANG_ID
				AND NVL (UID_LANG_IS_CATCHUP_VOD, 'N') = 'Y'
				AND TAP_BARCODE IN (SELECT COLUMN_VALUE
									FROM TABLE (X_PKG_CM_SPLIT_STRING.split_to_char (i_sbu_uid))
									));

			OPEN O_TERRITORY_LIST FOR
			select BIN_ID,
				TO_NUMBER (x.UID_LANG_ID) UID_LANG_ID,
				TER_CODE,
				TER_NAME,
				'I' INCLUDE_FLAG
			from X_CP_SCH_BIN_TERRITORY ,
				FID_LICENSE_LEDGER,
				FID_TERRITORY,
				X_CP_SCHEDULE_BIN,
				(SELECT COLUMN_VALUE AS UID_LANG_ID
				 FROM TABLE ( X_PKG_CM_SPLIT_STRING.split_to_char (l_uid_lang_exist))
				) x
			where bin_lic_number = lil_lic_number
			and lil_ter_code = ter_code
			AND LIL_RGH_CODE <> 'X'
			and sbt_bin_id = bin_id
			and SBT_LANG_ID = UID_LANG_ID
			and SBT_TER_CODE = ter_code
			and SBT_IE_FLAG = 'I'
			and sbt_bin_id = i_sbu_bin_id
			union all
			select BIN_ID,
					TO_NUMBER (x.UID_LANG_ID) UID_LANG_ID,
					TER_CODE,
					TER_NAME,
					'E' INCLUDE_FLAG
			from   FID_LICENSE_LEDGER,
				FID_TERRITORY,
				X_CP_SCHEDULE_BIN,
				(SELECT COLUMN_VALUE AS UID_LANG_ID
				 FROM TABLE ( X_PKG_CM_SPLIT_STRING.split_to_char (l_uid_lang_exist))
				) x
			where bin_lic_number = lil_lic_number
			and lil_ter_code = ter_code
			AND LIL_RGH_CODE <> 'X'
			and bin_id = i_sbu_bin_id
			and not exists (select 1 from X_CP_SCH_BIN_TERRITORY
							where SBT_LANG_ID = UID_LANG_ID
							and SBT_TER_CODE = ter_code
							and sbt_bin_id = bin_id
							and SBT_IE_FLAG = 'I'
							)
			and exists (select 1 from X_CP_SCH_BIN_TERRITORY
			where SBT_LANG_ID = UID_LANG_ID
			and sbt_bin_id = bin_id
			and SBT_IE_FLAG = 'I')
			union  all
			SELECT BIN_ID,
					to_number(LLT_LANG_ID) UID_LANG_ID,
					TER_CODE,
					TER_NAME,
					'I' INCLUDE_FLAG
			FROM X_VW_CP_LEE_LANG_TER_MAPP,
				  fid_license_ledger,
				  fid_territory,
				  x_cp_schedule_bin,
				  fid_license,
				  (SELECT COLUMN_VALUE AS UID_LANG_ID
				   FROM TABLE ( X_PKG_CM_SPLIT_STRING.split_to_char (l_uid_lang_notexist))
				  ) x
			WHERE  lil_ter_code = ter_code
			AND    bin_lic_number = lil_lic_number
			and    bin_lic_number = lic_number
			and    llt_ter_code = ter_code
			and    llt_lee_number = lic_lee_number
			AND    lil_rgh_code <> 'X'
			and    LLT_LANG_ID = UID_LANG_ID
			AND    Bin_Id = i_sbu_bin_id --TRSA ---TAFR -30637456--I_Bin_Id
      and not exists (select 1 from X_CP_SCH_BIN_TERRITORY
							where SBT_LANG_ID = nvl(UID_LANG_ID,1)
							--and SBT_TER_CODE = ter_code
							and sbt_bin_id = bin_id )
			UNION all
			SELECT BIN_ID,
					to_number(UID_LANG_ID) UID_LANG_ID,
					ter_code,
					TER_NAME,
					'E' INCLUDE_FLAG
			FROM   fid_license_ledger,
				  fid_territory,
				  x_cp_schedule_bin,
				  fid_license,
				  (SELECT COLUMN_VALUE AS UID_LANG_ID
				   FROM TABLE ( X_PKG_CM_SPLIT_STRING.split_to_char (l_uid_lang_notexist))
				  ) x
			WHERE  lil_ter_code = ter_code
			AND    bin_lic_number = lil_lic_number
			and    bin_lic_number = lic_number
			AND    lil_rgh_code <> 'X'
			AND    Bin_Id = i_sbu_bin_id --TRSA ---TAFR -30637456
      and not exists (select 1 from X_CP_SCH_BIN_TERRITORY
							where SBT_LANG_ID = nvl(UID_LANG_ID,1)
							--and SBT_TER_CODE = ter_code
							and sbt_bin_id = bin_id )
			and   not exists ( select 1
							   from  X_VW_CP_LEE_LANG_TER_MAPP
							   where llt_ter_code = ter_code
							   and llt_lee_number = lic_lee_number
							   and LLT_LANG_ID = UID_LANG_ID
							   )
			order by  UID_LANG_ID, INCLUDE_FLAG  desc
			;
   END x_prc_uid_terr_list;

   PROCEDURE x_prc_insert_sch_bin_uid (
      i_sbu_bin_id        IN     x_cp_sch_bin_uid.sbu_bin_id%TYPE,
      i_sbu_tap_barcode   IN     VARCHAR2,
      o_sucess_flag          OUT NUMBER)
   AS
   BEGIN
      o_sucess_flag := -1;

      DELETE FROM x_cp_sch_bin_uid
            WHERE sbu_bin_id = i_sbu_bin_id;

      INSERT INTO x_cp_sch_bin_uid (sbu_bin_id, sbu_tap_barcode)
         SELECT i_sbu_bin_id, COLUMN_VALUE
           FROM TABLE (
                   X_PKG_CM_SPLIT_STRING.split_to_char (i_sbu_tap_barcode));

      COMMIT;
      o_sucess_flag := 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20002, 'Error while inserting UID');
   END x_prc_insert_sch_bin_uid;

   /*To Save Territories in X_CP_SCH_BIN_TERRITORY for included ones */
   PROCEDURE x_prc_insert_sch_bin_ter (
      i_sbt_bin_id     IN     x_cp_sch_bin_territory.sbt_bin_id%TYPE,
      i_sbt_ter_code   IN     VARCHAR2,
      i_sbt_lang_id    IN     x_cp_sch_bin_territory.sbt_lang_id%TYPE,
      i_sbt_uid        IN     VARCHAR2,
      o_sucess_flag       OUT NUMBER)
   AS
      l_is_ter_code_available   NUMBER;
   BEGIN
      o_sucess_flag := -1;

      /*First delete all territories for given bin_id and language*/
      --CU4ALL sTART : [ANUJA SHINDE]
      DELETE FROM X_CP_SCH_BIN_TERRITORY
            WHERE     sbt_bin_id = i_sbt_bin_id
                  AND sbt_lang_id = i_sbt_lang_id
                  AND NVL (SBT_IE_FLAG, 'I') = 'I';

      --Added by swapnil malvi for CU4ALL on 21-03-2016
      DELETE FROM X_CP_SCH_BIN_TERRITORY
            WHERE sbt_bin_id = i_sbt_bin_id AND sbt_lang_id = i_sbt_lang_id
                  AND sbt_ter_code IN
                         (SELECT COLUMN_VALUE
                            FROM TABLE (
                                    X_PKG_CM_SPLIT_STRING.SPLIT_TO_CHAR (
                                       I_SBT_TER_CODE)));

      --Added by swapnil malvi for CU4ALL end

      IF i_sbt_uid IS NOT NULL
      THEN
         /*Then insert all territories that are present in Included List*/
         --CU4ALL sTART : [ANUJA SHINDE]
         INSERT INTO x_cp_sch_bin_territory (sbt_bin_id,
                                             sbt_lang_id,
                                             sbt_ter_code)
            SELECT i_sbt_bin_id, i_sbt_lang_id, COLUMN_VALUE      /*TER_CODE*/
                                                            FROM TABLE (X_PKG_CM_SPLIT_STRING.SPLIT_TO_CHAR (I_SBT_TER_CODE)) /*,FID_TERRITORY
                                                                                                                   WHERE TER_NAME =  COLUMN_VALUE*/
                                                                                                                             ;

         --CU4ALL : START [ANUJA SHINDE][02/02/2016]
         -- IF L_CU4ALL_FLAG = 'Y' THEN
         -- SET INCLUDE 'I' FLAG ON TERR BOUQ POPUP DATA WHEN INCLUDED IN THE TERRITORY POP UP
         UPDATE X_CP_PLT_TERR_BOUQ_TEMP
            SET PTBT_TER_IE_FLAG = 'I'
          WHERE PTBT_TER_IE_FLAG <> 'I'
                AND PTBT_TER_CODE IN
                       (SELECT UPPER (COLUMN_VALUE                /*ter_code*/
                                                  )
                          FROM TABLE (
                                  X_PKG_CM_SPLIT_STRING.SPLIT_TO_CHAR (
                                     I_SBT_TER_CODE)) /*,FID_TERRITORY
  where upper(ter_name) = upper(terr.COLUMN_VALUE)*/
                                                     )
                AND PTBT_PLT_ID IN (SELECT PLTT_ID
                                      FROM X_CP_PLAY_LIST_TEMP
                                     WHERE PLTT_BIN_ID = I_SBT_BIN_ID);

         --SET EXCLUDE 'E' FLAG ON TERR BOUQ POPUP DATA WHICH ARE EXCLUDED FROM TERRITORY POP UP
         UPDATE X_CP_PLT_TERR_BOUQ_TEMP
            SET PTBT_TER_IE_FLAG = 'E',
                PTBT_PLT_DEV_RIGHTS = 'N',
                PTBT_BOUQUET_RIGHTS = 'N',
                PTBT_BOUQ_SUPERS_RIGHTS = 'N'
          WHERE PTBT_TER_IE_FLAG <> 'E'
                AND PTBT_TER_CODE NOT IN
                       (SELECT UPPER (COLUMN_VALUE                /*ter_code*/
                                                  )
                          FROM TABLE (
                                  X_PKG_CM_SPLIT_STRING.SPLIT_TO_CHAR (
                                     I_SBT_TER_CODE)) TERR /*,FID_TERRITORY
 where upper(ter_name) = upper(terr.COLUMN_VALUE)*/
                                                          )
                AND PTBT_PLT_ID IN (SELECT PLTT_ID
                                      FROM X_CP_PLAY_LIST_TEMP
                                     WHERE PLTT_BIN_ID = I_SBT_BIN_ID);
      --  END IF;
      --CU4ALL : END

      END IF;

      COMMIT;
      o_sucess_flag := 1;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         o_sucess_flag := -1;
         raise_application_error (-20001, 'Territory Already Present');
      WHEN OTHERS
      THEN
         o_sucess_flag := -1;
         raise_application_error (-20002, 'Error while inserting Territory');
   END x_prc_insert_sch_bin_ter;

   /*Added by Swapnil Malvi on 23-Mar-2015 for Clearleap Release */
   /*To Save UIDs and Update Sch_channel, Sch_date and Sch_time in Schedule_Bin */
   PROCEDURE X_Prc_Save_VOD_Data (
      i_sch_cha_number   IN     NUMBER,
      i_sch_date         IN     DATE,
      i_sch_time         IN     VARCHAR2,
      i_bin_id           IN     x_cp_sch_bin_uid.sbu_bin_id%TYPE,
      i_uid              IN     VARCHAR2,
      o_sucess_flag         OUT NUMBER)
   AS
      L_BIN_SCH_NUMBER    NUMBER;
      L_TERRITORY_COUNT   NUMBER;
      l_lee_short_name    VARCHAR2 (50);
      L_LANG_ID           NUMBER;
      /*CU4ALL : START*/
      L_VCH_BOUQUET_ID    NUMBER;
      L_BIN_LIC_NUMBER    NUMBER;
      L_CON_NUMBER        NUMBER;
      L_CB_RANK           NUMBER;
      l_uid               varchar2(200) := i_uid;
   BEGIN
      o_sucess_flag := -1;

      BEGIN
         SELECT NVL (BIN_SCH_NUMBER, 0),
                BIN_LIC_NUMBER,
                (SELECT LIC_CON_NUMBER
                   FROM FID_LICENSE
                  WHERE LIC_NUMBER = BIN_LIC_NUMBER)
           INTO l_bin_sch_number, l_bin_lic_number, l_con_number
           FROM x_cp_schedule_bin
          WHERE bin_id = i_bin_id;

         SELECT Lee_Short_Name, NVL (Bin_Sch_Number, 0)
           INTO l_lee_short_name, l_bin_sch_number
           FROM X_Cp_Schedule_Bin, Fid_License, Fid_Licensee
          WHERE     Bin_Lic_Number = Lic_Number
                AND Lic_Lee_Number = Lee_Number
                AND Bin_Id = i_bin_id;

         IF NVL (l_bin_sch_number, 0) < 0
         THEN
            /*Update Schedule Bin*/
            UPDATE x_cp_schedule_bin
               SET bin_sch_cha_number = i_sch_cha_number,
                   --bin_sch_cha_number=decode(i_sch_cha_number,0,bin_sch_cha_number,i_sch_cha_number),/*Temporary change*/
                   BIN_SCH_DATE = i_sch_date,
                   BIN_LINEAR_SCH_TIME =
                      DECODE (i_sch_time,
                              NULL, NULL,
                              convert_time_c_n (i_sch_time))
             WHERE bin_id = i_bin_id;


            /*CU4ALL : START [ANUJa SHINDE]
            Update bouquet information for catchup3p license ON SELECTION OF VOD channel*/
            IF I_SCH_CHA_NUMBER <> 0
            THEN
               BEGIN
               SELECT VCH_BOUQUET_ID, CB_RANK
                 INTO L_VCH_BOUQUET_ID, L_CB_RANK
                 FROM X_VOD_CHANNEL, X_CP_BOUQUET
                WHERE CB_ID = VCH_BOUQUET_ID
                      AND VCH_NUMBER = i_sch_cha_number;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                null;
                END;
               UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                  SET PTBT_BOUQUET_RIGHTS = 'N',
                      PTBT_BOUQ_SUPERS_RIGHTS = 'N'
                WHERE PTBT_PLT_ID IN (SELECT PLTT_ID
                                        FROM X_CP_PLAY_LIST_TEMP
                                       WHERE PLTT_BIN_ID = I_BIN_ID)
                      AND PTBT_BOUQUET_ID NOT IN
                             (SELECT CB_ID
                                FROM X_CON_BOUQUE_MAPP, X_CP_BOUQUET
                               WHERE     CBM_BOUQUE_ID = CB_ID
                                     AND CBM_CON_NUMBER = l_con_number
                                     AND CB_RANK <= L_CB_RANK
                                     AND CBM_CON_BOUQ_RIGHTS = 'Y');

               UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                  SET PTBT_BOUQUET_RIGHTS = 'Y',
                      PTBT_BOUQ_SUPERS_RIGHTS =
                         (SELECT NVL (LSR_SUPERSTACK_FLAG, 'N')
                            FROM x_cp_lic_superstack_rights
                           WHERE LSR_LIC_NUMBER = l_bin_lic_number
                                 AND lsr_bouquet_id = PTBT_BOUQUET_ID)
                WHERE PTBT_PLT_ID IN (SELECT PLTT_ID
                                        FROM X_CP_PLAY_LIST_TEMP
                                       WHERE PLTT_BIN_ID = I_BIN_ID)
                      AND PTBT_BOUQUET_ID IN
                             (SELECT CB_ID
                                FROM X_CON_BOUQUE_MAPP, X_CP_BOUQUET
                               WHERE     CBM_BOUQUE_ID = CB_ID
                                     AND CBM_CON_NUMBER = L_CON_NUMBER
                                     AND CB_RANK <= L_CB_RANK
                                     AND CBM_CON_BOUQ_RIGHTS = 'Y');
            END IF;
         /*CU4ALL : START [ANUJA SHINDE]*/
         END IF;
      END;

      BEGIN
         /*Delete UIDs for given Bin*/
         DELETE FROM x_cp_sch_bin_uid
               WHERE sbu_bin_id = i_bin_id;

         IF l_uid IS NOT NULL
         THEN
            /*Insert UIDs for given Bin*/
			INSERT INTO x_cp_sch_bin_uid (sbu_bin_id, sbu_tap_barcode)
			SELECT i_bin_id, COLUMN_VALUE
			FROM TABLE (X_PKG_CM_SPLIT_STRING.split_to_char (l_uid));

         END IF;
      END;

      /*added by khilesh chauhan  for default territory if not specified in schedule grid window.*/
			DELETE FROM x_cp_sch_bin_territory
			WHERE sbt_bin_id = i_bin_id
			AND sbt_lang_id NOT IN
			(	SELECT UID_LANG_ID
				FROM x_cp_sch_bin_uid, fid_tape, x_uid_language
				WHERE sbu_tap_barcode = tap_barcode
				AND DECODE (NVL(TAP_UID_LANG_ID, 1),0, 1,NVL(TAP_UID_LANG_ID, 1)) =	UID_LANG_ID
				AND SBU_BIN_ID = I_BIN_ID
			);

			IF l_uid IS  NULL
			THEN
				l_uid := 'NULL';
			END IF;

			FOR barcode
			IN (	SELECT COLUMN_VALUE AS barcode_uid
					FROM TABLE (X_PKG_CM_SPLIT_STRING.SPLIT_TO_CHAR (l_uid))
			  )
			LOOP
				if barcode.BARCODE_UID =  'NULL'
				then
					l_lang_id := 1;
				else
					begin

						SELECT decode(nvl(TAP_UID_LANG_ID,0),0,1,TAP_UID_LANG_ID)
						INTO l_lang_id
						FROM fid_tape
						WHERE tap_barcode = barcode.BARCODE_UID
						;
					exception
					when others
					then
						l_lang_id := 1;
					end;
				end if;

				SELECT COUNT (1)
				INTO l_territory_count
				FROM X_CP_SCH_BIN_TERRITORY
				WHERE  sbt_bin_id = i_bin_id
				AND sbt_lang_id = l_lang_id
				AND SBT_IE_FLAG = 'I'                            /*CU4ALL*/
				;

				IF l_territory_count = 0
				THEN
				   DELETE FROM x_cp_sch_bin_territory
				   WHERE sbt_bin_id = i_bin_id
				   and sbt_lang_id = l_lang_id
           ;

				   INSERT INTO x_cp_sch_bin_territory
				   (	sbt_bin_id,
						sbt_ter_code,
						sbt_lang_id,
						SBT_IE_FLAG
					)
					SELECT bin_id,
							ter_code,
							LLT_LANG_ID UID_LANG_ID,
							'I' flag
					FROM X_VW_CP_LEE_LANG_TER_MAPP,
						fid_license_ledger,
						fid_territory,
						x_cp_schedule_bin,
						fid_license
					WHERE  lil_ter_code = ter_code
					AND    bin_lic_number = lil_lic_number
					and    bin_lic_number = lic_number
					and    llt_ter_code = ter_code
					and    llt_lee_number = lic_lee_number
					AND    lil_rgh_code <> 'X'
					and    LLT_LANG_ID = l_lang_id
					AND    Bin_Id = i_bin_id
					UNION
					SELECT bin_id,
							ter_code,
							to_number(l_lang_id) UID_LANG_ID,
							'E' flag
					FROM   fid_license_ledger,
							fid_territory,
							x_cp_schedule_bin,
							fid_license
					WHERE  lil_ter_code = ter_code
					AND    bin_lic_number = lil_lic_number
					and    bin_lic_number = lic_number
					AND    lil_rgh_code <> 'X'
					AND    Bin_Id = i_bin_id
					and   not exists ( select 1
										from  X_VW_CP_LEE_LANG_TER_MAPP
										where llt_ter_code = ter_code
										and llt_lee_number = lic_lee_number
										and LLT_LANG_ID = l_lang_id
										)
					order by flag
					;
				END IF;
			END LOOP;
      COMMIT;
      O_SUCESS_FLAG := 1;
   EXCEPTION
      WHEN OTHERS
      THEN
         o_sucess_flag := -1;
         raise_application_error (-20002, 'Error while inserting UID');
   END X_PRC_SAVE_VOD_DATA;

   /*END */

   --CU4ALL : START : [ANUJA_SHINDE] [06/01/2016]
   PROCEDURE X_PRC_LOAD_TERR_BOUQUET_DATA (
      I_BIN_ID                   IN     NUMBER,
      I_BIN_LIC_NUMBER           IN     NUMBER,
      i_dev_ids         IN      VARCHAR2,
     i_entry_oper      IN       VARCHAR2,
      O_TERR_DATA                   OUT SYS_REFCURSOR,
      O_PRIMARY_BOUQ_DATA           OUT SYS_REFCURSOR,
      O_SUB_BOUQ_DATA               OUT SYS_REFCURSOR,
      O_MEDIA_DEV_DATA              OUT SYS_REFCURSOR,
      O_MEDIA_DEV_DATA_DEFAULT      OUT SYS_REFCURSOR,
      O_SUB_BOUQ_DATA_DEFAULT       OUT SYS_REFCURSOR,
      O_COMP_RIGHTS_FOR_LIC         OUT SYS_REFCURSOR
      ,O_SUPERSTACK_AVAIL_DATES OUT SYS_REFCURSOR)
   AS
      L_TERR_CNT               NUMBER;
      L_IS_SCHEDULED           NUMBER;
      L_DEV_SQLSTMNT           CLOB;
      L_DEV_SQLSTMNT_DEFAULT   CLOB;
      L_CP_COMP_LIST           VARCHAR2 (300);
      L_COMP_ID_LIST           VARCHAR2 (100);
      L_SQLSTMNT_COMP_RYTS     VARCHAR2 (3000);
      l_prog_type       varchar2(1);
      l_Sch_end_time    number;
   BEGIN
   x_prc_clr_temp_table_data(I_BIN_LIC_NUMBER,I_BIN_ID,i_dev_ids,i_entry_oper);
      SELECT COUNT (1)
        INTO L_TERR_CNT
        FROM X_CP_SCH_BIN_TERRITORY
       WHERE sbt_bin_id = I_BIN_ID;

      /*  select COUNT (1)
          INTO L_IS_SCHEDULED
          from X_CP_PLAY_LIST
         WHERE PLT_BIN_ID = I_BIN_ID;*/

      SELECT x_fun_get_CP_compat () INTO l_cp_comp_list FROM DUAL;

      IF L_TERR_CNT = 0             /*insert default territories for license*/
      THEN
         -- cu4all START : ANUJA SHINDE[05/01/2016]
         -- Get all the territories for license
         INSERT INTO X_CP_SCH_BIN_TERRITORY (SBT_BIN_ID,
                                             SBT_TER_CODE,
                                             SBT_LANG_ID,
                                             SBT_IE_FLAG)
			SELECT bin_id,
				ter_code,
				LLT_LANG_ID UID_LANG_ID,
				'I' flag
			FROM X_VW_CP_LEE_LANG_TER_MAPP,
				  fid_license_ledger,
				  fid_territory,
				  x_cp_schedule_bin,
				  fid_license
			WHERE  lil_ter_code = ter_code
			AND    bin_lic_number = lil_lic_number
			and    bin_lic_number = lic_number
			and    llt_ter_code = ter_code
			and    llt_lee_number = lic_lee_number
			AND    lil_rgh_code <> 'X'
			and    LLT_LANG_ID = 1 --l_lang_id
			AND    Bin_Id = I_BIN_ID
			UNION all
			SELECT bin_id,
					ter_code,
					1 UID_LANG_ID,
					'E' flag
			FROM   fid_license_ledger,
				  fid_territory,
				  x_cp_schedule_bin,
				  fid_license
			WHERE  lil_ter_code = ter_code
			AND    bin_lic_number = lil_lic_number
			and    bin_lic_number = lic_number
			AND    lil_rgh_code <> 'X'
			AND    Bin_Id = I_BIN_ID
			and   not exists ( select 1
							   from  X_VW_CP_LEE_LANG_TER_MAPP
							   where llt_ter_code = ter_code
							   and llt_lee_number = lic_lee_number
							   and LLT_LANG_ID = 1
							   )
			 order by flag
			;
		END IF;

      -- IF L_IS_SCHEDULED = 0
      -- then                                /*display default data for license*/
      OPEN O_TERR_DATA FOR
           SELECT DISTINCT PTBT_TER_CODE TER_CODE,
                           PLTT_BIN_ID BIN_ID,
                           TERR.PTBT_TER_IE_FLAG TER_IE_FLAG,
                           PLTT_SCH_NOTES SCH_NOTES,
                           (SELECT TER_ISO_CODE
                              FROM FID_TERRITORY
                             WHERE TER_CODE = PTBT_TER_CODE)
                              TER_ISO_CODE,
                           PTBT_UPDATE_COUNT UPDATE_COUNT
             FROM X_CP_PLT_TERR_BOUQ_TEMP TERR, X_CP_PLAY_LIST_TEMP
            WHERE TERR.PTBT_PLT_ID = PLTT_ID AND pltt_bin_id = I_BIN_ID
         ORDER BY ter_code;

      OPEN O_PRIMARY_BOUQ_DATA FOR
           SELECT DISTINCT
                  PLTT_BIN_ID bin_id,
                  PTBT_TER_CODE TER_CODE,
                  (SELECT ter_iso_code
                     FROM FID_TERRITORY
                    WHERE ter_code = PTBT_TER_CODE)
                     ter_iso_code,
                  PTBT_TER_IE_FLAG TER_IE_FLAG,
                  DECODE (PTBT_TER_IE_FLAG, 'E', 'N', PTBT_BOUQUET_RIGHTS)
                     IS_BOUQ_CHECKED,
                  PTBT_BOUQUET_ID BOUQ_ID,
                  CB_NAME BOUQ_NAME,
                  CB_SHORT_CODE BOUQ_SHORT_NAME,
                  CB_RANK BOUQ_RANK,
--                  DECODE (PTBT_BOUQUET_RIGHTS,
--                          'Y', NVL (PTBT_BOUQ_SUPERS_RIGHTS, 'N'),
--                          'N')
--                     SUPER_STACK,
                     (CASE WHEN BIN_SUPERSTACK_AVAIL_TO IS NOT NULL THEN
                          DECODE (PTBT_BOUQUET_RIGHTS,'Y', NVL (PTBT_BOUQ_SUPERS_RIGHTS, 'N'),'N')
                          ELSE
                          'N'
                          END )SUPER_STACK,
                      (CASE WHEN BIN_SUPERSTACK_AVAIL_TO IS NOT NULL THEN
                                NVL ((SELECT LSR_SUPERSTACK_FLAG FROM X_CP_LIC_SUPERSTACK_RIGHTS
                                      WHERE LSR_LIC_NUMBER = I_BIN_LIC_NUMBER
                                      AND LSR_BOUQUET_ID = CB_ID),
                                    'N')
                             ELSE
                              'N'
                              END)
                     LIC_SUPERSTACK_RIGHT,
                  NVL (
                     (SELECT CBM_CON_BOUQ_RIGHTS
                        FROM X_CON_BOUQUE_MAPP, FID_LICENSE
                       WHERE     LIC_CON_NUMBER = CBM_CON_NUMBER
                             AND LIC_NUMBER = I_BIN_LIC_NUMBER
                             AND CBM_BOUQUE_ID = CB_ID),
                     'N')
                     con_bouq_rights,
                  BIN_SUPERSTACK_AVAIL_FROM,
                  BIN_SUPERSTACK_AVAIL_TO,
                  PTBT_UPDATE_COUNT UPDATE_COUNT
             FROM X_CP_PLAY_LIST_TEMP,
                  X_CP_PLT_TERR_BOUQ_TEMP,
                  X_CP_BOUQUET,
                  X_CP_SCHEDULE_BIN
            WHERE     PLTT_ID = PTBT_PLT_ID
                  AND PTBT_BOUQUET_ID = CB_ID
                  AND PLTT_BIN_ID = BIN_ID
                  AND PLTT_BIN_ID = I_BIN_ID
         ORDER BY TER_CODE, bouq_rank;
 --Added by Milan Shah for CU4ALL

        select x_fnc_get_prog_type(lic_budget_code) INTO l_prog_type
        from fid_license
        where lic_number = I_BIN_LIC_NUMBER;

        BEGIN
        select sch_end_time into l_Sch_end_time
        from fid_schedule,x_cp_schedule_bin
        where bin_id = I_BIN_ID
              and sch_number = bin_sch_number;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            l_Sch_end_time := 0;
         END;

        IF l_prog_type = 'Y'
        THEN
          OPEN O_SUPERSTACK_AVAIL_DATES FOR
               select md_id
                      ,md_code
                      --,MAX(mpdc_sch_start_aft_lnr_sch_ser)
                      ,to_date(
                              ((SELECT nvl(BIN_SUPERSTACK_AVAIL_FROM,to_date('01-01-1900','DD-MM-RRRR')) FROM x_cp_schedule_bin WHERE bin_id = I_BIN_ID)
                                ||' '||convert_time_n_c(l_Sch_end_time+(max(mpdc_sch_start_aft_lnr_sch_ser)))),'DD-MON-RRRR HH24:MI;SS') BIN_SUPERSTACK_AVAIL_FROM
                      ,to_date(
                              ((SELECT nvl(BIN_SUPERSTACK_AVAIL_TO,to_date('01-01-1900','DD-MM-RRRR')) FROM x_cp_schedule_bin where bin_id = I_BIN_ID)
                                ||' '||convert_time_n_c(l_Sch_end_time)),'DD-MON-RRRR HH24:MI;SS')BIN_SUPERSTACK_AVAIL_TO
          from
              x_cp_media_device
             ,x_cp_med_platm_dev_compat_map
             ,x_cp_media_dev_platm_map
          WHERE mpdc_dev_platm_id = mdp_map_id
                AND mdp_map_dev_id = md_id
          GROUP BY md_id,md_code;
        ELSE
          OPEN O_SUPERSTACK_AVAIL_DATES FOR
               select md_id
                      ,md_code
                      --,MAX(mpdc_sch_start_aft_lnr_sch_mov)
                       ,to_date(
                              ((SELECT nvl(BIN_SUPERSTACK_AVAIL_FROM,to_date('01-01-1900','DD-MM-RRRR')) FROM x_cp_schedule_bin WHERE bin_id = I_BIN_ID)
                                ||' '||convert_time_n_c(l_Sch_end_time+(max(mpdc_sch_start_aft_lnr_sch_mov)))),'DD-MON-RRRR HH24:MI;SS') BIN_SUPERSTACK_AVAIL_FROM
                      ,to_date(
                              ((SELECT nvl(BIN_SUPERSTACK_AVAIL_TO,to_date('01-01-1900','DD-MM-RRRR')) FROM x_cp_schedule_bin where bin_id = I_BIN_ID)
                                ||' '||convert_time_n_c(l_Sch_end_time)),'DD-MON-RRRR HH24:MI;SS')BIN_SUPERSTACK_AVAIL_TO
          from
              x_cp_media_device
             ,x_cp_med_platm_dev_compat_map
             ,x_cp_media_dev_platm_map
          WHERE mpdc_dev_platm_id = mdp_map_id
                AND mdp_map_dev_id = md_id
          GROUP BY md_id,md_code;
        END IF;

        --Ended by Milan Shah CU4ALL
      OPEN O_SUB_BOUQ_DATA FOR
           SELECT DISTINCT
                  PTBT_TER_CODE TER_CODE,
                  (SELECT CB_BOUQ_PARENT_ID
                     FROM X_CP_BOUQUET
                    WHERE CB_ID = CPST_SUBBOUQUET_ID)
                     CB_ID_PRI,
                  DECODE (
                     PTBT_BOUQUET_RIGHTS,
                     'Y', DECODE (PTBT_TER_IE_FLAG,
                                  'E', 'N',
                                  CPST_SUBBOUQUET_RIGHTS),
                     'N', 'N')
                     IS_SUB_CHKED,
                  --CPST_SUBBOUQUET_RIGHTS IS_SUB_CHKED,
                  --decode(ptbt_bouquet_rights,'N','N',CPST_SUBBOUQUET_RIGHTS) IS_SUB_CHKED,
                  (SELECT CB_NAME
                     FROM X_CP_BOUQUET
                    WHERE CB_ID = CPST_SUBBOUQUET_ID)
                     CB_NAME,
                  (SELECT CB_SHORT_CODE
                     FROM X_CP_BOUQUET
                    WHERE CB_ID = CPST_SUBBOUQUET_ID)
                     CB_SHORT_CODE,
                  (SELECT CB_id
                     FROM X_CP_BOUQUET
                    WHERE CB_ID = CPST_SUBBOUQUET_ID)
                     CB_ID,
                  (SELECT CB_rank
                     FROM X_CP_BOUQUET
                    WHERE CB_ID = CPST_SUBBOUQUET_ID)
                     CB_RANK
             FROM X_CP_PLT_SUBBOUQ_MAPP_TEMP,
                  X_CP_PLT_TERR_BOUQ_TEMP,
                  X_CP_PLAY_LIST_TEMP
            --,X_CP_BOUQUET
            WHERE     PTBT_ID = CPST_PTB_ID
                  AND PLTT_ID = PTBT_PLT_ID
                  AND CPST_SUBBOUQUET_ID <> 0
                  AND PLTT_BIN_ID = I_BIN_ID
         -- and PTBT_BOUQUET_ID = CB_ID
         ORDER BY TER_CODE, CB_ID_PRI, CB_ID;

      L_dev_SQLSTMNT :=
         'select * from (
                                    SELECT PLTT_ID plt_id,PLTT_BIN_ID bin_id,PTBT_TER_CODE TER_CODE
                                    ,(select ter_iso_code from FID_TERRITORY where ter_code = PTBT_TER_CODE) ter_iso_code
                                    ,PTBT_TER_IE_FLAG TER_IE_FLAG
                                    ,decode(PTBT_TER_IE_FLAG,''E'',''N'',PTBT_BOUQUET_RIGHTS) IS_BOUQ_CHECKED
                                    ,PTBT_BOUQUET_ID BOUQ_ID
                                    ,CB_NAME BOUQ_NAME,CB_SHORT_CODE BOUQ_short_NAME,CB_RANK bouq_rank,
                                    (CASE WHEN BIN_SUPERSTACK_AVAIL_TO IS NOT NULL THEN
                                              decode(PTBT_BOUQUET_RIGHTS,''Y'',NVL(PTBT_BOUQ_SUPERS_RIGHTS,''N''),''N'')
                                              ELSE
                                              ''N''
                                              END)
                                              SUPER_STACK,
                                                                    NVL((SELECT CBM_CON_BOUQ_RIGHTS FROM X_CON_BOUQUE_MAPP,FID_LICENSE
                                                                   WHERE LIC_CON_NUMBER = CBM_CON_NUMBER
                                                                   AND LIC_NUMBER = '
         || I_BIN_LIC_NUMBER
         || '
                                                                   and CBM_BOUQUE_ID = CB_ID ),''N'') con_bouq_rights
                                                                    ,BIN_SUPERSTACK_AVAIL_FROM
                                                                    ,BIN_SUPERSTACK_AVAIL_TO
                                                                    ,CDCR_DEV_ID DEV_ID
                                                                    ,MD_CODE
                                                                    ,MDC_CODE
                                                                    ,CDCR_COMP_RIGHTS
                                                                    ,MD_DESC
                                                                    ,DECODE(PTBT_TER_IE_FLAG,''E'',''N'',(DECODE(PTBT_BOUQUET_RIGHTS,''N'',''N'',PTBT_PLT_DEV_RIGHTS))) RIGHTS_ON_DEVICE
                                                                    ,(SELECT DISTINCT LIC_RIGHTS_ON_DEVICE
                                                                      FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP WHERE  LIC_MPDC_LIC_NUMBER = '''
         || I_BIN_LIC_NUMBER
         || '''
                                                                      AND LIC_MPDC_DEV_PLATM_ID = MD_ID) LIC_DEV_RIGHTS
                                                                    ,PTBT_PVR_START_DATE PVR_START
                                                                    ,PTBT_PVR_END_DATE PVR_END
                                                                    ,PTBT_OTT_START_DATE OTT_START
                                                                    ,PTBT_OTT_END_DATE OTT_END
                                                                    ,SYSDATE - 2 avail_from
                                                                    ,SYSDATE + 6 avail_to
                                                                    ,PLTT_SCH_NOTES SCH_NOTES
                                                                    ,PTBT_UPDATE_COUNT UPDATE_COUNT
                                    FROM X_CP_PLAY_LIST_TEMP
                                        ,X_CP_PLT_TERR_BOUQ_TEMP
                                        ,X_CP_BOUQUET
                                        ,X_CP_SCHEDULE_BIN
                                        ,X_CP_PLT_DEVCOMP_RIGHTS_TEMP
                                        ,X_CP_MEDIA_DEVICE_COMPAT
                                        ,X_CP_MEDIA_DEVICE
                                    WHERE PLTT_ID = PTBT_PLT_ID
                                    AND PTBT_BOUQUET_ID = CB_ID
                                    AND PLTT_BIN_ID = BIN_ID
                                    AND CDCR_PTBT_ID = PTBT_ID
                                    AND CDCR_DEV_ID = MD_ID
                                    AND CDCR_COMP_ID = MDC_ID
                                    AND PLTT_BIN_ID = '
         || I_BIN_ID
         || ')
                                    PIVOT( MAX(CDCR_COMP_RIGHTS) FOR MDC_CODE IN ('
         || L_CP_COMP_LIST
         || ') ) order by TER_CODE,bouq_rank,DEV_ID';

      OPEN O_MEDIA_DEV_DATA FOR L_DEV_SQLSTMNT;


      --
      --select *
      --                             from (select DEV.PLTT_ID PLT_ID ,DEV.PLTT_BIN_ID BIN_ID,
      --                                          TERR.SBT_TER_CODE TER_CODE,
      --                                          TERR.SBT_IE_FLAG TER_IE_FLAG,
      --                                          (select TER_ISO_CODE from FID_TERRITORY where TER_CODE = TERR.SBT_TER_CODE)TER_ISO_CODE,
      --                                          BOUQ.IS_BOUQ_CHECKED IS_BOUQ_CHECKED,
      --                                          BOUQ.BOUQ_ID BOUQ_ID,
      --                                          BOUQ.CB_NAME BOUQ_NAME,
      --                                          BOUQ.CB_SHORT_CODE BOUQ_SHORT_NAME,
      --                                          BOUQ.CB_RANK BOUQ_RANK,
      --                                          BOUQ.SUPER_STACK SUPER_STACK,
      --                                          --CON_BOUQ_RIGHTS,
      --                                          BOUQ.BIN_SUPERSTACK_AVAIL_FROM BIN_SUPERSTACK_AVAIL_FROM,
      --                                          BOUQ.BIN_SUPERSTACK_AVAIL_TO BIN_SUPERSTACK_AVAIL_TO,
      --                                          DEV.PLTT_DEV_ID DEV_ID
      --                                          --MD_CODE,
      --                                          --MD_DESC,
      --                                          --RIGHTS_ON_DEVICE,
      --                                          --LIC_DEV_RIGHTS,
      --                                     FROM X_CP_SCH_BIN_TERRITORY TERR,
      --                                          (SELECT 'Y'
      --                                                     IS_BOUQ_CHECKED,
      --                                                  CB_ID BOUQ_ID,
      --                                                  CB_SHORT_CODE,
      --                                                  CB_RANK,
      --                                                  CB_NAME,
      --                                                  NVL ((SELECT LSR_SUPERSTACK_FLAG
      --                                                        FROM x_cp_lic_superstack_rights
      --                                                        WHERE lsr_lic_number =  1006218
      --                                                              AND lsr_bouquet_id =  CB_ID),'N') SUPER_STACK,
      --                                                  BIN_SUPERSTACK_AVAIL_FROM,
      --                                                  BIN_SUPERSTACK_AVAIL_TO
      --                                             FROM X_CP_SCH_BOUQUET_MAPP,
      --                                                  X_CP_BOUQUET,X_CP_BOUQUET_MS_MAPP,
      --                                                  X_CP_SCHEDULE_BIN
      --                                            WHERE CMM_BOUQ_ID = CB_ID
      --                                             and CMM_BOUQ_MS_CODE = 'CATCHUP'
      --                                             AND CMM_BOUQ_MS_RIGHTS = 'Y'
      --                                              and NVL (CB_BOUQ_PARENT_ID,0) = 0
      --                                                  AND CB_AD_FLAG ='A'
      --                                                  AND BIN_ID =SBM_BIN_ID
      --                                                  AND CB_ID = SBM_BOUQUET_ID
      --                                                  AND SBM_BIN_ID =20389810
      --                                           UNION
      --                                           SELECT 'N' IS_BOUQ_CHECKED,
      --                                                  CB_ID BOUQ_ID,
      --                                                  CB_SHORT_CODE,
      --                                                  CB_RANK,
      --                                                  CB_NAME,
      --                                                  NVL ((SELECT LSR_SUPERSTACK_FLAG
      --                                                        FROM x_cp_lic_superstack_rights
      --                                                        WHERE lsr_lic_number =  1006218
      --                                                              AND lsr_bouquet_id =  CB_ID),'N')SUPER_STACK,
      --                                                  NULL
      --                                                     BIN_SUPERSTACK_AVAIL_FROM,
      --                                                  NULL
      --                                                     BIN_SUPERSTACK_AVAIL_TO
      --                                             FROM X_CP_BOUQUET,X_CP_BOUQUET_MS_MAPP
      --                                            WHERE
      --                                            CMM_BOUQ_ID = CB_ID
      --                                             and CMM_BOUQ_MS_CODE = 'CATCHUP'
      --                                             AND CMM_BOUQ_MS_RIGHTS = 'Y'
      --                                             and NVL (
      --                                                     CB_BOUQ_PARENT_ID,
      --                                                     0) = 0
      --                                                  AND CB_AD_FLAG =
      --                                                         'A'
      --                                                  AND CB_ID NOT IN
      --                                                         (SELECT SBM_BOUQUET_ID
      --                                                            FROM X_CP_SCH_BOUQUET_MAPP
      --                                                           WHERE SBM_BIN_ID =
      --                                                                    20389810)) BOUQ,
      --                                                          (select
      --                                                                   PLTT_ID,PLTT_DEV_ID,PLTT_BIN_ID,
      --                                                                    MDP_MAP_PLATM_CODE,
      --                                                                    1006218,
      --                                                                    (   NVL((SELECT DISTINCT 'Y'
      --                     FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP
      --                     WHERE LIC_MPDC_LIC_NUMBER = 1006218
      --                     and LIC_RIGHTS_ON_DEVICE = 'Y'
      --                     and LIC_MPDC_DEV_PLATM_ID = PLTT_DEV_ID),'N')) LIC_RIGHTS_ON_DEVICE from X_CP_PLAY_LIST_TEMP,X_CP_MEDIA_DEV_PLATM_MAP
      --                                                                                      where MDP_MAP_DEV_ID = PLTT_DEV_ID
      --                                                                                            and PLTT_BIN_ID = 20389810) DEV
      --                                    WHERE SBT_BIN_ID = 20389810)
      --                         order by TER_CODE,
      --                                  BOUQ_SHORT_NAME;
      L_DEV_SQLSTMNT_DEFAULT :=
         'select * from (
                                    SELECT PLTT_ID plt_id,PLTT_BIN_ID bin_id,PTBT_TER_CODE TER_CODE
                                    ,(select ter_iso_code from FID_TERRITORY where ter_code = PTBT_TER_CODE) ter_iso_code
                                    ,PTBT_TER_IE_FLAG TER_IE_FLAG
                                    ,PTBT_BOUQUET_RIGHTS IS_BOUQ_CHECKED
                                    ,PTBT_BOUQUET_ID BOUQ_ID
                                    ,CB_NAME BOUQ_NAME,CB_SHORT_CODE BOUQ_short_NAME,CB_RANK bouq_rank,
                                    (CASE WHEN BIN_SUPERSTACK_AVAIL_TO IS NOT NULL THEN
                                            NVL ((SELECT LSR_SUPERSTACK_FLAG
                                                  FROM x_cp_lic_superstack_rights
                                                  where LSR_LIC_NUMBER =  '|| I_BIN_LIC_NUMBER|| '
                                             AND lsr_bouquet_id =  CB_ID),''N'')
                                             ELSE
                                              ''N''
                                              END)
                                             SUPER_STACK,
                                                                    NVL((SELECT CBM_CON_BOUQ_RIGHTS FROM X_CON_BOUQUE_MAPP,FID_LICENSE
                                                                   WHERE LIC_CON_NUMBER = CBM_CON_NUMBER
                                                                   AND LIC_NUMBER = '
         || I_BIN_LIC_NUMBER
         || '
                                                                   and CBM_BOUQUE_ID = CB_ID ),''N'') con_bouq_rights
                                                                    ,BIN_SUPERSTACK_AVAIL_FROM
                                                                    ,BIN_SUPERSTACK_AVAIL_TO
                                                                    ,CDCR_DEV_ID DEV_ID
                                                                    ,MD_CODE
                                                                    ,MDC_CODE
                                                                    ,CDCR_COMP_RIGHTS
                                                                    ,MD_DESC
                                                                    ,PTBT_PLT_DEV_RIGHTS RIGHTS_ON_DEVICE
                                                                    ,(SELECT DISTINCT LIC_RIGHTS_ON_DEVICE
                                                                      FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP WHERE  LIC_MPDC_LIC_NUMBER = '''
         || I_BIN_LIC_NUMBER
         || '''
                                                                      AND LIC_MPDC_DEV_PLATM_ID = MD_ID) LIC_DEV_RIGHTS
                                                                    ,PTBT_PVR_START_DATE PVR_START
                                                                    ,PTBT_PVR_END_DATE PVR_END
                                                                    ,PTBT_OTT_START_DATE OTT_START
                                                                    ,PTBT_OTT_END_DATE OTT_END
                                                                    ,SYSDATE - 2 avail_from
                                                                    ,SYSDATE + 6 avail_to
                                                                    ,PLTT_SCH_NOTES SCH_NOTES
                                                                    ,PTBT_UPDATE_COUNT UPDATE_COUNT
                                    FROM X_CP_PLAY_LIST_TEMP
                                        ,X_CP_PLT_TERR_BOUQ_TEMP
                                        ,X_CP_BOUQUET
                                        ,X_CP_SCHEDULE_BIN
                                        ,X_CP_PLT_DEVCOMP_RIGHTS_TEMP
                                        ,X_CP_MEDIA_DEVICE_COMPAT
                                        ,X_CP_MEDIA_DEVICE
                                    WHERE PLTT_ID = PTBT_PLT_ID
                                    AND PTBT_BOUQUET_ID = CB_ID
                                    AND PLTT_BIN_ID = BIN_ID
                                    AND CDCR_PTBT_ID = PTBT_ID
                                    AND CDCR_DEV_ID = MD_ID
                                    AND CDCR_COMP_ID = MDC_ID
                                    AND PLTT_BIN_ID = '
         || I_BIN_ID
         || ')
                                    PIVOT( MAX(CDCR_COMP_RIGHTS) FOR MDC_CODE IN ('
         || L_CP_COMP_LIST
         || ') ) order by TER_CODE,bouq_rank,DEV_ID';

      OPEN O_MEDIA_DEV_DATA_DEFAULT FOR L_DEV_SQLSTMNT_DEFAULT;

      --          open O_SUB_BOUQ_DATA_DEFAULT for
      --           select  distinct PTBT_TER_CODE TER_CODE,CB_ID CB_ID_PRI,
      --               CPST_SUBBOUQUET_RIGHTS IS_SUB_CHKED,
      --               (select CB_NAME from X_CP_BOUQUET where CB_ID = CPST_SUBBOUQUET_ID) CB_NAME
      --               ,(select CB_SHORT_CODE from X_CP_BOUQUET where CB_ID = CPST_SUBBOUQUET_ID) CB_SHORT_CODE
      --               ,(select CB_id from X_CP_BOUQUET where CB_ID = CPST_SUBBOUQUET_ID) CB_ID
      --               ,(SELECT CB_rank FROM X_CP_BOUQUET WHERE CB_ID = CPST_SUBBOUQUET_ID) CB_RANK
      --        FROM X_CP_PLT_SUBBOUQ_MAPP_TEMP
      --                     ,X_CP_PLT_TERR_BOUQ_TEMP
      --                     ,X_CP_PLAY_LIST_TEMP
      --                     ,X_CP_BOUQUET
      --            WHERE PTBT_ID = CPST_PTB_ID
      --             AND PLTT_ID = PTBT_PLT_ID
      --             AND PLTT_BIN_ID = I_BIN_ID
      --             and PTBT_BOUQUET_ID = CB_ID
      --        order by TER_CODE ,CB_ID_PRI,CB_ID;
      OPEN O_SUB_BOUQ_DATA_DEFAULT FOR
         SELECT STM_TER_CODE TER_CODE,
                CB_BOUQ_PARENT_ID CB_ID_PRI,
                'Y' IS_SUB_CHKED,
                BOUQ.CB_NAME CB_NAME,
                BOUQ.CB_SHORT_CODE CB_SHORT_CODE,
                BOUQ.CB_ID CB_ID,
                CB_RANK
           FROM X_SAT_BOUQUET_MAPP,
                X_SATELLITE_TERR_MAPP,
                X_CP_BOUQUET BOUQ,
                X_CP_BOUQUET_MS_MAPP,
                (SELECT CB_ID
                   FROM X_CP_BOUQUET, X_CP_BOUQUET_MS_MAPP
                  WHERE     CMM_BOUQ_ID = CB_ID
                        AND CB_AD_FLAG = 'A'
                        AND CMM_BOUQ_MS_RIGHTS = 'Y'
                        AND CMM_BOUQ_MS_CODE =
                               (SELECT LEE_MEDIA_SERVICE_CODE
                                  FROM fid_license, fid_licensee
                                 WHERE lic_number = I_BIN_LIC_NUMBER
                                       AND lic_lee_number = lee_number)) PRM_SUB_BOUQ
          WHERE     SBM_STM_ID = STM_ID
                AND CMM_BOUQ_ID = BOUQ.CB_ID
                AND PRM_SUB_BOUQ.CB_ID = BOUQ.CB_ID
                AND (CMM_BOUQ_MS_CODE, STM_REG_CODE) IN
                       (SELECT LEE_MEDIA_SERVICE_CODE, reg_code
                          FROM FID_LICENSEE, FID_LICENSE, FID_REGION
                         WHERE     LEE_NUMBER = LIC_LEE_NUMBER
                               AND REG_id = LEE_SPLIT_REGION
                               AND LIC_NUMBER = I_BIN_LIC_NUMBER)
                AND SBM_BOUQUET_ID = BOUQ.CB_ID
                AND CB_AD_FLAG = 'A'
                AND CB_BOUQ_PARENT_ID IS NOT NULL;



      SELECT LISTAGG (MSC_MS_MDC_ID, ',')
                WITHIN GROUP (ORDER BY MSC_MS_MDC_ID)
        INTO L_COMp_ID_LIST
        FROM X_CP_MEDIA_SERVICE_COMPAT
       WHERE MSC_MS_IS_COMPAT_FLAG = 'Y'
             AND MSC_MS_CODE IN ('CATCHUP', 'CATCHUP3P');

      L_SQLSTMNT_COMP_RYTS :=
         'SELECT * FROM (
                    SELECT LIC_MPDC_DEV_PLATM_ID,MSC_MS_MDC_ID,X_PKG_CP_SCH_GRID.X_GET_COMP_RIGHTS_FOR_DEV('
         || I_BIN_LIC_NUMBER
         || ',LIC_MPDC_DEV_PLATM_ID,MSC_MS_MDC_ID) RYTS
                      FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP,X_CP_MEDIA_SERVICE_COMPAT
                      WHERE LIC_MPDC_COMP_RIGHTS_ID = MSC_MS_MDC_ID
                       AND MSC_MS_IS_COMPAT_FLAG = ''Y''
                       AND MSC_MS_CODE = ''CATCHUP''
                      AND LIC_MPDC_LIC_NUMBER = '
         || I_BIN_LIC_NUMBER
         || '
                union
          select MD_ID LIC_MPDC_DEV_PLATM_ID,MSC_MS_MDC_ID,X_PKG_CP_SCH_GRID.X_GET_COMP_RIGHTS_FOR_DEV('
         || I_BIN_LIC_NUMBER
         || ',MD_ID,MSC_MS_MDC_ID) RYTS
            FROM X_CP_MEDIA_DEVICE,X_CP_MEDIA_SERVICE_COMPAT
           where MD_ID NOT IN (SELECT LIC_MPDC_DEV_PLATM_ID
                    FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP
                    WHERE LIC_MPDC_LIC_NUMBER = '
         || I_BIN_LIC_NUMBER
         || ')
                      )
                      PIVOT( MAX(RYTS) FOR MSC_MS_MDC_ID IN ('
         || L_COMp_ID_LIST
         || '))
                      ORDER BY LIC_MPDC_DEV_PLATM_ID';

      OPEN O_COMP_RIGHTS_FOR_LIC FOR L_SQLSTMNT_COMP_RYTS;
   /* ELSE                                  /*display saved data for license
       null;
    END IF;*/
   END X_PRC_LOAD_TERR_BOUQUET_DATA;

   PROCEDURE X_PRC_SAVE_TERR_BOUQUET_DATA (
      I_BIN_ID                    IN     NUMBER,
      I_BIN_LIC_NUMBER            IN     NUMBER,
      I_PLT_ID                    IN     NUMBER,
      I_TER_CODE                  IN     VARCHAR2,
      I_TER_IE_FLAG               IN     VARCHAR2,
      I_BOUQ_ID                   IN     NUMBER,
      I_BOUQ_RIGHTS_FLAG          IN     VARCHAR2,
      I_BOUQ_SUPER_STACK_RIGHTS   IN     VARCHAR2,
      I_SUB_BOUQ_ID_LIST          IN     VARCHAR2,
      I_DEV_ID                    IN     NUMBER,
      I_DEVICE_RIGHTS_FLAG        IN     VARCHAR2,
      I_DEV_COMP_ID_LIST          IN     VARCHAR2,
      I_DEV_COMP_RIGHTS_LIST      IN     VARCHAR2,
      I_PVR_START_DATE            IN     DATE,
      I_PVR_END_DATE              IN     DATE,
      I_OTT_START_DATE            IN     DATE,
      I_OTT_END_DATE              IN     DATE,
      I_SCH_NOTES                 IN     VARCHAR2,
      I_USER_MADE_CHANGES         IN     VARCHAR2,
      I_ENTRY_OPER                IN     VARCHAR2,
      I_UPDATE_COUNT              IN     NUMBER,
      O_MEDIA_DEV_DATA               OUT NUMBER)
   AS
      L_UPDATE_COUNT   NUMBER;
      L_PTBT_ID        NUMBER;
      L_TERR_PRESENT   NUMBER;
   BEGIN
      O_MEDIA_DEV_DATA := 0;

      /*
         if L_UPDATE_COUNT <> I_UPDATE_COUNT then
          RAISE_APPLICATION_ERROR(-20188,' Please Refresh the Screen');
         else
         L_UPDATE_COUNT := L_UPDATE_COUNT  +1 ;
         end if;*/
      DELETE FROM X_CP_SCH_BIN_TERRITORY
            WHERE SBT_BIN_ID = I_BIN_ID AND SBT_TER_CODE = I_TER_CODE;

      INSERT INTO X_CP_SCH_BIN_TERRITORY (SBT_BIN_ID,
                                          SBT_TER_CODE,
                                          SBT_LANG_ID,
                                          SBT_IE_FLAG)
           VALUES (I_BIN_ID,
                   I_TER_CODE,
                   1,
                   I_TER_IE_FLAG);



      IF NVL (I_TER_IE_FLAG, 'X') = 'I'                            /*INCLUDE*/
      THEN
         SELECT PTBT_UPDATE_COUNT
           INTO L_UPDATE_COUNT
           FROM X_CP_PLT_TERR_BOUQ_TEMP
          WHERE     PTBT_PLT_ID = I_PLT_ID
                AND PTBT_TER_CODE = I_TER_CODE
                AND ROWNUM < 2;

         IF L_Update_Count IS NULL
         THEN
            L_Update_Count := 0;
         END IF;

         --      select COUNT(1) into L_TERR_PRESENT
         --      from X_CP_SCH_BIN_TERRITORY
         --      where SBT_BIN_ID = I_BIN_ID
         --        and SBT_TER_CODE = I_TER_CODE;
         --
         --
         --      IF L_TERR_PRESENT > 0 THEN
         --      update X_CP_SCH_BIN_TERRITORY
         --            set   SBT_IE_FLAG = 'I'
         --            where SBT_BIN_ID = I_BIN_ID
         --             and SBT_TER_CODE = I_TER_CODE;
         --        ELSE
         --
         --        insert into X_CP_SCH_BIN_TERRITORY (SBT_BIN_ID
         --                                          ,SBT_TER_CODE
         --                                          ,SBT_LANG_ID
         --                                          ,SBT_IE_FLAG)
         --        values (I_BIN_ID,I_TER_CODE,1,'I');
         --       END IF;

         SELECT PTBT_ID
           INTO L_PTBT_ID
           FROM X_CP_PLT_TERR_BOUQ_TEMP
          WHERE     PTBT_PLT_ID = I_PLT_ID
                AND PTBT_TER_CODE = I_TER_CODE
                AND PTBT_BOUQUET_ID = I_BOUQ_ID;

         UPDATE X_CP_PLT_TERR_BOUQ_TEMP
            SET PTBT_TER_IE_FLAG = I_TER_IE_FLAG,
                PTBT_BOUQUET_RIGHTS = I_BOUQ_RIGHTS_FLAG,
                PTBT_BOUQ_SUPERS_RIGHTS = I_BOUQ_SUPER_STACK_RIGHTS,
                PTBT_PVR_START_DATE = i_pvr_start_date,
                PTBT_PVR_END_DATE = I_PVR_END_DATE,
                PTBT_OTT_START_DATE = i_ott_start_date,
                PTBT_OTT_END_DATE = I_OTT_END_DATE,
                PTBT_SCH_PVR_FROM_TIME = CONVERT_TIME_C_N(to_char(i_pvr_start_date,'hh24:mi:ss')),
                PTBT_SCH_PVR_END_TIME = CONVERT_TIME_C_N(to_char(I_PVR_END_DATE,'hh24:mi:ss')),
                PTBT_SCH_OTT_FROM_TIME = CONVERT_TIME_C_N(to_char(i_ott_start_date,'hh24:mi:ss')),
                PTBT_SCH_OTT_END_TIME = CONVERT_TIME_C_N(to_char(I_OTT_END_DATE,'hh24:mi:ss')),
                PTBT_UPDATE_COUNT = L_UPDATE_COUNT,
                PTBT_PLT_DEV_RIGHTS = I_DEVICE_RIGHTS_FLAG,
                PTBT_IS_USER_MODIFIED = I_USER_MADE_CHANGES
          WHERE PTBT_ID = L_PTBT_ID;

         --inserting sub - bouquet for terr-bouq-dev

         UPDATE X_CP_PLT_SUBBOUQ_MAPP_TEMP
            SET CPST_SUBBOUQUET_RIGHTS = 'N'
          WHERE CPST_PTB_ID = L_PTBT_ID AND CPST_PLT_ID = I_PLT_ID
                AND CPST_SUBBOUQUET_ID NOT IN
                       (SELECT COLUMN_VALUE SUBBOUQ_ID
                          FROM TABLE (
                                  X_PKG_CP_SCH_GRID.SPLIT_TO_CHAR (
                                     I_SUB_BOUQ_ID_LIST,
                                     ',')));

         DELETE FROM X_CP_PLT_SUBBOUQ_MAPP_TEMP
               WHERE CPST_PTB_ID = L_PTBT_ID
                     AND CPST_SUBBOUQUET_ID IN
                            (SELECT COLUMN_VALUE SUBBOUQ_ID
                               FROM TABLE (
                                       X_PKG_CP_SCH_GRID.SPLIT_TO_CHAR (
                                          I_SUB_BOUQ_ID_LIST,
                                          ',')));

         FOR L_SUB_BOUQ
            IN (SELECT COLUMN_VALUE SUBBOUQ_ID
                  FROM TABLE (
                          X_PKG_CP_SCH_GRID.SPLIT_TO_CHAR (
                             I_SUB_BOUQ_ID_LIST,
                             ',')))
         LOOP
            /*  DELETE FROM X_CP_PLT_SUBBOUQ_MAPP_TEMP
               WHERE CPST_PTB_ID = L_PTBT_ID
                and CPST_SUBBOUQUET_ID = L_SUB_BOUQ.SUBBOUQ_ID;*/

            INSERT INTO X_CP_PLT_SUBBOUQ_MAPP_TEMP (CPST_ID,
                                                    CPST_PLT_ID,
                                                    CPST_PTB_ID,
                                                    CPST_SUBBOUQUET_ID,
                                                    CPST_SUBBOUQUET_RIGHTS,
                                                    CPST_UPDATE_COUNT,
                                                    CPST_MODIFY_OPER,
                                                    CPST_MODIFY_DATE)
                 VALUES (X_SEQ_SUB_BOUQ_TEMP_ID.NEXTVAL,
                         I_PLT_ID,
                         L_PTBT_ID,
                         L_SUB_BOUQ.SUBBOUQ_ID,
                         'Y',
                         L_UPDATE_COUNT,
                         I_ENTRY_OPER,
                         SYSDATE);
         END LOOP;

         IF I_SCH_NOTES IS NOT NULL
         THEN
            UPDATE X_CP_PLAY_LIST_TEMP
               SET PLTT_SCH_NOTES = I_SCH_NOTES,
                   PLTT_UPDATE_COUNT = L_UPDATE_COUNT
             WHERE PLTT_BIN_ID = i_bin_id
                   AND pltt_lic_number = I_BIN_LIC_NUMBER;
         END IF;

         DELETE FROM X_CP_PLT_DEVCOMP_RIGHTS_TEMP
               WHERE CDCR_PTBT_ID = L_PTBT_ID AND CDCR_DEV_ID = I_DEV_ID;

         FOR L_COMP_RIGHTS
            IN (SELECT COMP_ID.COL2 c_id, comp_rights.COL2 c_rights
                  FROM (SELECT ROWNUM R2, COLUMN_VALUE COL2
                          FROM TABLE (
                                  X_PKG_CP_SCH_GRID.SPLIT_TO_CHAR (
                                     I_DEV_COMP_ID_LIST,
                                     ','))) COMP_ID,
                       (SELECT ROWNUM r2, COLUMN_VALUE col2
                          FROM TABLE (
                                  X_PKG_CP_SCH_GRID.split_to_char (
                                     I_DEV_COMP_RIGHTS_LIST,
                                     ','))) comp_rights
                 WHERE COMP_ID.R2 = comp_rights.R2)
         LOOP
            INSERT INTO X_CP_PLT_DEVCOMP_RIGHTS_TEMP (CDCR_ID,
                                                      CDCR_PTBT_ID,
                                                      CDCR_DEV_ID,
                                                      CDCR_COMP_ID,
                                                      CDCR_COMP_RIGHTS)
                 VALUES (X_SEQ_DEV_COMP_ID.NEXTVAL,
                         L_PTBT_ID,
                         I_DEV_ID,
                         L_COMP_RIGHTS.C_ID,
                         L_COMP_RIGHTS.c_rights);
         END LOOP;
      ELSIF NVL (I_TER_IE_FLAG, 'X') = 'E'
      THEN
         SELECT COUNT (1)
           INTO L_TERR_PRESENT
           FROM X_CP_SCH_BIN_TERRITORY
          WHERE SBT_BIN_ID = I_BIN_ID AND SBT_TER_CODE = I_TER_CODE;


         --      IF L_TERR_PRESENT > 0 THEN
         --           UPDATE X_CP_SCH_BIN_TERRITORY
         --            set   SBT_IE_FLAG = 'E'
         --            where SBT_BIN_ID = I_BIN_ID
         --             AND SBT_TER_CODE =  I_TER_CODE;
         --      ELSE
         --
         --        insert into X_CP_SCH_BIN_TERRITORY (SBT_BIN_ID
         --                                          ,SBT_TER_CODE
         --                                          ,SBT_LANG_ID
         --                                          ,SBT_IE_FLAG)
         --        values (I_BIN_ID,I_TER_CODE,1,'E');
         --      END IF;
         UPDATE X_CP_PLT_TERR_BOUQ_TEMP
            SET PTBT_TER_IE_FLAG = I_TER_IE_FLAG,
                PTBT_BOUQUET_RIGHTS = 'N',
                PTBT_BOUQ_SUPERS_RIGHTS = 'N',
                PTBT_PLT_DEV_RIGHTS = 'N',
                PTBT_OTT_END_DATE = NULL,
                PTBT_OTT_START_DATE = NULL,
                PTBT_PVR_START_DATE = NULL,
                PTBT_PVR_END_DATE = NULL,
                PTBT_SCH_PVR_FROM_TIME = null,
                PTBT_SCH_PVR_END_TIME = null,
                PTBT_SCH_OTT_FROM_TIME = null,
                PTBT_SCH_OTT_END_TIME = null
          WHERE PTBT_PLT_ID IN (SELECT PLTT_ID
                                  FROM X_CP_PLAY_LIST_TEMP
                                 WHERE PLTT_BIN_ID = I_BIN_ID)
                AND PTBT_TER_CODE = I_TER_CODE;
      END IF;

      COMMIT;
      O_MEDIA_DEV_DATA := 1;
   /*EXCEPTION
   when OTHERS then
   RAISE_APPLICATION_ERROR(-20178,SUBSTR(SQLERRM,0,200));*/

   END X_PRC_SAVE_TERR_BOUQUET_DATA;


   --CU4ALL : END
   FUNCTION X_GET_COMP_RIGHTS_FOR_DEV (I_BIN_LIC_NUMBER   IN NUMBER,
                                       I_LIC_DEV_ID       IN NUMBER,
                                       I_MDC_ID           IN NUMBER)
      RETURN VARCHAR2
   AS
      L_RIGHTS_FLAG        VARCHAR2 (1);
      L_COMP_RIGHTS_LIST   VARCHAR2 (1000);
   BEGIN
      SELECT DECODE (COUNT (1), 0, 'N', 'Y')
        INTO L_RIGHTS_FLAG
        FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP
       WHERE     LIC_IS_COMP_RIGHTS = 'Y'
             AND LIC_MPDC_LIC_NUMBER = I_BIN_LIC_NUMBER
             AND LIC_MPDC_COMP_RIGHTS_ID = I_MDC_ID
             AND LIC_MPDC_DEV_PLATM_ID = I_LIC_DEV_ID;

      RETURN L_RIGHTS_FLAG;
   END X_GET_COMP_RIGHTS_FOR_DEV;

   FUNCTION x_fun_get_CP_compat
      RETURN VARCHAR2
   AS
      v_compat   VARCHAR2 (2000);
   BEGIN
      FOR mediaDevice
         IN (  SELECT (   ''''
                       || MDC_CODE
                       || ''''
                       || ' AS '
                       || MDC_CODE
                       || '_DYN'
                       || '_'
                       || MDC_ID
                       || '_'
                       || B.MDC_DELIVERY_METHOD)
                         MDC_DESC
                 FROM X_CP_MEDIA_SERVICE_COMPAT a, X_CP_MEDIA_DEVICE_COMPAT B
                WHERE A.MSC_MS_MDC_ID = B.MDC_ID
             ORDER BY MDC_UI_SEQ                                    /*mdc_id*/
                                )
      LOOP
         v_compat :=
            CASE
               WHEN v_compat IS NULL THEN v_compat || mediaDevice.mdc_desc
               ELSE v_compat || ',' || mediaDevice.mdc_desc
            END;
      END LOOP;

      RETURN V_COMPAT;
   END x_fun_get_CP_compat;

   --CU4ALL START MILAN SHAH
   PROCEDURE X_PRC_COPY_CONFIG_SEARCH (
      I_Sch_Month            IN     DATE,
      i_is_Include_Rec_Sch   IN     VARCHAR2,
      i_Content_Type         IN     VARCHAR2,
      i_is_Only_Premier      IN     VARCHAR2,
      i_Prog_Title           IN     fid_general.gen_title%TYPE,
      i_Media_Devices        IN     NUMBER,
      i_Include_Blackout     IN     VARCHAR2,
      i_Region               IN     fid_licensee.lee_split_region%TYPE,
      i_media_service        IN     VARCHAR2,
      I_ENTRY_OPER           IN     VARCHAR2,
      I_SCH_STRT_PAST_MON    IN     VARCHAR2,
      I_PRIMARY_BOUQUET      IN     NUMBER,
      i_lee_number           IN     NUMBER,
      o_config_data             OUT X_PKG_CP_SCH_GRID.x_cur_sch_grid)
   AS
      L_LIC_QUERY              VARCHAR2 (20000) := '';
      l_schedule_query         VARCHAR2 (20000);
      l_fea_blackout_days      NUMBER;
      l_ser_blackout_days      NUMBER;
      l_content_type           VARCHAR2 (1);
      l_sch_start_date         DATE;
      l_sch_end_date           DATE;
      l_plan_year_mon          NUMBER;
      l_media_devices_list     VARCHAR2 (1000);
      L_SCHEDULE_QUERY_PIVOT   VARCHAR2 (15000);
      L_SCH_START              VARCHAR2 (1);
      L_lee_number             NUMBER;
   BEGIN
      BEGIN
         SELECT pa_black_out_period_movies, pa_black_out_period_ser
           INTO l_fea_blackout_days, l_ser_blackout_days
           FROM x_cp_planning_attributes;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_fea_blackout_days := 0;
            l_ser_blackout_days := 0;
      END;

      l_sch_start_date := TRUNC (I_Sch_Month, 'MONTH');
      l_sch_end_date := LAST_DAY (I_Sch_Month);

      l_plan_year_mon := TO_NUMBER (TO_CHAR (I_Sch_Month, 'RRRRMM'));

      IF UPPER (i_Content_Type) = 'FEA'
      THEN
         l_content_type := 'N';
      ELSIF UPPER (i_Content_Type) = 'SER'
      THEN
         l_content_type := 'Y';
      END IF;

      l_lic_query :=
         'SELECT
				bin.bin_lic_number CSG_LIC_NUMBER,
        (SELECT REG_CODE FROM FID_REGION WHERE REG_ID = bin.BIN_REG_CODE) CRS_REGION_CODE,
				fg.gen_title CSG_GEN_TITLE,
				fg.gen_type CSG_GEN_TYPE,
				fg.gen_release_year,
				(SELECT ser_sea_number FROM fid_series WHERE ser_number = fg.gen_ser_number) ser_sea_number,
        fg.GEN_EPI_NUMBER,
        bin.bin_id Bin_Id,
      bin_update_Count CSG_UPDATE_COUNT
    FROM x_cp_schedule_bin bin,
      fid_general fg,
      fid_schedule fs,
      fid_license fl,
      x_cp_catchupsch_plan_attr

    WHERE bin.bin_sch_number = fs.sch_number(+)
    AND fl.lic_gen_refno = fg.gen_refno
    AND bin.bin_lic_number = fl.lic_number
    --AND fs.sch_number = fl.lic_sch_number
    AND fg.gen_catchup_category = cspa_Catchup_category (+)
    AND NVL(bin.on_schedule_grid,''N'') = ''Y''
    AND NVL(fl.lic_catchup_flag,''N'') IN ( SELECT ms_media_service_flag
                                              FROM x_vw_usr_ser_map
                                             WHERE x_usm_user_id = '''
         || i_entry_oper
         || '''
                                               AND ms_media_service_code like '''
         || i_media_service
         || '''
                                               AND ms_media_service_parent = ''CATCHUP''
                                           )--ver 1.0 added
    AND bin.bin_reg_code LIKE DECODE('''
         || i_Region
         || ''',0,''%'','''
         || i_Region
         || ''')
    AND '
         || l_plan_year_mon
         || ' BETWEEN to_number(to_char(bin_view_start_date,''RRRRMM'')) AND to_number(to_char(bin_view_end_date,''RRRRMM''))
    AND EXISTS (SELECT 1
                FROM fid_code
                WHERE cod_type=''GEN_TYPE''
                AND cod_value <> ''HEADER''
                AND cod_value = fg.gen_type
                AND UPPER(cod_attr1) LIKE UPPER(DECODE('''
         || i_Content_Type
         || ''',''%'',''%'','''
         || l_content_type
         || ''')))
        AND UPPER(gen_title) LIKE UPPER(DECODE(:a,'''',''%'',:b))
    ';

      IF NVL (I_SCH_STRT_PAST_MON, 'N') = 'Y'
      THEN
         l_lic_query :=
            l_lic_query
            || 'AND NOT EXISTS ( SELECT 1
                                                      FROM x_cp_play_list vcpl
                                                      WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                      AND vcpl.plt_bin_id = bin.bin_id
                                                      GROUP BY vcpl.plt_bin_id
                                                      HAVING(
            ('
            || l_plan_year_mon
            || ' >  to_number(to_char(max(vcpl.plt_sch_end_date),''RRRRMM'')))
            OR
            ('
            || l_plan_year_mon
            || ' <  to_number(to_char(min(vcpl.plt_sch_start_date),''RRRRMM'')))
                                                   ))
      ';

         l_schedule_query :=
            l_schedule_query
            || 'AND NOT EXISTS ( SELECT 1
                                                      FROM x_cp_play_list vcpl
                                                      WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                      AND vcpl.plt_bin_id = bin.bin_id
                                                      GROUP BY vcpl.plt_bin_id
                                                      HAVING(
            ('
            || l_plan_year_mon
            || ' >  to_number(to_char(max(vcpl.plt_sch_end_date),''RRRRMM'')))
            OR
            ('
            || l_plan_year_mon
            || ' <  to_number(to_char(min(vcpl.plt_sch_start_date),''RRRRMM'')))
                                                   ))
      ';
      ELSE
         -- Removing Licenses Scheduled in month different than planned month.
         l_lic_query :=
            l_lic_query
            || 'AND NOT EXISTS ( SELECT 1
                                                      FROM x_cp_play_list vcpl
                                                      WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                      AND vcpl.plt_bin_id = bin.bin_id
                                                      GROUP BY vcpl.plt_bin_id
                                                      HAVING ('
            || l_plan_year_mon
            || ' <>  to_number(to_char(min(vcpl.plt_sch_start_date),''RRRRMM'')))
                                                   )
      ';

         l_schedule_query :=
            l_schedule_query
            || 'AND NOT EXISTS ( SELECT 1
                                                      FROM x_cp_play_list vcpl
                                                      WHERE vcpl.plt_lic_number = bin.bin_lic_number
                                                      AND vcpl.plt_bin_id = bin.bin_id
                                                      GROUP BY vcpl.plt_bin_id
                                                      HAVING ('
            || l_plan_year_mon
            || ' <>  to_number(to_char(min(vcpl.plt_sch_start_date),''RRRRMM'')))
                                                   )
      ';
      END IF;

      IF NVL (i_is_Include_Rec_Sch, 'N') = 'Y'
         AND NVL (i_Include_Blackout, 'N') = 'N'
      THEN
         l_lic_query :=
            l_lic_query
            || 'AND NOT EXISTS (SELECT plt_lic_number FROM x_cp_play_list vcpl, fid_license fli
                                                      WHERE vcpl.plt_lic_number = fli.lic_number
                                                      AND fli.lic_gen_refno = fg.gen_refno
                                                      AND NVL(fli.lic_catchup_flag,''N'') IN ( SELECT ms_media_service_flag
                                                                                                 FROM x_vw_usr_ser_map
                                                                                                WHERE x_usm_user_id = '''
            || i_entry_oper
            || '''
                                                                                                  AND ms_media_service_code like '''
            || i_media_service
            || '''
                                                                                                  AND ms_media_service_parent = ''CATCHUP''
                                                                                              )--ver 1.0 added
                                                      AND vcpl.plt_reg_code = bin.bin_reg_code
                                                      AND ((trim(vcpl.plt_sch_start_date) BETWEEN CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                          THEN bin.bin_view_start_date - '
            || l_fea_blackout_days
            || '
                                                                                                                     ELSE bin.bin_view_start_date - '
            || l_ser_blackout_days
            || '
                                                                                                                     END AND bin.bin_view_start_date - 1)
                                                      OR (trim(vcpl.plt_sch_end_date) BETWEEN CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                          THEN bin.bin_view_start_date - '
            || l_fea_blackout_days
            || '
                                                                                                                     ELSE bin.bin_view_start_date - '
            || l_ser_blackout_days
            || '
                                                                                                                     END AND bin.bin_view_start_date - 1)
                                                      OR (trim(vcpl.plt_sch_start_date) BETWEEN bin.bin_view_end_date + 1 AND CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                                               THEN bin.bin_view_end_date + '
            || l_fea_blackout_days
            || '
                                                                                                                                          ELSE bin.bin_view_end_date + '
            || l_ser_blackout_days
            || '
                                                                                                                                          END)
                                                      OR (trim(vcpl.plt_sch_end_date) BETWEEN bin.bin_view_end_date + 1 AND CASE WHEN x_fnc_get_prog_type(fl.lic_budget_code) = ''N''
                                                                                                                                               THEN bin.bin_view_end_date + '
            || l_fea_blackout_days
            || '
                                                                                                                                          ELSE bin.bin_view_end_date + '
            || l_ser_blackout_days
            || '
                                                                                                                                          END))
                                                   )
      ';
      END IF;

      l_lic_query := l_lic_query || 'order by CSG_GEN_TITLE,CSG_LIC_NUMBER';

      --DBMS_OUTPUT.PUT_LINE ('QUERY : ' || l_lic_query);
      OPEN o_config_data FOR l_lic_query USING i_Prog_Title, i_Prog_Title;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20111,
            'Data is not available for ' || i_media_service);
   END X_PRC_COPY_CONFIG_SEARCH;

   PROCEDURE x_cp_prc_del_log
   AS
   BEGIN
      DELETE FROM X_CP_SCH_COPY_LOG;

      COMMIT;
   END x_cp_prc_del_log;

   PROCEDURE X_CP_COPY_SCH_CONFIG (I_SRC_LIC_NUMBER    IN     NUMBER,
                                   I_SRC_BIN_ID        IN     NUMBER,
                                   I_SRC_TITLE         IN     VARCHAR2,
                                   I_DEST_LIC_NUMBER   IN     NUMBER,
                                   I_DEST_BIN_ID       IN     NUMBER,
                                   I_DEST_TITLE        IN     VARCHAR2,
                                   i_Sch_Month         IN     DATE,
                                   i_media_service     IN     VARCHAR2,
                                   i_Region            IN     VARCHAR2,
                                   I_User              IN     VARCHAR2,
                                   O_RESULT               OUT NUMBER)
   AS
      L_DEST_PLTT_ID          NUMBER;
      L_SCH_NUMBER            NUMBER;
      L_REG_CODE              NUMBER;
      L_PLTT_LICENSE_FLAG     CHAR (1);
      L_PLTT_BIN_ADDED_DATE   DATE;
      L_DEVICE_RIGHTS_FLAG    VARCHAR2 (1);
      L_TER_FLAG              VARCHAR2 (1);
      L_COUNT                 NUMBER;
      L_SS_FLAG               VARCHAR (1);
      L_ROLLBACK              NUMBER := 0;
      L_SUPERSTACK            VARCHAR2 (1000) := '';
      L_DEVICE                VARCHAR2 (1000) := '';
      L_BOUQUET               VARCHAR2 (1000) := '';
      L_TERRITORY             VARCHAR2 (1000) := '';
      L_TEMP                  VARCHAR2 (1000);
      DEST_COMP_RIGHTS        VARCHAR2 (1);
      L_COMP                  VARCHAR2 (1000);
      l_flag                  NUMBER;
      l_comp_ptbt             NUMBER;
      L_SOURCE_EXCEPTION      EXCEPTION;
      L_CDCR_ID               NUMBER;
      L_TERR_PRESENT          NUMBER;
      l_start_date            VARCHAR2 (300);
      l_end_date              VARCHAR2 (300);
      l_dev_count             NUMBER;
      l_pvr_start_date        DATE;
      l_pvr_end_date          DATE;
      l_ott_start_date        DATE;
      l_ott_end_date          DATE;
      l_del_method            VARCHAR2 (200);
   BEGIN
      O_RESULT := 1;


      SELECT BIN_SCH_NUMBER,
             BIN_LICENSE_FLAG,
             BIN_CREATED_ON,
             BIN_REG_CODE
        INTO L_SCH_NUMBER,
             L_PLTT_LICENSE_FLAG,
             L_PLTT_BIN_ADDED_DATE,
             L_REG_CODE
        FROM x_cp_schedule_bin
       WHERE bin_id = I_DEST_BIN_ID AND ROWNUM < 2;

      UPDATE X_CP_PLT_DEVCOMP_RIGHTS_TEMP
         SET CDCR_COMP_RIGHTS = 'N'
       WHERE CDCR_PTBT_ID IN
                (SELECT ptbt_id
                   FROM X_CP_PLT_TERR_BOUQ_TEMP, X_CP_PLAY_LIST_TEMP
                  WHERE PTBT_PLT_ID = PLTT_ID AND PLTT_BIN_ID = I_DEST_BIN_ID);


      --    UPDATE X_CP_PLT_SUBBOUQ_MAPP_TEMP
      --    SET CPST_SUBBOUQUET_RIGHTS ='N'
      --    WHERE CPST_PLT_ID IN (SELECT PLTT_ID FROM X_CP_PLAY_LIST_TEMP WHERE PLTT_BIN_ID = I_DEST_BIN_ID)
      --          AND CPST_PTB_ID IN (SELECT PTBT_ID FROM X_CP_PLT_TERR_BOUQ_TEMP
      --                                     WHERE PTBT_PLT_ID IN (SELECT PLTT_ID FROM X_CP_PLAY_LIST_TEMP WHERE PLTT_BIN_ID = I_DEST_BIN_ID));

      UPDATE X_CP_PLT_SUBBOUQ_MAPP_TEMP
         SET CPST_SUBBOUQUET_RIGHTS = 'N'
       WHERE CPST_PTB_ID IN
                (SELECT ptbt_id
                   FROM X_CP_PLT_TERR_BOUQ_TEMP, X_CP_PLAY_LIST_TEMP
                  WHERE PTBT_PLT_ID = PLTT_ID AND PLTT_BIN_ID = I_DEST_BIN_ID);


      UPDATE X_CP_PLT_TERR_BOUQ_TEMP
         SET PTBT_PLT_DEV_RIGHTS = 'N',
             PTBT_BOUQUET_RIGHTS = 'N',
             PTBT_BOUQ_SUPERS_RIGHTS = 'N',
             PTBT_TER_IE_FLAG = 'E'
       WHERE PTBT_PLT_ID IN (SELECT PLTT_ID
                               FROM X_CP_PLAY_LIST_TEMP
                              WHERE PLTT_BIN_ID = I_DEST_BIN_ID);

      FOR I
         IN (SELECT PLTT_ID,
                    PLTT_PLAT_CODE,
                    PLTT_DEV_ID,
                    PLTT_REG_CODE,
                    PLTT_SCH_NOTES
               FROM X_CP_PLAY_LIST_TEMP
              WHERE PLTT_LIC_NUMBER = I_SRC_LIC_NUMBER
                    AND PLTT_BIN_ID = I_SRC_BIN_ID)
      LOOP
         FOR J IN (SELECT PTBT_ID,
                          PTBT_BOUQUET_ID,
                          PTBT_TER_CODE,
                          PTBT_TER_IE_FLAG,
                          PTBT_BOUQUET_RIGHTS,
                          PTBT_BOUQ_SUPERS_RIGHTS,
                          PTBT_PLT_DEV_RIGHTS
                     FROM X_CP_PLT_TERR_BOUQ_TEMP
                    WHERE PTBT_PLT_ID = I.PLTT_ID-- AND PTBT_TER_IE_FLAG    ='I'
                                                 --AND PTBT_BOUQUET_RIGHTS = 'Y'
                                                 --AND PTBT_PLT_DEV_RIGHTS = 'Y'
                  )
         LOOP
            L_ROLLBACK := L_ROLLBACK + 1;

            BEGIN
               SELECT DISTINCT NVL (LIC_RIGHTS_ON_DEVICE, 'N')
                 INTO L_DEVICE_RIGHTS_FLAG
                 FROM x_cp_lic_medplatmdevcompat_map,
                      x_cp_media_dev_platm_map
                WHERE     MDP_MAP_ID = LIC_MPDC_DEV_PLATM_ID
                      AND LIC_MPDC_LIC_NUMBER = I_DEST_LIC_NUMBER
                      AND MDP_MAP_DEV_ID = I.PLTT_DEV_ID
                      AND MDP_MAP_PLATM_CODE = I.PLTT_PLAT_CODE;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  L_DEVICE_RIGHTS_FLAG := 'N';
            END;

            IF ( (L_DEVICE_RIGHTS_FLAG = 'Y' AND J.PTBT_PLT_DEV_RIGHTS = 'Y')
                OR J.PTBT_PLT_DEV_RIGHTS = 'N')
            THEN
               BEGIN
                  --            SELECT NVL(SBT_IE_FLAG,'I')
                  --            INTO L_TER_FLAG
                  --            FROM x_cp_sch_bin_territory
                  --            WHERE SBT_BIN_ID = I_DEST_BIN_ID
                  --            AND SBT_TER_CODE = J.PTBT_TER_CODE;

                  SELECT LIL_RGH_CODE
                    INTO L_TER_FLAG
                    FROM fid_license_ledger
                   WHERE lil_lic_number = I_DEST_LIC_NUMBER
                         AND lil_ter_code = J.PTBT_TER_CODE;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     L_TER_FLAG := 'X';
               END;

               IF ( (L_TER_FLAG IN ('N', 'E') AND J.PTBT_TER_IE_FLAG = 'I')
                   OR (J.PTBT_TER_IE_FLAG = 'E'))
               THEN
                  SELECT COUNT (1)
                    INTO L_COUNT
                    FROM x_cp_sch_bouquet_mapp
                   WHERE SBM_BIN_ID = I_DEST_BIN_ID
                         AND SBM_BOUQUET_ID = J.PTBT_BOUQUET_ID;

                  IF ( (L_COUNT > 0 AND J.PTBT_BOUQUET_RIGHTS = 'Y')
                      OR (J.PTBT_BOUQUET_RIGHTS = 'N'))
                  THEN
                     BEGIN
                        SELECT NVL (LSR_SUPERSTACK_FLAG, 'N')
                          INTO L_SS_FLAG
                          FROM x_cp_lic_superstack_rights
                         WHERE LSR_LIC_NUMBER = I_DEST_LIC_NUMBER
                               AND LSR_BOUQUET_ID = J.PTBT_BOUQUET_ID;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           L_SS_FLAG := 'N';
                     END;

                     IF (L_SS_FLAG = 'Y' AND J.PTBT_BOUQ_SUPERS_RIGHTS = 'Y')
                        OR J.PTBT_BOUQ_SUPERS_RIGHTS = 'N' --Destination have superstack rights
                     THEN
                        IF    J.PTBT_BOUQ_SUPERS_RIGHTS = 'Y'
                           OR J.PTBT_BOUQUET_RIGHTS = 'Y'
                           OR J.PTBT_TER_IE_FLAG = 'I'
                           OR J.PTBT_PLT_DEV_RIGHTS = 'Y'
                        THEN
                           UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                              SET PTBT_PLT_DEV_RIGHTS = J.PTBT_PLT_DEV_RIGHTS,
                                  PTBT_BOUQUET_RIGHTS = J.PTBT_BOUQUET_RIGHTS,
                                  PTBT_BOUQ_SUPERS_RIGHTS =
                                     J.PTBT_BOUQ_SUPERS_RIGHTS,
                                  PTBT_TER_IE_FLAG = J.PTBT_TER_IE_FLAG
                            WHERE PTBT_PLT_ID =
                                     (SELECT PLTT_ID
                                        FROM X_CP_PLAY_LIST_TEMP
                                       WHERE PLTT_BIN_ID = I_DEST_BIN_ID
                                             AND pltt_lic_number =
                                                    I_DEST_LIC_NUMBER
                                             AND pltt_dev_id = I.PLTT_DEV_ID)
                                  AND PTBT_BOUQUET_ID = J.PTBT_BOUQUET_ID
                                  AND PTBT_TER_CODE = J.PTBT_TER_CODE;
                        END IF;

                        /*select X_PKG_CP_SCH_GRID.x_fnc_calc_start_date
                        (
                            lic_number,
                            bin_id,
                            I.PLTT_DEV_ID,
                            i_Sch_Month,
                            (x_fnc_title_is_premier(lic_gen_refno,cha_region_id,sch_date,sch_time)),
                            lic_max_viewing_period,
                            lic_sch_without_lin_ref,
                            lic_budget_code,
                            lic_gen_refno,
                            lic_sch_bef_x_day,
                            lic_sch_bef_x_day_value,
                            lic_start,
                            lic_end,
                            sch_fin_actual_date,
                            sch_time,
                            sch_end_time,
                            cha_region_id,
                            lic_period_tba,
                            bin_view_start_date
                         ) into l_start_date
                        from
                               fid_license
                              ,x_cp_schedule_bin
                              ,fid_Schedule
                              ,fid_channel
                              ,fid_general
                         where lic_number = I_DEST_LIC_NUMBER
                               and bin_lic_number = lic_number
                               and bin_id =I_DEST_BIN_ID
                               and bin_sch_number = sch_number
                               and cha_number = sch_cha_number
                               and gen_refno = lic_gen_refno;

                      select  X_PKG_CP_SCH_GRID.x_fnc_calc_end_date
                      (
                         lic_number,
                          bin_id,
                          I.PLTT_DEV_ID,
                          i_Sch_Month,
                           (x_fnc_title_is_premier(lic_gen_refno,cha_region_id,sch_date,sch_time)),
                          lic_max_viewing_period,
                          lic_sch_without_lin_ref,
                          lic_budget_code,
                          lic_gen_refno,
                          lic_sch_bef_x_day,
                          lic_sch_bef_x_day_value,
                          lic_start,
                          lic_end,
                          (fun_convert_duration_c_n (gen_duration_c)),
                          sch_fin_actual_date,
                          sch_time,
                          sch_end_time,
                          cha_region_id,
                          lic_period_tba,
                          bin_view_start_date,
                          bin_view_end_date,
                          l_start_date
                       ) into l_end_date

                     from
                           fid_license
                          ,x_cp_schedule_bin
                          ,fid_Schedule
                          ,fid_channel
                          ,fid_general
                     where lic_number = I_DEST_LIC_NUMBER
                           and bin_lic_number = lic_number
                           and bin_id =I_DEST_BIN_ID
                           and bin_sch_number = sch_number
                           and cha_number = sch_cha_number
                           and gen_refno = lic_gen_refno;



                   SELECT count(distinct MDC_DELIVERY_METHOD) into l_dev_count
                   FROM
                         X_CP_MEDIA_DEVICE_COMPAT
                        ,X_CP_MED_PLATM_DEV_COMPAT_MAP
                  WHERE  MDC_ID = MPDC_COMP_RIGHTS_ID
                         and MPDC_IS_COMP_RIGHTS = 'Y'
                         AND MPDC_DEV_PLATM_ID =  I.PLTT_DEV_ID;
                  IF(l_dev_count<2)
                  THEN
                   SELECT distinct MDC_DELIVERY_METHOD into l_del_method
                   FROM
                         X_CP_MEDIA_DEVICE_COMPAT
                        ,X_CP_MED_PLATM_DEV_COMPAT_MAP
                  WHERE  MDC_ID = MPDC_COMP_RIGHTS_ID
                         and MPDC_IS_COMP_RIGHTS = 'Y'
                         AND MPDC_DEV_PLATM_ID = I.PLTT_DEV_ID;

                   END IF;
                  IF l_dev_count > 1
                 THEN
                 x_prc_cal_both_compat_dates(i_dest_lic_number,i_dest_bin_id,i_Sch_Month,I.pltt_dev_id,l_pvr_start_date,l_pvr_end_date,l_ott_start_date,l_ott_end_date);
                 UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                    SET
                       PTBT_PLT_DEV_RIGHTS =J.PTBT_PLT_DEV_RIGHTS,
                       PTBT_BOUQUET_RIGHTS =J.PTBT_BOUQUET_RIGHTS,
                       PTBT_PVR_START_DATE = l_pvr_start_date,
                       ptbt_PVR_end_date = l_pvr_end_date,
                       PTBT_OTT_START_DATE = l_ott_start_date,
                       ptbt_ott_end_date = l_ott_end_date,
                       PTBT_BOUQ_SUPERS_RIGHTS =J.PTBT_BOUQ_SUPERS_RIGHTS,
                       PTBT_TER_IE_FLAG=J.PTBT_TER_IE_FLAG
                    where PTBT_PLT_ID = (SELECT PLTT_ID FROM X_CP_PLAY_LIST_TEMP WHERE PLTT_BIN_ID = I_DEST_BIN_ID AND pltt_lic_number = I_DEST_LIC_NUMBER and pltt_dev_id = I.PLTT_DEV_ID)
                          and PTBT_BOUQUET_ID = J.PTBT_BOUQUET_ID
                          and PTBT_TER_CODE = J.PTBT_TER_CODE;
                 END IF ;
                  IF  l_dev_count =1 and l_del_method = 'PUSH'
                  THEN
                   UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                    SET
                       PTBT_PLT_DEV_RIGHTS =J.PTBT_PLT_DEV_RIGHTS,
                       PTBT_BOUQUET_RIGHTS =J.PTBT_BOUQUET_RIGHTS,
                       PTBT_PVR_START_DATE = to_date(l_start_date,'DD-MM-YYYY HH24:MI:SS'),
                       ptbt_PVR_end_date = to_date(l_end_date,'DD-MM-YYYY HH24:MI:SS'),
                       PTBT_BOUQ_SUPERS_RIGHTS =J.PTBT_BOUQ_SUPERS_RIGHTS,
                       PTBT_TER_IE_FLAG=J.PTBT_TER_IE_FLAG
                    where PTBT_PLT_ID = (SELECT PLTT_ID FROM X_CP_PLAY_LIST_TEMP WHERE PLTT_BIN_ID = I_DEST_BIN_ID AND pltt_lic_number = I_DEST_LIC_NUMBER and pltt_dev_id = I.PLTT_DEV_ID)
                          and PTBT_BOUQUET_ID = J.PTBT_BOUQUET_ID
                          and PTBT_TER_CODE = J.PTBT_TER_CODE;

                  ELSIF l_dev_count =1 and l_del_method = 'PULL' THEN
                       UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                    SET
                       PTBT_PLT_DEV_RIGHTS =J.PTBT_PLT_DEV_RIGHTS,
                       PTBT_BOUQUET_RIGHTS =J.PTBT_BOUQUET_RIGHTS,
                       PTBT_OTT_START_DATE = to_date(l_start_date,'DD-MM-YYYY HH24:MI:SS'),
                       ptbt_ott_end_date = to_date(l_end_date,'DD-MM-YYYY HH24:MI:SS'),
                       PTBT_BOUQ_SUPERS_RIGHTS =J.PTBT_BOUQ_SUPERS_RIGHTS,
                       PTBT_TER_IE_FLAG=J.PTBT_TER_IE_FLAG
                    where PTBT_PLT_ID = (SELECT PLTT_ID FROM X_CP_PLAY_LIST_TEMP WHERE PLTT_BIN_ID = I_DEST_BIN_ID AND pltt_lic_number = I_DEST_LIC_NUMBER and pltt_dev_id = I.PLTT_DEV_ID)
                          and PTBT_BOUQUET_ID = J.PTBT_BOUQUET_ID
                          and PTBT_TER_CODE = J.PTBT_TER_CODE;
                  END IF;


                     END IF;*/

                        SELECT COUNT (1)
                          INTO L_TERR_PRESENT
                          FROM X_CP_SCH_BIN_TERRITORY
                         WHERE SBT_BIN_ID = I_DEST_BIN_ID
                               AND SBT_TER_CODE = J.PTBT_TER_CODE;


                        IF L_TERR_PRESENT > 0
                        THEN
                           UPDATE X_CP_SCH_BIN_TERRITORY
                              SET SBT_IE_FLAG = J.PTBT_TER_IE_FLAG
                            WHERE SBT_BIN_ID = I_DEST_BIN_ID
                                  AND SBT_TER_CODE = J.PTBT_TER_CODE;
                        ELSE
                           INSERT INTO X_CP_SCH_BIN_TERRITORY (SBT_BIN_ID,
                                                               SBT_TER_CODE,
                                                               SBT_LANG_ID,
                                                               SBT_IE_FLAG)
                                VALUES (I_DEST_BIN_ID,
                                        J.PTBT_TER_CODE,
                                        1,
                                        J.PTBT_TER_IE_FLAG);
                        END IF;

                        FOR K
                           IN ( (SELECT CPST_SUBBOUQUET_ID,
                                        CPST_SUBBOUQUET_RIGHTS
                                   FROM X_CP_PLT_SUBBOUQ_MAPP_TEMP
                                  WHERE CPST_PTB_ID = J.PTBT_ID))
                        LOOP
                           --                    UPDATE X_CP_PLT_SUBBOUQ_MAPP_TEMP
                           --                    SET
                           --                        CPST_SUBBOUQUET_RIGHTS = K.CPST_SUBBOUQUET_RIGHTS,
                           --                        CPST_MODIFY_OPER = I_USER,
                           --                        CPST_MODIFY_DATE = SYSDATE
                           --                    where CPST_SUBBOUQUET_ID = K.CPST_SUBBOUQUET_ID
                           --                          AND CPST_PTB_ID = (SELECT PTBT_ID FROM X_CP_PLT_TERR_BOUQ_TEMP
                           --                                                            where PTBT_PLT_ID IN (SELECT PLTT_ID FROM X_CP_PLAY_LIST_TEMP
                           --                                                                                                WHERE PLTT_BIN_ID = I_DEST_BIN_ID
                           --                                                                                                AND pltt_lic_number = I_DEST_LIC_NUMBER
                           --                                                                                                and pltt_dev_id = I.PLTT_DEV_ID)
                           --                                                                    and PTBT_BOUQUET_ID = J.PTBT_BOUQUET_ID
                           --                                                                    and PTBT_TER_CODE = J.PTBT_TER_CODE);
                           IF K.CPST_SUBBOUQUET_RIGHTS = 'Y'
                           THEN
                              UPDATE X_CP_PLT_SUBBOUQ_MAPP_TEMP
                                 SET CPST_SUBBOUQUET_RIGHTS =
                                        K.CPST_SUBBOUQUET_RIGHTS,
                                     CPST_MODIFY_OPER = I_USER,
                                     CPST_MODIFY_DATE = SYSDATE
                               WHERE CPST_SUBBOUQUET_ID =
                                        K.CPST_SUBBOUQUET_ID
                                     AND CPST_PTB_ID =
                                            (SELECT ptbt_id
                                               FROM X_CP_PLT_TERR_BOUQ_TEMP,
                                                    X_CP_PLAY_LIST_TEMP
                                              WHERE PTBT_PLT_ID = PLTT_ID
                                                    AND PLTT_BIN_ID =
                                                           I_DEST_BIN_ID
                                                    AND pltt_lic_number =
                                                           I_DEST_LIC_NUMBER
                                                    AND pltt_dev_id =
                                                           I.PLTT_DEV_ID
                                                    AND PTBT_BOUQUET_ID =
                                                           J.PTBT_BOUQUET_ID
                                                    AND PTBT_TER_CODE =
                                                           J.PTBT_TER_CODE);
                           END IF;
                        END LOOP;

                        IF J.PTBT_PLT_DEV_RIGHTS = 'Y'
                        THEN
                           FOR SRC_COMP
                              IN ( (SELECT CDCR_DEV_ID,
                                           CDCR_COMP_ID,
                                           CDCR_COMP_RIGHTS
                                      FROM X_CP_PLT_DEVCOMP_RIGHTS_TEMP
                                     WHERE CDCR_PTBT_ID = J.PTBT_ID))
                           LOOP
                              BEGIN
                                 SELECT LIC_IS_COMP_RIGHTS
                                   INTO DEST_COMP_RIGHTS
                                   FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP
                                  WHERE LIC_MPDC_LIC_NUMBER =
                                           I_DEST_LIC_NUMBER
                                        AND LIC_MPDC_DEV_PLATM_ID =
                                               SRC_COMP.CDCR_DEV_ID
                                        AND LIC_MPDC_COMP_RIGHTS_ID =
                                               SRC_COMP.CDCR_COMP_ID;
                              EXCEPTION
                                 WHEN NO_DATA_FOUND
                                 THEN
                                    DEST_COMP_RIGHTS := 'N';
                              END;

                              IF ( (DEST_COMP_RIGHTS = 'Y'
                                    AND SRC_COMP.CDCR_COMP_RIGHTS = 'Y')
                                  OR (SRC_COMP.CDCR_COMP_RIGHTS = 'N'))
                              THEN
                                 IF SRC_COMP.CDCR_COMP_RIGHTS = 'Y'
                                 THEN
                                    IF J.PTBT_PLT_DEV_RIGHTS = 'Y'
                                       AND J.PTBT_BOUQUET_RIGHTS = 'Y'
                                    THEN
                                       SELECT X_PKG_CP_SCH_GRID.x_fnc_calc_start_date (
                                                 lic_number,
                                                 bin_id,
                                                 I.PLTT_DEV_ID,
                                                 i_Sch_Month,
                                                 (x_fnc_title_is_premier (
                                                     lic_gen_refno,
                                                     (SELECT cha_region_id
                                                        FROM fid_channel
                                                       WHERE cha_number =
                                                                sch_cha_number),
                                                     sch_date,
                                                     sch_time)),
                                                 lic_max_viewing_period,
                                                 lic_sch_without_lin_ref,
                                                 lic_budget_code,
                                                 lic_gen_refno,
                                                 lic_sch_bef_x_day,
                                                 lic_sch_bef_x_day_value,
                                                 lic_start,
                                                 lic_end,
                                                 sch_fin_actual_date,
                                                 sch_time,
                                                 sch_end_time,
                                                 (SELECT cha_region_id
                                                    FROM fid_channel
                                                   WHERE cha_number =
                                                            sch_cha_number),
                                                 lic_period_tba,
                                                 bin_view_start_date)
                                         INTO l_start_date
                                         FROM fid_license,
                                              x_cp_schedule_bin,
                                              fid_Schedule--,fid_channel
                                              ,
                                              fid_general
                                        WHERE lic_number = I_DEST_LIC_NUMBER
                                              AND bin_lic_number = lic_number
                                              AND bin_id = I_DEST_BIN_ID
                                              AND bin_sch_number =
                                                     sch_number(+)
                                              --and cha_number = sch_cha_number
                                              AND gen_refno = lic_gen_refno;

                                       SELECT X_PKG_CP_SCH_GRID.x_fnc_calc_end_date (
                                                 lic_number,
                                                 bin_id,
                                                 I.PLTT_DEV_ID,
                                                 i_Sch_Month,
                                                 (x_fnc_title_is_premier (
                                                     lic_gen_refno,
                                                     (SELECT cha_region_id
                                                        FROM fid_channel
                                                       WHERE cha_number =
                                                                sch_cha_number),
                                                     sch_date,
                                                     sch_time)),
                                                 lic_max_viewing_period,
                                                 lic_sch_without_lin_ref,
                                                 lic_budget_code,
                                                 lic_gen_refno,
                                                 lic_sch_bef_x_day,
                                                 lic_sch_bef_x_day_value,
                                                 lic_start,
                                                 lic_end,
                                                 (fun_convert_duration_c_n (
                                                     gen_duration_c)),
                                                 sch_fin_actual_date,
                                                 sch_time,
                                                 sch_end_time,
                                                 (SELECT cha_region_id
                                                    FROM fid_channel
                                                   WHERE cha_number =
                                                            sch_cha_number),
                                                 lic_period_tba,
                                                 bin_view_start_date,
                                                 bin_view_end_date,
                                                 l_start_date)
                                         INTO l_end_date
                                         FROM fid_license,
                                              x_cp_schedule_bin,
                                              fid_Schedule-- ,fid_channel
                                              ,
                                              fid_general
                                        WHERE lic_number = I_DEST_LIC_NUMBER
                                              AND bin_lic_number = lic_number
                                              AND bin_id = I_DEST_BIN_ID
                                              AND bin_sch_number =
                                                     sch_number(+)
                                              --and cha_number = sch_cha_number
                                              AND gen_refno = lic_gen_refno;



                                       SELECT COUNT (
                                                 DISTINCT MDC_DELIVERY_METHOD)
                                         INTO l_dev_count
                                         FROM X_CP_MEDIA_DEVICE_COMPAT,
                                              X_CP_MED_PLATM_DEV_COMPAT_MAP
                                        WHERE MDC_ID = MPDC_COMP_RIGHTS_ID
                                              AND MPDC_IS_COMP_RIGHTS = 'Y'
                                              AND MPDC_DEV_PLATM_ID =
                                                     I.PLTT_DEV_ID;

                                       IF (l_dev_count < 2)
                                       THEN
                                          SELECT DISTINCT MDC_DELIVERY_METHOD
                                            INTO l_del_method
                                            FROM X_CP_MEDIA_DEVICE_COMPAT,
                                                 X_CP_MED_PLATM_DEV_COMPAT_MAP
                                           WHERE MDC_ID = MPDC_COMP_RIGHTS_ID
                                                 AND MPDC_IS_COMP_RIGHTS =
                                                        'Y'
                                                 AND MPDC_DEV_PLATM_ID =
                                                        I.PLTT_DEV_ID;
                                       END IF;

                                       IF l_dev_count > 1
                                       THEN
                                          x_prc_cal_both_compat_dates (
                                             i_dest_lic_number,
                                             i_dest_bin_id,
                                             i_Sch_Month,
                                             I.pltt_dev_id,
                                             l_pvr_start_date,
                                             l_pvr_end_date,
                                             l_ott_start_date,
                                             l_ott_end_date);

                                          UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                                             SET PTBT_PLT_DEV_RIGHTS =
                                                    J.PTBT_PLT_DEV_RIGHTS,
                                                 PTBT_BOUQUET_RIGHTS =
                                                    J.PTBT_BOUQUET_RIGHTS,
                                                 PTBT_PVR_START_DATE =
                                                    l_pvr_start_date,
                                                 ptbt_PVR_end_date =
                                                    l_pvr_end_date,
                                                 PTBT_OTT_START_DATE =
                                                    l_ott_start_date,
                                                 ptbt_ott_end_date =
                                                    l_ott_end_date,
                                                PTBT_SCH_PVR_FROM_TIME = CONVERT_TIME_C_N(to_char(l_pvr_start_date,'hh24:mi:ss')),
                                                PTBT_SCH_PVR_END_TIME = CONVERT_TIME_C_N(to_char(l_pvr_end_date,'hh24:mi:ss')),
                                                PTBT_SCH_OTT_FROM_TIME = CONVERT_TIME_C_N(to_char(l_ott_start_date,'hh24:mi:ss')),
                                                PTBT_SCH_OTT_END_TIME = CONVERT_TIME_C_N(to_char(l_ott_end_date,'hh24:mi:ss')),
                                                 PTBT_BOUQ_SUPERS_RIGHTS =
                                                    J.PTBT_BOUQ_SUPERS_RIGHTS,
                                                 PTBT_TER_IE_FLAG =
                                                    J.PTBT_TER_IE_FLAG
                                           WHERE PTBT_PLT_ID =
                                                    (SELECT PLTT_ID
                                                       FROM X_CP_PLAY_LIST_TEMP
                                                      WHERE PLTT_BIN_ID =
                                                               I_DEST_BIN_ID
                                                            AND pltt_lic_number =
                                                                   I_DEST_LIC_NUMBER
                                                            AND pltt_dev_id =
                                                                   I.PLTT_DEV_ID)
                                                 AND PTBT_BOUQUET_ID =
                                                        J.PTBT_BOUQUET_ID
                                                 AND PTBT_TER_CODE =
                                                        J.PTBT_TER_CODE;
                                       END IF;

                                       IF l_dev_count = 1
                                          AND l_del_method = 'PUSH'
                                       THEN
                                          UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                                             SET PTBT_PLT_DEV_RIGHTS =
                                                    J.PTBT_PLT_DEV_RIGHTS,
                                                 PTBT_BOUQUET_RIGHTS =
                                                    J.PTBT_BOUQUET_RIGHTS,
                                                 PTBT_PVR_START_DATE =
                                                    TO_DATE (
                                                       l_start_date,
                                                       'DD-MM-YYYY HH24:MI:SS'),
                                                 ptbt_PVR_end_date =
                                                    TO_DATE (
                                                       l_end_date,
                                                       'DD-MM-YYYY HH24:MI:SS'),
                                                PTBT_SCH_PVR_FROM_TIME = CONVERT_TIME_C_N(to_char(TO_DATE (l_start_date,'DD-MM-YYYY HH24:MI:SS'),'hh24:mi:ss')),
                                                PTBT_SCH_PVR_END_TIME = CONVERT_TIME_C_N(to_char(TO_DATE (l_end_date,'DD-MM-YYYY HH24:MI:SS'),'hh24:mi:ss')),
                                                 PTBT_BOUQ_SUPERS_RIGHTS =
                                                    J.PTBT_BOUQ_SUPERS_RIGHTS,
                                                 PTBT_TER_IE_FLAG =
                                                    J.PTBT_TER_IE_FLAG
                                           WHERE PTBT_PLT_ID =
                                                    (SELECT PLTT_ID
                                                       FROM X_CP_PLAY_LIST_TEMP
                                                      WHERE PLTT_BIN_ID =
                                                               I_DEST_BIN_ID
                                                            AND pltt_lic_number =
                                                                   I_DEST_LIC_NUMBER
                                                            AND pltt_dev_id =
                                                                   I.PLTT_DEV_ID)
                                                 AND PTBT_BOUQUET_ID =
                                                        J.PTBT_BOUQUET_ID
                                                 AND PTBT_TER_CODE =
                                                        J.PTBT_TER_CODE;
                                       ELSIF l_dev_count = 1
                                             AND l_del_method = 'PULL'
                                       THEN
                                          UPDATE X_CP_PLT_TERR_BOUQ_TEMP
                                             SET PTBT_PLT_DEV_RIGHTS =
                                                    J.PTBT_PLT_DEV_RIGHTS,
                                                 PTBT_BOUQUET_RIGHTS =
                                                    J.PTBT_BOUQUET_RIGHTS,
                                                 PTBT_OTT_START_DATE =
                                                    TO_DATE (
                                                       l_start_date,
                                                       'DD-MM-YYYY HH24:MI:SS'),
                                                 ptbt_ott_end_date =
                                                    TO_DATE (
                                                       l_end_date,
                                                       'DD-MM-YYYY HH24:MI:SS'),
                                                PTBT_SCH_OTT_FROM_TIME = CONVERT_TIME_C_N(to_char(TO_DATE (l_start_date,'DD-MM-YYYY HH24:MI:SS'),'hh24:mi:ss')),
                                                PTBT_SCH_OTT_END_TIME = CONVERT_TIME_C_N(to_char(TO_DATE (l_end_date,'DD-MM-YYYY HH24:MI:SS'),'hh24:mi:ss')),
                                                 PTBT_BOUQ_SUPERS_RIGHTS =
                                                    J.PTBT_BOUQ_SUPERS_RIGHTS,
                                                 PTBT_TER_IE_FLAG =
                                                    J.PTBT_TER_IE_FLAG
                                           WHERE PTBT_PLT_ID =
                                                    (SELECT PLTT_ID
                                                       FROM X_CP_PLAY_LIST_TEMP
                                                      WHERE PLTT_BIN_ID =
                                                               I_DEST_BIN_ID
                                                            AND pltt_lic_number =
                                                                   I_DEST_LIC_NUMBER
                                                            AND pltt_dev_id =
                                                                   I.PLTT_DEV_ID)
                                                 AND PTBT_BOUQUET_ID =
                                                        J.PTBT_BOUQUET_ID
                                                 AND PTBT_TER_CODE =
                                                        J.PTBT_TER_CODE;
                                       END IF;
                                    END IF;

                                    UPDATE X_CP_PLT_DEVCOMP_RIGHTS_TEMP
                                       SET CDCR_COMP_RIGHTS =
                                              SRC_COMP.CDCR_COMP_RIGHTS
                                     WHERE CDCR_PTBT_ID =
                                              (SELECT ptbt_id
                                                 FROM X_CP_PLT_TERR_BOUQ_TEMP,
                                                      X_CP_PLAY_LIST_TEMP
                                                WHERE PTBT_PLT_ID = PLTT_ID
                                                      AND PLTT_BIN_ID =
                                                             I_DEST_BIN_ID
                                                      AND pltt_lic_number =
                                                             I_DEST_LIC_NUMBER
                                                      AND pltt_dev_id =
                                                             I.PLTT_DEV_ID
                                                      AND PTBT_BOUQUET_ID =
                                                             J.PTBT_BOUQUET_ID
                                                      AND PTBT_TER_CODE =
                                                             J.PTBT_TER_CODE)
                                           AND CDCR_DEV_ID =
                                                  SRC_COMP.CDCR_DEV_ID
                                           AND CDCR_COMP_ID =
                                                  SRC_COMP.CDCR_COMP_ID;
                                 END IF;
                              ELSE
                                 SELECT MDC_CODE
                                   INTO L_TEMP
                                   FROM X_CP_MEDIA_DEVICE_COMPAT
                                  WHERE MDC_ID = SRC_COMP.CDCR_COMP_ID;

                                 BEGIN
                                    SELECT 1
                                      INTO l_flag
                                      FROM DUAL
                                     WHERE L_TEMP IN
                                              (SELECT DISTINCT
                                                      COLUMN_VALUE COL1
                                                 FROM TABLE (
                                                         X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (
                                                            L_COMP,
                                                            ',')));
                                 EXCEPTION
                                    WHEN NO_DATA_FOUND
                                    THEN
                                       L_COMP := L_COMP || L_TEMP || ',';
                                 END;
                              END IF;
                           END LOOP;
                        END IF;
                     ELSE        --Destination does not have superstack rights
                        SELECT CB_NAME
                          INTO L_TEMP
                          FROM x_cp_bouquet
                         WHERE cb_id = J.PTBT_BOUQUET_ID;

                        BEGIN
                           SELECT 1
                             INTO l_flag
                             FROM DUAL
                            WHERE L_TEMP IN
                                     (SELECT DISTINCT COLUMN_VALUE COL1
                                        FROM TABLE (
                                                X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (
                                                   L_SUPERSTACK,
                                                   ',')));
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              L_SUPERSTACK := L_SUPERSTACK || L_TEMP || ',';
                        END;
                     --raise_application_error(-20111,'Super Stacking rights mismatch for source and destination title');
                     END IF;
                  ELSE              --Destination does not have bouquet rights
                     SELECT Cb_Name
                       INTO L_Temp
                       FROM X_Cp_Bouquet
                      WHERE Cb_Id = J.Ptbt_Bouquet_Id;

                     BEGIN
                        SELECT 1
                          INTO l_flag
                          FROM DUAL
                         WHERE L_TEMP IN
                                  (SELECT DISTINCT COLUMN_VALUE COL1
                                     FROM TABLE (
                                             X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (
                                                L_BOUQUET,
                                                ',')));
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           L_BOUQUET := L_BOUQUET || L_TEMP || ',';
                     END;
                  --raise_application_error(-20111,'Allowed bouquets of source are not applicable for one of the destination title');
                  END IF;
               ELSE               --Destination does not have territory rights
                  BEGIN
                     SELECT 1
                       INTO l_flag
                       FROM DUAL
                      WHERE L_TEMP IN
                               (SELECT DISTINCT COLUMN_VALUE COL1
                                  FROM TABLE (
                                          X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (
                                             L_TERRITORY,
                                             ',')));
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        L_TERRITORY := L_TERRITORY || J.PTBT_TER_CODE || ',';
                  END;
               --raise_application_error(-20111,'Territories not present');
               END IF;
            ELSE                     --Destination does not have device rights
               SELECT MD_CODE
                 INTO L_TEMP
                 FROM x_cp_media_device
                WHERE md_id = I.PLTT_DEV_ID;

               BEGIN
                  SELECT 1
                    INTO l_flag
                    FROM DUAL
                   WHERE L_TEMP IN
                            (SELECT DISTINCT COLUMN_VALUE COL1
                               FROM TABLE (
                                       X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (
                                          L_DEVICE,
                                          ',')));
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     L_DEVICE := L_DEVICE || L_TEMP || ',';
               END;
            --raise_application_error(-20111,'Devices not selected on destination title but on source');
            END IF;
         --END IF;
         END LOOP;
      END LOOP;

      IF L_SUPERSTACK IS NOT NULL
      THEN
         SELECT LISTAGG (COL1, ',') WITHIN GROUP (ORDER BY 1)
           INTO L_SUPERSTACK
           FROM (SELECT DISTINCT COLUMN_VALUE COL1
                   FROM TABLE (
                           X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (
                              L_SUPERSTACK,
                              ',')));

         L_SUPERSTACK :=
               'Super Stacking rights mismatch for '
            || L_SUPERSTACK
            || ' bouquets for source and destination title';
         X_PKG_CP_SCH_GRID.X_CP_INSERT_VALIDATION (I_SRC_LIC_NUMBER,
                                                   I_SRC_TITLE,
                                                   I_DEST_LIC_NUMBER,
                                                   I_DEST_TITLE,
                                                   L_REG_CODE,
                                                   i_Sch_Month,
                                                   'FAILED',
                                                   L_SUPERSTACK,
                                                   I_User);
      END IF;

      IF L_BOUQUET IS NOT NULL
      THEN
         SELECT LISTAGG (COL1, ',') WITHIN GROUP (ORDER BY 1)
           INTO L_BOUQUET
           FROM (SELECT DISTINCT COLUMN_VALUE COL1
                   FROM TABLE (
                           X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (L_BOUQUET,
                                                                 ',')));

         L_BOUQUET :=
               'Allowed '
            || L_BOUQUET
            || ' bouquets of source are not applicable destination title';
         X_PKG_CP_SCH_GRID.X_CP_INSERT_VALIDATION (I_SRC_LIC_NUMBER,
                                                   I_SRC_TITLE,
                                                   I_DEST_LIC_NUMBER,
                                                   I_DEST_TITLE,
                                                   L_REG_CODE,
                                                   i_Sch_Month,
                                                   'FAILED',
                                                   L_BOUQUET,
                                                   I_User);
      END IF;

      IF L_TERRITORY IS NOT NULL
      THEN
         SELECT LISTAGG (COL1, ',') WITHIN GROUP (ORDER BY 1)
           INTO L_TERRITORY
           FROM (SELECT DISTINCT COLUMN_VALUE COL1
                   FROM TABLE (
                           X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (L_TERRITORY,
                                                                 ',')));

         L_TERRITORY :=
            'Territories ' || L_TERRITORY || ' not present for destination';
         X_PKG_CP_SCH_GRID.X_CP_INSERT_VALIDATION (I_SRC_LIC_NUMBER,
                                                   I_SRC_TITLE,
                                                   I_DEST_LIC_NUMBER,
                                                   I_DEST_TITLE,
                                                   L_REG_CODE,
                                                   i_Sch_Month,
                                                   'FAILED',
                                                   L_TERRITORY,
                                                   I_User);
      END IF;

      IF L_DEVICE IS NOT NULL
      THEN
         SELECT LISTAGG (COL1, ',') WITHIN GROUP (ORDER BY 1)
           INTO L_DEVICE
           FROM (SELECT DISTINCT COLUMN_VALUE COL1
                   FROM TABLE (
                           X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (L_DEVICE,
                                                                 ',')));

         L_DEVICE :=
            'Devices ' || L_DEVICE || ' not selected on destination title.';
         X_PKG_CP_SCH_GRID.X_CP_INSERT_VALIDATION (I_SRC_LIC_NUMBER,
                                                   I_SRC_TITLE,
                                                   I_DEST_LIC_NUMBER,
                                                   I_DEST_TITLE,
                                                   L_REG_CODE,
                                                   i_Sch_Month,
                                                   'FAILED',
                                                   L_DEVICE,
                                                   I_User);
      END IF;

      IF L_COMP IS NOT NULL
      THEN
         SELECT LISTAGG (COL1, ',') WITHIN GROUP (ORDER BY 1)
           INTO L_COMP
           FROM (SELECT DISTINCT COLUMN_VALUE COL1
                   FROM TABLE (
                           X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (L_COMP, ',')));

         -- DBMS_OUTPUT.PUT_LINE ('QUERY : ' || L_COMP);

         L_COMP :=
               'Compatibility rights mismatch for '
            || L_COMP
            || ' for source and destination title';
         X_PKG_CP_SCH_GRID.X_CP_INSERT_VALIDATION (I_SRC_LIC_NUMBER,
                                                   I_SRC_TITLE,
                                                   I_DEST_LIC_NUMBER,
                                                   I_DEST_TITLE,
                                                   L_REG_CODE,
                                                   i_Sch_Month,
                                                   'FAILED',
                                                   L_COMP,
                                                   I_User);
      END IF;


      IF     L_DEVICE IS NULL
         AND L_TERRITORY IS NULL
         AND L_BOUQUET IS NULL
         AND L_SUPERSTACK IS NULL
         AND L_ROLLBACK > 0
         AND L_COMP IS NULL
      THEN
         X_PKG_CP_SCH_GRID.X_CP_INSERT_VALIDATION (I_SRC_LIC_NUMBER,
                                                   I_SRC_TITLE,
                                                   I_DEST_LIC_NUMBER,
                                                   I_DEST_TITLE,
                                                   L_REG_CODE,
                                                   i_Sch_Month,
                                                   'COPIED',
                                                   'NA',
                                                   I_User);
         O_RESULT := I_DEST_LIC_NUMBER;
      END IF;

      IF    L_DEVICE IS NOT NULL
         OR L_TERRITORY IS NOT NULL
         OR L_BOUQUET IS NOT NULL
         OR L_SUPERSTACK IS NOT NULL
         OR L_COMP IS NOT NULL
         OR L_ROLLBACK = 0
      THEN
         ROLLBACK;
      END IF;

      IF L_ROLLBACK = 0
      THEN
         RAISE L_SOURCE_EXCEPTION;
      END IF;
   EXCEPTION
      WHEN L_SOURCE_EXCEPTION
      THEN
         ROLLBACK;
         raise_application_error (
            -20111,
            'Cannot copy as source title has no selection for either Territories or bouquets or devices.');
      WHEN OTHERS
      THEN
         ROLLBACK;
   --    O_RESULT:=-1;
   END X_CP_COPY_SCH_CONFIG;


   PROCEDURE X_CP_INSERT_VALIDATION (I_SRC_LIC_NUMBER    IN NUMBER,
                                     I_SRC_TITLE         IN VARCHAR2,
                                     I_DEST_LIC_NUMBER   IN NUMBER,
                                     I_DEST_TITLE        IN VARCHAR2,
                                     i_Region            IN VARCHAR2,
                                     i_Sch_Month         IN DATE,
                                     I_STATUS            IN VARCHAR2,
                                     I_MESSAGE           IN VARCHAR2,
                                     I_User              IN VARCHAR2)
   AS
      L_SCL_ID   NUMBER;
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      SELECT X_SEQ_SCH_COPY_LOG.NEXTVAL INTO L_SCL_ID FROM DUAL;

      INSERT INTO X_CP_SCH_COPY_LOG (SCL_ID,
                                     SCL_SOURCE_TITLE,
                                     SCL_PRGM_TITLE,
                                     SCL_LIC_NUMBER,
                                     SCL_REG_CODE,
                                     SCL_SRC_MEDIA_SERVICE,
                                     SCL_DEST_MEDIA_SERVICE,
                                     SCL_SCH_PLAN_MONTH,
                                     SCL_STATUS,
                                     SCL_REASON,
                                     SCL_ENTRY_OPER,
                                     SCL_ENTRY_DATE,
                                     SCL_MODIFY_OPER,
                                     SCL_MODIFY_DATE)
           VALUES (
                     L_SCL_ID,
                     I_SRC_TITLE,
                     I_DEST_TITLE,
                     I_DEST_LIC_NUMBER,
                     i_Region,
                     (SELECT LEE_MEDIA_SERVICE_CODE
                        FROM FID_LICENSEE
                       WHERE LEE_NUMBER =
                                (SELECT LIC_LEE_NUMBER
                                   FROM FID_LICENSE
                                  WHERE LIC_NUMBER = I_SRC_LIC_NUMBER)),
                     (SELECT LEE_MEDIA_SERVICE_CODE
                        FROM FID_LICENSEE
                       WHERE LEE_NUMBER =
                                (SELECT LIC_LEE_NUMBER
                                   FROM FID_LICENSE
                                  WHERE LIC_NUMBER = I_DEST_LIC_NUMBER)),
                     i_Sch_Month,
                     I_STATUS,
                     I_MESSAGE,
                     I_User,
                     SYSDATE,
                     NULL,
                     NULL);

      COMMIT;
   END;

   PROCEDURE X_PRC_COPY_SCH (I_LIC_NUMBER   IN     NUMBER,
                             I_BIN_ID       IN     NUMBER,
                             I_SRC_TER      IN     VARCHAR2,
                             I_DEST_TER     IN     VARCHAR2,
                             I_BOUQUET      IN     VARCHAR2,
                             I_User         IN     VARCHAR2,
                             O_RESULT          OUT NUMBER)
   AS
      L_CPST_ID        NUMBER;
      L_CDCR_ID        NUMBER;
      L_BOUQ_PRESENT   NUMBER;
   BEGIN
      O_RESULT := 1;

      FOR SRC
         IN (SELECT PLTT_ID,
                    PTBT_ID,
                    PTBT_BOUQUET_ID,
                    PTBT_TER_CODE,
                    PTBT_PVR_START_DATE,
                    PTBT_PVR_END_DATE,
                    PTBT_OTT_START_DATE,
                    PTBT_OTT_END_DATE,
                    PTBT_SCH_PVR_FROM_TIME,
                    PTBT_SCH_PVR_END_TIME,
                    PTBT_SCH_OTT_FROM_TIME,
                    PTBT_SCH_OTT_END_TIME,
                    PTBT_BOUQ_SUPERS_RIGHTS,
                    PTBT_PLT_DEV_RIGHTS,
                    PTBT_BOUQUET_RIGHTS
               FROM X_CP_PLAY_LIST_TEMP, X_CP_PLT_TERR_BOUQ_TEMP
              WHERE     PLTT_LIC_NUMBER = I_LIC_NUMBER
                    AND PLTT_BIN_ID = I_BIN_ID
                    AND PTBT_PLT_ID = PLTT_ID
                    AND PTBT_TER_CODE = I_SRC_TER
                    AND PTBT_BOUQUET_ID IN
                           (SELECT CB_ID
                              FROM X_CP_BOUQUET
                             WHERE CB_NAME IN
                                      (SELECT COLUMN_VALUE Col
                                         FROM TABLE (
                                                 X_CP_SUPERSTACK_RIGHTS.split_to_char (
                                                    I_BOUQUET,
                                                    ',')))
                                   AND CB_AD_FLAG = 'A'
                                   AND CB_BOUQ_PARENT_ID IS NULL))
      LOOP
         FOR DEST_TER
            IN (SELECT PTBT_ID, PTBT_PLT_ID
                  FROM X_CP_PLT_TERR_BOUQ_TEMP
                 WHERE PTBT_TER_CODE IN
                          (SELECT COLUMN_VALUE COL
                             FROM TABLE (
                                     X_CP_SUPERSTACK_RIGHTS.SPLIT_TO_CHAR (
                                        I_DEST_TER,
                                        ',')))
                       --AND PTBT_BOUQUET_ID IN (SELECT CB_ID FROM X_CP_BOUQUET WHERE CB_NAME IN (SELECT COLUMN_VALUE Col FROM TABLE(X_CP_SUPERSTACK_RIGHTS.split_to_char(I_BOUQUET,','))) AND CB_AD_FLAG='A' AND CB_BOUQ_PARENT_ID IS NULL)
                       AND PTBT_BOUQUET_ID = SRC.PTBT_BOUQUET_ID
                       AND PTBT_PLT_ID = SRC.PLTT_ID)
         LOOP
            UPDATE X_CP_PLT_TERR_BOUQ_TEMP
               SET PTBT_TER_IE_FLAG = 'I',
                   --PTBT_BOUQUET_RIGHTS = 'Y',
                   PTBT_BOUQUET_RIGHTS = SRC.PTBT_BOUQUET_RIGHTS,
                   PTBT_PLT_DEV_RIGHTS = SRC.PTBT_PLT_DEV_RIGHTS,
                   PTBT_BOUQ_SUPERS_RIGHTS = SRC.PTBT_BOUQ_SUPERS_RIGHTS,
                   PTBT_PVR_START_DATE = SRC.PTBT_PVR_START_DATE,
                   PTBT_PVR_END_DATE = SRC.PTBT_PVR_END_DATE,
                   PTBT_OTT_START_DATE = SRC.PTBT_OTT_START_DATE,
                   PTBT_OTT_END_DATE = SRC.PTBT_OTT_END_DATE,
                   PTBT_SCH_PVR_FROM_TIME = SRC.PTBT_SCH_PVR_FROM_TIME,
                   PTBT_SCH_PVR_END_TIME = SRC.PTBT_SCH_PVR_END_TIME,
                   PTBT_SCH_OTT_FROM_TIME = SRC.PTBT_SCH_OTT_FROM_TIME,
                   PTBT_SCH_OTT_END_TIME = SRC.PTBT_SCH_OTT_END_TIME
             WHERE PTBT_ID = DEST_TER.PTBT_ID;

            DELETE FROM X_CP_PLT_SUBBOUQ_MAPP_TEMP
                  WHERE CPST_PLT_ID = DEST_TER.PTBT_PLT_ID
                        AND CPST_PTB_ID = DEST_TER.PTBT_ID;

            FOR SRC_SUBBOUQ
               IN (SELECT CPST_SUBBOUQUET_ID, CPST_SUBBOUQUET_RIGHTS
                     FROM X_CP_PLT_SUBBOUQ_MAPP_TEMP
                    WHERE CPST_PLT_ID = SRC.PLTT_ID
                          AND CPST_PTB_ID = SRC.PTBT_ID)
            LOOP
               SELECT X_SEQ_SUB_BOUQ_TEMP_ID.NEXTVAL INTO L_CPST_ID FROM DUAL;

               INSERT
                 INTO X_CP_PLT_SUBBOUQ_MAPP_TEMP (CPST_ID,
                                                  CPST_PLT_ID,
                                                  CPST_PTB_ID,
                                                  CPST_SUBBOUQUET_ID,
                                                  CPST_UPDATE_COUNT,
                                                  CPST_ENTRY_OPER,
                                                  CPST_ENTRY_DATE,
                                                  CPST_MODIFY_OPER,
                                                  CPST_MODIFY_DATE,
                                                  CPST_SUBBOUQUET_RIGHTS)
               VALUES (L_CPST_ID,
                       DEST_TER.PTBT_PLT_ID,
                       DEST_TER.PTBT_ID,
                       SRC_SUBBOUQ.CPST_SUBBOUQUET_ID,
                       0,
                       I_USER,
                       SYSDATE,
                       NULL,
                       NULL,
                       SRC_SUBBOUQ.CPST_SUBBOUQUET_RIGHTS);
            END LOOP;

            DELETE FROM X_CP_PLT_DEVCOMP_RIGHTS_TEMP
                  WHERE CDCR_PTBT_ID = DEST_TER.PTBT_ID;

            FOR SRC_DEV_COM
               IN (SELECT CDCR_DEV_ID, CDCR_COMP_ID, CDCR_COMP_RIGHTS
                     FROM X_CP_PLT_DEVCOMP_RIGHTS_TEMP
                    WHERE CDCR_PTBT_ID = SRC.PTBT_ID)
            LOOP
               SELECT x_seq_DEV_COMP_id.NEXTVAL INTO L_CDCR_ID FROM DUAL;

               INSERT INTO X_CP_PLT_DEVCOMP_RIGHTS_TEMP (CDCR_ID,
                                                         CDCR_PTBT_ID,
                                                         CDCR_DEV_ID,
                                                         CDCR_COMP_ID,
                                                         CDCR_COMP_RIGHTS)
                    VALUES (L_CDCR_ID,
                            DEST_TER.PTBT_ID,
                            SRC_DEV_COM.CDCR_DEV_ID,
                            SRC_DEV_COM.CDCR_COMP_ID,
                            SRC_DEV_COM.CDCR_COMP_RIGHTS);
            END LOOP;
         END LOOP;
      END LOOP;

      UPDATE X_CP_PLT_TERR_BOUQ_TEMP
         SET PTBT_UPDATE_COUNT = PTBT_UPDATE_COUNT + 1,
             PTBT_MODIFY_OPER = I_USER,
             PTBT_MODIFY_DATE = SYSDATE
       WHERE PTBT_PLT_ID IN
                (SELECT pltt_id
                   FROM x_cp_play_list_temp
                  WHERE PLTT_LIC_NUMBER = I_LIC_NUMBER
                        AND PLTT_BIN_ID = I_BIN_ID);
   /*EXCEPTION WHEN OTHERS THEN
    O_RESULT := -1;  */
   END X_PRC_COPY_SCH;



   PROCEDURE X_PRC_COPY_LOG_RPT (I_SRC_TITLE        IN     VARCHAR2,
                                 I_MEDIA_SERVICE    IN     VARCHAR2,
                                 I_SCH_PLAN_MONTH   IN     DATE,
                                 O_LOG                 OUT SYS_REFCURSOR)
   AS
   BEGIN
      OPEN O_LOG FOR
         SELECT SCL_SOURCE_TITLE,
                SCL_PRGM_TITLE,
                SCL_LIC_NUMBER,
                (SELECT lee_short_name
                   FROM fid_licensee
                  WHERE lee_number = (SELECT lic_lee_number
                                        FROM fid_license
                                       WHERE lic_number = SCL_LIC_NUMBER))
                   licensee,
                (SELECT REG_CODE
                   FROM FID_REGION
                  WHERE REG_ID = SCL_REG_CODE)
                   SCL_REG_CODE,
                SCL_SRC_MEDIA_SERVICE,
                SCL_DEST_MEDIA_SERVICE,
                SCL_SCH_PLAN_MONTH,
                SCL_STATUS,
                SCL_REASON
           FROM X_CP_SCH_COPY_LOG
          WHERE SCL_SOURCE_TITLE = I_SRC_TITLE
                AND SCL_SRC_MEDIA_SERVICE LIKE I_MEDIA_SERVICE
                AND SCL_SCH_PLAN_MONTH BETWEEN (SELECT LAST_DAY (
                                                          ADD_MONTHS (
                                                             I_SCH_PLAN_MONTH,
                                                             -1))
                                                       + 1
                                                  FROM DUAL)
                                           AND (SELECT LAST_DAY (
                                                          I_SCH_PLAN_MONTH)
                                                  FROM DUAL);
   END X_PRC_COPY_LOG_RPT;

   --CU4ALL : END MILAN
   --CU4ALL : START : ANUJA SHINDE
   PROCEDURE X_PRC_SCHEDULE_ON_TERR_BOUQ (I_BIN_ID            IN NUMBER,
                                          I_BIN_LIC_NUMBER    IN NUMBER,
                                          I_PLT_ID            IN NUMBER,
                                          I_DEV_ID            IN NUMBER,
                                          I_DEV_GRID_FLAG     IN VARCHAR2,
                                          I_START_DATE        IN DATE,
                                          I_END_DATE          IN DATE,
                                          I_PUSH_START_DATE   IN DATE,
                                          I_PULL_START_DATE   IN DATE,
                                          I_PUSH_END_DATE     IN DATE,
                                          i_pull_end_date     IN DATE,
                                          I_START_TIME        IN NUMBER,
                                          I_end_time          IN NUMBER,
                                          I_ENTRY_OPER        IN VARCHAR2,
                                          I_UPDATE_COUNT      IN NUMBER)
   AS
      L_Terr_Bouq_Seq                  NUMBER;
      L_CON_BOUQ_RYTS_CNT              NUMBER;
      L_CON_SCH_LIN_SER_CHA            FID_CONTRACT.CON_SCH_LIN_SER_CHA%TYPE;
      L_CON_ALLOW_EXH_WEEK_TIER_SER    FID_CONTRACT.CON_ALLOW_EXH_WEEK_TIER_SER%TYPE;
      L_CON_SCH_AFT_PM_LIN_BOUQ        FID_CONTRACT.CON_SCH_AFT_PREM_LINR_SER_BOUQ%TYPE;
      L_CON_SCH_AFT_PM_LIN_BOUQ_name   VARCHAR2 (100);
      L_Con_Allow_Ring_Fence_Ser       Fid_Contract.Con_Allow_Ring_Fence_Ser%TYPE;
      L_Con_Allow_Ring_Fence_Fea       Fid_Contract.Con_Allow_Ring_Fence_Fea%TYPE;
      L_Without_Lin_Ref                Fid_License.Lic_Sch_Without_Lin_Ref%TYPE;
      L_Gen_Refno                      Fid_License.Lic_Gen_Refno%TYPE;
      L_Prog_Is_Ser                    VARCHAR2 (1);
      L_Con_Compact_Vp_Runs_Fea        Fid_Contract.Con_Compact_Vp_Runs_Fea%TYPE;
      L_Con_Number                     NUMBER;
      L_Gen_Title                      Fid_General.Gen_Title%TYPE;
      L_BOUQ_NAME                      X_CP_BOUQUET.CB_NAME%TYPE;
      L_IS_SUPER_USR                   NUMBER;
      L_LIN_SCH_NUMBER                 NUMBER;
      L_SCH_CHA_NUMBER                 NUMBER;
      L_LIN_LIC_NUMBER                 NUMBER;
      L_PREM_SCH_NUMBER                NUMBER;
      L_PREM_SCH_CHA_NO                NUMBER;
      L_PREM_SCH_CHA_BOU_ID            NUMBER;
      L_CHA_CHANNEL_TYPE               VARCHAR2 (50);
      L_LIC_LEE_NUMBER                 NUMBER;
      L_PREM_BOUQ_ID                   NUMBER;
      L_LIN_SCH_DATE                   DATE;
      L_EXH_WEEK_LAST_DATE             DATE;
      L_CP_VP_USED                     NUMBER;
      L_IS_BOUQ_CNT                    NUMBER;
      L_IS_SUBBOUQ_CNT                 NUMBER;
      L_IS_TERR_CNT                    NUMBER;
      l_sch_cnt                        NUMBER;
      l_min_sch_start                  DATE;
      L_MAX_SCH_END                    DATE;
      l_del_method                     VARCHAR2 (20);
      l_ss_avail_date_to               DATE;
      l_lic_max_viewing_period         NUMBER;
   BEGIN
      SELECT COUNT (1)
        INTO L_Is_Super_Usr
        FROM Ora_Aspnet_Users Usr,
             Ora_Aspnet_Usersinroles Usr_Role,
             ORA_ASPNET_ROLES ROL
       WHERE     Usr.Userid = Usr_Role.Userid
             AND ROL.ROLEID = USR_ROLE.ROLEID
             AND UPPER (Usr.Username) LIKE UPPER ('%' || I_Entry_Oper || '%')
             AND UPPER (ROL.ROLENAME) IN ('CATCHUP_SCH_ADMIN', 'ADMIN');

      SELECT COUNT (1)
        INTO L_SCH_CNT
        FROM X_CP_PLAY_LIST
       WHERE     PLT_LIC_NUMBER = I_BIN_LIC_NUMBER
             AND PLT_BIN_ID = I_BIN_ID
             AND PLT_DEV_ID = I_DEV_ID;

      SELECT BIN_SUPERSTACK_AVAIL_TO
        INTO l_ss_avail_date_to                                     /*CU4ALL*/
        FROM x_cp_schedule_bin
       WHERE bin_id = i_bin_id;

      SELECT lic_max_viewing_period
        INTO l_lic_max_viewing_period
        FROM fid_license
       WHERE lic_number = I_BIN_LIC_NUMBER
             AND NVL (lic_catchup_flag, 'N') IN
                    (SELECT s1.ms_media_service_flag
                       FROM sgy_pb_media_service s1
                      WHERE s1.ms_media_service_parent = 'CATCHUP');


      SELECT CON_SCH_LIN_SER_CHA,
             CON_ALLOW_EXH_WEEK_TIER_SER,
             CON_SCH_AFT_PREM_LINR_SER_BOUQ,
             (SELECT CB_NAME
                FROM X_CP_BOUQUET
               WHERE CB_ID = CON_SCH_AFT_PREM_LINR_SER_BOUQ),
             CON_ALLOW_RING_FENCE_SER,
             CON_ALLOW_RING_FENCE_FEA,
             Lic_Gen_Refno,
             GEN_TITLE,
             X_FNC_GET_PROG_TYPE (GEN_TYPE),
             con_compact_VP_runs_fea,
             LIC_CON_NUMBER,
             lic_lee_number,
             Lic_Sch_Without_Lin_Ref
        INTO L_Con_Sch_Lin_Ser_Cha, --Schedule After premier Broadcast on 1st Linear Channel FLAG
             L_Con_Allow_Exh_Week_Tier_Ser, --Allow within Exhibiton weeks for Compact
             L_CON_SCH_AFT_PM_LIN_BOUQ, --Schedule After premier Broadcast on 1st Linear Channel BOUQ
             L_CON_SCH_AFT_PM_LIN_BOUQ_name,
             L_CON_ALLOW_RING_FENCE_SER,
             L_CON_ALLOW_RING_FENCE_FEA,
             L_Gen_Refno,
             L_GEN_TITLE,
             L_PROG_IS_SER,
             L_Con_Compact_Vp_Runs_Fea,
             L_CON_NUMBER,
             l_lic_lee_number,
             L_WITHOUT_LIN_REF
        FROM FID_CONTRACT, FID_LICENSE, fid_general
       WHERE     CON_NUMBER = LIC_CON_NUMBER
             AND Gen_Refno = Lic_Gen_Refno
             AND LIC_NUMBER = I_BIN_LIC_NUMBER;

      -- valiadte if not a single bouquet is selected while scheduling
      SELECT COUNT (1)
        INTO L_IS_BOUQ_cnt
        FROM X_CP_PLT_TERR_BOUQ_TEMP, X_CP_PLAY_LIST_TEMP
       WHERE     PLTT_ID = PTBT_PLT_ID
             AND PLTT_BIN_ID = I_BIN_ID
             AND PLTT_LIC_NUMBER = I_BIN_LIC_NUMBER
             AND PTBT_BOUQUET_RIGHTS = 'Y'
             AND PLTT_DEV_ID = I_DEV_ID;

      -- valiadte if not a single sub-bouquet is selected while scheduling
      SELECT COUNT (1)
        INTO L_IS_SUBBOUQ_CNT
        FROM X_CP_PLT_TERR_BOUQ_TEMP,
             X_CP_PLAY_LIST_TEMP,
             X_CP_PLT_SUBBOUQ_MAPP_TEMP
       WHERE     PLTT_ID = PTBT_PLT_ID
             AND ptbt_id = CPST_PTB_ID
             AND PLTT_BIN_ID = I_BIN_ID
             AND PLTT_LIC_NUMBER = I_BIN_LIC_NUMBER
             AND CPST_SUBBOUQUET_ID IS NOT NULL
             AND PTBT_BOUQUET_RIGHTS = 'Y'
             AND CPST_SUBBOUQUET_RIGHTS = 'Y'
             AND PLTT_DEV_ID = I_DEV_ID;

      -- valiadte if not a single territory is selected while scheduling
      SELECT COUNT (1)
        INTO L_IS_terr_cnt
        FROM X_CP_PLT_TERR_BOUQ_TEMP, X_CP_PLAY_LIST_TEMP
       WHERE     PLTT_ID = PTBT_PLT_ID
             AND PLTT_BIN_ID = I_BIN_ID
             AND PLTT_LIC_NUMBER = I_BIN_LIC_NUMBER
             AND PTBT_TER_IE_FLAG = 'I'
             AND PLTT_DEV_ID = I_DEV_ID;

      IF L_IS_BOUQ_cnt = 0
      THEN
         ROLLBACK;
         RAISE_APPLICATION_ERROR (
            -20170,
            'Please select atleast one primary bouquet for title '
            || L_GEN_TITLE);
      END IF;

      IF L_IS_SUBBOUQ_CNT = 0
      THEN
         ROLLBACK;
         RAISE_APPLICATION_ERROR (
            -20170,
            'Please select atleast one sub-bouquet for title ' || L_GEN_TITLE);
      END IF;

      IF L_IS_terr_cnt = 0
      THEN
         ROLLBACK;
         RAISE_APPLICATION_ERROR (
            -20170,
            'Please select atleast one territory for title ' || L_GEN_TITLE);
      END IF;

      /* when updating the schedule */
      IF L_SCH_CNT > 0
      THEN
         DELETE FROM X_CP_PLT_DEVCOMP_RIGHTS
               WHERE CDCR_PTBT_ID IN
                        (SELECT PTB_ID
                           FROM X_CP_PLAY_LIST, X_CP_PLT_TERR_BOUQ
                          WHERE     PLT_ID = PTB_PLT_ID
                                AND PLT_LIC_NUMBER = I_BIN_LIC_NUMBER
                                AND PLT_BIN_ID = I_BIN_ID
                                AND plt_dev_id = I_DEV_ID);

         DELETE FROM X_CP_PLT_DEV_SUBBOUQ_MAPP
               WHERE CPS_PTB_ID IN
                        (SELECT PTB_ID
                           FROM X_CP_PLAY_LIST, X_CP_PLT_TERR_BOUQ
                          WHERE     PLT_ID = PTB_PLT_ID
                                AND PLT_LIC_NUMBER = I_BIN_LIC_NUMBER
                                AND plt_dev_id = I_DEV_ID
                                AND PLT_BIN_ID = I_BIN_ID);

         DELETE FROM X_CP_PLT_TERR_BOUQ
               WHERE PTB_PLT_ID IN
                        (SELECT PLT_ID
                           FROM X_CP_PLAY_LIST
                          WHERE     PLT_LIC_NUMBER = I_BIN_LIC_NUMBER
                                AND plt_dev_id = I_DEV_ID
                                AND PLT_BIN_ID = i_bin_id);
      END IF;

      /*check for date and device reverse flow from sch grid to bouquet pop up
        before inserting teritory and bouquet schedule
        case 1 : direct sch from sch grid(update dates for that device on bouquet popup)
        case 2 : saved on bouquet pop up and changed from sch grid
        case 3 : saved on bouquet pop up and then schedule
        case 4 : selected other device than on bouquet pop up */


      SELECT PKG_PB_MEDIA_PLAT_SER.X_FUN_GET_DEV_DELIEVERY_METHOD (I_DEV_ID)
        INTO l_del_method
        FROM DUAL;

      IF I_DEV_GRID_FLAG = 'Y'
      THEN
         IF UPPER (L_DEL_METHOD) = 'BOTH'
         THEN
            UPDATE X_CP_PLT_TERR_BOUQ_TEMP
               SET PTBT_PLT_DEV_RIGHTS = 'Y',
                   PTBT_PVR_START_DATE = I_PUSH_START_DATE,
                   PTBT_PVR_END_DATE = I_PUSH_END_DATE,
                   PTBT_OTT_START_DATE = I_PULL_START_DATE,
                   PTBT_OTT_END_DATE = I_PULL_END_DATE,
                   PTBT_SCH_PVR_FROM_TIME = CONVERT_TIME_C_N(to_char(I_PUSH_START_DATE,'hh24:mi:ss')),
                   PTBT_SCH_PVR_END_TIME = CONVERT_TIME_C_N(to_char(I_PUSH_END_DATE,'hh24:mi:ss')),
                   PTBT_SCH_OTT_FROM_TIME = CONVERT_TIME_C_N(to_char(I_PULL_START_DATE,'hh24:mi:ss')),
                   PTBT_SCH_OTT_END_TIME = CONVERT_TIME_C_N(to_char(I_PULL_END_DATE,'hh24:mi:ss'))
             WHERE PTBT_PLT_ID IN
                      (SELECT PLTT_ID
                         FROM X_CP_PLAY_LIST_TEMP
                        WHERE     PLTT_BIN_ID = I_BIN_ID
                              AND PLTT_LIC_NUMBER = I_BIN_LIC_NUMBER
                              AND PLTT_DEV_ID = I_DEV_ID)
                   AND PTBT_BOUQUET_RIGHTS = 'Y'
                   AND PTBT_TER_IE_FLAG = 'I';
         ELSIF UPPER (L_DEL_METHOD) = 'PUSH'
         THEN
            UPDATE X_CP_PLT_TERR_BOUQ_TEMP
               SET PTBT_PLT_DEV_RIGHTS = 'Y',
                   PTBT_PVR_START_DATE = I_START_DATE,
                   PTBT_PVR_END_DATE = I_END_DATE,
                   PTBT_OTT_START_DATE = NULL,
                   PTBT_OTT_END_DATE = NULL,
                   PTBT_SCH_PVR_FROM_TIME = CONVERT_TIME_C_N(to_char(I_START_DATE,'hh24:mi:ss')),
                   PTBT_SCH_PVR_END_TIME = CONVERT_TIME_C_N(to_char(I_END_DATE,'hh24:mi:ss')),
                   PTBT_SCH_OTT_FROM_TIME = NULL,
                   PTBT_SCH_OTT_END_TIME = NULL
             WHERE PTBT_PLT_ID IN
                      (SELECT PLTT_ID
                         FROM X_CP_PLAY_LIST_TEMP
                        WHERE     PLTT_BIN_ID = I_BIN_ID
                              AND PLTT_LIC_NUMBER = I_BIN_LIC_NUMBER
                              AND PLTT_DEV_ID = I_DEV_ID)
                   AND PTBT_BOUQUET_RIGHTS = 'Y'
                   AND PTBT_TER_IE_FLAG = 'I';
         ELSIF UPPER (L_DEL_METHOD) = 'PULL'
         THEN
            UPDATE X_CP_PLT_TERR_BOUQ_TEMP
               SET PTBT_PLT_DEV_RIGHTS = 'Y',
                   PTBT_PVR_START_DATE = NULL,
                   PTBT_PVR_END_DATE = NULL,
                   PTBT_OTT_START_DATE = I_START_DATE,
                   PTBT_OTT_END_DATE = I_END_DATE,
                   PTBT_SCH_PVR_FROM_TIME = NULL,
                   PTBT_SCH_PVR_END_TIME = NULL,
                   PTBT_SCH_OTT_FROM_TIME = CONVERT_TIME_C_N(to_char(I_START_DATE,'hh24:mi:ss')),
                   PTBT_SCH_OTT_END_TIME = CONVERT_TIME_C_N(to_char(I_END_DATE,'hh24:mi:ss'))
             WHERE PTBT_PLT_ID IN
                      (SELECT PLTT_ID
                         FROM X_CP_PLAY_LIST_TEMP
                        WHERE     PLTT_BIN_ID = I_BIN_ID
                              AND PLTT_LIC_NUMBER = I_BIN_LIC_NUMBER
                              AND PLTT_DEV_ID = I_DEV_ID)
                   AND PTBT_BOUQUET_RIGHTS = 'Y'
                   AND PTBT_TER_IE_FLAG = 'I';
         END IF;
      END IF;

      ----------------

      FOR L_SCH
         IN (SELECT DISTINCT PTBT_ID,
                             PTBT_PLT_ID,
                             PTBT_BOUQUET_ID,
                             PTBT_TER_CODE,
                             PTBT_PVR_START_DATE,
                             PTBT_PVR_END_DATE,
                             PTBT_SCH_PVR_FROM_TIME,
                             PTBT_SCH_PVR_END_TIME,
                             PTBT_OTT_START_DATE,
                             PTBT_OTT_END_DATE,
                             PTBT_SCH_OTT_FROM_TIME,
                             PTBT_SCH_OTT_END_TIME,
                             PTBT_BOUQ_SUPERS_RIGHTS
               FROM X_CP_PLT_TERR_BOUQ_TEMP, X_CP_PLT_SUBBOUQ_MAPP_TEMP
              WHERE PTBT_ID = CPST_PTB_ID
                    AND PTBT_PLT_ID IN
                           (SELECT PLTT_ID
                              FROM X_CP_PLAY_LIST_TEMP
                             WHERE     PLTT_BIN_ID = I_BIN_ID
                                   AND PLTT_LIC_NUMBER = I_BIN_LIC_NUMBER
                                   AND PLTT_DEV_ID = I_DEV_ID)
                    AND PTBT_TER_IE_FLAG = 'I'
                    AND PTBT_BOUQUET_RIGHTS = 'Y'
                    AND PTBT_PLT_DEV_RIGHTS = 'Y'
                    AND CPST_SUBBOUQUET_RIGHTS = 'Y')
      LOOP
         -- VALIDATION FOR CONTRACT BOUQ RIGHTS
         SELECT COUNT (Cbm_Bouque_Id)
           INTO L_CON_BOUQ_RYTS_CNT
           FROM X_Con_Bouque_Mapp
          WHERE     Cbm_Con_Bouq_Rights = 'Y'
                AND CBM_CON_Number = L_Con_Number
                AND CBM_BOUQUE_ID = L_SCH.PTBT_BOUQUET_ID;

         SELECT CB_NAME
           INTO L_BOUQ_NAME
           FROM X_CP_BOUQUET
          WHERE cb_id = L_SCH.PTBT_BOUQUET_ID;

         IF L_Is_Super_Usr = 0
         THEN
            IF L_CON_BOUQ_RYTS_CNT = 0
            THEN
               ROLLBACK;
               Raise_Application_Error (
                  -20170,
                     'Contract doesn¿ provide rights for '
                  || L_Bouq_Name
                  || ' for title '
                  || L_Gen_Title);
            END IF;

            -- Validations for linear linked CP licenses
            IF NVL (L_Without_Lin_Ref, 'N') = 'N'
            THEN
               SELECT BIN_SCH_NUMBER,
                      SCH_LIC_NUMBER,
                      BIN_SCH_CHA_NUMBER,
                      SCH_DATE
                 INTO L_LIN_SCH_NUMBER,
                      l_lin_lic_number,
                      L_SCH_CHA_NUMBER,
                      l_lin_sch_date
                 FROM X_CP_SCHEDULE_BIN, FID_SCHEDULE
                WHERE     BIN_SCH_NUMBER = sch_number
                      AND bin_lic_number = I_BIN_LIC_NUMBER
                      AND BIN_ID = I_BIN_ID;

               -- linear premier schedule information
               SELECT SCH_NUMBER,
                      SCH_CHA_NUMBER,
                      CHA_PRIMARY_BOUQUET_ID,
                      UPPER (CHA_CHANNEL_TYPE)
                 INTO L_PREM_SCH_NUMBER,
                      L_PREM_SCH_CHA_NO,
                      L_PREM_SCH_CHA_BOU_ID,
                      L_CHA_CHANNEL_TYPE
                 FROM (  SELECT SCH_NUMBER,
                                SCH_CHA_NUMBER,
                                CHA_PRIMARY_BOUQUET_ID,
                                CHA_CHANNEL_TYPE
                           FROM FID_SCHEDULE FSH, FID_CHANNEL
                          WHERE sch_cha_number = cha_number
                                AND FSH.sch_lic_number = l_lin_lic_number
                       ORDER BY 1)
                WHERE ROWNUM = 1;

               IF L_LIN_SCH_NUMBER <> L_PREM_SCH_NUMBER
               THEN
                  ROLLBACK;
                  Raise_Application_Error (
                     -20170,
                     'Linear run should be premiere for title '
                     || L_Gen_Title);
               END IF;

               IF NVL (L_CON_SCH_AFT_PM_LIN_BOUQ, 0) <> 0
                  AND NVL (L_PREM_SCH_CHA_BOU_ID, 0) <>
                         NVL (L_CON_SCH_AFT_PM_LIN_BOUQ, 0) --and L_SCH.PTBT_BOUQUET_ID and/* confirm current bouq in loop should be considered*/
               THEN
                  ROLLBACK;
                  Raise_Application_Error (
                     -20170,
                        'Linear premiere run should be on '
                     || L_CON_SCH_AFT_PM_LIN_BOUQ_name
                     || ' channel for the title '
                     || L_Gen_Title);
               END IF;
            END IF;

            IF NVL (L_CON_SCH_LIN_SER_CHA, 'N') = 'Y'
               AND (UPPER (L_CHA_CHANNEL_TYPE) LIKE UPPER ('Non-Series')
                    OR UPPER (L_CHA_CHANNEL_TYPE) LIKE UPPER ('Both'))
            THEN
               ROLLBACK;
               RAISE_APPLICATION_ERROR (
                  -20170,
                  'Linear is not scheduled on Series channel for title '
                  || L_GEN_TITLE);
            END IF;

            --Premium bouq for media service
            BEGIN
               SELECT CB_ID
                 INTO l_prem_bouq_id
                 FROM X_CP_BOUQUET, X_CP_BOUQUET_MS_MAPP
                WHERE     CB_ID = CMM_BOUQ_ID
                      AND CB_AD_FLAG = 'A'
                      AND CB_BOUQ_PARENT_ID IS NULL
                      AND CMM_BOUQ_MS_CODE =
                             (SELECT LEE_MEDIA_SERVICE_CODE
                                FROM FID_LICENSEE
                               WHERE LEE_NUMBER = L_LIC_LEE_NUMBER)
                      AND CMM_BOUQ_MS_RIGHTS = 'Y'
                      AND CB_RANK = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  ROLLBACK;
                  RAISE_APPLICATION_ERROR (
                     -20170,
                     'No bouquet is mapped to license Media Service');
            END;

            -- EXHIBITION WEEK
            IF L_SCH.PTBT_BOUQUET_ID <> L_PREM_BOUQ_ID
               AND NVL (L_CON_ALLOW_EXH_WEEK_TIER_SER, 0) <> 0
            THEN
               SELECT TRUNC (l_lin_sch_date, 'IW')
                      + (L_CON_ALLOW_EXH_WEEK_TIER_SER * 7)
                         EXH_WEEK_LAST_DATE
                 INTO L_EXH_WEEK_LAST_DATE
                 FROM DUAL;

               IF L_SCH.PTBT_PVR_START_DATE IS NOT NULL
                  OR L_SCH.PTBT_OTT_START_DATE IS NOT NULL
               THEN
                  IF L_SCH.PTBT_PVR_START_DATE > L_EXH_WEEK_LAST_DATE
                     OR L_SCH.PTBT_OTT_START_DATE > L_EXH_WEEK_LAST_DATE
                  THEN
                     ROLLBACK;
                     RAISE_APPLICATION_ERROR (
                        -20170,
                        'Linear exhibition week cannot exceed as specified on Contract for the title '
                        || L_GEN_TITLE);
                  END IF;
               END IF;
            END IF;

            --One of first V.P. on Catch Up
            -- RING FENCING
            -- VP used for bouquet

            SELECT COUNT (1)
              INTO L_CP_VP_USED
              FROM X_CP_PLAY_LIST, X_CP_PLT_TERR_BOUQ
             WHERE     PLT_ID = PTB_PLT_ID
                   --and PLT_BIN_ID = I_BIN_ID
                   AND PTB_BOUQUET_ID = L_SCH.PTBT_BOUQUET_ID
                   AND PLT_LIC_NUMBER = I_BIN_LIC_NUMBER
                   AND plt_dev_id = I_DEV_ID;



            IF NVL (L_CP_VP_USED, 0) > 0
               AND NVL (L_CON_ALLOW_RING_FENCE_SER, 'N') = 'Y'
            THEN
               ROLLBACK;
               RAISE_APPLICATION_ERROR (
                  -20170,
                     L_GEN_TITLE
                  || ' Title cannot be scheduled on '
                  || L_BOUQ_NAME
                  || ' as it has already scheduled on the this bouquet earlier');
            END IF;
         END IF;                             -- SKIP VALIDATIONS AS SUPER USER


         /*IF L_SCH.PTBT_BOUQ_SUPERS_RIGHTS = 'Y'
         THEN
             IF L_SCH.PTBT_PVR_END_DATE is not null AND L_SCH.PTBT_OTT_END_DATE is not null
             THEN
                 IF (to_char(L_SCH.PTBT_OTT_END_DATE,'DD-MM-RRRR') > to_char(l_ss_avail_date_to,'DD-MM-RRRR'))
                 THEN
                    --L_Error_Message := 'Schedule exceeding max viewing days';
                    raise_application_error (-20325,'Schedule exceeding max viewing days');
                 END IF;
             ELSIF L_SCH.PTBT_PVR_END_DATE is not null AND L_SCH.PTBT_OTT_END_DATE IS NULL
             THEN
                 IF (to_char(L_SCH.PTBT_PVR_END_DATE,'DD-MM-RRRR') > to_char(l_ss_avail_date_to,'DD-MM-RRRR'))
                 THEN
                    --L_Error_Message := 'Schedule exceeding max viewing days';
                    raise_application_error (-20325,'Schedule exceeding max viewing days');
                 END IF;
             ELSIF L_SCH.PTBT_OTT_END_DATE is not null AND L_SCH.PTBT_PVR_END_DATE is null
             THEN
                 IF (to_char(L_SCH.PTBT_OTT_END_DATE,'DD-MM-RRRR') > to_char(l_ss_avail_date_to,'DD-MM-RRRR'))
                 THEN
                    --L_Error_Message := 'Schedule exceeding max viewing days';
                    raise_application_error (-20325,'Schedule exceeding max viewing days');
                 END IF;
             END IF;

         ELSE
         ----------------------------------------- If license not superstacked
           ----------1st solution
               IF (to_char(I_END_DATE,'DD-MM-RRRR') > to_char((I_START_DATE + l_lic_max_viewing_period),'DD-MM-RRRR'))
               THEN
                  raise_application_error (-20325,'Schedule exceeding max viewing days');
               END IF;
           ----------------
           ---------------2nd solution
             IF L_SCH.PTBT_OTT_END_DATE is not null
             THEN
                 IF (to_char(L_SCH.PTBT_OTT_END_DATE,'DD-MM-RRRR') > to_char((I_START_DATE + l_lic_max_viewing_period),'DD-MM-RRRR'))
                 THEN
                      raise_application_error (-20325,'Schedule exceeding max viewing days');
                 END IF;
              ELSE
                 IF (to_char(L_SCH.PTBT_PVR_END_DATE,'DD-MM-RRRR') > to_char((I_START_DATE + l_lic_max_viewing_period),'DD-MM-RRRR'))
                 THEN
                      raise_application_error (-20325,'Schedule exceeding max viewing days');
                 END IF;
             END IF
           --------------------
         -----------------------------------------
         END IF;*/

         l_terr_bouq_seq := X_SEQ_TERR_BOUQ_ID.NEXTVAL;

         INSERT INTO X_CP_PLT_TERR_BOUQ (PTB_ID,
                                         PTB_PLT_ID,
                                         PTB_BOUQUET_ID,
                                         PTB_TER_CODE,
                                         PTB_PVR_START_DATE,
                                         PTB_pvr_END_DATE,
                                         PTB_SCH_PVR_FROM_TIME,
                                         PTB_SCH_PVR_END_TIME,
                                         PTB_OTT_START_DATE,
                                         PTB_OTT_END_DATE,
                                         PTB_SCH_OTT_FROM_TIME,
                                         PTB_SCH_OTT_END_TIME,
                                         PTB_UPDATE_COUNT,
                                         PTB_ENTRY_OPER,
                                         PTB_ENTRY_DATE,
                                         PTB_MODIFY_OPER,
                                         PTB_MODIFY_DATE,
                                         PTB_BOUQ_SUPERS_RIGHTS)
              VALUES (l_terr_bouq_seq,
                      I_PLT_ID,
                      L_SCH.PTBT_BOUQUET_ID,
                      L_SCH.PTBT_TER_CODE,
                      L_SCH.PTBT_PVR_START_DATE,
                      L_SCH.PTBT_PVR_END_DATE,
                      L_SCH.PTBT_SCH_PVR_FROM_TIME,
                      L_SCH.PTBT_SCH_PVR_END_TIME,
                      L_SCH.PTBT_OTT_START_DATE,
                      L_SCH.PTBT_OTT_END_DATE,
                      L_SCH.PTBT_SCH_OTT_FROM_TIME,
                      l_sch.PTBT_SCH_OTT_END_TIME,
                      0,
                      I_ENTRY_OPER,
                      SYSDATE,
                      NULL,
                      NULL,
                      l_sch.PTBT_BOUQ_SUPERS_RIGHTS);

         INSERT INTO X_CP_PLT_DEV_SUBBOUQ_MAPP (CPS_ID,
                                                CPS_PLT_ID,
                                                CPS_PTB_ID,
                                                CPS_SUBBOUQUET_ID,
                                                CPS_UPDATE_COUNT,
                                                CPS_ENTRY_OPER,
                                                CPS_ENTRY_DATE,
                                                CPS_MODIFY_OPER,
                                                CPS_MODIFY_DATE)
            SELECT X_SEQ_SUB_BOUQ_ID.NEXTVAL,
                   I_PLT_ID,
                   L_TERR_BOUQ_SEQ,
                   CPST_SUBBOUQUET_ID,
                   0,
                   I_ENTRY_OPER,
                   SYSDATE,
                   NULL,
                   NULL
              FROM X_CP_PLT_SUBBOUQ_MAPP_TEMP
             WHERE CPST_PTB_ID = L_SCH.PTBT_ID
                   AND CPST_PLT_ID = L_SCH.PTBT_PLT_ID;

         INSERT INTO X_CP_PLT_DEVCOMP_RIGHTS (CDCR_ID,
                                              CDCR_PTBT_ID,
                                              CDCR_DEV_ID,
                                              CDCR_COMP_ID,
                                              CDCR_COMP_RIGHTS)
            SELECT x_seq_DEV_COMP_seq.NEXTVAL,
                   l_terr_bouq_seq,
                   CDCR_DEV_ID,
                   CDCR_COMP_ID,
                   CDCR_COMP_RIGHTS
              FROM X_CP_PLT_DEVCOMP_RIGHTS_TEMP
             WHERE     CDCR_PTBT_ID = L_SCH.PTBT_ID
                   AND CDCR_DEV_ID = I_DEV_ID
                   AND CDCR_COMP_RIGHTS = 'Y';
      END LOOP;
   END X_PRC_SCHEDULE_ON_TERR_BOUQ;

   /*To refresh the grid row after bouquet pop up close*/
   PROCEDURE X_PRC_GET_SCHEDULED_DATA (
      I_BIN_ID           IN     NUMBER,
      I_BIN_LIC_NUMBER   IN     NUMBER,
      O_SCH_DATA            OUT X_PKG_CP_SCH_GRID.X_CUR_SCH_GRID)
   AS
   BEGIN
      OPEN O_SCH_DATA FOR
           SELECT MIN (PTBT_OTT_START_DATE) PTBT_OTT_START_DATE,
                  MAX (PTBT_OTT_END_DATE) PTBT_OTT_END_DATE,
                  MIN (PTBT_PVR_START_DATE) PTBT_PVR_START_DATE,
                  MAX (PTBT_PVR_END_DATE) PTBT_PVR_END_DATE,
                  MD_ID,
                  MD_CODE,
                  MD_DESC,
                  X_FUN_GET_lic_DELIEVERY_METHOD (MD_ID, I_BIN_LIC_NUMBER)
                     LIC_DEL_METHOD
             FROM X_CP_PLT_TERR_BOUQ_TEMP,
                  X_CP_PLAY_LIST_TEMP,
                  X_CP_MEDIA_DEVICE
            WHERE     PLTT_ID = PTBT_PLT_ID
                  AND PLTT_DEV_ID(+) = MD_ID
                  AND PLTT_BIN_ID = I_BIN_ID
         GROUP BY MD_ID,
                  MD_CODE,
                  MD_DESC,
                  X_FUN_GET_lic_DELIEVERY_METHOD (MD_ID, I_BIN_LIC_NUMBER);
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE_APPLICATION_ERROR (-20168, SUBSTR (SQLERRM, 1, 200));
   END X_PRC_GET_SCHEDULED_DATA;

   FUNCTION X_FUN_GET_lic_DELIEVERY_METHOD (I_DEV_ID       IN NUMBER,
                                            i_lic_number   IN NUMBER)
      RETURN VARCHAR2
   AS
      L_DEL_METHOD   VARCHAR2 (100);
      l_comp_cnt     NUMBER;
   BEGIN
      SELECT COUNT (DISTINCT MDC_DELIVERY_METHOD)
        INTO L_COMP_CNT
        FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP, X_CP_MEDIA_DEVICE_COMPAT
       WHERE     LIC_MPDC_COMP_RIGHTS_ID = MDC_ID
             AND LIC_MPDC_DEV_PLATM_ID = I_DEV_ID
             AND LIC_RIGHTS_ON_DEVICE = 'Y'
             AND LIC_IS_COMP_RIGHTS = 'Y'
             AND LIC_MPDC_LIC_NUMBER = i_lic_number;

      IF L_COMP_CNT > 1
      THEN
         L_DEL_METHOD := 'BOTH';
      ELSE
         SELECT DISTINCT MDC_DELIVERY_METHOD
           INTO L_DEL_METHOD
           FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP, X_CP_MEDIA_DEVICE_COMPAT
          WHERE     LIC_MPDC_COMP_RIGHTS_ID = MDC_ID
                AND LIC_MPDC_DEV_PLATM_ID = I_DEV_ID
                AND LIC_RIGHTS_ON_DEVICE = 'Y'
                AND LIC_IS_COMP_RIGHTS = 'Y'
                AND LIC_MPDC_LIC_NUMBER = i_lic_number;
      END IF;

      RETURN L_DEL_METHOD;
   END X_FUN_GET_lic_DELIEVERY_METHOD;


   PROCEDURE x_prc_validate_dev_capacity (i_lic_number   IN     VARCHAR2,
                                          i_start_date   IN     DATE,
                                          i_end_date     IN     DATE,
                                          o_result          OUT NUMBER)
   AS
      l_duration_sum   PLS_INTEGER;
   BEGIN
      SELECT SUM (convert_time_c_s (gen_duration_c))
        INTO l_duration_sum
        FROM x_cp_play_list
             INNER JOIN fid_license
                ON plt_lic_number = lic_number
             INNER JOIN fid_general
                ON lic_gen_refno = gen_refno
             INNER JOIN (SELECT i_start_date + (ROWNUM - 1) curr_date
                           FROM user_objects
                          WHERE i_start_date + (ROWNUM - 1) <= i_end_date)
                ON curr_date BETWEEN plt_sch_start_date AND plt_sch_end_date;
   END x_prc_validate_dev_capacity;

PROCEDURE x_prc_clr_temp_table_data
(
    i_lic_number      IN      NUMBER,
    i_bin_id          IN      NUMBER,
    i_dev_ids         IN      VARCHAR2,
    i_entry_oper      IN      varchar2
)
AS
    l_lic_MS_name     varchar2(100);
    L_DEV_RYTS        varchar2(1);
    l_terr_couq_seq   number;
    L_STR             varchar2(10);
BEGIN
     SELECT LEE_MEDIA_SERVICE_CODE into l_lic_MS_name
     FROM FID_LICENSE,FID_LICENSEE
     WHERE LIC_LEE_NUMBER = LEE_NUMBER
            and lic_number = i_lic_number;
    FOR I IN
    (
        SELECT pltt_id,pltt_dev_id
        from x_cp_play_list_temp
        where pltt_lic_number = i_lic_number
              and pltt_bin_id = i_bin_id
              and pltt_dev_id IN (SELECT md_id
                                  FROM x_cp_media_device
                                  where md_code in (SELECT COLUMN_VALUE COL1
                                                    FROM TABLE(X_PKG_CP_SCH_GRID.SPLIT_TO_CHAR(i_dev_ids,','))))
    )
    LOOP
        DELETE FROM x_cp_plt_devcomp_rights_temp
              where CDCR_PTBT_ID IN (select ptbt_id from x_cp_plt_terr_bouq_temp where ptbt_plt_id = I.pltt_id);

        --DELETE FROM x_cp_plt_subbouq_mapp_temp where cpst_plt_id = I.pltt_id;

        --DELETE FROM x_cp_plt_terr_bouq_temp where ptbt_plt_id = I.pltt_id;

--        BEGIN
--             SELECT DISTINCT LIC_MPDC_DEV_PLATM_ID ,'Y' INTO L_STR,L_DEV_RYTS
--             FROM X_CP_LIC_MEDPLATMDEVCOMPAT_MAP
--             WHERE LIC_MPDC_LIC_NUMBER = I_LIC_NUMBER
--             AND LIC_RIGHTS_ON_DEVICE = 'Y'
--             AND LIC_MPDC_DEV_PLATM_ID = I.pltt_dev_id;
--        EXCEPTION WHEN OTHERS THEN
--             L_DEV_RYTS := 'N';
--        END;
--
--        FOR l_TERR_BOUQ IN(SELECT * FROM
--                  (SELECT TERR.*, BOUQ.*, DEV.*
--                   FROM X_CP_SCH_BIN_TERRITORY TERR,
--                   (
--                       SELECT 'Y'
--                               IS_BOUQ_CHECKED,
--                               CB_ID BOUQ_ID,
--                               CB_SHORT_CODE,
--                               CB_RANK,
--                               CB_NAME,
--                               NVL ((SELECT LSR_SUPERSTACK_FLAG
--                                     FROM x_cp_lic_superstack_rights
--                                     WHERE lsr_lic_number =  i_lic_number
--                                           AND lsr_bouquet_id =  CB_ID),'N') SUPER_STACK,
--                               BIN_SUPERSTACK_AVAIL_FROM,
--                               BIN_SUPERSTACK_AVAIL_TO
--                       FROM X_CP_SCH_BOUQUET_MAPP,
--                            X_CP_BOUQUET,
--                            X_CP_BOUQUET_MS_MAPP,
--                            X_CP_SCHEDULE_BIN
--                       WHERE
--                            CMM_BOUQ_ID = CB_ID
--                            AND CMM_BOUQ_MS_CODE = l_lic_MS_name
--                            AND CMM_BOUQ_MS_RIGHTS = 'Y'
--                            AND NVL (CB_BOUQ_PARENT_ID,0) = 0
--                            AND CB_AD_FLAG ='A'
--                            AND BIN_ID =SBM_BIN_ID
--                            AND CB_ID = SBM_BOUQUET_ID
--                            AND SBM_BIN_ID =i_bin_id
--                       UNION
--                            SELECT 'N' IS_BOUQ_CHECKED,
--                                    CB_ID BOUQ_ID,
--                                    CB_SHORT_CODE,
--                                    CB_RANK,
--                                    CB_NAME,
--                                    NVL ((SELECT LSR_SUPERSTACK_FLAG
--                                          FROM x_cp_lic_superstack_rights
--                                          WHERE lsr_lic_number =  i_lic_number
--                                                AND lsr_bouquet_id =  CB_ID),'N')SUPER_STACK,
--                                    NULL BIN_SUPERSTACK_AVAIL_FROM,
--                                    NULL BIN_SUPERSTACK_AVAIL_TO
--                             FROM X_CP_BOUQUET
--                                  ,X_CP_BOUQUET_MS_MAPP
--                             WHERE
--                                  CMM_BOUQ_ID = CB_ID
--                                  AND CMM_BOUQ_MS_CODE = l_lic_MS_name
--                                  AND CMM_BOUQ_MS_RIGHTS = 'Y'
--                                  AND NVL (CB_BOUQ_PARENT_ID,0) = 0
--                                  AND CB_AD_FLAG = 'A'
--                                  AND CB_ID NOT IN (SELECT SBM_BOUQUET_ID
--                                                    FROM X_CP_SCH_BOUQUET_MAPP
--                                                    WHERE SBM_BIN_ID =i_bin_id)
--                    ) BOUQ,
--                    (
--                        SELECT MD_ID,
--                               MDP_MAP_PLATM_CODE,
--                               i_lic_number,
--                               MD_CODE,
--                               MD_DESC,
--                               L_DEV_RYTS LIC_RIGHTS_ON_DEVICE
--                        FROM
--                               X_CP_MEDIA_DEVICE,
--                               X_CP_MEDIA_DEV_PLATM_MAP
--                        WHERE
--                               MDP_MAP_DEV_ID = MD_ID
--                               AND MD_ID = I.pltt_dev_id
--                     )DEV
--                WHERE SBT_BIN_ID = i_bin_id)
--                ORDER BY SBT_TER_CODE,CB_SHORT_CODE,LIC_RIGHTS_ON_DEVICE)
--        LOOP
--            l_terr_couq_seq := X_SEQ_TERR_BOUQ_TEMP_ID.NEXTVAL;
--
--            INSERT INTO X_CP_PLT_TERR_BOUQ_TEMP
--            (
--                 PTBT_ID,
--                 PTBT_PLT_ID,
--                 PTBT_PLT_DEV_RIGHTS,
--                 PTBT_BOUQUET_ID,
--                 PTBT_BOUQUET_RIGHTS,
--                 PTBT_BOUQ_SUPERS_RIGHTS,
--                 PTBT_TER_CODE,
--                 PTBT_TER_IE_FLAG,
--                 PTBT_PVR_START_DATE,
--                 PTBT_PVR_END_DATE,
--                 PTBT_OTT_START_DATE,
--                 PTBT_OTT_END_DATE,
--                 PTBT_SCH_PVR_FROM_TIME,
--                 PTBT_SCH_PVR_END_TIME,
--                 PTBT_SCH_OTT_FROM_TIME,
--                 PTBT_SCH_OTT_END_TIME,
--                 PTBT_UPDATE_COUNT,
--                 PTBT_ENTRY_OPER,
--                 PTBT_ENTRY_DATE,
--                 PTBT_MODIFY_OPER,
--                 PTBT_MODIFY_DATE
--            )
--            VALUES
--            (
--                 l_terr_couq_seq,
--                 I.pltt_id,
--                 'N',
--                 l_TERR_BOUQ.BOUQ_ID,
--                 L_TERR_BOUQ.IS_BOUQ_CHECKED,
--                 L_TERR_BOUQ.SUPER_STACK,
--                 L_TERR_BOUQ.SBT_TER_CODE,
--                 l_TERR_BOUQ.SBT_IE_FLAG,
--                 NULL,
--                 NULL,
--                 NULL,
--                 NULL,
--                 NULL,
--                 NULL,
--                 NULL,
--                 NULL,
--                 0,
--                 i_entry_oper,
--                 SYSDATE,
--                 NULL,
--                 NULL
--            );
--
--            INSERT INTO X_CP_PLT_SUBBOUQ_MAPP_TEMP
--            (
--                CPST_ID,
--                CPST_PLT_ID,
--                CPST_PTB_ID,
--                CPST_SUBBOUQUET_ID,
--                CPST_SUBBOUQUET_RIGHTS,
--                CPST_UPDATE_COUNT,
--                CPST_ENTRY_OPER,
--                CPST_ENTRY_DATE
--            )
--            (SELECT X_SEQ_SUB_BOUQ_TEMP_ID.NEXTVAL,
--                    I.pltt_id,
--                    L_TERR_COUQ_SEQ,
--                    CB_ID,
--                    'Y',
--                    0,
--                    I_ENTRY_OPER,
--                    SYSDATE
--              FROM
--              (
--                  SELECT DISTINCT
--                          BOUQ.CB_ID CB_ID,
--                          CB_NAME,
--                          STM_TER_CODE
--                   FROM
--                        X_SAT_BOUQUET_MAPP,
--                        X_SATELLITE_TERR_MAPP,
--                        X_CP_BOUQUET BOUQ,
--                        X_CP_BOUQUET_MS_MAPP,
--                        (SELECT CB_ID
--                         FROM X_CP_BOUQUET,
--                              X_CP_BOUQUET_MS_MAPP
--                         WHERE CMM_BOUQ_ID = CB_ID
--                               AND CB_AD_FLAG = 'A'
--                               AND CB_BOUQ_PARENT_ID = L_TERR_BOUQ.BOUQ_ID
--                               AND CMM_BOUQ_MS_CODE = L_LIC_MS_NAME
--                               AND CMM_BOUQ_MS_RIGHTS = 'Y'
--                         )PRM_SUB_BOUQ
--                    WHERE
--                         SBM_STM_ID = STM_ID
--                         AND CMM_BOUQ_ID = BOUQ.CB_ID
--                         AND PRM_SUB_BOUQ.CB_ID = BOUQ.CB_ID
--                         AND (CMM_BOUQ_MS_CODE,STM_REG_CODE) IN(SELECT LEE_MEDIA_SERVICE_CODE,reg_code
--                                                                FROM FID_LICENSEE,
--                                                                     FID_LICENSE,
--                                                                     FID_REGION
--                                                                WHERE LEE_NUMBER =LIC_LEE_NUMBER
--                                                                      AND REG_id =LEE_SPLIT_REGION
--                                                                      AND LIC_NUMBER =i_lic_number)
--                         AND SBM_BOUQUET_ID = BOUQ.CB_ID
--                         AND CB_AD_FLAG = 'A'
--                         AND CB_BOUQ_PARENT_ID IS NOT NULL
--                         AND STM_TER_CODE =L_TERR_BOUQ.SBT_TER_CODE
--                )
--              );
--
              FOR TERR IN
              (
                  SELECT ptbt_id FROM X_cp_plt_terr_bouq_temp where ptbt_plt_id = i.pltt_id
              )
              LOOP
                  UPDATE x_cp_plt_terr_bouq_temp
                  SET PTBT_PLT_DEV_RIGHTS = 'N',
                      PTBT_OTT_START_DATE = null,
                      PTBT_OTT_END_DATE = null,
                      PTBT_PVR_START_DATE = null,
                      PTBT_PVR_END_DATE = null,
                      PTBT_SCH_OTT_FROM_TIME = null,
                      PTBT_SCH_OTT_END_TIME = null,
                      PTBT_SCH_PVR_FROM_TIME = null,
                      PTBT_SCH_PVR_END_TIME = null

                  WHERE ptbt_id = terr.ptbt_id;

                  INSERT INTO X_CP_PLT_DEVCOMP_RIGHTS_TEMP
                  (
                      CDCR_ID,
                      CDCR_PTBT_ID,
                      CDCR_DEV_ID,
                      CDCR_COMP_ID,
                      CDCR_COMP_RIGHTS
                   )
                   SELECT x_seq_DEV_COMP_id.NEXTVAL,
                          TERR.ptbt_id, --chnaged
                          I.pltt_dev_id,
                          MSC_MS_MDC_ID,
                          X_PKG_CP_SCH_GRID.X_GET_COMP_RIGHTS_FOR_DEV(i_lic_number,I.pltt_dev_id,MSC_MS_MDC_ID)
                   FROM X_CP_MEDIA_SERVICE_COMPAT
                   WHERE MSC_MS_CODE = 'CATCHUP'
                         AND MSC_MS_IS_COMPAT_FLAG = 'Y';
               END LOOP;
       -- END LOOP;
    END LOOP;
    commit;
    Exception when others then
    rollback;
END x_prc_clr_temp_table_data;

--CU4ALL : END
END X_PKG_CP_SCH_GRID;
/
