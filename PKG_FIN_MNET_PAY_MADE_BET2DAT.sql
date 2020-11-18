CREATE OR REPLACE PACKAGE          "PKG_FIN_MNET_PAY_MADE_BET2DAT"
AS
   /**************************************************************************
   REM Module          : Finance - Payments made between two dates
   REM Client          : MNET/ SUPER SPORT
   REM File Name       : PKG_FIN_MNET_PAY_MADE_BET2DAT
   REM Purpose         : Generate reports for payment made between two dates
   REM Written By      : Rajan Kumar
   REM Date            : 17-02-2010
   REM Type            : Database Package
   REM Change History  : Created
   REM **************************************************************************/
   TYPE o_fin_pay_bet2date_cursor IS REF CURSOR;

   PROCEDURE prc_fin_mnet_pay_made_bet2dat (
      i_channel_company   IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN     fid_contract.con_short_name%type,
      i_supplier          IN       fid_company.com_short_name%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_date_from         IN       DATE,
      i_date_to           IN       DATE,
      i_order_by          IN       VARCHAR2,
      -- Pure finance  mrunmayi kusurkar
      i_reg_code          IN       fid_region.reg_code%TYPE,
      i_report_type       IN       VARCHAR2,
      -- end
      i_budget_code       IN       VARCHAR2,
      o_output_cursor     OUT      pkg_fin_mnet_pay_made_bet2dat.o_fin_pay_bet2date_cursor
   );

   PROCEDURE prc_fin_mnet_pay_made_summary (
      i_channel_company   IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN     fid_contract.con_short_name%type,
      i_supplier          IN       fid_company.com_short_name%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_date_from         IN       DATE,
      i_date_to           IN       DATE,
      i_order_by          IN       VARCHAR2,
      -- Pure finance  mrunmayi kusurkar
      i_reg_code          IN       fid_region.reg_code%TYPE,
      i_report_type       IN       VARCHAR2,
      -- end
      o_output_cursor     OUT      pkg_fin_mnet_pay_made_bet2dat.o_fin_pay_bet2date_cursor
   );
END pkg_fin_mnet_pay_made_bet2dat;
/


