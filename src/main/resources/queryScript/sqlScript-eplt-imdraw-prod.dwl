%dw 2.0
output text/plain
--- 
"WITH

IBLTLV_IBLITM AS (
    -- Step 1: Get distinct IBLITM and IBLTLV values based on update criteria
    SELECT TRIM(TT1.IBLITM) AS IBLITM, TRIM(TT1.IBITM) AS IBITM, TRIM(TT1.IBLTLV) AS IBLTLV, TRIM(TT1.IBMCU) AS IBMCU
    FROM PRODDTA.F4102 TT1 
    WHERE (TRIM(TT1.IBUPMJ) >= $(vars.previousepltJobRun.date) AND TRIM(TT1.IBTDAY) >= $(vars.previousepltJobRun.time) AND (TT1.IBMCU) = '1801')
    --WHERE TT1.IBLITM = '6203[TB00]' and trim(TT1.IBMCU) = '1801'
    --WHERE TT1.IBLITM = '6002LLU/5C[TB00]' and trim(TT1.IBMCU) = '1801'
    --WHERE TT1.IBLITM = '592A[M100]' and trim(TT1.IBMCU) = '1801'
),
IBLTLV_IBPRP1_IBSRP4 AS (
    ---Query PRP1 and SRP4 where LITM = (IBLTLV_IBLITM) and IBMCU=1801 Hold variables IBPRP1 and IBSRP4
    SELECT TRIM(TT2.IBPRP1) AS IBPRP1, TRIM(TT2.IBSRP4) AS IBSRP4, TRIM(TT2.IBLITM) AS IBLITM, TRIM(TT2.IBITM) AS IBITM
    FROM PRODDTA.F4102 TT2
    LEFT JOIN IBLTLV_IBLITM TT3 ON TRIM(TT2.IBITM) = TRIM(TT3.IBITM)
    WHERE TRIM(TT2.IBMCU)= '1801'
),
IMDRAW_IMSRTX_IBLTLV AS (
    ---In F4101, Find IMDRAW & IMSRTX where IMLITM = IBLTLV_IBLITM. Hold variables IMDRAW & IMSRTX
    SELECT TRIM(TT3.IMDRAW) AS IMDRAW, TRIM(TT3.IMSRTX) AS IMSRTX, TRIM(TT3.IMLITM) AS IMLITM, TRIM(TT3.IMITM) AS IMITM
    FROM PRODDTA.F4101 TT3
    INNER JOIN IBLTLV_IBLITM TT4 ON TRIM(TT3.IMITM) = TRIM(TT4.IBITM)
),
IMLITM_IMDRAW_IBLTLV AS (
    ---In F4101, query all IMLITM where IMDRAW = (variable) IMDRAW and where IMPRP1 = IBPRP1 and IMSRP4 = IBSRP4.Create a result set / collection of LITM for DRAW
    SELECT TRIM(TT5.IMLITM) AS IMLITM, TRIM(TT5.IMITM) AS IMITM, TRIM(TT6.IMDRAW) AS IMDRAW, TRIM(TT5.IMPRP1) AS IMPRP1, TRIM(TT5.IMSRP4) AS IMSRP4
    FROM PRODDTA.F4101 TT5
    INNER JOIN IMDRAW_IMSRTX_IBLTLV TT6 ON TRIM(TT5.IMDRAW) = TRIM(TT6.IMDRAW)
    INNER JOIN IBLTLV_IBPRP1_IBSRP4 TT7 
    ON TRIM(TT5.IMPRP1) = TRIM(TT7.IBPRP1)
    AND TRIM(TT5.IMSRP4) = TRIM(TT7.IBSRP4)
 ),
IMLITM_IMSRTX_IBLTLV AS (
    ---In F4101, query all IMLITM where IMSRTX = (variable) IMSRTX. Create a result set / collection of LITM for SRTX
    SELECT TRIM(TT6.IMLITM) AS IMLITM, TRIM(TT6.IMSRTX) AS IMSRTX
    FROM PRODDTA.F4101 TT6
    LEFT JOIN IMDRAW_IMSRTX_IBLTLV TT7
    ON TRIM(TT6.IMSRTX)=TRIM(TT7.IMSRTX)
),
MINMAX_IBLTLV_IMDRAW AS (
    SELECT TRIM(TT14.IBLITM) AS IBLITM, TRIM(TT14.IBITM) AS IBITM, TT14.IBLTLV AS IBLTLV
    FROM PRODDTA.F4102 TT14
    INNER JOIN IMLITM_IMDRAW_IBLTLV TT15 
        ON TRIM(TT14.IBITM) = TRIM(TT15.IMITM)
    WHERE TRIM(TT14.IBMCU) = '1801'
    AND EXISTS (
        SELECT 1 
        FROM PRODDTA.F4101 F40, IMLITM_IMSRTX_IBLTLV F41
        WHERE TRIM(F40.IMDRAW) = TRIM(TT15.IMDRAW) 
        OR  TRIM(F40.IMSRTX) = TRIM(F41.IMSRTX)
    )
    -- GROUP BY TT14.IBITM, TT14.IBLITM, TT14.IBLTLV
)

SELECT
T3.IBPRP1 AS IBPRP1_IBLTV,
T3.IBSRP4 AS IBSRP4_IBLTV,
T4.IMDRAW AS IMDRAW_IBLTV,
T4.IMSRTX AS IMSRTX_IBLTV,
MIN(T5.IBLTLV) AS MIN_IBLTLV_DRAW,
MAX(T5.IBLTLV) AS MAX_IBLTLV_DRAW

FROM PRODDTA.F4102 T1
INNER JOIN PRODDTA.F4101 T2 ON
        TRIM(T1.IBLITM)=TRIM(T2.IMLITM)
        AND TRIM(T1.IBMCU)='1801'
LEFT JOIN IBLTLV_IBPRP1_IBSRP4 T3 ON
    TRIM(T3.IBLITM) = TRIM(T1.IBLITM)
LEFT JOIN IMDRAW_IMSRTX_IBLTLV T4 ON 1=1
LEFT JOIN MINMAX_IBLTLV_IMDRAW T5 ON 1=1

WHERE (TRIM(T1.IBUPMJ) >= $(vars.previousepltJobRun.date) AND TRIM(T1.IBTDAY) >= $(vars.previousepltJobRun.time) AND TRIM(T1.IBMCU) = '1801')
--WHERE T2.IMLITM = '6203[TB00]' and trim(T1.IBMCU) = '1801'
--WHERE T2.IMLITM = '6002LLU/5C[TB00]' and trim(T1.IBMCU) = '1801'
--WHERE T2.IMLITM = '592A[M100]' and trim(T1.IBMCU) = '1801'

GROUP BY T3.IBPRP1, T3.IBSRP4, T4.IMDRAW, T4.IMSRTX"