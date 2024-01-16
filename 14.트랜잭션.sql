--트랜잭션 (작업의 논리적인 단위)
--오직 DML문에 대해서만 트랜잭션을 수행할 수 있습니다.

--오토커밋 상태 확인
SHOW AUTOCOMMIT;
--오토커밋 온
SET AUTOCOMMIT ON;
--오토커밋 OFF
SET AUTOCOMMIT OFF;

--------------------------------------------------------------------------------
--SAVE POINT (실제로 많이 쓰지 않음)
SELECT * FROM DEPTS;
DELETE FROM DEPTS WHERE DEPARTMENT_ID = 10;

SAVEPOINT DEL10; -- DEL10 세이브포인트

DELETE FROM DEPTS WHERE DEPARTMENT_ID = 20;

SAVEPOINT DEL20; -- DEL20 세이브포인트

DELETE FROM DEPTS WHERE DEPARTMENT_ID = 30;

ROLLBACK TO DEL20; -- 20번지점으로 롤백
SELECT * FROM DEPTS;
ROLLBACK TO DEL10; -- 10번지점으로 롤백
SELECT * FROM DEPTS;

ROLLBACK; -- 마지막 커밋시점으로 롤백

--커밋 (실제 반영)
INSERT INTO DEPTS VALUES(280, 'AAA', NULL, 1800);
COMMIT;
SELECT * FROM DEPTS;










