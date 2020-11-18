CREATE OR REPLACE PACKAGE          "X_PKG_FIN_COMMITMNT_PMNT_RPT"
AS
   /*******************************************************************************
    REM Module          : Pure Finance
    REM Client          : MNet
    REM File Name       : pkg_fin_commpmntrpt.sql
    REM Form Name       : Committments Payment Report
    REM Purpose         : For calculating the Committments Payment
    REM Author          : Aditya Gupta
    REM Creation Date   : 03 Apr 2013
    REM Type            : Database Package
    REM Change History  :
    *******************************************************************************/
   TYPE c_comm_pmnt_rpt IS REF CURSOR;

   --**************************************************************
   --This procedure generates Committments Payment Report
   --**************************************************************
   PROCEDURE prc_fin_comm_pmnt_rpt (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      o_c_comm_pmnt_rpt   OUT    x_pkg_fin_commitmnt_pmnt_rpt.c_comm_pmnt_rpt);
      
   PROCEDURE prc_fin_comm_pmnt_rpt_after (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      o_c_comm_pmnt_rpt   OUT    x_pkg_fin_commitmnt_pmnt_rpt.c_comm_pmnt_rpt);

   PROCEDURE prc_fin_comm_pmnt_rpt_before (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      o_c_comm_pmnt_rpt   OUT    x_pkg_fin_commitmnt_pmnt_rpt.c_comm_pmnt_rpt);
   /*
   --**************************************************************
   --This procedure generates Committments Payment Report Excel
   --**************************************************************
       PROCEDURE prc_fin_comm_pmnt_exl(
       i_region                      IN         FID_REGION.REG_CODE%type,
       i_period                      IN         FID_LICENSE.LIC_END%type,
       i_chnl_comp                   IN         FID_COMPANY.COM_SHORT_NAME%TYPE,
       i_lic_type                    IN         FID_LICENSE.LIC_TYPE%TYPE,
       i_prg_type                    IN         FID_LICENSE.LIC_BUDGET_CODE%TYPE,
       i_licensee                    IN         FID_LICENSEE.LEE_SHORT_NAME%TYPE,
       i_supp_srt_name               IN         VARCHAR2,
       i_contract                    IN         FID_CONTRACT.CON_NAME%type,
       i_report_type                 IN         VARCHAR2,
       o_c_comm_pmnt_rpt             OUT        X_PKG_FIN_COMMITMNT_PMNT_RPT.c_comm_pmnt_rpt
       );
   */

   --**************************************************************
   --This procedure generates Committments Payment Report
   --**************************************************************
   PROCEDURE prc_fin_comm_pmnt_exl (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      i_type              IN     VARCHAR2,		-- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
      o_c_comm_pmnt_rpt      OUT x_pkg_fin_commitmnt_pmnt_rpt.c_comm_pmnt_rpt);
   
   PROCEDURE prc_fin_comm_pmnt_exl_after (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      i_type              IN     VARCHAR2,		-- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
      o_c_comm_pmnt_rpt      OUT x_pkg_fin_commitmnt_pmnt_rpt.c_comm_pmnt_rpt);

  PROCEDURE prc_fin_comm_pmnt_exl_before (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      i_type              IN      VARCHAR2,		-- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
      o_c_comm_pmnt_rpt      OUT x_pkg_fin_commitmnt_pmnt_rpt.c_comm_pmnt_rpt);
   FUNCTION total_paid_amt_per_lee (
      i_lic_number   IN fid_license.lic_number%TYPE,
      i_lsl_number   IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_period       IN DATE)
      RETURN NUMBER;
END x_pkg_fin_commitmnt_pmnt_rpt;
/
create or replace PACKAGE BODY          "X_PKG_FIN_COMMITMNT_PMNT_RPT"
AS
   /*******************************************************************************
    REM Module          : Pure Finance
    REM Client          : MNet
    REM File Name       : pkg_fin_commpmntrpt.sql
    REM Form Name       : Committments Payment Report
    REM Purpose         : For calculating the Committments Payment
    REM Author          : Aditya Gupta
    REM Creation Date   : 03 Apr 2013
    REM Type            : Database Package
    REM Change History  :
    *******************************************************************************/

