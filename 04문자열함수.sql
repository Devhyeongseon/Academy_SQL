--���ڿ� �ٷ�� �Լ� 
--LOWER, UPPER, INITCAP

SELECT 'abcDEF', LOWER('abcDEF'), UPPER('abcDEF'), INITCAP('abcDEF') FROM DUAL;
SELECT FIRST_NAME, LOWER(FIRST_NAME), UPPER(FIRST_NAME), INITCAP(FIRST_NAME) FROM EMPLOYEES;

--LENGTH - ����, INSTR - ���ڿ�ã��
SELECT FIRST_NAME, LENGTH(FIRST_NAME), INSTR(FIRST_NAME, 'a') FROM EMPLOYEES;

--SUBSTR(�÷�, �����ε���, �ڸ����ڰ���) - ���ڿ��ڸ���,  CONCAT - ���ڿ����̱�
SELECT FIRST_NAME, SUBSTR(FIRST_NAME, 3, 2), SUBSTR(FIRST_NAME, 3) FROM EMPLOYEES;

SELECT CONCAT(FIRST_NAME, LAST_NAME), FIRST_NAME || LAST_NAME FROM EMPLOYEES;

--LPAD - ���ʰ����� Ư�� ������ ä��, RPAD
SELECT LPAD('ABC', 10, '*' ) FROM DUAL;
SELECT RPAD(FIRST_NAME, 10, '-' ), LPAD(FIRST_NAME, 10, '-' ) FROM EMPLOYEES;

--TRIM - ���ʰ�������, LTRIM, RTRIM
SELECT TRIM(' HELLO WORLD  '), LTRIM(' HELLO WORLD  '), RTRIM(' HELLO WORLD  ') FROM DUAL;
SELECT LTRIM('HELLO WORLD', 'HE' ) FROM DUAL; --���ʿ��� ó���߰ߵ� HE�� ����

--REPLACE(����, ã������, �ٲܹ���) - Ư�� ���ڸ� ����
SELECT REPLACE('��ī�� ������ ���̸� ������', '���̸�', '���ڵ�') FROM DUAL;

--my dream is hello world
--hello�� '���' �� �����ϰ�, ��� ������ �����Ѵ�. ???????
SELECT LENGTH(REPLACE(REPLACE('my dream is hello world', 'hello', '���' ), ' ', '' )  )FROM DUAL;

-----------------------------------------------------------------
--��������

--���� 1.
--EMPLOYEES ���̺� ���� �̸�, �Ի����� �÷����� �����ؼ� �̸������� �������� ��� �մϴ�.
--���� 1) �̸� �÷��� first_name, last_name�� �ٿ��� ����մϴ�.
--���� 2) �Ի����� �÷��� xx/xx/xx�� ����Ǿ� �ֽ��ϴ�. xxxxxx���·� �����ؼ� ����մϴ�.
SELECT CONCAT(FIRST_NAME, LAST_NAME) AS �̸�, REPLACE(HIRE_DATE, '/', '') AS �Ի����� 
FROM EMPLOYEES
ORDER BY �̸�;

--���� 2.
--EMPLOYEES ���̺� ���� phone_numbe�÷��� ###.###.####���·� ����Ǿ� �ִ�
--���⼭ ó�� �� �ڸ� ���� ��� ���� ������ȣ (02)�� �ٿ� ��ȭ ��ȣ�� ����ϵ��� ������ �ۼ��ϼ���.
SELECT CONCAT('(02)' ,  SUBSTR(PHONE_NUMBER, 4)  ) FROM EMPLOYEES;

--���� 3. 
--EMPLOYEES ���̺��� JOB_ID�� it_prog�� ����� �̸�(first_name)�� �޿�(salary)�� ����ϼ���.
--���� 1) ���ϱ� ���� ���� �ҹ��ڷ� �Է��ؾ� �մϴ�.(��Ʈ : lower �̿�)
--���� 2) �̸��� �� 3���ڱ��� ����ϰ� �������� *�� ����մϴ�. 
--�� ���� �� ��Ī�� name�Դϴ�.(��Ʈ : rpad�� substr �Ǵ� substr �׸��� length �̿�)
--���� 3) �޿��� ��ü 10�ڸ��� ����ϵ� ������ �ڸ��� *�� ����մϴ�. 
--�� ���� �� ��Ī�� salary�Դϴ�.(��Ʈ : lpad �̿�)

SELECT RPAD(SUBSTR(FIRST_NAME, 1, 3), LENGTH(FIRST_NAME), '*') AS NAME,
       LPAD(SALARY,10, '*' ) AS SALARY
FROM EMPLOYEES WHERE LOWER(JOB_ID) = 'it_prog';













