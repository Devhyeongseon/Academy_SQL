--시퀀스(순차적으로 증가하는 값) *
SELECT * FROM USER_SEQUENCES;

--생성
CREATE SEQUENCE DEPTS_SEQ; -- 기본값으로 지정되면서 시퀀스가 생성됩니다.
DROP SEQUENCE DEPTS_SEQ; -- 삭제

CREATE SEQUENCE DEPTS_SEQ 
    INCREMENT BY 1
    START WITH 1
    MAXVALUE 10
    NOCYCLE  -- 시퀀스가 MAX에 도달했을 때 재사용 X
    NOCACHE; -- 캐시에 시퀀스를 두지 않겠음

-- 시퀀스는 일반적으로 PK에 자동증가하는 값으로 적용이 됩니다.
DROP TABLE DEPTS;
CREATE TABLE DEPTS(
    DEPT_NO NUMBER(2) CONSTRAINT DEPTS_NO_PK PRIMARY KEY,
    DEPT_NAME VARCHAR2(30),
    DEPT_DATE DATE
);
--시퀀스의 사용방법 2개 *
SELECT DEPTS_SEQ.CURRVAL FROM DUAL; --NEXTVAL가 한번 실행이 되고 나서 확인이 가능합니다.
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL; --한번 NEXTVAL가 일어나면, 후진은 불가능합니다.

INSERT INTO DEPTS VALUES( DEPTS_SEQ.NEXTVAL , 'TEST', SYSDATE ); --MAXVALUE가 10이 되면, 더 이상 사용이 불가능합니다.
SELECT * FROM DEPTS;

--시퀀스 수정(CREATE가 ALTER로만 바뀝니다)
ALTER SEQUENCE DEPTS_SEQ MAXVALUE 1000;
ALTER SEQUENCE DEPTS_SEQ MAXVALUE 10000;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 10 MINVALUE 1; -- 증가값 10, 최소값 1

SELECT * FROM USER_SEQUENCES;

--시퀀스가 이미 사용되고 있다면, DROP하면 안됩니다.
--주기적으로 시퀀스를 초기화 한다면?
--시퀀스 초기화 방법

--시퀀스 증가값을 -현재값음수로 바꾸고
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY -39 MINVALUE 0;
--한번 전진을 시키고
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL;
--다시 증가값을 양수값으로 바꿈
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 1;
---------------------------------------
--시퀀스 응용
--PK의 저장을 문자열로 지정 2023-12-시퀀스값
CREATE SEQUENCE DEPTS2_SEQ NOCACHE;

SELECT TO_CHAR( SYSDATE, 'YYYY-MM-' ), 
       LPAD('X', 5, '0'),
       TO_CHAR( SYSDATE, 'YYYY-MM-') || LPAD(DEPTS2_SEQ.NEXTVAL, 5, '0' ) AS NO
FROM DUAL;

--시퀀스 삭제
DROP SEQUENCE 시퀀스명;

--------------------------------------------------------------------------------
--인덱스
--INDEX는 PRIMARY KEY, UNIQUE 제약에 자동으로 생성되고, 조회를 빠르게 하는 HINT역할을 합니다
--INDEX의 종류로는 고유인덱스, 비고유인덱스 가 있습니다.
--UNIQUE한 컬럼에는 UNIQUE인덱스(고유인덱스)가 들어갈 수 있습니다.
--일반컬럼에는 비고유 인덱스를 지정할 수 있습니다.
--INDEX는 조회를 빠르게 하지만, 무작위하게 많이 사용되는 것은 오히려 성능저하를 부를 수 있습니다.
--주로 사용되는 컬럼중에서 SELECT절의 속도저하가 있다면, 먼저 고려해볼 내용중 하나가 INDEX 입니다.
CREATE TABLE EMPS_IT AS (SELECT * FROM EMPLOYEES);
SELECT * FROM EMPS_IT; 

--인덱스가 없을떄 속도
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy'; 
--비 고유 인덱스를 생성
CREATE INDEX EMPS_IT_IDX ON EMPS_IT(FIRST_NAME);
--인덱스 생성후 속도
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy'; 
--인덱스 삭제(테이블 자체에 영향을 미치지 않습니다)
DROP INDEX EMPS_IT_IDX;
--인덱스는 여러 컬럼을 묶어서(결합인덱스) 생성할 수도 있습니다.
CREATE INDEX EMPS_IT_IDX ON EMPS_IT(FIRST_NAME, LAST_NAME);
--
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy'; --힌트를 받음
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'Nancy' AND LAST_NAME = 'Greenberg'; --힌트를 받음
SELECT * FROM EMPS_IT WHERE LAST_NAME = 'Greenberg'; --힌트를 못받음

--오라클의 힌트절 (인덱스를 이용해서 조회 순서에 힌트를 줌)

--힌트를 받지 못하고 조회
SELECT ROWNUM AS RN,
       D.*
FROM DEPTS D
ORDER BY DEPT_NO DESC;
--원래구문
SELECT ROWNUM AS RN,
       D.*
FROM (
    SELECT *
    FROM DEPTS
    ORDER BY DEPT_NO DESC
) D;
--인덱스 힌트를 받아서 조회
SELECT /*+ INDEX_DESC(D DEPTS_NO_PK) */
       ROWNUM AS RN,
       D.*
FROM DEPTS D
ORDER BY DEPT_NO DESC;
--------------------------------------------------------------------------------






































