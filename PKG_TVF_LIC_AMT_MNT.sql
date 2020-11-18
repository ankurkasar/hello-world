create or replace PACKAGE          "PKG_TVF_LIC_AMT_MNT" AS

/**************************************************************************
REM Module          : TVOD Finance
REM Client          : MNET
REM File Name       : PKG_TVF_LIC_AMT_MNT
REM Purpose         : This procedure is used to view the license amortisation detail
REM Written By      : Ajitkumar Tanwade
REM Date            : 22-Sep-2011
REM Type            : Database Package
REM Change History  : Created
REM **************************************************************************/

  TYPE c_cursor_licamt IS REF CURSOR;

--****************************************************************
-- This procedure outputs license detail.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_tvf_lic_view (
      i_program_title    IN       tvod_license_vw.gen_title%TYPE,
      i_lic_no           IN       tvod_license_vw.LIC_V_NUMBER%TYPE,
      i_con_short_name   IN       tvod_license_vw.CON_V_SHORT_NAME%TYPE,
      i_start_date       IN       tvod_license_vw.LIC_DT_START_DATE%TYPE,
      i_end_date         IN       tvod_license_vw.LIC_DT_END_DATE%TYPE,
      i_type             IN       tvod_license_vw.LIC_N_DM_TYPE%TYPE,
      i_licencee         IN       tvod_license_vw.TVOD_V_LEE_SHORT_NAME%TYPE,
      i_amort_code       IN       tvod_license_vw.lic_v_amort_code%TYPE,
      o_con_dtls         OUT      PKG_TVF_LIC_AMT_MNT.c_cursor_licamt
   );

--****************************************************************
-- This procedure outputs license amortisation detail.
-- REM Client - MNET
--****************************************************************
  PROCEDURE prc_tvf_lic_amt_dtls (
      i_lic_no         IN       tvod_license_vw.lic_v_number%TYPE,
      o_lic_amt_dtls   OUT      pkg_tvf_lic_amt_mnt.c_cursor_licamt,
      o_lic_sch_dtls   OUT      pkg_tvf_lic_amt_mnt.c_cursor_licamt,
      o_write_off_flag OUT      pkg_tvf_lic_amt_mnt.c_cursor_licamt
   );

     --****************************************************************
-- This function outputs spot rate for a particular date.
-- REM Client - MNET
--****************************************************************
   FUNCTION fun_tvf_spot_rate (
      fromcurr   IN   VARCHAR2,
      tocurr     IN   VARCHAR2,
      ondate     IN   DATE
   )RETURN NUMBER;

