--제어문
--IF ~~ THEN
--ELSIF ~~ THEN
--ELSE ~~
--END IF;
SET SERVEROUTPUT ON;

DECLARE
    NUM NUMBER := TRUNC( DBMS_RANDOM.VALUE(1, 11) ); --1~11미만의 랜덤한 정수
    NUM2 NUMBER := 5;
BEGIN
    dbms_output.put_line(NUM);
    IF NUM >= NUM2 THEN
        dbms_output.put_line(NUM || '이 큰수 입니다');    
    ELSE 
        dbms_output.put_line(NUM2 || '이 큰수 입니다');    
    END IF;
END;

--ELSE IF
DECLARE
    RAN_NUM NUMBER := TRUNC( DBMS_RANDOM.VALUE(1, 101) ); --1~101미만 랜덤한 정수
BEGIN
    /*
    IF RAN_NUM >= 90 THEN
        dbms_output.put_line('A학점 입니다');    
    ELSIF RAN_NUM >= 80 THEN
        dbms_output.put_line('B학점 입니다');    
    ELSIF RAN_NUM >= 70 THEN
        dbms_output.put_line('C학점 입니다');    
    ELSE
        dbms_output.put_line('D학점 입니다');    
    END IF;
    */
    CASE WHEN RAN_NUM >= 90 THEN dbms_output.put_line('A학점 입니다');
         WHEN RAN_NUM >= 80 THEN dbms_output.put_line('B학점 입니다');
         WHEN RAN_NUM >= 70 THEN dbms_output.put_line('C학점 입니다');
         ELSE dbms_output.put_line('D학점 입니다');
    END CASE;
        
END;
--------------------------------------------------------------------------------
--반복문 WHILE

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
--FOR문
DECLARE
    DAN NUMBER:= 3;
BEGIN

    FOR I IN 1..9 --1~9까지 값을 I에 담는다
    LOOP
        dbms_output.put_line(DAN || ' X ' || I || ' = ' || DAN * I);
    END LOOP;

END;
--탈출문 EXIT WHEN 조건, CONTINUE WHEN 조건
DECLARE
BEGIN
    
    FOR I IN 1..10
    LOOP
        
        CONTINUE WHEN I = 5; -- NUM이 5면 다음으로
        dbms_output.put_line(I);
        -- EXIT WHEN I = 5; -- NUM이 5면 탈출

    END LOOP;
    
END;

--------------------------------------------------------------------------------
--커서 : 질의 수행결과가 여러행일 때 한행씩 처리하는 방법
--반환되는 행이 여러행 이기때문에, 처리가 불가능 (커서를 이용해서 처리)
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
    CURSOR X IS SELECT FIRST_NAME, SALARY FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG'; --1. 커서 선언
BEGIN

    OPEN X; --2. 커서 선언
        dbms_output.put_line('=======커서시작=========');
    LOOP
        FETCH X INTO NM, SALARY; --4. 커서의 데이터를 읽어서 변수에 저장
        EXIT WHEN X%NOTFOUND; --5. 커서에 더이상 읽을 데이터가 없다면 TRUE
        
        dbms_output.put_line(NM);
        dbms_output.put_line(SALARY);
        
    END LOOP;
         dbms_output.put_line('=======커서종료=========');
         dbms_output.put_line('결과레코드수:' || X%ROWCOUNT);
    CLOSE X; -- 3. 커서 종료

END;

--------------------------------------------------------------------------------
--1. 모든 구구단을 출력하는 익명블록을 만드세요
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
--2. 첫번째 값은 ROWNUM을 이용하면 됩니다. 
--조건) 10~120사이의 10단위 랜덤한 번호를 이용해서 랜덤DEPARTMENT_ID 의 첫번째 행만 SELECT합니다.
--조건) 뽑은 사람의 SALARY가 9000이상이면 높음, 5000이상이면 중간, 나머지는 낮음으로 출력.
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

    dbms_output.put_line('급여:' || SALARY);
    IF SALARY >= 9000 THEN
        dbms_output.put_line('높은 급여');
    ELSIF SALARY >= 5000 THEN
        dbms_output.put_line('중간 급여');
    ELSE
        dbms_output.put_line('낮은 급여');
    END IF;

END;
--3. COURSE 테이블에 insert를 100번 실행하는 익명블록을 처리하세요.
--조건) NUM은 COURSE_SEQ를 이용하세요.
CREATE TABLE COURSE(
    NUM     NUMBER(10) NOT NULL, --시퀀스를 이용합니다.
    SUBJECT VARCHAR2(20), 
    CONTENT VARCHAR2(20),
    ID      NUMBER(10)   --반복문의 INDEX 값으로 넣어주세요.
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

--4. 부서벌 급여합을 출력하는 커서구문을 작성해봅시다.
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
        
        dbms_output.put_line('부서명' || DEPT_ID || ', 급여합:' || SALARY);
        
    END LOOP;
    CLOSE CSR;
        
END;

--5. 사원테이블의 연도별 급여합을 구하여 EMP_SAL에 순차적으로 INSERT하는 커서구문을 작성해봅시다.
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
    FOR I IN CSR -- FOR~ IN구문을 쓰면, CURSOR OPEN, CLOSE, FETCH문장으로 자동처리
    LOOP
        --dbms_output.put_line(I.A );
        --dbms_output.put_line(I.B );
        INSERT INTO EMP_SAL VALUES(I.A, I.B);
    END LOOP;
    
END;







