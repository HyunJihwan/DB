-- 실습5
-- users테이블에서 userid가  brown이 아닌 회원의 userid, usernm, reg_dt, reg_dt가 없다면 오늘날짜로 변경하여 조회해주세요
SELECT userid ,usernm, reg_dt, COALESCE(REG_DT  ,SYSDATE)
FROM USERS
WHERE USERID != 'brown'
;

-- SQL 조건문
CASE 
	WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환값
	WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환값2
	WHEN 조건문(참 거짓을 판단할 수 있는 문장) THEN 반환값3
	ELSE 모든 WHEN절을 만족시키지 못할 때 반환할 기본값
END

-- EMP테이블에 저장된 JOB 컬럼의 값을 기준으로 급여(SAL)를 인상시키려고 한다. SAL컬럼과 함께 인상된 SAL컬럼의
-- 값을 비교하고 싶은 상황
-- 급여인상기준
-- JOB이 SALESMAN : SAL * 1.05
-- JOB이 MANAGER : SAL *1.1
-- JOB이 PRESIDENT : SAL * 1.2
-- 나머지 기타 직군은 SAL로 유지

SELECT ENAME, JOB ,SAL,
	CASE 
		WHEN JOB = 'SALESMAN' THEN SAL * 1.05
		WHEN JOB = 'MANAGER' THEN SAL*1.1
		WHEN JOB = 'PRESIDENT' THEN SAL*1.2
		WHEN ENAME = '김상재' THEN SAL*1.2
		ELSE SAL
	END	INC_SAL
FROM EMP;

SELECT *
FROM EMP;


SELECT EMPNO, ENAME,
	CASE
		WHEN DEPTNO = '20' THEN 'RESEARCH'
		WHEN DEPTNO = '30' THEN 'SALES'
		WHEN DEPTNO = '10' THEN 'ACCOUNTING' 
		ELSE '개발자'
	END DNAME
FROM EMP;


-- DECODE : 조건에 따라 반환 값이 달라지는 함수
--			==> 비교, JAVA (if), SQL - case와 비슷
--			단, 비교연산이 ( = ) 만 가능
--			CASE의 WHEN절에 기술할 수 있는 코드는 참 거짓 판단을 할 수 있는 코드면 가능
--			ex : sal > 1000

