# SQL

### 타입

문자,숫자,날짜,기타 타입이 존재함



문자

- CHAR : 최대 길이 2000BYTE 고정 길이 문자열
- VACHAR2 : 최대 길이 4000BYTE 가변 길이 문자열
- CLOB : 최대 4GB 가변 길이 문자열

숫자

- NUMBER : 숫자형 자료형

날짜

- DATE : YYYY-MM-DD HH24:MI:SS

기타

- BLOB : 이전 데이터 저장 자료형



CHAR를 10칸으로 설정하고 3칸만 채우면 3칸 + 7칸의 공백이됨

VARCHAR2를 10칸으로 설정하고 3칸만 채우면 공백이없이 3칸만 적용

VARCHAR도 존재

하지만 VARCHAR2랑 아예 똑같음 보통 VARCHAR2를 씀



### SQL 종류

Structured Query Language : 구조화된 질의 언어

- DDL (Data Deifnition Language) : DB 스키마 정의어
- DML (Data Manipulation Language) : Data 조작어
- DCL (Data Control Language) : Data 제어어



##### DML

- SELECT : 데이터 읽기

```SQL
SELECT COLUMN, ...
FROM ENTITY;
WHERE 조건
```

실행 순서 : FROM -> SELECT

실행 순서(WHERE) : FROM -> WHERE -> SELECT



- INSERT : 데이터 삽입

```SQL
INSERT INTO ENTITY
VALUES(전체 COLUMN 내용);

INSERT INTO ENTITY(특정 COLUMN명)
VALUES(특정 COLUMN 내용);
```



- UPDATE : 데이터 수정

```SQL
UPDATE ENTITY
SET COLUMN명 = 값
WHERE 조건;
```

***UPDATE 사용시 주의사항***

- WHERE가 없을 경우 그 컬럼의 값 전체가 전부 바뀐다. 꼭 WHERE를 쓰자 
- 그냥 UPDATE의 SQL구문은 WHERE가 있는게 기본구문이라고 생각하자.



- DELETE : 데이터 삭제

```SQL
DELETE FROM ENTITY
WHERE 조건;
```



- Alias(별칭) 

```SQL
SELECT ENAME AS "사원명" FROM EMP;
```



- 테이블 구조 확인

```SQL
DESC EMP;
```



- Line 크기 변경 / Page 크기 변경 (SIZE = 숫자)

```sql
SET LINESIZE SIZE; 
SET PAGESIZE SIZE;
```



- 문자열 연결

```SQL
STRING||STRING
```



##### DDL

- CREATE : 테이블, 뷰, 프로시저 등을 생성

```SQL
CREATE TABLE ENTITY(
COLUMN DATA_TYPE(SIZE),
...
CONSTRAINT 제약조건명 제약조건 (COLUMN명)
);
```



- 시퀀스 만들기

```SQL
CREATE SEQUENCE 시퀀스명(
INCREMENT BY 정수 (기본값 1) -- 정수값 만큼 증감
START WITH 정수 -- 시작 번호
MAXVALUE 정수 -- 최대값 지정
MINCALUE 정수 -- 최소값 지정
CYCLE || NOCYCLE -- 반복 여부
CACHE 정수 || NOCACHE -- 정수값 만큼 미리 생성
);

CREATE SEQUENCE SEQ_EMPID01
START WITH 300
INCREMENT BY 5
NOCYCLE
NOCACHE;

SELECT SEQ_EMPID01.NEXTVAL FROM DUAL;
```

NEXTVAL : 시퀀스의 다음 값 / CURRVAL : 시퀀스의 현재 값

***주의사항***

MAXVALUE가 OVERFLOW되면 START WITH값이 개발자가 지정해준 값이 아닌 1부터 시작



- 테이블 복제

  > 전체복제

  ```SQL
  CREATE TABLE NEW TABLE AS SELECT * FROM ENTITY;
  ```

  > 원하는 컬럼만 복제

  ```SQL
  CREATE TABLE NEW TABLE AS SELECT COLUMC명 FROM ENTITY;
  ```

  > 구조(전체 컬럼)만 복제

  ```SQL
  CREATE TABLE NEW TABLE AS SELECT * FROM ENTITY WHERE 1=2;
  ```

  구조만 복제하는 구문은 WHERE를 FALSE로 만들면 된다. ('A'='B'도 가능)

  

- 제약조건

  > 이름으로 관리

  - 문자로 시작, 길이는 30자까지 가능
  - 이름을 따로 지정하지 않으면 자동 생성

  > 생성 시기

  - 테이블 생성과 동시
  - 테이블을 생성한 후

  

  ### 데이터 무결성

  - 데이터가 손상되거나 원래의 의미를 잃지 않고 유지되는 상태
  - ***무결성 제약조건 : 입력되는 자료들이 규칠을 정해준다***

