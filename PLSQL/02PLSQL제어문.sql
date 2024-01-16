--���
--IF ~~ THEN
--ELSIF ~~ THEN
--ELSE ~~
--END IF;
SET SERVEROUTPUT ON;

DECLARE
    NUM NUMBER := TRUNC( DBMS_RANDOM.VALUE(1, 11) ); --1~11�̸��� ������ ����
    NUM2 NUMBER := 5;
BEGIN
    dbms_output.put_line(NUM);
    IF NUM >= NUM2 THEN
        dbms_output.put_line(NUM || '�� ū�� �Դϴ�');    
    ELSE 
        dbms_output.put_line(NUM2 || '�� ū�� �Դϴ�');    
    END IF;
END;

--ELSE IF
DECLARE
    RAN_NUM NUMBER := TRUNC( DBMS_RANDOM.VALUE(1, 101) ); --1~101�̸� ������ ����
BEGIN
    /*
    IF RAN_NUM >= 90 THEN
        dbms_output.put_line('A���� �Դϴ�');    
    ELSIF RAN_NUM >= 80 THEN
        dbms_output.put_line('B���� �Դϴ�');    
    ELSIF RAN_NUM >= 70 THEN
        dbms_output.put_line('C���� �Դϴ�');    
    ELSE
        dbms_output.put_line('D���� �Դϴ�');    
    END IF;
    */
    CASE WHEN RAN_NUM >= 90 THEN dbms_output.put_line('A���� �Դϴ�');
         WHEN RAN_NUM >= 80 THEN dbms_output.put_line('B���� �Դϴ�');
         WHEN RAN_NUM >= 70 THEN dbms_output.put_line('C���� �Դϴ�');
         ELSE dbms_output.put_line('D���� �Դϴ�');
    END CASE;
        
END;
--------------------------------------------------------------------------------
--�ݺ��� WHILE

DECLARE
    V_COUNT NUMBER := 1;
BEGIN
    
    WHILE V_COUNT <= 9
    LOOP
        dbms_output.put_line('3 X ' || V_COUNT || '=' || 3*V_COUNT);
        
        V_COUNT := V_COUNT + 1;
    END LOOP;
END;

--------------------------------------------------------------------------------
--FOR��
DECLARE
    DAN NUMBER:= 3;
BEGIN

    FOR I IN 1..9 --1~9���� ���� I�� ��´�
    LOOP
        dbms_output.put_line(DAN || ' X ' || I || ' = ' || DAN * I);
    END LOOP;

END;
--Ż�⹮ EXIT WHEN ����, CONTINUE WHEN ����
DECLARE
BEGIN
    
    FOR I IN 1..10
    LOOP
        
        CONTINUE WHEN I = 5; -- NUM�� 5�� ��������
        dbms_output.put_line(I);
        -- EXIT WHEN I = 5; -- NUM�� 5�� Ż��

    END LOOP;
    
END;

--------------------------------------------------------------------------------
--Ŀ�� : ���� �������� �������� �� ���྿ ó���ϴ� ���
--��ȯ�Ǵ� ���� ������ �̱⶧����, ó���� �Ұ��� (Ŀ���� �̿��ؼ� ó��)
DECLARE
    NM VARCHAR2(30);
    SALARY NUMBER;
BEGIN
    SELECT  FIRST_NAME, SALARY 
    INTO NM, SALARY
    FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG';
END;
---------------------
DECLARE
    NM VARCHAR2(30);
    SALARY NUMBER;
    CURSOR X IS SELECT FIRST_NAME, SALARY FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG'; --1. Ŀ�� ����
BEGIN

    OPEN X; --2. Ŀ�� ����
        dbms_output.put_line('=======Ŀ������=========');
    LOOP
        FETCH X INTO NM, SALARY; --4. Ŀ���� �����͸� �о ������ ����
        EXIT WHEN X%NOTFOUND; --5. Ŀ���� ���̻� ���� �����Ͱ� ���ٸ� TRUE
        
        dbms_output.put_line(NM);
        dbms_output.put_line(SALARY);
        
    END LOOP;
         dbms_output.put_line('=======Ŀ������=========');
         dbms_output.put_line('������ڵ��:' || X%ROWCOUNT);
    CLOSE X; -- 3. Ŀ�� ����

