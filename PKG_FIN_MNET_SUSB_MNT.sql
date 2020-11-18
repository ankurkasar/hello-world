CREATE OR REPLACE PACKAGE                   "PKG_FIN_MNET_SUSB_MNT"
AS
   /**************************************************************************
   REM Module     : Finance
   REM Client     : MNET
   REM File Name     : PKG_FIN_MNET_SUSB_MNT.sql
   REM Purpose     : This package is used for Subsriber Maintainance.
   REM Written By     : Vinayak
   REM Date     : 19-03-2010
   REM Type     : Database Package
   REM Change History :
   REM **************************************************************************/
   TYPE c_cursor_payqry IS REF CURSOR;

   PROCEDURE prc_search_sub_dtls (
      l_sub_cha_number   IN       fid_channel_subscriber.sub_cha_number%TYPE,
      l_sub_per_month    IN       fid_channel_subscriber.sub_per_month%TYPE,
      l_sub_per_year     IN       fid_channel_subscriber.sub_per_year%TYPE,
      o_susb_dtls        OUT      pkg_fin_mnet_susb_mnt.c_cursor_payqry
   );

   PROCEDURE prc_update_sub_dtls (
      i_sub_cha_number     IN       fid_channel_subscriber.sub_cha_number%TYPE,
      i_sub_per_month      IN       fid_channel_subscriber.sub_per_month%TYPE,
      i_sub_per_year       IN       fid_channel_subscriber.sub_per_year%TYPE,
      i_sub_ter_code       IN       fid_channel_subscriber.sub_ter_code%TYPE,
      i_sub_suc_code       IN       fid_channel_subscriber.sub_suc_code%TYPE,
      i_sub_update_count   IN       fid_channel_subscriber.sub_update_count%TYPE,
      i_sub_actual         IN       fid_channel_subscriber.sub_actual%TYPE,
      i_sub_equated        IN       fid_channel_subscriber.sub_equated%TYPE,
      o_update             OUT      NUMBER
   );

   PROCEDURE prc_add_sub_dtls (
      i_sub_cha_number     IN       fid_channel_subscriber.sub_cha_number%TYPE,
      i_sub_per_month      IN       fid_channel_subscriber.sub_per_month%TYPE,
      i_sub_per_year       IN       fid_channel_subscriber.sub_per_year%TYPE,
      i_sub_ter_code       IN       fid_channel_subscriber.sub_ter_code%TYPE,
      i_sub_suc_code       IN       fid_channel_subscriber.sub_suc_code%TYPE,
      i_sub_update_count   IN       fid_channel_subscriber.sub_update_count%TYPE,
      i_sub_actual         IN       fid_channel_subscriber.sub_actual%TYPE,
      i_sub_equated        IN       fid_channel_subscriber.sub_equated%TYPE,
      o_success            OUT      NUMBER
   );

   PROCEDURE prc_copy_subs (
      i_from_month   IN       NUMBER,
      i_from_year    IN       NUMBER,
      i_to_month     IN       NUMBER,
      i_to_year      IN       NUMBER,
      i_entry_oper   IN       VARCHAR2,
      o_success      OUT      NUMBER
   );

   FUNCTION history_date_check (i_month IN NUMBER, i_year IN NUMBER)
      RETURN NUMBER;
      
Procedure prc_insert_sub_dtls
(
    I_ROW_NUMBER        IN       x_pkg_common_var.varchar_array,
   i_sub_cha_name       IN       fid_channel.cha_Short_name%TYPE,
   i_sub_per_month      IN       x_pkg_common_var.number_array,
   i_sub_per_year       IN       x_pkg_common_var.number_array,
   i_sub_ter_code       IN       x_pkg_common_var.varchar_array,  
   i_sub_suc_code       IN       x_pkg_common_var.varchar_array,     
   i_sub_actual         IN       x_pkg_common_var.number_array,  
   i_sub_equated        IN       x_pkg_common_var.number_array,
   i_sub_number         IN       x_pkg_common_var.number_array,
   i_entry_oper         IN       fid_channel_subscriber.SUB_ENTRY_OPER%TYPE,
   O_success            OUT      NUMBER,
   O_fail_data          OUT      sys_refcursor,
   O_fail_cnt           OUT      NUMBER
);      

