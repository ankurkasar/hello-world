CREATE OR REPLACE PACKAGE PKG_FIN_MNET_MON_FIN_REP
AS
   /**************************************************************************
   REM Module    : Finance
   REM Client    : MNET
   REM File Name    : PKG_FIN_SS_EXC_REPORT
   REM Purpose    : Monthly FInancial Report
   REM Written By    : Vinayak
   REM Updated By     : --
   REM Date    : 24-02-2010
   REM Type    : Database Package
   REM Change History  : Created
   REM **************************************************************************/
   TYPE c_fin_rep IS REF CURSOR;

   -- FUNCTION TO CALCULATE THE PER SHOWING IN AIR_TIME_USED
   FUNCTION fun_air_tim_used_per_shwng (
      i_channel     IN fid_channel.cha_short_name%TYPE,
      i_from_date   IN DATE,
      i_to_date     IN DATE)
      RETURN NUMBER;

   FUNCTION sumcol1 (i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
                     i_lsl_number    x_fin_lic_sec_lee.lsl_number%TYPE,
                     i_from_date     DATE,
                     i_to_date       DATE)
      RETURN NUMBER;

   FUNCTION fun_cost_sale_sch_paid_1 (
      i_from_date     DATE,
      i_to_date       DATE,
      i_lic_number    fid_sch_summary_vw.sch_lic_number%TYPE)
      RETURN NUMBER;

   FUNCTION fun_inv_mmt_report_ex_rate (
      i_lic_currency        fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code        fid_exchange_rate.rat_cur_code_2%TYPE,
      i_acct_prvlng_rate    CHAR,
      i_lic_rate            fid_license.lic_rate%TYPE,
      i_lic_start           fid_license.lic_start%TYPE)
      RETURN NUMBER;

   --AIR TIME USED PER CHANNEL REPORT
   PROCEDURE prc_air_tim_usd_per_chan (
      i_region        IN     VARCHAR2,
      i_channel       IN     fid_channel.cha_short_name%TYPE,
      i_budget_type   IN     fid_code.cod_value%TYPE,
      i_from_date     IN     DATE,
      i_to_date       IN     DATE,
      o_fin_report       OUT pkg_fin_mnet_mon_fin_rep.c_fin_rep);

   --COST OD SALES REPORT PER CHANNEL
   PROCEDURE prc_cost_of_sales_per_chan (
      i_from_date         IN     DATE,
      i_to_date           IN     DATE,
      i_chnl_comp_name    IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_lee_short_name    IN     fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN     fid_license.lic_budget_code%TYPE --Dev2:Pure Finance:Start:[Hari Mandal]_[20/4/2013]
                                                                 ,
      i_region            IN     fid_region.reg_code%TYPE --Dev2:Pure Finance:End-------
                                   --    ,    i_acct_prvlng_rate    in    char
      ,
      o_fin_report           OUT pkg_fin_mnet_mon_fin_rep.c_fin_rep);

   --COMPANY/ADDRESS LISTING
   PROCEDURE prc_com_addr_listing (
      i_company_type   IN     VARCHAR2,
      o_fin_report        OUT pkg_fin_mnet_mon_fin_rep.c_fin_rep);

   --WRITE OFF REPORT
   PROCEDURE prc_write_off_rpt (
      i_region            IN     VARCHAR2,
      i_frst_shld_date    IN     DATE,
      i_last_shld_date    IN     DATE,
      i_subledger_year    IN     NUMBER,
      i_subledger_month   IN     NUMBER,
      o_fin_report           OUT pkg_fin_mnet_mon_fin_rep.c_fin_rep);

/*
Finace dev phase I [Ankur Kasar][start]
*/
   FUNCTION X_Fun_Amo_Exh_Used (
        l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
       -- I_CHA_NUMBER       number,
        i_from_period_date date,
        i_to_period_date   date
     )
        RETURN NUMBER;
/*
Finace dev phase I [Ankur Kasar][End]
*/

END pkg_fin_mnet_mon_fin_rep;

