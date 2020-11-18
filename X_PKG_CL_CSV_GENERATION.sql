CREATE OR REPLACE PACKAGE X_PKG_CL_CSV_GENERATION
AS
	/****************************************************************
	Release    : Clearleap Interface Integration Release
	Created On : 01-Apr-2015
	Purpose    : For Error/Warning Screen on Schedule Grid and
	   generation of .CSV file.
	****************************************************************/
	TYPE x_cl_ref_cursor IS REF CURSOR;
	TYPE SIMPLEARRAY is table of varchar2(100);
	type x_typ_sch_release_rec is table of varchar2(32767) INDEX by pls_integer;

	TYPE            x_typ_cl_release_rec IS RECORD
	(
	  tcr_Bin_Id            Number
	  ,Tcr_Tap_Uid_Lang      Varchar2(20)
	  ,tcr_process_priority  number
	);

	Type            x_typ_cl_release_tbl is Table Of x_typ_cl_release_rec;


	/* To return two Cursors for Error/Warning Screen*/
	PROCEDURE x_prc_csv_warnings
	(	i_sch_plan_month     	IN	DATE,
		i_sch_entry_opr      	IN	X_CL_GTT_RELEASE_SCHEDULE.GRS_ENTRY_OPER%type,
		i_release_flag      IN  VARCHAR2 := 'W',
		o_sch_warnings       	OUT	X_PKG_CL_CSV_GENERATION.X_CL_REF_CURSOR,
		o_sch_warning_excel	OUT	X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
	);

	PROCEDURE X_PRC_SEARCH_REL_SCHEDULE
	(	i_sch_plan_month     IN		DATE
		,i_sch_entry_opr      in		X_CL_GTT_REL_SCH_DETAIL.GRD_ENTRY_OPER%type
		,i_screen_flag        in		VARCHAR2
		,o_schedule_data      OUT	X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
	);

	/* To release schedule for a given Month from either Schedule Grid or Error/Warning Screen*/
	PROCEDURE x_prc_release_schedule
	(	i_release_data			IN      x_typ_sch_release_rec
		,i_sch_entry_opr		IN		X_CL_GTT_REL_SCH_DETAIL.GRD_ENTRY_OPER%type
		,i_session_id			IN		x_cl_release_schedule.crs_session_id%type
		,i_plan_month			IN		x_cl_temp_release_schedule.trs_sch_plan_month%type
    ,i_release_flag       IN    VARCHAR2 DEFAULT 'W'
		--,o_schedule_rel_data	OUT		X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
		--,o_ftpdetails			OUT		X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
	);
	PROCEDURE x_prc_default_uid(o_status OUT NUMBER);
	/*To check whether the given title is a Series or not*/
	FUNCTION X_FNC_PROG_IS_SER(I_GEN_REFNO fid_general.gen_refno%type) RETURN VARCHAR2;

	/* To check whether the file is generated and sent to FTP Location Successfully or not,
     also to take necessary backup when failed*/
  PROCEDURE x_prc_after_release_success
        (i_Success_Flag IN varchar2,
			i_Schedule_Plan_Month IN  DATE,
			i_Auto_Release_Flag  IN  VARCHAR2
			,i_error_message IN varchar2
       ,i_language IN x_cl_release_schedule.CRS_TAP_UID_LANG%type
      ,i_bin_id  IN x_cl_release_schedule.CRS_BIN_ID%type
      ,i_session_id in x_cl_release_schedule.CRS_SESSION_ID%type
        );
 /* For Auto Release Functionality*/
/*procedure x_prc_auto_release(o_schedule_data     OUT X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor,
                             --o_sch_warnings      OUT X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor,
                             --o_sch_warning_excel OUT X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor,
                             o_ftpdetails        OUT X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor);*/

	/*To get the list of mail IDs*/
	FUNCTION x_get_email_ids
	(
		list_in IN VARCHAR2,
		delimiter_in VARCHAR2
	)
	RETURN simplearray;

	/*For sending E-Mails to intended recipients on success or failure of the CSV generation*/
	PROCEDURE x_clearleap_email_csv_release (i_action  IN VARCHAR2,i_Schedule_Plan_Month IN  DATE,i_Success_Flag IN varchar2,i_error_message IN varchar2);
	FUNCTION X_fun_Teritory_Code
	(
	  I_Bin_Id  in  Number
	  ,I_Bin_Lic_Number in Number
	  ,i_Bin_Reg_Code  in number
	  ,i_langu_id in number
	  ,i_query_flag in number
	)
	Return Varchar2;
	FUNCTION X_fun_secondary_genre
	(
		i_gen_refno  in  NUMBER
		,i_ser_number in  NUMBER
		,i_series_flag in varchar2
		,i_lang_id  in number
	)
	Return Varchar2;

PROCEDURE x_prc_ixs_release_schedule
	(
    i_release_type    IN    varchar2,
     o_bin_data				OUT		X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
		,o_playlist_data		OUT		X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
	);

  FUNCTION X_fun_get_bouquet(I_Bin_Id  in  Number
                            ,I_Bin_Lic_Number in Number)
  Return Varchar2;
PROCEDURE X_PRC_SAVE_RELEASE_LATER
 (
  I_BIN_ID in X_CL_GTT_REL_SCH_DETAIL.GRD_BIN_ID%type,
  I_LANGUAGE IN x_cl_release_schedule.CRS_TAP_UID_LANG%type,
  I_SCH_PLAN_MONTH  IN  DATE,
  I_USER_NAME in X_CL_GTT_REL_SCH_DETAIL.GRD_ENTRY_OPER%type,
  O_RESULT OUT NUMBER
 );
END X_PKG_CL_CSV_GENERATION;
/


CREATE OR REPLACE PACKAGE BODY X_PKG_CL_CSV_GENERATION AS
	/****************************************************************
	Release    : Clearleap Interface Integration Release
  Created On : 01-Apr-2015
  Purpose    : For Error/Warning Screen on Schedule Grid and
               generation of .CSV file.
	****************************************************************/
  /* To return two Cursors for Error/Warning Screen*/
	PROCEDURE x_prc_csv_warnings
	(	i_sch_plan_month     	IN	DATE,
		i_sch_entry_opr      	IN	X_CL_GTT_RELEASE_SCHEDULE.GRS_ENTRY_OPER%type,
		i_release_flag      IN  VARCHAR2 := 'W',
		o_sch_warnings       	OUT	X_PKG_CL_CSV_GENERATION.X_CL_REF_CURSOR,
		o_sch_warning_excel	OUT	X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
	)
	AS
		l_plan_month	NUMBER;
		l_sqlstmnt	VARCHAR2(25000);
		l_string	VARCHAR2(5000);
		l_sqlinst_temp  VARCHAR2(25000);
		l_str_war_cur	VARCHAR2(5000);
		l_str_war_column VARCHAR2(25000);
    l_go_live_date X_FIN_CONFIGS.CONTENT%type;
	BEGIN
  /*Clear Global Temperrory Table (GTT) and Temp table*/
		delete from x_cl_gtt_release_schedule;
		delete from x_cl_sch_bin_temp;
    --dbms_output.disable;
		l_plan_month := to_number(to_char(i_sch_plan_month, 'RRRRMM'));
    select to_date(to_char(to_date("CONTENT"),'yyyyMMdd'),'yyyyMMdd')
    INTO l_go_live_date
    from X_FIN_CONFIGS
    WHERE "KEY" = 'CU4ALL_LIVE_DATE';

    /*update x_cl_csv_warning_config
    set cwc_condition ='CASE WHEN grs_bouquet_codes IS NULL and '''||l_go_live_date ||''' > '''||i_sch_plan_month||'''
    THEN ''M'' ELSE ''Y'' END'
    where cwc_column_name = 'GRS_BOUQUET_CODES'
    ;*/
    /*Fetch Schedule Bin Data for the month in a temp table*/

    /*Fetch Schedule Bin Data for the month in a temp table*/
    l_sqlinst_temp :=
             'INSERT INTO x_cl_sch_bin_temp
            ( bin_id
              ,bin_reg_code
              ,bin_media_service
              ,bin_lic_number
              ,bin_view_start_date
              ,bin_view_end_date
              ,bin_sch_number
              ,bin_sch_from_time
              ,bin_sch_end_time
              ,bin_is_schedule_flag
              ,bin_update_count
              ,bin_created_by
              ,bin_created_on
              ,bin_modified_by
              ,bin_modified_on
              ,bin_is_bin_arch
              ,bin_sch_without_lin_ref
              ,on_schedule_grid
              ,bin_sch_cha_number
              ,bin_sch_date
              ,bin_linear_sch_time
              ,bin_plt_min_start_date
            )
            SELECT  bin_id
              ,bin_reg_code
              ,''CATCHUP''  media_service
              ,bin_lic_number
              ,bin_view_start_date
              ,bin_view_end_date
              ,bin_sch_number
              ,bin_sch_from_time
              ,bin_sch_end_time
              ,bin_is_schedule_flag
              ,bin_update_count
              ,bin_created_by
              ,bin_created_on
              ,bin_modified_by
              ,bin_modified_on
              ,bin_is_bin_arch
              ,bin_sch_without_lin_ref
              ,on_schedule_grid
              ,bin_sch_cha_number
              ,bin_sch_date
              ,bin_linear_sch_time
              ,MIN(to_date(to_char(plt_sch_start_date,''DD-MON-RRRR'')||'' ''||plt_sch_from_time,''DD-MON-RRRR SSSSS'')
            ) min_date
            FROM  X_CP_SCHEDULE_BIN S
              ,X_CP_PLAY_LIST l';
       IF (l_go_live_date <= i_sch_plan_month/*sysdate*/)
       THEN
           l_sqlinst_temp :=l_sqlinst_temp||'
              ,X_CP_PLT_TERR_BOUQ B';
       end if;
       l_sqlinst_temp :=l_sqlinst_temp||'
            WHERE BIN_ID = PLT_BIN_ID';
       IF (l_go_live_date <= i_sch_plan_month/*sysdate*/)
       THEN
            l_sqlinst_temp :=l_sqlinst_temp||'
            AND   PTB_PLT_ID = PLT_ID';
       end if;
       if i_release_flag = 'W'
       then
          l_sqlinst_temp :=l_sqlinst_temp||'
            AND  exists ( select 1
                    from fid_license
                      ,fid_licensee
                      ,x_user_service_map
                    where lic_lee_number = lee_number
                    and lee_media_service_code =  x_usm_media_service_code
                    and lic_number = bin_lic_number
                    and upper(x_usm_user_id) = upper('''||i_sch_entry_opr||''')
                  )';
        end if;
        l_sqlinst_temp :=l_sqlinst_temp||'
            AND NVL(L.PLT_LICENSE_FLAG,''Y'') IN (
                                                SELECT s1.ms_media_service_flag
                                                  FROM SGY_PB_MEDIA_SERVICE S1
                                                 WHERE S1.MS_MEDIA_SERVICE_PARENT = ''CATCHUP''
                                                )--ver 1.0 aded in cond to consider all catchup licenses /*Need to add this condition to filter out SVOD Related data*/
            GROUP BY  bin_id
                ,bin_reg_code
                ,bin_lic_number
                ,bin_view_start_date
                ,bin_view_end_date
                ,bin_sch_number
                ,bin_sch_from_time
                ,bin_sch_end_time
                ,bin_is_schedule_flag
                ,bin_update_count
                ,bin_created_by
                ,bin_created_on
                ,bin_modified_by
                ,bin_modified_on
                ,bin_is_bin_arch
                ,bin_sch_without_lin_ref
                ,on_schedule_grid
                ,bin_sch_cha_number
                ,bin_sch_date
                ,bin_linear_sch_time
            HAVING (to_char(MIN(plt_sch_start_date),''RRRRMM'') = '|| l_plan_month||'
		AND to_char(Max(PLT_SCH_END_DATE),''RRRRMMDD'') >= to_char(sysdate,''RRRRMMDD'')
		) ';

    execute immediate  l_sqlinst_temp ;

/*Insert Schedule data into GTT */
		L_SQLSTMNT := 'insert into X_CL_GTT_RELEASE_SCHEDULE
          (GRS_ID
          ,GRS_BIN_ID
          ,GRS_LIC_NUMBER
          ,GRS_SERVICE_CODE
          ,GRS_VOD_TYPE
          ,GRS_SCH_PLAN_MONTH
          ,GRS_SCH_CREATED
          ,GRS_CRUD
          ,GRS_GEN_REFNO
          ,GRS_TAP_BARCODE
          ,GRS_REGION_CODE
          ,GRS_COUNTRIES
          ,GRS_SER_TITLE
          ,GRS_GEN_TITLE
          ,GRS_SEASON_NUMBER
          ,GRS_EPI_NUMBER
          ,GRS_MPAA_RATING
          ,GRS_LIN_CHA
          ,GRS_HD_SD_TITLE
          ,GRS_TITLE_SYNOPSIS
          ,GRS_SHOW_TYPE
          ,GRS_THEME
          ,GRS_GEN_CATEGORY
          ,GRS_SUB_GENRE
          ,GRS_ACTORS
          ,GRS_DIRECTOR
          ,GRS_SER_NUMBER
          ,GRS_SER_SYNOPSIS
          ,GRS_SEA_NUMBER
          ,GRS_SEA_SYNOPSIS
          ,GRS_EPI_COUNT
          ,GRS_ADVISORIES
          ,GRS_ORIG_COUNTRY
          ,GRS_RELEASE_YEAR
          ,GRS_COM_SHORT_NAME
          ,GRS_COM_NAME
          ,GRS_LIN_SCH_DATE
          ,GRS_TAP_UID_AUDIO
          ,GRS_TAP_UID_VERSION
          ,GRS_TAP_ASPECT_RATIO
          ,GRS_TAP_UID_LANG
          ,GRS_GEN_DURATION_C
          ,GRS_CURR_FLAG
          ,GRS_ENTRY_OPER
          ,GRS_ENTRY_DATE
          ,GRS_ERROR_TYPE
          ,GRS_IS_SERIES_FLAG
          ,GRS_L_RATING
          --Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/05]
          ,GRS_BOUQUET_CODES
          --Dev.R14 : Catchup 4 All Intrim : End
		  ,Grs_Gen_Catchup_Priority
		  ,Grs_Gen_Catchup_Category
      ,GRS_EXPRESS
          )
			select rownum l_row_id,
					bin_id,
					bin_lic_number,
					service,
					vod_type,
					sch_plan_mon,
					sch_created,
					crud,
					gen_refno,
					tap_barcode,
					Region,
					sbt_ter_code,
					nvl(sead.SER_SVD_SER_TITLE,stack.MS_NAME ) ser_title,
					nvl(pvd.pvd_gen_title,a.gen_title) gen_title,
					sead.season_number sea_number,
					nvl(epi_number,a.GEN_MS_STACK_SRNO) epi_number,
					(case
					When l_rating In (''E13'',''E16'',''EFAM'',''EPG'',''EPG13'') Then
					 ''16''
					When l_rating In (''E18'',''ER18'') Then
					''18''
					when l_rating = ''PG'' or l_rating = ''FAM'' then
					l_rating
					when not REGEXP_LIKE(l_rating, ''[[:digit:]]'')
					then
					null --REGEXP_SUBSTR(gen_rating_mpaa, ''[A-Z]+'', 1,1)
					when  lower(substr(l_rating,1,1))=upper(substr(l_rating,1,1))
					then
					REGEXP_SUBSTR(l_rating, ''[0-9]+'', 1)
					when lower(substr(l_rating,1,1))!=upper(substr(l_rating,1,1))
					then
					REGEXP_SUBSTR(l_rating, ''[A-Z]+[0-9]+'', 1,1)
					end )PG_rating,
					channel,
					pvd_pvr_title hd_sd_title,
					replace(replace(pvd_title_synopsis,chr(10),null),chr(13),null) title_synopsis,
					decode(is_series_flag,''Y'',sead.SER_show_type,pvd_show_type) show_type,
					decode(is_series_flag,''Y'',sead.ser_themes,pvd_themes) themes,
					decode(is_series_flag,''Y'',sead.ser_primary_genre,pvd_primary_genre) primary_genre,
					X_PKG_CL_CSV_GENERATION.X_fun_secondary_genre(a.GEN_REFNO,sead.ser_number ,is_series_flag ,a.lang_id)	secondary_genre	,
					pvd.pvd_actors actors,
					pvd.pvd_directors directors,
					sead.ser_number ser_id,
					replace(replace(sead.ser_svd_synopsis ,chr(10),null),chr(13),null) ser_synopsis,
					nvl(sead.sea_number,stack.MS_ID) sea_id,
					replace(replace(sead.sea_svd_synopsis  ,chr(10),null),chr(13),null) sea_synopsis,
					(	select count(1)
						from fid_general x
						where x.gen_ser_number = sead.SEA_NUMBER
					) epi_count,
					(case
						when l_rating = ''PG'' or l_rating = ''FAM'' then
						null
						when not REGEXP_LIKE(l_rating, ''[[:digit:]]'')
						then
						null -- REGEXP_SUBSTR(gen_rating_mpaa, ''[A-Z]+'', 1,1)
						when  lower(substr(l_rating,1,1))=upper(substr(l_rating,1,1))
						then
						REGEXP_SUBSTR(l_rating, ''[A-Z]+'', 1)
						when lower(substr(l_rating,1,1))!=upper(substr(l_rating,1,1))
						then
						REGEXP_SUBSTR(l_rating, ''[A-Z]+'', 1,2)
					end
					) advisory,
					con_of_origin,
					gen_release_year,
					studio_code,
					studio_name,
					linearStartdateTime,
					tap_uid_audio,
					tap_uid_version,
					tap_aspect_ratio,
					language,
					runtime_mins,
					''C'' curr_flag,
					'''||i_sch_entry_opr||''' entry_opr,
					'''||SYSDATE||''' entry_date,
					''Y'' warning_flag,
					is_series_flag,
					l_rating,
          --Added by swapnil malvi for CU4ALL
          (CASE WHEN
             (select to_number(to_char(to_date(CONTENT),''RRRRMM'')) from x_fin_configs where KEY =''CU4ALL_LIVE_DATE'')
               <= to_number(to_char(sch_created,''RRRRMM''))
           THEN
               (select concat_column(distinct cb_short_code)
                from x_cp_bouquet,
                     X_CP_PLT_TERR_BOUQ,
                     x_cp_play_list
                where plt_id = ptb_plt_id
                     and PTB_BOUQUET_ID = cb_id
                     and plt_bin_id=a.bin_id
                     and PLT_LIC_NUMBER=a.bin_lic_number
                     --group by (plt_id,plt_dev_id)
                     )
             else
               (select concat_column(cb_short_code)
               from x_cp_lic_bouquet_rights,x_cp_bouquet
               where lbr_lic_number = a.bin_lic_number
                     AND lbr_bin_id = a.bin_id
                     AND lbr_bqt_rights = ''Y''
                     and lbr_bqt_id = cb_id
		     and CB_BOUQ_PARENT_ID is null
                    and nvl(CB_AD_FLAG,''D'')=''A'')
               end),
          --Added by swapnil malvi for CU4ALL end
					gen_catchup_priority,
					gen_catchup_category,
          gen_express
			from	x_prog_vod_details pvd,
					x_vw_series_vod_dtl sead,
          X_CP_MOVIE_STACK stack,
					(select bin_id,
						decode(nvl(tap_uid_lang_id, 1),0,1,nvl(tap_uid_lang_id, 1)) lang_id,
						(select uid_lang_desc
						from x_uid_language
						where uid_lang_id = decode(nvl(tap_uid_lang_id,1),0,1,nvl(tap_uid_lang_id,1))
						) language,
						bin_lic_number,
						''Catch Up'' Service,
						''SVOD'' VOD_type,
						'||l_plan_month||' sch_plan_mon,
						bin_plt_min_start_date sch_created,
						nvl((	select nvl(CHA_VOD_SHORT_NAME,CHA_SHORT_NAME)
							from fid_channel
							where cha_number = sch.sch_cha_number
							),
							(	select vch_short_name
								from x_vod_channel
								where vch_number = BIN_SCH_CHA_NUMBER)
						) channel,
						to_char(nvl(sch.sch_date, BIN_SCH_DATE), ''DD-MM-YYYY'') || '' '' ||CONVERT_TIME_N_C(nvl(sch.sch_time,BIN_LINEAR_SCH_TIME)) linearStartdateTime,
						null CRUD,
						gen_refno,
						gen_title,
						gen_catchup_priority,
						gen_catchup_category,
						tap_barcode,
						(	select lee_short_name
							from fid_licensee
							where lee_number=lic_lee_number
						) region,
						X_PKG_CL_CSV_GENERATION.X_fun_Teritory_Code(bin_id,bin_lic_number,BIN_REG_CODE,nvl(t.tap_uid_lang_id,1),1) sbt_ter_code,
						/*RDT : End : [Terr_Satellite_mapp]_[Swapnali Belose]_[15/07/2015]*/
						gen_ser_number,
						gen_epi_number epi_number,
						decode((select lee_short_name
								from fid_licensee
								where lee_number=lic_lee_number),
								''CRSA'',nvl(gen_rating_mpaa,gen_rating_int)
								--Added by jawahar for 3rd Party Cp [02-jul-2015]
								,''TRSA'',nvl(gen_rating_mpaa,gen_rating_int)
								,''TAFR'',nvl(gen_rating_mpaa,gen_rating_int)
                						,''T36A'',nvl(gen_rating_mpaa,gen_rating_int)
								,''CAFR'',nvl(gen_rating_int,gen_rating_mpaa)
						) l_rating,
						(SELECT T.TER_ISO_CODE FROM FID_TERRITORY T WHERE T.TER_CODE = com_ter_code) con_of_origin,
						gen_release_year,
						C.COM_SHORT_NAME studio_code,
						C.COM_NAME studio_name,
						tap_uid_audio,
						tap_uid_version,
						tap_aspect_ratio,
						--decode(nvl(t.tap_uid_lang_id,1),0,1,nvl(t.tap_uid_lang_id,1)) tap_uid_lang_id,
						gen_duration_c runtime_mins,
						nvl((	SELECT cod_attr1
							FROM fid_code WHERE cod_type = ''GEN_TYPE''
							AND cod_value != ''HEADER''
							AND UPPER(cod_value) = UPPER(gen_type)
						),''N'') is_series_flag,
            gen_express,
            nvl(gen_ms_id,0) gen_ms_id,
            GEN_MS_STACK_SRNO
					FROM	x_cl_sch_bin_temp sb,
						fid_general       g,
						fid_license       l,
						fid_company       c,
						fid_contract      con,
						fid_tape          t,
						x_cp_sch_bin_uid  sbu,
						fid_schedule      sch
					WHERE	bin_lic_number = lic_number
					AND	lic_gen_refno = gen_refno
					AND	con_com_number = com_number
					AND	lic_con_number = con_number
					AND	bin_sch_number = sch_number(+)
					AND	bin_id = sbu_bin_id(+)
					AND	sbu_tap_barcode = tap_barcode(+)
					and	to_number(to_char(bin_plt_min_start_date /*bin_sch_date*/, ''RRRRMM'')) ='||l_plan_month||'/*need to confirm*/
				) a
			WHERE a.gen_refno       = pvd.pvd_gen_refno(+)
			AND a.lang_id = pvd.pvd_uid_lang_id(+)
			AND a.gen_ser_number  = sead.sea_number(+)
			AND a.lang_id = sead.ser_svd_uid_lang_id(+)
      AND a.gen_ms_id = stack.ms_id(+)
      ';
		--DBMS_OUTPUT.put_line(L_SQLSTMNT);
		execute immediate  L_SQLSTMNT ;
	if i_release_flag ='A'
    then
           delete from X_CL_GTT_RELEASE_SCHEDULE
           where not exists ( select 1
                             from X_CL_RELEASE_LATER R
                             where   CRL_BIN_ID = grs_bin_id
                             and   crl_language = GRS_TAP_UID_LANG
                             AND   CRL_SCH_PLAN_MONTH  = l_plan_month
                             and to_char(crl_entry_date,'RRRRMMDD') = to_char(sysdate,'RRRRMMDD')
                              and nvl(CRL_PROCESS_FLAG,'N')='N'
                            );
    else
        delete from X_CL_GTT_RELEASE_SCHEDULE
           where exists ( select 1
                             from X_CL_RELEASE_LATER R
                             where   CRL_BIN_ID = grs_bin_id
                             and   crl_language = GRS_TAP_UID_LANG
                              AND   CRL_SCH_PLAN_MONTH  = l_plan_month
                              and to_char(crl_entry_date,'RRRRMMDD') = to_char(sysdate,'RRRRMMDD')
                              and nvl(CRL_PROCESS_FLAG,'N')='N'
                            );
    end if;

