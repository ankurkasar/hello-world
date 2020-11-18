create or replace PACKAGE PKG_FIN_MNET_OUT_LIAB_RPT
AS
   TYPE fin_payment_cursor IS REF CURSOR;

   PROCEDURE prc_fin_fee_liab_search (
      i_report_type         IN       VARCHAR2,
      i_calculate_summary   IN       VARCHAR2,
      i_com_short_name      IN       fid_company.com_short_name%TYPE,
      i_lic_type            IN       fid_license.lic_type%TYPE,
      i_lee_short_name      IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code     IN       fid_license.lic_budget_code%TYPE,
      i_co_short_name       IN       fid_company.com_short_name%TYPE,
      i_con_short_name      IN       fid_contract.con_short_name%TYPE,
      i_licenses_in_out     IN       VARCHAR2,
      i_include_zeros       IN       VARCHAR2,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      i_type                IN       VARCHAR2,
      -- for a period or Consolidated
      i_report_sub_type     IN       VARCHAR2,                      --4 types
      i_rate_type           IN       VARCHAR2,            -- M rate or R rate
      i_from_date           IN       DATE,                      --period from
      i_to_date             IN       DATE,                       -- period to
      --Dev2: Pure Finance :End
      i_period              IN       DATE,                    -- "As of" date
      i_reg_code            IN       fid_region.reg_code%TYPE,
      o_fin_payment         OUT      pkg_fin_mnet_out_liab_rpt.fin_payment_cursor
   );

   FUNCTION get_exchange_rate (
      i_lic_type              IN   fid_license.lic_type%TYPE,
      i_lic_currency          IN   fid_license.lic_currency%TYPE,
      i_lic_number            IN   fid_license.lic_number%TYPE,
      i_lsl_number            IN   NUMBER,
      i_period                IN   DATE,
      i_v_go_live_date        IN   DATE,
      i_ter_cur_code          IN   fid_territory.ter_cur_code%TYPE,
      i_l_last_day            IN   DATE,
      i_l_rsa_ratedate        IN   DATE,
      i_report_sub_type       IN   VARCHAR2,
      i_rate_type             IN   VARCHAR2,
      i_rat_rate              IN   NUMBER,
      i_l_afr_ratedate        IN   DATE,
      i_calc_paid_liability   IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION get_exchange_rate_lsd (
      i_lic_currency     IN   fid_license.lic_currency%TYPE,
      i_lic_number       IN   fid_license.lic_number%TYPE,
      i_lsl_number       IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_period           IN   DATE,
      i_lic_start_rate   IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION calc_paid_liability (
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_lsl_number     IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_period         IN   DATE
   )
      RETURN NUMBER;

   FUNCTION calc_local_liability (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_period       IN   DATE,
	  i_lsl_number   IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION calc_local_liability1 (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_lsl_number   IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_liab_amt     IN   NUMBER,
      i_rate         IN   NUMBER,
      i_lic_start    IN   fid_license.lic_start%TYPE,
      i_period       IN   DATE
   )
      RETURN NUMBER;

   FUNCTION calc_liab_local_amount (
      i_lic_number            IN   fid_license.lic_number%TYPE,
      i_lsl_number            IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_rate                  IN   NUMBER,
      i_calc_paid_liability   IN   NUMBER,
      i_v_go_live_date        IN   DATE,
      i_period                IN   DATE
   )
      RETURN NUMBER;

   PROCEDURE prc_fin_fee_liab_summary (
      i_report_type       IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,
      i_type              IN       VARCHAR2,  -- for a period or Consolidated
      i_report_sub_type   IN       VARCHAR2,                        --4 types
      o_fin_payment       OUT      pkg_fin_mnet_out_liab_rpt.fin_payment_cursor
   );

   PROCEDURE prc_fin_fee_liab_exp_to_exl (
      i_report_type         IN       VARCHAR2,
      i_calculate_summary   IN       VARCHAR2,
      i_com_short_name      IN       fid_company.com_short_name%TYPE,
      i_lic_type            IN       fid_license.lic_type%TYPE,
      i_lee_short_name      IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code     IN       fid_license.lic_budget_code%TYPE,
      i_co_short_name       IN       fid_company.com_short_name%TYPE,
      i_con_short_name      IN       fid_contract.con_short_name%TYPE,
      i_licenses_in_out     IN       VARCHAR2,
      i_include_zeros       IN       VARCHAR2,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      i_type                IN       VARCHAR2,
      -- for a period or Consolidated
      i_report_sub_type     IN       VARCHAR2,                      --4 types
      i_rate_type           IN       VARCHAR2,            -- M rate or R rate
      i_from_date           IN       DATE,                      --period from
      i_to_date             IN       DATE,                       -- period to
      --Dev2: Pure Finance :End
      i_period              IN       DATE,                    -- "As of" date
      i_reg_code            IN       fid_region.reg_code%TYPE,    --For Split
      o_fin_payment         OUT      pkg_fin_mnet_out_liab_rpt.fin_payment_cursor
   );

   PROCEDURE prc_fee_liab_exp_paymonth_per (
      i_report_type         IN       VARCHAR2,
      i_calculate_summary   IN       VARCHAR2,
      i_com_short_name      IN       fid_company.com_short_name%TYPE,
      i_lic_type            IN       fid_license.lic_type%TYPE,
      i_lee_short_name      IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code     IN       fid_license.lic_budget_code%TYPE,
      i_co_short_name       IN       fid_company.com_short_name%TYPE,
      i_con_short_name      IN       fid_contract.con_short_name%TYPE,
      i_licenses_in_out     IN       VARCHAR2,
      i_include_zeros       IN       VARCHAR2,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      i_type                IN       VARCHAR2,
      -- for a period or Consolidated
      i_report_sub_type     IN       VARCHAR2,                      --4 types
      i_rate_type           IN       VARCHAR2,            -- M rate or R rate
      i_from_date           IN       DATE,                      --period from
      i_to_date             IN       DATE,                       -- period to
      --Dev2: Pure Finance :End
      i_period              IN       DATE,
      i_reg_code            IN       fid_region.reg_code%TYPE,    --For Split
      o_fin_paymonth_per    OUT      pkg_fin_mnet_out_liab_rpt.fin_payment_cursor
   );
END PKG_FIN_MNET_OUT_LIAB_RPT;
/
create or replace PACKAGE BODY PKG_FIN_MNET_OUT_LIAB_RPT
AS
   PROCEDURE prc_fin_fee_liab_search (
      i_report_type         IN       VARCHAR2,
      i_calculate_summary   IN       VARCHAR2,
      i_com_short_name      IN       fid_company.com_short_name%TYPE,
      i_lic_type            IN       fid_license.lic_type%TYPE,
      i_lee_short_name      IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code     IN       fid_license.lic_budget_code%TYPE,
      i_co_short_name       IN       fid_company.com_short_name%TYPE,
      i_con_short_name      IN       fid_contract.con_short_name%TYPE,
      i_licenses_in_out     IN       VARCHAR2,
      i_include_zeros       IN       VARCHAR2,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      i_type                IN       VARCHAR2,
      -- for a period or Consolidated
      i_report_sub_type     IN       VARCHAR2,                      --4 types
      i_rate_type           IN       VARCHAR2,            -- M rate or R rate
      i_from_date           IN       DATE,                      --period from
      i_to_date             IN       DATE,                       -- period to
      --Dev2: Pure Finance :End
      i_period              IN       DATE,                    -- "As of" date
      i_reg_code            IN       fid_region.reg_code%TYPE,
      o_fin_payment         OUT      pkg_fin_mnet_out_liab_rpt.fin_payment_cursor
   )
   AS
      l_period            VARCHAR2 (20);
      temp_period         VARCHAR2 (20);
      last_date           VARCHAR2 (20);
      first_date          VARCHAR2 (20);
      liab_summary_date   VARCHAR2 (20);
      spa_value_is        VARCHAR2 (5);
      l_temp_period       DATE;
      l_start             DATE;
      l_end               DATE;
      l_row_count         NUMBER;
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      l_year              NUMBER;
      l_month             NUMBER;
      l_last_day          DATE;
      l_first_day         DATE;
      l_rsa_ratedate      DATE;
      l_afr_ratedate      DATE;
      v_go_live_date      DATE;
      l_disc_rate         NUMBER;
      l_gtt_count         NUMBER;
      l_trc_query         VARCHAR2 (500);
      
      l_con_number        NUMBER;
			
			l_fin_i_live_date 	DATE := x_fnc_get_fin_i_live_date; --Added [Jawahar.Garg]FIN DEV PHASE-I
   BEGIN
      SELECT TO_CHAR (i_period, 'RRRRMM')
        INTO temp_period
        FROM DUAL;

      SELECT spa_value
        INTO spa_value_is
        FROM fid_system_parm
       WHERE spa_id = 'REPORT_INSERT';

      SELECT TO_CHAR (i_period, 'YYYY.MM')
        INTO liab_summary_date
        FROM DUAL;

      SELECT TRUNC (i_period, 'MON'), TRUNC (LAST_DAY (i_period))
        INTO l_start, l_end
        FROM DUAL;

      DBMS_OUTPUT.put_line ('l_start is - : -' || l_start);

--Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
--Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

--Dev2: Pure Finance :End
      l_month := LPAD (TO_NUMBER (TO_CHAR (i_period, 'MM')), 2, 0);
      l_year := TO_NUMBER (TO_CHAR (i_period, 'YYYY'));

--[last day of to_date input parameter for repiort type for a period]
      SELECT LAST_DAY (i_to_date)
        INTO l_last_day
        FROM DUAL;

--[first day  of from_date input parameter for report type "for a period"]
      SELECT ADD_MONTHS (LAST_DAY (i_from_date), -1) + 1
        INTO l_first_day
        FROM DUAL;

------------------Calculate Rate Date ---------------------------------------------------------------------------
      IF UPPER (i_reg_code) = 'RSA'
      THEN
         BEGIN
            SELECT xfmd.fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn xfmd, fid_region fr
             WHERE xfmd.fmd_month = l_month
               AND xfmd.fmd_year = l_year
               AND fr.reg_id = xfmd.fmd_region
               AND UPPER (xfmd.fmd_mon_end_type) = 'FINAL'
               AND UPPER (fr.reg_code) = i_reg_code;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;
      ELSIF UPPER (i_reg_code) = 'AFR'
      THEN
         BEGIN
            SELECT xfmd.fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn xfmd, fid_region fr
             WHERE xfmd.fmd_month = l_month
               AND xfmd.fmd_year = l_year
               AND fr.reg_id = fmd_region
               AND UPPER (xfmd.fmd_mon_end_type) = 'FINAL'
               AND UPPER (fr.reg_code) = i_reg_code;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_afr_ratedate := NULL;
         END;
      ELSE
         BEGIN
            SELECT xfmd.fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn xfmd, fid_region fr
             WHERE xfmd.fmd_month = l_month
               AND xfmd.fmd_year = l_year
               AND fr.reg_id = fmd_region
               AND UPPER (xfmd.fmd_mon_end_type) = 'FINAL'
               AND UPPER (fr.reg_code) = 'RSA';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;

         BEGIN
            SELECT xfmd.fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn xfmd, fid_region fr
             WHERE xfmd.fmd_month = l_month
               AND xfmd.fmd_year = l_year
               AND fr.reg_id = fmd_region
               AND UPPER (xfmd.fmd_mon_end_type) = 'FINAL'
               AND UPPER (fr.reg_code) = 'AFR';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_afr_ratedate := NULL;
         END;
      END IF;
			
----------------------------------------------------------------------------
-- TO SELECT DISCOUNT RATE - for specific month and year
      BEGIN
         SELECT drm_disc_per_anl
           INTO l_disc_rate
           FROM x_fin_disc_rate
          WHERE drm_year = l_year AND drm_month = LPAD (l_month, 2, 0);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_disc_rate := NULL;
      END;

      IF nvl(i_con_short_name,'%') <> '%'
      THEN
        BEGIN
           SELECT CON_NUMBER
             INTO l_con_number
             FROM fid_contract
            WHERE con_short_name = i_con_short_name;
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
             l_con_number := NULL;
        END;
      ELSE
        l_con_number := NULL;
      END IF;
      
      l_trc_query := 'TRUNCATE TABLE x_fin_subledger_arch';

      EXECUTE IMMEDIATE l_trc_query;
      INSERT      /*+APPEND */INTO x_fin_subledger_arch
                        (lis_lic_number, lis_lsl_number, lis_con_forecast,
                         liab_pv_adj)
               SELECT   lis_lic_number, lis_lsl_number,
                        ROUND (SUM (lis_con_fc_imu), 2),
                        ROUND (SUM (lis_pv_con_fc_emu)
                               - SUM (lis_pv_con_liab_ac_emu),
                               2
                              )
                  FROM x_mv_subledger_data mv1
                  WHERE lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'))
                  and lic_con_number = NVL(l_con_number,lic_con_number)
                  AND (
                       --Before Finance Dev Phase I Go Live Date
                       ( 
                          lic_acct_date BETWEEN DECODE (i_type, 'P', l_first_day, lic_acct_date ) AND DECODE (i_type, 'P', l_last_day, l_end ) 
                          AND i_period < l_fin_i_live_date
                       )
                         OR
                       --After Finance Dev Phase I Go Live Date
                       ( i_period >= l_fin_i_live_date
                         AND lic_acct_date BETWEEN DECODE (i_type, 'P', l_first_day, lic_acct_date ) AND DECODE (i_type, 'P', l_last_day, l_end )
                         AND NOT EXISTS (
                                           SELECT lsh_lic_number
                                           FROM(
                                               SELECT lsh_lic_number,lsh_lic_status,
                                                  DENSE_RANK() OVER(PARTITION BY LSH_LIC_NUMBER,LSH_STATUS_YYYYMM ORDER BY LSH_STATUS_YYYYMM DESC)RN
                                                  FROM X_LIC_STATUS_HISTORY
                                                  WHERE LSH_STATUS_YYYYMM <= TO_NUMBER(TO_CHAR(i_period,'RRRRMM'))
                                                )WHERE RN = 1
                                           AND lsh_lic_status = 'C'
                                           AND lsh_lic_number = lis_lic_number
                                           UNION ALL
                                           select mv2.lis_lic_number
                                           from x_mv_subledger_data mv2
                                           where (lis_lic_status = 'C'
                                                  or lis_lic_start > LAST_DAY(i_period))
                                           and mv1.lis_lic_number = mv2.lis_lic_number
                                           AND lis_yyyymm_num = TO_NUMBER(TO_CHAR(i_period,'RRRRMM'))
                                        )
                      )
                    )
               GROUP BY lis_lic_number, lis_lsl_number;

      
      COMMIT;

      IF i_include_zeros = 'Y'
      THEN
         OPEN o_fin_payment FOR
            SELECT   ter_cur_code, com_number, channel_company,
                     com_short_name1, lic_currency, lic_type, lee_short_name,
                     lic_budget_code, com_short_name, con_short_name,
                     com_ter_code, lic_number, con_number, lic_gen_refno,
                     lic_amort_code, lic_price, lsl_number, rat_rate,
                     exchange_rate, acct, start_date, end_date, d_programme,
                     d_license_fee, d_paid_amount, d_lia_amount, liab_pv_adj,
                     liab_closing, d_liab_local_amount, loc_liab_pv_adj,
                     loc_liab_closing, reg_code, rsa_ratedate, rsa_spotrate,
                     afr_ratedate, afr_spotrate, discountrate
                FROM (SELECT ter_cur_code, com_number, channel_company,
                             com_short_name1, lic_currency, lic_type,
                             lee_short_name, lee_number, lic_budget_code,
                             com_short_name, con_short_name, com_ter_code,
                             lic_number, con_number, lic_gen_refno,
                             lic_amort_code,lic_price, lsl_number, rat_rate,
                             acct, start_date, end_date, d_programme,
                             d_license_fee, d_paid_amount, reg_code,
                             liab_pv_adj,
                             (liab_pv_adj * exchange_rate) loc_liab_pv_adj,
                             ((d_license_fee - d_paid_amount) + liab_pv_adj
                             ) liab_closing,
                             (  ((d_license_fee - d_paid_amount) + liab_pv_adj
                                )
                              * exchange_rate
                             ) loc_liab_closing,
                             exchange_rate,
                             pkg_fin_mnet_out_liab_rpt.calc_liab_local_amount
                                       (lic_number,
                                        lsl_number,
                                        exchange_rate,
                                        (d_license_fee - d_paid_amount
                                        ),
                                        v_go_live_date,
                                        i_period
                                       ) d_liab_local_amount,
                             (d_license_fee - d_paid_amount) d_lia_amount,
                             l_rsa_ratedate rsa_ratedate,
                             DECODE
                                (i_rate_type,
                                 'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                l_rsa_ratedate
                                                               ),
                                 'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                (lic_currency,
                                                                 ter_cur_code,
                                                                 l_last_day
                                                                )
                                ) rsa_spotrate,
                             l_afr_ratedate afr_ratedate,
                             DECODE
                                (i_rate_type,
                                 'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                l_afr_ratedate
                                                               ),
                                 'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                (lic_currency,
                                                                 ter_cur_code,
                                                                 l_last_day
                                                                )
                                ) afr_spotrate,
                             l_disc_rate discountrate
                        FROM (SELECT ter_cur_code, com_number,
                                     channel_company, com_short_name1,
                                     lic_currency, lic_type, lee_short_name,
                                     lee_number, lic_budget_code,
                                     com_short_name, con_short_name,
                                     com_ter_code, con_number, lic_number,
                                     lic_amort_code, lic_gen_refno, lic_price,
                                     lsl_number, rat_rate, acct, start_date,
                                     end_date, d_programme, d_license_fee,
                                     d_paid_amount, reg_code, liab_pv_adj,
                                     pkg_fin_mnet_out_liab_rpt.get_exchange_rate
                                            (lic_type,
                                             lic_currency,
                                             lic_number,
                                             lsl_number,
                                             i_period,
                                             v_go_live_date,
                                             ter_cur_code,
                                             l_last_day,
                                             l_rsa_ratedate,
                                             i_report_sub_type,
                                             i_rate_type,
                                             rat_rate,
                                             l_afr_ratedate,
                                             (d_license_fee - d_paid_amount
                                             )
                                            ) exchange_rate
                                FROM (SELECT   ft.ter_cur_code,
                                               afc.com_number,
                                               afc.com_name channel_company,
                                               afc.com_short_name
                                                              com_short_name1,
                                               fl.lic_currency, fl.lic_type,
                                               flee.lee_short_name,
                                               flee.lee_number,
                                               fl.lic_budget_code,
                                               bfc.com_short_name
                                                               com_short_name,
                                               fcon.con_short_name,
                                               afc.com_ter_code,
                                               fcon.con_number, fl.lic_number,
                                               fl.lic_amort_code,
                                               fl.lic_gen_refno,
                                               lsl_lee_price lic_price,
                                               xfsl.lsl_number,
                                               NVL (fer.rat_rate, 0) rat_rate,
                                               TO_CHAR
                                                      (fl.lic_acct_date,
                                                       'YYYY.MM'
                                                      ) acct,
                                               TO_CHAR
                                                    (fl.lic_start,
                                                     'DDMonYYYY'
                                                    ) start_date,
                                               TO_CHAR (lic_end,
                                                        'DDMonYYYY'
                                                       ) end_date,
                                               fg.gen_title d_programme,
                                               (SELECT xfsa.lis_con_forecast
                                                  FROM x_fin_subledger_arch xfsa
                                                 WHERE xfsa.lis_lic_number =
                                                                 fl.lic_number
                                                   AND xfsa.lis_lsl_number =
                                                               xfsl.lsl_number)
                                                                d_license_fee,
                                               (SELECT NVL
                                                          (SUM (fp.pay_amount),
                                                           0
                                                          )
                                                  FROM fid_payment fp,
                                                       fid_payment_type fpt
                                                 WHERE fpt.pat_code =
                                                                   fp.pay_code
                                                   AND fp.pay_lic_number =
                                                                 fl.lic_number
                                                   AND fp.pay_con_number =
                                                               fcon.con_number
                                                   AND fp.pay_cur_code =
                                                               fl.lic_currency
                                                   AND fp.pay_lsl_number =
                                                               xfsl.lsl_number
                                                   AND TRUNC
                                                          (TO_DATE
                                                              (TO_CHAR
                                                                  (fp.pay_date,
                                                                   'DD-MON-RRRR'
                                                                  ),
                                                               'DD-MON-RRRR'
                                                              )
                                                          ) <=
                                                          TRUNC
                                                             (TO_DATE
                                                                 (TO_CHAR
                                                                     (TO_DATE
                                                                         (l_end,
                                                                          'DD-MON-RRRR'
                                                                         ),
                                                                      'DD-MON-RRRR'
                                                                     ),
                                                                  'DD-MON-RRRR'
                                                                 )
                                                             )
                                                   AND fp.pay_status IN
                                                                   ('P', 'I')
                                                   AND fpt.pat_group = 'F')
                                                                d_paid_amount,
                                               fr.reg_code,
                                               (SELECT liab_pv_adj
                                                  FROM x_fin_subledger_arch xfsa
                                                 WHERE xfsa.lis_lic_number =
                                                                 fl.lic_number
                                                   AND xfsa.lis_lsl_number =
                                                               xfsl.lsl_number)
                                                                  liab_pv_adj
                                          FROM fid_company afc,
                                               fid_company bfc,
                                               fid_contract fcon,
                                               fid_licensee flee,
                                               fid_license fl,
                                               fid_general fg,
                                               x_fin_lic_sec_lee xfsl,
                                               fid_territory ft,
                                               fid_exchange_rate fer,
                                               fid_region fr
                                         WHERE afc.com_short_name LIKE
                                                              i_com_short_name
                                           AND afc.com_type IN ('CC', 'BC')
                                           AND bfc.com_number =
                                                           fcon.con_com_number
                                           AND bfc.com_short_name LIKE
                                                               i_co_short_name
                                           AND fcon.con_short_name LIKE
                                                              i_con_short_name
                                           AND flee.lee_cha_com_number =
                                                                afc.com_number
                                           AND flee.lee_short_name LIKE
                                                              i_lee_short_name
                                           AND fcon.con_number = fl.lic_con_number
                                           AND fl.lic_type LIKE i_lic_type
                                           AND fl.lic_budget_code LIKE i_lic_budget_code
                                           AND fl.lic_status NOT IN ('B', 'F', 'T')
                                           AND EXISTS (
                                                  SELECT NULL
                                                    FROM x_fin_subledger_arch xfsa
                                                   WHERE xfsa.lis_lic_number = fl.lic_number
                                                     AND xfsa.lis_lsl_number = xfsl.lsl_number)
                                           AND fg.gen_refno = fl.lic_gen_refno
                                           AND ft.ter_code = afc.com_ter_code
                                           AND fer.rat_cur_code = fl.lic_currency
                                           AND fer.rat_cur_code_2 = ft.ter_cur_code
                                           AND fr.reg_id(+) = flee.lee_split_region
                                           AND fr.reg_code LIKE i_reg_code
                                           AND fl.lic_number =  xfsl.lsl_lic_number
                                           AND flee.lee_number = xfsl.lsl_lee_number
                                      GROUP BY ft.ter_cur_code,
                                               afc.com_number,
                                               afc.com_name,
                                               afc.com_short_name,
                                               fl.lic_currency,
                                               fl.lic_type,
                                               flee.lee_short_name,
                                               flee.lee_number,
                                               fl.lic_budget_code,
                                               bfc.com_short_name,
                                               fcon.con_short_name,
                                               afc.com_ter_code,
                                               fcon.con_number,
                                               fl.lic_number,
                                               fl.lic_amort_code,
                                               fl.lic_gen_refno,
                                               xfsl.lsl_lee_price,
                                               NVL (fer.rat_rate, 0),
                                               TO_CHAR (fl.lic_acct_date,'YYYY.MM'),
                                               TO_CHAR (fl.lic_start,'DDMonYYYY'),
                                               TO_CHAR (fl.lic_end,'DDMonYYYY'),
                                               fg.gen_title,
                                               fr.reg_code,
                                               xfsl.lsl_number)))
            ORDER BY channel_company,
                     lic_currency,
                     lic_type,
                     lee_short_name,
                     lic_budget_code,
                     com_short_name,
                     con_short_name,
                     lic_number,
                     reg_code;
      ELSE
         OPEN o_fin_payment FOR
            SELECT   ter_cur_code, com_number, channel_company,
                     com_short_name1, lic_currency, lic_type, lee_short_name,
                     lic_budget_code, com_short_name, con_short_name,
                     com_ter_code, lic_number, con_number, lic_gen_refno,
                     lic_amort_code, lic_price, exchange_rate, discountrate,
                     acct, start_date, end_date, d_programme, d_license_fee,
                     d_paid_amount, d_lia_amount, liab_pv_adj, liab_closing,
                     d_liab_local_amount, loc_liab_pv_adj, loc_liab_closing,
                     reg_code, rsa_ratedate, rsa_spotrate, afr_ratedate,
                     afr_spotrate
                FROM (SELECT ter_cur_code, com_number, channel_company,
                             com_short_name1, lic_currency, lic_type,
                             lee_short_name, lee_number, lic_budget_code,
                             com_short_name, con_short_name, com_ter_code,
                             lic_number, con_number, lic_gen_refno,
                             lic_amort_code,lic_price, lsl_number, acct,
                             start_date, end_date, d_programme, d_license_fee,
                             d_paid_amount, reg_code, liab_pv_adj,
                             (liab_pv_adj * exchange_rate) loc_liab_pv_adj,
                             ((d_license_fee - d_paid_amount) + liab_pv_adj
                             ) liab_closing,
                             (  ((d_license_fee - d_paid_amount) + liab_pv_adj
                                )
                              * exchange_rate
                             ) loc_liab_closing,
                             exchange_rate,
                             pkg_fin_mnet_out_liab_rpt.calc_liab_local_amount
                                       (lic_number,
                                        lsl_number,
                                        exchange_rate,
                                        (d_license_fee - d_paid_amount
                                        ),
                                        v_go_live_date,
                                        i_period
                                       ) d_liab_local_amount,
                             (d_license_fee - d_paid_amount) d_lia_amount,
                             l_rsa_ratedate rsa_ratedate,
                             DECODE
                                (i_rate_type,
                                 'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                l_rsa_ratedate
                                                               ),
                                 'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                (lic_currency,
                                                                 ter_cur_code,
                                                                 l_last_day
                                                                )
                                ) rsa_spotrate,
                             l_afr_ratedate afr_ratedate,
                             DECODE
                                (i_rate_type,
                                 'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                l_afr_ratedate
                                                               ),
                                 'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                (lic_currency,
                                                                 ter_cur_code,
                                                                 l_last_day
                                                                )
                                ) afr_spotrate,
                             l_disc_rate discountrate
                        FROM (SELECT ter_cur_code, com_number,
                                     channel_company, com_short_name1,
                                     lic_currency, lic_type, lee_short_name,
                                     lee_number, lic_budget_code,
                                     com_short_name, con_short_name,
                                     com_ter_code, con_number, lic_number,
                                     lic_amort_code, lic_gen_refno, lic_price,
                                     lsl_number, acct, start_date, end_date,
                                     d_programme, d_license_fee,
                                     d_paid_amount, reg_code, liab_pv_adj,
                                     pkg_fin_mnet_out_liab_rpt.get_exchange_rate
                                            (lic_type,
                                             lic_currency,
                                             lic_number,
                                             lsl_number,
                                             i_period,
                                             v_go_live_date,
                                             ter_cur_code,
                                             l_last_day,
                                             l_rsa_ratedate,
                                             i_report_sub_type,
                                             i_rate_type,
                                             rat_rate,
                                             l_afr_ratedate,
                                             (d_license_fee - d_paid_amount
                                             )
                                            ) exchange_rate
                                FROM (SELECT   ft.ter_cur_code,
                                               afc.com_number,
                                               afc.com_name channel_company,
                                               afc.com_short_name
                                                              com_short_name1,
                                               fl.lic_currency, fl.lic_type,
                                               flee.lee_short_name,
                                               flee.lee_number,
                                               fl.lic_budget_code,
                                               bfc.com_short_name
                                                               com_short_name,
                                               fcon.con_short_name,
                                               afc.com_ter_code,
                                               fcon.con_number, fl.lic_number,
                                               fl.lic_amort_code,
                                               fl.lic_gen_refno,
                                               lsl_lee_price lic_price,
                                               xfsl.lsl_number,
                                               NVL (fer.rat_rate, 0) rat_rate,
                                               TO_CHAR
                                                      (fl.lic_acct_date,
                                                       'YYYY.MM'
                                                      ) acct,
                                               TO_CHAR
                                                    (fl.lic_start,
                                                     'DDMonYYYY'
                                                    ) start_date,
                                               TO_CHAR (fl.lic_end,
                                                        'DDMonYYYY'
                                                       ) end_date,
                                               fg.gen_title d_programme,
                                               (SELECT xfsa.lis_con_forecast
                                                  FROM x_fin_subledger_arch xfsa
                                                 WHERE xfsa.lis_lic_number =
                                                                 fl.lic_number
                                                   AND xfsa.lis_lsl_number =
                                                               xfsl.lsl_number)
                                                                d_license_fee,
                                               (SELECT NVL
                                                          (SUM (fp.pay_amount),
                                                           0
                                                          )
                                                  FROM fid_payment fp,
                                                       fid_payment_type fpt
                                                 WHERE fpt.pat_code =
                                                                   fp.pay_code
                                                   AND fp.pay_lic_number =
                                                                 fl.lic_number
                                                   AND fp.pay_con_number =
                                                               fcon.con_number
                                                   AND fp.pay_cur_code =
                                                               fl.lic_currency
                                                   AND fp.pay_lsl_number =
                                                               xfsl.lsl_number
                                                   AND TRUNC
                                                          (TO_DATE
                                                              (TO_CHAR
                                                                  (fp.pay_date,
                                                                   'DD-MON-RRRR'
                                                                  ),
                                                               'DD-MON-RRRR'
                                                              )
                                                          ) <=
                                                          TRUNC
                                                             (TO_DATE
                                                                 (TO_CHAR
                                                                     (TO_DATE
                                                                         (l_end,
                                                                          'DD-MON-RRRR'
                                                                         ),
                                                                      'DD-MON-RRRR'
                                                                     ),
                                                                  'DD-MON-RRRR'
                                                                 )
                                                             )
                                                   AND fp.pay_status IN
                                                                   ('P', 'I')
                                                   AND fpt.pat_group = 'F')
                                                                d_paid_amount,
                                               fr.reg_code,
                                               (SELECT liab_pv_adj
                                                  FROM x_fin_subledger_arch
                                                 WHERE lis_lic_number =
                                                                    lic_number
                                                   AND lis_lsl_number =
                                                                    lsl_number)
                                                                  liab_pv_adj
                                          FROM fid_company afc,
                                               fid_company bfc,
                                               fid_contract fcon,
                                               fid_licensee flee,
                                               fid_license fl,
                                               fid_general fg,
                                               x_fin_lic_sec_lee xfsl,
                                               fid_territory ft,
                                               fid_exchange_rate fer,
                                               fid_region fr
                                         WHERE afc.com_short_name LIKE
                                                              i_com_short_name
                                           AND afc.com_type IN ('CC', 'BC')
                                           AND bfc.com_number = fcon.con_com_number
                                           AND bfc.com_short_name  LIKE  i_co_short_name
                                           AND fcon.con_short_name LIKE i_con_short_name
                                           AND flee.lee_cha_com_number = afc.com_number
                                           AND flee.lee_short_name LIKE i_lee_short_name
                                           AND fcon.con_number =fl.lic_con_number
                                           AND fl.lic_type LIKE i_lic_type                                                                                  
                                           AND fl.lic_budget_code LIKE i_lic_budget_code           
                                           AND fl.lic_status NOT IN ('B', 'F', 'T')
                                           AND EXISTS (
                                                  SELECT NULL
                                                    FROM x_fin_subledger_arch
                                                   WHERE lis_lic_number =
                                                                    lic_number
                                                     AND lis_lsl_number =
                                                                    lsl_number)
                                           AND fg.gen_refno = fl.lic_gen_refno
                                           AND ft.ter_code = afc.com_ter_code
                                           AND fer.rat_cur_code =
                                                               fl.lic_currency
                                           AND fer.rat_cur_code_2 =
                                                               ft.ter_cur_code
                                           AND fr.reg_id(+) =
                                                         flee.lee_split_region
                                           AND fr.reg_code LIKE i_reg_code
                                           AND fl.lic_number =
                                                           xfsl.lsl_lic_number
                                           AND flee.lee_number =
                                                           xfsl.lsl_lee_number
                                      GROUP BY ft.ter_cur_code,
                                               afc.com_number,
                                               afc.com_name,
                                               afc.com_short_name,
                                               fl.lic_currency,
                                               fl.lic_type,
                                               flee.lee_short_name,
                                               flee.lee_number,
                                               fl.lic_budget_code,
                                               bfc.com_short_name,
                                               fcon.con_short_name,
                                               afc.com_ter_code,
                                               fcon.con_number,
                                               fl.lic_number,
                                               fl.lic_amort_code,
                                               fl.lic_gen_refno,
                                               xfsl.lsl_lee_price,
                                               NVL (fer.rat_rate, 0),
                                               TO_CHAR (fl.lic_acct_date,
                                                        'YYYY.MM'
                                                       ),
                                               TO_CHAR (fl.lic_start,
                                                        'DDMonYYYY'
                                                       ),
                                               TO_CHAR (fl.lic_end,
                                                        'DDMonYYYY'
                                                       ),
                                               fg.gen_title,
                                               fr.reg_code,
                                               xfsl.lsl_number))
                       WHERE ROUND ((d_license_fee - d_paid_amount), 2) --<> 0
                                                        NOT BETWEEN  -1 AND 1) --FIN_CR . DO NOT DISPLAY RECORD WHICH CONTAIN 1 TO -1 VALUE (Ankur kasar)
            ---to ignore very less liability value
            ORDER BY channel_company,
                     lic_currency,
                     lic_type,
                     lee_short_name,
                     lic_budget_code,
                     com_short_name,
                     con_short_name,
                     lic_number,
                     reg_code;
      END IF;

      IF (UPPER (i_calculate_summary) = 'Y')
      THEN
         EXECUTE IMMEDIATE ('TRUNCATE TABLE fid_lia_summary');

         IF i_include_zeros = 'Y'
         THEN
            INSERT INTO fid_lia_summary
                        (lii_date, lii_period, lii_inoutlic, lii_reporttype,
                         lii_company, lii_lictype, lii_licensee,
                         lii_budgetcode, lii_supplier, lii_contract,
                         lii_com_short_name, lii_currency, lii_type,
                         lii_lee_short_name, lii_budget_code, lii_reg_code,
                         lii_rate, lii_lic_number, lii_acct_date,
                         lii_start_date, lii_fee_amount, lii_pay_amount,
                         lii_pv_adj, lii_cha_pv_adj, lii_clos_lia,
                         lii_cha_clos_lia, lii_lia_loc_amount)
               SELECT SYSDATE, liab_summary_date, i_licenses_in_out,
                      i_report_type, channel_company, i_lic_type,
                      i_lee_short_name, i_lic_budget_code, i_co_short_name,
                      i_con_short_name, com_short_name, lic_currency,
                      lic_type, lee_short_name, lic_budget_code, reg_code,
                      exchange_rate, lic_number, acct, start_date,
                      d_license_fee, d_paid_amount, liab_pv_adj,
                      loc_liab_pv_adj, liab_closing, loc_liab_closing,
                      d_liab_local_amount
                 FROM (SELECT ter_cur_code, com_number, channel_company,
                              com_short_name1, lic_currency, lic_type,
                              lee_short_name, lee_number, lic_budget_code,
                              com_short_name, con_short_name, com_ter_code,
                              lic_number,lic_price, lsl_number, acct,
                              start_date, end_date, d_programme,
                              d_license_fee, d_paid_amount, reg_code,
                              liab_pv_adj,
                              (liab_pv_adj * exchange_rate) loc_liab_pv_adj,
                              ((d_license_fee - d_paid_amount) + liab_pv_adj
                              ) liab_closing,
                              (  (  (d_license_fee - d_paid_amount)
                                  + liab_pv_adj
                                 )
                               * exchange_rate
                              ) loc_liab_closing,
                              exchange_rate,
                              pkg_fin_mnet_out_liab_rpt.calc_liab_local_amount
                                       (lic_number,
                                        lsl_number,
                                        exchange_rate,
                                        (d_license_fee - d_paid_amount
                                        ),
                                        v_go_live_date,
                                        i_period
                                       ) d_liab_local_amount
                       FROM   (SELECT ter_cur_code, com_number,
                                      channel_company, com_short_name1,
                                      lic_currency, lic_type, lee_short_name,
                                      lee_number, lic_budget_code,
                                      com_short_name, con_short_name,
                                      com_ter_code, con_number, lic_number,
                                      lic_amort_code, lic_gen_refno,
                                      lic_price, lsl_number, acct, start_date,
                                      end_date, d_programme, d_license_fee,
                                      d_paid_amount, reg_code, liab_pv_adj,
                                      pkg_fin_mnet_out_liab_rpt.get_exchange_rate
                                            (lic_type,
                                             lic_currency,
                                             lic_number,
                                             lsl_number,
                                             i_period,
                                             v_go_live_date,
                                             ter_cur_code,
                                             l_last_day,
                                             l_rsa_ratedate,
                                             i_report_sub_type,
                                             i_rate_type,
                                             rat_rate,
                                             l_afr_ratedate,
                                             (d_license_fee - d_paid_amount
                                             )
                                            ) exchange_rate
                                 FROM (SELECT   ft.ter_cur_code,
                                                afc.com_number,
                                                TRIM
                                                   (afc.com_name
                                                   ) channel_company,
                                                TRIM
                                                   (afc.com_short_name
                                                   ) com_short_name1,
                                                fl.lic_currency, fl.lic_type,
                                                flee.lee_short_name,
                                                flee.lee_number,
                                                fl.lic_budget_code,
                                                bfc.com_short_name
                                                               com_short_name,
                                                fcon.con_short_name,
                                                afc.com_ter_code,
                                                fcon.con_number,
                                                fl.lic_number,
                                                fl.lic_amort_code,
                                                fl.lic_gen_refno,
                                                xfsl.lsl_lee_price lic_price,
                                                xfsl.lsl_number,
                                                NVL (fer.rat_rate,
                                                     0) rat_rate,
                                                TO_CHAR
                                                      (fl.lic_acct_date,
                                                       'YYYY.MM'
                                                      ) acct,
                                                TO_CHAR
                                                    (fl.lic_start,
                                                     'DDMonYYYY'
                                                    ) start_date,
                                                TO_CHAR (fl.lic_end,
                                                         'DDMonYYYY'
                                                        ) end_date,
                                                fg.gen_title d_programme,
                                                (SELECT xfsa.lis_con_forecast
                                                   FROM x_fin_subledger_arch xfsa
                                                  WHERE xfsa.lis_lic_number =
                                                                 fl.lic_number
                                                    AND xfsa.lis_lsl_number =
                                                               xfsl.lsl_number)
                                                                d_license_fee,
                                                (SELECT NVL
                                                           (SUM (fp.pay_amount),
                                                            0
                                                           )
                                                   FROM fid_payment fp,
                                                        fid_payment_type fpt
                                                  WHERE fpt.pat_code =
                                                                   fp.pay_code
                                                    AND fp.pay_lic_number =
                                                                 fl.lic_number
                                                    AND fp.pay_con_number =
                                                               fcon.con_number
                                                    AND fp.pay_cur_code =
                                                               fl.lic_currency
                                                    AND fp.pay_lsl_number =
                                                               xfsl.lsl_number
                                                    AND TRUNC
                                                           (TO_DATE
                                                               (TO_CHAR
                                                                   (fp.pay_date,
                                                                    'DD-MON-RRRR'
                                                                   ),
                                                                'DD-MON-RRRR'
                                                               )
                                                           ) <=
                                                           TRUNC
                                                              (TO_DATE
                                                                  (TO_CHAR
                                                                      (TO_DATE
                                                                          (l_end,
                                                                           'DD-MON-RRRR'
                                                                          ),
                                                                       'DD-MON-RRRR'
                                                                      ),
                                                                   'DD-MON-RRRR'
                                                                  )
                                                              )
                                                    AND fp.pay_status IN
                                                                   ('P', 'I')
                                                    AND fpt.pat_group = 'F')
                                                                d_paid_amount,
                                                fr.reg_code,
                                                (SELECT liab_pv_adj
                                                   FROM x_fin_subledger_arch
                                                  WHERE lis_lic_number =
                                                                    lic_number
                                                    AND lis_lsl_number =
                                                                    lsl_number)
                                                                  liab_pv_adj
                                           FROM fid_company afc,
                                                fid_company bfc,
                                                fid_contract fcon,
                                                fid_licensee flee,
                                                fid_license fl,
                                                fid_general fg,
                                                x_fin_lic_sec_lee xfsl,
                                                fid_territory ft,
                                                fid_exchange_rate fer,
                                                fid_region fr
                                          WHERE afc.com_short_name LIKE
                                                              i_com_short_name
                                            AND afc.com_type IN ('CC', 'BC')
                                            AND bfc.com_number =
                                                           fcon.con_com_number
                                            AND bfc.com_short_name LIKE
                                                               i_co_short_name
                                            AND fcon.con_short_name LIKE
                                                              i_con_short_name
                                            AND flee.lee_cha_com_number =
                                                                afc.com_number
                                            AND flee.lee_short_name LIKE
                                                              i_lee_short_name
                                            AND fcon.con_number =
                                                             fl.lic_con_number
                                            AND fl.lic_type LIKE i_lic_type
                                            AND fl.lic_budget_code LIKE
                                                             i_lic_budget_code             
                                            AND fl.lic_status NOT IN
                                                              ('B', 'F', 'T')
                                            AND EXISTS (
                                                   SELECT NULL
                                                     FROM x_fin_subledger_arch
                                                    WHERE lis_lic_number =
                                                                    lic_number
                                                      AND lis_lsl_number =
                                                                    lsl_number)
                                            AND fg.gen_refno =
                                                              fl.lic_gen_refno
                                            AND ft.ter_code = afc.com_ter_code
                                            AND fer.rat_cur_code =
                                                               fl.lic_currency
                                            AND fer.rat_cur_code_2 =
                                                               ft.ter_cur_code
                                            AND fr.reg_id(+) =
                                                         flee.lee_split_region
                                            AND fr.reg_code LIKE i_reg_code
                                            AND fl.lic_number =
                                                           xfsl.lsl_lic_number
                                            AND flee.lee_number =
                                                           xfsl.lsl_lee_number
                                       GROUP BY ft.ter_cur_code,
                                                afc.com_number,
                                                afc.com_name,
                                                afc.com_short_name,
                                                fl.lic_currency,
                                                fl.lic_type,
                                                flee.lee_short_name,
                                                flee.lee_number,
                                                fl.lic_budget_code,
                                                bfc.com_short_name,
                                                fcon.con_short_name,
                                                afc.com_ter_code,
                                                fcon.con_number,
                                                fl.lic_number,
                                                fl.lic_amort_code,
                                                fl.lic_gen_refno,
                                                xfsl.lsl_lee_price,
                                                NVL (fer.rat_rate, 0),
                                                TO_CHAR (fl.lic_acct_date,
                                                         'YYYY.MM'
                                                        ),
                                                TO_CHAR (fl.lic_start,
                                                         'DDMonYYYY'
                                                        ),
                                                TO_CHAR (fl.lic_end,
                                                         'DDMonYYYY'
                                                        ),
                                                fg.gen_title,
                                                fr.reg_code,
                                                xfsl.lsl_number)));
         ELSE
            INSERT INTO fid_lia_summary
                        (lii_date, lii_period, lii_inoutlic, lii_reporttype,
                         lii_company, lii_lictype, lii_licensee,
                         lii_budgetcode, lii_supplier, lii_contract,
                         lii_com_short_name, lii_currency, lii_type,
                         lii_lee_short_name, lii_budget_code, lii_reg_code,
                         lii_rate, lii_lic_number, lii_acct_date,
                         lii_start_date, lii_fee_amount, lii_pay_amount,
                         lii_pv_adj, lii_cha_pv_adj, lii_clos_lia,
                         lii_cha_clos_lia, lii_lia_loc_amount)
               SELECT SYSDATE, liab_summary_date, i_licenses_in_out,
                      i_report_type, channel_company, i_lic_type,
                      i_lee_short_name, i_lic_budget_code, i_co_short_name,
                      i_con_short_name, com_short_name, lic_currency,
                      lic_type, lee_short_name, lic_budget_code, reg_code,
                      exchange_rate, lic_number, acct, start_date,
                      d_license_fee, d_paid_amount, liab_pv_adj,
                      loc_liab_pv_adj, liab_closing, loc_liab_closing,
                      d_liab_local_amount
                 FROM (SELECT ter_cur_code, com_number, channel_company,
                              com_short_name1, lic_currency, lic_type,
                              lee_short_name, lee_number, lic_budget_code,
                              com_short_name, con_short_name, com_ter_code,
                              lic_number,lic_price, lsl_number, acct,
                              start_date, end_date, d_programme,
                              d_license_fee, d_paid_amount, reg_code,
                              liab_pv_adj,
                              (liab_pv_adj * exchange_rate) loc_liab_pv_adj,
                              ((d_license_fee - d_paid_amount) + liab_pv_adj
                              ) liab_closing,
                              (  (  (d_license_fee - d_paid_amount)
                                  + liab_pv_adj
                                 )
                               * exchange_rate
                              ) loc_liab_closing,
                              exchange_rate,
                              pkg_fin_mnet_out_liab_rpt.calc_liab_local_amount
                                       (lic_number,
                                        lsl_number,
                                        exchange_rate,
                                        (d_license_fee - d_paid_amount
                                        ),
                                        v_go_live_date,
                                        i_period
                                       ) d_liab_local_amount
                       FROM   (SELECT ter_cur_code, com_number,
                                      channel_company, com_short_name1,
                                      lic_currency, lic_type, lee_short_name,
                                      lee_number, lic_budget_code,
                                      com_short_name, con_short_name,
                                      com_ter_code, con_number, lic_number,
                                      lic_amort_code, lic_gen_refno,
                                      lic_price, lsl_number, acct, start_date,
                                      end_date, d_programme, d_license_fee,
                                      d_paid_amount, reg_code, liab_pv_adj,
                                      pkg_fin_mnet_out_liab_rpt.get_exchange_rate
                                            (lic_type,
                                             lic_currency,
                                             lic_number,
                                             lsl_number,
                                             i_period,
                                             v_go_live_date,
                                             ter_cur_code,
                                             l_last_day,
                                             l_rsa_ratedate,
                                             i_report_sub_type,
                                             i_rate_type,
                                             rat_rate,
                                             l_afr_ratedate,
                                             (d_license_fee - d_paid_amount
                                             )
                                            ) exchange_rate
                                 FROM (SELECT   ft.ter_cur_code,
                                                afc.com_number,
                                                TRIM
                                                   (afc.com_name
                                                   ) channel_company,
                                                TRIM
                                                   (afc.com_short_name
                                                   ) com_short_name1,
                                                fl.lic_currency, fl.lic_type,
                                                flee.lee_short_name,
                                                flee.lee_number,
                                                fl.lic_budget_code,
                                                bfc.com_short_name
                                                               com_short_name,
                                                fcon.con_short_name,
                                                afc.com_ter_code,
                                                fcon.con_number,
                                                fl.lic_number,
                                                fl.lic_amort_code,
                                                fl.lic_gen_refno,
                                                xfsl.lsl_lee_price lic_price,
                                                xfsl.lsl_number,
                                                NVL (fer.rat_rate,
                                                     0) rat_rate,
                                                TO_CHAR
                                                      (fl.lic_acct_date,
                                                       'YYYY.MM'
                                                      ) acct,
                                                TO_CHAR
                                                    (fl.lic_start,
                                                     'DDMonYYYY'
                                                    ) start_date,
                                                TO_CHAR (fl.lic_end,
                                                         'DDMonYYYY'
                                                        ) end_date,
                                                fg.gen_title d_programme,
                                                (SELECT xfsa.lis_con_forecast
                                                   FROM x_fin_subledger_arch xfsa
                                                  WHERE xfsa.lis_lic_number =
                                                                 fl.lic_number
                                                    AND xfsa.lis_lsl_number =
                                                               xfsl.lsl_number)
                                                                d_license_fee,
                                                (SELECT NVL
                                                           (SUM (fp.pay_amount),
                                                            0
                                                           )
                                                   FROM fid_payment fp,
                                                        fid_payment_type fpt
                                                  WHERE fpt.pat_code =
                                                                   fp.pay_code
                                                    AND fp.pay_lic_number =
                                                                 fl.lic_number
                                                    AND fp.pay_con_number =
                                                               fcon.con_number
                                                    AND fp.pay_cur_code =
                                                               fl.lic_currency
                                                    AND fp.pay_lsl_number =
                                                               xfsl.lsl_number
                                                    AND TRUNC
                                                           (TO_DATE
                                                               (TO_CHAR
                                                                   (fp.pay_date,
                                                                    'DD-MON-RRRR'
                                                                   ),
                                                                'DD-MON-RRRR'
                                                               )
                                                           ) <=
                                                           TRUNC
                                                              (TO_DATE
                                                                  (TO_CHAR
                                                                      (TO_DATE
                                                                          (l_end,
                                                                           'DD-MON-RRRR'
                                                                          ),
                                                                       'DD-MON-RRRR'
                                                                      ),
                                                                   'DD-MON-RRRR'
                                                                  )
                                                              )
                                                    AND fp.pay_status IN
                                                                   ('P', 'I')
                                                    AND fpt.pat_group = 'F')
                                                                d_paid_amount,
                                                fr.reg_code,
                                                (SELECT liab_pv_adj
                                                   FROM x_fin_subledger_arch xfsa
                                                  WHERE xfsa.lis_lic_number =
                                                                 fl.lic_number
                                                    AND xfsa.lis_lsl_number =
                                                               xfsl.lsl_number)
                                                                  liab_pv_adj
                                           FROM fid_company afc,
                                                fid_company bfc,
                                                fid_contract fcon,
                                                fid_licensee flee,
                                                fid_license fl,
                                                fid_general fg,
                                                x_fin_lic_sec_lee xfsl,
                                                fid_territory ft,
                                                fid_exchange_rate fer,
                                                fid_region fr
                                          WHERE afc.com_short_name LIKE
                                                              i_com_short_name
                                            AND afc.com_type IN ('CC', 'BC')
                                            AND bfc.com_number =
                                                           fcon.con_com_number
                                            AND bfc.com_short_name LIKE
                                                               i_co_short_name
                                            AND fcon.con_short_name LIKE
                                                              i_con_short_name
                                            AND flee.lee_cha_com_number =
                                                                afc.com_number
                                            AND flee.lee_short_name LIKE
                                                              i_lee_short_name
                                            AND fcon.con_number =
                                                             fl.lic_con_number
                                            AND fl.lic_type LIKE i_lic_type
                                            AND fl.lic_budget_code LIKE
                                                             i_lic_budget_code              
                                            AND fl.lic_status NOT IN
                                                              ('B', 'F', 'T')
                                            AND EXISTS (
                                                   SELECT NULL
                                                     FROM x_fin_subledger_arch
                                                    WHERE lis_lic_number =
                                                                    lic_number
                                                      AND lis_lsl_number =
                                                                    lsl_number)
                                            AND fg.gen_refno =
                                                              fl.lic_gen_refno
                                            AND ft.ter_code = afc.com_ter_code
                                            AND fer.rat_cur_code =
                                                               fl.lic_currency
                                            AND fer.rat_cur_code_2 =
                                                               ft.ter_cur_code
                                            AND fr.reg_id(+) =
                                                         flee.lee_split_region
                                            AND fr.reg_code LIKE i_reg_code
                                            AND fl.lic_number =
                                                           xfsl.lsl_lic_number
                                            AND flee.lee_number =
                                                           xfsl.lsl_lee_number
                                       GROUP BY ft.ter_cur_code,
                                                afc.com_number,
                                                afc.com_name,
                                                afc.com_short_name,
                                                fl.lic_currency,
                                                fl.lic_type,
                                                flee.lee_short_name,
                                                flee.lee_number,
                                                fl.lic_budget_code,
                                                bfc.com_short_name,
                                                fcon.con_short_name,
                                                afc.com_ter_code,
                                                fcon.con_number,
                                                fl.lic_number,
                                                fl.lic_amort_code,
                                                fl.lic_gen_refno,
                                                xfsl.lsl_lee_price,
                                                NVL (fer.rat_rate, 0),
                                                TO_CHAR (fl.lic_acct_date,
                                                         'YYYY.MM'
                                                        ),
                                                TO_CHAR (fl.lic_start,
                                                         'DDMonYYYY'
                                                        ),
                                                TO_CHAR (fl.lic_end,
                                                         'DDMonYYYY'
                                                        ),
                                                fg.gen_title,
                                                fr.reg_code,
                                                xfsl.lsl_number))
                        WHERE ROUND ((d_license_fee - d_paid_amount), 2)  --<> 0
                                      NOT BETWEEN  -1 AND 1); -- REQUESTED BY FIN_CR . DO NOT DISPLAY RECORD WHICH CONTAIN 1 TO -1 VALUE (Ankur kasar)
         END IF;
      END IF;
   END prc_fin_fee_liab_search;

   FUNCTION get_exchange_rate (
      i_lic_type              IN   fid_license.lic_type%TYPE,
      i_lic_currency          IN   fid_license.lic_currency%TYPE,
      i_lic_number            IN   fid_license.lic_number%TYPE,
      i_lsl_number            IN   NUMBER,
      i_period                IN   DATE,
      i_v_go_live_date        IN   DATE,
      i_ter_cur_code          IN   fid_territory.ter_cur_code%TYPE,
      i_l_last_day            IN   DATE,
      i_l_rsa_ratedate        IN   DATE,
      i_report_sub_type       IN   VARCHAR2,
      i_rate_type             IN   VARCHAR2,
      i_rat_rate              IN   NUMBER,
      i_l_afr_ratedate        IN   DATE,
      i_calc_paid_liability   IN   NUMBER
   )
      RETURN NUMBER
   AS
      l_exchange_rate      NUMBER;
      i_lic_acct_date      DATE;
      i_lic_start          DATE;
      i_lic_start_rate     NUMBER;
      i_lee_split_region   NUMBER;
      l_lic_status         VARCHAR2 (3);
      i_lic_lee_number     fid_license.lic_lee_number%TYPE;
      i_lic_cancel_date   fid_license.lic_cancel_date%type;
   BEGIN
      SELECT lic_acct_date, lic_start, lic_start_rate, lic_status,
             lic_lee_number, lic_cancel_date
        INTO i_lic_acct_date, i_lic_start, i_lic_start_rate, l_lic_status,
             i_lic_lee_number, i_lic_cancel_date
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT lee_split_region
        INTO i_lee_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_lic_number);


      BEGIN
         SELECT (CASE
                    WHEN i_lic_currency <> 'ZAR'
                       THEN (CASE
                                WHEN i_calc_paid_liability < 0
                                AND i_lic_start < TO_DATE (i_v_go_live_date)
                                   --AND i_lic_start > LAST_DAY (i_period)
                             THEN NVL (i_rat_rate, 0)
                                /*
                                NOC :
                                Exchange rate for cancelled licenses having accounting date after go-live date.
                                NEERAJ : KARIM : 18-12-2013
                                */
                             WHEN i_calc_paid_liability < 0
                             AND i_lic_acct_date >= TO_DATE (i_v_go_live_date)
                             AND l_lic_status = 'C'
                             AND TO_CHAR (i_lic_start, 'YYYYMM') <
                                       TO_CHAR (LAST_DAY (i_period), 'YYYYMM')
                             AND TO_CHAR (i_lic_cancel_date, 'YYYYMM')
                                <= TO_CHAR (LAST_DAY (i_period), 'YYYYMM')
                                   THEN DECODE
                                          (i_report_sub_type,
                                           'A', ROUND
                                              (  pkg_fin_mnet_out_liab_rpt.calc_local_liability
                                                                (i_lic_number,
                                                                 i_period,
																 i_lsl_number
                                                                )
                                               / i_calc_paid_liability,
                                               5
                                              ),
                                           DECODE
                                              (i_lee_split_region,
                                               1, DECODE
                                                  (i_rate_type,
                                                   'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                             (i_lic_currency,
                                                              i_ter_cur_code,
                                                              i_l_afr_ratedate
                                                             ),
                                                   'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                              (i_lic_currency,
                                                               i_ter_cur_code,
                                                               i_l_last_day
                                                              )
                                                  ),
                                               DECODE
                                                  (i_rate_type,
                                                   'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                             (i_lic_currency,
                                                              i_ter_cur_code,
                                                              i_l_rsa_ratedate
                                                             ),
                                                   'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                              (i_lic_currency,
                                                               i_ter_cur_code,
                                                               i_l_last_day
                                                              )
                                                  )
                                              )
                                          )
                                WHEN i_calc_paid_liability < 0
                                AND i_lic_start >= TO_DATE (i_v_go_live_date)
                                   --AND i_lic_start > LAST_DAY (i_period)
                             THEN DECODE
                                    (i_report_sub_type,
                                     'A', ROUND
                                        (  pkg_fin_mnet_out_liab_rpt.calc_local_liability1
                                                       (i_lic_number,
                                                        i_lsl_number,
                                                        --Changes done on 17-jan-2014
                                                        i_calc_paid_liability,
                                                        NVL (i_rat_rate, 0),
                                                        i_lic_start,
                                                        i_period
                                                       )
                                         / i_calc_paid_liability,
                                         5
                                        ),
                                     DECODE
                                        (i_lee_split_region,
                                         1, DECODE
                                            (i_rate_type,
                                             'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                             (i_lic_currency,
                                                              i_ter_cur_code,
                                                              i_l_afr_ratedate
                                                             ),
                                             'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                              (i_lic_currency,
                                                               i_ter_cur_code,
                                                               i_l_last_day
                                                              )
                                            ),
                                         DECODE
                                            (i_rate_type,
                                             'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                             (i_lic_currency,
                                                              i_ter_cur_code,
                                                              i_l_rsa_ratedate
                                                             ),
                                             'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                              (i_lic_currency,
                                                               i_ter_cur_code,
                                                               i_l_last_day
                                                              )
                                            )
                                        )
                                    )
                                WHEN i_lic_start < TO_DATE (i_v_go_live_date)
                                   THEN NVL (i_rat_rate, 0)
                                ELSE DECODE
                                       (i_report_sub_type,
                                        'A',                 --Karim Commented
                                        /*(CASE
                                        --WHEN TO_CHAR (i_period, 'YYYYMM') <
                                        --201308
                                        THEN get_exchange_rate_lsd
                                        (i_lic_currency,
                                        i_lic_number,
                                        i_lsl_number,
                                        i_period,
                                        i_lic_start_rate
                                        )
                                        NVL (i_lic_start_rate, 0)
                                        ELSE*/
                                        get_exchange_rate_lsd
                                                             (i_lic_currency,
                                                              i_lic_number,
                                                              i_lsl_number,
                                                              i_period,
                                                              i_lic_start_rate
                                                             )
                                                              /*END
                                                              )*/
                                    ,
                                        DECODE
                                           (i_lee_split_region,
                                            1, DECODE
                                               (i_rate_type,
                                                'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                             (i_lic_currency,
                                                              i_ter_cur_code,
                                                              i_l_afr_ratedate
                                                             ),
                                                'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                              (i_lic_currency,
                                                               i_ter_cur_code,
                                                               i_l_last_day
                                                              )
                                               ),
                                            DECODE
                                               (i_rate_type,
                                                'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                             (i_lic_currency,
                                                              i_ter_cur_code,
                                                              i_l_rsa_ratedate
                                                             ),
                                                'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                              (i_lic_currency,
                                                               i_ter_cur_code,
                                                               i_l_last_day
                                                              )
                                               )
                                           )
                                       )
                             END
                            )
                    ELSE 1
                 END
                )
           INTO l_exchange_rate
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_exchange_rate := 0;
      END;

      RETURN ABS (ROUND (l_exchange_rate, 5));
   END;

   FUNCTION get_exchange_rate_lsd (
      i_lic_currency     IN   fid_license.lic_currency%TYPE,
      i_lic_number       IN   fid_license.lic_number%TYPE,
      i_lsl_number       IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_period           IN   DATE,
      i_lic_start_rate   IN   NUMBER
   )
      RETURN NUMBER
   IS
      lsd_rate_at_period   NUMBER;
   BEGIN
      lsd_rate_at_period := -1;

      BEGIN
         SELECT DISTINCT lis_lic_start_rate
                    INTO lsd_rate_at_period
                    FROM fid_license_sub_ledger
                   WHERE lis_lic_number = i_lic_number
                     AND lis_lsl_number = i_lsl_number
                     AND lis_per_year || LPAD (lis_per_month, 2, 0) =
                                                  TO_CHAR (i_period, 'YYYYMM')
                     AND lis_lic_start_rate <> 0
                     AND lis_lic_start_rate IS NOT NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            lsd_rate_at_period := i_lic_start_rate;
      END;

      RETURN lsd_rate_at_period;
   END get_exchange_rate_lsd;

   FUNCTION calc_paid_liability (
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_lsl_number     IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_period         IN   DATE
   )
      RETURN NUMBER
   IS
      fee_is       NUMBER;
      total_paid   NUMBER;
      l_liablity   NUMBER;
   BEGIN
      SELECT SUM (lis_con_fc_imu)
        INTO fee_is
        FROM fid_lis_fc_vw
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                                                  TO_CHAR (i_period, 'YYYYMM');

      SELECT NVL (SUM (pay_amount), 0)
        INTO total_paid
        FROM fid_payment, fid_payment_type
       WHERE pat_code = pay_code
         AND pay_lic_number = i_lic_number
         AND pay_lsl_number = i_lsl_number
         AND pay_cur_code = i_lic_currency
         AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <=
                TO_DATE (TO_CHAR (LAST_DAY (i_period), 'DD-MON-RRRR'),
                         'DD-MON-RRRR'
                        )
         AND pay_status IN ('P', 'I')
         AND pat_group = 'F';

      l_liablity := (fee_is - total_paid);
      RETURN ROUND (l_liablity, 2);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_liablity := 0;
         RETURN ROUND (l_liablity, 2);
   END calc_paid_liability;

   FUNCTION calc_local_liability (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_period       IN   DATE,
	  i_lsl_number   IN   NUMBER
   )
      RETURN NUMBER
   IS
      l_refund_amt        NUMBER;
      l_local_liability   NUMBER;
   BEGIN
      l_local_liability := 0;

      FOR i IN (SELECT pay_number, pay_rate, pay_amount
                  FROM fid_payment
                 WHERE pay_lic_number = i_lic_number
				 AND PAY_LSL_NUMBER= i_lsl_number
                   AND pay_amount > 0
                   AND pay_status = 'P'
                   AND TO_NUMBER (TO_CHAR (pay_date, 'RRRRMM')) <=
                                      TO_NUMBER (TO_CHAR (i_period, 'RRRRMM')))
      LOOP
         SELECT NVL (SUM (frs_rfd_amount), 0)
           INTO l_refund_amt
           FROM x_fin_refund_settle
          WHERE frs_pay_number = i.pay_number
            AND frs_year || LPAD (frs_month, 2, 0) <=
                                                  TO_CHAR (i_period, 'RRRRMM');

         l_local_liability :=
                 l_local_liability
                 + (i.pay_amount - l_refund_amt) * i.pay_rate;
      END LOOP;

      IF (l_local_liability > 0)
      THEN
         l_local_liability := -l_local_liability;
      END IF;

      RETURN ROUND (l_local_liability, 2);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_local_liability := 0;
         RETURN ROUND (l_local_liability, 2);
   END calc_local_liability;

   FUNCTION calc_local_liability1 (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_lsl_number   IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_liab_amt     IN   NUMBER,
      i_rate         IN   NUMBER,
      i_lic_start    IN   fid_license.lic_start%TYPE,
      i_period       IN   DATE
   )
      RETURN NUMBER
   IS
      l_refund_amt          NUMBER;
      l_local_liability     NUMBER;
      l_prepayment_amt      NUMBER;
      l_lic_start_rate      NUMBER;
      l_total_payment       NUMBER;
      l_total_refund_amt    NUMBER;
      l_payment_amount      NUMBER;
      l_lic_cur_liability   NUMBER;
      l_prepayment_amount   NUMBER;
   BEGIN
      l_lic_start_rate := 0;
      l_total_payment := 0;
      l_total_refund_amt := 0;
      l_local_liability := 0;
      l_lic_cur_liability := i_liab_amt;

      SELECT NVL (lic_start_rate, 0)
        INTO l_lic_start_rate
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT NVL (SUM (pay_amount), 0)
        INTO l_total_payment
        FROM fid_payment
       WHERE pay_lic_number = i_lic_number
         AND TO_DATE (pay_date, 'DD-MON-YYYY') >=
                                          TO_DATE (i_lic_start, 'DD-MON-YYYY')
         AND pay_status = 'P'
         AND pay_amount > 0
         AND pay_lsl_number = i_lsl_number
         AND TO_NUMBER (TO_CHAR (pay_date, 'YYYYMM')) <=
                                      TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'));

      SELECT NVL (SUM (frs_rfd_amount), 0)
        INTO l_total_refund_amt
        FROM x_fin_refund_settle, fid_payment
       WHERE frs_lic_number = i_lic_number
         AND frs_pay_number = pay_number
         AND pay_lsl_number = i_lsl_number
         AND TO_DATE (pay_date, 'DD-MON-YYYY') >=
                                          TO_DATE (i_lic_start, 'DD-MON-YYYY')
         AND frs_year || LPAD (frs_month, 2, 0) <=
                                                  TO_CHAR (i_period, 'YYYYMM');

      IF (l_total_payment - l_total_refund_amt) > 0
      THEN
         ----Payment loop to settle refund and calculate local amount
         FOR c_license_payment IN (SELECT pay_number, pay_rate, pay_amount
                                     FROM fid_payment
                                    WHERE pay_lic_number = i_lic_number
                                      AND pay_amount > 0
                                      AND TO_DATE (pay_date, 'DD-MON-YYYY') >=
                                             TO_DATE (i_lic_start,
                                                      'DD-MON-YYYY'
                                                     )
                                      AND pay_status = 'P'
                                      AND pay_lsl_number = i_lsl_number
                                      AND TO_NUMBER (TO_CHAR (pay_date,
                                                              'YYYYMM'
                                                             )
                                                    ) <=
                                             TO_NUMBER (TO_CHAR (i_period,
                                                                 'YYYYMM'
                                                                )
                                                       ))
         LOOP
            l_refund_amt := 0;

            SELECT NVL (SUM (frs_rfd_amount), 0)
              INTO l_refund_amt
              FROM x_fin_refund_settle
             WHERE frs_pay_number = c_license_payment.pay_number
               AND frs_year || LPAD (frs_month, 2, 0) <=
                                                  TO_CHAR (i_period, 'YYYYMM');

            l_payment_amount := c_license_payment.pay_amount - l_refund_amt;

            IF l_payment_amount < ABS (l_lic_cur_liability)
            THEN
               l_local_liability :=
                    l_local_liability
                    + (l_payment_amount * l_lic_start_rate);
               l_lic_cur_liability := l_lic_cur_liability + l_payment_amount;
            ELSE
               l_local_liability :=
                    l_local_liability
                  + (ABS (l_lic_cur_liability) * l_lic_start_rate);
               l_lic_cur_liability := 0;
               EXIT;
            END IF;
         END LOOP;
      END IF;

      IF l_lic_cur_liability < 0
      THEN
         ----Pre-payment loop to settle refund and calculate local amount
         FOR c_license_prepayment IN (SELECT   pay_number, pay_rate,
                                               pay_amount
                                          FROM fid_payment
                                         WHERE pay_lic_number = i_lic_number
                                           AND pay_amount > 0
                                           AND TO_DATE (pay_date,
                                                        'DD-MON-YYYY'
                                                       ) <
                                                  TO_DATE (i_lic_start,
                                                           'DD-MON-YYYY'
                                                          )
                                           AND pay_status = 'P'
                                           AND pay_lsl_number = i_lsl_number
                                           AND TO_NUMBER (TO_CHAR (pay_date,
                                                                   'YYYYMM'
                                                                  )
                                                         ) <=
                                                  TO_NUMBER
                                                           (TO_CHAR (i_period,
                                                                     'YYYYMM'
                                                                    )
                                                           )
                                      ORDER BY pay_date)
         LOOP
            SELECT NVL (SUM (frs_rfd_amount), 0)
              INTO l_refund_amt
              FROM x_fin_refund_settle
             WHERE frs_pay_number = c_license_prepayment.pay_number
               AND frs_year || LPAD (frs_month, 2, 0) <=
                                                  TO_CHAR (i_period, 'YYYYMM');

            l_prepayment_amount :=
                                c_license_prepayment.pay_amount - l_refund_amt;

            IF l_prepayment_amount < ABS (l_lic_cur_liability)
            THEN
               l_local_liability :=
                    l_local_liability
                  + (l_prepayment_amount * c_license_prepayment.pay_rate);
               l_lic_cur_liability :=
                                     l_lic_cur_liability + l_prepayment_amount;
            ELSE
               l_local_liability :=
                    l_local_liability
                  + (ABS (l_lic_cur_liability) * c_license_prepayment.pay_rate
                    );
               l_lic_cur_liability := 0;
               EXIT;
            END IF;
         END LOOP;
      END IF;

      RETURN ROUND (-l_local_liability, 2);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_local_liability := 0;
         RETURN ROUND (-l_local_liability, 2);
   END calc_local_liability1;

   FUNCTION calc_liab_local_amount (
      i_lic_number            IN   fid_license.lic_number%TYPE,
      i_lsl_number            IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_rate                  IN   NUMBER,
      i_calc_paid_liability   IN   NUMBER,
      i_v_go_live_date        IN   DATE,
      i_period                IN   DATE
   )
      RETURN NUMBER
   AS
      l_lic_currency    VARCHAR2 (3);
      l_lic_acct_date   DATE;
      l_lic_start       DATE;
      l_lic_status      VARCHAR2 (3);
      l_local_amount    NUMBER;
	  i_lic_cancel_date fid_license.lic_cancel_date%type;
   BEGIN
      SELECT lic_currency, lic_acct_date, lic_start, lic_status,lic_cancel_date
        INTO l_lic_currency, l_lic_acct_date, l_lic_start, l_lic_status,i_lic_cancel_date
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT CASE
                WHEN i_calc_paid_liability < 0
                AND l_lic_acct_date >= i_v_go_live_date
                AND l_lic_status = 'C'
                AND TO_CHAR (i_lic_cancel_date, 'YYYYMM')
                                <= TO_CHAR (LAST_DAY (i_period), 'YYYYMM')
                   THEN pkg_fin_mnet_out_liab_rpt.calc_local_liability
                                                                (i_lic_number,
                                                                 i_period,
																 i_lsl_number
                                                                )
                WHEN i_calc_paid_liability < 0
                AND l_lic_acct_date >= i_v_go_live_date
                AND l_lic_status = 'A'
                   THEN pkg_fin_mnet_out_liab_rpt.calc_local_liability1
                                                       (i_lic_number,
                                                        i_lsl_number,
                                                        i_calc_paid_liability,
                                                        i_rate,
                                                        l_lic_start,
                                                        i_period
                                                       )
                ELSE i_calc_paid_liability * i_rate
             END
        INTO l_local_amount
        FROM DUAL;

      RETURN ROUND (l_local_amount, 2);
   END calc_liab_local_amount;

   PROCEDURE prc_fin_fee_liab_summary (
      i_report_type       IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,
      i_type              IN       VARCHAR2,   -- for a period or Consolidated
      i_report_sub_type   IN       VARCHAR2,                         --4 types
      o_fin_payment       OUT      pkg_fin_mnet_out_liab_rpt.fin_payment_cursor
   )
   AS
      stmt_str             VARCHAR (5000);
      v_go_live_date       DATE;
      e_record_not_found   EXCEPTION;
   BEGIN
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      IF (i_report_type = 'S')
      THEN
         OPEN o_fin_payment FOR
            SELECT   lii_date, lii_period, lii_inoutlic, lii_reporttype,
                     lii_budget_code, lii_budgetcode,
                                                     -- report_type,
                                                     lii_company,
                     lii_currency, lii_type, lii_lictype, lii_lee_short_name,
                     lii_supplier, lii_contract,
                     SUM (lii_pay_amount) lii_pay_amount,
                     SUM (lii_fee_amount) lii_fee_amount,
                     SUM (s_lii_lia_amount) s_lii_lia_amount,
                     SUM (s_lii_lia_loc_amount) s_lii_lia_loc_amount,

                     --Dev2: Pure Finance :Start:[ANUJASHINDE]_[2013/3/19]
                     SUM (lii_pv_adj) s_lii_pv_adj,
                     SUM (lii_cha_pv_adj) s_lii_cha_pv_adj,
                     SUM (lii_clos_lia) s_lii_clos_lia,
                     SUM (lii_cha_clos_lia) s_lii_cha_clos_lia
                --Dev2: Pure Finance :END
            FROM     (SELECT TO_CHAR (LII_DATE,
                                      'DD-MON-RRRR'
                                     ) lii_date,
                             lii_period,
                             DECODE
                                (lii_inoutlic,
                                 'B', '[Both In and Out of License]',
                                 'I', '[In License Only]',
                                 'O', '[Out of License Only]'
                                ) lii_inoutlic,
                             DECODE (lii_reporttype,
                                     'M', 'Movement',
                                     'Detail'
                                    ) lii_reporttype,
                             lii_company, lii_lictype,        -- lii_licensee,
                                                      lii_budgetcode,
                             lii_budget_code, lii_supplier, lii_contract,

                             -- lii_com_short_name,
                             lii_currency, lii_type, lii_lee_short_name,
                             lii_fee_amount, lii_pay_amount,
                             (lii_fee_amount - lii_pay_amount
                             ) s_lii_lia_amount,
                             lii_lia_loc_amount s_lii_lia_loc_amount,

                             /*pkg_fin_mnet_out_liab_rpt.calc_liab_local_amount(lii_lic_number,
                             lii_rate,(lii_fee_amount - lii_pay_amount),v_go_live_date)s_lii_lia_loc_amount,*/
                             /*(CASE
                             WHEN (lii_fee_amount - lii_pay_amount) < 0
                             AND TO_DATE (lii_acct_date, 'YYYY.MM') >=
                             v_go_live_date
                             AND TO_DATE (lii_start_date, 'DDMONYYYY') >
                             LAST_DAY (TO_DATE (lii_period,
                             'YYYY.MM'
                             )
                             )
                             THEN   (  (lii_fee_amount - lii_pay_amount
                             )
                             * lii_rate
                             )
                             * -1
                             ELSE (  (lii_fee_amount - lii_pay_amount)
                             * lii_rate
                             )
                             END
                             ) s_lii_lia_loc_amount,*/
                             'S' report_type, lii_reg_code region
                                                                 --Dev2: Pure Finance :Start:[ANUJASHINDE]_[2013/3/19]
                             ,
                             NVL (lii_pv_adj, 0) lii_pv_adj,
                             NVL (lii_cha_pv_adj, 0) lii_cha_pv_adj,
                             NVL (lii_clos_lia, 0) lii_clos_lia,
                             NVL (lii_cha_clos_lia, 0) lii_cha_clos_lia
                        --Dev2: Pure Finance :END
                      FROM   fid_lia_summary
                       WHERE lii_reg_code LIKE i_reg_code)
            GROUP BY lii_date,
                     lii_period,
                     lii_inoutlic,
                     lii_reporttype,
                     lii_budget_code,
                     lii_budgetcode,
                     lii_company,
                     lii_currency,
                     lii_type,
                     lii_lictype,
                     lii_lee_short_name,
                     lii_supplier,
                     lii_contract
            ORDER BY lii_company, lii_currency, lii_type, lii_lee_short_name;
      END IF;
   END prc_fin_fee_liab_summary;

