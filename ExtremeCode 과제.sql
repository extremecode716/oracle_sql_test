-- ExtremeCode 작성한 과제

--과제.
--Q1. 사원테이블(EMP)에서 입사일(HIREDATE)을 4자리 연도로 출력 
--    되도록 SQL문을 작성하세요? (ex. 1980/01/01)
select emp.ename, TO_DATE(hiredate, 'YYYY/MM/DD') as "HIREDATE" from emp;
select  to_char(hiredate,'YYYY/MM/DD') from emp;

--Q2. 사원테이블(EMP)에서 MGR컬럼의  값이  null 인 데이터의 MGR의 
--    값을  CEO 로  출력하는 SQL문을 작성 하세요?
select emp.ename, NVL(TO_CHAR(MGR), 'CEO') as "MGR" from emp;
select ename, nvl(to_char(mgr,'9999'), 'CEO') as MANAGER  from emp where mgr is null;
                    
--Q3. 사원 테이블(EMP)에서 가장 최근에 입사한 사원명을 출력 하는 
--    SQL문을 작성 하세요?
select ename, hiredate from emp where hiredate = (select MAX(hiredate) from emp);
select ename, hiredate from (select ename, hiredate  from emp order by hiredate desc) where rownum <= 1;

--Q4. 사원 테이블(EMP)에서 최대 급여를 받는 사원명과 최대급여
--    금액을 출력하는 SQL문을 작성 하세요?
select ename, sal from (select ename, sal  from emp order by sal desc) where rownum <= 1;
select ename, sal from emp where sal = (select MAX(sal) from emp);


--과제 Join.
--Q1. 직급이 MANAGER인 사원의 이름, 부서명을 출력하는 SQL문을
--    작성 하세요? (JOIN을 사용하여 처리)
select e.ename, d.dname from emp e, dept d where e.deptno = d.deptno and e.job = 'MANAGER';
select ename, dname from emp, dept where emp.deptno=dept.deptno and job='MANAGER';
select ename, dname from emp inner join dept on emp.deptno=dept.deptno where job='MANAGER'; --
select ename, dname from emp inner join dept using(deptno)  where  job='MANAGER'; --
select ename, dname from emp natural join dept where job='MANAGER'; --
--Q2. 매니저가 KING 인 사원들의 이름과 직급을 출력하는 SQL문 작성?
select e1.ename, e1.job from emp e1, (select empno, ename, job from emp where ename='KING') e2 where e2.empno = e1.mgr;
select e1.ename, e1.job from emp e1 where e1.mgr = (select empno from emp where ename='KING');
select employee.ename, employee.job from emp employee, emp manager where employee.mgr=manager.empno and manager.ename='KING'; --
--Q3. SCOTT과 동일한 근무지에서 근무하는 사원의 이름을 출력하는 SQL문 작성?
select ename from (select ename, d.loc from emp e, dept d where e.deptno = d.deptno) where loc = (select loc from emp e, dept d where e.deptno = d.deptno and e.ename = 'SCOTT');
select ename from emp e, dept d where e.deptno = d.deptno and loc = (select loc from emp e, dept d where e.deptno = d.deptno and e.ename = 'SCOTT');
select ename from emp where deptno = (select deptno from emp where ename = 'SCOTT'); --