CREATE OR REPLACE PACKAGE X_PKG_FIN_INVENTORY_AGE_RPT AS

/****************************************************************
   REM Module          : Pure Finance
   REM Client          : MNet
   REM File Name       : X_PKG_FIN_INVENTORY_AGE_RPT.sql
   REM Form Name       : Inventory Age Analysis Report
   REM Purpose         : For inventory age
   REM Author          : Ajitkumar Tanwade
   REM Creation Date   : 13 Feb 2013
   REM Type            : Database Package
   REM Change History  :
  ****************************************************************/

  TYPE c_cur_inv_age IS REF CURSOR;

--****************************************************************
  -- This procedure for Inventory age report
--****************************************************************
 PROCEDURE prc_fin_inventory_age_rpt (
    i_region_code       	in       fid_region.reg_code%TYPE
    ,i_chnal_comp		      in	fid_company.com_short_name%type
    ,i_lic_type		        in	fid_license.lic_type%type
    ,i_lee_short_name	    in	fid_licensee.lee_short_name%type
    ,i_lic_budget_code	  in	fid_license.lic_budget_code%type
    ,i_con_short_name	    in	fid_contract.con_short_name%type
    ,i_report_type        in  VARCHAR2
    ,i_age_period         in  VARCHAR2
    ,i_prepetuinty        in  VARCHAR2
    ,i_period_date		    in	DATE
    ,o_inv_age_rep		        OUT X_PKG_FIN_INVENTORY_AGE_RPT.c_cur_inv_age
);

--*************************************************************************
  -- This procedure for Inventory age report export to excel functionality
--*************************************************************************
 PROCEDURE prc_fin_exprt_to_excel (
    i_region_code       	in       fid_region.reg_code%TYPE
    ,i_chnal_comp		      in	fid_company.com_short_name%type
    ,i_lic_type		        in	fid_license.lic_type%type
    ,i_lee_short_name	    in	fid_licensee.lee_short_name%type
    ,i_lic_budget_code	  in	fid_license.lic_budget_code%type
    ,i_con_short_name	    in	fid_contract.con_short_name%type
    ,i_report_type        in  VARCHAR2
    ,i_age_period         in  VARCHAR2
    ,i_prepetuinty        in  VARCHAR2
    ,i_period_date		    in	DATE
    ,o_inv_age_rep		        OUT X_PKG_FIN_INVENTORY_AGE_RPT.c_cur_inv_age
);

--****************************************************************
  -- This function for calculating Inventory
--****************************************************************
 FUNCTION con_inv (
      L_LIC_NUMBER	  FID_LICENSE.LIC_NUMBER%type,
      L_lsl_number    x_fin_lic_sec_lee.lsl_number%type,
      i_period_date	DATE
   )
 RETURN NUMBER;

--****************************************************************
  -- This function for calculating Cost
--****************************************************************
 FUNCTION con_cost (
      L_LIC_NUMBER	  FID_LICENSE.LIC_NUMBER%type,
      L_lsl_number    x_fin_lic_sec_lee.lsl_number%type,
      i_period_date	DATE
   )
 RETURN NUMBER;

FUNCTION td_total (
      l_sch_lic_number	fid_sch_summary_vw.sch_lic_number%type
    ,i_period_date		DATE
	)
 RETURN NUMBER;

--****************************************************************
  -- This function for exchange rate
--****************************************************************
 FUNCTION ex_rate (
    i_lic_currency	fid_exchange_rate.rat_cur_code%type
    ,	i_ter_cur_code	fid_exchange_rate.rat_cur_code_2%type
	)
 RETURN NUMBER;

END X_PKG_FIN_INVENTORY_AGE_RPT;
/
CREATE OR REPLACE PACKAGE BODY X_PKG_FIN_INVENTORY_AGE_RPT AS

/****************************************************************
   REM Module          : Pure Finance
   REM Client          : MNet
   REM File Name       : X_PKG_FIN_INVENTORY_AGE_RPT.sql
   REM Form Name       : Inventory Age Analysis Report
   REM Purpose         : For inventory age
   REM Author          : Ajitkumar Tanwade
   REM Creation Date   : 13 Feb 2013
   REM Type            : Database Package
   REM Change History  :
  ****************************************************************/