/
CREATE OR REPLACE PACKAGE BODY PKG_FIN_MNET_MON_FIN_REP
AS
   FUNCTION fun_air_tim_used_per_shwng (
      i_channel     IN fid_channel.cha_short_name%TYPE,
      i_from_date   IN DATE,
      i_to_date     IN DATE)
      RETURN NUMBER
   AS
      l_per_showing_is   NUMBER;
   BEGIN
      DBMS_OUTPUT.put_line ('IN FUNCTION');

      BEGIN
         SELECT COUNT (sch_number)
           INTO l_per_showing_is
           FROM fid_schedule,
                fid_channel,
                fid_license,
                fid_general
          WHERE cha_short_name LIKE UPPER (NVL (i_channel, '%'))
                AND sch_per_year || LPAD (sch_per_month, 2, 0) BETWEEN TO_NUMBER (
                                                                          TO_CHAR (
                                                                             i_from_date,
                                                                             'YYYYMM'))
                                                                   AND TO_NUMBER (
                                                                          TO_CHAR (
                                                                             i_to_date,
                                                                             'YYYYMM'))
                AND sch_cha_number = cha_number
                AND gen_refno = lic_gen_refno
                AND gen_duration != 0
                AND sch_lic_number = lic_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_per_showing_is := 0;
      END;

      RETURN l_per_showing_is;
   END;

   --AIR TIME PER CHANNEL --FIDCHA02.rdf
   PROCEDURE prc_air_tim_usd_per_chan (
      i_region        IN     VARCHAR2,
      i_channel       IN     fid_channel.cha_short_name%TYPE,
      i_budget_type   IN     fid_code.cod_value%TYPE,
      i_from_date     IN     DATE,
      i_to_date       IN     DATE,
      o_fin_report       OUT pkg_fin_mnet_mon_fin_rep.c_fin_rep)
   AS
      l_qry              VARCHAR2 (15000);
      l_per_showing_is   NUMBER;
   BEGIN
      SELECT COUNT (sch_number)
        INTO l_per_showing_is
        FROM fid_schedule,
             fid_channel,
             fid_license,
             fid_general
       WHERE cha_short_name LIKE UPPER (NVL (i_channel, '%'))
             AND sch_per_year || LPAD (sch_per_month, 2, 0) >=
                    TO_NUMBER (TO_CHAR (TO_DATE (i_from_date), 'YYYYMM'))
             AND sch_per_year || LPAD (sch_per_month, 2, 0) <=
                    TO_NUMBER (TO_CHAR (TO_DATE (i_to_date), 'YYYYMM'))
             AND sch_cha_number = cha_number
             AND gen_refno = lic_gen_refno
             AND gen_duration != 0
             AND sch_lic_number = lic_number
             --Dev2: Non Costed Filler : Start:[NCF_Fin1]_[Manish]_[2013/03/15]
             --[Added to exclude licenses with status F]
             AND lic_status != 'F'               --Dev2:Non Costed Filler: End
                                  ;

      l_qry :=
         'SELECT
        REG_CODE   Region
      , count(sch_number) showings
            ,    sch_per_year
            ,    sch_per_month
            ,    cha_short_name
            ,    cha_number
            ,    to_char(sch_date, ''FMMonth YYYY'')
            ,    cod_value
            ,    substr(cod_description,1,20)  LIC_BUDGET
            ,    lic_number
            ,    gen_duration
            ,    round(gen_duration * (count(sch_number) /90000)  , 2) lic_hours
