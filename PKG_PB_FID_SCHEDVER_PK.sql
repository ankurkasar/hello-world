CREATE OR REPLACE PACKAGE                   "PKG_PB_FID_SCHEDVER_PK" AS
 -------------------------------------------------------------------------------
 --  FID SCHEDVER PACKAGE SPEC                                                --
 --  DATE         WHO                  WHAT                         VERSION   --
 -- ------------------------------------------------------------------------- --
 --  18-05-2001 | GEN FROM DESIGNER |  CREATED IN VSS              | 1.0.0    --
 --  31-05-2001 | JUANITA           |  BUGFIX NOT_PAIDS            | 1.0.0    --
 --  06-08-2015 | Jawahar Garg	    |  Omnibus free schedule       | 1.1.0    --
 -------------------------------------------------------------------------------

   -- SUB-PROGRAM UNIT DECLARATIONS
   PROCEDURE RUN_RSLT (V_ACTION    IN NUMBER,
                       V_PROC      IN VARCHAR2,
                       V_PERIOD    IN NUMBER,
                       V_COMMENT   IN VARCHAR2);

   PROCEDURE MAIN (FROM_PERIOD      IN     NUMBER,
                   TO_PERIOD        IN     NUMBER,
                   UPD_IND          IN     VARCHAR2,
                   I_USER_ID        IN     VARCHAR2,
                   --PURE FINANCE[BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                   I_SPLIT_REGION   IN     VARCHAR2,
                   --PURE FINANCE END
                   V_ERR_CODE          OUT NUMBER);

   PROCEDURE MONTHLY_RUN (C_YEAR           IN     NUMBER,
                          C_MONTH          IN     NUMBER,
                          UPD_YN           IN     VARCHAR2,
                          I_USER_ID        IN     VARCHAR2,
                          --PURE FINANCE[BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                          I_SPLIT_REGION   IN     VARCHAR2,
                          --PURE FINANCE END
                          ERR_CODE            OUT NUMBER);

   PROCEDURE UPD_SUBS_BY_TER_MUX2 (C_YEAR      IN NUMBER,
                                   C_MONTH     IN NUMBER,
                                   C_CHANNEL   IN NUMBER);

   PROCEDURE REPORT_FIND_SCH_TYPE (C_MONTH            IN     NUMBER,
                                   C_YEAR             IN     NUMBER,
                                   C_VERIFICATION_1      OUT VARCHAR2);

   PROCEDURE REPORT_SCHEDULE (C_CURR_YEAR        IN     NUMBER,
                              C_CURR_MONTH       IN     NUMBER,
                              C_PREVIOUS_YEAR    IN     NUMBER,
                              C_PREVIOUS_MONTH   IN     NUMBER,
                              C_UPD_YN           IN     VARCHAR2,
                              I_USER_ID          IN     VARCHAR2,
                              --PURE FINANCE[BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                              I_SPLIT_REGION     IN     VARCHAR2,
                              --PURE FINANCE END
                              C_VERIFICATION_2      OUT VARCHAR2);

   PROCEDURE REPORT_COUNT_PAID_INT2 (C_YEAR             IN     NUMBER,
                                     C_MONTH            IN     NUMBER,
                                     C_UPD_YN           IN     VARCHAR2,
                                     C_VERIFICATION_3      OUT VARCHAR2);

   PROCEDURE REPORT_PRIMETIME_EXC (C_YEAR             IN     NUMBER,
                                   C_MONTH            IN     NUMBER,
                                   C_UPD_YN           IN     VARCHAR2,
                                   C_VERIFICATION_3      OUT VARCHAR2);

   -- PL/SQL SPECIFICATION
   -- CATCHUP CHANGES BY ANIRUDHA ON 01-NOV-2012
   PROCEDURE PRC_CP_SCH_VERIFICATION (I_FROM_DATE   IN NUMBER,
                                      I_TO_DATE     IN NUMBER,
                                      I_USER_ID     IN VARCHAR2);

   PROCEDURE PRC_CP_INSERT_TEMP_SCH (
      I_PLT_ID         IN X_CP_PLAY_LIST.PLT_ID%TYPE,
      I_PLT_SCH_TYPE   IN X_CP_PLAY_LIST.PLT_SCH_TYPE%TYPE);

   -- END CATCHUP CHANGES BY ANIRUDHA ON 01-NOV-2012

   --PURE FINANCE BIOSCOPE/NON BIOSCOPE  CHANGES [MANGESH_GULHANE][2013-02-25]
   PROCEDURE PRC_FIN_UPDATE_SCH_TYPE (C_CURR_YEAR    IN NUMBER,
                                      C_CURR_MONTH   IN NUMBER,
                                      C_NUMBER       IN NUMBER,
                                      C_BLOCK        IN VARCHAR2);

   PROCEDURE PRC_FIN_SCH_VEREX (I_CURR_YEAR        IN NUMBER,
                                I_CURR_MONTH       IN NUMBER,
                                I_PREVIOUS_YEAR    IN NUMBER,
                                I_PREVIOUS_MONTH   IN NUMBER,
                                I_SPLIT_REGION     IN VARCHAR2);

   PROCEDURE PRC_FIN_SCH_VEREX_NEW_RULE (I_CURR_YEAR        IN NUMBER,
                                         I_CURR_MONTH       IN NUMBER,
                                         I_PREVIOUS_YEAR    IN NUMBER,
                                         I_PREVIOUS_MONTH   IN NUMBER,
                                         I_SPLIT_REGION     IN VARCHAR2);

   PROCEDURE PRC_FIN_UPD_AFR_FREE_SCH (I_SCH_NUMBER       IN NUMBER,
                                       I_SCH_LIC_NUMBER   IN NUMBER,
                                       I_SCH_CHA_NUMBER   IN NUMBER,
                                       I_CHA_START_TIME   IN NUMBER,
                                       I_SCH_DATE         IN DATE,
                                       I_SCH_TIME         IN NUMBER,
                                       I_LIC_FREE_RPT     IN NUMBER,
                                       I_LIC_RPT_PERIOD   IN NUMBER,
                                       I_SCH_TYPE         IN VARCHAR2);

   PROCEDURE prc_cost_rule_config_info (
      i_sch_lic_number               IN     fid_license.lic_number%TYPE,
      i_lic_start                    IN     fid_license.lic_start%TYPE,
      i_lic_end                      IN     fid_license.lic_end%TYPE,
      i_cal_month                    IN     fid_license.lic_start%TYPE,
      i_lic_showing_lic              IN     fid_license.lic_showing_lic%TYPE,
      o_alloc_costed_runs               OUT x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE,
      o_sch_window                      OUT x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE,
      o_sw1_start                       OUT x_fin_costing_rule_config.crc_lic_start_from%TYPE,
      o_sw1_end                         OUT x_fin_costing_rule_config.crc_lic_start_from%TYPE,
      o_sw2_start                       OUT x_fin_costing_rule_config.crc_lic_start_from%TYPE,
      o_sw2_end                         OUT x_fin_costing_rule_config.crc_lic_start_from%TYPE,
      o_crc_costed_runs_fin_year_1      OUT x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE);
--PURE FINANCE END
  --ver 1.1 Start
  PROCEDURE prc_fin_upd_omnibus_sch (
   i_sch_number       IN NUMBER,
   i_sch_lic_number   IN NUMBER,
   i_sch_cha_number   IN NUMBER,
   i_cha_start_time   IN NUMBER,
   i_sch_date         IN DATE,
   i_sch_time         in number,
   i_lic_free_rpt     in number,
   i_lic_rpt_period   in number,
   I_SCH_TYPE         in varchar2);
  function FNC_GET_BACK_TO_BACK_SCH
								  (
								   I_SWD_ID 		in number,
								   i_sch_lic_number IN NUMBER,
								   i_gen_ser_number in NUMBER,
								   I_WEEK_FIRST_DAY in date,
								   I_WEEK_LAST_DAY 	in date
								  )return number;
   --Ver 1.1 End
END PKG_PB_FID_SCHEDVER_PK;

/


CREATE OR REPLACE PACKAGE BODY                   "PKG_PB_FID_SCHEDVER_PK"
IS
--------------------------------------------------------------------------------------------------------------------
--REVISIONS:
--Ver        Date          Author            Description
---------  ----------    ------------      -------------------------------------------------------------------------
--1.1		06-Aug-2015   Jawahar Garg	   [Omnibus CR]Added new rule for amort code 'F' for omnibus schedule
--------------------------------------------------------------------------------------------------------------------
   PROCEDURE RUN_RSLT (V_ACTION    IN NUMBER,
                       V_PROC      IN VARCHAR2,
                       V_PERIOD    IN NUMBER,
                       V_COMMENT   IN VARCHAR2)
   IS
   /*-------------------------------------------------------------------------------*/
   /* BUILD IN THE UPD_YN INDICATOR SO THAT ONLY THEWARNINGS PART COULD BE DONE     */
   /* AND NO UPDATING OF SCHEDULES ETC.  JP  26/01/2000                             */
   /*-------------------------------------------------------------------------------*/
   /*--    FUNCTION   : TO STORE RUN RESULTS FOR A BATCH PROCEDURE                  */
   /*-------------------------------------------------------------------------------*/
   BEGIN
      IF V_ACTION = 1
      THEN
         DELETE FROM FID_RUN_MSG
               WHERE RUN_PROC = UPPER (V_PROC);
      ELSIF V_ACTION = 2
      THEN
         INSERT INTO FID_RUN_MSG (RUN_PROC,
                                  RUN_PERIOD,
                                  RUN_CURR_DATE,
                                  RUN_COMMENTS)
              VALUES (UPPER (V_PROC),
                      V_PERIOD,
                      SYSDATE,
                      UPPER (V_COMMENT));
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   PROCEDURE MAIN (FROM_PERIOD      IN     NUMBER,
                   TO_PERIOD        IN     NUMBER,
                   UPD_IND          IN     VARCHAR2,
                   I_USER_ID        IN     VARCHAR2,
                   --PURE FINANCE[BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                   I_SPLIT_REGION   IN     VARCHAR2,
                   --PURE FINANCE END
                   V_ERR_CODE          OUT NUMBER)
   IS
      /*-------------------------------------------------------------------------------*/
      /*--    FUNCTION   : TO PROCESS ALL THE CHANNELLED SCHEDULES FOR A PARTICULAR    */
      /*--                 MONTH, SET THE SCH_TYPE TO EITHER 'F' (FREE) OR 'P' (PAID)  */
      /*--                 AND IDENTIFY THOSE SITUATIONS WHERE CROSS-CHANNEL           */
      /*--                 MULTIPLEXING IS NOT BEING USED EFFICIENTLY.                 */
      /*--                                                                             */
      /*-------------------------------------------------------------------------------*/
      UPD_YN        VARCHAR2 (1) := UPD_IND;
      FROM_YYYYMM   NUMBER := FROM_PERIOD;
      TO_YYYYMM     NUMBER := TO_PERIOD;
      C_MONTH       NUMBER := SUBSTR (FROM_YYYYMM, 5, 2);
      C_YEAR        NUMBER := SUBSTR (FROM_YYYYMM, 1, 4);
      C_ENDMONTH    NUMBER := SUBSTR (TO_YYYYMM, 5, 2);
      C_ENDYEAR     NUMBER := SUBSTR (TO_YYYYMM, 1, 4);
      SV_RUNS       NUMBER
         := ( (C_ENDYEAR * 12) + C_ENDMONTH) - ( (C_YEAR * 12) + C_MONTH);
      --C_VERIFICATION VARCHAR2(1);
      REP_FILE      VARCHAR2 (30);
      ERR_CODE      NUMBER := 0;
      DDL_CURSOR    INTEGER;
      DDL_RETURN    INTEGER;
      SG_STATUS     VARCHAR2 (20);
   BEGIN
      DBMS_OUTPUT.PUT_LINE (
         'SCHEDVER START AT :' || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
      V_ERR_CODE := 0;
      /*-------------------------------------------------------------------------------*/
      /*- DELETE PREVIOUS RUN RESULTS                                                  */
      /*-------------------------------------------------------------------------------*/
      --      SELECT STATUS INTO SG_STATUS FROM DBA_ROLLBACK_SEGS WHERE SEGMENT_NAME = 'RS_BATCH';
      --      IF SG_STATUS = 'OFFLINE' THEN
      -- VARY ROLLBACK SEGMENT ONLINE
      --        DDL_CURSOR := DBMS_SQL.OPEN_CURSOR;
      --        DBMS_SQL.PARSE(DDL_CURSOR,'ALTER ROLLBACK SEGMENT RS_BATCH ONLINE',DBMS_SQL.V7);
      --        DDL_RETURN := DBMS_SQL.EXECUTE(DDL_CURSOR);
      --        DBMS_SQL.CLOSE_CURSOR(DDL_CURSOR);
      --      END IF;
      --      COMMIT;
      --      SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
      PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (1,
                                       'FIDSCH06',
                                       C_YEAR || LPAD (C_MONTH, 2, 0),
                                       ' ');

      IF UPD_YN = 'Y'
      THEN
         PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                          'FIDSCH06',
                                          C_YEAR || LPAD (C_MONTH, 2, 0),
                                          'STARTING RUN');
      ELSE
         PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                          'FIDSCH06',
                                          C_YEAR || LPAD (C_MONTH, 2, 0),
                                          'STARTING WARNING RUN');
      END IF;

     <<MAIN_LOOP>>
      FOR I IN FROM_PERIOD .. TO_PERIOD
      LOOP
         PKG_PB_FID_SCHEDVER_PK.MONTHLY_RUN (C_YEAR,
                                             C_MONTH,
                                             UPD_YN,
                                             I_USER_ID,
                                             --PURE FINANCE[ADDED NEW  PARAM FOR  AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                                             I_SPLIT_REGION,
                                             ERR_CODE);

         IF ERR_CODE <> 0
         THEN
            V_ERR_CODE := ERR_CODE;
            DBMS_OUTPUT.PUT_LINE ('ERR CODE IS ' || ERR_CODE);
            EXIT MAIN_LOOP;
         END IF;

         IF C_MONTH = 12
         THEN
            C_MONTH := 1;
            C_YEAR := C_YEAR + 1;
         ELSE
            C_MONTH := C_MONTH + 1;
         END IF;
      END LOOP;

      /*------------------KARIM - START-----------------------------
      DBMS_OUTPUT.PUT_LINE('BEFORE KARIM START');
      C_MONTH := SUBSTR (FROM_YYYYMM, 5, 2);
      C_YEAR := SUBSTR (FROM_YYYYMM, 1, 4);
      FOR I IN FROM_PERIOD .. TO_PERIOD
            LOOP

      DECLARE
        REMAINING_PAID_RUNS NUMBER;
        EARLIER_PAID_RUNS NUMBER;
        TOTAL_PAID_RUNS_ON_CHNL NUMBER;
        CURSOR SCH_C IS SELECT SCH_NUMBER, SCH_LIC_NUMBER, SCH_DATE, SCH_TIME, SCH_CHA_NUMBER FROM FID_SCHEDULE, FID_LICENSE, FID_GENERAL
        WHERE SCH_LIC_NUMBER = LIC_NUMBER AND LIC_GEN_REFNO = GEN_REFNO
          AND UPPER(GEN_TYPE) IN (SELECT UPPER(CPT_GEN_TYPE) FROM SGY_PB_COSTED_PROG_TYPE)
          AND TO_CHAR(SCH_DATE, 'YYYY') = C_YEAR AND TO_CHAR(SCH_DATE, 'MM') = LPAD(C_MONTH, 2, 0)
          --AND SCH_DATE >= TO_DATE ('01-SEP-2012','DD-MON-YYYY')
          ORDER BY SCH_LIC_NUMBER, SCH_CHA_NUMBER, SCH_DATE, SCH_TIME;
      BEGIN
        FOR SCH IN SCH_C
        LOOP
          BEGIN
          SELECT NVL(LCR_CHA_COSTED_RUNS, 0) INTO TOTAL_PAID_RUNS_ON_CHNL
          FROM FID_LICENSE_CHANNEL_RUNS
          WHERE LCR_LIC_NUMBER = SCH.SCH_LIC_NUMBER
            AND LCR_CHA_NUMBER = SCH.SCH_CHA_NUMBER
            AND LCR_COST_IND = 'Y';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              TOTAL_PAID_RUNS_ON_CHNL:=0;
          END;
          IF SCH.SCH_LIC_NUMBER = 515504 THEN
            DBMS_OUTPUT.PUT_LINE('TOTAL_PAID_RUNS_ON_CHNL - 515504 - ' || SCH.SCH_CHA_NUMBER || ' - ' || TOTAL_PAID_RUNS_ON_CHNL);
          END IF;
          BEGIN
          SELECT NVL(COUNT(SCH_NUMBER),0) INTO EARLIER_PAID_RUNS
          FROM FID_SCHEDULE
          WHERE SCH_TYPE = 'P'
            AND SCH_LIC_NUMBER = SCH.SCH_LIC_NUMBER
            AND SCH_DATE <= SCH.SCH_DATE
            AND SCH_TIME < SCH.SCH_TIME
            AND SCH_CHA_NUMBER = SCH.SCH_CHA_NUMBER;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              EARLIER_PAID_RUNS := 0;
          END;
          IF SCH.SCH_LIC_NUMBER = 515504 THEN
            DBMS_OUTPUT.PUT_LINE('515504 - ' || SCH.SCH_CHA_NUMBER || ' - ' || EARLIER_PAID_RUNS);
          END IF;
          IF TOTAL_PAID_RUNS_ON_CHNL > EARLIER_PAID_RUNS
          THEN
            UPDATE FID_SCHEDULE
            SET SCH_TYPE = 'P'
            WHERE SCH_NUMBER = SCH.SCH_NUMBER;
          ELSE
            UPDATE FID_SCHEDULE
            SET SCH_TYPE = 'N'
            WHERE SCH_NUMBER = SCH.SCH_NUMBER;
          END IF;

        END LOOP;
      END;
               IF C_MONTH = 12
               THEN
                  C_MONTH := 1;
                  C_YEAR := C_YEAR + 1;
               ELSE
                  C_MONTH := C_MONTH + 1;
               END IF;
            END LOOP;
      DBMS_OUTPUT.PUT_LINE('AFTER KARIM END');
      ------------------KARIM - END-------------------------------*/
      IF UPD_YN = 'Y'
      THEN
         PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (
            2,
            'FIDSCH06',
            TO_PERIOD,
            '*** END OF SCHEDULE VERIFICATION ***');
      ELSE
         PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (
            2,
            'FIDSCH06',
            TO_PERIOD,
            '*** END OF SCHEDULE WARNING VERIFICATION ***');
      END IF;

      COMMIT;
   -- VARY ROLLBACK SEGMENT OFFLINE
   --   DDL_CURSOR := DBMS_SQL.OPEN_CURSOR;
   --   DBMS_SQL.PARSE(DDL_CURSOR,'ALTER ROLLBACK SEGMENT RS_BATCH OFFLINE',DBMS_SQL.V7);
   --   DDL_RETURN := DBMS_SQL.EXECUTE(DDL_CURSOR);
   --   DBMS_SQL.CLOSE_CURSOR(DDL_CURSOR);
   END;                                                             /*-MAIN */

   PROCEDURE MONTHLY_RUN (C_YEAR           IN     NUMBER,
                          C_MONTH          IN     NUMBER,
                          UPD_YN           IN     VARCHAR2,
                          I_USER_ID        IN     VARCHAR2,
                          --PURE FINANCE[BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                          I_SPLIT_REGION   IN     VARCHAR2,
                          --PURE FINANCE END
                          ERR_CODE            OUT NUMBER)
   IS
      /*-------------------------------------------------------------------------------*/
      /*- IF THE MONTH (FID_SCHEDULE_LOCK) HAS BEEN LOCKED OR DOES NOT EXIST,          */
      /*- THEN NO FURTHER PROCESSING SHOULD BE PERMITTED                               */
      /*-------------------------------------------------------------------------------*/
      RUN_PERIOD         NUMBER := C_YEAR || LPAD (C_MONTH, 2, 0);
      C_PREVIOUS_MONTH   NUMBER;
      C_PREVIOUS_YEAR    NUMBER;
      C_UPD_YN           VARCHAR2 (1) := UPD_YN;

      CURSOR GET_CHA_LIC
      IS
         SELECT DISTINCT
                SX1_SCH_CHA_NUMBER, SX1_LIC_NUMBER, SX1_LIC_CHS_NUMBER
           FROM FID_SCHEDULE_MUX1;

      C_CHANUMBER        NUMBER;
      C_OLD_CHANNEL      NUMBER;
      C_LICNUMBER        NUMBER;
      C_CHSNUMBER        NUMBER;
      C_VERIFICATION_1   VARCHAR2 (1);
      C_VERIFICATION_2   VARCHAR2 (1);
      C_VERIFICATION_3   VARCHAR2 (1);
      C_VERIFY           VARCHAR2 (10);
      DDL_CURSOR         INTEGER;
      DDL_RETURN         INTEGER;
   BEGIN
      DBMS_OUTPUT.PUT_LINE (
            'MONTHLY RUN :'
         || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS')
         || ' FOR '
         || C_YEAR
         || C_MONTH);

      /*-------------------------------------------------------------------------------*/
      /*- FIND THE PARAMETERS OF THE PREVIOUS PERIOD I.E. C_PREVIOUS_YEAR AND          */
      /*- C_PREVIOUS_MONTH                                                             */
      /*-------------------------------------------------------------------------------*/
      IF C_MONTH = 1
      THEN
         C_PREVIOUS_YEAR := C_YEAR - 1;
         C_PREVIOUS_MONTH := 12;
      ELSE
         C_PREVIOUS_YEAR := C_YEAR;
         C_PREVIOUS_MONTH := C_MONTH - 1;
      END IF;

      /*-------------------------------------------------------------------------------*/
      /*- DELETE THE TEMPORARY TABLES                                                  */
      /*-------------------------------------------------------------------------------*/
      DELETE FROM FID_WRN_SVR
            WHERE WRN_PERIOD = RUN_PERIOD;

      COMMIT;
      -- TRUNCATE WORK TABLES
      DDL_CURSOR := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE (DDL_CURSOR,
                      'TRUNCATE TABLE FID_SCHEDULE_MUX1',
                      DBMS_SQL.V7);
      DBMS_SQL.PARSE (DDL_CURSOR,
                      'TRUNCATE TABLE FID_SCHEDULE_MUX3',
                      DBMS_SQL.V7);
      DBMS_SQL.PARSE (DDL_CURSOR,
                      'TRUNCATE TABLE FID_SCHEDULE_MUX4',
                      DBMS_SQL.V7);
      DDL_RETURN := DBMS_SQL.EXECUTE (DDL_CURSOR);
      DBMS_SQL.CLOSE_CURSOR (DDL_CURSOR);
      SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;

      DELETE FROM FID_WRN_SVR
            WHERE WRN_PERIOD = RUN_PERIOD;

      COMMIT;
      SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;

      DELETE FROM FID_SVR_REP1
            WHERE SVR_PERIOD = RUN_PERIOD;

      COMMIT;
      SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
      /*-------------------------------------------------------------------------------*/
      /*- FIRST POPULATE THE TABLE FID_SCHEDULE_MUX1.                                  */
      /*-------------------------------------------------------------------------------*/
      PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                       'FIDSCH06',
                                       C_YEAR || LPAD (C_MONTH, 2, 0),
                                       'POPULATING MUX1');
      DBMS_OUTPUT.PUT_LINE ('POPULATING MUX1');
      DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

      BEGIN
         INSERT INTO FID_SCHEDULE_MUX1 (SX1_LIC_NUMBER,
                                        SX1_SCH_DATE,
                                        SX1_SCH_TIME,
                                        SX1_SCH_SLOT,
                                        SX1_SCH_CHA_NUMBER,
                                        SX1_SCH_TYPE,
                                        SX1_LIC_CHS_NUMBER,
                                        SX1_CON_MUX_IND,
                                        SX1_CON_ALIGN_IND,
                                        SX1_CON_EXH_DAY_START,
                                        SX1_GEN_TITLE,
                                        SX1_CON_SHORT_NAME,
                                        SX1_SCH_NUMBER,
                                        SX1_SCH_DATE_TIME,
                                        SX1_SCH_DATE_TIME_PLUS_24HRS,
                                        SX1_SUBS_THIS_SHOWING,
                                        SX1_LIC_AMORT_CODE,
                                        SX1_ALLOC_RUNS,
                                        SX1_COSTING_RUNS,
                                        SX1_MAX_CHS,
                                        SX1_COST_IND)
            SELECT LIC_NUMBER A,
                   SCH_DATE B,
                   SCH_TIME C,
                   SCH_SLOT D,
                   SCH_CHA_NUMBER E,
                   DECODE (
                      SCH_DATE,
                      TO_DATE (
                            '01'
                         || LPAD (C_MONTH, 2, '0')
                         || LPAD (C_YEAR, 4, '0'),
                         'DDMMYYYY')
                      - 1, SCH_TYPE,
                      DECODE (CHA_NUMBER, 0, 'P', 'F'))
                      F,
                   LIC_CHS_NUMBER G,
                   CON_MUX_IND H,
                   CON_ALIGN_IND I,
                   CON_EXH_DAY_START J,
                   SUBSTR (GEN_TITLE, 1, 40) K,
                   CON_SHORT_NAME L,
                   SCH_NUMBER M,
                   TO_NUMBER (
                      DECODE (SIGN (SCH_TIME - CHA_START_TIME),
                              -1, TO_CHAR (SCH_DATE + 1, 'YYYYMMDD'),
                              TO_CHAR (SCH_DATE, 'YYYYMMDD'))
                      || LPAD (TO_CHAR (SCH_TIME), 5, '0'))
                      N,
                   TO_NUMBER (
                      DECODE (SIGN (SCH_TIME - CHA_START_TIME),
                              -1, TO_CHAR (SCH_DATE + 2, 'YYYYMMDD'),
                              TO_CHAR (SCH_DATE + 1, 'YYYYMMDD'))
                      || LPAD (TO_CHAR (SCH_TIME), 5, '0'))
                      O,
                   0 P,
                   LIC_AMORT_CODE,
                   NVL (LIC_MAX_CHA, 0),
                   NVL (LIC_SHOWING_LIC, 0),
                   --       NVL(LCR_RUNS_ALLOCATED,0)  , REMOVED BY AH. SUBSTITUTED FIELD FOR TESTING AGAINST LIC_MAX_CHA

                   --       NVL(LCR_COSTING_RUNS,0) REMOVED BY AH. FIELD NO LONGER USED, SUBSTITUED FIELD LIC_SHOWING_LIC
                   LIC_MAX_CHS,
                   LCR_COST_IND
              /***********INDICATE COSTING PER CHANNEL*******************/
              FROM FID_GENERAL,
                   FID_CHANNEL,
                   FID_CONTRACT,
                   FID_LICENSE,
                   FID_SCHEDULE,
                   FID_LICENSE_CHANNEL_RUNS,
                   --PURE FINANCE[BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                   FID_REGION,
                   FID_LICENSEE
             WHERE SCH_DATE BETWEEN (TO_DATE (
                                           '01'
                                        || LPAD (C_MONTH, 2, '0')
                                        || LPAD (C_YEAR, 4, '0'),
                                        'DDMMYYYY')
                                     - 1)
                                AND LAST_DAY (
                                       TO_DATE (
                                             '01'
                                          || LPAD (C_MONTH, 2, '0')
                                          || LPAD (C_YEAR, 4, '0'),
                                          'DDMMYYYY'))
                   AND LCR_LIC_NUMBER(+) = SCH_LIC_NUMBER
                   AND LCR_CHA_NUMBER(+) = SCH_CHA_NUMBER
                   AND LIC_NUMBER = SCH_LIC_NUMBER
                   AND CON_NUMBER = LIC_CON_NUMBER
                   AND CHA_NUMBER = SCH_CHA_NUMBER
                   and gen_refno = lic_gen_refno
                   --AND CON_NUMBER = 65070
                   --and LIC_NUMBER = 1108531
                   --PURE FINANCE[FIN 27 -BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                   AND LIC_LEE_NUMBER = LEE_NUMBER
                   --PURE FINANCE:[exclude licenses for  NCF deal ][MANGESH GULHANE][2013-02-25]
                   AND UPPER (LIC_STATUS) NOT IN ('F', 'T')
                   --PURE FINANCE END
                   AND LEE_SPLIT_REGION = REG_ID(+)
                   AND UPPER (NVL (REG_CODE, '#')) LIKE
                          UPPER (NVL (I_SPLIT_REGION, '#'));

         --PURE FINANCE END
         COMMIT;
         SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      --SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
      /*-------------------------------------------------------------------------------*/
      /*- THEN POPULATE THE TABLE FID_SCHEDULE_MUX2.                                   */
      /*-------------------------------------------------------------------------------*/
      PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                       'FIDSCH06',
                                       C_YEAR || LPAD (C_MONTH, 2, 0),
                                       'MUX3');
      DBMS_OUTPUT.PUT_LINE ('MUX3');
      DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

      BEGIN
         INSERT INTO FID_SCHEDULE_MUX3 (SX3_LIC_NUMBER,
                                        SX3_CHA_NUMBER,
                                        SX3_COUNT)
            SELECT SX1_LIC_NUMBER Z, CHT_CHA_NUMBER Y, 0 V
              FROM FID_CHANNEL_TERRITORY, FID_SCHEDULE_MUX1
             WHERE CHT_CHA_NUMBER = SX1_LIC_CHS_NUMBER
            UNION
            SELECT SX1_LIC_NUMBER, CHT_CHA_NUMBER, 0
              FROM FID_CHANNEL_SERVICE,
                   FID_CHANNEL_TERRITORY,
                   FID_SCHEDULE_MUX1
             WHERE CHS_NUMBER = SX1_LIC_CHS_NUMBER
                   AND CHS_CHA_NUMBER = CHT_CHA_NUMBER
            UNION
            SELECT SX1_LIC_NUMBER, CHT_CHA_NUMBER, 0
              FROM FID_CHANNEL_SERVICE_CHANNEL,
                   FID_CHANNEL_TERRITORY,
                   FID_SCHEDULE_MUX1
             WHERE CSC_CHS_NUMBER = SX1_LIC_CHS_NUMBER
                   AND CSC_CHA_NUMBER = CHT_CHA_NUMBER;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                       'FIDSCH06',
                                       C_YEAR || LPAD (C_MONTH, 2, 0),
                                       'MUX4');
      DBMS_OUTPUT.PUT_LINE ('MUX4');
      DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

      BEGIN
         INSERT INTO FID_SCHEDULE_MUX4 (SX4_CHA_NUMBER,
                                        SX4_TER_CODE,
                                        SX4_SUBS)
            SELECT DISTINCT SX3_CHA_NUMBER Y, CHT_TER_CODE X, 0 W
              FROM FID_CHANNEL_TERRITORY, FID_SCHEDULE_MUX3
             WHERE CHT_CHA_NUMBER = SX3_CHA_NUMBER;

         COMMIT;
         SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      /*-------------------------------------------------------------------------------*/
      /*- UPDATE FID_SCHEDULE_MUX1 AND FID_SCHEDULE_MUX2 WITH THE SUB_ACTUAL           */
      /*- SUBSCRIBER FIGURE, ALSO THE TERRITORIES ON FID_SCHEDULE_MUX2                 */
      /*-------------------------------------------------------------------------------*/
      IF C_UPD_YN = 'Y'
      THEN
         PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                          'FIDSCH06',
                                          C_YEAR || LPAD (C_MONTH, 2, 0),
                                          'UPDATING SUBS');
         DBMS_OUTPUT.PUT_LINE ('UPDATING SUBS');
         DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
      END IF;

      /*-------------------------------------------------------------------------------*/
      /*- PROCEDURE DEFINITION - UPDATE-SUBSCRIBERS-BY-CHANNEL                         */
      /*- THIS PROCEDURE PURELY ALLOWS US TO UPDATE THE SUBSCRIBER NUMBERS IN          */
      /*- FID_SCHEDULE_MUX1 BY CHANNEL, AS OPPOSED TO DOING THE LOT IN ONE CHUNK       */
      /*- THIS BASICALLY ASSISTS US FROM A PERFORMANCE POINT OF VIEW                   */
      /*-------------------------------------------------------------------------------*/
      FOR SCHED_MUX1 IN GET_CHA_LIC
      LOOP
         /*-------------------------------------------------------------------------------*/
         /*- FOR EACH DISTINCT CHANNEL/LICENSE RETURNED, UPDATE BOTH FID_SCHEDULE_MUX1    */
         /*- AND FID_SCHEDULE_MUX2 WITH THEIR RESPECTIVE SUBSCRIBER FIGURES.              */
         /*-------------------------------------------------------------------------------*/
         IF SCHED_MUX1.SX1_SCH_CHA_NUMBER !=
               TO_NUMBER (NVL (TO_CHAR (C_OLD_CHANNEL), '0'))
         THEN
            /*-------------------------------------------------------------------------------*/
            /*- PROCEDURE DEFINITION - UPDATE-SUBSCRIBERS-MUX1                               */
            /*- THIS PROCEDURE UPDATES FID_SCHEDULE_MUX1 WITH THE NUMBER OF SUBSCRIBERS      */
            /*- AVAILABLE PER SCHEDULE CHANNEL WHERE THE SUBS EXIST FOR THIS CHANNEL         */
            /*-------------------------------------------------------------------------------*/
            BEGIN
               UPDATE FID_SCHEDULE_MUX1
                  SET SX1_SUBS_THIS_SHOWING =
                         (SELECT NVL (SUM (A.SUB_ACTUAL), 0)
                            FROM FID_CHANNEL_SUBSCRIBER A
                           WHERE A.SUB_CHA_NUMBER = SX1_SCH_CHA_NUMBER
                                 AND TO_NUMBER (
                                        A.SUB_PER_YEAR
                                        || LPAD (TO_CHAR (A.SUB_PER_MONTH),
                                                 2,
                                                 '0')) =
                                        (SELECT MAX (
                                                   TO_NUMBER (
                                                      B.SUB_PER_YEAR
                                                      || LPAD (
                                                            TO_CHAR (
                                                               B.SUB_PER_MONTH),
                                                            2,
                                                            '0')))
                                           FROM FID_CHANNEL_SUBSCRIBER B
                                          WHERE B.SUB_CHA_NUMBER =
                                                   A.SUB_CHA_NUMBER
                                                AND B.SUB_PER_YEAR <= C_YEAR
                                                AND B.SUB_PER_MONTH <=
                                                       C_MONTH))
                WHERE SX1_SCH_CHA_NUMBER = SCHED_MUX1.SX1_SCH_CHA_NUMBER;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            BEGIN
               UPDATE FID_SCHEDULE_MUX1
                  SET SX1_SUBS_THIS_SHOWING =
                         (SELECT NVL (SUM (A.SUB_ACTUAL), 0)
                            FROM FID_CHANNEL_SUBSCRIBER A
                           WHERE A.SUB_CHA_NUMBER != SX1_SCH_CHA_NUMBER
                                 AND A.SUB_CHA_NUMBER =
                                        (SELECT CSC_SUBS_CHA_NUMBER
                                           FROM FID_CHANNEL_SERVICE_CHANNEL
                                          WHERE CSC_CHA_NUMBER =
                                                   SX1_SCH_CHA_NUMBER
                                                AND ROWNUM < 2)
                                 AND TO_NUMBER (
                                        A.SUB_PER_YEAR
                                        || LPAD (TO_CHAR (A.SUB_PER_MONTH),
                                                 2,
                                                 '0')) =
                                        (SELECT MAX (
                                                   TO_NUMBER (
                                                      B.SUB_PER_YEAR
                                                      || LPAD (
                                                            TO_CHAR (
                                                               B.SUB_PER_MONTH),
                                                            2,
                                                            '0')))
                                           FROM FID_CHANNEL_SUBSCRIBER B
                                          WHERE B.SUB_CHA_NUMBER =
                                                   A.SUB_CHA_NUMBER
                                                AND B.SUB_PER_YEAR <= C_YEAR
                                                AND B.SUB_PER_MONTH <=
                                                       C_MONTH))
                WHERE SX1_SUBS_THIS_SHOWING = 0
                      AND SX1_SCH_CHA_NUMBER = SCHED_MUX1.SX1_SCH_CHA_NUMBER;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            PKG_PB_FID_SCHEDVER_PK.UPD_SUBS_BY_TER_MUX2 (
               C_YEAR,
               C_MONTH,
               SCHED_MUX1.SX1_SCH_CHA_NUMBER);
         END IF;

         /*-------------------------------------------------------------------------------*/
         /*- UPDATE THE TERRITORIES ON FID_SCHEDULE_MUX2                                  */
         /*- PROCEDURE DEFINITION - UPDATE-TERRITORIES-MUX2                               */
         /*- THIS PROCEDURE LOOKS AT FID_SCHEDULE_MUX2, FID_CHANNEL_SERVICE AND           */
         /*- FID_CHANNEL_SERVICE_CHANNEL AND WORKS OUT WHICH CHANNELS HAVE THEIR          */
         /*- CSC_INCLUDE_SUBS FLAG SET.  IT THEN UPDATES FID_SCHEDULE_MUX2.SX2_TER_CODE   */
         /*- BY ADDING THE CHA_SHORT_NAME TO THE FRONT OF IT E.G. 'SWE' BECOMES 'CSWE'    */
         /*-------------------------------------------------------------------------------*/
         BEGIN
            UPDATE FID_SCHEDULE_MUX4
               SET SX4_TER_CODE =
                      (SELECT CHA_SHORT_NAME || SX4_TER_CODE
                         FROM FID_CHANNEL, FID_CHANNEL_SERVICE
                        WHERE CHS_CHA_NUMBER = SX4_CHA_NUMBER
                              AND ( (CHS_NUMBER =
                                        SCHED_MUX1.SX1_LIC_CHS_NUMBER)
                                   OR (CHS_CHA_NUMBER =
                                          SCHED_MUX1.SX1_LIC_CHS_NUMBER))
                              AND CHA_NUMBER = CHS_CHA_NUMBER
                              AND ROWNUM < 2
                       UNION
                       SELECT CHA_SHORT_NAME || SX4_TER_CODE
                         FROM FID_CHANNEL, FID_CHANNEL_SERVICE_CHANNEL
                        WHERE CSC_CHA_NUMBER = SX4_CHA_NUMBER
                              AND ( (CSC_CHS_NUMBER =
                                        SCHED_MUX1.SX1_LIC_CHS_NUMBER)
                                   OR (CSC_CHA_NUMBER =
                                          SCHED_MUX1.SX1_LIC_CHS_NUMBER))
                              AND CHA_NUMBER = CSC_SUBS_CHA_NUMBER
                              AND ROWNUM < 2
                       UNION
                       SELECT CHA_SHORT_NAME || SX4_TER_CODE
                         FROM FID_CHANNEL
                        WHERE     CHA_NUMBER = SX4_CHA_NUMBER
                              AND NOT EXISTS
                                     (SELECT NULL
                                        FROM FID_CHANNEL_SERVICE
                                       WHERE CHS_CHA_NUMBER = SX4_CHA_NUMBER)
                              AND NOT EXISTS
                                     (SELECT NULL
                                        FROM FID_CHANNEL_SERVICE_CHANNEL
                                       WHERE CSC_CHA_NUMBER = SX4_CHA_NUMBER))
             WHERE SX4_CHA_NUMBER = SCHED_MUX1.SX1_SCH_CHA_NUMBER
                   AND EXISTS
                          (SELECT NULL
                             FROM FID_SCHEDULE_MUX3
                            WHERE SX3_LIC_NUMBER = SCHED_MUX1.SX1_LIC_NUMBER
                                  AND SX3_CHA_NUMBER = SX4_CHA_NUMBER)
                   AND EXISTS
                          (SELECT NULL
                             FROM FID_TERRITORY
                            WHERE TER_CODE = SX4_TER_CODE);

            COMMIT;
            SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN OTHERS
            THEN
               --DBMS_OUTPUT.PUT_LINE (
               --    'ERROR'
               -- || SCHED_MUX1.SX1_SCH_CHA_NUMBER
               --|| ' '
               --|| SCHED_MUX1.SX1_LIC_NUMBER);
               NULL;
         END;

         /*-------------------------------------------------------------------------------*/
         /*   RESET #OLD_CHANNEL VARIABLE                                                 */
         /*-------------------------------------------------------------------------------*/
         C_OLD_CHANNEL := SCHED_MUX1.SX1_SCH_CHA_NUMBER;
      END LOOP;

      /*-------------------------------------------------------------------------------*/
      /*- DO THE MAIN PROCEDURE ENSURING FIRST THAT AUDITING ON FID_SCHEDULE IS        */
      /*- TURNED OFF                                                                   */
      /*-------------------------------------------------------------------------------*/
      /*- PROCEDURE DEFINITION - UPDATE-FID-SCHEDULE-LOCK                              */
      /*- THIS PROCEDURE SETS THE VERIFICATION AND AUDIT FLAG ON THE FID_SCHEDULE_LOCK */
      /*- TABLE                                                                        */
      /*-------------------------------------------------------------------------------*/
      IF UPD_YN = 'Y'
      THEN
         UPDATE FID_SCHEDULE_LOCK
            SET SCL_VERIFICATION = 'N',
                SCL_VERIFICATION_DATE = SYSDATE,
                SCL_VERIFICATION_WHO = I_USER_ID,
                SCL_AUDIT = 'N'
          WHERE SCL_PER_YEAR = C_YEAR AND SCL_PER_MONTH = C_MONTH;
      END IF;

      /*-------------------------------------------------------------------------------*/
      /*- FIND THE APPROPRIATE SCH_TYPE AND UPDATE FID_SCHEDULE_MUX1 WHERE NECESSARY   */
      /*-------------------------------------------------------------------------------*/
      PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                       'FIDSCH06',
                                       C_YEAR || LPAD (C_MONTH, 2, 0),
                                       'FIND SCH TYPE');
      DBMS_OUTPUT.PUT_LINE ('FIND SCH TYPE');
      DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
	  /*Jawahar- It will update the sch_type as P or N based on lic_showing_lic i.ie costed runs */
      PKG_PB_FID_SCHEDVER_PK.REPORT_FIND_SCH_TYPE (C_MONTH,
                                                   C_YEAR,
                                                   C_VERIFICATION_1);
      COMMIT;
      SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
      PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                       'FIDSCH06',
                                       C_YEAR || LPAD (C_MONTH, 2, 0),
                                       'REPORT SCHEDULE');
      DBMS_OUTPUT.PUT_LINE ('REPORT SCHEDULE');
      DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
      PKG_PB_FID_SCHEDVER_PK.REPORT_SCHEDULE (C_YEAR,
                                              C_MONTH,
                                              C_PREVIOUS_YEAR,
                                              C_PREVIOUS_MONTH,
                                              C_UPD_YN,
                                              I_USER_ID,
                                              --PURE FINANCE[ADDED NEW  PARAM FOR  AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                                              I_SPLIT_REGION,
                                              C_VERIFICATION_2);
      COMMIT;
      SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
      /*-------------------------------------------------------------------------------*/
      /*- WORK OUT IF ANY LICENSES HAVE BEEN SHOWN MORE TIMES THAN ALLOWED, IF THEY    */
      /*- HAVE, PUT OUT A COMMENT. N.B. THE RETURN VALUE IS IRRELEVANT IN THIS CALL    */
      /*- BUT IS REQUIRED WHEN IT'S CALLED ELSEWHERE.                                  */
      /*-------------------------------------------------------------------------------*/
      PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                       'FIDSCH06',
                                       C_YEAR || LPAD (C_MONTH, 2, 0),
                                       'INT2');
      DBMS_OUTPUT.PUT_LINE ('INT2');
      DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
      PKG_PB_FID_SCHEDVER_PK.REPORT_COUNT_PAID_INT2 (C_YEAR,
                                                     C_MONTH,
                                                     UPD_YN,
                                                     C_VERIFICATION_3);
      COMMIT;
      SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
      PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                       'FIDSCH06',
                                       C_YEAR || LPAD (C_MONTH, 2, 0),
                                       'PRIMETIME');
      DBMS_OUTPUT.PUT_LINE ('PRIMETIME');
      DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
      PKG_PB_FID_SCHEDVER_PK.REPORT_PRIMETIME_EXC (C_YEAR,
                                                   C_MONTH,
                                                   UPD_YN,
                                                   C_VERIFICATION_3);

      --16Apr2015 : Issue : Jawahar : Schedule is not validating on lic_end date after midnight schedule.
      /*-------------------------------------------------------------------------------*/
      /* This SP is used to validate schedule fin actual date is between lic start
      /* and lic end. if not then insert a warning into warning table
      /*-------------------------------------------------------------------------------*/
      FID_SCHEDVER_PK.X_Prc_Ver_Lic_Sch_Date (
                                                c_year,
                                                C_MONTH
                                               );


      /*-------------------------------------------------------------------------------*/
      /*- UPDATE FID_SCHEDULE_LOCK DEPENDING ON THE CONTENTS OF $VERIFICATION          */
      /*-------------------------------------------------------------------------------*/
      IF    NVL (C_VERIFICATION_1, 'Y') = 'N'
         OR NVL (C_VERIFICATION_2, 'Y') = 'N'
         OR NVL (C_VERIFICATION_3, 'Y') = 'N'
      THEN
         C_VERIFY := 'N';
      ELSE
         C_VERIFY := 'Y';
      END IF;

      /*-------------------------------------------------------------------------------*/
      /*- PROCEDURE DEFINITION - UPDATE-FID-SCHEDULE-LOCK                              */
      /*- THIS PROCEDURE SETS THE VERIFICATION AND AUDIT FLAG ON THE FID_SCHEDULE_LOCK */
      /*- TABLE                                                                        */
      /*-------------------------------------------------------------------------------*/
    /*
      IF UPD_YN = 'Y'
      THEN
         UPDATE FID_SCHEDULE_LOCK
            SET SCL_VERIFICATION = C_VERIFY,
                SCL_VERIFICATION_DATE = SYSDATE,
                SCL_VERIFICATION_WHO = I_USER_ID,
                SCL_AUDIT = 'Y',
                SCL_LOCK_STATUS = 'U',
                SCL_LOCK_DATE = SYSDATE,
                SCL_LOCK_WHO = I_USER_ID
          WHERE SCL_PER_YEAR = C_YEAR AND SCL_PER_MONTH = C_MONTH;

         UPDATE FID_SCHEDULE_LOCK
            SET SCL_VERIFICATION = 'N',
                SCL_VERIFICATION_DATE = SYSDATE,
                SCL_VERIFICATION_WHO = I_USER_ID,
                SCL_LOCK_STATUS = 'U',
                SCL_LOCK_DATE = SYSDATE,
                SCL_LOCK_WHO = I_USER_ID
          WHERE ( (SCL_PER_YEAR * 12) + SCL_PER_MONTH) >
                   ( (C_YEAR * 12) + C_MONTH);
      END IF;
   */
      COMMIT;
      SET TRANSACTION USE ROLLBACK SEGMENT RS_BATCH;
      /*-------------------------------------------------------------------------------*/
      /*- DELETE THE CONTENTS OF THE TABLES FID_SCHEDULE_MUX1 AND FID_SCHEDULE_MUX2    */
      /*-------------------------------------------------------------------------------*/
      PKG_PB_FID_SCHEDVER_PK.RUN_RSLT (2,
                                       'FIDSCH06',
                                       C_YEAR || LPAD (C_MONTH, 2, 0),
                                       'DELETING TEMPORARY TABLES');
      DBMS_OUTPUT.PUT_LINE ('DELETING TEMP TABLES');
      DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
      /*-------------------------------------------------------------------------------*/
      /*- DELETE THE TEMPORARY TABLES                                                  */
      /*-------------------------------------------------------------------------------*/
      /*!!!!!!!!!!!!!!!!!!!PUT BACK AFTER TESTING***/
      -- TRUNCATE WORK TABLES
      --  DDL_CURSOR := DBMS_SQL.OPEN_CURSOR;
      --  DBMS_SQL.PARSE(DDL_CURSOR,'TRUNCATE TABLE FID_SCHEDULE_MUX1',DBMS_SQL.V7);
      --  DBMS_SQL.PARSE(DDL_CURSOR,'TRUNCATE TABLE FID_SCHEDULE_MUX3',DBMS_SQL.V7);
      --  DBMS_SQL.PARSE(DDL_CURSOR,'TRUNCATE TABLE FID_SCHEDULE_MUX4',DBMS_SQL.V7);
      --  DDL_RETURN := DBMS_SQL.EXECUTE(DDL_CURSOR);
      --  DBMS_SQL.CLOSE_CURSOR(DDL_CURSOR);
      COMMIT;

      IF UPD_YN = 'Y'
      THEN
         DBMS_OUTPUT.PUT_LINE ('SUCCESSFULLY FINISHED');
      ELSE
         DBMS_OUTPUT.PUT_LINE ('WARNINGS SUCCESSFULLY FINISHED');
      END IF;

      DBMS_OUTPUT.PUT_LINE (TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

     <<END_OF_REPORT>>
      NULL;
   END;                                              /*PROCEDURE MONTHLY_RUN*/

   PROCEDURE UPD_SUBS_BY_TER_MUX2 (C_YEAR      IN NUMBER,
                                   C_MONTH     IN NUMBER,
                                   C_CHANNEL   IN NUMBER)
   IS
   BEGIN
      /*-------------------------------------------------------------------------------*/
      /*- PROCEDURE DEFINITION - UPDATE_SUBSCRIBERS_BY_TERRITORY_MUX2                  */
      /*- THIS PROCEDURE EXISTS SOLEY TO BREAK OUT AN UPDATE BY TERRITORY, AND HENCE   */
      /*- REDUCE THE PRESSURE ON THE SERVER                                            */
      /*-------------------------------------------------------------------------------*/
      DECLARE
         CURSOR GET_TER
         IS
            SELECT DISTINCT CHT_TER_CODE
              FROM FID_CHANNEL_TERRITORY
             WHERE CHT_CHA_NUMBER = C_CHANNEL;
      BEGIN
         FOR ALL_TER IN GET_TER
         LOOP
            /*-------------------------------------------------------------------------------*/
            /*- FOR EACH TERRITORY RETURNED, UPDATE THE SUBSCRIBER FIGURE ON                 */
            /*- FID_SCHEDULE_MUX2                                                            */
            /*-------------------------------------------------------------------------------*/
            UPDATE FID_SCHEDULE_MUX4
               SET SX4_SUBS =
                      (SELECT NVL (SUM (A.SUB_ACTUAL), 0)
                         FROM FID_CHANNEL_SUBSCRIBER A
                        WHERE A.SUB_CHA_NUMBER = C_CHANNEL
                              AND A.SUB_TER_CODE = ALL_TER.CHT_TER_CODE
                              AND TO_NUMBER (
                                     TO_CHAR (A.SUB_PER_YEAR)
                                     || TO_CHAR (A.SUB_PER_MONTH)) =
                                     (SELECT NVL (
                                                MAX (
                                                   TO_NUMBER (
                                                      TO_CHAR (
                                                         B.SUB_PER_YEAR)
                                                      || TO_CHAR (
                                                            B.SUB_PER_MONTH))),
                                                0)
                                        FROM FID_CHANNEL_SUBSCRIBER B
                                       WHERE     B.SUB_CHA_NUMBER = C_CHANNEL
                                             AND B.SUB_PER_YEAR <= C_YEAR
                                             AND B.SUB_PER_MONTH <= C_MONTH))
             WHERE SX4_CHA_NUMBER = C_CHANNEL
                   AND ( (SX4_TER_CODE = ALL_TER.CHT_TER_CODE)
                        OR (SUBSTR (SX4_TER_CODE, 2, 3) =
                               ALL_TER.CHT_TER_CODE))
                   AND SX4_SUBS = 0;
         END LOOP;
      END;
   END;                   /*-PROCEDURE UPDATE_SUBSCRIBERS_BY_TERRITORY_MUX2 */

   PROCEDURE REPORT_FIND_SCH_TYPE (C_MONTH            IN     NUMBER,
                                   C_YEAR             IN     NUMBER,
                                   C_VERIFICATION_1      OUT VARCHAR2)
   IS
   BEGIN
      /*-------------------------------------------------------------------------------*/
      /*- PROCEDURE DEFINITION - REPORT_FIND_SCH_TYPE                                  */
      /*- THIS PROCEDURE SELECTS EACH FID_SCHEDULE_MUX1 RECORD IN TURN AND WORKS       */
      /*- OUT WHETHER THE SCH_TYPE SHOULD REMAIN AS 'F' (FREE) OR SHOULD BE CHANGED    */
      /*- TO 'P' (PAID)                                                                */
      /*-------------------------------------------------------------------------------*/
      DECLARE
         V_LIC_NUMBER             NUMBER := 0;
         V_CHA_NUMBER             NUMBER := 0;
         V_VERIFICATION           VARCHAR2 (1) := ' ';

         CURSOR GET_MUX1
         IS
              SELECT SX1_LIC_NUMBER,
                     SX1_SCH_CHA_NUMBER,
                     SX1_SCH_TYPE,
                     SX1_SCH_DATE_TIME_PLUS_24HRS DATE_PLUS_24HRS,
                     SX1_LIC_CHS_NUMBER,
                     SX1_SCH_NUMBER,
                     SX1_SCH_DATE_TIME,
                     SX1_SCH_TIME,
                     SX1_SUBS_THIS_SHOWING,
                     NVL (SX1_CON_MUX_IND, 'N') CON_MUX_IND,
                     NVL (SX1_CON_ALIGN_IND, 'N') CON_ALIGN_IND,
                     TO_NUMBER (
                        TO_CHAR (SX1_SCH_DATE, 'YYYYMMDD')
                        || NVL (LPAD (TO_CHAR (SX1_CON_EXH_DAY_START), 5, '0'),
                                '99999'))
                        EXH_DAY_START,
                     TO_NUMBER (
                        TO_CHAR (SX1_SCH_DATE + 1, 'YYYYMMDD')
                        || NVL (LPAD (TO_CHAR (SX1_CON_EXH_DAY_START), 5, '0'),
                                99999))
                        EXH_DAY_END
                FROM FID_SCHEDULE_MUX1
               WHERE (SX1_SCH_CHA_NUMBER != 0) --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
                     AND sx1_lic_amort_code NOT IN ('D', 'E', 'F')   --ver 1.1 added 'F'
            --END  AFRICA FREE REPEAT
            ORDER BY SX1_CON_SHORT_NAME,
                     SX1_GEN_TITLE,
                     SX1_LIC_NUMBER,
                     SX1_SCH_DATE,
                     SX1_SCH_SLOT,
                     SX1_SCH_CHA_NUMBER;

         CURSOR GET_LIC_COST
         IS
            SELECT DISTINCT SX1_LIC_NUMBER, SX1_COSTING_RUNS
              FROM fid_schedule_mux1
             --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
             WHERE sx1_lic_amort_code IN ('D', 'E' , 'F' );		   --ver 1.1 added 'F'

         --END  AFRICA FREE REPEAT

         CURSOR GET_SCH
         IS
              SELECT SCH_NUMBER,
                     CHA_SHORT_NAME,
                     SCH_DATE,
                     CONVERT_TIME_N_C (SCH_TIME) SCH_TIME
                FROM FID_SCHEDULE, FID_CHANNEL
               WHERE SCH_LIC_NUMBER = V_LIC_NUMBER
                     AND CHA_NUMBER = SCH_CHA_NUMBER
                     AND SCH_DATE <=
                            LAST_DAY (
                               TO_DATE (
                                     '01'
                                  || LPAD (TO_CHAR (C_MONTH), 2, '0')
                                  || C_YEAR,
                                  'DDMMYYYY'))
                     AND SCH_CHA_NUMBER IN
                            (SELECT LCR_CHA_NUMBER
                               FROM FID_LICENSE_CHANNEL_RUNS
                              WHERE LCR_LIC_NUMBER = V_LIC_NUMBER
                                    AND LCR_COST_IND = 'Y')
            ORDER BY SCH_DATE, SCH_TIME;

         V_PERIOD                 NUMBER (6) := CONCAT (C_YEAR, LPAD (C_MONTH, 2, 0));
         V_COMMENTS               VARCHAR2 (150);
         C_PAID_DATE_PLUS_24HRS   NUMBER := 0;
         C_LAST_PAID_DATE_TIME    NUMBER := 0;
         C_ALIGNMENT_DATE_TIME    NUMBER := 0;
         C_NEW_EXHIBITION         VARCHAR2 (1) := ' ';
         C_RETURN_VALUE1          VARCHAR2 (1) := ' ';
         C_RETURN_VALUE2          NUMBER := 0;
         C_OLD_SX1_LICENSE        NUMBER := 0;
         C_ALIGNED                VARCHAR2 (1) := ' ';
         V_PAID                   NUMBER := 0;
      BEGIN
         /*-------------------------------------------------------------------------------*/
         /*- IF THE SHOWING IS 'F' (FREE) AND WAS IN THE PREVIOUS MONTH THEN JUST         */
         /*- UPDATE THE NUMBER OF SHOWINGS APPROPRIATE AND SKIP ALL OTHER PROCESSING      */
         /*-------------------------------------------------------------------------------*/
         FOR ALL_MUX1 IN GET_MUX1
         LOOP
            /*  ??? CHECK FORMAAT VAN SX1_SCH_DATE_TIME EN VERANDER HIER ONDER !!! */
            IF TO_NUMBER (
                  SUBSTR (TO_CHAR (ALL_MUX1.SX1_SCH_DATE_TIME), 5, 2)) !=
                  C_MONTH
            THEN
               IF C_OLD_SX1_LICENSE != ALL_MUX1.SX1_LIC_NUMBER
               THEN
                  C_PAID_DATE_PLUS_24HRS := 1;
                  C_LAST_PAID_DATE_TIME := 1;
                  C_ALIGNMENT_DATE_TIME := 99999;
               END IF;

               IF ALL_MUX1.SX1_SCH_TYPE = 'F'
               THEN
                  UPDATE FID_SCHEDULE_MUX3
                     SET SX3_COUNT = SX3_COUNT + 1
                   WHERE SX3_LIC_NUMBER = ALL_MUX1.SX1_LIC_NUMBER
                         AND SX3_CHA_NUMBER = ALL_MUX1.SX1_SCH_CHA_NUMBER;

                  GOTO SKIPPED;
               ELSE
                  UPDATE FID_SCHEDULE_MUX3
                     SET SX3_COUNT = 0
                   WHERE SX3_LIC_NUMBER = ALL_MUX1.SX1_LIC_NUMBER;

                  UPDATE FID_SCHEDULE_MUX3
                     SET SX3_COUNT = SX3_COUNT + 1
                   WHERE SX3_LIC_NUMBER = ALL_MUX1.SX1_LIC_NUMBER
                         AND SX3_CHA_NUMBER = ALL_MUX1.SX1_SCH_CHA_NUMBER;

                  C_PAID_DATE_PLUS_24HRS := ALL_MUX1.DATE_PLUS_24HRS;
                  C_LAST_PAID_DATE_TIME := ALL_MUX1.SX1_SCH_DATE_TIME;

                  /*-------------------------------------------------------------------------------*/
                  /*-     IF ALIGNMENT IS ALLOWED RESET THE #ALIGNMENT_DATE_TIME VARIABLE TO       */
                  /*-     THE SX1_SCH_TIME OF THE CURRENT SHOWING                                  */
                  /*-------------------------------------------------------------------------------*/
                  IF ALL_MUX1.CON_ALIGN_IND = 'Y'
                  THEN
                     C_ALIGNMENT_DATE_TIME := ALL_MUX1.SX1_SCH_DATE_TIME;
                  END IF;

                  GOTO SKIPPED;
               END IF;
            END IF;

            /*-------------------------------------------------------------------------------*/
            /*-      RESET VARIABLES FOR USE                                                 */
            /*-------------------------------------------------------------------------------*/
            C_RETURN_VALUE1 := 'N';
            C_RETURN_VALUE2 := 0;
            C_NEW_EXHIBITION := 'N';

            /*-------------------------------------------------------------------------------*/
            /*-      UPDATE THE NUMBER OF SHOWINGS (SX2_COUNT) TO SX2_COUNT + 1              */
            /*-------------------------------------------------------------------------------*/
            UPDATE FID_SCHEDULE_MUX3
               SET SX3_COUNT = SX3_COUNT + 1
             WHERE SX3_LIC_NUMBER = ALL_MUX1.SX1_LIC_NUMBER
                   AND SX3_CHA_NUMBER = ALL_MUX1.SX1_SCH_CHA_NUMBER;

            /*-------------------------------------------------------------------------------*/
            /*-      IF IT'S PROCESSING THE NEXT NEW LICENSE NUMBER SET $NEW_EXHIBITION FLAG */
            /*-      I.E. "THIS IS A NEW EXHIBITION" FLAG = 'Y'.                             */
            /*-------------------------------------------------------------------------------*/
            IF C_OLD_SX1_LICENSE != ALL_MUX1.SX1_LIC_NUMBER
            THEN
               C_PAID_DATE_PLUS_24HRS := 1;
               C_LAST_PAID_DATE_TIME := 1;
               C_NEW_EXHIBITION := 'Y';
            ELSE
                 /*-------------------------------------------------------------------------------*/
                 /*- PROCEDURE DEFINITION - SELECT-TERR-SHOWINGS                                  */
                 /*- THIS PROCEDURE SELECTS RECORDS FROM FID_SCHEDULE_MUX2 WHERE MORE THAN        */
                 /*- 2 SHOWINGS PER TERRITORY PER EXHIBITION OCCURS                               */
                 /*-------------------------------------------------------------------------------*/
                 SELECT MAX (SUM (SX3_COUNT))
                   INTO C_RETURN_VALUE2
                   FROM FID_SCHEDULE_MUX4, FID_SCHEDULE_MUX3
                  WHERE SX4_CHA_NUMBER = SX3_CHA_NUMBER
                        AND SX3_LIC_NUMBER = ALL_MUX1.SX1_LIC_NUMBER
               GROUP BY SX4_TER_CODE;

               /*-------------------------------------------------------------------------------*/
               /*-        HAVING FOUND THE MAXIMUM NUMBER OF TIMES THE EXHIBITION HAS BEEN      */
               /*-        SHOWN IN ANY GIVEN TERRITORY, LOOK AT THE INDICATOR WHICH TELLS US    */
               /*-        WHETHER MULTIPLEXING OR ALIGNMENT ARE PERMITTED FOR THIS CONTRACT     */
               /*-        IF NEITHER ARE PERMITTED THEN EACH SHOWING MUST BE PAID.              */
               /*-------------------------------------------------------------------------------*/
               IF ALL_MUX1.CON_MUX_IND = 'N' AND ALL_MUX1.CON_ALIGN_IND = 'N'
               THEN
                  C_NEW_EXHIBITION := 'Y';
               ELSE
                  /*-------------------------------------------------------------------------------*/
                  /*-     IF MULTIPLEXING ISN'T PERMITTED, BUT ALIGNMENT IS AND ANY GIVEN          */
                  /*-     TERRITORY HAS SEEN THE EXHIBITION MORE THAN ONCE, THEN THIS              */
                  /*-     SHOWING MUST BE PAID.                                                    */
                  /*-------------------------------------------------------------------------------*/
                  IF     ALL_MUX1.CON_ALIGN_IND = 'Y'
                     AND ALL_MUX1.CON_MUX_IND = 'N'
                     AND C_RETURN_VALUE2 > 1
                  THEN
                     C_NEW_EXHIBITION := 'Y';
                  ELSE
                     /*-------------------------------------------------------------------------------*/
                     /*-       IF ALIGNMENT IS ALLOWED AND MULTIPLEXING ISN'T, BUT IT'S               */
                     /*-       OVER 1 HOUR SINCE THE LAST #ALIGNMENT_DATE_TIME THEN                   */
                     /*-       IT IS THE NEXT PAID SHOWING I.E. THE START OF A NEW                    */
                     /*-       EXHIBITION                                                             */
                     /*-------------------------------------------------------------------------------*/
                     IF ALL_MUX1.CON_ALIGN_IND = 'Y'
                        AND ALL_MUX1.CON_MUX_IND = 'N'
                     THEN
                        IF (ALL_MUX1.SX1_SCH_DATE_TIME
                            - C_ALIGNMENT_DATE_TIME >= 5400)
                        THEN
                           C_ALIGNED := 'N';
                           C_NEW_EXHIBITION := 'Y';
                        ELSE
                           C_ALIGNED := 'Y';
                        END IF;
                     ELSE
                        /*-------------------------------------------------------------------------------*/
                        /*-         IF BOTH ALIGNMENT AND MULTIPLEXING ARE PERMITTED, FIND OUT IF        */
                        /*-         THIS SHOWING IS ALIGNED OR NOT                                       */
                        /*-------------------------------------------------------------------------------*/
                        IF ALL_MUX1.CON_ALIGN_IND = 'Y'
                           AND ALL_MUX1.CON_MUX_IND = 'Y'
                        THEN
                           IF (ALL_MUX1.SX1_SCH_DATE_TIME
                               - C_ALIGNMENT_DATE_TIME >= 5400)
                           THEN
                              C_ALIGNED := 'N';
                           ELSE
                              C_ALIGNED := 'Y';
                           END IF;
                        END IF;

                        /*-------------------------------------------------------------------------------*/
                        /*-         FIND OUT IF THIS EXHIBITION HAS BEEN SHOWN IN ANY GIVEN              */
                        /*-         TERRITORY OF THE LICENSE MORE THAN TWICE, IF SO SET                  */
                        /*-         $NEW_EXHIBITION = 'Y'. OTHERWISE, CARRY ON.                          */
                        /*-------------------------------------------------------------------------------*/
                        IF C_RETURN_VALUE2 > 2
                        THEN
                           C_NEW_EXHIBITION := 'Y';
                        ELSE
                           /*-------------------------------------------------------------------------------*/
                           /*-           IF THE SX1_SCH_DATE_TIME IS GREATER THAN OR EQUAL TO               */
                           /*-           THE EXISTING #PAID_DATE_PLUS_24HRS VARIABLE THEN SET               */
                           /*-           $NEW_EXHIBITION FLAG = 'Y'                                         */
                           /*-------------------------------------------------------------------------------*/
                           IF C_PAID_DATE_PLUS_24HRS <=
                                 ALL_MUX1.SX1_SCH_DATE_TIME
                           THEN
                              C_NEW_EXHIBITION := 'Y';
                           ELSE
                              /*-------------------------------------------------------------------------------*/
                              /*-        IF THE START OF THE EXHIBITION DAY HAS BEEN DEFINED                */
                              /*-        IN THE FID_CONTRACT TABLE AND THE LAST PAID EXHIBITION WAS         */
                              /*-        PRIOR TO THE START OF THE EXHIBITION DAY, THEN THIS                */
                              /*-        SHOWING MUST BE PAID.           ?????????                          */
                              /*-------------------------------------------------------------------------------*/
                              IF ( (SUBSTR (TO_CHAR (ALL_MUX1.EXH_DAY_START),
                                            9,
                                            5) != '99999')
                                  AND (C_LAST_PAID_DATE_TIME <
                                          ALL_MUX1.EXH_DAY_START)
                                  AND (ALL_MUX1.SX1_SCH_DATE_TIME >
                                          ALL_MUX1.EXH_DAY_START))
                              THEN
                                 C_NEW_EXHIBITION := 'Y';
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;

            /*-------------------------------------------------------------------------------*/
            /*- IF THE $NEW_EXHIBITION FLAG = 'Y' THEN PERFORM THE UPDATES ETC.              */
            /*-------------------------------------------------------------------------------*/
            IF C_NEW_EXHIBITION = 'Y'
            THEN
               UPDATE FID_SCHEDULE_MUX3
                  SET SX3_COUNT = 0
                WHERE SX3_LIC_NUMBER = ALL_MUX1.SX1_LIC_NUMBER;

               UPDATE FID_SCHEDULE_MUX1
                  SET SX1_SCH_TYPE = 'P'
                WHERE SX1_SCH_NUMBER = ALL_MUX1.SX1_SCH_NUMBER;

               UPDATE FID_SCHEDULE_MUX3
                  SET SX3_COUNT = SX3_COUNT + 1
                WHERE SX3_LIC_NUMBER = ALL_MUX1.SX1_LIC_NUMBER
                      AND SX3_CHA_NUMBER = ALL_MUX1.SX1_SCH_CHA_NUMBER;

               C_PAID_DATE_PLUS_24HRS := ALL_MUX1.DATE_PLUS_24HRS;
               C_LAST_PAID_DATE_TIME := ALL_MUX1.SX1_SCH_DATE_TIME;

               /*-------------------------------------------------------------------------------*/
               /*-    IF ALIGNMENT IS ALLOWED RESET THE #ALIGNMENT_DATE_TIME VARIABLE TO        */
               /*-    THE SX1_SCH_TIME OF THE CURRENT SHOWING       ??                            */
               /*-------------------------------------------------------------------------------*/
               IF ALL_MUX1.CON_ALIGN_IND = 'Y'
               THEN
                  C_ALIGNMENT_DATE_TIME := ALL_MUX1.SX1_SCH_DATE_TIME;
               ELSE
                  C_ALIGNMENT_DATE_TIME := 99999;
               END IF;
            END IF;

           /*-------------------------------------------------------------------------------*/
           /*-      FINALLY RESET #OLD_SX1_LICENSE = SX1_LIC_NUMBER                        */
           /*-------------------------------------------------------------------------------*/
           <<SKIPPED>>
            C_OLD_SX1_LICENSE := ALL_MUX1.SX1_LIC_NUMBER;
         END LOOP;

         /*-------------------------------------------------------------------------------*/
         /*- CHECK THE NUMBER OF RUNS PER LICENSE WITH TYPE 'D' AND MARK RUNS AS   'PAID' */
         /*- FOR NUMBER OF COST RUNS AND ALL THE REST AS 'NOT PAID'.  PER CHANNEL.        */
         /*-------------------------------------------------------------------------------*/
         UPDATE FID_SCHEDULE_MUX1
            SET sx1_sch_type = 'P'
          --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
          WHERE sx1_lic_amort_code IN ('D', 'E' , 'F')    --ver 1.1 added 'F'
                --END  AFRICA FREE REPEAT
                AND SX1_SCH_DATE BETWEEN TO_DATE (
                                            '01'
                                            || LPAD (TO_CHAR (C_MONTH),
                                                     2,
                                                     '0')
                                            || C_YEAR,
                                            'DDMMYYYY')
                                     AND LAST_DAY (
                                            TO_DATE (
                                               '01'
                                               || LPAD (TO_CHAR (C_MONTH),
                                                        2,
                                                        '0')
                                               || C_YEAR,
                                               'DDMMYYYY'));

         UPDATE FID_SCHEDULE_MUX1
            SET SX1_SCH_TYPE = 'N'
          --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
          WHERE sx1_lic_amort_code IN ('D', 'E', 'F')     --END  AFRICA FREE REPEAT                 --ver 1.1 added 'F'
                                                AND SX1_COST_IND = 'N'
                AND SX1_SCH_DATE BETWEEN TO_DATE (
                                            '01'
                                            || LPAD (TO_CHAR (C_MONTH),
                                                     2,
                                                     '0')
                                            || C_YEAR,
                                            'DDMMYYYY')
                                     AND LAST_DAY (
                                            TO_DATE (
                                               '01'
                                               || LPAD (TO_CHAR (C_MONTH),
                                                        2,
                                                        '0')
                                               || C_YEAR,
                                               'DDMMYYYY'));

         FOR LIC_COST IN GET_LIC_COST
         LOOP
            V_LIC_NUMBER := LIC_COST.SX1_LIC_NUMBER;
            V_PAID := 0;

            FOR ALL_SCH IN GET_SCH
            LOOP
               V_PAID := V_PAID + 1;

               IF V_PAID > NVL (LIC_COST.SX1_COSTING_RUNS, 0)
               THEN
                  IF ALL_SCH.SCH_DATE BETWEEN TO_DATE (
                                                 '01'
                                                 || LPAD (TO_CHAR (C_MONTH),
                                                          2,
                                                          '0')
                                                 || C_YEAR,
                                                 'DDMMYYYY')
                                          AND LAST_DAY (
                                                 TO_DATE (
                                                    '01'
                                                    || LPAD (
                                                          TO_CHAR (C_MONTH),
                                                          2,
                                                          '0')
                                                    || C_YEAR,
                                                    'DDMMYYYY'))
                  THEN
                     UPDATE FID_SCHEDULE_MUX1
                        SET SX1_SCH_TYPE = 'N'
                      WHERE SX1_SCH_NUMBER = ALL_SCH.SCH_NUMBER;
                  END IF;
               END IF;
            END LOOP;
         END LOOP;
      END;
   END;                                              /*REPORT_FIND_SCH_TYPE */

   PROCEDURE REPORT_SCHEDULE (C_CURR_YEAR        IN     NUMBER,
                              C_CURR_MONTH       IN     NUMBER,
                              C_PREVIOUS_YEAR    IN     NUMBER,
                              C_PREVIOUS_MONTH   IN     NUMBER,
                              C_UPD_YN           IN     VARCHAR2,
                              I_USER_ID          IN     VARCHAR2,
                              --PURE FINANCE[BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                              I_SPLIT_REGION     IN     VARCHAR2,
                              --PURE FINANCE END
                              C_VERIFICATION_2      OUT VARCHAR2)
   IS
      /*-------------------------------------------------------------------------------*/
      /*- DECLARATION DONE FOR PROJECT BIOSCOPE IMPLEMENTATION - DECLARATION STARTS    */
      /*-------------------------------------------------------------------------------*/
      FIRST_SCHEDULING_WINDOW        NUMBER;
      COSTED_CHANNEL                 NUMBER;
      SCH_WND_START_DATE             DATE;
      SCH_WND_END_DATE               DATE;
      REMAINING_PAID_RUNS            NUMBER;
      EARLIER_PAID_RUNS_ON_SCH_WND   NUMBER;
      TOTAL_PAID_RUNS_ON_SCH_WND     NUMBER;
      PAID_RUNS_ON_THE_DAY           NUMBER;
      L_PAID_COUNT_ON_LIC_LEVEL      NUMBER;
      L_LIC_SHOWING_LIC              NUMBER;
      FIN_GO_LIVE                    DATE;
      C_NO_COST_PREV_MNT_SUB_LED     NUMBER;
      C_NO_OF_PAID_SCHEDULES         NUMBER;
      C_IS_BIOSCOPE_LEE              NUMBER;
      C_NO_OF_COSTED_IND             NUMBER;
      C_NO_OF_COSTED_PREV_IND        NUMBER;

      CURSOR SCH_C
      IS
           SELECT SCH_NUMBER,
                  SCH_LIC_NUMBER,
                  SCH_DATE,
                  SCH_TIME,
                  SCH_CHA_NUMBER
             FROM FID_SCHEDULE,
                  FID_LICENSE,
                  --PURE FINANCE[BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-25]
                  FID_LICENSEE,
                  FID_REGION
            --PURE FINANCE END
            WHERE     SCH_LIC_NUMBER = LIC_NUMBER
                  AND LIC_STATUS <> 'T'                               -- Added
                  AND LIC_LEE_NUMBER IN (SELECT LEE_NUMBER
                                           FROM FID_LICENSEE
                                          WHERE NVL (UPPER (LEE_BIOSCOPE_FLAG),
                                                     'N') = 'Y')
                  AND UPPER (LIC_AMORT_CODE) = 'D'
                  --REPLACED GEN_TYPE TO LIC_BUDGET_CODE BY MANGESH_GULHANE[[2013-02-26]]
                  AND UPPER (LIC_BUDGET_CODE) IN
                         (SELECT UPPER (CPT_GEN_TYPE)
                            FROM SGY_PB_COSTED_PROG_TYPE)
                  --PURE FINANCE[BIOSCOPE/NON BIOSCOPE AND AFR-RSA SPLIT CHANGES][MANGESH_GULHANE][2013-02-26]
                  AND LIC_LEE_NUMBER = LEE_NUMBER
                  AND LEE_SPLIT_REGION = REG_ID(+)
                  --PURE FINANCE END
                  AND TO_CHAR (SCH_DATE, 'YYYY') = C_CURR_YEAR
                  AND TO_CHAR (SCH_DATE, 'MM') = LPAD (C_CURR_MONTH, 2, 0)
                  AND SCH_DATE >= TO_DATE ('01-SEP-2012', 'DD-MON-YYYY')
                  --PURE FINANCE:[FOR BIOSCOPE AND NCF deal CHANGES][MANGESH GULHANE][2013-02-25]
                  AND UPPER (LIC_STATUS) <> 'F'
                  --PURE FINANCE END
                  --PICK LIC BEFORE GO-LIVE DATE ADDED BY MANGESH_GULHANE[2013-02-26]
                  AND LIC_START < (SELECT TO_DATE (CONTENT, 'DD-MON-YYYY')
                                     FROM X_FIN_CONFIGS
                                    WHERE KEY LIKE 'GO-LIVEDATE')
                  AND UPPER (NVL (REG_CODE, '#')) LIKE
                         UPPER (NVL (I_SPLIT_REGION, '#'))
                  --AND lic_CON_NUMBER = 65070
                  --and LIC_NUMBER = 1108531
         ORDER BY SCH_LIC_NUMBER, SCH_DATE, SCH_TIME;
   /*-------------------------------------------------------------------------------*/
   /*- DECLARATION DONE FOR PROJECT BIOSCOPE IMPLEMENTATION - DECLARATION ENDS      */
   /*-------------------------------------------------------------------------------*/
   BEGIN
      /*-------------------------------------------------------------------------------*/
      /*- PROCEDURE DEFINITION - REPORT_SCHEDULE                                       */
      /*-                                                                              */
      /*- NOTE - IN THE WHERE CLAUSE SCH_DATE IS COMPARED TO THE PERIOD ENTERED        */
      /*-        (MM/YYYY)INCLUDING THE LAST DAY OF THE PREVIOUS MONTH.                */
      /*-------------------------------------------------------------------------------*/
      DECLARE
         C_COMMENTS              VARCHAR2 (100);
         C_RETURN_VALUE3         VARCHAR2 (3);
         C_OLD_LIC_NUMBER        NUMBER := 0;
         C_TOTAL_SUBSCRIBERS     NUMBER := 0;
         C_MAXIMUM_SUBSCRIBERS   NUMBER := 0;
         C_INTENDED_SHOWINGS     NUMBER := 0;
         C_TOTAL_PRIOR_PAID      NUMBER := 0;
         C_PAID_THIS_MONTH       NUMBER := 0;
         C_NEXT_PAID_DATE        NUMBER := 0;
         C_PREVIOUS_PAID_DATE    NUMBER := 0;
         C_ROWNUM                NUMBER := 0;
         C_TERRITORY             VARCHAR2 (5);
         C_SUBS_PER_TERRITORY    NUMBER;
         V_VERIFICATION          VARCHAR2 (10) := NULL;
         C_LICNO                 NUMBER := 0;

         CURSOR REPSCHED
         IS
              SELECT LPAD (SX1_CON_SHORT_NAME, 12, ' ') CON_SHT,
                     /*(+1,2,12) ON-BREAK SKIPLINES=2 LEVEL=1*/
                     LPAD (SX1_LIC_NUMBER, 6, ' ') LIC_NUMBER,
                     /*(,15,6)   ON-BREAK SKIPLINES=1 LEVEL=1*/
                     SX1_GEN_TITLE GEN_TITLE,
                     /*(,22,40)  ON-BREAK             LEVEL=1*/
                     NVL (CHS_SHORT_NAME, CHA_SHORT_NAME) SER_SHT,
                     /*(,63,4)   ON-BREAK             LEVEL=1*/
                     CHA_SHORT_NAME CHA_SHORT_NAME,
                     TO_CHAR (SX1_SCH_DATE, 'DD/MM/YYYY') SCH_DATE,
                     LTRIM (TO_CHAR (FLOOR (SX1_SCH_TIME / 3600), '09')) || ':'
                     || LTRIM (
                           TO_CHAR (FLOOR (MOD (SX1_SCH_TIME, 3600) / 60),
                                    '09'))
                        SCH_TIME,
                     SX1_SCH_SLOT SCH_SLOT,
                     DECODE (SX1_SCH_TYPE,
                             'P', 'PAID',
                             'F', 'FREE',
                             'N', 'NOTP',
                             'MULT')
                        SCH_TYPE,
                     SX1_LIC_NUMBER LIC_NUMBER_PAR,
                     SX1_LIC_CHS_NUMBER LIC_CHS_NUMBER_PAR,
                     SX1_SCH_CHA_NUMBER SCH_CHA_NUMBER_PAR,
                     TO_NUMBER (TO_CHAR (SX1_SCH_DATE, 'MM')) SCH_MONTH_PAR,
                     SX1_SCH_TIME SCH_TIME_PAR,
                     SX1_SCH_NUMBER SCH_NUMBER_PAR,
                     SX1_SCH_TYPE SCH_TYPE_PAR,
                     SX1_SCH_DATE_TIME_PLUS_24HRS SCH_DATE_TIME_PLUS_ONE,
                     SX1_SCH_DATE_TIME THIS_SHOWING_DATE,
                     SX1_SUBS_THIS_SHOWING THIS_SHOWING_SUBS
                FROM FID_CHANNEL_SERVICE, FID_CHANNEL, FID_SCHEDULE_MUX1
               WHERE CHA_NUMBER = SX1_SCH_CHA_NUMBER
                     AND CHS_NUMBER(+) = SX1_LIC_CHS_NUMBER
            ORDER BY SX1_CON_SHORT_NAME,
                     SX1_GEN_TITLE,
                     SX1_LIC_NUMBER,
                     SX1_SCH_DATE,
                     SX1_SCH_SLOT,
                     SX1_SCH_CHA_NUMBER;

         CURSOR GET_MAX
         IS
            SELECT DISTINCT SX4_TER_CODE, SX4_SUBS
              FROM FID_SCHEDULE_MUX4, FID_SCHEDULE_MUX3
             WHERE SX4_CHA_NUMBER = SX3_CHA_NUMBER
                   AND SX3_LIC_NUMBER = C_LICNO;
      BEGIN
         FOR ALL_RS IN REPSCHED
         LOOP
            /*-------------------------------------------------------------------------------*/
            /*-       PRINT THE OTHER COLUMNS.  WE'RE DOING IT AS A PRINT COMMAND INSTEAD    */
            /*-       OF INCLUDING IT ABOVE BECAUSE FOR 'P' (PAID) SHOWINGS WE WANT IT IN    */
            /*-       BOLD.                                                                  */
            /*-                                                                              */
            /*-                                                                              */
            /*-     THE FOLLOWING LINES WILL BE UNCOMMENTED AND INCLUDED WHEN WE KNOW HOW TO */
            /*-     PRINT 'P' (PAID) SHOWINGS IN POSTSCRIPT BOLD                             */
            /*-                                                                              */
            /*-      IF SCH_TYPE_PAR = 'P'                                                  */
            /*-    PRINT CHA_SHORT_NAME (,68,7) BOLD                                        */
            /*-    PRINT SCH_DATE       (,72,8) BOLD                                        */
            /*-    PRINT SCH_TIME       (,81,5) BOLD                                        */
            /*-    PRINT SCH_SLOT       (,87,4) BOLD                                        */
            /*-    PRINT SCH_TYPE       (,92,4) BOLD                                        */
            /*-    ELSE                                                                      */
            /*-------------------------------------------------------------------------------*/
            /* WRITE THE FOLLOWING TO AN OUTPUT TABLE*/
            /*  PRINT CHA_SHORT_NAME (,68,7)*/
            /*  PRINT SCH_DATE       (,72,8)*/
            /*  PRINT SCH_TIME       (,81,5)*/
            /*  PRINT SCH_SLOT       (,87,4)*/
            /*  PRINT SCH_TYPE       (,92,4)*/
            /*-------------------------------------------------------------------------------*/
            /*-      END-IF                                                                  */
            /*-                                                                              */
            /*-       FIRST, RESET THE VARIOUS VARIABLES TO AVOID CONFUSION                  */
            /*-------------------------------------------------------------------------------*/
            C_RETURN_VALUE3 := NULL;
            C_COMMENTS := NULL;

            /*-------------------------------------------------------------------------------*/
            /*-       FIND THE MAXIMUM NUMBER OF SUBSCRIBERS PERMITTED TO SEE ANY EXHIBITION */
            /*-       OF THIS LICENSE AND THE NUMBER OF 'PAID' EXHIBITIONS UPTO, BUT NOT     */
            /*-       INCLUDING THE CURRENT MONTH, BUT ONLY IF SX1_LIC_NUMBER HAS CHANGED    */
            /*-------------------------------------------------------------------------------*/
            IF ALL_RS.LIC_NUMBER_PAR != C_OLD_LIC_NUMBER
            THEN
               C_MAXIMUM_SUBSCRIBERS := 0;
               C_INTENDED_SHOWINGS := 0;
               C_TOTAL_PRIOR_PAID := 0;
               C_PAID_THIS_MONTH := 0;
               /*-------------------------------------------------------------------------------*/
               /*- PROCEDURE DEFINITION - REPORT-MAXIMUM-SUBSCRIBERS                            */
               /*- THIS PROCEDURE LOOKS AT FID_SCHEDULE_MUX2 AND CALCULATES THE MAXIMUM NUMBER  */
               /*- OF SUBSCRIBERS                                                               */
               /*-------------------------------------------------------------------------------*/
               C_LICNO := ALL_RS.LIC_NUMBER_PAR;

               FOR ALL_SUBS IN GET_MAX
               LOOP
                  C_MAXIMUM_SUBSCRIBERS :=
                     C_MAXIMUM_SUBSCRIBERS + ALL_SUBS.SX4_SUBS;
               END LOOP;

               /*-------------------------------------------------------------------------------*/
               /*- PROCEDURE DEFINITION - REPORT-COUNT-PAID-INT1                                */
               /*- THIS PROCEDURE WORKS OUT IF ANY LICENSE SHOWN DURING THIS LICENSE PERIOD     */
               /*- HAS MORE 'PAID' EXHIBITIONS THAN LIC_SHOWING_INT I.E. THE NUMBER OF          */
               /*- ORIGINALLY INTENDED SHOWINGS.                                                */
               /*-------------------------------------------------------------------------------*/
               BEGIN
                    SELECT NVL (LIC_SHOWING_INT, 10), COUNT (SCH_NUMBER)
                      INTO C_INTENDED_SHOWINGS, C_TOTAL_PRIOR_PAID
                      /*-------------------------------------------------------------------------------*/
                      /*- IF THE LICENSE NUMBER PASSED TO THE PROCEDURE IS NOT EQUAL TO ZERO THEN      */
                      /*- WE'RE LOOKING FOR "EXCESS RUNS" IN THE MAIN BODY OF REPORT_SCHEDULE AND      */
                      /*- WE'RE RETURNING THE NUMBER OF 'PAID' EXHIBITIONS UPTO, BUT NOT INCLUDING,    */
                      /*- THE CURRENT MONTH                                                            */
                      /*-------------------------------------------------------------------------------*/
                      FROM FID_SCHEDULE, FID_LICENSE
                     WHERE     LIC_NUMBER = ALL_RS.LIC_NUMBER_PAR
                           AND SCH_LIC_NUMBER(+) = LIC_NUMBER
                           AND SCH_TYPE(+) = 'P'
                           AND SCH_DATE(+) <=
                                  LAST_DAY (
                                     TO_DATE (
                                        '01'
                                        || LPAD (TO_CHAR (C_PREVIOUS_MONTH),
                                                 2,
                                                 '0')
                                        || C_PREVIOUS_YEAR,
                                        'DDMMYYYY'))
                  GROUP BY LIC_SHOWING_INT;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;
            END IF;

            /*-------------------------------------------------------------------------------*/
            /*-       IF THE SCH_TYPE = 'P' I.E. IT IS A PAID SHOWING, FIND OTHER SHOWINGS   */
            /*-       AND SUM THE SUBS                                                       */
            /*-------------------------------------------------------------------------------*/
            IF ALL_RS.SCH_TYPE_PAR = 'P'
            THEN
               /*-------------------------------------------------------------------------------*/
               /*  IF THIS 'PAID' SHOWING IS ON THE LAST DAY OF THE PREVIOUS MONTH           */
               /*  THEN DON'T ADD IT TO THE PARAMETER HOLDING THE NUMBER OF PAID             */
               /*  SHOWINGS THIS MONTH I.E. #PAID_THIS_MONTH AND INITIALISE THE              */
               /*  #TOTAL_SUBSCRIBERS VARIABLE                                               */
               /*-------------------------------------------------------------------------------*/
               C_TOTAL_SUBSCRIBERS := 0;
               C_NEXT_PAID_DATE := 9999999900000;

               IF ALL_RS.SCH_MONTH_PAR = C_CURR_MONTH
               THEN
                  C_PAID_THIS_MONTH := C_PAID_THIS_MONTH + 1;
               END IF;

               /*-------------------------------------------------------------------------------*/
               /*- PROCEDURE DEFINITION - REPORT-FIND-PREVIOUS-NEXT-PAID                        */
               /*-------------------------------------------------------------------------------*/
               BEGIN
                    SELECT MIN (SX1_SCH_DATE_TIME)
                      INTO C_NEXT_PAID_DATE
                      FROM FID_SCHEDULE_MUX1
                     WHERE     SX1_LIC_NUMBER = ALL_RS.LIC_NUMBER_PAR
                           AND SX1_SCH_TYPE = 'P'
                           AND SX1_SCH_DATE_TIME > ALL_RS.THIS_SHOWING_DATE
                  GROUP BY SX1_LIC_NUMBER;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     C_NEXT_PAID_DATE := 9999999900000;
               END;

               /*-------------------------------------------------------------------------------*/
               /*- PROCEDURE DEFINITION - REPORT-FIND-OTHER-SHOWINGS                            */
               /*- THIS PROCEDURE FINDS OTHER ASSOCIATED 'F' (FREE) SHOWINGS TO THIS 'P' (PAID) */
               /*- ONE                                                                          */
               /*-------------------------------------------------------------------------------*/
               BEGIN
                  SELECT SUM (SX4_SUBS)
                    INTO C_TOTAL_SUBSCRIBERS
                    FROM FID_SCHEDULE_MUX4 C, FID_SCHEDULE_MUX3 A
                   WHERE C.SX4_CHA_NUMBER = A.SX3_CHA_NUMBER
                         AND EXISTS
                                (SELECT NULL
                                   FROM FID_SCHEDULE_MUX1,
                                        FID_SCHEDULE_MUX3 B
                                  WHERE SX1_SCH_CHA_NUMBER = B.SX3_CHA_NUMBER
                                        AND SX1_LIC_NUMBER = A.SX3_LIC_NUMBER
                                        AND B.SX3_LIC_NUMBER =
                                               A.SX3_LIC_NUMBER
                                        AND SX1_SCH_DATE_TIME >=
                                               ALL_RS.THIS_SHOWING_DATE
                                        AND SX1_SCH_DATE_TIME <
                                               C_NEXT_PAID_DATE
                                        AND SX1_SCH_DATE_TIME <
                                               ALL_RS.SCH_DATE_TIME_PLUS_ONE
                                        AND ( (SX1_SCH_TYPE = 'F')
                                             OR (SX1_SCH_NUMBER =
                                                    ALL_RS.SCH_NUMBER_PAR)))
                         AND A.SX3_COUNT > 0
                         AND A.SX3_LIC_NUMBER = ALL_RS.LIC_NUMBER_PAR;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     C_TOTAL_SUBSCRIBERS := 0;
               END;

               /*-------------------------------------------------------------------------------*/
               /*-    IF THE #TOTAL_SUBSCRIBERS FIGURE IS LESS THAN THE VALUE HELD              */
               /*-    IN THE #MAXIMUM_SUBSCRIBERS VARIABLE ADD SOMETHING SUITABLE               */
               /*-    TO THE COMMENTS.                                                          */
               /*-------------------------------------------------------------------------------*/
               -- PKG_PB_FID_SCHEDVER_PK.RUN_RSLT(2,'FIDSCH06',C_CURR_YEAR||LPAD(C_CURR_MONTH,2,0),'TST:'||
               -- C_TOTAL_SUBSCRIBERS||','||C_MAXIMUM_SUBSCRIBERS);
               IF C_TOTAL_SUBSCRIBERS < C_MAXIMUM_SUBSCRIBERS
               THEN
                  C_COMMENTS :=
                        'ONLY '
                     || TO_CHAR (C_TOTAL_SUBSCRIBERS)
                     || ' OUT OF '
                     || TO_CHAR (C_MAXIMUM_SUBSCRIBERS)
                     || ' SUBS.';
               END IF;

               /*-------------------------------------------------------------------------------*/
               /*- IF THE NUMBER OF 'PAID' SHOWINGS UPTO AND INCLUDING THIS ONE                 */
               /*- IS GREATER THAN THE NUMBER OF INTENDED SHOWINGS THEN GIVE A MESSAGE          */
               /*- TO THAT EFFECT                                                               */
               /*-------------------------------------------------------------------------------*/
               IF C_PAID_THIS_MONTH + C_TOTAL_PRIOR_PAID >
                     C_INTENDED_SHOWINGS
               THEN
                  C_COMMENTS :=
                     SUBSTR (C_COMMENTS || '**EXCESS RUN**', 1, 150);
                  V_VERIFICATION := 'N';
               END IF;
            END IF;

            /*-------------------------------------------------------------------------------*/
            /*-      ! PRINT WHAT EVER $COMMENTS WE HAVE GLEANED IN THE "COMMENTS" SECTION   */
            /*-      ! IN THE REPORT MAKING SURE THAT THEY ONLY OCCUPY THE SPACES AVAILABLE  */
            /*-      ! AND FOR A 'P' (PAID) SHOWING PRINT THEM IN BOLD.                      */
            /*-      !                                                                       */
            /*-            !                                                        */
            /*-            ! THE BOLD BELOW IS COMMENTED OUT                        */
            /*-            ! UNTIL WE KNOW HOW TO PRINT BOLD                        */
            /*-            ! POSTSCRIPT                                             */
            /*-------------------------------------------------------------------------------*/
            INSERT INTO FID_SVR_REP1 (SVR_PERIOD,
                                      SVR_CURR_DATE,
                                      SVR_CON_SHORT_NAME,
                                      SVR_LIC_NUMBER,
                                      SVR_GEN_TITLE,
                                      SVR_SER_SHT,
                                      SVR_CHA_SHORT_NAME,
                                      SVR_SCH_DATE,
                                      SVR_SCH_TIME,
                                      SVR_SCH_SLOT,
                                      SVR_SCH_TYPE,
                                      SVR_COMMENTS)
                 VALUES (C_CURR_YEAR || LPAD (C_CURR_MONTH, 2, 0),
                         SYSDATE,
                         ALL_RS.CON_SHT,
                         ALL_RS.LIC_NUMBER,
                         ALL_RS.GEN_TITLE,
                         ALL_RS.SER_SHT,
                         ALL_RS.CHA_SHORT_NAME,
                         TO_DATE (ALL_RS.SCH_DATE, 'DD/MM/YYYY'),
                         ALL_RS.SCH_TIME,
                         ALL_RS.SCH_SLOT,
                         ALL_RS.SCH_TYPE,
                         C_COMMENTS);

            /* !!!!!!!!!!REMOVE AFTER TESTING  */
            -- PKG_PB_FID_SCHEDVER_PK.RUN_RSLT(2,'FIDSCH06',C_CURR_YEAR||LPAD(C_CURR_MONTH,2,0),'UPD COM:'
            -- ||C_COMMENTS||','||C_ROWNUM);

            /*      PRINT $COMMENTS  (,97,62)  !BOLD */
            /*-------------------------------------------------------------------------------*/
            /*- PROCEDURE DEFINITION - UPDATE-SCH-TYPE-SCHEDULE                              */
            /*- THIS PROCEDURE UPDATES THE SCH_TYPE ON THE FID_SCHEDULE TABLE                */
            /*-------------------------------------------------------------------------------*/
            /* !!!!!!!!!!PUT BACK AFTER TESTING  */
            IF C_UPD_YN = 'Y'
            THEN
               UPDATE FID_SCHEDULE
                  SET SCH_TYPE = ALL_RS.SCH_TYPE_PAR,
                      SCH_ENTRY_OPER = I_USER_ID,
                      SCH_ENTRY_DATE = SYSDATE
                WHERE SCH_NUMBER = ALL_RS.SCH_NUMBER_PAR
                      AND SCH_TYPE != ALL_RS.SCH_TYPE_PAR;
            END IF;

            C_OLD_LIC_NUMBER := ALL_RS.LIC_NUMBER_PAR;
         END LOOP;

         C_VERIFICATION_2 := V_VERIFICATION;
      END;

      /*-------------------------------------------------------------------------------*/
      /*- CHANGES DONE FOR PROJECT BIOSCOPE IMPLEMENTATION - CHANGES STARTS            */
      /*-------------------------------------------------------------------------------*/
      FOR SCH IN SCH_C
      LOOP
         COSTED_CHANNEL := 0;
         L_PAID_COUNT_ON_LIC_LEVEL := 0;
         L_LIC_SHOWING_LIC := 0;

         SELECT COUNT (0)
           INTO L_PAID_COUNT_ON_LIC_LEVEL
           FROM FID_SCHEDULE, FID_LICENSE_CHANNEL_RUNS
          WHERE     SCH_TYPE = 'P'
                AND SCH_LIC_NUMBER = SCH.SCH_LIC_NUMBER
                AND SCH_CHA_NUMBER = LCR_CHA_NUMBER
                AND SCH_LIC_NUMBER = LCR_LIC_NUMBER
                AND LCR_COST_IND = 'Y'
                AND SCH_DATE < SCH.SCH_DATE;

         SELECT LIC_SHOWING_LIC
           INTO L_LIC_SHOWING_LIC
           FROM FID_LICENSE
          WHERE LIC_NUMBER = SCH.SCH_LIC_NUMBER;

         IF L_PAID_COUNT_ON_LIC_LEVEL < L_LIC_SHOWING_LIC
         THEN
            SELECT COUNT (*)
              INTO COSTED_CHANNEL
              FROM FID_LICENSE_CHANNEL_RUNS
             WHERE     LCR_LIC_NUMBER = SCH.SCH_LIC_NUMBER
                   AND LCR_CHA_NUMBER = SCH.SCH_CHA_NUMBER
                   AND LCR_COST_IND = 'Y';

            IF COSTED_CHANNEL > 0
            THEN
               FIRST_SCHEDULING_WINDOW := 0;

               SELECT COUNT (*)
                 INTO FIRST_SCHEDULING_WINDOW
                 FROM FID_LICENSE_CHANNEL_RUNS
                WHERE     LCR_LIC_NUMBER = SCH.SCH_LIC_NUMBER
                      AND LCR_CHA_NUMBER = SCH.SCH_CHA_NUMBER
                      AND LCR_COST_IND = 'Y'
                      AND SCH.SCH_DATE BETWEEN LCR_SCH_START_DATE
                                           AND LCR_SCH_END_DATE;

               TOTAL_PAID_RUNS_ON_SCH_WND := 0;
               SCH_WND_START_DATE := NULL;
               SCH_WND_END_DATE := NULL;
               EARLIER_PAID_RUNS_ON_SCH_WND := 0;

               IF FIRST_SCHEDULING_WINDOW > 0
               THEN
                  BEGIN
                     SELECT NVL (LCR_CHA_COSTED_RUNS, 0),
                            LCR_SCH_START_DATE,
                            LCR_SCH_END_DATE
                       INTO TOTAL_PAID_RUNS_ON_SCH_WND,
                            SCH_WND_START_DATE,
                            SCH_WND_END_DATE
                       FROM FID_LICENSE_CHANNEL_RUNS
                      WHERE     LCR_LIC_NUMBER = SCH.SCH_LIC_NUMBER
                            AND LCR_CHA_NUMBER = SCH.SCH_CHA_NUMBER
                            AND LCR_COST_IND = 'Y';
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        TOTAL_PAID_RUNS_ON_SCH_WND := 0;
                  END;

                  BEGIN
                     SELECT NVL (COUNT (SCH_NUMBER), 0)
                       INTO EARLIER_PAID_RUNS_ON_SCH_WND
                       FROM FID_SCHEDULE
                      WHERE     SCH_TYPE = 'P'
                            AND SCH_LIC_NUMBER = SCH.SCH_LIC_NUMBER
                            AND SCH_DATE < SCH.SCH_DATE
                            AND SCH_DATE BETWEEN SCH_WND_START_DATE
                                             AND SCH_WND_END_DATE
                            AND SCH_CHA_NUMBER = SCH.SCH_CHA_NUMBER;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        EARLIER_PAID_RUNS_ON_SCH_WND := 0;
                  END;
               ELSE
                  BEGIN
                     SELECT NVL (LCR_CHA_COSTED_RUNS2, 0),
                            LCR_SCH_START_DATE2,
                            LCR_SCH_END_DATE2
                       INTO TOTAL_PAID_RUNS_ON_SCH_WND,
                            SCH_WND_START_DATE,
                            SCH_WND_END_DATE
                       FROM FID_LICENSE_CHANNEL_RUNS
                      WHERE     LCR_LIC_NUMBER = SCH.SCH_LIC_NUMBER
                            AND LCR_CHA_NUMBER = SCH.SCH_CHA_NUMBER
                            AND LCR_COST_IND = 'Y';
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        TOTAL_PAID_RUNS_ON_SCH_WND := 0;
                  END;

                  BEGIN
                     SELECT NVL (COUNT (SCH_NUMBER), 0)
                       INTO EARLIER_PAID_RUNS_ON_SCH_WND
                       FROM FID_SCHEDULE
                      WHERE     SCH_TYPE = 'P'
                            AND SCH_LIC_NUMBER = SCH.SCH_LIC_NUMBER
                            AND SCH_DATE < SCH.SCH_DATE
                            AND SCH_DATE BETWEEN SCH_WND_START_DATE
                                             AND SCH_WND_END_DATE
                            AND SCH_CHA_NUMBER = SCH.SCH_CHA_NUMBER;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        EARLIER_PAID_RUNS_ON_SCH_WND := 0;
                  END;
               END IF;

               IF TOTAL_PAID_RUNS_ON_SCH_WND > EARLIER_PAID_RUNS_ON_SCH_WND
               THEN
                  PAID_RUNS_ON_THE_DAY := 0;

                  SELECT NVL (COUNT (SCH_NUMBER), 0)
                    INTO PAID_RUNS_ON_THE_DAY
                    FROM FID_SCHEDULE
                   WHERE     SCH_TYPE = 'P'
                         AND SCH_LIC_NUMBER = SCH.SCH_LIC_NUMBER
                         AND SCH_DATE = SCH.SCH_DATE
                         AND SCH_TIME < SCH.SCH_TIME
                         AND SCH_DATE BETWEEN SCH_WND_START_DATE
                                          AND SCH_WND_END_DATE
                         AND SCH_CHA_NUMBER = SCH.SCH_CHA_NUMBER;

                  EARLIER_PAID_RUNS_ON_SCH_WND :=
                     EARLIER_PAID_RUNS_ON_SCH_WND + PAID_RUNS_ON_THE_DAY;

                  IF TOTAL_PAID_RUNS_ON_SCH_WND >
                        EARLIER_PAID_RUNS_ON_SCH_WND
                  THEN
                     UPDATE FID_SCHEDULE
                        SET SCH_TYPE = 'P'
                      WHERE SCH_NUMBER = SCH.SCH_NUMBER;
                  ELSE
                     UPDATE FID_SCHEDULE
                        SET SCH_TYPE = 'N'
                      WHERE SCH_NUMBER = SCH.SCH_NUMBER;
                  END IF;
               ELSE
                  UPDATE FID_SCHEDULE
                     SET SCH_TYPE = 'N'
                   WHERE SCH_NUMBER = SCH.SCH_NUMBER;
               END IF;
            ELSE
               UPDATE FID_SCHEDULE
                  SET SCH_TYPE = 'N'
                WHERE SCH_NUMBER = SCH.SCH_NUMBER;
            END IF;
         ELSE
            UPDATE FID_SCHEDULE
               SET SCH_TYPE = 'N'
             WHERE SCH_NUMBER = SCH.SCH_NUMBER;
         END IF;
      END LOOP;

      /*-------------------------------------------------------------------------------*/
      /*- CHANGES DONE FOR PROJECT BIOSCOPE IMPLEMENTATION - CHANGES ENDS              */
      /*-------------------------------------------------------------------------------*/

      --CHANGES DONE FOR PURE FINANCE - BIOSCOPE/NON BIOSCOPE IMPLEMENATION
      --PURE FINANCE[MANGESH_GULHANE][2013-02-25]
      PKG_PB_FID_SCHEDVER_PK.PRC_FIN_SCH_VEREX (C_CURR_YEAR,
                                                C_CURR_MONTH,
                                                C_PREVIOUS_YEAR,
                                                C_PREVIOUS_MONTH,
                                                I_SPLIT_REGION);

      PKG_PB_FID_SCHEDVER_PK.PRC_FIN_SCH_VEREX_NEW_RULE (C_CURR_YEAR,
                                                         C_CURR_MONTH,
                                                         C_PREVIOUS_YEAR,
                                                         C_PREVIOUS_MONTH,
                                                         I_SPLIT_REGION);
   --PURE FINANCE END
   END;                                         /*PROCEDURE REPORT_SCHEDULE */

   PROCEDURE REPORT_COUNT_PAID_INT2 (C_YEAR             IN     NUMBER,
                                     C_MONTH            IN     NUMBER,
                                     C_UPD_YN           IN     VARCHAR2,
                                     C_VERIFICATION_3      OUT VARCHAR2)
   IS
      /*-------------------------------------------------------------------------------*/
      /*- PROCEDURE DEFINITION - REPORT_COUNT_PAID_INT2                                */
      /*- THIS PROCEDURE WORKS OUT IF ANY LICENSE SHOWN DURING THIS LICENSE PERIOD     */
      /*- HAS MORE 'PAID' EXHIBITIONS THAN LIC_SHOWING_INT I.E. THE NUMBER OF          */
      /*- ORIGINALLY INTENDED SHOWINGS.                                                */
      /*-------------------------------------------------------------------------------*/
      V_COMMENTS         VARCHAR2 (150);
      V_PERIOD           NUMBER (6) := CONCAT (C_YEAR, LPAD (C_MONTH, 2, 0));
      V_VERIFICATION     VARCHAR2 (10) := NULL;
      V_CHA_SHORT_NAME   VARCHAR2 (4);
      V_CHA_NUMBER       NUMBER := 0;
      V_LIC              NUMBER := 0;
      V_SCHED_RUNS       NUMBER := 0;
      V_ALLOC_RUNS       NUMBER := 0;
      V_TITLE            VARCHAR2 (30) := ' ';
      V_CHA_MAX_RUNS     NUMBER;

      CURSOR T_lic
      IS
         SELECT sch_lic_number LICENSE_NUMBER, SCH_DATE, SCH_CHA_NUMBER
           FROM fid_schedule, fid_license
          WHERE sch_lic_number(+) = lic_number AND lic_status = 'T'
                AND SCH_DATE(+) <=
                       LAST_DAY (
                          TO_DATE (
                                '01'
                             || LPAD (TO_CHAR (C_MONTH), 2, '0')
                             || C_YEAR,
                             'DDMMYYYY'));

      CURSOR MORE_PAID
      IS
           SELECT                         /*+ INDEX(FID_LICENSE LIC_NDX_1)  */
                 LIC_NUMBER LICENSE_NUMBER,
                  NVL (LIC_SHOWING_INT, 10) INTENDED_SHOWINGS,
                  SUBSTR (GEN_TITLE, 1, 30) TITLE,
                  LIC_AMORT_CODE,
                  COUNT (SCH_NUMBER) NO_PAID,
                  --acqisation and scheduling CR [sch04] [Mangesh gulhane]
                  sch_cha_number
             --end
             FROM fid_general, fid_schedule, fid_license
            --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
            WHERE EXISTS
                     (SELECT NULL
                        FROM FID_SCHEDULE_MUX1
                       WHERE sx1_lic_number = lic_number
                             AND sx1_lic_amort_code NOT IN ('D', 'E' ,'F'))  --ver 1.1 added 'F'
                  --END  AFRICA FREE REPEAT
                  AND lic_status <> 'T'                               ---Added
                  AND SCH_LIC_NUMBER(+) = LIC_NUMBER
                  AND SCH_TYPE(+) = 'P'
                  AND SCH_DATE(+) <=
                         LAST_DAY (
                            TO_DATE (
                                  '01'
                               || LPAD (TO_CHAR (C_MONTH), 2, '0')
                               || C_YEAR,
                               'DDMMYYYY'))
                  AND GEN_REFNO = LIC_GEN_REFNO
         GROUP BY LIC_NUMBER,
                  LIC_SHOWING_INT,
                  SUBSTR (GEN_TITLE, 1, 30),
                  LIC_AMORT_CODE,
                  sch_cha_number
         ORDER BY SUBSTR (GEN_TITLE, 1, 30);

      CURSOR GET_MUX2
      IS
         SELECT DISTINCT SX1_LIC_NUMBER,
                         SX1_GEN_TITLE,
                         SX1_SCH_CHA_NUMBER,
                         NVL (SX1_ALLOC_RUNS, 0) SX1_ALLOC_RUNS,
                         NVL (SX1_MAX_CHS, 0) SX1_MAX_CHS
           FROM fid_schedule_mux1
          --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
          WHERE sx1_lic_amort_code IN ('D', 'E' , 'F')          --ver 1.1 added 'F'
                AND SX1_SCH_TYPE IN ('P', 'N')
                --END  AFRICA FREE REPEAT
                AND SX1_SCH_DATE <=
                       LAST_DAY (
                          TO_DATE (
                                '01'
                             || LPAD (TO_CHAR (C_MONTH), 2, '0')
                             || C_YEAR,
                             'DDMMYYYY'));

      CURSOR GET_MUX3
      IS
           SELECT SCH_LIC_NUMBER LICENSE_NUMBER,
                  SCH_CHA_NUMBER CHA_NUMBER,
                  SUBSTR (GEN_TITLE, 1, 30) TITLE,
                  NVL (COUNT (SCH_NUMBER), 0) TOT_CHA
             FROM fid_schedule, fid_license, fid_general
            --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
            WHERE     lic_amort_code IN ('D', 'E' , 'F')     --ver 1.1 added 'F'
                  AND sch_type IN ('P', 'N')
                  --END  AFRICA FREE REPEAT
                  AND SCH_LIC_NUMBER = V_LIC
                  AND SCH_CHA_NUMBER = V_CHA_NUMBER
                  AND LIC_NUMBER = SCH_LIC_NUMBER
                  AND GEN_REFNO = LIC_GEN_REFNO
                  AND lic_status <> 'T'                               ---Added
                  AND SCH_DATE <=
                         LAST_DAY (
                            TO_DATE (
                                  '01'
                               || LPAD (TO_CHAR (C_MONTH), 2, '0')
                               || C_YEAR,
                               'DDMMYYYY'))
         GROUP BY SCH_LIC_NUMBER, SCH_CHA_NUMBER, SUBSTR (GEN_TITLE, 1, 30)
         ORDER BY SCH_LIC_NUMBER, SCH_CHA_NUMBER;

      CURSOR TOT_CHS
      IS
           SELECT LIC_SHOWING_INT, NVL (COUNT (SCH_NUMBER), 0) TOT_CHS
             FROM FID_SCHEDULE, FID_LICENSE
            WHERE     SCH_LIC_NUMBER = V_LIC
                  AND lic_number = sch_lic_number --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
                  AND sch_type IN ('P', 'N')
                  AND lic_status <> 'T'                               ---Added
                  --END  AFRICA FREE REPEAT
                  AND SCH_DATE <=
                         LAST_DAY (
                            TO_DATE (
                                  '01'
                               || LPAD (TO_CHAR (C_MONTH), 2, '0')
                               || C_YEAR,
                               'DDMMYYYY'))
         GROUP BY LIC_SHOWING_INT;

      TOT_CHS_REC        TOT_CHS%ROWTYPE;

      /*****************************************************************************************/
      /* REPORT ON SCHEDULED LICENSES(D) THAT HAVE BEEN SCHEDULED ON INCORRECT CHANNELS.  THEY */
      /* WOULD NOT BE FOUND IN FID_LICENSE_CHANNEL_RUNS FOR SCH CHANNEL.                       */
      /*****************************************************************************************/
      CURSOR NOT_IN_LCR
      IS
           SELECT SX1_LIC_NUMBER,
                  SX1_GEN_TITLE,
                  SX1_SCH_DATE,
                  CHA_SHORT_NAME,
                  SX1_SCH_CHA_NUMBER
             FROM FID_SCHEDULE_MUX1, FID_CHANNEL
            WHERE SX1_SCH_DATE BETWEEN TO_DATE (
                                             '01'
                                          || LPAD (TO_CHAR (C_MONTH), 2, '0')
                                          || C_YEAR,
                                          'DDMMYYYY')
                                   AND LAST_DAY (
                                          TO_DATE (
                                             '01'
                                             || LPAD (TO_CHAR (C_MONTH),
                                                      2,
                                                      '0')
                                             || C_YEAR,
                                             'DDMMYYYY'))
                  --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
                  AND sx1_lic_amort_code IN ('D', 'E' ,'F')              --ver 1.1 added 'F'
                  AND SX1_SCH_TYPE IN ('P', 'N')
                  --END  AFRICA FREE REPEAT
                  AND CHA_NUMBER = SX1_SCH_CHA_NUMBER
                  AND SX1_SCH_CHA_NUMBER NOT IN
                         (SELECT LCR_CHA_NUMBER
                            FROM FID_LICENSE_CHANNEL_RUNS
                           WHERE LCR_LIC_NUMBER = SX1_LIC_NUMBER)
         ORDER BY 1;
   /*-------------------------------------------------------------------------------*/
   /*-  COMPARE LIC_SHOWING_INT WITH NO_PAID, IF NO_PAID IS GREATER THAN            */
   /*-  THE FORMER, THEN CONSTRUCT A MESSAGE TO THAT EFFECT AND PRINT IT            */
   /*-------------------------------------------------------------------------------*/
   BEGIN
      FOR i IN t_lic
      LOOP
         V_VERIFICATION := 'N';
         V_COMMENTS :=
               'WARNING: T LICENSE '
            || TO_CHAR (I.LICENSE_NUMBER)
            || ' HAS BEEN SCHEDULED ON '
            || I.SCH_DATE;

         INSERT INTO fid_wrn_svr (wrn_period,
                                  wrn_curr_date,
                                  wrn_comments,
                                  wrn_lic_number,
                                  wrn_cha_number)
              VALUES (v_period,
                      SYSDATE,
                      v_comments,
                      I.license_number,
                      I.sch_cha_number);
      END LOOP;

      FOR SHOWS IN MORE_PAID
      LOOP
         IF SHOWS.INTENDED_SHOWINGS < SHOWS.NO_PAID
         THEN
            V_COMMENTS :=
               SUBSTR (
                     'WARNING: LIC '
                  || TO_CHAR (SHOWS.LICENSE_NUMBER)
                  || ' '
                  || SHOWS.TITLE
                  || ' HAS '
                  || TO_CHAR (SHOWS.NO_PAID)
                  || ' PAID SHOWINGS, BUT ONLY '
                  || TO_CHAR (SHOWS.INTENDED_SHOWINGS)
                  || ' ARE ALLOWED.',
                  1,
                  150);
            v_verification := 'N';

            --<catchup scheduling CRs -Mangesh gulhane 02-AUG-13 Lic field added >
            INSERT INTO fid_wrn_svr (wrn_period,
                                     wrn_curr_date,
                                     wrn_comments,
                                     wrn_lic_number,
                                     wrn_cha_number)
                 VALUES (v_period,
                         SYSDATE,
                         v_comments,
                         shows.license_number,
                         shows.sch_cha_number);
         --<catchup scheduling CRs End>
         END IF;
      END LOOP;

      /*-------------------------------------------------------------------------------*/
      /*- CHECK THE NUMBER OF SCHEDULED RUNS AGAINST THE NUMBER OF ALLOCATED RUNS PER  */
      /*- PER CHANNEL AND REPORT IF SCHEDULED EXCEED.                                  */
      /*-------------------------------------------------------------------------------*/
      FOR ALL_MUX2 IN GET_MUX2
      LOOP
         IF NVL (V_LIC, 0) <> ALL_MUX2.SX1_LIC_NUMBER
         THEN
            V_LIC := ALL_MUX2.SX1_LIC_NUMBER;

            OPEN TOT_CHS;

            /****** CHECK THAT TOTAL RUNS FOR LICENSE DO NOT EXCEED LIC_MAX_CHS ********/
            FETCH TOT_CHS INTO TOT_CHS_REC;

            IF TOT_CHS%FOUND
            THEN
               IF NVL (TOT_CHS_REC.TOT_CHS, 0) > TOT_CHS_REC.LIC_SHOWING_INT
               THEN
                  V_VERIFICATION := 'N';
                  V_COMMENTS :=
                     SUBSTR (
                           'WARNING: LICENSE '
                        || TO_CHAR (V_LIC)
                        || ' '
                        || ALL_MUX2.SX1_GEN_TITLE
                        || ' HAS '
                        || TO_CHAR (TOT_CHS_REC.TOT_CHS)
                        || ' SHOWINGS, BUT ONLY '
                        || TO_CHAR (TOT_CHS_REC.LIC_SHOWING_INT)
                        || ' IS ALLOWED.',
                        1,
                        150);
                  DBMS_OUTPUT.put_line (v_comments);

                  --<catchup scheduling CRs -Mangesh gulhane 02-AUG-13 Lic field added >
                  INSERT INTO fid_wrn_svr (wrn_period,
                                           wrn_curr_date,
                                           wrn_comments,
                                           wrn_lic_number,
                                           wrn_cha_number)
                       VALUES (V_PERIOD,
                               SYSDATE,
                               V_COMMENTS,
                               V_LIC,
                               ALL_MUX2.SX1_SCH_CHA_NUMBER);
               --<catchup scheduling CRs End>

               END IF;
            END IF;

            CLOSE TOT_CHS;
         END IF;

         V_CHA_NUMBER := ALL_MUX2.SX1_SCH_CHA_NUMBER;
         V_ALLOC_RUNS := ALL_MUX2.SX1_ALLOC_RUNS;
         V_SCHED_RUNS := 0;
         V_TITLE := NULL;

         FOR ALL_MUX3 IN GET_MUX3
         LOOP
            V_SCHED_RUNS := NVL (ALL_MUX3.TOT_CHA, 0);
            V_TITLE := ALL_MUX3.TITLE;
         END LOOP;

         IF V_TITLE IS NULL
         THEN
            BEGIN
               SELECT SUBSTR (GEN_TITLE, 1, 30) TITLE
                 INTO V_TITLE
                 FROM fid_license, fid_general
                --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013][Added condition for amort code E]
                WHERE     lic_amort_code IN ('D', 'E' ,'F')  --END  AFRICA FREE REPEAT        --ver 1.1 added 'F'
                      AND GEN_REFNO = LIC_GEN_REFNO
                      AND LIC_NUMBER = V_LIC;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  V_TITLE := NULL;
               WHEN OTHERS
               THEN
                  V_TITLE := NULL;
            END;
         END IF;

         IF V_SCHED_RUNS > V_ALLOC_RUNS
         THEN
            BEGIN
               SELECT CHA_SHORT_NAME
                 INTO V_CHA_SHORT_NAME
                 FROM FID_CHANNEL
                WHERE CHA_NUMBER = V_CHA_NUMBER;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  V_CHA_SHORT_NAME := '    ';
            END;

            V_VERIFICATION := 'N';
            V_COMMENTS :=
               SUBSTR (
                     'WARNING: LICENSE '
                  || TO_CHAR (V_LIC)
                  || ' '
                  || V_TITLE
                  || ' HAS '
                  || TO_CHAR (V_SCHED_RUNS)
                  || ' SHOWINGS FOR CHANNEL       '
                  || V_CHA_SHORT_NAME
                  || ', BUT ONLY '
                  || TO_CHAR (V_ALLOC_RUNS)
                  || ' ARE ALLOWED.',
                  1,
                  150);
            DBMS_OUTPUT.PUT_LINE (V_COMMENTS);

            --<catchup scheduling CRs -Mangesh gulhane 02-AUG-13 Lic field added >
            INSERT INTO fid_wrn_svr (wrn_period,
                                     wrn_curr_date,
                                     wrn_comments,
                                     wrn_lic_number,
                                     wrn_cha_number)
                 VALUES (v_period,
                         SYSDATE,
                         v_comments,
                         V_LIC,
                         ALL_MUX2.SX1_SCH_CHA_NUMBER);
         --<catchup scheduling CRs End>
         END IF;
      END LOOP;

      FOR SCH_NO_LCR IN NOT_IN_LCR
      LOOP
         V_VERIFICATION := 'N';
         V_COMMENTS :=
            SUBSTR (
                  'WARNING: LICENSE '
               || TO_CHAR (SCH_NO_LCR.SX1_LIC_NUMBER)
               || ' '
               || SCH_NO_LCR.SX1_GEN_TITLE
               || ' HAS SHOWINGS FOR CHANNEL '
               || SCH_NO_LCR.CHA_SHORT_NAME
               || ' ON '
               || TO_CHAR (SCH_NO_LCR.SX1_SCH_DATE, 'DD-MON-YYYY')
               || ' AND NONE ARE ALLOWED.',
               1,
               150);

         --<catchup scheduling CRs -Mangesh gulhane 02-AUG-13 Lic field added >
         INSERT INTO fid_wrn_svr (wrn_period,
                                  wrn_curr_date,
                                  wrn_comments,
                                  wrn_lic_number,
                                  wrn_cha_number)
              VALUES (v_period,
                      SYSDATE,
                      v_comments,
                      SCH_NO_LCR.SX1_LIC_NUMBER,
                      SCH_NO_LCR.SX1_SCH_CHA_NUMBER);
      --<catchup scheduling CRs End>
      END LOOP;

      C_VERIFICATION_3 := V_VERIFICATION;
   END;

   PROCEDURE REPORT_PRIMETIME_EXC (C_YEAR             IN     NUMBER,
                                   C_MONTH            IN     NUMBER,
                                   C_UPD_YN           IN     VARCHAR2,
                                   C_VERIFICATION_3      OUT VARCHAR2)
   IS
      /*-------------------------------------------------------------------------------*/
      /*- PROCEDURE DEFINITION - REPORT_PRIMETIME_EXC                                  */
      /*- THIS PROCEDURE WORKS OUT IF ANY LICENSE SHOWN DURING THIS LICENSE PERIOD     */
      /*- BREAKS ANY OF THE PRIMETIME RESTRICTIONS.  IT CHECKS THAT THE MAX RUNS ARE   */
      /*- NOT EXCEEDED AND THAT THE LIMIT PER DAY IS ALSO INTACT.                      */
      /*-------------------------------------------------------------------------------*/
      V_COMMENTS               VARCHAR2 (150);
      V_PERIOD                 NUMBER (6) := CONCAT (C_YEAR, LPAD (C_MONTH, 2, 0));
      V_VERIFICATION           VARCHAR2 (10) := NULL;
      V_CHA_SHORT_NAME         VARCHAR2 (4);
      P_LIC_NUMBER             NUMBER := 0;
      V_LIC                    NUMBER := 0;
      V_SCHED_RUNS             NUMBER := 0;
      V_ALLOC_RUNS             NUMBER := 0;
      V_CON_PRIME_TIME_START   NUMBER;
      V_CON_PRIME_TIME_END     NUMBER;
      V_TITLE                  VARCHAR2 (30) := ' ';
      V_CHA_MAX_RUNS           NUMBER;

      CURSOR ALL_LICS
      IS
         SELECT DISTINCT SX1_LIC_NUMBER,
                         SX1_GEN_TITLE,
                         CON_PRIME_TIME_START,
                         CON_PRIME_TIME_END,
                         CON_PRIME_TIME_PD_LIMIT,
                         CON_PRIME_TIME_TYPE,
                         CON_PRIME_TIME_LEVEL,
                         CON_PRIME_MAX_RUNS,
                         CON_PRIME_MAX_RUNS_PERC,
                         -- acquisation and scheduling CR[SCH04] added by mangesh[12-Sep-13]
                         SX1_sch_cha_number
           --END
           FROM FID_SCHEDULE_MUX1, FID_CONTRACT
          WHERE CON_SHORT_NAME = SX1_CON_SHORT_NAME
                AND (NVL (CON_PRIME_TIME_START, 0) > 0
                     AND NVL (CON_PRIME_TIME_END, 0) > 0);

      CURSOR PT_RULE
      IS
           SELECT *
             FROM FID_PT_SERVICE_CHANNEL_VW
            WHERE LPS_LIC_NUMBER = P_LIC_NUMBER
         ORDER BY 1, 2;

      V_CHA_NUMBER             VARCHAR2 (5) := '%';
      V_DURA                   NUMBER := 0;
      V_CNT                    NUMBER := 0;
      V_DAY_CNT                NUMBER := 0;

      CURSOR GET_DURA
      IS
         SELECT GEN_REFNO,
                GEN_TITLE_WORKING,
                GEN_DURATION,
                GEN_DURATION_C,
                GEN_DURATION_S,
                LIC_STATUS,
                CHS_SHORT_NAME
           FROM FID_GENERAL, FID_LICENSE, FID_CHANNEL_SERVICE
          WHERE     LIC_NUMBER = P_LIC_NUMBER
                AND LIC_STATUS <> 'T'                                 -- Added
                AND CHS_NUMBER = LIC_CHS_NUMBER
                AND GEN_REFNO = LIC_GEN_REFNO;

      DURA                     GET_DURA%ROWTYPE;

      /******************************************************************************************/
      /*- PRIME TIME TYPE 'PTIN' WHERE A PROGRAMME THAT STARTS BETWEEN PRIME TIME START         */
      /*- AND END TIME IS CONSIDERED PRIME TIME, EXCEPT ON THE LAST MINUTE. IF PROGRAMME START  */
      /*- BEFORE START TIMES AND RUN INTO OR OVER END TIME, IT IS  NOT A PRIME TIME RUN.        */
      /******************************************************************************************/
      CURSOR GET_SCH1
      IS
           SELECT SCH_NUMBER,
                  CHA_SHORT_NAME,
                  SCH_DATE,
                  ISM_SCH.SEC2CHAR (SCH_TIME) CON_TIME,
                  SCH_TIME,
                  -- acquisation and scheduling CR[SCH04] added by mangesh[12-Sep-13]
                  sch_cha_number
             --end
             FROM FID_SCHEDULE, FID_CHANNEL
            WHERE sch_lic_number = p_lic_number --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013]
                                               AND sch_type IN ('P', 'N')
                  --END  AFRICA FREE REPEAT
                  AND SCH_DATE <=
                         LAST_DAY (
                            TO_DATE (
                                  '01'
                               || LPAD (TO_CHAR (C_MONTH), 2, '0')
                               || C_YEAR,
                               'DDMMYYYY'))
                  AND (SCH_TIME >= V_CON_PRIME_TIME_START
                       AND SCH_TIME < V_CON_PRIME_TIME_END)
                  AND SCH_CHA_NUMBER LIKE V_CHA_NUMBER
                  AND CHA_NUMBER = SCH_CHA_NUMBER
         ORDER BY SCH_DATE, SCH_TIME;

      /******************************************************************************************/
      /*- PRIME TIME TYPE 'PTDUR' WHERE A PROGRAMME THAT STARTS BETWEEN PRIME TIME START        */
      /*- AND END TIME IS CONSIDERED PRIME TIME, EXCEPT ON THE LAST MINUTE.                     */
      /*- IF PROGRAMME START BEFORE START TIME AND RUN OVER BY 30 MINUTES OR MORE,              */
      /*- IT IS A PRIME TIME RUN.                                                               */
      /******************************************************************************************/
      CURSOR GET_SCH2
      IS
         SELECT SCH_NUMBER,
                CHA_SHORT_NAME,
                SCH_DATE,
                ISM_SCH.SEC2CHAR (SCH_TIME) CON_TIME,
                SCH_TIME,
                -- acquisation and scheduling CR[SCH04] added by mangesh[12-Sep-13]
                sch_cha_number
           --end
           FROM FID_SCHEDULE, FID_CHANNEL
          WHERE sch_lic_number = p_lic_number --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013]
                                             AND sch_type IN ('P', 'N')
                --END  AFRICA FREE REPEAT
                AND SCH_DATE <=
                       LAST_DAY (
                          TO_DATE (
                                '01'
                             || LPAD (TO_CHAR (C_MONTH), 2, '0')
                             || C_YEAR,
                             'DDMMYYYY'))
                AND (SCH_TIME >= V_CON_PRIME_TIME_START
                     AND SCH_TIME < V_CON_PRIME_TIME_END)
                AND SCH_CHA_NUMBER LIKE V_CHA_NUMBER
                AND CHA_NUMBER = SCH_CHA_NUMBER
         UNION
         SELECT SCH_NUMBER,
                CHA_SHORT_NAME,
                SCH_DATE,
                ISM_SCH.SEC2CHAR (SCH_TIME) CON_TIME,
                SCH_TIME,
                -- acquisation and scheduling CR[SCH04] added by mangesh[12-Sep-13]
                sch_cha_number
           --end
           FROM FID_SCHEDULE, FID_CHANNEL
          WHERE sch_lic_number = p_lic_number --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013]
                                             AND sch_type IN ('P', 'N')
                --END  AFRICA FREE REPEAT
                AND SCH_DATE <=
                       LAST_DAY (
                          TO_DATE (
                                '01'
                             || LPAD (TO_CHAR (C_MONTH), 2, '0')
                             || C_YEAR,
                             'DDMMYYYY'))
                AND (SCH_TIME < V_CON_PRIME_TIME_START
                     AND (SCH_TIME + V_DURA) >=
                            (V_CON_PRIME_TIME_START + 1800))
                AND SCH_CHA_NUMBER LIKE V_CHA_NUMBER
                AND CHA_NUMBER = SCH_CHA_NUMBER
         ORDER BY 3, 5;

      /*****************************************************************************************/
      /*- COUNT THE NUMBER OF PRIME TIME RUNS PER DAY PER SERVICE, IF THE LIMIT                */
      /*- SPECIFIES 'Y', THEN                                                                  */
      /*- REPORT ON THE LICENSES ON THE SCHEDULE THAT EXCEEDS THE LIMIT OF 1 PT A DAY/SERVICE. */
      /*****************************************************************************************/
      CURSOR GET_LIMIT1
      IS
           SELECT COUNT (*) TOT, SCH_DATE, -- acquisation and scheduling CR[SCH04] added by mangesh[12-Sep-13]
                                          sch_cha_number
             --end
             FROM FID_SCHEDULE
            WHERE sch_lic_number = p_lic_number --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013]
                                               AND sch_type IN ('P', 'N')
                  --END  AFRICA FREE REPEAT
                  AND SCH_DATE <=
                         LAST_DAY (
                            TO_DATE (
                                  '01'
                               || LPAD (TO_CHAR (C_MONTH), 2, '0')
                               || C_YEAR,
                               'DDMMYYYY'))
                  AND (SCH_TIME >= V_CON_PRIME_TIME_START
                       AND SCH_TIME < V_CON_PRIME_TIME_END)
         GROUP BY SCH_DATE, sch_cha_number
           HAVING COUNT (*) > 1
         ORDER BY SCH_DATE;

      CURSOR GET_LIMIT2
      IS
           SELECT COUNT (*) TOT, SCH_DATE, -- acquisation and scheduling CR[SCH04] added by mangesh[12-Sep-13]
                                          sch_cha_number
             --end
             FROM FID_SCHEDULE
            WHERE sch_lic_number = p_lic_number --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013]
                                               AND sch_type IN ('P', 'N')
                  --END  AFRICA FREE REPEAT
                  AND SCH_DATE <=
                         LAST_DAY (
                            TO_DATE (
                                  '01'
                               || LPAD (TO_CHAR (C_MONTH), 2, '0')
                               || C_YEAR,
                               'DDMMYYYY'))
                  AND (SCH_TIME >= V_CON_PRIME_TIME_START
                       AND SCH_TIME < V_CON_PRIME_TIME_END)
         GROUP BY SCH_DATE, sch_cha_number
           HAVING COUNT (*) > 1
         UNION
           SELECT COUNT (*) TOT, SCH_DATE, -- acquisation and scheduling CR[SCH04] added by mangesh[12-Sep-13]
                                          sch_cha_number
             --end
             FROM FID_SCHEDULE
            WHERE sch_lic_number = p_lic_number --AFRICA FREE REPEAT[MANGESH_GULHANE][02-APR-2013]
                                               AND sch_type IN ('P', 'N')
                  --END  AFRICA FREE REPEAT
                  AND SCH_DATE <=
                         LAST_DAY (
                            TO_DATE (
                                  '01'
                               || LPAD (TO_CHAR (C_MONTH), 2, '0')
                               || C_YEAR,
                               'DDMMYYYY'))
                  AND (SCH_TIME < V_CON_PRIME_TIME_START
                       AND (SCH_TIME + V_DURA) >=
                              (V_CON_PRIME_TIME_START + 1800))
         GROUP BY SCH_DATE, sch_cha_number
           HAVING COUNT (*) > 1
         ORDER BY 2;
   /*-------------------------------------------------------------------------------*/
   /*-  COMPARE LIC_SHOWING_INT WITH NO_PAID, IF NO_PAID IS GREATER THAN            */
   /*-  THE FORMER, THEN CONSTRUCT A MESSAGE TO THAT EFFECT AND PRINT IT            */
   /*-------------------------------------------------------------------------------*/
   BEGIN
      /*****************************************************************************************/
      /*- READ RULES TO VALIDATE.                                                              */
      /*****************************************************************************************/
      FOR LICS IN ALL_LICS
      LOOP
         IF NVL (LICS.CON_PRIME_TIME_TYPE, ' ') = ' '
         THEN
            RAISE_APPLICATION_ERROR (-20001, 'Contract has no Prime Type');
         END IF;

         P_LIC_NUMBER := LICS.SX1_LIC_NUMBER;
         V_CON_PRIME_TIME_START := LICS.CON_PRIME_TIME_START;
         V_CON_PRIME_TIME_END := LICS.CON_PRIME_TIME_END;
         V_CNT := 0;

         FOR PT IN PT_RULE
         LOOP
            IF PT.LPC_CHA_NUMBER IS NULL
            THEN
               V_CHA_NUMBER := '%';
            ELSE
               V_CHA_NUMBER := TO_CHAR (PT.LPC_CHA_NUMBER);
            END IF;

            V_CNT := 0;

            IF LICS.CON_PRIME_TIME_TYPE = 'PTIN'
            THEN
               FOR SCH IN GET_SCH1
               LOOP
                  V_CNT := V_CNT + 1;

                  IF V_CNT > NVL (PT.MAX_RUNS, PT.TOT_MAX_RUNS)
                  THEN
                     V_VERIFICATION := 'N';
                     V_COMMENTS :=
                           P_LIC_NUMBER
                        || ' '
                        || SUBSTR (LICS.SX1_GEN_TITLE, 1, 50)
                        || ' ON '
                        || SCH.CHA_SHORT_NAME
                        || ' ON '
                        || SCH.SCH_DATE
                        || ','
                        || SCH.CON_TIME
                        || ' EXCEEDS MAX PRIME TIME RUNS OF '
                        || NVL (pt.max_runs, pt.tot_max_runs);

                     --<catchup scheduling CRs -Mangesh gulhane 02-AUG-13 Lic field and channel added >
                     INSERT INTO FID_WRN_SVR (WRN_PERIOD,
                                              wrn_curr_date,
                                              wrn_comments,
                                              wrn_lic_number,
                                              wrn_cha_number)
                          VALUES (v_period,
                                  SYSDATE,
                                  v_comments,
                                  P_LIC_NUMBER,
                                  sch.sch_cha_number);
                  --<catchup scheduling CRs End>
                  END IF;
               END LOOP;
            ELSIF LICS.CON_PRIME_TIME_TYPE = 'PTDUR'
            THEN
               /**************************************************************************************/
               /*- GET THE DURATION IF THE RULE IS PTDUR FOR THE FOLLOWING:                          */
               /*- PRIME TIME TYPE 'PTDUR' WHERE A PROGRAMME THAT STARTS BETWEEN PRIME               */
               /*- TIME START AND END TIME IS CONSIDERED PRIME TIME, EXCEPT ON THE LAST MINUTE.      */
               /*- IF PROGRAMME START BEFORE START TIME AND RUN OVER BY 30 MINUTES OR MORE,          */
               /*-  IT IS A PRIME TIME RUN.                                                          */
               /**************************************************************************************/
               OPEN GET_DURA;

               FETCH GET_DURA INTO DURA;

               IF GET_DURA%NOTFOUND
               THEN
                  raise_application_error (-20002,
                                           'License/Programme Not found');
               ELSE
                  CLOSE GET_DURA;

                  IF NVL (DURA.GEN_DURATION, 0) = 0
                  THEN
                     V_DURA := 0;
                  ELSE
                     V_DURA := (DURA.GEN_DURATION / 25);
                  END IF;
               END IF;

               FOR SCH IN GET_SCH2
               LOOP
                  V_CNT := V_CNT + 1;

                  IF V_CNT > NVL (PT.MAX_RUNS, PT.TOT_MAX_RUNS)
                  THEN
                     V_VERIFICATION := 'N';
                     V_COMMENTS :=
                           'LICENSE '
                        || P_LIC_NUMBER
                        || ' '
                        || SUBSTR (LICS.SX1_GEN_TITLE, 1, 50)
                        || ' ON '
                        || SCH.CHA_SHORT_NAME
                        || ' ON '
                        || SCH.SCH_DATE
                        || ','
                        || SCH.CON_TIME
                        || ' EXCEEDS MAX PRIME TIME RUNS OF '
                        || NVL (pt.max_runs, pt.tot_max_runs);

                     --<catchup scheduling CRs -Mangesh gulhane 02-AUG-13 Lic field added >
                     INSERT INTO FID_WRN_SVR (WRN_PERIOD,
                                              WRN_CURR_DATE,
                                              wrn_comments,
                                              wrn_lic_number,
                                              wrn_cha_number)
                          VALUES (v_period,
                                  SYSDATE,
                                  v_comments,
                                  P_LIC_NUMBER,
                                  sch.sch_cha_number);
                  --<catchup scheduling CRs End>
                  END IF;
               END LOOP;
            END IF;
         END LOOP;

         IF LICS.CON_PRIME_TIME_PD_LIMIT = 'Y'
         THEN
            IF LICS.CON_PRIME_TIME_TYPE = 'PTIN'
            THEN
               FOR LIM IN GET_LIMIT1
               LOOP
                  V_VERIFICATION := 'N';
                  V_COMMENTS :=
                        P_LIC_NUMBER
                     || ' '
                     || SUBSTR (LICS.SX1_GEN_TITLE, 1, 50)
                     || ' ON '
                     || LIM.SCH_DATE
                     || ','
                     || 'EXCEEDS MORE THAN ONE RUN PER DAY PER SERVICE';

                  --<catchup scheduling CRs -Mangesh gulhane 02-AUG-13 Lic field added >
                  INSERT INTO fid_wrn_svr (wrn_period,
                                           wrn_curr_date,
                                           wrn_comments,
                                           wrn_lic_number,
                                           wrn_cha_number)
                       VALUES (v_period,
                               SYSDATE,
                               v_comments,
                               P_LIC_NUMBER,
                               LIM.sch_cha_number);
               --<catchup scheduling CRs End>
               END LOOP;
            ELSIF LICS.CON_PRIME_TIME_TYPE = 'PTDUR'
            THEN
               FOR LIM IN GET_LIMIT2
               LOOP
                  V_VERIFICATION := 'N';
                  V_COMMENTS :=
                        P_LIC_NUMBER
                     || ' '
                     || SUBSTR (LICS.SX1_GEN_TITLE, 1, 50)
                     || ' ON '
                     || LIM.SCH_DATE
                     || ','
                     || ' EXCEEDS MORE THAN ONE RUN PER DAY PER SERVICE';

                  --<catchup scheduling CRs -Mangesh gulhane 02-AUG-13 Lic field added >
                  INSERT INTO fid_wrn_svr (wrn_period,
                                           wrn_curr_date,
                                           wrn_comments,
                                           wrn_lic_number,
                                           wrn_cha_number)
                       VALUES (v_period,
                               SYSDATE,
                               v_comments,
                               P_LIC_NUMBER,
                               LIM.sch_cha_number);
               --<catchup scheduling CRs End>
               END LOOP;
            END IF;
         END IF;

        <<THATSIT>>
         NULL;
      END LOOP;

      C_VERIFICATION_3 := V_VERIFICATION;
   END;

   -- CATCHUP CHANGES BY ANIRUDHA ON 01-NOV-2012
   PROCEDURE PRC_CP_SCH_VERIFICATION (I_FROM_DATE   IN NUMBER,
                                      I_TO_DATE     IN NUMBER,
                                      I_USER_ID     IN VARCHAR2)
   IS
      L_TEMP_COSTED            NUMBER;
      L_CLOSE_MON_COSTED_RUN   NUMBER;
      L_REM_COSTED_RUNS        NUMBER;
      L_ALREDY_SCH_CNT         NUMBER;
      L_LIC_SHOWING_LIC        FID_LICENSE.LIC_SHOWING_LIC%TYPE;
      L_FROM_DATE              DATE;
      L_TO_DATE                DATE;
      l_lic_start              fid_license.lic_start%TYPE;
      l_lic_end                fid_license.lic_end%TYPE;
      l_5_2_go_live_date       DATE;
      l_alloc_costed_runs      x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
      l_sch_window             x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
      l_sw1_start              x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_sw1_end                x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_sw2_start              x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_sw2_end                x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_cw1_costed_runs        x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
   BEGIN
      -- FIND THE ALL CATCHUP SCHEDULE LICENSES BETWEEN L_FROM_DATE AND L_TO_DATE
      L_FROM_DATE := TO_DATE (I_FROM_DATE, 'YYYYMM');
      L_TO_DATE := LAST_DAY (TO_DATE (I_TO_DATE, 'YYYYMM'));

      SELECT content
        INTO l_5_2_go_live_date
        FROM x_fin_configs
       --where key ='COSTING_5+2_GO_LIVE_DATE'
       WHERE id = 6;

      FOR I
         IN (  SELECT A.PLT_LIC_NUMBER,
                      (SELECT MIN (C.PLT_SCH_START_DATE)
                         FROM X_CP_PLAY_LIST C
                        WHERE C.PLT_LIC_NUMBER = A.PLT_LIC_NUMBER
                              AND C.PLT_SCH_START_DATE BETWEEN L_FROM_DATE
                                                           AND L_TO_DATE)
                         START_DATE
                 FROM X_CP_PLAY_LIST A, FID_LICENSE B
                WHERE     A.PLT_LIC_NUMBER = B.LIC_NUMBER
                      AND B.LIC_CATCHUP_FLAG = 'Y'
                      AND PLT_SCH_START_DATE BETWEEN L_FROM_DATE AND L_TO_DATE
             GROUP BY A.PLT_LIC_NUMBER
             ORDER BY START_DATE)
      LOOP
         -- DBMS_OUTPUT.PUT_LINE ('LIC NO. ' || I.PLT_LIC_NUMBER);

         -- SELECT COUNT OF COSTED SCHEDULE WHICH IS SCHEDULE BEFORE L_FROM_DATE
         SELECT (SELECT COUNT (DISTINCT PLT_SCH_NUMBER)
                   FROM X_CP_PLAY_LIST
                  WHERE     PLT_SCH_TYPE = 'P'
                        AND PLT_SCH_START_DATE < L_FROM_DATE
                        AND PLT_LIC_NUMBER = AA.LIC_NUMBER)
                + DECODE (
                     'CRSA',
                     'CAFR', (SELECT COUNT (SCH_NUMBER)
                                FROM FID_SCHEDULE
                               WHERE     SCH_TYPE = 'P'
                                     AND SCH_DATE < L_FROM_DATE
                                     AND SCH_LIC_NUMBER = AA.LIC_NUMBER),
                     DECODE (
                        (SELECT COUNT (SCH_NUMBER)
                           FROM FID_SCHEDULE
                          WHERE     SCH_TYPE = 'P'
                                AND SCH_DATE < L_FROM_DATE
                                AND SCH_LIC_NUMBER = AA.LIC_NUMBER),
                        0, (SELECT COUNT (SCH_NUMBER)
                              FROM FID_SCHEDULE, FID_LICENSE
                             WHERE     SCH_TYPE = 'P'
                                   AND SCH_DATE < L_FROM_DATE
                                   AND SCH_LIC_NUMBER = LIC_NUMBER
                                   AND LIC_LEE_NUMBER = 319
                                   AND LIC_GEN_REFNO = AA.LIC_GEN_REFNO),
                        (SELECT COUNT (SCH_NUMBER)
                           FROM FID_SCHEDULE
                          WHERE     SCH_TYPE = 'P'
                                AND SCH_DATE < L_FROM_DATE
                                AND SCH_LIC_NUMBER = AA.LIC_NUMBER)))
                   NO_OF_VP_USED
           INTO L_CLOSE_MON_COSTED_RUN
           FROM FID_LICENSE AA, FID_LICENSEE AB
          WHERE AA.LIC_LEE_NUMBER = AB.LEE_NUMBER
                AND AA.LIC_NUMBER = I.PLT_LIC_NUMBER;

         SELECT LIC_SHOWING_LIC, lic_start, lic_end
           INTO L_LIC_SHOWING_LIC, l_lic_start, l_lic_end
           FROM FID_LICENSE
          WHERE LIC_NUMBER = I.PLT_LIC_NUMBER;

         L_REM_COSTED_RUNS := L_LIC_SHOWING_LIC - L_CLOSE_MON_COSTED_RUN;

         /*    DBMS_OUTPUT.PUT_LINE (
                   'L_REM_COSTED_RUNS '
                || L_REM_COSTED_RUNS
                || ' L_LIC_SHOWING_LIC '
                || L_LIC_SHOWING_LIC
                || ' L_CLOSE_MON_COSTED_RUN '
                || L_CLOSE_MON_COSTED_RUN); */

         IF L_REM_COSTED_RUNS = 0
         THEN
            -- IF REMANING COSTED RUN IS 0 THEN SET SCHEDULE TYPE 'N'
            FOR K
               IN (SELECT PLT_ID
                     FROM X_CP_PLAY_LIST
                    WHERE PLT_LIC_NUMBER = I.PLT_LIC_NUMBER
                          AND PLT_SCH_START_DATE BETWEEN L_FROM_DATE
                                                     AND L_TO_DATE)
            LOOP
               PRC_CP_INSERT_TEMP_SCH (K.PLT_ID, 'N');
            END LOOP;
         ELSE
            -- IF REMANING COSTED RUN GRETER THEN 0 THEN SET SCHEDULE TYPE 'P'
            L_TEMP_COSTED := 0;

            FOR J
               IN (  SELECT A.PLT_LIC_NUMBER,
                            A.PLT_SCH_NUMBER,
                            (SELECT MIN (B.PLT_SCH_START_DATE)
                               FROM X_CP_PLAY_LIST B
                              WHERE B.PLT_SCH_START_DATE BETWEEN L_FROM_DATE
                                                             AND L_TO_DATE
                                    AND B.PLT_SCH_NUMBER = A.PLT_SCH_NUMBER)
                               SCH_MIN_DATE
                       FROM X_CP_PLAY_LIST A, FID_LICENSE C
                      WHERE A.PLT_LIC_NUMBER = C.LIC_NUMBER
                            AND A.PLT_LIC_NUMBER = I.PLT_LIC_NUMBER
                            AND A.PLT_SCH_START_DATE BETWEEN L_FROM_DATE
                                                         AND L_TO_DATE
                   GROUP BY A.PLT_LIC_NUMBER, A.PLT_SCH_NUMBER
                   ORDER BY SCH_MIN_DATE)
            LOOP
               L_REM_COSTED_RUNS := L_LIC_SHOWING_LIC - L_CLOSE_MON_COSTED_RUN;

               IF TO_CHAR (l_lic_start, 'YYYYMMDD') >=
                     TO_CHAR (l_5_2_go_live_date, 'YYYYMMDD')
               THEN
                  prc_cost_rule_config_info (i.plt_lic_number,
                                             l_lic_start,
                                             l_lic_end,
                                             j.sch_min_date,
                                             l_lic_showing_lic,
                                             l_alloc_costed_runs,
                                             l_sch_window,
                                             l_sw1_start,
                                             l_sw1_end,
                                             l_sw2_start,
                                             l_sw2_end,
                                             l_cw1_costed_runs);

                  IF l_sch_window = 1
                     AND TO_CHAR (l_lic_start, 'YYYYMMDD') >=
                            TO_CHAR (l_5_2_go_live_date, 'YYYYMMDD')
                  THEN
                     L_REM_COSTED_RUNS :=
                        l_alloc_costed_runs - NVL (L_CLOSE_MON_COSTED_RUN, 0);
                  ELSE
                     L_REM_COSTED_RUNS :=
                        L_LIC_SHOWING_LIC - L_CLOSE_MON_COSTED_RUN;
                  END IF;
               END IF;

               IF L_REM_COSTED_RUNS > L_TEMP_COSTED
               THEN
                  SELECT COUNT (*)
                    INTO L_ALREDY_SCH_CNT
                    FROM X_CP_PLAY_LIST
                   WHERE     PLT_LIC_NUMBER = J.PLT_LIC_NUMBER
                         AND PLT_SCH_NUMBER = J.PLT_SCH_NUMBER
                         AND PLT_SCH_START_DATE < L_FROM_DATE;

                  --   DBMS_OUTPUT.PUT_LINE (
                  --    'L_ALREDY_SCH_CNT ' || L_ALREDY_SCH_CNT);

                  -- IF SAME LICENSE FOR SAME LENEAR SCHEDULE NO. BUT FOR DIFFRENT PLATFORM SCHEDULED BEFORE L_FROM_DATE
                  -- THEN SET SCHEDULE TYPE 'N' ELSE 'P'
                  IF L_ALREDY_SCH_CNT > 0
                  THEN
                     --   DBMS_OUTPUT.PUT_LINE (
                     --     'IN NOT PAID ' || J.PLT_SCH_NUMBER);

                     FOR L
                        IN (SELECT PLT_ID
                              FROM X_CP_PLAY_LIST
                             WHERE PLT_LIC_NUMBER = J.PLT_LIC_NUMBER
                                   AND PLT_SCH_NUMBER = J.PLT_SCH_NUMBER
                                   AND PLT_SCH_START_DATE BETWEEN L_FROM_DATE
                                                              AND L_TO_DATE)
                     LOOP
                        PRC_CP_INSERT_TEMP_SCH (L.PLT_ID, 'N');
                     END LOOP;
                  ELSE
                     --  DBMS_OUTPUT.PUT_LINE ('IN  PAID ' || J.PLT_SCH_NUMBER);

                     FOR L
                        IN (SELECT PLT_ID
                              FROM X_CP_PLAY_LIST
                             WHERE PLT_LIC_NUMBER = J.PLT_LIC_NUMBER
                                   AND PLT_SCH_NUMBER = J.PLT_SCH_NUMBER
                                   AND PLT_SCH_START_DATE BETWEEN L_FROM_DATE
                                                              AND L_TO_DATE)
                     LOOP
                        --DBMS_OUTPUT.PUT_LINE('L.PLT_ID '||L.PLT_ID||' L_TEMP_COSTED '||L_TEMP_COSTED);
                        PRC_CP_INSERT_TEMP_SCH (L.PLT_ID, 'P');
                     END LOOP;

                     --DBMS_OUTPUT.PUT_LINE(' L_TEMP_COSTED '||L_TEMP_COSTED);
                     L_TEMP_COSTED := L_TEMP_COSTED + 1;
                  END IF;
               ELSE
                  FOR L
                     IN (SELECT PLT_ID
                           FROM X_CP_PLAY_LIST
                          WHERE PLT_LIC_NUMBER = J.PLT_LIC_NUMBER
                                AND PLT_SCH_NUMBER = J.PLT_SCH_NUMBER
                                AND PLT_SCH_START_DATE BETWEEN L_FROM_DATE
                                                           AND L_TO_DATE)
                  LOOP
                     /*  DBMS_OUTPUT.PUT_LINE (
                             'L.PLT_ID '
                          || L.PLT_ID
                          || ' L_TEMP_COSTED '
                          || L_TEMP_COSTED); */

                     PRC_CP_INSERT_TEMP_SCH (L.PLT_ID, 'N');
                  END LOOP;
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      FOR N
         IN (SELECT TEMP_PLT_ID, TEMP_PLT_SCH_TYPE FROM X_CP_TEMP_SCHEDULE)
      LOOP
         UPDATE X_CP_PLAY_LIST
            SET PLT_SCH_TYPE = N.TEMP_PLT_SCH_TYPE,
                PLT_MODIFIED_BY = I_USER_ID,
                PLT_MODIFIED_ON = TRIM (SYSDATE)
          WHERE PLT_ID = N.TEMP_PLT_ID;
      END LOOP;

      COMMIT;
   --    EXCEPTION
   --    WHEN OTHERS
   --    THEN

   --    RAISE_APPLICATION_ERROR(-20332,'ERROR WHILE SELECTING DATA.'||SQLERRM);
   END PRC_CP_SCH_VERIFICATION;

   PROCEDURE PRC_CP_INSERT_TEMP_SCH (
      I_PLT_ID         IN X_CP_PLAY_LIST.PLT_ID%TYPE,
      I_PLT_SCH_TYPE   IN X_CP_PLAY_LIST.PLT_SCH_TYPE%TYPE)
   IS
   BEGIN
      INSERT INTO X_CP_TEMP_SCHEDULE (TEMP_PLT_ID, TEMP_PLT_SCH_TYPE)
           VALUES (I_PLT_ID, I_PLT_SCH_TYPE);
   END PRC_CP_INSERT_TEMP_SCH;

   -- END CATCHUP CHANGES

   --PURE FINANCE BIOSCOPE/NON BIOSCOPE  CHANGES [MANGESH_GULHANE][2013-02-25]
   PROCEDURE PRC_FIN_SCH_VEREX (I_CURR_YEAR        IN NUMBER,
                                I_CURR_MONTH       IN NUMBER,
                                I_PREVIOUS_YEAR    IN NUMBER,
                                I_PREVIOUS_MONTH   IN NUMBER,
                                I_SPLIT_REGION     IN VARCHAR2)
   IS
      FIN_GO_LIVE                      DATE;
      C_NO_COST_PREV_MNT_SUB_LED       NUMBER;
      C_NO_OF_PAID_SCHEDULES           NUMBER;
      C_IS_BIOSCOPE_LEE                NUMBER;
      C_NO_OF_COSTED_IND               NUMBER;
      C_NO_OF_COSTED_PREV_IND          NUMBER;
      C_NO_LIC_SCH_PREV_MTH            NUMBER;
      C_NO_LIC_SCH_PREV_SW2_STR        NUMBER;
      C_COSTED_RUNS_ON_SW              NUMBER;
      C_TOTAL_RUNS                     NUMBER;
      C_TOTAL_COST_RUNS_REMAIN         NUMBER;
      C_NO_LIC_SCH_BW_SW2_LDPREV_MNT   NUMBER;
      C_FREE_RPT                       NUMBER;
      C_RPT_PERIOD                     DATE;
      C_SCH_IN_RPT_PERIOD              NUMBER;
      C_NO_FREE_SCH                    NUMBER;
      C_SCH_DATE                       DATE;
      C_SCH_TIME                       NUMBER;

      --PURE FINANCE:[FOR BIOSCOPE AND NON BIOSCOPE CHANGES][MANGESH GULHANE][2013-02-25]

      --GET ALL THE LICENSES SCHEDULE IN THE CURRENT MONTH
      --SCH_FIN_ACTUAL_DATE:-IF THE SCHEDULE TIME IS BETWEEN 0 AND CHANNEL START TIME THEN
      --SCH_FIN_ACTUAL_DATE=SCH_DATE+1 ELSE IT WILL BE THE SAME AS SCH_DATE

      CURSOR SCH_LIC
      IS
           SELECT DISTINCT SCH_LIC_NUMBER, LIC_SHOWING_LIC, LIC_AMORT_CODE
             FROM FID_SCHEDULE,
                  FID_LICENSE,
                  FID_REGION --PURE FINANCE:[FOR BIOSCOPE/NON BIOSCOPE AND AFR-RSA CHANGES][MANGESH GULHANE][2013-02-25]
                            ,
                  FID_LICENSEE                              --PURE FINANCE END
            WHERE SCH_LIC_NUMBER = LIC_NUMBER
                  AND SCH_FIN_ACTUAL_DATE BETWEEN TO_DATE (
                                                     '01'
                                                     || LPAD (
                                                           TO_CHAR (
                                                              I_CURR_MONTH),
                                                           2,
                                                           '0')
                                                     || I_CURR_YEAR,
                                                     'DDMMYYYY')
                                              AND LAST_DAY (
                                                     TO_DATE (
                                                        '01'
                                                        || LPAD (
                                                              TO_CHAR (
                                                                 I_CURR_MONTH),
                                                              2,
                                                              '0')
                                                        || I_CURR_YEAR,
                                                        'DDMMYYYY'))
                  AND UPPER (LIC_AMORT_CODE) IN ('D', 'E','F')				--ver 1.1 added F
                  AND LIC_LEE_NUMBER = LEE_NUMBER
                  AND LEE_SPLIT_REGION = REG_ID(+)
                  --PURE FINANCE:[FOR BIOSCOPE/NON BIOSCOPE AND NCF deal CHANGES][MANGESH GULHANE][2013-02-25]
                  AND UPPER (LIC_STATUS) NOT IN ('F', 'T')          -- T Added
                  --PURE FINANCE END
                  AND LIC_START >= (SELECT TO_DATE (CONTENT, 'DD-MON-YYYY')
                                      FROM X_FIN_CONFIGS
                                     WHERE KEY LIKE 'GO-LIVEDATE') --GO_LIVE_DATE
                  AND LIC_START < (SELECT TO_DATE (CONTENT, 'DD-MON-YYYY')
                                     FROM X_FIN_CONFIGS
                                    WHERE --KEY LIKE 'COSTING_5+2_GO_LIVE_DATE'
                                         id = 6)         -- 5_+_2_GO_LIVE_DATE
                  AND UPPER (NVL (REG_CODE, '#')) LIKE
                         UPPER (NVL (I_SPLIT_REGION, '#'))
                  --AND lic_CON_NUMBER = 65070
                  --and LIC_NUMBER = 1108531
          --and sch_lic_number = 1090316
         -- and lic_number=637915
         ORDER BY SCH_LIC_NUMBER;


      -- GET EACH SCHEDULE OF LICENSE DURING ROUTINE PERIOD
      CURSOR SCH_PER_LIC (
         L_SCH_LIC_NUMBER NUMBER)
      IS
           SELECT SCH_LIC_NUMBER,
                  SCH_CHA_NUMBER,
                  SCH_FIN_ACTUAL_DATE,
                  SCH_TIME,
                  LCR_SCH_START_DATE2,
                  SCH_NUMBER,
                  LCR_COST_IND,
                  LIC_AMORT_CODE,
                  LCR_CHA_COSTED_RUNS,
                  LCR_CHA_COSTED_RUNS2,
                  LIC_FREE_RPT,
                  LIC_RPT_PERIOD,
                  CHA_SCH_START_TIME
             FROM FID_SCHEDULE,
                  FID_LICENSE_CHANNEL_RUNS,
                  FID_LICENSE,
                  FID_CHANNEL
            WHERE     SCH_LIC_NUMBER = LCR_LIC_NUMBER
                  AND LCR_LIC_NUMBER = LIC_NUMBER
                  AND SCH_CHA_NUMBER = LCR_CHA_NUMBER
                  AND LCR_CHA_NUMBER = CHA_NUMBER
                  AND SCH_FIN_ACTUAL_DATE BETWEEN TO_DATE (
                                                     '01'
                                                     || LPAD (
                                                           TO_CHAR (
                                                              I_CURR_MONTH),
                                                           2,
                                                           '0')
                                                     || I_CURR_YEAR,
                                                     'DDMMYYYY')
                                              AND LAST_DAY (
                                                     TO_DATE (
                                                        '01'
                                                        || LPAD (
                                                              TO_CHAR (
                                                                 I_CURR_MONTH),
                                                              2,
                                                              '0')
                                                        || I_CURR_YEAR,
                                                        'DDMMYYYY'))
                  AND SCH_LIC_NUMBER = L_SCH_LIC_NUMBER
         ORDER BY SCH_FIN_ACTUAL_DATE, SCH_TIME, SCH_NUMBER;

      --GET THE COSTED TICK CHANNEL FOR EACH LICENSE
      CURSOR COST_IND_PER_LIC (
         L_SCH_LIC_NUMBER NUMBER)
      IS
         SELECT *
           FROM FID_LICENSE_CHANNEL_RUNS
          WHERE LCR_LIC_NUMBER = L_SCH_LIC_NUMBER
                AND UPPER (LCR_COST_IND) = 'Y';
   --PURE FINANCE:END
   BEGIN
      /*-------------------------------------------------------------------------------*/
      /*- CHANGES PURE FINANCE NON BIOSCOPE LICENSE [MANGESH GULHANE][2013-02-25]
      /*-------------------------------------------------------------------------------*/

      FOR SCH_LIC_R IN SCH_LIC
      LOOP
         C_TOTAL_RUNS := 0;
         c_total_cost_runs_remain := 0;
         C_NO_OF_COSTED_PREV_IND := 0;



         /*SELECT NVL (SUM (LIS_PAID_EXHIBITION), 0)
         INTO C_NO_COST_PREV_MNT_SUB_LED
         FROM FID_LICENSE_SUB_LEDGER
         WHERE LIS_LIC_NUMBER = SCH_LIC_R.SCH_LIC_NUMBER
         and concat (lis_per_year, lpad (lis_per_month, 2, 0)) <=
         CONCAT (I_PREVIOUS_YEAR, LPAD (I_PREVIOUS_MONTH, 2, 0));*/

         --GET THE NO OF COSTED RUNS FROM SUBLEDGER TILL PREV MONTH at license level
         SELECT NVL (SUM (lis_paid_exhibition), 0)
           INTO c_no_cost_prev_mnt_sub_led
           FROM (SELECT DISTINCT lis_paid_exhibition,
                                 lis_per_month,
                                 lis_per_year,
                                 lis_lic_number
                   FROM fid_license_sub_ledger
                  WHERE lis_lic_number = SCH_LIC_R.SCH_LIC_NUMBER
                        AND lis_paid_exhibition <> 0
                        AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                               CONCAT (I_PREVIOUS_YEAR,
                                       LPAD (I_PREVIOUS_MONTH, 2, 0)));

         --IF NUMBER OF COSTED RUNS TILL PREV MONTH LESS THAN NO OF RUNS ON WHICH IT SHOULD BE COSTED
         --AT LICENSE LEVEL ELSE UPDATE SCH_TYPE AS 'N'OR 'F' FOR ALL THE SCHEDULES IN ROUTINE MONTH

         IF C_NO_COST_PREV_MNT_SUB_LED < SCH_LIC_R.LIC_SHOWING_LIC       --(1)
         THEN
            --GET NO OF PAID SCHEDULES TILL PREVIOUS MONTH OF ROUTINE MONTH
            SELECT COUNT (*)
              INTO C_NO_OF_PAID_SCHEDULES
              FROM FID_SCHEDULE
             WHERE SCH_LIC_NUMBER = SCH_LIC_R.SCH_LIC_NUMBER
                   AND SCH_FIN_ACTUAL_DATE <
                          TO_DATE (
                                '01'
                             || LPAD (TO_CHAR (I_CURR_MONTH), 2, '0')
                             || I_CURR_YEAR,
                             'DDMMYYYY')
                   AND UPPER (SCH_TYPE) IN ('P');

            --CHECK IF THERE ARE RUNS TO BE COSTED REMAINING AT LICENSE LEVEL
            IF (C_NO_OF_PAID_SCHEDULES < SCH_LIC_R.LIC_SHOWING_LIC)      --(2)
            THEN
               --CHECK FOR BIOSCOPE LICENSE
               --A LICENSE TO BE BIOSCOPE IT SHOULD HAVE 1)PGM_TYPE IN 'FEA','TV','LIB'
               --2)LEE_BIOSCOPE_FLAG='Y'
               --3)AMORT_CODE='D'

               SELECT COUNT (*)
                 INTO C_IS_BIOSCOPE_LEE
                 FROM FID_LICENSE
                WHERE LIC_LEE_NUMBER IN (SELECT LEE_NUMBER
                                           FROM FID_LICENSEE
                                          WHERE NVL (
                                                   UPPER (
                                                      LEE_BIOSCOPE_FLAG),
                                                   'N') = 'Y')
                      --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                      --LICENSES WITH AMORT CODE E WILL BE NON BIOSCOPE IRRESEPECTIVE OF
                      --BIOSCOPE LICENSEE AND BUDGET CODE
                      AND UPPER (LIC_AMORT_CODE) LIKE ('D')
                      --END  AFRICA FREE REPEAT
                      AND UPPER (LIC_BUDGET_CODE) IN
                             (SELECT UPPER (CPT_GEN_TYPE)
                                FROM SGY_PB_COSTED_PROG_TYPE)
                      AND LIC_NUMBER = SCH_LIC_R.SCH_LIC_NUMBER;

               --TO CHECK IF LICENSE IS BIOSCOPE OR NON-BIOSCOPE
               IF C_IS_BIOSCOPE_LEE != 1
               THEN                                                      --(3)
                  --GET THE NO OF SCHEDULES ON COSTED TICKED CHANNELS TILL PREV MONTH
                  SELECT COUNT (*)
                    INTO C_NO_OF_COSTED_IND
                    FROM FID_SCHEDULE, FID_LICENSE_CHANNEL_RUNS
                   WHERE     SCH_LIC_NUMBER = LCR_LIC_NUMBER
                         AND SCH_CHA_NUMBER = LCR_CHA_NUMBER
                         AND UPPER (LCR_COST_IND) = 'Y'
                         --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                         --TO EXCLUDE FREE RUNS FROM SCHEDULES
                         AND UPPER (SCH_TYPE) IN ('P', 'N')
                         --END  AFRICA FREE REPEAT
                         AND SCH_FIN_ACTUAL_DATE <
                                TO_DATE (
                                      '01'
                                   || LPAD (TO_CHAR (I_CURR_MONTH), 2, '0')
                                   || I_CURR_YEAR,
                                   'DDMMYYYY')
                         AND SCH_LIC_NUMBER = SCH_LIC_R.SCH_LIC_NUMBER;

                  --CHECK IF THERE ARE RUNS TO BE COSTED REMAINING AT LICENSE LEVEL
                  IF C_NO_OF_COSTED_IND < SCH_LIC_R.LIC_SHOWING_LIC      --(4)
                  THEN
                     --LOOP FOR EACH SCHEDULE OF LICENSE DURING ROUTINE MONTH
                     FOR SCH_PER_LIC_R
                        IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
                     LOOP
                        --CHECK IF SCHEDULE IS ON COSTED TICK CHANNEL
                        --ELSE UPDATE SCH_TYPE AS 'N' FOR AMORT CODE 'D'
                        --OR UPDATE SCH_TYPE AS 'N' OR 'F' FOR AMORT CODE 'E'
                        IF UPPER (SCH_PER_LIC_R.LCR_COST_IND) = 'Y'      --(5)
                        THEN
                           --GET NO OF SCHEDULES ON COSTED TICKED CHANNELS PRIOR TO SCH_DATE,SCH_TIME,SCH_NUMBER
                           SELECT SUM (A)
                             INTO C_NO_OF_COSTED_PREV_IND
                             FROM (SELECT COUNT (*) A
                                     FROM FID_SCHEDULE, FID_CHANNEL
                                    WHERE SCH_CHA_NUMBER = CHA_NUMBER
                                          AND SCH_LIC_NUMBER =
                                                 SCH_LIC_R.SCH_LIC_NUMBER
                                          --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                                          --TO EXCLUDE FREE RUNS FROM SCHEDULES
                                          AND UPPER (SCH_TYPE) IN ('P', 'N')
                                          --END  AFRICA FREE REPEAT
                                          AND TO_DATE ( TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY') || ' '							--Ver 1.1 added to_char to avoid date culture problem
                                                 || CONVERT_TIME_N_C (
                                                       SCH_TIME),
                                                 'DD-MON-YY HH24:MI:SS') <
                                                 TO_DATE (
                                                    TO_CHAR(SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')					    --Ver 1.1 added to_char
                                                    || ' '
                                                    || CONVERT_TIME_N_C (
                                                          SCH_PER_LIC_R.SCH_TIME),
                                                    'DD-MON-YY HH24:MI:SS')
                                          AND SCH_CHA_NUMBER IN
                                                 (SELECT LCR_CHA_NUMBER
                                                    FROM FID_LICENSE_CHANNEL_RUNS
                                                   WHERE LCR_LIC_NUMBER =
                                                            SCH_LIC_R.SCH_LIC_NUMBER
                                                         AND UPPER (
                                                                LCR_COST_IND) =
                                                                UPPER ('Y'))
                                   UNION
                                   --GET THE SCHEDULES AT SAME SCHDULE DATE AND SCHEDULE TIME
                                   --BUT ON DIFFERENT CHANNEL
                                   SELECT COUNT (*) A
                                     FROM FID_SCHEDULE, FID_CHANNEL
                                    WHERE SCH_CHA_NUMBER = CHA_NUMBER
                                          AND SCH_LIC_NUMBER =
                                                 SCH_LIC_R.SCH_LIC_NUMBER
                                          --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                                          --TO EXCLUDE FREE RUNS FROM SCHEDULES
                                          AND UPPER (SCH_TYPE) IN ('P', 'N')
                                          --END  AFRICA FREE REPEAT
                                          AND TO_DATE (
                                                 TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY') || ' '						--Ver 1.1 added to_char
                                                 || CONVERT_TIME_N_C (
                                                       SCH_TIME),
                                                 'DD-MON-YY HH24:MI:SS') =
                                                 TO_DATE (
                                                    TO_CHAR(SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')							--Ver 1.1 Added
                                                    || ' '
                                                    || CONVERT_TIME_N_C (
                                                          SCH_PER_LIC_R.SCH_TIME),
                                                    'DD-MON-YY HH24:MI:SS')
                                          AND SCH_NUMBER <
                                                 SCH_PER_LIC_R.SCH_NUMBER
                                          AND SCH_CHA_NUMBER IN
                                                 (SELECT LCR_CHA_NUMBER
                                                    FROM FID_LICENSE_CHANNEL_RUNS
                                                   WHERE LCR_LIC_NUMBER =
                                                            SCH_LIC_R.SCH_LIC_NUMBER
                                                         AND UPPER (
                                                                LCR_COST_IND) =
                                                                UPPER ('Y')));


                           --CHECK IF THERE ARE RUNS TO BE COSTED REMAINING AT LICENSE LEVEL
                           IF C_NO_OF_COSTED_PREV_IND <
                                 SCH_LIC_R.LIC_SHOWING_LIC
                           THEN
                              --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                              --TO INCLUDE FREE RUNS IN SCHEDULES
                              IF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'E' --AFC1
                              THEN
                                 --UPDATE SCH_TYPE WITH 'P' OR 'F'
                                 PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                                    SCH_PER_LIC_R.SCH_NUMBER,
                                    SCH_PER_LIC_R.SCH_LIC_NUMBER,
                                    SCH_PER_LIC_R.SCH_CHA_NUMBER,
                                    SCH_PER_LIC_R.CHA_SCH_START_TIME,
                                    SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                                    SCH_PER_LIC_R.SCH_TIME,
                                    SCH_PER_LIC_R.LIC_FREE_RPT,
                                    SCH_PER_LIC_R.LIC_RPT_PERIOD,
                                    'P');
                              --END  AFRICA FREE REPEAT
							  --ver 1.1 start
							  ELSIF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'F'
							  THEN
								  PRC_FIN_UPD_OMNIBUS_SCH(
											SCH_PER_LIC_R.SCH_NUMBER,
											SCH_PER_LIC_R.SCH_LIC_NUMBER,
											SCH_PER_LIC_R.SCH_CHA_NUMBER,
											SCH_PER_LIC_R.CHA_SCH_START_TIME,
											SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
											SCH_PER_LIC_R.SCH_TIME,
											SCH_PER_LIC_R.LIC_FREE_RPT,
											SCH_PER_LIC_R.LIC_RPT_PERIOD,
											'P');
							  --ver 1.1 end
                              ELSE
                                 --NON BIOSCOPE WITH AMORT CODE D
                                 --UPDATE SCH_TYPE WITH 'P'
                                 PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                                    I_CURR_YEAR,
                                    I_CURR_MONTH,
                                    SCH_PER_LIC_R.SCH_NUMBER,
                                    'P');
                              END IF;
                           --AFC1
                           ELSE
                              --NO RUNS REMAIN AT LICENSE LEVEL TO BE COSTED
                              --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                              --TO INCLUDE FREE RUNS IN SCHEDULES

                              IF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'E'
                              THEN
                                 PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                                    SCH_PER_LIC_R.SCH_NUMBER,
                                    SCH_PER_LIC_R.SCH_LIC_NUMBER,
                                    SCH_PER_LIC_R.SCH_CHA_NUMBER,
                                    SCH_PER_LIC_R.CHA_SCH_START_TIME,
                                    SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                                    SCH_PER_LIC_R.SCH_TIME,
                                    SCH_PER_LIC_R.LIC_FREE_RPT,
                                    SCH_PER_LIC_R.LIC_RPT_PERIOD,
                                    'N');
                              --END  AFRICA FREE REPEAT
							  --ver 1.1 start
							  ELSIF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'F'
							  THEN
								  PRC_FIN_UPD_OMNIBUS_SCH(
											SCH_PER_LIC_R.SCH_NUMBER,
											SCH_PER_LIC_R.SCH_LIC_NUMBER,
											SCH_PER_LIC_R.SCH_CHA_NUMBER,
											SCH_PER_LIC_R.CHA_SCH_START_TIME,
											SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
											SCH_PER_LIC_R.SCH_TIME,
											SCH_PER_LIC_R.LIC_FREE_RPT,
											SCH_PER_LIC_R.LIC_RPT_PERIOD,
											'N');
							  --ver 1.1 end
                              ELSE
                                 PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                                    I_CURR_YEAR,
                                    I_CURR_MONTH,
                                    SCH_PER_LIC_R.SCH_NUMBER,
                                    'DN');
                              END IF;
                           END IF;
                        ELSE
                           --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                           --TO INCLUDE FREE RUNS IN SCHEDULES
                           IF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'E'
                           THEN
                              PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                                 SCH_PER_LIC_R.SCH_NUMBER,
                                 SCH_PER_LIC_R.SCH_LIC_NUMBER,
                                 SCH_PER_LIC_R.SCH_CHA_NUMBER,
                                 SCH_PER_LIC_R.CHA_SCH_START_TIME,
                                 SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                                 SCH_PER_LIC_R.SCH_TIME,
                                 SCH_PER_LIC_R.LIC_FREE_RPT,
                                 SCH_PER_LIC_R.LIC_RPT_PERIOD,
                                 'N');
                           --END  AFRICA FREE REPEAT
						   --ver 1.1 start
							  ELSIF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'F'
							  THEN
								  PRC_FIN_UPD_OMNIBUS_SCH(
											SCH_PER_LIC_R.SCH_NUMBER,
											SCH_PER_LIC_R.SCH_LIC_NUMBER,
											SCH_PER_LIC_R.SCH_CHA_NUMBER,
											SCH_PER_LIC_R.CHA_SCH_START_TIME,
											SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
											SCH_PER_LIC_R.SCH_TIME,
											SCH_PER_LIC_R.LIC_FREE_RPT,
											SCH_PER_LIC_R.LIC_RPT_PERIOD,
											'N');
							  --ver 1.1 end
                           ELSE
                              PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                                 I_CURR_YEAR,
                                 I_CURR_MONTH,
                                 SCH_PER_LIC_R.SCH_NUMBER,
                                 'DN');
                           END IF;
                        END IF;                                          --(5)
                     END LOOP;
                  ELSE
                     --  DBMS_OUTPUT.PUT_LINE ('BLOCK A');

                     --UPDATE SCH_TYPE=N ALL LICENSES OF CURRENT ROUTINE MONTH
                     --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                     --TO INCLUDE FREE RUNS IN SCHEDULES
           IF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'E'
           THEN
              FOR SCH_PER_LIC_R
                 IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
              LOOP
                 PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                    SCH_PER_LIC_R.SCH_NUMBER,
                    SCH_PER_LIC_R.SCH_LIC_NUMBER,
                    SCH_PER_LIC_R.SCH_CHA_NUMBER,
                    SCH_PER_LIC_R.CHA_SCH_START_TIME,
                    SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                    SCH_PER_LIC_R.SCH_TIME,
                    SCH_PER_LIC_R.LIC_FREE_RPT,
                    SCH_PER_LIC_R.LIC_RPT_PERIOD,
                    'N');
              END LOOP;
           --END  AFRICA FREE REPEAT
					 --ver 1.1 start
					  ELSIF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'F'
					  THEN
					    FOR SCH_PER_LIC_R
                           IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
                        LOOP
						  PRC_FIN_UPD_OMNIBUS_SCH(
									SCH_PER_LIC_R.SCH_NUMBER,
									SCH_PER_LIC_R.SCH_LIC_NUMBER,
									SCH_PER_LIC_R.SCH_CHA_NUMBER,
									SCH_PER_LIC_R.CHA_SCH_START_TIME,
									SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
									SCH_PER_LIC_R.SCH_TIME,
									SCH_PER_LIC_R.LIC_FREE_RPT,
									SCH_PER_LIC_R.LIC_RPT_PERIOD,
									'N');
						END LOOP;
					  --ver 1.1 end
                     ELSE
                        PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                           I_CURR_YEAR,
                           I_CURR_MONTH,
                           SCH_LIC_R.SCH_LIC_NUMBER,
                           'AN');
                     END IF;
                  END IF;                                                --(4)
               ELSE
                  /*-------------------------------------------------------------------------------*/
                  /*- CHANGES PURE FINANCE  BIOSCOPE LICENSE [MANGESH GULHANE][2013-02-25]
                  /*-------------------------------------------------------------------------------*/
                  --LOOP FOR EACH OF COSTED TICKED CHANNEL FOR A LICENSE
                  FOR COST_IND IN COST_IND_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
                  LOOP
                     --DECIDE THE SCHDULEING WINDOW FOR THE CURRENT ROUTINE
                     --PERIOD
                     IF COST_IND.LCR_SCH_START_DATE2 IS NULL
                        OR COST_IND.LCR_SCH_START_DATE2 >
                              TO_DATE (
                                    '01'
                                 || LPAD (TO_CHAR (I_CURR_MONTH), 2, '0')
                                 || I_CURR_YEAR,
                                 'DDMMYYYY')
                     THEN
                        --GET NO OF LIC SCHEDULE ON CHANNEL TILL PREV MONTH

                        SELECT COUNT (*)
                          INTO C_NO_LIC_SCH_PREV_MTH
                          FROM FID_SCHEDULE
                         WHERE SCH_LIC_NUMBER = SCH_LIC_R.SCH_LIC_NUMBER
                               AND SCH_CHA_NUMBER = COST_IND.LCR_CHA_NUMBER
                               AND SCH_FIN_ACTUAL_DATE <
                                      TO_DATE (
                                         '01'
                                         || LPAD (TO_CHAR (I_CURR_MONTH),
                                                  2,
                                                  '0')
                                         || I_CURR_YEAR,
                                         'DDMMYYYY');
                     ELSE
                        --GET NO OF LIC SCHEDULE ON CHANNEL PRIOR TO SCH SW2 START DATE
                        SELECT COUNT (*)
                          INTO C_NO_LIC_SCH_PREV_MTH
                          FROM FID_SCHEDULE
                         WHERE SCH_LIC_NUMBER = SCH_LIC_R.SCH_LIC_NUMBER
                               AND SCH_CHA_NUMBER = COST_IND.LCR_CHA_NUMBER
                               AND SCH_FIN_ACTUAL_DATE <
                                      COST_IND.LCR_SCH_START_DATE2;
                     END IF;

                     --COMPARING schedules of prev month WITH COSTED RUNS SPECIFIED
                     --FOR CHANNEL SCHEDULING WINDOW 1
                     IF C_NO_LIC_SCH_PREV_MTH > COST_IND.LCR_CHA_COSTED_RUNS
                     THEN
                        C_TOTAL_RUNS :=
                           C_TOTAL_RUNS + COST_IND.LCR_CHA_COSTED_RUNS;
                     ELSE
                        --ADD NO OF LIC SCH ON CHANNEL TO TOTAL COSTED RUNS USED
                        C_TOTAL_RUNS := C_TOTAL_RUNS + C_NO_LIC_SCH_PREV_MTH;
                     END IF;

                     IF COST_IND.LCR_SCH_START_DATE2 <
                           TO_DATE (
                                 '01'
                              || LPAD (TO_CHAR (I_CURR_MONTH), 2, '0')
                              || I_CURR_YEAR,
                              'DDMMYYYY')                                  --6
                     THEN
                        --GET THE NUMBER OF LIC SCH ON CHN BTW SCHEDULING WIN2 START DATE AND LAST DAY OF
                        --PREV MONTH OF ROUTINE MONTH
                        SELECT COUNT (*)
                          INTO C_NO_LIC_SCH_BW_SW2_LDPREV_MNT
                          FROM FID_SCHEDULE
                         WHERE SCH_LIC_NUMBER = SCH_LIC_R.SCH_LIC_NUMBER
                               AND SCH_CHA_NUMBER = COST_IND.LCR_CHA_NUMBER
                               AND SCH_FIN_ACTUAL_DATE BETWEEN COST_IND.LCR_SCH_START_DATE2
                                                           AND LAST_DAY (
                                                                  TO_DATE (
                                                                     '01'
                                                                     || LPAD (
                                                                           TO_CHAR (
                                                                              I_PREVIOUS_MONTH),
                                                                           2,
                                                                           '0')
                                                                     || I_PREVIOUS_YEAR,
                                                                     'DDMMYYYY'));

                        IF C_NO_LIC_SCH_BW_SW2_LDPREV_MNT >
                              COST_IND.LCR_CHA_COSTED_RUNS2
                        THEN
                           C_TOTAL_RUNS :=
                              C_TOTAL_RUNS + COST_IND.LCR_CHA_COSTED_RUNS2;
                        ELSE
                           C_TOTAL_RUNS :=
                              C_TOTAL_RUNS + C_NO_LIC_SCH_BW_SW2_LDPREV_MNT;
                        END IF;
                     END IF;                                               --6
                  END LOOP;

                  --  DBMS_OUTPUT.put_line ('C_TOTAL_RUNS-' || c_total_runs);
                  --   DBMS_OUTPUT.put_line (
                  --      ' SCH_LIC_R.LIC_SHOWING_LIC -'
                  --      || SCH_LIC_R.LIC_SHOWING_LIC);

                  IF C_TOTAL_RUNS < SCH_LIC_R.LIC_SHOWING_LIC             --A1
                  THEN
                     --GET THE NUMBER OF RUNS REMAINING AT LICENSE LEVEL
                     C_TOTAL_COST_RUNS_REMAIN :=
                        SCH_LIC_R.LIC_SHOWING_LIC - C_TOTAL_RUNS;

                     --LOOP FOR EACH SCHEDULE OF LIC DURING THE ROUTINE PERIOD
                     FOR PER_LIC IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
                     LOOP
                        IF C_TOTAL_COST_RUNS_REMAIN > 0                    --7
                        THEN
                           IF UPPER (PER_LIC.LCR_COST_IND) = 'Y'          ---8
                           THEN
                              IF PER_LIC.LCR_SCH_START_DATE2 IS NULL
                                 OR PER_LIC.SCH_FIN_ACTUAL_DATE <
                                       PER_LIC.LCR_SCH_START_DATE2         --9
                              THEN
                                 /*    DBMS_OUTPUT.put_line (
                                        'sch number-' || PER_LIC.SCH_NUMBER); */
                                 /*    DBMS_OUTPUT.put_line (
                                           'in sch wind 1-'
                                        || PER_LIC.LCR_CHA_COSTED_RUNS
                                        || '-PER_LIC.SCH_CHA_NUMBER'); */
                                 --COSTED RUNS ON SCH WINDOW 1
                                 C_COSTED_RUNS_ON_SW :=
                                    PER_LIC.LCR_CHA_COSTED_RUNS;

                                 --GET THE NO. OF LIC. SCHEDULES ON CHANNEL PRIOR TO SCHEDULE FOR WHICH
                                 --THE LOOP IS RUNNING (SCH_DATE (<), SCH_TIME (<)).
                                 SELECT SUM (A)
                                   INTO C_NO_OF_COSTED_PREV_IND
                                   FROM (SELECT COUNT (*) A
                                           FROM FID_SCHEDULE
                                          WHERE SCH_LIC_NUMBER =
                                                   PER_LIC.SCH_LIC_NUMBER
                                                AND TO_DATE (
                                                       TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')						--Ver 1.1 Added to_char
                                                       || ' '
                                                       || CONVERT_TIME_N_C (
                                                             SCH_TIME),
                                                       'DD-MON-YY HH24:MI:SS') <
                                                       TO_DATE (
                                                          TO_CHAR(PER_LIC.SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')			--Ver 1.1 Added to_char
                                                          || ' '
                                                          || CONVERT_TIME_N_C (
                                                                PER_LIC.SCH_TIME),
                                                          'DD-MON-YY HH24:MI:SS')
                                                AND SCH_CHA_NUMBER =
                                                       PER_LIC.SCH_CHA_NUMBER
                                         UNION
                                         --ALSO GET THE NO. OF SCHEDULES ON CHANNEL , SCHEDULED AT SAME DATE AND
                                         --TIME FOR WHICH THE LOOP IS RUNNING (SCH_DATE (=), SCH_TIME (=), SCH_NUMBER (<) AND
                                         --ADD IT TO NO. OF SCHEDULES GOT EARLIER IN THIS BLOCK
                                         SELECT COUNT (*) A
                                           FROM fid_schedule
                                          WHERE SCH_LIC_NUMBER =
                                                   PER_LIC.SCH_LIC_NUMBER
                                                AND TO_DATE (
                                                       TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')						--Ver 1.1 Added to_char
                                                       || ' '
                                                       || CONVERT_TIME_N_C (
                                                             SCH_TIME),
                                                       'DD-MON-YY HH24:MI:SS') =
                                                       TO_DATE (
                                                          TO_CHAR(PER_LIC.SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')			--Ver 1.1 Added to_char
                                                          || ' '
                                                          || CONVERT_TIME_N_C (
                                                                PER_LIC.SCH_TIME),
                                                          'DD-MON-YY HH24:MI:SS')
                                                AND SCH_NUMBER <
                                                       per_lic.sch_number
                                                AND SCH_CHA_NUMBER =
                                                       PER_LIC.SCH_CHA_NUMBER);
                              ELSE
                                 --COSTED RUNS ON SCH WINDOW 2
                                 C_COSTED_RUNS_ON_SW :=
                                    per_lic.lcr_cha_costed_runs2;

                                 /*      DBMS_OUTPUT.put_line (
                                          'sch number-' || per_lic.sch_number);
                                       DBMS_OUTPUT.put_line (
                                             'in sch wind 2-'
                                          || per_lic.lcr_cha_costed_runs2
                                          || 'PER_LIC.SCH_CHA_NUMBER-'
                                          || per_lic.sch_cha_number);
                                       DBMS_OUTPUT.put_line (
                                          'PER_LIC.SCH_FIN_ACTUAL_DATE-'
                                          || per_lic.sch_fin_actual_date);
                                       DBMS_OUTPUT.put_line (
                                          'PER_LIC.LCR_SCH_START_DATE2-'
                                          || PER_LIC.LCR_SCH_START_DATE2);
                                       DBMS_OUTPUT.put_line (
                                          'per_lic.sch_number-'
                                          || per_lic.sch_number); */

                                 --BLOCK Q)
                                 SELECT SUM (A)
                                   INTO C_NO_OF_COSTED_PREV_IND
                                   FROM (SELECT COUNT (*) A
                                           FROM FID_SCHEDULE
                                          WHERE SCH_LIC_NUMBER =
                                                   per_lic.sch_lic_number
                                                AND SCH_FIN_ACTUAL_DATE BETWEEN PER_LIC.LCR_SCH_START_DATE2
                                                                            AND TO_DATE (
                                                                                   PER_LIC.SCH_FIN_ACTUAL_DATE,
                                                                                   'DD-MON-RRRR')
                                                                                - 1
                                                AND SCH_CHA_NUMBER =
                                                       PER_LIC.SCH_CHA_NUMBER
                                         UNION
                                         SELECT COUNT (*) A
                                           FROM FID_SCHEDULE
                                          WHERE SCH_LIC_NUMBER =
                                                   PER_LIC.SCH_LIC_NUMBER
                                                AND SCH_FIN_ACTUAL_DATE =
                                                       PER_LIC.SCH_FIN_ACTUAL_DATE
                                                AND SCH_TIME <
                                                       PER_LIC.SCH_TIME
                                                AND SCH_CHA_NUMBER =
                                                       PER_LIC.SCH_CHA_NUMBER
                                         UNION
                                         --GET THE NO. OF LIC. SCHEDULES ON CHANNEL PRIOR TO SCHEDULE FOR WHICH
                                         --THE LOOP IS RUNNING (SCH_DATE (<), SCH_TIME (<)).
                                         SELECT COUNT (*) A
                                           FROM FID_SCHEDULE
                                          WHERE SCH_LIC_NUMBER =
                                                   PER_LIC.SCH_LIC_NUMBER
                                                AND TO_DATE (
                                                       TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')			   --Ver 1.1 Added to_char
                                                       || ' '
                                                       || CONVERT_TIME_N_C (
                                                             SCH_TIME),
                                                       'DD-MON-YY HH24:MI:SS') =
                                                       TO_DATE (
                                                       TO_CHAR(PER_LIC.SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')	   --Ver 1.1 Added to_char
                                                          || ' '
                                                          || CONVERT_TIME_N_C (
                                                                PER_LIC.SCH_TIME),
                                                          'DD-MON-YY HH24:MI:SS')
                                                AND sch_number <
                                                       per_lic.sch_number
                                                AND SCH_CHA_NUMBER =
                                                       PER_LIC.SCH_CHA_NUMBER);
                              END IF;                                      --9

                              /*     DBMS_OUTPUT.put_line (
                                      'C_NO_OF_COSTED_PREV_IND-'
                                      || c_no_of_costed_prev_ind);
                                   DBMS_OUTPUT.put_line (
                                      'C_COSTED_RUNS_ON_SW-'
                                      || c_costed_runs_on_sw);
                                   DBMS_OUTPUT.put_line (
                                      '--------------------------------------------');*/

                              IF C_NO_OF_COSTED_PREV_IND >=
                                    C_COSTED_RUNS_ON_SW                   --11
                              THEN
                                 PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                                    I_CURR_YEAR,
                                    I_CURR_MONTH,
                                    PER_LIC.SCH_NUMBER,
                                    'DN');
                              --DBMS_OUTPUT.PUT_LINE ('SET STATUS TO N'||PER_LIC.SCH_NUMBER);
                              ELSE
                                 --    DBMS_OUTPUT.PUT_LINE (
                                 --    'SET STATUS TO P' || PER_LIC.SCH_NUMBER);
                                 PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                                    I_CURR_YEAR,
                                    I_CURR_MONTH,
                                    PER_LIC.SCH_NUMBER,
                                    'P');
                                 C_TOTAL_COST_RUNS_REMAIN :=
                                    C_TOTAL_COST_RUNS_REMAIN - 1;
                              -- DBMS_OUTPUT.PUT_LINE('DECREASE COUNT BY 1');
                              END IF;                                     --11
                           ELSE
                              PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                                 I_CURR_YEAR,
                                 I_CURR_MONTH,
                                 PER_LIC.SCH_NUMBER,
                                 'DN');
                           END IF;                                         --8
                        ELSE
                           PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                              I_CURR_YEAR,
                              I_CURR_MONTH,
                              PER_LIC.SCH_NUMBER,
                              'DN');
                        END IF;                                            --7
                     END LOOP;
                  ELSE
                     PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                        I_CURR_YEAR,
                        I_CURR_MONTH,
                        SCH_LIC_R.SCH_LIC_NUMBER,
                        'AN');
                  END IF;                                                 --A1
               END IF;                                                   --(3)
            ELSE
               IF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'E'
               THEN
                  FOR SCH_PER_LIC_R IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
                  LOOP
                     PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                        SCH_PER_LIC_R.SCH_NUMBER,
                        SCH_PER_LIC_R.SCH_LIC_NUMBER,
                        SCH_PER_LIC_R.SCH_CHA_NUMBER,
                        SCH_PER_LIC_R.CHA_SCH_START_TIME,
                        SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                        SCH_PER_LIC_R.SCH_TIME,
                        SCH_PER_LIC_R.LIC_FREE_RPT,
                        SCH_PER_LIC_R.LIC_RPT_PERIOD,
                        'N');
                  END LOOP;
               --END  AFRICA FREE REPEAT
			   --ver 1.1 start
			   ELSIF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'F'
			   THEN
			   FOR SCH_PER_LIC_R IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
			   LOOP
				  PRC_FIN_UPD_OMNIBUS_SCH(
							SCH_PER_LIC_R.SCH_NUMBER,
							SCH_PER_LIC_R.SCH_LIC_NUMBER,
							SCH_PER_LIC_R.SCH_CHA_NUMBER,
							SCH_PER_LIC_R.CHA_SCH_START_TIME,
							SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
							SCH_PER_LIC_R.SCH_TIME,
							SCH_PER_LIC_R.LIC_FREE_RPT,
							SCH_PER_LIC_R.LIC_RPT_PERIOD,
							'N');
			   END LOOP;
			   --ver 1.1 end
               ELSE
                  PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                     I_CURR_YEAR,
                     I_CURR_MONTH,
                     SCH_LIC_R.SCH_LIC_NUMBER,
                     'AN');
               END IF;
            END IF;                                                      --(2)
         ELSE
            IF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'E'
            THEN
               FOR SCH_PER_LIC_R IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
               LOOP
                  PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                     SCH_PER_LIC_R.SCH_NUMBER,
                     SCH_PER_LIC_R.SCH_LIC_NUMBER,
                     SCH_PER_LIC_R.SCH_CHA_NUMBER,
                     SCH_PER_LIC_R.CHA_SCH_START_TIME,
                     SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                     SCH_PER_LIC_R.SCH_TIME,
                     SCH_PER_LIC_R.LIC_FREE_RPT,
                     SCH_PER_LIC_R.LIC_RPT_PERIOD,
                     'N');
               END LOOP;
            --END  AFRICA FREE REPEAT
			--ver 1.1 start
			ELSIF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'F'
			THEN
				FOR SCH_PER_LIC_R IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
				LOOP
				  PRC_FIN_UPD_OMNIBUS_SCH(
							SCH_PER_LIC_R.SCH_NUMBER,
							SCH_PER_LIC_R.SCH_LIC_NUMBER,
							SCH_PER_LIC_R.SCH_CHA_NUMBER,
							SCH_PER_LIC_R.CHA_SCH_START_TIME,
							SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
							SCH_PER_LIC_R.SCH_TIME,
							SCH_PER_LIC_R.LIC_FREE_RPT,
							SCH_PER_LIC_R.LIC_RPT_PERIOD,
							'N');
			    END LOOP;
			 --ver 1.1 end
            ELSE
               PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                  I_CURR_YEAR,
                  I_CURR_MONTH,
                  SCH_LIC_R.SCH_LIC_NUMBER,
                  'AN');
            END IF;

            DBMS_OUTPUT.PUT_LINE ('BLOCK A-' || SCH_LIC_R.SCH_LIC_NUMBER);
         END IF;                                                         --(1)
      /*EXIT WHEN SCH_LIC%NOTFOUND;*/
      END LOOP;
   /*-------------------------------------------------------------------------------*/
   /*- CHANGES PURE FINANCE END
   /*-------------------------------------------------------------------------------*/
   END PRC_FIN_SCH_VEREX;

   PROCEDURE PRC_FIN_SCH_VEREX_NEW_RULE (I_CURR_YEAR        IN NUMBER,
                                         I_CURR_MONTH       IN NUMBER,
                                         I_PREVIOUS_YEAR    IN NUMBER,
                                         I_PREVIOUS_MONTH   IN NUMBER,
                                         I_SPLIT_REGION     IN VARCHAR2)
   IS
      FIN_GO_LIVE                      DATE;
      C_NO_COST_PREV_MNT_SUB_LED       NUMBER;
      C_NO_OF_PAID_SCHEDULES           NUMBER;
      C_IS_BIOSCOPE_LEE                NUMBER;
      C_NO_OF_COSTED_IND               NUMBER;
      C_NO_OF_COSTED_PREV_IND          NUMBER;
      C_NO_LIC_SCH_PREV_MTH            NUMBER;
      C_NO_LIC_SCH_PREV_SW2_STR        NUMBER;
      C_COSTED_RUNS_ON_SW              NUMBER;
      C_TOTAL_RUNS                     NUMBER;
      C_TOTAL_COST_RUNS_REMAIN         NUMBER;
      C_NO_LIC_SCH_BW_SW2_LDPREV_MNT   NUMBER;
      C_FREE_RPT                       NUMBER;
      C_RPT_PERIOD                     DATE;
      C_SCH_IN_RPT_PERIOD              NUMBER;
      C_NO_FREE_SCH                    NUMBER;
      C_SCH_DATE                       DATE;
      C_SCH_TIME                       NUMBER;
      l_alloc_costed_runs              x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
      l_sch_window                     x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
      l_sw1_start                      x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_sw1_end                        x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_sw2_start                      x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_sw2_end                        x_fin_costing_rule_config.crc_lic_start_from%TYPE;
      l_cw1_costed_runs                x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
      l_1_fin_year_sch_cnt             x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE;
      l_costed_runs_cost_schedules     NUMBER;

      --PURE FINANCE:[FOR BIOSCOPE AND NON BIOSCOPE CHANGES][MANGESH GULHANE][2013-02-25]

      --GET ALL THE LICENSES SCHEDULE IN THE CURRENT MONTH
      --SCH_FIN_ACTUAL_DATE:-IF THE SCHEDULE TIME IS BETWEEN 0 AND CHANNEL START TIME THEN
      --SCH_FIN_ACTUAL_DATE=SCH_DATE+1 ELSE IT WILL BE THE SAME AS SCH_DATE

      CURSOR SCH_LIC
      IS
           SELECT DISTINCT SCH_LIC_NUMBER, LIC_SHOWING_LIC, LIC_AMORT_CODE
             FROM FID_SCHEDULE,
                  FID_LICENSE,
                  FID_REGION --PURE FINANCE:[FOR BIOSCOPE/NON BIOSCOPE AND AFR-RSA CHANGES][MANGESH GULHANE][2013-02-25]
                            ,
                  FID_LICENSEE                              --PURE FINANCE END
            WHERE SCH_LIC_NUMBER = LIC_NUMBER
                  AND SCH_FIN_ACTUAL_DATE BETWEEN TO_DATE (
                                                     '01'
                                                     || LPAD (
                                                           TO_CHAR (
                                                              I_CURR_MONTH),
                                                           2,
                                                           '0')
                                                     || I_CURR_YEAR,
                                                     'DDMMYYYY')
                                              AND LAST_DAY (
                                                     TO_DATE (
                                                        '01'
                                                        || LPAD (
                                                              TO_CHAR (
                                                                 I_CURR_MONTH),
                                                              2,
                                                              '0')
                                                        || I_CURR_YEAR,
                                                        'DDMMYYYY'))
                  AND UPPER (LIC_AMORT_CODE) IN ('D', 'E','F')					--Added 'F' in ver 1.1
                  AND LIC_LEE_NUMBER = LEE_NUMBER
                  AND LEE_SPLIT_REGION = REG_ID(+) --PURE FINANCE:[FOR BIOSCOPE/NON BIOSCOPE AND NCF deal CHANGES][MANGESH GULHANE][2013-02-25]
                  AND UPPER (LIC_STATUS) NOT IN ('F', 'T')  --PURE FINANCE END
                  AND LIC_START >= (SELECT TO_DATE (CONTENT, 'DD-MON-YYYY')
                                      FROM X_FIN_CONFIGS
                                     WHERE KEY LIKE 'GO-LIVEDATE') --GO_LIVE_DATE
                  AND LIC_START >= (SELECT TO_DATE (CONTENT, 'DD-MON-YYYY')
                                      FROM X_FIN_CONFIGS
                                     WHERE --KEY LIKE 'COSTING_5+2_GO_LIVE_DATE'
                                          id = 6)        -- 5_+_2_GO_LIVE_DATE
                  AND UPPER (NVL (REG_CODE, '#')) LIKE
                         UPPER (NVL (I_SPLIT_REGION, '#'))
                  --AND LIC_CON_NUMBER = 65070
                  --and LIC_NUMBER = 1108531
         --   AND sch_lic_number = 734893
         -- and lic_number=637915
         ORDER BY SCH_LIC_NUMBER;


      -- GET EACH SCHEDULE OF LICENSE DURING ROUTINE PERIOD
      CURSOR SCH_PER_LIC (
         L_SCH_LIC_NUMBER NUMBER)
      IS
           SELECT SCH_LIC_NUMBER,
                  SCH_CHA_NUMBER,
                  SCH_FIN_ACTUAL_DATE,
                  SCH_TIME,
                  LCR_SCH_START_DATE2,
                  SCH_NUMBER,
                  LCR_COST_IND,
                  LIC_AMORT_CODE,
                  LCR_CHA_COSTED_RUNS,
                  LCR_CHA_COSTED_RUNS2,
                  LIC_FREE_RPT,
                  LIC_RPT_PERIOD,
                  CHA_SCH_START_TIME,
                  LIC_START,
                  LIC_END
             FROM FID_SCHEDULE,
                  FID_LICENSE_CHANNEL_RUNS,
                  FID_LICENSE,
                  FID_CHANNEL
            WHERE     SCH_LIC_NUMBER = LCR_LIC_NUMBER
                  AND LCR_LIC_NUMBER = LIC_NUMBER
                  AND SCH_CHA_NUMBER = LCR_CHA_NUMBER
                  AND LCR_CHA_NUMBER = CHA_NUMBER
                  AND SCH_FIN_ACTUAL_DATE BETWEEN TO_DATE (
                                                     '01'
                                                     || LPAD (
                                                           TO_CHAR (
                                                              I_CURR_MONTH),
                                                           2,
                                                           '0')
                                                     || I_CURR_YEAR,
                                                     'DDMMYYYY')
                                              AND LAST_DAY (
                                                     TO_DATE (
                                                        '01'
                                                        || LPAD (
                                                              TO_CHAR (
                                                                 I_CURR_MONTH),
                                                              2,
                                                              '0')
                                                        || I_CURR_YEAR,
                                                        'DDMMYYYY'))
                  AND SCH_LIC_NUMBER = L_SCH_LIC_NUMBER
         ORDER BY SCH_FIN_ACTUAL_DATE, SCH_TIME, SCH_NUMBER;

      --GET THE COSTED TICK CHANNEL FOR EACH LICENSE
      CURSOR COST_IND_PER_LIC (
         L_SCH_LIC_NUMBER NUMBER)
      IS
         SELECT *
           FROM FID_LICENSE_CHANNEL_RUNS
          WHERE LCR_LIC_NUMBER = L_SCH_LIC_NUMBER
                AND UPPER (LCR_COST_IND) = 'Y';
   --PURE FINANCE:END
   BEGIN
      /*-------------------------------------------------------------------------------*/
      /*- CHANGES PURE FINANCE NON BIOSCOPE LICENSE [MANGESH GULHANE][2013-02-25]
      /*-------------------------------------------------------------------------------*/

      FOR SCH_LIC_R IN SCH_LIC
      LOOP
         C_TOTAL_RUNS := 0;
         c_total_cost_runs_remain := 0;
         C_NO_OF_COSTED_PREV_IND := 0;

         --GET THE NO OF COSTED RUNS FROM SUBLEDGER TILL PREV MONTH at license level
         SELECT NVL (SUM (lis_paid_exhibition), 0)
           INTO c_no_cost_prev_mnt_sub_led
           FROM (SELECT DISTINCT lis_paid_exhibition,
                                 lis_per_month,
                                 lis_per_year,
                                 lis_lic_number
                   FROM fid_license_sub_ledger
                  WHERE lis_lic_number = SCH_LIC_R.SCH_LIC_NUMBER
                        AND lis_paid_exhibition <> 0
                        AND lis_per_year || LPAD (lis_per_month, 2, 0) <=
                               CONCAT (I_PREVIOUS_YEAR,
                                       LPAD (I_PREVIOUS_MONTH, 2, 0)));

         --IF NUMBER OF COSTED RUNS TILL PREV MONTH LESS THAN NO OF RUNS ON WHICH IT SHOULD BE COSTED
         --AT LICENSE LEVEL ELSE UPDATE SCH_TYPE AS 'N'OR 'F' FOR ALL THE SCHEDULES IN ROUTINE MONTH

         IF C_NO_COST_PREV_MNT_SUB_LED < SCH_LIC_R.LIC_SHOWING_LIC       --(1)
         THEN
            --GET NO OF PAID SCHEDULES TILL PREVIOUS MONTH OF ROUTINE MONTH
            SELECT COUNT (*)
              INTO C_NO_OF_PAID_SCHEDULES
              FROM FID_SCHEDULE
             WHERE SCH_LIC_NUMBER = SCH_LIC_R.SCH_LIC_NUMBER
                   AND SCH_FIN_ACTUAL_DATE <
                          TO_DATE (
                                '01'
                             || LPAD (TO_CHAR (I_CURR_MONTH), 2, '0')
                             || I_CURR_YEAR,
                             'DDMMYYYY')
                   AND UPPER (SCH_TYPE) IN ('P');

            --CHECK IF THERE ARE RUNS TO BE COSTED REMAINING AT LICENSE LEVEL
            IF (C_NO_OF_PAID_SCHEDULES < SCH_LIC_R.LIC_SHOWING_LIC)      --(2)
            THEN
               --LOOP FOR EACH SCHEDULE OF LICENSE DURING ROUTINE MONTH
               FOR SCH_PER_LIC_R IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
               LOOP
                  DBMS_OUTPUT.put_line (
                     'l ::' || sch_per_lic_r.sch_lic_number);
                  prc_cost_rule_config_info (
                     sch_per_lic_r.sch_lic_number,
                     sch_per_lic_r.lic_start,
                     sch_per_lic_r.lic_end,
                     sch_per_lic_r.sch_fin_actual_date,
                     sch_lic_r.lic_showing_lic,
                     l_alloc_costed_runs,
                     l_sch_window,
                     l_sw1_start,
                     l_sw1_end,
                     l_sw2_start,
                     l_sw2_end,
                     l_cw1_costed_runs);

                  IF l_sch_window = 2
                  THEN
                     l_alloc_costed_runs := sch_lic_r.lic_showing_lic;

                     SELECT COUNT (*)
                       INTO l_1_fin_year_sch_cnt
                       FROM fid_schedule, fid_channel
                      WHERE     sch_cha_number = cha_number
                            AND sch_lic_number = sch_per_lic_r.sch_lic_number
                            AND UPPER (sch_type) IN ('N', 'P')
                            AND sch_fin_actual_date < l_sw1_end + 1;

                     --    DBMS_OUTPUT.put_line (
                     --    'l_cw1_costed_runs *********** ' || l_cw1_costed_runs);

                     IF l_1_fin_year_sch_cnt > l_cw1_costed_runs
                     THEN
                        l_1_fin_year_sch_cnt := l_cw1_costed_runs;
                     END IF;

                     SELECT COUNT (*)
                       INTO l_costed_runs_cost_schedules
                       FROM x_fin_cost_schedules, FID_CHANNEL
                      WHERE CSH_CHA_NUMBER = CHA_NUMBER
                            AND CSH_LIC_NUMBER = SCH_LIC_R.SCH_LIC_NUMBER
                            AND TO_NUMBER (TO_CHAR (CSH_SCH_DATE, 'YYYYMM')) <
                                   (I_CURR_YEAR || LPAD (I_CURR_MONTH, 2, 0))
                            AND TO_NUMBER (TO_CHAR (CSH_SCH_DATE, 'YYYYMM')) <=
                                   TO_NUMBER (TO_CHAR (l_sw1_end, 'YYYYMM'));

                     IF l_costed_runs_cost_schedules > l_cw1_costed_runs
                     THEN
                        l_1_fin_year_sch_cnt := l_costed_runs_cost_schedules;
                     END IF;

                     BEGIN
                        SELECT SUM (A)
                          INTO C_NO_OF_COSTED_PREV_IND
                          FROM (SELECT COUNT (*) A
                                  FROM FID_SCHEDULE, FID_CHANNEL
                                 WHERE SCH_CHA_NUMBER = CHA_NUMBER
                                       AND SCH_LIC_NUMBER =
                                              SCH_LIC_R.SCH_LIC_NUMBER
                                       AND UPPER (SCH_TYPE) IN ('P', 'N')
                                       AND SCH_FIN_ACTUAL_DATE > l_sw1_end
                                       AND TO_DATE (
                                              TO_CHAR (SCH_FIN_ACTUAL_DATE,
                                                       'DD-MON-YYYY')
                                              || ' '
                                              || CONVERT_TIME_N_C (SCH_TIME),
                                              'DD-MON-YYYY HH24:MI:SS') <
                                              TO_DATE (
                                                 TO_CHAR (
                                                    SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                                                    'DD-MON-YYYY')
                                                 || ' '
                                                 || CONVERT_TIME_N_C (
                                                       SCH_PER_LIC_R.SCH_TIME),
                                                 'DD-MON-YYYY HH24:MI:SS')
                                UNION
                                SELECT COUNT (*) A
                                  FROM FID_SCHEDULE, FID_CHANNEL
                                 WHERE SCH_CHA_NUMBER = CHA_NUMBER
                                       AND SCH_LIC_NUMBER =
                                              SCH_LIC_R.SCH_LIC_NUMBER
                                       AND UPPER (SCH_TYPE) IN ('P', 'N')
                                       AND SCH_FIN_ACTUAL_DATE > l_sw1_end
                                       AND TO_DATE (
                                              TO_CHAR (SCH_FIN_ACTUAL_DATE,
                                                       'DD-MON-YYYY')
                                              || ' '
                                              || CONVERT_TIME_N_C (SCH_TIME),
                                              'DD-MON-YY HH24:MI:SS') =
                                              TO_DATE (
                                                 TO_CHAR (
                                                    SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                                                    'DD-MON-YYYY')
                                                 || ' '
                                                 || CONVERT_TIME_N_C (
                                                       SCH_PER_LIC_R.SCH_TIME),
                                                 'DD-MON-YY HH24:MI:SS')
                                       AND SCH_NUMBER <
                                              SCH_PER_LIC_R.SCH_NUMBER);
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           C_NO_OF_COSTED_PREV_IND := 0;
                     END;

                     /*    DBMS_OUTPUT.put_line (
                               'C_NO_OF_COSTED_PREV_IND '
                            || C_NO_OF_COSTED_PREV_IND
                            || ' l_1_fin_year_sch_cnt '
                            || l_1_fin_year_sch_cnt); */
                     C_NO_OF_COSTED_PREV_IND :=
                        C_NO_OF_COSTED_PREV_IND + l_1_fin_year_sch_cnt;
                  ELSE
                     BEGIN
                        SELECT SUM (A)
                          INTO C_NO_OF_COSTED_PREV_IND
                          FROM (SELECT COUNT (*) A
                                  FROM FID_SCHEDULE, FID_CHANNEL
                                 WHERE SCH_CHA_NUMBER = CHA_NUMBER
                                       AND SCH_LIC_NUMBER =
                                              SCH_LIC_R.SCH_LIC_NUMBER
                                       AND UPPER (SCH_TYPE) IN ('P', 'N')
                                       AND TO_DATE (
                                              TO_CHAR (SCH_FIN_ACTUAL_DATE,
                                                       'DD-MON-YYYY')
                                              || ' '
                                              || CONVERT_TIME_N_C (SCH_TIME),
                                              'DD-MON-YYYY HH24:MI:SS') <
                                              TO_DATE (
                                                 TO_CHAR (
                                                    SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                                                    'DD-MON-YYYY')
                                                 || ' '
                                                 || CONVERT_TIME_N_C (
                                                       SCH_PER_LIC_R.SCH_TIME),
                                                 'DD-MON-YYYY HH24:MI:SS')
                                UNION
                                SELECT COUNT (*) A
                                  FROM FID_SCHEDULE, FID_CHANNEL
                                 WHERE SCH_CHA_NUMBER = CHA_NUMBER
                                       AND SCH_LIC_NUMBER =
                                              SCH_LIC_R.SCH_LIC_NUMBER
                                       AND UPPER (SCH_TYPE) IN ('P', 'N')
                                       AND TO_DATE (
                                              TO_CHAR (SCH_FIN_ACTUAL_DATE,
                                                       'DD-MON-YYYY')
                                              || ' '
                                              || CONVERT_TIME_N_C (SCH_TIME),
                                              'DD-MON-YY HH24:MI:SS') =
                                              TO_DATE (
                                                 TO_CHAR (
                                                    SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                                                    'DD-MON-YYYY')
                                                 || ' '
                                                 || CONVERT_TIME_N_C (
                                                       SCH_PER_LIC_R.SCH_TIME),
                                                 'DD-MON-YY HH24:MI:SS')
                                       AND SCH_NUMBER <
                                              SCH_PER_LIC_R.SCH_NUMBER);
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           C_NO_OF_COSTED_PREV_IND := 0;
                     END;
                  END IF;



                  --CHECK IF THERE ARE RUNS TO BE COSTED REMAINING AT LICENSE LEVEL
                  IF C_NO_OF_COSTED_PREV_IND < l_alloc_costed_runs
                  THEN
                     --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                     --TO INCLUDE FREE RUNS IN SCHEDULES
                     IF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'E'      --AFC1
                     THEN
                        --UPDATE SCH_TYPE WITH 'P' OR 'F'
                        PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                           SCH_PER_LIC_R.SCH_NUMBER,
                           SCH_PER_LIC_R.SCH_LIC_NUMBER,
                           SCH_PER_LIC_R.SCH_CHA_NUMBER,
                           SCH_PER_LIC_R.CHA_SCH_START_TIME,
                           SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                           SCH_PER_LIC_R.SCH_TIME,
                           SCH_PER_LIC_R.LIC_FREE_RPT,
                           SCH_PER_LIC_R.LIC_RPT_PERIOD,
                           'P');
                     --END  AFRICA FREE REPEAT
					 --ver 1.1 start
					 ELSIF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'F'
                     THEN
                        PRC_FIN_UPD_OMNIBUS_SCH (
                           SCH_PER_LIC_R.SCH_NUMBER,
                           SCH_PER_LIC_R.SCH_LIC_NUMBER,
                           SCH_PER_LIC_R.SCH_CHA_NUMBER,
                           SCH_PER_LIC_R.CHA_SCH_START_TIME,
                           SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                           SCH_PER_LIC_R.SCH_TIME,
                           SCH_PER_LIC_R.LIC_FREE_RPT,
                           SCH_PER_LIC_R.LIC_RPT_PERIOD,
                           'P');
					 --ver 1.1 end
                     ELSE
                        --NON BIOSCOPE WITH AMORT CODE D
                        --UPDATE SCH_TYPE WITH 'P'
                        --     dbms_output.put_line ('C_NO_OF_COSTED_PREV_IND ::'||C_NO_OF_COSTED_PREV_IND||' '||'l_alloc_costed_runs ::'||' '||l_alloc_costed_runs);
                        PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                           I_CURR_YEAR,
                           I_CURR_MONTH,
                           SCH_PER_LIC_R.SCH_NUMBER,
                           'P');
                     END IF;
                  --AFC1
                  ELSE
                     --NO RUNS REMAIN AT LICENSE LEVEL TO BE COSTED
                     --AFRICA FREE REPEAT[MANGESH_GULHANE][15-MAR-2013]
                     --TO INCLUDE FREE RUNS IN SCHEDULES

                     IF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'E'
                     THEN
                        PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                           SCH_PER_LIC_R.SCH_NUMBER,
                           SCH_PER_LIC_R.SCH_LIC_NUMBER,
                           SCH_PER_LIC_R.SCH_CHA_NUMBER,
                           SCH_PER_LIC_R.CHA_SCH_START_TIME,
                           SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                           SCH_PER_LIC_R.SCH_TIME,
                           SCH_PER_LIC_R.LIC_FREE_RPT,
                           SCH_PER_LIC_R.LIC_RPT_PERIOD,
                           'N');
                     --END  AFRICA FREE REPEAT
					 --ver 1.1 start
					 ELSIF UPPER (SCH_PER_LIC_R.LIC_AMORT_CODE) = 'F'
                     THEN
                        PRC_FIN_UPD_OMNIBUS_SCH(
                           SCH_PER_LIC_R.SCH_NUMBER,
                           SCH_PER_LIC_R.SCH_LIC_NUMBER,
                           SCH_PER_LIC_R.SCH_CHA_NUMBER,
                           SCH_PER_LIC_R.CHA_SCH_START_TIME,
                           SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                           SCH_PER_LIC_R.SCH_TIME,
                           SCH_PER_LIC_R.LIC_FREE_RPT,
                           SCH_PER_LIC_R.LIC_RPT_PERIOD,
                           'N');
					 --ver 1.1 end
                     ELSE
                        PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                           I_CURR_YEAR,
                           I_CURR_MONTH,
                           SCH_PER_LIC_R.SCH_NUMBER,
                           'DN');
                     END IF;
                  END IF;
               END LOOP;
            ELSE
               IF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'E'
               THEN
                  FOR SCH_PER_LIC_R IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
                  LOOP
                     PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                        SCH_PER_LIC_R.SCH_NUMBER,
                        SCH_PER_LIC_R.SCH_LIC_NUMBER,
                        SCH_PER_LIC_R.SCH_CHA_NUMBER,
                        SCH_PER_LIC_R.CHA_SCH_START_TIME,
                        SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                        SCH_PER_LIC_R.SCH_TIME,
                        SCH_PER_LIC_R.LIC_FREE_RPT,
                        SCH_PER_LIC_R.LIC_RPT_PERIOD,
                        'N');
                  END LOOP;
               --END  AFRICA FREE REPEAT
				--ver 1.1 start
				ELSIF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'F'
				THEN
				FOR SCH_PER_LIC_R IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
                LOOP
				PRC_FIN_UPD_OMNIBUS_SCH(
										SCH_PER_LIC_R.SCH_NUMBER,
										SCH_PER_LIC_R.SCH_LIC_NUMBER,
										SCH_PER_LIC_R.SCH_CHA_NUMBER,
										SCH_PER_LIC_R.CHA_SCH_START_TIME,
										SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
										SCH_PER_LIC_R.SCH_TIME,
										SCH_PER_LIC_R.LIC_FREE_RPT,
										SCH_PER_LIC_R.LIC_RPT_PERIOD,
										'N');
				END LOOP;
				--ver 1.1 end
               ELSE
                  PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                     I_CURR_YEAR,
                     I_CURR_MONTH,
                     SCH_LIC_R.SCH_LIC_NUMBER,
                     'AN');
               END IF;
            END IF;                                                      --(2)
         ELSE
            IF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'E'
            THEN
               FOR SCH_PER_LIC_R IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
               LOOP
                  PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPD_AFR_FREE_SCH (
                     SCH_PER_LIC_R.SCH_NUMBER,
                     SCH_PER_LIC_R.SCH_LIC_NUMBER,
                     SCH_PER_LIC_R.SCH_CHA_NUMBER,
                     SCH_PER_LIC_R.CHA_SCH_START_TIME,
                     SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
                     SCH_PER_LIC_R.SCH_TIME,
                     SCH_PER_LIC_R.LIC_FREE_RPT,
                     SCH_PER_LIC_R.LIC_RPT_PERIOD,
                     'N');
               END LOOP;
            --END  AFRICA FREE REPEAT
			--ver 1.1 start
			ELSIF UPPER (SCH_LIC_R.LIC_AMORT_CODE) = 'F'
			THEN
				FOR SCH_PER_LIC_R IN SCH_PER_LIC (SCH_LIC_R.SCH_LIC_NUMBER)
                LOOP
				PRC_FIN_UPD_OMNIBUS_SCH(
										SCH_PER_LIC_R.SCH_NUMBER,
										SCH_PER_LIC_R.SCH_LIC_NUMBER,
										SCH_PER_LIC_R.SCH_CHA_NUMBER,
										SCH_PER_LIC_R.CHA_SCH_START_TIME,
										SCH_PER_LIC_R.SCH_FIN_ACTUAL_DATE,
										SCH_PER_LIC_R.SCH_TIME,
										SCH_PER_LIC_R.LIC_FREE_RPT,
										SCH_PER_LIC_R.LIC_RPT_PERIOD,
										'N');
				END LOOP;
			--ver 1.1 end
            ELSE
               PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (
                  I_CURR_YEAR,
                  I_CURR_MONTH,
                  SCH_LIC_R.SCH_LIC_NUMBER,
                  'AN');
            END IF;

            DBMS_OUTPUT.PUT_LINE ('BLOCK A-' || SCH_LIC_R.SCH_LIC_NUMBER);
         END IF;                                                         --(1)
      /*EXIT WHEN SCH_LIC%NOTFOUND;*/
      END LOOP;
   /*-------------------------------------------------------------------------------*/
   /*- CHANGES PURE FINANCE END
   /*-------------------------------------------------------------------------------*/
   EXCEPTION
         WHEN OTHERS
         THEN
         raise_application_error (-20100, SUBSTR (SQLERRM, 1, 200));
   END PRC_FIN_SCH_VEREX_NEW_RULE;

   PROCEDURE PRC_FIN_UPDATE_SCH_TYPE (C_CURR_YEAR    IN NUMBER,
                                      C_CURR_MONTH   IN NUMBER,
                                      C_NUMBER       IN NUMBER,
                                      --CAN CONTAIN EITHER SCH_NUMBER OR SCH_LIC_NUMBER
                                      C_BLOCK        IN VARCHAR2 --USED FOR DECISION MAKING FOR BLOCK EXECUTION
                                                                )
   IS
   BEGIN
      IF C_BLOCK = 'AN'
      THEN
         UPDATE FID_SCHEDULE
            SET SCH_TYPE = 'N'
          WHERE SCH_LIC_NUMBER = C_NUMBER
                AND SCH_FIN_ACTUAL_DATE BETWEEN TO_DATE (
                                                   '01'
                                                   || LPAD (
                                                         TO_CHAR (
                                                            C_CURR_MONTH),
                                                         2,
                                                         '0')
                                                   || C_CURR_YEAR,
                                                   'DDMMYYYY')
                                            AND LAST_DAY (
                                                   TO_DATE (
                                                      '01'
                                                      || LPAD (
                                                            TO_CHAR (
                                                               C_CURR_MONTH),
                                                            2,
                                                            '0')
                                                      || C_CURR_YEAR,
                                                      'DDMMYYYY'));
      END IF;

      IF UPPER (C_BLOCK) = 'P'
      THEN
         UPDATE FID_SCHEDULE
            SET SCH_TYPE = 'P'
          WHERE SCH_NUMBER = C_NUMBER;
      END IF;

      IF UPPER (C_BLOCK) = 'DN'
      THEN
         UPDATE FID_SCHEDULE
            SET SCH_TYPE = 'N'
          WHERE SCH_NUMBER = C_NUMBER;
      END IF;


      IF UPPER (C_BLOCK) = 'F'
      THEN
         UPDATE FID_SCHEDULE
            SET SCH_TYPE = 'F'
          WHERE SCH_NUMBER = C_NUMBER;
      END IF;
   END PRC_FIN_UPDATE_SCH_TYPE;

   PROCEDURE PRC_FIN_UPD_AFR_FREE_SCH (I_SCH_NUMBER       IN NUMBER,
                                       I_SCH_LIC_NUMBER   IN NUMBER,
                                       I_SCH_CHA_NUMBER   IN NUMBER,
                                       I_CHA_START_TIME   IN NUMBER,
                                       I_SCH_DATE         IN DATE,
                                       I_SCH_TIME         IN NUMBER,
                                       I_LIC_FREE_RPT     IN NUMBER,
                                       I_LIC_RPT_PERIOD   IN NUMBER,
                                       I_SCH_TYPE         IN VARCHAR2)
   AS
      C_RPT_PERIOD          DATE;
      C_SCH_IN_RPT_PERIOD   NUMBER;
      C_NO_FREE_SCH         NUMBER;
      C_TEMP_SCH_TIME       NUMBER;
      C_TEMP_SCH_DATE       DATE;
      C_CURR_MONTH          NUMBER;
      C_CURR_YEAR           NUMBER;
   BEGIN
      c_rpt_period :=
         TO_DATE (to_char(I_SCH_DATE,'DD-MON-YYYY') || ' ' || CONVERT_TIME_N_C (I_SCH_TIME),
                  'DD-MON-YY HH24:MI:SS')
         - I_LIC_RPT_PERIOD;

      /* dbms_output.put_line('============================================================');
       dbms_output.put_line('sch_number='||i_sch_number ||'-I_SCH_TYPE'||I_SCH_TYPE);
       dbms_output.put_line('C_RPT_PERIOD -'||to_char(C_RPT_PERIOD,'DD-MON-YY HH24:MI:SS') );*/

      --GET THE NUMBER OF SCHDULES HAVING SCH_TYPE AS 'P' OR 'N'
      --BETWEEN THE INPUT SCHEDULE DATE AND REPEAT PERIOD SPECIFIED FOR THE LICENSE



      SELECT SUM (A)
        INTO c_sch_in_rpt_period
        FROM (SELECT COUNT (*) A
                FROM FID_SCHEDULE
               WHERE     sch_lic_number = i_sch_lic_number
                     --   AND SCH_CHA_NUMBER=I_SCH_CHA_NUMBER
                     AND UPPER (SCH_TYPE) IN ('P', 'N')
                     AND TO_DATE (
                               TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')				--Ver 1.1 Added to_char
                            || ' '
                            || CONVERT_TIME_N_C (SCH_TIME),
                            'DD-MON-YY HH24:MI:SS') >= C_RPT_PERIOD
                     AND TO_DATE (
                               TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')			    --Ver 1.1 Added to_char
                            || ' '
                            || CONVERT_TIME_N_C (SCH_TIME),
                            'DD-MON-YY HH24:MI:SS') <
                            TO_DATE (
                                  TO_CHAR(I_SCH_DATE,'DD-MON-YYYY')						--Ver 1.1 Added to_char
                               || ' '
                               || CONVERT_TIME_N_C (I_SCH_TIME),
                               'DD-MON-YY HH24:MI:SS')
              UNION
              SELECT COUNT (*) A
                FROM fid_schedule
               WHERE sch_lic_number = i_sch_lic_number
                     AND UPPER (sch_type) IN ('P', 'N')
                     AND TO_DATE (
                            TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')					--Ver 1.1 Added to_char
                            || ' '
                            || CONVERT_TIME_N_C (SCH_TIME),
                            'DD-MON-YY HH24:MI:SS') =
                            TO_DATE (
                                  TO_CHAR(I_SCH_DATE,'DD-MON-YYYY')						--Ver 1.1 Added to_char
                               || ' '
                               || CONVERT_TIME_N_C (I_SCH_TIME),
                               'DD-MON-YY HH24:MI:SS')
                     AND sch_number < i_sch_number);

      --dbms_output.put_line('C_SCH_IN_RPT_PERIOD-'||C_SCH_IN_RPT_PERIOD);
      --CHECK IF ANY SCHEDULE EXIST IN THE ABOVE DATE RANGE
      IF C_SCH_IN_RPT_PERIOD = 0
      THEN
         --IF NO SCHEDULES EXIST THE UPDATE THE SCHEDULES AS 'P' OR 'N'
         --DEPENDING UPON THE NUMBER OF COSTED RUNS REMAINING
         IF UPPER (I_SCH_TYPE) = 'P'
         THEN
            -- DBMS_OUTPUT.put_line ('In paid not paid-P');
            PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (C_CURR_YEAR,
                                                            C_CURR_MONTH,
                                                            I_SCH_NUMBER,
                                                            'P');
         END IF;

         IF UPPER (I_SCH_TYPE) = 'N'
         THEN
            --  DBMS_OUTPUT.put_line ('In paid not paid-N');
            PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (C_CURR_YEAR,
                                                            C_CURR_MONTH,
                                                            i_sch_number,
                                                            'DN');
         END IF;
      ELSE
         --dbms_output.put_line('In paid not paid Free');
         --IF SCHEDULES EXIST BETWEEN THE INPUT SCHEDULE DATE AND REPEAT PERIOD SPECIFIED FOR THE LICENSE
         --THEN GET THE CLOSEST PREVIOUS SCHEDULE ON CHANNEL HAVING SCHEDULE TYPE AS 'P'OR 'N'
         SELECT SCH_FIN_ACTUAL_DATE, SCH_TIME
           INTO C_TEMP_SCH_DATE, C_TEMP_SCH_TIME
           FROM (SELECT SCH_FIN_ACTUAL_DATE, SCH_TIME
                   FROM FID_SCHEDULE
                  WHERE     sch_lic_number = i_sch_lic_number
                        -- AND SCH_CHA_NUMBER=I_SCH_CHA_NUMBER
                        AND UPPER (sch_type) IN ('P', 'N')
                        AND TO_DATE (
                                  TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')					--Ver 1.1 Added to_char
                               || ' '
                               || CONVERT_TIME_N_C (SCH_TIME),
                               'DD-MON-YY HH24:MI:SS') >= C_RPT_PERIOD
                        and to_date (
                                  TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')          --Ver 1.1 Added to_char
                               || ' '
                               || CONVERT_TIME_N_C (SCH_TIME),
                               'DD-MON-YY HH24:MI:SS') <
                               TO_DATE (
                                     TO_CHAR(I_SCH_DATE,'DD-MON-YYYY')							--Ver 1.1 Added to_char
                                  || ' '
                                  || CONVERT_TIME_N_C (I_SCH_TIME),
                                  'DD-MON-YY HH24:MI:SS')
                 UNION
                 SELECT SCH_FIN_ACTUAL_DATE, SCH_TIME
                   FROM fid_schedule
                  WHERE sch_lic_number = i_sch_lic_number
                        AND UPPER (sch_type) IN ('P', 'N')
                        AND TO_DATE (
                                  TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')					--Ver 1.1 Added to_char
                               || ' '
                               || CONVERT_TIME_N_C (SCH_TIME),
                               'DD-MON-YY HH24:MI:SS') =
                               TO_DATE (
                                     TO_CHAR(I_SCH_DATE,'DD-MON-YYYY')							--Ver 1.1 Added to_char
                                  || ' '
                                  || CONVERT_TIME_N_C (I_SCH_TIME),
                                  'DD-MON-YY HH24:MI:SS')
                        AND sch_number < i_sch_number
                 ORDER BY sch_fin_actual_date DESC, sch_time DESC)
          WHERE ROWNUM = 1;


         /*   DBMS_OUTPUT.put_line (
                   'C_TEMP_SCH_DATE-'
                || C_TEMP_SCH_DATE
                || '-C_TEMP_SCH_TIME-'
                || C_TEMP_SCH_TIME); */

         --COUNT THE NUMBER OF FREE RUNS('F') BETWEEN CLOSEST PREVIOUS SCHEDULE AND INPUT SCH DATE
         SELECT COUNT (*)
           INTO C_NO_FREE_SCH
           FROM FID_SCHEDULE
          WHERE sch_lic_number = i_sch_lic_number --AND SCH_CHA_NUMBER=I_SCH_CHA_NUMBER
                                                 AND UPPER (SCH_TYPE) = 'F'
                AND TO_DATE (
                          TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')					--Ver 1.1 Added to_char
                       || ' '
                       || CONVERT_TIME_N_C (SCH_TIME),
                       'DD-MON-YY HH24:MI:SS') >=
                       to_date (
                             TO_CHAR(C_TEMP_SCH_DATE,'DD-MON-YYYY')
                          || ' '
                          || CONVERT_TIME_N_C (C_TEMP_SCH_TIME),
                          'DD-MON-YY HH24:MI:SS')
                AND TO_DATE (
                          TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')					--Ver 1.1 Added to_char
                       || ' '
                       || CONVERT_TIME_N_C (SCH_TIME),
                       'DD-MON-YY HH24:MI:SS') <
                       to_date (
                          TO_CHAR(I_SCH_DATE,'DD-MON-YYYY') || ' ' || CONVERT_TIME_N_C (I_SCH_TIME),
                          'DD-MON-YY HH24:MI:SS');

         /*     DBMS_OUTPUT.put_line (
                    I_SCH_NUMBER
                 || '-C_NO_FREE_SCH-'
                 || C_NO_FREE_SCH
                 || '-I_LIC_FREE_RPT-'
                 || I_LIC_FREE_RPT); */

         IF C_NO_FREE_SCH < I_LIC_FREE_RPT
         THEN
            PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (C_CURR_YEAR,
                                                            C_CURR_MONTH,
                                                            I_SCH_NUMBER,
                                                            'F');
         ELSE
            IF UPPER (I_SCH_TYPE) = 'P'
            THEN
               PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (C_CURR_YEAR,
                                                               C_CURR_MONTH,
                                                               I_SCH_NUMBER,
                                                               'P');
            END IF;

            IF UPPER (I_SCH_TYPE) = 'N'
            THEN
               PKG_PB_FID_SCHEDVER_PK.PRC_FIN_UPDATE_SCH_TYPE (C_CURR_YEAR,
                                                               C_CURR_MONTH,
                                                               i_sch_number,
                                                               'DN');
            END IF;
         END IF;
      --dbms_output.put_line('============================================================');
      END IF;
   END PRC_FIN_UPD_AFR_FREE_SCH;

   --PURE FINANCE END

   PROCEDURE prc_cost_rule_config_info (
      i_sch_lic_number               IN     fid_license.lic_number%TYPE,
      i_lic_start                    IN     fid_license.lic_start%TYPE,
      i_lic_end                      IN     fid_license.lic_end%TYPE,
      i_cal_month                    IN     fid_license.lic_start%TYPE,
      i_lic_showing_lic              IN     fid_license.lic_showing_lic%TYPE,
      o_alloc_costed_runs               OUT x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE,
      o_sch_window                      OUT x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE,
      o_sw1_start                       OUT x_fin_costing_rule_config.crc_lic_start_from%TYPE,
      o_sw1_end                         OUT x_fin_costing_rule_config.crc_lic_start_from%TYPE,
      o_sw2_start                       OUT x_fin_costing_rule_config.crc_lic_start_from%TYPE,
      o_sw2_end                         OUT x_fin_costing_rule_config.crc_lic_start_from%TYPE,
      o_crc_costed_runs_fin_year_1      OUT x_fin_costing_rule_config.crc_costed_runs_fin_year_1%TYPE)
   AS
      l_cw_1_start                   DATE;
      l_cw_1_end                     DATE;
      l_cw_2_start                   DATE;
      l_cw_2_end                     DATE;
      l_no_of_fin_year               NUMBER;
      l_1_fin_year_sch_cnt           NUMBER;
      l_first_cw_costed_runs         NUMBER;
      l_crc_costed_runs_fin_year_1   NUMBER;
   BEGIN
      IF TO_NUMBER (TO_CHAR (i_lic_start, 'MM')) IN (1, 2, 3)
      THEN
         l_cw_1_start := i_lic_start;
         l_cw_1_end :=
            TO_DATE ('31-MAR-' || TO_CHAR (i_lic_start, 'RRRR'),
                     'DD-MON-YYYY');
         l_cw_2_start :=
            TO_DATE ('1-APR-' || TO_CHAR (i_lic_start, 'RRRR'),
                     'DD-MON-YYYY');
         l_cw_2_end := i_lic_end;

         SELECT COUNT (*)
           INTO l_no_of_fin_year
           FROM (SELECT ADD_MONTHS (
                           TO_DATE (
                              '01-APR' || (TO_CHAR (i_lic_start, 'YYYY') - 1),
                              'DD-MON-YYYY'),
                           ROWNUM - 1)
                           l_temp_month
                   FROM user_objects
                  WHERE ADD_MONTHS (
                           TO_DATE (
                              '01-APR' || (TO_CHAR (i_lic_start, 'YYYY') - 1),
                              'DD-MON-YYYY'),
                           ROWNUM - 1) <= i_lic_end)
          WHERE TO_CHAR (l_temp_month, 'MM') = '04';

         IF l_no_of_fin_year > 2
         THEN
            IF i_cal_month BETWEEN l_cw_1_end + 1 AND l_cw_2_end --LAST_DAY (ADD_MONTHS (l_cw_1_end, 12))
            THEN
               SELECT COUNT (*)
                 INTO l_1_fin_year_sch_cnt
                 FROM fid_schedule, fid_channel
                WHERE     sch_cha_number = cha_number
                      AND sch_lic_number = i_sch_lic_number
                      AND UPPER (sch_type) IN ('N', 'P')
                      --AND sch_fin_actual_date < l_cw_1_end + 1
                      --5+2 Logic Change by Swapnil Start
                     AND sch_fin_actual_date < i_cal_month
                      --Swapnil End
                      ;

              if (NVL (i_lic_showing_lic, 0) <> 0) then
               SELECT crc_costed_runs_fin_year_1
                 INTO l_first_cw_costed_runs
                 FROM x_fin_costing_rule_config
                WHERE i_lic_start BETWEEN crc_lic_start_from
                                      AND crc_lic_start_to
                      AND crc_costed_runs = i_lic_showing_lic;
              else
                 l_first_cw_costed_runs := 0;
              end if;

               IF l_1_fin_year_sch_cnt < l_first_cw_costed_runs
               THEN
                  l_cw_1_end := LAST_DAY (ADD_MONTHS (l_cw_1_end, 12));
                  l_cw_2_start := l_cw_1_end + 1;
               END IF;
            END IF;
         END IF;
      ELSE
         l_cw_1_start := i_lic_start;
         l_cw_1_end :=
            TO_DATE (
               '31-MAR-' || (TO_NUMBER (TO_CHAR (i_lic_start, 'RRRR')) + 1),
               'DD-MON-YYYY');
         l_cw_2_start :=
            TO_DATE (
               '1-APR-' || (TO_NUMBER (TO_CHAR (i_lic_start, 'RRRR')) + 1),
               'DD-MON-YYYY');
         l_cw_2_end := i_lic_end;

         SELECT COUNT (*)
           INTO l_no_of_fin_year
           FROM (SELECT ADD_MONTHS (
                           TO_DATE (
                              '01-APR' || TO_CHAR (i_lic_start, 'YYYY'),
                              'DD-MON-YYYY'),
                           ROWNUM - 1)
                           l_temp_month
                   FROM user_objects
                  WHERE ADD_MONTHS (
                           TO_DATE (
                              '01-APR' || TO_CHAR (i_lic_start, 'YYYY'),
                              'DD-MON-YYYY'),
                           ROWNUM - 1) <= i_lic_end)
          WHERE TO_CHAR (l_temp_month, 'MM') = '04';

         IF l_no_of_fin_year > 2
         THEN
            IF i_cal_month BETWEEN l_cw_1_end + 1 AND l_cw_2_end --LAST_DAY (ADD_MONTHS (l_cw_1_end, 12))
            THEN
               SELECT COUNT (*)
                 INTO l_1_fin_year_sch_cnt
                 FROM fid_schedule, fid_channel
                WHERE     sch_cha_number = cha_number
                      AND sch_lic_number = i_sch_lic_number
                      AND UPPER (sch_type) IN ('N', 'P')
                      --AND sch_fin_actual_date < l_cw_1_end + 1
                      --5+2 Logic Change by Swapnil Start
                      AND sch_fin_actual_date < i_cal_month
                      --Swapnil End
                      ;

             if (NVL (i_lic_showing_lic, 0) <> 0)
             then
               SELECT crc_costed_runs_fin_year_1
                 INTO l_first_cw_costed_runs
                 FROM x_fin_costing_rule_config
                WHERE i_lic_start BETWEEN crc_lic_start_from
                                      AND crc_lic_start_to
                      AND crc_costed_runs = i_lic_showing_lic;
             else
                l_first_cw_costed_runs := 0;
             end if;

               IF l_1_fin_year_sch_cnt < l_first_cw_costed_runs
               THEN
                  l_cw_1_end := LAST_DAY (ADD_MONTHS (l_cw_1_end, 12));
                  l_cw_2_start := l_cw_1_end + 1;
               END IF;
            END IF;
         END IF;
      END IF;

      IF l_cw_2_start > l_cw_2_end
      THEN
         l_cw_2_start := l_cw_1_end + 1;
         l_cw_2_end := l_cw_1_end + 1;
      END IF;

      IF (NVL (i_lic_showing_lic, 0) <> 0)
      THEN
         BEGIN
            SELECT (CASE
                       WHEN i_cal_month BETWEEN l_cw_1_start AND l_cw_1_end
                            AND i_lic_end <= l_cw_1_end
                       THEN
                          i_lic_showing_lic
                       --5+2 Logic Change by Swapnil Start
                       WHEN i_cal_month BETWEEN l_cw_1_start AND l_cw_1_end
                            AND i_lic_end > l_cw_1_end
                            and l_1_fin_year_sch_cnt < l_first_cw_costed_runs	
                       THEN
                          i_lic_showing_lic
                       --Swapnil End
                       WHEN i_cal_month BETWEEN l_cw_1_start AND l_cw_1_end
                            AND i_lic_end > l_cw_1_end
                       THEN
                          crc_costed_runs_fin_year_1
                       WHEN i_cal_month BETWEEN l_cw_2_start AND l_cw_2_end
                       THEN
                          crc_costed_runs_fin_year_2
                       ELSE
                          0
                    END)
                      l_cost,
                   (CASE
                       WHEN i_cal_month BETWEEN l_cw_1_start AND l_cw_1_end
                       THEN
                          1
                       WHEN i_cal_month BETWEEN l_cw_2_start AND l_cw_2_end
                       THEN
                          2
                       ELSE
                          0
                    END)
                      l_sw,
                   l_cw_1_start,
                   l_cw_1_end,
                   l_cw_2_start,
                   l_cw_2_end,
                   CRC_COSTED_RUNS_FIN_YEAR_1
              INTO o_alloc_costed_runs,
                   o_sch_window,
                   o_sw1_start,
                   o_sw1_end,
                   o_sw2_start,
                   o_sw2_end,
                   o_crc_costed_runs_fin_year_1
              FROM x_fin_costing_rule_config
             WHERE i_lic_start BETWEEN crc_lic_start_from
                                   AND crc_lic_start_to
                   AND crc_costed_runs = i_lic_showing_lic;
         /*     dbms_output.put_line('i_cal_month '|| i_cal_month);
              dbms_output.put_line('o_alloc_costed_runs '|| o_alloc_costed_runs);
              dbms_output.put_line('o_sch_window '|| o_sch_window);
              dbms_output.put_line('o_sw1_start '|| o_sw1_start);
              dbms_output.put_line('o_sw1_end '|| o_sw1_end);
              dbms_output.put_line('o_crc_costed_runs_fin_year_1 '|| o_crc_costed_runs_fin_year_1);*/



         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               INSERT INTO fid_wrn_svr (wrn_period,
                                        wrn_curr_date,
                                        wrn_comments,
                                        wrn_lic_number,
                                        wrn_cha_number)
                    VALUES (
                              TO_NUMBER (TO_CHAR (i_cal_month, 'YYYYMM')),
                              SYSDATE,
                                 'License Number '
                              || i_sch_lic_number
                              || ' does not lie in any costing rule ',
                              i_sch_lic_number,
                              NULL);

               raise_application_error (
                  -20002,
                     'License Number '
                  || i_sch_lic_number
                  || ' does not lie in any costing rule');
         END;
      ELSE
         o_alloc_costed_runs := 0;
         o_sch_window := 1;
         o_sw1_start := l_cw_1_start;
         o_sw1_end := l_cw_1_end;
         o_sw2_start := l_cw_2_start;
         o_sw2_end := l_cw_2_end;
         o_crc_costed_runs_fin_year_1 := l_crc_costed_runs_fin_year_1;
      END IF;
   end prc_cost_rule_config_info;

