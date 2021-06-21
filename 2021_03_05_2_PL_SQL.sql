-- 2021.03.05(금)

-- PL/SQL

--Q. Hello World~!!  출력
set serveroutput on
begin
DBMS_OUTPUT.PUT_LINE('Hello World~!!');
end;

-- 변수 사용하기
set serveroutput on
declare                        -- 선언부 시작
    vempno number(4);          -- 변수 선언 : 스칼라 변수
    vename varchar2(10);       -- 변수명은 대.소문자를 구분하지 않는다.
begin                          -- 실행부 시작
    vempno := 7788;            -- vempno 변수에 7788 할당
    vename := 'SCOTT';         -- vename 변수에 SCOTT 을 할당
    DBMS_OUTPUT.PUT_LINE('사번 /  이름');
    DBMS_OUTPUT.PUT_LINE(VEMPNO || '/' || VENAME);
end;                           --  실행부 끝


-- 사번과 이름 검색하기
set serveroutput on
declare
    vempno emp.empno%type;          --  레퍼런스 변수
    vename emp.ename%type;  
begin
    select empno, ename into vempno, vename from emp where ename='SCOTT';    
    DBMS_OUTPUT.PUT_LINE('사번 /  이름');
    DBMS_OUTPUT.PUT_LINE(VEMPNO || '/' || VENAME);
end;


select * from dept01;
select * from emp02;
drop table emp02 purge;
create table emp02 as select * from emp;
select * from emp02;
-- 조건문 (=선택문)
--1. if ~ then ~ end if
--Q. SCOTT 사원의 부서번호를 검색해서 부서명을 출력하는 PL/SQL문 작성?

set SERVEROUTPUT on
declare
    vempno number(4);
    vename varchar2(20);
    vdeptno dept01.deptno%type;
    vdname varchar2(20) := null;
begin
    select empno, ename, deptno into vempno, vename, vdeptno from emp02
        where ename = 'SCOTT';
    
    if vdeptno = 10 then
        vdname := 'ACCOUNTING';
    end if;
    if vdeptno = 20 then
        vdname := 'RESEARCH';
    end if;
    if vdeptno = 30 then
        vdname := 'SALES';
    end if;
    if vdeptno = 40 then
        vdname := 'OPERATIONS';
    end if;    
    DBMS_OUTPUT.PUT_LINE('사번 / 이름 / 부서명');
    DBMS_OUTPUT.PUT_LINE(vempno || '/' || vename || '/' || vdname);
end;


--Q. 사원 테이블에서 SCOTT 사원의 연봉을 구하는 PL/SQL문 작성
set SERVEROUTPUT ON
declare
    vemp emp%rowtype;              -- 레퍼런스 변수
    annsal number(7, 2);           -- 스칼라 변수 
begin
    select * into vemp from emp where ename = 'SCOTT';
    
    if vemp.comm is null then
        vemp.comm := 0;
    end if;
    annsal := vemp.sal * 12 + vemp.comm;
    
    DBMS_OUTPUT.PUT_LINE('사번 / 이름 / 연봉');
    DBMS_OUTPUT.PUT_LINE(vemp.empno || '/' || vemp.ename || '/' || annsal);
end;




