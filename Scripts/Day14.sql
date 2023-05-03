테이블을 조회하면 기본적으로 정렬이 안되어 있음(집합);

emp 테이블에서 empno = 7698인 데이터를 조회

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7698;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);
-- 컨트롤하고 제약조건보기 컨트롤 + 마우스
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------

ALTER TABLE EMP DROP CONSTRAINT SYS_C006997;

--제약조건 삭제 (DROP)
ALTER TABLE EMP_TEST DROP CONSTRAINT PK_EMP_TEST;

-- 제약조건 추가(ADD)
ALTER TABLE EMP ADD CONSTRAINT PK_EMP PRIMARY KEY (EMPNO);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7698;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------

emp 테이블에 PRIMARY KEY 제약조건을 생성하고 나서 변경된 점
* 오라클 입장에서 데이터를 조회할 때 사용할 수 있는 전략이 하나 더 생김
1. TABLE FULL SCAN
2. pk_emp 인덱스를 이용하여 사용자가 원하는 행을 빠르게 찾아가서 필요한 컬럼들은 인덱스에 저장된
	ROWID를 이용하여 테이블의 행으로 바로 접근

EXPLAIN PLAN FOR
SELECT EMPNO
FROM emp
WHERE empno = 7698;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);	-- 테이블에 접근하는 부분이 빠짐

----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |    13 |     0   (0)| 00:00:01 |
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |    13 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
EMPNO 컬럼의 인덱스를 UNIQUE 인덱스가 아닌 일반 인덱스(중복이 가능한)로 생성한 경우

ALTER TABLE EMP DROP CONSTRAINT PK_EMP;

NON-UNIQUE 인덱스 생성(중복 가능)
 UNIQUE 인덱스 명명규칙 - IDX_U_ 테이블명_01;
NON-UNIQUE 인덱스 명명규칙 - IDX_NU_테이블명_01;

CREATE [UNIQUE] INDEX 인덱스명 ON 테이블명 (인덱스로 구성할 컬럼);

CREATE INDEX idx_nu_emp_01 ON EMP (EMPNO);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7698;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

---------------------------------------------------------------------------------------------
| Id  | Operation                   | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |               |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP           |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_NU_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------

-------------------------------------------------------------

DCL - 데이터 제어언어 

GRANT 권한명 | 롤명 TO 사용자;

REVOKE 권한명 | 롤명 FROM 사용자; 

SELECT *
  FROM DICTIONARY;

 CATEGORY(접두어)
 USER_ ==> 해당 사용자가 소유한 객체 관련 조회
 ALL_ ==> 해당 사용자가 소유한 객체 + 권한을 부여받은 객체 조회
 DBA_ ==> 데이터베이스에 설치된 모든 객체(DBA 권한이 있는 사용자만 가능 - system)
 v$ ==> 성능, 모니터링 관련된 특수 VIEW 
 
 SELECT *
 FROM user_tables;
 
 SELECT *
 FROM ALL_tables;

SELECT *
FROM dba_tables;

------------------------------------------------------------------------

SQL 응용 - DML (SELECT, UPDATE ,INSERT, MERGE)

1. MULTIPLE INSERT ==> 많이 사용하는 편은 아님
한 번의 INSERT 구문을 통해서 여러 테이블에 데이터를 입력

실 사용 예 - 1. 실제 사용할 테이블과 별개로 보조 테이블에도 동일한 데이터 쌓기
		   2. 데이터의 수평분할(*)
		   주문 테이블
		   2022년 데이터 ==> TB_ORDER_2022
		   2023년 데이터 ==> TB_ORDER_2023
		   ==> 오라클 PARTITION 을 통해 더 효과적으로 관리 가능(정식버전에만 있음)
		   하나의 테이블안에 데이터값에 따라 저장하는 물리공간이 나뉘어져 있음
		   ==> 개발자 입장에서는 데이터를 입력하면 데이터 값에 따라 물리적인 공간을 오라클이 알아서
		   나눠서 저장
		   
MULTIPLE INSERT 종류
1. UNCONDITIONAL INSERT : 조건과 관계없이 하나의 데이터를 여러 테이블 입력
2. CONDITIONAL ALL INSERT : 조건을 만족하는 모든 테이블에 입력
3. CONDITIONAL FIRST INSERT : 조건을 만족하는 첫번째 테이블에 입력
------------------------------------------------------------

