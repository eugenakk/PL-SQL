/* ***************************************************************************************************************
Ʈ����(Trigger)

- �����ͺ����� ������Ʈ�� �̺�Ʈ�� �߻��ϸ� �ڵ����� ����Ǵ� ���ν���

	- �̺�Ʈ: Ʈ���Ÿ� �۵��� ��Ȳ.
		- DML �� : insert, update, delete
		- DDL �� : create, alter, drop
		- �����ͺ��̽� ��ü �̺�Ʈ : ��������, �α���, �����ͺ��̽� ����, ����
        
	- Ʈ���� Ÿ�̹�: Ʈ���� ���� ����.
		- BEFORE : �̺�Ʈ �߻� ��
		- AFTER : �̺�Ʈ �߻� ��
        
	- Ʈ���� ����
		- �� Ʈ���� 
			- DML�� ������ �޴� ��� ������� Ʈ���� ����.
			- ���� ���ڵ带 ������ �� �ִ�.
			- FOR EACH ROW �ɼ�
            
		- ��ɹ� Ʈ����
			- DML �� ������ Ʈ���� ����
			- �� �������� ��� ���� ���ŵǾ Ʈ���Ŵ� �ѹ��� ȣ�� �ȴ�.

- ����
	CREATE [ OR REPLACE] TRIGGER Ʈ�����̸�
 	  Ÿ�̹�
	  �̺�Ʈ [ OR �̺�Ʈ2 OR �̺�Ʈ3 ..]
	  ON ���̺��̸�
	  [FOR EACH ROW] 
	
	[DECLARE
		�����]
	BEGIN
		�����]
	[EXCEPTION
		����ó��]
	END;

	- Ÿ�̹� : BEFORE, AFTER
		-  BEFORE���� ���ܰ� �߻��ϸ� event ������ ���� ���� �ʴ´�. after�� ���� ���ܰ� �߻��ص� event ������ ����ȴ�.
	- �̺�Ʈ 
		- Ʈ���Ÿ� �߻���ų SQL ����
		- update �� ��� : update of �÷���[,�÷���] ���� �÷��� ������ �� �ִ�.
	- ���̺� : Ʈ���ſ� ����� ���̺� �̸�
	- FOR EACH ROW : ������ �� Ʈ����, �����ϸ� ��ɹ� Ʈ����
	- DECLARE �� : ���๮���� ����� ������ ���� �Ѵ�. ���� ����
	- BEGIN �� : �����
		- ����ο��� commit/rollback�� �� �� ����.
	- EXCEPTION : ����ο��� �߻��� ����ó��. ���� ����

- ����ο��� �̺�Ʈ ����� �� ����
	- :old : ���� ���� �÷��� �� (update : ������ ������, delete: ���� ���� ������)
	- :new : ���� ���� �÷��� �� (insert : �Էµ� ������, update: ������ ������)
	- :new.�÷���, :old.�÷��� ���� ��ȸ�Ѵ�.
	
Ʈ���� ����
- drop trigger Ʈ���� �̸�
- ����� ���̺��� �����Ǹ� Ʈ���ŵ� �ڵ� �����ȴ�.
	
*************************************************************************************************************** */

set serveroutput on;
create or replace trigger ex_trigger    --delete�Ҷ����� �̰͵� ����ȴ�. 
    after delete on emp  --� �̺�Ʈ�� �߻��� ��~

--������ ������ ������ declare ��� ���ص� �ȴ�. 
begin
    dbms_output.put_line('emp���� ������ �߻�');
end;
/
delete from emp;   
rollback;
delete from emp where 1=0;

-- �� Ʈ����
DROP TABLE DEPT_COPY;
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPT;
create or replace trigger ex_2_trigger
    before insert or delete or update of loc   --�� �߰��ϰ� �ʹٸ� loc, dept_name
    on dept_copy
    for each row --�� ���� Ʈ����
    
begin
    dbms_output.put_line('���� �� loc: '|| :old.loc );
    dbms_output.put_line('���� �� loc: '|| :new.loc );
    dbms_output.put_line('���� �� dept_name: '|| :old.dept_name );
    dbms_output.put_line('���� �� dept_name: '|| :new.dept_name );
    dbms_output.put_line('------------------------------------------');
end;
/

insert into dept_copy
values (3030,'���μ�','��õ');
delete from dept_copy where loc='��õ';
update  dept_copy
set dept_name =dept_name,
    loc='�λ�'
