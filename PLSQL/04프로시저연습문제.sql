--1. 프로시저명 GUGUPROC
--- 구구단 을 입력받아 해당 단수를 출력하는 procedure을 생성하고 실행하세요
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
--2. 프로시저명 EMP_YEAR_PROC
--- EMPLOYEE_ID를 받아서 EMPLOYEES에 존재하면, "근속년수를 출력" 하고, 없다면 "EMPLOYEE_ID는 없습니다" 를 출력하는 프로시저
--- 예외처리도 작성해주세요.
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
        dbms_output.put_line('해당 아이디는 없습니다');
    ELSE
        SELECT TRUNC( (SYSDATE - HIRE_DATE) / 365 ) AS YEARS 
        INTO YEARS
        FROM EMPLOYEES WHERE EMPLOYEE_ID = EMP_ID;
        
        dbms_output.put_line('근속년수:' || YEARS);
    END IF;

    EXCEPTION WHEN OTHERS THEN 
        dbms_output.put_line('예외가 발생했습니다');
END;

EXEC EMP_YEAR_PROC(100);
EXEC EMP_YEAR_PROC(2344);

--3. 프로시저명 DEPTS_PROC
--- 부서번호, 부서명, 작업 flag(I: insert, U:update, D:delete)을 매개변수로 받아 
--DEPTS테이블에 각각 flag가 i면 INSERT, u면 UPDATE, d면 DELETE 하는 프로시저를 생성합니다.
--- 그리고 정상종료라면 commit, 예외라면 롤백 처리하도록 처리하세요.
--- 예외처리도 작성해주세요.
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
        dbms_output.put_line('예외가 발생했습니다');
        ROLLBACK;
    
END;
--4. 프로시저명 EMP_AGE_PROC
--- employee_id를 입력받아 employees에 존재하면, 근속년수를 out하는 프로시저를 작성하세요.
--- 예외처리도 작성해주세요.
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
        INTO EMP_YEARS --OUT변수
        FROM EMPLOYEES WHERE EMPLOYEE_ID = EMP_ID;
        
    END IF;
    
    EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('예외가 발생했습니다');
    
END;
--
DECLARE
    RESULT NUMBER;
BEGIN
    EMP_AGE_PROC(101, RESULT);
    dbms_output.put_line(RESULT);
END;
--5. 프로시저명 - EMP_MERGE_PROC
--- employees 테이블의 복사 테이블 emps를 생성합니다.
--- employee_id, last_name, email, hire_date, job_id를 입력받아 존재하면 이름, 이메일, 입사일, 직업을 update, 
--없다면 insert하는 merge문을 작성하세요
--- 힌트 (MERGE INTO 테이블 USING 조건 WHEN MATCHED THEN 업데이트 WHEN NOT MATCHED THEN 인서트 )
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
--6. 프로시저명 - SALES_PROC
--- sales테이블은 오늘의 판매내역이다.
--- day_of_sales테이블은 판매내역 마감시 오늘 일자의 총매출을 기록하는 테이블이다.
--- 마감시 sales의 오늘날짜 판매내역을 집계하여 day_of_sales에 집계하는 프로시저를 생성해보세요.
--조건) day_of_sales의 마감내역이 이미 존재하면 업데이트 처리
CREATE TABLE SALES(
    SNO NUMBER(5) CONSTRAINT SALES_PK PRIMARY KEY, -- 번호
    NAME VARCHAR2(30), -- 상품명
    TOTAL NUMBER(10), --수량
    PRICE NUMBER(10), --가격
    REGDATE DATE DEFAULT SYSDATE --날짜
);

CREATE TABLE DAY_OF_SALES(
    REGDATE DATE,
    FINAL_TOTAL NUMBER(10)
);

INSERT INTO SALES VALUES(1, '아이스아메리카', 1, 1000, SYSDATE);
INSERT INTO SALES VALUES(2, '나떼는', 2, 2000, SYSDATE);
INSERT INTO SALES VALUES(3, '자바칩', 3, 3000, SYSDATE);

-----------------------------------
CREATE OR REPLACE PROCEDURE SALES_PROC(
    P_REGDATE IN DATE
)
IS
    TOTAL_COUNT NUMBER := 0; --총금액
    CNT NUMBER := 0;
BEGIN
    --1.오늘날짜 데이터의 금액총합
    SELECT SUM(TOTAL * PRICE)
    INTO TOTAL_COUNT
    FROM SALES
    WHERE TO_CHAR(REGDATE, 'YYYY-MM-DD') = TO_CHAR(P_REGDATE, 'YYYY-MM-DD');
    --2.마감테이블에 오늘날짜 데이터가 있는지 확인
    SELECT COUNT(*)
    INTO CNT
    FROM DAY_OF_SALES
    WHERE TO_CHAR(REGDATE, 'YYYY-MM-DD') = TO_CHAR(P_REGDATE, 'YYYY-MM-DD');
    --3. CNT = 0면 INSERT CNT가 0이 아니면 UPDATE
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

















