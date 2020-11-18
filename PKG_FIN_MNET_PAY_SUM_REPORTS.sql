create or replace PACKAGE          "PKG_FIN_MNET_PAY_SUM_REPORTS"
AS
   TYPE fin_summary_cursor IS REF CURSOR;

   /**************************************************************************
   REM Module          : Finance - Payment Summary Report
   REM Client          : MNET/ SUPER SPORT
   REM File Name       : PKG_FIN_MNET_PAY_SUM_REPORTS
   REM Purpose         : Generate reports for payment summary
   REM Written By      : Rajan Kumar
   REM Date            : 17-02-2010
   REM Type            : Database Package
   REM Change History  : Created
   REM **************************************************************************/
   g_from_date   DATE;
   g_to_date     DATE;
   g_live_date   DATE;

   PROCEDURE set_parameter (
      p_from_date   IN   DATE,
      p_to_date     IN   DATE,
      p_live_date   IN   DATE
   );

   FUNCTION get_from_date
      RETURN DATE;

   FUNCTION get_to_date
      RETURN DATE;

   FUNCTION get_live_date
      RETURN DATE;

   PROCEDURE prc_fin_sum_reports (
      --Dev2: Pure Finance :Start:[RSA- AFR Month-end Split]_[ANUJASHINDE]_[2013/3/5]
      i_region            IN       fid_region.reg_code%TYPE,
      --Dev2: Pure Finance :End
      i_channel_company   IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_budget_code       IN       fid_license.lic_budget_code%TYPE,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_summay_report     OUT      pkg_fin_mnet_pay_sum_reports.fin_summary_cursor
   );

   FUNCTION exchange_rate (
      i_lic_cur        IN   fid_license.lic_currency%TYPE,
      i_ter_cur_code   IN   fid_territory.ter_cur_code%TYPE
   )
      RETURN NUMBER;

   -- Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/11]
   FUNCTION local_cur_relised_forex (
      i_from_date       IN   DATE,
      i_to_date         IN   DATE,
      i_lic_cur         IN   fid_license.lic_currency%TYPE,
      i_lic_type        IN   fid_license.lic_type%TYPE,
      i_lsl_number      IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_lic_budg_code   IN   fid_license.lic_budget_code%TYPE
   )
      RETURN NUMBER;

   FUNCTION prepayment_cur_relised_forex (
      i_from_date       IN   DATE,
      i_to_date         IN   DATE,
      i_lic_cur         IN   fid_license.lic_currency%TYPE,
      i_lic_type        IN   fid_license.lic_type%TYPE,
      i_lsl_number      IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_lic_budg_code   IN   fid_license.lic_budget_code%TYPE
   )
      RETURN NUMBER;
-- Dev2: Pure Finance :End
END pkg_fin_mnet_pay_sum_reports;
/
create or replace PACKAGE BODY          "PKG_FIN_MNET_PAY_SUM_REPORTS"
AS
   PROCEDURE set_parameter (
      p_from_date   IN   DATE,
      p_to_date     IN   DATE,
      p_live_date   IN   DATE
   )
   IS
   BEGIN
      g_from_date := p_from_date;
      g_to_date := p_to_date;
      g_live_date := p_live_date;
   END set_parameter;

   FUNCTION get_from_date
      RETURN DATE
   IS
   BEGIN
      RETURN g_from_date;
   END;

   FUNCTION get_to_date
      RETURN DATE
   IS
   BEGIN
      RETURN g_to_date;
   END;

   FUNCTION get_live_date
      RETURN DATE
   IS
   BEGIN
      RETURN g_live_date;
   END;

   PROCEDURE prc_fin_sum_reports (
      --Dev2: Pure Finance :Start:[RSA- AFR Month-end Split]_[ANUJASHINDE]_[2013/3/5]
      i_region            IN       fid_region.reg_code%TYPE,
      --Dev2: Pure Finance :End
      i_channel_company   IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_budget_code       IN       fid_license.lic_budget_code%TYPE,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_summay_report     OUT      pkg_fin_mnet_pay_sum_reports.fin_summary_cursor
   )