--Ver 1.1 Start
PROCEDURE prc_fin_upd_omnibus_sch(
   i_sch_number       IN NUMBER,
   i_sch_lic_number   IN NUMBER,
   i_sch_cha_number   IN NUMBER,
   i_cha_start_time   IN NUMBER,
   i_sch_date         IN DATE,
   i_sch_time         IN NUMBER,
   i_lic_free_rpt     IN NUMBER,
   i_lic_rpt_period   IN NUMBER,
   i_sch_type         IN VARCHAR2)
/*********************************************************************************************
NAME    : prc_fin_upd_omnibus_sch
PURPOSE : This package is used to update the schedule for business Rule 'F'
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Ver        Date          Author           Description
---------  ----------    ---------------  ---------------------------------------------------
1.0        28-Jul-2015   Jawahar Garg     Initial Version.
*********************************************************************************************/
AS
   c_sch_in_rpt_period   NUMBER;
   c_no_free_sch         NUMBER;
   c_temp_sch_time       NUMBER;
   c_curr_month          NUMBER;
   c_curr_year           number;
   v_is_weekend_sch      number;
   v_other_sch_present    number;
   V_SCH_CNT             number := 0;
   V_LIC_ALREADY_EXISTS  number;
   V_GEN_SER_NUMBER      number;
   V_LIC_SCH_ID          number;

   v_sch_end_date_time   DATE;
   v_sch_date            DATE
      := TO_DATE (
               TO_CHAR (i_sch_date, 'DD-MON-RRRR')
            || ' '
            || convert_time_n_c (i_sch_time),
            'DD-MON-RRRR HH24:MI:SS');

   v_previous_sch_date   date;
   v_next_sch_date       date;
   v_week_first_day      date;
   v_week_last_day       DATE;
   c_rpt_period          DATE;
   c_temp_sch_date       DATE;
   v_week_sat_date       DATE;
   v_week_sun_date       DATE;
   v_pre_sch_date        DATE;

   v_com_short_name      fid_company.com_short_name%TYPE;

   v_prog_type           varchar2 (3);
   v_lic_sch_exists      varchar2(1) default 'N';
   V_STACK_EPI           varchar2(1) default 'N';
   v_lic_number          number;
