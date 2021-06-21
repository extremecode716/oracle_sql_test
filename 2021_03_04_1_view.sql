-- 2021.03.04(목)

-- 뷰(view) : 기본 테이블을 이용해서 만들어진 가상 테이블
--CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW view_name
--[(alias, alias, alias, ...)]
--AS subquery
--[WITH CHECK OPTION]
--[WITH READ ONLY];

-- 실습을 위한 기본 테이블 생성 : dept_copy, emp_copy

-- 2개의 기본 테이블 생성
create table dept_copy as select * from dept;
create table emp_copy as select * from emp;
select * from dept_copy;
select * from emp_copy;

-- 뷰 생성
create view emp_view30
as
select empno, ename, deptno from emp_copy where deptno = 30;

-- 뷰 생성 확인
select * from tab;
select * from user_views;

select * from emp_view30;
desc emp_view30;

--Q. 뷰(emp_view30)에 insert로 데이터를 입력 했을 경우에 기본 테이블(emp_copy)에도
--   데이터가 입력 될까요?
insert into emp_view30 values(1111,'안화수',30); 

select * from emp_view30;
select * from emp_copy;     -- 기본 테이블에도 데이터가 입력됨.

-- 뷰의 종류
-- 단순뷰 : 하나의 기본 테이블로 생성된 뷰
-- 복합뷰 : 여러개의 기본 테이블로 생성된 뷰

-- 단순뷰
--Q. 기본 테이블인 emp_copy를 이용해서 20번 부서에 소속된 사원들의 사번과 이름,
--   부서번호, 직속상관의 사번을 출력하기 위한 뷰(emp_view20)를 생성하세요?
create view emp_view20
as
select empno, ename, deptno, mgr from emp_copy where deptno=20;

select * from user_views;
select * from emp_view20;

-- 복합뷰
--Q. 각 부서별(부서명) 최대급여와 최소급여를 출력하는 뷰를 sal_view라는 이름으로 생성하세요?
create view sal_view
as
select dname, max(sal) MAX, min(sal) MIN from dept, emp
  where dept.deptno=emp.deptno group by dname;

select * from user_views;
select * from sal_view;

-- 뷰 삭제
drop view 뷰이름;
drop view sal_view;

-----------------------------------------------------------------------
-- 뷰를 생성할때 사용하는 옵션들
--1. or replace 옵션
--   기존에 뷰가 존재하지 않으면 뷰를 생성하고, 동일한 이름을 가진 뷰가 존재하면
--   뷰의 내용을 수정 하도록 해주는 옵션

--  위에서 emp_view30 이라는 뷰를 생성했는데, or replace 옵션을 붙여서 
--  다시  emp_view30  뷰를 생성해보자?
--1) or replace 옵션없이 동일한 뷰(emp_view30) 생성하면 오류 발생
create view emp_view30
as
select empno, ename, deptno from emp_copy where deptno = 30;

--2) or replace 옵션을 붙여서 동일한 뷰(emp_view30) 생성 : 뷰의 내용이 수정됨
create or replace view emp_view30
as
select empno, ename, deptno, sal, comm from emp_copy where deptno = 30;

-- 뷰 확인
select * from user_views;
select * from emp_view30;

--2. with check option
--  : where 조건절에 사용된 값을 수정하지 못하게 만들어 주는 옵션
--1) with check option 사용하지 않은 경우
create or replace view emp_view30
as
select empno, ename, deptno, sal, comm from emp_copy where deptno = 30;

select * from emp_view30;

--emp_view30 뷰에서 급여가 1200 이상인 사원들의 부서번호를 30번에서 20번으로 수정?
update emp_view30  set deptno = 20 where sal >= 1200;

--2) with check option 사용한 경우
create or replace view emp_view_chk30
as
select empno, ename, sal, comm, deptno from emp_copy
    where deptno = 30 with check option;
    
select * from user_views; 
select * from emp_view_chk30;

--emp_view_chk30 뷰에서 급여가 1200 이상인 사원들의 부서번호를 30번에서 20번으로 수정?
update emp_view_chk30 set deptno=20 where sal >= 1200;

