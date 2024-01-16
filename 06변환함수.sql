
--형변환함수

--자동형변환
SELECT * FROM EMPLOYEES;
SELECT * FROM EMPLOYEES WHERE SALARY >= '10000'; -- 문자 -> 숫자 자동형변환
SELECT * FROM EMPLOYEES WHERE HIRE_DATE >= '05/01/01'; -- 문자 -> 날짜 자동형변환

--강제형변환
--TO_CHAR -> 날짜, 문자로 강제 형변환, 날짜 포맷형식이 쓰입니다
SELECT TO_CHAR(SYSDATE) FROM DUAL; 
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') AS TIME FROM DUAL; 
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD') AS TIME FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD AM') AS TIME FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"') FROM DUAL; -- 데이트 포맷형식이 아닌값을 쓰려면 "" 로 묶어줍니다

SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') FROM EMPLOYEES;

--TO_CHAR -> 숫자, 문자로 강제 형변환, 숫자 포맷형식이 쓰입니다 (9 0 , . $ L )
SELECT TO_CHAR(20000, '9999999999'), 20000 FROM DUAL; --문자 10자리로 변경
SELECT TO_CHAR(20000, '0999999999'), 20000 FROM DUAL; --남는 자리를 0으로 채움
SELECT TO_CHAR(20000, '9999'), 20000 FROM DUAL; --자리수가 부족하면 #으로 처리 됩니다.
SELECT TO_CHAR(20000.123, '99,999.999' ) FROM DUAL; -- 소수점은 .으로 나타냅니다.   ,는 그냥 쓰면 됩니다
SELECT TO_CHAR(20000, '$999999') AS A FROM DUAL; -- $도 그냥 쓰면 됩니다
SELECT TO_CHAR(20000, 'L99999') AS A FROM DUAL;  -- L지역화폐 기호

-- 오늘의 환율이 1302.69원 입니다
-- SALARY컬럼을 한국돈으로 변경해서 소수점 2자리수까지 출력
SELECT TO_CHAR(SALARY * 1302.69, 'L999,999,999.99') FROM EMPLOYEES;

--TO_NUMBER -> 문자, 숫자로 강제 형변환
SELECT '2000' + 2000 FROM DUAL; -- 자동형변환
SELECT TO_NUMBER('2000') + 2000 FROM DUAL; -- 명시적형변환

SELECT '$5,000' + 2000 FROM DUAL; -- 에러
SELECT TO_NUMBER('$5,000', '$9,999') + 2000 FROM DUAL; --숫자로 변환이 가능한 문자일 경우, 숫자FMT을 이용해서 자리를 맞추면 됩니다.

--TO_DATE -> 문자, 날짜로 강제 형변환
SELECT TO_DATE('2023-12-04') FROM DUAL; --날짜로 형변환
SELECT SYSDATE - TO_DATE('2023-12-03') FROM DUAL; --날짜로 변환해야 일자가 나옵니다.
SELECT TO_DATE('2023/12/04', 'YYYY/MM/DD') FROM DUAL;
SELECT TO_DATE('2023년12월04일', 'YYYY"년"MM"월"DD"일"') FROM DUAL; --날짜포멧문자가 아닌 문자는 ""로 감싸줍니다.
SELECT TO_DATE('2024-12-04 02:30:23', 'YYYY-MM-DD HH:MI:SS') FROM DUAL; --자리에 맞춰서 포멧형식을 적어줍니다.

-- XXXX년XX월XX일 로 변환
SELECT '20050102' FROM DUAL;
SELECT TO_CHAR(TO_DATE('20050102', 'YYYYMMDD'), 'YYYY"년"MM"월"DD"일"') AS A FROM DUAL;

------------------------------------------------------------------------
--NULL처리함수들 

--NVL(값, NULL일경우 대체할값) *
SELECT NVL(NULL, 0) FROM DUAL; -- NULL일 경우 0으로 변환됨
SELECT NVL(300, 0) FROM DUAL;  -- NULL이 아닐경우 그대로 출력됨

SELECT NULL * 3000 + 1000 FROM DUAL; -- NULL에 연산이 들어갈 경우는 NULL이 나옵니다
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT FROM EMPLOYEES; -- NULL에 연산이 들어갈 경우는 NULL이 나옵니다
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * NVL(COMMISSION_PCT, 0) FROM EMPLOYEES;

--NVL2(값, NULL이 아닐경우 대체할값, NULL일 경우 대체할값) *
SELECT NVL2(300, 'NULL이 아닙니다', 'NULL입니다') FROM DUAL;

