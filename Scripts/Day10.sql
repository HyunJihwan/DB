-- 실습 1
SELECT b.BUY_DATE,b.BUY_PROD ,p.PROD_ID ,p.PROD_NAME ,b.BUY_QTY
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.BUY_DATE(+) = '2005/01/25';

-- 실습 2
SELECT NVL(b.BUY_DATE,'2005/01/25'),b.BUY_PROD ,p.PROD_ID ,p.PROD_NAME ,b.BUY_QTY
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.BUY_DATE(+) = '2005/01/25';

-- 실습 3
SELECT NVL(b.BUY_DATE,'2005/01/25') buy_date ,b.BUY_PROD ,p.PROD_ID ,p.PROD_NAME ,NVL(b.BUY_QTY,0) buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
AND b.BUY_DATE(+) = '2005/01/25';

-- 실습 4
SELECT p.pid, p.pnm, NVL(c.CID,1) ,NVL(c."DAY",0),NVL(c.cnt,0) 
FROM CYCLE c ,product p
WHERE c.pid(+) = p.pid
AND c.CID(+) = 1;

-- 실습 5
SELECT p.PID ,p.PNM ,NVL(c.CID,1) CID ,NVL(c2.CNM,'brown') CNM ,nvl(c."DAY",0) DAY ,nvl(c.CNT,0) CNT 
FROM CYCLE c,PRODUCT p,CUSTOMER c2
WHERE c.pid(+) = p.pid 
AND C.cid = c2.cid(+)
AND c.CID(+) = 1;

SELECT p.PID ,p.PNM ,NVL(c.CID,1) ,NVL(c2.CNM,'brown') ,NVL(c."DAY",0),NVL(c.CNT,0) 
FROM "CYCLE" c  FULL JOIN PRODUCT p  
ON(c.pid = p.pid AND C.CID = 1) 
FULL JOIN CUSTOMER c2 ON(C.cid = c2.cid);

SUBQUERY : SQL 내부에서 사용된 SQL (Main 쿼리에서 사용된 쿼리)
사용위치에 따른 분류
1. SELECT 절 : scalar(단일의) subquery
2. FROM 절 : IN-LINE-VIEW
3. WHERE 절 : subquery

반환하는 행, 컬럼 수에 따른 분류
1. 단일행, 단일 컬럼
2. 단일행, 복수 컬럼
3. 복수행, 단일 컬럼
4. 복수행, 복수 컬럼

서브쿼리에서 메인쿼리의 컬럼을 사용유무에 따른 분류
1. 서브쿼리에서 메인쿼리의 컬럼 사용 : corelated subquery ==> 상호 연관 서브쿼리
		==> 서브쿼리 단독으로 실행하는 것이 불가능
2. 서브쿼리에서 메인쿼리의 컬럼 미사용 : non(un) corelated subquery ==> 비상호 연관 서브쿼리
		==> 서브쿼리 단독으로 실행하는 것이 가능
		
SMITH 사원이 속한 부서에서 속하는 사원들은 누가있을까
1. SMITH가 속한 부서의 번호를 확인하는 쿼리

1.;
SELECT DEPTNO
FROM EMP
WHERE ENAME ='SMITH';

2.;
SELECT *
FROM EMP
WHERE DEPTNO =20;

SMITH가 현재 상황에서 속한 부서는 20번인데
나중에 30번 부서로 부서전배가 이뤄지면
2번에서 작성한 쿼리가 수정이 되어야한다.
WHERE DEPTNO = 20; ==> WHERE DEPTNO = 30;

우리가 원하는 것은 고정된 부서번호로 사원 정보를 조회하는것이 아니라
SMITH가 속한 부서를 통해 데이터를 조회 ==> SMITH가 속한 부서가 바뀌더라도
쿼리를 수정하지 않도록 하는것

위에서 작성한 두개의 쿼리를 하나로 합칠 수 있다
==> SMITH의 부서번호가 변경 되더라도 우리가 원하는 데이터 셋을 쿼리 수정 없이 조회할 수 있다
==> 코드 변경이 필요없다 ==> 유지보수가 편하다

SELECT DEPTNO
FROM EMP
WHERE ENAME = 'SMITH'; -- ==> 20이란느 값

SELECT *
FROM EMP
WHERE DEPTNO = (SELECT DEPTNO
				FROM EMP 
				WHERE ENAME = 'SMITH'); 

스칼라 서브쿼리 : SELECT 절에서 사용된 서브쿼리
* 제약사항 : 반드시 서브쿼리가 하나의 행, 하나의 컬럼을 반환해야 된다.

