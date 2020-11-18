CREATE OR REPLACE PACKAGE          "X_PKG_LINEAR_RECON" AS

/**************************************************************************
REM Module          : MNET Finance
REM Client          : MNET
REM File Name       : X_PKG_LINEAR_RECON
REM Purpose         : Generates search results based on Recon type selected
REM Written By      : Zeshan Khan
REM Date            : 12-May-2016
REM Type            : Database Package
REM Change History  : Created
REM **************************************************************************/

  G_PERIOD DATE;

	TYPE C_INV_RECON	IS REF CURSOR;
	TYPE C_LIAB_RECON	IS REF CURSOR;
	TYPE C_PREPAY_RECON IS REF CURSOR;

--****************************************************************
-- This procedure is called for fetching Recon Data
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_RECON_SEARCH (
      I_CHANNEL_COMPANY			  	IN		      FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	    FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		      FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		      VARCHAR2,
      I_RECON_TYPE		       		IN    	    VARCHAR2,
      I_RECON_FROM          		IN    	    DATE,
      I_RECON_TO				        IN		      DATE,
      O_INV_RECON							    OUT				X_PKG_LINEAR_RECON.C_INV_RECON,
      O_LIAB_RECON							  OUT				X_PKG_LINEAR_RECON.C_LIAB_RECON,
      O_PREPAY_RECON						  OUT				X_PKG_LINEAR_RECON.C_PREPAY_RECON
   );

--****************************************************************
-- This procedure is called for fetching Inventory Recon Data
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_INV_RECON (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_INV_RECON							    OUT		X_PKG_LINEAR_RECON.C_INV_RECON
   );

--****************************************************************
-- This procedure is called for fetching Prepayment Recon Data
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_PREPAY_RECON (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_PREPAY_RECON						  OUT		X_PKG_LINEAR_RECON.C_PREPAY_RECON
   );

--****************************************************************
-- This procedure is called for fetching Liability Recon Data
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_LIAB_RECON (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_LIAB_RECON							  OUT		X_PKG_LINEAR_RECON.C_LIAB_RECON
   );

--****************************************************************
-- This procedure is called for fetching Inventory Recon Data
-- for not reconciled licenses
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_INV_RECON_NR (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_INV_RECON							    OUT		X_PKG_LINEAR_RECON.C_INV_RECON
   );

--****************************************************************
-- This procedure is called for fetching Prepayment Recon Data
-- for not reconciled licenses
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_PREPAY_RECON_NR (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_PREPAY_RECON						  OUT		X_PKG_LINEAR_RECON.C_PREPAY_RECON
   );

--****************************************************************
-- This procedure is called for fetching Liability Recon Data
-- for not reconciled licenses
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_LIAB_RECON_NR (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_LIAB_RECON							  OUT		X_PKG_LINEAR_RECON.C_LIAB_RECON
   );

--****************************************************************
-- This function formats the input value.
-- REM Client - MNET
--****************************************************************
  FUNCTION X_FNC_FORMAT_NUMBER (
  I_DATA_VALUE                  IN      NUMBER
  )
  RETURN VARCHAR2;

--****************************************************************
-- This function formats the input value.
-- REM Client - MNET
--****************************************************************
  FUNCTION X_FNC_ROUNDED_VALUE_LIC (
  I_AMOUNT                      IN      NUMBER,
  I_LIC_CURR                    IN      VARCHAR2
  )
  RETURN NUMBER;

--****************************************************************
-- This function formats the input value.
-- REM Client - MNET
--****************************************************************
  FUNCTION X_FNC_ROUNDED_VALUE_LOC (
  I_AMOUNT                      IN      NUMBER,
  I_LIC_CURR                    IN      VARCHAR2
  )
  RETURN NUMBER;

--****************************************************************
-- This function gets the period value.
-- REM Client - MNET
--****************************************************************
  FUNCTION X_FNC_GET_PERIOD RETURN DATE;

--****************************************************************
-- This procedure is called for setting period value.
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_SET_PERIOD(I_PERIOD DATE);

--****************************************************************
-- FINACE DEV PHASE ONE [ANKUR KASAR]
-- REM Client - MNET
--****************************************************************

  PROCEDURE X_PRC_INV_RECON_SEARCH (
    I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
    I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
    I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
    I_RECON_CURRENCY				  IN		  VARCHAR2,
    I_RECON_FROM          		IN    	DATE,
    I_RECON_TO				        IN		  DATE,
    O_INV_RECON							    OUT		X_PKG_LINEAR_RECON.C_INV_RECON
 );

  PROCEDURE X_PRC_PREPAY_RECON_SEARCH (
    I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
    I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
    I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
    I_RECON_CURRENCY				  IN		  VARCHAR2,
    I_RECON_FROM          		IN    	DATE,
    I_RECON_TO				        IN		  DATE,
    O_PREPAY_RECON						  OUT		X_PKG_LINEAR_RECON.C_PREPAY_RECON
 );

  PROCEDURE X_PRC_LIAB_RECON_SEARCH (
    I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
    I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
    I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
    I_RECON_CURRENCY				  IN		  VARCHAR2,
    I_RECON_FROM          		IN    	DATE,
    I_RECON_TO				        IN		  DATE,
    O_LIAB_RECON							OUT		  X_PKG_LINEAR_RECON.C_LIAB_RECON
 );

--****************************************************************
-- FINACE DEV PHASE ONE [ANKUR KASAR]
-- REM Client - MNET
--****************************************************************
END X_PKG_LINEAR_RECON;
/


