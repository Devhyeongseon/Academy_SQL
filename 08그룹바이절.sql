--�׷��Լ� - �࿡���� ������� ��
--SUM, AVG, MAX, MIN, COUNT - ���� NULL�� �ƴѵ����Ϳ� ���ؼ� ��踦 ���մϴ�.
SELECT SUM(SALARY), AVG(SALARY), MAX(SALARY), MIN(SALARY), COUNT(SALARY) FROM EMPLOYEES;

--MAX, MIN�� ���ڿ��̳� ��¥���� ������ �˴ϴ�.
SELECT MIN(HIRE_DATE), MAX(HIRE_DATE) FROM EMPLOYEES;
SELECT MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES;

-- COUNT() �ΰ��� �����
SELECT COUNT(COMMISSION_PCT) FROM EMPLOYEES; -- NULL�� �ƴ� ������ ����
SELECT COUNT(*) FROM EMPLOYEES; -- ��ü���(NULL����)

-- 80�� �μ�������� COMMISSION��谪
SELECT MIN(COMMISSION_PCT), MAX(COMMISSION_PCT), SUM(COMMISSION_PCT) FROM EMPLOYEES WHERE DEPARTMENT_ID = 80;

-- ��������: �׷��Լ��� �Ϲ��÷��� ���ÿ� ����� �Ұ���
SELECT FIRST_NAME, AVG(SALARY) FROM EMPLOYEES;

-- �׷��Լ� �ڿ� OVER() �� ���̸� ��ü�� ����� �˴ϴ�.
SELECT FIRST_NAME, AVG(SALARY) OVER(), MAX(SALARY) OVER(), COUNT(*) OVER() FROM EMPLOYEES;

---------------------------------------------------------------------------------------------------------------
-- GROUP BY�� - �÷��������� �׷���
SELECT DEPARTMENT_ID FROM EMPLOYEES GROUP BY DEPARTMENT_ID;

SELECT DEPARTMENT_ID, SUM(SALARY), AVG(SALARY), MAX(SALARY), MIN(SALARY), COUNT(*)
FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID; -- �׷��Լ��� �Բ� ����� �� �ֽ��ϴ�

--�������� - GROUP BY�������� ���� �÷��� SELECT���� ����Ҽ� ����
SELECT DEPARTMENT_ID, FIRST_NAME
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

--2�� �̻��� �׷�ȭ (���� �׷�)
SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;
--COUNT(*) OVER() �� ����ϸ�, �� ���� ���� ���� ����� �� �ֽ��ϴ�.
SELECT DEPARTMENT_ID, JOB_ID, COUNT(*), COUNT(*) OVER()
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID;

--WHERE���� �׷��Լ� ������ ����� �� �����ϴ�. (��, �Ϲ������� ����)
SELECT DEPARTMENT_ID, SUM(SALARY), AVG(SALARY)
FROM EMPLOYEES
WHERE SUM(SALARY) >= 100000 -- �׷��Լ��� ������ ���� ������ HAVING�̶�� �־�!
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

--------------------------------------------------------------------------------
--HAVING - �׷��Լ��� ����
--WHERE - �Ϲ�����
SELECT DEPARTMENT_ID, SUM(SALARY), COUNT(*)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING SUM(SALARY) >= 100000 AND COUNT(*) >= 40;
--
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY)
FROM EMPLOYEES
WHERE JOB_ID NOT LIKE 'SA%'
GROUP BY DEPARTMENT_ID, JOB_ID
HAVING AVG(SALARY) >= 5000;

--�μ����̵� NULL�� �ƴϰ�, �Ի����� 05�⵵ �� ������� �μ� �޿���հ�, �޿��հ踦 ��ձ��� ��������
--������ ����� 10000�̻��� �����͸�.
SELECT DEPARTMENT_ID, SUM(SALARY) AS �հ�, AVG(SALARY) AS ���
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL AND HIRE_DATE LIKE '05%'
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 10000
ORDER BY ��� DESC;