-- DECODE는 가변인자(인자의 갯수가 정해지지 않음, 상황에 따라 늘어날 수도 있다)를 갖는 함수
-- DECODE는 연산자가 제한된다. equals ( = ) 연산만 가능. CASE 절은 다른 연산자 사용 가능.
-- 문법 : DECODE(기준값[col | expression],
--					비교값1, 반환값1,
--					비교값2, 반환값2,
--					비교값3, 반환값3,
--					옵션[기준값이 비교중에 일치하는 값이 없을 때 기본적으로 반환할 값]
-- ==> java
-- if(기준값 == 비교값1)
--		반환값1 반환
-- else if(기준값 == 비교값2)
--		반환값2 반환
-- else if(기준값 == 비교값3)
--		반환값3 반환
-- else
--		마지막 인자가 있을 경우 마지막 인자를 반환하고
--		마지막 인자가 없을 경우 null을 반환


SELECT EMPNO, JOB ,SAL, 
	DECODE(DEPTNO ,10 ,'ACCOUNTING',20,'RESEARCH',30,'SALES','DW') DNAME
FROM EMP
ORDER BY EMPNO;


SELECT EMPNO, ENAME ,HIREDATE ,
		CASE 
			WHEN MOD(TO_CHAR(HIREDATE , 'YYYY'),2) = 1 THEN '건강검진 대상자'
			ELSE '건강검진 비대상자'
		END "건강검진"
FROM EMP;

SELECT *
FROM EMP;

SELECT EMPNO , ENAME, HIREDATE,
		CASE
			WHEN MOD(TO_CHAR(HIREDATE, 'YYYY'),2) = 0 THEN '건강검진 비대상자'
			WHEN MOD(TO_CHAR(HIREDATE, 'YYYY'),2) = 1 THEN '건강검진 대상자'
		END "건강검진"
FROM EMP;

-- 실습
SELECT ENAME, JOB ,DEPTNO ,SAL,
	CASE 
		WHEN JOB = 'SALESMAN' THEN SAL * 1.05
		WHEN JOB = 'MANAGER' THEN 
							CASE
								WHEN DEPTNO =30 THEN SAL *1.3
								ELSE SAL* 1.1
							END
		WHEN JOB = 'PRESIDENT' THEN SAL*1.2
		ELSE SAL
	END	INC_SAL
FROM EMP;

-- 위의 CASE문 중첩 구문을 DECODE 중첩 구문으로 바꿔주세요.
SELECT ENAME, JOB, SAL ,DECODE(JOB,'SALESMAN',SAL*1.05,
									'MANAGER',DECODE(DEPTNO, 30, SAL*1.3, SAL*1.1),
									'PRESIDENT',SAL*1.2 ,NULL,SAL*50, SAL) inc_sal
FROM EMP;


-- 그룹함수 : 여러개의 행을 입력으로 받아서 하나의 행으로 결과를 리턴하는 함수
-- SUM : 합계
-- COUNT : 행의 수
-- AVG : 평균
-- MAX : 그룹에서 가장 큰 값
-- MIN : 그룹에서 가장 작은 값

-- 사용방법
SELECT 행들을 묶을 기준1, 행들을 묶을 기준2, 그룹함수...
  FROM 테이블
 [WHERE]
 GROUP BY 행들을 묶을 기준1, 행들을 묶을 기준2
 HAVING 

--1.부서번호별 SAL 컬럼의 합
--==> 부서번호가 같은 행들을 하나의 행으로 만든다
--2.부서번호별 가장 큰 급여를 받는사람 급여액수
--3.부서번호별 가장 작은 급여를 받는사람 급여액수
--4.부서번호별 급여 평균액수
--5.부서번호별 급여가 존재하는 사람의 수(sal 컬럼이 null이 아닌 행의 수)
--							* : 그 그룹의 행수 전체가보임

SELECT DEPTNO , JOB , SUM(SAL) 합계 , MAX(SAL) 최댓값,MIN(SAL) 최솟값, AVG(SAL) 평균 
FROM emp
WHERE DEPTNO IS NOT NULL
GROUP BY DEPTNO ,JOB; 

SELECT *
FROM EMP;

DELETE FROM EMP
WHERE ENAME = '김상재';

-- 그룹함수의 특징
-- 1. null 값을 무시
-- 30번 부서의 사원 6명중 2명은 comm 값이 NULL

SELECT DEPTNO, SUM(COMM)
FROM EMP
GROUP BY DEPTNO;

-- 2. GROUP BY를 적용 여러행을 하나의 행으로 묶게 되면 SELECT 절에 기술할 수 있는 컬럼이 제한됨
-- ==> SELECT 절에 기술되는 일반 컬럼들은 (그룹 함수를 적용하지 않은) 반드시 GROUP BY 절에 기술 되어야 한다.
--	   * 단 그룹핑에 영향을 주지 않는 고정된 상수, 함수는 기술하는 것이 가능하다.
SELECT DEPTNO ,ENAME ,SUM(SAL)
FROM EMP
GROUP BY DEPTNO ,ENAME;  

-- 3. 일반 함수를 WHERE 절에서 사용하는게 가능
-- WHERE UPPER(ename) = 'SMITH';
-- 그룹함수의 경우 WHERE 절에서 사용하는게 불가능
-- 하지만 HAVING 절에 기술하여 동일한 결과를 나타낼 수 있다.

-- SUM(SAL) 값이 9000보다 큰 행들만 조회하고 싶은 경우
SELECT DEPTNO ,SUM(SAL) 
FROM EMP
GROUP BY DEPTNO 
HAVING SUM(SAL) > 9000; 

SELECT ENAME A1 , DEPTNO A2 
FROM EMP
WHERE DEPTNO FULL OUTER JOIN DEPT ON 

SELECT DEPTNO B1 , DNAME B2    
FROM DEPT;


