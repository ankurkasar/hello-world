create or replace PACKAGE          "PKG_FIN_MNET_OUTSTAND_COMENT"
AS
   TYPE c_cursor_fin_ost_commemnt IS REF CURSOR;

   FUNCTION prc_fin_mnet_ousncom_paid (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_lsl_number     IN   fid_payment.pay_lsl_number%TYPE,
      i_param11        IN   DATE
   )
      RETURN NUMBER;

   FUNCTION prc_fin_mnet_ousncom_paid_mmt (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_param10        IN   DATE,
      i_param11        IN   DATE
   )
      RETURN NUMBER;

   FUNCTION prc_fin_mnet_ousncom_paid_sum (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_lsl_number     IN   fid_payment.pay_lsl_number%TYPE,
      i_param11        IN   DATE
   )
      RETURN NUMBER;

   FUNCTION prc_fin_mnet_ousncom_exh_mmt (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_param10      IN   DATE
   )
      RETURN NUMBER;

   FUNCTION prc_fin_mnet_ousncom_exh_sum (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_param10      IN   DATE
   )
      RETURN NUMBER;

   FUNCTION prc_fin_mnet_ousncom_liab_mmt (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param10              IN   DATE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE
   )
      RETURN NUMBER;

   FUNCTION prc_fin_mnet_ousncom_liab (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_con_number           IN   fid_contract.con_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE,
      i_lsl_number           IN   fid_payment.pay_lsl_number%TYPE
   )
      RETURN NUMBER;

   FUNCTION prc_fin_mnet_ousncom_liab_sum (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE,
      i_lic_type             IN   fid_license.lic_type%TYPE,
      i_lsl_number           IN   fid_payment.pay_lsl_number%TYPE,
      i_eval_val             IN   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION prc_fin_mnet_ousncom_exrate (
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_com_ter_code   IN   fid_company.com_ter_code%TYPE
   )
      RETURN NUMBER;

   PROCEDURE prc_fin_mnet_ousncom_details (
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      l_lic_type          IN       fid_license.lic_type%TYPE,
      l_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      l_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      l_com_short_name    IN       fid_company.com_short_name%TYPE,
      l_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,      --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

   PROCEDURE prc_fin_mnet_ousncom_moment (
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_com_short_name    IN       fid_company.com_short_name%TYPE,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

   PROCEDURE prc_fin_mnet_ousncom_mmt_sum (
      i_lic_type          IN       fid_license.lic_type%TYPE   --LICENSE TYPE
                                                            ,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE
                                                                   --LICENSE TYPE
   ,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE
                                                                   --LICENSEE NAME
   ,
      i_com_short_name    IN       fid_company.com_short_name%TYPE
                                                                  --COMPANY_NAME
   ,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE --SUPPLIER
                                                                  ,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE
                                                                   --CONTRACT
   ,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

   PROCEDURE prc_fin_mnet_ousncom_summary (
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_com_short_name    IN       fid_company.com_short_name%TYPE,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,      --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

   FUNCTION total_paid_imu (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lsl_number           IN   fid_payment.pay_lsl_number%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE
   )
      RETURN NUMBER;

   FUNCTION total_paid_imu_mmt (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_param10        IN   DATE,
      i_param11        IN   DATE
   )
      RETURN NUMBER;

   FUNCTION total_paid_imu_detail (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_param11        IN   DATE,
      i_lic_markup     IN   fid_license.lic_markup_percent%TYPE,
      i_lsl_number     IN   fid_payment.pay_lsl_number%TYPE
   )
      RETURN NUMBER;

   PROCEDURE prc_fin_mnet_det_exp_to_exl (
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      l_lic_type          IN       fid_license.lic_type%TYPE,
      l_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      l_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      l_com_short_name    IN       fid_company.com_short_name%TYPE --SUPPLIER
                                                                  ,
      l_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,      --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

   PROCEDURE prc_fin_mnet_sum_exp_to_exl (
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_com_short_name    IN       fid_company.com_short_name%TYPE,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,      --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

   ----Dev2:Pure Finance:Start:[Hari Mandal]_[02/05/2013]
   FUNCTION x_fin_con_forcast_sum (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_month        IN   NUMBER,
      i_year         IN   NUMBER
   )
      RETURN NUMBER;

   FUNCTION x_fin_subled_con_forcast_sum (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_month        IN   NUMBER,
      i_year         IN   NUMBER
   )
      RETURN NUMBER;
  -- Added by Zeshan for BR_15_007

FUNCTION prc_fin_mnet_ousncom_paid_new (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_lsl_number     IN   fid_payment.pay_lsl_number%TYPE,
      i_param11        IN   DATE
   )RETURN NUMBER;

FUNCTION prc_fin_mnet_ousncom_liab_new (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_con_number           IN   fid_contract.con_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE,
      i_lsl_number           IN   fid_payment.pay_lsl_number%TYPE
   )RETURN NUMBER;

PROCEDURE prc_fin_mnet_ousncom_details_n (
/********************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         06-May-2016       Zeshan Khan                  Included field Effective subscribers for ROY licenses, when i_evaluate_val = 'Y'.
**********************************************************************************************************************************************/
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      l_lic_type          IN       fid_license.lic_type%TYPE,
      l_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      l_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      l_com_short_name    IN       fid_company.com_short_name%TYPE,
      l_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

PROCEDURE prc_fin_mnet_det_exp_to_exl_n (
/********************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         06-May-2016       Zeshan Khan                  Included field Effective subscribers for ROY licenses, when i_evaluate_val = 'Y'.
**********************************************************************************************************************************************/
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      l_lic_type          IN       fid_license.lic_type%TYPE,
      l_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      l_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      l_com_short_name    IN       fid_company.com_short_name%TYPE, --SUPPLIER
      l_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

PROCEDURE prc_fin_mnet_ousncom_summary_n (
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_com_short_name    IN       fid_company.com_short_name%TYPE,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

PROCEDURE prc_fin_mnet_sum_exp_to_exl_n (
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_com_short_name    IN       fid_company.com_short_name%TYPE,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   );

END PKG_FIN_MNET_OUTSTAND_COMENT;
/
create or replace PACKAGE BODY          "PKG_FIN_MNET_OUTSTAND_COMENT"
AS
   FUNCTION total_paid_imu_detail (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_param11        IN   DATE,
      i_lic_markup     IN   fid_license.lic_markup_percent%TYPE,
      i_lsl_number     IN   fid_payment.pay_lsl_number%TYPE
   )
      RETURN NUMBER
   AS
      l_liab1   NUMBER;
   BEGIN
      BEGIN
         SELECT NVL (SUM (  pay_amount
                          * (100 / (100 + NVL (pay_markup_percent, 0)))
                         ),
                     0
                    )
           INTO l_liab1
           FROM fid_payment, fid_payment_type
          WHERE pat_code = pay_code
            AND pay_lic_number = i_lic_number
            AND pay_con_number = i_con_number
            AND pay_cur_code = i_lic_currency
            AND pay_lsl_number = i_lsl_number
            AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <=
                   TO_DATE (TO_CHAR (i_param11, 'DD-MON-RRRR'), 'DD_MON-RRRR')
            AND pay_status IN ('P', 'I')
            AND pat_group = 'F';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_liab1 := 0;
      END;

      IF l_liab1 IS NULL
      THEN
         l_liab1 := 0;
      END IF;

      RETURN NVL (l_liab1, 0);
   END total_paid_imu_detail;

   FUNCTION prc_fin_mnet_ousncom_liab (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_con_number           IN   fid_contract.con_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE,
      i_lsl_number           IN   fid_payment.pay_lsl_number%TYPE
   )
      RETURN NUMBER
   AS
      l_liab1                NUMBER;
      l_liab                 NUMBER;
      l_lic_markup_percent   fid_license.lic_markup_percent%TYPE;
      temp                   NUMBER;
      l_flag                 NUMBER;
   BEGIN
      IF i_lic_price = 0
      THEN
         l_lic_markup_percent := 0;
      ELSE
         l_lic_markup_percent := i_lic_markup_percent;
      END IF;

      SELECT CASE
                WHEN (TO_NUMBER (TO_CHAR (lic_acct_date, 'YYYYMM')) <
                                     TO_NUMBER (TO_CHAR (lic_start, 'YYYYMM'))
                     )
                   THEN 1
                ELSE 0
             END
        INTO l_flag
        FROM fid_license
       WHERE lic_number = i_lic_number;

      IF l_flag = 1
      THEN
         l_liab := i_lic_price;
      ELSE
         l_liab :=
              (  i_lic_price
               - total_paid_imu_detail (i_lic_number,
                                        i_con_number,
                                        i_lic_currency,
                                        i_param11,
                                        i_lic_markup_percent,
                                        i_lsl_number
                                       )
              )
            * ((100 + l_lic_markup_percent) / 100);
      --    l_liab := (i_lic_price  - l_liab1)
      --                    * ((100 + L_lic_markup_percent)/100);
      END IF;

      RETURN NVL (l_liab, 0);
   END;

   FUNCTION total_paid_imu_mmt (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_param10        IN   DATE,
      i_param11        IN   DATE
   )
      RETURN NUMBER
   AS
      l_liab1   NUMBER;
   BEGIN
      BEGIN
         SELECT NVL (SUM (  pay_amount
                          * (100 / (100 + NVL (pay_markup_percent, 0)))
                         ),
                     0
                    )
           INTO l_liab1
           FROM fid_payment, fid_payment_type
          WHERE pat_code = pay_code
            AND pay_cur_code = i_lic_currency
            AND pay_lic_number = i_lic_number
            AND pay_status IN ('P', 'I')
            AND pat_group = 'F'
            AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR')
                   BETWEEN TO_DATE (TO_CHAR (i_param10, 'DD-MON-RRRR'),
                                    'DD-MON-RRRR'
                                   )
                       AND TO_DATE (TO_CHAR (i_param11, 'DD-MON-RRRR'),
                                    'DD-MON-RRRR'
                                   );
      --    return nvl(l_liab1,0);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_liab1 := 0;
      END;

      IF l_liab1 IS NULL
      THEN
         l_liab1 := 0;
      END IF;

      RETURN NVL (l_liab1, 0);
   END total_paid_imu_mmt;

   FUNCTION prc_fin_mnet_ousncom_liab_mmt (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param10              IN   DATE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE
   )
      RETURN NUMBER
   AS
      l_liab   NUMBER;
   BEGIN
      l_liab :=
         (  (  i_lic_price
             - total_paid_imu_mmt (i_lic_number,
                                   i_lic_currency,
                                   i_param10,
                                   i_param11
                                  )
            )
          * ((100 + i_lic_markup_percent) / 100)
         );
      --dbms_output.put_line('IN LIAB '||l_liab || ' ' ||l_liab1);
      RETURN NVL (l_liab, 0);
   END prc_fin_mnet_ousncom_liab_mmt;

   FUNCTION total_paid_imu (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lsl_number           IN   fid_payment.pay_lsl_number%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE
   )
      RETURN NUMBER
   AS
      l_liab1   NUMBER;
   BEGIN
      BEGIN
         SELECT NVL (SUM (  pay_amount
                          * (100 / (100 + NVL (pay_markup_percent, 0)))
                         ),
                     0
                    )
           INTO l_liab1
           FROM fid_payment, fid_payment_type
          WHERE pat_code = pay_code
            AND pay_cur_code = i_lic_currency
            AND pay_lic_number = i_lic_number
            AND pay_lsl_number = i_lsl_number
            AND pay_status IN ('P', 'I')
            AND pat_group = 'F'
            AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <=
                   TO_DATE (TO_CHAR (i_param11, 'DD-MON-RRRR'), 'DD-MON-RRRR');

         RETURN l_liab1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_liab1 := 0;
      END;

      RETURN l_liab1;
   END;

   FUNCTION prc_fin_mnet_ousncom_liab_sum (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE,
      i_lic_type             IN   fid_license.lic_type%TYPE,
      i_lsl_number           IN   fid_payment.pay_lsl_number%TYPE,
      i_eval_val             IN   VARCHAR2
   )
      RETURN NUMBER
   AS
      l_liab1                NUMBER;
      l_liab                 NUMBER;
      l_lic_markup_percent   fid_license.lic_markup_percent%TYPE;
      l_month                NUMBER;
      l_year                 NUMBER;
      l_flag                 NUMBER;
   BEGIN
      l_month := TO_NUMBER (TO_CHAR (i_param11, 'MM'));
      l_year := TO_NUMBER (TO_CHAR (i_param11, 'RRRR'));

      IF i_lic_price = 0
      THEN
         l_lic_markup_percent := 0;
      ELSE
         l_lic_markup_percent := i_lic_markup_percent;
      END IF;

      SELECT CASE
                WHEN (TO_NUMBER (TO_CHAR (lic_acct_date, 'YYYYMM')) <
                                     TO_NUMBER (TO_CHAR (lic_start, 'YYYYMM'))
                     )
                   THEN 1
                ELSE 0
             END
        INTO l_flag
        FROM fid_license
       WHERE lic_number = i_lic_number;

      IF l_flag = 1
      THEN
         l_liab := i_lic_price;
      ELSE
         IF i_lic_type = 'ROY' AND i_eval_val = 'Y'
         THEN
            l_liab :=
               PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                               (i_lic_number,
                                                                l_month,
                                                                l_year
                                                               );
         ELSE
            l_liab :=
               (  (  i_lic_price
                   - total_paid_imu (i_lic_number,
                                     i_lic_currency,
                                     i_param11,
                                     i_lic_price,
                                     i_lsl_number,
                                     i_lic_markup_percent
                                    )
                  )
                * ((100 + l_lic_markup_percent) / 100)
               );
         END IF;
      END IF;

      RETURN NVL (ROUND (l_liab, 4), 0);
   END;

   FUNCTION prc_fin_mnet_ousncom_exh_mmt (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_param10      IN   DATE
   )
      RETURN NUMBER
   AS
      l_exh   NUMBER;
   BEGIN
      BEGIN
         SELECT NVL (SUM (sch_paid), 0)
           INTO l_exh
           FROM fid_sch_summary_vw
          WHERE sch_lic_number = i_lic_number
            AND sch_year || LPAD (sch_month, 2, 0) =
                                                 TO_CHAR (i_param10, 'YYYYMM');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_exh := 0;
      END;

      RETURN NVL (ROUND (l_exh, 4), 0);
   END;

   FUNCTION prc_fin_mnet_ousncom_exh_sum (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_param10      IN   DATE
   )
      RETURN NUMBER
   AS
      l_exh   NUMBER;
   BEGIN
      BEGIN
         SELECT NVL (SUM (sch_paid), 0)
           INTO l_exh
           FROM fid_sch_summary_vw
          WHERE sch_lic_number = i_lic_number
            AND sch_year || LPAD (sch_month, 2, 0) <=
                                                 TO_CHAR (i_param10, 'YYYYMM');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_exh := 0;
      END;

      RETURN l_exh;
   END;

   FUNCTION prc_fin_mnet_ousncom_paid (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_lsl_number     IN   fid_payment.pay_lsl_number%TYPE,
      i_param11        IN   DATE
   )
      RETURN NUMBER
   AS
      l_paid   NUMBER;
      l_flag   NUMBER;
   BEGIN
      l_paid := 0;

      SELECT CASE
                WHEN (TO_NUMBER (TO_CHAR (lic_acct_date, 'YYYYMM')) <
                                     TO_NUMBER (TO_CHAR (lic_start, 'YYYYMM'))
                     )
                   THEN 1
                ELSE 0
             END
        INTO l_flag
        FROM fid_license
       WHERE lic_number = i_lic_number;

      IF l_flag = 1
      THEN
         l_paid := 0;
      ELSE
         BEGIN
            SELECT NVL (SUM (pay_amount), 0)
              INTO l_paid
              FROM fid_payment, fid_payment_type
             WHERE pat_code = pay_code
               AND pay_lic_number = i_lic_number
               AND pay_con_number = i_con_number
               AND pay_cur_code = i_lic_currency
               AND pay_lsl_number = i_lsl_number
               AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <=
                      TO_DATE (TO_CHAR (i_param11, 'DD-MON-RRRR'),
                               'DD-MON-RRRR'
                              )
               AND pay_status IN ('P', 'I')
               AND pat_group = 'F';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_paid := 0;
         END;
      END IF;

      RETURN NVL (ROUND (l_paid, 4), 0);
   END prc_fin_mnet_ousncom_paid;

   FUNCTION prc_fin_mnet_ousncom_paid_mmt (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_param10        IN   DATE,
      i_param11        IN   DATE
   )
      RETURN NUMBER
   AS
      l_paid   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (NVL (pay_amount, 0))
           INTO l_paid
           FROM fid_payment, fid_payment_type
          WHERE pat_code = pay_code
            AND pay_cur_code = i_lic_currency
            AND pay_lic_number = i_lic_number
            AND pay_status IN ('P', 'I')
            AND pat_group = 'F'
            AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR')
                   BETWEEN TO_DATE (TO_CHAR (i_param10, 'DD-MON-RRRR'),
                                    'DD-MON-RRRR'
                                   )
                       AND TO_DATE (TO_CHAR (i_param11, 'DD-MON-RRRR'),
                                    'DD-MON-RRRR'
                                   );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_paid := 0;
            DBMS_OUTPUT.put_line (l_paid || ' ** IN EXCEPTION ');
      END;

      --dbms_output.put_line(l_paid||' **  ');
      RETURN NVL (l_paid, 0);
   END;

   FUNCTION prc_fin_mnet_ousncom_paid_sum (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_lsl_number     IN   fid_payment.pay_lsl_number%TYPE,
      i_param11        IN   DATE
   )
      RETURN NUMBER
   AS
      l_paid   NUMBER;
      l_flag   NUMBER;
   BEGIN
      SELECT CASE
                WHEN (TO_NUMBER (TO_CHAR (lic_acct_date, 'YYYYMM')) <
                                     TO_NUMBER (TO_CHAR (lic_start, 'YYYYMM'))
                     )
                   THEN 1
                ELSE 0
             END
        INTO l_flag
        FROM fid_license
       WHERE lic_number = i_lic_number;

      IF l_flag = 1
      THEN
         l_paid := 0;
      ELSE
         BEGIN
            SELECT SUM (NVL (pay_amount, 0))
              INTO l_paid
              FROM fid_payment, fid_payment_type
             WHERE pat_code = pay_code
               AND pay_cur_code = i_lic_currency
               AND pay_lic_number = i_lic_number
               AND pay_lsl_number = i_lsl_number
               AND pay_status IN ('P', 'I')
               AND pat_group = 'F'
               AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <=
                      TO_DATE (TO_CHAR (i_param11, 'DD-MON-RRRR'),
                               'DD-MON-RRRR'
                              );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_paid := 0;
               DBMS_OUTPUT.put_line (l_paid || ' ** IN EXCEPTION ');
         END;
      END IF;

      --dbms_output.put_line(l_paid||' **  ');
      RETURN NVL (ROUND (l_paid, 4), 0);
   END prc_fin_mnet_ousncom_paid_sum;

   FUNCTION prc_fin_mnet_ousncom_exrate (
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_com_ter_code   IN   fid_company.com_ter_code%TYPE
   )
      RETURN NUMBER
   AS
      l_ex_rate   NUMBER;
   BEGIN
      BEGIN
         SELECT rat_rate
           INTO l_ex_rate
           FROM fid_exchange_rate, fid_territory
          WHERE rat_cur_code = i_lic_currency
            AND rat_cur_code_2 = ter_cur_code
            AND ter_code = i_com_ter_code;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --dbms_output.put_line('TEST ** '||i_lic_currency||' ** '||' **  '||i_com_ter_code);
      RETURN l_ex_rate;
   END;

   FUNCTION x_fin_con_forcast_sum (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_month        IN   NUMBER,
      i_year         IN   NUMBER
   )
      RETURN NUMBER
   AS
      l_con_forcast   NUMBER;
   BEGIN
      SELECT SUM (NVL (occ_con_forecast, 0))
        INTO l_con_forcast
        FROM x_fin_outs_comm_calc
       WHERE occ_year || LPAD (occ_month, 2, 0) <=
                                                i_year || LPAD (i_month, 2, 0)
         AND occ_lic_number = i_lic_number;

      RETURN l_con_forcast;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_con_forcast := 0;
         RETURN l_con_forcast;
   END;

   FUNCTION x_fin_subled_con_forcast_sum (
      i_lic_number   IN   fid_license.lic_number%TYPE,
      i_month        IN   NUMBER,
      i_year         IN   NUMBER
   )
      RETURN NUMBER
   AS
      l_con_forcast   NUMBER;
   BEGIN
      
      SELECT NVL (SUM (NVL (lis_con_forecast, 0)), 0)
        INTO l_con_forcast
        FROM fid_license_sub_ledger
       WHERE lis_per_year || LPAD (lis_per_month, 2, 0) <=
                                                i_year || LPAD (i_month, 2, 0)
         AND lis_lic_number = i_lic_number;

      RETURN l_con_forcast;
      
   EXCEPTION
      WHEN OTHERS
      THEN
         l_con_forcast := 0;
         RETURN l_con_forcast;
   END x_fin_subled_con_forcast_sum;

   PROCEDURE prc_fin_mnet_ousncom_details (
/********************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         06-May-2016       Zeshan Khan                  Included field Effective subscribers for ROY licenses, when i_evaluate_val = 'Y'.
**********************************************************************************************************************************************/
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      l_lic_type          IN       fid_license.lic_type%TYPE,
      l_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      l_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      l_com_short_name    IN       fid_company.com_short_name%TYPE,
      l_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      l_where_clause   VARCHAR2 (1000);
      l_qry_string     VARCHAR2 (32000);
      l_rsa_ratedate   DATE;
      l_afr_ratedate   DATE;
      l_year           NUMBER;
      L_MONTH          NUMBER;
      v_go_live_date   DATE;
      l_last_day       DATE;
      L_YYYYMM_NUM     NUMBER (6);
   BEGIN
      
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'FIN_I_LIVE_DATE';
      
      IF TO_CHAR(i_period_date,'YYYYMM') >= TO_CHAR(v_go_live_date,'YYYYMM') OR TO_CHAR(i_from_date,'YYYYMM') >= TO_CHAR(v_go_live_date,'YYYYMM')
      THEN
          prc_fin_mnet_ousncom_details_n (i_channel_comp,
                                          l_lic_type, 
                                          l_lic_budget_code, 
                                          l_lee_short_name, 
                                          l_com_short_name, 
                                          l_con_short_name, 
                                          i_period_date, 
                                          i_include_zeros, 
                                          i_reg_code, 
                                          i_from_date, 
                                          i_to_date, 
                                          i_rate_type, 
                                          i_evaluate_val, 
                                          o_cursor);
      ELSE
            BEGIN
            IF i_lic_in_or_out = 'IN'
            THEN
               l_where_clause :=
                     ' AND Lic_start <= '''
                  || LAST_DAY (i_period_date)
                  || '''And Lic_end >= '''
                  || i_period_date
                  || '''';
            ELSIF i_lic_in_or_out = 'OUT'
            THEN
               l_where_clause :=
                     ' AND Lic_start > '''
                  || LAST_DAY (i_period_date)
                  || '''OR Lic_end < '''
                  || i_period_date
                  || '''';
            ELSIF i_lic_in_or_out = 'BOTH'
            THEN
               l_where_clause := ' ';
            END IF;
      
            l_month := TO_NUMBER (TO_CHAR (i_period_date, 'MM'));
            l_year := TO_NUMBER (TO_CHAR (i_period_date, 'RRRR'));
            l_yyyymm_num := l_year || TO_CHAR (i_period_date, 'MM');
      
      
            SELECT TO_DATE (content)
              INTO v_go_live_date
              FROM x_fin_configs
             WHERE KEY = 'GO-LIVEDATE';
      
            SELECT LAST_DAY (i_period_date)
              INTO l_last_day
              FROM DUAL;
      
            IF i_evaluate_val = 'Y'
            THEN
            DBMS_OUTPUT.DISABLE;
               x_pkg_fin_out_comm_roy_calc.prc_fin_calc_roy_comm
                                                                (i_reg_code,
                                                                 i_channel_comp,
                                                                 l_lee_short_name,
                                                                 l_lic_budget_code,
                                                                 l_com_short_name,
                                                                 l_con_short_name,
                                                                 i_from_date,
                                                                 i_to_date,
                                                                 i_period_date
                                                                );
            END IF;
          DBMS_OUTPUT.ENABLE;
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
      --open o_cursor for
            l_qry_string :=
                  'SELECT
                         MEM_AGY_COM_NUMBER
                    ,    fg.gen_title
                    ,    ft.ter_cur_code
                    ,    fc.com_number
                    ,    fc.com_name Channel_Company
                    ,    fc.com_short_name comp_short_name
                    ,    fl.lic_currency
                    ,    fl.lic_type
                    ,    lee_short_name
                    ,    fl.lic_budget_code
                    ,    b.com_short_name SUPPLIER
                    ,    fct.con_short_name
                    ,    fc.com_ter_code
                    ,    con_number
                    ,    fl.lic_number
                    ,    lic_gen_refno
                    ,    lic_amort_code
                 -- ,    round(fl.lic_price,2) lic_price
                    ,    round(lsl.lsl_lee_price,2) lic_price
                    ,    fc.com_short_name
                    ,    lic_markup_percent
                    ,    TO_CHAR(lic_acct_date,'
                             || '''YYYY.MM'''
                             || ') LIC_ACCT_DATE
                    ,    TO_CHAR(lic_start,'
                             || '''DDMonYYYY'''
                             || ') LIC_START
                    ,    TO_CHAR(lic_end, '
                             || '''DDMonYYYY'
                             || ''') LIC_END
                    ,  '''
                             || l_afr_ratedate
                             || ''' afr_ratedate
                    ,  CASE WHEN LIC_START < '''
                             || v_go_live_date
                             || '''  OR to_date('''
                             || i_period_date
                             || ''') < to_date('''
                             || v_go_live_date
                             || ''')
                    THEN ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXRATE(fl.lic_currency,fc.com_ter_code ),4)
                    ELSE ROUND(DECODE('''
                             || i_rate_type
                             || ''',
                    ''M'', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                    (fl.lic_currency,
                    ft.ter_cur_code,
                    '''
                             || l_afr_ratedate
                             || '''
                    ),
                    ''R'', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                    (fl.lic_currency,
                    ft.ter_cur_code,
                    '''
                             || l_last_day
                             || '''
                    )
                    ),5) END AFR_EX_RATE   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                    , '''
                             || l_rsa_ratedate
                             || ''' rsa_ratedate
                    , CASE WHEN LIC_START < '''
                             || v_go_live_date
                             || '''  OR to_date('''
                             || i_period_date
                             || ''') < to_date('''
                             || v_go_live_date
                             || ''')
                    THEN ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXRATE(fl.lic_currency,fc.com_ter_code ),4)
                    ELSE ROUND(DECODE('''
                             || i_rate_type
                             || ''',
                    ''M'', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                    (fl.lic_currency,
                    ft.ter_cur_code,
                    '''
                             || l_rsa_ratedate
                             || '''
                    ),
                    ''R'', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                    (fl.lic_currency,
                    ft.ter_cur_code,
                    '''
                             || l_last_day
                             || '''
                    )
                    ),5) END RSA_EX_RATE   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                    
                    ,CASE WHEN '''
                             || i_evaluate_val
                             || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                             || l_month
                             || ','
                             || l_year
                             || ')
                    ELSE PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                             || i_period_date
                             || '''), lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number)END
                    +
                    PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                             || i_period_date
                             || ''')    ) fee
                    ,    ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                             || i_period_date
                             || ''')    ),2)  paid
                    ,  CASE WHEN '''
                             || i_evaluate_val
                             || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                             || l_month
                             || ','
                             || l_year
                             || ')
                    ELSE ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                             || i_period_date
                             || ''')    , lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number),2)END liab
                    ,  CASE WHEN '''
                             || i_evaluate_val
                             || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                             || l_month
                             || ','
                             || l_year
                             || ')
                    ELSE ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                             || i_period_date
                             || ''')    , lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number),2)END
                    *
                    CASE WHEN LIC_START < '''
                             || v_go_live_date
                             || ''' OR to_date('''
                             || i_period_date
                             || ''') < to_date('''
                             || v_go_live_date
                             || ''')
                    THEN ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXRATE(fl.lic_currency,fc.com_ter_code ),4)
                    ELSE ROUND(DECODE('''
                             || i_rate_type
                             || ''',
                    ''M'', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                    (fl.lic_currency,
                    ft.ter_cur_code,
                    decode(fre.reg_code,''RSA'','''
                             || l_rsa_ratedate
                             || ''','''
                             || l_afr_ratedate
                             || '''
                    )),
                    ''R'', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                    (fl.lic_currency,
                    ft.ter_cur_code,
                    '''
                             || l_last_day
                             || '''
                    )
                    ) ,5)END   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                    sar_LIAB ,
                    fre.reg_code,
                    FL.LIC_STATUS  --[finace dev 1] [Ankur Kasar]
                    ';
                    
                    
                    
                    --[Ver 0.1] [START]
                      IF I_EVALUATE_VAL = 'Y'
                      THEN
                      l_qry_string := l_qry_string || '
                       ,CASE WHEN lic_type =''ROY''
                       THEN
                       round( (nvl(round(
                       (
                       CASE WHEN '''
                             || i_evaluate_val
                             || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                             || l_month
                             || ','
                             || l_year
                             || ')
                              ELSE PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                                       || i_period_date
                                       || '''), lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number)END
                              +
                              PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                                       || i_period_date
                                       || ''')    )
                       )
                       ,2),0))/(decode(lic_price,0,1,round(lic_price,2))) )
                       ELSE
                       NULL
                       END Effective_Subs 
                       ';
                      END IF;
                    --[Ver 0.1] [END]
                    
                    L_QRY_STRING := L_QRY_STRING || '
                    FROM    fid_company fc
                    ,    fid_company b
                    ,    fid_contract fct
                    ,    fid_licensee fle
                    ,    fid_license fl
                    ,    fid_territory ft
                    ,    fid_general fg
                    ,    SAK_MEMO
                    ,    fid_region fre
                    ,    x_fin_lic_sec_lee lsl
                    WHERE    lee_cha_com_number = fc.com_number
                    AND    gen_refno = lic_gen_refno
                    AND    ter_code = fc.com_ter_code
                    AND    fc.com_type IN ('
                             || '''CC'''
                             || ','
                             || '''BC'''
                             || ')
                    ----Dev2:Pure Finance:Start:[Hari Mandal]_[29/04/2013]
                    -- AND    fl.lic_lee_number = fle.lee_number
                    AND    fle.lee_number = lsl.lsl_lee_number
                    AND    fl.lic_number  = lsl.lsl_lic_number
                    AND    fl.lic_entry_date between decode('''
                             || i_from_date
                             || ''',null,fl.lic_entry_date,'''
                             || i_from_date
                             || ''') and decode('''
                             || i_to_date
                             || ''',null,fl.lic_entry_date,'''
                             || i_to_date
                             || ''')
                    ----Dev2:Pure Finance:End-------------------------------
                    AND    con_number = lic_con_number
                    AND     mem_id = lic_mem_number
                    AND    b.com_number = con_com_number
                    
                    /*AND   case when lic_status=''C'' then
                    CASE WHEN '''
                             || i_evaluate_val
                             || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                             || l_month
                             || ','
                             || l_year
                             || ')
                    ELSE ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                             || i_period_date
                             || ''')    , lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number),2)END
                    else -1
                    end < 0*/
                    
                    AND    fl.lic_type LIKE     '''|| l_lic_type|| '''
                    AND    fle.lee_short_name LIKE '''|| l_lee_short_name|| '''
                    AND    fl.lic_budget_code LIKE '''
                             || l_lic_budget_code
                             || '''
                    AND    b.com_short_name LIKE '''
                             || l_com_short_name
                             || '''
                    AND    fc.com_short_name LIKE '''
                             || i_channel_comp
                             || '''
                    --
                    AND    fct.con_short_name LIKE '''
                             || l_con_short_name
                             || '''
                    AND    ( (( lic_acct_date > last_day('''
                             || i_period_date
                             || ''')) OR ( lic_start > last_day('''
                             || i_period_date
                             || ''')))
                    OR lic_acct_date IS NULL
                    OR lic_status = ''C''                             --
                    OR nvl(lic_before_acct_date,''N'') = ''Y'' )
                    
                    AND (NOT EXISTS ( SELECT  lis_lic_number,NVL(SUM(LIS_CON_FC_EMU),0)
                    FROM    X_MV_OUT_COMM_EX
                    WHERE   lis_lic_number = fl.lic_number
                    and     LIS_YYYYMM_NUM <= '|| l_yyyymm_num || '
                    GROUP BY lis_lic_number
                    HAVING NVL(SUM(LIS_CON_FC_EMU),0) != 0
                    ))
                    -- AND fle.lee_region_id = fre.reg_id
                    AND fle.lee_split_region = fre.reg_id(+)
                    AND fre.reg_code like ''' || i_reg_code || '''
                    AND    lic_status NOT IN (''B'',''F'',''T'')' || l_where_clause|| '';
                    
                          IF i_include_zeros = 'N'
                          THEN
                             --  l_qry_string := l_qry_string ||'AND  ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB(fl.lic_number , con_number , fl.lic_currency , last_day('''||i_period_date||''')    , fl.lic_price , fl.lic_markup_percent),2) <> 0';
                             l_qry_string :=
                                   l_qry_string
                                || 'AND ( ( (  ROUND(case when '''
                                || i_evaluate_val
                                || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                                || l_month
                                || ','
                                || l_year
                                || ')
                    else PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                                || i_period_date
                                || '''), lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number)
                    +
                    PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                                || i_period_date
                                || ''')    )
                    end,2) <> 0) OR ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                                || i_period_date
                                || ''')    ),2) <> 0) OR (lsl_lee_price <> 0) ) ';
            END IF;
      
            l_qry_string :=
                  l_qry_string
               || ' ORDER BY    fc.com_name ,    lic_currency,    lic_type,    lee_short_name,    lic_budget_code,    b.com_short_name,    con_short_name,    lic_number';
            DBMS_OUTPUT.put_line (l_qry_string);
      
            OPEN o_cursor FOR l_qry_string;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (-20786, SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,1,200));

      END;
      END IF;

   END prc_fin_mnet_ousncom_details;

   PROCEDURE prc_fin_mnet_ousncom_moment (
      i_lic_type          IN       fid_license.lic_type%TYPE    --LICENSE TYPE
                                                            ,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE
                                                                   --LICENSE TYPE
   ,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE
                                                                   --LICENSEE NAME
   ,
      i_com_short_name    IN       fid_company.com_short_name%TYPE
                                                                  --COMPANY_NAME
   ,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE  --SUPPLIER
                                                                  ,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE --CONTRACT
                                                                   ,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      l_qry_text       VARCHAR2 (2500);
      l_where_clause   VARCHAR2 (500);
   BEGIN
      IF i_lic_in_or_out = 'IN'
      THEN
         OPEN o_cursor FOR
            SELECT DISTINCT a.com_number com_number2, a.com_name,
                            a.com_short_name, a.com_ter_code, lic_currency,
                            lic_type, lee_short_name, lic_budget_code,
                            lic_con_number, lic_number,
                            ROUND (lic_price, 2) lic_price,
                            lic_markup_percent,
                            TO_CHAR (lic_end, 'DDMonYYYY'),
                            TO_CHAR (lic_end, 'MM.YYYY'),
                            b.com_number com_number,
                            ROUND
                               (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exrate
                                                               (lic_currency,
                                                                a.com_ter_code
                                                               ),
                                5
                               ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                            ROUND
                               (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_mmt
                                                      (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       i_period_date,
                                                       LAST_DAY (i_period_date)
                                                      ),
                                2
                               ) paid,
                            ROUND
                               (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_mmt
                                                     (lic_number,
                                                      lic_currency,
                                                      i_period_date,
                                                      LAST_DAY (i_period_date),
                                                      lic_price,
                                                      lic_markup_percent
                                                     ),
                                2
                               ) fee,
                            TO_CHAR (i_period_date, 'Mon-yyyy') period,
                            fid_license.LIC_STATUS --[ANKUR KASAR]
                       FROM fid_company a,
                            fid_company b,
                            fid_contract,
                            fid_licensee,
                            fid_license,
                            (SELECT com_ter_code, com_number com_number1,
                                    ter_cur_code
                               FROM fid_company, fid_territory
                              WHERE ter_code = com_ter_code) ter
                      WHERE lee_cha_com_number = a.com_number
                        AND lic_lee_number = lee_number
                        AND con_number = lic_con_number
                        AND b.com_number = con_com_number
                        AND a.com_type IN ('CC', 'BC')
                        AND a.com_short_name LIKE i_com_short_name
                        AND lic_type LIKE i_lic_type
                        AND lee_short_name LIKE i_lee_short_name
                        AND lic_budget_code LIKE i_lic_budget_code
                        AND b.com_short_name LIKE i_supp_com_name
                        AND con_short_name LIKE i_con_short_name
                        AND (   lic_acct_date > LAST_DAY (i_period_date)
                             OR lic_acct_date IS NULL
                            )
                        AND lic_status NOT IN ('B', 'T')
                        AND (ter.com_number1 = a.com_number)
                        AND lic_start <= LAST_DAY (i_period_date)
                        AND lic_end >= i_period_date
                   ORDER BY lic_currency,
                            lic_type,
                            lee_short_name,
                            lic_budget_code;
      END IF;

      IF i_lic_in_or_out = 'OUT'
      THEN
         OPEN o_cursor FOR
            SELECT DISTINCT a.com_number com_number2, a.com_name,
                            a.com_short_name, a.com_ter_code, lic_currency,
                            lic_type, lee_short_name, lic_budget_code,
                            lic_con_number, lic_number,
                            ROUND (lic_price, 2) lic_price,
                            lic_markup_percent,
                            TO_CHAR (lic_end, 'DDMonYYYY'),
                            TO_CHAR (lic_end, 'MM.YYYY'),
                            b.com_number com_number,
                            ROUND
                               (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exrate
                                                               (lic_currency,
                                                                a.com_ter_code
                                                               ),
                                5
                               ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                            ROUND
                               (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_mmt
                                                      (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       i_period_date,
                                                       LAST_DAY (i_period_date)
                                                      ),
                                2
                               ) paid,
                            ROUND
                               (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_mmt
                                                     (lic_number,
                                                      lic_currency,
                                                      i_period_date,
                                                      LAST_DAY (i_period_date),
                                                      lic_price,
                                                      lic_markup_percent
                                                     ),
                                2
                               ) fee,
                            TO_CHAR (i_period_date, 'Mon-yyyy') period,
                            fid_license.LIC_STATUS --[ANKUR KASAR]
                       FROM fid_company a,
                            fid_company b,
                            fid_contract,
                            fid_licensee,
                            fid_license,
                            (SELECT com_ter_code, com_number com_number1,
                                    ter_cur_code
                               FROM fid_company, fid_territory
                              WHERE ter_code = com_ter_code) ter
                      WHERE lee_cha_com_number = a.com_number
                        AND lic_lee_number = lee_number
                        AND con_number = lic_con_number
                        AND b.com_number = con_com_number
                        AND a.com_type IN ('CC', 'BC')
                        AND a.com_short_name LIKE i_com_short_name
                        AND lic_type LIKE i_lic_type
                        AND lee_short_name LIKE i_lee_short_name
                        AND lic_budget_code LIKE i_lic_budget_code
                        AND b.com_short_name LIKE i_supp_com_name
                        AND con_short_name LIKE i_con_short_name
                        AND (   lic_acct_date > LAST_DAY (i_period_date)
                             OR lic_acct_date IS NULL
                            )
                        AND lic_status NOT IN ('B', 'T')
                        AND (ter.com_number1 = a.com_number)
                        AND lic_start > LAST_DAY (i_period_date)
                        AND lic_end < i_period_date
                   ORDER BY lic_currency,
                            lic_type,
                            lee_short_name,
                            lic_budget_code;
      END IF;

      IF i_lic_in_or_out = 'BOTH'
      THEN
         OPEN o_cursor FOR
            SELECT DISTINCT a.com_number com_number2, a.com_name,
                            a.com_short_name, a.com_ter_code, lic_currency,
                            lic_type, lee_short_name, lic_budget_code,
                            lic_con_number, lic_number,
                            ROUND (lic_price, 2) lic_price,
                            lic_markup_percent,
                            TO_CHAR (lic_end, 'DDMonYYYY'),
                            TO_CHAR (lic_end, 'MM.YYYY'),
                            b.com_number com_number,
                            ROUND
                               (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exrate
                                                               (lic_currency,
                                                                a.com_ter_code
                                                               ),
                                5   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                               ) ex_rate,
                            ROUND
                               (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_mmt
                                                      (lic_number,
                                                       con_number,
                                                       lic_currency,
                                                       i_period_date,
                                                       LAST_DAY (i_period_date)
                                                      ),
                                2
                               ) paid,
                            ROUND
                               (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_mmt
                                                     (lic_number,
                                                      lic_currency,
                                                      i_period_date,
                                                      LAST_DAY (i_period_date),
                                                      lic_price,
                                                      lic_markup_percent
                                                     ),
                                2
                               ) fee,
                            TO_CHAR (i_period_date, 'Mon-yyyy') period,
                            fid_license.LIC_STATUS --[ANKUR KASAR]
                       FROM fid_company a,
                            fid_company b,
                            fid_contract,
                            fid_licensee,
                            fid_license,
                            (SELECT com_ter_code, com_number com_number1,
                                    ter_cur_code
                               FROM fid_company, fid_territory
                              WHERE ter_code = com_ter_code) ter
                      WHERE lee_cha_com_number = a.com_number
                        AND lic_lee_number = lee_number
                        AND con_number = lic_con_number
                        AND b.com_number = con_com_number
                        AND a.com_type IN ('CC', 'BC')
                        AND a.com_short_name LIKE i_com_short_name
                        AND lic_type LIKE i_lic_type
                        AND lee_short_name LIKE i_lee_short_name
                        AND lic_budget_code LIKE i_lic_budget_code
                        AND b.com_short_name LIKE i_supp_com_name
                        AND con_short_name LIKE i_con_short_name
                        AND (   lic_acct_date > LAST_DAY (i_period_date)
                             OR lic_acct_date IS NULL
                            )
                        AND lic_status NOT IN ('B', 'T')
                        AND (ter.com_number1 = a.com_number)
                   ORDER BY lic_currency,
                            lic_type,
                            lee_short_name,
                            lic_budget_code;
      END IF;
   END prc_fin_mnet_ousncom_moment;

   PROCEDURE prc_fin_mnet_ousncom_mmt_sum (
      i_lic_type          IN       fid_license.lic_type%TYPE    --LICENSE TYPE
                                                            ,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE
                                                                   --LICENSE TYPE
   ,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE
                                                                   --LICENSEE NAME
   ,
      i_com_short_name    IN       fid_company.com_short_name%TYPE
                                                                  --COMPANY_NAME
   ,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE  --SUPPLIER
                                                                  ,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE --CONTRACT
                                                                   ,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      l_qry_text       VARCHAR2 (9900);
      l_where_clause   VARCHAR2 (500);
   BEGIN
      IF i_lic_in_or_out = 'IN'
      THEN
         l_where_clause :=
               ' AND Lic_start <= '''
            || LAST_DAY (i_period_date)
            || ''' And Lic_end >= '''
            || i_period_date
            || '''';
      ELSIF i_lic_in_or_out = 'OUT'
      THEN
         l_where_clause :=
               ' AND Lic_start > '''
            || LAST_DAY (i_period_date)
            || ''' And Lic_end < '''
            || i_period_date
            || '''';
      ELSIF i_lic_in_or_out = 'BOTH'
      THEN
         l_where_clause := ' ';
      END IF;

      l_qry_text :=
            'SELECT
                 DISTINCT --fc1.com_number com_number2  ,
            --   con_short_name
                 ter.ter_cur_code
            ,    fc1.com_name
            ,    fc1.com_short_name
            ,    fc1.com_ter_code
            ,    lic_currency
            ,    lic_type
            ,    fle.lee_short_name
            ,    lic_budget_code
          --,    lic_con_number
          --,    lic_number
            ,    round(sum(lic_price),2) lic_price
          --,    lic_markup_percent
          --,    TO_CHAR (lic_end, ''DDMonYYYY'')
          --,    TO_CHAR (lic_end, ''MM.YYYY'')
          --,    fc2.com_number com_number
            ,    round(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXRATE(fl.lic_currency,fc1.com_ter_code ),5) EX_RATE   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
            ,    round(sum(decode( fl.lic_type ,'
                     || '''ROY'''
                     || ' , fl.lic_price
            , round(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_MMT(fl.lic_number , fl.lic_currency ,  '''
                     || i_period_date
                     || ''' , last_day('''
                     || i_period_date
                     || '''), fl.lic_price , fl.lic_markup_percent) )
            +
            PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_MMT(fl.lic_number , con_number , fl.lic_currency , '''
                     || i_period_date
                     || ''',last_day('''
                     || i_period_date
                     || '''))
            )),2) fee
            ,    round(sum(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_MMT(fl.lic_number , con_number , fl.lic_currency , '''
                     || i_period_date
                     || ''',last_day('''
                     || i_period_date
                     || '''))),2) PAID
            /*,    PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_MMT(fl.lic_number , fl.lic_currency ,  '''
                     || i_period_date
                     || ''' , last_day('''
                     || i_period_date
                     || '''), fl.lic_price , fl.lic_markup_percent)
            *
            PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXRATE(fl.lic_currency,fc1.com_ter_code )  LOC_LIAB    */
            ,    round(sum(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXH_MMT(fl.lic_number ,'''
                     || i_period_date
                     || ''')),4)  EXH,
            '''
                     || TO_CHAR (i_period_date, 'Mon-yyyy')
                     || ''' Period
            ,fl.LIC_STATUS--[ANKUR KASAR]
            FROM    fid_company fc1
            ,    fid_company fc2
            ,    fid_contract fct
            ,    fid_licensee fle
            ,    fid_license fl
            ,    (SELECT    com_ter_code
            ,    com_number com_number1
            ,    ter_cur_code
            from     fid_company
            ,            fid_territory
            where     ter_code = com_ter_code
            )    ter
            WHERE    (fle.lee_cha_com_number = fc1.com_number
            AND    fl.lic_lee_number = fle.lee_number
            AND    fct.con_number = fl.lic_con_number
            AND    fc2.com_number = fct.con_com_number
            AND    fc1.com_type IN (''CC'', ''BC'')
            AND    fc1.com_short_name LIKE '''
                     || i_com_short_name
                     || '''  -- CHANNEL COMPANY
            AND    fl.lic_type LIKE '''
                     || i_lic_type
                     || '''        --LIC TYPE
            AND    fle.lee_short_name LIKE '''
                     || i_lee_short_name
                     || '''  -- LINECSEE
            AND    fl.lic_budget_code LIKE '''
                     || i_lic_budget_code
                     || ''' -- BUDGET CODE
            AND    fc2.com_short_name LIKE '''
                     || i_supp_com_name
                     || '''  -- SUPPLIER CODE
            AND    fct.con_short_name LIKE '''
                     || i_con_short_name
                     || '''    --CONTRACT SHORT NAME
            AND    (fl.lic_acct_date > last_day('''
                     || i_period_date
                     || ''') OR fl.lic_acct_date IS NULL)
            AND    fl.lic_status NOT IN (''B'',''T''))
            AND      (ter.com_number1= fc1.com_number)'
                     || l_where_clause
                     || '
            group by 
          --     fc1.com_number   ,         con_short_name ,
                 fc1.com_name
            ,    fc1.com_short_name
            ,    fc1.com_ter_code
            ,    lic_currency
            ,    lic_type
            ,    fle.lee_short_name
            ,    lic_budget_code
            ,       ter.ter_cur_code
          --,    lic_con_number
          --,    lic_number
          --,    lic_price
          --,    lic_markup_percent
          --,    TO_CHAR (lic_end, ''DDMonYYYY'')
          --,    TO_CHAR (lic_end, ''MM.YYYY'')
          --,    fc2.com_number
          --,    PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_MMT(fl.lic_number , con_number , fl.lic_currency , '''
                     || i_period_date
                     || ''',last_day('''
                     || i_period_date
                     || '''))
            ,   PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXRATE(fl.lic_currency,fc1.com_ter_code )
            ,   LIC_STATUS --[ANKUR KASAR]
            ORDER    BY 1    ,    3
            ,    4    ,    2
            ,    5    ,    6
            ,    7    ,    8
            ,    fl.lic_currency        ,    fl.lic_type
            ,    fle.lee_short_name    ,    fl.lic_budget_code';
      DBMS_OUTPUT.put_line (l_qry_text);

      OPEN o_cursor FOR l_qry_text;
   --open o_cursor for select sysdate from dual;
   END prc_fin_mnet_ousncom_mmt_sum;

   PROCEDURE prc_fin_mnet_ousncom_summary (
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_com_short_name    IN       fid_company.com_short_name%TYPE,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      l_qry_text       VARCHAR2 (3500);
      l_where_clause   VARCHAR2 (500);
      l_month          NUMBER;
      l_year           NUMBER;
      l_rsa_ratedate   DATE;
      l_afr_ratedate   DATE;
      l_last_day       DATE;
      v_go_live_date   DATE;
   BEGIN
      
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'FIN_I_LIVE_DATE';
       
       IF TO_CHAR(i_period_date,'YYYYMM') >= TO_CHAR(v_go_live_date,'YYYYMM') OR TO_CHAR(i_from_date,'YYYYMM') >= TO_CHAR(v_go_live_date,'YYYYMM')
       THEN
            prc_fin_mnet_ousncom_summary_n (i_lic_type,
                                            i_lic_budget_code,
                                            i_lee_short_name,
                                            i_com_short_name,
                                            i_supp_com_name,
                                            i_con_short_name,
                                            i_period_date,
                                            i_include_zeros,
                                            i_reg_code,
                                            i_from_date,
                                            i_to_date,
                                            i_rate_type,
                                            i_evaluate_val,
                                            o_cursor);
       ELSE
          BEGIN
              SELECT TO_DATE (content)
                INTO v_go_live_date
                FROM x_fin_configs
               WHERE KEY = 'GO-LIVEDATE';
        
              l_month := TO_NUMBER (TO_CHAR (i_period_date, 'mm'));
              l_year := TO_NUMBER (TO_CHAR (i_period_date, 'yyyy'));
        
              SELECT LAST_DAY (i_to_date)
                INTO l_last_day
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
              IF i_lic_in_or_out = 'IN'
              THEN
                 OPEN o_cursor FOR
                    SELECT   com_name, com_number com_number1, lic_type,
                             lee_short_name, lic_budget_code,
        
                             --SUM (lic_price) lic_price,
                             SUM (lsl_lee_price) lic_price, lic_currency,
                             ter_cur_code, ex_rate,
                             ROUND
                                (SUM
                                    (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              )
                                    ),
                                 2
                                ) paid_sum,
                             ROUND
                                (SUM
                                    (  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                     + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              )
                                    ),
                                 2
                                ) fee,
                             ROUND
                                (SUM
                                    (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                    ),
                                 2
                                ) liab,
                             ROUND
                                (SUM
                                    ((  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                      * ex_rate
                                     )
                                    ),
                                 2
                                ) loc_liab,
                             ROUND
                                (SUM
                                    (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exh_sum
                                                                        (lic_number,
                                                                         i_period_date
                                                                        )
                                    ),
                                 4
                                ) exh   ,
                                LIC_STATUS --[ANKUR KASAR]
                        --reg_code                                     --For Split
                    FROM     (SELECT DISTINCT fc.com_name, fc.com_ter_code,
                                              fc.com_number com_number1, fl.lic_type,
                                              ROUND (fl.lic_price, 2) lic_price,
                                              lsl_lee_price,
                                              lsl.lsl_number lsl_number,
                                              fc1.com_short_name supplier,
                                              fle.lee_short_name, fl.lic_budget_code,
                                          --, fl.lic_con_number
                                          --, fct.con_short_name
                                              fl.lic_currency,
                                          --, con_number
                                              fl.lic_number, fl.lic_markup_percent,
                                              TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                                              TO_CHAR (fl.lic_end, 'MM.YYYY'),
                                              fc1.com_number com_number,
                                              ft.ter_cur_code,
                                              CASE
                                                 WHEN lic_start <
                                                               v_go_live_date
                                                  OR TO_DATE (i_period_date) <
                                                                        v_go_live_date
                                                    THEN ROUND (NVL (rat_rate, 0), 4)
                                                 ELSE DECODE
                                                        (i_rate_type,
                                                         'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                              (fl.lic_currency,
                                                               ft.ter_cur_code,
                                                               DECODE (fre.reg_code,
                                                                       'RSA', l_rsa_ratedate,
                                                                       l_afr_ratedate
                                                                      )
                                                              ),
                                                         'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                     (fl.lic_currency,
                                                                      ft.ter_cur_code,
                                                                      l_last_day
                                                                     )
                                                        )
                                              END ex_rate                          ,
                                              fl.LIC_STATUS --[ANKUR KASAR]
                                            --fre.reg_code                 --For Split
                              FROM            fid_territory ft,
                                              fid_company fc,
                                              fid_company fc1,
                                              fid_contract fct,
                                              fid_licensee fle,
                                              fid_license fl,
                                              fid_exchange_rate,
                                              fid_region fre,              --For Split
                                              x_fin_lic_sec_lee lsl
                                        WHERE ft.ter_code = fc.com_ter_code
                                          AND lee_cha_com_number = fc.com_number
                                          --Dev2:Pure Finance:Start:[Hari Mandal]_[30/04/2013]
                                       -- AND lic_lee_number = fle.lee_number
                                          AND lic_number = lsl.lsl_lic_number
                                          AND fle.lee_number = lsl.lsl_lee_number
                                       -- and fl.lic_entry_date between nvl(i_from_date,fl.lic_entry_date) and nvl(i_to_date,fl.lic_entry_date)
                                          --Dev2:Pure Finance:End-------------------
                                          AND con_number = fl.lic_con_number
                                          AND fc1.com_number = fct.con_com_number
                                          AND fc.com_short_name LIKE i_com_short_name
                                          AND fc.com_type IN ('CC', 'BC')
                                          AND fl.lic_type LIKE i_lic_type
                                          AND fle.lee_short_name LIKE i_lee_short_name
                                          AND fl.lic_budget_code LIKE
                                                                     i_lic_budget_code
                                          AND fc1.com_short_name LIKE i_supp_com_name
                                          AND con_short_name LIKE i_con_short_name
                                          AND (   (   (lic_acct_date >
                                                              LAST_DAY (i_period_date)
                                                      )
                                                   OR (lic_start >
                                                              LAST_DAY (i_period_date)
                                                      )
                                                  )
                                               OR lic_acct_date IS NULL
                                              )
                                          AND fl.lic_status NOT IN ('B', 'F')
                                          AND CASE
                                                 WHEN lic_status = 'C'
                                                    THEN ROUND
                                                           (CASE
                                                               WHEN i_evaluate_val =
                                                                                   'Y'
                                                               AND fl.lic_type = 'ROY'
                                                                  THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                         (fl.lic_number,
                                                                          l_month,
                                                                          l_year
                                                                         )
                                                               ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                                      (fl.lic_number,
                                                                       con_number,
                                                                       fl.lic_currency,
                                                                       LAST_DAY
                                                                          (i_period_date
                                                                          ),
                                                                       lsl_lee_price,
                                                                       fl.lic_markup_percent,
                                                                       lsl.lsl_number
                                                                      )
                                                            END,
                                                            2
                                                           )
                                                 ELSE -1
                                              END < 0
                                          AND rat_cur_code = lic_currency
                                          AND rat_cur_code_2 = ter_cur_code
                                          AND ter_code = fc.com_ter_code
                                          AND TO_DATE (lic_start, 'DD-MON-YYYY') <=
                                                              LAST_DAY (i_period_date)
                                          AND lic_end >= i_period_date
                                          -- AND fle.lee_region_id = fre.reg_id
                                          AND fle.lee_split_region = fre.reg_id(+)
                                          --For Split
                                          AND fre.reg_code LIKE i_reg_code --For Split
                                     ORDER BY fl.lic_currency,
                                              fl.lic_type,
                                              fle.lee_short_name,
                                              fl.lic_budget_code)
                    GROUP BY com_name,
                             com_number,
                             lic_type,
                             lee_short_name,
                             lic_budget_code,
                             lic_currency,
                             ex_rate,
                             ter_cur_code,
                             LIC_STATUS;--[ANKUR KASAR]
              --reg_code;
              END IF;
        
              IF i_lic_in_or_out = 'OUT'
              THEN
                 OPEN o_cursor FOR
                    SELECT   com_name, com_number com_number1, lic_type,
                             lee_short_name, lic_budget_code,
        
                             --SUM (lic_price) lic_price,
                             SUM (lsl_lee_price) lic_price, lic_currency,
                             ter_cur_code, ex_rate,
                             ROUND
                                (SUM
                                    (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              )
                                    ),
                                 2
                                ) paid_sum,
                             ROUND
                                (SUM
                                    (  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                     + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              )
                                    ),
                                 2
                                ) fee,
                             ROUND
                                (SUM
                                    (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                    ),
                                 2
                                ) liab,
                             ROUND
                                (SUM
                                    ((  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                      * ex_rate
                                     )
                                    ),
                                 2
                                ) loc_liab,
                             ROUND
                                (SUM
                                    (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exh_sum
                                                                        (lic_number,
                                                                         i_period_date
                                                                        )
                                    ),
                                 4
                                ) exh,
                                LIC_STATUS --[ANKUR KASAR]
                        --reg_code                                     --For Split
                    FROM     (SELECT DISTINCT fc.com_name, fc.com_ter_code,
                                              fc.com_number com_number1, fl.lic_type,
                                              ROUND (fl.lic_price, 2) lic_price,
                                              lsl_lee_price,
                                              lsl.lsl_number lsl_number,
                                              fc1.com_short_name supplier,
                                              fle.lee_short_name, fl.lic_budget_code,
                                              fl.lic_currency, fl.lic_number,
                                              fl.lic_markup_percent,
                                              TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                                              TO_CHAR (fl.lic_end, 'MM.YYYY'),
                                              fc1.com_number com_number,
                                              ft.ter_cur_code,
                                              CASE
                                                 WHEN lic_start <
                                                               v_go_live_date
                                                  OR TO_DATE (i_period_date) <
                                                                        v_go_live_date
                                                    THEN ROUND (NVL (rat_rate, 0), 4)
                                                 ELSE DECODE
                                                        (i_rate_type,
                                                         'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                              (fl.lic_currency,
                                                               ft.ter_cur_code,
                                                               DECODE (fre.reg_code,
                                                                       'RSA', l_rsa_ratedate,
                                                                       l_afr_ratedate
                                                                      )
                                                              ),
                                                         'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                     (fl.lic_currency,
                                                                      ft.ter_cur_code,
                                                                      l_last_day
                                                                     )
                                                        )
                                              END ex_rate                       ,
                                              fl.LIC_STATUS--[ANKUR KASAR]
                                            --fre.reg_code                 --For Split
                              FROM            fid_territory ft,
                                              fid_company fc,
                                              fid_company fc1,
                                              fid_contract fct,
                                              fid_licensee fle,
                                              fid_license fl,
                                              fid_exchange_rate,
                                              fid_region fre,              --For Split
                                              x_fin_lic_sec_lee lsl
                                        WHERE ft.ter_code = fc.com_ter_code
                                          AND lee_cha_com_number = fc.com_number
                                          ---Dev2:Pure Finance:Start:[Hari_Mandal]_[30/4/2013]
                                       -- AND lic_lee_number = fle.lee_number
                                          AND lic_number = lsl.lsl_lic_number
                                          AND fle.lee_number = lsl.lsl_lee_number
                                      --  and fl.lic_entry_date between nvl(i_from_date,fl.lic_entry_date) and nvl(i_to_date,fl.lic_entry_date)
                                          ---Dev2:Pure Finance:End----------------------------
                                          AND con_number = fl.lic_con_number
                                          AND fc1.com_number = fct.con_com_number
                                          AND fc.com_short_name LIKE i_com_short_name
                                          AND fc.com_type IN ('CC', 'BC')
                                          AND fl.lic_type LIKE i_lic_type
                                          AND fle.lee_short_name LIKE i_lee_short_name
                                          AND fl.lic_budget_code LIKE
                                                                     i_lic_budget_code
                                          AND fc1.com_short_name LIKE i_supp_com_name
                                          AND con_short_name LIKE i_con_short_name
                                          AND (   (   (lic_acct_date >
                                                              LAST_DAY (i_period_date)
                                                      )
                                                   OR (lic_start >
                                                              LAST_DAY (i_period_date)
                                                      )
                                                  )
                                               OR lic_acct_date IS NULL
                                              )
                                          AND fl.lic_status NOT IN ('B', 'F')
                                          AND CASE
                                                 WHEN lic_status = 'C'
                                                    THEN ROUND
                                                           (CASE
                                                               WHEN i_evaluate_val =
                                                                                   'Y'
                                                               AND fl.lic_type = 'ROY'
                                                                  THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                         (fl.lic_number,
                                                                          l_month,
                                                                          l_year
                                                                         )
                                                               ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                                      (fl.lic_number,
                                                                       con_number,
                                                                       fl.lic_currency,
                                                                       LAST_DAY
                                                                          (i_period_date
                                                                          ),
                                                                       lsl_lee_price,
                                                                       fl.lic_markup_percent,
                                                                       lsl.lsl_number
                                                                      )
                                                            END,
                                                            2
                                                           )
                                                 ELSE -1
                                              END < 0
                                          AND rat_cur_code = lic_currency
                                          AND rat_cur_code_2 = ter_cur_code
                                          AND ter_code = fc.com_ter_code
                                        --AND fle.lee_region_id = fre.reg_id
                                          AND fle.lee_split_region = fre.reg_id(+)
                                          --For Split
                                          AND fre.reg_code LIKE i_reg_code
                                          --For Split
                                          AND (   TO_DATE (lic_start, 'DD-MON-YYYY') >
                                                              LAST_DAY (i_period_date)
                                               OR lic_end < i_period_date
                                              )
                                     ORDER BY fl.lic_currency,
                                              fl.lic_type,
                                              fle.lee_short_name,
                                              fl.lic_budget_code)
                    GROUP BY com_name,
                             com_number,
                             lic_type,
                             lee_short_name,
                             lic_budget_code,
                             lic_currency,
                             ex_rate,
                             ter_cur_code,
                             LIC_STATUS;--[ANKUR KASAR]
              --reg_code;
              END IF;
        
              IF i_lic_in_or_out = 'BOTH'
              THEN
                 OPEN o_cursor FOR
                    SELECT   com_name, com_number com_number1, lic_type,
                             lee_short_name, lic_budget_code,
        
                             --SUM (lic_price) lic_price,
                             SUM (lsl_lee_price) lic_price, lic_currency,
                             ter_cur_code, ex_rate,
                             ROUND
                                (SUM
                                    (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              )
                                    ),
                                 2
                                ) paid_sum,
                             ROUND
                                (SUM
                                    (  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                     + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              )
                                    ),
                                 2
                                ) fee,
                             ROUND
                                (SUM
                                    (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                    ),
                                 2
                                ) liab,
                             ROUND
                                (SUM
                                    ((  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                      * ex_rate
                                     )
                                    ),
                                 2
                                ) loc_liab,
                             ROUND
                                (SUM
                                    (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exh_sum
                                                                        (lic_number,
                                                                         i_period_date
                                                                        )
                                    ),
                                 4
                                ) exh ,
                                LIC_STATUS --[ANKUR KASAR]
                        --reg_code                                     --For Split
                    FROM     (SELECT DISTINCT fc.com_name, fc.com_ter_code,
                                              fc.com_number com_number1, fl.lic_type,
                                              ROUND (fl.lic_price, 2) lic_price,
                                              lsl_lee_price,
                                              lsl.lsl_number lsl_number,
                                              fc1.com_short_name supplier,
                                              fle.lee_short_name, fl.lic_budget_code
                                                                                    --, fl.lic_con_number
                                                                                    --, fct.con_short_name
                                              ,
                                              fl.lic_currency
                                                             --, con_number
                                              , fl.lic_number, fl.lic_markup_percent,
                                              TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                                              TO_CHAR (fl.lic_end, 'MM.YYYY'),
                                              fc1.com_number com_number,
                                              ft.ter_cur_code,
                                              CASE
                                                 WHEN lic_start <
                                                               v_go_live_date
                                                  OR TO_DATE (i_period_date) <
                                                                        v_go_live_date
                                                    THEN ROUND (NVL (rat_rate, 0), 4)
                                                 ELSE DECODE
                                                        (i_rate_type,
                                                         'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                              (fl.lic_currency,
                                                               ft.ter_cur_code,
                                                               DECODE (fre.reg_code,
                                                                       'RSA', l_rsa_ratedate,
                                                                       l_afr_ratedate
                                                                      )
                                                              ),
                                                         'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                     (fl.lic_currency,
                                                                      ft.ter_cur_code,
                                                                      l_last_day
                                                                     )
                                                        )
                                              END ex_rate,
                                              fl.LIC_STATUS --[ANKUR KASAR]
                                         --fre.reg_code                 --For Split
                              FROM            fid_territory ft,
                                              fid_company fc,
                                              fid_company fc1,
                                              fid_contract fct,
                                              fid_licensee fle,
                                              fid_license fl,
                                              fid_exchange_rate,
                                              fid_region fre,              --For Split
                                              x_fin_lic_sec_lee lsl
                                        WHERE ft.ter_code = fc.com_ter_code
                                          AND lee_cha_com_number = fc.com_number
                                          --Dev2:Pure Finance:Start:[Hari_Mandal]_[30/4/2013]
                                        --AND lic_lee_number = fle.lee_number
                                          AND lic_number = lsl.lsl_lic_number
                                          AND lee_number = lsl.lsl_lee_number
                                     --   and fl.lic_entry_date between nvl(i_from_date,fl.lic_entry_date) and nvl(i_to_date,fl.lic_entry_date)
                                          --Dev2:Pure Finance:End---------------------------
                                          AND con_number = fl.lic_con_number
                                          AND fc1.com_number = fct.con_com_number
                                          AND fc.com_short_name LIKE i_com_short_name
                                          AND fc.com_type IN ('CC', 'BC')
                                          AND fl.lic_type LIKE i_lic_type
                                          AND fle.lee_short_name LIKE i_lee_short_name
                                          AND fl.lic_budget_code LIKE
                                                                     i_lic_budget_code
                                          AND fc1.com_short_name LIKE i_supp_com_name
                                          AND con_short_name LIKE i_con_short_name
                                          AND (   (   (lic_acct_date >
                                                              LAST_DAY (i_period_date)
                                                      )
                                                   OR (lic_start >
                                                              LAST_DAY (i_period_date)
                                                      )
                                                  )
                                               OR lic_acct_date IS NULL
                                              )
                                          AND fl.lic_status NOT IN ('B', 'F')
                                          AND CASE
                                                 WHEN lic_status = 'C'
                                                    THEN ROUND
                                                           (CASE
                                                               WHEN i_evaluate_val =
                                                                                   'Y'
                                                               AND fl.lic_type = 'ROY'
                                                                  THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                         (fl.lic_number,
                                                                          l_month,
                                                                          l_year
                                                                         )
                                                               ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                                      (fl.lic_number,
                                                                       con_number,
                                                                       fl.lic_currency,
                                                                       LAST_DAY
                                                                          (i_period_date
                                                                          ),
                                                                       lsl_lee_price,
                                                                       fl.lic_markup_percent,
                                                                       lsl.lsl_number
                                                                      )
                                                            END,
                                                            2
                                                           )
                                                 ELSE -1
                                              END < 0
                                          AND rat_cur_code = lic_currency
                                          AND rat_cur_code_2 = ter_cur_code
                                          AND ter_code = fc.com_ter_code
                                        --AND fle.lee_region_id = fre.reg_id
                                          AND fle.lee_split_region = fre.reg_id(+)
                                          --For Split
                                          AND fre.reg_code LIKE i_reg_code --For Split
                                     ORDER BY fl.lic_currency,
                                              fl.lic_type,
                                              fle.lee_short_name,
                                              fl.lic_budget_code)
                    GROUP BY com_name,
                             com_number,
                             lic_type,
                             lee_short_name,
                             lic_budget_code,
                             lic_currency,
                             ex_rate,
                             ter_cur_code,
                             LIC_STATUS --[ANKUR KASAR]
                             ;                                         --,
              --reg_code;
              END IF;
          END;
       END IF;
   END prc_fin_mnet_ousncom_summary;

   PROCEDURE PRC_FIN_MNET_DET_EXP_TO_EXL (
/********************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         06-May-2016       Zeshan Khan                  Included field Effective subscribers for ROY licenses, when i_evaluate_val = 'Y'.
**********************************************************************************************************************************************/
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      l_lic_type          IN       fid_license.lic_type%TYPE,
      l_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      l_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      l_com_short_name    IN       fid_company.com_short_name%TYPE, --SUPPLIER
      l_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      l_where_clause   VARCHAR2 (100);
      L_QUERY_STRING   VARCHAR2 (25000); --[Ver 0.1 Increased var size]

      l_month          NUMBER;
      l_year           NUMBER;
      l_last_day       DATE;
      v_go_live_date   DATE;
      l_rsa_ratedate   DATE;
      L_AFR_RATEDATE   DATE;

   BEGIN
      
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'FIN_I_LIVE_DATE';
       
      IF TO_CHAR(i_period_date,'YYYYMM') >= TO_CHAR(v_go_live_date,'YYYYMM') OR TO_CHAR(i_from_date,'YYYYMM') >= TO_CHAR(v_go_live_date,'YYYYMM')
      THEN
           prc_fin_mnet_det_exp_to_exl_n (i_channel_comp,
                                          l_lic_type,
                                          l_lic_budget_code,
                                          l_lee_short_name,
                                          l_com_short_name,
                                          l_con_short_name,
                                          i_period_date,
                                          i_include_zeros,
                                          i_reg_code,
                                          i_from_date,
                                          i_to_date,
                                          i_rate_type,
                                          i_evaluate_val,
                                          o_cursor);
      ELSE
          BEGIN
          ---Dev2:Pure Finance:Start:[Hari_Mandal]_[30/4/2013]
                l_month := TO_NUMBER (TO_CHAR (i_period_date, 'mm'));
                L_YEAR := TO_NUMBER (TO_CHAR (I_PERIOD_DATE, 'yyyy'));
          
                SELECT LAST_DAY (i_to_date)
                  INTO l_last_day
                  FROM DUAL;
          
                SELECT TO_DATE (content)
                  INTO v_go_live_date
                  FROM X_FIN_CONFIGS
                 WHERE KEY = 'GO-LIVEDATE';
          
                ------Calculate Rate Date ----------
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
          
                ---Dev2:Pure Finance:End------------------------------------
                IF i_lic_in_or_out = 'IN'
                THEN
                   l_where_clause :=
                         ' AND Lic_start <= '''
                      || LAST_DAY (i_period_date)
                      || '''And Lic_end >= '''
                      || i_period_date
                      || '''';
                ELSIF i_lic_in_or_out = 'OUT'
                THEN
                   l_where_clause :=
                         ' AND Lic_start > '''
                      || LAST_DAY (i_period_date)
                      || '''And Lic_end < '''
                      || i_period_date
                      || '''';
                ELSIF i_lic_in_or_out = 'BOTH'
                THEN
                   l_where_clause := '';
                END IF;
          
                /*********************Stopped insering select query result to excel sheet and filler directly into cursor****************************/
                --DELETE FROM exl_outstanding_commitment;
                COMMIT;
          
                --FIN CR Rewrite the code as per new requirnment and added dynamic query instead of static SQL.
                L_QUERY_STRING := 'SELECT channel_company,
                                          lic_currency
                                          ,PERIOD_DATE
                                          , ter_cur_code,
                                          lic_type, lee_short_name, lic_budget_code, supplier,
                                          con_short_name, lic_number, gen_title, acct_date,
                                          lic_start, lic_end, ROUND (fee, 2) fee, ';
                --[Ver 0.1] [START]  fl.lic_type = ''ROY''
                IF I_EVALUATE_VAL = 'Y'
                THEN
                  L_QUERY_STRING := L_QUERY_STRING || '
                   CASE WHEN lic_type =''ROY''
                   THEN
                   round( (nvl(round(fee,2),0))/(decode(lic_price,0,1,round(lic_price,2))) )
                   ELSE
                   NULL
                   END Effective_Subs,';
                END IF;
                --[Ver 0.1] [END]
                L_QUERY_STRING := L_QUERY_STRING ||
                                          '
                                          ROUND (lic_price, 2) lic_price, ROUND (paid, 2) paid,
                                          ROUND (liab, 2) liab,
                                          ROUND (exchange_rate, 5) exchange_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                                          ROUND (loc_liab, 2) loc_liab, lic_amort_code, reg_code,lic_status 
                              FROM (
                                     SELECT   fc.com_name channel_company, fl.lic_currency,
                                      TO_CHAR (TO_DATE('''||i_period_date||'''), ''YYYY/MM/DD'') PERIOD_DATE,
                                       ft.ter_cur_code, fl.lic_type, lee_short_name,
                                       fl.lic_budget_code, b.com_short_name supplier,
                                       fct.con_short_name, fl.lic_number, fg.gen_title,
                                       TO_CHAR (lic_acct_date, ''YYYY.MM'') acct_date,
                                       TO_CHAR (LIC_START, ''DD-MON-RRRR'') LIC_START,
                                       TO_CHAR (lic_end, ''DD-MON-RRRR'') lic_end,
                                       ROUND
                                          (  CASE
                                                WHEN '''||i_evaluate_val||''' = ''Y''
                                                AND fl.lic_type = ''ROY''
                                                THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                         (fl.lic_number,'
                                                                         ||l_month||
                                                                         ','
                                                                          ||l_year||
                                                                         ')
                                                ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                               (fl.lic_number,
                                                                con_number,
                                                                fl.lic_currency,
                                                                LAST_DAY ('''
                                                                ||i_period_date||
                                                                '''),
                                                                lsl.lsl_lee_price,
                                                                fl.lic_markup_percent,
                                                                lsl.lsl_number
                                                               )
                                              END
                                       + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid
                                                                (fl.lic_number,
                                                                 con_number,
                                                                 fl.lic_currency,
                                                                 lsl.lsl_number,
                                                                 LAST_DAY ('''
                                                                 ||i_period_date||
                                                                 ''')
                                                                ),
                                           2
                                          ) fee,';
          
                   L_QUERY_STRING := L_QUERY_STRING ||'
                                       lsl_lee_price lic_price,
                                       ROUND
                                          (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid
                                                                (fl.lic_number,
                                                                 con_number,
                                                                 fl.lic_currency,
                                                                 lsl.lsl_number,
                                                                 LAST_DAY ('''
                                                                 ||i_period_date||
                                                                 ''')
                                                                ),
                                           2
                                          ) paid,
                                       ROUND
                                          (CASE
                                              WHEN '''
                                                    ||i_evaluate_val||
                                                    '''	= ''Y''
                                                    AND fl.lic_type = ''ROY''
                                              THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                         (fl.lic_number,'
                                                                          ||L_MONTH||','
                                                                          ||l_year||'
                                                                         )
                                              ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                               (fl.lic_number,
                                                                con_number,
                                                                fl.lic_currency,
                                                                LAST_DAY ('''
                                                               ||i_period_date||
                                                               '''),
                                                                lsl_lee_price,
                                                                fl.lic_markup_percent,
                                                                lsl.lsl_number
                                                               )
                                           END,
                                           2
                                          ) liab,
                                       CASE
                                          WHEN lic_start < '''
                                                            ||v_go_live_date||
                                                            '''OR TO_DATE ('''
                                                            ||i_period_date||
                                                            ''') < '''
                                                            ||v_go_live_date||
                                                            '''THEN ROUND
                                                                  (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exrate
                                                                                     (fl.lic_currency,
                                                                                      fc.com_ter_code
                                                                                     ),
                                                                   4
                                                                  )
                                          ELSE DECODE
                                                 ('''
                                                   ||i_rate_type||
                                                   ''',
                                                  ''M'', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                  (fl.lic_currency,
                                                   ft.ter_cur_code,
                                                   DECODE (fre.reg_code,
                                                           ''RSA'', '''
                                                           ||l_rsa_ratedate||
                                                           ''','''
                                                           ||l_afr_ratedate||
                                                          ''')
                                                  ),
                                                  ''R'', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                       (fl.lic_currency,
                                                                        ft.ter_cur_code,'''
                                                                        ||l_last_day||
                                                                       ''')
                                                 )
                                       END exchange_rate,
                                       ROUND
                                          (  CASE
                                                WHEN '''
                                                ||i_evaluate_val||
                                                '''= ''Y''
                                                AND fl.lic_type = ''ROY''
                                                   THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                         (fl.lic_number,'
                                                                          ||l_month||
                                                                          ','
                                                                          ||l_year||
                                                                          ')
                                                ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                               (fl.lic_number,
                                                                con_number,
                                                                fl.lic_currency,
                                                                LAST_DAY ('''
                                                               ||i_period_date||
                                                               '''),
                                                                lsl_lee_price,
                                                                fl.lic_markup_percent,
                                                                lsl.lsl_number
                                                               )
                                             END
                                           * CASE
                                                WHEN lic_start < '''||
                                                v_go_live_date||'''
                                                 OR TO_DATE ('''
                                                               ||i_period_date||
                                                               ''') < '''
                                                               ||v_go_live_date||
                                                   '''THEN ROUND
                                                          (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exrate
                                                                       (fl.lic_currency,
                                                                        fc.com_ter_code
                                                                       ),
                                                           4
                                                          )
                                                ELSE ROUND
                                                       (DECODE
                                                           ('''
                                                             ||i_rate_type||''',
                                                            ''M'', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                                (fl.lic_currency,
                                                                 ft.ter_cur_code,
                                                                 DECODE (fre.reg_code,
                                                                         ''RSA'', '''
                                                                         ||l_rsa_ratedate||
                                                                         ''','''
                                                                         ||l_afr_ratedate||
                                                                        ''')
                                                                ),
                                                            ''R'', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                       (fl.lic_currency,
                                                                        ft.ter_cur_code,'''
                                                                        ||l_last_day||
                                                                       ''')
                                                           ),
                                                        4
                                                       )
                                             END,
                                           2
                                          ) loc_liab,
                                       fl.lic_amort_code, 
                                       fre.reg_code,
                                       fl.lic_status
                                  FROM fid_company fc,
                                       fid_company b,
                                       fid_contract fct,
                                       fid_licensee fle,
                                       fid_license fl,
                                       fid_territory ft,
                                       fid_general fg,
                                       sak_memo,
                                       fid_region fre,
                                       x_fin_lic_sec_lee lsl
                                 WHERE lee_cha_com_number = fc.com_number
                                   AND gen_refno = lic_gen_refno
                                   AND ter_code = fc.com_ter_code
                                   AND fc.com_type IN (''CC'', ''BC'')
                                   AND fl.lic_number = lsl.lsl_lic_number
                                   AND fle.lee_number = lsl.lsl_lee_number
                                   AND fle.lee_split_region = fre.reg_id(+)
                                   AND con_number = lic_con_number
                                   AND mem_id = lic_mem_number
                                   AND b.com_number = con_com_number
                                   AND fl.lic_type LIKE '''||l_lic_type||'''
                                   AND fle.lee_short_name LIKE '''||l_lee_short_name||'''
                                   AND fl.lic_budget_code LIKE '''||l_lic_budget_code||'''
                                   AND b.com_short_name LIKE '''||l_com_short_name||'''
                                   AND fc.com_short_name LIKE '''||i_channel_comp||'''
                                   AND fct.con_short_name LIKE '''||l_con_short_name||'''
                                   AND fre.reg_code LIKE '''||i_reg_code||'''
                                   AND (   (   (lic_acct_date > LAST_DAY ('''
                                          ||i_period_date||
                                          ''')
                                               )
                                            OR (lic_start > LAST_DAY ('''
                                          ||i_period_date||
                                          '''))
                                           )
                                        OR lic_acct_date IS NULL
                                       )
                                   AND lic_status NOT IN
                                                     (''B'', ''F'', ''T'') --|| l_where_clause
                                   AND CASE
                                          WHEN lic_status = ''C''
                                             THEN ROUND
                                                    (CASE
                                                        WHEN '''||i_evaluate_val||''' = ''Y''
                                                        AND fl.lic_type = ''ROY''
                                                           THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                         (fl.lic_number,'
                                                                          ||l_month||','
                                                                          ||l_year||'
                                                                         )
                                                        ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                               (fl.lic_number,
                                                                con_number,
                                                                fl.lic_currency,
                                                                LAST_DAY ('''
                                                                ||i_period_date||
                                                                '''),
                                                                lsl_lee_price,
                                                                fl.lic_markup_percent,
                                                                lsl.lsl_number
                                                               )
                                                     END,
                                                     2
                                                    )
                                          ELSE -1
                                       END < 0
                                   ';
          
                      IF i_include_zeros = 'N'
                      THEN
                      L_QUERY_STRING := L_QUERY_STRING || 'AND (   (   ROUND
                                                  (  CASE
                                                        WHEN
                                                        '''
                                                        || i_evaluate_val
                                                        ||''' = ''Y''
                                                        AND fl.lic_type = ''ROY''
                                                           THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                         (fl.lic_number,'
                                                                          ||l_month
                                                                          ||','
                                                                          ||l_year||'
                                                                         )
                                                        ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                               (fl.lic_number,
                                                                con_number,
                                                                fl.lic_currency,
                                                                LAST_DAY ('''
                                                                ||i_period_date||'''),
                                                                lsl_lee_price,
                                                                fl.lic_markup_percent,
                                                                lsl.lsl_number
                                                               )
                                                     END
                                                   + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid
                                                                (fl.lic_number,
                                                                 con_number,
                                                                 fl.lic_currency,
                                                                 lsl.lsl_number,
                                                                 LAST_DAY ('''
                                                                 ||i_period_date||
                                                                 ''')
                                                                ),
                                                   2
                                                  ) <> 0
                                            OR ROUND
                                                  (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid
                                                                (fl.lic_number,
                                                                 con_number,
                                                                 fl.lic_currency,
                                                                 lsl.lsl_number,
                                                                 LAST_DAY ('''
                                                                 ||i_period_date||
                                                                 ''')
                                                                ),
                                                   2
                                                  ) <> 0
                                           )
                                        OR (lsl_lee_price <> 0)
                                       )';
                         END IF;
          
                      L_QUERY_STRING := L_QUERY_STRING || '
                                  ORDER BY fc.com_name,
                   fl.lic_currency,
                   fl.lic_type,
                   fle.lee_short_name,
                   fl.lic_budget_code,
                   b.com_short_name,
                   fct.con_short_name,
                   fl.lic_number)';
          
                  OPEN O_CURSOR FOR L_QUERY_STRING;
             EXCEPTION
                WHEN OTHERS
                THEN
                   raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
          END;
      END IF;
   
   END prc_fin_mnet_det_exp_to_exl;

   PROCEDURE prc_fin_mnet_sum_exp_to_exl (
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_com_short_name    IN       fid_company.com_short_name%TYPE,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_lic_in_or_out     IN       VARCHAR2,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      l_qry_text       VARCHAR2 (3500);
      l_where_clause   VARCHAR2 (500);
      l_month          NUMBER;
      l_year           NUMBER;
      l_afr_ratedate   DATE;
      l_rsa_ratedate   DATE;
      l_last_day       DATE;
      v_go_live_date   DATE;
   BEGIN
      
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'FIN_I_LIVE_DATE';
      
      IF TO_CHAR(i_period_date,'YYYYMM') >= TO_CHAR(v_go_live_date,'YYYYMM') OR TO_CHAR(i_from_date,'YYYYMM') >= TO_CHAR(v_go_live_date,'YYYYMM')
      THEN
           prc_fin_mnet_sum_exp_to_exl_n (i_lic_type,
                                          i_lic_budget_code,
                                          i_lee_short_name,
                                          i_com_short_name,
                                          i_supp_com_name,
                                          i_con_short_name,
                                          i_period_date,
                                          i_include_zeros,
                                          i_reg_code,
                                          i_from_date,
                                          i_to_date,
                                          i_rate_type,
                                          i_evaluate_val,
                                          o_cursor);
      ELSE
          BEGIN
              ---Dev2:Pure Finance:Start:[Hari_Mandal]_[30/4/2013]
              l_month := TO_NUMBER (TO_CHAR (i_period_date, 'mm'));
              l_year := TO_NUMBER (TO_CHAR (i_period_date, 'yyyy'));
        
              SELECT LAST_DAY (i_to_date)
                INTO l_last_day
                FROM DUAL;
        
              SELECT TO_DATE (content)
                INTO v_go_live_date
                FROM x_fin_configs
               WHERE KEY = 'GO-LIVEDATE';
        
              ------Calculate Rate Date ----------
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
        
              ---Dev2:Pure Finance:End------------------------------------
              IF i_lic_in_or_out = 'IN'
              THEN
                 l_where_clause :=
                       ' AND Lic_start <= '''
                    || LAST_DAY (i_period_date)
                    || '''And Lic_end >= '''
                    || i_period_date
                    || '''';
              ELSIF i_lic_in_or_out = 'OUT'
              THEN
                 l_where_clause :=
                       ' AND Lic_start > '''
                    || LAST_DAY (i_period_date)
                    || '''And Lic_end < '''
                    || i_period_date
                    || '''';
              ELSIF i_lic_in_or_out = 'BOTH'
              THEN
                 l_where_clause := '';
              END IF;
        
              IF i_lic_in_or_out = 'IN'
              THEN
                 OPEN o_cursor FOR
                    SELECT channel_company com_name, lic_currency,
        
                           -- TO_CHAR (i_period_date, 'YYYY/MM/DD HH:MI:SS') period,
                           TO_CHAR (i_period_date, 'YYYY/MM/DD') period,
                           ter_cur_code, lic_type, lee_short_name, lic_budget_code
                   --  ,round(EXH,2)EXH
                           ,
                           ROUND (fee, 2) fee, ROUND (paid, 2) paid,
                           ROUND (liab, 2) liab,
                           ROUND (exchange_rate, 5) exchange_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                           ROUND (loc_liab, 2) loc_liab ,lic_status
                      --reg_code
                    FROM   (SELECT com_name channel_company, lic_currency
                                                                         ---,    to_char(i_period_date,'Mon-yyyy') Period
                                   ,
                                   ter_cur_code, lic_type, lee_short_name,
                                   lic_budget_code, supplier, con_short_name,
                                   lic_number
                                             ----, fg.gen_title
                                   , lic_acct_date, lic_start, lic_end,
                                   ROUND
                                      (  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                       + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              ),
                                       2
                                      ) fee,
        
                                   --ROUND (lic_price, 2) lic_price,
                                   ROUND (lsl_lee_price, 2) lic_price,
                                   ROUND
                                      (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              ),
                                       2
                                      ) paid,
                                   ROUND
                                      (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             ),
                                       2
                                      ) liab,
                                   ex_rate exchange_rate,
                                   ROUND
                                      ((  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                        * ex_rate
                                       ),
                                       2
                                      ) loc_liab,
                                   lic_amort_code, com_number,
                                   ROUND
                                      (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exh_sum
                                                                        (lic_number,
                                                                         i_period_date
                                                                        ),
                                       2
                                      ) exh,
                                   reg_code,lic_status
                              FROM (SELECT DISTINCT fc.com_name, fc.com_ter_code,
                                                    fc.com_number com_number1,
                                                    fl.lic_type,
                                                    ROUND (fl.lic_price, 2) lic_price,
                                                    lsl_lee_price,
                                                    lsl.lsl_number lsl_number,
                                                    fc1.com_short_name supplier,
                                                    fle.lee_short_name,
                                                    fl.lic_budget_code
                                                                      --, fl.lic_con_number
                                                    ,
                                                    fct.con_short_name,
                                                    fl.lic_currency
                                                                   --, con_number
                                                    , fl.lic_number,
                                                    fl.lic_markup_percent,
                                                    TO_CHAR (fl.lic_start,
                                                             'DDMonYYYY'
                                                            ) lic_start,
                                                    TO_CHAR (fl.lic_end,
                                                             'DDMonYYYY'
                                                            ) lic_end,
                                                    TO_CHAR (fl.lic_end, 'MM.YYYY'),
                                                    TO_CHAR
                                                        (lic_acct_date,
                                                         'YYYY.MM'
                                                        ) lic_acct_date,
                                                    fc1.com_number com_number,
                                                    ft.ter_cur_code,
                                                    CASE
                                                       WHEN lic_start <
                                                               v_go_live_date
                                                        OR TO_DATE (i_period_date) <
                                                                        v_go_live_date
                                                          THEN ROUND (NVL (rat_rate,
                                                                           0),
                                                                      4
                                                                     )
                                                       ELSE DECODE
                                                              (i_rate_type,
                                                               'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                                  (fl.lic_currency,
                                                                   ft.ter_cur_code,
                                                                   DECODE
                                                                      (fre.reg_code,
                                                                       'RSA', l_rsa_ratedate,
                                                                       l_afr_ratedate
                                                                      )
                                                                  ),
                                                               'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                     (fl.lic_currency,
                                                                      ft.ter_cur_code,
                                                                      l_last_day
                                                                     )
                                                              )
                                                    END ex_rate,
                                                    lic_amort_code, 
                                                    fre.reg_code,
                                                    fl.lic_status
                                               FROM fid_territory ft,
                                                    fid_company fc,
                                                    fid_company fc1,
                                                    fid_contract fct,
                                                    fid_licensee fle,
                                                    fid_license fl,
                                                    fid_exchange_rate,
                                                    fid_region fre,
                                                    x_fin_lic_sec_lee lsl
                                              WHERE ft.ter_code = fc.com_ter_code
                                                AND lee_cha_com_number = fc.com_number
                                                --Dev2:Pure Finance:Start:[Hari Mandal]_[30/4/2013]
                                                -- AND lic_lee_number = fle.lee_number
                                                AND lic_number = lsl.lsl_lic_number
                                                AND fle.lee_number =
                                                                    lsl.lsl_lee_number
                                                --   and fl.lic_entry_date between nvl(i_from_date,fl.lic_entry_date) and nvl(i_to_date,fl.lic_entry_date)
                                                --Dev2:Pure Finance:End-----------------------
                                                AND con_number = fl.lic_con_number
                                                AND fc1.com_number =
                                                                    fct.con_com_number
                                                AND fc.com_short_name LIKE
                                                                      i_com_short_name
                                                AND fc.com_type IN ('CC', 'BC')
                                                AND fl.lic_type LIKE i_lic_type
                                                AND fle.lee_short_name LIKE
                                                                      i_lee_short_name
                                                AND fl.lic_budget_code LIKE
                                                                     i_lic_budget_code
                                                AND fc1.com_short_name LIKE
                                                                       i_supp_com_name
                                                AND con_short_name LIKE
                                                                      i_con_short_name
                                                AND (   (   (lic_acct_date >
                                                                LAST_DAY
                                                                        (i_period_date)
                                                            )
                                                         OR (lic_start >
                                                                LAST_DAY
                                                                        (i_period_date)
                                                            )
                                                        )
                                                     OR lic_acct_date IS NULL
                                                    )
                                                AND lic_end >= i_period_date
                                                AND fl.lic_status NOT IN
                                                                      ('B', 'F', 'T')
                                                AND CASE
                                                       WHEN lic_status = 'C'
                                                          THEN ROUND
                                                                 (CASE
                                                                     WHEN i_evaluate_val =
                                                                                   'Y'
                                                                     AND fl.lic_type =
                                                                                 'ROY'
                                                                        THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                               (fl.lic_number,
                                                                                l_month,
                                                                                l_year
                                                                               )
                                                                     ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                                            (fl.lic_number,
                                                                             con_number,
                                                                             fl.lic_currency,
                                                                             LAST_DAY
                                                                                (i_period_date
                                                                                ),
                                                                             lsl_lee_price,
                                                                             fl.lic_markup_percent,
                                                                             lsl.lsl_number
                                                                            )
                                                                  END,
                                                                  2
                                                                 )
                                                       ELSE -1
                                                    END < 0
                                                AND rat_cur_code = lic_currency
                                                AND rat_cur_code_2 = ter_cur_code
                                                AND ter_code = fc.com_ter_code
                                                --Dev2:Pure Finance:Start:[Hari Mandal]_[30/4/2013]
                                                --AND fle.lee_region_id = fre.reg_id
                                                AND fle.lee_split_region = fre.reg_id(+)
                                                --Dev2:Pure Finance:End-----------------------------
                                                AND fre.reg_code LIKE i_reg_code
                                           ORDER BY fl.lic_currency,
                                                    fl.lic_type,
                                                    fle.lee_short_name,
                                                    fl.lic_budget_code));
              END IF;
        
              IF i_lic_in_or_out = 'OUT'
              THEN
                 OPEN o_cursor FOR
                    SELECT channel_company com_name, lic_currency,
        
                           -- TO_CHAR (i_period_date, 'YYYY/MM/DD HH:MI:SS') period,
                           TO_CHAR (i_period_date, 'YYYY/MM/DD') period,
                           ter_cur_code, lic_type, lee_short_name, lic_budget_code,
                           ROUND (exh, 2) exh, ROUND (fee, 2) fee,
                           ROUND (paid, 2) paid, ROUND (liab, 2) liab,
                           ROUND (exchange_rate, 5) exchange_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                           ROUND (loc_liab, 2) loc_liab,lic_status
                      FROM (SELECT com_name channel_company, lic_currency,
                                   ter_cur_code, lic_type, lee_short_name,
                                   lic_budget_code, supplier, con_short_name,
                                   lic_number
                                             ----, fg.gen_title
                                   , lic_acct_date, lic_start, lic_end,
                                   ROUND
                                      (  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                       + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              ),
                                       2
                                      ) fee,
        
                                   --ROUND (lic_price, 2) lic_price,
                                   ROUND (lsl_lee_price, 2) lic_price,
                                   ROUND
                                      (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              ),
                                       2
                                      ) paid,
                                   ROUND
                                      (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             ),
                                       2
                                      ) liab,
                                   ex_rate exchange_rate,
                                   ROUND
                                      ((  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                        * ex_rate
                                       ),
                                       2
                                      ) loc_liab,
                                   lic_amort_code, com_number,
                                   ROUND
                                      (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exh_sum
                                                                        (lic_number,
                                                                         i_period_date
                                                                        ),
                                       2
                                      ) exh,
                                   reg_code,lic_status
                              FROM (SELECT DISTINCT fc.com_name, fc.com_ter_code,
                                                    fc.com_number com_number1,
                                                    fl.lic_type,
                                                    ROUND (fl.lic_price, 2) lic_price,
                                                    lsl_lee_price,
                                                    lsl.lsl_number lsl_number,
                                                    fc1.com_short_name supplier,
                                                    fle.lee_short_name,
                                                    fl.lic_budget_code,
                                                    fct.con_short_name,
                                                    fl.lic_currency, fl.lic_number,
                                                    fl.lic_markup_percent,
                                                    TO_CHAR (fl.lic_start,
                                                             'DDMonYYYY'
                                                            ) lic_start,
                                                    TO_CHAR (fl.lic_end,
                                                             'DDMonYYYY'
                                                            ) lic_end,
                                                    TO_CHAR (fl.lic_end, 'MM.YYYY'),
                                                    TO_CHAR
                                                        (lic_acct_date,
                                                         'YYYY.MM'
                                                        ) lic_acct_date,
                                                    fc1.com_number com_number,
                                                    ft.ter_cur_code,
                                                    CASE
                                                       WHEN lic_start <
                                                               v_go_live_date
                                                        OR TO_DATE (i_period_date) <
                                                                        v_go_live_date
                                                          THEN ROUND (NVL (rat_rate,
                                                                           0),
                                                                      4
                                                                     )
                                                       ELSE DECODE
                                                              (i_rate_type,
                                                               'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                                  (fl.lic_currency,
                                                                   ft.ter_cur_code,
                                                                   DECODE
                                                                      (fre.reg_code,
                                                                       'RSA', l_rsa_ratedate,
                                                                       l_afr_ratedate
                                                                      )
                                                                  ),
                                                               'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                     (fl.lic_currency,
                                                                      ft.ter_cur_code,
                                                                      l_last_day
                                                                     )
                                                              )
                                                    END ex_rate,
                                                    lic_amort_code, fre.reg_code,fl.lic_status
                                               FROM fid_territory ft,
                                                    fid_company fc,
                                                    fid_company fc1,
                                                    fid_contract fct,
                                                    fid_licensee fle,
                                                    fid_license fl,
                                                    fid_exchange_rate,
                                                    fid_region fre,
                                                    x_fin_lic_sec_lee lsl
                                              WHERE ft.ter_code = fc.com_ter_code
                                                AND lee_cha_com_number = fc.com_number
                                                --Dev2:Pure Finance:Start:[Hari Mandal]_[30/4/2013]
                                                -- AND lic_lee_number = fle.lee_number
                                                AND fl.lic_number = lsl.lsl_lic_number
                                                AND fle.lee_number =
                                                                    lsl.lsl_lee_number
                                                --  and fl.lic_entry_date between nvl(i_from_date,fl.lic_entry_date) and nvl(i_to_date,fl.lic_entry_date)
                                                --Dev2:Pure Finance:End
                                                AND con_number = fl.lic_con_number
                                                AND fc1.com_number =
                                                                    fct.con_com_number
                                                AND fc.com_short_name LIKE
                                                                      i_com_short_name
                                                AND fc.com_type IN ('CC', 'BC')
                                                AND fl.lic_type LIKE i_lic_type
                                                AND fle.lee_short_name LIKE
                                                                      i_lee_short_name
                                                AND fl.lic_budget_code LIKE
                                                                     i_lic_budget_code
                                                AND fc1.com_short_name LIKE
                                                                       i_supp_com_name
                                                AND con_short_name LIKE
                                                                      i_con_short_name
                                                AND (   (   (lic_acct_date >
                                                                LAST_DAY
                                                                        (i_period_date)
                                                            )
                                                         OR (lic_start >
                                                                LAST_DAY
                                                                        (i_period_date)
                                                            )
                                                        )
                                                     OR lic_acct_date IS NULL
                                                    )
                                                AND fl.lic_status NOT IN
                                                                      ('B', 'F', 'T')
                                                AND CASE
                                                       WHEN lic_status = 'C'
                                                          THEN ROUND
                                                                 (CASE
                                                                     WHEN i_evaluate_val =
                                                                                   'Y'
                                                                     AND fl.lic_type =
                                                                                 'ROY'
                                                                        THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                               (fl.lic_number,
                                                                                l_month,
                                                                                l_year
                                                                               )
                                                                     ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                                            (fl.lic_number,
                                                                             con_number,
                                                                             fl.lic_currency,
                                                                             LAST_DAY
                                                                                (i_period_date
                                                                                ),
                                                                             lsl_lee_price,
                                                                             fl.lic_markup_percent,
                                                                             lsl.lsl_number
                                                                            )
                                                                  END,
                                                                  2
                                                                 )
                                                       ELSE -1
                                                    END < 0
                                                AND rat_cur_code = lic_currency
                                                AND rat_cur_code_2 = ter_cur_code
                                                AND ter_code = fc.com_ter_code
                                                --Dev2:Pure Finance:Start:[Hari Mandal]_[30/4/2013]
                                                --AND fle.lee_region_id = fre.reg_id
                                                AND fle.lee_split_region = fre.reg_id(+)
                                                --Dev2:Pure Finance:End
                                                AND fre.reg_code LIKE i_reg_code
                                           ORDER BY fl.lic_currency,
                                                    fl.lic_type,
                                                    fle.lee_short_name,
                                                    fl.lic_budget_code));
              END IF;
        
              IF i_lic_in_or_out = 'BOTH'
              THEN
                 OPEN o_cursor FOR
                    SELECT channel_company com_name, lic_currency,
        
                           -- TO_CHAR (i_period_date, 'YYYY/MM/DD HH:MI:SS') period,
                           TO_CHAR (i_period_date, 'YYYY/MM/DD') period,
                           ter_cur_code, lic_type, lee_short_name, lic_budget_code,
                           ROUND (exh, 2) exh, ROUND (fee, 2) fee,
                           ROUND (paid, 2) paid, ROUND (liab, 2) liab,
                           ROUND (exchange_rate, 5) exchange_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                           ROUND (loc_liab, 2) loc_liab,lic_status
                      FROM (SELECT com_name channel_company, lic_currency
                                                                         ---,    to_char(i_period_date,'Mon-yyyy') Period
                                   ,
                                   ter_cur_code, lic_type, lee_short_name,
                                   lic_budget_code, supplier, con_short_name,
                                   lic_number
                                             ----, fg.gen_title
                                   , lic_acct_date, lic_start, lic_end,
                                   ROUND
                                      (  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                       + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              ),
                                       2
                                      ) fee,
        
                                   --ROUND (lic_price, 2) lic_price,
                                   ROUND (lsl_lee_price, 2) lic_price,
                                   ROUND
                                      (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                              (lic_number,
                                                               lic_currency,
                                                               lsl_number,
                                                               LAST_DAY (i_period_date)
                                                              ),
                                       2
                                      ) paid,
                                   ROUND
                                      (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             ),
                                       2
                                      ) liab,
                                   ex_rate exchange_rate,
                                   ROUND
                                      ((  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                             (lic_number,
                                                              lic_currency,
                                                              LAST_DAY (i_period_date),
                                                              lsl_lee_price,
                                                              lic_markup_percent,
                                                              lic_type,
                                                              lsl_number,
                                                              i_evaluate_val
                                                             )
                                        * ex_rate
                                       ),
                                       2
                                      ) loc_liab,
                                   lic_amort_code, com_number,
                                   ROUND
                                      (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exh_sum
                                                                        (lic_number,
                                                                         i_period_date
                                                                        ),
                                       2
                                      ) exh,
                                   reg_code,lic_status
                              FROM (SELECT DISTINCT fc.com_name, fc.com_ter_code,
                                                    fc.com_number com_number1,
                                                    fl.lic_type,
                                                    ROUND (fl.lic_price, 2) lic_price,
                                                    lsl_lee_price,
                                                    lsl.lsl_number lsl_number,
                                                    fc1.com_short_name supplier,
                                                    fle.lee_short_name,
                                                    fl.lic_budget_code
                                                                      --, fl.lic_con_number
                                                    ,
                                                    fct.con_short_name,
                                                    fl.lic_currency
                                                                   --, con_number
                                                    , fl.lic_number,
                                                    fl.lic_markup_percent,
                                                    TO_CHAR (fl.lic_start,
                                                             'DDMonYYYY'
                                                            ) lic_start,
                                                    TO_CHAR (fl.lic_end,
                                                             'DDMonYYYY'
                                                            ) lic_end,
                                                    TO_CHAR (fl.lic_end, 'MM.YYYY'),
                                                    TO_CHAR
                                                        (lic_acct_date,
                                                         'YYYY.MM'
                                                        ) lic_acct_date,
                                                    fc1.com_number com_number,
                                                    ft.ter_cur_code,
                                                    CASE
                                                       WHEN lic_start <
                                                               v_go_live_date
                                                        OR TO_DATE (i_period_date) <
                                                                        v_go_live_date
                                                          THEN ROUND (NVL (rat_rate,
                                                                           0),
                                                                      4
                                                                     )
                                                       ELSE DECODE
                                                              (i_rate_type,
                                                               'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                                  (fl.lic_currency,
                                                                   ft.ter_cur_code,
                                                                   DECODE
                                                                      (fre.reg_code,
                                                                       'RSA', l_rsa_ratedate,
                                                                       l_afr_ratedate
                                                                      )
                                                                  ),
                                                               'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                                     (fl.lic_currency,
                                                                      ft.ter_cur_code,
                                                                      l_last_day
                                                                     )
                                                              )
                                                    END ex_rate,
                                                    lic_amort_code, fre.reg_code,fl.lic_status
                                               FROM fid_territory ft,
                                                    fid_company fc,
                                                    fid_company fc1,
                                                    fid_contract fct,
                                                    fid_licensee fle,
                                                    fid_license fl,
                                                    fid_exchange_rate,
                                                    fid_region fre,
                                                    x_fin_lic_sec_lee lsl
                                              WHERE ft.ter_code = fc.com_ter_code
                                                AND lee_cha_com_number = fc.com_number
                                                --Dev2:Pure Finance:Start:[Hari Mandal]_[30/4/2013]
                                                --AND lic_lee_number = fle.lee_number
                                                AND fl.lic_number = lsl.lsl_lic_number
                                                AND fle.lee_number =
                                                                    lsl.lsl_lee_number
                                                --  and fl.lic_entry_date between nvl(i_from_date,fl.lic_entry_date) and nvl(i_to_date,fl.lic_entry_date)
                                                --Dev2:Pure Finance:End--------------------------
                                                AND con_number = fl.lic_con_number
                                                AND fc1.com_number =
                                                                    fct.con_com_number
                                                AND fc.com_short_name LIKE
                                                                      i_com_short_name
                                                AND fc.com_type IN ('CC', 'BC')
                                                AND fl.lic_type LIKE i_lic_type
                                                AND fle.lee_short_name LIKE
                                                                      i_lee_short_name
                                                AND fl.lic_budget_code LIKE
                                                                     i_lic_budget_code
                                                AND fc1.com_short_name LIKE
                                                                       i_supp_com_name
                                                AND con_short_name LIKE
                                                                      i_con_short_name
                                                AND (   (   (lic_acct_date >
                                                                LAST_DAY
                                                                        (i_period_date)
                                                            )
                                                         OR (lic_start >
                                                                LAST_DAY
                                                                        (i_period_date)
                                                            )
                                                        )
                                                     OR lic_acct_date IS NULL
                                                    )
                                                AND fl.lic_status NOT IN
                                                                      ('B', 'F', 'T')
                                                AND CASE
                                                       WHEN lic_status = 'C'
                                                          THEN ROUND
                                                                 (CASE
                                                                     WHEN i_evaluate_val =
                                                                                   'Y'
                                                                     AND fl.lic_type =
                                                                                 'ROY'
                                                                        THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                                               (fl.lic_number,
                                                                                l_month,
                                                                                l_year
                                                                               )
                                                                     ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                                            (fl.lic_number,
                                                                             con_number,
                                                                             fl.lic_currency,
                                                                             LAST_DAY
                                                                                (i_period_date
                                                                                ),
                                                                             lsl_lee_price,
                                                                             fl.lic_markup_percent,
                                                                             lsl.lsl_number
                                                                            )
                                                                  END,
                                                                  2
                                                                 )
                                                       ELSE -1
                                                    END < 0
                                                AND rat_cur_code = lic_currency
                                                AND rat_cur_code_2 = ter_cur_code
                                                AND ter_code = fc.com_ter_code
                                                --Dev2:Pure Finance:Start:[Hari Mandal]_[30/4/2013]
                                                --AND fle.lee_region_id = fre.reg_id
                                                AND fle.lee_split_region = fre.reg_id(+)
                                                --Dev2:Pure Finance:End-----------------------------
                                                AND fre.reg_code LIKE i_reg_code
                                           ORDER BY fl.lic_currency,
                                                    fl.lic_type,
                                                    fle.lee_short_name,
                                                    fl.lic_budget_code));
              END IF;
          END;
      END IF;
   END prc_fin_mnet_sum_exp_to_exl;

FUNCTION prc_fin_mnet_ousncom_paid_new (
      i_lic_number     IN   fid_license.lic_number%TYPE,
      i_con_number     IN   fid_contract.con_number%TYPE,
      i_lic_currency   IN   fid_license.lic_currency%TYPE,
      i_lsl_number     IN   fid_payment.pay_lsl_number%TYPE,
      i_param11        IN   DATE
   )
/********************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         21-Oct-2016       Jawahar Garg                 Added new function for finance dev phase - I.
**********************************************************************************************************************************************/

      RETURN NUMBER
   AS
      l_paid   NUMBER;
   BEGIN
				SELECT NVL (SUM (pay_amount), 0)
					INTO l_paid
					FROM fid_payment, fid_payment_type
				 WHERE pat_code = pay_code
					 AND pay_lic_number = i_lic_number
					 AND pay_con_number = i_con_number
					 AND pay_cur_code = i_lic_currency
					 AND pay_lsl_number = i_lsl_number
					 AND TO_DATE (TO_CHAR (NVL(pay_date,pay_status_date),'DD-MON-RRRR'),'DD-MON-RRRR') <= TO_DATE (TO_CHAR (i_param11, 'DD-MON-RRRR'),'DD-MON-RRRR')
					 AND pay_status IN ('P', 'I')
					 AND pat_group = 'F';
	
				RETURN NVL (ROUND (l_paid, 4), 0);
			
END prc_fin_mnet_ousncom_paid_new;

FUNCTION prc_fin_mnet_ousncom_liab_new (
      i_lic_number           IN   fid_license.lic_number%TYPE,
      i_con_number           IN   fid_contract.con_number%TYPE,
      i_lic_currency         IN   fid_license.lic_currency%TYPE,
      i_param11              IN   DATE,
      i_lic_price            IN   fid_license.lic_price%TYPE,
      i_lic_markup_percent   IN   fid_license.lic_markup_percent%TYPE,
      i_lsl_number           IN   fid_payment.pay_lsl_number%TYPE
   )
/********************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         21-Oct-2016       Jawahar Garg                 Added new function for finance dev phase - I.
**********************************************************************************************************************************************/
      RETURN NUMBER
   AS
      l_liab                 NUMBER;
      l_lic_markup_percent   fid_license.lic_markup_percent%TYPE;
   BEGIN
				IF i_lic_price = 0
				THEN
					 l_lic_markup_percent := 0;
				ELSE
					 l_lic_markup_percent := i_lic_markup_percent;
				END IF;

				l_liab :=
							(i_lic_price - total_paid_imu_detail (i_lic_number,
																										i_con_number,
																										i_lic_currency,
																										i_param11,
																										i_lic_markup_percent,
																										i_lsl_number
																									 )
							)
						* ((100 + l_lic_markup_percent) / 100);
				
			RETURN NVL (l_liab, 0);
			
END prc_fin_mnet_ousncom_liab_new;

PROCEDURE prc_fin_mnet_ousncom_details_n (
/********************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         06-May-2016       Zeshan Khan                  Included field Effective subscribers for ROY licenses, when i_evaluate_val = 'Y'.
**********************************************************************************************************************************************/
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      l_lic_type          IN       fid_license.lic_type%TYPE,
      l_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      l_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      l_com_short_name    IN       fid_company.com_short_name%TYPE,
      l_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      l_qry_string     VARCHAR2 (32000);
      l_rsa_ratedate   DATE;
      l_afr_ratedate   DATE;
      l_year           NUMBER;
      L_MONTH          NUMBER;
      v_go_live_date   DATE;
      l_last_day       DATE;
      L_YYYYMM_NUM     NUMBER (6);
   BEGIN

      l_month := TO_NUMBER (TO_CHAR (i_period_date, 'MM'));
      l_year := TO_NUMBER (TO_CHAR (i_period_date, 'RRRR'));
      l_yyyymm_num := l_year || TO_CHAR (i_period_date, 'MM');


      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      SELECT LAST_DAY (i_period_date)
        INTO l_last_day
        FROM DUAL;

      IF i_evaluate_val = 'Y'
      THEN
      DBMS_OUTPUT.DISABLE;
         x_pkg_fin_out_comm_roy_calc.prc_fin_calc_roy_comm
                                                          (i_reg_code,
                                                           i_channel_comp,
                                                           l_lee_short_name,
                                                           l_lic_budget_code,
                                                           l_com_short_name,
                                                           l_con_short_name,
                                                           i_from_date,
                                                           i_to_date,
                                                           i_period_date
                                                          );
      END IF;
    DBMS_OUTPUT.ENABLE;
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
--open o_cursor for
      l_qry_string :=
            'SELECT
                   MEM_AGY_COM_NUMBER
              ,    fg.gen_title
              ,    ft.ter_cur_code
              ,    fc.com_number
              ,    fc.com_name Channel_Company
              ,    fc.com_short_name comp_short_name
              ,    fl.lic_currency
              ,    fl.lic_type
              ,    lee_short_name
              ,    fl.lic_budget_code
              ,    b.com_short_name SUPPLIER
              ,    fct.con_short_name
              ,    fc.com_ter_code
              ,    con_number
              ,    fl.lic_number
              ,    lic_gen_refno
              ,    lic_amort_code
              ,    round(lsl.lsl_lee_price,2) lic_price
              ,    fc.com_short_name
              ,    lic_markup_percent
              ,    TO_CHAR(lic_acct_date,' || '''YYYY.MM''' || ') LIC_ACCT_DATE
              ,    TO_CHAR(lic_start,' || '''DDMonYYYY''' || ') LIC_START
              ,    TO_CHAR(lic_end, ' || '''DDMonYYYY' || ''') LIC_END
              ,  ''' || l_afr_ratedate || ''' afr_ratedate
              ,  CASE WHEN LIC_START < ''' || v_go_live_date || '''  OR to_date(''' || i_period_date || ''') < to_date(''' || v_go_live_date || ''')
                 THEN ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXRATE(fl.lic_currency,fc.com_ter_code ),4)
                 ELSE ROUND(DECODE(''' || i_rate_type || '''
              ,  ''M''
              ,  x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse(fl.lic_currency, ft.ter_cur_code, ''' || l_afr_ratedate || ''' )
              ,  ''R''
              ,  x_pkg_fin_get_spot_rate.get_spot_rate_with_rater(fl.lic_currency, ft.ter_cur_code, ''' || l_last_day|| ''')),5) END AFR_EX_RATE  -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
              , ''' || l_rsa_ratedate || ''' rsa_ratedate
              , CASE WHEN LIC_START < ''' || v_go_live_date || '''  OR to_date(''' || i_period_date || ''') < to_date(''' || v_go_live_date || ''')
              THEN ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXRATE(fl.lic_currency,fc.com_ter_code ),4)
              ELSE ROUND(DECODE('''
                       || i_rate_type
                       || ''',
              ''M'', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
              (fl.lic_currency,
              ft.ter_cur_code,
              '''
                       || l_rsa_ratedate
                       || '''
              ),
              ''R'', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
              (fl.lic_currency,
              ft.ter_cur_code,
              '''
                       || l_last_day
                       || '''
              )
              ),4) END RSA_EX_RATE
              
              ,CASE WHEN '''
                       || i_evaluate_val
                       || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                       || l_month
                       || ','
                       || l_year
                       || ')
              ELSE PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                       || i_period_date
                       || '''), lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number)END
              +
              PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                       || i_period_date
                       || ''')    ) fee
              ,    ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                       || i_period_date
                       || ''')    ),2)  paid
              ,  CASE WHEN '''
                       || i_evaluate_val
                       || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                       || l_month
                       || ','
                       || l_year
                       || ')
              ELSE ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                       || i_period_date
                       || ''')    , lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number),2)END liab
              ,  CASE WHEN '''
                       || i_evaluate_val
                       || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                       || l_month
                       || ','
                       || l_year
                       || ')
              ELSE ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                       || i_period_date
                       || ''')    , lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number),2)END
              *
              CASE WHEN LIC_START < '''
                       || v_go_live_date
                       || ''' OR to_date('''
                       || i_period_date
                       || ''') < to_date('''
                       || v_go_live_date
                       || ''')
              THEN ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_EXRATE(fl.lic_currency,fc.com_ter_code ),4)
              ELSE ROUND(DECODE('''
                       || i_rate_type
                       || ''',
              ''M'', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
              (fl.lic_currency,
              ft.ter_cur_code,
              decode(fre.reg_code,''RSA'',''' || l_rsa_ratedate || ''',''' || l_afr_ratedate || ''' )),
              ''R'', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater(fl.lic_currency, ft.ter_cur_code, '''|| l_last_day || ''' )),4) END
              sar_LIAB ,
              fre.reg_code,
              FL.LIC_STATUS  --[finace dev 1] [Ankur Kasar]
              ';
              
              --[Ver 0.1] [START]
                IF I_EVALUATE_VAL = 'Y'
                THEN
                l_qry_string := l_qry_string || '
                 ,CASE WHEN lic_type =''ROY''
                 THEN
                 round( (nvl(round(
                 (
                 CASE WHEN ''' || i_evaluate_val || ''' = ''Y'' AND fl.lic_type = ''ROY'' 
                 THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,' || l_month || ',' || l_year || ')
                 ELSE PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                                 || i_period_date
                                 || '''), lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number)END
                        +
                        PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                                 || i_period_date
                                 || ''')    )
                 ),2),0))/(decode(lic_price,0,1,round(lic_price,2))) )
                 ELSE
                 NULL
                 END Effective_Subs 
                 ';
                END IF;
              --[Ver 0.1] [END]
              
              
