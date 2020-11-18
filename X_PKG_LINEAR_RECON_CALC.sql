create or replace PACKAGE             "X_PKG_LINEAR_RECON_CALC" AS
/**************************************************************************
REM Module          : MNET Finance
REM Client          : MNET
REM File Name       : X_PKG_LINEAR_RECON_CALC
REM Purpose         : Does the Monthly Reconciliation for selected month
REM Written By      : Jawahar Garg
REM Date            : 18-June-2016
REM Type            : Database Package
REM Change History  : Created
REM **************************************************************************/


--****************************************************************
-- This procedure is called for doing Inventory Reconciliation
-- REM Client - MNET
--****************************************************************
  PROCEDURE x_prc_inventory_recon (
      I_RECON_MONTH              IN              DATE
  );

--****************************************************************
-- This procedure is called for doing Pre-Payment Reconciliation
-- REM Client - MNET
--****************************************************************
  PROCEDURE X_PRC_PRE_PAYMENT_RECON (
			I_RECON_MONTH              IN              DATE
	);

--****************************************************************
-- This procedure is called for doing Liability Reconciliation
-- REM Client - MNET
--****************************************************************
  PROCEDURE x_prc_liability_recon (
			I_RECON_MONTH              IN              DATE
	);

--****************************************************************
-- This function returns the value of paid amount in local currency.
-- REM Client - MNET
--****************************************************************
  FUNCTION PAID_AMOUNT_LOCAL_RECON (
      I_LIC_NUMBER               IN              FID_LICENSE.LIC_NUMBER%TYPE,
      I_LIC_CURRENCY             IN              FID_LICENSE.LIC_CURRENCY%TYPE,
      I_PERIOD                   IN              DATE,
      I_LSL_NUMBER               IN              X_FIN_LIC_SEC_LEE.LSL_NUMBER%TYPE
   )
   RETURN NUMBER;

--****************************************************************
-- This function returns the value of RGL for Commitments Paid.
-- REM Client - MNET
--****************************************************************
  FUNCTION X_FNC_GET_COMMITPAY_RGL
  (
      I_LIC_NUMBER               IN              NUMBER,
      I_LSL_NUMBER               IN              NUMBER,
      I_PERIOD                   IN              DATE
  )
  RETURN NUMBER;

--****************************************************************
-- This function returns the value of RGL for Prepayments.
-- REM Client - MNET
--****************************************************************
  FUNCTION X_FNC_GET_PREPAY_RGL
  (
      I_PERIOD 		               IN              DATE,
      I_LSL_NUMBER               IN              NUMBER,
      I_PAY_NUMBER               IN              NUMBER
  )
  RETURN NUMBER;

	PROCEDURE X_PRC_LINEAR_RECON_CALC(
      I_RECON_MONTH             IN      NUMBER,
      I_RECON_YEAR              IN      NUMBER,
      I_RECON_USER              IN      VARCHAR2
 );

   FUNCTION calc_local_liability1 (
				i_lic_number   IN   fid_license.lic_number%TYPE,
				i_lsl_number   IN   x_fin_lic_sec_lee.lsl_number%TYPE,
				i_liab_amt     IN   NUMBER,
				i_rate         IN   NUMBER,
				i_lic_start    IN   fid_license.lic_start%TYPE,
				i_period       IN   DATE
		 )RETURN NUMBER;

	 FUNCTION X_FNC_CAL_LOCAL_LIAB (
												  i_lic_currency          IN   fid_license.lic_currency%TYPE,
												  i_lic_number            IN   fid_license.lic_number%TYPE,
												  i_lsl_number            IN   NUMBER,
												  i_period                IN   DATE,
												  i_v_go_live_date        IN   DATE,
												  i_rat_rate              IN   NUMBER,
												  i_lic_acct_date		  IN   DATE,
												  i_lic_start			  IN   DATE,
												  i_lic_cancel_date		  IN   DATE,
												  i_lic_start_rate		  IN   NUMBER,
												  i_lic_status			  IN   VARCHAR2,
												  i_calc_paid_liability   IN   NUMBER
												)
	 RETURN NUMBER;

	 PROCEDURE X_PRC_INSERT_RECON_SUM_DATA(
	I_RECON_USER		              IN			VARCHAR2,
	I_RECON_PERIOD		            IN			NUMBER
);


	PROCEDURE X_PRC_RECON_CLEANUP(
		I_RECON_YYYYMM      IN      DATE
	);

END X_PKG_LINEAR_RECON_CALC;
/
create or replace PACKAGE BODY "X_PKG_LINEAR_RECON_CALC" AS

  PROCEDURE X_PRC_LINEAR_RECON_CALC(
      I_RECON_MONTH             IN      NUMBER,
      I_RECON_YEAR              IN      NUMBER,
      I_RECON_USER              IN      VARCHAR2
 )
 AS
    L_RECON_PERIOD            DATE;
 BEGIN
     EXECUTE IMMEDIATE 'TRUNCATE TABLE X_GTT_CONTENT_LIAB';
	   
	   EXECUTE IMMEDIATE 'TRUNCATE TABLE X_GTT_INV_DATA';
     
     
 L_RECON_PERIOD := TO_DATE(I_RECON_YEAR || LPAD(I_RECON_MONTH, 2, 0), 'YYYYMM');

    X_PKG_LINEAR_RECON_CALC.X_PRC_PRE_PAYMENT_RECON(L_RECON_PERIOD);

    --X_PKG_LINEAR_RECON_CALC.X_PRC_LIABILITY_RECON(L_RECON_PERIOD);

	  --X_PKG_LINEAR_RECON_CALC.x_prc_inventory_recon(L_RECON_PERIOD);

	  X_PKG_LINEAR_RECON_CALC.X_PRC_INSERT_RECON_SUM_DATA(I_RECON_USER   => I_RECON_USER,
														I_RECON_PERIOD => TO_NUMBER(I_RECON_YEAR || LPAD(I_RECON_MONTH,2,0))
														);

														
	X_PKG_LINEAR_RECON_CALC.X_PRC_RECON_CLEANUP(I_RECON_YYYYMM =>L_RECON_PERIOD);
	COMMIT;
 END X_PRC_LINEAR_RECON_CALC;
 
  PROCEDURE x_prc_inventory_recon (
      I_RECON_MONTH   IN  DATE
  )
  AS
  
--****************************************************************
-- This procedure is called for doing Inventory Reconciliation
-- REM Client - MNET
--****************************************************************
  v_golive_date 					DATE;
  l_period_last_month 	  DATE := ADD_MONTHs(I_RECON_MONTH,-1);
  L_PERIOD_YYYYMM					NUMBER:= TO_NUMBER(TO_CHAR(I_RECON_MONTH,'YYYYMM'));
  L_PERIOD_START          DATE := ADD_MONTHS (LAST_DAY (I_RECON_MONTH), -1) + 1;
  L_PERIOD_END            DATE := LAST_DAY(I_RECON_MONTH);

		CURSOR inv_cur
		IS
		SELECT
					LIC_NUMBER,
					LSL_NUMBER,
					LIC_TYPE,
					LIC_CURRENCY,
          --New Column Added  
          COM_NUMBER,
          COM_CURRENCY,
          LIC_LEE_NUMBER,
          LIC_BUDGET_CODE,  

					---------------------OPENING BAL VALUE-----------------          
          IR_LIC_SUM_ASSET_CLOSING_O,
          IR_LOC_SUM_ASSET_CLOSING_O,
          IR_LIC_SUM_COST_CLOSING_O,
          IR_LOC_SUM_COST_CLOSING_O,
					---------Movement Summary Cost LIC and Local--------------
           LIC_MOV_COST_INC_MU,
           LOC_MOV_COST_INC_MU,          
          	--------------LIC ASSET AND COST--------------------------
					 LIC_ASSET_INC_MU_C,
					 LIC_COST_INC_MU_C,
					-------------LOC ASSET AND COST---------------------------
					 LOC_ASSET_INC_MU_C,
					 LOC_COST_INC_MU_C,
					-------------LIC PROG INV EXP ASSET AND COST--------------
          
          INV_EXP.LIC_PRG_EXP_ASSET AS LIC_PRG_EXP_ASSET_INC_MU,
          INV_EXP.LOC_PRG_EXP_ASSET AS LOC_PRG_EXP_ASSET_INC_MU,
          INV_EXP.LIC_PRG_EXP_COST  AS LIC_PRG_EXP_COST_INC_MU,
          INV_EXP.LOC_PRG_EXP_COST  AS LOC_PRG_EXP_COST_INC_MU       
             
		FROM(
    
    SELECT 
          LIC_NUMBER,
          LSL_NUMBER,
          LIC_TYPE,
          LIC_CURRENCY,
          
          SUM(IR_LIC_SUM_ASSET_CLOSING_O) AS IR_LIC_SUM_ASSET_CLOSING_O,
          SUM(IR_LOC_SUM_ASSET_CLOSING_O) AS IR_LOC_SUM_ASSET_CLOSING_O,    
          SUM(IR_LIC_SUM_COST_CLOSING_O)  AS IR_LIC_SUM_COST_CLOSING_O,
          SUM(IR_LOC_SUM_COST_CLOSING_O)  AS IR_LOC_SUM_COST_CLOSING_O,
          
          SUM(LIC_ASSET_INC_MU_C) AS LIC_ASSET_INC_MU_C,
          SUM(LIC_COST_INC_MU_C)  AS LIC_COST_INC_MU_C,
          SUM(LOC_ASSET_INC_MU_C) AS LOC_ASSET_INC_MU_C,
          SUM(LOC_COST_INC_MU_C)  AS LOC_COST_INC_MU_C,
        --New Column Added  
          COM_NUMBER,
          COM_CURRENCY,
          LIC_LEE_NUMBER,
          LIC_BUDGET_CODE

          
    FROM 
    (    
					SELECT  
                  LIC_NUMBER,
									LSL_NUMBER,
									LIC_TYPE,
									LIC_CURRENCY,
                  --New Column Added  
                  FL.COM_NUMBER,
                  FL.COM_CURRENCY,
                  FL.LIC_LEE_NUMBER,
                  FL.LIC_BUDGET_CODE,                  
                  
                  0 AS IR_LIC_SUM_ASSET_CLOSING_O ,
                  0 AS IR_LOC_SUM_ASSET_CLOSING_O,    
                  0 AS IR_LIC_SUM_COST_CLOSING_O,
                  0 AS IR_LOC_SUM_COST_CLOSING_O,
                  
									 LIC_ASSET_INC_MU_C                            AS LIC_ASSET_INC_MU_C,
								 	 LIC_COST_INC_MU_BEFGOLIVE_C                   AS LIC_COST_INC_MU_C,
									(LIC_ASSET_INC_MU_C * fer.rat_rate)  				   AS LOC_ASSET_INC_MU_C,
									(LIC_COST_INC_MU_BEFGOLIVE_C * fer.rat_rate)   AS LOC_COST_INC_MU_C
                  
						 FROM X_GTT_INV_DATA lbl,
									x_vw_lic_details fl,
									fid_exchange_rate fer,
									fid_region fr
					 where fl.lic_number	= lbl.lis_lic_number
					   AND fl.LSL_NUMBER = lbl.LIS_LSL_NUMBER
						 AND fl.lic_status <> 'T'
						 AND fer.rat_cur_code = fl.lic_currency
             AND fer.rat_cur_code_2(+) = fl.COM_CURRENCY
						 and fl.lee_region_id = fr.reg_id
						 AND fl.lic_start < v_golive_date
						 AND (   EXISTS (
													 SELECT   'X',SUM(slx.cf_m_ca_p_cadj)
															 FROM x_mv_movement_sum_ex_1 slx
															WHERE slx.lis_lic_number = fl.lic_number
																AND slx.lis_yyyymm_num <= l_period_yyyymm
													 GROUP BY 'X'
														 HAVING ROUND(SUM(slx.cf_m_ca_p_cadj),0) != 0)
                       OR (    fl.lic_acct_date <= TRUNC(LAST_DAY(I_RECON_MONTH))
                           AND fl.lic_end > TRUNC(LAST_DAY(I_RECON_MONTH))
												)
								 )
					UNION ALL
					SELECT  LIC_NUMBER,
							LSL_NUMBER,
							LIC_TYPE,
							LIC_CURRENCY,
              --New Column Added  
              FL.COM_NUMBER,
              FL.COM_CURRENCY,
              FL.LIC_LEE_NUMBER,
              FL.LIC_BUDGET_CODE,
                  
							0 AS IR_LIC_SUM_ASSET_CLOSING_O ,
							0 AS IR_LOC_SUM_ASSET_CLOSING_O,    
							0 AS IR_LIC_SUM_COST_CLOSING_O,
							0 AS IR_LOC_SUM_COST_CLOSING_O,
							LIC_ASSET_INC_MU_C,
							LIC_COST_INC_MU_AFTGOLIVE_C,
							LOC_ASSET_INC_MU_AFTGOLIVE_C,
							LOC_COST_INC_MU_AFTGOLIVE_C 
					   FROM X_GTT_INV_DATA lbl,
							x_vw_lic_details fl
					  where fl.lic_number	= lbl.lis_lic_number
						AND fl.LSL_NUMBER = lbl.LIS_LSL_NUMBER
						AND fl.LIC_STATUS IN ('A', 'C')
						AND fl.lic_start >= v_golive_date
						AND (EXISTS (
													 SELECT   'X',SUM(slx.cf_m_ca_p_cadj)
															 FROM x_mv_movement_sum_ex_2 slx
															WHERE slx.lis_lic_number = fl.lic_number
															  AND slx.lis_lsl_number = fl.LSL_NUMBER
															  AND slx.lis_yyyymm_num <= l_period_yyyymm
													 GROUP BY 'X'
														HAVING( ROUND(SUM(slx.cf_m_ca_p_cadj),0) != 0
																OR ROUND(SUM(slx.lf_m_la_p_ladj),0) != 0
															   )
									)						   
                       OR (    fl.lic_acct_date <= TRUNC(LAST_DAY(I_RECON_MONTH))
                           AND fl.lic_end > TRUNC(LAST_DAY(I_RECON_MONTH))
												)
							)
                 UNION ALL 
                SELECT  
                
                  IR_LIC_NUMBER,
                  IR_LSL_NUMBER,
                  IR_LIC_TYPE,                
                  IR_LIC_CUR,
                  --New Column Added  
                  IR_LIC_CHA_COM_NUMBER,
                  IR_LOC_CUR,
                  IR_LIC_LEE_NUMBER,
                  IR_LIC_BUD_CODE, 		

                
                 IR_LIC_SUM_ASSET_CLOSING AS  IR_LIC_SUM_ASSET_CLOSING_O ,
                 IR_LOC_SUM_ASSET_CLOSING AS  IR_LOC_SUM_ASSET_CLOSING_O,    
                 IR_LIC_SUM_COST_CLOSING  AS  IR_LIC_SUM_COST_CLOSING_O,
                 IR_LOC_SUM_COST_CLOSING  AS  IR_LOC_SUM_COST_CLOSING_O,
                  
                  0 AS LIC_ASSET_INC_MU_C,
                  0 AS LIC_COST_INC_MU_C,
                  0 AS LOC_ASSET_INC_MU_C,
                  0 AS LOC_COST_INC_MU_C
                 FROM X_INVENTORY_RECON
                 WHERE IR_YYYYMM  = TO_NUMBER(TO_CHAR(l_period_last_month,'RRRRMM'))
								   AND (    	NVL(IR_LIC_SUM_ASSET_CLOSING,0) <> 0
													 OR NVL(IR_LOC_SUM_ASSET_CLOSING,0) <> 0
												   OR NVL(IR_LIC_SUM_COST_CLOSING,0)  <> 0
												   OR NVL(IR_LOC_SUM_COST_CLOSING,0)  <> 0
												)
					)
          GROUP BY 
                  LIC_NUMBER,
									LSL_NUMBER,
									LIC_TYPE,
									LIC_CURRENCY,
                  COM_NUMBER,
                  COM_CURRENCY,
                  LIC_LEE_NUMBER,
                  LIC_BUDGET_CODE
          )A,
					(
					 SELECT
									SUM(LIS_CON_AA_IMU_23)  				AS LIC_MOV_COST_INC_MU,	--LIC COST INC MU AFTER GOLIVE
									---------------------------LOC CURRENCY------------------------------------------
									SUM((lis_loc_aa_emu + lis_loc_aa_mu_2)) AS LOC_MOV_COST_INC_MU,--LOC COST INC MU AFTER GOLIVE CLOSING
									lis_lic_number,
									LIS_LSL_NUMBER
					FROM    X_MV_SUBLEDGER_DATA mv
					WHERE   LIS_YYYYMM_NUM = l_period_yyyymm
					GROUP BY lis_lic_number,
									 LIS_LSL_NUMBER
					HAVING ( SUM(LIS_CON_AA_IMU_23) <> 0 OR SUM((lis_loc_aa_emu + lis_loc_aa_mu_2)) <> 0 )
					)mov_sum_cost,				
					(
					SELECT
								 lis_lic_number,
								 LIS_LSL_NUMBER,
								 SUM(LIC_PRG_EXP_ASSET) as LIC_PRG_EXP_ASSET,
								 SUM(LOC_PRG_EXP_ASSET) as LOC_PRG_EXP_ASSET,
								 SUM(LIC_PRG_EXP_COST)  as LIC_PRG_EXP_COST,
								 SUM(LOC_PRG_EXP_COST)  as LOC_PRG_EXP_COST
					FROM
					(
					SELECT
					       fl.lic_number as lis_lic_number,
								 fl.LSL_NUMBER as LIS_LSL_NUMBER ,
								 LIC_ASSET_INC_MU_C AS LIC_PRG_EXP_ASSET,
								 CASE WHEN fl.lic_start >= v_golive_date
									THEN
											(LIC_ASSET_INC_MU_C * lic_rate)
									ELSE
											LIC_ASSET_INC_MU_C * fer.rat_rate
									END AS LOC_PRG_EXP_ASSET,
									CASE WHEN fl.lic_start >= v_golive_date
									THEN
											LIC_COST_INC_MU_AFTGOLIVE_C
									ELSE
											LIC_COST_INC_MU_BEFGOLIVE_C
									END LIC_PRG_EXP_COST,
									CASE WHEN fl.lic_start >= v_golive_date
									THEN
											(LIC_COST_INC_MU_AFTGOLIVE_C * lic_rate)
									ELSE
											LIC_COST_INC_MU_BEFGOLIVE_C * fer.rat_rate
									END LOC_PRG_EXP_COST
						FROM X_GTT_INV_DATA lbl,
								 x_vw_lic_details fl,
								 fid_exchange_rate fer
					 WHERE  fl.lic_number	= lbl.lis_lic_number
							AND fl.LSL_NUMBER = lbl.LIS_LSL_NUMBER
							AND fer.rat_cur_code = fl.lic_currency
							AND fer.rat_cur_code_2(+) = fl.COM_CURRENCY
							AND fl.lic_status NOT IN ('F', 'T')
							AND fl.lic_end >= L_PERIOD_START
							AND fl.lic_end < = L_PERIOD_END
					)GROUP BY  lis_lic_number,
										 LIS_LSL_NUMBER
					)INV_EXP
	 WHERE  A.LIC_NUMBER = mov_sum_cost.lis_lic_number(+)
		 AND  A.LSL_NUMBER = mov_sum_cost.LIS_LSL_NUMBER(+)
		 AND  A.LIC_NUMBER = INV_EXP.lis_lic_number(+)
		 AND  A.LSL_NUMBER = INV_EXP.LIS_LSL_NUMBER(+);