/*******************************************************************************************************************************************************
Ver       Date            Author                Description
0.0                                             Initial Version
0.1       07-Apr-2015     Jawahar Garg          Issue : Recon issue local_cur_relised_forex is not getting matched for march-15 month end.
                                                        Calculating triwe for same lsl_number due to duplicate records in inner query.
                                                        Moved it to outer select so local_cur_relised_forex will cal onces for each lsl_number.
********************************************************************************************************************************************************/
   AS
      l_live_date   DATE;
      l_fin_go_live DATE;
      l_period      VARCHAR2 (20);
   BEGIN
      SELECT TO_DATE (xfc.content,'DD-MON-RRRR')
        INTO l_fin_go_live 
        FROM x_fin_configs xfc
       WHERE KEY =  'FIN_I_LIVE_DATE';

      SELECT TO_DATE (xfc.content)
          INTO l_live_date
        FROM x_fin_configs xfc
       WHERE KEY = 'GO-LIVEDATE';

     SELECT TO_DATE (i_from_date, 'DD-MON-RRRR')
       INTO l_period
       FROM DUAL;

      set_parameter (i_from_date, i_to_date, l_live_date);

      /*Ver 0.1 Start

      /* commented in ver 0.1
      OPEN o_summay_report FOR
         SELECT   NVL (SUM (psv.fees_paid), 0) fees_paid,
                  NVL (SUM (psv.payment_pre), 0) payment_pre,
                  NVL (SUM (psv.payment_pre_adj), 0) payment_pre_adj,
                  NVL (SUM (psv.payment_liab_adj), 0) payment_liab_adj,
                  NVL (SUM (psv.payment_pre_tran), 0) payment_pre_tran,
                  NVL (SUM (psv.payment_liab_tran), 0) payment_liab_tran,
                  NVL (SUM (ROUND (psv.local_fees_paid, 4)),
                       0
                      ) local_fees_paid,
                  NVL (SUM (ROUND (psv.local_payment_pre, 4)),
                       0
                      ) local_payment_pre,
                  NVL
                     (SUM (ROUND (psv.local_payment_pre_adj, 4)),
                      0
                     ) local_payment_pre_adj,
                  NVL
                     (SUM (ROUND (psv.local_payment_liab_adj, 4)),
                      0
                     ) local_payment_liab_adj,
                  NVL
                     (SUM (ROUND (psv.local_payment_pre_tran, 4)),
                      0
                     ) local_payment_pre_tran,
                  NVL
                     (SUM (ROUND (psv.local_payment_liab_tran, 4)),
                      0
                     ) local_payment_liab_tran,
                  NVL
                     (SUM (ROUND (local_cur_relised_forex (i_from_date,
                                                           i_to_date,
                                                           fl.lic_currency,
                                                           fl.lic_type,
                                                           xfsl.lsl_number,
                                                           fl.lic_budget_code
                                                          ),
                                  4
                                 )
                          ),
                      0
                     ) local_relised_forex,
                  NVL
                     (SUM
                         (ROUND
                             (prepayment_cur_relised_forex (i_from_date,
                                                            i_to_date,
                                                            fl.lic_currency,
                                                            fl.lic_type,
                                                            xfsl.lsl_number,
                                                            fl.lic_budget_code
                                                           ),
                              4
                             )
                         ),
                      0
                     ) prepayment_cur_relised_forex,
                  fr.reg_code, fc.com_name, ft.ter_cur_code,
                  fc.com_number comnumber, fl.lic_currency liccurrency,
                  fl.lic_type, flee.lee_short_name, fl.lic_budget_code
             FROM fid_company fc,
                  fid_licensee flee,
                  fid_region fr,
                  fid_license fl,
                  x_fin_lic_sec_lee xfsl,
                  fid_territory ft,
                  x_vw_payment_sum_rep psv
            WHERE (   fc.com_short_name LIKE NVL (i_channel_company, '%')
                   OR fc.com_name LIKE NVL (i_channel_company, '%')
                  )
              AND fc.com_type IN ('CC', 'BC')
              AND flee.lee_cha_com_number = fc.com_number
              AND fc.com_ter_code = ft.ter_code
              AND fl.lic_type LIKE NVL (i_lic_type, '%')
              AND lee_short_name LIKE NVL (i_licensee, '%')
              AND fl.lic_budget_code LIKE NVL (i_budget_code, '%')
              AND xfsl.lsl_lic_number = fl.lic_number
              AND flee.lee_number = xfsl.lsl_lee_number
              AND fr.reg_id(+) = flee.lee_split_region
              /*AND NVL (reg_code, '#') LIKE
                         DECODE (i_region, '%', NVL (reg_code, '#'), i_region)
              * /
              AND NVL (fr.reg_code, '#') LIKE
                      DECODE (i_region,
                              '%', NVL (fr.reg_code, '#'),
                              i_region
                             )
              AND UPPER (lic_status) NOT IN
                     ('F', 'T')
                            --added so that t licenses should not be displayed
              AND fl.lic_number = psv.lic_number
              AND xfsl.lsl_number = psv.pay_lsl_number
              AND fl.lic_currency = psv.lic_currency
              AND fl.lic_type = psv.lic_type
              AND fl.lic_budget_code = psv.lic_budget_code
              AND fc.com_number = psv.pay_source_com_number
         GROUP BY fr.reg_code,
                  fc.com_name,
                  ft.ter_cur_code,
                  fc.com_number,
                  fl.lic_currency,
                  fl.lic_type,
                  flee.lee_short_name,
                  fl.lic_budget_code
         ORDER BY fc.com_name,
                  fl.lic_currency,
                  fl.lic_type,
                  flee.lee_short_name,
                  fl.lic_budget_code;*/
   IF l_period < l_fin_go_live
   THEN

     OPEN o_summay_report FOR
     SELECT NVL (SUM (fees_paid), 0) fees_paid,
            NVL (SUM (payment_pre), 0) payment_pre,
            NVL (SUM (payment_pre_adj), 0) payment_pre_adj,
            NVL (SUM (payment_liab_adj), 0) payment_liab_adj,
            NVL (SUM (payment_pre_tran), 0) payment_pre_tran,
            NVL (SUM (payment_liab_tran), 0) payment_liab_tran,
            NVL (SUM (ROUND (local_fees_paid, 4)),0) local_fees_paid,
            NVL (SUM (ROUND (local_payment_pre, 4)), 0 ) local_payment_pre,
            NVL (SUM (ROUND (local_payment_pre_adj, 4)), 0) local_payment_pre_adj,
            NVL (SUM (ROUND (local_payment_liab_adj, 4)), 0) local_payment_liab_adj,
            NVL (SUM (ROUND (local_payment_pre_tran, 4)), 0) local_payment_pre_tran,
            NVL (SUM (ROUND (local_payment_liab_tran, 4)), 0) local_payment_liab_tran,
            NVL
               (SUM (ROUND (PKG_FIN_MNET_PAY_SUM_REPORTS.local_cur_relised_forex (i_from_date,
                                                     i_to_date,
                                                     lic_currency,
                                                     lic_type,
                                                     lsl_number,
                                                     lic_budget_code
                                                    ),
                            4
                           )
                    ),
                0
               ) local_relised_forex,
            NVL
               (SUM
                   (ROUND
                       (PKG_FIN_MNET_PAY_SUM_REPORTS.prepayment_cur_relised_forex (i_from_date,
                                                      i_to_date,
                                                      lic_currency,
                                                      lic_type,
                                                      lsl_number,
                                                      lic_budget_code
                                                     ),
                        4
                       )
                   ),
                0
               ) prepayment_cur_relised_forex,
            reg_code,
            com_name,
            ter_cur_code,
            com_number comnumber,
            lic_currency liccurrency,
            lic_type,
            lee_short_name,
            lic_budget_code
      FROM (
           SELECT   NVL (SUM (psv.fees_paid), 0) fees_paid,
                    NVL (SUM (psv.payment_pre), 0) payment_pre,
                    NVL (SUM (psv.payment_pre_adj), 0) payment_pre_adj,
                    NVL (SUM (psv.payment_liab_adj), 0) payment_liab_adj,
                    NVL (SUM (psv.payment_pre_tran), 0) payment_pre_tran,
                    NVL (SUM (psv.payment_liab_tran), 0) payment_liab_tran,
                    NVL (SUM (psv.local_fees_paid), 0) local_fees_paid,
                    NVL (SUM (psv.local_payment_pre), 0) local_payment_pre,
                    NVL (SUM (psv.local_payment_pre_adj), 0) local_payment_pre_adj,
                    NVL (SUM (psv.local_payment_liab_adj), 0) local_payment_liab_adj,
                    NVL (SUM (psv.local_payment_pre_tran), 0) local_payment_pre_tran,
                    NVL (SUM (psv.local_payment_liab_tran), 0) local_payment_liab_tran,
                    fr.reg_code,
                    fc.com_name,
                    ft.ter_cur_code,
                    fc.com_number ,
                    fl.lic_currency ,
                    psv.pay_lsl_number as lsl_number,
                    fl.lic_type,
                    flee.lee_short_name,
                    fl.lic_budget_code
               FROM fid_company fc,
                    fid_licensee flee,
                    fid_region fr,
                    fid_license fl,
                    x_fin_lic_sec_lee xfsl,
                    fid_territory ft,
                    x_vw_payment_sum_rep psv
              WHERE (   fc.com_short_name LIKE NVL (i_channel_company, '%')
                     OR fc.com_name LIKE NVL (i_channel_company, '%')
                    )
                AND fc.com_type IN ('CC', 'BC')
                AND flee.lee_cha_com_number = fc.com_number
                AND fc.com_ter_code = ft.ter_code
                AND fl.lic_type LIKE NVL (i_lic_type, '%')
                AND lee_short_name LIKE NVL (i_licensee, '%')
                AND fl.lic_budget_code LIKE NVL (i_budget_code, '%')
                AND xfsl.lsl_lic_number = fl.lic_number
                AND flee.lee_number = xfsl.lsl_lee_number
                AND fr.reg_id(+) = flee.lee_split_region
                AND NVL (fr.reg_code, '#') LIKE
                        DECODE (i_region,
                                '%', NVL (fr.reg_code, '#'),
                                i_region
                               )
                AND UPPER (lic_status) NOT IN ('F', 'T')
                AND fl.lic_number = psv.lic_number
                AND xfsl.lsl_number = psv.pay_lsl_number
                AND fl.lic_currency = psv.lic_currency
                AND fl.lic_type = psv.lic_type
                AND fl.lic_budget_code = psv.lic_budget_code
                AND fc.com_number = psv.pay_source_com_number
                
           group by fr.reg_code,
                    fc.com_name,
                    ft.ter_cur_code,
                    fc.com_number,
                    fl.lic_currency,
                    psv.pay_lsl_number,
                    fl.lic_type,
                    flee.lee_short_name,
                    fl.lic_budget_code
      )group by reg_code,
                com_name,
                ter_cur_code,
                com_number,
                lic_currency,
                lic_type,
                lee_short_name,
                lic_budget_code
       ORDER BY com_name,
                lic_currency,
                lic_type,
                lee_short_name,
                lic_budget_code;

   ELSE
   
    OPEN o_summay_report FOR
     SELECT NVL (SUM (fees_paid), 0) fees_paid,
            NVL (SUM (payment_pre), 0) payment_pre,
            NVL (SUM (payment_pre_adj), 0) payment_pre_adj,
            NVL (SUM (payment_liab_adj), 0) payment_liab_adj,
            NVL (SUM (payment_pre_tran), 0) payment_pre_tran,
            NVL (SUM (payment_liab_tran), 0) payment_liab_tran,
            NVL (SUM (ROUND (local_fees_paid, 4)),0) local_fees_paid,
            NVL (SUM (ROUND (local_payment_pre, 4)), 0 ) local_payment_pre,
            NVL (SUM (ROUND (local_payment_pre_adj, 4)), 0) local_payment_pre_adj,
            NVL (SUM (ROUND (local_payment_liab_adj, 4)), 0) local_payment_liab_adj,
            NVL (SUM (ROUND (local_payment_pre_tran, 4)), 0) local_payment_pre_tran,
            NVL (SUM (ROUND (local_payment_liab_tran, 4)), 0) local_payment_liab_tran,
            NVL
               (SUM (ROUND (PKG_FIN_MNET_PAY_SUM_REPORTS.local_cur_relised_forex (i_from_date,
                                                     i_to_date,
                                                     lic_currency,
                                                     lic_type,
                                                     lsl_number,
                                                     lic_budget_code
                                                    ),
                            4
                           )
                    ),
                0
               ) local_relised_forex,
            NVL
               (SUM
                   (ROUND
                       (PKG_FIN_MNET_PAY_SUM_REPORTS.prepayment_cur_relised_forex (i_from_date,
                                                      i_to_date,
                                                      lic_currency,
                                                      lic_type,
                                                      lsl_number,
                                                      lic_budget_code
                                                     ),
                        4
                       )
                   ),
                0
               ) prepayment_cur_relised_forex,
            reg_code,
            com_name,
            ter_cur_code,
            com_number comnumber,
            lic_currency liccurrency,
            lic_type,
            lee_short_name,
            lic_budget_code
      FROM (
           SELECT   NVL (SUM (psv.fees_paid), 0) fees_paid,
                    NVL (SUM (psv.payment_pre), 0) payment_pre,
                    NVL (SUM (psv.payment_pre_adj), 0) payment_pre_adj,
                    NVL (SUM (psv.payment_liab_adj), 0) payment_liab_adj,
                    NVL (SUM (psv.payment_pre_tran), 0) payment_pre_tran,
                    NVL (SUM (psv.payment_liab_tran), 0) payment_liab_tran,
                    NVL (SUM (psv.local_fees_paid), 0) local_fees_paid,
                    NVL (SUM (psv.local_payment_pre), 0) local_payment_pre,
                    NVL (SUM (psv.local_payment_pre_adj), 0) local_payment_pre_adj,
                    NVL (SUM (psv.local_payment_liab_adj), 0) local_payment_liab_adj,
                    NVL (SUM (psv.local_payment_pre_tran), 0) local_payment_pre_tran,
                    NVL (SUM (psv.local_payment_liab_tran), 0) local_payment_liab_tran,
                    fr.reg_code,
                    fc.com_name,
                    ft.ter_cur_code,
                    fc.com_number ,
                    fl.lic_currency ,
                    psv.pay_lsl_number as lsl_number,
                    fl.lic_type,
                    flee.lee_short_name,
                    fl.lic_budget_code
               FROM fid_company fc,
                    fid_licensee flee,
                    fid_region fr,
                    fid_license fl,
                    x_fin_lic_sec_lee xfsl,
                    fid_territory ft,
                    x_vw_payment_sum_rep_new psv
              WHERE (   fc.com_short_name LIKE NVL (i_channel_company, '%')
                     OR fc.com_name LIKE NVL (i_channel_company, '%')
                    )
                AND fc.com_type IN ('CC', 'BC')
                AND flee.lee_cha_com_number = fc.com_number
                AND fc.com_ter_code = ft.ter_code
                AND fl.lic_type LIKE NVL (i_lic_type, '%')
                AND lee_short_name LIKE NVL (i_licensee, '%')
                AND fl.lic_budget_code LIKE NVL (i_budget_code, '%')
                AND xfsl.lsl_lic_number = fl.lic_number
                AND flee.lee_number = xfsl.lsl_lee_number
                AND fr.reg_id(+) = flee.lee_split_region
                AND NVL (fr.reg_code, '#') LIKE
                        DECODE (i_region,
                                '%', NVL (fr.reg_code, '#'),
                                i_region
                               )
                AND UPPER (lic_status) NOT IN ('F', 'T')
                AND fl.lic_number = psv.lic_number
                AND xfsl.lsl_number = psv.pay_lsl_number
                AND fl.lic_currency = psv.lic_currency
                AND fl.lic_type = psv.lic_type
                AND fl.lic_budget_code = psv.lic_budget_code
                AND fc.com_number = psv.pay_source_com_number
                
           group by fr.reg_code,
                    fc.com_name,
                    ft.ter_cur_code,
                    fc.com_number,
                    fl.lic_currency,
                    psv.pay_lsl_number,
                    fl.lic_type,
                    flee.lee_short_name,
                    fl.lic_budget_code
      )group by reg_code,
                com_name,
                ter_cur_code,
                com_number,
                lic_currency,
                lic_type,
                lee_short_name,
                lic_budget_code
       ORDER BY com_name,
                lic_currency,
                lic_type,
                lee_short_name,
                lic_budget_code;
   
   END IF;
          --Ver 0.1 END

   END prc_fin_sum_reports;

   FUNCTION exchange_rate (
      i_lic_cur        IN   fid_license.lic_currency%TYPE,
      i_ter_cur_code   IN   fid_territory.ter_cur_code%TYPE
   )
      RETURN NUMBER
   IS
      rate_is   NUMBER;

      CURSOR get_exchange_rate
      IS
         SELECT fer.rat_rate
           FROM fid_exchange_rate fer
          WHERE fer.rat_cur_code = i_lic_cur
            AND fer.rat_cur_code_2 = i_ter_cur_code;
   BEGIN
      OPEN get_exchange_rate;

      FETCH get_exchange_rate
       INTO rate_is;

      IF get_exchange_rate%NOTFOUND
      THEN
         rate_is := 1;
      END IF;

      RETURN rate_is;
   END;

   FUNCTION local_cur_relised_forex (
      i_from_date       IN   DATE,
      i_to_date         IN   DATE,
      i_lic_cur         IN   fid_license.lic_currency%TYPE,
      i_lic_type        IN   fid_license.lic_type%TYPE,
      i_lsl_number      IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_lic_budg_code   IN   fid_license.lic_budget_code%TYPE
   )
      RETURN NUMBER
   IS
      forex_is   NUMBER;
   BEGIN
      SELECT NVL (SUM (xfrf.rzf_realized_forex), 0)
        INTO forex_is
        FROM x_fin_realized_forex xfrf, fid_license fl, fid_payment fp
       WHERE fl.lic_number(+) = NVL (xfrf.rzf_lic_number, 0)
         AND fp.pay_lic_number = fl.lic_number
         AND fp.pay_lsl_number = i_lsl_number
         AND fl.lic_currency = i_lic_cur
         AND fl.lic_type = i_lic_type
         AND xfrf.rzf_lsl_number = i_lsl_number
         AND fl.lic_budget_code = i_lic_budg_code
         AND xfrf.rzf_pay_number = fp.pay_number
         AND xfrf.rzf_account_head <> UPPER ('ED')
         AND PAY_TYPE = 'PP'
         AND (CONCAT (xfrf.rzf_year, LPAD (xfrf.rzf_month, 2, 0)))
                BETWEEN (   TO_CHAR (TO_DATE (i_from_date), 'YYYY')
                         || TO_CHAR (TO_DATE (i_from_date), 'MM')
                        )
                    AND (   TO_CHAR (TO_DATE (i_to_date), 'YYYY')
                         || TO_CHAR (TO_DATE (i_to_date), 'MM')
                        );

      RETURN forex_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         forex_is := 0;
         RETURN forex_is;
   END;

   FUNCTION prepayment_cur_relised_forex (
      i_from_date       IN   DATE,
      i_to_date         IN   DATE,
      i_lic_cur         IN   fid_license.lic_currency%TYPE,
      i_lic_type        IN   fid_license.lic_type%TYPE,
      i_lsl_number      IN   x_fin_lic_sec_lee.lsl_number%TYPE,
      i_lic_budg_code   IN   fid_license.lic_budget_code%TYPE
   )
      RETURN NUMBER
   IS
      forex_is   NUMBER;
   BEGIN
      SELECT NVL (SUM (rzf_realized_forex), 0)
        INTO forex_is
        FROM x_fin_realized_forex xfrf, fid_license fl, fid_payment fp
       WHERE fl.lic_number(+) = NVL (xfrf.rzf_lic_number, 0)
         AND fp.pay_lic_number = fl.lic_number
         AND fp.pay_lsl_number = i_lsl_number
         AND fl.lic_currency = i_lic_cur
         AND fl.lic_type = i_lic_type
         AND xfrf.rzf_lsl_number = i_lsl_number
         AND fl.lic_budget_code = i_lic_budg_code
         AND xfrf.rzf_pay_number = pay_number
         AND xfrf.rzf_account_head <> UPPER ('ED')
         AND PAY_TYPE = 'PR'
         AND (CONCAT (xfrf.rzf_year, LPAD (xfrf.rzf_month, 2, 0)))
                BETWEEN (   TO_CHAR (TO_DATE (i_from_date), 'YYYY')
                         || TO_CHAR (TO_DATE (i_from_date), 'MM')
                        )
                    AND (   TO_CHAR (TO_DATE (i_to_date), 'YYYY')
                         || TO_CHAR (TO_DATE (i_to_date), 'MM')
                        );

      RETURN forex_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         forex_is := 0;
         RETURN forex_is;
   END;
-- Dev2: Pure Finance :End
END pkg_fin_mnet_pay_sum_reports;
/