참조되고 있는 부모쪽 데이터를 삭제하는 경우
dept_test 테이블에 1번 부서가 존재하고
emp_test 테이블의 brown 사원이 1번 부서에 속한 상태에서
dept_test 테이블의 1번 부서를 삭제하는 경우
FK의 기본 설정에서는 참조하는 데이터가 없어질 수 없기 때문에 에러가 발생한다.

DELETE FROM DEPT_TEST WHERE DEPTNO = 1;
DELETE EMP_TEST WHERE DEPTNO = 1;
ROLLBACK;


FK 생성시 옵션
0. DEFAULT - 무결성이 위배되는 경우 에러
1. ON DELETE CASCADE - 부모 데이터를 삭제할 경우 참조하는 자식 데이터를 같이삭제
	(Dept_test 테이블의 1번 부서를 삭제하면 1번 부서에 소속된 brown 사원도 삭제)
2. ON DELETE SET NULL - 부모 데이터를 삭제할 경우 참조하는 자식 데이터의 컬럼을 NULL로 수정

DROP TABLE EMP_TEST;

CREATE TABLE EMP_TEST(
	EMPNO NUMBER(4),
	ENAME VARCHAR2(10),
	DEPTNO NUMBER(2),
	CONSTRAINT FK_EMP_TEST_DEPT_TEST FOREIGN KEY (DEPTNO)
							REFERENCES DEPT_TEST (DEPTNO) 
							ON DELETE CASCADE				

		);
	
INSERT INTO EMP_TEST VALUES (9999,'BROWN',1);

--부모 데이터 삭제;
DELETE DEPT_TEST WHERE DEPTNO = 1;

-- SET NULL 옵션 확인

DROP TABLE EMP_TEST;

CREATE TABLE EMP_TEST(
	EMPNO NUMBER(4),
	ENAME VARCHAR2(10),
	DEPTNO NUMBER(2),
	CONSTRAINT FK_EMP_TEST_DEPT_TEST FOREIGN KEY (DEPTNO)
							REFERENCES DEPT_TEST (DEPTNO) 
							ON DELETE SET NULL				
		);
	
INSERT INTO DEPT_TEST VALUES (1, 'DW', 'DAEJEON');
INSERT INTO EMP_TEST VALUES (9999,'BROWN',1);

--부모 데이터 삭제;
DELETE DEPT_TEST WHERE DEPTNO = 1;

[ CHECK 제약조건 - 컬럼에 입력되는 값을 검증하는 제약 조건 ]
	(ex - salary 컬럼(급여)이 음수가 입력되는 것은 부자연스러움
		  성별 컬럼에 남, 여가 아닌 값들이 들어오는 것은 데이터가 잘못된 것
		  직원 구분이 정직원, 계약직 2개가 존재할 때 다른 값이 들어오면 논리적으로 어긋남 )

DROP TABLE EMP_TEST;

CREATE TABLE EMP_TEST(
	EMPNO NUMBER(4),
	ENAME VARCHAR2(10),
--	SAL NUMBER(7, 2) CHECK (SAL > 0)
	SAL NUMBER(7, 2) CONSTRAINT SAL_NO_ZERO CHECK (SAL > 0)
	);
		  
INSERT INTO EMP_TEST VALUES (9999,'BROWN',-500);

테이블 생성 + [제약조건 포함] - CTAS

CREATE TABLE 테이블명 AS 
SELECT ...

--CTAS 명령을 이용하여 EMP 테이블의 모든 데이터를 바탕으로 EMP_TEST 테이블 생성
DROP TABLE EMP_TEST;

CREATE TABLE EMP_TEST AS 
SELECT *
FROM EMP;

SELECT *
FROM dept_test;

SELECT *
FROM EMP_TEST;

--테이블 컬럼 구조만 복사하고 싶을 때 WHERE 절에 항상 FALSE 가 되는 조건을 기술하여 생성 가능
CREATE TABLE EMP_TEST2 AS
SELECT *
FROM EMP
WHERE 1 !=1 ;

SELECT *
FROM EMP_TEST2;

생성된 테이블 변경 
컬럼에 작업
1. 존재하지 않았던 새로운 컬럼을 추가
	** 테이블의 컬럼 기술순서를 제어하는건 불가
	** 신규로 추가하는 컬럼의 경우 컬럼순서가 항상 테이블의 마지막
	** 설계를 할 때 컬럼순서에 충분히 고려, 누락된 컬럼이 없는지도 고려
2. 존재하는 컬럼 삭제
	** 제약조건(FK) 주의
