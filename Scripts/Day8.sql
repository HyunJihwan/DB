SELF-JOIN : 동일한 테이블끼리 조인할 때 자칭하는 명칭(별도의 키워드가 아니다)

SELECT *
FROM EMP;

SELECT a.EMPNO "사원번호", a.ENAME "사원이름" , a.MGR "사원의 상사 사원번호", b.ENAME "사원의 상사 이름"
FROM EMP a ,EMP b
WHERE a.mgr = b.Empno;  
-- 매니저 번호는 사원 번호가된다.
-- KING의 경우 상사가 없기 때문에 조인에 실패한다.
-- 따라서 총 행의 수는 13건이 조회된다.

SELECT E.EMPNO,E.ENAME,E.MGR,M.ENAME 
FROM EMP E JOIN EMP M ON E.MGR = M.EMPNO;

-- 사원중 사원의 번호가 7369 ~ 7639인 사원만 대상으로 해당 사원의 사원번호,이름,상사의 사원번호, 상사의 이름 조회

SELECT E.EMPNO,E.ENAME,E.MGR,M.ENAME 
FROM EMP E JOIN EMP M ON(E.MGR=M.EMPNO)
WHERE E.EMPNO BETWEEN 7369 AND 7698;

SELECT a.EMPNO "사원번호", a.ENAME "사원이름" , a.MGR "사원의 상사 사원번호", b.ENAME "사원의 상사 이름"
FROM EMP a ,EMP b
WHERE a.mgr = b.Empno
AND a.EMPNO BETWEEN 7369 AND 7698;

NON-EQUI-JOIN : 조인 조건이 = 이 아닌 조인

SELECT *
FROM SALGRADE;

SELECT EMPNO,ENAME,SAL,SALGRADE.GRADE 
FROM EMP ,SALGRADE
WHERE EMP.SAL BETWEEN SALGRADE.LOSAL AND SALGRADE.HISAL; 

-- 실습 0

SELECT A.EMPNO ,A.ENAME ,A.DEPTNO,A.ENAME 
FROM EMP A,DEPT B
WHERE A.DEPTNO = B.DEPTNO;

-- 실습 1
SELECT A.EMPNO ,A.ENAME ,A.DEPTNO,A.ENAME 
FROM EMP A,DEPT B
WHERE A.DEPTNO = B.DEPTNO
AND A.DEPTNO != 20;

-- 실습 2
SELECT A.EMPNO ,A.ENAME ,A.SAL ,B.DEPTNO,B.DNAME 
FROM EMP A,DEPT B
WHERE A.DEPTNO = B.DEPTNO
AND SAL > 2500;

-- 실습 3
SELECT A.EMPNO ,A.ENAME ,A.SAL ,B.DEPTNO,B.DNAME 
FROM EMP A,DEPT B
WHERE A.DEPTNO = B.DEPTNO
AND SAL > 2500 
AND A.ENAME != 'JONES';

-- 실습 4
SELECT A.EMPNO ,A.ENAME ,A.SAL ,B.DEPTNO,B.DNAME 
FROM EMP A,DEPT B
WHERE A.DEPTNO = B.DEPTNO
AND SAL >= 3000 
AND B.DEPTNO =20;

-- 실습 5
SELECT B.LPROD_GU ,B.LPROD_NM ,A.PROD_ID,A.PROD_NAME 
FROM PROD A, LPROD B
WHERE A.PROD_LGU = B.LPROD_GU;

-- 실습 6
SELECT B.BUYER_ID , B.BUYER_NAME ,P.PROD_ID ,P.PROD_NAME 
FROM BUYER B, PROD P
WHERE B.BUYER_ID  = P.PROD_BUYER;

-- 실습 7
SELECT M.MEM_ID , M.MEM_NAME ,P.PROD_ID ,P.PROD_NAME ,C.CART_QTY 
FROM MEMBER M , CART C, PROD P
WHERE M.MEM_ID = C.CART_MEMBER 
AND C.CART_PROD = P.PROD_ID;

SELECT *  
FROM MEMBER;

SELECT *
FROM CART;
---------------
SELECT *
FROM customer;

SELECT *
FROM cycle;

SELECT *
FROM product;


--실습 8
SELECT a.cid,a.cnm ,b.pid,b.DAY,b.cnt
FROM customer a,CYCLE b
WHERE a.cid = b.cid
AND a.cid != '3';

-- 실습 9
SELECT a.cid , a.cnm ,c.pid ,c.pnm ,b.DAY, b.cnt
FROM customer a,CYCLE b, product c
WHERE a.cid = b.cid 
AND b.pid = c.pid
AND a.cid != 3;

-- 실습 10 customer a,CYCLE b, product c
SELECT a.cid , cnm ,c.pid ,pnm , gc.a "SUM(CNT)" 
FROM(SELECT cid , SUM(cnt) a, pid  
		FROM CYCLE
		GROUP BY cid ,pid
		)gc,
		customer a, product c
WHERE a.cid = gc.cid 
AND gc.pid = c.pid;

-- 실습 11 
SELECT c.pid ,pnm , gc.a "SUM(CNT)" 
FROM(SELECT SUM(cnt) a, pid  
		FROM CYCLE
		GROUP BY pid
		)gc,
		 product c
WHERE gc.pid = c.pid;

-- 실습 12
SELECT *
FROM HR-COUNTRIES;







