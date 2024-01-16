--뷰란?
--뷰는 제한적인 자료를 보기위해서 미리 만들어 놓은 가상테이블 입니다.
--자주 사용되는 컬럼만 저장해 두면, 관리가 용이해집니다.
--뷰는 물리적으로 데이터가 저장된 형태는 아니고, 원본테이블을 기반으로 한 가상테이블(논리적) 이라고 생각하면 됩니다.

SELECT * FROM USER_SYS_PRIVS; --뷰를 생성하려면 권한이 필요합니다.
SELECT * FROM EMP_DETAILS_VIEW; -- 미리 만들어져 있는 뷰

--뷰 생성 (하나의 테이블로 생성된 뷰를 단순뷰)
CREATE OR REPLACE VIEW VIEW_EMP 
AS (
    SELECT EMPLOYEE_ID AS EMP_ID,
           FIRST_NAME || ' ' || LAST_NAME AS NAME,
           JOB_ID,
           SALARY
    FROM EMPLOYEES 
    WHERE DEPARTMENT_ID = 60
);

SELECT * FROM VIEW_EMP;

--복합 뷰 - 두개 이상의 테이블이 조인을 통해서 만들어진 뷰
CREATE OR REPLACE VIEW VIEW_EMP_JOB 
AS (
    SELECT E.EMPLOYEE_ID,
           FIRST_NAME || ' ' || LAST_NAME AS NAME,
           J.JOB_TITLE,
           D.DEPARTMENT_NAME,
           L.STREET_ADDRESS
    FROM EMPLOYEES E
    JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
    LEFT JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID
);
-- 뷰를 생성하면, 데이터를 손쉽게 조회가 가능합니다.
SELECT JOB_TITLE, COUNT(*) AS CNT
FROM VIEW_EMP_JOB
GROUP BY JOB_TITLE
ORDER BY CNT;

--뷰의 수정 (생성구문과 동일합니다)
CREATE OR REPLACE VIEW VIEW_EMP_JOB 
AS (
    SELECT E.EMPLOYEE_ID,
           FIRST_NAME || ' ' || LAST_NAME AS NAME,
           J.JOB_TITLE,
           J.MAX_SALARY,
           D.DEPARTMENT_NAME,
           L.STREET_ADDRESS
    FROM EMPLOYEES E
    JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
    LEFT JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID
    WHERE D.DEPARTMENT_ID = 60)
    ORDER BY MAX_SALARY DESC;


--뷰의 삭제
DROP VIEW VIEW_EMP_JOB;

--VIEW를 이용한 DML연산 - 가능은 하지만, 많은 제약사항이 따릅니다.
SELECT * FROM VIEW_EMP;
SELECT * FROM VIEW_EMP_JOB;


--NAME이 가상열이기 때문에 INSERT가 불가능합니다.
INSERT INTO VIEW_EMP(EMP_ID, NAME, JOB_ID, SALARY) VALUES(250, 'HONG', 'IT_PROG', 5000);
--원본테이블의 NULL을 허용하지 않는 컬럼이 있어서, 불가능합니다.
INSERT INTO VIEW_EMP(JOB_ID, SALARY) VALUES('IT_PROG', 5000);
--복합뷰는 당연히 안됩니다.
INSERT INTO VIEW_EMP_JOB(EMPLOYEE_ID, JOB_TITLE) VALUES (200, 'TEST');


--뷰의 옵션
--뷰의 생성문장에 마지막에 넣습니다.
--WITH CHECK OPTION - WHERE절에 들어간 컬럼의 변경을 금지합니다.
--WITH READ ONLY - 읽기전용뷰(SELECT) 만 가능하게 합니다.
CREATE OR REPLACE VIEW VIEW_EMP 
AS (
    SELECT EMPLOYEE_ID,
           FIRST_NAME,
           EMAIL,
           JOB_ID,
           DEPARTMENT_ID
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID IN ( 60, 70, 80)
) WITH CHECK OPTION; 

SELECT * FROM VIEW_EMP;
UPDATE VIEW_EMP SET DEPARTMENT_ID = 100 WHERE EMPLOYEE_ID = 103;
--읽기전용 뷰
CREATE OR REPLACE VIEW VIEW_EMP 
AS (
    SELECT EMPLOYEE_ID,
           FIRST_NAME,
           EMAIL,
           JOB_ID,
           DEPARTMENT_ID
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID IN ( 60, 70, 80)
) WITH READ ONLY; 

UPDATE VIEW_EMP SET DEPARTMENT_ID = 100 WHERE EMPLOYEE_ID = 103;

------------------------------------
-- 인라인뷰가 뷰였다