INV_cur_type           INV_cur%rowtype;

TYPE INV_rec_cur IS TABLE OF INV_cur_type%TYPE INDEX BY pls_integer;

v_INV_cur		INV_rec_cur;

v_SQL VARCHAR2(1000);

BEGIN
      SELECT content
			INTO v_golive_date
			FROM x_fin_configs
			WHERE ID = 1;

        delete X_INVENTORY_RECON where IR_YYYYMM = l_period_yyyymm;
	    DELETE X_GTT_INV_DATA;
		COMMIT;

		 INSERT INTO X_GTT_INV_DATA
					 (
						LIC_ASSET_INC_MU_C,
						LIC_COST_INC_MU_AFTGOLIVE_C,
						LIC_COST_INC_MU_BEFGOLIVE_C,
						LOC_ASSET_INC_MU_AFTGOLIVE_C,
						LOC_COST_INC_MU_AFTGOLIVE_C,
						LIS_LIC_NUMBER,
						LIS_LSL_NUMBER
					 )
        SELECT
							---------------------------LIC CURRENCY----------------------------------------------
									SUM(lis_con_fc_imu) 	as LIC_ASSET_INC_MU_C,						--LIC ASSET INC MU CLOSING
									SUM(LIS_CON_AA_IMU_23)  as LIC_COST_INC_MU_AFTGOLIVE_C,	--LIC COST INC MU AFTER GOLIVE CLOSING
									SUM(lis_con_aa_imu_1)   as LIC_COST_INC_MU_BEFGOLIVE_C,	--LIC COST INC MU BEFORE GOLIVE CLOSING
									---------------------------LOC CURRENCY----------------------------------
									SUM((lis_loc_fc_emu_23 + LIS_LOC_FC_MU))   				AS LOC_ASSET_INC_MU_AFTGOLIVE_C, 			--LOC ASSET INC MU AFTER GOLIVE CLOSING
									SUM((lis_loc_aa_emu + lis_loc_aa_mu_2))  				  AS LOC_COST_INC_MU_AFTGOLIVE_C, 			--LOC COST INC MU AFTER GOLIVE CLOSING
								    lis_lic_number,
									LIS_LSL_NUMBER
					FROM    X_MV_SUBLEDGER_DATA lbl
					 WHERE  LIS_YYYYMM_NUM <= TO_NUMBER(TO_CHAR(I_RECON_MONTH,'YYYYMM'))
				  GROUP BY  lis_lic_number,
							LIS_LSL_NUMBER
					HAVING ( 	SUM(lis_con_fc_imu) <> 0 
							OR SUM(LIS_CON_AA_IMU_23) <> 0 
							OR SUM(lis_con_aa_imu_1) <> 0
							OR SUM((lis_loc_fc_emu_23 + LIS_LOC_FC_MU)) <> 0
							OR SUM((lis_loc_aa_emu + lis_loc_aa_mu_2))  <> 0
							);
			COMMIT;

			OPEN inv_cur;
			LOOP
			    FETCH inv_cur BULK COLLECT INTO v_inv_cur LIMIT 10000;
			    EXIT WHEN v_inv_cur.COUNT = 0;
					--dbms_output.put_line( '  l_opening_bal: '|| i.OPENING_BAL|| '  closing_bal:  ' || i.CLOSING_BAL || '  l_pre_pay: ' || i.PRE_PAY || '  l_pre_pay_adj: ' || i.PRE_PAY_ADJ  || '  l_pre_pay_movement: ' || i.pre_pay_movement );

          FORALL i IN 1..v_inv_cur.COUNT

	  INSERT INTO X_INVENTORY_RECON
							 (
								IR_LIC_NUMBER,
								IR_MONTH,
								IR_YEAR,
                IR_LSL_NUMBER,
								IR_LIC_CUR,
								IR_LIC_TYPE,
								IR_LIC_MOV_COST,
								IR_LOC_MOV_COST,

								IR_LIC_SUM_ASSET_OPENING,
								IR_LOC_SUM_ASSET_OPENING,
								
								IR_LIC_SUM_COST_OPENING,
								IR_LOC_SUM_COST_OPENING,

								IR_LIC_SUM_ASSET_CLOSING,
								IR_LOC_SUM_ASSET_CLOSING,

								IR_LIC_SUM_COST_CLOSING,
								IR_LOC_SUM_COST_CLOSING,

								IR_LIC_PROG_INV_FEE,
								IR_LOC_PROG_INV_FEE,

								IR_LIC_PROG_INV_COST,
								IR_LOC_PROG_INV_COST,
                
                IR_LIC_CHA_COM_NUMBER,
                IR_LOC_CUR,
                IR_LIC_LEE_NUMBER,
                IR_LIC_BUD_CODE
								
							)
							VALUES
							(
								v_inv_cur(i).LIC_NUMBER,
								TO_CHAR(I_RECON_MONTH,'MM'),
								TO_CHAR(I_RECON_MONTH,'RRRR'),
								v_inv_cur(i).LSL_NUMBER,
								v_inv_cur(i).LIC_CURRENCY,
								v_inv_cur(i).LIC_TYPE,

								v_inv_cur(i).LIC_MOV_COST_INC_MU,
								v_inv_cur(i).LOC_MOV_COST_INC_MU,

								v_inv_cur(i).IR_LIC_SUM_ASSET_CLOSING_O,
								v_inv_cur(i).IR_LOC_SUM_ASSET_CLOSING_O,
								v_inv_cur(i).IR_LIC_SUM_COST_CLOSING_O,
								v_inv_cur(i).IR_LOC_SUM_COST_CLOSING_O,

								v_inv_cur(i).LIC_ASSET_INC_MU_C,           --IR_LIC_SUM_ASSET_CLOSING
								v_inv_cur(i).LOC_ASSET_INC_MU_C,					 --IR_LOC_SUM_ASSET_CLOSING
								v_inv_cur(i).LIC_COST_INC_MU_C,						 --IR_LIC_SUM_COST_CLOSING
								v_inv_cur(i).LOC_COST_INC_MU_C,						 --IR_LOC_SUM_COST_CLOSING

								v_inv_cur(i).LIC_PRG_EXP_ASSET_INC_MU,		 --IR_LIC_PROG_INV_FEE
								v_inv_cur(i).LOC_PRG_EXP_ASSET_INC_MU,		 --IR_LOC_PROG_INV_FEE
								v_inv_cur(i).LIC_PRG_EXP_COST_INC_MU,			 --IR_LIC_PROG_INV_COST
								v_inv_cur(i).LOC_PRG_EXP_COST_INC_MU,			 --IR_LOC_PROG_INV_COST
                --New Column Addded
                v_inv_cur(i).COM_NUMBER,
                v_inv_cur(i).COM_CURRENCY,
                v_inv_cur(i).LIC_LEE_NUMBER,
                v_inv_cur(i).LIC_BUDGET_CODE
							);
			COMMIT;

	END LOOP;


	--insert not matched data --

	INSERT INTO X_INVENTORY_RECON
							 (
								IR_LIC_NUMBER,
								IR_MONTH,
								IR_YEAR,
                IR_LSL_NUMBER,
								
								IR_LIC_CUR,
								IR_LIC_TYPE,
								
								IR_LIC_MOV_COST,
								IR_LOC_MOV_COST,

                IR_LIC_PROG_INV_FEE,
								IR_LOC_PROG_INV_FEE,

								IR_LIC_PROG_INV_COST,
								IR_LOC_PROG_INV_COST,

								IR_LIC_SUM_ASSET_CLOSING,
								IR_LOC_SUM_ASSET_CLOSING,

								IR_LIC_SUM_COST_CLOSING,
								IR_LOC_SUM_COST_CLOSING,
                --New Column Added
                IR_LIC_CHA_COM_NUMBER,
                IR_LOC_CUR,
                --New Column Added
                IR_LIC_LEE_NUMBER,
                IR_LIC_BUD_CODE
							)
					SELECT
              		lis_lic_number,
                  TO_CHAR(I_RECON_MONTH,'MM'),
                  TO_CHAR(I_RECON_MONTH,'RRRR'),
                  LIS_LSL_NUMBER,
                	LIC_CURRENCY,
                	LIC_TYPE,
                  SUM(LIC_MOV_COST_INC_MU),
                  SUM(LOC_MOV_COST_INC_MU),
                  SUM(LIC_PRG_EXP_ASSET),
                  SUM(LOC_PRG_EXP_ASSET),
                  SUM(LIC_PRG_EXP_COST),
                  SUM(LOC_PRG_EXP_COST),
                  SUM(0),
                  SUM(0),
                  SUM(0),
                  SUM(0),
                  COM_NUMBER,
                  COM_CURRENCY,
                  LIC_LEE_NUMBER,
                  LIC_BUDGET_CODE
						FROM
							(
				     SELECT
									SUM(LIS_CON_AA_IMU_23)  								 AS LIC_MOV_COST_INC_MU,	--LIC COST INC MU AFTER GOLIVE
									---------------------------LOC CURRENCY------------------------------------------
									SUM((lis_loc_aa_emu + lis_loc_aa_mu_2))  AS LOC_MOV_COST_INC_MU, 	--LOC COST INC MU AFTER GOLIVE CLOSING

									0 as LIC_PRG_EXP_ASSET,
									0 as LOC_PRG_EXP_ASSET,
									0 as LIC_PRG_EXP_COST,
									0 as LOC_PRG_EXP_COST,                  
									lis_lic_number,
									LIS_LSL_NUMBER,
									LIC_TYPE,
									LIC_CURRENCY,
                   --New Column Added
                  FL.COM_NUMBER,
                  FL.COM_CURRENCY,
                  FL.LIC_LEE_NUMBER,
                  FL.LIC_BUDGET_CODE
					FROM    X_MV_SUBLEDGER_DATA mv,
					        x_vw_lic_details fl
						where fl.lic_number	= mv.lis_lic_number
						  AND fl.LSL_NUMBER = mv.LIS_LSL_NUMBER
					    and LIS_YYYYMM_NUM = l_period_yyyymm
					GROUP BY lis_lic_number,
									 LIS_LSL_NUMBER,
									 LIC_TYPE,
									 LIC_CURRENCY,
                   COM_NUMBER,
                   COM_CURRENCY,
                   LIC_LEE_NUMBER,
                   LIC_BUDGET_CODE
						HAVING (SUM(LIS_CON_AA_IMU_23) <> 0 OR SUM(lis_loc_aa_emu + lis_loc_aa_mu_2) <> 0)

					UNION ALL
					 SELECT SUM(0)  AS LIC_MOV_COST_INC_MU,
									SUM(0)  AS LOC_MOV_COST_INC_MU,
									SUM(LIC_PRG_EXP_ASSET) as LIC_PRG_EXP_ASSET,
									SUM(LOC_PRG_EXP_ASSET) as LOC_PRG_EXP_ASSET,
									SUM(LIC_PRG_EXP_COST)  as LIC_PRG_EXP_COST,
									SUM(LOC_PRG_EXP_COST)  as LOC_PRG_EXP_COST,
									lis_lic_number,
									LIS_LSL_NUMBER,
									LIC_TYPE,
									LIC_CURRENCY,
                    --New Column Added
                  COM_NUMBER,
                  COM_CURRENCY,
                  LIC_LEE_NUMBER,
                  LIC_BUDGET_CODE
					FROM
					(
								SELECT
											 fl.lic_number as lis_lic_number,
											 fl.LSL_NUMBER as LIS_LSL_NUMBER,
											 fl.LIC_TYPE,
											 fl.LIC_CURRENCY,
                         --New Column Added
                       FL.COM_NUMBER,
                       FL.COM_CURRENCY,
                       FL.LIC_LEE_NUMBER,
                       FL.LIC_BUDGET_CODE,
                       
											 LIC_ASSET_INC_MU_C AS LIC_PRG_EXP_ASSET,
											 CASE WHEN fl.lic_start >= v_golive_date
												THEN
														(LIC_ASSET_INC_MU_C * lic_rate)
												ELSE
														LIC_ASSET_INC_MU_C * fer.rat_rate
												END AS LOC_PRG_EXP_ASSET,
												CASE WHEN fl.lic_start >= v_golive_date
												THEN
														LIC_COST_INC_MU_AFTGOLIVE_C
												ELSE
														LIC_COST_INC_MU_BEFGOLIVE_C
												END LIC_PRG_EXP_COST,
												CASE WHEN fl.lic_start >= v_golive_date
												THEN
														(LIC_COST_INC_MU_AFTGOLIVE_C * lic_rate)
												ELSE
														LIC_COST_INC_MU_BEFGOLIVE_C * fer.rat_rate
												END LOC_PRG_EXP_COST
									FROM X_GTT_INV_DATA lbl,
											 x_vw_lic_details fl,
											 fid_exchange_rate fer
								 WHERE  fl.lic_number	= lbl.lis_lic_number
										AND fl.LSL_NUMBER = lbl.LIS_LSL_NUMBER
										AND fer.rat_cur_code = fl.lic_currency
										AND fer.rat_cur_code_2(+) = fl.COM_CURRENCY
										AND fl.lic_status NOT IN ('F', 'T')
										AND fl.lic_end >= L_PERIOD_START
										AND fl.lic_end < = L_PERIOD_END
								)GROUP BY lis_lic_number,
													LIS_LSL_NUMBER,
													LIC_TYPE,
													LIC_CURRENCY,
                          COM_NUMBER,
                          COM_CURRENCY,
                          LIC_LEE_NUMBER,
                          LIC_BUDGET_CODE
				  )A
					WHERE NOT EXISTS ( SELECT 1
					                     FROM X_INVENTORY_RECON
								              WHERE IR_LIC_NUMBER = a.lis_lic_number
																AND IR_LSL_NUMBER = a.LIS_LSL_NUMBER
															  AND IR_YYYYMM = L_PERIOD_YYYYMM
									 )
			 GROUP BY   lis_lic_number,
                  TO_CHAR(I_RECON_MONTH,'MM'),
                  TO_CHAR(I_RECON_MONTH,'RRRR'),
                  LIS_LSL_NUMBER,
                  LIC_CURRENCY,
                  LIC_TYPE,
                    --New Column Added
                  COM_NUMBER,
                  COM_CURRENCY,
                  LIC_LEE_NUMBER,
                  LIC_BUDGET_CODE;

	DELETE X_GTT_INV_DATA;

