DML-INSERT : 테이블에 데이터를 입력하는 SQL 문장;
1. 어떤 테이블에 데이터를 입혁할지 테이블을 정한다.
2. 해당 테이블의 어떤 컬럼에 어떤 값을 입력할 지 정한다.
[문법]
INSERT INTO 테이블명 (컬럼1, 컬럼2,...)
			VALUES (컬럼1값, 컬럼2값, ...);
INSERT INTO EMP (EMPNO,ENAME,JOB,MGR) VALUES (7777,'HJH','KING',7698);

DEPT 테이블에 99번 부서번호를 갖는 DW를 부서명으로 DAJEON 지역에 위치하는 부서를 등록;

INSERT INTO DEPT(DEPTNO,DNAME,LOC) VALUES(99,'DW','DAJEON'); 

컬럼명을 나열할 때 테이블 정의에 따른 컬럼 순서를 반드시 따를 필요는 없다.
다만, VALUES 절에 기술한 해당 컬럼에 입력할 값의 위치만 지키면 된다.

INSERT INTO DEPT VALUES (98,'dw2','대전');

모든 컬럼에 값을 입력하지 않을 수도 있다.
단, 해당 컬럼이 NOT NULL 제약조건이 걸려있는 경우는 반드시 값이 들어가야 한다.
컬럼에 NOT NULL 제약조건 적용 여부는 테이블의 DESCRIPTION을 통해 확인 가능

EMPNO 컬럼에는 NOT NULL 제약조건이 존재하기 때문에 반드시 값을 입력해야한다.

INSERT INTO EMP (EMPNO, ENAME,JOB)
VALUES (NULL,'BROWN', 'RANGER');

DATE 타입에 대한 INSERT 
EMP 테이블에 SALLY 사원을 오늘 날짜로 입사 할 때
신규 데이터 입력, JOB = RANGER, EMPNO = 9998

INSERT INTO EMP (EMPNO ,ENAME ,JOB ,HIREDATE)
		  VALUES(9998,'SALLY', 'RANGER', SYSDATE);

INSERT INTO EMP (EMPNO ,ENAME ,JOB ,HIREDATE)
		  VALUES(9997,'MOON', 'RANGER', TO_DATE('2023-04-21','YYYY-MM-DD'));

위에서 실행한 INSERT 구문들이 모두 취소;
ROLLBACK;

SELECT 쿼리 결과를 테이블에 입력
SELECT 쿼리 결과는 여러건의 행이 될 수도 있다.
여러건의 데이터를 하나의 INSERT 구문을 통해서 입력할 수 있다.
[문법]
INSERT INTO 테이블명 (컬럼1, 컬럼2, ...)
SELECT 컬럼1, 컬럼2, ...
FROM ...;

INSERT INTO EMP (HIREDATE, JOB, EMPNO, ENAME)
SELECT SYSDATE, 'RANGER', 9998,NULL
FROM DUAL
UNION
SELECT TO_DATE('2023-04-21','YYYY-MM-DD'), 'RANGER',9997, 'MOON'
FROM DUAL;


UPDATE : 테이블에 존재하는 데이터를 수정하는 것
1. 어떤 테이블을 업데이트 할 건지?
2. 어떤 컬럼을 어떤 값으로 업데이트 할건지
3. 어떤 행에 대해서 업데이트 할 건지(SELECT 쿼리의 WHERE 절과 동일)
[문법]
UPDATE 테이블명 SET 컬럼명1 = 변경할 값1,
				  컬럼명2 = 변경할 값2,...
WHERE 변경할 행을 제한(선택)할 조건;

DEPTNO가 90, DNAME DW, LOC가 선화동인 데이터를 DEPT 테이블에 입력하는 쿼리 작성;

INSERT INTO DEPT(DEPTNO,DNAME,LOC) VALUES (90,'DW','선화동');

UPDATE DEPT SET DNAME = 'DW아카데미',
				  LOC = 'daejeon' 
