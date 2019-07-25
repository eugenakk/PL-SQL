
/* ************************************************************************************************
���ڵ�(Record)
    - ������ ������ ������ Ÿ��. 
    - �ϳ��� ��(Row) ���� ǥ���ϴµ� ���ȴ�.
�ʵ�(Field) 
		- ���ڵ带 ���� ��ҷ� ���� value�� ������ �ִ�. 
		- ���ڵ��.�ʵ�� ���� �����Ѵ�.
    - ���� ���̺��� �̿��� ���ڵ�
    - ����� ���� ���ڵ�
************************************************************************************************ */


/* ************************************************************************************************
  - ���� ���̺��� �̿��� ���ڵ�
    -  %ROWTYPE �Ӽ�
    -  ���̺��̸�%ROWTYPE : ���� ���̺��̳� View�� �÷��� �ʵ�� ������ ���ڵ带 ����
        - �ش� ���̺��̳� VIEW�� ��� �÷��� �ʵ�� ������.
	- ����
		��������:  ������  ���̺��%rowtype;
	- ��ȸ�� �������� ���ڵ��� �ʵ���� ���̴�.
		���ڵ��� �ʵ� ��� : ������.�ʵ��
************************************************************************************************ */
set serveroutput on;
declare
    rec_emp emp%rowtype;   --���ڵ� Ÿ�� ���� : rec_������ 
                            --�ʵ��� ������ ���̺� ���� �� ������ �÷� ����.
     
begin
    select *
    into rec_emp 
    from emp
    where emp_id=100; 
    
    --���ڵ� ������.�ʵ�� 
    dbms_output.put_line(rec_emp.emp_id || ' ' || rec_emp.emp_name  || ' ' || rec_emp.salary);
end;
/


-- ROWTYPE�� �̿��� DML
drop table emp_copy;
create table emp_copy 
as 
select * from emp where dept_id =100 ;

declare
    rec_emp emp%rowtype;
begin
    select *
    into rec_emp
    from emp
    where emp_id=130;
    
    insert into emp_copy values rec_emp;  --�ʵ��-�÷����� ��ġ�ϴ� �÷��� ���� insert ���ش�. 
    --���ڵ� �ʵ��� �� ����
    rec_emp.salary :=30000;
    rec_emp.comm_pct := 0.3;
    rec_emp.hire_date := '2019/07/22';
    
    update emp_copy 
    set row=rec_emp   --��ü �÷��� ���� ���ڵ尡 ���� ������ ����. (��ü�� �ѹ��� �ٲ۴�)
    where emp_id=rec_emp.emp_id;
    commit;
end;
/

select * from emp where emp_id=140
union all 
select * from emp_copy where emp_id=140;

declare
    rec_emp emp%rowtype;
begin
    select emp_id, emp_name, salary
    into rec_emp.emp_id, rec_emp.emp_name, rec_emp.salary 
    from emp
    where emp_id=110;
    
    dbms_output.put_line(rec_emp.emp_id || ' ' ||rec_emp.emp_name || ' ' ||rec_emp.salary);
end;
/ 
--�Ʒ� TODO�� ��ȸ ����� ���� ������ %ROWTYPE ���ڵ�� ����.
-- TODO : JOB ���̺��� JOB_ID�� 'AD_PRES' �� ���� ��ȸ�� ���.

declare
    rec_job job%rowtype;
begin
    select *
    into rec_job
    from job
    where job_id='AD_PRES';
    
    dbms_output.put_line(rec_job.job_id || ' '||rec_job.job_title || ' ' || rec_job.min_salary || ' ' || rec_job.max_salary);
    
end;
/ 

-- TODO : CUSTOMERS ���̺��� ��_ID(cust_id), �̸�(cust_name), �ּ�(address), �̸����ּ�(cust_email)�� ��ȸ�Ͽ� ����ϴ� �ڵ� �ۼ�.  
declare
    rec_cust customers%rowtype;
begin
    select cust_id, cust_name, address, cust_email
    into rec_cust.cust_id,
    rec_cust.cust_name, 
    rec_cust.address, 
    rec_cust.cust_email
    from customers
    where cust_id=100;
    
    dbms_output.put_line(rec_cust.cust_id|| ' '|| 
                        rec_cust.cust_name|| ' '||
                        rec_cust.address|| ' '|| 
                        rec_cust.cust_email);
end;
/
desc customers; 

-- DEPT_COPY ���̺��� ���� (��� ������ ī��)
-- TODO : DEPT_COPY���� DEPT_ID�� 100�� �μ� ������ ����ϴ� �ڵ� �ۼ�.

create or replace table dept_copy
as
select * from dept;

declare
    rec_emp2 emp%rowtype;