CREATE OR REPLACE PACKAGE BODY          "X_PKG_LINEAR_RECON"
AS

  PROCEDURE X_PRC_RECON_SEARCH (
      I_CHANNEL_COMPANY			  	IN		      FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	    FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		      FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		      VARCHAR2,
      I_RECON_TYPE		       		IN    	    VARCHAR2,
      I_RECON_FROM          		IN    	    DATE,
      I_RECON_TO				        IN		      DATE,
      O_INV_RECON							  OUT		  		X_PKG_LINEAR_RECON.C_INV_RECON,
      O_LIAB_RECON							OUT	  			X_PKG_LINEAR_RECON.C_LIAB_RECON,
      O_PREPAY_RECON						OUT 				X_PKG_LINEAR_RECON.C_PREPAY_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Recon Data
-- REM Client - MNET
--****************************************************************
	L_QUERY			VARCHAR2(100);
BEGIN

	L_QUERY := 'SELECT * FROM DUAL WHERE 1 = 2';

	IF I_RECON_TYPE = '%'
	THEN

				X_PKG_LINEAR_RECON.X_PRC_PREPAY_RECON_SEARCH(
													 I_CHANNEL_COMPANY
													,I_LICENSE_TYPE
													,I_LICENSE_CURRENCY
													,I_RECON_CURRENCY
													,I_RECON_FROM
													,I_RECON_TO
													,O_PREPAY_RECON);

				X_PKG_LINEAR_RECON.X_PRC_LIAB_RECON_SEARCH(
													 I_CHANNEL_COMPANY
													,I_LICENSE_TYPE
													,I_LICENSE_CURRENCY
													,I_RECON_CURRENCY
													,I_RECON_FROM
													,I_RECON_TO
													,O_LIAB_RECON);

				X_PKG_LINEAR_RECON.X_PRC_INV_RECON_SEARCH(
													 I_CHANNEL_COMPANY
													,I_LICENSE_TYPE
													,I_LICENSE_CURRENCY
													,I_RECON_CURRENCY
													,I_RECON_FROM
													,I_RECON_TO
													,O_INV_RECON);

	ELSIF I_RECON_TYPE = 'I'
		THEN
			X_PKG_LINEAR_RECON.X_PRC_INV_RECON_SEARCH(I_CHANNEL_COMPANY
												,I_LICENSE_TYPE
												,I_LICENSE_CURRENCY
												,I_RECON_CURRENCY
												,I_RECON_FROM
												,I_RECON_TO
												,O_INV_RECON);
      OPEN O_PREPAY_RECON FOR L_QUERY;
      OPEN O_LIAB_RECON FOR L_QUERY;

  ELSIF I_RECON_TYPE = 'P'
		THEN
			X_PKG_LINEAR_RECON.X_PRC_PREPAY_RECON_SEARCH(
                         I_CHANNEL_COMPANY
												,I_LICENSE_TYPE
												,I_LICENSE_CURRENCY
												,I_RECON_CURRENCY
												,I_RECON_FROM
												,I_RECON_TO
												,O_PREPAY_RECON);
      OPEN O_LIAB_RECON FOR L_QUERY;
      OPEN O_INV_RECON FOR L_QUERY;

  ELSIF I_RECON_TYPE = 'L'
		THEN
			X_PKG_LINEAR_RECON.X_PRC_LIAB_RECON_SEARCH(
                         I_CHANNEL_COMPANY
												,I_LICENSE_TYPE
												,I_LICENSE_CURRENCY
												,I_RECON_CURRENCY
												,I_RECON_FROM
												,I_RECON_TO
												,O_LIAB_RECON);
      OPEN O_INV_RECON FOR L_QUERY;
      OPEN O_PREPAY_RECON FOR L_QUERY;

	END IF;

END X_PRC_RECON_SEARCH;

  PROCEDURE X_PRC_INV_RECON (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_INV_RECON							    OUT		X_PKG_LINEAR_RECON.C_INV_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Inventory Recon Data
-- REM Client - MNET
--****************************************************************
   L_START_YYYYMM			        NUMBER;
   L_END_YYYYMM				        NUMBER;
   L_QUERY                    VARCHAR2(5000);
   L_LTYPE_GROUP_QUERY        VARCHAR2(400);
   L_GROUP_QUERY              VARCHAR2(400);
   BEGIN

		L_START_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_FROM, 'YYYYMM'));
		L_END_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_TO, 'YYYYMM'));

    L_LTYPE_GROUP_QUERY := '
            )
      GROUP BY
        IR_CHA_COM_SHORT_NAME,
        IR_LIC_CUR,
        IR_LOC_CUR,
        IR_YYYYMM,
        ROLLUP(IR_LIC_TYPE)
      ORDER BY
        IR_CHA_COM_SHORT_NAME,
        IR_LIC_CUR,
        IR_LOC_CUR,
        IR_YYYYMM,
        IR_LIC_TYPE
        ';


    L_GROUP_QUERY := '
            )
      GROUP BY
        IR_CHA_COM_SHORT_NAME,
        IR_LIC_CUR,
        IR_LOC_CUR,
        IR_YYYYMM
      ORDER BY
        IR_CHA_COM_SHORT_NAME,
        IR_LIC_CUR,
        IR_LOC_CUR,
				IR_YYYYMM';

    IF I_RECON_CURRENCY = 'LIC' --License Currency
		THEN
            L_QUERY := '
            SELECT
            IR_CHA_COM_SHORT_NAME "Channel Company",
            IR_LIC_CUR "Lic Currency",
            IR_LIC_CUR "Recon Currency",
            ';
            IF I_LICENSE_TYPE IS NOT NULL
            THEN
            L_QUERY := L_QUERY ||'NVL(IR_LIC_TYPE,''CONSOLIDATED'') "Lic Type",
              ';
            END IF;

            L_QUERY := L_QUERY || 'TO_CHAR(TO_DATE(IR_YYYYMM, ' || '''YYYYMM''' || '),' || '''Mon-YY''' || ') YEAR_MONTH,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND(SUM(DIFFERENCE))) "Difference",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_OB_ASSET_VALUE)) "O/B Asset Value",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_OB_COST)*(-1))) "O/B Cost",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_OB_INVENTORY)) "O/B Inventory",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_ADDITIONS)) "Additions",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_FLF_PRICE_CHANGE)) "FLF Price Changes/Revaluations",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_CANCELLATIONS)) "Cancellations",
         -- X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_REVALUATIONS)) "Revaluations",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_REVERSAL)) "Reversals",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_COS_COST)*(-1))) "Cost of Sales",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_PIE_FEE)*(-1))) "Inventory Expiry Fee",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_PIE_COST)) "Inventory Expiry Cost",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_CB_ASSET_VALUE)) "C/B Asset Value",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_CB_COST)*(-1))) "C/B Cost",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_CB_INVENTORY)) "C/B Inventory",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(CALC_ASSET_VALUE)) "Calculated Asset Value",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_CALC_COST)*(-1))) "Calculated Cost",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(CB_CALC)) "Calculated C/B"
            FROM
            (
                SELECT
                IR_CHA_COM_SHORT_NAME,
                IR_LIC_CUR,
                IR_LOC_CUR,
                IR_LIC_TYPE,
                --TO_CHAR(TO_DATE(IR_YYYYMM, ' || '''YYYYMM''' || '),' || '''Mon-YY''' || ') YEAR_MONTH,
								IR_YYYYMM,
                IR_LIC_ADDITIONS,
                IR_LIC_CANCELLATIONS,
                IR_LIC_FLF_PRICE_CHANGE,
                IR_LIC_REVALUATIONS,
                IR_LIC_REVERSAL,
                IR_LIC_COS_COST,
                IR_LIC_OB_ASSET_VALUE,
                IR_LIC_OB_COST,
                IR_LIC_OB_INVENTORY,
                IR_LIC_PIE_FEE,
                IR_LIC_PIE_COST,
                IR_LIC_CB_ASSET_VALUE,
                IR_LIC_CB_COST,
                IR_LIC_CB_INVENTORY,
                (NVL(IR_LIC_ADDITIONS,0) + NVL(IR_LIC_CANCELLATIONS,0) + NVL(IR_LIC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LIC_REVERSAL,0) + NVL(IR_LIC_OB_ASSET_VALUE,0) - NVL(IR_LIC_PIE_FEE,0)) CALC_ASSET_VALUE,
                IR_LIC_CALC_COST,
                ((NVL(IR_LIC_ADDITIONS,0) + NVL(IR_LIC_CANCELLATIONS,0) + NVL(IR_LIC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LIC_REVERSAL,0) + NVL(IR_LIC_OB_ASSET_VALUE,0) - NVL(IR_LIC_PIE_FEE,0)) - NVL(IR_LIC_CALC_COST,0)) CB_CALC,
                (NVL(IR_LIC_CB_INVENTORY,0) - ((NVL(IR_LIC_ADDITIONS,0) + NVL(IR_LIC_CANCELLATIONS,0) + NVL(IR_LIC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LIC_REVERSAL,0) + NVL(IR_LIC_OB_ASSET_VALUE,0) - NVL(IR_LIC_PIE_FEE,0)) - NVL(IR_LIC_CALC_COST,0))) DIFFERENCE
            FROM
                X_INVENTORY_RECON_SUM
            WHERE
                IR_YYYYMM >= ''' || L_START_YYYYMM || '''
                AND IR_CHA_COM_SHORT_NAME <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                AND IR_YYYYMM <= ''' || L_END_YYYYMM || '''
                AND IR_CHA_COM_SHORT_NAME LIKE ''' || I_CHANNEL_COMPANY || '''
                AND IR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                AND (
                      IR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL
                    )';
            IF I_LICENSE_TYPE IS NULL
            THEN
                L_QUERY := L_QUERY || L_GROUP_QUERY;
            ELSE
                L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;
            END IF;
		ELSE                        --Recon Currency
            L_QUERY := '
            SELECT
              IR_CHA_COM_SHORT_NAME "Channel Company",
              IR_LIC_CUR "Lic Currency",
              IR_LOC_CUR "Recon Currency",
              ';
            IF I_LICENSE_TYPE IS NOT NULL
            THEN
            L_QUERY := L_QUERY ||'NVL(IR_LIC_TYPE,''CONSOLIDATED'') "Lic Type",
                ';
            END IF;

            L_QUERY := L_QUERY || 'TO_CHAR(TO_DATE(IR_YYYYMM, ' || '''YYYYMM''' || '),' || '''Mon-YY''' || ') YEAR_MONTH,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND(SUM(DIFFERENCE))) "Difference",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_OB_ASSET_VALUE)) "O/B Asset Value",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_OB_COST)*(-1))) "O/B Cost",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_OB_INVENTORY)) "O/B Inventory",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_ADDITIONS)) "Additions",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_FLF_PRICE_CHANGE)) "FLF Price Changes/Revaluations",
             -- X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_REVALUATIONS)) "Revaluations",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_CANCELLATIONS)) "Cancellations",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_REVERSAL)) "Reversals",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_COS_COST)*(-1))) "Cost of Sales",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_PIE_FEE)*(-1))) "Inventory Expiry Fee",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_PIE_COST)) "Inventory Expiry Cost",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_CB_ASSET_VALUE)) "C/B Asset Value",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_CB_COST)*(-1))) "C/B Cost",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_CB_INVENTORY)) "C/B Inventory",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(CALC_ASSET_VALUE)) "Calculated Asset Value",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_CALC_COST)*(-1))) "Calculated Cost",
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(CB_CALC)) "Calculated C/B"
            FROM
              (
                  SELECT
                  IR_CHA_COM_SHORT_NAME,
                  IR_LIC_CUR,
                  IR_LOC_CUR,
                  IR_LIC_TYPE,
                  --TO_CHAR(TO_DATE(IR_YYYYMM, ' || '''YYYYMM''' || '),' || '''Mon-YY''' || ') YEAR_MONTH,
									IR_YYYYMM,
                  IR_LOC_ADDITIONS,
                  IR_LOC_CANCELLATIONS,
                  IR_LOC_FLF_PRICE_CHANGE,
                  IR_LOC_REVALUATIONS,
                  IR_LOC_REVERSAL,
                  IR_LOC_COS_COST,
                  IR_LOC_OB_ASSET_VALUE,
                  IR_LOC_OB_COST,
                  IR_LOC_OB_INVENTORY,
                  IR_LOC_PIE_FEE,
                  IR_LOC_PIE_COST,
                  IR_LOC_CB_ASSET_VALUE,
                  IR_LOC_CB_COST,
                  IR_LOC_CB_INVENTORY,
                  (NVL(IR_LOC_ADDITIONS,0) + NVL(IR_LOC_CANCELLATIONS,0) + NVL(IR_LOC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LOC_REVERSAL,0) + NVL(IR_LOC_OB_ASSET_VALUE,0) - NVL(IR_LOC_PIE_FEE,0)) CALC_ASSET_VALUE,
                  IR_LOC_CALC_COST,
                  ((NVL(IR_LOC_ADDITIONS,0) + NVL(IR_LOC_CANCELLATIONS,0) + NVL(IR_LOC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LOC_REVERSAL,0) + NVL(IR_LOC_OB_ASSET_VALUE,0) - NVL(IR_LOC_PIE_FEE,0)) - NVL(IR_LOC_CALC_COST,0)) CB_CALC,
                  (NVL(IR_LOC_CB_INVENTORY,0) - ((NVL(IR_LOC_ADDITIONS,0) + NVL(IR_LOC_CANCELLATIONS,0) + NVL(IR_LOC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LOC_REVERSAL,0) + NVL(IR_LOC_OB_ASSET_VALUE,0) - NVL(IR_LOC_PIE_FEE,0)) - NVL(IR_LOC_CALC_COST,0))) DIFFERENCE
            FROM
                  X_INVENTORY_RECON_SUM
            WHERE
                  IR_YYYYMM >= ''' || L_START_YYYYMM || '''
                  AND IR_CHA_COM_SHORT_NAME <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                  AND IR_YYYYMM <= ''' || L_END_YYYYMM || '''
                  AND IR_CHA_COM_SHORT_NAME LIKE ''' || I_CHANNEL_COMPANY || '''
                  AND IR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                  AND (
                        IR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                        OR ''' || I_LICENSE_TYPE || ''' IS NULL
                      )
                      ';

            IF I_LICENSE_TYPE IS NULL
            THEN
                L_QUERY := L_QUERY || L_GROUP_QUERY;
            ELSE
                L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;
            END IF;

		END IF;

    dbms_output.put_line(L_QUERY);
		OPEN O_INV_RECON FOR L_QUERY;
   END X_PRC_INV_RECON;

  PROCEDURE X_PRC_PREPAY_RECON (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_PREPAY_RECON						  OUT		X_PKG_LINEAR_RECON.C_PREPAY_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Prepayment Recon Data
-- REM Client - MNET
--****************************************************************
    L_START_YYYYMM			    NUMBER;
    L_END_YYYYMM			      NUMBER;
    L_QUERY					        VARCHAR2(5000);
    L_LTYPE_GROUP_QUERY     VARCHAR2(400);
    L_GROUP_QUERY           VARCHAR2(400);
   BEGIN

		L_START_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_FROM, 'YYYYMM'));
		L_END_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_TO, 'YYYYMM'));

    L_LTYPE_GROUP_QUERY :='GROUP BY
      PR_CHA_COM_SHORT_NAME,
      PR_LIC_CUR,
      PR_LOC_CUR,
      PR_YYYYMM,
      ROLLUP(PR_LIC_TYPE)
    ORDER BY
      PR_CHA_COM_SHORT_NAME,
      PR_LIC_CUR,
      PR_LOC_CUR,
      PR_YYYYMM,
      PR_LIC_TYPE desc ';

    L_GROUP_QUERY :='GROUP BY
      PR_CHA_COM_SHORT_NAME,
      PR_LIC_CUR,
      PR_LOC_CUR,
      PR_YYYYMM
    ORDER BY
      PR_CHA_COM_SHORT_NAME,
      PR_LIC_CUR,
      PR_LOC_CUR,
      PR_YYYYMM';


		IF I_RECON_CURRENCY = 'LIC'
		THEN     --LICENSE CURRENCY
        L_QUERY := '
        SELECT
        PR_CHA_COM_SHORT_NAME "Channel Company",
        PR_LIC_CUR "Lic Currency",
        PR_LIC_CUR "Recon Currency",
        ';

        IF I_LICENSE_TYPE IS NOT NULL
        THEN  L_QUERY := L_QUERY || 'NVL(PR_LIC_TYPE,''CONSOLIDATED'') "Lic Type",
        ';
        END IF;

        L_QUERY := L_QUERY || ' TO_CHAR(TO_DATE(PR_YYYYMM, '|| '''YYYYMM''' || '), ' || '''Mon-YY''' || ') YEAR_MONTH,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND(SUM(DIFFERENCE))) "Difference",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_OPENING_BAL)) "O/B Pre-Payments",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(PR_LIC_PREPAY_MOVEMENT)*(-1))) "Pre-Payment Movements",--NAME CHANGE BECAUSE CR (Ankur Kasar)
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_PRE_PAY)) "Pre-Payments",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_PRE_ADJ_PAY)) "Adjustments (Pre-Payments)",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_ADJ_TRANSFER)) "Transfers (Pre-Payments)",-- Added because CR  (Ankur Kasar)
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_CALC_PAY)) "Calculated Pre-Payments",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_CLOSING_BAL)) "C/B Pre-Payments"
          FROM
           (
                SELECT
                  PR_CHA_COM_SHORT_NAME,
                  PR_LIC_CUR,
                  PR_LOC_CUR,
                  PR_LIC_TYPE,
									PR_YYYYMM,
                  PR_LIC_OPENING_BAL,
                  PR_LIC_PREPAY_MOVEMENT,
                  PR_LIC_PRE_PAY,
                  PR_LIC_PRE_ADJ_PAY,
                  PR_LIC_CALC_PAY,
                  PR_LIC_CLOSING_BAL,
                  PR_LIC_ADJ_TRANSFER,
                  ((NVL(PR_LIC_CALC_PAY,0)) - (NVL(PR_LIC_CLOSING_BAL,0))) DIFFERENCE
                FROM
                  X_PRE_PAYMENT_RECON_SUM
                WHERE
                  PR_CHA_COM_SHORT_NAME LIKE ''' || I_CHANNEL_COMPANY || '''
                  AND PR_CHA_COM_SHORT_NAME <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                  AND PR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                  AND PR_YYYYMM >= ''' || L_START_YYYYMM || '''
                  AND PR_YYYYMM <= ''' || L_END_YYYYMM || '''
                  AND (PR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL)
            )
          ';

          IF I_LICENSE_TYPE IS NULL
          THEN
              L_QUERY := L_QUERY || L_GROUP_QUERY;
          ELSE
              L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;
          END IF;

		ELSE		--RECON CURRENCY
        L_QUERY := 'SELECT
        PR_CHA_COM_SHORT_NAME "Channel Company",
        PR_LIC_CUR "Lic Currency",
        PR_LOC_CUR "Recon Currency",
        ';

        IF I_LICENSE_TYPE IS NOT NULL
        THEN  L_QUERY := L_QUERY || 'NVL(PR_LIC_TYPE,''CONSOLIDATED'') "Lic Type",
        ';
        END IF;

        L_QUERY := L_QUERY || ' TO_CHAR(TO_DATE(PR_YYYYMM, '|| '''YYYYMM''' || '), ' || '''Mon-YY''' || ') YEAR_MONTH,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND(SUM(DIFFERENCE))) "Difference",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_OPENING_BAL)) "O/B Pre-Payments",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(PR_LOC_PREPAY_MOVEMENT)*(-1))) "Pre-Payment Movements",--NAME CHANGE BECAUSE CR  (Ankur Kasar)
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_PRE_PAY)) "Pre-Payments",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_PRE_ADJ_PAY)) "Adjustments (Pre-Payments)",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_ADJ_TRANSFER)) "Transfers (Pre-Payments)",--ADDED BECAUSE CR  (Ankur Kasar)
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_RGL)) "Realised Forex",--NAME CHANGE BECAUSE CR  (Ankur Kasar)
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_CALC_PAY)) "Calculated Pre-Payments",
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_CLOSING_BAL)) "C/B Pre-Payments"
          FROM
           (
                SELECT
                  PR_CHA_COM_SHORT_NAME,
                  PR_LIC_CUR,
                  PR_LOC_CUR,
                  PR_LIC_TYPE,
									PR_YYYYMM,
                  PR_LOC_OPENING_BAL,
                  PR_LOC_PREPAY_MOVEMENT,
                  PR_LOC_PRE_PAY,
                  PR_LOC_PRE_ADJ_PAY,
                  PR_RGL,
                  PR_LOC_CALC_PAY,
                  PR_LOC_CLOSING_BAL,
                  PR_LOC_ADJ_TRANSFER,
                  ((NVL(PR_LOC_CALC_PAY,0)) - (NVL(PR_LOC_CLOSING_BAL,0))) DIFFERENCE
                FROM
                  X_PRE_PAYMENT_RECON_SUM
                WHERE
                  PR_CHA_COM_SHORT_NAME LIKE ''' || I_CHANNEL_COMPANY || '''
                  AND PR_CHA_COM_SHORT_NAME <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                  AND PR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                  AND PR_YYYYMM >= ''' || L_START_YYYYMM || '''
                  AND PR_YYYYMM <= ''' || L_END_YYYYMM || '''
                  AND (PR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL)
            )
          ';

          IF I_LICENSE_TYPE IS NULL
          THEN
              L_QUERY := L_QUERY || L_GROUP_QUERY;
          ELSE
              L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;
          END IF;
		END IF;

		dbms_output.put_line(L_QUERY);
		OPEN O_PREPAY_RECON FOR L_QUERY;

   END X_PRC_PREPAY_RECON;

  PROCEDURE X_PRC_LIAB_RECON (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_LIAB_RECON							OUT		X_PKG_LINEAR_RECON.C_LIAB_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Liability Recon Data
-- REM Client - MNET
--****************************************************************
      L_START_YYYYMM			      NUMBER;
      L_END_YYYYMM			        NUMBER;
      L_QUERY					          VARCHAR2(5000);
      L_LTYPE_GROUP_QUERY       VARCHAR2(500);
      L_GROUP_QUERY             VARCHAR2(500);
   BEGIN

		L_START_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_FROM, 'YYYYMM'));
		L_END_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_TO, 'YYYYMM'));

    L_LTYPE_GROUP_QUERY := 'GROUP BY
      LR_LIC_CHA_COM,
      LR_LIC_CUR,
      LR_LOC_CUR,
      LR_YYYYMM,
      ROLLUP(LR_LIC_TYPE)
    ORDER BY
      LR_LIC_CHA_COM,
      LR_LIC_CUR,
      LR_LOC_CUR,
	    LR_YYYYMM ';

    L_GROUP_QUERY := 'GROUP BY
      LR_LIC_CHA_COM,
      LR_LIC_CUR,
      LR_LOC_CUR,
      LR_YYYYMM
    ORDER BY
      LR_LIC_CHA_COM,
      LR_LIC_CUR,
      LR_LOC_CUR,
	  LR_YYYYMM ';



		IF I_RECON_CURRENCY = 'LIC'
		THEN		--LICENSE CURRENCY
          L_QUERY := 'SELECT
          LR_LIC_CHA_COM "Channel Company",
          LR_LIC_CUR "Lic Currency",
          LR_LIC_CUR "Recon Currency",
          ';

          IF I_LICENSE_TYPE IS NOT NULL
          THEN
            L_QUERY := L_QUERY || 'NVL(LR_LIC_TYPE,''CONSOLIDATED'') "Lic Type",
            ';
          END IF;

          L_QUERY := L_QUERY || ' TO_CHAR(TO_DATE(LR_YYYYMM, ' || '''YYYYMM''' || '), ' || '''Mon-YY''' || ') YEAR_MONTH,
					X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND((
					NVL(SUM(LR_LIC_OB_LIAB),0) 						+
					NVL(SUM(LR_LIC_ADDITIONS),0) 					+
					NVL(SUM(LR_LIC_FLF_CHANGE_REVAL),0) 	+
					NVL(SUM(LR_LIC_REVERSAL),0) 					+
					NVL(SUM(LR_LIC_CANCELLATION),0)				-
					NVL(SUM(LR_LIC_PAYMENTS),0)						-
					NVL(SUM(LR_LIC_ADJ_PAY),0) 						-
					NVL(SUM(LR_LIC_TRANSFER_PAY),0) 			-
					NVL(SUM(LR_LIC_MOVEMENT),0)
					)-
					NVL(SUM(LR_LIC_CB_LIAB),0)
					)) "Difference",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_OB_LIAB)) "O/B - Liability",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_ADDITIONS)) "Additions",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_FLF_CHANGE_REVAL)) "FLF Price Changes/Revaluations",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_CANCELLATION)) "Cancellations",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_REVERSAL)) "Reversals",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_PAYMENTS)*(-1))) "Payments",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_ADJ_PAY)*(-1))) "Adjustments (Payments)",--name change becuase CR (Ankur Kasar)
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_TRANSFER_PAY)*(-1))) "Transfers (Payments)",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_MOVEMENT)*(-1))) "Pre-Payment Movements",

					X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(
					ROUND(
					NVL(SUM(LR_LIC_OB_LIAB),0) 						+
					NVL(SUM(LR_LIC_ADDITIONS),0) 					+
					NVL(SUM(LR_LIC_FLF_CHANGE_REVAL),0) 	+
					NVL(SUM(LR_LIC_REVERSAL),0) 					+
					NVL(SUM(LR_LIC_CANCELLATION),0)				-
					NVL(SUM(LR_LIC_PAYMENTS),0)						-
					NVL(SUM(LR_LIC_ADJ_PAY),0) 						-
					NVL(SUM(LR_LIC_TRANSFER_PAY),0) 			-
					NVL(SUM(LR_LIC_MOVEMENT),0)
					)
					)
					"C/B - Liability Calculated",
           X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_CB_LIAB)) "C/B - Liability Report"
          --ROUND(SUM(LR_LIC_LIAB_DIFF)) "Difference"
        FROM
          (
              SELECT
                LR_LIC_CHA_COM,
                LR_LIC_CUR,
                LR_LOC_CUR,
                LR_LIC_TYPE,
                --TO_CHAR(TO_DATE(LR_YYYYMM, ' || '''YYYYMM''' || '), ' || '''Mon-YY''' || ') YEAR_MONTH,
								LR_YYYYMM,
                LR_LIC_OB_LIAB,
                LR_LIC_ADDITIONS,
                LR_LIC_CANCELLATION,
                LR_LIC_FLF_CHANGE_REVAL,
                LR_LIC_REVERSAL,
                LR_LIC_PAYMENTS,
                LR_LIC_ADJ_PAY,
                LR_LIC_TRANSFER_PAY,
                LR_LIC_MOVEMENT,
                LR_CAL_LIC_CB_LIAB,
                LR_LIC_CB_LIAB,
                LR_LIC_LIAB_DIFF
              FROM
                X_LIABILITY_RECON_SUM
              WHERE
                LR_LIC_CHA_COM LIKE ''' || I_CHANNEL_COMPANY || '''
                AND LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                AND LR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                AND LR_YYYYMM >= ''' || L_START_YYYYMM || '''
                AND LR_YYYYMM <= ''' || L_END_YYYYMM || '''
                AND (
                      LR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL
                    )
          )
        ';
          IF I_LICENSE_TYPE IS NULL
          THEN
              L_QUERY := L_QUERY || L_GROUP_QUERY;
          ELSE
              L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;
          END IF;
		ELSE		--RECON CURRENCY
				  L_QUERY := 'SELECT
          LR_LIC_CHA_COM "Channel Company",
          LR_LIC_CUR "Lic Currency",
          LR_LOC_CUR "Recon Currency",
          ';

          IF I_LICENSE_TYPE IS NOT NULL
          THEN
            L_QUERY := L_QUERY || 'NVL(LR_LIC_TYPE,''CONSOLIDATED'') "Lic Type",
            ';
          END IF;

          L_QUERY := L_QUERY || '  TO_CHAR(TO_DATE(LR_YYYYMM, ' || '''YYYYMM''' || '), ' || '''Mon-YY''' || ') YEAR_MONTH,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND((
					NVL(SUM(LR_LOC_OB_LIAB),0) 				 		+
					NVL(SUM(LR_LOC_ADDITIONS),0) 			 		+
					NVL(SUM(LR_LOC_FLF_CHANGE_REVAL),0) 	+
					NVL(SUM(LR_LOC_REVERSAL),0) 				 	+
					NVL(SUM(LR_LOC_CANCELLATION),0) 		 	-
					NVL(SUM(LR_LOC_PAYMENTS),0) 				 	-
					NVL(SUM(LR_LOC_ADJ_PAY),0) 				 		-
					NVL(SUM(LR_LOC_TRANSFER_PAY),0) 		 	-
					NVL(SUM(LR_LIC_RGL),0)              	-
					NVL(SUM(LR_LOC_MOVEMENT),0)
					)-
					NVL(SUM(LR_LOC_CB_LIAB),0)
					)) as "Difference",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_OB_LIAB)) "O/B - Liability",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_ADDITIONS)) "Additions",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_FLF_CHANGE_REVAL)) "FLF Price Changes/Revaluations",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_CANCELLATION)) "Cancellations",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_REVERSAL)) "Reversals",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LOC_PAYMENTS)*(-1))) "Payments",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LOC_ADJ_PAY)*(-1))) "Adjustments (Payments)",--name change because CR (Ankur Kasar)
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LOC_TRANSFER_PAY)*(-1))) "Transfers (Payments)",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_RGL)*(-1))) "Realised Forex",--name change because CR (Ankur Kasar)
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LOC_MOVEMENT)*(-1))) "Pre-Payment Movements",

          --X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_CAL_LOC_CB_LIAB)) "C/B - Liability Calculated",
					X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(
					ROUND(
					NVL(SUM(LR_LOC_OB_LIAB),0) 				 		+
					NVL(SUM(LR_LOC_ADDITIONS),0) 			 		+
					NVL(SUM(LR_LOC_FLF_CHANGE_REVAL),0) 	+
					NVL(SUM(LR_LOC_REVERSAL),0) 				 	+
					NVL(SUM(LR_LOC_CANCELLATION),0) 		 	-
					NVL(SUM(LR_LOC_PAYMENTS),0) 				 	-
					NVL(SUM(LR_LOC_ADJ_PAY),0) 				 		-
					NVL(SUM(LR_LOC_TRANSFER_PAY),0) 		 	-
					NVL(SUM(LR_LIC_RGL),0)              	-
					NVL(SUM(LR_LOC_MOVEMENT),0)
					)
					)"C/B - Liability Calculated",
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_CB_LIAB))     "C/B - Liability Report"

        FROM
          (
              SELECT
                LR_LIC_CHA_COM,
                LR_LIC_CUR,
                LR_LOC_CUR,
                LR_LIC_TYPE,
								LR_YYYYMM,
                LR_LOC_OB_LIAB,
                LR_LOC_ADDITIONS,
                LR_LOC_CANCELLATION,
                LR_LOC_FLF_CHANGE_REVAL,
                LR_LOC_REVERSAL,
                LR_LOC_PAYMENTS,
                LR_LOC_ADJ_PAY,
                LR_LOC_TRANSFER_PAY,
                LR_LIC_RGL,
                LR_LOC_MOVEMENT,
                LR_CAL_LOC_CB_LIAB,
                LR_LOC_CB_LIAB,
                LR_LOC_LIAB_DIFF
              FROM
                X_LIABILITY_RECON_SUM
              WHERE
                LR_LIC_CHA_COM LIKE ''' || I_CHANNEL_COMPANY || '''
                AND LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                AND LR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                AND LR_YYYYMM >= ''' || L_START_YYYYMM || '''
                AND LR_YYYYMM <= ''' || L_END_YYYYMM || '''
                AND (
                      LR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL
                    )
          )
        ';
          IF I_LICENSE_TYPE IS NULL
          THEN
              L_QUERY := L_QUERY || L_GROUP_QUERY;
          ELSE
              L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;
          END IF;
		END IF;

    dbms_output.put_line(L_QUERY);
		OPEN O_LIAB_RECON FOR L_QUERY;

   END X_PRC_LIAB_RECON;

  PROCEDURE X_PRC_INV_RECON_NR (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_INV_RECON							    OUT		X_PKG_LINEAR_RECON.C_INV_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Inventory Recon Data
-- for not reconciled licenses
-- REM Client - MNET
--****************************************************************
   L_START_YYYYMM			        NUMBER;
   L_END_YYYYMM				        NUMBER;
   L_QUERY                    VARCHAR2(5000);
   L_LTYPE_GROUP_QUERY        VARCHAR2(400);
   L_GROUP_QUERY              VARCHAR2(400);
   BEGIN

    L_START_YYYYMM := to_char(I_RECON_FROM,'RRRRMM');
    L_END_YYYYMM := to_char(I_RECON_TO,'RRRRMM');

    IF I_RECON_CURRENCY = 'LIC'
		THEN      --LICENSE CURRENCY
        OPEN O_INV_RECON FOR
            SELECT
              COM_SHORT_NAME "Channel Company",
              IR_LIC_CUR "Lic Currency",
              IR_LIC_TYPE "Type",
              LEE_SHORT_NAME "Licensee",
              IR_LIC_BUD_CODE "Budget Code",
              IR_LIC_NUMBER "License No.",
              NVL(LR_LIC_ADDITIONS,0) "Additions",
              NVL(LR_LIC_CANCELATION,0) "Cancellations",
              NVL(LR_LIC_FLF_CHANGE_REVAL,0) "FLF Price Change/Revaluations",
              --IR_LIC_REVALUATIONS "Revaluations",
              NVL(LR_LIC_REVERSAL,0) "Reversals",
              NVL((IR_LIC_MOV_COST *(-1)),0) "Cost of Sales",
              NVL(IR_LIC_SUM_ASSET_OPENING,0) "O/B Asset Value",
              NVL((IR_LIC_SUM_COST_OPENING *(-1)),0) "O/B Cost",
              NVL(LIC_OB_INVENTORY,0) "O/B Inventory",
              NVL((IR_LIC_PROG_INV_FEE *(-1)),0) "Inventory Expiry Fee",
              NVL(IR_LIC_PROG_INV_COST,0) "Inventory Expiry Cost",
              NVL(IR_LIC_SUM_ASSET_CLOSING,0) "C/B Asset Value",
              NVL((IR_LIC_SUM_COST_CLOSING *(-1)),0) "C/B Cost",
              NVL(LIC_CB_INVENTORY,0) "C/B Inventory",
              (NVL(LR_LIC_ADDITIONS,0) + NVL(LR_LIC_CANCELATION,0) + NVL(LR_LIC_FLF_CHANGE_REVAL,0) + NVL(LR_LIC_REVERSAL,0) + NVL(IR_LIC_SUM_ASSET_OPENING,0) - NVL(IR_LIC_PROG_INV_FEE,0)) "Calculated Asset Value",
              NVL((IR_LIC_COST_CAL *(-1)),0) "Calculated Cost",
              ((NVL(LR_LIC_ADDITIONS,0) + NVL(LR_LIC_CANCELATION,0) + NVL(LR_LIC_FLF_CHANGE_REVAL,0) + NVL(LR_LIC_REVERSAL,0) + NVL(IR_LIC_SUM_ASSET_OPENING,0) - NVL(IR_LIC_PROG_INV_FEE,0)) - NVL(IR_LIC_COST_CAL,0)) "Calculated C/B",
              X_FNC_ROUNDED_VALUE_LIC((
                NVL(IR_LIC_SUM_ASSET_CLOSING,0)      -
                NVL(IR_LIC_SUM_COST_CLOSING,0)       -
                NVL(LR_LIC_ADDITIONS,0)              -
                NVL(LR_LIC_CANCELATION,0)            -
                NVL(LR_LIC_FLF_CHANGE_REVAL,0)       -
                NVL(LR_LIC_REVERSAL,0)               -
                NVL(IR_LIC_SUM_ASSET_OPENING,0)      +
                NVL(IR_LIC_PROG_INV_FEE,0)           +
                NVL(IR_LIC_MOV_COST,0)               +
                NVL(IR_LIC_SUM_COST_OPENING,0)       -
                NVL(IR_LIC_PROG_INV_COST,0)
              ),IR_LIC_CUR) "Difference",
							TO_CHAR(TO_DATE(IR_YYYYMM, 'YYYYMM'), 'Mon-YY') "Period"
            FROM
              (
                  SELECT
                      FC.COM_SHORT_NAME,
                      IR_LIC_CUR,
                      IR_LIC_TYPE,
                      FL.LEE_SHORT_NAME,
                    --New Column Added
                      IR_LIC_CHA_COM_NUMBER,
                      IR_LOC_CUR,
                      IR_LIC_LEE_NUMBER,
                      IR_LIC_BUD_CODE,

                      IR_LIC_NUMBER,
                      IR_LSL_NUMBER,
                      IR_LIC_MOV_COST,
                      IR_LIC_SUM_ASSET_OPENING,
                      IR_LIC_SUM_COST_OPENING,
                      (
                        NVL(IR_LIC_SUM_ASSET_OPENING,0) -
                        NVL(IR_LIC_SUM_COST_OPENING,0)
                      )
                      AS LIC_OB_INVENTORY,
                      IR_LIC_PROG_INV_FEE,
                      IR_LIC_PROG_INV_COST,
                      IR_LIC_SUM_ASSET_CLOSING,
                      IR_LIC_SUM_COST_CLOSING,
                      (
                        NVL(IR_LIC_SUM_ASSET_CLOSING,0) -
                        NVL(IR_LIC_SUM_COST_CLOSING,0)
                      )
                      AS LIC_CB_INVENTORY,
                      IR_LIC_COST_CAL,
                      IR_YYYYMM
                  FROM
                      X_INVENTORY_RECON XIR, FID_COMPANY FC,FID_LICENSEE FL
                  WHERE
                      COM_SHORT_NAME LIKE I_CHANNEL_COMPANY
                      AND (IR_LIC_TYPE LIKE I_LICENSE_TYPE
                            OR I_LICENSE_TYPE IS NULL)
                      AND XIR.Ir_lic_cha_com_number = FC.com_number
                      AND XIR.IR_LIC_LEE_NUMBER = FL.LEE_NUMBER
                      AND IR_LIC_CUR LIKE I_LICENSE_CURRENCY
                      AND IR_YYYYMM >=TO_CHAR(I_RECON_FROM,'YYYYMM')
                      AND IR_YYYYMM <= TO_CHAR(I_RECON_TO,'YYYYMM')
                      and FC.COM_NUMBER <> 50268
              ) INVENTORY,
              (
                  SELECT
                      LR_LIC_NUMBER,
                      LR_LSL_NUMBER,
                      LR_LIC_ADDITIONS,
                      LR_LIC_CANCELATION,
                      LR_LIC_FLF_CHANGE_REVAL,
                      LR_LIC_REVERSAL,
                      LR_YYYYMM
                  FROM
                      X_LIABILITY_RECON XLR, FID_COMPANY FC
                  WHERE
                      COM_SHORT_NAME LIKE I_CHANNEL_COMPANY
                      AND (LR_LIC_TYPE LIKE I_LICENSE_TYPE
                            OR I_LICENSE_TYPE IS NULL)
                      AND XLR.Lr_lic_cha_com_number = FC.com_number
                      AND LR_LIC_CUR LIKE I_LICENSE_CURRENCY
                      AND LR_YYYYMM >= TO_CHAR(I_RECON_FROM,'YYYYMM')
                      AND LR_YYYYMM <= TO_CHAR(I_RECON_TO,'YYYYMM')
                      AND FC.COM_NUMBER <> 50268
              ) LIABILITY
            WHERE
                LR_YYYYMM(+) = IR_YYYYMM
                AND LR_LSL_NUMBER(+) = IR_LSL_NUMBER
                AND LR_LIC_NUMBER(+) = IR_LIC_NUMBER
                AND X_FNC_ROUNDED_VALUE_LIC((
                      NVL(IR_LIC_SUM_ASSET_CLOSING,0)      -
                      NVL(IR_LIC_SUM_COST_CLOSING,0)       -
                      NVL(LR_LIC_ADDITIONS,0)              -
                      NVL(LR_LIC_CANCELATION,0)            -
                      NVL(LR_LIC_FLF_CHANGE_REVAL,0)       -
                      NVL(LR_LIC_REVERSAL,0)               -
                      NVL(IR_LIC_SUM_ASSET_OPENING,0)      +
                      NVL(IR_LIC_PROG_INV_FEE,0)           +
                      NVL(IR_LIC_MOV_COST,0)               +
                      NVL(IR_LIC_SUM_COST_OPENING,0)       -
                      NVL(IR_LIC_PROG_INV_COST,0)
                    ),IR_LIC_CUR) <> 0
            ORDER BY
                IR_YYYYMM,
                COM_SHORT_NAME,
                IR_LIC_CUR,
                IR_LIC_TYPE,
                LEE_SHORT_NAME,
                IR_LIC_BUD_CODE,
                IR_LIC_NUMBER;
		ELSE		  --RECON CURRENCY
        OPEN O_INV_RECON FOR
            SELECT
              COM_SHORT_NAME "Channel Company",
              IR_LIC_CUR "Lic Currency",
              IR_LIC_TYPE "Type",
              LEE_SHORT_NAME "Licensee",
              IR_LIC_BUD_CODE "Budget Code",
              IR_LIC_NUMBER "License No.",
              NVL(LR_LOC_ADDITIONS,0) "Additions",
              NVL(LR_LOC_CANCELATION,0) "Cancellations",
              NVL(LR_LOC_FLF_CHANGE_REVAL,0) "FLF Price Change/Revaluations",
              NVL(LR_LOC_REVERSAL,0) "Reversals",
              NVL((IR_LOC_MOV_COST *(-1)),0) "Cost of Sales",
              NVL(IR_LOC_SUM_ASSET_OPENING,0) "O/B Asset Value",
              NVL((IR_LOC_SUM_COST_OPENING *(-1)),0) "O/B Cost",
              NVL(LOC_OB_INVENTORY,0) "O/B Inventory",
              NVL((IR_LOC_PROG_INV_FEE *(-1)),0) "Inventory Expiry Fee",
              NVL(IR_LOC_PROG_INV_COST,0) "Inventory Expiry Cost",
              NVL(IR_LOC_SUM_ASSET_CLOSING,0) "C/B Asset Value",
              NVL((IR_LOC_SUM_COST_CLOSING *(-1)),0) "C/B Cost",
              NVL(LOC_CB_INVENTORY,0) "C/B Inventory",
              (NVL(LR_LOC_ADDITIONS,0) + NVL(LR_LOC_CANCELATION,0) + NVL(LR_LOC_FLF_CHANGE_REVAL,0) + NVL(LR_LOC_REVERSAL,0) + NVL(IR_LOC_SUM_ASSET_OPENING,0) - NVL(IR_LOC_PROG_INV_FEE,0)) "Calculated Asset Value",
              NVL((IR_LOC_COST_CAL *(-1)),0) "Calculated Cost",
              ((NVL(LR_LOC_ADDITIONS,0) + NVL(LR_LOC_CANCELATION,0) + NVL(LR_LOC_FLF_CHANGE_REVAL,0) + NVL(LR_LOC_REVERSAL,0) + NVL(IR_LOC_SUM_ASSET_OPENING,0) - NVL(IR_LOC_PROG_INV_FEE,0)) - NVL(IR_LOC_COST_CAL,0)) "Calculated C/B",
              X_FNC_ROUNDED_VALUE_LOC((
                NVL(IR_LOC_SUM_ASSET_CLOSING,0)      -
                NVL(IR_LOC_SUM_COST_CLOSING,0)       -
                NVL(LR_LOC_ADDITIONS,0)              -
                NVL(LR_LOC_CANCELATION,0)            -
                NVL(LR_LOC_FLF_CHANGE_REVAL,0)       -
                NVL(LR_LOC_REVERSAL,0)               -
                NVL(IR_LOC_SUM_ASSET_OPENING,0)      +
                NVL(IR_LOC_PROG_INV_FEE,0)           +
                NVL(IR_LOC_MOV_COST,0)               +
                NVL(IR_LOC_SUM_COST_OPENING,0)       -
                NVL(IR_LOC_PROG_INV_COST,0)
              ),IR_LIC_CUR) "Difference",
              TO_CHAR(TO_DATE(IR_YYYYMM, 'YYYYMM'), 'Mon-YY') "Period"
            FROM
              (
                  SELECT
                      FC.COM_SHORT_NAME,
                      IR_LIC_CUR,
                      IR_LIC_TYPE,
                      FL.LEE_SHORT_NAME,
                      --New Column Added
                      IR_LIC_CHA_COM_NUMBER,
                      IR_LOC_CUR,
                      IR_LIC_LEE_NUMBER,
                      IR_LIC_BUD_CODE,

                      IR_LIC_NUMBER,
                      IR_LSL_NUMBER,
                      IR_LOC_MOV_COST,
                      IR_LOC_SUM_ASSET_OPENING,
                      IR_LOC_SUM_COST_OPENING,
                      (
                        NVL(IR_LOC_SUM_ASSET_OPENING,0) -
                        NVL(IR_LOC_SUM_COST_OPENING,0)
                      )
                      AS LOC_OB_INVENTORY,
                      IR_LOC_PROG_INV_FEE,
                      IR_LOC_PROG_INV_COST,
                      IR_LOC_SUM_ASSET_CLOSING,
                      IR_LOC_SUM_COST_CLOSING,
                      (
                        NVL(IR_LOC_SUM_ASSET_CLOSING,0) -
                        NVL(IR_LOC_SUM_COST_CLOSING,0)
                      )
                      AS LOC_CB_INVENTORY,
                      IR_LOC_COST_CAL,
                      IR_YYYYMM
                  FROM
                      X_INVENTORY_RECON XIR,FID_COMPANY FC,FID_LICENSEE FL
                  WHERE
                      COM_SHORT_NAME LIKE I_CHANNEL_COMPANY
                      AND (IR_LIC_TYPE LIKE I_LICENSE_TYPE
                            OR I_LICENSE_TYPE IS NULL)
                     and XIR.Ir_lic_cha_com_number = FC.com_number
                       AND XIR.IR_LIC_LEE_NUMBER = FL.LEE_NUMBER
                      AND IR_LIC_CUR LIKE I_LICENSE_CURRENCY
                      AND IR_YYYYMM >= L_START_YYYYMM
                      AND IR_YYYYMM <= L_END_YYYYMM
                      AND FC.COM_NUMBER <> 50268 --added because supersport data is not required
              ) INVENTORY,
              (
                  SELECT
                      NVL(LR_LIC_NUMBER,0) LR_LIC_NUMBER,
                      NVL(LR_LSL_NUMBER,0) LR_LSL_NUMBER,
                      NVL(LR_LOC_ADDITIONS,0) LR_LOC_ADDITIONS,
                      NVL(LR_LOC_CANCELATION,0) LR_LOC_CANCELATION,
                      NVL(LR_LOC_FLF_CHANGE_REVAL,0) LR_LOC_FLF_CHANGE_REVAL,
                      NVL(LR_LOC_REVERSAL,0) LR_LOC_REVERSAL,
                      LR_YYYYMM
                  FROM
                      X_LIABILITY_RECON XLR, FID_COMPANY FC
                  WHERE
                      COM_SHORT_NAME LIKE I_CHANNEL_COMPANY
                      AND (LR_LIC_TYPE LIKE I_LICENSE_TYPE
                            OR I_LICENSE_TYPE IS NULL)
                      AND XLR.Lr_lic_cha_com_number = FC.com_number
                      AND LR_LIC_CUR LIKE I_LICENSE_CURRENCY
                      AND LR_YYYYMM >= L_START_YYYYMM
                      AND LR_YYYYMM <= L_END_YYYYMM
                      and FC.COM_NUMBER <> 50268
              ) LIABILITY
            WHERE
                LR_YYYYMM(+) = IR_YYYYMM
                AND LR_LIC_NUMBER(+) = IR_LIC_NUMBER
                AND LR_LSL_NUMBER(+) = IR_LSL_NUMBER
                AND X_FNC_ROUNDED_VALUE_LOC((
                      NVL(IR_LOC_SUM_ASSET_CLOSING,0)      -
                      NVL(IR_LOC_SUM_COST_CLOSING,0)       -
                      NVL(LR_LOC_ADDITIONS,0)              -
                      NVL(LR_LOC_CANCELATION,0)            -
                      NVL(LR_LOC_FLF_CHANGE_REVAL,0)       -
                      NVL(LR_LOC_REVERSAL,0)               -
                      NVL(IR_LOC_SUM_ASSET_OPENING,0)      +
                      NVL(IR_LOC_PROG_INV_FEE,0)           +
                      NVL(IR_LOC_MOV_COST,0)               +
                      NVL(IR_LOC_SUM_COST_OPENING,0)       -
                      NVL(IR_LOC_PROG_INV_COST,0)
                    ),IR_LIC_CUR) <> 0
            ORDER BY
                IR_YYYYMM,
                COM_SHORT_NAME,
                IR_LIC_CUR,
                IR_LIC_TYPE,
                LEE_SHORT_NAME,
                IR_LIC_BUD_CODE,
                IR_LIC_NUMBER;
		END IF;

   END X_PRC_INV_RECON_NR;

  PROCEDURE X_PRC_PREPAY_RECON_NR (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_PREPAY_RECON						  OUT		X_PKG_LINEAR_RECON.C_PREPAY_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Prepayment Recon Data
-- for not reconciled licenses
-- REM Client - MNET
--****************************************************************
    L_START_YYYYMM			    NUMBER;
    L_END_YYYYMM			      NUMBER;
   BEGIN

		L_START_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_FROM, 'YYYYMM'));
		L_END_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_TO, 'YYYYMM'));


		IF I_RECON_CURRENCY = 'LIC'
		THEN      --LICENSE CURRENCY
        OPEN O_PREPAY_RECON FOR
        SELECT
          FC.COM_SHORT_NAME "Channel Company",
          PR_LIC_CUR "Lic Currency",
          PR_LIC_TYPE "Type",
          FL.LEE_SHORT_NAME "Licensee",
          PR_LIC_BUD_CODE "Budget Code",
          PR_LIC_NUMBER "License No.",
          NVL(PR_LIC_OPENING_BAL,0) "O/B Pre-Payments",
          NVL((PR_LIC_PREPAY_MOVEMENT *(-1)),0) "Pre-Payment Movements",--"Transfers(Pre-Payments)",--change because CR Request(Ankur Kasar)
          NVL(PR_LIC_ADJ_TRANSFER,0) "Transfers (Pre-Payments)",--Added Because CR Request(Ankur Kasar)
          NVL(PR_LIC_PRE_PAY,0) "Pre-Payments",
          (NVL(PR_LIC_PRE_ADJ_PAY,0) + NVL(PR_LIC_ADJ_TRANSFER,0)) "Adjustments(Pre-Payments)",
					(
               NVL(PR_LIC_OPENING_BAL,0)       -
               NVL(PR_LIC_PREPAY_MOVEMENT,0)   +
               NVL(PR_LIC_PRE_PAY,0)           +
               NVL(PR_LIC_PRE_ADJ_PAY,0)       +
               NVL(PR_LIC_ADJ_TRANSFER,0)
          )
					AS "Calculated Pre-Payments",
          NVL(PR_LIC_CLOSING_BAL,0) "C/B Pre-Payment",
          ROUND(
                  X_FNC_ROUNDED_VALUE_LIC((
                   NVL(PR_LIC_OPENING_BAL,0)         -
                   NVL(PR_LIC_PREPAY_MOVEMENT,0)     +
                   NVL(PR_LIC_PRE_PAY,0)             +
                   NVL(PR_LIC_PRE_ADJ_PAY,0)         +
                   NVL(PR_LIC_ADJ_TRANSFER,0)        -
                   NVL(PR_LIC_CLOSING_BAL,0)
                 ),PR_LIC_CUR)
                ) AS "Difference",
          TO_CHAR(TO_DATE(PR_YYYYMM, 'YYYYMM'), 'Mon-YY') "Period"
        FROM
          X_PRE_PAYMENT_RECON XPR,FID_COMPANY FC,FID_LICENSEE FL
        WHERE
          COM_SHORT_NAME LIKE I_CHANNEL_COMPANY
          AND (PR_LIC_TYPE LIKE I_LICENSE_TYPE
                OR I_LICENSE_TYPE IS NULL)
          AND PR_LIC_CUR LIKE I_LICENSE_CURRENCY
          AND PR_YYYYMM >= L_START_YYYYMM
          AND PR_YYYYMM <= L_END_YYYYMM
          AND XPR.pr_lic_cha_com_number = FC.com_number
          AND XPR.PR_LIC_LEE_NUMBER = FL.LEE_NUMBER
          AND FC.COM_NUMBER <> 50268
          AND ROUND(
                      X_FNC_ROUNDED_VALUE_LIC((
                       NVL(PR_LIC_OPENING_BAL,0)         -
                       NVL(PR_LIC_PREPAY_MOVEMENT,0)     +
                       NVL(PR_LIC_PRE_PAY,0)             +
                       NVL(PR_LIC_PRE_ADJ_PAY,0)         +
                       NVL(PR_LIC_ADJ_TRANSFER,0)        -
                       NVL(PR_LIC_CLOSING_BAL,0)
                     ),PR_LIC_CUR)
                    ) <> 0
        ORDER BY
          FC.COM_SHORT_NAME,
          PR_LIC_CUR,
          PR_LIC_TYPE,
          FL.LEE_SHORT_NAME,
          PR_LIC_BUD_CODE,
          PR_LIC_NUMBER;
		ELSE		  --RECON CURRENCY
        OPEN O_PREPAY_RECON FOR
        SELECT
          FC.COM_SHORT_NAME "Channel Company",
          PR_LIC_CUR "Lic Currency",
          PR_LIC_TYPE "Type",
          FL.LEE_SHORT_NAME "Licensee",
          PR_LIC_BUD_CODE "Budget Code",
          PR_LIC_NUMBER "License No.",
          NVL(PR_LOC_OPENING_BAL,0) "O/B Pre-Payments",
          NVL((PR_LOC_PREPAY_MOVEMENT *(-1)),0) "Pre-Payment Movements",--"Transfers(Pre-Payments)",
          NVL(PR_LIC_ADJ_TRANSFER,0) "Transfers (Pre-Payments)",--Added Because CR Request(Ankur Kasar)
          NVL(PR_LOC_PRE_PAY,0) "Pre-Payments",
          (NVL(PR_LOC_PRE_ADJ_PAY,0) + NVL(PR_LOC_ADJ_TRANSFER,0)) "Adjustments(Pre-Payments)",
          PR_RGL "Realised Forex",-- Name Change Because CR Request(Ankur Kasar)
					(
                NVL(PR_LOC_OPENING_BAL,0)      -
                NVL(PR_LOC_PREPAY_MOVEMENT,0)  +
                NVL(PR_LOC_PRE_PAY,0)          +
                NVL(PR_LOC_PRE_ADJ_PAY,0)      +
                NVL(PR_LOC_ADJ_TRANSFER,0)     +
                NVL(PR_RGL,0)
					) "Calculated Pre-Payments",
          NVL(PR_LOC_CLOSING_BAL,0) "C/B Pre-Payment",
					ROUND(
              X_FNC_ROUNDED_VALUE_LOC((
                 NVL(PR_LOC_OPENING_BAL,0)       -
                 NVL(PR_LOC_PREPAY_MOVEMENT,0)   +
                 NVL(PR_LOC_PRE_PAY,0)           +
                 NVL(PR_LOC_PRE_ADJ_PAY,0)       +
                 NVL(PR_LOC_ADJ_TRANSFER,0)      +
                 NVL(PR_RGL,0)                   -
                 NVL(PR_LOC_CLOSING_BAL,0)
                ),PR_LIC_CUR))
          AS "Difference",
          TO_CHAR(TO_DATE(PR_YYYYMM, 'YYYYMM'), 'Mon-YY') "Period"
        FROM
          X_PRE_PAYMENT_RECON XPR,FID_COMPANY FC,FID_LICENSEE FL
        WHERE
          COM_SHORT_NAME LIKE I_CHANNEL_COMPANY
          AND (PR_LIC_TYPE LIKE I_LICENSE_TYPE
                OR I_LICENSE_TYPE IS NULL)
          AND PR_LIC_CUR LIKE I_LICENSE_CURRENCY
          AND PR_YYYYMM >= L_START_YYYYMM
          AND PR_YYYYMM <= L_END_YYYYMM
          AND XPR.pr_lic_cha_com_number = FC.com_number
          AND XPR.PR_LIC_LEE_NUMBER = FL.LEE_NUMBER
          AND FC.COM_NUMBER <> 50268
          AND ROUND(
                X_FNC_ROUNDED_VALUE_LOC((
									 NVL(PR_LOC_OPENING_BAL,0)       -
									 NVL(PR_LOC_PREPAY_MOVEMENT,0)   +
									 NVL(PR_LOC_PRE_PAY,0)           +
									 NVL(PR_LOC_PRE_ADJ_PAY,0)       +
									 NVL(PR_LOC_ADJ_TRANSFER,0)      +
									 NVL(PR_RGL,0)                   -
									 NVL(PR_LOC_CLOSING_BAL,0)
                ),PR_LIC_CUR)) <> 0
        ORDER BY
          FC.COM_SHORT_NAME,
          PR_LIC_CUR,
          PR_LIC_TYPE,
          FL.LEE_SHORT_NAME,
          PR_LIC_BUD_CODE,
          PR_LIC_NUMBER;
		END IF;

   END X_PRC_PREPAY_RECON_NR;

  PROCEDURE X_PRC_LIAB_RECON_NR (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_LIAB_RECON							  OUT		X_PKG_LINEAR_RECON.C_LIAB_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Liability Recon Data
-- for not reconciled licenses
-- REM Client - MNET
--****************************************************************
      L_START_YYYYMM			      NUMBER;
      L_END_YYYYMM			        NUMBER;
   BEGIN

		L_START_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_FROM, 'YYYYMM'));
		L_END_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_TO, 'YYYYMM'));

		IF I_RECON_CURRENCY = 'LIC'
		THEN		--LICENSE CURRENCY
         OPEN O_LIAB_RECON FOR
            SELECT
                FC.COM_SHORT_NAME "Channel Company",
                LR_LIC_CUR "Lic Currency",
                LR_LIC_TYPE "Type",
                FL.LEE_SHORT_NAME "Licensee",
                LR_LIC_BUD_CODE "Budget Code",
                LR_LIC_NUMBER "License No.",
                LR_LIC_OB_LIAB "O/B - Liability",
                NVL(LR_LIC_ADDITIONS,0) "Additions",
                NVL(LR_LIC_CANCELATION,0) "Cancellations",
                NVL(LR_LIC_FLF_CHANGE_REVAL,0) "FLF Price Changes/Revaluations",
                NVL(LR_LIC_REVERSAL,0) "Reversal",
                NVL((LR_LIC_PAYMENTS *(-1)),0) "Payments",
                NVL((LR_LIC_ADJ_PAY *(-1)),0) "Adjustments (Payments)",--Name Change Because CR Request(Ankur Kasar)
                NVL((LR_LIC_TRANSFER_PAY *(-1)),0) "Transfers",
                NVL((LR_LIC_MOVEMENT *(-1)),0) "Pre-Payment Movements",
                NVL(LR_LIC_CB_LIAB_CAL,0) "C/B-Liability Calculated",
                NVL(LR_LIC_CB_LIAB,0) "C/B-Liability Report",
                X_FNC_ROUNDED_VALUE_LIC(NVL(LR_LIC_CB_LIAB_CAL,0) - NVL(LR_LIC_CB_LIAB,0),LR_LIC_CUR)  "Difference",
                TO_CHAR(TO_DATE(LR_YYYYMM, 'YYYYMM'), 'Mon-YY') "Period"
            FROM
                X_LIABILITY_RECON XLR,FID_COMPANY FC,FID_LICENSEE FL
            WHERE
                COM_SHORT_NAME LIKE I_CHANNEL_COMPANY
                AND (LR_LIC_TYPE LIKE I_LICENSE_TYPE
                OR I_LICENSE_TYPE IS NULL)
                AND XLR.lr_lic_cha_com_number = FC.com_number
                AND XLR.LR_LIC_LEE_NUMBER = FL.LEE_NUMBER
                AND LR_LIC_CUR LIKE I_LICENSE_CURRENCY
                AND LR_YYYYMM >= L_START_YYYYMM
                AND LR_YYYYMM <= L_END_YYYYMM
                AND FC.COM_NUMBER <> 50268
                AND X_FNC_ROUNDED_VALUE_LIC(NVL(LR_LIC_CB_LIAB_CAL,0) - NVL(LR_LIC_CB_LIAB,0),LR_LIC_CUR) <> 0
            ORDER BY
                FC.COM_SHORT_NAME,
                LR_LIC_CUR,
                LR_LIC_TYPE,
                FL.LEE_SHORT_NAME,
                LR_LIC_BUD_CODE,
                LR_LIC_NUMBER;
		ELSE		--RECON CURRENCY
				 OPEN O_LIAB_RECON FOR
            SELECT
                FC.COM_SHORT_NAME "Channel Company",
                LR_LIC_CUR "Lic Currency",
                LR_LIC_TYPE "Type",
                FL.LEE_SHORT_NAME "Licensee",
                lR_LIC_BUD_CODE "Budget Code",
                LR_LIC_NUMBER "License No.",
                LR_LOC_OB_LIAB "O/B - Liability",
                NVL(LR_LOC_ADDITIONS,0) "Additions",
                NVL(LR_LOC_CANCELATION,0) "Cancellations",
                NVL(LR_LOC_FLF_CHANGE_REVAL,0) "FLF Price Changes/Revaluations",
                NVL(LR_LOC_REVERSAL,0) "Reversal",
                NVL((LR_LOC_PAYMENTS *(-1)),0) "Payments",
                NVL((LR_LOC_ADJ_PAY *(-1)),0) "Adjustments (Payments)",--Name Change Because CR Request(Ankur Kasar)
                NVL((LR_LOC_TRANSFER_PAY *(-1)),0) "Transfers",
                NVL((LR_LIC_RGL *(-1)),0) "Realised Forex",--Name Change Because CR Request(Ankur Kasar)
                NVL((LR_LOC_MOVEMENT *(-1)),0) "Pre-Payment Movements",
                NVL(LR_LOC_CB_LIAB_CAL,0) "C/B-Liability Calculated",
                NVL(LR_LOC_CB_LIAB,0) "C/B-Liability Report",
							  X_FNC_ROUNDED_VALUE_LOC(NVL(LR_LOC_CB_LIAB_CAL,0) - NVL(LR_LOC_CB_LIAB,0),LR_LIC_CUR) "Difference",
                TO_CHAR(TO_DATE(LR_YYYYMM, 'YYYYMM'), 'Mon-YY') "Period"
            FROM
                X_LIABILITY_RECON XLR,FID_COMPANY FC,FID_LICENSEE FL
            WHERE
                COM_SHORT_NAME LIKE I_CHANNEL_COMPANY
                AND (LR_LIC_TYPE LIKE I_LICENSE_TYPE
                OR I_LICENSE_TYPE IS NULL)
                AND XLR.lr_lic_cha_com_number = FC.com_number
                AND XLR.LR_LIC_LEE_NUMBER = FL.LEE_NUMBER
                AND LR_LIC_CUR LIKE I_LICENSE_CURRENCY
                AND LR_YYYYMM >= L_START_YYYYMM
                AND LR_YYYYMM <= L_END_YYYYMM
                AND FC.COM_NUMBER <> 50268
                AND X_FNC_ROUNDED_VALUE_LOC(NVL(LR_LOC_CB_LIAB_CAL,0) - NVL(LR_LOC_CB_LIAB,0),LR_LIC_CUR) <> 0
            ORDER BY
                FC.COM_SHORT_NAME,
                LR_LIC_CUR,
                LR_LIC_TYPE,
                FL.LEE_SHORT_NAME,
                LR_LIC_BUD_CODE,
                LR_LIC_NUMBER;
		END IF;

   END X_PRC_LIAB_RECON_NR;

  FUNCTION X_FNC_FORMAT_NUMBER (
  I_DATA_VALUE                  IN      NUMBER
    )
  RETURN VARCHAR2
  AS
--****************************************************************
-- This function formats the input value.
-- REM Client - MNET
--****************************************************************
    L_FORMATTED_TXT   VARCHAR2(50);
  BEGIN

    --L_FORMATTED_TXT := TRANSLATE(TRIM(TO_CHAR(I_DATA_VALUE,'999,999,999,999,999PR')),'<>','()');

    L_FORMATTED_TXT := TRIM(TO_CHAR(ROUND(I_DATA_VALUE),'999,999,999,999,999'));

    RETURN NVL(L_FORMATTED_TXT,0);--ADDED NVL BECAUSE DATA IS GETTING NULL

  END X_FNC_FORMAT_NUMBER;

  FUNCTION X_FNC_ROUNDED_VALUE_LIC (
  I_AMOUNT                      IN      NUMBER,
  I_LIC_CURR                    IN      VARCHAR2
  )
  RETURN NUMBER
  AS
--****************************************************************
-- This function formats the input value.
-- REM Client - MNET
--****************************************************************
      L_AMOUNT            NUMBER;
  BEGIN
      IF I_LIC_CURR = 'ZAR'
      THEN
          IF NVL(I_AMOUNT,0) BETWEEN -0.05 AND 0.05
          THEN L_AMOUNT := 0;
          ELSE L_AMOUNT := ROUND(NVL(I_AMOUNT,0),2);
          END IF;
      ELSE
          IF NVL(I_AMOUNT,0) BETWEEN -0.25 AND 0.25
          THEN L_AMOUNT := 0;
          ELSE L_AMOUNT := ROUND(NVL(I_AMOUNT,0),2);
          END IF;
      END IF;

      RETURN L_AMOUNT;
  END X_FNC_ROUNDED_VALUE_LIC;

  FUNCTION X_FNC_ROUNDED_VALUE_LOC (
  I_AMOUNT                      IN      NUMBER,
  I_LIC_CURR                    IN      VARCHAR2
  )
  RETURN NUMBER
  AS
--****************************************************************
-- This function formats the input value.
-- REM Client - MNET
--****************************************************************
        L_AMOUNT              NUMBER;
  BEGIN

    IF I_LIC_CURR = 'ZAR'
    THEN
        IF NVL(I_AMOUNT,0) BETWEEN -0.05 AND 0.05
        THEN L_AMOUNT := 0;
        ELSE L_AMOUNT := ROUND(NVL(I_AMOUNT,0),2);
        END IF;
    ELSE
        IF NVL(I_AMOUNT,0) BETWEEN -2.5 AND 2.5
        THEN L_AMOUNT := 0;
        ELSE L_AMOUNT := ROUND(NVL(I_AMOUNT,0),2);
        END IF;
    END IF;

    RETURN L_AMOUNT;

  END X_FNC_ROUNDED_VALUE_LOC;

  FUNCTION X_FNC_GET_PERIOD RETURN DATE
  AS
--****************************************************************
-- This function gets the period value.
-- REM Client - MNET
--****************************************************************
  BEGIN

  RETURN G_PERIOD;

  END X_FNC_GET_PERIOD;

  PROCEDURE X_PRC_SET_PERIOD(I_PERIOD DATE)
  AS
--****************************************************************
-- This procedure is called for setting period value.
-- REM Client - MNET
--****************************************************************
  BEGIN
       G_PERIOD := I_PERIOD;
  END X_PRC_SET_PERIOD;

--****************************************************************
-- FINACE DEV PHASE I [ANKUR KASAR] [START]
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_INV_RECON_SEARCH (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_INV_RECON							    OUT		X_PKG_LINEAR_RECON.C_INV_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Inventory Recon Data
-- REM Client - MNET
--****************************************************************
   L_START_YYYYMM			        NUMBER;
   L_END_YYYYMM				        NUMBER;
   L_QUERY                    VARCHAR2(10000);
   L_LTYPE_GROUP_QUERY        VARCHAR2(400);
   L_GROUP_QUERY              VARCHAR2(400);
   L_INV_DATE                 VARCHAR2(1024);
   l_DAY_LIAB                VARCHAR2(1024);
   BEGIN

		L_START_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_FROM, 'YYYYMM'));
		L_END_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_TO, 'YYYYMM'));

      SELECT LISTAGG(''''||TO_CHAR(DAY_INV,'Mon'||'-'||'YY')||''''||' as "'||TO_CHAR(DAY_INV,'MONYY')||'"', ',')  WITHIN GROUP (ORDER BY DAY_INV)
               INTO  L_INV_DATE
               FROM  (
             select  DISTINCT to_date(LR_YYYYMM,'RRRRMM')   DAY_INV
               FROM  X_LIABILITY_RECON_SUM
              WHERE  LR_LIC_CHA_COM LIKE I_CHANNEL_COMPANY
                AND  LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                AND  LR_LIC_CUR LIKE I_LICENSE_CURRENCY
                AND  LR_YYYYMM >= L_START_YYYYMM
                AND  LR_YYYYMM <= L_END_YYYYMM
                AND  (
                      LR_LIC_TYPE LIKE NVL(I_LICENSE_TYPE,'%')
                      OR '%' IS NULL
                     )
                     );

       SELECT LISTAGG(' NVL('||TO_CHAR(DAY_LIAB,'MONYY')||',''0'') AS '||TO_CHAR(DAY_LIAB,'MonYY')||',')  WITHIN GROUP (ORDER BY DAY_LIAB) into   l_DAY_LIAB
          FROM(
           select  DISTINCT to_date(LR_YYYYMM,'RRRRMM')   DAY_LIAB
             FROM  X_LIABILITY_RECON_SUM
            WHERE  LR_LIC_CHA_COM LIKE 'MNET'
              AND  LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
              AND  LR_LIC_CUR LIKE '%'
              AND  LR_YYYYMM >= L_START_YYYYMM
              AND  LR_YYYYMM <= L_END_YYYYMM
              AND  (
                    LR_LIC_TYPE LIKE NVL('%','%')
                    OR '%' IS NULL
                   )
              );
    --DBMS_OUTPUT.PUT_LINE(L_INV_DATE);

    L_LTYPE_GROUP_QUERY := '
            )
      GROUP BY
        IR_CHA_COM_SHORT_NAME,
        IR_LIC_CUR,
        IR_LOC_CUR,
        IR_YYYYMM,
        ROLLUP(IR_LIC_TYPE)';


   L_QUERY :=' SELECT 
    "Channel Company",
    "Lic Currency",
    "Recon Currency",
    "Lic Type",
    Unique_Key,
    REPORT_TYPE ,
    '||l_DAY_LIAB||' 
    RANK FROM
 (';
   L_QUERY:=L_QUERY||'
   SELECT
    A.Channel_Company "Channel Company",
    A.Lic_Currency "Lic Currency",
    A.Recon_Currency "Recon Currency",
    A.Lic_Type "Lic Type",
    A.Unique_Key,
    A.REPORT_TYPE ,
    '||l_DAY_LIAB||' 
    CASE
        WHEN   A.Report_Type = ''Difference''                     THEN 1
        WHEN   A.Report_Type = ''O/B Asset Value''                THEN 2
        WHEN   A.Report_Type = ''O/B Cost''                       THEN 3
        WHEN   A.Report_Type = ''O/B Inventory''                  THEN 4
        WHEN   A.Report_Type = ''Additions''                      THEN 5
        WHEN   A.Report_Type = ''Cancellations''                  THEN 6
        WHEN   A.Report_Type = ''FLF Price Changes/Revaluations'' THEN 7
        WHEN   A.Report_Type = ''Reversals''                      THEN 8
        WHEN   A.Report_Type = ''Cost of Sales''                  THEN 9
        WHEN   A.Report_Type = ''Inventory Expiry Fee''           THEN 10
        WHEN   A.Report_Type = ''Inventory Expiry Cost''          THEN 11
        WHEN   A.Report_Type = ''C/B Asset Value''                THEN 12
        WHEN   A.Report_Type = ''C/B Cost''                       THEN 13
        WHEN   A.Report_Type = ''C/B Inventory''                  THEN 14
        WHEN   A.Report_Type = ''Calculated Asset Value''         THEN 15
        WHEN   A.Report_Type = ''Calculated Cost''                THEN 16
        WHEN   A.Report_Type = ''Calculated C/B''                 THEN 17

    END RANK,
     CASE
         WHEN   A.Lic_Type =''Total''                             THEN 1
         WHEN   A.Lic_Type =''FLF''                               THEN 2
         WHEN   A.Lic_Type =''ROY''                               THEN 3

    END RANKS
    FROM
    (
       SELECT *
              FROM(
                    SELECT *
                      FROM
                      (';

    IF I_RECON_CURRENCY = 'LIC' --License Currency
		THEN
            L_QUERY := L_QUERY||'
            SELECT
            IR_CHA_COM_SHORT_NAME      Channel_Company,
            IR_LIC_CUR                 Lic_Currency,
            IR_LIC_CUR                 Recon_Currency,';

            L_QUERY := L_QUERY ||'NVL(IR_LIC_TYPE,''Total'') Lic_Type,
                                  IR_CHA_COM_SHORT_NAME||IR_LIC_CUR||IR_LIC_CUR Unique_Key,
              ';

            L_QUERY := L_QUERY || 'TO_CHAR(TO_DATE(IR_YYYYMM, ' || '''YYYYMM''' || '),' || '''Mon-YY''' || ') YEAR_MONTH,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND(SUM(DIFFERENCE)))                              Difference,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_OB_ASSET_VALUE))                          OB_Asset_Value,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_OB_COST)*(-1)))                          OB_Cost,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_OB_INVENTORY))                            OB_Inventory,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_ADDITIONS))                               Additions,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_FLF_PRICE_CHANGE))                        FLF_Price_Changes_Revaluations,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_CANCELLATIONS))                           Cancellations,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_REVERSAL))                                Reversals,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_COS_COST)*(-1)))                         Cost_of_Sales,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_PIE_FEE)*(-1)))                          Inventory_Expiry_Fee,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_PIE_COST))                                Inventory_Expiry_Cost,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_CB_ASSET_VALUE))                          CB_Asset_Value,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_CB_COST)*(-1)))                          CB_Cost,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LIC_CB_INVENTORY))                            CB_Inventory,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(CALC_ASSET_VALUE))                               Calculated_Asset_Value,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LIC_CALC_COST)*(-1)))                        Calculated_Cost,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(CB_CALC))                                        Calculated_cb
            FROM
            (
                SELECT
                IR_CHA_COM_SHORT_NAME,
                IR_LIC_CUR,
                IR_LOC_CUR,
                IR_LIC_TYPE,
								IR_YYYYMM,
                IR_LIC_ADDITIONS,
                IR_LIC_CANCELLATIONS,
                IR_LIC_FLF_PRICE_CHANGE,
                IR_LIC_REVALUATIONS,
                IR_LIC_REVERSAL,
                IR_LIC_COS_COST,
                IR_LIC_OB_ASSET_VALUE,
                IR_LIC_OB_COST,
                IR_LIC_OB_INVENTORY,
                IR_LIC_PIE_FEE,
                IR_LIC_PIE_COST,
                IR_LIC_CB_ASSET_VALUE,
                IR_LIC_CB_COST,
                IR_LIC_CB_INVENTORY,
                (NVL(IR_LIC_ADDITIONS,0) + NVL(IR_LIC_CANCELLATIONS,0) + NVL(IR_LIC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LIC_REVERSAL,0) + NVL(IR_LIC_OB_ASSET_VALUE,0) - NVL(IR_LIC_PIE_FEE,0)) CALC_ASSET_VALUE,
                IR_LIC_CALC_COST,
                ((NVL(IR_LIC_ADDITIONS,0) + NVL(IR_LIC_CANCELLATIONS,0) + NVL(IR_LIC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LIC_REVERSAL,0) + NVL(IR_LIC_OB_ASSET_VALUE,0) - NVL(IR_LIC_PIE_FEE,0)) - NVL(IR_LIC_CALC_COST,0)) CB_CALC,
                (NVL(IR_LIC_CB_INVENTORY,0) - ((NVL(IR_LIC_ADDITIONS,0) + NVL(IR_LIC_CANCELLATIONS,0) + NVL(IR_LIC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LIC_REVERSAL,0) + NVL(IR_LIC_OB_ASSET_VALUE,0) - NVL(IR_LIC_PIE_FEE,0)) - NVL(IR_LIC_CALC_COST,0))) DIFFERENCE
            FROM
                X_INVENTORY_RECON_SUM
            WHERE
                IR_YYYYMM >= ''' || L_START_YYYYMM || '''
                AND IR_CHA_COM_SHORT_NAME <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                AND IR_YYYYMM <= ''' || L_END_YYYYMM || '''
                AND IR_CHA_COM_SHORT_NAME LIKE ''' || I_CHANNEL_COMPANY || '''
                AND IR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                AND (
                      IR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL
                    )';

                L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;

             L_QUERY := L_QUERY||'
               )
               UNPIVOT (quantity FOR Report_Type IN
               (
                OB_Asset_Value                  AS ''O/B Asset Value'',
                OB_Cost                         AS ''O/B Cost'',
                OB_Inventory                    AS ''O/B Inventory'',
                Additions                       AS ''Additions'',
                Cancellations                   AS ''Cancellations'',
                FLF_Price_Changes_Revaluations  AS ''FLF Price Changes/Revaluations'',
                Reversals                       AS ''Reversals'',
                Cost_of_Sales                   AS ''Cost of Sales'',
                Inventory_Expiry_Fee            AS ''Inventory Expiry Fee'',
                Inventory_Expiry_Cost           AS ''Inventory Expiry Cost'',
                CB_Asset_Value                  AS ''C/B Asset Value'',
                CB_Cost                         AS ''C/B Cost'',
                CB_Inventory                    AS ''C/B Inventory'',
                Calculated_Asset_Value          AS ''Calculated Asset Value'',
                Calculated_Cost                 AS ''Calculated Cost'',
                Calculated_cb                   AS ''Calculated C/B'',
                Difference                      AS ''Difference''
               )
               )
              -- order by 1,2,3,5,6,4,5
               )
               PIVOT (min(quantity) FOR YEAR_MONTH IN ('||L_INV_DATE||'))
               ORDER BY 1,2,3,5,4';
		ELSE                        --Recon Currency
            L_QUERY := L_QUERY||'
            SELECT
              IR_CHA_COM_SHORT_NAME Channel_Company,
              IR_LIC_CUR            Lic_Currency,
              IR_LOC_CUR            Recon_Currency,
              ';

            L_QUERY := L_QUERY ||'NVL(IR_LIC_TYPE,''Total'') Lic_Type,
                                  IR_CHA_COM_SHORT_NAME||IR_LIC_CUR||IR_LIC_CUR Unique_Key,
                ';


            L_QUERY := L_QUERY || 'TO_CHAR(TO_DATE(IR_YYYYMM, ' || '''YYYYMM''' || '),' || '''Mon-YY''' || ')   YEAR_MONTH,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND(SUM(DIFFERENCE)))                               Difference,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_OB_ASSET_VALUE))                           ob_Asset_Value,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_OB_COST)*(-1)))                           ob_Cost,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_OB_INVENTORY))                             ob_Inventory,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_ADDITIONS))                                Additions,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_FLF_PRICE_CHANGE))                         FLF_Price_Changes_Revaluations,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_CANCELLATIONS))                            Cancellations,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_REVERSAL))                                 Reversals,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_COS_COST)*(-1)))                          Cost_of_Sales,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_PIE_FEE)*(-1)))                           Inventory_Expiry_Fee,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_PIE_COST))                                 Inventory_Expiry_Cost,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_CB_ASSET_VALUE))                           cb_Asset_Value,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_CB_COST)*(-1)))                           cb_Cost,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(IR_LOC_CB_INVENTORY))                             cb_Inventory,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(CALC_ASSET_VALUE))                                Calculated_Asset_Value,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(IR_LOC_CALC_COST)*(-1)))                         Calculated_Cost,
              X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(CB_CALC))                                         Calculated_cb
            FROM
              (
                  SELECT
                  IR_CHA_COM_SHORT_NAME,
                  IR_LIC_CUR,
                  IR_LOC_CUR,
                  IR_LIC_TYPE,
									IR_YYYYMM,
                  IR_LOC_ADDITIONS,
                  IR_LOC_CANCELLATIONS,
                  IR_LOC_FLF_PRICE_CHANGE,
                  IR_LOC_REVALUATIONS,
                  IR_LOC_REVERSAL,
                  IR_LOC_COS_COST,
                  IR_LOC_OB_ASSET_VALUE,
                  IR_LOC_OB_COST,
                  IR_LOC_OB_INVENTORY,
                  IR_LOC_PIE_FEE,
                  IR_LOC_PIE_COST,
                  IR_LOC_CB_ASSET_VALUE,
                  IR_LOC_CB_COST,
                  IR_LOC_CB_INVENTORY,
                  (NVL(IR_LOC_ADDITIONS,0) + NVL(IR_LOC_CANCELLATIONS,0) + NVL(IR_LOC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LOC_REVERSAL,0) + NVL(IR_LOC_OB_ASSET_VALUE,0) - NVL(IR_LOC_PIE_FEE,0)) CALC_ASSET_VALUE,
                  IR_LOC_CALC_COST,
                  ((NVL(IR_LOC_ADDITIONS,0) + NVL(IR_LOC_CANCELLATIONS,0) + NVL(IR_LOC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LOC_REVERSAL,0) + NVL(IR_LOC_OB_ASSET_VALUE,0) - NVL(IR_LOC_PIE_FEE,0)) - NVL(IR_LOC_CALC_COST,0)) CB_CALC,
                  (NVL(IR_LOC_CB_INVENTORY,0) - ((NVL(IR_LOC_ADDITIONS,0) + NVL(IR_LOC_CANCELLATIONS,0) + NVL(IR_LOC_FLF_PRICE_CHANGE,0) + 0 + NVL(IR_LOC_REVERSAL,0) + NVL(IR_LOC_OB_ASSET_VALUE,0) - NVL(IR_LOC_PIE_FEE,0)) - NVL(IR_LOC_CALC_COST,0))) DIFFERENCE
            FROM
                  X_INVENTORY_RECON_SUM
            WHERE
                  IR_YYYYMM >= ''' || L_START_YYYYMM || '''
                  AND IR_CHA_COM_SHORT_NAME <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                  AND IR_YYYYMM <= ''' || L_END_YYYYMM || '''
                  AND IR_CHA_COM_SHORT_NAME LIKE ''' || I_CHANNEL_COMPANY || '''
                  AND IR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                  AND (
                        IR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                        OR ''' || I_LICENSE_TYPE || ''' IS NULL
                      )
                      ';

                L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;


             L_QUERY := L_QUERY||'
               )
               UNPIVOT (quantity FOR Report_Type IN
               (
                OB_Asset_Value                  AS ''O/B Asset Value'',
                OB_Cost                         AS ''O/B Cost'',
                OB_Inventory                    AS ''O/B Inventory'',
                Additions                       AS ''Additions'',
                Cancellations                   AS ''Cancellations'',
                FLF_Price_Changes_Revaluations  AS ''FLF Price Changes/Revaluations'',
                Reversals                       AS ''Reversals'',
                Cost_of_Sales                   AS ''Cost of Sales'',
                Inventory_Expiry_Fee            AS ''Inventory Expiry Fee'',
                Inventory_Expiry_Cost           AS ''Inventory Expiry Cost'',
                CB_Asset_Value                  AS ''C/B Asset Value'',
                CB_Cost                         AS ''C/B Cost'',
                CB_Inventory                    AS ''C/B Inventory'',
                Calculated_Asset_Value          AS ''Calculated Asset Value'',
                Calculated_Cost                 AS ''Calculated Cost'',
                Calculated_cb                   AS ''Calculated C/B'',
                Difference                      AS ''Difference''
               )
               )
            --   order by 1,2,3,5,6,4,5
               )
               PIVOT (min(quantity) FOR YEAR_MONTH IN ('||L_INV_DATE||'))
               ORDER BY 1,2,3,5,4';
		END IF;
      L_QUERY:=L_QUERY||')A
                          ORDER BY 1,2,3,RANK,RANKS) Table_Alise';
    dbms_output.put_line(L_QUERY);
		OPEN O_INV_RECON FOR L_QUERY;
   END X_PRC_INV_RECON_SEARCH;

  PROCEDURE X_PRC_PREPAY_RECON_SEARCH (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_PREPAY_RECON						  OUT		X_PKG_LINEAR_RECON.C_PREPAY_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Prepayment Recon Data
-- REM Client - MNET
--****************************************************************
    L_START_YYYYMM			    NUMBER;
    L_END_YYYYMM			      NUMBER;
    L_QUERY					        VARCHAR2(10000);
    L_LTYPE_GROUP_QUERY     VARCHAR2(400);
    L_GROUP_QUERY           VARCHAR2(400);
    L_DATE_PREPAY           VARCHAR(2024);
    l_DAY_LIAB              VARCHAR2(1024);
   BEGIN

		L_START_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_FROM, 'YYYYMM'));
		L_END_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_TO, 'YYYYMM'));

   SELECT LISTAGG(''''||TO_CHAR(DAY_PREPAY,'Mon'||'-'||'YY')||''''||' as "'||TO_CHAR(DAY_PREPAY,'MONYY')||'"', ',')  WITHIN GROUP (ORDER BY DAY_PREPAY) INTO L_DATE_PREPAY
            FROM(
             select  DISTINCT to_date(LR_YYYYMM,'RRRRMM')   DAY_PREPAY
               FROM  X_LIABILITY_RECON_SUM
              WHERE  LR_LIC_CHA_COM LIKE I_CHANNEL_COMPANY
                AND  LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                AND  LR_LIC_CUR LIKE NVL(I_LICENSE_CURRENCY,'%')
                AND  LR_YYYYMM >= L_START_YYYYMM
                AND  LR_YYYYMM <= L_END_YYYYMM
                AND  (
                      LR_LIC_TYPE LIKE nvl(I_LICENSE_TYPE,'%')
                      OR '%' IS NULL
                     )
                );

     SELECT LISTAGG(' NVL('||TO_CHAR(DAY_LIAB,'MONYY')||',''0'') AS '||TO_CHAR(DAY_LIAB,'MonYY')||',')  WITHIN GROUP (ORDER BY DAY_LIAB) into   l_DAY_LIAB
          FROM(
           select  DISTINCT to_date(LR_YYYYMM,'RRRRMM')   DAY_LIAB
             FROM  X_LIABILITY_RECON_SUM
            WHERE  LR_LIC_CHA_COM LIKE 'MNET'
              AND  LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
              AND  LR_LIC_CUR LIKE '%'
              AND  LR_YYYYMM >= L_START_YYYYMM
              AND  LR_YYYYMM <= L_END_YYYYMM
              AND  (
                    LR_LIC_TYPE LIKE NVL('%','%')
                    OR '%' IS NULL
                   )
              );

    DBMS_OUTPUT.PUT_LINE(L_DATE_PREPAY);

    L_LTYPE_GROUP_QUERY :='GROUP BY
      PR_CHA_COM_SHORT_NAME,
      PR_LIC_CUR,
      PR_LOC_CUR,
      --PR_LIC_TYPE,
      PR_YYYYMM,
      ROLLUP(PR_LIC_TYPE)';

  L_QUERY :=' SELECT 
    "Channel Company",
    "Lic Currency",
    "Recon Currency",
    "Lic Type",
    Unique_Key,
    REPORT_TYPE ,
    '||l_DAY_LIAB||' 
    RANK FROM
 (';

    IF I_RECON_CURRENCY = 'LIC'
		THEN     --LICENSE CURRENCY
       L_QUERY:=L_QUERY||'
       SELECT
          A.Channel_Company "Channel Company",
          A.Lic_Currency "Lic Currency",
          A.Recon_Currency "Recon Currency",
          A.Lic_Type "Lic Type",
          A.Unique_Key,
          A.REPORT_TYPE ,
          '||l_DAY_LIAB||'
          CASE
              WHEN   A.Report_Type = ''Difference''                 THEN 1
              WHEN   A.Report_Type = ''O/B Pre-Payments'' 			    THEN 2
              WHEN   A.Report_Type = ''O/B Pre-Payments'' 			    THEN 3
              WHEN   A.Report_Type = ''Pre-Payment Movements'' 	    THEN 4
              WHEN   A.Report_Type = ''Pre-payments''				        THEN 5
              WHEN   A.Report_Type = ''Adjustments (Pre-Payments)'' THEN 6
              WHEN   A.Report_Type = ''Transfers (Pre-Payments)''	  THEN 7
              WHEN   A.Report_Type = ''Calculated Pre-Payments''	  THEN 8
              WHEN   A.Report_Type = ''C/B Pre-Payments'' 			    THEN 9
          END RANK,
          CASE
              WHEN   A.Lic_Type =''Total''                             THEN 1
              WHEN   A.Lic_Type =''FLF''                               THEN 2
              WHEN   A.Lic_Type =''ROY''                               THEN 3
          END RANK_LIC_TYPE
          FROM
          (
             SELECT *
                    FROM(
                          SELECT *
                            FROM
                            (';

        L_QUERY := L_QUERY||'SELECT
        PR_CHA_COM_SHORT_NAME     Channel_Company,
        PR_LIC_CUR                Lic_Currency,
        PR_LIC_CUR                Recon_Currency,';

        L_QUERY := L_QUERY || 'NVL(PR_LIC_TYPE,''Total'') Lic_Type,
                                     PR_CHA_COM_SHORT_NAME||PR_LIC_CUR||PR_LIC_CUR Unique_Key,
        ';

        L_QUERY := L_QUERY || ' TO_CHAR(TO_DATE(PR_YYYYMM, '|| '''YYYYMM''' || '), ' || '''Mon-YY''' || ')                    YEAR_MONTH,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND(SUM(((NVL(PR_LIC_CALC_PAY,0)) - (NVL(PR_LIC_CLOSING_BAL,0)))))) Difference,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_OPENING_BAL))                                              ob_Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(PR_LIC_PREPAY_MOVEMENT)*(-1)))                                   Pre_Payment_Movements,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_PRE_PAY))                                                  Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_PRE_ADJ_PAY))                                              Adjustments_Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_ADJ_TRANSFER))                                             Transfers_Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_CALC_PAY))                                                 Calculated_Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LIC_CLOSING_BAL))                                              cb_Pre_Payments
                FROM
                  X_PRE_PAYMENT_RECON_SUM
                WHERE
                  PR_CHA_COM_SHORT_NAME LIKE ''' || I_CHANNEL_COMPANY || '''
                  AND PR_CHA_COM_SHORT_NAME <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                  AND PR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                  AND PR_YYYYMM >= ''' || L_START_YYYYMM || '''
                  AND PR_YYYYMM <= ''' || L_END_YYYYMM || '''
                  AND (PR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL)
            ';

              L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;

            L_QUERY := L_QUERY||'
                         )
                         UNPIVOT (quantity FOR Report_Type IN
                         (
                          Difference                as ''Difference'' ,
                          ob_pre_payments           as ''O/B Pre-Payments'',
                          Pre_Payment_Movements     as ''Pre-Payment Movements'',
                          pre_payments              as ''Pre-payments'',
                          Adjustments_Pre_Payments  as ''Adjustments (Pre-Payments)'',
                          Transfers_Pre_Payments    as ''Transfers (Pre-Payments)'',
                          Calculated_Pre_Payments   as ''Calculated Pre-Payments'',
                          cb_Pre_Payments           as ''C/B Pre-Payments''
                         )
                         )
                         order by 1,2,3,5,6,4,5
                         )
                         PIVOT (min(quantity) FOR YEAR_MONTH IN ('||L_DATE_PREPAY||'))
                         ORDER BY 1,2,3,5,4';

		ELSE		--RECON CURRENCY

    L_QUERY:=L_QUERY||'
        SELECT
          A.Channel_Company "Channel Company",
          A.Lic_Currency "Lic Currency",
          A.Recon_Currency "Recon Currency",
          A.Lic_Type "Lic Type",
          A.Unique_Key,
          A.REPORT_TYPE "REPORT_TYPE",
          '||l_DAY_LIAB||'
          CASE
              WHEN   A.Report_Type = ''Difference''                 THEN 1
              WHEN   A.Report_Type = ''O/B Pre-Payments'' 			    THEN 2
              WHEN   A.Report_Type = ''O/B Pre-Payments'' 			    THEN 3
              WHEN   A.Report_Type = ''Pre-Payment Movements'' 	    THEN 4
              WHEN   A.Report_Type = ''Pre-payments''				        THEN 5
              WHEN   A.Report_Type = ''Adjustments (Pre-Payments)'' THEN 6
              WHEN   A.Report_Type = ''Transfers (Pre-Payments)''	  THEN 7
              WHEN   A.Report_Type = ''Realised Forex'' 			      THEN 8
              WHEN   A.Report_Type = ''Calculated Pre-Payments''	  THEN 9
              WHEN   A.Report_Type = ''C/B Pre-Payments'' 			    THEN 10
          END RANK,
          CASE
             WHEN   A.Lic_Type =''Total''                             THEN 1
             WHEN   A.Lic_Type =''FLF''                               THEN 2
             WHEN   A.Lic_Type =''ROY''                               THEN 3

          END RANK_LIC_TYPE
          FROM
          (
             SELECT *
                    FROM(
                          SELECT *
                            FROM
                            (';

        L_QUERY :=L_QUERY||'SELECT
        PR_CHA_COM_SHORT_NAME Channel_Company,
        PR_LIC_CUR            Lic_Currency,
        PR_LOC_CUR            Recon_Currency,
        ';

         L_QUERY := L_QUERY || 'NVL(PR_LIC_TYPE,''Total'') Lic_Type,
                                     PR_CHA_COM_SHORT_NAME||PR_LIC_CUR||PR_LIC_CUR Unique_Key,';


        L_QUERY := L_QUERY || ' TO_CHAR(TO_DATE(PR_YYYYMM, '|| '''YYYYMM''' || '), ' || '''Mon-YY''' || ')                    YEAR_MONTH,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND(SUM(((NVL(PR_LOC_CALC_PAY,0)) - (NVL(PR_LOC_CLOSING_BAL,0)))))) Difference,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_OPENING_BAL))                                              ob_Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(PR_LOC_PREPAY_MOVEMENT)*(-1)))                                   Pre_Payment_Movements,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_PRE_PAY))                                                  Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_PRE_ADJ_PAY))                                              Adjustments_Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_ADJ_TRANSFER))                                             Transfers_Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_RGL))                                                          Realised_Forex,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_CALC_PAY))                                                 Calculated_Pre_Payments,
            X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(PR_LOC_CLOSING_BAL))                                              cb_Pre_Payments
                FROM
                  X_PRE_PAYMENT_RECON_SUM
                WHERE
                  PR_CHA_COM_SHORT_NAME LIKE ''' || I_CHANNEL_COMPANY || '''
                  AND PR_CHA_COM_SHORT_NAME <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                  AND PR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                  AND PR_YYYYMM >= ''' || L_START_YYYYMM || '''
                  AND PR_YYYYMM <= ''' || L_END_YYYYMM || '''
                  AND (PR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL)';


              L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;

            L_QUERY := L_QUERY||'
                         )
                         UNPIVOT (quantity FOR Report_Type IN
                         (
                          Difference                as ''Difference'' ,
                          ob_pre_payments           as ''O/B Pre-Payments'',
                          Pre_Payment_Movements     as ''Pre-Payment Movements'',
                          pre_payments              as ''Pre-payments'',
                          Adjustments_Pre_Payments  as ''Adjustments (Pre-Payments)'',
                          Transfers_Pre_Payments    as ''Transfers (Pre-Payments)'',
                          Realised_Forex            as ''Realised Forex'',
                          Calculated_Pre_Payments   as ''Calculated Pre-Payments'',
                          cb_Pre_Payments           as ''C/B Pre-Payments''
                         )
                         )
                         order by 1,2,3,5,6,4,5
                         )
                         PIVOT (min(quantity) FOR YEAR_MONTH IN ('||L_DATE_PREPAY||'))
                         ORDER BY 1,2,3,5,4';
		END IF;

    L_QUERY:=L_QUERY||')A
                ORDER BY 1,2,3,RANK ,RANK_LIC_TYPE) table_alise';
		dbms_output.put_line(L_QUERY);
		OPEN O_PREPAY_RECON FOR L_QUERY;

   END X_PRC_PREPAY_RECON_SEARCH;

  PROCEDURE X_PRC_LIAB_RECON_SEARCH (
      I_CHANNEL_COMPANY			  	IN		  FID_COMPANY.COM_SHORT_NAME%TYPE,
      I_LICENSE_TYPE         		IN    	FID_LICENSE.LIC_TYPE%TYPE,
      I_LICENSE_CURRENCY			  IN 		  FID_LICENSE.LIC_CURRENCY%TYPE,
      I_RECON_CURRENCY				  IN		  VARCHAR2,
      I_RECON_FROM          		IN    	DATE,
      I_RECON_TO				        IN		  DATE,
      O_LIAB_RECON							OUT		  X_PKG_LINEAR_RECON.C_LIAB_RECON
   )
   AS
--****************************************************************
-- This procedure is called for fetching Liability Recon Data
-- REM Client - MNET
--****************************************************************
      L_START_YYYYMM			      NUMBER;
      L_END_YYYYMM			        NUMBER;
      L_QUERY					          VARCHAR2(7000);
      L_LTYPE_GROUP_QUERY       VARCHAR2(500);
      L_GROUP_QUERY             VARCHAR2(500);
      L_LIAB_DATE               VARCHAR2(500);
      l_DAY_LIAB                VARCHAR2(1024);
   BEGIN

		L_START_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_FROM, 'YYYYMM'));
		L_END_YYYYMM := TO_NUMBER(TO_CHAR(I_RECON_TO, 'YYYYMM'));

    SELECT LISTAGG(''''||TO_CHAR(DAY_LIAB,'Mon'||'-'||'YY')||''''||' as "'||TO_CHAR(DAY_LIAB,'MONYY')||'"', ',')  WITHIN GROUP (ORDER BY DAY_LIAB) INTO L_LIAB_DATE
            FROM(
             select  DISTINCT to_date(LR_YYYYMM,'RRRRMM')   DAY_LIAB
               FROM  X_LIABILITY_RECON_SUM
              WHERE  LR_LIC_CHA_COM LIKE I_CHANNEL_COMPANY
                AND  LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                AND  LR_LIC_CUR LIKE I_LICENSE_CURRENCY
                AND  LR_YYYYMM >= L_START_YYYYMM
                AND  LR_YYYYMM <= L_END_YYYYMM
                AND  (
                      LR_LIC_TYPE LIKE NVL(I_LICENSE_TYPE,'%')
                      OR '%' IS NULL
                     )
                );

     SELECT LISTAGG(' NVL('||TO_CHAR(DAY_LIAB,'MONYY')||',''0'') AS '||TO_CHAR(DAY_LIAB,'MonYY')||',')  WITHIN GROUP (ORDER BY DAY_LIAB) into   l_DAY_LIAB
          FROM(
           select  DISTINCT to_date(LR_YYYYMM,'RRRRMM')   DAY_LIAB
             FROM  X_LIABILITY_RECON_SUM
            WHERE  LR_LIC_CHA_COM LIKE 'MNET'
              AND  LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
              AND  LR_LIC_CUR LIKE '%'
              AND  LR_YYYYMM >= L_START_YYYYMM
              AND  LR_YYYYMM <= L_END_YYYYMM
              AND  (
                    LR_LIC_TYPE LIKE NVL('%','%')
                    OR '%' IS NULL
                   )
              );


      DBMS_OUTPUT.PUT_LINE(L_LIAB_DATE);
      DBMS_OUTPUT.PUT_LINE(l_DAY_LIAB);

    L_LTYPE_GROUP_QUERY := 'GROUP BY
      LR_LIC_CHA_COM,
      LR_LIC_CUR,
      LR_LOC_CUR,
      LR_YYYYMM,
      ROLLUP(LR_LIC_TYPE)';

  L_QUERY :=' SELECT 
    "Channel Company",
    "Lic Currency",
    "Recon Currency",
    "Lic Type",
    Unique_Key,
    REPORT_TYPE ,
    '||l_DAY_LIAB||' 
    RANK FROM
 (';

		IF I_RECON_CURRENCY = 'LIC'
		THEN		--LICENSE CURRENCY
     L_QUERY:=L_QUERY||'
         SELECT
            A.Channel_Company "Channel Company",
            A.Lic_Currency "Lic Currency",
            A.Recon_Currency "Recon Currency",
            A.Lic_Type "Lic Type",
            A.Unique_Key,
            A.REPORT_TYPE ,
            '||l_DAY_LIAB||'
          CASE
              WHEN   A.Report_Type = ''Difference''			 		            THEN 1
              WHEN   A.Report_Type = ''O/B - Liability''		 		        THEN 2
              WHEN   A.Report_Type = ''Additions''				 		          THEN 3
              WHEN   A.Report_Type = ''FLF Price Changes/Revaluations'' THEN 4
              WHEN   A.Report_Type = ''Cancellations''					        THEN 5
              WHEN   A.Report_Type = ''Reversals'' 					            THEN 6
              WHEN   A.Report_Type = ''Payments''						            THEN 7
              WHEN   A.Report_Type = ''Adjustments (Payments)''		      THEN 8
              WHEN   A.Report_Type = ''Transfers (Payments)''			      THEN 9
              WHEN   A.Report_Type = ''Pre-Payment Movements'' 		      THEN 10
              WHEN   A.Report_Type = ''C/B - Liability Calculated''	    THEN 11
              WHEN   A.Report_Type = ''C/B - Liability Report'' 		    THEN 12
          END RANK,
          CASE
             WHEN   A.Lic_Type =''Total''                             THEN 1
             WHEN   A.Lic_Type =''FLF''                               THEN 2
             WHEN   A.Lic_Type =''ROY''                               THEN 3

          END RANK_LIC_TYPE
                    FROM
          (
             SELECT *
                    FROM(
                          SELECT *
                            FROM
                            (';

          L_QUERY :=L_QUERY|| 'SELECT
          LR_LIC_CHA_COM      Channel_Company,
          LR_LIC_CUR          Lic_Currency,
          LR_LIC_CUR          Recon_Currency,
          ';


            L_QUERY := L_QUERY || 'NVL(LR_LIC_TYPE,''Total'') Lic_Type,
                                   LR_LIC_CHA_COM||LR_LIC_CUR||LR_LIC_CUR Unique_Key,';


          L_QUERY := L_QUERY || ' TO_CHAR(TO_DATE(LR_YYYYMM, ' || '''YYYYMM''' || '), ' || '''Mon-YY''' || ') YEAR_MONTH,
					X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND((
					NVL(SUM(LR_LIC_OB_LIAB),0) 						+
					NVL(SUM(LR_LIC_ADDITIONS),0) 					+
					NVL(SUM(LR_LIC_FLF_CHANGE_REVAL),0) 	+
					NVL(SUM(LR_LIC_REVERSAL),0) 					+
					NVL(SUM(LR_LIC_CANCELLATION),0)				-
					NVL(SUM(LR_LIC_PAYMENTS),0)						-
					NVL(SUM(LR_LIC_ADJ_PAY),0) 						-
					NVL(SUM(LR_LIC_TRANSFER_PAY),0) 			-
					NVL(SUM(LR_LIC_MOVEMENT),0)
					)-
					NVL(SUM(LR_LIC_CB_LIAB),0)
					)) Difference,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_OB_LIAB))              Liability,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_ADDITIONS))            Additions,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_FLF_CHANGE_REVAL))     FLF_Price_Changes_Revaluations,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_CANCELLATION))         Cancellations,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_REVERSAL))             Reversals,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_PAYMENTS)*(-1)))      Payments,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_ADJ_PAY)*(-1)))       Adjustments_Payments,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_TRANSFER_PAY)*(-1)))  Transfers_Payments,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_MOVEMENT)*(-1)))      Pre_Payment_Movements,

					X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(
					ROUND(
					NVL(SUM(LR_LIC_OB_LIAB),0) 						+
					NVL(SUM(LR_LIC_ADDITIONS),0) 					+
					NVL(SUM(LR_LIC_FLF_CHANGE_REVAL),0) 	+
					NVL(SUM(LR_LIC_REVERSAL),0) 					+
					NVL(SUM(LR_LIC_CANCELLATION),0)				-
					NVL(SUM(LR_LIC_PAYMENTS),0)						-
					NVL(SUM(LR_LIC_ADJ_PAY),0) 						-
					NVL(SUM(LR_LIC_TRANSFER_PAY),0) 			-
					NVL(SUM(LR_LIC_MOVEMENT),0)
					)
					)
					CB_Liability_Calculated,
           X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LIC_CB_LIAB)) CB_Liability_Report
          --ROUND(SUM(LR_LIC_LIAB_DIFF)) "Difference"
              FROM
                X_LIABILITY_RECON_SUM
              WHERE
                LR_LIC_CHA_COM LIKE ''' || I_CHANNEL_COMPANY || '''
                AND LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                AND LR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                AND LR_YYYYMM >= ''' || L_START_YYYYMM || '''
                AND LR_YYYYMM <= ''' || L_END_YYYYMM || '''
                AND (
                      LR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL
                    )   ';


              L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;

           L_QUERY := L_QUERY||'
                         )
                         UNPIVOT (quantity FOR Report_Type IN
                         (
                          DIFFERENCE                      as ''Difference'' ,
                          LIABILITY                       as ''O/B - Liability'',
                          ADDITIONS                       as ''Additions'' ,
                          FLF_Price_Changes_Revaluations  as ''FLF Price Changes/Revaluations'',
                          Cancellations                   as ''Cancellations'' ,
                          Reversals                       as ''Reversals'',
                          Payments                        as ''Payments'',
                          Adjustments_Payments            as ''Adjustments (Payments)'' ,
                          Transfers_Payments              as ''Transfers (Payments)'',
                          Pre_Payment_Movements           as ''Pre-Payment Movements'',
                          CB_Liability_Calculated         as ''C/B - Liability Calculated'' ,
                          CB_Liability_Report             as ''C/B - Liability Report''
                         )
                         )
                         order by 1,2,3,5,6,4,5
                         )
                         PIVOT (min(quantity) FOR YEAR_MONTH IN ('||L_LIAB_DATE||'))
                         ORDER BY 1,2,3,5,4';
		ELSE		--RECON CURRENCY


     L_QUERY:=L_QUERY||'
          SELECT
            A.Channel_Company "Channel Company",
            A.Lic_Currency "Lic Currency",
            A.Recon_Currency "Recon Currency",
            A.Lic_Type "Lic Type",
            A.Unique_Key,
            A.REPORT_TYPE "REPORT_TYPE",
            '||l_DAY_LIAB||'
          CASE
              WHEN   A.Report_Type = ''Difference''			 		            THEN 1
              WHEN   A.Report_Type = ''O/B - Liability''		 		        THEN 2
              WHEN   A.Report_Type = ''Additions''				 		          THEN 3
              WHEN   A.Report_Type = ''FLF Price Changes/Revaluations'' THEN 4
              WHEN   A.Report_Type = ''Cancellations''					        THEN 5
              WHEN   A.Report_Type = ''Reversals'' 					            THEN 6
              WHEN   A.Report_Type = ''Payments''						            THEN 7
              WHEN   A.Report_Type = ''Adjustments (Payments)''		      THEN 8
              WHEN   A.Report_Type = ''Transfers (Payments)''			      THEN 9
              WHEN   A.Report_Type = ''Pre-Payment Movements'' 		      THEN 10
              WHEN   A.Report_Type = ''Realised Forex''	                THEN 11
              WHEN   A.Report_Type = ''C/B - Liability Calculated''	    THEN 12
              WHEN   A.Report_Type = ''C/B - Liability Report'' 		    THEN 13

          END RANK,
          CASE
             WHEN   A.Lic_Type =''Total''                             THEN 1
             WHEN   A.Lic_Type =''FLF''                               THEN 2
             WHEN   A.Lic_Type =''ROY''                               THEN 3

          END RANK_LIC_TYPE
              FROM
              (
                 SELECT *
                        FROM(
                              SELECT *
                                FROM
                                (';
				  L_QUERY :=L_QUERY || 'SELECT
          LR_LIC_CHA_COM    Channel_Company,
          LR_LIC_CUR        Lic_Currency,
          LR_LOC_CUR        Recon_Currency,
          ';

            L_QUERY := L_QUERY || 'NVL(LR_LIC_TYPE,''Total'') Lic_Type,
                                   LR_LIC_CHA_COM||LR_LIC_CUR||LR_LIC_CUR Unique_Key,';


          L_QUERY := L_QUERY || '  TO_CHAR(TO_DATE(LR_YYYYMM, ' || '''YYYYMM''' || '), ' || '''Mon-YY''' || ') YEAR_MONTH,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(ROUND((
					NVL(SUM(LR_LOC_OB_LIAB),0) 				 		+
					NVL(SUM(LR_LOC_ADDITIONS),0) 			 		+
					NVL(SUM(LR_LOC_FLF_CHANGE_REVAL),0) 	+
					NVL(SUM(LR_LOC_REVERSAL),0) 				 	+
					NVL(SUM(LR_LOC_CANCELLATION),0) 		 	-
					NVL(SUM(LR_LOC_PAYMENTS),0) 				 	-
					NVL(SUM(LR_LOC_ADJ_PAY),0) 				 		-
					NVL(SUM(LR_LOC_TRANSFER_PAY),0) 		 	-
					NVL(SUM(LR_LIC_RGL),0)              	-
					NVL(SUM(LR_LOC_MOVEMENT),0)
					)-
					NVL(SUM(LR_LOC_CB_LIAB),0)
					)) as Difference,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_OB_LIAB))              Liability,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_ADDITIONS))            Additions,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_FLF_CHANGE_REVAL))     FLF_Price_Changes_Revaluations,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_CANCELLATION))         Cancellations,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_REVERSAL))             Reversals,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LOC_PAYMENTS)*(-1)))      Payments,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LOC_ADJ_PAY)*(-1)))       Adjustments_Payments,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LOC_TRANSFER_PAY)*(-1)))  Transfers_Payments,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LIC_RGL)*(-1)))           Realised_Forex,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER((SUM(LR_LOC_MOVEMENT)*(-1)))      Pre_Payment_Movements,
					X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(
					ROUND(
					NVL(SUM(LR_LOC_OB_LIAB),0) 				 		+
					NVL(SUM(LR_LOC_ADDITIONS),0) 			 		+
					NVL(SUM(LR_LOC_FLF_CHANGE_REVAL),0) 	+
					NVL(SUM(LR_LOC_REVERSAL),0) 				 	+
					NVL(SUM(LR_LOC_CANCELLATION),0) 		 	-
					NVL(SUM(LR_LOC_PAYMENTS),0) 				 	-
					NVL(SUM(LR_LOC_ADJ_PAY),0) 				 		-
					NVL(SUM(LR_LOC_TRANSFER_PAY),0) 		 	-
					NVL(SUM(LR_LIC_RGL),0)              	-
					NVL(SUM(LR_LOC_MOVEMENT),0)
					)
					)CB_Liability_Calculated,
          X_PKG_LINEAR_RECON.X_FNC_FORMAT_NUMBER(SUM(LR_LOC_CB_LIAB))     CB_Liability_Report

              FROM
                X_LIABILITY_RECON_SUM
              WHERE
                LR_LIC_CHA_COM LIKE ''' || I_CHANNEL_COMPANY || '''
                AND LR_LIC_CHA_COM <> (SELECT COM_SHORT_NAME  FROM FID_COMPANY WHERE COM_NUMBER = 50268)
                AND LR_LIC_CUR LIKE ''' || I_LICENSE_CURRENCY || '''
                AND LR_YYYYMM >= ''' || L_START_YYYYMM || '''
                AND LR_YYYYMM <= ''' || L_END_YYYYMM || '''
                AND (
                      LR_LIC_TYPE LIKE ''' || I_LICENSE_TYPE || '''
                      OR ''' || I_LICENSE_TYPE || ''' IS NULL
                    )

        ';

              L_QUERY := L_QUERY || L_LTYPE_GROUP_QUERY;

            L_QUERY := L_QUERY||'
                         )
                         UNPIVOT (quantity FOR Report_Type IN
                         (
                          DIFFERENCE                      as ''Difference'' ,
                          LIABILITY                       as ''O/B - Liability'',
                          ADDITIONS                       as ''Additions'' ,
                          FLF_Price_Changes_Revaluations  as ''FLF Price Changes/Revaluations'',
                          Cancellations                   as ''Cancellations'' ,
                          Reversals                       as ''Reversals'',
                          Payments                        as ''Payments'',
                          Adjustments_Payments            as ''Adjustments (Payments)'' ,
                          Transfers_Payments              as ''Transfers (Payments)'',
                          Realised_Forex                  as ''Realised Forex'' ,
                          Pre_Payment_Movements           as ''Pre-Payment Movements'',
                          CB_Liability_Calculated         as ''C/B - Liability Calculated'' ,
                          CB_Liability_Report             as ''C/B - Liability Report''
                         )
                         )
                         order by 1,2,3,5,6,4,5
                         )
                         PIVOT (min(quantity) FOR YEAR_MONTH IN ('||L_LIAB_DATE||'))
                         ORDER BY 1,2,3,5,4';
		END IF;
      L_QUERY:=L_QUERY||')A
                          ORDER BY 1,2,3,RANK ,RANK_LIC_TYPE)table_alise';
    dbms_output.put_line(L_QUERY);
		OPEN O_LIAB_RECON FOR L_QUERY;

   END X_PRC_LIAB_RECON_SEARCH;
--****************************************************************
-- FINACE DEV PHASE I [ANKUR KASAR] [END]
-- REM Client - MNET
--****************************************************************
END X_PKG_LINEAR_RECON;
/