WHERE DEPTNO = '90';

업데이트 쿼리를 작성할 때 주의점
1. WHERE 절이 있는지 없는지 확인!!
   WHERE 절이 없다는건 모든 행에 대해서 업데이트를 행한다는 의미
   
2. UPDATE 하기전에 기술한 WHERE 절을 SELECT 절에 적용하여 업데이트 대상 데이터를 눈으로 확인하고 실행

SELECT *
FROM DEPT
WHERE DEPTNO = 90;

UPDATE - 상수값으로 업데이트 ==> 서브쿼리 사용가능;
9999번 사원번호를 갖는 사원의 deptno와 job 컬럼의 값을 smith 사원의 deptno와 job 값으로 업데이트;

UPDATE EMP SET  DEPTNO =(SELECT DEPTNO  
						 FROM EMP 					
					 	 WHERE ENAME ='SMITH'), 
				   JOB =(SELECT JOB 
						 FROM EMP
					     WHERE ENAME ='SMITH')
WHERE EMPNO = 9999;

==> UPDATE 쿼리1 실행할 때 안쪽 SELECT 쿼리가 2개가 포함됨 ==> 비효율적
	고정된 값을 업데이트 하는게 아니라 다른 테이블에 있는 값을 통해서 업데이트 할 때 비효율이 존재
	==> MERGE 구문을 통해 보다 효율적으로 업데이트가 가능

DELETE - 테이블의 행을 삭제할 때 사용하는 SQL
		 특정 컬럼만 삭제하는 거는 UPDATE 
		 DELETE 구문은 행 자체를 삭제
1. 어떤 테이블에서 삭제할지
2. 테이블의 어떤 행을 삭제할지
[문법]
DELETE [FROM] 테이블명 
WHERE 삭제할 행을 선택하는 조건; 

UPDATE 쿼리 실습시 업데이트 해줬던 9999번 사원을 삭제하는 쿼리를 작성하세요.

DELETE FROM EMP 
WHERE EMPNO = 9999;
	
DELETE 쿼리도 SELECT 쿼리 작성시 사용한 WHERE 절과 동일하게 서브쿼리 사용 가능

사원중에 mgr이 7698인 사원들만 삭제;

DELETE FROM EMP WHERE mgr = 7698;

ROLLBACK;

SELECT *
FROM EMP;

DBMS의 경우 데이터 복구를 위해서
DML 구문을 실행할 때마다 로그를 생성
대량의 데이터를 지울 때는 로그 기록도 부하가 되기 때문에
개발환경에서는 테이블의 모든 데이터를 지우는 경우에 한해서
TRUNCATE TABLE 테이블명; 명령을 통해 로그를 남기지 않고 빠르게 삭제가 가능하다.
단, 로그가 없기 때문에 복구 불가능하다.

SELECT *
FROM EMP;

DELETE EMP WHERE EMPNO = 7777;
DELETE EMP WHERE EMPNO = 9999;

SELECT *
FROM DEPT;

DELETE FROM DEPT WHERE DEPTNO = 99;

DML(DATA Manipulation[조작] Language) - 데이터를 다루는 SQL
SELECT, INSERT, UPDATE, DELETE

DDL(DATA Definition[정의] Language) - 데이터를 정의하는 SQL
DDL은 자동 커밋, ROLLBACK 불가
ex) 테이블 생성 DDL 실행 ==> 롤백이 불가
	==> 테이블 삭제 DDL 실행 
	
CREATE TABLE EMP_COPY AS 
SELECT *
FROM EMP;

SELECT *
FROM EMP_COPY;

테이블 삭제
[문법]
DROP 객체종류 객체이름;
DROP TABLE EMP_COPY;

DML 문과 DDL문을 혼합해서 사용 할 경우 발생할 수 있는 문제점
==> 의도와 다르게 DML문에 대해서 COMMIT이 될 수 있다.

SELECT *
FROM EMP;
14

INSERT INTO EMP (EMPNO, ENAME) VALUES (9999, 'brown');
15

