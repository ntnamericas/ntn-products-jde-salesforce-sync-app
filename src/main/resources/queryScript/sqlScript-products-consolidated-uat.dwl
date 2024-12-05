%dw 2.0
output text/plain
---
"WITH 

DRDL01_IBPRP4 AS (
	-- Step 1: Retrieve DRDL01 values for IBPRP4 from UDC 41/P4
    SELECT TRIM(Y1.DRDL01) AS DRDLO1, TRIM(Y1.DRKY) AS DRKY
    FROM CRPCTL.F0005 Y1
    WHERE TRIM(Y1.DRSY) = '41' AND TRIM(Y1.DRRT) = 'P4' --AND ( TRIM(Y1.DRUPMJ) >= $(vars.productsJobRun.date) AND TRIM(Y1.DRUPMT) >= $(vars.previousProductsJobRun.time))
),


IBLTLV_IBLITM AS (
	-- Step 2: Get IBLITM and IBLTLV from F4102 based on criteria
    SELECT TRIM(Y2.IBLITM) AS IBLITM, TRIM(Y2.IBLTLV) AS IBLTLV
    FROM CRPDTA.F4102 Y2
    WHERE ( TRIM(Y2.IBUPMJ) >= $(vars.productsJobRun.date) AND TRIM(Y2.IBTDAY) >= $(vars.previousProductsJobRun.time))
),

IMDRAW_IMSRTX_IBLTLV AS (
	-- Step 3: Retrieve IMDRAW and IMSRTX from F4101 where IMLITM matches IBLITM
    SELECT TRIM(TT10.IMDRAW) AS IMDRAW, TRIM(TT10.IMSRTX) AS IMSRTX, TRIM(TT10.IMLITM) AS IMLITM
    FROM CRPDTA.F4101 TT10
    INNER JOIN IBLTLV_IBLITM TT11 ON TRIM(TT10.IMLITM) = TRIM(TT11.IBLITM)
),


IMLITM_IMSRTX_IBLTLV AS (
	-- Step 4: Filter F4101 records based on IMSRTX, retrieve IMLITM and IMPRP1
    SELECT TRIM(TT13.IMLITM) AS IMLITM, TRIM(TT13.IMPRP1) AS IMPRP1
    FROM CRPDTA.F4101 TT13
    INNER JOIN IMDRAW_IMSRTX_IBLTLV TT14 ON TRIM(TT13.IMSRTX) = TRIM(TT14.IMSRTX)
),


MINMAX_IBLTLV_IMSRTX AS (
	-- Step 5: Find min and max IBLTLV values for each IBLITM in F4102 where IBMCU = '1801'
    SELECT TRIM(TT16.IBLITM) AS IBLITM, MIN(TT16.IBLTLV) AS MIN_IBLTLV, MAX(TT16.IBLTLV) AS MAX_IBLTLV
    FROM CRPDTA.F4102 TT16
    INNER JOIN IMLITM_IMSRTX_IBLTLV TT17 ON TRIM(TT16.IBLITM) = TRIM(TT17.IMLITM)
    WHERE TRIM(TT16.IBMCU) = '1801'
    GROUP BY TT16.IBLITM
)

SELECT
    T1.IBPRP1,
    T1.IBMCU,
    T1.IBPRP4,
    T1.IBLITM,
    T1.IBSRP4,
    T1.IBSRP2,
    T1.IBSRP1,
    T1.IBPRP5,
    T1.IBPRP7,
    T1.IBSTKT,
    T2.IMLITM,
    T2.IMSRTX,
    T3.DRDLO1 AS DRDL01_IBPRP4,
    T12.DRKY AS DRKY_SRP2,
    T12.DRDL01 AS DRDL01_SRP2,
    T13.DRKY AS DRKY_SRP1,
    T13.DRDL01 AS DRDL01_SRP1,
    T14.DRKY AS DRKY_PRP8,
    T14.DRDL01 AS DRDL01_PRP8,
    T15.DRKY AS DRKY_SRP5,
    T15.DRDL01 AS DRDL01_SRP5,
    T16.IMDRAW AS IMDRAW_IBLTLV,
    T16.IMSRTX AS IMSRTX_IBLTLV,
    T17.IMLITM AS IMLITM_IBLTLV

FROM CRPDTA.F4102 T1
INNER JOIN CRPDTA.F4101 T2 
    ON TRIM(T1.IBLITM) = TRIM(T2.IMLITM) AND TRIM(T1.IBMCU) = '1801'
LEFT JOIN DRDL01_IBPRP4 T3 
    ON TRIM(T3.DRKY) = TRIM(T1.IBPRP4)
LEFT JOIN CRPCTL.F0005 T12 
    ON TRIM(T12.DRKY) = TRIM(T1.IBSRP2) AND TRIM(T12.DRSY) = '41' AND TRIM(T12.DRRT) = 'S2'
LEFT JOIN CRPCTL.F0005 T13 
    ON TRIM(T13.DRKY) = TRIM(T1.IBSRP1) AND TRIM(T13.DRSY) = '41' AND TRIM(T13.DRRT) = 'S1'
LEFT JOIN CRPCTL.F0005 T14 
    ON TRIM(T14.DRKY) = TRIM(T1.IBPRP8) AND TRIM(T14.DRSY) = '41' AND TRIM(T14.DRRT) = '02'
LEFT JOIN CRPCTL.F0005 T15 
    ON TRIM(T15.DRKY) = TRIM(T1.IBSRP5) AND TRIM(T15.DRSY) = '41' AND TRIM(T15.DRRT) = 'S5'
LEFT JOIN MINMAX_IBLTLV_IMSRTX T12 
    ON TRIM(T12.IBLITM) = TRIM(T1.IBLITM)
LEFT JOIN IMDRAW_IMSRTX_IBLTLV T16 
    ON TRIM(T16.IMLITM) = TRIM(T2.IMLITM)
LEFT JOIN IMLITM_IMSRTX_IBLTLV T17 
    ON TRIM(T17.IMLITM) = TRIM(T2.IMLITM)
 
WHERE ((T2.IMUPMJ >= $(vars.productsJobRun.date) AND T2.IMTDAY >= $(vars.previousProductsJobRun.time)) OR (T2.IBUPMJ >= $(vars.productsJobRun.date) AND T2.IBTDAY >= $(vars.previousProductsJobRun.time)) OR (T12.DRUPMJ >= $(vars.productsJobRun.date) AND T12.DRUPMT >= $(vars.previousProductsJobRun.time)))
    --T2.IMLITM = '6203[TB00]'
GROUP BY
    T1.IBPRP4, T1.IBLITM, T1.IBSTKT, T1.IBSRP4, T1.IBMCU, T1.IBSRP2, T1.IBSRP1, T2.IMLITM,
    T2.IMSRTX, T3.DRDLO1, T12.DRKY, T12.DRDL01, T13.DRKY, T13.DRDL01,
    T14.DRKY, T14.DRDL01, T15.DRKY, T15.DRDL01, T1.IBPRP1, T1.IBPRP5, 
    T1.IBPRP7, T16.IMDRAW, T16.IMSRTX, T17.IMLITM"