--���� ���� or �پ��� ������ �ο��Ϸ��� DBA�������� �����մϴ�.

SELECT * FROM HR.EMPLOYEES;
-- ����� ���� Ȯ��
SELECT * FROM all_users;
-- ���� ���� ���� Ȯ��
SELECT * FROM user_sys_privs;

--����� ���� ����
CREATE USER USER01 IDENTIFIED BY USER01; --���̵�, ��й�ȣ
--����ڿ��� ���� �ο�
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE PROCEDURE  TO USER01;
--���̺����̽� ����
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS; --�����Ѵ� USER01 �⺻���̺����̽� USERS ������ �Ҵ��Ѵ� USERS

--������ ȸ��
REVOKE CREATE SESSION FROM USER01;
--��������(���� ������ ���̺��� ��� ������, ���̺��� �����ؼ� ������ �Ͼ�� �մϴ�. )
DROP USER USER01 /*CASCADE*/;

-------------------------------------------------------------------------------
--���� �̿��� ���� �ο�
CREATE USER USER01 IDENTIFIED BY USER01;
--ROLE
GRANT RESOURCE, CONNECT TO USER01; --������ ����� ���Ѱ� ������ ROLE
--���̺����̽�
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

DROP USER USER01 Cascade; --���������� ����
-------------------------------------------------------------------------------
--�� ������ ���콺��
--�ٸ� ����� -> �������� -> �Ѻο� -> ���̺����̽� ���� -> ����

--������ -> DBAŬ��
--���̺����̽��� ��������� ���.




