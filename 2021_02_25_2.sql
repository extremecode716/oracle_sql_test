--2021.02.25_2 (목)
-- SQL 함수

select 10+20 from dept;     -- 4개 출력
select 10+20 from emp;      -- 14개 출력

select 10+20 from dual;     -- 1개 출력

-- dual 테이블
--1. sys 계정 소유의 테이블로 공개 동의어로 설정 되어 있다.
--2. dual 테이블은 공개가 되어 있기 때문에 누구나 사용 가능하다.
--3. dual 테이블은 데이터가 1개 밖에 없기 때문에, 연산 결과가 1개만 출력한다.

desc dual;                  -- dummy 컬럼 1개 밖에 없음
select * from dual;         -- X 데이터 1개 밖에 없음
select 10+20 from sys.dual;
select 10+20 from dual;   

--1. 숫자 함수
-- abs() : 절대값을 구해주는 함수
select -10, abs(-10), ABS(-10) from dual;

-- floor() : 소숫점 아래를 버리는 역할
select 34.5678, floor(34.5678) from dual;

-- round() : 특정 자리에서 반올림을 하는 역할
-- round(대상값, 자리수)
select 34.5678, round(34.5678) from dual;    -- 35출력 : 소수 첫번째 자리에서 반올림
select 34.5678, round(34.5678, 2) from dual; -- 34.57출력 : 3자리에서 반올림
select 34.5678, round(34.5678, -1) from dual;-- 30출력
select 34.5678, round(35.5678, -1) from dual;-- 40출력

-- trunc() : 특정 자리에서 잘라내는 역할
select trunc(34.5678), trunc(34.5678, 2), trunc(34.5678, -1) from dual;
--         34              34.56                 30

-- mod() : 나머지를 구해주는 함수
select mod(27, 2), mod(27, 5), mod(27, 7) from dual;

--Q. 사원테이블에서 사원번호가 홀수인 사원들을 검색하는 SQL문 작성?
select * from emp where mod(empno, 2) = 1;

------------------------------------------------------------------------
--2. 문자 처리 함수

-- upper() : 대문자로 변환해 주는 함수
select 'Welcome to Oracle', upper('Welcome to Oracle') from dual;

-- lower() : 소문자로 변환해 주는 함수
select 'Welcome to Oracle', lower('Welcome to Oracle') from dual;

-- initcap() : 이니셜을 대문자로 변환해주는 함수
select 'Welcome to Oracle', initcap('welcome to oracle') from dual;

--Q.사원 테이블에서 job이 manager인 사원을 검색하는 SQL문 작성?
select empno, ename, job from emp where job = 'manager';        -- 검색 안됨
select empno, ename, job from emp where lower(job) = 'manager';
select empno, ename, job from emp where job = upper('manager');

-- length() : 문자의 길이를 구해주는 함수(글자수)
select length('Oracle'), length('오라클') from dual;

-- lengthb() : 문자의 길이를 바이트로 구해주는 함수
-- 영문 1글자 : 1Byte, 한글 1글자 : 3Byte
select lengthb('Oracle'), lengthb('오라클') from dual;

-- substr() : 문자열의 일부를 추출하는 함수
-- 형식 : substr(대상 문자열,  시작위치, 추출할 문자 갯수)
-- 시작 위치 번호는 왼쪽부터 1번부터 시작한다.
-- 시작 위치 번호가 음수인 경우에는 끝문자 부터 시작한다.
select substr('Welcome to Oracle', 4, 3) from dual;     -- com 출력
select substr('Welcome to Oracle', -4, 3) from dual;    -- acl 출력
select substr('안녕하세요.',1,3) from dual;

--Q. 사원테이블에서 입사일을 년, 월, 일을 추출해서 출력하는 SQL문 작성?
select substr(hiredate,1,2) as "년",
       substr(hiredate,4,2) as "월",
       substr(hiredate,7,2) as "일"  from emp;

--Q. 사원테이블에서 9월달에 입사한 사원을 검색하는 SQL문 작성?
select * from emp where substr(hiredate,4,2) = '09';

--Q. 사원테이블에서 87년도에 입사한 사원을 검색하는 SQL문 작성?
select * from emp where substr(hiredate,1,2) = '87';

--Q. 사원테이블에서 사원명이 E로 끝나는 사원을 검색하는 SQL문 작성? (2가지 방법)
select * from emp where ename like '%E';
select * from emp where substr(ename, -1, 1) = 'E';

-- lpad() / rpad() : 특정 기호로 채워주는 함수 ※한글 2개씩 인식.
select lpad('Oracle',20,'#') from dual;  -- ##############Oracle
select rpad('Oracle',20,'#') from dual;  -- Oracle##############

-- ltrim() : 왼쪽 공백을 삭제하는 함수
-- rtrim() : 오른쪽 공백을 삭제하는 함수
select  '   Oracle  ',  ltrim('   Oracle  ') from dual;
select  '   Oracle  ',  rtrim('   Oracle  ') from dual;

-- trim() : 문자열 좌.우의 공백을 삭제하는 함수
--          특정 문자를 잘라내는 함수
select trim('   Oracle  ') from dual;
select trim('a' from 'aaaaOracleaaaa') from dual;

--------------------------------------------------------------------
-- 3. 날짜 함수
-- sysdate : 시스템의 날짜를 구해주는 함수

select sysdate from dual;       -- 21/02/25

select sysdate-1 어제, sysdate 오늘, sysdate+1  내일 from dual;

--Q. 사원테이블에서 각 사원들이 현재까지 근무일수를 구하는 SQL문 작성?
select sysdate - hiredate from emp;
select round(sysdate - hiredate) from emp;  -- 소수 1째자리에서 반올림
select trunc(sysdate - hiredate) from emp;  -- 소수점 자리를 버림

-- months_between() : 두 날짜 사이의 경과된 개월 수를 구해주는 함수
-- months_between(date1, date2)
--Q.사원테이블에서 각 사원들의 근무한 개월 수를 구하는 SQL문 작성?
select ename, sysdate, hiredate, months_between(sysdate, hiredate) from emp;

-- add_months() : 특정 날짜에 경과된 개월의 날짜를 구해주는 함수
-- add_months( date, 개월수)
--Q. 오늘 날짜에 6개월 경과된 일자를 구하는 SQL문 작성?
select sysdate, add_months(sysdate, 6) from dual;

-- next_day() : 해당 요일의 가장 가까운 날짜를 구해주는 함수
-- next_day( date, 요일 )
--Q.오늘을 기준으로 가까운 다음 목요일이 언제인지 구하는 SQL문 작성?
select sysdate, next_day(sysdate, '목요일') from dual;
select sysdate, next_day(sysdate, 'MONDAY') from dual; --영문OS

-- last_day() : 해당 달의 마지막 날짜를 구해주는 함수
--Q.이번달의 가장 마지막 날짜를 구하는 SQL문 작성?
select sysdate, last_day(sysdate) from dual;
select last_day('21/01/01') from dual;

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