--            ,    round( (PKG_FIN_MNET_MON_FIN_REP.fun_air_tim_used_per_shwng('''
         || i_channel
         || ''' , to_date('''
         || i_from_date
         || '''), to_date('''
         || i_to_date
         || ''') )
--                /  count(sch_number) ) * 100  ,2)  PERCENTAGE
                        ,       '''
         || l_per_showing_is
         || '''  PERCENTAGE
            FROM    fid_schedule
            ,    fid_channel
            ,    fid_code
            ,    fid_license
            ,    fid_general
      ,fid_licensee
      ,fid_region

            WHERE    cha_short_name like '''
         || i_channel
         || '''
            and    sch_cha_number = cha_number
            and    sch_per_year||lpad(sch_per_month,2,0) >= TO_NUMBER(TO_CHAR(to_date('''
         || i_from_date
         || '''),''YYYYMM''))
                        and     sch_per_year||lpad(sch_per_month,2,0) <=TO_NUMBER(TO_CHAR(to_date('''
         || i_to_date
         || '''),''YYYYMM''))
            and    cod_value like '''
         || i_budget_type
         || '''
            and    cod_value != ''HEADER''
            and    cod_type = ''LIC_BUDGET_CODE''
            and    cod_value = lic_budget_code
            and    gen_refno = lic_gen_refno
            and    gen_duration != 0
            and    sch_lic_number = lic_number
      AND LEE_NUMBER=LIC_LEE_NUMBER
      AND REG_ID(+) = LEE_SPLIT_REGION
      AND   NVL(reg_code,''#'') like DECODE ('''
         || i_region
         || ''',''%'',NVL(reg_code,''#''),'''
         || i_region
         || ''')
      --Dev2: Non Costed Filler : Start:[NCF_Fin1]_[Manish]_[2013/03/15]
      --[Added to exclude licenses with status F]
      AND   lic_status!=''F''
      --Dev2:Non Costed Filler: End


            GROUP BY
         REG_CODE,
         substr(cod_description,1,20),
                 sch_per_year,
                 sch_per_month,
                 cha_short_name,
                 cha_number,
                 to_char(sch_date, ''FMMonth YYYY''),
                 cod_value,
                 lic_number,
                 gen_duration
            ORDER BY sch_per_year,
                 sch_per_month,
                 cha_short_name,
                 cod_value,
                 substr(cod_description,1,20)';
      DBMS_OUTPUT.put_line (l_qry);

      OPEN o_fin_report FOR l_qry;
   END prc_air_tim_usd_per_chan;

   PROCEDURE prc_cost_of_sales_per_chan (
      i_from_date         IN     DATE                            --01-JAN-2009
                                     ,
      i_to_date           IN     DATE                            --01-JAN-2009
                                     ,
      i_chnl_comp_name    IN     fid_company.com_short_name%TYPE        --MNET
                                                                ,
      i_lic_type          IN     fid_license.lic_type%TYPE               --FLF
                                                          ,
      i_lee_short_name    IN     fid_licensee.lee_short_name%TYPE        --AFR
                                                                 ,
      i_lic_budget_code   IN     fid_license.lic_budget_code%TYPE        --FIL
                                                                 --Dev2:Pure Finance:Start:[Hari Mandal]_[20/4/2013]
      ,
      i_region            IN     fid_region.reg_code%TYPE --Dev2:Pure Finance:End-------
                                       --,    i_acct_prvlng_rate    in    char
      ,
      o_fin_report           OUT pkg_fin_mnet_mon_fin_rep.c_fin_rep)
   AS
      l_qry   VARCHAR2 (1500);
   BEGIN
      OPEN o_fin_report FOR
         SELECT reg_code,
                com_number,
                lic_currency,
                lic_type,
                lee_short_name,
                lic_budget_code,
                supplier,
                con_short_name,
                lic_number,
                gentitle,
                acct_date,
                lic_start,
                lic_end,
                lic_amort_code,
                lic_showing_lic,
                lic_markup_percent,
                showsrem,
                ter_cur_code,
                chnl_comp,
                ROUND (DECODE (exh, 0, 0, ( (curr3_cost1 * exh) / tot_exh)),
                       4)
                   curr3_cost,
                curr4_markup,
                ex_rate,
                ROUND (
                   DECODE (exh, 0, 0, ( (currency2_cost1 * exh) / tot_exh)),
                   4)
                   currency2_cost,
                exchange_markup1,
                exh,
                cha_short_name,
                cha_name,
                nvl(AmoExhUsed,0) "Amo Exh Used"--Finace Dev 1[Ankur Kasar]
           FROM (  SELECT a.com_number,
                          (SELECT reg_code
                             FROM fid_region
                            WHERE reg_id = lee_split_region)
                             reg_code,
                          lic_currency,
                          lic_type,
                          lee_short_name,
                          lic_budget_code,
                          SUBSTR (a.com_short_name, 1, 8) supplier,
                          con_short_name,
                          lic_number,
                          SUBSTR (gen_title, 1, 22) gentitle,
                          TO_CHAR (lic_acct_date, 'YYYY.MM') acct_date,
                          lic_start,
                          lic_end,
                          lic_amort_code,
                          lic_showing_lic,
                          lic_markup_percent,
                          NVL (
                             LTRIM (
                                TO_CHAR (lic_showing_int - lic_showing_paid,
                                         '999')),
                             0)
                          || '/'
                          || NVL (LTRIM (lic_showing_int, '999'), 0)
                             showsrem,
                          --  b.com_number,
                          x.ter_cur_code,
                          x.com_name chnl_comp,
                          pkg_fin_mnet_mon_fin_rep.sumcol1 (
                             lic_number,
                             lsl_number,
                             TO_DATE (i_from_date),
                             TO_DATE (i_to_date))
                             curr3_cost1,
                          ROUND (pkg_fin_mnet_mon_fin_rep.sumcol1 (
                                    lic_number,
                                    lsl_number,
                                    TO_DATE (i_from_date),
                                    TO_DATE (i_to_date))
                                 * (lic_markup_percent / 100),
                                 0)
                             curr4_markup,
                          pkg_fin_mnet_mon_fin_rep.fun_inv_mmt_report_ex_rate (
                             lic_currency,
                             x.ter_cur_code,
                             '%',
                             lic_rate,
                             lic_start)
                             ex_rate,
                          pkg_fin_mnet_mon_fin_rep.sumcol1 (
                             lic_number,
                             lsl_number,
                             TO_DATE (i_from_date),
                             TO_DATE (i_to_date))
                          * pkg_fin_mnet_mon_fin_rep.fun_inv_mmt_report_ex_rate (
                               lic_currency,
                               x.ter_cur_code,
                               '%',
                               lic_rate,
                               lic_start)
                             currency2_cost1,
                          ROUND (pkg_fin_mnet_mon_fin_rep.sumcol1 (
                                    lic_number,
                                    lsl_number,
                                    TO_DATE (i_from_date),
                                    TO_DATE (i_to_date))
                                 * (lic_markup_percent / 100),
                                 0)
                          * pkg_fin_mnet_mon_fin_rep.fun_inv_mmt_report_ex_rate (
                               lic_currency,
                               x.ter_cur_code,
                               '%',
                               lic_rate,
                               lic_start)
                             exchange_markup1 ----,    PKG_FIN_MNET_MON_FIN_REP.fun_cost_sale_sch_paid_1(to_date(i_from_date ),to_date(i_to_date ),lic_number)    EXH
                                             ,
                          (SELECT COUNT (0)
                             FROM fid_schedule, fid_channel
                            WHERE sch_cha_number = cha_number
                                  AND sch_lic_number = lic_number
                                  -- Neeraj Basliyal : Please log this with Synergy .Costed runs channels are missing on the Cost of Sales report. I see there are channels missing.
                                  AND sch_per_year
                                      || LPAD (sch_per_month, 2, 0) BETWEEN TO_NUMBER (
                                                                               TO_CHAR (
                                                                                  TO_DATE (
                                                                                     i_from_date),
                                                                                  'YYYYMM'))
                                                                        AND TO_NUMBER (
                                                                               TO_CHAR (
                                                                                  TO_DATE (
                                                                                     i_to_date),
                                                                                  'YYYYMM')) --'''||i_period||'''
                                  --'''||i_period||'''
                                  AND sch_type = 'P'
                                  AND y.cha_name = cha_name)
                             exh,
                          (SELECT COUNT (0)
                             FROM fid_schedule, fid_channel
                            WHERE sch_cha_number = cha_number
                                  AND sch_lic_number = lic_number
                                  -- Neeraj Basliyal : Please log this with Synergy .Costed runs channels are missing on the Cost of Sales report. I see there are channels missing.
                                  AND sch_per_year
                                      || LPAD (sch_per_month, 2, 0) BETWEEN TO_NUMBER (
                                                                               TO_CHAR (
                                                                                  TO_DATE (
                                                                                     i_from_date),
                                                                                  'YYYYMM'))
                                                                        AND TO_NUMBER (
                                                                               TO_CHAR (
                                                                                  TO_DATE (
                                                                                     i_to_date),
                                                                                  'YYYYMM')) --'''||i_period||'''
                                  AND sch_type = 'P')
                             tot_exh,
                          y.cha_short_name,
                          y.cha_name,
                          PKG_FIN_MNET_MON_FIN_REP.X_Fun_Amo_Exh_Used(fid_license.lic_number,i_from_date,i_to_date) AmoExhUsed--Finace Dev 1[Ankur Kasar]
                     FROM fid_company a,
                          fid_general,
                          --   fid_company b,
                          fid_contract,
                          fid_licensee,
                          fid_license,
                          (SELECT ter_cur_code,
                                  a.com_short_name,
                                  a.com_ter_code,
                                  a.com_name,
                                  a.com_number
                             FROM fid_company a, fid_territory
                            WHERE     a.com_short_name LIKE i_chnl_comp_name
                                  AND a.com_type IN ('CC', 'BC')
                                  AND ter_code = com_ter_code) x,
                          (SELECT DISTINCT
                                  fs.sch_cha_number,
                                  fs.sch_lic_number,
                                  NVL (fc.cha_short_name, 'None')
                                     cha_short_name,
                                  NVL (fc.cha_name, 'None') cha_name
                             FROM fid_schedule fs, fid_channel fc
                            WHERE fs.sch_cha_number = cha_number
                                  -- Neeraj Basliyal : Please log this with Synergy .Costed runs channels are missing on the Cost of Sales report. I see there are channels missing.
                                  AND fs.sch_per_year
                                      || LPAD (fs.sch_per_month, 2, 0) BETWEEN TO_NUMBER (
                                                                                  TO_CHAR (
                                                                                     TO_DATE (
                                                                                        i_from_date),
                                                                                     'RRRRMM'))
                                                                           AND TO_NUMBER (
                                                                                  TO_CHAR (
                                                                                     TO_DATE (
                                                                                        i_to_date),
                                                                                     'RRRRMM')) 
                                                                                               ) y,
                          --Dev2:Pure Finance:Start:[Hari Mandal]_[20/4/2013]
                          x_fin_lic_sec_lee
                    --Dev2:Pure Finance:End-------
                    WHERE (    lee_cha_com_number = x.com_number
                           --:com_number2
                           AND lic_type LIKE i_lic_type         --License type
                           AND lee_short_name LIKE i_lee_short_name --licensee
                           AND lic_budget_code LIKE i_lic_budget_code
                           -- budget_code
                           -- AND lic_lee_number  = lee_number
                           AND con_number = lic_con_number
                           AND a.com_number = con_com_number
                           AND gen_refno = lic_gen_refno
                           AND lic_number = y.sch_lic_number
                           --Dev2:Pure Finance:Start:[Hari Mandal]_[20/4/2013]
                           AND lic_number = lsl_lic_number
                           AND lee_number = lsl_lee_number
                           AND lee_split_region IN
                                  (SELECT reg_id
                                     FROM fid_region
                                    WHERE UPPER (reg_code) LIKE
                                             UPPER (i_region))
                           AND lic_status <> 'F'
                           --Dev2:Pure Finance:End-------
                           --Dev.R3: Start: Placeholder_[Devashish Raverkar]_[27-03-2014]
                           AND lic_status <> 'T'
                           --Dev.R3: End:
                           AND NVL (lic_catchup_flag, 'N') = 'N'
                           AND 0 <>
                                  (SELECT SUM (lis_con_aa_emu)
                                     FROM fid_lis_vw
                                    WHERE lis_lic_number = lic_number
                                          AND lis_per_year
                                              || LPAD (lis_per_month, 2, 0) >=
                                                 TO_NUMBER (
                                                    TO_CHAR (
                                                       TO_DATE (i_from_date),
                                                       'YYYYMM'))
                                          AND lis_per_year
                                              || LPAD (lis_per_month, 2, 0) <=
                                                 TO_NUMBER (
                                                    TO_CHAR (
                                                       TO_DATE (i_to_date),
                                                       'YYYYMM'))))
                 -- AND ROWNUM < 50
                 --     AND (x.com_number = a.com_number) ----:com_number2
                 ORDER BY 1 ASC,
                          2 ASC,
                          3 ASC,
                          4 ASC,
                          5 ASC,
                          6 ASC,
                          lic_currency,
                          lic_type,
                          lee_short_name,
                          lic_budget_code,
                          x.com_short_name,
                          con_short_name,
                          gen_title)
         UNION         ----- Added union for displaying catchup PB CR mrunmayi
         SELECT reg_code,
                com_number,
                lic_currency,
                lic_type,
                lee_short_name,
                lic_budget_code,
                supplier,
                con_short_name,
                lic_number,
                gentitle,
                acct_date,
                lic_start,
                lic_end,
                lic_amort_code,
                lic_showing_lic,
                lic_markup_percent,
                showsrem,
                ter_cur_code,
                chnl_comp,
                ROUND (DECODE (exh, 0, 0, ( (curr3_cost1 * exh) / tot_exh)),
                       4)
                   curr3_cost,
                curr4_markup,
                ex_rate,
                ROUND (
                   DECODE (exh, 0, 0, ( (currency2_cost1 * exh) / tot_exh)),
                   4)
                   currency2_cost,
                EXCHANGE_MARKUP1,
                NULL EXH,
                CHA_SHORT_NAME,
                CHA_NAME,
                nvl(AmoExhUsed,0) "Amo Exh Used"--Finace Dev 1[Ankur Kasar]
           FROM (  SELECT A.COM_NUMBER,
                          REG1.REG_CODE,
                          lic_currency,
                          lic_type,
                          lee1.lee_short_name,
                          lic_budget_code,
                          SUBSTR (a.com_short_name, 1, 8) supplier,
                          con_short_name,
                          lic_number,
                          SUBSTR (gen_title, 1, 22) gentitle,
                          TO_CHAR (lic_acct_date, 'YYYY.MM') acct_date,
                          lic_start,
                          lic_end,
                          lic_amort_code,
                          lic_showing_lic,
                          lic_markup_percent,
                          NULL showsrem,
                          --  b.com_number,
                          x.ter_cur_code,
                          x.com_name chnl_comp,
                          pkg_fin_mnet_mon_fin_rep.sumcol1 (
                             lic_number,
                             lsl_number,
                             TO_DATE (i_from_date),
                             TO_DATE (i_to_date))
                             curr3_cost1,
                          ROUND (pkg_fin_mnet_mon_fin_rep.sumcol1 (
                                    lic_number,
                                    lsl_number,
                                    TO_DATE (i_from_date),
                                    TO_DATE (i_to_date))
                                 * (lic_markup_percent / 100),
                                 0)
                             curr4_markup,
                          pkg_fin_mnet_mon_fin_rep.fun_inv_mmt_report_ex_rate (
                             lic_currency,
                             x.ter_cur_code,
                             '%',
                             lic_rate,
                             lic_start)
                             ex_rate,
                          pkg_fin_mnet_mon_fin_rep.sumcol1 (
                             lic_number,
                             lsl_number,
                             TO_DATE (i_from_date),
                             TO_DATE (i_to_date))
                          * pkg_fin_mnet_mon_fin_rep.fun_inv_mmt_report_ex_rate (
                               lic_currency,
                               x.ter_cur_code,
                               '%',
                               lic_rate,
                               lic_start)
                             currency2_cost1,
                          ROUND (pkg_fin_mnet_mon_fin_rep.sumcol1 (
                                    lic_number,
                                    lsl_number,
                                    TO_DATE (i_from_date),
                                    TO_DATE (i_to_date))
                                 * (lic_markup_percent / 100),
                                 0)
                          * pkg_fin_mnet_mon_fin_rep.fun_inv_mmt_report_ex_rate (
                               lic_currency,
                               x.ter_cur_code,
                               '%',
                               lic_rate,
                               lic_start)
                             exchange_markup1,
                          ----,    PKG_FIN_MNET_MON_FIN_REP.fun_cost_sale_sch_paid_1(to_date(i_from_date ),to_date(i_to_date ),lic_number)    EXH
                          (SELECT COUNT (0)
                             FROM x_cp_play_list
                            WHERE     plt_lic_number = lic_number
                                  AND plt_sch_start_date >= i_from_date
                                  AND plt_sch_end_date <= i_to_date
                                  AND plt_sch_type = 'P'
                                  AND y.plt_plat_code = plt_plat_code)
                             exh,
                          (SELECT COUNT (0)
                             FROM x_cp_play_list
                            WHERE     plt_lic_number = lic_number
                                  AND plt_sch_start_date >= i_from_date
                                  AND plt_sch_end_date <= i_to_date
                                  AND PLT_SCH_TYPE = 'P')
                             TOT_EXH,
                          reg2.reg_code cha_short_name,
                          NULL cha_name,
                        PKG_FIN_MNET_MON_FIN_REP.X_Fun_Amo_Exh_Used(fid_license.lic_number,i_from_date,i_to_date) AmoExhUsed--Finace Dev 1[Ankur Kasar]
                     FROM fid_company a,
                          FID_GENERAL,
                          FID_CONTRACT,
                          fid_licensee lee1,
                          fid_license,
                          (SELECT ter_cur_code,
                                  a.com_short_name,
                                  a.com_ter_code,
                                  a.com_name,
                                  a.com_number
                             FROM fid_company a, fid_territory
                            WHERE     a.com_short_name LIKE i_chnl_comp_name
                                  AND a.com_type IN ('CC', 'BC')
                                  AND ter_code = com_ter_code) x,
                          (SELECT DISTINCT
                                  plt_reg_code, plt_lic_number, plt_plat_code
                             FROM x_cp_play_list
                            WHERE plt_sch_start_date >= i_from_date
                                  AND PLT_SCH_END_DATE <= I_TO_DATE) Y,
                          X_FIN_LIC_SEC_LEE,
                          FID_REGION REG1,
                          FID_REGION REG2,
                          fid_licensee lee2
                    --Dev2:Pure Finance:End-------
                    WHERE     lee1.lee_cha_com_number = x.com_number
                          --:com_number2
                          AND LIC_TYPE LIKE I_LIC_TYPE          --License type
                          AND lee1.lee_short_name LIKE i_lee_short_name --licensee
                          AND lic_budget_code LIKE i_lic_budget_code
                          -- budget_code
                          -- AND lic_lee_number  = lee_number
                          AND con_number = lic_con_number
                          AND a.com_number = con_com_number
                          AND gen_refno = lic_gen_refno
                          AND lic_number = y.plt_lic_number
                          --Dev2:Pure Finance:Start:[Hari Mandal]_[20/4/2013]
                          AND LIC_NUMBER = LSL_LIC_NUMBER
                          AND lee1.lee_number = lsl_lee_number
                          AND NVL (LIC_CATCHUP_FLAG, 'N') = 'Y'
                          AND LEE1.LEE_SPLIT_REGION = REG1.REG_ID
                          AND UPPER (REG1.REG_CODE) LIKE UPPER ('%')
                          AND LIC_STATUS <> 'F'
                          AND LIC_LEE_NUMBER = LEE2.LEE_NUMBER
                          AND lee2.LEE_REGION_ID = reg2.REG_id
                          --Dev2:Pure Finance:End-------
                          AND 0 <>
                                 (SELECT SUM (lis_con_aa_emu)
                                    FROM fid_lis_vw
                                   WHERE lis_lic_number = lic_number
                                         AND lis_per_year
                                             || LPAD (lis_per_month, 2, 0) >=
                                                TO_NUMBER (
                                                   TO_CHAR (
                                                      TO_DATE (i_from_date),
                                                      'YYYYMM'))
                                         AND lis_per_year
                                             || LPAD (lis_per_month, 2, 0) <=
                                                TO_NUMBER (
                                                   TO_CHAR (
                                                      TO_DATE (i_to_date),
                                                      'YYYYMM')))
                 ORDER BY 1 ASC,
                          2 ASC,
                          3 ASC,
                          4 ASC,
                          5 ASC,
                          6 ASC,
                          lic_currency,
                          lic_type,
                          lee_short_name,
                          lic_budget_code,
                          x.com_short_name,
                          con_short_name,
                          gen_title);
   /* l_qry :='select *
       from     (select    fc.COM_NAME
           ,    fc.LIC_CURRENCY
           ,    fc.FROM_DATE
           ,    fc.TO_DATE
           ,    fc.TER_CUR_CODE
           ,    fc.LIC_TYPE
           ,    fc.LEE_SHORT_NAME
           ,    fc.LIC_BUDGET_CODE
           ,    fc.SUPPLIER
           ,    fc.CON_SHORT_NAME
           ,    fc.LIC_NUMBER
           ,    fc.GEN_TITLE
           ,    fc.ACCT_DATE
           ,    fc.LIC_START
           ,    fc.LIC_END
           ,    fc.LIC_AMORT_CODE
           ,    fc.EXH
           ,    fc.LIC_SHOWINGS_LIC
           ,    fc.SHOWS_REM
           ,    fc.COST
           ,    fc.MARKUP
           ,    fc.EXCHANGE_COST
           ,    fc.EXCHANGE_MARKUP
           from    fidcos01 fc
           ) a
       ,    (select    distinct fs.sch_cha_number
           ,    fs.sch_lic_number
           ,    nvl(fc.cha_short_name,''None'') CHA_SHORT_NAME
           ,    nvl(fc.cha_name,''None'') cha_name
           from    fid_schedule fs
           ,    fid_channel fc
           where    fs.sch_cha_number = cha_number
           and    fs.sch_per_year||lpad(fs.sch_per_month ,2,0) = '''||i_period||'''
           ) b
       where a.LIC_NUMBER     = b.sch_lic_number'
       ;
   dbms_output.put_line(l_qry);
   open o_fin_report for l_qry; */
   END prc_cost_of_sales_per_chan;

   PROCEDURE prc_com_addr_listing (
      i_company_type   IN     VARCHAR2,
      o_fin_report        OUT pkg_fin_mnet_mon_fin_rep.c_fin_rep)
   AS
      l_qry   VARCHAR2 (1500);
   BEGIN
      l_qry :=
         'select decode(fc.com_type,''BC'',''Buying'',''CC'',''Channel'',''S'',''Supplier'',com_type) com_type
        ,    fc.com_short_name
        ,    fc.com_name
        ,    nvl(fcd.cod_value,''-'') coe_type
        ,    nvl(fe.ent_short_name,''-'') ent_short_name
        ,    nvl(fe.ent_name,''-'') ent_name
        ,    nvl(fe.ent_address_1||'' ''||ent_address_2,''-'') ent_address
        ,    nvl(fe.ent_city,''-'') ent_city
        ,    nvl(fe.ent_region,''-'') ent_region
        ,    nvl(fe.ent_country,''-'') ent_country
        ,    nvl(fe.ent_postcode,''-'') ent_postcode
        From    fid_company fc
        ,    fid_company_enterprise fce
        ,    fid_enterprise  fe
        ,    fid_code fcd
        where    fc.com_type like '''
         || i_company_type
         || '''
        and    fce.coe_com_number = fc.com_number
        and    fce.coe_ent_number = fe.ent_number
        and    fce.coe_type = fcd.cod_value
        and    fcd.cod_type = ''COE_TYPE''
        order by 1,2';
      DBMS_OUTPUT.put_line (l_qry);

      OPEN o_fin_report FOR l_qry;
   END prc_com_addr_listing;

   PROCEDURE prc_write_off_rpt (
      i_region            IN     VARCHAR2,
      i_frst_shld_date    IN     DATE,
      i_last_shld_date    IN     DATE,
      i_subledger_year    IN     NUMBER,
      i_subledger_month   IN     NUMBER,
      o_fin_report           OUT pkg_fin_mnet_mon_fin_rep.c_fin_rep)
   AS
      l_qry   VARCHAR2 (5000);
   BEGIN
      l_qry :=
            'SELECT
        REG_CODE   Region
      , FID_LICENSE_VW.LIC_NUMBER
            ,    FID_CHANNEL.CHA_SHORT_NAME
            ,    FID_LICENSE_VW.LEE_SHORT_NAME
            ,    FID_LICENSE_VW.CON_SHORT_NAME
            ,    FID_LICENSE_VW.GEN_TITLE
            ,    FID_LICENSE_VW.LIC_CURRENCY
            ,    FID_LICENSE_VW.LIC_START
            ,    FID_LICENSE_VW.LIC_END
            ,    FID_LICENSE_VW.LIC_PRICE
            ,    FID_SCHEDULE.SCH_DATE
            ,    FID_LICENSE_SUB_LEDGER.LIS_PER_YEAR
            ,    FID_LICENSE_SUB_LEDGER.LIS_PER_MONTH
            ,    FID_LICENSE_SUB_LEDGER.LIS_CON_ACTUAL
            ,    FID_LICENSE_VW.LIC_MARKUP_PERCENT
            ,    FID_LICENSE_VW.LIC_BUDGET_CODE
            FROM     FID_LICENSE_VW
            ,    FID_SCHEDULE
            ,    FID_LICENSE_SUB_LEDGER
            ,    FID_CHANNEL
                  ,       fid_licensee b
                  ,       fid_region

            WHERE (FID_CHANNEL.CHA_SHORT_NAME = ''Z''
             AND FID_SCHEDULE.SCH_DATE BETWEEN '''
         || i_frst_shld_date
         || ''' AND '''
         || i_last_shld_date
         || '''
             AND FID_LICENSE_SUB_LEDGER.LIS_PER_YEAR||LPAD(FID_LICENSE_SUB_LEDGER.LIS_PER_MONTH,2,0) = '
         || i_subledger_year
         || ' ||LPAD('
         || i_subledger_month
         || ',2,0)
             AND FID_LICENSE_SUB_LEDGER.LIS_CON_ACTUAL<>0)
             AND ((FID_LICENSE_VW.LIC_NUMBER = FID_SCHEDULE.SCH_LIC_NUMBER)
             AND (FID_LICENSE_VW.LIC_NUMBER = FID_LICENSE_SUB_LEDGER.LIS_LIC_NUMBER)
             AND (FID_CHANNEL.CHA_NUMBER = FID_SCHEDULE.SCH_CHA_NUMBER))
             AND FID_SCHEDULE.SCH_NUMBER NOT IN (select sch_number from fid_schedule
                                 where sch_lic_number = FID_LICENSE_VW.LIC_NUMBER
                                 and SCH_DATE BETWEEN  to_date('''
         || to_char(i_frst_shld_date,'dd-mm-yyyy')
         || ''',''dd-mm-yyyy'') AND to_date('''
         || to_char(i_last_shld_date,'dd-mm-yyyy')
         || ''',''dd-mm-yyyy'')
                                 and sch_cha_number = 0
                                 and rowid > (select min(rowid) from fid_schedule
                                 where sch_lic_number = FID_LICENSE_VW.LIC_NUMBER and SCH_DATE BETWEEN to_date('''
         || to_char(i_frst_shld_date,'dd-mm-yyyy')
         || ''',''dd-mm-yyyy'')
                                 AND to_date( '''
         || to_char(i_last_shld_date,'dd-mm-yyyy')
         || ''',''dd-mm-yyyy'') and sch_cha_number = 0))
      and   b.LEE_NUMBER=LIC_lee_NUMBER
      AND   REG_ID(+) = b.LEE_SPLIT_REGION
      AND   NVL(reg_code,''#'') like DECODE ('''
         || i_region
         || ''',''%'',NVL(reg_code,''#''),'''
         || i_region
         || ''')
      --Dev2: Non Costed Filler : Start:[NCF_Fin1]_[Manish]_[2013/03/15]
      --[Added to exclude licenses with status F]
      AND   lic_status!=''F''
      --Dev2:Non Costed Filler: End
      --Dev.R3: Start: Placeholder_[Devashish Raverkar]_[27-03-2014]
      AND lic_status <> ''T''
      --Dev.R3: End:


            ORDER BY FID_LICENSE_VW.LIC_NUMBER ASC';
      DBMS_OUTPUT.put_line (l_qry);

      OPEN o_fin_report FOR l_qry;
   END prc_write_off_rpt;

   FUNCTION sumcol1 (i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
                     i_lsl_number    x_fin_lic_sec_lee.lsl_number%TYPE,
                     i_from_date     DATE,
                     i_to_date       DATE)
      RETURN NUMBER
   AS
      l_sumcol1   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (lis_con_aa_emu)
           INTO l_sumcol1
           FROM fid_lis_vw
          WHERE lis_per_year || LPAD (lis_per_month, 2, 0) >=
                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
                AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                       TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
                AND lis_lic_number = i_lic_number
                AND lis_lsl_number = i_lsl_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_sumcol1 := 0;
      END;

      IF l_sumcol1 IS NULL
      THEN
         l_sumcol1 := 0;
      END IF;

      RETURN l_sumcol1;
   END;

   FUNCTION fun_inv_mmt_report_ex_rate (
      i_lic_currency        fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code        fid_exchange_rate.rat_cur_code_2%TYPE,
      i_acct_prvlng_rate    CHAR,
      i_lic_rate            fid_license.lic_rate%TYPE,
      i_lic_start           fid_license.lic_start%TYPE)
      RETURN NUMBER
   AS
      l_ex_rate      NUMBER;
      go_live_date   VARCHAR2 (20);

      CURSOR get_prevailing_rate
      IS
         SELECT rat_rate
           FROM fid_exchange_rate
          WHERE rat_cur_code = i_lic_currency
                AND rat_cur_code_2 = i_ter_cur_code;
   BEGIN
      SELECT content
        INTO go_live_date
        FROM x_fin_configs
       WHERE UPPER (KEY) LIKE 'GO-LIVEDATE' AND ID = 1;

      IF i_acct_prvlng_rate = 'P'
      THEN
         OPEN get_prevailing_rate;

         FETCH get_prevailing_rate INTO l_ex_rate;

         IF get_prevailing_rate%NOTFOUND
         THEN
            l_ex_rate := 1;
         END IF;
      ELSE
         IF i_lic_start >= TO_DATE (go_live_date, 'DD-MON-YYYY')
         THEN
            l_ex_rate := i_lic_rate;
         ELSE
            OPEN get_prevailing_rate;

            FETCH get_prevailing_rate INTO l_ex_rate;
         END IF;
      END IF;

      RETURN l_ex_rate;
   END;

   FUNCTION fun_cost_sale_sch_paid_1 (
      i_from_date     DATE,
      i_to_date       DATE,
      i_lic_number    fid_sch_summary_vw.sch_lic_number%TYPE)
      RETURN NUMBER
   AS
      l_sch_paid_1   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (sch_paid)
           INTO l_sch_paid_1
           FROM fid_sch_summary_vw
          WHERE sch_year || LPAD (sch_month, 2, 0) >=
                   TO_NUMBER (TO_CHAR (TO_DATE (i_from_date), 'YYYYMM'))
                AND sch_year || LPAD (sch_month, 2, 0) <=
                       TO_NUMBER (TO_CHAR (TO_DATE (i_to_date), 'YYYYMM'))
                AND sch_lic_number = i_lic_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_sch_paid_1 := 0;
      END;

      IF l_sch_paid_1 IS NULL
      THEN
         l_sch_paid_1 := 0;
      END IF;

      RETURN l_sch_paid_1;
   END;
/*
Finace dev phase I [Ankur Kasar][start]
*/
   FUNCTION X_Fun_Amo_Exh_Used (
        l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
       -- I_CHA_NUMBER       number,
        i_from_period_date date,
        i_to_period_date   date
     )
        RETURN NUMBER
     AS
        l_td_exh      NUMBER;
        L_START_DATE  DATE;
        v_go_live_date DATE;
     BEGIN
  
     SELECT LIC_START  
       INTO L_START_DATE 
       FROM FID_LICENSE
      WHERE LIC_NUMBER = l_sch_lic_number;
      
      SELECT TO_DATE (xfc.content)
        INTO v_go_live_date
        FROM x_fin_configs xfc
       WHERE KEY = 'GO-LIVEDATE';
     
           IF ((L_START_DATE < v_go_live_date))
           THEN
              SELECT NVL (SUM (DECODE (fl.lic_catchup_flag,
                                       'Y', NULL,
                                       fsv.sch_paid
                                      )
                              ),
                          0
                         )
                INTO l_td_exh
                FROM fid_sch_summary_vw fsv, fid_license fl
               WHERE fsv.sch_year || LPAD (fsv.sch_month, 2, 0)
             BETWEEN TO_CHAR (i_from_period_date, 'YYYYMM')
                 AND TO_CHAR (i_to_period_date, 'YYYYMM')
                 AND fsv.sch_lic_number = lic_number
                 AND fsv.sch_lic_number = l_sch_lic_number;
           ELSE
               SELECT COUNT (xfcs.csh_lic_number)
                INTO l_td_exh
                FROM x_fin_cost_schedules xfcs
               WHERE xfcs.csh_lic_number = l_sch_lic_number             
                 AND xfcs.CSH_YEAR||LPAD(xfcs.CSH_MONTH, 2, 0) <= TO_CHAR (i_from_period_date, 'YYYYMM');
           END IF;
  
           RETURN l_td_exh;                               
     END X_Fun_Amo_Exh_Used; 
/*
Finace dev phase I [Ankur Kasar][End]
*/
END pkg_fin_mnet_mon_fin_rep;
/