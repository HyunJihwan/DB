--ALTER TABLE System
--	DROP
--		PRIMARY KEY
--		CASCADE
--		KEEP INDEX;
--
--DROP INDEX PK_System;

/* 시스템 */
CREATE TABLE System (
	adminLevel NUMBER(1) NOT NULL, /* 관리레벨 */
	ID VARCHAR2(14), /* 아이디 */
	PWD VARCHAR2(20), /* 패스워드 */
	NAME VARCHAR2(20), /* 이름 */
	TEL VARCHAR2(13), /* 전화번호 */
	ADDR VARCHAR2(50), /* 주소 */
	GENDER NUMBER(1), /* 성별 */
	EMAIL VARCHAR2(30), /* 이메일 */
	POINT NUMBER(8) /* 포인트 */
);

COMMENT ON TABLE System IS '시스템';

COMMENT ON COLUMN System.adminLevel IS '관리레벨';

COMMENT ON COLUMN System.ID IS '아이디';

COMMENT ON COLUMN System.PWD IS '패스워드';

COMMENT ON COLUMN System.NAME IS '이름';

COMMENT ON COLUMN System.TEL IS '전화번호';

COMMENT ON COLUMN System.ADDR IS '주소';

COMMENT ON COLUMN System.GENDER IS '성별';

COMMENT ON COLUMN System.EMAIL IS '이메일';

COMMENT ON COLUMN System.POINT IS '포인트';

CREATE UNIQUE INDEX PK_System
	ON System (
		adminLevel ASC
	);

ALTER TABLE System
	ADD
		CONSTRAINT PK_System
		PRIMARY KEY (
			adminLevel
		);
		
	SELECT *
	FROM SYSTEM;

DROP TABLE SYSTEM;
	
INSERT INTO SYSTEM VALUES (5,'admin','1234','관리자','010-1234-5678','DW아카데미학원',NULL,NULL,NULL);
INSERT INTO SYSTEM VALUES (4,'wjawkd','1234','김점장','010-1234-5678','DW아카데미학원',1,'wjawkd@naver.com',NULL);
INSERT INTO SYSTEM VALUES (3,'manager','1234','이매니저','010-1234-5678','DW아카데미학원',2,'manager@naver.com',NULL);
INSERT INTO SYSTEM VALUES (2,'crew','1234','박크루','010-1234-5678','DW아카데미학원',1,'crew@naver.com',NULL);
INSERT INTO SYSTEM VALUES (1,'user','1234','최손님','010-1234-5678','DW아카데미학원',2,'user@naver.com',0);

ALTER TABLE system ADD sal; 

ALTER TABLE Program
	DROP
		PRIMARY KEY
		CASCADE
		KEEP INDEX;

DROP INDEX PK_Program;

/* 프로그램 */
CREATE TABLE Program (
	adminLevel NUMBER(1) NOT NULL, /* 관리레벨 */
	NAME VARCHAR2(20), /* 이름 */
	LOC VARCHAR2(10), /* 소속매장 */
	HIREDATE DATE, /* 입사일 */
	SAL TO_CHAR(NUMBER(5),'9,999'), /* 연봉 */
	ID VARCHAR2(14), /* 아이디 */
	PWD VARCHAR2(20), /* 패스워드 */
	TEL VARCHAR2(13), /* 전화번호 */
	ADDR VARCHAR2(50), /* 주소 */
	GENDER NUMBER(1), /* 성별 */
	EMAIL VARCHAR2(30), /* 이메일 */
	POINT NUMBER(8), /* 포인트 */
	MONTH NUMBER(3) /* 근속개월수 */
);

COMMENT ON TABLE Program IS '프로그램';

COMMENT ON COLUMN Program.adminLevel IS '관리레벨';

COMMENT ON COLUMN Program.NAME IS '이름';

COMMENT ON COLUMN Program.LOC IS '소속매장';

COMMENT ON COLUMN Program.HIREDATE IS '입사일';

COMMENT ON COLUMN Program.SAL IS '연봉';

COMMENT ON COLUMN Program.ID IS '아이디';

COMMENT ON COLUMN Program.PWD IS '패스워드';

COMMENT ON COLUMN Program.TEL IS '전화번호';

COMMENT ON COLUMN Program.ADDR IS '주소';

COMMENT ON COLUMN Program.GENDER IS '성별';

COMMENT ON COLUMN Program.EMAIL IS '이메일';

COMMENT ON COLUMN Program.POINT IS '포인트';

COMMENT ON COLUMN Program.MONTH IS '근속개월수';

CREATE UNIQUE INDEX PK_Program
	ON Program (
		adminLevel ASC
	);

ALTER TABLE Program
	ADD
		CONSTRAINT PK_Program
		PRIMARY KEY (
			adminLevel
		);





