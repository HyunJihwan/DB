-- 논리연산 
-- 논리연산자 : AND, OR , NOT 
-- AND : 참 거짓 판단식1 AND 참 거짓 판단식2 ==> 식 두개를 동시에 만족하는 행만 참
--	   : 일반적으로 AND 조건이 많이 붙으면 조회되는 행의 수가 줄어든다.
-- OR  : 참 거짓 판단식1 OR 참 거짓 판단식2 ==> 식 두개중에 하나라도 만족하면 참
-- NOT : 조건을 반대로 해석하는 부정형 연산
-- NOT IN : 포함되지 않는것
-- IS NOT NULL : NULL 이 아닌것

SELECT *
FROM emp
;

-- emp 테이블에서 mgr 컬럼 값이 7698이면서 sal 컬럼의 값이 1000보다 큰 사원을 조회하세요.
-- 두가지 조건을 동시에 만족하는 사원 리스트

SELECT *
FROM emp
WHERE mgr = 7698 AND SAL > 1000;

UPDATE EMP
SET MGR = 7698
WHERE MGR = 20000;

-- mgr 값이 7698이거나 sal 값이 1000보다 크거나 두개의 조건을 하나라도 만족하는 행을 조회하세요
SELECT *
FROM emp
WHERE mgr = 7698 OR SAL > 1000;

-- emp 테이블에서 mgr 컬럼이 7698,7839가 아닌 사원들을 조회하세요
SELECT *
FROM EMP
WHERE MGR NOT IN(7698,7839);

INSERT INTO EMP(NAME)
VALUES('홍길동');

-- mgr 사번이 7698이 아니고, 7839가 아니고, null이아닌 직원들을 조회하세요.

SELECT *
FROM EMP
WHERE MGR NOT IN(7698,7839) AND 
MGR IS NOT NULL;

-- MGR 컬럼이 (7698, 7839, NULL)에 포함된다.
-- mgr IN(7698, 7839, NULL); ==> MGR ==> 7698 OR MGR = 7839 OR MGR = NULL
-- MGR NOT IN(7698, 7839,NULL); ==> MGR != 7698 AND MGR != 7839 AND MGR != NULL
-- 마지막에 MGR != NULL 값이 항상 false 라서 값이 나오지 않는다.

-- mgr NOT IN (7698, 7839)
-- !(MGR = 7698 OR MGR = 7839) ==> (MGR != 7698 AND MGR !=7839)
-- **** MGR 컬럼에 NULL 값이 있을 경우 비교 연산으로 NULL 비교가 불가하기 때문에 NULL을 갖는 행은 무시가 된다.

SELECT * 
FROM EMP
;
-- 예제1
-- EMP 테이블에서 JOB이 SALESMAN 이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회하세요

SELECT *
FROM EMP
WHERE JOB = 'SALESMAN' AND HIREDATE > TO_DATE ('19810601', 'YYYYMMDD') ;

-- 예제2
-- EMP 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월1일 이후인 직원의 정보를 조회하세요
SELECT *
FROM EMP
WHERE DEPTNO != 10 AND HIREDATE > TO_DATE ('19810601', 'YYYYMMDD') ;

-- 예제3
-- 예제2와 동일 조건을 NOT IN 사용
SELECT *
FROM EMP
WHERE DEPTNO NOT IN(10) AND HIREDATE > TO_DATE ('19810601', 'YYYYMMDD');

-- 예제4
-- EMP테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월1일 이후인 직원의 정보를 조회하세요.
-- 부서는 10,20,30 만 있다고 가정하고 IN 연산자를 사용
SELECT *
FROM EMP
WHERE DEPTNO !=10 AND HIREDATE > TO_DATE ('19810601', 'YYYYMMDD') AND DEPTNO IN(10,20,30);

SELECT *
FROM EMP
WHERE DEPTNO IN(20,30) AND HIREDATE > TO_DATE ('19810601', 'YYYYMMDD');	-- 명시적 형변환
-- 예제5
-- EMP 테이블에서 JOB이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회하세요
SELECT *
FROM EMP
WHERE JOB = 'SALESMAN' 
OR EMPNO LIKE '78%';	-- 묵시적 형변환이 이뤄졌다  