3. 존재하는 컬럼 변경
	* 컬럼명 변경 ==> FK와 관계 없이 알아서 적용해줌
	* 그 외적인 부분에서는 사실상 불가능 하다고 생각하면 편함
		(데이터가 이미 들어가 있는 테이블의 경우)
		1. 컬럼 사이즈 변경
		2. 컬럼 타입 변경
	==> 설계시 충분한 고려

제약 조건 작업
1. 제약조건 추가 
2. 제약조건 삭제
3. 제약조건 비활성화 / 활성화

DROP TABLE EMP_TEST;
	
CREATE TABLE EMP_TEST(
	EMPNO NUMBER(4),
	ENAME VARCHAR2(10),
	DEPTNO NUMBER(2)
);

테이블 수정

ALTER TABLE 테이블명 ....

--1. 신규 컬럼 추가
ALTER TABLE EMP_TEST ADD (hp VARCHAR2(11));  

2. 컬럼 수정 (MODIFY)
	** 데이터가 존재하지 않을 때는 비교적 자유롭게 수정 가능

ALTER TABLE EMP_TEST MODIFY (HP VARCHAR(5));
ALTER TABLE EMP_TEST MODIFY (HP NUMBER);

--3. 컬럼 기본값 설정
ALTER TABLE EMP_TEST MODIFY (HP DEFAULT 123);
INSERT INTO EMP_TEST (EMPNO, ENAME, DEPTNO) VALUES (9999, 'BROWN', NULL);

SELECT *
FROM EMP_TEST;

DELETE FROM DEPT_TEST WHERE EMPNO = 9999;

ROLLBACK;

4. 컬럼 명칭 변경 (RENAME COLUMN 현재컬럼명 TO 변경할 컬럼명)

ALTER TABLE EMP_TEST RENAME COLUMN HP TO CELL;

SELECT *
FROM EMP_TEST;


5.컬럼 삭제 (DROP, DROP COLUMN)

ALTER TABLE EMP_TEST DROP (CELL);
ALTER TABLE EMP_TEST DROP COLUMN CELL;

6. 제약조건 추가, 삭제 (ADD, DROP)

ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 제약조건타입 대상컬럼;

테이블 수정을 통해서 EMP_TEST 테이블의 EMPNO 컬럼에 PRIMARY KEY 제약조건 추가

ALTER TABLE EMP_TEST ADD CONSTRAINT pk_emp_test PRIMARY KEY (EMPNO); 

--제약조건 삭제 (DROP)
ALTER TABLE EMP_TEST DROP CONSTRAINT PK_EMP_TEST;

7. 제약 조건을 활성화 / 비활성화 (ENABLE / DISABLE)

ALTER TABLE EMP_TEST DISABLE CONSTRAINT PK_EMP_TEST;

PK_EMP_TEST 가 비활성화 되었기 때문에 EMPNO컬럼에 중복되는 값 입력이 가능

INSERT INTO EMP_TEST VALUES (9999, 'SALLY', NULL);
INSERT INTO EMP_TEST VALUES (9999, 'BROWN', NULL);

SELECT *
FROM EMP_TEST;

SELECT *
FROM USER_TABLES;

SELECT *
FROM USER_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'P';

SELECT *
FROM USER_CONS_COLUMNS
WHERE TABLE_NAME = 'CYCLE'
AND CONSTRAINT_NAME = 'PK_CYCLE';

SELECT *
FROM USER_TAB_COMMENTS;

SELECT *
FROM USER_COL_COMMENTS;

테이블, 컬럼 주석 달기

COMMENT ON TABLE 테이블명 IS '주석';
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';

EMP_TEST 테이블, 컬럼에 주석;

COMMENT ON TABLE EMP_TEST IS '사원_복제';
COMMENT ON COLUMN EMP_TEST.EMPNO IS '사번';
COMMENT ON COLUMN EMP_TEST.ENAME  IS '사원이름';
COMMENT ON COLUMN EMP_TEST.DEPTNO  IS '소속부서번호';

SELECT *
FROM USER_TAB_COMMENTS;

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'EMP_TEST';

DDL
오라클 객체
1. TABLE : 데이터를 저장할 수 있는 공간
	제약조건 
	NOT NULL, UNIQUE, PRIMARY KEY , FOREIGN KEY CHECK
	
2. VIEW : SQL ==> 실제 데이터가 존재하는 것이 아님 
				논리적인 데이터 집합의 정의 가상 테이블
	* VIEW TABLE ==> 잘못된 표현
-----------------------------------------------------------

VIEW 생성 문법
CREATE TABLE 
CREATE INDEX
CREATE [OR REPLACE] VIEW 뷰이름 [COLUMN1, COLUMN2, ...] AS 
SELECT 쿼리;