SELECT FIRST_NAME, NVL2(COMMISSION_PCT, 'TRUE', 'FALSE') FROM EMPLOYEES;
SELECT FIRST_NAME, SALARY, NVL2(COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT, SALARY ) FROM EMPLOYEES;

--DECODE(값, 비교값, 결과값, 나열..., ELSE문) *
SELECT DECODE('A', 'A', 'A입니다', 'A가아닙니다' ) FROM DUAL; -- IF ~ELSE
SELECT DECODE('B', 'A', 'A입니다',
                   'B', 'B입니다',
                   'C', 'C입니다',
                   '전부아닙니다') FROM DUAL;

SELECT FIRST_NAME, 
       JOB_ID,
       DECODE(JOB_ID, 'AD_VP', SALARY * 1.1,
                      'IT_PROG', SALARY * 1.2,
                      'FI_MGR', SALARY * 1.3,
                      SALARY) AS 급여
FROM EMPLOYEES;

--CASE ~WHEN ~THEN ~ELSE ~ END 구문 (SWICH문장과 비슷함) *
--1ST
SELECT FIRST_NAME,
       JOB_ID,
       SALARY,
       CASE JOB_ID WHEN 'AD_VP' THEN SALARY * 1.1
                   WHEN 'IT_PROG' THEN SALARY * 1.2
                   WHEN 'FI_MGR' THEN SALARY * 1.3
                   ELSE SALARY
       END AS 급여
FROM EMPLOYEES;

--2ED
SELECT FIRST_NAME,
       JOB_ID,
       SALARY,
       CASE WHEN JOB_ID = 'AD_VP' THEN SALARY * 1.1
            WHEN JOB_ID = 'IT_PROG' THEN SALARY * 1.2
            WHEN JOB_ID = 'FI_MGR' THEN SALARY * 1.3
            ELSE SALARY
       END AS 급여
FROM EMPLOYEES;

SELECT CASE WHEN SALARY >= 10000 THEN '상'
            WHEN SALARY >= 5000 THEN '중'
            ELSE '하'
       END AS 급여
FROM EMPLOYEES;

-- COALESCE(값, 값, ...) 코얼레스 - NULL이 아닌 첫번째 인자값을 반환함
SELECT COALESCE(NULL, 'A', 'B') FROM DUAL;  -- A
SELECT COALESCE(NULL, NULL, 'B') FROM DUAL; -- B
SELECT COALESCE(NULL, 'B', 'C', NULL) FROM DUAL; -- B
SELECT COALESCE(NULL, NULL, NULL, NULL) FROM DUAL; -- NULL
SELECT COMMISSION_PCT, COALESCE(COMMISSION_PCT, 0 ) FROM EMPLOYEES; -- NVL과 비슷

---------------------------------------------------------------------------------
--연습문제

--문제 1.
--현재일자를 기준으로 EMPLOYEE테이블의 입사일자(hire_date)를 참조해서 근속년수가 10년 이상인
--사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성해 보세요. 
--조건 1) 근속년수가 높은 사원 순서대로 결과가 나오도록 합니다
SELECT EMPLOYEE_ID AS 사원번호, 
       CONCAT(FIRST_NAME, LAST_NAME) AS 이름,
       HIRE_DATE AS 입사일자,
       TRUNC((SYSDATE - HIRE_DATE) / 365) AS 근속년수
FROM EMPLOYEES
WHERE TRUNC((SYSDATE - HIRE_DATE) / 365) >= 10 --10년이상
ORDER BY 근속년수 DESC;
       
--문제 2.
--EMPLOYEE 테이블의 manager_id컬럼을 확인하여 first_name, manager_id, 직급을 출력합니다.
--100이라면 ‘사원’, 
--120이라면 ‘주임’
--121이라면 ‘대리’
--122라면 ‘과장’
--나머지는 ‘임원’ 으로 출력합니다.
--조건 1) 부서가 50인 사람들을 대상으로만 조회합니다
SELECT FIRST_NAME, 
       DECODE(MANAGER_ID, 100, '사원', 120, '주임', 121, '대리', 122, '과장', '임원') AS 직급,
       JOB_ID 
FROM EMPLOYEES;

SELECT FIRST_NAME, 
       CASE MANAGER_ID WHEN 100 THEN  '사원'
                       WHEN 120 THEN  '주임'
                       WHEN 121 THEN  '대리'
                       WHEN 122 THEN  '과장'
                       ELSE '임원'
       END AS 직급,
       JOB_ID 
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 50;






