PROCEDURE prc_return_subtemppath (o_data OUT sys_refcursor);

END pkg_fin_mnet_susb_mnt;

/


CREATE OR REPLACE PACKAGE BODY                   "PKG_FIN_MNET_SUSB_MNT"
AS
   PROCEDURE prc_copy_subs (
      i_from_month   IN       NUMBER,
      i_from_year    IN       NUMBER,
      i_to_month     IN       NUMBER,
      i_to_year      IN       NUMBER,
      i_entry_oper   IN       VARCHAR2,
      o_success      OUT      NUMBER
   )
   AS
      l_flag             NUMBER        := 0;
      --Added by Ashish Shukla--
      l_fim_status       VARCHAR2 (10);
      l_date_input       DATE;
      l_live_date        DATE;
      l_fuction_result   NUMBER;
   ---Added by Ashish Shukla Date [25 feb 2013] for hold live date ---
   BEGIN
      ---Added by Ashish Shukla Date [25 feb 2013] for check input date is  Historical date or not---
      ----if return value=0 thant input date is histoirical date else live of greater than go live date-----
      l_fuction_result := history_date_check (i_to_month, i_to_year);

      ---Added by Ashish Shukla Date [25 feb 2013] for hold live date ---
      IF (l_fuction_result < 1)
      then
         --BEGIN
            SELECT NVL (fim_status, 'C')
              into l_fim_status
              FROM fid_financial_month
             where fim_month = i_to_month and fim_year = i_to_year;
        /* EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (-20002,
                                           ' Financial Month:'
                                        || i_to_month
                                        || ' Year:'
                                        || i_to_year
                                        || ' Entry Not Created '
                                       );
         end;*/
      ELSIF (l_fuction_result = 1)
      then
        -- BEGIN
            SELECT fim_status
              INTO l_fim_status
              FROM fid_financial_month
             where fim_month = i_to_month
               AND fim_year = i_to_year
               and fim_split_region = 2;
        /* EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (-20002,
                                           ' Financial Month:'
                                        || i_to_month
                                        || ' Year:'
                                        || i_to_year
                                        || ' Entry Not Created '
                                       );
         END;*/
      END IF;

      IF (l_fim_status = 'C')
      Then
         --DBMS_OUTPUT.put_line ('in than');
         --dbms_output.put_line('Operation cannot be performed as the month '||i_to_month||'-'||i_to_year||' is closed');
         raise_application_error
                            (-20414,
                                'Operation cannot be performed as the month '
                             || i_to_month
                             || '-'
                             || i_to_year
                             || ' is closed'
                            );
         o_success := -1;
      ELSE
         INSERT INTO fid_channel_subscriber
                     (sub_cha_number, sub_ter_code, sub_suc_code,
                      sub_per_year, sub_per_month, sub_actual, sub_equated,
                      sub_entry_date, sub_entry_oper, sub_is_deleted,
                      sub_update_count)
            SELECT sub_cha_number, sub_ter_code, sub_suc_code, i_to_year,
                   i_to_month, sub_actual, sub_equated, SYSDATE,
                   i_entry_oper, 0, 0
              FROM fid_channel_subscriber
             WHERE sub_per_year = i_from_year
               AND sub_per_month = i_from_month
               AND sub_cha_number IN (1, 1006, 1007);

         o_success := 1;


      END IF;

      l_flag := SQL%ROWCOUNT;

      IF l_flag <> 0
      THEN
         o_success := 1;
      ELSE
         o_success := 0;
      END IF;
   exception
      WHEN NO_DATA_FOUND
      THEN


         raise_application_error (-20002,
                                     ' Financial Month-'
                                  || i_to_month
                                  || '  And Year-'
                                  || i_to_year
                                  || ' Entry Not Created '
                                 );
      WHEN dup_val_on_index
      then
      --   raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));
      -- Added by Khilesh Chauhan for Vanilla 09 Jun 2015 to display error properly instead of Unique constraint error
      raise_application_error (-20001, 'Cannot Copy. Subscriber already Present for '|| TO_CHAR(TO_DATE(i_to_month, 'MM'), 'MON') || '-' || i_to_year);
    /*WHEN others
      then

         raise_application_error (-20001, SUBSTR (1, 200, SQLERRM));*/
   END prc_copy_subs;

   PROCEDURE prc_search_sub_dtls (
      l_sub_cha_number   IN       fid_channel_subscriber.sub_cha_number%TYPE,
      l_sub_per_month    IN       fid_channel_subscriber.sub_per_month%TYPE,
      l_sub_per_year     IN       fid_channel_subscriber.sub_per_year%TYPE,
      o_susb_dtls        OUT      pkg_fin_mnet_susb_mnt.c_cursor_payqry
   )
   AS
      l_qry     VARCHAR2 (4000);
      l_count   NUMBER;
   BEGIN
