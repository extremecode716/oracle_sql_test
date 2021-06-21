-- 2021.03.03(수)

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
rollback;   -- 트랜잭션이 종료 되었기 때문에 삭제된 20번 데이터를 복구하지 못한다


-- 자동 커밋 : 자동으로 커밋이 수행
-- 1) 정상적인 종료 : quit, exit, con.close()
-- 2) DDL(create, alter, rename, truncate, drop), DCL(grant, revoke) 
--    명령이 수행

-- 예1.
select * from dept01;   -- 10, 30, 40
delete from dept01 where deptno = 40;       -- 40번 데이터 삭제

create table dept03 as select * from dept;  -- 자동 커밋 수행(DDL)

rollback;    -- 삭제된 40번 부서를 복구하지 못한다.
select * from dept01;

--예2.
-- DML(delete), DDL(truncate)
select * from dept01;   -- 10, 30

delete from dept01 where deptno=30;     -- DML(delete)
rollback;               --  삭제된 30번 부서를 복구한다.

select * from dept01;   -- 10, 30
truncate table dept01;  -- 자동 커밋 수행(DDL)
rollback;               --  dept01 테이블의 데이터를 복구하지 못한다.

-- 자동 롤백
-- : 비정상적인 종료 (강제로 창을 닫는 경우, 컴퓨터가 다운되는 경우)

-- savepoint : 임시 저장점을 지정
--[실습]
drop table dept01 purge;

--1. dept01 테이블 생성
create table dept01 as select * from dept;
select * from dept01;

--2. 40번 부서 삭제
delete from dept01 where deptno=40;

--3. commit 수행 : 트랜잭션 종료
commit;

--4. 30번 부서 삭제
delete from dept01 where deptno=30;

--5. c1저장점 지정
savepoint c1;

--6. 20번 부서 삭제
delete from dept01 where deptno=20;

--7. c2 저장점 지정
savepoint c2;

--8. 10번 부서 삭제
delete from dept01 where deptno=10;

--9. c2저장점까지 복구
rollback to c2;
select * from dept01;       -- 10

--10. c1저장점까지 복구
rollback to c1;
select * from dept01;       -- 10, 20

--11. 이전 트랜잭션 종류 이후를 복구
rollback;
select * from dept01;       -- 10, 20, 30

--------------------------------------------------------------------------
--  무결성 제약조건 (Data Integrity Constraint Rule) DICR
-- : 테이블에 부적절한 데이터가 입력되는 것을 방지하기 위해서 테이블을 생성할 때
--    각 컬럼에 대해서 정의하는 여러가지 규칙을 말한다.
--   ex) not null, unique, primary key, foreign key, check, default

-- 제약 조건 확인
desc user_constraints; -- 데이터 딕셔너리
-- P: primary key, R: foreign key, U: unique, C:check, not null
select constraint_name, constraint_type, table_name from user_constraints;
--    1. 제약조건명      2.제약조건유형     3.테이블소속명
--EMP04_EMPNO_UK
--테이블명_칼럼명_제약 조건유형
CREATE TABLE EMP04( 
EMPNO NUMBER(4) CONSTRAINT EMP04_EMPNO_UK UNIQUE, -- 컬럼 레벨 방식(컬럼명 옆에 제약조건을 붙이는 방식)
ENAME VARCHAR2(10) CONSTRAINT EMP04_ENAME_NN NOT NULL, 
JOB VARCHAR2(9),
DEPTNO NUMBER(2)
);

--------------------------------------------------------------------------------
--1. not null 제약 조건
--   null을 허용하지 않는다.
--   반드시 값을 입력 해야 된다.
--[실습]
drop table emp02 purge;
create table emp02(
    empno number(4) not null,
    ename varchar2(12) not null,
    job varchar2(12),
    deptno number(2));

insert into emp02 values(1111, '안화수', 'MANAGER', 30);  --데이터 입력
select * from emp02;

-- 제약조건(NOT NULL)에 위배되기 때문에 데이터 입력이 안됨
insert into emp02 values(null, null, 'SALESMAN', 30); 

--2. unique 제약 조건
--   유일한 값만 입력할 수 있다.
--   중복된 값을 입력할 수 없다.
--   null 값은 입력할 수 있다.(null값은 허용된다)
drop table emp03 purge;
create table emp03(
    empno number(4) unique,
    ename varchar2(12) not null,
    job varchar2(12),
    deptno number(2));
    
select * from emp03;
insert into emp03 values(1111, '안화수', 'MANAGER', 10);

-- unique 제약조건에 위배
insert into emp03 values(1111, '홍길동', 'MANAGER', 10);