END x_prc_inventory_recon;

  PROCEDURE X_PRC_PRE_PAYMENT_RECON (
			I_RECON_MONTH              IN              DATE
	)
  AS
--****************************************************************
-- This procedure is called for doing Pre-Payment Reconciliation
-- REM Client - MNET
--****************************************************************
  l_period date := i_recon_month;
  l_prev_period date := add_months(l_period,-1);

  l_LIC_CALC_PRE_PAY  NUMBER;
  l_LOC_CALC_PRE_PAY	NUMBER;
	
	l_LIC_OPENING_BAL   NUMBER;
	l_LOC_OPENING_BAL   NUMBER;

  BEGIN

  delete X_PRE_PAYMENT_RECON where PR_YEAR||LPAD(PR_MONTH,2,0) = TO_CHAR(l_period,'RRRRMM');

  FOR I IN(SELECT
            LIC_NUMBER,
            LSL_NUMBER ,
            LIC_TYPE,
            LIC_CURRENCY,
            --New Column Added
            COM_NUMBER,
            COM_CURRENCY,
            LIC_LEE_NUMBER,
            LIC_BUDGET_CODE, 
            
						0  as OPENING_BAL,
						0  as LOC_OPENING_BAL,
            NVL(round(SUM(CLOSING_BAL),2),0) AS CLOSING_BAL,
            CASE WHEN NVL(round(SUM(CLOSING_BAL),2),0) = 0
            THEN
                0
            else
                (round(SUM(CLOSING_BAL*pay_rate),2) +  X_FNC_GET_COMMITPAY_RGL(LIC_NUMBER, LSL_NUMBER, L_PERIOD))
            END
            as LOC_CLOSING_BAL,

            --------Transfers (Pre-Payments)----------------------
            (SELECT sum(lis_con_pay) from fid_license_sub_ledger
              WHERE lis_lic_number = lic_number
                AND lis_lsl_number = lsl_number
                AND TO_CHAR(LIS_PER_YEAR|| LPAD(LIS_PER_MONTH,2,0)) = TO_CHAR(L_PERIOD,'RRRRMM')
                AND LIS_PAY_MOV_FLAG IN ('O','I'))
            as pre_lic_pay_movement,
            (SELECT SUM(lis_loc_pay) from fid_license_sub_ledger
              WHERE lis_lic_number = lic_number
                AND lis_lsl_number = lsl_number
                AND TO_CHAR(LIS_PER_YEAR|| LPAD(LIS_PER_MONTH,2,0)) = TO_CHAR(L_PERIOD,'RRRRMM')
                AND LIS_PAY_MOV_FLAG IN ('O','I'))
            as pre_loc_pay_movement,
            --------Pre-Payment-----------------------------------
            SUM(PRE_PAY)            				as PRE_LIC_PAY,
            SUM(PRE_PAY * PAY_RATE) 				as PRE_LOC_PAY,

            --------Adjustment (Pre-Payment)-----------------------
            SUM(PRE_PAY_ADJ) 								as PRE_LIC_PAY_ADJ,
            SUM(PRE_PAY_ADJ * pay_rate) 		as PRE_LOC_PAY_ADJ,


            SUM(pr_lic_adj_transfer)			  as pr_lic_adj_transfer,

            SUM(pr_loc_adj_transfer)				as pr_loc_adj_transfer,

            -------Realised G/L ZAR--------------------------------
            SUM(RGL)											 AS RGL,
            SUM(PAY_AMOUNT) AS PAY_AMOUNT
    FROM(
    SELECT  LIC_NUMBER,
            LSL_NUMBER,
            LIC_TYPE,
            LIC_CURRENCY,
            LIC_ACCT_DATE,
            --New Column Added
            vwl.COM_NUMBER,
						vwl.COM_CURRENCY,
						vwl.LIC_LEE_NUMBER,
						vwl.LIC_BUDGET_CODE,

            CASE WHEN ( vwl.lic_acct_date > LAST_DAY (l_period)
                        OR vwl.lic_start > LAST_DAY (l_period)
                        OR vwl.lic_acct_date IS NULL
                        OR vwl.lic_status = 'C'
                      )AND  NVL (FP.PAY_DATE,FP.PAY_STATUS_DATE) <= LAST_DAY (l_period)
  
            THEN (FP.PAY_AMOUNT)
            ELSE 0
            END
            as CLOSING_BAL,
						
           NVL (
                  CASE
                    WHEN UPPER (pay_code) = 'A'
                    AND NVL (FP.PAY_DATE,FP.PAY_STATUS_DATE)  BETWEEN l_period AND LAST_DAY (l_period)
                    THEN pay_amount
                  END, 0
               ) 
            as PRE_PAY_ADJ ,

            (CASE WHEN ( NVL (FP.PAY_DATE,FP.PAY_STATUS_DATE)  BETWEEN l_period AND LAST_DAY (l_period)
                         AND vwl.lic_acct_date > NVL (FP.PAY_DATE,FP.PAY_STATUS_DATE)
                         AND UPPER (pay_code)= 'T'
                       )
                then (FP.PAY_AMOUNT)
            ELSE 0
            END
            ) 
            as pr_lic_adj_transfer,

            (
              CASE WHEN ( NVL (FP.PAY_DATE,FP.PAY_STATUS_DATE)  BETWEEN l_period AND LAST_DAY (l_period)
                           AND vwl.lic_acct_date > NVL (FP.PAY_DATE,FP.PAY_STATUS_DATE)
                           AND UPPER (pay_code)= 'T'
                          )
                  then (FP.PAY_AMOUNT * fp.pay_rate)
              ELSE
                  0
              END
            )
            as pr_loc_adj_transfer,

           NVL (
                CASE
                  WHEN UPPER (pay_code) NOT IN ('A', 'T')
                   AND NVL (FP.PAY_DATE,FP.PAY_STATUS_DATE)  BETWEEN l_period AND LAST_DAY (l_period)
                  THEN pay_amount
                END , 0 )
           PRE_PAY,

             PAY_RATE,

             CASE WHEN NVL (FP.PAY_DATE,FP.PAY_STATUS_DATE) between l_period and last_day(l_period)
             THEN
                 ROUND(x_fnc_get_prepay_rgl(
                                      i_period 		  => l_period,
                                      i_lsl_number  => vwl.lsl_number,
                                      i_pay_number	=> fp.PAY_NUMBER
                                      )
                      ,4
                      )

             ELSE
             0
             END AS RGL,

             FP.PAY_AMOUNT

            FROM fid_payment fp,
                 x_vw_lic_details vwl
           WHERE vwl.lic_number = fp.pay_lic_number
             and fp.PAY_LSL_NUMBER = vwl.lsl_number
             AND ( ( vwl.lic_acct_date > LAST_DAY (l_prev_period)
                      OR vwl.lic_start > LAST_DAY (l_prev_period)
                      OR vwl.lic_acct_date IS NULL
                      OR vwl.lic_status = 'C'
                   )
                 )
             AND vwl.lic_status NOT IN ('B', 'F', 'T')
             AND FP.PAY_STATUS = 'P'
            )
  group by  LIC_NUMBER,
            LSL_NUMBER ,
            LIC_TYPE,
            LIC_CURRENCY,
            LIC_ACCT_DATE,
            --New Column Added
            COM_NUMBER,
            COM_CURRENCY,
            LIC_LEE_NUMBER,
            LIC_BUDGET_CODE
  )
        LOOP

            BEGIN
            SELECT PR_LIC_CLOSING_BAL ,PR_LOC_CLOSING_BAL
						   INTO l_LIC_OPENING_BAL ,
							      l_LOC_OPENING_BAL
							 FROM X_PRE_PAYMENT_RECON B 
							WHERE B.PR_LIC_NUMBER = i.LIC_NUMBER 
								AND B.PR_LSL_NUMBER = i.LSL_NUMBER
								AND B.PR_YYYYMM = TO_NUMBER(TO_CHAR(l_prev_period,'RRRRMM'));
						EXCEPTION 
						WHEN NO_DATA_FOUND THEN
						l_LIC_OPENING_BAL :=0 ;
						l_LOC_OPENING_BAL := 0;
						END;		

            INSERT INTO X_PRE_PAYMENT_RECON
                    (
                    PR_LIC_NUMBER,PR_LSL_NUMBER,PR_MONTH,PR_YEAR,PR_LIC_CUR,PR_LIC_TYPE,
                    PR_LIC_OPENING_BAL,
                    PR_LOC_OPENING_BAL,

                    PR_LIC_PREPAY_MOVEMENT,
                    PR_LOC_PREPAY_MOVEMENT,

                    PR_LIC_PRE_PAY,
                    PR_LOC_PRE_PAY,

                    PR_LIC_PRE_ADJ_PAY,
                    PR_LOC_PRE_ADJ_PAY,

                    pr_lic_adj_transfer,
                    pr_loc_adj_transfer,

                    PR_RGL,

                    PR_LIC_CLOSING_BAL,
                    PR_LOC_CLOSING_BAL,
                    --New Column Added
                    PR_LIC_CHA_COM_NUMBER,
                    PR_LOC_CUR, 			
                    PR_LIC_LEE_NUMBER,	
                    PR_LIC_BUD_CODE 
                    
                    )
                VALUES
                    (
                    i.LIC_NUMBER,i.LSL_NUMBER,to_number(to_char(l_period,'MM')),to_number(to_char(l_period,'RRRR')),i.LIC_CURRENCY,i.LIC_TYPE,
                    
										l_LIC_OPENING_BAL,        --PR_LIC_OPENING_BAL
                    l_LOC_OPENING_BAL,				--PR_LOC_OPENING_BAL

                    i.pre_lic_pay_movement,		--PR_LIC_PREPAY_MOVEMENT
                    i.pre_loc_pay_movement,		--PR_LOC_PREPAY_MOVEMENT

                    i.PRE_LIC_PAY,						--PR_LIC_PRE_PAY
                    i.PRE_LOC_PAY,						--PR_LOC_PRE_PAY

                    i.PRE_LIC_PAY_ADJ,				--PR_LIC_PRE_ADJ_PAY
                    i.PRE_LOC_PAY_ADJ,				--PR_LOC_PRE_ADJ_PAY

                    i.pr_lic_adj_transfer,		--Lic adjustment to prepaids (i.e pay_code = 'T')
                    i.pr_loc_adj_transfer,    --Loc adjustment to prepaids (i.e pay_code = 'T')

                    i.RGL,										--PR_RGL

                    i.CLOSING_BAL,						--PR_LIC_CLOSING_BAL
                    i.LOC_CLOSING_BAL,					--PR_LOC_CLOSING_BAL
                    --New Column Added
                    i.COM_NUMBER,
                    i.COM_CURRENCY,
                    i.LIC_LEE_NUMBER,
                    i.LIC_BUDGET_CODE 
                    );

      END LOOP;

					 INSERT INTO X_PRE_PAYMENT_RECON( PR_LIC_NUMBER,
										PR_LSL_NUMBER,
										PR_MONTH,
										PR_YEAR,
										PR_LIC_CUR,
										PR_LIC_TYPE,
                    PR_LIC_OPENING_BAL,
                    PR_LOC_OPENING_BAL,
                    --New Column Added
                    PR_LIC_CHA_COM_NUMBER,
                    PR_LOC_CUR,			
                    PR_LIC_LEE_NUMBER,
                    PR_LIC_BUD_CODE
										)
             SELECT PR_LIC_NUMBER,
										PR_LSL_NUMBER,
										to_number(to_char(l_period,'MM')),
										to_number(to_char(l_period,'RRRR')),
										PR_LIC_CUR,
										PR_LIC_TYPE,
                    PR_LIC_CLOSING_BAL,
                    PR_LOC_CLOSING_BAL,
                    --New Column Added
                    PR_LIC_CHA_COM_NUMBER,
                    PR_LOC_CUR,			
                    PR_LIC_LEE_NUMBER,
                    PR_LIC_BUD_CODE
						  FROM  X_PRE_PAYMENT_RECON A
						WHERE PR_YYYYMM = TO_NUMBER(TO_CHAR(l_prev_period,'RRRRMM'))
              AND NOT EXISTS ( SELECT 1
							                    FROM X_PRE_PAYMENT_RECON B
																WHERE b.PR_YYYYMM = TO_NUMBER(TO_CHAR(l_period,'RRRRMM'))
																  AND b.PR_LIC_NUMBER = a.PR_LIC_NUMBER 
										              AND b.PR_LSL_NUMBER = a.PR_LSL_NUMBER
															);
			
			COMMIT;

  END X_PRC_PRE_PAYMENT_RECON; 

  PROCEDURE x_prc_liability_recon(
			I_RECON_MONTH              IN              DATE
	)
  AS
