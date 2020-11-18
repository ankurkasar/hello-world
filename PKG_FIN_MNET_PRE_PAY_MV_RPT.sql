CREATE OR REPLACE PACKAGE          PKG_FIN_MNET_PRE_PAY_MV_RPT
AS
   TYPE fin_pre_pay_mv_cursor IS REF CURSOR;

   /**************************************************************************
   REM Module          : Finance - Pre-Payments Movement Report
   REM Client          : MNET/ SUPER SPORT
   REM File Name       : PKG_FIN_MNET_PRE_PAY_MV_RPT
   REM Purpose         : Generate reports for different currency
   REM Written By      : Rajan Kumar
   REM Date            : 18-02-2010
   REM Type            : Database Package
   REM Change History  : Created
   REM **************************************************************************/

   PROCEDURE prc_fin_pre_pay_mv_reports(
      ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
      i_region            IN       fid_region.reg_code%TYPE,
      ----Dev2: Pure Finance:END----------------------------
      i_channel_company   IN       fid_company.com_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_budget_code       IN       fid_license.lic_budget_code%TYPE,
      i_license_in_out    IN       VARCHAR2,
      ----------Pure Finance: Start:[FIN36]_Hari_2013/03/06]
      i_from_period       IN       VARCHAR2,
      i_to_period         IN       VARCHAR2,
      ----Dev2: Pure Finance:END----------------------------
      o_pre_payment       OUT      pkg_fin_mnet_pre_pay_mv_rpt.fin_pre_pay_mv_cursor
   );
  
   PROCEDURE prc_fin_pre_pay_mv_rep_bfr_go (
      ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
      i_region            IN       fid_region.reg_code%TYPE,
      ----Dev2: Pure Finance:END----------------------------
      i_channel_company   IN       fid_company.com_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_budget_code       IN       fid_license.lic_budget_code%TYPE,
      i_license_in_out    IN       VARCHAR2,
      ----------Pure Finance: Start:[FIN36]_Hari_2013/03/06]
      i_from_period       IN       VARCHAR2,
      i_to_period         IN       VARCHAR2,
      ----Dev2: Pure Finance:END----------------------------
      o_pre_payment       OUT      pkg_fin_mnet_pre_pay_mv_rpt.fin_pre_pay_mv_cursor
   );
  
   PROCEDURE prc_fin_pre_pay_mv_rep_aft_go (
      ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
      i_region            IN       fid_region.reg_code%TYPE,
      ----Dev2: Pure Finance:END----------------------------
      i_channel_company   IN       fid_company.com_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_budget_code       IN       fid_license.lic_budget_code%TYPE,
      i_license_in_out    IN       VARCHAR2,
      ----------Pure Finance: Start:[FIN36]_Hari_2013/03/06]
      i_from_period       IN       VARCHAR2,
      i_to_period         IN       VARCHAR2,
      ----Dev2: Pure Finance:END----------------------------
      o_pre_payment       OUT      pkg_fin_mnet_pre_pay_mv_rpt.fin_pre_pay_mv_cursor
   );
  
   FUNCTION paid_amount (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_period         IN   VARCHAR2,
      i_lsl_number     IN   x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER;

   FUNCTION paid_amount_local (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_period         IN   VARCHAR2,
      i_lsl_number     IN   x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER;

   FUNCTION paid_amount_golive (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_period         IN   VARCHAR2,
      i_lsl_number     IN   x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER;

   FUNCTION exchange_rate (
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_ter_cur_code   IN   fid_territory.ter_cur_code%TYPE
   )
      RETURN NUMBER;

   FUNCTION where_clause (i_license_in_out IN VARCHAR2, i_period IN DATE)
      RETURN VARCHAR2;

   FUNCTION month_end_rate (
      i_month    IN   NUMBER,
      i_year     IN   NUMBER,
      i_lic_no   IN   fid_license.lic_number%TYPE
   )
      RETURN DATE;

   FUNCTION month_end_rate_regionwise (
      i_month         IN   NUMBER,
      i_year          IN   NUMBER,
      i_region_code   IN   fid_region.reg_code%TYPE
   )
      RETURN DATE;

   FUNCTION license_region (i_lic_no IN fid_license.lic_number%TYPE)
      RETURN VARCHAR2;
END PKG_FIN_MNET_PRE_PAY_MV_RPT;
/
create or replace PACKAGE BODY          "PKG_FIN_MNET_PRE_PAY_MV_RPT"
AS   
   PROCEDURE prc_fin_pre_pay_mv_reports (
      ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
      i_region            IN       fid_region.reg_code%TYPE,
      ----Dev2: Pure Finance:END----------------------------
      i_channel_company   IN       fid_company.com_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_budget_code       IN       fid_license.lic_budget_code%TYPE,
      i_license_in_out    IN       VARCHAR2,
      ----------Pure Finance: Start:[FIN36]_Hari_2013/03/06]
      i_from_period       IN       VARCHAR2,
      i_to_period         IN       VARCHAR2,
      ----Dev2: Pure Finance:END----------------------------
      o_pre_payment       OUT      pkg_fin_mnet_pre_pay_mv_rpt.fin_pre_pay_mv_cursor
   )
   AS
      l_period          DATE;
      v_go_live_date    DATE;
   BEGIN
   

       SELECT TO_DATE (i_from_period, 'MM/DD/YYYY')
        INTO l_period
        FROM DUAL;
        
      SELECT TO_DATE (xfc.content)
        INTO v_go_live_date
        FROM x_fin_configs xfc
       WHERE KEY = 'FIN_I_LIVE_DATE';
      
    
    IF l_period < v_go_live_date
    THEN
    
    PKG_FIN_MNET_PRE_PAY_MV_RPT.prc_fin_pre_pay_mv_rep_bfr_go
    (
      i_region,           
      i_channel_company,
      i_lic_type,          
      i_licensee,          
      i_budget_code,       
      i_license_in_out,    
      i_from_period,       
      i_to_period,         
      o_pre_payment      
    );
    ELSE

    PKG_FIN_MNET_PRE_PAY_MV_RPT.prc_fin_pre_pay_mv_rep_aft_go
    (
      i_region,           
      i_channel_company,
      i_lic_type,          
      i_licensee,          
      i_budget_code,       
      i_license_in_out,    
      i_from_period,       
      i_to_period,         
      o_pre_payment      
    );
    END IF;
    EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20000,SUBSTR(SQLERRM,1,200));
   END prc_fin_pre_pay_mv_reports;

--****************************************************************
-- This procedure is called for fetching data befor go live date
-- Finace Dev Phase 1[Existing Data]
-- Ankur Kasar
--****************************************************************
   PROCEDURE prc_fin_pre_pay_mv_rep_bfr_go (
      ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
      i_region            IN       fid_region.reg_code%TYPE,
      ----Dev2: Pure Finance:END----------------------------
      i_channel_company   IN       fid_company.com_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_budget_code       IN       fid_license.lic_budget_code%TYPE,
      i_license_in_out    IN       VARCHAR2,
      ----------Pure Finance: Start:[FIN36]_Hari_2013/03/06]
      i_from_period       IN       VARCHAR2,
      i_to_period         IN       VARCHAR2,
      ----Dev2: Pure Finance:END----------------------------
      o_pre_payment       OUT      pkg_fin_mnet_pre_pay_mv_rpt.fin_pre_pay_mv_cursor
   )
   AS
      -- temp_period      VARCHAR2 (20);
      temp_period       NUMBER;
      temp_period_end   NUMBER;
      t_compare_date    VARCHAR2 (20);
      final_date        DATE;
      l_period          VARCHAR2 (20);
      first_date        VARCHAR2 (20);
      l_month           NUMBER;
      l_year            NUMBER;
	  l_license_in_out  VARCHAR2 (20);
   BEGIN
        l_license_in_out := CASE 
		                    WHEN UPPER(i_license_in_out) = 'LIAB TO PPMT' 
		                    THEN 'IN' 
							WHEN UPPER(i_license_in_out) = 'PPMT TO LIAB' 
							THEN 'OUT' 
							ELSE 'BOTH' 
							END;
              
      /* TODO implementation required */
      --SELECT TO_DATE(i_period,'mon-yyyy') into t_compare_date FROM DUAL;
      --  SELECT TO_CHAR(TO_DATE(i_period,'DD/mm/YYYY'),'DD-MON-YYYY') into t_compare_date FROM DUAL ;
      --SELECT TO_CHAR(TO_DATE(i_period,'MON-YYYY'),'YYYYMM') INTO temp_period FROM DUAL;
      SELECT TO_NUMBER (TO_CHAR (TO_DATE (i_from_period, 'MM/DD/YYYY'),
                                 'RRRRMMDD'
                                )
                       )
        INTO temp_period
        FROM DUAL;

      SELECT TO_NUMBER (TO_CHAR (LAST_DAY(TO_DATE (i_to_period, 'MM/DD/YYYY')),
                                 'RRRRMMDD'
                                )
                       )
        INTO temp_period_end
        FROM DUAL;

      SELECT TO_CHAR (TO_DATE (i_from_period, 'MM/DD/YYYY'), 'DD-MON-YYYY')
        INTO l_period
        FROM DUAL;

----------Pure Finance: Start:[FIN6]_Hari_2013/03/06]
      SELECT TO_NUMBER (TO_CHAR (TO_DATE (i_from_period, 'MM/DD/YYYY'), 'MM'))
        INTO l_month
        FROM DUAL;

      SELECT TO_NUMBER (TO_CHAR (TO_DATE (i_from_period, 'MM/DD/YYYY'),
                                 'YYYY')
                       )
        INTO l_year
        FROM DUAL;