EMP 테이블에서 급여정보인 SAL, COMM 컬럼을 제외하고 나머지 6개 컬럼만 조회할 수 있는 SELECT 쿼리를
V_EMP 이름의 VIEW로 생성

CREATE OR REPLACE VIEW V_EMP AS 
SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO
	FROM EMP; -- 에러. VIEW를 만들 수 있는 권한이 있어야 한다.

-----------------------------------------------------------
dron4gi 계정에게 VIEW 를 생성할 수 있는 권한 부여
GRANT CREATE VIEW TO DRON4GI;	-- SYSTEM 계정에서 실행 해야함.
								-- 권한 부여 후 위 쿼리를 다시 실행하면 VIEW 를 생성할 수 있다.

--오라클 VIEW 객체를 생성하여 조회

SELECT *
FROM V_EMP;

--IN-LINE VIEW 를 이용하여 조회
SELECT *
FROM (SELECT EMPNO, ENAME, JOB,MGR,HIREDATE,DEPTNO
		FROM EMP);	-- 위에서 만들었던 V_EMP 테이블을 IN-LINE VIEW 로 조회

VIEW 객체를 통해 얻을 수 있는 이점
1. 코드를 재사용할 수 있다.
2. SQL 코드 길이가 짧아진다.

hr 계정에게 emp 테이블이 아니라 v_emp 에 대한 접근권한을 부여
hr 계정에서는 emp 테이블의 sal, comm 컬럼을 볼 수가 없다.
	==> 급여정보에 대한 부분을 비 관련자로부터 차단을 할 수가 있다.
	
GRANT SELECT ON V_EMP TO HR;
----------------------------------------------------------------------

[ hr 계정으로 접속하여 테스트 ]
v_emp VIEW는 dron4gi 계정이 hr 계정에게 SELECT 권한을 주었기 때문에 정상적으로 조회 가능

SELECT*
FROM DRON4GI.V_EMP;

SELECT *
FROM dron4gi.emp;

-------------------------------------------------------------------
SELECT *
FROM emp;

VIEW : SQL 
v_emp 정의
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp

--1. emp 테이블에 신규 사원을 입력(기존 15건, 추가되서 16건)
INSERT INTO EMP (EMPNO, ENAME) VALUES (9990, 'JAMES');

2. SELECT *
	FROM V_EMP;
결과? ==> 16건
	VIEW 는 실체가 없는 데이터 집합을 정의하는 SQL 이기 때문에 해당 SQL 에서 사용하는 테이블의 데이터가
	변경이 되면 VIEW 에도 영향을 미친다.

------------------------------------------------------------
	
VIEW 는 SQL 이기 때문에 조인되 결과나, 그룹함수를 적용하여 행의 건수가 달라지는 SQL 도 VIEW 로 생성하는 것이 가능

EMP, DEPT 테이블의 경우 업무상 자주 같이 쓰일 수 밖에 없는 테이블
부서명, 사원번호, 사원이름, 담당업무, 입사일자
다섯개의 컬럼을 갖는 VIEW 를 V_EMP_DEPT

CREATE VIEW V_EMP_DEPT AS
SELECT DNAME, EMPNO, ENAME, JOB, HIREDATE
FROM DEPT d ,EMP e 
WHERE E.DEPTNO = D.DEPTNO;
	

SELECT *
FROM DEPT;

SELECT * 
FROM V_EMP_DEPT;

---------------------------------------------------------------

SEQUENCE : 중복되지 않는 정수값을 반환해주는 오라클 객체
시작값(DEFAULT 1, 혹은 개발자가 설정 가능) 부터 1씩 순차적으로 증가한 값을 반환한다.

[문법]
CREATE SEQUENCE 시퀀스명;
[옵션....]

seq_emp 이름으로 SEQUENCE 생성
CREATE SEQUENCE SEQ_EMP;

시퀀스 객체를 통해 중복되지 않는 값을 조회
시퀀스 객체에서 제공하는 함수
1. nextVal(NEXT value)
	시퀀스 객체의 다음 값을 요청하는 함수
	함수를 호출하면 시퀀스 객체의 값이 하나 증가 하여 다음번 호출 시 증가된 값을 반환한다.

2. currVal(CURRENT value)
	nextVal 함수를 사용하고 나서 사용할 수 있는 함수
	nextVal 함수를 통해 얻은 값을 다시 확인할 때 사용
	시퀀스 객체가 다음에 리턴할 값에 대해 영향을 미치지 않음
	
	nextVal 사용하기 전에 currval 사용하는 경우 ==> 에러
	
	
SELECT seq_emp.nextval
FROM dual;

SELECT seq_emp.currval
FROM dual;

INSERT INTO emp (empno) VALUES (???);