--****************************************************************
-- This procedure is called for doing Liability Reconciliation
-- REM Client - MNET
--****************************************************************
    l_period 			date 	:= i_recon_month;
    l_prev_period date 	:= add_months(l_period,-1);

				 CURSOR liab_cur IS
				 SELECT a.LIC_NUMBER,
								a.LSL_NUMBER,
								a.LIC_TYPE,
								A.LIC_CURRENCY,
								a.COM_NUMBER,
								a.COM_CURRENCY,
								a.LIC_LEE_NUMBER,
								LIC_BUDGET_CODE,
								NVL(a.LR_LIC_OB_LIAB,0) LR_LIC_OB_LIAB,
								NVL(a.LR_LOC_OB_LIAB,0) LR_LOC_OB_LIAB,

								NVL(a.LR_LIC_CB_LIAB,0) LR_LIC_CB_LIAB,
								NVL(a.LR_LOC_CB_LIAB,0) LR_LOC_CB_LIAB,

								NVL(b.add_reval_mu,0)     add_reval_mu,
								NVL(b.add_reval_mu_loc,0) add_reval_mu_loc,
								NVL(b.can_revel,0)        can_revel,
								NVL(b.can_revel_loc,0)    can_revel_loc,
								CASE WHEN a.LIC_TYPE = 'FLF'
								THEN
										 NVL(b.FLAT_FEE_reval,0)
								ELSE
										 NVL(b.ROY_FEE_revel,0)
								END  lic_price_change,

								CASE WHEN a.LIC_TYPE = 'ROY'
								THEN
										NVL(b.ROY_FEE_revel_loc,0)
								ELSE
										NVL(b.FLAT_FEE_reval_loc,0)
								END loc_price_change,

								NVL(b.Rev_reval_mu,0)  Rev_reval_mu,
								NVL(b.Rev_reval_mu_loc,0) Rev_reval_mu_loc,

								NVL(b.fees_paid,0)		fees_paid,
								NVL(b.local_fees_paid,0) local_fees_paid,

								NVL(b.payment_liab_adj,0) payment_liab_adj,
								NVL(b.local_payment_liab_adj,0) local_payment_liab_adj,

								NVL(b.payment_liab_tran,0) payment_liab_tran,
								NVL(b.local_payment_liab_tran,0) local_payment_liab_tran,

								NVL(b.RGL,0) RGL,

                NVL(b.PR_LIC_PREPAY_MOVEMENT,0) as lic_pre_pay_movement,
								NVL(b.PR_LoC_PREPAY_MOVEMENT,0) as loc_pre_pay_movement
					FROM (
							SELECT 
											LIC_NUMBER,
											LSL_NUMBER,
											LIC_TYPE,
											LIC_CURRENCY,
											COM_NUMBER,
											COM_CURRENCY,
											LIC_LEE_NUMBER,
											LIC_BUDGET_CODE,
											SUM(LR_LIC_OB_LIAB) as LR_LIC_OB_LIAB,
											SUM(LR_LOC_OB_LIAB) as LR_LOC_OB_LIAB,
											SUM(LR_LIC_CB_LIAB) as LR_LIC_CB_LIAB,
											SUM(LR_LOC_CB_LIAB) as LR_LOC_CB_LIAB
							FROM
							    (
													SELECT  LIC_NUMBER,
																	LSL_NUMBER,
																	LIC_TYPE,
																	LIC_CURRENCY,
																	FL.COM_NUMBER,
																	FL.COM_CURRENCY,
																	FL.LIC_LEE_NUMBER,
																	FL.LIC_BUDGET_CODE,
																	0 LR_LIC_OB_LIAB,
																	0 as LR_LOC_OB_LIAB,
																	(lis_con_forecast_c - lis_lic_paid_amount_C) LR_LIC_CB_LIAB,
																	X_PKG_LINEAR_RECON_CALC.X_FNC_CAL_LOCAL_LIAB (
																							i_lic_currency          => LIC_CURRENCY,
																							i_lic_number            => LIC_NUMBER,
																							i_lsl_number            => LSL_NUMBER,
																							i_period                => l_period,
																							i_v_go_live_date        => '01-jun-2013',--v_go_live_date'',
																							i_rat_rate              => fer.rat_rate,
																							i_lic_acct_date		  		=> LIC_ACCT_DATE,
																							i_lic_start			  			=> LIC_START,
																							i_lic_cancel_date		  	=> LIC_CANCEL_DATE,
																							i_lic_start_rate		  	=> LIC_RATE,
																							i_lic_status			  		=> LIC_STATUS,
																							i_calc_paid_liability   => (lis_con_forecast_c - lis_lic_paid_amount_C)	
																	)as LR_LOC_CB_LIAB
						
														FROM X_GTT_CONTENT_LIAB LBL,
																	X_VW_LIC_DETAILS FL,
																	fid_exchange_rate fer
														WHERE FL.LIC_NUMBER	= LBL.LIS_LIC_NUMBER
															AND LBL.LIS_LSL_NUMBER = FL.LSL_NUMBER
															AND fer.rat_cur_code = fl.lic_currency
															AND fer.rat_cur_code_2(+) = fl.COM_CURRENCY
															AND fl.lic_status NOT IN ('B', 'F', 'T')
															AND ROUND(NVL((lis_con_forecast_c - lis_lic_paid_amount_c ),0),2) NOT BETWEEN  -1 AND 1
															AND fl.lic_acct_date <= LAST_DAY (l_period)
															/* GET OPENING BALANCE FROM PREVIOUS MONTH */
															UNION ALL
															SELECT 
																		LR_LIC_NUMBER,
																		LR_LSL_NUMBER,
																		LR_LIC_TYPE,
																		LR_LIC_CUR,
																		LR_LIC_CHA_COM_NUMBER,
																		LR_LOC_CUR,
																		LR_LIC_LEE_NUMBER,
																		LR_LIC_BUD_CODE,
																		LR_LIC_CB_LIAB as LR_LIC_OB_LIAB,
																		LR_LOC_CB_LIAB as LR_LOC_OB_LIAB,
																		0 						 as LR_LIC_CB_LIAB,
																		0 						 as LR_LOC_CB_LIAB
														 FROM X_LIABILITY_RECON
														WHERE LR_YYYYMM = TO_NUMBER(TO_CHAR(l_prev_period,'RRRRMM'))
														  AND (ROUND(NVL(LR_LIC_CB_LIAB,0),2) <> 0)
								)
								 GROUP BY LIC_NUMBER,
													LSL_NUMBER,
													LIC_TYPE,
													LIC_CURRENCY,
													COM_NUMBER,
													COM_CURRENCY,
													LIC_LEE_NUMBER,
													LIC_BUDGET_CODE
								)A,
                (SELECT
                          rev.LIC_NUMBER,
                          rev.LSL_NUMBER,
                          ADD_REVAL_MU,
                          ADD_REVAL_MU_LOC,
                          CAN_REVEL,
                          CAN_REVEL_LOC,
                          FLAT_FEE_REVAL,
                          FLAT_FEE_REVAL_LOC,
                          ROY_FEE_REVEL,
                          ROY_FEE_REVEL_LOC,
                          REV_REVAL_MU,
                          REV_REVAL_MU_LOC,
                          PR_LIC_PREPAY_MOVEMENT,
                          PR_LOC_PREPAY_MOVEMENT,
                          FEES_PAID,
                          LOCAL_FEES_PAID,
                          PAYMENT_LIAB_ADJ,
                          LOCAL_PAYMENT_LIAB_ADJ,
                          PAYMENT_LIAB_TRAN,
                          LOCAL_PAYMENT_LIAB_TRAN,
                          RGL
                     FROM x_vw_lib_reval2 rev ,
                          x_vw_lic_details fl											/*This join is used to filter tha data for channel company CC and BC */ 
                   where  fl.lic_number	= rev.lic_number
                     AND  fl.lsl_number = rev.lsl_number
                     AND NOT EXISTS (
                                      SELECT lsh_lic_number
                                      FROM(
                                            SELECT lsh_lic_number,
                                                   lsh_lic_status,
                                                   DENSE_RANK() OVER(PARTITION BY LSH_LIC_NUMBER,LSH_STATUS_YYYYMM ORDER BY LSH_STATUS_YYYYMM DESC) RN
                                             FROM X_LIC_STATUS_HISTORY
                                             WHERE LSH_STATUS_YYYYMM <= TO_NUMBER(TO_CHAR(l_period,'RRRRMM'))
                                          )WHERE RN = 1
                                      AND lsh_lic_status = 'C'
                                      AND lsh_lic_number = fl.lic_number
                                      UNION ALL
                                      select mv1.lis_lic_number
                                      from x_mv_subledger_data mv1
                                      where (lis_lic_status = 'C'
                                             /*or lis_lic_start > LAST_DAY(l_period)*/)
                                      and fl.lic_number = mv1.lis_lic_number
                                      AND lis_yyyymm_num = TO_NUMBER(TO_CHAR(l_period,'RRRRMM'))
                                   )
									)B
					WHERE a.LIC_NUMBER = b.LIC_NUMBER(+)
					  and a.lsl_number = b.LSL_NUMBER(+);

			liab_cur_type           liab_cur%rowtype;
			TYPE liab_rec_cur IS TABLE OF liab_cur_type%TYPE INDEX BY pls_integer;
			v_liab_cur		liab_rec_cur;
			
			l_opening_bal       number;
			l_closing_bal       number;
			l_pre_pay           number;
			l_pre_pay_adj       number;
			l_pre_pay_movement  number;
