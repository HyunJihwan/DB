SELECT DEPTNO 
FROM emp
GROUP BY deptno;

SELECT DISTINCT deptno
FROM emp;

-------------------------------------------

[ 계층형 쿼리 ]

계층형 쿼리?
 - 한 테이블에 담겨 있는 여러 레코드들이 서로 상하 관계(부모, 자식) 관계를 이루며 존재할 때, 이 관계에 따라 레코드를
   hirearchical(상하위) 한 구조로 가져올 때 사용되는 SQL을 의미한다.
 - 쉽게 생각하면 조직도, 메일함, 문서함 등을 예로 들 수 있다.
 
 이러한 구조의 테이블을 상하위 구조의 일목요연한 레코드로 SELECT 할 때 사용하는것이 오라클의 
 START WITH ~ CONNECT BY 구문이다.
 
 START WITH 
 - 계층 질의의 루트(부모행)로 사용될 행을 지정한다.
 - 서브 쿼리를 사용할 수도 있다.
 - START WITH 구문에서는 어떤 레코드를 최상위 레코드로 잡을지 지정한다.
 
CONNECT BY 
 - 이 절을 이용하여 계층 질의에서 상위계층(부모행)과 하위계층(자식행)의 관계를 규정할 수 있다.
 - PRIOR 연산자와 함께 사용하여 계층구조로 표현할 수 있다.
   지정된 최상위 루트 ROW 와 연관된 레코드(부모 혹은 자식)를 어떻게 전개해 나갈 것인가?
   상위(부모)방향으로 , 하위(자식) 방향으로?
   방향은 'PRIOR'가 어디에 지정되어 있냐에 따라 달라지는데, PRIOR 가 없는 곳에서 PRIOR 가 있는 곳으로 전개된다.
 - CONNECT BY PRIOR 자식컬럼 = 부모컬럼 : 부모에서 자식으로 트리 구성(top Down)
 - CONNECT BY PRIOR 부모컬럼 = 자식컬럼 : 자식에서 부모로 트리 구성(Bottom up)
 - CONNECT BY nocycle PRIOR : noCycle 파라미터를 이용하여 무한 루프 방지
 
LEVEL Pseudocolumn 
 - LEVEL 은 게층구조 쿼리에서 수행 결과의 DEPTH 를 표현하는 의사컬럼이다.
 - 의사컬럼이란, '가짜 컬럼'을 의미한다. 즉, 테이블 생성 시에 DBA나 생성자가 별도로 정의한 컬럼이 아니다.
   단순하게 레코드들이 최상의 레코드로부터 몇 단계 깊이에 있는지를 참고하는 용도로만 사용된다.
;

SELECT LPAD('@',1)
FROM DUAL;



SELECT LPAD(' ',(LEVEL - 1)*4) || ENAME ENAME, LEVEL
FROM EMP
START WITH ENAME = 'KING'
CONNECT BY PRIOR EMPNO = MGR;

-- 계층형쿼리 실습1
SELECT LPAD(' ',(LEVEL - 1)*4) || DEPTNM DEPTNM
FROM DEPT_H 
START WITH DEPTNM = 'XX회사'
CONNECT BY PRIOR DEPTCD = P_DEPTCD;
   
-- 계층형쿼리 실습2

SELECT *
FROM H_SUM;
   
SELECT  LPAD(' ',(LEVEL - 1)*4) || S_ID S_ID, VALUE
FROM H_SUM
START WITH S_ID = 0
CONNECT BY PRIOR S_ID = PS_ID;
   
CONNECT BY 의 실행 순서는 다음과 같다.
1. START WITH 절
2. CONNECT BY 절
3. WHERE 절

SELECT LPAD(' ',(LEVEL - 1)*4) || DEPTNM DEPTNM
FROM DEPT_H 
--WHERE DEPTNM != '정보기획부'
START WITH DEPTNM = 'XX회사'
CONNECT BY PRIOR DEPTCD = P_DEPTCD AND DEPTNM != '정보기획부';
   
SELECT *
FROM DEPT_H;
   

iw : 월요일을 기준으로 한 주차
ww : 일요일을 기준으로 한 주차

[ 2023년 5월의 달력 구하기 ]

SELECT MIN(SUN) SUN, MIN(MON) MON,MIN(TUE) TUE,MIN(WED) WED, MIN(THU) THU,MIN(FRI) FRI ,MIN(SAT) SAT
	FROM (SELECT WW B
	   ,DECODE(D,1,DT,null) SUN
	   ,DECODE(D,2,DT,null) MON
	   ,DECODE(D,3,DT,NULL) TUE
	   ,DECODE(D,4,DT,NULL) WED
	   ,DECODE(D,5,DT,NULL) THU
	   ,DECODE(D,6,DT,NULL) FRI
	   ,DECODE(D,7,DT,NULL) SAT  
	FROM(SELECT 
	   TO_DATE(:YYYYMM , 'YYYYMM') + (LEVEL-1) DT 
	  ,TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') +(LEVEL -1), 'D') d
	  ,TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM')+(LEVEL -1), 'WW') WW
	  ,LEVEL	   
		FROM DUAL
		CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') 	
	) 
ORDER BY WW) A
GROUP BY A.B
ORDER BY A.B;














   


SELECT LAST_DAY(TO_DATE('202305','YYYYMM'))
FROM DUAL;

   
 
   
   
   
   



















   
   SELECT 
        NVL(MIN( DECODE(TO_CHAR(dates,'D'),1, TO_CHAR(dates,'DD')  ) ),' ') 일
        ,NVL(MIN(DECODE(TO_CHAR(dates,'D'),2, TO_CHAR(dates,'DD')  ) ),' ') 월
        ,NVL(MIN(DECODE(TO_CHAR(dates,'D'),3, TO_CHAR(dates,'DD')  ) ),' ') 화
        ,NVL(MIN(DECODE(TO_CHAR(dates,'D'),4, TO_CHAR(dates,'DD')  ) ),' ') 수
        ,NVL(MIN(DECODE(TO_CHAR(dates,'D'),5, TO_CHAR(dates,'DD')  ) ),' ') 목
        ,NVL(MIN(DECODE(TO_CHAR(dates,'D'),6, TO_CHAR(dates,'DD')  ) ),' ') 금
        ,NVL(MIN(DECODE(TO_CHAR(dates,'D'),7, TO_CHAR(dates,'DD')  ) ),' ') 토
FROM(
    SELECT TO_DATE(:yyyymm,'YYYYMM') + (LEVEL -1) dates
    FROM dual
    CONNECT BY LEVEL <= EXTRACT(DAY FROM LAST_DAY(TO_DATE( :yyyymm ,'YYYYMM')))
) t
GROUP BY DECODE( TO_CHAR( dates, 'D'),1, TO_CHAR( dates, 'IW')+1, TO_CHAR( dates, 'IW') ) 
ORDER BY DECODE( TO_CHAR( dates,'D') ,1, TO_CHAR( dates, 'IW')+1, TO_CHAR( dates, 'IW') );
   
   
   
   
   
   
   
   
 
 
