create or replace PACKAGE PKG_FIN_MNET_MON_COS_CAL
AS
   /**************************************************************************
   REM Module  : Finance
   REM Client  : MNET
   REM File Name   : PKG_FIN_MNET_MON_COS_CAL.sql
   REM Purpose   : This package is used for Monthly Costing Calculation.
   REM Written By  : Vinayak
   REM Date  : 31-02-2010
   REM Type  : Database Package
   REM Change History :
   REM **************************************************************************/
   TYPE c_cursor_payqry IS REF CURSOR;

   PROCEDURE prc_calculate_cos_rout (
      i_com_short_name   IN       fid_company.com_short_name%TYPE,
      i_con_number       IN       fid_contract.con_number%TYPE,
      i_month            IN       NUMBER,
      i_year             IN       NUMBER,
      i_month_end_type   IN       VARCHAR2,
      i_region           IN       VARCHAR2,
      i_user_id          IN       VARCHAR2,
      i_email_id         IN       VARCHAR2,
      i_rpt_optimizer    IN       VARCHAR2,
      o_result           OUT      NUMBER
   --,  o_contracts out  PKG_FIN_MNET_MON_COS_CAL.c_cursor_payqry
   );

   PROCEDURE prc_mon_cos_defaults (o_year OUT NUMBER, o_month OUT NUMBER);
END;
/
create or replace PACKAGE BODY PKG_FIN_MNET_MON_COS_CAL
AS
   PROCEDURE prc_calculate_cos_rout (
      i_com_short_name   IN       fid_company.com_short_name%TYPE,
      i_con_number       IN       fid_contract.con_number%TYPE,
      i_month            IN       NUMBER,
      i_year             IN       NUMBER,
      i_month_end_type   IN       VARCHAR2,
      i_region           IN       VARCHAR2,
      i_user_id          IN       VARCHAR2,
      i_email_id         IN       VARCHAR2,
      i_rpt_optimizer    IN       VARCHAR2,
      o_result           OUT      NUMBER
   --,  o_contracts     out  PKG_FIN_MNET_MON_COS_CAL.c_cursor_payqry
   )
   AS
      l_com_number          fid_company.com_number%TYPE;
      l_com_name            fid_company.com_name%TYPE;
      l_con_short_name      fid_contract.con_short_name%TYPE;
      l_con_name            fid_contract.con_name%TYPE;
      l_con_number          fid_contract.con_number%TYPE;
      l_con_number_t        fid_contract.con_number%TYPE;
      l_mon_cos_routine     VARCHAR2 (4000);
      l_count               NUMBER;
      first_date_of_month   DATE;
      last_date_of_month    DATE;
      no_of_warnings        NUMBER                             := 0;
      month_end_from_date   DATE;
      month_end_todate      DATE;
      email_status          NUMBER;
      l_fim_status_afr      VARCHAR2 (1);
      l_fim_status_rsa      VARCHAR2 (1);
   BEGIN
      l_mon_cos_routine := ' ';
      l_count := 0;

      IF i_month IS NULL OR i_year IS NULL
      THEN
         raise_application_error (-20423, 'Month or Year can not be blank');
      END IF;

      --VALIDATION for Channel Comp --WHN VALIDATE ITEM of Channel Company Short Name
      BEGIN
         SELECT com_number, com_name
           INTO l_com_number, l_com_name
           FROM fid_company
          WHERE com_short_name = i_com_short_name AND com_type = 'CC';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20423, 'Invalid Channel Company');
      END;
      BEGIN
         IF i_region = '%'
         THEN
            SELECT fim_status
              INTO l_fim_status_afr
              FROM fid_financial_month
             WHERE fim_year = i_year
               AND fim_month = i_month
               AND NVL (fim_split_region, 1) = 1;
            SELECT fim_status
              INTO l_fim_status_rsa
              FROM fid_financial_month
             WHERE fim_year = i_year
               AND fim_month = i_month
               AND NVL (fim_split_region, 2) = 2;
         ELSIF i_region = 'RSA'
         THEN
            SELECT fim_status
              INTO l_fim_status_rsa
              FROM fid_financial_month
             WHERE fim_year = i_year
               AND fim_month = i_month
               AND NVL (fim_split_region, 2) = 2;
         ELSE
            SELECT fim_status
              INTO l_fim_status_afr
              FROM fid_financial_month
             WHERE fim_year = i_year
               AND fim_month = i_month
               AND NVL (fim_split_region, 1) = 1;
         END IF;
         IF (l_fim_status_afr = 'B' OR l_fim_status_rsa = 'B')
         THEN
            raise_application_error
               (-20345,
                   'The Month '
                || TO_CHAR (TO_DATE (i_year || LPAD (i_month, 2, 0), 'YYYYMM'),
                            'MON,YYYY'
                           )
                || ' is a Budget Month. Costing routine can only be run for open month.'
               );
         END IF;
         IF (l_fim_status_afr = 'C' OR l_fim_status_rsa = 'C')
         THEN
            raise_application_error
               (-20345,
                   'The Month '
                || TO_CHAR (TO_DATE (i_year || LPAD (i_month, 2, 0), 'YYYYMM'),
                            'MON,YYYY'
                           )
                || ' is a Closed Month. Costing routine can only be run for open month.'
               );
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20888,
                                     'Error :' || SUBSTR (SQLERRM, 1, 200)
                                    );
      END;

      BEGIN
         IF (i_con_number > 0)
         THEN
            SELECT DISTINCT con_number
                       INTO l_con_number_t
                       FROM fid_contract, fid_licensee, fid_company
                      WHERE con_lee_number = lee_number
                        AND com_number = lee_cha_com_number
                        AND com_number = l_com_number
                        AND con_number = i_con_number;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
                                (-20423,
                                 'Check if this contract is for this company'
                                );
         WHEN OTHERS
         THEN
            NULL;
      END;

      first_date_of_month :=
         TO_DATE ('01' || TO_CHAR (i_month, '09') || TO_CHAR (i_year),
                  'DDMMYYYY'
                 );