----Dev2: Pure Finance:END----------------------------
      SELECT ADD_MONTHS (LAST_DAY (l_period), -1) + 1
        INTO first_date
        FROM DUAL;

      DBMS_OUTPUT.put_line ('l_month -->' || l_month);
      DBMS_OUTPUT.put_line ('l_year-->' || l_year);
      DBMS_OUTPUT.put_line ('temp_period:' || temp_period);
      DBMS_OUTPUT.put_line ('temp_period_end:' || temp_period_end);

      IF (UPPER (l_license_in_out) = 'IN')
      THEN
         OPEN o_pre_payment FOR
            SELECT   *
                FROM (SELECT
                               ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
                               (SELECT DECODE (i_region,
                                               '%', 'Consolidated',
                                               i_region
                                              )
                                  FROM DUAL) reg_code,
                               license_region (lic_number) region_name,

                               ----Dev2: Pure Finance:END----------------------------
                               flee.lee_cha_com_number, fl.lic_currency,
                               fl.lic_type, flee.lee_short_name,
                               fl.lic_budget_code, fc.com_short_name,
                               x.com_name company_channel,
                               fcon.con_short_name, fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35) gen_title,
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct,
                               TO_CHAR (fl.lic_start, 'DDMonYYYY') start_date,
                               TO_CHAR (fl.lic_end, 'DDMonYYYY') end_date,
                               fcon.con_number, fc.com_number,
                               SUM
                                  (  flsl.lis_con_forecast
                                   * (100 + NVL (fl.lic_markup_percent, 0))
                                   / 100
                                  ) lis_con_fc_imu,
                               NVL (paid_amount (lic_number,
                                                 con_number,
                                                 lic_currency,
                                                 lic_acct_date,
                                                 lsl_number
                                                ),
                                    0
                                   ) paid,
                               DECODE
                                  (paid_amount (lic_number,
                                                con_number,
                                                lic_currency,
                                                lic_acct_date,
                                                lsl_number
                                               ),
                                   0, 0.00,
                                   NVL (paid_amount_local (lic_number,
                                                           con_number,
                                                           lic_currency,
                                                           lic_acct_date,
                                                           lsl_number
                                                          ),
                                        0.00
                                       )
                                  ) local_paid,

                               /*(CASE
                               WHEN paid_amount (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ) = 0
                               AND paid_amount_golive (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ) = 0
                               THEN DECODE
                               (lic_currency,
                               'USD', paid_amount_local
                               (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ),
                               0.00
                               )
                               ELSE 0.00
                               END
                               )*/
                               0.00 rel_forex_gl,
                               NVL
                                  ((  SUM (  lis_con_forecast
                                           * (100
                                              + NVL (lic_markup_percent, 0)
                                             )
                                           / 100
                                          )
                                    - paid_amount (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  )
                                   ),
                                   0
                                  ) liability,

                                 ----------Pure Finance: Start:[FIN6]_Hari_2013/03/06]
                                 (NVL ((  SUM (  lis_con_forecast
                                               * (  100
                                                  + NVL (lic_markup_percent,
                                                         0)
                                                 )
                                               / 100
                                              )
                                        - paid_amount (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       lic_acct_date,
                                                       lsl_number
                                                      )
                                       ),
                                       0
                                      )
                                 )
                               * x_pkg_fin_get_spot_rate.get_spot_rate
                                                   (lic_currency,
                                                    ter_cur_code,
                                                    month_end_rate (l_month,
                                                                    l_year,
                                                                    lic_number
                                                                   )
                                                   ) local_liability,
                               ROUND(x_pkg_fin_get_spot_rate.get_spot_rate
                                    (lic_currency,
                                     ter_cur_code,
                                     month_end_rate (l_month,
                                                     l_year,
                                                     lic_number
                                                    )
                                    ),5) exchange_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'AFR', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'RSA'
                                                                     )
                                          )
                                  ) ,5)rsa_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'RSA', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'AFR'
                                                                     )
                                          )
                                  ),5) afr_rate,

                               ----Dev2: Pure Finance:END----------------------------
                               x.ter_cur_code, 
                               fc.com_ter_code,
                               fl.lic_status --Finace DEV Phase 1 [Ankur Kasar]
                          FROM fid_license_sub_ledger flsl,
                               fid_general fg,
                               fid_company fc,
                               fid_contract fcon,
                               fid_license fl,
                               fid_licensee flee,
                               ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                               x_fin_lic_sec_lee xfsl,
                               fid_region fr,

                               ----Dev2: Pure Finance:END----------------------------
                               (SELECT   fc.com_number, fc.com_short_name,
                                         fc.com_name, fc.com_ter_code,
                                         ft.ter_cur_code
                                    FROM fid_company fc, fid_territory ft
                                   WHERE fc.com_short_name LIKE
                                                             i_channel_company
                                     AND fc.com_type IN ('CC', 'BC')
                                     AND ft.ter_code = fc.com_ter_code
                                ORDER BY fc.com_name) x
                         WHERE flee.lee_cha_com_number = x.com_number
                           ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                           AND xfsl.lsl_lic_number = fl.lic_number
                           AND xfsl.lsl_lee_number = flee.lee_number
                           AND flee.lee_split_region = fr.reg_id(+)
                           AND UPPER (fr.reg_code) LIKE UPPER (i_region)
                           ----Dev2: Pure Finance:END----------------------------
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_licensee
                           AND fl.lic_budget_code LIKE i_budget_code
                           AND fl.lic_acct_date IS NOT NULL
                           --AND (TO_CHAR (lic_acct_date, 'YYYYMM') = temp_period
                           -- )                            --to_char(:PARAM5,'YYYYMM'))
                           AND TO_NUMBER (TO_CHAR (fl.lic_acct_date,
                                                   'YYYYMMDD'
                                                  )
                                         ) BETWEEN temp_period AND temp_period_end
                           AND fcon.con_number = fl.lic_con_number
                           AND fc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno
                           AND flsl.lis_lic_number = fl.lic_number
                           AND flsl.lis_lsl_number = xfsl.lsl_number
                           AND    flsl.lis_per_year
                               || LPAD (flsl.lis_per_month, 2, 0) <=
                                  TO_NUMBER (TO_CHAR (fl.lic_acct_date,
                                                      'YYYYMM'
                                                     )
                                            )
                           --to_number(to_char(:PARAM5,'YYYYMM'))
                           AND EXISTS (
                                  SELECT NULL
                                    FROM fid_payment fp
                                   WHERE fp.pay_lic_number = fl.lic_number
                                     AND fp.pay_status IN ('I', 'P')
                                     AND TO_DATE (TO_CHAR (fp.pay_date,
                                                           'DD-MON-RRRR'
                                                          ),
                                                  'DD-MON-RRRR'
                                                 ) <
                                            TO_DATE (fl.lic_acct_date,
                                                     'DD-MON-RRRR'
                                                    ))
                           /*AND lic_start <= first_date
                           ----------Pure Finance: Start:[FIN36]_Hari_2013/03/06]
                           AND lic_end >=
                           LAST_DAY (TO_CHAR (TO_DATE (i_to_period, 'MM/DD/YYYY'),
                           'DD-MON-YYYY'
                           )
                           )*/
                           AND fl.lic_status NOT IN
                                  ('C', 'F', 'T')
                            --added so that t licenses should not be displayed
                      ----Dev2: Pure Finance:END----------------------------
                      --    and rownum<=100
                      GROUP BY license_region (lic_number),
                               flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               fc.com_short_name,
                               x.com_name,
                               fcon.con_short_name,
                               fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35),
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM'),
                               TO_CHAR (fl.lic_start, 'DDMonYYYY'),
                               TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                               fcon.con_number,
                               fc.com_number,
                               paid_amount (lic_number,
                                            con_number,
                                            lic_currency,
                                            lic_acct_date,
                                            lsl_number
                                           ),
                               paid_amount_local (lic_number,
                                                  con_number,
                                                  lic_currency,
                                                  lic_acct_date,
                                                  lsl_number
                                                 ),
                               paid_amount_golive (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  ),
                               x_pkg_fin_get_spot_rate.get_spot_rate
                                                   (lic_currency,
                                                    ter_cur_code,
                                                    month_end_rate (l_month,
                                                                    l_year,
                                                                    lic_number
                                                                   )
                                                   ),
                               DECODE
                                  (i_region,
                                   'AFR', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'RSA'
                                                                     )
                                          )
                                  ),
                               DECODE
                                  (i_region,
                                   'RSA', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'AFR'
                                                                     )
                                          )
                                  ),
                               x.ter_cur_code,
                               fc.com_ter_code,
                               fl.lic_status--Finace DEV Phase 1 [Ankur Kasar]
                      /*    ORDER BY lic_currency,
                      lic_type,
                      lee_short_name,
                      lic_budget_code,
                      b.com_short_name,
                      con_short_name,
                      lic_number,
                      SUBSTR (gen_title, 1, 35),
                      TO_CHAR (lic_acct_date, 'YYYY.MM'),
                      TO_CHAR (lic_start, 'DDMonYYYY'),
                      TO_CHAR (lic_end, 'DDMonYYYY'),
                      con_number
                      */
                      UNION
                      SELECT
                               ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
                               (SELECT DECODE (i_region,
                                               '%', 'Consolidated',
                                               i_region
                                              )
                                  FROM DUAL) reg_code,
                               license_region (lic_number) region_name,

                               ----Dev2: Pure Finance:END----------------------------
                               flee.lee_cha_com_number, fl.lic_currency,
                               fl.lic_type, flee.lee_short_name,
                               fl.lic_budget_code, fc.com_short_name,
                               x.com_name company_channel,
                               fcon.con_short_name, fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35) gen_title,
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct,
                               TO_CHAR (fl.lic_start, 'DDMonYYYY') start_date,
                               TO_CHAR (fl.lic_end, 'DDMonYYYY') end_date,
                               fcon.con_number, fc.com_number,
                               SUM (  0
                                    * (100 + NVL (lic_markup_percent, 0))
                                    / 100
                                   ) lis_con_fc_imu,
                               NVL (paid_amount (lic_number,
                                                 con_number,
                                                 lic_currency,
                                                 lic_acct_date,
                                                 lsl_number
                                                ),
                                    0
                                   ) paid,
                               DECODE
                                  (paid_amount (lic_number,
                                                con_number,
                                                lic_currency,
                                                lic_acct_date,
                                                lsl_number
                                               ),
                                   0, 0.00,
                                   NVL (paid_amount_local (lic_number,
                                                           con_number,
                                                           lic_currency,
                                                           lic_acct_date,
                                                           lsl_number
                                                          ),
                                        0.00
                                       )
                                  ) local_paid,

                               /*(CASE
                               WHEN paid_amount (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ) = 0
                               AND paid_amount_golive (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ) = 0
                               THEN DECODE
                               (lic_currency,
                               'USD', paid_amount_local
                               (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ),
                               0.00
                               )
                               ELSE 0.00
                               END
                               )*/
                               0.00 rel_forex_gl,
                               NVL
                                  ((  SUM (  0
                                           * (100
                                              + NVL (lic_markup_percent, 0)
                                             )
                                           / 100
                                          )
                                    - paid_amount (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  )
                                   ),
                                   0
                                  ) liability,

                                 ----------Pure Finance: Start:[FIN6]_Hari_2013/03/06]
                                 (NVL ((  SUM (  0
                                               * (  100
                                                  + NVL (lic_markup_percent,
                                                         0)
                                                 )
                                               / 100
                                              )
                                        - paid_amount (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       lic_acct_date,
                                                       lsl_number
                                                      )
                                       ),
                                       0
                                      )
                                 )
                               * x_pkg_fin_get_spot_rate.get_spot_rate
                                                   (lic_currency,
                                                    ter_cur_code,
                                                    month_end_rate (l_month,
                                                                    l_year,
                                                                    lic_number
                                                                   )
                                                   ) local_liability,
                               ROUND(x_pkg_fin_get_spot_rate.get_spot_rate
                                    (lic_currency,
                                     ter_cur_code,
                                     month_end_rate (l_month,
                                                     l_year,
                                                     lic_number
                                                    )
                                    ) ,5)exchange_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'AFR', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'RSA'
                                                                     )
                                          )
                                  ),5) rsa_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'RSA', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'AFR'
                                                                     )
                                          )
                                  ),5) afr_rate,

                               ----Dev2: Pure Finance:END----------------------------
                               x.ter_cur_code, 
                               fc.com_ter_code,
                               fl.lic_status--Finace DEV Phase 1 [Ankur Kasar]
                          FROM                       --fid_license_sub_ledger,
                               fid_general fg,
                               fid_company fc,
                               fid_contract fcon,
                               fid_license fl,
                               fid_licensee flee,
                               ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                               x_fin_lic_sec_lee xfsl,
                               fid_region fr,

                               ----Dev2: Pure Finance:END----------------------------
                               (SELECT   fc.com_number, fc.com_short_name,
                                         fc.com_name, fc.com_ter_code,
                                         ft.ter_cur_code
                                    FROM fid_company fc, fid_territory ft
                                   WHERE fc.com_short_name LIKE
                                                             i_channel_company
                                     AND fc.com_type IN ('CC', 'BC')
                                     AND ft.ter_code = fc.com_ter_code
                                ORDER BY fc.com_name) x
                         WHERE flee.lee_cha_com_number = x.com_number
                           ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                           AND xfsl.lsl_lic_number = fl.lic_number
                           AND xfsl.lsl_lee_number = flee.lee_number
                           AND flee.lee_split_region = fr.reg_id(+)
                           AND UPPER (fr.reg_code) LIKE UPPER (i_region)
                           ----Dev2: Pure Finance:END----------------------------
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_licensee
                           AND fl.lic_budget_code LIKE i_budget_code
                           AND fl.lic_acct_date IS NOT NULL
                           --AND (TO_CHAR (lic_acct_date, 'YYYYMM') = temp_period
                           -- )                            --to_char(:PARAM5,'YYYYMM'))
                           AND TO_NUMBER (TO_CHAR (lic_acct_date, 'YYYYMMDD'))
                                  BETWEEN temp_period
                                      AND temp_period_end
                           AND fcon.con_number = fl.lic_con_number
                           AND fc.com_number = fcon.con_com_number
                           AND gen_refno = lic_gen_refno
                           -- AND lis_lic_number = lic_number
                           -- AND lis_lsl_number = lsl_number
                           -- AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                           --                     TO_NUMBER (TO_CHAR (lic_acct_date, 'YYYYMM'))
                           --to_number(to_char(:PARAM5,'YYYYMM'))
                           AND EXISTS (
                                  SELECT NULL
                                    FROM fid_payment fp
                                   WHERE fp.pay_lic_number = fl.lic_number
                                     AND fp.pay_status IN ('I', 'P')
                                     AND TO_DATE (TO_CHAR (fp.pay_date,
                                                           'DD-MON-RRRR'
                                                          ),
                                                  'DD-MON-RRRR'
                                                 ) <
                                            TO_DATE (fl.lic_acct_date,
                                                     'DD-MON-RRRR'
                                                    ))
                           /*AND lic_start <= first_date
                           ----------Pure Finance: Start:[FIN36]_Hari_2013/03/06]
                           AND lic_end >=
                           LAST_DAY (TO_CHAR (TO_DATE (i_to_period, 'MM/DD/YYYY'),
                           'DD-MON-YYYY'
                           )
                           )*/
                           AND fl.lic_status = 'C'
                           AND fl.lic_status NOT IN
                                  ('F', 'T')
                            --added so that t licenses should not be displayed
                           AND TO_NUMBER (TO_CHAR (fl.lic_cancel_date,
                                                   'YYYYMM'
                                                  )
                                         ) <=
                                  TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
                      ----Dev2: Pure Finance:END----------------------------
                      --    and rownum<=100
                      GROUP BY license_region (lic_number),
                               flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               fc.com_short_name,
                               x.com_name,
                               fcon.con_short_name,
                               fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35),
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM'),
                               TO_CHAR (fl.lic_start, 'DDMonYYYY'),
                               TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                               fcon.con_number,
                               fc.com_number,
                               paid_amount (lic_number,
                                            con_number,
                                            lic_currency,
                                            lic_acct_date,
                                            lsl_number
                                           ),
                               paid_amount_local (lic_number,
                                                  con_number,
                                                  lic_currency,
                                                  lic_acct_date,
                                                  lsl_number
                                                 ),
                               paid_amount_golive (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  ),
                               x_pkg_fin_get_spot_rate.get_spot_rate
                                                   (lic_currency,
                                                    ter_cur_code,
                                                    month_end_rate (l_month,
                                                                    l_year,
                                                                    lic_number
                                                                   )
                                                   ),
                               DECODE
                                  (i_region,
                                   'AFR', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'RSA'
                                                                     )
                                          )
                                  ),
                               DECODE
                                  (i_region,
                                   'RSA', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'AFR'
                                                                     )
                                          )
                                  ),
                               ter_cur_code,
                               fc.com_ter_code,
                               fl.lic_status--Finace DEV Phase 1 [Ankur Kasar]
                               )
            ORDER BY lic_currency,
                     lic_type,
                     lee_short_name,
                     lic_budget_code,
                     com_short_name,
                     con_short_name,
                     lic_number,
                     gen_title,
                     acct,
                     start_date,
                     end_date,
                     con_number;
      END IF;

      IF (UPPER (l_license_in_out) = 'BOTH')
      THEN
         OPEN o_pre_payment FOR
            SELECT   *
                FROM (SELECT
                               ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
                               (SELECT DECODE (i_region,
                                               '%', 'Consolidated',
                                               i_region
                                              )
                                  FROM DUAL) reg_code,
                               license_region (lic_number) region_name,

                               ----Dev2: Pure Finance:END----------------------------
                               flee.lee_cha_com_number, fl.lic_currency,
                               fl.lic_type, flee.lee_short_name,
                               fl.lic_budget_code, fc.com_short_name,
                               x.com_name company_channel,
                               fcon.con_short_name, fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35) gen_title,
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct,
                               TO_CHAR (fl.lic_start, 'DDMonYYYY') start_date,
                               TO_CHAR (fl.lic_end, 'DDMonYYYY') end_date,
                               fcon.con_number,

                               --     SUM(lis_con_forecast * (100 + NVL(lic_markup_percent,0)) / 100) lis_con_fc_imu,
                               --  b.com_number,
                               SUM
                                  (  flsl.lis_con_forecast
                                   * (100 + NVL (fl.lic_markup_percent, 0))
                                   / 100
                                  ) lis_con_fc_imu,
                               NVL (paid_amount (lic_number,
                                                 con_number,
                                                 lic_currency,
                                                 lic_acct_date,
                                                 lsl_number
                                                ),
                                    0
                                   ) paid,
                               DECODE
                                  (paid_amount (lic_number,
                                                con_number,
                                                lic_currency,
                                                lic_acct_date,
                                                lsl_number
                                               ),
                                   0, 0.00,
                                   NVL (paid_amount_local (lic_number,
                                                           con_number,
                                                           lic_currency,
                                                           lic_acct_date,
                                                           lsl_number
                                                          ),
                                        0.00
                                       )
                                  ) local_paid,

                        
                               0.00 rel_forex_gl,
                               NVL
                                  ((  SUM (  flsl.lis_con_forecast
                                           * (  100
                                              + NVL (fl.lic_markup_percent, 0)
                                             )
                                           / 100
                                          )
                                    - paid_amount (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  )
                                   ),
                                   0
                                  ) liability,

                                 ----------Pure Finance: Start:[FIN6]_Hari_2013/03/06]
                                 (NVL ((  SUM (  flsl.lis_con_forecast
                                               * (  100
                                                  + NVL
                                                       (fl.lic_markup_percent,
                                                        0
                                                       )
                                                 )
                                               / 100
                                              )
                                        - paid_amount (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       lic_acct_date,
                                                       lsl_number
                                                      )
                                       ),
                                       0
                                      )
                                 )
                               * x_pkg_fin_get_spot_rate.get_spot_rate
                                                   (lic_currency,
                                                    ter_cur_code,
                                                    month_end_rate (l_month,
                                                                    l_year,
                                                                    lic_number
                                                                   )
                                                   ) local_liability,
                              ROUND( x_pkg_fin_get_spot_rate.get_spot_rate
                                    (lic_currency,
                                     ter_cur_code,
                                     month_end_rate (l_month,
                                                     l_year,
                                                     lic_number
                                                    )
                                    ),5) exchange_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'AFR', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'RSA'
                                                                     )
                                          )
                                  ),5) rsa_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'RSA', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'AFR'
                                                                     )
                                          )
                                  ),5) afr_rate,

                               ----Dev2: Pure Finance:END----------------------------
                               x.ter_cur_code,
                               fc.com_ter_code,
                               fl.lic_status, --Finace DEV Phase 1 [Ankur Kasar]
                               'Ppmt To Liab' lsl_con_pay_flag --Finace DEV Phase 1 [Ankur Kasar]
                          FROM fid_license_sub_ledger flsl,
                               fid_general fg,
                               fid_company fc,
                               fid_contract fcon,
                               fid_license fl,
                               fid_licensee flee,
                               ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                               x_fin_lic_sec_lee xfsl,
                               fid_region fr,

                               ----Dev2: Pure Finance:END----------------------------
                               (SELECT   fc.com_number,
                                                       --    com_short_name,
                                                       fc.com_name,

                                         --   com_ter_code,
                                         ft.ter_cur_code
                                    FROM fid_company fc, fid_territory ft
                                   WHERE fc.com_short_name LIKE
                                                             i_channel_company
                                     AND fc.com_type IN ('CC', 'BC')
                                     AND ft.ter_code = fc.com_ter_code
                                ORDER BY fc.com_name) x
                         WHERE flee.lee_cha_com_number = x.com_number
                           ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                           AND xfsl.lsl_lic_number = fl.lic_number
                           AND xfsl.lsl_lee_number = flee.lee_number
                           AND flee.lee_split_region = fr.reg_id(+)
                           AND UPPER (fr.reg_code) LIKE UPPER (i_region)
                           ----Dev2: Pure Finance:END----------------------------
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_licensee
                           AND fl.lic_budget_code LIKE i_budget_code
                           AND fl.lic_acct_date IS NOT NULL
                           -- AND (TO_CHAR (lic_acct_date, 'YYYYMM') = temp_period
                           --  )                            --to_char(:PARAM5,'YYYYMM'))
                           AND TO_NUMBER (TO_CHAR (fl.lic_acct_date,
                                                   'RRRRMMDD'
                                                  )
                                         ) BETWEEN temp_period AND temp_period_end
                           -- and to_date(lic_acct_date,'MM/DD/YYYY') between i_from_period
                           --  and i_to_period
                           AND fcon.con_number = fl.lic_con_number
                           AND fc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno
                           AND flsl.lis_lic_number = fl.lic_number
                           AND flsl.lis_lsl_number = xfsl.lsl_number
                           AND    flsl.lis_per_year
                               || LPAD (flsl.lis_per_month, 2, 0) <=
                                  TO_NUMBER (TO_CHAR (fl.lic_acct_date,
                                                      'YYYYMM'
                                                     )
                                            )
                           --to_number(to_char(:PARAM5,'YYYYMM'))
                           AND EXISTS (
                                  SELECT NULL
                                    FROM fid_payment fp
                                   WHERE fp.pay_lic_number = fl.lic_number
                                     AND fp.pay_status IN ('I', 'P')
                                     AND TO_DATE (TO_CHAR (fp.pay_date,
                                                           'DD-MON-RRRR'
                                                          ),
                                                  'DD-MON-RRRR'
                                                 ) <
                                            TO_DATE (fl.lic_acct_date,
                                                     'DD-MON-RRRR'
                                                    ))
                           AND fl.lic_status NOT IN
                                  ('C', 'F', 'T')
                            --added so that t licenses should not be displayed
                      GROUP BY flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               fc.com_short_name,
                               x.com_name,
                               fcon.con_short_name,
                               fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35),
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM'),
                               TO_CHAR (fl.lic_start, 'DDMonYYYY'),
                               TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                               fcon.con_number,
                               paid_amount (lic_number,
                                            con_number,
                                            lic_currency,
                                            lic_acct_date,
                                            lsl_number
                                           ),
                               paid_amount_local (lic_number,
                                                  con_number,
                                                  lic_currency,
                                                  lic_acct_date,
                                                  lsl_number
                                                 ),
                               paid_amount_golive (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  ),
                               exchange_rate (lic_currency, ter_cur_code),
                               x.ter_cur_code,
                               fc.com_ter_code,
                               fl.lic_status --Finace DEV Phase 1 [Ankur Kasar]
                      UNION
                      SELECT
                               ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
                               (SELECT DECODE (i_region,
                                               '%', 'Consolidated',
                                               i_region
                                              )
                                  FROM DUAL) reg_code,
                               license_region (lic_number) region_name,

                               ----Dev2: Pure Finance:END----------------------------
                               flee.lee_cha_com_number, fl.lic_currency,
                               fl.lic_type, flee.lee_short_name,
                               fl.lic_budget_code, fc.com_short_name,
                               x.com_name company_channel,
                               fcon.con_short_name, fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35) gen_title,
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct,
                               TO_CHAR (fl.lic_start, 'DDMonYYYY') start_date,
                               TO_CHAR (fl.lic_end, 'DDMonYYYY') end_date,
                               fcon.con_number,

                               --     SUM(lis_con_forecast * (100 + NVL(lic_markup_percent,0)) / 100) lis_con_fc_imu,
                               --  b.com_number,
                               SUM
                                  (  0
                                   * (100 + NVL (fl.lic_markup_percent, 0))
                                   / 100
                                  ) lis_con_fc_imu,
                               NVL (paid_amount (lic_number,
                                                 con_number,
                                                 lic_currency,
                                                 lic_acct_date,
                                                 lsl_number
                                                ),
                                    0
                                   ) paid,
                               DECODE
                                  (paid_amount (lic_number,
                                                con_number,
                                                lic_currency,
                                                lic_acct_date,
                                                lsl_number
                                               ),
                                   0, 0.00,
                                   NVL (paid_amount_local (lic_number,
                                                           con_number,
                                                           lic_currency,
                                                           lic_acct_date,
                                                           lsl_number
                                                          ),
                                        0.00
                                       )
                                  ) local_paid,

                               0.00 rel_forex_gl,
                               NVL
                                  ((  SUM (  0
                                           * (  100
                                              + NVL (fl.lic_markup_percent, 0)
                                             )
                                           / 100
                                          )
                                    - paid_amount (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  )
                                   ),
                                   0
                                  ) liability,

                                 ----------Pure Finance: Start:[FIN6]_Hari_2013/03/06]
                                 (NVL ((  SUM (  0
                                               * (  100
                                                  + NVL
                                                       (fl.lic_markup_percent,
                                                        0
                                                       )
                                                 )
                                               / 100
                                              )
                                        - paid_amount (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       lic_acct_date,
                                                       lsl_number
                                                      )
                                       ),
                                       0
                                      )
                                 )
                               * x_pkg_fin_get_spot_rate.get_spot_rate
                                                   (lic_currency,
                                                    ter_cur_code,
                                                    month_end_rate (l_month,
                                                                    l_year,
                                                                    lic_number
                                                                   )
                                                   ) local_liability,
                               ROUND(x_pkg_fin_get_spot_rate.get_spot_rate
                                    (lic_currency,
                                     ter_cur_code,
                                     month_end_rate (l_month,
                                                     l_year,
                                                     lic_number
                                                    )
                                    ),5) exchange_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'AFR', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'RSA'
                                                                     )
                                          )
                                  ) ,5)rsa_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'RSA', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'AFR'
                                                                     )
                                          )
                                  ),5) afr_rate,

                               ----Dev2: Pure Finance:END----------------------------
                               ter_cur_code, 
                               fc.com_ter_code,
                               fl.lic_status, --Finace DEV Phase 1 [Ankur Kasar]
                               'Ppmt To Liab' lsl_con_pay_flag
                          FROM                       --fid_license_sub_ledger,
                               fid_general fg,
                               fid_company fc,
                               fid_contract fcon,
                               fid_license fl,
                               fid_licensee flee,
                               ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                               x_fin_lic_sec_lee xfsl,
                               fid_region fr,

                               ----Dev2: Pure Finance:END----------------------------
                               (SELECT   fc.com_number,
                                                       --    com_short_name,
                                                       fc.com_name,

                                         --   com_ter_code,
                                         ft.ter_cur_code
                                    FROM fid_company fc, fid_territory ft
                                   WHERE fc.com_short_name LIKE
                                                             i_channel_company
                                     AND fc.com_type IN ('CC', 'BC')
                                     AND ft.ter_code = fc.com_ter_code
                                ORDER BY fc.com_name) x
                         WHERE flee.lee_cha_com_number = x.com_number
                           ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                           AND xfsl.lsl_lic_number = fl.lic_number
                           AND xfsl.lsl_lee_number = flee.lee_number
                           AND flee.lee_split_region = fr.reg_id(+)
                           AND UPPER (fr.reg_code) LIKE UPPER (i_region)
                           ----Dev2: Pure Finance:END----------------------------
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_licensee
                           AND fl.lic_budget_code LIKE i_budget_code
                           AND fl.lic_acct_date IS NOT NULL
                           -- AND (TO_CHAR (lic_acct_date, 'YYYYMM') = temp_period
                           --  )                            --to_char(:PARAM5,'YYYYMM'))
                           AND TO_NUMBER (TO_CHAR (fl.lic_acct_date,
                                                   'YYYYMMDD'
                                                  )
                                         ) BETWEEN temp_period AND temp_period_end
                           -- and to_date(lic_acct_date,'MM/DD/YYYY') between i_from_period
                           --  and i_to_period
                           AND fcon.con_number = fl.lic_con_number
                           AND fc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno
                           --  AND lis_lic_number = lic_number
                           --  AND lis_lsl_number = lsl_number
                           --  AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                           --                      TO_NUMBER (TO_CHAR (lic_acct_date, 'YYYYMM'))
                           --to_number(to_char(:PARAM5,'YYYYMM'))
                           AND EXISTS (
                                  SELECT NULL
                                    FROM fid_payment fp
                                   WHERE fp.pay_lic_number = lic_number
                                     AND fp.pay_status IN ('I', 'P')
                                     AND TO_DATE (TO_CHAR (fp.pay_date,
                                                           'DD-MON-RRRR'
                                                          ),
                                                  'DD-MON-RRRR'
                                                 ) <
                                            TO_DATE (lic_acct_date,
                                                     'DD-MON-RRRR'
                                                    ))
                           AND FL.LIC_STATUS = 'C'
                           AND FL.LIC_STATUS NOT IN  ('F', 'T') --added so that t licenses should not be displayed

			   /*Commented by Jawahar
			   AND TO_NUMBER (TO_CHAR (fl.lic_cancel_date,
                                                   'YYYYMM'
                                                  )
                                         ) <=
                                  TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
			   */

			   /*
                              Old condition gave incorrect past data by filtering out cancelled licenses,
                              even though they were cancelled on a future date. Eg, a license cancelled in February
                              was filtered out for January, even though it was active in January. Below condition
                              fixes this.
			      */
                           AND TO_NUMBER (TO_CHAR (FL.LIC_CANCEL_DATE,'YYYYMMDD')) > temp_period_end --Added by Jawahar to correct license cancle date condition
                                  --TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
                      GROUP BY flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               fc.com_short_name,
                               x.com_name,
                               fcon.con_short_name,
                               fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35),
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM'),
                               TO_CHAR (fl.lic_start, 'DDMonYYYY'),
                               TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                               fcon.con_number,
                               paid_amount (lic_number,
                                            con_number,
                                            lic_currency,
                                            lic_acct_date,
                                            lsl_number
                                           ),
                               paid_amount_local (lic_number,
                                                  con_number,
                                                  lic_currency,
                                                  lic_acct_date,
                                                  lsl_number
                                                 ),
                               paid_amount_golive (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  ),
                               exchange_rate (lic_currency, ter_cur_code),
                               x.ter_cur_code,
                               fc.com_ter_code,
                               fl.lic_status --Finace DEV Phase 1 [Ankur Kasar]
                               )
            ORDER BY lic_currency,
                     lic_type,
                     lee_short_name,
                     lic_budget_code,
                     com_short_name,
                     con_short_name,
                     lic_number,
                     gen_title,
                     acct,
                     start_date,
                     end_date,
                     con_number;
      END IF;

      IF (UPPER (l_license_in_out) = 'OUT')
      THEN
         OPEN o_pre_payment FOR
            SELECT   *
                FROM (SELECT
                               ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
                               (SELECT DECODE (i_region,
                                               '%', 'Consolidated',
                                               i_region
                                              )
                                  FROM DUAL) reg_code,
                               license_region (lic_number) region_name,

                               -----------Dev2: Pure Finance:END----------------------------
                               flee.lee_cha_com_number, fl.lic_currency,
                               fl.lic_type, flee.lee_short_name,
                               fl.lic_budget_code, fc.com_short_name,
                               x.com_name company_channel,
                               fcon.con_short_name, fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35) gen_title,
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct,
                               TO_CHAR (fl.lic_start, 'DDMonYYYY') start_date,
                               TO_CHAR (fl.lic_end, 'DDMonYYYY') end_date,
                               fcon.con_number,

                               --       SUM(lis_con_forecast * (100 + NVL(lic_markup_percent,0)) / 100) lis_con_fc_imu,
                               --        b.com_number,
                               SUM
                                  (  flsl.lis_con_forecast
                                   * (100 + NVL (fl.lic_markup_percent, 0))
                                   / 100
                                  ) lis_con_fc_imu,
                               NVL (paid_amount (lic_number,
                                                 con_number,
                                                 lic_currency,
                                                 lic_acct_date,
                                                 lsl_number
                                                ),
                                    0
                                   ) paid,
                               DECODE
                                  (paid_amount (lic_number,
                                                con_number,
                                                lic_currency,
                                                lic_acct_date,
                                                lsl_number
                                               ),
                                   0, 0.00,
                                   NVL (paid_amount_local (lic_number,
                                                           con_number,
                                                           lic_currency,
                                                           lic_acct_date,
                                                           lsl_number
                                                          ),
                                        0.00
                                       )
                                  ) local_paid,

                               /*(CASE
                               WHEN paid_amount (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ) = 0
                               AND paid_amount_golive (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ) = 0
                               THEN DECODE
                               (lic_currency,
                               'USD', paid_amount_local
                               (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ),
                               0.00
                               )
                               ELSE 0.00
                               END
                               )*/
                               0.00 rel_forex_gl,
                               NVL
                                  ((  SUM (  flsl.lis_con_forecast
                                           * (  100
                                              + NVL (fl.lic_markup_percent, 0)
                                             )
                                           / 100
                                          )
                                    - paid_amount (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  )
                                   ),
                                   0
                                  ) liability,

                                 ----------Pure Finance: Start:[FIN6]_Hari_2013/03/06]
                                 (NVL ((  SUM (  flsl.lis_con_forecast
                                               * (  100
                                                  + NVL
                                                       (fl.lic_markup_percent,
                                                        0
                                                       )
                                                 )
                                               / 100
                                              )
                                        - paid_amount (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       lic_acct_date,
                                                       lsl_number
                                                      )
                                       ),
                                       0
                                      )
                                 )
                               * x_pkg_fin_get_spot_rate.get_spot_rate
                                                   (lic_currency,
                                                    ter_cur_code,
                                                    month_end_rate (l_month,
                                                                    l_year,
                                                                    lic_number
                                                                   )
                                                   ) local_liability,
                               ROUND(x_pkg_fin_get_spot_rate.get_spot_rate
                                    (lic_currency,
                                     ter_cur_code,
                                     month_end_rate (l_month,
                                                     l_year,
                                                     lic_number
                                                    )
                                    ),5) exchange_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'AFR', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'RSA'
                                                                     )
                                          )
                                  ),5) rsa_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'RSA', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'AFR'
                                                                     )
                                          )
                                  ),5) afr_rate,

                               ---Dev2: Pure Finance:END----------------------------
                               x.ter_cur_code,
                               fc.com_ter_code,
                               fl.lic_status    --Finace DEV Phase 1 [Ankur Kasar]                           
                          FROM fid_license_sub_ledger flsl,
                               fid_general fg,
                               fid_company fc,
                               fid_contract fcon,
                               fid_license fl,
                               fid_licensee flee,
                               ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                               x_fin_lic_sec_lee xfsl,
                               fid_region fr,

                               ----Dev2: Pure Finance:END----------------------------
                               (SELECT   fc.com_number, fc.com_short_name,
                                         fc.com_name, fc.com_ter_code,
                                         ft.ter_cur_code
                                    FROM fid_company fc, fid_territory ft
                                   WHERE fc.com_short_name LIKE
                                                             i_channel_company
                                     AND fc.com_type IN ('CC', 'BC')
                                     AND ft.ter_code = fc.com_ter_code
                                ORDER BY fc.com_name) x
                         WHERE flee.lee_cha_com_number = x.com_number
                           ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                           AND xfsl.lsl_lic_number = fl.lic_number
                           AND xfsl.lsl_lee_number = flee.lee_number
                           AND flee.lee_split_region = fr.reg_id(+)
                           AND UPPER (fr.reg_code) LIKE UPPER (i_region)
                           ----Dev2: Pure Finance:END----------------------------
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_licensee
                           AND fl.lic_budget_code LIKE i_budget_code
                           AND fl.lic_acct_date IS NOT NULL
                           -- AND (TO_CHAR (lic_acct_date, 'YYYYMM') = temp_period
                           --   )                            --to_char(:PARAM5,'YYYYMM'))
                           AND TO_NUMBER (TO_CHAR (fl.lic_acct_date,
                                                   'RRRRMMDD'
                                                  )
                                         ) BETWEEN temp_period AND temp_period_end
                           AND fcon.con_number = fl.lic_con_number
                           AND fc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno
                           AND flsl.lis_lic_number = fl.lic_number
                           AND flsl.lis_lsl_number = xfsl.lsl_number
                           AND    flsl.lis_per_year
                               || LPAD (flsl.lis_per_month, 2, 0) <=
                                  TO_NUMBER (TO_CHAR (fl.lic_acct_date,
                                                      'RRRRMM'
                                                     )
                                            )
                           --to_number(to_char(:PARAM5,'YYYYMM'))
                           AND EXISTS (
                                  SELECT NULL
                                    FROM fid_payment fp
                                   WHERE fp.pay_lic_number = fl.lic_number
                                     AND fp.pay_status IN ('I', 'P')
                                     AND TO_DATE (TO_CHAR (fp.pay_date,
                                                           'DD-MON-RRRR'
                                                          ),
                                                  'DD-MON-RRRR'
                                                 ) <
                                            TO_DATE (fl.lic_acct_date,
                                                     'DD-MON-RRRR'
                                                    ))
                           AND fl.lic_status NOT IN
                                  ('C', 'F', 'T')
                            --added so that t licenses should not be displayed
                      GROUP BY flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               fc.com_short_name,
                               x.com_name,
                               fcon.con_short_name,
                               fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35),
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM'),
                               TO_CHAR (fl.lic_start, 'DDMonYYYY'),
                               TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                               fcon.con_number,
                               paid_amount (lic_number,
                                            con_number,
                                            lic_currency,
                                            lic_acct_date,
                                            lsl_number
                                           ),
                               paid_amount_local (lic_number,
                                                  con_number,
                                                  lic_currency,
                                                  lic_acct_date,
                                                  lsl_number
                                                 ),
                               paid_amount_golive (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  ),
                               exchange_rate (lic_currency, ter_cur_code),
                               x.ter_cur_code,
                               fc.com_ter_code,
                               fl.lic_status --Finace DEV Phase 1 [Ankur Kasar]
                      UNION
                      SELECT
                               ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
                               (SELECT DECODE (i_region,
                                               '%', 'Consolidated',
                                               i_region
                                              )
                                  FROM DUAL) reg_code,
                               license_region (lic_number) region_name,

                               -----------Dev2: Pure Finance:END----------------------------
                               flee.lee_cha_com_number, fl.lic_currency,
                               fl.lic_type, flee.lee_short_name,
                               fl.lic_budget_code, fc.com_short_name,
                               x.com_name company_channel,
                               fcon.con_short_name, fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35) gen_title,
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct,
                               TO_CHAR (fl.lic_start, 'DDMonYYYY') start_date,
                               TO_CHAR (fl.lic_end, 'DDMonYYYY') end_date,
                               fcon.con_number,

                               --       SUM(lis_con_forecast * (100 + NVL(lic_markup_percent,0)) / 100) lis_con_fc_imu,
                               --        b.com_number,
                               SUM
                                  (  0
                                   * (100 + NVL (fl.lic_markup_percent, 0))
                                   / 100
                                  ) lis_con_fc_imu,
                               NVL (paid_amount (lic_number,
                                                 con_number,
                                                 lic_currency,
                                                 lic_acct_date,
                                                 lsl_number
                                                ),
                                    0
                                   ) paid,
                               DECODE
                                  (paid_amount (lic_number,
                                                con_number,
                                                lic_currency,
                                                lic_acct_date,
                                                lsl_number
                                               ),
                                   0, 0.00,
                                   NVL (paid_amount_local (lic_number,
                                                           con_number,
                                                           lic_currency,
                                                           lic_acct_date,
                                                           lsl_number
                                                          ),
                                        0.00
                                       )
                                  ) local_paid,

                               /*(CASE
                               WHEN paid_amount (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ) = 0
                               AND paid_amount_golive (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ) = 0
                               THEN DECODE
                               (lic_currency,
                               'USD', paid_amount_local
                               (lic_number,
                               con_number,
                               lic_currency,
                               lic_acct_date,
                               lsl_number
                               ),
                               0.00
                               )
                               ELSE 0.00
                               END
                               )*/
                               0.00 rel_forex_gl,
                               NVL
                                  ((  SUM (  0
                                           * (  100
                                              + NVL (fl.lic_markup_percent, 0)
                                             )
                                           / 100
                                          )
                                    - paid_amount (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  )
                                   ),
                                   0
                                  ) liability,

                                 ----------Pure Finance: Start:[FIN6]_Hari_2013/03/06]
                                 (NVL ((  SUM (  0
                                               * (  100
                                                  + NVL
                                                       (fl.lic_markup_percent,
                                                        0
                                                       )
                                                 )
                                               / 100
                                              )
                                        - paid_amount (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       lic_acct_date,
                                                       lsl_number
                                                      )
                                       ),
                                       0
                                      )
                                 )
                               * x_pkg_fin_get_spot_rate.get_spot_rate
                                                   (lic_currency,
                                                    ter_cur_code,
                                                    month_end_rate (l_month,
                                                                    l_year,
                                                                    lic_number
                                                                   )
                                                   ) local_liability,
                               ROUND(x_pkg_fin_get_spot_rate.get_spot_rate
                                    (lic_currency,
                                     ter_cur_code,
                                     month_end_rate (l_month,
                                                     l_year,
                                                     lic_number
                                                    )
                                    ),5) exchange_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'AFR', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'RSA'
                                                                     )
                                          )
                                  ),5) rsa_rate,
                               ROUND(DECODE
                                  (i_region,
                                   'RSA', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'AFR'
                                                                     )
                                          )
                                  ) ,5)afr_rate,

                               ---Dev2: Pure Finance:END----------------------------
                               x.ter_cur_code, 
                               fc.com_ter_code,
                               fl.lic_status --Finace DEV Phase 1 [Ankur Kasar]
                          FROM                       --fid_license_sub_ledger,
                               fid_general fg,
                               fid_company fc,
                               fid_contract fcon,
                               fid_license fl,
                               fid_licensee flee,
                               ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                               x_fin_lic_sec_lee xfsl,
                               fid_region fr,

                               ----Dev2: Pure Finance:END----------------------------
                               (SELECT   fc.com_number, fc.com_short_name,
                                         fc.com_name, fc.com_ter_code,
                                         ft.ter_cur_code
                                    FROM fid_company fc, fid_territory ft
                                   WHERE fc.com_short_name LIKE
                                                             i_channel_company
                                     AND fc.com_type IN ('CC', 'BC')
                                     AND ft.ter_code = fc.com_ter_code
                                ORDER BY fc.com_name) x
                         WHERE flee.lee_cha_com_number = x.com_number
                           ----------Pure Finance: Start:[FIN3]_Hari_2013/03/06]
                           AND xfsl.lsl_lic_number = fl.lic_number
                           AND xfsl.lsl_lee_number = flee.lee_number
                           AND flee.lee_split_region = fr.reg_id(+)
                           AND UPPER (fr.reg_code) LIKE UPPER (i_region)
                           ----Dev2: Pure Finance:END----------------------------
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_licensee
                           AND fl.lic_budget_code LIKE i_budget_code
                           AND fl.lic_acct_date IS NOT NULL
                           -- AND (TO_CHAR (lic_acct_date, 'YYYYMM') = temp_period
                           --   )                            --to_char(:PARAM5,'YYYYMM'))
                           AND TO_NUMBER (TO_CHAR (fl.lic_acct_date,
                                                   'RRRRMMDD'
                                                  )
                                         ) BETWEEN temp_period AND temp_period_end
                           AND fcon.con_number = fl.lic_con_number
                           AND fc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno
                           --    AND lis_lic_number = lic_number
                           --    AND lis_lsl_number = lsl_number
                           --     AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                           --                        TO_NUMBER (TO_CHAR (lic_acct_date, 'YYYYMM'))
                           --to_number(to_char(:PARAM5,'YYYYMM'))
                           AND EXISTS (
                                  SELECT NULL
                                    FROM fid_payment fp
                                   WHERE fp.pay_lic_number = fl.lic_number
                                     AND fp.pay_status IN ('I', 'P')
                                     AND TO_DATE (TO_CHAR (fp.pay_date,
                                                           'DD-MON-RRRR'
                                                          ),
                                                  'DD-MON-RRRR'
                                                 ) <
                                            TO_DATE (fl.lic_acct_date,
                                                     'DD-MON-RRRR'
                                                    ))
                           AND fl.lic_status = 'C'
                           AND fl.lic_status NOT IN
                                  ('F', 'T')
                            --added so that t licenses should not be displayed
                           AND TO_NUMBER (TO_CHAR (fl.lic_cancel_date,
                                                   'RRRRMM'
                                                  )
                                         ) <=
                                  TO_NUMBER (TO_CHAR (fl.lic_start, 'RRRRMM'))
                      --AND lic_start <= first_date
                      ----------Pure Finance: Start:[FIN36]_Hari_2013/03/06]
                      --AND lic_end >=
                      --     LAST_DAY (TO_CHAR (TO_DATE (i_to_period, 'MM/DD/YYYY'),
                      --                      'DD-MON-YYYY'
                      --                   )
                      --        )
                      --AND (   lic_start > = first_date
                      --   OR lic_end <
                      --       LAST_DAY (TO_CHAR (TO_DATE (i_to_period,
                      --                                 'MM/DD/YYYY'
                      --                              ),
                      --                    'DD-MON-YYYY'
                      --                 )
                      --      )
                      -- )
                      ----Dev2: Pure Finance:END----------------------------
                      -- and rownum<=1000
                      GROUP BY flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               fc.com_short_name,
                               x.com_name,
                               fcon.con_short_name,
                               fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35),
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM'),
                               TO_CHAR (fl.lic_start, 'DDMonYYYY'),
                               TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                               fcon.con_number,
                               paid_amount (lic_number,
                                            con_number,
                                            lic_currency,
                                            lic_acct_date,
                                            lsl_number
                                           ),
                               paid_amount_local (lic_number,
                                                  con_number,
                                                  lic_currency,
                                                  lic_acct_date,
                                                  lsl_number
                                                 ),
                               paid_amount_golive (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  ),
                               exchange_rate (lic_currency, ter_cur_code),
                               x.ter_cur_code,
                               fc.com_ter_code,
                               fl.lic_status --Finace DEV Phase 1 [Ankur Kasar]
                               )
            ORDER BY lic_currency,
                     lic_type,
                     lee_short_name,
                     lic_budget_code,
                     com_short_name,
                     con_short_name,
                     lic_number,
                     gen_title,
                     acct,
                     start_date,
                     end_date,
                     con_number;
      END IF;
 
 END prc_fin_pre_pay_mv_rep_bfr_go;