--('D','N','%','%','%','%','%','%','BOTH','N','C','A','M',Null,Null,'01/Dec/2015','%',:D)
   PROCEDURE prc_fin_fee_liab_exp_to_exl (
      i_report_type         IN       VARCHAR2,
      i_calculate_summary   IN       VARCHAR2,
      i_com_short_name      IN       fid_company.com_short_name%TYPE,
      i_lic_type            IN       fid_license.lic_type%TYPE,
      i_lee_short_name      IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code     IN       fid_license.lic_budget_code%TYPE,
      i_co_short_name       IN       fid_company.com_short_name%TYPE,
      i_con_short_name      IN       fid_contract.con_short_name%TYPE,
      i_licenses_in_out     IN       VARCHAR2,
      i_include_zeros       IN       VARCHAR2,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      i_type                IN       VARCHAR2, -- for a period or Consolidated
      i_report_sub_type     IN       VARCHAR2,                       --4 types
      i_rate_type           IN       VARCHAR2,             -- M rate or R rate
      i_from_date           IN       DATE,                       --period from
      i_to_date             IN       DATE,                        -- period to
      --Dev2: Pure Finance :End
      i_period              IN       DATE,                     -- "As of" date
      i_reg_code            IN       fid_region.reg_code%TYPE,     --For Split
      o_fin_payment         OUT      pkg_fin_mnet_out_liab_rpt.fin_payment_cursor
   )
   AS
      e_no_period_date    EXCEPTION;
      stmt_str            VARCHAR2 (5000);
      l_period            VARCHAR2 (20);
      temp_period         VARCHAR2 (20);
      last_date           VARCHAR2 (20);
      first_date          VARCHAR2 (20);
      liab_summary_date   VARCHAR2 (20);
      l_temp_period       DATE;
      l_start             DATE;
      l_end               DATE;
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      l_year              NUMBER;
      l_month             NUMBER;
      l_last_day          DATE;
      l_first_day         DATE;
      l_rsa_ratedate      DATE;
      l_afr_ratedate      DATE;
      v_go_live_date      DATE;
      l_disc_rate         NUMBER;
      l_trc_query         VARCHAR2 (500);
      v_sql               VARCHAR2 (10000);
      
      l_con_number        NUMBER;
   --Dev2: Pure Finance :End
     l_fin_i_live_date 	DATE := x_fnc_get_fin_i_live_date; --Added [Jawahar.Garg]FIN DEV PHASE-I
   BEGIN
      SELECT TO_CHAR (i_period, 'YYYYMM')
        INTO temp_period
        FROM DUAL;

      SELECT TO_CHAR (i_period, 'YYYY.MM')
        INTO liab_summary_date
        FROM DUAL;

      SELECT TRUNC (i_period, 'MON'), TRUNC (LAST_DAY (i_period))
        INTO l_start, l_end
        FROM DUAL;

      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      l_month := TO_NUMBER (TO_CHAR (i_period, 'MM'));
      l_year := TO_NUMBER (TO_CHAR (i_period, 'RRRR'));

      --[last day of to_date input parameter for repiort type for a period]
      SELECT LAST_DAY (i_to_date)
        INTO l_last_day
        FROM DUAL;

      --[first day  of from_date input parameter for report type "for a period"]
      SELECT ADD_MONTHS (LAST_DAY (i_from_date), -1) + 1
        INTO l_first_day
        FROM DUAL;

