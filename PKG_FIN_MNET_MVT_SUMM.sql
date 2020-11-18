CREATE OR REPLACE PACKAGE PKG_FIN_MNET_MVT_SUMM
AS
   /******************************************************************************
   NAME:       pkg_fin_mnet_out_summ
   PURPOSE:
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/29/2010             1. Created this package.
   ******************************************************************************/
   TYPE c_out_summ IS REF CURSOR;

   TYPE c_ex_rate IS REF CURSOR;

   PROCEDURE prc_out_summ (
      i_chnl_comp_name     IN       VARCHAR2,
      i_lic_type           IN       VARCHAR2,
      i_from_period        IN       DATE,
      i_to_period          IN       DATE,
      i_acct_prvlng_rate   IN       VARCHAR2,
      i_lee_region_id      IN       fid_region.reg_code%TYPE,
      -- added for split
      o_cur_data           OUT      pkg_fin_mnet_mvt_summ.c_out_summ
   );

   PROCEDURE prc_ex_rate (
      i_chnl_comp_name   IN       VARCHAR2,
      o_ex_rate          OUT      pkg_fin_mnet_mvt_summ.c_ex_rate
   );

   PROCEDURE prc_fin_moment_rep_mmt (
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_from_period        IN       DATE,
      i_to_period          IN       DATE,
      i_acct_prvlng_rate   IN       CHAR,
      i_lee_region_id      IN       fid_region.reg_code%TYPE,
      o_lib_rep            OUT      pkg_fin_mnet_mvt_summ.c_out_summ
   );

   FUNCTION sch_paid (
      i_lic_currency      IN   fid_license.lic_currency%TYPE,
      i_lic_type          IN   fid_license.lic_type%TYPE,
      i_lee_short_name    IN   fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN   fid_license.lic_budget_code%TYPE,
      i_from_period       IN   DATE,
      i_to_period         IN   DATE,
      i_lee_region_id     IN   fid_region.reg_code%TYPE
   )
      RETURN NUMBER;

   FUNCTION sch_paid_summ (
      i_lic_number    IN   fid_license.lic_number%TYPE,
      i_period_date   IN   DATE
   )
      RETURN NUMBER;
    
   PROCEDURE prc_out_summ_exc (
      i_chnl_comp_name     IN       VARCHAR2,
      i_lic_type           IN       VARCHAR2,
      i_from_period        IN       DATE,
      i_to_period          IN       DATE,
      i_acct_prvlng_rate   IN       VARCHAR2,
      i_lee_region_id      IN       fid_region.reg_code%TYPE,
      -- added for split
      o_cur_data           OUT      pkg_fin_mnet_mvt_summ.c_out_summ
   );
  
   PROCEDURE prc_fin_moment_rep_mmt_exc (
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_from_period        IN       DATE,
      i_to_period          IN       DATE,
      i_acct_prvlng_rate   IN       CHAR,
      i_lee_region_id      IN       fid_region.reg_code%TYPE,
      o_lib_rep            OUT      pkg_fin_mnet_mvt_summ.c_out_summ
   );
   
