--Q1 ������̺��� ������ 10000�̻��� ����� �����ȣ�� ���� ����Ͻÿ�.
SELECT EMPLOYEE_ID, LAST_NAME
FROM EMPLOYEES
WHERE SALARY >=10000;

--Q2 ���� 'S'�� �����ϴ� ������� ��� ���޺��� ������ �� ���� �޴� ����� �����ȣ��,��,������ ����Ͻÿ�
--   �� ��½� ������ ������������ �����Ͻÿ�
SELECT EMPLOYEE_ID ,FIRST_NAME, SALARY 
FROM EMPLOYEES
WHERE SALARY >
(SELECT AVG(SALARY) FROM EMPLOYEES WHERE FIRST_NAME LIKE 'S%')
ORDER BY SALARY;

--Q3 �� ���ú� ��� �μ� �������� ��տ���,�ش� ������ �������� ����Ͻÿ� 
--   �� ��տ����� ������������ �����Ͻÿ� 
--   �� ���ÿ� �� ���ϴ� ������ 10�� �̻��� ���� �����Ͻÿ�
SELECT CITY , AVG(SALARY) , COUNT(*)
FROM EMPLOYEES JOIN DEPARTMENTS USING (DEPARTMENT_ID) 
JOIN LOCATIONS USING(LOCATION_ID) 
GROUP BY CITY
HAVING COUNT(*) < 10
ORDER BY AVG(SALARY) ASC;

--Q4 �����ȣ�� 105, 205�� ������ ������ ���Ͻÿ�
SELECT REGION_NAME
FROM EMPLOYEES JOIN DEPARTMENTS USING(DEPARTMENT_ID)
JOIN LOCATIONS USING(LOCATION_ID)
JOIN COUNTRIES USING(COUNTRY_ID)
JOIN REGIONS USING(REGION_ID)
WHERE EMPLOYEE_ID IN ('105','205');

--Q5 2007�⿡ �Ի�(hire_date)�� �������� �����ȣ, �̸� 
--   �μ����� ��ȸ�Ͻÿ�  
--   �� �μ��� ��ġ���� ���� ������ ��� 'N'���� ����Ͻÿ�.
--   �÷��� ��Ī�� �����ֽÿ�. (�����ȣ = �����ȣ, �̸� = �̸�, �μ���(�Լ�) = �μ���)
SELECT EMPLOYEE_ID, FIRST_NAME, NVL(DEPARTMENT_NAME,'N')
FROM EMPLOYEES LEFT JOIN DEPARTMENTS USING(DEPARTMENT_ID)
WHERE TO_CHAR(HIRE_DATE ,'YYYY') = '2007';

--Q6 �μ����� ���� ���� �޿��� �ް� �ִ� ������ �̸�, �μ��̸�, �޿��� ����Ͻÿ�.
--   �� �μ��̸����� �������� �Ͻÿ�
--   �÷��� ��Ī�� �����ֽÿ�. (�̸� = �̸�, �μ��̸� = �μ��� , �޿� = �޿�)
SELECT FIRST_NAME AS �̸� ,A.D AS �μ��� , SALARY AS �޿�
FROM EMPLOYEES E ,
(SELECT DEPARTMENT_ID AS A,MIN(SALARY) AS M ,DEPARTMENT_NAME AS D
FROM EMPLOYEES JOIN DEPARTMENTS USING(DEPARTMENT_ID)
GROUP BY DEPARTMENT_NAME,DEPARTMENT_ID ) A
WHERE (E.DEPARTMENT_ID =A.A) AND E.SALARY = A.M
ORDER BY 2;


 SELECT FIRST_NAME,MYRES.DE,SALARY
FROM EMPLOYEES E join
(SELECT E.DEPARTMENT_ID, D.DEPARTMENT_NAME as DE, MIN(E.SALARY) AS M FROM EMPLOYEES E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME, E.DEPARTMENT_ID) MYRES
USING (DEPARTMENT_ID)
WHERE E.SALARY = MYRES.M
ORDER BY 2;



--Q7 �Ի�⵵�� 2020�� 1�� 1�� �������� 12���̻��� ������ �̸�,�μ���,���ø� ����Ͻÿ�.
--	  �� �μ����� ���°�� �μ����� N���� ���
SELECT FIRST_NAME, NVL(DEPARTMENT_NAME,'N'), CITY
FROM EMPLOYEES LEFT JOIN DEPARTMENTS USING(DEPARTMENT_ID)
LEFT JOIN LOCATIONS USING(LOCATION_ID)
WHERE TRUNC(MONTHS_BETWEEN('2020/01/01',HIRE_DATE)/12) >= 12;

--Q8 �μ��� �������� �ִ�޿�,�ּұ޿�,��ձ޿��� ��ȸ�Ͻÿ�(�μ��̸��� ���� ��ȸ)
--   �� ��ձ޿��� 'Public Relations'�μ��� ��� �޿����� ����
--   'Executive' �μ����� ���� ������ ����Ͻÿ�.
SELECT DEPARTMENT_NAME,MAX(SALARY), MIN(SALARY),AVG(SALARY)
FROM EMPLOYEES JOIN DEPARTMENTS USING(DEPARTMENT_ID)
GROUP BY DEPARTMENT_NAME
HAVING AVG(SALARY) >
(SELECT AVG(SALARY) 
FROM EMPLOYEES JOIN DEPARTMENTS  USING(DEPARTMENT_ID)
WHERE DEPARTMENT_NAME ='Public Relations')
AND AVG(SALARY) <
(SELECT AVG(SALARY) 
FROM EMPLOYEES JOIN DEPARTMENTS USING(DEPARTMENT_ID)
WHERE DEPARTMENT_NAME ='Executive');

--Q9 �μ��� ������ ���� ����Ͻÿ�.(�μ��� ����ϵ�, �μ����� ���� ������ �μ����� 'N'���� ����Ͻÿ�.)
SELECT NVL(DEPARTMENT_NAME,'N'),COUNT(*)
FROM EMPLOYEES LEFT JOIN DEPARTMENTS USING(DEPARTMENT_ID)
GROUP BY DEPARTMENT_NAME;
-- GROUP BY�� DEPARTMENT_ID�� ���ϴ� ������ DEPARTMENT_NAME ����ϱ⶧����
-- DEPARTMENT_NAME �̱��� ������ COUNT������ �׷��� �׷����־����

--Q10 NVL,IS NOT NULL Ű���带 ������� �ʰ�, ROWNUM�� �̿��Ͽ� Ŀ�̼��� ���� ���� �޴� ���� 4����
--    �μ���,�̸�,�޿�,Ŀ�̼��� ��ȸ�Ͻÿ�.
--    ��°���� Ŀ�̼��� ������, Ŀ�̼��� ���ٸ� ������ ���������� ����Ͻÿ�
SELECT *
FROM(
SELECT DEPARTMENT_NAME,FIRST_NAME,SALARY,COMMISSION_PCT
FROM EMPLOYEES JOIN DEPARTMENTS USING(DEPARTMENT_ID)
ORDER BY COMMISSION_PCT DESC NULLS LAST,SALARY DESC)
WHERE ROWNUM <=4;
-- NVL���� ���� Ÿ�Ը� ������ ID�� �ѹ�Ÿ���̸� ���ڵ鸸





