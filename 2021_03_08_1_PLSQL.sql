-- 2021.03.08(월)

-- 조건문 (=선택문)
--2. if ~ then ~ else ~ end if
--Q. 사원 테이블에서 SCOTT사원의 연봉을 구하는 PL/SQL문 작성?
set SERVEROUTPUT ON
declare
    vemp emp%rowtype;       -- 레퍼런스 변수
    annsal number(7,2);     -- 스칼라 변수
begin
    select * into vemp from emp where ename='SCOTT';
    
    if vemp.comm is null then
        annsal := vemp.sal * 12;
    else
        annsal := vemp.sal * 12 + vemp.comm;
    end if;
    
    DBMS_OUTPUT.PUT_LINE('사번 / 이름 / 연봉');
    DBMS_OUTPUT.PUT_LINE(vemp.empno || '/' || vemp.ename || '/' || annsal);
end;

--3. if ~ then ~ elsif ~ else ~ end if
--Q. SCOTT 사원이 소속된 부서명을 구한  PL/SQL문 작성?
set SERVEROUTPUT ON
declare
    vemp emp%rowtype;
    vdname varchar2(14);
begin
    select * into vemp from emp where ename = 'SCOTT';
    
    if vemp.deptno = 10 then
        vdname := 'ACCOUNTING';
    elsif vemp.deptno = 20 then
        vdname := 'RESEARCH';
    elsif vemp.deptno = 30 then
        vdname := 'SALES';
    elsif vemp.deptno = 40 then
        vdname := 'OPERATIONS';
    end if;
    
    DBMS_OUTPUT.PUT_LINE('사번 / 이름 / 부서명');
    DBMS_OUTPUT.PUT_LINE(vemp.empno || '/' || vemp.ename || '/' || vdname);
end;

--------------------------------------------------------------------------
-- 반복문
--1. Basic Loop 문
-- loop
--    반복 실행될 문장;
-- end loop;

--Q1. 1 ~ 5까지 출력
set SERVEROUTPUT ON
declare
    n number := 1;      -- 변수의 초기값 1
begin
    loop
        DBMS_OUTPUT.PUT_LINE(n);
        n := n + 1;
        if n > 5 then
            exit;
        end if;        
    end loop;
end;

--Q2. 1부터 10까지 합을 구하는 프로그램 작성?
SET SERVEROUTPUT ON
declare
    n number := 1;      -- 루프를 돌릴 변수
    s number := 0;      -- 합이 누적될 변수
begin
    loop
        s := s + n;
        n := n + 1;
        if n > 10 then
            exit;
        end if;
    end loop;
    DBMS_OUTPUT.put_line('1~10까지의 합:' || s);
end;

--2. For Loop 문
--Q1. For Loop문으로 1부터 5까지 출력
set SERVEROUTPUT ON
begin
    for n in 1..5 loop              -- 자동으로 1씩 증가
        DBMS_OUTPUT.PUT_LINE(n);
    end loop;
end;

--Q2. For Loop문으로 5부터 1까지 출력
set SERVEROUTPUT ON
begin
    for n in reverse 1..5 loop      -- 자동으로 1씩 감소
        DBMS_OUTPUT.PUT_LINE(n);
    end loop;
end;

--Q3. For Loop문을 이용해서 부서 테이블(DEPT)의 모든 정보를 출력하는 PL/SQL문 작성?
SET SERVEROUTPUT ON
declare
    vdept dept%rowtype;
begin
    DBMS_OUTPUT.PUT_LINE('부서번호 / 부서명 / 지역명');
    for cnt in 1..4 loop
        select * into vdept from dept where deptno = 10 * cnt;

        DBMS_OUTPUT.put_line(vdept.deptno||'/'||vdept.dname||'/'||vdept.loc);
    end loop;
end;

--3. while loop문
--Q1. while loop문으로 1부터 5까지 출력하는 PL/SQL문 작성?
set SERVEROUTPUT ON
declare
    n number := 1;