--****************************************************************
-- This procedure is called for fetching data after go live date
-- Finace Dev Phase 1[New Data]
-- Ankur Kasar
--**************************************************************** 
   PROCEDURE prc_fin_pre_pay_mv_rep_aft_go (
      ----------Pure Finance: Start:[FIN7]_Hari_2013/03/06]
      i_region            IN       fid_region.reg_code%TYPE,
      ----Dev2: Pure Finance:END----------------------------
      i_channel_company   IN       fid_company.com_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_budget_code       IN       fid_license.lic_budget_code%TYPE,
      i_license_in_out    IN       VARCHAR2,
      ----------Pure Finance: Start:[FIN36]_Hari_2013/03/06]
      i_from_period       IN       VARCHAR2,
      i_to_period         IN       VARCHAR2,
      ----Dev2: Pure Finance:END----------------------------
      o_pre_payment       OUT      pkg_fin_mnet_pre_pay_mv_rpt.fin_pre_pay_mv_cursor
   )
   AS
      -- temp_period      VARCHAR2 (20);
      temp_period       VARCHAR2(20);
      temp_period_end   VARCHAR2(20);
      t_compare_date    NUMBER;
      final_date        DATE;
      l_period          VARCHAR2 (20);
      first_date        VARCHAR2 (20);
      l_month           NUMBER;
      l_year            NUMBER;
      v_go_live_date    DATE;
   BEGIN
     
      
      
      SELECT  (TO_CHAR (TO_DATE (i_from_period, 'MM/DD/RRRR'),
                                 'RRRRMM'
                                )
                       )
        INTO temp_period
        FROM DUAL;

      SELECT  (TO_CHAR (last_day(TO_DATE (i_to_period, 'MM/DD/RRRR')),
                                 'RRRRMM'
                                )
                       )
        INTO temp_period_end
        FROM DUAL;

      SELECT TO_CHAR (TO_DATE (i_from_period, 'MM/DD/RRRR'), 'DD-MON-RRRR')
        INTO l_period
        FROM DUAL;

