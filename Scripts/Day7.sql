-- SUM(SAL) 값이 9000보다 큰 행들만 조회하고 싶은 경우
SELECT DEPTNO ,SUM(SAL) 
FROM EMP
GROUP BY DEPTNO 
HAVING SUM(SAL) > 9000; 


-- 위의 쿼리를 HAVING 절 없이 작성
SELECT *
FROM (SELECT DEPTNO, SUM(SAL) SS
	 	FROM EMP
		GROUP BY DEPTNO)
WHERE SS > 9000; 

SELECT 쿼리 문법
SELECT
FROM
WHERE 
GROUP BY 
HAVING 
ORDER BY

GROUP BY 절에 행을 그룹핑할 기준(컬럼)을 작성
ex : 부서번호"별"로 그룹을 만들경우
GROUP BY deptno

전체행을 기준으로 그룹핑 하려면 GROUP BY 절에 어떤 컬럼을 기술해야 할까?
emp 테이블에 등록된 14명의 사원 전체의 급여 합계를 구하려면? ==> 결과는 1개의 행
==> GROUP BY 절을 기술하지 않는다.
;

SELECT SUM(sal)
	FROM EMP;

GROUP BY 절에 기술한 컬럼을 SELECT 절에 기술하지 않는 경우는??
;

SELECT SUM(SAL)
FROM EMP
GROUP BY DEPTNO;	-- 결과가 출력이 된다

그룹함수의 제한사항
부서번호별 가장 높은 급여를 받는 사람의 급여액
그래서 그 사람이 누군데??; -- 알수 없다==> (서브쿼리, 분석함수를 통해서 알 수 있음)

SELECT DEPTNO, MAX(SAL)
	FROM (SELECT DEPTNO ,MAX(SAL)
		FROM EMP
		GROUP BY DEPTNO 
			)
WHERE ENAME;

GROUP 함수의 특징
1. NULL은 그룹함수 연산에서 제외가 된다.

부서번호별 사원 SAL, COMM 컬럼의 총 합을 구하기;
SELECT DEPTNO, SUM(SAL + COMM), SUM(SAL + NVL(COMM,0)), SUM(SAL) + SUM(COMM)
FROM EMP
GROUP BY DEPTNO;

NULL처리의 효율;
SELECT DEPTNO ,SUM(SAL) + NVL(SUM(COMM), 0)
			   ,SUM(SAL) + SUM(NVL(COMM, 0))
FROM EMP
GROUP BY DEPTNO;

2. GROUP BY 절에 작성된 컬럼 의외의 컬럼이 SELECT 절에 올 수 없다.
	==> GROUP BY 절로 묶었는데 SELECT 로 다시 조회한다? == > 논리적으로 맞지 않는다.
	
-- 실습1
-- 직원중 가장 높은 급여 
-- 직원중 가장 낮은 급여
-- 직원의 급여 평균(소수점 두자리까지 나오도록 반올림)
-- 직원의 급여 합
-- 직원중 급여가 있는 직원의 수(NULL 제외)
-- 직원중 상급자가 있는 직원의 수(NULL 제외) < MGR코드 
-- 전체 직원의수

SELECT *
FROM EMP;

SELECT MAX(SAL) 높은급여 , MIN(SAL) 낮은급여 ,ROUND(AVG(SAL),2) 급여평균 , SUM(SAL) 급여합 , COUNT(SAL), COUNT(MGR), COUNT(*)
FROM EMP;

-- 실습2
-- 실습1의 결과로 부서별로 조회하세요.
SELECT *
FROM EMP;


SELECT 
FROM EMP
GROUP BY DEPTNO;

-- 실습3
SELECT CASE
		WHEN DEPTNO = '20' THEN 'RESEARCH'
		WHEN DEPTNO = '30' THEN 'SALES'
		WHEN DEPTNO = '10' THEN 'ACCOUNTING' 
		END DNAME
	,MAX(SAL) 높은급여 , MIN(SAL) 낮은급여 ,ROUND(AVG(SAL),2) 급여평균 , SUM(SAL) 급여합 , COUNT(SAL), COUNT(MGR), COUNT(*)
FROM EMP
WHERE DEPTNO  IS NOT NULL
GROUP BY DEPTNO;

-- 실습4
SELECT  TO_CHAR(HIREDATE , 'YYYYMM') HIRE_YYYYMM , COUNT(*) cnt
FROM EMP
WHERE HIREDATE IS NOT NULL
GROUP BY TO_CHAR(HIREDATE , 'YYYYMM');