1. EMP_TEST, EMP_TEST2 테이블 삭제
2. EMP 테이블의 EMPNO 컬럼이랑 ENAME 컬럼만 갖고 EMP_TEST, EMP_TEST2 를 생성.
단, 데이터를 복사하지 않음

DROP VIEW EMP_TEST;

DROP TABLE EMP_TEST2;

CREATE OR REPLACE VIEW EMP_TEST AS 
SELECT EMPNO, ENAME
	FROM EMP;

CREATE TABLE EMP_TEST AS
SELECT EMPNO ,ENAME
FROM EMP
WHERE 1 !=1 ;

CREATE TABLE EMP_TEST2 AS
SELECT EMPNO ,ENAME
FROM EMP
WHERE 1 !=1 ;

------------------------------------------------------------
[ UNCONDITIONAL INSERT ]

SELECT 9999 EMPNO, 'BROWN' ENAME FROM DUAL
UNION ALL
SELECT 9999 EMPNO, 'SALLY' ENAME FROM DUAL;
 
--위 두개의 행을 EMP_TEST, EMP_TEST2 에 동시입력, 하나의 INSERT 구문 사용

INSERT ALL 
	INTO EMP_TEST VALUES (EMPNO,ENAME)	--
	INTO EMP_TEST2 (ENPNO)VALUES(EMPNO)
 
SELECT *
FROM EMP_TEST2;
 
-----------------------------------------

[conditional INSERT]

ROLLBACK; -- 비교가이위해 롤백

조건 분기 문법: CASE WHEN THEN END
조건 분기 함수 : DECODE

INSERT ALL 
	WHEN EMPNO >= 9999 THEN
		INTO EMP_TEST VALUES (EMPNO,ENAME)
	WHEN EMPNO >= 9998 THEN
		INTO EMP_TEST2 VALUES (EMPNO, ENAME)
	ELSE
		INTO EMP_TEST2 (EMPNO) VALUES (EMPNO)
SELECT 9999 EMPNO, 'BROWN' ENAME FROM DUAL
UNION ALL
SELECT 9998 EMPNO, 'SALLY' ENAME FROM DUAL;
 
SELECT *
FROM EMP_TEST2;
 
SELECT *
FROM EMP_TEST;
 
---------------------------------------------------------------

[CONDITIONAL FIRST INSERT ]
 
ROLLBACK;

ALL ==> 3건의 데이터가 입력됨, FIRST ==> ?

INSERT FIRST 	
	WHEN EMPNO >= 9999 THEN
		INTO EMP_TEST VALUES (EMPNO,ENAME)
	WHEN EMPNO >= 9998 THEN
		INTO EMP_TEST2 VALUES (EMPNO, ENAME)
	ELSE
		INTO EMP_TEST2 (EMPNO) VALUES (EMPNO)
SELECT 9999 EMPNO, 'BROWN' ENAME FROM DUAL
UNION ALL
SELECT 9998 EMPNO, 'SALLY' ENAME FROM DUAL
UNION ALL
SELECT 9997 EMPNO, 'MOON' ENAME FROM DUAL;

---------------------------------------------------------

MERGE 
1. 사용자로부터 받은 값을 가지고 테이블에 저장 OR 수정하고 싶은데
	입력받은 값이 테이블에 존재하면 수정을 하고 싶고,
	입력받은 값이 테이블에 존재하지 않으면 신규 입력을 하고 싶을 때

2. 테이블의 데이터를 이용하여 다른 테이블의 데이터를 업데이트 OR INSERT 하고 싶을 때
	일반 UPDATE 구문에서는 비효율이 존재
	ALLEN 의 JOB 과 DEPTNO 를 SMITH 사원과 동일하게 업데이트 하시요.
	
	UPDATE EMP SET JOB = (SELECT JOB FROM EMP WHERE ENAME = 'SMITH'),
				   DEPTNO = (SELECT DEPTNO FROM EMP WHERE ENAME = 'SMITH')
	WHERE ENAME = 'ALLEN';
	
	ex - empno 9999, ename 'brown'
	 emp 테이블에 동일한 empno 가 있으면 ename 을 업데이트 하고 싶고
	 emp 테이블에 동일한 empno 가 없으면 신규 입력
	 
	 위의 경우를 MERGE 구문을 사용하지 않는다면
	 1.1 해당 데이터가 존재하는지 확인하는 SELECT 구문을 실행
	 1.2 1번 쿼리가 조회 결과가 있으면
	  1.2.1 UPDATE
	 1.3 1번 쿼리가 조회 결과가 없으면
	  1.3.1 INSERT 
	  