L_QRY_STRING := L_QRY_STRING || '
FROM    fid_company fc
,    fid_company b
,    fid_contract fct
,    fid_licensee fle
,    fid_license fl
,    fid_territory ft
,    fid_general fg
,       SAK_MEMO
,       fid_region fre
,x_fin_lic_sec_lee lsl
WHERE    lee_cha_com_number = fc.com_number
AND    gen_refno = lic_gen_refno
AND    ter_code = fc.com_ter_code
AND    fc.com_type IN ('
         || '''CC'''
         || ','
         || '''BC'''
         || ')
----Dev2:Pure Finance:Start:[Hari Mandal]_[29/04/2013]
-- AND    fl.lic_lee_number = fle.lee_number
AND    fle.lee_number = lsl.lsl_lee_number
AND    fl.lic_number  = lsl.lsl_lic_number
AND    fl.lic_entry_date between decode('''
         || i_from_date
         || ''',null,fl.lic_entry_date,'''
         || i_from_date
         || ''') and decode('''
         || i_to_date
         || ''',null,fl.lic_entry_date,'''
         || i_to_date
         || ''')
----Dev2:Pure Finance:End-------------------------------
AND    con_number = lic_con_number
AND     mem_id = lic_mem_number
AND    b.com_number = con_com_number
AND   case when lic_status=''C'' then
CASE WHEN '''
         || i_evaluate_val
         || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
         || l_month
         || ','
         || l_year
         || ')
ELSE ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB(fl.lic_number , con_number , fl.lic_currency , last_day('''
         || i_period_date
         || ''')    , lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number),2)END
else -1
end < 0
AND    fl.lic_type LIKE     '''
         || l_lic_type
         || '''
AND    fle.lee_short_name LIKE '''
         || l_lee_short_name
         || '''
AND    fl.lic_budget_code LIKE '''
         || l_lic_budget_code
         || '''
AND    b.com_short_name LIKE '''
         || l_com_short_name
         || '''
AND    fc.com_short_name LIKE '''
         || i_channel_comp
         || '''
--
AND    fct.con_short_name LIKE '''
         || l_con_short_name
         || '''
AND    ( (( lic_acct_date > last_day('''
         || i_period_date
         || ''')) OR ( lic_start > last_day('''
         || i_period_date
         || ''')))
OR lic_acct_date IS NULL
OR nvl(lic_before_acct_date,''N'') = ''Y'' )

AND (NOT EXISTS ( SELECT  lis_lic_number,NVL(SUM(LIS_CON_FC_EMU),0)
FROM    X_MV_OUT_COMM_EX
WHERE   lis_lic_number = fl.lic_number
and     LIS_YYYYMM_NUM <='
         || l_yyyymm_num
         || '
GROUP BY lis_lic_number
HAVING NVL(SUM(LIS_CON_FC_EMU),0) != 0
))
-- AND fle.lee_region_id = fre.reg_id
AND fle.lee_split_region = fre.reg_id(+)
AND fre.reg_code like '''
         || i_reg_code
         || '''
AND    lic_status NOT IN (''B'',''F'',''T'')
          AND ( 
                    (   
                        lic_acct_date > LAST_DAY(''' || i_period_date || ''')
                        OR  lic_acct_date IS NULL
                    )
                    OR
                    ( 
                        lic_acct_date < LAST_DAY(''' || i_period_date || ''')
                        AND NOT EXISTS 
                        ( 
                          SELECT 1 
                          FROM FID_LICENSE_SUB_LEDGER flsl 
                          WHERE fl.lic_number = flsl.lis_lic_number
                          AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = ''' || i_period_date || '''
                          AND flsl.lis_lic_status = ''A''
                          AND flsl.lis_lic_start <= ''' || i_period_date || '''
                        )
                    ) 
                  )';

              
/*              
              L_QRY_STRING := L_QRY_STRING || '
              FROM    fid_company fc
              ,    fid_company b
              ,    fid_contract fct
              ,    fid_licensee fle
              ,    fid_license fl
              ,    fid_territory ft
              ,    fid_general fg
              ,    SAK_MEMO
              ,    fid_region fre
              ,    x_fin_lic_sec_lee lsl
              WHERE    lee_cha_com_number = fc.com_number
              AND    gen_refno = lic_gen_refno
              AND    ter_code = fc.com_ter_code
              AND    fc.com_type IN (''CC'',''BC'')
              AND    fle.lee_number = lsl.lsl_lee_number
              AND    fl.lic_number  = lsl.lsl_lic_number
              AND    con_number = lic_con_number
              AND     mem_id = lic_mem_number
              AND    b.com_number = con_com_number
              AND    fl.lic_type LIKE     '''|| l_lic_type|| '''
              AND    fle.lee_short_name LIKE '''|| l_lee_short_name|| '''
              AND    fl.lic_budget_code LIKE ''' || l_lic_budget_code || '''
              AND    b.com_short_name LIKE ''' || l_com_short_name || '''
              AND    fc.com_short_name LIKE ''' || i_channel_comp || '''
              AND    fct.con_short_name LIKE ''' || l_con_short_name || '''
              AND (NOT EXISTS ( SELECT  lis_lic_number,NVL(SUM(LIS_CON_FC_EMU),0)
              AND    fl.lic_entry_date between decode('''
                       || i_from_date
                       || ''',null,fl.lic_entry_date,'''
                       || i_from_date
                       || ''') and decode('''
                       || i_to_date
                       || ''',null,fl.lic_entry_date,'''
                       || i_to_date
                       || ''')
              FROM    X_MV_OUT_COMM_EX
              WHERE   lis_lic_number = fl.lic_number
              and     LIS_YYYYMM_NUM <= '|| l_yyyymm_num || '
              GROUP BY lis_lic_number
              HAVING NVL(SUM(LIS_CON_FC_EMU),0) != 0
              ))
              AND fle.lee_split_region = fre.reg_id(+)
              AND fre.reg_code like ''' || i_reg_code || '''
              AND lic_status NOT IN (''B'',''F'',''T'')
              AND ( 
                    (   
                        lic_acct_date > LAST_DAY(''' || i_period_date || ''')
                        OR  lic_acct_date IS NULL
                    )
                    OR
                    ( 
                        lic_acct_date < LAST_DAY(''' || i_period_date || ''')
                        AND NOT EXISTS 
                        ( 
                          SELECT 1 
                          FROM FID_LICENSE_SUB_LEDGER flsl 
                          WHERE fl.lic_number = flsl.lis_lic_number
                          AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = ''' || i_period_date || '''
                          AND flsl.lis_lic_status = ''A''
                          AND flsl.lis_lic_start <= ''' || i_period_date || '''
                        )
                    ) 
                  )';
*/
              IF i_include_zeros = 'N'
              THEN
                 l_qry_string :=
                       l_qry_string
                    || 'AND ( ( (  ROUND(case when '''
                    || i_evaluate_val
                    || ''' = ''Y'' AND fl.lic_type = ''ROY'' THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum(fl.lic_number,'
                    || l_month
                    || ','
                    || l_year
                    || ')
              else PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_LIAB_NEW(fl.lic_number , con_number , fl.lic_currency , last_day('''
                          || i_period_date
                          || '''), lsl.lsl_lee_price , fl.lic_markup_percent,lsl.lsl_number)
              +
              PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                          || i_period_date
                          || ''')    )
              end,2) <> 0) OR ROUND(PKG_FIN_MNET_OUTSTAND_COMENT.PRC_FIN_MNET_OUSNCOM_PAID_NEW(fl.lic_number , con_number , fl.lic_currency ,lsl.lsl_number, last_day('''
                          || i_period_date
                          || ''')    ),2) <> 0) OR (lsl_lee_price <> 0) ) ';
      END IF;

      l_qry_string :=
            l_qry_string
         || ' ORDER BY    fc.com_name ,    lic_currency,    lic_type,    lee_short_name,    lic_budget_code,    b.com_short_name,    con_short_name,    lic_number';
      DBMS_OUTPUT.put_line (l_qry_string);

      OPEN o_cursor FOR l_qry_string;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20786, SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,1,200));
   END prc_fin_mnet_ousncom_details_n;