-- 실습5
SELECT COUNT(*) cnt 
FROM (SELECT  TO_CHAR(HIREDATE , 'YYYY') 
	  FROM EMP
	  WHERE HIREDATE IS NOT NULL
	  GROUP BY TO_CHAR(HIREDATE , 'YYYY')
	 );
	
-- 실습6
SELECT COUNT(*) CNT
FROM DEPT;

-- 실습 7
SELECT COUNT(DISTINCT(DEPTNO)) CNT
FROM EMP;

SELECT COUNT(*) cnt
FROM (SELECT COUNT(DEPTNO)
	  FROM EMP
	  GROUP BY DEPTNO 
	  HAVING COUNT(DEPTNO) IS NOT NULL 
	  AND DEPTNO IS NOT NULL
	);

SELECT COUNT(*)
FROM (SELECT DEPTNO 
	  FROM EMP
	  WHERE DEPTNO IS NOT NULL
	  GROUP BY DEPTNO
	);
-- --------------------------조인-----------

--JOIN : 컬럼을 확장하는 방법(데이터 연결한다)
--	   다른 테이블의 컬럼을 가져온다
--RDBMS가 중복을 최소화하는 구조이기 때문에 하나의 테이블에 데이터를 전부 담지 않고, 목적에 맞게 설계한 테이블에
--데이터가 분산된다. 하지만 데이터를 조회할 때 다른 테이블의 데이터를 연결하여 컬럼을 가져올 수 있다.
--
--ANSI-SQL : AMERICAN NATIONAL STANDARD INSTITUTE SQL
--ORACLE-SQL 문법
--두개의 차이가 다소 발생 ==> 회사마다 사용하는게 다름
--
--ANSI-SQL JOIN
--NATURAL JOIN : 조인하고자 하는 테이블간 컬럼명이 동일할 경우 해당 컬럼으로 행을 연결
--				컬럼 이름 뿐만 아니라 데이터 타입도 동일해야함
--
--문법 :
--SELECT 컬럼
--FROM 테이블1 NATURAL JOIN 테이블2...
--
--EMP, DEPT 두 테이블의 공통된 이름을 갖는 컬럼 : DEPTNO;
SELECT EMPNO, ENAME, DEPTNO
FROM EMP NATURAL JOIN DEPT;
 
SELECT DNAME
FROM DEPT;

SELECT EMPNO, ENAME, DEPTNO,DNAME
FROM EMP NATURAL JOIN DEPT
;	==> JOIN 조건으로 사용한 컬럼은 테이블 한정자를 붙이면 에러(ANSI-SQL)

위의 쿼리를 ORACLE-SQL 버전으로 수정
오라클에서는 조인 조건을 WHERE절에 기술
행을 제한하는 조건, 조인 조건 ==> WHERE 절에 기술


SELECT EMP.* ,DEPT.DEPTNO, dname 
FROM EMP,DEPT 
WHERE EMP.DEPTNO = DEPT.DEPTNO
;

SELECT EMP.EMPNO ,EMP.ENAME ,DEPT.DEPTNO,DNAME  
FROM EMP,DEPT 
WHERE EMP.DEPTNO = DEPT.DEPTNO;

SELECT A.*,A.DEPTNO, DNAME
FROM EMP A, DEPT B
WHERE A.DEPTNO = B.DEPTNO;

ANSI-SQL : JOIN WITH USING
조인 테이블간 동일한 이름의 컬럼이 복수개인데 이름이 같은 컬럼중 일부로만 조인하고 싶을 때 사용

SELECT *
FROM EMP JOIN DEPT USING (DEPTNO);

위의 쿼리를 ORACLE 조인으로 변경하면?

SELECT *
FROM EMP,DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;

ANSI-SQL : JOIN WITH ON
위에서 배운	 NATURAL JOIN, JOIN WITH USING 의 경우 조인 테이블의 조인컬럼이 이름이 같아야 한다는 제약조건이 있음
설계상 두 테이블의 컬럼 이름이 다를 수도 있음. 컬럼 이름이 다를경우 개발자가 직접 조인 조건을 기술할 수 있도록 제공해주는
문법.

SELECT *
FROM EMP JOIN DEPT ON (EMP.DEPTNO = DEPT.DEPTNO);

ORACLE-SQL

SELECT *
FROM EMP,DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;









































	










































