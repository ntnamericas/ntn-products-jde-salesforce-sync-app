%dw 2.0
output text/plain
--- 
"WITH

IBLTLV_IBLITM AS (
    -- Step 1: Get distinct IBLITM and IBLTLV values based on update criteria
    SELECT TRIM(TT1.IBLITM) AS IBLITM, TRIM(TT1.IBLTLV) AS IBLTLV
    FROM CRPDTA.F4102 TT1 
    WHERE (TRIM(TT1.IBUPMJ) > $(vars.previousepltJobRun.date) AND TRIM(TT1.IBTDAY) >= $(vars.previousepltJobRun.time))
	--AND TRIM(TT1.IBLITM)='6203[TB00]'
),
IBLTLV_IBPRP1_IBSRP4 AS (
    ---Query PRP1 and SRP4 where LITM = (IBLTLV_IBLITM) and IBMCU=1801 Hold variables IBPRP1 and IBSRP4
    SELECT TRIM(TT2.IBPRP1) AS IBPRP1, TRIM(TT2.IBSRP4) AS IBSRP4, TRIM(TT2.IBLITM) AS IBLITM
    FROM CRPDTA.F4102 TT2
    INNER JOIN IBLTLV_IBLITM TT3 ON TRIM(TT2.IBLITM) = TT3.IBLITM
    WHERE TRIM(TT2.IBMCU)= '1801'
),
IMDRAW_IMSRTX_IBLTLV AS (
    ---In F4101, Find IMDRAW & IMSRTX where IMLITM = IBLTLV_IBLITM. Hold variables IMDRAW & IMSRTX
    SELECT TRIM(TT3.IMDRAW) AS IMDRAW, TRIM(TT3.IMSRTX) AS IMSRTX, TRIM(TT3.IMLITM) AS IMLITM
    FROM CRPDTA.F4101 TT3
    LEFT JOIN IBLTLV_IBLITM TT4 ON TRIM(TT3.IMLITM) = TRIM(TT4.IBLITM)
),
IMLITM_IMDRAW_IBLTLV AS (
    ---In F4101, query all IMLITM where IMDRAW = (variable) IMDRAW and where IMPRP1 = IBPRP1 and IMSRP4 = IBSRP4.Create a result set / collection of LITM for DRAW
    SELECT TRIM(TT5.IMLITM) AS IMLITM
    FROM CRPDTA.F4101 TT5
    LEFT JOIN IMDRAW_IMSRTX_IBLTLV TT6
    ON TRIM(TT5.IMDRAW)=TRIM(TT6.IMDRAW)
    
),
IMLITM_IMSRTX_IBLTLV AS (
    ---In F4101, query all IMLITM where IMSRTX = (variable) IMSRTX. Create a result set / collection of LITM for SRTX
    SELECT TRIM(TT6.IMLITM) AS IMLITM, TRIM(TT6.IMSRTX) AS IMSRTX
    FROM CRPDTA.F4101 TT6
    LEFT JOIN IMDRAW_IMSRTX_IBLTLV TT7
    ON TRIM(TT6.IMSRTX)=TRIM(TT7.IMSRTX)
),
MINMAX_IBLTLV_IMDRAW AS (
    SELECT TRIM(TT14.IBLITM) AS IBLITM, MIN(TT14.IBLTLV) AS MIN_IBLTLV, MAX(TT14.IBLTLV) AS MAX_IBLTLV
    FROM CRPDTA.F4102 TT14
    JOIN IMLITM_IMDRAW_IBLTLV TT15 ON TRIM(TT14.IBLITM) = TRIM(TT15.IMLITM)
    WHERE TRIM(TT14.IBMCU) = '1801'
    GROUP BY TT14.IBLITM
)

SELECT
T3.IBPRP1 AS IBPRP1_IBLTV,
T3.IBSRP4 AS IBSRP4_IBLTV,
T4.IMDRAW AS IMDRAW_IBLTV,
T4.IMSRTX AS IMSRTX_IBLTV,
T5.MIN_IBLTLV AS MIN_IBLTLV_DRAW,
T5.MAX_IBLTLV AS MAX_IBLTLV_DRAW

FROM CRPDTA.F4102 T1
INNER JOIN CRPDTA.F4101 T2 ON
	TRIM(T1.IBLITM)=TRIM(T2.IMLITM)
	AND TRIM(T1.IBMCU)='1801'
LEFT JOIN IBLTLV_IBPRP1_IBSRP4 T3 ON
    TRIM(T3.IBLITM) = TRIM(T1.IBLITM)
LEFT JOIN IMDRAW_IMSRTX_IBLTLV T4 ON 
    TRIM(T4.IMLITM) = TRIM(T2.IMLITM)
LEFT JOIN MINMAX_IBLTLV_IMDRAW T5 ON
     TRIM(T5.IBLITM)=TRIM(T1.IBLITM)

WHERE (TRIM(T1.IBUPMJ) > $(vars.previousepltJobRun.date) AND TRIM(T1.IBTDAY) >= $(vars.previousepltJobRun.time))
-- and(T2.IMLITM ='6203[TB00]') 

GROUP BY T3.IBPRP1, T3.IBSRP4, T4.IMDRAW, T4.IMSRTX, T5.MIN_IBLTLV, T5.MAX_IBLTLV"