-- unique제약조건이 설정된 컬럼에 null 값 입력 가능함
insert into emp03 values(null, '안화수', '개발자', 20);
insert into emp03 values(null, '홍길동', '개발자', 30);

--3. primary key (기본키)
--   primary key = not null + unique
--   반드시 중복되지 않는 값을 입력 해야된다.
--   ex) 부서테이블(DEPT) - deptno (pk)
--       사원테이블(EMP) - empno (pk)

select * from dept;
insert into dept values(10,'개발부','서울');    --unique제약조건 위배
insert into dept values(null,'개발부','서울');  --not null제약조건 위배
-- DEPT 테이블의 deptno 컬럼은 primary key 제약조건이 설정되어 있기 때문에,
-- 중복된 값과 null값을 입력할 수 없다.

select * from emp;
insert into emp(empno, ename) values(7788, '안화수');--unique제약조건 위배
insert into emp(empno, ename) values(null, '안화수');--not null제약조건 위배

drop table emp05 purge;
create table emp05(
    empno number(4) primary key,
    ename varchar2(12) not null,
    job varchar2(12),
    deptno number(2));
    
select * from emp05;   
insert into emp05 values(1111,'안화수','개발자',20); -- 정상적인 입력
insert into emp05 values(1111,'홍길동','개발자',20); --unique제약조건 위배
insert into emp05 values(null,'홍길동','개발자',20); --not null제약조건 위배

--4. foreign key (외래키)
--   DEPT(부모테이블) - deptno(pk, 부모키) : 10, 20, 30, 40
--   EMP(자식테이블) - deptno(fk) : 10, 20, 30

-- 1) 사원테이블(EMP)의 deptno 컬럼이 foreign key 제약조건이 설정되어 있다.
-- 2) foreign key 제약조건이 가지고 있는 의미는 부모테이블(DEPT)의 부모키(deptno)의
--    값만 참조할 수 있다. (10, 20, 30, 40번 부서번호만 참조할 수 있다.)
-- 3) 부모키가 되기 위한 조건은 primary key나 unique 제약조건이 설정되어 있어야 한다.

--Q.사원테이블(EMP)에 사원정보를 등록 해보자?
--  외래키가 설정된 컬럼(EMP-deptno)은 부모키(DEPT-deptno)안에 있는 값(10,20,30,40)만
--  참조할 수 있다.
insert into emp(empno, deptno) values(1111, 50); -- 제약조건 위배

--[실습]
drop table emp06 purge;
create table emp06(
    empno number(4) primary key,
    ename varchar2(10) not null,
    job varchar2(10),
    deptno number(2) references dept(deptno) );  -- foreign key
    
select * from emp06;    
insert into emp06 values(1111, '안화수', 'MANAGER', 10);
insert into emp06 values(1112, '안화수', 'MANAGER', 20);
insert into emp06 values(1113, '안화수', 'MANAGER', 30);
insert into emp06 values(1114, '안화수', 'MANAGER', 40);
insert into emp06 values(1115, '안화수', 'MANAGER', 50); -- 제약조건에 위배

--5. check 제약조건
--   : 데이터가 입력될때 특정 조건을 만족하는 데이터만 입력되도록 만들어 주는 제약조건
create table emp07(
    empno number(4) primary key,
    ename varchar2(10) not null,
    sal number(7,2) check(sal between 500 and 5000), -- sal : 500 ~ 5000
    gender varchar2(1) check(gender in('M','F') ));  -- gender : 'M','F'

select * from emp07;
insert into emp07 values(1111,'안화수',3000,'M');  -- 정상적인 입력
insert into emp07 values(1112,'안화수',8000,'M');  -- check제약조건 위배
insert into emp07 values(1113,'안화수',5000,'m');  -- check제약조건 위배

--6. default 제약조건
--   default 제약조건이 설정된 컬럼에  값이 입력되지 않으면 default로 설정된 값이
--   자동으로 입력된다.

drop table dept01 purge;
create table dept01(
    deptno number(2) primary key,
    dname varchar2(14),
    loc varchar2(13) default 'SEOUL');
--  count number default 0,

select * from dept01;
insert into dept01 values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept01(deptno, dname) values(20, 'RESEARCH'); 

--------------------------------------------------------------------------
-- 제약조건 설정 방식
--1. 컬럼레벨 방식으로 제약조건 설정
--2. 테이블레벨 방식으로 제약조건 설정

--1. 컬럼레벨 방식으로 제약조건 설정
drop table emp01 purge;

