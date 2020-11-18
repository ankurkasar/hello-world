create or replace PACKAGE          "X_PKG_RD_MONTH_DISC_CALC" AS

/****************************************************************
REM Module          : Rand Devaluation
REM Client          : MNET
REM File Name       : X_PKG_RD_MONTH_DISC_CALC.sql
REM Form Name       : Rand Devaluation Discount Calculation Routine
REM Purpose         : Discount calcualtion of contract
REM Author          : Sushma Komulla
REM Creation Date   : 09-JUN-2014
REM Type            : Database Package
REM Change History  :
****************************************************************/
--Below procedure is used to check wheather the spot rate available or not
  PROCEDURE VALIDATION_CHECK
  (
    I_COM_NUMBER     IN    NUMBER,
   i_region         IN     VARCHAR2,
   i_period_month   IN    NUMBER,
   i_period_year    IN    NUMBER
   );
  --Below procedure is used to get the spot rate on particular day
  FUNCTION get_spot_rate
  (
     fromcurr                  IN   VARCHAR2,
      tocurr                   IN   VARCHAR2,
      ondate                   IN   DATE,
      i_spo_n_srs_id           IN   tbl_tvf_spot_rate.spo_n_srs_id%TYPE,
      i_is_sunday_holiday_flag IN   varchar2
   )
      RETURN NUMBER;

  FUNCTION valid_no_rate (no_rate_date DATE)
      RETURN NUMBER;
  --Below procedure is used to calculate the discount per each and every contratc which contract having rand devaluation info.
  procedure prc_month_disc_calc
  (
   i_com_short_name IN fid_company.com_short_name%TYPE,
   i_region         IN VARCHAR2,
   i_period_month   IN NUMBER,
   i_period_year    IN NUMBER,
   i_entry_oper     IN VARCHAR2,
   i_log_date       IN VARCHAR2,
   i_user_email     IN VARCHAR2,
   O_SUCESS         OUT number
  );
PROCEDURE PRC_INS_DISCOUNT_CALC
(
I_RDI_NUMBER            IN NUMBER,
I_CONTRACT_NUMBER       IN NUMBER,
I_LIC_NUMBER            IN NUMBER,
I_MONTH                 IN NUMBER,
I_YEAR                  IN NUMBER,
I_REVIEW_RATE           IN NUMBER,
I_DISCOUNT_PER_DOLLAR   IN NUMBER,
I_DISCOUNT              IN NUMBER,
I_APPLICABLE_DISCOUNT   IN NUMBER,
I_DISCOUNT_CLAIMED_FLAG IN NUMBER,
I_ENTRY_OPER            IN VARCHAR2,
I_ENTRY_DATE            IN DATE,
I_MODIFY_BY             IN VARCHAR2,
I_MODIFY_ON             IN DATE,
I_UPDATE_COUNT          IN NUMBER,
I_PAY_AMOUNT            IN NUMBER,
I_PAY_NUMBER            IN NUMBER
);
--This function is used to send the mail when ever the routines fails.
  FUNCTION fun_send_email (
      i_user           IN   VARCHAR2,
      i_action         IN   VARCHAR2,
      i_log_date       IN   VARCHAR2,
      i_user_mail_id   IN   VARCHAR2
   )
      RETURN NUMBER;

  FUNCTION get_email_ids (list_in IN VARCHAR2, delimiter_in VARCHAR2)
      RETURN simplearray;

    FUNCTION get_spot_rate_date
  (
     fromcurr                  IN   VARCHAR2,
      tocurr                   IN   VARCHAR2,
      ondate                   IN   DATE,
      i_spo_n_srs_id           IN   tbl_tvf_spot_rate.spo_n_srs_id%TYPE,
      i_is_sunday_holiday_flag IN   varchar2
   )
      RETURN varchar2;

function x_fun_calc_avg
 (
   first_day_rate  IN NUMBER,
   second_day_rate IN NUMBER,
   last_day_rate   IN NUMBER
 )
 RETURN NUMBER;


END X_PKG_RD_MONTH_DISC_CALC;
/
create or replace PACKAGE BODY          "X_PKG_RD_MONTH_DISC_CALC" AS

/******************************************************************************************************************************************
Ver         Date              Author                       Description
-------------------------------------------------------------------------------------------------------------------------------------------
0.1         02-Nov-2016       Zeshan Khan                 Business Req.-
                                                          1. Business wants to get all the spot rates upto 5 decimal places instead of 4.
*******************************************************************************************************************************************/

  /* TODO enter package declarations (types, exceptions, methods etc) here */
  PROCEDURE VALIDATION_CHECK
  (

   I_COM_NUMBER     IN    NUMBER,
   i_region         IN    VARCHAR2,
   i_period_month   IN    NUMBER,
   i_period_year    IN    NUMBER
   )
