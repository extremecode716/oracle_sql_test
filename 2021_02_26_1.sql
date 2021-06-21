-- 2021.02.26 (금)

-- 형변환 함수 : to_char(), to_date(), to_number()

-- 1. to_char() : 날짜형, 숫자형 데이터를 문자형으로 변환시켜주는 함수
--    to_char( 날짜 데이터, '출력형식')

-- 1) 날짜형 데이터를 문자형으로 변환
--Q.현재 시스템의 날짜를 년, 월, 일, 시, 분, 초, 요일을 출력
select sysdate from dual;
    
select sysdate, to_char(sysdate, 'yyyy-mm-dd am hh:mi:ss dy') from dual;
select sysdate, to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss day') from dual;

--Q.사원 테이블에서 각 사원들의 입사일을 년,월,일,시,분,초,요일을 출력하는 SQL문 작성?
select hiredate, to_char(hiredate, 'yyyy-mm-dd hh24:mi:ss day') from emp;

-- 2) 숫자형 데이터를 문자형으로 변환
--   to_char( 숫자 데이터, '구분기호')
--Q. 숫자 1230000을 3자리씩 컴마로 구분해서 출력
select 1230000 from dual;

-- 0으로 자리수를 지정하면, 데이터의 길이가 9자리가 되지 않으면 0으로 채운다.
select 1230000, to_char(1230000, '000,000,000') from dual;-- 001,230,000

-- 9로 자리수를 지정하면, 데이터의 길이가 9자리가 되지 않아도 채우지 않는다.
select 1230000, to_char(1230000, '999,999,999') from dual;-- 1,230,000

--Q.사원테이블에서 각 사원들의 급여를 3자리씩 컴마(,)로 구분해서 출력하는 SQL문 작성?
select ename, sal, to_char(sal, '9,999') from emp;
select ename, sal, to_char(sal, 'L9,999') from emp; --각국의 통화기호 출력

--2.to_date() : 문자를 날짜형으로 변환해주는 함수
--  to_date('문자', 'format')
--Q. 2021년 1월 1일 부터 현재까지 경과된 일수를 구하는 SQL문 작성?
select sysdate - '2021/01/01' from dual;    -- 오류 발생

select sysdate - to_date('2021/01/01','yyyy/mm/dd') from dual;
select round(sysdate - to_date('2021/01/01','yyyy/mm/dd')) from dual;
select trunc(sysdate - to_date('2021/01/01','yyyy/mm/dd')) from dual;

--Q. 2021년 12월 25일 크리스마스까지 남은 일수를 구하는 SQL문 작성?
select '2021/12/25' - sysdate from dual;    -- 오류 발생
select to_date('2021/12/25','yyyy/mm/dd') - sysdate from dual;
select round(to_date('2021/12/25','yyyy/mm/dd') - sysdate) from dual;
select trunc(to_date('2021/12/25','yyyy/mm/dd') - sysdate) from dual;

-- 3. to_number() : 문자형을 숫자형으로 변환해주는 함수
--    to_number( '문자 데이터' , '구분기호')
select '20,000'  - '10,000' from dual;  -- 오류 발생
select to_number('20,000','99,999') - to_number('10,000','99,999') from dual;

-- Q1. 사원테이블(EMP)에서 입사일(HIREDATE)을 4자리 연도로 출력                                
--           되도록 SQL문을 작성하세요? (ex. 1980/01/01)
select  to_char(hiredate,'YYYY/MM/DD') from emp;

---------------------------------------------------------------------
-- nvl() : null값을 다른값으로 변환해주는 함수
--1. null값은 정해지지 않은 값을 의미
--2. null값은 산술연산(+,-,*,/)이 되지 않는다.

--Q. 사원테이블에 있는 각 사원들의 연봉을 계산하는 SQL문 작성?
--   연봉 = 급여(sal) * 12  + comm
--   nvl( comm, 0 ) : comm 이 null값인 데이터를 0으로 변환