begin
    select *
    into rec_emp2
    from emp
    where job_id='AD_PRES'; 
    
    dbms_output.put_line(rec_emp2.job_id || ' '||rec_emp2.emp_id || ' ' || rec_emp2.emp_name  || ' ' || rec_emp2.salary);
    
end;


-- TODO : DEPT_COPY �� ROWTYPE ���ڵ� ������ ���� �ϰ� �� ������ �ʵ忡 ������ ���� ������ �� INSERT �ϴ� �ڵ带 �ۼ�.
declare
    rec_dept_copy dept_copy%rowtype;
begin
    rec_dept_copy.dept_id := 4500;
     rec_dept_copy.dept_id := '���μ�4500';
     rec_dept_copy.loc :='����';
     insert into dept_copy values rec_dept_copy;
    
    
    dbms_output.put_line(rec_emp2.job_id || ' '||rec_emp2.emp_id || ' ' || rec_emp2.emp_name  || ' ' || rec_emp2.salary);
    
end;

/* ************************************************************************************************
����� ���� ���ڵ�
 - ���ڵ� Ÿ���� ���� ����
 - ���� ����� ������ Ÿ������ ����Ѵ�. 
 - ����

 TYPE ���ڵ��̸� IS RECORD (
    �ʵ��  �ʵ�Ÿ�� [NOT NULL] [ := ����Ʈ��] , 
    ...
 );      

    -�ʵ� Ÿ�� (������ Ÿ��)
        -pl/sql ������ Ÿ��
        -%type
        -%rowtype, ����� ���� ���ڵ� Ÿ��
    -���
        -������ ���ڵ��̸� 
        -TYPE �̸� IS ���� 
                
 ************************************************************************************************ */
declare
    --�μ�ID,  �μ��̸��� ������ �� �ִ� ���ڵ� �ϳ� ����.
    type dept_type is record (
        --���ڵ� Ÿ�� �̸�: �̸�_type ��� ����. 
        --id number(4),
        --name varchar2(100) 
        id dept.dept_id%type,
        name dept.dept_name%type;
    );
    
    rec_dept dept_type;  --id/name�� �ʵ�� ������ ���ڵ�
        
begin
     select dept_id, dept_name
     into rec_dept 
     from dept
     where dept_id =10;
     
     dbms_output.put_line(rec_dept.id || ' - '|| rec_dept.name);
     rec_dept.id :=20;

end; 
/

--TODO: �Ʒ� select �� �������� ������ ����� ���� ���ڵ带 ����� SQL�������� �� Ÿ���� ������ �����ѵ� ����ϴ� ���ν����� �ۼ�.
/*
select e.emp_id, e.emp_name, d.dept_id, d.dept_name, j.job_title
from emp e, dept d, job j
where e.dept_id = d.dept_id(+)
and   e.job_id = j.job_id(+)
and   e.emp_id = 100;
*/
declare
    type emp_type is record(
        emp_id emp.emp_id%type,
        emp_name emp.emp_name%type,
        dept_id dept.dept_id%type,
        dept_name dept.dept_name%type,
        job_title job.job_title%type
    );
    rec_emp emp_type;
begin
        select e.emp_id, e.emp_name, d.dept_id, d.dept_name, j.job_title
        into rec_join.rec
        from emp e, dept d, job j
        into rec_emp 
        where e.dept_id = d.dept_id(+)
        and   e.job_id = j.job_id(+)
        and   e.emp_id = 100;
        
        dbms_output.put_line(rec_emp.emp_name || '-' ||rec_emp.dept_name);
end;
/

/* ************************************************************************************************************************************************************************************
�÷���

- ���� Ÿ���� ������ ������ �����ϴ� ����.
    - ���ڵ�� �پ��� Ÿ���� �ʵ带 �������� ���̺� ó�� ���� ROW�� ���� �� ����.
    - �÷����� ���� row�� ������ ����
- ����
  1. �����迭: Ű�� ������ ������ �÷���
  2. VARRAY  : ũ�Ⱑ ������ �ִ� �迭����
  3. ��ø���̺� : ũ�⸦ �����Ӱ� ���� ���ִ� �迭����
     
     
************************************************************************************************************************************************************************************ */

/* *********************************************************************************************
- �����迭(Associative Array)
    - Ű-�� ������ ������ �÷���
    - Ű�� INDEX�� �θ��� ������ Index-by ���̺��̶�� �Ѵ�.
	- ������ Ÿ������ ���ȴ�.
- ����
    - Ÿ�� ����
        - TYPE �̸� IS TABLE OF ��Ÿ�� INDEX BY Ű(�ε���)Ÿ��
        - ��Ÿ�� : ��� Ÿ�� ����
        - Ű(�ε���) Ÿ�� : ������ �Ǵ� PLS_INTEGER/BINARY_INTEGER Ÿ�Ը� ����.
    - ����ο� �����Ѵ�.
	- Ÿ���� ���� �ѵ� ������ Ÿ������ ����� �� �ִ�.
	- �� ���� : �迭�̸�(INDEX):=��
    - �� ��ȸ : �迭�̸�(INDEX)
********************************************************************************************* */

