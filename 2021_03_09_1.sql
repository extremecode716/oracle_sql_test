-- 2021.03.09(화)

-- 패키지(package) = 저장 함수 + 저장 프로시저

--1. 패키지 헤드
create or replace package exam_pack
is
    function cal_bonus(vempno in emp.empno%type)    -- 저장 함수
        return number;
    procedure cursor_sample02;                      -- 저장 프로시저
end;


--2. 패키지 바디 생성
create or replace package body exam_pack
is

-- 저장 함수 : cal_bonus()
function cal_bonus(vempno in emp.empno%type)
    return number
is
    vsal number(7,2);
begin
    select sal into vsal from emp where empno = vempno;
    return vsal * 2;
end;

-- 저장 프로시저 : cursor_sample02
procedure cursor_sample02
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

end;

--3. 저장 프로시저 실행 : cursor_sample02
set SERVEROUTPUT ON
execute exam_pack.cursor_sample02;

--4. 저장 함수 실행 :  cal_bonus()
-- 바인드 변수
variable var_res number;

execute :var_res := exam_pack.cal_bonus(7788);
print var_res;

select ename, exam_pack.cal_bonus(7788) from emp where empno=7788;

--------------------------------------------------------------------------
-- 트리거(trigger)

--Q1. 사원테이블에 사원이 등록되면, '신입사원이 입사했습니다.'를 출력하는 
--    트리거를 생성 하세요?
--1. 사원 테이블 생성 : emp01
select * from tab;
drop table emp01 purge;
create table emp01(
    empno number(4) primary key,       -- 기본키(부모키)
    ename varchar2(20),
    job varchar2(20));
    
--2. 트리거 생성
set SERVEROUTPUT ON
create or replace trigger trg_01
    after insert on emp01           -- 이벤트 발생
begin
    DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다.');
end;

--3. 트리거 목록 확인
select * from user_triggers;

--4. 이벤트 발생 : emp01 테이블에 데이터 입력
set SERVEROUTPUT ON
select * from emp01;
insert into emp01 values(1111, '안화수', 'MANAGER');
insert into emp01 values(1112, '안화수', 'MANAGER');
insert into emp01 values(1113, '안화수', 'MANAGER');
insert into emp01 values(1114, '안화수', 'MANAGER');
insert into emp01 values(1115, '안화수', 'MANAGER');

------------------------------------------------------------------------
--Q2. 사원테이블(EMP01)에 신입사원을 등록하면, 급여 테이블(SAL01)에 급여정보를
--    자동으로 추가해주는 트리거를 생성하세요?
--1. 사원테이블 생성 : emp01
delete from emp01;
commit;
select * from emp01;

--2. 급여 테이블 생성 : sal01
drop table sal purge;
create table sal01(
    salno number(4) primary key,                -- 기본키
    sal number(7,2),
    empno number(4) references emp01(empno) );  -- 외래키(foreign key)

select * from tab;

--3. 시퀀스 생성
create sequence sal01_salno_seq;
select * from seq;

--4.트리거 생성
create or replace trigger trg_02
    after insert on emp01           -- 이벤트 발생
    for each row                    -- 행레벨 트리거
begin
    insert into sal01 values(sal01_salno_seq.nextval,100, :new.empno);
end;

--5.트리거 목록 확인
select * from user_triggers;

--6. 이벤트 발생 : 회원가입
insert into emp01 values(10, '안화수', '프로그래머');  
insert into emp01 values(20, '홍길동', '관리자'); 
insert into emp01 values(30, '이순신', 'ANALYST'); 

--7. 데이터 확인
select * from emp01;
select * from sal01;

----------------------------------------------------------------------
--Q3.회원 정보가 삭제되면, 급여 정보를 자동으로 삭제하는 트리거 생성
--  사원 테이블(EMP01)    -  급여 테이블(SQL01)
delete from emp01 where empno = 10;     -- 삭제 안됨

--1.트리거 생성
create or replace trigger trg_03
    after delete on emp01           -- 이벤트 발생
    for each row
begin
    delete from sal01 where empno = :old.empno;
end;

--2. 트리거 목록 확인
select * from user_triggers;

--3. 이벤트 발생 : 회원탈퇴(emp01 테이블의 데이터 삭제)
--   : 사원테이블(emp01)의 사원번호 10번 사원을 삭제(탈퇴)하면, 연쇄적으로
--     급여테이블(sal01)의 급여 정보도 같이 삭제된다.
delete from emp01 where empno = 10;
delete from emp01 where empno = 20;
delete from emp01 where empno = 30;

--4. 결과 확인
select * from emp01;
select * from sal01;

--5. 트리거 삭제
drop trigger trg_01;
