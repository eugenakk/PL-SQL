
/* ******************************************************************
테이블 스페이스 조회

- 모든 테이블스페이스 확인
시스템 계정에서  dba_data_files 또는 dba_tablespaces 뷰를 이용해 조회
- 현재 접속한 계정의 default tablespace 확인
	- user_users 뷰의 default_tablespace 컬럼을 이용해 조회
******************************************************************* */
--현재 사용자의 default 테이블 스페이스를 조회
select * from user_users;
--현재 사용자 소유의 테이블 정보 조회.
select * from tabs;
--system 계정으로 접속해야 조회가능,
select * from dba_data_files;

select * from dba_tablespaces;
/* ***********************************************
테이블 스페이스 생성

create tablespace 테이블스페이스 이름
datafile '테이블스페이스가 사용할 data파일의 경로'
size 파일크기  --k|m  키로바이트, 메가바이트
[autoextend on next 확장될 크기] --G: 생략시 증가 안함
[maxsize 최대파일크기] --생략시 최대사이즈 지정안함
[
default storage(
  initial 10K --테이블스페이스의 첫번째 extends 크기
  next  10K -- 다음 extends의 크기
  minextents 2 --생성할 extent 의 최소값
  maxextendts 50 -- 생성할 extent의 최대개수
  pctincrease 50 -- extents 증가율
)
]
*********************************************** */
--system 계정

create tablespace my_tbs
datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs.dbf' size 10m ; --이 테이블 스페이스가 사용할 파일을 생성한다**

--scott_join
create table test_tbs (
    txt varchar2(1000)
)tablespace my_tbs;

select * from tabs
where table_name='TEST_TBS';

begin
    for i in 1..50000
    loop 
        insert into test_tbs values ('oajsldmosdjgnjksnfdlaijkfdlaijksngiljsknfjjsenfd;jgsoejdf;odnjzf');
    end loop;
    commit;
end;
/

commit;

select * from test_tbs;
--system계정
--테이블 스페이스 공간이 부족하면.. 해결책!
    --1. 데이터 파일 추가 (공간 늘리기)
    alter tablespace my_tbs add datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs2.dbf'
    size 10m;
    select * from dba_data_files;
    
    --2: 기존의 datafile의 크기가 자동으로 늘어나도록 설정.
    alter database datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs.dbf'
    autoextend on next 10m; --10m씩 자동증가하도록!~
    
    --3: datafile의 크기를 늘린다. 
    alter database datafile 'C:\oraclexe\app\oracle\oradata\XE\my_tbs.dbf'
    resize 20m; --20mega 로 늘리기.

/* *********************************
테이블 스페이스 삭제
drop tablesapce 테이블스페이스이름 [옵션]
- 옵션
	- including contents [and datafiles] : 데이터가 이미 들어 있는 경우 내용을 포함해 모두 삭제. 테이터가 있는 경우 이 옵션을 반드시 줘야 한다. 
										   and datafiles를 추가하면 테이블스페이스가 사용하는 데이터파일도 같이 디스크에서 삭제한다.
	- cascade constraints: 테이블스페이스내의 테이블의 primary key를 참조하는 foreign key 설정을 모두 삭제하고 테이블스페이스를 삭제한다.
********************************* */
--아무것도 없을 때만  drop을 할 수 있다 (데이터 포함되어 있으면 X)
--아니면. including contents 라 설정해줌.

drop tablespace my_tbs including contents and datafiles cascade constraints;
select * from dba_data_files;       

select * from dba_tablespaces;