--TODO
-- 1. index�� ũ�� 10�� ���ڿ��� ���� date�� ������ �����迭 ����
-- 2. index�� ����, ���� dept ���̺��� loc�� ���� Ÿ���� �����迭 ����
declare
    --1�� ����
    type var1_table_type is table of date
    index by varchar2(10);
    --2�� ����
    type var2_table_type is table of dept.loc%type;
    index by binary_integer;  
        
begin

end;
/

--TODO �μ� ID�� Index�� �μ� ���ڵ�(%ROWTYPE)�� Value�� ������ �����迭�� �����ϰ�
-- dept_id�� 10�� �μ��� dept_id�� 20 �� �μ��� ����(dept_id, dept_name, loc)�� ��ȸ�Ͽ� �����迭 ������ �ִ� ���ν����� �ۼ�
declare
    type dept_table_type is table of dept%rowtype
        index by binary_integer;
        
    dept_table dept_table type;
begin
    select *
    into dept_table(10) 
    from dept
    where dept_id=10;
end;
/



-- TODO: emp_id �� 100 ~ 120���� ������ �̸��� ��ȸ�� �����迭(index: emp_id, value: emp_name)�� �����ϴ� �ڵ带 �ۼ�.
declare

begin
	--�ݺ����� �̿��� 100 ~ 120 �� ������ �̸��� ��ȸ �� �����迭�� ���尡��
	
	
	--�����迭���� ��ȸ��� ���
end;
/





/* *********************************************************************************************
- VARRAY(Variable-Size Array)
    - �������� �迭. 
		- ����� �迭�� ũ��(�ִ��Ұ���)�� �����ϸ� �� ũ�� ��ŭ�� ��Ҹ� ���尡��
        - ������ ���� �̻� ���� �� �� ������ ���� �����ϴ� ���� ����.
    - Index�� 1���� 1�� �����ϴ� ������ �ڵ����� �����ȴ�.
    - �����ڸ� ���� �ʱ�ȭ
		- �ݵ�� �����ڸ� �̿��� ������ ������ �ڿ������ �� �ִ�.
    - �Ϲ� ������ �������� ���� �����ؾ� �ϴ� ��� ���� ����(index�� ���� �����̹Ƿ�)
	- C �� Java�� �迭�� ����� �����̴�.
- ����    
    - Ÿ�� ����
        - TYPE �̸� IS VARRAY(�ִ�ũ��) OF ��Ұ�Ÿ��;
    - �ʱ�ȭ 
        - ���� := �̸�(�� [, ...]) 
        - �ʱ�ȭ �� ������ŭ�� ���� ���� 
    - �� ����(����) : �̸�(INDEX):=��
    - �� ��ȸ : �̸�(INDEX)
********************************************************************************************* */
declare
    type va_type is varray(5) of varchar2(100);
    va_arr va_type; 
begin
    --�ʱ�ȭ
    va_arr := va_type('��','��','��');  --��������鼭 ������ �� ����, �ε��� 1,2,3. 
    --�ʱ�ȭ�� 3���� �߱� ������ ũ��� 5�� �ƴ϶� 3���̴�.  (����� 3���� ���ߴٴ� ��)
    va_arr(2) :='B';  --���� ����.
    --va_arr(4) :='K';  -ó���� 3���� �־ �߰��� �� X. 5�� ũ���� ���� �ƴ϶�, �ִ�ũ��.
    dbms_output.put_line(va_arr(1) || '  '|| va_arr(2) || '  ' ||va_arr(3));
    
    for idx in 1..3    --�ݺ����� idx �� ���� ������. (idx ������ for�� ����ϴ� ���� ��)
    loop
        dbms_output.put_line(va_arr(idx));
    end loop;
end;
/

--dept_id 10,50,70 �� �μ��� ������ ��ȸ---->�����迭 ��� ���
declare
--����� ���� �����迭 Ÿ��
    type dept_table_type is table of dept%rowtype 
        index by binary_integer;
--��ȸ�� �μ� id���� ���� varray 
    type dept_id_list is varray(3) of dept_id%type;  --dept_id�� ������ ���̴ϱ� type�� dept_id%type.

    dept_table dept_table_type;
    dept_ids dept_id_list;