-- 예제 6
-- EMP테이블에서 JOB이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회하세요
-- LIKE 연산자를 사용하지마세요
SELECT *
FROM EMP
WHERE JOB = 'SALESMAN' OR EMPNO BETWEEN  7800 AND 7899
OR EMPNO BETWEEN  780 AND 789
OR EMPNO = 78;

SELECT *
FROM EMP
WHERE JOB = 'SALESMAN'
	OR EMPNO = 78
	OR  (EMPNO >= 780 AND EMPNO <=789)
	OR  (EMPNO >= 7800 AND EMPNO <=7899);

SELECT DISTINCT *
FROM EMP
WHERE JOB = 'SALESMAN' OR EMPNO BETWEEN 7800 AND 7899;

-- ROW NUM은 1밖에 못쓴다.

-- SQL 작성순서(꼭 그렇지 않다)	ORACLE에서 실행하는 순서
-- 1. SELECT			3순위	 
-- 2. FROM				1순위
-- 3. WHERE 			2순위
-- 4. ORDER BY			4순위

/*
 *1.FROM
 *2. ON 
 *3. JOIN
 *4.WHERE 
 *5.GROUP BY
 *6.CUBE | ROLLUP
 *7.HAVING
 *8.SELECT
 *9.DISTINCT
 *10.ORDER BY
 *11.TOP
 */

-- 정렬
-- 정렬 방법 : ORDER BY 절에서 통해 정렬 기준 컬럼을 명시
--		   : 컬럼 뒤에 [ASC | DESC]를 기술하여 오름차순, 내림차순을 지정할 수 있다.

-- 1. ORDER BY 컬럼
-- 2. ORDER BY 별칭
-- 3. ORDER BY SELECT 절에 나열된 컬럼의 인덱스 번호

SELECT *
FROM EMP
ORDER BY 컬럼 | 별칭 | 나열된 컬럼의 인덱스 번호 [ASC | DESC];

SELECT *
FROM EMP
ORDER BY ENAME DESC
;

SELECT * 
FROM EMP
ORDER BY DEPTNO,EMPNO DESC;	-- EMPNO(두번째 기준)는 두번째 기술 조건으로 같은 순위가 있을 때 조건을 줄 수 있다.

-- 별칭으로 ORDER BY
SELECT EMPNO, ENAME, SAL , SAL*12 SALARY
FROM EMP
ORDER BY SALARY;

-- SELECT 절에 기술된 컬럼순서(인덱스)로 정렬
SELECT EMPNO, ENAME, SAL , SAL*12 SALARY
FROM EMP
ORDER BY 4 DESC	-- 4번째 컬럼인 sal*12 salary 로 정렬됨. ==> 데이터 추가시 다른 데이터 추출
;

-- dept 테이블이 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요

SELECT *
FROM DEPT
ORDER BY DNAME;

-- dept 테이블이 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요

SELECT *
FROM DEPT
ORDER BY LOC DESC;
--ORDER BY DEPTNO DESC;

UPDATE DEPT 
SET DEPTNO = 0
WHERE DEPTNO = 10;

--DELETE FROM DEPT 
--WHERE DEPTNO = 10;

SELECT *
FROM DEPT
;

SELECT *
FROM EMP
;

-- EMP 테이블에서 상여(COMM) 정보가 있는 사람들만 조회하고, 상여(COMM)를 많이 받는 사람이 먼저 조회되도록하고,
-- 상여가 같을경우 사번으로 내림차순 정렬하세요.(상여가 0인 사람은 상여가 없는 것으로 간주)

SELECT *
FROM EMP
WHERE COMM > 0
ORDER BY COMM DESC, EMPNO DESC;

--INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');

-- EMP 테이블에서 부서번호가 10,30 에속하고 , SAL 컬럼값이 1500 이상인 사원들을 사원명의 내림차순으로 
-- 정렬하여 조회하세요.
SELECT *
FROM EMP
WHERE DEPTNO IN(10,30) AND SAL >=1500
ORDER BY ENAME DESC;
















