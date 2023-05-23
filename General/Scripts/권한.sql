CREATE USER m_project IDENTIFIED BY java
DEFAULT tablespace TS_DBSQL
TEMPORARY tablespace TEMP
;

GRANT CONNECT, resource TO m_project;


CREATE USER m_project IDENTIFIED BY java
DEFAULT tablespace TS_DBSQL
TEMPORARY tablespace TEMP
;

CREATE USER a_project IDENTIFIED BY java
DEFAULT tablespace TS_DBSQL
TEMPORARY tablespace TEMP
;

GRANT CONNECT, resource TO a_project;