BEGIN
    PKG_FIN_MNET_PAY_SUM_REPORTS.set_parameter (
														  p_from_date   => l_period,
														  p_to_date     => LAST_DAY(l_period),
														  p_live_date   => NULL								 /*Not required so set to null.*/
													 );

    X_PKG_LINEAR_RECON.x_prc_set_period(l_period);

		delete x_liability_recon where lr_yyyymm = TO_NUMBER(TO_CHAR(l_period,'RRRRMM'));
    delete from x_fin_subledger_arch;
    
    INSERT INTO x_fin_subledger_arch
    SELECT   
       lis_lic_number,
       lis_lsl_number,
       SUM(LIS_CON_FC_IMU),
       SUM(lis_loc_forecast)
    FROM x_mv_subledger_data mv1,
         x_vw_lic_details
    WHERE lis_yyyymm_num <= TO_NUMBER(TO_CHAR(l_period,'RRRRMM'))
    AND NOT EXISTS (
                      SELECT lsh_lic_number
                      FROM(
                            SELECT lsh_lic_number,
                                   lsh_lic_status,
                                   DENSE_RANK() OVER(PARTITION BY LSH_LIC_NUMBER,LSH_STATUS_YYYYMM ORDER BY LSH_STATUS_YYYYMM DESC) RN
                             FROM X_LIC_STATUS_HISTORY
                             WHERE LSH_STATUS_YYYYMM <= TO_NUMBER(TO_CHAR(l_period,'RRRRMM'))
                          )WHERE RN = 1
                      AND lsh_lic_status = 'C'
                      AND lsh_lic_number = lis_lic_number
                      UNION ALL
                      select mv2.lis_lic_number
                      from x_mv_subledger_data mv2
                      where (lis_lic_status = 'C'
                             or lis_lic_start > LAST_DAY(l_period))
                      and mv1.lis_lic_number = mv2.lis_lic_number
                      AND lis_yyyymm_num = TO_NUMBER(TO_CHAR(l_period,'RRRRMM'))
                   )
    and lic_number = lis_lic_number
    and lsl_number = lis_lsl_number
    GROUP BY lis_lic_number,
          lis_lsl_number;

    COMMIT;

      INSERT INTO X_GTT_CONTENT_LIAB
						(
						lis_lic_number,
						lis_lsl_number,
						lis_con_forecast_c,
						lis_loc_forecast_c,
						lis_lic_paid_amount_c,
						lis_loc_paid_amount_c
						)
				SELECT
							lis_lic_number,
							lis_lsl_number,
							ROUND((lis_con_forecast),2),
							ROUND((liab_pv_adj),2),
							(SELECT NVL(sum(fp.pay_amount),0)
									 FROM fid_payment fp,fid_payment_type fpt
									WHERE fpt.pat_code =fp.pay_code
										AND fp.pay_lic_number = mv.lis_lic_number
										AND fp.pay_lsl_number = mv.lis_lsl_number
										AND TO_DATE(TO_CHAR(fp.pay_date,'DD-MON-RRRR'),'DD-MON-RRRR') <=last_day(l_period)
										AND fp.pay_status IN ('P', 'I')
										AND fpt.pat_group = 'F'
							) AS lis_lic_paid_amount_C,

							  (  SELECT NVL(sum(fp.pay_amount*pay_rate),0)
								   FROM fid_payment fp,fid_payment_type fpt
								  WHERE fpt.pat_code = fp.pay_code
								    AND fp.pay_lic_number = mv.lis_lic_number
									AND fp.pay_lsl_number = mv.lis_lsl_number
									AND TO_DATE(TO_CHAR(fp.pay_date,'DD-MON-RRRR'),'DD-MON-RRRR') <= last_day(l_period)
									AND fp.pay_status IN ('P', 'I')
									AND fpt.pat_group = 'F'
							  ) AS lis_loc_paid_amount_C
				FROM  x_fin_subledger_arch mv;
			COMMIT;
 
			DELETE FROM X_GTT_CONTENT_LIAB
			 WHERE NVL(LIS_CON_FORECAST_C,0) = 0
			   AND NVL(LIS_LOC_FORECAST_C,0) = 0
			   AND NVL(LIS_LIC_PAID_AMOUNT_C,0) = 0
			   AND NVL(LIS_LOC_PAID_AMOUNT_C,0) = 0;
	
	
	OPEN liab_cur;
			LOOP
			   FETCH liab_cur BULK COLLECT INTO v_liab_cur LIMIT 10000;
			    EXIT WHEN v_liab_cur.COUNT = 0;

          FORALL i IN 1..v_liab_cur.COUNT
						INSERT INTO X_LIABILITY_RECON
							(
								LR_LIC_NUMBER,
								LR_LSL_NUMBER,
								LR_MONTH,
								LR_YEAR,
								LR_LIC_CUR,
								LR_LIC_TYPE,
								LR_LIC_CHA_COM_NUMBER,	
								LR_LOC_CUR,
								LR_LIC_LEE_NUMBER,
								LR_LIC_BUD_CODE,
								
								LR_LIC_OB_LIAB,
								LR_LOC_OB_LIAB,

								LR_LIC_CB_LIAB,
								LR_LOC_CB_LIAB,

								LR_LIC_ADDITIONS,
								LR_LOC_ADDITIONS,

								LR_LIC_CANCELATION,
								LR_LOC_CANCELATION,

								LR_LIC_FLF_CHANGE_REVAL,
								LR_LOC_FLF_CHANGE_REVAL,

								LR_LIC_REVERSAL,
								LR_LOC_REVERSAL,
								---Payments Columns---
								LR_LIC_PAYMENTS,
								LR_LOC_PAYMENTS,

								LR_LIC_TRANSFER_PAY,
								LR_LOC_TRANSFER_PAY,

								LR_LIC_ADJ_PAY,
								LR_LOC_ADJ_PAY,

								LR_LIC_MOVEMENT,
								LR_LOC_MOVEMENT,

							  LR_LIC_RGL
							)
							VALUES
							(
							v_liab_cur(i).LIC_NUMBER,
							v_liab_cur(i).LSL_NUMBER,
							TO_CHAR(l_period,'MM'),
							TO_CHAR(l_period,'RRRR'),
							V_LIAB_CUR(I).LIC_CURRENCY,
							v_liab_cur(i).LIC_TYPE,
							v_liab_cur(i).COM_NUMBER,
							v_liab_cur(i).COM_CURRENCY,
							v_liab_cur(i).LIC_LEE_NUMBER,
							v_liab_cur(i).LIC_BUDGET_CODE,
							
							v_liab_cur(i).LR_LIC_OB_LIAB,
							v_liab_cur(i).LR_LOC_OB_LIAB,
							v_liab_cur(i).LR_LIC_CB_LIAB,
							v_liab_cur(i).LR_LOC_CB_LIAB,
							v_liab_cur(i).add_reval_mu,
							v_liab_cur(i).add_reval_mu_loc,
							v_liab_cur(i).can_revel,
							v_liab_cur(i).can_revel_loc,
							v_liab_cur(i).lic_price_change,
							v_liab_cur(i).loc_price_change,
							v_liab_cur(i).Rev_reval_mu,
							v_liab_cur(i).Rev_reval_mu_loc,
							---Payments Columns-------
							v_liab_cur(i).fees_paid,														--LR_LIC_PAYMENTS,
							v_liab_cur(i).local_fees_paid,											--LR_LOC_PAYMENTS,
							v_liab_cur(i).payment_liab_tran,										--LR_LIC_TRANSFER_PAY,
							v_liab_cur(i).local_payment_liab_tran,							--LR_LOC_TRANSFER_PAY,
							v_liab_cur(i).payment_liab_adj,											--LR_LIC_ADJ_PAY,
							v_liab_cur(i).local_payment_liab_adj,								--LR_LOC_ADJ_PAY,
							v_liab_cur(i).lic_pre_pay_movement,									--LR_LIC_RGL,
							v_liab_cur(i).loc_pre_pay_movement,									--LR_LIC_MOVEMENT
							v_liab_cur(i).RGL																	  --Liability RGL
							);

		COMMIT;

		END LOOP;

    --fOR NOT MATCHED LICENSES
   --insert data for not matched licenses

		INSERT INTO X_LIABILITY_RECON
							(
								LR_LIC_NUMBER,
								LR_LSL_NUMBER,
								LR_MONTH,
								LR_YEAR,
								LR_LIC_CUR,
								LR_LIC_TYPE,
								LR_LIC_CHA_COM_NUMBER,	
								LR_LOC_CUR,
								LR_LIC_LEE_NUMBER,
								LR_LIC_BUD_CODE,
								
								LR_LIC_OB_LIAB,
								LR_LOC_OB_LIAB,
								LR_LIC_CB_LIAB,
								LR_LOC_CB_LIAB,
								LR_LIC_ADDITIONS,
								LR_LOC_ADDITIONS,
								LR_LIC_CANCELATION,
								LR_LOC_CANCELATION,
								LR_LIC_FLF_CHANGE_REVAL,
								LR_LOC_FLF_CHANGE_REVAL,
								LR_LIC_REVERSAL,
								LR_LOC_REVERSAL,
								---Payments Columns---
								LR_LIC_PAYMENTS,
								LR_LOC_PAYMENTS,
								LR_LIC_TRANSFER_PAY,
								LR_LOC_TRANSFER_PAY,
								LR_LIC_ADJ_PAY,
								LR_LOC_ADJ_PAY,
								LR_LIC_MOVEMENT,
								LR_LOC_MOVEMENT,
							  LR_LIC_RGL
							)
		 select
		        fl.LIC_NUMBER,
						fl.lsl_number,
						TO_CHAR(l_period,'MM'),
						TO_CHAR(l_period,'RRRR'),
						FL.LIC_CURRENCY,
						FL.LIC_TYPE,
						FL.COM_NUMBER,
						FL.COM_CURRENCY,
						FL.LIC_LEE_NUMBER,
						FL.LIC_BUDGET_CODE,
						
						0,     									--lic opening bal liability
						0,											--loc opening bal liability
						0,											--lic closing bal liability
						0,											--loc closing bal liability
						NVL(ADD_REVAL_MU,0),
						NVL(ADD_REVAL_MU_LOC,0),
						NVL(CAN_REVEL,0),
						NVL(CAN_REVEL_LOC,0),

						CASE WHEN fl.lic_type ='FLF'
						THEN
						    NVL(FLAT_FEE_REVAL,0)
						ELSE
						    NVL(ROY_FEE_REVEL,0)
						END,

						CASE WHEN fl.lic_type ='FLF'
						THEN
						    NVL(FLAT_FEE_REVAL_LOC,0)
						ELSE
						    NVL(ROY_FEE_REVEL_LOC,0)
						END,

						NVL(REV_REVAL_MU,0),
						NVL(REV_REVAL_MU_LOC,0),

						FEES_PAID,
						LOCAL_FEES_PAID,

						PAYMENT_LIAB_TRAN,
						LOCAL_PAYMENT_LIAB_TRAN,

						PAYMENT_LIAB_ADJ,
						LOCAL_PAYMENT_LIAB_ADJ,

						NVL(PR_LIC_PREPAY_MOVEMENT,0),
						NVL(PR_LOC_PREPAY_MOVEMENT,0),

						RGL

         FROM x_vw_lib_reval2 rev ,
              x_vw_lic_details FL
        where  fl.lic_number	= rev.lic_number
          AND  fl.lsl_number  = rev.lsl_number
        AND NOT EXISTS(SELECT lsh_lic_number
                      FROM(
                            SELECT lsh_lic_number,
                                   lsh_lic_status,
                                   DENSE_RANK() OVER(PARTITION BY LSH_LIC_NUMBER,LSH_STATUS_YYYYMM ORDER BY LSH_STATUS_YYYYMM DESC) RN
                             FROM X_LIC_STATUS_HISTORY
                             WHERE LSH_STATUS_YYYYMM <= TO_NUMBER(TO_CHAR(l_period,'RRRRMM'))
                          )WHERE RN = 1
                      AND lsh_lic_status = 'C'
                      AND lsh_lic_number = rev.lic_number
                      UNION ALL
                      select mv2.lis_lic_number
                      from x_mv_subledger_data mv2
                      where (lis_lic_status = 'C'
                             or lis_lic_start > LAST_DAY(l_period))
                      and mv2.lis_lic_number = rev.lic_number
                      AND lis_yyyymm_num = TO_NUMBER(TO_CHAR(l_period,'RRRRMM')))
        AND NOT EXISTS (
                        SELECT 1
                          FROM X_LIABILITY_RECON lr
                         WHERE lr.LR_LIC_NUMBER =  rev.LIC_NUMBER
                           AND lr.LR_LSL_NUMBER =  rev.LSL_NUMBER
                           AND lr.lr_yyyymm  = TO_NUMBER (TO_CHAR (l_period, 'YYYYMM'))
                       );

          
          FOR I IN ( SELECT * 
                   FROM FID_LICENSE_SUB_LEDGER 
                  WHERE lis_lic_status = 'C'
                   AND TO_CHAR(LIS_PER_YEAR|| LPAD(LIS_PER_MONTH,2,0)) = TO_CHAR(L_PERIOD,'RRRRMM')
                   AND LIS_PAY_MOV_FLAG IN ('O','I')
              )LOOP
          
              UPDATE X_LIABILITY_RECON 
                                      set 	LR_LIC_MOVEMENT = i.LIS_CON_PAY,
                                            LR_LOC_MOVEMENT = i.LIS_LOC_PAY
                                    WHERE 	LR_LIC_NUMBER = i.lis_lic_number
                                      AND 	LR_LSL_NUMBER = i.lis_lsl_number
                                      AND   lr_yyyymm = TO_NUMBER(TO_CHAR(L_PERIOD,'RRRRMM'));
              
          END LOOP;
    
    		delete  X_GTT_CONTENT_LIAB;

    COMMIT;
    

end x_prc_liability_recon;

  FUNCTION PAID_AMOUNT_LOCAL_RECON (
      I_LIC_NUMBER               IN              FID_LICENSE.LIC_NUMBER%TYPE,
      I_LIC_CURRENCY             IN              FID_LICENSE.LIC_CURRENCY%TYPE,
      I_PERIOD                   IN              DATE,
      I_LSL_NUMBER               IN              X_FIN_LIC_SEC_LEE.LSL_NUMBER%TYPE
   )
   RETURN NUMBER
   AS
--****************************************************************
-- This function returns the value of paid amount in local currency.
-- REM Client - MNET
--****************************************************************
      licpay_con_paid_is   NUMBER;
      l_count              NUMBER;
      l_refund_amt         NUMBER;
   BEGIN
      licpay_con_paid_is := 0;

      SELECT COUNT (*)
        INTO l_count
        FROM x_fin_refund_settle xfrs
       WHERE xfrs.frs_lic_number = i_lic_number;

      IF l_count > 0
      THEN
         FOR i IN (SELECT fp.pay_number, fp.pay_amount, fp.pay_rate
                     FROM fid_payment fp,
                          fid_payment_type fpt,
                          x_fin_lic_sec_lee xfsl
                    WHERE fp.pay_lsl_number = xfsl.lsl_number
                      AND fp.pay_lsl_number = i_lsl_number
                      AND fp.pay_lic_number = i_lic_number
                      AND fp.pay_status IN ('P', 'I')
                      AND fpt.pat_code = fp.pay_code
                      AND TO_DATE (TO_CHAR (fp.pay_date, 'DD-MON-RRRR'),
                                   'DD-MON-RRRR'
                                  ) < i_period)
         LOOP
            IF (i.pay_amount < 0)
            THEN
               SELECT NVL (SUM (xfrs.frs_rfd_amount), 0)
                 INTO l_refund_amt
                 FROM x_fin_refund_settle xfrs
                WHERE xfrs.frs_rfd_pay_number = i.pay_number;

               licpay_con_paid_is :=
                    licpay_con_paid_is
                  + (i.pay_amount + l_refund_amt) * i.pay_rate;
            END IF;

            IF (i.pay_amount > 0)
            THEN
               SELECT NVL (SUM (xfrs.frs_rfd_amount), 0)
                 INTO l_refund_amt
                 FROM x_fin_refund_settle xfrs, fid_payment fp
                WHERE xfrs.frs_pay_number = i.pay_number
                  AND xfrs.frs_rfd_pay_number = fp.pay_number
                  AND xfrs.frs_lic_number = i_lic_number
                  AND TO_DATE (TO_CHAR (fp.pay_date, 'DD-MON-RRRR'),
                               'DD-MON-RRRR'
                              ) < i_period;

               licpay_con_paid_is :=
                    licpay_con_paid_is
                  + (i.pay_amount - l_refund_amt) * i.pay_rate;
            END IF;
         END LOOP;
      ELSE
         SELECT SUM (fp.pay_amount * fp.pay_rate)
           INTO licpay_con_paid_is
           FROM fid_payment fp, fid_payment_type fpt, x_fin_lic_sec_lee xfsl
          WHERE fp.pay_lsl_number = xfsl.lsl_number
            AND fp.pay_lic_number = i_lic_number
            AND fp.pay_lsl_number = i_lsl_number
            AND fp.pay_status IN ('P', 'I')
            AND fpt.pat_code = fp.pay_code
            AND TO_DATE (TO_CHAR (fp.pay_date, 'DD-MON-RRRR'), 'DD-MON-RRRR') < i_period
            AND fpt.pat_group = 'F';
      END IF;

      RETURN licpay_con_paid_is;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         licpay_con_paid_is := 0;

         IF licpay_con_paid_is IS NULL
         THEN
            licpay_con_paid_is := 0;
         END IF;

         RETURN LICPAY_CON_PAID_IS;
   END paid_amount_local_recon;

  FUNCTION X_FNC_GET_COMMITPAY_RGL
  (
      I_LIC_NUMBER               IN              NUMBER,
      I_LSL_NUMBER               IN              NUMBER,
      I_PERIOD                   IN              DATE
  )
  RETURN NUMBER
  AS
