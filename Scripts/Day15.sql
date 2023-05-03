[ GROUP FUNCTION 응용, 확장 ]

SELECT DEPTNO, SUM(SAL)
FROM EMP
GROUP BY DEPTNO 
UNION
SELECT NULL, SUM(SAL)
FROM EMP
ORDER BY DEPTNO DESC NULLS LAST;


ROLLUP - 1. GROUP BY 의 확장 구문
		 2. 정해진 규칙으로 서브 그룹을 생성하고 생성된 서브 그룹을 하나의 집합으로 반환
		 3. GROUP BY ROLLUP(COL1,COL2, ...)
		 4. ROLLUP 절에 기술된 컬럼을 오른쪽에서부터 하나씩 제거해 가며 서브그룹을 생성
		 	ROLLUP의 경우 방향성이 있기 때문에 컬럼 기술 순서가 다르면 다른 결과가 나온다.
		 
예시 - GROUP BY ROLLUP (DEPTNO)
1. GROUP BY deptno ==> 부서번호별 총계
2. GROUP BY ''	==> 전체 총계

예시 - GROUP BY ROLLUP ( JOB, DEPTNO)
1. GROUP BY JOB, DEPTNO ==> 담당업무, 부서번호별 총계
2. GROUP BY JOB ==> 담당업무별 총계
3. GROUP BY ''	==> 전체 총계
		 	
SELECT 
	job ,DEPTNO, SUM(SAL + NVL(COMM,0)) SAL
	FROM EMP 
	GROUP BY ROLLUP (job, DEPTNO);
--	HAVING DEPTNO IS NOT NULL;
	
* ROLLUP 절에 N개의 컬럼을 기술 했을 때 SUBGROUP 의 개수는 N + 1 개의 서브 그룹이 생성

GROUPING 함수
GROUPING(column) 

job 컬럼이 소계 계산으로 사용되어 NULL 값이 나온 것인지, 정말 컬럼의 값이 null인 행들이
GROUP BY 된 것인지 알려면 GROUPING 함수를 사용해야 정확한 값을 할 수 있다.

SELECT nvl(job,'총계'), deptno, sum(sal + NVL(COMM,0)) SAL, GROUPING (JOB)
,GROUPING (DEPTNO)
	FROM EMP
	GROUP BY ROLLUP (JOB,DEPTNO);

GROUPING(COLUMN) - 0,1;
0 - 컬럼이 소계 계산에 사용 되지 않았다. (GROUP BY 컬럼으로 사용됨)
1 - 컬럼이 소계 게산에 사용 되었다.
			-- 조건 , 결과 , ELSE

SELECT DECODE(GROUPING(JOB),1, '총계', JOB) JOB, DECODE(GROUPING(DEPTNO),1,'소계',DEPTNO)DEPTNO, GROUPING(JOB),
GROUPING(DEPTNO), SUM(SAL + NVL(COMM,0)) SAL
FROM EMP 
GROUP BY ROLLUP (JOB,DEPTNO);


-- 실습 1
SELECT DECODE(GROUPING(JOB),1, '총', JOB) JOB, DECODE(GROUPING(JOB) + GROUPING(DEPTNO),1,'소계',2,'계',DEPTNO)DEPTNO,
GROUPING(JOB),GROUPING(DEPTNO), SUM(SAL + NVL(COMM,0)) SAL
FROM EMP 
GROUP BY ROLLUP (JOB,DEPTNO);

SELECT CASE 
	WHEN GROUPING(JOB) = 1 THEN '총'
	WHEN GROUPING(JOB) = 0 THEN job
END JOB,
CASE
	WHEN GROUPING(JOB) = 1 AND GROUPING(DEPTNO) = 1 THEN '계'
	WHEN GROUPING(JOB) = 0 AND GROUPING(DEPTNO) = 1 THEN '소계'
	WHEN GROUPING(JOB) = 0 AND GROUPING(DEPTNO) = 0 THEN TO_CHAR(DEPTNO)
END DEPTNO,
	GROUPING(JOB),GROUPING(DEPTNO), SUM(SAL + NVL(COMM,0)) SAL