begin

delete X_TEMP_SCH_WEEKEND_DATA;

   SELECT com_short_name,
          DECODE (x_fnc_get_prog_type (lic_budget_code),
                  'Y', 'SER',
                  'N', 'FEA'),
          (SELECT gen_ser_number from fid_general fg where fg.gen_refno = fl.lic_gen_refno)
     into V_COM_SHORT_NAME,
          V_PROG_TYPE,
          v_gen_ser_number
     FROM fid_license fl, fid_contract fc, fid_company fcom
    WHERE     fl.lic_con_number = fc.con_number
          and fcom.com_number = fc.con_com_number
          AND fl.lic_number = i_sch_lic_number;


   /*-------------------------------------------------------------*/
   /*GET SCHEDULE END DATE TIME TO VALIDATE AGAINST REPEAT PERIOD */
   /*-------------------------------------------------------------*/
    SELECT
           TO_DATE(
                (case when SCH_TIME > SCH_END_TIME
                 then TO_CHAR(SCH_FIN_ACTUAL_DATE + 1,'DD-MON-RRRR')
                 else
                 TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-RRRR')
                 end
                 )||' '||X_MO_CONVERT_TIME(DECODE(SCH_END_TIME,86400,86399,SCH_END_TIME))
           ,'DD-MON-RRRR HH24:MI:SS'
            )
     into v_sch_end_date_time
     from fid_schedule
    where sch_number = i_sch_number;

   c_rpt_period := v_sch_end_date_time  - ( i_lic_rpt_period + ((300/3600)/24) );     --[21-Sept-2015]Jawahar.Garg[Omnibus_CR]Consider additional 5 mins in free repeat period
   /*---------------------------------------------------------------------------*/
   /*GET THE NUMBER OF SCHDULES HAVING SCH_TYPE AS 'P' OR 'N'                   */
   /*BETWEEN THE INPUT SCHEDULE DATE AND REPEAT PERIOD SPECIFIED FOR THE LICENSE*/
   /*---------------------------------------------------------------------------*/

   SELECT SUM (a)
     INTO c_sch_in_rpt_period
     FROM (SELECT COUNT (*) a
             FROM fid_schedule
            WHERE     sch_lic_number = i_sch_lic_number
                  AND sch_cha_number = i_sch_cha_number
                  AND UPPER (sch_type) IN ('P', 'N')
                  and to_date (
                            TO_CHAR(sch_fin_actual_date,'DD-MON-YYYY')
                         || ' '
                         || convert_time_n_c (sch_time),
                         'DD-MM-YY HH24:MI:SS') >= c_rpt_period
                  and to_date (
                            TO_CHAR(sch_fin_actual_date,'DD-MON-YYYY')
                         || ' '
                         || convert_time_n_c (sch_time),
                         'DD-MM-YY HH24:MI:SS') < v_sch_date
           UNION
           SELECT COUNT (*) a
             FROM fid_schedule
            WHERE     sch_lic_number = i_sch_lic_number
                  AND sch_cha_number = i_sch_cha_number
                  AND UPPER (sch_type) IN ('P', 'N')
                  and to_date (
                            TO_CHAR(sch_fin_actual_date,'DD-MON-YYYY')
                         || ' '
                         || convert_time_n_c (sch_time),
                         'DD-MM-YY HH24:MI:SS') = v_sch_date
                  AND sch_number < i_sch_number);

   IF c_sch_in_rpt_period = 0
   THEN
      IF TO_CHAR (v_sch_date, 'D') IN ('1', '7') AND v_prog_type = 'SER' /*i.e Sat or Sunday */
      THEN
         v_week_first_day :=
            CASE
               when to_char (v_sch_date, 'D') = 1 then trunc (v_sch_date - 6)
               ELSE (TRUNC (v_sch_date, 'D')+1)
            END;

         v_week_last_day :=
            TO_DATE (
               TO_CHAR (v_week_first_day + 4, 'DD-MON-RRRR') || '23:59:59',
               'DD-MON-RRRR HH24:MI:SS');              /*i.e Friday-23:59:59*/

         v_week_sat_date := v_week_first_day + 5;
         v_week_sun_date :=
            TO_DATE (
               TO_CHAR (v_week_first_day + 6, 'DD-MON-RRRR') || '23:59:59',
               'DD-MON-RRRR HH24:MI:SS');              /*i.e Sunday-23:59:59*/

         /*--------------------------------------*/
         /*Get premier schedule for the license  */
         /*--------------------------------------*/
         v_pre_sch_date := x_pkg_stack_scheduling.x_fnc_get_premier_date_by_ch (i_lic_number   => i_sch_lic_number,
                                          i_cha_number   => i_sch_cha_number);

         if (V_PRE_SCH_DATE between V_WEEK_FIRST_DAY and V_WEEK_LAST_DAY)
         THEN
            insert into X_TEMP_SCH_WEEKEND_DATA
            (
            SWD_ID,
            SWd_SCH_NUMBER,
            SWD_SCH_LIC_NUMBER,
            swd_sch_cha_number,
            SWd_GEN_SER_NUMBER,
            swd_FIN_ACTUAL_DATE
            )
            select rownum,
            SCH_NUMBER,
            SCH_LIC_NUMBER,
            sch_cha_number,
            (select gen_ser_number from fid_general fg ,fid_license fl where fl.lic_gen_refno = fg.gen_refno and fl.lic_number = sch_lic_number),
            SCH_FIN_ACTUAL_DATE
            FROM (
                  select SCH_NUMBER,
                  SCH_LIC_NUMBER,
                  sch_cha_number,
                  SCH_FIN_ACTUAL_DATE,
                  sch_actual_end_date
                  from
                  (
                 select FSH.SCH_NUMBER,
                        fsh.sch_actual_end_date,
                        FSH.SCH_LIC_NUMBER,
                        fsh.sch_cha_number,
                        TO_DATE (TO_CHAR(SCH_FIN_ACTUAL_DATE,'DD-MON-YYYY')|| ' '|| CONVERT_TIME_N_C (SCH_TIME),'DD-MM-RR HH24:MI:SS')as SCH_FIN_ACTUAL_DATE
                        FROM fid_schedule fsh
                        where FSH.SCH_CHA_NUMBER = i_sch_cha_number
                        /*and exists(select 1 from fid_license where lic_number=sch_lic_number
                        and lic_con_number=65070
                        and LIC_NUMBER = 1108531
                        )*/
                        and to_number(to_char (sch_date,'RRRRMMDD')) between to_number(to_char ((v_week_sat_date-1),'RRRRMMDD')) AND to_number(to_char ( v_week_sun_date,'RRRRMMDD'))
                  )
                  where SCH_FIN_ACTUAL_DATE between V_WEEK_SAT_DATE and V_WEEK_SUN_DATE
                  and SCH_ACTUAL_END_DATE <= V_WEEK_SUN_DATE
                  order by SCH_FIN_ACTUAL_DATE
                );

                BEGIN
                     select SWD_ID
                       into V_LIC_SCH_ID
                       from X_TEMP_SCH_WEEKEND_DATA
                      where SWD_SCH_NUMBER = I_SCH_NUMBER
                        and SWD_SCH_LIC_NUMBER = i_sch_lic_number;
               EXCEPTION
               when NO_DATA_FOUND then
               V_LIC_SCH_ID := null;
               V_STACK_EPI := 'N';
               c_sch_in_rpt_period :=0;
               end;

               IF V_COM_SHORT_NAME = 'SABC'
               THEN

                    if   (FNC_GET_BACK_TO_BACK_SCH ((V_LIC_SCH_ID - 1),
                                                   I_SCH_LIC_NUMBER,
                                                   V_GEN_SER_NUMBER,
                                                   V_WEEK_FIRST_DAY,
                                                   V_WEEK_LAST_DAY
                                                   ) > 0
                         )or
                         (FNC_GET_BACK_TO_BACK_SCH ((V_LIC_SCH_ID + 1),
                                                   I_SCH_LIC_NUMBER,
                                                   V_GEN_SER_NUMBER,
                                                   V_WEEK_FIRST_DAY,
                                                   V_WEEK_LAST_DAY
                                                   ) > 0
                         )
                   then
                        V_STACK_EPI := 'Y';
                        c_sch_in_rpt_period := 1;
                   else
                        V_STACK_EPI := 'N';
                        c_sch_in_rpt_period :=0;
                   end if;

                ELSIF V_COM_SHORT_NAME != 'SABC'
                then
                     if (  (FNC_GET_BACK_TO_BACK_SCH ((V_LIC_SCH_ID - 1),
                                                   I_SCH_LIC_NUMBER,
                                                   V_GEN_SER_NUMBER,
                                                   V_WEEK_FIRST_DAY,
                                                   V_WEEK_LAST_DAY
                                                   ) > 0
                         )AND
                         (FNC_GET_BACK_TO_BACK_SCH ((V_LIC_SCH_ID - 2),
                                                   I_SCH_LIC_NUMBER,
                                                   V_GEN_SER_NUMBER,
                                                   V_WEEK_FIRST_DAY,
                                                   V_WEEK_LAST_DAY
                                                   ) > 0
                         )
                      )or
                      (
                        (FNC_GET_BACK_TO_BACK_SCH ((V_LIC_SCH_ID + 1),
                                                   I_SCH_LIC_NUMBER,
                                                   V_GEN_SER_NUMBER,
                                                   V_WEEK_FIRST_DAY,
                                                   V_WEEK_LAST_DAY
                                                   ) > 0
                         )and
                         (FNC_GET_BACK_TO_BACK_SCH ((V_LIC_SCH_ID + 2),
                                                   I_SCH_LIC_NUMBER,
                                                   V_GEN_SER_NUMBER,
                                                   V_WEEK_FIRST_DAY,
                                                   V_WEEK_LAST_DAY
                                                   ) > 0

                      )
                      )or

                      ( (FNC_GET_BACK_TO_BACK_SCH ((V_LIC_SCH_ID - 1),
                                                   I_SCH_LIC_NUMBER,
                                                   V_GEN_SER_NUMBER,
                                                   V_WEEK_FIRST_DAY,
                                                   V_WEEK_LAST_DAY
                                                   ) > 0
                         )and
                         (FNC_GET_BACK_TO_BACK_SCH ((V_LIC_SCH_ID + 1),
                                                   I_SCH_LIC_NUMBER,
                                                   V_GEN_SER_NUMBER,
                                                   V_WEEK_FIRST_DAY,
                                                   V_WEEK_LAST_DAY
                                                   ) > 0
                      )
                      )
                   then
                        V_STACK_EPI := 'Y';
                        c_sch_in_rpt_period := 1;
                   else
                        V_STACK_EPI := 'N';
                        c_sch_in_rpt_period :=0;
                   end if;

                END IF;
         END IF;
         END IF;
   ELSE
      SELECT sch_fin_actual_date, sch_time
        INTO c_temp_sch_date, c_temp_sch_time
        FROM (SELECT sch_fin_actual_date, sch_time
                FROM fid_schedule
               WHERE     sch_lic_number = i_sch_lic_number
                     AND sch_cha_number = i_sch_cha_number
                     AND UPPER (sch_type) IN ('P', 'N')
                     and to_date (
                               TO_CHAR(sch_fin_actual_date,'DD-MON-YYYY')
                            || ' '
                            || convert_time_n_c (sch_time),
                            'DD-MM-YY HH24:MI:SS') >= c_rpt_period
                     and to_date (
                               TO_CHAR(sch_fin_actual_date,'DD-MON-YYYY')
                            || ' '
                            || convert_time_n_c (sch_time),
                            'DD-MM-YY HH24:MI:SS') < v_sch_date
              UNION
              SELECT sch_fin_actual_date, sch_time
                FROM fid_schedule
               WHERE     sch_lic_number = i_sch_lic_number
                     AND UPPER (sch_type) IN ('P', 'N')
                     and to_date (
                               TO_CHAR(sch_fin_actual_date,'DD-MON-YYYY')
                            || ' '
                            || convert_time_n_c (sch_time),
                            'DD-MM-YY HH24:MI:SS') = v_sch_date
                     AND sch_number < i_sch_number
              ORDER BY sch_fin_actual_date DESC, sch_time DESC)
       WHERE ROWNUM = 1;
   END IF;

   /*-----------------------------------------------------*/
   /*CHECK IF ANY SCHEDULE EXIST IN THE ABOVE DATE RANGE  */
   /*-----------------------------------------------------*/

   IF c_sch_in_rpt_period = 0
   THEN
      /*--------------------------------------------------------------*/
      /* IF NO SCHEDULES EXIST THE UPDATE THE SCHEDULES AS 'P' OR 'N' */
      /* DEPENDING UPON THE NUMBER OF COSTED RUNS REMAINING           */
      /*--------------------------------------------------------------*/
      --DBMS_OUTPUT.put_line ('In paid not paid-P');

      IF UPPER (i_sch_type) = 'P'
      THEN
         pkg_pb_fid_schedver_pk.prc_fin_update_sch_type (c_curr_year,
                                                         c_curr_month,
                                                         i_sch_number,
                                                         'P');
      END IF;

      IF UPPER (i_sch_type) = 'N'
      THEN
         --  DBMS_OUTPUT.put_line ('In paid not paid-N');
         pkg_pb_fid_schedver_pk.prc_fin_update_sch_type (c_curr_year,
                                                         c_curr_month,
                                                         i_sch_number,
                                                         'DN');
      END IF;
   ELSE
      /*----------------------------------------------------------------------------------------------*/
      /*IF SCHEDULES EXIST BETWEEN THE INPUT SCHEDULE DATE AND REPEAT PERIOD SPECIFIED FOR THE LICENSE*/
      /*THEN GET THE CLOSEST PREVIOUS SCHEDULE ON CHANNEL HAVING SCHEDULE TYPE AS 'P' OR 'N'          */
      /*COUNT THE NUMBER OF FREE RUNS('F') BETWEEN CLOSEST PREVIOUS SCHEDULE AND INPUT SCH DATE       */
      /*----------------------------------------------------------------------------------------------*/

      if v_stack_epi ='N'
      THEN

      SELECT COUNT (*)
        INTO c_no_free_sch
        FROM fid_schedule
       where     sch_lic_number = i_sch_lic_number
             AND sch_cha_number = i_sch_cha_number
             AND UPPER (sch_type) = 'F'
             AND TO_DATE (
                    sch_fin_actual_date || ' ' || convert_time_n_c (sch_time),
                    'DD-MM-YY HH24:MI:SS') >=
                    TO_DATE (
                          c_temp_sch_date
                       || ' '
                       || convert_time_n_c (c_temp_sch_time),
                       'DD-MM-YY HH24:MI:SS')
             AND TO_DATE (
                    sch_fin_actual_date || ' ' || convert_time_n_c (sch_time),
                    'DD-MM-YY HH24:MI:SS') < v_sch_date;

    /*  DBMS_OUTPUT.put_line ('lic_number -'|| i_sch_lic_number||' - '||
            i_sch_number
         || '-C_NO_FREE_SCH-'
         || c_no_free_sch
         || '-I_LIC_FREE_RPT-'
         || i_lic_free_rpt);
     */
      else
          c_no_free_sch := 0;

      ENd IF;

      IF c_no_free_sch < i_lic_free_rpt
      then
        pkg_pb_fid_schedver_pk.prc_fin_update_sch_type (c_curr_year,
                                                         c_curr_month,
                                                         i_sch_number,
                                                         'F');
      ELSE
         IF UPPER (i_sch_type) = 'P'
         then
           pkg_pb_fid_schedver_pk.prc_fin_update_sch_type (c_curr_year,
                                                            c_curr_month,
                                                            i_sch_number,
                                                            'P');
         END IF;

         IF UPPER (i_sch_type) = 'N'
         then
            pkg_pb_fid_schedver_pk.prc_fin_update_sch_type (c_curr_year,
                                                            c_curr_month,
                                                            i_sch_number,
                                                            'DN');
         END IF;

      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
   ROLLBACK;
      raise_application_error (
         -20009,
            SUBSTR (SQLERRM, 1, 200)
         || '. Line No -'
         || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
end prc_fin_upd_omnibus_sch;

function FNC_GET_BACK_TO_BACK_SCH
								  (
								   I_SWD_ID 		in number,
								   i_sch_lic_number IN NUMBER,
								   i_gen_ser_number in NUMBER,
								   I_WEEK_FIRST_DAY in date,
								   I_WEEK_LAST_DAY 	in date
								  )return number
AS

v_sch_exists NUMBER;

begin
       select COUNT(1)
         INTO v_sch_exists
         from X_TEMP_SCH_WEEKEND_DATA
        where SWD_ID = I_SWD_ID
          and SWD_GEN_SER_NUMBER =  I_GEN_SER_NUMBER
          and SWD_SCH_LIC_NUMBER <> I_SCH_LIC_NUMBER
          and X_PKG_STACK_SCHEDULING.X_FNC_GET_PREMIER_DATE_BY_CH (SWD_SCH_LIC_NUMBER,SWD_SCH_CHA_NUMBER)
      BETWEEN I_WEEK_FIRST_DAY AND I_WEEK_LAST_DAY;

   RETURN  v_sch_exists;

END FNC_GET_BACK_TO_BACK_SCH;
--ver 1.1 End
end PKG_PB_FID_SCHEDVER_PK;
/