END pkg_fin_mnet_mvt_summ;
/
CREATE OR REPLACE PACKAGE BODY PKG_FIN_MNET_MVT_SUMM
AS
   /******************************************************************************
   NAME:       pkg_fin_mnet_mvt_summ
   PURPOSE:
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/29/2010             1. Created this package.
   ******************************************************************************/
   PROCEDURE prc_out_summ (
      i_chnl_comp_name     IN       VARCHAR2,
      i_lic_type           IN       VARCHAR2,
      i_from_period        IN       DATE,
      i_to_period          IN       DATE,
      i_acct_prvlng_rate   IN       VARCHAR2,
      i_lee_region_id      IN       fid_region.reg_code%TYPE,
      -- added for split
      o_cur_data           OUT      pkg_fin_mnet_mvt_summ.c_out_summ
   )
   AS
      o_query_string   VARCHAR2 (5000);
      l_start          DATE;
      l_end            DATE;
      v_go_live_date   DATE;
   BEGIN
      SELECT TRUNC (TO_DATE (i_from_period)), TRUNC (LAST_DAY (i_to_period))
        INTO l_start, l_end
        FROM DUAL;

      IF i_acct_prvlng_rate = 'A'
      THEN
         --Commented By Karim
         --OPEN o_cur_data FOR
         --Commented By Karim
         /*SELECT   com_name,                                  --com_number,
         lic_currency, lic_type, lee_short_name,
         lic_budget_code, ter_cur_code,
         ROUND (SUM (lisconfcmu), 2) lisconfcmu,
         ROUND (SUM (lisconfce), 2) lisconfce,
         ROUND (SUM (lisconaae), 2) lisconaae,
         ROUND (SUM (lisconaamu), 2) lisconaamu,
         ROUND (SUM (lisconfci), 2) lisconfci,
         ROUND (SUM (lisconaai), 2) lisconaai,
         ROUND (SUM (lislocfce), 2) lislocfce,
         ROUND (SUM (lislocaae), 2) lislocaae,
         ROUND (SUM (lislocfcmu), 2) lislocfcmu,
         ROUND (SUM (lislocaamu), 2) lislocaamu,
         ROUND (SUM (con_fci_fce), 2) con_fci_fce,
         ROUND (SUM (con_aai_aae), 2) con_aai_aae,
         --sum(lisconfceP),sum(lisconfcmuP),sum(lisconaaeP),sum(lisconaamuP),
         SUM (sch_paid_is) showings
         FROM (SELECT lic_number,
         (SELECT SUM (sch_paid)
         FROM fid_sch_summary_vw
         WHERE    TO_CHAR (sch_year)
         || TO_CHAR (sch_month, '09') <=
         TO_CHAR (l_start, 'YYYYMM')
         AND sch_lic_number = lic_number) sch_paid_is,
         com_name, com_number, lic_currency, ter_cur_code,
         lic_type, lee_short_name, lic_budget_code,
         rat_rate, lisconfcmu, lisconfce, lisconaae,
         lisconaamu, lisconfci, lisconaai, lislocfce,
         lislocaae, lislocfcmu, lislocaamu,
         lisconfci - lisconfce con_fci_fce,
         (lisconaai - lisconaae) con_aai_aae,
         ROUND (lisconfce * rat_rate, 2) lisconfcep,
         ROUND (lisconfcmu * rat_rate, 2) lisconfcmup,
         ROUND (lisconaae * rat_rate, 2) lisconaaep,
         ROUND (lisconaamu * rat_rate, 2) lisconaamup
         FROM (SELECT lic_number, a.com_number, a.com_name,
         lic_currency, lic_type, lee_short_name,
         lic_budget_code,
         NVL (rat_rate, 0) rat_rate, ter_cur_code,
         reg_code
         FROM fid_company a,
         fid_licensee,
         fid_license,
         fid_territory,
         fid_exchange_rate,
         fid_region             -- added for split
         WHERE a.com_short_name LIKE i_chnl_comp_name
         AND a.com_type IN ('BC', 'CC')
         AND ter_code = a.com_ter_code
         AND rat_cur_code = lic_currency
         AND rat_cur_code_2(+) = ter_cur_code
         -- split
         AND lee_region_id = reg_id
         AND reg_code LIKE i_lee_region_id
         AND (    lee_cha_com_number = a.com_number
         AND lic_type LIKE i_lic_type
         AND lic_lee_number = lee_number
         AND (   EXISTS (
         SELECT   'X',
         SUM
         (TO_NUMBER
         (  lis_con_forecast
         - (  lis_con_actual
         + lis_con_adjust
         )
         )
         )
         FROM fid_license_sub_ledger
         WHERE lis_lic_number =
         lic_number
         AND TO_CHAR
         (   lis_per_year
         || LPAD
         (lis_per_month,
         2,
         0
         )
         ) <=
         TO_CHAR (l_start,
         'YYYYMM'
         )
         GROUP BY 'X'
         HAVING ROUND
         (SUM
         (TO_NUMBER
         (  lis_con_forecast
         - (  lis_con_actual
         + lis_con_adjust
         )
         )
         ),
         0
         ) != 0)
         OR (    lic_acct_date <= l_end
         AND lic_end > l_end
         )
         )
         )),
         (SELECT   SUM (lis_con_fc_mu) lisconfcmu,
         SUM (lis_con_fc_emu) lisconfce,
         SUM (lis_con_aa_emu) lisconaae,
         SUM (lis_con_aa_mu) lisconaamu,
         SUM (lis_con_fc_imu) lisconfci,
         SUM (lis_con_aa_imu) lisconaai,
         SUM (lis_loc_fc_emu) lislocfce,
         SUM (lis_loc_aa_emu) lislocaae,
         SUM (lis_loc_fc_mu) lislocfcmu,
         SUM (lis_loc_aa_mu) lislocaamu,
         lis_lic_number
         FROM fid_lis_vw
         WHERE (   lis_per_year
         || LPAD (lis_per_month, 2, 0) <=
         TO_NUMBER (TO_CHAR (l_start,
         'YYYYMM'
         )
         )
         )
         GROUP BY lis_lic_number) b
         WHERE lis_lic_number = lic_number)
         GROUP BY com_number,
         com_name,
         ter_cur_code,
         lic_currency,
         lic_type,
         lee_short_name,
         lic_budget_code
         ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;*/
         NULL;
      ELSE
         OPEN o_cur_data FOR
            SELECT   com_name,                                  --com_number,
                              lic_currency, ter_cur_code, lic_type,
                     lee_short_name, lic_budget_code,

                     -- SUM (lisconfcmu) lisconfcmu,
                     ROUND (SUM (lisconfce), 2) lisconfce,
                     ROUND (SUM (lisconaae), 2) lisconaae,
                     ROUND (SUM (lisconaai), 2) lisconaai,
                     ROUND (SUM (lisconfci), 2) lisconfci,
                     ROUND (SUM (con_fci_fce), 2) con_fci_fce,
                     ROUND (SUM (con_aai_aae), 2) con_aai_aae,
                     ROUND (SUM (lislocfcep), 2) lislocfce,
                     ROUND (SUM (lislocfcmup), 2) lislocfcmu,
                     ROUND (SUM (lislocaaep), 2) lislocaae,
                     ROUND (SUM (lislocaamup), 2) lislocaamu,
                                                             /*SUM (sch_paid_is)*/
                     0 showings
                FROM (SELECT lic_number, ter_cur_code,
                                                      /*(SELECT SUM (sch_paid)
                                                      FROM fid_sch_summary_vw
                                                      WHERE  TO_CHAR (sch_year)||TO_CHAR (sch_month, '09') <= TO_CHAR (l_start, 'YYYYMM')
                                                      AND sch_lic_number = lic_number) sch_paid_is,*/
                                                      com_name, com_number,
                             lic_currency, lic_type, lee_short_name,
                             lic_budget_code, rat_rate, lisconfcmu, lisconfce,
                             lisconaae, lisconaamu, lisconfci, lisconaai,
                             lisconfci - lisconfce con_fci_fce,
                             (lisconaai - lisconaae) con_aai_aae,
                             ROUND (lisconfce * rat_rate, 2) lislocfcep,
                             ROUND (lisconfcmu * rat_rate, 2) lislocfcmup,
                             ROUND (lisconaae * rat_rate, 2) lislocaaep,
                             ROUND (lisconaamu * rat_rate, 2) lislocaamup
                        FROM (SELECT fl.lic_number, fc.com_number,
                                     fc.com_name, fl.lic_currency,
                                     fl.lic_type, flee.lee_short_name,
                                     ft.ter_cur_code, fl.lic_budget_code,
                                     NVL (fer.rat_rate, 0) rat_rate
                                FROM fid_company fc,
                                     fid_licensee flee,
                                     fid_license fl,
                                     fid_territory ft,
                                     fid_exchange_rate fer,
                                     fid_region fr          -- added for split
                               WHERE fc.com_short_name LIKE i_chnl_comp_name
                                 AND fc.com_type IN ('BC', 'CC')
                                 AND ft.ter_code = fc.com_ter_code
                                 AND fer.rat_cur_code = fl.lic_currency
                                 AND fer.rat_cur_code_2(+) = ft.ter_cur_code
                                 --Dev.R3: Start: Placeholder_[Devashish Raverkar]_[27-03-2014]
                                 AND fl.lic_status <> 'T'
                                 --Dev.R3: End:
                                 AND fl.lic_start < (SELECT content
                                                       FROM x_fin_configs
                                                      WHERE ID = 1)
                                 -- split
                                 AND flee.lee_region_id = fr.reg_id
                                 AND fr.reg_code LIKE i_lee_region_id
                                 AND (    flee.lee_cha_com_number =
                                                                 fc.com_number
                                      AND fl.lic_type LIKE i_lic_type
                                      AND fl.lic_lee_number = flee.lee_number
                                      AND (   EXISTS (
                                                 /*
                                                 SELECT   'X',
                                                 SUM
                                                 (TO_NUMBER
                                                 (  lis_con_forecast
                                                 - (  lis_con_actual
                                                 + lis_con_adjust
                                                 )
                                                 )
                                                 )
                                                 FROM fid_license_sub_ledger
                                                 WHERE lis_lic_number =
                                                 lic_number
                                                 AND TO_CHAR
                                                 (   lis_per_year
                                                 || LPAD
                                                 (lis_per_month,
                                                 2,
                                                 0
                                                 )
                                                 ) <=
                                                 TO_CHAR (l_start,
                                                 'YYYYMM'
                                                 )
                                                 group by 'X'
                                                 HAVING (ROUND
                                                 (SUM
                                                 (TO_NUMBER
                                                 (  lis_con_forecast
                                                 - (  lis_con_actual
                                                 + lis_con_adjust
                                                 )
                                                 )
                                                 ),
                                                 0
                                                 ) != 0) /*OR
                                                 (ROUND
                                                 (SUM
                                                 (TO_NUMBER
                                                 (  lis_loc_forecast
                                                 - (  lis_loc_actual
                                                 + lis_loc_adjust
                                                 )
                                                 )
                                                 ),
                                                 0
                                                 ) != 0)*/
                                                 SELECT   'X',
                                                          SUM
                                                             (slx.cf_m_ca_p_cadj
                                                             )
                                                     FROM x_mv_movement_sum_ex_1 slx
                                                    WHERE slx.lis_lic_number =
                                                                 fl.lic_number
                                                      AND slx.lis_yyyymm_num <=
                                                             TO_NUMBER
                                                                (TO_CHAR
                                                                     (l_start,
                                                                      'YYYYMM'
                                                                     )
                                                                )
                                                 GROUP BY 'X'
                                                   HAVING ROUND
                                                             (SUM
                                                                 (slx.cf_m_ca_p_cadj
                                                                 ),
                                                              0
                                                             ) != 0)
                                           OR (    fl.lic_acct_date <= l_end
                                               AND fl.lic_end > l_end
                                              )
                                          )
                                     )),
                             (
                              /*
                              SELECT   SUM (lis_con_fc_mu) lisconfcmu,
                              SUM (lis_con_fc_emu) lisconfce,
                              SUM (lis_con_aa_emu) lisconaae,
                              SUM (lis_con_aa_mu) lisconaamu,
                              SUM (lis_con_fc_imu) lisconfci,
                              SUM (lis_con_aa_imu) lisconaai,
                              lis_lic_number
                              FROM FID_LIS_VW_FMSUM
                              WHERE (   lis_per_year
                              || LPAD (lis_per_month, 2, 0) <=
                              TO_NUMBER (TO_CHAR (l_start,
                              'YYYYMM'
                              )
                              )
                              )
                              GROUP BY lis_lic_number */
                              SELECT   SUM (lisconfcmu) AS lisconfcmu,
                                       SUM (lisconfce) AS lisconfce,
                                       SUM (lisconaae) AS lisconaae,
                                       SUM (lisconaamu) AS lisconaamu,
                                       SUM (lisconfci) AS lisconfci,
                                       SUM (lisconaai) AS lisconaai,
                                       lis_lic_number
                                  FROM x_mv_fid_lis_fmsum
                                 WHERE (lis_yyyymm_num <=
                                           TO_NUMBER (TO_CHAR (l_start,
                                                               'YYYYMM'
                                                              )
                                                     )
                                       )
                              GROUP BY lis_lic_number) b
                       WHERE b.lis_lic_number = lic_number
                      UNION
                      SELECT lic_number, ter_cur_code,
                                                      /*(SELECT SUM (sch_paid)
                                                      FROM fid_sch_summary_vw
                                                      WHERE    TO_CHAR (sch_year)
                                                      || TO_CHAR (sch_month, '09') <=
                                                      TO_CHAR (l_start, 'YYYYMM')
                                                      AND sch_lic_number = lic_number) sch_paid_is,*/
                                                      com_name, com_number,
                             lic_currency, lic_type, lee_short_name,
                             lic_budget_code, rat_rate, lisconfcmu, lisconfce,
                             lisconaae, lisconaamu, lisconfci, lisconaai,
                             lisconfci - lisconfce con_fci_fce,
                             (lisconaai - lisconaae) con_aai_aae,
                             ROUND (lislocfce, 2) lislocfce,
                             ROUND (lislocfcmu, 2) lislocfcmu,
                             ROUND (lislocaae, 2) lislocaae,
                             ROUND (lislocaamu, 2) lislocaamu
                        FROM (SELECT fl.lic_number, fc.com_number,
                                     fc.com_name, fl.lic_currency,
                                     fl.lic_type, flee.lee_short_name,
                                     ft.ter_cur_code, fl.lic_budget_code,
                                     NVL (fer.rat_rate, 0) rat_rate,
                                     xfsl.lsl_number
                                FROM fid_company fc,
                                     fid_licensee flee,
                                     fid_license fl,
                                     fid_territory ft,
                                     fid_exchange_rate fer,
                                     fid_region fr,
                                     x_fin_lic_sec_lee xfsl
                               WHERE fc.com_short_name LIKE i_chnl_comp_name
                                 AND fc.com_type IN ('BC', 'CC')
                                 AND ft.ter_code = fc.com_ter_code
                                 AND fer.rat_cur_code = fl.lic_currency
                                 --Dev.R3: Start: Placeholder_[Devashish Raverkar]_[27-03-2014]
                                 AND fl.lic_status <>
                                        'T'
                                           -- Alias for Finance Report Rewrite
                                 --Dev.R3: End:
                                 AND fer.rat_cur_code_2(+) = ft.ter_cur_code
                                 AND fl.lic_start >= (SELECT content
                                                        FROM x_fin_configs
                                                       WHERE ID = 1)
                                 AND flee.lee_split_region =
                                              fr.reg_id(+)
                                                 -- AND lee_region_id = reg_id
                                 AND fr.reg_code LIKE i_lee_region_id
----------------------------------------------
                                 AND fl.lic_number = xfsl.lsl_lic_number
                                 AND flee.lee_number = xfsl.lsl_lee_number
-------------------------------------------------
                                 AND (    flee.lee_cha_com_number =
                                                                 fc.com_number
                                      AND fl.lic_type LIKE i_lic_type
                                      ---commented----AND lic_lee_number = lee_number
                                      AND (   EXISTS (
                                                 SELECT   'X',
                                                          SUM (cf_m_ca_p_cadj),
                                                          SUM (lf_m_la_p_ladj)
                                                     FROM x_mv_movement_sum_ex_2 f1
                                                    WHERE f1.lis_lic_number =
                                                                 fl.lic_number
                                                      AND f1.lis_lsl_number =
                                                               xfsl.lsl_number
                                                      AND f1.lis_yyyymm_num <=
                                                             TO_NUMBER
                                                                (TO_CHAR
                                                                     (l_start,
                                                                      'YYYYMM'
                                                                     )
                                                                )
                                                 GROUP BY 'X'
                                                   HAVING (ROUND
                                                              (SUM
                                                                  (f1.cf_m_ca_p_cadj
                                                                  ),
                                                               0
                                                              ) != 0
                                                          )
                                                       OR (ROUND
                                                              (SUM
                                                                  (f1.lf_m_la_p_ladj
                                                                  ),
                                                               0
                                                              ) != 0
                                                          ))
                                           OR (    fl.lic_acct_date <= l_end
                                               AND fl.lic_end > l_end
                                              )
                                          )
                                     )),
                             (
                              /*
                              SELECT   SUM (lis_con_fc_mu) lisconfcmu,
                              SUM (lis_con_fc_emu) lisconfce,
                              SUM (lis_con_aa_emu) lisconaae,
                              SUM (lis_con_aa_mu) lisconaamu,
                              SUM (lis_con_fc_imu) lisconfci,
                              SUM (lis_con_aa_imu) lisconaai,
                              SUM (lis_loc_fc_emu) lislocfce,
                              SUM (lis_loc_aa_emu) lislocaae,
                              SUM (lis_loc_fc_mu) lislocfcmu,
                              sum (lis_loc_aa_mu) lislocaamu,
                              lis_lic_number,
                              lis_lsl_number
                              FROM FID_LIS_VW_FMSUM_NEW
                              WHERE (   lis_per_year
                              || LPAD (lis_per_month, 2, 0) <=
                              TO_NUMBER (TO_CHAR (l_start,
                              'YYYYMM'
                              )
                              )
                              )
                              group by lis_lic_number,lis_lsl_number */
                              SELECT   SUM (lisconfcmu) AS lisconfcmu,
                                       SUM (lisconfce) AS lisconfce,
                                       SUM (lisconaae) AS lisconaae,
                                       SUM (lisconaamu) AS lisconaamu,
                                       SUM (lisconfci) AS lisconfci,
                                       SUM (lisconaai) AS lisconaai,
                                       SUM (ROUND (lislocfce, 2))
                                                                 AS lislocfce,
                                       SUM (lislocaae) AS lislocaae,
                                       SUM (lislocfcmu) AS lislocfcmu,
                                       SUM (lislocaamu) AS lislocaamu,
                                       lis_lic_number, lis_lsl_number
                                  FROM x_mv_fid_lis_fmsum_new flmvn
                                 WHERE (flmvn.lis_yyyymm_num <=
                                           TO_NUMBER (TO_CHAR (l_start,
                                                               'YYYYMM'
                                                              )
                                                     )
                                       )
                              GROUP BY flmvn.lis_lic_number,
                                       flmvn.lis_lsl_number) b
                       WHERE b.lis_lic_number = lic_number
                         AND b.lis_lsl_number = lsl_number)
            GROUP BY com_number,
                     com_name,
                     lic_currency,
                     ter_cur_code,
                     lic_type,
                     lee_short_name,
                     lic_budget_code
            ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;
      END IF;
   END prc_out_summ;

   PROCEDURE prc_ex_rate (
      i_chnl_comp_name   IN       VARCHAR2,
      o_ex_rate          OUT      pkg_fin_mnet_mvt_summ.c_ex_rate
   )
   AS
   BEGIN
      OPEN o_ex_rate FOR
         SELECT com_short_name, rat_cur_code, com_ter_code,
                NVL (rat_rate, 0) ex_rate
           FROM fid_exchange_rate fer, fid_company fc
          WHERE fc.com_ter_code = fer.rat_cur_code_2(+)
            AND fc.com_type IN ('BC', 'CC')
            AND fc.com_short_name = i_chnl_comp_name;
   END prc_ex_rate;

   PROCEDURE prc_fin_moment_rep_mmt (
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_from_period        IN       DATE,
      i_to_period          IN       DATE,
      i_acct_prvlng_rate   IN       CHAR,
      i_lee_region_id      IN       fid_region.reg_code%TYPE,
      o_lib_rep            OUT      pkg_fin_mnet_mvt_summ.c_out_summ
   )
   AS
      l_month                NUMBER;
      l_year                 NUMBER;
      v_frm_per_yyyymm_num   NUMBER (6)
                             := TO_NUMBER (TO_CHAR (i_from_period, 'YYYYMM'));
      v_to_per_yyyymm_num    NUMBER (6)
                               := TO_NUMBER (TO_CHAR (i_to_period, 'YYYYMM'));
      v_go_live_date         DATE;
   BEGIN
      /*SELECT TO_CHAR (TO_DATE (i_period_date, 'DD-MON-YYYY'), 'YYYY')
      INTO l_year
      FROM DUAL;
      DBMS_OUTPUT.put_line ('year -->' || l_year);
      SELECT TO_CHAR (TO_DATE (i_period_date, 'DD-MON-YYYY'), 'MM')
      into l_month
      from dual;*/
      DBMS_OUTPUT.put_line ('month -->' || l_month);

      ---Dev2:Pure Finance:Start:[Hari Mandal]_[02/05/2013]
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      ---Dev2:Pure Finance:End--------------
      IF (UPPER (i_acct_prvlng_rate) = 'A')
      THEN
         /*SELECT   lee_cha_com_number, lic_currency, lic_type,
         lee_short_name, lic_budget_code, y.com_name chnl_comp,
         y.ter_cur_code, SUM (lis_con_fc_emu) lisconfce,      --1
         SUM (lis_con_aa_emu) lisconaae,
         -- 3 Costs Exc M/U (param ='A')
         SUM (lis_con_fc_imu) lisconfci,                     -- 5
         SUM (lis_con_aa_imu) lisconaai,                     -- 6
         SUM (lis_loc_fc_emu) lislocfce,
         -- 7 Asset Exc M/U (param ='A')
         SUM (lis_loc_aa_emu) lislocaae,                     -- 9
         SUM (lis_loc_fc_mu) lislocfcmu,
         --  8 Markup on Assset (param ='A')
         SUM (lis_loc_aa_mu) lislocaamu,
         -- 10 Markup on Cost  (param ='A')
         /* --sum(lis_con_fc_emu)*rat_rate lislopfce,
         --sum(lis_con_aa_emu)*rat_rate lislopaae,
         --sum(lis_con_fc_mu)*rat_rate lislopfcmu,
         -- sum(lis_con_aa_mu)*rat_rate lislopaamu,
         ROUND (SUM (lis_con_fc_imu), 2)
         - ROUND (SUM (lis_con_fc_emu), 2) con_fci_fce,
         -- 2 Markup on Asset
         ROUND (SUM (lis_con_aa_imu), 2)
         - ROUND (SUM (lis_con_aa_emu), 2) con_aai_aae,
         -- 4 Markup on Costs
         sch_paid (lic_currency,
         lic_type,
         lee_short_name,
         lic_budget_code,
         l_year
         ) exh
         FROM fid_licensee,
         fid_license,
         fid_lis_vw,
         fid_exchange_rate,
         (SELECT com_name, com_number, ter_cur_code
         FROM fid_company, fid_territory
         WHERE com_short_name LIKE i_chnl_comp_name
         AND com_type IN ('BC', 'CC')
         AND ter_code = com_ter_code) y
         WHERE lic_type LIKE i_lic_type
         AND lic_lee_number = lee_number
         AND lic_number = lis_lic_number
         AND lis_per_year = l_year
         --TO_NUMBER(TO_CHAR(:PARAM4,'YYYY'))
         AND lis_per_month = l_month
         --TO_NUMBER(TO_CHAR(:PARAM4,'MM'))
         AND rat_cur_code = lic_currency
         AND rat_cur_code_2 = y.ter_cur_code
         --    and rownum<=20
         GROUP BY lee_cha_com_number,
         lic_currency,
         lic_type,
         lee_short_name,
         lic_budget_code,
         y.com_name,
         y.ter_cur_code,
         sch_paid (lic_currency,
         lic_type,
         lee_short_name,
         lic_budget_code,
         l_year
         )
         ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;*/
         OPEN o_lib_rep FOR
            SELECT   chnl_comp, lee_cha_com_number, lic_currency, lic_type,
                     lee_short_name, lic_budget_code, ter_cur_code,
                     ROUND (lisconfce, 2) lisconfce,
                     ROUND (lisconaae, 2) lisconaae,
                     ROUND (lisconfci, 2) lisconfci,
                     ROUND (lisconaai, 2) lisconaai,
                     ROUND (lislocfce, 2) lislocfce,
                     ROUND (lislocaae, 2) lislocaae,
                     ROUND (lislocfcmu, 2) lislocfcmu,
                     ROUND (lislocaamu, 2) lislocaamu,
                     ROUND (con_fci_fce, 2) con_fci_fce,
                     ROUND (con_aai_aae, 2) con_aai_aae,
                     pkg_fin_mnet_mvt_summ.sch_paid (lic_currency,
                                                     lic_type,
                                                     lee_short_name,
                                                     lic_budget_code,
                                                     i_from_period,
                                                     i_to_period,
                                                     i_lee_region_id
                                                    ) exh
                FROM (SELECT   fc.com_name chnl_comp, flee.lee_cha_com_number,
                               fl.lic_currency, fl.lic_type,
                               flee.lee_short_name, fl.lic_budget_code,
                               ft.ter_cur_code,
                               SUM (mv.lis_con_fc_emu_nw) lisconfce,
                               SUM (mv.lis_con_aa_emu_23) lisconaae,
                               SUM (mv.lis_con_fc_imu) lisconfci,
                               SUM (mv.lis_con_aa_imu_23) lisconaai,
                               SUM (mv.lis_loc_fc_emu_23) lislocfce,
                               SUM (mv.lis_loc_aa_emu) lislocaae,
                               SUM (mv.lis_loc_fc_mu_3) lislocfcmu,
                               SUM (mv.lis_loc_aa_mu_3) lislocaamu,
                               (  SUM (ROUND (mv.lis_con_fc_imu, 2))
                                - SUM (mv.lis_con_fc_emu_nw)
                               ) con_fci_fce,

                                 -- 2 Markup on Asset
                                 SUM (mv.lis_con_aa_imu_23)
                               - SUM (mv.lis_con_aa_emu_23) con_aai_aae
                          --SUM (lis_con_fc_emu) * rat_rate lislopfce,
                          --SUM (lis_con_aa_emu) * rat_rate lislopaae,
                          --SUM (lis_con_fc_mu) * rat_rate lislopfcmu,
                          --SUM (lis_con_aa_mu) * rat_rate lislopaamu,
                          --SUM (sch_paid) exh
                      FROM     fid_company fc,
                               fid_territory ft,
                               fid_licensee flee,
                               fid_license fl,
                               --fid_lis_vw,
                               x_mv_subledger_data mv,
                               --fid_sch_summary_vw,
                               fid_exchange_rate fer,
                               fid_region fr,               -- added for split
                               x_fin_lic_sec_lee xfsl
                         WHERE fc.com_short_name LIKE i_chnl_comp_name
                           AND fc.com_type IN ('BC', 'CC')
                           AND ft.ter_code = fc.com_ter_code
                           AND fl.lic_type LIKE i_lic_type
                           ---Dev2:Pure Finance:Start:[Hari mandal]_[30/4/2013]
                           --AND lic_lee_number = lee_number
                           AND fl.lic_number = xfsl.lsl_lic_number
                           AND flee.lee_number = xfsl.lsl_lee_number
                           AND flee.lee_split_region = reg_id(+)
                           AND fl.lic_status NOT IN ('F', 'T')
                           ---Dev2:Pure Finance:End---------------------------
                           AND fl.lic_number = mv.lis_lic_number
                           -----added on 28-jun-2013
                           AND xfsl.lsl_number = mv.lis_lsl_number
                           -----
                           AND flee.lee_cha_com_number = fc.com_number
                           --and lis_per_year || lpad (lis_per_month, 2, 0) between to_number (to_char (i_from_period,'YYYYMM')) AND TO_NUMBER (TO_CHAR (i_to_period,'YYYYMM'))
                           AND (    mv.lis_yyyymm_num >= v_frm_per_yyyymm_num
                                AND mv.lis_yyyymm_num <= v_to_per_yyyymm_num
                               )
                           --AND sch_year || LPAD (sch_month, 2, 0) = TO_NUMBER (TO_CHAR (:i_period_date, 'YYYYMM'))
                           --AND sch_lic_number = lic_number
                           AND fer.rat_cur_code = fl.lic_currency
                           AND fer.rat_cur_code_2(+) = ft.ter_cur_code
                           AND UPPER (fr.reg_code) LIKE
                                                       UPPER (i_lee_region_id)
                      --AND lee_region_id = reg_id
                      --AND ROWNUM < 100000
                      GROUP BY fc.com_name,
                               flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               ft.ter_cur_code)
            ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;
      /* SELECT   com_name chnl_comp, lee_cha_com_number, lic_currency,
      lic_type, lee_short_name, lic_budget_code, ter_cur_code,
      SUM (lis_con_fc_emu) lisconfce,
      SUM (lis_con_aa_emu) lisconaae,
      SUM (lis_con_fc_imu) lisconfci,
      SUM (lis_con_aa_imu) lisconaai,
      SUM (lis_loc_fc_emu) lislocfce,
      SUM (lis_loc_aa_emu) lislocaae,
      SUM (lis_loc_fc_mu) lislocfcmu,
      SUM (lis_loc_aa_mu) lislocaamu,
      (SUM (lis_con_fc_imu) - SUM (lis_con_fc_emu)
      ) con_fci_fce,
      -- 2 Markup on Asset
      SUM (lis_con_aa_imu) - SUM (lis_con_aa_emu) con_aai_aae,
      -- SUM (lis_con_fc_emu) * rat_rate lislopfce,
      --SUM (lis_con_aa_emu) * rat_rate lislopaae,
      --SUM (lis_con_fc_mu) * rat_rate lislopfcmu,
      --SUM (lis_con_aa_mu) * rat_rate lislopaamu,
      SUM (sch_paid) exh
      FROM fid_company fc,
      fid_territory,
      fid_licensee,
      fid_license,
      fid_lis_vw,
      fid_sch_summary_vw,
      fid_exchange_rate
      WHERE fc.com_short_name LIKE i_chnl_comp_name
      AND fc.com_type IN ('BC', 'CC')
      AND ter_code = fc.com_ter_code
      AND lic_type LIKE i_lic_type
      AND lic_lee_number = lee_number
      AND lic_number = lis_lic_number
      AND lee_cha_com_number = fc.com_number
      AND lis_per_year =
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYY'))
      AND lis_per_month = TO_NUMBER (TO_CHAR (i_period_date, 'MM'))
      AND sch_year || LPAD (sch_month, 2, 0) =
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
      AND sch_lic_number = lic_number
      AND rat_cur_code = lic_currency
      AND rat_cur_code_2(+) = ter_cur_code
      AND ROWNUM < 100000
      GROUP BY com_name,
      ter_cur_code,
      rat_rate,
      lic_currency,
      lic_type,
      lee_short_name,
      lic_budget_code,
      lee_cha_com_number
      ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;*/
      END IF;

      IF (UPPER (i_acct_prvlng_rate) = 'P')
      THEN
         /*OPEN o_lib_rep FOR
         SELECT   lee_cha_com_number, lic_currency, lic_type,
         lee_short_name, lic_budget_code, y.com_name chnl_comp,
         y.ter_cur_code, SUM (lis_con_fc_emu) lisconfce,      --1
         SUM (lis_con_aa_emu) lisconaae,
         -- 3 Costs Exc M/U (param ='A')
         SUM (lis_con_fc_imu) lisconfci,                     -- 5
         SUM (lis_con_aa_imu) lisconaai,                     -- 6
         /*   --   sum(lis_loc_fc_emu) lislocfce, -- 7 Asset Exc M/U (param ='A')
         -- sum(lis_loc_aa_emu) lislocaae,-- 9
         ---  sum(lis_loc_fc_mu) lislocfcmu, --  8 Markup on Assset (param ='A')
         --  sum(lis_loc_aa_mu) lislocaamu, -- 10 Markup on Cost  (param ='A') *
         SUM (lis_con_fc_emu) * rat_rate lislocfce,
         SUM (lis_con_aa_emu) * rat_rate lislocaae,
         SUM (lis_con_fc_mu) * rat_rate lislocfcmu,
         SUM (lis_con_aa_mu) * rat_rate lislocaamu,
         ROUND (SUM (lis_con_fc_imu), 2)
         - ROUND (SUM (lis_con_fc_emu), 2) con_fci_fce,
         -- 2 Markup on Asset
         ROUND (SUM (lis_con_aa_imu), 2)
         - ROUND (SUM (lis_con_aa_emu), 2) con_aai_aae,
         -- 4 Markup on Costs
         sch_paid (lic_currency,
         lic_type,
         lee_short_name,
         lic_budget_code,
         i_period_date
         ) exh
         FROM fid_licensee,
         fid_license,
         fid_lis_vw,
         fid_exchange_rate,
         (SELECT com_name, com_number, ter_cur_code
         FROM fid_company, fid_territory
         WHERE com_short_name LIKE i_chnl_comp_name
         AND com_type IN ('BC', 'CC')
         AND ter_code = com_ter_code) y
         WHERE lic_type LIKE i_lic_type
         AND lic_lee_number = lee_number
         AND lic_number = lis_lic_number
         AND lis_per_year = l_year
         --TO_NUMBER(TO_CHAR(:PARAM4,'YYYY'))
         AND lis_per_month = l_month
         --TO_NUMBER(TO_CHAR(:PARAM4,'MM'))
         AND rat_cur_code = lic_currency
         AND rat_cur_code_2 = y.ter_cur_code
         --   and rownum<=20
         GROUP BY lee_cha_com_number,
         lic_currency,
         lic_type,
         lee_short_name,
         lic_budget_code,
         y.com_name,
         y.ter_cur_code,
         sch_paid (lic_currency,
         lic_type,
         lee_short_name,
         lic_budget_code,
         i_period_date
         ),
         lis_con_fc_emu,
         lis_con_aa_emu,
         lis_con_fc_mu,
         lis_con_aa_mu,
         rat_rate
         ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;*/
         OPEN o_lib_rep FOR
            SELECT   chnl_comp, lee_cha_com_number, lic_currency, lic_type,

                     ---Dev2:Pure Finance:Start:[Hari mandal]_[30/4/2013]
                     lee_short_name, lic_budget_code, ter_cur_code,

                     --,rat_rate,lic_start,lic_rate,
                     ROUND (lisconfce, 2) lisconfce,
                     ROUND (lisconaae, 2) lisconaae,
                     ROUND (lisconfci, 2) lisconfci,
                     ROUND (lisconaai, 2) lisconaai, lislocfce, lislocaae,
                     lislocfcmu, lislocaamu,
                     ROUND (con_fci_fce, 2) con_fci_fce,

                     ---Dev2:Pure Finance:End----------------------------
                     ROUND (con_aai_aae, 2) con_aai_aae,
                     pkg_fin_mnet_mvt_summ.sch_paid (lic_currency,
                                                     lic_type,
                                                     lee_short_name,
                                                     lic_budget_code,
                                                     i_from_period,
                                                     i_to_period,
                                                     i_lee_region_id
                                                    ) exh
                FROM (SELECT   fc.com_name chnl_comp, flee.lee_cha_com_number,
                               fl.lic_currency, fl.lic_type,
                               flee.lee_short_name, fl.lic_budget_code,
                               ft.ter_cur_code,

                               --,lic_start,lic_rate,
                               --case when lic_start < v_go_live_date then nvl (rat_rate, 0)
                               --else lic_rate end rat_rate,
                               SUM (mv.lis_con_fc_emu_nw) lisconfce,
                               SUM (mv.lis_con_aa_emu_23) lisconaae,
                               SUM (mv.lis_con_fc_imu) lisconfci,
                               SUM (mv.lis_con_aa_imu_23) lisconaai,
                               SUM (mv.lis_loc_fc_emu_23) lislocfce,
                               SUM (mv.lis_loc_aa_emu) lislocaae,
                               SUM (mv.lis_loc_fc_mu_3) lislocfcmu,
                               SUM (mv.lis_loc_aa_mu_3) lislocaamu,
                               (  SUM (ROUND (mv.lis_con_fc_imu, 2))
                                - SUM (mv.lis_con_fc_emu_nw)
                               ) con_fci_fce,

                                 -- 2 Markup on Asset
                                 SUM (mv.lis_con_aa_imu_23)
                               - SUM (mv.lis_con_aa_emu_23) con_aai_aae
                          -- SUM (sch_paid) exh
                      FROM     fid_company fc,
                               fid_territory ft,
                               fid_licensee flee,
                               fid_license fl,
                               --fid_lis_vw,
                               x_mv_subledger_data mv,
                               --fid_sch_summary_vw,
                               fid_exchange_rate fer,
                               fid_region fr,               -- added for split
                               x_fin_lic_sec_lee xfsl
                         WHERE fc.com_short_name LIKE i_chnl_comp_name
                           AND fc.com_type IN ('BC', 'CC')
                           AND ft.ter_code = fc.com_ter_code
                           AND fl.lic_type LIKE i_lic_type
                           ---Dev2:Pure Finance:Start:[Hari mandal]_[30/4/2013]
                           --AND lic_lee_number = lee_number
                           AND fl.lic_number = lsl_lic_number
                           AND flee.lee_number = lsl_lee_number
                           AND flee.lee_split_region = reg_id(+)
                           AND fl.lic_status NOT IN ('F', 'T')
                           ---Dev2:Pure Finance:End---------------------------
                           AND fl.lic_number = lis_lic_number
                           -----added on 28-jun-2013
                           AND xfsl.lsl_number = lis_lsl_number
                           ----
                           AND flee.lee_cha_com_number = fc.com_number
                           --ANDlis_per_year || LPAD (lis_per_month, 2, 0) BETWEEN TO_NUMBER (TO_CHAR (i_from_period,'YYYYMM')) AND TO_NUMBER (TO_CHAR (i_to_period,'YYYYMM'))
                           AND (    mv.lis_yyyymm_num >= v_frm_per_yyyymm_num
                                AND mv.lis_yyyymm_num <= v_to_per_yyyymm_num
                               )
                           --AND sch_year || LPAD (sch_month, 2, 0) = TO_NUMBER (TO_CHAR (:i_period_date, 'YYYYMM'))
                           --AND sch_lic_number = lic_number
                           AND fer.rat_cur_code = fl.lic_currency
                           AND fer.rat_cur_code_2(+) = ft.ter_cur_code
                           AND UPPER (fr.reg_code) LIKE
                                                       UPPER (i_lee_region_id)
                      --AND lee_region_id = reg_id
                      --AND ROWNUM < 100000
                      GROUP BY fc.com_name,
                               flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               ft.ter_cur_code                             --,
                                              --lic_start,
                                              --lic_rate
                     )
            ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;
      END IF;
   END prc_fin_moment_rep_mmt;

   FUNCTION sch_paid (
      i_lic_currency      IN   fid_license.lic_currency%TYPE,
      i_lic_type          IN   fid_license.lic_type%TYPE,
      i_lee_short_name    IN   fid_licensee.lee_short_name%TYPE,
      i_lic_budget_code   IN   fid_license.lic_budget_code%TYPE,
      i_from_period       IN   DATE,
      i_to_period         IN   DATE,
      i_lee_region_id     IN   fid_region.reg_code%TYPE
   )
      RETURN NUMBER
   IS
      sch_paid_is    NUMBER;
      l_cp_lee_cnt   NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO l_cp_lee_cnt
           FROM fid_licensee flee
          WHERE flee.lee_short_name = i_lee_short_name
            AND flee.lee_media_service_code = 'CATCHUP';

         IF l_cp_lee_cnt = 0
         THEN
            SELECT   SUM (DECODE (a.lic_catchup_flag, 'Y', NULL, sch_paid))
                INTO sch_paid_is
                FROM fid_sch_summary_vw, fid_license_vw a, fid_region fr
               WHERE a.lic_currency = i_lic_currency
                 AND a.lic_type = i_lic_type
                 AND a.lee_short_name = i_lee_short_name
                 AND a.lic_budget_code = i_lic_budget_code
                 AND sch_year || LPAD (sch_month, 2, 0)
                        BETWEEN                                       --i_year
                               TO_CHAR (i_from_period, 'YYYYMM')
                            AND TO_CHAR (i_to_period, 'YYYYMM')
                 AND sch_lic_number = a.lic_number
                 AND a.lee_region_id = fr.reg_id
                 AND fr.reg_code LIKE i_lee_region_id
            GROUP BY a.lic_currency,
                     a.lic_type,
                     a.lee_short_name,
                     a.lic_budget_code;
         ELSE
            sch_paid_is := NULL;
         END IF;
      /* SELECT SUM (sch_paid)
      INTO sch_paid_is
      FROM fid_sch_summary_vw
      WHERE sch_year || LPAD (sch_month, 2, 0) =                  --i_year
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
      AND sch_lic_number IN (
      SELECT lic_number
      FROM fid_license_vw a--, fid_region, fid_licensee b
      WHERE --a.lee_number = b.lee_number
      --AND lee_region_id = reg_id
      -- AND reg_code LIKE i_lee_region_id
      lic_currency = i_lic_currency
      AND lic_type = i_lic_type
      AND a.lee_short_name = i_lee_short_name
      AND lic_budget_code = i_lic_budget_code);*/
      /*SELECT SUM (sch_paid)
      INTO sch_paid_is
      FROM fid_sch_summary_vw
      WHERE sch_year || LPAD (sch_month, 2, 0) =                  --i_year
      TO_NUMBER (TO_CHAR (i_period_date, 'YYYYMM'))
      AND sch_lic_number IN (
      SELECT lic_number
      FROM fid_license_vw a ,fid_region, fid_licensee b
      WHERE a.lee_number = b.lee_number
      AND lee_region_id = reg_id
      AND reg_code LIKE i_lee_region_id
      AND lic_currency = i_lic_currency
      AND lic_type = i_lic_type
      AND a.lee_short_name = i_lee_short_name
      AND lic_budget_code = i_lic_budget_code); */
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            sch_paid_is := 0;
      END;

      /* IF sch_paid_is IS NULL
      THEN
      sch_paid_is := 0;
      END IF;*/
      RETURN sch_paid_is;
   END;

   FUNCTION sch_paid_summ (
      i_lic_number    IN   fid_license.lic_number%TYPE,
      i_period_date   IN   DATE
   )
      RETURN NUMBER
   IS
      sch_paid_is   NUMBER;
   BEGIN
      SELECT SUM (sch_paid)
        INTO sch_paid_is
        FROM fid_sch_summary_vw
       WHERE TO_CHAR (sch_year) || TO_CHAR (sch_month, '09') <=
                                             TO_CHAR (i_period_date, 'YYYYMM')
         AND sch_lic_number = i_lic_number;

      RETURN sch_paid_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         sch_paid_is := 0;
         RETURN sch_paid_is;
   END;

 /************************************************************************************************************************************
   Ver        Date        Author            Description                    Purpose
   ---------  ----------  ---------------  ------------------------------------------------------------------------------------------
   1.0        10/13/2016   Ankur Kasar     1. Created this package.      Rename all header  as per new requirement.
                                                                         :[BR_16_399_Update Financial Movement Report]
   ************************************************************************************************************************************/
   PROCEDURE prc_out_summ_exc (
      i_chnl_comp_name     IN       VARCHAR2,
      i_lic_type           IN       VARCHAR2,
      i_from_period        IN       DATE,
      i_to_period          IN       DATE,
      i_acct_prvlng_rate   IN       VARCHAR2,
      i_lee_region_id      IN       fid_region.reg_code%TYPE,
      -- added for split
      o_cur_data           OUT      pkg_fin_mnet_mvt_summ.c_out_summ
   )
   AS
      o_query_string   VARCHAR2 (5000);
      l_start          DATE;
      l_end            DATE;
      v_go_live_date   DATE;
   BEGIN
      SELECT TRUNC (TO_DATE (i_from_period)), TRUNC (LAST_DAY (i_to_period))
        INTO l_start, l_end
        FROM DUAL;

      IF i_acct_prvlng_rate <> 'A'
      THEN
         OPEN o_cur_data FOR
            SELECT   com_name,lic_currency, ter_cur_code, lic_type,
                     lee_short_name, lic_budget_code,
                     ROUND (SUM (lisconfce),  2)   "License Currency Asset Exc M/U",--lisconfce,
                     ROUND (SUM (lisconaae),  2)   "License Currency Costs Exc M/U",--lisconaae,
                     ROUND (SUM (lisconaai),  2)   "License Currency Costs Inc M/U",--lisconaai,
                     ROUND (SUM (lisconfci),  2)   "License Currency Asset Inc M/U",--lisconfci,
                     ROUND (SUM (con_fci_fce),2)   "MarkUp On Asset-Lic Currency", --con_fci_fce,
                     ROUND (SUM (con_aai_aae),2)   "MarkUp On Cost-Lic Currency",--con_aai_aae,
                     ROUND (SUM (lislocfcep), 2)   "Local Currency Asset Exc M/U",--lislocfce,
                     ROUND (SUM (lislocfcmup),2)   "MarkUp On Asset-Loc Currency",--lislocfcmu,
                     ROUND (SUM (lislocaaep), 2)   "Local Currency Costs Exc M/U",--lislocaae,
                     ROUND (SUM (lislocaamup),2)   "MarkUp On Cost-Loc Currency",--lislocaamu,
                     0 "Exh"--showings
                FROM (SELECT lic_number, ter_cur_code,
                                                      /*(SELECT SUM (sch_paid)
                                                      FROM fid_sch_summary_vw
                                                      WHERE  TO_CHAR (sch_year)||TO_CHAR (sch_month, '09') <= TO_CHAR (l_start, 'YYYYMM')
                                                      AND sch_lic_number = lic_number) sch_paid_is,*/
                                                      com_name, com_number,
                             lic_currency, lic_type, lee_short_name,
                             lic_budget_code, rat_rate, lisconfcmu, lisconfce,
                             lisconaae, lisconaamu, lisconfci, lisconaai,
                             (lisconfci - lisconfce) con_fci_fce,
                             (lisconaai - lisconaae) con_aai_aae,
                             ROUND (lisconfce * rat_rate, 2) lislocfcep,
                             ROUND (lisconfcmu * rat_rate, 2) lislocfcmup,
                             ROUND (lisconaae * rat_rate, 2) lislocaaep,
                             ROUND (lisconaamu * rat_rate, 2) lislocaamup
                        FROM (SELECT fl.lic_number, fc.com_number,
                                     fc.com_name, fl.lic_currency,
                                     fl.lic_type, flee.lee_short_name,
                                     ft.ter_cur_code, fl.lic_budget_code,
                                     NVL (fer.rat_rate, 0) rat_rate
                                FROM fid_company fc,
                                     fid_licensee flee,
                                     fid_license fl,
                                     fid_territory ft,
                                     fid_exchange_rate fer,
                                     fid_region fr          -- added for split
                               WHERE fc.com_short_name LIKE i_chnl_comp_name
                                 AND fc.com_type IN ('BC', 'CC')
                                 AND ft.ter_code = fc.com_ter_code
                                 AND fer.rat_cur_code = fl.lic_currency
                                 AND fer.rat_cur_code_2(+) = ft.ter_cur_code
                                 --Dev.R3: Start: Placeholder_[Devashish Raverkar]_[27-03-2014]
                                 AND fl.lic_status <> 'T'
                                 --Dev.R3: End:
                                 AND fl.lic_start < (SELECT content
                                                       FROM x_fin_configs
                                                      WHERE ID = 1)
                                 -- split
                                 AND flee.lee_region_id = fr.reg_id
                                 AND fr.reg_code LIKE i_lee_region_id
                                 AND (    flee.lee_cha_com_number =
                                                                 fc.com_number
                                      AND fl.lic_type LIKE i_lic_type
                                      AND fl.lic_lee_number = flee.lee_number
                                      AND (   EXISTS (
                                                 /*
                                                 SELECT   'X',
                                                 SUM
                                                 (TO_NUMBER
                                                 (  lis_con_forecast
                                                 - (  lis_con_actual
                                                 + lis_con_adjust
                                                 )
                                                 )
                                                 )
                                                 FROM fid_license_sub_ledger
                                                 WHERE lis_lic_number =
                                                 lic_number
                                                 AND TO_CHAR
                                                 (   lis_per_year
                                                 || LPAD
                                                 (lis_per_month,
                                                 2,
                                                 0
                                                 )
                                                 ) <=
                                                 TO_CHAR (l_start,
                                                 'YYYYMM'
                                                 )
                                                 group by 'X'
                                                 HAVING (ROUND
                                                 (SUM
                                                 (TO_NUMBER
                                                 (  lis_con_forecast
                                                 - (  lis_con_actual
                                                 + lis_con_adjust
                                                 )
                                                 )
                                                 ),
                                                 0
                                                 ) != 0) /*OR
                                                 (ROUND
                                                 (SUM
                                                 (TO_NUMBER
                                                 (  lis_loc_forecast
                                                 - (  lis_loc_actual
                                                 + lis_loc_adjust
                                                 )
                                                 )
                                                 ),
                                                 0
                                                 ) != 0)*/
                                                 SELECT   'X',
                                                          SUM
                                                             (slx.cf_m_ca_p_cadj
                                                             )
                                                     FROM x_mv_movement_sum_ex_1 slx
                                                    WHERE slx.lis_lic_number =
                                                                 fl.lic_number
                                                      AND slx.lis_yyyymm_num <=
                                                             TO_NUMBER
                                                                (TO_CHAR
                                                                     (l_start,
                                                                      'YYYYMM'
                                                                     )
                                                                )
                                                 GROUP BY 'X'
                                                   HAVING ROUND
                                                             (SUM
                                                                 (slx.cf_m_ca_p_cadj
                                                                 ),
                                                              0
                                                             ) != 0)
                                           OR (    fl.lic_acct_date <= l_end
                                               AND fl.lic_end > l_end
                                              )
                                          )
                                     )),
                             (
                              /*
                              SELECT   SUM (lis_con_fc_mu) lisconfcmu,
                              SUM (lis_con_fc_emu) lisconfce,
                              SUM (lis_con_aa_emu) lisconaae,
                              SUM (lis_con_aa_mu) lisconaamu,
                              SUM (lis_con_fc_imu) lisconfci,
                              SUM (lis_con_aa_imu) lisconaai,
                              lis_lic_number
                              FROM FID_LIS_VW_FMSUM
                              WHERE (   lis_per_year
                              || LPAD (lis_per_month, 2, 0) <=
                              TO_NUMBER (TO_CHAR (l_start,
                              'YYYYMM'
                              )
                              )
                              )
                              GROUP BY lis_lic_number */
                              SELECT   SUM (lisconfcmu) AS lisconfcmu,
                                       SUM (lisconfce) AS lisconfce,
                                       SUM (lisconaae) AS lisconaae,
                                       SUM (lisconaamu) AS lisconaamu,
                                       SUM (lisconfci) AS lisconfci,
                                       SUM (lisconaai) AS lisconaai,
                                       lis_lic_number
                                  FROM x_mv_fid_lis_fmsum
                                 WHERE (lis_yyyymm_num <=
                                           TO_NUMBER (TO_CHAR (l_start,
                                                               'YYYYMM'
                                                              )
                                                     )
                                       )
                              GROUP BY lis_lic_number) b
                       WHERE b.lis_lic_number = lic_number
                      UNION
                      SELECT lic_number, ter_cur_code,
                                                      /*(SELECT SUM (sch_paid)
                                                      FROM fid_sch_summary_vw
                                                      WHERE    TO_CHAR (sch_year)
                                                      || TO_CHAR (sch_month, '09') <=
                                                      TO_CHAR (l_start, 'YYYYMM')
                                                      AND sch_lic_number = lic_number) sch_paid_is,*/
                                                      com_name, com_number,
                             lic_currency, lic_type, lee_short_name,
                             lic_budget_code, rat_rate, lisconfcmu, lisconfce,
                             lisconaae, lisconaamu, lisconfci, lisconaai,
                             lisconfci - lisconfce con_fci_fce,
                             (lisconaai - lisconaae) con_aai_aae,
                             ROUND (lislocfce, 2) lislocfce,
                             ROUND (lislocfcmu, 2) lislocfcmu,
                             ROUND (lislocaae, 2) lislocaae,
                             ROUND (lislocaamu, 2) lislocaamu
                        FROM (SELECT fl.lic_number, fc.com_number,
                                     fc.com_name, fl.lic_currency,
                                     fl.lic_type, flee.lee_short_name,
                                     ft.ter_cur_code, fl.lic_budget_code,
                                     NVL (fer.rat_rate, 0) rat_rate,
                                     xfsl.lsl_number
                                FROM fid_company fc,
                                     fid_licensee flee,
                                     fid_license fl,
                                     fid_territory ft,
                                     fid_exchange_rate fer,
                                     fid_region fr,
                                     x_fin_lic_sec_lee xfsl
                               WHERE fc.com_short_name LIKE i_chnl_comp_name
                                 AND fc.com_type IN ('BC', 'CC')
                                 AND ft.ter_code = fc.com_ter_code
                                 AND fer.rat_cur_code = fl.lic_currency
                                 --Dev.R3: Start: Placeholder_[Devashish Raverkar]_[27-03-2014]
                                 AND fl.lic_status <>
                                        'T'
                                           -- Alias for Finance Report Rewrite
                                 --Dev.R3: End:
                                 AND fer.rat_cur_code_2(+) = ft.ter_cur_code
                                 AND fl.lic_start >= (SELECT content
                                                        FROM x_fin_configs
                                                       WHERE ID = 1)
                                 AND flee.lee_split_region =
                                              fr.reg_id(+)
                                                 -- AND lee_region_id = reg_id
                                 AND fr.reg_code LIKE i_lee_region_id
----------------------------------------------
                                 AND fl.lic_number = xfsl.lsl_lic_number
                                 AND flee.lee_number = xfsl.lsl_lee_number
-------------------------------------------------
                                 AND (    flee.lee_cha_com_number =
                                                                 fc.com_number
                                      AND fl.lic_type LIKE i_lic_type
                                      ---commented----AND lic_lee_number = lee_number
                                      AND (   EXISTS (
                                                 SELECT   'X',
                                                          SUM (cf_m_ca_p_cadj),
                                                          SUM (lf_m_la_p_ladj)
                                                     FROM x_mv_movement_sum_ex_2 f1
                                                    WHERE f1.lis_lic_number =
                                                                 fl.lic_number
                                                      AND f1.lis_lsl_number =
                                                               xfsl.lsl_number
                                                      AND f1.lis_yyyymm_num <=
                                                             TO_NUMBER
                                                                (TO_CHAR
                                                                     (l_start,
                                                                      'YYYYMM'
                                                                     )
                                                                )
                                                 GROUP BY 'X'
                                                   HAVING (ROUND
                                                              (SUM
                                                                  (f1.cf_m_ca_p_cadj
                                                                  ),
                                                               0
                                                              ) != 0
                                                          )
                                                       OR (ROUND
                                                              (SUM
                                                                  (f1.lf_m_la_p_ladj
                                                                  ),
                                                               0
                                                              ) != 0
                                                          ))
                                           OR (    fl.lic_acct_date <= l_end
                                               AND fl.lic_end > l_end
                                              )
                                          )
                                     )),
                             (
                              /*
                              SELECT   SUM (lis_con_fc_mu) lisconfcmu,
                              SUM (lis_con_fc_emu) lisconfce,
                              SUM (lis_con_aa_emu) lisconaae,
                              SUM (lis_con_aa_mu) lisconaamu,
                              SUM (lis_con_fc_imu) lisconfci,
                              SUM (lis_con_aa_imu) lisconaai,
                              SUM (lis_loc_fc_emu) lislocfce,
                              SUM (lis_loc_aa_emu) lislocaae,
                              SUM (lis_loc_fc_mu) lislocfcmu,
                              sum (lis_loc_aa_mu) lislocaamu,
                              lis_lic_number,
                              lis_lsl_number
                              FROM FID_LIS_VW_FMSUM_NEW
                              WHERE (   lis_per_year
                              || LPAD (lis_per_month, 2, 0) <=
                              TO_NUMBER (TO_CHAR (l_start,
                              'YYYYMM'
                              )
                              )
                              )
                              group by lis_lic_number,lis_lsl_number */
                              SELECT   SUM (lisconfcmu) AS lisconfcmu,
                                       SUM (lisconfce) AS lisconfce,
                                       SUM (lisconaae) AS lisconaae,
                                       SUM (lisconaamu) AS lisconaamu,
                                       SUM (lisconfci) AS lisconfci,
                                       SUM (lisconaai) AS lisconaai,
                                       SUM (ROUND (lislocfce, 2))
                                                                 AS lislocfce,
                                       SUM (lislocaae) AS lislocaae,
                                       SUM (lislocfcmu) AS lislocfcmu,
                                       SUM (lislocaamu) AS lislocaamu,
                                       lis_lic_number, lis_lsl_number
                                  FROM x_mv_fid_lis_fmsum_new flmvn
                                 WHERE (flmvn.lis_yyyymm_num <=
                                           TO_NUMBER (TO_CHAR (l_start,
                                                               'YYYYMM'
                                                              )
                                                     )
                                       )
                              GROUP BY flmvn.lis_lic_number,
                                       flmvn.lis_lsl_number) b
                       WHERE b.lis_lic_number = lic_number
                         AND b.lis_lsl_number = lsl_number
                     )
            GROUP BY com_number,
                     com_name,
                     lic_currency,
                     ter_cur_code,
                     lic_type,
                     lee_short_name,
                     lic_budget_code
            ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;
      END IF;
   END prc_out_summ_exc;

   PROCEDURE prc_fin_moment_rep_mmt_exc (
      i_chnl_comp_name     IN       fid_company.com_short_name%TYPE,
      i_lic_type           IN       fid_license.lic_type%TYPE,
      i_from_period        IN       DATE,
      i_to_period          IN       DATE,
      i_acct_prvlng_rate   IN       CHAR,
      i_lee_region_id      IN       fid_region.reg_code%TYPE,
      o_lib_rep            OUT      pkg_fin_mnet_mvt_summ.c_out_summ
   )
   AS
      l_month                NUMBER;
      l_year                 NUMBER;
      v_frm_per_yyyymm_num   NUMBER (6)
                             := TO_NUMBER (TO_CHAR (i_from_period, 'YYYYMM'));
      v_to_per_yyyymm_num    NUMBER (6)
                             := TO_NUMBER (TO_CHAR (i_to_period, 'YYYYMM'));
      v_go_live_date         DATE;
   BEGIN
      ---Dev2:Pure Finance:Start:[Hari Mandal]_[02/05/2013]
      SELECT TO_DATE (content)
        INTO v_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      ---Dev2:Pure Finance:End--------------
      IF (UPPER (i_acct_prvlng_rate) = 'A')
      THEN
         OPEN o_lib_rep FOR
            SELECT   chnl_comp, lee_cha_com_number, lic_currency, lic_type,
                     lee_short_name, lic_budget_code, ter_cur_code,
                     ROUND (lisconfce,  2) "License Currency Asset Exc M/U",--lisconfce,
                     ROUND (lisconaae,  2) "License Currency Costs Exc M/U",--lisconaae,
                     ROUND (lisconaai,  2) "License Currency Costs Inc M/U",--lisconaai,
                     ROUND (lisconfci,  2) "License Currency Asset Inc M/U",--lisconfci,
                     ROUND (con_fci_fce,2) "MarkUp On Asset-Lic Currency",--con_fci_fce,
                     ROUND (con_aai_aae,2) "MarkUp On Cost-Lic Currency",--con_aai_aae,
                     ROUND (lislocfce,  2) "Local Currency Asset Exc M/U",--lislocfce,
                     ROUND (lislocfcmu, 2) "MarkUp On Asset-Loc Currency",--lislocfcmu,
                     ROUND (lislocaae,  2) "Local Currency Costs Exc M/U",--lislocaae,
                     ROUND (lislocaamu, 2) "MarkUp On Cost-Loc Currency",--lislocaamu,             
                     pkg_fin_mnet_mvt_summ.sch_paid (lic_currency,
                                                     lic_type,
                                                     lee_short_name,
                                                     lic_budget_code,
                                                     i_from_period,
                                                     i_to_period,
                                                     i_lee_region_id
                                                    ) "Exh"
                FROM (SELECT   fc.com_name chnl_comp, flee.lee_cha_com_number,
                               fl.lic_currency, fl.lic_type,
                               flee.lee_short_name, fl.lic_budget_code,
                               ft.ter_cur_code,
                               SUM (mv.lis_con_fc_emu_nw) lisconfce,
                               SUM (mv.lis_con_aa_emu_23) lisconaae,
                               SUM (mv.lis_con_fc_imu)    lisconfci,
                               SUM (mv.lis_con_aa_imu_23) lisconaai,
                               SUM (mv.lis_loc_fc_emu_23) lislocfce,
                               SUM (mv.lis_loc_aa_emu)    lislocaae,
                               SUM (mv.lis_loc_fc_mu_3)   lislocfcmu,
                               SUM (mv.lis_loc_aa_mu_3)   lislocaamu,
                               (  SUM (ROUND (mv.lis_con_fc_imu, 2))
                                - SUM (mv.lis_con_fc_emu_nw)
                               ) con_fci_fce,

                                 -- 2 Markup on Asset
                                 SUM (mv.lis_con_aa_imu_23)
                               - SUM (mv.lis_con_aa_emu_23) con_aai_aae
                          --SUM (lis_con_fc_emu) * rat_rate lislopfce,
                          --SUM (lis_con_aa_emu) * rat_rate lislopaae,
                          --SUM (lis_con_fc_mu) * rat_rate lislopfcmu,
                          --SUM (lis_con_aa_mu) * rat_rate lislopaamu,
                          --SUM (sch_paid) exh
                      FROM     fid_company fc,
                               fid_territory ft,
                               fid_licensee flee,
                               fid_license fl,
                               --fid_lis_vw,
                               x_mv_subledger_data mv,
                               --fid_sch_summary_vw,
                               fid_exchange_rate fer,
                               fid_region fr,               -- added for split
                               x_fin_lic_sec_lee xfsl
                         WHERE fc.com_short_name LIKE i_chnl_comp_name
                           AND fc.com_type IN ('BC', 'CC')
                           AND ft.ter_code = fc.com_ter_code
                           AND fl.lic_type LIKE i_lic_type
                           ---Dev2:Pure Finance:Start:[Hari mandal]_[30/4/2013]
                           --AND lic_lee_number = lee_number
                           AND fl.lic_number = xfsl.lsl_lic_number
                           AND flee.lee_number = xfsl.lsl_lee_number
                           AND flee.lee_split_region = reg_id(+)
                           AND fl.lic_status NOT IN ('F', 'T')
                           ---Dev2:Pure Finance:End---------------------------
                           AND fl.lic_number = mv.lis_lic_number
                           -----added on 28-jun-2013
                           AND xfsl.lsl_number = mv.lis_lsl_number
                           -----
                           AND flee.lee_cha_com_number = fc.com_number
                           --and lis_per_year || lpad (lis_per_month, 2, 0) between to_number (to_char (i_from_period,'YYYYMM')) AND TO_NUMBER (TO_CHAR (i_to_period,'YYYYMM'))
                           AND (    mv.lis_yyyymm_num >= v_frm_per_yyyymm_num
                                AND mv.lis_yyyymm_num <= v_to_per_yyyymm_num
                               )
                           --AND sch_year || LPAD (sch_month, 2, 0) = TO_NUMBER (TO_CHAR (:i_period_date, 'YYYYMM'))
                           --AND sch_lic_number = lic_number
                           AND fer.rat_cur_code = fl.lic_currency
                           AND fer.rat_cur_code_2(+) = ft.ter_cur_code
                           AND UPPER (fr.reg_code) LIKE
                                                       UPPER (i_lee_region_id)
                      --AND lee_region_id = reg_id
                      --AND ROWNUM < 100000
                      GROUP BY fc.com_name,
                               flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               ft.ter_cur_code)
            ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;
      
      END IF;

      IF (UPPER (i_acct_prvlng_rate) = 'P')
      THEN
         OPEN o_lib_rep FOR
            SELECT   chnl_comp, lee_cha_com_number, lic_currency, lic_type,
                     lee_short_name, lic_budget_code, ter_cur_code,
                     ROUND (lisconfce,  2) "License Currency Asset Exc M/U",--lisconfce,
                     ROUND (lisconaae,  2) "License Currency Costs Exc M/U",--lisconaae,
                     ROUND (lisconaai,  2) "License Currency Costs Inc M/U",--lisconaai,                      
                     ROUND (lisconfci,  2) "License Currency Asset Inc M/U",--lisconfci,
                     ROUND (con_fci_fce,2) "MarkUp On Asset-Lic Currency",--con_fci_fce,
                     ROUND (con_aai_aae, 2)"MarkUp On Cost-Lic Currency",--con_aai_aae,                     
                     lislocfce             "Local Currency Asset Exc M/U", 
                     lislocfcmu            "MarkUp On Asset-Loc Currency",                    
                     lislocaae             "Local Currency Costs Exc M/U",
                     lislocaamu            "MarkUp On Cost-Loc Currency",                     
                     pkg_fin_mnet_mvt_summ.sch_paid (lic_currency,
                                                     lic_type,
                                                     lee_short_name,
                                                     lic_budget_code,
                                                     i_from_period,
                                                     i_to_period,
                                                     i_lee_region_id
                                                    ) "Exh"--exh
                FROM (SELECT   fc.com_name chnl_comp, flee.lee_cha_com_number,
                               fl.lic_currency, fl.lic_type,
                               flee.lee_short_name, fl.lic_budget_code,
                               ft.ter_cur_code,

                               --,lic_start,lic_rate,
                               --case when lic_start < v_go_live_date then nvl (rat_rate, 0)
                               --else lic_rate end rat_rate,
                               SUM (mv.lis_con_fc_emu_nw) lisconfce,
                               SUM (mv.lis_con_aa_emu_23) lisconaae,
                               SUM (mv.lis_con_fc_imu)    lisconfci,
                               SUM (mv.lis_con_aa_imu_23) lisconaai,
                               SUM (mv.lis_loc_fc_emu_23) lislocfce,
                               SUM (mv.lis_loc_aa_emu)    lislocaae,
                               SUM (mv.lis_loc_fc_mu_3)   lislocfcmu,
                               SUM (mv.lis_loc_aa_mu_3)   lislocaamu,
                               (  SUM (ROUND (mv.lis_con_fc_imu, 2))
                                - SUM (mv.lis_con_fc_emu_nw)
                               ) con_fci_fce,

                                 -- 2 Markup on Asset
                                 SUM (mv.lis_con_aa_imu_23)
                               - SUM (mv.lis_con_aa_emu_23) con_aai_aae
                          -- SUM (sch_paid) exh
                      FROM     fid_company fc,
                               fid_territory ft,
                               fid_licensee flee,
                               fid_license fl,
                               --fid_lis_vw,
                               x_mv_subledger_data mv,
                               --fid_sch_summary_vw,
                               fid_exchange_rate fer,
                               fid_region fr,               -- added for split
                               x_fin_lic_sec_lee xfsl
                         WHERE fc.com_short_name LIKE i_chnl_comp_name
                           AND fc.com_type IN ('BC', 'CC')
                           AND ft.ter_code = fc.com_ter_code
                           AND fl.lic_type LIKE i_lic_type
                           ---Dev2:Pure Finance:Start:[Hari mandal]_[30/4/2013]
                           --AND lic_lee_number = lee_number
                           AND fl.lic_number = lsl_lic_number
                           AND flee.lee_number = lsl_lee_number
                           AND flee.lee_split_region = reg_id(+)
                           AND fl.lic_status NOT IN ('F', 'T')
                           ---Dev2:Pure Finance:End---------------------------
                           AND fl.lic_number = lis_lic_number
                           -----added on 28-jun-2013
                           AND xfsl.lsl_number = lis_lsl_number
                           ----
                           AND flee.lee_cha_com_number = fc.com_number
                           --ANDlis_per_year || LPAD (lis_per_month, 2, 0) BETWEEN TO_NUMBER (TO_CHAR (i_from_period,'YYYYMM')) AND TO_NUMBER (TO_CHAR (i_to_period,'YYYYMM'))
                           AND (    mv.lis_yyyymm_num >= v_frm_per_yyyymm_num
                                AND mv.lis_yyyymm_num <= v_to_per_yyyymm_num
                               )
                           --AND sch_year || LPAD (sch_month, 2, 0) = TO_NUMBER (TO_CHAR (:i_period_date, 'YYYYMM'))
                           --AND sch_lic_number = lic_number
                           AND fer.rat_cur_code = fl.lic_currency
                           AND fer.rat_cur_code_2(+) = ft.ter_cur_code
                           AND UPPER (fr.reg_code) LIKE
                                                       UPPER (i_lee_region_id)
                      --AND lee_region_id = reg_id
                      --AND ROWNUM < 100000
                      GROUP BY fc.com_name,
                               flee.lee_cha_com_number,
                               fl.lic_currency,
                               fl.lic_type,
                               flee.lee_short_name,
                               fl.lic_budget_code,
                               ft.ter_cur_code                             --,
                                              --lic_start,
                                              --lic_rate
                     )
            ORDER BY lic_currency, lic_type, lee_short_name, lic_budget_code;
      END IF;
   END prc_fin_moment_rep_mmt_exc;

END pkg_fin_mnet_mvt_summ;
/