--****************************************************************
  -- This procedure for Inventory age report
--****************************************************************

  PROCEDURE prc_fin_inventory_age_rpt (
    i_region_code       	in  fid_region.reg_code%TYPE
    ,i_chnal_comp		      in	fid_company.com_short_name%type
    ,i_lic_type		        in	fid_license.lic_type%type
    ,i_lee_short_name	    in	fid_licensee.lee_short_name%type
    ,i_lic_budget_code	  in	fid_license.lic_budget_code%type
    ,i_con_short_name	    in	fid_contract.con_short_name%type
    ,i_report_type        in  VARCHAR2
    ,i_age_period         in  VARCHAR2
    ,i_prepetuinty        in  VARCHAR2
    ,i_period_date		    in	DATE
    ,o_inv_age_rep		    OUT X_PKG_FIN_INVENTORY_AGE_RPT.c_cur_inv_age
) AS
  sqlstmnt varchar2(30000);
  l_live_date DATE;
  l_channel_comp varchar2(15);
  BEGIN

    SELECT decode(upper(i_report_type),'DETAIL',i_chnal_comp,'%')
        into l_channel_comp
      from dual;

     SELECT to_date(Content,'DD-MON-YYYY')
                INTO l_live_date
              from X_FIN_CONFIGS
            where key = 'GO-LIVEDATE';

     IF UPPER(i_report_type)  = 'DETAIL'
     THEN


         sqlstmnt := 'select lic_curr
                       ,region
                       ,channel_comp
                       ,lic_type
                       ,lee
                       ,budget_code
                       ,SUPPLIER
                       ,CONTRACT
                       ,lic_number
                       ,title
                       ,ACCT_DATE
                       ,LIC_START
                       ,LIC_END
                       ,AM_CO
                       ,LIC_EXH
                       ,AMO_EXH
                       ,td_exh
                       ,lic_fee
                       ,cost
                       ,(lic_fee - cost) close_inv
                       ,rate
                      ,ROUND((( cost) * rate),2) loc_close_inv
                       ,age
                      from
                          (';
    END IF;

     IF UPPER(I_REPORT_TYPE) = 'SUMMARY'
     THEN
         SQLSTMNT:= 'select
                           channel_comp
                           ,lic_curr
                           ,lic_type
                           ,lee
                           ,budget_code
                           ,SUPPLIER
                           ,ROUND(sum(lic_fee),2) total_fee
                           ,ROUND(sum(cost),2) total_close
                           ,ROUND(sum(close_inv),2) total_cost
                           ,ROUND(sum(loc_close_inv),2) loc_total_close
                           ,ROUND(sum(col1),2) "Months0_6"
                           ,ROUND(sum(col2),2) "Months6_12"
                           ,ROUND(sum(col3),2) "Months12_18"
                           ,ROUND(sum(col4),2) "Months18_24"
                           ,ROUND(SUM(col5),2) "Months24_36"
                           ,ROUND(SUM(col6),2) "Months_36"
                     from
                    (
                             select
                                     channel_comp
                                    ,SUPPLIER
                                    ,lic_curr
                                    ,lic_type
                                    ,lee
                                    ,budget_code
                                    ,lic_fee
                                    ,cost
                                    ,(lic_fee - cost) close_inv
                                    ,rate
                                    ,((cost) * rate) loc_close_inv
                                    ,age
                                    ,(case when age <= 6 then ((lic_fee - cost) )
                                        else 0
                                        end) col1
                                    ,(case when age between 7 and 12 then ((cost) )
                                        else 0
                                        end) col2
                                    ,(case when age between 13 and 18 then ((cost))
                                        else 0
                                        end) col3
                                    ,(case when age between 19 and 24 then ((cost))
                                        else 0
                                        end) col4
                                    ,(case when age between 25 and 36 then ((cost))
                                        else 0
                                        end) col5
                                    ,(case when age > 36 then ((cost))
                                        else 0
                                        end) col6
                          from
                            (';
     END IF;

    sqlstmnt := sqlstmnt || ' SELECT	  lic_currency lic_curr
                                  , reg_code region
                                  ,x.com_name	channel_comp
                                  ,lic_type
                                  ,lee_short_name lee
                                  ,lic_budget_code budget_code
                                  ,substr(fc.com_short_name, 1, 8) SUPPLIER
                                  ,con_short_name	CONTRACT
                                  ,lic_number
                                  ,GEN_TITLE title
                                  ,TO_CHAR(lic_acct_date,''DDMonYYYY'') ACCT_DATE
                                  ,to_char(lic_start,''DDMonYYYY'') LIC_START
                                  ,to_char(lic_end, ''DDMonYYYY'') LIC_END
                                  ,ROUND((CASE WHEN lic_start < ''' || l_live_date || '''
                                      THEN X_PKG_FIN_INVENTORY_AGE_RPT.ex_rate(lic_currency , ter_cur_code)
                                      ELSE lic_rate END), 5) rate   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                                  ,lic_amort_code	AM_CO
                                  ,lic_showing_int LIC_EXH
                                  ,lic_showing_lic AMO_EXH
                                  ,X_PKG_FIN_INVENTORY_AGE_RPT.td_total(lic_number,to_date('''||i_period_date||''')) td_exh
                                  ,X_PKG_FIN_INVENTORY_AGE_RPT.con_inv(lic_number,lsl_number ,to_date('''||i_period_date||''')) lic_fee
                                  ,X_PKG_FIN_INVENTORY_AGE_RPT.con_cost(lic_number,lsl_number ,to_date('''||i_period_date||''')) cost
                                  ,ter_cur_code
                                  ,CEIL((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) age
                                FROM 	fid_general
                                  ,fid_company fc
                                  ,fid_contract
                                  ,fid_licensee
                                  ,fid_license
                                  ,fid_region
                                  ,fid_territory
                                  ,x_fin_lic_sec_lee
                                  ,(select	distinct com_number,
                                  com_name
                                  ,	com_ter_code
                                  from	fid_company f
                                  WHERE  	com_short_name LIKE '''|| l_channel_comp ||'''
                                  AND   	com_type  IN (''CC'',''BC'')
                                  ) x
                            Where Ter_Code  = x.Com_Ter_Code
                            AND lee_cha_com_number = x.com_number
                            and lic_number = lsl_lic_number
                            AND NVL(lic_writeoff, ''N'') = ''N''
                            AND	lsl_lee_number     = lee_number
                            AND	con_number         = lic_con_number
                            AND	fc.com_number     = con_com_number
                            AND	gen_refno            = lic_gen_refno
                            AND reg_id(+) = LEE_SPLIT_REGION
							and upper(lic_status) = ''A''
                            and  (select  sum(lis_con_forecast - (lis_con_actual + lis_con_adjust + NVL(lis_con_writeoff,0)))
                                       from fid_license_sub_ledger
                                       where  lis_lic_number = lic_number
                                       and lis_lsl_number = lsl_number
									   and upper(lic_status) = ''A''
                                      and lis_per_year||lpad(lis_per_month,2,0) <= to_char(to_date('''||i_period_date||'''),''YYYYMM'')) > 0';


       IF UPPER(i_prepetuinty) = 'N'
       THEN
             sqlstmnt :=
                 sqlstmnt
              || ' AND LIC_END  <> to_date(''31-DEC-2199'') ';
       END IF;

       IF i_region_code IS NOT NULL
             then
            sqlstmnt :=
               sqlstmnt
            || ' AND UPPER(reg_code) like UPPER ('''
            || i_region_code
            || ''')';
       END IF;

      IF upper(i_report_type)  = 'DETAIL'
      THEN
           IF i_lic_type IS NOT NULL
           then
                sqlstmnt :=
                   sqlstmnt
                || ' AND UPPER(LIC_TYPE) like UPPER ('''
                || i_lic_type
                || ''')';
           END IF;

           IF i_lic_budget_code IS NOT NULL
           then
                sqlstmnt :=
                   sqlstmnt
                || ' AND UPPER(LIC_BUDGET_CODE) like UPPER ('''
                || i_lic_budget_code
                || ''')';
           END IF;

           IF i_lee_short_name IS NOT NULL
           then
                sqlstmnt :=
                   sqlstmnt
                || ' AND UPPER(LEE_SHORT_NAME) like UPPER ('''
                || i_lee_short_name
                || ''')';
           END IF;

           IF i_con_short_name IS NOT NULL
           then
                sqlstmnt :=
                   sqlstmnt
                || ' AND UPPER(CON_SHORT_NAME) like UPPER ('''
                || i_con_short_name
                || ''')';
           END IF;

           IF UPPER(i_age_period) =UPPER('<=6 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) <= 6';
           END IF;

           IF UPPER(i_age_period) =UPPER('6-12 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) between 7 and 12';
           END IF;

           IF UPPER(i_age_period) =UPPER('12-18 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) between 13 and 18';
           END IF;

           IF UPPER(i_age_period) =UPPER('18-24 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) between 19 and 24';
           END IF;

           IF UPPER(i_age_period) =UPPER('24-36 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) between 24 and 36';
           END IF;

           IF UPPER(i_age_period) =UPPER('>36 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) > 36';
           END IF;

           sqlstmnt := sqlstmnt || ')  ORDER BY lic_curr,
                                             lic_type,
                                             channel_comp,
                                             lee,
                                             budget_code,
                                             SUPPLIER,
                                             CONTRACT asc,
                                             lic_number asc,
                                             title';
      END IF;

     IF UPPER(I_REPORT_TYPE) = 'SUMMARY'
     THEN
          SQLSTMNT := SQLSTMNT ||   ')
                                      ) group by lic_curr,
                                         channel_comp,
                                         lic_type,
                                         lee,
                                         budget_code,
                                         SUPPLIER
                                         order by lic_curr,
                                             channel_comp,
                                             lic_type,
                                             lee,
                                             budget_code,
                                             SUPPLIER
                                              ';
     end if;

    dbms_output.put_line(sqlstmnt);
    OPEN  o_inv_age_rep  FOR sqlstmnt;

  END prc_fin_inventory_age_rpt;

-- Start by Sandip

--****************************************************************
  -- This procedure for Inventory age report export to excel functionality
--****************************************************************

  PROCEDURE prc_fin_exprt_to_excel (
    i_region_code       	in  fid_region.reg_code%TYPE
    ,i_chnal_comp		      in	fid_company.com_short_name%type
    ,i_lic_type		        in	fid_license.lic_type%type
    ,i_lee_short_name	    in	fid_licensee.lee_short_name%type
    ,i_lic_budget_code	  in	fid_license.lic_budget_code%type
    ,i_con_short_name	    in	fid_contract.con_short_name%type
    ,i_report_type        in  VARCHAR2
    ,i_age_period         in  VARCHAR2
    ,i_prepetuinty        in  VARCHAR2
    ,i_period_date		    in	DATE
    ,o_inv_age_rep		    OUT X_PKG_FIN_INVENTORY_AGE_RPT.c_cur_inv_age
) AS
  sqlstmnt varchar2(30000);
  l_live_date DATE;
  l_channel_comp varchar2(15);
  BEGIN

    SELECT decode(upper(i_report_type),'DETAIL',i_chnal_comp,'%')
        into l_channel_comp
      from dual;

     SELECT to_date(Content,'DD-MON-YYYY')
                INTO l_live_date
              from X_FIN_CONFIGS
            where key = 'GO-LIVEDATE';

     IF UPPER(i_report_type)  = 'DETAIL'
     THEN


         SQLSTMNT := 'select lic_curr as "License Currency"
                       ,region "Region"
                       ,channel_comp as "Channel Company"
                       ,lic_type as "License Type"
                       ,lee as "Licensee"
                       ,budget_code as "Budget Code"
                       ,SUPPLIER as "Supplier"
                       ,CONTRACT as "Contract"
                       ,lic_number as "Lic Number"
                       ,title as "Title"
                       ,ACCT_DATE as "Account Date"
                       ,LIC_START as "Lic Start Date"
                       ,LIC_END as "Lic End Date"
                       ,AM_CO as "Amort Code"
                       ,LIC_EXH as "Lic Exh"
                       ,AMO_EXH as "Amort Exh"
                       ,td_exh as "TD Exh"
                       ,lic_fee as "License Fee"
                       ,cost as "Closed Inventory"
                       ,(lic_fee - cost) as "Cost"
                       ,rate as "Exchange Rate"
                      ,ROUND((( cost) * rate),2) as "Closed Inventory in ZAR"
                       ,age as "Age in Month"
                      from
                          (';
    END IF;

     IF UPPER(I_REPORT_TYPE) = 'SUMMARY'
     THEN
         SQLSTMNT:= 'select
                           channel_comp as "Channel Company"
                           ,lic_curr as "License Currency"
                           ,lic_type as "License Type"
                           ,lee  as "License"
                           ,budget_code as "Budget Code"
                           ,SUPPLIER as "Supplier"
                           ,ROUND(sum(lic_fee),2) as "Total Fee"
                           ,ROUND(sum(cost),2) as "Total Cost"
                           ,ROUND(sum(close_inv),2) as "Total Close"
                           ,ROUND(sum(loc_close_inv),2) as "Loc Total Close"
                           ,ROUND(sum(col1),2)as "0-6 Months"
                           ,ROUND(sum(col2),2) as  "6-12 Months"
                           ,ROUND(sum(col3),2) as "12-18 Months"
                           ,ROUND(sum(col4),2) as "18-24 Months"
                           ,ROUND(SUM(col5),2)as  "24-36Months"
                           ,ROUND(SUM(col6),2) as ">36 Months"
                     from
                    (
                             select
                                     channel_comp
                                    ,SUPPLIER
                                    ,lic_curr
                                    ,lic_type
                                    ,lee
                                    ,budget_code
                                    ,lic_fee
                                    ,cost
                                    ,(lic_fee - cost) close_inv
                                    ,rate
                                    ,((cost) * rate) loc_close_inv
                                    ,age
                                    ,(case when age <= 6 then ((lic_fee - cost) )
                                        else 0
                                        end) col1
                                    ,(case when age between 7 and 12 then ((cost) )
                                        else 0
                                        end) col2
                                    ,(case when age between 13 and 18 then ((cost))
                                        else 0
                                        end) col3
                                    ,(case when age between 19 and 24 then ((cost))
                                        else 0
                                        end) col4
                                    ,(case when age between 25 and 36 then ((cost))
                                        else 0
                                        end) col5
                                    ,(case when age > 36 then ((cost))
                                        else 0
                                        end) col6
                          from
                            (';
     END IF;

    sqlstmnt := sqlstmnt || ' SELECT	  lic_currency lic_curr
                                  , reg_code region
                                  ,x.com_name	channel_comp
                                  ,lic_type
                                  ,lee_short_name lee
                                  ,lic_budget_code budget_code
                                  ,substr(fc.com_short_name, 1, 8) SUPPLIER
                                  ,con_short_name	CONTRACT
                                  ,lic_number
                                  ,GEN_TITLE title
                                  ,TO_CHAR(lic_acct_date,''DDMonYYYY'') ACCT_DATE
                                  ,to_char(lic_start,''DDMonYYYY'') LIC_START
                                  ,to_char(lic_end, ''DDMonYYYY'') LIC_END
                                  ,ROUND((CASE WHEN lic_start < ''' || l_live_date || '''
                                      THEN X_PKG_FIN_INVENTORY_AGE_RPT.ex_rate(lic_currency , ter_cur_code)
                                      ELSE lic_rate END), 5) rate   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                                  ,lic_amort_code	AM_CO
                                  ,lic_showing_int LIC_EXH
                                  ,lic_showing_lic AMO_EXH
                                  ,X_PKG_FIN_INVENTORY_AGE_RPT.td_total(lic_number,to_date('''||i_period_date||''')) td_exh
                                  ,X_PKG_FIN_INVENTORY_AGE_RPT.con_inv(lic_number,lsl_number ,to_date('''||i_period_date||''')) lic_fee
                                  ,X_PKG_FIN_INVENTORY_AGE_RPT.con_cost(lic_number,lsl_number ,to_date('''||i_period_date||''')) cost
                                  ,ter_cur_code
                                  ,CEIL((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) age
                                FROM 	fid_general
                                  ,fid_company fc
                                  ,fid_contract
                                  ,fid_licensee
                                  ,fid_license
                                  ,fid_region
                                  ,fid_territory
                                  ,x_fin_lic_sec_lee
                                  ,(select	distinct com_number,
                                  com_name
                                  ,	com_ter_code
                                  from	fid_company f
                                  WHERE  	com_short_name LIKE '''|| l_channel_comp ||'''
                                  AND   	com_type  IN (''CC'',''BC'')
                                  ) x
                            Where Ter_Code  = x.Com_Ter_Code
                            AND lee_cha_com_number = x.com_number
                            and lic_number = lsl_lic_number
                            AND NVL(lic_writeoff, ''N'') = ''N''
                            AND	lsl_lee_number     = lee_number
                            AND	con_number         = lic_con_number
                            AND	fc.com_number     = con_com_number
                            AND	gen_refno            = lic_gen_refno
                            AND reg_id(+) = LEE_SPLIT_REGION
							and upper(lic_status) = ''A''
                           -- and lic_number in(637800,637897)
                            and  (select  sum(lis_con_forecast - (lis_con_actual + lis_con_adjust + NVL(lis_con_writeoff,0)))
                                       from fid_license_sub_ledger
                                       where  lis_lic_number = lic_number
                                       and lis_lsl_number = lsl_number
									   and upper(lic_status) = ''A''
                                      and lis_per_year||lpad(lis_per_month,2,0) <= to_char(to_date('''||i_period_date||'''),''YYYYMM'')) > 0';


       IF UPPER(i_prepetuinty) = 'N'
       THEN
             sqlstmnt :=
                 sqlstmnt
              || ' AND LIC_END  <> to_date(''31-DEC-2199'') ';
       END IF;

       IF i_region_code IS NOT NULL
             then
            sqlstmnt :=
               sqlstmnt
            || ' AND UPPER(reg_code) like UPPER ('''
            || i_region_code
            || ''')';
       END IF;

      IF upper(i_report_type)  = 'DETAIL'
      THEN
           IF i_lic_type IS NOT NULL
           then
                sqlstmnt :=
                   sqlstmnt
                || ' AND UPPER(LIC_TYPE) like UPPER ('''
                || i_lic_type
                || ''')';
           END IF;

           IF i_lic_budget_code IS NOT NULL
           then
                sqlstmnt :=
                   sqlstmnt
                || ' AND UPPER(LIC_BUDGET_CODE) like UPPER ('''
                || i_lic_budget_code
                || ''')';
           END IF;

           IF i_lee_short_name IS NOT NULL
           then
                sqlstmnt :=
                   sqlstmnt
                || ' AND UPPER(LEE_SHORT_NAME) like UPPER ('''
                || i_lee_short_name
                || ''')';
           END IF;

           IF i_con_short_name IS NOT NULL
           then
                sqlstmnt :=
                   sqlstmnt
                || ' AND UPPER(CON_SHORT_NAME) like UPPER ('''
                || i_con_short_name
                || ''')';
           END IF;

           IF UPPER(i_age_period) =UPPER('<=6 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) <= 6';
           END IF;

           IF UPPER(i_age_period) =UPPER('6-12 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) between 7 and 12';
           END IF;

           IF UPPER(i_age_period) =UPPER('12-18 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) between 13 and 18';
           END IF;

           IF UPPER(i_age_period) =UPPER('18-24 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) between 19 and 24';
           END IF;

           IF UPPER(i_age_period) =UPPER('24-36 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) between 24 and 36';
           END IF;

           IF UPPER(i_age_period) =UPPER('>36 Months')
           THEN
              SQLSTMNT := SQLSTMNT
                  || ' AND ROUND((TRUNC(TO_DATE('''||i_period_date||''')) - TRUNC(lic_start)) / 30) > 36';
           END IF;

           sqlstmnt := sqlstmnt || ')  ORDER BY lic_curr,
                                             lic_type,
                                             channel_comp,
                                             lee,
                                             budget_code,
                                             SUPPLIER,
                                             CONTRACT asc,
                                             lic_number asc,
                                             title';
      END IF;

     IF UPPER(I_REPORT_TYPE) = 'SUMMARY'
     THEN
          SQLSTMNT := SQLSTMNT ||   ')
                                      ) group by lic_curr,
                                         channel_comp,
                                         lic_type,
                                         lee,
                                         budget_code,
                                         SUPPLIER
                                         order by lic_curr,
                                             channel_comp,
                                             lic_type,
                                             lee,
                                             budget_code,
                                             SUPPLIER
                                              ';
     end if;

    --dbms_output.put_line(sqlstmnt);
    OPEN  o_inv_age_rep  FOR sqlstmnt;

  end prc_fin_exprt_to_excel;

-- End by Sandip
--****************************************************************
  -- This function for calculating Inventory
--****************************************************************
  FUNCTION con_inv (
      L_LIC_NUMBER	  FID_LICENSE.LIC_NUMBER%type,
      L_lsl_number    x_fin_lic_sec_lee.lsl_number%type,
      i_period_date	DATE
   )
 RETURN NUMBER AS
 l_con_inv  number;
  BEGIN

      select ROUND(SUM(LIS_CON_FORECAST),2)
          into 	L_CON_INV
        from 	FID_LICENSE_SUB_LEDGER
        where LIS_LIC_NUMBER = L_LIC_NUMBER
        and LIS_LSL_NUMBER =  L_LSL_NUMBER
        and 	lis_per_year||lpad(lis_per_month,2,0) <= to_number(to_char(to_date(i_period_date),'YYYYMM'));

      return l_con_inv;

  EXCEPTION
		WHEN no_data_found
		THEN
			RETURN 0;

  END con_inv;

--****************************************************************
  -- This function for calculating Cost
--****************************************************************
  FUNCTION con_cost (
      L_LIC_NUMBER	  FID_LICENSE.LIC_NUMBER%type,
      L_lsl_number    x_fin_lic_sec_lee.lsl_number%type,
      i_period_date	DATE
   )
 RETURN NUMBER AS
 l_con_cost  number;
  BEGIN

      select ROUND(SUM(LIS_CON_FORECAST - (LIS_CON_ACTUAL + LIS_CON_ADJUST + NVL(LIS_CON_WRITEOFF,0))),2)
          into 	L_CON_COST
        from 	FID_LICENSE_SUB_LEDGER
        where LIS_LIC_NUMBER = L_LIC_NUMBER
        and lis_lsl_number= L_lsl_number

        and 	lis_per_year||lpad(lis_per_month,2,0) <= to_number(to_char(to_date(i_period_date),'YYYYMM'));

      return l_con_cost;

  EXCEPTION
		WHEN no_data_found
		THEN
			RETURN 0;
  END con_cost;

  FUNCTION td_total
	(	l_sch_lic_number	fid_sch_summary_vw.sch_lic_number%type
	,	i_period_date		DATE
	)
	return number
	as
	l_TD_Exh number;
	begin
		begin
			SELECT	SUM(sch_total)
			into 	l_TD_Exh
			FROM 	fid_sch_summary_vw
			WHERE 	sch_year||lpad(sch_month,2,0) <= to_number(to_char(i_period_date,'YYYYMM'))
			AND 	sch_lic_number = l_sch_lic_number
			;
		exception
		when no_data_found
		then
			l_TD_Exh := 0;
		end;
		if l_TD_Exh is null
		then
			l_TD_Exh := 0;
		end if;
		RETURN  l_TD_Exh;
	End;

--****************************************************************
  -- This function for exchange rate
--****************************************************************
  FUNCTION ex_rate (
    i_lic_currency	fid_exchange_rate.rat_cur_code%type
    ,	i_ter_cur_code	fid_exchange_rate.rat_cur_code_2%type
	)
 return number as
 l_ex_rate 	number;
 begin
      select	ROUND(rat_rate,4)
          into	l_ex_rate
        from	fid_exchange_rate
          where	rat_cur_code   = i_lic_currency
          and	rat_cur_code_2 = i_ter_cur_code
				;

  return trunc(l_ex_rate,4);

 EXCEPTION
		WHEN no_data_found
		THEN
				l_ex_rate := 1.0000;

  return trunc(l_ex_rate,4);

  END ex_rate;

END X_PKG_FIN_INVENTORY_AGE_RPT;
/