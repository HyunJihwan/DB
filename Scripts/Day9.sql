조인 성공 여부로 데이터 조회를 결정한느 구분 방법
INNER JOIN : 조인에 성공하는 데이터만 조회하는 조인 방법
OUTER JOIN : 조인에 실패하더라도, 개발자가 지정한 기준이 되는 테이블의 데이터는 나오도록 하는 조인

복습 - 사원의 관리자 이름을 알고싶은 상황
	- 조회 컬럼: 사원의 사번, 사원의 이름, 사원의 관리자의 사번, 사원의 관리자의 이름

동일한 테이블끼리 조인되었기 때문에 : SELF-JOIN
조인 조건을 만족하는 데이터만 조회되었기 때문에 : INNER-JOIN

SELECT E.EMPNO, E.ENAME ,E.MGR ,M.ENAME  
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO;

KING의 경우 PRESIDENT 이기 때문에 MGR 컬럼의 값이 NULL ==> 조인에 실패
	==> KING의 데이터는 조회되지 않음(총 15건 데이터 중 13건의 데이터만 조인 성공)
	
OUTER 조인을 이용하여 조인 테이블 중 기준이 되는 테이블을 선택하면
조인에 실패하더라도 기준 테이블의 데이터는 조회 되도록 할 수 있다.

ANSI-SQL 버전
테이블1 JOIN 테이블2 ON(.........)
테이블1 LEFT OUTER JOIN 테이블2 ON(..........)
위 쿼리는 
테이블2 RIGHT OUTER JOIN 테이블1 ON(...........)
과 같다.
 매핑이 안된애들은 NULL 로나옴
 
SELECT E.EMPNO, E.ENAME ,M.EMPNO, E.ENAME 
FROM EMP E LEFT OUTER JOIN EMP M ON (E.MGR = M.EMPNO);

-- 부하직원이 없는 m도 표시
--SELECT E.EMPNO, E.ENAME ,M.EMPNO, E.ENAME 
--FROM EMP E RIGHT OUTER JOIN EMP M ON (E.MGR = M.EMPNO);

INNER JOIN : 조인 조건을 만족하는 (조인에 성공하는) 데이터만 조회
OUTER JOIN : 조인 조건을 만족하지 않더라도 (조인에 실패하더라도) 기준이 되는 테이블 쪽의 데이터(컬럼)은 조회가 
			되도록 하는 조인 방식

OUTER JOIN :
	LEFT OUTER JOIN : 조인 키워드의 왼쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
	RIGHT OUTER JOIN : 조인 키워드의 오른쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
	FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복되는것 제외
	
ORACLE-SQL
SELECT 데이터가 없는데 나와야하는 테이블의 컬럼
FROM 테이블1, 테이블2
WHERE 테이블1.컬럼 = 테이블2.컬럼(+);

SELECT E.EMPNO ,E.ENAME ,M.EMPNO ,M.ENAME 
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO(+);	-- 기준이 EMP E 이므로 조회했을 때 안나오는 즉, NULL로 채워지는 EMP M쪽에
							-- (+)를 붙여야한다.

OUTER JOIN 시 조인 조건(ON 절에 기술)과 일반 조건(WHERE 절에 기술)적용시 주의 사항
	: OUTER JOIN 을 사용하는데 WHERE 절에 별도의 다른 조건을 기술할 경우 원하는 결과가 안나올 수 있음
	==> OUTER JOIN 의 결과가 무시
	
SELECT E.EMPNO, E.ENAME,E.DEPTNO , M.EMPNO, M.ENAME,M.DEPTNO 
FROM EMP E LEFT OUTER JOIN EMP M ON(E.MGR = M.EMPNO AND M.DEPTNO =10); 
==> DEPTNO = 10 이 아닌 사람들의 데이터는 나오지 않는다.

SELECT E.EMPNO ,E.ENAME, E.DEPTNO, M.EMPNO ,M.ENAME ,M.DEPTNO 
FROM EMP E, EMP M
WHERE E.MGR = M.EMPNO(+) 
AND M.DEPTNO(+) = 10;

조인 조건을 WHERE 절로 변경한 경우
ANSI-SQL;
SELECT E.EMPNO,E.ENAME,M.EMPNO,M.ENAME
FROM EMP E LEFT OUTER JOIN EMP M ON(E.MGR = M.EMPNO) 
WHERE M.DEPTNO = 10;

ORACLE-SQL;
SELECT E.EMPNO,E.ENAME,M.EMPNO,M.ENAME
FROM EMP E,EMP M
WHERE E.MGR = M.EMPNO
AND M.DEPTNO = 10;

RIGTH OUTER JOIN : 기준 테이블이 오른쪽
;
SELECT E.EMPNO, E.ENAME, M.EMPNO, M.ENAME
FROM EMP E RIGHT OUTER JOIN EMP M ON(E.MGR = M.EMPNO);

LEFT OUTER 15 
RIGHT OUTER 22

FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복이 제거됨;
SELECT E.EMPNO, E.ENAME, M.EMPNO, M.ENAME
FROM EMP E FULL OUTER JOIN EMP M ON(E.MGR = M.EMPNO);

ORACLE-SQL FULL OUTER;
SELECT E.EMPNO, E.ENAME, M.EMPNO, M.ENAME
FROM EMP E, EMP M
WHERE E.MGR(+) = M.EMPNO(+);	-- 오라클 SQL은 FULL OUTER 문법을 제공하지 않음

FULL OUTER 검증;
SELECT E.EMPNO,E.ENAME, M.EMPNO, M.ENAME
	FROM EMP E LEFT JOIN EMP M ON(E.MGR = M.EMPNO)
UNION
SELECT E.EMPNO,E.ENAME, M.EMPNO, M.ENAME
	FROM EMP E RIGHT JOIN EMP M ON(E.MGR = M.EMPNO)
MINUS
SELECT E.EMPNO,E.ENAME, M.EMPNO, M.ENAME
	FROM EMP E FULL JOIN EMP M ON(E.MGR = M.EMPNO)
;

SELECT E.EMPNO,E.ENAME, M.EMPNO, M.ENAME
	FROM EMP E LEFT JOIN EMP M ON(E.MGR = M.EMPNO)
UNION 
SELECT E.EMPNO,E.ENAME, M.EMPNO, M.ENAME
	FROM EMP E RIGHT JOIN EMP M ON(E.MGR = M.EMPNO)
INTERSECT 
SELECT E.EMPNO,E.ENAME, M.EMPNO, M.ENAME
	FROM EMP E FULL JOIN EMP M ON(E.MGR = M.EMPNO)
;




