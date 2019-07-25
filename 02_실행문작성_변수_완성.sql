/* ***********************************************************************************************
���� ���
- ���� ����
  - DECLARE ������ �Ѵ�.
  - ����: ������ [CONSTANT] ������Ÿ�� [NOT NULL] [ := �⺻��] 
     - CONSTANT : ���� ������ �� ���� ����. ����� �ݵ�� �ʱ�ȭ �ؾ� �Ѵ�.
	 - ������Ÿ��: ����Ŭ ������Ÿ��+PL/SQL ������Ÿ�� �����Ѵ�.
	 - NOT NULL: ������ NULL�� ������ �ȵ��� ������������ ����. ����� �ݵ�� �ʱ�ȭ �Ǿ���.
	 - ����� [DEFAULT ��] ���� �ʱⰪ ���� ����
  - ���Կ�����
     -  ���� := ��
*********************************************************************************************** */
declare
-- ������(identifier)    datatype
    v_message1           varchar2(100);  --null �� �ʱ�ȭ.  
    v_message2           varchar2(100)    not null := '�⺻�޼���';
    c_num       constant pls_integer      default 20;
    --not null������ constant(���)�� ����� �ʱ�ȭ �ؾ� �Ѵ�.
begin
    v_message1 := 'hello world';
    v_message2 := '&msg'; --ġȯ������.
--    c_num := 5000; --������� ���� ���Ҵ� �� ������.
    dbms_output.put_line(v_message1);
    dbms_output.put_line(v_message2);
    dbms_output.put_line(c_num);
end;
/
-- TODO: DECLARE ���� ���� ������ ������ ������(�̸�, ����, �ּ� ���)�� �����ϰ� 
--���� ���(BEGIN)���� ���� ������ �� ����ϴ� �ڵ� �ۼ�.
declare
    v_name nvarchar2(50);
    v_age  pls_integer; --number
    v_address nvarchar2(100);
begin
    v_name := 'ȫ�浿';
    v_age := 30;
    v_address := '����� ���α�';
    dbms_output.put_line('�̸� : '||v_name);
    dbms_output.put_line('���� : '||v_age);
    dbms_output.put_line('�ּ� : '||v_address);
end;
/

-- TODO: emp ���̺��� �̸�(emp_name), �޿�(salary), Ŀ�̼Ǻ���(comm_pct), 
--�Ի���(hire_date) �� ���� ������ �� �ִ� ������ �����ϰ�
-- &������ �̿��� ���� �Է� �޾� ����ϴ� �ڵ带 �ۼ�.
desc emp;

declare
    v_emp_name varchar2(20);
    v_hire_date date;
    v_salary number(7,2);
    v_comm_pct number(2,2);
begin
    v_emp_name := '&e_name';
    v_hire_date := '&hire_date';
    v_salary := &salary;
    v_comm_pct := &comm_pct;
    
    dbms_output.put_line(v_emp_name||' , '||v_hire_date||
                         ' , '||v_salary||' , '||v_comm_pct);
end;
/


/* **********************************************************
- %TYPE �Ӽ�
  - �÷��� ������Ÿ���� �̿��� ������ Ÿ�� �����
  - ����:   ���̺��.�÷�%TYPE
    ex) v_emp_id emp.emp_id%TYPE
*********************************************************** */
-- dept ���̺��� �÷����� ������ Ÿ���� �̿��� ���� ����
declare
    v_dept_id  dept.dept_id%type;
    v_dept_name dept.dept_name%type := '����';
    v_loc dept.loc%type;
begin
    v_dept_id := 2000;
    v_loc := '����';
    dbms_output.put_line(v_dept_id||','||v_dept_name||','||v_loc);
end;
/
desc dept;
-- TODO: job ���̺��� �÷����� Ÿ���� �̿��� 
--v_job_id, v_job_title, v_max_salary, v_min_salary �� �����ϰ� 
--& ������ �̿��� ���� �Է� �޾� ����ϴ� �ڵ� �ۼ�
desc job;
declare
    v_job_id    job.job_id%type;
    v_job_title job.job_title%type;
    v_max_salary job.max_salary%type;
    v_min_salary job.min_salary%type;
begin
    v_job_id := '&job_id';
    v_job_title := '&job_title';
    v_max_salary := &max_sal;
    v_min_salary := &min_sal;
    dbms_output.put_line(v_job_id||' , '||
                         v_job_title||' , '||
                         v_max_salary||' , '||
                         v_min_salary);
end;
/

