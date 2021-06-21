-- 2021.03.04(목)

-- 시퀀스(sequence)
-- : 테이블에 숫자를 자동으로 증가 시켜서 처리해주는 역할

-- 시퀀스 생성
create sequence dept_deptno_seq
start with 10           -- 시작할 번호
increment by 10;        -- 증가치

-- 시퀀스 목록
select * from seq;
select * from user_sequences;

-- currval : 시퀀스 현재값을 반환
-- nextval : 시퀀스 다음값을 반환

select dept_deptno_seq.nextval from dual;
select dept_deptno_seq.currval from dual;

-- 예1. 시퀀스를 테이블의 기본키에 적용하기
drop table emp01 purge;
create table emp01(
    empno number(4) primary key,
    ename varchar2(10),
    hiredate date);

create sequence emp01_empno_seq;    -- 1부터 1씩 증가되는 시퀀스 생성

select * from tab;      -- 테이블 목록 확인
select * from seq;      -- 시퀀스 목록 확인

-- 데이터 입력
insert into emp01 values(emp01_empno_seq.nextval, '안화수', sysdate );

select * from emp01;

-- 시퀀스 삭제
-- drop  sequence  시퀀스 이름;
drop sequence dept_deptno_seq;

-- 시퀀스 수정
create sequence dept_deptno_seq
start with 10       -- 시작값
increment by 10     -- 증가치
maxvalue 30;        -- 최대값

-- 시퀀스 목록
select * from seq;

-- 시퀀스 다음값 구해오기
select dept_deptno_seq.nextval from dual;   -- 10 구해옴
select dept_deptno_seq.nextval from dual;   -- 20 구해옴
select dept_deptno_seq.nextval from dual;   -- 30 구해옴
select dept_deptno_seq.nextval from dual;   -- 오류 발생

-- 시퀀스 수정 : maxvalue : 30 -->  100000
alter sequence dept_deptno_seq maxvalue 100000;

-- 시퀀스 수정 확인
select * from seq;

-- 시퀀스 다음값 구해오기
select dept_deptno_seq.nextval from dual;   -- 40 구해옴


-----------------------------------------------------------------------
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
set timing off

--5. 검색용 데이터로 검색시간을 측정 : 인덱스가 설정되지 않은 경우
select * from emp01 where ename = 'ahn';    -- 11.85초

--6. 인덱스 생성 : ename 컬럼에 인덱스 적용
create index idx_emp01_ename on emp01(ename);

select * from user_indexes;     -- 인덱스 목록 확인

--7. 검색용 데이터로 검색시간을 측정 : 인덱스가 설정된 경우
select * from emp01 where ename = 'ahn';    -- 0.568초