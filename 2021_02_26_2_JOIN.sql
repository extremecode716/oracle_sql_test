-- 2021.02.26_2 (금)

select * from emp; -- 14 rows
select * from dept;  -- 4 rows
-- 조인(join)
-- : 2개 이상의 테이블을 결합해서 정보를 구해오는 것

--Q. SCOTT 사원이 소속된 부서명을 출력하는 SQL문 작성?
--1. 사원 테이블(EMP)에서 SCOTT 사원의 부서번호를 구한다.
select deptno from emp where ename = 'SCOTT';  --20
--2. 부서 테이블(DEPT)에서 20번 부서의 부서명을 구한다.
select dname from dept where deptno = 20;             -- RESEARCH

-- Cross Join
select * from dept, emp;   -- 4 * 14 = 56 rows (56개 데이터 검색) 
select * from emp, dept;   -- 14 * 4 = 56 rows

-- Cross Join 종류
--1. 등가 조인 (Equi Join)
--2. 비등가 조인 (Non-Equi Join)
--3. 자체 조인 (Self Join)
--4. 외부 조인 (Outer Join)

--1. 등가 조인 (Equi Join)
-- : 두 테이블에 동일한 컬럼을 기준으로 조인
select * from dept, emp where dept.deptno = emp.deptno;  -- 14개의 데이터 검색

--Q. scott 사원이 소속된 부서명을 출력하는 SQL문 작성? (조인 이용)
select ename, dname from dept, emp where dept.deptno = emp.deptno and ename = 'SCOTT';

-- ORA-00918: column ambiguously defined
select deptno, ename, dname from dept, emp where dept.deptno = emp.deptno and ename = 'SCOTT'; -- 오류 발생
select dept.deptno, ename, dname from dept, emp where dept.deptno = emp.deptno and ename = 'SCOTT';
select emp.deptno, ename, dname from dept, emp where dept.deptno = emp.deptno and ename = 'SCOTT';

-- 테이블에 별칭 부여하기
--1. 테이블에 대한 별칭이 부여된 다음 부터는 테이블명은 사용할 수 없고,
--   별칭명만 사용해야 된다.
--2. 별칭명은 대.소문자를 구분하지 않는다.
--3. 공통컬럼 (deptno) 은 별칭명.공통컬럼명 형식으로 사용해야 한다. ex) D.deptno
--4. 공통컬럼이 아닌 컬럼들은 앞에 별칭명을 생략할 수 잇다.

select e.ename, d.dname, e.deptno, d.deptno from emp e, dept d where e.deptno = d.deptno and e.ename = 'SCOTT';

-- 오류 발생(별칭명만 사용가능)
select emp.ename, d.dname, e.deptno, d.deptno from emp e, dept d where e.deptno = d.deptno and e.ename = 'SCOTT';

-- 별칭명은 대.소문자를 구분하지 않는다.
select e.ename, d.dname, e.deptno, d.deptno from emp E, dept D where E.deptno = D.deptno and e.ename = 'SCOTT';

-- 공통컬럼이 아닌 컬럼은 앞에 별칭명을 생략 할 수 있다.
select ename, dname, e.deptno, d.deptno from emp E, dept D where E.deptno = D.deptno and ename = 'SCOTT';

--Q. 조인을 사용하여 뉴욕에 근무하는 사원의 이름과 급여를 출력하는 SQL문 작성?
select dept.deptno, ename, sal from emp, dept where emp.deptno = dept.deptno and loc = 'NEW YORK';

--Q. 조인을 사용하여 SALES부서 소속 사원의 이름과 입사일을 출력하는 SQL문 작성?
SELECT DEPT.DEPTNO, ENAME, HIREDATE FROM DEPT, EMP WHERE DEPT.DEPTNO = EMP.DEPTNO AND DNAME='SALES';



-- 2. 비등가 조인 (Non-Equi Join)
-- : 두개의 테이블에 동일한 컬럼 없이 다른 조건을 사용하여 조인하는 것