/* ***********************
���ε� ����, ȣ��Ʈ ����
- ����
variable ������ Ÿ��;
var ������ Ÿ��;
var name varchar2(100);
- ���
:������
:name

*********************** */
var e_id number;
exec :e_id := 200;

select * from emp
where emp_id = :e_id;


/* ******************************************************************
 PL/SQL���� ������(Sequence) ���
 - select �������� sequence�̸�.nextval �� �ٷ�ȣ�� ����.
********************************************************************* */
create sequence t_seq;
declare
    v_num number;
begin
    v_num := t_seq.nextval;
    dbms_output.put_line(v_num);
    dbms_output.put_line(t_seq.currval);
end;
/


/* ****************************************************************
���ν������� �Լ� ���
 - ����/����/��¥/��ȯ �Լ��� ó������� 1���� �� ���� �������� �ܵ����� ����� �� �ִ�.
 - �����Լ��� DECODE() �Լ��� SQL�������� ����� �� �ִ�. 
******************************************************************* */

begin
    dbms_output.put_line(length('aaaaa'));
    dbms_output.put_line(round(4.23232, 2));
    dbms_output.put_line(upper('Hello World'));
    dbms_output.put_line(to_char(sysdate, 'hh24:mi:ss'));
    --dbms_output.put_line(sum(10));
end;
/
-- TODO: ������ ������� ����ϴ� �ڵ带 �ۼ�
/*
"����� ������ ���ﵿ" ���ڿ��� ���̸� ���
"Hello World" �� �빮�ڷ� ���
100.23456 �� �Ҽ��� ù��° ���Ͽ��� �ݿø� �ؼ� ���
SYSDATE���� ��:��:�� �� ���

/* *************************************************************
��ø ����
- PL/SQL �����ϳ��� PL/SQL ������ ��ø�ؼ� �ۼ��� �� �ִ�.
- ���� �����Ͽ����� �ٱ��� ���౸������ ������ ������ ����� �� ������ �ݴ�� �ȵȴ�.
*************************************************************** */
declare
    v_outer varchar2(100) := 'v_outer';
begin
    declare
        v_inner varchar2(100) := 'v_inner';
    begin
        dbms_output.put_line('INNER: '||v_outer);--outer�� ������ inner ���� ��밡��.
        dbms_output.put_line('INNER: '||v_inner);
    end;
    
    dbms_output.put_line('OUTER: '||v_outer);
--    dbms_output.put_line('OUTER: '||v_inner);--inner�� ����� ������ outer���� ������.
end;
/
begin <<outer_p>>
    declare
        v_outer varchar2(100) := 'v_outer';
    begin
        declare
            v_inner varchar2(100) := 'v_inner';
            v_outer number := 30;
        begin
            dbms_output.put_line('INNER: '||v_outer);
            dbms_output.put_line('INNER: '||outer_p.v_outer);
            dbms_output.put_line('INNER: '||v_inner);
        end;
        
        dbms_output.put_line('OUTER: '||v_outer);
    
    end;
end;    
/

/* *************************************************************************************	

DML ����
- insert/delete/update
- SQL�� ����
- ó���� commit

************************************************************************************* */
drop table dept_copy;
create table dept_copy
as
select * from dept;
-- insert
declare
    v_dept_id dept.dept_id%type;
    v_dept_name dept.dept_name%type;
    v_loc dept.loc%type;
begin
    v_dept_id := :id;
    v_dept_name := :name;
    v_loc := :loc;
    
    --insert into dept values (2000, '��ȹ��', '��õ');
    insert into dept_copy values (v_dept_id, v_dept_name, v_loc);
    v_dept_name := '������';
    v_loc := '�λ�';
    insert into dept_copy values (v_dept_id+1, v_dept_name, v_loc);
    insert into dept_copy values (v_dept_id+2, v_dept_name, v_loc);
    commit;
end;
/

rollback;
select * from dept_copy order by 1 desc;

--delete
begin
    delete from dept_copy 
    where loc = '����';
    commit;
end;
/
--update
declare
    v_dept_id dept.dept_id%type := :dept_id;
    v_loc dept.loc%type := :loc;    
begin
    update  dept_copy
    set     loc = v_loc
    where   dept_id = v_dept_id;
    commit;
end;
/
select *from dept_copy order by 1 desc;
rollback;
-- TODO : emp ���̺� ���ο� �������� �߰��ϴ� ������ �ۼ�.
declare

begin
    insert into emp (emp_id, emp_name, hire_date, salary)
    values (3801, '������', :hiredate, 30000);
--    
--    insert into emp (emp_id, emp_name, hire_date, salary)
--    values (3702, '������', '2007-10-20', 30000);
--    
--    insert into emp (emp_id, emp_name, hire_date, salary)
--    values (3703, '������', '2009-10-20', 30000);
    commit;