--------------------------------------------------------------------------------
--���� ���迡 ���� ����
--ROLLUP - GROUP BY�� �Բ� ���ǰ�, �����׷��� �հ�, ��ո� ���մϴ�.
SELECT DEPARTMENT_ID, AVG(SALARY), SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID) -- �μ� ��ü�հ�, ��ü���
ORDER BY DEPARTMENT_ID;
--
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY), SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID; -- �μ��� �հ�, ���, ��ü�հ�, ��ü���

-- CUBE - �Ѿ��� ���ؼ� ������ �� + ����׷� ��� �߰���
SELECT DEPARTMENT_ID, JOB_ID, AVG(SALARY), SUM(SALARY)
FROM EMPLOYEES
GROUP BY CUBE(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID, JOB_ID;

--GROUPING�Լ� - �׷����� ������� ���� 0����ȯ, �Ѿ�ORť��� ������� ���� ��쿡�� 1�� ��ȯ
SELECT DECODE( GROUPING(DEPARTMENT_ID), 1, '�Ѱ�', DEPARTMENT_ID),
       DECODE( GROUPING(JOB_ID), 1, '�Ұ�', JOB_ID  ), 
       AVG(SALARY),
       GROUPING(DEPARTMENT_ID),
       GROUPING(JOB_ID)
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY DEPARTMENT_ID;
--------------------------------------------------------------------------------
--��������
--���� 1.
--��� ���̺��� JOB_ID�� ��� ���� ���ϼ���.
--��� ���̺��� JOB_ID�� ������ ����� ���ϼ���. ������ ��� ������ �������� �����ϼ���
SELECT JOB_ID, 
       COUNT(*) AS �����,
       AVG(SALARY) AS �޿����
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY �޿���� DESC;
--���� 2.
--��� ���̺��� �Ի� �⵵ �� ��� ���� ���ϼ���.
SELECT TO_CHAR(HIRE_DATE, 'YY') AS �Ի�⵵, 
       COUNT(*) AS �����
FROM EMPLOYEES
GROUP BY TO_CHAR(HIRE_DATE, 'YY');
--���� 3.
--�޿��� 1000 �̻��� ������� �μ��� ��� �޿��� ����ϼ���. �� �μ� ��� �޿��� 2000�̻��� �μ��� ���
SELECT DEPARTMENT_ID, 
       AVG(SALARY)
FROM EMPLOYEES
WHERE SALARY >= 1000
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) >= 2000;
--���� 4.
--��� ���̺��� commission_pct(Ŀ�̼�) �÷��� null�� �ƴ� �������
--department_id(�μ���) salary(����)�� ���, �հ�, count�� ���մϴ�.
--���� 1) ������ ����� Ŀ�̼��� �����Ų �����Դϴ�.
--���� 2) ����� �Ҽ� 2° �ڸ����� ���� �ϼ���.

SELECT DEPARTMENT_ID,
       TRUNC( AVG(SALARY + SALARY * COMMISSION_PCT), 2 ),
       SUM(SALARY + SALARY * COMMISSION_PCT),
       COUNT(SALARY)
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL
GROUP BY DEPARTMENT_ID;

--5
SELECT DECODE( GROUPING(JOB_ID ), 1, '�հ�', JOB_ID ) AS JOB_ID, 
       SUM(SALARY)
FROM EMPLOYEES
GROUP BY ROLLUP(JOB_ID);
--6
SELECT DECODE(GROUPING(DEPARTMENT_ID), 1 ,'�հ�', DEPARTMENT_ID ) AS DEPARTMENT_ID,
       DECODE(GROUPING(JOB_ID), 1, '�Ұ�', JOB_ID  ) JOB_ID,
       COUNT(*) TOTAL,
       SUM(SALARY) AS SUM
FROM EMPLOYEES
GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
ORDER BY SUM;


 














