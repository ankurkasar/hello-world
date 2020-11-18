CREATE OR REPLACE PACKAGE X_PKG_ALIC_MAGIC_LIC_DATES
AS
   /******************************************************************************
      NAME:       X_PKG_ALIC_MAGIC_LIC_DATES
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        18/12/2012             1. Created this package.

     CREATED BY PRANAY KUSUMWAL FOR CATCHUP R2 CACQ13
   ******************************************************************************/
   PROCEDURE prc_licence_search (
      i_lic_number      IN     VARCHAR2,
      i_lic_gen_refno   IN     VARCHAR2,
      i_gen_title       IN     fid_general.gen_title%TYPE,
      o_lic_data           OUT pkg_alic_mn_magic_lic_copier.c_lic_search_data);

   PROCEDURE prc_licence_details_search (
      i_lic_number                IN     VARCHAR2,
      o_lic_detail_data              OUT pkg_alic_mn_magic_lic_copier.c_lic_search_data,
      o_lic_cha_alloc_data           OUT pkg_alic_mn_magic_lic_copier.c_lic_search_cha_alloc_data,
      o_lic_territory_data           OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
      o_searchmediasermediaplat      OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
      o_costed_prog_type             OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data);

   PROCEDURE prc_edit_licence_date (i_lic_number        IN     VARCHAR2,
                                    i_lic_lee_number    IN     NUMBER,
                                    i_lic_chs_number    IN     NUMBER,
                                    i_lic_con_number    IN     NUMBER,
                                    i_lic_gen_refno     IN     VARCHAR2,
                                    i_lic_period_tba    IN     VARCHAR2,
                                    i_lee_number_list   IN     VARCHAR2,
                                    i_lic_start         IN     DATE,
                                    i_lic_end           IN     DATE,
                                    i_contract_series   IN     VARCHAR2,
                                    i_entry_oper        IN     VARCHAR2,
				     ---Added By Rashmi For Svod For Deal:RDT :start
                                    i_from_episode      IN     Number,
                                    i_to_episodes       IN     Number,
                                    i_IncmentLicStrtDays In    NUmber,
                                    i_IncremntLicEndDays In    Number,
                                    i_IsAlter            IN    Varchar2,
                                    i_IsIncrement           IN   Varchar2,
				     ---Added By Rashmi For Svod For Deal:RDT  :End
                                    o_count                OUT NUMBER,
                                    o_status               OUT NUMBER);