------------------Calculate Rate Date ---------------------------------------------------------------------------
      IF UPPER (i_reg_code) = 'RSA'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE fmd_month = l_month
               AND fmd_year = l_year
               AND reg_id = fmd_region
               AND UPPER (fmd_mon_end_type) = 'FINAL'
               AND UPPER (reg_code) = i_reg_code;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;
      ELSIF UPPER (i_reg_code) = 'AFR'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE fmd_month = l_month
               AND fmd_year = l_year
               AND reg_id = fmd_region
               AND UPPER (fmd_mon_end_type) = 'FINAL'
               AND UPPER (reg_code) = i_reg_code;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_afr_ratedate := NULL;
         END;
      ELSE
         BEGIN
            SELECT fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE fmd_month = l_month
               AND fmd_year = l_year
               AND reg_id = fmd_region
               AND UPPER (fmd_mon_end_type) = 'FINAL'
               AND UPPER (reg_code) = 'RSA';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;

         BEGIN
            SELECT fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE fmd_month = l_month
               AND fmd_year = l_year
               AND reg_id = fmd_region
               AND UPPER (fmd_mon_end_type) = 'FINAL'
               AND UPPER (reg_code) = 'AFR';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_afr_ratedate := NULL;
         END;
      END IF;

----------------------------------------------------------------------------
-- TO SELECT DISCOUNT RATE - for specific month and year
      BEGIN
         SELECT drm_disc_per_anl
           INTO l_disc_rate
           FROM x_fin_disc_rate
          WHERE drm_year = l_year AND drm_month = l_month;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_disc_rate := NULL;
      END;
      
      IF nvl(i_con_short_name,'%') <> '%'
      THEN
        BEGIN
           SELECT CON_NUMBER
             INTO l_con_number
             FROM fid_contract
            WHERE con_short_name = i_con_short_name;
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
             l_con_number := NULL;
        END;
      ELSE
        l_con_number := NULL;
      END IF;
      
      --Dev2: Pure Finance :End
      DELETE FROM exl_outstanding_liability_dtls;

      --EXECUTE IMMEDIATE ('TRUNCATE TABLE exl_outstanding_liability_dtls');
      l_trc_query := 'TRUNCATE TABLE x_fin_subledger_arch';

      EXECUTE IMMEDIATE l_trc_query;
      INSERT      /*+APPEND */INTO x_fin_subledger_arch
                        (lis_lic_number, lis_lsl_number, lis_con_forecast,
                         liab_pv_adj)
               SELECT   lis_lic_number, lis_lsl_number,
                        ROUND (SUM (lis_con_fc_imu), 2),
                        ROUND (SUM (lis_pv_con_fc_emu)
                               - SUM (lis_pv_con_liab_ac_emu),
                               2
                              )
                  FROM x_mv_subledger_data mv1
                  WHERE lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'))
                  and lic_con_number = nvl(l_con_number,lic_con_number)
                  AND (
                       --Before Finance Dev Phase I Go Live Date
                       ( 
                          lic_acct_date BETWEEN DECODE (i_type, 'P', l_first_day, lic_acct_date ) AND DECODE (i_type, 'P', l_last_day, l_end ) 
                          AND i_period < l_fin_i_live_date
                       )
                         OR
                       --After Finance Dev Phase I Go Live Date
                       ( i_period >= l_fin_i_live_date
                         AND lic_acct_date BETWEEN DECODE (i_type, 'P', l_first_day, lic_acct_date ) AND DECODE (i_type, 'P', l_last_day, l_end )
                         AND NOT EXISTS (
                                           SELECT lsh_lic_number
                                           FROM(
                                               SELECT lsh_lic_number,lsh_lic_status,
                                                  DENSE_RANK() OVER(PARTITION BY LSH_LIC_NUMBER,LSH_STATUS_YYYYMM ORDER BY LSH_STATUS_YYYYMM DESC)RN
                                                  FROM X_LIC_STATUS_HISTORY
                                                  WHERE LSH_STATUS_YYYYMM <= TO_NUMBER(TO_CHAR(i_period,'RRRRMM'))
                                                )WHERE RN = 1
                                           AND lsh_lic_status = 'C'
                                           AND lsh_lic_number = lis_lic_number
                                           UNION ALL
                                           select mv2.lis_lic_number
                                           from x_mv_subledger_data mv2
                                           where (lis_lic_status = 'C'
                                                  or lis_lic_start > LAST_DAY(i_period))
                                           and mv1.lis_lic_number = mv2.lis_lic_number
                                           AND lis_yyyymm_num = TO_NUMBER(TO_CHAR(i_period,'RRRRMM'))
                                        )
                      )
                    )
               GROUP BY lis_lic_number, lis_lsl_number;

      COMMIT;

      IF (UPPER (i_report_type) = 'D') -- exl
      THEN
         IF i_include_zeros = 'Y'
         THEN
            INSERT INTO exl_outstanding_liability_dtls
                        (channel_company, lic_currency, period,
                         exchange_rate, ter_cur_code, lic_type,
                         lee_short_name, lic_budget_code, suppler,
                         con_short_name, lic_number, gen_title,
                         gen_title_working, acct_date, lic_start, lic_end,
                         lic_price, fee, paid, liab, loc_liab,
                         lic_amort_code, reg_code,
                         pv_adj, loc_pv_adj,
                         close_liab, loc_close_liab, discount_rate)
						SELECT   channel_company
								,lic_currency
								,TO_CHAR (i_period, 'MON-YYYY') period
								,exchange_rate
								,ter_cur_code
								,lic_type
								,lee_short_name
								,lic_budget_code
								,com_short_name supplier
								,con_short_name
								,lic_number
								,gen_title
								,gen_title_working
								,ACCT ACCT_DATE
								,START_DATE LIC_START
								,end_date lic_end
								,ROUND (lic_price, 2) lic_price
								,d_license_fee fee
								,d_paid_amount paid
								,d_lia_amount liab
								,d_liab_local_amount loc_liab
								,lic_amort_code lic_amort_code
								,reg_code
								,liab_pv_adj
								,loc_liab_pv_adj
								,liab_closing
								,loc_liab_closing
								,discountrate
						FROM (	SELECT	ter_cur_code
										,com_number
										,channel_company
										,com_short_name1
										,lic_currency
										,lic_type
										,lee_short_name
										,lee_number
										,lic_budget_code
										,com_short_name
										,con_short_name
										,com_ter_code
										,lic_number
										,con_number
										,gen_title
										,gen_title_working
										,lic_amort_code
										,lic_price
										,lsl_number
										,acct
										,start_date
										,end_date
										,d_license_fee
										,d_paid_amount
										,reg_code
										,liab_pv_adj
										,(liab_pv_adj * exchange_rate) loc_liab_pv_adj
										,((d_license_fee - d_paid_amount) + liab_pv_adj) liab_closing
										,(  (  (d_license_fee - d_paid_amount) + liab_pv_adj) * exchange_rate) loc_liab_closing
										, exchange_rate
										,pkg_fin_mnet_out_liab_rpt.calc_liab_local_amount
										(	lic_number,
											lsl_number,
											exchange_rate,
											(d_license_fee - d_paid_amount),
											v_go_live_date,
											i_period
										) d_liab_local_amount
										,(d_license_fee - d_paid_amount) d_lia_amount
										,l_rsa_ratedate rsa_ratedate
										,DECODE(i_rate_type,'M'
												,x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
												(lic_currency,
												ter_cur_code,
												l_rsa_ratedate
												), 'R'
												, x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
												(	lic_currency,
													ter_cur_code,
													l_last_day
												)) rsa_spotrate
										,l_afr_ratedate afr_ratedate
										,DECODE(i_rate_type,	'M'
												, x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
												(	lic_currency,
													ter_cur_code,
													l_afr_ratedate
												),'R'
												, x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
												(lic_currency,
													ter_cur_code,
													l_last_day
												)
											) afr_spotrate
										,l_disc_rate discountrate
								FROM (	SELECT ter_cur_code
												,com_number
												,channel_company
												,com_short_name1
												,lic_currency
												,lic_type
												,lee_short_name
												,lee_number
												,lic_budget_code
												,com_short_name
												,con_short_name
												,com_ter_code
												,con_number
												,lic_number
												,lic_amort_code
												,lic_gen_refno
												,lic_price
												,lsl_number
												,acct
												,start_date
												,end_date
												,gen_title
												,gen_title_working
												,d_license_fee
												,d_paid_amount
												,reg_code
												,liab_pv_adj
												,pkg_fin_mnet_out_liab_rpt.get_exchange_rate
													(	lic_type,
														lic_currency,
														lic_number,
														lsl_number,
														i_period,
														v_go_live_date,
														ter_cur_code,
														l_last_day,
														l_rsa_ratedate,
														i_report_sub_type,
														i_rate_type,
														rat_rate,
														l_afr_ratedate,
														(d_license_fee - d_paid_amount)
													) exchange_rate
										FROM (	SELECT	ft.ter_cur_code
														,afc.com_number
														,TRIM(afc.com_name) channel_company
														,TRIM(afc.com_short_name) com_short_name1
														,fl.lic_currency
														,fl.lic_type
														,flee.lee_short_name
														,flee.lee_number
														,fl.lic_budget_code
														,bfc.com_short_name	com_short_name
														,fcon.con_short_name
														,afc.com_ter_code
														,fcon.con_number
														,fl.lic_number
														,fl.lic_amort_code
														,fl.lic_gen_refno
														,lsl_lee_price lic_price
														,xfsl.lsl_number
														,NVL (fer.rat_rate,0) rat_rate
														,TO_CHAR(fl.lic_acct_date,'YYYY.MM') acct
														,TO_CHAR(fl.lic_start,'DDMonYYYY') start_date
														,TO_CHAR(fl.lic_end,'DDMonYYYY') end_date
														,fg.gen_title
														,fg.gen_title_working
														,xfsa.lis_con_forecast d_license_fee
														,(SELECT NVL(SUM(fp.pay_amount),0)
															FROM	fid_payment fp,
																	fid_payment_type fpt
															WHERE	fpt.pat_code = fp.pay_code
															AND fp.pay_lic_number = fl.lic_number
															AND fp.pay_con_number = fcon.con_number
															AND fp.pay_cur_code = fl.lic_currency
															AND fp.pay_lsl_number = xfsl.lsl_number
															AND TRUNC(TO_DATE(TO_CHAR(fp.pay_date,'DD-MON-RRRR'),'DD-MON-RRRR')) <=
																TRUNC(TO_DATE(TO_CHAR(TO_DATE(l_end,'DD-MON-RRRR'),'DD-MON-RRRR'),'DD-MON-RRRR'))
															AND fp.pay_status IN ('P', 'I')
															AND fpt.pat_group = 'F'
														) d_paid_amount
														,fr.reg_code
														,xfsa.liab_pv_adj
												FROM	fid_company afc,
														fid_company bfc,
														fid_contract fcon,
														fid_licensee flee,
														fid_license fl,
														fid_general fg,
														x_fin_lic_sec_lee xfsl,
														x_fin_subledger_arch xfsa,
														fid_territory ft,
														fid_exchange_rate fer,
														fid_region fr
												WHERE	afc.com_short_name LIKE i_com_short_name
												AND afc.com_type IN ('CC', 'BC')
												AND bfc.com_number = fcon.con_com_number
												AND bfc.com_short_name LIKE i_co_short_name
												AND fcon.con_short_name LIKE i_con_short_name
												AND flee.lee_cha_com_number = afc.com_number
												AND flee.lee_short_name LIKE i_lee_short_name
												AND fcon.con_number = fl.lic_con_number
												AND fl.lic_type LIKE i_lic_type
												AND fl.lic_budget_code LIKE i_lic_budget_code
												AND fl.lic_status NOT IN ('B', 'F', 'T')
												AND xfsa.lis_lic_number = xfsl.lsl_lic_number
												AND xfsa.lis_lsl_number = xfsl.lsl_number
												AND fg.gen_refno = fl.lic_gen_refno
												AND ft.ter_code = afc.com_ter_code
												AND fer.rat_cur_code = fl.lic_currency
												AND fer.rat_cur_code_2 = ft.ter_cur_code
												AND fr.reg_id(+) = flee.lee_split_region
												AND fr.reg_code LIKE i_reg_code
												AND fl.lic_number = xfsl.lsl_lic_number
												AND flee.lee_number = xfsl.lsl_lee_number
												GROUP BY ft.ter_cur_code,
														afc.com_number,
														afc.com_name,
														afc.com_short_name,
														fl.lic_currency,
														fl.lic_type,
														flee.lee_short_name,
														flee.lee_number,
														fl.lic_budget_code,
														bfc.com_short_name,
														fcon.con_short_name,
														afc.com_ter_code,
														fcon.con_number,
														fl.lic_number,
														fl.lic_amort_code,
														fl.lic_gen_refno,
														gen_title,
														gen_title_working,
														lsl_lee_price,
														NVL (fer.rat_rate, 0),
														TO_CHAR (fl.lic_acct_date,'YYYY.MM'),
														TO_CHAR (fl.lic_start,'DDMonYYYY'),
														TO_CHAR (fl.lic_end,'DDMonYYYY'),
														fl.lic_gen_refno,
														fr.reg_code,
														xfsl.lsl_number,
														xfsa.lis_con_forecast,
														xfsa.liab_pv_adj
											)
									)
								)
								ORDER BY channel_company,
										lic_currency,
										lic_type,
										lee_short_name,
										lic_budget_code,
										com_short_name,
										con_short_name,
										lic_number;

         ELSIF i_include_zeros = 'N'
         THEN
            INSERT INTO exl_outstanding_liability_dtls
                        (channel_company, lic_currency, period,
                         exchange_rate, ter_cur_code, lic_type,
                         lee_short_name, lic_budget_code, suppler,
                         con_short_name, lic_number, gen_title,
                         gen_title_working, acct_date, lic_start, lic_end,
                         lic_price, fee, paid, liab, loc_liab,
                         lic_amort_code, reg_code,
                         pv_adj, loc_pv_adj,
                         Close_Liab, Loc_Close_Liab, Discount_Rate)
                      SELECT   channel_company
                                    ,LIC_CURRENCY
                                    ,TO_CHAR (i_period, 'MON-RRRR') period
                                    ,exchange_rate
                                    ,ter_cur_code
                                    ,lic_type
                                    ,lee_short_name
                                    ,lic_budget_code
                                    ,supplier
                                    ,con_short_name
                                    ,lic_number
                                    ,gen_title
                                    ,GEN_TITLE_WORKING
                                    ,ACCT ACCT_DATE
                                    ,START_DATE LIC_START
                                    ,end_date lic_end
                                    ,ROUND (lic_price, 2) lic_price
                                    ,d_license_fee fee
                                    ,d_paid_amount paid
                                    ,d_lia_amount liab
                                    ,d_liab_local_amount loc_liab
                                    ,lic_amort_code lic_amort_code
                                    ,reg_code, liab_pv_adj
                                    ,loc_liab_pv_adj
                                    ,liab_closing
                                    ,loc_liab_closing
                                    ,discountrate
                                FROM (	SELECT ter_cur_code
                                      ,com_number
                                      ,TRIM (channel_company) channel_company
                                      ,com_short_name1
                                      ,lic_currency
                                      ,lic_type
                                      ,lee_short_name
                                      ,lee_number
                                      ,lic_budget_code
                                      ,TRIM (com_short_name) supplier
                                      ,con_short_name
                                      ,com_ter_code
                                      ,lic_number
                                      ,con_number
                                      ,gen_title
                                      ,gen_title_working
                                      ,lic_amort_code
                                      ,lic_price
                                      ,lsl_number, acct
                                      ,start_date
                                      ,end_date
                                      ,d_license_fee
                                      ,d_paid_amount
                                      ,reg_code
                                      ,liab_pv_adj
                                      ,(liab_pv_adj * exchange_rate) loc_liab_pv_adj
                                      ,((d_license_fee - d_paid_amount) + liab_pv_adj) liab_closing
                                      ,(((d_license_fee - d_paid_amount) + liab_pv_adj)* exchange_rate) loc_liab_closing
                                      ,exchange_rate
                                      ,pkg_fin_mnet_out_liab_rpt.calc_liab_local_amount
                                      (	lic_number,
                                        lsl_number,
                                        exchange_rate,
                                        (d_license_fee - d_paid_amount),
                                        v_go_live_date,
                                        i_period
                                      ) d_liab_local_amount
                                      ,(d_license_fee - d_paid_amount) d_lia_amount
                                      ,l_rsa_ratedate rsa_ratedate
                                      ,DECODE	(i_rate_type,'M'
                                            ,x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                            (	lic_currency,
                                              ter_cur_code,
                                              l_rsa_ratedate
                                            ) ,'R'
                                            ,x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                            (	lic_currency,
                                              ter_cur_code,
                                              l_last_day
                                            )
                                          ) rsa_spotrate
                                      ,l_afr_ratedate afr_ratedate
                                      ,DECODE (	i_rate_type,'M'
                                            ,x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                            (lic_currency,
                                              ter_cur_code,
                                              l_afr_ratedate
                                            ), 'R'
                                            ,x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                            (lic_currency,
                                              ter_cur_code,
                                              l_last_day
                                            )
                                          ) afr_spotrate
                                      , l_disc_rate discountrate
                                    FROM (	SELECT ter_cur_code
                                            ,com_number
                                            ,channel_company
                                            ,com_short_name1
                                            ,lic_currency
                                            ,lic_type
                                            ,lee_short_name
                                            ,lee_number
                                            ,lic_budget_code
                                            ,com_short_name
                                            ,con_short_name
                                            ,com_ter_code
                                            ,con_number
                                            ,lic_number
                                            ,lic_amort_code
                                            ,lic_gen_refno
                                            ,lic_price
                                            ,lsl_number
                                            ,acct
                                            ,start_date
                                            ,end_date
                                            ,gen_title
                                            ,gen_title_working
                                            ,d_license_fee
                                            ,d_paid_amount
                                            ,reg_code
                                            ,liab_pv_adj
                                            ,pkg_fin_mnet_out_liab_rpt.get_exchange_rate
                                            (	lic_type,
                                              lic_currency,
                                              lic_number,
                                              lsl_number,
                                              i_period,
                                              v_go_live_date,
                                              ter_cur_code,
                                              l_last_day,
                                              l_rsa_ratedate,
                                              i_report_sub_type,
                                              i_rate_type,
                                              rat_rate,
                                              l_afr_ratedate,
                                              (d_license_fee - d_paid_amount)
                                            ) exchange_rate
                                        FROM (SELECT   ft.ter_cur_code,
                                              afc.com_number,
                                              afc.com_name channel_company,
                                              afc.com_short_name	com_short_name1,
                                              fl.lic_currency,
                                              fl.lic_type,
                                              flee.lee_short_name,
                                              flee.lee_number,
                                              fl.lic_budget_code,
                                              bfc.com_short_name	com_short_name,
                                              fcon.con_short_name,
                                              afc.com_ter_code,
                                              fcon.con_number,
                                              fl.lic_number,
                                              fl.lic_amort_code,
                                              fl.lic_gen_refno,
                                              xfsl.lsl_lee_price	lic_price,
                                              xfsl.lsl_number,
                                              NVL (FER.RAT_RATE,0) RAT_RATE,
                                              TO_CHAR(fl.lic_acct_date,'YYYY.MM') acct,
                                              TO_CHAR(fl.lic_start,'DDMonYYYY') start_date,
                                              TO_CHAR(fl.lic_end,'DDMonYYYY') end_date,
                                              fg.gen_title,
                                              fg.gen_title_working,
                                              xfsa.lis_con_forecast d_license_fee,
                                              (	SELECT NVL(SUM(fp.pay_amount),0)
                                                FROM fid_payment fp,
                                                  fid_payment_type fpt
                                                WHERE fpt.pat_code = fp.pay_code
                                                AND fp.pay_lic_number =fl.lic_number
                                                AND fp.pay_con_number = fcon.con_number
                                                AND fp.pay_cur_code =fl.lic_currency
                                                AND fp.pay_lsl_number =xfsl.lsl_number
                                                AND TRUNC(TO_DATE(TO_CHAR(fp.pay_date,'DD-MON-RRRR'),'DD-MON-RRRR')) <=
                                                  TRUNC(TO_DATE(TO_CHAR(TO_DATE(l_end,'DD-MON-RRRR'),'DD-MON-RRRR'),'DD-MON-RRRR'))
                                                AND fp.pay_status IN ('P', 'I')
                                                AND fpt.pat_group = 'F'
                                              ) d_paid_amount,
                                              fr.reg_code,
                                              xfsa.liab_pv_adj
                                            FROM	fid_company afc,
                                                fid_company bfc,
                                                fid_contract fcon,
                                                fid_licensee flee,
                                                fid_license fl,
                                                fid_general fg,
                                                x_fin_lic_sec_lee xfsl,
                                                x_fin_subledger_arch xfsa,
                                                fid_territory ft,
                                                fid_exchange_rate fer,
                                                fid_region fr
                                            WHERE afc.com_short_name LIKE i_com_short_name
                                            AND afc.com_type IN ('CC', 'BC')
                                            AND bfc.com_number = fcon.con_com_number
                                            AND bfc.com_short_name LIKE i_co_short_name
                                            AND fcon.con_short_name LIKE i_con_short_name
                                            AND flee.lee_cha_com_number = afc.com_number
                                            AND flee.lee_short_name LIKE i_lee_short_name
                                            AND fcon.con_number = fl.lic_con_number
                                            AND fl.lic_type LIKE i_lic_type
                                            AND fl.lic_budget_code LIKE i_lic_budget_code
                                            AND fl.lic_status NOT IN ('B', 'F', 'T')
                                            AND xfsa.lis_lic_number = xfsl.lsl_lic_number
                                            AND xfsa.lis_lsl_number = xfsl.lsl_number
                                            AND fg.gen_refno = fl.lic_gen_refno
                                            AND ft.ter_code = afc.com_ter_code
                                            AND fer.rat_cur_code = fl.lic_currency
                                            AND fer.rat_cur_code_2 = ft.ter_cur_code
                                            AND fr.reg_id(+) = flee.lee_split_region
                                            AND fr.reg_code LIKE i_reg_code
                                            AND fl.lic_number = xfsl.lsl_lic_number
                                            AND flee.lee_number = xfsl.lsl_lee_number
                                            GROUP BY ft.ter_cur_code,
                                                afc.com_number,
                                                afc.com_name,
                                                afc.com_short_name,
                                                fl.lic_currency,
                                                fl.lic_type,
                                                flee.lee_short_name,
                                                flee.lee_number,
                                                fl.lic_budget_code,
                                                bfc.com_short_name,
                                                fcon.con_short_name,
                                                afc.com_ter_code,
                                                fcon.con_number,
                                                fl.lic_number,
                                                fl.lic_amort_code,
                                                fl.lic_gen_refno,
                                                xfsl.lsl_lee_price,
                                                NVL (fer.rat_rate, 0),
                                                TO_CHAR (fl.lic_acct_date,'YYYY.MM'),
                                                TO_CHAR (fl.lic_start,'DDMonYYYY'),
                                                TO_CHAR (fl.lic_end,'DDMonYYYY'),
                                                fl.lic_gen_refno,
                                                fg.gen_title,
                                                fg.gen_title_working,
                                                fr.reg_code,
                                                xfsl.lsl_number,
                                                xfsa.lis_con_forecast,
                                                xfsa.liab_pv_adj
                                          )
                                      )
                                              WHERE ROUND ((d_license_fee - d_paid_amount), 2) -- <> 0
                                                            NOT BETWEEN  -1 AND 1 -- REQUESTED BY FIN_CR . DO NOT DISPLAY RECORD WHICH CONTAIN 1 TO -1 VALUE (Ankur kasar)
                                  )
                                  ORDER BY channel_company,
                                    lic_currency,
                                    lic_type,
                                    lee_short_name,
                                    lic_budget_code,
                                    supplier,
                                    Con_Short_Name,
                                    lic_number;
         END IF;
      END IF;

      IF UPPER (i_report_sub_type) = 'A' OR UPPER (i_report_sub_type) = 'B'
      THEN
         OPEN o_fin_payment FOR
            SELECT   channel_company, lic_currency, period, exchange_rate,
                     ter_cur_code, lic_type, lee_short_name, lic_budget_code,
                     SUPPLER "SUPPLIER", CON_SHORT_NAME, LIC_NUMBER,
                     gen_title, acct_date, lic_start, lic_end, lic_price,
                     fee, paid, liab, loc_liab, lic_amort_code, reg_code
                FROM exl_outstanding_liability_dtls
            ORDER BY channel_company,
                     lic_currency,
                     lic_type,
                     lee_short_name,
                     lic_budget_code,
                     suppler,
                     con_short_name,
                     lic_number;
      END IF;

      IF UPPER (i_report_sub_type) = 'C'
      THEN
         OPEN o_fin_payment FOR
            SELECT   channel_company, lic_currency, period, exchange_rate,
                     ter_cur_code, lic_type, lee_short_name, lic_budget_code,
                     suppler "SUPPLIER", con_short_name, lic_number,
                     gen_title, acct_date, lic_start, lic_end, lic_price,
                     fee, discount_rate "DISCOUNT_RATE", pv_adj "PV_ADJ",
                     loc_pv_adj "LOC_PV_ADJ", lic_amort_code, reg_code
                FROM exl_outstanding_liability_dtls
            ORDER BY channel_company,
                     lic_currency,
                     lic_type,
                     lee_short_name,
                     lic_budget_code,
                     suppler,
                     con_short_name,
                     lic_number;
      END IF;

      IF UPPER (i_report_sub_type) = 'D'
      THEN
         OPEN o_fin_payment FOR
            SELECT   channel_company, lic_currency, period, exchange_rate,
                     ter_cur_code, lic_type, lee_short_name, lic_budget_code,
                     suppler "SUPPLIER", con_short_name, lic_number,
                     gen_title, acct_date, lic_start, lic_end, lic_price,
                     fee, paid "PAID", liab, loc_liab, pv_adj "PV_ADJ",
                     loc_pv_adj "LOC_PV_ADJ", close_liab "CLOSE_LIAB",
                     loc_close_liab "LOC_CLOSE_LIAB", lic_amort_code,
                     reg_code
                FROM exl_outstanding_liability_dtls
            ORDER BY channel_company,
                     lic_currency,
                     lic_type,
                     lee_short_name,
                     lic_budget_code,
                     suppler,
                     con_short_name,
                     lic_number;
      END IF;

      IF (UPPER (i_report_type) = 'M')
      THEN
         OPEN o_fin_payment FOR
            SELECT   ter_cur_code, channel_company, lic_currency, lic_type,
                     lee_short_name, lic_budget_code, com_ter_code,
                     lic_con_number, lic_number,
                     ROUND (NVL (exh_is, 0)) m_exh,
                     ROUND (fee_is) m_license_fee,
                     ROUND (TOTAL_PAID_IS) M_AMT_PAID, EX_RATE M_EXH_RATE,
                     TO_CHAR (i_period, 'Mon-yyyy') period
                --i_period
            FROM     (SELECT   ft.ter_cur_code, afc.com_name channel_company,
                               fl.lic_currency, fl.lic_type,
                               flee.lee_short_name, fl.lic_budget_code,
                               afc.com_ter_code, fl.lic_con_number,
                               fl.lic_number,
                               NVL (SUM (flv.lis_con_fc_imu), 0) fee_is,
                               (SELECT NVL (SUM (fp.pay_amount),
                                            0
                                           )
                                  FROM fid_payment fp, fid_payment_type fpt
                                 WHERE fpt.pat_code = fp.pay_code
                                   AND fp.pay_lic_number = fl.lic_number
                                   AND fp.pay_con_number = fl.lic_con_number
                                   AND fp.pay_cur_code = fl.lic_currency
                                   AND (TO_DATE (TO_CHAR (fp.pay_status_date,
                                                          'DD-MON-RRRR'
                                                         ),
                                                 'DD-MON-RRRR'
                                                )
                                           BETWEEN TO_DATE
                                                      (TO_CHAR (l_start,
                                                                'DD-MON-RRRR'
                                                               ),
                                                       'DD-MON-RRRR'
                                                      )
                                               AND TO_DATE
                                                      (TO_CHAR (l_end,
                                                                'DD-MON-RRRR'
                                                               ),
                                                       'DD-MON-RRRR'
                                                      )
                                       )
                                   AND fp.pay_status IN ('P', 'I')
                                   AND fpt.pat_group = 'F') total_paid_is,
                               NVL (fer.rat_rate, 0) ex_rate,
                               TO_CHAR (fl.lic_end, 'DDMonYYYY')
                          FROM fid_company afc,
                               fid_company bfc,
                               fid_contract fcon,
                               fid_licensee flee,
                               fid_license fl,
                               fid_territory ft,
                               fid_exchange_rate fer,
                               --fid_lis_vw flv
                               x_mv_subledger_data flv
                         WHERE flee.lee_cha_com_number = afc.com_number
                           AND afc.com_ter_code = ft.ter_code
                           AND fl.lic_lee_number = flee.lee_number
                           AND fcon.con_number = fl.lic_con_number
                           AND bfc.com_number = fcon.con_com_number
                           AND afc.com_type IN ('CC', 'BC')
                           AND flv.lis_lic_number = fl.lic_number
                           --AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <= TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'))
                           AND flv.lis_yyyymm_num <=
                                      TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'))
                           AND fer.rat_cur_code = fl.lic_currency
                           AND fer.rat_cur_code_2 = ft.ter_cur_code
                           AND ft.ter_code = afc.com_ter_code
                           AND afc.com_short_name LIKE i_com_short_name
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_lee_short_name
                           AND fl.lic_budget_code LIKE i_lic_budget_code
                           AND bfc.com_short_name LIKE i_co_short_name
                           AND fcon.con_short_name LIKE i_con_short_name
                           AND fl.lic_acct_date <= l_end
                           AND EXISTS (
                                  SELECT NULL
                                    FROM x_mv_subledger_data mvlsl
                                   WHERE mvlsl.lis_lic_number = fl.lic_number
                                     AND mvlsl.lis_yyyymm_num <=
                                            TO_NUMBER (TO_CHAR (i_period,
                                                                'YYYYMM'
                                                               )
                                                      ))
                           AND fl.lic_status NOT IN ('B', 'F', 'T')
                           AND fl.lic_start <= LAST_DAY (i_period)
                      GROUP BY ft.ter_cur_code,
                               afc.com_name,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               afc.com_ter_code,
                               fl.lic_number,
                               fl.lic_con_number,
                               TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                               NVL (fer.rat_rate, 0)) a
                     LEFT JOIN
                     (SELECT sch_lic_number, NVL (sch_paid, 0) exh_is
                        FROM fid_sch_summary_vw
                       WHERE TO_CHAR (sch_year) || TO_CHAR (sch_month, '09') =
                                                  TO_CHAR (i_period, 'YYYYMM')) b
                     ON sch_lic_number = lic_number
            ORDER BY channel_company,
                     lic_currency,
                     lic_type,
                     lee_short_name,
                     lic_budget_code;
      END IF;
   END prc_fin_fee_liab_exp_to_exl;
   
  PROCEDURE prc_fee_liab_exp_paymonth_per (
      i_report_type         IN       VARCHAR2,
      i_calculate_summary   IN       VARCHAR2,
      i_com_short_name      IN       fid_company.com_short_name%TYPE,
      i_lic_type            IN       fid_license.lic_type%TYPE,
      i_lee_short_name      IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code     IN       fid_license.lic_budget_code%TYPE,
      i_co_short_name       IN       fid_company.com_short_name%TYPE,
      i_con_short_name      IN       fid_contract.con_short_name%TYPE,
      i_licenses_in_out     IN       VARCHAR2,
      i_include_zeros       IN       VARCHAR2,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      i_type                IN       VARCHAR2,
      -- for a period or Consolidated
      i_report_sub_type     IN       VARCHAR2,                       --4 types
      i_rate_type           IN       VARCHAR2,             -- M rate or R rate
      i_from_date           IN       DATE,                       --period from
      i_to_date             IN       DATE,                        -- period to
      --Dev2: Pure Finance :End
      i_period              IN       DATE,
      i_reg_code            IN       fid_region.reg_code%TYPE,     --For Split
      o_fin_paymonth_per    OUT      pkg_fin_mnet_out_liab_rpt.fin_payment_cursor
   )
   AS
      e_no_period_date    EXCEPTION;
      stmt_str            VARCHAR2 (5000);
      l_period            VARCHAR2 (20);
      temp_period         VARCHAR2 (20);
      last_date           VARCHAR2 (20);
      first_date          VARCHAR2 (20);
      liab_summary_date   VARCHAR2 (20);
      l_temp_period       DATE;
      l_start             DATE;
      l_end               DATE;
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      l_year              NUMBER;
      l_month             NUMBER;
      l_last_day          DATE;
      l_first_day         DATE;
      l_rsa_ratedate      DATE;
      l_afr_ratedate      DATE;
      v_go_live_date      DATE;
      l_disc_rate         NUMBER;
      l_gtt_count         NUMBER;
      l_trc_query         VARCHAR2 (500);
   --Dev2: Pure Finance :End
   BEGIN
      SELECT TO_CHAR (i_period, 'YYYYMM')
        INTO temp_period
        FROM DUAL;

      SELECT TO_CHAR (i_period, 'YYYY.MM')
        INTO liab_summary_date
        FROM DUAL;

      SELECT TRUNC (i_period, 'MON'), TRUNC (LAST_DAY (i_period))
        INTO l_start, l_end
        FROM DUAL;

      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/4/23]
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      --l_month := TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'MM'));
      -- l_year :=  TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'YYYY'));
      l_month := TO_NUMBER (TO_CHAR (i_period, 'MM'));
      l_year := TO_NUMBER (TO_CHAR (i_period, 'YYYY'));

      --[last day of to_date input parameter for repiort type for a period]
      SELECT LAST_DAY (i_to_date)
        INTO l_last_day
        FROM DUAL;

      --[first day  of from_date input parameter for report type "for a period"]
      SELECT ADD_MONTHS (LAST_DAY (i_from_date), -1) + 1
        INTO l_first_day
        FROM DUAL;