|  제약조건   |                   설명                    |   설정레벨   |
| :---------: | :---------------------------------------: | :----------: |
|  NOT NULL   |    해당 컬림에 NULL을 입력할 수 없도록    |     컬럼     |
|   UNIQUE    | 해당 컬럼 또는 컬럼 조합 값이 유일하도록  | 컬럼, 테이블 |
| PRIMARY KEY |     각 행을 유일하게 식별할 수 있도록     | 컬럼, 테이블 |
|    CHECK    | 해당 컬럼에 특정 조건을 항상 만족시키도록 | 컬럼, 테이블 |



```SQL
--UNIQUE

CREATE TABLE TABLE_UNIQUE01(
	ID CHAR(3) UNIQUE,
    NAME VARCHAR2(20)
);

INSERT INTO TABLE_UNIQUE01 VALUES('100','JAVA');
INSERT INTO TABLE_UNIQUE01 VALUES('100','ORACLE');

-- 오류 : ID가 UNIQUE라서 값이 유일해야함.

CREATE TABLE TABLE_UNIQUE02(
	ID CHAR(3),
	NAME VARCHAR2(20),
    NUM NUMBER,
    CONSTRAINT TU02_ID_UN UNIQUE(ID,NAME)
);

-- 이렇게 제약조건에 사용도 가능
-- 오류가 나면 TU02_ID_UN이라는 내가 설정한 제약조건명이 뜸
-- 이런 경우에는 ID와 NAME이 둘 다 같은 중복값 허용 안됨
```



```SQL
---PRIMARY KEY = UNIQUE + NOT NULL

CREATE TABLE TABLE_PK01(
	ID CHAR(3) PRIMARY KEY,
	NAME VALRCHAR2(20)
);

INSERT INTO TABLE_PK01 VALUES('100','ORACLE');
INSERT INTO TABLE_PK01 VALUES('100','ORACLE');
INSERT INTO TABLE_PK01 VALUES(NULL,'ORACLE');

--2,3번째 오류

CREATE TABLE TABLE_PK01(
	ID CHAR(3),
	NAME VALRCHAR2(20),
    NUM NUMBER
    CONSTRAINT TP02_PK PRIMARY KEY(ID,NAME)
);

INSERT INTO TABLE_PK01 VALUES('100','ORACLE',1);
INSERT INTO TABLE_PK01 VALUES('100','JAVA',2);
INSERT INTO TABLE_PK01 VALUES(NULL,'ORACLE',3);

--3번째 오류
--2번째 오류 안나는 이유는 ID와 NAME이 두개가 기본키여서 두개가 같아야지 오류가 남
```



```SQL
--FOREGN KEY

CREATE TABLE TABLE_FK01(
	ID CHAR(3) PRIMARY KEY,
	NAME VARCHAR2(20),
	PKID CHAR(3) REFERENCES TABLE_PK01(ID)
);

INSERT INTO TABLE_FK01 VALUES('123','ORACLE','100');
INSERT INTO TABLE_FK01 VALUES('124','JAVA','200');
INSERT INTO TABLE_FK01 VALUES('125','ORACLE','300');

--3번째 구문 오류 TABLE_PK01에는 기본키로 300이 없음
--외래키는 부모 테이블에도 값이 존재해야함

CREATE TABLE TABLE_FK02(
	ID CHAR(3) PRIMARY KEY,
	PKID CHAR(3),
	PKNAME VARCHAR2(20),
	FOREIGN KEY(PKID,PKNAME) REFERENCES TABLE_PK02(ID,NAME)
);

INSERT INTO TABLE_FK02 VALUES('123','100','ORACLE');
INSERT INTO TABLE_FK02 VALUES('124','200','JAVA');
INSERT INTO TABLE_FK02 VALUES('125','300','ORACLE');

--2,3번째 둘다 오류 
--부모 테이블에 200과 300값이 없음


```



```SQL
--CHECK

CREATE TABLE TABLE_CHECK01(
	EMP_ID CHAR(3) PRIMARY KEY,
	NAME VARCHAR2(20),
	MARRIAGE CHAR(1) CHECK(MARRIAGE IN('Y','N'))
);

INSERT INTO TABLE_CHECK01 VALUES('123','HONG','Y');
INSERT INTO TABLE_CHECK01 VALUES('124','LEE','N');
INSERT INTO TABLE_CHECK01 VALUES('125','KIM','A');

--3번째 줄 오류 CHECK는 사용자가 지정해준 값만 들어갈 수 있음

CREATE TABLE TABLE_CHECK02(
	EMP_ID CHAR(3) PRIMARY KEY,
	NAME VARCHAR2(20),
	MARRIAGE CHAR(1) 
    CONSTRAINT TC_CK CHECK(MARRIAGE IN('Y','N'))
);

INSERT INTO TABLE_CHECK01 VALUES('123','HONG','Y');
INSERT INTO TABLE_CHECK01 VALUES('124','LEE','N');
INSERT INTO TABLE_CHECK01 VALUES('125','KIM','A');

--위의 코드와 같은 이유로 오류
```



