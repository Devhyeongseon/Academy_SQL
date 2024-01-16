
--����ȯ�Լ�

--�ڵ�����ȯ
SELECT * FROM EMPLOYEES;
SELECT * FROM EMPLOYEES WHERE SALARY >= '10000'; -- ���� -> ���� �ڵ�����ȯ
SELECT * FROM EMPLOYEES WHERE HIRE_DATE >= '05/01/01'; -- ���� -> ��¥ �ڵ�����ȯ

--��������ȯ
--TO_CHAR -> ��¥, ���ڷ� ���� ����ȯ, ��¥ ���������� ���Դϴ�
SELECT TO_CHAR(SYSDATE) FROM DUAL; 
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS') AS TIME FROM DUAL; 
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD') AS TIME FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD AM') AS TIME FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY"��" MM"��" DD"��"') FROM DUAL; -- ����Ʈ ���������� �ƴѰ��� ������ "" �� �����ݴϴ�

SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') FROM EMPLOYEES;

--TO_CHAR -> ����, ���ڷ� ���� ����ȯ, ���� ���������� ���Դϴ� (9 0 , . $ L )
SELECT TO_CHAR(20000, '9999999999'), 20000 FROM DUAL; --���� 10�ڸ��� ����
SELECT TO_CHAR(20000, '0999999999'), 20000 FROM DUAL; --���� �ڸ��� 0���� ä��
SELECT TO_CHAR(20000, '9999'), 20000 FROM DUAL; --�ڸ����� �����ϸ� #���� ó�� �˴ϴ�.
SELECT TO_CHAR(20000.123, '99,999.999' ) FROM DUAL; -- �Ҽ����� .���� ��Ÿ���ϴ�.   ,�� �׳� ���� �˴ϴ�
SELECT TO_CHAR(20000, '$999999') AS A FROM DUAL; -- $�� �׳� ���� �˴ϴ�
SELECT TO_CHAR(20000, 'L99999') AS A FROM DUAL;  -- L����ȭ�� ��ȣ

-- ������ ȯ���� 1302.69�� �Դϴ�
-- SALARY�÷��� �ѱ������� �����ؼ� �Ҽ��� 2�ڸ������� ���
SELECT TO_CHAR(SALARY * 1302.69, 'L999,999,999.99') FROM EMPLOYEES;

--TO_NUMBER -> ����, ���ڷ� ���� ����ȯ
SELECT '2000' + 2000 FROM DUAL; -- �ڵ�����ȯ
SELECT TO_NUMBER('2000') + 2000 FROM DUAL; -- ���������ȯ

SELECT '$5,000' + 2000 FROM DUAL; -- ����
SELECT TO_NUMBER('$5,000', '$9,999') + 2000 FROM DUAL; --���ڷ� ��ȯ�� ������ ������ ���, ����FMT�� �̿��ؼ� �ڸ��� ���߸� �˴ϴ�.

--TO_DATE -> ����, ��¥�� ���� ����ȯ
SELECT TO_DATE('2023-12-04') FROM DUAL; --��¥�� ����ȯ
SELECT SYSDATE - TO_DATE('2023-12-03') FROM DUAL; --��¥�� ��ȯ�ؾ� ���ڰ� ���ɴϴ�.
SELECT TO_DATE('2023/12/04', 'YYYY/MM/DD') FROM DUAL;
SELECT TO_DATE('2023��12��04��', 'YYYY"��"MM"��"DD"��"') FROM DUAL; --��¥���乮�ڰ� �ƴ� ���ڴ� ""�� �����ݴϴ�.
SELECT TO_DATE('2024-12-04 02:30:23', 'YYYY-MM-DD HH:MI:SS') FROM DUAL; --�ڸ��� ���缭 ���������� �����ݴϴ�.

-- XXXX��XX��XX�� �� ��ȯ
SELECT '20050102' FROM DUAL;
SELECT TO_CHAR(TO_DATE('20050102', 'YYYYMMDD'), 'YYYY"��"MM"��"DD"��"') AS A FROM DUAL;

------------------------------------------------------------------------
--NULLó���Լ��� 

--NVL(��, NULL�ϰ�� ��ü�Ұ�) *
SELECT NVL(NULL, 0) FROM DUAL; -- NULL�� ��� 0���� ��ȯ��
SELECT NVL(300, 0) FROM DUAL;  -- NULL�� �ƴҰ�� �״�� ��µ�

SELECT NULL * 3000 + 1000 FROM DUAL; -- NULL�� ������ �� ���� NULL�� ���ɴϴ�
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT FROM EMPLOYEES; -- NULL�� ������ �� ���� NULL�� ���ɴϴ�
SELECT FIRST_NAME, SALARY, COMMISSION_PCT, SALARY + SALARY * NVL(COMMISSION_PCT, 0) FROM EMPLOYEES;