END x_pkg_alic_magic_lic_dates;
/
CREATE OR REPLACE PACKAGE BODY X_PKG_ALIC_MAGIC_LIC_DATES
AS
   /******************************************************************************
      NAME:       X_PKG_ALIC_MAGIC_LIC_DATES
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        18/12/2012             1. Created this package.

     CREATED BY PRANAY KUSUMWAL FOR CATCHUP R2 CACQ13
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
               lic_update_count,
            (Select Count(1)
                From Fid_General
                where gen_Ser_number = fg.gen_Ser_number
                ) epicount
          FROM fid_license,
               fid_general fg,
               fid_licensee,
               fid_contract
         WHERE lic_gen_refno = fg.gen_refno
           AND con_number = lic_con_number
           and lic_budget_code IN(select cod_value from fid_code where cod_attr1=''Y'')

           AND lee_number(+) = lic_lee_number and LIC_STATUS not in (''T'',''I'',''C'')) a
          where rownum<500
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

     -- DBMS_OUTPUT.put_line (l_query_string);

      OPEN o_lic_data FOR l_query_string;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_licence_search;

   PROCEDURE prc_licence_details_search (
      i_lic_number                IN     VARCHAR2,
      o_lic_detail_data              OUT pkg_alic_mn_magic_lic_copier.c_lic_search_data,
      o_lic_cha_alloc_data           OUT pkg_alic_mn_magic_lic_copier.c_lic_search_cha_alloc_data,
      o_lic_territory_data           OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
      o_searchmediasermediaplat      OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data,
      o_costed_prog_type             OUT pkg_alic_mn_magic_lic_copier.c_lic_search_territory_data)
   AS
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
                NVL (lic_max_chs, 0) lic_max_chs,
                NVL (lic_max_cha, 0) lic_max_cha,
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
                --Finance Dev Phase I Zeshan [Start]
                (SELECT TO_DATE (fim_year || fim_month, 'YYYYMM')
                FROM fid_financial_month
                WHERE fim_split_region = l_split_region
                AND fim_status = 'O') OPEN_MONTH
                --Finance Dev Phase I [End]
           /* Catchup CACQ11 : END 21/03/2012 */
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
                           NVL (lic_non_cons_month, 'N') lic_non_cons_month
                      /* Catchup CACQ11 : END 21/03/2012 */
                      -- Project Bioscope : Ajit_20120314 : End
                      FROM fid_license,
                           fid_general fg,
                           fid_licensee,
                           fid_contract
                     WHERE     lic_gen_refno = fg.gen_refno
                           AND con_number = lic_con_number
                           -- AND chs_number = lic_chs_number
                           AND lee_number(+) = lic_lee_number) a
                LEFT JOIN
                   (  SELECT gen_ser_number, COUNT (*) epicount
                        FROM fid_general
                    GROUP BY gen_ser_number) b
                ON b.gen_ser_number = a.gen_ser_number
          WHERE lic_number = i_lic_number
		  AND 	 LIC_STATUS not in ('T','I','C')
		  ;
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
                                   ---pure finance:[Hari Mandal]:Added for split region
                                   WHERE fim_status = 'C'
                                         AND fim_split_region =
                                                l_split_region))
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
                                    ---pure finance:[Hari Mandal]:Added for split region
                                    WHERE fim_status = 'C'
                                          AND fim_split_region =
                                                 l_split_region)))
                   total_costed_used_runs,
                (NVL (flcrc.lcr_cha_costed_runs, 0)
                 + NVL (flcrc.lcr_cha_costed_runs2, 0))
                   total_costed_runs,
                fc.cha_roy_flag
           FROM fid_license, fid_channel fc, fid_license_channel_runs flcrc
          WHERE     lcr_cha_number = cha_number
                AND flcrc.lcr_lic_number(+) = lic_number
                AND lic_number = i_lic_number
					  AND 	 LIC_STATUS not in ('T','I','C');

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
					  AND 	 LIC_STATUS not in ('T','I','C');

      -- Catch up R2 : to get the list of licensees in the system
      --The existing bioscope cursor(which was sending null) has been used to avoid any UI change
      OPEN o_searchmediasermediaplat FOR
           SELECT lee_number,
                  'N' isleechk,
                  lee_short_name,
                  lee_name,
                  com_short_name,
                  com_name,
                  (SELECT reg_code
                     FROM fid_region
                    WHERE reg_id = lee_region_id)
                     region
             FROM fid_licensee, fid_company
            WHERE lee_cha_com_number = com_number AND com_type = 'CC'
                  AND lee_number IN
                         (SELECT DISTINCT lic_lee_number
                            FROM fid_license
                           WHERE lic_con_number =
                                    (SELECT lic_con_number
                                       FROM fid_license
                                      WHERE lic_number = i_lic_number)
                                 AND lic_budget_code IN (select cod_value from fid_code where cod_attr1='Y')
                                 AND lic_gen_refno =
                                        (SELECT lic_gen_refno
                                           FROM fid_license
                                          WHERE lic_number = i_lic_number))

         ORDER BY lee_number;

      OPEN o_costed_prog_type FOR
         SELECT cpt_gen_type FROM sgy_pb_costed_prog_type;
   -- Project Bioscope  End
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20010, SUBSTR (SQLERRM, 1, 200));
   END prc_licence_details_search;

   PROCEDURE prc_edit_licence_date (i_lic_number        IN     VARCHAR2,
                                    i_lic_lee_number    IN     NUMBER,
                                    i_lic_chs_number    IN     NUMBER,
                                    i_lic_con_number    IN     NUMBER,
                                    I_LIC_GEN_REFNO     IN     VARCHAR2,
                                    ---DEV 8 RDT --[Deepak Gharge] [16/09/2013]---
                                    i_lic_period_tba    IN     VARCHAR2,
                                    i_lee_number_list   IN     VARCHAR2,
                                    i_lic_start         IN     DATE,
                                    i_lic_end           IN     DATE,
                                    i_contract_series   IN     VARCHAR2,
                                    i_entry_oper        IN     VARCHAR2,
                             --   ---Added By Rashmi For Svod For Deal:RDT
                                    i_from_episode      IN     Number,
                                    i_to_episodes       IN     Number,
                                    i_IncmentLicStrtDays In    NUmber,
                                    i_IncremntLicEndDays In    Number,
                                    i_IsAlter            IN    Varchar2,
                                    i_IsIncrement           IN   Varchar2,
                              --   ---Added By Rashmi For Svod For Deal:RDT
                                    o_count                OUT NUMBER,
                                    o_status               OUT NUMBER)
   AS
      l_message                   VARCHAR2 (200);
      l_ser_number                NUMBER;
      select_contract_or_series   EXCEPTION;
      o_lic_start                 fid_license.lic_start%TYPE;
      o_lic_end                   fid_license.lic_end%TYPE;
      o_lic_period_tba            fid_license.lic_period_tba%TYPE;
      l_con_catchup_flag          fid_contract.con_catchup_flag%TYPE;
      l_changed_date_flag         VARCHAR2 (30);
      l_lee_number                NUMBER;
      l_string                    VARCHAR2 (2000);
      l_lee_catchup               VARCHAR2 (20);
      x_lic_start                 fid_license.lic_start%TYPE;
      x_lic_end                   fid_license.lic_end%TYPE;
      t_count                     NUMBER := 0;
      p_count                     NUMBER := 0;
      count_sch_end               NUMBER;
      count_sch_start             NUMBER;
      count_play_list_end         NUMBER;
      count_play_list_start       NUMBER;
      --Dev2: Costing 5+2 Rules :Rashmi Tijare_20140505 : Go live date of costing 5+2
      v_go_live_crc_date          DATE;
      l_costed_runs               X_FIN_COSTING_RULE_CONFIG%ROWTYPE;
      Costrulenotexists           EXCEPTION;
      L_Count_5_2                 NUMBER := 0;
      L_Count_Dates               NUMBER := 0;
      L_Count_Dates_5_2_After     NUMBER := 0;
      l_count_dates_5_2_before    NUMBER := 0;
      L_IS_VALID_DATE             number;
      l_IncmentLicStrtDays        number:=0;
      L_IncremntLicEndDays        number:=0;
      l_new_strt_date             date;
      l_new_end_date              date;
      u_count                     number:=0;
      l_lee_name                  varchar2(30);
      l_min_epi                   number;
      l_max_epi                   number;
      L_OPEN_MONTH                VARCHAR2(1024);-- Finace Dev Phase 1 [Ankur Kasar]
      L_GO_LIVE_DATE              DATE;-- Finace Dev Phase 1 [Ankur Kasar]

      --start :Ankur.Kasar added sp to send reversal mail.
      l_lic_number_ary  			x_pkg_common_var.number_array;
      l_gen_title_ary    			x_pkg_common_var.varchar_array;
      l_old_lic_start_ary			x_pkg_common_var.date_array;
      l_new_lic_start_ary			x_pkg_common_var.date_array;
      l_con_name_ary			  	x_pkg_common_var.varchar_array;
      l_con_short_name_ary		x_pkg_common_var.varchar_array;
      l_lic_lee_number_ary		x_pkg_common_var.number_array;
      l_trc_query             varchar2(1024);
      --End: Ankur.Kasar added sp to send reversal mail.
      CURSOR get_costed_runs
      IS
         SELECT *
           FROM X_FIN_COSTING_RULE_CONFIG
          WHERE i_lic_start BETWEEN crc_lic_start_from AND crc_lic_start_to;
   --Dev2: Costing 5+2 Rules :Rashmi Tijare_20140505: End
   BEGIN

      l_string := i_lee_number_list;

      WHILE (l_string IS NOT NULL)
      LOOP
         IF INSTR (l_string, ',') > 0
         THEN
            l_lee_number := SUBSTR (l_string, 1, INSTR (l_string, ',') - 1);
            l_string :=
               SUBSTR (l_string,
                       INSTR (l_string, ',') + 1,
                       LENGTH (l_string));
         ELSE
            l_lee_number := l_string;
            l_string := NULL;
         END IF;

         SELECT NVL (lee_media_service_code, 'N')
           INTO l_lee_catchup
           FROM fid_licensee
          WHERE lee_number = l_lee_number;

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
               Raise_Application_Error (-20602, Substr (Sqlerrm, 1, 200));
         END;



         IF l_lee_catchup = 'CATCHUP'
         THEN
            FOR x
               In (Select Distinct Lic_Number
                     FROM fid_license,fid_general
                    Where Lic_Lee_Number = L_Lee_Number
                    And Lic_Gen_Refno = Gen_Refno
                    and gen_ser_number = l_ser_number
                    AND lic_con_number = i_lic_con_number)
            LOOP
               SELECT lic_start,
                      lic_end,
                      lic_period_tba,
                      NVL (lic_catchup_flag, 'N')
                 INTO o_lic_start,
                      o_lic_end,
                      o_lic_period_tba,
                      L_Con_Catchup_Flag
                 FROM fid_license, fid_contract
                Where Lic_Con_Number = Con_Number
                AND lic_number = x.lic_number;

               x_pkg_cp_license_upd_validate.prc_cp_lic_before_upd_valid (
                  x.lic_number,
                  i_lic_start,
                  i_lic_end,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  o_lic_period_tba,
                  i_entry_oper);
            END LOOP;
         END IF;


           SELECT COUNT (*)
           INTO count_play_list_end
           FROM x_cp_play_list
          WHERE plt_sch_start_date > i_lic_end
                AND plt_lic_number IN
                       (SELECT lic_number
                          FROM fid_license
                         WHERE     lic_con_number = i_lic_con_number
                               AND lic_lee_number = i_lic_lee_number
                               AND lic_status <> 'I'
                               AND lic_gen_refno IN
                                      (SELECT gen_refno
                                         FROM fid_general
                                        WHERE gen_ser_number = l_ser_number));

         SELECT COUNT (*)
           INTO count_play_list_start
           FROM x_cp_play_list
          WHERE plt_sch_start_date < i_lic_start
                AND plt_lic_number IN
                       (SELECT lic_number
                          FROM fid_license
                         WHERE     lic_con_number = i_lic_con_number
                               AND lic_lee_number = i_lic_lee_number
                               AND lic_status <> 'I'
                               AND lic_gen_refno IN
                                      (SELECT gen_refno
                                         FROM fid_general
                                        WHERE gen_ser_number = l_ser_number));

         IF count_play_list_end > 0 OR count_play_list_start > 0
         THEN
            raise_application_error (
               -20102,
               'One of the license of this series is scheduled beyond the updated dates,cannot change License Start Date or End Date.' -- 'License is Scheduled beyond the updated dates. Cannot change License Start Date or End Date. '
                                                                                                                                      );
         END IF;

         SELECT COUNT (*)
           INTO count_sch_end
           from FID_SCHEDULE
          where to_date(SCH_FIN_ACTUAL_DATE||' '||convert_time_n_c(sch_time) ,'DD-MON-RRRR HH24:MI:SS') > TO_DATE(TO_CHAR(I_LIC_END,'DD-MON-RRRR')||' '||'19:59:59','DD-MON-RRRR HH24:MI:SS')      --sch_date > i_lic_end  16Apr2015 : P1 Issue :Jawahar : Allowing to schedule after lic_end date for midnight schedule after 12.Used sch_fin_actual_date

                AND sch_lic_number IN
                       (SELECT lic_number
                          FROM fid_license
                         WHERE     lic_con_number = i_lic_con_number
                               AND lic_lee_number = l_lee_number
                               AND lic_status <> 'I'
                               AND lic_gen_refno IN
                                      (SELECT gen_refno
                                         FROM fid_general
                                        WHERE gen_ser_number = l_ser_number -- AND gen_refno     != i_lic_gen_refno
                                                                           ));

         SELECT COUNT (*)
           INTO count_sch_start
           from FID_SCHEDULE
          WHERE sch_fin_actual_date < i_lic_start                                  --sch_date < i_lic_start 16Apr2015 : P1 Issue :Jawahar : Allowing to schedule after lic_end date for midnight schedule after 12.Used sch_fin_actual_date
                AND sch_lic_number IN
                       (SELECT lic_number
                          FROM fid_license
                         WHERE     lic_con_number = i_lic_con_number
                               AND lic_lee_number = l_lee_number
                               AND lic_status <> 'I'
                               AND lic_gen_refno IN
                                      (SELECT gen_refno
                                         FROM fid_general
                                        Where Gen_Ser_Number = L_Ser_Number -- AND gen_refno     != i_lic_gen_refno
                                                                           ));

         IF count_sch_end > 0 OR count_sch_start > 0
         THEN
            raise_application_error (
               -20102,
               'One of the license of this series is scheduled beyond the updated dates,cannot change License Start Date or End Date.' -- 'License is Scheduled beyond the updated dates. Cannot change License Start Date or End Date. '
                                                                                                                                      );
         END IF;
         --Dev2: Costing 5+2 Rules :Rashmi_Tijare 20140505 : Go live date of costing 5+2
         SELECT TO_DATE (content)
           INTO v_go_live_crc_date
           FROM x_fin_configs
          WHERE ID = 6;

         IF (i_lic_start >= v_go_live_crc_date)
         THEN
            BEGIN
               OPEN get_costed_runs;

               FETCH get_costed_runs INTO l_costed_runs;

               IF get_costed_runs%NOTFOUND
               THEN
                  RAISE costrulenotexists;
               END IF;

               CLOSE get_costed_runs;
            EXCEPTION
               WHEN costrulenotexists
               THEN
                  raise_application_error (
                     -20601,
                     'Costing rule for this date is not defined on Costing Rule Configuration screen.');
            END;
         END IF;

         --Dev2: Costing 5+2 Rules :Rashmi_Tijare 20140505: End

         --Dev2: Costing 5+2 Rules :Aditya_Gupta 20140701: Start

         DELETE FROM x_gtt_Lic_Start_Dates;

         FOR j
            IN (SELECT lic_start
                  FROM fid_license
                 WHERE     lic_con_number = i_lic_con_number
                       AND Lic_Lee_Number = L_Lee_Number
                       AND Lic_Status <> 'I'
                       AND lic_showing_lic <> 0               ----- 26-07-2014
                       AND Lic_Gen_Refno IN
                              (SELECT Gen_Refno
                                 FROM Fid_General
                                WHERE Gen_Ser_Number = L_Ser_Number))
         LOOP
            INSERT INTO x_gtt_Lic_Start_Dates
                 VALUES (j.lic_start);
         END LOOP;

         SELECT COUNT (*) INTO L_Count_Dates FROM X_Gtt_Lic_Start_Dates;

         FOR I IN (SELECT Lic_Start_Date FROM X_Gtt_Lic_Start_Dates)
         LOOP
            IF I.Lic_Start_Date < V_Go_Live_Crc_Date
            THEN
               L_Count_Dates_5_2_Before := L_Count_Dates_5_2_Before + 1;
            ELSE
               L_Count_Dates_5_2_After := L_Count_Dates_5_2_After + 1;
            END IF;
         END LOOP;


         IF ( (L_Count_Dates_5_2_Before <> L_Count_Dates)
             AND (L_Count_Dates_5_2_After <> L_Count_Dates))
         THEN
            raise_application_error (
               -20601,
               'Licenses have different costing rule applicable to them, cannot be copied.');
         END IF;

         L_Count_Dates_5_2_Before := 0;
         L_Count_Dates_5_2_After := 0;

     ---Added By Rashmi For Svod For Deal:RDT    :start
                  SELECT min(gen_epi_number),max(gen_epi_number)
                  into l_min_epi,l_max_epi
                   FROM fid_general
                  WHERE gen_ser_number = l_ser_number;


    If i_IsAlter = 'N' and i_IsIncrement ='Y'
            Then
    if i_from_episode < l_min_epi  or i_to_episodes >l_max_epi
    then
    raise_application_error(-20605,'Please enter the episode range between '|| l_min_epi ||' and ' ||l_max_epi);
    end if;
    
    End if;

     If i_IsAlter = 'N' and i_IsIncrement ='Y'
        Then

       select count (*) INTO L_IS_VALID_DATE
        from (  SELECT  lic_start
                  FROM fid_license
                 WHERE     lic_con_number = i_lic_con_number
                       AND Lic_Lee_Number = L_Lee_Number
                       --AND lic_number =i_lic_number
                     --  AND lic_showing_lic <> 0                   --26-07-2014
                       AND Lic_Status <> 'I'
                       AND Lic_Gen_Refno IN
                              (SELECT gen_refno
                                 FROM fid_general
                                WHERE gen_ser_number = l_ser_number
                                and gen_epi_number between i_from_episode and i_to_episodes)
                                 group by lic_start);


        IF L_IS_VALID_DATE > 1
        THEN
        for t in
                (SELECT lee_short_name
                  FROM fid_licensee,fid_license
                 WHERE     lic_con_number = i_lic_con_number
                       and lic_lee_number =lee_number
                       AND Lic_Lee_Number = L_Lee_Number)

            loop
            raise_application_error (
               -20601,
               'License Start Dates of episodes for licensee ' ||t.lee_short_name ||' are not same');
           end loop;
        end if;
        End if;
     ---Added By Rashmi For Svod For Deal:RDT    :End
         FOR j
            IN (SELECT lic_number, lic_start, lic_showing_lic
                  FROM fid_license
                 WHERE     lic_con_number = i_lic_con_number
                       AND Lic_Lee_Number = L_Lee_Number
                       AND lic_showing_lic <> 0                   --26-07-2014
                       AND Lic_Status <> 'I'
                       AND Lic_Gen_Refno IN
                              (SELECT gen_refno
                                 FROM fid_general
                                WHERE gen_ser_number = l_ser_number))
         LOOP


            --Dev2: Costing 5+2 Rules :Rashmi_Tijare 20140722: Start

            IF i_lic_start >= v_go_live_crc_date
            THEN
               SELECT COUNT (*)
                 INTO L_Count_5_2
                 FROM x_fin_costing_rule_config r
                WHERE R.Crc_Costed_Runs = J.Lic_Showing_Lic
                      AND i_lic_start                            --J.Lic_Start
                                     BETWEEN r.crc_lic_start_from
                                         AND r.crc_lic_start_to;

               IF l_count_5_2 = 0
               THEN
                  ROLLBACK;
                  raise_application_error (
                     -20601,
                     'Copy not allowed as rule not defined for destination Licensee Costed Runs');
               ELSE
                  UPDATE fid_license_channel_runs
                     SET lcr_cost_ind = 'N',
                         lcr_cha_costed_runs = 0,
                         lcr_cha_costed_runs2 = 0
                   WHERE lcr_lic_number = j.lic_number;
               END IF;
            END IF;
         --Dev2: Costing 5+2 Rules :Rashmi_Tijare 20140722: End

         END LOOP;

         --Dev2: Costing 5+2 Rules :Aditya_Gupta 20140701: End
      If i_IsAlter = 'Y' and i_IsIncrement ='N'  ---Added By Rashmi For Svod For Deal:RDT
      Then

      --Start [27-Jun-2016][Ankur.Kasar]Changes done for FINCR
      BEGIN
     insert into x_lic_details
       SELECT  LIC_NUMBER,
                          gen_title,
                          LIC_START,
                          i_lic_start,
                          con_name,
                          con_short_name,
                          lic_lee_number
                          from fid_license 	fl
                          ,fid_general fg
                          ,fid_contract fc
                    WHERE     lic_con_number = i_lic_con_number
                          AND fl.lic_gen_refno = fg.gen_refno
                          AND fl.lic_con_number = fc.con_number
                          AND lic_lee_number = l_lee_number
                          AND LIC_STATUS not in ('T','I','C')
                          and LIC_WRITEOFF_MARK = 'Y'
                          AND lic_gen_refno IN
                                            (SELECT gen_refno
                                             FROM fid_general
                                             WHERE gen_ser_number = l_ser_number);
                                             commit;
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
              NULL;
						END;
        --End [27-Jun-2016][Ankur.Kasar]Changes done for FINCR
         UPDATE fid_license
            SET lic_start =
                   DECODE (o_lic_start, i_lic_start, lic_start, i_lic_start),
                lic_end = DECODE (o_lic_end, i_lic_end, lic_end, i_lic_end),
                ---DEV 8 RDT --START --[Deepak Gharge] [16/09/2013]---
                -- lic_period_tba = decode(o_lic_period_tba,i_lic_period_tba,lic_period_tba,i_lic_period_tba),
                LIC_PERIOD_TBA = I_LIC_PERIOD_TBA,
                lic_entry_oper = i_entry_oper
          WHERE     lic_con_number = i_lic_con_number
                AND lic_lee_number = l_lee_number
                AND 	 LIC_STATUS not in ('T','I','C')
                AND lic_gen_refno IN (SELECT gen_refno
                                        FROM fid_general
                                       WHERE gen_ser_number = l_ser_number);

        P_Count := Sql%Rowcount;
	 ---Added By Rashmi For Svod For Deal:RDT   :start
        T_count := P_Count+ T_Count;
      ELSIF i_IsAlter = 'N' and i_IsIncrement ='Y'
      Then
         FOR l
            IN (SELECT lic_number, lic_period_tba, lic_start,lic_end
                  FROM fid_license
                 WHERE     lic_con_number = i_lic_con_number
                       AND lic_lee_number = l_lee_number
                       -- and    lic_chs_number = i_lic_chs_number
                       AND lic_status <> 'I'
                       AND lic_gen_refno IN
                              (SELECT gen_refno
                                 FROM fid_general
                                WHERE gen_ser_number = l_ser_number -- and gen_refno     != i_lic_gen_refno
                                  and gen_epi_number between i_from_episode +1 and i_to_episodes
                                  and i_to_episodes - i_from_episode <> 0 ))
       loop
       l_IncmentLicStrtDays:=i_IncmentLicStrtDays+l_IncmentLicStrtDays;
       L_IncremntLicEndDays :=i_IncremntLicEndDays +L_IncremntLicEndDays;
       -- select DECODE (o_lic_start, i_lic_start, l.lic_start, i_lic_start)+l_IncmentLicStrtDays into l_new_strt_date from dual;
        l_new_strt_date:=  l.lic_start+l_IncmentLicStrtDays ;
       -- select DECODE (o_lic_end, i_lic_end, l.lic_end, i_lic_end)+i_IncremntLicEndDays into l_new_end_date from dual;
        l_new_end_date:=  l.lic_end+L_IncremntLicEndDays;

       --Dev.R1: Finace DEV Phase 1 :[BR_16_404_UC_ Restriction on Updating License End Date to Closed Financial Month]_[Ankur Kasar]_[2016/10/24]: Start
          
           SELECT TO_DATE(CONTENT,'DD-MON-RR')
             INTO L_GO_LIVE_DATE
             FROM x_fin_configs
            WHERE ID = 1;
          
           SELECT FLM.FIM_YEAR||LPAD(FLM.FIM_MONTH,02,0) INTO L_OPEN_MONTH
             FROM FID_LICENSE FL,
                  FID_LICENSEE FLE,
                  FID_FINANCIAL_MONTH FLM
            WHERE FL.LIC_LEE_NUMBER = FLE.LEE_NUMBER
              AND FLE.LEE_SPLIT_REGION =FLM.FIM_SPLIT_REGION
              AND FLM.FIM_STATUS = 'O'
              AND FL.LIC_NUMBER = l.lic_number;
          
           IF TO_CHAR(l_new_end_date,'RRRRMM') < L_OPEN_MONTH
           THEN
             raise_application_error (
                       -20601,
                       'License End Date cannot be changed to Closed Financial Month .');
           END IF;
          
           IF l_new_strt_date < L_GO_LIVE_DATE
           THEN
             raise_application_error (
                       -20601,
                       'License Start Date Cannot be Prior to '||L_GO_LIVE_DATE);
           END IF;
         --Dev.R1: Finace DEV Phase 1 :[BR_16_404_UC_ Restriction on Updating License End Date to Closed Financial Month]_[Ankur Kasar]_[2016/10/24]: End


        if l_new_strt_date <l_new_end_date
        then
        --Start [27-Jun-2016][Ankur.Kasar]Changes done for FINCR
          BEGIN
          insert into x_lic_details
               SELECT   LIC_NUMBER,
                        gen_title,
                        LIC_START,
                        i_lic_start,
                        con_name,
                        con_short_name,
                        lic_lee_number
              FROM       fid_license 	fl
                        ,fid_general fg
                        ,fid_contract fc
               WHERE
                            fl.lic_gen_refno = fg.gen_refno
                        AND fl.lic_con_number = fc.con_number
                        and lic_number = l.lic_number
                        and LIC_WRITEOFF_MARK = 'Y'
                        and i_to_episodes - i_from_episode <> 0;
                        commit;
                EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    NULL;
               END;
        --End [27-Jun-2016][Ankur.Kasar]Changes done for FINCR

        UPDATE fid_license
            SET lic_start = i_lic_start+l_IncmentLicStrtDays,
                --  DECODE (o_lic_start, i_lic_start, l.lic_start, i_lic_start)+l_IncmentLicStrtDays,
                lic_end = i_lic_end+l_IncremntLicEndDays,
              -- DECODE (o_lic_end, i_lic_end, l.lic_end, i_lic_end)+L_IncremntLicEndDays,
              LIC_PERIOD_TBA = I_LIC_PERIOD_TBA,
                lic_entry_oper = i_entry_oper
          WHERE     lic_number = l.lic_number
                and i_to_episodes - i_from_episode <> 0;
         u_count:= u_count +1;

       else
						 rollback;
						 raise_application_error(-20010,'License Start Date cannot be greater than License End Date. Please correct the incremental value');
						 end if;

     End LOOP;

     l_IncmentLicStrtDays :=0;
     L_IncremntLicEndDays :=0;
