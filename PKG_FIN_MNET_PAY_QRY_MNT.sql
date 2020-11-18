CREATE OR REPLACE PACKAGE          "PKG_FIN_MNET_PAY_QRY_MNT"
AS
   /**************************************************************************
   REM Module     : Finance :
   REM Client     : MNET
   REM File Name     : PKG_FIN_MNET_PAY_QRY_MNT.sql
   REM Purpose     : This package is used for Payment Query and Maintainance.
   REM Written By     : Hari Mandal
   REM Date     : 12-MAR-2013
   REM Type     : Database Package
   REM Change History :
   REM **************************************************************************/
   TYPE c_cursor_payqry IS REF CURSOR;

   --PROCEDURE TO GENERATE CUSTOMER NAME LOV
   PROCEDURE prc_contshortnamelov (
      o_con_short_name OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE prc_searchcontdtls (
      i_program_title         IN     fid_license_vw.gen_title%TYPE,
      i_lic_no                IN     fid_license_vw.lic_number%TYPE,
      i_con_short_name        IN     VARCHAR2,
      i_deal_memo             IN     fid_license_vw.lic_mem_number%TYPE,
      i_start_date            IN     fid_license_vw.lic_start%TYPE,
      i_end_date              IN     fid_license_vw.lic_end%TYPE,
      i_type                  IN     fid_license_vw.lic_type%TYPE,
      i_license               IN     fid_license_vw.lee_short_name%TYPE,
      i_status                IN     fid_license_vw.lic_status%TYPE,
      i_sup_short_name        IN     VARCHAR2,
      i_pay_date_from         IN     DATE,
      i_pay_date_to           IN     DATE,
      i_pay_date_not_avail    IN     VARCHAR2,
      i_due_date_from         IN     DATE,
      i_due_date_to           IN     DATE,
      i_pay_status            IN     VARCHAR2,
      i_spot_rate_from        IN     NUMBER,
      i_spot_rate_to          IN     NUMBER,
      i_spot_rate_not_avail   IN     VARCHAR2,
      i_post_date_from        IN     DATE,
      i_post_date_to          IN     DATE,
      o_con_dtls                 OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   --PROCEDURE TO SELECT CONTRACT DETAILS
   PROCEDURE prc_contractdtls (
      i_con_short_name       IN     fid_contract.con_short_name%TYPE--,    o_cpd_dtls         out    PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry
      ,
      i_lic_number           IN     fid_license.lic_number%TYPE,
      i_gen_title            IN     fid_general.gen_title%TYPE,
      i_amount               IN     fid_payment.pay_amount%TYPE,
      i_code                 IN     fid_payment.pay_code%TYPE,
      i_status               IN     fid_payment.pay_status%TYPE,
      i_duedate              IN     fid_payment.pay_due%TYPE,
      i_supplier             IN     fid_payment.pay_reference%TYPE,
      o_fid_payment             OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_po_fee_info             OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_oth_dtls                OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_title           OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_season          OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_season_pay      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_title_pay       OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE prc_title_lic_dtls (
      i_con_short_name   IN     fid_contract.con_short_name%TYPE,
      o_title_lic_no        OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   --SELECT LICENCE NO or TITLE
   PROCEDURE prc_pay_qry_val_lic_no_title (
      i_o_gen_title     IN OUT fid_general.gen_title%TYPE,
      i_o_lic_number    IN OUT fid_license.lic_number%TYPE,
      o_error_message      OUT VARCHAR2);

   --PROCEDURE TO INSERT PAYMENT
   PROCEDURE prc_add_payment (
      i_licensee               IN     fid_licensee.lee_short_name%TYPE,
      i_pay_code               IN     fid_payment.pay_code%TYPE,
      i_pay_cur_code           IN     fid_payment.pay_cur_code%TYPE,
      i_pay_amount             IN     fid_payment.pay_amount%TYPE,
      i_pay_status             IN     fid_payment.pay_status%TYPE,
      i_pay_status_date        IN     fid_payment.pay_status_date%TYPE,
      i_pay_due                IN     fid_payment.pay_due%TYPE,
      i_pay_date               IN     fid_payment.pay_date%TYPE,
      i_pay_rate               IN     fid_payment.pay_rate%TYPE,
      i_pay_supplier_invoice   IN     fid_payment.pay_reference%TYPE,
	  i_pay_mnet_invoice   IN     fid_payment.PAY_MNET_REFERENCE%TYPE, -- #region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
      i_pay_comment            IN     fid_payment.pay_comment%TYPE,
      i_pay_con_number         IN     fid_payment.pay_con_number%TYPE,
      i_pay_lic_number         IN     fid_payment.pay_lic_number%TYPE,
      i_userid                 IN     VARCHAR2,
      i_pay_duestr             IN     VARCHAR2,
      i_is_transfer_pay        IN     VARCHAR2,
      o_pay_number                OUT NUMBER,
      o_gen_refno                 OUT NUMBER,
      o_gen_title                 OUT VARCHAR2,
      o_gen_ser_number            OUT NUMBER,
      o_success                   OUT NUMBER);

   --PROCEDURE TO SELECT PAYMENT CODE DESCRIPTION
   PROCEDURE prc_get_payment_code_desc (
      i_pat_code            fid_payment_type.pat_code%TYPE,
      i_pay_code_desc   OUT fid_payment_type.pat_desc%TYPE,
      i_pat_group       OUT fid_payment_type.pat_group%TYPE);

   --PROCEDURE TO UPDATE THE PAYMENT DEATILS
   PROCEDURE prc_update_payment (
      i_pay_con_number     IN     fid_payment.pay_con_number%TYPE,
      i_pay_number         IN     fid_payment.pay_number%TYPE,
      ----Dev2: Pure Finance: Start:[CR Id/Mantis Id]_Hari_2013/01/30]
      i_licensee           IN     fid_licensee.lee_short_name%TYPE,
      ----Dev2: Pure Finance: End------------------------------------
      i_pay_code           IN     fid_payment.pay_code%TYPE,
      i_pay_cur_code       IN     fid_payment.pay_cur_code%TYPE,
      i_pay_amount         IN     fid_payment.pay_amount%TYPE,
      i_pay_status_date    IN     fid_payment.pay_status_date%TYPE,
      i_pay_due            IN     fid_payment.pay_due%TYPE,
      i_pay_reference      IN     fid_payment.pay_reference%TYPE,
	  i_pay_mnet_invoice   IN     fid_payment.PAY_MNET_REFERENCE%TYPE, -- #region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
      i_pay_comment        IN     fid_payment.pay_comment%TYPE,
      i_pay_lic_number     IN     fid_payment.pay_lic_number%TYPE,
      i_gen_title          IN     fid_general.gen_title%TYPE,
      i_pay_status         IN     fid_payment.pay_status%TYPE,
      i_pay_date           IN     fid_payment.pay_date%TYPE,
      i_pay_rate           IN     fid_payment.pay_rate%TYPE,
      i_pay_update_count   IN     fid_payment.pay_update_count%TYPE,
      i_entry_oper         IN     fid_payment.pay_entry_oper%TYPE,
      i_is_transfer_pay    IN     VARCHAR2,
	 i_is_rem_lib_same     IN     VARCHAR2,
      o_pay_dtls              OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE prc_delete_payment (
      i_pay_lic_number       fid_payment.pay_lic_number%TYPE,
      i_pay_number           fid_payment.pay_number%TYPE,
      i_entry_oper           fid_payment.pay_entry_oper%TYPE,
      o_success          OUT NUMBER);

   PROCEDURE prc_split_pay_default (
      i_pay_number       fid_payment.pay_number%TYPE,
      o_pay_dtls     OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE prc_split_payment (
      i_pay_number       fid_payment.pay_number%TYPE,
      i_amount           fid_payment.pay_amount%TYPE,
      o_success      OUT NUMBER);

   PROCEDURE prc_lic_prgm_details (
      i_gen_title   IN     VARCHAR2,
      o_con_dtls       OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE x_prc_get_mcgregor_rate (
      i_pay_number   IN     fid_payment.pay_number%TYPE,
      i_pay_date     IN     fid_payment.pay_date%TYPE,
      o_spot_rate       OUT NUMBER);

   FUNCTION local_currency (i_lic_number fid_license.lic_number%TYPE)
      RETURN VARCHAR2;

   PROCEDURE x_prc_licenseelov (
      i_lic_number       IN     fid_license.lic_number%TYPE,
      o_lee_short_name      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE x_prc_copy_pay_attr_search (
      i_program_title         IN     fid_license_vw.gen_title%TYPE,
      i_lic_no                IN     fid_license_vw.lic_number%TYPE,
      i_con_short_name        IN     fid_license_vw.con_short_name%TYPE,
      i_deal_memo             IN     fid_license_vw.lic_mem_number%TYPE,
      i_start_date            IN     fid_license_vw.lic_start%TYPE,
      i_end_date              IN     fid_license_vw.lic_end%TYPE,
      i_type                  IN     fid_license_vw.lic_type%TYPE,
      i_licensee              IN     fid_license_vw.lee_short_name%TYPE,
      i_status                IN     fid_license_vw.lic_status%TYPE,
      i_sup_short_name        IN     fid_company.com_short_name%TYPE,
      i_pay_date_from         IN     DATE,
      i_pay_date_to           IN     DATE,
      i_pay_date_not_avail    IN     VARCHAR2,
      i_due_date_from         IN     DATE,
      i_due_date_to           IN     DATE,
      i_pay_status            IN     VARCHAR2,
      i_spot_rate_from        IN     NUMBER,
      i_spot_rate_to          IN     NUMBER,
      i_spot_rate_not_avail   IN     VARCHAR2,
      i_post_date_from        IN     DATE,
      i_post_date_to          IN     DATE,
      o_cpy_pay_dtls             OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE x_prc_cpy_pay_attribute (
      i_pay_number         IN     fid_payment.pay_number%TYPE,
      i_status             IN     fid_payment.pay_status%TYPE,
      i_pay_date           IN     fid_payment.pay_date%TYPE,
      i_spot_rate          IN     fid_payment.pay_rate%TYPE,
      i_pay_update_count   IN     fid_payment.pay_update_count%TYPE,
      o_pay_dtls              OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE x_prc_transfer_payment_search (
      i_program_title    IN     fid_license_vw.gen_title%TYPE,
      i_lic_no           IN     fid_license_vw.lic_number%TYPE,
      i_con_short_name   IN     fid_license_vw.con_short_name%TYPE,
      i_deal_memo        IN     fid_license_vw.lic_mem_number%TYPE,
      i_start_date       IN     fid_license_vw.lic_start%TYPE,
      i_end_date         IN     fid_license_vw.lic_end%TYPE,
      i_type             IN     fid_license_vw.lic_type%TYPE,
      i_licensee         IN     fid_license_vw.lee_short_name%TYPE,
      i_status           IN     fid_license_vw.lic_status%TYPE,
      i_chs_name         IN     fid_channel_service.chs_name%TYPE,
      o_transfer_pay        OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE x_prc_add_transfer_payment (
      i_pay_lic_num         IN     NUMBER,
      i_pay_number          IN     fid_payment.pay_number%TYPE,
      i_pay_amount          IN     VARCHAR2,
      i_pay_source_number   IN     fid_payment.pay_source_number%TYPE,
      i_entry_oper          IN     fid_payment.pay_entry_oper%TYPE,
      i_pay_comment         IN     fid_payment.pay_comment%TYPE,
      i_pay_due             IN     fid_payment.pay_due%TYPE,
      i_pay_status          IN     fid_payment.pay_status%TYPE,
      o_success                OUT NUMBER);

   FUNCTION x_prc_avl_transfer_amt (
      i_pay_number IN fid_payment.pay_number%TYPE)
      RETURN NUMBER;

   FUNCTION x_prc_remaining_liab_amt (
      i_lic_number IN fid_license.lic_number%TYPE)
      RETURN NUMBER;

   PROCEDURE x_prc_delete_tmp_tabl_trnsfer;

   PROCEDURE x_prc_transfer_detail_rpt (
      o_transfer_detail OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE x_prc_con_prgm_details (
      i_con_short_name   IN     VARCHAR2,
      o_con_dtls            OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE x_prc_batch_pay_view_details (
      i_lic_number    IN     VARCHAR2,
      o_fid_payment      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

   PROCEDURE x_prc_batch_contractwise_dtls (
      i_pay_number           IN     fid_payment.pay_number%TYPE,
      o_po_fee_info             OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_title           OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_season          OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_season_pay      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_title_pay       OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_oth_dtls                OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry);

  PROCEDURE prc_get_licprice_paytotal (
      i_lic_number        IN     fid_payment.pay_lic_number%TYPE,
	  i_lee_short_name		  IN	 fid_licensee.lee_short_name%TYPE,
      o_lic_pay_details      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry
	  );
END PKG_FIN_MNET_PAY_QRY_MNT;
/


CREATE OR REPLACE PACKAGE BODY          "PKG_FIN_MNET_PAY_QRY_MNT"
AS
   PROCEDURE prc_contshortnamelov (
      o_con_short_name OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
   BEGIN
      ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/03/29]
      OPEN o_con_short_name FOR
         SELECT con_number,
                con_name,
                con_short_name,
                con_currency,
                lic_number,
                gen_title
           FROM fid_contract, fid_license, fid_general
          WHERE con_number = lic_con_number AND lic_gen_refno = gen_refno;
   ----------Dev2 :Pure Finance:End------------------------------
   END;

   --PROCEDURE TO SEARCH THE CONTRACT DETAILS
   PROCEDURE prc_searchcontdtls (
      i_program_title         IN     fid_license_vw.gen_title%TYPE,
      i_lic_no                IN     fid_license_vw.lic_number%TYPE,
      i_con_short_name        IN     VARCHAR2,
      i_deal_memo             IN     fid_license_vw.lic_mem_number%TYPE,
      i_start_date            IN     fid_license_vw.lic_start%TYPE,
      i_end_date              IN     fid_license_vw.lic_end%TYPE,
      i_type                  IN     fid_license_vw.lic_type%TYPE,
      i_license               IN     fid_license_vw.lee_short_name%TYPE,
      i_status                IN     fid_license_vw.lic_status%TYPE,
      i_sup_short_name        IN     VARCHAR2,
      i_pay_date_from         IN     DATE,
      i_pay_date_to           IN     DATE,
      i_pay_date_not_avail    IN     VARCHAR2,
      i_due_date_from         IN     DATE,
      i_due_date_to           IN     DATE,
      i_pay_status            IN     VARCHAR2,
      i_spot_rate_from        IN     NUMBER,
      i_spot_rate_to          IN     NUMBER,
      i_spot_rate_not_avail   IN     VARCHAR2,
      i_post_date_from        IN     DATE,
      i_post_date_to          IN     DATE,
      o_con_dtls                 OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
      l_qry_string       VARCHAR2 (4000);
      l_contract_name    VARCHAR2 (100);
      l_supplier_name    VARCHAR2 (100);
      l_flag             NUMBER;
      l_supplier_name1   VARCHAR2 (100);
   BEGIN
      l_flag := 0;
      l_qry_string :=
         ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/01/29]
         'select  gen_title
                ,    LIC_NUMBER
              --  ,    PAY_STATUS
                ,    CON_SHORT_NAME
                ,    CON_NAME
                ,    LIC_MEM_NUMBER
                ,    LIC_START
                ,    LIC_END
                ,    LIC_TYPE
                ,    LEE_SHORT_NAME
                ,    GEN_REFNO
                ,    LIC_LEE_NUMBER
                ,    LIC_CON_NUMBER
                ,    LIC_STATUS
                ,   CON_CURRENCY
                ,      COD_DESCRIPTION
                FROM
                (select  distinct gen_title
                ,    LIC_NUMBER
              --  ,    PAY_STATUS
                ,    CON_SHORT_NAME
                ,    CON_NAME
                ,    LIC_MEM_NUMBER
                ,    LIC_START
                ,    LIC_END
                ,    LIC_TYPE
                ,    LEE_SHORT_NAME
                ,    GEN_REFNO
                ,    LIC_LEE_NUMBER
                ,    LIC_CON_NUMBER
                ,    LIC_STATUS
                ,   CON_CURRENCY
                ,    COD_DESCRIPTION
                FROM
                (select  gen_title
                ,    LIC_NUMBER
              --  ,    PAY_STATUS
                ,    CON_SHORT_NAME
                ,    CON_NAME
                ,    LIC_MEM_NUMBER
                ,    LIC_START
                ,    LIC_END
                ,    LIC_TYPE
                ,    LEE_SHORT_NAME
                ,    GEN_REFNO
                ,    LIC_LEE_NUMBER
                ,    LIC_CON_NUMBER
                ,    LIC_STATUS
                ,   CON_CURRENCY
                ,   (Select COD_DESCRIPTION FROM FID_CODE WHERE COD_TYPE =''CON_CALC_TYPE'' AND COD_VALUE =  CON_CALC_TYPE) COD_DESCRIPTION
                from fid_license_vw flv,
                fid_payment fp,
                FID_COMPANY FC where
                flv.lic_number=fp.pay_lic_number(+)
                --and flv.con_number = fp.pay_con_number and
                 and flv.con_com_number=fc.com_number and flv.lic_status not in(''F'',''T'')';

      IF i_program_title IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and upper(gen_title) like upper('''
            || i_program_title
            || ''')';
        -- DBMS_OUTPUT.put_line (l_qry_string);
      END IF;

      IF i_lic_no IS NOT NULL
      THEN
         l_qry_string := l_qry_string || ' and flv.LIC_NUMBER =' || i_lic_no;
      END IF;

      /*if i_cont_no is not null
      then
         if l_flag = 0
         then
            l_qry_string := l_qry_string ||' where CON_NUMBER =' ||i_cont_no ;
            l_flag := 1;
         else
            l_qry_string := l_qry_string ||' and CON_NUMBER =' ||i_cont_no ;
            l_flag := 1;
         end if;
      end if;
      */
      IF i_con_short_name IS NOT NULL
      THEN
         l_contract_name := REPLACE (i_con_short_name, ',', ''',''');
         -- l_contract_name := replace(i_con_short_name,', ',''',''');
         l_qry_string :=
               l_qry_string
            || ' and flv.CON_SHORT_NAME in ('''
            || l_contract_name
            || ''')';
      END IF;

      /*if i_contract_title is not null
      then
         if l_flag = 0
         then
            l_qry_string := l_qry_string ||' where CON_NAME like ''' ||i_contract_title||'''' ;
            l_flag := 1;
         else
            l_qry_string := l_qry_string ||' and CON_NAME like ''' ||i_contract_title||'''' ;
            l_flag := 1;
         end if;
      end if;
      */
      IF i_deal_memo IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and flv.LIC_MEM_NUMBER =' || i_deal_memo;
      END IF;

      IF i_start_date IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and flv.LIC_START =to_date('''
            || i_start_date
            || ''')';
      END IF;

      IF i_end_date IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and flv.LIC_END =to_date('''
            || i_end_date
            || ''')';
      END IF;

      IF i_type IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and flv.LIC_TYPE like ''' || i_type || '''';
      END IF;

      IF i_license IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and flv.LEE_SHORT_NAME like '''
            || i_license
            || '''';
      END IF;

      IF i_status IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and flv.LIC_STATUS like ''' || i_status || '''';
      END IF;

      IF i_sup_short_name IS NOT NULL
      THEN
         l_supplier_name := REPLACE (i_sup_short_name, ',', ''',''');
         --  DBMS_OUTPUT.PUT_LINE('l_supplier_name:'||l_supplier_name);
         ---------------------
         --  select com_number into l_supplier_name1 from fid_company where com_short_name in ( ''||l_supplier_name||'' );
         ---------------------
         --   DBMS_OUTPUT.PUT_LINE('l_supplier_name1:'||l_supplier_name1);

         --  l_supplier_name := replace(i_sup_short_name,', ',''',''');
         l_qry_string :=
               l_qry_string
            || ' and fc.COM_SHORT_NAME in ('''
            || l_supplier_name
            || ''')';
      END IF;

      IF i_pay_date_from IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_DATE >= to_date('''
            || i_pay_date_from
            || ''')';
      END IF;

      IF i_pay_date_to IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_DATE <= to_date('''
            || i_pay_date_to
            || ''')';
      END IF;

      IF i_pay_date_not_avail = 'Y'
      THEN
         l_qry_string := l_qry_string || ' and fp.PAY_DATE is null';
       --  DBMS_OUTPUT.put_line ('pay_date_not_avail:' || i_pay_date_not_avail);
      END IF;

      IF i_due_date_from IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_DUE >= to_date('''
            || i_due_date_from
            || ''')';
      END IF;

      IF i_due_date_to IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_DUE <= to_date('''
            || i_due_date_to
            || ''')';
      END IF;

      IF i_pay_status IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and nvl(fp.PAY_STATUS,''%'') like '''
            || i_pay_status
            || '''';
      END IF;

      IF i_spot_rate_from IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and fp.PAY_RATE >= ' || i_spot_rate_from;
      END IF;

      IF i_spot_rate_to IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and fp.PAY_RATE <= ' || i_spot_rate_to;
      END IF;

      IF i_spot_rate_not_avail = 'Y'
      THEN
         l_qry_string :=
            l_qry_string
            || ' and fp.pay_status=''P'' and fp.pay_rate is null ';
         --DBMS_OUTPUT.put_line ('spot_rate_not_avail:' || i_spot_rate_not_avail);
      END IF;

      IF i_post_date_from IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_STATUS_DATE >= to_date('''
            || i_post_date_from
            || ''')';
      END IF;

      IF i_post_date_to IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_STATUS_DATE <= to_date('''
            || i_post_date_to
            || ''')';
      END IF;

      ----Dev2: Pure Finance: End----------------------------------------------------------------
      l_qry_string := l_qry_string || '))' || '  where rownum <=500';
      l_qry_string := l_qry_string || ' order by gen_title ';
      --DBMS_OUTPUT.put_line ('l_qry_string:' || l_qry_string);

      OPEN o_con_dtls FOR l_qry_string;
   END;

   --PROCEDURE TO SELECT CONTRACT DETAILS
   PROCEDURE prc_contractdtls (
      i_con_short_name       IN     fid_contract.con_short_name%TYPE,
      --,   o_cpd_dtls     out   PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry
      ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/01/29]
      i_lic_number           IN     fid_license.lic_number%TYPE,
      ----Dev2: Pure Finance: End---------------------------------
      i_gen_title            IN     fid_general.gen_title%TYPE,
      i_amount               IN     fid_payment.pay_amount%TYPE,
      i_code                 IN     fid_payment.pay_code%TYPE,
      i_status               IN     fid_payment.pay_status%TYPE,
      i_duedate              IN     fid_payment.pay_due%TYPE,
      i_supplier             IN     fid_payment.pay_reference%TYPE,
      o_fid_payment             OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_po_fee_info             OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_oth_dtls                OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_title           OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_season          OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_season_pay      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_title_pay       OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
      l_pay_fcd_number       fid_payment.pay_fcd_number%TYPE;
      o_tot_paid_sel_title   NUMBER;
      o_inc_mkup_sel_title   NUMBER;
      o_exc_mkup_sel_title   NUMBER;
      o_ous_liab_sel_title   NUMBER;
      o_tot_paid_ent_con     NUMBER;
      o_inc_mkup_ent_con     NUMBER;
      o_exc_mkup_ent_con     NUMBER;
      o_ous_liab_ent_con     NUMBER;
      o_con_number           fid_contract.con_number%TYPE;
      o_con_calc_type        fid_contract.con_calc_type%TYPE;
      o_pay_amt              NUMBER;
      o_con_calc_type_desc   fid_code.cod_description%TYPE;
      o_con_currency         fid_contract.con_currency%TYPE;
      o_con_price            fid_contract.con_price%TYPE;
      o_con_short_name       fid_contract.con_short_name%TYPE;
      o_con_name             fid_contract.con_name%TYPE;
      l_querystring          VARCHAR2 (4000);
   BEGIN
      NULL;

      OPEN o_fid_payment FOR SELECT SYSDATE FROM DUAL;

--      DBMS_OUTPUT.put_line ('TEST 1');

      BEGIN
         SELECT con_number,
                con_short_name,
                con_calc_type,
                con_name,
                con_currency,
                con_price
           INTO o_con_number,
                o_con_short_name,
                o_con_calc_type,
                o_con_name,
                o_con_currency,
                o_con_price
           FROM fid_contract
          WHERE con_short_name = i_con_short_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20426,
               'The Contract Name ' || i_con_short_name || ' does not exists');
      END;

     -- DBMS_OUTPUT.put_line ('TEST 2');

      BEGIN
         SELECT SUM (pay_amount)
           INTO o_pay_amt
           FROM fid_payment, fid_payment_type
          WHERE     pay_con_number = o_con_number
                AND pay_code = pat_code
                AND pat_group = 'F'
                AND pay_status = 'P';

        -- DBMS_OUTPUT.put_line ('TEST 3');

         SELECT SUBSTR (cod_description, 1, 20)
           INTO o_con_calc_type_desc
           FROM fid_code
          WHERE     cod_type = 'CON_CALC_TYPE'
                AND cod_value = o_con_calc_type
                AND cod_value <> 'HEADER';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20426,
                                     'Code Description does not found ');
      END;

     -- DBMS_OUTPUT.put_line ('TEST 4');
      --       OPEN o_fid_payment FOR
      l_querystring :=
         'select PAY_NUMBER
        ,(select lee_short_name from fid_licensee where lee_number in(select lsl_lee_number from x_fin_lic_sec_lee where lsl_number= pay_lsl_number))licensee
        ,    PAY_SOURCE_COM_NUMBER
        ,    PAY_TARGET_COM_NUMBER
        ,    PAY_CON_NUMBER
        ,   (select con_short_name from fid_contract where con_number= PAY_CON_NUMBER) con_short_name
        ,   (select con_calc_type from fid_contract where con_number= PAY_CON_NUMBER) con_calc_type
        ,    PAY_LIC_NUMBER
        ,    PAY_STATUS
        ,    PAY_STATUS_DATE
        ,    trunc(PAY_AMOUNT,2) PAY_AMOUNT
        ,    PAY_CUR_CODE
         ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/01/29]
        ,    PAY_DATE
        ,(select ter_cur_code from fid_territory where ter_code in (select com_ter_code from fid_company where com_number in (select lee_cha_com_number from fid_licensee
            where lee_number in (select lsl_lee_number from x_fin_lic_sec_lee where lsl_lic_number = PAY_LIC_NUMBER))))loc_cur_code
        ----Dev2: Pure Finance: End------------------------------------
        ,    PAY_RATE
        ,    PAY_CODE
        ,    PAY_DUE
        ,    PAY_UPDATE_COUNT
        ,    PAY_REFERENCE
	    	,    PAY_MNET_REFERENCE   -------- #region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
        ,    PAY_COMMENT
        ,    PAY_SUPPLIER_INVOICE
        ,    PAY_ENTRY_DATE
        ,    PAY_ENTRY_OPER
        ,    PAY_MARKUP_PERCENT
        ,    PAY_FCD_NUMBER
        ,    fg.GEN_TITLE
        ,    fl.LIC_NUMBER
        ,    fg.GEN_REFNO
        ,    fg.gen_ser_number
        ,    PKG_FIN_MNET_PAY_QRY_MNT.x_prc_avl_transfer_amt(pay_number) transferable_amt
        ,    (select com_short_name from fid_company where com_number in (select con_com_number from fid_contract where con_number=pay_con_number))supplier
        
        --Finance Dev Phase I Zeshan Khan
        
       , CASE 
          WHEN
           (PAY_DATE >=(SELECT TO_DATE (fim_year || fim_month, ''YYYYMM'')
                  FROM fid_financial_month, fid_licensee
                 WHERE fim_split_region = lee_split_region
                       AND fim_status = ''O''
                       AND lee_number = (SELECT lic_lee_number FROM fid_license WHERE lic_number = FL.LIC_NUMBER)))
        THEN
        ''Y''
        ELSE
        ''N''
        END LIC_PAID_FLAG
        ---Finance Dev Phase I Ankur Kasar
        ,   LIC_STATUS
      from  fid_payment
        ,   fid_license  fl
        ,   fid_general fg
     where  fl.lic_number = PAY_LIC_NUMBER
        and fl.lic_gen_refno = fg.gen_refno
        and pay_status NOT IN (''F'')
        and pay_con_number = '''
         || o_con_number
         || '''';

      /*and pay_amount = DECODE('''
       || i_amount
       || ''',0.0,pay_amount,'''
       || i_amount
       || ''')';*/

      --and gen_title like decode('''||i_gen_title||''' , null,gen_title, '''||i_gen_title ||''')
      --and pay_code like decode('''||i_code||''',null,pay_code,'''||i_code||''')
      -- and pay_status like decode('''||i_status||''',null,pay_status,'''||i_status||''')
      --and pay_due = decode('''||i_duedate||''',null,pay_due,'''||i_duedate||''')
      --and upper(pay_reference) like upper(decode('''||i_supplier||''',null,pay_reference,'''||i_supplier||'''))
      IF (i_amount IS NOT NULL)
      THEN
         l_querystring := l_querystring || ' and pay_amount = ' || i_amount;
      END IF;

      IF (i_gen_title IS NOT NULL)
      THEN
         l_querystring :=
               l_querystring
            || ' and upper(gen_title) like upper('''
            || i_gen_title
            || ''')';
      END IF;

      IF (i_code IS NOT NULL)
      THEN
         l_querystring :=
               l_querystring
            || ' and upper(pay_code) like upper('''
            || i_code
            || ''')';
      END IF;

      IF (i_status IS NOT NULL)
      THEN
         l_querystring :=
               l_querystring
            || ' and upper(pay_status) like upper('''
            || i_status
            || ''')';
      END IF;

      IF (i_duedate IS NOT NULL)
      THEN
         l_querystring :=
            l_querystring || ' and pay_due = ''' || i_duedate || '''';
      END IF;

      IF (i_supplier IS NOT NULL)
      THEN
         l_querystring :=
               l_querystring
            || ' and upper(pay_reference) like upper('''
            || i_supplier
            || ''')';
      END IF;

      l_querystring :=
         -- l_querystring || ' order by fg.GEN_TITLE, PAY_DUE , PAY_CODE asc';
         l_querystring || ' order by PAY_DUE ,pay_lic_number
         ,(select lee_short_name from fid_licensee where lee_number in(select lsl_lee_number from x_fin_lic_sec_lee where lsl_number= pay_lsl_number))
         asc';
      --dbms_output.put_line(l_querystring);
      OPEN o_fid_payment FOR l_querystring;

      /*
         if(i_gen_title is NULL) then
         OPEN o_fid_payment FOR
                           'select PAY_NUMBER
           ,    PAY_SOURCE_COM_NUMBER
           ,    PAY_TARGET_COM_NUMBER
           ,    PAY_CON_NUMBER
           ,    PAY_LIC_NUMBER
           ,    PAY_STATUS
           ,    PAY_STATUS_DATE
           ,    trunc(PAY_AMOUNT,4) PAY_AMOUNT
           ,    PAY_CUR_CODE
           ,    PAY_RATE
           ,    PAY_CODE
           ,    PAY_DUE
           ,    PAY_REFERENCE
           ,    PAY_COMMENT
           ,    PAY_SUPPLIER_INVOICE
           ,    PAY_ENTRY_DATE
           ,    PAY_ENTRY_OPER
           ,    PAY_MARKUP_PERCENT
           ,    PAY_FCD_NUMBER
           ,    fg.GEN_TITLE
           ,    fl.LIC_NUMBER
                   ,       fg.GEN_REFNO
                   ,       fg.gen_ser_number
           from     fid_payment
           ,    fid_license  fl
           ,      fid_general fg
                   where    fl.lic_number = PAY_LIC_NUMBER
           and    fl.lic_gen_refno = fg.gen_refno
           and    pay_con_number ='
                                || o_con_number
                                || '
                   order by PAY_DUE asc';

         DBMS_OUTPUT.put_line ('TEST 5 ' || o_con_number);
       else
             OPEN o_fid_payment FOR
                           'select PAY_NUMBER
           ,    PAY_SOURCE_COM_NUMBER
           ,    PAY_TARGET_COM_NUMBER
           ,    PAY_CON_NUMBER
           ,    PAY_LIC_NUMBER
           ,    PAY_STATUS
           ,    PAY_STATUS_DATE
           ,    trunc(PAY_AMOUNT,4) PAY_AMOUNT
           ,    PAY_CUR_CODE
           ,    PAY_RATE
           ,    PAY_CODE
           ,    PAY_DUE
           ,    PAY_REFERENCE
           ,    PAY_COMMENT
           ,    PAY_SUPPLIER_INVOICE
           ,    PAY_ENTRY_DATE
           ,    PAY_ENTRY_OPER
           ,    PAY_MARKUP_PERCENT
           ,    PAY_FCD_NUMBER
           ,    fg.GEN_TITLE
           ,    fl.LIC_NUMBER
                   ,       fg.GEN_REFNO
                   ,       fg.gen_ser_number
           from     fid_payment
           ,    fid_license  fl
           ,      fid_general fg
                   where    fl.lic_number = PAY_LIC_NUMBER
           and    fl.lic_gen_refno = fg.gen_refno
           and    pay_con_number ='|| o_con_number|| '
                   and     gen_title like '''||i_gen_title||'''
                   order by PAY_DUE asc';
   and gen_title like decode(i_gen_title , null,gen_title,i_gen_title
                    DBMS_OUTPUT.put_line ('Gen_title is not null');
        end if;*/
      BEGIN
         SELECT DISTINCT pay_fcd_number
           INTO l_pay_fcd_number
           FROM fid_payment
          WHERE pay_con_number = o_con_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_pay_fcd_number := NULL;
      ---raise_application_error (-20426, 'No Data Found ');
      END;

      /*open o_cpd_dtls for
      select   fcd_title, fcd_price, fcd_per_year, fcd_per_month
      ,  fcd_end_year, fcd_end_month
      from  fid_cpd_details
      where fcd_number = l_PAY_FCD_NUMBER
      ;*/
     -- DBMS_OUTPUT.put_line ('TEST 6');

      --POPULATE FEE INFO
      /*select con_currency
      ,  con_price
      into  o_con_currency
      ,  o_con_price
      from fid_contract
            where con_number =o_con_number
            ;*/
      IF o_con_calc_type IN ('FLF', 'CHC')
      THEN
         SELECT NVL (SUM (lsl_lee_price), 0),
                NVL (SUM (lsl_lee_price * (100 + lic_markup_percent) / 100),
                     0)
           INTO o_exc_mkup_ent_con, o_inc_mkup_ent_con
           FROM fid_license, x_fin_lic_sec_lee
          WHERE     lic_number = lsl_lic_number
                AND lic_con_number = o_con_number
                AND lic_type IN ('FLF', 'CHC');

         SELECT NVL (SUM (lsl_lee_price), 0),
                NVL (SUM (lsl_lee_price * (100 + lic_markup_percent) / 100),
                     0)
           INTO o_exc_mkup_sel_title                       --:control.qry_excl
                                    , o_inc_mkup_sel_title --:control.qry_incl
           FROM fid_license, fid_general, x_fin_lic_sec_lee
          WHERE     lic_con_number = o_con_number
                AND lic_gen_refno = gen_refno
                AND lic_number = lsl_lic_number
                --and gen_title like nvl(:control.title_query, '%')
                AND lic_type IN ('FLF', 'CHC');
      ELSIF o_con_calc_type = 'CPD'
      THEN
         BEGIN
            SELECT con_price
              INTO o_inc_mkup_ent_con
              FROM fid_contract
             WHERE con_number = o_con_number;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_inc_mkup_ent_con := 0;
         END;

         o_exc_mkup_ent_con := 0;
         o_inc_mkup_sel_title := o_exc_mkup_ent_con;
         o_exc_mkup_sel_title := 0;
      ELSE
         o_exc_mkup_ent_con := 0;
         o_inc_mkup_ent_con := 0;
         o_exc_mkup_sel_title := 0;
         o_inc_mkup_sel_title := 0;
      END IF;

     -- DBMS_OUTPUT.put_line ('TEST 7');

      IF o_con_calc_type IN ('FLF', 'CHC', 'CPD')
      THEN
         o_tot_paid_ent_con := NVL (o_pay_amt, 0);

         --o_pay_amt + sumpay(:pay_status, :pay_amount, :pay_group)
         BEGIN
            SELECT NVL (SUM (pay_amount), 0)
              INTO o_tot_paid_sel_title
              FROM fid_license, fid_general, fid_payment
             WHERE     lic_con_number = o_con_number
                   AND pay_con_number = lic_con_number
                   AND pay_status = 'P'
                   AND pay_lic_number = lic_number
                   AND lic_gen_refno = gen_refno--and    gen_title like nvl(:control.title_query, '%')
            ;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_tot_paid_sel_title := 0;
         END;

         o_ous_liab_ent_con := o_inc_mkup_ent_con - o_tot_paid_ent_con;
         o_ous_liab_sel_title := o_inc_mkup_sel_title - o_tot_paid_sel_title;
      ELSE
         o_tot_paid_ent_con := 0;
         o_tot_paid_sel_title := 0;
         o_ous_liab_ent_con := 0;
         o_ous_liab_sel_title := 0;
      END IF;

      OPEN o_po_fee_info FOR
         SELECT ROUND (o_tot_paid_sel_title, 2) o_tot_paid_sel_title,
                TRUNC (o_inc_mkup_sel_title, 2) o_inc_mkup_sel_title,
                TRUNC (o_exc_mkup_sel_title, 2) o_exc_mkup_sel_title,
                TRUNC (o_ous_liab_sel_title, 2) o_ous_liab_sel_title,
                TRUNC (o_tot_paid_ent_con, 2) o_tot_paid_ent_con,
                TRUNC (o_inc_mkup_ent_con, 2) o_inc_mkup_ent_con,
                TRUNC (o_exc_mkup_ent_con, 2) o_exc_mkup_ent_con,
                TRUNC (o_ous_liab_ent_con, 2) o_ous_liab_ent_con
           FROM DUAL;

     -- DBMS_OUTPUT.put_line (o_tot_paid_sel_title);

      OPEN o_oth_dtls FOR
         SELECT o_con_number o_con_number,
                o_con_calc_type o_con_calc_type,
                o_pay_amt o_pay_amt,
                o_con_calc_type_desc o_con_calc_type_desc,
                o_con_currency o_con_currency,
                o_con_price o_con_price,
                o_con_short_name o_con_short_name,
                o_con_name o_con_name
           FROM DUAL;

      /* Group by gen_ser_number - season */
      OPEN o_dtls_by_season FOR
           SELECT NVL (SUM (TRUNC (lsl.lsl_lee_price, 2)), 0)
                     o_exc_mkup_sel_title,
                  NVL (
                     SUM (
                          TRUNC (lsl.lsl_lee_price, 2)
                        * (100 + TRUNC (fl.lic_markup_percent, 2))
                        / 100),
                     0)
                     o_inc_mkup_sel_title,
                  fg.gen_ser_number
             FROM fid_license fl, fid_general fg, x_fin_lic_sec_lee lsl
            --fid_payment fp,
            --fid_payment_type fpt
            WHERE     fl.lic_con_number = o_con_number
                  AND fl.lic_gen_refno = fg.gen_refno
                  AND fl.lic_number = lsl.lsl_lic_number
                  AND fg.gen_ser_number IS NOT NULL
                  -- AND fl.lic_con_number = fp.pay_con_number
                  --AND fl.lic_number = fp.pay_lic_number
                  -- AND fp.pay_code = fpt.pat_code
                  --AND fpt.pat_group = 'F'
                  AND fl.lic_type IN ('FLF', 'CHC')
         --And fg.gen_ser_number =1010383
         GROUP BY fg.gen_ser_number;

      OPEN o_dtls_by_season_pay FOR
           SELECT DISTINCT
                  fg.gen_ser_number,
                  NVL (SUM (TRUNC (fp.pay_amount, 2)), 0) o_pay_amt
             FROM fid_license fl, fid_general fg, fid_payment fp
            --    fid_payment_type fpt
            WHERE     fl.lic_con_number = o_con_number
                  AND fl.lic_gen_refno = fg.gen_refno
                  AND fp.pay_con_number = fl.lic_con_number
                  AND fl.lic_number = fp.pay_lic_number
                  AND fg.gen_ser_number IS NOT NULL
                  --    AND       fp.pay_code = fpt.pat_code
                  --   AND       fpt.pat_group = 'F'
                  AND fp.pay_status = 'P'
         --  AND       fg.gen_ser_number = 1010383
         GROUP BY fg.gen_ser_number;

       /*select   nvl(sum(trunc(fl.lic_price,2)),0) o_exc_mkup_sel_title
       ,       nvl(to_char(sum(trunc(fl.lic_price,2)* (100 + trunc(fl.lic_markup_percent,2)) / 100),'999,999,999,999.90'),to_char(0,'999,999,999,999.90')) o_inc_mkup_sel_title
       ,       nvl(to_char(sum(trunc(fp.pay_amount,2)),'999,999,999,999.90'),to_char(0,'999,999,999,999.90'))  o_pay_amt
       ,       fg.gen_ser_number


from  fid_license fl
,  fid_general fg
               ,       fid_payment fp
               ,       fid_payment_type fpt
where fl.lic_con_number = o_con_number
               and     fl.lic_gen_refno = fg.gen_refno
and   fl.lic_con_number = fp.pay_con_number
            --   and fl.lic_type in ('FLF', 'CHC')
               and fl.lic_number = fp.PAY_LIC_NUMBER
               and   fp.pay_code = fpt.pat_code
and   fpt.pat_group = 'F'
and   fp.pay_status = 'P'
               group by fg.gen_ser_number ;

            dbms_output.put_line('TEST 8');*/

      /* Group by gen_refno and gen_title */
      OPEN o_dtls_by_title FOR
           SELECT NVL (SUM (TRUNC (lsl.lsl_lee_price, 2)), 0)
                     o_exc_mkup_sel_title,
                  NVL (
                     SUM (
                          TRUNC (lsl.lsl_lee_price, 2)
                        * (100 + TRUNC (fl.lic_markup_percent, 2))
                        / 100),
                     0)
                     o_inc_mkup_sel_title,
                  fg.gen_title,
                  fg.gen_refno
             FROM fid_license fl, fid_general fg, x_fin_lic_sec_lee lsl
            WHERE     fl.lic_con_number = o_con_number
                  AND fl.lic_gen_refno = fg.gen_refno
                  AND fl.lic_number = lsl.lsl_lic_number
                  AND fl.lic_type IN ('FLF', 'CHC')
                  AND fl.lic_price != 0
         GROUP BY fg.gen_title, fg.gen_refno;

    --  DBMS_OUTPUT.put_line ('TEST 9');

      OPEN o_dtls_by_title_pay FOR
           SELECT NVL (
                     SUM (
                        TRUNC (DECODE (fp.pay_status, 'P', fp.pay_amount, 0),
                               2)),
                     0)
                     o_pay_amt,
                  fg.gen_title,
                  fg.gen_refno
             FROM fid_general fg, fid_payment fp, fid_license fl
            WHERE     fl.lic_con_number = o_con_number
                  AND fl.lic_gen_refno = fg.gen_refno
                  AND fl.lic_con_number = fp.pay_con_number
                  AND fl.lic_type IN ('FLF', 'CHC')
                  AND fl.lic_number = fp.pay_lic_number
         --AND fp.pay_status = 'P'
         GROUP BY fg.gen_title, fg.gen_refno;
   END;

   PROCEDURE prc_title_lic_dtls (
      i_con_short_name   IN     fid_contract.con_short_name%TYPE,
      o_title_lic_no        OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
   BEGIN
      OPEN o_title_lic_no FOR
         SELECT DISTINCT gen_title, lic_number, con_short_name
           FROM fid_general, fid_license, fid_contract
          WHERE     gen_refno = lic_gen_refno
                AND lic_con_number = con_number
                AND con_short_name = i_con_short_name;
   END;

   PROCEDURE prc_pay_qry_val_lic_no_title (
      i_o_gen_title     IN OUT fid_general.gen_title%TYPE,
      i_o_lic_number    IN OUT fid_license.lic_number%TYPE,
      o_error_message      OUT VARCHAR2)
   AS
      l_gen_title    fid_general.gen_title%TYPE;
      l_lic_number   fid_license.lic_number%TYPE;
   BEGIN
    /*  DBMS_OUTPUT.put_line (
            '---1---'
         || NVL (i_o_gen_title, '***')
         || ' '
         || NVL (i_o_lic_number, 99)
         || ' ----');
*/
      IF i_o_gen_title IS NULL AND i_o_lic_number IS NULL
      THEN
         o_error_message := 'Title and Licence Both can not be NULL';
      ELSE
         IF i_o_gen_title IS NOT NULL AND i_o_lic_number IS NOT NULL
         THEN
            o_error_message := 'Title and Licence Both can not be NOT NULL';
         ELSE
          --  DBMS_OUTPUT.put_line ('---2---');

            IF i_o_gen_title IS NOT NULL
            THEN
            --   DBMS_OUTPUT.put_line ('---3---');

               BEGIN
                  SELECT lic_number
                    INTO i_o_lic_number
                    FROM fid_license fl, fid_general fg
                   WHERE fg.gen_refno = fl.lic_gen_refno
                         AND UPPER (fg.gen_title) = UPPER (i_o_gen_title);
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     o_error_message := 'Invalid Title ';
                /*  WHEN OTHERS
                  THEN
                     DBMS_OUTPUT.put_line ('---4---' || SQLERRM);
                     */
               END;

              -- DBMS_OUTPUT.put_line ('LIC NO' || i_o_lic_number);
            ELSE
               BEGIN
                  SELECT gen_title
                    INTO i_o_gen_title
                    FROM fid_license fl, fid_general fg
                   WHERE fl.lic_number = i_o_lic_number
                         AND fg.gen_refno = fl.lic_gen_refno;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     o_error_message := 'Invalid Licence Number';
               END;
            END IF;
         END IF;
      END IF;

     -- DBMS_OUTPUT.put_line ('---5---');
   END;

   PROCEDURE prc_add_payment (
      ----Dev2: Pure Finance: Start:[CR Id/Mantis Id]_Hari_2013/01/30]
      i_licensee               IN     fid_licensee.lee_short_name%TYPE,
      ----Dev2: Pure Finance: End------------------------------------
      i_pay_code               IN     fid_payment.pay_code%TYPE,
      i_pay_cur_code           IN     fid_payment.pay_cur_code%TYPE,
      i_pay_amount             IN     fid_payment.pay_amount%TYPE,
      i_pay_status             IN     fid_payment.pay_status%TYPE,
      i_pay_status_date        IN     fid_payment.pay_status_date%TYPE,
      i_pay_due                IN     fid_payment.pay_due%TYPE,
      i_pay_date               IN     fid_payment.pay_date%TYPE,
      ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/02]
      i_pay_rate               IN     fid_payment.pay_rate%TYPE,
      ----Dev2: Pure Finance: End------------------------------------
      i_pay_supplier_invoice   IN     fid_payment.pay_reference%TYPE,
	  i_pay_mnet_invoice       IN     fid_payment.PAY_MNET_REFERENCE%TYPE, -- #region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
      i_pay_comment            IN     fid_payment.pay_comment%TYPE,
      i_pay_con_number         IN     fid_payment.pay_con_number%TYPE,
      i_pay_lic_number         IN     fid_payment.pay_lic_number%TYPE,
      i_userid                 IN     VARCHAR2,
      i_pay_duestr             IN     VARCHAR2,
      i_is_transfer_pay        IN     VARCHAR2,
      o_pay_number                OUT NUMBER,
      o_gen_refno                 OUT NUMBER,
      o_gen_title                 OUT VARCHAR2,
      o_gen_ser_number            OUT NUMBER,
      o_success                   OUT NUMBER)
   AS
      l_pay_source_com_number   fid_payment.pay_source_com_number%TYPE;
      l_pay_target_com_number   fid_payment.pay_target_com_number%TYPE;
      l_pay_number              NUMBER;
      ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/02]
      l_lee_number              NUMBER;
      l_lsl_number              NUMBER;
      l_split_region            fid_licensee.lee_split_region%TYPE;
      l_open_month              DATE;
      l_last_month              DATE;
      l_to_date                 DATE;
      l_paid_amount             NUMBER;
      l_total_amount            NUMBER;
      l_sec_lic_price           NUMBER;
      ----Dev2: Pure Finance: End------------------------------------
      l_gen_refno               NUMBER;
      l_gen_title               VARCHAR2 (120);
      l_gen_ser_number          NUMBER;
      l_update_count            NUMBER;
   BEGIN
     -- DBMS_OUTPUT.put_line ('TEST1');

      BEGIN
         SELECT lee_cha_com_number
           INTO l_pay_source_com_number
           FROM fid_licensee, fid_license
          WHERE lic_lee_number = lee_number AND lic_number = i_pay_lic_number;

         SELECT com_number
           INTO l_pay_target_com_number
           FROM fid_contract, fid_company
          WHERE con_number = i_pay_con_number AND com_number = con_com_number;

         ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/02]
         SELECT lee_number
           INTO l_lee_number
           FROM fid_licensee
          WHERE lee_short_name = i_licensee;

         SELECT lsl_number
           INTO l_lsl_number
           FROM x_fin_lic_sec_lee
          WHERE lsl_lee_number = l_lee_number
                AND lsl_lic_number = i_pay_lic_number;

         SELECT lee_split_region
           INTO l_split_region
           FROM fid_licensee
          WHERE lee_number IN (SELECT lic_lee_number
                                 FROM fid_license
                                WHERE lic_number = i_pay_lic_number);
      ----Dev2: Pure Finance: End------------------------------------
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      SELECT TO_DATE (
                TO_CHAR (
                   TO_DATE (
                      TO_CHAR ('01' || LPAD (fim_month, 2, 0) || fim_year),
                      'DD/MM/RRRR'),
                   'DD-MON-RRRR'))
        INTO l_open_month
        FROM fid_financial_month
       WHERE fim_status = 'O'
             AND NVL (fim_split_region, 1) =
                    DECODE (fim_split_region, NULL, 1, l_split_region);

      IF i_pay_date < l_open_month
      THEN
         l_last_month := ADD_MONTHS (l_open_month, -1);

         BEGIN
            SELECT MAX (fmd_to_date)
              INTO l_to_date
              FROM x_fin_month_defn
             WHERE fmd_month =
                      TO_NUMBER (
                         TO_CHAR (TO_DATE (l_last_month, 'DD/MM/YYYY'), 'MM'))
                   AND fmd_year =
                          TO_NUMBER (
                             TO_CHAR (TO_DATE (l_last_month, 'DD/MM/YYYY'),
                                      'YYYY'))
                   AND fmd_region = l_split_region
                   AND UPPER (fmd_mon_end_type) = 'FINAL';

            IF l_to_date IS NULL
            THEN
               l_to_date := LAST_DAY (l_last_month);
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_to_date := LAST_DAY (l_last_month);
         END;

         IF i_pay_date <= l_to_date
         THEN
            raise_application_error (
               -20345,
                  'Can not insert the payment date for License no-'
               || i_pay_lic_number
               || ' as it is in closed financial month.');
         END IF;
      END IF;

     -- DBMS_OUTPUT.put_line ('TEST2');

      SELECT seq_pay_number.NEXTVAL INTO l_pay_number FROM DUAL;

      BEGIN
         INSERT INTO fid_payment (pay_code,
                                  pay_number,
                                  pay_source_com_number,
                                  pay_target_com_number,
                                  pay_con_number,
                                  pay_lic_number,
                                  pay_status,
                                  pay_status_date,
                                  pay_amount,
                                  pay_cur_code,
                                  pay_comment,
                                  pay_reference,
                                  pay_due,
                                  pay_entry_oper,
                                  pay_entry_date,
                                  ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/02]
                                  pay_rate,
                                  pay_date,
                                  pay_lsl_number-----Dev2: Pure Finance: End------------------------------------
                                  ,PAY_MNET_REFERENCE) --#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
              VALUES (i_pay_code,
                      l_pay_number,
                      l_pay_source_com_number,
                      l_pay_target_com_number,
                      i_pay_con_number,
                      i_pay_lic_number,
                      i_pay_status,
                      TO_CHAR (TO_DATE (i_pay_status_date), 'DD-MON-YYYY'),
                      i_pay_amount,
                      i_pay_cur_code,
                      i_pay_comment,
                      i_pay_supplier_invoice,
                      i_pay_due    --to_char(to_date(i_PAY_DUE),'DD-MON-YYYY')
                               ,
                      i_userid,
                      SYSDATE,
                      ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/02]
                      i_pay_rate,
                      i_pay_date,
                      l_lsl_number-----Dev2: Pure Finance: End------------------------------------
                      ,i_pay_mnet_invoice); ----#region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN

       --  DBMS_OUTPUT.put_line ('l_pay_number --->' || l_pay_number);

         SELECT pay_update_count
           INTO l_update_count
           FROM fid_payment
          WHERE pay_number = l_pay_number;

         o_pay_number := l_pay_number;

         SELECT g.gen_refno
           INTO l_gen_refno
           FROM fid_general g, fid_license l
          WHERE l.lic_gen_refno = g.gen_refno
                AND lic_number = i_pay_lic_number;

         o_gen_refno := l_gen_refno;

         SELECT g.gen_ser_number
           INTO l_gen_ser_number
           FROM fid_general g, fid_license l
          WHERE l.lic_gen_refno = g.gen_refno
                AND lic_number = i_pay_lic_number;

         o_gen_ser_number := l_gen_ser_number;

         SELECT g.gen_title
           INTO l_gen_title
           FROM fid_general g, fid_license l
          WHERE l.lic_gen_refno = g.gen_refno
                AND lic_number = i_pay_lic_number;

         o_gen_title := l_gen_title;
         --o_update_count := l_update_count;
         o_success := 1;
      /*exception
      when
      others
      then
         raise_application_error(-20420,sqlerrm);
         o_success := -1;*/
      END;
   END;

   PROCEDURE prc_get_payment_code_desc (
      i_pat_code            fid_payment_type.pat_code%TYPE,
      i_pay_code_desc   OUT fid_payment_type.pat_desc%TYPE,
      i_pat_group       OUT fid_payment_type.pat_group%TYPE)
   AS
   BEGIN
      SELECT pat_desc, pat_group
        INTO i_pay_code_desc, i_pat_group
        FROM fid_payment_type
       WHERE pat_code = i_pat_code;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   PROCEDURE prc_update_payment (
      i_pay_con_number            fid_payment.pay_con_number%TYPE,
      i_pay_number                fid_payment.pay_number%TYPE,
      ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/05]
      i_licensee           IN     fid_licensee.lee_short_name%TYPE,
      ----Dev2: Pure Finance: End------------------------------------
      i_pay_code                  fid_payment.pay_code%TYPE,
      i_pay_cur_code              fid_payment.pay_cur_code%TYPE,
      i_pay_amount                fid_payment.pay_amount%TYPE,
      i_pay_status_date           fid_payment.pay_status_date%TYPE,
      i_pay_due                   fid_payment.pay_due%TYPE,
      i_pay_reference             fid_payment.pay_reference%TYPE,
	  i_pay_mnet_invoice   IN     fid_payment.PAY_MNET_REFERENCE%TYPE, -- #region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
      i_pay_comment               fid_payment.pay_comment%TYPE,
      i_pay_lic_number            fid_payment.pay_lic_number%TYPE,
      i_gen_title                 fid_general.gen_title%TYPE,
      i_pay_status                fid_payment.pay_status%TYPE,
      i_pay_date           IN     fid_payment.pay_date%TYPE,
      i_pay_rate           IN     fid_payment.pay_rate%TYPE,
      i_pay_update_count          fid_payment.pay_update_count%TYPE,
      i_entry_oper         IN     fid_payment.pay_entry_oper%TYPE,
      i_is_transfer_pay    IN     VARCHAR2,
	  i_is_rem_lib_same     IN     VARCHAR2,
      o_pay_dtls              OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
      l_pay_status            fid_payment.pay_status%TYPE;
      l_curr_code             fid_currency.cur_code%TYPE;
      l_pay_update_count      fid_payment.pay_update_count%TYPE;
      l_season_number_count   NUMBER;
      l_season_number         VARCHAR2 (20);
      l_excl_mup              NUMBER;
      l_inc_mup               NUMBER;
      l_paid_amt              NUMBER;
      l_ser_number            NUMBER;
      ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/05]
      l_lee_number            NUMBER;
      l_pay_date              fid_payment.pay_date%TYPE;
      l_pay_rate              fid_payment.pay_rate%TYPE;
      l_lsl_number            NUMBER;
      l_flag                  NUMBER;
      l_split_region          fid_licensee.lee_split_region%TYPE;
      l_closed_month          NUMBER;
      l_to_date               DATE;
      l_pay_date1             fid_payment.pay_date%TYPE;
      l_month_count           NUMBER;
      l_live_date             DATE;
      l_open_month            DATE;
      l_last_month            DATE;
      ----Dev2: Pure Finance: End------------------------------------
      o_con_pay_amt           NUMBER;
      o_exc_mkup_ent_con      NUMBER;
      o_inc_mkup_ent_con      NUMBER;
	    l_number                NUMBER;
      l_min_subs_flag         varchar2(1);
      l_pay_mgp_number        NUMBER;
   BEGIN
      BEGIN
         ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/05]
         SELECT pay_status, pay_update_count
           INTO l_pay_status, l_pay_update_count
           FROM fid_payment
          WHERE                            --pay_lic_number = i_pay_lic_number
                -- and
                pay_number = i_pay_number;
      ----Dev2: Pure Finance: End------------------------------------
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20426,
               'Pay Number ' || i_pay_number || ' does not found');
      END;

      BEGIN
         SELECT cur_code
           INTO l_curr_code
           FROM fid_currency
          WHERE cur_code = i_pay_cur_code;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20412,
               'Invalid Currency Please Enter Correct Currency');
      END;

      ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/05]
      BEGIN
         SELECT lee_number
           INTO l_lee_number
           FROM fid_licensee
          WHERE lee_short_name = i_licensee;

         SELECT lsl_number
           INTO l_lsl_number
           FROM x_fin_lic_sec_lee
          WHERE lsl_lee_number = l_lee_number
                AND lsl_lic_number = i_pay_lic_number;

         SELECT COUNT (*)
           INTO l_flag
           FROM x_fin_lic_sec_lee
          WHERE lsl_lic_number = i_pay_lic_number
                AND lsl_lee_number = l_lee_number;

         IF l_flag = 0
         THEN
            raise_application_error (
               -20056,
               'Licensee is not valid for primary licensee');
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      ----Dev2: Pure Finance: End------------------------------------
      IF l_pay_status = 'P' AND i_pay_status = 'N'
      THEN
         raise_application_error (
            -20415,
            'Paid Status Cannot Be Edited For License Number '
            || i_pay_lic_number);
      END IF;

      SELECT TO_DATE (content)
        INTO l_live_date
        FROM x_fin_configs
       WHERE KEY = 'GO-LIVEDATE';

      SELECT lee_split_region
        INTO l_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = i_pay_lic_number);

      SELECT TO_DATE (
                TO_CHAR (
                   TO_DATE (
                      TO_CHAR ('01' || LPAD (fim_month, 2, 0) || fim_year),
                      'DD/MM/RRRR'),
                   'DD-MON-RRRR'))
        INTO l_open_month
        FROM fid_financial_month
       WHERE fim_status = 'O'
             AND NVL (fim_split_region, 1) =
                    DECODE (fim_split_region, NULL, 1, l_split_region);

      IF i_pay_date < l_open_month
      THEN
         l_last_month := ADD_MONTHS (l_open_month, -1);

         BEGIN
            SELECT MAX (fmd_to_date)
              INTO l_to_date
              FROM x_fin_month_defn
             WHERE fmd_month =
                      TO_NUMBER (
                         TO_CHAR (TO_DATE (l_last_month, 'DD/MM/RRRR'), 'MM'))
                   AND fmd_year =
                          TO_NUMBER (
                             TO_CHAR (TO_DATE (l_last_month, 'DD/MM/RRRR'),
                                      'RRRR'))
                   AND NVL (fmd_region, 1) =
                          DECODE (fmd_region, NULL, 1, l_split_region)
                   AND UPPER (fmd_mon_end_type) = 'FINAL';

            IF l_to_date IS NULL
            THEN
               l_to_date := LAST_DAY (l_last_month);
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_to_date := LAST_DAY (l_last_month);
         END;

         IF i_pay_date <= l_to_date
         THEN
            raise_application_error (
               -20345,
               'Payment date should be greater than "To Date" of latest closed month for License no-'
               || i_pay_lic_number
               || ', Pay Date-'
               || i_pay_date
               || ', Amount-'
               || i_pay_amount);
         END IF;
      END IF;

      BEGIN
         SELECT pay_date
           INTO l_pay_date1
           FROM fid_payment
          WHERE pay_number = i_pay_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF l_pay_date1 IS NOT NULL
      THEN
         SELECT TO_DATE (
                   TO_CHAR (
                      TO_DATE (
                         TO_CHAR ('01' || LPAD (fim_month, 2, 0) || fim_year),
                         'DD/MM/RRRR'),
                      'DD-MON-RRRR'))
           INTO l_open_month
           FROM fid_financial_month
          WHERE fim_status = 'O'
                AND NVL (fim_split_region, 1) =
                       DECODE (fim_split_region, NULL, 1, l_split_region);

         IF l_pay_date1 < l_open_month
         THEN
            l_last_month := ADD_MONTHS (l_open_month, -1);

            BEGIN
               SELECT MAX (fmd_to_date)
                 INTO l_to_date
                 FROM x_fin_month_defn
                WHERE fmd_month =
                         TO_NUMBER (
                            TO_CHAR (TO_DATE (l_last_month, 'DD/MM/RRRR'),
                                     'MM'))
                      AND fmd_year =
                             TO_NUMBER (
                                TO_CHAR (
                                   TO_DATE (l_last_month, 'DD/MM/RRRR'),
                                   'RRRR'))
                      AND NVL (fmd_region, 1) =
                             DECODE (fmd_region, NULL, 1, l_split_region)
                      AND UPPER (fmd_mon_end_type) = 'FINAL';

               IF l_to_date IS NULL
               THEN
                  l_to_date := LAST_DAY (l_last_month);
               END IF;
            EXCEPTION
               WHEN OTHERS
               THEN
                  l_to_date := LAST_DAY (l_last_month);
            END;

            IF l_pay_date1 < l_to_date
            THEN
               raise_application_error (
                  -20345,
                  'Payment date should be greater than "To Date" of latest closed month for License no-'
                  || i_pay_lic_number
                  || ', Pay Date-'
                  || l_pay_date1
                  || ', Amount-'
                  || i_pay_amount);
            END IF;
         END IF;
      END IF;

      /*       if l_pay_status = 'P' and i_pay_status = 'P'
            then
                    raise_application_error(-20415,'Paid Status Cannot Be Edited For License Number '||I_PAY_LIC_NUMBER);
            end if ;
            */
	  IF i_is_rem_lib_same='Y'
      THEN

			SELECT pkg_cm_username.setusername (i_entry_oper)
			INTO l_number
			FROM DUAL;


            delete from fid_payment
            where pay_lic_number=i_pay_lic_number
            and  pay_status='N'
            AND  pay_number <> i_pay_number
            ;
      END IF;

      IF l_pay_status != 'N'
      THEN
         ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/05]
         --Add to change payment date and spot rate when status is paid.
       --  DBMS_OUTPUT.put_line ('l_pay_status:' || l_pay_status);

         UPDATE fid_payment fp
            SET pay_date = i_pay_date,
                pay_rate = i_pay_rate,
                pay_entry_oper = i_entry_oper,
                pay_entry_date = SYSDATE
          WHERE pay_number = i_pay_number
                AND pay_lic_number = i_pay_lic_number;
      ----Dev2: Pure Finance: End------------------------
      ELSE
         IF l_pay_status = 'N' AND i_pay_status = 'P'
         THEN
            IF i_pay_lic_number IS NOT NULL AND i_gen_title IS NOT NULL
            THEN
               NULL;
            ELSE
               raise_application_error (
                  -20425,
                  'Lic Number and Program Title can not be blank');
            END IF;
         END IF;

		   ----Changes Made By Rashmi  21-09-2015 For Spot Rate Routine
               IF l_pay_status = 'N' AND i_pay_status = 'P'
         THEN
            IF i_pay_lic_number IS NOT NULL
            THEN
               update fid_payment
               set pay_exch_oper = i_entry_oper
                WHERE                            --pay_lic_number = i_pay_lic_number
                pay_number = i_pay_number;
            ELSE
               raise_application_error (
                  -20425,
                  'Entry operator can not be blank');
            END IF;
         END IF;
               ---------Changes Made By Rashmi  21-09-2015 For Spot Rate Routine

         IF i_pay_number IS NULL OR i_pay_con_number IS NULL
         THEN
            NULL;
         ELSE
            IF l_pay_update_count = i_pay_update_count
            THEN
               IF i_pay_cur_code = 'ZAR'
               THEN
                  IF i_pay_status = 'P'
                  THEN
                     l_pay_date := i_pay_date;
                     l_pay_rate := 1;
                  ELSE
                     NULL;
                  END IF;
               ELSE
                  l_pay_date := i_pay_date;
                  l_pay_rate := i_pay_rate;
               END IF;

              -- DBMS_OUTPUT.put_line ('Updating table');

               UPDATE fid_payment fp
                  SET pay_lsl_number = l_lsl_number,
                      pay_code = NVL (i_pay_code, fp.pay_code),
                      pay_cur_code = NVL (i_pay_cur_code, fp.pay_cur_code),
                      pay_amount = NVL (i_pay_amount, fp.pay_amount),
                      pay_status_date = i_pay_status_date-- nvl(to_char(sysdate,'DD-MON-YYYY'), fp.pay_status_date)
                      ,
                      pay_due = NVL (i_pay_due, fp.pay_due)-- nvl(to_char(to_date(I_PAY_DUE),'DD-MON-YYYY') , fp.pay_due)
                      ,
                      pay_reference = i_pay_reference,
                      -----NVL (i_pay_reference, fp.pay_reference),
					  PAY_MNET_REFERENCE = i_pay_mnet_invoice, -- #region Abhinay_5Aug14 : ADDITIONAL FIELD ON THE PAYMENTS SCREEN
                      pay_comment = i_pay_comment,
                      ---NVL (i_pay_comment, fp.pay_comment),
                      pay_lic_number =
                         NVL (i_pay_lic_number, fp.pay_lic_number),
                      pay_status = NVL (i_pay_status, fp.pay_status),
                      ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/02/05]
                      pay_date = l_pay_date,
                      pay_rate = l_pay_rate,
                      ----Dev2: Pure Finance: End------------------------
                      pay_entry_oper = NVL (i_entry_oper, fp.pay_entry_oper),
                      pay_entry_date = SYSDATE,
                      pay_update_count = i_pay_update_count + 1
                WHERE pay_number = i_pay_number;
            -- AND pay_lic_number = i_pay_lic_number;

                  --BR_15_144:Warner Payment :Rashmi Tijare :30-07-2015 :Start
                     select NVL(LIC_MIN_SUBS_FLAG,'N')
                      INTO l_min_subs_flag
                     from fid_license
                     where lic_number = i_pay_lic_number;

                    IF l_min_subs_flag = 'Y'
                    THEN
                              For i in (select distinct PAY_MGP_NUMBER
                                            --INTO l_pay_mgp_number
                                            from fid_payment
                                           where pay_lic_number = i_pay_lic_number
                                          and pay_due = i_pay_due)
                          LOOP


                                UPDATE x_fin_mg_pay_plan
                                SET mgp_is_paid = 'Y'
                                WHERE mgp_number = i.PAY_MGP_NUMBER;
                          END LOOP;
                          commit;
                    END IF;

                  For i in (select distinct pay_lpy_number
                             from fid_payment
                             where pay_lic_number = i_pay_lic_number
                             and pay_due = i_pay_due)
                  LOOP

                     update fid_license_payment_months
                     set lpy_paid_actual = 'Y'
                     where lpy_number = i.pay_lpy_number ;
                  END lOOP;
                      --*BR_15_144:Warner Payment :Rashmi Tijare :30-07-2015 :End
            ELSE
               raise_application_error (
                  -20416,
                  'The Record was Updated by Some Other User. Please retrive the modified record and Update');

               OPEN o_pay_dtls FOR
                  SELECT *
                    FROM fid_payment fp
                   WHERE pay_number = i_pay_number
                         AND pay_lic_number = i_pay_lic_number;
            END IF;
         END IF;
      END IF;
   END;

   PROCEDURE prc_delete_payment (
      i_pay_lic_number          fid_payment.pay_lic_number%TYPE,
      --changed by hari as per batch payment fin req.
      i_pay_number              fid_payment.pay_number%TYPE,
      i_entry_oper       IN     fid_payment.pay_entry_oper%TYPE,
      o_success             OUT NUMBER)
   AS
      l_pay_status        fid_payment.pay_status%TYPE;
      l_number            NUMBER;
      l_lic_type          fid_license.lic_type%TYPE;
      l_not_paid          NUMBER;
      l_pay_split_id      NUMBER;
      l_orginal_payment   NUMBER;
      l_pay_lpy_number    NUMBER;
   BEGIN
      o_success := 1;

      SELECT pay_status
        INTO l_pay_status
        FROM fid_payment
       WHERE pay_lic_number = i_pay_lic_number AND pay_number = i_pay_number;

      SELECT lic_type
        INTO l_lic_type
        FROM fid_license
       WHERE lic_number = i_pay_lic_number;

      IF l_pay_status = 'P'
      THEN
         NULL;
         o_success := -1;
      ELSE
         IF UPPER (l_lic_type) = 'FLF'
         THEN
            SELECT pkg_cm_username.setusername (i_entry_oper)
              INTO l_number
              FROM DUAL;

            DELETE FROM fid_payment
                  WHERE     pay_lic_number = i_pay_lic_number
                        AND pay_status <> 'P'
                        AND pay_number = i_pay_number;
         ELSE
            BEGIN
               SELECT pay_split_id
                 INTO l_pay_split_id
                 FROM fid_payment
                WHERE pay_number = i_pay_number;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_pay_split_id := NULL;
            END;

            BEGIN
               SELECT pay_lpy_number
                 INTO l_pay_lpy_number
                 FROM fid_payment
                WHERE pay_number = i_pay_number;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_pay_lpy_number := NULL;
            END;

            IF l_pay_split_id IS NOT NULL AND l_pay_lpy_number IS NOT NULL
            THEN
               SELECT pay_number
                 INTO l_orginal_payment
                 FROM fid_payment
                WHERE pay_split_id = l_pay_split_id
                      AND pay_calc_year || LPAD (pay_calc_month, 2, 0) =
                             (SELECT MIN (
                                        pay_calc_year
                                        || LPAD (pay_calc_month, 2, 0))
                                FROM fid_payment
                               WHERE pay_split_id = l_pay_split_id);

               IF l_orginal_payment = i_pay_number
               THEN
                  raise_application_error (
                     -20789,
                     'Payments for ROY license are system created, hence cannot be deleted.');
               ELSE
                  SELECT pkg_cm_username.setusername (i_entry_oper)
                    INTO l_number
                    FROM DUAL;

                  DELETE FROM fid_payment
                        WHERE     pay_lic_number = i_pay_lic_number
                              AND pay_status <> 'P'
                              AND pay_number = i_pay_number;
               END IF;
            ELSIF l_pay_split_id IS NULL AND l_pay_lpy_number IS NOT NULL
            THEN
               SELECT pay_number
                 INTO l_orginal_payment
                 FROM fid_payment
                WHERE pay_lpy_number = l_pay_lpy_number
                      AND pay_calc_year || LPAD (pay_calc_month, 2, 0) =
                             (SELECT MIN (
                                        pay_calc_year
                                        || LPAD (pay_calc_month, 2, 0))
                                FROM fid_payment
                               WHERE pay_lpy_number = l_pay_lpy_number);

               IF l_orginal_payment = i_pay_number
               THEN
                  raise_application_error (
                     -20789,
                     'Payments for ROY license are system created, hence cannot be deleted.');
               ELSE
                  SELECT pkg_cm_username.setusername (i_entry_oper)
                    INTO l_number
                    FROM DUAL;

                  DELETE FROM fid_payment
                        WHERE     pay_lic_number = i_pay_lic_number
                              AND pay_status <> 'P'
                              AND pay_number = i_pay_number;
               END IF;
            ELSE
               SELECT pkg_cm_username.setusername (i_entry_oper)
                 INTO l_number
                 FROM DUAL;

               DELETE FROM fid_payment
                     WHERE     pay_lic_number = i_pay_lic_number
                           AND pay_status <> 'P'
                           AND pay_number = i_pay_number;
            END IF;
         END IF;
      END IF;
   END;

   PROCEDURE prc_split_pay_default (
      i_pay_number       fid_payment.pay_number%TYPE,
      o_pay_dtls     OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
   BEGIN
      OPEN o_pay_dtls FOR
         SELECT pay_status,
                pay_status_date,
                pay_due,
                pay_code,
                pay_cur_code,
                pay_amount
           FROM fid_payment
          WHERE pay_number = i_pay_number;
   END;

   PROCEDURE prc_split_payment (
      i_pay_number       fid_payment.pay_number%TYPE,
      i_amount           fid_payment.pay_amount%TYPE,
      o_success      OUT NUMBER)
   AS
      l_pay_status   fid_payment.pay_status%TYPE;
   BEGIN
      BEGIN
         INSERT INTO fid_payment (pay_number,
                                  pay_amount,
                                  pay_source_com_number,
                                  pay_target_com_number,
                                  pay_con_number,
                                  pay_lic_number,
                                  pay_status,
                                  pay_status_date,
                                  pay_cur_code,
                                  pay_rate,
                                  pay_code,
                                  pay_due,
                                  pay_reference,
                                  pay_comment,
                                  pay_supplier_invoice,
                                  pay_entry_date,
                                  pay_entry_oper)
            SELECT seq_pay_number.NEXTVAL,
                   i_amount,
                   pay_source_com_number,
                   pay_target_com_number,
                   pay_con_number,
                   pay_lic_number,
                   pay_status,
                   pay_status_date,
                   pay_cur_code,
                   pay_rate,
                   pay_code,
                   pay_due,
                   pay_reference,
                   pay_comment,
                   pay_supplier_invoice,
                   pay_entry_date,
                   pay_entry_oper
              FROM fid_payment
             WHERE pay_number = i_pay_number;

         o_success := 1;
      EXCEPTION
         WHEN OTHERS
         THEN
            o_success := -1;
            raise_application_error (-20427, SQLERRM);
      END;
   END prc_split_payment;

   PROCEDURE prc_lic_prgm_details (
      i_gen_title   IN     VARCHAR2,
      o_con_dtls       OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
   BEGIN
      OPEN o_con_dtls FOR
         SELECT gen_title,
                lic_number,
                con_short_name,
                lee_short_name,
                chs_short_name,
                con_start_date,
                con_end_date,
                lic_status
           FROM fid_license_vw, fid_channel_service
          WHERE gen_title = i_gen_title AND lic_chs_number = chs_number(+);
   END;

   ----------Dev2 :Pure Finance: Start:[Hari Mandal]_[2013/03/05]
   PROCEDURE x_prc_get_mcgregor_rate (
      i_pay_number   IN     fid_payment.pay_number%TYPE,
      i_pay_date     IN     fid_payment.pay_date%TYPE,
      o_spot_rate       OUT NUMBER)
   AS
      l_pay_cur_code         fid_payment.pay_cur_code%TYPE;
      l_pay_lic_number       fid_payment.pay_lic_number%TYPE;
      l_pay_amount           fid_payment.pay_amount%TYPE;
      l_local_currency       fid_territory.ter_cur_code%TYPE;
      l_split_region         fid_licensee.lee_split_region%TYPE;
      l_closed_month_count   NUMBER;
      l_month_count          NUMBER;
   BEGIN
      SELECT pay_lic_number, pay_cur_code, pay_amount
        INTO l_pay_lic_number, l_pay_cur_code, l_pay_amount
        FROM fid_payment
       WHERE pay_number = i_pay_number;

      SELECT COUNT (*)
        INTO l_month_count
        FROM fid_financial_month
       WHERE i_pay_date BETWEEN TO_DATE (fim_year || fim_month, 'RRRRMM')
                            AND LAST_DAY (
                                   TO_DATE (fim_year || fim_month, 'RRRRMM'));

      IF l_month_count = 1
      THEN
         SELECT COUNT (*)
           INTO l_closed_month_count
           FROM fid_financial_month
          WHERE fim_status = 'C'
                AND i_pay_date BETWEEN TO_DATE (fim_year || fim_month,
                                                'RRRRMM')
                                   AND LAST_DAY (
                                          TO_DATE (fim_year || fim_month,
                                                   'RRRRMM'));
      ELSIF l_month_count = 2
      THEN
         SELECT lee_split_region
           INTO l_split_region
           FROM fid_licensee
          WHERE lee_number IN (SELECT lic_lee_number
                                 FROM fid_license
                                WHERE lic_number = l_pay_lic_number);

         SELECT COUNT (*)
           INTO l_closed_month_count
           FROM fid_financial_month
          WHERE fim_status = 'C'
                AND i_pay_date BETWEEN TO_DATE (fim_year || fim_month,
                                                'RRRRMM')
                                   AND LAST_DAY (
                                          TO_DATE (fim_year || fim_month,
                                                   'RRRRMM'))
                AND fim_split_region = l_split_region;
      END IF;

  --    DBMS_OUTPUT.put_line ('l_split_region:' || l_split_region);
  --    DBMS_OUTPUT.put_line ('i_pay_date:' || i_pay_date);
  --    DBMS_OUTPUT.put_line ('l_pay_lic_number:' || l_pay_lic_number);
  --    DBMS_OUTPUT.put_line ('l_closed_month_count:' || l_closed_month_count);

      IF l_closed_month_count > 0
      THEN
         raise_application_error (
            -20337,
               'Cannot update the Spot Rate as payment date for License no-'
            || l_pay_lic_number
            || ',Pay Date-'
            || i_pay_date
            || ',Amount-'
            || l_pay_amount
            || ' is in closed financial month.');
      END IF;

      SELECT ter_cur_code
        INTO l_local_currency
        FROM fid_territory ft,
             fid_company fc,
             fid_licensee fl,
             fid_license fle
       WHERE     ft.ter_code = fc.com_ter_code
             AND fc.com_number = fl.lee_cha_com_number
             AND fl.lee_number = fle.lic_lee_number
             AND fle.lic_number = l_pay_lic_number;

      /*SELECT count(1) into l_count FROM tbl_tvf_holidays WHERE thol_holiday_date = l_pay_date;
      dbms_output.put_line ('l_count:'||l_count);
      while l_count > 0
      loop
      l_pay_date := l_pay_date - 1;
      SELECT COUNT (1) into l_count FROM tbl_tvf_holidays WHERE thol_holiday_date = l_pay_date;
      end loop ;
      exception
      when no_data_found then
      l_pay_date := i_pay_date ;
      end;
      select spo_n_rate into l_spot_rate from tbl_tvf_spot_rate where spo_n_per_day = to_number(to_char(to_date(i_pay_date,'DD-MM-RRRR'),'DD')) and
      spo_n_per_month = to_number(to_char(to_date(i_pay_date,'DD-MM-RRRR'),'MM')) and
      spo_n_per_year = to_number(to_char(to_date(i_pay_date,'DD-MM-RRRR'),'RRRR')) ;*/
      o_spot_rate :=
         x_pkg_fin_get_spot_rate.get_spot_rate (l_pay_cur_code,
                                                l_local_currency,
                                                i_pay_date);
    --  DBMS_OUTPUT.put_line ('o_spot_rate:' || o_spot_rate);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         o_spot_rate := NULL;
      WHEN OTHERS
      THEN
         raise_application_error (-20067, SUBSTR (SQLERRM, 1, 200));
   END x_prc_get_mcgregor_rate;

   FUNCTION local_currency (i_lic_number fid_license.lic_number%TYPE)
      RETURN VARCHAR2
   AS
      l_local_currency   VARCHAR2 (3);
   BEGIN
      SELECT ter_cur_code
        INTO l_local_currency
        FROM fid_territory,
             fid_company,
             fid_licensee,
             fid_license
       WHERE     ter_code = com_ter_code
             AND com_number = lee_cha_com_number
             AND lee_number = lic_lee_number
             AND lic_number = i_lic_number;

      RETURN l_local_currency;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_local_currency := NULL;
         RETURN l_local_currency;
      WHEN OTHERS
      THEN
         l_local_currency := NULL;
         RETURN l_local_currency;
   END;

   PROCEDURE x_prc_licenseelov (
      i_lic_number       IN     fid_license.lic_number%TYPE,
      o_lee_short_name      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
   BEGIN
      OPEN o_lee_short_name FOR
         SELECT lee_number,
                lee_name,
                lee_short_name,
                lee_cha_com_number
           FROM fid_licensee
          WHERE lee_number IN
                   (SELECT lsl_lee_number
                      FROM x_fin_lic_sec_lee
                     WHERE lsl_lic_number LIKE
                              DECODE (i_lic_number, NULL, '%', i_lic_number));
   END x_prc_licenseelov;

   PROCEDURE x_prc_copy_pay_attr_search (
      i_program_title         IN     fid_license_vw.gen_title%TYPE,
      i_lic_no                IN     fid_license_vw.lic_number%TYPE,
      i_con_short_name        IN     fid_license_vw.con_short_name%TYPE,
      i_deal_memo             IN     fid_license_vw.lic_mem_number%TYPE,
      i_start_date            IN     fid_license_vw.lic_start%TYPE,
      i_end_date              IN     fid_license_vw.lic_end%TYPE,
      i_type                  IN     fid_license_vw.lic_type%TYPE,
      i_licensee              IN     fid_license_vw.lee_short_name%TYPE,
      i_status                IN     fid_license_vw.lic_status%TYPE,
      i_sup_short_name        IN     fid_company.com_short_name%TYPE,
      i_pay_date_from         IN     DATE,
      i_pay_date_to           IN     DATE,
      i_pay_date_not_avail    IN     VARCHAR2,
      i_due_date_from         IN     DATE,
      i_due_date_to           IN     DATE,
      i_pay_status            IN     VARCHAR2,
      i_spot_rate_from        IN     NUMBER,
      i_spot_rate_to          IN     NUMBER,
      i_spot_rate_not_avail   IN     VARCHAR2,
      i_post_date_from        IN     DATE,
      i_post_date_to          IN     DATE,
      o_cpy_pay_dtls             OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
      l_qry_string   VARCHAR2 (4000);
   BEGIN
      l_qry_string :=
         'select PAY_NUMBER
        ,(select lee_short_name from fid_licensee where lee_number=lic_lee_number)licensee
        ,    PAY_SOURCE_COM_NUMBER
        ,    PAY_TARGET_COM_NUMBER
        ,    PAY_CON_NUMBER
        ,    PAY_LIC_NUMBER
        ,    PAY_STATUS
        ,    PAY_STATUS_DATE
        ,    trunc(PAY_AMOUNT,4) PAY_AMOUNT
        ,    PAY_CUR_CODE
        ,    PAY_DATE
        ,    PAY_RATE
        ,    PAY_CODE
        ,    PAY_DUE
        ,    PAY_REFERENCE
        ,    PAY_COMMENT
        ,    PAY_SUPPLIER_INVOICE
        ,    PAY_ENTRY_DATE
        ,    PAY_ENTRY_OPER
        ,    pay_update_count
        ,    PAY_MARKUP_PERCENT
        ,    PAY_FCD_NUMBER
        ,    fg.GEN_TITLE
        ,    flv.LIC_NUMBER
        ,    fg.GEN_REFNO
        ,    fg.gen_ser_number
        from fid_payment fp
        ,    fid_license_vw  flv
        ,    fid_general fg
        ,    fid_company fc
      where  flv.lic_number = fp.PAY_LIC_NUMBER
        and  flv.lic_gen_refno = fg.gen_refno
        and  flv.con_com_number=fc.com_number
        and  flv.LIC_STATUS NOT IN (''I'',''C'') -- FINACE DEV PHASE I [ANKUR KASAR]
        and  upper(fp.pay_code) <> ''T'' ';

      IF i_program_title IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fg.gen_title like upper('''
            || i_program_title
            || ''')';
      END IF;

      IF i_lic_no IS NOT NULL
      THEN
         l_qry_string := l_qry_string || ' and flv.LIC_NUMBER =' || i_lic_no;
      END IF;

      IF i_con_short_name IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and flv.CON_SHORT_NAME like '''
            || i_con_short_name
            || '''';
      END IF;

      IF i_deal_memo IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and flv.LIC_MEM_NUMBER =' || i_deal_memo;
      END IF;

      IF i_start_date IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and flv.LIC_START =to_date('''
            || i_start_date
            || ''')';
      END IF;

      IF i_end_date IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and flv.LIC_END =to_date('''
            || i_end_date
            || ''')';
      END IF;

      IF i_type IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and flv.LIC_TYPE like ''' || i_type || '''';
      END IF;

      IF i_licensee IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and flv.LEE_SHORT_NAME like '''
            || i_licensee
            || '''';
      END IF;

      IF i_status IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and flv.LIC_STATUS like ''' || i_status || '''';
      END IF;

      IF i_sup_short_name IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fc.COM_SHORT_NAME like '''
            || i_sup_short_name
            || '''';
      END IF;

      IF i_pay_date_from IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_DATE >= to_date('''
            || i_pay_date_from
            || ''')';
      END IF;

      IF i_pay_date_to IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_DATE <= to_date('''
            || i_pay_date_to
            || ''')';
      END IF;

      IF i_pay_date_not_avail = 'Y'
      THEN
         l_qry_string := l_qry_string || ' and fp.PAY_DATE is null';
      END IF;

      IF i_due_date_from IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_DUE >= to_date('''
            || i_due_date_from
            || ''')';
      END IF;

      IF i_due_date_to IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_DUE <= to_date('''
            || i_due_date_to
            || ''')';
      END IF;

      IF i_pay_status IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_STATUS like '''
            || i_pay_status
            || '''';
      END IF;

      IF i_spot_rate_from IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and fp.PAY_RATE >= ' || i_spot_rate_from;
      END IF;

      IF i_spot_rate_to IS NOT NULL
      THEN
         l_qry_string :=
            l_qry_string || ' and fp.PAY_RATE <= ' || i_spot_rate_to;
      END IF;

      IF i_spot_rate_not_avail = 'Y'
      THEN
         l_qry_string :=
            l_qry_string
            || ' and fp.pay_status=''P'' and fp.pay_rate is null ';
      END IF;

      IF i_post_date_from IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_STATUS_DATE >= to_date('''
            || i_post_date_from
            || ''')';
      END IF;

      IF i_post_date_to IS NOT NULL
      THEN
         l_qry_string :=
               l_qry_string
            || ' and fp.PAY_STATUS_DATE <= to_date('''
            || i_post_date_to
            || ''')';
      END IF;

      l_qry_string := l_qry_string || '  and rownum <=500 ';
      l_qry_string := l_qry_string || ' order by gen_title ';
      
      --DBMS_OUTPUT.PUT_LINE(l_qry_string);

      OPEN o_cpy_pay_dtls FOR l_qry_string;
   END x_prc_copy_pay_attr_search;

   PROCEDURE x_prc_cpy_pay_attribute (
      i_pay_number         IN     fid_payment.pay_number%TYPE,
      i_status             IN     fid_payment.pay_status%TYPE,
      i_pay_date           IN     fid_payment.pay_date%TYPE,
      i_spot_rate          IN     fid_payment.pay_rate%TYPE,
      i_pay_update_count   IN     fid_payment.pay_update_count%TYPE,
      o_pay_dtls              OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
      l_pay_update_count   NUMBER;
      l_pay_status         fid_payment.pay_status%TYPE;
      l_pay_status_date    fid_payment.pay_status_date%TYPE;
      l_pay_lic_number     fid_payment.pay_lic_number%TYPE;
      l_split_region       fid_licensee.lee_split_region%TYPE;
      l_open_month         DATE;
      l_last_month         DATE;
      l_to_date            DATE;
      l_pay_date1          DATE;
   BEGIN
      BEGIN
         SELECT pay_update_count,
                pay_status,
                pay_status_date,
                pay_lic_number
           INTO l_pay_update_count,
                l_pay_status,
                l_pay_status_date,
                l_pay_lic_number
           FROM fid_payment
          WHERE pay_number = i_pay_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20426,
               'Pay Number ' || i_pay_number || ' does not found');
      END;

      SELECT lee_split_region
        INTO l_split_region
        FROM fid_licensee
       WHERE lee_number IN (SELECT lic_lee_number
                              FROM fid_license
                             WHERE lic_number = l_pay_lic_number);

      SELECT TO_DATE (
                TO_CHAR (
                   TO_DATE (
                      TO_CHAR ('01' || LPAD (fim_month, 2, 0) || fim_year),
                      'DD/MM/RRRR'),
                   'DD-MON-RRRR'))
        INTO l_open_month
        FROM fid_financial_month
       WHERE fim_status = 'O'
             AND NVL (fim_split_region, 1) =
                    DECODE (fim_split_region, NULL, 1, l_split_region);

      IF i_pay_date < l_open_month
      THEN
         l_last_month := ADD_MONTHS (l_open_month, -1);

         BEGIN
            SELECT MAX (fmd_to_date)
              INTO l_to_date
              FROM x_fin_month_defn
             WHERE fmd_month =
                      TO_NUMBER (
                         TO_CHAR (TO_DATE (l_last_month, 'DD/MM/RRRR'), 'MM'))
                   AND fmd_year =
                          TO_NUMBER (
                             TO_CHAR (TO_DATE (l_last_month, 'DD/MM/RRRR'),
                                      'RRRR'))
                   AND NVL (fmd_region, 1) =
                          DECODE (fmd_region, NULL, 1, l_split_region)
                   AND UPPER (fmd_mon_end_type) = 'FINAL';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               l_to_date := LAST_DAY (l_last_month);
         END;

         IF i_pay_date < l_to_date
         THEN
            raise_application_error (
               -20345,
               'Payment date should be greater than "To Date" of latest closed month for License no-'
               || l_pay_lic_number
               || ' ,pay_number-'
               || i_pay_number
               || ', Pay Date-'
               || i_pay_date);
         END IF;
      END IF;

      BEGIN
         SELECT pay_date
           INTO l_pay_date1
           FROM fid_payment
          WHERE pay_number = i_pay_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF l_pay_date1 IS NOT NULL
      THEN
         SELECT TO_DATE (
                   TO_CHAR (
                      TO_DATE (
                         TO_CHAR ('01' || LPAD (fim_month, 2, 0) || fim_year),
                         'DD/MM/RRRR'),
                      'DD-MON-RRRR'))
           INTO l_open_month
           FROM fid_financial_month
          WHERE fim_status = 'O'
                AND NVL (fim_split_region, 1) =
                       DECODE (fim_split_region, NULL, 1, l_split_region);

         IF l_pay_date1 < l_open_month
         THEN
            l_last_month := ADD_MONTHS (l_open_month, -1);

            BEGIN
               SELECT MAX (fmd_to_date)
                 INTO l_to_date
                 FROM x_fin_month_defn
                WHERE fmd_month =
                         TO_NUMBER (
                            TO_CHAR (TO_DATE (l_last_month, 'DD/MM/RRRR'),
                                     'MM'))
                      AND fmd_year =
                             TO_NUMBER (
                                TO_CHAR (
                                   TO_DATE (l_last_month, 'DD/MM/RRRR'),
                                   'RRRR'))
                      AND NVL (fmd_region, 1) =
                             DECODE (fmd_region, NULL, 1, l_split_region)
                      AND UPPER (fmd_mon_end_type) = 'FINAL';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  l_to_date := LAST_DAY (l_last_month);
            END;

            IF l_pay_date1 <= l_to_date
            THEN
               raise_application_error (
                  -20345,
                  'Payment date should be greater than "To Date" of latest closed month for License no-'
                  || l_pay_lic_number
                  || ' ,pay_number-'
                  || i_pay_number
                  || ', Pay Date-'
                  || l_pay_date1);
            END IF;
         END IF;
      END IF;

      IF l_pay_update_count = i_pay_update_count
      THEN
         UPDATE fid_payment fp
            SET pay_status = i_status,
                pay_date = i_pay_date,
                pay_rate = i_spot_rate,
                pay_entry_date = SYSDATE,
                pay_status_date =
                   DECODE (i_status,
                           l_pay_status, l_pay_status_date,
                           TRUNC (SYSDATE)),
                pay_update_count = i_pay_update_count + 1
          WHERE pay_number = i_pay_number;

         COMMIT;
      ELSE
         --raise_application_error
         --                (-20416,
         --               'The Record was Updated by Some Other User. Please retrive the modified record and Update'
         --            );
         OPEN o_pay_dtls FOR
            SELECT pay_number,
                   pay_con_number,
                   pay_code,
                   pay_cur_code,
                   pay_amount,
                   pay_status,
                   pay_status_date,
                   pay_due,
                   pay_reference,
                   pay_comment,
                   fg.gen_title,
                   pay_lic_number,
                   (SELECT lee_short_name
                      FROM fid_licensee
                     WHERE lee_number = lic_lee_number)
                      licensee,
                   pay_rate,
                   pay_date,
                   pay_update_count,
                   PKG_FIN_MNET_PAY_QRY_MNT.local_currency (flv.lic_number)
                      loc_cur_code,
                   fg.gen_title gen_title,
                   flv.lic_number lic_number
              FROM fid_payment fp,
                   fid_license_vw flv,
                   fid_general fg,
                   fid_company fc
             WHERE     flv.lic_number = fp.pay_lic_number
                   AND flv.lic_gen_refno = fg.gen_refno
                   AND flv.con_com_number = fc.com_number
                   AND pay_number = i_pay_number;
      END IF;
   END x_prc_cpy_pay_attribute;

   PROCEDURE x_prc_transfer_payment_search (
      i_program_title    IN     fid_license_vw.gen_title%TYPE,
      i_lic_no           IN     fid_license_vw.lic_number%TYPE,
      i_con_short_name   IN     fid_license_vw.con_short_name%TYPE,
      i_deal_memo        IN     fid_license_vw.lic_mem_number%TYPE,
      i_start_date       IN     fid_license_vw.lic_start%TYPE,
      i_end_date         IN     fid_license_vw.lic_end%TYPE,
      i_type             IN     fid_license_vw.lic_type%TYPE,
      i_licensee         IN     fid_license_vw.lee_short_name%TYPE,
      i_status           IN     fid_license_vw.lic_status%TYPE,
      i_chs_name         IN     fid_channel_service.chs_name%TYPE,
      o_transfer_pay        OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
      l_qry_string   VARCHAR2 (5000);
      l_flag         NUMBER;
      l_chs_number   fid_channel_service.chs_number%TYPE;
   BEGIN
      --l_flag := 0;
      l_qry_string :=
         'select gen_title
      ,PAY_NUMBER
      ,PAY_CON_NUMBER
      ,PAY_CUR_CODE
      ,PAY_CODE
      ,round(pay_amount,2) pay_amount
      ,PAY_STATUS
      ,PAY_STATUS_DATE
      ,PAY_DUE
      ,PAY_RATE
      ,PAY_DATE
      ,PAY_REFERENCE
      ,PAY_COMMENT
      ,PAY_UPDATE_COUNT
      ,gen_refno
      ,lic_number
      ,con_short_name
      ,lic_mem_number
      ,lic_start
      ,lic_end
      ,lic_type
      ,/*lee_short_name*/ (select lee_short_name from fid_licensee where lee_number in(select lsl_lee_number from x_fin_lic_sec_lee where lsl_number= pay_lsl_number)) licensee
      ,lic_status
      ,con_calc_type
      ,round(PKG_FIN_MNET_PAY_QRY_MNT.x_prc_remaining_liab_amt(lic_number),2) remaining_liab
      ,( select chs_name  from fid_channel_service where chs_number = lic_chs_number)chs_name
       from fid_license_vw,
            fid_payment 
       where lic_number=pay_lic_number and con_number=pay_con_number
         AND upper(pay_status)=''N''
         --AND LIC_STATUS <> ''I''         --Fin Dev Phase I Added by Ankur
         AND NVL(round(PKG_FIN_MNET_PAY_QRY_MNT.x_prc_remaining_liab_amt(lic_number),2),0) > 0';

      IF i_program_title IS NOT NULL
      THEN
         /*IF l_flag = 0
           THEN
             l_qry_string :=
                l_qry_string
             || ' where upper(gen_title) like upper('''
             || i_program_title
             ||''')';
          l_flag := 1;
         ELSE*/
         l_qry_string :=
               l_qry_string
            || ' and upper(gen_title) like upper('''
            || i_program_title
            || ''')';
      --  l_flag := 1;
      --   END IF;
      END IF;

      IF i_lic_no IS NOT NULL
      THEN
         /*IF l_flag = 0
         THEN
            l_qry_string := l_qry_string || ' where LIC_NUMBER =' || i_lic_no;
            l_flag := 1;
         ELSE*/
         l_qry_string := l_qry_string || ' and LIC_NUMBER =' || i_lic_no;
      --  l_flag := 1;
      --  END IF;
      END IF;

      IF i_con_short_name IS NOT NULL
      THEN
         /*IF l_flag = 0
         THEN
            l_qry_string :=
                  l_qry_string
               || ' where CON_SHORT_NAME like '''
               || i_con_short_name
               || '''';
            l_flag := 1;
         ELSE*/
         l_qry_string :=
               l_qry_string
            || ' and CON_SHORT_NAME like '''
            || i_con_short_name
            || '''';
      --   l_flag := 1;
      --  END IF;
      END IF;

      IF i_deal_memo IS NOT NULL
      THEN
         /*IF l_flag = 0
         THEN
            l_qry_string :=
                     l_qry_string || ' where LIC_MEM_NUMBER =' || i_deal_memo;
            l_flag := 1;
         ELSE*/
         l_qry_string :=
            l_qry_string || ' and LIC_MEM_NUMBER =' || i_deal_memo;
      --  l_flag := 1;
      --   END IF;
      END IF;

      IF i_start_date IS NOT NULL
      THEN
         /*IF l_flag = 0
         THEN
            l_qry_string :=
                  l_qry_string
               || ' where LIC_START =to_date('''
               || i_start_date
               || ''')';
            l_flag := 1;
         ELSE*/
         l_qry_string :=
               l_qry_string
            || ' and LIC_START =to_date('''
            || i_start_date
            || ''')';
      --  l_flag := 1;
      -- END IF;
      END IF;

      IF i_end_date IS NOT NULL
      THEN
         /*IF l_flag = 0
         THEN
            l_qry_string :=
                  l_qry_string
               || ' where LIC_END =to_date('''
               || i_end_date
               || ''')';
            l_flag := 1;
         ELSE*/
         l_qry_string :=
            l_qry_string || ' and LIC_END =to_date(''' || i_end_date || ''')';
      -- l_flag := 1;
      -- END IF;
      END IF;

      IF i_type IS NOT NULL
      THEN
         /*IF l_flag = 0
         THEN
            l_qry_string :=
                  l_qry_string || ' where LIC_TYPE like ''' || i_type || '''';
            l_flag := 1;
         ELSE*/
         l_qry_string :=
            l_qry_string || ' and LIC_TYPE like ''' || i_type || '''';
      -- l_flag := 1;
      -- END IF;
      END IF;

      IF i_licensee IS NOT NULL
      THEN
         /*IF l_flag = 0
         THEN
            l_qry_string :=
                  l_qry_string
               || ' where LEE_SHORT_NAME like '''
               || i_licensee
               || '''';
            l_flag := 1;
         ELSE*/
         l_qry_string :=
               l_qry_string
            || ' and LEE_SHORT_NAME like '''
            || i_licensee
            || '''';
      --   l_flag := 1;
      --    END IF;
      END IF;

      IF i_status IS NOT NULL
      THEN
         /*IF l_flag = 0
          THEN
             l_qry_string :=
                l_qry_string || ' where LIC_STATUS like ''' || i_status
                || '''';
             l_flag := 1;
          ELSE*/
         l_qry_string :=
            l_qry_string || ' and LIC_STATUS like ''' || i_status || '''';
      --  l_flag := 1;
      --  END IF;
      END IF;

      IF i_chs_name IS NOT NULL
      THEN
         SELECT chs_number
           INTO l_chs_number
           FROM fid_channel_service
          WHERE chs_name = i_chs_name;

         /*IF l_flag = 0
           THEN
           l_qry_string :=
                l_qry_string || ' where lic_chs_number = ' || l_chs_number ;
             l_flag := 1;

         ELSE*/
         l_qry_string :=
            l_qry_string || ' and lic_chs_number = ' || l_chs_number;
      -- l_flag := 1;
      --  END IF;
      END IF;

      l_qry_string :=
         l_qry_string
         || ' and round(PKG_FIN_MNET_PAY_QRY_MNT.x_prc_remaining_liab_amt(lic_number),2) > 0 and rownum <=500';
      -- l_qry_string := l_qry_string || ' order by  gen_title ';
      l_qry_string := l_qry_string || ' order by pay_due,pay_lic_number ';

    --DBMS_OUTPUT.PUT_LINE(l_qry_string);
      OPEN o_transfer_pay FOR l_qry_string;
   END x_prc_transfer_payment_search;

   PROCEDURE x_prc_add_transfer_payment (
      i_pay_lic_num         IN     NUMBER,
      i_pay_number          IN     fid_payment.pay_number%TYPE,
      i_pay_amount          IN     VARCHAR2,
      i_pay_source_number   IN     fid_payment.pay_source_number%TYPE,
      i_entry_oper          IN     fid_payment.pay_entry_oper%TYPE,
      i_pay_comment         IN     fid_payment.pay_comment%TYPE,
      i_pay_due             IN     fid_payment.pay_due%TYPE,
      i_pay_status          IN     fid_payment.pay_status%TYPE,--Finace Dev Phase 1[Ankur Kasar]
      o_success             OUT NUMBER)
   AS
      l_pay_number              fid_payment.pay_number%TYPE;
      l_pay_source_com_number   fid_payment.pay_source_com_number%TYPE;
      l_pay_target_com_number   fid_payment.pay_target_com_number%TYPE;
      l_pay_code                fid_payment.pay_code%TYPE;
      l_pay_con_number          fid_payment.pay_con_number%TYPE;
      l_pay_lic_number          fid_payment.pay_lic_number%TYPE;
      l_pay_cur_code            fid_payment.pay_cur_code%TYPE;
      l_pay_reference           fid_payment.pay_reference%TYPE;
      l_pay_due                 fid_payment.pay_due%TYPE;
      l_pay_entry_oper          fid_payment.pay_entry_oper%TYPE;
      l_pay_entry_date          fid_payment.pay_entry_date%TYPE;
      l_pay_rate                fid_payment.pay_rate%TYPE;
      l_pay_lsl_number          fid_payment.pay_lsl_number%TYPE;
      l_pay_status_date         fid_payment.pay_status_date%TYPE;
      l_pay_amount              fid_payment.pay_amount%TYPE;
      l_number                  NUMBER;
      l_refund_payment_count    NUMBER := 0;
      l_rem_not_paid_pay        NUMBER;
      l_new_pay_number          NUMBER;
      l_dest_pay_amount         NUMBER;
   BEGIN
      o_success := -1;
      /*
      BEGIN
         SELECT pay_lic_number
           INTO l_pay_lic_number
           FROM fid_payment
          WHERE pay_number = i_pay_number;
      EXCEPTION
         WHEN OTHERS
         THEN
            raise_application_error (-20010,
                                        'i_pay_number - '
                                     || i_pay_number
                                     || ', '
                                     || SQLERRM
                                    );
      END;
      */
      l_pay_lic_number := i_pay_lic_num;
      l_pay_amount := ROUND (i_pay_amount, 2);

      IF TO_NUMBER (l_pay_amount) < 0
      THEN
       --  DBMS_OUTPUT.put_line ('source lic nuumber' || l_pay_lic_number);

         BEGIN
            SELECT pay_source_com_number,
                   pay_target_com_number,
                   pay_con_number,
                   pay_cur_code,
                   pay_reference,
                   pay_due,
                   pay_rate,
                   pay_lsl_number
              INTO l_pay_source_com_number,
                   l_pay_target_com_number,
                   l_pay_con_number,
                   l_pay_cur_code,
                   l_pay_reference,
                   l_pay_due,
                   l_pay_rate,
                   l_pay_lsl_number
              FROM fid_payment
             WHERE pay_number = i_pay_number
                   AND pay_lic_number = l_pay_lic_number;
         EXCEPTION
            WHEN OTHERS
            THEN
               raise_application_error (
                  -20010,
                     'i_pay_number - '
                  || i_pay_number
                  || ', l_pay_lic_number - '
                  || l_pay_lic_number
                  || ', '
                  || SQLERRM);
         END;

         --Get the count for all not paid payments having amount less than 0
         SELECT COUNT (1)
           INTO l_refund_payment_count
           FROM fid_payment
          WHERE     pay_lic_number = l_pay_lic_number
                AND pay_amount < 0
                AND pay_status = 'N'
                AND pay_lsl_number = l_pay_lsl_number
                AND pay_cur_code = l_pay_cur_code;

         IF l_refund_payment_count > 0
         THEN
            --Loop for all not paid payments having amount less than 0
            FOR c_refund_payment
               IN (SELECT pay_number, pay_amount
                     FROM fid_payment
                    WHERE     pay_lic_number = l_pay_lic_number
                          AND pay_amount < 0
                          AND pay_lsl_number = l_pay_lsl_number
                          AND pay_cur_code = l_pay_cur_code
                          AND pay_status = 'N')
            LOOP
               IF l_pay_amount <> 0
               THEN
                  IF ABS (c_refund_payment.pay_amount) <= ABS (l_pay_amount)
                  THEN
                     l_rem_not_paid_pay := 0;

                     SELECT COUNT (1)
                       INTO l_rem_not_paid_pay
                       FROM fid_payment
                      WHERE     pay_lic_number = l_pay_lic_number
                            AND pay_amount < 0
                            AND pay_status = 'N'
                            AND pay_lsl_number = l_pay_lsl_number
                            AND pay_cur_code = l_pay_cur_code;

                     IF l_rem_not_paid_pay > 1
                     THEN
                        UPDATE fid_payment
                           SET pay_status = 'P',
                               pay_code = 'T',
                               pay_date = SYSDATE,
                               pay_rate = l_pay_rate,
                               pay_due = l_pay_due,
                               pay_status_date = SYSDATE,
                               pay_source_number = i_pay_source_number,
                               pay_source_com_number = l_pay_source_com_number,
                               pay_target_com_number = l_pay_target_com_number,
                               pay_con_number = l_pay_con_number,
                               pay_comment = i_pay_comment,
                               pay_reference = l_pay_reference,
                               pay_entry_oper = i_entry_oper,
                               pay_entry_date = SYSDATE
                         WHERE pay_number = c_refund_payment.pay_number;

                        l_pay_amount :=
                           l_pay_amount - c_refund_payment.pay_amount;
                     ELSE
                        --When count for remaining not paid payment is 1 (l_rem_not_paid_pay = 1)
                        UPDATE fid_payment
                           SET pay_status = 'P',
                               pay_code = 'T',
                               pay_date = SYSDATE,
                               pay_rate = l_pay_rate,
                               pay_due = l_pay_due,
                               pay_status_date = SYSDATE,
                               pay_source_number = i_pay_source_number,
                               pay_source_com_number = l_pay_source_com_number,
                               pay_target_com_number = l_pay_target_com_number,
                               pay_con_number = l_pay_con_number,
                               pay_comment = i_pay_comment,
                               pay_reference = l_pay_reference,
                               pay_entry_oper = i_entry_oper,
                               pay_entry_date = SYSDATE,
                               pay_amount = l_pay_amount
                         WHERE pay_number = c_refund_payment.pay_number;

                        l_pay_amount := 0;
                        EXIT;
                     END IF;
                  ELSE
                     INSERT INTO fid_payment (pay_number,
                                              pay_source_com_number,
                                              pay_target_com_number,
                                              pay_code,
                                              pay_con_number,
                                              pay_lic_number,
                                              pay_status,
                                              pay_status_date,
                                              pay_amount,
                                              pay_cur_code,
                                              pay_comment,
                                              pay_reference,
                                              pay_entry_oper,
                                              pay_entry_date,
                                              pay_rate,
                                              pay_date,
                                              pay_lsl_number,
                                              pay_source_number,
                                              pay_due)
                          VALUES (seq_pay_number.NEXTVAL,
                                  l_pay_source_com_number,
                                  l_pay_target_com_number,
                                  DECODE(i_pay_status,'P','T','G'),--Finace Dev Phase 1[Jawahar Garg]
                                  l_pay_con_number,
                                  l_pay_lic_number,
                                  i_pay_status,--Finace Dev Phase 1[Ankur Kasar]
                                  SYSDATE,
                                  l_pay_amount,
                                  l_pay_cur_code,
                                  i_pay_comment,
                                  l_pay_reference,
                                  i_entry_oper,
                                  SYSDATE,
                                  l_pay_rate,
                                  DECODE(i_pay_status,'N',NULL,SYSDATE),
                                  l_pay_lsl_number,
                                  i_pay_source_number,
                                  i_pay_due);

                     UPDATE fid_payment
                        SET pay_amount =
                               c_refund_payment.pay_amount - l_pay_amount,
                            pay_entry_oper = i_entry_oper,
                            pay_entry_date = SYSDATE
                      WHERE pay_number = c_refund_payment.pay_number;

                     EXIT;
                  END IF;
               END IF;
            END LOOP;
         ELSE
            INSERT INTO fid_payment (pay_number,
                                     pay_source_com_number,
                                     pay_target_com_number,
                                     pay_code,
                                     pay_con_number,
                                     pay_lic_number,
                                     pay_status,
                                     pay_status_date,
                                     pay_amount,
                                     pay_cur_code,
                                     pay_comment,
                                     pay_reference,
                                     pay_entry_oper,
                                     pay_entry_date,
                                     pay_rate,
                                     pay_date,
                                     pay_lsl_number,
                                     pay_source_number,
                                     pay_due)
                 VALUES (seq_pay_number.NEXTVAL,
                         l_pay_source_com_number,
                         l_pay_target_com_number,
                         DECODE(i_pay_status,'P','T','G'),--Finace Dev Phase 1[Jawahar Garg],
                         l_pay_con_number,
                         l_pay_lic_number,
                         i_pay_status,--Finace Dev Phase 1[Ankur Kasar]
                         SYSDATE,
                         l_pay_amount,
                         l_pay_cur_code,
                         i_pay_comment,
                         l_pay_reference,
                         i_entry_oper,
                         SYSDATE,
                         l_pay_rate,
                         DECODE(i_pay_status,'N',NULL,SYSDATE),
                         l_pay_lsl_number,
                         i_pay_source_number,
                         i_pay_due);
         END IF;

         --COMMIT;
         o_success := SQL%ROWCOUNT;
      END IF;

      IF TO_NUMBER (l_pay_amount) > 0
      THEN
        -- DBMS_OUTPUT.put_line ('destination lic nuumber' || l_pay_lic_number);

         SELECT pay_cur_code,
                pay_status_date,
                pay_due,
                pay_rate,
                pay_reference
           INTO l_pay_cur_code,
                l_pay_status_date,
                l_pay_due,
                l_pay_rate,
                l_pay_reference
           FROM fid_payment
          WHERE pay_number = i_pay_source_number;

         SELECT pay_source_com_number,
                pay_target_com_number,
                pay_code,
                pay_con_number,
                pay_lsl_number
           INTO l_pay_source_com_number,
                l_pay_target_com_number,
                l_pay_code,
                l_pay_con_number,
                l_pay_lsl_number
           FROM fid_payment
          WHERE pay_number = i_pay_number;

         l_new_pay_number := seq_pay_number.NEXTVAL;
         l_dest_pay_amount := l_pay_amount;

         INSERT INTO fid_payment (pay_number,
                                  pay_source_com_number,
                                  pay_target_com_number,
                                  pay_code,
                                  pay_con_number,
                                  pay_lic_number,
                                  pay_status,
                                  pay_status_date,
                                  pay_amount,
                                  pay_cur_code,
                                  pay_comment,
                                  pay_reference,
                                  pay_entry_oper,
                                  pay_entry_date,
                                  pay_rate,
                                  pay_date,
                                  pay_lsl_number,
                                  pay_source_number,
                                  pay_due)
              VALUES (l_new_pay_number,
                      l_pay_source_com_number,
                      l_pay_target_com_number,
                      DECODE(i_pay_status,'P','T','G'),--Finace Dev Phase 1[Jawahar Garg],
                      l_pay_con_number,
                      l_pay_lic_number,
                      i_pay_status,--Finace Dev Phase 1[Ankur Kasar]
                      SYSDATE,
                      l_pay_amount,
                      l_pay_cur_code,
                      i_pay_comment,
                      l_pay_reference,
                      i_entry_oper,
                      SYSDATE,
                      l_pay_rate,
                      DECODE(i_pay_status,'N',NULL,SYSDATE),
                      l_pay_lsl_number,
                      i_pay_source_number,
                      i_pay_due);
          --Change Sequence of Inserting data           
          if i_pay_status <> 'N'--Finace Dev Phase I [Ankur Kasar]
          then
          INSERT INTO x_tmp_fid_payment (tfp_s_pay_number,
                                        tfp_s_con_short_name,
                                        tfp_s_lic_number,
                                        tfp_s_licensee,
                                        tfp_s_lic_type,
                                        tfp_s_gen_title,
                                        tfp_s_lic_bud_code,
                                        tfp_s_lic_amort_code,
                                        tfp_s_pay_date,
                                        tfp_d_pay_number,
                                        tfp_d_con_short_name,
                                        tfp_d_lic_number,
                                        tfp_d_licensee,
                                        tfp_d_lic_type,
                                        tfp_d_gen_title,
                                        tfp_d_lic_bud_code,
                                        tfp_d_lic_amort_code,
                                        tfp_d_pay_date,
                                        tfp_d_entry_oper,
                                        tfp_d_pay_comment,
                                        tfp_d_cur_code,
                                        tfp_d_pay_amount)
              VALUES (
                        i_pay_source_number,
                        (SELECT con_short_name
                           FROM fid_contract
                          WHERE con_number IN
                                   (SELECT pay_con_number
                                      FROM fid_payment
                                     WHERE pay_number = i_pay_source_number)),
                        (SELECT pay_lic_number
                           FROM fid_payment
                          WHERE pay_number = i_pay_source_number),
                        (SELECT lee_short_name
                           FROM fid_licensee
                          WHERE lee_number IN
                                   (SELECT lsl_lee_number
                                      FROM x_fin_lic_sec_lee
                                     WHERE lsl_number IN
                                              (SELECT pay_lsl_number
                                                 FROM fid_payment
                                                WHERE pay_number =
                                                         i_pay_source_number))),
                        (SELECT lic_type
                           FROM fid_license
                          WHERE lic_number IN
                                   (SELECT pay_lic_number
                                      FROM fid_payment
                                     WHERE pay_number = i_pay_source_number)),
                        (SELECT gen_title
                           FROM fid_general
                          WHERE gen_refno IN
                                   (SELECT lic_gen_refno
                                      FROM fid_license
                                     WHERE lic_number IN
                                              (SELECT pay_lic_number
                                                 FROM fid_payment
                                                WHERE pay_number =
                                                         i_pay_source_number))),
                        (SELECT lic_budget_code
                           FROM fid_license
                          WHERE lic_number IN
                                   (SELECT pay_lic_number
                                      FROM fid_payment
                                     WHERE pay_number = i_pay_source_number)),
                        (SELECT lic_amort_code
                           FROM fid_license
                          WHERE lic_number IN
                                   (SELECT pay_lic_number
                                      FROM fid_payment
                                     WHERE pay_number = i_pay_source_number)),
                        TRUNC (SYSDATE),
                        l_new_pay_number,
                        (SELECT con_short_name
                           FROM fid_contract
                          WHERE con_number IN
                                   (SELECT pay_con_number
                                      FROM fid_payment
                                     WHERE pay_number = l_new_pay_number)),
                        (SELECT pay_lic_number
                           FROM fid_payment
                          WHERE pay_number = l_new_pay_number),
                        (SELECT lee_short_name
                           FROM fid_licensee
                          WHERE lee_number IN
                                   (SELECT lsl_lee_number
                                      FROM x_fin_lic_sec_lee
                                     WHERE lsl_number IN
                                              (SELECT pay_lsl_number
                                                 FROM fid_payment
                                                WHERE pay_number =
                                                         l_new_pay_number))),
                        (SELECT lic_type
                           FROM fid_license
                          WHERE lic_number IN
                                   (SELECT pay_lic_number
                                      FROM fid_payment
                                     WHERE pay_number = l_new_pay_number)),
                        (SELECT gen_title
                           FROM fid_general
                          WHERE gen_refno IN
                                   (SELECT lic_gen_refno
                                      FROM fid_license
                                     WHERE lic_number IN
                                              (SELECT pay_lic_number
                                                 FROM fid_payment
                                                WHERE pay_number =
                                                         l_new_pay_number))),
                        (SELECT lic_budget_code
                           FROM fid_license
                          WHERE lic_number IN
                                   (SELECT pay_lic_number
                                      FROM fid_payment
                                     WHERE pay_number = l_new_pay_number)),
                        (SELECT lic_amort_code
                           FROM fid_license
                          WHERE lic_number IN
                                   (SELECT pay_lic_number
                                      FROM fid_payment
                                     WHERE pay_number = l_new_pay_number)),
                        TRUNC (SYSDATE),
                        i_entry_oper,
                        i_pay_comment,
                        (SELECT pay_cur_code
                           FROM fid_payment
                          WHERE pay_number = l_new_pay_number),
                          
                        DECODE (l_pay_amount,
                                0, l_dest_pay_amount,
                                l_pay_amount));

            end if;
       
         UPDATE fid_payment
            SET pay_amount = pay_amount - l_pay_amount,
                pay_entry_oper = i_entry_oper,
                pay_entry_date = SYSDATE
          WHERE pay_number = i_pay_number AND pay_status = 'N';

         SELECT pay_amount
           INTO l_pay_amount
           FROM fid_payment
          WHERE pay_number = i_pay_number AND pay_status = 'N';

         IF l_pay_amount = 0
         THEN
            SELECT pkg_cm_username.setusername (i_entry_oper)
              INTO l_number
              FROM DUAL;

            DELETE FROM fid_payment
                  WHERE --Pay_Lic_Number = I_Pay_Lic_Number
                        --And
                        pay_status = 'N' AND pay_number = i_pay_number;
         END IF;

       
         o_success := SQL%ROWCOUNT;
      END IF;
   
   END x_prc_add_transfer_payment;

   FUNCTION x_prc_avl_transfer_amt (
      i_pay_number IN fid_payment.pay_number%TYPE)
      RETURN NUMBER
   AS
      l_amount                       fid_payment.pay_amount%TYPE;
      l_tranfer_amt_curr_month       fid_payment.pay_amount%TYPE;
      l_pay_lic_number               fid_payment.pay_lic_number%TYPE;
      o_amount                       NUMBER;
      l_split_region                 NUMBER;
      l_latest_closed_month          DATE;
      l_refund_amt_till_last_month   NUMBER := 0;
      l_refund_amt_in_curr_month     NUMBER := 0;
      l_fim_year                     NUMBER;
      l_fim_month                    NUMBER;
      l_pay_code                     VARCHAR2 (1);
      l_non_settle_amt_till_now      NUMBER;
   BEGIN
      SELECT pay_lic_number, pay_code
        INTO l_pay_lic_number, l_pay_code
        FROM fid_payment
       WHERE pay_number = i_pay_number;

      SELECT lee_split_region
        INTO l_split_region
        FROM fid_licensee, fid_license
       WHERE lee_number = lic_lee_number AND lic_number = l_pay_lic_number;

      SELECT TO_DATE (TO_CHAR (MAX (fim_year || LPAD (fim_month, 2, 0))),
                      'YYYYMM')
        INTO l_latest_closed_month
        FROM fid_financial_month
       WHERE fim_status = 'C' AND fim_split_region = l_split_region;

      SELECT fim_year, fim_month
        INTO l_fim_year, l_fim_month
        FROM fid_financial_month
       WHERE fim_status = 'O' AND fim_split_region = l_split_region;

      BEGIN
         SELECT NVL (pay_amount, 0)
           INTO l_amount
           FROM fid_payment
          WHERE pay_number = i_pay_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_amount := 0;
      END;

      BEGIN
         --Calculating refund amount till last closed month
         SELECT NVL (SUM (frs_rfd_amount), 0)
           INTO l_refund_amt_till_last_month
           FROM x_fin_refund_settle
          WHERE frs_lic_number = l_pay_lic_number
                AND frs_pay_number = i_pay_number
                AND frs_year || LPAD (frs_month, 2, 0) <=
                       TO_CHAR (l_latest_closed_month, 'YYYYMM');

         --Calculating refund amount in current month (Occurs after INTERMEDIATE month End routine)
         SELECT NVL (SUM (frs_rfd_amount), 0)
           INTO l_refund_amt_in_curr_month
           FROM x_fin_refund_settle, fid_payment
          WHERE     frs_lic_number = pay_lic_number
                AND frs_rfd_pay_number = pay_number
                AND frs_lic_number = l_pay_lic_number
                AND frs_pay_number = i_pay_number
                AND pay_amount < 0
                AND TO_CHAR (pay_date, 'YYYYMM') =
                       l_fim_year || LPAD (l_fim_month, 2, 0)
                AND frs_year = l_fim_year
                AND frs_month = l_fim_month;

         --Calculating refund amount which are still to settle in current month
         SELECT NVL (SUM (pay_amount), 0)
           INTO l_non_settle_amt_till_now
           FROM fid_payment
          WHERE     pay_lic_number = l_pay_lic_number
                AND pay_amount < 0
                AND pay_code <> 'T'
                AND pay_number NOT IN
                       (SELECT frs_rfd_pay_number
                          FROM x_fin_refund_settle
                         WHERE     frs_lic_number = l_pay_lic_number
                               AND frs_year = l_fim_year
                               AND frs_month = l_fim_month)
                AND TO_CHAR (pay_date, 'YYYYMM') =
                       l_fim_year || LPAD (l_fim_month, 2, 0);

         --Calculating transfer amount in current month which are not settled yet
         SELECT NVL (SUM (pay_amount), 0)
           INTO l_tranfer_amt_curr_month
           FROM fid_payment
          WHERE     pay_source_number = i_pay_number
                AND pay_code = 'T'
                AND pay_amount < 0
                AND pay_lic_number = l_pay_lic_number
                AND pay_number NOT IN
                       (SELECT frs_rfd_pay_number
                          FROM x_fin_refund_settle
                         WHERE     frs_lic_number = l_pay_lic_number
                               AND frs_year = l_fim_year
                               AND frs_month = l_fim_month)
                AND TO_CHAR (pay_date, 'YYYYMM') =
                       l_fim_year || LPAD (l_fim_month, 2, 0);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_tranfer_amt_curr_month := 0;
      END;

      o_amount :=
         l_amount + l_tranfer_amt_curr_month
         - (  l_refund_amt_till_last_month
            + l_refund_amt_in_curr_month
            + l_non_settle_amt_till_now);
     -- DBMS_OUTPUT.put_line ('o_amount:' || o_amount);
      RETURN o_amount;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         o_amount := 0;
         RETURN o_amount;
      WHEN OTHERS
      THEN
         o_amount := 0;
         RETURN o_amount;
   END x_prc_avl_transfer_amt;

   FUNCTION x_prc_remaining_liab_amt (
      i_lic_number IN fid_license.lic_number%TYPE)
      RETURN NUMBER
   AS
      l_lic_price   fid_license.lic_price%TYPE;
      l_amount      fid_payment.pay_amount%TYPE;
      o_liab_amt    NUMBER;
   BEGIN
      SELECT lic_price
        INTO l_lic_price
        FROM fid_license
       WHERE lic_number = i_lic_number;

      BEGIN
         SELECT NVL (SUM (pay_amount), 0)
           INTO l_amount
           FROM fid_payment
          WHERE pay_lic_number = i_lic_number AND pay_status = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_amount := 0;
      END;

      o_liab_amt := l_lic_price - l_amount;
      RETURN o_liab_amt;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         o_liab_amt := 0;
         RETURN o_liab_amt;
      WHEN OTHERS
      THEN
         o_liab_amt := 0;
         RETURN o_liab_amt;
   END x_prc_remaining_liab_amt;

   PROCEDURE x_prc_delete_tmp_tabl_trnsfer
   AS
   BEGIN
      DELETE FROM x_tmp_fid_payment;

      COMMIT;
   END x_prc_delete_tmp_tabl_trnsfer;

   PROCEDURE x_prc_transfer_detail_rpt (
      o_transfer_detail OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
   BEGIN
      OPEN o_transfer_detail FOR SELECT * FROM x_tmp_fid_payment;
   END;

   PROCEDURE x_prc_con_prgm_details (
      i_con_short_name   IN     VARCHAR2,
      o_con_dtls            OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
      l_con_short_name   VARCHAR2 (100);
      l_query_string     VARCHAR2 (1000);
   BEGIN
      l_query_string :=
         'select gen_title,lic_number,con_short_name,con_number,con_name,con_calc_type,con_currency,
                  (SELECT SUBSTR (cod_description, 1, 20) FROM fid_code WHERE cod_type = ''CON_CALC_TYPE''
                  AND cod_value = con_calc_type AND cod_value <> ''HEADER'')con_calc_type_desc,lee_short_name,
                  chs_short_name, con_start_date, con_end_date, lic_status,
                  PKG_FIN_MNET_PAY_QRY_MNT.local_currency(lic_number) loc_cur_code
                  from fid_license_vw, fid_channel_service
                  where  lic_chs_number = chs_number(+)';

      IF i_con_short_name IS NOT NULL
      THEN
         l_con_short_name := REPLACE (i_con_short_name, ',', ''',''');
         l_query_string :=
               l_query_string
            || ' and con_short_name in ('''
            || l_con_short_name
            || ''')';
      END IF;

     -- DBMS_OUTPUT.put_line (l_query_string);

      OPEN o_con_dtls FOR l_query_string;
   END;

   PROCEDURE x_prc_batch_pay_view_details (
      i_lic_number    IN     VARCHAR2,
      o_fid_payment      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
      l_pay_fcd_number       fid_payment.pay_fcd_number%TYPE;
      o_tot_paid_sel_title   NUMBER;
      o_inc_mkup_sel_title   NUMBER;
      o_exc_mkup_sel_title   NUMBER;
      o_ous_liab_sel_title   NUMBER;
      o_tot_paid_ent_con     NUMBER;
      o_inc_mkup_ent_con     NUMBER;
      o_exc_mkup_ent_con     NUMBER;
      o_ous_liab_ent_con     NUMBER;
      o_con_number           fid_contract.con_number%TYPE;
      o_con_calc_type        fid_contract.con_calc_type%TYPE;
      o_pay_amt              NUMBER;
      o_con_calc_type_desc   fid_code.cod_description%TYPE;
      o_con_currency         fid_contract.con_currency%TYPE;
      o_con_price            fid_contract.con_price%TYPE;
      o_con_short_name       fid_contract.con_short_name%TYPE;
      o_con_name             fid_contract.con_name%TYPE;
      -- l_querystring          varchar2 (10000);
      l_querystring          CLOB;
      l_lic_number           CLOB;
   BEGIN
      l_lic_number := REPLACE (i_lic_number, ',', ''',''');
    --  DBMS_OUTPUT.put_line ('lic_no:' || l_lic_number);
      l_querystring :=
         'select PAY_NUMBER
        ,(select lee_short_name from fid_licensee where lee_number in(select lsl_lee_number from x_fin_lic_sec_lee where lsl_number= pay_lsl_number))licensee
        ,    PAY_SOURCE_COM_NUMBER
        ,    PAY_TARGET_COM_NUMBER
        ,    PAY_CON_NUMBER
        ,    (select con_short_name from fid_contract where con_number = pay_con_number)con_short_name
        ,     (select con_calc_type from fid_contract where con_number = pay_con_number)con_calc_type
        ,    PAY_LIC_NUMBER
        ,    PAY_STATUS
        ,    PAY_STATUS_DATE
        ,    trunc(PAY_AMOUNT,4) PAY_AMOUNT
        ,    PAY_CUR_CODE
        ,    PAY_DATE
        ,(select ter_cur_code from fid_territory where ter_code in (select com_ter_code from fid_company where com_number in (select lee_cha_com_number from fid_licensee
            where lee_number in (select lsl_lee_number from x_fin_lic_sec_lee where lsl_lic_number = PAY_LIC_NUMBER))))loc_cur_code
        ,    PAY_RATE
        ,    PAY_CODE
        ,    PAY_DUE
        ,    PAY_UPDATE_COUNT
        ,    PAY_REFERENCE
        ,    PAY_COMMENT
        ,    PAY_SUPPLIER_INVOICE
        ,    PAY_ENTRY_DATE
        ,    PAY_ENTRY_OPER
        ,    PAY_MARKUP_PERCENT
        ,    PAY_FCD_NUMBER
        ,    fg.GEN_TITLE
        ,    fl.LIC_NUMBER
        ,    fg.GEN_REFNO
        ,    fg.gen_ser_number
        ,    PKG_FIN_MNET_PAY_QRY_MNT.x_prc_avl_transfer_amt(pay_number) transferable_amt
        ,    (select com_short_name from fid_company where com_number in (select con_com_number from fid_contract
                where con_number=pay_con_number))supplier
        from     fid_payment
        ,    fid_license  fl
        ,      fid_general fg
                where    fl.lic_number = PAY_LIC_NUMBER
        and    fl.lic_gen_refno = fg.gen_refno
        and    pay_lic_number in ('''
         || l_lic_number
         || ''')';

      /*l_querystring :=
             l_querystring || ' order by fg.GEN_TITLE, PAY_DUE , PAY_CODE asc';*/
      OPEN o_fid_payment FOR l_querystring;
   END x_prc_batch_pay_view_details;

   PROCEDURE x_prc_batch_contractwise_dtls (
      i_pay_number           IN     fid_payment.pay_number%TYPE,
      o_po_fee_info             OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_title           OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_season          OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_season_pay      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_dtls_by_title_pay       OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry,
      o_oth_dtls                OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry)
   AS
      l_pay_fcd_number       fid_payment.pay_fcd_number%TYPE;
      o_tot_paid_sel_title   NUMBER;
      o_inc_mkup_sel_title   NUMBER;
      o_exc_mkup_sel_title   NUMBER;
      o_ous_liab_sel_title   NUMBER;
      o_tot_paid_ent_con     NUMBER;
      o_inc_mkup_ent_con     NUMBER;
      o_exc_mkup_ent_con     NUMBER;
      o_ous_liab_ent_con     NUMBER;
      o_con_number           fid_contract.con_number%TYPE;
      o_con_calc_type        fid_contract.con_calc_type%TYPE;
      o_pay_amt              NUMBER;
      o_con_calc_type_desc   fid_code.cod_description%TYPE;
      o_con_currency         fid_contract.con_currency%TYPE;
      o_con_price            fid_contract.con_price%TYPE;
      o_con_short_name       fid_contract.con_short_name%TYPE;
      o_con_name             fid_contract.con_name%TYPE;
   BEGIN
      SELECT pay_con_number
        INTO o_con_number
        FROM fid_payment
       WHERE pay_number = i_pay_number;

      BEGIN
         SELECT con_short_name,
                con_calc_type,
                con_name,
                con_currency,
                con_price
           INTO o_con_short_name,
                o_con_calc_type,
                o_con_name,
                o_con_currency,
                o_con_price
           FROM fid_contract
          WHERE con_number = o_con_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20426,
               'The Contract Name ' || o_con_short_name || ' does not exists');
      END;

      BEGIN
         SELECT SUM (pay_amount)
           INTO o_pay_amt
           FROM fid_payment, fid_payment_type
          WHERE     pay_con_number = o_con_number
                AND pay_code = pat_code
                AND pat_group = 'F'
                AND pay_status = 'P';

         SELECT SUBSTR (cod_description, 1, 20)
           INTO o_con_calc_type_desc
           FROM fid_code
          WHERE     cod_type = 'CON_CALC_TYPE'
                AND cod_value = o_con_calc_type
                AND cod_value <> 'HEADER';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20426,
                                     'Code Description does not found ');
      END;

      BEGIN
         SELECT DISTINCT pay_fcd_number
           INTO l_pay_fcd_number
           FROM fid_payment
          WHERE pay_con_number = o_con_number;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_pay_fcd_number := NULL;
      END;

      IF o_con_calc_type IN ('FLF', 'CHC')
      THEN
         SELECT NVL (SUM (lic_price), 0),
                NVL (SUM (lic_price * (100 + lic_markup_percent) / 100), 0)
           INTO o_exc_mkup_ent_con, o_inc_mkup_ent_con
           FROM fid_license
          WHERE lic_con_number = o_con_number AND lic_type IN ('FLF', 'CHC');

         SELECT NVL (SUM (lic_price), 0),
                NVL (SUM (lic_price * (100 + lic_markup_percent) / 100), 0)
           INTO o_exc_mkup_sel_title, o_inc_mkup_sel_title
           FROM fid_license, fid_general
          WHERE     lic_con_number = o_con_number
                AND lic_gen_refno = gen_refno
                AND lic_type IN ('FLF', 'CHC');
      ELSIF o_con_calc_type = 'CPD'
      THEN
         BEGIN
            SELECT con_price
              INTO o_inc_mkup_ent_con
              FROM fid_contract
             WHERE con_number = o_con_number;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_inc_mkup_ent_con := 0;
         END;

         o_exc_mkup_ent_con := 0;
         o_inc_mkup_sel_title := o_exc_mkup_ent_con;
         o_exc_mkup_sel_title := 0;
      ELSE
         o_exc_mkup_ent_con := 0;
         o_inc_mkup_ent_con := 0;
         o_exc_mkup_sel_title := 0;
         o_inc_mkup_sel_title := 0;
      END IF;

      IF o_con_calc_type IN ('FLF', 'CHC', 'CPD')
      THEN
         o_tot_paid_ent_con := NVL (o_pay_amt, 0);

         BEGIN
            SELECT NVL (SUM (pay_amount), 0)
              INTO o_tot_paid_sel_title
              FROM fid_license, fid_general, fid_payment
             WHERE     lic_con_number = o_con_number
                   AND pay_con_number = lic_con_number
                   AND pay_status = 'P'
                   AND pay_lic_number = lic_number
                   AND lic_gen_refno = gen_refno;
         EXCEPTION
            WHEN OTHERS
            THEN
               o_tot_paid_sel_title := 0;
         END;

         o_ous_liab_ent_con := o_inc_mkup_ent_con - o_tot_paid_ent_con;
         o_ous_liab_sel_title := o_inc_mkup_sel_title - o_tot_paid_sel_title;
      ELSE
         o_tot_paid_ent_con := 0;
         o_tot_paid_sel_title := 0;
         o_ous_liab_ent_con := 0;
         o_ous_liab_sel_title := 0;
      END IF;

      OPEN o_po_fee_info FOR
         SELECT ROUND (o_tot_paid_sel_title, 2) o_tot_paid_sel_title,
                TRUNC (o_inc_mkup_sel_title, 2) o_inc_mkup_sel_title,
                TRUNC (o_exc_mkup_sel_title, 2) o_exc_mkup_sel_title,
                TRUNC (o_ous_liab_sel_title, 2) o_ous_liab_sel_title,
                TRUNC (o_tot_paid_ent_con, 2) o_tot_paid_ent_con,
                TRUNC (o_inc_mkup_ent_con, 2) o_inc_mkup_ent_con,
                TRUNC (o_exc_mkup_ent_con, 2) o_exc_mkup_ent_con,
                TRUNC (o_ous_liab_ent_con, 2) o_ous_liab_ent_con
           FROM DUAL;

      OPEN o_oth_dtls FOR
         SELECT o_con_number contractnumber,
                o_con_calc_type contracttype,
                o_con_calc_type_desc contracttypedescription,
                o_con_currency contractcurrency,
                o_con_short_name contractshortname,
                o_con_name contractname
           FROM DUAL;

      /* Group by gen_ser_number - season */
      OPEN o_dtls_by_season FOR
           SELECT NVL (SUM (TRUNC (fl.lic_price, 2)), 0) o_exc_mkup_sel_title,
                  NVL (
                     SUM (
                          TRUNC (fl.lic_price, 2)
                        * (100 + TRUNC (fl.lic_markup_percent, 2))
                        / 100),
                     0)
                     o_inc_mkup_sel_title,
                  fg.gen_ser_number
             FROM fid_license fl, fid_general fg
            --fid_payment fp,
            --fid_payment_type fpt
            WHERE     fl.lic_con_number = o_con_number
                  AND fl.lic_gen_refno = fg.gen_refno
                  AND fg.gen_ser_number IS NOT NULL
                  -- AND fl.lic_con_number = fp.pay_con_number
                  --AND fl.lic_number = fp.pay_lic_number
                  -- AND fp.pay_code = fpt.pat_code
                  --AND fpt.pat_group = 'F'
                  AND fl.lic_type IN ('FLF', 'CHC')
         --And fg.gen_ser_number =1010383
         GROUP BY fg.gen_ser_number;

     -- DBMS_OUTPUT.put_line ('TEST 8');

      /* Group by gen_refno and gen_title */
      OPEN o_dtls_by_title FOR
           SELECT NVL (SUM (TRUNC (fl.lic_price, 2)), 0) o_exc_mkup_sel_title,
                  NVL (
                     SUM (
                          TRUNC (fl.lic_price, 2)
                        * (100 + TRUNC (fl.lic_markup_percent, 2))
                        / 100),
                     0)
                     o_inc_mkup_sel_title,
                  fg.gen_title,
                  fg.gen_refno
             FROM fid_license fl, fid_general fg
            WHERE     fl.lic_con_number = o_con_number
                  AND fl.lic_gen_refno = fg.gen_refno
                  AND fl.lic_type IN ('FLF', 'CHC')
                  AND fl.lic_price != 0
         GROUP BY fg.gen_title, fg.gen_refno;

      OPEN o_dtls_by_season_pay FOR
           SELECT DISTINCT
                  fg.gen_ser_number,
                  NVL (SUM (TRUNC (fp.pay_amount, 2)), 0) o_pay_amt
             FROM fid_license fl, fid_general fg, fid_payment fp
            --    fid_payment_type fpt
            WHERE     fl.lic_con_number = o_con_number
                  AND fl.lic_gen_refno = fg.gen_refno
                  AND fp.pay_con_number = fl.lic_con_number
                  AND fl.lic_number = fp.pay_lic_number
                  AND fg.gen_ser_number IS NOT NULL
                  --    AND       fp.pay_code = fpt.pat_code
                  --   AND       fpt.pat_group = 'F'
                  AND fp.pay_status = 'P'
         --  AND       fg.gen_ser_number = 1010383
         GROUP BY fg.gen_ser_number;

      OPEN o_dtls_by_title_pay FOR
           SELECT NVL (
                     SUM (
                        TRUNC (DECODE (fp.pay_status, 'P', fp.pay_amount, 0),
                               2)),
                     0)
                     o_pay_amt,
                  fg.gen_title,
                  fg.gen_refno
             FROM fid_general fg, fid_payment fp, fid_license fl
            WHERE     fl.lic_con_number = o_con_number
                  AND fl.lic_gen_refno = fg.gen_refno
                  AND fl.lic_con_number = fp.pay_con_number
                  AND fl.lic_type IN ('FLF', 'CHC')
                  AND fl.lic_number = fp.pay_lic_number
         --AND fp.pay_status = 'P'
         GROUP BY fg.gen_title, fg.gen_refno;
   END x_prc_batch_contractwise_dtls;

   PROCEDURE prc_get_licprice_paytotal (
      i_lic_number        IN     fid_payment.pay_lic_number%TYPE,
	  i_lee_short_name		  IN	 fid_licensee.lee_short_name%TYPE,
      o_lic_pay_details      OUT PKG_FIN_MNET_PAY_QRY_MNT.c_cursor_payqry
	  )
   AS
      o_lic_price   NUMBER;
      o_pay_total   NUMBER;
	  O_Lee_Price   Number;
    L_Lsl_Number  number;
   BEGIN
      SELECT NVL (lic_price, 0)
        INTO o_lic_price
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT NVL (SUM (pay_amount), 0)
        INTO o_pay_total
        FROM fid_payment
       WHERE pay_lic_number = i_lic_number AND pay_status = 'P';

     begin
            Select Lsl_Number
            Into L_Lsl_Number
            FROM x_fin_lic_sec_lee
                 ,Fid_Licensee
            Where Lsl_Lic_Number = i_lic_number
            and lsl_lee_number = lee_number
            And  Upper(Lee_Short_Name) = i_lee_short_name
            ;
      Exception
      When Others
      Then
            L_Lsl_Number :=0;
      End;

		BEGIN
            select lsl_lee_price
            INTO o_lee_price
            from x_fin_lic_sec_lee
              ,fid_licensee
            where lsl_lee_number = lee_number
            and	lsl_lic_number = i_lic_number
            and upper(lee_short_name) = upper(i_lee_short_name)
            ;

		EXCEPTION
		WHEN OTHERS
		THEN
			o_lee_price := o_lic_price;
		END;

		Begin

    /*	SELECT NVL (SUM (pay_amount), 0)
			INTO o_pay_total
			FROM fid_payment
				 ,fid_license
				 ,x_fin_lic_sec_lee
				 ,fid_licensee
			WHERE pay_lic_number = i_lic_number
			AND  upper(lee_short_name) = upper(i_lee_short_name)
			AND  pay_lic_number = lic_number
			AND LSL_LIC_NUMBER = lic_number
			AND pay_lsl_number = LSL_NUMBER
			AND lic_lee_number = lee_number
			AND pay_status = 'P';
      */

      Select Nvl (Sum (Pay_Amount), 0)
      into o_pay_total
      From Fid_Payment
      Where Pay_Lic_Number = i_lic_number
      And Pay_Lsl_Number = L_Lsl_Number
      And Pay_Status = 'P'
      ;

		EXCEPTION
		WHEN OTHERS
		THEN
			o_pay_total := o_pay_total;
		END;

      OPEN o_lic_pay_details FOR
      SELECT o_lic_price o_lic_price, o_pay_total o_pay_total, o_lee_price o_lee_price FROM DUAL;

   END prc_get_licprice_paytotal;
---Dev:Pure Finance:End-----------------------------------------------
END PKG_FIN_MNET_PAY_QRY_MNT;
/