END;

--------------------------------------------------------------------------------
--1. ��� �������� ����ϴ� �͸����� ���弼��
DECLARE
BEGIN
   
    FOR I IN 2..9
    LOOP
        
        FOR J IN 1..9
        LOOP
            dbms_output.put_line(I || ' X ' || J || ' = ' || I * J );
        END LOOP;
    
    END LOOP;    
END;
--2. ù��° ���� ROWNUM�� �̿��ϸ� �˴ϴ�. 
--����) 10~120������ 10���� ������ ��ȣ�� �̿��ؼ� ����DEPARTMENT_ID �� ù��° �ุ SELECT�մϴ�.
--����) ���� ����� SALARY�� 9000�̻��̸� ����, 5000�̻��̸� �߰�, �������� �������� ���.
--
SELECT TRUNC(DBMS_RANDOM.VALUE(1, 13)) * 10 FROM DUAL;
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = (SELECT TRUNC(DBMS_RANDOM.VALUE(1, 13)) * 10 FROM DUAL);

DECLARE
    RAN NUMBER := TRUNC(DBMS_RANDOM.VALUE(1, 13)) * 10;
    SALARY NUMBER;
BEGIN
    
    SELECT SALARY 
    INTO SALARY
    FROM EMPLOYEES WHERE DEPARTMENT_ID = RAN AND ROWNUM = 1;

    dbms_output.put_line('�޿�:' || SALARY);
    IF SALARY >= 9000 THEN
        dbms_output.put_line('���� �޿�');
    ELSIF SALARY >= 5000 THEN
        dbms_output.put_line('�߰� �޿�');
    ELSE
        dbms_output.put_line('���� �޿�');
    END IF;

END;
--3. COURSE ���̺� insert�� 100�� �����ϴ� �͸����� ó���ϼ���.
--����) NUM�� COURSE_SEQ�� �̿��ϼ���.
CREATE TABLE COURSE(
    NUM     NUMBER(10) NOT NULL, --�������� �̿��մϴ�.
    SUBJECT VARCHAR2(20), 
    CONTENT VARCHAR2(20),
    ID      NUMBER(10)   --�ݺ����� INDEX ������ �־��ּ���.
);
CREATE SEQUENCE COURSE_SEQ NOCACHE;

DECLARE
BEGIN
    
    FOR I IN 1..100
    LOOP
        INSERT INTO COURSE VALUES(COURSE_SEQ.NEXTVAL, 'TEST' || I, 'TEST' || I, I );
    END LOOP;
    
    COMMIT;
END;

--4. �μ��� �޿����� ����ϴ� Ŀ�������� �ۼ��غ��ô�.
SELECT DEPARTMENT_ID, SUM(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID;

DECLARE
    DEPT_ID VARCHAR2(30);
    SALARY NUMBER;
    CURSOR CSR IS SELECT DEPARTMENT_ID, SUM(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID;
BEGIN
    
    OPEN CSR;
    LOOP
        FETCH CSR INTO DEPT_ID, SALARY;
        EXIT WHEN CSR%NOTFOUND;
        
        dbms_output.put_line('�μ���' || DEPT_ID || ', �޿���:' || SALARY);
        
    END LOOP;
    CLOSE CSR;
        
END;

--5. ������̺��� ������ �޿����� ���Ͽ� EMP_SAL�� ���������� INSERT�ϴ� Ŀ�������� �ۼ��غ��ô�.
DECLARE
    YEAR VARCHAR2(30);
    SALARY NUMBER;
    CURSOR CSR IS SELECT A,
                         SUM(SALARY) AS B
                  FROM (SELECT TO_CHAR(HIRE_DATE, 'YYYY') AS A, 
                               SALARY
                        FROM EMPLOYEES 
                        )
                  GROUP BY A;
BEGIN
    FOR I IN CSR -- FOR~ IN������ ����, CURSOR OPEN, CLOSE, FETCH�������� �ڵ�ó��
    LOOP
        --dbms_output.put_line(I.A );
        --dbms_output.put_line(I.B );
        INSERT INTO EMP_SAL VALUES(I.A, I.B);
    END LOOP;
    
END;