- ALTER : 테이블, 뷰, 프로시저 등을 수정



- 테이블 수정

```SQL
ALTER TABLE ENTITY
-ADD(컬럼명 DATA_TYPE....)
-MODIFY(컬럼명 DATA_TYPE...)
-RENAME COLUMN 원래컬럼명 TO 바꿀컬럼명
-DROP COLUMN 컬럼명||DROP(COLUMN)

--ADD는 컬럼 추가
--MODIFY는 컬럼의 타입 변경
--RENAME은 컬럼의 이름 변경
--DROP은 컬럼 삭제
```



- 시퀀스 수정

```SQL
ALTER SEQUENCE 시퀀스명
[INCREMENT BY 정수(기본값1)]
[{MAXVALUE 정수}][{MINVALUE 정수}]
[{CYCLE|NOCYCLE}]
[{CACHE 정수|NOCACHE}]


-- *START WITH 값은 수정 불가
```



- DROP : 테이블, 뷰, 프로시저 등을 삭제

```SQL
DROP TABLE ENTITY (PURGE);
```



##### DDL

- COMMIT / ROLLBACK : 데이터, 트랜잭션 저장 / 취소 (TCL)

- GRANT / REVOKE : DB 권한(시스템 권한, 개체 권한, 역할(ROLL)) 부여 / 삭제

  > 시스템 권한

  - 객체 생성, 변경, 소멸 등이 관한 권한으로, SYS(SYSTEM)에게 부여 받는다.
  - 시스템 권한은 기능이 매우 강력하여, 대부분 관리자나 개발자만 부여한다.
  - EX) 테이블스페이스 생성, 임의 테이블 행 삭제 등을 할 수 있는 권한

  > 개체 권한

  - 사용가자 특정 개체에 대해 특정 자업을 수행 가능하도록 일반 사용자에게 부여하는 권한
  - 객체 내용 조작과 관련되 권한으로, 객체 소유자에게 부여받은 권한
  - EX) 특정 테이블의 행 삭제

  > 역할 (ROLL)

  - 시스템 권한만 해도 120가지 이상

  - 많은 권한을 사용자마다 일일이 부여하기가 힘들어서 

    권한들을 미리 정의해 놓은 집합(ROLL)을 만듬

  - 사용자에게 특정 집합을 권한 대신 부여

  

  - 설치와 동시에 기본적으로 생성되어 있는 ROLL
    - CONNECT : 접속권한을 가진 ROLL
    - RESOURCE : 객체의 생성, 변경, 삭제 등의 기본 시스템 권한을 가진 ROLL
    - DBA : DB 관리에 필요한 권한을 가진 ROLL
    - SYSDBA : DB 시작과 종료 및 관리 권한을 가진 ROLL
    - SYSOPER : SYSDBA + DB 생성 권한을 가진 ROLL



##### 함수 중첩

- 우리가 JAVA에서 배우듯이 A메소드안에 B메소드가 있을 경우 B메소드 먼저 실행 후 B메소드의 값이 A의 메소드 아규먼트로 들어감.

- JAVA와 마찬가지로 SQL에서도 A함수안에 B함수가 있을 경우

   B함수 실행하고 그 값으로 A함수 실행



##### 단일 행 함수

- 주요 단일 행 함수

|      구분      | 입력값 타입 |                종류                 | 리턴값 타입 |
| :------------: | :---------: | :---------------------------------: | :---------: |
| 문자(열) 함수  |  CHARACTER  | LPAD/RPAD, LTRIM/RTRIM/TRIM, SUBSTR |  CHARACTER  |
| 문자(열) 함수  |  CHARACTER  |        INSTR, LENGHT/LENGTHB        |   NUNBER    |
|   숫자 함수    |   NUMBER    |            ROUND, TRUNC             |   NUMBER    |
|   날짜 함수    |    DATE     |         ADD_MONTHS, SYSDATE         |    DATE     |
|   날짜 함수    |    DATE     |           MONTHS_BETWEEN            |   NUMBER    |
| 타입 변환 함수 |     ANY     |     TO_CHAR, TO_DATE, TO_NUMBER     |     ANY     |
|   기타 함수    |     ANY     |             NVL, DECODE             |     ANY     |



- LPAD/RPAD (컬럼명, 길이, 값)
  - 해당 컬럼을 길이만큼 오른쪽/왼쪽 정렬한다.
  - 빈 공간은 값을 채운다.

```SQL
--Q1 빈 자리에는 *을 넣어서 7자리만큼 오른쪽 정렬하자.
SELECT LPAD(ENAME.7,'*') FROM EMP;

--Q2 빈 자리에는 *을 넣어서 10자리만큼 왼쪽 정렬하자.
SELECT RPAD(ENAME,10,'*') FROM EMP;
```