스칼라 서브쿼리가 다중행 복수컬럼을 리턴하는 경우(X)
SELECT EMPNO, ENAME ,(SELECT DEPTNO, DNAME FROM DEPT)
FROM EMP;

스칼라 서브쿼리가 단일행 복수컬럼을 리턴하는 경우
SELECT EMPNO, ENAME, (SELECT DEPTNO,DNAME FROM DEPT WHERE DEPTNO =10)
FROM EMP;

스칼라 서브쿼리가 단일행, 단일컬럼을 리턴하는 경우;
SELECT EMPNO, ENAME,(SELECT DEPTNO FROM DEPT WHERE DEPTNO = 10) DEPTNO
FROM EMP;

메인쿼리의 컬럼을 사용하는 스칼라 서브쿼리;

SELECT EMPNO, ENAME, DEPTNO,
		(SELECT DNAME FROM DEPT WHERE DEPT.DEPTNO = EMP.DEPTNO) DNAME 
		FROM EMP;

IN-LINE VIEW ==> paging 처리할 때 사용해봄

SUBQUERY : WHERE 절에서 사용된 SUBQUERY

SMITH가 속한 부서에 속하는 사원들 조회
WHERE 절에서 서브쿼리 사용시 주의점

연산자와, 서브쿼리의 반환 행수 주의
 = 연산자를 사용시 서브쿼리에서 여러개 행(값)을 리턴하면 논리적으로 맞지가 않다.
IN 연산자를 사용시 서브쿼리에서 리턴하는 여러개의 행(값)과 비교가 가능

SELECT *
FROM EMP
WHERE DEPTNO IN (SELECT DEPTNO
				FROM EMP 
				WHERE ENAME IN ('SMITH','ALLEN')); 




--실습1
SELECT *
FROM EMP 
WHERE SAL > (SELECT ROUND(AVG(SAL),2) AVG_SAL
				FROM EMP);
-- 예제1
사원이 속한 부서의 급여 평균보다 높은 급여를 받는 사원 정보를 조회;

SELECT E.* 
FROM EMP E,(SELECT DEPTNO ,AVG(SAL) S 
			FROM EMP
			GROUP BY DEPTNO) D		 
WHERE E.DEPTNO = D.DEPTNO
AND SAL > S;

SELECT *
FROM EMP A
WHERE SAL > (SELECT AVG(SAL)
			FROM EMP B
			WHERE A.DEPTNO = B.DEPTNO);
	-- 실습1과 차이점은 서브쿼리가 메인쿼리의 테이블 참조하는 건지 아닌지 차이


SELECT *
FROM EMP;
			
-- 실습2
SELECT *
FROM EMP 
WHERE DEPTNO IN(SELECT DEPTNO
			FROM EMP
			WHERE ENAME IN('SMITH','WARD'));
		
[NULL 과 IN, NULL과 NOT IN]
** IN,NOT IN 이용시 NULL 값의 존재 유무에 따라 원하지 않는 결과가 나올 수 있다.

WHERE MGR IN(7902,NULL)
==> MGR = 7902 OR MGR = NULL
==> MGR값이 7902 이거나 MGR 값이 NULL인 데이터

SELECT *
FROM EMP
WHERE MGR IN (7902,NULL);

WHERE MGR NOT IN (7902,NULL);
==> NOT (MGR = 7902 OR MGR = NULL)
==> MGR != 7902 AND MGR != NULL

SELECT *
FROM EMP
WHERE MGR = 7902 OR MGR IS NULL;

[ pairwise, non-pairwise]
한 행의 컬럼 값을 하나씩 비교하는 것 : non-pairwise
한 행의 복수 컬럼을 비교하는 것 : pairwise(다중컬럼 서브쿼리 라고도 한다.)


SELECT *
FROM EMP
WHERE JOB IN('MANAGER','CLERK');	-- NON-PAIRWISE

SELECT *
FROM EMP
WHERE (MGR,DEPTNO) IN (SELECT MGR,DEPTNO
					  FROM EMP					
					  WHERE EMPNO IN (7499,7782));

SELECT *
FROM EMP
WHERE MGR IN ( SELECT MGR
				FROM EMP
				WHERE EMPNO IN(7499, 7782))
AND DEPTNO IN(SELECT DEPTNO
				FROM EMP
				WHERE EMPNO IN(7499,7782));

				


-- 실습3
INSERT INTO DEPT VALUES(99,'dw','daejeon');
INSERT INTO DEPT VALUES(99,'김상재','농민순대');
DELETE FROM DEPT WHERE DEPTNO = 99;


SELECT *
FROM DEPT
WHERE DEPTNO NOT IN (SELECT DEPTNO 
				FROM EMP
				WHERE DEPTNO IS NOT NULL);

	



