--****************************************************************
-- This function returns the value of RGL for Commitments Paid.
-- REM Client - MNET
--****************************************************************
    L_PERIOD    VARCHAR2(6) := TO_CHAR(I_PERIOD, 'RRRRMM');
    L_RGL       NUMBER;
  BEGIN
          SELECT NVL (SUM (RZF_REALIZED_FOREX), 0)
            INTO L_RGL
          FROM x_fin_realized_forex xfrf, fid_license fl, fid_payment fp
         WHERE fl.lic_number(+) = NVL (xfrf.rzf_lic_number, 0)
           AND FP.PAY_LIC_NUMBER = FL.LIC_NUMBER
           and fp.pay_lic_number = I_LIC_NUMBER
           AND xfrf.rzf_lsl_number = I_LSL_NUMBER
           AND xfrf.rzf_pay_number(+) = pay_number
           AND XFRF.RZF_ACCOUNT_HEAD <> UPPER ('ED')
           AND NVL (FP.PAY_DATE, FP.PAY_STATUS_DATE) < NVL (FL.LIC_ACCT_DATE, '31-Dec-2199')
           AND (CONCAT (XFRF.RZF_YEAR, LPAD (XFRF.RZF_MONTH, 2, 0))) <= L_PERIOD;

    RETURN L_RGL;
  END X_FNC_GET_COMMITPAY_RGL;

  FUNCTION X_FNC_GET_PREPAY_RGL
  (
      I_PERIOD 		               IN              DATE,
      I_LSL_NUMBER               IN              NUMBER,
      I_PAY_NUMBER               IN              NUMBER
  )
  RETURN NUMBER
  AS
--****************************************************************
-- This function returns the value of RGL for Prepayments.
-- REM Client - MNET
--****************************************************************
  l_rgl NUMBER;
  BEGIN
  SELECT SUM(NVL(rzf_realized_forex,0))
        INTO l_rgl
        FROM x_fin_realized_forex
        WHERE RZF_ACCOUNT_HEAD <> UPPER ('ED')
        AND RZF_YEAR = to_number(to_char(i_period,'RRRR'))
        AND RZF_MONTH = to_number(to_char(i_period,'MM'))
        and RZF_LSL_NUMBER = i_lsl_number
        AND rzf_pay_number = i_pay_number;

  RETURN L_RGL;
  END x_fnc_get_prepay_rgl;

  FUNCTION calc_local_liability1 (
      I_LIC_NUMBER               IN              FID_LICENSE.LIC_NUMBER%TYPE,
      I_LSL_NUMBER               IN              X_FIN_LIC_SEC_LEE.LSL_NUMBER%TYPE,
      I_LIAB_AMT                 IN              NUMBER,
      I_RATE                     IN              NUMBER,
      I_LIC_START                IN              FID_LICENSE.LIC_START%TYPE,
      I_PERIOD                   IN              DATE
   )
      RETURN NUMBER
   IS
      l_refund_amt          NUMBER;
      l_local_liability     NUMBER;
      l_prepayment_amt      NUMBER;
      l_lic_start_rate      NUMBER;
      l_total_payment       NUMBER;
      l_total_refund_amt    NUMBER;
      l_payment_amount      NUMBER;
      l_lic_cur_liability   NUMBER;
      l_prepayment_amount   NUMBER;
   BEGIN
      l_lic_start_rate := 0;
      l_total_payment := 0;
      l_total_refund_amt := 0;
      l_local_liability := 0;
      l_lic_cur_liability := i_liab_amt;

      SELECT NVL (lic_start_rate, 0)
        INTO l_lic_start_rate
        FROM fid_license
       WHERE lic_number = i_lic_number;

      SELECT NVL (SUM (pay_amount), 0)
        INTO l_total_payment
        FROM fid_payment
       WHERE pay_lic_number = i_lic_number
         AND TRUNC (pay_date) >= TRUNC(i_lic_start)
         AND pay_status = 'P'
         AND pay_amount > 0
         AND pay_lsl_number = i_lsl_number
         AND TO_NUMBER (TO_CHAR (pay_date, 'YYYYMM')) <= TO_NUMBER (TO_CHAR (i_period, 'YYYYMM'));

      SELECT NVL (SUM (frs_rfd_amount), 0)
        INTO l_total_refund_amt
        FROM x_fin_refund_settle, fid_payment
       WHERE frs_lic_number = i_lic_number
         AND frs_pay_number = pay_number
         AND pay_lsl_number = i_lsl_number
         AND TRUNC (pay_date) >= TRUNC(i_lic_start)
         AND frs_year || LPAD (frs_month, 2, 0) <= TO_CHAR (i_period, 'YYYYMM');

      IF (l_total_payment - l_total_refund_amt) > 0
      THEN
         ----Payment loop to settle refund and calculate local amount
         FOR c_license_payment IN (SELECT pay_number, pay_rate, pay_amount
                                     FROM fid_payment
                                    WHERE pay_lic_number = i_lic_number
                                      AND pay_amount > 0
                                      AND TRUNC (pay_date) >= TRUNC(i_lic_start)
                                      AND pay_status = 'P'
                                      AND pay_lsl_number = i_lsl_number
                                      AND TO_NUMBER (TO_CHAR (pay_date,'YYYYMM')) <= TO_NUMBER (TO_CHAR (i_period,'YYYYMM'))
								)
         LOOP
            l_refund_amt := 0;

            SELECT NVL (SUM (frs_rfd_amount), 0)
              INTO l_refund_amt
              FROM x_fin_refund_settle
             WHERE frs_pay_number = c_license_payment.pay_number
               AND frs_year || LPAD (frs_month, 2, 0) <= TO_CHAR (i_period, 'YYYYMM');

            l_payment_amount := c_license_payment.pay_amount - l_refund_amt;

            IF l_payment_amount < ABS (l_lic_cur_liability)
            THEN
               l_local_liability :=
                    l_local_liability
                    + (l_payment_amount * l_lic_start_rate);
               l_lic_cur_liability := l_lic_cur_liability + l_payment_amount;
            ELSE
               l_local_liability :=
                    l_local_liability
                  + (ABS (l_lic_cur_liability) * l_lic_start_rate);
               l_lic_cur_liability := 0;
               EXIT;
            END IF;
         END LOOP;
      END IF;

      IF l_lic_cur_liability < 0
      THEN
         ----Pre-payment loop to settle refund and calculate local amount
         FOR c_license_prepayment IN (SELECT   pay_number, pay_rate,
                                               pay_amount
                                          FROM fid_payment
                                         WHERE pay_lic_number = i_lic_number
                                           AND pay_amount > 0
                                           AND TRUNC (pay_date) < TRUNC(i_lic_start)
                                           AND pay_status = 'P'
                                           AND pay_lsl_number = i_lsl_number
                                           AND TO_NUMBER (TO_CHAR (pay_date,'YYYYMM')) <=TO_NUMBER(TO_CHAR (i_period,'YYYYMM'))
                                      ORDER BY pay_date)
         LOOP
            SELECT NVL (SUM (frs_rfd_amount), 0)
              INTO l_refund_amt
              FROM x_fin_refund_settle
             WHERE frs_pay_number = c_license_prepayment.pay_number
               AND frs_year || LPAD (frs_month, 2, 0) <= TO_CHAR (i_period, 'YYYYMM');

            l_prepayment_amount := c_license_prepayment.pay_amount - l_refund_amt;

            IF l_prepayment_amount < ABS (l_lic_cur_liability)
            THEN
               l_local_liability :=
                    l_local_liability
                  + (l_prepayment_amount * c_license_prepayment.pay_rate);
               l_lic_cur_liability :=
                                     l_lic_cur_liability + l_prepayment_amount;
            ELSE
               l_local_liability :=
                    l_local_liability
                  + (ABS (l_lic_cur_liability) * c_license_prepayment.pay_rate
                    );
               l_lic_cur_liability := 0;
               EXIT;
            END IF;
         END LOOP;
      END IF;

      RETURN ROUND (-l_local_liability, 2);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_local_liability := 0;
         RETURN ROUND (-l_local_liability, 2);
   END calc_local_liability1;
	 
  FUNCTION X_FNC_CAL_LOCAL_LIAB (
      I_LIC_CURRENCY              IN             FID_LICENSE.LIC_CURRENCY%TYPE,
      I_LIC_NUMBER                IN             FID_LICENSE.LIC_NUMBER%TYPE,
      I_LSL_NUMBER                IN             NUMBER,
      I_PERIOD                    IN             DATE,
      I_V_GO_LIVE_DATE            IN             DATE,
      I_RAT_RATE                  IN             NUMBER,
      I_LIC_ACCT_DATE		          IN             DATE,
      I_LIC_START			            IN             DATE,
      I_LIC_CANCEL_DATE		        IN             DATE,
      I_LIC_START_RATE		        IN             NUMBER,
      I_LIC_STATUS			          IN             VARCHAR2,
      I_CALC_PAID_LIABILITY       IN             NUMBER
		)
	RETURN NUMBER
AS
      l_local_amount      NUMBER;