----------Pure Finance: Start:[FIN6]_Hari_2013/03/06]
      SELECT TO_NUMBER (TO_CHAR (TO_DATE (i_from_period, 'MM/DD/RRRR'), 'MM'))
        INTO l_month
        FROM DUAL;

      SELECT TO_NUMBER (TO_CHAR (TO_DATE (i_from_period, 'MM/DD/RRRR'),
                                 'RRRR')
                       )
        INTO l_year
        FROM DUAL;

----Dev2: Pure Finance:END----------------------------
      SELECT ADD_MONTHS (LAST_DAY (l_period), -1) + 1
        INTO first_date
        FROM DUAL;
        
      delete from x_sub_ledger;
      insert into x_sub_ledger 
      select 
                            lis_lic_number,
                            lis_lsl_number,
                            round(SUM(lis_con_forecast),2) lis_con_forecast,
                            round(SUM(LIS_CON_PAY),2)      LIS_CON_PAY,
                            round(SUM(LIS_LOC_PAY),2)      LIS_LOC_PAY,
                            CASE WHEN SUM(LIS_CON_PAY)> 0
                            THEN 'Ppmt To Liab'
                            ELSE 'Liab To Ppmt'
                            END mv_flag      
                       FROM fid_license_sub_ledger flsl
                       where flsl.LIS_PER_YEAR||lpad(flsl.LIS_PER_MONTH,2,0) between temp_period AND temp_period_end
                       AND flsl.LIS_PAY_MOV_FLAG IN ('I','O')
                       GROUP BY lis_lic_number,
                                lis_lsl_number
                       HAVING (SUM(LIS_CON_PAY) <>0 OR SUM(LIS_LOC_PAY) <>0);
      commit;
      
      open o_pre_payment for
                SELECT
                              DECODE (i_region,
                                      '%', 'Consolidated',
                                      i_region
                                    ) reg_code,
                               license_region (lic_number) region_name,
                               flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               fc.com_short_name,
                               x.com_name company_channel,
                               fcon.con_short_name, 
                               fl.lic_number,
                               SUBSTR (fg.gen_title, 1, 35) gen_title,
                               TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct,
                               TO_CHAR (fl.lic_start, 'DDMonYYYY') start_date,
                               TO_CHAR (fl.lic_end, 'DDMonYYYY') end_date,
                               fcon.con_number,
                               
                                ROUND (  (  flsl.lis_con_forecast
                                   * (100 + NVL (fl.lic_markup_percent, 0))
                                   / 100
                                  ),2) lis_con_fc_imu,
                               ROUND(LIS_CON_PAY,2) PAID,
                               ROUND(LIS_LOC_PAY,2) LOCAL_PAID,
                               0.00 rel_forex_gl,
                               ROUND(NVL
                                  ((   (  flsl.lis_con_forecast
                                           * (  100
                                              + NVL (fl.lic_markup_percent, 0)
                                             )
                                           / 100
                                          )
                                    - paid_amount (lic_number,
                                                   con_number,
                                                   lic_currency,
                                                   lic_acct_date,
                                                   lsl_number
                                                  )
                                   ),
                                   0
                                  ),2) liability,
								  ROUND(
                                 (NVL ((   (  flsl.lis_con_forecast
                                               * (  100
                                                  + NVL
                                                       (fl.lic_markup_percent,
                                                        0
                                                       )
                                                 )
                                               / 100
                                              )
                                        - paid_amount (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       lic_acct_date,
                                                       lsl_number
                                                      )
                                       ),
                                       0
                                      )
                                 )
                               * x_pkg_fin_get_spot_rate.get_spot_rate
                                                   (lic_currency,
                                                    ter_cur_code,
                                                    month_end_rate (l_month,
                                                                    l_year,
                                                                    lic_number
                                                                   )
                                                   )
								,2)	local_liability,
                               ROUND(x_pkg_fin_get_spot_rate.get_spot_rate
                                    (lic_currency,
                                     ter_cur_code,
                                     month_end_rate (l_month,
                                                     l_year,
                                                     lic_number
                                                    )
                                    ),5) exchange_rate,
                               ROUND(
							   DECODE
                                  (i_region,
                                   'AFR', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'RSA'
                                                                     )
                                          )
                                  ),
								  5) rsa_rate,
                               ROUND(
							   DECODE
                                  (i_region,
                                   'RSA', NULL,
                                   x_pkg_fin_get_spot_rate.get_spot_rate
                                          (lic_currency,
                                           ter_cur_code,
                                           month_end_rate_regionwise (l_month,
                                                                      l_year,
                                                                      'AFR'
                                                                     )
                                          )
                                  ) 
								  ,5)afr_rate,
                               x.ter_cur_code,
                               fc.com_ter_code,
                               fl.lic_status,
                              -- DECODE(flsl.LIS_PAY_MOV_FLAG,'I','IN','O','OUT') LIS_PAY_MOV_FLAG                               
                               CASE WHEN SIGN((LIS_CON_PAY)) = -1 
                                    THEN 'Liab To Ppmt'
                                    ELSE 'Ppmt To Liab'
                                END lsl_con_pay_flag                                
                          FROM x_sub_ledger flsl,
                               fid_general fg,
                               fid_company fc,
                               fid_contract fcon,
                               fid_license fl,
                               fid_licensee flee,
                               x_fin_lic_sec_lee xfsl,
                               fid_region fr,
                               (SELECT   fc.com_number,
                                                       fc.com_name,
                                         ft.ter_cur_code
                                    FROM fid_company fc, fid_territory ft
                                   WHERE fc.com_short_name LIKE
                                                             i_channel_company
                                     AND fc.com_type IN ('CC', 'BC')
                                     AND ft.ter_code = fc.com_ter_code
                                ORDER BY fc.com_name) x
                         WHERE flee.lee_cha_com_number = x.com_number
                           AND xfsl.lsl_lic_number   = fl.lic_number
                           AND xfsl.lsl_lee_number   = flee.lee_number
                           AND flee.lee_split_region = fr.reg_id(+)
                           AND UPPER (fr.reg_code)   LIKE UPPER (i_region)
                           AND fl.lic_type           LIKE i_lic_type
                           AND flee.lee_short_name   LIKE i_licensee
                           AND fl.lic_budget_code    LIKE i_budget_code
                           AND fcon.con_number       = fl.lic_con_number
                           AND fc.com_number         = fcon.con_com_number
                           AND fg.gen_refno          = fl.lic_gen_refno
                           AND flsl.lis_lic_number   = fl.lic_number
                           AND flsl.lis_lsl_number   = xfsl.lsl_number
                           AND fl.lic_status NOT IN ('F', 'T')
                           AND UPPER(flsl.mv_flag) like DECODE(UPPER(i_license_in_out),'%',UPPER(flsl.mv_flag),UPPER(i_license_in_out));

   END prc_fin_pre_pay_mv_rep_aft_go;

   FUNCTION paid_amount (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_period         IN   VARCHAR2,
      i_lsl_number     IN   x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER
   IS
      licpay_con_paid_is   NUMBER;
   BEGIN
      SELECT SUM (fp.pay_amount)
        INTO licpay_con_paid_is
        FROM fid_payment fp, fid_payment_type fpt, x_fin_lic_sec_lee xfsl
       WHERE fp.pay_lsl_number = xfsl.lsl_number
         AND fp.pay_lic_number = i_lic_number
         AND fp.pay_con_number = i_con_number
         AND fp.pay_lsl_number = i_lsl_number
         AND fp.pay_status IN ('P', 'I')
         AND fp.pay_cur_code = i_lic_currency
         AND fpt.pat_code = fp.pay_code
         AND TO_DATE (TO_CHAR (fp.pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <
                                             TO_DATE (i_period, 'DD-MON-RRRR')
         --'01-'||TO_CHAR(i_period,'MON-YYYY')
         AND fpt.pat_group = 'F';

      RETURN licpay_con_paid_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         licpay_con_paid_is := 0;

         IF licpay_con_paid_is IS NULL
         THEN
            licpay_con_paid_is := 0;
         END IF;

         RETURN licpay_con_paid_is;
   END;

   FUNCTION paid_amount_local (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_period         IN   VARCHAR2,
      i_lsl_number     IN   x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER
   IS
      licpay_con_paid_is   NUMBER;
      l_count              NUMBER;
      l_refund_amt         NUMBER;
   BEGIN
      licpay_con_paid_is := 0;

      SELECT COUNT (*)
        INTO l_count
        FROM x_fin_refund_settle xfrs
       WHERE xfrs.frs_lic_number = i_lic_number;

      IF l_count > 0
      THEN
         FOR i IN (SELECT fp.pay_number, fp.pay_amount, fp.pay_rate
                     FROM fid_payment fp,
                          fid_payment_type fpt,
                          x_fin_lic_sec_lee xfsl
                    WHERE fp.pay_lsl_number = xfsl.lsl_number
                      AND fp.pay_lsl_number = i_lsl_number
                      AND fp.pay_lic_number = i_lic_number
                      AND fp.pay_con_number = i_con_number
                      AND fp.pay_status IN ('P', 'I')
                      AND fp.pay_cur_code = i_lic_currency
                      AND fpt.pat_code = fp.pay_code
                      AND TO_DATE (TO_CHAR (fp.pay_date, 'DD-MON-RRRR'),
                                   'DD-MON-RRRR'
                                  ) < TO_DATE (i_period, 'DD-MON-RRRR'))
         LOOP
            IF (i.pay_amount < 0)
            THEN
               SELECT NVL (SUM (xfrs.frs_rfd_amount), 0)
                 INTO l_refund_amt
                 FROM x_fin_refund_settle xfrs
                WHERE xfrs.frs_rfd_pay_number = i.pay_number;

               licpay_con_paid_is :=
                    licpay_con_paid_is
                  + (i.pay_amount + l_refund_amt) * i.pay_rate;
            END IF;

            IF (i.pay_amount > 0)
            THEN
               SELECT NVL (SUM (xfrs.frs_rfd_amount), 0)
                 INTO l_refund_amt
                 FROM x_fin_refund_settle xfrs, fid_payment fp
                WHERE xfrs.frs_pay_number = i.pay_number
                  AND xfrs.frs_rfd_pay_number = fp.pay_number
                  AND xfrs.frs_lic_number = i_lic_number
                  AND TO_DATE (TO_CHAR (fp.pay_date, 'DD-MON-RRRR'),
                               'DD-MON-RRRR'
                              ) < TO_DATE (i_period, 'DD-MON-RRRR');

               licpay_con_paid_is :=
                    licpay_con_paid_is
                  + (i.pay_amount - l_refund_amt) * i.pay_rate;
            END IF;
         END LOOP;
      ELSE
         SELECT SUM (fp.pay_amount * fp.pay_rate)
           INTO licpay_con_paid_is
           FROM fid_payment fp, fid_payment_type fpt, x_fin_lic_sec_lee xfsl
          WHERE fp.pay_lsl_number = xfsl.lsl_number
            AND fp.pay_lic_number = i_lic_number
            AND fp.pay_con_number = i_con_number
            AND fp.pay_lsl_number = i_lsl_number
            AND fp.pay_status IN ('P', 'I')
            AND fp.pay_cur_code = i_lic_currency
            AND fpt.pat_code = fp.pay_code
            AND TO_DATE (TO_CHAR (fp.pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <
                                             TO_DATE (i_period, 'DD-MON-RRRR')
            --'01-'||TO_CHAR(i_period,'MON-YYYY')
            AND fpt.pat_group = 'F';
      END IF;

      RETURN licpay_con_paid_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         licpay_con_paid_is := 0;

         IF licpay_con_paid_is IS NULL
         THEN
            licpay_con_paid_is := 0;
         END IF;

         RETURN licpay_con_paid_is;
   END;

   FUNCTION paid_amount_golive (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_period         IN   VARCHAR2,
      i_lsl_number     IN   x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER
   IS
      licpay_con_paid_is   NUMBER;
      v_go_live_date       DATE;
   BEGIN
      SELECT TO_DATE (xfc.content)
        INTO v_go_live_date
        FROM x_fin_configs xfc
       WHERE KEY = 'GO-LIVEDATE';

      SELECT SUM (fp.pay_amount)
        INTO licpay_con_paid_is
        FROM fid_payment fp, fid_payment_type fpt, x_fin_lic_sec_lee xfsl
       WHERE fp.pay_lsl_number = xfsl.lsl_number
         AND fp.pay_lic_number = i_lic_number
         AND fp.pay_con_number = i_con_number
         AND fp.pay_lsl_number = i_lsl_number
         AND fp.pay_status IN ('P', 'I')
         AND fp.pay_cur_code = i_lic_currency
         AND fpt.pat_code = fp.pay_code
         AND TO_DATE (TO_CHAR (fp.pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <
                                             TO_DATE (i_period, 'DD-MON-RRRR')
         AND TO_DATE (TO_CHAR (fp.pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <
                                       TO_DATE (v_go_live_date, 'DD-MON-RRRR')
         AND fpt.pat_group = 'F';

      RETURN licpay_con_paid_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         licpay_con_paid_is := 0;

         IF licpay_con_paid_is IS NULL
         THEN
            licpay_con_paid_is := 0;
         END IF;

         RETURN licpay_con_paid_is;
   END;

   FUNCTION exchange_rate (
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_ter_cur_code   IN   fid_territory.ter_cur_code%TYPE
   )
      RETURN NUMBER
   IS
      rate_is   NUMBER;

      CURSOR get_exchange_rate
      IS
         SELECT NVL (fer.rat_rate, 0)
           FROM fid_exchange_rate fer
          WHERE fer.rat_cur_code = i_lic_currency
            AND fer.rat_cur_code_2 = i_ter_cur_code;
   BEGIN
      OPEN get_exchange_rate;

      FETCH get_exchange_rate
       INTO rate_is;

      IF get_exchange_rate%NOTFOUND
      THEN
         rate_is := 0;
      END IF;

      RETURN NVL (rate_is, 0);
   END;

   FUNCTION where_clause (i_license_in_out IN VARCHAR2, i_period IN DATE)
      RETURN VARCHAR2
   IS
      l_in_out   VARCHAR2 (100);
   BEGIN
      IF (i_license_in_out = 'In')
      THEN
         l_in_out :=
            ' And lic_start<= i_period
And lic_end >= to_char(last_day(i_period,''DD-MON-YYYY'')';
      END IF;

      IF (i_license_in_out = 'Out')
      THEN
         l_in_out :=
            ' And lic_start >  i_period
OR lic_end < TO_CHAR(LAST_DAY(i_period),''DD-MON-YYYY'')';
      END IF;

      IF (i_license_in_out = 'Both')
      THEN
         l_in_out := ' ';
      END IF;

      RETURN l_in_out;
   END;

   FUNCTION month_end_rate (
      i_month    IN   NUMBER,
      i_year     IN   NUMBER,
      i_lic_no   IN   fid_license.lic_number%TYPE
   )
      RETURN DATE
   IS
      l_rate_date   DATE;
   BEGIN
      SELECT xfm.fmd_rate_date
        INTO l_rate_date
        FROM x_fin_month_defn xfm
       WHERE xfm.fmd_month = i_month
         AND xfm.fmd_year = i_year
         AND xfm.fmd_region IN (
                SELECT fr.reg_id
                  FROM fid_region fr, fid_licensee flee, fid_license fl
                 WHERE fr.reg_id(+) = flee.lee_split_region
                   AND flee.lee_number = fl.lic_lee_number
                   AND fl.lic_number = i_lic_no)
         AND xfm.fmd_mon_end_type = 'FINAL';

      RETURN l_rate_date;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_rate_date := NULL;
         RETURN l_rate_date;
      WHEN OTHERS
      THEN
         l_rate_date := NULL;
         RETURN l_rate_date;
   END;

   FUNCTION month_end_rate_regionwise (
      i_month         IN   NUMBER,
      i_year          IN   NUMBER,
      i_region_code   IN   fid_region.reg_code%TYPE
   )
      RETURN DATE
   IS
      l_rate_date   DATE;
   BEGIN
      SELECT xfm.fmd_rate_date
        INTO l_rate_date
        FROM x_fin_month_defn xfm
       WHERE xfm.fmd_month = i_month
         AND xfm.fmd_year = i_year
         AND xfm.fmd_region = (SELECT fr.reg_id
                                 FROM fid_region fr
                                WHERE fr.reg_code = i_region_code)
         AND xfm.fmd_mon_end_type = 'FINAL';

      RETURN l_rate_date;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_rate_date := NULL;
         RETURN l_rate_date;
      WHEN OTHERS
      THEN
         l_rate_date := NULL;
         RETURN l_rate_date;
   END;

   FUNCTION license_region (i_lic_no IN fid_license.lic_number%TYPE)
      RETURN VARCHAR2
   AS
      l_reg_code   fid_region.reg_code%TYPE;
   BEGIN
      SELECT fr.reg_code
        INTO l_reg_code
        FROM fid_region fr, fid_licensee flee, fid_license fl
       WHERE fr.reg_id(+) = flee.lee_split_region
         AND flee.lee_number = fl.lic_lee_number
         AND fl.lic_number = i_lic_no;

      RETURN l_reg_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_reg_code := NULL;
         RETURN l_reg_code;
      WHEN OTHERS
      THEN
         l_reg_code := NULL;
         RETURN l_reg_code;
   END;

END PKG_FIN_MNET_PRE_PAY_MV_RPT;
/