/******************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         02-Nov-2016       Zeshan Khan                 Business Req.-
                                                          1. Business wants to get all the spot rates upto 5 decimal places instead of 4.
*******************************************************************************************************************************************/

   --**************************************************************
   --This procedure generates Committments Payment Report
   --**************************************************************
   PROCEDURE prc_fin_comm_pmnt_rpt (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      o_c_comm_pmnt_rpt   OUT    X_PKG_FIN_COMMITMNT_PMNT_RPT.c_comm_pmnt_rpt)
   AS
      l_go_live_date  date;
   BEGIN
      SELECT TO_DATE (content)
        INTO l_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'FIN_I_LIVE_DATE';
       
      IF i_period >= l_go_live_date OR i_from_period >= l_go_live_date
      THEN     
      X_PKG_FIN_COMMITMNT_PMNT_RPT.prc_fin_comm_pmnt_rpt_after(
                                                              i_region         ,           
                                                              i_from_period    ,
                                                              i_period         ,     
                                                              i_chnl_comp      ,    
                                                              i_lic_type       ,     
                                                              i_prg_type       ,     
                                                              i_licensee       ,     
                                                              i_supp_srt_name  ,    
                                                              i_contract       ,   
                                                              i_report_type    ,    
                                                              i_rpt_type       ,    
                                                              o_c_comm_pmnt_rpt 
                                                             );
      ELSE      
      X_PKG_FIN_COMMITMNT_PMNT_RPT.prc_fin_comm_pmnt_rpt_before(
                                                                i_region         ,           
                                                                i_from_period    ,
                                                                i_period         ,     
                                                                i_chnl_comp      ,    
                                                                i_lic_type       ,     
                                                                i_prg_type       ,     
                                                                i_licensee       ,     
                                                                i_supp_srt_name  ,    
                                                                i_contract       ,   
                                                                i_report_type    ,    
                                                                i_rpt_type       ,    
                                                                o_c_comm_pmnt_rpt 
                                                               );
      END IF;
              
   END prc_fin_comm_pmnt_rpt;
   
   PROCEDURE prc_fin_comm_pmnt_exl (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      i_type              IN     VARCHAR2, -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
      o_c_comm_pmnt_rpt      OUT x_pkg_fin_commitmnt_pmnt_rpt.c_comm_pmnt_rpt)
   AS
      l_go_live_date  date;
   BEGIN
      SELECT TO_DATE (content)
        INTO l_go_live_date
        FROM x_fin_configs
       WHERE KEY = 'FIN_I_LIVE_DATE';
       
       
         IF i_period >= l_go_live_date OR i_from_period >= l_go_live_date
      THEN
      
      X_PKG_FIN_COMMITMNT_PMNT_RPT.prc_fin_comm_pmnt_exl_after(
                                                              i_region         ,           
                                                              i_from_period    ,
                                                              i_period         ,     
                                                              i_chnl_comp      ,    
                                                              i_lic_type       ,     
                                                              i_prg_type       ,     
                                                              i_licensee       ,     
                                                              i_supp_srt_name  ,    
                                                              i_contract       ,   
                                                              i_report_type    ,    
                                                              i_rpt_type       , 
                                                              i_type           ,
                                                              o_c_comm_pmnt_rpt 
                                                             );
      ELSE
      
      X_PKG_FIN_COMMITMNT_PMNT_RPT.prc_fin_comm_pmnt_exl_before(                                              
                                                                i_region         ,           
                                                                i_from_period    ,
                                                                i_period         ,     
                                                                i_chnl_comp      ,    
                                                                i_lic_type       ,     
                                                                i_prg_type       ,     
                                                                i_licensee       ,     
                                                                i_supp_srt_name  ,    
                                                                i_contract       ,   
                                                                i_report_type    ,    
                                                                i_rpt_type       ,  
                                                                i_type           ,
                                                                o_c_comm_pmnt_rpt 
                                                               );
      END IF;
       
       
   END prc_fin_comm_pmnt_exl;
   --Dev.R1: Finace DEV Phase 1 :[Change because before go live date it work as existing package and after go live it work as new requirement]_[Ankur Kasar]_[2016/11/16]: Start
   
   PROCEDURE prc_fin_comm_pmnt_rpt_after (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      o_c_comm_pmnt_rpt   OUT    X_PKG_FIN_COMMITMNT_PMNT_RPT.c_comm_pmnt_rpt)
   AS
      l_year           NUMBER;
      l_month          NUMBER;
      l_rsa_ratedate   DATE;
      l_afr_ratedate   DATE;
      l_lastdate       DATE;
      l_firstdate      DATE;
   BEGIN
      l_month := TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'MM'));
      l_year := TO_NUMBER (TO_CHAR (i_period, 'YYYY'));

      --   TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'YYYY'));

      ------------------Calculate Rate Date ---------------------------------------------------------------------------
      IF UPPER (i_region) = 'RSA'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE     fmd_month = l_month
                   AND fmd_year = l_year
                   AND reg_id = fmd_region
                   AND UPPER (fmd_mon_end_type) = 'FINAL'
                   AND UPPER (reg_code) = i_region;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;
      ELSIF UPPER (i_region) = 'AFR'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE     fmd_month = l_month
                   AND fmd_year = l_year
                   AND reg_id = fmd_region
                   AND UPPER (fmd_mon_end_type) = 'FINAL'
                   AND UPPER (reg_code) = i_region;
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
             WHERE     fmd_month = l_month
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
             WHERE     fmd_month = l_month
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

      --------------------------------------------------------------------------------------------------------------------
      SELECT LAST_DAY (i_period) INTO l_lastdate FROM DUAL;

      SELECT ADD_MONTHS (LAST_DAY (l_lastdate), -1) + 1
        INTO l_firstdate
        FROM DUAL;

    if(upper(i_rpt_type) ='SUMMARY')
    then                                -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
      OPEN o_c_comm_pmnt_rpt FOR
         SELECT
                 lic_type license_type,
                 lee_short_name licensee,
                 lic_budget_code program_type,
                 ter_cur_code territory,
                 reg_code region,
                 channel_company,
                 lic_currency license_currency,
                 sum(pay_amount) payment_amount,
                 sum((pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period)) local_payment_amount
           FROM (SELECT
                          fl.lic_type,
                          lee_short_name,
                          lsl_number,
                          fl.lic_budget_code,
                          con_number,
                          fl.lic_number,
                          ROUND (fl.lic_price, 2) lic_price,
													--[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Added 
													(SELECT ROUND(NVL(SUM (pay_amount),0),2)
														 FROM fid_payment, fid_payment_type
														WHERE pat_code = pay_code
															AND pay_lic_number = fl.lic_number
															AND pay_con_number = FL.lic_con_number
															AND pay_cur_code = fl.lic_currency
															AND pay_lsl_number = lsl.lsl_number
															AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <= LAST_DAY(i_period)
															AND pay_status IN ('P', 'I')
															AND pat_group = 'F'
													 )paid,
                           ft.ter_cur_code,
                           fre.reg_code,
                           fc.com_name channel_company,
                           fl.lic_currency
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
                  WHERE     lee_cha_com_number = fc.com_number
                        AND gen_refno = lic_gen_refno
                        AND ter_code = fc.com_ter_code
                        AND fc.com_type IN ('CC', 'BC')
                        AND fle.lee_number = lsl.lsl_lee_number
                        AND fl.lic_number = lsl.lsl_lic_number
                        AND con_number = lic_con_number
                        AND mem_id = lic_mem_number
                        AND b.com_number = con_com_number
												--[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Commented as not required
												/*AND CASE
                               WHEN lic_status = 'C'
                               THEN
                                  CASE
                                     WHEN 'N' = 'Y' AND fl.lic_type = 'ROY'
                                     THEN
                                        pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
                                           fl.lic_number,
                                           6,
                                           2013)
                                     ELSE
                                        ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
                                                  fl.lic_number,
                                                  con_number,
                                                  fl.lic_currency,
                                                  LAST_DAY (i_period),
                                                  lsl.lsl_lee_price,
                                                  fl.lic_markup_percent,
                                                  lsl.lsl_number),
                                               2)
                                  END
                               ELSE
                                  -1
                            END < 0*/
                        AND fl.lic_type LIKE i_lic_type
                        AND fle.lee_short_name LIKE i_licensee
                        AND fl.lic_budget_code LIKE i_prg_type
                        AND b.com_short_name LIKE i_supp_srt_name
                        AND fc.com_short_name LIKE i_chnl_comp
                        AND fct.con_short_name LIKE i_contract
						--Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
						AND ( 

									 (   lic_acct_date > LAST_DAY(i_period)
									 OR  lic_acct_date IS NULL
									 )
									 OR
									 ( lic_acct_date < LAST_DAY(i_period)
									 AND NOT EXISTS ( SELECT 1 
														FROM FID_LICENSE_SUB_LEDGER flsl 
													   WHERE fl.lic_number = flsl.lis_lic_number
														 AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = TO_CHAR(i_period,'RRRRMM')
														 AND flsl.lis_lic_status = 'A'
														 AND flsl.lis_lic_start <= i_period
													)
									 ) 
							)
						--End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
                        AND fre.reg_code LIKE i_region
                        AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
						fid_payment b
					--	x_fin_realized_forex c
          WHERE     paid <> 0
                --AND pay_number = rzf_pay_number(+)
                AND pay_lic_number = lic_number
                AND pay_status = 'P'
                --deals having secondary licensee displaying payment twice
                AND pay_lsl_number = lsl_number
                AND pay_date <= LAST_DAY (i_period)
                --AND NVL (CONCAT(rzf_year,LPAD (rzf_month,2,0)),l_year||LPAD(l_month,2,0)) <= l_year||LPAD(l_month,2,0)
                --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
               -- AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
               -- AND to_number(to_char(pay_date, 'MM')) = rzf_month(+)
                --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
			 GROUP BY lic_type,
								lee_short_name,
								lic_budget_code,
								ter_cur_code,
								reg_code,
								channel_company,
								lic_currency;
								
    elsif(upper(i_rpt_type) ='DETAIL')  -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
    then
      OPEN o_c_comm_pmnt_rpt FOR
         SELECT ter_cur_code territory,
                reg_code region,
                pay_due,
                pay_amount payment_amount,
                --,pay_rate payment_rate
                channel_company,
                lic_type license_type,
                lee_short_name licensee,
                lic_budget_code program_type,
                DECODE (i_from_period, NULL, com_short_name, supplier)
                   supplier_name             --  ,com_short_name supplier_name
                                ,
                con_short_name contract_name,
                lic_number license_number,
                gen_title program_title,
                TO_CHAR (lic_acct_date, 'DD-MON-YYYY') account_date--,trunc(to_date(to_char(lic_start,'DD-MON-YYYY'),'DD-MON-YYYY')) license_start_date
                ,
                TO_CHAR (lic_start, 'DD-MON-YYYY') license_start_date,
                TO_CHAR (lic_end, 'DD-MON-YYYY') license_end_date,
                NVL (lsl_lee_price, 0) license_price,
                pay_code description               --  , pay_rate payment_rate
                                    ,
                ROUND (
                   ( (pay_amount * pay_rate) + x_fnc_get_total_rgl(pay_number,i_period))
                   / decode(pay_amount,0,1,pay_amount),--added Decode because pay_amount is geting zero
                   5)
                   payment_rate,   -- [Ver 0.1]
                (pay_amount * pay_rate) + x_fnc_get_total_rgl(pay_number,i_period)
                   local_payment_amount,
                TO_CHAR (pay_date, 'DD-MON-YYYY') paid_date,
                pay_status status,
                lsl_lee_price
                - (X_PKG_FIN_COMMITMNT_PMNT_RPT.total_paid_amt_per_lee (
                      lic_number,
                      lsl_number,
                      i_period))
                   license_currency_liability,
                pay_reference referencee,
                pay_comment payment_comments,
                lic_currency license_currency,
                TO_CHAR (l_rsa_ratedate, 'DD-MON-YYYY') rsa_ratedate,
                TO_NUMBER (
                   DECODE (
                      i_report_type,
                      'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                              lic_currency,
                              ter_cur_code,
                              l_rsa_ratedate),
                      'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                              lic_currency,
                              ter_cur_code,
                              l_lastdate)))
                   rsa_spotrate,
                TO_CHAR (l_afr_ratedate, 'DD-MON-YYYY') afr_ratedate,
                (X_PKG_FIN_COMMITMNT_PMNT_RPT.total_paid_amt_per_lee (
                    lic_number,
                    lsl_number,
                    i_period))
                   amt,
                DECODE (
                   i_report_type,
                   'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                           lic_currency,
                           ter_cur_code,
                           l_afr_ratedate),
                   'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                           lic_currency,
                           ter_cur_code,
                           l_lastdate))
                   afr_spotrate,
                (lsl_lee_price
                 - (X_PKG_FIN_COMMITMNT_PMNT_RPT.total_paid_amt_per_lee (
                       lic_number,
                       lsl_number,
                       i_period))
                   * DECODE (
                        i_report_type,
                        'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                                lic_currency,
                                ter_cur_code,
                                DECODE (reg_code,
                                        'RSA', l_rsa_ratedate,
                                        'AFR', l_afr_ratedate)),
                        'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                                lic_currency,
                                ter_cur_code,
                                l_lastdate)))
                   loc_curr_lia,
                ( (lsl_lee_price
                   - X_PKG_FIN_COMMITMNT_PMNT_RPT.total_paid_amt_per_lee (
                        lic_number,
                        lsl_number,
                        i_period))
                 * DECODE (
                      i_report_type,
                      'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                              lic_currency,
                              ter_cur_code,
                              l_afr_ratedate),
                      'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                              lic_currency,
                              ter_cur_code,
                              l_lastdate)))
                   loc_curr_lia_afr,
									 lic_status
           FROM (SELECT mem_agy_com_number,
                        fg.gen_title,
                        ft.ter_cur_code,
                        fc.com_number,
                        fc.com_name channel_company,
                        fc.com_short_name comp_short_name,
                        fl.lic_currency,
                        fl.lic_type,
                        lee_short_name,
                        lsl_number,
                        lsl_lee_price,
                        fl.lic_budget_code,
                        b.com_short_name supplier,
                        fct.con_short_name,
                        fc.com_ter_code,
                        con_number,
                        fl.lic_number,
                        lic_gen_refno,
                        lic_amort_code,
                        ROUND (fl.lic_price, 2) lic_price,
                       --fc.com_short_name,
                        b.com_short_name,
                        lic_markup_percent,
                        lic_acct_date--TO_CHAR(lic_acct_date,'YYYY.MM') LIC_ACCT_DATE
                        ,
                        lic_start,
                        lic_end,
						--[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Added 
						(SELECT ROUND(NVL(SUM (pay_amount),0),2)
						   FROM fid_payment, fid_payment_type
						  WHERE pat_code = pay_code
						    AND pay_lic_number = fl.lic_number
						    AND pay_con_number = FL.lic_con_number
						    AND pay_cur_code = fl.lic_currency
						    AND pay_lsl_number = lsl.lsl_number
						    AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <= LAST_DAY(i_period)
							AND pay_status IN ('P', 'I')
						    AND pat_group = 'F'
						) paid,
						fre.reg_code,
            (CASE WHEN (lic_acct_date > LAST_DAY(i_period) OR  lic_acct_date IS NULL)
            THEN fl.lic_status
            ELSE
                (
                  SELECT LIS_LIC_STATUS FROM FID_LICENSE_SUB_LEDGER
                  WHERE LIS_LIC_NUMBER = FL.LIC_NUMBER
                  AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = TO_CHAR(i_period,'RRRRMM')
                )
            END) lic_status   --[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Added lic status 
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
					AND fc.com_type IN ('CC', 'BC')
					AND fle.lee_number = lsl.lsl_lee_number
					AND fl.lic_number = lsl.lsl_lic_number
					AND con_number = lic_con_number
					AND mem_id = lic_mem_number
					AND b.com_number = con_com_number
									  --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I-Commented
										/*AND CASE
                               WHEN lic_status = 'C'
                               THEN
                                  CASE
                                     WHEN 'N' = 'Y' AND fl.lic_type = 'ROY'
                                     THEN
                                        pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
                                           fl.lic_number,
                                           6,
                                           2013)
                                     ELSE
                                        ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
                                                  fl.lic_number,
                                                  con_number,
                                                  fl.lic_currency,
                                                  LAST_DAY (i_period),
                                                  lsl.lsl_lee_price,
                                                  fl.lic_markup_percent,
                                                  lsl.lsl_number),
                                               2)
                                  END
                               ELSE
                                  -1
												END < 0*/
												--End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I-Commented
                        AND fl.lic_type LIKE i_lic_type
                        AND fle.lee_short_name LIKE i_licensee
                        AND fl.lic_budget_code LIKE i_prg_type
                        AND b.com_short_name LIKE i_supp_srt_name
                        AND fc.com_short_name LIKE i_chnl_comp
                        AND fct.con_short_name LIKE i_contract
						--Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
						AND ( 
						
									 (   lic_acct_date > LAST_DAY(i_period)
									 OR  lic_acct_date IS NULL
									 )
									 OR
									 ( lic_acct_date < i_period
									 AND NOT EXISTS ( SELECT 1 
														FROM FID_LICENSE_SUB_LEDGER flsl 
													   WHERE fl.lic_number = flsl.lis_lic_number
														 AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = TO_CHAR(i_period,'RRRRMM')
														 AND flsl.lis_lic_status = 'A'
														 AND flsl.lis_lic_start <= i_period
													)
									 ) 
							)
						--End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
                        AND fle.lee_split_region = fre.reg_id(+)
                        AND fre.reg_code LIKE i_region
                        AND lic_status NOT IN ('B', 'F', 'T')
						
						
						) a, --added so that t licenses should not be displayed
												fid_payment b
												--x_fin_realized_forex c
          WHERE     paid <> 0
                --AND ROWNUM  <100
              --  AND pay_number = rzf_pay_number(+)
                AND pay_lic_number = lic_number
                AND pay_status = 'P'
                --deals having secondary licensee displaying payment twice
                AND pay_lsl_number = lsl_number
                AND pay_date <= LAST_DAY (i_period)
                AND TRUNC (pay_date) BETWEEN TRUNC (NVL(TRUNC(i_from_period,'MON'),pay_date)) AND LAST_DAY(i_period)
          ORDER BY channel_company,pay_lic_number,pay_date
           ;
                ----to_date('01-JUL-2013') AND to_date('31-JUL-2013')
               -- AND NVL(CONCAT(rzf_year,LPAD(rzf_month,2,0)),l_year||LPAD(l_month,2,0)) <= l_year||LPAD (l_month, 2, 0)
                --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
               -- AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
               -- AND to_number(to_char(pay_date, 'MM')) = rzf_month(+);
                --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
    end if;		---- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0

  --  DBMS_OUTPUT.PUT_LINE(l_stmt_str);
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_fin_comm_pmnt_rpt_after;

   PROCEDURE prc_fin_comm_pmnt_exl_after (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      i_type              IN      VARCHAR2, -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
      o_c_comm_pmnt_rpt      OUT X_PKG_FIN_COMMITMNT_PMNT_RPT.c_comm_pmnt_rpt)
   AS
      l_year           NUMBER;
      l_month          NUMBER;
      l_rsa_ratedate   DATE;
      l_afr_ratedate   DATE;
      l_lastdate       DATE;
      l_firstdate      DATE;
   BEGIN
      l_month := TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'MM'));
      l_year := TO_NUMBER (TO_CHAR (i_period, 'YYYY'));
	  
	  DELETE X_TBL_GTT_CONTENT_FILTER;
	  COMMIT;
	  
	  INSERT INTO X_TBL_GTT_CONTENT_FILTER
	  SELECT DISTINCT lis_lic_number
	    FROM FID_LICENSE_SUB_LEDGER flsl 
       WHERE LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = TO_CHAR(i_period,'RRRRMM')
	     AND lis_lic_status = 'A'
	     AND lis_lic_start <= i_period;
	   COMMIT;

      --   TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'YYYY'));

      ------------------Calculate Rate Date ---------------------------------------------------------------------------
      IF UPPER (i_region) = 'RSA'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE     fmd_month = l_month
                   AND fmd_year = l_year
                   AND reg_id = fmd_region
                   AND UPPER (fmd_mon_end_type) = 'FINAL'
                   AND UPPER (reg_code) = i_region;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;
      ELSIF UPPER (i_region) = 'AFR'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE     fmd_month = l_month
                   AND fmd_year = l_year
                   AND reg_id = fmd_region
                   AND UPPER (fmd_mon_end_type) = 'FINAL'
                   AND UPPER (reg_code) = i_region;
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
             WHERE     fmd_month = l_month
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
             WHERE     fmd_month = l_month
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

      --------------------------------------------------------------------------------------------------------------------
      SELECT LAST_DAY (i_period) INTO l_lastdate FROM DUAL;

      SELECT ADD_MONTHS (LAST_DAY (l_lastdate), -1) + 1
        INTO l_firstdate
        FROM DUAL;

      DBMS_OUTPUT.put_line ('i_from_period :' || i_from_period);

      IF(UPPER(i_rpt_type) = 'SUMMARY') -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
      THEN
         OPEN o_c_comm_pmnt_rpt FOR
        SELECT reg_code "Region",
               channel_company "Channel Company",
               lic_currency "License Currency",
               lic_type "License Type",
               lee_short_name "Licensee",
               lic_budget_code "Programme Type",
               SUM(pay_amount) "Payment Amount",
               SUM((pay_amount * pay_rate) + x_fnc_get_total_rgl(pay_number,i_period))"Local Payment Amount"
          FROM (SELECT mem_agy_com_number,
                       fg.gen_title,
                       ft.ter_cur_code,
                       fc.com_number,
                       fc.com_name channel_company,
                       fc.com_short_name comp_short_name,
                       fl.lic_currency,
                       fl.lic_type,
                       lee_short_name,
                       lsl_number,
                       lsl_lee_price,
                       fl.lic_budget_code,
                       b.com_short_name supplier,
                       fct.con_short_name,
                       fc.com_ter_code,
                       con_number,
                       fl.lic_number,
                       lic_gen_refno,
                       lic_amort_code,
                       ROUND (fl.lic_price, 2) lic_price,
                       fc.com_short_name,
                       lic_markup_percent,
                       lic_acct_date--TO_CHAR(lic_acct_date,'YYYY.MM') LIC_ACCT_DATE
                       ,
                       lic_start,
                       lic_end,
       --Start [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Added
        (SELECT ROUND(NVL(SUM (pay_amount),0),2)
           FROM fid_payment, fid_payment_type
          WHERE pat_code = pay_code
            AND pay_lic_number = fl.lic_number
            AND pay_con_number = FL.lic_con_number
            AND pay_cur_code = fl.lic_currency
            AND pay_lsl_number = lsl.lsl_number
            AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <= LAST_DAY(i_period)
            AND pay_status IN ('P', 'I')
            AND pat_group = 'F'
        )paid,
       --End [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Added 
                       fre.reg_code
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
                 WHERE     lee_cha_com_number = fc.com_number
                       AND gen_refno = lic_gen_refno
                       AND ter_code = fc.com_ter_code
                       AND fc.com_type IN ('CC', 'BC')
                       AND fle.lee_number = lsl.lsl_lee_number
                       AND fl.lic_number = lsl.lsl_lic_number
                       AND con_number = lic_con_number
                       AND mem_id = lic_mem_number
                       AND b.com_number = con_com_number
                        --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Commented as not required
                       /*AND CASE
                              WHEN lic_status = 'C'
                              THEN
                                 CASE
                                    WHEN 'N' = 'Y'
                                         AND fl.lic_type = 'ROY'
                                    THEN
                                       pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
                                          fl.lic_number,
                                          6,
                                          2013)
                                    ELSE
                                       ROUND (
                                          pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
                                             fl.lic_number,
                                             con_number,
                                             fl.lic_currency,
                                             LAST_DAY (i_period),
                                             lsl.lsl_lee_price,
                                             fl.lic_markup_percent,
                                             lsl.lsl_number),
                                          2)
                                 END
                              ELSE
                                 -1
                           END < 0*/
                        --End [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Commented as not required
                       AND fl.lic_type LIKE i_lic_type
                       AND fle.lee_short_name LIKE i_licensee
                       AND fl.lic_budget_code LIKE i_prg_type
                       AND b.com_short_name LIKE i_supp_srt_name
                       AND fc.com_short_name LIKE i_chnl_comp
                       AND fct.con_short_name LIKE i_contract
         --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
         AND ( 

             (   lic_acct_date > LAST_DAY(i_period)
             OR  lic_acct_date IS NULL
             )
             OR
             ( lic_acct_date < LAST_DAY(i_period)
             AND NOT EXISTS ( SELECT 1 
                      FROM FID_LICENSE_SUB_LEDGER flsl 
                       WHERE fl.lic_number = flsl.lis_lic_number
                       AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = TO_CHAR(i_period,'RRRRMM')
                       AND flsl.lis_lic_status = 'A'
                       AND flsl.lis_lic_start <= i_period
                    )
             ) 
          )
        --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
                       AND fle.lee_split_region = fre.reg_id(+)
                       AND fre.reg_code LIKE i_region
                       AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
               fid_payment b
              -- x_fin_realized_forex c
         WHERE     paid <> 0
               --AND pay_number = rzf_pay_number(+)
               AND pay_lic_number = lic_number
               AND pay_status = 'P'
               --deals having secondary licensee displaying payment twice
               AND pay_lsl_number = lsl_number
               AND pay_date <= LAST_DAY (i_period)
               AND TRUNC (pay_date) BETWEEN TRUNC (NVL(TRUNC(i_from_period,'MON'),pay_date))AND TRUNC (DECODE (i_from_period,NULL, pay_date,LAST_DAY (i_period)));
             --  AND NVL(CONCAT(rzf_year,LPAD(rzf_month,2,0)),l_year||LPAD(l_month,2,0)) <= l_year||LPAD(l_month,2,0)
               --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
             --  AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
              -- AND to_number(to_char(pay_date, 'MM')) = rzf_month(+);
               --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I

      ELSIF UPPER(i_rpt_type) = 'DETAIL'
			THEN
				IF (i_from_period IS NOT NULL)
				THEN
				 OPEN o_c_comm_pmnt_rpt FOR
				SELECT reg_code "Region",
							 channel_company "Channel Company",
							 lic_currency "License Currency",
							 lic_type "License Type",
							 lee_short_name "Licensee",
							 lic_budget_code "Programme Type",
							 supplier "Supplier",
							 lic_number "License Number",
							 GEN_TITLE "Programme Title",
							 TO_CHAR (lic_start, 'DD-MON-RRRR') "License Start Date",
							 (X_PKG_FIN_COMMITMNT_PMNT_RPT.total_paid_amt_per_lee (
									 lic_number,
									 lsl_number,
									 i_period))
									"License Price",
							 pay_code "Pay Code",
							 pay_amount "Payment Amount",
							 ROUND (
									( (pay_amount * pay_rate) + x_fnc_get_total_rgl(pay_number,i_period))
									/ decode(pay_amount,0,1,pay_amount),--added Decode because pay_amount is geting zero,
									5)   -- [Ver 0.1]
									"Payment Rate",
							 (pay_amount * pay_rate) + x_fnc_get_total_rgl(pay_number,i_period)
									"Local Payment Amount",
							 TO_CHAR (pay_date, 'DD-MON-RRRR') "Paid Date",
							 pay_status "Status",
							 pay_reference "Reference",
							 pay_comment "Payment Comments",
							 lic_status
					FROM (SELECT mem_agy_com_number,
							 fg.gen_title,
							 ft.ter_cur_code,
							 fc.com_number,
							 fc.com_name channel_company,
							 fc.com_short_name comp_short_name,
							 fl.lic_currency,
							 fl.lic_type,
							 lee_short_name,
							 lsl_number,
							 lsl_lee_price,
							 fl.lic_budget_code,
							 b.com_short_name supplier,
							 fct.con_short_name,
							 fc.com_ter_code,
							 con_number,
							 fl.lic_number,
							 lic_gen_refno,
							 lic_amort_code,
							 ROUND (fl.lic_price, 2) lic_price,
							 fc.com_short_name,
							 lic_markup_percent,
							 lic_acct_date,--TO_CHAR(lic_acct_date,'YYYY.MM') LIC_ACCT_DATE
							 lic_start,
							 lic_end,
							 --Start [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Added
								(SELECT ROUND(NVL(SUM (pay_amount),0),2)
									 FROM fid_payment, fid_payment_type
									WHERE pat_code = pay_code
										AND pay_lic_number = fl.lic_number
										AND pay_con_number = FL.lic_con_number
										AND pay_cur_code = fl.lic_currency
										AND pay_lsl_number = lsl.lsl_number
										AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <= LAST_DAY(i_period)
										AND pay_status IN ('P', 'I')
										AND pat_group = 'F'
								)paid,
                (CASE WHEN (lic_acct_date > LAST_DAY(i_period) OR  lic_acct_date IS NULL)
                  THEN fl.lic_status
                  ELSE
                      (
                        SELECT LIS_LIC_STATUS FROM FID_LICENSE_SUB_LEDGER
                        WHERE LIS_LIC_NUMBER = FL.LIC_NUMBER
                        AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = TO_CHAR(i_period,'RRRRMM')
                      )
                  END) lic_status,
							 --End [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Added
							 fre.reg_code
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
					WHERE     lee_cha_com_number = fc.com_number
							 AND gen_refno = lic_gen_refno
							 AND ter_code = fc.com_ter_code
							 AND fc.com_type IN ('CC', 'BC')
							 AND fle.lee_number = lsl.lsl_lee_number
							 AND fl.lic_number = lsl.lsl_lic_number
							 AND con_number = lic_con_number
							 AND mem_id = lic_mem_number
							 AND b.com_number = con_com_number
							 --Start [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Commented as not required
							 /*AND CASE
											WHEN lic_status = 'C'
											THEN
												 CASE
														WHEN 'N' = 'Y'
																 AND fl.lic_type = 'ROY'
														THEN
															 pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
																	fl.lic_number,
																	6,
																	2013)
														ELSE
															 ROUND (
																	pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
																		 fl.lic_number,
																		 con_number,
																		 fl.lic_currency,
																		 LAST_DAY (i_period),
																		 lsl.lsl_lee_price,
																		 fl.lic_markup_percent,
																		 lsl.lsl_number),
																	2)
												 END
											ELSE
												 -1
									 END < 0*/
							 --End [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Commented as not required
							 AND fl.lic_type LIKE i_lic_type
							 AND fle.lee_short_name LIKE i_licensee
							 AND fl.lic_budget_code LIKE i_prg_type
							 AND b.com_short_name LIKE i_supp_srt_name
							 AND fc.com_short_name LIKE i_chnl_comp
							 AND fct.con_short_name LIKE i_contract
							--Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
							   AND ( 

										 (   lic_acct_date > LAST_DAY(i_period)
										 OR  lic_acct_date IS NULL
										 )
										 OR
										 ( lic_acct_date < LAST_DAY(i_period)
										 AND NOT EXISTS ( SELECT 1 
																       FROM X_TBL_GTT_CONTENT_FILTER flsl 
															          WHERE fl.lic_number = flsl.FL_GEN_REFNO    --temp table with lic_numbers
														)
										 ) 
								         )
											AND EXISTS  (
														SELECT 1
														 FROM fid_payment, fid_payment_type
														WHERE pat_code = pay_code
															AND pay_lic_number = fl.lic_number
															AND pay_con_number = FL.lic_con_number
															AND pay_cur_code = fl.lic_currency
															AND pay_lsl_number = lsl.lsl_number
															AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <= LAST_DAY(i_period)
															AND pay_status IN ('P', 'I')
															AND pay_date <= LAST_DAY (i_period)
															AND pay_date BETWEEN TRUNC(NVL(TRUNC(i_from_period,'MON'),pay_date)) AND TRUNC (DECODE (i_from_period,NULL, pay_date,LAST_DAY (i_period)))
															AND pat_group = 'F'
															HAVING ROUND(NVL(SUM (pay_amount),0),2) <> 0
														)
									
								--End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
							 AND fle.lee_split_region = fre.reg_id(+)
							 AND fre.reg_code LIKE i_region
							 AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
							  fid_payment b
							 -- x_fin_realized_forex c
					WHERE paid <> 0
					--AND pay_number = rzf_pay_number(+)
					AND pay_lic_number = lic_number
					AND pay_status = 'P'
					--deals having secondary licensee displaying payment twice
					AND pay_lsl_number = lsl_number
					AND pay_date <= LAST_DAY (i_period)
					AND TRUNC (pay_date) BETWEEN TRUNC(NVL(TRUNC(i_from_period,'MON'),pay_date)) AND TRUNC(DECODE(i_from_period,NULL,pay_date,LAST_DAY (i_period)));
					--AND NVL(CONCAT(rzf_year,LPAD(rzf_month,2,0)),l_year||LPAD(l_month,2,0)) <= l_year||LPAD(l_month,2,0)
          --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
          --AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
          --AND to_number(to_char(pay_date, 'MM')) = rzf_month(+);
          --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
				ELSE
				OPEN o_c_comm_pmnt_rpt FOR
				 SELECT reg_code "region",
							 TER_CUR_CODE "territory",
							 TO_CHAR(pay_due, 'DD-MON-RRRR') "pay_due",
							 pay_amount "payment_amount",
							 pay_rate "payment_rate",
							 channel_company "channel company",
							 lic_type "license type",
							 lee_short_name "licensee",
							 lic_budget_code "programmme type",
							 com_short_name "supplier name",
							 con_short_name "contract name",
							 lic_number "license number",
							 gen_title "programme title",
							-- TO_DATE (TO_CHAR (lic_acct_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') "account date",
							 TO_CHAR (lic_acct_date, 'DD-MON-RRRR') "account date",
							 TO_CHAR (LIC_START, 'DD-MON-RRRR') "license start date",
							 TO_CHAR (lic_end, 'DD-MON-RRRR') "license end date",
							 NVL (lsl_lee_price, 0) "license price",
							 pay_code "description",
							 ROUND (
									( (pay_amount * pay_rate) +x_fnc_get_total_rgl(pay_number,i_period))
									/ decode(pay_amount,0,1,pay_amount),--added Decode because pay_amount is geting zero,
									5)
									"payment rate",   -- [Ver 0.1]
							 (pay_amount * pay_rate) + x_fnc_get_total_rgl(pay_number,i_period)
									"local payment amount",
							 TO_CHAR (pay_date, 'DD-MON-RRRR') "paid date",
							 pay_status "status",
							 lsl_lee_price
							 - (X_PKG_FIN_COMMITMNT_PMNT_RPT.total_paid_amt_per_lee (
										 lic_number,
										 lsl_number,
										 i_period))
									"license currency liability",
							 pay_reference "reference",
							 pay_comment "payment comments",
							 lic_currency "license_currency",
							 TO_CHAR (l_rsa_ratedate, 'DD-MON-YYYY') "rsa ratedate",
							 TO_NUMBER (
									DECODE (
										 i_report_type,
										 'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
														 lic_currency,
														 ter_cur_code,
														 l_rsa_ratedate),
										 'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
														 lic_currency,
														 ter_cur_code,
														 l_lastdate)))
									"rsa spotrate",
							 TO_CHAR (l_afr_ratedate, 'DD-MON-RRRR') "afr ratedate",
							 (X_PKG_FIN_COMMITMNT_PMNT_RPT.total_paid_amt_per_lee (
									 lic_number,
									 lsl_number,
									 i_period))
									"amount",
							 DECODE (
									i_report_type,
									'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
													lic_currency,
													ter_cur_code,
													l_afr_ratedate),
									'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
													lic_currency,
													ter_cur_code,
													l_lastdate))
									"afr spotrate",
							 (lsl_lee_price
								- (X_PKG_FIN_COMMITMNT_PMNT_RPT.total_paid_amt_per_lee (
											lic_number,
											lsl_number,
											i_period))
									* DECODE (
											 i_report_type,
											 'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
															 lic_currency,
															 ter_cur_code,
															 DECODE (reg_code,
																			 'RSA', l_rsa_ratedate,
																			 'AFR', l_afr_ratedate)),
											 'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
															 lic_currency,
															 ter_cur_code,
															 l_lastdate)))
									"loc_curr_lia",
							 ( (lsl_lee_price
									- X_PKG_FIN_COMMITMNT_PMNT_RPT.total_paid_amt_per_lee (
											 lic_number,
											 lsl_number,
											 i_period))
								* DECODE (
										 i_report_type,
										 'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
														 lic_currency,
														 ter_cur_code,
														 l_afr_ratedate),
										 'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
														 lic_currency,
														 ter_cur_code,
														 l_lastdate)))
									"loc_curr_lia_afr",
									lic_status
					FROM (SELECT mem_agy_com_number,
											 fg.gen_title,
											 ft.ter_cur_code,
											 fc.com_number,
											 fc.com_name channel_company,
											 fc.com_short_name comp_short_name,
											 fl.lic_currency,
											 fl.lic_type,
											 lee_short_name,
											 lsl_number,
											 lsl_lee_price,
											 fl.lic_budget_code,
											 b.com_short_name supplier,
											 fct.con_short_name,
											 fc.com_ter_code,
											 con_number,
											 fl.lic_number,
											 lic_gen_refno,
											 lic_amort_code,
											 ROUND (fl.lic_price, 2) lic_price,
											 --fc.com_short_name,
												b.com_short_name,
											 lic_markup_percent,
											 lic_acct_date--TO_CHAR(lic_acct_date,'YYYY.MM') LIC_ACCT_DATE
											 ,
											 lic_start,
											 lic_end,
											 --Start [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Added
												(SELECT ROUND(NVL(SUM (pay_amount),0),2)
													 FROM fid_payment, fid_payment_type
													WHERE pat_code = pay_code
														AND pay_lic_number = fl.lic_number
														AND pay_con_number = FL.lic_con_number
														AND pay_cur_code = fl.lic_currency
														AND pay_lsl_number = lsl.lsl_number
														AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <= LAST_DAY(i_period)
														AND pay_status IN ('P', 'I')
														AND pat_group = 'F'
												)paid,
                      (CASE WHEN (lic_acct_date > LAST_DAY(i_period) OR  lic_acct_date IS NULL)
                        THEN fl.lic_status
                        ELSE
                            (
                              SELECT LIS_LIC_STATUS FROM FID_LICENSE_SUB_LEDGER
                              WHERE LIS_LIC_NUMBER = FL.LIC_NUMBER
                              AND LIS_PER_YEAR||LPAD(LIS_PER_MONTH,2,0) = TO_CHAR(i_period,'RRRRMM')
                            )
                        END) lic_status,
											 --End [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Added
											 fre.reg_code
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
								 WHERE       lee_cha_com_number = fc.com_number
											 AND gen_refno = lic_gen_refno
											 AND ter_code = fc.com_ter_code
											 AND fc.com_type IN ('CC', 'BC')
											 AND fle.lee_number = lsl.lsl_lee_number
											 AND fl.lic_number = lsl.lsl_lic_number
											 AND con_number = lic_con_number
											 AND mem_id = lic_mem_number
											 AND b.com_number = con_com_number
												--Start [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Commented as not required
												/*AND CASE
												WHEN lic_status = 'C'
												THEN
												 CASE
														WHEN 'N' = 'Y'
																 AND fl.lic_type = 'ROY'
														THEN
															 pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
																	fl.lic_number,
																	6,
																	2013)
														ELSE
															 ROUND (
																	pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
																		 fl.lic_number,
																		 con_number,
																		 fl.lic_currency,
																		 LAST_DAY (i_period),
																		 lsl.lsl_lee_price,
																		 fl.lic_markup_percent,
																		 lsl.lsl_number),
																	2)
												 END
												ELSE
												 -1
												END < 0*/
											 --End [20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I - Commented as not required
											 AND fl.lic_type LIKE i_lic_type
											 AND fle.lee_short_name LIKE i_licensee
											 AND fl.lic_budget_code LIKE i_prg_type
											 AND b.com_short_name LIKE i_supp_srt_name
											 AND fc.com_short_name LIKE i_chnl_comp
											 AND fct.con_short_name LIKE i_contract
											--Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
											AND ( 

													(   lic_acct_date > LAST_DAY(i_period)
													OR  lic_acct_date IS NULL
													)
													OR
													( lic_acct_date < LAST_DAY(i_period)
													AND NOT EXISTS ( SELECT 1 
																       FROM X_TBL_GTT_CONTENT_FILTER flsl 
															          WHERE fl.lic_number = flsl.FL_GEN_REFNO    --temp table with lic_numbers
															        )
													) 
												)
											AND EXISTS  (
														SELECT 1
														 FROM fid_payment, fid_payment_type
														WHERE pat_code = pay_code
															AND pay_lic_number = fl.lic_number
															AND pay_con_number = FL.lic_con_number
															AND pay_cur_code = fl.lic_currency
															AND pay_lsl_number = lsl.lsl_number
															AND TO_DATE (TO_CHAR (pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') <= LAST_DAY(i_period)
															AND pay_status IN ('P', 'I')
															AND pay_date <= LAST_DAY (i_period)
															AND pay_date BETWEEN TRUNC(NVL(TRUNC(i_from_period,'MON'),pay_date)) AND TRUNC (DECODE (i_from_period,NULL, pay_date,LAST_DAY (i_period)))
															AND pat_group = 'F'
															HAVING ROUND(NVL(SUM (pay_amount),0),2) <> 0
														)
											--End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
											 AND fle.lee_split_region = fre.reg_id(+)
											 AND fre.reg_code LIKE i_region
											 AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
											 fid_payment b
											-- x_fin_realized_forex c
				 WHERE     paid <> 0
							-- AND pay_number = rzf_pay_number(+)
							 AND pay_lic_number = lic_number
							 AND pay_status = 'P'
							 --deals having secondary licensee displaying payment twice
							 AND pay_lsl_number = lsl_number
							 AND pay_date <= LAST_DAY (i_period)
							 AND TRUNC (pay_date) BETWEEN TRUNC(NVL(TRUNC(i_from_period,'MON'),pay_date)) AND TRUNC (DECODE (i_from_period,NULL, pay_date,LAST_DAY (i_period)));
							-- AND NVL (CONCAT(rzf_year,LPAD(rzf_month,2,0)),l_year||LPAD(l_month,2,0)) <= l_year||LPAD(l_month,2,0)
               --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
              -- AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
              -- AND to_number(to_char(pay_date, 'MM')) = rzf_month(+);
               --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
				END IF;
				END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_fin_comm_pmnt_exl_after;

   PROCEDURE prc_fin_comm_pmnt_exl_before (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      i_type              IN     VARCHAR2, -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
      o_c_comm_pmnt_rpt   OUT    x_pkg_fin_commitmnt_pmnt_rpt.c_comm_pmnt_rpt)
   AS
      l_year           NUMBER;
      l_month          NUMBER;
      l_rsa_ratedate   DATE;
      l_afr_ratedate   DATE;
      l_lastdate       DATE;
      l_firstdate      DATE;
   BEGIN
      l_month := TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'MM'));
      l_year := TO_NUMBER (TO_CHAR (i_period, 'YYYY'));

      --   TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'YYYY'));

      ------------------Calculate Rate Date ---------------------------------------------------------------------------
      IF UPPER (i_region) = 'RSA'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE     fmd_month = l_month
                   AND fmd_year = l_year
                   AND reg_id = fmd_region
                   AND UPPER (fmd_mon_end_type) = 'FINAL'
                   AND UPPER (reg_code) = i_region;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;
      ELSIF UPPER (i_region) = 'AFR'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE     fmd_month = l_month
                   AND fmd_year = l_year
                   AND reg_id = fmd_region
                   AND UPPER (fmd_mon_end_type) = 'FINAL'
                   AND UPPER (reg_code) = i_region;
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
             WHERE     fmd_month = l_month
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
             WHERE     fmd_month = l_month
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

      --------------------------------------------------------------------------------------------------------------------
      SELECT LAST_DAY (i_period) INTO l_lastdate FROM DUAL;

      SELECT ADD_MONTHS (LAST_DAY (l_lastdate), -1) + 1
        INTO l_firstdate
        FROM DUAL;

      DBMS_OUTPUT.put_line ('i_from_period :' || i_from_period);

      IF (i_from_period IS NOT NULL)
      THEN
         DBMS_OUTPUT.put_line ('inside i_from_period is not null');

          IF(UPPER(i_rpt_type) = 'SUMMARY') -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
            THEN
                 OPEN o_c_comm_pmnt_rpt FOR
                SELECT reg_code "Region",
                       channel_company "Channel Company",
                       lic_currency "License Currency",
                       lic_type "License Type",
                       lee_short_name "Licensee",
                       lic_budget_code "Programme Type",
                       SUM(pay_amount) "Payment Amount",
                       SUM((pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period))"Local Payment Amount"
                  FROM (SELECT mem_agy_com_number,
                               fg.gen_title,
                               ft.ter_cur_code,
                               fc.com_number,
                               fc.com_name channel_company,
                               fc.com_short_name comp_short_name,
                               fl.lic_currency,
                               fl.lic_type,
                               lee_short_name,
                               lsl_number,
                               lsl_lee_price,
                               fl.lic_budget_code,
                               b.com_short_name supplier,
                               fct.con_short_name,
                               fc.com_ter_code,
                               con_number,
                               fl.lic_number,
                               lic_gen_refno,
                               lic_amort_code,
                               ROUND (fl.lic_price, 2) lic_price,
                               fc.com_short_name,
                               lic_markup_percent,
                               lic_acct_date--TO_CHAR(lic_acct_date,'YYYY.MM') LIC_ACCT_DATE
                               ,
                               lic_start,
                               lic_end,
                               ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_paid (
                                         fl.lic_number,
                                         con_number,
                                         fl.lic_currency,
                                         lsl.lsl_number,
                                         LAST_DAY (i_period)),
                                      2)
                                  paid,
                               fre.reg_code
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
                         WHERE     lee_cha_com_number = fc.com_number
                               AND gen_refno = lic_gen_refno
                               AND ter_code = fc.com_ter_code
                               AND fc.com_type IN ('CC', 'BC')
                               AND fle.lee_number = lsl.lsl_lee_number
                               AND fl.lic_number = lsl.lsl_lic_number
                               AND con_number = lic_con_number
                               AND mem_id = lic_mem_number
                               AND b.com_number = con_com_number
                               AND CASE
                                      WHEN lic_status = 'C'
                                      THEN
                                         CASE
                                            WHEN 'N' = 'Y'
                                                 AND fl.lic_type = 'ROY'
                                            THEN
                                               pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
                                                  fl.lic_number,
                                                  6,
                                                  2013)
                                            ELSE
                                               ROUND (
                                                  pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
                                                     fl.lic_number,
                                                     con_number,
                                                     fl.lic_currency,
                                                     LAST_DAY (i_period),
                                                     lsl.lsl_lee_price,
                                                     fl.lic_markup_percent,
                                                     lsl.lsl_number),
                                                  2)
                                         END
                                      ELSE
                                         -1
                                   END < 0
                               AND fl.lic_type LIKE i_lic_type
                               AND fle.lee_short_name LIKE i_licensee
                               AND fl.lic_budget_code LIKE i_prg_type
                               AND b.com_short_name LIKE i_supp_srt_name
                               AND fc.com_short_name LIKE i_chnl_comp
                               AND fct.con_short_name LIKE i_contract
                               -- AND    ( lic_acct_date >= last_day(i_period) OR lic_acct_date IS NULL )
                               AND ( ( (lic_acct_date > LAST_DAY (i_period))
                                      OR (lic_start > LAST_DAY (i_period)))
                                    OR lic_acct_date IS NULL)
                               AND fle.lee_split_region = fre.reg_id(+)
                               AND fre.reg_code LIKE i_region
                               AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
                       fid_payment b
                       --x_fin_realized_forex c
                 WHERE     paid <> 0
                       --AND pay_number = rzf_pay_number(+)
                       AND pay_lic_number = lic_number
                       AND pay_status = 'P'
                       --deals having secondary licensee displaying payment twice
                       AND pay_lsl_number = lsl_number
                       AND pay_date <= LAST_DAY (i_period)
                       AND TRUNC (pay_date) BETWEEN TRUNC (
                                                       NVL (
                                                          TRUNC (i_from_period,
                                                                 'MON'),
                                                          pay_date))
                                                AND TRUNC (
                                                       DECODE (
                                                          i_from_period,
                                                          NULL, pay_date,
                                                          LAST_DAY (i_period)));
                       --and trunc(pay_date) between nvl(i_from_period,pay_date)
                       --      and decode(i_from_period,null,pay_date,i_period)
                      /* AND NVL (CONCAT (rzf_year, LPAD (rzf_month, 2, 0)),
                                l_year || LPAD (l_month, 2, 0)) <=
                              l_year || LPAD (l_month, 2, 0);*/
          ELSE
             OPEN o_c_comm_pmnt_rpt FOR
                SELECT reg_code "Region",
                       channel_company "Channel Company",
                       lic_currency "License Currency",
                       lic_type "License Type",
                       lee_short_name "Licensee",
                       lic_budget_code "Programme Type",
                       supplier "Supplier",
                       lic_number "License Number",
                       GEN_TITLE "Programme Title",
                       TO_CHAR (lic_start, 'DD-MON-RRRR') "License Start Date",
                       (x_pkg_fin_commitmnt_pmnt_rpt.total_paid_amt_per_lee (
                           lic_number,
                           lsl_number,
                           i_period))
                          "License Price",
                       pay_code "Pay Code",
                       pay_amount "Payment Amount",
                       ROUND (
                          ( (pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period))
                          / pay_amount,
                          5)
                          "Payment Rate",   -- [Ver 0.1]
                       (pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period)
                          "Local Payment Amount",
                       TO_CHAR (pay_date, 'DD-MON-RRRR') "Paid Date",
                       pay_status "Status",
                       pay_reference "Reference",
                       pay_comment "Payment Comments"
                  FROM (SELECT mem_agy_com_number,
                               fg.gen_title,
                               ft.ter_cur_code,
                               fc.com_number,
                               fc.com_name channel_company,
                               fc.com_short_name comp_short_name,
                               fl.lic_currency,
                               fl.lic_type,
                               lee_short_name,
                               lsl_number,
                               lsl_lee_price,
                               fl.lic_budget_code,
                               b.com_short_name supplier,
                               fct.con_short_name,
                               fc.com_ter_code,
                               con_number,
                               fl.lic_number,
                               lic_gen_refno,
                               lic_amort_code,
                               ROUND (fl.lic_price, 2) lic_price,
                               fc.com_short_name,
                               lic_markup_percent,
                               lic_acct_date--TO_CHAR(lic_acct_date,'YYYY.MM') LIC_ACCT_DATE
                               ,
                               lic_start,
                               lic_end,
                               ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_paid (
                                         fl.lic_number,
                                         con_number,
                                         fl.lic_currency,
                                         lsl.lsl_number,
                                         LAST_DAY (i_period)),
                                      2)
                                  paid,
                               fre.reg_code
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
                         WHERE     lee_cha_com_number = fc.com_number
                               AND gen_refno = lic_gen_refno
                               AND ter_code = fc.com_ter_code
                               AND fc.com_type IN ('CC', 'BC')
                               AND fle.lee_number = lsl.lsl_lee_number
                               AND fl.lic_number = lsl.lsl_lic_number
                               AND con_number = lic_con_number
                               AND mem_id = lic_mem_number
                               AND b.com_number = con_com_number
                               AND CASE
                                      WHEN lic_status = 'C'
                                      THEN
                                         CASE
                                            WHEN 'N' = 'Y'
                                                 AND fl.lic_type = 'ROY'
                                            THEN
                                               pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
                                                  fl.lic_number,
                                                  6,
                                                  2013)
                                            ELSE
                                               ROUND (
                                                  pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
                                                     fl.lic_number,
                                                     con_number,
                                                     fl.lic_currency,
                                                     LAST_DAY (i_period),
                                                     lsl.lsl_lee_price,
                                                     fl.lic_markup_percent,
                                                     lsl.lsl_number),
                                                  2)
                                         END
                                      ELSE
                                         -1
                                   END < 0
                               AND fl.lic_type LIKE i_lic_type
                               AND fle.lee_short_name LIKE i_licensee
                               AND fl.lic_budget_code LIKE i_prg_type
                               AND b.com_short_name LIKE i_supp_srt_name
                               AND fc.com_short_name LIKE i_chnl_comp
                               AND fct.con_short_name LIKE i_contract
                               -- AND    ( lic_acct_date >= last_day(i_period) OR lic_acct_date IS NULL )
                               AND ( ( (lic_acct_date > LAST_DAY (i_period))
                                      OR (lic_start > LAST_DAY (i_period)))
                                    OR lic_acct_date IS NULL)
                               AND fle.lee_split_region = fre.reg_id(+)
                               AND fre.reg_code LIKE i_region
                               AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
                       fid_payment b
                       ---x_fin_realized_forex c
                 WHERE     paid <> 0
                       --AND pay_number = rzf_pay_number(+)
                       AND pay_lic_number = lic_number
                       AND pay_status = 'P'
                       --deals having secondary licensee displaying payment twice
                       AND pay_lsl_number = lsl_number
                       AND pay_date <= LAST_DAY (i_period)
                       AND TRUNC (pay_date) BETWEEN TRUNC (
                                                       NVL (
                                                          TRUNC (i_from_period,
                                                                 'MON'),
                                                          pay_date))
                                                AND TRUNC (
                                                       DECODE (
                                                          i_from_period,
                                                          NULL, pay_date,
                                                          LAST_DAY (i_period)));
                       --and trunc(pay_date) between nvl(i_from_period,pay_date)
                       --      and decode(i_from_period,null,pay_date,i_period)
                     /*  AND NVL (CONCAT (rzf_year, LPAD (rzf_month, 2, 0)),
                                l_year || LPAD (l_month, 2, 0)) <=
                              l_year || LPAD (l_month, 2, 0)
                       --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
                       AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
                       AND to_number(to_char(pay_date, 'MM')) = rzf_month(+);*/
                       --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
          END IF;
      ELSE
         DBMS_OUTPUT.put_line ('inside i_from_period is null');

     IF(UPPER(i_rpt_type) = 'SAMMARY') -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
        THEN
           OPEN o_c_comm_pmnt_rpt FOR
              SELECT reg_code "Region",
                   channel_company "Channel Company",
                   lic_currency "License Currency",
                   lic_type "License Type",
                   lee_short_name "Licensee",
                   lic_budget_code "Programme Type",
                   SUM(pay_amount) "Payment Amount",
                   SUM((pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period))"Local Payment Amount"
              FROM (SELECT mem_agy_com_number,
                           fg.gen_title,
                           ft.ter_cur_code,
                           fc.com_number,
                           fc.com_name channel_company,
                           fc.com_short_name comp_short_name,
                           fl.lic_currency,
                           fl.lic_type,
                           lee_short_name,
                           lsl_number,
                           lsl_lee_price,
                           fl.lic_budget_code,
                           b.com_short_name supplier,
                           fct.con_short_name,
                           fc.com_ter_code,
                           con_number,
                           fl.lic_number,
                           lic_gen_refno,
                           lic_amort_code,
                           ROUND (fl.lic_price, 2) lic_price,
                           --fc.com_short_name,
                            b.com_short_name,
                           lic_markup_percent,
                           lic_acct_date--TO_CHAR(lic_acct_date,'YYYY.MM') LIC_ACCT_DATE
                           ,
                           lic_start,
                           lic_end,
                           ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_paid (
                                     fl.lic_number,
                                     con_number,
                                     fl.lic_currency,
                                     lsl.lsl_number,
                                     LAST_DAY (i_period)),
                                  2)
                              paid,
                           fre.reg_code
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
                     WHERE     lee_cha_com_number = fc.com_number
                           AND gen_refno = lic_gen_refno
                           AND ter_code = fc.com_ter_code
                           AND fc.com_type IN ('CC', 'BC')
                           AND fle.lee_number = lsl.lsl_lee_number
                           AND fl.lic_number = lsl.lsl_lic_number
                           AND con_number = lic_con_number
                           AND mem_id = lic_mem_number
                           AND b.com_number = con_com_number
                           AND CASE
                                  WHEN lic_status = 'C'
                                  THEN
                                     CASE
                                        WHEN 'N' = 'Y'
                                             AND fl.lic_type = 'ROY'
                                        THEN
                                           pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
                                              fl.lic_number,
                                              6,
                                              2013)
                                        ELSE
                                           ROUND (
                                              pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
                                                 fl.lic_number,
                                                 con_number,
                                                 fl.lic_currency,
                                                 LAST_DAY (i_period),
                                                 lsl.lsl_lee_price,
                                                 fl.lic_markup_percent,
                                                 lsl.lsl_number),
                                              2)
                                     END
                                  ELSE
                                     -1
                               END < 0
                           AND fl.lic_type LIKE i_lic_type
                           AND fle.lee_short_name LIKE i_licensee
                           AND fl.lic_budget_code LIKE i_prg_type
                           AND b.com_short_name LIKE i_supp_srt_name
                           AND fc.com_short_name LIKE i_chnl_comp
                           AND fct.con_short_name LIKE i_contract
                           -- AND    ( lic_acct_date >= last_day(i_period) OR lic_acct_date IS NULL )
                           AND ( ( (lic_acct_date > LAST_DAY (i_period))
                                  OR (lic_start > LAST_DAY (i_period)))
                                OR lic_acct_date IS NULL)
                           AND fle.lee_split_region = fre.reg_id(+)
                           AND fre.reg_code LIKE i_region
                           AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
                   fid_payment b
                   --x_fin_realized_forex c
             WHERE     paid <> 0
                   --AND pay_number = rzf_pay_number(+)
                   AND pay_lic_number = lic_number
                   AND pay_status = 'P'
                   --deals having secondary licensee displaying payment twice
                   AND pay_lsl_number = lsl_number
                   AND pay_date <= LAST_DAY (i_period)
                   AND TRUNC (pay_date) BETWEEN TRUNC (
                                                   NVL (
                                                      TRUNC (i_from_period,
                                                             'MON'),
                                                      pay_date))
                                            AND TRUNC (
                                                   DECODE (
                                                      i_from_period,
                                                      NULL, pay_date,
                                                      LAST_DAY (i_period)));
                   --and trunc(pay_date) between nvl(i_from_period,pay_date)
                   --      and decode(i_from_period,null,pay_date,i_period)
                   /*AND NVL (CONCAT (rzf_year, LPAD (rzf_month, 2, 0)),
                            l_year || LPAD (l_month, 2, 0)) <=
                          l_year || LPAD (l_month, 2, 0)
                   --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
                   AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
                   AND to_number(to_char(pay_date, 'MM')) = rzf_month(+);*/
                   --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
        ELSE
         OPEN o_c_comm_pmnt_rpt FOR
             SELECT reg_code "region",
                   TER_CUR_CODE "territory",
                   TO_CHAR(pay_due, 'DD-MON-RRRR') "pay_due",
                   pay_amount "payment_amount",
                   pay_rate "payment_rate",
                   channel_company "channel company",
                   lic_type "license type",
                   lee_short_name "licensee",
                   lic_budget_code "programmme type",
                   com_short_name "supplier name",
                   con_short_name "contract name",
                   lic_number "license number",
                   gen_title "programme title",
                  -- TO_DATE (TO_CHAR (lic_acct_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') "account date",
                   TO_CHAR (lic_acct_date, 'DD-MON-RRRR') "account date",
                   TO_CHAR (LIC_START, 'DD-MON-RRRR') "license start date",
                   TO_CHAR (lic_end, 'DD-MON-RRRR') "license end date",
                   NVL (lsl_lee_price, 0) "license price",
                   pay_code "description",
                   ROUND (
                      ( (pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period))
                      / pay_amount,
                      5)
                      "payment rate",   -- [Ver 0.1]
                   (pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period)
                      "local payment amount",
                   TO_CHAR (pay_date, 'DD-MON-RRRR') "paid date",
                   pay_status "status",
                   lsl_lee_price
                   - (x_pkg_fin_commitmnt_pmnt_rpt.total_paid_amt_per_lee (
                         lic_number,
                         lsl_number,
                         i_period))
                      "license currency liability",
                   pay_reference "reference",
                   pay_comment "payment comments",
                   lic_currency "license_currency",
                   TO_CHAR (l_rsa_ratedate, 'DD-MON-YYYY') "rsa ratedate",
                   TO_NUMBER (
                      DECODE (
                         i_report_type,
                         'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                                 lic_currency,
                                 ter_cur_code,
                                 l_rsa_ratedate),
                         'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                                 lic_currency,
                                 ter_cur_code,
                                 l_lastdate)))
                      "rsa spotrate",
                   TO_CHAR (l_afr_ratedate, 'DD-MON-RRRR') "afr ratedate",
                   (x_pkg_fin_commitmnt_pmnt_rpt.total_paid_amt_per_lee (
                       lic_number,
                       lsl_number,
                       i_period))
                      "amount",
                   DECODE (
                      i_report_type,
                      'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                              lic_currency,
                              ter_cur_code,
                              l_afr_ratedate),
                      'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                              lic_currency,
                              ter_cur_code,
                              l_lastdate))
                      "afr spotrate",
                   (lsl_lee_price
                    - (x_pkg_fin_commitmnt_pmnt_rpt.total_paid_amt_per_lee (
                          lic_number,
                          lsl_number,
                          i_period))
                      * DECODE (
                           i_report_type,
                           'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                                   lic_currency,
                                   ter_cur_code,
                                   DECODE (reg_code,
                                           'RSA', l_rsa_ratedate,
                                           'AFR', l_afr_ratedate)),
                           'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                                   lic_currency,
                                   ter_cur_code,
                                   l_lastdate)))
                      "loc_curr_lia",
                   ( (lsl_lee_price
                      - x_pkg_fin_commitmnt_pmnt_rpt.total_paid_amt_per_lee (
                           lic_number,
                           lsl_number,
                           i_period))
                    * DECODE (
                         i_report_type,
                         'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                                 lic_currency,
                                 ter_cur_code,
                                 l_afr_ratedate),
                         'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                                 lic_currency,
                                 ter_cur_code,
                                 l_lastdate)))
                      "loc_curr_lia_afr"
              FROM (SELECT mem_agy_com_number,
                           fg.gen_title,
                           ft.ter_cur_code,
                           fc.com_number,
                           fc.com_name channel_company,
                           fc.com_short_name comp_short_name,
                           fl.lic_currency,
                           fl.lic_type,
                           lee_short_name,
                           lsl_number,
                           lsl_lee_price,
                           fl.lic_budget_code,
                           b.com_short_name supplier,
                           fct.con_short_name,
                           fc.com_ter_code,
                           con_number,
                           fl.lic_number,
                           lic_gen_refno,
                           lic_amort_code,
                           ROUND (fl.lic_price, 2) lic_price,
                           --fc.com_short_name,
                            b.com_short_name,
                           lic_markup_percent,
                           lic_acct_date--TO_CHAR(lic_acct_date,'YYYY.MM') LIC_ACCT_DATE
                           ,
                           lic_start,
                           lic_end,
                           ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_paid (
                                     fl.lic_number,
                                     con_number,
                                     fl.lic_currency,
                                     lsl.lsl_number,
                                     LAST_DAY (i_period)),
                                  2)
                              paid,
                           fre.reg_code
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
                     WHERE     lee_cha_com_number = fc.com_number
                           AND gen_refno = lic_gen_refno
                           AND ter_code = fc.com_ter_code
                           AND fc.com_type IN ('CC', 'BC')
                           AND fle.lee_number = lsl.lsl_lee_number
                           AND fl.lic_number = lsl.lsl_lic_number
                           AND con_number = lic_con_number
                           AND mem_id = lic_mem_number
                           AND b.com_number = con_com_number
                           AND CASE
                                  WHEN lic_status = 'C'
                                  THEN
                                     CASE
                                        WHEN 'N' = 'Y'
                                             AND fl.lic_type = 'ROY'
                                        THEN
                                           pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
                                              fl.lic_number,
                                              6,
                                              2013)
                                        ELSE
                                           ROUND (
                                              pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
                                                 fl.lic_number,
                                                 con_number,
                                                 fl.lic_currency,
                                                 LAST_DAY (i_period),
                                                 lsl.lsl_lee_price,
                                                 fl.lic_markup_percent,
                                                 lsl.lsl_number),
                                              2)
                                     END
                                  ELSE
                                     -1
                               END < 0
                           AND fl.lic_type LIKE i_lic_type
                           AND fle.lee_short_name LIKE i_licensee
                           AND fl.lic_budget_code LIKE i_prg_type
                           AND b.com_short_name LIKE i_supp_srt_name
                           AND fc.com_short_name LIKE i_chnl_comp
                           AND fct.con_short_name LIKE i_contract
                           -- AND    ( lic_acct_date >= last_day(i_period) OR lic_acct_date IS NULL )
                           AND ( ( (lic_acct_date > LAST_DAY (i_period))
                                  OR (lic_start > LAST_DAY (i_period)))
                                OR lic_acct_date IS NULL)
                           AND fle.lee_split_region = fre.reg_id(+)
                           AND fre.reg_code LIKE i_region
                           AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
                   fid_payment b
                  -- x_fin_realized_forex c
             WHERE     paid <> 0
                   --AND pay_number = rzf_pay_number(+)
                   AND pay_lic_number = lic_number
                   AND pay_status = 'P'
                   --deals having secondary licensee displaying payment twice
                   AND pay_lsl_number = lsl_number
                   AND pay_date <= LAST_DAY (i_period)
                   AND TRUNC (pay_date) BETWEEN TRUNC (
                                                   NVL (
                                                      TRUNC (i_from_period,
                                                             'MON'),
                                                      pay_date))
                                            AND TRUNC (
                                                   DECODE (
                                                      i_from_period,
                                                      NULL, pay_date,
                                                      LAST_DAY (i_period)));
                   --and trunc(pay_date) between nvl(i_from_period,pay_date)
                   --      and decode(i_from_period,null,pay_date,i_period)
                   /*AND NVL (CONCAT (rzf_year, LPAD (rzf_month, 2, 0)),
                            l_year || LPAD (l_month, 2, 0)) <=
                          l_year || LPAD (l_month, 2, 0)
                   --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
                   AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
                   AND to_number(to_char(pay_date, 'MM')) = rzf_month(+);*/
                   --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
        END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_fin_comm_pmnt_exl_before;

   PROCEDURE prc_fin_comm_pmnt_rpt_before (
      i_region            IN     fid_region.reg_code%TYPE,
      i_from_period       IN     DATE,
      i_period            IN     fid_license.lic_start%TYPE,
      i_chnl_comp         IN     fid_company.com_short_name%TYPE,
      i_lic_type          IN     fid_license.lic_type%TYPE,
      i_prg_type          IN     fid_license.lic_budget_code%TYPE,
      i_licensee          IN     fid_licensee.lee_short_name%TYPE,
      i_supp_srt_name     IN     VARCHAR2,
      i_contract          IN     fid_contract.con_name%TYPE,
      i_report_type       IN     VARCHAR2,
      i_rpt_type          IN     VARCHAR2,
      o_c_comm_pmnt_rpt   OUT    x_pkg_fin_commitmnt_pmnt_rpt.c_comm_pmnt_rpt)
   AS
      l_year           NUMBER;
      l_month          NUMBER;
      l_rsa_ratedate   DATE;
      l_afr_ratedate   DATE;
      l_lastdate       DATE;
      l_firstdate      DATE;
   BEGIN
      l_month := TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'MM'));
      l_year := TO_NUMBER (TO_CHAR (i_period, 'YYYY'));

      --   TO_NUMBER (TO_CHAR (TO_DATE (i_period, 'DD/MM/YYYY'), 'YYYY'));

      ------------------Calculate Rate Date ---------------------------------------------------------------------------
      IF UPPER (i_region) = 'RSA'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_rsa_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE     fmd_month = l_month
                   AND fmd_year = l_year
                   AND reg_id = fmd_region
                   AND UPPER (fmd_mon_end_type) = 'FINAL'
                   AND UPPER (reg_code) = i_region;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_rsa_ratedate := NULL;
         END;
      ELSIF UPPER (i_region) = 'AFR'
      THEN
         BEGIN
            SELECT fmd_rate_date
              INTO l_afr_ratedate
              FROM x_fin_month_defn, fid_region
             WHERE     fmd_month = l_month
                   AND fmd_year = l_year
                   AND reg_id = fmd_region
                   AND UPPER (fmd_mon_end_type) = 'FINAL'
                   AND UPPER (reg_code) = i_region;
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
             WHERE     fmd_month = l_month
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
             WHERE     fmd_month = l_month
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

      --------------------------------------------------------------------------------------------------------------------
      SELECT LAST_DAY (i_period) INTO l_lastdate FROM DUAL;

      SELECT ADD_MONTHS (LAST_DAY (l_lastdate), -1) + 1
        INTO l_firstdate
        FROM DUAL;

    if(upper(i_rpt_type) ='SUMMARY')
    then                                -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
      OPEN o_c_comm_pmnt_rpt FOR
         SELECT
                 lic_type license_type,
                 lee_short_name licensee,
                 lic_budget_code program_type,
                 ter_cur_code territory,
                 reg_code region,
                 channel_company,
                 lic_currency license_currency,
                 sum( pay_amount) payment_amount,
                 sum((pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period)) local_payment_amount
           FROM (SELECT
                          fl.lic_type,
                          lee_short_name,
                          lsl_number,
                          fl.lic_budget_code,
                          con_number,
                          fl.lic_number,
                          ROUND (fl.lic_price, 2) lic_price,
                          ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_paid (
                                  fl.lic_number,
                                  con_number,
                                  fl.lic_currency,
                                  lsl.lsl_number,
                                  LAST_DAY (i_period)),
                               2)
                           paid,
                           ft.ter_cur_code,
                           fre.reg_code,
                           fc.com_name channel_company,
                           fl.lic_currency
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
                  WHERE     lee_cha_com_number = fc.com_number
                        AND gen_refno = lic_gen_refno
                        AND ter_code = fc.com_ter_code
                        AND fc.com_type IN ('CC', 'BC')
                        AND fle.lee_number = lsl.lsl_lee_number
                        AND fl.lic_number = lsl.lsl_lic_number
                        AND con_number = lic_con_number
                        AND mem_id = lic_mem_number
                        AND b.com_number = con_com_number
                        AND CASE
                               WHEN lic_status = 'C'
                               THEN
                                  CASE
                                     WHEN 'N' = 'Y' AND fl.lic_type = 'ROY'
                                     THEN
                                        pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
                                           fl.lic_number,
                                           6,
                                           2013)
                                     ELSE
                                        ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
                                                  fl.lic_number,
                                                  con_number,
                                                  fl.lic_currency,
                                                  LAST_DAY (i_period),
                                                  lsl.lsl_lee_price,
                                                  fl.lic_markup_percent,
                                                  lsl.lsl_number),
                                               2)
                                  END
                               ELSE
                                  -1
                            END < 0
                        AND fl.lic_type LIKE i_lic_type
                        AND fle.lee_short_name LIKE i_licensee
                        AND fl.lic_budget_code LIKE i_prg_type
                        AND b.com_short_name LIKE i_supp_srt_name
                        AND fc.com_short_name LIKE i_chnl_comp
                        AND fct.con_short_name LIKE i_contract
                        -- AND    ( lic_acct_date >= last_day(i_period) OR lic_acct_date IS NULL )
                        AND ( ( (lic_acct_date > LAST_DAY (i_period))
                               OR (lic_start > LAST_DAY (i_period)))
                             OR lic_acct_date IS NULL)
                        AND fle.lee_split_region = fre.reg_id(+)
                        AND fre.reg_code LIKE i_region
                        AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
                fid_payment b
               -- x_fin_realized_forex c
          WHERE     paid <> 0
               -- AND pay_number = rzf_pay_number(+)
                AND pay_lic_number = lic_number
                AND pay_status = 'P'
                --deals having secondary licensee displaying payment twice
                AND pay_lsl_number = lsl_number
                AND pay_date <= LAST_DAY (i_period)
                --AND NVL (CONCAT (rzf_year, LPAD (rzf_month, 2, 0)),
                --         l_year || LPAD (l_month, 2, 0)) <=
                --       l_year || LPAD (l_month, 2, 0)
                --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
              --  AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
              --  AND to_number(to_char(pay_date, 'MM')) = rzf_month(+)
                --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
           group by lic_type,lee_short_name,lic_budget_code,ter_cur_code,reg_code,channel_company,lic_currency;
    elsif(upper(i_rpt_type) ='DETAIL')  -- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0
    then
      OPEN o_c_comm_pmnt_rpt FOR
         SELECT ter_cur_code territory,
                reg_code region,
                pay_due,
                pay_amount payment_amount,
                --,pay_rate payment_rate
                channel_company,
                lic_type license_type,
                lee_short_name licensee,
                lic_budget_code program_type,
                DECODE (i_from_period, NULL, com_short_name, supplier)
                   supplier_name             --  ,com_short_name supplier_name
                                ,
                con_short_name contract_name,
                lic_number license_number,
                gen_title program_title,
                TO_CHAR (lic_acct_date, 'DD-MON-YYYY') account_date--,trunc(to_date(to_char(lic_start,'DD-MON-YYYY'),'DD-MON-YYYY')) license_start_date
                ,
                TO_CHAR (lic_start, 'DD-MON-YYYY') license_start_date,
                TO_CHAR (lic_end, 'DD-MON-YYYY') license_end_date,
                NVL (lsl_lee_price, 0) license_price,
                pay_code description               --  , pay_rate payment_rate
                                    ,
                ROUND (
                   ( (pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period))
                   / pay_amount,
                   5)
                   payment_rate,   -- [Ver 0.1]
                (pay_amount * pay_rate) +  x_fnc_get_total_rgl(pay_number,i_period)
                   local_payment_amount,
                TO_CHAR (pay_date, 'DD-MON-YYYY') paid_date,
                pay_status status,
                lsl_lee_price
                - (x_pkg_fin_commitmnt_pmnt_rpt.total_paid_amt_per_lee (
                      lic_number,
                      lsl_number,
                      i_period))
                   license_currency_liability,
                pay_reference referencee,
                pay_comment payment_comments,
                lic_currency license_currency,
                TO_CHAR (l_rsa_ratedate, 'DD-MON-YYYY') rsa_ratedate,
                TO_NUMBER (
                   DECODE (
                      i_report_type,
                      'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                              lic_currency,
                              ter_cur_code,
                              l_rsa_ratedate),
                      'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                              lic_currency,
                              ter_cur_code,
                              l_lastdate)))
                   rsa_spotrate,
                TO_CHAR (l_afr_ratedate, 'DD-MON-YYYY') afr_ratedate,
                (x_pkg_fin_commitmnt_pmnt_rpt.total_paid_amt_per_lee (
                    lic_number,
                    lsl_number,
                    i_period))
                   amt,
                DECODE (
                   i_report_type,
                   'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                           lic_currency,
                           ter_cur_code,
                           l_afr_ratedate),
                   'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                           lic_currency,
                           ter_cur_code,
                           l_lastdate))
                   afr_spotrate,
                (lsl_lee_price
                 - (x_pkg_fin_commitmnt_pmnt_rpt.total_paid_amt_per_lee (
                       lic_number,
                       lsl_number,
                       i_period))
                   * DECODE (
                        i_report_type,
                        'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                                lic_currency,
                                ter_cur_code,
                                DECODE (reg_code,
                                        'RSA', l_rsa_ratedate,
                                        'AFR', l_afr_ratedate)),
                        'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                                lic_currency,
                                ter_cur_code,
                                l_lastdate)))
                   loc_curr_lia,
                ( (lsl_lee_price
                   - x_pkg_fin_commitmnt_pmnt_rpt.total_paid_amt_per_lee (
                        lic_number,
                        lsl_number,
                        i_period))
                 * DECODE (
                      i_report_type,
                      'M', x_pkg_fin_get_spot_rate.get_spot_rate_with_inverse (
                              lic_currency,
                              ter_cur_code,
                              l_afr_ratedate),
                      'R', x_pkg_fin_get_spot_rate.get_spot_rate_with_rater (
                              lic_currency,
                              ter_cur_code,
                              l_lastdate)))
                   loc_curr_lia_afr
           FROM (SELECT mem_agy_com_number,
                        fg.gen_title,
                        ft.ter_cur_code,
                        fc.com_number,
                        fc.com_name channel_company,
                        fc.com_short_name comp_short_name,
                        fl.lic_currency,
                        fl.lic_type,
                        lee_short_name,
                        lsl_number,
                        lsl_lee_price,
                        fl.lic_budget_code,
                        b.com_short_name supplier,
                        fct.con_short_name,
                        fc.com_ter_code,
                        con_number,
                        fl.lic_number,
                        lic_gen_refno,
                        lic_amort_code,
                        ROUND (fl.lic_price, 2) lic_price,
                       --fc.com_short_name,
                        b.com_short_name,
                        lic_markup_percent,
                        lic_acct_date--TO_CHAR(lic_acct_date,'YYYY.MM') LIC_ACCT_DATE
                        ,
                        lic_start,
                        lic_end,
                        ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_paid (
                                  fl.lic_number,
                                  con_number,
                                  fl.lic_currency,
                                  lsl.lsl_number,
                                  LAST_DAY (i_period)),
                               2)
                           paid,
                        fre.reg_code
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
                  WHERE     lee_cha_com_number = fc.com_number
                        AND gen_refno = lic_gen_refno
                        AND ter_code = fc.com_ter_code
                        AND fc.com_type IN ('CC', 'BC')
                        AND fle.lee_number = lsl.lsl_lee_number
                        AND fl.lic_number = lsl.lsl_lic_number
                        AND con_number = lic_con_number
                        AND mem_id = lic_mem_number
                        AND b.com_number = con_com_number
                        AND CASE
                               WHEN lic_status = 'C'
                               THEN
                                  CASE
                                     WHEN 'N' = 'Y' AND fl.lic_type = 'ROY'
                                     THEN
                                        pkg_fin_mnet_outstand_coment.x_fin_con_forcast_sum (
                                           fl.lic_number,
                                           6,
                                           2013)
                                     ELSE
                                        ROUND (pkg_fin_mnet_outstand_coment.prc_fin_mnet_ousncom_liab (
                                                  fl.lic_number,
                                                  con_number,
                                                  fl.lic_currency,
                                                  LAST_DAY (i_period),
                                                  lsl.lsl_lee_price,
                                                  fl.lic_markup_percent,
                                                  lsl.lsl_number),
                                               2)
                                  END
                               ELSE
                                  -1
                            END < 0
                        AND fl.lic_type LIKE i_lic_type
                        AND fle.lee_short_name LIKE i_licensee
                        AND fl.lic_budget_code LIKE i_prg_type
                        AND b.com_short_name LIKE i_supp_srt_name
                        AND fc.com_short_name LIKE i_chnl_comp
                        AND fct.con_short_name LIKE i_contract
                        -- AND    ( lic_acct_date >= last_day(i_period) OR lic_acct_date IS NULL )
                        AND ( ( (lic_acct_date > LAST_DAY (i_period))
                               OR (lic_start > LAST_DAY (i_period)))
                             OR lic_acct_date IS NULL)
                        AND fle.lee_split_region = fre.reg_id(+)
                        AND fre.reg_code LIKE i_region
                        AND lic_status NOT IN ('B', 'F', 'T')) a, --added so that t licenses should not be displayed
                fid_payment b
                --x_fin_realized_forex c
          WHERE     paid <> 0
               -- AND pay_number = rzf_pay_number(+)
                AND pay_lic_number = lic_number
                AND pay_status = 'P'
                --deals having secondary licensee displaying payment twice
                AND pay_lsl_number = lsl_number
                AND pay_date <= LAST_DAY (i_period)
                AND TRUNC (pay_date) BETWEEN TRUNC (
                                                NVL (
                                                   TRUNC (i_from_period,
                                                          'MON'),
                                                   pay_date))
                                         AND TRUNC (
                                                DECODE (i_from_period,
                                                        NULL, pay_date,
                                                        LAST_DAY (i_period)));
                ----to_date('01-JUL-2013') AND to_date('31-JUL-2013')
                /*AND NVL (CONCAT (rzf_year, LPAD (rzf_month, 2, 0)),
                         l_year || LPAD (l_month, 2, 0)) <=
                       l_year || LPAD (l_month, 2, 0)
                --Start[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
                AND to_number(to_char(pay_date, 'RRRR')) = rzf_year(+)
                AND to_number(to_char(pay_date, 'MM')) = rzf_month(+);*/
                --End[20-Oct-2016]-[Jawahar.Garg]FIN_DEV_PHASE_I
    end if;		---- Added by Ankur Kasar [19-04-2016]- 15_FIN_03_Summary Report For Commitments Payment_v1.0

  --  DBMS_OUTPUT.PUT_LINE(l_stmt_str);
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));
   END prc_fin_comm_pmnt_rpt_before;
    --Dev.R1: Finace DEV Phase 1 :[Change because before go live date it work as existing and after go live it work as new requirement]_[Ankur Kasar]_[2016/11/16]: end 
   FUNCTION total_paid_amt_per_lee (
      i_lic_number   IN fid_license.lic_number%TYPE,
      i_lsl_number   IN x_fin_lic_sec_lee.lsl_number%TYPE,
      i_period       IN DATE)
      RETURN NUMBER
   AS
      l_lee_number   NUMBER;
      l_pay_amt      NUMBER;
   BEGIN
      /*    SELECT SUM (pay_amount)
                      ,lsl_lee_number
              into    l_pay_amt
                      ,l_lee_number
              from fid_license ,
                  fid_payment,
                  x_fin_lic_sec_lee
              where lic_number = pay_lic_number
              and lic_acct_date is null
              and pay_status = 'P'
              and pay_date < lic_start
              and lic_number = i_lic_number
              and lsl_number (+) = pay_lsl_number
        and lsl_lee_number = i_lee_number
              group by lsl_lee_number
              ;
      */
      SELECT NVL (SUM (pay_amount), 0)
        INTO l_pay_amt
        FROM fid_payment
       WHERE     UPPER (pay_status) = 'P'
             AND pay_date < (SELECT lic_start
                               FROM fid_license
                              WHERE lic_number = i_lic_number)
             AND pay_lic_number = i_lic_number
             AND pay_lsl_number = i_lsl_number
             AND TO_NUMBER (TO_CHAR (pay_date, 'YYYYMM')) <=
                    TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'));

      RETURN l_pay_amt;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_pay_amt := 0;
         RETURN l_pay_amt;
   END total_paid_amt_per_lee;

END X_PKG_FIN_COMMITMNT_PMNT_RPT;
/