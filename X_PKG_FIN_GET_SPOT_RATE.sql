CREATE OR REPLACE PACKAGE X_PKG_FIN_GET_SPOT_RATE
AS
   FUNCTION get_spot_rate_with_inverse (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_period      IN   DATE
   )
      RETURN NUMBER DETERMINISTIC;

   FUNCTION get_spot_rate (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_period      IN   DATE
   )
      RETURN NUMBER DETERMINISTIC;

   FUNCTION get_forward_rate_with_inverse (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_period      IN   DATE
   )
      RETURN NUMBER DETERMINISTIC;

   FUNCTION get_is_forward_rate_avialabe (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_day         IN   NUMBER,
      i_month       IN   NUMBER,
      i_year        IN   NUMBER
   )
      RETURN NUMBER DETERMINISTIC;

   FUNCTION cal_forward_rate (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_day         IN   NUMBER,
      i_month       IN   NUMBER,
      i_year        IN   NUMBER
   )
      RETURN NUMBER DETERMINISTIC;

   FUNCTION get_discount_rate (i_month IN NUMBER, i_year IN NUMBER)
      RETURN NUMBER DETERMINISTIC;

   FUNCTION get_spot_rate_with_rater (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_period      IN   DATE
   )
      RETURN NUMBER DETERMINISTIC;