CREATE OR REPLACE PACKAGE BODY          "PKG_FIN_MNET_PAY_MADE_BET2DAT"
AS
   PROCEDURE prc_fin_mnet_pay_made_bet2dat (
      i_channel_company   IN       fid_company.com_short_name%TYPE,
      i_con_short_name    IN       fid_contract.con_short_name%type,
      i_supplier          IN       fid_company.com_short_name%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_date_from         IN       DATE,
      i_date_to           IN       DATE,
      i_order_by          IN       VARCHAR2,
      -- Pure finance  mrunmayi kusurkar
      i_reg_code          IN       fid_region.reg_code%TYPE,
      i_report_type       IN       VARCHAR2,
      i_budget_code       IN       VARCHAR2,
      -- end
      o_output_cursor     OUT      pkg_fin_mnet_pay_made_bet2dat.o_fin_pay_bet2date_cursor
   )
   AS
      stmt_str         VARCHAR2 (30000);
      order_stmt       VARCHAR2 (9000);
      start_mth_year   NUMBER;
      end_mth_year     NUMBER;
   BEGIN
      SELECT TO_NUMBER (TO_CHAR (i_date_from, 'YYYYMM')),
             TO_NUMBER (TO_CHAR (i_date_to, 'YYYYMM'))
        INTO start_mth_year,
             end_mth_year
        FROM DUAL;

      DBMS_OUTPUT.put_line (start_mth_year || ' ' || end_mth_year);

      IF    i_report_type = 'General'
         OR i_report_type = 'Adjustment'
         OR i_report_type = '%'
         OR i_report_type = 'Transfer'
      THEN
         stmt_str :=
               '
        SELECT  lic_type,
                con_short_name,
                pay_lic_number,
                gen_title,
                to_char(lic_start, ''DD-MON-RRRR'') lic_start,				--FIN CR Done changes for date format
                TO_CHAR(PAY_STATUS_DATE, ''DD-MON-RRRR'') PAY_STATUS_DATE,		--FIN CR Done changes for date format
                lee_short_name,
                lic_budget_code  Budget_Code,
                LIC_PRICE,
                pat_desc,
                pay_amount,
                /*decode(to_number(to_char(pay_date,''YYYYMM'')),'
                            || start_mth_year
                            || ', pay_amount,null) pay_amount,*/
                lic_currency,
                pay_cur_code,
                round(PAY_RATE,5) PAY_RATE,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                TER_CURRENCY,
                "Realized G/L",
                TO_CHAR(nvl(PAY_DATE,PAY_STATUS_DATE), ''DD-MON-RRRR'') PAY_DATE,	--FIN CR Done changes for date format
                payment_type  Payment_type,
                pay_status,
                pay_number,
                pay_reference,
                PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                pay_comment,
                channel_company,
                company,
                supplier,pay_code,
                ROUND(pay_amount * PAY_RATE,2) local_paymnet,
                /* decode(to_number(to_char(pay_date,''YYYYMM'')),'
                            || start_mth_year
                            || ', ROUND(pay_amount * PAY_RATE,2),null) local_paymnet,*/
                X_PKG_FIN_GET_SPOT_RATE.GET_SPOT_RATE_WITH_INVERSE(LIC_CURRENCY,TER_CURRENCY,lic_start) "Mc-Gregor",
                reg_code,
                RZF_MONTH,
                RZF_YEAR,
                ref_mth,
                decode(PAYTYPE,''PR'',''Pre-payment'',''PP'',''Payment'') PAYTYPE --Finace Dev Phase 1 [Ankur Kasar]
        FROM
        (
        select 
            fl.lic_type,
            fcon.con_short_name,
            fp.pay_lic_number,
            fg.gen_title,
            fl.lic_start,pay_code,
            fp.PAY_STATUS_DATE,
            fp.pay_number,
            sflee.lee_short_name,
            fl.lic_budget_code,
            ROUND(xfsl.lsl_lee_price,2) LIC_PRICE,
            (select fpt.pat_desc
            from fid_payment_type fpt
            where  fpt.pat_code = fp.pay_code) pat_desc,
            round(fp.pay_amount,2) pay_amount,
            fl.lic_currency,
            fp.pay_cur_code,
            round(fp.PAY_RATE,5) PAY_RATE,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
            ft.TER_CUR_CODE "TER_CURRENCY",
            round(sum(xfrf.RZF_REALIZED_FOREX),2) "Realized G/L",
            nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE) PAY_DATE,
            (case when (fp.pay_type = ''PP'')
            then
            ''Liability''
            else
            ''Pre-Payment''
            END
            ) payment_type ,
            decode(fp.pay_status, ''I'', ''In Transit'', ''P'', ''Paid'', fp.pay_status) pay_status,
            fp.pay_reference,
            PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
            fp.pay_comment,
            afc.com_short_name channel_company,
            afc.com_name company,
            bfc.com_short_name supplier,
            fr.reg_code,
            xfrf.RZF_MONTH,
            xfrf.RZF_YEAR,
            (case when (to_number(to_char(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM'')) <> to_number(xfrf.rzf_year||lpad(xfrf.rzf_month,2,0)))
            then
            -1
            else
            0
            END
            ) ref_mth,
            NVL(fp.PAY_TYPE,''PR'') PAYTYPE    --Finace Dev Phase 1 [Ankur Kasar]
        FROM  fid_license fl,
              fid_general fg,
              fid_payment fp,
              fid_contract fcon,
              fid_company afc,
              FID_COMPANY bfc,
              FID_LICENSEE Pflee,
              fid_licensee sflee,
              fid_region fr,
              x_fin_lic_sec_lee xfsl,
              x_fin_realized_forex xfrf,
              fid_territory ft
        where fl.LIC_NUMBER = fp.PAY_LIC_NUMBER
          and Pflee.LEE_NUMBER = fl.LIC_LEE_NUMBER
          and Pflee.LEE_SPLIT_REGION = fr.REG_ID(+)
          and  xfsl.LSL_NUMBER = fp.PAY_LSL_NUMBER
          and Sflee.LEE_NUMBER = xfsl.LSL_LEE_NUMBER
          and fl.lic_number = xfsl.lsl_lic_number
          and fl.lic_gen_refno = fg.gen_refno
          AND fl.LIC_CON_NUMBER = fcon.CON_NUMBER
          AND afc.COM_TYPE IN (''CC'', ''BC'')
          AND fp.pay_status IN (''I'', ''P'')
          and fcon.con_com_number = bfc.com_number
          and fp.PAY_SOURCE_COM_NUMBER = afc.COM_NUMBER
          ---- and lic_number = RZF_LIC_NUMBER
          ---- and lsl_number=RZF_LSL_NUMBER
          and fp.pay_number = xfrf.RZF_PAY_NUMBER(+)
        
          AND (
          (
          (TRUNC(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE)) BETWEEN '''
                      || i_date_from
                      || ''' AND '''
                      || i_date_to
                      || ''')
          AND
          ( ( xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0)) =to_number(to_char(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM''))
          )
          )
          )
          and ft.TER_CODE = afc.COM_TER_CODE
          and pflee.LEE_CHA_COM_NUMBER = afc.COM_NUMBER
          and UPPER(xfrf.RZF_ACCOUNT_HEAD) <> ''ED''
          and fcon.con_short_name LIKE '''||i_con_short_name||'''
        group by  xfrf.RZF_REALIZED_FOREX,
                  xfrf.rzf_pay_number,
                  fl.lic_type,
                  fcon.con_short_name,
                  fp.pay_lic_number,
                  fg.gen_title,
                  fl.lic_start,
                  fp.pay_code,
                  fp.PAY_STATUS_DATE,
                  fp.pay_number,
                  sflee.lee_short_name,
                  xfsl.lsl_lee_price,
                  fl.lic_currency,
                  fp.pay_cur_code,
                  fp.PAY_RATE,
                  fp.PAY_DATE,
                  fp.pay_reference,
                  PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                  fp.pay_comment,
                  fr.reg_code,
                  afc.com_short_name,
                  afc.com_name,
                  bfc.com_short_name,
                  fp.pay_status,
                  fp.pay_amount,
                  ft.TER_CUR_CODE,
                  xfrf.RZF_MONTH,
                  xfrf.RZF_YEAR,
                  fl.lic_budget_code,
                  fl.lic_acct_date,
                  fp.PAY_TYPE--Finace Dev Phase 1 [Ankur Kasar]
        
        UNION
        
        select  
              fl.lic_type,
              fcon.con_short_name,
              fp.pay_lic_number,
              fg.gen_title,
              fl.lic_start,
              fp.pay_code,
              fp.PAY_STATUS_DATE,
              fp.pay_number,
              sflee.lee_short_name,
              fl.lic_budget_code,
              ROUND(xfsl.lsl_lee_price,2) LIC_PRICE,
              (select fpt.pat_desc
              from fid_payment_type fpt
              WHERE  fpt.pat_code = fp.pay_code) pat_desc,
              Round(fp.pay_amount,2) pay_amount,
              fl.lic_currency,
              fp.pay_cur_code,
              Round(fp.PAY_RATE,5) PAY_RATE,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
              ft.TER_CUR_CODE "TER_CURRENCY",
              null "Realized G/L",
              nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE) PAY_DATE,
              (case when (fp.pay_type = ''PP'')
              then
              ''Liability''
              else
              ''Pre-Payment''
              END
              ) payment_type,
              decode(fp.pay_status, ''I'', ''In Transit'', ''P'', ''Paid'', pay_status) pay_status,
              fp.pay_reference,
              PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
              fp.pay_comment,
              afc.com_short_name channel_company,
              afc.com_name  company,
              bfc.com_short_name supplier,
              reg_code,
              null RZF_MONTH,
              null RZF_YEAR,
              0 ref_mth,
              NVL(fp.PAY_TYPE,''PR'') PAYTYPE --Finace Dev Phase 1 [Ankur Kasar]
        FROM  fid_license fl,
              fid_general fg,
              fid_payment fp,
              fid_contract fcon,
              fid_company afc,
              FID_COMPANY bfc,
              FID_LICENSEE Pflee,
              fid_licensee sflee,
              fid_region fr,
              x_fin_lic_sec_lee xfsl,
              fid_territory ft
        where fl.LIC_NUMBER = fp.PAY_LIC_NUMBER
          and Pflee.LEE_NUMBER = fl.LIC_LEE_NUMBER
          and Pflee.LEE_SPLIT_REGION = fr.REG_ID(+)
          and xfsl.LSL_NUMBER = fp.PAY_LSL_NUMBER
          and Sflee.LEE_NUMBER = xfsl.LSL_LEE_NUMBER
          and fl.lic_number = xfsl.lsl_lic_number
          and fl.lic_gen_refno = fg.gen_refno
          AND fl.LIC_CON_NUMBER = fcon.CON_NUMBER
          AND afc.COM_TYPE IN (''CC'', ''BC'')
          AND fp.pay_status IN (''I'', ''P'')
          and fcon.con_com_number = bfc.com_number
          and fp.PAY_SOURCE_COM_NUMBER = afc.COM_NUMBER
          and TRUNC(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE)) BETWEEN '''
                    || i_date_from
                    || ''' AND '''
                    || i_date_to
                    || '''
        --to inclucde ZAR and Prepayments
          and fp.pay_number not in (select
                                    distinct fp.pay_number
                                    from fid_payment fp,x_fin_realized_forex xfrf
                                    where xfrf.rzf_pay_number(+) = fp.pay_number
                                    and UPPER(xfrf.RZF_ACCOUNT_HEAD) <> ''ED''
          and TRUNC(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE)) BETWEEN '''
                      || i_date_from
                      || ''' AND '''
                      || i_date_to
                      || '''
          and fp.pay_status in (''I'',''P'')
          AND ((xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0)) =TO_NUMBER(TO_CHAR(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM''))
          ))
          and ft.TER_CODE = afc.COM_TER_CODE
          and pflee.LEE_CHA_COM_NUMBER = afc.COM_NUMBER
          and fcon.con_short_name LIKE '''||i_con_short_name||''' -- Changes for CVS and Alias for Finance Report Rewrite
                                                                        /*group by xfrf.RZF_REALIZED_FOREX,
                                                                        fl.lic_type,
                                                                        fcon.con_short_name,
                                                                        fp.pay_lic_number,
                                                                        fg.gen_title,
                                                                        fl.lic_start,
                                                                        fp.pay_code,
                                                                        fp.PAY_STATUS_DATE,
                                                                        fp.pay_number,
                                                                        sflee.lee_short_name,
                                                                        xfsl.lsl_lee_price,
                                                                        fl.lic_currency,
                                                                        fp.pay_cur_code,
                                                                        fp.PAY_RATE,
                                                                        fp.PAY_DATE,
                                                                        fp.pay_reference,
                                                                        PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                                                                        fp.pay_comment,
                                                                        fr.reg_code,
                                                                        afc.com_short_name,
                                                                        afc.com_name,
                                                                        bfc.com_short_name,
                                                                        fp.pay_status,
                                                                        fp.pay_amount,
                                                                        ft.TER_CUR_CODE,
                                                                        xfrf.RZF_MONTH,
                                                                        xfrf.RZF_YEAR*/
        
        union
        select   
              fl.lic_type,
              fcon.con_short_name,
              fp.pay_lic_number,
              fg.gen_title,
              fl.lic_start,fp.pay_code,
              fp.PAY_STATUS_DATE,
              fp.pay_number,
              flees.lee_short_name,
              fl.lic_budget_code,
              ROUND(xfsl.lsl_lee_price,2) LIC_PRICE,
              (select fpt.pat_desc
              from fid_payment_type fpt
              WHERE  fpt.pat_code = fp.pay_code) pat_desc,
              null pay_amount,
              -- Round(fp.pay_amount,2) pay_amount,
              fl.lic_currency,
              fp.pay_cur_code,
              Round(fp.PAY_RATE,5) PAY_RATE,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
              ft.TER_CUR_CODE "TER_CURRENCY",
              Round(sum(xfrf.RZF_REALIZED_FOREX),2) "Realized G/L",
              nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE) PAY_DATE,
              (case when (fp.pay_type = ''PP'')
              then
              ''Liability''
              else
              ''Pre-Payment''
              END
              ) payment_type,
              decode(fp.pay_status, ''I'', ''In Transit'', ''P'', ''Paid'', pay_status) pay_status,
              fp.pay_reference,
              PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
              fp.pay_comment,
              fcom.com_short_name channel_company,
              fcom.com_name  company,
              fsup.com_short_name supplier,
              fr.reg_code,
              xfrf.RZF_MONTH,
              xfrf.RZF_YEAR,
              -1 ref_mth,
              NVL(fp.PAY_TYPE,''PR'') PAYTYPE --Finace Dev Phase 1 [Ankur Kasar]
        FROM  fid_license fl,
              fid_general fg,
              fid_payment fp,
              fid_contract fcon,
              fid_company fcom,
              FID_COMPANY fSUP,
              FID_LICENSEE flee,
              fid_licensee flees,
              fid_region fr,
              x_fin_lic_sec_lee xfsl,
              x_fin_realized_forex xfrf,
              fid_territory ft
        where fl.LIC_NUMBER = fp.PAY_LIC_NUMBER
          and flee.LEE_NUMBER = fl.LIC_LEE_NUMBER
          and flee.LEE_SPLIT_REGION = fr.REG_ID(+)
          and xfsl.LSL_NUMBER = fp.PAY_LSL_NUMBER
          and flees.LEE_NUMBER = xfsl.LSL_LEE_NUMBER
          and fl.lic_number = xfsl.lsl_lic_number
          and fl.lic_gen_refno = fg.gen_refno
          AND fl.LIC_CON_NUMBER = fcon.CON_NUMBER
          AND fcom.COM_TYPE IN (''CC'', ''BC'')
          AND fp.pay_status IN (''I'', ''P'')
          and fcon.con_com_number = fsup.com_number
          and fp.PAY_SOURCE_COM_NUMBER = fcom.COM_NUMBER
          AND fp.PAY_NUMBER = xfrf.RZF_PAY_NUMBER
          
          --for Roy pre payments where realized is calcated on license start
          AND
          (
          (
          ( xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0) ) <> TO_CHAR(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM'')
          )
          and
          ( xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0)) BETWEEN '''
                      || start_mth_year
                      || ''' AND '''
                      || end_mth_year
                      || '''
          )
          and ft.TER_CODE = fcom.COM_TER_CODE
          and flee.LEE_CHA_COM_NUMBER = fcom.COM_NUMBER
          and UPPER(xfrf.RZF_ACCOUNT_HEAD) <> ''ED''
          and fcon.con_short_name LIKE '''||i_con_short_name||''' --Alias for Finance Report Rewrite
        group by  xfrf.RZF_REALIZED_FOREX,
                  xfrf.rzf_pay_number,
                  fl.lic_type,
                  fcon.con_short_name,
                  fp.pay_lic_number,
                  fg.gen_title,
                  fl.lic_start,
                  fp.pay_code,
                  fp.PAY_STATUS_DATE,
                  fp.pay_number,
                  flees.lee_short_name,
                  xfsl.lsl_lee_price,
                  fl.lic_currency,
                  fp.pay_cur_code,
                  fp.PAY_RATE,
                  fp.PAY_DATE,
                  fp.pay_reference,
                  PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                  fp.pay_comment,
                  fr.reg_code,
                  fcom.com_short_name,
                  fcom.com_name,
                  fsup.com_short_name,
                  fp.pay_status,
                  fp.pay_amount,
                  ft.TER_CUR_CODE,
                  xfrf.RZF_MONTH,
                  xfrf.RZF_YEAR,
                  fl.lic_budget_code,
                  fl.lic_acct_date,
                  fp.PAY_TYPE--Finace Dev Phase 1 [Ankur Kasar]
        
        )where channel_company like decode('''
                    || i_channel_company
                    || ''',''%'',channel_company,'''
                    || i_channel_company
                    || ''')';
              END IF;
        
              IF i_report_type = 'Spot Rate Exception'
              THEN
                 stmt_str :=
                       '
        SELECT 
              lic_type,
              con_short_name,
              pay_lic_number,
              gen_title,
              to_char(lic_start, ''DD-MON-RRRR'') lic_start,			     --FIN CR Done changes for date format
              TO_CHAR(PAY_STATUS_DATE, ''DD-MON-RRRR'') PAY_STATUS_DATE,	     --FIN CR Done changes for date format
              lee_short_name,
              lic_budget_code  Budget_Code,
              LIC_PRICE,
              pat_desc,
              decode(to_number(to_char(pay_date,''YYYYMM'')),'
                          || start_mth_year
                          || ', pay_amount,null) pay_amount,
              lic_currency,
              pay_cur_code,
              round(PAY_RATE,5) PAY_RATE,
              TER_CURRENCY,
              "Realized G/L",
              TO_CHAR(nvl(PAY_DATE,PAY_STATUS_DATE), ''DD-MON-RRRR'') PAY_DATE,	--FIN CR Done changes for date format
              pay_status,
              pay_number,
              pay_reference,
              PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
              pay_comment,
              channel_company,
              company,
              supplier,pay_code,
              decode(to_number(to_char(pay_date,''YYYYMM'')),'
                          || start_mth_year
                          || ', ROUND(pay_amount * PAY_RATE,2),null) local_paymnet,
              X_PKG_FIN_GET_SPOT_RATE.GET_SPOT_RATE_WITH_INVERSE(LIC_CURRENCY,TER_CURRENCY,lic_start) "Mc-Gregor",
              reg_code,
              RZF_MONTH,
              RZF_YEAR,
              ref_mth,
               decode(PAYTYPE,''PR'',''Pre-payment'',PAYTYPE,''PP'',''Payment'')  PAYTYPE         --Finace Dev Phase 1 [Ankur Kasar]   
              FROM
              (
              select    
                  fl.lic_type,
                  fcon.con_short_name,
                  fp.pay_lic_number,
                  fg.gen_title,
                  fl.lic_start,fp.pay_code,
                  fp.PAY_STATUS_DATE,
                  fp.pay_number,
                  flees.lee_short_name,
                  fl.lic_budget_code,
                  ROUND(xfsl.lsl_lee_price,2) LIC_PRICE,
                  (select fpt.pat_desc
                  from fid_payment_type fpt
                  where  fpt.pat_code = fp.pay_code) pat_desc,
                  round(fp.pay_amount,2) pay_amount,
                  fl.lic_currency,
                  fp.pay_cur_code,
                  round(fp.PAY_RATE,5) PAY_RATE,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
                  ft.TER_CUR_CODE "TER_CURRENCY",
                  round(sum(xfrf.RZF_REALIZED_FOREX),2) "Realized G/L",
                  nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE) PAY_DATE,
                  decode(fp.pay_status, ''I'', ''In Transit'', ''P'', ''Paid'', fp.pay_status) pay_status,
                  fp.pay_reference,
                  PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                  fp.pay_comment,
                  fcom.com_short_name channel_company,
                  fcom.com_name company,
                  fsup.com_short_name supplier,
                  fr.reg_code,
                  xfrf.RZF_MONTH,
                  xfrf.RZF_YEAR,
                  (case when (to_number(to_char(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM'')) <> to_number(xfrf.rzf_year||lpad(xfrf.rzf_month,2,0)))
                  then
                  -1
                  else
                  0
                  END
                  ) ref_mth,
                  NVL(fp.PAY_TYPE,''PR'') PAYTYPE --Finace Dev Phase 1 [Ankur Kasar]
              
        FROM  fid_license fl,
              fid_general fg,
              fid_payment fp,
              fid_contract fcon,
              fid_company fcom,
              FID_COMPANY fsup,
              FID_LICENSEE flee,
              fid_licensee flees,
              fid_region fr,
              x_fin_lic_sec_lee xfsl,
              x_fin_realized_forex xfrf,
              fid_territory ft
        where fl.LIC_NUMBER = fp.PAY_LIC_NUMBER
          and flee.LEE_NUMBER = fl.LIC_LEE_NUMBER
          and flee.LEE_SPLIT_REGION = fr.REG_ID(+)
          and  xfsl.LSL_NUMBER = fp.PAY_LSL_NUMBER
          and flees.LEE_NUMBER = xfsl.LSL_LEE_NUMBER
          and fl.lic_number = xfsl.lsl_lic_number
          and fl.lic_gen_refno = fg.gen_refno
          AND fl.LIC_CON_NUMBER = fcon.CON_NUMBER
          AND fcom.COM_TYPE IN (''CC'', ''BC'')
          AND fp.pay_status IN (''I'', ''P'')
          and fcon.con_com_number = fsup.com_number
          and fp.PAY_SOURCE_COM_NUMBER = fcom.COM_NUMBER
          ---- and fl.lic_number = xfrf.RZF_LIC_NUMBER
          ---- and zfsl.lsl_number=xfrf.RZF_LSL_NUMBER
          and fp.pay_number = xfrf.RZF_PAY_NUMBER(+)
          AND fl.lic_status != ''T'' --added so that t licenses should not be displayed
          
          AND (
          (
          (TRUNC(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE)) BETWEEN '''
                      || i_date_from
                      || ''' AND '''
                      || i_date_to
                      || ''')
          AND
          ( ( xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0)) =to_number(to_char(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM''))
          )
          )
          )
          and ft.TER_CODE = fcom.COM_TER_CODE
          and flee.LEE_CHA_COM_NUMBER = fcom.COM_NUMBER
          and UPPER(xfrf.RZF_ACCOUNT_HEAD) <> ''ED''
          and fcon.con_short_name LIKE '''||i_con_short_name||''' --Alias for finance Report Rewrite
        group by  xfrf.RZF_REALIZED_FOREX,
                  xfrf.rzf_pay_number,
                  fl.lic_type,
                  fcon.con_short_name,
                  fp.pay_lic_number,
                  fg.gen_title,
                  fl.lic_start,
                  fp.pay_code,
                  fp.PAY_STATUS_DATE,
                  fp.pay_number,
                  flees.lee_short_name,
                  xfsl.lsl_lee_price,
                  fl.lic_currency,
                  fp.pay_cur_code,
                  fp.PAY_RATE,
                  fp.PAY_DATE,
                  fp.pay_reference,
                  PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                  fp.pay_comment,
                  fr.reg_code,
                  fcom.com_short_name,
                  fcom.com_name,
                  fsup.com_short_name,
                  fp.pay_status,
                  fp.pay_amount,
                  ft.TER_CUR_CODE,
                  xfrf.RZF_MONTH,
                  xfrf.RZF_YEAR,
                  fl.lic_budget_code,
                  FP.PAY_TYPE--Finace Dev Phase 1 [Ankur Kasar]
        
        UNION
        
        select  
              lic_type,
              con_short_name,
              pay_lic_number,
              gen_title,
              lic_start,
              pay_code,
              PAY_STATUS_DATE,
              pay_number,
              flees.lee_short_name,
              lic_budget_code,
              ROUND(lsl_lee_price,2) LIC_PRICE,
              (select pat_desc
              from fid_payment_type
              WHERE  pat_code = pay_code) pat_desc,
              Round(pay_amount,2) pay_amount,
              lic_currency,
              pay_cur_code,
              Round(PAY_RATE,5) PAY_RATE,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
              TER_CUR_CODE "TER_CURRENCY",
              null "Realized G/L",
              nvl(PAY_DATE,PAY_STATUS_DATE) PAY_DATE,
              decode(pay_status, ''I'', ''In Transit'', ''P'', ''Paid'', pay_status) pay_status,
              pay_reference,
              PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
              pay_comment,
              fcom.com_short_name channel_company,
              fcom.com_name  company,
              fsup.com_short_name supplier,
              reg_code,
              null RZF_MONTH,
              null RZF_YEAR,
              0 ref_mth,
              NVL(fp.PAY_TYPE,''PR'') PAYTYPE --Finace Dev Phase 1 [Ankur Kasar]
        FROM  fid_license fl,
              fid_general fg,
              fid_payment fp,
              fid_contract fcon,
              fid_company fcom,
              FID_COMPANY fsup,
              FID_LICENSEE flee,
              fid_licensee flees,
              fid_region fr,
              x_fin_lic_sec_lee xfsl,
              fid_territory ft
        where fl.LIC_NUMBER = PAY_LIC_NUMBER
          and flee.LEE_NUMBER = fl.LIC_LEE_NUMBER
          and flee.LEE_SPLIT_REGION = fr.REG_ID(+)
          and xfsl.LSL_NUMBER = PAY_LSL_NUMBER
          and flees.LEE_NUMBER = xfsl.LSL_LEE_NUMBER
          and fl.lic_number = xfsl.lsl_lic_number
          and fl.lic_gen_refno = fg.gen_refno
          AND fl.LIC_CON_NUMBER = fcon.CON_NUMBER
          AND fcom.COM_TYPE IN (''CC'', ''BC'')
          AND pay_status IN (''I'', ''P'')
          and fcon.con_com_number = fsup.com_number
          and PAY_SOURCE_COM_NUMBER = fcom.COM_NUMBER
          and TRUNC(nvl(PAY_DATE,fp.PAY_STATUS_DATE)) BETWEEN '''
                      || i_date_from
                      || ''' AND '''
                      || i_date_to
                      || '''
          --to inclucde ZAR and Prepayments
          and pay_number not in (select
          distinct fp.pay_number
          from fid_payment fp,x_fin_realized_forex xfrf
          where xfrf.rzf_pay_number(+) = fp.pay_number
          and UPPER(xfrf.RZF_ACCOUNT_HEAD) <> ''ED''
          and TRUNC(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE)) BETWEEN '''
                      || i_date_from
                      || ''' AND '''
                      || i_date_to
                      || '''
          and fp.pay_status in (''I'',''P'')
          AND ((xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0)) =TO_NUMBER(TO_CHAR(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM''))
          ))
          and ft.TER_CODE = fcom.COM_TER_CODE
          and flee.LEE_CHA_COM_NUMBER = fcom.COM_NUMBER
          and fcon.con_short_name LIKE '''||i_con_short_name||'''
                                                                                    /*group by xfrf.RZF_REALIZED_FOREX,
                                                                                    fl.lic_type,
                                                                                    fcon.con_short_name,
                                                                                    pay_lic_number,
                                                                                    fg.gen_title,
                                                                                    fl.lic_start,
                                                                                    fp.pay_code,
                                                                                    fp.PAY_STATUS_DATE,
                                                                                    fp.pay_number,
                                                                                    flees.lee_short_name,
                                                                                    xfsl.lsl_lee_price,
                                                                                    fl.lic_currency,
                                                                                    fp.pay_cur_code,
                                                                                    fp.PAY_RATE,
                                                                                    fp.PAY_DATE,
                                                                                    fp.pay_reference,
                                                                                    PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                                                                                    fp.pay_comment,
                                                                                    fr.reg_code,
                                                                                    fcom.com_short_name,
                                                                                    fcom.com_name,
                                                                                    fsup.com_short_name,
                                                                                    fp.pay_status,
                                                                                    fp.pay_amount,
                                                                                    ft.TER_CUR_CODE,
                                                                                    xfrf.RZF_MONTH,
                                                                                    RZF_YEAR*/
                                                                                    
        union
        select    
              fl.lic_type,
              fcon.con_short_name,
              fp.pay_lic_number,
              fg.gen_title,
              fl.lic_start,pay_code,
              fp.PAY_STATUS_DATE,
              fp.pay_number,
              flees.lee_short_name,
              fl.lic_budget_code,
              ROUND(xfsl.lsl_lee_price,2) LIC_PRICE,
              (select fpt.pat_desc
              from fid_payment_type fpt
              WHERE  fpt.pat_code = fp.pay_code) pat_desc,
              Round(fp.pay_amount,2) pay_amount,
              fl.lic_currency,
              fp.pay_cur_code,
              Round(fp.PAY_RATE,5) PAY_RATE,   -- 02-Nov-2016 [Zeshan Khan] [Finance Dev Phase I] Spot rates upto 5 decimals.
              ft.TER_CUR_CODE "TER_CURRENCY",
              Round(sum(xfrf.RZF_REALIZED_FOREX),2) "Realized G/L",
              nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE) PAY_DATE,
              decode(fp.pay_status, ''I'', ''In Transit'', ''P'', ''Paid'', fp.pay_status) pay_status,
              fp.pay_reference,
              PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
              fp.pay_comment,
              fcom.com_short_name channel_company,
              fcom.com_name  company,
              fsup.com_short_name supplier,
              fr.reg_code,
              xfrf.RZF_MONTH,
              xfrf.RZF_YEAR,
              -1 ref_mth,
              NVL(fp.PAY_TYPE,''PR'') PAYTYPE --Finace Dev Phase 1 [Ankur Kasar]
        FROM  fid_license fl,
              fid_general fg,
              fid_payment fp,
              fid_contract fcon,
              fid_company fcom,
              FID_COMPANY fsup,
              FID_LICENSEE flee,
              fid_licensee flees,
              fid_region fr,
              x_fin_lic_sec_lee xfsl,
              x_fin_realized_forex xfrf,
              fid_territory ft
        where fl.LIC_NUMBER = fp.PAY_LIC_NUMBER
          and flee.LEE_NUMBER = fl.LIC_LEE_NUMBER
          and flee.LEE_SPLIT_REGION = fr.REG_ID(+)
          and xfsl.LSL_NUMBER = fp.PAY_LSL_NUMBER
          and flees.LEE_NUMBER = xfsl.LSL_LEE_NUMBER
          and fl.lic_number = xfsl.lsl_lic_number
          and fl.lic_gen_refno = fg.gen_refno
          AND fl.LIC_CON_NUMBER = fcon.CON_NUMBER
          AND fcom.COM_TYPE IN (''CC'', ''BC'')
          AND fp.pay_status IN (''I'', ''P'')
          and fcon.con_com_number = fsup.com_number
          and fp.PAY_SOURCE_COM_NUMBER = fcom.COM_NUMBER
          AND fp.PAY_NUMBER = xfrf.RZF_PAY_NUMBER
          AND fl.lic_status != ''T'' --added so that t licenses should not be displayed
          
          --for Roy pre payments where realized is calcated on license start
          AND
          (
          (
          ( xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0) ) <> TO_CHAR(nvl(fp.PAY_DATE,PAY_STATUS_DATE),''YYYYMM'')
          )
          and
          ( xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0)) BETWEEN '''
                      || start_mth_year
                      || ''' AND '''
                      || end_mth_year
                      || '''
          )
          and ft.TER_CODE = fcom.COM_TER_CODE
          and flee.LEE_CHA_COM_NUMBER = fcom.COM_NUMBER
          and UPPER(xfrf.RZF_ACCOUNT_HEAD) <> ''ED''
          and fcon.con_short_name LIKE '''||i_con_short_name||'''
        group by  xfrf.RZF_REALIZED_FOREX,
                  xfrf.rzf_pay_number,
                  fl.lic_type,
                  fcon.con_short_name,
                  fp.pay_lic_number,
                  fg.gen_title,
                  fl.lic_start,
                  fp.pay_code,
                  fp.PAY_STATUS_DATE,
                  fp.pay_number,
                  flees.lee_short_name,
                  xfsl.lsl_lee_price,
                  fl.lic_currency,
                  fp.pay_cur_code,
                  fp.PAY_RATE,
                  fp.PAY_DATE,
                  fp.pay_reference,
                  PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                  fp.pay_comment,
                  fr.reg_code,
                  fcom.com_short_name,
                  fcom.com_name,
                  fsup.com_short_name,
                  fp.pay_status,
                  fp.pay_amount,
                  ft.TER_CUR_CODE,
                  xfrf.RZF_MONTH,
                  xfrf.RZF_YEAR,
                  fl.lic_budget_code,
                  FP.PAY_TYPE--Finace Dev Phase 1 [Ankur Kasar]
        
        )where channel_company like decode('''
                    || i_channel_company
                    || ''',''%'',channel_company,'''
                    || i_channel_company
                    || ''')';
              END IF;
        
        /*
        IF i_channel_company != '%'
        THEN
        STMT_STR :=
        STMT_STR
        || ' AND channel_company like UPPER ('''
        || i_channel_company
        || ''')';
        END IF;*/
              IF i_supplier != '%'
              THEN
                 stmt_str :=
                    stmt_str || ' AND supplier like UPPER (''' || i_supplier || ''')';
              END IF;
        
              IF i_budget_code != '%'
              THEN
                 stmt_str :=
                       stmt_str
                    || ' AND lic_budget_code like UPPER ('''
                    || i_budget_code
                    || ''')';
              END IF;
        
              IF i_licensee != '%'
              THEN
                 stmt_str :=
                       stmt_str
                    || ' AND lee_short_name like UPPER ('''
                    || i_licensee
                    || ''')';
              END IF;
        
              IF i_reg_code != '%'
              THEN
                 stmt_str :=
                    stmt_str || ' AND reg_code like UPPER (''' || i_reg_code || ''')';
              END IF;
        
              IF i_report_type != '%'
              THEN
                 IF i_report_type = 'General'
                 THEN
                    stmt_str := stmt_str || ' AND pay_code IN (''G'',''D'',''S'')';
                 ELSIF i_report_type = 'Adjustment'
                 THEN
                    stmt_str := stmt_str || ' AND pay_code IN (''A'')';
                 ELSIF i_report_type = 'Transfer'
                 THEN
                    stmt_str := stmt_str || ' AND pay_code IN (''T'')';
                 END IF;
              END IF;
        
              IF i_report_type = 'Spot Rate Exception'
              THEN
                 stmt_str :=
                       stmt_str
                    || ' AND ( ABS((PAY_RATE - X_PKG_FIN_GET_SPOT_RATE.GET_SPOT_RATE_WITH_INVERSE(LIC_CURRENCY,TER_CURRENCY,nvl(PAY_DATE,PAY_STATUS_DATE)))/
        X_PKG_FIN_GET_SPOT_RATE.GET_SPOT_RATE_WITH_INVERSE(LIC_CURRENCY,TER_CURRENCY,nvl(PAY_DATE,PAY_STATUS_DATE)) * 100) > 5 )';
              END IF;
        
              IF i_report_type = 'Transfer History'
              THEN
       stmt_str :=
             'select 
                   fl.lic_type
                  ,fcon.con_short_name
                  ,fp.pay_lic_number
                  ,fg.gen_title
                  ,flees.lee_short_name
                  ,fl.lic_budget_code
                  ,fl.lic_amort_code
                  ,TO_CHAR(fp.pay_status_date, ''DD-MON-RRRR'') PAY_STATUS_DATE 		--FIN CR Done changes for date format
                  ,fp.pay_entry_oper
                  ,fp.pay_comment
                  ,fp.pay_code
                  ,fp.pay_cur_code
                  ,round (fp.pay_amount, 2) pay_amount
                  ,fl.lic_currency
                  ,ft.ter_cur_code "ter_currency"
                  ,Round(( SELECT  sum(xfrf.RZF_REALIZED_FOREX)
                             FROM   x_fin_realized_forex xfrf
                            where  fl.lic_number = xfrf.RZF_LIC_NUMBER
                              AND  xfsl.lsl_number = xfrf.RZF_LSL_NUMBER(+)
                              AND fp.pay_number = xfrf.RZF_PAY_NUMBER ),2) "Realized G/L"
                  ,fcom.com_short_name channel_company
                  ,fsup.com_short_name supplier
                  ,fr.reg_code
                  ,fp.pay_source_number
                  -- source
                  ,x.lic_type s_lic_type
                  ,x.con_short_name s_con_short_name
                  ,x.lic_number s_lic_number
                  ,x.gen_title s_title
                  ,x.lee_short_name s_licensee
                  ,x.lic_budget_code s_budget_code
                  ,x.lic_amort_code s_amort_code
                  ,TO_CHAR(x.pay_status_date, ''DD-MON-RRRR'') s_paymnet_date		--FIN CR Done changes for date format
                  ,x.pay_source_number s_pay_source_number
                  ,x.pay_amount s_pay_amount
                  ,x.PAY_ENTRY_OPER s_username
                  , decode(NVL(fp.PAY_TYPE,''PR''),''PR'',''Pre-payment'',NVL(fp.PAY_TYPE,''PR''),''PP'',''Payment'') PAYTYPE--Finace Dev Phase 1 [Ankur Kasar]
        from  fid_license fl,
              fid_general fg,
              fid_payment fp,
              fid_contract fcon,
              fid_company fcom,
              fid_company fsup,
              fid_licensee flee,
              fid_licensee flees,
              fid_region fr,
              x_fin_lic_sec_lee xfsl,
              x_fin_realized_forex xfrf,
              fid_territory ft,
        (
        select
             fl.lic_type
            ,fcon.con_short_name
            ,fl.lic_number
            ,fg.gen_title
            ,bflee.lee_short_name
            ,fl.lic_budget_code
            ,fl.lic_amort_code
            ,fp.pay_status_date
            ,fp.pay_source_number
            ,fp.pay_amount
            ,fp.PAY_ENTRY_OPER
        from  fid_license fl,
              fid_general fg,
              fid_payment fp,
              fid_contract fcon,
              fid_licensee bflee, --sec
              x_fin_lic_sec_lee xfsl,
              fid_company afc,
              fid_company bfc,
              fid_licensee aflee, --pri
              fid_region fr
        where fl.lic_gen_refno =  fg.gen_refno
          and fl.lic_con_number = fcon.con_number
          and fl.lic_number = fp.pay_lic_number
          and fp.pay_amount > 1
          and bflee.lee_number(+) = xfsl.lsl_lee_number
          and xfsl.lsl_number(+) = fp.pay_lsl_number
          and fp.pay_code = ''T''
          and fp.pay_status in (''I'', ''P'')
          and fcon.con_com_number = bfc.com_number
          and fp.pay_source_com_number = afc.com_number
          and afc.com_type in (''CC'', ''BC'')
          and aflee.lee_number = fl.lic_lee_number
          AND fl.lic_status != ''T'' --added so that t licenses should not be displayed
          and aflee.lee_split_region = fr.reg_id(+)
          and bfc.com_short_name like decode('''
                      || i_supplier
                      || ''',''%'',bfc.com_short_name,'''
                      || i_supplier
                      || ''')
          and afc.com_short_name like decode('''
                      || i_channel_company
                      || ''',''%'',afc.com_short_name,'''
                      || i_channel_company
                      || ''')
          and fr.reg_code like decode('''
                      || i_reg_code
                      || ''',''%'',fr.reg_code,'''
                      || i_reg_code
                      || ''')
          and aflee.lee_short_name like decode('''
                      || i_licensee
                      || ''',''%'',aflee.lee_short_name,'''
                      || i_licensee
                      || ''')
          and trunc(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE)) between '''
                      || i_date_from
                      || ''' and '''
                      || i_date_to
                      || '''
        )x
        where fl.lic_number = fp.pay_lic_number
          and flee.lee_number = fl.lic_lee_number
          and flee.lee_split_region = fr.reg_id(+)
          and xfsl.lsl_number(+) = fp.pay_lsl_number
          and flees.lee_number(+) = xfsl.lsl_lee_number
          and fl.lic_gen_refno = fg.gen_refno
          and fl.lic_number =xfsl.lsl_lic_number
          -- and fl.lic_number=xfrf.RZF_LIC_NUMBER
          -- and xfsl.lsl_number = xfrf.RZF_LSL_NUMBER
          -- and fp.pay_number = xfrf.RZF_PAY_NUMBER
          and ft.ter_code = fcom.com_ter_code
          AND flee.lee_cha_com_number = fcom.com_number
          AND fl.lic_con_number = fcon.con_number
          and fcom.com_type in (''CC'', ''BC'')
          and fp.pay_status in (''I'', ''P'')
          and fp.pay_code = ''T''
          and fp.pay_amount < 1
          AND fl.lic_status != ''T'' --added so that t licenses should not be displayed
          and fcon.con_com_number = fsup.com_number
          and fp.pay_source_com_number = fcom.com_number
          and fcon.con_short_name LIKE '''||i_con_short_name||'''
          and x.pay_source_number = fp.pay_source_number
          and fsup.com_short_name like decode('''
                      || i_supplier
                      || ''',''%'',fsup.com_short_name,'''
                      || i_supplier
                      || ''')
          and fcom.com_short_name like decode('''
                      || i_channel_company
                      || ''',''%'',fcom.com_short_name,'''
                      || i_channel_company
                      || ''')
          and fr.reg_code like decode('''
                      || i_reg_code
                      || ''',''%'',fr.reg_code,'''
                      || i_reg_code
                      || ''')
          and flee.lee_short_name like decode('''
                      || i_licensee
                      || ''',''%'',flee.lee_short_name,'''
                      || i_licensee
                      || ''')
          and trunc(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE)) between '''
                      || i_date_from
                      || ''' and '''
                      || i_date_to
                      || '''
          
        
        GROUP BY fl.lic_type
                ,fcon.con_short_name
                ,fp.pay_lic_number
                ,fg.gen_title
                ,flees.lee_short_name
                ,fl.lic_budget_code
                ,fl.lic_amort_code
                ,fp.pay_status_date
                ,fp.pay_entry_oper
                ,fp.pay_comment
                ,fp.pay_code
                ,fp.pay_cur_code
                ,round(fp.pay_amount,2)
                ,fl.lic_currency
                ,ft.ter_cur_code
                ,fcom.com_short_name
                ,fsup.com_short_name
                ,fr.reg_code
                ,fp.pay_source_number
                ,x.lic_type
                ,x.con_short_name
                ,x.lic_number
                ,x.gen_title
                ,x.lee_short_name
                ,x.lic_budget_code
                ,x.lic_amort_code
                ,x.pay_status_date
                ,x.pay_source_number
                ,x.pay_amount
                ,x.PAY_ENTRY_OPER
                ,xfsl.lsl_number
                ,fp.pay_number
                ,fl.lic_number
                ,PAY_DATE
                ,fp.PAY_TYPE--Finace Dev Phase 1 [Ankur Kasar]
                ';
              END IF;
        
              IF UPPER (i_report_type) = UPPER ('Payment Rate/Date Missing')
              THEN
       stmt_str :=
             ' select
                  fl.lic_type,
                  fcon.con_short_name,
                  fp.pay_lic_number,
                  fg.gen_title,
                  fl.lic_start,
                  fp.pay_code,
                  fl.lic_currency,
                  to_char(fp.pay_status_date,''DD-MON-YYYY'') pay_status_date,
                  flees.lee_short_name,
                  fl.lic_budget_code Budget_Code,
                  ROUND(xfsl.lsl_lee_price,2) LIC_PRICE,
                  (select fpt.pat_desc
                  from fid_payment_type fpt
                  WHERE  fpt.pat_code = fp.pay_code) pat_desc,
                  round(fp.pay_amount,2) pay_amount,
                  fp.pay_cur_code,
                  round(fp.PAY_RATE,5) PAY_RATE,
                  fp.pay_date pay_date,
                  decode(fp.pay_status, ''I'', ''In Transit'', ''P'', ''Paid'', fp.pay_status) pay_status,
                  fp.pay_reference,
                  PAY_MNET_REFERENCE, --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                  fp.pay_comment,
                  afc.com_short_name channel_company,
                  afc.com_name  company,
                  bfc.com_short_name supplier,
                  fr.REG_CODE,
                  decode(NVL(fp.PAY_TYPE,''PR''),''PR'',''Pre-payment'',NVL(fp.PAY_TYPE,''PR''),''PP'',''Payment'')  PAYTYPE --Finace Dev Phase 1 [Ankur Kasar]      
        FROM  fid_license fl,
              fid_general fg,
              fid_payment fp,
              fid_contract fcon,
              fid_company afc,
              FID_COMPANY bfc,
              FID_LICENSEE flee,     --pri
              fid_licensee flees,    --sec
              fid_region fr,
              x_fin_lic_sec_lee xfsl
        where fl.LIC_NUMBER = fp.PAY_LIC_NUMBER
          and flee.LEE_NUMBER = fl.LIC_LEE_NUMBER
          and flee.LEE_SPLIT_REGION = fr.REG_ID(+)
          and  xfsl.LSL_NUMBER = fp.PAY_LSL_NUMBER
          and flees.LEE_NUMBER = xfsl.LSL_LEE_NUMBER
          and fl.lic_number = xfsl.lsl_lic_number
          and fl.lic_gen_refno = fg.gen_refno
          and fl.lic_con_number = fcon.con_number
          and afc.com_type in (''CC'', ''BC'')
          and fcon.con_com_number = bfc.com_number
          and fp.pay_source_com_number = afc.com_number
           and fcon.con_short_name LIKE '''||i_con_short_name||'''
          and flee.lee_cha_com_number = afc.com_number
          and fp.pay_status = ''P''
          AND fl.lic_status != ''T'' --added so that t licenses should not be displayed
          and (fp.pay_rate is null or fp.pay_date is null)
          AND ( fp.pay_status_date BETWEEN '''|| i_date_from|| ''' AND '''|| i_date_to|| ''' OR fp.pay_date BETWEEN '''|| i_date_from|| ''' AND '''|| i_date_to|| ''')';
                 IF i_channel_company != '%'
                 THEN
                    stmt_str :=
                          stmt_str
                       || ' AND afc.com_short_name like UPPER ('''
                       || i_channel_company
                       || ''')';
                 END IF;
        
                 IF i_supplier != '%'
                 THEN
                    stmt_str :=
                       stmt_str || ' AND supplier like UPPER (''' || i_supplier
                       || ''')';
                 END IF;
        
                 IF i_budget_code != '%'
                 THEN
                    stmt_str :=
                          stmt_str
                       || ' AND fl.lic_budget_code like UPPER ('''
                       || i_budget_code
                       || ''')';
                 END IF;
        
                 IF i_licensee != '%'
                 THEN
                    stmt_str :=
                          stmt_str
                       || ' AND flees.lee_short_name like UPPER ('''
                       || i_licensee
                       || ''')';
                 END IF;
        
                 IF i_reg_code != '%'
                 THEN
                    stmt_str :=
                          stmt_str
                       || ' AND fr.reg_code like UPPER ('''
                       || i_reg_code
                       || ''')';
                 END IF;
              END IF;
        
              IF i_order_by = 'A'
              THEN
                 order_stmt :=
                    '  ORDER BY lic_type,
                                pay_cur_code,
                                channel_company,
                                supplier,
                                con_short_name,
                                gen_title,
                                pay_lic_number';
              ELSIF i_order_by = 'B'
              THEN
                 order_stmt :=
                    '  ORDER BY lic_type,
                                channel_company,
                                nvl(PAY_DATE,PAY_STATUS_DATE),
                                supplier,
                                con_short_name,
                                pay_cur_code,
                                gen_title,
                                pay_lic_number';
              ELSIF i_order_by = 'C'
              THEN
                 order_stmt :=
                    '   ORDER BY  lic_type,
                                  channel_company,
                                  gen_title,
                                  nvl(PAY_DATE,PAY_STATUS_DATE),
                                  supplier,
                                  con_short_name,
                                  pay_cur_code,
                                  pay_lic_number';
              ELSIF i_order_by = 'D'
              THEN
                 order_stmt :=
                    '   ORDER BY  lic_type,
                                  channel_company,
                                  NVL (pay_reference, ''0''),
                                  NVL (PAY_MNET_REFERENCE, ''0''), --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                                  gen_title,
                                  pay_status_date,
                                  supplier,
                                  con_short_name,
                                  pay_cur_code,
                                  pay_lic_number';
              ELSIF i_order_by = 'E'
              THEN
                 order_stmt :=
                      'ORDER BY lic_type,
                                pay_cur_code,
                                channel_company,
                                supplier,
                                con_short_name,
                                gen_title,
                                pay_lic_number
                                ';
      END IF;

      stmt_str := stmt_str || order_stmt;
      DBMS_OUTPUT.put_line (stmt_str);

      OPEN o_output_cursor FOR stmt_str;
   END prc_fin_mnet_pay_made_bet2dat;

/*
--SELECT TO_CHAR(TO_DATE(i_date_from,'DD/MM/YYYY'),'DD-MON-YYYY') into temp_period_from FROM DUAL ;
IF (UPPER (i_order_by) = 'A' AND UPPER (i_adjustment) = 'Y')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier,
DECODE
((SIGN (  NVL (lic_acct_date,
TO_DATE ('31122096', 'DD-MM-YYYY')
)
- TO_DATE (temp_period_to, 'DD-MON-YYYY')
)
),
-1, '(Liability)',
0, '(Liability)',
1, '(Pre-Payments)'
) lic_acct_date,
con_short_name, pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
ROUND (lic_price, 2) lic_price, lee_short_name,
ROUND (pay_amount, 2) pay_amount, pay_status_date,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, pay_comment,
DECODE (pay_code, 'A', 'Adjustment', 'Payment') TYPE
FROM fid_license,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type,
fid_licensee
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND lee_number = lic_lee_number
AND lee_short_name LIKE NVL (i_licensee, '%')
AND pay_code = 'A'
ORDER BY NVL (lic_type, 'N/A'),
pay_cur_code,
company.com_short_name,
supplier.com_short_name,
con_short_name,
DECODE (pay_code, 'A', 'Adjustment', 'Payment') DESC,
NVL (gen_title, '0');
END IF;
IF (UPPER (i_order_by) = 'A' AND UPPER (i_adjustment) = 'N')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier,
DECODE
((SIGN (  NVL (lic_acct_date,
TO_DATE ('31122096', 'DD-MM-YYYY')
)
- TO_DATE (temp_period_to, 'DD-MON-YYYY')
)
),
-1, '(Liability)',
0, '(Liability)',
1, '(Pre-Payments)'
) lic_acct_date,
con_short_name, pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
ROUND (lic_price, 2) lic_price, lee_short_name,
ROUND (pay_amount, 2) pay_amount, pay_status_date,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, pay_comment,
DECODE (pay_code, 'A', 'Adjustment', 'Payment') TYPE
FROM fid_license,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type,
fid_licensee
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND lee_number = lic_lee_number
AND lee_short_name LIKE NVL (i_licensee, '%')
AND pay_code <> 'A'
ORDER BY NVL (lic_type, 'N/A'),
pay_cur_code,
company.com_short_name,
supplier.com_short_name,
con_short_name,
DECODE (pay_code, 'A', 'Adjustment', 'Payment') DESC,
NVL (gen_title, '0');
END IF;
IF (UPPER (i_order_by) = 'B' AND UPPER (i_adjustment) = 'Y')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier, con_short_name,
pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
-- lic_price,
--   lee_short_name,
ROUND (pay_amount, 2) pay_amount, pay_status_date,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, lee_short_name,
ROUND (lic_price, 2) lic_price, pay_comment
FROM fid_license,
fid_licensee,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pat_group = 'F'
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND fid_license.lic_lee_number = fid_licensee.lee_number
AND pay_code = 'A'
ORDER BY NVL (lic_type, 'N/A'),
company.com_short_name,
pay_status_date,
supplier.com_short_name,
con_short_name,
pay_cur_code,
NVL (gen_title, '0');
END IF;
IF (UPPER (i_order_by) = 'B' AND UPPER (i_adjustment) = 'N')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier, con_short_name,
pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
-- lic_price,
--  lee_short_name,
ROUND (pay_amount, 2) pay_amount, pay_status_date,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, lee_short_name,
ROUND (lic_price, 2) lic_price, pay_comment
FROM fid_license,
fid_licensee,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pat_group = 'F'
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND fid_license.lic_lee_number = fid_licensee.lee_number
AND pay_code <> 'A'
ORDER BY NVL (lic_type, 'N/A'),
company.com_short_name,
pay_status_date,
supplier.com_short_name,
con_short_name,
pay_cur_code,
NVL (gen_title, '0');
END IF;
IF (UPPER (i_order_by) = 'C' AND UPPER (i_adjustment) = 'Y')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier, con_short_name,
pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
--   lic_price,
--    lee_short_name,
ROUND (pay_amount, 2) pay_amount,
ROUND (lic_price, 2) lic_price, lee_short_name,
pay_status_date,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, pay_comment
FROM fid_license,
fid_licensee,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pat_group = 'F'
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND fid_licensee.lee_number = fid_license.lic_lee_number
AND pay_code = 'A'
ORDER BY NVL (lic_type, 'N/A'),
company.com_short_name,
NVL (gen_title, '0'),
pay_status_date,
supplier.com_short_name,
con_short_name,
pay_cur_code;
END IF;
IF (UPPER (i_order_by) = 'C' AND UPPER (i_adjustment) = 'N')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier, con_short_name,
pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
-- lic_price,
--  lee_short_name,
ROUND (pay_amount, 2) pay_amount,
ROUND (lic_price, 2) lic_price, lee_short_name,
pay_status_date,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, pay_comment
FROM fid_license,
fid_licensee,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pat_group = 'F'
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND fid_licensee.lee_number = fid_license.lic_lee_number
AND pay_code <> 'A'
ORDER BY NVL (lic_type, 'N/A'),
company.com_short_name,
NVL (gen_title, '0'),
pay_status_date,
supplier.com_short_name,
con_short_name,
pay_cur_code;
END IF;
IF (UPPER (i_order_by) = 'D' AND UPPER (i_adjustment) = 'Y')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier, con_short_name,
pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
-- lic_price,
--  lee_short_name,
ROUND (pay_amount, 2) pay_amount, pay_status_date,
ROUND (lic_price, 2) lic_price, lee_short_name,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, pay_comment
FROM fid_license,
fid_licensee,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pat_group = 'F'
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND fid_licensee.lee_number = fid_license.lic_lee_number
AND pay_code = 'A'
ORDER BY NVL (lic_type, 'N/A'),
company.com_short_name,
NVL (pay_reference, '0'),
NVL (gen_title, '0'),
pay_status_date,
supplier.com_short_name,
con_short_name,
pay_cur_code;
END IF;
IF (UPPER (i_order_by) = 'D' AND UPPER (i_adjustment) = 'N')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier, con_short_name,
pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
ROUND (lic_price, 2) lic_price, lee_short_name,
ROUND (pay_amount, 2) pay_amount, pay_status_date,
--  lic_price,
--  lee_short_name,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, pay_comment
FROM fid_license,
fid_licensee,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pat_group = 'F'
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND fid_licensee.lee_number = fid_license.lic_lee_number
AND pay_code <> 'A'
ORDER BY NVL (lic_type, 'N/A'),
company.com_short_name,
NVL (pay_reference, '0'),
NVL (gen_title, '0'),
pay_status_date,
supplier.com_short_name,
con_short_name,
pay_cur_code;
END IF;
IF (UPPER (i_order_by) = 'E' AND UPPER (i_adjustment) = 'Y')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier,
DECODE
((SIGN (  NVL (lic_acct_date,
TO_DATE ('31122096', 'DD-MM-YYYY')
)
- TO_DATE (temp_period_to, 'DD-MON-YYYY')
)
),
-1, '(Liability)',
0, '(Liability)',
1, '(Pre-Payments)'
) lic_acct_date,
con_short_name, pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
ROUND (lic_price, 2) lic_price, lee_short_name,
ROUND (pay_amount, 2) pay_amount,
--  fid_license.lic_price,
pay_status_date,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, pay_comment,
-- lee_short_name,
DECODE (pay_code, 'A', 'Adjustment', 'Payment') TYPE
FROM fid_license,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type,
fid_licensee
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pat_group = 'O'
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND lee_number = lic_lee_number
AND lee_short_name LIKE NVL (i_licensee, '%')
AND pay_code = 'A'
ORDER BY NVL (lic_type, 'N/A'),
pay_cur_code,
company.com_short_name,
supplier.com_short_name,
con_short_name,
DECODE (pay_code, 'A', 'Adjustment', 'Payment') DESC,
NVL (gen_title, '0');
END IF;
IF (UPPER (i_order_by) = 'E' AND UPPER (i_adjustment) = 'N')
THEN
OPEN o_output_cursor FOR
SELECT   NVL (lic_type, 'N/A') lic_type,
DECODE (pat_group,
'F', 'Fee',
'O', 'Other',
'Unknown'
) pat_group,
pay_cur_code, company.com_name channel_company,
supplier.com_short_name supplier,
DECODE
((SIGN (  NVL (lic_acct_date,
TO_DATE ('31122096', 'DD-MM-YYYY')
)
- TO_DATE (temp_period_to, 'DD-MON-YYYY')
)
),
-1, '(Liability)',
0, '(Liability)',
1, '(Pre-Payments)'
) lic_acct_date,
con_short_name, pay_lic_number,
NVL (gen_title, 'Contract Payment') gen_title, pat_desc,
ROUND (lic_price, 2) lic_price, lee_short_name,
ROUND (pay_amount, 2) pay_amount,
--  fid_license.lic_price,
pay_status_date,
DECODE (pay_status,
'I', 'In Transit',
'P', 'Paid',
pay_status
) pay_status,
pay_reference, pay_comment,
--   lee_short_name,
DECODE (pay_code, 'A', 'Adjustment', 'Payment') TYPE
FROM fid_license,
fid_general,
fid_payment,
fid_contract,
fid_company company,
fid_company supplier,
fid_payment_type,
fid_licensee
WHERE NVL (pay_lic_number, 0) = lic_number(+)
AND NVL (lic_gen_refno, 0) = gen_refno(+)
AND TRUNC (pay_status_date) BETWEEN temp_period_from
AND temp_period_to
AND pay_status IN ('I', 'P')
AND pat_group = 'O'
AND pay_source_com_number = company.com_number
AND con_com_number = supplier.com_number
AND company.com_short_name LIKE NVL (i_channel_company, '%')
AND supplier.com_short_name LIKE NVL (i_supplier, '%')
AND con_number = NVL (lic_con_number, pay_con_number)
AND pat_code = pay_code
AND lee_number = lic_lee_number
AND lee_short_name LIKE NVL (i_licensee, '%')
AND pay_code <> 'A'
ORDER BY NVL (lic_type, 'N/A'),
pay_cur_code,
company.com_short_name,
supplier.com_short_name,
con_short_name,
DECODE (pay_code, 'A', 'Adjustment', 'Payment') DESC,
NVL (gen_title, '0');
END IF;
*/
   PROCEDURE prc_fin_mnet_pay_made_summary (
      i_channel_company   IN       fid_company.com_short_name%TYPE,
	  i_con_short_name    IN     fid_contract.con_short_name%type,
      i_supplier          IN       fid_company.com_short_name%TYPE,
      i_licensee          IN       fid_licensee.lee_short_name%TYPE,
      i_date_from         IN       DATE,
      i_date_to           IN       DATE,
      i_order_by          IN       VARCHAR2,
      -- Pure finance  mrunmayi kusurkar
      i_reg_code          IN       fid_region.reg_code%TYPE,
      i_report_type       IN       VARCHAR2,
      -- end
      o_output_cursor     OUT      pkg_fin_mnet_pay_made_bet2dat.o_fin_pay_bet2date_cursor
   )
   AS
      stmt_str         VARCHAR2 (30000);
      order_stmt       VARCHAR2 (9000);
      start_mth_year   NUMBER;
      end_mth_year     NUMBER;
   BEGIN
      SELECT TO_NUMBER (TO_CHAR (i_date_from, 'YYYYMM')),
             TO_NUMBER (TO_CHAR (i_date_to, 'YYYYMM'))
        INTO start_mth_year,
             end_mth_year
        FROM DUAL;

      stmt_str :=
            'select pay_cur_code
            ,pat_group
            ,inv
            ,lic_type
            ,sum(total_amt) total_amt
            ,TYPE
            ,sum(forex) forex
            ---- Dev8: RDT :Start:[Add Loacl Amount]_[Deepak]_[27-Aug-2013]
            ,sum(Local_Amount)total_paid_Local_Amount
            from(
            SELECT pay_cur_code
            ,pat_group
            ,inv
            ,lic_type
            ,(CASE WHEN ref_mth = 0
            THEN
            sum(pay_amount)
            ELSE
            NULL
            END
            ) total_amt
            ,TYPE
            
            ,(CASE WHEN ref_mth = 0
            THEN
            SUM(Local_Amount)
            ELSE
            NULL
            END
            ) Local_Amount
            
            ,sum(RZF_REALIZED_FOREX) forex
            FROM
            (
            
            
            SELECT   fp.pay_cur_code,fp.pay_lic_number,fp.pay_number,
            DECODE (fpt.pat_group,
            ''F'', ''Fee'',
            ''O'', ''Other'',
            ''Unknown''
            ) pat_group,
            DECODE ((SIGN (  NVL (fl.LIC_ACCT_DATE,
            TO_DATE (''31122096'', ''DD-MM-RRRR'')
            )
            - TO_DATE ('''
                     || i_date_to
                     || ''', ''DD-MON-RRRR'')
            )
            ),
            -1, ''(Liability)'',
            0, ''(Liability)'',
            1, ''(Pre-Payments)''
            ) inv,
            fl.lic_type, fp.pay_amount,
            decode (fp.pay_code, ''A'', ''Adjustment'',''T'',''Transfer'',''Payment'') type
            --, null forex
            ,xfrf.RZF_REALIZED_FOREX
            , (case when to_number(to_char(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM'')) <> to_number(xfrf.rzf_year||lpad(xfrf.rzf_month,2,0))
            then
            -1
            else
            0
            END
            ) ref_mth
            ---- Dev8: RDT :Start:[Add Loacl Amount]_[Deepak]_[27-Aug-2013]
            ,fp.pay_amount * NVL(fp.Pay_rate,0)Local_Amount
            FROM fid_contract fcon,
            fid_license fl,
            fid_licensee flee,
            fid_payment_type fpt,
            fid_payment fp,
            fid_company afc, -- cha comp
            fid_company bfc,  -- supp
            x_fin_realized_forex xfrf,
            fid_region fr
            WHERE afc.com_short_name LIKE decode('''
                     || i_channel_company
                     || ''',''%'',afc.com_short_name,'''
                     || i_channel_company
                     || ''')
            AND bfc.com_short_name LIKE decode('''
                     || i_supplier
                     || ''',''%'',bfc.com_short_name,'''
                     || i_supplier
                     || ''')
            AND fp.pay_source_com_number = afc.com_number
            AND fp.pay_status IN (''I'', ''P'')
            AND fl.lic_status != ''T'' --added so that t licenses should not be displayed
            and fcon.con_short_name LIKE '''||i_con_short_name||'''
            AND (trunc (nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE))  BETWEEN '''
                     || i_date_from
                     || ''' AND '''
                     || i_date_to
                     || '''
            AND to_number(xfrf.rzf_year || lpad(xfrf.rzf_month,2,0))= to_number(to_char(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM'')))
            AND fpt.pat_code = fp.pay_code
            AND fl.lic_number = fp.pay_lic_number
            AND fcon.con_number = fl.lic_con_number
            AND fcon.con_com_number = bfc.com_number
            AND flee.LEE_SPLIT_REGION  = fr.REG_ID(+)
            AND fr.reg_code LIKE UPPER(decode('''
                     || i_reg_code
                     || ''',''%'',fr.reg_code,'''
                     || i_reg_code
                     || '''))
            AND flee.lee_number = fl.lic_lee_number
            and flee.lee_short_name like decode('''
                     || i_licensee
                     || ''',''%'',flee.lee_short_name,'''
                     || i_licensee
                     || ''')
            and xfrf.rzf_pay_number(+) = fp.pay_number
            and UPPER(xfrf.RZF_ACCOUNT_HEAD) <> ''ED''
            
            UNION
            
            SELECT   fp.pay_cur_code,fp.pay_lic_number,fp.pay_number,
            DECODE (fpt.pat_group,
            ''F'', ''Fee'',
            ''O'', ''Other'',
            ''Unknown''
            ) pat_group,
            DECODE ((SIGN (  NVL (fl.LIC_ACCT_DATE,
            TO_DATE (''31122096'', ''DD-MM-RRRR'')
            )
            - TO_DATE ('''
                     || i_date_to
                     || ''', ''DD-MON-RRRR'')
            )
            ),
            -1, ''(Liability)'',
            0, ''(Liability)'',
            1, ''(Pre-Payments)''
            ) INV,
            fl.lic_type,fp.pay_amount,
            decode (fp.pay_code, ''A'', ''Adjustment'',''T'',''Transfer'',''Payment'') type
            --, null forex
            ,null RZF_REALIZED_FOREX
            , 0 ref_mth
            ---- Dev8: RDT :Start:[Add Loacl Amount]_[Deepak]_[27-Aug-2013]
            ,fp.pay_amount * NVL(fp.Pay_rate,0)Local_Amount
            FROM fid_contract fcon,
            fid_license fl,
            fid_licensee flee,
            fid_payment_type fpt,
            fid_payment fp,
            fid_company afc, -- cha comp
            fid_company bfc,
            fid_region fr
            
            -- supp
            WHERE Afc.com_short_name LIKE decode('''
                     || i_channel_company
                     || ''',''%'',Afc.com_short_name,'''
                     || i_channel_company
                     || ''')
            AND bfc.com_short_name LIKE decode('''
                     || i_supplier
                     || ''',''%'',bfc.com_short_name,'''
                     || i_supplier
                     || ''')
            AND fp.pay_source_com_number = afc.com_number
            AND fp.pay_status IN (''I'', ''P'')
            AND fl.lic_status != ''T'' --added so that t licenses should not be displayed
            and fcon.con_short_name LIKE '''||i_con_short_name||'''
            and TRUNC(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE)) BETWEEN '''
                     || i_date_from
                     || ''' AND '''
                     || i_date_to
                     || '''
            --to inclucde ZAR and Prepayments
            and fp.pay_number not in (select
            distinct fp.pay_number
            from fid_payment fp,x_fin_realized_forex xfrf
            where xfrf.rzf_pay_number(+) = fp.pay_number
            and TRUNC(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE)) BETWEEN '''
                     || i_date_from
                     || ''' AND '''
                     || i_date_to
                     || '''
            and UPPER(xfrf.RZF_ACCOUNT_HEAD) <> ''ED''
            and fp.pay_status in (''I'',''P'')
            AND ( (xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0)) =TO_NUMBER(TO_CHAR(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM''))
            )
            )
            --AND  to_number(to_char(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM''))<>to_number(to_char(xfrf.rzf_year || lpad(xfrf.rzf_month,2,0)))
            AND fpt.pat_code = fp.pay_code
            AND fl.lic_number = fp.pay_lic_number
            AND fcon.con_number = fl.lic_con_number
            AND fcon.con_com_number = bfc.com_number
            AND flee.LEE_SPLIT_REGION  = fr.REG_ID(+)
            AND fr.reg_code LIKE UPPER(decode('''
                     || i_reg_code
                     || ''',''%'',fr.reg_code,'''
                     || i_reg_code
                     || '''))
            AND flee.lee_number = fl.lic_lee_number
            
            AND flee.lee_short_name LIKE decode('''
                     || i_licensee
                     || ''',''%'',flee.lee_short_name,'''
                     || i_licensee
                     || ''')
            
            
            union
            
            SELECT   fp.pay_cur_code,fp.pay_lic_number,fp.pay_number,
            DECODE (fpt.pat_group,
            ''F'', ''Fee'',
            ''O'', ''Other'',
            ''Unknown''
            ) pat_group,
            DECODE ((SIGN (  NVL (fl.LIC_ACCT_DATE,
            TO_DATE (''31122096'', ''DD-MM-RRRR'')
            )
            - TO_DATE ('''
                     || i_date_to
                     || ''', ''DD-MON-RRRR'')
            )
            ),
            -1, ''(Liability)'',
            0, ''(Liability)'',
            1, ''(Pre-Payments)''
            ) INV,
            lic_type,null pay_amount,
            decode (fp.pay_code, ''A'', ''Adjustment'',''T'',''Transfer'',''Payment'') type
            --, null forex
            ,xfrf.RZF_REALIZED_FOREX
            , -1 ref_mth
            ,fp.pay_amount * NVL(fp.Pay_rate,0)Local_Amount
            FROM fid_contract fcon,
            fid_license fl,
            fid_licensee flee,
            fid_region fr,
            fid_payment_type fpt,
            fid_payment fp,
            fid_company afc, -- cha comp
            fid_company bfc
            ,x_fin_realized_forex xfrf
            -- supp
            WHERE Afc.com_short_name LIKE decode('''
                     || i_channel_company
                     || ''',''%'',Afc.com_short_name,'''
                     || i_channel_company
                     || ''')
            AND bfc.com_short_name LIKE decode('''
                     || i_supplier
                     || ''',''%'',bfc.com_short_name,'''
                     || i_supplier
                     || ''')
            AND fp.pay_source_com_number = afc.com_number
            AND fp.pay_status IN (''I'', ''P'')
            AND fl.lic_status != ''T'' --added so that t licenses should not be displayed
                     and fcon.con_short_name LIKE '''||i_con_short_name||'''
            AND(
            (
            ( xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0) ) <> TO_CHAR(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM'')
            )
            and
            ( xfrf.RZF_YEAR || LPAD (xfrf.RZF_MONTH, 2, 0)) BETWEEN '''
                     || start_mth_year
                     || ''' AND '''
                     || end_mth_year
                     || '''
            )
            --AND  to_number(to_char(nvl(fp.PAY_DATE,fp.PAY_STATUS_DATE),''YYYYMM''))<>to_number(to_char(xfrf.rzf_year || lpad(xfrf.rzf_month,2,0)))
            AND fpt.pat_code = fp.pay_code
            AND fl.lic_number = fp.pay_lic_number
            AND fcon.con_number = fl.lic_con_number
            AND fcon.con_com_number = bfc.com_number
            AND flee.LEE_SPLIT_REGION  = fr.REG_ID(+)
            AND fr.reg_code LIKE UPPER(decode('''
                     || i_reg_code
                     || ''',''%'',fr.reg_code,'''
                     || i_reg_code
                     || '''))
            AND flee.lee_number = fl.lic_lee_number
            and UPPER(xfrf.RZF_ACCOUNT_HEAD) <> ''ED''
            AND flee.lee_short_name LIKE decode('''
                     || i_licensee
                     || ''',''%'',flee.lee_short_name,'''
                     || i_licensee
                     || ''')
            and xfrf.rzf_pay_number = fp.pay_number
            )
            GROUP BY
            pay_cur_code,
            pat_group,
            inv,
            lic_type,
            TYPE,
            ref_mth
            )
            GROUP BY
            pay_cur_code,
            pat_group,
            inv,
            lic_type,
            TYPE
            
            ';
      DBMS_OUTPUT.put_line (stmt_str);

      OPEN o_output_cursor FOR stmt_str;
   /*SELECT TO_CHAR (TO_DATE (i_date_to, 'MM/DD/YYYY'), 'DD-MON-YYYY')
   INTO temp_period_to
   FROM DUAL;
   SELECT TO_CHAR (TO_DATE (i_date_from, 'MM/DD/YYYY'), 'DD-MON-YYYY')
   INTO temp_period_from
   FROM DUAL;
   IF (UPPER (i_order_by) = 'A')
   THEN                                      -- and upper(i_adjustment)='Y'
   OPEN o_output_cursor FOR
   SELECT   pay_cur_code,
   DECODE (pat_group,
   'F', 'Fee',
   'O', 'Other',
   'Unknown'
   ) pat_group,
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (i_date_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ) inv,
   lic_type, SUM (pay_amount) total_amt,
   DECODE (pay_code, 'A', 'Adjustment', 'Payment') TYPE
   FROM fid_contract,
   fid_license,
   fid_licensee,
   fid_payment_type,
   fid_payment,
   fid_company a,
   fid_company b
   WHERE a.com_short_name LIKE NVL (i_channel_company, '%')
   AND b.com_short_name LIKE NVL (i_supplier, '%')
   AND pay_source_com_number = a.com_number
   AND pay_status IN ('I', 'P')
   AND TRUNC (pay_status_date) BETWEEN i_date_from
   AND i_date_to
   AND pat_code = pay_code
   AND lic_number = pay_lic_number
   AND con_number = lic_con_number
   AND con_com_number = b.com_number
   AND lee_number = lic_lee_number
   AND lee_short_name LIKE NVL (i_licensee, '%')
   GROUP BY DECODE (pay_code, 'A', 'Adjustment', 'Payment'),
   pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (i_date_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type
   ORDER BY pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (i_date_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type;
   END IF;
   IF (UPPER (i_order_by) = 'B')
   THEN
   OPEN o_output_cursor FOR
   SELECT   pay_cur_code,
   DECODE (pat_group,
   'F', 'Fee',
   'O', 'Other',
   'Unknown'
   ) pat_group,
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ) inv,
   lic_type, SUM (pay_amount) total_amt
   FROM fid_contract,
   fid_license,
   fid_licensee,
   fid_payment_type,
   fid_payment,
   fid_company a,
   fid_company b
   WHERE a.com_short_name LIKE NVL (i_channel_company, '%')
   AND b.com_short_name LIKE NVL (i_supplier, '%')
   AND pay_source_com_number = a.com_number
   AND pay_status IN ('I', 'P')
   AND TRUNC (pay_status_date) BETWEEN temp_period_from
   AND temp_period_to
   AND pat_code = pay_code
   AND lic_number = pay_lic_number
   AND con_number = lic_con_number
   AND con_com_number = b.com_number
   AND lee_number = lic_lee_number
   AND lee_short_name LIKE NVL (i_licensee, '%')
   GROUP BY pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type
   ORDER BY pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type;
   END IF;
   IF (UPPER (i_order_by) = 'C')
   THEN
   OPEN o_output_cursor FOR
   SELECT   pay_cur_code,
   DECODE (pat_group,
   'F', 'Fee',
   'O', 'Other',
   'Unknown'
   ) pat_group,
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ) inv,
   lic_type, SUM (pay_amount) total_amt
   FROM fid_contract,
   fid_license,
   fid_licensee,
   fid_payment_type,
   fid_payment,
   fid_company a,
   fid_company b
   WHERE a.com_short_name LIKE NVL (i_channel_company, '%')
   AND b.com_short_name LIKE NVL (i_supplier, '%')
   AND pay_source_com_number = a.com_number
   AND pay_status IN ('I', 'P')
   AND TRUNC (pay_status_date) BETWEEN temp_period_from
   AND temp_period_to
   AND pat_code = pay_code
   AND lic_number = pay_lic_number
   AND con_number = lic_con_number
   AND con_com_number = b.com_number
   AND lee_number = lic_lee_number
   AND lee_short_name LIKE NVL (i_licensee, '%')
   GROUP BY pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type
   ORDER BY pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type;
   END IF;
   IF (UPPER (i_order_by) = 'D')
   THEN
   OPEN o_output_cursor FOR
   SELECT   pay_cur_code,
   DECODE (pat_group,
   'F', 'Fee',
   'O', 'Other',
   'Unknown'
   ) pat_group,
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ) inv,
   lic_type, SUM (pay_amount) total_amt
   FROM fid_contract,
   fid_license,
   fid_licensee,
   fid_payment_type,
   fid_payment,
   fid_company a,
   fid_company b
   WHERE a.com_short_name LIKE NVL (i_channel_company, '%')
   AND b.com_short_name LIKE NVL (i_supplier, '%')
   AND pay_source_com_number = a.com_number
   AND pay_status IN ('I', 'P')
   AND TRUNC (pay_status_date) BETWEEN temp_period_from
   AND temp_period_to
   AND pat_code = pay_code
   AND lic_number = pay_lic_number
   AND con_number = lic_con_number
   AND con_com_number = b.com_number
   AND lee_number = lic_lee_number
   AND lee_short_name LIKE NVL (i_licensee, '%')
   GROUP BY pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type
   ORDER BY pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type;
   END IF;
   IF (UPPER (i_order_by) = 'E')
   THEN
   OPEN o_output_cursor FOR
   SELECT   pay_cur_code,
   DECODE (pat_group,
   'F', 'Fee',
   'O', 'Other',
   'Unknown'
   ) pat_group,
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ) inv,
   lic_type, SUM (pay_amount) total_amt,
   DECODE (pay_code, 'A', 'Adjustment', 'Payment') TYPE
   FROM fid_contract,
   fid_license,
   fid_licensee,
   fid_payment_type,
   fid_payment,
   fid_company a,
   fid_company b
   WHERE a.com_short_name LIKE NVL (i_channel_company, '%')
   AND b.com_short_name LIKE NVL (i_supplier, '%')
   AND pay_source_com_number = a.com_number
   AND pay_status IN ('I', 'P')
   AND TRUNC (pay_status_date) BETWEEN temp_period_from
   AND temp_period_to
   AND pat_code = pay_code
   AND lic_number = pay_lic_number
   AND con_number = lic_con_number
   AND con_com_number = b.com_number
   AND lee_number = lic_lee_number
   AND lee_short_name LIKE NVL (i_licensee, '%')
   GROUP BY DECODE (pay_code, 'A', 'Adjustment', 'Payment'),
   pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type
   ORDER BY pay_cur_code,
   DECODE (pat_group, 'F', 'Fee', 'O', 'Other', 'Unknown'),
   DECODE ((SIGN (  NVL (lic_acct_date,
   TO_DATE ('31122096', 'DD-MM-YYYY')
   )
   - TO_DATE (temp_period_to, 'DD-MON-YYYY')
   )
   ),
   -1, '(Liability)',
   0, '(Liability)',
   1, '(Pre-Payments)'
   ),
   lic_type;
   END IF;*/
   END PRC_FIN_MNET_PAY_MADE_SUMMARY;
END pkg_fin_mnet_pay_made_bet2dat;
/