select sal, sal*12, comm, sal*12+comm, sal*12+nvl(comm,0) as "연봉" from emp;

--Q2. 사원테이블(EMP)에서 MGR컬럼의  값이  null 인 데이터의 MGR                              
--          컬럼의 값을  CEO 로  출력하는 SQL문을 작성 하세요?
select ename, mgr from emp where mgr is null;   -- MGR컬럼에 NULL값 검색
select ename, nvl(mgr,'CEO') from emp where mgr is null; -- 오류 발생
select ename, nvl(to_char(mgr,'9999'),'CEO') from emp where mgr is null;
select ename, nvl(to_char(mgr,'9999'),'CEO') MANAGER  from emp where mgr is null;

-- decode() : switch ~ case 구문과 유사
-- decode( 컬럼명, 값1, 결과1,
--                값2, 결과2,
--                값3, 결과3,
--                ............)
--Q. 사원테이블에서 부서번호(deptno)를 부서명으로 바꿔서 출력하는 SQL문 작성?
select ename, deptno, decode( deptno, 10, 'ACCOUNTING', 
                                      20, 'RESEARCH',
                                      30, 'SALES',
                                      40, 'OPERATIONS') as dname from emp;


-- case() : if ~ else if 문과 유사
-- case   when  조건1  then  결과1
--        when  조건2  then  결과2
--        else  결과3
-- end
--Q. 사원테이블에서 부서번호(deptno)를 부서명으로 바꿔서 출력하는 SQL문 작성?
select ename, deptno, case  when deptno=10 then 'ACCOUNTING'
                                 when deptno=20 then 'RESEARCH'
                                 when deptno=30 then 'SALES'
                                 when deptno=40 then 'OPERATIONS'
                      end  as dname from emp;
                      
-----------------------------------------------------------------------
-- 그룹함수 : 하나 이상의 데이터를 그룹으로 묶어서 연산을 수행하고
--           하나의 결과로 처리해주는 함수

-- sum() : 합을 구해주는 함수
select sum(sal) from emp;       -- 급여의 합
select sum(comm) from emp;      -- comm의 합, null값은 제외
select sum(ename) from emp;     -- 오류 발생
select sum(hiredate) from emp;  -- 오류 발생

select sum(sal), sum(comm) from emp;    -- 그룹함수끼리 사용 가능함
select sal, sum(sal) from emp;  --그룹함수와 일반 컬럼을 같이 사용할 수 없다.

select sum(sal) from emp where deptno=10;   -- 8750
select sum(sal) from emp where deptno=20;   -- 10875
select sum(sal) from emp where deptno=30;   -- 9400
select sum(sal) from emp where deptno=40;   -- null

-- avg() : 평균값을 구해주는 함수
select deptno, comm from emp;
select avg(sal) from emp;
select avg(sal), avg(comm) from emp;
select avg(sal), avg(comm) from emp where deptno=10;
select avg(sal), avg(comm) from emp where deptno=20;
select avg(sal), avg(comm) from emp where deptno=30;

-- max() : 최대값을 구해주는 함수
select max(sal) from emp;   -- 5000
select ename, max(sal) from emp; -- 오류발생 : 그룹함수와 일반컬럼은 같이 사용할 수 없다.                   
select max(sal) from emp where deptno = 10; 
select max(sal) from emp where deptno = 20; 
select max(sal) from emp where deptno = 30; 

--Q.사원 테이블에서 가장 최근에 입사한 사원의 입사일을 출력하는 SQL문 작성?
select max(hiredate) from emp;  -- 87/07/13
select hiredate from emp order by hiredate desc;

select max(ename) from emp;     -- WARD
select ename from emp order by ename desc;  -- 내림차순 정렬 (사전 역순 정렬)

-- min() : 최소값을 구해주는 함수
select min(sal) from emp;   -- 800
select min(sal) from emp where deptno = 10; -- 1300
select min(sal) from emp where deptno = 20; -- 800
select min(sal) from emp where deptno = 30; -- 950