AS
      no_of_holidays_in_month        NUMBER;
      no_of_sundays_in_month         NUMBER;
      no_of_days_in_month            NUMBER;
      no_of_days_aval                NUMBER;
      eff_no_of_days_aval            NUMBER;
      fromdate_no                    NUMBER;
      todate_no                      NUMBER;
      first_day_of_month             DATE;
      last_day_of_month              DATE;
      l_spot_rate                    NUMBER;
	    l_spotrate_src_code            VARCHAR2(50);
      rate_date                      DATE;
      get_spotrate_date              VARCHAR2(50);
      L_TMP_YEAR                     NUMBER(10);
      L_day                          NUMBER;
      review_date                    varchar2(100);
      L_date_1                       varchar2(100);
      L_date_2                       varchar2(100);
      L_date_3                       varchar2(100);
      L_date_4                       varchar2(100);
      L_PAY_DATE                     varchar2(100);
      PAY_MONTH                      NUMBER;

  BEGIN

   DBMS_OUTPUT.PUT_LINE('In validation check');

   first_day_of_month := to_date('01' || to_char(i_period_month,'09') || to_char(i_period_year) , 'DDMMYYYY');

   last_day_of_month :=
         LAST_DAY (TO_DATE (   '01'
                            || TO_CHAR (i_period_month, '09')
                            || TO_CHAR (i_period_year),
                            'DDMMYYYY'
                           )
                  );

    DELETE X_RD_DISCOUNT_WARNINGS;

   for i in (select fc.*,rdi.* from fid_contract fc,fid_company,x_rand_devaluation_info rdi
                where com_number = con_com_number
                --and   com_number = l_com_number
                and   CON_AGY_COM_NUMBER = I_COM_NUMBER
                and   con_status = 'A'
                and con_number = RDI_CON_NUMBER
                and CON_DEVALUATION_FLAG = 'Y')
   LOOP
        select srs_n_code INTO l_spotrate_src_code
        from tbl_tvf_spot_rate_source where  SRS_N_ID = i.RDI_EXH_RATE_SOURCE;

      -- DBMS_OUTPUT.PUT_LINE('In Contarct Loop');
	    	--DBMS_OUTPUT.PUT_LINE('contarct NUmber:' || i.con_number);

          for j in ( select a.* from
                      fid_license a,
                      fid_licensee,
                      fid_region
                      where lic_con_number = i.con_number
                      and  lic_lee_number = lee_number
                      and  reg_id(+) = lee_split_region
                     AND UPPER (NVL (reg_code, '#')) LIKE
                           UPPER (DECODE (i_region,
                                      '%', NVL (reg_code, '#'),
                                      i_region
                                     )
                             )
                    )
        LOOP

            for k in (  select fp.* from fid_payment fp
                          where PAY_LIC_NUMBER =  j.lic_number
                          AND PAY_STATUS = 'P'
                         -- and PAY_AMOUNT > 0
                          AND PAY_CODE IN ('G','S')
                          and PAY_CUR_CODE = 'USD'
                          and PAY_DATE between  first_day_of_month AND last_day_of_month
                      )
            LOOP

               DBMS_OUTPUT.PUT_LINE('In License Payment Loop');
               DBMS_OUTPUT.PUT_LINE('License NUmber:' || j.lic_number || 'pay_date' || k.pay_date || 'pay Amount' || k.pay_amount);


    IF I.RDI_REVIEW_DATE_CALC = 0    ---'FIXED DATE'
    THEN
            L_DATE_1 := TO_DATE(i.RDI_FIXED_DATE,'DD-MON-YYYY');

             DBMS_OUTPUT.PUT_LINE('IN Validation check 0 ');

             IF valid_no_rate (L_DATE_1) = 1
             THEN
                     IF i.RDI_IS_SUNDAY_HOLIDAY = 'FBD'--1
                     THEN
                        rate_date := to_date(L_DATE_1,'DD-MON-YYYY') + 1;
                     ELSE
                        rate_date := to_date(L_DATE_1,'DD-MON-YYYY') - 1;
                     END IF;
               ELSE
                   rate_date := L_DATE_1;
                END IF;

           get_spotrate_date := get_spot_rate_date('USD','ZAR',rate_date,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);

         -- dbms_output.put_line('get_spotrate_date' || get_spotrate_date );

          IF get_spotrate_date IS NOT NULL
          THEN
            --    DBMS_OUTPUT.PUT_LINE('rate_date'|| rate_date);

               BEGIN
                  INSERT INTO X_RD_DISCOUNT_WARNINGS
                                         (cow_v_warning
                                          ,COW_DT_DATE
                                         )
                                  VALUES (   'Spot Rate from '
                                          || 'USD'
                                          || ' to '
                                          || 'ZAR'
                                          || ' for ' || l_spotrate_src_code || ' for day of '
                                          ||  get_spotrate_date
                                          || ' does not exist.'
                                          ,to_date(get_spotrate_date)
                                         );
                EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                  NULL;
                END;
          END IF;
    ELSIF I.RDI_REVIEW_DATE_CALC = '1'--'DAY OF PAYMENT MONTH'
    THEN
       DBMS_OUTPUT.PUT_LINE('IN Validation check 1');


                if i.RDI_PAY_MONTH_1 is not null
                THEN
                      l_day := i.RDI_PAY_MONTH_1;
                      L_DATE_1 := l_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');

                     --  DBMS_OUTPUT.PUT_LINE('L_DATE_1 :  ' || L_DATE_1);

                end if;

                 IF i.RDI_LAST_DAY_FLAG = 'Y'
                 THEN
                     l_day :=  to_char(last_day(k.PAY_DATE),'DD');
                     L_DATE_1 := l_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');

                 end if;

				 DBMS_OUTPUT.PUT_LINE('L_DATE_1 :  ' || L_DATE_1 );

               IF valid_no_rate (L_DATE_1) = 1
                 THEN
                     IF i.RDI_IS_SUNDAY_HOLIDAY = 'FBD'--1
                     THEN
                        rate_date := to_date(L_DATE_1,'DD-MON-YYYY') + 1;
                     ELSE
                        rate_date := to_date(L_DATE_1,'DD-MON-YYYY') - 1;
                     END IF;
                ELSE
                   rate_date := to_date(L_DATE_1,'DD-MON-YYYY');
                END IF;

               get_spotrate_date := get_spot_rate_date('USD','ZAR',rate_date,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);

              IF get_spotrate_date IS NOT NULL
              THEN

              --  DBMS_OUTPUT.PUT_LINE('rate_date'|| rate_date);

                  BEGIN
                  INSERT INTO X_RD_DISCOUNT_WARNINGS
                                         (cow_v_warning
                                          ,COW_DT_DATE
                                         )
                                  VALUES (   'Spot Rate from '
                                          || 'USD'
                                          || ' to '
                                          || 'ZAR'
                                          || ' for ' || l_spotrate_src_code || ' for day of '
                                          ||  get_spotrate_date
                                          || ' does not exist.'
                                            ,to_date(get_spotrate_date)
                                         );
                EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                  NULL;
                END;
              END IF;


      ELSIF I.RDI_REVIEW_DATE_CALC = 2 --'AVG OF PAYMENT DAYS'
      THEN
          DBMS_OUTPUT.PUT_LINE('IN Validation check 2');

             if i.RDI_PAY_MONTH_1 is not null
              THEN
                l_day := i.RDI_PAY_MONTH_1;
                L_DATE_1 := l_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');

                 DBMS_OUTPUT.PUT_LINE('L_DATE_1 ' || L_DATE_1);
                END IF;

              if i.RDI_PAY_MONTH_2 is not null
              THEN
                l_day := i.RDI_PAY_MONTH_2;
                L_DATE_2 := l_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');

                DBMS_OUTPUT.PUT_LINE('L_DATE_2 ' || L_DATE_2);
              END IF;

              if i.RDI_LAST_DAY_FLAG = 'Y'
              THEN
                 l_day :=  to_char(last_day(k.PAY_DATE),'DD');
                 L_DATE_3 := l_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');
                 DBMS_OUTPUT.PUT_LINE('L_DATE_3 ' || L_DATE_3);
              END IF;

           IF L_DATE_1 is not null
           THEN
            -- DBMS_OUTPUT.PUT_LINE('L_DATE_1' || L_DATE_1);

                  IF valid_no_rate (L_DATE_1) = 1
                  THEN
                     IF i.RDI_IS_SUNDAY_HOLIDAY = 'FBD'--1
                     THEN
                        rate_date := to_date(L_DATE_1,'DD-MON-YYYY') + 1;
                     ELSE
                        rate_date := to_date(L_DATE_1,'DD-MON-YYYY') - 1;
                     END IF;
                ELSE
                   rate_date := to_date(L_DATE_1,'DD-MON-YYYY');
                END IF;

             get_spotrate_date := get_spot_rate_date('USD','ZAR',rate_date,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);

          --  dbms_output.put_line('get_spotrate_date' || get_spotrate_date );

            IF get_spotrate_date IS NOT NULL
            THEN

               --   DBMS_OUTPUT.PUT_LINE('rate_date'|| rate_date);

                BEGIN
                  INSERT INTO X_RD_DISCOUNT_WARNINGS
                                         (cow_v_warning
                                         ,COW_DT_DATE
                                         )
                                  VALUES (   'Spot Rate from '
                                          || 'USD'
                                          || ' to '
                                          || 'ZAR'
                                          || ' for ' || l_spotrate_src_code || ' for day of '
                                          ||  get_spotrate_date
                                          || ' does not exist.'
                                           ,to_date(get_spotrate_date)
                                         );
                EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                  NULL;
                END;
               END IF;
          END IF;
          IF L_DATE_2 is not null
           THEN
                --DBMS_OUTPUT.PUT_LINE('L_DATE_2' || L_DATE_2);

                 IF valid_no_rate (L_DATE_2) = 1
                   THEN
                     IF i.RDI_IS_SUNDAY_HOLIDAY = 'FBD'--1
                     THEN
                        rate_date := TO_dATE(L_DATE_2,'DD-MON-YYYY') + 1;
                     ELSE
                        rate_date := TO_DATE(L_DATE_2,'DD-MON-YYYY') - 1;
                     END IF;
                  ELSE
                   rate_date := TO_DATE(L_DATE_2,'DD-MON-YYYY');
                  END IF;

               get_spotrate_date := get_spot_rate_date('USD','ZAR',rate_date,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);

                -- dbms_output.put_line('get_spotrate_date' || get_spotrate_date );

            IF get_spotrate_date IS NOT NULL
            THEN

              --  DBMS_OUTPUT.PUT_LINE('rate_date'|| rate_date);
                    BEGIN
                      INSERT INTO X_RD_DISCOUNT_WARNINGS
                                             (cow_v_warning
                                             ,COW_DT_DATE
                                             )
                                      VALUES (   'Spot Rate from '
                                              || 'USD'
                                              || ' to '
                                              || 'ZAR'
                                              || ' for ' || l_spotrate_src_code || ' for day of '
                                              ||  get_spotrate_date
                                              || ' does not exist.'
                                              ,to_date(get_spotrate_date)
                                             );
                    EXCEPTION
                    WHEN DUP_VAL_ON_INDEX
                    THEN
                      NULL;
                    END;
             END IF;
          END IF;

         IF L_DATE_3 is not null
         THEN

             -- DBMS_OUTPUT.PUT_LINE('L_DATE_3' || L_DATE_3);

               IF valid_no_rate (L_DATE_3) = 1
                   THEN
                       IF i.RDI_IS_SUNDAY_HOLIDAY = 'FBD'--1
                       THEN
                          rate_date := TO_DATE(L_DATE_3,'DD-MON-YYYY') + 1;
                       ELSE
                          rate_date := TO_DATE(L_DATE_3,'DD-MON-YYYY') - 1;
                       END IF;
                  ELSE
                   rate_date := TO_DATE(L_DATE_3,'DD-MON-YYYY');
                  END IF;

                get_spotrate_date := get_spot_rate_date('USD','ZAR',rate_date,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);

              --   dbms_output.put_line('get_spotrate_date' || get_spotrate_date );

               IF get_spotrate_date IS NOT NULL
                THEN

                --  DBMS_OUTPUT.PUT_LINE('rate_date'|| rate_date);

                   BEGIN
                    INSERT INTO X_RD_DISCOUNT_WARNINGS
                                           (cow_v_warning
                                           ,COW_DT_DATE
                                           )
                                    VALUES (   'Spot Rate from '
                                            || 'USD'
                                            || ' to '
                                            || 'ZAR'
                                            || ' for ' || l_spotrate_src_code || ' for day of '
                                            ||  get_spotrate_date
                                            || ' does not exist.'
                                            ,to_date(get_spotrate_date)
                                           );
                  EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                    NULL;
                  END;
                  END IF;
           END IF;


    ELSIF I.RDI_REVIEW_DATE_CALC = 3--'NO OF PAST MONTHS'
    THEN

       DBMS_OUTPUT.PUT_LINE('No of past months excluding pay months ');

        L_DATE_1 :=  to_char(to_date('01' || '-' || to_char(add_months(k.PAY_DATE,- i.RDI_NO_PAST_MON),'MON-YYYY'),'DD-MON-YYYY'),'DD-MON-YYYY');

        L_DATE_2 :=   to_char(ADD_months(to_date('01' || '-' || to_char(add_months(k.PAY_DATE,- i.RDI_NO_PAST_MON),'MON-YYYY'),'DD-MON-YYYY'),i.RDI_NO_PAST_MON) - 1,'DD-MON-YYYY') ;

       DBMS_OUTPUT.PUT_LINE('L_DATE_1' || L_DATE_1 || ' ' || 'L_DATE_2' || L_DATE_2) ;


        For dt in (select to_char(l_date,'DD-MON-RRRR') l_date from ( SELECT (TO_DATE (L_DATE_1, 'DD-MON-RRRR') + ROWNUM - 1) l_date
                                                    FROM user_objects
                                                    WHERE (TO_DATE (L_DATE_1, 'DD-MON-RRRR') + ROWNUM - 1)
                                                    BETWEEN TO_DATE (L_DATE_1, 'DD-MON-RRRR')
                                                    AND TO_DATE (L_DATE_2, 'DD-MON-RRRR') )
                           where l_Date not in ( SELECT thol_holiday_date
                                    FROM tbl_tvf_holidays
                                    WHERE thol_holiday_date BETWEEN To_date(L_DATE_1,'DD-MON-RRRR') AND to_date(L_DATE_2,'DD-MON-RRRR'))
                      )
              LOOP

                fromdate_no := TO_NUMBER (TO_CHAR (to_date(dt.l_date,'DD-MON-YYYY'), 'YYYYMMDD'));

             --   DBMS_OUTPUT.PUT_LINE('i.l_date'|| i.l_date);

               --- DBMS_OUTPUT.PUT_LINE('fromdate_no' || fromdate_no);

                BEGIN
                 SELECT NVL(SPO_N_RATE,0)
                    INTO l_spot_rate
                    FROM tbl_tvf_spot_rate
                  WHERE  spo_v_cur_code = 'USD'
                     AND spo_v_cur_code_2 = 'ZAR'
                     AND spo_n_srs_id = i.RDI_EXH_RATE_SOURCE
                     AND  spo_n_per_year
                   || LPAD (spo_n_per_month, 2, 0)
                   || LPAD (spo_n_per_day, 2, 0) = fromdate_no;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  l_spot_rate := 0;
                END;

                ---   DBMS_OUTPUT.PUT_LINE('l_spot_rate' || l_spot_rate);

                   IF nvl(l_spot_rate,0) <= 0
                   THEN
                      BEGIN
                       --  DBMS_OUTPUT.PUT_LINE('In Insert');
                           INSERT INTO X_RD_DISCOUNT_WARNINGS
                                             (cow_v_warning
                                             ,COW_DT_DATE
                                             )
                                      VALUES (   'Spot Rate from '
                                              || 'USD'
                                              || ' to '
                                              || 'ZAR'
                                              || ' for ' || l_spotrate_src_code || ' for day of '
                                              || TO_CHAR (to_date(dt.l_date,'DD-MON-YYYY'), 'DD-Mon-YYYY')
                                              || ' does not exist.'
                                              ,to_date(dt.l_date)
                                             );
                       EXCEPTION
                           WHEN DUP_VAL_ON_INDEX
                           THEN
                              NULL;
                        END;
                   END IF;

                fromdate_no := NULL;
              END LOOP;

      ELSIF I.RDI_REVIEW_DATE_CALC = 4--'ACCOUTING BY MONTHS'
      THEN
          dbms_output.put_line('In validation check 4');
       -- dbms_output.put_line('i_date_1' || i_date_1);
        --  dbms_output.put_line('i_date_2' || i_date_2);

          IF i.RDI_ACC_TYPE = 'TY'
           THEN
		       DBMS_OUTPUT.PUT_LINE('IN i.RDI_ACC_TYPE = TY');

              L_TMP_YEAR := to_char(k.pay_date,'RRRR') ;


              --DBMS_OUTPUT.PUT_LINE('L_TMP_YEAR:'||L_TMP_YEAR);
              -- DBMS_OUTPUT.PUT_LINE('i.RDI_SELECT_MON:'||i.RDI_SELECT_MON);
              -- dbms_output.PUT_LINE('review_month' || review_month);


                    select RDAM_MONTH_NO
                      INTO PAY_MONTH
                    from x_rd_acc_month_info
                    where rdam_month_name = to_char(k.pay_date,'Mon')
                    AND   rdam_rdi_number = i.rdi_number;

                 L_DATE_1 := to_char( TO_date(i.RDI_SELECT_MON ||'-'||L_TMP_YEAR,'Mon-RRRR'), 'DD-Mon-YYYY');
                  dbms_output.put_line('L_DATE_1' || L_DATE_1);
                 L_DATE_2 := to_char( ADD_MONTHS(L_DATE_1,6),'DD-Mon-YYYY');
                   dbms_output.put_line('L_DATE_2' || L_DATE_2);

                 IF PAY_MONTH BETWEEN 1 and 6
                  THEN

                    dbms_output.put_line('1');

                    l_pay_date  := to_char(k.pay_date,'Mon-YYYY');

                    dbms_output.put_line('l_pay_date' || l_pay_date);

                     --review_date := review_date_1;

                      IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(L_DATE_1,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
                      THEN
                      --  dbms_output.put_line('IF l_pay_date < L_DATE_1');
                        review_date :=  to_char(to_date(L_DATE_1,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(L_DATE_1,'DD-Mon_YYYY'),'YYYY') - 1 );
                      ELSE
                     --   dbms_output.put_line('else  l_pay_date < review_date_1');
                        review_date := L_DATE_1;
                      END IF;


                 elsif PAY_MONTH BETWEEN 7 and 12
                 THEN
                   dbms_output.put_line('2');

                      l_pay_date  := to_char(k.pay_date,'Mon-YYYY');

                      dbms_output.put_line('l_pay_date' || l_pay_date);

                     -- review_date := review_date_2;

                    IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(L_DATE_2,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
                      THEN
                     --   dbms_output.put_line('IF l_pay_date < L_DATE_2');
                          review_date :=  to_char(to_date(L_DATE_2,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(L_DATE_2,'DD-Mon_YYYY'),'YYYY') - 1 );
                         -- review_date := add_months(to_date(review_date_2,'DD-Mon-YYYY'),-12);
                         DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
                      ELSE
                       -- dbms_output.put_line('else l_pay_date < review_date_2');
                        review_date := L_DATE_2;
                      END IF;
                 end if;

             -- dbms_output.put_line('review_date_1' || review_date_1 || 'review_date_2' || review_date_2 );
           ELSE
    		       DBMS_OUTPUT.PUT_LINE(' i.RDI_ACC_TYPE = QTY');

               select RDAM_MONTH_NO
                      INTO PAY_MONTH
                    from x_rd_acc_month_info
                    where rdam_month_name = to_char(k.pay_date,'Mon')
                    AND   rdam_rdi_number = i.rdi_number;


               L_TMP_YEAR := to_char(k.pay_date,'RRRR') ;

               L_DATE_1 := to_char(To_date(i.RDI_SELECT_MON || '-' || L_TMP_YEAR,'Mon-RRRR'),'DD-MON-YYYY') ;
               L_DATE_2 := to_char(ADD_MONTHS(L_DATE_1,3),'DD-MON-YYYY') ;
               L_DATE_3 := to_char(ADD_MONTHS(L_DATE_2,3),'DD-MON-YYYY');
               L_DATE_4 := to_char(ADD_MONTHS(L_DATE_3,3),'DD-MON-YYYY');
               l_pay_date  := to_char(k.pay_date,'Mon-YYYY');

               DBMS_OUTPUT.PUT_LINE('L_DATE_1' || L_DATE_1);
               DBMS_OUTPUT.PUT_LINE('L_DATE_2' || L_DATE_2);
               DBMS_OUTPUT.PUT_LINE('L_DATE_3' || L_DATE_3);
               DBMS_OUTPUT.PUT_LINE('L_DATE_4' || L_DATE_4);
               dbms_output.put_line('pay_date' ||  l_pay_date);
               dbms_output.put_line('PAY_MONTH' || PAY_MONTH);

                  IF PAY_MONTH BETWEEN 1 and 3
                  THEN
                     DBMS_OUTPUT.PUT_LINE('1');
					            IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(L_DATE_1,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
                      THEN
                        ---dbms_output.put_line('IF l_pay_date < L_DATE_1');
                          review_date :=  to_char(to_date(L_DATE_1,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(L_DATE_1,'DD-Mon_YYYY'),'YYYY') - 1 );
                        -- DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
                      ELSE
                        --dbms_output.put_line('else l_pay_date < L_DATE_1');
                        review_date := L_DATE_1;
                      END IF;

                  elsif PAY_MONTH BETWEEN 4 and 6
                  THEN
                  DBMS_OUTPUT.PUT_LINE('2');
				            IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(L_DATE_2,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
                     THEN
                        --dbms_output.put_line('IF l_pay_date < L_DATE_2');
                          review_date :=  to_char(to_date(L_DATE_2,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(L_DATE_2,'DD-Mon_YYYY'),'YYYY') - 1 );
                         -- review_date := add_months(to_date(review_date_2,'DD-Mon-YYYY'),-12);
                       --  DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
                      ELSE
                        --dbms_output.put_line('else l_pay_date < L_DATE_2');
                        review_date := L_DATE_2;
                      END IF;

                  elsif PAY_MONTH BETWEEN 7 and 9
                  THEN
                    DBMS_OUTPUT.PUT_LINE('3');
					 IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(L_DATE_3,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
                     THEN
                       -- dbms_output.put_line('IF l_pay_date < L_DATE_3');
                          review_date :=  to_char(to_date(L_DATE_3,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(L_DATE_3,'DD-Mon_YYYY'),'YYYY') - 1 );
                         -- review_date := add_months(to_date(review_date_2,'DD-Mon-YYYY'),-12);
                         --DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
                      ELSE
                        --dbms_output.put_line('else l_pay_date < L_DATE_3');
                        review_date := L_DATE_3;
                      END IF;

                  elsif PAY_MONTH BETWEEN 10 and 12
                  THEN
                   DBMS_OUTPUT.PUT_LINE('4');
				     IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(L_DATE_4,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
                     THEN
                       -- dbms_output.put_line('IF l_pay_date < L_DATE_4');
                          review_date :=  to_char(to_date(L_DATE_4,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(L_DATE_4,'DD-Mon_YYYY'),'YYYY') - 1 );
                         -- review_date := add_months(to_date(review_date_2,'DD-Mon-YYYY'),-12);
                        --- DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
                      ELSE
                      --  dbms_output.put_line('else l_pay_date < L_DATE_4');
                        review_date := L_DATE_4;
                      END IF;

                 END IF;
           END IF;


        -- first_day_of_month := i_date_1;
         --last_day_of_month  := last_day(i_date_2);

        /*IF  i_date_1 is not null and i_date_2 is not null
        THEN
         fromdate_no := TO_NUMBER (TO_CHAR (I_DATE_1, 'YYYYMMDD'));
         todate_no   := TO_NUMBER (TO_CHAR (last_day(I_DATE_1), 'YYYYMMDD'));
         no_of_days_in_month := (I_DATE_2 - I_DATE_1) + 1;*/

         IF i.RDI_ACC_FLAG = 'AOM'
         THEN

           For dt in (select to_char(l_date,'DD-MON-RRRR') l_date from ( SELECT (TO_DATE (review_date, 'DD-MON-RRRR') + ROWNUM - 1) l_date
                                                      FROM user_objects
                                                      WHERE (TO_DATE (review_date, 'DD-MON-RRRR') + ROWNUM - 1)
                                                      BETWEEN TO_DATE (review_date, 'DD-MON-RRRR')
                                                      AND TO_DATE (last_Day(review_date), 'DD-MON-RRRR') )
                             where l_Date not in ( SELECT thol_holiday_date
                                      FROM tbl_tvf_holidays
                                      WHERE thol_holiday_date BETWEEN To_date(review_date,'DD-MON-RRRR') AND to_date(last_Day(review_date),'DD-MON-RRRR'))
                        )
                LOOP

                --   DBMS_OUTPUT.PUT_LINE('i.l_date' ||dt.l_date);


                fromdate_no := TO_NUMBER (TO_CHAR (to_date(dt.l_date,'DD-MON-YYYY'), 'YYYYMMDD'));


             --   dbms_output.put_line('fromdate_no' || fromdate_no);

                BEGIN
                 SELECT SPO_N_RATE
                    INTO l_spot_rate
                    FROM tbl_tvf_spot_rate
                  WHERE  spo_v_cur_code = 'USD'
                     AND spo_v_cur_code_2 = 'ZAR'
                     AND spo_n_srs_id = i.RDI_EXH_RATE_SOURCE
                     AND  spo_n_per_year
                   || LPAD (spo_n_per_month, 2, 0)
                   || LPAD (spo_n_per_day, 2, 0) = fromdate_no;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                 l_spot_rate := 0;
                END;

                 --  dbms_output.put_line('l_spot_rate' || l_spot_rate);

                   IF nvl(l_spot_rate,0) <= 0
                   THEN
                      BEGIN
                           INSERT INTO X_RD_DISCOUNT_WARNINGS
                                             (cow_v_warning
                                              ,COW_DT_DATE
                                             )
                                      VALUES (   'Spot Rate from '
                                              || 'USD'
                                              || ' to '
                                              || 'ZAR'
                                              || ' for ' || l_spotrate_src_code || ' for day of '
                                              || TO_CHAR (to_date(dt.l_date,'DD-MON-YYYY'), 'DD-Mon-YYYY')
                                              || ' does not exist.'
                                               ,to_date(dt.l_date)
                                             );
                        EXCEPTION
                           WHEN DUP_VAL_ON_INDEX
                           THEN
                              NULL;
                        END;
                   END IF;

                fromdate_no := NULL;
              END LOOP;

          else
              if i.RDI_PAY_MONTH_1 > 0 --is not null
              THEN
                DBMS_OUTPUT.PUT_LINE('i.RDI_PAY_MONTH_1 > 0');

                -- L_day := i.RDI_PAY_MONTH_1;

                 --DBMS_OUTPUT.PUT_LINE('L_day' || L_day);

                  L_DATE_1 :=  to_char( to_date(i.RDI_PAY_MONTH_1 || '-' || to_char(to_date(review_date,'DD-MON-YYYY'),'MON-YYYY'),'DD-MON-YYYY'),'DD-MON-YYYY');
                 -- DBMS_OUTPUT.PUT_LINE('review_date-' || review_date);
                  DBMS_OUTPUT.PUT_LINE('L_DATE_1' || L_DATE_1);

                IF valid_no_rate (L_DATE_1) = 1
                THEN
                   IF i.RDI_IS_SUNDAY_HOLIDAY = 'FBD'--1
                   THEN
                      rate_date := TO_DATE(L_DATE_1,'DD-MON-YYYY') + 1;
                   ELSE
                      rate_date := TO_DATE(L_DATE_1,'DD-MON-YYYY') - 1;
                   END IF;
                ELSE
                   rate_date := TO_DATE(L_DATE_1,'DD-MON-YYYY');
                END IF;

              get_spotrate_date := get_spot_rate_date('USD','ZAR',rate_date,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);

               --dbms_output.put_line('get_spotrate_date' || get_spotrate_date );

                  IF get_spotrate_date IS NOT NULL
                  THEN

                    BEGIN
                      INSERT INTO X_RD_DISCOUNT_WARNINGS
                                             (cow_v_warning
                                               ,COW_DT_DATE
                                             )
                                      VALUES (   'Spot Rate from '
                                              || 'USD'
                                              || ' to '
                                              || 'ZAR'
                                              || ' for ' || l_spotrate_src_code || ' for day of '
                                              || get_spotrate_date
                                              || ' does not exist.'
                                              ,to_date(get_spotrate_date)
                                             );
                     EXCEPTION
                      WHEN DUP_VAL_ON_INDEX
                      THEN
                        NULL;
                      END;
                    END IF;
               END IF;

             IF i.RDI_PAY_MONTH_2 > 0
             THEN

                 DBMS_OUTPUT.PUT_LINE(' i.RDI_PAY_MONTH_2 > 0');

                  L_DATE_2 :=  to_char( to_date(i.RDI_PAY_MONTH_2 || '-' || to_char(to_date(review_date,'DD-MON-YYYY'),'MON-YYYY'),'DD-MON-YYYY'),'DD-MON-YYYY');

                  DBMS_OUTPUT.PUT_LINE('L_DATE_2' || L_DATE_2);

                  IF valid_no_rate (L_DATE_2) = 1
                  THEN
                   IF i.RDI_IS_SUNDAY_HOLIDAY = 'FBD'--1
                   THEN
                      rate_date := TO_DATE(L_DATE_2,'DD-MON-YYYY') + 1;
                   ELSE
                      rate_date := TO_DATE(L_DATE_2,'DD-MON-YYYY') - 1;
                   END IF;
                ELSE
                   rate_date := TO_DATE(L_DATE_2,'DD-MON-YYYY');
                END IF;

               get_spotrate_date := get_spot_rate_date('USD','ZAR',rate_date,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);

              -- dbms_output.put_line('get_spotrate_date' || get_spotrate_date );

                  IF get_spotrate_date IS NOT NULL
                  THEN

                   BEGIN
                      INSERT INTO X_RD_DISCOUNT_WARNINGS
                                             (cow_v_warning
                                             ,COW_DT_DATE
                                             )
                                      VALUES (   'Spot Rate from '
                                              || 'USD'
                                              || ' to '
                                              || 'ZAR'
                                              || ' for ' || l_spotrate_src_code || ' for day of '
                                              ||  get_spotrate_date
                                              || ' does not exist.'
                                              ,to_date(get_spotrate_date)
                                             );
                  EXCEPTION
                    WHEN DUP_VAL_ON_INDEX
                    THEN
                     NULL;
                   END;
                    END IF;
               END IF;

                IF i.RDI_LAST_DAY_FLAG = 'Y'
                THEN
                   DBMS_OUTPUT.PUT_LINE('i.RDI_LAST_DAY_FLAG');

                  L_day :=  to_char(last_day(review_date),'DD');

                  L_DATE_3 :=  to_char( to_date(L_day || '-' || to_char(to_date(review_date,'DD-MON-YYYY'),'MON-YYYY'),'DD-MON-YYYY'),'DD-MON-YYYY');

                      DBMS_OUTPUT.PUT_LINE('L_DATE_3' || L_DATE_3);
                  IF valid_no_rate (L_DATE_3) = 1
                  THEN
                   IF i.RDI_IS_SUNDAY_HOLIDAY = 'FBD'--1
                   THEN
                      rate_date := TO_DATE(L_DATE_3,'DD-MON-YYYY') + 1;
                   ELSE
                      rate_date := TO_DATE(L_DATE_3,'DD-MON-YYYY') - 1;
                   END IF;
                ELSE
                   rate_date := TO_DATE(L_DATE_3,'DD-MON-YYYY');
                END IF;

               get_spotrate_date :=  get_spot_rate_date('USD','ZAR',rate_date,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);

              -- dbms_output.put_line('get_spotrate_date' || get_spotrate_date );

                  IF get_spotrate_date IS NOT NULL
                  THEN

                   BEGIN
                    INSERT INTO X_RD_DISCOUNT_WARNINGS
                                           (cow_v_warning
                                            ,COW_DT_DATE
                                           )
                                    VALUES (   'Spot Rate from '
                                            || 'USD'
                                            || ' to '
                                            || 'ZAR'
                                            || ' for ' || l_spotrate_src_code || ' for day of '
                                            ||  get_spotrate_date
                                            || ' does not exist.'
                                            ,to_date(get_spotrate_date)
                                           );
                 EXCEPTION
                  WHEN DUP_VAL_ON_INDEX
                  THEN
                   NULL;
                END;
                    END IF;
                  END IF;
              end if;
          END IF;
      L_day        := NULL;
      review_date  := NULL;
      L_date_1     := NULL;
      L_date_2     := NULL;
      L_date_3     := NULL;
      L_date_4     := NULL;
      L_PAY_DATE   := NULL;
      PAY_MONTH    := NULL;
       END LOOP;
    END LOOP;
  END LOOP;
    COMMIT;

 /* EXCEPTION
  WHEN OTHERS THEN
    NULL;*/
  END VALIDATION_CHECK;

    FUNCTION get_spot_rate
  (
      fromcurr                 IN   VARCHAR2,
      tocurr                   IN   VARCHAR2,
      ondate                   IN   DATE,
      i_spo_n_srs_id           IN   tbl_tvf_spot_rate.spo_n_srs_id%TYPE,
      i_is_sunday_holiday_flag IN   varchar2
   )
      RETURN NUMBER
   IS
      spotrate    NUMBER;
      perday      NUMBER;
      permonth    NUMBER;
      peryear     NUMBER;
      rate_date   DATE;
   BEGIN
      rate_date := ondate;

      <<next_day_rate>>
      perday := TO_CHAR (rate_date, 'DD');
      permonth := TO_CHAR (rate_date, 'MM');
      peryear := TO_CHAR (rate_date, 'YYYY');

      BEGIN
         IF fromcurr = tocurr
         THEN
            spotrate := 1;
         ELSE
            SELECT spo_n_rate
              INTO spotrate
              FROM tbl_tvf_spot_rate
             WHERE spo_v_cur_code = fromcurr
               AND spo_v_cur_code_2 = tocurr
               AND spo_n_per_day = perday
               AND spo_n_per_month = permonth
               AND spo_n_per_year = peryear
               AND spo_n_srs_id = i_spo_n_srs_id;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            --IF i_spo_n_srs_id = 1
            --THEN
            IF valid_no_rate (rate_date) = 1
            THEN
               IF i_is_sunday_holiday_flag = 'FBD'--1
               THEN
                  rate_date := rate_date + 1;
                  GOTO next_day_rate;
               ELSE
                  rate_date := rate_date - 1;
                  GOTO next_day_rate;
               END IF;
            ELSE
               spotrate := '';
            END IF;
      END;

      RETURN spotrate;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601,
                                     SUBSTR (SQLERRM, 1, 200)
                                  || ' - While fetching Spot Rate'
                                 );
   END get_spot_rate;

  FUNCTION valid_no_rate (no_rate_date DATE)
      RETURN NUMBER
   AS
      is_holiday         NUMBER;
      day_of_week        VARCHAR2 (10);
      is_valid_no_rate   NUMBER;
   BEGIN
   -- DBMS_OUTPUT.PUT_LINE('IN valid_no_rate');
    --DBMS_OUTPUT.PUT_LINE(no_rate_date);

      is_holiday := 0;
      day_of_week := NULL;

      SELECT COUNT (*)
        INTO is_holiday
        FROM tbl_tvf_holidays
       WHERE thol_holiday_date = no_rate_date;

      SELECT TO_CHAR (no_rate_date, 'DAY')
        INTO day_of_week
        FROM DUAL;

      -- DBMS_OUTPUT.PUT_LINE('DAYS Of WEEK-' || day_of_week || 'COUNT OF HOLIDAY-' ||is_holiday);

      IF (is_holiday = 1 OR TRIM(UPPER (day_of_week)) = 'SUNDAY')
      THEN
        -- DBMS_OUTPUT.PUT_LINE(' IF is_holiday = 1 OR UPPER (day_of_week) = SUNDAY');
         is_valid_no_rate := 1;
      ELSE
         is_valid_no_rate := 0;
      END IF;

      RETURN is_valid_no_rate;
   END valid_no_rate;

  procedure prc_month_disc_calc
  (
   i_com_short_name IN fid_company.com_short_name%TYPE,
   i_region         IN VARCHAR2,
   i_period_month   IN NUMBER,
   i_period_year    IN NUMBER,
   i_entry_oper     IN VARCHAR2,
   i_log_date       IN VARCHAR2,
   i_user_email     IN VARCHAR2,
   O_SUCESS         OUT number
  )
  AS
  l_com_number         NUMBER;
  l_com_name           varchar2(100);
  send_email           EXCEPTION;
  first_day_of_month    DATE;
  last_day_of_month     DATE;
  review_day            NUMBER;
  review_date           varchar2(100);
  review_date_1         varchar2(100);
  review_date_2         varchar2(100);
  review_date_3         varchar2(100);
  review_date_4         varchar2(100);
  no_of_warnings        NUMBER;
  review_spot_rate      NUMBER;
  review_spot_rate_1    NUMBER;
  review_spot_rate_2    NUMBER;
  review_spot_rate_3    NUMBER;
  discount_per_dollar  NUMBER;
  discount             NUMBER;
  applicable_discount  NUMBER;
  threshold_discount   NUMBER;
  l_count              NUMBER := 0;
  L_TMP_YEAR           VARCHAR2(4);
  l_tmp_no_of_days     number;
  l_spot_rate          VARCHAR2(1);
  l_pay_date           varchar2(100);
  review_month         VARCHAR2(10);
  PAY_MONTH            NUMBER;
  review_month_1       NUMBER;
  review_month_2       NUMBER;
  l_temp_last_day      varchar2(100);
  l_send_email         NUMBER;
  open_month           date;

 BEGIN

   first_day_of_month := to_date('01' || to_char(i_period_month,'09') || to_char(i_period_year) , 'DDMMYYYY');

   last_day_of_month :=
         LAST_DAY (TO_DATE (   '01'
                            || TO_CHAR (i_period_month, '09')
                            || TO_CHAR (i_period_year),
                            'DDMMYYYY'
                           )
                  );

	 DBMS_OUTPUT.PUT_LINE('first_day_of_month' || first_day_of_month);
	 DBMS_OUTPUT.PUT_LINE('last_day_of_month' || last_day_of_month);



     --VALIDATION for Channel Comp --WHN VALIDATE ITEM of Channel Company Short Name
      BEGIN
         SELECT com_number, com_name
           INTO l_com_number, l_com_name
           FROM fid_company
          WHERE com_short_name = i_com_short_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20423, 'Invalid Channel Company');
      END;

    DBMS_OUTPUT.PUT_LINE('l_com_number' ||l_com_number ||'l_com_name' || l_com_name);

  	VALIDATION_CHECK(l_com_number,i_region,i_period_month,i_period_year);

				select count(1)
				INTO no_of_warnings
			  from  X_RD_DISCOUNT_WARNINGS;

        DBMS_OUTPUT.PUT_LINE('no_of_warnings'|| no_of_warnings);

 	IF no_of_warnings > 0
    THEN
        RAISE send_email;
    ELSE
			for i in (select fc.*,rdi.* from fid_contract fc,fid_company,x_rand_devaluation_info rdi
						where com_number = con_com_number
						--and   com_number = l_com_number
						and   CON_AGY_COM_NUMBER = l_com_number
						and   con_status = 'A'
						and con_number = RDI_CON_NUMBER
						and CON_DEVALUATION_FLAG = 'Y')
		   LOOP
			--DBMS_OUTPUT.PUT_LINE('In Contarct Loop');
			--	DBMS_OUTPUT.PUT_LINE('contarct NUmber:' || i.con_number);

			  for j in ( select a.* from
						  fid_license a,
						  fid_licensee,
						  fid_region
						  where lic_con_number = i.con_number
						  and  lic_lee_number = lee_number
						  and  reg_id(+) = lee_split_region
						 AND UPPER (NVL (reg_code, '#')) LIKE
							   UPPER (DECODE (i_region,
										  '%', NVL (reg_code, '#'),
										  i_region
										 )
								 )
						)
			LOOP

			  --DBMS_OUTPUT.PUT_LINE('In License Loop');
				--  DBMS_OUTPUT.PUT_LINE('License NUmber:' || j.lic_number);

				for k in (  select fp.* from fid_payment fp
							  where PAY_LIC_NUMBER =  j.lic_number
							  AND PAY_STATUS = 'P'
							 -- and PAY_AMOUNT > 0
							  AND PAY_CODE IN ('G','S')
							  and PAY_CUR_CODE = 'USD'
							  and PAY_DATE between  first_day_of_month AND last_day_of_month
						  )
				LOOP

				  DBMS_OUTPUT.PUT_LINE('In License Payment Loop');
				  DBMS_OUTPUT.PUT_LINE('License NUmber:' || j.lic_number || 'pay_date' || k.pay_date || 'pay Amount' || k.pay_amount);

				  IF i.RDI_REVIEW_DATE_CALC = 0--'FIXED DATE'
				  THEN

					DBMS_OUTPUT.PUT_LINE('In Fixed date ');

					review_date_1 := i.RDI_FIXED_DATE;

					  DBMS_OUTPUT.PUT_LINE('review_date_1 ' || review_date_1);

					review_spot_rate :=  ROUND(get_spot_rate('USD','ZAR',review_date_1,i.RDI_EXH_RATE_SOURCE ,i.RDI_IS_SUNDAY_HOLIDAY),5);   -- [Ver 0.1]

				  --  DBMS_OUTPUT.PUT_LINE('review_spot_rate:' || review_spot_rate);

				  elsif i.RDI_REVIEW_DATE_CALC = 1 ---MOnthly -on a day of payment month
				  THEN

					  DBMS_OUTPUT.PUT_LINE('MOnthly -on a day of payment month ');

						if i.RDI_PAY_MONTH_1 is not null
						THEN
							  review_day := i.RDI_PAY_MONTH_1;
							  review_date_1 := review_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');

							   DBMS_OUTPUT.PUT_LINE('review date 1 :  ' || review_date_1 );

						end if;

						 IF i.RDI_LAST_DAY_FLAG = 'Y'
						 THEN
							 review_day :=  to_char(last_day(k.PAY_DATE),'DD');
							 review_date_1 := review_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');

							  DBMS_OUTPUT.PUT_LINE('review date 1 :  ' || review_date_1 );
						 end if;

						 review_spot_rate_1 := ROUND(get_spot_rate('USD','ZAR',review_date_1,i.RDI_EXH_RATE_SOURCE ,i.RDI_IS_SUNDAY_HOLIDAY),5) ;   -- [Ver 0.1]
						 review_spot_rate := review_spot_rate_1;


					DBMS_OUTPUT.PUT_LINE('review_spot_rate:' || review_spot_rate);

				  elsif i.RDI_REVIEW_DATE_CALC = 2 --Avg of days of payment month
				  THEN

						DBMS_OUTPUT.PUT_LINE('Avg of days of payment month ');

								if i.RDI_PAY_MONTH_1 is not null
								THEN
								  review_day := i.RDI_PAY_MONTH_1;
								  review_date_1 := review_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');

								   DBMS_OUTPUT.PUT_LINE('review_date_1 ' || review_date_1);
								  END IF;

								if i.RDI_PAY_MONTH_2 is not null
								THEN
								  review_day := i.RDI_PAY_MONTH_2;
								  review_date_2 := review_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');

								  DBMS_OUTPUT.PUT_LINE('review_date_2 ' || review_date_2);
								END IF;

								if i.RDI_LAST_DAY_FLAG = 'Y'
								THEN
								   review_day :=  to_char(last_day(k.PAY_DATE),'DD');
								   review_date_3 := review_day || '-' || to_char(k.PAY_DATE,'MON-YYYY');
								   DBMS_OUTPUT.PUT_LINE('review_date_3 ' || review_date_3);
								END IF;



								review_spot_rate_1 := get_spot_rate('USD','ZAR',review_date_1,i.RDI_EXH_RATE_SOURCE ,i.RDI_IS_SUNDAY_HOLIDAY);

								--  DBMS_OUTPUT.PUT_LINE('review_spot_rate_1 ' || review_spot_rate_1);

								review_spot_rate_2 := get_spot_rate('USD','ZAR',review_date_2,i.RDI_EXH_RATE_SOURCE ,i.RDI_IS_SUNDAY_HOLIDAY);

								  --DBMS_OUTPUT.PUT_LINE('review_spot_rate_2 ' || review_spot_rate_2);

								review_spot_rate_3 := get_spot_rate('USD','ZAR',review_date_3,i.RDI_EXH_RATE_SOURCE ,i.RDI_IS_SUNDAY_HOLIDAY);

								  ---DBMS_OUTPUT.PUT_LINE('review_spot_rate_3 ' || review_spot_rate_3);


							  IF  i.RDI_PAY_MONTH_1 is  null
								   OR i.RDI_PAY_MONTH_2 is  null
									   OR  i.RDI_LAST_DAY_FLAG != 'Y'
							  THEN
							 --    dbms_output.put_line('1');
							  --   dbms_output.put_line('review_spot_rate_3' || review_spot_rate_3);
								review_spot_rate := ROUND( ( NVL(review_spot_rate_1,0) + NVL(review_spot_rate_2,0) + nvl(review_spot_rate_3,0) )/ 2 ,5);   -- [Ver 0.1]
							  ELSIF i.RDI_PAY_MONTH_1 is not null and i.RDI_PAY_MONTH_2 is not null AND i.RDI_LAST_DAY_FLAG = 'Y'
							  THEN
								dbms_output.put_line('2');
							   review_spot_rate :=  ROUND( ( NVL(review_spot_rate_1,0) + NVL(review_spot_rate_2,0) + NVL(review_spot_rate_3,0) ) / 3 ,5)  ;   -- [Ver 0.1]
							  END IF;

						DBMS_OUTPUT.PUT_LINE('review_spot_rate:' || review_spot_rate);

				  elsif i.RDI_REVIEW_DATE_CALC = 3 --No of past months excluding pay months
				  THEN

					  DBMS_OUTPUT.PUT_LINE('No of past months excluding pay months ');

					review_date_1 :=  to_char(to_date('01' || '-' || to_char(add_months(k.PAY_DATE,- i.RDI_NO_PAST_MON),'MON-YYYY'),'DD-MON-YYYY'),'DD-MON-YYYY');

					review_date_2 :=   to_char(ADD_months(to_date('01' || '-' || to_char(add_months(k.PAY_DATE,- i.RDI_NO_PAST_MON),'MON-YYYY'),'DD-MON-YYYY'),i.RDI_NO_PAST_MON) - 1,'DD-MON-YYYY') ;


				   DBMS_OUTPUT.PUT_LINE('review_date_1 ' || review_date_1);
				   DBMS_OUTPUT.PUT_LINE('review_date_2 ' || review_date_2);
				 --  dbmS_OUTPUT.PUT_LINE('i.RDI_EXH_RATE_SOURCE' || i.RDI_EXH_RATE_SOURCE);


					   select ( to_number(to_date(review_date_2,'DD-MON-YYYY') -  to_date(review_date_1,'DD-MON-YYYY') ) + 1 )
					   -  ( select count(1) from tbl_tvf_holidays where thol_holiday_date
							  between to_date(review_date_1,'DD-MON-YYYY') and to_date(review_date_2,'DD-MON-YYYY') )
						INTO l_tmp_no_of_days
						from dual;

						DBMS_OUTPUT.PUT_LINE('l_tmp_no_of_days' || l_tmp_no_of_days);

						select ROUND( ( sum(SPO_N_RATE) / l_tmp_no_of_days ) , 5)   -- [Ver 0.1]
						 INTO review_spot_rate
							  from tbl_tvf_spot_rate
							  where spo_v_cur_code = 'USD'
							  and spo_v_cur_code_2 = 'ZAR'
							  and SPO_N_SRS_ID = i.RDI_EXH_RATE_SOURCE
							  and TO_DATE(to_char(to_date(SPO_N_PER_DAY || '-' || SPO_N_PER_MONTH || '-' || SPO_N_PER_YEAR,'DD-MM-YYYY'),'DD-MON-YYYY'))
							  between  TO_DATE(review_date_1,'DD-MON-YYYY') and TO_DATE(review_date_2,'DD-MON-YYYY');

					   DBMS_OUTPUT.PUT_LINE('review_spot_rate:' || review_spot_rate);

				elsif i.RDI_REVIEW_DATE_CALC = 4 --Accounting by months
				THEN
					DBMS_OUTPUT.PUT_LINE('Accounting by months ');

				   IF i.RDI_ACC_TYPE = 'TY'
				   THEN
					   DBMS_OUTPUT.PUT_LINE('IN i.RDI_ACC_TYPE = TY');

					  L_TMP_YEAR := to_char(k.pay_date,'RRRR') ;


					   --DBMS_OUTPUT.PUT_LINE('L_TMP_YEAR:'||L_TMP_YEAR);
					 -- DBMS_OUTPUT.PUT_LINE('i.RDI_SELECT_MON:'||i.RDI_SELECT_MON);
					  -- dbms_output.PUT_LINE('review_month' || review_month);


							select RDAM_MONTH_NO
							  INTO PAY_MONTH
							from x_rd_acc_month_info
							where rdam_month_name = to_char(k.pay_date,'Mon')
							AND   rdam_rdi_number = i.rdi_number;

						 review_date_1 := to_char( TO_date(i.RDI_SELECT_MON ||'-'||L_TMP_YEAR,'Mon-RRRR'), 'DD-Mon-YYYY');
						  dbms_output.put_line('review_date_1' || review_date_1);
						 review_date_2 := to_char( ADD_MONTHS(review_date_1,6),'DD-Mon-YYYY');
						   dbms_output.put_line('review_date_2' || review_date_2);

						 IF PAY_MONTH BETWEEN 1 and 6
						  THEN

							dbms_output.put_line('1');

							l_pay_date  := to_char(k.pay_date,'Mon-YYYY');

							dbms_output.put_line('l_pay_date' || l_pay_date);

							 --review_date := review_date_1;

							  IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(review_date_1,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
							  THEN
								--dbms_output.put_line('IF l_pay_date < review_date_1');
								review_date :=  to_char(to_date(review_date_1,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(review_date_1,'DD-Mon_YYYY'),'YYYY') - 1 );
							  ELSE
								--dbms_output.put_line('else  l_pay_date < review_date_1');
								review_date := review_date_1;
							  END IF;


						 elsif PAY_MONTH BETWEEN 7 and 12
						 THEN
						   dbms_output.put_line('2');

							  l_pay_date  := to_char(k.pay_date,'Mon-YYYY');

							  dbms_output.put_line('l_pay_date' || l_pay_date);

							 -- review_date := review_date_2;

							IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(review_date_2,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
							  THEN
								--dbms_output.put_line('IF l_pay_date < review_date_2');
								  review_date :=  to_char(to_date(review_date_2,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(review_date_2,'DD-Mon_YYYY'),'YYYY') - 1 );
								 -- review_date := add_months(to_date(review_date_2,'DD-Mon-YYYY'),-12);
								 DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
							  ELSE
								--dbms_output.put_line('else l_pay_date < review_date_2');
								review_date := review_date_2;
							  END IF;
						 end if;

					 -- dbms_output.put_line('review_date_1' || review_date_1 || 'review_date_2' || review_date_2 );
				   ELSE
						   DBMS_OUTPUT.PUT_LINE('else for i.RDI_ACC_TYPE = TY');

					   select RDAM_MONTH_NO
							  INTO PAY_MONTH
							from x_rd_acc_month_info
							where rdam_month_name = to_char(k.pay_date,'Mon')
							AND   rdam_rdi_number = i.rdi_number;


					   L_TMP_YEAR := to_char(k.pay_date,'RRRR') ;

					   review_date_1 := to_char(To_date(i.RDI_SELECT_MON || '-' || L_TMP_YEAR,'Mon-RRRR'),'DD-MON-YYYY') ;
					   review_date_2 := to_char(ADD_MONTHS(review_date_1,3),'DD-MON-YYYY') ;
					   review_date_3 := to_char(ADD_MONTHS(review_date_2,3),'DD-MON-YYYY');
					   review_date_4 := to_char(ADD_MONTHS(review_date_3,3),'DD-MON-YYYY');
					   l_pay_date  := to_char(k.pay_date,'Mon-YYYY');

					   DBMS_OUTPUT.PUT_LINE('review_date_1' || review_date_1);
					   DBMS_OUTPUT.PUT_LINE('review_date_2' || review_date_2);
					   DBMS_OUTPUT.PUT_LINE('review_date_3' || review_date_3);
					   DBMS_OUTPUT.PUT_LINE('review_date_4' || review_date_4);
					   dbms_output.put_line('pay_date' ||  l_pay_date);
					   dbms_output.put_line('PAY_MONTH' || PAY_MONTH);

						  IF PAY_MONTH BETWEEN 1 and 3
						  THEN
							 DBMS_OUTPUT.PUT_LINE('1');
							  IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(review_date_1,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
							  THEN
								--dbms_output.put_line('IF l_pay_date < review_date_1');
								  review_date :=  to_char(to_date(review_date_1,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(review_date_1,'DD-Mon_YYYY'),'YYYY') - 1 );
								 -- review_date := add_months(to_date(review_date_2,'DD-Mon-YYYY'),-12);
								 DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
							  ELSE
								--dbms_output.put_line('else l_pay_date < review_date_1');
								review_date := review_date_1;
							  END IF;

						  elsif PAY_MONTH BETWEEN 4 and 6
						  THEN
						  DBMS_OUTPUT.PUT_LINE('2');
							 IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(review_date_2,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
							 THEN
								--dbms_output.put_line('IF l_pay_date < review_date_2');
								  review_date :=  to_char(to_date(review_date_2,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(review_date_2,'DD-Mon_YYYY'),'YYYY') - 1 );
								 -- review_date := add_months(to_date(review_date_2,'DD-Mon-YYYY'),-12);
								 DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
							  ELSE
								--dbms_output.put_line('else l_pay_date < review_date_2');
								review_date := review_date_2;
							  END IF;

						  elsif PAY_MONTH BETWEEN 7 and 9
						  THEN
							DBMS_OUTPUT.PUT_LINE('3');
							IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(review_date_3,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
							 THEN
								--dbms_output.put_line('IF l_pay_date < review_date_3');
								  review_date :=  to_char(to_date(review_date_3,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(review_date_3,'DD-Mon_YYYY'),'YYYY') - 1 );
								 -- review_date := add_months(to_date(review_date_2,'DD-Mon-YYYY'),-12);
								 DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
							  ELSE
								--dbms_output.put_line('else l_pay_date < review_date_3');
								review_date := review_date_3;
							  END IF;

						  elsif PAY_MONTH BETWEEN 10 and 12
						  THEN
						   DBMS_OUTPUT.PUT_LINE('4');
						   IF to_date(l_pay_date,'Mon-YYYY') < to_date(to_char(to_date(review_date_4,'DD-Mon-YYYY'),'Mon-YYYY'),'Mon-YYYY')
							 THEN
								--dbms_output.put_line('IF l_pay_date < review_date_4');
								  review_date :=  to_char(to_date(review_date_4,'DD-MOn-YYYY'),'DD-MON') || '-' || ( to_char(to_date(review_date_4,'DD-Mon_YYYY'),'YYYY') - 1 );
								 -- review_date := add_months(to_date(review_date_2,'DD-Mon-YYYY'),-12);
								 DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);
							  ELSE
								--dbms_output.put_line('else l_pay_date < review_date_4');
								review_date := review_date_4;
							  END IF;

						 END IF;
				   END IF;

					DBMS_OUTPUT.PUT_LINE('review_date:' || review_date);

					 IF  i.RDI_ACC_FLAG = 'AOM'
					 THEN
							  DBMS_OUTPUT.PUT_LINE('i.RDI_ACC_FLAG = AOM');



						l_temp_last_day := TO_CHAR(last_day(review_date),'DD-MON-YYYY');

							  DBMS_OUTPUT.PUT_LINE('l_temp_last_day' || l_temp_last_day);

							 select ( to_number(to_date(l_temp_last_day,'DD-MON-YYYY') -  to_date(review_date,'DD-MON-YYYY') ) + 1 )
							 -  ( select count(1) from tbl_tvf_holidays where thol_holiday_date
									 between to_date(review_date,'DD-MON-YYYY') and l_temp_last_day )
							  INTO l_tmp_no_of_days
							  from dual;

							DBMS_OUTPUT.PUT_LINE('l_tmp_no_of_days:' || l_tmp_no_of_days);

								select  round(sum(SPO_N_RATE) / l_tmp_no_of_days,5)   -- [Ver 0.1]
								 INTO review_spot_rate
									  from tbl_tvf_spot_rate
									  where spo_v_cur_code = 'USD'
									  and spo_v_cur_code_2 = 'ZAR'
									  and SPO_N_SRS_ID = i.RDI_EXH_RATE_SOURCE
									  and to_date(SPO_N_PER_DAY || '-' || SPO_N_PER_MONTH || '-' || SPO_N_PER_YEAR,'DD-MM-YYYY')
									  between to_date(review_date,'DD-MON-YYYY') and last_day(review_date);

									 DBMS_OUTPUT.PUT_LINE('review_spot_rate:' || review_spot_rate);


					 elsif i.RDI_ACC_FLAG = 'DOM'
					 THEN
					   DBMS_OUTPUT.PUT_LINE('i.RDI_ACC_FLAG = DOM');
						 review_date_1 := NULL;
						 review_date_2 := NULL;
						 review_date_3 := NULL;

						 if i.RDI_PAY_MONTH_1 > 0 --is not null
						 THEN
								DBMS_OUTPUT.PUT_LINE('i.RDI_PAY_MONTH_1 > 0');

							 review_day := i.RDI_PAY_MONTH_1;

							-- DBMS_OUTPUT.PUT_LINE('review_day' || review_day);

							 review_date_1 :=  to_char( to_date(review_day || '-' || to_char(to_date(review_date,'DD-MON-YYYY'),'MON-YYYY'),'DD-MON-YYYY'),'DD-MON-YYYY');

							 DBMS_OUTPUT.PUT_LINE('review_date_1' || review_date_1);


						 END IF;

						 IF i.RDI_PAY_MONTH_2 > 0
						 THEN

							 DBMS_OUTPUT.PUT_LINE(' i.RDI_PAY_MONTH_2 > 0');

							review_date_2 :=  to_char( to_date(i.RDI_PAY_MONTH_2 || '-' || to_char(to_date(review_date,'DD-MON-YYYY'),'MON-YYYY'),'DD-MON-YYYY'),'DD-MON-YYYY');

							  DBMS_OUTPUT.PUT_LINE('review_date_2' || review_date_2);

						END IF;

						IF i.RDI_LAST_DAY_FLAG = 'Y'
						THEN
						   DBMS_OUTPUT.PUT_LINE('i.RDI_LAST_DAY_FLAG');

						  review_day :=  to_char(last_day(review_date),'DD');

						  review_date_3 :=  to_char( to_date(review_day || '-' || to_char(to_date(review_date,'DD-MON-YYYY'),'MON-YYYY'),'DD-MON-YYYY'),'DD-MON-YYYY');

							  DBMS_OUTPUT.PUT_LINE('review_date_3' || review_date_3);

						 END IF;


						   review_spot_rate_1 := get_spot_rate('USD','ZAR',review_date_1,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);
						   review_spot_rate_2 := get_spot_rate('USD','ZAR',review_date_2,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);
						   review_spot_rate_3 := get_spot_rate('USD','ZAR',review_date_3,i.RDI_EXH_RATE_SOURCE,i.RDI_IS_SUNDAY_HOLIDAY);

						   DBMS_OUTPUT.PUT_LINE('review_spot_rate_1'|| review_spot_rate_1);
						   DBMS_OUTPUT.PUT_LINE('review_spot_rate_2'|| review_spot_rate_2);
						   DBMS_OUTPUT.PUT_LINE('review_spot_rate_3'|| review_spot_rate_3);

						   SELECT ROUND(x_fun_calc_avg(review_spot_rate_1,review_spot_rate_2,review_spot_rate_3),5) into review_spot_rate FROM DUAL;   -- [Ver 0.1]

						   /*  IF  i.RDI_PAY_MONTH_1 is  null
									 OR i.RDI_PAY_MONTH_2 is  null
										 OR  i.RDI_LAST_DAY_FLAG != 'Y'
								THEN
								   dbms_output.put_line('1');
								  review_spot_rate := ROUND( ( NVL(review_spot_rate_1,0) + NVL(review_spot_rate_2,0) + nvl(review_spot_rate_3,0) )/ 2 ,4);
								ELSIF i.RDI_PAY_MONTH_1 is not null and i.RDI_PAY_MONTH_2 is not null AND i.RDI_LAST_DAY_FLAG = 'Y'
								THEN
								  dbms_output.put_line('2');
								 review_spot_rate :=  ROUND( ( NVL(review_spot_rate_1,0) + NVL(review_spot_rate_2,0) + NVL(review_spot_rate_3,0) ) / 3 ,4)  ;
								END IF;*/
						 END IF;



						DBMS_OUTPUT.PUT_LINE('review_spot_rate:' || review_spot_rate);

			   END IF;

			 /*  dbms_output.put_line('review_spot_rate' || review_spot_rate);
			   dbms_output.put_line('i.RDI_BM_UPPER' || i.RDI_BM_UPPER);
			   dbms_output.put_line('i.RDI_BM_LOWER' || i.RDI_BM_LOWER);*/

			   if review_spot_rate  > i.RDI_BM_UPPER
					 OR review_spot_rate < i.RDI_BM_LOWER
				THEN
				   DBMS_output.put_line('if for spot rate');
					IF review_spot_rate > i.RDI_BM_UPPER
					THEN
					   l_spot_rate := 'Y';
					 -- DBMS_output.put_line('In review_spot_rate > i.RDI_BM_UPPER' || 'Upper' || i.RDI_BM_UPPER || 'RDI_SHARE_SUP' || i.RDI_SHARE_SUP);
					  discount_per_dollar := ROUND(( review_spot_rate - i.RDI_BM_UPPER) / i.RDI_BM_UPPER  * ( i.RDI_SHARE_SUP / 100 ) ,6) ;

					elsif review_spot_rate < i.RDI_BM_LOWER
					THEN
					  l_spot_rate := 'N' ;
					 -- DBMS_output.put_line('In review_spot_rate < i.RDI_BM_LOWER' || 'Lower' || i.RDI_BM_LOWER );
					  discount_per_dollar := ROUND(( review_spot_rate - i.RDI_BM_LOWER  ) / i.RDI_BM_LOWER  * ( i.RDI_SHARE_SUP / 100 ),6) ;
					END IF;

							dbms_output.put_line('discount_per_dollar' || discount_per_dollar);

				   discount := ROUND( (discount_per_dollar * k.PAY_AMOUNT) ,2) ;

						dbms_output.put_line('discount' || discount);

						if NVL(i.RDI_DISCOUNT_THRESHOLD,0) > 0
						THEN
						  threshold_discount := ( i.RDI_DISCOUNT_THRESHOLD / 100 ) *k.PAY_AMOUNT ;
						  dbms_output.put_line('threshold_discount' || threshold_discount);

							IF l_spot_rate = 'Y'
							THEN
								IF ABS(threshold_discount) > ABS(discount)
								THEN
								  applicable_discount := discount;
								ELSE
								  applicable_discount := threshold_discount;
								END IF;
							ELSIF l_spot_rate = 'N'
							THEN
                 if k.PAY_AMOUNT > 0
                 THEN
							     select greatest(-(threshold_discount),discount) INTO applicable_discount from dual;
                 else
                    select  least(-(threshold_discount),discount) INTO applicable_discount from dual;
                 End if;
            END IF;
					ELSE
					 applicable_discount := discount;
					END IF;
						dbms_output.put_line('applicable_discount' || applicable_discount);
			 ELSE
			 DBMS_output.put_line('else for spot rate');
				 --review_spot_rate := 0;
				 discount_per_dollar := 0;
				 discount := 0;
				 applicable_discount := 0;
			 END IF;
				 dbms_output.put_line('bEFORE INSERT' );

				 --DBMS_OUTPUT.PUT_LINE('i_period_month' || i_period_month);
				-- DBMS_OUTPUT.PUT_LINE('i_log_date' || i_log_date);

				  PRC_INS_DISCOUNT_CALC(I.RDI_NUMBER,
										I.CON_NUMBER,
										J.LIC_NUMBER,
										i_period_month,
										i_period_year,
										review_spot_rate,
										discount_per_dollar,
										discount,
										applicable_discount,
										null,
										i_entry_oper,
										sysdate,
										null,
										null,
										0,
										K.PAY_AMOUNT,
										k.pay_number
									   );
			  review_date_1 := NULL;
			  review_date_2 := NULL;
			  review_date_3 := NULL;
			  review_date_4 := NULL;
			  review_date   := NULL;
			  review_spot_rate := 0;
			  review_day := NULL;
			  discount_per_dollar := 0;
			  discount := 0;
			  applicable_discount := 0;
			  review_spot_rate_1 := NULL;
			  review_spot_rate_2 := NULL;
			  review_spot_rate_3 := NULL;

			 END LOOP;   ---end of payment loop

			 --l_count := l_count + 1;
		   END LOOP;          ----end of lic loop

		   /* dbms_output.put_line('l_count' || l_count);

			  IF l_count = 0
			  THEN
				dbms_output.put_line('In count');
				raise_application_error (-20223,
										 'There are no license present in contract'
										);

			  END IF;*/

		 END LOOP;    ---end of contract loop

		 --Dev.R2 : Rand Devaluation : Start : [Devashish Raverkar]_[04-09-2014]
      FOR i in (SELECT rddc_lic_number
                from x_rd_discount_calculation,
                    fid_contract,
                    x_rand_devaluation_info
                WHERE RDDC_CONTRACT_NUMBER=con_number
                AND rdi_number = rddc_rdi_number
                AND CON_DEVALUATION_FLAG = 'N')
     LOOP
       select to_date(fim_year || fim_month,'YYYYMM')
       into open_month
       from fid_financial_month
       where fim_status = 'O'
       and fim_split_region = (SELECT LEE_REGION_ID
                              from FID_LICENSEE, FID_LICENSE
                              WHERE LIC_LEE_NUMBER = LEE_NUMBER
                              AND LIC_NUMBER = I.RDDC_LIC_NUMBER);

       delete from x_rd_discount_calculation
       where rddc_LIC_number = I.rddc_lic_number
       and to_date(rddc_year || rddc_month,'YYYYMM') >= open_month;
     END LOOP;
     --Dev.R2 : Rand Devaluation : End:

			o_sucess := 1;
    END IF;

  EXCEPTION
  when send_email then
    l_send_email := X_PKG_RD_MONTH_DISC_CALC.fun_send_email(i_entry_oper,'RandDevaluationRoutine',i_log_date,i_user_email) ;

    raise_application_error (-20601,'Rand Devaluation Routine Failed');
     o_sucess := 0;
/*  WHEN OTHERS THEN
    raise_application_error (-20601,
                                     SUBSTR (SQLERRM, 1, 200)
                                 );
    o_sucess := 0;*/
  END prc_month_disc_calc;

PROCEDURE PRC_INS_DISCOUNT_CALC
(
I_RDI_NUMBER            IN NUMBER,
I_CONTRACT_NUMBER       IN NUMBER,
I_LIC_NUMBER            IN NUMBER,
I_MONTH                 IN NUMBER,
I_YEAR                  IN NUMBER,
I_REVIEW_RATE           IN NUMBER,
I_DISCOUNT_PER_DOLLAR   IN NUMBER,
I_DISCOUNT              IN NUMBER,
I_APPLICABLE_DISCOUNT   IN NUMBER,
I_DISCOUNT_CLAIMED_FLAG IN NUMBER,
I_ENTRY_OPER            IN VARCHAR2,
I_ENTRY_DATE            IN DATE,
I_MODIFY_BY             IN VARCHAR2,
I_MODIFY_ON             IN DATE,
I_UPDATE_COUNT          IN NUMBER,
I_PAY_AMOUNT            IN NUMBER,
i_pay_number            IN NUMBER
)
AS
 cursor cur_rdi
 IS
    select rddc_number
      from X_RD_DISCOUNT_CALCULATION
      where RDDC_CONTRACT_NUMBER = I_CONTRACT_NUMBER
      AND   RDDC_LIC_NUMBER = I_LIC_NUMBER
      AND   RDDC_MONTH = I_MONTH
      AND   RDDC_YEAR = I_YEAR
      and   RDDC_PAY_NUMBER = i_pay_number ;

    currdi          cur_rdi%ROWTYPE;

    l_rddc_number     NUMBER;
BEGIN

    DBMS_OUTPUT.PUT_LINE('IN DISCOUNT CALCUALTION INSERT');

   OPEN cur_rdi;

   FETCH cur_rdi
   INTO currdi;


 IF   cur_rdi%NOTFOUND
 THEN
  l_rddc_number := x_seq_rddc.nextval;

  DBMS_OUTPUT.PUT_LINE('l_rddc_number:' || l_rddc_number);

            insert into X_RD_DISCOUNT_CALCULATION
            ( RDDC_NUMBER,
              RDDC_RDI_NUMBER,
              RDDC_CONTRACT_NUMBER,
              RDDC_LIC_NUMBER,
              RDDC_MONTH,
              RDDC_YEAR,
              RDDC_REVIEW_RATE,
              RDDC_DISCOUNT_PER_DOLLAR,
              RDDC_DISCOUNT,
              RDDC_APPLICABLE_DISCOUNT,
              RDDC_DISCOUNT_CLAIMED_FLAG,
              RDDC_ENTRY_OPER,
              RDDC_ENTRY_DATE,
              RDDC_MODIFY_BY,
              RDDC_MODIFY_ON,
              RDDC_UPDATE_COUNT,
              RDDC_PAY_AMOUNT,
              RDDC_PAY_NUMBER,
              RDDC_DISCOUNT_CLAIMED_DATE,
              RDDC_SUPPLIER_REF
            )
          values
          ( l_rddc_number,
            I_RDI_NUMBER,
            I_CONTRACT_NUMBER,
            I_LIC_NUMBER,
            I_MONTH,
            I_YEAR ,
            I_REVIEW_RATE,
            I_DISCOUNT_PER_DOLLAR,
            I_DISCOUNT,
            I_APPLICABLE_DISCOUNT,
            I_DISCOUNT_CLAIMED_FLAG,
            I_ENTRY_OPER,
            I_ENTRY_DATE,
            I_MODIFY_BY,
            I_MODIFY_ON,
            I_UPDATE_COUNT,
            I_PAY_AMOUNT,
            i_pay_number,
            NULL,
            NULL
          );
  ELSE
     dbms_output.put_line('In Update');
     --dbms_output.put_line('I_PAY_AMOUNT' || I_PAY_AMOUNT);
     --dbms_output.put_line('I_REVIEW_RATE' || I_REVIEW_RATE);

     UPDATE X_RD_DISCOUNT_CALCULATION
      set   RDDC_REVIEW_RATE = I_REVIEW_RATE,
            RDDC_DISCOUNT_PER_DOLLAR = I_DISCOUNT_PER_DOLLAR,
            RDDC_DISCOUNT = I_DISCOUNT ,
            RDDC_APPLICABLE_DISCOUNT = I_APPLICABLE_DISCOUNT,
            RDDC_DISCOUNT_CLAIMED_FLAG = I_DISCOUNT_CLAIMED_FLAG,
            RDDC_MODIFY_BY = I_ENTRY_OPER,
            RDDC_MODIFY_ON = SYSDATE , --I_MODIFY_ON,
            RDDC_UPDATE_COUNT  = RDDC_UPDATE_COUNT+ 1 ,
            RDDC_PAY_AMOUNT = I_PAY_AMOUNT
      where RDDC_CONTRACT_NUMBER = I_CONTRACT_NUMBER
      AND   RDDC_LIC_NUMBER = I_LIC_NUMBER
      AND   RDDC_PAY_NUMBER = i_pay_number;
  END IF;

commit;

/*EXCEPTION
WHEN OTHERS THEN
raise_application_error(-20201,sqlerrm);*/
END PRC_INS_DISCOUNT_CALC;

FUNCTION fun_send_email (
      i_user           IN   VARCHAR2,
      i_action         IN   VARCHAR2,
      i_log_date       IN   VARCHAR2,
      i_user_mail_id   IN   VARCHAR2
   )
      RETURN NUMBER
   AS
      l_mail_conn     UTL_SMTP.connection;
      l_smtp_server   VARCHAR2 (100);
      l_recipient     VARCHAR2 (500);
      l_subject       VARCHAR2 (500);
      l_mailfrom      VARCHAR2 (50);
      var             VARCHAR2 (20);
      o_sucess        NUMBER;
      arr_email       simplearray         := simplearray (50);
   BEGIN
      var := CHR (38) || 'nbsp;';

      -- Get the SMTP server ip from fwk_appparameter table
      SELECT "Content"
        INTO l_smtp_server
        FROM fwk_appparameter
       WHERE KEY = 'SMTPServer';

      -- Get the recipient, subject, mailfrom from sgy_email table
      SELECT recipient, subject, mailfrom
        INTO l_recipient, l_subject, l_mailfrom
        FROM sgy_email
       WHERE action = i_action;


	     -- l_recipient := 'priyanka.pathak@nihilent.com,kailas.late@nihilent.com,neeraj.prasad@nihilent.com,yogesh.umaranikar@nihilent.com,sushma.komulla@nihilent.com,praneet.nadkar@nihilent.com';
         -- l_recipient := 'Piyush.Bansal@mnet.co.za,mandar.dhotre@mnet.co.za';
       l_mailfrom := 'SynergyAdmin@mnet.co.za';

      -- Get the ',' seperated emailids as array
      arr_email := get_email_ids (l_recipient, ',');
      l_mail_conn := UTL_SMTP.open_connection (l_smtp_server, 25);
      UTL_SMTP.helo (l_mail_conn, l_smtp_server);
      UTL_SMTP.mail (l_mail_conn, l_mailfrom);
      UTL_SMTP.rcpt (l_mail_conn, i_user_mail_id);

      FOR i IN 1 .. arr_email.COUNT - 1
      LOOP
         UTL_SMTP.rcpt (l_mail_conn, '' || arr_email (i) || '');
      END LOOP;

      UTL_SMTP.open_data (l_mail_conn);
      UTL_SMTP.write_data (l_mail_conn,
                              'Subject:'
                           || l_subject
                           || '  '
                           || i_user
                           || ' on Date '
                           || i_log_date
                           || UTL_TCP.crlf
                          );
      UTL_SMTP.write_data (l_mail_conn,
                           'Content-Type: text/html' || UTL_TCP.crlf
                          );
      UTL_SMTP.write_data (l_mail_conn, UTL_TCP.crlf || '');
      UTL_SMTP.write_data (l_mail_conn, 'Greetings, ');
      UTL_SMTP.write_data (l_mail_conn, ' <BR>');
      UTL_SMTP.write_data (l_mail_conn, '<BR>' || UTL_TCP.crlf);
      UTL_SMTP.write_data
          (l_mail_conn,
           'The Rand Devaluation Routine Failed due to following reason(s)'
          );
      UTL_SMTP.write_data (l_mail_conn, '<BR><BR>');

      FOR err IN ( select a.*,rownum from (SELECT COW_V_WARNING
                    FROM X_RD_DISCOUNT_WARNINGS
                    order by COW_DT_DATE)a
                   )
      LOOP
         IF err.ROWNUM = 1
         THEN
            UTL_SMTP.write_data (l_mail_conn,
                                    var
                                 || var
                                 || var
                                 || var
                                 || 'Due to unavailability of spot rate for following dates'
                                );
            UTL_SMTP.write_data (l_mail_conn, '<BR>');
         END IF;

         UTL_SMTP.write_data (l_mail_conn,
                                 var
                              || var
                              || var
                              || var
                              || var
                              || var
                              || var
                              || var
                              || err.ROWNUM
                              || '.'
                              || var
                              || var
                              || err.COW_V_WARNING
                             );
         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      END LOOP;

       UTL_SMTP.write_data (l_mail_conn, '<BR>');

         UTL_SMTP.write_data (l_mail_conn, '<BR>');
      UTL_SMTP.write_data (l_mail_conn, '<BR><BR>');
      UTL_SMTP.write_data (l_mail_conn, 'Thanks,<BR>');
      UTL_SMTP.write_data (l_mail_conn, 'Synergy Admin<BR>');
      UTL_SMTP.write_data (l_mail_conn, '<BR>');
      UTL_SMTP.write_data
         (l_mail_conn,
          'This is an auto generated email. Please do not reply to this email.'
         );
      UTL_SMTP.close_data (l_mail_conn);
      UTL_SMTP.quit (l_mail_conn);
      o_sucess := 1;
      RETURN o_sucess;
  /* EXCEPTION
      WHEN OTHERS
      THEN
         UTL_SMTP.close_data (l_mail_conn);
         UTL_SMTP.quit (l_mail_conn);
         raise_application_error (-20601, SUBSTR (SQLERRM, 1, 200));*/
   END;


   FUNCTION get_email_ids (list_in IN VARCHAR2, delimiter_in VARCHAR2)
      RETURN simplearray
   AS
      v_retval   simplearray
         := simplearray (  LENGTH (list_in)
                         - LENGTH (REPLACE (list_in, delimiter_in, ''))
                         + 1
                        );
   BEGIN
      IF list_in IS NOT NULL
      THEN
         FOR i IN 1 ..   LENGTH (list_in)
                       - LENGTH (REPLACE (list_in, delimiter_in, ''))
                       + 1
         LOOP
            v_retval.EXTEND;
            v_retval (i) :=
               SUBSTR (delimiter_in || list_in || delimiter_in,
                         INSTR (delimiter_in || list_in || delimiter_in,
                                delimiter_in,
                                1,
                                i
                               )
                       + 1,
                         INSTR (delimiter_in || list_in || delimiter_in,
                                delimiter_in,
                                1,
                                i + 1
                               )
                       - INSTR (delimiter_in || list_in || delimiter_in,
                                delimiter_in,
                                1,
                                i
                               )
                       - 1
                      );
         END LOOP;
      END IF;

      RETURN v_retval;
   END get_email_ids;

 FUNCTION get_spot_rate_date
  (
      fromcurr                 IN   VARCHAR2,
      tocurr                   IN   VARCHAR2,
      ondate                   IN   DATE,
      i_spo_n_srs_id           IN   tbl_tvf_spot_rate.spo_n_srs_id%TYPE,
      i_is_sunday_holiday_flag IN   varchar2
   )
      RETURN varchar2
   IS
      spotrate_1  NUMBER;
      spotrate    VARCHAR2(50);
      perday      NUMBER;
      permonth    NUMBER;
      peryear     NUMBER;
      rate_date   DATE;
   BEGIN
      rate_date := ondate;

      <<next_day_rate>>
      perday := TO_CHAR (rate_date, 'DD');
      permonth := TO_CHAR (rate_date, 'MM');
      peryear := TO_CHAR (rate_date, 'YYYY');

      BEGIN
         IF fromcurr = tocurr
         THEN
            spotrate_1 := 1;
         ELSE
            SELECT spo_n_rate
              INTO spotrate_1
              FROM tbl_tvf_spot_rate
             WHERE spo_v_cur_code = fromcurr
               AND spo_v_cur_code_2 = tocurr
               AND spo_n_per_day = perday
               AND spo_n_per_month = permonth
               AND spo_n_per_year = peryear
               AND spo_n_srs_id = i_spo_n_srs_id;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            --IF i_spo_n_srs_id = 1
            --THEN
            IF valid_no_rate (rate_date) = 1
            THEN
               IF i_is_sunday_holiday_flag = 'FBD'--1
               THEN
                  rate_date := rate_date + 1;
                  GOTO next_day_rate;
               ELSE
                  rate_date := rate_date - 1;
                  GOTO next_day_rate;
               END IF;
            ELSE
               spotrate :=  to_char(rate_date,'DD-MON-YYYY');
            END IF;
      END;

      RETURN spotrate;
   EXCEPTION
      WHEN OTHERS
      THEN
         raise_application_error (-20601,
                                     SUBSTR (SQLERRM, 1, 200)
                                  || ' - While fetching Spot Rate'
                                 );
   END get_spot_rate_date;

 function x_fun_calc_avg
 (
   first_day_rate  IN NUMBER,
   second_day_rate IN NUMBER,
   last_day_rate   IN NUMBER
 )
 RETURN NUMBER
 IS
  L_SPOT_RATE   NUMBER := 0;
 BEGIN
  IF first_day_rate > 0
  THEN
      IF second_day_rate > 0
      THEN
          IF last_day_rate > 0
          THEN
            L_SPOT_RATE := ( first_day_rate + second_day_rate + last_day_rate )/ 3;

          ELSE
            L_SPOT_RATE := ( first_day_rate + second_day_rate ) / 2 ;
          END IF;
      ELSIF last_day_rate > 0
      THEN
        L_SPOT_RATE := ( first_day_rate + last_day_rate ) / 2 ;
      ELSE
        L_SPOT_RATE := first_day_rate ;
      END IF;
  ELSIF second_day_rate > 0
  THEN
     if last_day_rate > 0
     THEN
       L_SPOT_RATE := ( second_day_rate +  last_day_rate ) / 2 ;
     ELSE
       L_SPOT_RATE := second_day_rate;
     END IF;
  ELSE
     L_SPOT_RATE := last_day_rate;
  END IF;

RETURN L_SPOT_RATE ;

EXCEPTION
WHEN OTHERS THEN
 RAISE_APPLICATION_ERROR(-20225,SQLERRM);
END x_fun_calc_avg;

END X_PKG_RD_MONTH_DISC_CALC;
/