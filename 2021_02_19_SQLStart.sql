SELECT
    *
FROM
    tab;

SELECT
    *
FROM
    dept;
-- 임시 테이블 삭제
--purge recyclebin;

-- 테이블 생성(create) DDL
CREATE TABLE member01 (
    id        VARCHAR2(20),
    name      VARCHAR2(20),
    address   VARCHAR2(50),
    phone     VARCHAR2(20)
);
    
-- 테이블 목록 출력

SELECT
    *
FROM
    tab;

SELECT
    *
FROM
    member01;

-- 데이터 입력(insert) DML

INSERT INTO member01 VALUES (
    'test',
    '홍길동',
    '서울시 마포구',
    '010-1111-2222'
);

INSERT INTO member01 VALUES (
    'test1',
    '홍길동1',
    '서울시 마포구1',
    '010-1111-2223'
);

INSERT INTO member01 VALUES (
    'toto',
    '이순신',
    '서울시 서대문구',
    '010-1111-4444'
);


SELECT
    *
FROM
    member01;
    
-- 테이블 수정(update) DML
-- ID가 test인 계정의 핸드폰 번호를 '010-3333-3333' 으로 수정하세요.
update member01 set phone='010-3333-3333' where id='test';

-- ID가 TOTO인 계정의 ADDRESS를 '인천시 계양구'로 수정 하세요.
update member01 set address='인천시 계양구' where id ='toto';

-- 테이블 삭제(delete) DML
delete from member01 where id = 'test';

-- 테이블 삭제(delete) DML (행번호로 삭제)
delete from member01 where ROWNUM = 1;


-- Oracle

select * from tab;      -- 테이블 목록
select * from customer; -- customer 목록
select * from seq;      -- 시퀀스 목록
delete from customer;   -- 테이블 목록 삭제

-- 테이블 삭제 oracle은 purge를 붙임으로써 임시테이블 교체없이 삭제 가능.
drop table customer purge;

-- 예1.
-- customer 테이블 생성 (DDL) 
-- primary key:제약조건 : not null + unique
create table customer( no number(4)  primary key, 
		       name varchar2(20),
		       email varchar2(20),
		       tel varchar2(20)      
		       );

-- 예2.
alter table customer add(address varchar2(50));
alter table customer add(reg_date timestamp);

-- 시퀀스란 자동으로 순차적으로 증가하는 순번을 반환하는 데이터베이스 객체. 중복값을 방지하기위해 사용.
-- create sequnce [시퀀스명(테이블명_column명_seq)]
-- start with [시작숫자] 
-- increment by [증감숫자] 
create sequence customer_no_seq
	start with 1
	increment by 1;

select customer_no_seq from CUSTOMER; -- 해당 시퀀스 값 조회
drop sequence customer_no_seq;        -- 시퀀스 삭제

-- 게시판 (p2021_02_23)

create table board(
	no number primary key,
	writer varchar2(20) not null,
	passwd varchar2(20) not null,
	subject varchar2(100) not null,
	content varchar2(1000) not null,
	reg_date timestamp
	);

create sequence board_seq
	start with 1
	increment by 1;
	
-- 테이블 목록 select
select * from board;
	
-- 테이블 목록 삭제
delete from board;
	
-- 시퀀스 삭제
drop sequence board_seq;

-- board 목록중 삭제
delete from BOARD where no = 7;
-- 시퀀스의 현재 값을 확인
select LAST_NUMBER from USER_SEQUENCES where SEQUENCE_NAME='BOARD_SEQ';
-- 현재 시퀀스의 INCREMENT를 현재 값 만큼 차감
alter sequence board_seq increment by -6;
-- 시퀀스의 다음 값 실행
select BOARD_SEQ.NEXTVAL FROM BOARD;
-- 시퀀스의 현재 값 조회
select board_seq.currval from BOARD;

select * from all_users;   -- 사용자 조회
select * from all_objects; -- obejct 조회
select * from all_tables;  -- table 조회
select * from all_synonyms;  --synonym 조회
select * from all_ind_columns; -- table index 조회
select * from all_tab_columns; -- table column 조회
select * from all_tab_columns where table_name = 'EMP'; -- table column 조회 EMP
select * from all_tab_comments;  -- table commnet 조회
select * from all_col_comments;  -- column comment 조회
select * from all_tab_columns; -- table column 조회

-- table 정의서 조회 응용 쿼리
SELECT A.COLUMN_ID AS NO
     , B.COMMENTS AS "논리명"
     , A.COLUMN_NAME AS "물리명"
     , A.DATA_TYPE AS "자료 형태"
     , A.DATA_LENGTH AS "길이"
     , DECODE(A.NULLABLE, 'N', 'No', 'Y', 'Yes') AS "Null 허용"
     , '' AS "식별자"
     , A.DATA_DEFAULT AS "기본값"
     , B.COMMENTS AS "코멘트"
FROM  ALL_TAB_COLUMNS A
LEFT JOIN ALL_COL_COMMENTS B
  ON A.OWNER = B.OWNER
 AND A.TABLE_NAME = B.TABLE_NAME
 AND A.COLUMN_NAME = B.COLUMN_NAME 
WHERE A.TABLE_NAME LIKE 'table이름'
ORDER BY A.COLUMN_ID;
			