/*Update GTT Error type with correct flag whether it is Mandetory(M),Optional(O) or Not blank(N)*/
		begin
			l_str_war_column := 'Merge Into X_Cl_Gtt_Release_Schedule A
								Using (  Select grs_bin_id,TAP_LANGUAGE
										,replace(replace(''#''||(Case When Countries In (''O'') Then '', Countries'' Else Null End)
										||(Case When Runtime_Mins In (''O'') Then '', Runtime Mins'' Else Null End)
										||(Case When Aspect_Ratio In (''O'') Then '', Aspect Ratio'' Else Null End)
										||(Case When Series_Title In (''O'') Then '', Series Title'' Else Null End)
										||(Case When Title In (''O'') Then '', Title'' Else Null End)
										||(Case When Linear_Channel In (''O'') Then '', Linear Channel'' Else Null End)
										||(Case When Hd_Sd_Pvr In (''O'') Then '', HD_SD_PVR'' Else Null End)
										||(Case When Title_Synopsis In (''O'') Then '', Title Synopsis'' Else Null End)
										||(Case When Show_Type In (''O'') Then '', Show Type'' Else Null End)
										||(Case When Theme In (''O'') Then '', Theme'' Else Null End)
										||(Case When Primary_Genre In (''O'') Then '', Primary Genre'' Else Null End)
										||(Case When Actors In (''O'') Then '', Actors'' Else Null End)
										||(Case When DIRECTOR In (''O'') Then '', Director'' Else Null End)
										||(Case When Series_Synopsis In (''O'') Then '', Series Synopsis'' Else Null End)
										||(Case When Season_Synopsis In (''O'') Then '', Season Synopsis'' Else Null End)
										||(Case When Supplier_Country In (''O'') Then '', Supplier Country'' Else Null End)
										||(Case When Year_Of_Release In (''O'') Then '', Year Of Release'' Else Null End)
										||(Case When Studio_Code In (''O'') Then '', Studio Code'' Else Null End)
										||(Case When STUDIO_NAME In (''O'') Then '', Studio Name'' Else Null End)
										||(Case When Linear_Start_Date In (''O'') Then '', Linear Start Date'' Else Null End)
										||(Case When Audio_Type In (''O'') Then '', Audio Type'' Else Null End)
										||(Case When Format In (''O'') Then '', Format'' Else Null End)
										||(Case When Pg_Rating In (''O'') Then '', Pg Rating'' Else Null End)
										||(Case When Uids In (''O'') Then '' , UIDS'' Else Null End)
										||(Case When Advisories In (''O'') Then '', Advisories'' Else Null End)
										||(Case When Secondary_Genre In (''O'') Then '', Secondary Genre'' Else Null End)
										||(Case When Bouquet In (''O'') Then '', Bouquet'' Else Null End),''#,''),''#'') Warnings_Items
									From ( ';
/*Query for Warning Screen Cursor*/
			l_str_war_cur := 'select GEN_REFNO ,GEN_TITLE ,GRS_TAP_UID_LANG  TAP_LANGUAGE, GRS_REGION_CODE REGION ,grs_bin_id';
/*Update statement for GTT Error Type, If Mandetory field is blank then its an Error,
  if Optional is blank then its a warning*/
			l_string := '	update X_CL_GTT_RELEASE_SCHEDULE b
					set b.grs_error_type =	(select (case when instr(col,''M'') > 0 then ''M'' when instr(col,''O'') > 0 then ''O'' else ''Y'' end)
								from 	(select  grs_bin_id ,GRS_TAP_UID_LANG ,grs_id ,'||''' ''';

			for i in
			(	select  t.cwc_condition str,'('||t.cwc_condition||')'||CWC_COL_ALIAS str1
				from x_cl_csv_warning_config t
			)/*x_cl_csv_warning_config table contains validations for Mandetory and optional fields*/
			loop
				l_str_war_cur := l_str_war_cur||'
						,'||i.str1;
				l_string := l_string||'
						||('||i.str||')';

			end loop;
			l_string := l_string||' col
				from X_CL_GTT_RELEASE_SCHEDULE ,FID_GENERAL
				WHERE   GEN_REFNO = GRS_GEN_REFNO
				) a
				where a.grs_id = b.grs_id
				)';

			l_str_war_cur := l_str_war_cur||'
				FROM   X_CL_GTT_RELEASE_SCHEDULE
				,FID_GENERAL
				WHERE   GEN_REFNO = GRS_GEN_REFNO
				AND grs_error_type in (''O'',''M'')
				';
			--DBMS_OUTPUT.put_line('l_string '||l_string);
			execute immediate l_string;

		   delete from x_cl_release_count;
		end;

		l_str_war_column := l_str_war_column ||l_str_war_cur;

		l_str_war_column := l_str_war_column ||'
								)
									) B
								on  (  A.Grs_Bin_Id = B.Grs_Bin_Id
									  And  A.Grs_Tap_Uid_Lang = B.TAP_LANGUAGE
									)
								When Matched Then Update
								Set A.Grs_Warnings = B.Warnings_Items
								where a.Grs_Error_Type In (''O'') ';

		--DBMS_OUTPUT.put_line('l_str_war_cur '||l_str_war_cur);
		execute immediate l_str_war_column;
    /*Out Cursor for Error/Warning Screen*/
		open o_sch_warnings for l_str_war_cur;

    /*Out Cursor for Export to Excel*/
		open o_sch_warning_excel  for
		select grs_gen_refno        gen_refno,
		gen_title           gen_title,
		grs_gen_title        title,
		grs_tap_barcode      uids,
		grs_region_code      region,
		grs_countries        countries,
		grs_ser_title        series_title,
		grs_mpaa_rating      pg_rating,
		grs_lin_cha          linear_channel,
		grs_hd_sd_title      hd_sd_pvr,
		grs_title_synopsis   title_synopsis,
		grs_show_type        show_type,
		grs_theme            theme,
		grs_gen_category     primary_genre,
		grs_sub_genre        secondary_genre,
		grs_actors           actors,
		grs_director         director,
		grs_ser_synopsis     series_synopsis,
		grs_sea_synopsis     season_synopsis,
		grs_advisories       advisories,
		grs_orig_country     supplier_country,
		grs_release_year     year_of_release,
		grs_com_short_name   studio_code,
		grs_com_name         studio_name,
		grs_lin_sch_date     linear_start_date,
		grs_tap_uid_audio    audio_type,
		grs_tap_uid_version  format,
		grs_tap_aspect_ratio aspect_ratio,
		grs_tap_uid_lang     tap_language,
		grs_gen_duration_c   runtime_mins,
                --Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/05]
                grs_bouquet_codes    bouquet
		--Dev.R14 : Catchup 4 All Intrim : End
    from x_cl_gtt_release_schedule
		,fid_general
		where gen_refno = grs_gen_refno
		AND grs_error_type in ('O','M');
		commit;
	end x_prc_csv_warnings;

  /* To release schedule for a given Month from either Schedule Grid or Error/Warning Screen*/
	PROCEDURE X_PRC_SEARCH_REL_SCHEDULE
	(	i_sch_plan_month     IN		DATE
		,i_sch_entry_opr      in		X_CL_GTT_REL_SCH_DETAIL.GRD_ENTRY_OPER%type
		,i_screen_flag        in		VARCHAR2
		,o_schedule_data      OUT	X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
	)
	AS
		l_warnings_cnt  NUMBER;
		l_error_cnt    NUMBER;
		l_is_super_user  NUMBER;
		l_release_cnt	NUMBER;
		l_valid_month_cnt NUMBER;
		l_str_table_script varchar2(32767);
		l_str_column_name varchar2(32767);
		l_dynamic_query varchar2(32767);
		l_plan_month	NUMBER;
		l_session varchar2(25);
		l_backup_cnt NUMBER;
		l_open_month date;
		l_temp_rel_sch_cnt NUMBER;
    --IXS START - Sagar Sonawane 31-Jan-2016
    l_go_live_date X_FIN_CONFIGS.CONTENT%type;
    --IXS END
		o_sch_warnings      X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor;
		o_sch_warning_excel X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor;
    l_sqlstmnt	VARCHAR2(25000);

    TYPE REC_Trd_Bin_Id IS TABLE OF X_CL_TEMP_REL_SCH_DETAIL.Trd_Bin_Id%TYPE INDEX BY PLS_INTEGER;
    L_Trd_Bin_Id REC_Trd_Bin_Id;
	BEGIN

		l_plan_month := to_number(to_char(i_sch_plan_month, 'RRRRMM'));

		l_session:= to_char(sysdate, 'YYYYMMDDHH24MISS');
		begin
			Select Min(To_Date(Fim_Year||Lpad(Fim_Month,2,0),'RRRRMM'))
			into l_open_month
			From Fid_Financial_Month
			Where Fim_Status ='O'
			;
		exception
		when others
		then
				l_open_month := sysdate;
		end;
/*Code to check the month is within allowed range or not*/
		select count(1)
		into l_valid_month_cnt
		from dual
		where to_char(i_sch_plan_month,'YYYYMM') between to_char(l_open_month,'YYYYMM') and to_char(add_months(l_open_month,2),'YYYYMM')
		;
	/*if l_valid_month_cnt = 0
		then
		raise_application_error(-20100, 'Cannot release the schedule for months other than current month and next two months.');
		end if;
    */
    /*Clear GTT*/
    /*delect records from X_CL_GTT_REL_SCH_DETAIL i.e. clear this global temporary table*/
		DELETE FROM X_CL_GTT_REL_SCH_DETAIL;
    DELETE FROM X_CL_GTT_TERR_BOUQ_DTL;

/*Code to check whether the user is normal User or Super User*/
		if upper(i_sch_entry_opr)='SYSADMIN'
		THEN
			l_is_super_user:=0;
		ELSE
			SELECT DECODE(count(1),0,0,1) INTO l_is_super_user
			FROM ora_aspnet_roles A,ora_aspnet_usersinroles b,ora_aspnet_users  c
			WHERE A.roleid = b.roleid
			AND c.userid = b.userid
			AND upper(username) LIKE upper('%'||i_sch_entry_opr||'%')
			and b.roleid in('AD38C7A90E024F838ABD7416DF02938F','A071C4FF1FD84E52B3C0829790CE430F'); -- M-Net Operations manager

			l_is_super_user:=0;
		END IF;

    /*invoke warnings procedure X_PRC_CSV_WARNINGS -> this procedure will check for optional and mandatory fields againt X_CL_CSV_WARNING_CONFIG table
      This procedure will populate X_CL_GTT_RELEASE_SCHEDULE table*/
    /*Call to Warning Procedure to populate current Data in GTT*/
		x_prc_csv_warnings(i_sch_plan_month,i_sch_entry_opr,i_screen_flag,o_sch_warnings,o_sch_warning_excel);

    /*As data could be present in X_CL_GTT_RELEASE_SCHEDULE, take count of errors and warnings into variables from X_CL_GTT_RELEASE_SCHEDULE*/
    /*Take count of Errors and Warnings present*/
		SELECT nvl(sum(CASE grs_error_type WHEN  'O' THEN 1
		WHEN 'M' THEN 0
		END),0),
		nvl(sum(CASE grs_error_type WHEN  'O' THEN  0
		WHEN 'M' THEN 1
		END),0)
		into l_warnings_cnt ,l_error_cnt
		from x_cl_gtt_release_schedule
		where nvl(grs_error_type,'N') in ('O','M')
		;

    /*Populate Dynamic GTT Using the Main(Static)GTT*/
    /*populate data of current planned month into X_CL_GTT_REL_SCH_DETAIL table from X_CP_PLAY_LIST using bin id*/
		INSERT INTO X_CL_GTT_REL_SCH_DETAIL
		(	grd_bin_id
			,grd_lic_number
			,grd_plat_code
			,grd_dev_id
			,grd_crud
			,grd_sch_start_date
			,grd_sch_end_date
			,grd_curr_flag
			,grd_entry_oper
			,grd_entry_date
			,grd_sch_plan_month
			,Grd_Push_Start_Date
			,Grd_Pull_Start_Date
			,Grd_Push_End_Date
			,Grd_Pull_End_Date
      ,GRD_PLT_ID
		)
		select plt_bin_id,
			grs_lic_number,
			plt_plat_code,
			plt_dev_id,
			'I',
			to_date(to_char(plt_sch_start_date,'DD-MON-YYYY')||' '||convert_time_n_c(plt_sch_from_time),'DD-MON-RRRR HH24:MI:SS')plt_sch_start_date,
			to_date(to_char(plt_sch_end_date,'DD-MON-YYYY')||' '||convert_time_n_c(plt_sch_end_time),'DD-MON-RRRR HH24:MI:SS')plt_sch_end_date,
			'C',
			i_sch_entry_opr,
			sysdate,
			L_Plan_Month,
			plt_push_start_date
			,plt_pull_start_date
			,Plt_Push_End_Date
			,plt_pull_end_date
      ,plt_id
		FROM  x_cp_play_list,(SELECT DISTINCT GRS_BIN_ID,grs_lic_number FROM x_cl_gtt_release_schedule)GRS
		WHERE grs.grs_bin_id = plt_bin_id
		;

    --IXS START - Sagar Sonawane 30-Jan-2016
    /*populate bouquet level information in dynamic GTT i.e. X_CL_GTT_TERR_BOUQ_DTL from X_CP_PLT_TERR_BOUQ for the given planned month*/
    INSERT INTO x_cl_gtt_terr_bouq_dtl
    (
      GBD_PLT_ID,
      GBD_BIN_ID,
      GBD_BOUQUET_CODE,
      GBD_TER_CODE,
      GBD_PVR_START_DATE,
      GBD_PVR_END_DATE,
      GBD_OTT_START_DATE,
      GBD_OTT_END_DATE,
      GBD_SUBBOUQUET_NAME,
      GBD_CURR_FLAG,
      GBD_CRUD,
      GBD_SCH_PLAN_MONTH
    )
    Select Ptb_Plt_Id,
          GRD_BIN_ID,
          (Select Cb_Short_Code From X_Cp_Bouquet Where Cb_Id = Ptb_Bouquet_Id) Bouquet,
          (select TER_ISO_CODE from fid_territory where TER_CODE = PTB_TER_CODE),
          to_date(to_char(PTB_PVR_START_DATE,'DD-MON-YYYY')||convert_time_n_c(PTB_SCH_PVR_FROM_TIME),'DD-MON-RRRRHH24:MI:SS') PTB_PVR_START_DATE,
          to_date(to_char(PTB_PVR_END_DATE,'DD-MON-YYYY')||convert_time_n_c(PTB_SCH_PVR_END_TIME),'DD-MON-RRRRHH24:MI:SS') PTB_PVR_END_DATE,
          to_date(to_char(PTB_OTT_START_DATE,'DD-MON-YYYY')||convert_time_n_c(PTB_SCH_OTT_FROM_TIME),'DD-MON-RRRRHH24:MI:SS') PTB_OTT_START_DATE,
          to_date(to_char(PTB_OTT_END_DATE,'DD-MON-YYYY')||convert_time_n_c(PTB_SCH_OTT_END_TIME),'DD-MON-RRRRHH24:MI:SS') PTB_OTT_END_DATE,
          (Select Listagg(CB_NAME, ', ') Within Group (Order By CB_NAME)
              From X_Cp_Plt_Dev_Subbouq_Mapp,x_cp_bouquet
              Where Cps_Ptb_Id = Ptb_Id
              And Cb_Id = Cps_Subbouquet_Id
              ) sub_bouquet,
           'C',
           'I',
           GRD_SCH_PLAN_MONTH
          From  X_Cp_Plt_Terr_Bouq,
                X_CL_GTT_REL_SCH_DETAIL
          --Where grd_plt_id(+) = Ptb_Plt_Id/*Logically the outer join is not required but still need to confirm*/
          Where grd_plt_id = Ptb_Plt_Id;
    --IXS END

    /*Reset Curr Flags of both GTT and Temp Tables */

    DELETE FROM x_cl_rel_sch_detail WHERE EXISTS (SELECT 1  FROM x_cl_release_schedule WHERE crs_release_flag = 'N' AND crs_bin_id = crd_bin_id AND crs_session_id = crd_session_id AND substr(crs_session_id,1,8) < to_char(sysdate,'RRRRMMDD'));

    DELETE FROM x_cl_release_schedule WHERE crs_release_flag = 'N' AND substr(crs_session_id,1,8) < to_char(sysdate,'RRRRMMDD');

    --IXS START - Sagar Sonawane 30-Jan-2016
    UPDATE x_cl_release_terr_bouq_dtl SET rbd_curr_flag = NULL
		where rbd_sch_plan_month = l_plan_month
		and rbd_curr_flag = 'C';
    --IXS END

		UPDATE x_cl_rel_sch_detail t SET CRD_CURR_FLAG = NULL
		where crd_sch_plan_month =l_plan_month
		and t.crd_curr_flag='C';

		UPDATE x_cl_release_schedule SET CRS_CURR_FLAG = NULL
		where crs_sch_plan_month =l_plan_month
		and crs_curr_flag='C';

    --IXS START - Sagar Sonawane 30-Jan-2016
    UPDATE x_cl_temp_terr_bouq_dtl SET tbd_curr_flag = NULL;
    --IXS END

		UPDATE x_cl_temp_rel_sch_detail SET TRD_CURR_FLAG = NULL;

		UPDATE x_cl_temp_release_schedule SET TRS_CURR_FLAG = NULL;

/*To release from schedule grid there must not be a single warning or error
  and for release button on warning screen or in Auto Release Functionality
  normal user can release data with warnings where as Super user can release
  errors also*/
  --dbms_output.put_line('BEFORE l_warnings_cnt '||l_warnings_cnt||' l_error_cnt '||l_error_cnt);
		IF (i_screen_flag = 'S' AND l_warnings_cnt =0 AND l_error_cnt = 0)
		OR (i_screen_flag <> 'S')
		THEN

    --Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/05]

    INSERT INTO x_cl_gtt_release_schedule
          (grs_id
          ,grs_bin_id
          ,grs_lic_number
          ,grs_service_code
          ,grs_vod_type
          ,grs_sch_plan_month
          ,grs_sch_created
          ,grs_crud
          ,grs_gen_refno
          ,grs_tap_barcode
          ,grs_region_code
          ,grs_countries
          ,grs_ser_title
          ,grs_gen_title
          ,grs_season_number
          ,grs_epi_number
          ,grs_mpaa_rating
          ,grs_lin_cha
          ,grs_hd_sd_title
          ,grs_title_synopsis
          ,grs_show_type
          ,grs_theme
          ,grs_gen_category
          ,grs_sub_genre
          ,grs_actors
          ,grs_director
          ,grs_ser_number
          ,grs_ser_synopsis
          ,grs_sea_number
          ,grs_sea_synopsis
          ,grs_epi_count
          ,grs_advisories
          ,grs_orig_country
          ,grs_release_year
          ,grs_com_short_name
          ,grs_com_name
          ,grs_lin_sch_date
          ,grs_tap_uid_audio
          ,grs_tap_uid_version
          ,grs_tap_aspect_ratio
          ,grs_tap_uid_lang
          ,grs_gen_duration_c
          ,grs_curr_flag
          ,grs_entry_oper
          ,grs_entry_date
          ,grs_error_type
          ,grs_is_series_flag
          ,grs_l_rating
          ,grs_bouquet_codes
		      ,Grs_Gen_Catchup_Priority
		      ,Grs_Gen_Catchup_Category
    ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
          ,GRS_TITLE_VERSION
          ,GRS_SEASON_VERSION
          ,GRS_SER_VERSION
          --END : Req Id : BR_15_363
          )
		SELECT nvl((SELECT max(grs_id)+1
                FROM x_cl_gtt_release_schedule),1) l_row_id,
           bin_id,
           bin_lic_number,
           service,
           vod_type,
           sch_plan_mon,
           sch_created,
           crud,
           gen_refno,
           tap_barcode,
           region,
           sbt_ter_code,
           sead.ser_svd_ser_title ser_title,
           nvl(pvd.pvd_gen_title,a.gen_title) gen_title,
           sead.season_number sea_number,
           epi_number,
           (CASE WHEN l_rating = 'PG' or l_rating = 'FAM'
                 THEN l_rating
                 WHEN NOT regexp_like(l_rating, '[[:digit:]]')
                 THEN NULL
                 WHEN  lower(substr(l_rating,1,1)) = upper(substr(l_rating,1,1))
                 THEN regexp_substr(l_rating, '[0-9]+', 1)
                 WHEN lower(substr(l_rating,1,1)) != upper(substr(l_rating,1,1))
                 THEN regexp_substr(l_rating, '[A-Z]+[0-9]+', 1,1)
            END)pg_rating,
           channel,
           pvd_pvr_title hd_sd_title,
           replace(replace(pvd_title_synopsis,chr(10),null),chr(13),null) title_synopsis,
           decode(is_series_flag,'Y',sead.SER_show_type,pvd_show_type) show_type,
           decode(is_series_flag,'Y',sead.ser_themes,pvd_themes) themes,
           decode(is_series_flag,'Y',sead.ser_primary_genre,pvd_primary_genre) primary_genre,
           (CASE WHEN is_series_flag = 'Y'
                 THEN rtrim((SELECT rtrim(xmlagg(xmlelement(c, c.cod_value || ',')).extract('//text()'),',') cas_name
                               FROM x_prog_vod_genre_details d, fid_code c
                              WHERE cod_type = 'VOD_GENRE'
                                AND c.cod_attr1 = d.gd_genre_mapp_id
                                AND d.gd_gen_refno = sead.ser_number
                                AND d.gd_is_series_flag = 'Y'
                                AND d.gd_lang_id = a.lang_id),',')
            ELSE rtrim((SELECT rtrim(xmlagg(xmlelement(c, c.cod_value || ',')).extract('//text()'),',') cas_name
                          FROM x_prog_vod_genre_details d, fid_code c
                         WHERE cod_type = 'VOD_GENRE'
                           AND c.cod_attr1 = d.gd_genre_mapp_id
                           AND d.gd_gen_refno = a.gen_refno
                           AND d.gd_lang_id = a.lang_id),',')
            END) secondary_genre,
           pvd.pvd_actors actors,
           pvd.pvd_directors directors,
           sead.ser_number ser_id,
           replace(replace(sead.ser_svd_synopsis ,chr(10),null),chr(13),null) ser_synopsis,
           sead.sea_number sea_id,
           replace(replace(sead.sea_svd_synopsis  ,chr(10),null),chr(13),null) sea_synopsis,
           (SELECT count(1)
              FROM fid_general x
             WHERE x.gen_ser_number = sead.SEA_NUMBER
            ) epi_count,
           (CASE WHEN l_rating = 'PG' or l_rating = 'FAM'
                 THEN NULL
                 WHEN NOT regexp_like(l_rating, '[[:digit:]]')
                 THEN NULL
                 WHEN lower(substr(l_rating,1,1)) = upper(substr(l_rating,1,1))
                 THEN regexp_substr(l_rating, '[A-Z]+',1)
                 WHEN lower(substr(l_rating,1,1)) != upper(substr(l_rating,1,1))
                 THEN regexp_substr(l_rating, '[A-Z]+', 1,2)
            END) advisory,
           con_of_origin,
           gen_release_year,
           studio_code,
           studio_name,
           linearStartdateTime,
           tap_uid_audio,
           tap_uid_version,
           tap_aspect_ratio,
           language,
           runtime_mins,
           'C' curr_flag,
           i_sch_entry_opr entry_opr,
           sysdate entry_date,
           'Y' warning_flag,
           is_series_flag,
           l_rating,
           (SELECT rtrim(xmlagg(xmlelement(e,cb_short_code || ',')).extract('//text()'),',')
              FROM x_cp_bouquet
        INNER JOIN x_cp_lic_bouquet_rights
                ON cb_id = lbr_bqt_id
             WHERE lbr_lic_number = a.bin_lic_number
               AND lbr_bin_id = a.bin_id
               AND lbr_bqt_rights = 'Y') bouquet
			   ,gen_catchup_priority
			   ,gen_catchup_category
       ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
         ,PVD_SYN_VERSION
         ,SEA_VERSION
         ,SER_VERSION
         --Req Id : BR_15_363: END
      FROM x_prog_vod_details pvd,
           x_vw_series_vod_dtl sead,
           (select epl_bin_id bin_id,
                   decode(nvl(tap_uid_lang_id, 1),0,1,nvl(tap_uid_lang_id, 1)) lang_id,
                   max((SELECT uid_lang_desc
                          FROM x_uid_language
                         WHERE uid_lang_id = decode(nvl(tap_uid_lang_id,1),0,1,nvl(tap_uid_lang_id,1)))) language,
                   epl_lic_number bin_lic_number,
                   max('Catch Up') Service,
                   max('SVOD') VOD_type,
                   max(l_plan_month) sch_plan_mon,
                   min(epl_sch_start_date) sch_created,
                   max(NULL) channel,
                   max(NULL) linearStartdateTime,
                   max(null) CRUD,
                   gen_refno,
                   gen_title,
				   gen_catchup_priority,
				   gen_catchup_category,
                   tap_barcode,
                   max((SELECT lee_short_name
                          FROM fid_licensee
                         WHERE lee_number = lic_lee_number)) region,
                  /* max(nvl(rtrim((SELECT rtrim(xmlagg(xmlelement(c,ter_iso_code||',')).extract('//text()'),',')
                                    FROM fid_license_ledger l,fid_territory t
                                   WHERE l.lil_ter_code = t.ter_code
                                     AND l.lil_lic_number = epl_lic_number
                                     AND nvl(t.ter_lang_id,1) IN (SELECT nvl(uid_lang_id, 1) uid_lang_id
                                                                    FROM fid_tape, x_uid_language
                                                                   WHERE decode(tap_uid_lang_id,0,1,tap_uid_lang_id) = uid_lang_id
                                                                     AND nvl(uid_lang_is_catchup_vod,'N') = 'Y'
                                                                     AND tap_barcode = ebu_tap_barcode)
                                     AND lil_rgh_code<>'X'),',')
                           ,(SELECT rtrim(xmlagg(xmlelement(c,ter_iso_code||',')).extract('//text()'),',')
                               FROM fid_license_ledger l,fid_territory t
                              WHERE l.lil_ter_code = t.ter_code
                                AND l.lil_lic_number = epl_lic_number
                                AND nvl(t.ter_lang_id,1) = 1
                                AND lil_rgh_code<>'X'))) sbt_ter_code,
				*/
					X_PKG_CL_CSV_GENERATION.X_fun_Teritory_Code(0,epl_lic_number,(select lee_region_id from fid_licensee where lee_number = lic_lee_number),decode(nvl(tap_uid_lang_id, 1),0,1,nvl(tap_uid_lang_id, 1)),2) sbt_ter_code,
                   gen_ser_number,
                   gen_epi_number epi_number,
                   max(decode((SELECT lee_short_name
                                 FROM fid_licensee
                                WHERE lee_number=lic_lee_number),'CRSA',nvl(gen_rating_mpaa,gen_rating_int),
                                                                 'TRSA',nvl(gen_rating_mpaa,gen_rating_int),
                                                                 'TAFR',nvl(gen_rating_mpaa,gen_rating_int),
                                                                 'CAFR',nvl(gen_rating_int,gen_rating_mpaa))) l_rating,
                   max((SELECT t.ter_iso_code
                          FROM fid_territory t
                         WHERE t.ter_code = com_ter_code)) con_of_origin,
                   gen_release_year,
                   c.com_short_name studio_code,
                   c.com_name studio_name,
                   tap_uid_audio,
                   tap_uid_version,
                   tap_aspect_ratio,
                   gen_duration_c runtime_mins,
                   max(nvl((SELECT cod_attr1
                              FROM fid_code
                             WHERE cod_type = 'GEN_TYPE'
                               AND cod_value != 'HEADER'
                               AND upper(cod_value) = upper(gen_type)),'N')) is_series_flag
              FROM x_cp_exp_play_list sb,
                   fid_general g,
                   fid_license l,
                   fid_company c,
                   fid_contract con,
                   fid_tape t,
                   x_cp_exp_bin_uid sbu
             WHERE epl_lic_number = lic_number
               AND lic_gen_refno = gen_refno
               AND con_com_number = com_number
               AND lic_con_number = con_number
               AND epl_bin_id = ebu_bin_id(+)
               AND ebu_tap_barcode = tap_barcode(+)
          GROUP BY epl_bin_id,
                   decode(nvl(tap_uid_lang_id, 1),0,1,nvl(tap_uid_lang_id, 1)),
                   epl_lic_number,
				   lic_lee_number,
                   gen_refno,
                   gen_title,
				   gen_catchup_priority,
				   gen_catchup_category,
                   tap_barcode,
                   gen_ser_number,
                   gen_epi_number,
                   gen_release_year,
                   com_short_name,
                   com_name,
                   tap_uid_audio,
                   tap_uid_version,
                   tap_aspect_ratio,
                   gen_duration_c
            HAVING to_number(to_char(min(epl_sch_start_date),'RRRRMM')) = l_plan_month) a
     WHERE a.gen_refno = pvd.pvd_gen_refno(+)
       AND a.lang_id = pvd.pvd_uid_lang_id(+)
       AND a.gen_ser_number = sead.sea_number(+)
       AND a.lang_id = sead.ser_svd_uid_lang_id(+);

    INSERT INTO x_cl_gtt_rel_sch_detail
		(
			grd_bin_id,
			grd_lic_number,
			grd_plat_code,
			grd_dev_id,
			grd_crud,
			grd_sch_start_date,
			grd_sch_end_date,
			grd_curr_flag,
			grd_entry_oper,
			grd_entry_date,
			grd_sch_plan_month,
			grd_push_start_date,
			grd_pull_start_date,
			grd_push_end_date,
			grd_pull_end_date
		)
    SELECT epl_bin_id,
           grs_lic_number,
           epl_plat_code,
           epl_dev_id,
           'I',
           epl_sch_start_date,
           epl_sch_end_date,
           'C',
           i_sch_entry_opr,
           sysdate,
           l_plan_month,
		   epl_push_start_date,
		   epl_pull_start_date,
		   epl_push_end_date,
		   epl_pull_end_date
      FROM x_cp_exp_play_list,
           (SELECT distinct
                   grs_bin_id,
                   grs_lic_number
              FROM x_cl_gtt_release_schedule) grs
		 WHERE grs.grs_bin_id = epl_bin_id;
    --Dev.R14 : Catchup 4 All Intrim : End

    -- dbms_output.put_line('IN IFFFFFFFFFFF');
    /*take count of records from X_CL_BACKUP_REL_SCHEDULE for the given planned month and whose status is not processed*/
			select count(1)
			into l_backup_cnt
			from x_cl_backup_rel_schedule
			where brs_sch_plan_month = l_plan_month
      and nvl(BRS_PROCESS_FLAG,'N') <> 'P';


			IF l_backup_cnt = 0
			THEN
        /*take the count of records into l_temp_rel_sch_cnt from X_CL_TEMP_RELEASE_SCHEDULE for the given planned month*/
				select count(*)
				into l_temp_rel_sch_cnt
				from x_cl_temp_release_schedule
				where trs_sch_plan_month = l_plan_month
				;

				if l_temp_rel_sch_cnt > 0
				then

          FOR J IN
          (
              select trs_bin_id,TRS_TAP_UID_LANG
              from x_cl_temp_release_schedule
              where trs_sch_plan_month = l_plan_month
              and not exists (select 1
                                  from x_cl_backup_rel_schedule
                                  where brs_sch_plan_month = trs_sch_plan_month
                                  and BRS_TAP_UID_LANG =  TRS_TAP_UID_LANG
                                  and brs_bin_id = trs_bin_id)
             and  not exists ( select 1
                               from x_cl_ixs_api_release
                               where IAR_STATUS = 'P'
                               and IAR_LANGUAGE = TRS_TAP_UID_LANG
                               and IAR_BIN_ID = trs_bin_id)
          )
          LOOP

                delete from x_cl_temp_terr_bouq_dtl
                where  tbd_bin_id = J.trs_bin_id;

                delete from x_cl_temp_rel_sch_detail
                WHERE trd_bin_id = J.trs_bin_id;

                delete from x_cl_temp_release_schedule
                where trs_sch_plan_month = l_plan_month
                AND  TRS_TAP_UID_LANG = J.TRS_TAP_UID_LANG
                AND trs_bin_id = J.trs_bin_id;

          END LOOP;

          /*delete all the records from the back up storage for the given planned month*/
          delete from x_cl_backup_rel_schedule
          where brs_sch_plan_month = l_plan_month;

          delete from x_cl_backup_rel_sch_detl
          where brd_sch_plan_month = l_plan_month;

          delete from x_cl_backup_terr_bouq_dtl
          where bbd_sch_plan_month = l_plan_month;

          /*take back up from temp tables for the given month*/
					insert into x_cl_backup_rel_schedule
					select
              TRS_BIN_ID,
              TRS_LIC_NUMBER,
              TRS_SERVICE_CODE,
              TRS_VOD_TYPE,
              TRS_SCH_PLAN_MONTH,
              TRS_SCH_CREATED,
              TRS_CRUD,
              TRS_GEN_REFNO,
              TRS_TAP_BARCODE,
              TRS_REGION_CODE,
              TRS_COUNTRIES,
              TRS_SER_TITLE,
              TRS_GEN_TITLE,
              TRS_SEASON_NUMBER,
              TRS_EPI_NUMBER,
              TRS_MPAA_RATING,
              TRS_LIN_CHA,
              TRS_HD_SD_TITLE,
              TRS_TITLE_SYNOPSIS,
              TRS_SHOW_TYPE,
              TRS_THEME,
              TRS_GEN_CATEGORY,
              TRS_SUB_GENRE,
              TRS_ACTORS,
              TRS_DIRECTOR,
              TRS_SER_NUMBER,
              TRS_SER_SYNOPSIS,
              TRS_SEA_NUMBER,
              TRS_SEA_SYNOPSIS,
              TRS_EPI_COUNT,
              TRS_ADVISORIES,
              TRS_ORIG_COUNTRY,
              TRS_RELEASE_YEAR,
              TRS_COM_SHORT_NAME,
              TRS_COM_NAME,
              TRS_LIN_SCH_DATE,
              TRS_TAP_UID_AUDIO,
              TRS_TAP_UID_VERSION,
              TRS_TAP_ASPECT_RATIO,
              TRS_TAP_UID_LANG,
              TRS_GEN_DURATION_C,
              TRS_CURR_FLAG,
              TRS_ENTRY_OPER,
              TRS_ENTRY_DATE,
              TRS_BOUQUET_CODES,
              TRS_GEN_CATCHUP_PRIORITY,
              TRS_GEN_CATCHUP_CATEGORY,
              TRS_EXPRESS,
              'N',
           ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
              TRS_TITLE_VERSION,
              TRS_SEASON_VERSION,
              TRS_SER_VERSION
              --Req Id : BR_15_363: end
          from x_cl_temp_release_schedule
					where trs_sch_plan_month = l_plan_month
					;

					insert into x_cl_backup_rel_sch_detl
					select * from x_cl_temp_rel_sch_detail
					where trd_sch_plan_month = l_plan_month
					;

        --IXS START - Sagar Sonawane 31-Jan-2016
          insert into x_cl_backup_terr_bouq_dtl
          select * from x_cl_temp_terr_bouq_dtl
          where tbd_sch_plan_month = l_plan_month
          ;
        --IXS END
				else

					insert into x_cl_backup_rel_schedule
						(brs_sch_plan_month, brs_process_flag)
					values (l_plan_month,'P')
					;
				end if;

			ELSE

       /*take backup count into l_backup_cnt for the given planned month and whose bin id is not equal to null*/
       /*i.e check if this is a first schedule release for the given planned month*/
				select count(1)
				into l_backup_cnt
				from x_cl_backup_rel_schedule
				where brs_sch_plan_month = l_plan_month
				and brs_bin_id is null
				;

				if l_backup_cnt > 0
				then

					delete from x_cl_temp_release_schedule
					where trs_sch_plan_month = l_plan_month
					;

					delete from x_cl_temp_rel_sch_detail
					where trd_sch_plan_month = l_plan_month
					;

          --IXS START - Sagar Sonawane 31-Jan-2016
          delete from x_cl_temp_terr_bouq_dtl
          where tbd_sch_plan_month = l_plan_month
          ;
          --IXS END
				else
          --IXS START - Sagar Sonawane 31-Jan-2016

          /*for each back up record in bin back up i.e. X_CL_BACKUP_REL_SCHEDULE, whose processed flag is <> 'P' and for the given planned month
          delete all such records from all temporary storage and restore them from backup
          i.e. these were the entries which were failed to release in previous release. Hence theis old status is restored from backup for comparison to be done after merge*/

          FOR J IN
          (
              select trs_bin_id,TRS_TAP_UID_LANG
              from x_cl_temp_release_schedule
              where trs_sch_plan_month = l_plan_month
              and not exists (select 1
                                  from x_cl_backup_rel_schedule
                                  where brs_sch_plan_month = trs_sch_plan_month
                                  and BRS_TAP_UID_LANG =  TRS_TAP_UID_LANG
                                  and brs_process_flag = 'P'
                                  AND brs_bin_id = trs_bin_id)
             and (--trs_crud = 'I' or
             not exists ( select 1
                               from x_cl_ixs_api_release
                               where IAR_STATUS = 'P'
                               and IAR_LANGUAGE = TRS_TAP_UID_LANG
                               and IAR_BIN_ID = trs_bin_id))
             /*and  not exists ( select 1
                               from x_cl_ixs_api_release
                               where IAR_STATUS = 'P'
                               and IAR_LANGUAGE = TRS_TAP_UID_LANG
                               and IAR_BIN_ID = trs_bin_id)*/
          )
          LOOP

                delete from x_cl_temp_terr_bouq_dtl
                where  tbd_bin_id = J.trs_bin_id;

                delete from x_cl_temp_rel_sch_detail
                WHERE trd_bin_id = J.trs_bin_id;

                delete from x_cl_temp_release_schedule
                where trs_sch_plan_month = l_plan_month
                AND  TRS_TAP_UID_LANG = J.TRS_TAP_UID_LANG
                AND trs_bin_id = J.trs_bin_id;

          END LOOP;

          FOR rec IN (select BRS_BIN_ID, BRS_TAP_UID_LANG
                              from x_cl_backup_rel_schedule
                              where nvl(brs_process_flag,'N') <> 'P'
                              and BRS_SCH_PLAN_MONTH = l_plan_month)
          LOOP

              delete from x_cl_temp_release_schedule
              where trs_sch_plan_month = l_plan_month
              and TRS_BIN_ID = rec.BRS_BIN_ID
              and TRS_TAP_UID_LANG = rec.BRS_TAP_UID_LANG;

              delete from x_cl_temp_rel_sch_detail
              where trd_sch_plan_month = l_plan_month
              and TRD_BIN_ID = rec.BRS_BIN_ID;

              delete from x_cl_temp_terr_bouq_dtl
              where tbd_sch_plan_month = l_plan_month
              and tbd_bin_id = rec.BRS_BIN_ID;

              insert into x_cl_temp_release_schedule
              select BRS_BIN_ID,BRS_LIC_NUMBER,BRS_SERVICE_CODE,BRS_VOD_TYPE,BRS_SCH_PLAN_MONTH,BRS_SCH_CREATED,BRS_CRUD,BRS_GEN_REFNO,BRS_TAP_BARCODE,BRS_REGION_CODE,BRS_COUNTRIES,BRS_SER_TITLE,BRS_GEN_TITLE,BRS_SEASON_NUMBER,BRS_EPI_NUMBER,BRS_MPAA_RATING,BRS_LIN_CHA,BRS_HD_SD_TITLE,BRS_TITLE_SYNOPSIS,BRS_SHOW_TYPE,BRS_THEME,BRS_GEN_CATEGORY,BRS_SUB_GENRE,BRS_ACTORS,BRS_DIRECTOR,BRS_SER_NUMBER,BRS_SER_SYNOPSIS,BRS_SEA_NUMBER,BRS_SEA_SYNOPSIS,BRS_EPI_COUNT,BRS_ADVISORIES,BRS_ORIG_COUNTRY,BRS_RELEASE_YEAR,BRS_COM_SHORT_NAME,BRS_COM_NAME,BRS_LIN_SCH_DATE,BRS_TAP_UID_AUDIO,BRS_TAP_UID_VERSION,BRS_TAP_ASPECT_RATIO,BRS_TAP_UID_LANG,BRS_GEN_DURATION_C,BRS_CURR_FLAG,BRS_ENTRY_OPER,BRS_ENTRY_DATE,BRS_BOUQUET_CODES,BRS_GEN_CATCHUP_PRIORITY,BRS_GEN_CATCHUP_CATEGORY,BRS_EXPRESS
            ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
              ,BRS_TITLE_VERSION
              ,BRS_SEASON_VERSION
              ,BRS_SER_VERSION
              --Req Id : BR_15_363: END
              from x_cl_backup_rel_schedule
              where brs_sch_plan_month = l_plan_month
              and BRS_BIN_ID = rec.BRS_BIN_ID
              and BRS_TAP_UID_LANG = rec.BRS_TAP_UID_LANG;

              insert into x_cl_temp_rel_sch_detail
              select * from x_cl_backup_rel_sch_detl
              where brd_sch_plan_month = l_plan_month
              and bRD_BIN_ID = rec.BRS_BIN_ID;

              insert into x_cl_temp_terr_bouq_dtl tbd
              select * from x_cl_backup_terr_bouq_dtl
              where bbd_sch_plan_month = l_plan_month
              and bbd_bin_id = rec.BRS_BIN_ID;
          END LOOP;

          /*delete all the records from back up storage for the given month */
          delete from x_cl_backup_rel_schedule
          where brs_sch_plan_month = l_plan_month;

          delete from x_cl_backup_rel_sch_detl
          where brd_sch_plan_month = l_plan_month;

          delete from x_cl_backup_terr_bouq_dtl
          where bbd_sch_plan_month = l_plan_month;

          --copy temp to backup for given planned month
          --i.e. take back up of the latest data from temp tables before merging
          insert into x_cl_backup_rel_schedule
          select
              TRS_BIN_ID,
              TRS_LIC_NUMBER,
              TRS_SERVICE_CODE,
              TRS_VOD_TYPE,
              TRS_SCH_PLAN_MONTH,
              TRS_SCH_CREATED,
              TRS_CRUD,
              TRS_GEN_REFNO,
              TRS_TAP_BARCODE,
              TRS_REGION_CODE,
              TRS_COUNTRIES,
              TRS_SER_TITLE,
              TRS_GEN_TITLE,
              TRS_SEASON_NUMBER,
              TRS_EPI_NUMBER,
              TRS_MPAA_RATING,
              TRS_LIN_CHA,
              TRS_HD_SD_TITLE,
              TRS_TITLE_SYNOPSIS,
              TRS_SHOW_TYPE,
              TRS_THEME,
              TRS_GEN_CATEGORY,
              TRS_SUB_GENRE,
              TRS_ACTORS,
              TRS_DIRECTOR,
              TRS_SER_NUMBER,
              TRS_SER_SYNOPSIS,
              TRS_SEA_NUMBER,
              TRS_SEA_SYNOPSIS,
              TRS_EPI_COUNT,
              TRS_ADVISORIES,
              TRS_ORIG_COUNTRY,
              TRS_RELEASE_YEAR,
              TRS_COM_SHORT_NAME,
              TRS_COM_NAME,
              TRS_LIN_SCH_DATE,
              TRS_TAP_UID_AUDIO,
              TRS_TAP_UID_VERSION,
              TRS_TAP_ASPECT_RATIO,
              TRS_TAP_UID_LANG,
              TRS_GEN_DURATION_C,
              TRS_CURR_FLAG,
              TRS_ENTRY_OPER,
              TRS_ENTRY_DATE,
              TRS_BOUQUET_CODES,
              TRS_GEN_CATCHUP_PRIORITY,
              TRS_GEN_CATCHUP_CATEGORY,
              TRS_EXPRESS,
              'N',
          ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
              TRS_TITLE_VERSION,
              TRS_SEASON_VERSION,
              TRS_SER_VERSION
              --Req Id : BR_15_363: end
          from x_cl_temp_release_schedule
          where trs_sch_plan_month = l_plan_month;

          insert into x_cl_backup_rel_sch_detl
          select * from x_cl_temp_rel_sch_detail
          where trd_sch_plan_month = l_plan_month;

          insert into x_cl_backup_terr_bouq_dtl
          select * from x_cl_temp_terr_bouq_dtl
          where tbd_sch_plan_month = l_plan_month;

          --IXS END

				end if;

			END IF;

			 commit;

/*Merge Dynamic GTT data into Dynamic Temp Table*/

      --IXS START - Sagar Sonawane 30-Jan-2016
      select to_date(to_char(to_date("CONTENT"),'yyyyMMdd'),'yyyyMMdd') INTO l_go_live_date from X_FIN_CONFIGS WHERE "KEY" = 'CU4ALL_LIVE_DATE';

      begin
          for i in
          (
          select trd.TRD_PLT_ID old_plt_id, grd.grd_plt_id new_plt_id
          from x_cl_temp_rel_sch_detail trd
              ,(     select *
                  from x_cl_gtt_rel_sch_detail
                      ,(            SELECT DISTINCT GRS_BIN_ID
                           FROM x_cl_gtt_release_schedule
                          WHERE  grs_error_type <>  DECODE(l_is_super_user,0,'M','X')
                      )GRS
                  where grd_bin_id = GRS.grs_bin_id
              ) GRD
          where trd.trd_bin_id      = grd.grd_bin_id
          AND trd.trd_plat_code      = grd.grd_plat_code
          AND trd.trd_dev_id         = grd.grd_dev_id
          and trd.TRD_PLT_ID <> grd.grd_plt_id
          )
          loop
                update x_cl_temp_terr_bouq_dtl
                set tbd_plt_id = i.new_plt_id
                where tbd_plt_id = i.old_plt_id
                ;

                update x_cl_temp_rel_sch_detail
                set TRD_PLT_ID = i.new_plt_id
                where TRD_PLT_ID = i.old_plt_id
                ;
          end loop;
      end;
      --Anirudha

      /*merge bouquet and subbouquet details into X_CL_TEMP_TERR_BOUQ_DTL from X_CL_GTT_TERR_BOUQ_DTL
				when matched then update the records present in X_CL_TEMP_TERR_BOUQ_DTL with TBD_CURR_FLAG = 'C' and TBD_CRUD = 'U'
				when not matched then insert into X_CL_TEMP_TERR_BOUQ_DTL with TRD_CURR_FLAG = 'C' and TRD_CRUD = 'U' -- CRUD flag will always be U as this schedule belogs to a parent record of playlist table*/


      MERGE INTO x_cl_temp_terr_bouq_dtl tbd
      USING
      (	select *
            from x_cl_gtt_terr_bouq_dtl
              ,(	SELECT DISTINCT GRS_BIN_ID
                FROM x_cl_gtt_release_schedule
                WHERE  grs_error_type <>  DECODE(l_is_super_user,0,'M','X')
              )GRS
            where gbd_bin_id = GRS.grs_bin_id
      ) GBD
      ON (tbd.tbd_bin_id      = gbd.gbd_bin_id
          AND tbd.tbd_plt_id      = gbd.gbd_plt_id
          AND tbd.tbd_bouquet_code         = gbd.gbd_bouquet_code
          and tbd.tbd_ter_code = gbd.gbd_ter_code
          )
      WHEN MATCHED THEN UPDATE
      SET
          --tbd.tbd_ter_code           = gbd.gbd_ter_code
           tbd.tbd_pvr_start_date     = gbd.gbd_pvr_start_date
          ,tbd.tbd_pvr_end_date       = gbd.gbd_pvr_end_date
          ,tbd.tbd_ott_start_date     = gbd.gbd_ott_start_date
          ,tbd.tbd_ott_end_date       = gbd.gbd_ott_end_date
          ,tbd.tbd_subbouquet_name    = gbd.gbd_subbouquet_name
          ,tbd.tbd_curr_flag          = 'C'
          ,tbd.tbd_crud	              = 'U'
          ,tbd.tbd_entry_oper         = I_SCH_ENTRY_OPR
          ,tbd.tbd_entry_date         = SYSDATE
      Where
          (--tbd.tbd_ter_code             <> gbd.gbd_ter_code OR
           nvl(tbd.tbd_pvr_start_date,'31-DEC-3199') <> nvl(gbd.gbd_pvr_start_date,'31-DEC-3199') OR
           nvl(tbd.tbd_pvr_end_date,'31-DEC-3199') <> nvl(gbd.gbd_pvr_end_date,'31-DEC-3199') OR
           nvl(tbd.tbd_ott_start_date,'31-DEC-3199') <> nvl(gbd.gbd_ott_start_date,'31-DEC-3199') OR
           nvl(tbd.tbd_ott_end_date,'31-DEC-3199') <> nvl(gbd.gbd_ott_end_date,'31-DEC-3199') OR
           tbd.tbd_subbouquet_name    <> gbd.gbd_subbouquet_name)
      AND  exists (select 1
					    from x_cl_gtt_release_schedule
              where grs_error_type <>  DECODE(l_is_super_user,0,'M','X')
              and grs_bin_id = tbd.tbd_bin_id
					)
			WHEN NOT MATCHED THEN INSERT
      (
        tbd_plt_id,
        tbd_bin_id,
        tbd_bouquet_code,
        tbd_ter_code,
        tbd_pvr_start_date,
        tbd_pvr_end_date,
        tbd_ott_start_date,
        tbd_ott_end_date,
        tbd_subbouquet_name,
        tbd_curr_flag,
        tbd_crud,
        tbd_sch_plan_month,
        tbd_entry_oper,
        tbd_entry_date
      )
      VALUES
      (
        gbd_plt_id,
        gbd_bin_id,
        gbd_bouquet_code,
        gbd_ter_code,
        gbd_pvr_start_date,
        gbd_pvr_end_date,
        gbd_ott_start_date,
        gbd_ott_end_date,
        gbd_subbouquet_name,
        'C',
        'U',
        L_Plan_Month,
        i_sch_entry_opr,
				SYSDATE
      );

      /*Above merge statement is used to merge those records which are already present or or newly inserted. It does not cater delete operation*/

      /*Set Curr flag 'C' and CRUD 'U' in Static Temp for bin IDs whose schedule is deleted*/
      IF(l_go_live_date <= i_sch_plan_month /*sysdate*/)
      THEN
      /*update X_CL_TEMP_REL_SCH_DETAIL table with TRD_CURR_FLAG = 'C' and TRD_CRUD = 'U' whose schedule is deleted*/
      Select TBd_Bin_Id BULK COLLECT INTO L_Trd_Bin_Id
                            From x_cl_temp_terr_bouq_dtl
                                        ,X_Cl_Gtt_Release_Schedule
                					 Where Grs_Error_Type <>  Decode(L_Is_Super_User,0,'M','X')
                           And Grs_Bin_Id = Tbd_Bin_Id
                           and not exists (select 1 from x_cl_gtt_terr_bouq_dtl
                            									where gbd_bin_id = Tbd_BIN_ID
                            									and gbd_plt_id = tbd_plt_id
                                              and gbd_bouquet_code = tbd_bouquet_code
                									          );
      FORALL indx IN 1 .. L_Trd_Bin_Id.COUNT
      UPDATE X_CL_TEMP_REL_SCH_DETAIL
      set TRD_CURR_FLAG = 'C'
          ,TRD_CRUD = 'U'
      Where TRD_BIN_ID= L_Trd_Bin_Id(indx);

      /*update X_CL_TEMP_REL_SCH_DETAIL
      set TRD_CURR_FLAG = 'C'
          ,TRD_CRUD = 'U'
      Where TRD_BIN_ID in (Select TBd_Bin_Id
                            From x_cl_temp_terr_bouq_dtl
                                        ,X_Cl_Gtt_Release_Schedule
                					 Where Grs_Error_Type <>  Decode(L_Is_Super_User,0,'M','X')
                           And Grs_Bin_Id = Tbd_Bin_Id
                           and not exists (select 1 from x_cl_gtt_terr_bouq_dtl
                            									where gbd_bin_id = Tbd_BIN_ID
                            									and gbd_plt_id = tbd_plt_id
                                              and gbd_bouquet_code = tbd_bouquet_code
                									          )
                                 );*/
      END IF;

      /*now delete the records from X_CL_TEMP_TERR_BOUQ_DTL whose parent records exists in X_CL_GTT_RELEASE_SCHEDULE but whose bin id is not present in X_CL_GTT_TERR_BOUQ_DTL
				i.e. delete stale records from static temp bouquet */
      delete from x_cl_temp_terr_bouq_dtl
      where  exists (select 1 from x_cl_gtt_release_schedule where grs_bin_id = tbd_bin_id)
			and not exists (select 1 from x_cl_gtt_terr_bouq_dtl
            					where gbd_bin_id = Tbd_BIN_ID
                            and gbd_plt_id = tbd_plt_id
                            and gbd_bouquet_code = tbd_bouquet_code);

      /*  populate X_CL_RELEASE_TERR_BOUQ_DTL from X_CL_TEMP_TERR_BOUQ_DTL whose TBD_CURR_FLAG = 'C'  */
      insert into x_cl_release_terr_bouq_dtl
      select
        tbd_plt_id,
        tbd_bin_id,
        tbd_bouquet_code,
        tbd_ter_code,
        tbd_pvr_start_date,
        tbd_pvr_end_date,
        tbd_ott_start_date,
        tbd_ott_end_date,
        tbd_subbouquet_name,
        tbd_curr_flag,
        tbd_crud,
        tbd_sch_plan_month,
        l_session,
        tbd_entry_oper,
        tbd_entry_date
      from x_cl_temp_terr_bouq_dtl where tbd_curr_flag = 'C' ;

    --IXS END

      /*merge playlist details into X_CL_TEMP_REL_SCH_DETAIL from X_CL_GTT_REL_SCH_DETAIL
				when matched then update the records present in X_CL_TEMP_REL_SCH_DETAIL with TRD_CURR_FLAG = 'C' and TRD_CRUD = 'U'
				when not matched then insert into X_CL_TEMP_REL_SCH_DETAIL with TRD_CURR_FLAG = 'C' and TRD_CRUD = 'U' -- CRUD flag will always be U as this schedule belogs to a parent record of bin table*/

			MERGE into x_cl_temp_rel_sch_detail trd
			USING	(	select *
					from x_cl_gtt_rel_sch_detail
						,(	SELECT DISTINCT GRS_BIN_ID
							FROM x_cl_gtt_release_schedule
							WHERE  grs_error_type <>  DECODE(l_is_super_user,0,'M','X')
						)GRS
					where grd_bin_id = GRS.grs_bin_id
				) GRD
			ON	(trd.trd_bin_id      = grd.grd_bin_id
				AND trd.trd_plat_code      = grd.grd_plat_code
				AND trd.trd_dev_id         = grd.grd_dev_id
				)
			WHEN MATCHED THEN UPDATE
			SET	TRD.TRD_LIC_NUMBER     = GRD.GRD_LIC_NUMBER,
				TRD.TRD_SCH_START_DATE = GRD.GRD_SCH_START_DATE,
				TRD.TRD_SCH_END_DATE   = GRD.GRD_SCH_END_DATE,
				Trd.Trd_Push_Start_Date = Grd.Grd_Push_Start_Date,
				Trd.Trd_Pull_Start_Date = Grd.Grd_Pull_Start_Date,
				Trd.Trd_Push_End_Date = Grd.Grd_Push_End_Date,
				trd.trd_Pull_End_Date = grd.Grd_Pull_End_Date,
				TRD.TRD_CURR_FLAG      = 'C',
				TRD.TRD_CRUD           = 'U',
				TRD.TRD_ENTRY_OPER     = I_SCH_ENTRY_OPR,
				TRD.TRD_ENTRY_DATE     = SYSDATE,
        TRD.TRD_PLT_ID         = GRD.GRD_PLT_ID
			WHERE (	TRD.TRD_LIC_NUMBER     <> GRD.GRD_LIC_NUMBER OR
				TRD.TRD_SCH_START_DATE <> GRD.GRD_SCH_START_DATE OR
				Trd.Trd_Sch_End_Date <> Grd.Grd_Sch_End_Date Or
				nvl(Trd.Trd_Push_Start_Date,'31-DEC-3199') <> nvl(Grd.Grd_Push_Start_Date,'31-DEC-3199') Or
				nvl(Trd.Trd_Pull_Start_Date,'31-DEC-3199') <> nvl(Grd.Grd_Pull_Start_Date,'31-DEC-3199') Or
				nvl(Trd.Trd_Push_End_Date,'31-DEC-3199') <> nvl(Grd.Grd_Push_End_Date,'31-DEC-3199') Or
				nvl(trd.trd_Pull_End_Date,'31-DEC-3199') <> nvl(grd.Grd_Pull_End_Date,'31-DEC-3199')
        )
			AND  exists (       select 1
					    from x_cl_gtt_release_schedule
					    where grs_error_type <>  DECODE(l_is_super_user,0,'M','X')
					    and grs_bin_id = trd.trd_bin_id
					)
			WHEN NOT MATCHED THEN 	INSERT
				(trd_bin_id,
				trd_lic_number,
				trd_plat_code,
				trd_dev_id,
				trd_sch_start_date,
				trd_sch_end_date,
				trd_curr_flag,
				trd_crud,
				trd_entry_oper,
				trd_entry_date,
				Trd_Sch_Plan_Month,
				Trd_Push_Start_Date,
				Trd_Pull_Start_Date,
				Trd_Push_End_Date,
				trd_Pull_End_Date,
        TRD_PLT_ID
				)
			VALUES
				(grd.grd_bin_id,
				grd.grd_lic_number,
				grd.grd_plat_code,
				grd.grd_dev_id,
				grd.grd_sch_start_date,
				grd.grd_sch_end_date,
				'C',
				'U',
				i_sch_entry_opr,
				SYSDATE,
				L_Plan_Month,
				grd.Grd_Push_Start_Date,
				grd.Grd_Pull_Start_Date,
				grd.Grd_Push_End_Date,
				grd.Grd_Pull_End_Date,
        grd.grd_plt_id
				);

      /*Above merge statement is used to merge those records which are already present or or newly inserted. It does not cater delete operation*/
      /*Set Curr flag 'C' and CRUD 'U' in Static Temp for bin IDs whose schedule is deleted*/
			update x_cl_temp_release_schedule
			set trs_curr_flag = 'C'
				 ,Trs_Crud      = 'U'
			Where Trs_Bin_Id In (Select Trd_Bin_Id
                            From X_Cl_Temp_Rel_Sch_Detail
                                        ,X_Cl_Gtt_Release_Schedule
                					 Where Grs_Error_Type <>  Decode(L_Is_Super_User,0,'M','X')
                           And Grs_Bin_Id = Trd_Bin_Id
                           and not exists (select 1 from x_cl_gtt_rel_sch_detail
                            									where grd_bin_id = TRD_BIN_ID
                            									and grd_dev_id = trd_dev_id
                									          )
                                 );
/*Also delete the same from Dynamic Temp*/
			delete from X_CL_TEMP_REL_SCH_DETAIL
			where  exists (select 1 from x_cl_gtt_release_schedule where grs_bin_id = trd_bin_id)
			and not exists (select 1 from x_cl_gtt_rel_sch_detail
            					where grd_bin_id = TRD_BIN_ID
            					and grd_dev_id = trd_dev_id);



    --IXS START - Sagar Sonawane 30-Jan-2016
    --CHECK AGAINST GO LIVE DATE

      IF(l_go_live_date <= i_sch_plan_month/*sysdate*/)
      THEN
      /*now update X_CL_TEMP_REL_SCH_DETAIL table with TRD_CURR_FLAG = 'C' and TRD_CRUD = 'U' whose schedule is updated
					i.e. in bin level merge section a records can be set as deleted using these modified records.
						This statement is written because only bouquet level information could have been changed for schedules*/
      update X_CL_TEMP_REL_SCH_DETAIL
      set TRD_CURR_FLAG = 'C',
          TRD_CRUD = 'U'
      where TRD_CURR_FLAG <> 'C'
      and exists (  select 1
                    from x_cl_temp_terr_bouq_dtl
                    where TBD_PLT_ID = TRD_PLT_ID
                      and tbd_bin_id = TRD_BIN_ID
                      and TBD_CURR_FLAG  = 'C'
                      );
      END IF;
    --IXS END

      /*insert data into X_CL_REL_SCH_DETAIL table from X_CL_TEMP_REL_SCH_DETAIL whose TRD_CURR_FLAG = 'C'
			i.e. insert data into X_CL_REL_SCH_DETAIL which is a final release table */
/*Release Dynamic records with curr flag 'C'*/
			insert into x_cl_rel_sch_detail
			select trd_bin_id
				,trd_lic_number
				,trd_plat_code
				,trd_dev_id
				,trd_crud
				,trd_sch_start_date
				,trd_sch_end_date
				,trd_curr_flag
				,trd_entry_oper
				,trd_entry_date
				,l_session
				,trd_sch_plan_month
				,Trd_Push_Start_Date
				,Trd_Pull_Start_Date
				,Trd_Push_End_Date
				,trd_Pull_End_Date
        ,TRD_PLT_ID
			FROM X_CL_TEMP_REL_SCH_DETAIL where TRD_CURR_FLAG = 'C';

/*Merge Static GTT data into Static Temp Table*/

      /*merge bin details into X_CL_TEMP_RELEASE_SCHEDULE from X_CL_GTT_RELEASE_SCHEDULE
				when matched then update the records with trs_CRUD = 'U'
				when not matched then insert the records with trs_CRUD = 'I'*/

			MERGE	into x_cl_temp_release_schedule trs
			USING ( select * from x_cl_gtt_release_schedule
			where grs_error_type <> DECODE(l_is_super_user,'0','M','X')
    			) grs
			ON (	trs.trs_bin_id = grs.grs_bin_id
				AND trs.trs_sch_plan_month = grs.grs_sch_plan_month
				AND trs.trs_tap_uid_lang  = grs.grs_tap_uid_lang
				)
			WHEN MATCHED THEN UPDATE
			SET	trs.trs_lic_number       = grs.grs_lic_number,
				trs.trs_service_code     = grs.grs_service_code,
				trs.trs_vod_type         = grs.grs_vod_type,
				trs.trs_sch_created      = grs.grs_sch_created,
				trs.trs_CRUD             = 'U',
				trs.trs_gen_refno        = grs.grs_gen_refno,
				trs.trs_tap_barcode      = grs.grs_tap_barcode,
				trs.trs_region_code      = grs.grs_region_code,
				trs.trs_countries        = grs.grs_countries,
				trs.trs_ser_title        = grs.grs_ser_title,
				trs.trs_gen_title        = grs.grs_gen_title,
				trs.trs_season_number    = grs.grs_season_number,
				trs.trs_epi_number       = grs.grs_epi_number,
				trs.trs_mpaa_rating      = grs.grs_mpaa_rating,
				trs.trs_lin_cha          = grs.grs_lin_cha,
				trs.trs_hd_sd_title      = grs.grs_hd_sd_title,
				trs.trs_title_synopsis   = grs.grs_title_synopsis,
				trs.trs_show_type        = grs.grs_show_type,
				trs.trs_theme            = grs.grs_theme,
				trs.trs_gen_category     = grs.grs_gen_category,
				trs.trs_sub_genre        = grs.grs_sub_genre,
				trs.trs_actors           = grs.grs_actors,
				trs.trs_director         = grs.grs_director,
				trs.trs_ser_number       = grs.grs_ser_number,
				trs.trs_ser_synopsis     = grs.grs_ser_synopsis,
				trs.trs_sea_number       = grs.grs_sea_number,
				trs.trs_sea_synopsis     = grs.grs_sea_synopsis,
				trs.trs_epi_count        = grs.grs_epi_count,
				trs.trs_advisories       = grs.grs_advisories,
				trs.trs_orig_country     = grs.grs_orig_country,
				trs.trs_release_year     = grs.grs_release_year,
				trs.trs_com_short_name   = grs.grs_com_short_name,
				trs.trs_com_name         = grs.grs_com_name,
				trs.trs_lin_sch_date     = grs.grs_lin_sch_date,
				trs.trs_tap_uid_audio    = grs.grs_tap_uid_audio,
				trs.trs_tap_uid_version  = grs.grs_tap_uid_version,
				trs.trs_tap_aspect_ratio = grs.grs_tap_aspect_ratio,
				--trs.trs_tap_uid_lang  = grs.grs_tap_uid_lang,
				trs.trs_gen_duration_c   = grs.grs_gen_duration_c,
				trs.trs_Gen_Catchup_Priority = grs.grs_Gen_Catchup_Priority,
				trs.trs_Gen_Catchup_Category = grs.grs_Gen_Catchup_Category,
				trs.trs_CURR_FLAG        = 'C',
				trs.trs_entry_oper       = i_sch_entry_opr,
				trs.trs_entry_date       = sysdate,
        trs.trs_bouquet_codes    = grs.grs_bouquet_codes,
        trs.trs_express          = grs.grs_express,
     ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
        trs.trs_title_version   = grs.grs_title_version,
        trs.trs_season_version   = grs.grs_season_version,
        trs.trs_ser_version   = grs.grs_ser_version
        ---Req Id : BR_15_363: END
			where (/*nvl(trs.trs_bin_id, 0) <> nvl(grs.grs_bin_id, 0) or*/
				nvl(trs.trs_lic_number, 0)  <> nvl(grs.grs_lic_number, 0) or
				nvl(trs.trs_service_code, 0)<>	nvl(grs.grs_service_code, 0) or
				nvl(trs.trs_vod_type, 0)    <> nvl(grs.grs_vod_type, 0) or
				--trs.trs_sch_created         <> grs.grs_sch_created or
				nvl(trs.trs_gen_refno, 0)   <> nvl(grs.grs_gen_refno, 0) or
				nvl(trs.trs_tap_barcode, 0) <> nvl(grs.grs_tap_barcode, 0) or
				nvl(trs.trs_region_code, 0) <> nvl(grs.grs_region_code, 0) or
				nvl(trs.trs_countries, 0)   <> nvl(grs.grs_countries, 0) or
				nvl(trs.trs_ser_title, 0)   <> nvl(grs.grs_ser_title, 0) or
				nvl(trs.trs_gen_title, 0)   <> nvl(grs.grs_gen_title, 0) or
				nvl(trs.trs_season_number, 0)<> nvl(grs.grs_season_number, 0) or
				nvl(trs.trs_epi_number, 0)   <> nvl(grs.grs_epi_number, 0) or
				nvl(trs.trs_mpaa_rating, 0)  <> nvl(grs.grs_mpaa_rating, 0) or
				nvl(trs.trs_lin_cha, 0)      <> nvl(grs.grs_lin_cha, 0) or
				nvl(trs.trs_hd_sd_title, 0)  <> nvl(grs.grs_hd_sd_title, 0) or
				nvl(trs.trs_title_synopsis, 0)<> nvl(grs.grs_title_synopsis, 0) or
				nvl(trs.trs_show_type, 0)     <> nvl(grs.grs_show_type, 0) or
				nvl(trs.trs_theme, 0)         <> nvl(grs.grs_theme, 0) or
				nvl(trs.trs_gen_category, 0)  <> nvl(grs.grs_gen_category, 0) or
				nvl(trs.trs_sub_genre, 0)     <> nvl(grs.grs_sub_genre, 0) or
				nvl(trs.trs_actors, 0)        <> nvl(grs.grs_actors, 0) or
				nvl(trs.trs_director, 0)      <> nvl(grs.grs_director, 0) or
				nvl(trs.trs_ser_number, 0)    <> nvl(grs.grs_ser_number, 0) or
				nvl(trs.trs_ser_synopsis, 0)  <> nvl(grs.grs_ser_synopsis, 0) or
				nvl(trs.trs_sea_number, 0)    <> nvl(grs.grs_sea_number, 0) or
				nvl(trs.trs_sea_synopsis, 0)  <> nvl(grs.grs_sea_synopsis, 0) or
				nvl(trs.trs_epi_count, 0)     <> nvl(grs.grs_epi_count, 0) or
				nvl(trs.trs_advisories, 0)    <> nvl(grs.grs_advisories, 0) or
				nvl(trs.trs_orig_country, 0)  <> nvl(grs.grs_orig_country, 0) or
				nvl(trs.trs_release_year, 0)  <> nvl(grs.grs_release_year, 0) or
				nvl(trs.trs_com_short_name, 0)<> nvl(grs.grs_com_short_name, 0) or
				nvl(trs.trs_com_name, 0)      <> nvl(grs.grs_com_name, 0) or
				/*nvl(trs.trs_lin_sch_date, trs.trs_sch_created) <>
				nvl(grs.grs_lin_sch_date, trs.trs_sch_created) or*/
				nvl(trs.trs_tap_uid_audio, 0)   <> nvl(grs.grs_tap_uid_audio, 0) or
				nvl(trs.trs_tap_uid_version, 0) <> nvl(grs.grs_tap_uid_version, 0) or
				nvl(trs.trs_tap_aspect_ratio, 0)<> nvl(grs.grs_tap_aspect_ratio, 0) or
				nvl(trs.trs_tap_uid_lang, 0)    <> nvl(grs.grs_tap_uid_lang, 0) or
				nvl(trs.trs_gen_duration_c, 0)  <> nvl(grs.grs_gen_duration_c, 0) or
                nvl(trs.trs_bouquet_codes,0)    <> nvl(grs.grs_bouquet_codes,0) or
				nvl(trs.trs_Gen_Catchup_Priority, 0)  <> nvl(grs.grs_Gen_Catchup_Priority, 0) or
        nvl(trs.trs_Gen_Catchup_Category,0)    <> nvl(grs.grs_Gen_Catchup_Category,0) or
        nvl(trs.trs_express,0)  <>  nvl(grs.grs_express,0) or
      ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
        trs.trs_title_version   <> grs.grs_title_version or
        trs.trs_season_version  <>  grs.grs_season_version or
        trs.trs_ser_version   <>   grs.grs_ser_version
        ---Req Id : BR_15_363: END
				)
			and 	trs_sch_plan_month = l_plan_month
			and exists (select 1
                  from x_cl_gtt_release_schedule
                  where grs_error_type <>  DECODE(l_is_super_user,0,'M','X')
                  and grs_bin_id = trs.trs_bin_id
                  )
			WHEN NOT MATCHED THEN
			INSERT
			(	trs_bin_id,
				trs_lic_number,
				trs_service_code,
				trs_vod_type,
				trs_sch_plan_month,
				trs_sch_created,
				trs_crud,
				trs_gen_refno,
				trs_tap_barcode,
				trs_region_code,
				trs_countries,
				trs_ser_title,
				trs_gen_title,
				trs_season_number,
				trs_epi_number,
				trs_mpaa_rating,
				trs_lin_cha,
				trs_hd_sd_title,
				trs_title_synopsis,
				trs_show_type,
				trs_theme,
				trs_gen_category,
				trs_sub_genre,
				trs_actors,
				trs_director,
				trs_ser_number,
				trs_ser_synopsis,
				trs_sea_number,
				trs_sea_synopsis,
				trs_epi_count,
				trs_advisories,
				trs_orig_country,
				trs_release_year,
				trs_com_short_name,
				trs_com_name,
				trs_lin_sch_date,
				trs_tap_uid_audio,
				trs_tap_uid_version,
				trs_tap_aspect_ratio,
				trs_tap_uid_lang,
				trs_gen_duration_c,
				trs_curr_flag,
				trs_entry_oper,
				trs_entry_date,
				trs_bouquet_codes,
				trs_Gen_Catchup_Priority,
				trs_Gen_Catchup_Category,
        trs_express,
    ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
        trs.trs_title_version,
        trs.trs_season_version,
        trs.trs_Ser_version
    ---Req Id : BR_15_363: END
			)
			VALUES
			(	grs.grs_bin_id,
				grs.grs_lic_number,
				grs.grs_service_code,
				grs.grs_vod_type,
				grs.grs_sch_plan_month,
				grs.grs_sch_created,
				'I',
				grs.grs_gen_refno,
				grs.grs_tap_barcode,
				grs.grs_region_code,
				grs.grs_countries,
				grs.grs_ser_title,
				grs.grs_gen_title,
				grs.grs_season_number,
				grs.grs_epi_number,
				grs.grs_mpaa_rating,
				grs.grs_lin_cha,
				grs.grs_hd_sd_title,
				grs.grs_title_synopsis,
				grs.grs_show_type,
				grs.grs_theme,
				grs.grs_gen_category,
				grs.grs_sub_genre,
				grs.grs_actors,
				grs.grs_director,
				grs.grs_ser_number,
				grs.grs_ser_synopsis,
				grs.grs_sea_number,
				grs.grs_sea_synopsis,
				grs.grs_epi_count,
				grs.grs_advisories,
				grs.grs_orig_country,
				grs.grs_release_year,
				grs.grs_com_short_name,
				grs.grs_com_name,
				grs.grs_lin_sch_date,
				grs.grs_tap_uid_audio,
				grs.grs_tap_uid_version,
				grs.grs_tap_aspect_ratio,
				grs.grs_tap_uid_lang,
				grs.grs_gen_duration_c,
				'C',
				i_sch_entry_opr,
				sysdate,
                grs.grs_bouquet_codes,
				grs.Grs_Gen_Catchup_Priority,
				grs.Grs_Gen_Catchup_Category,
        grs.grs_express,
      ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
        grs.grs_title_version,
        grs.grs_season_version,
        grs.grs_ser_version
        ---Req Id : BR_15_363: END
			);

      /*Above merge statement is used to merge those records which are already present or or newly inserted. It does not cater delete operation*/
      /*Release Records as Deleted 'D' which were present in previous release and has been deleted*/

      /*nsert data into X_CL_RELEASE_SCHEDULE table as deleted 'D' which were present in previous release and has been deleted
			i.e. insert such records into X_CL_RELEASE_SCHEDULE which are present in temp table(bin) but currently not present in GTT(bin), because some one must have deleted those records so that GTT could not capture it.
					But these records are still present in temp(bin) table. So they must be marked as deleted. Hence insert them in release schedule with flag as 'D'(deleted)*/
			l_sqlstmnt := 'insert into x_cl_release_schedule
			(	crs_bin_id,
				crs_lic_number,
				crs_service_code,
				crs_vod_type,
				crs_sch_plan_month,
				crs_sch_created,
				crs_crud,
				crs_gen_refno,
				crs_tap_barcode,
				crs_region_code,
				crs_countries,
				crs_ser_title,
				crs_gen_title,
				crs_season_number,
				crs_epi_number,
				crs_mpaa_rating,
				crs_lin_cha,
				crs_hd_sd_title,
				crs_title_synopsis,
				crs_show_type,
				crs_theme,
				crs_gen_category,
				crs_sub_genre,
				crs_actors,
				crs_director,
				crs_ser_number,
				crs_ser_synopsis,
				crs_sea_number,
				crs_sea_synopsis,
				crs_epi_count,
				crs_advisories,
				crs_orig_country,
				crs_release_year,
				crs_com_short_name,
				crs_com_name,
				crs_lin_sch_date,
				crs_tap_uid_audio,
				crs_tap_uid_version,
				crs_tap_aspect_ratio,
				crs_tap_uid_lang,
				crs_gen_duration_c,
				crs_curr_flag,
				crs_entry_oper,
				crs_entry_date,
				crs_session_id,
				crs_bouquet_codes,
				crs_release_flag,
				crs_process_priority,
				Crs_Gen_Catchup_Priority,
				crs_Gen_Catchup_Category,
        crs_express
			)
			SELECT trs_bin_id,
				trs_lic_number,
				trs_service_code,
				trs_vod_type,
				trs_sch_plan_month,
				trs_sch_created,
				''D'',
				trs_gen_refno,
				trs_tap_barcode,
				trs_region_code,
				trs_countries,
				trs_ser_title,
				trs_gen_title,
				trs_season_number,
				trs_epi_number,
				trs_mpaa_rating,
				trs_lin_cha,
				trs_hd_sd_title,
				trs_title_synopsis,
				trs_show_type,
				trs_theme,
				trs_gen_category,
				trs_sub_genre,
				trs_actors,
				trs_director,
				trs_ser_number,
				trs_ser_synopsis,
				trs_sea_number,
				trs_sea_synopsis,
				trs_epi_count,
				trs_advisories,
				trs_orig_country,
				trs_release_year,
				trs_com_short_name,
				trs_com_name,
				trs_lin_sch_date,
				trs_tap_uid_audio,
				trs_tap_uid_version,
				trs_tap_aspect_ratio,
				trs_tap_uid_lang,
				trs_gen_duration_c,
				''C'',
				trs_entry_oper,
				trs_entry_date,
				'||l_session||',
				trs_bouquet_codes,
				''N'',
				null,
				trs_Gen_Catchup_Priority,
				trs_Gen_Catchup_Category,
        trs_express
			FROM x_cl_temp_release_schedule h
			WHERE  trs_sch_plan_month = '''||l_plan_month||'''';

      IF (i_screen_flag <> 'A')
      THEN
      l_sqlstmnt := l_sqlstmnt ||
			' AND not exists ( select 1
                             from X_CL_RELEASE_LATER R
                             where   CRL_BIN_ID = trs_bin_id
                             and   crl_language = tRS_TAP_UID_LANG
                             AND   CRL_SCH_PLAN_MONTH  = '''||l_plan_month||'''
                             and nvl(CRL_PROCESS_FLAG,''N'')=''N''
                             and to_char(crl_entry_date, ''DD-MON-YYYY'') = to_char(sysdate, ''DD-MON-YYYY'')';
      ELSE
      l_sqlstmnt := l_sqlstmnt ||
			' AND exists (select 1
                             from X_CL_RELEASE_LATER R
                             where   CRL_BIN_ID = trs_bin_id
                             and   crl_language = tRS_TAP_UID_LANG
                             AND   CRL_SCH_PLAN_MONTH  = '''||l_plan_month||'''
                             and nvl(CRL_PROCESS_FLAG,''N'')=''N''
                             and to_char(crl_entry_date, ''DD-MON-YYYY'') = to_char(sysdate, ''DD-MON-YYYY'')';
      END IF;

      l_sqlstmnt := l_sqlstmnt ||
      ')
			AND  exists (select 1
						from fid_license
							,fid_licensee
							,x_user_service_map
						where lic_lee_number = lee_number
						and lee_media_service_code =  x_usm_media_service_code
						and lic_number = trs_lic_number';

            IF (i_screen_flag <> 'A')
            THEN
              l_sqlstmnt := l_sqlstmnt || ' and upper(x_usm_user_id) = upper('''||i_sch_entry_opr||''')';
            END IF;
					 l_sqlstmnt := l_sqlstmnt || ')
			AND not exists (	select 1
						from x_cl_gtt_release_schedule
						where grs_bin_id = h.trs_bin_id
						and grs_sch_plan_month = h.trs_sch_plan_month
						and grs_tap_uid_lang = trs_tap_uid_lang
    				)';
			l_sqlstmnt := l_sqlstmnt ||
      			'AND   exists (select  1
								from x_cp_play_list
								where PLT_BIN_ID =  h.trs_bin_id
								GROUP BY plt_bin_id
								having to_char(max(PLT_SCH_END_DATE),''RRRRMMDD'') >= to_char(sysdate,''RRRRMMDD''))
								';


      --DBMS_OUTPUT.put_line(l_sqlstmnt);
      execute immediate l_sqlstmnt;


      /*Delete the records with CRUD 'D' from Static Temp
			i.e. delete from X_CL_TEMP_RELEASE_SCHEDULE using X_CL_RELEASE_SCHEDULE. i.e we have inserted schedules to be deleted in above statement. Now use same data to delete corrosponding records frpm temp(bin) table also.
					Because this is a stale data. And it must be deleted.			*/
      /*Delete the records with CRUD 'D' from Static Temp*/
			delete from x_cl_temp_release_schedule
			where trs_sch_plan_month = l_plan_month
			and trs_bin_id in (	select crs_bin_id from x_cl_release_schedule
						where crs_crud = 'D'
						and crs_curr_flag ='C'
						);

      /*now insert into X_CL_RELEASE_SCHEDULE from X_CL_TEMP_RELEASE_SCHEDULE whose trs_curr_flag = 'C' for the given planned month
			i.e now populate records in X_CL_RELEASE_SCHEDULE table which were merged in the previous statement. This will populate newly inserted and updated records for final release
			*/
			insert into x_cl_release_schedule
			select trs_bin_id
				,trs_lic_number
				,trs_service_code
				,trs_vod_type
				,trs_sch_plan_month
				,trs_sch_created
				,trs_crud
				,trs_gen_refno
				,trs_tap_barcode
				,trs_region_code
				,trs_countries
				,trs_ser_title
				,trs_gen_title
				,trs_season_number
				,trs_epi_number
				,trs_mpaa_rating
				,trs_lin_cha
				,trs_hd_sd_title
				,trs_title_synopsis
				,trs_show_type
				,trs_theme
				,trs_gen_category
				,trs_sub_genre
				,trs_actors
				,trs_director
				,trs_ser_number
				,trs_ser_synopsis
				,trs_sea_number
				,trs_sea_synopsis
				,trs_epi_count
				,trs_advisories
				,trs_orig_country
				,trs_release_year
				,trs_com_short_name
				,trs_com_name
				,trs_lin_sch_date
				,trs_tap_uid_audio
				,trs_tap_uid_version
				,trs_tap_aspect_ratio
				,trs_tap_uid_lang
				,trs_gen_duration_c
				,trs_curr_flag
				,trs_entry_oper
				,trs_entry_date
				,l_session
                ,trs_bouquet_codes
				,'N'
				,null
				,trs_Gen_Catchup_Priority
				,trs_Gen_Catchup_Category
        ,trs_express
        ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
        ,TRS_TITLE_VERSION
        ,TRS_SEASON_VERSION
        ,TRS_SER_VERSION
        --Req Id : BR_15_363: END
			from x_cl_temp_release_schedule
			where trs_curr_flag = 'C'
			and trs_sch_plan_month =l_plan_month;

			/*to find the entries that are updated in one table and not in the other */

			insert into x_cl_release_schedule
			(	crs_bin_id,
				crs_lic_number,
				crs_service_code,
				crs_vod_type,
				crs_sch_plan_month,
				crs_sch_created,
				crs_crud,
				crs_gen_refno,
				crs_tap_barcode,
				crs_region_code,
				crs_countries,
				crs_ser_title,
				crs_gen_title,
				crs_season_number,
				crs_epi_number,
				crs_mpaa_rating,
				crs_lin_cha,
				crs_hd_sd_title,
				crs_title_synopsis,
				crs_show_type,
				crs_theme,
				crs_gen_category,
				crs_sub_genre,
				crs_actors,
				crs_director,
				crs_ser_number,
				crs_ser_synopsis,
				crs_sea_number,
				crs_sea_synopsis,
				crs_epi_count,
				crs_advisories,
				crs_orig_country,
				crs_release_year,
				crs_com_short_name,
				crs_com_name,
				crs_lin_sch_date,
				crs_tap_uid_audio,
				crs_tap_uid_version,
				crs_tap_aspect_ratio,
				crs_tap_uid_lang,
				crs_gen_duration_c,
				crs_curr_flag,
				crs_entry_oper,
				crs_entry_date,
				crs_session_id,
				crs_bouquet_codes,
				crs_release_flag,
				crs_process_priority,
				Crs_Gen_Catchup_Priority,
				crs_Gen_Catchup_Category,
        crs_express,
       ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
        CRS_TITLE_VERSION,
        CRS_SEASON_VERSION,
        CRS_SER_VERSION
        --Req Id : BR_15_363: END
			)
			SELECT grs_bin_id,
				grs_lic_number,
				grs_service_code,
				grs_vod_type,
				grs_sch_plan_month,
				grs_sch_created,
				'U',
				grs_gen_refno,
				grs_tap_barcode,
				grs_region_code,
				grs_countries,
				grs_ser_title,
				grs_gen_title,
				grs_season_number,
				grs_epi_number,
				grs_mpaa_rating,
				grs_lin_cha,
				grs_hd_sd_title,
				grs_title_synopsis,
				grs_show_type,
				grs_theme,
				grs_gen_category,
				grs_sub_genre,
				grs_actors,
				grs_director,
				grs_ser_number,
				grs_ser_synopsis,
				grs_sea_number,
				grs_sea_synopsis,
				grs_epi_count,
				grs_advisories,
				grs_orig_country,
				grs_release_year,
				grs_com_short_name,
				grs_com_name,
				grs_lin_sch_date,
				grs_tap_uid_audio,
				grs_tap_uid_version,
				grs_tap_aspect_ratio,
				grs_tap_uid_lang,
				grs_gen_duration_c,
				'C',
				grs_entry_oper,
				grs_entry_date,
				l_session,
                grs_bouquet_codes,
				'N',
				null,
				Grs_Gen_Catchup_Priority,
				Grs_Gen_Catchup_Category,
        grs_express,
       ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
        GRS_TITLE_VERSION,
        GRS_SEASON_VERSION,
        GRS_SER_VERSION
        --Req Id : BR_15_363: END
			FROM	x_cl_gtt_release_schedule grs
			WHERE exists 	(select crd.crd_bin_id
                      from x_cl_rel_sch_detail crd
                      where crd.crd_curr_flag = 'C'
                      and crd.crd_bin_id  = grs.grs_bin_id
                      and crd.crd_sch_plan_month = l_plan_month
                     )
			AND NOT EXISTS
						(	select 1
							from x_cl_release_schedule crs
							where crs.crs_bin_id = grs.grs_bin_id
							and crs.crs_session_id=l_session
							--and crs.crs_curr_flag = 'C'
						)
			AND grs_error_type <> DECODE(l_is_super_user,'0','M','X')
			;

      /*insert into X_CL_REL_SCH_DETAIL from X_CL_GTT_REL_SCH_DETAIL those records which exists in X_CL_RELEASE_SCHEDULE with crs_curr_flag = 'C' and do not exist in X_CL_REL_SCH_DETAIL
				i.e. insert into playlist level release whose parent records exists in bin level release*/
			INSERT INTO X_CL_REL_SCH_DETAIL
			(	crd_bin_id,
				crd_lic_number,
				crd_plat_code,
				crd_dev_id,
				crd_sch_start_date,
				crd_sch_end_date,
				crd_curr_flag,
				crd_crud,
				crd_entry_oper,
				crd_entry_date,
			    crd_session_id,
				Crd_Sch_Plan_Month,
				Crd_Push_Start_Date,
				Crd_Pull_Start_Date,
				Crd_Push_End_Date,
				crd_Pull_End_Date,
        --IXS START - Sagar Sonawane 30-Jan-2016
        CRD_PLT_ID
      --IXS END
			)
			SELECT h.grd_bin_id,
				h.grd_lic_number,
				h.grd_plat_code,
				h.grd_dev_id,
				h.grd_sch_start_date,
				h.grd_sch_end_date,
				'C',
				'U',
				i_sch_entry_opr,
				sysdate,
        		l_session,
				H.Grd_Sch_Plan_Month,
				H.Grd_Push_Start_Date,
				H.Grd_Pull_Start_Date,
				H.Grd_Push_End_Date,
				h.Grd_Pull_End_Date,
        --IXS START - Sagar Sonawane 30-Jan-2016
        h.grd_plt_id
        --IXS END
			FROM	x_cl_gtt_rel_sch_detail h
			WHERE h.grd_bin_id in
					(	select crs.crs_bin_id
						from	x_cl_release_schedule crs
						where crs.crs_curr_flag = 'C'
						and crs.crs_session_id = l_session
					)
			AND NOT EXISTS	(SELECT 1
						FROM x_cl_rel_sch_detail crd
						WHERE crd.crd_bin_id = h.grd_bin_id
						AND crd.crd_curr_flag = 'C'
						AND  crd.crd_dev_id = h.grd_dev_id
						AND crd.crd_session_id = l_session
					);

      --IXS START - Sagar Sonawane 30-Jan-2016
      /*insert into X_CL_RELEASE_TERR_BOUQ_DTL from X_CL_GTT_TERR_BOUQ_DTL
				i.e. This has been written because there can be a scenario where bin level information has been changed hence corrosponding bouquet information must get populated in bouquet level release table
				*/
      INSERT INTO x_cl_release_terr_bouq_dtl
			(   rbd_plt_id,
          rbd_bin_id,
          rbd_bouquet_code,
          rbd_ter_code,
          rbd_pvr_start_date,
          rbd_pvr_end_date,
          rbd_ott_start_date,
          rbd_ott_end_date,
          rbd_subbouquet_name,
          rbd_curr_flag,
          rbd_crud,
          rbd_sch_plan_month,
          rbd_entry_oper,
          rbd_entry_date
			)
			SELECT
      	  gbd.gbd_plt_id,
          gbd.gbd_bin_id,
          gbd.gbd_bouquet_code,
          gbd.gbd_ter_code,
          gbd.gbd_pvr_start_date,
          gbd.gbd_pvr_end_date,
          gbd.gbd_ott_start_date,
          gbd.gbd_ott_end_date,
          gbd.gbd_subbouquet_name,
          'C',
          'U',
          gbd.gbd_sch_plan_month,
          i_sch_entry_opr,
          sysdate
      FROM	x_cl_gtt_terr_bouq_dtl gbd
			WHERE gbd.gbd_bin_id in
					(	select crs.crs_bin_id
						from	x_cl_release_schedule crs
						where crs.crs_curr_flag = 'C'
						and crs.crs_session_id = l_session
					)
			AND NOT EXISTS	(SELECT 1
						FROM x_cl_release_terr_bouq_dtl rbd
						WHERE rbd.rbd_bin_id = gbd.gbd_bin_id
						AND rbd.rbd_curr_flag = 'C'
						AND  rbd.rbd_plt_id = gbd.gbd_plt_id
            AND rbd.rbd_bouquet_code = gbd.gbd_bouquet_code
						AND rbd.rbd_session_id = l_session
					);
      --IXS END
		END IF;


    --IXS START - Sagar Sonawane 31-Jan-2016
    /*update processed flag as 'p' in X_CL_BACKUP_REL_SCHEDULE table for the given planned month and records not exist in the bin release table X_CL_RELEASE_SCHEDULE*/
    /*i.e those records are marked as processed in back up table which are not changed after merge operation.
    because in subsequent release there is no need to restore them in temp tables*/
    update x_cl_backup_rel_schedule
    set brs_process_flag = 'P'
    where Brs_Sch_Plan_Month = l_plan_month
    and BRS_BIN_ID IS NOT NULL
    and not exists (Select 1
        From x_cl_release_schedule
        where Crs_Sch_Plan_Month = l_plan_month
        And Crs_Session_Id = l_session
        and crs_bin_id = brs_bin_id
        and crs_tap_uid_lang = brs_tap_uid_lang
        );
    --IXS END

    commit;

		open o_schedule_data for
		Select Crs_Region_Code Licensee
		,Crs_Gen_Refno
		,crs_hd_sd_title Crs_Gen_Title
		,Crs_Crud
		,crs_Gen_Catchup_Category Crs_Service_Code
		,Crs_Gen_Catchup_Priority Crs_Catchup_Priority
		,Null Crs_Process_Priority
		,CRS_SCH_CREATED ScheduleStartDate
		,Crs_Tap_Uid_Lang
		,Crs_Tap_Barcode
		,Crs_Bouquet_Codes
		,Crs_Bin_Id
		,crs_session_id
		,(select Grs_Warnings
		  from X_Cl_Gtt_Release_Schedule
		  where Grs_Bin_Id = crs_Bin_Id
		  And  Grs_Tap_Uid_Lang	= crs_Tap_Uid_Lang
		) warnings
		,crs_sch_plan_month
      ,(SELECT FIRST_VALue(RS.CRS_ENTRY_DATE)OVER(PARTITION BY RS.CRS_BIN_ID ORDER BY RS.CRS_ENTRY_DATE desc)
      FROM X_CL_RELEASE_SCHEDULE  RS
      WHERE RS.CRS_SESSION_ID = (SELECT MAX(IAR_SESSION_ID) FROM X_CL_IXS_API_RELEASE WHERE IAR_BIN_ID = cs.Crs_Bin_Id AND IAR_STATUS <> 'P') 
      and RS.CRS_BIN_ID = cs.Crs_Bin_Id 
      AND RS.CRS_TAP_BARCODE=cs.CRS_TAP_BARCODE
      AND RS.CRS_LIC_NUMBER=cs.CRS_LIC_NUMBER)  Modified_on ---Added by Rashmi for VOD Changes
    ,(SELECT FIRST_VALue(RS.CRS_ENTRY_OPER)OVER(PARTITION BY RS.CRS_BIN_ID ORDER BY RS.CRS_ENTRY_DATE desc)
      FROM X_CL_RELEASE_SCHEDULE  RS
      WHERE RS.CRS_SESSION_ID = (SELECT MAX(IAR_SESSION_ID) FROM X_CL_IXS_API_RELEASE WHERE IAR_BIN_ID = cs.Crs_Bin_Id AND IAR_STATUS <> 'P') 
      and RS.CRS_BIN_ID = cs.Crs_Bin_Id 
      AND RS.CRS_TAP_BARCODE=cs.CRS_TAP_BARCODE
      AND RS.CRS_LIC_NUMBER=cs.CRS_LIC_NUMBER) Last_Modified_by ---Added by Rashmi for VOD Changes
		from  x_cl_release_schedule Cs
		where crs_session_id = l_session
   		 order by CRS_SCH_CREATED
		;

	END X_PRC_SEARCH_REL_SCHEDULE;


	PROCEDURE x_prc_release_schedule
	(	i_release_data			IN      x_typ_sch_release_rec
		,i_sch_entry_opr		IN		X_CL_GTT_REL_SCH_DETAIL.GRD_ENTRY_OPER%type
		,i_session_id			IN		x_cl_release_schedule.crs_session_id%type
		,i_plan_month			IN		x_cl_temp_release_schedule.trs_sch_plan_month%type
    ,i_release_flag       IN    VARCHAR2 DEFAULT 'W'
		--,o_schedule_rel_data	OUT		X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
		--,o_ftpdetails			OUT		X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
	)
	as
		l_str_table_script varchar2(32767);
		l_str_column_name varchar2(32767);
		l_dynamic_query varchar2(32767);
		l_release_cnt number;
		l_tcr_Bin_Id number;
		l_tcr_process_priority number;
		l_Tcr_Tap_Uid_Lang varchar2(50);
	begin
		if i_release_data.count = 0
		then
				delete from x_cl_release_schedule where crs_session_id = i_session_id;

				delete from x_cl_temp_release_schedule
				where trs_sch_plan_month = i_plan_month
				;

				insert into x_cl_temp_release_schedule
				select BRS_BIN_ID,BRS_LIC_NUMBER,BRS_SERVICE_CODE,BRS_VOD_TYPE,BRS_SCH_PLAN_MONTH,BRS_SCH_CREATED,BRS_CRUD,BRS_GEN_REFNO,BRS_TAP_BARCODE,BRS_REGION_CODE,BRS_COUNTRIES,BRS_SER_TITLE,BRS_GEN_TITLE,BRS_SEASON_NUMBER,BRS_EPI_NUMBER,BRS_MPAA_RATING,BRS_LIN_CHA,BRS_HD_SD_TITLE,BRS_TITLE_SYNOPSIS,BRS_SHOW_TYPE,BRS_THEME,BRS_GEN_CATEGORY,BRS_SUB_GENRE,BRS_ACTORS,BRS_DIRECTOR,BRS_SER_NUMBER,BRS_SER_SYNOPSIS,BRS_SEA_NUMBER,BRS_SEA_SYNOPSIS,BRS_EPI_COUNT,BRS_ADVISORIES,BRS_ORIG_COUNTRY,BRS_RELEASE_YEAR,BRS_COM_SHORT_NAME,BRS_COM_NAME,BRS_LIN_SCH_DATE,BRS_TAP_UID_AUDIO,BRS_TAP_UID_VERSION,BRS_TAP_ASPECT_RATIO,BRS_TAP_UID_LANG,BRS_GEN_DURATION_C,BRS_CURR_FLAG,BRS_ENTRY_OPER,BRS_ENTRY_DATE,BRS_BOUQUET_CODES,BRS_GEN_CATCHUP_PRIORITY,BRS_GEN_CATCHUP_CATEGORY,BRS_EXPRESS
         ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
              ,BRS_TITLE_VERSION
              ,BRS_SEASON_VERSION
              ,BRS_SER_VERSION
              --Req Id : BR_15_363:END
        from x_cl_backup_rel_schedule
				where brs_sch_plan_month = i_plan_month
				;

        --IXS START - Sagar Sonawane 31-Jan-2016
        delete from X_CL_REL_SCH_DETAIL where CRD_SESSION_ID = i_session_id;
        --IXS END

				delete from x_cl_temp_rel_sch_detail
				where trd_sch_plan_month = i_plan_month
				;

				insert into x_cl_temp_rel_sch_detail
				select * from x_cl_backup_rel_sch_detl
				where brd_sch_plan_month = i_plan_month
				;

         --IXS START - Sagar Sonawane 31-Jan-2016

        delete from x_cl_release_terr_bouq_dtl where rbd_session_id = i_session_id;

        delete from x_cl_temp_terr_bouq_dtl
        where tbd_sch_plan_month = i_plan_month;

				insert into x_cl_temp_terr_bouq_dtl
				select * from x_cl_backup_terr_bouq_dtl
				where bbd_sch_plan_month = i_plan_month				;

        --IXS END

				raise_application_error (-20100, 'Cannot release the schedule for '||i_plan_month||' as there are no records to release.');
		else
			FOR i IN i_release_data.FIRST .. i_release_data.LAST
			LOOP


					Select Max(tcr_Bin_Id),Max(tcr_process_priority),Max(Tcr_Tap_Uid_Lang)
					into l_tcr_Bin_Id,l_tcr_process_priority,l_Tcr_Tap_Uid_Lang
					from (
						Select (Case When Rownum = 1 Then Column_Value Else Null End )tcr_Bin_Id
							  ,(Case When Rownum = 2 Then Column_Value Else Null End )tcr_process_priority
							  ,(Case When Rownum = 3 Then Column_Value Else Null End )Tcr_Tap_Uid_Lang
						From Table(X_Pkg_Cm_Split_String.Split_To_Char(i_release_data(i)))
						);

					update x_cl_release_schedule
					set crs_release_flag =	'Y'
					    ,crs_process_priority = l_tcr_process_priority
					where CRS_SESSION_ID = i_session_id
					and CRS_BIN_ID = l_tcr_Bin_Id
					and CRS_TAP_UID_LANG = l_Tcr_Tap_Uid_Lang
					;
			end loop;


			delete from x_cl_release_schedule
			where crs_session_id = i_session_id
			and Crs_Sch_Plan_Month = I_Plan_Month
			and nvl(Crs_Release_Flag,'N') = 'N'
			;

			delete from x_cl_rel_sch_detail
			where crd_curr_flag = 'C'
			and crd_session_id = i_session_id
			and not exists ( select 1
							From x_cl_release_schedule
							Where Crs_Release_Flag = 'Y'
							And Crs_Sch_Plan_Month = I_Plan_Month
							And Crs_Session_Id = I_Session_Id
							and crs_bin_id = crd_bin_id
							);

      --IXS START - Sagar Sonawane 31-Jan-2016

      delete from x_cl_release_terr_bouq_dtl
      where rbd_curr_flag = 'C'
      and rbd_session_id = i_session_id
      and not exists ( select 1
							From x_cl_release_schedule
							Where Crs_Release_Flag = 'Y'
							And Crs_Sch_Plan_Month = I_Plan_Month
							And Crs_Session_Id = I_Session_Id
							and crs_bin_id = rbd_bin_id
							);
      --IXS END

			delete from x_cl_temp_release_schedule
			where trs_sch_plan_month = i_plan_month
			and not exists ( Select 1
							From x_cl_release_schedule
							Where Crs_Release_Flag = 'Y'
							And Crs_Sch_Plan_Month = i_plan_month
							And Crs_Session_Id = I_Session_Id
							and crs_bin_id = trs_bin_id
							and CRS_TAP_UID_LANG = tRS_TAP_UID_LANG
							);

			insert into x_cl_temp_release_schedule
			select BRS_BIN_ID,BRS_LIC_NUMBER,BRS_SERVICE_CODE,BRS_VOD_TYPE,BRS_SCH_PLAN_MONTH,BRS_SCH_CREATED,BRS_CRUD,BRS_GEN_REFNO,BRS_TAP_BARCODE,BRS_REGION_CODE,BRS_COUNTRIES,BRS_SER_TITLE,BRS_GEN_TITLE,BRS_SEASON_NUMBER,BRS_EPI_NUMBER,BRS_MPAA_RATING,BRS_LIN_CHA,BRS_HD_SD_TITLE,BRS_TITLE_SYNOPSIS,BRS_SHOW_TYPE,BRS_THEME,BRS_GEN_CATEGORY,BRS_SUB_GENRE,BRS_ACTORS,BRS_DIRECTOR,BRS_SER_NUMBER,BRS_SER_SYNOPSIS,BRS_SEA_NUMBER,BRS_SEA_SYNOPSIS,BRS_EPI_COUNT,BRS_ADVISORIES,BRS_ORIG_COUNTRY,BRS_RELEASE_YEAR,BRS_COM_SHORT_NAME,BRS_COM_NAME,BRS_LIN_SCH_DATE,BRS_TAP_UID_AUDIO,BRS_TAP_UID_VERSION,BRS_TAP_ASPECT_RATIO,BRS_TAP_UID_LANG,BRS_GEN_DURATION_C,BRS_CURR_FLAG,BRS_ENTRY_OPER,BRS_ENTRY_DATE,BRS_BOUQUET_CODES,BRS_GEN_CATCHUP_PRIORITY,BRS_GEN_CATCHUP_CATEGORY,BRS_EXPRESS
    ---Req Id : BR_15_363: For EPG Phase 1 :Start : [SUSHMA KOMULLA]_[2016/07/18]
              ,BRS_TITLE_VERSION
              ,BRS_SEASON_VERSION
              ,BRS_SER_VERSION
              --Req Id : BR_15_363:END
      from x_cl_backup_rel_schedule
			Where Brs_Sch_Plan_Month = I_Plan_Month
      			AND BRS_BIN_ID IS NOT NULL
			and not exists ( Select 1
							From x_cl_release_schedule
							Where Crs_Release_Flag = 'Y'
							And Crs_Sch_Plan_Month = i_plan_month
							And Crs_Session_Id = I_Session_Id
							and crs_bin_id = brs_bin_id
							and crs_tap_uid_lang = brs_tap_uid_lang
							);

          --IXS START - Sagar Sonawane 31-Jan-2016
          --process flag is set as P so that unselected records can be rolled back in next release
          update x_cl_backup_rel_schedule
          set brs_process_flag = 'P'
          where Brs_Sch_Plan_Month = I_Plan_Month
          and BRS_BIN_ID IS NOT NULL
      		and not exists ( Select 1
							From x_cl_release_schedule
							Where Crs_Release_Flag = 'Y'
							And Crs_Sch_Plan_Month = i_plan_month
							And Crs_Session_Id = I_Session_Id
							and crs_bin_id = brs_bin_id
							and crs_tap_uid_lang = brs_tap_uid_lang
							);
          --IXS END

			delete from x_cl_temp_rel_sch_detail
			where trd_sch_plan_month = i_plan_month
			and not exists ( Select 1
							From x_cl_release_schedule
							Where Crs_Release_Flag = 'Y'
							And Crs_Sch_Plan_Month = i_plan_month
							And Crs_Session_Id = I_Session_Id
							and crs_bin_id = trd_bin_id
							);

			insert into x_cl_temp_rel_sch_detail
			select * from x_cl_backup_rel_sch_detl
			where brd_sch_plan_month = i_plan_month
			and not exists ( Select 1
							From x_cl_release_schedule
							Where Crs_Release_Flag = 'Y'
							And Crs_Sch_Plan_Month = i_plan_month
							And Crs_Session_Id = I_Session_Id
							and crs_bin_id = brd_bin_id
							);

      --IXS START - Sagar Sonawane 31-Jan-2016
      delete from x_cl_temp_terr_bouq_dtl
      where tbd_sch_plan_month = i_plan_month
      and not exists ( select 1
              from x_cl_release_schedule
							Where Crs_Release_Flag = 'Y'
							And Crs_Sch_Plan_Month = i_plan_month
							And Crs_Session_Id = I_Session_Id
							and crs_bin_id = tbd_bin_id
							);


      insert into x_cl_temp_terr_bouq_dtl
			select * from x_cl_backup_terr_bouq_dtl
			where bbd_sch_plan_month = i_plan_month
			and not exists ( Select 1
							From x_cl_release_schedule
							Where Crs_Release_Flag = 'Y'
							And Crs_Sch_Plan_Month = i_plan_month
							And Crs_Session_Id = I_Session_Id
							and crs_bin_id = bbd_bin_id
							);
      --IXS END
		end if;

    --IXS START - Sagar Sonawane 31-Jan-2016
    --IAR_STATUS values can be P - Processed, N - Not Processed and F - Failed
      insert into X_CL_IXS_API_RELEASE
      (
        IAR_BIN_ID,
        IAR_LANGUAGE,
        IAR_STATUS,
        IAR_SESSION_ID,
        IAR_SCH_PLAN_MONTH,
        IAR_PROCESS_PRIORITY,
        IAR_GEN_CATCHUP_PRIORITY,
        IAR_SCH_CREATED,
        IAR_RELEASE_TYPE,
        IAR_STATUS_BEFORE_GOLIVE
      )
      select
          CRS_BIN_ID,
          CRS_TAP_UID_LANG,
          'N',
          I_Session_Id,
          i_plan_month,
          CRS_PROCESS_PRIORITY,
          CRS_GEN_CATCHUP_PRIORITY,
          CRS_SCH_CREATED,
          nvl(i_release_flag,'W'),
          'N'
      from x_cl_release_schedule
      where Crs_Release_Flag = 'Y'
      And Crs_Session_Id = I_Session_Id;
    --IXS END

			/*Code for Pivot Operation*/
			/*BEGIN
				l_str_table_script := 'select  CRS_SERVICE_CODE "mediaService"   ,CRS_VOD_TYPE "vodType"  ,TO_CHAR(to_date(CRS_SCH_PLAN_MONTH,''YYYYMM''),''MON-YYYY'')  "schedulePlanMonth" ,to_char(to_date('''||i_session_id||''',''YYYYMMDDHH24MISS''),''DD-MM-RRRR HH24:MI:SS'')  "datetimeScheduleCreated" ,CRS_CRUD "crud"  ,CRS_GEN_REFNO "genRef" ,CRS_TAP_BARCODE "uid" ,CRS_REGION_CODE "region" ,CRS_COUNTRIES "countries" ,CRS_SER_TITLE "seriesTitle" ,CRS_GEN_TITLE "title" ,CRS_SEASON_NUMBER "seasonNumber" ,CRS_EPI_NUMBER "episodeNumber" ,CRS_MPAA_RATING "pgRating" ,CRS_LIN_CHA "linearChannel"
				';
				for i in
				(	select  cl.dcl_column_name||d.md_short_name||'-'||c.mdc_short_name table_column_name
						,pl.mp_media_platform_code || '_' || d.md_code|| '_' ||replace(c.MDC_DESC_SHORT,' ','_') column_name
						,cl.dcl_short_name
						,cl.DCL_COLUMN_SEQ
					from X_CP_MEDIA_DEVICE             d,
						X_CP_MEDIA_DEV_PLATM_MAP      m,
						X_CP_MEDIA_DEVICE_COMPAT      c,
						SGY_PB_MEDIA_PLATFORM         PL,
						x_cp_med_platm_dev_compat_map dm,
						x_cl_detail_column_list cl
					where d.md_id = m.mdp_map_dev_id
					and dm.mpdc_dev_platm_id = d.md_id
					AND PL.MP_MEDIA_PLATFORM_CODE = m.mdp_map_platm_code
					and c.mdc_id = dm.mpdc_comp_rights_id
					and dm.MPDC_IS_COMP_RIGHTS ='Y'
					order by pl.mp_seq_no,d.md_seq_no,c.mdc_seq_no ,cl.DCL_COLUMN_SEQ
				)
    				loop
    					l_str_table_script  := l_str_table_script||' ,'||i.column_name||'_'||i.dcl_short_name||'   "'||i.table_column_name ||'"' ;

    					if  i.DCL_COLUMN_SEQ = 1
    					then
    						if l_str_column_name is null
    						then
    							l_str_column_name  :=  ''''||i.column_name||''''||' as '||i.column_name;

    						else
    							l_str_column_name  :=   l_str_column_name||','''||i.column_name||''''||' as '||i.column_name ;
    						end if;
    					end if;
    				end loop;
    					l_str_table_script  :=  l_str_table_script||'
    					,CRS_HD_SD_TITLE "hdsdPvrTitle" ,CRS_TITLE_SYNOPSIS "titleSynopsis" ,CRS_SHOW_TYPE "showType"  ,CRS_THEME "theme",CRS_GEN_CATEGORY "primaryGenre" ,CRS_SUB_GENRE "secondaryGenres" ,CRS_ACTORS "actors" ,CRS_DIRECTOR "director" ,CRS_SER_NUMBER "serId" ,CRS_SER_SYNOPSIS "seriesSynopsis" ,CRS_SEA_NUMBER "seasonId" ,CRS_SEA_SYNOPSIS "seasonSynopsis" ,CRS_EPI_COUNT "totalEpisodes" ,CRS_ADVISORIES "advisories" ,CRS_ORIG_COUNTRY "supplierCountry" ,CRS_RELEASE_YEAR "yearOfRelease"  ,CRS_COM_SHORT_NAME "studioCode" ,CRS_COM_NAME "studioName" ,CRS_LIN_SCH_DATE "linearStartdateTime" ,CRS_TAP_UID_AUDIO "audioType" ,CRS_TAP_UID_VERSION "format" ,CRS_TAP_ASPECT_RATIO "aspectRatio" ,CRS_TAP_UID_LANG "language" ,CRS_GEN_DURATION_C "runtimeMins", (select g.GEN_EPG_CONTENT_ID from fid_general g where g.gen_refno = CRS_GEN_REFNO) "epgcontentId",CRS_BOUQUET_CODES "bouquet" , crs_Gen_Catchup_Category "CatchupCategory", Crs_Gen_Catchup_Priority "CatchupPriority"
						,(case when CRS_PROCESS_PRIORITY = 1 then ''High''  when CRS_PROCESS_PRIORITY = 2 then ''Medium''  when CRS_PROCESS_PRIORITY = 3 then ''Low'' else null end) "ProcessPriority"';

    					--DBMS_OUTPUT.put_line(l_str_table_script);
    					--DBMS_OUTPUT.put_line(l_str_column_name);

    					l_dynamic_query :='
    				from	x_cl_release_schedule z
    					,((with tbl as
    						(SELECT CRD_BIN_ID,
    							L.CRD_PLAT_CODE,
    							L.CRD_DEV_ID,
    							D.MD_DESC,
    							C.MPDC_COMP_RIGHTS_ID,
    							COM.MDC_DESC,
    							to_char(L.CRD_SCH_START_DATE,''DD-MM-RRRR HH24:MI:SS'') CRD_SCH_START_DATE,
    							to_char(L.CRD_SCH_END_DATE,''DD-MM-RRRR HH24:MI:SS'') CRD_SCH_END_DATE
    						FROM   x_cp_media_dev_platm_map M
								  ,x_cp_med_platm_dev_compat_map C
								  ,x_cl_rel_sch_detail L
								  ,X_CP_MEDIA_DEVICE D
								  ,X_CP_MEDIA_DEVICE_COMPAT COM
								  ,x_cp_lic_medplatmdevcompat_map MM
    						WHERE  MPDC_DEV_PLATM_ID = MDP_MAP_ID
    						AND   CRD_PLAT_CODE = MDP_MAP_PLATM_CODE
    						AND   CRD_DEV_ID = MDP_MAP_DEV_ID
    						AND   D.MD_ID=MDP_MAP_DEV_ID
    						AND   COM.MDC_ID=C.MPDC_COMP_RIGHTS_ID
    						AND   MM.LIC_MPDC_LIC_NUMBER=L.CRD_LIC_NUMBER
                            AND   L.crd_dev_id=D.MD_ID
    						AND   MM.LIC_MPDC_DEV_PLATM_ID=C.mpdc_dev_platm_id
    						AND   COM.MDC_ID = lic_mpdc_comp_rights_id
                            AND   L.crd_curr_flag =''C''
    						AND   MM.lic_is_comp_rights =''Y''
                            AND   L.crd_dev_id <> 1
							UNION
							 SELECT CRD_BIN_ID,
									L.CRD_PLAT_CODE,
									L.CRD_DEV_ID,
									D.MD_DESC,
									C.MPDC_COMP_RIGHTS_ID,
									COM.MDC_DESC,
									--Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/26]
									to_char(crd_push_start_date,''DD-MM-RRRR HH24:MI:SS'') CRD_SCH_START_DATE,
									to_char(crd_push_end_date,''DD-MM-RRRR HH24:MI:SS'') CRD_SCH_END_DATE
							--Dev.R14 : Catchup 4 All Intrim : End
							FROM  x_cp_media_dev_platm_map M
									,x_cp_med_platm_dev_compat_map C
									,x_cl_rel_sch_detail L
									,X_CP_MEDIA_DEVICE D
									,X_CP_MEDIA_DEVICE_COMPAT COM
									,x_cp_lic_medplatmdevcompat_map MM
							WHERE  MPDC_DEV_PLATM_ID = MDP_MAP_ID
							AND  CRD_PLAT_CODE = MDP_MAP_PLATM_CODE
							AND  CRD_DEV_ID = MDP_MAP_DEV_ID
							AND  D.MD_ID=MDP_MAP_DEV_ID
							AND  COM.MDC_ID=C.MPDC_COMP_RIGHTS_ID
							AND  MM.LIC_MPDC_LIC_NUMBER=L.CRD_LIC_NUMBER
							AND  L.crd_dev_id=D.MD_ID
							AND  MM.LIC_MPDC_DEV_PLATM_ID=C.mpdc_dev_platm_id
							AND  COM.MDC_ID = lic_mpdc_comp_rights_id
							AND  L.crd_curr_flag =''C''
							AND  MM.lic_is_comp_rights =''Y''
							AND  L.crd_dev_id = 1
							AND  lic_mpdc_comp_rights_id = 1
							--Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/26]
							AND  (EXISTS (SELECT 1 FROM x_cp_play_list WHERE plt_dev_id = 1 AND plt_bin_id = CRD_BIN_ID AND plt_push_start_date IS NOT NULL)
									OR EXISTS (SELECT 1 FROM x_cp_exp_play_list WHERE epl_dev_id = 1 AND epl_bin_id = CRD_BIN_ID AND epl_push_start_date IS NOT NULL))
							--Dev.R14 : Catchup 4 All Intrim : End
							UNION
							  SELECT CRD_BIN_ID,
									 L.CRD_PLAT_CODE,
									 L.CRD_DEV_ID,
									 D.MD_DESC,
									 C.MPDC_COMP_RIGHTS_ID,
									 COM.MDC_DESC,
									 --Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/26]
									 to_char(crd_pull_start_date,''DD-MM-RRRR HH24:MI:SS'') CRD_SCH_START_DATE,
									to_char(crd_pull_end_date,''DD-MM-RRRR HH24:MI:SS'') CRD_SCH_END_DATE
									--Dev.R14 : Catchup 4 All Intrim : End
									FROM   x_cp_media_dev_platm_map M
										  ,x_cp_med_platm_dev_compat_map C
										  ,x_cl_rel_sch_detail L
										  ,X_CP_MEDIA_DEVICE D
										  ,X_CP_MEDIA_DEVICE_COMPAT COM
										  ,x_cp_lic_medplatmdevcompat_map MM
								   WHERE  MPDC_DEV_PLATM_ID = MDP_MAP_ID
									AND   CRD_PLAT_CODE = MDP_MAP_PLATM_CODE
									AND   CRD_DEV_ID = MDP_MAP_DEV_ID
									AND   D.MD_ID=MDP_MAP_DEV_ID
									AND   COM.MDC_ID=C.MPDC_COMP_RIGHTS_ID
									AND   MM.LIC_MPDC_LIC_NUMBER=L.CRD_LIC_NUMBER
									AND   L.crd_dev_id=D.MD_ID
									AND   MM.LIC_MPDC_DEV_PLATM_ID=C.mpdc_dev_platm_id
									AND   COM.MDC_ID = lic_mpdc_comp_rights_id
									AND   L.crd_curr_flag =''C''
									AND   MM.lic_is_comp_rights =''Y''
									AND   L.crd_dev_id = 1
									AND   lic_mpdc_comp_rights_id IN (2,3)
									--Dev.R14 : Catchup 4 All Intrim : Start : [BR_15_212]_[Devashish Raverkar]_[2015/08/26]
									AND (EXISTS (SELECT 1 FROM x_cp_play_list WHERE plt_dev_id = 1 AND plt_bin_id = CRD_BIN_ID AND plt_pull_start_date IS NOT NULL)
									 OR EXISTS (SELECT 1 FROM x_cp_exp_play_list WHERE epl_dev_id = 1 AND epl_bin_id = CRD_BIN_ID AND epl_pull_start_date IS NOT NULL))
									--Dev.R14 : Catchup 4 All Intrim : End
							)
    					select CRD_BIN_ID,generatecolumns,Platform,device,compat,CRD_SCH_START_DATE,CRD_SCH_END_DATE from
    					(select rownum rn,CRD_BIN_ID
    						,pl.mp_media_platform_code || ''_'' || d.md_code|| ''_'' || c.MDC_DESC_SHORT  as generatecolumns
    						,d.md_id device_id
    						,d.md_code                 device
    						,pl.mp_media_platform_code platform
    						,c.mdc_id                  compat_id
    						,c.mdc_desc                compat
    						,c.mdc_short_name          COMPAT_short_name
    						,CRD_SCH_START_DATE
    						,CRD_SCH_END_DATE
    					from	X_CP_MEDIA_DEVICE             d,
    						X_CP_MEDIA_DEV_PLATM_MAP      m,
    						X_CP_MEDIA_DEVICE_COMPAT      c,
    						SGY_PB_MEDIA_PLATFORM         PL,
    						tbl ,
    						x_cp_med_platm_dev_compat_map dm
    					where	d.md_id = m.mdp_map_dev_id
    					and	dm.mpdc_dev_platm_id = d.md_id
    					AND	PL.MP_MEDIA_PLATFORM_CODE = m.mdp_map_platm_code
    					and	c.mdc_id = dm.mpdc_comp_rights_id
    					and	d.md_id=crd_dev_id
    					and	c.mdc_id=tbl.MPDC_COMP_RIGHTS_ID
						and dm.MPDC_IS_COMP_RIGHTS =''Y''
    					order by pl.mp_seq_no,d.md_seq_no,c.mdc_seq_no
    					))
    					pivot (
    						max(platform) as PLT,
    						max(device) as DEV,
    						max(compat) as DEM,
    						max(CRD_SCH_START_DATE) as ST,
    						max(CRD_SCH_END_DATE) as ET
    					for generatecolumns in ('||l_str_column_name||')
    					)) x
    				where x.crd_bin_id(+) = z.crs_bin_id
    				and z.crs_curr_flag = ''C''
            and z.Crs_Release_Flag = ''Y''
            and z.crs_session_id = '||I_Session_Id||'
					and z.crs_sch_plan_month = '||I_Plan_Month||'
					order by  crs_process_priority,CRS_SCH_CREATED asc'
					;

    			--DBMS_OUTPUT.put_line(l_str_table_script||l_dynamic_query);
    			END;*/
				--DBMS_OUTPUT.put_line('query:-'||l_str_table_script||l_dynamic_query);
			--open o_schedule_rel_data for
			--l_str_table_script||l_dynamic_query;

			select count(1)
			into l_release_cnt
			from x_cl_release_schedule l
			where l.crs_sch_plan_month=i_plan_month
			and crs_curr_flag = 'C'
			;
			-- dbms_output.put_line(l_release_cnt || 'l_release_cnt');
			--DBMS_OUTPUT.PUT_LINE('after select '||l_release_cnt);

			if l_release_cnt =0
			then
			ROLLBACK;
				raise_application_error (-20100, 'Cannot release the schedule for '
				||i_plan_month||' as there are no changes to update');
			end if;


			insert into x_cl_release_count(crc_schmonth,crc_totalCount,crc_completedcount,crc_warningcount,crc_errorcount,crc_csvcount)
			select i_plan_month
			,count(1) total_mont_cnt
			,count(case when grs_error_type = 'Y' then 1 end) Completed_cnt
			,count(case when grs_error_type = 'O' then 1 end) Warning_cnt
			,count(case when grs_error_type = 'M' then 1 end) Error_cnt
			,0 CSV_ReleaseCnt
			from x_cl_gtt_release_schedule  s
			where s.grs_sch_plan_month=i_plan_month
			group by i_plan_month
			;

			update x_cl_release_count set crc_csvcount=(select count(1)
			from x_cl_release_schedule l
			where l.crs_sch_plan_month=i_plan_month
			and crs_curr_flag = 'C')
			where crc_schmonth=i_plan_month;

			commit;

			/*open o_ftpdetails for
			select ftpid,ftplocation,ftpuser,ftppassword,
			(select lower(MS_MEDIA_SERVICE_CODE) from SGY_PB_MEDIA_SERVICE where MS_MEDIA_SERVICE_CODE='CATCHUP') || '_' || to_char(to_date(i_plan_month,'RRRRMM'),'monYYYY')
				||'_' ||i_session_id|| '.csv'
				ftpFileName,ftpEncodingMethod,ARCHIVEFOLDERPATH,type,expiry_days
			FROM x_cl_clearleap_config
			;*/
	END X_PRC_RELEASE_SCHEDULE;

		PROCEDURE x_prc_default_uid(o_status OUT NUMBER) AS
			l_tap_barcode fid_tape.tap_barcode%type;
		begin
			  for i in
			  (select bin_id,bin_lic_number,lic_gen_refno
				 from x_cp_schedule_bin
					 ,x_cp_play_list
					 ,fid_license
				where bin_id = plt_bin_id
				  and bin_lic_number = lic_number
				  and not exists (select 1 from x_cp_sch_bin_uid where SBU_BIN_ID = BIN_ID)
				group by bin_id, bin_lic_number,lic_gen_refno
			   having to_char(min(PLT_SCH_START_DATE),'YYYYMM') >= to_char(sysdate,'YYYYMM')
			  )
			  loop
				begin
				  select tap_barcode
					into l_tap_barcode
					from(
						select TAP_UID_VERSION,tap_barcode
						  from fid_tape ,SGY_MN_LIC_TAPE_CHA_MAPP
						 where tap_number      = ltcm_tap_number
						   and TAP_UID_VERSION   is not null
						   and tap_uid_version ='HD - HI'
						   and tap_uid_status_id in(10,27)
						   and ltcm_gen_refno  = i.lic_gen_refno
						union
						select TAP_UID_VERSION,tap_barcode
						  from fid_tape ,SGY_MN_LIC_TAPE_CHA_MAPP
						 where tap_number      = ltcm_tap_number
						   and TAP_UID_VERSION   is not null
						   and tap_uid_version ='HD - HI'
						   and tap_uid_status_id in(10,27)
						   and ltcm_lic_number = i.bin_lic_number
					   )
				  where rownum < 2
				  ;
			   exception
			   when others
			   then
					l_tap_barcode := null;
			   end;
				  if  l_tap_barcode is not null
				  then
					  insert into x_cp_sch_bin_uid (SBU_BIN_ID,SBU_TAP_BARCODE)
					  values (i.bin_id,l_tap_barcode);
				  end if;
			  end loop;
			  COMMIT;
			  o_status:=1;
		  EXCEPTION WHEN OTHERS THEN
			o_status:=0;
		end x_prc_default_uid;

		/*To check whether the given title is a Series or not*/
		FUNCTION X_FNC_PROG_IS_SER(I_GEN_REFNO fid_general.gen_refno%type) RETURN VARCHAR2
		AS
			l_is_series varchar2(1);
			l_prog_type varchar2(20);
		BEGIN

			select gen_type
			into l_prog_type
			from fid_general
			where gen_refno = i_gen_refno;

			BEGIN
				SELECT cod_attr1
				INTO l_is_series
				FROM fid_code
				WHERE cod_type = 'GEN_TYPE'
				AND cod_value != 'HEADER'
				AND UPPER(cod_value) = UPPER(l_prog_type);
			EXCEPTION
			WHEN NO_DATA_FOUND THEN
				l_is_series := 'N';
			END;

			RETURN L_IS_SERIES;
		END X_FNC_PROG_IS_SER;

		/* To check whether the file is generated and sent to FTP Location Successfully or not,
		 also to take necessary backup when failed*/
		PROCEDURE x_prc_after_release_success
		(	i_Success_Flag IN varchar2,
			i_Schedule_Plan_Month IN  DATE,
			i_Auto_Release_Flag  IN  VARCHAR2
			,i_error_message IN varchar2 -- To be uncommented after build is ready
      ,i_language IN x_cl_release_schedule.CRS_TAP_UID_LANG%type
      ,i_bin_id  IN x_cl_release_schedule.CRS_BIN_ID%type
      ,i_session_id in x_cl_release_schedule.CRS_SESSION_ID%type
		)
		AS
			l_plan_month VARCHAR2(10);
      l_go_live_date X_FIN_CONFIGS.CONTENT%type;
			--i_failure_code varchar2(20); -- To be commented after build is ready
		Begin
			--i_failure_code:=''; -- To be Commented After Build is ready.
			l_plan_month := to_number(to_char(i_Schedule_Plan_Month, 'RRRRMM'));

      select to_date(to_char(to_date("CONTENT"),'yyyyMMdd'),'yyyyMMdd') INTO l_go_live_date from X_FIN_CONFIGS WHERE "KEY" = 'CU4ALL_LIVE_DATE';
      --IXS START - Sagar Sonawane 31-Jan-2016

      /*IF(l_go_live_date > i_Schedule_Plan_Month)
      THEN
          UPDATE x_cl_release_schedule SET CRS_CURR_FLAG = NULL
          WHERE crs_sch_plan_month =l_plan_month
          AND crs_curr_flag='C'
          AND CRS_SESSION_ID = i_session_id;
      ELSE*/
          UPDATE x_cl_release_schedule SET CRS_CURR_FLAG = NULL
          where crs_sch_plan_month =l_plan_month
          and crs_curr_flag='C'
          and CRS_BIN_ID = i_bin_id
          AND CRS_TAP_UID_LANG = i_language;
     -- END IF;

      --IXS END
        /*IF(l_go_live_date > i_Schedule_Plan_Month)
        THEN

          if i_bin_id is null
          then
            update x_cl_backup_rel_schedule
            set BRS_PROCESS_FLAG = decode(i_Success_Flag,'Y','P','F')
            where BRS_SCH_PLAN_MONTH = l_plan_month
            and exists (select 1
                          from X_CL_IXS_API_RELEASE
                          where IAR_SESSION_ID = i_session_id
            and IAR_SCH_PLAN_MONTH = l_plan_month
            and IAR_STATUS = 'N');


            update X_CL_IXS_API_RELEASE
            set IAR_STATUS = decode(i_Success_Flag,'Y','P','F')
            where IAR_SESSION_ID = i_session_id
            and IAR_SCH_PLAN_MONTH = l_plan_month;
        else*/
            update X_CL_IXS_API_RELEASE
            set iar_status_before_golive = decode(i_Success_Flag,'Y','P','F')
            where IAR_LANGUAGE = i_language
            and IAR_BIN_ID = i_bin_id
            AND IAR_SESSION_ID = i_session_id;
        --end if;

		  /*IF(i_Auto_Release_Flag = 'A')
          THEN
            update x_cl_release_later
            set crl_process_flag = decode(i_Success_Flag,'Y','P','F')
            where crl_sch_plan_month = l_plan_month
            and to_char(crl_entry_date, 'DD-MON-YYYY') = to_char(sysdate, 'DD-MON-YYYY');
          END IF;
        ELSE
       */
          --IXS START - Sagar Sonawane 31-Jan-2016
          update X_CL_IXS_API_RELEASE
          SET IAR_STATUS = decode(i_Success_Flag,'Y','P','F')
               ,iar_comment = i_error_message
          where IAR_LANGUAGE = i_language
          and IAR_BIN_ID = i_bin_id
          and IAR_SESSION_ID = i_session_id;

          update x_cl_backup_rel_schedule
          set BRS_PROCESS_FLAG = decode(i_Success_Flag,'Y','P','F')
          where BRS_TAP_UID_LANG = i_language
          and   BRS_BIN_ID = i_bin_id
          and BRS_SCH_PLAN_MONTH = l_plan_month;

		  IF(i_Auto_Release_Flag = 'A')
          THEN
            update x_cl_release_later
            set crl_process_flag = decode(i_Success_Flag,'Y','P','F')
            where crl_language = i_language
            and   crl_bin_id = i_bin_id
            and crl_sch_plan_month = l_plan_month
            and to_char(crl_entry_date, 'DD-MON-YYYY') = to_char(sysdate, 'DD-MON-YYYY');
          END IF;

    --   END IF;
        --IXS END

			commit;
			/*if i_Auto_Release_Flag ='A'
			THEN
			x_clearleap_email_csv_release('CLEARLEAPINTEGRATION',i_Schedule_Plan_Month,i_Success_Flag,i_error_message);

			end if;
			*/
		End x_prc_after_release_success;

		 /* For Auto Release Functionality*/
			/*procedure x_prc_auto_release(o_schedule_data     OUT X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor,
									 --o_sch_warnings      OUT X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor,
									 --o_sch_warning_excel OUT X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor,
									 o_ftpdetails        OUT X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor) as
		  l_curr_date_cnt number;
		  l_release_month date;
		  l_as_id         number;
		  o_sch_warnings  X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor;
		  o_sch_warning_excel X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor;

		begin

		  select count(1)
			into l_curr_date_cnt
			from x_cl_auto_schedule
		   where to_char(AS_CURR_DATE, 'YYYYMMDD') = to_char(sysdate, 'YYYYMMDD')
			 and as_release_flag = 'N';

		  if l_curr_date_cnt = 0 then
			delete from x_cl_auto_schedule;

			insert into x_cl_auto_schedule
			  (as_id, as_curr_date, as_release_month, as_release_flag)
			  select rownum,
					 trunc(sysdate),
					 trunc(add_months(sysdate, rownum - 1), 'MON'),
					 'N'
				from user_objects
			   where rownum < 4;

		  end if;

		  begin
			select as_release_month, as_id
			  into l_release_month, l_as_id
			  from (select as_release_month, as_id
					  from x_cl_auto_schedule
					 where to_char(AS_CURR_DATE, 'YYYYMMDD') =
						   to_char(sysdate, 'YYYYMMDD')
					   and as_release_flag = 'N'
					 order by as_id)
			 where rownum < 2;
		  exception
			when others then
			  l_release_month := null;
		  end;

		  if l_release_month is not null then
			update x_cl_auto_schedule
			   set as_release_flag = 'Y'
			 where as_id = l_as_id;
			x_pkg_cl_csv_generation.x_prc_release_schedule(l_release_month,
														   'SYSADMIN',
														   'A',
														   o_schedule_data,
														   o_sch_warnings,
														   o_sch_warning_excel,
														   o_ftpdetails);

		  end if;
		  commit;
		end x_prc_auto_release;*/

		/*To get the list of mail IDs*/
		FUNCTION x_get_email_ids (list_in IN VARCHAR2, delimiter_in VARCHAR2)
		RETURN simplearray
		AS
		v_retval   simplearray:= simplearray (LENGTH (list_in)- LENGTH (REPLACE (list_in, delimiter_in, ''))+ 1);
		BEGIN
			IF list_in IS NOT NULL
			THEN
			FOR i IN 1 ..
			LENGTH (list_in)- LENGTH (REPLACE (list_in, delimiter_in, ''))+ 1
			  LOOP
				v_retval.EXTEND;
				v_retval (i) :=SUBSTR (delimiter_in || list_in || delimiter_in,INSTR (delimiter_in || list_in || delimiter_in,delimiter_in,1,i)
								+ 1,INSTR (delimiter_in || list_in || delimiter_in,delimiter_in,1,i + 1)
							   - INSTR (delimiter_in || list_in || delimiter_in,delimiter_in,1,i)- 1);
				 END LOOP;
			  END IF;
			RETURN v_retval;
		END x_get_email_ids;


		/*For sending E-Mails to intended recipients on success or failure of the CSV generation*/
		PROCEDURE x_clearleap_email_csv_release(i_action              IN VARCHAR2,
												i_Schedule_Plan_Month IN DATE,
												i_Success_Flag        IN varchar2,
												i_error_message       IN varchar2) AS
		  l_mail_conn   UTL_SMTP.connection;
		  l_smtp_server varchar2(50);
		  l_recipient   varchar2(2000);
		  l_subject     varchar2(2000);
		  l_mailfrom    varchar2(2000);
		  p_smtp_port   NUMBER;
		  l_message     varchar2(2000);
		  l_mailcc      varchar2(100);
		  l_mailbcc      varchar2(100);
		  arr_email     simplearray := simplearray(100);
		  l_plan_month  VARCHAR2(10);
		  l_total_count number;
		  l_error_count number;
		  l_successful_count number;
		  l_warning_count number;
		  l_total_release_count number;
		BEGIN
		  l_plan_month := to_char(i_Schedule_Plan_Month, 'MON-RRRR');
		  p_smtp_port  := 25;

		begin
			select
				nvl(crc_completedcount,0) ,
				nvl(crc_warningcount,0) ,
				nvl(crc_errorcount,0) ,
				nvl(crc_csvcount,0) ,
				nvl(crc_totalCount,0)
				into l_successful_count,l_warning_count,l_error_count,l_total_release_count, l_total_count
				from x_cl_release_count where crc_schmonth=to_char(i_Schedule_Plan_Month,'YYYYMM');
				exception when no_data_found then
				 l_total_count:=0;
				  l_error_count:=0;
				  l_successful_count :=0;
				  l_warning_count :=0;
				  l_total_release_count :=0;
			  end;

		  SELECT "Content"
			INTO l_smtp_server
			FROM fwk_appparameter
		   WHERE KEY = 'SMTPServer';

		  SELECT recipient, Subject, mailfrom, message, mailcc,mailbcc
			INTO l_recipient, l_subject, l_mailfrom, l_message, l_mailcc, l_mailbcc
			FROM sgy_email
		   WHERE UPPER(action) = i_action;

		  l_message := replace(replace(replace(l_message,
											   '<<TODAYSDATE>>',
											   to_char(sysdate, 'DD-MON-YYYY')),
									   '<<TODAYSTIME>>',
									   to_char(sysdate, 'HH24MI')),
							   '<<SCHEDULEMONTH>>',
							   l_plan_month);

		  if i_Success_Flag = 'Y' then
			l_subject := 'Catch Up Schedule for ' || l_plan_month ||
						 ' released successfully.';
			l_message := replace(l_message,
								 '<<STATUSCSVRELEASE>>',
								 'has been released successfully.'  || '<BR>' ||--);
			 '<BR>' || 'Total Scheduled Titles : ' || l_total_count ||
		   '<BR>' || 'Completed Titles : ' ||l_successful_count  ||
			'<BR>' || 'Warning Titles : ' || l_warning_count ||
			 '<BR>' || 'Error Titles : ' || l_error_count ||
			 '<BR>' || 'Total titles released in current CSV:  ' || l_total_release_count ||'<BR>' );

		  /* l_message := l_message || '<BR>' || 'Total Scheduled Titles : ' || l_total_count;
			l_message := l_message || '<BR>' || 'Completed Titles : ' || l_error_count;
			l_message := l_message || '<BR>' || 'Warning Titles : ' || l_successful_count;
			l_message := l_message || '<BR>' || 'Error Titles : ' || l_warning_count;
			 l_message := l_message || '<BR>' || 'Total titles released in current CSV:  ' || l_total_release_count;

		*/
		 l_message := replace(l_message, '<<ONFAILURESTATUS>>', '');
		  elsif i_Success_Flag = 'N' then
			l_subject := 'Unable to release Catch Up Schedule for ' || l_plan_month || '.';
			l_message := replace(l_message,
								 '<<STATUSCSVRELEASE>>',
								 'could not be released');
			l_message := replace(l_message,
								 '<<ONFAILURESTATUS>>',
								 '<BR>' || 'Reason : ' || i_error_message || '<BR>');
		  elsif i_Success_Flag = 'NoChanges' then
			l_subject := 'No changes in Catch Up Schedule for ' || l_plan_month || '.';
			l_message := replace(l_message,
								 '<<STATUSCSVRELEASE>>',
								 'could not be released as there were no changes to be updated.' || '<BR>' ||--);

		   '<BR>' || 'Total Scheduled Titles : ' || l_total_count ||
		   '<BR>' || 'Completed Titles : ' ||l_successful_count  ||
			'<BR>' || 'Warning Titles : ' || l_warning_count ||
			 '<BR>' || 'Error Titles : ' || l_error_count  ||
			 '<BR>' || 'Total titles released in current CSV:  ' || l_total_release_count ||'<BR>' );
		  /*  l_message := l_message || '<BR>' || 'Total Scheduled Titles : ' || l_total_count;
			l_message := l_message || '<BR>' || 'Completed Titles : ' || l_error_count;
			l_message := l_message || '<BR>' || 'Warning Titles : ' || l_successful_count;
			l_message := l_message || '<BR>' || 'Error Titles : ' || l_warning_count;
			l_message := l_message || '<BR>' || 'Total titles released in current CSV:  ' || l_total_release_count;
		  */
			l_message := replace(l_message, '<<ONFAILURESTATUS>>', '');

		  end if;
		  --dbms_output.put_line(l_recipient);
		  arr_email := x_get_email_ids(l_recipient, ',');

		  l_mail_conn := UTL_SMTP.open_connection(l_smtp_server, 25);

		  UTL_SMTP.helo(l_mail_conn, l_smtp_server);
		  UTL_SMTP.mail(l_mail_conn, l_mailfrom);

		  FOR i IN 1 .. arr_email.COUNT - 1 LOOP
			UTL_SMTP.rcpt(l_mail_conn, '' || arr_email(i) || '');
		  END LOOP;

		  IF l_mailcc IS NOT NULL THEN
            arr_email := x_get_email_ids(l_mailcc, ',');
            FOR i IN 1 .. arr_email.count - 1
            loop
              utl_smtp.rcpt(l_mail_conn, arr_email(i));
            END LOOP;
            --utl_smtp.rcpt(l_mail_conn, l_mailcc);
		  END IF;

		  IF l_mailbcc IS NOT NULL
		  THEN
            arr_email := x_get_email_ids(l_mailbcc, ',');
            FOR i IN 1 .. arr_email.count - 1
            loop
              utl_smtp.rcpt(l_mail_conn, arr_email(i));
            END LOOP;
		  END IF;

		--l_subject :='Test Email';-- || l_subject; -- to removed after UAT
		--l_message :='This is a Test Email. Please Ignore.';
		  UTL_SMTP.open_data(l_mail_conn);
		  UTL_SMTP.write_data(l_mail_conn,
							  'Subject: ' || l_subject || UTL_TCP.crlf);
		  UTL_SMTP.write_data(l_mail_conn, 'To: ' || l_recipient || UTL_TCP.crlf);
		  if l_mailcc is not null then
			UTL_SMTP.write_data(l_mail_conn, 'Cc: ' || l_mailcc || UTL_TCP.crlf);
		  end if;

		  if l_mailbcc is not null then
			UTL_SMTP.write_data(l_mail_conn, 'Bcc: ' || l_mailbcc || UTL_TCP.crlf);
		  end if;

		  UTL_SMTP.write_data(l_mail_conn, 'From: ' || l_mailfrom || UTL_TCP.crlf);
		  UTL_SMTP.write_data(l_mail_conn,
							  'Content-Type: text/html' || UTL_TCP.crlf);
		  UTL_SMTP.write_data(l_mail_conn, UTL_TCP.crlf || '');

		  UTL_SMTP.write_data(l_mail_conn,
							  UTL_TCP.crlf || UTL_TCP.crlf || l_message);
		  UTL_SMTP.close_data(l_mail_conn);
		  UTL_SMTP.quit(l_mail_conn);

		delete from x_cl_release_count  where crc_schmonth=to_char(i_Schedule_Plan_Month,'YYYYMM');
		commit;
		END x_clearleap_email_csv_release;

		FUNCTION X_fun_Teritory_Code
		(
		I_Bin_Id  in  Number
		,I_Bin_Lic_Number in Number
		,i_Bin_Reg_Code  in number
		,i_langu_id in number
		,i_query_flag in number
		)
		Return Varchar2
		Is
			L_Ter_Str Varchar2(1000);
		Begin

		  if i_query_flag = 1
		  then
			   For I In
			   (
				Select NVL(ter_ISO_code,TER_CODE) iso_code
							From X_Cp_Sch_Bin_Territory,Fid_Territory
							WHERE sbt_bin_id = I_Bin_Id
				AND sbt_ter_code=TER_CODE
        AND SBT_IE_FLAG='I'
				And Ter_Code Not In (Select Lil_Ter_Code
									  From Fid_License_Ledger
									 Where  lil_rgh_code='X'
									 and lil_lic_number=(select bin_lic_number
															From X_Cp_Schedule_Bin B
															Where B.Bin_Id = Sbt_Bin_Id)
									  )
							And Sbt_Lang_Id = Decode(Nvl(I_Langu_Id,1),0,1,Nvl(I_Langu_Id,1))
				Order By Nvl(Ter_Iso_Code,Ter_Code)
				)
				Loop
					If L_Ter_Str Is Null
					Then
						  L_Ter_Str := i.iso_code;
					Else
						   L_Ter_Str := L_Ter_Str||','||i.iso_code;
					end if;
				end loop;
			end if;

			If L_Ter_Str Is Null
			Then
				  For I In
				  (	SELECT NVL(ter_ISO_code,TER_CODE) iso_code
					FROM X_VW_CP_LEE_LANG_TER_MAPP,
						  fid_license_ledger,
						  fid_territory,
						  Fid_License
					WHERE  lil_ter_code = ter_code
					and		lil_lic_number = lic_number
					AND     lil_lic_number = I_Bin_Lic_Number
					AND    lil_rgh_code <> 'X'
					and    llt_lee_number = lic_lee_number
					and    llt_ter_code = ter_code
					and    LLT_LANG_ID = Decode(Nvl(I_Langu_Id,1),0,1,Nvl(I_Langu_Id,1))
          Order By Nvl(Ter_Iso_Code,Ter_Code)
				   )
				   loop
						  If L_Ter_Str Is Null
						  Then
								L_Ter_Str := i.iso_code;
						  Else
								 L_Ter_Str := L_Ter_Str||','||i.iso_code;
						  end if;
				   End Loop;
		  end if;

		  return L_Ter_Str;
		END X_fun_Teritory_Code;
   PROCEDURE x_prc_ixs_release_schedule
	(
    i_release_type    IN    varchar2,
    o_bin_data				OUT		X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
		,o_playlist_data		OUT		X_PKG_CL_CSV_GENERATION.x_cl_ref_cursor
	)
	AS
			l_bin_id X_CL_GTT_REL_SCH_DETAIL.GRD_BIN_ID%type;
			l_language X_CL_RELEASE_SCHEDULE.CRS_TAP_UID_LANG%type;
			l_session_id X_CL_RELEASE_SCHEDULE.CRS_SESSION_ID%type;
			l_CRS_BOUQUET_CODES X_CL_RELEASE_SCHEDULE.CRS_BOUQUET_CODES%type;
			l_details_data VARCHAR2(5000);
			l_prp_weightage number;
			l_ixp_weightage number;
			l_priority number;
			l_go_live_date number;
			l_CRS_SCH_PLAN_MONTH number;
      l_sch_live varchar2(1);
	BEGIN

	 select to_char(to_date("CONTENT"),'RRRRMM') INTO l_go_live_date from X_FIN_CONFIGS WHERE "KEY" = 'CU4ALL_LIVE_DATE';



  For I In
				  (
            SELECT (CASE WHEN IAR_PROCESS_PRIORITY = 1 THEN 'High'  WHEN IAR_PROCESS_PRIORITY = 2 THEN 'Medium' ELSE 'Low' END) ProcessPriority,
                   iar_gen_catchup_priority, iar_bin_id, iar_session_id, iar_sch_created
              FROM x_cl_ixs_api_release
             WHERE iar_status = 'N'
             and IAR_PRIORITY is null
             --AND iar_bin_id = l_bin_id
             --AND iar_session_id = l_session_id
				   )
				   loop

            begin
                  select nvl(sch_live,'N') sch_live
                  into l_sch_live
                  from x_cp_schedule_bin
                         ,fid_schedule
                  where bin_id = I.iar_bin_id
                  and bin_sch_number = sch_number(+)
                  ;
            exception
            when others
            then
                l_sch_live := 'N';
            end;

            if l_sch_live = 'Y'
            then
                  l_priority := 2;
            else
                  SELECT PRP_WEIGHTAGE
                  INTO l_prp_weightage
                  FROM X_CL_PROGRAMME_PRIORITY
                  WHERE PRP_CATCH_UP_PRIORITY = nvl(I.iar_gen_catchup_priority,'C')
                  AND PRP_PROCESS_PRIORITY = I.ProcessPriority;

                  SELECT (CASE WHEN (trunc(I.iar_sch_created) - trunc(SYSDATE)) <= 2 THEN 80
                  WHEN (trunc(I.iar_sch_created) - trunc(SYSDATE)) BETWEEN 3 AND 7 THEN 56
                  ELSE 24 END)
                  INTO l_ixp_weightage
                  FROM DUAL;

                  SELECT IXP_PRIORITY
                  INTO l_priority
                  FROM X_CL_IXS_PRIORITY
                  WHERE l_prp_weightage+l_ixp_weightage
                  BETWEEN IXP_MIN_RANGE AND IXP_MAX_RANGE;
            end if;



            UPDATE x_cl_ixs_api_release
            SET IAR_PRIORITY = l_priority
            WHERE iar_bin_id = I.iar_bin_id
            AND iar_session_id = I.iar_session_id;


     End Loop;

    BEGIN
      SELECT CRS_BIN_ID, CRS_TAP_UID_LANG, CRS_SESSION_ID,IAR_PRIORITY,CRS_SCH_PLAN_MONTH,CRS_BOUQUET_CODES
        INTO l_bin_id, l_language, l_session_id,l_priority,l_CRS_SCH_PLAN_MONTH,l_CRS_BOUQUET_CODES
        FROM (SELECT CRS_BIN_ID , CRS_TAP_UID_LANG, CRS_SESSION_ID,IAR_PRIORITY,CRS_SCH_PLAN_MONTH,CRS_BOUQUET_CODES, rownum l_rownum
                FROM (SELECT R.CRS_BIN_ID, R.CRS_TAP_UID_LANG, R.CRS_SESSION_ID,IAR_PRIORITY,R.CRS_SCH_PLAN_MONTH,CRS_BOUQUET_CODES
                        FROM X_CL_RELEASE_SCHEDULE R,
                             X_CL_IXS_API_RELEASE I
                       WHERE CRS_BIN_ID = IAR_BIN_ID
                         AND CRS_TAP_UID_LANG = IAR_LANGUAGE
                         AND iar_status = 'N'
                         AND CRS_SESSION_ID = IAR_SESSION_ID
                         AND IAR_RELEASE_TYPE = NVL(i_release_type,'W')
                         AND IAR_PRIORITY IS NOT NULL
                    ORDER BY IAR_PRIORITY)
              )
       WHERE l_rownum < 2;
    EXCEPTION
      WHEN OTHERS
      THEN
        l_bin_id :=0;
        l_language := 0;
        l_session_id :=0;
    END;


   -- dbms_output.put_line('l_bin_id '||l_bin_id||' l_language '||l_language||' l_session_id '||l_session_id);

  commit;

    --  dbms_output.put_line('l_bin_id '||l_bin_id||' l_language '||l_language||' l_session_id '||l_session_id);
  /*BEGIN
      SELECT CRS_BIN_ID, CRS_TAP_UID_LANG, CRS_SESSION_ID,IAR_PRIORITY,CRS_SCH_PLAN_MONTH,CRS_BOUQUET_CODES
        INTO l_bin_id, l_language, l_session_id,l_priority,l_CRS_SCH_PLAN_MONTH,l_CRS_BOUQUET_CODES
        FROM (SELECT CRS_BIN_ID , CRS_TAP_UID_LANG, CRS_SESSION_ID,IAR_PRIORITY,CRS_SCH_PLAN_MONTH,CRS_BOUQUET_CODES, rownum l_rownum
                FROM (SELECT R.CRS_BIN_ID, R.CRS_TAP_UID_LANG, R.CRS_SESSION_ID,IAR_PRIORITY,R.CRS_SCH_PLAN_MONTH,CRS_BOUQUET_CODES
                        FROM X_CL_RELEASE_SCHEDULE R,
                             X_CL_IXS_API_RELEASE I
                       WHERE CRS_BIN_ID = IAR_BIN_ID
                         AND CRS_TAP_UID_LANG = IAR_LANGUAGE
                         AND (case when IAR_SCH_PLAN_MONTH >= l_go_live_date then iar_status else IAR_STATUS_BEFORE_GOLIVE end) = 'N'
                         AND CRS_SESSION_ID = IAR_SESSION_ID
                         AND IAR_RELEASE_TYPE = NVL(i_release_type,'W')
			 AND IAR_PRIORITY IS NOT NULL
                    ORDER BY IAR_PRIORITY))
       WHERE l_rownum < 2;
    EXCEPTION
      WHEN OTHERS
      THEN
        l_bin_id :=0;
        l_language := 0;
        l_session_id :=0;
    END;*/

	OPEN o_bin_data FOR
	SELECT
			CRS_BIN_ID BIN_ID,
			CRS_SERVICE_CODE,
			CRS_VOD_TYPE,
			CRS_SCH_PLAN_MONTH,
			CRS_GEN_REFNO,
			CRS_REGION_CODE,
			CRS_TAP_BARCODE,
			CRS_CRUD,
      l_priority PRIORITY,
      nvl(CRS_EXPRESS,'N') CRS_EXPRESS,
			CRS_MPAA_RATING,
			CRS_LIN_CHA,
			CRS_HD_SD_TITLE,
			CRS_SER_NUMBER,
			CRS_SER_TITLE,
      CRS_SEASON_NUMBER,
			CRS_EPI_COUNT,
      CRS_EPI_NUMBER,
			CRS_SEA_NUMBER,
			CRS_GEN_TITLE,
			CRS_GEN_DURATION_C,
      (select g.GEN_EPG_CONTENT_ID from fid_general g where g.gen_refno = CRS_GEN_REFNO) "CRS_EPG_CONTENT_ID",
			CRS_RELEASE_YEAR,
			CRS_GEN_CATEGORY,
			CRS_SUB_GENRE,
			CRS_ACTORS,
			CRS_DIRECTOR,
			CRS_SER_SYNOPSIS,
			CRS_SEA_SYNOPSIS,
      CRS_TITLE_SYNOPSIS,
			CRS_ORIG_COUNTRY,
			CRS_SHOW_TYPE,
			CRS_COM_SHORT_NAME,
			CRS_COM_NAME,
			CRS_THEME,
			CRS_ADVISORIES,
			CRS_LIN_SCH_DATE,
			to_char(to_date(crs_session_id,'YYYYMMDDHH24MISS'),'DD-MM-RRRR HH24:MI:SS') CRS_SCH_CREATED,
			CRS_TAP_UID_AUDIO,
			CRS_TAP_UID_VERSION,
			CRS_TAP_ASPECT_RATIO,
			CRS_TAP_UID_LANG,
      CRS_SESSION_ID
	FROM X_CL_RELEASE_SCHEDULE
	WHERE CRS_BIN_ID = l_bin_id
	AND	  CRS_TAP_UID_LANG = l_language
  AND   CRS_SESSION_ID = l_session_id;



	if l_CRS_SCH_PLAN_MONTH >= l_go_live_date
	then
			  l_details_data :=
				   'select BIN_ID
      ,CRD_PLAT_CODE
      ,wm_concat( distinct MD_CODE) MD_DESC
      ,MDC_DESC
      ,Territory
      ,Bouquet
				   ,START_DATE
				   ,END_DATE
				   ,sub_bouquet
from (select CRD_BIN_ID BIN_ID
				   ,CRD_PLAT_CODE
				   --,wm_concat( distinct MD_CODE) MD_CODE
           ,MD_CODE
				   ,wm_concat( distinct MDC_DESC) MDC_DESC
				   ,wm_concat( distinct Territory) Territory
				   ,Bouquet
				   ,START_DATE
				   ,END_DATE
				   ,sub_bouquet
			from (
				   Select Ptb_Plt_Id,
					  CRD_BIN_ID,
					  ''OTT'' CRD_PLAT_CODE,
					  L.CRD_DEV_ID,
					  D.MD_CODE,
					  C.MPDC_COMP_RIGHTS_ID,
					  COM.MDC_DESC,
					  (Select Cb_Short_Code From X_Cp_Bouquet Where Cb_Id = Ptb_Bouquet_Id) Bouquet,
					  (Select Ter_Iso_Code From Fid_Territory Where Ter_Code = Ptb_Ter_Code) Territory,
					  to_char(to_date(to_char(PTB_OTT_START_DATE,''DD-MON-YYYY'')||convert_time_n_c(PTB_SCH_OTT_FROM_TIME),''DD-MON-RRRRHH24:MI:SS''), ''DD-MM-RRRR hh24:mi:ss'') START_DATE,
					  to_char(to_date(to_char(PTB_OTT_END_DATE,''DD-MON-YYYY'')||convert_time_n_c(PTB_SCH_OTT_END_TIME),''DD-MON-RRRRHH24:MI:SS''), ''DD-MM-RRRR hh24:mi:ss'') END_DATE,
					  (Select Listagg(CB_NAME, '', '') Within Group (Order By CB_NAME)
						  From X_Cp_Plt_Dev_Subbouq_Mapp,x_cp_bouquet
						  Where Cps_Ptb_Id = Ptb_Id
						  And Cb_Id = Cps_Subbouquet_Id
					   ) sub_bouquet
				From  X_Cp_Plt_Terr_Bouq
					   ,x_cp_media_dev_platm_map M
						,x_cp_med_platm_dev_compat_map C
						,x_cl_rel_sch_detail L
						,X_CP_MEDIA_DEVICE D
						,X_CP_MEDIA_DEVICE_COMPAT COM
						,x_cp_lic_medplatmdevcompat_map MM
						,x_cl_release_schedule CRS
						,X_CP_PLT_DEVCOMP_RIGHTS
				Where CRD_PLT_ID = Ptb_Plt_Id(+)
				And  Mpdc_Dev_Platm_Id = Mdp_Map_Id
				AND   CRD_PLAT_CODE = MDP_MAP_PLATM_CODE
				AND   CRD_DEV_ID = MDP_MAP_DEV_ID
				AND   D.MD_ID=MDP_MAP_DEV_ID
				AND   COM.MDC_ID=C.MPDC_COMP_RIGHTS_ID
				AND   MM.LIC_MPDC_LIC_NUMBER=L.CRD_LIC_NUMBER
				AND   L.crd_dev_id=D.MD_ID
				AND   MM.LIC_MPDC_DEV_PLATM_ID=C.mpdc_dev_platm_id
				And   Com.Mdc_Id = Lic_Mpdc_Comp_Rights_Id
				AND   CDCR_PTBT_ID=PTB_ID
				and   cdcr_comp_id=Com.Mdc_Id
				and   cdcr_dev_id=D.MD_ID
        --Join was missing added by swapnil
        AND CRS.CRS_SESSION_ID = L.CRD_SESSION_ID
        --Join was missing added by swapnil
				And   Mm.Lic_Is_Comp_Rights =''Y''
				and   l.crd_bin_id =  '||l_bin_id||'
				and   CRS.CRS_SESSION_ID = '||l_session_id||'
				and ptb_ott_start_date is not null
				and MDC_DELIVERY_METHOD = ''PULL''
				UNION ALL
				   Select Ptb_Plt_Id,
					  CRD_BIN_ID,
					  ''SAT'' CRD_PLAT_CODE,
					  L.CRD_DEV_ID,
					  D.MD_CODE,
					  C.MPDC_COMP_RIGHTS_ID,
					  COM.MDC_DESC,
					  (Select Cb_Short_Code From X_Cp_Bouquet Where Cb_Id = Ptb_Bouquet_Id) Bouquet,
					  (Select Ter_Iso_Code From Fid_Territory Where Ter_Code = Ptb_Ter_Code) Territory,
					  to_char(to_date(to_char(PTB_PVR_START_DATE,''DD-MON-YYYY'')||convert_time_n_c(PTB_SCH_PVR_FROM_TIME),''DD-MON-RRRRHH24:MI:SS''), ''DD-MM-RRRR hh24:mi:ss'') START_DATE,
					  to_char(to_date(to_char(PTB_PVR_END_DATE,''DD-MON-YYYY'')||convert_time_n_c(PTB_SCH_PVR_END_TIME),''DD-MON-RRRRHH24:MI:SS''), ''DD-MM-RRRR hh24:mi:ss'') END_DATE,
					  (Select Listagg(CB_NAME, '', '') Within Group (Order By CB_NAME)
						  From X_Cp_Plt_Dev_Subbouq_Mapp,x_cp_bouquet
						  Where Cps_Ptb_Id = Ptb_Id
						  And Cb_Id = Cps_Subbouquet_Id
					   ) sub_bouquet
				From  X_Cp_Plt_Terr_Bouq
					   ,x_cp_media_dev_platm_map M
						,x_cp_med_platm_dev_compat_map C
						,x_cl_rel_sch_detail L
						,X_CP_MEDIA_DEVICE D
						,X_CP_MEDIA_DEVICE_COMPAT COM
						,x_cp_lic_medplatmdevcompat_map MM
						,x_cl_release_schedule CRS
						,X_CP_PLT_DEVCOMP_RIGHTS
				Where CRD_PLT_ID = Ptb_Plt_Id(+)
				And  Mpdc_Dev_Platm_Id = Mdp_Map_Id
				AND   CRD_PLAT_CODE = MDP_MAP_PLATM_CODE
				AND   CRD_DEV_ID = MDP_MAP_DEV_ID
				AND   D.MD_ID=MDP_MAP_DEV_ID
				AND   COM.MDC_ID=C.MPDC_COMP_RIGHTS_ID
				AND   MM.LIC_MPDC_LIC_NUMBER=L.CRD_LIC_NUMBER
				AND   L.crd_dev_id=D.MD_ID
				AND   MM.LIC_MPDC_DEV_PLATM_ID=C.mpdc_dev_platm_id
				And   Com.Mdc_Id = Lic_Mpdc_Comp_Rights_Id
				AND   CDCR_PTBT_ID=PTB_ID
				and   cdcr_comp_id=Com.Mdc_Id
				and   cdcr_dev_id=D.MD_ID
        --Join was missing added by swapnil
        AND CRS.CRS_SESSION_ID = L.CRD_SESSION_ID
        --Join was missing added by swapnil
				And   Mm.Lic_Is_Comp_Rights =''Y''
				and   l.crd_bin_id =   '||l_bin_id||'
				and   CRS.CRS_SESSION_ID = '||l_session_id||'
				and PTB_PVR_START_DATE is not null
				and MDC_DELIVERY_METHOD = ''PUSH''
				 )
						group by  START_DATE
				   ,END_DATE
				   ,sub_bouquet
				   ,Bouquet
           ,MD_CODE
				   ,CRD_BIN_ID
				,CRD_PLAT_CODE)
        group by BIN_ID
      ,CRD_PLAT_CODE
      --,wm_concat( distinct MD_CODE) MD_CODE
      ,MDC_DESC
      ,Territory
      ,Bouquet
				   ,START_DATE
				   ,END_DATE
				   ,sub_bouquet';
		else
				----- Before Go live IXS API Reselse API Release logic

		  l_details_data :=
			   'select BIN_ID
      ,CRD_PLAT_CODE
      ,wm_concat( distinct MD_CODE) MD_DESC
      ,MDC_DESC
      ,Territory
      ,Bouquet
				   ,START_DATE
				   ,END_DATE
				   ,sub_bouquet
from (select CRD_BIN_ID BIN_ID
				   ,CRD_PLAT_CODE
				   --,wm_concat( distinct MD_CODE) MD_CODE
           ,MD_CODE
				   ,to_char(wm_concat( distinct MDC_DESC)) MDC_DESC
				   ,to_char(wm_concat( distinct Territory)) Territory
				   ,Bouquet
				   ,START_DATE
				   ,END_DATE
				   ,sub_bouquet
			from (
			 SELECT CRD_BIN_ID,
						''OTT'' CRD_PLAT_CODE,
						L.CRD_DEV_ID,
						D.MD_CODE,
						C.MPDC_COMP_RIGHTS_ID,
						COM.MDC_DESC,
						--CRS_BOUQUET_CODES Bouquet,
						CRS_COUNTRIES Territory,
						to_char(decode(crd_dev_id,1,CRD_PULL_START_DATE,CRD_SCH_START_DATE), ''DD-MM-RRRR hh24:mi:ss'') START_DATE,
						to_char(decode(crd_dev_id,1,CRD_PULL_END_DATE,CRD_SCH_END_DATE ), ''DD-MM-RRRR hh24:mi:ss'') END_DATE,
						null sub_bouquet
				  FROM   x_cp_media_dev_platm_map M
						,x_cp_med_platm_dev_compat_map C
						,x_cl_rel_sch_detail L
						,X_CP_MEDIA_DEVICE D
						,X_CP_MEDIA_DEVICE_COMPAT COM
						,x_cp_lic_medplatmdevcompat_map MM
						,x_cl_release_schedule CRS
				  WHERE  MPDC_DEV_PLATM_ID = MDP_MAP_ID
				  AND   CRD_PLAT_CODE = MDP_MAP_PLATM_CODE
				  AND   CRD_DEV_ID = MDP_MAP_DEV_ID
				  AND   D.MD_ID=MDP_MAP_DEV_ID
				  AND   COM.MDC_ID=C.MPDC_COMP_RIGHTS_ID
				  AND   MM.LIC_MPDC_LIC_NUMBER=L.CRD_LIC_NUMBER
				  AND   L.crd_dev_id=D.MD_ID
				  AND   MM.LIC_MPDC_DEV_PLATM_ID=C.mpdc_dev_platm_id
				  AND   COM.MDC_ID = lic_mpdc_comp_rights_id
				  and   crs_bin_id = crd_bin_id
        --Join was missing added by swapnil
        AND CRS.CRS_SESSION_ID = L.CRD_SESSION_ID
        --Join was missing added by swapnil
				 -- AND   L.crd_curr_flag =''C''
				  AND   MM.lic_is_comp_rights =''Y''
          AND mpdc_is_comp_rights = ''Y''
				  and MDC_DELIVERY_METHOD = ''PULL''
  				  and   l.crd_bin_id =   '||l_bin_id||'
				  and   CRS.CRS_SESSION_ID = '||l_session_id||'
        --  and l.CRD_PULL_START_DATE is not null
          AND ( (D.MD_CODE = ''EXP'' AND l.CRD_PULL_START_DATE is not null)
                or( D.MD_CODE <> ''EXP''))
				  UNION ALL
				  SELECT CRD_BIN_ID,
						''SAT'' CRD_PLAT_CODE,
						L.CRD_DEV_ID,
						D.MD_CODE,
						C.MPDC_COMP_RIGHTS_ID,
						COM.MDC_DESC,
						--CRS_BOUQUET_CODES Bouquet,
						CRS_COUNTRIES Territory,
						to_char(decode(crd_dev_id,1,CRD_PUSH_START_DATE,CRD_SCH_START_DATE), ''DD-MM-RRRR hh24:mi:ss'') START_DATE,
						to_char(decode(crd_dev_id,1,CRD_PUSH_END_DATE,CRD_SCH_END_DATE ), ''DD-MM-RRRR hh24:mi:ss'') END_DATE,
						null sub_bouquet
				  FROM   x_cp_media_dev_platm_map M
						,x_cp_med_platm_dev_compat_map C
						,x_cl_rel_sch_detail L
						,X_CP_MEDIA_DEVICE D
						,X_CP_MEDIA_DEVICE_COMPAT COM
						,x_cp_lic_medplatmdevcompat_map MM
						,x_cl_release_schedule CRS
				  WHERE  MPDC_DEV_PLATM_ID = MDP_MAP_ID
				  AND   CRD_PLAT_CODE = MDP_MAP_PLATM_CODE
				  AND   CRD_DEV_ID = MDP_MAP_DEV_ID
				  AND   D.MD_ID=MDP_MAP_DEV_ID
				  AND   COM.MDC_ID=C.MPDC_COMP_RIGHTS_ID
				  AND   MM.LIC_MPDC_LIC_NUMBER=L.CRD_LIC_NUMBER
				  AND   L.crd_dev_id=D.MD_ID
				  AND   MM.LIC_MPDC_DEV_PLATM_ID=C.mpdc_dev_platm_id
				  AND   COM.MDC_ID = lic_mpdc_comp_rights_id
				  and   crs_bin_id = crd_bin_id
        --Join was missing added by swapnil
        AND CRS.CRS_SESSION_ID = L.CRD_SESSION_ID
        --Join was missing added by swapnil
				--  AND   L.crd_curr_flag =''C''
				  AND   MM.lic_is_comp_rights =''Y''
           AND mpdc_is_comp_rights = ''Y''
				  and MDC_DELIVERY_METHOD = ''PUSH''
          --and l.CRD_PUSH_START_DATE is not null
          AND ( (D.MD_CODE = ''EXP'' AND l.CRD_PUSH_START_DATE is not null)
                or( D.MD_CODE <> ''EXP''))
				  and   l.crd_bin_id =   '||l_bin_id||'
				  and   CRS.CRS_SESSION_ID = '||l_session_id||'
				 )
			 ,(	select column_value Bouquet
				FROM TABLE (X_PKG_CM_SPLIT_STRING.split_to_char ('''||l_CRS_BOUQUET_CODES||'''))
              ) temp
			group by  START_DATE
				   ,END_DATE
				   ,sub_bouquet
				   ,Bouquet
           ,MD_CODE
				   ,CRD_BIN_ID
				,CRD_PLAT_CODE)
        group by BIN_ID
      ,CRD_PLAT_CODE
      --,wm_concat( distinct MD_CODE) MD_CODE
      ,MDC_DESC
      ,Territory
      ,Bouquet
				   ,START_DATE
				   ,END_DATE
				   ,sub_bouquet';
				----- Before Go live IXS API Reselse API Release logic end
		END IF;
--dbms_output.put_line(l_details_data);

OPEN o_playlist_data FOR  l_details_data;

End X_PRC_IXS_RELEASE_SCHEDULE;

  FUNCTION X_fun_get_bouquet(I_Bin_Id  in  Number
                            ,I_Bin_Lic_Number in Number)
  Return Varchar2
  is
    l_bouquet X_CL_GTT_RELEASE_SCHEDULE.GRS_BOUQUET_CODES%type;
  begin
    SELECT RTRIM(XMLAGG(XMLELEMENT(e,cb_short_code || ',')).EXTRACT('//text()'),',')
    into l_bouquet
    from (select distinct cb_short_code
					FROM x_cp_bouquet,X_CP_PLAY_LIST,X_CP_PLT_DEV_SUBBOUQ_MAPP
					WHERE CPS_PLT_ID=PLT_ID
          and CPS_SUBBOUQUET_ID=CB_ID
          and plt_lic_number = i_bin_lic_number
					AND plt_bin_id =i_bin_id);
    return l_bouquet;
    exception when others
    then
      return null;
  end X_fun_get_bouquet;

PROCEDURE X_PRC_SAVE_RELEASE_LATER
 (
  I_BIN_ID in X_CL_GTT_REL_SCH_DETAIL.GRD_BIN_ID%type,
  I_LANGUAGE IN x_cl_release_schedule.CRS_TAP_UID_LANG%type,
  I_SCH_PLAN_MONTH  IN  DATE,
  I_USER_NAME in X_CL_GTT_REL_SCH_DETAIL.GRD_ENTRY_OPER%type,
  O_RESULT OUT NUMBER
 )
 AS
 l_plan_month NUMBER;
 BEGIN
  O_RESULT := 1;

  l_plan_month := to_number(to_char(I_SCH_PLAN_MONTH, 'RRRRMM'));

  INSERT INTO X_CL_RELEASE_LATER VALUES(I_BIN_ID, I_LANGUAGE, l_plan_month, I_USER_NAME, 'N',sysdate);

  EXCEPTION WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20601, 'Could not capture records for release later');
END X_PRC_SAVE_RELEASE_LATER;

		FUNCTION X_fun_secondary_genre
		(
			i_gen_refno  in  NUMBER
			,i_ser_number in  NUMBER
			,i_series_flag in varchar2
			,i_lang_id  in number
		)
		Return Varchar2
		Is
			L_sec_genere_Str varchar2(1000);
		Begin
			IF i_series_flag = 'Y'
			THEN
				SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_VALUE || ',')).EXTRACT('//text()'),',') CAS_NAME
				into L_sec_genere_Str
				FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
				WHERE COD_TYPE = 'VOD_GENRE'
				AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
				AND D.GD_GEN_REFNO = i_ser_number
				AND D.GD_IS_SERIES_FLAG = 'Y'
				AND D.GD_LANG_ID = i_lang_id
				ORDER BY C.COD_VALUE
				;

			ELSE
				SELECT RTRIM(XMLAGG(XMLELEMENT(C, C.COD_VALUE || ',')).EXTRACT('//text()'),',') CAS_NAME
				into L_sec_genere_Str
				FROM X_PROG_VOD_GENRE_DETAILS D, FID_CODE C
				WHERE COD_TYPE = 'VOD_GENRE'
				AND C.COD_ATTR1 = D.GD_GENRE_MAPP_ID
				AND D.GD_GEN_REFNO = i_gen_refno
				AND D.GD_LANG_ID = i_lang_id
				ORDER BY C.COD_VALUE
				;
			END IF;

			return L_sec_genere_Str;
		END X_fun_secondary_genre;
END X_PKG_CL_CSV_GENERATION;
/