begin
    while n <= 5 loop
        DBMS_OUTPUT.PUT_LINE(n);
        n := n + 1;
    end loop;
end;

----------------------------------------------------------------------------
-- 저장 프로시저

--[실습]
drop table emp01 purge;
create table emp01 as select * from emp;
select * from emp01;

--1.저장 프로시저 생성
create or replace procedure del_all
is
begin
    delete from emp01;
end;

--2. 프로시저 목록 확인
select * from user_source;

--3. 프로시저 실행
execute del_all;

--4. 프로시저 실행 확인
select * from emp01;    -- 프로시저에 의해서 데이터가 모두 삭제됨.

rollback;

-------------------------------------------------------------------------
-- 매개변수가 있는 프로시저
--1. 매개변수가 있는 프로시저 생성
create or replace procedure del_ename(vename in emp01.ename%type)
is
begin
    delete from emp01 where ename = vename;
end;

--2. 프로시저 목록 확인
select * from user_source;

--3. 프로시저 실행
select * from emp01;
execute del_ename('SCOTT');
execute del_ename('KING');
execute del_ename('SMITH');

---------------------------------------------------------------------------
-- 매개변수의  MODE가  in, out 인 저장프로시저
--1.매개변수의  MODE가  in, out 인 저장프로시저 생성
-- in : 매개변수로 값을 받는 역할
-- out : 매개변수로 값을 돌려주는 역할

-- Q.사원번호를 프로시저의 매개변수로 전달 받아서, 그 사원의 사원명, 급여, 직책을 
--   구하는 프로시저 생성?
create or replace procedure sal_empno(
    vempno in emp.empno%type,
    vename out emp.ename%type,
    vsal out emp.sal%type,
    vjob out emp.job%type)
is
begin
    select ename, sal, job into vename, vsal, vjob from emp
        where empno = vempno;
end;
 
--2. 프로시저 목록 확인
select * from user_source;

--3. 바인드 변수 : 프로시저를 실행했을때 결과를 돌려받는 변수
variable var_ename varchar2(12);
variable var_sal number;
variable var_job varchar2(10);

--4. 프로시저 실행
execute sal_empno(7788, :var_ename, :var_sal, :var_job); 

print var_ename;
print var_sal;
print var_job;

----------------------------------------------------------------------------
--Q. 사원 테이블에서 사원명을 검색하여 사원의 직급을 구해오는 저장 프로시저 생성하세요?
--1.저장 프로시저 생성
create or replace procedure ename_job(
        vename in emp.ename%type,
        vjob out emp.job%type)
is
begin
    select job into vjob from emp where ename = vename;
end;

--2.프로시저 목록 확인
select * from user_source;

--3. 바인드 변수 실행
variable var_job varchar2(10);

--4. 프로시저 실행
execute ename_job('SCOTT', :var_job);
execute ename_job('KING', :var_job);
execute ename_job('SMITH', :var_job);

--5. 바인드 변수로 받은 값 출력
print var_job;

--------------------------------------------------------
-- 자바 프로그램으로 프로시저 실행
create or replace procedure sel_customer
( vname in customer.name%TYPE,
  vemail out customer.email%TYPE,
  vtel out customer.tel%TYPE)

is
begin
	select email, tel into vemail, vtel from customer
	where name = vname;
end;

-- 바인드 변수 생성 (자바에서는 선언 하지 않아도 사용할 수 있다 cs.registerOutParameter(2, java.sql.Types.VARCHAR);)
variable var_email varchar2(20);
variable var_tel varchar2(20);

-- 프로시저 실행
execute sel_customer('이순신', :var_email, :var_tel);

print var_email;
print var_tel;


------------------------------------------------------------------------------
-- 저장 함수
--: 저장 프로시저와 유사한 기능을 수행하지만, 실행 결과를 돌려주는 역할을 한다.