SELECT COUNT(*)
FROM EMP;
15

DROP TABLE BATCH;

ROLLBACK;

테이블 생성
[문법]
CREATE TABLE 테이블명 (
	컬럼명1 컬럼1타입,
	컬럼명2 컬럼2타입,
	컬럼명3 컬럼3타입,
	컬럼명4 컬럼4타입,
	컬럼명5 컬럼5타입 DEFAULT 기본값
);

ranger 라는 이름의 테이블 생성

CREATE TABLE RANGER (
	RANGER_NO NUMBER,
	RANGER_NM VARCHAR2(50),
	REG_DT DATE DEFAULT SYSDATE
);

SELECT *
FROM RANGER;

INSERT INTO RANGER (RANGER_NO, RANGER_NM) VALUES (100, '김상재');

--[ 데이터 무결성 - 잘못된 데이터가 들어가는 것을 방지하려는 성격]
EX) 1. 사원 테이블에 중복된 사원번호가 등록되는 것을 방지
	2. 반드시 입력이 되어야 되는 컬럼의 값을 확인
	
-- [ 오라클에서 제공하는 데이터 무결성을 지키기 위해 제공하는 제약조건 5가지]
1. NOT NULL 
	해당 컬럼에 값이 NULL 이 들어오는 것을 제약, 방지
	(EX. EMP 테이블의 EMPNO 컬럼)

2. UNIQUE 
	전체 행중에 해당 컬럼의 값이 중복이 되면 안된다.
	(EX. EMP 테이블에서 EMPNO 컬럼이 중복이되면 안된다.)
	단, NULL 에 대한 중복은 허용한다.

3. PRIMARY KEY = UNIQUE + NOT NULL (다른 행에 동일한 값이 나오면 안된다)

4. FOREIGN KEY 
	연관된 테이블에 해당 데이터가 존재해야하만 입력이 가능
	emp 테이블과 dept 테이블은 deptno 컬럼으로 연결이 되어 있음.
	emp 테이블에 데이터를 입력할 때 dept 테이블에 존재하지 않는 deptno 값을 입력하는 것을 방지
	
5. CHECK 제약 조건(NOT NULL 은 여기에 들어갈 수 있음)	
	컬럼에 들어오는 값을 정해진 로직에 따라 제어
	EX) 어떤 테이블에 성별 컬럼이 존재하면
	남성 = M, 여성 = F
	시스템에는 M, F 두 가지 값만 저장될 수 있도록 제어
	C 성별을 입력하면 ?? 시스템 요구사항을 정의할 때 정의하지 않은 값이기 때문에 추후 문제가 될 수 있다.
	
-- [ 제약조건 생성 방법]
1. 테이블 생성시 컬럼 옆에 기술하는 경우
	* 상대적으로 세세하게 제어하는것은 불가
2. 테이블 생성시 모든 컬럼을 기술하고 나서 
	제약조건만 별도로 기술 ==> 1번 방법보다 세세하게 제어하는게 가능
3. 테이블 생성 이후, 객체 수정 명령을 통해 제약조건을 추가

1번 방법으로 PRIMARY KEY 생성

--DEPT 테이블과 동일한 컬럼명, 타입으로 DEPT_TEST 라는 테이블 이름으로 생성

CREATE TABLE DEPT_TEST (
		DEPTNO NUMBER(2,0) PRIMARY KEY,
		DNAME VARCHAR2(14),
		LOC VARCHAR2(13)
		 );
	

	
SELECT *
FROM DEPT_TEST;
	
1. NULL 값 입력 테스트
PRIMARY KEY 제약조건에 의해 DEPTNO 컬럼에는 NULL 값이 들어갈 수 없다.

INSERT INTO DEPT_TEST VALUES(NULL,'DW','DAEJEON');
	
2. 값 중복 테스트
INSERT INTO DEPT_TEST VALUES (99, 'DW', 'DAEJEON');