BEGIN
      BEGIN
         SELECT (CASE
                    WHEN i_lic_currency <> 'ZAR'
										THEN (CASE 
										WHEN i_calc_paid_liability < 0 AND i_lic_start < i_v_go_live_date
										THEN NVL (i_rat_rate,0) * i_calc_paid_liability
							 
										WHEN i_lic_start < i_v_go_live_date
										THEN NVL (i_rat_rate,0) * i_calc_paid_liability
                    WHEN i_calc_paid_liability < 0 AND i_lic_acct_date >= i_v_go_live_date AND i_lic_status = 'C'
										 AND TO_CHAR (i_lic_start, 'YYYYMM') < TO_CHAR (LAST_DAY (i_period), 'YYYYMM')
										 AND TO_CHAR (i_lic_cancel_date, 'YYYYMM') <= TO_CHAR (LAST_DAY (i_period), 'YYYYMM')
										THEN 
												           pkg_fin_mnet_out_liab_rpt.calc_local_liability
                                                                (i_lic_number,
                                                                 i_period,
																																 i_lsl_number
                                                                )
                             WHEN i_calc_paid_liability < 0 AND i_lic_start >= i_v_go_live_date
                             THEN 
																	 X_PKG_LINEAR_RECON_CALC.calc_local_liability1
                                                       (i_lic_number,
                                                        i_lsl_number,
                                                        i_calc_paid_liability,
                                                        NVL (i_rat_rate, 0),
                                                        i_lic_start,
                                                        i_period
                                                       )
			
                              ELSE  PKG_FIN_MNET_OUT_LIAB_RPT.get_exchange_rate_lsd
                                                             (i_lic_currency,
                                                              i_lic_number,
                                                              i_lsl_number,
                                                              i_period,
                                                              i_lic_start_rate
                                                             ) 
																														 * 
																														 i_calc_paid_liability
                                                              
                             END
                     )
                    ELSE 
							i_calc_paid_liability
                 END
                )
    INTO l_local_amount
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_local_amount := 0;
      END;
			
      RETURN (ROUND (l_local_amount, 2));

   END X_FNC_CAL_LOCAL_LIAB;

  PROCEDURE X_PRC_INSERT_RECON_SUM_DATA(
	I_RECON_USER		              IN			VARCHAR2,
	I_RECON_PERIOD		            IN			NUMBER
)
AS
--****************************************************************
-- This procedure populates Recon summation data for given month-year.
-- REM Client - MNET
--****************************************************************
BEGIN

	--INVENTORY RECON SUMMATION

	DELETE FROM X_INVENTORY_RECON_SUM
	WHERE IR_YYYYMM = I_RECON_PERIOD;

	INSERT INTO X_INVENTORY_RECON_SUM
  (IR_CHA_COM_SHORT_NAME,
  IR_LIC_CUR,
  IR_LOC_CUR,
  IR_LIC_TYPE,
  IR_YEAR,
  IR_MONTH,
  IR_LIC_ADDITIONS,
  IR_LOC_ADDITIONS,
  IR_LIC_CANCELLATIONS,
  IR_LOC_CANCELLATIONS,
  IR_LIC_FLF_PRICE_CHANGE,
  IR_LOC_FLF_PRICE_CHANGE,
  IR_LIC_REVERSAL,
  IR_LOC_REVERSAL,
  IR_LIC_COS_COST,
  IR_LOC_COS_COST,
  IR_LIC_OB_ASSET_VALUE,
  IR_LOC_OB_ASSET_VALUE,
  IR_LIC_OB_COST,
  IR_LOC_OB_COST,
  IR_LIC_OB_INVENTORY,
  IR_LOC_OB_INVENTORY,
  IR_LIC_PIE_FEE,
  IR_LOC_PIE_FEE,
  IR_LIC_PIE_COST,
  IR_LOC_PIE_COST,
  IR_LIC_CB_ASSET_VALUE,
  IR_LOC_CB_ASSET_VALUE,
  IR_LIC_CB_COST,
  IR_LOC_CB_COST,
  IR_LIC_CB_INVENTORY,
  IR_LOC_CB_INVENTORY,
  IR_LIC_CALC_COST,
  IR_LOC_CALC_COST,
  IR_RUN_BY
  )
   SELECT
       INVENTORY.COM_SHORT_NAME as IR_CHA_COM_SHORT_NAME,
       IR_LIC_CUR,
      (select FT.TER_CUR_CODE  from    
                 fid_company fc ,fid_territory fT
                where  FT.ter_code = FC.COM_TER_CODE
                AND COM_SHORT_NAME =INVENTORY.COM_SHORT_NAME) COM_CURRENCY,
       LR_LIC_TYPE AS IR_LIC_TYPE,
       IR_YEAR,
       IR_MONTH,
       LIC_ADDITIONS AS IR_LIC_ADDITIONS,
       LOC_ADDITIONS AS IR_LOC_ADDITIONS,
       LIC_CANCELLATIONS AS IR_LIC_CANCELLATIONS,
       LOC_CANCELLATIONS AS IR_LOC_CANCELLATIONS,
       LIC_FLF_PRICE_CHANGE AS IR_LIC_FLF_PRICE_CHANGE,
       LOC_FLF_PRICE_CHANGE AS IR_LOC_FLF_PRICE_CHANGE,
       LIC_REVERSAL AS IR_LIC_REVERSAL,
       LOC_REVERSAL AS IR_LOC_REVERSAL,
       LIC_COS_COST AS IR_LIC_COS_COST,
       LOC_COS_COST AS IR_LOC_COS_COST,
       LIC_OB_ASSET_VALUE AS IR_LIC_OB_ASSET_VALUE,
       LOC_OB_ASSET_VALUE AS IR_LOC_OB_ASSET_VALUE,
       LIC_OB_COST AS IR_LIC_OB_COST,
       LOC_OB_COST AS IR_LOC_OB_COST,
       LIC_OB_INVENTORY AS IR_LIC_OB_INVENTORY,
       LOC_OB_INVENTORY AS IR_LOC_OB_INVENTORY,
       LIC_PIE_FEE AS IR_LIC_PIE_FEE,
       LOC_PIE_FEE AS IR_LOC_PIE_FEE,
       LIC_PIE_COST AS IR_LIC_PIE_COST,
       LOC_PIE_COST AS IR_LOC_PIE_COST,
       LIC_CB_ASSET_VALUE AS IR_LIC_CB_ASSET_VALUE,
       LOC_CB_ASSET_VALUE AS IR_LOC_CB_ASSET_VALUE,
       LIC_CB_COST AS IR_LIC_CB_COST,
       LOC_CB_COST AS IR_LOC_CB_COST,
       LIC_CB_INVENTORY AS IR_LIC_CB_INVENTORY,
       LOC_CB_INVENTORY AS IR_LOC_CB_INVENTORY,
       LIC_CALC_COST AS IR_LIC_CALC_COST,
       LOC_CALC_COST AS IR_LOC_CALC_COST,
       I_RECON_USER AS IR_RUN_BY
    FROM
		  (
          SELECT FID_COMPANY.COM_SHORT_NAME COM_SHORT_NAME,
          IR_LIC_CUR,
          IR_LIC_TYPE,
          IR_YEAR,
          IR_MONTH,
          SUM(NVL(IR_LIC_MOV_COST,0)) LIC_COS_COST,
          SUM(NVL(IR_LOC_MOV_COST,0)) LOC_COS_COST,
          SUM(NVL(IR_LIC_SUM_ASSET_OPENING,0)) LIC_OB_ASSET_VALUE,
          SUM(NVL(IR_LIC_SUM_COST_OPENING,0)) LIC_OB_COST,
          (
            SUM(NVL(IR_LIC_SUM_ASSET_OPENING,0)) -
            SUM(NVL(IR_LIC_SUM_COST_OPENING,0))
          )
          AS LIC_OB_INVENTORY,
          SUM(NVL(IR_LOC_SUM_ASSET_OPENING,0)) LOC_OB_ASSET_VALUE,
          SUM(NVL(IR_LOC_SUM_COST_OPENING,0)) LOC_OB_COST,
          (
            SUM(NVL(IR_LOC_SUM_ASSET_OPENING,0)) -
            SUM(NVL(IR_LOC_SUM_COST_OPENING,0))
          )
          AS LOC_OB_INVENTORY,
          SUM(NVL(IR_LIC_SUM_ASSET_CLOSING,0)) LIC_CB_ASSET_VALUE,
          SUM(NVL(IR_LIC_SUM_COST_CLOSING,0)) LIC_CB_COST,
          (
            SUM(NVL(IR_LIC_SUM_ASSET_CLOSING,0)) -
            SUM(NVL(IR_LIC_SUM_COST_CLOSING,0))
          )
          AS LIC_CB_INVENTORY,
          SUM(NVL(IR_LOC_SUM_ASSET_CLOSING,0)) LOC_CB_ASSET_VALUE,
          SUM(NVL(IR_LOC_SUM_COST_CLOSING,0)) LOC_CB_COST,
          (
            SUM(NVL(IR_LOC_SUM_ASSET_CLOSING,0)) -
            SUM(NVL(IR_LOC_SUM_COST_CLOSING,0))
          )
          AS LOC_CB_INVENTORY,
          SUM(NVL(IR_LIC_PROG_INV_FEE,0)) LIC_PIE_FEE,
          SUM(NVL(IR_LIC_PROG_INV_COST,0)) LIC_PIE_COST,
          SUM(NVL(IR_LOC_PROG_INV_FEE,0)) LOC_PIE_FEE,
          SUM(NVL(IR_LOC_PROG_INV_COST,0)) LOC_PIE_COST,
          (
            SUM(NVL(IR_LIC_MOV_COST,0))          +
            SUM(NVL(IR_LIC_SUM_COST_OPENING,0))  -
            SUM(NVL(IR_LIC_PROG_INV_COST,0))
          )
          AS LIC_CALC_COST,
          (
            SUM(NVL(IR_LOC_MOV_COST,0))          +
            SUM(NVL(IR_LOC_SUM_COST_OPENING,0))  -
            SUM(NVL(IR_LOC_PROG_INV_COST,0))
          )
          AS LOC_CALC_COST
          FROM X_INVENTORY_RECON ,FID_COMPANY 
          WHERE IR_YYYYMM = I_RECON_PERIOD
            and X_INVENTORY_RECON.IR_LIC_CHA_COM_NUMBER = FID_COMPANY.com_number
          GROUP BY
          COM_SHORT_NAME,
          IR_LIC_CUR,
          IR_LIC_TYPE,
          IR_YEAR,
          IR_MONTH
		  ) INVENTORY,
		  (
           SELECT
            FID_COMPANY.COM_SHORT_NAME COM_SHORT_NAME, 
            LR_LIC_CUR,
            LR_LIC_TYPE,
            LR_YEAR,
            LR_MONTH,
            SUM(NVL(LR_LIC_ADDITIONS,0)) LIC_ADDITIONS,
            SUM(NVL(LR_LOC_ADDITIONS,0)) LOC_ADDITIONS,
            SUM(NVL(LR_LIC_CANCELATION,0)) LIC_CANCELLATIONS,
            SUM(NVL(LR_LOC_CANCELATION,0)) LOC_CANCELLATIONS,
            SUM(NVL(LR_LIC_FLF_CHANGE_REVAL,0)) LIC_FLF_PRICE_CHANGE,
            SUM(NVL(LR_LOC_FLF_CHANGE_REVAL,0)) LOC_FLF_PRICE_CHANGE,
            SUM(NVL(LR_LIC_REVERSAL,0)) LIC_REVERSAL,
            SUM(NVL(LR_LOC_REVERSAL,0)) LOC_REVERSAL
          FROM
            X_LIABILITY_RECON,FID_COMPANY 
          WHERE LR_YYYYMM = I_RECON_PERIOD
          and x_liability_recon.lr_lic_cha_com_number = FID_COMPANY.com_number
          GROUP BY
            COM_SHORT_NAME,
            LR_LIC_CUR,
            LR_LIC_TYPE,
            LR_YEAR,
            LR_MONTH
		  ) LIABILITY
	WHERE LR_YEAR(+) = IR_YEAR
	AND LR_MONTH(+) = IR_MONTH
	AND LR_LIC_TYPE(+) = IR_LIC_TYPE
	AND LIABILITY.COM_SHORT_NAME(+) = INVENTORY.COM_SHORT_NAME
	AND LR_LIC_CUR(+) = IR_LIC_CUR;

	--LIABILITY RECON SUMMATION

	DELETE FROM X_LIABILITY_RECON_SUM
	WHERE LR_YYYYMM = I_RECON_PERIOD;

	INSERT INTO X_LIABILITY_RECON_SUM
  (LR_LIC_CHA_COM,
  LR_LIC_CUR,
  LR_LOC_CUR,
  LR_LIC_TYPE,
  LR_MONTH,
  LR_YEAR,
  LR_LIC_OB_LIAB,
  LR_LOC_OB_LIAB,
  LR_LIC_ADDITIONS,
  LR_LOC_ADDITIONS,
  LR_LIC_CANCELLATION,
  LR_LOC_CANCELLATION,
  LR_LIC_FLF_CHANGE_REVAL,
  LR_LOC_FLF_CHANGE_REVAL,
  LR_LIC_REVERSAL,
  LR_LOC_REVERSAL,
  LR_LIC_PAYMENTS,
  LR_LOC_PAYMENTS,
  LR_LIC_ADJ_PAY,
  LR_LOC_ADJ_PAY,
  LR_LIC_TRANSFER_PAY,
  LR_LOC_TRANSFER_PAY,
  LR_LIC_RGL,
  LR_LIC_MOVEMENT,
  LR_LOC_MOVEMENT,
  LR_CAL_LIC_CB_LIAB,
  LR_CAL_LOC_CB_LIAB,
  LR_LIC_CB_LIAB,
  LR_LOC_CB_LIAB,
  LR_LIC_LIAB_DIFF,
  LR_LOC_LIAB_DIFF,
  LR_RUN_BY
  )
	SELECT
	  FID_COMPANY.COM_SHORT_NAME COM_SHORT_NAME,
	  LR_LIC_CUR,
   (select FT.TER_CUR_CODE  from    
                 fid_company fc ,fid_territory fT
                where  FT.ter_code = FC.COM_TER_CODE
                AND COM_NUMBER =X_LIABILITY_RECON.LR_LIC_CHA_COM_NUMBER) COM_CURRENCY,
	  LR_LIC_TYPE,
	  LR_MONTH,
	  LR_YEAR,
	  SUM(NVL(LR_LIC_OB_LIAB,0)) LR_LIC_OB_LIAB,
	  SUM(NVL(LR_LOC_OB_LIAB,0)) LR_LOC_OB_LIAB,
	  SUM(NVL(LR_LIC_ADDITIONS,0)) LR_LIC_ADDITIONS,
	  SUM(NVL(LR_LOC_ADDITIONS,0)) LR_LOC_ADDITIONS,
	  SUM(NVL(LR_LIC_CANCELATION,0)) LR_LIC_CANCELLATION,
	  SUM(NVL(LR_LOC_CANCELATION,0)) LR_LOC_CANCELLATION,
	  SUM(NVL(LR_LIC_FLF_CHANGE_REVAL,0)) LR_LIC_FLF_CHANGE_REVAL,
	  SUM(NVL(LR_LOC_FLF_CHANGE_REVAL,0)) LR_LOC_FLF_CHANGE_REVAL,
	  SUM(NVL(LR_LIC_REVERSAL,0)) LR_LIC_REVERSAL,
	  SUM(NVL(LR_LOC_REVERSAL,0)) LR_LOC_REVERSAL,
	  SUM(NVL(LR_LIC_PAYMENTS,0)) LR_LIC_PAYMENTS,
	  SUM(NVL(LR_LOC_PAYMENTS,0)) LR_LOC_PAYMENTS,
	  SUM(NVL(LR_LIC_ADJ_PAY,0)) LR_LIC_ADJ_PAY,
	  SUM(NVL(LR_LOC_ADJ_PAY,0)) LR_LOC_ADJ_PAY,
	  SUM(NVL(LR_LIC_TRANSFER_PAY,0)) LR_LIC_TRANSFER_PAY,
	  SUM(NVL(LR_LOC_TRANSFER_PAY,0)) LR_LOC_TRANSFER_PAY,
	  SUM(NVL(LR_LIC_RGL,0)) LR_LIC_RGL,
	  SUM(NVL(LR_LIC_MOVEMENT,0)) LR_LIC_MOVEMENT,
	  SUM(NVL(LR_LOC_MOVEMENT,0)) LR_LOC_MOVEMENT,
	  SUM(NVL(LR_LIC_CB_LIAB_CAL,0)) LR_CAL_LIC_CB_LIAB,
	  SUM(NVL(LR_LOC_CB_LIAB_CAL,0)) LR_CAL_LOC_CB_LIAB,
	  SUM(NVL(LR_LIC_CB_LIAB,0)) LR_LIC_CB_LIAB,
	  SUM(NVL(LR_LOC_CB_LIAB,0)) LR_LOC_CB_LIAB,
	  (
      SUM(NVL(LR_LIC_CB_LIAB_CAL,0)) - SUM(NVL(LR_LIC_CB_LIAB,0))
    )
    AS LR_LIC_LIAB_DIFF,
    (
      SUM(NVL(LR_LOC_CB_LIAB_CAL,0)) - SUM(NVL(LR_LOC_CB_LIAB,0))
    )
    AS LR_LOC_LIAB_DIFF,
	  I_RECON_USER LR_RUN_BY
	FROM
	  X_LIABILITY_RECON ,FID_COMPANY
	WHERE LR_YYYYMM =  I_RECON_PERIOD
  and x_liability_recon.lr_lic_cha_com_number = FID_COMPANY.com_number
	GROUP BY
	  COM_SHORT_NAME,
	  LR_LIC_CUR,
    LR_LIC_CHA_COM_NUMBER,
	  LR_LIC_TYPE,
	  LR_YEAR,    
	  LR_MONTH,
	  I_RECON_USER;

	--PRE-PAYMENT RECON SUMMATION

	DELETE FROM X_PRE_PAYMENT_RECON_SUM
	WHERE PR_YYYYMM = I_RECON_PERIOD;

	INSERT INTO X_PRE_PAYMENT_RECON_SUM
  (PR_CHA_COM_SHORT_NAME,
  PR_LIC_CUR,
  PR_LOC_CUR,
  PR_LIC_TYPE,
  PR_MONTH,
  PR_YEAR,
  PR_LIC_OPENING_BAL,
  PR_LOC_OPENING_BAL,
  PR_LIC_PREPAY_MOVEMENT,
  PR_LOC_PREPAY_MOVEMENT,
  PR_LIC_PRE_PAY,
  PR_LOC_PRE_PAY,
  PR_LIC_PRE_ADJ_PAY,
  PR_LIC_ADJ_TRANSFER,
  PR_LOC_PRE_ADJ_PAY,
  PR_LOC_ADJ_TRANSFER,
  PR_RGL,
  PR_LIC_CALC_PAY,
  PR_LOC_CALC_PAY,
  PR_LIC_CLOSING_BAL,
  PR_LOC_CLOSING_BAL,
  PR_RUN_BY)