l_qry :=
      'select SUB_CHA_NUMBER
              ,SUB_TER_CODE
              ,SUB_SUC_CODE
              ,SUB_PER_YEAR
              ,SUB_PER_MONTH
              ,sum(SUB_ACTUAL)SUB_ACTUAL
              ,sum(SUB_EQUATED)SUB_EQUATED
              ,sum(SUB_UPDATE_COUNT)SUB_UPDATE_COUNT
              ,sum(SUB_NUMBER)SUB_NUMBER
              ,SUBSCRIBER_CAT
              ,ter_desc
        from 
        (select SUB_CHA_NUMBER
              ,SUB_TER_CODE
              ,SUB_SUC_CODE
              ,SUB_PER_YEAR
              ,SUB_PER_MONTH
              ,SUB_ACTUAL
              ,SUB_EQUATED
              ,SUB_UPDATE_COUNT
              ,SUB_NUMBER
              ,(    select COD_DESCRIPTION
                      from fid_code
                      where cod_value   != ''HEADER''
                      and   cod_type     = ''SUC_CODE''
                      and   cod_value=    SUB_SUC_CODE
                  ) SUBSCRIBER_CAT
              ,nvl((   SELECT    ter_name
                          FROM         fid_territory
                  WHERE     ter_code       = SUB_TER_CODE
                          ) , ''ERROR: Territory not valid for this Channel''
                      ) ter_desc
        from fid_channel_subscriber fcs
        where SUB_CHA_NUMBER= '|| l_sub_cha_number||'
        and SUB_PER_MONTH = '|| l_sub_per_month|| '
        and SUB_PER_YEAR = '|| l_sub_per_year|| '
        union
        select distinct fst.sub_id SUB_CHA_NUMBER
              ,fct.cht_ter_code SUB_TER_CODE
              ,ftcl.tcl_subcat_code SUB_SUC_CODE
              ,'|| l_sub_per_year||' SUB_PER_YEAR
              ,'||l_sub_per_month||' SUB_PER_MONTH
                ,0 SUB_ACTUAL
                ,0 SUB_EQUATED
                ,0 SUB_UPDATE_COUNT
                ,0 sub_number
              ,(select COD_DESCRIPTION
                from fid_code
                where cod_value   != ''HEADER''
                and   cod_type     = ''SUC_CODE''
                and   cod_value=    ftcl.tcl_subcat_code
               )SUBSCRIBER_CAT
              ,nvl((SELECT ter_name
                    FROM fid_territory
                    WHERE cht_ter_code = ter_code
                   ) , ''ERROR: Territory not valid for this Channel''
                  )TER_DESC
        from fid_channel_service fcs
            ,fid_channel_service_channel  fcsc
            ,fid_channel_territory fct
            ,fid_type_cat_linking ftcl
            ,FIN_SUB_TYPE fst
            ,fid_channelservice_subtype fcss
            ,fid_channel fc
        where fst.sub_id = fcss.FCS_SUB_ID
        and fcss.fcs_chs_number = fcs.chs_number
        and fcs.chs_number  = fcsc.csc_chs_number
        and fcsc.csc_cha_number = fc.cha_number
        and fc.cha_number = fct.cht_cha_number
        and  fst.sub_id = '|| l_sub_cha_number||' )
        group by SUB_CHA_NUMBER
              ,SUB_TER_CODE
              ,SUB_SUC_CODE
              ,SUB_PER_YEAR
              ,SUB_PER_MONTH
              ,SUBSCRIBER_CAT
              ,ter_desc
        order by sub_ter_code asc,
        sub_suc_code desc';
      /*l_qry :=
            'select fcs.*
            ,(    select COD_DESCRIPTION
                    from fid_code
                    where cod_value   != ''HEADER''
                    and   cod_type     = ''SUC_CODE''
                    and   cod_value=    SUB_SUC_CODE
                ) SUBSCRIBER_CAT
            ,nvl((   SELECT    ter_name
                        FROM         fid_territory
                WHERE     ter_code       = SUB_TER_CODE
                        ) , ''ERROR: Territory not valid for this Channel''
                    ) ter_desc
            from fid_channel_subscriber fcs
            where SUB_CHA_NUMBER= '
         || l_sub_cha_number
         || '
            and SUB_PER_MONTH = '
         || l_sub_per_month
         || '
            and SUB_PER_YEAR = '
         || l_sub_per_year
         || '
                        order by sub_ter_code asc,
                        sub_suc_code desc ';
DBMS_OUTPUT.put_line (l_qry);                        

      SELECT COUNT (*)
        INTO l_count
        FROM fid_channel_subscriber fcs
       WHERE sub_cha_number = l_sub_cha_number
         AND sub_per_month = l_sub_per_month
         AND sub_per_year = l_sub_per_year;

      IF l_count = 0
      THEN
         l_qry :=
               '
            select    distinct fst.sub_id     SUB_CHA_NUMBER
            ,     fct.cht_ter_code     SUB_TER_CODE
            ,    ftcl.tcl_subcat_code     SUB_SUC_CODE
            ,    '
            || l_sub_per_month
            || '      SUB_PER_MONTH
            ,    '
            || l_sub_per_year
            || '    SUB_PER_YEAR
            ,(    select COD_DESCRIPTION
                from fid_code
                where cod_value   != ''HEADER''
                and   cod_type     = ''SUC_CODE''
                and   cod_value=    ftcl.tcl_subcat_code
                )                 SUBSCRIBER_CAT
                       ,    nvl((      SELECT    ter_name     FROM     fid_territory
                                    WHERE     cht_ter_code   = ter_code
                        ) , ''ERROR: Territory not valid for this Channel''
                    )     TER_DESC
                    ,    0     SUB_ACTUAL
                    ,    0    SUB_EQUATED
                    ,    0    SUB_UPDATE_COUNT
                    ,    0    sub_number
                    ,    0    SUBSCRIBER_CAT
                    ,    0   ter_desc
            from    fid_channel_service fcs
            , fid_channel_service_channel  fcsc
            ,    fid_channel_territory fct
            ,    fid_type_cat_linking ftcl
            ,    FIN_SUB_TYPE  fst
            ,   fid_channelservice_subtype fcss
             ,   fid_channel fc
            where fst.sub_id = fcss.FCS_SUB_ID
            and fcss.fcs_chs_number = fcs.chs_number
            and fcs.chs_number  = fcsc.csc_chs_number
            and fcsc.csc_cha_number = fc.cha_number
            and fc.cha_number = fct.cht_cha_number
            and  fst.sub_id ='
            || l_sub_cha_number
            || '
            order by sub_ter_code asc,
                        sub_suc_code desc,2';*/
        /* where    fcs.SUB_TYPE  is not null
      --and    fst.sub_type = fcs.sub_type
      and  fst.sub_id = fcss.FCS_SUB_ID
      and fcs.chs_number = fcsc.csc_chs_number
      and fcsc.csc_cha_number = fct.cht_cha_number
      and    ftcl.TCL_SUBTYPE_CODE = fcs.sub_type
      and fcs.chs_number = fcss.fcs_chs_number
      and fcsc.csc_chs_number = fcss.fcs_chs_number
      and    fst.sub_id ='|| l_SUB_CHA_NUMBER||'
      order by 2'*/
        --    ;
      --END IF;

      --DBMS_OUTPUT.put_line (l_qry);

      OPEN o_susb_dtls FOR l_qry;
   END prc_search_sub_dtls;

   PROCEDURE prc_update_sub_dtls (
      i_sub_cha_number     IN       fid_channel_subscriber.sub_cha_number%TYPE,
      i_sub_per_month      IN       fid_channel_subscriber.sub_per_month%TYPE,
      i_sub_per_year       IN       fid_channel_subscriber.sub_per_year%TYPE,
      i_sub_ter_code       IN       fid_channel_subscriber.sub_ter_code%TYPE,
      i_sub_suc_code       IN       fid_channel_subscriber.sub_suc_code%TYPE,
      i_sub_update_count   IN       fid_channel_subscriber.sub_update_count%TYPE,
      i_sub_actual         IN       fid_channel_subscriber.sub_actual%TYPE,
      i_sub_equated        IN       fid_channel_subscriber.sub_equated%TYPE,
      o_update             OUT      NUMBER
   )
   AS
      l_qry                VARCHAR2 (1000);
      l_sub_update_count   fid_channel_subscriber.sub_update_count%TYPE;
      l_fim_status         VARCHAR2 (10);
      ---Added by Ashish Shukla Date [21 feb 2013] for hold input date ---
      l_date_input         DATE;
      l_live_date          DATE;
      --- end
      l_fim_split_region   VARCHAR2 (10);
      l_function_return    NUMBER;
   BEGIN
      --Added by Ashish Shukla Date[25-feb 2013]--
      l_function_return :=
                         history_date_check (i_sub_per_month, i_sub_per_year);

      --- This loop Added By Ashish Shukla Date[22-Feb-2013] For Comparision b/w Live Date and History Date for region split effect-----
      IF (l_function_return < 1)
      Then
         --DBMS_OUTPUT.put_line ('in if');

      BEGIN
         SELECT NVL (fim_status, 'C')
           INTO l_fim_status
           FROM fid_financial_month
          where fim_month = i_sub_per_month and fim_year = i_sub_per_year;
       exception
        when no_data_found
        THEN
        raise_application_error
                            (-20414,
                                'Financial Month does not exist for '
                             || i_sub_per_month
                             || '-'
                             || i_sub_per_year
                            );
        END;


      ELSIF (l_function_return = 1)
      Then
         --dbms_output.put_line ('in than');
        BEGIN
         SELECT fim_status, fim_split_region
           INTO l_fim_status, l_fim_split_region
           FROM fid_financial_month
          WHERE fim_month = i_sub_per_month
            AND fim_year =
                   i_sub_per_year
                          -- and   fim_split_region=nvl(fim_split_region,2)  ;
            and fim_split_region = 2;
        exception
        when no_data_found
        THEN
        raise_application_error
                            (-20414,
                                'Financial Month does not exist for '
                             || i_sub_per_month
                             || '-'
                             || i_sub_per_year
                            );
        END;


      END IF;

      IF (l_fim_status = 'C')
      THEN
         raise_application_error
                            (-20414,
                                'Operation cannot be performed as the month '
                             || i_sub_per_month
                             || '-'
                             || i_sub_per_year
                             || ' is closed'
                            );
         o_update := -1;
      END IF;

      o_update := 1;

      BEGIN
         SELECT sub_update_count
           INTO l_sub_update_count
           FROM fid_channel_subscriber
          WHERE sub_cha_number = i_sub_cha_number
            AND sub_per_month = i_sub_per_month
            AND sub_per_year = i_sub_per_year
            AND sub_ter_code = i_sub_ter_code
            AND sub_suc_code = i_sub_suc_code;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            pkg_fin_mnet_susb_mnt.prc_add_sub_dtls (i_sub_cha_number,
                                                    i_sub_per_month,
                                                    i_sub_per_year,
                                                    i_sub_ter_code,
                                                    i_sub_suc_code,
                                                    i_sub_update_count,
                                                    i_sub_actual,
                                                    i_sub_equated,
                                                    o_update
                                                   );
      END;

      --    dbms_output.put_line('l_SUB_UPDATE_COUNT 1111111 '||l_SUB_UPDATE_COUNT);
      IF i_sub_update_count >= 0
      THEN
         SELECT sub_update_count
           INTO l_sub_update_count
           FROM fid_channel_subscriber
          WHERE sub_cha_number = i_sub_cha_number
            AND sub_per_month = i_sub_per_month
            AND sub_per_year = i_sub_per_year
            AND sub_ter_code = i_sub_ter_code
            AND sub_suc_code = i_sub_suc_code;

         --dbms_output.put_line('l_SUB_UPDATE_COUNT 22222222 '||l_SUB_UPDATE_COUNT);
         IF l_sub_update_count = i_sub_update_count
         THEN
            BEGIN
               UPDATE fid_channel_subscriber
                  SET sub_actual = i_sub_actual,
                      sub_equated = i_sub_equated,
                      sub_update_count = sub_update_count + 1
                WHERE sub_cha_number = i_sub_cha_number
                  AND sub_per_month = i_sub_per_month
                  AND sub_per_year = i_sub_per_year
                  AND sub_ter_code = i_sub_ter_code
                  AND sub_suc_code = i_sub_suc_code;
            EXCEPTION
               WHEN OTHERS
               THEN
                  o_update := -1;
            END;
         ELSE
            raise_application_error
               (-20414,
                'The Record has been modified by some other user. Please retrive the modified data'
               );
            o_update := -1;
         END IF;
      END IF;
   /*        if l_SUB_UPDATE_COUNT = i_SUB_UPDATE_COUNT
           then
               begin
                   update     FID_CHANNEL_SUBSCRIBER
                   set    SUB_ACTUAL    =  i_SUB_ACTUAL
                   ,    SUB_EQUATED    =  i_SUB_EQUATED
                   ,    SUB_UPDATE_COUNT = SUB_UPDATE_COUNT + 1
                   where     SUB_CHA_NUMBER     =  i_SUB_CHA_NUMBER
                   and    SUB_PER_MONTH      =  i_SUB_PER_MONTH
                   and    SUB_PER_YEAR       =  i_SUB_PER_YEAR
                   and    SUB_TER_CODE       =  i_SUB_TER_CODE
                   and    SUB_SUC_CODE    =  i_SUB_SUC_CODE
                   ;
               exception
               when others
               then
                   o_update := -1;
               end;
           end if; */

   --        end if;
   END prc_update_sub_dtls;

   PROCEDURE prc_add_sub_dtls (
      i_sub_cha_number     IN       fid_channel_subscriber.sub_cha_number%TYPE,
      i_sub_per_month      IN       fid_channel_subscriber.sub_per_month%TYPE,
      i_sub_per_year       IN       fid_channel_subscriber.sub_per_year%TYPE,
      i_sub_ter_code       IN       fid_channel_subscriber.sub_ter_code%TYPE,
      i_sub_suc_code       IN       fid_channel_subscriber.sub_suc_code%TYPE,
      i_sub_update_count   IN       fid_channel_subscriber.sub_update_count%TYPE,
      i_sub_actual         IN       fid_channel_subscriber.sub_actual%TYPE,
      i_sub_equated        IN       fid_channel_subscriber.sub_equated%TYPE,
      o_success            OUT      NUMBER
   )
   AS
   BEGIN
      BEGIN
         INSERT INTO fid_channel_subscriber
                     (sub_cha_number, sub_per_month, sub_per_year,
                      sub_ter_code, sub_suc_code, sub_update_count,
                      sub_actual, sub_equated, sub_entry_date
                     )
              VALUES (i_sub_cha_number, i_sub_per_month, i_sub_per_year,
                      i_sub_ter_code, i_sub_suc_code, 0,
                      i_sub_actual, i_sub_equated, SYSDATE
                     );

         o_success := 1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            o_success := -1;
            raise_application_error (-20428,
                                     'Error in insertintg the data '
                                     || SQLERRM
                                    );
      END;
   END;

   ---This Function Added By Ashish Shukla Date[25-Feb-2013] -----
   FUNCTION history_date_check (i_month IN NUMBER, i_year IN NUMBER)
      RETURN NUMBER
   AS
      l_status       VARCHAR2 (10);
      l_live_date    DATE;
      l_date_input   DATE;
      l_return       NUMBER;
   BEGIN
      BEGIN
         SELECT TO_DATE (content, 'DD-MON-YYYY')
           INTO l_live_date
           FROM x_fin_configs
          WHERE KEY = 'GO-LIVEDATE';

         l_date_input :=
            TO_DATE ('01' || TO_CHAR (i_month, '09') || TO_CHAR (i_year),
                     'DDMMYYYY'
                    );

         IF (l_date_input < l_live_date)
         THEN
            l_return := 0;
         ELSIF (l_date_input >= l_live_date)
         THEN
            l_return := 1;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_return := 0;
            raise_application_error (-20002,
                                     'An error occurred. Message: ' || SQLERRM
                                    );
      END;

      RETURN l_return;
   EXCEPTION
      WHEN OTHERS
      THEN
         l_return := 0;
         raise_application_error (-20002,
                                  'An error occurred. Message: ' || SQLERRM
                                 );
         RETURN l_return;
