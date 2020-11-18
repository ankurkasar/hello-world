CREATE OR REPLACE PACKAGE PKG_FIN_MNET_LIB_VAL_REP
AS
   /**************************************************************************
   REM Module     : Finance : Library Valuation Report
   REM Client     : MNET
   REM File Name     : PKG_FIN_MNET_LIB_VAL_REP.sql
   REM Purpose     : This package is used for Library Valuation Report.
   REM Written By     : Vinayak
   REM Date     : 01-03-2010
   REM Type     : Database Package
   REM Change History :
   REM **************************************************************************/
   TYPE c_fin_rep IS REF CURSOR;

   PROCEDURE prc_prg_lib_valution_rep (
      i_chnal_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_acc_prv_rate      IN       CHAR,
      i_inc_markup        IN       CHAR,
      i_period_date       IN       DATE,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   FUNCTION ex_rate_lib_val (
      i_acc_prv_rate   CHAR,
      i_lic_currency   fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code   fid_exchange_rate.rat_cur_code_2%TYPE,
      i_lic_rate       fid_license.lic_rate%TYPE
   )
      RETURN NUMBER;

   FUNCTION con_fc (
      i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE
   )
      RETURN NUMBER;

   FUNCTION con_aa (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE
   )
      RETURN NUMBER;

   FUNCTION td_exh (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
   )
      RETURN NUMBER;

   --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
   FUNCTION td_exh_fin_ex (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
                             --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   ,
      i_lic_start        DATE,
      i_go_live_date     DATE,
      i_lic_amort_code   CHAR
   --Dev2: Pure Finance :END
   )
      RETURN NUMBER;

   FUNCTION fun_inv_mmt_report_ex_rate_ex (
      i_lic_currency       fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code       fid_exchange_rate.rat_cur_code_2%TYPE,
      i_acct_prvlng_rate   CHAR,
      i_lic_rate           fid_license.lic_rate%TYPE,
      i_lic_start          DATE,
      i_go_live_date       DATE
   )
      RETURN NUMBER;

   --Dev2: Pure Finance :End
   FUNCTION td_unpaid (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
   )
      RETURN NUMBER;

   FUNCTION td_total (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_showng (
      i_lic_currency      fid_license_vw.lic_currency%TYPE,
      i_lic_type          fid_license_vw.lic_type%TYPE,
      i_lee_short_name    fid_license_vw.lee_short_name%TYPE,
      i_lic_budget_code   fid_license_vw.lic_budget_code%TYPE,
      i_period_date       DATE
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_ob_mp (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER;

   --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   FUNCTION fun_fin_mmt_rep_ob_mp_ex (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER
                            -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
   ,
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_ob_mp_rversal (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      i_mup           CHAR,
      i_date_period   DATE
   -- ,  i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION x_fun_fin_rep_ob_mp_rversal (
      i_lic_number     fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number     NUMBER,
      i_mup            CHAR,
      i_date_period    DATE,
      i_ter_cur_code   VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_ob_mp_cancl (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      i_mup           CHAR,
      i_date_period   DATE
   -- ,  i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_revel_rversal (
      i_lic_number       fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number       NUMBER,
      i_mup              CHAR,
      i_from_date        DATE,
      i_lic_start_date   DATE,
      i_ter_code         VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION fun_rep_revel_rversal_loc (
      i_lic_number       fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number       NUMBER,
      i_mup              CHAR,
      i_from_date        DATE,
      i_lic_start_date   DATE,
      i_ter_code         VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_revel_cancl (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION fun_rep_revel_cancl_loc (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_cost_reversal (
      i_lic_number      fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number      NUMBER,
      i_mup             CHAR,
      i_lic_strt_date   DATE,
      i_to_date         DATE,
      i_ter_code        VARCHAR2
   )
      RETURN NUMBER;

   --[function for pure finance price change report requirement]
   FUNCTION fun_fin_mmt_rep_cost_fin_ex (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      i_mup           CHAR,
      i_date_period   DATE,
      i_to_date       DATE
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_revel_fin_ex (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER
                            -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
   ,
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_revel_fin_add (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION fun_rep_revel_fin_ex_local_add (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_revel_fin_roy (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION fun_rep_revel_fin_ex_local_roy (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION fun_rep_revel_fin_ex_local (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER
                            -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
   ,
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER;

   FUNCTION fun_fin_mmt_rep_cost_addn (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER
                            -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
   ,
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER;

   --Dev2: Pure Finance :End
   FUNCTION fun_fin_mmt_rep_revel (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER;

   FUNCTION fun_inv_mmt_report_ex_rate (
      i_lic_currency       fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code       fid_exchange_rate.rat_cur_code_2%TYPE,
      i_acct_prvlng_rate   CHAR,
      i_lic_rate           fid_license.lic_rate%TYPE
   )
      RETURN NUMBER;

   FUNCTION fun_inv_mmt_report_ex_rate_new (
      i_lic_currency       fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code       fid_exchange_rate.rat_cur_code_2%TYPE,
      i_acct_prvlng_rate   CHAR,
      i_lic_rate           fid_license.lic_rate%TYPE
   )
      RETURN NUMBER;

   --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   FUNCTION con_fc_prg_inv_fin_expiry (
      i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER;

   FUNCTION con_aa_prg_inv_fin_ex (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER;

   --Dev2: Pure Finance: End
   FUNCTION con_fc_prg_inv (
      i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE
   )
      RETURN NUMBER;

   FUNCTION con_aa_prg_inv (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE
   )
      RETURN NUMBER;

   FUNCTION sumcol1 (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION sumcol1_ex (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      -- DEV2 : Pure Finance : Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/4/10]
      i_lsl_number   NUMBER,
      -- DEV2 : Pure Finance : END
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER;

   FUNCTION sumcol1_ex_loc (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      -- DEV2 : Pure Finance : Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/4/10]
      i_lsl_number   NUMBER,
      -- DEV2 : Pure Finance : END
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER;

   --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [ PV and ED ]
   FUNCTION fun_sum_pv_ed_ac (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      i_from_date    DATE,
      i_to_date      DATE,
      i_type         VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION fun_sum_pv_ed_ac_loc (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      i_from_date    DATE,
      i_to_date      DATE,
      i_type         VARCHAR2
   )
      RETURN NUMBER;

   --Dev2: Pure Finance : END
   FUNCTION fun_cost_sale_sch_paid_1 (
      i_from_date      DATE,
      i_to_date        DATE,
      i_lic_number     fid_sch_summary_vw.sch_lic_number%TYPE
                                                             --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
   ,
      i_lic_start      DATE,
      i_go_live_date   DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER;

   FUNCTION fun_cost_sale_sch_paid_2 (
      l_period_date    DATE,
      i_lic_number     fid_sch_summary_vw.sch_lic_number%TYPE
                                                             --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
   ,
      i_lic_start      DATE,
      i_go_live_date   DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER;

   FUNCTION fun_cost_sale_wo_number (
      l_period_date       DATE,
      i_lic_number        fid_sch_summary_vw.sch_lic_number%TYPE,
      i_lic_showing_lic   NUMBER
                                --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
   ,
      i_lic_start         DATE,
      i_go_live_date      DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER;

   FUNCTION fun_cost_sale_this_month (
      l_from_date         DATE,
      l_to_date           DATE,
      i_lic_number        fid_sch_summary_vw.sch_lic_number%TYPE,
      i_lic_showing_lic   NUMBER
                                --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
   ,
      i_lic_start         DATE,
      i_go_live_date      DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER;

   FUNCTION fun_cost_sale_wo_percent (
      l_from_date         DATE,
      l_to_date           DATE,
      i_lic_number        fid_sch_summary_vw.sch_lic_number%TYPE,
      i_lic_showing_lic   NUMBER
                                --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
   ,
      i_lic_start         DATE,
      i_go_live_date      DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER;

   PROCEDURE prc_prg_lib_re_valution_adtn (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_markup            IN       VARCHAR2
                                           --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
   ,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE
                                       --Dev2: Pure Finance :End
   ,
      i_lic_region        IN       VARCHAR2                -- added for split
                                           ,
      i_acc_prv_rate      IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_prg_lib_re_valution_adtn_x (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_markup            IN       VARCHAR2
                                           --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
   ,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE
                                       --Dev2: Pure Finance :End
   ,
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,                -- added for split
			i_acc_prv_rate      IN       VARCHAR2
   );

   PROCEDURE prc_prg_lib_re_valution_flf (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
      -- i_period_date       IN       DATE,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      --Dev2: Pure Finance :End
      i_lic_region        IN       VARCHAR2                -- added for split
                                           ,
      i_acc_prv_rate      IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_prg_lib_re_valution_flf_x (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      -- i_period_date       IN       DATE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/4/5]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      --Dev2: Pure Finance :End
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,                -- added for split
			i_acc_prv_rate      IN       VARCHAR2
   );

   PROCEDURE prc_prg_lib_re_valu_roy_rev (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      -- i_period_date       IN       DATE,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      --Dev2: Pure Finance :End
      i_lic_region        IN       VARCHAR2                -- added for split
                                           ,
      i_acc_prv_rate      IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_prg_lib_re_valu_roy_rev_x (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      --Dev2: Pure Finance :End
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,                -- added for split
			i_acc_prv_rate      IN       VARCHAR2
   );

   PROCEDURE prc_prg_lib_re_valu_canc (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      -- Pure Finance : Ajit : 10-Apr-2013 : Instead of period, from date and
      -- to date aaded
      --i_period_date     in       date,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      -- Pure Finance :End
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,               -- added for split
      i_acc_prv_rate      IN       VARCHAR2
   );

  PROCEDURE prc_prg_lib_re_valu_canc_x (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      -- Pure Finance : Ajit : 10-Apr-2013 : Instead of period, from date and
      -- to date aaded : Start
      --i_period_date     in       date,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      -- Pure Finance :End
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,                 -- added for split
			i_acc_prv_rate      IN       VARCHAR2
   );
   /*    procedure prc_fin_moment_rep_MMT
   (
   i_chnl_comp_name    in    fid_company.com_short_name%type
   ,    i_lic_type        in    fid_license.lic_type%type
   ,    i_period_date        IN     varchar2
   ,    i_acct_prvlng_rate    in    char
   ,    o_lib_rep        OUT     PKG_FIN_MNET_LIB_VAL_REP.c_fin_rep
   );
   procedure prc_fin_moment_rep_SUM
   (
   i_chnl_comp_name    in    fid_company.com_short_name%type
   ,    i_lic_type        in    fid_license.lic_type%type
   ,    i_period_date        IN     DATE
   ,    i_acct_prvlng_rate    in    char
   ,    o_lib_rep        OUT     PKG_FIN_MNET_LIB_VAL_REP.c_fin_rep
   ); */
   PROCEDURE prc_prg_inv_exp_rep (
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_mup                IN       CHAR,
      i_acct_prvlng_rate   IN       CHAR,
      i_period_date        IN       DATE,
      i_lic_region         IN       VARCHAR2               -- added for split
                                            ,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_amo_code_c_rep (
      i_region            IN       fid_region.reg_code%TYPE,
      --Dev2: Pure Finance :Start:[RSA- AFR Month-end Split]_[ANUJASHINDE]_[2013/1/24]
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_lic_cost_bef_ac_date (
      --Dev2: Pure Finance: Start:[RSA/AFR Split]_[Manish]_[2013/03/12]
      --[added region for Excel n Report]
      i_region             IN       VARCHAR2
                                            --Dev2: Pure Finance: End
   ,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_mup                IN       CHAR,
      i_acct_prvlng_rate   IN       CHAR,
      i_period_date        IN       DATE,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_cost_sale_rpt_ty_li_bu (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                 --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_cost_sale_rpt_ty_li_bu_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                 --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_cost_sale_rpt_con (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                 --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
   PROCEDURE prc_cost_sale_rpt_con_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   --Dev2: Pure Finance : END
   PROCEDURE prc_cost_sale_rpt_sum_by_per (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                 --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/09] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
   PROCEDURE prc_cost_sale_sum_by_per_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   --Dev2: Pure Finance : END
   --PROCEDURE FOR Cost of Sales Report Write Offs FIDCOS01D.rdf
   PROCEDURE prc_cost_sale_rpt_write_offs (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                 --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/09] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
   PROCEDURE prc_cost_sale_write_offs_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   --Dev2: Pure Finance : END
   --PROCEDURE FOR Cost of Sales Report Exceptions FIDCOS01E.rdf
   PROCEDURE prc_cost_sale_rpt_exceptions (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                 --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/09] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
   PROCEDURE prc_cost_sale_exceptions_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   --Dev2: Pure Finance : END
   --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/28]
   PROCEDURE prc_lib_re_val_reversal (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_markup            IN       VARCHAR2,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_lic_region        IN       VARCHAR2,               -- added for split
      i_acc_prv_rate      IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   );

   PROCEDURE prc_lib_re_val_reversal_exl (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_markup            IN       VARCHAR2,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,
			i_acc_prv_rate      IN       VARCHAR2
   );
--Dev2: Pure Finance :End
-------swapnil
FUNCTION x_func_get_costed_runs_end_of
(	i_lic_start date
	,i_go_live_date date
	,i_lis_lic_number	number
	,i_lic_catchup_flag   fid_license.lic_catchup_flag%type
)
RETURN NUMBER;
-------swapnil
END PKG_FIN_MNET_LIB_VAL_REP;
/
CREATE OR REPLACE PACKAGE BODY PKG_FIN_MNET_LIB_VAL_REP AS
   FUNCTION ex_rate_lib_val (
      i_acc_prv_rate   CHAR,
      i_lic_currency   fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code   fid_exchange_rate.rat_cur_code_2%TYPE,
      i_lic_rate       fid_license.lic_rate%TYPE
   )
      RETURN NUMBER
   IS
      l_ex_rate   NUMBER;
   BEGIN
      IF i_acc_prv_rate = 'P'
      THEN
         BEGIN
            SELECT fer.rat_rate
              INTO l_ex_rate
              FROM fid_exchange_rate fer
             WHERE fer.rat_cur_code = i_lic_currency
               AND fer.rat_cur_code_2 = i_ter_cur_code;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_ex_rate := 1;
         END;
      ELSE
         l_ex_rate := i_lic_rate;
      END IF;

      RETURN l_ex_rate;
   END;

   FUNCTION con_fc (
      i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_con_fc_is   NUMBER;
   BEGIN
      /* BEGIN
      SELECT DECODE (i_inc_markup,
      'I', SUM (flv.lis_con_fc_imu),
      SUM (flv.lis_con_fc_emu)
      )
      INTO l_con_fc_is
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = l_lic_number
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_con_fc_is := 0;
      RETURN l_con_fc_is;
      */
      SELECT DECODE (i_inc_markup,
                     'I', SUM (flv.lis_con_fc_imu),
                     SUM (flv.lis_con_fc_emu)
                    )
        INTO l_con_fc_is
        FROM x_mv_subledger_data flv
       WHERE flv.lis_lic_number = l_lic_number
         AND flv.lis_yyyymm_num <
                                 TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN NVL (l_con_fc_is, 0);
   END con_fc;

   FUNCTION con_aa (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_con_aa_is   NUMBER;
   BEGIN
      /*SELECT DECODE (i_inc_markup,
      'I', SUM (flv.lis_con_aa_imu),
      SUM (flv.lis_con_aa_emu)
      )
      INTO l_con_aa_is
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = i_lic_number
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM')); */
      SELECT DECODE (i_inc_markup,
                     'I', SUM (lis_con_aa_imu_23),
                     SUM (lis_con_aa_emu_23)
                    )
        INTO l_con_aa_is
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_yyyymm_num < TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN l_con_aa_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_con_aa_is := 0;
         RETURN l_con_aa_is;
   END;

/*  Paid Amount */
   FUNCTION td_exh (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
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
                                     sch_paid
                                    )),
                        0
                       )
              INTO l_td_exh
              FROM fid_sch_summary_vw fsv, fid_license fl
             WHERE fsv.sch_lic_number = fl.lic_number
               AND fsv.sch_year || LPAD (fsv.sch_month, 2, 0) <=
                                 TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
               AND fsv.sch_lic_number = l_sch_lic_number;
         /*SELECT    NVL(SUM(sch_paid),0)
         into     l_TD_Exh
         FROM     fid_sch_summary_vw
         WHERE      sch_year||lpad(sch_month,2,0) <= to_number(to_char(i_period_date,'YYYYMM'))
         AND     sch_lic_number = l_sch_lic_number
         ;*/
         ELSE
            l_td_exh := NULL;
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

--Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   FUNCTION td_exh_fin_ex (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
                             --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   ,
      i_lic_start        DATE,
      i_go_live_date     DATE,
      i_lic_amort_code   CHAR
   --Dev2: Pure Finance :END
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
            IF ((i_lic_start < i_go_live_date) AND (i_lic_amort_code = 'C')
               )
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
                                 TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
                  AND fsv.sch_lic_number = l_sch_lic_number;
            --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
            ELSE
               SELECT COUNT (xfcs.csh_lic_number)
                 INTO l_td_exh
                 FROM x_fin_cost_schedules xfcs
                WHERE xfcs.csh_lic_number = l_sch_lic_number
                  AND xfcs.csh_year || LPAD (xfcs.csh_month, 2, 0) <=
                                 TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
            END IF;
         ELSE
            l_td_exh := NULL;
         END IF;

         --Dev2: Pure Finance :END
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
   END td_exh_fin_ex;

--Dev2: Pure Finance :End
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
                                 TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
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

/*  Total Amount */
   FUNCTION td_total (
      l_sch_lic_number   fid_sch_summary_vw.sch_lic_number%TYPE,
      i_period_date      DATE
   )
      RETURN NUMBER
   AS
      l_td_exh   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (DECODE (fl.lic_catchup_flag, 'Y', NULL, sch_total))
           INTO l_td_exh
           FROM fid_sch_summary_vw fsv, fid_license fl
          WHERE fsv.sch_lic_number = fl.lic_number
            AND fsv.sch_year || LPAD (fsv.sch_month, 2, 0) <=
                                 TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
            AND fsv.sch_lic_number = l_sch_lic_number;
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

   FUNCTION fun_fin_mmt_rep_showng (
      i_lic_currency      fid_license_vw.lic_currency%TYPE,
      i_lic_type          fid_license_vw.lic_type%TYPE,
      i_lee_short_name    fid_license_vw.lee_short_name%TYPE,
      i_lic_budget_code   fid_license_vw.lic_budget_code%TYPE,
      i_period_date       DATE
   )
      RETURN NUMBER
   AS
      l_showing   NUMBER;
   BEGIN
      BEGIN
         SELECT SUM (fsv.sch_paid)
           INTO l_showing
           FROM fid_sch_summary_vw fsv
          WHERE fsv.sch_year || LPAD (fsv.sch_month, 2, 0) =
                       TO_NUMBER (TO_CHAR (TO_DATE (i_period_date), 'YYYYMM'))
            AND fsv.sch_lic_number IN (
                   SELECT flvw.lic_number
                     FROM fid_license_vw flvw
                    WHERE flvw.lic_currency = i_lic_currency
                      AND flvw.lic_type = i_lic_type
                      AND flvw.lee_short_name = i_lee_short_name
                      AND flvw.lic_budget_code = i_lic_budget_code);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_showing := 0;
      END;

      IF l_showing IS NULL
      THEN
         l_showing := 0;
      END IF;

      RETURN l_showing;
   END fun_fin_mmt_rep_showng;

   FUNCTION fun_fin_mmt_rep_ob_mp (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_con_fc_is     NUMBER;
      l_con_aa_is     NUMBER;
      l_con_fc_p_aa   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT DECODE (i_mup,
      'I', SUM (flv.lis_con_fc_imu),
      SUM (flv.lis_con_fc_emu)
      )
      INTO l_con_fc_is
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = i_lic_number
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
      SELECT DECODE (i_mup,
      'I', SUM (flv.lis_con_aa_imu),
      SUM (flv.lis_con_aa_emu)
      )
      INTO l_con_aa_is
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = i_lic_number
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_con_fc_is := 0;
      END;
      */
      SELECT CASE i_mup
                WHEN 'I'
                   THEN (SUM (lis_con_fc_imu) - SUM (lis_con_aa_imu_23))
                ELSE (SUM (lis_con_fc_emu) - SUM (lis_con_aa_emu_23))
             END
        INTO l_con_fc_p_aa
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_yyyymm_num < TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      --RETURN NVL (l_con_fc_is, 0) - NVL (l_con_aa_is, 0);
      RETURN NVL (l_con_fc_p_aa, 0);
   END;

   FUNCTION fun_fin_mmt_rep_ob_mp_ex (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      -- [Pure Finance: Start : Anuja Shinde[2013/03/27]]
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_con_fc_is     NUMBER;
      l_con_aa_is     NUMBER;
      l_con_fc_p_aa   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT DECODE (i_mup,
      'I', SUM (flv.lis_con_fc_imu),
      SUM (flv.lis_con_fc_emu)
      )
      INTO l_con_fc_is
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = i_lic_number
      AND flv.lis_lsl_number = i_lsl_number
      -- [Pure Finance: Start : Anuja Shinde[2013/03/27]]
      AND flv.lis_per_year || LPAD (lis_per_month, 2, 0) <
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
      SELECT DECODE (i_mup,
      'I', SUM (flv.lis_con_aa_imu),
      SUM (flv.lis_con_aa_emu)
      )
      INTO l_con_aa_is
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = i_lic_number
      AND flv.lis_lsl_number = i_lsl_number
      -- [Pure Finance: Start : Anuja Shinde[2013/03/27]]
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_con_fc_is := 0;
      END;*/
      --RETURN NVL (l_con_fc_is, 0) - NVL (l_con_aa_is, 0);
      SELECT CASE i_mup
                WHEN 'I'
                   THEN (SUM (lis_con_fc_imu) - SUM (lis_con_aa_imu_23))
                ELSE (SUM (lis_con_fc_emu) - SUM (lis_con_aa_emu_23))
             END
        INTO l_con_fc_p_aa
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num < TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN NVL (l_con_fc_p_aa, 0);
   END fun_fin_mmt_rep_ob_mp_ex;

   FUNCTION fun_fin_mmt_rep_ob_mp_rversal (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      -- [Pure Finance: Start : Anuja Shinde[2013/03/27]]
      i_mup           CHAR,
      i_date_period   DATE
   )
      RETURN NUMBER
   AS
      l_con_fc_is   NUMBER;
      l_con_aa_is   NUMBER;
      v_date        DATE;
      v_lic_strt    DATE;
      l_con_fc_aa   NUMBER;
   BEGIN
      /*BEGIN
      SELECT   DECODE (i_mup,
      'I', SUM (ROUND (  ROUND (SUM (flsl.lis_con_forecast), 2)
      * (  (  100
      + NVL (fl.lic_markup_percent, 0)
      )
      / 100
      ),
      2
      )
      ),
      SUM (ROUND (SUM (flsl.lis_con_forecast), 2))
      )
      INTO l_con_fc_is
      FROM fid_license_sub_ledger flsl, fid_license fl
      WHERE fl.lic_number = flsl.lis_lic_number
      AND flsl.lis_lic_number = i_lic_number
      AND flsl.lis_lsl_number = i_lsl_number
      --AND     LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) <= TO_NUMBER(TO_CHAR(v_date,'YYYYMM'));
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <
      TO_NUMBER (TO_CHAR (i_date_period, 'YYYYMM'))
      GROUP BY flsl.lis_con_forecast, fl.lic_markup_percent;
      SELECT   DECODE
      (i_mup,
      'I', NVL
      (SUM (ROUND (  ROUND (SUM ((  NVL (flsl.lis_con_actual,
      0)
      + NVL (flsl.lis_con_adjust,
      0)
      + NVL (flsl.lis_con_writeoff,
      0
      )
      )
      ),
      2
      )
      * (  (100 + NVL (fl.lic_markup_percent, 0)
      )
      / 100
      ),
      2
      )
      ),
      0
      ),
      NVL (SUM (ROUND (SUM ((  NVL (flsl.lis_con_actual, 0)
      + NVL (flsl.lis_con_adjust, 0)
      + NVL (flsl.lis_con_writeoff, 0)
      )
      ),
      2
      )
      ),
      0
      )
      )
      INTO l_con_aa_is
      FROM fid_license_sub_ledger flsl, fid_license fl
      WHERE fl.lic_number = flsl.lis_lic_number
      AND flsl.lis_lic_number = i_lic_number
      AND flsl.lis_lsl_number = i_lsl_number
      --AND     LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) <= TO_NUMBER(TO_CHAR(v_date,'YYYYMM'));
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <
      TO_NUMBER (TO_CHAR (i_date_period, 'YYYYMM'))
      GROUP BY fl.lic_markup_percent,
      flsl.lis_con_actual,
      flsl.lis_con_adjust,
      flsl.lis_con_writeoff;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_con_fc_is := 0;
      l_con_aa_is := 0;
      END;
      RETURN NVL (l_con_fc_is, 0) - NVL (l_con_aa_is, 0);*/
      --RETURN NVL (l_con_fc_is, 0);
      SELECT   DECODE (i_mup,
                       'I', SUM (lis_con_fc_imu),
                       SUM (lis_con_fc_emu)
                      )
             - DECODE (i_mup,
                       'I', SUM (lis_con_aa_imu_23),
                       SUM (lis_con_aa_emu_23)
                      )
        INTO l_con_fc_aa
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num < TO_NUMBER (TO_CHAR (i_date_period, 'YYYYMM'));

      RETURN NVL (l_con_fc_aa, 0);
   END fun_fin_mmt_rep_ob_mp_rversal;

   FUNCTION x_fun_fin_rep_ob_mp_rversal (
      i_lic_number     fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number     NUMBER,
      -- [Pure Finance: Start : Anuja Shinde[2013/03/27]]
      i_mup            CHAR,
      i_date_period    DATE,
      i_ter_cur_code   VARCHAR2
   )
      RETURN NUMBER
   AS
      l_con_fc_is   NUMBER;
      l_con_aa_is   NUMBER;
      v_date        DATE;
      v_lic_strt    DATE;
   BEGIN
      BEGIN
         SELECT   DECODE (i_mup,
                          'I', SUM (ROUND (  ROUND (SUM (lis_con_forecast), 2)
                                           * (  (  100
                                                 + NVL (lic_markup_percent, 0)
                                                )
                                              / 100
                                             ),
                                           2
                                          )
                                   ),
                          SUM (ROUND (SUM (lis_con_forecast), 2))
                         )
             INTO l_con_fc_is
             FROM fid_license_sub_ledger, fid_license
            WHERE lic_number = lis_lic_number
              AND lis_lic_number = i_lic_number
              AND lis_lsl_number = i_lsl_number
              AND lis_ter_code = i_ter_cur_code
              --AND     LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) <= TO_NUMBER(TO_CHAR(v_date,'YYYYMM'));
              AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                                 TO_NUMBER (TO_CHAR (i_date_period, 'YYYYMM'))
         GROUP BY lis_con_forecast, lic_markup_percent;

         SELECT   DECODE
                     (i_mup,
                      'I', NVL
                          (SUM (ROUND (  ROUND (SUM ((  NVL (lis_con_actual,
                                                             0)
                                                      + NVL (lis_con_adjust,
                                                             0)
                                                      + NVL (lis_con_writeoff,
                                                             0
                                                            )
                                                     )
                                                    ),
                                                2
                                               )
                                       * (  (100 + NVL (lic_markup_percent, 0)
                                            )
                                          / 100
                                         ),
                                       2
                                      )
                               ),
                           0
                          ),
                      NVL (SUM (ROUND (SUM ((  NVL (lis_con_actual, 0)
                                             + NVL (lis_con_adjust, 0)
                                             + NVL (lis_con_writeoff, 0)
                                            )
                                           ),
                                       2
                                      )
                               ),
                           0
                          )
                     )
             INTO l_con_aa_is
             FROM fid_license_sub_ledger, fid_license
            WHERE lic_number = lis_lic_number
              AND lis_lic_number = i_lic_number
              AND lis_ter_code = i_ter_cur_code
              AND lis_lsl_number = i_lsl_number
              --AND     LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) <= TO_NUMBER(TO_CHAR(v_date,'YYYYMM'));
              AND lis_per_year || LPAD (lis_per_month, 2, 0) <
                                 TO_NUMBER (TO_CHAR (i_date_period, 'YYYYMM'))
         GROUP BY lic_markup_percent,
                  lis_con_actual,
                  lis_con_adjust,
                  lis_con_writeoff;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_con_fc_is := 0;
            l_con_aa_is := 0;
      END;

      RETURN NVL (l_con_fc_is, 0) - NVL (l_con_aa_is, 0);
   --RETURN NVL (l_con_fc_is, 0);
   END x_fun_fin_rep_ob_mp_rversal;

   FUNCTION fun_fin_mmt_rep_ob_mp_cancl (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      -- [Pure Finance: Start : Anuja Shinde[2013/03/27]]
      i_mup           CHAR,
      i_date_period   DATE
   )
      RETURN NUMBER
   AS
      l_con_fc_is   NUMBER;
      v_date        DATE;
      v_lic_strt    DATE;
   BEGIN
      /*BEGIN
      SELECT   DECODE (i_mup,
      'I', SUM (ROUND (  ROUND (SUM (flsl.lis_con_forecast), 2)
      * (  (  100
      + NVL (fl.lic_markup_percent, 0)
      )
      / 100
      ),
      2
      )
      ),
      SUM (ROUND (SUM (flsl.lis_con_forecast), 2))
      )
      INTO l_con_fc_is
      FROM fid_license_sub_ledger flsl, fid_license fl
      WHERE fl.lic_number = flsl.lis_lic_number
      AND flsl.lis_lic_number = i_lic_number
      AND flsl.lis_lsl_number = i_lsl_number
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <
      TO_NUMBER (TO_CHAR (fl.lic_cancel_date, 'YYYYMM'))
      GROUP BY flsl.lis_con_forecast, fl.lic_markup_percent;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_con_fc_is := 0;
      END; */
      SELECT DECODE (i_mup,
                     'I', ROUND (SUM (lis_con_fc_imu), 2),
                     ROUND (SUM (lis_con_fc_emu), 2)
                    )
        INTO l_con_fc_is
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num <
                     (SELECT TO_NUMBER (TO_CHAR (lic_cancel_date, 'YYYYMM'))
                        FROM fid_license
                       WHERE lic_number = i_lic_number);

      --return nvl(l_con_fc_is,0)  - nvl(l_con_aa_is,0) ;
      RETURN NVL (l_con_fc_is, 0);
   END fun_fin_mmt_rep_ob_mp_cancl;

   FUNCTION fun_fin_mmt_rep_revel_rversal (
      i_lic_number       fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number       NUMBER,
      i_mup              CHAR,
      i_from_date        DATE,
      i_lic_start_date   DATE,
      i_ter_code         VARCHAR2
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      BEGIN
         SELECT   DECODE (i_mup,
                          'I',
                               /*sum*/
                          ( ROUND (  ROUND (SUM (flsl.lis_con_forecast), 2)
                                   * (  (100 + NVL (fl.lic_markup_percent, 0)
                                        )
                                      / 100
                                     ),
                                   2
                                  )
                           ),
                          ROUND (SUM (flsl.lis_con_forecast), 2)
                         )
             INTO l_revel
             FROM fid_license_sub_ledger flsl, fid_license fl
            WHERE fl.lic_number = i_lic_number
              AND flsl.lis_lic_number = fl.lic_number
              AND flsl.lis_lsl_number = i_lsl_number
              AND flsl.lis_ter_code = i_ter_code
              AND flsl.lis_con_forecast < 0          -- for negative inventory
              AND TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM')) >=
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
              AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) =
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         GROUP BY fl.lic_markup_percent;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_revel := 0;
      END;

      RETURN NVL (l_revel, 0);
   END fun_fin_mmt_rep_revel_rversal;

   FUNCTION fun_rep_revel_rversal_loc (
      i_lic_number       fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number       NUMBER,
      i_mup              CHAR,
      i_from_date        DATE,
      i_lic_start_date   DATE,
      i_ter_code         VARCHAR2
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      BEGIN
         SELECT   DECODE (i_mup,
                          'I',
                               /*sum*/
                          ( ROUND (  ROUND (SUM (lis_loc_forecast), 2)
                                   * (  (100 + NVL (lic_markup_percent, 0))
                                      / 100
                                     ),
                                   2
                                  )
                           ),
                          ROUND (SUM (lis_loc_forecast), 2)
                         )
             INTO l_revel
             FROM fid_license_sub_ledger, fid_license
            WHERE lic_number = i_lic_number
              AND lis_lic_number = lic_number
              AND lis_lsl_number = i_lsl_number
              AND lis_ter_code = i_ter_code
              AND lis_loc_forecast < 0               -- for negative inventory
              AND TO_NUMBER (TO_CHAR (lic_start, 'YYYYMM')) >=
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
              AND lis_per_year || LPAD (lis_per_month, 2, 0) =
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         GROUP BY lic_markup_percent;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_revel := 0;
      END;

      RETURN NVL (l_revel, 0);
   END fun_rep_revel_rversal_loc;

   FUNCTION fun_fin_mmt_rep_revel_cancl (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      /* BEGIN
      SELECT   DECODE (i_mup,
      'I', /*sum* / (ROUND (  ROUND (SUM (flsl.lis_con_forecast),
      2
      )
      * (  (  100
      + NVL
      (fl.lic_markup_percent,
      0
      )
      )
      / 100
      ),
      2
      )
      ),
      ROUND (SUM (flsl.lis_con_forecast), 2)
      )
      INTO l_revel
      FROM fid_license_sub_ledger flsl, fid_license fl
      WHERE fl.lic_number = i_lic_number
      AND flsl.lis_lic_number = fl.lic_number
      AND flsl.lis_lsl_number = i_lsl_number
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0)
      BETWEEN TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
      AND TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
      GROUP BY fl.lic_markup_percent;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_revel := 0;
      END;   */
      SELECT DECODE (i_mup,
                     'I', ROUND (SUM (lis_con_fc_imu), 2),
                     ROUND (SUM (lis_con_fc_emu), 2)
                    )
        INTO l_revel
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'));

      RETURN NVL (l_revel, 0);
   END fun_fin_mmt_rep_revel_cancl;

   FUNCTION fun_rep_revel_cancl_loc (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      /*BEGIN
      SELECT   DECODE (i_mup,
      'I', /*sum* / (ROUND (  ROUND (SUM (lis_loc_forecast),
      2
      )
      * (  (  100
      + NVL
      (lic_markup_percent,
      0
      )
      )
      / 100
      ),
      2
      )
      ),
      ROUND (SUM (lis_loc_forecast), 2)
      )
      INTO l_revel
      FROM fid_license_sub_ledger, fid_license
      WHERE lic_number = i_lic_number
      AND lis_lic_number = lic_number
      AND lis_lsl_number = i_lsl_number
      AND lis_per_year || LPAD (lis_per_month, 2, 0)
      BETWEEN TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
      AND TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
      GROUP BY lic_markup_percent;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_revel := 0;
      END; */
      SELECT DECODE (i_mup,
                     'I', ROUND (SUM (lis_loc_fc_mu_100), 2),
                     ROUND (SUM (lis_loc_forecast), 2)
                    )
        INTO l_revel
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'));

      RETURN NVL (l_revel, 0);
   END fun_rep_revel_cancl_loc;

   FUNCTION fun_fin_mmt_rep_revel_fin_ex (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      /*BEGIN
      SELECT DECODE (i_mup,
      'I', SUM (flv.lis_con_fc_imu),
      SUM (flv.lis_con_fc_emu)
      )
      INTO l_revel
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = i_lic_number
      AND flv.lis_lsl_number = i_lsl_number
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) =
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_revel := 0;
      END; */
      SELECT DECODE (i_mup,
                     'I', SUM (flv.lis_con_fc_imu),
                     SUM (flv.lis_con_fc_emu)
                    )
        INTO l_revel
        FROM x_mv_subledger_data flv
       WHERE flv.lis_lic_number = i_lic_number
         AND flv.lis_lsl_number = i_lsl_number
         AND flv.lis_yyyymm_num =
                                 TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN NVL (l_revel, 0);
   END fun_fin_mmt_rep_revel_fin_ex;

   FUNCTION fun_fin_mmt_rep_revel_fin_add (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT   DECODE (i_mup,
      'I', SUM (flsl.lis_con_forecast),
      SUM (flsl.lis_con_forecast)
      )
      INTO l_revel
      FROM fid_license_sub_ledger flsl, fid_license fl
      WHERE flsl.lis_lic_number = i_lic_number
      AND fl.lic_number = flsl.lis_lic_number
      AND flsl.lis_lsl_number = i_lsl_number
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0)
      BETWEEN TO_CHAR (i_from_date, 'YYYYMM')
      AND TO_CHAR (i_to_date, 'YYYYMM')
      AND (   flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) =
      TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM'))
      OR flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) =
      TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
      )
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <>
      TO_CHAR (NVL (fl.lic_cancel_date, '31-dec-2199'), 'YYYYMM')
      GROUP BY flsl.lis_lic_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_revel := 0;
      END;  */
      /*SELECT DECODE (i_mup,
                     'I', SUM (flsl.lis_con_fc_emu),
                     SUM (flsl.lis_con_fc_emu)
                    )
        INTO l_revel
        FROM x_mv_subledger_data flsl, fid_license fl
       WHERE flsl.lis_lic_number = i_lic_number
         AND flsl.lis_lsl_number = i_lsl_number
         AND flsl.lis_lic_number = fl.lic_number
         AND flsl.lis_yyyymm_num >=
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
         AND (   flsl.lis_yyyymm_num =
                              TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM'))
              OR flsl.lis_yyyymm_num =
                                  TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
             )
         AND flsl.lis_yyyymm_num <>
                TO_NUMBER (TO_CHAR (NVL (fl.lic_cancel_date, '31-dec-2199'),
                                    'YYYYMM'
                                   )
                          );*/

      SELECT DECODE (i_mup,
                     'I', SUM (flsl.lis_con_fc_emu),
                     SUM (flsl.lis_con_fc_emu)
                    )
        INTO l_revel
        FROM x_mv_subledger_data flsl
       WHERE flsl.lis_lic_number = i_lic_number
         AND flsl.lis_lsl_number = i_lsl_number
	 AND flsl.lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
	 AND flsl.lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'));

      RETURN NVL (l_revel, 0);
   END fun_fin_mmt_rep_revel_fin_add;

   FUNCTION fun_rep_revel_fin_ex_local (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      /* BEGIN
      SELECT DECODE (i_mup,
      'I', SUM (flsl.lis_loc_forecast),
      SUM (flsl.lis_loc_forecast)
      )
      INTO l_revel
      FROM fid_license_sub_ledger flsl, fid_license fl
      WHERE flsl.lis_lic_number = i_lic_number
      AND flsl.lis_lsl_number = i_lsl_number
      AND fl.lic_number = flsl.lis_lic_number
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) =
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_revel := 0;
      END;
      */
      SELECT DECODE (i_mup,
                     'I', SUM (lis_loc_fc_emu_23),
                     SUM (lis_loc_fc_emu_23)
                    )
        INTO l_revel
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num = TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN NVL (l_revel, 0);
   END fun_rep_revel_fin_ex_local;

   FUNCTION fun_rep_revel_fin_ex_local_add (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT   DECODE (i_mup,
      'I', SUM (flsl.lis_loc_forecast),
      SUM (flsl.lis_loc_forecast)
      )
      INTO l_revel
      FROM fid_license_sub_ledger flsl, fid_license fl
      WHERE flsl.lis_lic_number = i_lic_number
      AND fl.lic_number = flsl.lis_lic_number
      AND flsl.lis_lsl_number = i_lsl_number
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0)
      BETWEEN TO_CHAR (i_from_date, 'YYYYMM')
      AND TO_CHAR (i_to_date, 'YYYYMM')
      AND (   flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) =
      TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM'))
      OR flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) =
      TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
      )
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <>
      TO_CHAR (NVL (fl.lic_cancel_date, '31-dec-2199'), 'YYYYMM')
      GROUP BY flsl.lis_lic_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_revel := 0;
      END;*/
      /*SELECT DECODE (i_mup,
                     'I', SUM (flsl.lis_loc_fc_emu_23),
                     SUM (flsl.lis_loc_fc_emu_23)
                    )
        INTO l_revel
        FROM x_mv_subledger_data flsl, fid_license fl
       WHERE flsl.lis_lic_number = i_lic_number
         AND flsl.lis_lsl_number = i_lsl_number
         AND flsl.lis_lic_number = fl.lic_number
         AND flsl.lis_yyyymm_num >=
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
         AND (   flsl.lis_yyyymm_num =
                              TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM'))
              OR flsl.lis_yyyymm_num =
                                  TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
             )
         AND flsl.lis_yyyymm_num <>
                TO_NUMBER (TO_CHAR (NVL (fl.lic_cancel_date, '31-dec-2199'),
                                    'YYYYMM'
                                   )
                          );*/

      SELECT DECODE (i_mup,
                     'I', SUM (flsl.lis_loc_fc_emu_23),
                     SUM (flsl.lis_loc_fc_emu_23)
                    )
        INTO l_revel
        FROM x_mv_subledger_data flsl
       WHERE flsl.lis_lic_number = i_lic_number
         AND flsl.lis_lsl_number = i_lsl_number

         AND flsl.lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND flsl.lis_yyyymm_num <= TO_NUMBER(TO_CHAR (i_to_date, 'YYYYMM'));

      RETURN NVL (l_revel, 0);
   END fun_rep_revel_fin_ex_local_add;

   FUNCTION fun_fin_mmt_rep_cost_addn (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_cost   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT DECODE (i_mup,
      'I', SUM (flv.lis_con_aa_imu),
      SUM (flv.lis_con_aa_emu)
      )
      INTO l_cost
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = i_lic_number
      AND flv.lis_lsl_number = i_lsl_number
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) =
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_cost := 0;
      END; */
      SELECT DECODE (i_mup,
                     'I', SUM (lis_con_aa_imu_23),
                     SUM (lis_con_aa_emu_23)
                    )
        INTO l_cost
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num = TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN NVL (l_cost, 0);
   END;

   FUNCTION fun_fin_mmt_rep_revel_fin_roy (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT   DECODE (i_mup,
      'I', SUM (flsl.lis_con_forecast),
      SUM (flsl.lis_con_forecast)
      )
      INTO l_revel
      FROM fid_license_sub_ledger flsl, fid_license fl
      WHERE flsl.lis_lic_number = i_lic_number
      AND fl.lic_number = flsl.lis_lic_number
      AND flsl.lis_lsl_number = i_lsl_number
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0)
      BETWEEN TO_CHAR (i_from_date, 'YYYYMM')
      AND TO_CHAR (i_to_date, 'YYYYMM')
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <>
      TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM'))
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <>
      TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <>
      TO_CHAR (NVL (fl.lic_cancel_date, '31-dec-2199'), 'YYYYMM')
      GROUP BY flsl.lis_lic_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_revel := 0;
      END;
      */
      SELECT DECODE (i_mup,
                     'I', SUM (mvlsl.lis_con_fc_emu),
                     SUM (mvlsl.lis_con_fc_emu)
                    )
        INTO l_revel
        FROM x_mv_subledger_data mvlsl, fid_license fl
       WHERE mvlsl.lis_lic_number = i_lic_number
         AND mvlsl.lis_lsl_number = i_lsl_number
         AND mvlsl.lis_lic_number = fl.lic_number
         AND mvlsl.lis_yyyymm_num >=
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
         AND mvlsl.lis_yyyymm_num <>
                              TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM'))
         AND mvlsl.lis_yyyymm_num <>
                                  TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
         AND mvlsl.lis_yyyymm_num <>
                TO_NUMBER (TO_CHAR (NVL (fl.lic_cancel_date, '31-dec-2199'),
                                    'YYYYMM'
                                   )
                          );

      RETURN NVL (l_revel, 0);
   END fun_fin_mmt_rep_revel_fin_roy;

   FUNCTION fun_rep_revel_fin_ex_local_roy (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup          CHAR,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT   DECODE (i_mup,
      'I', SUM (flsl.lis_loc_forecast),
      SUM (flsl.lis_loc_forecast)
      )
      INTO l_revel
      FROM fid_license_sub_ledger flsl, fid_license fl
      WHERE flsl.lis_lic_number = i_lic_number
      AND fl.lic_number = flsl.lis_lic_number
      AND flsl.lis_lsl_number = i_lsl_number
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0)
      BETWEEN TO_CHAR (i_from_date, 'YYYYMM')
      AND TO_CHAR (i_to_date, 'YYYYMM')
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <>
      TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM'))
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <>
      TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
      AND flsl.lis_per_year || LPAD (flsl.lis_per_month, 2, 0) <>
      TO_CHAR (NVL (fl.lic_cancel_date, '31-dec-2199'), 'YYYYMM')
      GROUP BY flsl.lis_lic_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_revel := 0;
      END; */
      SELECT DECODE (i_mup,
                     'I', SUM (flsl.lis_loc_forecast),
                     SUM (flsl.lis_loc_forecast)
                    )
        INTO l_revel
        FROM x_mv_subledger_data flsl, fid_license fl
       WHERE flsl.lis_lic_number = i_lic_number
         AND flsl.lis_lsl_number = i_lsl_number
         AND flsl.lis_lic_number = fl.lic_number
         AND flsl.lis_yyyymm_num >=
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
         AND flsl.lis_yyyymm_num <>
                              TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM'))
         AND flsl.lis_yyyymm_num <>
                                  TO_NUMBER (TO_CHAR (fl.lic_start, 'YYYYMM'))
         AND flsl.lis_yyyymm_num <>
                TO_NUMBER (TO_CHAR (NVL (fl.lic_cancel_date, '31-dec-2199'),
                                    'YYYYMM'
                                   )
                          );

      RETURN NVL (l_revel, 0);
   END fun_rep_revel_fin_ex_local_roy;

--[Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   FUNCTION fun_fin_mmt_rep_cost_reversal (
      i_lic_number      fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number      NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup             CHAR,
      i_lic_strt_date   DATE,
      i_to_date         DATE,
      i_ter_code        VARCHAR2
   )
      RETURN NUMBER
   AS
      l_cost   NUMBER;
      v_date   DATE;
   BEGIN
      --BEGIN
      IF TO_CHAR (i_lic_strt_date, 'YYYYMM') < TO_CHAR (i_to_date, 'YYYYMM')
      THEN
         v_date := i_lic_strt_date;
      ELSE
         v_date := i_to_date;
      END IF;

      /*
      SELECT DECODE (i_mup,
      'I', SUM (lis_con_aa_imu),
      SUM (lis_con_aa_emu)
      )
      INTO l_cost
      FROM fid_lis_vw flv, fid_license_sub_ledger flsl
      WHERE flsl.lis_lic_number = flv.lis_lic_number
      AND flsl.lis_lsl_number = flv.lis_lsl_number
      AND flv.lis_lic_number = i_lic_number
      AND flsl.lis_ter_code = i_ter_code
      AND flv.lis_lsl_number = i_lsl_number
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) =
      TO_NUMBER (TO_CHAR (v_date, 'YYYYMM'));
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_cost := 0;
      END;
      */
      SELECT DECODE (i_mup,
                     'I', SUM (mvlsl.lis_con_aa_imu_23),
                     SUM (mvlsl.lis_con_aa_emu_23)
                    )
        INTO l_cost
        FROM x_mv_subledger_data mvlsl, fid_license_sub_ledger flsl
       WHERE mvlsl.lis_lic_number = flsl.lis_lic_number
         AND mvlsl.lis_lsl_number = flsl.lis_lsl_number
         AND mvlsl.lis_lic_number = i_lic_number
         AND flsl.lis_ter_code = i_ter_code
         AND mvlsl.lis_lsl_number = i_lsl_number
         AND mvlsl.lis_yyyymm_num = TO_NUMBER (TO_CHAR (v_date, 'YYYYMM'));

      RETURN NVL (l_cost, 0);
   END fun_fin_mmt_rep_cost_reversal;

--[Pure Finance] :End
--[Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
--[function for flf price change report]
   FUNCTION fun_fin_mmt_rep_cost_fin_ex (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number    NUMBER,
      -- [Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]]
      i_mup           CHAR,
      i_date_period   DATE,
      i_to_date       DATE
   )
      RETURN NUMBER
   AS
      l_cost   NUMBER;
      v_date   DATE;
   BEGIN
      /*BEGIN
      /* IF to_char(i_lic_strt_date,'YYYYMM') < to_char(i_to_date,'YYYYMM')
      THEN
      v_date := i_lic_strt_date;
      ELSE
      v_date := i_to_date;
      End if;* /
      SELECT DECODE (i_mup,
      'I', SUM (flv.lis_con_aa_imu),
      SUM (flv.lis_con_aa_emu)
      )
      INTO l_cost
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = i_lic_number
      AND flv.lis_lsl_number = i_lsl_number
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0)
      BETWEEN TO_NUMBER (TO_CHAR (i_date_period, 'YYYYMM'))
      AND TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'));
      --[for condition <= to_date ]
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_cost := 0;
      END; */
      SELECT DECODE (i_mup,
                     'I', SUM (lis_con_aa_imu_23),
                     SUM (lis_con_aa_emu_23)
                    )
        INTO l_cost
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_date_period, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'));

      RETURN NVL (l_cost, 0);
   END fun_fin_mmt_rep_cost_fin_ex;

   FUNCTION fun_fin_mmt_rep_revel (
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_mup           CHAR,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_revel   NUMBER;
   BEGIN
      /*BEGIN
      SELECT DECODE (i_mup,
      'I', SUM (flv.lis_con_fc_imu),
      SUM (flv.lis_con_fc_emu)
      )
      INTO l_revel
      FROM fid_lis_vw flv
      WHERE flv.lis_lic_number = i_lic_number
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) =
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_revel := 0;
      END;
      */
      SELECT DECODE (i_mup, 'I', SUM (lis_con_fc_imu), SUM (lis_con_fc_emu))
        INTO l_revel
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_yyyymm_num = TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN NVL (l_revel, 0);
   END fun_fin_mmt_rep_revel;

   FUNCTION fun_inv_mmt_report_ex_rate (
      i_lic_currency       fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code       fid_exchange_rate.rat_cur_code_2%TYPE,
      i_acct_prvlng_rate   CHAR,
      i_lic_rate           fid_license.lic_rate%TYPE
   )
      RETURN NUMBER
   AS
      l_ex_rate   NUMBER;

      CURSOR get_prevailing_rate
      IS
         SELECT fer.rat_rate
           FROM fid_exchange_rate fer
          WHERE fer.rat_cur_code = i_lic_currency
            AND fer.rat_cur_code_2 = i_ter_cur_code;
   BEGIN
      IF i_acct_prvlng_rate = 'P'
      THEN
         OPEN get_prevailing_rate;

         FETCH get_prevailing_rate
          INTO l_ex_rate;

         IF get_prevailing_rate%NOTFOUND
         THEN
            l_ex_rate := 1;
         END IF;
      ELSE
         l_ex_rate := i_lic_rate;
      END IF;

      RETURN l_ex_rate;
   END;

--NEW
   FUNCTION con_fc_prg_inv (
      i_inc_markup    CHAR,
      l_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_con_fc_is   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT DECODE (i_inc_markup,
      'I', SUM (flv.lis_con_fc_imu),
      SUM (flv.lis_con_fc_emu)
      )
      INTO l_con_fc_is
      FROM fid_lis_vw flv
      WHERE flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
      AND flv.lis_lic_number = l_lic_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_con_fc_is := 0;
      END;
      IF l_con_fc_is IS NULL
      THEN
      l_con_fc_is := 0;
      END IF;
      */
      SELECT DECODE (i_inc_markup,
                     'I', SUM (lis_con_fc_imu),
                     SUM (lis_con_fc_emu)
                    )
        INTO l_con_fc_is
        FROM x_mv_subledger_data
       WHERE lis_lic_number = l_lic_number
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'));

      RETURN NVL (l_con_fc_is, 0);
   END;

--Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   FUNCTION fun_inv_mmt_report_ex_rate_ex (
      i_lic_currency       fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code       fid_exchange_rate.rat_cur_code_2%TYPE,
      i_acct_prvlng_rate   CHAR,
      i_lic_rate           fid_license.lic_rate%TYPE
                                                    --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   ,
      i_lic_start          DATE,
      i_go_live_date       DATE
   )
      --Dev2: Pure Finance :End
   RETURN NUMBER
   AS
      l_ex_rate   NUMBER;

      CURSOR get_prevailing_rate
      IS
         SELECT fer.rat_rate
           FROM fid_exchange_rate fer
          WHERE fer.rat_cur_code = i_lic_currency
            AND fer.rat_cur_code_2 = i_ter_cur_code;
   BEGIN
      IF ((i_acct_prvlng_rate = 'P') AND (i_lic_start < i_go_live_date))
      THEN
         OPEN get_prevailing_rate;

         FETCH get_prevailing_rate
          INTO l_ex_rate;

         IF get_prevailing_rate%NOTFOUND
         THEN
            l_ex_rate := 1;
         END IF;
      ELSE
         l_ex_rate := i_lic_rate;
      END IF;

      RETURN l_ex_rate;
   END;

   FUNCTION fun_inv_mmt_report_ex_rate_new (
      i_lic_currency       fid_exchange_rate.rat_cur_code%TYPE,
      i_ter_cur_code       fid_exchange_rate.rat_cur_code_2%TYPE,
      i_acct_prvlng_rate   CHAR,
      i_lic_rate           fid_license.lic_rate%TYPE
   )
      RETURN NUMBER
   AS
      l_ex_rate   NUMBER;

      CURSOR get_prevailing_rate
      IS
         SELECT fer.rat_rate
           FROM fid_exchange_rate fer
          WHERE fer.rat_cur_code = i_lic_currency
            AND fer.rat_cur_code_2 = i_ter_cur_code;
   BEGIN
      IF i_acct_prvlng_rate = 'P'
      THEN
         OPEN get_prevailing_rate;

         FETCH get_prevailing_rate
          INTO l_ex_rate;

         IF get_prevailing_rate%NOTFOUND
         THEN
            l_ex_rate := 1;
         END IF;
      ELSE
         l_ex_rate := i_lic_rate;
      END IF;

      RETURN l_ex_rate;
   END;

--Dev2: Pure Finance :End
--Dev2: Pure Finance Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
   FUNCTION con_fc_prg_inv_fin_expiry (
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
      /*
      BEGIN
      SELECT DECODE (i_inc_markup,
      'I', SUM (flv.lis_con_fc_imu),
      SUM (flv.lis_con_fc_emu)
      )
      INTO l_con_fc_is
      FROM fid_lis_vw flv
      WHERE flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
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
      */
      SELECT DECODE (i_inc_markup,
                     'I', SUM (lis_con_fc_imu),
                     SUM (lis_con_fc_emu)
                    )
        INTO l_con_fc_is
        FROM x_mv_subledger_data
       WHERE lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
         AND lis_lic_number = l_lic_number
         AND lis_lsl_number = i_lsl_number;

      RETURN NVL (l_con_fc_is, 0);
   END con_fc_prg_inv_fin_expiry;

   FUNCTION con_aa_prg_inv_fin_ex (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE,
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[ANUJASHINDE]_[2013/3/5]
      i_lsl_number    NUMBER
   --Dev2: Pure Finance :End
   )
      RETURN NUMBER
   AS
      l_con_aa_is   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT DECODE (i_inc_markup,
      'I', SUM (flv.lis_con_aa_imu),
      SUM (flv.lis_con_aa_emu)
      )
      INTO l_con_aa_is
      FROM fid_lis_vw flv
      WHERE flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
      AND flv.lis_lic_number = i_lic_number
      AND flv.lis_lsl_number = i_lsl_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_con_aa_is := 0;
      END;
      IF l_con_aa_is IS NULL
      THEN
      l_con_aa_is := 0;
      END IF;
      */
      BEGIN
         SELECT DECODE (i_inc_markup,
                        'I', SUM (lis_con_aa_imu_23),
                        SUM (lis_con_aa_emu_23)
                       )
           INTO l_con_aa_is
           FROM x_mv_subledger_data
          WHERE lis_yyyymm_num <=
                                 TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
            AND lis_lic_number = i_lic_number
            AND lis_lsl_number = i_lsl_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_con_aa_is := 0;
      END;

      IF l_con_aa_is IS NULL
      THEN
         l_con_aa_is := 0;
      END IF;

      RETURN l_con_aa_is;
   END;

--Dev2: Pure Finance :End
   FUNCTION con_aa_prg_inv (
      i_inc_markup    CHAR,
      i_lic_number    fid_lis_vw.lis_lic_number%TYPE,
      i_period_date   DATE
   )
      RETURN NUMBER
   AS
      l_con_aa_is   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT DECODE (i_inc_markup,
      'I', SUM (flv.lis_con_aa_imu),
      SUM (flv.lis_con_aa_emu)
      )
      INTO l_con_aa_is
      FROM fid_lis_vw flv
      WHERE flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
      AND flv.lis_lic_number = i_lic_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_con_aa_is := 0;
      END;
      IF l_con_aa_is IS NULL
      THEN
      l_con_aa_is := 0;
      END IF;
      */
      SELECT DECODE (i_inc_markup,
                     'I', SUM (lis_con_aa_imu_23),
                     SUM (lis_con_aa_emu_23)
                    )
        INTO l_con_aa_is
        FROM x_mv_subledger_data
       WHERE lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
         AND lis_lic_number = i_lic_number;

      RETURN NVL (l_con_aa_is, 0);
   END con_aa_prg_inv;

   FUNCTION sumcol1 (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER
   AS
      l_sumcol1   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT SUM (lis_con_aa_emu)
      INTO l_sumcol1
      FROM fid_lis_vw flv
      WHERE flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) >=
      TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
      AND flv.lis_lic_number = i_lic_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_sumcol1 := 0;
      END;
      IF l_sumcol1 IS NULL
      THEN
      l_sumcol1 := 0;
      END IF;
      */
      SELECT SUM (lis_con_aa_emu_23)
        INTO l_sumcol1
        FROM x_mv_subledger_data
       WHERE lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'));

      RETURN NVL (l_sumcol1, 0);
   END;

   FUNCTION sumcol1_ex (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      -- DEV2 : Pure Finance : Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/4/10]
      i_lsl_number   NUMBER,
      -- DEV2 : Pure Finance : END
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER
   AS
      l_sumcol1   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT SUM (flv.lis_con_aa_emu)
      INTO l_sumcol1
      FROM fid_lis_vw flv
      WHERE flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) >=
      TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
      AND flv.lis_lic_number = i_lic_number
      -- DEV2 : Pure Finance : Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/4/10]
      AND flv.lis_lsl_number = i_lsl_number
      -- DEV2 : Pure Finance : END
      ;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_sumcol1 := 0;
      END;
      IF l_sumcol1 IS NULL
      THEN
      l_sumcol1 := 0;
      END IF;*/
      SELECT SUM (lis_con_aa_emu_23)
        INTO l_sumcol1
        FROM x_mv_subledger_data
       WHERE lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
         AND lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number;

      RETURN NVL (l_sumcol1, 0);
   END sumcol1_ex;

   FUNCTION sumcol1_ex_loc (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      -- DEV2 : Pure Finance : Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/4/10]
      i_lsl_number   NUMBER,
      -- DEV2 : Pure Finance : END
      i_from_date    DATE,
      i_to_date      DATE
   )
      RETURN NUMBER
   AS
      l_sumcol1   NUMBER;
   BEGIN
      /* BEGIN
      SELECT SUM (flv.lis_loc_aa_emu)
      INTO l_sumcol1
      FROM fid_lis_vw flv
      WHERE flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) >=
      TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
      AND flv.lis_lic_number = i_lic_number
      -- DEV2 : Pure Finance : Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/4/10]
      AND flv.lis_lsl_number = i_lsl_number
      -- DEV2 : Pure Finance : END
      ;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_sumcol1 := 0;
      END;
      IF l_sumcol1 IS NULL
      THEN
      l_sumcol1 := 0;
      END IF; */
      SELECT SUM (lis_loc_aa_emu)
        INTO l_sumcol1
        FROM x_mv_subledger_data
       WHERE lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
         AND lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number;

      RETURN NVL (l_sumcol1, 0);
   END sumcol1_ex_loc;

--Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [ PV and ED ]
   FUNCTION fun_sum_pv_ed_ac (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      i_from_date    DATE,
      i_to_date      DATE,
      i_type         VARCHAR2
   )
      RETURN NUMBER
   AS
      l_sum   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT DECODE (i_type,
      'ED', SUM (flv.lis_ed_loc_ac_emu),
      SUM (flv.lis_pv_con_ac_emu)
      )
      INTO l_sum
      FROM fid_lis_vw flv
      WHERE flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) >=
      TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
      AND flv.lis_lic_number = i_lic_number
      AND flv.lis_lsl_number = i_lsl_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_sum := 0;
      END;
      IF l_sum IS NULL
      THEN
      l_sum := 0;
      END IF;
      */
      SELECT DECODE (i_type,
                     'ED', SUM (lis_ed_loc_ac_emu),
                     SUM (lis_pv_con_ac_emu)
                    )
        INTO l_sum
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'));

      RETURN NVL (l_sum, 0);
   END fun_sum_pv_ed_ac;

   FUNCTION fun_sum_pv_ed_ac_loc (
      i_lic_number   fid_lis_vw.lis_lic_number%TYPE,
      i_lsl_number   NUMBER,
      i_from_date    DATE,
      i_to_date      DATE,
      i_type         VARCHAR2
   )
      RETURN NUMBER
   AS
      l_sum   NUMBER;
   BEGIN
      /*
      BEGIN
      SELECT DECODE (i_type,
      'ED', SUM (flv.lis_ed_loc_ac_emu),
      SUM (flv.lis_pv_loc_ac_emu)
      )
      INTO l_sum
      FROM fid_lis_vw flv
      WHERE flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) >=
      TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
      AND flv.lis_per_year || LPAD (flv.lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
      AND flv.lis_lic_number = i_lic_number
      AND flv.lis_lsl_number = i_lsl_number;
      EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
      l_sum := 0;
      END;
      IF l_sum IS NULL
      THEN
      l_sum := 0;
      END IF; */
      SELECT DECODE (i_type,
                     'ED', SUM (lis_ed_loc_ac_emu),
                     SUM (lis_pv_loc_ac_emu)
                    )
        INTO l_sum
        FROM x_mv_subledger_data
       WHERE lis_lic_number = i_lic_number
         AND lis_lsl_number = i_lsl_number
         AND lis_yyyymm_num >= TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
         AND lis_yyyymm_num <= TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'));

      RETURN NVL (l_sum, 0);
   END fun_sum_pv_ed_ac_loc;

--Dev2: Pure Finance : END
   FUNCTION fun_cost_sale_sch_paid_1 (
      i_from_date      DATE,
      i_to_date        DATE,
      i_lic_number     fid_sch_summary_vw.sch_lic_number%TYPE
                                                             --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
   ,
      i_lic_start      DATE,
      i_go_live_date   DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER
   AS
      l_sch_paid_1   NUMBER;
   BEGIN
      BEGIN
         --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
         IF (i_lic_start < i_go_live_date)
         THEN
            --Dev2 : Pure Finance : END
            SELECT SUM (fsv.sch_paid)
              INTO l_sch_paid_1
              FROM fid_sch_summary_vw fsv
             WHERE fsv.sch_year || LPAD (fsv.sch_month, 2, 0) >=
                         TO_NUMBER (TO_CHAR (TO_DATE (i_from_date), 'YYYYMM'))
               AND fsv.sch_year || LPAD (fsv.sch_month, 2, 0) <=
                           TO_NUMBER (TO_CHAR (TO_DATE (i_to_date), 'YYYYMM'))
               AND fsv.sch_lic_number = i_lic_number;
         --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
         ELSE
            SELECT COUNT (xfcs.csh_lic_number)
              INTO l_sch_paid_1
              FROM x_fin_cost_schedules xfcs
             WHERE xfcs.csh_lic_number = i_lic_number
               AND xfcs.csh_year || LPAD (xfcs.csh_month, 2, 0) =
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'));
         END IF;
      --Dev2 : Pure Finance : END
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

   FUNCTION fun_cost_sale_sch_paid_2 (
      l_period_date    DATE,
      i_lic_number     fid_sch_summary_vw.sch_lic_number%TYPE
                                                             --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
   ,
      i_lic_start      DATE,
      i_go_live_date   DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER
   AS
      l_sch_paid_2   NUMBER;
   BEGIN
      BEGIN
         --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
         IF (i_lic_start < i_go_live_date)
         THEN
            --Dev2 : Pure Finance : END
            SELECT SUM (fsv.sch_paid)
              INTO l_sch_paid_2
              FROM fid_sch_summary_vw fsv
             WHERE fsv.sch_year || LPAD (fsv.sch_month, 2, 0) <=
                                 TO_NUMBER (TO_CHAR (l_period_date, 'YYYYMM'))
               AND fsv.sch_lic_number = i_lic_number;
         --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[Avinash Lanka]_[2013/3/5]
         ELSE
            SELECT COUNT (xfcs.csh_lic_number)
              INTO l_sch_paid_2
              FROM x_fin_cost_schedules xfcs
             WHERE xfcs.csh_lic_number = i_lic_number
               AND xfcs.csh_year || LPAD (xfcs.csh_month, 2, 0) <=
                                 TO_NUMBER (TO_CHAR (l_period_date, 'YYYYMM'));
         END IF;
      --Dev2 : Pure Finance : END
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_sch_paid_2 := 0;
      END;

      IF l_sch_paid_2 IS NULL
      THEN
         l_sch_paid_2 := 0;
      END IF;

      RETURN l_sch_paid_2;
   END;

   FUNCTION fun_cost_sale_wo_number (
      l_period_date       DATE,
      i_lic_number        fid_sch_summary_vw.sch_lic_number%TYPE,
      i_lic_showing_lic   NUMBER
                                --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[AVINASH LANKA]_[2013/3/5]
   ,
      i_lic_start         DATE,
      i_go_live_date      DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER
   AS
      l_wo_number   NUMBER;
   BEGIN
      BEGIN
         l_wo_number :=
              i_lic_showing_lic
            - pkg_fin_mnet_lib_val_rep.fun_cost_sale_sch_paid_2
                                                               (l_period_date,
                                                                i_lic_number,
                                                                i_lic_start,
                                                                i_go_live_date
                                                               );
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_wo_number := 0;
      END;

      RETURN l_wo_number;
   END;

   FUNCTION fun_cost_sale_this_month (
      l_from_date         DATE,
      l_to_date           DATE,
      i_lic_number        fid_sch_summary_vw.sch_lic_number%TYPE,
      i_lic_showing_lic   NUMBER
                                --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[AVINASH LANKA]_[2013/3/5]
   ,
      i_lic_start         DATE,
      i_go_live_date      DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER
   AS
      l_this_month   NUMBER;
   BEGIN
      BEGIN
         l_this_month :=
              pkg_fin_mnet_lib_val_rep.fun_cost_sale_sch_paid_1
                                                              (l_from_date,
                                                               l_to_date,
                                                               i_lic_number,
                                                               i_lic_start,
                                                               i_go_live_date
                                                              )
            + pkg_fin_mnet_lib_val_rep.fun_cost_sale_wo_number
                                                           (l_from_date,
                                                            i_lic_number,
                                                            i_lic_showing_lic,
                                                            i_lic_start,
                                                            i_go_live_date
                                                           );
      END;

      RETURN NVL (l_this_month, 0);
   END;

   FUNCTION fun_cost_sale_wo_percent (
      l_from_date         DATE,
      l_to_date           DATE,
      i_lic_number        fid_sch_summary_vw.sch_lic_number%TYPE,
      i_lic_showing_lic   NUMBER
                                --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7]_[AVINASH LANKA]_[2013/3/5]
   ,
      i_lic_start         DATE,
      i_go_live_date      DATE
   --Dev2 : Pure Finance : END
   )
      RETURN NUMBER
   AS
      l_wo_percent   NUMBER;
      l_this_month   NUMBER;
   BEGIN
      BEGIN
         l_this_month :=
            pkg_fin_mnet_lib_val_rep.fun_cost_sale_this_month
                                                          (l_from_date,
                                                           l_to_date,
                                                           i_lic_number,
                                                           i_lic_showing_lic,
                                                           i_lic_start,
                                                           i_go_live_date
                                                          );

         IF (l_this_month != 0)
         THEN
            l_wo_percent :=
                 pkg_fin_mnet_lib_val_rep.fun_cost_sale_wo_number
                                                          (l_from_date,
                                                           i_lic_number,
                                                           i_lic_showing_lic,
                                                           i_lic_start,
                                                           i_go_live_date
                                                          )
               / l_this_month;
         ELSIF (l_this_month = 0)
         THEN
            l_wo_percent := 0;
            RETURN l_wo_percent;
         END IF;
      END;

      RETURN NVL (l_wo_percent, 0);
   END;

   PROCEDURE prc_prg_lib_valution_rep (
      i_chnal_comp        IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_acc_prv_rate      IN       CHAR,
      i_inc_markup        IN       CHAR,
      i_period_date       IN       DATE,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry   VARCHAR2 (30000);
   BEGIN
      OPEN o_lib_rep FOR
         SELECT
                --    fc2.com_number
                --,    fc1.com_number    ,
                ft.ter_cur_code, fl.lic_currency, x.com_name channel_comp,
                fl.lic_type, flee.lee_short_name, fl.lic_budget_code,
                SUBSTR (fc1.com_short_name, 1, 8) supplier,
                fcon.con_short_name contract, fl.lic_number,
                SUBSTR (fg.gen_title, 1, 20) gen_title,
                TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                fl.lic_amort_code am_co,
                DECODE (fl.lic_catchup_flag,
                        'Y', NULL,
                        fl.lic_showing_int
                       ) lic_exh                  ---null for catchup license
                                ,
                fl.lic_showing_lic amo_exh,
                ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                ROUND (fl.lic_rate, 5) lic_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                pkg_fin_mnet_lib_val_rep.ex_rate_lib_val
                                                     (i_acc_prv_rate,
                                                      lic_currency,
                                                      ter_cur_code,
                                                      lic_rate
                                                     ) ex_rate,
                pkg_fin_mnet_lib_val_rep.con_fc
                                               (i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date)
                                               ) con_fc,
                pkg_fin_mnet_lib_val_rep.con_aa
                                               (i_inc_markup,
                                                lic_number,
                                                TO_DATE (i_period_date)
                                               ) con_aa,
                pkg_fin_mnet_lib_val_rep.td_exh
                                             (lic_number,
                                              TO_DATE (i_period_date)
                                             ) paid_exh,
                pkg_fin_mnet_lib_val_rep.td_unpaid
                                           (lic_number,
                                            TO_DATE (i_period_date)
                                           ) unpaid_exh,
                pkg_fin_mnet_lib_val_rep.td_total
                                               (lic_number,
                                                TO_DATE (i_period_date)
                                               ) td_exh,
                  pkg_fin_mnet_lib_val_rep.con_fc
                                         (i_inc_markup,
                                          lic_number,
                                          TO_DATE (i_period_date)
                                         )
                - pkg_fin_mnet_lib_val_rep.con_aa (i_inc_markup,
                                                   lic_number,
                                                   TO_DATE (i_period_date)
                                                  ) close_markup,
                  (  pkg_fin_mnet_lib_val_rep.con_fc (i_inc_markup,
                                                      lic_number,
                                                      TO_DATE (i_period_date)
                                                     )
                   - pkg_fin_mnet_lib_val_rep.con_aa (i_inc_markup,
                                                      lic_number,
                                                      TO_DATE (i_period_date)
                                                     )
                  )
                * pkg_fin_mnet_lib_val_rep.ex_rate_lib_val (i_acc_prv_rate,
                                                            lic_currency,
                                                            ter_cur_code,
                                                            lic_rate
                                                           ) close_markup2
           FROM fid_general fg,
                fid_company fc1
                               --,    fid_company fc2---commented
         ,
                fid_contract fcon,
                fid_licensee flee,
                fid_license fl,
                fid_territory ft,
                (SELECT fc.com_name, fc.com_number, fc.com_ter_code
                   FROM fid_company fc
                  WHERE fc.com_short_name LIKE i_chnal_comp
                    AND fc.com_type IN ('CC', 'BC')) x
          WHERE ter_code = x.com_ter_code
            AND lee_cha_com_number = x.com_number
            AND lic_type LIKE i_lic_type
            AND lee_short_name LIKE i_lee_short_name
            AND lic_lee_number = lee_number
            AND lic_budget_code LIKE i_lic_budget_code
            AND con_short_name LIKE i_con_short_name
            AND con_number = lic_con_number
            AND fc1.com_number = con_com_number            --change fc2 to fc1
            AND gen_refno = lic_gen_refno;
   END prc_prg_lib_valution_rep;

-- Inventory Month Moment  Fidval03A.rdf
   PROCEDURE prc_prg_lib_re_valution_adtn (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_markup            IN       VARCHAR2
                                           --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
   ,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE
                                       --Dev2: Pure Finance :End
   ,
      i_lic_region        IN       VARCHAR2                 -- added for split
                                           ,
      i_acc_prv_rate      IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (3000);
      first_day        DATE;
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
      OPEN o_lib_rep FOR
         SELECT b, com_number, lic_currency, lic_type, lee_short_name,
                lic_budget_code, supplier, con_short_name, lic_number,
                com_name, gen_title, acct_date, lic_start, lic_end,
                lic_amort_code, lic_showing_int,
                --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                --lic_showing_lic,
                DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                lic_markup_percent, lic_rate, ter_cur_code,
                --td_exh,
                DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                --SIT.R5 : SVOD Enhancements : End
                ob_mup,
                reval_mu, reval_mu_loc,
                ROUND (DECODE (reval_mu, 0, 0, (reval_mu_loc / reval_mu)),
                       5
                      ) exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                cost_mu,
                CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                THEN 0
                ELSE (ob_mup + reval_mu - cost_mu)
                END cbmp,
                CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                THEN 0
                ELSE ((ob_mup + reval_mu - cost_mu) * ex_rate)
                END cb_final,
                lic_price,
                from_date, TO_DATE, rat_rate, reg_code
           FROM (SELECT   bfc.com_number b, afc.com_number com_number,
                          fl.lic_currency, fl.lic_type, flee.lee_short_name,
                          fl.lic_budget_code, afc.com_short_name supplier,
                          fcon.con_short_name, fl.lic_number,
                          bfc.com_name com_name,
                          SUBSTR (fg.gen_title, 1, 20) gen_title,
                          TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  fl.lic_showing_int
                                 ) lic_showing_int ---null for catchup license
                                                  ,
                          fl.lic_showing_lic,
                          ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                          ROUND (fl.lic_rate, 5) lic_rate, ft.ter_cur_code   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                                                                          --[passing "lic_acct_date" to functions instead of "i_period_date" and lsl_number]
                          ,
                          pkg_fin_mnet_lib_val_rep.td_exh_fin_ex
                                              (fl.lic_number,
                                               TO_DATE (lic_acct_date),
                                               fl.lic_start,
                                               v_go_live_date,
                                               fl.lic_amort_code
                                              ) td_exh,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_ob_mp_ex
                                                    (fl.lic_number,
                                                     xfsl.lsl_number,
                                                     i_markup,
                                                     TO_DATE (fl.lic_acct_date)
                                                    ),
                              2
                             )
                          END ob_mup,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_fin_add
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_markup,
                                                              i_from_date,
                                                              i_to_date
                                                             ),
                              2
                             ) reval_mu,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_rep_revel_fin_ex_local_add
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_markup,
                                                              i_from_date,
                                                              i_to_date
                                                             ),
                              2
                             ) reval_mu_loc,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_addn
                                                    (fl.lic_number,
                                                     xfsl.lsl_number,
                                                     i_markup,
                                                     TO_DATE (fl.lic_acct_date)
                                                    ),
                              2
                             )
                          END cost_mu,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                          pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                    (fl.lic_currency,
                                                     ft.ter_cur_code,
                                                     'P',
                                                     fl.lic_rate,
                                                     fl.lic_start,
                                                     v_go_live_date
                                                    )
                          END ex_rate,
                          ROUND (xfsl.lsl_lee_price, 2) lic_price,

                          --[changed from lic_price to LSL_LEE_PRICE ]
                          --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
                          i_from_date from_date, i_to_date TO_DATE,
                                                                   --Dev2: Pure Finance :End
                                                                   rat_rate,
                          reg_code
                     FROM fid_general fg,
                          fid_company afc,
                          fid_company bfc,
                          fid_contract fcon,
                          fid_licensee flee,
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          x_fin_lic_sec_lee xfsl,
                          --Dev2: Pure Finance :END
                          fid_license fl,
                          fid_territory ft,
                          fid_region fr,                   -- added for split,
                          fid_exchange_rate fer,
                          (SELECT fc.com_name, fc.com_number, fc.com_ter_code
                             FROM fid_company fc
                            WHERE fc.com_short_name LIKE i_chnl_comp_name
                              AND fc.com_type IN ('CC', 'BC')) x
                    WHERE (    flee.lee_cha_com_number = x.com_number
                           AND ft.ter_code LIKE x.com_ter_code
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_lee_short_name
                           AND fl.lic_budget_code LIKE i_lic_budget_code
                           AND fcon.con_number = lic_con_number
                           AND afc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno
                           --[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
						   /*AND (   (TO_CHAR (fl.lic_acct_date, 'YYYYMM')
                                       --= TO_CHAR ( i_period_date , 'YYYYMM' )
                                    BETWEEN TO_CHAR (TO_DATE (i_from_date),
                                                     'YYYYMM'
                                                    )
                                           AND TO_CHAR (TO_DATE (i_to_date),
                                                        'YYYYMM'
                                                       )
                                   )
                                OR (TO_CHAR (fl.lic_start, 'YYYYMM')
                                       --= TO_CHAR ( i_period_date , 'YYYYMM' )
                                    BETWEEN TO_CHAR (TO_DATE (i_from_date),
                                                     'YYYYMM'
                                                    )
                                           AND TO_CHAR (TO_DATE (i_to_date),
                                                        'YYYYMM'
                                                       )
                                   )
                               )*/
                           AND EXISTS (
                                  SELECT   'x'
                                      FROM x_mv_subledger_data flsl
                                     WHERE flsl.lis_lic_number = fl.lic_number
									   AND flsl.lis_lsl_number = xfsl.lsl_number
                                       AND (    flsl.lis_yyyymm_num >=
                                                   TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                            AND flsl.lis_yyyymm_num <=
                                                   TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                           )
									   AND flsl.lis_reval_flag = 'AL'
                                  GROUP BY flsl.lis_lic_number,
								           flsl.lis_lsl_number
                                    HAVING (   SUM (flsl.lis_con_fc_emu) != 0
                                            OR SUM (flsl.lis_loc_forecast) != 0
                                           ))
                          )
                      AND (x.com_number = bfc.com_number)
                      AND fer.rat_cur_code = fl.lic_currency
                      AND fer.rat_cur_code_2 = ft.ter_cur_code         --split
                      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                      --LIC_LEE_NUMBER = LEE_NUMBER and
                      AND fl.lic_number = xfsl.lsl_lic_number
                      AND flee.lee_number = xfsl.lsl_lee_number
                      --Dev2: Pure Finance :End
                      --Dev2: Pure Finance :Start:[Non Costed Fillers]_[ANUJASHINDE]_[2013/3/15]
                      --[Added to exclude(fillers) licenses with status F]
                      AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                      --Dev2: Pure Finance[Non Costed Fillers] :End
                      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                      --AND lee_split_region = reg_id
                      AND fr.reg_id(+) = flee.lee_split_region
                      --Dev2: Pure Finance :END
                      AND fr.reg_code LIKE i_lic_region
                 ORDER BY fl.lic_currency,
                          fl.lic_type,
                          flee.lee_short_name,
                          fl.lic_budget_code,
                          afc.com_short_name,
                          fcon.con_short_name,
                          fg.gen_title,
                          fl.lic_number)
          WHERE 1 = 1;
   END prc_prg_lib_re_valution_adtn;

   PROCEDURE prc_prg_lib_re_valution_adtn_x (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_markup            IN       VARCHAR2
                                           --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
   ,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE
                                       --Dev2: Pure Finance :End
   ,
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,                 -- added for split
			i_acc_prv_rate      IN       VARCHAR2
   )
   AS
      l_qry            VARCHAR2 (3000);
      first_day        DATE;
      v_go_live_date   DATE;
   BEGIN
      -- first_day := ADD_MONTHS (LAST_DAY (i_period_date), -1) + 1;
      --open o_lib_rep for
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      DELETE FROM exl_inventory_for_additon;

      COMMIT;

		IF i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
		THEN
			INSERT INTO exl_inventory_for_additon
                  (b, com_number, lic_currency, lic_type, lee_short_name,
                   lic_budget_code, suppler, contract, lic_number, com_name,
                   gen_title, lic_acct_date, lic_start, lic_end,
                   lic_amort_code, lic_showing_int, lic_showing_lic,
                   lic_markup_percent, lic_rate, ter_cur_code, td_exh, reval, reval_loc, reval_exh_rate, lic_price
                                                 --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
                   , from_date, TO_DATE
                                       --Dev2: Pure Finance :End
                   , exchange_rate, region_code)
         SELECT b, com_number, lic_currency, lic_type, lee_short_name,
                lic_budget_code, supplier, con_short_name, lic_number,
                com_name, gen_title, acct_date, lic_start, lic_end,
                lic_amort_code, lic_showing_int,
                --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                --lic_showing_lic,
                DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                lic_markup_percent, lic_rate, ter_cur_code,
                --td_exh,
                DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                --SIT.R5 : SVOD Enhancements : End
                reval_mu, reval_mu_loc,
                ROUND (DECODE (reval_mu, 0, 0, (reval_mu_loc / reval_mu)),
                       5
                      ) exh_rate, lic_price,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                from_date, TO_DATE, rat_rate, reg_code
           FROM (SELECT   bfc.com_number b, afc.com_number com_number,
                          fl.lic_currency, fl.lic_type, flee.lee_short_name,
                          fl.lic_budget_code, afc.com_short_name supplier,
                          fcon.con_short_name, fl.lic_number,
                          bfc.com_name com_name,
                          --SUBSTR (fg.gen_title, 1, 20) gen_title,
                          TRIM (fg.gen_title) gen_title,
                          TO_CHAR (fl.lic_acct_date, 'RRRR.MM') acct_date,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  fl.lic_showing_int
                                 ) lic_showing_int ---null for catchup license
                                                  ,
                          ROUND (fl.lic_showing_lic, 4) lic_showing_lic,
                          ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                          ROUND (fl.lic_rate, 5) lic_rate, ft.ter_cur_code   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                                                                          --[passing "lic_acct_date" to functions instead of "i_period_date" and lsl_number]
                          ,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.td_exh_fin_ex
                                                      (lic_number,
                                                       TO_DATE (lic_acct_date),
                                                       lic_start,
                                                       v_go_live_date,
                                                       lic_amort_code
                                                      ),
                              2
                             ) td_exh,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_fin_add
                                                                 (lic_number,
                                                                  lsl_number,
                                                                  i_markup,
                                                                  i_from_date,
                                                                  i_to_date
                                                                 ),
                              2
                             ) reval_mu,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_rep_revel_fin_ex_local_add
                                                                 (lic_number,
                                                                  lsl_number,
                                                                  i_markup,
                                                                  i_from_date,
                                                                  i_to_date
                                                                 ),
                              2
                             ) reval_mu_loc,
                          ROUND (xfsl.lsl_lee_price, 4) lic_price,
                          --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
                          i_from_date from_date, i_to_date TO_DATE,
                                                                   --Dev2: Pure Finance :End
                                                                   rat_rate,
                          reg_code
                     FROM fid_general fg,
                          fid_company afc,
                          fid_company bfc,
                          fid_contract fcon,
                          fid_licensee flee,
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          x_fin_lic_sec_lee xfsl,
                          --Dev2: Pure Finance :END
                          fid_license fl,
                          fid_territory ft,
                          fid_region fr,
                          fid_exchange_rate fer,
                          (SELECT fc.com_name, fc.com_number, fc.com_ter_code
                             FROM fid_company fc
                            WHERE fc.com_short_name LIKE i_chnl_comp_name
                              AND fc.com_type IN ('CC', 'BC')) x
                    WHERE (    flee.lee_cha_com_number = x.com_number
                           AND ft.ter_code LIKE x.com_ter_code
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_lee_short_name
                           AND fl.lic_budget_code LIKE i_lic_budget_code
                           AND fcon.con_number = fl.lic_con_number
                           AND afc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno
                           AND EXISTS (
                                  SELECT   'x'
                                      FROM x_mv_subledger_data flsl
                                     WHERE flsl.lis_lic_number = fl.lic_number
									   AND flsl.lis_lsl_number = xfsl.lsl_number
                                       AND (    flsl.lis_yyyymm_num >=
                                                   TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                            AND flsl.lis_yyyymm_num <=
                                                   TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                           )
                                       AND flsl.lis_reval_flag = 'AL'
                                  GROUP BY flsl.lis_lic_number,
								           flsl.lis_lsl_number
                                    HAVING (   SUM (flsl.lis_con_fc_emu) != 0
                                            OR SUM (flsl.lis_loc_forecast) !=
                                                                             0
                                           ))
                          )
                      AND (x.com_number = bfc.com_number)
                      AND fer.rat_cur_code = fl.lic_currency
                      AND fer.rat_cur_code_2 = ft.ter_cur_code         --split
                      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                      --LIC_LEE_NUMBER = LEE_NUMBER and
                      AND fl.lic_number = xfsl.lsl_lic_number
                      AND flee.lee_number = xfsl.lsl_lee_number
                      --Dev2: Pure Finance :End
                      --Dev2: Pure Finance :Start:[Non Costed Fillers]_[ANUJASHINDE]_[2013/3/15]
                      --[Added to exclude(fillers) licenses with status F]
                      AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                      --Dev2: Pure Finance[Non Costed Fillers] :End
                      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                      --AND lee_split_region = reg_id
                      AND fr.reg_id(+) = flee.lee_split_region
                      --Dev2: Pure Finance :END
                      AND fr.reg_code LIKE i_lic_region
                 ORDER BY fl.lic_currency,
                          fl.lic_type,
                          flee.lee_short_name,
                          fl.lic_budget_code,
                          afc.com_short_name,
                          fcon.con_short_name,
                          fg.gen_title,
                          fl.lic_number)
          WHERE 1 = 1;

			OPEN O_LIB_REP FOR
         SELECT EA.COM_NAME, EA.LIC_CURRENCY, TO_CHAR(EA.FROM_DATE, 'DD-MON-RRRR') FROM_DATE,
                TO_CHAR(ea.TO_DATE, 'DD-MON-RRRR') TO_DATE,
                ea.ter_cur_code, ea.exchange_rate, ea.lic_type,
                ea.lee_short_name, ea.lic_budget_code, suppler,
                EA.CONTRACT "CONTRACT", EA.LIC_NUMBER, EA.GEN_TITLE,
                ea.lic_acct_date "ACCT_DATE"
                ,ea.lic_start
                ,ea.lic_end,
                ea.lic_amort_code, ea.lic_showing_int, ea.lic_showing_lic,
                ea.td_exh, ea.lic_markup_percent,
                ea.reval "FEE", ea.reval_exh_rate, ea.reval_loc "ZAR FEES", ea.lic_rate, ea.lic_price, ea.region_code
           FROM exl_inventory_for_additon ea;
		ELSE
      INSERT INTO exl_inventory_for_additon
                  (b, com_number, lic_currency, lic_type, lee_short_name,
                   lic_budget_code, suppler, contract, lic_number, com_name,
                   gen_title, lic_acct_date, lic_start, lic_end,
                   lic_amort_code, lic_showing_int, lic_showing_lic,
                   lic_markup_percent, lic_rate, ter_cur_code, td_exh,
                   ob_markup, reval, reval_loc, reval_exh_rate, COST,
                   cb_markup, cb_close, lic_price
                                                 --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
                   , from_date, TO_DATE
                                       --Dev2: Pure Finance :End
                   , exchange_rate, region_code)
         SELECT b, com_number, lic_currency, lic_type, lee_short_name,
                lic_budget_code, supplier, con_short_name, lic_number,
                com_name, gen_title, acct_date, lic_start, lic_end,
                lic_amort_code, lic_showing_int,
                --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                --lic_showing_lic,
                DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                lic_markup_percent, lic_rate, ter_cur_code,
                --td_exh,
                DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                --SIT.R5 : SVOD Enhancements : End
                ob_mup,
                reval_mu, reval_mu_loc,
                ROUND (DECODE (reval_mu, 0, 0, (reval_mu_loc / reval_mu)),
                       5
                      ) exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                cost_mu, (ob_mup + reval_mu - cost_mu) cbmp,
                ((ob_mup + reval_mu - cost_mu) * ex_rate) cb_final, lic_price,
                from_date, TO_DATE, rat_rate, reg_code
           FROM (SELECT   bfc.com_number b, afc.com_number com_number,
                          fl.lic_currency, fl.lic_type, flee.lee_short_name,
                          fl.lic_budget_code, afc.com_short_name supplier,
                          fcon.con_short_name, fl.lic_number,
                          bfc.com_name com_name,
                          --SUBSTR (fg.gen_title, 1, 20) gen_title,
                          TRIM (fg.gen_title) gen_title,
                          TO_CHAR (fl.lic_acct_date, 'RRRR.MM') acct_date,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  fl.lic_showing_int
                                 ) lic_showing_int ---null for catchup license
                                                  ,
                          ROUND (fl.lic_showing_lic, 4) lic_showing_lic,
                          ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                          ROUND (fl.lic_rate, 4) lic_rate, ft.ter_cur_code
                                                                          --[passing "lic_acct_date" to functions instead of "i_period_date" and lsl_number]
                          ,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.td_exh_fin_ex
                                                      (lic_number,
                                                       TO_DATE (lic_acct_date),
                                                       lic_start,
                                                       v_go_live_date,
                                                       lic_amort_code
                                                      ),
                              2
                             ) td_exh,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_ob_mp_ex
                                                       (lic_number,
                                                        lsl_number,
                                                        i_markup,
                                                        TO_DATE (lic_acct_date)
                                                       ),
                              2
                             ) ob_mup,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_fin_add
                                                                 (lic_number,
                                                                  lsl_number,
                                                                  i_markup,
                                                                  i_from_date,
                                                                  i_to_date
                                                                 ),
                              2
                             ) reval_mu,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_rep_revel_fin_ex_local_add
                                                                 (lic_number,
                                                                  lsl_number,
                                                                  i_markup,
                                                                  i_from_date,
                                                                  i_to_date
                                                                 ),
                              2
                             ) reval_mu_loc,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_addn
                                                       (lic_number,
                                                        lsl_number,
                                                        i_markup,
                                                        TO_DATE (lic_acct_date)
                                                       ),
                              2
                             ) cost_mu,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                'P',
                                                                lic_rate,
                                                                lic_start,
                                                                v_go_live_date
                                                               ),
                              5
                             ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                          ROUND (xfsl.lsl_lee_price, 4) lic_price,

                          --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
                          i_from_date from_date, i_to_date TO_DATE,
                                                                   --Dev2: Pure Finance :End
                                                                   rat_rate,
                          reg_code
                     FROM fid_general fg,
                          fid_company afc,
                          fid_company bfc,
                          fid_contract fcon,
                          fid_licensee flee,
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          x_fin_lic_sec_lee xfsl,
                          --Dev2: Pure Finance :END
                          fid_license fl,
                          fid_territory ft,
                          fid_region fr                    -- added for split,
                                       ,
                          fid_exchange_rate fer,
                          (SELECT fc.com_name, fc.com_number, fc.com_ter_code
                             FROM fid_company fc
                            WHERE fc.com_short_name LIKE i_chnl_comp_name
                              AND fc.com_type IN ('CC', 'BC')) x
                    WHERE (    flee.lee_cha_com_number = x.com_number
                           AND ft.ter_code LIKE x.com_ter_code
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_lee_short_name
                           AND fl.lic_budget_code LIKE i_lic_budget_code
                           AND fcon.con_number = fl.lic_con_number
                           AND afc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno
						   --[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                           /*AND (   (TO_CHAR (fl.lic_acct_date, 'YYYYMM')
                                       --= TO_CHAR ( i_period_date , 'YYYYMM' )
                                    BETWEEN TO_CHAR (TO_DATE (i_from_date),
                                                     'YYYYMM'
                                                    )
                                           AND TO_CHAR (TO_DATE (i_to_date),
                                                        'YYYYMM'
                                                       )
                                   )
                                OR (TO_CHAR (lic_start, 'YYYYMM')
                                       --= TO_CHAR ( i_period_date , 'YYYYMM' )
                                    BETWEEN TO_CHAR (TO_DATE (i_from_date),
                                                     'YYYYMM'
                                                    )
                                           AND TO_CHAR (TO_DATE (i_to_date),
                                                        'YYYYMM'
                                                       )
                                   )
                               )*/
                           AND EXISTS (
                                  SELECT   'x'
                                      FROM x_mv_subledger_data flsl
                                     WHERE flsl.lis_lic_number = fl.lic_number
									   AND flsl.lis_lsl_number = xfsl.lsl_number
                                       AND (    flsl.lis_yyyymm_num >=
                                                   TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                            AND flsl.lis_yyyymm_num <=
                                                   TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                           )
                                       AND flsl.lis_reval_flag = 'AL'
                                  GROUP BY flsl.lis_lic_number,
								           flsl.lis_lsl_number
                                    HAVING (   SUM (flsl.lis_con_fc_emu) != 0
                                            OR SUM (flsl.lis_loc_forecast) !=
                                                                             0
                                           ))
                          )
                      AND (x.com_number = bfc.com_number)
                      AND fer.rat_cur_code = fl.lic_currency
                      AND fer.rat_cur_code_2 = ft.ter_cur_code         --split
                      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                      --LIC_LEE_NUMBER = LEE_NUMBER and
                      AND fl.lic_number = xfsl.lsl_lic_number
                      AND flee.lee_number = xfsl.lsl_lee_number
                      --Dev2: Pure Finance :End
                      --Dev2: Pure Finance :Start:[Non Costed Fillers]_[ANUJASHINDE]_[2013/3/15]
                      --[Added to exclude(fillers) licenses with status F]
                      AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                      --Dev2: Pure Finance[Non Costed Fillers] :End
                      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                      --AND lee_split_region = reg_id
                      AND fr.reg_id(+) = flee.lee_split_region
                      --Dev2: Pure Finance :END
                      AND fr.reg_code LIKE i_lic_region
                 ORDER BY fl.lic_currency,
                          fl.lic_type,
                          flee.lee_short_name,
                          fl.lic_budget_code,
                          afc.com_short_name,
                          fcon.con_short_name,
                          fg.gen_title,
                          fl.lic_number)
          WHERE 1 = 1;

			OPEN O_LIB_REP FOR
         SELECT EA.COM_NAME, EA.LIC_CURRENCY, TO_CHAR(EA.FROM_DATE, 'DD-MON-RRRR') FROM_DATE,
                TO_CHAR(ea.TO_DATE, 'DD-MON-RRRR') TO_DATE,
                ea.ter_cur_code, ea.exchange_rate, ea.lic_type,
                ea.lee_short_name, ea.lic_budget_code, suppler,
                EA.CONTRACT "CONTRACT", EA.LIC_NUMBER, EA.GEN_TITLE,
                EA.LIC_ACCT_DATE "ACCT_DATE"
                ,ea.lic_start
                ,ea.lic_end,
                ea.lic_amort_code, ea.lic_showing_int, ea.lic_showing_lic,
                ea.td_exh, ea.lic_markup_percent, ea.ob_markup "OB_MUP",
                ea.reval "FEE", ea.reval_exh_rate, ea.reval_loc "ZAR FEES",
                ea.COST "COST", ea.cb_markup "CLOSE", ea.lic_rate,
                ea.cb_close "E_CLOSE", ea.lic_price, ea.region_code
           FROM exl_inventory_for_additon ea;
		END IF;
   END prc_prg_lib_re_valution_adtn_x;

   PROCEDURE prc_prg_lib_re_valution_flf (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      --Dev2: Pure Finance :End
      i_lic_region        IN       VARCHAR2                -- added for split,
                                           ,
      i_acc_prv_rate      IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (3000);
      v_go_live_date   DATE;
   BEGIN
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      OPEN o_lib_rep FOR
         SELECT   com_name, com_number, com_ter_code, ter_cur_code,
                  lee_cha_com_number, lic_currency, lic_type, lee_short_name,
                  lic_budget_code, supplier, con_short_name, lic_number,
                  gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                  lic_showing_int,
                  --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                  --lic_showing_lic,
                  DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                  lic_markup_percent,
                  --td_exh,
                  DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                  --SIT.R5 : SVOD Enhancements : End
                  ob_markup, COST,
                  revel, reval_mu_loc,
                  ROUND (DECODE (revel, 0, 0, (reval_mu_loc / revel)), 5) rev_exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  ex_rate,
                  CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                  THEN 0
                  ELSE (ob_markup + revel - COST)
                  END cb_mup,
                  CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                  THEN 0
                  ELSE ((ob_markup + revel - COST) * ex_rate)
                  END cb_final,
                  lic_price,
                  from_date, TO_DATE
             FROM (SELECT x.com_name com_name, x.com_number com_number,
                          x.com_ter_code com_ter_code,
                          x.ter_cur_code ter_cur_code,
                          flee.lee_cha_com_number, fl.lic_currency,
                          fl.lic_type, flee.lee_short_name,
                          fl.lic_budget_code,
                          RPAD (afc.com_short_name, 12, ' ') supplier,
                          fcon.con_short_name, fl.lic_number,
                          SUBSTR (fg.gen_title, 1, 20) gen_title,
                          TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  fl.lic_showing_int
                                 ) lic_showing_int,
                          fl.lic_showing_lic,
                          ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                          pkg_fin_mnet_lib_val_rep.td_exh (lic_number,
                                                           i_from_date
                                                          ) td_exh, -- Pending
                          CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_ob_mp_rversal
                                                                  (lic_number,
                                                                   lsl_number,
                                                                   i_mup,
                                                                   i_from_date
                                                                  ),
                              2
                             )
                          END ob_markup,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_fin_ex
                                                                 (lic_number,
                                                                  lsl_number,
                                                                  i_mup,
                                                                  i_from_date,
                                                                  i_to_date
                                                                 ),
                              2
                             )
                          END COST,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_fin_ex
                                 (lic_number,
                                  lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS (lic_start,
                                                                  +1
                                                                 )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) revel,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_rep_revel_fin_ex_local
                                 (lic_number,
                                  lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS (lic_start,
                                                                  +1
                                                                 )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) reval_mu_loc,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                'P',
                                                                lic_rate,
                                                                lic_start,
                                                                v_go_live_date
                                                               ),
                              5
                             )
                          END ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                          ROUND (xfsl.lsl_lee_price, 4) lic_price
                                                                 --[changed from lic_price to LSL_LEE_PRICE ]
                          ,
                          i_from_date from_date, i_to_date TO_DATE
                     FROM fid_general fg,
                          fid_company afc,
                          fid_contract fcon,
                          fid_licensee flee,
                          fid_region fr,                       -- added region
                          fid_license fl
                                        --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                   ,
                          x_fin_lic_sec_lee xfsl
                                                --Dev2: Pure Finance :END
                   ,
                          (SELECT fc.com_name, fc.com_number, fc.com_ter_code,
                                  ft.ter_cur_code
                             FROM fid_company fc, fid_territory ft
                            WHERE fc.com_short_name LIKE i_chnl_comp_name
                              AND fc.com_type IN ('CC', 'BC')
                              AND ft.ter_code = fc.com_ter_code) x
                    WHERE (    fl.lic_type LIKE 'FLF'
                           --AND UPPER (fl.lic_status) <> 'C'
                             --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/4/5]
                           --AND UPPER (fl.lic_status) NOT IN ('F', 'C', 'T')		--[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
						   AND UPPER (fl.lic_status) NOT IN ('F', 'T') 				--[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                           AND fl.lic_number = xfsl.lsl_lic_number
                           AND flee.lee_number = xfsl.lsl_lee_number
                           --Dev2: Pure Finance :End
                           AND flee.lee_short_name LIKE i_lee_short_name
                           -- AND lic_lee_number = lee_number
                           AND fl.lic_budget_code LIKE i_lic_budget_code
                           AND fcon.con_number = fl.lic_con_number
                           AND afc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno
						   --Start[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                           /*AND TO_CHAR (fl.lic_acct_date, 'YYYYMM') <
                                                 TO_CHAR (i_to_date, 'YYYYMM')
                           AND TO_CHAR (fl.lic_start, 'YYYYMM') <>
                                                 TO_CHAR (i_to_date, 'YYYYMM')
						   */
							--END[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                          -- i_period_date to I_TO_DATE
                          /*   AND EXISTS (
                          SELECT 'x'
                          FROM fid_license_sub_ledger
                          WHERE LIS_LIC_NUMBER = LIC_NUMBER
                          AND lis_per_year || LPAD (lis_per_month, 2, 0) =
                          TO_CHAR (I_PERIOD_DATE, 'YYYYMM')
                          AND lis_con_forecast != 0)         */
                          )
                      -- Pure Finance : Ajit : 10-Apr-2013 : Check if the inventory is not
                      -- equal to 0 for the given time period
                      AND EXISTS (
                             SELECT   'x'
                                 FROM x_mv_subledger_data flsl
                                /*fid_license_sub_ledger flsl*/
                             WHERE    flsl.lis_lic_number = fl.lic_number
                                  AND flsl.lis_lsl_number = xfsl.lsl_number
                                  AND flsl.lis_yyyymm_num BETWEEN TO_CHAR (i_from_date,'YYYYMM') AND TO_CHAR (i_to_date,'YYYYMM') --[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                                         --Start[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
										 /*BETWEEN CASE
                                         WHEN TO_NUMBER
                                                       (TO_CHAR (fl.lic_start,
                                                                 'YYYYMM'
                                                                )
                                                       ) >
                                                TO_NUMBER
                                                        (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                            THEN   TO_NUMBER
                                                          (TO_CHAR (lic_start,
                                                                    'YYYYMM'
                                                                   )
                                                          )
                                                 + 1
                                         ELSE TO_NUMBER (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                      END
                                             AND TO_NUMBER
                                                          (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )*/
								--END[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                                  AND flsl.lis_reval_flag = 'PC'
                             GROUP BY flsl.lis_lic_number,
                                      flsl.lis_lsl_number
                               --HAVING SUM (lis_con_forecast) <> 0)
                             HAVING   (
                                          /*SUM (flsl.lis_con_forecast)*/
                                          SUM (lis_con_fc_emu) <> 0
                                       OR SUM (flsl.lis_loc_forecast) <> 0
                                      )
								  )
                      AND (x.com_number = flee.lee_cha_com_number)
                      -- Pure Finance : Ajit : 10-Apr-2013 : split region mapping changed from lee
                      -- region id to lee split region
                      AND flee.lee_split_region = fr.reg_id
                      AND fr.reg_code LIKE i_lic_region)
            WHERE 1 = 1
         ORDER BY 2 ASC,
                  1 ASC,
                  3 ASC,
                  4 ASC,
                  5 ASC,
                  6 ASC,
                  lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  lic_number ASC,
                  con_short_name,
                  gen_title;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
   END prc_prg_lib_re_valution_flf;

   PROCEDURE prc_prg_lib_re_valution_flf_x (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      --Dev2: Pure Finance :End
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,                 -- added for split
			i_acc_prv_rate      IN       VARCHAR2
   )
   AS
      l_qry            VARCHAR2 (3000);
      v_go_live_date   DATE;
   BEGIN
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      DELETE FROM exl_inventory_for_flf;

      COMMIT;

		IF i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
		THEN
			INSERT INTO exl_inventory_for_flf
                  (com_name, com_number, com_ter_code, ter_cur_code,
                   lee_cha_com_number, lic_currency, lic_type, lee_short_name,
                   lic_budget_code, suppler, con_short_name, lic_number,
                   gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                   lic_showing_int, lic_showing_lic, lic_markup_percent,
                   td_exh, reval, reval_loc, reval_exh_rate,
									 lic_price, from_date, TO_DATE,
                   region_code)
         SELECT   com_name, com_number, com_ter_code, ter_cur_code,
                  lee_cha_com_number, lic_currency, lic_type, lee_short_name,
                  lic_budget_code, supplier, con_short_name, lic_number,
                  gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                  lic_showing_int,
                  --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                  --lic_showing_lic,
                  DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                  lic_markup_percent,
                  --td_exh,
                  DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                  --SIT.R5 : SVOD Enhancements : End
									revel, reval_mu_loc,
                  ROUND (DECODE (revel, 0, 0, (reval_mu_loc / revel)),
                         5
                        ) rev_exh_rate, lic_price,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  from_date, TO_DATE, reg_code
             FROM (SELECT x.com_name com_name, x.com_number com_number,
                          x.com_ter_code com_ter_code,
                          x.ter_cur_code ter_cur_code,
                          flee.lee_cha_com_number, fl.lic_currency,
                          fl.lic_type, flee.lee_short_name,
                          fl.lic_budget_code,
                          RPAD (fc.com_short_name, 12, ' ') supplier,
                          fcon.con_short_name, fl.lic_number,
                          TO_CHAR (fl.lic_acct_date, 'RRRR.MM') acct_date,
                          --SUBSTR (fg.gen_title, 1, 20) gen_title,
                          TRIM (fg.gen_title) gen_title,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  fl.lic_showing_int
                                 ) lic_showing_int,
                          fl.lic_showing_lic,
                          ROUND (lic_markup_percent, 4) lic_markup_percent,
                          pkg_fin_mnet_lib_val_rep.td_exh
                                                       (fl.lic_number,
                                                        i_from_date
                                                       ) td_exh,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_fin_ex
                                 (fl.lic_number,
                                  xfsl.lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN fl.lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS (lic_start,
                                                                  +1
                                                                 )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) revel,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_rep_revel_fin_ex_local
                                 (fl.lic_number,
                                  xfsl.lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN fl.lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS (lic_start,
                                                                  +1
                                                                 )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) reval_mu_loc,
                          ROUND (xfsl.lsl_lee_price, 4) lic_price,

                          --[changed from lic_price to LSL_LEE_PRICE ]
                          i_from_date from_date, i_from_date TO_DATE,
                          fr.reg_code
                     FROM fid_general fg,
                          fid_company fc,
                          fid_contract fcon,
                          fid_licensee flee,
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          x_fin_lic_sec_lee xfsl,
                          --Dev2: Pure Finance :END
                          fid_license fl,
                          fid_region fr,
                          (SELECT fc.com_name, fc.com_number, fc.com_ter_code,
                                  ft.ter_cur_code
                             FROM fid_company fc, fid_territory ft
                            WHERE fc.com_short_name LIKE i_chnl_comp_name
                              AND fc.com_type IN ('CC', 'BC')
                              AND ft.ter_code = fc.com_ter_code) x
                    WHERE (    fl.lic_type LIKE 'FLF'
                           --AND fl.lic_status <> 'C'
                             --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/4/5]
                           --AND UPPER (fl.lic_status) NOT IN ('F', 'C', 'T')		--[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
						   AND UPPER (fl.lic_status) NOT IN ('F', 'T') 				--[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                           AND fl.lic_number = xfsl.lsl_lic_number
                           AND flee.lee_number = xfsl.lsl_lee_number
                           --Dev2: Pure Finance :End
                           AND flee.lee_short_name LIKE i_lee_short_name
                           --  AND fl.lic_lee_number = flee.lee_number
                           AND fl.lic_budget_code LIKE i_lic_budget_code
                           AND fcon.con_number = fl.lic_con_number
                           AND fc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno

						   --Start[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                           /*AND TO_CHAR (fl.lic_acct_date, 'YYYYMM') <
                                                 TO_CHAR (i_to_date, 'YYYYMM')
                           AND TO_CHAR (fl.lic_start, 'YYYYMM') <>
                                                 TO_CHAR (i_to_date, 'YYYYMM')*/
						   --End[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports

                          -- i_period_date to I_TO_DATE
                          /* AND EXISTS (
                          SELECT 'x'
                          FROM fid_license_sub_ledger
                          WHERE lis_lic_number = lic_number
                          AND lis_per_year || LPAD (lis_per_month, 2, 0) =
                          TO_CHAR (i_period_date, 'YYYYMM')
                          AND lis_con_forecast != 0)*/
                          )
                      -- Pure Finance : Ajit : 10-Apr-2013 : Check if the inventory is not
                      -- equal to 0 for the given time period
                      AND EXISTS (
                             SELECT   'x'
                                 FROM x_mv_subledger_data flsl
                                /*fid_license_sub_ledger*/
                             WHERE    flsl.lis_lic_number = fl.lic_number
                                  AND flsl.lis_lsl_number = xfsl.lsl_number
                                  AND flsl.lis_yyyymm_num BETWEEN TO_CHAR (i_from_date,'YYYYMM') AND TO_CHAR (i_to_date,'YYYYMM') --[15-Jun-2016]Added by Jawahar so the data will not change for close month reports

                                          --Start[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
										 /*BETWEEN CASE
                                         WHEN TO_NUMBER (TO_CHAR (lic_start,
                                                                  'YYYYMM'
                                                                 )
                                                        ) >
                                                TO_NUMBER
                                                        (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                            THEN   TO_NUMBER
                                                          (TO_CHAR (lic_start,
                                                                    'YYYYMM'
                                                                   )
                                                          )
                                                 + 1
                                         ELSE TO_NUMBER (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                      END
                                             AND TO_NUMBER
                                                          (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )*/
										--END[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                                  AND flsl.lis_reval_flag = 'PC'
                             GROUP BY flsl.lis_lic_number,
                                      flsl.lis_lsl_number
                               --  HAVING SUM (lis_con_forecast) <> 0)
                             HAVING   (   SUM (lis_con_fc_emu)
                                                              /*SUM (flsl.lis_con_forecast)*/
                                          <> 0
                                       OR SUM (flsl.lis_loc_forecast) <> 0
                                      )
								  )
                      AND (x.com_number = flee.lee_cha_com_number)
                      -- Pure Finance : Ajit : 10-Apr-2013 : split region mapping changed from lee
                      -- region id to lee split region
                      AND flee.lee_split_region = fr.reg_id
                      AND fr.reg_code LIKE i_lic_region)
            WHERE 1 = 1
         ORDER BY 2 ASC,
                  1 ASC,
                  3 ASC,
                  4 ASC,
                  5 ASC,
                  6 ASC,
                  lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  lic_number ASC,
                  con_short_name,
                  gen_title;

      OPEN O_LIB_REP FOR
         SELECT EF.COM_NAME "CHANNEL_COMPANY", EF.LIC_CURRENCY, TO_CHAR(EF.FROM_DATE, 'DD-MON-RRRR') FROM_DATE,
                TO_CHAR(ef.TO_DATE, 'DD-MON-RRRR') TO_DATE, ef.ter_cur_code, ef.ex_rate "EXCHANGE_RATE",
                ef.lic_type, ef.lee_short_name, ef.lic_budget_code,
                EF.SUPPLER, EF.CON_SHORT_NAME "CONTRACT", EF.LIC_NUMBER,
                ef.gen_title
                ,EF.ACCT_DATE
                ,EF.LIC_START
                ,ef.lic_end,
                ef.lic_amort_code, ef.lic_showing_int, ef.lic_showing_lic,
                ef.td_exh, ef.lic_markup_percent,
                ef.reval revel, ef.reval_exh_rate, ef.reval_loc,
                ef.region_code
           FROM exl_inventory_for_flf ef;
		ELSE
			INSERT INTO exl_inventory_for_flf
                  (com_name, com_number, com_ter_code, ter_cur_code,
                   lee_cha_com_number, lic_currency, lic_type, lee_short_name,
                   lic_budget_code, suppler, con_short_name, lic_number,
                   gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                   lic_showing_int, lic_showing_lic, lic_markup_percent,
                   td_exh, ob_mup, COST, reval, reval_loc, reval_exh_rate,
                   ex_rate, cb_mup, cb_final, lic_price, from_date, TO_DATE,
                   region_code)
         SELECT   com_name, com_number, com_ter_code, ter_cur_code,
                  lee_cha_com_number, lic_currency, lic_type, lee_short_name,
                  lic_budget_code, supplier, con_short_name, lic_number,
                  gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                  lic_showing_int,
                  --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                  --lic_showing_lic,
                  DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                  lic_markup_percent,
                  --td_exh,
                  DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                  --SIT.R5 : SVOD Enhancements : End
                  ob_markup, COST, revel, reval_mu_loc,
                  ROUND (DECODE (revel, 0, 0, (reval_mu_loc / revel)),
                         5
                        ) rev_exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  ex_rate, (ob_markup + revel - COST) cb_mup,
                  ((ob_markup + revel - COST) * ex_rate) cb_final, lic_price,
                  from_date, TO_DATE, reg_code
             FROM (SELECT x.com_name com_name, x.com_number com_number,
                          x.com_ter_code com_ter_code,
                          x.ter_cur_code ter_cur_code,
                          flee.lee_cha_com_number, fl.lic_currency,
                          fl.lic_type, flee.lee_short_name,
                          fl.lic_budget_code,
                          RPAD (fc.com_short_name, 12, ' ') supplier,
                          fcon.con_short_name, fl.lic_number,
                          TO_CHAR (fl.lic_acct_date, 'RRRR.MM') acct_date,
                          --SUBSTR (fg.gen_title, 1, 20) gen_title,
                          TRIM (fg.gen_title) gen_title,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  fl.lic_showing_int
                                 ) lic_showing_int,
                          fl.lic_showing_lic,
                          ROUND (lic_markup_percent, 4) lic_markup_percent,
                          pkg_fin_mnet_lib_val_rep.td_exh
                                                       (fl.lic_number,
                                                        i_from_date
                                                       ) td_exh,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_ob_mp_rversal
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_mup,
                                                              i_from_date
                                                             ),
                              2
                             ) ob_markup,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_fin_ex
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_mup,
                                                              i_from_date,
                                                              i_to_date
                                                             ),
                              2
                             ) COST,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_fin_ex
                                 (fl.lic_number,
                                  xfsl.lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN fl.lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS (lic_start,
                                                                  +1
                                                                 )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) revel,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_rep_revel_fin_ex_local
                                 (fl.lic_number,
                                  xfsl.lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN fl.lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS (lic_start,
                                                                  +1
                                                                 )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) reval_mu_loc,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                             (fl.lic_currency,
                                                              x.ter_cur_code,
                                                              'P',
                                                              fl.lic_rate,
                                                              fl.lic_start,
                                                              v_go_live_date
                                                             ),
                              5
                             ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                          ROUND (xfsl.lsl_lee_price, 4) lic_price,

                          --[changed from lic_price to LSL_LEE_PRICE ]
                          i_from_date from_date, i_from_date TO_DATE,
                          fr.reg_code
                     FROM fid_general fg,
                          fid_company fc,
                          fid_contract fcon,
                          fid_licensee flee,
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          x_fin_lic_sec_lee xfsl,
                          --Dev2: Pure Finance :END
                          fid_license fl,
                          fid_region fr,
                          (SELECT fc.com_name, fc.com_number, fc.com_ter_code,
                                  ft.ter_cur_code
                             FROM fid_company fc, fid_territory ft
                            WHERE fc.com_short_name LIKE i_chnl_comp_name
                              AND fc.com_type IN ('CC', 'BC')
                              AND ft.ter_code = fc.com_ter_code) x
                    WHERE (    fl.lic_type LIKE 'FLF'
                           --AND fl.lic_status <> 'C'
                             --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/4/5]
                           --AND UPPER (fl.lic_status) NOT IN ('F', 'C', 'T')		--[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
						   AND UPPER (fl.lic_status) NOT IN ('F', 'T') 				--[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                           AND fl.lic_number = xfsl.lsl_lic_number
                           AND flee.lee_number = xfsl.lsl_lee_number
                           --Dev2: Pure Finance :End
                           AND flee.lee_short_name LIKE i_lee_short_name
                           --  AND fl.lic_lee_number = flee.lee_number
                           AND fl.lic_budget_code LIKE i_lic_budget_code
                           AND fcon.con_number = fl.lic_con_number
                           AND fc.com_number = fcon.con_com_number
                           AND fg.gen_refno = fl.lic_gen_refno

						   --Start[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                           /*AND TO_CHAR (fl.lic_acct_date, 'YYYYMM') <
                                                 TO_CHAR (i_to_date, 'YYYYMM')
                           AND TO_CHAR (fl.lic_start, 'YYYYMM') <>
                                                 TO_CHAR (i_to_date, 'YYYYMM')*/
						   --End[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports

                          -- i_period_date to I_TO_DATE
                          /* AND EXISTS (
                          SELECT 'x'
                          FROM fid_license_sub_ledger
                          WHERE lis_lic_number = lic_number
                          AND lis_per_year || LPAD (lis_per_month, 2, 0) =
                          TO_CHAR (i_period_date, 'YYYYMM')
                          AND lis_con_forecast != 0)*/
                          )
                      -- Pure Finance : Ajit : 10-Apr-2013 : Check if the inventory is not
                      -- equal to 0 for the given time period
                      AND EXISTS (
                             SELECT   'x'
                                 FROM x_mv_subledger_data flsl
                                /*fid_license_sub_ledger*/
                             WHERE    flsl.lis_lic_number = fl.lic_number
                                  AND flsl.lis_lsl_number = xfsl.lsl_number
                                  AND flsl.lis_yyyymm_num BETWEEN TO_CHAR (i_from_date,'YYYYMM') AND TO_CHAR (i_to_date,'YYYYMM') --[15-Jun-2016]Added by Jawahar so the data will not change for close month reports

                                          --Start[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
										 /*BETWEEN CASE
                                         WHEN TO_NUMBER (TO_CHAR (lic_start,
                                                                  'YYYYMM'
                                                                 )
                                                        ) >
                                                TO_NUMBER
                                                        (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                            THEN   TO_NUMBER
                                                          (TO_CHAR (lic_start,
                                                                    'YYYYMM'
                                                                   )
                                                          )
                                                 + 1
                                         ELSE TO_NUMBER (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                      END
                                             AND TO_NUMBER
                                                          (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )*/
										--END[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                                  AND flsl.lis_reval_flag = 'PC'
                             GROUP BY flsl.lis_lic_number,
                                      flsl.lis_lsl_number
                               --  HAVING SUM (lis_con_forecast) <> 0)
                             HAVING   (   SUM (lis_con_fc_emu)
                                                              /*SUM (flsl.lis_con_forecast)*/
                                          <> 0
                                       OR SUM (flsl.lis_loc_forecast) <> 0
                                      )
								  )
                      AND (x.com_number = flee.lee_cha_com_number)
                      -- Pure Finance : Ajit : 10-Apr-2013 : split region mapping changed from lee
                      -- region id to lee split region
                      AND flee.lee_split_region = fr.reg_id
                      AND fr.reg_code LIKE i_lic_region)
            WHERE 1 = 1
         ORDER BY 2 ASC,
                  1 ASC,
                  3 ASC,
                  4 ASC,
                  5 ASC,
                  6 ASC,
                  lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  lic_number ASC,
                  con_short_name,
                  gen_title;

      OPEN O_LIB_REP FOR
         SELECT EF.COM_NAME "CHANNEL_COMPANY", EF.LIC_CURRENCY, TO_CHAR(EF.FROM_DATE, 'DD-MON-RRRR') FROM_DATE,
                TO_CHAR(ef.TO_DATE, 'DD-MON-RRRR') TO_DATE, ef.ter_cur_code, ef.ex_rate "EXCHANGE_RATE",
                ef.lic_type, ef.lee_short_name, ef.lic_budget_code,
                EF.SUPPLER, EF.CON_SHORT_NAME "CONTRACT", EF.LIC_NUMBER,
                ef.gen_title
                ,EF.ACCT_DATE
                ,EF.LIC_START
                ,ef.lic_end,
                ef.lic_amort_code, ef.lic_showing_int, ef.lic_showing_lic,
                ef.td_exh, ef.lic_markup_percent, ef.ob_mup ob_markup,
                ef.reval revel, ef.reval_exh_rate, ef.reval_loc, ef.COST,
                ef.cb_mup "CB_MARKUP", ef.ex_rate, ef.cb_final "CB_CLOSE",
                ef.region_code
           FROM exl_inventory_for_flf ef;
		END IF;
	END prc_prg_lib_re_valution_flf_x;

   PROCEDURE prc_prg_lib_re_valu_roy_rev (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      --Dev2: Pure Finance :End
      i_lic_region        IN       VARCHAR2,                -- added for split
      i_acc_prv_rate      IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (3000);
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
      OPEN o_lib_rep FOR
         SELECT   com_name, com_number, ter_cur_code, lic_currency, lic_type,
                  lee_short_name, lic_budget_code, supplier, con_short_name,
                  lic_number, gen_title, acct_date, lic_start, lic_end,
                  lic_amort_code, lic_showing_int, lic_showing_lic,
                  lic_markup_percent, td_exh,
                  ob_markup, COST,
                  revel,
                  reval_mu_loc,
                  ROUND (DECODE (revel, 0, 0, (reval_mu_loc / revel)),
                         5
                        ) rev_exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  ex_rate,
                  CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                  THEN 0
                  ELSE (ob_markup + revel - COST)
                  END cb_mup,
                  CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                  THEN 0
                  ELSE ((ob_markup + revel - COST) * ex_rate)
                  END cb_final,
                  lic_price,
                  from_date, TO_DATE, reg_code
             FROM (SELECT bfc.com_number com_number,
                          fl.lic_currency lic_currency, fl.lic_type,
                          flee.lee_short_name, fl.lic_budget_code,
                          RPAD (afc.com_short_name, 12, ' ') supplier,
                          fcon.con_short_name, fl.lic_number,
                          SUBSTR (fg.gen_title, 1, 20) gen_title,
                          TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  fl.lic_showing_int
                                 ) lic_showing_int,
                          fl.lic_showing_lic,
                          ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                          fl.lic_rate, ft.ter_cur_code, bfc.com_name com_name,
                          pkg_fin_mnet_lib_val_rep.td_exh
                                                       (fl.lic_number,
                                                        i_from_date
                                                       ) td_exh,

                          --0  td_exh,                                 -- pending
                          CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                          round
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_ob_mp_rversal
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_mup,
                                                              i_from_date
                                                             ),
                              2
                             )
                          END ob_markup,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                          round
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_fin_ex
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_mup,
                                                              i_from_date,
                                                              i_to_date
                                                             ),
                              2
                             )
                          END COST,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_fin_roy
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_mup,
                                                              i_from_date,
                                                              i_to_date
                                                             ),
                              2
                             ) revel,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_rep_revel_fin_ex_local_roy
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_mup,
                                                              i_from_date,
                                                              i_to_date
                                                             ),
                              2
                             ) reval_mu_loc,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                             (fl.lic_currency,
                                                              ft.ter_cur_code,
                                                              'P',
                                                              fl.lic_rate,
                                                              fl.lic_start,
                                                              v_go_live_date
                                                             ),
                              5
                             )
                          END ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                          ROUND (xfsl.lsl_lee_price, 4) lic_price,

                          --[changed from lic_price to LSL_LEE_PRICE ]
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          i_from_date from_date, i_to_date TO_DATE,
                          fr.reg_code
                     --Dev2: Pure Finance :END
                   FROM   fid_general fg,
                          fid_company afc,
                          fid_company bfc,
                          fid_contract fcon,
                          fid_licensee flee,
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          x_fin_lic_sec_lee xfsl,
                          --Dev2: Pure Finance :END
                          fid_license fl,
                          fid_territory ft,
                          fid_region fr                     -- added for split
                    /*,    (SELECT    com_name
                    ,    com_number
                    ,    com_ter_code
                    FROM    fid_company
                    WHERE      com_short_name LIKE  i_chnl_comp_name
                    AND       com_type  IN ('CC','BC')
                    )x*/
                   WHERE  flee.lee_cha_com_number = bfc.com_number
                      AND bfc.com_short_name LIKE i_chnl_comp_name
                      AND bfc.com_type IN ('CC', 'BC')
                      AND ft.ter_code LIKE bfc.com_ter_code
                      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/4/5]
                      AND fl.lic_type = 'ROY'
                      --AND UPPER (fl.lic_status) NOT IN ('F', 'C', 'T')		--[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
					  AND UPPER (fl.lic_status) NOT IN ('F', 'T') 				--[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                      AND fl.lic_number = xfsl.lsl_lic_number
                      AND flee.lee_number = xfsl.lsl_lee_number
                      AND fr.reg_id(+) = flee.lee_split_region
                      --Dev2: Pure Finance :End
                      AND flee.lee_short_name LIKE i_lee_short_name
                      -- AND lic_lee_number = lee_number
                      AND fl.lic_budget_code LIKE i_lic_budget_code
                      AND fcon.con_number = fl.lic_con_number
                      AND afc.com_number = fcon.con_com_number
                      AND fg.gen_refno = fl.lic_gen_refno
                      -- split
                      AND fr.reg_code LIKE i_lic_region
					  --[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                      /*AND TO_CHAR (fl.lic_acct_date, 'YYYYMM') <
                             TO_CHAR
                                  ((SELECT   LAST_DAY (ADD_MONTHS (i_to_date,
                                                                   -1
                                                                  )
                                                      )
                                           + 1
                                      FROM DUAL),
                                   'YYYYMM'
                                  )*/
                      /*AND EXISTS (
                      SELECT 'x'
                      FROM fid_license_sub_ledger
                      WHERE LIS_LIC_NUMBER = LIC_NUMBER
                      AND( LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0)
                      --= TO_NUMBER (TO_CHAR (TO_DATE (i_period_date),'YYYYMM'))
                      between fun_get_date(lic_start,i_from_date) and i_to_date )
                      and lis_con_forecast != 0) */
                      -- Pure Finance : Ajit : 10-Apr-2013 : Check if the inventory is not
                      -- equal to 0 for the given time period
                      AND EXISTS (
                             SELECT   'x'
                                 FROM x_mv_subledger_data flsl
                                /*fid_license_sub_ledger*/
                             WHERE    flsl.lis_lic_number = fl.lic_number
                                  AND flsl.lis_lsl_number = xfsl.lsl_number
                                  AND flsl.lis_yyyymm_num  BETWEEN TO_CHAR (i_from_date,'YYYYMM') AND TO_CHAR (i_to_date,'YYYYMM') --[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                                    --Start[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
									/*BETWEEN CASE
                                         WHEN TO_NUMBER
                                                       (TO_CHAR (fl.lic_start,
                                                                 'YYYYMM'
                                                                )
                                                       ) >
                                                TO_NUMBER
                                                        (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                            THEN   TO_NUMBER
                                                       (TO_CHAR (fl.lic_start,
                                                                 'YYYYMM'
                                                                )
                                                       )
                                                 + 1
                                         ELSE TO_NUMBER (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                      END
                                             AND TO_NUMBER
                                                          (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )*/
									--End[15-Jun-2016]Commented by Jawahar so the data will not change for close month reports
                                  AND flsl.lis_reval_flag = 'PC'
                             GROUP BY flsl.lis_lic_number,
                                      flsl.lis_lsl_number
                               HAVING SUM (flsl.lis_con_fc_emu) <> 0)
							 )
            WHERE 1 = 1
         ORDER BY lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  gen_title,
                  lic_number;
   END prc_prg_lib_re_valu_roy_rev;

   PROCEDURE prc_prg_lib_re_valu_roy_rev_x (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      --Dev2: Pure Finance :End
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,                 -- added for split
			i_acc_prv_rate      IN       VARCHAR2
   )
   AS
      l_qry            VARCHAR2 (3000);
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      v_go_live_date   DATE;
   --Dev2: Pure Finance :End
   BEGIN
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      DELETE FROM exl_inventory_for_royrvluation;

      COMMIT;

      --Dev2: Pure Finance :End

		IF i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
		THEN
			INSERT INTO exl_inventory_for_royrvluation
                  (com_number, lic_currency, lic_type, lee_short_name,
                   lic_budget_code, suppler, con_short_name, lic_number,
                   gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                   lic_showing_int, lic_showing_lic, lic_markup_percent,
                   lic_rate, ter_cur_code, com_name, td_exh, reval,
                   reval_loc, reval_exh_rate,
                   lic_price, from_date, TO_DATE, region_code)
         SELECT   com_number, lic_currency, lic_type, lee_short_name,
                  lic_budget_code, supplier, con_short_name, lic_number,
                  gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                  lic_showing_int, lic_showing_lic, lic_markup_percent,
                  lic_rate, ter_cur_code, com_name, td_exh, reval,
                  reval_mu_loc,
                  ROUND (DECODE (reval, 0, 0, (reval_mu_loc / reval)),
                         5
                        ) rev_exh_rate, lic_price,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  from_date, TO_DATE, reg_code
             FROM (SELECT bfc.com_number com_number,
                          TRIM (fl.lic_currency) lic_currency, fl.lic_type,
                          TRIM (flee.lee_short_name) lee_short_name,
                          TRIM (fl.lic_budget_code) lic_budget_code,
                          TRIM (RPAD (afc.com_short_name, 12, ' ')) supplier,
                          TRIM (fcon.con_short_name) con_short_name,
                          fl.lic_number,
                          --TRIM (SUBSTR (fg.gen_title, 1, 20)) gen_title,
                          TRIM (fg.gen_title) gen_title,
                          TO_CHAR (fl.lic_acct_date, 'RRRR.MM') acct_date,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  fl.lic_showing_int
                                 ) lic_showing_int,
                          fl.lic_showing_lic,
                          ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                          fl.lic_rate, ft.ter_cur_code, bfc.com_name com_name,
                          pkg_fin_mnet_lib_val_rep.td_exh
                                                       (fl.lic_number,
                                                        i_from_date
                                                       ) td_exh,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_fin_ex
                                 (fl.lic_number,
                                  xfsl.lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS (lic_start,
                                                                  +1
                                                                 )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) reval,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_rep_revel_fin_ex_local
                                 (fl.lic_number,
                                  xfsl.lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN fl.lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS
                                                                (fl.lic_start,
                                                                 +1
                                                                )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) reval_mu_loc,
                          ROUND (xfsl.lsl_lee_price, 4) lic_price,

                          --[changed from lic_price to LSL_LEE_PRICE ]
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          i_from_date from_date, i_from_date TO_DATE,
                          fr.reg_code
                     --Dev2: Pure Finance :END
                   FROM   fid_general fg,
                          fid_company afc,
                          fid_company bfc,
                          fid_contract fcon,
                          fid_licensee flee,
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          x_fin_lic_sec_lee xfsl,
                          --Dev2: Pure Finance :END
                          fid_license fl,
                          fid_territory ft,
                          fid_region fr                     -- added for split
                    /*,    (SELECT    com_name
                    ,    com_number
                    ,    com_ter_code
                    FROM    fid_company
                    WHERE      com_short_name LIKE  i_chnl_comp_name
                    AND       com_type  IN ('CC','BC')
                    )x*/
                   WHERE  flee.lee_cha_com_number = bfc.com_number
                      AND bfc.com_short_name LIKE i_chnl_comp_name
                      AND bfc.com_type IN ('CC', 'BC')
                      AND ft.ter_code LIKE bfc.com_ter_code
                      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/4/5]
                      AND fl.lic_type = 'ROY'
                      --AND UPPER (fl.lic_status) NOT IN ('F', 'C', 'T')		--[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
					  AND UPPER (fl.lic_status) NOT IN ('F', 'T') 				--[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                      AND fl.lic_number = xfsl.lsl_lic_number
                      AND flee.lee_number = xfsl.lsl_lee_number
                      AND fr.reg_id(+) = flee.lee_split_region
                      --Dev2: Pure Finance :End
                      AND flee.lee_short_name LIKE i_lee_short_name
                      -- AND lic_lee_number = lee_number
                      AND fl.lic_budget_code LIKE i_lic_budget_code
                      AND fcon.con_number = fl.lic_con_number
                      AND afc.com_number = fcon.con_com_number
                      AND fg.gen_refno = fl.lic_gen_refno
                      -- split
                      AND fr.reg_code LIKE i_lic_region
					  --Start[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
					  /*
                      AND TO_CHAR (fl.lic_acct_date, 'YYYYMM') <
                             TO_CHAR
                                  ((SELECT   LAST_DAY (ADD_MONTHS (i_to_date,
                                                                   -1
                                                                  )
                                                      )
                                           + 1
                                      FROM DUAL),
                                   'YYYYMM'
                                  )
					  */
					  --END[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
                      /*AND EXISTS (
                      SELECT 'x'
                      FROM fid_license_sub_ledger
                      WHERE LIS_LIC_NUMBER = LIC_NUMBER
                      AND( LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0)
                      --= TO_NUMBER (TO_CHAR (TO_DATE (i_period_date),'YYYYMM'))
                      between fun_get_date(lic_start,i_from_date) and i_to_date )
                      and lis_con_forecast != 0) */
                      -- Pure Finance : Ajit : 10-Apr-2013 : Check if the inventory is not
                      -- equal to 0 for the given time period
                      AND EXISTS (
                             ---------------Finance Report Rewrite_[Start]---------
                             SELECT   'x'
                                 FROM x_mv_subledger_data mvlsl
                                WHERE mvlsl.lis_lic_number = fl.lic_number
                                  AND mvlsl.lis_lsl_number = xfsl.lsl_number
                                  AND mvlsl.lis_yyyymm_num BETWEEN TO_CHAR (i_from_date,'YYYYMM') AND TO_CHAR (i_to_date,'YYYYMM') --[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                                         ---------------Finance Report Rewrite_[End]--------
                                       --Start[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
									  /*BETWEEN CASE
                                         WHEN TO_NUMBER
                                                       (TO_CHAR (fl.lic_start,
                                                                 'YYYYMM'
                                                                )
                                                       ) >
                                                TO_NUMBER
                                                        (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                            THEN   TO_NUMBER
                                                       (TO_CHAR (fl.lic_start,
                                                                 'YYYYMM'
                                                                )
                                                       )
                                                 + 1
                                         ELSE TO_NUMBER (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                      END
                                             AND TO_NUMBER
                                                          (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )*/
									 --End[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
                                  AND mvlsl.lis_reval_flag = 'PC'
                             GROUP BY mvlsl.lis_lic_number,
                                      mvlsl.lis_lsl_number
                               HAVING SUM (mvlsl.lis_con_fc_emu) <> 0
							   ))
            WHERE 1 = 1
         ORDER BY lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  gen_title,
                  lic_number;

      OPEN O_LIB_REP FOR
         SELECT   err.com_name, err.lic_currency, TO_CHAR(err.from_date, 'DD-MON-RRRR') from_date,
                  TO_CHAR(ERR.TO_DATE, 'DD-MON-RRRR') TO_DATE, ERR.TER_CUR_CODE,
                  err.ex_rate "EXCHANGE_RATE", err.lic_type,
                  err.lee_short_name, err.lic_budget_code, err.suppler,
                  err.con_short_name "CONTRACT", err.lic_number,
                  ERR.GEN_TITLE
                  ,ERR.ACCT_DATE
                  ,err.lic_start
                  ,err.lic_end,
                  err.lic_amort_code, err.lic_showing_int,
                  err.lic_showing_lic, err.td_exh, err.lic_markup_percent, err.reval revel,
                  err.reval_exh_rate, err.reval_loc, err.region_code
             FROM exl_inventory_for_royrvluation err
         ORDER BY lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  suppler,
                  con_short_name,
                  gen_title,
                  lic_number;
		ELSE
			INSERT INTO exl_inventory_for_royrvluation
                  (com_number, lic_currency, lic_type, lee_short_name,
                   lic_budget_code, suppler, con_short_name, lic_number,
                   gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                   lic_showing_int, lic_showing_lic, lic_markup_percent,
                   lic_rate, ter_cur_code, com_name, td_exh, ob_markup, reval,
                   reval_loc, reval_exh_rate, COST, cb_mup, ex_rate, cb_final,
                   lic_price, from_date, TO_DATE, region_code)
         SELECT   com_number, lic_currency, lic_type, lee_short_name,
                  lic_budget_code, supplier, con_short_name, lic_number,
                  gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                  lic_showing_int, lic_showing_lic, lic_markup_percent,
                  lic_rate, ter_cur_code, com_name, td_exh, ob_markup, reval,
                  reval_mu_loc,
                  ROUND (DECODE (reval, 0, 0, (reval_mu_loc / reval)),
                         5
                        ) rev_exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  COST, (ob_markup + reval - COST) cb_mup, ex_rate,
                  ((ob_markup + reval - COST) * ex_rate) cb_final, lic_price,
                  from_date, TO_DATE, reg_code
             FROM (SELECT bfc.com_number com_number,
                          TRIM (fl.lic_currency) lic_currency, fl.lic_type,
                          TRIM (flee.lee_short_name) lee_short_name,
                          TRIM (fl.lic_budget_code) lic_budget_code,
                          TRIM (RPAD (afc.com_short_name, 12, ' ')) supplier,
                          TRIM (fcon.con_short_name) con_short_name,
                          fl.lic_number,
                          --TRIM (SUBSTR (fg.gen_title, 1, 20)) gen_title,
                          TRIM (fg.gen_title) gen_title,
                          TO_CHAR (fl.lic_acct_date, 'RRRR.MM') acct_date,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  fl.lic_showing_int
                                 ) lic_showing_int,
                          fl.lic_showing_lic,
                          ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                          fl.lic_rate, ft.ter_cur_code, bfc.com_name com_name,
                          pkg_fin_mnet_lib_val_rep.td_exh
                                                       (fl.lic_number,
                                                        i_from_date
                                                       ) td_exh,

                          --0  td_exh,                                 -- pending
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_ob_mp_rversal
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_mup,
                                                              i_from_date
                                                             ),
                              2
                             ) ob_markup,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_fin_ex
                                                             (fl.lic_number,
                                                              xfsl.lsl_number,
                                                              i_mup,
                                                              i_from_date,
                                                              i_to_date
                                                             ),
                              2
                             ) COST,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_fin_ex
                                 (fl.lic_number,
                                  xfsl.lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS (lic_start,
                                                                  +1
                                                                 )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) reval,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_rep_revel_fin_ex_local
                                 (fl.lic_number,
                                  xfsl.lsl_number,
                                  i_mup,
                                  (CASE
                                      WHEN fl.lic_start > i_from_date
                                         THEN (SELECT ADD_MONTHS
                                                                (fl.lic_start,
                                                                 +1
                                                                )
                                                 FROM DUAL)
                                      ELSE i_from_date
                                   END
                                  )
                                 ),
                              2
                             ) reval_mu_loc,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                             (fl.lic_currency,
                                                              ft.ter_cur_code,
                                                              'P',
                                                              fl.lic_rate,
                                                              fl.lic_start,
                                                              v_go_live_date
                                                             ),
                              5
                             ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                          ROUND (xfsl.lsl_lee_price, 4) lic_price,

                          --[changed from lic_price to LSL_LEE_PRICE ]
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          i_from_date from_date, i_from_date TO_DATE,
                          fr.reg_code
                     --Dev2: Pure Finance :END
                   FROM   fid_general fg,
                          fid_company afc,
                          fid_company bfc,
                          fid_contract fcon,
                          fid_licensee flee,
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          x_fin_lic_sec_lee xfsl,
                          --Dev2: Pure Finance :END
                          fid_license fl,
                          fid_territory ft,
                          fid_region fr                     -- added for split
                    /*,    (SELECT    com_name
                    ,    com_number
                    ,    com_ter_code
                    FROM    fid_company
                    WHERE      com_short_name LIKE  i_chnl_comp_name
                    AND       com_type  IN ('CC','BC')
                    )x*/
                   WHERE  flee.lee_cha_com_number = bfc.com_number
                      AND bfc.com_short_name LIKE i_chnl_comp_name
                      AND bfc.com_type IN ('CC', 'BC')
                      AND ft.ter_code LIKE bfc.com_ter_code
                      --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/4/5]
                      AND fl.lic_type = 'ROY'
                      --AND UPPER (fl.lic_status) NOT IN ('F', 'C', 'T')		--[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
					  AND UPPER (fl.lic_status) NOT IN ('F', 'T') 				--[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                      AND fl.lic_number = xfsl.lsl_lic_number
                      AND flee.lee_number = xfsl.lsl_lee_number
                      AND fr.reg_id(+) = flee.lee_split_region
                      --Dev2: Pure Finance :End
                      AND flee.lee_short_name LIKE i_lee_short_name
                      -- AND lic_lee_number = lee_number
                      AND fl.lic_budget_code LIKE i_lic_budget_code
                      AND fcon.con_number = fl.lic_con_number
                      AND afc.com_number = fcon.con_com_number
                      AND fg.gen_refno = fl.lic_gen_refno
                      -- split
                      AND fr.reg_code LIKE i_lic_region
					  --Start[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
					  /*
                      AND TO_CHAR (fl.lic_acct_date, 'YYYYMM') <
                             TO_CHAR
                                  ((SELECT   LAST_DAY (ADD_MONTHS (i_to_date,
                                                                   -1
                                                                  )
                                                      )
                                           + 1
                                      FROM DUAL),
                                   'YYYYMM'
                                  )
					  */
					  --END[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
                      /*AND EXISTS (
                      SELECT 'x'
                      FROM fid_license_sub_ledger
                      WHERE LIS_LIC_NUMBER = LIC_NUMBER
                      AND( LIS_PER_YEAR || LPAD (LIS_PER_MONTH, 2, 0)
                      --= TO_NUMBER (TO_CHAR (TO_DATE (i_period_date),'YYYYMM'))
                      between fun_get_date(lic_start,i_from_date) and i_to_date )
                      and lis_con_forecast != 0) */
                      -- Pure Finance : Ajit : 10-Apr-2013 : Check if the inventory is not
                      -- equal to 0 for the given time period
                      AND EXISTS (
                             ---------------Finance Report Rewrite_[Start]---------
                             SELECT   'x'
                                 FROM x_mv_subledger_data mvlsl
                                WHERE mvlsl.lis_lic_number = fl.lic_number
                                  AND mvlsl.lis_lsl_number = xfsl.lsl_number
                                  AND mvlsl.lis_yyyymm_num BETWEEN TO_CHAR (i_from_date,'YYYYMM') AND TO_CHAR (i_to_date,'YYYYMM') --[15-Jun-2016]Added by Jawahar so the data will not change for close month reports
                                         ---------------Finance Report Rewrite_[End]--------
                                       --Start[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
									  /*BETWEEN CASE
                                         WHEN TO_NUMBER
                                                       (TO_CHAR (fl.lic_start,
                                                                 'YYYYMM'
                                                                )
                                                       ) >
                                                TO_NUMBER
                                                        (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                            THEN   TO_NUMBER
                                                       (TO_CHAR (fl.lic_start,
                                                                 'YYYYMM'
                                                                )
                                                       )
                                                 + 1
                                         ELSE TO_NUMBER (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                      END
                                             AND TO_NUMBER
                                                          (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )*/
									 --End[15-Jun-2016]Commented by Jawahar as lic status NOT IN C is not required
                                  AND mvlsl.lis_reval_flag = 'PC'
                             GROUP BY mvlsl.lis_lic_number,
                                      mvlsl.lis_lsl_number
                               HAVING SUM (mvlsl.lis_con_fc_emu) <> 0
								  )
								 )
            WHERE 1 = 1
         ORDER BY lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  gen_title,
                  lic_number;

      OPEN O_LIB_REP FOR
         SELECT   err.com_name, err.lic_currency, TO_CHAR(err.from_date, 'DD-MON-RRRR') from_date,
                  TO_CHAR(ERR.TO_DATE, 'DD-MON-RRRR') TO_DATE, ERR.TER_CUR_CODE,
                  err.ex_rate "EXCHANGE_RATE", err.lic_type,
                  err.lee_short_name, err.lic_budget_code, err.suppler,
                  err.con_short_name "CONTRACT", err.lic_number,
                  ERR.GEN_TITLE
                  ,ERR.ACCT_DATE
                  ,err.lic_start
                  ,err.lic_end,
                  err.lic_amort_code, err.lic_showing_int,
                  err.lic_showing_lic, err.td_exh, err.lic_markup_percent,
                  err.ob_markup "OB_MARKUP", err.reval revel,
                  err.reval_exh_rate, err.reval_loc, err.COST,
                  err.cb_mup "CB_MARKUP", err.ex_rate,
                  err.cb_final "CB_CLOSE", err.region_code
             FROM exl_inventory_for_royrvluation err
         ORDER BY lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  suppler,
                  con_short_name,
                  gen_title,
                  lic_number;
		END IF;
   END prc_prg_lib_re_valu_roy_rev_x;

--LIBRARY RE-VALUATION REPORT - CANCELLATION
   PROCEDURE prc_prg_lib_re_valu_canc (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      -- Pure Finance : Ajit : 10-Apr-2013 : Instead of period, from date and
      -- to date aaded : Start
      --i_period_date     in       date,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      -- Pure Finance :End
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,                 -- added for split
      i_acc_prv_rate      IN       VARCHAR2
   )
   AS
      l_qry            VARCHAR2 (3000);
      v_go_live_date   DATE;
   BEGIN
      -- Pure Finance : Ajit : 10-Apr-2013 : Get the Pure Finance Go-Live date : Start
      SELECT TO_DATE (content, 'DD-MON-YYYY')
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      -- Pure Finance :End
      OPEN o_lib_rep FOR

          SELECT channel_company, lic_currency, lic_type, lee_short_name,
                lic_budget_code, com_short_name, con_short_name, lic_number,
                gen_title
                ,LIC_ACCT_DATE
                ,lic_start
                ,LIC_END
                ,lic_amort_code,
                lic_showing_int,
                --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                --lic_showing_lic,
                DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                lic_markup_percent, lic_rate, ter_cur_code,
                --td_exh,
                DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                --SIT.R5 : SVOD Enhancements : End
                ob_markup,
                CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                THEN 0
                ELSE ROUND ((ob_markup + revel - COST), 2)
                END cb_mup,
                revel,
                reval_mu_loc,
                ROUND (DECODE (revel, 0, 0, (reval_mu_loc / revel)),
                       5
                      ) rev_exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                COST,
                ex_rate,
                CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                then 0
                ELSE round ((ob_markup + revel - COST) * ex_rate, 2)
                END cb_final
           FROM (SELECT DISTINCT x.com_name "CHANNEL_COMPANY",
                                 fl.lic_currency, fl.lic_type,
                                 flee.lee_short_name, fl.lic_budget_code,
                                 RPAD (afc.com_short_name,
                                       12,
                                       ' '
                                      ) com_short_name,
                                 fcon.con_short_name, fl.lic_number,
                                 --SUBSTR (fg.gen_title, 1, 20) gen_title,
                                 TRIM (fg.gen_title) gen_title,
                                 TO_CHAR (fl.lic_acct_date,
                                          'YYYY.MM'
                                         ) lic_acct_date,
                                 TO_CHAR (fl.lic_start,
                                          'DDMonYYYY') lic_start,
                                 TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                                 fl.lic_amort_code,
                                 DECODE (fl.lic_catchup_flag,
                                         'Y', NULL,
                                         fl.lic_showing_int
                                        ) lic_showing_int,
                                 fl.lic_showing_lic,
                                 ROUND
                                    (fl.lic_markup_percent,
                                     4
                                    ) lic_markup_percent,
                                 fl.lic_rate, ft.ter_cur_code,
                                 pkg_fin_mnet_lib_val_rep.td_exh
                                                          (lic_number,
                                                           i_from_date
                                                          ) td_exh,

                                 -- sum of +Ve inventory before the to date
                          CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                                ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_ob_mp_rversal
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date),
                                     2
                                    )
                          END ob_markup,

                                 -- sum of -ve inventory during the report period
                                 ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_cancl
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date,
                                         i_to_date
                                        ),
                                     2
                                    ) revel,
                                 ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_rep_revel_cancl_loc
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date,
                                         i_to_date
                                        ),
                                     2
                                    ) reval_mu_loc,

                                 -- Get the Cost before the to date
                          CASE WHEN i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                               ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_fin_ex
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date,
                                         i_to_date
                                        ),
                                     2
                                    )
                          END COST,

                                 -- If license start date before Pure Finance Go-live then
                                 -- use existsing rate of if the license start date is after
                                 -- the pure finance Go-live then use license rate
                                 ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                'P',
                                                                lic_rate,
                                                                lic_start,
                                                                v_go_live_date
                                                               ),
                                     5
                                    ) ex_rate   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                            FROM fid_general fg,
                                 fid_company afc,
                                 --fid_company bfc,  /*not used*/
                                 fid_contract fcon,
                                 fid_licensee flee,
                                 fid_license fl,
                                 fid_region fr,             -- added for split
                                 fid_territory ft,
                                 --Pure Finance: Ajit: 10-Apr-2013 : Sec lee table added : start
                                 x_fin_lic_sec_lee xfsl,

                                 -- Pure Finance :END
                                 (SELECT fc.com_name, fc.com_number,
                                         fc.com_ter_code
                                    FROM fid_company fc
                                   WHERE fc.com_short_name LIKE
                                                              i_chnl_comp_name
                                     AND fc.com_type IN ('CC', 'BC')) x
                           WHERE flee.lee_cha_com_number = x.com_number
                             AND ft.ter_code LIKE x.com_ter_code
                             AND fl.lic_type LIKE i_lic_type
                             AND flee.lee_short_name LIKE i_lee_short_name
                             --AND lic_lee_number = lee_number
                             AND fl.lic_budget_code LIKE i_lic_budget_code
                             AND fcon.con_number = fl.lic_con_number
                             AND afc.com_number = fcon.con_com_number
                             AND fg.gen_refno = fl.lic_gen_refno
                             -- Pure Finance : Ajit : 10-Apr-2013 : Lee joined changed, used
                             -- seconddary licnese referance and split region mapping changed from lee
                             -- region id to lee split region
                             AND xfsl.lsl_lic_number = fl.lic_number
                             AND xfsl.lsl_lee_number = flee.lee_number
                             AND flee.lee_split_region = fr.reg_id
                             and fr.reg_code like i_lic_region
                             /*AND fl.lic_status = 'C'
                             AND TO_NUMBER (TO_CHAR (fl.lic_cancel_date,
                                                     'YYYYMM'
                                                    )
                                           ) <=
                                     TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))*/
                             -- Pure Finance : Ajit : 10-Apr-2013
                             -- Check for if any month between the from date and todate
                             -- there is -ve inventory
                             AND EXISTS (
                                    SELECT 'x'
                                      FROM x_mv_subledger_data
                                                              /*fid_license_sub_ledger*/
                                           flsl
                                     WHERE flsl.lis_lic_number = fl.lic_number
                                       AND flsl.lis_lsl_number =
                                                               xfsl.lsl_number
                                       AND
                                           /*flsl.lis_per_year|| LPAD (flsl.lis_per_month, 2, 0)*/
                                           flsl.lis_yyyymm_num
                                              BETWEEN TO_NUMBER
                                                        (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                                  AND TO_NUMBER
                                                          (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )
                                       AND flsl.lis_con_fc_emu <> 0
									   AND flsl.lis_reval_flag = 'CL')
                        ORDER BY fl.lic_currency,
                                 fl.lic_type,
                                 flee.lee_short_name,
                                 fl.lic_budget_code,
                                 RPAD (afc.com_short_name, 12, ' '),
                                 fcon.con_short_name,
                                 fl.lic_number);
   END prc_prg_lib_re_valu_canc;

  PROCEDURE prc_prg_lib_re_valu_canc_x (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_mup               IN       CHAR,
      -- Pure Finance : Ajit : 10-Apr-2013 : Instead of period, from date and
      -- to date aaded : Start
      --i_period_date     in       date,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      -- Pure Finance :End
      o_lib_rep           out      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,                 -- added for split
			i_acc_prv_rate      IN       VARCHAR2
   )
   AS
      l_qry            VARCHAR2 (3000);
      v_go_live_date   DATE;
   BEGIN
      -- Pure Finance : Ajit : 10-Apr-2013 : Get the Pure Finance Go-Live date : Start
      SELECT TO_DATE (content, 'DD-MON-YYYY')
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      -- Pure Finance :End

		IF i_acc_prv_rate = 'B' AND i_mup = 'I' AND i_to_date >= to_date('01-Jun-2016')
		THEN
			OPEN o_lib_rep FOR
				 SELECT channel_company, lic_currency, lic_type, lee_short_name,
                lic_budget_code, com_short_name, con_short_name, lic_number,
                gen_title
                ,LIC_ACCT_DATE
                ,lic_start
                ,LIC_END
                ,lic_amort_code,
                lic_showing_int,
                --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                --lic_showing_lic,
                DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                lic_markup_percent, lic_rate, ter_cur_code,
                --td_exh,
                DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                --SIT.R5 : SVOD Enhancements : End
                revel,
                reval_mu_loc,
                ROUND (DECODE (revel, 0, 0, (reval_mu_loc / revel)),
                       5
                      ) rev_exh_rate   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
           FROM (SELECT DISTINCT x.com_name "CHANNEL_COMPANY",
                                 fl.lic_currency, fl.lic_type,
                                 flee.lee_short_name, fl.lic_budget_code,
                                 RPAD (afc.com_short_name,
                                       12,
                                       ' '
                                      ) com_short_name,
                                 fcon.con_short_name, fl.lic_number,
                                 --SUBSTR (fg.gen_title, 1, 20) gen_title,
                                 TRIM (fg.gen_title) gen_title,
                                 TO_CHAR (fl.lic_acct_date,
                                          'YYYY.MM'
                                         ) lic_acct_date,
                                 TO_CHAR (fl.lic_start,
                                          'DDMonYYYY') lic_start,
                                 TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                                 fl.lic_amort_code,
                                 DECODE (fl.lic_catchup_flag,
                                         'Y', NULL,
                                         fl.lic_showing_int
                                        ) lic_showing_int,
                                 fl.lic_showing_lic,
                                 ROUND
                                    (fl.lic_markup_percent,
                                     4
                                    ) lic_markup_percent,
                                 fl.lic_rate, ft.ter_cur_code,
                                 pkg_fin_mnet_lib_val_rep.td_exh
                                                          (lic_number,
                                                           i_from_date
                                                          ) td_exh,
                                 -- sum of -ve inventory during the report period
                                 ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_cancl
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date,
                                         i_to_date
                                        ),
                                     2
                                    ) revel,
                                 ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_rep_revel_cancl_loc
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date,
                                         i_to_date
                                        ),
                                     2
                                    ) reval_mu_loc
                            FROM fid_general fg,
                                 fid_company afc,
                                 --fid_company bfc,  /*not used*/
                                 fid_contract fcon,
                                 fid_licensee flee,
                                 fid_license fl,
                                 fid_region fr,             -- added for split
                                 fid_territory ft,
                                 --Pure Finance: Ajit: 10-Apr-2013 : Sec lee table added : start
                                 x_fin_lic_sec_lee xfsl,

                                 -- Pure Finance :END
                                 (SELECT fc.com_name, fc.com_number,
                                         fc.com_ter_code
                                    FROM fid_company fc
                                   WHERE fc.com_short_name LIKE
                                                              i_chnl_comp_name
                                     AND fc.com_type IN ('CC', 'BC')) x
                           WHERE flee.lee_cha_com_number = x.com_number
                             AND ft.ter_code LIKE x.com_ter_code
                             AND fl.lic_type LIKE i_lic_type
                             AND flee.lee_short_name LIKE i_lee_short_name
                             --AND lic_lee_number = lee_number
                             AND fl.lic_budget_code LIKE i_lic_budget_code
                             AND fcon.con_number = fl.lic_con_number
                             AND afc.com_number = fcon.con_com_number
                             AND fg.gen_refno = fl.lic_gen_refno
                             -- Pure Finance : Ajit : 10-Apr-2013 : Lee joined changed, used
                             -- seconddary licnese referance and split region mapping changed from lee
                             -- region id to lee split region
                             AND xfsl.lsl_lic_number = fl.lic_number
                             AND xfsl.lsl_lee_number = flee.lee_number
                             AND flee.lee_split_region = fr.reg_id
                             and fr.reg_code like i_lic_region
                             /*AND fl.lic_status = 'C'
                             AND TO_NUMBER (TO_CHAR (fl.lic_cancel_date,
                                                     'YYYYMM'
                                                    )
                                           ) <=
                                     TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))*/
                             -- Pure Finance : Ajit : 10-Apr-2013
                             -- Check for if any month between the from date and todate
                             -- there is -ve inventory
                             AND EXISTS (
                                    SELECT 'x'
                                      FROM x_mv_subledger_data
                                                              /*fid_license_sub_ledger*/
                                           flsl
                                     WHERE flsl.lis_lic_number = fl.lic_number
                                       AND flsl.lis_lsl_number =
                                                               xfsl.lsl_number
                                       AND
                                           /*flsl.lis_per_year|| LPAD (flsl.lis_per_month, 2, 0)*/
                                           flsl.lis_yyyymm_num
                                              BETWEEN TO_NUMBER
                                                        (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                                  AND TO_NUMBER
                                                          (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )
                                       AND flsl.lis_con_fc_emu <> 0
									   AND flsl.lis_reval_flag = 'CL')
                        ORDER BY fl.lic_currency,
                                 fl.lic_type,
                                 flee.lee_short_name,
                                 fl.lic_budget_code,
                                 RPAD (afc.com_short_name, 12, ' '),
                                 fcon.con_short_name,
                                 FL.LIC_NUMBER);
		ELSE
			OPEN o_lib_rep FOR

          SELECT channel_company, lic_currency, lic_type, lee_short_name,
                lic_budget_code, com_short_name, con_short_name, lic_number,
                gen_title
                ,LIC_ACCT_DATE
                ,lic_start
                ,LIC_END
                ,lic_amort_code,
                lic_showing_int,
                --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                --lic_showing_lic,
                DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                lic_markup_percent, lic_rate, ter_cur_code,
                --td_exh,
                DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                --SIT.R5 : SVOD Enhancements : End
                ob_markup,
                ROUND ((ob_markup + revel - COST), 2) cb_mup,
                revel,
                reval_mu_loc,
                ROUND (DECODE (revel, 0, 0, (reval_mu_loc / revel)),
                       5
                      ) rev_exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                COST,
                ex_rate,
                round ((ob_markup + revel - COST) * ex_rate, 2) cb_final
           FROM (SELECT DISTINCT x.com_name "CHANNEL_COMPANY",
                                 fl.lic_currency, fl.lic_type,
                                 flee.lee_short_name, fl.lic_budget_code,
                                 RPAD (afc.com_short_name,
                                       12,
                                       ' '
                                      ) com_short_name,
                                 fcon.con_short_name, fl.lic_number,
                                 --SUBSTR (fg.gen_title, 1, 20) gen_title,
                                 TRIM (fg.gen_title) gen_title,
                                 TO_CHAR (fl.lic_acct_date,
                                          'YYYY.MM'
                                         ) lic_acct_date,
                                 TO_CHAR (fl.lic_start,
                                          'DDMonYYYY') lic_start,
                                 TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                                 fl.lic_amort_code,
                                 DECODE (fl.lic_catchup_flag,
                                         'Y', NULL,
                                         fl.lic_showing_int
                                        ) lic_showing_int,
                                 fl.lic_showing_lic,
                                 ROUND
                                    (fl.lic_markup_percent,
                                     4
                                    ) lic_markup_percent,
                                 fl.lic_rate, ft.ter_cur_code,
                                 pkg_fin_mnet_lib_val_rep.td_exh
                                                          (lic_number,
                                                           i_from_date
                                                          ) td_exh,

                                 -- sum of +Ve inventory before the to date
                                ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_ob_mp_rversal
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date),
                                     2
                                    ) ob_markup,

                                 -- sum of -ve inventory during the report period
                                 ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_cancl
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date,
                                         i_to_date
                                        ),
                                     2
                                    ) revel,
                                 ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_rep_revel_cancl_loc
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date,
                                         i_to_date
                                        ),
                                     2
                                    ) reval_mu_loc,

                                 -- Get the Cost before the to date
                               ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_fin_ex
                                        (lic_number,
                                         lsl_number,
                                         i_mup,
                                         i_from_date,
                                         i_to_date
                                        ),
                                     2
                                    ) COST,

                                 -- If license start date before Pure Finance Go-live then
                                 -- use existsing rate of if the license start date is after
                                 -- the pure finance Go-live then use license rate
                                 ROUND
                                    (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                               (lic_currency,
                                                                ter_cur_code,
                                                                'P',
                                                                lic_rate,
                                                                lic_start,
                                                                v_go_live_date
                                                               ),
                                     4
                                    ) ex_rate
                            FROM fid_general fg,
                                 fid_company afc,
                                 --fid_company bfc,  /*not used*/
                                 fid_contract fcon,
                                 fid_licensee flee,
                                 fid_license fl,
                                 fid_region fr,             -- added for split
                                 fid_territory ft,
                                 --Pure Finance: Ajit: 10-Apr-2013 : Sec lee table added : start
                                 x_fin_lic_sec_lee xfsl,

                                 -- Pure Finance :END
                                 (SELECT fc.com_name, fc.com_number,
                                         fc.com_ter_code
                                    FROM fid_company fc
                                   WHERE fc.com_short_name LIKE
                                                              i_chnl_comp_name
                                     AND fc.com_type IN ('CC', 'BC')) x
                           WHERE flee.lee_cha_com_number = x.com_number
                             AND ft.ter_code LIKE x.com_ter_code
                             AND fl.lic_type LIKE i_lic_type
                             AND flee.lee_short_name LIKE i_lee_short_name
                             --AND lic_lee_number = lee_number
                             AND fl.lic_budget_code LIKE i_lic_budget_code
                             AND fcon.con_number = fl.lic_con_number
                             AND afc.com_number = fcon.con_com_number
                             AND fg.gen_refno = fl.lic_gen_refno
                             -- Pure Finance : Ajit : 10-Apr-2013 : Lee joined changed, used
                             -- seconddary licnese referance and split region mapping changed from lee
                             -- region id to lee split region
                             AND xfsl.lsl_lic_number = fl.lic_number
                             AND xfsl.lsl_lee_number = flee.lee_number
                             AND flee.lee_split_region = fr.reg_id
                             and fr.reg_code like i_lic_region
                             /*AND fl.lic_status = 'C'
                             AND TO_NUMBER (TO_CHAR (fl.lic_cancel_date,
                                                     'YYYYMM'
                                                    )
                                           ) <=
                                     TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))*/
                             -- Pure Finance : Ajit : 10-Apr-2013
                             -- Check for if any month between the from date and todate
                             -- there is -ve inventory
                             AND EXISTS (
                                    SELECT 'x'
                                      FROM x_mv_subledger_data
                                                              /*fid_license_sub_ledger*/
                                           flsl
                                     WHERE flsl.lis_lic_number = fl.lic_number
                                       AND flsl.lis_lsl_number =
                                                               xfsl.lsl_number
                                       AND
                                           /*flsl.lis_per_year|| LPAD (flsl.lis_per_month, 2, 0)*/
                                           flsl.lis_yyyymm_num
                                              BETWEEN TO_NUMBER
                                                        (TO_CHAR (i_from_date,
                                                                  'YYYYMM'
                                                                 )
                                                        )
                                                  AND TO_NUMBER
                                                          (TO_CHAR (i_to_date,
                                                                    'YYYYMM'
                                                                   )
                                                          )
                                       AND flsl.lis_con_fc_emu <> 0
									   AND flsl.lis_reval_flag = 'CL')
                        ORDER BY fl.lic_currency,
                                 fl.lic_type,
                                 flee.lee_short_name,
                                 fl.lic_budget_code,
                                 RPAD (afc.com_short_name, 12, ' '),
                                 fcon.con_short_name,
                                 fl.lic_number);
		END IF;
   END prc_prg_lib_re_valu_canc_x;
--PROCEDURE FOR PROGRAM INVENTORY EXPERIES REPORT FIDVAL06A.rdf
   PROCEDURE prc_prg_inv_exp_rep (
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_mup                IN       CHAR,
      i_acct_prvlng_rate   IN       CHAR,
      i_period_date        IN       DATE,
      i_lic_region         IN       VARCHAR2                -- added for split
                                            ,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (3000);
      l_from_date      DATE;
      l_to_date        DATE;
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      v_go_live_date   DATE;
   --Dev2: Pure Finance :End
   BEGIN
      --l_from_date := trunc(i_period_date,'MON') ;
      ---- COMMENTED ON 20-JAN-2011
      ----l_from_date := add_months(trunc(i_period_date,'MON'),-24) ;
      l_from_date :=
         ADD_MONTHS (LAST_DAY (TO_DATE (i_period_date, 'DD-MON-RRRR')), -1)
         + 1;
      l_to_date := LAST_DAY (i_period_date);

      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      OPEN o_lib_rep FOR
         --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
         SELECT   channel_comp, com_number, b, ter_cur_code, lic_currency,
                  lic_type, lee_short_name, lic_budget_code, supplier,
                  con_short_name, lic_number, gen_title, acct_date, lic_start,
                  lic_end, lic_amort_code, lic_showing_int, lic_showing_lic,
                  lic_markup_percent, lic_rate, td_exh, con_fc, con_aa,
                  (con_fc - con_aa) close_markup, ex_rate,
                  ((con_fc - con_aa) * ex_rate) close_markup2
             FROM (
                   --Dev2: Pure Finance :End
                   SELECT x.com_name channel_comp, afc.com_number,
                          bfc.com_number b, ft.ter_cur_code, fl.lic_currency,
                          fl.lic_type, flee.lee_short_name,

                          --Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          xfsl.lsl_lee_number,
                                              --Pure Finance :End
                                              fl.lic_budget_code,
                          SUBSTR (afc.com_short_name, 1, 8) supplier,
                          fcon.con_short_name, fl.lic_number,
                          (SELECT SUBSTR (fg.gen_title, 1, 20)
                             FROM fid_general fg
                            WHERE fg.gen_refno = fl.lic_gen_refno) gen_title,
                          TO_CHAR (FL.LIC_ACCT_DATE, 'RRRR.MM') ACCT_DATE,
                          TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                          TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                          fl.lic_amort_code,
                          DECODE (fl.lic_catchup_flag,
                                  'Y', NULL,
                                  ROUND (fl.lic_showing_int, 4)
                                 ) lic_showing_int,
                          ROUND (fl.lic_showing_lic, 4) lic_showing_lic,
                          ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                          ROUND (fl.lic_rate, 5) lic_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.td_exh_fin_ex
                                                            (fl.lic_number,
                                                             i_period_date,
                                                             fl.lic_start,
                                                             v_go_live_date,
                                                             fl.lic_amort_code
                                                            )
                             ) td_exh,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.con_fc_prg_inv_fin_expiry
                                                              (i_mup,
                                                               fl.lic_number,
                                                               i_period_date,
                                                               xfsl.lsl_number
                                                              )
                             ) con_fc,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.con_aa_prg_inv_fin_ex
                                                              (i_mup,
                                                               fl.lic_number,
                                                               i_period_date,
                                                               xfsl.lsl_number
                                                              )
                             ) con_aa,
                          ROUND
                             (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                          (fl.lic_currency,
                                                           ft.ter_cur_code,
                                                           i_acct_prvlng_rate,
                                                           fl.lic_rate,
                                                           fl.lic_start,
                                                           v_go_live_date
                                                          ),
                              4
                             ) ex_rate
                     FROM                                       --fid_general,
                          fid_company afc,
                          fid_company bfc,
                          fid_contract fcon,
                          fid_licensee flee,
                          --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                          x_fin_lic_sec_lee xfsl,
                          --Dev2: Pure Finance :END
                          fid_license fl,
                          fid_region fr,                    -- added for split
                          fid_territory ft,
                          (SELECT fc.com_name, fc.com_number, fc.com_ter_code
                             FROM fid_company fc
                            WHERE fc.com_short_name LIKE i_chnl_comp_name
                              AND fc.com_type IN ('CC', 'BC')) x
                    WHERE (    ft.ter_code = bfc.com_ter_code
                           AND flee.lee_cha_com_number = bfc.com_number
                           AND fl.lic_type LIKE i_lic_type
                           AND flee.lee_short_name LIKE i_lee_short_name
                           AND
                               --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                               --LIC_LEE_NUMBER = LEE_NUMBER and
                               fl.lic_number = xfsl.lsl_lic_number
                           AND flee.lee_number = xfsl.lsl_lee_number
                           --Dev2: Pure Finance :End
                           AND fl.lic_budget_code LIKE i_lic_budget_code
                           AND fcon.con_number = fl.lic_con_number
                           AND afc.com_number = fcon.con_com_number
                           --AND gen_refno = lic_gen_refno
                           -- AND ( lic_end BETWEEN i_period_date  AND  l_to_date) AND  ---- COMMENTED ON 20-JAN-2011
                           -- split
                           --Dev2: Pure Finance :Start:[Non Costed Fillers]_[ANUJASHINDE]_[2013/3/15]
                           --[Added to exclude(fillers) licenses with status F]
                           AND fl.lic_status NOT IN ('F', 'T')
                           --Dev2: Pure Finance[Non Costed Fillers] :End
                           --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                           --AND LEE_REGION_ID = reg_id
                           AND fr.reg_id(+) = flee.lee_split_region
                           --Dev2: Pure Finance :END
                           AND fr.reg_code LIKE i_lic_region
                           -- AND (LIC_END BETWEEN L_FROM_DATE AND L_TO_DATE)
                           AND fl.lic_end >= l_from_date
                           AND fl.lic_end < = l_to_date
                           /* AND EXISTS (
                           SELECT NULL
                           FROM fid_license_sub_ledger
                           WHERE lis_lic_number = lic_number
                           AND    lis_per_year
                           || LPAD (lis_per_month, 2, 0) <=
                           TO_CHAR (i_period_date, 'YYYYMM'))*/
                           AND EXISTS (
                                  SELECT 0
                                    FROM x_mv_subledger_data mvlsl
                                   WHERE mvlsl.lis_lic_number = fl.lic_number
                                     AND lis_yyyymm_num <=
                                            TO_NUMBER (TO_CHAR (i_period_date,
                                                                'YYYYMM'
                                                               )
                                                      ))
                          )
                      --'201006' ))--TO_CHAR (to_date('jun-2010','mon-yyyy') , 'YYYYMM' ))  )
                      AND (x.com_number = bfc.com_number)
                                                         --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
                  )
            WHERE 1 = 1
         ORDER BY 2 ASC,
                  3 ASC,
                  4 ASC,
                  5 ASC,
                  6 ASC,
                  7 ASC,
                  8 ASC,
                  lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  -- a.com_short_name,
                  con_short_name,
                  gen_title,
                  lic_number;
   --Dev2: Pure Finance :END
   END prc_prg_inv_exp_rep;

--PROCEDURE FOR Amortisation code 'C' Report FIDVAL07A.rdf
   PROCEDURE prc_amo_code_c_rep (
      i_region            IN       fid_region.reg_code%TYPE,
      --Dev2: Pure Finance :Start:[RSA- AFR Month-end Split]_[ANUJASHINDE]_[2013/1/24]
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%TYPE,
      i_period_date       IN       DATE,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
   BEGIN
      OPEN o_lib_rep FOR
         SELECT
                  --Dev2: Pure Finance :Start:[RSA- AFR Month-end Split]_[ANUJASHINDE]_[2013/1/24]
                  fr.reg_code region,
                                     --Dev2: Pure Finance :End
                                     afc.com_name channel_comp,
                  fl.lic_currency, fl.lic_type, flee.lee_short_name,
                  fl.lic_budget_code, bfc.com_short_name supplier,
                  fcon.con_short_name contract, fl.lic_number,
                  fg.gen_title program,
                  TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                  TO_CHAR (fl.lic_start, 'DDMonYYYY') start_date,
                  TO_CHAR (fl.lic_end, 'DDMonYYYY') end_date,
                  ROUND (fl.lic_price, 4),
                     (flsl.lis_per_year)
                  || '.'
                  || LPAD (flsl.lis_per_month, 2, '0') MONTH,

                  --Dev2: Pure Finance :Start:[RSA- AFR Month-end Split]_[ANUJASHINDE]_[2013/1/24]
                  --[Added ROUNDING by (4) for export to excel functionality]
                  ROUND (SUM (flsl.lis_con_actual + flsl.lis_con_adjust),
                         4
                        ) cost_exc_m_u
             --Dev2: Pure Finance :End
         FROM     fid_general fg,
                  fid_company afc,
                  fid_company bfc,
                  fid_contract fcon,
                  fid_licensee flee,
                  --Dev2: Pure Finance :Start:[RSA- AFR Month-end Split]_[ANUJASHINDE]_[2013/1/24]
                  fid_region fr,
                  --Dev2: Pure Finance :End
                  fid_license fl,
                  fid_license_sub_ledger flsl
            WHERE flee.lee_cha_com_number = afc.com_number
              AND fl.lic_lee_number = flee.lee_number
              AND fcon.con_number = fl.lic_con_number
              AND bfc.com_number = fcon.con_com_number
              AND fg.gen_refno = fl.lic_gen_refno
              AND fl.lic_amort_code = 'C'
              AND afc.com_type IN ('CC', 'BC')
              AND afc.com_short_name LIKE i_chnl_comp_name
              --Dev.R3: Start: Placeholder_[Devashish Raverkar]_[27-03-2014]
              AND fl.lic_status <> 'T'
              --Dev.R3: End:
              AND fl.lic_type LIKE i_lic_type
              AND flee.lee_short_name LIKE i_lee_short_name
              AND fl.lic_budget_code LIKE i_lic_budget_code
              AND fcon.con_short_name LIKE i_con_short_name
              AND fl.lic_end > LAST_DAY (i_period_date)
              AND (   fl.lic_price != 0
                   OR 0 !=
                         (SELECT SUM (flsl.lis_con_actual
                                      + flsl.lis_con_adjust
                                     )
                            FROM fid_license_sub_ledger flsl
                           WHERE flsl.lis_lic_number = fl.lic_number)
                  )
              AND fl.lic_number = flsl.lis_lic_number
              AND (flsl.lis_con_actual + flsl.lis_con_adjust) != 0
              --Dev2: Pure Finance :Start:[RSA- AFR Month-end Split]_[ANUJASHINDE]_[2013/1/24]
              AND fr.reg_id(+) = flee.lee_split_region
              AND NVL (fr.reg_code, '#') LIKE
                      DECODE (i_region,
                              '%', NVL (fr.reg_code, '#'),
                              i_region
                             )
         --Dev2: Pure Finance :End
         GROUP BY fr.reg_code,
                  afc.com_name,
                  fl.lic_currency,
                  fl.lic_type,
                  flee.lee_short_name,
                  fl.lic_budget_code,
                  bfc.com_short_name,
                  fcon.con_short_name,
                  fl.lic_number,
                  fg.gen_title,
                  TO_CHAR (fl.lic_acct_date, 'YYYY.MM'),
                  TO_CHAR (fl.lic_start, 'DDMonYYYY'),
                  TO_CHAR (fl.lic_end, 'DDMonYYYY'),
                  ROUND (fl.lic_price, 4),
                     (flsl.lis_per_year)
                  || '.'
                  || LPAD (flsl.lis_per_month, 2, '0')
         ORDER BY 1 ASC, 2 ASC, 3 ASC, 4 ASC, 5 ASC, 6 ASC, 7 ASC, lic_number;
   END prc_amo_code_c_rep;

--PROCEDURE FOR Licence Costed Before A/C Date FIDVAL08A.rdf
   PROCEDURE prc_lic_cost_bef_ac_date (
      --Dev2: Pure Finance: Start:[RSA/AFR Split]_[Manish]_[2013/03/12]
      --[added region for Excel n Report]
      i_region             IN       VARCHAR2
                                            --Dev2: Pure Finance: End
   ,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE     --MNET
                                                                   ,
      i_lic_type           IN       fid_license.lic_type%TYPE            --FLF
                                                             ,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE     --AFR
                                                                    ,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE     --FIL
                                                                    ,
      i_mup                IN       CHAR                                   --A
                                        ,
      i_acct_prvlng_rate   IN       CHAR                                   --%
                                        ,
      i_period_date        IN       DATE                         --01-JAN-2009
                                        ,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      OPEN o_lib_rep FOR
         SELECT
                  --Dev2: Pure Finance: Start:[RSA/AFR Split]_[Manish]_[2013/03/12]
                  --[added region for Excel n Report]
                  fr.reg_code region
                                    --Dev2: Pure Finance: End
                  , afc.com_number
                                  --,         b.com_number   b_com_number
                  , ft.ter_cur_code, lic_currency, lic_type, lee_short_name,
                  lic_budget_code, SUBSTR (com_short_name, 1, 8) supplier,
                  con_short_name, fl.lic_number, SUBSTR (gen_title, 1, 20),
                  TO_CHAR (lic_acct_date, 'YYYY.MM'),
                  TO_CHAR (lic_start, 'DDMonYYYY'),
                  TO_CHAR (lic_end, 'DDMonYYYY'), fl.lic_amort_code,
                  DECODE (fl.lic_catchup_flag,
                          'Y', NULL,
                          fl.lic_showing_int
                         ) lic_showing_int,
                  fl.lic_showing_lic, fl.lic_markup_percent, fl.lic_rate,
                  x.com_name chnl_company,
                  pkg_fin_mnet_lib_val_rep.td_exh (fl.lic_number,
                                                   i_period_date
                                                  ) td_exh,
                  pkg_fin_mnet_lib_val_rep.con_fc_prg_inv
                                                       (i_mup,
                                                        fl.lic_number,
                                                        i_period_date
                                                       ) con_fc,
                  pkg_fin_mnet_lib_val_rep.con_aa_prg_inv
                                                       (i_mup,
                                                        fl.lic_number,
                                                        i_period_date
                                                       ) con_aa,
                    pkg_fin_mnet_lib_val_rep.con_fc_prg_inv
                                                  (i_mup,
                                                   fl.lic_number,
                                                   i_period_date
                                                  )
                  - pkg_fin_mnet_lib_val_rep.con_aa_prg_inv (i_mup,
                                                             fl.lic_number,
                                                             i_period_date
                                                            ) clse_markup,

                  --Dev2: Pure Finance: Start:[RSA/AFR Split]_[Manish]_[2013/03/12]
                  --[Calling new function created]
                  pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                 (fl.lic_currency,
                                                  ft.ter_cur_code,
                                                  i_acct_prvlng_rate,
                                                  fl.lic_rate,
                                                  fl.lic_start,
                                                  v_go_live_date
                                                 ) ex_rate
                                                          --Dev2: Pure Finance: End
                  ,
                  ROUND
                     (  (  pkg_fin_mnet_lib_val_rep.con_fc_prg_inv
                                                                (i_mup,
                                                                 lic_number,
                                                                 i_period_date
                                                                )
                         - pkg_fin_mnet_lib_val_rep.con_aa_prg_inv
                                                               (i_mup,
                                                                fl.lic_number,
                                                                i_period_date
                                                               )
                        )
                      *
                        --Dev2: Pure Finance: Start:[RSA/AFR Split]_[Manish]_[2013/03/12]
                        --[Calling new function created]
                        pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                          (fl.lic_currency,
                                                           ft.ter_cur_code,
                                                           i_acct_prvlng_rate,
                                                           fl.lic_rate,
                                                           fl.lic_start,
                                                           v_go_live_date
                                                          )
                     ) close_markup2
             --Dev2: Pure Finance: End
         FROM     fid_general fg,
                  fid_company afc,
                  --,fid_company b  ,
                  fid_contract fcon,
                  fid_licensee flee,
                  fid_license fl,
                  fid_territory ft,
                  --Dev2: Pure Finance: Start:[RSA/AFR Split]_[Manish]_[2013/01/24]
                  --[added license table]
                  fid_region fr,

                  --Dev2: Pure Finance: End
                  (SELECT fc.com_name, fc.com_number, fc.com_ter_code
                     FROM fid_company fc
                    WHERE fc.com_short_name LIKE '' || i_chnl_comp_name || ''
                      AND fc.com_type IN ('CC', 'BC')) x
            WHERE ft.ter_code = x.com_ter_code
              AND flee.lee_cha_com_number = x.com_number
              AND fl.lic_type LIKE '' || i_lic_type || ''
              AND flee.lee_short_name LIKE '' || i_lee_short_name || ''
              AND fl.lic_lee_number = flee.lee_number
              AND fl.lic_budget_code LIKE '' || i_lic_budget_code || ''
              AND fcon.con_number = fl.lic_con_number
              AND afc.com_number = fcon.con_com_number
              AND fg.gen_refno = fl.lic_gen_refno
              AND
                  /*EXISTS (
                  SELECT NULL
                  FROM fid_license_sub_ledger flsle
                  WHERE flsle.lis_lic_number = fl.lic_number
                  AND flsle.lis_per_year || LPAD (flsle.lis_per_month, 2, 0) <
                  TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM'))) */
                  --Aditi
                  EXISTS (
                     SELECT NULL
                       FROM x_mv_subledger_data
                      WHERE lis_lic_number = fl.lic_number
                        AND lis_yyyymm_num <
                               TO_NUMBER (TO_CHAR (fl.lic_acct_date, 'YYYYMM')))
              --Dev2: Pure Finance: Start:[RSA/AFR Split]_[Manish]_[2013/03/12]
              --[added conditions for getting Region in Excel n Report]
              AND flee.lee_number = fl.lic_lee_number
              AND fr.reg_id(+) = flee.lee_split_region
              AND NVL (fr.reg_code, '#') LIKE
                      DECODE (i_region,
                              '%', NVL (fr.reg_code, '#'),
                              i_region
                             )
              --Dev2: Pure Finance: End
              --Dev2: Non Costed Filler : Start:[NCF_Fin1]_[Manish]_[2013/03/15]
              --[Added to exclude licenses with status F]
              AND fl.lic_status NOT IN ('F', 'T')
         --Dev2:Non Costed Filler: End
         GROUP BY fr.reg_code,
                  afc.com_number,
                  fl.lic_type,
                  flee.lee_short_name,
                  fl.lic_budget_code,
                  afc.com_short_name,
                  fcon.con_short_name,
                  fl.lic_number
                               --,         b.com_number   b_com_number
         ,
                  ft.ter_cur_code,
                  fl.lic_currency,
                  fg.gen_title,
                  fl.lic_acct_date,
                  fl.lic_start,
                  fl.lic_end,
                  fl.lic_amort_code,
                  DECODE (fl.lic_catchup_flag, 'Y', NULL, fl.lic_showing_int),
                  fl.lic_showing_lic,
                  fl.lic_markup_percent,
                  fl.lic_rate,
                  x.com_name
         ORDER BY afc.com_number,
                  fl.lic_currency,
                  fl.lic_type,
                  flee.lee_short_name,
                  fl.lic_budget_code,
                  afc.com_short_name,
                  fcon.con_short_name,
                  fl.lic_number;
   END prc_lic_cost_bef_ac_date;

--PROCEDURE FOR Cost of Sales Report by Type, Licensee, Budget Code FIDCOS01A.rdf
   PROCEDURE prc_cost_sale_rpt_ty_li_bu (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                  --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      OPEN o_lib_rep FOR
         --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
         SELECT   com_name, lic_currency, lic_type, lic_price, lee_short_name,
                  lic_budget_code, supplier, con_short_name,
                  con_con_effective_date, lic_number, gen_title, acct_date,
                  lic_start, lic_end, lic_amort_code, lic_showing_int,
                  --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/22]
                  --exh,lic_showing_lic,
                  DECODE(lic_amort_code,'A',NULL,exh) exh,
                  DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                  --SIT.R5 : SVOD Enhancements : End
                  chnl_comp, ter_cur_code, showsrem,
                  curr3_cost,
                  ROUND (curr3_cost * (lic_markup_percent / 100),
                         0
                        ) curr4_markup,

                  --ex_rate,
                  CASE
                     WHEN (lic_start >= v_go_live_date)
                        THEN ROUND (DECODE (curr3_cost,
                                            0, lic_rate,
                                            (  NVL (curr3_cost_loc, 0)
                                             / curr3_cost
                                            )
                                           ),
                                    5
                                   )
                     ELSE ex_rate
                  END ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  CASE
                     WHEN (lic_start >= v_go_live_date)
                        THEN ROUND (curr3_cost_loc, 2)
                     ELSE ROUND (curr3_cost * ex_rate, 2)
                  END currency2_cost,

                  -- CURR3_COST * EX_RATE CURRENCY2_COST,
                  /*curr3_cost_loc currency2_cost,*/
                  CASE
                     WHEN (lic_start >= v_go_live_date)
                        THEN ROUND (  curr3_cost_loc
                                    * (lic_markup_percent / 100),
                                    2
                                   )
                     ELSE ROUND (  (curr3_cost * ex_rate)
                                 * (lic_markup_percent / 100),
                                 2
                                )
                  END exchange_markup1,

                  --   ROUND(  CURR3_COST * (lic_markup_percent / 100), 0 )* ex_rate exchange_markup1,
                  /*ROUND (curr3_cost_loc * (lic_markup_percent / 100),
                  0
                  ) exchange_markup1,*/
                  cos_pv, cos_ed,
                                 --COS_PV * ex_rate LOC_PV,
                                 cos_pv_loc loc_pv,
                  curr3_cost + cos_pv total_con_cost,

                  --(CURR3_COST *  ex_rate)  + (COS_PV * ex_rate)  + COS_ED TOTAL_LOC_COST
                  ((curr3_cost_loc) + (cos_pv_loc) + cos_ed) total_loc_cost,
                  amo_ytod
             FROM (
                   --Dev2: Pure Finance : END
                   SELECT afc.com_name, fl.lic_currency, fl.lic_type,
                          fl.lic_rate, xfsl.lsl_lee_price "LIC_PRICE",
                          flee.lee_short_name, fl.lic_budget_code,
                          TRIM (SUBSTR (afc.com_short_name, 1, 8)) supplier,
                          fcon.con_short_name, fcon.con_con_effective_date,
                          fl.lic_number, fg.gen_title,
                          TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                          fl.lic_start, fl.lic_end
                                                  -- , lic_rate
                          , fl.lic_amort_code, fl.lic_showing_lic,
                          fl.lic_showing_int
                                            --,    lic_markup_percent
                          , x.com_name chnl_comp, x.ter_cur_code,
                          DECODE
                             (fl.lic_catchup_flag,
                              'Y', NULL,
                              (   NVL (LTRIM (TO_CHAR (  fl.lic_showing_int
                                                       - fl.lic_showing_paid,
                                                       '9999'
                                                      )
                                             ),
                                       0
                                      )
                               || '/'
                               || NVL (LTRIM (to_char(fl.lic_showing_int, '9999')), 0)
                              )
                             ) showsrem,
                          pkg_fin_mnet_lib_val_rep.sumcol1_ex
                                            (lic_number,
                                             lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date)
                                            ) curr3_cost,
                          (CASE
                              WHEN (fl.lic_start >= v_go_live_date)
                                 THEN pkg_fin_mnet_lib_val_rep.sumcol1_ex_loc
                                                        (lic_number,
                                                         lsl_number,
                                                         TO_DATE (i_from_date),
                                                         TO_DATE (i_to_date)
                                                        )
                              ELSE   pkg_fin_mnet_lib_val_rep.sumcol1_ex
                                                        (lic_number,
                                                         lsl_number,
                                                         TO_DATE (i_from_date),
                                                         TO_DATE (i_to_date)
                                                        )
                                   * pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_new
                                                          (lic_currency,
                                                           x.ter_cur_code,
                                                           i_acct_prvlng_rate,
                                                           lic_rate
                                                          )
                           END
                          ) curr3_cost_loc,

                          --PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(LIC_CURRENCY,X.TER_CUR_CODE,I_ACCT_PRVLNG_RATE,LIC_RATE,LIC_START,V_GO_LIVE_DATE) EX_RATE,
                          pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_new
                                                 (lic_currency,
                                                  x.ter_cur_code,
                                                  i_acct_prvlng_rate,
                                                  lic_rate
                                                 ) ex_rate,
                          DECODE
                             (fl.lic_catchup_flag,
                              'Y', NULL,
                              pkg_fin_mnet_lib_val_rep.fun_cost_sale_sch_paid_1
                                                        (TO_DATE (i_from_date),
                                                         TO_DATE (i_to_date),
                                                         lic_number,
                                                         lic_start,
                                                         v_go_live_date
                                                        )
                             ) exh,

                          --i_from_date, i_to_date,
                          --b.com_number                b_com_number,
                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [ PV and ED ]
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (lic_number,
                                                 lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'PV'
                                                ) cos_pv,
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (lic_number,
                                                 lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'ED'
                                                ) cos_ed,
                          fl.lic_markup_percent,
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac_loc
                                            (lic_number,
                                             lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date),
                                             'PV'
                                            ) cos_pv_loc,
                  --swapnil
                  PKG_FIN_MNET_LIB_VAL_REP.x_func_get_costed_runs_end_of(fl.lic_start,v_go_live_date,fl.lic_number,fl.lic_catchup_flag)
                  || '/'
                  || NVL (LTRIM (fl.lic_showing_int, '999'), 0)amo_ytod
                  --swapnil

                     --Dev2: Pure Finance : END
                   FROM   fid_company afc,
                          fid_general fg
                                        --,    fid_company b
                   ,
                          fid_contract fcon,
                          fid_licensee flee,
                          fid_license fl,
                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
                          fid_region fr,
                          x_fin_lic_sec_lee xfsl,

                          --Dev2: Pure Finance : END
                          (SELECT ft.ter_cur_code, afc.com_short_name,
                                  afc.com_ter_code, afc.com_name,
                                  afc.com_number
                             FROM fid_company afc, fid_territory ft
                            WHERE afc.com_short_name LIKE i_chnl_comp_name
                              AND afc.com_type IN ('CC', 'BC')
                              AND ft.ter_code = afc.com_ter_code) x
                    WHERE flee.lee_cha_com_number = x.com_number
                      AND fl.lic_type LIKE i_lic_type
                      AND flee.lee_short_name LIKE i_lee_short_name
                      AND fl.lic_budget_code LIKE i_lic_budget_code
                      --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
                      AND fr.reg_code LIKE i_region
                      AND flee.lee_split_region = fr.reg_id(+)
                      AND fl.lic_status NOT IN ('F', 'T')
                      --AND lic_lee_number     = lee_number
                      AND xfsl.lsl_lee_number = flee.lee_number
                      AND xfsl.lsl_lic_number = fl.lic_number
                      --AND con_short_name = '13-061020-MN'
                      --Dev2: Pure Finance: END
                      AND fcon.con_number = fl.lic_con_number
                      AND afc.com_number = fcon.con_com_number
                      --Dev2: Pure Finance: Start:[Adding Supplier Code check]_[ADITYA GUPTA]_[2013/04/30]
                      AND afc.com_short_name LIKE i_supplier_code
                      --Dev2: Pure Finance: End
                      AND fg.gen_refno = fl.lic_gen_refno
                      AND
                          /* CASE
                          WHEN i_report_sub_type = 1
                          THEN (SELECT SUM (flv.lis_con_aa_emu)
                          FROM fid_lis_vw flv
                          WHERE flv.lis_lic_number = fl.lic_number
                          AND flv.lis_lsl_number = xfsl.lsl_number
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) >=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_from_date),
                          'YYYYMM'
                          )
                          )
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) <=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_to_date),
                          'YYYYMM'
                          )
                          ))
                          WHEN i_report_sub_type = 2
                          THEN (SELECT SUM (flv.lis_ed_loc_ac_emu)
                          FROM fid_lis_vw flv
                          WHERE flv.lis_lic_number = fl.lic_number
                          AND flv.lis_lsl_number = xfsl.lsl_number
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) >=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_from_date),
                          'YYYYMM'
                          )
                          )
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) <=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_to_date),
                          'YYYYMM'
                          )
                          ))
                          WHEN i_report_sub_type = 3
                          THEN (SELECT SUM (flv.lis_pv_con_ac_emu)
                          FROM fid_lis_vw flv
                          WHERE flv.lis_lic_number = fl.lic_number
                          AND flv.lis_lsl_number = xfsl.lsl_number
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) >=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_from_date),
                          'YYYYMM'
                          )
                          )
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) <=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_to_date),
                          'YYYYMM'
                          )
                          ))
                          WHEN i_report_sub_type = 4
                          THEN (SELECT SUM (  flv.lis_con_aa_emu
                          + flv.lis_ed_loc_ac_emu
                          + flv.lis_pv_con_ac_emu
                          )
                          FROM fid_lis_vw flv
                          WHERE flv.lis_lic_number = fl.lic_number
                          AND flv.lis_lsl_number = xfsl.lsl_number
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) >=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_from_date),
                          'YYYYMM'
                          )
                          )
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) <=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_to_date),
                          'YYYYMM'
                          )
                          ))
                          END <> 0 */
                          CASE
                             WHEN i_report_sub_type = 1
                                THEN (SELECT SUM (flv.lis_con_aa_emu_23)
                                        FROM x_mv_subledger_data flv
                                       WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                         AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                         AND flv.lis_yyyymm_num >=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                                   )
                                         AND flv.lis_yyyymm_num <=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                                   ))
                             WHEN i_report_sub_type = 2
                                THEN (SELECT SUM (flv.lis_ed_loc_ac_emu)
                                        FROM x_mv_subledger_data flv
                                       WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                         AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                         AND flv.lis_yyyymm_num >=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                                   )
                                         AND flv.lis_yyyymm_num <=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                                   ))
                             WHEN i_report_sub_type = 3
                                THEN (SELECT SUM (flv.lis_pv_con_ac_emu)
                                        FROM x_mv_subledger_data flv
                                       WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                         AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                         AND flv.lis_yyyymm_num >=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                                   )
                                         AND flv.lis_yyyymm_num <=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                                   ))
                             WHEN i_report_sub_type = 4
                                THEN (SELECT SUM (  flv.lis_con_aa_emu_23
                                                  + flv.lis_ed_loc_ac_emu
                                                  + flv.lis_pv_con_ac_emu
                                                 )
                                        FROM x_mv_subledger_data flv
                                       WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                         AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                         AND flv.lis_yyyymm_num >=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                                   )
                                         AND flv.lis_yyyymm_num <=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                                   ))
                          END <> 0
                                  -- and rownum < 51
                  )
         ORDER BY lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  gen_title,
                  lic_number;
   --WHERE 1=1
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
   END prc_cost_sale_rpt_ty_li_bu;

   PROCEDURE prc_cost_sale_rpt_ty_li_bu_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                  --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (20000);
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      /*l_qry :=
      'SELECT   REG_CODE, a.com_name , lic_currency, lic_type, lee_short_name,
      lic_budget_code, SUBSTR (a.com_short_name, 1, 8) supplier,
      con_short_name, lic_number, gen_title gentitle,
      TO_CHAR (lic_acct_date, ''YYYY.MM'') acct_date, lic_start,
      lic_end
      -- , lic_rate
      , lic_amort_code, lic_showing_lic
      --,    lic_markup_percent
      , x.com_name chnl_comp , x.ter_cur_code,
      DECODE
      (lic_catchup_flag,
      ''Y'', NULL,
      (   NVL (LTRIM (TO_CHAR (  lic_showing_int
      - lic_showing_paid,
      ''9999''
      )
      ),
      0
      )
      || ''/''
      || NVL (LTRIM (lic_showing_int, ''9999''), 0)
      )
      ) showsrem,
      PKG_FIN_MNET_LIB_VAL_REP.sumcol1_ex(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || ''')) Cost,
      ROUND(  PKG_FIN_MNET_LIB_VAL_REP.sumcol1_ex(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''))
      * (lic_markup_percent / 100),
      0
      ) MARKUP,
      case when (LIC_START >= '''
      || v_go_live_date
      || ''')
      then round(decode
      (
      PKG_FIN_MNET_LIB_VAL_REP.sumcol1_ex(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''))
      ,0
      ,lic_rate
      ,(nvl(PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX_LOC(LIC_NUMBER, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || ''')),0)
      / PKG_FIN_MNET_LIB_VAL_REP.sumcol1_ex(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || ''')))
      ),4)
      else PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_new(LIC_CURRENCY,X.TER_CUR_CODE,'''
      || i_acct_prvlng_rate
      || ''',LIC_RATE)
      end ex_rate,
      ----  PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_new(LIC_CURRENCY,X.TER_CUR_CODE,'''
      || i_acct_prvlng_rate
      || ''',LIC_RATE) ex_rate,
      ----       PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(lic_currency,x.ter_cur_code,'''
      || i_acct_prvlng_rate
      || ''',lic_rate,lic_start,'''
      || v_go_live_date
      || ''') ex_rate,
      PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX_LOC(LIC_NUMBER, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || ''')) Exchange_Cost,
      ----     PKG_FIN_MNET_LIB_VAL_REP.sumcol1_ex(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''))
      ----      * PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(lic_currency,x.ter_cur_code,'''
      || i_acct_prvlng_rate
      || ''',lic_rate,lic_start,'''
      || v_go_live_date
      || ''') currency2_cost,
      ROUND(  PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX_LOC(LIC_NUMBER, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || ''')) * (lic_markup_percent / 100), 0 ) Exchange_Markup,
      ----    ROUND
      ----         (  PKG_FIN_MNET_LIB_VAL_REP.sumcol1_ex(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''))
      ----          * (lic_markup_percent / 100),
      ----          0
      ----         )
      ----    * PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(lic_currency,x.ter_cur_code,'''
      || i_acct_prvlng_rate
      || ''',lic_rate,lic_start,'''
      || v_go_live_date
      || ''') exchange_markup1,
      DECODE
      (lic_catchup_flag,
      ''Y'', NULL,
      PKG_FIN_MNET_LIB_VAL_REP.fun_cost_sale_sch_paid_1(TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),lic_number,lic_start,'''
      || v_go_live_date
      || ''')
      ) exh,
      TO_DATE ('''
      || i_from_date
      || ''') FROM_DATE,TO_DATE ('''
      || i_to_date
      || ''') TO_DATE';
      IF i_report_sub_type = 2
      THEN
      l_qry :=
      l_qry
      || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''ED'') COS_ED';
      ELSIF i_report_sub_type = 3
      THEN
      l_qry :=
      l_qry
      || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''PV'') COS_PV,
      PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC_LOC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''PV'') LOC_PV ';
      ----  ,ROUND(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''||i_from_date||'''),TO_DATE ('''||I_TO_DATE||'''),''PV'')
      ----                        *
      ----  PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(lic_currency,x.ter_cur_code,'''||i_acct_prvlng_rate||''',LIC_RATE,lic_start,'''||v_go_live_date||'''),2) LOC_PV';
      ELSIF i_report_sub_type = 4
      THEN
      l_qry :=
      l_qry
      || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''PV'') COS_PV,
      PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''ED'') COS_ED,
      PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC_LOC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''PV'') LOC_PV,
      ----ROUND(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''PV'')
      ----                  *
      ----PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(lic_currency,x.ter_cur_code,'''
      || i_acct_prvlng_rate
      || ''',LIC_RATE,lic_start,'''
      || v_go_live_date
      || '''),2) LOC_PV,
      PKG_FIN_MNET_LIB_VAL_REP.sumcol1_ex(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''))
      +
      PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''PV'') TOTAL_CON_COST,
      PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''ED'')
      +
      PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX_LOC(LIC_NUMBER, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''))
      +
      PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC_LOC(lic_number, LSL_NUMBER,TO_DATE ('''
      || i_from_date
      || '''),TO_DATE ('''
      || i_to_date
      || '''),''PV'') TOTAL_LOC_COST ';
      ----ROUND((PKG_FIN_MNET_LIB_VAL_REP.sumcol1_ex(lic_number, LSL_NUMBER,TO_DATE ('''||i_from_date||'''),TO_DATE ('''||I_TO_DATE||'''))
      ----                   *
      ----PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(lic_currency,x.ter_cur_code,'''||i_acct_prvlng_rate||''',LIC_RATE,lic_start,'''||v_go_live_date||'''))
      ----                    +
      ----(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''||i_from_date||'''),TO_DATE ('''||I_TO_DATE||'''),''PV'')
      ----                    *
      ----PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(lic_currency,x.ter_cur_code,'''||i_acct_prvlng_rate||''',LIC_RATE,lic_start,'''||v_go_live_date||'''))
      ----                  +
      ----PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''||i_from_date||'''),TO_DATE ('''||I_TO_DATE||'''),''ED''),2) TOTAL_LOC_COST';
      END IF;
      l_qry :=
      l_qry
      || ' FROM     fid_company a,
      fid_general
      --,    fid_company b
      ,
      fid_contract,
      fid_licensee,
      fid_license,
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
      FID_REGION,
      x_fin_lic_sec_lee,
      --Dev2: Pure Finance : END
      (SELECT ter_cur_code, a.com_short_name, a.com_ter_code,
      a.com_name, a.com_number
      FROM fid_company a, fid_territory
      WHERE a.com_short_name LIKE '''
      || i_chnl_comp_name
      || '''
      AND a.com_type IN (''CC'', ''BC'')
      AND ter_code = com_ter_code) x
      WHERE lee_cha_com_number = x.com_number
      AND lic_type LIKE '''
      || i_lic_type
      || '''
      AND lee_short_name LIKE '''
      || i_lee_short_name
      || '''
      AND lic_budget_code LIKE '''
      || i_lic_budget_code
      || '''
      --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
      AND REG_CODE LIKE '''
      || i_region
      || '''
      AND a.com_short_name LIKE '''
      || i_supplier_code
      || '''
      AND lee_split_region = reg_id
      AND LIC_STATUS != ''F''
      --AND    lic_lee_number     = lee_number
      AND lsl_lee_number = lee_number
      AND lsl_lic_number = lic_number
      --Dev2: Pure Finance: END
      AND con_number = lic_con_number
      AND a.com_number = con_com_number
      AND gen_refno = lic_gen_refno
      ----  AND rownum < 100
      ';
      DBMS_OUTPUT.put_line (l_qry);
      OPEN o_lib_rep FOR l_qry;
      /*DELETE FROM exl_cost_of_sales;
      COMMIT;
      INSERT INTO exl_cost_of_sales
      (com_name, lic_currency, lic_type, lee_short_name,
      lic_budget_code, supplier, con_short_name, lic_number,
      gen_title, acct_date, lic_start, lic_end, lic_amort_code,
      lic_showings_lic, ter_cur_code, shows_rem, COST, markup,
      rate, exchange_cost, exchange_markup, exh, from_date,
      TO_DATE)
      SELECT   x.com_name, lic_currency, lic_type, lee_short_name,
      lic_budget_code, SUBSTR (a.com_short_name, 1, 8) supplier,
      con_short_name, lic_number,
      SUBSTR (gen_title, 1, 22) gentitle,
      TO_CHAR (lic_acct_date, 'YYYY.MM') acct_date, lic_start,
      lic_end, lic_amort_code, lic_showing_lic, x.ter_cur_code,
      DECODE
      (lic_catchup_flag,
      'Y', NULL,
      (   NVL (LTRIM (TO_CHAR (  lic_showing_int
      - lic_showing_paid,
      '999'
      )
      ),
      0
      )
      || '/'
      || NVL (LTRIM (lic_showing_int, '999'), 0)
      )
      ) showsrem,
      pkg_fin_mnet_lib_val_rep.sumcol1
      (lic_number,
      TO_DATE (i_from_date),
      TO_DATE (i_to_date)
      ) curr3_cost,
      ROUND
      (  pkg_fin_mnet_lib_val_rep.sumcol1
      (lic_number,
      TO_DATE (i_from_date),
      TO_DATE (i_to_date)
      )
      * (lic_markup_percent / 100),
      0
      ) curr4_markup,
      pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate
      (lic_currency,
      x.ter_cur_code,
      i_acct_prvlng_rate,
      lic_rate
      ) ex_rate,
      pkg_fin_mnet_lib_val_rep.sumcol1
      (lic_number,
      TO_DATE (i_from_date),
      TO_DATE (i_to_date)
      )
      * pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate
      (lic_currency,
      x.ter_cur_code,
      i_acct_prvlng_rate,
      lic_rate
      ) currency2_cost,
      ROUND
      (  pkg_fin_mnet_lib_val_rep.sumcol1
      (lic_number,
      TO_DATE (i_from_date),
      TO_DATE (i_to_date)
      )
      * (lic_markup_percent / 100),
      0
      )
      * pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate
      (lic_currency,
      x.ter_cur_code,
      i_acct_prvlng_rate,
      lic_rate
      ) exchange_markup1,
      DECODE
      (lic_catchup_flag,
      'Y', NULL,
      pkg_fin_mnet_lib_val_rep.fun_cost_sale_sch_paid_1
      (TO_DATE (i_from_date),
      TO_DATE (i_to_date),
      lic_number
      )
      ) exh,
      i_from_date, i_to_date
      FROM fid_company a,
      fid_general,
      fid_contract,
      fid_licensee,
      fid_license,
      (SELECT ter_cur_code, a.com_short_name, a.com_ter_code,
      a.com_name, a.com_number
      FROM fid_company a, fid_territory
      WHERE a.com_short_name LIKE i_chnl_comp_name
      AND a.com_type IN ('CC', 'BC')
      AND ter_code = com_ter_code) x
      WHERE lee_cha_com_number = x.com_number
      AND lic_type LIKE i_lic_type
      AND lee_short_name LIKE i_lee_short_name
      AND lic_budget_code LIKE i_lic_budget_code
      AND lic_lee_number = lee_number
      AND con_number = lic_con_number
      AND a.com_number = con_com_number
      AND gen_refno = lic_gen_refno
      AND 0 <>
      (SELECT SUM (lis_con_aa_emu)
      FROM fid_lis_vw
      WHERE lis_lic_number = lic_number
      AND lis_per_year || LPAD (lis_per_month, 2, 0) >=
      TO_NUMBER (TO_CHAR (TO_DATE (i_from_date),
      'YYYYMM'
      )
      )
      AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
      TO_NUMBER (TO_CHAR (TO_DATE (i_to_date),
      'YYYYMM'
      )
      ))
      ORDER BY lic_currency,
      lic_type,
      lee_short_name,
      lic_budget_code,
      x.com_short_name,
      con_short_name,
      gen_title;
      COMMIT;
      OPEN o_lib_rep FOR
      SELECT com_name "CHANNEL_COMPANY", lic_currency, from_date, TO_DATE,
      ter_cur_code, lic_type, lee_short_name, lic_budget_code,
      supplier, con_short_name, lic_number, gen_title gentitle,
      acct_date, lic_start, lic_end, lic_amort_code, exh,
      lic_showings_lic, shows_rem showsrem, COST "COST",
      markup "MARKUP", exchange_cost "EXCHANGE_COST",
      exchange_markup "EXCHANGE_MARKUP", rate ex_rate
      FROM exl_cost_of_sales;*/
      DELETE FROM exl_cost_of_sales;

      COMMIT;

      INSERT INTO exl_cost_of_sales
                  (com_name, lic_currency, lic_type, lee_short_name,
                   lic_budget_code, supplier, con_short_name, lic_number,
                   gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                   lic_showings_lic, ter_cur_code, shows_rem, COST, markup,
                   rate, exchange_cost, exchange_markup, exh, from_date,
                   TO_DATE)
         SELECT com_name, lic_currency, lic_type, lee_short_name,
                lic_budget_code, supplier, con_short_name, lic_number,
                gen_title, acct_date, lic_start, lic_end, lic_amort_code,
                lic_showings_lic, ter_cur_code, shows_rem, COST, markup, rate,
                exchange_cost, exchange_markup, exh, i_from_date, i_to_date
           FROM (
                 --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
                 SELECT com_name, lic_currency, lic_type, lic_price,
                        lee_short_name, lic_budget_code, supplier,
                        con_short_name, con_con_effective_date, lic_number,
                        gen_title, acct_date, lic_start, lic_end,
                        lic_amort_code, lic_showing_int lic_showings_lic, exh,
                        lic_showing_lic, chnl_comp, ter_cur_code,
                        showsrem shows_rem, curr3_cost COST,
                        ROUND (curr3_cost * (lic_markup_percent / 100),
                               0
                              ) markup,

                        --ex_rate,
                        CASE
                           WHEN (lic_start >= v_go_live_date)
                              THEN ROUND
                                        (DECODE (curr3_cost,
                                                 0, lic_rate,
                                                 (  NVL (curr3_cost_loc, 0)
                                                  / curr3_cost
                                                 )
                                                ),
                                         5
                                        )
                           ELSE ex_rate
                        END rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                        CASE
                           WHEN (lic_start >= v_go_live_date)
                              THEN ROUND (curr3_cost_loc, 2)
                           ELSE ROUND (curr3_cost * ex_rate, 2)
                        END exchange_cost,

                        -- CURR3_COST * EX_RATE CURRENCY2_COST,
                        /*curr3_cost_loc exchange_cost,*/
                        CASE
                           WHEN (lic_start >= v_go_live_date
                                )
                              THEN ROUND (  curr3_cost_loc
                                          * (lic_markup_percent / 100),
                                          2
                                         )
                           ELSE ROUND (  (curr3_cost * ex_rate)
                                       * (lic_markup_percent / 100),
                                       2
                                      )
                        END exchange_markup,

                        --   ROUND(  CURR3_COST * (lic_markup_percent / 100), 0 )* ex_rate exchange_markup1,
                        /*   ROUND (curr3_cost_loc * (lic_markup_percent / 100),
                        0
                        ) exchange_markup,*/
                        cos_pv, cos_ed,
                                       --COS_PV * ex_rate LOC_PV,
                                       cos_pv_loc loc_pv,
                        curr3_cost + cos_pv total_con_cost,

                          --(CURR3_COST *  ex_rate)  + (COS_PV * ex_rate)  + COS_ED TOTAL_LOC_COST
                          (curr3_cost_loc)
                        + (cos_pv_loc)
                        + cos_ed total_loc_cost
                   FROM (
                         --Dev2: Pure Finance : END
                         SELECT afc.com_name, fl.lic_currency, fl.lic_type,
                                fl.lic_rate, xfsl.lsl_lee_price "LIC_PRICE",
                                flee.lee_short_name, fl.lic_budget_code,
                                SUBSTR (afc.com_short_name, 1, 8) supplier,
                                fcon.con_short_name,
                                fcon.con_con_effective_date, fl.lic_number,
                                fg.gen_title,
                                TO_CHAR (fl.lic_acct_date,
                                         'YYYY.MM'
                                        ) acct_date,
                                fl.lic_start, fl.lic_end
                                                        -- , lic_rate
                                , fl.lic_amort_code, fl.lic_showing_lic,
                                fl.lic_showing_int
                                                  --,    lic_markup_percent
                                , x.com_name chnl_comp, x.ter_cur_code,
                                DECODE
                                   (FL.LIC_CATCHUP_FLAG,
                                    'Y', '', '' ||
                                    to_char(NVL
                                           (LTRIM
                                               (TO_CHAR (  fl.lic_showing_int
                                                         - fl.lic_showing_paid,
                                                         '9999'
                                                        )
                                               ),
                                            0
                                           )
                                     || '/'
                                     || NVL (LTRIM (TO_CHAR(FL.LIC_SHOWING_INT,
                                                    '9999')),
                                             0
                                            )
                                    )
                                   ) showsrem,
                                pkg_fin_mnet_lib_val_rep.sumcol1_ex
                                            (fl.lic_number,
                                             xfsl.lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date)
                                            ) curr3_cost,
                                pkg_fin_mnet_lib_val_rep.sumcol1_ex_loc
                                        (fl.lic_number,
                                         xfsl.lsl_number,
                                         TO_DATE (i_from_date),
                                         TO_DATE (i_to_date)
                                        ) curr3_cost_loc,

                                --PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(LIC_CURRENCY,X.TER_CUR_CODE,I_ACCT_PRVLNG_RATE,LIC_RATE,LIC_START,V_GO_LIVE_DATE) EX_RATE,
                                pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_new
                                                 (fl.lic_currency,
                                                  x.ter_cur_code,
                                                  i_acct_prvlng_rate,
                                                  fl.lic_rate
                                                 ) ex_rate,
                                DECODE
                                   (fl.lic_catchup_flag,
                                    'Y', NULL,
                                    pkg_fin_mnet_lib_val_rep.fun_cost_sale_sch_paid_1
                                                        (TO_DATE (i_from_date),
                                                         TO_DATE (i_to_date),
                                                         fl.lic_number,
                                                         fl.lic_start,
                                                         v_go_live_date
                                                        )
                                   ) exh,

                                --i_from_date, i_to_date,
                                --b.com_number                b_com_number,
                                --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [ PV and ED ]
                                pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'PV'
                                                ) cos_pv,
                                pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'ED'
                                                ) cos_ed,
                                lic_markup_percent,
                                pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac_loc
                                            (fl.lic_number,
                                             xfsl.lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date),
                                             'PV'
                                            ) cos_pv_loc
                           --Dev2: Pure Finance : END
                         FROM   fid_company afc,
                                fid_general fg,
                                --,fid_company b
                                fid_contract fcon,
                                fid_licensee flee,
                                fid_license fl,
                                --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
                                fid_region fr,
                                x_fin_lic_sec_lee xfsl,

                                --Dev2: Pure Finance : END
                                (SELECT ft.ter_cur_code, afc.com_short_name,
                                        afc.com_ter_code, afc.com_name,
                                        afc.com_number
                                   FROM fid_company afc, fid_territory ft
                                  WHERE afc.com_short_name LIKE
                                                              i_chnl_comp_name
                                    AND afc.com_type IN ('CC', 'BC')
                                    AND ft.ter_code = afc.com_ter_code) x
                          WHERE flee.lee_cha_com_number = x.com_number
                            AND fl.lic_type LIKE i_lic_type
                            AND flee.lee_short_name LIKE i_lee_short_name
                            AND fl.lic_budget_code LIKE i_lic_budget_code
                            --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
                            AND fr.reg_code LIKE i_region
                            AND flee.lee_split_region = fr.reg_id(+)
                            AND fl.lic_status NOT IN ('F', 'T')
                            --AND lic_lee_number     = lee_number
                            AND xfsl.lsl_lee_number = flee.lee_number
                            AND xfsl.lsl_lic_number = fl.lic_number
                            --AND con_short_name = '13-061020-MN'
                            --Dev2: Pure Finance: END
                            AND fcon.con_number = fl.lic_con_number
                            AND afc.com_number = fcon.con_com_number
                            --Dev2: Pure Finance: Start:[Adding Supplier Code check]_[ADITYA GUPTA]_[2013/04/30]
                            AND afc.com_short_name LIKE i_supplier_code
                            --Dev2: Pure Finance: End
                            AND fg.gen_refno = fl.lic_gen_refno
                            AND
                                /*CASE
                                WHEN i_report_sub_type = 1
                                THEN (SELECT SUM (flv.lis_con_aa_emu)
                                FROM fid_lis_vw flv
                                WHERE flv.lis_lic_number = fl.lic_number
                                AND flv.lis_lsl_number = xfsl.lsl_number
                                AND    flv.lis_per_year
                                || LPAD (flv.lis_per_month,
                                2,
                                0
                                ) >=
                                TO_NUMBER
                                (TO_CHAR
                                (TO_DATE
                                (i_from_date),
                                'YYYYMM'
                                )
                                )
                                AND    flv.lis_per_year
                                || LPAD (flv.lis_per_month,
                                2,
                                0
                                ) <=
                                TO_NUMBER
                                (TO_CHAR
                                (TO_DATE
                                (i_to_date),
                                'YYYYMM'
                                )
                                ))
                                WHEN i_report_sub_type = 2
                                THEN (SELECT SUM (flv.lis_ed_loc_ac_emu)
                                FROM fid_lis_vw flv
                                WHERE flv.lis_lic_number = fl.lic_number
                                AND flv.lis_lsl_number = xfsl.lsl_number
                                AND    flv.lis_per_year
                                || LPAD (flv.lis_per_month,
                                2,
                                0
                                ) >=
                                TO_NUMBER
                                (TO_CHAR
                                (TO_DATE
                                (i_from_date),
                                'YYYYMM'
                                )
                                )
                                AND    flv.lis_per_year
                                || LPAD (flv.lis_per_month,
                                2,
                                0
                                ) <=
                                TO_NUMBER
                                (TO_CHAR
                                (TO_DATE
                                (i_to_date),
                                'YYYYMM'
                                )
                                ))
                                WHEN i_report_sub_type = 3
                                THEN (SELECT SUM (flv.lis_pv_con_ac_emu)
                                FROM fid_lis_vw flv
                                WHERE flv.lis_lic_number = fl.lic_number
                                AND flv.lis_lsl_number = xfsl.lsl_number
                                AND    flv.lis_per_year
                                || LPAD (flv.lis_per_month,
                                2,
                                0
                                ) >=
                                TO_NUMBER
                                (TO_CHAR
                                (TO_DATE
                                (i_from_date),
                                'YYYYMM'
                                )
                                )
                                AND    flv.lis_per_year
                                || LPAD (flv.lis_per_month,
                                2,
                                0
                                ) <=
                                TO_NUMBER
                                (TO_CHAR
                                (TO_DATE
                                (i_to_date),
                                'YYYYMM'
                                )
                                ))
                                WHEN i_report_sub_type = 4
                                THEN (SELECT SUM (  flv.lis_con_aa_emu
                                + flv.lis_ed_loc_ac_emu
                                + flv.lis_pv_con_ac_emu
                                )
                                FROM fid_lis_vw flv
                                WHERE flv.lis_lic_number = fl.lic_number
                                AND flv.lis_lsl_number = xfsl.lsl_number
                                AND    flv.lis_per_year
                                || LPAD (flv.lis_per_month,
                                2,
                                0
                                ) >=
                                TO_NUMBER
                                (TO_CHAR
                                (TO_DATE
                                (i_from_date),
                                'YYYYMM'
                                )
                                )
                                AND    flv.lis_per_year
                                || LPAD (flv.lis_per_month,
                                2,
                                0
                                ) <=
                                TO_NUMBER
                                (TO_CHAR
                                (TO_DATE
                                (i_to_date),
                                'YYYYMM'
                                )
                                ))
                                END <> 0 */
                                CASE
                                   WHEN i_report_sub_type = 1
                                      THEN (SELECT SUM (flv.lis_con_aa_emu_23)
                                              FROM x_mv_subledger_data flv
                                             WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                               AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                               AND flv.lis_yyyymm_num >=
                                                      TO_NUMBER
                                                         (TO_CHAR
                                                             (TO_DATE
                                                                  (i_from_date),
                                                              'YYYYMM'
                                                             )
                                                         )
                                               AND flv.lis_yyyymm_num <=
                                                      TO_NUMBER
                                                         (TO_CHAR
                                                             (TO_DATE
                                                                    (i_to_date),
                                                              'YYYYMM'
                                                             )
                                                         ))
                                   WHEN i_report_sub_type = 2
                                      THEN (SELECT SUM (flv.lis_ed_loc_ac_emu)
                                              FROM x_mv_subledger_data flv
                                             WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                               AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                               AND flv.lis_yyyymm_num >=
                                                      TO_NUMBER
                                                         (TO_CHAR
                                                             (TO_DATE
                                                                  (i_from_date),
                                                              'YYYYMM'
                                                             )
                                                         )
                                               AND flv.lis_yyyymm_num <=
                                                      TO_NUMBER
                                                         (TO_CHAR
                                                             (TO_DATE
                                                                    (i_to_date),
                                                              'YYYYMM'
                                                             )
                                                         ))
                                   WHEN i_report_sub_type = 3
                                      THEN (SELECT SUM (flv.lis_pv_con_ac_emu)
                                              FROM x_mv_subledger_data flv
                                             WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                               AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                               AND flv.lis_yyyymm_num >=
                                                      TO_NUMBER
                                                         (TO_CHAR
                                                             (TO_DATE
                                                                  (i_from_date),
                                                              'YYYYMM'
                                                             )
                                                         )
                                               AND flv.lis_yyyymm_num <=
                                                      TO_NUMBER
                                                         (TO_CHAR
                                                             (TO_DATE
                                                                    (i_to_date),
                                                              'YYYYMM'
                                                             )
                                                         ))
                                   WHEN i_report_sub_type = 4
                                      THEN (SELECT SUM
                                                      (  flv.lis_con_aa_emu_23
                                                       + flv.lis_ed_loc_ac_emu
                                                       + flv.lis_pv_con_ac_emu
                                                      )
                                              FROM x_mv_subledger_data flv
                                             WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                               AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                               AND flv.lis_yyyymm_num >=
                                                      TO_NUMBER
                                                         (TO_CHAR
                                                             (TO_DATE
                                                                  (i_from_date),
                                                              'YYYYMM'
                                                             )
                                                         )
                                               AND flv.lis_yyyymm_num <=
                                                      TO_NUMBER
                                                         (TO_CHAR
                                                             (TO_DATE
                                                                    (i_to_date),
                                                              'YYYYMM'
                                                             )
                                                         ))
                                END <> 0));

      COMMIT;

      OPEN o_lib_rep FOR
         --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
         SELECT   com_name, lic_currency, lic_type, lic_price, lee_short_name,
                  lic_budget_code, supplier, con_short_name,
                  con_con_effective_date, lic_number, gen_title, acct_date,
                  lic_start, lic_end, lic_amort_code, lic_showing_int,
                  --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/22]
                  --exh,lic_showing_lic,
                  DECODE(lic_amort_code,'A',NULL,exh) exh,
                  DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                  --SIT.R5 : SVOD Enhancements : End
                  chnl_comp, ter_cur_code, showsrem,
                  curr3_cost,
                  ROUND (curr3_cost * (lic_markup_percent / 100),
                         0
                        ) curr4_markup,

                  --ex_rate,
                  CASE
                     WHEN (lic_start >= v_go_live_date)
                        THEN ROUND (DECODE (curr3_cost,
                                            0, lic_rate,
                                            (  NVL (curr3_cost_loc, 0)
                                             / curr3_cost
                                            )
                                           ),
                                    5
                                   )
                     ELSE ex_rate
                  END ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  CASE
                     WHEN (lic_start >= v_go_live_date)
                        THEN ROUND (curr3_cost_loc, 2)
                     ELSE ROUND (curr3_cost * ex_rate, 2)
                  END currency2_cost,

                  -- CURR3_COST * EX_RATE CURRENCY2_COST,
                  /*curr3_cost_loc currency2_cost,*/
                  CASE
                     WHEN (lic_start >= v_go_live_date)
                        THEN ROUND (  curr3_cost_loc
                                    * (lic_markup_percent / 100),
                                    2
                                   )
                     ELSE ROUND (  (curr3_cost * ex_rate)
                                 * (lic_markup_percent / 100),
                                 2
                                )
                  END exchange_markup1,

                  --   ROUND(  CURR3_COST * (lic_markup_percent / 100), 0 )* ex_rate exchange_markup1,
                  /*ROUND (curr3_cost_loc * (lic_markup_percent / 100),
                  0
                  ) exchange_markup1,*/
                  cos_pv, cos_ed,
                                 --COS_PV * ex_rate LOC_PV,
                                 cos_pv_loc loc_pv,
                  curr3_cost + cos_pv total_con_cost,

                  --(CURR3_COST *  ex_rate)  + (COS_PV * ex_rate)  + COS_ED TOTAL_LOC_COST
                  (curr3_cost_loc) + (cos_pv_loc) + cos_ed total_loc_cost
             FROM (
                   --Dev2: Pure Finance : END
                   SELECT afc.com_name, fl.lic_currency, fl.lic_type,
                          fl.lic_rate, xfsl.lsl_lee_price "LIC_PRICE",
                          flee.lee_short_name, fl.lic_budget_code,
                          SUBSTR (afc.com_short_name, 1, 8) supplier,
                          fcon.con_short_name,
                          TO_CHAR(fcon.con_con_effective_date,'DD-MON-RRRR') con_con_effective_date,
                          fl.lic_number, fg.gen_title,
                          TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                          TO_CHAR(fl.lic_start,'DD-MON-RRRR') lic_start,
                          TO_CHAR(fl.lic_end,'DD-MON-RRRR') lic_end
                                                  -- , lic_rate
                          , fl.lic_amort_code, fl.lic_showing_lic,
                          fl.lic_showing_int
                                            --,    lic_markup_percent
                          , x.com_name chnl_comp, x.ter_cur_code,
                          DECODE
                             (FL.LIC_CATCHUP_FLAG,
                              'Y', '',  '' ||
                              to_char(NVL (LTRIM (TO_CHAR (  fl.lic_showing_int
                                                       - fl.lic_showing_paid,
                                                       '9999'
                                                      )
                                             ),
                                       0
                                      )
                               || '/'
                               || NVL (LTRIM (to_char(fl.lic_showing_int, '9999')), 0)
                              )
                             ) showsrem,
                          pkg_fin_mnet_lib_val_rep.sumcol1_ex
                                            (fl.lic_number,
                                             xfsl.lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date)
                                            ) curr3_cost,
                          pkg_fin_mnet_lib_val_rep.sumcol1_ex_loc
                                        (fl.lic_number,
                                         xfsl.lsl_number,
                                         TO_DATE (i_from_date),
                                         TO_DATE (i_to_date)
                                        ) curr3_cost_loc,

                          --PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(LIC_CURRENCY,X.TER_CUR_CODE,I_ACCT_PRVLNG_RATE,LIC_RATE,LIC_START,V_GO_LIVE_DATE) EX_RATE,
                          pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_new
                                                 (fl.lic_currency,
                                                  x.ter_cur_code,
                                                  i_acct_prvlng_rate,
                                                  fl.lic_rate
                                                 ) ex_rate,
                          DECODE
                             (fl.lic_catchup_flag,
                              'Y', NULL,
                              pkg_fin_mnet_lib_val_rep.fun_cost_sale_sch_paid_1
                                                        (TO_DATE (i_from_date),
                                                         TO_DATE (i_to_date),
                                                         fl.lic_number,
                                                         fl.lic_start,
                                                         v_go_live_date
                                                        )
                             ) exh,

                          --i_from_date, i_to_date,
                          --b.com_number                b_com_number,
                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [ PV and ED ]
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'PV'
                                                ) cos_pv,
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'ED'
                                                ) cos_ed,
                          fl.lic_markup_percent,
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac_loc
                                            (fl.lic_number,
                                             xfsl.lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date),
                                             'PV'
                                            ) cos_pv_loc
                     --Dev2: Pure Finance : END
                   FROM   fid_company afc,
                          fid_general fg
                                        --,    fid_company b
                   ,
                          fid_contract fcon,
                          fid_licensee flee,
                          fid_license fl,
                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
                          fid_region fr,
                          x_fin_lic_sec_lee xfsl,

                          --Dev2: Pure Finance : END
                          (SELECT ft.ter_cur_code, afc.com_short_name,
                                  afc.com_ter_code, afc.com_name,
                                  afc.com_number
                             FROM fid_company afc, fid_territory ft
                            WHERE afc.com_short_name LIKE i_chnl_comp_name
                              AND afc.com_type IN ('CC', 'BC')
                              AND ft.ter_code = afc.com_ter_code) x
                    WHERE flee.lee_cha_com_number = x.com_number
                      AND fl.lic_type LIKE i_lic_type
                      AND flee.lee_short_name LIKE i_lee_short_name
                      AND fl.lic_budget_code LIKE i_lic_budget_code
                      --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
                      AND fr.reg_code LIKE i_region
                      AND flee.lee_split_region = fr.reg_id(+)
                      AND fl.lic_status NOT IN ('F', 'T')
                      --AND lic_lee_number     = lee_number
                      AND xfsl.lsl_lee_number = flee.lee_number
                      AND xfsl.lsl_lic_number = fl.lic_number
                      --AND con_short_name = '13-061020-MN'
                      --Dev2: Pure Finance: END
                      AND fcon.con_number = fl.lic_con_number
                      AND afc.com_number = fcon.con_com_number
                      --Dev2: Pure Finance: Start:[Adding Supplier Code check]_[ADITYA GUPTA]_[2013/04/30]
                      AND afc.com_short_name LIKE i_supplier_code
                      --Dev2: Pure Finance: End
                      AND fg.gen_refno = fl.lic_gen_refno
                      AND
                          /*CASE
                          WHEN i_report_sub_type = 1
                          THEN (SELECT SUM (flv.lis_con_aa_emu)
                          FROM fid_lis_vw flv
                          WHERE flv.lis_lic_number = fl.lic_number
                          AND flv.lis_lsl_number = xfsl.lsl_number
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) >=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_from_date),
                          'YYYYMM'
                          )
                          )
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) <=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_to_date),
                          'YYYYMM'
                          )
                          ))
                          WHEN i_report_sub_type = 2
                          THEN (SELECT SUM (flv.lis_ed_loc_ac_emu)
                          FROM fid_lis_vw flv
                          WHERE flv.lis_lic_number = fl.lic_number
                          AND flv.lis_lsl_number = xfsl.lsl_number
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) >=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_from_date),
                          'YYYYMM'
                          )
                          )
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) <=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_to_date),
                          'YYYYMM'
                          )
                          ))
                          WHEN i_report_sub_type = 3
                          THEN (SELECT SUM (flv.lis_pv_con_ac_emu)
                          FROM fid_lis_vw flv
                          WHERE flv.lis_lic_number = fl.lic_number
                          AND flv.lis_lsl_number = xfsl.lsl_number
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) >=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_from_date),
                          'YYYYMM'
                          )
                          )
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) <=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_to_date),
                          'YYYYMM'
                          )
                          ))
                          WHEN i_report_sub_type = 4
                          THEN (SELECT SUM (  flv.lis_con_aa_emu
                          + flv.lis_ed_loc_ac_emu
                          + flv.lis_pv_con_ac_emu
                          )
                          FROM fid_lis_vw flv
                          WHERE flv.lis_lic_number = fl.lic_number
                          AND flv.lis_lsl_number = xfsl.lsl_number
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) >=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_from_date),
                          'YYYYMM'
                          )
                          )
                          AND    flv.lis_per_year
                          || LPAD (flv.lis_per_month, 2, 0) <=
                          TO_NUMBER
                          (TO_CHAR
                          (TO_DATE (i_to_date),
                          'YYYYMM'
                          )
                          ))
                          END <> 0 */
                          CASE
                             WHEN i_report_sub_type = 1
                                THEN (SELECT SUM (flv.lis_con_aa_emu_23)
                                        FROM x_mv_subledger_data flv
                                       WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                         AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                         AND flv.lis_yyyymm_num >=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                                   )
                                         AND flv.lis_yyyymm_num <=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                                   ))
                             WHEN i_report_sub_type = 2
                                THEN (SELECT SUM (flv.lis_ed_loc_ac_emu)
                                        FROM x_mv_subledger_data flv
                                       WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                         AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                         AND flv.lis_yyyymm_num >=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                                   )
                                         AND flv.lis_yyyymm_num <=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                                   ))
                             WHEN i_report_sub_type = 3
                                THEN (SELECT SUM (flv.lis_pv_con_ac_emu)
                                        FROM x_mv_subledger_data flv
                                       WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                         AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                         AND flv.lis_yyyymm_num >=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                                   )
                                         AND flv.lis_yyyymm_num <=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                                   ))
                             WHEN i_report_sub_type = 4
                                THEN (SELECT SUM (  flv.lis_con_aa_emu_23
                                                  + flv.lis_ed_loc_ac_emu
                                                  + flv.lis_pv_con_ac_emu
                                                 )
                                        FROM x_mv_subledger_data flv
                                       WHERE flv.lis_lic_number =
                                                                 fl.lic_number
                                         AND flv.lis_lsl_number =
                                                               xfsl.lsl_number
                                         AND flv.lis_yyyymm_num >=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                        (TO_DATE (i_from_date),
                                                         'YYYYMM'
                                                        )
                                                   )
                                         AND flv.lis_yyyymm_num <=
                                                TO_NUMBER
                                                   (TO_CHAR
                                                          (TO_DATE (i_to_date),
                                                           'YYYYMM'
                                                          )
                                                   ))
                          END <> 0
                                  -- and rownum < 51
                  )
         ORDER BY lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  gen_title,
                  lic_number;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
   END prc_cost_sale_rpt_ty_li_bu_exl;

--PROCEDURE FOR Cost of Sales Report by Contractor FIDCOS01B.rdf
--PROCEDURE FOR Cost of Sales Report by Contractor FIDCOS01B.rdf
   PROCEDURE prc_cost_sale_rpt_con (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                  --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      EXECUTE IMMEDIATE 'TRUNCATE TABLE X_FIN_CON_FORCAST_SUM';

      INSERT INTO x_fin_con_forcast_sum
         SELECT lis_lic_number
           FROM (SELECT   lis_lic_number, SUM (lis_con_aa_emu_23)
                     FROM x_mv_subledger_data
                    WHERE lis_yyyymm_num >=
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
                      AND lis_yyyymm_num <=
                                     TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
                 GROUP BY lis_lic_number
                   HAVING SUM (lis_con_aa_emu_23) != 0);

      OPEN o_lib_rep FOR
         --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
         SELECT   lic_currency || com_short_name, com_number, lic_currency,
                  com_short_name, contractor, lic_type, lee_short_name,
                  lic_budget_code, supplier, con_short_name, lic_number,
                  gen_title, acct_date, lic_start, lic_end, lic_rate,
                  LIC_AMORT_CODE, LIC_SHOWING_LIC, LIC_MARKUP_PERCENT,
                  showsrem, curr3_cost, ex_rate,
                  ROUND (curr3_cost * (lic_markup_percent / 100),
                         0
                        ) curr4_markup,
                  curr3_cost * ex_rate currency2_cost,
                  (ROUND (curr3_cost * (lic_markup_percent / 100), 0)
                   * ex_rate
                  ) exchange_markup,
                  exh, ter_cur_code, chnl_comp, cos_pv, cos_ed,
                  ROUND (cos_pv * ex_rate, 2) loc_pv,
                  curr3_cost + cos_pv total_con_cost,
                  ROUND ((curr3_cost * ex_rate) + (cos_pv * ex_rate) + cos_ed,
                         2
                        ) total_loc_cost
             FROM (
                   --Dev2: Pure Finance : END
                   SELECT xfsl.lsl_number,
                          fl.lic_currency || bfc.com_short_name,
                          afc.com_number, fl.lic_currency, bfc.com_short_name,
                          bfc.com_name contractor, fl.lic_type,
                          flee.lee_short_name, fl.lic_budget_code,
                          TRIM (SUBSTR (afc.com_short_name, 1, 8)) supplier,
                          fcon.con_short_name, fl.lic_number,
                          TRIM (SUBSTR (fg.gen_title, 1, 22)) gen_title,
                          TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                          fl.lic_start, fl.lic_end, fl.lic_rate,
                          fl.lic_amort_code, fl.lic_showing_lic,
                          fl.lic_markup_percent,
                          DECODE
                             (fl.lic_catchup_flag,
                              'Y', NULL,
                              (   LTRIM (TO_CHAR (  fl.lic_showing_int
                                                  - fl.lic_showing_paid,
                                                  '999'
                                                 )
                                        )
                               || '/'
                               || LTRIM (to_char(fl.lic_showing_int, '999'))
                              )
                             ) showsrem,
                          pkg_fin_mnet_lib_val_rep.sumcol1_ex
                                            (lic_number,
                                             lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date)
                                            ) curr3_cost,
                          pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                 (fl.lic_currency,
                                                  x.ter_cur_code,
                                                  i_acct_prvlng_rate,
                                                  fl.lic_rate,
                                                  fl.lic_start,
                                                  v_go_live_date
                                                 ) ex_rate,
                          DECODE
                             (fl.lic_catchup_flag,
                              'Y', NULL,
                              pkg_fin_mnet_lib_val_rep.fun_cost_sale_sch_paid_1
                                                        (TO_DATE (i_from_date),
                                                         TO_DATE (i_to_date),
                                                         fl.lic_number,
                                                         fl.lic_start,
                                                         v_go_live_date
                                                        )
                             ) exh,
                          x.ter_cur_code, x.com_name chnl_comp
                                                              --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [ PV and ED ]
                          ,
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (lic_number,
                                                 lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'PV'
                                                ) cos_pv,
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (lic_number,
                                                 lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'ED'
                                                ) cos_ed
                     --Dev2: Pure Finance : END
                   FROM   fid_company afc,
                          fid_company bfc,
                          fid_general fg,
                          fid_contract fcon,
                          fid_licensee flee,
                          fid_license fl,
                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
                          fid_region fr,
                          x_fin_lic_sec_lee xfsl,

                          --Dev2: Pure Finance : END
                          (SELECT ft.ter_cur_code, afc.com_ter_code,
                                  afc.com_name, afc.com_number
                             FROM fid_company afc, fid_territory ft
                            WHERE afc.com_short_name LIKE i_chnl_comp_name
                              AND afc.com_type IN ('CC', 'BC')
                              AND ft.ter_code = afc.com_ter_code) x
                    WHERE flee.lee_cha_com_number = x.com_number
                      AND fl.lic_type LIKE i_lic_type
                      AND flee.lee_short_name LIKE i_lee_short_name
                      AND fl.lic_budget_code LIKE i_lic_budget_code
                      --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
                      AND fr.reg_code LIKE i_region
                      AND flee.lee_split_region = fr.reg_id
                      AND fl.lic_status NOT IN ('F', 'T')
                      --AND  lic_lee_number     = lee_number
                      AND xfsl.lsl_lee_number = flee.lee_number
                      AND xfsl.lsl_lic_number = fl.lic_number
                      --Dev2: Pure Finance: END
                      AND fcon.con_number = fl.lic_con_number
                      AND afc.com_number = fcon.con_com_number
                      AND bfc.com_number = fcon.con_agy_com_number
                      AND fg.gen_refno = fl.lic_gen_refno
                      AND EXISTS (SELECT 1
                                    FROM x_fin_con_forcast_sum xfc
                                   WHERE xfc.lis_lic_number = fl.lic_number)
                                                                            /* AND 0 <>
                                                                            (SELECT SUM (lis_con_aa_emu)
                                                                            FROM fid_lis_vw
                                                                            WHERE lis_lic_number = lic_number
                                                                            AND lis_per_year
                                                                            || LPAD (lis_per_month, 2, 0) >=
                                                                            TO_NUMBER
                                                                            (TO_CHAR (TO_DATE (i_from_date),
                                                                            'YYYYMM'
                                                                            )
                                                                            )
                                                                            AND lis_per_year
                                                                            || LPAD (lis_per_month, 2, 0) <=
                                                                            TO_NUMBER
                                                                            (TO_CHAR (TO_DATE (i_to_date),
                                                                            'YYYYMM'
                                                                            )
                                                                            ))*/
                  )
         /*  a,
         (
         SELECT
         SUM (lis_ed_loc_ac_emu) AS cos_ed,
         SUM (lis_pv_con_ac_emu) AS cos_pv,
         SUM (lis_con_aa_emu_23) as curr3_cost,
         lis_lic_number,
         lis_lsl_number
         FROM x_mv_subledger_data
         WHERE lis_YYYYMM_NUM >= TO_NUMBER(TO_CHAR (TO_DATE (i_from_date),'YYYYMM'))
         AND lis_YYYYMM_NUM   <= TO_NUMBER(TO_CHAR (TO_DATE (i_to_date),'YYYYMM'))
         GROUP BY lis_lic_number, lis_lsl_number
         ) b
         WHERE A.lic_number=b.lis_lic_number(+)
         and A.lsl_number=b.lis_lsl_number(+) */
         ORDER BY lic_currency,
                  com_short_name,
                  lee_short_name,
                  lic_type,
                  supplier,
                  con_short_name,
                  lic_budget_code,
                  gen_title,
                  lic_number;
   END prc_cost_sale_rpt_con;

--Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
   PROCEDURE prc_cost_sale_rpt_con_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (20000);
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      EXECUTE IMMEDIATE 'TRUNCATE TABLE X_FIN_CON_FORCAST_SUM';

      INSERT INTO x_fin_con_forcast_sum
         SELECT lis_lic_number
           FROM (SELECT   lis_lic_number, SUM (lis_con_aa_emu_23)
                     FROM x_mv_subledger_data
                    WHERE lis_yyyymm_num >=
                                   TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
                      AND lis_yyyymm_num <=
                                     TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
                 GROUP BY lis_lic_number
                   HAVING SUM (lis_con_aa_emu_23) != 0);

      l_qry :=
                      'SELECT   REG_CODE, lic_currency || ce.com_short_name, a.com_number,
                        lic_currency, ce.com_short_name, ce.com_name contractor,
                        lic_type, lee_short_name, lic_budget_code,
                        SUBSTR (a.com_short_name, 1, 8) supplier, con_short_name,
                        lic_number, SUBSTR (gen_title, 1, 22),
                        TO_CHAR (lic_acct_date, ''YYYY.MM'') acct_date,
                        TO_CHAR(lic_start,''DD-MON-YYYY'') lic_start,
                        TO_CHAR(lic_end,''DD-MON-YYYY'') lic_end, lic_rate, lic_amort_code, lic_showing_lic,
                        lic_markup_percent,
                        DECODE (lic_catchup_flag,
                        ''Y'', '''', '''' ||
                        to_char(NVL(LTRIM (TO_CHAR (  lic_showing_int
                        - lic_showing_paid,
                        ''999''
                        )
                        ),0)
                        || ''/''
                        || LTRIM (to_char(lic_showing_int, ''999''))
                        )
                        ) SHOWSREMS,
                        PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(lic_number, lsl_number,TO_DATE ('''
                                 || i_from_date
                                 || '''),TO_DATE ('''
                                 || i_to_date
                                 || ''')) CURR3_COST,
                        PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(lic_currency,x.ter_cur_code,'''
                                 || i_acct_prvlng_rate
                                 || ''',lic_rate,lic_start,'''
                                 || v_go_live_date
                                 || ''') ex_rate,
                        ROUND
                        (  PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(lic_number, lsl_number,TO_DATE ('''
                                 || i_from_date
                                 || '''),TO_DATE ('''
                                 || i_to_date
                                 || '''))
                        * (lic_markup_percent / 100),
                        0
                        ) curr4_markup,
                        PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(lic_number, lsl_number,TO_DATE ('''
                                 || i_from_date
                                 || '''),TO_DATE ('''
                                 || i_to_date
                                 || '''))
                        *
                        PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(lic_currency,x.ter_cur_code,'''
                                 || i_acct_prvlng_rate
                                 || ''',lic_rate,lic_start,'''
                                 || v_go_live_date
                                 || ''') currency2_cost,
                        (ROUND
                        (  PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(lic_number, lsl_number,TO_DATE ('''
                                 || i_from_date
                                 || '''),TO_DATE ('''
                                 || i_to_date
                                 || '''))
                        * (lic_markup_percent / 100),
                        0
                        )
                        )
                        *
                        PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(lic_currency,x.ter_cur_code,'''
                                 || i_acct_prvlng_rate
                                 || ''',lic_rate,lic_start,'''
                                 || v_go_live_date
                                 || ''') exchange_markup,
                        DECODE
                        (lic_catchup_flag,
                        ''Y'', NULL,
                        PKG_FIN_MNET_LIB_VAL_REP.fun_cost_sale_sch_paid_1(TO_DATE ('''
                                 || i_from_date
                                 || '''),TO_DATE ('''
                                 || i_to_date
                                 || '''),lic_number,lic_start,'''
                                 || v_go_live_date
                                 || ''')
                        ) exh,
                        X.TER_CUR_CODE, X.COM_NAME CHNL_COMP';

                              IF i_report_sub_type = 2
                              THEN
                                 l_qry :=
                                       l_qry
                                    || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''),''ED'') COS_ED';
                              ELSIF i_report_sub_type = 3
                              THEN
                                 l_qry :=
                                       l_qry
                                    || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''),''PV'') COS_PV,

                        ROUND(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''),''PV'')
                        *
                        PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(lic_currency,x.ter_cur_code,'''
                                    || i_acct_prvlng_rate
                                    || ''',LIC_RATE,lic_start,'''
                                    || v_go_live_date
                                    || '''),2) LOC_PV';
                              ELSIF i_report_sub_type = 4
                              THEN
                                 l_qry :=
                                       l_qry
                                    || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''),''PV'') COS_PV,
                        PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''),''ED'') COS_ED,
                        ROUND(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''),''PV'')
                        *
                        PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(lic_currency,x.ter_cur_code,'''
                                    || i_acct_prvlng_rate
                                    || ''',LIC_RATE,lic_start,'''
                                    || v_go_live_date
                                    || '''),2) LOC_PV,
                        PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(lic_number, lsl_number,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''))
                        +
                        PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''),''PV'') TOTAL_CON_COST,
                        ROUND((PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(lic_number, lsl_number,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''))
                        *
                        PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(lic_currency,x.ter_cur_code,'''
                                    || i_acct_prvlng_rate
                                    || ''',LIC_RATE,lic_start,'''
                                    || v_go_live_date
                                    || '''))
                        +
                        (PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''),''PV'')
                        *
                        PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(lic_currency,x.ter_cur_code,'''
                                    || i_acct_prvlng_rate
                                    || ''',LIC_RATE,lic_start,'''
                                    || v_go_live_date
                                    || '''))
                        +
                        PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(lic_number, LSL_NUMBER,TO_DATE ('''
                                    || i_from_date
                                    || '''),TO_DATE ('''
                                    || i_to_date
                                    || '''),''ED''),2) TOTAL_LOC_COST';
                              END IF;

                              l_qry :=
                                    l_qry
                                 || ' FROM fid_company a,
                        fid_company ce,
                        fid_general,
                        fid_contract,
                        fid_licensee,
                        FID_LICENSE,
                        FID_REGION,
                        x_fin_lic_sec_lee,
                        (SELECT ter_cur_code, a.com_ter_code, a.com_name,
                        a.com_number
                        FROM fid_company a, fid_territory
                        WHERE a.com_short_name LIKE '''
                                 || i_chnl_comp_name
                                 || '''
                        AND a.com_type IN (''CC'', ''BC'')
                        and TER_CODE = COM_TER_CODE) X
                        WHERE lee_cha_com_number = x.com_number
                        AND lic_type LIKE '''
                                 || i_lic_type
                                 || '''
                        AND lee_short_name LIKE '''
                                 || i_lee_short_name
                                 || '''
                        AND LIC_BUDGET_CODE LIKE '''
                                 || i_lic_budget_code
                                 || '''
                        AND REG_CODE LIKE '''
                                 || i_region
                                 || '''
                        AND a.com_short_name LIKE '''
                                 || i_supplier_code
                                 || '''
                        AND lee_split_region = reg_id
                        AND LIC_STATUS NOT IN (''F'',''T'')
                        --AND    lic_lee_number     = lee_number
                        AND lsl_lee_number = lee_number
                        AND lsl_lic_number = lic_number
                        AND con_number = lic_con_number
                        AND a.com_number = con_com_number
                        AND CE.COM_NUMBER = CON_AGY_COM_NUMBER
                        AND gen_refno = lic_gen_refno
                        AND EXISTS (
                        SELECT 1
                        FROM X_FIN_CON_FORCAST_SUM xfc
                        WHERE xfc.lis_lic_number = lic_number
                        )
                        ORDER BY lic_currency,
                        ce.com_short_name,
                        lee_short_name,
                        lic_type,
                        a.com_short_name,
                        con_short_name,
                        lic_budget_code,
                        GEN_TITLE,
                        lic_number';
      DBMS_OUTPUT.put_line (l_qry);

      OPEN o_lib_rep FOR l_qry;
   END prc_cost_sale_rpt_con_exl;

--Dev2: Pure Finance : END
--PROCEDURE FOR Cost of Sales Report Summary by Period FIDCOS01C.rdf
   PROCEDURE prc_cost_sale_rpt_sum_by_per (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                  --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      OPEN o_lib_rep FOR
         --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
         SELECT com_number, lic_currency, lic_type, lic_rate, lee_short_name,
                lic_budget_code, chnl_comp, ter_cur_code,

                --lis_per_year || '.' || LPAD (lis_per_month, 2, 0),
                (   SUBSTR (lis_yyyymm_num, 1, 4)
                 || '.'
                 || SUBSTR (lis_yyyymm_num, 5, 2)
                ) AS "SUBSTR_LIS_YYYY_MM_NUM",
                COST, markup, e_cost, e_markup, ex_rate,
                DECODE (i_acct_prvlng_rate,
                        'A', e_cost,
                        COST * ex_rate
                       ) exchange_cost,
                DECODE (i_acct_prvlng_rate,
                        'A', e_markup,
                        markup * ex_rate
                       ) exchange_markup,
                cos_pv, cos_ed, ROUND (cos_pv * ex_rate, 2) loc_pv,
                curr3_cost + cos_pv total_con_cost,
                ROUND ((curr3_cost * ex_rate) + (cos_pv * ex_rate) + cos_ed,
                       2
                      ) total_loc_cost
           FROM (
                 --Dev2: Pure Finance : END
                 SELECT   afc.com_number, fl.lic_currency, fl.lic_type,
                          fl.lic_rate, flee.lee_short_name,
                          fl.lic_budget_code, x.com_name chnl_comp,
                          x.ter_cur_code,
                                         --lis_per_year,
                                         --lis_per_month,
                                         flv.lis_yyyymm_num,
                          SUM (flv.lis_con_aa_emu_23) COST,
                          SUM (flv.lis_con_aa_mu_23) markup,
                          SUM (flv.lis_loc_aa_emu) e_cost,
                          SUM (flv.lis_loc_aa_mu_3) e_markup,
                          pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                 (fl.lic_currency,
                                                  x.ter_cur_code,
                                                  i_acct_prvlng_rate,
                                                  fl.lic_rate,
                                                  fl.lic_start,
                                                  v_go_live_date
                                                 ) ex_rate,
                          pkg_fin_mnet_lib_val_rep.sumcol1_ex
                                            (fl.lic_number,
                                             xfsl.lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date)
                                            ) curr3_cost,

                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [ PV and ED ]
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'PV'
                                                ) cos_pv,
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'ED'
                                                ) cos_ed
                     --Dev2: Pure Finance : END
                 FROM     x_mv_subledger_data flv,
                          fid_license fl,
                          fid_contract fcon,
                          fid_licensee flee,
                          fid_company afc,
                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
                          fid_region fr,
                          x_fin_lic_sec_lee xfsl,

                          --Dev2: Pure Finance : END
                          (SELECT ft.ter_cur_code, afc.com_ter_code,
                                  afc.com_name, afc.com_number
                             FROM fid_company afc, fid_territory ft
                            WHERE afc.com_short_name LIKE i_chnl_comp_name
                              AND afc.com_type IN ('CC', 'BC')
                              AND ft.ter_code = afc.com_ter_code) x
                    WHERE flee.lee_cha_com_number = x.com_number
                      AND fcon.con_number = fl.lic_con_number
                      AND afc.com_number = fcon.con_com_number
                      AND fl.lic_type LIKE i_lic_type
                      AND flee.lee_short_name LIKE i_lee_short_name
                      AND fl.lic_budget_code LIKE i_lic_budget_code
                      --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
                      AND fr.reg_code LIKE i_region
                      AND flee.lee_split_region = fr.reg_id
                      AND fl.lic_status NOT IN ('F', 'T')
                      --AND  lic_lee_number     = lee_number
                      AND xfsl.lsl_lee_number = flee.lee_number
                      AND xfsl.lsl_lic_number = fl.lic_number
                      --Dev2: Pure Finance: END
                      AND flv.lis_lic_number = fl.lic_number
                      AND flv.lis_yyyymm_num >=
                             TO_NUMBER (TO_CHAR (TO_DATE (i_from_date),
                                                 'YYYYMM'
                                                )
                                       )
                      AND flv.lis_yyyymm_num <=
                             TO_NUMBER (TO_CHAR (TO_DATE (i_to_date),
                                                 'YYYYMM')
                                       )
                 GROUP BY afc.com_number,
                          fl.lic_currency,
                          fl.lic_type,
                          fl.lic_rate,
                          fl.lic_budget_code,
                          flee.lee_short_name,
                          --lis_per_year,
                          --lis_per_month,
                          flv.lis_yyyymm_num,
                          x.ter_cur_code,
                          x.com_name,
                          fl.lic_start,
                          fl.lic_number,
                          xfsl.lsl_number);
   END prc_cost_sale_rpt_sum_by_per;

--Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/09] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
   PROCEDURE prc_cost_sale_sum_by_per_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (20000);
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      l_qry :=
            'SELECT   fr.REG_CODE,
                      fc.com_number,
                      fl.lic_currency,
                      fl.lic_type,
                      fl.lic_rate,
                      flee.lee_short_name,
                      fl.lic_budget_code,
                      x.com_name chnl_comp,
                      x.ter_cur_code,
                      --lis_per_year || ''.'' || LPAD (lis_per_month, 2, 0),
                      SUBSTR(flv.lis_yyyymm_num,1,4)||''.''||SUBSTR(flv.lis_yyyymm_num,5,2) as lis_yyyymm_num,
                      SUM (flv.lis_con_aa_emu_23) COST,
                      SUM (flv.lis_con_aa_mu_23) markup,
                      SUM (flv.lis_loc_aa_emu) e_cost,
                      SUM (flv.lis_loc_aa_mu_3) e_markup,
                      PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(fl.lic_currency,x.ter_cur_code,'''
                               || i_acct_prvlng_rate
                               || ''',fl.lic_rate,fl.lic_start,'''
                               || v_go_live_date
                               || ''') ex_rate,
                      DECODE
                      ('''
                               || i_acct_prvlng_rate
                               || ''',
                      ''A'', SUM (flv.lis_loc_aa_emu),
                      SUM (flv.lis_con_aa_emu_23)
                      * PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(fl.lic_currency,x.ter_cur_code,'''
                               || i_acct_prvlng_rate
                               || ''',fl.lic_rate,fl.lic_start,'''
                               || v_go_live_date
                               || ''')
                      ) exchange_cost,
                      DECODE
                      ('''
                               || i_acct_prvlng_rate
                               || ''',
                      ''A'', SUM (flv.lis_loc_aa_mu_3),
                      SUM (flv.lis_con_aa_mu_23)
                      * PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(fl.lic_currency,x.ter_cur_code,'''
                               || i_acct_prvlng_rate
                               || ''',fl.lic_rate,fl.lic_start,'''
                               || v_go_live_date
                               || ''')
                      ) exchange_markup';

                            IF i_report_sub_type = 2
                            THEN
                               l_qry :=
                                     l_qry
                                  || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''),''ED'') COS_ED';
                            ELSIF i_report_sub_type = 3
                            THEN
                               l_qry :=
                                     l_qry
                                  || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''),''PV'') COS_PV,

                      ROUND(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''),''PV'')
                      *
                      PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                                  || i_acct_prvlng_rate
                                  || ''',fl.LIC_RATE,fl.lic_start,'''
                                  || v_go_live_date
                                  || '''),2) LOC_PV';
                            ELSIF i_report_sub_type = 4
                            THEN
                               l_qry :=
                                     l_qry
                                  || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''),''PV'') COS_PV,
                      PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''),''ED'') COS_ED,
                      ROUND(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''),''PV'')
                      *
                      PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                                  || i_acct_prvlng_rate
                                  || ''',fl.LIC_RATE,fl.lic_start,'''
                                  || v_go_live_date
                                  || '''),2) LOC_PV,
                      PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(fl.lic_number, xfsl.lsl_number,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''))
                      +
                      PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''),''PV'') TOTAL_CON_COST,
                      ROUND((PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(fl.lic_number, xfsl.lsl_number,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''))
                      *
                      PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                                  || i_acct_prvlng_rate
                                  || ''',fl.LIC_RATE,fl.lic_start,'''
                                  || v_go_live_date
                                  || '''))
                      +
                      (PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''),''PV'')
                      *
                      PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                                  || i_acct_prvlng_rate
                                  || ''',fl.LIC_RATE,fl.lic_start,'''
                                  || v_go_live_date
                                  || '''))
                      +
                      PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                                  || i_from_date
                                  || '''),TO_DATE ('''
                                  || i_to_date
                                  || '''),''ED''),2) TOTAL_LOC_COST';
                            END IF;

                            l_qry :=
                                  l_qry
                               || ' FROM x_mv_subledger_data flv,
                      fid_license fl,
                      fid_licensee flee,
                      fid_company fc,
                      fid_contract fcon,
                      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
                      FID_REGION fr,
                      X_FIN_LIC_SEC_LEE xfsl,
                      --Dev2: Pure Finance : END
                      (SELECT ter_cur_code, a.com_ter_code, a.com_name,
                      a.com_number
                      FROM fid_company a, fid_territory
                      WHERE a.com_short_name LIKE '''
                               || i_chnl_comp_name
                               || '''
                      AND a.com_type IN (''CC'', ''BC'')
                      AND ter_code = com_ter_code) x
                      WHERE flee.lee_cha_com_number = x.com_number
                      AND fl.lic_type LIKE '''
                               || i_lic_type
                               || '''
                      AND flee.lee_short_name LIKE '''
                               || i_lee_short_name
                               || '''
                      AND fl.lic_budget_code LIKE '''
                               || i_lic_budget_code
                               || '''
                      --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
                      AND fr.REG_CODE LIKE '''
                               || i_region
                               || '''
                      AND fc.com_short_name LIKE '''
                               || i_supplier_code
                               || '''
                      AND flee.lee_split_region = fr.reg_id
                      AND fcon.con_number = fl.lic_con_number
                      AND fc.com_number = fcon.con_com_number
                      AND fl.LIC_STATUS NOT IN (''F'',''T'')
                      --AND    fl.lic_lee_number     = flee.lee_number
                      AND xfsl.lsl_lee_number = flee.lee_number
                      AND xfsl.lsl_lic_number = fl.lic_number
                      --Dev2: Pure Finance: END
                      AND flv.lis_lic_number = fl.lic_number
                      AND flv.lis_yyyymm_num >= '
                               || TO_NUMBER (TO_CHAR (i_from_date, 'YYYYMM'))
                               || ' AND flv.lis_YYYYMM_NUM <='
                               || TO_NUMBER (TO_CHAR (i_to_date, 'YYYYMM'))
                               --AND lis_per_year || LPAD (lis_per_month, 2, 0) >= '
                               --|| TO_CHAR (i_from_date, 'YYYYMM')
                               --||'AND lis_per_year || LPAD (lis_per_month, 2, 0) <= '
                               --|| TO_CHAR (i_to_date, 'YYYYMM')
                               || '
                      GROUP BY fc.com_number,
                      fl.lic_currency,
                      fl.lic_type,
                      fl.lic_rate,
                      fl.lic_budget_code,
                      flee.lee_short_name,
                      --lis_per_year,
                      --lis_per_month,
                      flv.lis_YYYYMM_NUM,
                      x.ter_cur_code,
                      x.com_name,
                      fl.lic_start,
                      fr.reg_code,
                      fl.lic_number';

      ------------- Finance Report Rewrite_[shantanu aggarwal]_[11/7/2014]---------------------
      IF i_report_sub_type IN (2, 3, 4)
      THEN
         l_qry := l_qry || ',xfsl.lsl_number';
      END IF;

      ------------- Finance Report Rewrite_[End]------------------
      DBMS_OUTPUT.put_line ('l_qry:' || l_qry);

      OPEN o_lib_rep FOR l_qry;
   END prc_cost_sale_sum_by_per_exl;

--Dev2: Pure Finance : END
--PROCEDURE FOR Cost of Sales Report Write Offs FIDCOS01D.rdf
   PROCEDURE prc_cost_sale_rpt_write_offs (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                  --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      OPEN o_lib_rep FOR
         --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
         SELECT   com_number, lic_currency, lic_type, lic_rate,
                  lee_short_name, lic_budget_code, supplier, chnl_comp,
                  ter_cur_code, con_short_name, lic_number,
                  SUBSTR (gen_title, 1, 22) gen_title, acct_date, lic_start,
                  lic_end, lic_amort_code, lic_showing_lic,
                  lic_markup_percent, showsrem, lis_con_aa_emu, lis_con_aa_mu,
                  lis_loc_aa_emu, lis_loc_aa_mu, ex_rate,
                  lis_con_aa_emu * cost_wo_percent COST,
                  lis_con_aa_mu * cost_wo_percent markup, exh,
                  DECODE (i_acct_prvlng_rate,
                          'A', lis_con_aa_emu * cost_wo_num,
                          lis_con_aa_emu * ex_rate
                         ) exchange_cost,
                  DECODE (i_acct_prvlng_rate,
                          'A', lis_con_aa_emu,
                          lis_con_aa_emu * ex_rate
                         ) exchange_markup,
                  cos_pv, cos_ed, ROUND (cos_pv * ex_rate, 2) loc_pv,
                  curr3_cost + cos_pv total_con_cost,
                  ROUND ((curr3_cost * ex_rate) + (cos_pv * ex_rate) + cos_ed,
                         2
                        ) total_loc_cost
             FROM (
                   --Dev2: Pure Finance : END
                   SELECT afc.com_number, fl.lic_currency, fl.lic_type,
                          fl.lic_rate, flee.lee_short_name,
                          fl.lic_budget_code,
                          SUBSTR (afc.com_short_name, 1, 8) supplier,
                          x.com_name chnl_comp, x.ter_cur_code,
                          fcon.con_short_name, fl.lic_number, fg.gen_title,
                          TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                          fl.lic_start, fl.lic_end, fl.lic_amort_code,
                          fl.lic_showing_lic, fl.lic_markup_percent,
                          DECODE
                             (fl.lic_catchup_flag,
                              'Y', NULL,
                              (   LTRIM (TO_CHAR (  fl.lic_showing_int
                                                  - fl.lic_showing_paid,
                                                  '999'
                                                 )
                                        )
                               || '/'
                               || LTRIM (to_char(fl.lic_showing_int, '999'))
                              )
                             ) showsrem,
                          flv.lis_con_aa_emu_23 AS lis_con_aa_emu,
                          flv.lis_con_aa_mu_23 AS lis_con_aa_mu,
                          flv.lis_loc_aa_emu,
                          flv.lis_loc_aa_mu_3 AS lis_loc_aa_mu,
                          pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                 (lic_currency,
                                                  x.ter_cur_code,
                                                  i_acct_prvlng_rate,
                                                  fl.lic_rate,
                                                  fl.lic_start,
                                                  v_go_live_date
                                                 ) ex_rate,
                          pkg_fin_mnet_lib_val_rep.fun_cost_sale_wo_percent
                                         (i_from_date,
                                          i_to_date,
                                          fl.lic_number,
                                          fl.lic_showing_lic,
                                          fl.lic_start,
                                          v_go_live_date
                                         ) cost_wo_percent,
                          pkg_fin_mnet_lib_val_rep.sumcol1_ex
                                            (fl.lic_number,
                                             xfsl.lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date)
                                            ) curr3_cost,
                          DECODE
                             (fl.lic_catchup_flag,
                              'Y', NULL,
                              pkg_fin_mnet_lib_val_rep.fun_cost_sale_sch_paid_1
                                                        (TO_DATE (i_from_date),
                                                         TO_DATE (i_to_date),
                                                         fl.lic_number,
                                                         fl.lic_start,
                                                         v_go_live_date
                                                        )
                             ) exh,
                          pkg_fin_mnet_lib_val_rep.fun_cost_sale_wo_number
                                           (TO_DATE (i_from_date),
                                            fl.lic_number,
                                            fl.lic_showing_lic,
                                            fl.lic_start,
                                            v_go_live_date
                                           ) cost_wo_num,

                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [ PV and ED ]
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'PV'
                                                ) cos_pv,
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'ED'
                                                ) cos_ed
                     --Dev2: Pure Finance : END
                   FROM   fid_company afc,
                          fid_general fg,
                          fid_contract fcon,
                          fid_licensee flee,
                          fid_license fl,
                          --fid_lis_vw flv,
                          x_mv_subledger_data flv,
                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
                          fid_region fr,
                          x_fin_lic_sec_lee xfsl,

                          --Dev2: Pure Finance : END
                          (SELECT ft.ter_cur_code, afc.com_short_name,
                                  afc.com_ter_code, afc.com_name,
                                  afc.com_number
                             FROM fid_company afc, fid_territory ft
                            WHERE afc.com_short_name LIKE i_chnl_comp_name
                              AND afc.com_type IN ('CC', 'BC')
                              AND ft.ter_code = afc.com_ter_code) x
                    WHERE flee.lee_cha_com_number = x.com_number
                      AND fl.lic_type LIKE i_lic_type
                      AND flee.lee_short_name LIKE i_lee_short_name
                      AND fl.lic_budget_code LIKE i_lic_budget_code
                      --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
                      AND fr.reg_code LIKE i_region
                      AND flee.lee_split_region = fr.reg_id
                      AND fl.lic_status NOT IN ('F', 'T')
                      --AND  lic_lee_number     = lee_number
                      AND xfsl.lsl_lee_number = flee.lee_number
                      AND xfsl.lsl_lic_number = fl.lic_number
                      --Dev2: Pure Finance: END
                      AND fcon.con_number = fl.lic_con_number
                      AND afc.com_number = fcon.con_com_number
                      AND fg.gen_refno = fl.lic_gen_refno
                      AND TO_CHAR (fl.lic_end, 'YYYYMM') =
                                     TO_CHAR (TO_DATE (i_from_date), 'YYYYMM')
                      AND fl.lic_showing_lic >
                             (SELECT NVL (SUM (DECODE (fs.sch_type,
                                                       'P', 1,
                                                       0
                                                      )),
                                          0
                                         )
                                FROM fid_schedule fs
                               WHERE fs.sch_lic_number = fl.lic_number)
                      AND flv.lis_lic_number = fl.lic_number
                      AND flv.lis_yyyymm_num =
                             TO_NUMBER (TO_CHAR (TO_DATE (i_from_date),
                                                 'YYYYMM'
                                                )
                                       )
                      AND flv.lis_con_aa_emu_23 != 0
                                                    --  and rownum<=100
                  )
         ORDER BY lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  gen_title,
                  lic_number;
   END prc_cost_sale_rpt_write_offs;

--Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/09] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
   PROCEDURE prc_cost_sale_write_offs_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (20000);
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      l_qry :=
            'SELECT   fr.REG_CODE,
            afc.com_number,
            fl.lic_currency,
            fl.lic_type,
            fl.lic_rate,
            flee.lee_short_name,
            fl.lic_budget_code,
            SUBSTR (afc.com_short_name, 1, 8) supplier,
            x.com_name chnl_comp,
            x.ter_cur_code,
            fcon.con_short_name,
            fl.lic_number,
            SUBSTR (fg.gen_title, 1, 22) gen_title,
            TO_CHAR (fl.lic_acct_date, ''YYYY.MM'') acct_date,
            TO_CHAR(fl.lic_start,''DD-MON-YYYY'') lic_start,
            TO_CHAR(fl.lic_end,''DD-MON-YYYY'') lic_end,
            fl.lic_amort_code,
            fl.lic_showing_lic,
            fl.lic_markup_percent,
            DECODE (fl.lic_catchup_flag,
            ''Y'', '''', '''' ||
            to_char(NVL(LTRIM (TO_CHAR ( fl.lic_showing_int - fl.lic_showing_paid,''999'')),0)|| ''/''|| LTRIM (to_char(fl.lic_showing_int, ''999'')))
            ) showsrem
            --,b.com_number    b_com_number
            ,
            mvlsl.lis_con_aa_emu_23 as lis_con_aa_emu,
            mvlsl.lis_con_aa_mu_23  as lis_con_aa_mu,
            mvlsl.lis_loc_aa_emu   as lis_loc_aa_emu,
            mvlsl.lis_loc_aa_mu_3   as lis_loc_aa_mu,
            PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX
            (fl.lic_currency,x.ter_cur_code,'''
                     || i_acct_prvlng_rate
                     || ''',fl.lic_rate,fl.lic_start,'''
                     || v_go_live_date
                     || '''
            ) ex_rate,
            mvlsl.lis_con_aa_emu_23* pkg_fin_mnet_lib_val_rep.fun_cost_sale_wo_percent
            ( TO_DATE ('''
                     || i_from_date
                     || '''),
            TO_DATE ('''
                     || i_to_date
                     || '''),
            fl.lic_number,
            fl.lic_showing_lic,
            fl.lic_start,
            '''
                     || v_go_live_date
                     || '''
            ) COST,
            mvlsl.lis_con_aa_mu_23* PKG_FIN_MNET_LIB_VAL_REP.fun_cost_sale_wo_percent
            ( TO_DATE ('''
                     || i_from_date
                     || '''),
            TO_DATE ('''
                     || i_to_date
                     || '''),
            fl.lic_number,
            fl.lic_showing_lic,
            fl.lic_start,
            '''
                     || v_go_live_date
                     || '''
            ) markup,
            DECODE
            (fl.lic_catchup_flag,
            ''Y'', NULL,
            PKG_FIN_MNET_LIB_VAL_REP.fun_cost_sale_sch_paid_1
            (TO_DATE ('''
                     || i_from_date
                     || '''),
            TO_DATE ('''
                     || i_to_date
                     || '''),
            fl.lic_number,
            fl.lic_start,
            '''
                     || v_go_live_date
                     || '''
            )
            )exh,
            DECODE
            ('''
                     || i_acct_prvlng_rate
                     || ''',
            ''A'', mvlsl.lis_con_aa_emu_23
            * PKG_FIN_MNET_LIB_VAL_REP.fun_cost_sale_wo_number
            (TO_DATE ('''
                     || i_from_date
                     || '''),
            fl.lic_number,
            fl.lic_showing_lic,fl.lic_start,'''
                     || v_go_live_date
                     || '''
            ),
            mvlsl.lis_con_aa_emu_23
            * PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(fl.lic_currency,x.ter_cur_code,'''
                     || i_acct_prvlng_rate
                     || ''',fl.lic_rate,fl.lic_start,'''
                     || v_go_live_date
                     || ''')
            ) exchange_cost,
            DECODE
            ('''
                     || i_acct_prvlng_rate
                     || ''',
            ''A'', mvlsl.lis_con_aa_emu_23,
            mvlsl.lis_con_aa_emu_23
            * PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(fl.lic_currency,x.ter_cur_code,'''
                     || i_acct_prvlng_rate
                     || ''',fl.lic_rate,fl.lic_start,'''
                     || v_go_live_date
                     || ''')
            ) exchange_markup';

                  IF i_report_sub_type = 2
                  THEN
                     l_qry :=
                           l_qry
                        || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''),''ED'') COS_ED';
                  ELSIF i_report_sub_type = 3
                  THEN
                     l_qry :=
                           l_qry
                        || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number,xfsl.LSL_NUMBER,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''),''PV'') COS_PV,

            ROUND(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''),''PV'')
            *
            PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                        || i_acct_prvlng_rate
                        || ''',fl.LIC_RATE,fl.lic_start,'''
                        || v_go_live_date
                        || '''),2) LOC_PV';
                  ELSIF i_report_sub_type = 4
                  THEN
                     l_qry :=
                           l_qry
                        || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''),''PV'') COS_PV,
            PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''),''ED'') COS_ED,
            ROUND(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''),''PV'')
            *
            PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                        || i_acct_prvlng_rate
                        || ''',fl.LIC_RATE,fl.lic_start,'''
                        || v_go_live_date
                        || '''),2) LOC_PV,
            PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(fl.lic_number, xfsl.lsl_number,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''))
            +
            PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number,xfsl.LSL_NUMBER,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''),''PV'') TOTAL_CON_COST,
            ROUND((PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(fl.lic_number, xfsl.lsl_number,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''))
            *
            PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                        || i_acct_prvlng_rate
                        || ''',fl.LIC_RATE,fl.lic_start,'''
                        || v_go_live_date
                        || '''))
            +
            (PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''),''PV'')
            *
            PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                        || i_acct_prvlng_rate
                        || ''',fl.LIC_RATE,fl.lic_start,'''
                        || v_go_live_date
                        || '''))
            +
            PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                        || i_from_date
                        || '''),TO_DATE ('''
                        || i_to_date
                        || '''),''ED''),2) TOTAL_LOC_COST';
                  END IF;

                  l_qry :=
                        l_qry
                     || ' FROM    fid_company      afc,
            fid_general      fg,
            --,fid_company b
            fid_contract     fcon,
            fid_licensee     flee,
            fid_license      fl,
            --fid_lis_vw       flv,
            x_mv_subledger_data mvlsl,
            --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
            FID_REGION       fr,
            X_FIN_LIC_SEC_LEE  xfsl,
            --Dev2: Pure Finance : END
            (SELECT  ft.ter_cur_code,
            fc.com_short_name,
            fc.com_ter_code,
            fc.com_name,
            fc.com_number
            FROM    fid_company fc, fid_territory ft
            WHERE    fc.com_short_name LIKE '''
                     || i_chnl_comp_name
                     || '''
            AND    fc.com_type IN (''CC'', ''BC'')
            AND    ft.ter_code = fc.com_ter_code
            )x
            WHERE flee.lee_cha_com_number = x.com_number
            AND fl.lic_type LIKE '''
                     || i_lic_type
                     || '''
            AND flee.lee_short_name LIKE '''
                     || i_lee_short_name
                     || '''
            AND fl.lic_budget_code LIKE '''
                     || i_lic_budget_code
                     || '''
            --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
            AND fr.REG_CODE LIKE '''
                     || i_region
                     || '''
            AND afc.com_short_name LIKE '''
                     || i_supplier_code
                     || '''
            AND flee.lee_split_region = fr.reg_id
            AND fl.LIC_STATUS NOT IN (''F'',''T'')
            --AND    lic_lee_number     = lee_number
            AND xfsl.lsl_lee_number = flee.lee_number
            AND xfsl.lsl_lic_number = fl.lic_number
            --Dev2: Pure Finance: END
            AND fcon.con_number = fl.lic_con_number
            AND afc.com_number = fcon.con_com_number
            AND fg.gen_refno = fl.lic_gen_refno
            AND TO_CHAR (lic_end, ''YYYYMM'') = TO_CHAR (TO_DATE ('''
                     || i_from_date
                     || '''), ''YYYYMM'')
            AND fl.lic_showing_lic >
            (
            SELECT NVL (SUM (DECODE (sch_type, ''P'', 1, 0)), 0)
            FROM fid_schedule
            WHERE sch_lic_number = fl.lic_number
            )
            AND mvlsl.lis_lic_number = fl.lic_number
            --AND flv.lis_per_year || LPAD (lis_per_month, 2, 0) =  TO_CHAR (TO_DATE ('''|| i_from_date|| '''), ''YYYYMM'')
            AND mvlsl.lis_YYYYMM_NUM = TO_NUMBER( TO_CHAR (TO_DATE ('''
                     || i_from_date
                     || '''), ''YYYYMM'') )
            --AND flv.lis_con_aa_emu != 0
            AND mvlsl.lis_con_aa_emu_23 !=0
            ORDER BY  lic_currency,
            lic_type,
            lee_short_name,
            lic_budget_code,
            x.com_short_name,
            con_short_name,
            gen_title,
            lic_number';
      DBMS_OUTPUT.put_line ('l_qry:' || l_qry);

      OPEN o_lib_rep FOR l_qry;
   END prc_cost_sale_write_offs_exl;

--Dev2: Pure Finance : END
--PROCEDURE FOR Cost of Sales Report Exceptions FIDCOS01E.rdf
   PROCEDURE prc_cost_sale_rpt_exceptions (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,                                  --%
      --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      --Dev2: Pure Finance : END
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      OPEN o_lib_rep FOR
         --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
         SELECT   com_number, lic_currency, lic_type, lee_short_name,
                  lic_budget_code, supplier, chnl_comp, ter_cur_code,
                  con_short_name, lic_number,
                  SUBSTR (gen_title, 1, 22) gen_title, acct_date, lic_start,
                  LIC_END, LIC_RATE, LIC_AMORT_CODE, LIC_SHOWING_LIC,
                  lic_markup_percent, showsrem, lis_con_aa_emu, lis_con_aa_mu,
                  lis_loc_aa_emu, lis_loc_aa_mu, ex_rate, COST, markup,
                  DECODE (i_acct_prvlng_rate,
                          'A', lis_con_aa_emu,
                          lis_con_aa_emu * ex_rate
                         ) exchange_cost,
                  DECODE (i_acct_prvlng_rate,
                          'A', lis_con_aa_emu,
                          lis_con_aa_emu * ex_rate
                         ) exchange_markup,
                  exh, cos_pv, cos_ed, ROUND (cos_pv * ex_rate, 2) loc_pv,
                  curr3_cost + cos_pv total_con_cost,
                  ROUND ((curr3_cost * ex_rate) + (cos_pv * ex_rate) + cos_ed,
                         2
                        ) total_loc_cost
             FROM (
                   --Dev2: Pure Finance : END
                   SELECT afc.com_number, fl.lic_currency, fl.lic_type,
                          flee.lee_short_name, fl.lic_budget_code,
                          SUBSTR (afc.com_short_name, 1, 8) supplier,
                          x.com_name chnl_comp, x.ter_cur_code,
                          fcon.con_short_name, fl.lic_number, fg.gen_title,
                          TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                          fl.lic_start, fl.lic_end,
                          ROUND (fl.lic_rate, 4) lic_rate, fl.lic_amort_code,
                          fl.lic_showing_lic,
                          ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
                          DECODE
                             (fl.lic_catchup_flag,
                              'Y', '',
                              to_char( ' ' || LTRIM (TO_CHAR (  fl.lic_showing_int
                                                  - fl.lic_showing_paid,
                                                  '999'
                                                 )
                                        )
                               || '/'
                               || LTRIM (to_char(fl.lic_showing_int, '999'))
                              )
                             ) showsrem,
                          mvlsl.lis_con_aa_emu_23 AS lis_con_aa_emu,
                          mvlsl.lis_con_aa_mu_23 AS lis_con_aa_mu,
                          mvlsl.lis_loc_aa_emu,
                          mvlsl.lis_loc_aa_mu_3 AS lis_loc_aa_mu,
                          pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                 (fl.lic_currency,
                                                  x.ter_cur_code,
                                                  i_acct_prvlng_rate,
                                                  fl.lic_rate,
                                                  fl.lic_start,
                                                  v_go_live_date
                                                 ) ex_rate,
                          pkg_fin_mnet_lib_val_rep.sumcol1_ex
                                            (fl.lic_number,
                                             xfsl.lsl_number,
                                             TO_DATE (i_from_date),
                                             TO_DATE (i_to_date)
                                            ) curr3_cost,
                          mvlsl.lis_con_aa_emu_23 COST,
                          mvlsl.lis_con_aa_mu_23 markup,
                          DECODE
                             (fl.lic_catchup_flag,
                              'Y', NULL,
                              pkg_fin_mnet_lib_val_rep.fun_cost_sale_sch_paid_1
                                                        (TO_DATE (i_from_date),
                                                         TO_DATE (i_to_date),
                                                         fl.lic_number,
                                                         fl.lic_start,
                                                         v_go_live_date
                                                        )
                             ) exh,

                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [ PV and ED ]
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'PV'
                                                ) cos_pv,
                          pkg_fin_mnet_lib_val_rep.fun_sum_pv_ed_ac
                                                (fl.lic_number,
                                                 xfsl.lsl_number,
                                                 TO_DATE (i_from_date),
                                                 TO_DATE (i_to_date),
                                                 'ED'
                                                ) cos_ed
                     --Dev2: Pure Finance : END
                   FROM   fid_company afc,
                          fid_general fg,
                          fid_contract fcon,
                          fid_licensee flee,
                          fid_license fl,
                          --fid_lis_vw flv,
                          x_mv_subledger_data mvlsl,
                          --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
                          fid_region fr,
                          x_fin_lic_sec_lee xfsl,

                          --Dev2: Pure Finance : END
                          (SELECT ft.ter_cur_code, afc.com_ter_code,
                                  afc.com_name, afc.com_number
                             FROM fid_company afc, fid_territory ft
                            WHERE afc.com_short_name LIKE i_chnl_comp_name
                              AND afc.com_type IN ('CC', 'BC')
                              AND ft.ter_code = afc.com_ter_code) x
                    WHERE flee.lee_cha_com_number = x.com_number
                      AND fl.lic_type = 'FLF'
                      AND flee.lee_short_name LIKE i_lee_short_name
                      AND fl.lic_budget_code LIKE i_lic_budget_code
                      --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
                      AND fr.reg_code LIKE i_region
                      AND flee.lee_split_region = fr.reg_id
                      AND fl.lic_status NOT IN ('F', 'T')
                      --AND  lic_lee_number     = lee_number
                      AND xfsl.lsl_lee_number = flee.lee_number
                      AND xfsl.lsl_lic_number = fl.lic_number
                      --Dev2: Pure Finance: END
                      AND fcon.con_number = fl.lic_con_number
                      AND afc.com_number = fcon.con_com_number
                      AND fg.gen_refno = fl.lic_gen_refno
                      AND TO_CHAR (fl.lic_end, 'YYYYMM') =
                                     TO_CHAR (TO_DATE (i_from_date), 'YYYYMM')
                      AND mvlsl.lis_lic_number = fl.lic_number
                      AND mvlsl.lis_yyyymm_num =
                             TO_NUMBER (TO_CHAR (TO_DATE (i_from_date),
                                                 'YYYYMM'
                                                )
                                       )
                      AND fl.lic_price !=
                             (SELECT SUM (  flsl.lis_con_actual
                                          + flsl.lis_con_adjust
                                         )
                                FROM fid_license_sub_ledger flsl
                               WHERE flsl.lis_lic_number = fl.lic_number))
         ORDER BY lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  gen_title,
                  lic_number;
   END prc_cost_sale_rpt_exceptions;

--Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/09] : [AFR/Rsa Split, PV, ED, Spot Rate Implementation, Multiple Licensees for FLF]
   PROCEDURE prc_cost_sale_exceptions_exl (
      i_from_date          IN       DATE,
      i_to_date            IN       DATE,
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_lee_short_name     IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code    IN       fid_license.lic_budget_code%TYPE,
      i_acct_prvlng_rate   IN       CHAR,
      i_region             IN       VARCHAR2,
      i_supplier_code      IN       VARCHAR2,
      i_report_sub_type    IN       NUMBER,
      o_lib_rep            OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (20000);
      v_go_live_date   DATE;
   BEGIN
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      l_qry :=
            'SELECT   fr.REG_CODE,
              afc.com_number,
              fl.lic_currency,
              fl.lic_type,
              flee.lee_short_name,
              fl.lic_budget_code,
              SUBSTR (afc.com_short_name, 1, 8) supplier,
              x.com_name chnl_comp,
              x.ter_cur_code,
              fcon.con_short_name,
              fl.lic_number,
              SUBSTR (fg.gen_title, 1, 22),
              TO_CHAR (fl.lic_acct_date, ''YYYY.MM'') acct_date,
              TO_CHAR(fl.lic_start,''DD-MON-YYYY'') lic_start,
              TO_CHAR(fl.lic_end,''DD-MON-YYYY'')lic_end,
              ROUND (fl.lic_rate, 5) lic_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
              fl.lic_amort_code,
              fl.lic_showing_lic,
              ROUND (fl.lic_markup_percent, 4) lic_markup_percent,
              DECODE (fl.lic_catchup_flag,
              ''Y'', '''', '''' ||
              to_char(nvl(LTRIM (TO_CHAR (  fl.lic_showing_int - fl.lic_showing_paid,''999'' )),0)|| ''/''|| LTRIM (to_char(fl.lic_showing_int, ''999'')))
              ) showsrems
              --,b.com_number    b_com_number
              ,
              mvlsl.lis_con_aa_emu_23 as lis_con_aa_emu,
              mvlsl.lis_con_aa_mu_23  as lis_con_aa_mu,
              mvlsl.lis_loc_aa_emu   as lis_loc_aa_emu,
              mvlsl.lis_loc_aa_mu_3   as lis_loc_aa_mu,
              PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(fl.lic_currency,x.ter_cur_code,'''
                       || i_acct_prvlng_rate
                       || ''',fl.lic_rate,fl.lic_start,'''
                       || v_go_live_date
                       || ''') ex_rate,
              mvlsl.lis_con_aa_emu_23 COST, mvlsl.lis_con_aa_mu_23 markup,
              DECODE
              ('''
                       || i_acct_prvlng_rate
                       || ''',
              ''A'', mvlsl.lis_con_aa_emu_23,
              mvlsl.lis_con_aa_emu_23
              * PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(fl.lic_currency,x.ter_cur_code,'''
                       || i_acct_prvlng_rate
                       || ''',fl.lic_rate,fl.lic_start,'''
                       || v_go_live_date
                       || ''')
              ) exchange_cost,
              DECODE
              ('''
                       || i_acct_prvlng_rate
                       || ''',
              ''A'', mvlsl.lis_con_aa_emu_23,
              mvlsl.lis_con_aa_emu_23
              * PKG_FIN_MNET_LIB_VAL_REP.FUN_INV_MMT_REPORT_EX_RATE_EX(fl.lic_currency,x.ter_cur_code,'''
                       || i_acct_prvlng_rate
                       || ''',fl.lic_rate,fl.lic_start,'''
                       || v_go_live_date
                       || ''')
              ) exchange_markup,
              DECODE
              (fl.lic_catchup_flag,
              ''Y'', NULL,
              PKG_FIN_MNET_LIB_VAL_REP.fun_cost_sale_sch_paid_1
              (TO_DATE ('''
                       || i_from_date
                       || '''),TO_DATE ('''
                       || i_to_date
                       || '''),
              fl.lic_number,fl.lic_start,'''
                       || v_go_live_date
                       || '''
              )
              ) exh';

                    IF i_report_sub_type = 2
                    THEN
                       l_qry :=
                             l_qry
                          || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                          || i_from_date
                          || '''),TO_DATE ('''
                          || i_to_date
                          || '''),''ED'') COS_ED';
                    ELSIF i_report_sub_type = 3
                    THEN
                       l_qry :=
                             l_qry
                          || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                          || i_from_date
                          || '''),TO_DATE ('''
                          || i_to_date
                          || '''),''PV'') COS_PV,

              ROUND(PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                          || i_from_date
                          || '''),TO_DATE ('''
                          || i_to_date
                          || '''),''PV'')
              *
              PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                          || i_acct_prvlng_rate
                          || ''',fl.LIC_RATE,fl.lic_start,'''
                          || v_go_live_date
                          || '''),2) LOC_PV';
                    ELSIF i_report_sub_type = 4
                    THEN
                       l_qry :=
                             l_qry
                          || ',PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC
              (fl.lic_number,
              xfsl.LSL_NUMBER,TO_DATE ('''
                          || i_from_date
                          || '''),TO_DATE ('''
                          || i_to_date
                          || '''),''PV''
              )COS_PV,
              PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC
              (fl.lic_number,
              xfsl.LSL_NUMBER,
              TO_DATE ('''
                          || i_from_date
                          || '''),
              TO_DATE ('''
                          || i_to_date
                          || '''),
              ''ED''
              ) COS_ED,
              ROUND( PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC
              (fl.lic_number,
              xfsl.LSL_NUMBER,
              TO_DATE ('''
                          || i_from_date
                          || '''),
              TO_DATE ('''
                          || i_to_date
                          || '''),''PV''
              )
              *
              PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex
              (
              fl.lic_currency,
              x.ter_cur_code,
              '''
                          || i_acct_prvlng_rate
                          || ''',
              fl.LIC_RATE,
              fl.lic_start,
              '''
                          || v_go_live_date
                          || '''
              ),
              2) LOC_PV,
              PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(fl.lic_number, xfsl.lsl_number,TO_DATE ('''
                          || i_from_date
                          || '''),TO_DATE ('''
                          || i_to_date
                          || '''))
              +
              PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                          || i_from_date
                          || '''),TO_DATE ('''
                          || i_to_date
                          || '''),''PV'') TOTAL_CON_COST,
              ROUND((PKG_FIN_MNET_LIB_VAL_REP.SUMCOL1_EX(fl.lic_number, xfsl.lsl_number,TO_DATE ('''
                          || i_from_date
                          || '''),TO_DATE ('''
                          || i_to_date
                          || '''))
              *
              PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                          || i_acct_prvlng_rate
                          || ''',fl.LIC_RATE,fl.lic_start,'''
                          || v_go_live_date
                          || '''))
              +
              (PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number, xfsl.LSL_NUMBER,TO_DATE ('''
                          || i_from_date
                          || '''),TO_DATE ('''
                          || i_to_date
                          || '''),''PV'')
              *
              PKG_FIN_MNET_LIB_VAL_REP.fun_inv_mmt_report_ex_rate_ex(fl.lic_currency,x.ter_cur_code,'''
                          || i_acct_prvlng_rate
                          || ''',fl.LIC_RATE,fl.lic_start,'''
                          || v_go_live_date
                          || '''))
              +
              PKG_FIN_MNET_LIB_VAL_REP.FUN_SUM_PV_ED_AC(fl.lic_number,xfsl.LSL_NUMBER,TO_DATE ('''
                          || i_from_date
                          || '''),TO_DATE ('''
                          || i_to_date
                          || '''),''ED''),2) TOTAL_LOC_COST';
                    END IF;

                    l_qry :=
                          l_qry
                       || ' FROM fid_company    afc,
              fid_general    fg,
              --,fid_company b
              fid_contract    fcon,
              fid_licensee    flee,
              fid_license     fl,
              --fid_lis_vw      flv,
              x_mv_subledger_data  mvlsl,
              --Dev2: Pure Finance : START : [Avinash Lanka] : [2013/04/04] : [AFR/Rsa Split, Multiple Licensees for FLF]
              FID_REGION       fr,
              X_FIN_LIC_SEC_LEE  xfsl,
              --Dev2: Pure Finance : END
              (SELECT ft.ter_cur_code, fc.com_ter_code, fc.com_name,
              fc.com_number
              FROM fid_company fc, fid_territory ft
              WHERE fc.com_short_name LIKE '''
                       || i_chnl_comp_name
                       || '''
              AND fc.com_type IN (''CC'', ''BC'')
              AND ft.ter_code = fc.com_ter_code
              ) x
              WHERE flee.lee_cha_com_number = x.com_number
              AND fl.lic_type = ''FLF''
              AND flee.lee_short_name LIKE '''
                       || i_lee_short_name
                       || '''
              AND fl.lic_budget_code LIKE '''
                       || i_lic_budget_code
                       || '''
              --Dev2: Pure Finance: Start:[AFR/Rsa Split, Multiple Licensees for FLF, Non-Costed Fillers]_[AvinashLanka]_[2013/04/04]
              AND fr.REG_CODE LIKE '''
                       || i_region
                       || '''
              AND afc.com_short_name LIKE '''
                       || i_supplier_code
                       || '''
              AND flee.lee_split_region = fr.reg_id
              AND fl.LIC_STATUS NOT IN (''F'',''T'')
              --AND    lic_lee_number     = lee_number
              AND lsl_lee_number = flee.lee_number
              AND lsl_lic_number = fl.lic_number
              --Dev2: Pure Finance: END
              AND fcon.con_number = fl.lic_con_number
              AND afc.com_number = fcon.con_com_number
              AND fg.gen_refno = fl.lic_gen_refno
              AND TO_CHAR (fl.lic_end, ''YYYYMM'') =TO_CHAR (TO_DATE ('''
                       || i_from_date
                       || '''), ''YYYYMM'')
              AND mvlsl.lis_lic_number = fl.lic_number
              --AND flv.lis_per_year || LPAD (lis_per_month, 2, 0) = TO_NUMBER (TO_CHAR (TO_DATE ('''|| i_from_date|| '''), ''YYYYMM''))
              AND mvlsl.lis_YYYYMM_NUM = TO_NUMBER (TO_CHAR (TO_DATE ('''
                       || i_from_date
                       || '''), ''YYYYMM''))
              AND fl.lic_price != (
              SELECT SUM (lis_con_actual + lis_con_adjust)
              FROM fid_license_sub_ledger
              WHERE lis_lic_number = fl.lic_number
              )
              ORDER BY fl.lic_currency,
              fl.lic_type,
              flee.lee_short_name,
              fl.lic_budget_code,
              afc.com_short_name,
              fcon.con_short_name,
              fg.gen_title,
              fl.lic_number';

      OPEN o_lib_rep FOR l_qry;
   END prc_cost_sale_exceptions_exl;

--Dev2: Pure Finance : END
--Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/28]
   PROCEDURE prc_lib_re_val_reversal (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_markup            IN       VARCHAR2,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      i_lic_region        IN       VARCHAR2,
      i_acc_prv_rate      IN       VARCHAR2,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep
   )
   AS
      l_qry            VARCHAR2 (3000);
      first_day        DATE;
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      v_go_live_date   DATE;
      v_lic_date       DATE;
   --Dev2: Pure Finance :End
   BEGIN
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      SELECT (LAST_DAY (i_from_date) + 1)
        INTO v_lic_date
        FROM DUAL;

      OPEN o_lib_rep FOR
         SELECT   b, com_number, lic_currency, lic_type, lee_short_name,
                  lsl_lee_number, lic_budget_code, supplier, con_short_name,
                  lic_number, com_name, gen_title, acct_date, lic_start,
                  lic_end, lic_amort_code, lic_showing_int,
                  --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                  --lic_showing_lic,
                  DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                  lic_markup_percent, lic_rate, ter_cur_code,
                  --td_exh,
                  DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                  --SIT.R5 : SVOD Enhancements : End
                  SUM (ob_mup) ob_mup,
                  SUM (reval_mu) reval_mu,
                  SUM (reval_mu_loc) reval_mu_loc,
                  ROUND (DECODE (SUM (reval_mu),
                                 0, 0,
                                 SUM (reval_mu_loc) / SUM (reval_mu)
                                ),
                         5
                        ) rev_exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  sum (cost_mu) cost_mu,
                  CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                  THEN 0
                  ELSE (sum (ob_mup) + sum (reval_mu) - sum (cost_mu))
                  END cbmp,
                  CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                  THEN 0
                  ELSE ((sum (ob_mup) + sum (reval_mu) - sum (cost_mu)) * ex_rate)
                  END cb_final,
                  lic_price, from_date, TO_DATE, rat_rate, reg_code
             FROM (SELECT   bfc.com_number b, afc.com_number com_number,
                            fl.lic_currency, fl.lic_type, flee.lee_short_name,
                            xfsl.lsl_lee_number, fl.lic_budget_code,
                            afc.com_short_name supplier, fcon.con_short_name,
                            fl.lic_number, bfc.com_name com_name,
                            fg.gen_title gen_title,
                            TO_CHAR (fl.lic_acct_date, 'YYYY.MM') acct_date,
                            TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                            TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                            fl.lic_amort_code, fl.lic_showing_int,
                            fl.lic_showing_lic,
                            ROUND (fl.lic_markup_percent,
                                   4
                                  ) lic_markup_percent,
                            ROUND (fl.lic_rate, 5) lic_rate, ft.ter_cur_code   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                                                                            --[passing "lic_acct_date" to functions instead of "i_period_date" and lsl_number]
                            ,
                            0 td_exh,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                            round
                               (pkg_fin_mnet_lib_val_rep.x_fun_fin_rep_ob_mp_rversal
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || flsl.lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    flsl.lis_ter_code
                                   ),
                                2
                               )
                          END ob_mup,
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_rversal
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    fl.lic_start,
                                    flsl.lis_ter_code
                                   ),
                                2
                               ) reval_mu,
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_rep_revel_rversal_loc
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || flsl.lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    fl.lic_start,
                                    flsl.lis_ter_code
                                   ),
                                2
                               ) reval_mu_loc,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_reversal
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    fl.lic_start,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || flsl.lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    flsl.lis_ter_code
                                   ),
                                2
                               )
                          END cost_mu,
                          CASE WHEN i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
                          THEN 0
                          ELSE
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                             (fl.lic_currency,
                                                              ft.ter_cur_code,
                                                              'P',
                                                              fl.lic_rate,
                                                              fl.lic_start,
                                                              v_go_live_date
                                                             ),
                                2
                               )
                          END ex_rate,
                            ROUND (xfsl.lsl_lee_price, 4) lic_price,

                            --[changed from lic_price to LSL_LEE_PRICE ]
                            --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                            i_from_date from_date, i_to_date TO_DATE,
                            fr.reg_code,
                                        --Dev2: Pure Finance :end
                                        rat_rate
                       FROM fid_general fg,
                            fid_company afc,
                            fid_company bfc,
                            fid_contract fcon,
                            fid_licensee flee,
                            fid_license_sub_ledger flsl,
                            --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                            x_fin_lic_sec_lee xfsl,
                            --Dev2: Pure Finance :END
                            fid_license fl,
                            fid_territory ft,
                            fid_region fr,
                            fid_exchange_rate fer,
                            (SELECT fc.com_name, fc.com_number,
                                    fc.com_ter_code
                               FROM fid_company fc
                              WHERE fc.com_short_name LIKE i_chnl_comp_name
                                AND fc.com_type IN ('CC', 'BC')) x
                      WHERE flee.lee_cha_com_number = x.com_number
                        AND ft.ter_code LIKE x.com_ter_code
                        AND fl.lic_type LIKE i_lic_type
                        AND flee.lee_short_name LIKE i_lee_short_name
                        --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                        --  AND    lic_lee_number = lee_number
                        AND fl.lic_start >= v_go_live_date                -- 1
                        --2 [ from period + 1st day of next mon should be on or after lic_strt ]
                        --Dev2: Pure Finance : End
                        AND fl.lic_budget_code LIKE i_lic_budget_code
                        AND fcon.con_number = fl.lic_con_number
                        AND afc.com_number = fcon.con_com_number
                        AND fg.gen_refno = fl.lic_gen_refno
                        AND (x.com_number = bfc.com_number)
                        --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                        AND fl.lic_number = xfsl.lsl_lic_number
                        AND flee.lee_number = xfsl.lsl_lee_number
                        AND flsl.lis_lic_number = fl.lic_number
                        AND flsl.lis_lsl_number = xfsl.lsl_number
                        --AND lee_split_region = reg_id
                        AND fr.reg_id(+) = flee.lee_split_region
                        --Dev2: Pure Finance :END
                        --Dev2: Pure Finance :Start:[Non Costed Fillers]_[ANUJASHINDE]_[2013/3/15]
                        --[Added to exclude(fillers) licenses with status F]
                        AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                        --Dev2: Pure Finance[Non Costed Fillers] :End
                        AND fr.reg_code LIKE i_lic_region
                        AND fer.rat_cur_code = fl.lic_currency
                        and fer.rat_cur_code_2 = ft.ter_cur_code
						AND EXISTS (
                               SELECT 1
                                 FROM x_mv_subledger_data mvlsl
                                WHERE mvlsl.lis_lic_number = fl.lic_number
                                  AND mvlsl.lis_yyyymm_num >=
                                         TO_NUMBER (TO_CHAR (i_from_date,
                                                             'YYYYMM'
                                                            )
                                                   )
                                  AND mvlsl.lis_yyyymm_num <=
                                         TO_NUMBER (TO_CHAR (i_to_date,
                                                             'YYYYMM'
                                                            )
                                                   )
								  AND mvlsl.lis_reval_flag = 'RL'
									)
                   ORDER BY fl.lic_currency,
                            fl.lic_type,
                            flee.lee_short_name,
                            fl.lic_budget_code,
                            afc.com_short_name,
                            fcon.con_short_name,
                            fg.gen_title,
                            fl.lic_number)
            WHERE 1 = 1
         GROUP BY b,
                  com_number,
                  lic_currency,
                  lic_type,
                  lee_short_name,
                  lsl_lee_number,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  lic_number,
                  com_name,
                  gen_title,
                  acct_date,
                  lic_start,
                  lic_end,
                  lic_amort_code,
                  lic_showing_int,
                  lic_showing_lic,
                  lic_markup_percent,
                  lic_rate,
                  ter_cur_code,
                  td_exh,
                  ex_rate,
                  lic_price,
                  from_date,
                  TO_DATE,
                  rat_rate,
                  reg_code;
   END prc_lib_re_val_reversal;

--[Reversal report proc for export to excel]
--Dev2: Pure Finance :End
   PROCEDURE prc_lib_re_val_reversal_exl (
      i_chnl_comp_name    IN       fid_company.com_short_name%TYPE,
      i_lic_type          IN       fid_license.lic_type%TYPE,
      i_lee_short_name    IN       fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN       fid_license.lic_budget_code%TYPE,
      i_markup            IN       VARCHAR2,
      i_from_date         IN       DATE,
      i_to_date           IN       DATE,
      o_lib_rep           OUT      pkg_fin_mnet_lib_val_rep.c_fin_rep,
      i_lic_region        IN       VARCHAR2,
			i_acc_prv_rate      IN       VARCHAR2
   )
   AS
      l_qry            VARCHAR2 (3000);
      first_day        DATE;
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      v_go_live_date   DATE;
      v_lic_date       DATE;
   --Dev2: Pure Finance :End
   BEGIN
      --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
      SELECT content
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      --Dev2: Pure Finance :End
      SELECT (LAST_DAY (i_from_date) + 1)
        INTO v_lic_date
        FROM DUAL;

      DELETE FROM exl_inventory_for_reversal;

      COMMIT;

		IF i_acc_prv_rate = 'B' AND i_markup = 'I' AND i_to_date >= to_date('01-Jun-2016')
		THEN
			INSERT INTO exl_inventory_for_reversal
                  (b, com_number, lic_currency, lic_type, lee_short_name,
                   lic_budget_code, suppler, contract, lic_number, com_name,
                   gen_title, lic_acct_date, lic_start, lic_end,
                   lic_amort_code, lic_showing_int,
                   lic_showing_lic,
                   lic_markup_percent, lic_rate, ter_cur_code, td_exh,
									 reval, reval_loc, reval_exh_rate, lic_price
                                                 --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
                   , from_date, TO_DATE
                                       --Dev2: Pure Finance :End
                   , exchange_rate, region_code)
         SELECT   b, com_number, lic_currency, lic_type, lee_short_name,
                  lic_budget_code, supplier, con_short_name, lic_number,
                  com_name, gen_title, acct_date, lic_start, lic_end,
                  lic_amort_code, lic_showing_int,
                  --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                   --lic_showing_lic,
                   DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                   lic_markup_percent, lic_rate, ter_cur_code,
                   --td_exh,
                   DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                   --SIT.R5 : SVOD Enhancements : End
                   SUM (reval_mu) reval_mu,
                  SUM (reval_mu_loc) reval_mu_loc,
                  ROUND (DECODE (SUM (reval_mu),
                                 0, 0,
                                 SUM (reval_mu_loc) / SUM (reval_mu)
                                ),
                         5
                        ) rev_exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  lic_price, from_date, TO_DATE, rat_rate, reg_code
             FROM (SELECT   bfc.com_number b, afc.com_number com_number,
                            fl.lic_currency, fl.lic_type, flee.lee_short_name,
                            xfsl.lsl_lee_number, fl.lic_budget_code,
                            afc.com_short_name supplier, fcon.con_short_name,
                            fl.lic_number, bfc.com_name com_name,
                            TRIM (FG.GEN_TITLE) GEN_TITLE,
                            TO_CHAR (FL.LIC_ACCT_DATE, 'RRRR.MM') ACCT_DATE,
                            TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                            TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                            fl.lic_amort_code, fl.lic_showing_int,
                            fl.lic_showing_lic,
                            ROUND (fl.lic_markup_percent,
                                   4
                                  ) lic_markup_percent,
                            ROUND (fl.lic_rate, 5) lic_rate, ft.ter_cur_code   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                                                                            --[passing "lic_acct_date" to functions instead of "i_period_date" and lsl_number]
                            ,
                            0 td_exh,
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_rversal
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || flsl.lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    fl.lic_start,
                                    flsl.lis_ter_code
                                   ),
                                2
                               ) reval_mu,
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_rep_revel_rversal_loc
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || flsl.lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    fl.lic_start,
                                    flsl.lis_ter_code
                                   ),
                                2
                               ) reval_mu_loc,
                            ROUND (xfsl.lsl_lee_price, 4) lic_price,

                            --[changed from lic_price to LSL_LEE_PRICE ]
                            --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                            i_from_date from_date, i_to_date TO_DATE,
                            fr.reg_code,
                                        --Dev2: Pure Finance :end
                                        fer.rat_rate
                       FROM fid_general fg,
                            fid_company afc,
                            fid_company bfc,
                            fid_contract fcon,
                            fid_licensee flee,
                            fid_license_sub_ledger flsl,
                            --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                            x_fin_lic_sec_lee xfsl,
                            --Dev2: Pure Finance :END
                            fid_license fl,
                            fid_territory ft,
                            fid_region fr,
                            fid_exchange_rate fer,
                            (SELECT com_name, com_number, com_ter_code
                               FROM fid_company
                              WHERE com_short_name LIKE i_chnl_comp_name
                                AND com_type IN ('CC', 'BC')) x
                      WHERE flee.lee_cha_com_number = x.com_number
                        AND ft.ter_code LIKE x.com_ter_code
                        AND fl.lic_type LIKE i_lic_type
                        AND flee.lee_short_name LIKE i_lee_short_name
                        --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                        --  AND    lic_lee_number = lee_number
                        AND fl.lic_start >= v_go_live_date                -- 1
                        --AND lic_start <=
                        --     v_lic_date
                        --2 [ from period + 1st day of next mon should be on or after lic_strt ]
                        --Dev2: Pure Finance : End
                        AND fl.lic_budget_code LIKE i_lic_budget_code
                        AND fcon.con_number = fl.lic_con_number
                        AND afc.com_number = fcon.con_com_number
                        AND fg.gen_refno = fl.lic_gen_refno
                        AND (x.com_number = bfc.com_number)
                        --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                        --LIC_LEE_NUMBER = LEE_NUMBER and
                        AND fl.lic_number = xfsl.lsl_lic_number
                        AND flee.lee_number = xfsl.lsl_lee_number
                        AND flsl.lis_lic_number = fl.lic_number
                        AND flsl.lis_lsl_number = xfsl.lsl_number
                        --AND lee_split_region = reg_id
                        AND fr.reg_id(+) = flee.lee_split_region
                        --Dev2: Pure Finance :END
                        --Dev2: Pure Finance :Start:[Non Costed Fillers]_[ANUJASHINDE]_[2013/3/15]
                        --[Added to exclude(fillers) licenses with status F]
                        AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                        --Dev2: Pure Finance[Non Costed Fillers] :End
                        AND fr.reg_code LIKE i_lic_region
                        AND fer.rat_cur_code = fl.lic_currency
                        AND fer.rat_cur_code_2 = ft.ter_cur_code
						AND EXISTS (
                               SELECT 1
                                 FROM x_mv_subledger_data mvlsl
                                WHERE mvlsl.lis_lic_number = fl.lic_number
                                  AND mvlsl.lis_yyyymm_num >=
                                         TO_NUMBER (TO_CHAR (i_from_date,
                                                             'YYYYMM'
                                                            )
                                                   )
                                  AND mvlsl.lis_yyyymm_num <=
                                         TO_NUMBER (TO_CHAR (i_to_date,
                                                             'YYYYMM'
                                                            )
                                                   )
								  AND mvlsl.lis_reval_flag = 'RL')
                   ORDER BY fl.lic_currency,
                            fl.lic_type,
                            flee.lee_short_name,
                            fl.lic_budget_code,
                            afc.com_short_name,
                            fcon.con_short_name,
                            fg.gen_title,
                            fl.lic_number)
            WHERE 1 = 1
         GROUP BY b,
                  com_number,
                  lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  lic_number,
                  com_name,
                  gen_title,
                  acct_date,
                  lic_start,
                  lic_end,
                  lic_amort_code,
                  lic_showing_int,
                  lic_showing_lic,
                  lic_markup_percent,
                  lic_rate,
                  ter_cur_code,
                  td_exh,
                  lic_price,
                  from_date,
                  TO_DATE,
                  rat_rate,
                  reg_code;

      OPEN O_LIB_REP FOR
         SELECT com_name, lic_currency, TO_CHAR(from_date, 'DD-MON-RRRR') from_date,
                TO_CHAR(TO_DATE, 'DD-MON-RRRR') TO_DATE, ter_cur_code,
                exchange_rate, lic_type, lee_short_name, lic_budget_code,
                SUPPLER, CONTRACT "CONTRACT", LIC_NUMBER, GEN_TITLE,
                LIC_ACCT_DATE "ACCT_DATE"
                ,lic_start
                ,lic_end, lic_amort_code,
                lic_showing_int, lic_showing_lic, td_exh, lic_markup_percent,
                ob_markup "OB_MUP", reval "FEE", reval_exh_rate,
                reval_loc "ZAR FEES", COST "COST", cb_markup "CLOSE",
                lic_rate, cb_close "E_CLOSE", lic_price, region_code
           FROM exl_inventory_for_reversal;
		ELSE
			INSERT INTO exl_inventory_for_reversal
                  (b, com_number, lic_currency, lic_type, lee_short_name,
                   lic_budget_code, suppler, contract, lic_number, com_name,
                   gen_title, lic_acct_date, lic_start, lic_end,
                   lic_amort_code, lic_showing_int,
                   lic_showing_lic,
                   lic_markup_percent, lic_rate, ter_cur_code, td_exh,
                   ob_markup, reval, reval_loc, reval_exh_rate, COST,
                   cb_markup, cb_close, lic_price
                                                 --Dev2: Pure Finance :Start:[FIN 3,FIN 6,FIN 7 ]_[ANUJASHINDE]_[2013/3/21]
                   , from_date, TO_DATE
                                       --Dev2: Pure Finance :End
                   , exchange_rate, region_code)
         SELECT   b, com_number, lic_currency, lic_type, lee_short_name,
                  lic_budget_code, supplier, con_short_name, lic_number,
                  com_name, gen_title, acct_date, lic_start, lic_end,
                  lic_amort_code, lic_showing_int,
                  --SIT.R5 : SVOD Enhancements : Start : [ENH-SFIN01]_[Devashish Raverkar]_[2015/05/26]
                   --lic_showing_lic,
                   DECODE(lic_amort_code,'A',NULL,lic_showing_lic) lic_showing_lic,
                   lic_markup_percent, lic_rate, ter_cur_code,
                   --td_exh,
                   DECODE(lic_amort_code,'A',NULL,td_exh) td_exh,
                   --SIT.R5 : SVOD Enhancements : End
                  SUM (ob_mup) ob_mup, SUM (reval_mu) reval_mu,
                  SUM (reval_mu_loc) reval_mu_loc,
                  ROUND (DECODE (SUM (reval_mu),
                                 0, 0,
                                 SUM (reval_mu_loc) / SUM (reval_mu)
                                ),
                         5
                        ) rev_exh_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  SUM (cost_mu) cost_mu,
                  (SUM (ob_mup) + SUM (reval_mu) - SUM (cost_mu)) cbmp,
                  ((SUM (ob_mup) + SUM (reval_mu) - SUM (cost_mu)) * ex_rate
                  ) cb_final,
                  lic_price, from_date, TO_DATE, rat_rate, reg_code
             FROM (SELECT   bfc.com_number b, afc.com_number com_number,
                            fl.lic_currency, fl.lic_type, flee.lee_short_name,
                            xfsl.lsl_lee_number, fl.lic_budget_code,
                            afc.com_short_name supplier, fcon.con_short_name,
                            fl.lic_number, bfc.com_name com_name,
                            TRIM (FG.GEN_TITLE) GEN_TITLE,
                            TO_CHAR (FL.LIC_ACCT_DATE, 'RRRR.MM') ACCT_DATE,
                            TO_CHAR (fl.lic_start, 'DDMonYYYY') lic_start,
                            TO_CHAR (fl.lic_end, 'DDMonYYYY') lic_end,
                            fl.lic_amort_code, fl.lic_showing_int,
                            fl.lic_showing_lic,
                            ROUND (fl.lic_markup_percent,
                                   4
                                  ) lic_markup_percent,
                            ROUND (fl.lic_rate, 5) lic_rate, ft.ter_cur_code   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                                                                            --[passing "lic_acct_date" to functions instead of "i_period_date" and lsl_number]
                            ,
                            0 td_exh,
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.x_fun_fin_rep_ob_mp_rversal
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || flsl.lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    flsl.lis_ter_code
                                   ),
                                2
                               ) ob_mup,
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_revel_rversal
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || flsl.lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    fl.lic_start,
                                    flsl.lis_ter_code
                                   ),
                                2
                               ) reval_mu,
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_rep_revel_rversal_loc
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || flsl.lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    fl.lic_start,
                                    flsl.lis_ter_code
                                   ),
                                2
                               ) reval_mu_loc,
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_fin_mmt_rep_cost_reversal
                                   (fl.lic_number,
                                    xfsl.lsl_number,
                                    i_markup,
                                    fl.lic_start,
                                    TO_DATE
                                        (   '01'
                                         || LPAD (TO_CHAR (flsl.lis_per_month),
                                                  2,
                                                  '0'
                                                 )
                                         || flsl.lis_per_year,
                                         'DDMMYYYY'
                                        ),
                                    flsl.lis_ter_code
                                   ),
                                2
                               ) cost_mu,
                            ROUND
                               (pkg_fin_mnet_lib_val_rep.fun_inv_mmt_report_ex_rate_ex
                                                             (fl.lic_currency,
                                                              ft.ter_cur_code,
                                                              'P',
                                                              fl.lic_rate,
                                                              fl.lic_start,
                                                              v_go_live_date
                                                             ),
                                5
                               ) ex_rate,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                            ROUND (xfsl.lsl_lee_price, 4) lic_price,

                            --[changed from lic_price to LSL_LEE_PRICE ]
                            --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                            i_from_date from_date, i_to_date TO_DATE,
                            fr.reg_code,
                                        --Dev2: Pure Finance :end
                                        fer.rat_rate
                       FROM fid_general fg,
                            fid_company afc,
                            fid_company bfc,
                            fid_contract fcon,
                            fid_licensee flee,
                            fid_license_sub_ledger flsl,
                            --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                            x_fin_lic_sec_lee xfsl,
                            --Dev2: Pure Finance :END
                            fid_license fl,
                            fid_territory ft,
                            fid_region fr,
                            fid_exchange_rate fer,
                            (SELECT com_name, com_number, com_ter_code
                               FROM fid_company
                              WHERE com_short_name LIKE i_chnl_comp_name
                                AND com_type IN ('CC', 'BC')) x
                      WHERE flee.lee_cha_com_number = x.com_number
                        AND ft.ter_code LIKE x.com_ter_code
                        AND fl.lic_type LIKE i_lic_type
                        AND flee.lee_short_name LIKE i_lee_short_name
                        --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                        --  AND    lic_lee_number = lee_number
                        AND fl.lic_start >= v_go_live_date                -- 1
                        --AND lic_start <=
                        --     v_lic_date
                        --2 [ from period + 1st day of next mon should be on or after lic_strt ]
                        --Dev2: Pure Finance : End
                        AND fl.lic_budget_code LIKE i_lic_budget_code
                        AND fcon.con_number = fl.lic_con_number
                        AND afc.com_number = fcon.con_com_number
                        AND fg.gen_refno = fl.lic_gen_refno
                        AND (x.com_number = bfc.com_number)
                        --Dev2: Pure Finance :Start:[FIN 3]_[ANUJASHINDE]_[2013/3/5]
                        --LIC_LEE_NUMBER = LEE_NUMBER and
                        AND fl.lic_number = xfsl.lsl_lic_number
                        AND flee.lee_number = xfsl.lsl_lee_number
                        AND flsl.lis_lic_number = fl.lic_number
                        AND flsl.lis_lsl_number = xfsl.lsl_number
                        --AND lee_split_region = reg_id
                        AND fr.reg_id(+) = flee.lee_split_region
                        --Dev2: Pure Finance :END
                        --Dev2: Pure Finance :Start:[Non Costed Fillers]_[ANUJASHINDE]_[2013/3/15]
                        --[Added to exclude(fillers) licenses with status F]
                        AND UPPER (fl.lic_status) NOT IN ('F', 'T')
                        --Dev2: Pure Finance[Non Costed Fillers] :End
                        AND fr.reg_code LIKE i_lic_region
                        AND fer.rat_cur_code = fl.lic_currency
                        AND fer.rat_cur_code_2 = ft.ter_cur_code
						AND EXISTS (
                               SELECT 1
                                 FROM x_mv_subledger_data mvlsl
                                WHERE mvlsl.lis_lic_number = fl.lic_number
                                  AND mvlsl.lis_yyyymm_num >=
                                         TO_NUMBER (TO_CHAR (i_from_date,
                                                             'YYYYMM'
                                                            )
                                                   )
                                  AND mvlsl.lis_yyyymm_num <=
                                         TO_NUMBER (TO_CHAR (i_to_date,
                                                             'YYYYMM'
                                                            )
                                                   )
								  AND mvlsl.lis_reval_flag = 'RL')
                   ORDER BY fl.lic_currency,
                            fl.lic_type,
                            flee.lee_short_name,
                            fl.lic_budget_code,
                            afc.com_short_name,
                            fcon.con_short_name,
                            fg.gen_title,
                            fl.lic_number)
            WHERE 1 = 1
         GROUP BY b,
                  com_number,
                  lic_currency,
                  lic_type,
                  lee_short_name,
                  lic_budget_code,
                  supplier,
                  con_short_name,
                  lic_number,
                  com_name,
                  gen_title,
                  acct_date,
                  lic_start,
                  lic_end,
                  lic_amort_code,
                  lic_showing_int,
                  lic_showing_lic,
                  lic_markup_percent,
                  lic_rate,
                  ter_cur_code,
                  td_exh,
                  ex_rate,
                  lic_price,
                  from_date,
                  TO_DATE,
                  rat_rate,
                  reg_code;

      OPEN O_LIB_REP FOR
         SELECT com_name, lic_currency, TO_CHAR(from_date, 'DD-MON-RRRR') from_date,
                TO_CHAR(TO_DATE, 'DD-MON-RRRR') TO_DATE, ter_cur_code,
                exchange_rate, lic_type, lee_short_name, lic_budget_code,
                SUPPLER, CONTRACT "CONTRACT", LIC_NUMBER, GEN_TITLE,
                LIC_ACCT_DATE "ACCT_DATE"
                ,lic_start
                ,lic_end, lic_amort_code,
                lic_showing_int, lic_showing_lic, td_exh, lic_markup_percent,
                ob_markup "OB_MUP", reval "FEE", reval_exh_rate,
                reval_loc "ZAR FEES", COST "COST", cb_markup "CLOSE",
                lic_rate, cb_close "E_CLOSE", lic_price, region_code
           FROM exl_inventory_for_reversal;
		END IF;
   END prc_lib_re_val_reversal_exl;
--Dev2: Pure Finance :End
-------swapnil
FUNCTION x_func_get_costed_runs_end_of
(	i_lic_start date
	,i_go_live_date date
	,i_lis_lic_number	number
	,i_lic_catchup_flag   fid_license.lic_catchup_flag%type
)
RETURN NUMBER
AS
l_paid_count  number;
	BEGIN
	   IF i_lic_start <= i_go_live_date
	   THEN
			IF NVL(i_lic_catchup_flag,'N') ='N'
			THEN
					SELECT COUNT (*)
					INTO	  l_paid_count
					  FROM fid_schedule
					  WHERE sch_type = 'P'
					  AND sch_lic_number = i_lis_lic_number
					  AND sch_date <=
								 (  SELECT LAST_DAY (
											MAX (
											   TO_DATE (
													 lis_per_month
												  || '/'
												  || lis_per_year,
												  'mm/yyyy')))
									FROM fid_license_sub_ledger
								   WHERE lis_lic_number = i_lis_lic_number
								  );
			ELSE
				select count(distinct plt_sch_number)
				into   l_paid_count
				from   x_cp_play_list
				where  PLT_LIC_NUMBER= i_lis_lic_number
				and    plt_sch_type = 'P'
				and    plt_sch_start_date  <=
								 (  SELECT LAST_DAY (
											MAX (
											   TO_DATE (
													 lis_per_month
												  || '/'
												  || lis_per_year,
												  'mm/yyyy')))
									FROM fid_license_sub_ledger
								   WHERE lis_lic_number = i_lis_lic_number
								  );
			END IF;
		ELSE
				IF NVL(i_lic_catchup_flag,'N') ='N'
				THEN
							SELECT count(*)
						INTO   l_paid_count
						FROM x_fin_cost_schedules
						WHERE csh_lic_number=i_lis_lic_number
						AND  To_number(csh_year || Lpad(csh_month,2,0)) <=
						(
							select  To_number(Lis_per_year || Lpad(Lis_per_month,2,0))
							from
							(
							select lis_per_year,lis_per_month
							FROM fid_license_sub_ledger
							WHERE lis_lic_number = i_lis_lic_number
							order by lis_per_year,lis_per_month desc
							)
						where rownum < 2
						)  ;
				ELSE
						select count(distinct plt_sch_number)
						into   l_paid_count
						from   x_cp_play_list
						where  PLT_LIC_NUMBER= i_lis_lic_number
						and    plt_sch_type = 'P'
						and    plt_sch_start_date  <=
									 (  SELECT LAST_DAY (
												MAX (
												   TO_DATE (
														 lis_per_month
													  || '/'
													  || lis_per_year,
													  'mm/yyyy')))
										FROM fid_license_sub_ledger
									   WHERE lis_lic_number = i_lis_lic_number
									  );
				END IF;

        END IF;
	RETURN 	NVL(l_paid_count,0);
END;
-------swapnil
END PKG_FIN_MNET_LIB_VAL_REP;
/