End if;
     ---Added By Rashmi For Svod For Deal:RDT   :End
       --  DBMS_OUTPUT.put_line ('p_count' || p_count);
        -- DBMS_OUTPUT.put_line (p_count);

         --Deepak RDT DEV 8
         IF NVL (i_lic_period_tba, 'N') = 'Y'
         THEN
            l_changed_date_flag := 'BOTH';
         ELSE
            IF i_lic_start != x_lic_start AND i_lic_end != x_lic_end
            THEN
               l_changed_date_flag := 'BOTH';
            ELSIF i_lic_start != x_lic_start
            THEN
               l_changed_date_flag := 'START';
            ELSIF i_lic_end != x_lic_end
            THEN
               l_changed_date_flag := 'END';
            END IF;
         END IF;

         FOR i
            IN (SELECT lic_number, lic_period_tba, lic_start
                  FROM fid_license
                 WHERE     lic_con_number = i_lic_con_number
                       AND lic_lee_number = l_lee_number
                       -- and    lic_chs_number = i_lic_chs_number
                       AND lic_status <> 'I'
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

         --        END IF;
         -- t_count := p_count + t_count;
         --Deepak RDT DEV 8 Fix for no of rows updated
        -- t_count := p_count;
      --End Deepak
      END LOOP;
--Ankur.Kasar added sp to send reversal mail.
      COMMIT;
       ---Added By Rashmi For Svod For Deal:RDT  :start
      If i_IsAlter = 'Y' and i_IsIncrement ='N'
      then
      O_Count := T_Count;
      else
      O_Count := u_count;
      End if;
     -- DBMS_OUTPUT.put_line ('o_count' || o_count);
     If i_IsAlter = 'Y' and i_IsIncrement ='N'
     then
      O_Status := 1;
      Else
      O_Status := u_count;
      End if;
       ---Added By Rashmi For Svod For Deal:RDT  :end

      --Start [27-Jun-2016][Ankur.Kasar]Changes done for FINCR
      begin
        select  lic_number ,
        gen_title ,
        lic_start ,
        start_date ,
        con_name ,
        con_short_name ,
        lic_lee_number

        BULK
          COLLECT
        INTO
                 l_lic_number_ary
                ,l_gen_title_ary
                ,l_old_lic_start_ary
                ,l_new_lic_start_ary
                ,l_con_name_ary
                ,l_con_short_name_ary
                ,l_lic_lee_number_ary
        from x_lic_details;

      EXCEPTION
      WHEN no_data_found
      then
         null;
      end;
     IF  l_lic_number_ary.count >0
     THEN
            begin
          	X_PKG_SEND_LIC_REV_MAIL.X_PRC_CHK_LIC_REV (
						I_LIC_NUMBER			  	=> l_lic_number_ary,
						I_TITLE               => l_gen_title_ary,
						I_LEE_NUMBER          => l_lic_lee_number_ary,
						I_OLD_LIC_START				=> l_old_lic_start_ary,
						I_NEW_LIC_START				=> l_new_lic_start_ary,
						I_CON_SHORT_NAME      => l_con_short_name_ary,
						I_CON_NAME            => l_con_name_ary,
						I_USER					      => i_entry_oper
					 );
            EXCEPTION
            WHEN OTHERS
            THEN
                raise_application_error (-20601,SUBSTR(SQLERRM,1,200));
           end;
     END IF;
       l_trc_query := 'TRUNCATE TABLE x_lic_details';
       EXECUTE IMMEDIATE l_trc_query;
    --End [27-Jun-2016][Ankur.Kasar]Changes done for FINCR

   EXCEPTION
      WHEN select_contract_or_series
      THEN
         raise_application_error (-20010, l_message);
      WHEN OTHERS
      THEN
         o_status := 0;
         raise_application_error (-20604, SUBSTR (SQLERRM, 1, 200));
   END;

end X_PKG_ALIC_MAGIC_LIC_DATES;
/