--Q. 사원 테이블에 있는 각 사원들의 급여가 몇 등급인지를 출력하는 SQL문 작성?
select * from salgrade;
-- EMP(SAL) - SALGRADE (GRADE)
select ename, sal, grade from emp, salgrade where sal >= losal and sal <= hisal;
select ename, sal, grade from emp, salgrade where sal between losal and hisal;
select e.ename, e.sal, s.grade from emp e, salgrade s where e.sal between s.losal and s.hisal;


--3. 자체조인 (Self Join)
--   : 한 개의 테이블 내에서 컬럼과 컬럼 사이의 관계를 이용해서 조인
--Q. 자체조인 (Self Join) 을 이용하여 사원 테이블의 각 사원들의 사원명과
--   매니저 (=직속상관) 를 출력하는 SQL문 작성?
--   EMP (EMPNO)   -   EMP (MGR)

select employee.ename || '의 매니저는 ' || manager.ename from emp employee, emp manager where employee.mgr = manager.empno;

-- 13개의 검색 결과가 출력된다.
-- KING 사원은 직속상관이 없기 때문에 출력되지 않는다.

--4.외부 조인(Outer Join)
--  : 조인 조건을 만족하지 않는 데이터를 출력 해주는 조인
 -- 1) 테이블을 조인할때 어느 한쪽의 테이블에는 데이터가 존재하지만, 다른 테이블에는
 --    데이터가 존재하지 않는 경우에, 그 데이터가 출력되지 않는 문제를 해결하기 위해서
 --    사용되는 조인 방법
 -- 2) 정보가 부족한 곳에 (+)를 추가한다.
 
--Q1. 위의 자체조인의 결과, KING사원은 직속상관이 없기 때문에 출력이되지 않았는데,
--    KING 사원도 외부조인을 이용해서 출력 하세요?
select employee.ename || '의 매니저는 ' ||  manager.ename 
    from emp employee, emp manager
    where employee.mgr = manager.empno(+);
    
--Q2.부서테이블(DEPT)의 40번 부서는 조인할 사원테이블(EMP)의 부서번호에는
--   나타나지 않지만, 40번 부서의 부서명을 출력하는 SQL문 작성?
--  1) DEPT - EMP 등가 조인 : 40번 부서가 출력안됨
select ename, d.deptno, dname from emp e, dept d
    where e.deptno = d.deptno order by deptno asc;
    
--  2) 외부조인 : 출력되지 않는 40번 부서를 출력해 주는 조인
select ename, d.deptno, dname from emp e, dept d
    where e.deptno(+) = d.deptno order by deptno asc;

select ename, deptno from emp;


select * from emp e1, emp e2;
select * from emp e1, emp e2 where e1.empno = e2.empno;

--과제 Join.
--Q1. 직급이 MANAGER인 사원의 이름, 부서명을 출력하는 SQL문을
--    작성 하세요? (JOIN을 사용하여 처리)
select e.ename, d.dname from emp e, dept d where e.deptno = d.deptno and e.job = 'MANAGER';
--Q2. 매니저가 KING 인 사원들의 이름과 직급을 출력하는 SQL문 작성?
select e1.ename, e1.job from emp e1, (select empno, ename, job from emp where ename='KING') e2 where e2.empno = e1.mgr;
select e1.ename, e1.job from emp e1 where e1.mgr = (select empno from emp where ename='KING');
--Q3. SCOTT과 동일한 근무지에서 근무하는 사원의 이름을 출력하는 SQL문 작성?
select ename from (select ename, d.loc from emp e, dept d where e.deptno = d.deptno) where loc = (select loc from emp e, dept d where e.deptno = d.deptno and e.ename = 'SCOTT');
select ename from emp e, dept d where e.deptno = d.deptno and loc = (select loc from emp e, dept d where e.deptno = d.deptno and e.ename = 'SCOTT');