END history_date_check; 

 ---Added by Sushma to insert/update subscriber data
Procedure prc_insert_sub_dtls
(
   I_ROW_NUMBER         IN       x_pkg_common_var.varchar_array,
   i_sub_cha_name       IN       fid_channel.cha_Short_name%TYPE,
   i_sub_per_month      IN       x_pkg_common_var.number_array,
   i_sub_per_year       IN       x_pkg_common_var.number_array,
   i_sub_ter_code       IN       x_pkg_common_var.varchar_array,  
   i_sub_suc_code       IN       x_pkg_common_var.varchar_array,     
   i_sub_actual         IN       x_pkg_common_var.number_array,  
   i_sub_equated        IN       x_pkg_common_var.number_array,
   i_sub_number         IN       x_pkg_common_var.number_array,
   i_entry_oper         IN       fid_channel_subscriber.SUB_ENTRY_OPER%TYPE,
   O_success            OUT      NUMBER,
   O_fail_data          OUT      sys_refcursor,
   O_fail_cnt           OUT      NUMBER
)
as 
v_month         NUMBER;
v_year          NUMBER;
v_rownumber     NUMBER;
v_ter_code      varchar2(50);
l_fim_status    varchar2(1);
v_cha_number    NUMBER;
v_sub_suc_code  varchar2(10);
l_ter_count     NUMBER;
v_sub_number    NUMBER;
v_sub_actual    NUMBER;
v_sub_equated   NUMBER;
V_ERROR_MSG     varchar2(1000);
v_number         NUMBER; 
l_warnings        NUMBER; 
begin     

   begin 
    select SUB_ID 
       into v_cha_number
    from FIN_SUB_TYPE 
    where upper(SUB_TYPE)  = upper(i_sub_cha_name) ;
   exception when no_data_found
   then
    raise_application_error(-20414,'Incorrect Information for the Field Sub Type in import data ' );
   end;

   For i in 1..I_ROW_NUMBER.count
   LOOP   
      v_number := I_ROW_NUMBER(i);
      v_month := i_sub_per_month(i);
      v_year  := i_sub_per_year(i);
      v_ter_code := i_sub_ter_code(i);
      v_sub_suc_code := i_sub_suc_code(i);
      v_sub_actual  := i_sub_actual(i);
      v_sub_equated  := i_sub_equated(i);
      v_sub_number   := i_sub_number(i);
     
     --check whether user is trying to upload the data for closed/Budget month.
     --Should upload the data for open month only
       BEGIN
         SELECT fim_status
           INTO l_fim_status
           FROM fid_financial_month
          WHERE fim_month = v_month
            AND fim_year =  v_year
            and fim_split_region = 2;
        exception
         when no_data_found
         THEN
           raise_application_error(-20414,'Financial Month does not exist for '|| v_month|| '-'|| v_year);
           o_success := -1;
        END;
      
      IF l_fim_status in('C','B')
      THEN         
         V_ERROR_MSG := 'Subscriber Information should be for open month only';
         raise_application_error(-20414,'Subscriber Information should be for open month only');
         o_success := -1;
      END IF;
    
      ---check wheather enter trritory is mapped with channel or not
        select count(1)
          INTO l_ter_count
       from fid_channel_territory
      where cht_ter_code = v_ter_code
      and CHT_CHA_NUMBER = v_cha_number ;
      
      IF l_ter_count = 0
      THEN
        V_ERROR_MSG := V_ERROR_MSG || CASE WHEN V_ERROR_MSG IS NULL THEN 'Incorrect Information for the Field Territory Code in import data '
                                   ELSE ',Incorrect Information for the Field Territory Code in import data ' END;
         raise_application_error(-20414,'Incorrect Information for the Field Territory Code in import data ' );
         o_success := -1;
      END IF;      
      
     ---check wheather enter subscriber sud code(SUD,MUD,HOT,COM) is valid or not 
      select count(1) 
         INTO l_ter_count
      from fid_type_cat_linking  
    where upper(TCL_SUBTYPE_CODE) = upper(i_sub_cha_name)
    and upper(TCL_SUBCAT_CODE) = upper(v_sub_suc_code);
  
      IF l_ter_count = 0
      THEN
        V_ERROR_MSG := V_ERROR_MSG || CASE WHEN V_ERROR_MSG IS NULL THEN 'Incorrect Information for the Field SUB_SUC_CODE in import data '
                                   ELSE ',Incorrect Information for the Field SUB_SUC_CODE in import data ' END;
         raise_application_error(-20414,'Incorrect Information for the Field SUB_SUC_CODE in import data ' );
         o_success := -1;
      END IF;
      
      IF V_ERROR_MSG  is not null
      THEN
       insert into x_sub_errror_log(SEL_ROW_NUMBER,
                                    SEL_TER_NAME,
                                    SEL_MONTH,
                                    SEL_YEAR,
                                    SEL_SUB_SUC_CODE,
                                    SEL_FAIL_REASON
                                  )
                            VALUES(v_number,
                                   v_ter_code,
                                   v_month,
                                   v_year,
                                   v_sub_suc_code,
                                   V_ERROR_MSG
                                   );
      END IF;
      
      select count(1)
          into l_warnings
        from x_sub_errror_log ;
      
     IF l_warnings = 0
     THEN
      BEGIN
        IF v_sub_number = 0
        THEN
         INSERT INTO fid_channel_subscriber
                     (sub_cha_number, sub_per_month, sub_per_year,
                      sub_ter_code, sub_suc_code, sub_update_count,
                      sub_actual, sub_equated, sub_entry_date,SUB_ENTRY_OPER,sub_number
                     )
              VALUES (v_cha_number, v_month, v_year,
                      v_ter_code, v_sub_suc_code, 0,
                      v_sub_actual, v_sub_equated, SYSDATE,i_entry_oper,x_seq_Sub_number.nextval
                     );
         
        ELSE         
               UPDATE fid_channel_subscriber
                  SET sub_actual = v_sub_actual,
                      sub_equated = v_sub_equated,
                      sub_update_count = sub_update_count + 1
                WHERE sub_number = v_sub_number ;            
        END IF;
        
        o_success := 1;
        --commit;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            o_success := -1;
            raise_application_error (-20428,'Error in insertintg the data '|| SQLERRM);
      END;
    END IF;    
  END LOOP;
  commit;
  open O_fail_data for select * from x_sub_errror_log;
  select count(1) into O_fail_cnt from  x_sub_errror_log;
  
end prc_insert_sub_dtls;

 -- Return Excel file path.
PROCEDURE prc_return_subtemppath (o_data OUT sys_refcursor)
AS
 BEGIN
      OPEN o_data FOR
         SELECT "Content"
           FROM fwk_appparameter
          WHERE ID = 17;
END prc_return_subtemppath;
   
END pkg_fin_mnet_susb_mnt;
/