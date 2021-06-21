-- 2021.03.02 (화)

-- DDL(Data Definition Language) : 데이터 정의어
-- create : 테이블 생성
-- alter : 테이블 구조 변경
-- rename : 테이블 이름 변경
-- drop : 테이블 삭제
-- truncate : 데이터 삭제

-- 테이블 목록 확인
select * from tab;

--1. create
-- : 데이터베이스, 테이블 생성
--  1) 테이블 생성
create table emp01(
    empno number(4),
    ename varchar2(20),
    sal number(7,2));
    
--  2) 서브쿼리로 테이블 생성
--     복사본 테이블이 생성됨
--      단, 제약조건은 복사 되지 않는다.
drop table emp02 purge;            -- 임시테이블로 교체되지 않고 깨끗하게 삭제
purge recyclebin;                  -- 임시테이블 삭제
create table emp02 as select * from emp;
select * from emp02;
desc emp02; -- 제약조건 복사x
desc emp;

-- 원하는 컬럼으로 구성된 복사본 테이블 생성
create table emp03 as select empno, ename from emp;
select * from emp03;
desc emp03;

-- 원하는 행으로 구성된 복사본 테이블 생성
create table emp04 as select * from emp where deptno = 10;
select * from emp04;

--테이블 구조만 복사하기
create table emp05 as select * from emp where 1=0; -- 조건 false로
select * from emp05;

--2. alter
--  : 테이블 구조를 변경 (컬럼추가, 컬럼값 수정, 컬럼 삭제)
--  1) 컬럼 추가
alter table emp01 add(job varchar2(10));
desc emp01;

-- 2) 컬럼값 수정
--    i) 해당 컬럼에 데이터가 없는 경우
--       컬럼의 데이터 타입을 변경할 수 있다.
--       컬럼의 크기를 변경할 수 있다.
--    ii) 해당 컬럼에 데이터가 있는 경우
--        컬럼의 데이터 타입을 변경할 수 없다.
--        자료형의 크기는 늘릴수는 있지만, 현재의 데이터의 크기보다 작은 크기로 
--        변경할 수 없다.
alter table emp01 modify(job varchar2(30));
desc emp01;

-- 3) 컬럼 삭제
alter table emp01 drop column job;
alter table emp01 drop(job);
desc emp01;

-- cf. 비번 변경
alter user 계정명 identified by 비밀번호;

-- 3. rename
--  : 테이블 이름 변경
-- 형식 : rename old_name to new_name;
--Q. emp01 테이블을 test 테이블명으로 변경 해보자?
rename emp01 to test;
select * from tab;

-- 4. truncate
--    : 테이블의 모든 데이터 삭제 where 불가능.(롤백으로 복구 불가o 가능한 사용하지말 것)
-- 형식 : truncate table table_name;
select * from emp02;
truncate table emp02;

-- 5. drop
--   : 테이블 삭제
-- 형식 : drop table table_name;        --(oracle 10g부터는 임시테이블로 교체)
--       drop table table_name purge;   -- (깨끗하게 삭제됨)

drop table test;
select * from tab;

-- 임시 테이블 삭제
purge recyclebin;

-------------------------------------------------------------------------
-- 1.오라클의 객체
--    테이블, 뷰, 시퀀스, 인덱스, 동의어, 프로시저, 트리거

-- 2. 데이터 딕셔너리와 데이터 딕셔너리 뷰

--    데이터 딕셔너리 뷰 : user_xxxx
--    (가상 테이블)       all_xxxx
--                      dba_xxxx

--  데이터 딕셔너리(시스템 테이블) : 
--select table_name from user_tables; (테이블)
--select * from user_views; (뷰)
--select * from user_sequences; (시퀀스)
--select * from user_indexes; (인덱스)
--select * from user_synonyms; (동의어)
--select * from user_source; (프로시저)
--select * from user_triggers; (트리거)
--select table_name from all_tables;
--select table_name from dba_tables; (DBA 계정만 사용가능)
--select user_name from dba_users; (DBA 계정만 사용가능)
 
 -- SCOTT 계정 소유의 테이블 객체에 대한 정보를 조회
select * from tab;

select * from user_tables;

-- 자신 계정 소유 또는 권한을 부여받은 객체 등에 관한 정보를 조회
select * from all_tables;

-- DBA 계정만 사용 가능함.
select * from dba_tables;

-- 오라클 시스템의 계정 정보 검색
select * from dba_users;

-------------------------------------------------------------------------
-- DML(Data Manipulation Language, 데이터 조작어) : insert, update, delete

--1. insert
--1)형식 : insert into 테이블(컬럼1, 컬럼2,...) values(데이터1, 데이터2,...);  
--        insert into 테이블  values(데이터1, 데이터2, ....);

-- [실습]
drop table dept01 purge;

-- 비어있는 dept01 복사본 테이블 생성
create table dept01 as select * from dept where 1=0;

select * from dept01;

insert into dept01(deptno, dname, loc) values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept01 values(20, 'RESEARCH', 'DALLAS');
insert into dept01 values(30, '영업부', '서울');

-- null 값 입력
insert into dept01(deptno, dname) values(40, '개발부');
insert into dept01 values(50, '기획부', NULL);

-- 2)서브쿼리로 데이터 입력
drop table dept02 purge;
create table dept02 as select * from dept where 1=0;  -- 테이블 구조만 복사
select * from dept02;
select count(*) from dept02;

insert into dept02 select * from dept;
insert into dept02 select * from dept02;

--2. update : 데이터 수정
-- 형식 : update  테이블명  set  컬럼1 = 수정할 값1,
--                             컬럼2 = 수정할 값2,...
--        where  조건절;

--[실습]
drop table emp01 purge;
create table emp01 as select * from emp;    -- 복사본 테이블 생성
select * from emp01;

-- 1) 모든 데이터 수정
-- Q1. 모든 사원들의 부서번호를 30번 수정
update emp01 set deptno = 30;

--Q2. 모든 사원들의 입사일을 오늘날짜로 수정
update emp01 set hiredate = sysdate;

-- 2) 특정 데이터만 수정 : where 조건절 사용
--Q3. 급여가 3000 이상인 사원만 급여를 10% 인상 
update emp01 set sal = sal * 1.1 where sal >= 3000;

--3. delete : 데이터 삭제
-- 형식 : delete from 테이블명  where 조건절; 

-- 1) 모든 데이터 삭제
delete from dept01;
select * from dept01;
rollback;               -- 트랜잭션을 취소

-- 2) 조건을 만족하는 데이터 삭제
delete from dept01 where deptno = 30;

-------------------------------------------------------------------
-- 트랜잭션(Transaction) : 논리적인 작업 단위

-- TCL(Transaction Control Language)
-- commit : 트랜잭션을 종료
-- rollback : 트랜잭션을 취소
-- savepoint : 복구할 시점(저장점)을 지정하는 역할

-- [실습]
drop table dept01 purge;
create table dept01 as select * from dept;  -- 복사본 테이블 생성
select * from  dept01;

-- rollback : 트랜잭션을 취소(데이터 복구)
delete from dept01;
rollback;   -- 트랜잭션을 취소

-- commit : 트랜잭션을 종료
delete from dept01 where deptno=20;
commit;     -- 트랜잭션을 종료
rollback;   -- 트랜잭션이 종료 되었기 때문에 삭제된 20번 데이터를 복구하지 못한다.