INSERT INTO DEPT_TEST VALUES (99, 'DW2', '대전');
첫번째 INSERT 구문에 의해 99번 부서는 DEPT_TEST 테이블에 존재
DEPTNO 컬럼의 값이 99번인 데이터가 이미 존재하기 때문에 중복데이터로 입력이 불가능

-- [ 테이블 생성시 제약조건 명을 설정한 경우 ]
DROP TABLE DEPT_TEST;	

컬럼명 컬럼타입 CONSTRAINT 제약조건이름 제약조건타입

CREATE TABLE DEPT_TEST (
		DEPTNO NUMBER(2,0) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
		DNAME VARCHAR2(14),
		LOC VARCHAR2(13)
);
	
INSERT INTO DEPT_TEST VALUES (99, 'DW', 'DAEJEON');
INSERT INTO DEPT_TEST VALUES (99, 'DW2', '대전');
	
2번 방법으로 제약조건 생성 - 테이블 생성시 컬럼 기술 이후 별도로 제약조건을 기술하는 방법
					- DEPT_TEST 테이블의 DEPTNO 컬럼을 대상으로 PRIMARY KEY 제약 조건생성
	
DROP TABLE DEPT_TEST;	

CREATE TABLE DEPT_TEST (
		DEPTNO NUMBER(2,0),
		DNAME VARCHAR2(14),
		LOC VARCHAR2(13),	
		CONSTRAINT UK_DEPT_TEST_DNAME UNIQUE (DNAME,LOC)
);

/*  제약조건은 양쪽이 똑같아야한다.
 * DW, DAEJEON 
 * DW, DAEJEON
 * 
 * DW, DAEJEON
 * DW, 대전
 */	

INSERT INTO DEPT_TEST VALUES (99, 'DW', 'DAEJEON');
INSERT INTO DEPT_TEST VALUES (99, 'DW', '대전');

SELECT *
FROM DEPT_TEST;
	
[ FOREIGN KEY - 참조키]

한 테이블의 컬럼의 값이 참조하는 테이블의 컬럼 값중에 존재하는 값만 입력되도록 제어하는 제약조건
즉 FOREIGN KEY 경우 두개의 테이블간의 제약조건

DROP TABLE DEPT_TEST;	

CREATE TABLE DEPT_TEST (
		DEPTNO NUMBER(2,0),
		DNAME VARCHAR2(14),
		LOC VARCHAR2(13),	
		CONSTRAINT PK_DEPT_TEST_DNAME PRIMARY KEY (DEPTNO)
);

테스트 데이터 준비;
INSERT INTO DEPT_TEST VALUES (1, 'DW', 'DAEJEON');
	
DEPT_TEST 테이블의 DEPTNO 컬럼을 참조하는 EMP_TEST 테이블 생성

DROP TABLE EMP_TEST;

CREATE TABLE EMP_TEST (
	EMPNO NUMBER(4),
	ENAME VARCHAR2(10),
	DEPTNO NUMBER(2) REFERENCES DEPT_TEST (DEPTNO) 
);
	
1. DEPT_TEST 테이블에는 부서번호가 1번인 부서가 존재
2. EMP_TEST 테이블의 DEPTNO 컬럼으로 DEPT_TEST.DEPTNO 컬럼을 참조
	==> EMP_TEST 테이블의 DEPTNO 컬럼에는 DEPT_TEST.DEPTNO컬럼에 존재하는 값만 입력하는 것이 가능

SELECT *
FROM DEPT_TEST;

DEPT_TEST 테이블에 존재하는 부서번호로 EMP_TEST 테이블에 입력하는 경우;
INSERT INTO EMP_TEST VALUES (9999, '김상재' , 1);

DEPT_TEST 테이블에 존재하는 부서번호로 EMP_TEST 테이블에 입력하는 경우;
INSERT INTO EMP_TEST VALUES (9998, 'SALLY' , 2);


SELECT *
FROM EMP_TEST;

COMMIT;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	















