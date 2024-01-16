--문제 1.
---EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 데이터를 출력 하세요 ( AVG(컬럼) 사용)
---EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 수를 출력하세요
SELECT COUNT(*)
FROM EMPLOYEES
WHERE SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEES);
---EMPLOYEES 테이블에서 job_id가 IT_PFOG인 사원들의 평균급여보다 높은 사원들을 데이터를 출력하세요
SELECT *
FROM EMPLOYEES
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG');

--문제 2.
---DEPARTMENTS테이블에서 manager_id가 100인 사람의 department_id와
--EMPLOYEES테이블에서 department_id가 일치하는 모든 사원의 정보를 검색하세요.
SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE MANAGER_ID = 100;

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE MANAGER_ID = 100);
--문제 3.
---EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 출력하세요
SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Pat';
SELECT *
FROM EMPLOYEES
WHERE MANAGER_ID > (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Pat');

---EMPLOYEES테이블에서 “James”(2명)들의 manager_id와 같은 모든 사원의 데이터를 출력하세요.
SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'James';
SELECT *
FROM EMPLOYEES
WHERE MANAGER_ID IN (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'James');

--문제 4.
---EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 행 번호, 이름을 출력하세요
SELECT *
FROM(SELECT ROWNUM AS RN,
            A.*
       FROM (SELECT * 
              FROM EMPLOYEES
              ORDER BY FIRST_NAME DESC) A
)
WHERE RN > 40 AND RN <= 50;
--문제 5.
---EMPLOYEES테이블에서 hire_date기준으로 오름차순 정렬하고, 31~40번째 데이터의 행 번호, 사원id, 이름, 번호, 입사일을 출력하세요.
SELECT *
FROM (SELECT ROWNUM AS RN,
             EMPLOYEE_ID,
             FIRST_NAME,
             PHONE_NUMBER,
             HIRE_DATE
       FROM (SELECT *
             FROM EMPLOYEES
             ORDER BY HIRE_DATE)
)
WHERE RN > 30 AND RN <=40;
--문제 6.
--employees테이블 departments테이블을 left 조인하세요
--조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
--조건) 직원아이디 기준 오름차순 정렬
SELECT CONCAT(FIRST_NAME, LAST_NAME) AS NAME,
       E.DEPARTMENT_ID,
       D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY EMPLOYEE_ID;
--문제 7.
--문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT CONCAT(FIRST_NAME, LAST_NAME) AS NAME,
       E.DEPARTMENT_ID,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS DEPARTMENT_NAME
FROM EMPLOYEES E
ORDER BY EMPLOYEE_ID;

--문제 8.
--departments테이블 locations테이블을 left 조인하세요
--조건) 부서아이디, 부서이름, 매니저아이디, 로케이션아이디, 스트릿_어드레스, 포스트 코드, 시티 만 출력합니다
--조건) 부서아이디 기준 오름차순 정렬
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

SELECT D.DEPARTMENT_ID,
       D.DEPARTMENT_NAME,
       D.MANAGER_ID,
       D.LOCATION_ID,
       L.STREET_ADDRESS,
       L.POSTAL_CODE,
       L.CITY
FROM DEPARTMENTS D
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID
ORDER BY DEPARTMENT_ID;
--문제 9.
--문제 8의 결과를 (스칼라 쿼리)로 동일하게 조회하세요

SELECT D.DEPARTMENT_ID,
       D.DEPARTMENT_NAME,
       D.MANAGER_ID,
       D.LOCATION_ID,
       (SELECT STREET_ADDRESS FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) AS ST,
       (SELECT POSTAL_CODE FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) AS PC,
       (SELECT CITY FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) AS CT
FROM DEPARTMENTS D
ORDER BY DEPARTMENT_ID;
--문제 10.
--locations테이블 countries 테이블을 left 조인하세요
--조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다
--조건) country_name기준 오름차순 정렬
SELECT * FROM LOCATIONS;
SELECT * FROM COUNTRIES;

SELECT L.LOCATION_ID,
       L.STREET_ADDRESS,
       L.CITY,
       L.COUNTRY_ID,
       C.COUNTRY_NAME
FROM LOCATIONS L
LEFT JOIN COUNTRIES C
ON L.COUNTRY_ID = C.COUNTRY_ID
ORDER BY COUNTRY_NAME;
--문제 11.
--문제 10의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT L.LOCATION_ID,
       L.STREET_ADDRESS,
       L.CITY,
       L.COUNTRY_ID,
       (SELECT COUNTRY_NAME FROM COUNTRIES C WHERE C.COUNTRY_ID = L.COUNTRY_ID) AS COUNTRY_NAME