--Q. 사원테이블에서 가장 먼저 입사한 사원의 입사일을 검색하는 SQL문 작성?
select min(hiredate) from emp;      -- 80/12/17
select hiredate from emp order by hiredate asc;

select min(ename) from emp;         -- ADAMS
select ename from emp order by ename asc;   -- 오름차순 정렬 (사전순 정렬)

select sum(sal), avg(sal), max(sal), min(sal) from emp;
select sum(sal), avg(sal), max(sal), min(sal) from emp where deptno=10;
select sum(sal), avg(sal), max(sal), min(sal) from emp where deptno=20;
select sum(sal), avg(sal), max(sal), min(sal) from emp where deptno=30;

-- count() : 총 데이터 갯수를 구해주는 함수
select count(sal) from emp;  -- 14
select count(mgr) from emp;  -- 13 : null값은 counting을 하지 않는다.
select count(comm) from emp; -- 4 : null값은 counting을 하지 않는다.
select count(empno) from emp;-- 14 : (empno컬럼 : 기본키로 설정된 컬럼)
select count(*) from emp;    -- 14

--Q. 사원 테이블에서 JOB의 갯수 구하기
select count(job) from emp;  -- 14 : 중복 데이터도 counting 된다.
select job from emp;
select distinct job from emp; -- 중복행을 제거한 JOB 출력

-- 중복행을 제거한 job의 갯수 구하기?
select count(distinct job) from emp;    -- 5

--Q.사원 테이블에서 가장 최근에 사원의 입사일과 가장 먼저 입사한 사원의 입사일을 
--  구하는 SQL문 작성?
select max(hiredate) 최근입사, min(hiredate) 먼저입사 from emp;

--Q.10번 부서 소속 사원 중에서 커미션을 받는 사원의 수를 구하는 SQL문 작성?
select count(comm) from emp where deptno=10;


-- group by 절
-- : 특정 컬럼을 기준으로 테이블에 존재하는 데이터를 그룹으로 구분하여 
--   처리해 주는 역할을 한다.

--Q.각 부서(10,20,30)의 급여의 합, 평균급여, 최대급여, 최소급여를 구하는 SQL문 작성?
select sum(sal), avg(sal), max(sal), min(sal) from emp where deptno=10;
select sum(sal), avg(sal), max(sal), min(sal) from emp where deptno=20;
select sum(sal), avg(sal), max(sal), min(sal) from emp where deptno=30;

-- 그룹함수와 일반컬럼은 같이 사용할 수 없지만, 예외적으로 group by절에 사용되는 
-- 컬럼은 그룹함수와 같이 사용할 수 있다.
select deptno, sum(sal), avg(sal), max(sal), min(sal) from emp
       group by deptno order by deptno asc;

select deptno from emp group by deptno;
select job from emp group by job;

--Q.JOB컬럼을 기준으로 급여의 합, 평균급여, 최대급여, 최소급여를 구하는 SQL문 작성?
select job, sum(sal), avg(sal), max(sal), min(sal) from emp
        group by job;
        
--Q.각 부서번호별 사원수와 커미션을 받는 사원의 수를 구하는 SQL문 작성?
select deptno, count(*) 사원수, count(comm) 커미션 from emp
        group by deptno order by deptno asc;
        
-- having 조건절
--Q.각 부서별 평균급여 금액을 구하는 SQL문 작성?
select deptno, avg(sal) from emp group by deptno;

--Q.각 부서별 평균급여 금액이 2000 이상인 부서만 출력하는 SQL문 작성?
select deptno, avg(sal) from emp group by deptno
       where avg(sal) >= 2000;      -- 오류발생

 -- group by 절이 사용되는 경우에 데이터 제한을 가하기 위해서는 where 조건절
 -- 대신에 having 조건절을 사용해야 된다.
select deptno, avg(sal) from emp group by deptno
       having avg(sal) >= 2000;         