END PKG_TVF_LIC_AMT_MNT;
/
create or replace PACKAGE BODY          "PKG_TVF_LIC_AMT_MNT"
AS
--****************************************************************
-- This procedure outputs license detail.
-- REM Client - MNET
--****************************************************************
   PROCEDURE prc_tvf_lic_view (
      i_program_title    IN       tvod_license_vw.gen_title%TYPE,
      i_lic_no           IN       tvod_license_vw.lic_v_number%TYPE,
      i_con_short_name   IN       tvod_license_vw.con_v_short_name%TYPE,
      i_start_date       IN       tvod_license_vw.lic_dt_start_date%TYPE,
      i_end_date         IN       tvod_license_vw.lic_dt_end_date%TYPE,
      i_type             IN       tvod_license_vw.lic_n_dm_type%TYPE,
      i_licencee         IN       tvod_license_vw.tvod_v_lee_short_name%TYPE,
      i_amort_code       IN       tvod_license_vw.lic_v_amort_code%TYPE,
      o_con_dtls         OUT      pkg_tvf_lic_amt_mnt.c_cursor_licamt
   )
   AS
      l_qry_string   VARCHAR2 (5000);
   BEGIN
      l_qry_string :=
         'SELECT
               GEN_REFNO
              ,gen_title
              , LIC_V_NUMBER
              , CON_V_SHORT_NAME
              , CON_V_CURRENCY
              , LIC_N_PRICE LIC_PRICE
              , LIC_DT_START_DATE
              , LIC_DT_END_DATE
              , LIC_DT_ACCOUNT_DATE
              , DEAL_TYPE
              , TVOD_V_LEE_SHORT_NAME
              , LIC_V_BUDGET_TYPE
              , LIC_V_AMORT_CODE
              , LIC_N_SPOT_RATE
         FROM tvod_license_vw, TVOD_DEAL_MEMO_TYPE
          WHERE DM_TYPE_ID = LIC_N_DM_TYPE
          AND   ROWNUM <= 500  ';

      IF i_program_title IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and gen_title like ''' || i_program_title
            || '''';
      END IF;

      IF i_lic_no IS NOT NULL
      THEN
         l_qry_string :=
              l_qry_string || ' and LIC_V_NUMBER like ''' || i_lic_no || '''';
      END IF;

      IF i_con_short_name IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and CON_V_SHORT_NAME like '''
            || i_con_short_name
            || '''';
      END IF;

      IF i_amort_code IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and lic_v_amort_code like '''
            || i_amort_code
            || '''';
      END IF;

      IF i_start_date IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and LIC_DT_START_DATE  like to_date('''
            || i_start_date
            || ''')';
      END IF;

      IF i_end_date IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and LIC_DT_END_DATE like to_date('''
            || i_end_date
            || ''')';
      END IF;

      IF i_type IS NOT NULL
      THEN
         l_qry_string := l_qry_string || ' and LIC_N_DM_TYPE =' || i_type;
      END IF;

      IF i_licencee IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and TVOD_V_LEE_SHORT_NAME like '''
            || i_licencee
            || '''';
      END IF;

      l_qry_string := l_qry_string || ' order by gen_title ';

      OPEN o_con_dtls FOR l_qry_string;

      DBMS_OUTPUT.put_line (l_qry_string);
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20002,
                                  'An error occurred. Message: ' || SQLERRM
                                 );
   END prc_tvf_lic_view;

--****************************************************************
-- This procedure outputs license amortisation detail.
-- REM Client - MNET
--****************************************************************
   PROCEDURE prc_tvf_lic_amt_dtls (
      i_lic_no         IN       tvod_license_vw.lic_v_number%TYPE,
      o_lic_amt_dtls   OUT      pkg_tvf_lic_amt_mnt.c_cursor_licamt,
      o_lic_sch_dtls   OUT      pkg_tvf_lic_amt_mnt.c_cursor_licamt,
      o_write_off_flag OUT      pkg_tvf_lic_amt_mnt.c_cursor_licamt
   )
   AS
   BEGIN
        OPEN o_write_off_flag FOR
          select (case when count(1) > 1 then 1 else 0 end) dwo_n_number
              from (
              select distinct ( case when DWO_APPROVE_STATUS = 'REJECTED' then 0
              when DWO_AUTH_STATUS =  'AUTHORISATIONREJECTED' then 0
              else dwo_n_number end ) dwo_n_number
              from	TBL_TVF_DIS_WRITE_OFF
              where	DWO_V_LIC_NUMBER =  i_lic_no )
              --- group by dwo_n_number
              ;

           OPEN o_lic_amt_dtls FOR
           SELECT  leg.lis_n_per_month,                                               -- Month
                  leg.lis_n_per_year,                                                 -- Year
                  ROUND (NVL (leg.lis_n_con_total_fees, 0), 4) total_fees,            -- Total Fees
                  ROUND (NVL (leg.lis_n_con_inventory, 0), 4) mg,                     -- MG
                  ROUND (NVL (leg.lis_n_con_ovg_inv, 0), 4) overage,                  -- Overage
                  ROUND (NVL (leg.lis_n_overage_spot_rate, 0),
                         5                                                            -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                        ) overage_spot_rate,                                          -- Overage Spot Rate
                  (ROUND (NVL (leg.lis_n_con_cost, 0), 4) +
                     ROUND (NVL (leg.LIS_N_CON_OVG_INV, 0), 4))  total_cost,          -- Cost
                  ROUND (NVL (leg.lis_n_con_cost, 0), 4) mg_costed,                   -- MG Costed
                  ROUND (NVL (leg.LIS_N_CON_OVG_INV, 0), 4) ovg_costed,               -- Ovg Costed
                  ROUND (NVL (leg.lis_n_con_adjust, 0), 4) adjustment,                -- Adjustment
                  ROUND (NVL (leg.LIS_N_CON_WRITE_OFF, 0), 4) write_off,              -- Write off
                  leg.lis_v_comments comments,                                        -- Comments
                  ROUND ((  ( SELECT ROUND(SUM(NVL (sub.lis_n_con_inventory, 0)
                                    + NVL (sub.lis_n_con_ovg_inv, 0)),4)
                                FROM tbl_tvf_license_sub_ledger sub
                                WHERE sub.lis_v_lic_number = i_lic_no
                               --   AND sub.lis_n_per_month <= leg.lis_n_per_month
                              --    AND sub.lis_n_per_year <= leg.lis_n_per_year
                            )
                          - ( SELECT ROUND(SUM(NVL (lis_n_con_cost, 0)
                                    + NVL (sub_leg.lis_n_con_ovg_inv, 0)),4)
                                FROM tbl_tvf_license_sub_ledger sub_leg
                                WHERE sub_leg.lis_v_lic_number = i_lic_no
                                --  AND sub_leg.lis_n_per_month <= leg.lis_n_per_month
                                --  AND sub_leg.lis_n_per_year <= leg.lis_n_per_year
                            )
                          - NVL (lis_n_con_adjust, 0)
                          - ( Select sum(NVL (a.LIS_N_CON_WRITE_OFF, 0))
                              from  tbl_tvf_license_sub_ledger a
                              where a.lis_v_lic_number = i_lic_no
                          )
                         ),
                         4
                        ) inv_balance                        -- Inventory Balance
             FROM tbl_tvf_license_sub_ledger leg
            WHERE leg.lis_v_lic_number = i_lic_no
         ORDER BY leg.lis_n_per_year, leg.lis_n_per_month;


      OPEN o_lic_sch_dtls FOR
         SELECT DISTINCT sch_d_start_date, sch_d_end_date
           FROM tbl_tvs_schedule
          WHERE sch_v_lic_number = i_lic_no;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20002,
                                  'An error occurred. Message: ' || SQLERRM
                                 );
   END prc_tvf_lic_amt_dtls;

   --****************************************************************
-- This function outputs spot rate for a particular date.
-- REM Client - MNET
--****************************************************************
   FUNCTION fun_tvf_spot_rate (
      fromcurr   IN   VARCHAR2,
      tocurr     IN   VARCHAR2,
      ondate     IN   DATE
   )
      RETURN NUMBER
   IS
      spotrate   NUMBER;
      perday     NUMBER;
      permonth   NUMBER;
      peryear    NUMBER;
   BEGIN
      perday := TO_NUMBER (TO_CHAR (ondate, 'DD'));
      permonth := TO_NUMBER (TO_CHAR (ondate, 'MM'));
      peryear := TO_NUMBER (TO_CHAR (ondate, 'YYYY'));

      BEGIN
         IF fromcurr = tocurr
         THEN
            spotrate := 1;
         ELSE
            SELECT spo_n_rate
              INTO spotrate
              FROM tbl_tvf_spot_rate
             WHERE UPPER (spo_v_cur_code) = UPPER (fromcurr)
               AND UPPER (spo_v_cur_code_2) = UPPER (tocurr)
               AND spo_n_per_day = perday
               AND spo_n_per_month = permonth
               AND spo_n_per_year = peryear;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            spotrate := '';
         WHEN OTHERS
         THEN
            raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
      END;

      RETURN spotrate;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END fun_tvf_spot_rate;

END pkg_tvf_lic_amt_mnt;
/