--- Identify the last day of Amortisation month
      last_date_of_month :=
         LAST_DAY (TO_DATE ('01' || TO_CHAR (i_month, '09')
                            || TO_CHAR (i_year),
                            'DDMMYYYY'
                           )
                  );

      DELETE      x_fin_costing_validations;

-- get the month end defination
      SELECT fmd_from_date, fmd_to_date
        INTO month_end_from_date, month_end_todate
        FROM x_fin_month_defn, fid_region
       WHERE UPPER (fmd_mon_end_type) = UPPER (i_month_end_type)
         AND fmd_month = i_month
         AND fmd_year = i_year
         AND fmd_region = reg_id
         AND UPPER (NVL (reg_code, '#')) LIKE
                 UPPER (DECODE (i_region, '%', NVL (reg_code, '#'), i_region))
         AND ROWNUM < 2;

--check spot rate,forward rate and discount rate for current month
      fid_cos_pk.chk_spot_rate_avail (first_date_of_month,
                                      last_date_of_month,
                                      i_month,
                                      i_year,
                                      i_month_end_type,
                                      i_region,
                                      month_end_from_date,
                                      month_end_todate
                                     );

      IF (i_con_number = 0)
      THEN
         FOR i IN (SELECT DISTINCT con_number             -- , con_short_name
                                             ,
                                   con_name, com_short_name, con_calc_type,
                                   NVL (con_catchup_flag,
                                        'N'
                                       ) con_catchup_flag
                              FROM fid_contract, fid_licensee, fid_company
                             WHERE con_lee_number = lee_number
                               AND com_number = lee_cha_com_number
                               AND com_number = l_com_number)
         LOOP
            fid_cos_pk.validations_check (l_com_number,
                                          i.con_number,
                                          i_month_end_type,
                                          i_region,
                                          first_date_of_month,
                                          last_date_of_month,
                                          month_end_from_date,
                                          month_end_todate
                                         );
         --Pure Finance End
         END LOOP;
      ELSE
         FOR i IN (SELECT DISTINCT con_number             -- , con_short_name
                                             ,
                                   con_name, com_short_name, con_calc_type,
                                   NVL (con_catchup_flag,
                                        'N'
                                       ) con_catchup_flag
                              FROM fid_contract, fid_licensee, fid_company
                             WHERE con_lee_number = lee_number
                               AND com_number = lee_cha_com_number
                               AND com_number = l_com_number
                               AND con_number = i_con_number)
         LOOP
            fid_cos_pk.validations_check (l_com_number,
                                          i.con_number,
                                          i_month_end_type,
                                          i_region,
                                          first_date_of_month,
                                          last_date_of_month,
                                          month_end_from_date,
                                          month_end_todate
                                         );
         --Pure Finance End
         END LOOP;
      END IF;

