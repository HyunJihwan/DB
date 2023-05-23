/* 사용자 */
CREATE TABLE T_USER (
	user_no INTEGER NOT NULL, /* 회원번호 */
	email VARCHAR2(50), /* 이메일 */
	pass VARCHAR2(255), /* 비밀번호 */
	nick VARCHAR2(20), /* 닉네임 */
	name VARCHAR2(30), /* 이름 */
	birth VARCHAR2(20), /* 생년월일 */
	gender VARCHAR2(6), /* 성별 */
	auth_cd VARCHAR2(4), /* 권한코드 */
	gb_del VARCHAR2(1) /* 탈퇴여부 */
);

CREATE UNIQUE INDEX PK_T_USER
	ON T_USER (
		user_no ASC
	);

ALTER TABLE T_USER
	ADD
		CONSTRAINT PK_T_USER
		PRIMARY KEY (
			user_no
		);

/* 공통코드 */
CREATE TABLE T_CODE (
	cd_id VARCHAR2(4) NOT NULL, /* 코드ID */
	cd_nm VARCHAR2(50), /* 코드명 */
	gb_using VARCHAR2(1), /* 사용여부 */
	cd_des VARCHAR2(255) /* 코드설명 */
);

CREATE UNIQUE INDEX PK_T_CODE
	ON T_CODE (
		cd_id ASC
	);

ALTER TABLE T_CODE
	ADD
		CONSTRAINT PK_T_CODE
		PRIMARY KEY (
			cd_id
		);

/* 게시판 */
CREATE TABLE T_BOARD (
	bd_no INTEGER NOT NULL, /* 글번호 */
	bd_title VARCHAR2(30), /* 제목 */
	user_no INTEGER, /* 회원번호 */
	nick VARCHAR2(20), /* 작성자 */
	bd_content VARCHAR2(1000), /* 내용 */
	bd_wdt DATE, /* 작성일 */
	bd_hit INTEGER, /* 조회수 */
	bd_like INTEGER, /* 좋아요수 */
	gb_del VARCHAR2(1) /* 삭제여부 */
);

CREATE UNIQUE INDEX PK_T_BOARD
	ON T_BOARD (
		bd_no ASC
	);

ALTER TABLE T_BOARD
	ADD
		CONSTRAINT PK_T_BOARD
		PRIMARY KEY (
			bd_no
		);

/* 게시판댓글 */
CREATE TABLE T_BOARD_RE (
	re_no INTEGER NOT NULL, /* 댓글번호 */
	bd_no INTEGER, /* 글번호 */
	user_no INTEGER, /* 회원번호 */
	nick VARCHAR2(20), /* 작성자 */
	re_content VARCHAR2(100), /* 댓글내용 */
	re_wdt DATE, /* 댓글작성일 */
	gb_del VARCHAR2(1) /* 삭제여부 */
);

CREATE UNIQUE INDEX PK_T_BOARD_RE
	ON T_BOARD_RE (
		re_no ASC
	);

ALTER TABLE T_BOARD_RE
	ADD
		CONSTRAINT PK_T_BOARD_RE
		PRIMARY KEY (
			re_no
		);

/* 공감테이블 */
CREATE TABLE T_LIKE (
	bd_no INTEGER NOT NULL, /* 글번호 */
	user_no INTEGER NOT NULL, /* 회원번호 */
	like_cnt INTEGER /* 공감수 */
);

CREATE UNIQUE INDEX PK_T_LIKE
	ON T_LIKE (
		bd_no ASC,
		user_no ASC
	);

ALTER TABLE T_LIKE
	ADD
		CONSTRAINT PK_T_LIKE
		PRIMARY KEY (
			bd_no,
			user_no
		);

/* 첨부파일 */
CREATE TABLE T_ATT (
	att_no INTEGER NOT NULL, /* 첨부파일번호 */
	user_no INTEGER, /* 회원번호 */
	att_nm VARCHAR2(50) /* 첨부파일명 */
);

CREATE UNIQUE INDEX PK_T_ATT
	ON T_ATT (
		att_no ASC
	);

ALTER TABLE T_ATT
	ADD
		CONSTRAINT PK_T_ATT
		PRIMARY KEY (
			att_no
		);

ALTER TABLE T_BOARD
	ADD
		CONSTRAINT FK_T_USER_TO_T_BOARD
		FOREIGN KEY (
			user_no
		)
		REFERENCES T_USER (
			user_no
		);

ALTER TABLE T_BOARD_RE
	ADD
		CONSTRAINT FK_T_USER_TO_T_BOARD_RE
		FOREIGN KEY (
			user_no
		)
		REFERENCES T_USER (
			user_no
		);

ALTER TABLE T_BOARD_RE
	ADD
		CONSTRAINT FK_T_BOARD_TO_T_BOARD_RE
		FOREIGN KEY (
			bd_no
		)
		REFERENCES T_BOARD (
			bd_no
		);

ALTER TABLE T_LIKE
	ADD
		CONSTRAINT FK_T_USER_TO_T_LIKE
		FOREIGN KEY (
			user_no
		)
		REFERENCES T_USER (
			user_no
		);

ALTER TABLE T_LIKE
	ADD
		CONSTRAINT FK_T_BOARD_TO_T_LIKE
		FOREIGN KEY (
			bd_no
		)
		REFERENCES T_BOARD (
			bd_no
		);

ALTER TABLE T_ATT
	ADD
		CONSTRAINT FK_T_USER_TO_T_ATT
		FOREIGN KEY (
			user_no
		)
		REFERENCES T_USER (
			user_no
		);

	
	
	
