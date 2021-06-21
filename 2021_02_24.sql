-- 2021.02.24 (수)

-- Oracle
-- 테이블 목록 (scott계정 소유의 테이블 목록을 보여달라)
select * from tab;
-- MySQL일때 테이블 목록
show tables;

-- DEPT 테이블 구조
describe dept;
desc dept;

-- DEPT 테이블의 데이터 검색
select * from dept;

-- EMP 테이블 구조
desc emp;

-- EMP 테이블의 데이터 검색
select * from emp;

-- 오라클의 데이터 타입
-- 1. 숫자 데이터
--      number(정수)    : number(2) 정수 2자리까지 저장
--      number(n1, n2)  : n1: 전체 자리수 , n2 : 소숫점에 할당된 자리수
-- 2. 문자 데이터
--      char() : 고정 길이 문자형 (값이 길이가 정해져있을때 사용) 최대 2000byte
--      varchar2() : 가변 길이 문자형 (지정된 범위 내에서 실제 사용한 공간만큼만 사용) 최대 4000byte
--      long : 2GB 까지 저장 가능 (검색기능은 지원 안해준다고 함)
-- 3. 날짜 데이터
--      date : 년/월/일 정보 저장
--      timestamp : 년/월/일 시:분:초
-- select SQL문
select * from dept;

select loc, deptno, dname from dept;

select empno, ename, sal from emp;

-- column의 데이터가 NUMBER일때 산술연산자 가능(+, -, *, -)
select sal + comm from emp;
select sal - 100 from emp;
select sal * 100 from emp;
select sal / 100 from emp;

--Q. 사원테이블(EMP)에 소속된 사원들의 연봉을 구해보자?
-- 연봉 = 급여(SAL) * 12 + 커미션(COMM)
select ename, job, sal, comm, sal * 12 + comm from emp;
select ename, job, sal, comm, sal * 12 + NVL(comm,0) from emp;
select ename, job, sal, comm, sal * 12 + DECODE(comm, NULL, 0, comm) from emp;
select ename, job, sal, comm, sal * 12 + case when comm is null then 0 else comm end comm_yn from emp;

-- NULL
--1. 정해지지 않은 값을 의미
--2. NULL 값은 산술연산을 할 수 없다.
--3. NULL 값의 예
--   EX) EMP 테이블 : MGR 컬럼
--                   COMM 컬럼

-- NVL(컬럼, 변환될 값) : NULL 값을 다른 값(0) 으로 변환 해주는 함수
-- ex) NVL( comm, 0 )

-- 별칭 부여하기 : as "별칭명"
-- 별칭명에 띄어쓰기가 있을 경우에는 쌍따옴표를 생략 할 수 없다.
select ename, job, sal, comm, sal * 12 + NVL(comm,0) as "Annsal" from emp;
select ename, job, sal, comm, sal * 12 + NVL(comm,0) "Annsal" from emp;


-- Concatenation 연산자 : ||
-- 컬럼과 문자열을 연결할 때 사용함.
select ename, 'is a', job from emp;
select ename || ' is a ' || job from emp;

-- distinct : 중복행을 제거하고 1번만 출력
select deptno from emp; --원본
select distinct deptno from emp;

--Q. EMP 테이블에서 각 사원들의 JOB을 1번만 출력하는 SQL문을 작성하세요.
select distinct job from emp;

-- EMP 테이블의 총 데이터 수| 구하기
-- count(컬럼명) : 데이터 갯수 구하기
select count(*) from emp;

--Q. EMP 테이블에서 중복을 제거한 JOB의 갯수를 구하는 SQL문 작성 하세요?
select count(distinct job) from emp;


-----------------------------------------------------------------------------------
-- where 조건절 : 비교 연산자 ( =, >, >=, <, <= , <>,!=,^= )
-- 1. 숫자 데이터 검색
-- Q. 사원 테이블에서 급여를 3000 이상 받는 사원을 검색하는 SQL문 작성
select * from emp where sal >= 3000;
-- Q. 급여가 3000인 사원을 검색?
select * from emp where sal = 3000;
-- Q. 급여가 3000이 아닌 사원을 검색?
select * from emp where sal != 3000;
select * from emp where sal <> 3000;
select * from emp where sal ^= 3000;
-- Q. 급여가 1500 이하인 사원의 사원번호, 사원명, 급여를 출력하는 SQL문 작성?
select empno, ename, sal from emp where sal <= 1500;


-- 2. 문자 데이터 검색
-- 1) 문자 데이터는 대.소문자를 구분한다
-- 2) 문자 데이터를 검색 할때는 문자열 좌.우에 외따옴표(')를 붙여야 한다.
--Q. 사원 테이블 사원명이 FORD 인 사원의 정보를 검색하는 SQL문 작성? '(대소문자 구분)'
select * from emp where ename = FORD;  -- 오류
select * from emp where ename = "FORD"; -- 오류
select * from emp where ename = 'FORD';
-- 대소문자 구분없이 검색하는 법
select * from emp where LOWER(ename) = LOWER('ford');
select * from emp where upper(ename) LIKE upper('ford');
--Q. SCOTT 사원의 사원번호, 사원명, 급여를 출력하는 SQL문 작성?
select empno, ename, sal from emp where ename = 'SCOTT';


-- 3. 날짜 데이터 검색
-- 1) 날짜 데이터를 검색할때 날짜 좌.우에 외따옴표(')를 붙여야 한다.
-- 2) 날짜 데이터를 비교할때 비교 연산자를 사용한다.
-- Q. 1982년 1월 1일 이후에 입사한 사원을 검색하는 SQL문 작성?
select * from emp where hiredate >= 82/01/01;  -- 오류
select * from emp where HIREDATE >= '82/01/01';
select * from emp where HIREDATE >= '1982/01/01' order by hiredate asc;
desc emp;