create  table  emp01(	
	empno  number(4)  primary  key,
	ename  varchar2(15)  not null,
	job  varchar2(10)  unique,
 	deptno  number(4)  references  dept(deptno) );
    
--2. 테이블레벨 방식으로 제약조건 설정    
drop table emp02 purge;

create table emp02(
    empno number(2),
    ename varchar2(15) not null,
    job varchar2(10),
    deptno number(4),
    primary key(empno),
    unique(job),
    foreign key(deptno) references dept(deptno) );
    
    
-- 제약조건을 설정할때 테이블 레벨 방식만 가능한 경우
--1. 복합키로 기본키를 지정할 경우
--    2개 이상의 컬럼을 기본키롤 설정하는 경우
--2. alter table로 제약 조건을 추가할 경우

--1. 2개 이상의 컬럼을 기본키를 설정하는 경우
drop table member01 purge;

-- 컬럼레벨 방식으로 2개의 컬럼을 primary key로 설정할 수 없다.
create table member01(
    id varchar2(20)  primary key,
    passwd varchar2(20) primary key);   -- 테이블 생성안됨

-- 테이블레벨 방식으로 2개의 컬럼을 primary key로 설정할 수 있다.
create table member01(
    id varchar2(20),
    passwd varchar2(20),
    primary key(id, passwd));           -- 테이블 생성됨
    
    
--2. alter table로 제약 조건을 추가할 경우    
drop table emp01 purge;

-- 제약조건이 없는 테이블 생성
create  table  emp01(	
	empno  number(4),
	ename  varchar2(15),
	job  varchar2(10),
 	deptno  number(4) );
    
-- primary key 제약조건 추가 : empno    
alter table emp01 add primary key(empno);   

-- not null 제약조건 추가 : ename
alter table emp01 modify ename not null;

-- unique 제약조건 추가 : job
alter table emp01 add unique(job);

-- foreign key 제약조건 추가 : deptno
alter table emp01 add foreign key(deptno) references dept(deptno); 


-- 제약조건 제거
-- 형식 : alter table 테이블 drop  constraint  constraint_name;

-- primary key 제약조건 제거
alter table emp01 drop constraint SYS_C007031;
alter table emp01 drop primary key;

-- unique 제약조건 제거
alter table emp01 drop constraint SYS_C007033;
alter table emp01 drop unique(job); 

-- not null 제약조건 제거
alter table emp01 drop constraint SYS_C007032;

-- foreign key 제약조건 제거
alter table emp01 drop constraint SYS_C007034;


-- 제약 조건의 활성화 / 비활성화
--1. 부모 테이블 생성
drop table dept01 purge;
create table dept01(
    deptno number(2) primary key,
    dname varchar2(14),
    loc varchar2(13));
    
insert into dept01 values(10, 'ACCOUNTING', 'NEW YORK');    

--2.자식 테이블 생성
drop table emp01 purge;
create table emp01(
    empno number(4) primary key,
    ename varchar2(10) not null,
    job varchar2(10) unique,
    deptno number(2) references dept01(deptno) );

insert into emp01 values(1111, '안화수', 'SALESMAN', 10);
select * from emp01;

--3. 부모 테이블의 데이터 삭제
delete from dept01; -- 자식테이블(emp01)에서 참조하고 있기 때문에 삭제 안됨.

-- 부모 테이블(DEPT01)의 데이터를 삭제하기 위해서는 자식 테이블(EMP01)의
-- foreign key 제약조건을 비활성화 시키면, 부모 테이블의 데이터를 삭제할 수 있다.

-- 자식 테이블(EMP01)의 foreign key 제약조건을 비활성화 시켜보자?
-- 형식 : alter table 테이블명  disable constraint  constraint_name;
alter table emp01 disable constraint SYS_C007040;

--cf. foreign key 제약조건을 활성화
alter table emp01 enable constraint SYS_C007040;

--4. cascade 옵션
-- 부모의 제약조건을 비활성화 시키면, 참조하고 있는 자식의 제약조건도 같이 비활성화 
-- 시켜주는 옵션

-- cascade 옵션을 붙여서 부모 테이블(DEPT01)의 제약조건을 비활성화 시키면, 참조하고
--  있는 자식 테이블(EMP01)의 foreign key제약조건도 같이 비활성화 된다.
alter table dept01 disable constraint SYS_C007036 cascade;

-- cascade 옵션을 붙여서 부모 테이블(DEPT01)의 제약조건을 제거하면, 참조하고 있는
-- 자식 테이블(EMP01)의 foreign key 제약조건도 같이 제거된다.
alter table dept01 drop constraint SYS_C007036 cascade;
alter table dept01 drop primary key cascade;



