-- ���� ���ν��� (�Ϸ��� SQLó�� ������ ����ó�� ��� ����ϴ� ������)
-- ����
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC -- ���ν�����
IS -- ���������� ����
BEGIN -- ���౸��
    dbms_output.put_line('HELLO WORLD');
END;

-- ���๮
EXEC NEW_JOB_PROC;

------------------------------------------
-- ���ν����� �Ű����� IN
-- ����Ʈ �Ű�����
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC -- ������ �̸����� ����� �����˴ϴ�.
(P_JOB_ID IN JOBS.JOB_ID%TYPE,
 P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
 P_MIN_SALARY IN JOBS.MIN_SALARY%TYPE := 0,
 P_MAX_SALARY IN JOBS.MAX_SALARY%TYPE := 1000
)
IS
BEGIN
    
    INSERT INTO JOBS_IT VALUES(P_JOB_ID, P_JOB_TITLE, P_MIN_SALARY, P_MAX_SALARY);
    
END;

--
EXEC NEW_JOB_PROC('SAMPLE', 'TEXT', 1000, 10000); --OK
EXEC NEW_JOB_PROC('TEST1', 'TEST1', 1000); -- ���������� �⺻�Ű������� ����
EXEC NEW_JOB_PROC('TEST2', 'TEST2'); --OK
EXEC NEW_JOB_PROC('TEST3'); -- �Ű������� ���� �ʱ� ������ ERR

SELECT * FROM JOBS_IT;
------------------------------------------
--���ν��������� PL/SQL���� ����� ��� ������ ���� ��밡���մϴ�.
--JOB_ID�� �������� ������ UPDATE, �����ϸ� INSERT
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC 
    (P_JOB_ID IN JOBS.JOB_ID%TYPE,
     P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
     P_MIN_SALARY IN JOBS.MIN_SALARY%TYPE := 0,
     P_MAX_SALARY IN JOBS.MAX_SALARY%TYPE := 1000
    )
IS
    CNT NUMBER := 0; --��������    
BEGIN
    
    SELECT COUNT(*)
    INTO CNT -- CNT�� P_JOB_ID������ ����
    FROM JOBS_IT
    WHERE JOB_ID = P_JOB_ID;
    
    IF CNT = 0 THEN
        -- INSERT
        INSERT INTO JOBS_IT VALUES(P_JOB_ID, P_JOB_TITLE, P_MIN_SALARY, P_MAX_SALARY); --�Ű����� INSERT
    ELSE
        -- UPDATE
        UPDATE JOBS_IT SET JOB_TITLE = P_JOB_TITLE,
                           MIN_SALARY = P_MIN_SALARY,
                           MAX_SALARY = P_MAX_SALARY
        WHERE JOB_ID = P_JOB_ID;
    END IF;
    
    COMMIT;
    
END;
--
EXEC NEW_JOB_PROC('ADMIN', 'ADMINISTRATION', 1000, 20000); --INSERT
EXEC NEW_JOB_PROC('ADMIN', 'ADMINISTRATION DBA', 1000, 30000); --UPDATE

SELECT * FROM JOBS_IT;
-------------------------------------------------------------------------
--OUT�Ű����� - �ܺη� ���� �����ֱ����� �Ű�����
--OUT�Ű������� ����ҷ��� �͸��Ͽ��� ȣ���ؾ� �մϴ�.
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC 
    (P_JOB_ID IN JOBS.JOB_ID%TYPE,
     P_JOB_TITLE IN JOBS.JOB_TITLE%TYPE,
     P_MIN_SALARY IN JOBS.MIN_SALARY%TYPE := 0,
     P_MAX_SALARY IN JOBS.MAX_SALARY%TYPE := 1000,
     P_RESULT OUT NUMBER -- �ƿ��Ű�����
    )
IS
    CNT NUMBER := 0; --��������    
BEGIN
    
    SELECT COUNT(*)
    INTO CNT -- CNT�� P_JOB_ID������ ����
    FROM JOBS_IT
    WHERE JOB_ID = P_JOB_ID;
    
    IF CNT = 0 THEN
        -- INSERT
        INSERT INTO JOBS_IT VALUES(P_JOB_ID, P_JOB_TITLE, P_MIN_SALARY, P_MAX_SALARY); --�Ű����� INSERT
        
        -- �ƿ������� ���� ����
        P_RESULT := 0;
    ELSE
        -- UPDATE
        UPDATE JOBS_IT SET JOB_TITLE = P_JOB_TITLE,
                           MIN_SALARY = P_MIN_SALARY,
                           MAX_SALARY = P_MAX_SALARY
        WHERE JOB_ID = P_JOB_ID;
        
        --�ƿ������� ���� ����
        P_RESULT := CNT;
        
    END IF;
    
    COMMIT;
    
END;
--
DECLARE
    P_RESULT NUMBER;
BEGIN
    NEW_JOB_PROC('ADMIN2', 'ADMINISTRATION', 1000, 20000, P_RESULT);--�Ű������� 5�� (�ƿ��Ű����� �ڸ��� �ܺ� ��������)
    dbms_output.put_line('�ƿ��Ű��������:' || P_RESULT);
END;

SET SERVEROUTPUT ON;
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE TEST_PROC
    (VAR1 IN VARCHAR2,
     VAR2 OUT VARCHAR2,
     VAR3 IN OUT VARCHAR2 --IN OUT�� �Ѵٰ����� �Ű�����
    )
IS 
BEGIN
    dbms_output.put_line(VAR1);
    dbms_output.put_line(VAR2); -- OUT(�Ű����� ������ X)
    dbms_output.put_line(VAR3);

    --VAR1 := '����'; -- IN�Ű������� �Ҵ�Ұ�
    VAR2 := '����2';
    VAR3 := '����3';

END;
--
DECLARE
    A VARCHAR2(30) := 'A'; -- IN 
    B VARCHAR2(30) := 'B'; -- OUT
    C VARCHAR2(30) := 'C'; -- IN OUT
BEGIN
    TEST_PROC(A, B, C);
    dbms_output.put_line(A);
    dbms_output.put_line(B); 
    dbms_output.put_line(C);
END;
-------------------------------------------------------------------------------
--RETURN����� EXCEPTION WHEN OTHERS THEN ����ó��
CREATE OR REPLACE PROCEDURE NEW_JOB_PROC
    (P_JOB_ID IN JOBS_IT.JOB_ID%TYPE
    )
IS 
    CNT NUMBER := 0; --COUNT����
    S_RESULT NUMBER := 0; -- �ִ�޿��� ������ ����
BEGIN
    
    SELECT COUNT(*)
    INTO CNT
    FROM JOBS_IT
    WHERE JOB_ID LIKE '%' || P_JOB_ID || '%';
    
    IF CNT = 0 THEN
        dbms_output.put_line('�ش� ���� �����ϴ�');
        RETURN; --���ν����� ����
    ELSE 
        SELECT SUM(MAX_SALARY)
        INTO S_RESULT
        FROM JOBS_IT
        WHERE JOB_ID LIKE '%' || P_JOB_ID || '%';
        
        dbms_output.put_line('�ִ�޿���:' || S_RESULT);
        
    END IF;
    
    dbms_output.put_line('���ν��� ���� ����');  
    -- ����ó����
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('���ܰ� �߻��߽��ϴ�');      
END;
--
EXEC NEW_JOB_PROC('ADMIN');
EXEC NEW_JOB_PROC('EFGDFGVEFDSDF');