END x_pkg_fin_get_spot_rate;
/
CREATE OR REPLACE PACKAGE BODY X_PKG_FIN_GET_SPOT_RATE
AS
/******************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         02-Nov-2016       Zeshan Khan                 Business Req.-
                                                          1. Business wants to get all the spot rates upto 5 decimal places instead of 4.
*******************************************************************************************************************************************/
   FUNCTION get_spot_rate_with_inverse (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_period      IN   DATE
   )
      RETURN NUMBER DETERMINISTIC
   IS
      spot_rate        NUMBER;
      spot_rate_date   VARCHAR2 (20);
      perday           NUMBER;
      permonth         NUMBER;
      peryear          NUMBER;
      l_date           DATE;
      l_day            VARCHAR2 (20);
      l_inverse_rate   NUMBER;
   BEGIN
      l_date := i_period;

      SELECT content
        INTO spot_rate_date
        FROM x_fin_configs
       WHERE UPPER (KEY) LIKE 'SPOT_RATE' AND ID = 2;

      IF i_period < TO_DATE (spot_rate_date, 'DD-MON-YYYY')
      THEN
         SELECT rat_rate
           INTO spot_rate
           FROM fid_exchange_rate
          WHERE rat_cur_code = i_from_curr AND rat_cur_code_2 = i_to_curr;
      ELSE
         LOOP
            --   DBMS_OUTPUT.PUT_LINE('In 1st loop');
            IF pkg_tvf_out_liab_rpt.holiday_exists (l_date) = 1
            THEN
               l_date := l_date - 1;
            END IF;

            --  DBMS_OUTPUT.PUT_LINE('In 1st loop' ||  L_DATE);
            l_day := TO_CHAR (l_date, 'DAY');

            --   DBMS_OUTPUT.PUT_LINE(L_DAY);
            IF UPPER (TRIM (l_day)) = UPPER (TRIM ('SUNDAY'))
            THEN
               --   DBMS_OUTPUT.PUT_LINE('inside Sunday chk'||L_DATE);
               l_date := l_date - 1;
            END IF;

            --   DBMS_OUTPUT.PUT_LINE('Sunday chk'||L_DATE);
            EXIT WHEN pkg_tvf_out_liab_rpt.holiday_exists (l_date) = 0;
         END LOOP;

         --        DBMS_OUTPUT.PUT_LINE('Out of loop' ||  L_DATE);
         perday := TO_NUMBER (TO_CHAR (l_date, 'DD'));
         permonth := TO_NUMBER (TO_CHAR (l_date, 'MM'));
         peryear := TO_NUMBER (TO_CHAR (l_date, 'YYYY'));

         IF i_from_curr = i_to_curr
         THEN
            spot_rate := 1;
         ELSE
            SELECT spo_n_rate
              INTO spot_rate
              FROM tbl_tvf_spot_rate
             WHERE spo_v_cur_code = i_from_curr
               AND spo_v_cur_code_2 = i_to_curr
               AND spo_n_per_day = perday
               AND spo_n_srs_id = 1
               AND spo_n_per_month = permonth
               AND spo_n_per_year = peryear;
         END IF;
      END IF;

      RETURN ROUND (spot_rate, 5);   -- [Ver 0.1]
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            SELECT spo_n_rate
              INTO spot_rate
              FROM tbl_tvf_spot_rate
             WHERE spo_v_cur_code = i_to_curr
               AND spo_v_cur_code_2 = i_from_curr
               AND spo_n_per_day = perday
               AND spo_n_srs_id = 1
               AND spo_n_per_month = permonth
               AND spo_n_per_year = peryear;

            l_inverse_rate := ROUND (1 / spot_rate, 5);   -- [Ver 0.1]
            RETURN l_inverse_rate;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_inverse_rate := NULL;
               RETURN l_inverse_rate;
         END;
      WHEN OTHERS
      THEN
         spot_rate := NULL;
         RETURN spot_rate;
   -- DBMS_OUTPUT.PUT_LINE('SPOT_RATe-'|| SPOT_RATE);
   END;

   FUNCTION get_spot_rate (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_period      IN   DATE
   )
      RETURN NUMBER DETERMINISTIC
   IS
      spot_rate        NUMBER;
      spot_rate_date   VARCHAR2 (20);
      perday           NUMBER;
      permonth         NUMBER;
      peryear          NUMBER;
      l_date           DATE;
      l_day            VARCHAR2 (20);
   BEGIN
      l_date := i_period;

      SELECT content
        INTO spot_rate_date
        FROM x_fin_configs
       WHERE UPPER (KEY) LIKE 'SPOT_RATE' AND ID = 2;

      IF i_period <= TO_DATE (spot_rate_date, 'DD-MON-YYYY')
      THEN
         SELECT rat_rate
           INTO spot_rate
           FROM fid_exchange_rate
          WHERE rat_cur_code = i_from_curr AND rat_cur_code_2 = i_to_curr;
      ELSE
         LOOP
            -- DBMS_OUTPUT.PUT_LINE('In 1st loop');
            IF pkg_tvf_out_liab_rpt.holiday_exists (l_date) = 1
            THEN
               l_date := l_date - 1;
            END IF;

            --  DBMS_OUTPUT.PUT_LINE('In 1st loop' ||  L_DATE);
            l_day := TO_CHAR (l_date, 'DAY');

            --   DBMS_OUTPUT.PUT_LINE(L_DAY);
            IF UPPER (TRIM (l_day)) = UPPER (TRIM ('SUNDAY'))
            THEN
               --   DBMS_OUTPUT.PUT_LINE('inside Sunday chk'||L_DATE);
               l_date := l_date - 1;
            END IF;

            --   DBMS_OUTPUT.PUT_LINE('Sunday chk'||L_DATE);
            EXIT WHEN pkg_tvf_out_liab_rpt.holiday_exists (l_date) = 0;
         END LOOP;

         --    DBMS_OUTPUT.PUT_LINE('Out of loop' ||  L_DATE);
         perday := TO_NUMBER (TO_CHAR (l_date, 'DD'));
         permonth := TO_NUMBER (TO_CHAR (l_date, 'MM'));
         peryear := TO_NUMBER (TO_CHAR (l_date, 'YYYY'));

         IF i_from_curr = i_to_curr
         THEN
            spot_rate := 1;
         ELSE
            SELECT spo_n_rate
              INTO spot_rate
              FROM tbl_tvf_spot_rate
             WHERE spo_v_cur_code = i_from_curr
               AND spo_v_cur_code_2 = i_to_curr
               AND spo_n_per_day = perday
               AND spo_n_srs_id = 1
               AND spo_n_per_month = permonth
               AND spo_n_per_year = peryear;
         END IF;
      END IF;

      RETURN ROUND (spot_rate, 5);   -- [Ver 0.1]
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         spot_rate := NULL;
         RETURN spot_rate;
      WHEN OTHERS
      THEN
         spot_rate := NULL;
         RETURN spot_rate;
   -- DBMS_OUTPUT.PUT_LINE('SPOT_RATe-'|| SPOT_RATE);
   END;

   FUNCTION get_forward_rate_with_inverse (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_period      IN   DATE
   )
      RETURN NUMBER DETERMINISTIC
   IS
      l_lst_day_prv_mth    DATE;
      l_lst_day_curr_mth   DATE;
      l_temp_fwr_date      DATE;
      l_temp_bck_date      DATE;
      l_fwr_rate           NUMBER;
      l_is_fwr_rate_avl    NUMBER;
      l_perday             NUMBER;
      l_permonth           NUMBER;
      l_peryear            NUMBER;
      l_errortext          VARCHAR2 (10);
   BEGIN
      --to get last date of prev month
      --this will limit the search for forward rate till last day of previous month
      l_lst_day_prv_mth := LAST_DAY (ADD_MONTHS (i_period, -1));
      --to get last date of current month
      --this will limit the search for forward rate till last day of current month
      l_lst_day_curr_mth := LAST_DAY (i_period);
      --this are two pointers used to get future and backward date till the limit specified
      --above
      l_temp_fwr_date := i_period;
      l_temp_bck_date := i_period;
      --to_check if for the supplied date is forward rate avaialabe
      --if yes return the same else LOOP through the month.
      l_perday := TO_NUMBER (TO_CHAR (i_period, 'DD'));
      l_permonth := TO_NUMBER (TO_CHAR (i_period, 'MM'));
      l_peryear := TO_NUMBER (TO_CHAR (i_period, 'YYYY'));
      --check if forward rate is available
      l_is_fwr_rate_avl :=
         x_pkg_fin_get_spot_rate.get_is_forward_rate_avialabe (i_from_curr,
                                                               i_to_curr,
                                                               l_perday,
                                                               l_permonth,
                                                               l_peryear
                                                              );

      IF l_is_fwr_rate_avl <> 0
      THEN
         l_fwr_rate :=
            x_pkg_fin_get_spot_rate.cal_forward_rate (i_from_curr,
                                                      i_to_curr,
                                                      l_perday,
                                                      l_permonth,
                                                      l_peryear
                                                     );
         RETURN l_fwr_rate;
      ELSE
         --loop to get forward rate between last day of previous month and last day of current month
         LOOP
            --this loop will exit if no forward rate is availabe
            EXIT WHEN l_temp_bck_date = l_lst_day_prv_mth
                 AND l_temp_fwr_date = l_lst_day_curr_mth;

            --This condition will calculate if forward rate is avialabe for next day
            IF l_temp_fwr_date < l_lst_day_curr_mth
            THEN
               --To check the availabilty of  forward rate for the next day
               l_temp_fwr_date := l_temp_fwr_date + 1;
               l_perday := TO_NUMBER (TO_CHAR (l_temp_fwr_date, 'DD'));
               l_permonth := TO_NUMBER (TO_CHAR (l_temp_fwr_date, 'MM'));
               l_peryear := TO_NUMBER (TO_CHAR (l_temp_fwr_date, 'YYYY'));
               l_is_fwr_rate_avl :=
                  x_pkg_fin_get_spot_rate.get_is_forward_rate_avialabe
                                                                (i_from_curr,
                                                                 i_to_curr,
                                                                 l_perday,
                                                                 l_permonth,
                                                                 l_peryear
                                                                );

               IF l_is_fwr_rate_avl <> 0
               THEN
                  l_fwr_rate :=
                     x_pkg_fin_get_spot_rate.cal_forward_rate (i_from_curr,
                                                               i_to_curr,
                                                               l_perday,
                                                               l_permonth,
                                                               l_peryear
                                                              );
                  RETURN l_fwr_rate;
               END IF;
            END IF;

            IF l_temp_bck_date > l_lst_day_prv_mth
            THEN
               --To check the availabilty of  forward rate for the prev day
               l_temp_bck_date := l_temp_bck_date - 1;
               l_perday := TO_NUMBER (TO_CHAR (l_temp_bck_date, 'DD'));
               l_permonth := TO_NUMBER (TO_CHAR (l_temp_bck_date, 'MM'));
               l_peryear := TO_NUMBER (TO_CHAR (l_temp_bck_date, 'YYYY'));
               l_is_fwr_rate_avl :=
                  x_pkg_fin_get_spot_rate.get_is_forward_rate_avialabe
                                                                (i_from_curr,
                                                                 i_to_curr,
                                                                 l_perday,
                                                                 l_permonth,
                                                                 l_peryear
                                                                );

               IF l_is_fwr_rate_avl <> 0
               THEN
                  l_fwr_rate :=
                     x_pkg_fin_get_spot_rate.cal_forward_rate (i_from_curr,
                                                               i_to_curr,
                                                               l_perday,
                                                               l_permonth,
                                                               l_peryear
                                                              );
                  RETURN l_fwr_rate;
               END IF;
            END IF;
         END LOOP;

         DBMS_OUTPUT.put_line ('outside Loop');
      END IF;

      --this block will throw exception if forward rate is not available througout the month
      RETURN NULL;
   END get_forward_rate_with_inverse;

   FUNCTION get_is_forward_rate_avialabe (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_day         IN   NUMBER,
      i_month       IN   NUMBER,
      i_year        IN   NUMBER
   )
      RETURN NUMBER DETERMINISTIC
   IS
      l_is_fwr_availabe   NUMBER;
      l_inverse           NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO l_is_fwr_availabe
        FROM x_fin_fwd_rate
       WHERE fwd_cur_code = i_from_curr
         AND fwd_cur_code_2 = i_to_curr
         AND fwd_per_day = i_day
         AND fwd_per_month = i_month
         AND fwd_per_year = i_year
         AND fwd_n_rate IS NOT NULL;

      IF l_is_fwr_availabe = 0
      THEN
         --to check if inverse is available
         SELECT COUNT (*)
           INTO l_inverse
           FROM x_fin_fwd_rate
          WHERE fwd_cur_code = i_to_curr
            AND fwd_cur_code_2 = i_from_curr
            AND fwd_per_day = i_day
            AND fwd_per_month = i_month
            AND fwd_per_year = i_year
            AND fwd_n_rate IS NOT NULL;
      END IF;

      RETURN l_is_fwr_availabe;
   END get_is_forward_rate_avialabe;

   FUNCTION cal_forward_rate (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_day         IN   NUMBER,
      i_month       IN   NUMBER,
      i_year        IN   NUMBER
   )
      RETURN NUMBER
   IS
      l_fwd_n_rate     NUMBER;
      l_inverse_rate   NUMBER;
   BEGIN
      SELECT fwd_n_rate
        INTO l_fwd_n_rate
        FROM x_fin_fwd_rate
       WHERE fwd_cur_code = i_from_curr
         AND fwd_cur_code_2 = i_to_curr
         AND fwd_per_day = i_day
         AND fwd_per_month = i_month
         AND fwd_per_year = i_year;

      RETURN l_fwd_n_rate;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            SELECT fwd_n_rate
              INTO l_fwd_n_rate
              FROM x_fin_fwd_rate
             WHERE fwd_cur_code = i_to_curr
               AND fwd_cur_code_2 = i_from_curr
               AND fwd_per_day = i_day
               AND fwd_per_month = i_month
               AND fwd_per_year = i_year;

            l_inverse_rate := ROUND (1 / l_fwd_n_rate, 5);   -- [Ver 0.1]
            RETURN l_inverse_rate;
         END;
   END cal_forward_rate;

   FUNCTION get_discount_rate (i_month IN NUMBER, i_year IN NUMBER)
      RETURN NUMBER DETERMINISTIC
   IS
      l_disc_rate_per_anl   NUMBER;
      l_disc_rate           NUMBER;
      l_temp_date           DATE;
      l_no_of_days          NUMBER;
   BEGIN
      SELECT drm_disc_per_anl
        INTO l_disc_rate_per_anl
        FROM x_fin_disc_rate
       WHERE drm_month = i_month AND drm_year = i_year;

      SELECT TO_DATE (TO_CHAR (i_month || '-' || '01' || '-' || i_year),
                      'DD-MM-YYYY'
                     )
        INTO l_temp_date
        FROM DUAL;

      --get the number of days in year
      l_no_of_days :=
           ADD_MONTHS (TRUNC (l_temp_date, 'YEAR'), 12)
         - TRUNC (l_temp_date, 'YEAR');
      -- dbms_output.put_line('number of days'||l_no_of_days);
      -- dbms_output.put_line('l_disc_rate_per_anl'||l_disc_rate_per_anl);
      l_disc_rate := l_disc_rate_per_anl / l_no_of_days;
      -- dbms_output.put_line('disc rate'||l_disc_rate);
      RETURN l_disc_rate;
   END;

   FUNCTION get_spot_rate_with_rater (
      i_from_curr   IN   fid_license.lic_currency%TYPE,
      i_to_curr     IN   fid_territory.ter_cur_code%TYPE,
      i_period      IN   DATE
   )
      RETURN NUMBER DETERMINISTIC
   IS
      spot_rate        NUMBER;
      spot_rate_date   VARCHAR2 (20);
      perday           NUMBER;
      permonth         NUMBER;
      peryear          NUMBER;
      l_date           DATE;
      l_day            VARCHAR2 (20);
      l_inverse_rate   NUMBER;
   BEGIN
      l_date := i_period;

      SELECT content
        INTO spot_rate_date
        FROM x_fin_configs
       WHERE UPPER (KEY) LIKE 'SPOT_RATE' AND ID = 2;

      IF i_period <= TO_DATE (spot_rate_date, 'DD-MON-YYYY')
      THEN
         SELECT rat_rate
           INTO spot_rate
           FROM fid_exchange_rate
          WHERE rat_cur_code = i_from_curr AND rat_cur_code_2 = i_to_curr;
      ELSE
         LOOP
            -- DBMS_OUTPUT.PUT_LINE('In 1st loop');
            IF pkg_tvf_out_liab_rpt.holiday_exists (l_date) = 1
            THEN
               l_date := l_date - 1;
            END IF;

            --  DBMS_OUTPUT.PUT_LINE('In 1st loop' ||  L_DATE);
            l_day := TO_CHAR (l_date, 'DAY');

            --   DBMS_OUTPUT.PUT_LINE(L_DAY);
            IF UPPER (TRIM (l_day)) = UPPER (TRIM ('SUNDAY'))
            THEN
               --   DBMS_OUTPUT.PUT_LINE('inside Sunday chk'||L_DATE);
               l_date := l_date - 1;
            END IF;

            --   DBMS_OUTPUT.PUT_LINE('Sunday chk'||L_DATE);
            EXIT WHEN pkg_tvf_out_liab_rpt.holiday_exists (l_date) = 0;
         END LOOP;

         --    DBMS_OUTPUT.PUT_LINE('Out of loop' ||  L_DATE);
         perday := TO_NUMBER (TO_CHAR (l_date, 'DD'));
         permonth := TO_NUMBER (TO_CHAR (l_date, 'MM'));
         peryear := TO_NUMBER (TO_CHAR (l_date, 'YYYY'));

         IF i_from_curr = i_to_curr
         THEN
            spot_rate := 1;
         ELSE
            SELECT spo_n_rate
              INTO spot_rate
              FROM tbl_tvf_spot_rate
             WHERE spo_v_cur_code = i_from_curr
               AND spo_v_cur_code_2 = i_to_curr
               AND spo_n_per_day = perday
               AND spo_n_exchange_rate_type = 'R'
               AND spo_n_per_month = permonth
               AND spo_n_per_year = peryear;
         END IF;
      END IF;

      RETURN ROUND (spot_rate, 5);   -- [Ver 0.1]
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            SELECT spo_n_rate
              INTO spot_rate
              FROM tbl_tvf_spot_rate
             WHERE spo_v_cur_code = i_to_curr
               AND spo_v_cur_code_2 = i_from_curr
               AND spo_n_per_day = perday
               AND spo_n_srs_id = 1
               AND spo_n_per_month = permonth
               AND spo_n_per_year = peryear;

            l_inverse_rate := ROUND (1 / spot_rate, 5);   -- [Ver 0.1]
            RETURN l_inverse_rate;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_inverse_rate := NULL;
               RETURN l_inverse_rate;
         END;
      WHEN OTHERS
      THEN
         spot_rate := NULL;
         RETURN spot_rate;
   -- DBMS_OUTPUT.PUT_LINE('SPOT_RATe-'|| SPOT_RATE);
   END;
END x_pkg_fin_get_spot_rate;
/