--계정 생성 or 다양한 권한을 부여하려면 DBA계정으로 접속합니다.

SELECT * FROM HR.EMPLOYEES;
-- 사용자 계정 확인
SELECT * FROM all_users;
-- 현재 계정 권한 확인
SELECT * FROM user_sys_privs;

--사용자 계정 생성
CREATE USER USER01 IDENTIFIED BY USER01; --아이디, 비밀번호
--사용자에게 권한 부여
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE PROCEDURE  TO USER01;
--테이블스페이스 연결
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS; --변경한다 USER01 기본테이블스페이스 USERS 무제한 할당한다 USERS

--권한의 회수
REVOKE CREATE SESSION FROM USER01;
--계정삭제(만약 계정이 테이블을 들고 있으면, 테이블을 포함해서 삭제가 일어나야 합니다. )
DROP USER USER01 /*CASCADE*/;

-------------------------------------------------------------------------------
--롤을 이용한 권한 부여
CREATE USER USER01 IDENTIFIED BY USER01;
--ROLE
GRANT RESOURCE, CONNECT TO USER01; --위에서 사용한 권한과 동일한 ROLE
--테이블스페이스
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

DROP USER USER01 Cascade; --접속해제후 삭제
-------------------------------------------------------------------------------
--이 모든것을 마우스로
--다른 사용자 -> 계정생성 -> 롤부여 -> 테이블스페이스 지정 -> 생성

--보기탭 -> DBA클릭
--테이블스페이스를 직접만드는 방법.