begin
    dept_ids := dept_id_list(10,50,70);   --�ʱ�ȭ
    for idx in 1..3
    loop
        select *
        into dept_table(dept_ids(idx))
        from dept
        where dept_id=dept_ids(idx);
    end loop;
    
    --��ȸ��� ���
    for idx in 1..3
    loop
       dbms_output.put_line(dept_table(dept_ids(idx)).dept_name || ' ' |
                                    dept_table(dept_ids(idx)).loc);
    end loop;
end;
/


/* *********************************************************************************************
- ��ø���̺�(Nested Table)
    - ����� ũ�⸦ �������� �ʰ� 
    - �����ڸ� �̿��� �ʱ�ȭ �Ҷ� ���Ե� ���� ���� ���� ũ�Ⱑ ��������.
    - �����ڸ� ����� �ʱ�ȭ �� ���
    - index �� 1���� 1�� �ڵ������ϴ� ������ ����.    
    - �Ϲ� ���̺��� �÷� Ÿ������ ���� �� �ִ�.
- ����
    - Ÿ�� ����
        - TYPE �̸� IS TABLE OF ��Ÿ��;
********************************************************************************************* */
declare
    type nt_table_type is table of number;  --number Ÿ������ ���̺� ����.
    nt_table nt_table_type;  --nt_table����.
    nt_table2 nt_table_type;
begin
    --�����ڸ� �̿��� �ʱ�ȭ.
    nt_table := nt_table_type(10,20,30,40,50);  --������ ���� ����X   (Varray �ƴϹǷ�)
    nt_table2 :=nt_table_type(60,70,80,90,100,110,120);
    --���� ������ .. �� ��ü�� ���� ������ŭ ũ�Ⱑ ��������**********************************
    nt_table(2) :=2000;  --���� (����)
    dbms_output.put_line(nt_table(2));
    
   -- for idx 1..5
   for idx in 1..nt_table.count       --ũ�⸦ count�� ����ؼ� 
    loop
       dbms_output.put_line(nt_table(idx));
    
    end loop;
end;
/


/* *****************************************************************************************************************************
- �÷��� �޼ҵ�
 # DELETE : ��� ��� ����
 # DELETE(n) : index�� n�� ��� ���� (varray�� ��������)
 # DELETE(n, m) : index�� n ~ m �� ��� ���� (varray�� ��������)
 
 # EXISTS(index) : index�� �ִ� �� ���� boolean������ ��ȯ
 # FIRST : ù��° INDEX ��ȯ
 # LAST : ������ INDEX ��ȯ
    - FOR idx IN �÷���.FIRST..�÷���.LAST  
 # PRIOR(index) : index ���� INDEX ��ȯ
 # NEXT(index) : index ���� INDEX ��ȯ

# COUNT: �÷��ǳ��� ��� ���� ��ȯ 

***************************************************************************************************************************** */
declare
     type varr_type is varray(5) of varchar2(10);
     
     varr varr_type;
begin
    varr := varr_type('a','b','c','d');   --�ʱ�ȭ
    dbms_output.put_line(varr.first); 
    dbms_output.put_line(varr.last); 
      dbms_output.put_line(varr.next(3));  --3�� ���� index 4 �� ����
      dbms_output.put_line(varr.prior(3)); 
      
      if varr.exists(3) then            --�ִ��� ������ ���ؼ� ������ ó��, ������ �۾����� ����.
        dbms_output.put_line('index ����!!!!');
    end if;
end;
/

-- TODO: emp���� emp_id�� 100 ~ 120�� �������� ������ ��ȸ�� �� �� ������ emp_copy�� �߰��ϴ� �ڵ带 �ۼ�.
DECLARE
    -- �����迭 Ÿ�� ����(��ȸ�� ���������� ����): key - emp_idŸ��, value:emp row
    type emp_table_type is table of emp%rowtype 
        index by binary_integer;
         
    -- �����迭 Ÿ�� ���� ����
    emp_table emp_table_type;
    
BEGIN
    -- �ݺ����� �̿��� emp_id�� 100 ~ 120 �� ���� ��ȸ�ؼ� �����迭�� ���� 
	for idx in 100..120 
    loop
        select *
        into emp_table(idx)
        from emp
        where emp_id = idx;
    end loop;
	
	-- �ݺ����� �̿��� �����迭�� ����� ��ȸ������� emp_copy ���̺�  insert (FIRST, LAST �޼ҵ� �̿�)
	for idx in emp_table.first..emp_table.last
    loop
        insert into emp_copy values emp_table(idx);
    end loop;
    commit;
END;
/
select * from emp_copy;
drop table emp_copy;
create  table emp_copy 
as
select * from emp;

desc emp_copy;