-- Get the no of warnings from validations tables
      SELECT COUNT (1)
        INTO no_of_warnings
        FROM x_fin_costing_validations;
        
        no_of_warnings:=0;

      IF no_of_warnings = 0
      THEN
         IF (i_con_number = 0)
         THEN
            FOR i IN
               (SELECT DISTINCT con_number                -- , con_short_name
                                          ,
                                con_name, com_short_name, con_calc_type,
                                NVL (con_catchup_flag, 'N') con_catchup_flag
                           FROM fid_contract, fid_licensee, fid_company
                          WHERE con_lee_number = lee_number
                            AND com_number = lee_cha_com_number
                            AND com_number = l_com_number)
            LOOP
               --Pure Finance:[29-APR-13][Mangesh Gulhane][Procedure added for calculation of content,PV,Ed inentory and cost]
               fid_cos_pk.monthly_costing_calculations (l_com_number,
                                                        i.con_number,
                                                        i.con_calc_type,
                                                        i_month,
                                                        i_year,
                                                        i_month_end_type,
                                                        i_region,
                                                        i_user_id,
                                                        SYSDATE,
                                                        i_email_id
                                                       );
               --Pure Finance End
               l_count := l_count + 1;
            END LOOP;
         ELSE
            FOR i IN
               (SELECT DISTINCT con_number                -- , con_short_name
                                          ,
                                con_name, com_short_name, con_calc_type,
                                NVL (con_catchup_flag, 'N') con_catchup_flag
                           FROM fid_contract, fid_licensee, fid_company
                          WHERE con_lee_number = lee_number
                            AND com_number = lee_cha_com_number
                            AND com_number = l_com_number
                            AND con_number = i_con_number)
            LOOP
               --Pure Finance:[29-APR-13][Mangesh Gulhane][Procedure added for calculation of content,PV,Ed inentory and cost]
               fid_cos_pk.monthly_costing_calculations (l_com_number,
                                                        i.con_number,
                                                        i.con_calc_type,
                                                        i_month,
                                                        i_year,
                                                        i_month_end_type,
                                                        i_region,
                                                        i_user_id,
                                                        SYSDATE,
                                                        i_email_id
                                                       );
               --Pure Finance End
               l_count := l_count + 1;
            END LOOP;
         END IF;
         --Finance Dev Phase I Zeshan [Start]
         IF (i_YEAR || LPAD(i_month,2,0)) = TO_CHAR(X_FNC_GET_FIN_I_LIVE_DATE,'RRRRMM')
         THEN
             
             BEGIN
                PRC_PREPAY_LIC_HISTORIC_FIX(i_user_id);
             END;
         END IF;
         --Finance Dev Phase I [End]
      ELSE
         email_status :=
            fid_cos_pk.fun_send_email (i_user_id,
                                       'MonthlyCosting',
                                       SYSDATE,
                                       i_email_id
                                      );
         -- Raise exception so that status of oracle job would be failed
         raise_application_error (-20601,
                                  'Monthly Costing Calculations failed.'
                                 );
      END IF;

      IF (l_count > 0)
      THEN
         o_result := 1;
      ELSE
         o_result := 0;
      END IF;

------- Finance Report optimizatio--------------------
      IF i_rpt_optimizer = 'Y' AND o_result = 1
      THEN
         DECLARE
            i_job_name   VARCHAR2 (100);
            o_success    NUMBER;
         BEGIN
            SELECT 'RO_' || TO_CHAR (SYSDATE, 'YYYYMMDDHH24MISS')
              INTO i_job_name
              FROM DUAL;

            pkg_fin_cm_scheduled_job.act_date_create_job
                                              (i_job_name,
                                               'ReportOptimizer',
                                               SYSDATE,
                                               1,
                                               NULL,
                                               'BEGIN X_PRC_MV_REFRESH; END;',
                                               ' ',
                                               i_user_id,
                                               null,
                                               o_success
                                              );
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;
---------END-----------------------------------------------------------
-- open o_contracts for
--select l_mon_cos_routine CON_SHORT_NAME from dual;
   END prc_calculate_cos_rout;

   PROCEDURE prc_mon_cos_defaults (o_year OUT NUMBER, o_month OUT NUMBER)
   AS
   BEGIN
      BEGIN
         SELECT fim_year, fim_month
           INTO o_year, o_month
           FROM fid_financial_month
          WHERE fim_status = 'O';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20421,
                                     'No Open Financial Month record found'
                                    );
      END;
   END prc_mon_cos_defaults;
END PKG_FIN_MNET_MON_COS_CAL;
/