PROCEDURE prc_fin_mnet_det_exp_to_exl_n (
/********************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         06-May-2016       Zeshan Khan                  Included field Effective subscribers for ROY licenses, when i_evaluate_val = 'Y'.
**********************************************************************************************************************************************/
      i_channel_comp      IN       fid_company.com_short_name%TYPE,
      l_lic_type          IN       fid_license.lic_type%TYPE,
      l_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      l_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      l_com_short_name    IN       fid_company.com_short_name%TYPE, --SUPPLIER
      l_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      L_QUERY_STRING   VARCHAR2 (25000); --[Ver 0.1 Increased var size]

      l_month          NUMBER;
      l_year           NUMBER;
      l_last_day       DATE;
      v_go_live_date   DATE;
      l_rsa_ratedate   DATE;
      L_AFR_RATEDATE   DATE;

   BEGIN
      ---Dev2:Pure Finance:Start:[Hari_Mandal]_[30/4/2013]
      l_month := TO_NUMBER (TO_CHAR (i_period_date, 'mm'));
      L_YEAR := TO_NUMBER (TO_CHAR (I_PERIOD_DATE, 'yyyy'));

      SELECT LAST_DAY (i_to_date)
        INTO l_last_day
        FROM DUAL;

      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM X_FIN_CONFIGS
       WHERE KEY = 'GO-LIVEDATE';

      ------Calculate Rate Date ----------
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

      /*********************Stopped insering select query result to excel sheet and filler directly into cursor****************************/
      --DELETE FROM exl_outstanding_commitment;
      COMMIT;

      --FIN CR Rewrite the code as per new requirnment and added dynamic query instead of static SQL.
      L_QUERY_STRING := 'SELECT channel_company,
                                lic_currency
                                ,PERIOD_DATE
                                , ter_cur_code,
                                lic_type, lee_short_name, lic_budget_code, supplier,
                                con_short_name, lic_number, gen_title, acct_date,
                                lic_start, lic_end, ROUND (fee, 2) fee, ';
      --[Ver 0.1] [START]  fl.lic_type = ''ROY''
      IF I_EVALUATE_VAL = 'Y'
      THEN
        L_QUERY_STRING := L_QUERY_STRING || '
         CASE WHEN lic_type =''ROY''
         THEN
         round( (nvl(round(fee,2),0))/(decode(lic_price,0,1,round(lic_price,2))) )
         ELSE
         NULL
         END Effective_Subs,';
      END IF;
      --[Ver 0.1] [END]
      L_QUERY_STRING := L_QUERY_STRING ||
                                '
                                ROUND (lic_price, 2) lic_price, ROUND (paid, 2) paid,
                                ROUND (liab, 2) liab,
                                ROUND (exchange_rate, 5) exchange_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                                ROUND (loc_liab, 2) loc_liab, lic_amort_code, reg_code,lic_status 
                    FROM (
                           SELECT   fc.com_name channel_company, fl.lic_currency,
                            TO_CHAR (TO_DATE('''||i_period_date||'''), ''YYYY/MM/DD'') PERIOD_DATE,
                             ft.ter_cur_code, fl.lic_type, lee_short_name,
                             fl.lic_budget_code, b.com_short_name supplier,
                             fct.con_short_name, fl.lic_number, fg.gen_title,
                             TO_CHAR (lic_acct_date, ''YYYY.MM'') acct_date,
                             TO_CHAR (LIC_START, ''DD-MON-RRRR'') LIC_START,
                             TO_CHAR (lic_end, ''DD-MON-RRRR'') lic_end,
                             ROUND
                                (  CASE
                                      WHEN '''||i_evaluate_val||''' = ''Y''
                                      AND fl.lic_type = ''ROY''
                                      THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                               (fl.lic_number,'
                                                               ||l_month||
                                                               ','
                                                                ||l_year||
                                                               ')
                                      ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                     (fl.lic_number,
                                                      con_number,
                                                      fl.lic_currency,
                                                      LAST_DAY ('''
                                                      ||i_period_date||
                                                      '''),
                                                      lsl.lsl_lee_price,
                                                      fl.lic_markup_percent,
                                                      lsl.lsl_number
                                                     )
                                    END
                             + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid
                                                      (fl.lic_number,
                                                       con_number,
                                                       fl.lic_currency,
                                                       lsl.lsl_number,
                                                       LAST_DAY ('''
                                                       ||i_period_date||
                                                       ''')
                                                      ),
                                 2
                                ) fee,';

         L_QUERY_STRING := L_QUERY_STRING ||'
                             lsl_lee_price lic_price,
                             ROUND
                                (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid
                                                      (fl.lic_number,
                                                       con_number,
                                                       fl.lic_currency,
                                                       lsl.lsl_number,
                                                       LAST_DAY ('''
                                                       ||i_period_date||
                                                       ''')
                                                      ),
                                 2
                                ) paid,
                             ROUND
                                (CASE
                                    WHEN '''
                                          ||i_evaluate_val||
                                          '''	= ''Y''
                                          AND fl.lic_type = ''ROY''
                                    THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                               (fl.lic_number,'
                                                                ||L_MONTH||','
                                                                ||l_year||'
                                                               )
                                    ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                     (fl.lic_number,
                                                      con_number,
                                                      fl.lic_currency,
                                                      LAST_DAY ('''
                                                     ||i_period_date||
                                                     '''),
                                                      lsl_lee_price,
                                                      fl.lic_markup_percent,
                                                      lsl.lsl_number
                                                     )
                                 END,
                                 2
                                ) liab,
                             CASE
                                WHEN lic_start < '''
                                                  ||v_go_live_date||
                                                  '''OR TO_DATE ('''
                                                  ||i_period_date||
                                                  ''') < '''
                                                  ||v_go_live_date||
                                                  '''THEN ROUND
                                                        (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exrate
                                                                           (fl.lic_currency,
                                                                            fc.com_ter_code
                                                                           ),
                                                         4
                                                        )
                                ELSE DECODE
                                       ('''
                                         ||i_rate_type||
                                         ''',
                                        ''M'', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                        (fl.lic_currency,
                                         ft.ter_cur_code,
                                         DECODE (fre.reg_code,
                                                 ''RSA'', '''
                                                 ||l_rsa_ratedate||
                                                 ''','''
                                                 ||l_afr_ratedate||
                                                ''')
                                        ),
                                        ''R'', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                             (fl.lic_currency,
                                                              ft.ter_cur_code,'''
                                                              ||l_last_day||
                                                             ''')
                                       )
                             END exchange_rate,
                             ROUND
                                (  CASE
                                      WHEN '''
                                      ||i_evaluate_val||
                                      '''= ''Y''
                                      AND fl.lic_type = ''ROY''
                                         THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                               (fl.lic_number,'
                                                                ||l_month||
                                                                ','
                                                                ||l_year||
                                                                ')
                                      ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                     (fl.lic_number,
                                                      con_number,
                                                      fl.lic_currency,
                                                      LAST_DAY ('''
                                                     ||i_period_date||
                                                     '''),
                                                      lsl_lee_price,
                                                      fl.lic_markup_percent,
                                                      lsl.lsl_number
                                                     )
                                   END
                                 * CASE
                                      WHEN lic_start < '''||
                                      v_go_live_date||'''
                                       OR TO_DATE ('''
                                                     ||i_period_date||
                                                     ''') < '''
                                                     ||v_go_live_date||
                                         '''THEN ROUND
                                                (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exrate
                                                             (fl.lic_currency,
                                                              fc.com_ter_code
                                                             ),
                                                 4
                                                )
                                      ELSE ROUND
                                             (DECODE
                                                 ('''
                                                   ||i_rate_type||''',
                                                  ''M'', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                      (fl.lic_currency,
                                                       ft.ter_cur_code,
                                                       DECODE (fre.reg_code,
                                                               ''RSA'', '''
                                                               ||l_rsa_ratedate||
                                                               ''','''
                                                               ||l_afr_ratedate||
                                                              ''')
                                                      ),
                                                  ''R'', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                             (fl.lic_currency,
                                                              ft.ter_cur_code,'''
                                                              ||l_last_day||
                                                             ''')
                                                 ),
                                              4
                                             )
                                   END,
                                 2
                                ) loc_liab,
                             fl.lic_amort_code, 
                             fre.reg_code,
                             fl.lic_status
                        FROM fid_company fc,
                             fid_company b,
                             fid_contract fct,
                             fid_licensee fle,
                             fid_license fl,
                             fid_territory ft,
                             fid_general fg,
                             sak_memo,
                             fid_region fre,
                             x_fin_lic_sec_lee lsl
                       WHERE lee_cha_com_number = fc.com_number
                         AND gen_refno = lic_gen_refno
                         AND ter_code = fc.com_ter_code
                         AND fc.com_type IN (''CC'', ''BC'')
                         AND fl.lic_number = lsl.lsl_lic_number
                         AND fle.lee_number = lsl.lsl_lee_number
                         AND fle.lee_split_region = fre.reg_id(+)
                         AND con_number = lic_con_number
                         AND mem_id = lic_mem_number
                         AND b.com_number = con_com_number
                         AND fl.lic_type LIKE '''||l_lic_type||'''
                         AND fle.lee_short_name LIKE '''||l_lee_short_name||'''
                         AND fl.lic_budget_code LIKE '''||l_lic_budget_code||'''
                         AND b.com_short_name LIKE '''||l_com_short_name||'''
                         AND fc.com_short_name LIKE '''||i_channel_comp||'''
                         AND fct.con_short_name LIKE '''||l_con_short_name||'''
                         AND fre.reg_code LIKE '''||i_reg_code||'''
                         AND lic_status NOT IN (''B'', ''F'', ''T'')
                         AND    fl.lic_entry_date between decode('''
                                  || i_from_date
                                  || ''',null,fl.lic_entry_date,'''
                                  || i_from_date
                                  || ''') and decode('''
                                  || i_to_date
                                  || ''',null,fl.lic_entry_date,'''
                                  || i_to_date
                                  || ''')
                         AND ( 
                               (   
                                   lic_acct_date > LAST_DAY(''' || i_period_date || ''')
                                   OR  lic_acct_date IS NULL
                               )
                               OR
                               ( 
                                   lic_acct_date < LAST_DAY(''' || i_period_date || ''')
                                   AND NOT EXISTS 
                                   ( 
                                     SELECT 1 
                                     FROM FID_LICENSE_SUB_LEDGER flsl 
                                     WHERE fl.lic_number = flsl.lis_lic_number
                                     AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = ''' || i_period_date || '''
                                     AND flsl.lis_lic_status = ''A''
                                     AND flsl.lis_lic_start <= ''' || i_period_date || '''
                                   )
                               ) 
                             )
                         ';

            IF i_include_zeros = 'N'
						THEN
						L_QUERY_STRING := L_QUERY_STRING || 'AND (   (   ROUND
                                        (  CASE
                                              WHEN
                                              '''
                                              || i_evaluate_val
                                              ||''' = ''Y''
                                              AND fl.lic_type = ''ROY''
                                                 THEN PKG_FIN_MNET_OUTSTAND_COMENT.x_fin_con_forcast_sum
                                                               (fl.lic_number,'
                                                                ||l_month
                                                                ||','
                                                                ||l_year||'
                                                               )
                                              ELSE PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab
                                                     (fl.lic_number,
                                                      con_number,
                                                      fl.lic_currency,
                                                      LAST_DAY ('''
                                                      ||i_period_date||'''),
                                                      lsl_lee_price,
                                                      fl.lic_markup_percent,
                                                      lsl.lsl_number
                                                     )
                                           END
                                         + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid
                                                      (fl.lic_number,
                                                       con_number,
                                                       fl.lic_currency,
                                                       lsl.lsl_number,
                                                       LAST_DAY ('''
                                                       ||i_period_date||
                                                       ''')
                                                      ),
                                         2
                                        ) <> 0
                                  OR ROUND
                                        (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid
                                                      (fl.lic_number,
                                                       con_number,
                                                       fl.lic_currency,
                                                       lsl.lsl_number,
                                                       LAST_DAY ('''
                                                       ||i_period_date||
                                                       ''')
                                                      ),
                                         2
                                        ) <> 0
                                 )
                              OR (lsl_lee_price <> 0)
                             )';
							 END IF;

						L_QUERY_STRING := L_QUERY_STRING || '
                        ORDER BY fc.com_name,
				 fl.lic_currency,
				 fl.lic_type,
				 fle.lee_short_name,
				 fl.lic_budget_code,
				 b.com_short_name,
				 fct.con_short_name,
				 fl.lic_number)';

        OPEN O_CURSOR FOR L_QUERY_STRING;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
   END prc_fin_mnet_det_exp_to_exl_n;

PROCEDURE prc_fin_mnet_ousncom_summary_n (
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_com_short_name    IN       fid_company.com_short_name%TYPE,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      l_qry_text       VARCHAR2 (3500);
      l_where_clause   VARCHAR2 (500);
      l_month          NUMBER;
      l_year           NUMBER;
      l_rsa_ratedate   DATE;
      l_afr_ratedate   DATE;
      l_last_day       DATE;
      v_go_live_date   DATE;
   BEGIN
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      l_month := TO_NUMBER (TO_CHAR (i_period_date, 'mm'));
      l_year := TO_NUMBER (TO_CHAR (i_period_date, 'yyyy'));

      SELECT LAST_DAY (i_to_date)
        INTO l_last_day
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

         OPEN o_cursor FOR
            SELECT   com_name, com_number com_number1, lic_type,
                     lee_short_name, lic_budget_code,

                     --SUM (lic_price) lic_price,
                     SUM (lsl_lee_price) lic_price, lic_currency,
                     ter_cur_code, ex_rate,
                     ROUND
                        (SUM
                            (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                      (lic_number,
                                                       lic_currency,
                                                       lsl_number,
                                                       LAST_DAY (i_period_date)
                                                      )
                            ),
                         2
                        ) paid_sum,
                     ROUND
                        (SUM
                            (  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                     (lic_number,
                                                      lic_currency,
                                                      LAST_DAY (i_period_date),
                                                      lsl_lee_price,
                                                      lic_markup_percent,
                                                      lic_type,
                                                      lsl_number,
                                                      i_evaluate_val
                                                     )
                             + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                      (lic_number,
                                                       lic_currency,
                                                       lsl_number,
                                                       LAST_DAY (i_period_date)
                                                      )
                            ),
                         2
                        ) fee,
                     ROUND
                        (SUM
                            (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                     (lic_number,
                                                      lic_currency,
                                                      LAST_DAY (i_period_date),
                                                      lsl_lee_price,
                                                      lic_markup_percent,
                                                      lic_type,
                                                      lsl_number,
                                                      i_evaluate_val
                                                     )
                            ),
                         2
                        ) liab,
                     ROUND
                        (SUM
                            ((  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                     (lic_number,
                                                      lic_currency,
                                                      LAST_DAY (i_period_date),
                                                      lsl_lee_price,
                                                      lic_markup_percent,
                                                      lic_type,
                                                      lsl_number,
                                                      i_evaluate_val
                                                     )
                              * ex_rate
                             )
                            ),
                         2
                        ) loc_liab,
                     ROUND
                        (SUM
                            (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exh_sum
                                                                (lic_number,
                                                                 i_period_date
                                                                )
                            ),
                         4
                        ) exh ,
                        LIC_STATUS --[ANKUR KASAR]
                --reg_code                                     --For Split
            FROM     (SELECT DISTINCT fc.com_name, fc.com_ter_code,
                                      fc.com_number com_number1, fl.lic_type,
                                      ROUND (fl.lic_price, 2) lic_price,
                                      lsl_lee_price,
                                      lsl.lsl_number lsl_number,
                                      fc1.com_short_name supplier,
                                      fle.lee_short_name, fl.lic_budget_code
                                                                            --, fl.lic_con_number
                                                                            --, fct.con_short_name
                                      ,
                                      fl.lic_currency
                                                     --, con_number
                                      , fl.lic_number, fl.lic_markup_percent,
                                      TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                                      TO_CHAR (fl.lic_end, 'MM.YYYY'),
                                      fc1.com_number com_number,
                                      ft.ter_cur_code,
                                      CASE
                                         WHEN lic_start <
                                                       v_go_live_date
                                          OR TO_DATE (i_period_date) <
                                                                v_go_live_date
                                            THEN ROUND (NVL (rat_rate, 0), 4)
                                         ELSE DECODE
                                                (i_rate_type,
                                                 'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                      (fl.lic_currency,
                                                       ft.ter_cur_code,
                                                       DECODE (fre.reg_code,
                                                               'RSA', l_rsa_ratedate,
                                                               l_afr_ratedate
                                                              )
                                                      ),
                                                 'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                             (fl.lic_currency,
                                                              ft.ter_cur_code,
                                                              l_last_day
                                                             )
                                                )
                                      END ex_rate,
                                      fl.LIC_STATUS --[ANKUR KASAR]
                                 --fre.reg_code                 --For Split
                      FROM            fid_territory ft,
                                      fid_company fc,
                                      fid_company fc1,
                                      fid_contract fct,
                                      fid_licensee fle,
                                      fid_license fl,
                                      fid_exchange_rate,
                                      fid_region fre,              --For Split
                                      x_fin_lic_sec_lee lsl
                                WHERE ft.ter_code = fc.com_ter_code
                                  AND lee_cha_com_number = fc.com_number
                                  --Dev2:Pure Finance:Start:[Hari_Mandal]_[30/4/2013]
                                --AND lic_lee_number = fle.lee_number
                                  AND lic_number = lsl.lsl_lic_number
                                  AND lee_number = lsl.lsl_lee_number
                             --   and fl.lic_entry_date between nvl(i_from_date,fl.lic_entry_date) and nvl(i_to_date,fl.lic_entry_date)
                                  --Dev2:Pure Finance:End---------------------------
                                  AND con_number = fl.lic_con_number
                                  AND fc1.com_number = fct.con_com_number
                                  AND fc.com_short_name LIKE i_com_short_name
                                  AND fc.com_type IN ('CC', 'BC')
                                  AND fl.lic_type LIKE i_lic_type
                                  AND fle.lee_short_name LIKE i_lee_short_name
                                  AND fl.lic_budget_code LIKE
                                                             i_lic_budget_code
                                  AND fc1.com_short_name LIKE i_supp_com_name
                                  AND con_short_name LIKE i_con_short_name
                                  AND fl.lic_status NOT IN ('B', 'F')
                                  AND ( 
                                        (   
                                            lic_acct_date > LAST_DAY(i_period_date)
                                            OR  lic_acct_date IS NULL
                                        )
                                        OR
                                        ( 
                                            lic_acct_date < LAST_DAY(i_period_date)
                                            AND NOT EXISTS 
                                            ( 
                                              SELECT 1 
                                              FROM FID_LICENSE_SUB_LEDGER flsl 
                                              WHERE fl.lic_number = flsl.lis_lic_number
                                              AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = l_year||lpad(l_month,2,0)
                                              AND flsl.lis_lic_status = 'A'
                                              AND flsl.lis_lic_start <= i_period_date
                                            )
                                        ) 
                                      )
                                  AND rat_cur_code = lic_currency
                                  AND rat_cur_code_2 = ter_cur_code
                                  AND ter_code = fc.com_ter_code
                                --AND fle.lee_region_id = fre.reg_id
                                  AND fle.lee_split_region = fre.reg_id(+)
                                  --For Split
                                  AND fre.reg_code LIKE i_reg_code --For Split
                             ORDER BY fl.lic_currency,
                                      fl.lic_type,
                                      fle.lee_short_name,
                                      fl.lic_budget_code)
            GROUP BY com_name,
                     com_number,
                     lic_type,
                     lee_short_name,
                     lic_budget_code,
                     lic_currency,
                     ex_rate,
                     ter_cur_code,
                     LIC_STATUS --[ANKUR KASAR]
                     ;                                         --,
      --reg_code;
   END prc_fin_mnet_ousncom_summary_n;

