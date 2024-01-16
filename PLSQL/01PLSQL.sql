--��¹� ���
SET SERVEROUTPUT ON;

DECLARE
    V_NUM NUMBER; --������ ����
    V_NUM2 NUMBER := 2 ** 3 * 3;
BEGIN
    V_NUM := 30; --����
    
    dbms_output.put_line('�����ǰ�:' || V_NUM);
    dbms_output.put_line('�����ǰ�:' || V_NUM2);
END;

----------------------------------------------
--DML����� �Բ� ����� �� �� �ֽ��ϴ�.
--SELECT -> INSERT, UPDATE �������� DML������ ������ �� �ֵ��� ���ݴϴ�.

DECLARE
    EMP_NAME VARCHAR2(30);
    EMP_SALARY NUMBER;
    EMP_LAST_NAME EMPLOYEES.LAST_NAME%TYPE; -- �ش� �÷��� ������ ���� Ÿ���� ����� (VARCAHR2 25)
BEGIN
    
    SELECT FIRST_NAME, SALARY, LAST_NAME
    INTO EMP_NAME, EMP_SALARY, EMP_LAST_NAME -- ��ȸ�� ���� ������ ����
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
    
    dbms_output.put_line(EMP_NAME ); 
    dbms_output.put_line(EMP_SALARY ); 
    dbms_output.put_line(EMP_LAST_NAME ); 
    
END;

-----------------------------------------------
--�⵵�� ����� �޿����� ���ؼ� ���ο� ���̺� INSERT
CREATE TABLE EMP_SAL (
    EMP_YEARS VARCHAR2(50),
    EMP_SALARY NUMBER(10)
);

DECLARE 
    EMP_SUM EMP_SAL.EMP_SALARY%TYPE;
    EMP_YEARS EMP_SAL.EMP_YEARS%TYPE := 2008;
BEGIN
    SELECT SUM(SALARY) 
    INTO EMP_SUM
    FROM EMPLOYEES WHERE TO_CHAR(HIRE_DATE, 'YYYY') = EMP_YEARS;
    
    INSERT INTO EMP_SAL VALUES(EMP_YEARS, EMP_SUM);
    COMMIT; 
    
    dbms_output.put_line('���� ó���Ǿ����ϴ�. 2008�޿���:' || EMP_SUM );
END;

--------------------------------------------------------------------------------
--1. ������ �� 3���� ����ϴ� �͸� ����� �����ô�. (�ܼ��� ���)
DECLARE
BEGIN
   DBMS_OUTPUT.PUT_LINE('3 * 1 = ' || 3*1);
   DBMS_OUTPUT.PUT_LINE('3 * 2 = ' || 3*2);
   DBMS_OUTPUT.PUT_LINE('3 * 3 = ' || 3*3);
   DBMS_OUTPUT.PUT_LINE('3 * 4 = ' || 3*4);
   DBMS_OUTPUT.PUT_LINE('3 * 5 = ' || 3*5);
   DBMS_OUTPUT.PUT_LINE('3 * 6 = ' || 3*6);
   DBMS_OUTPUT.PUT_LINE('3 * 7 = ' || 3*7);
   DBMS_OUTPUT.PUT_LINE('3 * 8 = ' || 3*8);
   DBMS_OUTPUT.PUT_LINE('3 * 9 = ' || 3*9);   
END;
--2. ��� ���̺��� 201�� ����� �̸��� �̸����ּҸ� ����ϴ� �͸� ����� ����� ����.
DECLARE
    F_NAME EMPLOYEES.FIRST_NAME%TYPE;
    F_EMAIL EMPLOYEES.EMAIL%TYPE;
BEGIN
    SELECT FIRST_NAME, EMAIL
    INTO F_NAME, F_EMAIL
    FROM EMPLOYEES WHERE EMPLOYEE_ID = 201;
    
    DBMS_OUTPUT.PUT_LINE(F_NAME || '���� �̸�����:' || F_EMAIL);   
END;
--3. ��� ���̺��� �����ȣ�� ���� ū ����� ã�Ƴ� ��, 
--	 �� ��ȣ +1������ �Ʒ��� ����� emps���̺� employee_id, last_name, email, hire_date, job_id��  �ű� �Է��ϴ� �͸� ����� ����� ����.
--<�����>   : steven
--<�̸���>   : stevenjobs
--<�Ի�����> : ���ó�¥
--<JOB_ID> : CEO
DECLARE
    NUM NUMBER;
BEGIN
    SELECT MAX(EMPLOYEE_ID) + 1 
    INTO NUM
    FROM EMPLOYEES;
    
    INSERT INTO EMPS(EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES (NUM, 'steven', 'stevenjobs', SYSDATE, 'CEO');
    
    COMMIT;
END;

SELECT * FROM EMPS;

