end;
/
select * from emp where emp_id >= 3700;

-- TODO : ������ �߰��� ���� ���� salary�� comm_pct �� ���� ���� �ø��� ������ �ۼ�
declare
    v_num number := 3;
begin
    update  emp
    set     salary = salary * v_num,
            comm_pct = comm_pct * v_num
    where   emp_id in (100);            
end;
/
select * from emp where emp_id >= 3700;
rollback;

-- TODO : ������ �߰��� ���� ���� �����ϴ� ������ �ۼ�
begin
    delete from emp where emp_id in (3700, 3701, 3702);
    commit;
end;
/
/* *************************************************************************************
��ȸ����
select into �� 

select ��ȸ�÷�
INTO   ��ȸ���� ������ ����
from ���̺�
where ��������
group by 
having
order by
************************************************************************************* */
-- �μ� ID(dept_id)�� 10�� �μ��� �̸�(dept_name), ��ġ(loc) �� ��ȸ�ϴ� ����
declare
    v_dept_id     dept.dept_id%type;
    v_dept_name   dept.dept_name%type;
    v_loc           dept.loc%type;
begin
    select dept_id,   dept_name,   loc
    into   v_dept_id, v_dept_name, v_loc 
    from dept
    where dept_ID = 10;
    
    dbms_output.put_line(v_dept_id||' - '||v_dept_name||' - '||v_loc);
end;
/
set serveroutput on;

--���� id(emp.emp_id) �� 110 �� ������ �̸�(emp.emp_name), �޿�(emp.salary),
-- �μ� ID(dept.dept_id) �μ��̸�(dept.dept_name) ����ϴ� �����ۼ�
declare
    v_emp_name    emp.emp_name%type;
    v_salary      emp.salary%type;
    v_dept_id     dept.dept_id%type;
    v_dept_name   dept.dept_name%type;
begin
    select e.emp_name, e.salary, d.dept_id, d.dept_name
    into   v_emp_name, v_salary, v_dept_id, v_dept_name
    from   emp e, dept d
    where  e.dept_id = d.dept_id(+)
    and    e.emp_id = 110;
    
    dbms_output.put_line(v_emp_name||' - '||v_salary||' - '||
                         v_dept_id||' - '||v_dept_name);
end;
/

-- TODO ������ ID�� 120�� ������ �̸�(emp.emp_name), �޿�(emp.salary), 
-- ����_ID (emp.job_id), �Ի���(emp.hire_date)�� ����ϴ� ���� �ۼ�
declare
    v_emp_name  emp.emp_name%type;
    v_salary    varchar2(100);--emp.salary%type;
    v_job_id    emp.job_id%type;
    v_hire_date emp.hire_date%type;
begin
    select  emp_name, 
            to_char(salary, 'fm$99,999'),  
            job_id,
            hire_date
    into    v_emp_name, 
            v_salary,
            v_job_id,
            v_hire_date
    from    emp
    where   emp_id = 120;
    
    dbms_output.put_line(v_emp_name||' - '||v_salary||' - '||
                         v_job_id||' - '||v_hire_date);
        
end;
/


-- TODO �μ����̺� dept_id=9900, dept_name='�濵��ȹ', loc='����' �� insert �ϰ� 
-- dept_id�� ��ȸ�Ͽ� �Է°���� ����ϴ� ������ �ۼ�.
declare
    v_dept_id dept.dept_id%type;
    v_dept_name dept.dept_name%type;
    v_loc dept.loc%type;
begin
    insert into dept values (9900, '�濵��ȹ', '����');
    select dept_id, dept_name, loc
    into   v_dept_id, v_dept_name, v_loc
    from dept
    where dept_id = 9900;
    commit;
    dbms_output.put_line(v_dept_id||' - '||v_dept_name||' - '||v_loc);
end;
/
select * from dept where dept_id = 9900;

-- TODO ����_ID�� 110�� ������ �̸�(emp.emp_name), ���� ID(emp.job_id), 
-- ������(job.job_title) ����ϴ� ���� �ۼ�

declare
    v_emp_name emp.emp_name%type;
    v_job_id   emp.job_id%type;
    v_job_title job.job_title%type;
begin
    select  e.emp_name, e.job_id, j.job_title
    into    v_emp_name, v_job_id, v_job_title
    from    emp e, job j
    where   e.job_id = j.job_id(+)
    and     e.emp_id = 110;
    
    dbms_output.put_line(v_emp_name||' - '||v_job_id||' - '||v_job_title);
end;
/











