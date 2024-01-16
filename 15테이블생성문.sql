--DDL문장 (트랜잭션이 없습니다)
--CREATE, ALTER, DROP문이 있습니다

DROP TABLE DEPTS; -- DEPTS삭제
CREATE TABLE DEPTS(
    DEPT_NO NUMBER(2), -- 숫자 2자리
    DEPT_NAME VARCHAR2(30), -- 30BYTE (한글은 15글자, 숫자 OR 영어는 30글자)
    DEPT_YN CHAR(1), -- 고정문자 1BYTE (VARCHAR2로 대체가능)
    DEPT_DATE DATE, --날짜
    DEPT_BONUS NUMBER(10, 2), -- 전체 숫자 10자리, 소수점 2자리까지 저장
    DEPT_CONTENT LONG -- 2기가 가변문자열( VARCHAR2 보다 더큰 문자열)
);
DESC DEPTS;

INSERT INTO DEPTS VALUES(99, 'HELLO', 'Y', SYSDATE, 3.14, 'HELLO WORLD, HI~~');
INSERT INTO DEPTS VALUES(100, 'HELLO', 'N', SYSDATE, 3.14, 'BYE~'); -- DEPT_NO 초과
INSERT INTO DEPTS VALUES(1, 'HELLO', '가', SYSDATE, 3.14, 'BYE~'); -- CHAR(1) 초과 (한글은 2바이트)

SELECT * FROM DEPTS;
--------------------------------------------------------------------------------
--테이블 구조 변경 ALTER

--컬럼추가
ALTER TABLE DEPTS ADD (DEPT_COUNT NUMBER(3) );
SELECT * FROM DEPTS;

--컬럼명칭 변경
ALTER TABLE DEPTS RENAME COLUMN DEPT_COUNT TO EMP_COUNT; --> DEPT_COUNT -> EMP_COUNT로 변경
DESC DEPTS;

--컬럼 수정(크기)
ALTER TABLE DEPTS MODIFY (EMP_COUNT NUMBER(10) ); -- EMP_COUNT컬럼의 타입을 변경
ALTER TABLE DEPTS MODIFY (EMP_COUNT NUMBER(2)  ); -- EMP_COUNT컬럼의 타입을 변경
ALTER TABLE DEPTS MODIFY (DEPT_NAME VARCHAR2(1)); -- 기존데이터가 변경할 크기를 넘어가는 경우, 변경불가.
SELECT * FROM DEPTS;

--컬럼 삭제(DROP COLUMN )
ALTER TABLE DEPTS DROP COLUMN EMP_COUNT;
--------------------------------------------------------------------------------
DROP TABLE DEPTS;
DROP TABLE DEPARTMENTS; -- 제약조건이라는 개념이 있어서, 테이블이 한번에 삭제될 수 없습니다.

--------------------------------------------------------------------------------
--테이블명 DEPT2
--DEPT_NO 숫자타입 3글자
--DEPT_NAME 가변형문자 15바이트
--LOCA_NUMBER 숫자타입 4글자
--DEPT_GENDER 고정문자 1글자
--REG_DATE 날짜타입
--DEPT_BONUS 실수 5자리까지

-- 가짜 데이터 INSERT








