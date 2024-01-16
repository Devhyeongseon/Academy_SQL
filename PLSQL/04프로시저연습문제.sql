--1. ���ν����� GUGUPROC
--- ������ �� �Է¹޾� �ش� �ܼ��� ����ϴ� procedure�� �����ϰ� �����ϼ���
CREATE OR REPLACE PROCEDURE GUGUPROC
(DAN IN NUMBER)
IS 
BEGIN
    FOR I IN 1..9
    LOOP
        dbms_output.put_line(DAN || ' X ' || I || ' = ' || DAN * I);
    END LOOP;
END;

EXEC GUGUPROC(3);
--2. ���ν����� EMP_YEAR_PROC
--- EMPLOYEE_ID�� �޾Ƽ� EMPLOYEES�� �����ϸ�, "�ټӳ���� ���" �ϰ�, ���ٸ� "EMPLOYEE_ID�� �����ϴ�" �� ����ϴ� ���ν���
--- ����ó���� �ۼ����ּ���.
SELECT TRUNC( (SYSDATE - HIRE_DATE) / 365 ) AS YEARS FROM EMPLOYEES WHERE EMPLOYEE_ID = 101;

CREATE OR REPLACE PROCEDURE EMP_YEAR_PROC(
    EMP_ID EMPLOYEES.EMPLOYEE_ID%TYPE
)
IS
    CNT NUMBER;
    YEARS NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CNT
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = EMP_ID;

    IF CNT = 0 THEN
        dbms_output.put_line('�ش� ���̵�� �����ϴ�');
    ELSE
        SELECT TRUNC( (SYSDATE - HIRE_DATE) / 365 ) AS YEARS 
        INTO YEARS
        FROM EMPLOYEES WHERE EMPLOYEE_ID = EMP_ID;
        
        dbms_output.put_line('�ټӳ��:' || YEARS);
    END IF;

    EXCEPTION WHEN OTHERS THEN 
        dbms_output.put_line('���ܰ� �߻��߽��ϴ�');
END;

EXEC EMP_YEAR_PROC(100);
EXEC EMP_YEAR_PROC(2344);

--3. ���ν����� DEPTS_PROC
--- �μ���ȣ, �μ���, �۾� flag(I: insert, U:update, D:delete)�� �Ű������� �޾� 
--DEPTS���̺� ���� flag�� i�� INSERT, u�� UPDATE, d�� DELETE �ϴ� ���ν����� �����մϴ�.
--- �׸��� ���������� commit, ���ܶ�� �ѹ� ó���ϵ��� ó���ϼ���.
--- ����ó���� �ۼ����ּ���.
DROP TABLE DEPTS;
CREATE TABLE DEPTS AS (SELECT * FROM DEPARTMENTS WHERE 1 = 1);
SELECT * FROM DEPTS;
---------------------------------------
CREATE OR REPLACE PROCEDURE DEPTS_PROC(
    DEPTS_ID IN DEPARTMENTS.DEPARTMENT_ID%TYPE,
    DEPTS_NM IN DEPARTMENTS.DEPARTMENT_NAME%TYPE,
    FLAG IN VARCHAR2
)
IS
BEGIN

    IF FLAG = 'I' THEN
        INSERT INTO DEPTS(DEPARTMENT_ID, DEPARTMENT_NAME) VALUES(DEPTS_ID, DEPTS_NM); 
    ELSIF FLAG = 'U' THEN
        UPDATE DEPTS 
        SET DEPARTMENT_NAME = DEPTS_NM
        WHERE DEPARTMENT_ID = DEPTS_ID;
    ELSE
        DELETE FROM DEPTS WHERE DEPARTMENT_ID = DEPTS_ID;
    END IF;
    
    COMMIT;
    
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('���ܰ� �߻��߽��ϴ�');
        ROLLBACK;
    
END;
--4. ���ν����� EMP_AGE_PROC
--- employee_id�� �Է¹޾� employees�� �����ϸ�, �ټӳ���� out�ϴ� ���ν����� �ۼ��ϼ���.
--- ����ó���� �ۼ����ּ���.
CREATE OR REPLACE PROCEDURE EMP_AGE_PROC(
    EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    EMP_YEARS OUT NUMBER
)
IS
    CNT NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO CNT
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = EMP_ID;
    
    IF CNT <> 0 THEN
        SELECT TRUNC((SYSDATE - HIRE_DATE) / 365) 
        INTO EMP_YEARS --OUT����
        FROM EMPLOYEES WHERE EMPLOYEE_ID = EMP_ID;
        
    END IF;
    
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('���ܰ� �߻��߽��ϴ�');
    
END;
--
DECLARE
    RESULT NUMBER;
BEGIN
    EMP_AGE_PROC(101, RESULT);
    dbms_output.put_line(RESULT);
