--2021.03.02_1 (화)
select * from emp;
select * from dept;

-- ANSI JOIN
-- : ANSI ( 미국 표준 협회) 표준안에 따라서 만들어진 JOIN 방법

-- ANSI CROSS JOIN
select * from dept cross join emp; -- 4 * 14 = 56 개의 데이터 검색
select * from demp cross join dept; -- 14 * 4 = 56개 데이터 검색


--ANSI INNER JOIN
--Q. SCOTT 사원이 소속된 부서명을 출력하는 SQL문 작성?
select * from dept inner join emp on dept.deptno = emp.deptno;
select * from dept inner join emp on dept.deptno = emp.deptno where ename = 'SCOTT';

-- USING을 이용해서 조인
select ename, dname from dept inner join emp using(deptno) where ename = 'SCOTT';

-- ANSI NATURAL JOIN
-- : dept와 emp 테이블 사이의 공통컬럼이 같다는 의미를 가지고 있음.
select ename, dname from dept natural join emp where ename = 'SCOTT';


-- outer join test용 테이블 생성
select * from tab;
drop table dept01 purge; -- 임시 테이블로 교체하지 않고 깨끗하게 테이블 삭제
purge recyclebin; -- 임시 테이블 삭제
create table dept01( -- 1. dept01 테이블 생성
    deptno number(2),
    dname varchar2(14)
);
select * from dept01;
delete from dept01 where deptno = 10;
insert into dept01 values(10, 'ACCOUNTING');  -- 데이터를 추가
insert into dept01 values(20, 'RESEARCH');
select * from dept02;
create table dept02(deptno number(2), dname varchar2(14));  -- 2. dept02 테이블 생성
insert into dept02 values(10, 'ACCOUNTING');
insert into dept02 values(30, 'SALES');

--ANSI OUTER JOIN
-- select * from table1 [left | right | full] outer join table2

-- left outer join
-- dept01 테이블의 정보만 출력됨
select * from dept01 left outer join dept02 using(deptno);

-- right outer join
-- dept02 테이블의 정보만 출력됨
select * from dept01 right outer join dept02 using(deptno);

-- full outer join
-- dept01, dept02 테이블의 정보 모든 정보가 출력됨
select * from dept01 full outer join dept02 using(deptno);

select * from dept01, dept02 where dept01.deptno(+) = dept02.deptno;


-----------------------------------------------------------------------------------
-- 서브쿼리
--Q. SCOTT 사원이 소속된 부서명을 구하는 SQL문 작성?

-- JOIN 으로 구하기
select dname from dept, emp where dept.deptno = emp.deptno and ename = 'SCOTT';
select dname from dept inner join emp on dept.deptno = emp.deptno where ename='SCOTT';
select dname from dept inner join emp using(deptno) where ename='SCOTT';
select dname from dept natural join emp where ename='SCOTT';

--서브쿼리로 구하기
select dname from dept where deptno = (select deptno from emp where ename = 'SCOTT'); -- 서브쿼리
    
-- 1. 단일행 서브쿼리
-- 1) 서브쿼리의 검색 결과가 1개만 반환되는 쿼리
-- 2) 메인 쿼리의 where 조건절에서 비교 연산자만 사용 가능 (=, >, >= , <, <=, !=)

-- Q1. 사원테이블에서 가장 최근에 입사한 사원명을 출력하는 SQL문 작성?
select ename from emp where hiredate = (select max(hiredate) from emp);

-- Q2. 사원 테이블에서 최대 급여를 받는 사원명과 최대급여 금액을 출력하는 SQL문 작성?
select ename, MAX(sal) from emp; -- 오류 발생: 그룹함수와 일반컬럼은 같이 사용할 수 없다.
select ename, sal from emp where sal = (select MAX(sal) from emp);

-- Q3. SCOTT의 급여(SAL) 와 동일하거나 SCOTT보다 더 많은 급여를 받는 사원명과 급여를 출력하는 SQL문 작성?
select ename, sal from emp where sal >= (select sal from emp where ename = 'SCOTT'); 

-- Q4. 직속상관(MGR) 이 KING인 사원의 사원명과 급여를 출력하는 SQL문 작성?
select ename, sal from emp where mgr = 
    (select empno from emp where ename = 'KING');

----------------------------------------------------------------------------------------------------------------
-- 2. 다중행 서브쿼리
-- 1) 서브 쿼리에서 반환되는 검색 결과가 2개 이상인 서브쿼리
-- 2) 메인 쿼리의 where 조건절에서 다중행 연산자(in, all, any, ...)를 사용해야 된다.

-- in 연산자
-- : 서브쿼리의 검색 결과 중에서 하나라도 일치되면 참이 된다.

--Q. 급여를 3000이상 받는 사원이 소속된 부서와 동일한 부서에서 근무하는 사원들의
--   정보를 출력하는 SQL 작성?

-- 각 부서별 최대급여 금액 구하기
select deptno, max(sal) from emp group by deptno; -- 10, 20번 부서

select ename, sal, deptno from emp where deptno in
    (select distinct deptno from emp where sal >= 3000); -- 10, 20

select e1.ename, e1.sal, e1.deptno from emp e1, (select distinct deptno from emp where sal >= 3000) e2 where e1.deptno = e2.deptno;


-- all 연산자
-- : 메인 쿼리의 비교 조건이 서브쿼리의 검색 결과와 모든 값이 일치하면 참이 된다.
--Q. 30번 부서에 소속된 사원 중에서 급여를 가장 많이 받는 사원보다 더 많은 급여를 받는 사원의 이름과 급여를 출력하는 SQL문 작성?

-- 30번 부서 소속 사원 중에서 최대 급여 금액 구하기
select max(sal) from emp where deptno = 30;

-- 1) 단일행 서브쿼리로 구하기
select ename, sal from emp where sal > (select max(sal) from emp where deptno = 30);
-- 2) 다중행 서브쿼리로 구하기
select ename, sal from emp where sal > all(select sal from emp where deptno = 30);

-- any 연산자
-- : 메인 쿼리의 비교 조건이 서브쿼리의 검색 결과와 하나 이상 일치되면 참이 된다.
--Q. 부서번호가 30번인 사원들의 급여중 가장 낮은 급여(950)보다 더 많은 급여를 받는 사원명과 급여를 출력하는 SQL문 작성?

-- 30번 부서의 가장 낮은 급여 구하기
select min(sal) from emp where deptno=30; --950

--1) 단일행 서브쿼리로 구하기
select ename, sal from emp where sal > (select min(sal) from emp where deptno = 30);
--2) 다중행 서브쿼리로 구하기
select ename, sal from emp where sal > any(select sal from emp where deptno = 30); -- 다중행 서브쿼리