--NVL2(��, NULL�� �ƴҰ�� ��ü�Ұ�, NULL�� ��� ��ü�Ұ�) *
SELECT NVL2(300, 'NULL�� �ƴմϴ�', 'NULL�Դϴ�') FROM DUAL;

SELECT FIRST_NAME, NVL2(COMMISSION_PCT, 'TRUE', 'FALSE') FROM EMPLOYEES;
SELECT FIRST_NAME, SALARY, NVL2(COMMISSION_PCT, SALARY + SALARY * COMMISSION_PCT, SALARY ) FROM EMPLOYEES;

--DECODE(��, �񱳰�, �����, ����..., ELSE��) *
SELECT DECODE('A', 'A', 'A�Դϴ�', 'A���ƴմϴ�' ) FROM DUAL; -- IF ~ELSE
SELECT DECODE('B', 'A', 'A�Դϴ�',
                   'B', 'B�Դϴ�',
                   'C', 'C�Դϴ�',
                   '���ξƴմϴ�') FROM DUAL;

SELECT FIRST_NAME, 
       JOB_ID,
       DECODE(JOB_ID, 'AD_VP', SALARY * 1.1,
                      'IT_PROG', SALARY * 1.2,
                      'FI_MGR', SALARY * 1.3,
                      SALARY) AS �޿�
FROM EMPLOYEES;

--CASE ~WHEN ~THEN ~ELSE ~ END ���� (SWICH����� �����) *
--1ST
SELECT FIRST_NAME,
       JOB_ID,
       SALARY,
       CASE JOB_ID WHEN 'AD_VP' THEN SALARY * 1.1
                   WHEN 'IT_PROG' THEN SALARY * 1.2
                   WHEN 'FI_MGR' THEN SALARY * 1.3
                   ELSE SALARY
       END AS �޿�
FROM EMPLOYEES;

--2ED
SELECT FIRST_NAME,
       JOB_ID,
       SALARY,
       CASE WHEN JOB_ID = 'AD_VP' THEN SALARY * 1.1
            WHEN JOB_ID = 'IT_PROG' THEN SALARY * 1.2
            WHEN JOB_ID = 'FI_MGR' THEN SALARY * 1.3
            ELSE SALARY
       END AS �޿�
FROM EMPLOYEES;

SELECT CASE WHEN SALARY >= 10000 THEN '��'
            WHEN SALARY >= 5000 THEN '��'
            ELSE '��'
       END AS �޿�
FROM EMPLOYEES;

-- COALESCE(��, ��, ...) �ھ󷹽� - NULL�� �ƴ� ù��° ���ڰ��� ��ȯ��
SELECT COALESCE(NULL, 'A', 'B') FROM DUAL;  -- A
SELECT COALESCE(NULL, NULL, 'B') FROM DUAL; -- B
SELECT COALESCE(NULL, 'B', 'C', NULL) FROM DUAL; -- B
SELECT COALESCE(NULL, NULL, NULL, NULL) FROM DUAL; -- NULL
SELECT COMMISSION_PCT, COALESCE(COMMISSION_PCT, 0 ) FROM EMPLOYEES; -- NVL�� ���

---------------------------------------------------------------------------------
--��������

--���� 1.
--�������ڸ� �������� EMPLOYEE���̺��� �Ի�����(hire_date)�� �����ؼ� �ټӳ���� 10�� �̻���
--����� ������ ���� ������ ����� ����ϵ��� ������ �ۼ��� ������. 
--���� 1) �ټӳ���� ���� ��� ������� ����� �������� �մϴ�
SELECT EMPLOYEE_ID AS �����ȣ, 
       CONCAT(FIRST_NAME, LAST_NAME) AS �̸�,
       HIRE_DATE AS �Ի�����,
       TRUNC((SYSDATE - HIRE_DATE) / 365) AS �ټӳ��
FROM EMPLOYEES
WHERE TRUNC((SYSDATE - HIRE_DATE) / 365) >= 10 --10���̻�
ORDER BY �ټӳ�� DESC;
       
--���� 2.
--EMPLOYEE ���̺��� manager_id�÷��� Ȯ���Ͽ� first_name, manager_id, ������ ����մϴ�.
--100�̶�� �������, 
--120�̶�� �����ӡ�
--121�̶�� ���븮��
--122��� �����塯
--�������� ���ӿ��� ���� ����մϴ�.
--���� 1) �μ��� 50�� ������� ������θ� ��ȸ�մϴ�
SELECT FIRST_NAME, 
       DECODE(MANAGER_ID, 100, '���', 120, '����', 121, '�븮', 122, '����', '�ӿ�') AS ����,
       JOB_ID 
FROM EMPLOYEES;

SELECT FIRST_NAME, 
       CASE MANAGER_ID WHEN 100 THEN  '���'
                       WHEN 120 THEN  '����'
                       WHEN 121 THEN  '�븮'
                       WHEN 122 THEN  '����'
                       ELSE '�ӿ�'
       END AS ����,
       JOB_ID 
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 50;






















