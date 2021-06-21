-- 2021.03.05(금)

--  인덱스(index) : 빠른 검색을 하기 위해서 사용되는 객체

-- 인덱스 목록 확인
select * from user_indexes;

-- 기본키(primary key)로 설정된 컬럼은 자동으로 고유 인덱스가 설정된다.

--[실습]
-- 인덱스 실습 (인덱스 사용 유.무에 따른 검색 속도 비교)
--1.테이블 생성
 drop table emp01 purge;
 
 -- 복사본 테이블 생성 : 제약 조건은 복사되지 않는다.
create table emp01 as select * from emp;
select * from emp01;

--2. emp01 테이블에 데이터 입력 : 14,680,065개
insert into emp01 select * from emp01;

--3. 검색용 데이터 입력
insert into emp01(empno, ename) values(1111, 'ahn');

--4. 시간 측정 타이머 온
set timing on

--5. 검색용 데이터로 검색시간을 측정 : 인덱스가 설정되지 않은 경우
select * from emp01 where ename = 'ahn';    -- 11.85초

--6. 인덱스 생성 : ename 컬럼에 인덱스 적용
create index idx_emp01_ename on emp01(ename);

select * from user_indexes;     -- 인덱스 목록 확인

--7. 검색용 데이터로 검색시간을 측정 : 인덱스가 설정된 경우
select * from emp01 where ename = 'ahn';    -- 0.568초

-- 인덱스 삭제
-- 형식 : drop index  index_name;
drop index idx_emp01_ename;

-- 인덱스 종류
-- 고유 인덱스 : 중복된 데이터가 없는 컬럼에 적용할 수 있는 인덱스
-- 비고유 인덱스 : 중복된 데이터가 있는 컬럼에 적용할 수 있는 인덱스

--1. 테이블 생성
drop table dept01 purge;
create table dept01 as select * from dept where 1=0; --테이블 구조만 복사

--2. 데이터 입력 : loc 컬럼에 중복 데이터 입력
select * from dept01;
insert into dept01 values(10, '인사과', '서울');
insert into dept01 values(20, '총무과', '대전');
insert into dept01 values(30, '교육팀', '대전');

--3. 고유 인덱스  : deptno 컬럼에 고유 인덱스 적용
create unique index idx_dept01_deptno on dept01(deptno);

-- 고유 인덱스가 설정된 deptno 컬럼에 중복 데이터를 입력 해보자?
insert into dept01 values(30, '교육팀', '대전');
-- deptno 컬럼은 고유 인덱스가 설정된 이후에는 중복된 데이터를 입력할 수 없다.

--4. 인덱스 목록 확인
select * from user_indexes;

--5. 비고유 인덱스 : loc 컬럼에 고유, 비고유 인덱스를 적용 해보자?
--   loc 컬럼은 중복된 값이 있기 때문에 비고유 인덱스로 만들어야 한다.
create unique index idx_dept01_loc 
    on dept01(loc);              --  고유 인덱스로 만들면 오류 발생   

create index idx_dept01_loc 
    on dept01(loc);             -- 비고유 인덱스 생성됨
    
    
------------------------------------------------------------------------------
--객체 권한
--1. 새로 생성된 user01 계정에게 scott 계정 소유의 EMP 테이블 객체에 대한 
--   select 객체 권한을 부여한다.
conn scott/tiger
grant select on emp to user01;

--2. user01 계정으로 접속 후  EMP 테이블에 대해서 select 해본다.
conn user01/tiger
select * from emp;          -- 오류발생
select * from scott.emp;    -- 검색 가능함

--3. 객체 권한 취소
revoke select on emp from user01;

-- with grant option
-- : 일반 계정인 user02계정에게 scott계정 소유의 EMP 테이블 객체에 대한 select
--   객체 권한을 부여할때 with grant option을 붙여서 권한이 부여되면, user02계정은
--   자기사 부여받은 권한을 제 3의 계정(user01)에게 재 부여할 수 있다.
--1. user02 계정에게 scott 계정 소유의 emp객체에 대한 select객체 권한 부여한다.
conn scott/tiger
grant select on emp to user02 with grant option;

--2. user02계정으로 접속 후, user01계정에게 자기가 부여받은 객체권한을 재부여 한다.
conn user02/tiger
select * from scott.emp;

grant select on scott.emp to user01;   -- user01계정에게  객체권한 부여

--3. user01 계정으로 접속 후, 검색 해본다.
conn user01/tiger
select * from scott.emp;                -- 검색 가능함.

--------------------------------------------------------------------------
-- 사용자 정의 롤 : 롤에 객체 권한 부여
--1.롤 생성
conn system/ora123
create role mrole02;

--2. 생성된 롤에 객체권한을 추가한다.
conn scott/tiger
grant select on emp to mrole02;

--3. user05 계정에게 mrole02를 부여한다.
conn system/ora123
grant mrole02 to user05;

--4. user05 계정으로 접속 후, 검색을 해본다.
conn user05/tiger
select * from scott.emp;

----------------------------------------------------------------------
-- 동의어(synonym)
--1. 비공개 동의어
--  : 객체에 대한 접근 권한을 부여받은 사용자가 정의한 동의어로 해당 사용자만
--    사용할 수 있다.

--2. 공개 동의어
--   DBA 권한을 가진 사용자만 생성할 수 있으며, 누구나 사용할 수 있다.

--   공개 동의어의 예
--   sys.tab    --->  tab
--   sys.dual   --->  dual

select * from sys.tab;
select * from tab;              --  공개 동의어

select 10+20 from sys.dual;
select 10+20 from dual;         --  공개 동의어

-- 비공개 동의어 예제
--1. system 계정으로 접속 후 테이블 생성
conn system/ora123
create table systbl(ename varchar2(20));

--2. 생성된 테이블에 데이터 추가
conn system/ora123
insert into systbl values('안화수');
insert into systbl values('홍길동');

select * from systbl;

--3. scott 계정에게 systbl 테이블에 select객체 권한 부여
conn system/ora123
grant select on systbl to scott;

--4. scott 계정으로 접속 후 검색
conn scott/tiger
select * from systbl;           --  오류 발생
select * from system.systbl;    --  검색 가능함

--5. scott 계정에게 동의어를 생성할 수 있는 권한을 부여한다.
conn system/ora123
grant create synonym to scott;

--6. scott 계정으로 접속 후 비공개 동의어 생성 : system.systbl --> systbl
--   생성된 비공개 동의어는 scott 계정만 사용 가능함.
conn scott/tiger
create synonym  systbl for system.systbl;

--7. 동의어를 이용해서 검색
conn scott/tiger
select * from system.systbl;
select * from systbl;           -- 검색 가능함 (비공개 동의어)

--8. 동의어 목록
conn scott/tiger
select * from user_synonyms;

--9. 동의어 삭제
conn scott/tiger
-- 형식 : drop synonym  synonym_name;
drop synonym systbl;



-- 공개 동의어
-- 1. DBA 계정으로 접속해서 공개 동의어를 생성할 수 있다.
-- 2. 공개 동의어를 만들때 public 을 붙여서 생성할 수 있다.

-- 공개 동의어 생성
conn system/ora123
create public synonym  pubdept for scott.dept;

-- 공개 동의어 목록
conn system/ora123
select * from dba_synonyms;

-- 공개 동의어 삭제
conn system/ora123
drop public synonym pubdept;