--Ʈ���� : Ʈ���Ŵ� ���̺� ������ ���·�, after, beforeƮ���Ű� �ֽ��ϴ�.
--after - DML������ Ÿ�����̺� ����� ���Ŀ� �����ϴ� Ʈ����
--before - DML������ Ÿ�����̺� ����Ǳ� ������ �����ϴ� Ʈ����
SET SERVEROUTPUT ON;

CREATE TABLE TBL_TEST(
    ID VARCHAR2(30),
    TEXT VARCHAR2(30)
);
--
CREATE OR REPLACE TRIGGER TBL_TEST_TRG
    AFTER UPDATE OR INSERT OR DELETE --Ʈ���� ����
    ON TBL_TEST --������ ���̺�
    FOR EACH ROW --���࿡ ������
BEGIN
    dbms_output.put_line('Ʈ���Ű� ���۵�');
END;
--
INSERT INTO TBL_TEST VALUES('1', 'HONG'); -- Ʈ���� OK
INSERT INTO TBL_TEST VALUES('2', 'KIM'); -- Ʈ���� OK
UPDATE TBL_TEST SET TEXT = 'TEST' WHERE ID = '1'; -- Ʈ���� OK
DELETE FROM TBL_TEST WHERE ID = '1'; -- Ʈ���� OK
---------------------------------------------------------------------------------
-- :OLD = ���� �� ���� �� (INSERT : �Է� �� �ڷ�, UPDATE : ���� �� �ڷ�, DELETE : ������ �ڷ�)
-- :NEW = ���� �� ���� �� (INSERT : �Է� �� �ڷ�, UPDATE : ���� �� �ڷ�)
CREATE TABLE TBL_USER(
    ID VARCHAR2(30) PRIMARY KEY,
    NAME VARCHAR2(30),
    ADDRESS VARCHAR2(30)
);
CREATE TABLE TBL_USER_BACKUP(
    ID VARCHAR2(30),
    NAME VARCHAR2(30),
    ADDRESS VARCHAR2(30),
    UPDATE_DATE DATE DEFAULT SYSDATE, -- ���� �����Ǿ���
    M_TYPE VARCHAR2(10), -- � ���·� ����Ǿ�����
    M_USER VARCHAR2(20)  -- ���� �����ߴ���
);
-- ������Ʈ OR ������ �Ͼ�� ���� �����͸� BACKUP�� �����Ѵ�.
CREATE OR REPLACE TRIGGER TLB_USER_TRG
    AFTER UPDATE OR DELETE
    ON TBL_USER
    FOR EACH ROW
DECLARE 
    V_TYPE VARCHAR2(10);
BEGIN
    
    IF UPDATING THEN -- UPDATE�� �Ͼ�� TRUE�� ��ȯ�ϴ� TRIGGER���� ��밡���� ����
        V_TYPE := 'UPDATE';
    ELSIF DELETING THEN
        V_TYPE := 'DELETE';
    END IF;
    
    -- UPDATE OR DELETE�� ����Ǳ� ���� �÷��� :OLD
    INSERT INTO TBL_USER_BACKUP VALUES( :OLD.ID, :OLD.NAME , :OLD.ADDRESS , SYSDATE ,V_TYPE , USER() );
END;
--
INSERT INTO TBL_USER VALUES('A1', 'TEST1', '����'); -- Ʈ���� X
INSERT INTO TBL_USER VALUES('A2', 'TEST2', '����');
INSERT INTO TBL_USER VALUES('A3', 'TEST3', '����');
INSERT INTO TBL_USER VALUES('A4', 'TEST4', '����');
UPDATE TBL_USER SET NAME = 'XXX' WHERE ID = 'A1'; -- Ʈ���� O
UPDATE TBL_USER SET NAME = 'YYY' WHERE ID = 'A1'; -- Ʈ���� O
DELETE FROM TBL_USER WHERE ID = 'A1'; -- Ʈ���� O

SELECT * FROM TBL_USER_BACKUP;
--------------------------------------------------------------------------------
--BEFOREƮ���� :NEWŰ����
SELECT * FROM TBL_USER;

CREATE OR REPLACE TRIGGER TBL_USER_MASKING_TRG
    BEFORE INSERT -- INSERT������ ����
    ON TBL_USER
    FOR EACH ROW
DECLARE
BEGIN
    -- �μ�Ʈ�� �Ǳ� �� �ڷḦ �� ����ŷ ó���ϰ�, �ٽ� ����
    :NEW.NAME := SUBSTR( :NEW.NAME, 1, 1 ) || '****';

END;
--
INSERT INTO TBL_USER VALUES('A5', 'ȫ�浿', '�����');
INSERT INTO TBL_USER VALUES('A6', '������', '�����');
SELECT * FROM TBL_USER;
-------------------------------------------------------------------------------
-- 1. �ֹ��� ���ͼ� �ֹ����̺� �����Ͱ� INSERT�Ǹ� �ڵ����� ��ǰ���̺��� ������ ���ҵǴ� Ʈ���Ÿ� �����غ�����.
--�ֹ�(�ֹ��� �ѹ��� �� ��ǰ�ۿ� ���Ѵٰ� ����)
CREATE TABLE ORDER_HISTORY (
    HISTORY_NO NUMBER(5) PRIMARY KEY,
    PRODUCT_NO NUMBER(5), --FK
    TOTAL NUMBER(10), --����
    PRICE NUMBER(10) --�ݾ�
);

--��ǰ
CREATE TABLE PRODUCT (
    PRODUCT_NO NUMBER(5) PRIMARY KEY,
    PRODUCT_NAME VARCHAR(20),
    TOTAL NUMBER(5),
    PRICE NUMBER(5)
);

INSERT INTO PRODUCT VALUES(1, '����', 100, 10000); 
INSERT INTO PRODUCT VALUES(2, 'ġŲ', 100, 15000); 
INSERT INTO PRODUCT VALUES(3, '�ܹ���', 100, 5000);

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
    
    --ó���� �۾��� PRODUCT���̺��� �ش� ��ǰ�� ������ ����
    UPDATE PRODUCT 
    SET TOTAL = TOTAL - P_TOTAL 
    WHERE PRODUCT_NO = P_NO;
    
END;
--ORDER���̺� INSERT
INSERT INTO ORDER_HISTORY VALUES(1, 1, 10, 100000); --PK, FK, ����, ����
INSERT INTO ORDER_HISTORY VALUES(2, 1, 5, 50000); --PK, FK, ����, ����
INSERT INTO ORDER_HISTORY VALUES(3, 2, 10, 150000); --PK, FK, ����, ����
INSERT INTO ORDER_HISTORY VALUES(4, 3, 1, 5000); --PK, FK, ����, ����

SELECT * FROM PRODUCT;






