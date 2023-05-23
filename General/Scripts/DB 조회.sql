INSERT INTO A_USER (U_NO,ID,PWD,NICK) VALUES( 
					0 
					,'ADMIN'
					,'1234'
					,'관리자'	
					);
				
INSERT INTO A_USER VALUES( 
					1 
					,'WJAWKD'
					,'1234'
					,'김둘리'
					,null
					,'점장'	
					,'대전 선화동 집게리아'
					,SYSDATE 
					,60
					,5000
					,NULL
					,'1980-10-10'
					,'010-1234-5678'
					,'대전 중구 선화동'
					,'wjawkd@wjawkd.com'
					,1
					,null
					,'y'
					,0
					);

				
				

INSERT INTO A_USER VALUES( 
					2 
					,'MANAGER'
					,'1234'
					,'김도우너'
					,null
					,'매니저'	
					,'대전 선화동 집게리아'
					,SYSDATE 
					,40
					,'3000'
					,NULL
					,'1995-05-10'
					,'010-2345-6789'
					,'대전 중구 선화동'
					,'manager@manager.com'
					,1
					,null
					,'y'
					,0
					);
				
INSERT INTO A_USER VALUES( 
					3 
					,'CREW'
					,'1234'
					,'김뚱이'
					,null
					,'알바'	
					,'대전 선화동 집게리아'
					,SYSDATE 
					,6
					,NULL
					,9820
					,'2000-05-23'
					,'010-5444-5555'
					,'대전 중구 선화동'
					,'crew@crew.com'
					,2
					,null
					,'n'
					,0
					);	
INSERT INTO A_USER VALUES( 
					4 
					,'CREW'
					,'1234'
					,'김크루'
					,null
					,'알바'	
					,'대전 선화동 집게리아'
					,SYSDATE 
					,8
					,NULL
					,9620
					,'2000-05-23'
					,'010-5555-5555'
					,'대전 중구 선화동'
					,'crew1@crew.com'
					,1
					,null
					,'n'
					,0
					);
INSERT INTO A_USER VALUES( 
					5 
					,'CREW'
					,'1234'
					,'박크루'
					,null
					,'알바'	
					,'대전 선화동 집게리아'
					,SYSDATE 
					,9
					,NULL
					,9700
					,'1997-09-26'
					,'010-5444-5555'
					,'대전 중구 선화동'
					,'crew2@crew.com'
					,1
					,null
					,'n'
					,0
					);				
	SELECT *
	FROM a_user;
	
	SELECT *
	FROM A_STORE;

INSERT INTO A_STORE('대전 선화동 집게리아', '대전 중구 선화동', '09:00-18:00','김점장'); 

INSERT INTO a_user (U_NO,ID,PWD,NAME,NICK ,BIRTH,TEL ,ADDR ,EMAIL,POINT ,GB_OUT,PICTURE)
VALUES(
	6,'customer1','1234','김손님','김데리','2002-02-02','010-1111-1111','대전 동구 성남동 ','thssla1@thssla.com',555,'N',0
);

INSERT INTO a_user (U_NO,ID,PWD,NAME,NICK ,BIRTH,TEL ,ADDR ,EMAIL,POINT ,GB_OUT,PICTURE)
VALUES(
	7,'customer2','1234','박손님','박맥날','2005-03-03','010-1111-2222','대전 동구 삼성동 ','thssla2@thssla.com',675,'N',0
);

INSERT INTO a_user (U_NO,ID,PWD,NAME,NICK ,BIRTH,TEL ,ADDR ,EMAIL,POINT ,GB_OUT,PICTURE)
VALUES(
	8,'customer3','1234','최손님','최버거','1998-04-04','010-1111-3333','대전 동구 은행동 ','thssla3@thssla.com',877,'N',0
);
				
	