FROM LOCATIONS L
ORDER BY COUNTRY_NAME;
--문제 12
--employees테이블, departments테이블을 left조인 hire_date를 오름차순 기준으로 1-10번째 데이터만 출력합니다
--조건) rownum을 적용하여 번호, 직원아이디, 이름, 전화번호, 입사일, 부서아이디, 부서이름 을 출력합니다.
--조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 틀어지면 안됩니다.
/*
SELECT *
FROM (
    SELECT ROWNUM AS RN,
           A.*
    FROM(
        SELECT E.EMPLOYEE_ID,
               CONCAT(FIRST_NAME, LAST_NAME) AS NAME,
               PHONE_NUMBER,
               HIRE_DATE,
               D.DEPARTMENT_NAME
        FROM EMPLOYEES E
        LEFT JOIN DEPARTMENTS D
        ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY HIRE_DATE
    ) A
)
WHERE RN > 0 AND RN <= 10;
*/
SELECT B.*,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE B.DEPARTMENT_ID = D.DEPARTMENT_ID)
FROM (
    SELECT ROWNUM AS RN,
           A.*
    FROM (
        SELECT EMPLOYEE_ID,
               CONCAT(FIRST_NAME, LAST_NAME) AS NAME,
               PHONE_NUMBER,
               HIRE_DATE,
               DEPARTMENT_ID
        FROM EMPLOYEES
        ORDER BY HIRE_DATE
    ) A
) B
WHERE RN > 0 AND RN <= 10;

--문제 13. 
--EMPLOYEES 과 DEPARTMENTS 테이블에서 JOB_ID가 SA_MAN 사원의 정보의 LAST_NAME, JOB_ID, DEPARTMENT_ID,DEPARTMENT_NAME을 출력하세요
SELECT LAST_NAME,
       JOB_ID,
       DEPARTMENT_ID,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID)
FROM EMPLOYEES E
WHERE JOB_ID = 'SA_MAN';

--
SELECT E.LAST_NAME,
       E.JOB_ID,
       E.DEPARTMENT_ID,
       D.DEPARTMENT_NAME
FROM (
     SELECT LAST_NAME,
            JOB_ID,
            DEPARTMENT_ID
     FROM EMPLOYEES
     WHERE JOB_ID = 'SA_MAN'
     ) E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

--문제 14
--DEPARTMENT테이블에서 각 부서의 ID, NAME, MANAGER_ID와 부서에 속한 인원수를 출력하세요.
--인원수 기준 내림차순 정렬하세요.
--사람이 없는 부서는 출력하지 뽑지 않습니다

--부서의 인원수 먼저 구한다
--이테이블을 조인한다.
SELECT *
FROM (
    SELECT DEPARTMENT_ID, 
           COUNT(*) AS CNT
    FROM EMPLOYEES
    GROUP BY DEPARTMENT_ID
) E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY CNT DESC;

--문제 15
--부서에 대한 정보 전부와, 주소, 우편번호, 부서별 평균 연봉을 구해서 출력하세요
--부서별 평균이 없으면 0으로 출력하세요
SELECT DEPARTMENT_ID,
       AVG(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

SELECT D.*,
       L.STREET_ADDRESS,
       L.POSTAL_CODE,
       NVL((SELECT AVG(SALARY) FROM EMPLOYEES E WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID GROUP BY DEPARTMENT_ID ), 0) AS AVG
FROM DEPARTMENTS D
LEFT JOIN LOCATIONS L
ON D.LOCATION_ID = L.LOCATION_ID;

--문제 16
--문제 15결과에 대해 DEPARTMENT_ID기준으로 내림차순 정렬해서 ROWNUM을 붙여 1-10데이터 까지만
--출력하세요

SELECT *
FROM (
    SELECT ROWNUM AS RN,
           A.*     
    FROM (
          SELECT D.*,
                 L.STREET_ADDRESS,
                 L.POSTAL_CODE,
                 NVL((SELECT AVG(SALARY) FROM EMPLOYEES E WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID GROUP BY DEPARTMENT_ID ), 0) AS AVG
          FROM DEPARTMENTS D
          LEFT JOIN LOCATIONS L
          ON D.LOCATION_ID = L.LOCATION_ID
          ORDER BY DEPARTMENT_ID DESC
    ) A
)
WHERE RN > 0 AND RN <= 10;





