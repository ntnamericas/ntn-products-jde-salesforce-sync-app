%dw 2.0
output text/plain
--- 
"WITH
COLEDG07_F4105 AS (
 ---Based on changed since last run (review  COUMPJ and COTDAY)Hold variable COLITM
    Select TRIM(X1.COLITM) AS COLITM, TRIM(X1.COLEDG) AS COLEDG, TRIM(X1.COUPMJ) AS COUPMJ, TRIM(X1.COTDAY) AS COTDAY, TRIM(X1.COMCU) AS COMCU
    FROM TESTDTA.F4105 X1
    WHERE  X1.COLEDG='07' AND TRIM(COMCU)='1801' AND TRIM(X1.COLITM)='JM720249[H100]'
    --AND (X1.COUPMJ >= $(vars.previouscifJobRun.date) AND X1.COTDAY >= $(vars.previouscifJobRun.time))
	--AND TRIM(X1.COLITM)='6203[TB00]' 
),

IBPRP1_IBSRP4_COLITM AS (
---Query PRP1 and SRP4 where LITM = (COLITM) and IBMCU=1801.Hold the variables PRP1 and SRP4
    SELECT DISTINCT 
    TRIM(TT1.IBPRP1) AS IBPRP1, 
    TRIM(TT1.IBSRP4) AS IBSRP4, 
    TRIM(TT1.IBLITM) AS IBLITM, 
    TRIM(TT1.IBMCU) AS IBMCU
    FROM TESTDTA.F4102 TT1
    INNER JOIN COLEDG07_F4105 TT2 
    ON TRIM(TT1.IBLITM)=TRIM(TT2.COLITM)
    AND TRIM(TT1.IBMCU) = TRIM(TT2.COMCU)
),

IMDRAW_IMSRTX_COLITM AS (
---Query IMDRAW and IMSRTX where LITM = (COLITM) and IBMCU=1801.Hold the variables IMDRAW and IMSRTX
    SELECT TRIM(TT3.IMDRAW) AS IMDRAW, TRIM(TT3.IMSRTX) AS IMSRTX, TRIM(TT3.IMLITM) AS IMLITM
    FROM TESTDTA.F4101 TT3
    INNER JOIN COLEDG07_F4105 TT2 ON TRIM(TT3.IMLITM)=TRIM(TT2.COLITM)
 
),
IMLITM_ISRTX AS (
---Query IMLITM where IMSRTX = (variable) IMSRTX
    SELECT TRIM(TT6.IMLITM) AS IMLITM, TRIM(TT6.IMSRTX) AS IMSRTX
    FROM TESTDTA.F4101 TT6
    INNER JOIN IMDRAW_IMSRTX_COLITM TT7 ON TRIM(TT6.IMSRTX)= TRIM(TT7.IMSRTX)
),

COUNCS_IMSRTX AS (
---Query  COUNCS where IBLITM = COLITM and COMCU=1801 and COLEDG='07'
    SELECT TRIM(TT8.COUNCS)/10000 AS COUNCS, TRIM(TT8.COLITM) AS COLITM, TRIM(TT8.COMCU) AS COMCU, TRIM(COLEDG) AS COLEDG
    FROM TESTDTA.F4105 TT8
    INNER JOIN IMLITM_ISRTX TT10 ON TRIM(TT10.IMLITM)= TRIM(TT8.COLITM)
)

SELECT 
T1.IBLITM,
T2.IMLITM,
MAX(T10.COUNCS) AS MAX_COUNCS_IMSRTX,
MIN(T10.COUNCS) AS MIN_COUNCS_IMSRTX


FROM TESTDTA.F4102 T1
INNER JOIN TESTDTA.F4101 T2 ON
	TRIM(T1.IBLITM)=TRIM(T2.IMLITM)
	AND TRIM(T1.IBMCU)='1801'
LEFT JOIN COLEDG07_F4105 T4 ON
     --TRIM(T4.COLEDG)='07'
     TRIM(T1.IBLITM)=TRIM(T4.COLITM)
LEFT JOIN IBPRP1_IBSRP4_COLITM T5 ON
     TRIM(T5.IBMCU)='1801'
LEFT JOIN IMDRAW_IMSRTX_COLITM T6 ON
     T2.IMLITM=TRIM(T6.IMLITM)
LEFT JOIN IMLITM_ISRTX T8 ON
     T8.IMLITM=TRIM(T2.IMLITM)
LEFT JOIN COUNCS_IMSRTX T10 ON
     T10.COMCU='1801' 
     AND T10.COLEDG='07'


WHERE T2.IMLITM = 'JM720249[H100]'
--WHERE (T4.COUPMJ >= $(vars.previouscifJobRun.date) AND T4.COTDAY >= $(vars.previouscifJobRun.time))

GROUP BY
    T1.IBLITM, T2.IMLITM"