FROM EMP 
GROUP BY ROLLUP(JOB,DEPTNO);

-- 실습 2
SELECT DEPTNO, JOB 
,SUM(SAL + NVL(COMM,0)) SAL
FROM EMP 
GROUP BY ROLLUP (DEPTNO ,JOB);

-- 실습 3

SELECT D.DNAME ,E.JOB,SUM(E.SAL + NVL(COMM,0)) SAL
FROM DEPT D ,EMP E
WHERE D.DEPTNO = E.DEPTNO
GROUP BY ROLLUP(D.DNAME, E.JOB)
ORDER BY D.DNAME ,E.JOB DESC;


SELECT *
FROM EMP;

SELECT *
FROM DEPT;

DELETE FROM DEPT WHERE DEPTNO =99;

UPDATE EMP SET JOB = 'SALESMAN'
WHERE ENAME = 'ALLEN' AND JOB = 'CLERK';

----------------------------------------------------------

확장된 GROUP BY
1. ROLLUP - 컬럼 기술에 방향성이 존재
	GROUP BY ROLLUP (JOB, DEPTNO) != GROUP BY ROLLUP (DEPTNO, JOB)
	GROUP BY JOB,DEPTNO				 GROUP BY DEPTNO, JOB
	GROUP BY JOB 					 GROUP BY DEPTNO
	GROUP BY ''						 GROUP BY ''
	단점 - 개발자가 필요가 없는 서브그룹을 임의로 제거할 수 없다.

2. GROUPING SETS - 필요한 서브그룹을 임의로 지정하는 형태
	==> 복수의 GROUP BY 를 하나도 합쳐서 결과를 돌려주는 형태
	GROUP BY GROUPING SETS (COL1, COL2)
	
	GROUP BY COL1
	UNION ALL 
	GROUP BY COL2
	
	GROUP BY GROUPING SETS (COL2, COL1)
	
	GROUP BY COL2
	UNION ALL 
	GROUP BY COL1
	
	GROUPING SETS 의 경우 ROLLUP 과는 다르게 컬럼 나열순서가 데이터 자체에 영향을 미치지 않는다.
	
	복수 컬럼으로 GROUP BY 
	GROUP BY COL1, COL2
	UNION ALL 
	GROUP BY COL1
	==> GROUPING SETS ((COL1, COL2), COL1)
	
GROUPING SETS 실습

SELECT JOB ,DEPTNO , SUM(SAL + NVL(COMM,0)) SAL
FROM EMP
GROUP BY GROUPING SETS( JOB, DEPTNO);

위 쿼리를 UNION ALL 로 풀어 쓰기
SELECT JOB, NULL, SUM(SAL + NVL(COMM,0)) SAL
FROM EMP
GROUP BY JOB

UNION ALL

SELECT NULL,DEPTNO, SUM(SAL + NVL(COMM,0)) SAL
FROM EMP
GROUP BY DEPTNO;

-------------------------------------------

3. CUBE
GROUP BY 절을 확장한 구문
CUBE 절에 나열한 모든 가능한 조합으로 서브그룹을 생성
GROUP BY CUBE (JOB, DEPTNO)

GROUP BY JOB, DEPTNO
GROUP BY JOB
GROUP BY 	  DEPTNO
GROUP BY '소계'

SELECT JOB,DEPTNO,GROUPING(JOB),GROUPING(DEPTNO), SUM(SAL + NVL(COMM,0)) SAL
FROM EMP
GROUP BY CUBE (JOB,DEPTNO);


GROUP BY ROLLUP (JOB, DEPTNO,MGR)
GROUP BY CUBE (JOB, DEPTNO,MGR)

CUBE 의 경우 기술한 컬럼으로 모든 가능한 조합으로 서브그룹을 생성한다.
가능한 서브그룹은 2^기술한 컬럼개수
기술한 컬럼이 3개만 넘어도 생성되는  서브그룹의 개수가 8개가 넘기 때문에 실제 필요하지 않은 서브그룹이
포함될 가능성이  높다 ==> ROLLUP, GROUPING SETS 보다 활용성이 떨어진다.














