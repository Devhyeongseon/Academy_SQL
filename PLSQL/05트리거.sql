--트리거 : 트리거는 테이블 부착된 형태로, after, before트리거가 있습니다.
--after - DML문장이 타겟테이블에 실행된 이후에 동작하는 트리거
--before - DML문장이 타겟테이블에 실행되기 이전에 동작하는 트리거
SET SERVEROUTPUT ON;

CREATE TABLE TBL_TEST(
    ID VARCHAR2(30),
    TEXT VARCHAR2(30)
);
--
CREATE OR REPLACE TRIGGER TBL_TEST_TRG
    AFTER UPDATE OR INSERT OR DELETE --트리거 종류
    ON TBL_TEST --부착할 테이블
    FOR EACH ROW --각행에 적용함
BEGIN
    dbms_output.put_line('트리거가 동작됨');
END;
--
INSERT INTO TBL_TEST VALUES('1', 'HONG'); -- 트리거 OK
INSERT INTO TBL_TEST VALUES('2', 'KIM'); -- 트리거 OK
UPDATE TBL_TEST SET TEXT = 'TEST' WHERE ID = '1'; -- 트리거 OK
DELETE FROM TBL_TEST WHERE ID = '1'; -- 트리거 OK
---------------------------------------------------------------------------------
-- :OLD = 참조 전 열의 값 (INSERT : 입력 전 자료, UPDATE : 수정 전 자료, DELETE : 삭제될 자료)
-- :NEW = 참조 후 열의 값 (INSERT : 입력 할 자료, UPDATE : 수정 된 자료)
CREATE TABLE TBL_USER(
    ID VARCHAR2(30) PRIMARY KEY,
    NAME VARCHAR2(30),
    ADDRESS VARCHAR2(30)
);
CREATE TABLE TBL_USER_BACKUP(
    ID VARCHAR2(30),
    NAME VARCHAR2(30),
    ADDRESS VARCHAR2(30),
    UPDATE_DATE DATE DEFAULT SYSDATE, -- 언제 수정되었나
    M_TYPE VARCHAR2(10), -- 어떤 형태로 변경되었는지
    M_USER VARCHAR2(20)  -- 누가 변경했는지
);
-- 업데이트 OR 삭제가 일어날때 기존 데이터를 BACKUP에 저장한다.
CREATE OR REPLACE TRIGGER TLB_USER_TRG
    AFTER UPDATE OR DELETE
    ON TBL_USER
    FOR EACH ROW
DECLARE 
    V_TYPE VARCHAR2(10);
BEGIN
    
    IF UPDATING THEN -- UPDATE가 일어나면 TRUE를 반환하는 TRIGGER에서 사용가능한 구문
        V_TYPE := 'UPDATE';
    ELSIF DELETING THEN
        V_TYPE := 'DELETE';
    END IF;
    
    -- UPDATE OR DELETE가 적용되기 전의 컬럼값 :OLD
    INSERT INTO TBL_USER_BACKUP VALUES( :OLD.ID, :OLD.NAME , :OLD.ADDRESS , SYSDATE ,V_TYPE , USER() );
END;
--
INSERT INTO TBL_USER VALUES('A1', 'TEST1', '서울'); -- 트리거 X
INSERT INTO TBL_USER VALUES('A2', 'TEST2', '서울');
INSERT INTO TBL_USER VALUES('A3', 'TEST3', '서울');
INSERT INTO TBL_USER VALUES('A4', 'TEST4', '서울');
UPDATE TBL_USER SET NAME = 'XXX' WHERE ID = 'A1'; -- 트리거 O
UPDATE TBL_USER SET NAME = 'YYY' WHERE ID = 'A1'; -- 트리거 O
DELETE FROM TBL_USER WHERE ID = 'A1'; -- 트리거 O

SELECT * FROM TBL_USER_BACKUP;
--------------------------------------------------------------------------------
--BEFORE트리거 :NEW키워드
SELECT * FROM TBL_USER;

CREATE OR REPLACE TRIGGER TBL_USER_MASKING_TRG
    BEFORE INSERT -- INSERT이전에 동작
    ON TBL_USER
    FOR EACH ROW
DECLARE
BEGIN
    -- 인서트가 되기 전 자료를 얻어서 마스킹 처리하고, 다시 저장
    :NEW.NAME := SUBSTR( :NEW.NAME, 1, 1 ) || '****';

END;
--
INSERT INTO TBL_USER VALUES('A5', '홍길동', '서울시');
INSERT INTO TBL_USER VALUES('A6', '이참빛', '서울시');
SELECT * FROM TBL_USER;
-------------------------------------------------------------------------------
-- 1. 주문이 들어와서 주문테이블에 데이터가 INSERT되면 자동으로 상품테이블의 수량이 감소되는 트리거를 생성해보세요.
--주문(주문은 한번에 한 상품밖에 못한다고 가정)
CREATE TABLE ORDER_HISTORY (
    HISTORY_NO NUMBER(5) PRIMARY KEY,
    PRODUCT_NO NUMBER(5), --FK
    TOTAL NUMBER(10), --수량
    PRICE NUMBER(10) --금액
);

--상품
CREATE TABLE PRODUCT (
    PRODUCT_NO NUMBER(5) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(20),
    TOTAL NUMBER(5),
    PRICE NUMBER(5)
);

INSERT INTO PRODUCT VALUES(1, '피자', 100, 10000); 
INSERT INTO PRODUCT VALUES(2, '치킨', 100, 15000); 
INSERT INTO PRODUCT VALUES(3, '햄버거', 100, 5000);

SELECT * FROM PRODUCT;
SELECT * FROM ORDER_HISTORY;

CREATE OR REPLACE TRIGGER PRODUCT_TRG
    AFTER INSERT
    ON ORDER_HISTORY
    FOR EACH ROW
DECLARE
    P_TOTAL NUMBER := :NEW.TOTAL;
    P_NO NUMBER := :NEW.PRODUCT_NO;
BEGIN
    
    --처리할 작업은 PRODUCT테이블의 해당 상품의 수량을 감소
    UPDATE PRODUCT 
    SET TOTAL = TOTAL - P_TOTAL 
    WHERE PRODUCT_NO = P_NO;
    
END;
--ORDER테이블에 INSERT
INSERT INTO ORDER_HISTORY VALUES(1, 1, 10, 100000); --PK, FK, 수량, 가격
INSERT INTO ORDER_HISTORY VALUES(2, 1, 5, 50000); --PK, FK, 수량, 가격
INSERT INTO ORDER_HISTORY VALUES(3, 2, 10, 150000); --PK, FK, 수량, 가격
INSERT INTO ORDER_HISTORY VALUES(4, 3, 1, 5000); --PK, FK, 수량, 가격

SELECT * FROM PRODUCT;