--Q1.사원 테이블에서 특정 사원의 급여를 200% 인상한 결과를 돌려주는 저장 함수 생성
--1. 저장 함수 생성
create or replace function cal_bonus(vempno in emp.empno%type)
    return number
is
    vsal number(7,2);
begin
    select sal into vsal from emp where empno = vempno;
    return vsal * 2;
end;

--2. 저장 함수 목록 확인
select * from user_source;

--3. 바인드 변수 선언
variable var_res number;

--4. 저장 함수 실행
execute :var_res := cal_bonus(7788);
execute :var_res := cal_bonus(7900);
print var_res;

-- 저장 함수를 SQL문에 포함해서 실행
select sal, cal_bonus(7788) from emp where empno = 7788;
select sal, cal_bonus(7900) from emp where empno = 7900;

--Q2. 사원명으로 검색하여 해당 사원의 직급을 구해오는 저장 함수 생성
--1. 저장 함수 생성
create or replace function job_emp(vename in emp.ename%type)
    return varchar2
is
    vjob emp.job%type;      -- 로컬변수
begin
    select job into vjob from emp where ename = vename; 
    return vjob;
end;

--2. 저장 함수 목록 확인
select * from user_source;

--3. 바인드 변수
variable var_job varchar2(10);

--4. 저장 함수 실행
execute :var_job := job_emp('SCOTT');
print var_job;

----------------------------------------------------------------------------
-- 커서(cursor)
-- : 2개 이상의 데이터를 처리할 때 커서를 사용함.

--Q1.부서 테이블의 모든 데이터를 출력하기 위한 PL/SQL문 작성
--1.저장 프로시저 생성
create or replace procedure cursor_sample01
is
     vdept dept%rowtype;
     
     cursor c1      -- 커서 선언
     is
     select * from dept;
begin
    open c1;
        loop
            fetch c1 into vdept.deptno, vdept.dname, vdet.loc;
            exit when c1%notfound;
        end loop;
    close c1;
end;

--2. 프로시저 목록 확인
select * from user_source;

--3. 프로시저 실행
execute cursor_sample01;

--Q2. 부서 테이블의 모든 내용을 출력하기 : For Loop문으로 처리
--1. open ~ fetch ~ close 없이 사용 가능
--2. for loop 문을 사용하게 되면 각 반복문 마다, cursor를 열고, 각 행을 인출(fetch),
--   close로 커서를 닫는 작업을 자동으로 처리해준다.

--1.저장 프로시저 생성
create or replace procedure cursor_sample02
is
     vdept dept%rowtype;
     
     cursor c1               -- 커서 선언
     is
     select * from dept;
begin
    DBMS_OUTPUT.PUT_LINE('부서번호 / 부서명 / 지역명');
    DBMS_OUTPUT.PUT_LINE('----------------------------');
       
    for vdept in c1 loop       
        exit when c1%notfound;
        DBMS_OUTPUT.put_line(vdept.deptno||'/'||vdept.dname||'/'||vdept.loc);
    end loop;   
end;

--2. 프로시저 목록
select * from user_source;

--Q3. 부서번호를 전달하여 해당 부서에 소속된 사원의 정보를 출력하는 프로시저를
--    커서를 이용해서 처리하세요?
--1. 저장 프로시저 생성
create or replace procedure info_emp(vdeptno in emp.deptno%type)
is
    vemp emp%rowtype;
    
    cursor c1               -- 커서 선언
    is
    select * from emp where deptno = vdeptno;
begin
    DBMS_OUTPUT.PUT_LINE('부서번호 / 사원번호 / 사원명 / 직급 / 급여');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    for vemp in c1 loop
        exit when c1%notfound;
        DBMS_OUTPUT.PUT_LINE(vemp.deptno||'/'||vemp.empno||'/'||vemp.ename||'/'||vemp.job||'/'||vemp.sal);
    end loop;
end;

--2. 프로시저 목록 확인
select * from user_source;

--3. 프로시저 실행
execute info_emp(10);
execute info_emp(20);
execute info_emp(30);
execute info_emp(40);








