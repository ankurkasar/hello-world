CREATE OR REPLACE PACKAGE PKG_FIN_LIB_VALUATION
AS
   PROCEDURE prc_prg_lib_valution_rep (
      i_region_code       IN       fid_region.reg_code%TYPE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
      i_report_type       IN       VARCHAR2,
      i_report_sub_type   IN       VARCHAR2,
      --Dev2: Pure Finance : End
      i_chnal_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      --Dev2: Pure Finance :End
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_acc_prv_rate      IN       CHAR,
      i_inc_markup        IN       CHAR,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/3/19]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_period_date       IN       DATE,
      --Dev2: Pure Finance :End
      i_include_zero      IN       CHAR,
      --[01-jun-2016]Start[Ankur.Kasar]Added param for FIN CR
      i_summary_flag      IN       X_SUMMARY_PROG_LIB_VAL.INCLUDE_ZERO%TYPE,
      i_type              IN       VARCHAR2,
      --[01-jun-2016]End[Ankur.Kasar]Added param for FIN CR
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_prg_lib_valution_rep_exl (
      i_region_code       IN       fid_region.reg_code%TYPE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
      i_report_type       IN       VARCHAR2,
      i_report_sub_type   IN       VARCHAR2,
      --Dev2: Pure Finance : End
      i_chnal_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      --Dev2: Pure Finance :End
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_acc_prv_rate      IN       CHAR,
      i_inc_markup        IN       CHAR,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/3/19]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_period_date       IN       DATE,
      --Dev2: Pure Finance :End
      i_include_zero      IN       CHAR,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   -- Start :Fincr new requrement for summary export to excel report (Ankur.Kasar)..
   PROCEDURE prc_prg_lib_val_sum_rep_exl (
      i_report_sub_type   IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );
   -- End :Fincr new requrement for summary export to excel report (Ankur.Kasar)..

   FUNCTION ex_rate_lib_val (
      i_acc_prv_rate   CHAR,
      i_lic_currency   fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code   fid_exchange_rate.rat_cur_code_2%TYPE
   /*I_LIC_NUMBER       fid_license.lic_number%type,
   --Dev2: Pure Finance : Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/19]
   i_lic_start          date,
   I_GO_LIVE_DATE       DATE,
   i_lsl_number           number
   --Dev2: Pure Finance : End*/
   )
      RETURN NUMBER;

   FUNCTION con_fc (
      i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER;

   FUNCTION con_aa (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      lsl_number      x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER;

   FUNCTION td_exh (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
                             --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   ,
      i_lic_start        DATE,
      i_go_live_date     DATE
   --Dev2: Pure Finance :END
   )
      RETURN NUMBER;

   FUNCTION td_unpaid (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
   )
      RETURN NUMBER;

   FUNCTION td_not_paid (
      l_sch_lic_number   fid_schedule.sch_lic_number%TYPE,
      i_period_date      DATE
   )
      RETURN NUMBER;

   FUNCTION td_total (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE,
      lsl_number         x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER;

   --Dev2: Pure Finance Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   FUNCTION loc_fc (
      i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER;

   FUNCTION loc_aa (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      lsl_number      x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER;

   FUNCTION con_fc_fin (
      --i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER;

   FUNCTION con_aa_fin (
      -- i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      lsl_number      x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER;

   FUNCTION loc_fc_fin (
      --i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER;

   FUNCTION loc_aa_fin (
      -- i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      lsl_number      x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER;

   FUNCTION ed_inv (
      --i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER;

   FUNCTION ed_cos (
      --i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER;
--Dev2: Pure Finance :End
END pkg_fin_lib_valuation;
/
CREATE OR REPLACE PACKAGE BODY PKG_FIN_LIB_VALUATION
AS
   FUNCTION ex_rate_lib_val (
      i_acc_prv_rate   CHAR,
      i_lic_currency   fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code   fid_exchange_rate.rat_cur_code_2%TYPE
   /*I_LIC_NUMBER       fid_license.lic_number%type,
   --Dev2: Pure Finance : Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/19]
   i_lic_start          date,
   I_GO_LIVE_DATE       DATE,
   i_lsl_number           number
   --Dev2: Pure Finance : End*/
   )
      RETURN NUMBER
   AS
      l_ex_rate   NUMBER;
   BEGIN
      BEGIN
         SELECT fer.rat_rate
           INTO l_ex_rate
           FROM fid_exchange_rate fer
          WHERE fer.rat_cur_code = i_lic_currency
            AND fer.rat_cur_code_2 = i_ter_cur_code;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_ex_rate := 1.0000;
      END;

      RETURN TRUNC (l_ex_rate, 4);
   END;

   FUNCTION con_fc (
      i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER
   AS
      l_con_fc_is   NUMBER;
   BEGIN
      SELECT DECODE (i_inc_markup,
                     'I', SUM (ROUND (flv.lis_con_fc_imu, 2)),
                     SUM (ROUND (flv.lis_con_fc_emu, 2))
                    )
        INTO l_con_fc_is
        FROM x_mv_subledger_data
                                /*fid_lis_vw*/
             flv
       WHERE flv.lis_lic_number = l_lic_number
         AND flv.lis_lsl_number = i_lsl_number
         AND flv.lis_yyyymm_num
                               /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
             <= TO_NUMBER (TO_CHAR (TO_DATE (i_period_date), 'YYYYMM'));

      RETURN ROUND (l_con_fc_is, 2);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

---for local fee calculations
   FUNCTION loc_fc (
      i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER
   AS
      l_loc_fc_is   NUMBER;
   BEGIN
      SELECT DECODE (i_inc_markup,
                     'I', SUM (NVL (flv.lis_loc_fc_imu, flv.lis_loc_fc_emu_23)),
                     SUM (flv.lis_loc_fc_emu_23)
                    )
        INTO l_loc_fc_is
        FROM x_mv_subledger_data
                                /*fid_lis_vw*/
             flv
       WHERE flv.lis_lic_number = l_lic_number
         AND flv.lis_lsl_number = i_lsl_number
         AND flv.lis_yyyymm_num
                               /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
             <= TO_NUMBER (TO_CHAR (TO_DATE (i_period_date), 'YYYYMM'));

      RETURN l_loc_fc_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

--- for local cost calculations
   FUNCTION loc_aa (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      lsl_number      x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER
   AS
      l_loc_aa_is   NUMBER;
   BEGIN
      SELECT DECODE (i_inc_markup,
                     'I', SUM (NVL (flv.lis_loc_aa_imu, flv.lis_loc_aa_emu)),
                     SUM (flv.lis_loc_aa_emu)
                    )
        INTO l_loc_aa_is
        FROM x_mv_subledger_data
                                /*fid_lis_vw*/
             flv
       WHERE flv.lis_lic_number = i_lic_number
         AND flv.lis_lsl_number = lsl_number
         AND flv.lis_yyyymm_num
                               /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
             <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN l_loc_aa_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

--Dev2: Pure Finance Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   FUNCTION con_fc_fin (
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER
   AS
      l_con_fc_is   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (flv.lis_pv_con_fc_emu)
           INTO l_con_fc_is
           FROM x_mv_subledger_data
                                   /*fid_lis_vw*/
                flv
          WHERE flv.lis_yyyymm_num
                                  /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
                <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
            AND flv.lis_lic_number = l_lic_number
            AND flv.lis_lsl_number = i_lsl_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_con_fc_is := 0;
      END;

      IF l_con_fc_is IS NULL
      THEN
         l_con_fc_is := 0;
      END IF;

      RETURN l_con_fc_is;
   END;

---- for local curr calculation of PV
   FUNCTION loc_fc_fin (
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER
   AS
      l_loc_fc_is   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (flv.lis_pv_loc_fc_emu)
           INTO l_loc_fc_is
           FROM x_mv_subledger_data
                                   /*fid_lis_vw*/
                flv
          WHERE flv.lis_yyyymm_num
                                  /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
                <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
            AND flv.lis_lic_number = l_lic_number
            AND flv.lis_lsl_number = i_lsl_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_loc_fc_is := 0;
      END;

      IF l_loc_fc_is IS NULL
      THEN
         l_loc_fc_is := 0;
      END IF;

      RETURN l_loc_fc_is;
   END;

   FUNCTION con_aa_fin (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      lsl_number      x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER
   AS
      l_con_aa_is   NUMBER;
   BEGIN
      SELECT SUM (flv.lis_pv_con_ac_emu)
        INTO l_con_aa_is
        FROM x_mv_subledger_data
                                /*fid_lis_vw*/
             flv
       WHERE flv.lis_lic_number = i_lic_number
         AND flv.lis_lsl_number = lsl_number
         AND flv.lis_yyyymm_num
                               /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
             <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN l_con_aa_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

-- for local currency calculations of PV
   FUNCTION loc_aa_fin (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      lsl_number      x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER
   AS
      l_loc_aa_is   NUMBER;
   BEGIN
      SELECT SUM (flv.lis_pv_loc_ac_emu)
        INTO l_loc_aa_is
        FROM x_mv_subledger_data
                                /*fid_lis_vw*/
             flv
       WHERE flv.lis_lic_number = i_lic_number
         AND flv.lis_lsl_number = lsl_number
         AND flv.lis_yyyymm_num
                               /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
             <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN l_loc_aa_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

   FUNCTION ed_inv (
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER
   AS
      l_con_fc_is   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (flv.lis_ed_loc_fc_emu)
           INTO l_con_fc_is
           FROM x_mv_subledger_data
                                   /*fid_lis_vw*/
                flv
          WHERE flv.lis_yyyymm_num
                                  /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
                <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
            AND flv.lis_lic_number = l_lic_number
            AND flv.lis_lsl_number = i_lsl_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_con_fc_is := 0;
      END;

      IF l_con_fc_is IS NULL
      THEN
         l_con_fc_is := 0;
      END IF;

      RETURN l_con_fc_is;
   END;

   FUNCTION ed_cos (
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER
   AS
      l_con_fc_is   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (flv.lis_ed_loc_ac_emu)
           INTO l_con_fc_is
           FROM x_mv_subledger_data
                                   /*fid_lis_vw*/
                flv
          WHERE flv.lis_yyyymm_num
                                  /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
                <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
            AND flv.lis_lic_number = l_lic_number
            AND flv.lis_lsl_number = i_lsl_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_con_fc_is := 0;
      END;

      IF l_con_fc_is IS NULL
      THEN
         l_con_fc_is := 0;
      END IF;

      RETURN l_con_fc_is;
   END;

--Dev2: Pure Finance :End
   FUNCTION con_aa (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      lsl_number      x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER
   AS
      l_con_aa_is   NUMBER;
   BEGIN
      SELECT DECODE (i_inc_markup,
                     'I', SUM (flv.lis_con_aa_imu_23),
                     SUM (flv.lis_con_aa_emu_23)
                    )
        INTO l_con_aa_is
        FROM x_mv_subledger_data
                                /*fid_lis_vw*/
             flv
       WHERE flv.lis_lic_number = i_lic_number
         AND flv.lis_lsl_number = lsl_number
         AND flv.lis_yyyymm_num
                               /*flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)*/
             <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN l_con_aa_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN 0;
   END;

/*  Paid Amount */
   FUNCTION td_exh (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
                             --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   ,
      i_lic_start        DATE,
      i_go_live_date     DATE
   --Dev2: Pure Finance :END
   )
      RETURN NUMBER
   AS
      l_td_exh   NUMBER;
   BEGIN
      BEGIN
         IF ((i_lic_start < i_go_live_date))
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
             WHERE fsv.sch_year || LPAD (fsv.sch_month, 2, 0) <=
                                             TO_CHAR (i_period_date, 'YYYYMM')
               AND fsv.sch_lic_number = lic_number
               AND fsv.sch_lic_number = l_sch_lic_number;
         --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
         ELSE
            SELECT COUNT (xfcs.csh_lic_number)
              INTO l_td_exh
              FROM x_fin_cost_schedules xfcs
             WHERE xfcs.csh_lic_number = l_sch_lic_number
               AND xfcs.csh_year || LPAD (xfcs.csh_month, 2, 0) <=
                                             TO_CHAR (i_period_date, 'YYYYMM');
         END IF;

         RETURN l_td_exh;                                   --nvl(l_TD_Exh,0);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_td_exh := 0;
         WHEN OTHERS
         THEN
            l_td_exh := 0;
      END;
   /*if l_TD_Exh is null
   then
   l_TD_Exh := 0;
   end if;*/
   --RETURN  nvl(l_TD_Exh,0);
   END;

/*  Unpaid Amount */
   FUNCTION td_unpaid (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
   )
      RETURN NUMBER
   AS
      l_td_exh   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (fsv.sch_free)
           INTO l_td_exh
           FROM fid_sch_summary_vw fsv
          WHERE fsv.sch_year || LPAD (fsv.sch_month, 2, 0) <=
                                             TO_CHAR (i_period_date, 'YYYYMM')
            AND fsv.sch_lic_number = l_sch_lic_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_td_exh := 0;
      END;

      IF l_td_exh IS NULL
      THEN
         l_td_exh := 0;
      END IF;

      RETURN l_td_exh;
   END;

/*  lic_EXH_Used Amount */
   FUNCTION td_not_paid (
      l_sch_lic_number   fid_schedule.sch_lic_number%TYPE,
      i_period_date      DATE
   )
      RETURN NUMBER
   AS
      l_td_exh   NUMBER;
   BEGIN
      BEGIN
         SELECT NVL (  SUM (DECODE (fs.sch_type, 'N', 1, 0))
                     + SUM (DECODE (fs.sch_type, 'P', 1, 0)),
                     0
                    ) sch_not_paid
           INTO l_td_exh
           FROM fid_schedule fs
          WHERE fs.sch_lic_number = l_sch_lic_number
            AND fs.sch_date <= TO_DATE (i_period_date);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_td_exh := 0;
      END;

      IF l_td_exh IS NULL
      THEN
         l_td_exh := 0;
      END IF;

      RETURN l_td_exh;
   END;

/*  Total Amount */
   FUNCTION td_total (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE,
      lsl_number         x_fin_lic_sec_lee.lsl_number%TYPE
   )
      RETURN NUMBER
   AS
      l_td_exh       NUMBER;
      l_cp_lee_cnt   NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO l_cp_lee_cnt
           FROM fid_licensee flee, fid_license fl
          WHERE fl.lic_lee_number = flee.lee_number
            AND fl.lic_number = l_sch_lic_number
            AND flee.lee_media_service_code = 'CATCHUP';

         IF l_cp_lee_cnt = 0
         THEN
            SELECT NVL (SUM (DECODE (fl.lic_catchup_flag,
                                     'Y', NULL,
                                     fsv.sch_total
                                    )
                            ),
                        0
                       )
              INTO l_td_exh
              FROM fid_sch_summary_vw fsv, fid_license fl
             WHERE fsv.sch_lic_number = fl.lic_number
               AND fsv.sch_year || LPAD (fsv.sch_month, 2, 0) <=
                                             TO_CHAR (i_period_date, 'YYYYMM')
               AND fsv.sch_lic_number = l_sch_lic_number;
         ELSE
            l_td_exh := NULL;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_td_exh := 0;
         WHEN OTHERS
         THEN
            l_td_exh := 0;
      END;

      /*if l_TD_Exh is null
      then
      l_TD_Exh := 0;
      end if;*/
      RETURN l_td_exh;
   END;

   PROCEDURE prc_prg_lib_valution_rep (
      i_region_code       IN       fid_region.reg_code%TYPE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
      i_report_type       IN       VARCHAR2,
      i_report_sub_type   IN       VARCHAR2,
      --Dev2: Pure Finance : End
      i_chnal_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      --Dev2: Pure Finance :End
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_acc_prv_rate      IN       CHAR,
      i_inc_markup        IN       CHAR,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/3/19]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_period_date       IN       DATE,
      --Dev2: Pure Finance :End
      i_include_zero      IN       CHAR,
       --[01-jun-2016]Start[Ankur.Kasar]Added param for FIN CR
      i_summary_flag      IN       X_SUMMARY_PROG_LIB_VAL.INCLUDE_ZERO%TYPE,      --REQUESTED BY FIN_CR.(Ankur Kasar)
      i_type              IN       VARCHAR2,  --REQUESTED BY FIN_CR.(Ankur Kasar)
       --[01-jun-2016]End[Ankur.Kasar]Added param for FIN CR
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (30000);
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      v_go_live_date   DATE;
   --Dev2: Pure Finance :End
    --[01-jun-2016]Start[Ankur.Kasar]Added param for FIN CR
      l_com_short_name 	       varchar2(512);
      l_delete_month           NUMBER := TO_NUMBER (TO_CHAR (i_period_date,'YYYYMM'));
      l_trc_query              varchar2(1000);
    --[01-jun-2016]End[Ankur.Kasar]Added param for FIN CR
   BEGIN

      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT TO_DATE (xfc.content)
        INTO v_go_live_date
        FROM x_fin_configs xfc
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      IF i_include_zero = 'Y'
      THEN

      -- DEV- BR_15_006 - FINCR 30.(Ankur Kasar)
      if((upper(i_type) = 'DETAILS') AND (i_summary_flag = 'Y'))
            THEN

      l_trc_query := 'TRUNCATE TABLE X_SUMMARY_PROG_LIB_VAL';

      EXECUTE IMMEDIATE l_trc_query;

              INSERT INTO X_SUMMARY_PROG_LIB_VAL
              (
                  REGION            ,
                  COM_NAME          ,
                  LIC_CURRENCY      ,
                  PERIOD            ,
                  TER_CUR_CODE      ,
                  EX_RATE           ,
                  LIC_TYPE          ,
                  LEE_SHORT_NAME    ,
                  LIC_BUDGET_CODE   ,
                  SUPPLIER          ,
                  CONTRACT          ,
                  LIC_NUMBER        ,
                  GEN_TITLE         ,
                  ACCT_DATE         ,
                  CON_EFF_DATE      ,
                  LIC_START         ,
                  LIC_END           ,
                  AM_CO             ,
                  LIC_EXH           ,
                  LIC_EXH_USED      ,
                  AMO_EXH           ,
                  PAID_EXH          ,
                  UNPAID_EXH        ,
                  TD_EXH            ,
                  AMO_EXH_REM       ,
                  LIC_MARKUP_PERCENT,
                  CON_FC            ,
                  CON_AA            ,
                  CLOSE_MARKUP      ,
                  CLOSE_MARKUP2     ,
                  LIC_SHOWING_FIRST ,
                  PV_CON_FC         ,
                  PV_CON_AA         ,
                  CLOSED_INV_PV     ,
                  TOTAL_CLOSED_LIC  ,
                  CLOSED_INV_PV2    ,
                  ED_INV            ,
                  ED_COS            ,
                  ED_CLOSE          ,
                  TOTAL_CLOSED_LOC  ,
                  FREE_REPEAT       ,
                  LIC_PRICE         ,
                  I_MON_YEAR        ,
                  INCLUDE_ZERO      ,
                  I_BUDGET_CODE     ,
                  I_CONTRACT
              )
                SELECT
                    --Dev2: Pure Finance :Start:[FIN 7]_[ANUJASHINDE]_[2013/3/19]
                       region
                             --Dev2: Pure Finance :End
                       , com_name,
                       lic_currency,
                       TO_CHAR (i_period_date, 'YYYY/MM/DD HH:MI:SS') period,
                       ter_cur_code
                                   /*
                                   NOC :
                                   Changes done to Show correct exchange rate and local currency invnetory
                                   NEERAJ : KARIM : 13-12-2013
                                   */
                                   /*(CASE
                                   WHEN lic_start < v_go_live_date
                                   THEN ex_rate
                                   ELSE ROUND (DECODE (NVL (con_fc, 0),
                                   0, lic_rate,
                                   (NVL (loc_fc, 0) / NVL (con_fc, 0)
                                   )
                                   ),
                                   4
                                   )
                                   END
                                   ) ex_rate,*/
                       ,
                       (CASE
                           WHEN lic_start < v_go_live_date
                           AND lic_acct_date < v_go_live_date
                              THEN ex_rate
                           WHEN lic_start >= v_go_live_date
                           AND lic_acct_date >= v_go_live_date
                              THEN ROUND (DECODE (NVL (con_fc, 0),
                                                  0, lic_rate,
                                                  (  NVL (loc_fc, 0)
                                                   / NVL (con_fc, 0)
                                                  )
                                                 ),
                                          5
                                         )
                           WHEN TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') >=
                                       TO_CHAR (TO_DATE (lic_acct_date), 'YYYYMM')
                           AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                      TO_CHAR (TO_DATE (v_go_live_date), 'YYYYMM')
                              THEN ex_rate
                           WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                              (SELECT yearmonth_char
                                                 FROM
                                                      /*subledger_data*/
                                                      x_mv_lib_reval_ex
                                                WHERE lis_lic_number = lic_number)
                                )
                              THEN ex_rate
                           ELSE ROUND (DECODE (NVL (con_fc, 0),
                                               0, NVL (lic_rate, ex_rate),
                                               (NVL (loc_fc, 0) / NVL (con_fc, 0)
                                               )
                                              ),
                                       5
                                      )
                        END
                       ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                       lic_type, lee_short_name, lic_budget_code, supplier,
                       contract, lic_number, gen_title, acct_date,
                       con_eff_date, lic_start, lic_end, am_co
                                                              --,LIC_AMORT_CODE
                       , lic_exh
                                --,LIC_SHOWING_INT
                       --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/25]
                       ,lic_exh_used
                       --,amo_exh
                       ,DECODE(am_co,'A',NULL,amo_exh) amo_exh
                                              --,LIC_SHOWING_LIC
                       --,paid_exh,
                       ,DECODE(am_co,'A',NULL,paid_exh) paid_exh
                       ,unpaid_exh
                                             --Africa free repeat-free runs
                       , (lic_exh - lic_exh_used) td_exh,
                       --(amo_exh - paid_exh) amo_exh_rem,
                       DECODE(am_co,'A',NULL,(amo_exh - paid_exh)) amo_exh_rem,
                       lic_markup_percent,
                       --SIT.R5 : SVOD Enhancements : End
                       con_fc
                             --,FEE
                       , con_aa
                               --,COST
                       , (con_fc - con_aa) close_markup
                                                       --,CLOSE
                                                       --***((con_fc -con_aa)* ex_rate) close_markup2,          --E_CLOSE
                                                       --(loc_fc - loc_aa) close_markup2,                 --E_CLOSE
                                                       /*
                                                       NOC :
                                                       Changes done to Show correct exchange rate and local currency invnetory
                                                       NEERAJ : KARIM : 13-12-2013
                                                       */
                       ,
                       (CASE
                           WHEN lic_start < v_go_live_date
                           AND lic_acct_date < v_go_live_date
                              THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                           WHEN lic_start >= v_go_live_date
                           AND lic_acct_date >= v_go_live_date
                              THEN ROUND ((loc_fc - loc_aa), 2)
                           WHEN TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') >=
                                       TO_CHAR (TO_DATE (lic_acct_date), 'YYYYMM')
                           AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                      TO_CHAR (TO_DATE (v_go_live_date), 'YYYYMM')
                              THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                           WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                              (SELECT yearmonth_char
                                                 FROM
                                                      /*subledger_data*/
                                                      x_mv_lib_reval_ex
                                                WHERE lis_lic_number = lic_number)
                                )
                              THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                           --ELSE ROUND ((loc_fc - loc_aa), 2)
                        ELSE DECODE (con_fc, 0, 0, ROUND ((loc_fc - loc_aa), 2))
                        END
                       ) close_markup2
                                      /*(CASE
                                      WHEN lic_start < v_go_live_date
                                      THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                                      ELSE ROUND ((loc_fc - loc_aa), 2)
                                      END
                                      ) close_markup2,*/
                       ,
                       lic_showing_first, pv_con_fc, pv_con_aa,
                       (pv_con_fc - pv_con_aa) closed_inv_pv,
                       ((con_fc - con_aa) + (pv_con_fc - pv_con_aa)
                       ) total_closed_lic
                                         --,((pv_con_fc - pv_con_aa) * ex_rate) closed_inv_pv2
                       ,
                       (pv_loc_fc - pv_loc_aa) closed_inv_pv2, ed_inv, ed_cos,
                       (ed_inv - ed_cos) ed_close
                                                 --,(((con_fc -con_aa)* ex_rate) + ((pv_con_fc - pv_con_aa) * ex_rate) + (ED_inv - ED_COS) ) total_closed_loc
                       ,
                       (  (loc_fc - loc_aa)
                        + (pv_loc_fc - pv_loc_aa)
                        + (ed_inv - ed_cos)
                       ) TOTAL_CLOSED_LOC
                       ,Free_Repeat													 --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                       ,LIC_PRICE         -- [2016-MAR-04] Ankur.Kasar[BR_15_001, BR_15_260 - Programme Library Valuation Report]
                       ,l_delete_month
                       ,i_include_zero
                       ,i_lic_budget_code
                       ,i_con_short_name
                  FROM (SELECT
                                 --    fc2.com_number
                                 fr.reg_code region, fc.com_number,
                                 ft.ter_cur_code, fl.lic_currency,
                                 x.com_name channel_comp, fl.lic_type,
                                 flee.lee_short_name, fl.lic_budget_code,
                                 SUBSTR (fc.com_short_name, 1, 8) supplier,
                                 fcon.con_short_name contract, fl.lic_number,
                                 fg.gen_title, fl.lic_acct_date,

                                 -- SUBSTR(gen_title,1,20) GEN_TITLE   ---Removed Substring for issue  IM110349
                                 TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                                 con_con_effective_date con_eff_date,
                                 TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                                 TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                                 fl.lic_markup_percent, fl.lic_rate,
                                 ROUND (xfsl.lsl_lee_price, 4) lic_price,
                                 fl.lic_amort_code am_co,
                                 DECODE (fl.lic_catchup_flag,
                                         'Y', NULL,
                                         fl.lic_showing_int
                                        ) lic_exh,

                                 --,    lic_showing_int    LIC_EXH
                                 pkg_fin_lib_valuation.td_not_paid
                                                      (lic_number,
                                                       i_period_date
                                                      ) lic_exh_used,
                                 fl.lic_showing_lic amo_exh,

                                 /* pkg_fin_lib_valuation.td_total -- passing lsl_number
                                 (lic_number,
                                 to_date (i_period_date),
                                 LSL_NUMBER
                                 ) TD_EXH,                */
                                 -- for lic_start < go_live_date get bud_rate
                                 /* pkg_fin_lib_valuation.ex_rate_lib_val
                                 (i_acc_prv_rate,
                                 lic_currency,
                                 TER_CUR_CODE,
                                 lic_number,
                                 lic_start,
                                 V_GO_LIVE_DATE,
                                 LSL_NUMBER
                                 ) EX_RATE, */
                                 pkg_fin_lib_valuation.ex_rate_lib_val
                                                         (i_acc_prv_rate,
                                                          lic_currency,
                                                          ter_cur_code
                                                         ) ex_rate,
                                 pkg_fin_lib_valuation.con_fc
                                                  (i_inc_markup,
                                                   lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  )
                                                   /*DECODE (i_inc_markup,'I',con_fc_i,con_fc_e)*/
                                 con_fc,
                                 pkg_fin_lib_valuation.con_aa
                                                  (i_inc_markup,
                                                   lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  )
                                                   /*DECODE (i_inc_markup,'I',con_aa_i,con_aa_e)*/
                                 con_aa,

                                 -- Pure Finance [new functions for local calculations]
                                 pkg_fin_lib_valuation.loc_fc
                                                  (i_inc_markup,
                                                   lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  )
                                                   /*DECODE (i_inc_markup,'I',nvl(loc_fc_i,loc_fc_e),loc_fc_e)*/
                                 loc_fc,
                                 pkg_fin_lib_valuation.loc_aa
                                                  (i_inc_markup,
                                                   lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  )
                                                   /*DECODE (i_inc_markup,'I',nvl(loc_aa_i,loc_aa_e),loc_aa_e)*/
                                 loc_aa,
                                 pkg_fin_lib_valuation.td_exh
                                                (lic_number,
                                                 TO_DATE (i_period_date),
                                                 lic_start,
                                                 v_go_live_date
                                                ) paid_exh,        -- amo exh used
                                 pkg_fin_lib_valuation.td_unpaid
                                               (lic_number,
                                                TO_DATE (i_period_date)
                                               --,LSL_NUMBER
                                               ) unpaid_exh,

                                 -- Africa free repeat-free runs
                                 --  new functions for ED PV inv
                                 pkg_fin_lib_valuation.con_fc_fin
                                               (       -- i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date),
                                                lsl_number
                                               ) pv_con_fc,

                                 --initial pv adj till to_date
                                 pkg_fin_lib_valuation.con_aa_fin
                                               (       -- i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date),
                                                lsl_number
                                               ) pv_con_aa,

                                 --cos of PV till to_date
                                 --  new functions for ED PV  local inventory
                                 pkg_fin_lib_valuation.loc_fc_fin
                                               (       -- i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date),
                                                lsl_number
                                               ) pv_loc_fc,

                                 --initial local pv adj till to_date
                                 pkg_fin_lib_valuation.loc_aa_fin
                                               (       -- i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date),
                                                lsl_number
                                               ) pv_loc_aa,

                                 --local cos of PV till to_date
                                 --(pv_con_fc -  pv_con_aa) clos_inv_pv, -- closed inv PV
                                 --' ' lic_curre_total_closed,
                                 pkg_fin_lib_valuation.ed_inv
                                                  (lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  ) ed_inv,
                                 pkg_fin_lib_valuation.ed_cos
                                                  (lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  ) ed_cos,
                                 FL.LIC_SHOWING_FIRST,
                                 X.COM_NAME COM_NAME,
                                 (SELECT count(1) from fid_schedule fsh where fsh.sch_lic_number=fl.lic_number and fsh.sch_type='F') as Free_Repeat    --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                            FROM fid_general fg,
                                 fid_company fc,
                                 fid_contract fcon,
                                 fid_licensee flee,
                                 --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
                                 x_fin_lic_sec_lee xfsl,
                                 --Dev2: Pure Finance :END
                                 fid_license fl,
                                 fid_territory ft,
                                 fid_region fr,                 -- added for split
                                 (SELECT DISTINCT fcom.com_number, fcom.com_name,
                                                  fcom.com_ter_code
                                             FROM fid_company fcom
                                            WHERE fcom.com_short_name LIKE
                                                                      i_chnal_comp
                                              AND fcom.com_type IN ('CC', 'BC')) x
                           WHERE ft.ter_code = x.com_ter_code
                             --And fc.com_number=x.com_number
                           --  and rownum <101
                             AND flee.lee_cha_com_number = x.com_number
                             AND fl.lic_type LIKE i_lic_type
                             AND flee.lee_short_name LIKE i_lee_short_name
                             AND fl.lic_budget_code LIKE i_lic_budget_code
                             AND fcon.con_short_name LIKE i_con_short_name
                             AND fcon.con_number = fl.lic_con_number
                             AND fc.com_number = fcon.con_com_number   -- supplier
                             AND fg.gen_refno = fl.lic_gen_refno
                             --Dev2: Pure Finance :Start:[ANUJASHINDE]_[2013/3/19]
                             --LIC_LEE_NUMBER = LEE_NUMBER and
                             AND fl.lic_number = xfsl.lsl_lic_number
                             AND flee.lee_number = xfsl.lsl_lee_number
                             --AND lee_split_region = reg_id
                             AND fr.reg_id(+) = flee.lee_split_region
                             AND UPPER (fr.reg_code) LIKE UPPER (i_region_code)
                             AND fc.com_short_name LIKE i_supp_short_name
                             --for report type "For a Period" it should take licenses with acc_date between given date range
                             AND DECODE (i_report_type,
                                         'P', TO_CHAR (fl.lic_acct_date, 'YYYYMM'),
                                         NVL (TO_CHAR (i_to_date, 'YYYYMM'), 0)
                                        ) BETWEEN NVL (TO_CHAR (i_from_date,
                                                                'YYYYMM'
                                                               ),
                                                       0
                                                      )
                                              AND NVL (TO_CHAR (i_to_date,
                                                                'YYYYMM'
                                                               ),
                                                       0
                                                      )
                             --Dev2: Pure Finance :END
                             --Dev2: Pure Finance :Start:[Non-Costed Fillers][ANUJASHINDE]_[2013/3/19]
                             --[Added to exclude(fillers) licenses with status F]
                             --Dev.R3: Placeholder: Start:[Devashish Raverkar]_[2014/03/28]
                             AND UPPER (fl.lic_status) NOT IN ('F', 'T')

    --Dev.R3: Placeholder: End:
    --Dev2: Pure Finance[Non Costed Fillers] :End
                             ---Start[01-Sep-2015][Jawahar.Garg]commented the condition to show records with zero when include zero is selected
                             /*AND (EXISTS (
                                     SELECT   / *+ PARALLEL(flsl,2)* /
                                              'X', SUM (cf_m_ca_p_cadj)
                                         FROM x_mv_lib_val_sum flsl
                                        WHERE lis_yyyymm_num <=
                                                 TO_NUMBER
                                                          (TO_CHAR (i_period_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )
                                          AND flsl.lis_lic_number = fl.lic_number
                                          AND flsl.lis_lsl_number =
                                                                   xfsl.lsl_number
                                     GROUP BY 'X'
                                       HAVING ROUND (SUM (cf_m_ca_p_cadj), 0) != 0)
                                 )
                   */
                   ---END[01-Sep-2015][Jawahar.Garg]commented the condition to show records with zero when include zero is selected

                        /*OR (lic_acct_date <= LAST_DAY (i_period_date))
                        and LIC_END > LAST_DAY (i_period_date)*/
                        ORDER BY lic_currency,
                                 lic_type,
                                 lee_short_name,
                                 lic_budget_code,
                                 com_short_name,
                                 con_short_name ASC,
                                 lic_number ASC,
                                 gen_title);
                                  COMMIT;

                         OPEN o_lib_rep FOR    --REQUESTED BY- BR_15_006 - FINCR 30.(Ankur Kasar)
                                SELECT
                                REGION region,
                                com_name,
                                LIC_CURRENCY lic_currency,
                                PERIOD period,
                                TER_CUR_CODE ter_cur_code,
                                NVL(EX_RATE,0) ex_rate,
                                LIC_TYPE lic_type,
                                LEE_SHORT_NAME lee_short_name,
                                LIC_BUDGET_CODE lic_budget_code,
                                SUPPLIER supplier,
                                CONTRACT contract,
                                LIC_NUMBER lic_number,
                                GEN_TITLE gen_title,
                                ACCT_DATE,
                                LIC_START lic_start,
                                LIC_END lic_end,
                                AM_CO,
                                NVL(LIC_EXH,0) lic_exh,
                                NVL(AMO_EXH,0) amo_exh,
                                NVL(PAID_EXH,0) paid_exh,
                                NVL(UNPAID_EXH,0) unpaid_exh,
                                NVL(CON_FC,0) con_fc,
                                NVL(CLOSE_MARKUP,0) close_markup,
                                NVL(CLOSE_MARKUP2,0) close_markup2,
                                NVL(CON_AA,0) con_aa,
                                    LIC_SHOWING_FIRST lic_showing_first,
                                NVL(TD_EXH,0) td_exh,
                                NVL(LIC_MARKUP_PERCENT,0) lic_markup_percent,
                                NVL(LIC_PRICE,0) LIC_PRICE,
                                NVL(PV_CON_FC,0) pv_con_fc,
                                NVL(PV_CON_AA,0) pv_con_aa,
                                NVL(CLOSED_INV_PV,0) closed_inv_pv,
                                NVL(TOTAL_CLOSED_LIC,0) total_closed_lic,
                                NVL(CLOSED_INV_PV2,0) closed_inv_pv2,
                                NVL(ED_INV,0) ed_inv,
                                NVL(ED_COS,0) ed_cos,
                                NVL(ED_CLOSE,0) ed_close,
                                NVL(TOTAL_CLOSED_LOC,0) TOTAL_CLOSED_LOC,
                                NVL(AMO_EXH_REM,0) amo_exh_rem,
                                    CON_EFF_DATE con_eff_date,
                                NVL(LIC_EXH_USED,0) lic_exh_used,
                                NVL(FREE_REPEAT,0) Free_Repeat
                                FROM X_SUMMARY_PROG_LIB_VAL;

              ELSIF(upper(i_type) = 'SUMMARY')
              THEN -- REQUESTED BY- BR_15_006 - FINCR 30.(Ankur Kasar)

              OPEN o_lib_rep FOR
                    select
                    REGION region,
                    COM_NAME com_name,
                    LIC_CURRENCY lic_currency,
                    PERIOD period,
                    TER_CUR_CODE ter_cur_code,
                    LIC_TYPE lic_type,
                    LEE_SHORT_NAME lee_short_name,
                    LIC_BUDGET_CODE lic_budget_code,
                    I_BUDGET_CODE  BUDGET_CODE_IP,
                    I_CONTRACT  CONTRACT_IP,
                    NVL(sum(CON_FC),0) con_fc,
                    NVL(sum(CLOSE_MARKUP),0) close_markup,
                    NVL(sum(CLOSE_MARKUP2),0) close_markup2,
                    NVL(sum(CON_AA),0) con_aa,
                    NVL(sum(PV_CON_FC),0) pv_con_fc,
                    NVL(sum(PV_CON_AA),0) pv_con_aa,
                    NVL(sum(CLOSED_INV_PV),0) closed_inv_pv,
                    NVL(sum(TOTAL_CLOSED_LIC),0) total_closed_lic,
                    NVL(sum(CLOSED_INV_PV2),0) closed_inv_pv2,
                    NVL(sum(ED_INV),0) ed_inv,
                    NVL(sum(ED_COS),0) ed_cos,
                    NVL(sum(ED_CLOSE),0) ed_close,
                    NVL(sum(TOTAL_CLOSED_LOC),0) TOTAL_CLOSED_LOC
               FROM X_SUMMARY_PROG_LIB_VAL
            group by
                    com_name,
		    region,
		    lic_currency,
		    lic_type,
		    ter_cur_code,
                    lee_short_name,
		    lic_budget_code,
		    I_BUDGET_CODE,
		    I_CONTRACT,
		    period;

              ELSE
                OPEN o_lib_rep FOR
              /*WITH subledger_data AS
              (
              SELECT lis_lic_number
              ,MIN(lis_YYYYMM_NUM) YEARMONTH
              FROM   x_mv_subledger_data
              WHERE  (LIS_CON_FC_EMU > 0 OR lis_loc_forecast > 0)
              --AND    lis_lic_number = lic_number
              AND   lis_YYYYMM_NUM >= TO_CHAR(TO_DATE(v_go_live_date),'YYYYMM')
              GROUP BY lis_lic_number
              )*/

                SELECT
                    --Dev2: Pure Finance :Start:[FIN 7]_[ANUJASHINDE]_[2013/3/19]
                       region
                             --Dev2: Pure Finance :End
                       , com_name,
                       lic_currency,
                       TO_CHAR (i_period_date, 'YYYY/MM/DD HH:MI:SS') period,
                       ter_cur_code
                                   /*
                                   NOC :
                                   Changes done to Show correct exchange rate and local currency invnetory
                                   NEERAJ : KARIM : 13-12-2013
                                   */
                                   /*(CASE
                                   WHEN lic_start < v_go_live_date
                                   THEN ex_rate
                                   ELSE ROUND (DECODE (NVL (con_fc, 0),
                                   0, lic_rate,
                                   (NVL (loc_fc, 0) / NVL (con_fc, 0)
                                   )
                                   ),
                                   4
                                   )
                                   END
                                   ) ex_rate,*/
                       ,
                       (CASE
                           WHEN lic_start < v_go_live_date
                           AND lic_acct_date < v_go_live_date
                              THEN ex_rate
                           WHEN lic_start >= v_go_live_date
                           AND lic_acct_date >= v_go_live_date
                              THEN ROUND (DECODE (NVL (con_fc, 0),
                                                  0, lic_rate,
                                                  (  NVL (loc_fc, 0)
                                                   / NVL (con_fc, 0)
                                                  )
                                                 ),
                                          5
                                         )
                           WHEN TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') >=
                                       TO_CHAR (TO_DATE (lic_acct_date), 'YYYYMM')
                           AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                      TO_CHAR (TO_DATE (v_go_live_date), 'YYYYMM')
                              THEN ex_rate
                           WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                              (SELECT yearmonth_char
                                                 FROM
                                                      /*subledger_data*/
                                                      x_mv_lib_reval_ex
                                                WHERE lis_lic_number = lic_number)
                                )
                              THEN ex_rate
                           ELSE ROUND (DECODE (NVL (con_fc, 0),
                                               0, NVL (lic_rate, ex_rate),
                                               (NVL (loc_fc, 0) / NVL (con_fc, 0)
                                               )
                                              ),
                                       5
                                      )
                        END
                       ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                       lic_type, lee_short_name, lic_budget_code, supplier,
                       contract, lic_number, gen_title, acct_date,
                       con_eff_date, lic_start, lic_end, am_co
                                                              --,LIC_AMORT_CODE
                       , lic_exh
                                --,LIC_SHOWING_INT
                       --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/25]
                       ,lic_exh_used
                       --,amo_exh
                       ,DECODE(am_co,'A',NULL,amo_exh) amo_exh
                                              --,LIC_SHOWING_LIC
                       --,paid_exh,
                       ,DECODE(am_co,'A',NULL,paid_exh) paid_exh
                       ,unpaid_exh
                                             --Africa free repeat-free runs
                       , (lic_exh - lic_exh_used) td_exh,
                       --(amo_exh - paid_exh) amo_exh_rem,
                       DECODE(am_co,'A',NULL,(amo_exh - paid_exh)) amo_exh_rem,
                       lic_markup_percent,
                       --SIT.R5 : SVOD Enhancements : End
                       con_fc
                             --,FEE
                       , con_aa
                               --,COST
                       , (con_fc - con_aa) close_markup
                                                       --,CLOSE
                                                       --***((con_fc -con_aa)* ex_rate) close_markup2,          --E_CLOSE
                                                       --(loc_fc - loc_aa) close_markup2,                 --E_CLOSE
                                                       /*
                                                       NOC :
                                                       Changes done to Show correct exchange rate and local currency invnetory
                                                       NEERAJ : KARIM : 13-12-2013
                                                       */
                       ,
                       (CASE
                           WHEN lic_start < v_go_live_date
                           AND lic_acct_date < v_go_live_date
                              THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                           WHEN lic_start >= v_go_live_date
                           AND lic_acct_date >= v_go_live_date
                              THEN ROUND ((loc_fc - loc_aa), 2)
                           WHEN TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') >=
                                       TO_CHAR (TO_DATE (lic_acct_date), 'YYYYMM')
                           AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                      TO_CHAR (TO_DATE (v_go_live_date), 'YYYYMM')
                              THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                           WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                              (SELECT yearmonth_char
                                                 FROM
                                                      /*subledger_data*/
                                                      x_mv_lib_reval_ex
                                                WHERE lis_lic_number = lic_number)
                                )
                              THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                           --ELSE ROUND ((loc_fc - loc_aa), 2)
                        ELSE DECODE (con_fc, 0, 0, ROUND ((loc_fc - loc_aa), 2))
                        END
                       ) close_markup2
                                      /*(CASE
                                      WHEN lic_start < v_go_live_date
                                      THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                                      ELSE ROUND ((loc_fc - loc_aa), 2)
                                      END
                                      ) close_markup2,*/
                       ,
                       lic_showing_first, pv_con_fc, pv_con_aa,
                       (pv_con_fc - pv_con_aa) closed_inv_pv,
                       ((con_fc - con_aa) + (pv_con_fc - pv_con_aa)
                       ) total_closed_lic
                                         --,((pv_con_fc - pv_con_aa) * ex_rate) closed_inv_pv2
                       ,
                       (pv_loc_fc - pv_loc_aa) closed_inv_pv2, ed_inv, ed_cos,
                       (ed_inv - ed_cos) ed_close
                                                 --,(((con_fc -con_aa)* ex_rate) + ((pv_con_fc - pv_con_aa) * ex_rate) + (ED_inv - ED_COS) ) total_closed_loc
                       ,
                       (  (loc_fc - loc_aa)
                        + (pv_loc_fc - pv_loc_aa)
                        + (ed_inv - ed_cos)
                       ) TOTAL_CLOSED_LOC
                       ,Free_Repeat													 --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                       ,LIC_PRICE         -- [2016-MAR-04] Ankur.Kasar[BR_15_001, BR_15_260 - Programme Library Valuation Report]
                  FROM (SELECT
                                 --    fc2.com_number
                                 fr.reg_code region, fc.com_number,
                                 ft.ter_cur_code, fl.lic_currency,
                                 x.com_name channel_comp, fl.lic_type,
                                 flee.lee_short_name, fl.lic_budget_code,
                                 SUBSTR (fc.com_short_name, 1, 8) supplier,
                                 fcon.con_short_name contract, fl.lic_number,
                                 fg.gen_title, fl.lic_acct_date,

                                 -- SUBSTR(gen_title,1,20) GEN_TITLE   ---Removed Substring for issue  IM110349
                                 TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                                 con_con_effective_date con_eff_date,
                                 TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                                 TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                                 fl.lic_markup_percent, fl.lic_rate,
                                 ROUND (xfsl.lsl_lee_price, 4) lic_price,
                                 fl.lic_amort_code am_co,
                                 DECODE (fl.lic_catchup_flag,
                                         'Y', NULL,
                                         fl.lic_showing_int
                                        ) lic_exh,

                                 --,    lic_showing_int    LIC_EXH
                                 pkg_fin_lib_valuation.td_not_paid
                                                      (lic_number,
                                                       i_period_date
                                                      ) lic_exh_used,
                                 fl.lic_showing_lic amo_exh,

                                 /* pkg_fin_lib_valuation.td_total -- passing lsl_number
                                 (lic_number,
                                 to_date (i_period_date),
                                 LSL_NUMBER
                                 ) TD_EXH,                */
                                 -- for lic_start < go_live_date get bud_rate
                                 /* pkg_fin_lib_valuation.ex_rate_lib_val
                                 (i_acc_prv_rate,
                                 lic_currency,
                                 TER_CUR_CODE,
                                 lic_number,
                                 lic_start,
                                 V_GO_LIVE_DATE,
                                 LSL_NUMBER
                                 ) EX_RATE, */
                                 pkg_fin_lib_valuation.ex_rate_lib_val
                                                         (i_acc_prv_rate,
                                                          lic_currency,
                                                          ter_cur_code
                                                         ) ex_rate,
                                 pkg_fin_lib_valuation.con_fc
                                                  (i_inc_markup,
                                                   lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  )
                                                   /*DECODE (i_inc_markup,'I',con_fc_i,con_fc_e)*/
                                 con_fc,
                                 pkg_fin_lib_valuation.con_aa
                                                  (i_inc_markup,
                                                   lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  )
                                                   /*DECODE (i_inc_markup,'I',con_aa_i,con_aa_e)*/
                                 con_aa,

                                 -- Pure Finance [new functions for local calculations]
                                 pkg_fin_lib_valuation.loc_fc
                                                  (i_inc_markup,
                                                   lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  )
                                                   /*DECODE (i_inc_markup,'I',nvl(loc_fc_i,loc_fc_e),loc_fc_e)*/
                                 loc_fc,
                                 pkg_fin_lib_valuation.loc_aa
                                                  (i_inc_markup,
                                                   lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  )
                                                   /*DECODE (i_inc_markup,'I',nvl(loc_aa_i,loc_aa_e),loc_aa_e)*/
                                 loc_aa,
                                 pkg_fin_lib_valuation.td_exh
                                                (lic_number,
                                                 TO_DATE (i_period_date),
                                                 lic_start,
                                                 v_go_live_date
                                                ) paid_exh,        -- amo exh used
                                 pkg_fin_lib_valuation.td_unpaid
                                               (lic_number,
                                                TO_DATE (i_period_date)
                                               --,LSL_NUMBER
                                               ) unpaid_exh,

                                 -- Africa free repeat-free runs
                                 --  new functions for ED PV inv
                                 pkg_fin_lib_valuation.con_fc_fin
                                               (       -- i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date),
                                                lsl_number
                                               ) pv_con_fc,

                                 --initial pv adj till to_date
                                 pkg_fin_lib_valuation.con_aa_fin
                                               (       -- i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date),
                                                lsl_number
                                               ) pv_con_aa,

                                 --cos of PV till to_date
                                 --  new functions for ED PV  local inventory
                                 pkg_fin_lib_valuation.loc_fc_fin
                                               (       -- i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date),
                                                lsl_number
                                               ) pv_loc_fc,

                                 --initial local pv adj till to_date
                                 pkg_fin_lib_valuation.loc_aa_fin
                                               (       -- i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date),
                                                lsl_number
                                               ) pv_loc_aa,

                                 --local cos of PV till to_date
                                 --(pv_con_fc -  pv_con_aa) clos_inv_pv, -- closed inv PV
                                 --' ' lic_curre_total_closed,
                                 pkg_fin_lib_valuation.ed_inv
                                                  (lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  ) ed_inv,
                                 pkg_fin_lib_valuation.ed_cos
                                                  (lic_number,
                                                   TO_DATE (i_period_date),
                                                   lsl_number
                                                  ) ed_cos,
                                 FL.LIC_SHOWING_FIRST,
                                 X.COM_NAME COM_NAME,
                                 (SELECT count(1) from fid_schedule fsh where fsh.sch_lic_number=fl.lic_number and fsh.sch_type='F') as Free_Repeat    --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                            FROM fid_general fg,
                                 fid_company fc,
                                 fid_contract fcon,
                                 fid_licensee flee,
                                 --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
                                 x_fin_lic_sec_lee xfsl,
                                 --Dev2: Pure Finance :END
                                 fid_license fl,
                                 fid_territory ft,
                                 fid_region fr,                 -- added for split
                                 (SELECT DISTINCT fcom.com_number, fcom.com_name,
                                                  fcom.com_ter_code
                                             FROM fid_company fcom
                                            WHERE fcom.com_short_name LIKE
                                                                      i_chnal_comp
                                              AND fcom.com_type IN ('CC', 'BC')) x
                           WHERE ft.ter_code = x.com_ter_code
                             --And fc.com_number=x.com_number
                             AND flee.lee_cha_com_number = x.com_number
                           --  AND ROWNUM <101
                             AND fl.lic_type LIKE i_lic_type
                             AND flee.lee_short_name LIKE i_lee_short_name
                             AND fl.lic_budget_code LIKE i_lic_budget_code
                             AND fcon.con_short_name LIKE i_con_short_name
                             AND fcon.con_number = fl.lic_con_number
                             AND fc.com_number = fcon.con_com_number   -- supplier
                             AND fg.gen_refno = fl.lic_gen_refno
                             --Dev2: Pure Finance :Start:[ANUJASHINDE]_[2013/3/19]
                             --LIC_LEE_NUMBER = LEE_NUMBER and
                             AND fl.lic_number = xfsl.lsl_lic_number
                             AND flee.lee_number = xfsl.lsl_lee_number
                             --AND lee_split_region = reg_id
                             AND fr.reg_id(+) = flee.lee_split_region
                             AND UPPER (fr.reg_code) LIKE UPPER (i_region_code)
                             AND fc.com_short_name LIKE i_supp_short_name
                             --for report type "For a Period" it should take licenses with acc_date between given date range
                             AND DECODE (i_report_type,
                                         'P', TO_CHAR (fl.lic_acct_date, 'YYYYMM'),
                                         NVL (TO_CHAR (i_to_date, 'YYYYMM'), 0)
                                        ) BETWEEN NVL (TO_CHAR (i_from_date,
                                                                'YYYYMM'
                                                               ),
                                                       0
                                                      )
                                              AND NVL (TO_CHAR (i_to_date,
                                                                'YYYYMM'
                                                               ),
                                                       0
                                                      )
                             --Dev2: Pure Finance :END
                             --Dev2: Pure Finance :Start:[Non-Costed Fillers][ANUJASHINDE]_[2013/3/19]
                             --[Added to exclude(fillers) licenses with status F]
                             --Dev.R3: Placeholder: Start:[Devashish Raverkar]_[2014/03/28]
                             AND UPPER (fl.lic_status) NOT IN ('F', 'T')
    --Dev.R3: Placeholder: End:
    --Dev2: Pure Finance[Non Costed Fillers] :End
                             ---Start[01-Sep-2015][Jawahar.Garg]commented the condition to show records with zero when include zero is selected
                             /*AND (EXISTS (
                                     SELECT   / *+ PARALLEL(flsl,2)* /
                                              'X', SUM (cf_m_ca_p_cadj)
                                         FROM x_mv_lib_val_sum flsl
                                        WHERE lis_yyyymm_num <=
                                                 TO_NUMBER
                                                          (TO_CHAR (i_period_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )
                                          AND flsl.lis_lic_number = fl.lic_number
                                          AND flsl.lis_lsl_number =
                                                                   xfsl.lsl_number
                                     GROUP BY 'X'
                                       HAVING ROUND (SUM (cf_m_ca_p_cadj), 0) != 0)
                                 )
                   */
                   ---END[01-Sep-2015][Jawahar.Garg]commented the condition to show records with zero when include zero is selected

                        /*OR (lic_acct_date <= LAST_DAY (i_period_date))
                        and LIC_END > LAST_DAY (i_period_date)*/
                        ORDER BY lic_currency,
                                 lic_type,
                                 lee_short_name,
                                 lic_budget_code,
                                 com_short_name,
                                 con_short_name ASC,
                                 lic_number ASC,
                                 gen_title);
          END IF;

      ELSIF i_include_zero = 'N'
      THEN
           if((upper(i_type) = 'DETAILS')AND(i_summary_flag = 'Y'))    -- REQUESTED BY- BR_15_006 - FINCR 30.(Ankur Kasar)
            THEN

        l_trc_query := 'TRUNCATE TABLE X_SUMMARY_PROG_LIB_VAL';

        EXECUTE IMMEDIATE l_trc_query;

                   INSERT INTO X_SUMMARY_PROG_LIB_VAL
              (
                  REGION            ,
                  COM_NAME          ,
                  LIC_CURRENCY      ,
                  PERIOD            ,
                  TER_CUR_CODE      ,
                  EX_RATE           ,
                  LIC_TYPE          ,
                  LEE_SHORT_NAME    ,
                  LIC_BUDGET_CODE   ,
                  SUPPLIER          ,
                  CONTRACT          ,
                  LIC_NUMBER        ,
                  GEN_TITLE         ,
                  ACCT_DATE         ,
                  CON_EFF_DATE      ,
                  LIC_START         ,
                  LIC_END           ,
                  AM_CO             ,
                  LIC_EXH           ,
                  LIC_EXH_USED      ,
                  AMO_EXH           ,
                  PAID_EXH          ,
                  UNPAID_EXH        ,
                  TD_EXH            ,
                  AMO_EXH_REM       ,
                  LIC_MARKUP_PERCENT,
                  CON_FC            ,
                  CON_AA            ,
                  CLOSE_MARKUP      ,
                  CLOSE_MARKUP2     ,
                  LIC_SHOWING_FIRST ,
                  PV_CON_FC         ,
                  PV_CON_AA         ,
                  CLOSED_INV_PV     ,
                  TOTAL_CLOSED_LIC  ,
                  CLOSED_INV_PV2    ,
                  ED_INV            ,
                  ED_COS            ,
                  ED_CLOSE          ,
                  TOTAL_CLOSED_LOC  ,
                  FREE_REPEAT       ,
                  LIC_PRICE         ,
                  I_MON_YEAR        ,
                  INCLUDE_ZERO      ,
                  I_BUDGET_CODE     ,
                  I_CONTRACT
              )
          --    OPEN o_lib_rep FOR
                     SELECT region, com_name, lic_currency,
                           TO_CHAR (i_period_date, 'YYYY/MM/DD HH:MI:SS') period,
                           ter_cur_code,

                           /*
                           NOC :
                           Changes done to Show correct exchange rate and local currency invnetory
                           NEERAJ : KARIM : 13-12-2013
                           */
                           /*(CASE WHEN lic_start < v_go_live_date
                           THEN ex_rate
                           ELSE ROUND(DECODE(NVL(con_fc, 0),0,lic_rate,(NVL(loc_fc,0)/NVL(con_fc, 0))),4)
                           END
                           ) ex_rate,*/
                           (CASE
                               WHEN lic_start < v_go_live_date
                               AND lic_acct_date < v_go_live_date
                                  THEN ex_rate
                               WHEN lic_start >= v_go_live_date
                               AND lic_acct_date >= v_go_live_date
                                  THEN ROUND (DECODE (NVL (con_fc, 0),
                                                      0, lic_rate,
                                                      (  NVL (loc_fc, 0)
                                                       / NVL (con_fc, 0)
                                                      )
                                                     ),
                                              5
                                             )
                               WHEN TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') >=
                                           TO_CHAR (TO_DATE (lic_acct_date), 'YYYYMM')
                               AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                          TO_CHAR (TO_DATE (v_go_live_date), 'YYYYMM')
                                  THEN ex_rate
                               WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                                  (SELECT yearmonth_char
                                                     FROM
                                                          /*subledger_data*/
                                                          x_mv_lib_reval_ex
                                                    WHERE lis_lic_number = lic_number)
                                    )
                                  THEN ex_rate
                               ELSE ROUND (DECODE (NVL (con_fc, 0),
                                                   0, NVL (lic_rate, ex_rate),
                                                   (NVL (loc_fc, 0) / NVL (con_fc, 0)
                                                   )
                                                  ),
                                           5
                                          )
                            END
                           ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                           lic_type, lee_short_name, lic_budget_code, supplier,
                           contract, lic_number, gen_title, acct_date,
                           con_eff_date, lic_start, lic_end, am_co
                                                                  --,LIC_AMORT_CODE
                           , lic_exh
                                    --,LIC_SHOWING_INT
                           , lic_exh_used
                           --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/25]
                           --,amo_exh
                                                  --,LIC_SHOWING_LIC
                           --,(amo_exh - paid_exh) amo_exh_rem, paid_exh,
                           ,DECODE(am_co,'A',NULL,amo_exh) amo_exh
                           ,DECODE(am_co,'A',NULL,(amo_exh - paid_exh)) amo_exh_rem
                           ,DECODE(am_co,'A',NULL,paid_exh) paid_exh,
                           --SIT.R5 : SVOD Enhancements : End
                           unpaid_exh,
                           (lic_exh - lic_exh_used) td_exh, lic_markup_percent,
                           con_fc
                                 --,FEE
                           , con_aa
                                   --,COST
                                   --,close_markup
                                   --,CLOSE
                                   --,close_markup2
                                   --,E_CLOSE
                           , (con_fc - con_aa) close_markup
                                                           --,CLOSE
                                                           --,((con_fc -con_aa)* ex_rate) close_markup2
                                                           --,E_CLOSE
                                                           --,(loc_fc - loc_aa) close_markup2
                                                           --,E_CLOSE
                                                           /*
                                                           NOC :
                                                           Changes done to Show correct exchange rate and local currency invnetory
                                                           NEERAJ : KARIM : 13-12-2013
                                                           */
                           ,
                           (CASE
                               WHEN lic_start < v_go_live_date
                               AND lic_acct_date < v_go_live_date
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               WHEN lic_start >= v_go_live_date
                               AND lic_acct_date >= v_go_live_date
                                  THEN ROUND ((loc_fc - loc_aa), 2)
                               WHEN TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') >=
                                           TO_CHAR (TO_DATE (lic_acct_date), 'YYYYMM')
                               AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                          TO_CHAR (TO_DATE (v_go_live_date), 'YYYYMM')
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                                  (SELECT yearmonth_char
                                                     FROM

                                                          x_mv_lib_reval_ex
                                                    WHERE lis_lic_number = lic_number)
                                    )
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               --ELSE ROUND ((loc_fc - loc_aa), 2)
                            ELSE DECODE (con_fc, 0, 0, ROUND ((loc_fc - loc_aa), 2))
                            END
                           ) close_markup2
                                          /*,(CASE
                                          WHEN lic_start < v_go_live_date
                                          THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                                          ELSE ROUND ((loc_fc - loc_aa), 2)
                                          END
                                          ) close_markup2,*/
                           ,
                           lic_showing_first, pv_con_fc, pv_con_aa,
                           (pv_con_fc - pv_con_aa) closed_inv_pv,
                           ((con_fc - con_aa) + (pv_con_fc - pv_con_aa)
                           ) total_closed_lic
                                             --,((pv_con_fc - pv_con_aa) * ex_rate) closed_inv_pv2
                           ,
                           (pv_loc_fc - pv_loc_aa) closed_inv_pv2, ed_inv, ed_cos,
                           (ed_inv - ed_cos) ed_close
                                                     --,(((con_fc -con_aa)* ex_rate) + ((pv_con_fc - pv_con_aa) * ex_rate) + (ED_inv - ED_COS) ) total_closed_loc
                           ,
                           (  (loc_fc - loc_aa)
                            + (pv_loc_fc - pv_loc_aa)
                            + (ed_inv - ed_cos)
                           ) TOTAL_CLOSED_LOC
                           ,Free_Repeat							 --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                           ,LIC_PRICE                --[2016-MAR-04] Ankur.Kasar[BR_15_001, BR_15_260 - Programme Library Valuation Report]
                           ,l_delete_month
                           ,i_include_zero
                           ,i_lic_budget_code
                           ,i_con_short_name
                      FROM (SELECT
                                     --    fc2.com_number
                                     fc.com_number, ft.ter_cur_code, fl.lic_currency,
                                     x.com_name channel_comp, fl.lic_type,
                                     flee.lee_short_name, fl.lic_budget_code,
                                     SUBSTR (fc.com_short_name, 1, 8) supplier,
                                     fcon.con_short_name contract, fl.lic_number,
                                     fg.gen_title,

                                     --    SUBSTR(gen_title,1,20) GEN_TITLE   ---Removed Substring for issue  IM110349
                                     TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                                     con_con_effective_date con_eff_date,
                                     ROUND (xfsl.lsl_lee_price, 4) lic_price,
                                     TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                                     TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                                     fl.lic_amort_code am_co,
                                     DECODE (fl.lic_catchup_flag,
                                             'Y', NULL,
                                             fl.lic_showing_int
                                            ) lic_exh,
                                     pkg_fin_lib_valuation.td_not_paid
                                                          (lic_number,
                                                           i_period_date
                                                          ) lic_exh_used,
                                     fl.lic_showing_lic amo_exh,
                                     fl.lic_markup_percent, fl.lic_rate,
                                     fl.lic_acct_date,

                                     /* pkg_fin_lib_valuation.td_total -- passing lsl_number
                                     (lic_number,
                                     to_date (i_period_date),
                                     LSL_NUMBER
                                     ) td_exh ,*/
                                     /* pkg_fin_lib_valuation.ex_rate_lib_val
                                     (i_acc_prv_rate,
                                     lic_currency,
                                     TER_CUR_CODE,
                                     lic_number,
                                     lic_start,
                                     V_GO_LIVE_DATE,
                                     LSL_NUMBER
                                     ) EX_RATE, */
                                     pkg_fin_lib_valuation.ex_rate_lib_val
                                                             (i_acc_prv_rate,
                                                              lic_currency,
                                                              ter_cur_code
                                                             ) ex_rate,
                                     pkg_fin_lib_valuation.con_fc
                                                      (i_inc_markup,
                                                       lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      )
                                                       /*DECODE (i_inc_markup,'I',con_fc_i,con_fc_e)*/
                                     con_fc,
                                     pkg_fin_lib_valuation.con_aa
                                                      (i_inc_markup,
                                                       lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      )
                                                       /*DECODE (i_inc_markup,'I',con_aa_i,con_aa_e)*/
                                     con_aa,

                                     -- Pure Finance [new functions for local calculations]
                                     pkg_fin_lib_valuation.loc_fc            --
                                                      (i_inc_markup,
                                                       lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      )
                                                       /*DECODE (i_inc_markup,'I',nvl(loc_fc_i,loc_fc_e),loc_fc_e)*/
                                     loc_fc,
                                     pkg_fin_lib_valuation.loc_aa            --
                                                      (i_inc_markup,
                                                       lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      )
                                                       /*DECODE (i_inc_markup,'I',nvl(loc_aa_i,loc_aa_e),loc_aa_e)*/
                                     loc_aa,
                                     pkg_fin_lib_valuation.td_exh          --
                                                    (lic_number,
                                                     TO_DATE (i_period_date),
                                                     lic_start,
                                                     v_go_live_date
                                                    ) paid_exh,
                                     pkg_fin_lib_valuation.td_unpaid     --
                                                   (lic_number,
                                                    TO_DATE (i_period_date)
                                                   --,LSL_NUMBER
                                                   ) unpaid_exh,

                                     --  new functions for ED PV inv
                                     pkg_fin_lib_valuation.con_fc_fin
                                                   (       -- i_inc_markup,
                                                    lic_number,
                                                    TO_DATE (i_period_date),
                                                    lsl_number
                                                   ) pv_con_fc,

                                     --initial pv adj till to_date
                                     pkg_fin_lib_valuation.con_aa_fin
                                                   (       -- i_inc_markup,
                                                    lic_number,
                                                    TO_DATE (i_period_date),
                                                    lsl_number
                                                   ) pv_con_aa,

                                     --cos of PV till to_date
                                     --  new functions for ED PV  local inventory
                                     pkg_fin_lib_valuation.loc_fc_fin
                                                   (       -- i_inc_markup,
                                                    lic_number,
                                                    TO_DATE (i_period_date),
                                                    lsl_number
                                                   ) pv_loc_fc,

                                     --initial local pv adj till to_date
                                     pkg_fin_lib_valuation.loc_aa_fin
                                                   (       -- i_inc_markup,
                                                    lic_number,
                                                    TO_DATE (i_period_date),
                                                    lsl_number
                                                   ) pv_loc_aa,

                                     --local cos of PV till to_date
                                     --(pv_con_fc -  pv_con_aa) clos_inv_pv, -- closed inv PV
                                     --' ' lic_curre_total_closed,
                                     pkg_fin_lib_valuation.ed_inv
                                                      (lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      ) ed_inv,
                                     pkg_fin_lib_valuation.ed_cos
                                                      (lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      ) ed_cos,
                                     fl.lic_showing_first, x.com_name com_name,
                                     FR.REG_ID, FR.REG_CODE REGION,
                                     (SELECT count(1) from fid_schedule fsh where fsh.sch_lic_number=fl.lic_number and fsh.sch_type='F') as Free_Repeat		 --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                                FROM fid_general fg,
                                     fid_company fc,
                                     fid_contract fcon,
                                     fid_licensee flee,
                                     --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
                                     x_fin_lic_sec_lee xfsl,
                                     --Dev2: Pure Finance :END
                                     fid_license fl,

                   fid_region fr,                 -- added for split
                                     fid_territory ft,
                                     (SELECT DISTINCT fcom.com_number, fcom.com_name,
                                                      fcom.com_ter_code
                                                 FROM fid_company fcom
                                                WHERE fcom.com_short_name LIKE
                                                                          i_chnal_comp
                                                  AND fcom.com_type IN ('CC', 'BC')) x
                               WHERE ft.ter_code = x.com_ter_code
                                 --And fc.com_number=x.com_number
                                 AND flee.lee_cha_com_number = x.com_number
                              --   AND ROWNUM <101
                                 AND fl.lic_type LIKE i_lic_type
                                 AND flee.lee_short_name LIKE i_lee_short_name
                                 AND fl.lic_budget_code LIKE i_lic_budget_code
                                 AND fcon.con_short_name LIKE i_con_short_name
                                 AND fcon.con_number = fl.lic_con_number
                                 AND fc.com_number = fcon.con_com_number
                                 AND fg.gen_refno = fl.lic_gen_refno
                                 --Dev2: Pure Finance :Start:[ANUJASHINDE]_[2013/3/19]
                                 --LIC_LEE_NUMBER = LEE_NUMBER and
                                 AND fl.lic_number = xfsl.lsl_lic_number
                                 AND flee.lee_number = xfsl.lsl_lee_number
                                 --AND lee_split_region = reg_id
                                 AND fr.reg_id(+) = flee.lee_split_region
                                 AND UPPER (fr.reg_code) LIKE UPPER (i_region_code)
                                 AND fc.com_short_name LIKE i_supp_short_name
                                 --for report type "For a Period" it should take licenses with acc_date between given date range
                                 AND DECODE (i_report_type,
                                             'P', TO_CHAR (fl.lic_acct_date, 'YYYYMM'),
                                             NVL (TO_CHAR (i_to_date, 'YYYYMM'), 0)
                                            ) BETWEEN NVL (TO_CHAR (i_from_date,
                                                                    'YYYYMM'
                                                                   ),
                                                           0
                                                          )
                                                  AND NVL (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   ),
                                                           0
                                                          )
                                 --Dev2: Pure Finance :END
                                 --Dev2: Pure Finance :Start:[Non-Costed Fillers][ANUJASHINDE]_[2013/3/19]
                                 --[Added to exclude(fillers) licenses with status F]
                                 --Dev.R3: Placeholder: Start:[Devashish Raverkar]_[2014/03/28]
                                 AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                                 --Dev.R3: Placeholder: End:
                                 --Dev2: Pure Finance[Non Costed Fillers] :End
                                 AND flee.lee_cha_com_number = x.com_number
                                 AND UPPER (fr.reg_code) LIKE UPPER (i_region_code)

                   AND (EXISTS (
                                         SELECT   /*+ PARALLEL(flsl,2)*/
                                                  'X', SUM (cf_m_ca_p_cadj)
                                             FROM x_mv_lib_val_sum flsl
                                            WHERE lis_yyyymm_num <=
                                                     TO_NUMBER
                                                              (TO_CHAR (i_period_date,
                                                                        'YYYYMM'
                                                                       )
                                                              )
                                              AND flsl.lis_lic_number = fl.lic_number
                                              AND flsl.lis_lsl_number =
                                                                       xfsl.lsl_number
                                         GROUP BY 'X'
                                           HAVING ROUND (SUM (cf_m_ca_p_cadj), 0) != 0)
                                     )

                            /*or
                            ( lic_acct_date <= LAST_DAY(i_period_date))
                            and lic_end > LAST_DAY(i_period_date)))*/
                            ORDER BY lic_currency,
                                     lic_type,
                                     lee_short_name,
                                     lic_budget_code,
                                     com_short_name,
                                     con_short_name ASC,
                                     lic_number ASC,
                                     gen_title);
           COMMIT;
                         OPEN o_lib_rep FOR
                             SELECT
                                REGION region,
                                com_name,
                                LIC_CURRENCY lic_currency,
                                PERIOD period,
                                TER_CUR_CODE ter_cur_code,
                                NVL(EX_RATE,0) ex_rate,
                                LIC_TYPE lic_type,
                                LEE_SHORT_NAME lee_short_name,
                                LIC_BUDGET_CODE lic_budget_code,
                                SUPPLIER supplier,
                                CONTRACT contract,
                                LIC_NUMBER lic_number,
                                GEN_TITLE gen_title,
                                ACCT_DATE,
                                LIC_START lic_start,
                                LIC_END lic_end,
                                AM_CO,
                                NVL(LIC_EXH,0) lic_exh,
                                NVL(AMO_EXH,0) amo_exh,
                                NVL(PAID_EXH,0) paid_exh,
                                NVL(UNPAID_EXH,0) unpaid_exh,
                                NVL(CON_FC,0) con_fc,
                                NVL(CLOSE_MARKUP,0) close_markup,
                                NVL(CLOSE_MARKUP2,0) close_markup2,
                                NVL(CON_AA,0) con_aa,
                                    LIC_SHOWING_FIRST lic_showing_first,
                                NVL(TD_EXH,0) td_exh,
                                NVL(LIC_MARKUP_PERCENT,0) lic_markup_percent,
                                NVL(LIC_PRICE,0) LIC_PRICE,
                                NVL(PV_CON_FC,0) pv_con_fc,
                                NVL(PV_CON_AA,0) pv_con_aa,
                                NVL(CLOSED_INV_PV,0) closed_inv_pv,
                                NVL(TOTAL_CLOSED_LIC,0) total_closed_lic,
                                NVL(CLOSED_INV_PV2,0) closed_inv_pv2,
                                NVL(ED_INV,0) ed_inv,
                                NVL(ED_COS,0) ed_cos,
                                NVL(ED_CLOSE,0) ed_close,
                                NVL(TOTAL_CLOSED_LOC,0) TOTAL_CLOSED_LOC,
                                NVL(AMO_EXH_REM,0) amo_exh_rem,
                                    CON_EFF_DATE con_eff_date,
                                NVL(LIC_EXH_USED,0) lic_exh_used,
                                NVL(FREE_REPEAT,0) Free_Repeat
                                FROM X_SUMMARY_PROG_LIB_VAL;
                    --    Raise_Application_Error (-20343, 'The balance is too low.');
            ELSIF(upper(i_type) = 'SUMMARY')  -- REQUESTED BY- BR_15_006 - FINCR 30.(Ankur Kasar)
              THEN
               OPEN o_lib_rep FOR
                    select
                    REGION region,
                    COM_NAME com_name,
                    LIC_CURRENCY lic_currency,
                    PERIOD period,
                    TER_CUR_CODE ter_cur_code,
                    LIC_TYPE lic_type,
                    LEE_SHORT_NAME lee_short_name,
                    LIC_BUDGET_CODE lic_budget_code,
                    I_BUDGET_CODE  BUDGET_CODE_IP,
                    I_CONTRACT  CONTRACT_IP,
                    NVL(sum(CON_FC),0) con_fc,
                    NVL(sum(CLOSE_MARKUP),0) close_markup,
                    NVL(sum(CLOSE_MARKUP2),0) close_markup2,
                    NVL(sum(CON_AA),0) con_aa,
                    NVL(sum(PV_CON_FC),0) pv_con_fc,
                    NVL(sum(PV_CON_AA),0) pv_con_aa,
                    NVL(sum(CLOSED_INV_PV),0) closed_inv_pv,
                    NVL(sum(TOTAL_CLOSED_LIC),0) total_closed_lic,
                    NVL(sum(CLOSED_INV_PV2),0) closed_inv_pv2,
                    NVL(sum(ED_INV),0) ed_inv,
                    NVL(sum(ED_COS),0) ed_cos,
                    NVL(sum(ED_CLOSE),0) ed_close,
                    NVL(sum(TOTAL_CLOSED_LOC),0) TOTAL_CLOSED_LOC
                    FROM X_SUMMARY_PROG_LIB_VAL
                    group by com_name,region,lic_currency,lic_type,ter_cur_code,
                    lee_short_name,lic_budget_code,I_BUDGET_CODE,I_CONTRACT,period;

               ELSE

                OPEN o_lib_rep FOR
                  SELECT region, com_name, lic_currency,
                           TO_CHAR (i_period_date, 'YYYY/MM/DD HH:MI:SS') period,
                           ter_cur_code,

                           /*
                           NOC :
                           Changes done to Show correct exchange rate and local currency invnetory
                           NEERAJ : KARIM : 13-12-2013
                           */
                           /*(CASE WHEN lic_start < v_go_live_date
                           THEN ex_rate
                           ELSE ROUND(DECODE(NVL(con_fc, 0),0,lic_rate,(NVL(loc_fc,0)/NVL(con_fc, 0))),4)
                           END
                           ) ex_rate,*/
                           (CASE
                               WHEN lic_start < v_go_live_date
                               AND lic_acct_date < v_go_live_date
                                  THEN ex_rate
                               WHEN lic_start >= v_go_live_date
                               AND lic_acct_date >= v_go_live_date
                                  THEN ROUND (DECODE (NVL (con_fc, 0),
                                                      0, lic_rate,
                                                      (  NVL (loc_fc, 0)
                                                       / NVL (con_fc, 0)
                                                      )
                                                     ),
                                              5
                                             )
                               WHEN TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') >=
                                           TO_CHAR (TO_DATE (lic_acct_date), 'YYYYMM')
                               AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                          TO_CHAR (TO_DATE (v_go_live_date), 'YYYYMM')
                                  THEN ex_rate
                               WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                                  (SELECT yearmonth_char
                                                     FROM
                                                          /*subledger_data*/
                                                          x_mv_lib_reval_ex
                                                    WHERE lis_lic_number = lic_number)
                                    )
                                  THEN ex_rate
                               ELSE ROUND (DECODE (NVL (con_fc, 0),
                                                   0, NVL (lic_rate, ex_rate),
                                                   (NVL (loc_fc, 0) / NVL (con_fc, 0)
                                                   )
                                                  ),
                                           5
                                          )
                            END
                           ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                           lic_type, lee_short_name, lic_budget_code, supplier,
                           contract, lic_number, gen_title, acct_date,
                           con_eff_date, lic_start, lic_end, am_co
                                                                  --,LIC_AMORT_CODE
                           , lic_exh
                                    --,LIC_SHOWING_INT
                           , lic_exh_used
                           --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/25]
                           --,amo_exh
                                                  --,LIC_SHOWING_LIC
                           --,(amo_exh - paid_exh) amo_exh_rem, paid_exh,
                           ,DECODE(am_co,'A',NULL,amo_exh) amo_exh
                           ,DECODE(am_co,'A',NULL,(amo_exh - paid_exh)) amo_exh_rem
                           ,DECODE(am_co,'A',NULL,paid_exh) paid_exh,
                           --SIT.R5 : SVOD Enhancements : End
                           unpaid_exh,
                           (lic_exh - lic_exh_used) td_exh, lic_markup_percent,
                           con_fc
                                 --,FEE
                           , con_aa
                                   --,COST
                                   --,close_markup
                                   --,CLOSE
                                   --,close_markup2
                                   --,E_CLOSE
                           , (con_fc - con_aa) close_markup
                                                           --,CLOSE
                                                           --,((con_fc -con_aa)* ex_rate) close_markup2
                                                           --,E_CLOSE
                                                           --,(loc_fc - loc_aa) close_markup2
                                                           --,E_CLOSE
                                                           /*
                                                           NOC :
                                                           Changes done to Show correct exchange rate and local currency invnetory
                                                           NEERAJ : KARIM : 13-12-2013
                                                           */
                           ,
                           (CASE
                               WHEN lic_start < v_go_live_date
                               AND lic_acct_date < v_go_live_date
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               WHEN lic_start >= v_go_live_date
                               AND lic_acct_date >= v_go_live_date
                                  THEN ROUND ((loc_fc - loc_aa), 2)
                               WHEN TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') >=
                                           TO_CHAR (TO_DATE (lic_acct_date), 'YYYYMM')
                               AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                          TO_CHAR (TO_DATE (v_go_live_date), 'YYYYMM')
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                                  (SELECT yearmonth_char
                                                     FROM

                                                          x_mv_lib_reval_ex
                                                    WHERE lis_lic_number = lic_number)
                                    )
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               --ELSE ROUND ((loc_fc - loc_aa), 2)
                            ELSE DECODE (con_fc, 0, 0, ROUND ((loc_fc - loc_aa), 2))
                            END
                           ) close_markup2
                                          /*,(CASE
                                          WHEN lic_start < v_go_live_date
                                          THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                                          ELSE ROUND ((loc_fc - loc_aa), 2)
                                          END
                                          ) close_markup2,*/
                           ,
                           lic_showing_first, pv_con_fc, pv_con_aa,
                           (pv_con_fc - pv_con_aa) closed_inv_pv,
                           ((con_fc - con_aa) + (pv_con_fc - pv_con_aa)
                           ) total_closed_lic
                                             --,((pv_con_fc - pv_con_aa) * ex_rate) closed_inv_pv2
                           ,
                           (pv_loc_fc - pv_loc_aa) closed_inv_pv2, ed_inv, ed_cos,
                           (ed_inv - ed_cos) ed_close
                                                     --,(((con_fc -con_aa)* ex_rate) + ((pv_con_fc - pv_con_aa) * ex_rate) + (ED_inv - ED_COS) ) total_closed_loc
                           ,
                           (  (loc_fc - loc_aa)
                            + (pv_loc_fc - pv_loc_aa)
                            + (ed_inv - ed_cos)
                           ) TOTAL_CLOSED_LOC
                           ,Free_Repeat							 --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                           ,LIC_PRICE                --[2016-MAR-04] Ankur.Kasar[BR_15_001, BR_15_260 - Programme Library Valuation Report]
                           ,l_delete_month
                      FROM (SELECT
                                     --    fc2.com_number
                                     fc.com_number, ft.ter_cur_code, fl.lic_currency,
                                     x.com_name channel_comp, fl.lic_type,
                                     flee.lee_short_name, fl.lic_budget_code,
                                     SUBSTR (fc.com_short_name, 1, 8) supplier,
                                     fcon.con_short_name contract, fl.lic_number,
                                     fg.gen_title,

                                     --    SUBSTR(gen_title,1,20) GEN_TITLE   ---Removed Substring for issue  IM110349
                                     TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                                     con_con_effective_date con_eff_date,
                                     ROUND (xfsl.lsl_lee_price, 4) lic_price,
                                     TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                                     TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                                     fl.lic_amort_code am_co,
                                     DECODE (fl.lic_catchup_flag,
                                             'Y', NULL,
                                             fl.lic_showing_int
                                            ) lic_exh,
                                     pkg_fin_lib_valuation.td_not_paid
                                                          (lic_number,
                                                           i_period_date
                                                          ) lic_exh_used,
                                     fl.lic_showing_lic amo_exh,
                                     fl.lic_markup_percent, fl.lic_rate,
                                     fl.lic_acct_date,

                                     /* pkg_fin_lib_valuation.td_total -- passing lsl_number
                                     (lic_number,
                                     to_date (i_period_date),
                                     LSL_NUMBER
                                     ) td_exh ,*/
                                     /* pkg_fin_lib_valuation.ex_rate_lib_val
                                     (i_acc_prv_rate,
                                     lic_currency,
                                     TER_CUR_CODE,
                                     lic_number,
                                     lic_start,
                                     V_GO_LIVE_DATE,
                                     LSL_NUMBER
                                     ) EX_RATE, */
                                     pkg_fin_lib_valuation.ex_rate_lib_val
                                                             (i_acc_prv_rate,
                                                              lic_currency,
                                                              ter_cur_code
                                                             ) ex_rate,
                                     pkg_fin_lib_valuation.con_fc
                                                      (i_inc_markup,
                                                       lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      )
                                                       /*DECODE (i_inc_markup,'I',con_fc_i,con_fc_e)*/
                                     con_fc,
                                     pkg_fin_lib_valuation.con_aa
                                                      (i_inc_markup,
                                                       lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      )
                                                       /*DECODE (i_inc_markup,'I',con_aa_i,con_aa_e)*/
                                     con_aa,

                                     -- Pure Finance [new functions for local calculations]
                                     pkg_fin_lib_valuation.loc_fc            --
                                                      (i_inc_markup,
                                                       lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      )
                                                       /*DECODE (i_inc_markup,'I',nvl(loc_fc_i,loc_fc_e),loc_fc_e)*/
                                     loc_fc,
                                     pkg_fin_lib_valuation.loc_aa            --
                                                      (i_inc_markup,
                                                       lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      )
                                                       /*DECODE (i_inc_markup,'I',nvl(loc_aa_i,loc_aa_e),loc_aa_e)*/
                                     loc_aa,
                                     pkg_fin_lib_valuation.td_exh          --
                                                    (lic_number,
                                                     TO_DATE (i_period_date),
                                                     lic_start,
                                                     v_go_live_date
                                                    ) paid_exh,
                                     pkg_fin_lib_valuation.td_unpaid     --
                                                   (lic_number,
                                                    TO_DATE (i_period_date)
                                                   --,LSL_NUMBER
                                                   ) unpaid_exh,

                                     --  new functions for ED PV inv
                                     pkg_fin_lib_valuation.con_fc_fin
                                                   (       -- i_inc_markup,
                                                    lic_number,
                                                    TO_DATE (i_period_date),
                                                    lsl_number
                                                   ) pv_con_fc,

                                     --initial pv adj till to_date
                                     pkg_fin_lib_valuation.con_aa_fin
                                                   (       -- i_inc_markup,
                                                    lic_number,
                                                    TO_DATE (i_period_date),
                                                    lsl_number
                                                   ) pv_con_aa,

                                     --cos of PV till to_date
                                     --  new functions for ED PV  local inventory
                                     pkg_fin_lib_valuation.loc_fc_fin
                                                   (       -- i_inc_markup,
                                                    lic_number,
                                                    TO_DATE (i_period_date),
                                                    lsl_number
                                                   ) pv_loc_fc,

                                     --initial local pv adj till to_date
                                     pkg_fin_lib_valuation.loc_aa_fin
                                                   (       -- i_inc_markup,
                                                    lic_number,
                                                    TO_DATE (i_period_date),
                                                    lsl_number
                                                   ) pv_loc_aa,

                                     --local cos of PV till to_date
                                     --(pv_con_fc -  pv_con_aa) clos_inv_pv, -- closed inv PV
                                     --' ' lic_curre_total_closed,
                                     pkg_fin_lib_valuation.ed_inv
                                                      (lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      ) ed_inv,
                                     pkg_fin_lib_valuation.ed_cos
                                                      (lic_number,
                                                       TO_DATE (i_period_date),
                                                       lsl_number
                                                      ) ed_cos,
                                     fl.lic_showing_first, x.com_name com_name,
                                     FR.REG_ID, FR.REG_CODE REGION,
                                     (SELECT count(1) from fid_schedule fsh where fsh.sch_lic_number=fl.lic_number and fsh.sch_type='F') as Free_Repeat		 --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                                FROM fid_general fg,
                                     fid_company fc,
                                     fid_contract fcon,
                                     fid_licensee flee,
                                     --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
                                     x_fin_lic_sec_lee xfsl,
                                     --Dev2: Pure Finance :END
                                     fid_license fl,

                   fid_region fr,                 -- added for split
                                     fid_territory ft,
                                     (SELECT DISTINCT fcom.com_number, fcom.com_name,
                                                      fcom.com_ter_code
                                                 FROM fid_company fcom
                                                WHERE fcom.com_short_name LIKE
                                                                          i_chnal_comp
                                                  AND fcom.com_type IN ('CC', 'BC')) x
                               WHERE ft.ter_code = x.com_ter_code
                                 --And fc.com_number=x.com_number
                                 AND flee.lee_cha_com_number = x.com_number
                             --    AND ROWNUM <101
                                 AND fl.lic_type LIKE i_lic_type
                                 AND flee.lee_short_name LIKE i_lee_short_name
                                 AND fl.lic_budget_code LIKE i_lic_budget_code
                                 AND fcon.con_short_name LIKE i_con_short_name
                                 AND fcon.con_number = fl.lic_con_number
                                 AND fc.com_number = fcon.con_com_number
                                 AND fg.gen_refno = fl.lic_gen_refno
                                 --Dev2: Pure Finance :Start:[ANUJASHINDE]_[2013/3/19]
                                 --LIC_LEE_NUMBER = LEE_NUMBER and
                                 AND fl.lic_number = xfsl.lsl_lic_number
                                 AND flee.lee_number = xfsl.lsl_lee_number
                                 --AND lee_split_region = reg_id
                                 AND fr.reg_id(+) = flee.lee_split_region
                                 AND UPPER (fr.reg_code) LIKE UPPER (i_region_code)
                                 AND fc.com_short_name LIKE i_supp_short_name
                                 --for report type "For a Period" it should take licenses with acc_date between given date range
                                 AND DECODE (i_report_type,
                                             'P', TO_CHAR (fl.lic_acct_date, 'YYYYMM'),
                                             NVL (TO_CHAR (i_to_date, 'YYYYMM'), 0)
                                            ) BETWEEN NVL (TO_CHAR (i_from_date,
                                                                    'YYYYMM'
                                                                   ),
                                                           0
                                                          )
                                                  AND NVL (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   ),
                                                           0
                                                          )
                                 --Dev2: Pure Finance :END
                                 --Dev2: Pure Finance :Start:[Non-Costed Fillers][ANUJASHINDE]_[2013/3/19]
                                 --[Added to exclude(fillers) licenses with status F]
                                 --Dev.R3: Placeholder: Start:[Devashish Raverkar]_[2014/03/28]
                                 AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                                 --Dev.R3: Placeholder: End:
                                 --Dev2: Pure Finance[Non Costed Fillers] :End
                                 AND flee.lee_cha_com_number = x.com_number
                                 AND UPPER (fr.reg_code) LIKE UPPER (i_region_code)

                   AND (EXISTS (
                                         SELECT   /*+ PARALLEL(flsl,2)*/
                                                  'X', SUM (cf_m_ca_p_cadj)
                                             FROM x_mv_lib_val_sum flsl
                                            WHERE lis_yyyymm_num <=
                                                     TO_NUMBER
                                                              (TO_CHAR (i_period_date,
                                                                        'YYYYMM'
                                                                       )
                                                              )
                                              AND flsl.lis_lic_number = fl.lic_number
                                              AND flsl.lis_lsl_number =
                                                                       xfsl.lsl_number
                                         GROUP BY 'X'
                                           HAVING ROUND (SUM (cf_m_ca_p_cadj), 0) != 0)
                                     )

                            /*or
                            ( lic_acct_date <= LAST_DAY(i_period_date))
                            and lic_end > LAST_DAY(i_period_date)))*/
                            ORDER BY lic_currency,
                                     lic_type,
                                     lee_short_name,
                                     lic_budget_code,
                                     com_short_name,
                                     con_short_name ASC,
                                     lic_number ASC,
                                     gen_title);
           END IF;
      END IF;

   END prc_prg_lib_valution_rep;

   PROCEDURE prc_prg_lib_valution_rep_exl (
      i_region_code       IN       fid_region.reg_code%TYPE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
      i_report_type       IN       VARCHAR2,
      i_report_sub_type   IN       VARCHAR2,
      --Dev2: Pure Finance : End
      i_chnal_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
      i_supp_short_name   IN       fid_company.com_short_name%TYPE,
      --Dev2: Pure Finance :End
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_acc_prv_rate      IN       CHAR,
      i_inc_markup        IN       CHAR,
      --Dev2: Pure Finance :Start : [ANUJASHINDE]_[2013/3/19]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_period_date       IN       DATE,
      --Dev2: Pure Finance :End
      i_include_zero      IN       CHAR,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (30000);
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      v_go_live_date   DATE;
   --Dev2: Pure Finance :End
   BEGIN
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      DELETE      exl_prog_lib_val;

      COMMIT;

      IF i_include_zero = 'Y'
      THEN
         INSERT      /*+APPEND*/INTO exl_prog_lib_val
                     (com_name, lic_currency, period, ter_cur_code,
                      exchange_rate, lic_type, lee_short_name,
                      lic_budget_code, supplier, contract, lic_number,
                      gen_title, lic_acct_date, con_eff_date, lic_start,
                      lic_end, lic_amort_code, lic_showing_int, lic_exh_used,
                      lic_showing_lic,              --,PAID_EXH --,UNPAID_EXH
                                      td_exh, amo_exh_rem,
                      lic_markup_percent, fee, COST, CLOSE, e_close,

                      --,LIC_SHOWING_FIRST
                      lic_price, reg_code,                               --26
                                          pv_con_fc, pv_con_aa,
                      closed_inv_pv, total_closed_lic, closed_inv_pv2,
                      ED_INV, ED_COS, ED_CLOSE, TOTAL_CLOSED_LOC)        --35
            SELECT com_name, lic_currency,
                   TO_CHAR (i_period_date, 'DD-MON-RRRR') period,
                   ter_cur_code, ex_rate, lic_type, lee_short_name,
                   lic_budget_code, supplier, contract, lic_number,
                   gen_title, acct_date, con_eff_date,
                   lic_start, lic_end,
                   am_co, lic_exh,
                   --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/25]
                   --, lic_exh_used, amo_exh
                   DECODE(am_co,'A',NULL,lic_exh_used) lic_exh_used,
                   DECODE(am_co,'A',NULL,amo_exh) amo_exh,
                                                        --,PAID_EXH
                                                        --,UNPAID_EXH
                   td_exh,
                   DECODE(am_co,'A',NULL,amo_exh_rem) amo_exh_rem,
                   --SIT.R5 : SVOD Enhancements : End
                   lic_markup_percent, con_fc, con_aa,
                   close_markup, close_markup2 --,LIC_SHOWING_FIRST
                   , lic_price, region                                   --26
                                      ,
                   pv_con_fc, pv_con_aa, closed_inv_pv, total_closed_lic,
                   closed_inv_pv2, ed_inv, ed_cos, ed_close,
                   total_closed_loc                                      --32
              FROM (SELECT
                 --Dev2: Pure Finance :Start:[FIN 7]_[ANUJASHINDE]_[2013/3/19]
                           region,
                                  --Dev2: Pure Finance :End
                                  com_name, lic_currency, lic_price,
                           TO_CHAR (i_period_date,
                                    'DD-MON-RRRR'
                                   ) period,
                           ter_cur_code,

                           /*
                           NOC :
                           Changes done to Show correct exchange rate and local currency invnetory
                           NEERAJ : KARIM : 13-12-2013
                           */
                           /*(CASE
                           WHEN lic_start < v_go_live_date
                           THEN ex_rate
                           ELSE ROUND(DECODE(NVL(con_fc,0),0,lic_rate,(NVL(loc_fc,0)/ NVL(con_fc,0))),4)
                           END
                           )ex_rate,*/
                           (CASE
                               WHEN lic_start < v_go_live_date
                               AND lic_acct_date < v_go_live_date
                                  THEN ex_rate
                               WHEN lic_start >= v_go_live_date
                               AND lic_acct_date >= v_go_live_date
                                  THEN ROUND (DECODE (NVL (con_fc, 0),
                                                      0, lic_rate,
                                                      (  NVL (loc_fc, 0)
                                                       / NVL (con_fc, 0)
                                                      )
                                                     ),
                                              5
                                             )
                               WHEN TO_CHAR (TO_DATE (i_period_date),
                                             'YYYYMM') >=
                                      TO_CHAR (TO_DATE (lic_acct_date),
                                               'YYYYMM'
                                              )
                               AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                      TO_CHAR (TO_DATE (v_go_live_date),
                                               'YYYYMM'
                                              )
                                  THEN ex_rate
                               WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                          (SELECT yearmonth_char
                                             FROM
                                                  /*subledger_data*/
                                                  x_mv_lib_reval_ex
                                            WHERE lis_lic_number = lic_number)
                                    )
                                  THEN ex_rate
                               ELSE ROUND (DECODE (NVL (con_fc, 0),
                                                   0, NVL (lic_rate, ex_rate),
                                                   (  NVL (loc_fc, 0)
                                                    / NVL (con_fc, 0)
                                                   )
                                                  ),
                                           5
                                          )
                            END
                           ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                           lic_type, lee_short_name, lic_budget_code,
                           supplier, contract, lic_number, gen_title,
                           acct_date, con_eff_date, lic_start, lic_end, am_co
                                                                             --,LIC_AMORT_CODE
                           ,
                           lic_exh
                                  --,LIC_SHOWING_INT
                           , lic_exh_used, amo_exh
                                                  --,LIC_SHOWING_LIC
                           , paid_exh, unpaid_exh,
                           (lic_exh - lic_exh_used) td_exh,
                           (amo_exh - paid_exh) amo_exh_rem,
                           lic_markup_percent, con_fc                   -- FEE
                                                     ,
                           con_aa                                      -- COST
                                 ,
                           (con_fc - con_aa) close_markup              --CLOSE
                                                         --  ((con_fc -con_aa)* ex_rate) close_markup2,          --E_CLOSE
                                                         --  ((loc_fc - loc_aa)) close_markup2,        --E_CLOSE
                                                         /*
                                                         NOC :
                                                         Changes done to Show correct exchange rate and local currency invnetory
                                                         NEERAJ : KARIM : 13-12-2013
                                                         */
                                                         /*(CASE
                                                         WHEN lic_start < v_go_live_date
                                                         THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                                                         ELSE ROUND ((loc_fc - loc_aa), 2)
                                                         END
                                                         ) close_markup2,*/
                           ,
                           (CASE
                               WHEN lic_start < v_go_live_date
                               AND lic_acct_date < v_go_live_date
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               WHEN lic_start >= v_go_live_date
                               AND lic_acct_date >= v_go_live_date
                                  THEN ROUND ((loc_fc - loc_aa), 2)
                               WHEN TO_CHAR (TO_DATE (i_period_date),
                                             'YYYYMM') >=
                                      TO_CHAR (TO_DATE (lic_acct_date),
                                               'YYYYMM'
                                              )
                               AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                      TO_CHAR (TO_DATE (v_go_live_date),
                                               'YYYYMM'
                                              )
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                          (SELECT yearmonth_char
                                             FROM
                                                  /*subledger_data*/
                                                  x_mv_lib_reval_ex
                                            WHERE lis_lic_number = lic_number)
                                    )
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               --ELSE ROUND ((loc_fc - loc_aa), 2)
                            ELSE DECODE (con_fc,
                                         0, 0,
                                         ROUND ((loc_fc - loc_aa), 2)
                                        )
                            END
                           ) close_markup2,
                           lic_showing_first, pv_con_fc, pv_con_aa,
                           (pv_con_fc - pv_con_aa) closed_inv_pv,
                           ((con_fc - con_aa) + (pv_con_fc - pv_con_aa)
                           ) total_closed_lic
                                             --((pv_con_fc - pv_con_aa) * ex_rate) closed_inv_pv2,
                           ,
                           (pv_loc_fc - pv_loc_aa) closed_inv_pv2, ed_inv,
                           ed_cos, (ed_inv - ed_cos) ed_close
                                                             --(((con_fc -con_aa)* ex_rate) + ((pv_con_fc - pv_con_aa) * ex_rate) + (ED_inv - ED_COS) ) total_closed_loc
                           ,
                           (  (loc_fc - loc_aa)
                            + (pv_loc_fc - pv_loc_aa)
                            + (ed_inv - ed_cos)
                           ) total_closed_loc
                      FROM (SELECT                            --fc2.com_number
                                     fr.reg_code region, fc.com_number,
                                     ft.ter_cur_code, fl.lic_currency,
                                     x.com_name channel_comp, fl.lic_type,
                                     flee.lee_short_name, fl.lic_budget_code,
                                     SUBSTR (fc.com_short_name, 1,
                                             8) supplier,
                                     fcon.con_short_name contract,
                                     fl.lic_number, fl.lic_acct_date,
                                     fg.gen_title
                                                 -- SUBSTR(gen_title,1,20) GEN_TITLE   ---Removed Substring for issue  IM110349
                                     ,
                                     TO_CHAR (fl.lic_acct_date,
                                              'YYYY.MM'
                                             ) acct_date,
                                     con_con_effective_date con_eff_date,
                                     TO_CHAR (fl.lic_start,
                                              'DD-MON-RRRR'
                                             ) lic_start,
                                     TO_CHAR (fl.lic_end,
                                              'DD-MON-RRRR') lic_end,
                                     fl.lic_markup_percent, fl.lic_rate,
                                     ROUND (xfsl.lsl_lee_price, 4) lic_price,
                                     fl.lic_amort_code am_co,
                                     DECODE (fl.lic_catchup_flag,
                                             'Y', NULL,
                                             fl.lic_showing_int
                                            ) lic_exh,
                                     pkg_fin_lib_valuation.td_not_paid
                                                  (lic_number,
                                                   i_period_date
                                                  ) lic_exh_used,
                                     fl.lic_showing_lic amo_exh,

                                     /* pkg_fin_lib_valuation.td_total -- passing lsl_number
                                     (lic_number,
                                     to_date (i_period_date),
                                     LSL_NUMBER
                                     ) td_exh,*/
                                     -- for lic_start < go_live_date get bud_rate else lic_rate
                                     /* pkg_fin_lib_valuation.ex_rate_lib_val
                                     (i_acc_prv_rate,
                                     lic_currency,
                                     TER_CUR_CODE,
                                     lic_number,
                                     lic_start,
                                     V_GO_LIVE_DATE,
                                     LSL_NUMBER
                                     ) EX_RATE, */
                                     pkg_fin_lib_valuation.ex_rate_lib_val
                                                     (i_acc_prv_rate,
                                                      lic_currency,
                                                      ter_cur_code
                                                     ) ex_rate,
                                     pkg_fin_lib_valuation.con_fc
                                              (i_inc_markup,
                                               lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              )
                                               /*DECODE (i_inc_markup,'I',con_fc_i,con_fc_e)*/
                                     con_fc,
                                     pkg_fin_lib_valuation.con_aa
                                              (i_inc_markup,
                                               lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              )
                                               /*DECODE (i_inc_markup,'I',con_aa_i,con_aa_e)*/
                                     con_aa,

                                     -- Pure Finance [new functions for local calculations]
                                     pkg_fin_lib_valuation.loc_fc
                                              (i_inc_markup,
                                               lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              )
                                               /*DECODE (i_inc_markup,'I',nvl(loc_fc_i,loc_fc_e),loc_fc_e)*/
                                     loc_fc,
                                     pkg_fin_lib_valuation.loc_aa
                                              (i_inc_markup,
                                               lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              )
                                               /*DECODE (i_inc_markup,'I',nvl(loc_aa_i,loc_aa_e),loc_aa_e)*/
                                     loc_aa,
                                     pkg_fin_lib_valuation.td_exh
                                            (lic_number,
                                             TO_DATE (i_period_date),
                                             lic_start,
                                             v_go_live_date
                                            ) paid_exh,
                                     pkg_fin_lib_valuation.td_unpaid
                                           (lic_number,
                                            TO_DATE (i_period_date)
                                           --,LSL_NUMBER
                                           ) unpaid_exh,

                                     -- anuja new functions for ED PV inv
                                     pkg_fin_lib_valuation.con_fc_fin
                                           (       -- i_inc_markup,
                                            lic_number,
                                            TO_DATE (i_period_date),
                                            lsl_number
                                           ) pv_con_fc,

                                     --initial pv adj till to_date
                                     pkg_fin_lib_valuation.con_aa_fin
                                           (       -- i_inc_markup,
                                            lic_number,
                                            TO_DATE (i_period_date),
                                            lsl_number
                                           ) pv_con_aa,

                                     --cos of PV till to_date
                                     --  new functions for ED PV  local inventory
                                     pkg_fin_lib_valuation.loc_fc_fin
                                           (       -- i_inc_markup,
                                            lic_number,
                                            TO_DATE (i_period_date),
                                            lsl_number
                                           ) pv_loc_fc,

                                     --initial local pv adj till to_date
                                     pkg_fin_lib_valuation.loc_aa_fin
                                           (       -- i_inc_markup,
                                            lic_number,
                                            TO_DATE (i_period_date),
                                            lsl_number
                                           ) pv_loc_aa,

                                     --local cos of PV till to_date
                                     --(pv_con_fc -  pv_con_aa) clos_inv_pv, -- closed inv PV
                                     --' ' lic_curre_total_closed,
                                     pkg_fin_lib_valuation.ed_inv
                                              (lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              ) ed_inv,
                                     pkg_fin_lib_valuation.ed_cos
                                              (lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              ) ed_cos,
                                     lic_showing_first, x.com_name com_name
                                FROM fid_general fg,
                                     fid_company fc,
                                     fid_contract fcon,
                                     fid_licensee flee,
                                     --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
                                     x_fin_lic_sec_lee xfsl,
                                     --Dev2: Pure Finance :END
                                     fid_license fl,
                                     fid_territory ft,
                                     fid_region fr,         -- added for split
                                     (SELECT DISTINCT fcom.com_number,
                                                      fcom.com_name,
                                                      fcom.com_ter_code
                                                 FROM fid_company fcom
                                                WHERE fcom.com_short_name LIKE
                                                                  i_chnal_comp
                                                  AND fcom.com_type IN
                                                                 ('CC', 'BC')) x
                               WHERE ft.ter_code = x.com_ter_code
                                 --And fc.com_number=x.com_number
                                 AND flee.lee_cha_com_number = x.com_number
                                 AND fl.lic_type LIKE i_lic_type
                                 AND flee.lee_short_name LIKE i_lee_short_name
                                 AND fl.lic_budget_code LIKE i_lic_budget_code
                                 AND fcon.con_short_name LIKE i_con_short_name
                                 AND fcon.con_number = fl.lic_con_number
                                 AND fc.com_number = fcon.con_com_number
                                 -- supplier
                                 AND fg.gen_refno = fl.lic_gen_refno
                                 --Dev2: Pure Finance :Start:[ANUJASHINDE]_[2013/3/19]
                                 --LIC_LEE_NUMBER = LEE_NUMBER and
                                 AND fl.lic_number = xfsl.lsl_lic_number
                                 AND flee.lee_number = xfsl.lsl_lee_number
                                 --AND lee_split_region = reg_id
                                 AND fr.reg_id(+) = flee.lee_split_region
                                 AND UPPER (fr.reg_code) LIKE
                                                         UPPER (i_region_code)
                                 AND fc.com_short_name LIKE i_supp_short_name
                                 --for report type "For a Period" it should take licenses with acc_date between given date range
                                 AND DECODE (i_report_type,
                                             'P', TO_CHAR (fl.lic_acct_date,
                                                           'YYYYMM'
                                                          ),
                                             NVL (TO_CHAR (i_to_date,
                                                           'YYYYMM'),
                                                  0
                                                 )
                                            )
                                        BETWEEN NVL (TO_CHAR (i_from_date,
                                                              'YYYYMM'
                                                             ),
                                                     0
                                                    )
                                            AND NVL (TO_CHAR (i_to_date,
                                                              'YYYYMM'
                                                             ),
                                                     0
                                                    )
                                 --Dev2: Pure Finance :END
                                 --Dev2: Pure Finance :Start:[Non-Costed Fillers][ANUJASHINDE]_[2013/3/19]
                                 --[Added to exclude(fillers) licenses with status F]
                                 --Dev.R3: Placeholder: Start:[Devashish Raverkar]_[2014/03/28]
                                 AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                                 --Dev.R3: Placeholder: End:
                                 --Dev2: Pure Finance[Non Costed Fillers] :End
                                ---Start[01-Sep-2015][Jawahar.Garg]commented the condition to show records with zero when include zero is selected
								 /*AND (EXISTS (
                                         SELECT   / *+ PARALLEL(flsl,2)* /
                                                  'X', SUM (cf_m_ca_p_cadj)
                                             FROM x_mv_lib_val_sum flsl
                                            WHERE lis_yyyymm_num <=
                                                     TO_NUMBER
                                                        (TO_CHAR
                                                               (i_period_date,
                                                                'YYYYMM'
                                                               )
                                                        )
                                              AND flsl.lis_lic_number =
                                                                 fl.lic_number
                                              AND flsl.lis_lsl_number =
                                                               xfsl.lsl_number
                                         GROUP BY 'X'
                                           HAVING ROUND (SUM (cf_m_ca_p_cadj),
                                                         0
                                                        ) != 0
                                                   --Pure Finance :Start [Anuja_Shinde] [2013/05/27]
                                                              --OR (FL.LIC_ACCT_DATE <= LAST_DAY(I_PERIOD_DATE)) --Not required , same as generate
                                      )
                                     ) */
							    ---End[01-Sep-2015][Jawahar.Garg]commented the condition to show records with zero when include zero is selected

                            ORDER BY lic_currency,
                                     lic_type,
                                     lee_short_name,
                                     lic_budget_code,
                                     com_short_name,
                                     con_short_name ASC,
                                     lic_number ASC,
                                     gen_title));

         COMMIT;
      ELSE
         INSERT      /*+APPEND*/INTO exl_prog_lib_val
                     (com_name, lic_currency, period, ter_cur_code,
                      exchange_rate, lic_type, lee_short_name,
                      lic_budget_code, supplier, contract, lic_number,
                      gen_title, lic_acct_date, con_eff_date, lic_start,
                      lic_end, lic_amort_code, lic_showing_int, lic_exh_used,
                      lic_showing_lic,              --,PAID_EXH --,UNPAID_EXH
                                      td_exh, amo_exh_rem,
                      lic_markup_percent, fee, COST, CLOSE, e_close,

                      --,LIC_SHOWING_FIRST
                      lic_price, reg_code,                               --26
                                          pv_con_fc, pv_con_aa,
                      closed_inv_pv, total_closed_lic, closed_inv_pv2,
                      ed_inv, ed_cos, ed_close, total_closed_loc)        --35
            SELECT com_name, lic_currency,
                   period,						--FIN CR Req changed date format
                   ter_cur_code, ex_rate, lic_type, lee_short_name,
                   lic_budget_code, supplier, contract, lic_number,
                   gen_title, acct_date, con_eff_date, lic_start, lic_end,
                   am_co, lic_exh,
                   --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/25]
                   --, lic_exh_used, amo_exh
                   DECODE(am_co,'A',NULL,lic_exh_used) lic_exh_used,
                   DECODE(am_co,'A',NULL,amo_exh) amo_exh,
                                                         --,PAID_EXH
                                                         --,UNPAID_EXH
                                                         td_exh,
                   --(amo_exh - paid_exh) amo_exh_rem,
                   DECODE(am_co,'A',NULL,(amo_exh - paid_exh)) amo_exh_rem,
                   --SIT.R5 : SVOD Enhancements : End
                   lic_markup_percent,
                   con_fc, con_aa, close_markup, close_markup2,
                                                               --,LIC_SHOWING_FIRST,
                                                               lic_price,
                   region,                                               --26
                          pv_con_fc, pv_con_aa, closed_inv_pv,
                   total_closed_lic, closed_inv_pv2, ed_inv, ed_cos,
                   ed_close, total_closed_loc                            --32
              FROM (SELECT region, com_name, lic_currency,
                           TO_CHAR (I_PERIOD_DATE,
                                    'DD-MON-RRRR'			--FIN CR Req changed date format
                                   ) period,
                           ter_cur_code,

                           /*
                           NOC :
                           Changes done to Show correct exchange rate and local currency invnetory
                           NEERAJ : KARIM : 13-12-2013
                           */
                           /*(CASE
                           WHEN lic_start < v_go_live_date
                           THEN ex_rate
                           ELSE ROUND(DECODE(NVL(con_fc,0),0,lic_rate,(NVL(loc_fc,0)/NVL(con_fc,0))),4)
                           END
                           ) ex_rate,*/
                           (CASE
                               WHEN lic_start < v_go_live_date
                               AND lic_acct_date < v_go_live_date
                                  THEN ex_rate
                               WHEN lic_start >= v_go_live_date
                               AND lic_acct_date >= v_go_live_date
                                  THEN ROUND (DECODE (NVL (con_fc, 0),
                                                      0, lic_rate,
                                                      (  NVL (loc_fc, 0)
                                                       / NVL (con_fc, 0)
                                                      )
                                                     ),
                                              5
                                             )
                               WHEN TO_CHAR (TO_DATE (i_period_date),
                                             'YYYYMM') >=
                                      TO_CHAR (TO_DATE (lic_acct_date),
                                               'YYYYMM'
                                              )
                               AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                      TO_CHAR (TO_DATE (v_go_live_date),
                                               'YYYYMM'
                                              )
                                  THEN ex_rate
                               WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                          (SELECT yearmonth_char
                                             FROM

                                                  x_mv_lib_reval_ex
                                            WHERE lis_lic_number = lic_number)
                                    )
                                  THEN ex_rate
                               ELSE ROUND (DECODE (NVL (con_fc, 0),
                                                   0, NVL (lic_rate, ex_rate),
                                                   (  NVL (loc_fc, 0)
                                                    / NVL (con_fc, 0)
                                                   )
                                                  ),
                                           5
                                          )
                            END
                           ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                           lic_price, lic_type, lee_short_name,
                           lic_budget_code, supplier, contract, lic_number,
                           gen_title, acct_date, con_eff_date, lic_start,
                           lic_end, am_co,                   -- LIC_AMORT_CODE
                                          lic_exh,          -- LIC_SHOWING_INT
                                                  lic_exh_used, amo_exh,

                           --LIC_SHOWING_LIC
                           (amo_exh - paid_exh) amo_exh_rem, paid_exh,
                           unpaid_exh, (lic_exh - lic_exh_used) td_exh,
                           lic_markup_percent, con_fc,                  -- FEE
                                                      con_aa,          -- COST

                           --      close_markup,                                       --CLOSE
                           --      close_markup2,                                    --E_CLOSE
                           (con_fc - con_aa) close_markup,             --CLOSE

                           --((CON_FC -CON_AA)* EX_RATE) CLOSE_MARKUP2,          --E_CLOSE
                           --(loc_fc - loc_aa) close_markup2,          --E_CLOSE
                           /*
                           NOC :
                           Changes done to Show correct exchange rate and local currency invnetory
                           NEERAJ : KARIM : 13-12-2013
                           */
                           /*    (CASE
                           WHEN lic_start < v_go_live_date
                           THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                           ELSE ROUND ((loc_fc - loc_aa), 2)
                           END
                           ) close_markup2,*/
                           (CASE
                               WHEN lic_start < v_go_live_date
                               AND lic_acct_date < v_go_live_date
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               WHEN lic_start >= v_go_live_date
                               AND lic_acct_date >= v_go_live_date
                                  THEN ROUND ((loc_fc - loc_aa), 2)
                               WHEN TO_CHAR (TO_DATE (i_period_date),
                                             'YYYYMM') >=
                                      TO_CHAR (TO_DATE (lic_acct_date),
                                               'YYYYMM'
                                              )
                               AND TO_CHAR (TO_DATE (i_period_date), 'YYYYMM') <
                                      TO_CHAR (TO_DATE (v_go_live_date),
                                               'YYYYMM'
                                              )
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               WHEN (TO_CHAR (i_period_date, 'YYYYMM') <
                                          (SELECT yearmonth_char
                                             FROM

                                                  x_mv_lib_reval_ex
                                            WHERE lis_lic_number = lic_number)
                                    )
                                  THEN ROUND ((con_fc - con_aa) * ex_rate, 2)
                               --ELSE ROUND ((loc_fc - loc_aa), 2)
                            ELSE DECODE (con_fc,
                                         0, 0,
                                         ROUND ((loc_fc - loc_aa), 2)
                                        )
                            END
                           ) close_markup2,
                           lic_showing_first, pv_con_fc, pv_con_aa,
                           (pv_con_fc - pv_con_aa) closed_inv_pv,
                           ((con_fc - con_aa) + (pv_con_fc - pv_con_aa)
                           ) total_closed_lic,

                           -- ((pv_con_fc - pv_con_aa) * ex_rate) closed_inv_pv2,
                           (pv_loc_fc - pv_loc_aa) closed_inv_pv2, ed_inv,
                           ed_cos, (ed_inv - ed_cos) ed_close,

                           --(((con_fc -con_aa)* ex_rate) + ((pv_con_fc - pv_con_aa) * ex_rate) + (ED_inv - ED_COS) ) total_closed_loc,
                           (  (loc_fc - loc_aa)
                            + (pv_loc_fc - pv_loc_aa)
                            + (ed_inv - ed_cos)
                           ) total_closed_loc,
                           lic_showing_first
                      FROM (SELECT                            --fc2.com_number
                                     fc.com_number, ft.ter_cur_code,
                                     fl.lic_currency, x.com_name channel_comp,
                                     fl.lic_type, flee.lee_short_name,
                                     fl.lic_budget_code,
                                     SUBSTR (fc.com_short_name, 1,
                                             8) supplier,
                                     fcon.con_short_name contract,
                                     fl.lic_number, fl.lic_acct_date,
                                     fg.gen_title,

                                     --    SUBSTR(gen_title,1,20) GEN_TITLE   ---Removed Substring for issue  IM110349
                                     TO_CHAR (fl.lic_acct_date,
                                              'YYYY.MM'
                                             ) acct_date,
                                     con_con_effective_date con_eff_date,
                                     TO_CHAR (fl.lic_start,
                                              'DD-MON-RRRR'
                                             ) lic_start,
                                     TO_CHAR (fl.lic_end,
                                              'DD-MON-RRRR') lic_end,
                                     fl.lic_amort_code am_co,
                                     DECODE (fl.lic_catchup_flag,
                                             'Y', NULL,
                                             fl.lic_showing_int
                                            ) lic_exh,
                                     pkg_fin_lib_valuation.td_not_paid
                                                  (lic_number,
                                                   i_period_date
                                                  ) lic_exh_used,
                                     fl.lic_showing_lic amo_exh,
                                     fl.lic_markup_percent, lic_rate,
                                     ROUND (xfsl.lsl_lee_price, 4) lic_price,

                                     /*pkg_fin_lib_valuation.td_total -- passing lsl_number
                                     (lic_number,
                                     to_date (i_period_date),
                                     LSL_NUMBER
                                     ) td_exh, */
                                     /* pkg_fin_lib_valuation.ex_rate_lib_val
                                     (i_acc_prv_rate,
                                     lic_currency,
                                     TER_CUR_CODE,
                                     lic_number,
                                     lic_start,
                                     V_GO_LIVE_DATE,
                                     LSL_NUMBER
                                     ) EX_RATE, */
                                     pkg_fin_lib_valuation.ex_rate_lib_val
                                                     (i_acc_prv_rate,
                                                      lic_currency,
                                                      ter_cur_code
                                                     ) ex_rate,
                                     pkg_fin_lib_valuation.con_fc
                                              (i_inc_markup,
                                               lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              )
                                               /*DECODE (i_inc_markup,'I',con_fc_i,con_fc_e)*/
                                     con_fc,
                                     pkg_fin_lib_valuation.con_aa
                                              (i_inc_markup,
                                               lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              )
                                               /*DECODE (i_inc_markup,'I',con_aa_i,con_aa_e)*/
                                     con_aa,
                        -- Pure Finance [new functions for local calculations]
                                     pkg_fin_lib_valuation.loc_fc
                                              (i_inc_markup,
                                               lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              )
                                               /*DECODE (i_inc_markup,'I',nvl(loc_fc_i,loc_fc_e),loc_fc_e)*/
                                     loc_fc,
                                     pkg_fin_lib_valuation.loc_aa
                                              (i_inc_markup,
                                               lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              )
                                               /*DECODE (i_inc_markup,'I',nvl(loc_aa_i,loc_aa_e),loc_aa_e)*/
                                     loc_aa,
                                     pkg_fin_lib_valuation.td_exh
                                            (lic_number,
                                             TO_DATE (i_period_date),
                                             lic_start,
                                             v_go_live_date
                                            ) paid_exh,
                                     pkg_fin_lib_valuation.td_unpaid
                                           (lic_number,
                                            TO_DATE (i_period_date)
                                           --,LSL_NUMBER
                                           ) unpaid_exh,

                                     -- anuja new functions for ED PV inv
                                     pkg_fin_lib_valuation.con_fc_fin
                                           (       -- i_inc_markup,
                                            lic_number,
                                            TO_DATE (i_period_date),
                                            lsl_number
                                           ) pv_con_fc,

                                     --initial pv adj till to_date
                                     pkg_fin_lib_valuation.con_aa_fin
                                           (       -- i_inc_markup,
                                            lic_number,
                                            TO_DATE (i_period_date),
                                            lsl_number
                                           ) pv_con_aa,

                                     --cos of PV till to_date
                                     --  new functions for ED PV  local inventory
                                     pkg_fin_lib_valuation.loc_fc_fin
                                           (       -- i_inc_markup,
                                            lic_number,
                                            TO_DATE (i_period_date),
                                            lsl_number
                                           ) pv_loc_fc,

                                     --initial local pv adj till to_date
                                     pkg_fin_lib_valuation.loc_aa_fin
                                           (       -- i_inc_markup,
                                            lic_number,
                                            TO_DATE (i_period_date),
                                            lsl_number
                                           ) pv_loc_aa,

                                     --local cos of PV till to_date
                                     --(pv_con_fc -  pv_con_aa) clos_inv_pv, -- closed inv PV
                                     --' ' lic_curre_total_closed,
                                     pkg_fin_lib_valuation.ed_inv
                                              (lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              ) ed_inv,
                                     pkg_fin_lib_valuation.ed_cos
                                              (lic_number,
                                               TO_DATE (i_period_date),
                                               lsl_number
                                              ) ed_cos,
                                     fl.lic_showing_first,
                                     x.com_name com_name, fr.reg_id,
                                     fr.reg_code region
                                FROM fid_general fg,
                                     fid_company fc,
                                     fid_contract fcon,
                                     fid_licensee flee,
                                     --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/19]
                                     x_fin_lic_sec_lee xfsl,
                                     --Dev2: Pure Finance :END
                                     fid_license fl,
                                     fid_region fr,         -- added for split
                                     fid_territory ft,
                                     (SELECT DISTINCT fcom.com_number,
                                                      fcom.com_name,
                                                      fcom.com_ter_code
                                                 FROM fid_company fcom
                                                WHERE fcom.com_short_name LIKE
                                                                  i_chnal_comp
                                                  AND fcom.com_type IN
                                                                 ('CC', 'BC')) x
                               WHERE ft.ter_code = x.com_ter_code
                                 --And fc.com_number=x.com_number
                                 AND flee.lee_cha_com_number = x.com_number
                                 AND fl.lic_type LIKE i_lic_type
                                 AND flee.lee_short_name LIKE i_lee_short_name
                                 AND fl.lic_budget_code LIKE i_lic_budget_code
                                 AND fcon.con_short_name LIKE i_con_short_name
                                 AND fcon.con_number = fl.lic_con_number
                                 AND fc.com_number = fcon.con_com_number
                                 AND fg.gen_refno = fl.lic_gen_refno
                                 --Dev2: Pure Finance :Start:[ANUJASHINDE]_[2013/3/19]
                                 --LIC_LEE_NUMBER = LEE_NUMBER and
                                 AND fl.lic_number = xfsl.lsl_lic_number
                                 AND flee.lee_number = xfsl.lsl_lee_number
                                 --AND lee_split_region = reg_id
                                 AND fr.reg_id(+) = flee.lee_split_region
                                 AND UPPER (fr.reg_code) LIKE
                                                         UPPER (i_region_code)
                                 AND fc.com_short_name LIKE i_supp_short_name
                                 --for report type "For a Period" it should take licenses with acc_date between given date range
                                 AND DECODE (i_report_type,
                                             'P', TO_CHAR (fl.lic_acct_date,
                                                           'YYYYMM'
                                                          ),
                                             NVL (TO_CHAR (i_to_date,
                                                           'YYYYMM'),
                                                  0
                                                 )
                                            )
                                        BETWEEN NVL (TO_CHAR (i_from_date,
                                                              'YYYYMM'
                                                             ),
                                                     0
                                                    )
                                            AND NVL (TO_CHAR (i_to_date,
                                                              'YYYYMM'
                                                             ),
                                                     0
                                                    )
                                 --Dev2: Pure Finance :END
                                 --Dev2: Pure Finance :Start:[Non-Costed Fillers][ANUJASHINDE]_[2013/3/19]
                                 --[Added to exclude(fillers) licenses with status F]
                                 --Dev.R3: Placeholder: Start:[Devashish Raverkar]_[2014/03/28]
                                 AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                                 --Dev.R3: Placeholder: End:
                                 --Dev2: Pure Finance[Non Costed Fillers] :End
                                 AND flee.lee_cha_com_number = x.com_number
                                 AND UPPER (fr.reg_code) LIKE
                                                         UPPER (i_region_code)
                                 AND (EXISTS (
                                         SELECT   /*+ PARALLEL(flsl,2)*/
                                                  'X', SUM (cf_m_ca_p_cadj)
                                             FROM x_mv_lib_val_sum flsl
                                            WHERE lis_yyyymm_num <=
                                                     TO_NUMBER
                                                        (TO_CHAR
                                                               (i_period_date,
                                                                'YYYYMM'
                                                               )
                                                        )
                                              AND flsl.lis_lic_number =
                                                                 fl.lic_number
                                              AND flsl.lis_lsl_number =
                                                               xfsl.lsl_number
                                         GROUP BY 'X'
                                           HAVING ROUND (SUM (cf_m_ca_p_cadj),
                                                         0
                                                        ) != 0)
                                     )
                            /*or
                            ( lic_acct_date <= LAST_DAY(i_period_date))
                            and lic_end > LAST_DAY(i_period_date)))*/
                            ORDER BY fl.lic_currency,
                                     fl.lic_type,
                                     flee.lee_short_name,
                                     fl.lic_budget_code,
                                     fc.com_short_name,
                                     fcon.con_short_name ASC,
                                     fl.lic_number ASC,
                                     fg.gen_title));

         COMMIT;
      END IF;

      IF i_report_sub_type = 'CON'
      THEN
         OPEN o_lib_rep FOR
            SELECT reg_code, com_name, lic_currency, period, ter_cur_code,
                   lic_type, lee_short_name, lic_budget_code, supplier,
                   contract, lic_number, gen_title, lic_acct_date, lic_start,
                   lic_end, lic_amort_code am_co, lic_showing_lic amo_exh,

                   --AMO_EXH_USED
                   amo_exh_rem, lic_showing_int lic_exh, lic_exh_used,LIC_PRICE,
				   (SELECT count(1) from fid_schedule fsh where fsh.sch_lic_number=lic_number and fsh.sch_type='F') as FR,			 --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                   td_exh, lic_markup_percent, fee con_fc, COST con_aa,
                   CLOSE close_markup, exchange_rate ex_rate,
                   E_CLOSE CLOSE_MARKUP2
                 FROM exl_prog_lib_val;
      ELSIF i_report_sub_type = 'ED'
      THEN
         OPEN o_lib_rep FOR
            SELECT reg_code, com_name, lic_currency, period, ter_cur_code,
                   lic_type, lee_short_name, lic_budget_code, supplier,
                   contract, lic_number, gen_title, lic_acct_date,
                   con_eff_date, lic_start, lic_end, lic_amort_code am_co,
                   lic_showing_lic amo_exh,--AMO_EXH_USED
                   amo_exh_rem,
                   LIC_SHOWING_INT LIC_EXH, LIC_EXH_USED,LIC_PRICE,
                   (SELECT count(1) from fid_schedule fsh where fsh.sch_lic_number=lic_number and fsh.sch_type='F') as FR,            	--[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
				   TD_EXH, ED_INV,
                   ed_cos, ed_close
                    FROM exl_prog_lib_val;
      ELSIF i_report_sub_type = 'PV'
      THEN
         OPEN o_lib_rep FOR
            SELECT reg_code, com_name, lic_currency, period, ter_cur_code,
                   lic_type, lee_short_name, lic_budget_code, supplier,
                   contract, lic_number, gen_title, lic_acct_date, lic_start,
                   lic_end, lic_price, lic_amort_code am_co,
                   lic_showing_lic amo_exh, --AMO_EXH_USED
                   amo_exh_rem, lic_exh_used,
                   (SELECT count(1) from fid_schedule fsh where fsh.sch_lic_number=lic_number and fsh.sch_type='F') as FR,               --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                   lic_showing_int lic_exh, td_exh, lic_markup_percent,
                   PV_CON_FC, PV_CON_AA, CLOSED_INV_PV,
                   exchange_rate ex_rate, closed_inv_pv2
			  FROM exl_prog_lib_val;
      ELSIF i_report_sub_type = 'Both'
      THEN
         OPEN o_lib_rep FOR
            SELECT reg_code, com_name, lic_currency, period, ter_cur_code,
                   lic_type, lee_short_name, lic_budget_code, supplier,
                   contract, lic_number, gen_title, lic_acct_date, lic_start,
                   lic_end, lic_amort_code am_co, lic_showing_lic amo_exh,
                   td_exh, --AMO_EXH_USED
                   amo_exh_rem, lic_showing_int lic_exh, lic_exh_used,LIC_PRICE,
				   (SELECT count(1) from fid_schedule fsh where fsh.sch_lic_number=lic_number and fsh.sch_type='F') as FR,			   --[01-Aug-2015]Jawahar.Grag[Added for Omnibus Free schedule count]
                   lic_markup_percent, fee con_fc, COST con_aa, CLOSE,

                   --close_markup
                   pv_con_fc, pv_con_aa, closed_inv_pv, total_closed_lic,
                   exchange_rate ex_rate, e_close,            --close markup2
                                                  closed_inv_pv2, ed_inv,
                   ed_cos, ed_close, total_closed_loc
              --,LIC_SHOWING_FIRST
              FROM   exl_prog_lib_val;
      END IF;
   END prc_prg_lib_valution_rep_exl;

   -- Start :Fincr new requrement for summary export to excel report (Ankur.Kasar)..
    PROCEDURE prc_prg_lib_val_sum_rep_exl (
      i_report_sub_type   IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS


   BEGIN

    IF(UPPER(i_report_sub_type) = 'CON')
    THEN
         OPEN o_lib_rep FOR
                    select
                    REGION "Region",
                    COM_NAME "Channel Company",
                    LIC_CURRENCY "Cur",
                    LIC_TYPE "Type",
                    LEE_SHORT_NAME "Licensee",
                    LIC_BUDGET_CODE "Budg",
                    NVL(sum(CON_FC),0) "Lic. Currency Fee",
                    NVL(sum(CON_AA),0) "Lic. Currency Cost",
                    NVL(sum(CLOSE_MARKUP),0) "Lic. Currency Close",
                    NVL(sum(CLOSE_MARKUP2),0) "Channel Close"
                    FROM X_SUMMARY_PROG_LIB_VAL
                    group by
                    REGION,COM_NAME,LIC_CURRENCY,LIC_TYPE,LEE_SHORT_NAME,LIC_BUDGET_CODE;

    ELSIF(UPPER(i_report_sub_type) = 'ED')
       THEN
       OPEN o_lib_rep FOR
                    select
                    REGION "Region",
                    COM_NAME "Channel Company",
                    LIC_CURRENCY "Cur",
                    LIC_TYPE "Type",
                    LEE_SHORT_NAME "Licensee",
                    LIC_BUDGET_CODE "Budg",
                    NVL(sum(CON_FC),0) "Lic.Currency Fee",
                    NVL(sum(ED_CLOSE),0) "Channel ED Close"
                    FROM X_SUMMARY_PROG_LIB_VAL
                  group by
                  REGION,COM_NAME,LIC_CURRENCY,LIC_TYPE,LEE_SHORT_NAME,LIC_BUDGET_CODE;

    ELSIF(UPPER(i_report_sub_type) = 'PV')
      THEN
       OPEN o_lib_rep FOR
                    select
                    REGION "Region",
                    COM_NAME "Channel Company",
                    LIC_CURRENCY "Cur",
                    LIC_TYPE "Type",
                    LEE_SHORT_NAME "Licensee",
                    LIC_BUDGET_CODE "Budg",
                    NVL(sum(CON_FC),0) "Lic.Currency Fee",
                    NVL(sum(PV_CON_AA),0) "Cost - PV of Creditors",
                    NVL(sum(CLOSED_INV_PV),0)  "Close - PV of Creditors",
                    NVL(sum(CLOSED_INV_PV2),0) "Cha. Close-PV of Creditors"
                    FROM X_SUMMARY_PROG_LIB_VAL
                  group by
                     REGION,COM_NAME,LIC_CURRENCY,LIC_TYPE,LEE_SHORT_NAME,LIC_BUDGET_CODE;

    ELSIF(UPPER(i_report_sub_type) = 'BOTH')
      THEN
         OPEN o_lib_rep FOR
                      select
                    REGION "Region",
                    COM_NAME "Channel Company",
                    LIC_CURRENCY "Cur",
                    LIC_TYPE "Type",
                    LEE_SHORT_NAME "Licensee",
                    LIC_BUDGET_CODE "Budg",
                    NVL(sum(CON_FC),0) "Lic. Currency Fee",
                    NVL(sum(CON_AA),0) "Lic. Currency Cost",
                    NVL(sum(CLOSE_MARKUP),0) "Lic. Currency Close",
                    NVL(sum(CLOSE_MARKUP2),0) "Loc. Currency Close",
                    NVL(sum(PV_CON_FC),0) "Cost-PV of Creditors",
                    NVL(sum(CLOSED_INV_PV),0) "Close-PV Creditors",
                    NVL(sum(CLOSED_INV_PV2),0) "Channel Close-PV Creditors",
                    NVL(sum(ED_CLOSE),0) "Channel ED Close",
                    NVL(sum(TOTAL_CLOSED_LIC),0) "Lic. Currency Total Closed",
                    NVL(sum(TOTAL_CLOSED_LOC),0)  "Loc. Currency Total Closed"
                    FROM X_SUMMARY_PROG_LIB_VAL
                  group by
                   REGION,COM_NAME,LIC_CURRENCY,LIC_TYPE,LEE_SHORT_NAME,LIC_BUDGET_CODE;

    END IF;

   END	prc_prg_lib_val_sum_rep_exl;
   -- End :Fincr new requrement for summary export to excel report (Ankur.Kasar)..
end PKG_FIN_LIB_VALUATION;
/