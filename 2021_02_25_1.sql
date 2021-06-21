-- 2021.02.25_1 (목)

desc emp;
select * from emp;

-- 논리 연산자 : and, or, not
--1. and 연산자 : 두 조건식을 모두 만족하는 데이터를 검색
--Q. 사원 테이블에서 부서번호가 10번이고, job이 MANAGER인 사원을 검색하는 SQL문 작성?
select * from emp where deptno=10 AND job='MANAGER';

--2. or 연산자 : 두 조건식 중에서 한가지만 만족해도 검색
--Q.사원 테이블에서 부서 번호가 10번 이거나, job이 MANAGER인 사원을 검색하는 SQL문 작성?
select * from emp where deptno=10 or job='MANAGER';

--3. not 연산자 : 논리값을 반대로 바꿔주는 역할
--Q. 부서번호가 10번이 아닌 사원을 검색하는 SQL문 작성?
select * from emp where deptno = 10;        -- 10번 부서

select * from emp where not deptno = 10;    -- 논리 연산자
select * from emp where deptno != 10;       -- 비교 연산자
select * from emp where deptno ^= 10;       -- 비교 연산자
select * from emp where deptno <> 10;       -- 비교 연산자

--Q1.급여를 2000에서 3000 사이의 급여를 받는 사원을 검색하는 SQL문 작성?
select * from emp where sal>=2000 and sal<=3000;

--Q2.커미션이 300이거나 500이거나 1400인 사원을 검색하는 SQL문 작성?
select * from emp where comm=300 or comm=500 or comm=1400;

--Q3.사원번호가 7521이거나 7654이거나 7844인 사원을 검색하는 SQL문 작성?
select * from emp where empno=7521 or empno=7654 or empno=7844;

-- between  and 연산자
-- : where  컬럼명  between  작은값 and  큰값
--Q.급여를 2000에서 3000 사이의 급여를 받는 사원을 검색하는 SQL문 작성?
select * from emp where sal>=2000 and sal<=3000;
select * from emp where sal between 2000 and 3000;
select * from emp where sal between 3000 and 2000;  -- 검색 결과 없음

--Q. 급여가 2000 미만이거나 3000을 초과한 사원을 검색하는 SQL문 작성?
select * from emp where sal < 2000 or sal > 3000;
select * from emp where sal not between 2000 and 3000;

--Q.1987년도에 입사한 사원을 검색하는 SQL문 작성?
select * from emp where hiredate >='87/01/01' and hiredate <= '87/12/31';
select * from emp where hiredate between '87/01/01' and '87/12/31';

-- in연산자
-- : where  컬럼명  in (데이터1, 데이터2,....)
--Q.커미션이 300이거나 500이거나 1400인 사원을 검색하는 SQL문 작성?
select * from emp where comm=300 or comm=500 or comm=1400;
select * from emp where comm in(300, 500, 1400);

--Q.커미션이 300, 500, 1400이 아닌 사원을 검색하는 SQL문 작성?
select * from emp where comm != 300 and comm != 500 and comm != 1400;
select * from emp where comm not in(300, 500, 1400);

--Q.사원번호가 7521이거나 7844인 사원들을 검색하는 SQL문을 in연산자로 작성?
select * from emp where empno = 7521 or empno = 7844;
select * from emp where empno in(7521, 7844);

-------------------------------------------------------------------------
-- like 연산자와 와일드 카드
-- : where  컬럼  like  pattern

-- 와일드 카드
-- 1. % : 문자가 없거나, 하나 이상의 문자가 어떤 값이 와도 상관없다.
-- 2. _ : 하나의 문자가 어떤 값이 와도 상관없다.

-- % 와일드 사용
--Q.사원테이블에서 사원명이 대문자 F로 시작하는 사원을 검색하는 SQL문 작성?
select * from emp where ename = 'FORD';     -- FORD 사원만 검색됨
select * from emp where ename like 'F%';

--Q.사원테이블에서 사원명이 대문자 N으로 끝나는 사원을 검색하는 SQL문 작성?
select * from emp where ename like '%N';

--Q.사원테이블에서 사원명에 대문자 A가 포함된 사원을 검색하는 SQL문 작성?
select * from emp where ename like '%A%';

-- 언드바(_) 와일드 카드
-- 언드바(_) :  하나의 문자에 어떤 값이 와도 상관없다.
--Q. 사원 이름의 두번째 글자가 A인 사원을 검색하는 SQL문 작성?
select * from emp where ename like '_A%';

--Q. 사원 이름의 세번째 글자가 A인 사원을 검색하는 SQL문 작성?
select * from emp where ename like '__A%';

--Q. 사원 이름이 끝에서 2번째 글자가 E인 사원을 검색하는 SQL문 작성?
select * from emp where ename like '%E_';