END;
--5. ���ν����� - EMP_MERGE_PROC
--- employees ���̺��� ���� ���̺� emps�� �����մϴ�.
--- employee_id, last_name, email, hire_date, job_id�� �Է¹޾� �����ϸ� �̸�, �̸���, �Ի���, ������ update, 
--���ٸ� insert�ϴ� merge���� �ۼ��ϼ���
--- ��Ʈ (MERGE INTO ���̺� USING ���� WHEN MATCHED THEN ������Ʈ WHEN NOT MATCHED THEN �μ�Ʈ )
CREATE OR REPLACE PROCEDURE EMP_MERGE_PROC(
    P_EMPLOYEE_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    P_LAST_NAME   IN EMPLOYEES.LAST_NAME%TYPE,
    P_EMAIL       IN EMPLOYEES.EMAIL%TYPE,
    P_HIRE_DATE   IN EMPLOYEES.HIRE_DATE%TYPE,
    P_JOB_ID      IN EMPLOYEES.JOB_ID%TYPE
    )
IS
BEGIN

    MERGE INTO EMPS E1
    USING (SELECT P_EMPLOYEE_ID AS EMPLOYEE_ID FROM DUAL) E2
    ON (E1.EMPLOYEE_ID = E2.EMPLOYEE_ID)
    WHEN MATCHED THEN
        UPDATE SET E1.LAST_NAME = P_LAST_NAME,
                   E1.EMAIL     = P_EMAIL,
                   E1.HIRE_DATE = P_HIRE_DATE,
                   E1.JOB_ID    = P_JOB_ID
    WHEN NOT MATCHED THEN
        INSERT (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID) 
        VALUES(P_EMPLOYEE_ID, P_LAST_NAME, P_EMAIL, P_HIRE_DATE, P_JOB_ID);

END;
--
SELECT * FROM EMPS;

EXEC EMP_MERGE_PROC(100, 'TEST', 'TEST', SYSDATE, 'TEST');
EXEC EMP_MERGE_PROC(148, 'TEST', 'TEST', SYSDATE, 'TEST');
--------------------------
--6. ���ν����� - SALES_PROC
--- sales���̺��� ������ �Ǹų����̴�.
--- day_of_sales���̺��� �Ǹų��� ������ ���� ������ �Ѹ����� ����ϴ� ���̺��̴�.
--- ������ sales�� ���ó�¥ �Ǹų����� �����Ͽ� day_of_sales�� �����ϴ� ���ν����� �����غ�����.
--����) day_of_sales�� ���������� �̹� �����ϸ� ������Ʈ ó��
CREATE TABLE SALES(
    SNO NUMBER(5) CONSTRAINT SALES_PK PRIMARY KEY, -- ��ȣ
    NAME VARCHAR2(30), -- ��ǰ��
    TOTAL NUMBER(10), --����
    PRICE NUMBER(10), --����
    REGDATE DATE DEFAULT SYSDATE --��¥
);

CREATE TABLE DAY_OF_SALES(
    REGDATE DATE,
    FINAL_TOTAL NUMBER(10)
);

INSERT INTO SALES VALUES(1, '���̽��Ƹ޸�ī', 1, 1000, SYSDATE);
INSERT INTO SALES VALUES(2, '������', 2, 2000, SYSDATE);
INSERT INTO SALES VALUES(3, '�ڹ�Ĩ', 3, 3000, SYSDATE);

-----------------------------------
CREATE OR REPLACE PROCEDURE SALES_PROC(
    P_REGDATE IN DATE
)
IS
    TOTAL_COUNT NUMBER := 0; --�ѱݾ�
    CNT NUMBER := 0;
BEGIN
    --1.���ó�¥ �������� �ݾ�����
    SELECT SUM(TOTAL * PRICE)
    INTO TOTAL_COUNT
    FROM SALES
    WHERE TO_CHAR(REGDATE, 'YYYY-MM-DD') = TO_CHAR(P_REGDATE, 'YYYY-MM-DD');
    --2.�������̺� ���ó�¥ �����Ͱ� �ִ��� Ȯ��
    SELECT COUNT(*)
    INTO CNT
    FROM DAY_OF_SALES
    WHERE TO_CHAR(REGDATE, 'YYYY-MM-DD') = TO_CHAR(P_REGDATE, 'YYYY-MM-DD');
    --3. CNT = 0�� INSERT CNT�� 0�� �ƴϸ� UPDATE
    IF CNT = 0 THEN
        INSERT INTO DAY_OF_SALES VALUES(P_REGDATE, TOTAL_COUNT);
    ELSE
        UPDATE DAY_OF_SALES SET FINAL_TOTAL = TOTAL_COUNT
        WHERE TO_CHAR(REGDATE, 'YYYY-MM-DD') = TO_CHAR(P_REGDATE, 'YYYY-MM-DD');
        
    END IF;
    
END;
--
EXEC SALES_PROC(SYSDATE);
SELECT * FROM DAY_OF_SALES;

