SELECT
	 FID_COMPANY.COM_SHORT_NAME COM_SHORT_NAME,
		PR_LIC_CUR,
	(select FT.TER_CUR_CODE  from    
           fid_company fc ,fid_territory fT
          where  FT.ter_code = FC.COM_TER_CODE
          AND COM_NUMBER =X_PRE_PAYMENT_RECON.PR_LIC_CHA_COM_NUMBER) COM_CURRENCY,
		PR_LIC_TYPE,
		PR_MONTH,
		PR_YEAR,
		SUM(NVL(PR_LIC_OPENING_BAL,0)) PR_LIC_OPENING_BAL,
		SUM(NVL(PR_LOC_OPENING_BAL,0)) PR_LOC_OPENING_BAL,
		SUM(NVL(PR_LIC_PREPAY_MOVEMENT,0)) PR_LIC_PREPAY_MOVEMENT,
		SUM(NVL(PR_LOC_PREPAY_MOVEMENT,0)) PR_LOC_PREPAY_MOVEMENT,
		SUM(NVL(PR_LIC_PRE_PAY,0)) PR_LIC_PRE_PAY,
		SUM(NVL(PR_LOC_PRE_PAY,0)) PR_LOC_PRE_PAY,
	  SUM(NVL(PR_LIC_PRE_ADJ_PAY,0))  AS PR_LIC_PRE_ADJ_PAY,
    SUM(NVL(PR_LIC_ADJ_TRANSFER,0)) AS PR_LIC_ADJ_TRANSFER,
		SUM(NVL(PR_LOC_PRE_ADJ_PAY,0))  AS PR_LOC_PRE_ADJ_PAY,
    SUM(NVL(PR_LOC_ADJ_TRANSFER,0)) AS PR_LOC_ADJ_TRANSFER,
		SUM(NVL(PR_RGL,0)) PR_RGL,
    (
      SUM(NVL(PR_LIC_OPENING_BAL,0))  			+
      SUM(NVL(PR_LIC_PRE_PAY,0)) 	          +
      SUM(NVL(PR_LIC_PRE_ADJ_PAY,0))        +
      SUM(NVL(PR_LIC_ADJ_TRANSFER,0)) 			-
      SUM(NVL(PR_LIC_PREPAY_MOVEMENT,0))
		)
    AS PR_LIC_CALC_PAY,
    (
      SUM(NVL(PR_LOC_OPENING_BAL,0))  		  +
      SUM(NVL(PR_LOC_PRE_PAY,0)) 	          +
      SUM(NVL(PR_LOC_PRE_ADJ_PAY,0))        +
      SUM(NVL(PR_LOC_ADJ_TRANSFER,0)) 			+
      SUM(NVL(PR_RGL,0))									  -
      SUM(NVL(PR_LOC_PREPAY_MOVEMENT,0))
	)
    AS PR_LOC_CALC_PAY,
		SUM(NVL(PR_LIC_CLOSING_BAL,0)) PR_LIC_CLOSING_BAL,
		SUM(NVL(PR_LOC_CLOSING_BAL,0)) PR_LOC_CLOSING_BAL,
		I_RECON_USER PR_RUN_BY
	FROM
		X_PRE_PAYMENT_RECON ,FID_COMPANY
	WHERE
		PR_YYYYMM =I_RECON_PERIOD
      and X_PRE_PAYMENT_RECON.pr_lic_cha_com_number = FID_COMPANY.com_number
	GROUP BY
		COM_SHORT_NAME,
		PR_LIC_CUR,
		PR_LIC_CHA_COM_NUMBER,
		PR_LIC_TYPE,
		PR_YEAR,
		PR_MONTH,
		I_RECON_USER ;

---Delete the data having all values zero.
  DELETE
   FROM  X_PRE_PAYMENT_RECON_SUM
  WHERE   NVL(PR_LIC_OPENING_BAL,0) = 0
	AND   NVL(PR_LIC_PRE_PAY,0) = 0
	AND	  NVL(PR_LIC_PRE_ADJ_PAY,0) = 0
	AND   NVL(PR_LIC_PREPAY_MOVEMENT,0) = 0
	AND   NVL(PR_LIC_CLOSING_BAL,0) = 0
	AND	  NVL(PR_LOC_OPENING_BAL,0) = 0 
	AND	  NVL(PR_LOC_PRE_PAY,0) = 0	    
	AND	  NVL(PR_LOC_PRE_ADJ_PAY,0) = 0
	AND	  NVL(PR_RGL,0)	 = 0
	AND	  NVL(PR_LOC_PREPAY_MOVEMENT,0) = 0
	and   NVL(PR_LoC_CLOSING_BAL,0) = 0;

  DELETE
  FROM X_LIABILITY_RECON_SUM
  WHERE NVL(LR_LIC_OB_LIAB,0)= 0
        AND	NVL(LR_LIC_ADDITIONS,0) = 0
        AND NVL(LR_LIC_CANCELLATION,0) = 0
        AND NVL(LR_LIC_FLF_CHANGE_REVAL,0) = 0
        AND	NVL(LR_LIC_REVERSAL,0) = 0
        AND NVL(LR_LIC_PAYMENTS,0) = 0
        AND NVL(LR_LIC_ADJ_PAY,0) = 0
        AND NVL(LR_LIC_TRANSFER_PAY,0) = 0
        AND NVL(LR_LIC_MOVEMENT,0) = 0
        AND NVL(LR_LIC_CB_LIAB,0) = 0
		AND NVL(LR_LOC_OB_LIAB,0)= 0
        AND	NVL(LR_LOC_ADDITIONS,0) = 0
        AND NVL(LR_LOC_CANCELLATION,0) = 0
        AND NVL(LR_LOC_FLF_CHANGE_REVAL,0) = 0
        AND	NVL(LR_LOC_REVERSAL,0) = 0
        AND NVL(LR_LOC_PAYMENTS,0) = 0
        AND NVL(LR_LOC_ADJ_PAY,0) = 0
        AND NVL(LR_LOC_TRANSFER_PAY,0) = 0
        AND NVL(LR_LOC_MOVEMENT,0) = 0
        AND NVL(LR_LOC_CB_LIAB,0) = 0;

  DELETE
  FROM X_INVENTORY_RECON_SUM
  WHERE NVL(IR_LIC_ADDITIONS,0) = 0
        AND NVL(IR_LIC_CANCELLATIONS,0) = 0
        AND NVL(IR_LIC_FLF_PRICE_CHANGE,0) = 0
        AND NVL(IR_LIC_REVALUATIONS,0) = 0
        AND NVL(IR_LIC_REVERSAL,0) = 0
        AND NVL(IR_LIC_COS_COST,0) = 0
        AND NVL(IR_LIC_OB_ASSET_VALUE,0) = 0
        AND NVL(IR_LIC_OB_COST,0) = 0
        AND NVL(IR_LIC_OB_INVENTORY,0) = 0
        AND NVL(IR_LIC_PIE_FEE,0) = 0
        AND NVL(IR_LIC_PIE_COST,0) = 0
        AND NVL(IR_LIC_CB_ASSET_VALUE,0) = 0
        AND NVL(IR_LIC_CB_COST,0) = 0
        AND NVL(IR_LIC_CB_INVENTORY,0) = 0
        AND NVL(IR_LIC_CALC_COST,0) = 0
		AND NVL(IR_LOC_ADDITIONS,0) = 0
		AND NVL(IR_LOC_CANCELLATIONS,0) = 0
		AND NVL(IR_LOC_FLF_PRICE_CHANGE,0) = 0
		AND NVL(IR_LOC_REVALUATIONS,0) = 0
		AND NVL(IR_LOC_REVERSAL,0) = 0
		AND NVL(IR_LOC_COS_COST,0) = 0
		AND NVL(IR_LOC_OB_ASSET_VALUE,0) = 0
		AND NVL(IR_LOC_OB_COST,0) = 0
		AND NVL(IR_LOC_OB_INVENTORY,0) = 0
		AND NVL(IR_LOC_PIE_FEE,0) = 0
		AND NVL(IR_LOC_PIE_COST,0) = 0
		AND NVL(IR_LOC_CB_ASSET_VALUE,0) = 0
		AND NVL(IR_LOC_CB_COST,0) = 0
		AND NVL(IR_LOC_CB_INVENTORY,0) = 0
		AND NVL(IR_LOC_CALC_COST,0) = 0;

  COMMIT;

END X_PRC_INSERT_RECON_SUM_DATA;

  PROCEDURE X_PRC_RECON_CLEANUP(
    I_RECON_YYYYMM      IN      DATE
)
AS
--****************************************************************
-- This procedure is called for cleanup of old Reconciliation data.
-- REM Client - MNET
--****************************************************************
    L_YEAR_BACK        NUMBER := TO_NUMBER(TO_CHAR(ADD_MONTHS(I_RECON_YYYYMM,-13),'YYYYMM'));
    L_QUARTER_BACK     NUMBER := TO_NUMBER(TO_CHAR(ADD_MONTHS(I_RECON_YYYYMM,-4),'YYYYMM'));
BEGIN
    
    /*
      NOTES:
        1. Inventory Recon Data is dependent on Liability Recon Data, Liability recon data is dependent on Pre-Payment recon data;
            hence the deletion sequence goes as :
            a) Inventory Reconciliation Data.
            b) Liability Reconciliation Data.
            c) Pre-Payment Reconciliation Data.
        2. Data to be deleted:
            1. Reconciliation Data which is a year old.
            2. 3 months or older Reconciliation Data; for reconciled licenses.
    */
    
    --a
    DELETE FROM x_inventory_recon
    WHERE ir_yyyymm <= L_YEAR_BACK
          OR (ir_lic_number, ir_lsl_number, ir_yyyymm) IN 
                    (
                     SELECT
                        IR_LIC_NUMBER,
                        IR_LSL_NUMBER,
                        IR_YYYYMM
                      FROM
                        (
                            SELECT
                                IR_LIC_NUMBER,
                                IR_LSL_NUMBER,
                                IR_LIC_CUR,
                                IR_LIC_MOV_COST,
                                IR_LIC_SUM_ASSET_OPENING,
                                IR_LIC_SUM_COST_OPENING,
                                IR_LIC_PROG_INV_FEE,
                                IR_LIC_PROG_INV_COST,
                                IR_LIC_SUM_ASSET_CLOSING,
                                IR_LIC_SUM_COST_CLOSING,
                                IR_LOC_MOV_COST,
                                IR_LOC_SUM_ASSET_OPENING,
                                IR_LOC_SUM_COST_OPENING,
                                IR_LOC_PROG_INV_FEE,
                                IR_LOC_PROG_INV_COST,
                                IR_LOC_SUM_ASSET_CLOSING,
                                IR_LOC_SUM_COST_CLOSING,
                                IR_YYYYMM
                                FROM
                                    X_INVENTORY_RECON, X_VW_LIC_DETAILS
                                WHERE
                                    IR_LIC_NUMBER = LIC_NUMBER
                                    AND IR_LSL_NUMBER = LSL_NUMBER
                                    AND IR_YYYYMM <= L_QUARTER_BACK
                        ) INVENTORY,
                        (
                            SELECT
                                LR_LIC_NUMBER,
                                LR_LSL_NUMBER,
                                LR_LIC_ADDITIONS,
                                LR_LIC_CANCELATION,
                                LR_LIC_FLF_CHANGE_REVAL,
                                LR_LIC_REVERSAL,
                                LR_LOC_ADDITIONS,
                                LR_LOC_CANCELATION,
                                LR_LOC_FLF_CHANGE_REVAL,
                                LR_LOC_REVERSAL,
                                LR_YYYYMM
                            FROM
                                X_LIABILITY_RECON, X_VW_LIC_DETAILS
                            WHERE
                                LR_LIC_NUMBER = LIC_NUMBER
                                AND LR_LSL_NUMBER = LSL_NUMBER
                                AND LR_YYYYMM <= L_QUARTER_BACK
                        ) LIABILITY
                      WHERE
                          LR_YYYYMM(+) = IR_YYYYMM
                          AND LR_LSL_NUMBER(+) = IR_LSL_NUMBER
                          AND LR_LIC_NUMBER(+) = IR_LIC_NUMBER
                          AND X_PKG_LINEAR_RECON.X_FNC_ROUNDED_VALUE_LIC((
                                IR_LIC_SUM_ASSET_CLOSING      -
                                IR_LIC_SUM_COST_CLOSING       -
                                LR_LIC_ADDITIONS              -
                                LR_LIC_CANCELATION            -
                                LR_LIC_FLF_CHANGE_REVAL       -
                                LR_LIC_REVERSAL               -
                                IR_LIC_SUM_ASSET_OPENING      +
                                IR_LIC_PROG_INV_FEE           +
                                IR_LIC_MOV_COST               +
                                IR_LIC_SUM_COST_OPENING       -
                                IR_LIC_PROG_INV_COST
                              ),IR_LIC_CUR) = 0
                          AND X_PKG_LINEAR_RECON.X_FNC_ROUNDED_VALUE_LOC((
                                IR_LOC_SUM_ASSET_CLOSING      -
                                IR_LOC_SUM_COST_CLOSING       -
                                LR_LOC_ADDITIONS              -
                                LR_LOC_CANCELATION            -
                                LR_LOC_FLF_CHANGE_REVAL       -
                                LR_LOC_REVERSAL               -
                                IR_LOC_SUM_ASSET_OPENING      +
                                IR_LOC_PROG_INV_FEE           +
                                IR_LOC_MOV_COST               +
                                IR_LOC_SUM_COST_OPENING       -
                                IR_LOC_PROG_INV_COST
                              ),IR_LIC_CUR) = 0
                        );

    --b
    DELETE FROM x_liability_recon
    WHERE lr_yyyymm <= L_YEAR_BACK
          OR (
                lr_yyyymm <= L_QUARTER_BACK
                AND X_PKG_LINEAR_RECON.X_FNC_ROUNDED_VALUE_LIC(LR_LIC_CB_LIAB_CAL - LR_LIC_CB_LIAB,LR_LIC_CUR) = 0
                AND X_PKG_LINEAR_RECON.X_FNC_ROUNDED_VALUE_LOC(LR_LOC_CB_LIAB_CAL - LR_LOC_CB_LIAB,LR_LIC_CUR) = 0
             );

    --c
    DELETE FROM x_pre_payment_recon
    WHERE pr_yyyymm <= L_YEAR_BACK
          OR (
                pr_yyyymm <= L_QUARTER_BACK
                AND ROUND(
                      X_PKG_LINEAR_RECON.X_FNC_ROUNDED_VALUE_LIC((
                       PR_LIC_OPENING_BAL         -
                       PR_LIC_PREPAY_MOVEMENT     +
                       PR_LIC_PRE_PAY             +
                       PR_LIC_PRE_ADJ_PAY         +
                       PR_LIC_ADJ_TRANSFER        -
                       PR_LIC_CLOSING_BAL
                     ),PR_LIC_CUR)
                    ) = 0
                AND ROUND(
                      X_PKG_LINEAR_RECON.X_FNC_ROUNDED_VALUE_LOC((
                       PR_LOC_OPENING_BAL       -
                       PR_LOC_PREPAY_MOVEMENT   +
                       PR_LOC_PRE_PAY           +
                       PR_LOC_PRE_ADJ_PAY       +
                       PR_LOC_ADJ_TRANSFER      +
                       PR_RGL                   -
                       PR_LOC_CLOSING_BAL
                    ),PR_LIC_CUR)
                   ) = 0
             );
      
END X_PRC_RECON_CLEANUP;

END X_PKG_LINEAR_RECON_CALC;
/