-- not like 연산자
--Q. 사원명에 A가 포함되어 있지 않은 사원을 검색하는 SQL문 작성?
select * from emp where ename like '%A%';       -- A가 포함된 사원검색
select * from emp where ename not like '%A%';
------------------------------------------------------------------------
-- null 값 검색
-- ex) EMP테이블 : MGR컬럼, COMM컬럼
--Q. MGR 컬럼에 null 값인 데이터를 검색?
select * from emp where mgr = null;     -- 검색 안됨
select * from emp where mgr = '';       -- 검색 안됨

select * from emp where mgr is null;

--Q. COMM 컬럼에 null 값인 데이터를 검색?
select * from emp where comm = null;    -- 검색 안됨
select * from emp where comm = '';      -- 검색 안됨

select * from emp where comm is null;

--Q. COMM 컬럼에 null 값이 아닌 데이터 검색?
select * from emp where comm is not null;

-----------------------------------------------------------------------
-- 정렬 :  order  by  컬럼명   정렬방식(asc, desc)
-- 정렬 방식 : 오름차순(ascending), 내림차순(descending)

--           오름차순                           내림차순
-----------------------------------------------------------------------
-- 숫자: 작은 숫자부터 큰숫자로 정렬(1,2,3..)    큰숫자부터 작은 숫자로 정렬
-- 문자: 사전순 정렬(a,b,c..)                  사전 역순 정렬(z,y,x,,,)
-- 날짜: 빠른날짜 순으로 정렬                   늦은날짜 순으로 정렬
-- NULL: NULL값이 가장 마지막에 출력            NULL값이 가장 먼저 출력

--1.숫자 데이터 정렬
--Q.사원 테이블에서 급여를 기준으로 오름차순 정렬
select ename, sal from emp order by sal asc;

-- 정렬방식(asc, desc)이 생략되면, 기본 정렬 방식이 오름차순으로 정렬함.
select ename, sal from emp order by sal;

--Q.사원 테이블에서 급여를 기준으로 내림차순 정렬
select ename, sal from emp order by sal desc;

--2.문자 데이터 정렬
--Q.사원 테이블에서 사원명을 기준으로 오름차순 정렬 : 사전순 정렬
select ename from emp order by ename asc;
select ename from emp order by ename;

--Q.사원 테이블에서 사원명을 기준으로 내람차순 정렬 : 사전역순 정렬
select ename from emp order by ename desc;

--3.날짜 데이터 정렬
--Q.사원 테이블에서 입사일을 기준으로 오름차순 정렬 : 빠른 날짜순 정렬
select  hiredate from emp order by hiredate asc;

--Q.사원 테이블에서 입사일을 기준으로 내림차순 정렬 : 늦은 날짜순 정렬
select hiredate from emp order by hiredate desc;

--4.NULL값 정렬
-- 1) 오름차순 정렬: NULL값이 가장 마지막에 출력
-- 2) 내림차순 정렬: NULL값이 가장 먼저 출력

--Q. MGR컬럼을 기준으로 오름차순 정렬
select mgr from emp order by mgr asc;   -- NULL값이 가장 마지막에 출력

--Q. MGR컬럼을 기준으로 내림차순 정렬
select mgr from emp order by mgr desc;  -- NULL값이 가장 먼저 출력

--Q. comm컬럼을 기준으로 오름차순 정렬
select comm from emp order by comm asc; -- NULL값이 가장 마지막에 출력

--Q. comm컬럼을 기준으로 내림차순 정렬
select comm from emp order by comm desc; -- NULL값이 가장 먼저 출력


-- 여러번 정렬하기
--1. 한번 정렬했을때 동일한 결과가 나오는 데이터가 있을 경우에 한번 더 정렬을 해야한다.
--2. 두번째 정렬 조건은 한번 정렬했을때 동일한 결과가 나온 데이터만 두번째 정렬조건의
--   적용을 받는다.
--3. 댓글 게시판을 만들 경우에 주로 사용한다.

--Q. 사원 테이블에서 급여를 기준으로 내림차순 정렬을 한다. 이때 동일한 급여를 받는 
--   사원들은 사원명을 기준으로 오름차순으로 정렬해서 출력하는 SQL문을 작성?
select ename, sal from emp order by sal desc;

select ename, sal from emp order by sal desc, ename asc;

-- 정렬 문제
--Q1. 사원 테이블의 자료에서 입사일을 기준으로 오름차순으로 정렬하여 출력하되 사원번호,
--    사원명, 직급, 입사일 컬럼을 출력하는 SQL문 작성?
select empno, ename, job, hiredate from emp order by hiredate asc;

--Q2. 사원 테이블의 자료에서 사원번호를 기준으로 내림차순으로 정렬하여 사원번호와 사원명
--    컬럼을 출력하는 SQL문 작성?
select empno, ename from emp order by empno desc;

--Q3. 부서번호가 빠른 사원부터 출력하되, 동일한 부서내의 사원을 출력하는 경우에는
--    최근에 입사한 사원부터 출력하되 사원번호, 입사일, 사원명, 급여순으로 출력하는
--    SQL문 작성?
select empno, hiredate, ename, sal, deptno from emp 
    order by deptno asc, hiredate desc;