1. 
SELECT *
FROM EMP 
WHERE EMPNO = 9999;

2.
UPDATE EMP 
SET ENAME = 'BROWN'
WHERE EMPNO = 9999;

3.
INSERT INTO EMP (EMPNO, ENAME) VALUES (9999, 'BROWN');

[문법]

MERGE INTO 테이블명(덮어쓰거나, 신규로 입력할 테이블) ALIAS 
USING (테이블명 | VIEW | INLINE-VIEW) ALIAS
	ON(두 테이블간 데이터 존재 여부를 확인할 조건)
WHEN MATCHED THEN 
	UPDATE SET 컬럼1 = 값1,
			   컬럼2 = 값2
WHEN NOT MATCHED THEN 
	INSERT INTO (컬럼1, 컬럼2, ....) VALUES (값1, 값2, ...);

7369 사원의 데이터를 EMP_TEST로 복사 (EMPNO ,ENAME)

INSERT INTO EMP_TEST
SELECT EMPNO, ENAME 
	FROM EMP
	WHERE EMPNO = 9999;

SELECT *
FROM EMP_TEST;

SELECT *
FROM EMP;

EMP - 16 건 , EMP_TEST 2건 (7369, 9999 ==> EMP 테이블에도 존재)
EMP 테이블을 이용하여 EMP_TEST에
동일한 EMPNO 값이 있으면 EMP_TEST.ENAME 업데이트
동일한 EMPNO 값이 없으면 EMP 테이블의 데이터를 신규 입력

MERGE INTO EMP_TEST A 
USING EMP B
	ON (A.EMPNO = B.EMPNO)	-- 조인조건 생각
WHEN MATCHED THEN 
	UPDATE SET A.ENAME = B.ENAME || '_M'
WHEN NOT MATCHED THEN 
	INSERT (A.EMPNO, A.ENAME) VALUES (B.EMPNO, B.ENAME);

*** MERGE 에서 많이 사용하는 형태 ***
사용자로부터 받은 데이터를 EMP_TEST 테이블에 동일한데이터 존재 유무에 따른 MERGE
시나리오 : 사용자 입력 EMPNO = 9999, ENAME = 'BROWN'

MERGE INTO EMP_TEST A
USING DUAL
	ON (A.EMPNO = :EMPNO)
WHEN MATCHED THEN 
	UPDATE SET ENAME = :ENAME 
WHEN NOT MATCHED THEN 
	INSERT VALUES (:EMPNO, :ENAME);


SELECT *
FROM EMP_TEST;

----------------------------------------------------------
-- 실습1
DEPT_TEST 테이블을 DEPT 테이블과 돌일하게 생성 단, 10,20번 부서 데이터만 복제
DEPT 테이블을 이용하여 DEPT_TEST 테이블에 데이터를 MERGE 
* 머지 조건 - 부서번호가 같은 데이터
동일한 부서가 있을 때 - 기존 LOC 컬럼의 값 + _M으로 업데이트
동일한 부서가 없을 때 : 신규 데이터를 입력

DROP TABLE DEPT_TEST;


SELECT *
FROM DEPT_TEST;

CREATE TABLE DEPT_TEST AS
SELECT *
FROM DEPT
WHERE DEPTNO IN(10,20);

MERGE INTO DEPT_TEST A
USING DEPT B
	ON (A.DEPTNO = B.DEPTNO)
WHEN MATCHED THEN 
	UPDATE SET A.LOC = B.LOC || '_M'
WHEN NOT MATCHED THEN 
	INSERT VALUES (B.DEPTNO, B.DNAME, B.LOC);

-- 실습2
사용자 입력받은 값을 이용한 MERGE 
사용자 입력 - DEPTNO 99, DNAME 'DW', LOC 'DAEJENON'
DEPT_TEST 테이블에 사용자가 입력한 DEPTNO 값과
동일한 데이터가 있을 경우 ==> 사용자가 입력한 DNAME, LOC 값으로 두개ㅡ 컬럼 업데이트
동일한 데이터가 없을 경우 ==> 사용자가 입력한 DEPTNO, DNAME , LOC 값으로 데이터 등록


MERGE INTO DEPT_TEST A
USING DUAL
	ON (A.DEPTNO = :DEPTNO)
WHEN MATCHED THEN 
	UPDATE SET A.DNAME = :DNAME , A.LOC = :LOC
WHEN NOT MATCHED THEN 
	INSERT VALUES (:DEPTNO,:DNAME,:LOC);


SELECT *
FROM DEPT_TEST;










