PROCEDURE prc_fin_mnet_sum_exp_to_exl_n (
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_com_short_name    IN       fid_company.com_short_name%TYPE,
      i_supp_com_name     IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      i_include_zeros     IN       VARCHAR2,
      i_reg_code          IN       fid_region.reg_code%TYPE,       --For Split
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_rate_type         IN       VARCHAR2,
      i_evaluate_val      IN       VARCHAR2,
      o_cursor            OUT      PKG_FIN_MNET_OUTSTAND_COMENT.c_cursor_fin_ost_commemnt
   )
   AS
      l_qry_text       VARCHAR2 (3500);
      l_month          NUMBER;
      l_year           NUMBER;
      l_afr_ratedate   DATE;
      l_rsa_ratedate   DATE;
      l_last_day       DATE;
      v_go_live_date   DATE;
   BEGIN
      ---Dev2:Pure Finance:Start:[Hari_Mandal]_[30/4/2013]
      l_month := TO_NUMBER (TO_CHAR (i_period_date, 'mm'));
      l_year := TO_NUMBER (TO_CHAR (i_period_date, 'yyyy'));

      SELECT LAST_DAY (i_to_date)
        INTO l_last_day
        FROM DUAL;

      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      ------Calculate Rate Date ----------
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
        OPEN o_cursor FOR
            SELECT channel_company com_name, lic_currency,

                   -- TO_CHAR (i_period_date, 'YYYY/MM/DD HH:MI:SS') period,
                   TO_CHAR (i_period_date, 'YYYY/MM/DD') period,
                   ter_cur_code, lic_type, lee_short_name, lic_budget_code,
                   ROUND (exh, 2) exh, ROUND (fee, 2) fee,
                   ROUND (paid, 2) paid, ROUND (liab, 2) liab,
                   ROUND (exchange_rate, 5) exchange_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                   ROUND (loc_liab, 2) loc_liab,lic_status
              FROM (SELECT com_name channel_company, lic_currency
                                                                 ---,    to_char(i_period_date,'Mon-yyyy') Period
                           ,
                           ter_cur_code, lic_type, lee_short_name,
                           lic_budget_code, supplier, con_short_name,
                           lic_number
                                     ----, fg.gen_title
                           , lic_acct_date, lic_start, lic_end,
                           ROUND
                              (  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                     (lic_number,
                                                      lic_currency,
                                                      LAST_DAY (i_period_date),
                                                      lsl_lee_price,
                                                      lic_markup_percent,
                                                      lic_type,
                                                      lsl_number,
                                                      i_evaluate_val
                                                     )
                               + PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                      (lic_number,
                                                       lic_currency,
                                                       lsl_number,
                                                       LAST_DAY (i_period_date)
                                                      ),
                               2
                              ) fee,

                           --ROUND (lic_price, 2) lic_price,
                           ROUND (lsl_lee_price, 2) lic_price,
                           ROUND
                              (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_paid_sum
                                                      (lic_number,
                                                       lic_currency,
                                                       lsl_number,
                                                       LAST_DAY (i_period_date)
                                                      ),
                               2
                              ) paid,
                           ROUND
                              (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                     (lic_number,
                                                      lic_currency,
                                                      LAST_DAY (i_period_date),
                                                      lsl_lee_price,
                                                      lic_markup_percent,
                                                      lic_type,
                                                      lsl_number,
                                                      i_evaluate_val
                                                     ),
                               2
                              ) liab,
                           ex_rate exchange_rate,
                           ROUND
                              ((  PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_liab_sum
                                                     (lic_number,
                                                      lic_currency,
                                                      LAST_DAY (i_period_date),
                                                      lsl_lee_price,
                                                      lic_markup_percent,
                                                      lic_type,
                                                      lsl_number,
                                                      i_evaluate_val
                                                     )
                                * ex_rate
                               ),
                               2
                              ) loc_liab,
                           lic_amort_code, com_number,
                           ROUND
                              (PKG_FIN_MNET_OUTSTAND_COMENT.prc_fin_mnet_ousncom_exh_sum
                                                                (lic_number,
                                                                 i_period_date
                                                                ),
                               2
                              ) exh,
                           reg_code,lic_status
                      FROM (SELECT DISTINCT fc.com_name, fc.com_ter_code,
                                            fc.com_number com_number1,
                                            fl.lic_type,
                                            ROUND (fl.lic_price, 2) lic_price,
                                            lsl_lee_price,
                                            lsl.lsl_number lsl_number,
                                            fc1.com_short_name supplier,
                                            fle.lee_short_name,
                                            fl.lic_budget_code
                                                              --, fl.lic_con_number
                                            ,
                                            fct.con_short_name,
                                            fl.lic_currency
                                                           --, con_number
                                            , fl.lic_number,
                                            fl.lic_markup_percent,
                                            TO_CHAR (fl.lic_start,
                                                     'DDMonYYYY'
                                                    ) lic_start,
                                            TO_CHAR (fl.lic_end,
                                                     'DDMonYYYY'
                                                    ) lic_end,
                                            TO_CHAR (fl.lic_end, 'MM.YYYY'),
                                            TO_CHAR
                                                (lic_acct_date,
                                                 'YYYY.MM'
                                                ) lic_acct_date,
                                            fc1.com_number com_number,
                                            ft.ter_cur_code,
                                            CASE
                                               WHEN lic_start <
                                                       v_go_live_date
                                                OR TO_DATE (i_period_date) <
                                                                v_go_live_date
                                                  THEN ROUND (NVL (rat_rate,
                                                                   0),
                                                              4
                                                             )
                                               ELSE DECODE
                                                      (i_rate_type,
                                                       'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse
                                                          (fl.lic_currency,
                                                           ft.ter_cur_code,
                                                           DECODE
                                                              (fre.reg_code,
                                                               'RSA', l_rsa_ratedate,
                                                               l_afr_ratedate
                                                              )
                                                          ),
                                                       'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater
                                                             (fl.lic_currency,
                                                              ft.ter_cur_code,
                                                              l_last_day
                                                             )
                                                      )
                                            END ex_rate,
                                            lic_amort_code, fre.reg_code,fl.lic_status
                                       FROM fid_territory ft,
                                            fid_company fc,
                                            fid_company fc1,
                                            fid_contract fct,
                                            fid_licensee fle,
                                            fid_license fl,
                                            fid_exchange_rate,
                                            fid_region fre,
                                            x_fin_lic_sec_lee lsl
                                      WHERE ft.ter_code = fc.com_ter_code
                                        AND lee_cha_com_number = fc.com_number
                                        --Dev2:Pure Finance:Start:[Hari Mandal]_[30/4/2013]
                                        --AND lic_lee_number = fle.lee_number
                                        AND fl.lic_number = lsl.lsl_lic_number
                                        AND fle.lee_number =
                                                            lsl.lsl_lee_number
                                        --  and fl.lic_entry_date between nvl(i_from_date,fl.lic_entry_date) and nvl(i_to_date,fl.lic_entry_date)
                                        --Dev2:Pure Finance:End--------------------------
                                        AND con_number = fl.lic_con_number
                                        AND fc1.com_number =
                                                            fct.con_com_number
                                        AND fc.com_short_name LIKE
                                                              i_com_short_name
                                        AND fc.com_type IN ('CC', 'BC')
                                        AND fl.lic_type LIKE i_lic_type
                                        AND fle.lee_short_name LIKE
                                                              i_lee_short_name
                                        AND fl.lic_budget_code LIKE
                                                             i_lic_budget_code
                                        AND fc1.com_short_name LIKE
                                                               i_supp_com_name
                                        AND con_short_name LIKE
                                                              i_con_short_name
                                        AND fl.lic_status NOT IN ('B', 'F', 'T')
                                        AND ( 
                                              (   
                                                  lic_acct_date > LAST_DAY(i_period_date)
                                                  OR  lic_acct_date IS NULL
                                              )
                                              OR
                                              ( 
                                                  lic_acct_date < LAST_DAY(i_period_date)
                                                  AND NOT EXISTS 
                                                  ( 
                                                    SELECT 1 
                                                    FROM FID_LICENSE_SUB_LEDGER flsl 
                                                    WHERE fl.lic_number = flsl.lis_lic_number
                                                    AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = i_period_date
                                                    AND flsl.lis_lic_status = 'A'
                                                    AND flsl.lis_lic_start <= i_period_date
                                                  )
                                              ) 
                                            )
                                        AND rat_cur_code = lic_currency
                                        AND rat_cur_code_2 = ter_cur_code
                                        AND ter_code = fc.com_ter_code
                                        --Dev2:Pure Finance:Start:[Hari Mandal]_[30/4/2013]
                                        --AND fle.lee_region_id = fre.reg_id
                                        AND fle.lee_split_region = fre.reg_id(+)
                                        --Dev2:Pure Finance:End-----------------------------
                                        AND fre.reg_code LIKE i_reg_code
                                   ORDER BY fl.lic_currency,
                                            fl.lic_type,
                                            fle.lee_short_name,
                                            fl.lic_budget_code));
   END prc_fin_mnet_sum_exp_to_exl_n;

END PKG_FIN_MNET_OUTSTAND_COMENT;
/