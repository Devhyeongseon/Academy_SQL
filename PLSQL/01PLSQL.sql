--출력문 사용
SET SERVEROUTPUT ON;

DECLARE
    V_NUM NUMBER; --변수의 선언
    V_NUM2 NUMBER := 2 ** 3 * 3;
BEGIN
    V_NUM := 30; --대입
    
    dbms_output.put_line('변수의값:' || V_NUM);
    dbms_output.put_line('변수의값:' || V_NUM2);
END;

----------------------------------------------
--DML문장과 함께 사용을 할 수 있습니다.
--SELECT -> INSERT, UPDATE 순차적인 DML문장을 실행할 수 있도록 해줍니다.

DECLARE
    EMP_NAME VARCHAR2(30);
    EMP_SALARY NUMBER;
    EMP_LAST_NAME EMPLOYEES.LAST_NAME%TYPE; -- 해당 컬럼과 동일한 변수 타입을 사용함 (VARCAHR2 25)
BEGIN
    
    SELECT FIRST_NAME, SALARY, LAST_NAME
    INTO EMP_NAME, EMP_SALARY, EMP_LAST_NAME -- 조회한 값을 변수에 대입
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
    
    dbms_output.put_line(EMP_NAME ); 
    dbms_output.put_line(EMP_SALARY ); 
    dbms_output.put_line(EMP_LAST_NAME ); 
    
END;

-----------------------------------------------
--년도별 사원의 급여합을 구해서 새로운 테이블에 INSERT
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
    
    dbms_output.put_line('정상 처리되었습니다. 2008급여합:' || EMP_SUM );
END;

--------------------------------------------------------------------------------
--1. 구구단 중 3단을 출력하는 익명 블록을 만들어봅시다. (단순한 출력)
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
--2. 사원 테이블에서 201번 사원의 이름과 이메일주소를 출력하는 익명 블록을 만들어 보자.
DECLARE
    F_NAME EMPLOYEES.FIRST_NAME%TYPE;
    F_EMAIL EMPLOYEES.EMAIL%TYPE;
BEGIN
    SELECT FIRST_NAME, EMAIL
    INTO F_NAME, F_EMAIL
    FROM EMPLOYEES WHERE EMPLOYEE_ID = 201;
    
    DBMS_OUTPUT.PUT_LINE(F_NAME || '님의 이메일은:' || F_EMAIL);   
END;
--3. 사원 테이블에서 사원번호가 제일 큰 사원을 찾아낸 뒤, 
--	 이 번호 +1번으로 아래의 사원을 emps테이블에 employee_id, last_name, email, hire_date, job_id를  신규 입력하는 익명 블록을 만들어 보자.
--<사원명>   : steven
--<이메일>   : stevenjobs
--<입사일자> : 오늘날짜
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

