------------------Calculate Rate Date ---------------------------------------------------------------------------
      IF UPPER (i_reg_code) = 'RSA'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE fmd_month = l_month
               AND fmd_year = l_year
               AND reg_id = fmd_region
               AND UPPER (fmd_mon_end_type) = 'FINAL'
               AND UPPER (reg_code) = i_reg_code;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;
      ELSIF UPPER (i_reg_code) = 'AFR'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE fmd_month = l_month
               AND fmd_year = l_year
               AND reg_id = fmd_region
               AND UPPER (fmd_mon_end_type) = 'FINAL'
               AND UPPER (reg_code) = i_reg_code;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_afr_ratedate := NULL;
         END;
      ELSE
         BEGIN
            SELECT fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE fmd_month = l_month
               AND fmd_year = l_year
               AND reg_id = fmd_region
               AND UPPER (fmd_mon_end_type) = 'FINAL'
               AND UPPER (reg_code) = 'RSA';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;

         BEGIN
            SELECT fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE fmd_month = l_month
               AND fmd_year = l_year
               AND reg_id = fmd_region
               AND UPPER (fmd_mon_end_type) = 'FINAL'
               AND UPPER (reg_code) = 'AFR';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_afr_ratedate := NULL;
         END;
      END IF;

----------------------------------------------------------------------------
-- TO SELECT DISCOUNT RATE - for specific month and year
      BEGIN
         SELECT drm_disc_per_anl
           INTO l_disc_rate
           FROM x_fin_disc_rate
          WHERE drm_year = l_year AND drm_month = l_month;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_disc_rate := NULL;
      END;

      --Dev2: Pure Finance :End
      DBMS_OUTPUT.put_line ('l_afr_ratedate-' || l_afr_ratedate);
      DBMS_OUTPUT.put_line ('l_rsa_ratedate-' || l_rsa_ratedate);
      DBMS_OUTPUT.put_line ('l_last_day-' || l_last_day);
      DBMS_OUTPUT.put_line ('L_FIRST_DAY-' || l_first_day);
      DBMS_OUTPUT.put_line ('L_START-' || l_start);
      DBMS_OUTPUT.put_line ('L_END-' || l_end);

      --DELETE FROM exl_outstanding_liability_dtls;
      EXECUTE IMMEDIATE ('TRUNCATE TABLE exl_outstanding_liability_dtls');

      l_trc_query := 'TRUNCATE TABLE x_fin_subledger_arch';

      EXECUTE IMMEDIATE l_trc_query;
    IF nvl(i_con_short_name,'%') <> '%'
    then

          INSERT      /*+APPEND*/INTO x_fin_subledger_arch
            ( lis_lic_number
              , lis_lsl_number
              , lis_con_forecast
              , liab_pv_adj
             )
             SELECT   lis_lic_number
                      , lis_lsl_number,
                      --nvl(sum(lis_con_forecast),0) lis_con_forecast,
                      ROUND (  ROUND (SUM (lis_con_forecast), 2)
                              * ((100 + NVL (lic_markup_percent, 0)) / 100),
                              2) lis_con_forecast,     --LIS_CON_FC_IMU
                      NVL (SUM (lis_pv_con_forecast), 0)                      --LIS_PV_CON_FC_EMU
                          - NVL (SUM (lis_pv_con_liab_actual), 0) liab_pv_adj       --LIS_PV_CON_LIAB_AC_EMU
            FROM fid_license_sub_ledger, fid_license
            WHERE lic_number = lis_lic_number
            AND lis_per_year || LPAD (lis_per_month, 2, 0) <=  TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'))
            group by lis_lic_number, lis_lsl_number,lic_markup_percent;

    else
		  INSERT      /*+APPEND*/INTO x_fin_subledger_arch
					  (lis_lic_number, lis_lsl_number, lis_con_forecast,
					   liab_pv_adj)
			 /*SELECT   lis_lic_number, lis_lsl_number,
			 --nvl(sum(lis_con_forecast),0) lis_con_forecast,
			 ROUND (  ROUND (SUM (lis_con_forecast), 2)
			 * ((100 + NVL (lic_markup_percent, 0)) / 100),
			 2
			 ) lis_con_forecast,
			 NVL (SUM (lis_pv_con_forecast), 0)
			 - NVL (SUM (lis_pv_con_liab_actual), 0) liab_pv_adj
			 FROM fid_license_sub_ledger, fid_license
			 WHERE lic_number = lis_lic_number
			 AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
			 TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'))
			 GROUP BY lis_lic_number, lis_lsl_number, lic_markup_percent; */
			 SELECT   lis_lic_number, lis_lsl_number,
					  ROUND (SUM (lis_con_fc_imu), 2),
					  ROUND (SUM (lis_pv_con_fc_emu)
							 - SUM (lis_pv_con_liab_ac_emu),
							 2
							)
				 FROM x_mv_subledger_data
				WHERE lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'))
			 GROUP BY lis_lic_number, lis_lsl_number;
	end if;
      COMMIT;

      IF (UPPER (i_report_type) = 'D')                                  -- exl
      THEN
         IF i_include_zeros = 'Y'
         THEN
            OPEN o_fin_paymonth_per FOR
               SELECT   a.*, b.lpy_pay_percent, b.lpy_pay_month
                   FROM (SELECT channel_company, lic_currency,
                                --TO_CHAR (i_period,
                                --         'YYYY/MM/DD HH:MI:SS'
                                 --       ) period,
                                TO_CHAR(i_period, 'DD-MON-RRRR') period,
                                exchange_rate, ter_cur_code, lic_type,
                                lee_short_name, lic_budget_code,
                                com_short_name supplier, con_short_name,
                                lic_number, gen_title, gen_title_working,
                                acct acct_date, start_date lic_start,
                                end_date lic_end,
                                ROUND (lic_price, 2) lic_price,
                                d_license_fee fee, d_paid_amount paid,
                                d_lia_amount liab,
                                d_liab_local_amount loc_liab,
                                lic_amort_code lic_amort_code, reg_code,

                                --Pure Finance :Start :Anuja_Shinde[01/11/2013]
                                --[for PV ED Content Liab]
                                liab_pv_adj, loc_liab_pv_adj, liab_closing,
                                loc_liab_closing, discountrate
                           FROM (SELECT ter_cur_code, com_number,
                                        channel_company, com_short_name1,
                                        lic_currency, lic_type,
                                        lee_short_name, lee_number,
                                        lic_budget_code, com_short_name,
                                        con_short_name, com_ter_code,
                                        lic_number, con_number,
                                        (SELECT gen_title
                                           FROM fid_general
                                          WHERE gen_refno =
                                                      lic_gen_refno)
                                                                    gen_title,
                                        (SELECT gen_title_working
                                           FROM fid_general
                                          WHERE gen_refno =
                                                   lic_gen_refno)
                                                            gen_title_working,
                                        lic_amort_code,
                                                       /*(SELECT lsl_lee_price
                                                       FROM x_fin_lic_sec_lee lsl
                                                       WHERE lsl.lsl_number =
                                                       lsl_number
                                                       AND lsl.lsl_lic_number = lic_number)*/
                                                       lic_price, lsl_number,
                                        acct, start_date,
                                        to_char(end_date,'DD/MM/YYYY') end_date,
                                        d_programme, d_license_fee,
                                        d_paid_amount, reg_code, liab_pv_adj,
                                        (liab_pv_adj * exchange_rate
                                        ) loc_liab_pv_adj,
                                        (  (d_license_fee - d_paid_amount)
                                         + liab_pv_adj
                                        ) liab_closing,
                                        (  (  (d_license_fee - d_paid_amount
                                              )
                                            + liab_pv_adj
                                           )
                                         * exchange_rate
                                        ) loc_liab_closing,
                                        exchange_rate,
                                        pkg_fin_mnet_out_liab_rpt.calc_liab_local_amount
                                           (lic_number,
                                            lsl_number,
                                            exchange_rate,
                                            (d_license_fee - d_paid_amount
                                            ),
                                            v_go_live_date,
                                            i_period
                                           ) d_liab_local_amount,
                                        (d_license_fee - d_paid_amount
                                        ) d_lia_amount,
                                        l_rsa_ratedate rsa_ratedate,
                                        DECODE
                                           (i_rate_type,
                                            'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                l_rsa_ratedate
                                                               ),
                                            'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                (lic_currency,
                                                                 ter_cur_code,
                                                                 l_last_day
                                                                )
                                           ) rsa_spotrate,
                                        l_afr_ratedate afr_ratedate,
                                        DECODE
                                           (i_rate_type,
                                            'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                l_afr_ratedate
                                                               ),
                                            'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                (lic_currency,
                                                                 ter_cur_code,
                                                                 l_last_day
                                                                )
                                           ) afr_spotrate,
                                        l_disc_rate discountrate
                                   FROM (SELECT ter_cur_code, com_number,
                                                channel_company,
                                                com_short_name1, lic_currency,
                                                lic_type, lee_short_name,
                                                lee_number, lic_budget_code,
                                                com_short_name,
                                                con_short_name, com_ter_code,
                                                con_number, lic_number,
                                                lic_amort_code, lic_gen_refno,
                                                lic_price, lsl_number, acct,
                                                start_date, end_date,
                                                d_programme, d_license_fee,
                                                d_paid_amount, reg_code,
                                                liab_pv_adj,
                                                pkg_fin_mnet_out_liab_rpt.get_exchange_rate
                                                   (lic_type,
                                                    lic_currency,
                                                    lic_number,
                                                    lsl_number,
                                                    i_period,
                                                    v_go_live_date,
                                                    ter_cur_code,
                                                    l_last_day,
                                                    l_rsa_ratedate,
                                                    i_report_sub_type,
                                                    i_rate_type,
                                                    rat_rate,
                                                    l_afr_ratedate,
                                                    (  d_license_fee
                                                     - d_paid_amount
                                                    )
                                                   ) exchange_rate
                                           FROM (SELECT   ft.ter_cur_code,
                                                          afc.com_number,
                                                          TRIM
                                                             (afc.com_name
                                                             )
                                                              channel_company,
                                                          TRIM
                                                             (afc.com_short_name
                                                             )
                                                              com_short_name1,
                                                          fl.lic_currency,
                                                          fl.lic_type,
                                                          flee.lee_short_name,
                                                          flee.lee_number,
                                                          fl.lic_budget_code,
                                                          bfc.com_short_name
                                                               com_short_name,
                                                          fcon.con_short_name,
                                                          afc.com_ter_code,
                                                          fcon.con_number,
                                                          fl.lic_number,
                                                          fl.lic_amort_code,
                                                          fl.lic_gen_refno,
                                                          xfsl.lsl_lee_price
                                                                    lic_price,
                                                          xfsl.lsl_number,
                                                          NVL
                                                             (fer.rat_rate,
                                                              0
                                                             ) rat_rate,
                                                          TO_CHAR
                                                             (fl.lic_acct_date,
                                                              'YYYY.MM'
                                                             ) acct,
                                                          TO_CHAR
                                                             (fl.lic_start,
                                                              'DD-MON-RRRR'
                                                             ) start_date,
                                                          TO_CHAR
                                                             (fl.lic_end,
                                                              'DD-MON-RRRR'
                                                             ) end_date,
                                                          fg.gen_title
                                                                  d_programme,
                                                          (SELECT xfsa.lis_con_forecast
                                                             FROM x_fin_subledger_arch xfsa
                                                            WHERE xfsa.lis_lic_number =
                                                                     fl.lic_number
                                                              AND xfsa.lis_lsl_number =
                                                                     xfsl.lsl_number)
                                                                d_license_fee,
                                                          (SELECT NVL
                                                                     (SUM
                                                                         (fp.pay_amount
                                                                         ),
                                                                      0
                                                                     )
                                                             FROM fid_payment fp,
                                                                  fid_payment_type fpt
                                                            WHERE fpt.pat_code =
                                                                     fp.pay_code
                                                              AND fp.pay_lic_number =
                                                                     fl.lic_number
                                                              AND fp.pay_con_number =
                                                                     fcon.con_number
                                                              AND fp.pay_cur_code =
                                                                     fl.lic_currency
                                                              AND fp.pay_lsl_number =
                                                                     xfsl.lsl_number
                                                              AND TRUNC
                                                                     (TO_DATE
                                                                         (TO_CHAR
                                                                             (fp.pay_date,
                                                                              'DD-MON-RRRR'
                                                                             ),
                                                                          'DD-MON-RRRR'
                                                                         )
                                                                     ) <=
                                                                     TRUNC
                                                                        (TO_DATE
                                                                            (TO_CHAR
                                                                                (TO_DATE
                                                                                    (l_end,
                                                                                     'DD-MON-RRRR'
                                                                                    ),
                                                                                 'DD-MON-RRRR'
                                                                                ),
                                                                             'DD-MON-RRRR'
                                                                            )
                                                                        )
                                                              AND fp.pay_status IN
                                                                     ('P',
                                                                      'I')
                                                              AND fpt.pat_group =
                                                                           'F')
                                                                d_paid_amount,
                                                          fr.reg_code,
                                                          (SELECT liab_pv_adj
                                                             FROM x_fin_subledger_arch
                                                            WHERE lis_lic_number =
                                                                     lic_number
                                                              AND lis_lsl_number =
                                                                     lsl_number)
                                                                  liab_pv_adj
                                                     FROM fid_company afc,
                                                          fid_company bfc,
                                                          fid_contract fcon,
                                                          fid_licensee flee,
                                                          fid_license fl,
                                                          fid_general fg,
                                                          x_fin_lic_sec_lee xfsl,
                                                          fid_territory ft,
                                                          fid_exchange_rate fer,
                                                          fid_region fr
                                                    WHERE afc.com_short_name LIKE
                                                              i_com_short_name
                                                      AND afc.com_type IN
                                                                 ('CC', 'BC')
                                                      AND bfc.com_number =
                                                             fcon.con_com_number
                                                      AND bfc.com_short_name LIKE
                                                               i_co_short_name
                                                      AND fcon.con_short_name LIKE
                                                              i_con_short_name
                                                      AND flee.lee_cha_com_number =
                                                                afc.com_number
                                                      AND flee.lee_short_name LIKE
                                                              i_lee_short_name
                                                      AND fcon.con_number =
                                                             fl.lic_con_number
                                                      AND fl.lic_type LIKE
                                                                    i_lic_type
                                                      AND fl.lic_budget_code LIKE
                                                             i_lic_budget_code
                                                      AND fl.lic_acct_date <=
                                                             LAST_DAY
                                                                     (i_period)
                                                      AND fl.lic_status NOT IN
                                                              ('B', 'F', 'T')
                                                      --AND fl.lic_status NOT LIKE 'F'
                                                      AND EXISTS (
                                                             SELECT NULL
                                                               FROM x_fin_subledger_arch xfsa
                                                              WHERE xfsa.lis_lic_number =
                                                                       fl.lic_number
                                                                AND xfsa.lis_lsl_number =
                                                                       xfsl.lsl_number)
                                                      AND fg.gen_refno =
                                                              fl.lic_gen_refno
                                                      AND ft.ter_code =
                                                              afc.com_ter_code
                                                      AND fer.rat_cur_code =
                                                               fl.lic_currency
                                                      AND fer.rat_cur_code_2 =
                                                               ft.ter_cur_code
                                                      AND fr.reg_id(+) =
                                                             flee.lee_split_region
                                                      AND fr.reg_code LIKE
                                                                    i_reg_code
                                                      AND fl.lic_number =
                                                             xfsl.lsl_lic_number
                                                      AND flee.lee_number =
                                                             xfsl.lsl_lee_number
                                                      AND (TO_CHAR
                                                              (fl.lic_acct_date,
                                                               'YYYYMM'
                                                              )
                                                              BETWEEN DECODE
                                                                        (i_type,
                                                                         'P', TO_CHAR
                                                                            (l_first_day,
                                                                             'YYYYMM'
                                                                            ),
                                                                         TO_CHAR
                                                                            (fl.lic_acct_date,
                                                                             'YYYYMM'
                                                                            )
                                                                        )
                                                                  AND DECODE
                                                                        (i_type,
                                                                         'P', TO_CHAR
                                                                            (l_last_day,
                                                                             'YYYYMM'
                                                                            ),
                                                                         TO_CHAR
                                                                            (l_end,
                                                                             'YYYYMM'
                                                                            )
                                                                        )
                                                          )
                                                 GROUP BY ft.ter_cur_code,
                                                          afc.com_number,
                                                          afc.com_name,
                                                          afc.com_short_name,
                                                          fl.lic_currency,
                                                          fl.lic_type,
                                                          flee.lee_short_name,
                                                          flee.lee_number,
                                                          fl.lic_budget_code,
                                                          bfc.com_short_name,
                                                          fcon.con_short_name,
                                                          afc.com_ter_code,
                                                          fcon.con_number,
                                                          fl.lic_number,
                                                          fl.lic_amort_code,
                                                          fl.lic_gen_refno,
                                                          xfsl.lsl_lee_price,
                                                          NVL (fer.rat_rate,
                                                               0),
                                                          TO_CHAR
                                                             (fl.lic_acct_date,
                                                              'YYYY.MM'
                                                             ),
                                                          TO_CHAR
                                                                (fl.lic_start,
                                                                 'DD-MON-RRRR'
                                                                ),
                                                          TO_CHAR (fl.lic_end,
                                                                   'DD-MON-RRRR'
                                                                  ),
                                                          fg.gen_title,
                                                          fr.reg_code,
                                                          xfsl.lsl_number)))) a,
                        fid_license_payment_months b
                  WHERE a.lic_number = b.lpy_lic_number
               ORDER BY channel_company,
                        lic_currency,
                        lic_type,
                        lee_short_name,
                        lic_budget_code,
                        con_short_name,
                        lic_number;
         ELSIF i_include_zeros = 'N'
         THEN
            OPEN o_fin_paymonth_per FOR
               SELECT   a.*, b.lpy_pay_percent, to_char(b.lpy_pay_month,'DD-MON-RRRR') lpy_pay_month
                   FROM (SELECT channel_company, lic_currency,
                                TO_CHAR (i_period,
                                         'DD-MON-RRRR'
                                        ) period,
                                exchange_rate, ter_cur_code, lic_type,
                                lee_short_name, lic_budget_code,
                                com_short_name supplier, con_short_name,
                                lic_number, gen_title, gen_title_working,
                                acct acct_date, start_date lic_start,
                                end_date lic_end,
                                ROUND (lic_price, 2) lic_price,
                                d_license_fee fee, d_paid_amount paid,
                                d_lia_amount liab,
                                d_liab_local_amount loc_liab,
                                lic_amort_code lic_amort_code, reg_code,
                                liab_pv_adj, loc_liab_pv_adj, liab_closing,
                                loc_liab_closing, discountrate
                           FROM (SELECT ter_cur_code, com_number,
                                        channel_company, com_short_name1,
                                        lic_currency, lic_type,
                                        lee_short_name, lee_number,
                                        lic_budget_code, com_short_name,
                                        con_short_name, com_ter_code,
                                        lic_number, con_number,
                                        (SELECT gen_title
                                           FROM fid_general
                                          WHERE gen_refno =
                                                      lic_gen_refno)
                                                                    gen_title,
                                        (SELECT gen_title_working
                                           FROM fid_general
                                          WHERE gen_refno =
                                                   lic_gen_refno)
                                                            gen_title_working,
                                        lic_amort_code,
                                                       /*(SELECT lsl_lee_price
                                                       FROM x_fin_lic_sec_lee lsl
                                                       WHERE lsl.lsl_number =
                                                       lsl_number
                                                       AND lsl.lsl_lic_number = lic_number)*/
                                                       lic_price, lsl_number,
                                        acct, start_date, end_date,
                                        d_programme, d_license_fee,
                                        d_paid_amount, reg_code, liab_pv_adj,
                                        (liab_pv_adj * exchange_rate
                                        ) loc_liab_pv_adj,
                                        (  (d_license_fee - d_paid_amount)
                                         + liab_pv_adj
                                        ) liab_closing,
                                        (  (  (d_license_fee - d_paid_amount
                                              )
                                            + liab_pv_adj
                                           )
                                         * exchange_rate
                                        ) loc_liab_closing,
                                        exchange_rate,
                                        pkg_fin_mnet_out_liab_rpt.calc_liab_local_amount
                                           (lic_number,
                                            lsl_number,
                                            exchange_rate,
                                            (d_license_fee - d_paid_amount
                                            ),
                                            v_go_live_date,
                                            i_period
                                           ) d_liab_local_amount,
                                        (d_license_fee - d_paid_amount
                                        ) d_lia_amount,
                                        l_rsa_ratedate rsa_ratedate,
                                        DECODE
                                           (i_rate_type,
                                            'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                l_rsa_ratedate
                                                               ),
                                            'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                (lic_currency,
                                                                 ter_cur_code,
                                                                 l_last_day
                                                                )
                                           ) rsa_spotrate,
                                        l_afr_ratedate afr_ratedate,
                                        DECODE
                                           (i_rate_type,
                                            'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                l_afr_ratedate
                                                               ),
                                            'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                (lic_currency,
                                                                 ter_cur_code,
                                                                 l_last_day
                                                                )
                                           ) afr_spotrate,
                                        l_disc_rate discountrate
                                   FROM (SELECT ter_cur_code, com_number,
                                                channel_company,
                                                com_short_name1, lic_currency,
                                                lic_type, lee_short_name,
                                                lee_number, lic_budget_code,
                                                com_short_name,
                                                con_short_name, com_ter_code,
                                                con_number, lic_number,
                                                lic_amort_code, lic_gen_refno,
                                                lic_price, lsl_number, acct,
                                                start_date, end_date,
                                                d_programme, d_license_fee,
                                                d_paid_amount, reg_code,
                                                liab_pv_adj,
                                                pkg_fin_mnet_out_liab_rpt.get_exchange_rate
                                                   (lic_type,
                                                    lic_currency,
                                                    lic_number,
                                                    lsl_number,
                                                    i_period,
                                                    v_go_live_date,
                                                    ter_cur_code,
                                                    l_last_day,
                                                    l_rsa_ratedate,
                                                    i_report_sub_type,
                                                    i_rate_type,
                                                    rat_rate,
                                                    l_afr_ratedate,
                                                    (  d_license_fee
                                                     - d_paid_amount
                                                    )
                                                   ) exchange_rate
                                           FROM (SELECT   ft.ter_cur_code,
                                                          afc.com_number,
                                                          TRIM
                                                             (afc.com_name
                                                             )
                                                              channel_company,
                                                          TRIM
                                                             (afc.com_short_name
                                                             )
                                                              com_short_name1,
                                                          fl.lic_currency,
                                                          fl.lic_type,
                                                          flee.lee_short_name,
                                                          flee.lee_number,
                                                          fl.lic_budget_code,
                                                          bfc.com_short_name
                                                               com_short_name,
                                                          fcon.con_short_name,
                                                          afc.com_ter_code,
                                                          fcon.con_number,
                                                          fl.lic_number,
                                                          fl.lic_amort_code,
                                                          fl.lic_gen_refno,
                                                          xfsl.lsl_lee_price
                                                                    lic_price,
                                                          xfsl.lsl_number,
                                                          NVL
                                                             (fer.rat_rate,
                                                              0
                                                             ) rat_rate,
                                                          TO_CHAR
                                                             (fl.lic_acct_date,
                                                              'YYYY.MM'
                                                             ) acct,
                                                          TO_CHAR
                                                             (fl.lic_start,'DD-MON-RRRR'
                                                              --'DDMonYYYY'
                                                             ) start_date,
                                                          TO_CHAR
                                                             (fl.lic_end,'DD-MON-RRRR'
                                                              --'DDMonYYYY'
                                                             ) end_date,
                                                          fg.gen_title
                                                                  d_programme,
                                                          (SELECT xfsa.lis_con_forecast
                                                             FROM x_fin_subledger_arch xfsa
                                                            WHERE xfsa.lis_lic_number =
                                                                     fl.lic_number
                                                              AND xfsa.lis_lsl_number =
                                                                     xfsl.lsl_number)
                                                                d_license_fee,
                                                          (SELECT NVL
                                                                     (SUM
                                                                         (fp.pay_amount
                                                                         ),
                                                                      0
                                                                     )
                                                             FROM fid_payment fp,
                                                                  fid_payment_type fpt
                                                            WHERE fpt.pat_code =
                                                                     fp.pay_code
                                                              AND fp.pay_lic_number =
                                                                     fl.lic_number
                                                              AND fp.pay_con_number =
                                                                     fcon.con_number
                                                              AND fp.pay_cur_code =
                                                                     fl.lic_currency
                                                              AND fp.pay_lsl_number =
                                                                     xfsl.lsl_number
                                                              AND TRUNC
                                                                     (TO_DATE
                                                                         (TO_CHAR
                                                                             (fp.pay_date,
                                                                              'DD-MON-RRRR'
                                                                             ),
                                                                          'DD-MON-RRRR'
                                                                         )
                                                                     ) <=
                                                                     TRUNC
                                                                        (TO_DATE
                                                                            (TO_CHAR
                                                                                (TO_DATE
                                                                                    (l_end,
                                                                                     'DD-MON-RRRR'
                                                                                    ),
                                                                                 'DD-MON-RRRR'
                                                                                ),
                                                                             'DD-MON-RRRR'
                                                                            )
                                                                        )
                                                              AND fp.pay_status IN
                                                                     ('P',
                                                                      'I')
                                                              AND fpt.pat_group =
                                                                           'F')
                                                                d_paid_amount,
                                                          fr.reg_code,
                                                          (SELECT liab_pv_adj
                                                             FROM x_fin_subledger_arch xfsa
                                                            WHERE xfsa.lis_lic_number =
                                                                     fl.lic_number
                                                              AND xfsa.lis_lsl_number =
                                                                     xfsl.lsl_number)
                                                                  liab_pv_adj
                                                     FROM fid_company afc,
                                                          fid_company bfc,
                                                          fid_contract fcon,
                                                          fid_licensee flee,
                                                          fid_license fl,
                                                          fid_general fg,
                                                          x_fin_lic_sec_lee xfsl,
                                                          fid_territory ft,
                                                          fid_exchange_rate fer,
                                                          fid_region fr
                                                    WHERE afc.com_short_name LIKE
                                                              i_com_short_name
                                                      AND afc.com_type IN
                                                                 ('CC', 'BC')
                                                      AND bfc.com_number =
                                                             fcon.con_com_number
                                                      AND bfc.com_short_name LIKE
                                                               i_co_short_name
                                                      AND fcon.con_short_name LIKE
                                                              i_con_short_name
                                                      AND flee.lee_cha_com_number =
                                                                afc.com_number
                                                      AND flee.lee_short_name LIKE
                                                              i_lee_short_name
                                                      AND fcon.con_number =
                                                             fl.lic_con_number
                                                      AND fl.lic_type LIKE
                                                                    i_lic_type
                                                      AND fl.lic_budget_code LIKE
                                                             i_lic_budget_code
                                                      AND fl.lic_acct_date <=
                                                             LAST_DAY
                                                                     (i_period)
                                                      AND fl.lic_status NOT IN
                                                              ('B', 'F', 'T')
                                                      --AND fl.lic_status NOT LIKE 'F'
                                                      AND EXISTS (
                                                             SELECT NULL
                                                               FROM x_fin_subledger_arch xfsa
                                                              WHERE xfsa.lis_lic_number =
                                                                       fl.lic_number
                                                                AND xfsa.lis_lsl_number =
                                                                       xfsl.lsl_number)
                                                      AND fg.gen_refno =
                                                              fl.lic_gen_refno
                                                      AND ft.ter_code =
                                                              afc.com_ter_code
                                                      AND fer.rat_cur_code =
                                                               fl.lic_currency
                                                      AND fer.rat_cur_code_2 =
                                                               ft.ter_cur_code
                                                      AND fr.reg_id(+) =
                                                             flee.lee_split_region
                                                      AND fr.reg_code LIKE
                                                                    i_reg_code
                                                      AND fl.lic_number =
                                                             xfsl.lsl_lic_number
                                                      AND flee.lee_number =
                                                             xfsl.lsl_lee_number
                                                      AND (TO_CHAR
                                                              (fl.lic_acct_date,
                                                               'YYYYMM'
                                                              )
                                                              BETWEEN DECODE
                                                                        (i_type,
                                                                         'P', TO_CHAR
                                                                            (l_first_day,
                                                                             'YYYYMM'
                                                                            ),
                                                                         TO_CHAR
                                                                            (fl.lic_acct_date,
                                                                             'YYYYMM'
                                                                            )
                                                                        )
                                                                  AND DECODE
                                                                        (i_type,
                                                                         'P', TO_CHAR
                                                                            (l_last_day,
                                                                             'YYYYMM'
                                                                            ),
                                                                         TO_CHAR
                                                                            (l_end,
                                                                             'YYYYMM'
                                                                            )
                                                                        )
                                                          )
                                                 GROUP BY ter_cur_code,
                                                          afc.com_number,
                                                          afc.com_name,
                                                          afc.com_short_name,
                                                          fl.lic_currency,
                                                          fl.lic_type,
                                                          flee.lee_short_name,
                                                          flee.lee_number,
                                                          fl.lic_budget_code,
                                                          bfc.com_short_name,
                                                          fcon.con_short_name,
                                                          afc.com_ter_code,
                                                          fcon.con_number,
                                                          fl.lic_number,
                                                          fl.lic_amort_code,
                                                          fl.lic_gen_refno,
                                                          xfsl.lsl_lee_price,
                                                          NVL (fer.rat_rate,
                                                               0),
                                                          TO_CHAR
                                                             (fl.lic_acct_date,
                                                              'YYYY.MM'
                                                             ),
                                                          TO_CHAR
                                                                (fl.lic_start,'DD-MON-RRRR'
                                                                 --'DDMonYYYY'
                                                                ),
                                                          TO_CHAR (fl.lic_end,'DD-MON-RRRR'
                                                                   --'DDMonYYYY'
                                                                  ),
                                                          fg.gen_title,
                                                          fr.reg_code,
                                                          xfsl.lsl_number))
                                  WHERE ROUND ((d_license_fee - d_paid_amount
                                               ),
                                               2
                                              ) --<> 0)
                                              NOT BETWEEN  -1 AND 1) -- FIR CR DO NOT DISPLAY RECORD WHICH CONTAIN 1 TO -1  (Ankur kasar)
                                        ---to ignore very less liabilty amount
                                                     ) a,
                        fid_license_payment_months b
                  WHERE a.lic_number = b.lpy_lic_number
               ORDER BY channel_company,
                        lic_currency,
                        lic_type,
                        lee_short_name,
                        lic_budget_code,
                        con_short_name,
                        lic_number;
         END IF;
      END IF;
   END prc_fee_liab_exp_paymonth_per;

END PKG_FIN_MNET_OUT_LIAB_RPT;
/