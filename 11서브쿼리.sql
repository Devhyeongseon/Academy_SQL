--서브쿼리

--단일행 서브쿼리 - SELECT한 결과가 1행인 서브쿼리
--서브쿼리의 문법은 ()로 반드시 묶는다, 연산자보다 오른쪽에 위치함

--낸시의 급여보다 높은 급여를 받는 사람
SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy';

SELECT *
FROM EMPLOYEES
WHERE SALARY >= (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Nancy');

--EMPLOYEE_ID가 103번인 사람과 동일한 직군인 사람
SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103;

SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 103);

--주의할 점 - 비교할 컬럼은 정확히 한개여야 합니다.
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 103 );

--주의할 점 - 여러행이 나온는 구문이라면, 다중행 서브쿼리 구문으로 작성이 들어가야 합니다. (처리할 방법이 있음)
SELECT *
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');

---------------------------------------------------------------------------------------------------------
--다중행 서브쿼리 - 여러행이 리턴되는 서브쿼리
--IN, ANY(SOME), ALL

SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME = 'David';

-- 4800, 6800, 9500중 4800보다 큰 데이터는 다나옴 (최소값 보다 큰 데이터)
SELECT *
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David'); --SOME 으로 써도 동일함

-- 9500보다 작은 데이터는 다나옴 (최대값 보다 작은 데이터)
SELECT *
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- 9500보다 큰 데이터는 다나옴( 최대값 보다 큰 데이터 )
SELECT *
FROM EMPLOYEES
WHERE SALARY > ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- 4800보다 작은 데이터 다나옴 (최소값 보다 작은 데이터)
SELECT *
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');

-- IN 다중행 데이터중, 일치하는 데이터가 다 나옴
SELECT *
FROM EMPLOYEES
WHERE SALARY IN (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'David');  -- 4800, 6800, 9500 
                
-- STEVEN과 동일한 부서번호를 가지는 사람들
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');

-- STEVEN과 DAVID와 동일한 JOB을 가지는 사람들 UNION ALL
SELECT *
FROM EMPLOYEES 
WHERE JOB_ID IN (SELECT JOB_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven'
                 UNION ALL
                 SELECT JOB_ID FROM EMPLOYEES WHERE FIRST_NAME = 'David');

--------------------------------------------------------------------------------
--스칼라 쿼리 - SELECT문에 서브쿼리가 들어가는 문장

--JOIN DEPARTEMENT_NAME
SELECT E.FIRST_NAME,
       D.DEPARTMENT_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY FIRST_NAME;
--스칼라
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) AS DEPARTMENT_NAME
FROM EMPLOYEES E
ORDER BY FIRST_NAME;

--스칼라쿼리는 한번에 하나의 컬럼을 가지고 옵니다. 많은 열을 가지고 올때는 가독성이 떨어질 수 있습니다
SELECT FIRST_NAME,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID),
       (SELECT MANAGER_ID FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
FROM EMPLOYEES E;

--스칼라쿼리는 다른테이블의 1개의 컬럼을 가지고 올 때, JOIN보다 유리합니다.
--부서명을 가지고 오고, 직무명을 출력합니다.
SELECT E.*, -- E테이블의 전부다
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS D WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID),
       (SELECT JOB_TITLE FROM JOBS J WHERE J.JOB_ID = E.JOB_ID)
FROM EMPLOYEES E;

--스칼라쿼리 (조인을 대체가능)
--스칼라쿼리가 조인보다 느린경우
--1) 데이터가 많을 때
--2) 컬럼(인덱스) 를 참조할 수 있다면, 스칼라가 유리, 인덱스 참조가 안되는 경우 조인이 유리함 

--------------------------------------------------------------------------------------------
--인라인 뷰 - FROM하위에 서브쿼리절이 들어갑니다.
--인라인 뷰에서 만든 가상 컬럼에 대해서 조회를 해나갈 때 사용합니다.
SELECT *
FROM (SELECT *
      FROM (SELECT * 
            FROM EMPLOYEES));

-- ROWNUM은 조회된 순서에 대해 번호가 붙기 때문에, ORDER를 시키면 순서가 뒤바뀝니다.
SELECT ROWNUM, 
       FIRST_NAME,
       SALARY
FROM EMPLOYEES 
ORDER BY SALARY DESC;
-- 인라인 뷰로 해결 ( ROWNUM은 반드시 1번 부터만 조회가 됩니다)
SELECT FIRST_NAME,
       SALARY,
       ROWNUM AS RN
FROM (SELECT FIRST_NAME,
             SALARY
        FROM EMPLOYEES
        ORDER BY SALARY DESC)
WHERE ROWNUM > 10 AND ROWNUM <= 20; -- WHERE ROWNUM <= 10;      

-- 인라인 뷰로 해결 (ROWNUM을 컬럼화 시키고 다시 인라인뷰를 사용합니다)
SELECT *
FROM (SELECT FIRST_NAME,
               SALARY,
               ROWNUM AS RN
        FROM (SELECT FIRST_NAME,
                     SALARY
                FROM EMPLOYEES
                ORDER BY SALARY DESC)
      )
WHERE RN > 10 AND RN <= 20;

--예시
SELECT A.*
FROM (SELECT FIRST_NAME || ' ' || LAST_NAME AS NAME,
               TO_CHAR(SALARY + SALARY * NVL(COMMISSION_PCT, 0)  , 'L999,999,999') AS SALARY,
               NVL(COMMISSION_PCT, 0) AS COMMISSION_PCT,
               TO_CHAR(HIRE_DATE, 'YYYY"년"MM"월"DD"일"') AS HIRE_DATE,
               TRUNC((SYSDATE - HIRE_DATE) / 365) AS 근속년수
        FROM EMPLOYEES
        ORDER BY 근속년수
      ) A
WHERE MOD(근속년수, 5) = 0;

-----------------------------------------------------------------------------------------------
-- 조인과 서브쿼리
-- 인라인 뷰는 하나의 테이블이 되기 때문에, 테이블 자리에 들어갈 수 있음.

-- DEPARTMENTS테이블에 MANGER_ID가 NULL이 아닌 데이터들을 구해서, EMPLOYEES테이블에 조인
-- 10~20번째 행 데이터만 구한다.
SELECT * FROM EMPLOYEES;
--
SELECT *
FROM (
     SELECT ROWNUM AS RN,
               A.*
     FROM (
           SELECT *
           FROM EMPLOYEES E
           LEFT JOIN (SELECT *
                        FROM DEPARTMENTS
                       WHERE MANAGER_ID IS NOT NULL) D
           ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
      ) A
)
WHERE RN > 10 AND RN <= 20;
----------------------
SELECT *
FROM (SELECT *
        FROM DEPARTMENTS
        WHERE MANAGER_ID IS NOT NULL) D
RIGHT JOIN EMPLOYEES E
ON D.DEPARTMENT_ID = E.DEPARTMENT_ID;
