where loc='Seattle'; 

--  DEPT ���̺� ���� insert �Ǹ� ���� ���� DEPT_COPY�� insert�ϴ� Ʈ���� �ۼ�.
create or replace trigger dept_copy_trigger
    after insert on dept
    for each row

declare 
   -- ex_error exception;  --����ó�� ����
begin

   -- raise ex_error;  --����ó���� �߻�
    insert into dept_copy
    values (:new.dept_id, :new.dept_name, :new.loc);
end;
/
insert into dept values (8900,'������ȹ��','���ﵿ');
insert into dept values (8901,'������ȹ��','���ﵿ');
insert into dept values (8902,'������ȹ��','���ﵿ');
insert into dept values (8903,'������ȹ��','���ﵿ');
--commit: trigger������ commit, rollback�� �� �� ����. 

select * from dept where loc='���ﵿ';
select * from dept_copy where loc='���ﵿ';
rollback;

-- dept_copy�� ���� 12 ~ 07�� ������ DML ������ �������� ���ϵ��� �ϴ� trigger ����
create or replace trigger ban_dml_dept_copy_trigger
    before insert or update or delete on dept_copy
    --for each row   --�� Ʈ���Ű� �ƴ϶�, ��ɹ� Ʈ���Ÿ� ����ؾ��Ѵ�. 

declare
    ex_error exception;  --����ó�� ����
    v_hour varchar2(2);  --�ð� ������ ����
begin
    --�ð� ��ȸ
    v_hour := to_char(sysdate,'hh24');
    if v_hour between '00' and '07' then
        raise ex_error;
    end if;

end;
/
update dept_copy
set loc=loc;


-- emp_copy ���̺��� DML(insert, delete, update)�� �߻��ϸ� �װ��� log�� ����� Ʈ���Ÿ� ����
drop table emp_copy ;
create table emp_copy as select * from emp where 1 =0;   --Ʋ�� ������


drop table logs;
create table logs (
 table_name varchar2(100), -- ���̺��̸�
 event_time date default sysdate, --DML ����ð�
 event varchar2(10) --DML ����
);

create or replace trigger emp_log_trigger
    after insert or delete or update on emp_copy
    --��ɹ�. (�ະ�� ��� ���� ���� �ƴϴϱ�)

declare
    v_event varchar(10);  --DML������ ���� ��!
begin
    if inserting then  --insert �� �߻��ߴٸ� true�� ��ȯ�ȴ�. 
        v_event :=' INSERT';
    elsif updating then
        v_event:='UPDATE';
    elsif deleting then
        v_event :='DELETE';
    end if;
    insert into logs values ('emp_copy',sysdate,v_event);
end;
/
insert into emp_copy(emp_name, hire_date,salary)
values ('ȫ�浿','2000/10/10',1000);
update emp_copy 
set emp_name=emp_name;
delete from emp_copy;
rollback;

select table_name , to_char(event_time,'hh24:mi:ss'), event
from logs;

-- ���� �ڵ带 dept_copy_log_trigger, job_copy_log_trigger �� ����� dept_copy, job_copy ���̺� �� ����. 
create or replace procedure logging_sp(p_table_name varchar2)   --****���̺� ���� ������ �����ϰ� ������ ���ν��� ����ؼ� �Ű������� �Ѱܹ޾� �����Ѵ�. 
    is
        v_event varchar(10);  --DML������ ���� ��!
    begin
        if inserting then  --insert �� �߻��ߴٸ� true�� ��ȯ�ȴ�. 
            v_event :=' INSERT';
        elsif updating then
            v_event:='UPDATE';
        elsif deleting then
            v_event :='DELETE';
        end if;
        insert into logs values (p_table_name,sysdate,v_event);
    end;
    /
--*****************Ʈ���Ŵ� ���̺� ������ �� ���ۿ� ��� ���ν����� ����.
create or replace trigger dept_logging_trigger
    after insert or delete or update on dept
begin
    logging_sp('dept');  --���̺���� �˷�����Ѵ�. 
end;
/

create or replace trigger job_logging_trigger
    after insert or delete or update on job
begin
    logging_sp('job');  --���̺���� �˷�����Ѵ�. 
end;
/
update dept 
set loc=loc;

update job 
set job_title=job_title;



