--3. with read only 옵션
--   : 뷰를 통해서 기본 테이블의 어떤 컬럼에 대해서도 내용을 수정하지 못하도록
--     만들어주는 옵션
create or replace view view_read30
as
select empno, ename, sal, comm, deptno from emp_copy
    where deptno=30 with read only;

select * from user_views;
select * from view_read30;

--Q. 생성된 뷰 view_read30을 수정 해보자?
update view_read30 set sal = 3000;  
--with read only 옵션 때문에 데이터 수정안됨 (오류 발생)

------------------------------------------------------------------------
-- rownum 컬럼
-- 1. 데이터의 저장 순서를 가지고 있는 논리적인 컬럼이다.
-- 2. nownum 값은 1번 부터 시작한다.
-- 3. rownum 값은 order by절로 정렬 하더라도 변경되지 않는다.
--    rownum 값을 변경하기 위해서는 테이블을 변경 해야된다.

select rownum, deptno, dname, loc from dept;
select rownum, ename, sal from emp;

select rownum, ename, sal from emp order by sal desc;

--Q1. 사원테이블에서 입사일이 빠른 사원 5명을 구해보자?
--1) 입사일이 빠른 사원순으로 정렬 (입사일을 기준으로 오름차순 정렬)
select empno, ename, hiredate from emp order by hiredate asc;

--2) 뷰생성
create or replace view hire_view
as
select empno, ename, hiredate from emp order by hiredate asc;

--3) 입사일이 빠른 사원 5명 출력
select * from hire_view;
select rownum, empno, ename, hiredate from hire_view;

select rownum, empno, ename, hiredate from hire_view where rownum <= 5;

-- 4) 인라인 뷰 (= 서브쿼리로 만들어진 뷰)
-- 입사일이 빠른 사원 5명 검색?
select rownum, ename, hiredate from (
  select rownum, ename, hiredate from emp order by hiredate asc)
  where rownum <= 5;
  
  
--Q2. 사원 테이블에서 급여를 많이 받는 사원 5명 검색?
--1) 급여를 많이 받는 사원순으로 정렬 (급여를 기준으로 내림차순 정렬)
select ename, sal from emp order by sal desc;

--2) 뷰 생성
create or replace view sal_view
as
select ename, sal from emp order by sal desc;

--3) 급여를 많이 받는 사원 5명 출력
select * from sal_view;
select rownum, ename, sal from sal_view;  

select rownum, ename, sal from sal_view where rownum <= 5;

--4) 인라인 뷰(=서브쿼리로 만들어진 뷰)
-- 급여를 많이 받는 사원 5명 출력?
select rownum, ename, sal from (
    select rownum, ename, sal from emp order by sal desc)
where rownum <= 5;

-- 급여를 3 ~ 5번째 많이 받는 사원을 검색?
select rownum, ename, sal from (
    select rownum, ename, sal from emp order by sal desc)
where rownum <= 5 and rownum >=3;  -- 검색 안됨

select ename, sal from (
    select rownum rnum, ename, sal from (   -- rownum 컬럼에 별칭부여
    select * from emp order by sal desc ) )
where rnum >= 3 and rnum <= 5;

--컬럼명을 간결하게 처리
select * from (
    select rownum rnum, mem.* from (
    select * from emp order by sal desc) mem )  -- 서브쿼리에 별칭부여
--where rnum between 3 and 5;    
where rnum >= 3 and rnum <= 5;

--Q3. 사원테이블에서 사원번호(empno)가 빠른 사원 5명을 인라인 뷰로 검색 하세요?
select empno, ename from emp order by empno asc;

-- 사원번호가 빠른 사원 5명 검색?
select rownum, empno, ename from (
    select * from emp order by empno asc)
where rownum <= 5;

-- 사원번호가 3 ~ 5번째 빠른 사원 검색?
select rnum, empno, ename from ( 
    select rownum rnum, empno, ename from (  -- rownum 컬럼에 대한 별칭부여
    select * from emp order by empno asc ) )
where rnum <=5 and rnum >= 3;
    
    

