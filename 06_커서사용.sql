/* *********************************************************************************************************************************************
Ŀ��(Cursor)
 - Ŀ���� ��ǻ�Ϳ��� ���� ��ġ�� ����Ű�� ���� ���Ѵ�.
 - ����Ŭ���� Ŀ��
    - ������ SQL���� ó���� ����� ����Ű�� ������ Ŀ���� �̿��� ó���� ��� ������ ������ ���� �� �ִ�.
 - ��ȸ����� ���� �̻��� ��� �ݵ�� Ŀ���� ����ؾ� �Ѵ�.
	- select into �δ� ������ ����� ��ȸ�����ϴ�.

- Ŀ���� ���� �ܰ�
    - Ŀ�� ����
    - Ŀ�� ����(open)  --���� ���� ���� ����
    - ��ġ (fetch)  --���� ����� ������
    - Ŀ�� �ݱ� (close)  --���� �� �׸�.
    
 - ������ Ŀ��, ����� Ŀ��
    - ������ Ŀ�� 
        - ����Ŭ ���ο��� �ڵ����� �����Ǿ� ���Ǵ� Ŀ���� PL/SQL ��Ͽ��� 
		  �����ϴ� ����(INSERT,UPDATE,DELETE, SELECT INTO)�� ����� ������ �ڵ����� ������.
        - ���� ���� �ܰ谡 �ڵ����� ó���ȴ�.
        
    - ����� Ŀ�� 
        - ����ڰ� ���� �����ؼ� ����ϴ� Ŀ���� select ����� ��ȸ�� �� ����Ѵ�.
        - ���� ������ ���� �ܰ踦 ��������� ó���ؾ� �Ѵ�. (Ŀ�� ����, open, fetch,close)

- Ŀ�� �Ӽ�
    - Ŀ���� �����ϴ� ��������� ������.
      - Ŀ���̸�%FOUND      : ��� ���տ��� ��ȸ������ ���� �ִ��� ���� ��ȯ.
                            1�� �̻� ������ ��(True) ������ ����(False) ��ȯ
      - Ŀ���̸�%NOTFOUND   :  %FOUND�� �ݴ�.
                            Cursor �� ���� ���������� ���� Ŀ���� ��� set�� ���ڵ尡 ������ ��(True)
      - Ŀ���̸�%ROWCOUNT   :  SQL���� ���� ���� ���� ���� ��ȯ
      - Ŀ���̸�%ISOPEN     : ���� Ŀ���� OPEN �����̸� ��(True), CLOSE �����̸� ����(False)
      - Ŀ���̸� 
        - ������ Ŀ�� :  SQL ����. (��: SQL%FOUND)
        - ����� Ŀ�� :  Ŀ���̸� ���� (��: my_cursor%FOUND)
*********************************************************************************************************************************************  */    
SET SERVEROUTPUT ON;

-- ������ Ŀ���� �� (update ���� ���)
begin
    update emp
    set emp_name =emp_name
    where emp_id>150;
    dbms_output.put_line(sql%rowcount); --sql%rowcount --> ������ Ŀ�� ����ؼ� ���� ��ȸ����.
end;
/

-- ������ Ŀ���� ��(select ��ȸ��� ���)
declare
    v_name emp.emp_name%type;
    
begin
    select emp_name
    into v_name
    from emp
    where emp_id = 100; 
    if sql%found then   --��ȸ ������ ���� ����������....
        dbms_output.put_line(sql%rowcount);
    end if; --select�� ������ ���� �ְ� 1��. ����� 1�̹Ƿ�.
end;
/


--TODO
/* *********************************************************************
--Database���� DML�� ����Ǹ� �� ����� ������ ���̺�
	- log_no: ��ȣ
	- category : � ������ ����Ǿ����� ���� 
		- 'I' - insert, 'U' - update, 'D' - delete
	- exec_datetime : DML���� ���� �Ͻ�
	- table_name : ����� ���̺�
	- row_count : ������ ����� ���� ���� 
********************************************************************* */
create sequence dml_log_no_seq; 
drop table dml_log;
create table dml_log(
    log_no number primary key,
    category char not null constraint ck_dml_log_category check(category in ('I', 'D', 'U')),
    exec_datetime date default sysdate not null,
    table_name varchar2(100) not null,
    row_count number not null
);

/* *********************************************************************
 dml_log_no_seq ���̺��� log_no �÷��� ���� ������ sequence.
*********************************************************************** */
drop table emp_copy;
create table emp_copy as select * from emp;

-- TODO: �Ķ���ͷ� dept_id�� �޾Ƽ� �� �μ��� �Ҽӵ� �������� �����ϰ� dml_log�� ����� ����� stored procedure�� ����
--emp_copy���� ����
create or replace procedure delete_emp_by_dept_id_sp (p_dept_id in dept.dept_id%type) --default�� IN����̹Ƿ� ���� ����.
is                                        
     v_del_cnt binary_integer;  --���� ����� ������ ����.   
    
begin
    delete
    from emp_copy
    where dept_id=p_dept_id;   
    
    v_del_cnt := sql%rowcount;    --sql%rowcount�� ���
    
    insert into dml_log values (dml_log_no_seq.nextval,
                                'D',sysdate,'EMP_COPY',v_del_cnt);
   commit;
end;
/

exec delete_emp_by_dept_id_sp(110);

/* ************************************************************ 
- ����� Ŀ�� ��� ����
1. Ŀ�� ����
    - CURSOR Ŀ���̸� [(�Ķ�����̸� datatype[:=�⺻��], ...)] IS 
            select ����;
    
	- �Ķ����
        - Ŀ�� ���� ���޹��� ���� �ִ� ��� ����(������ ����) 
		- ������ ������Ÿ�� [:= �⺻��] 
		- �⺻���� �ִ� ��� ȣ��� �� ������ ������ �� �ִ�.
		
2. Ŀ������
    - OPEN Ŀ���̸� [(���ް�1, ���ް�2,..);
    - Ŀ���� �Ķ���Ͱ� ����� ��� ������ ���� ( ) �� ����. ������ () ����
	
3. Ŀ���κ��� ��ȸ ��� ������ �б�
    - FETCH Ŀ���̸� INTO ���� [,..]
	- ���� : Ŀ���� ��ȯ�ϴ� ��ȸ ������� ���� ����. select ���� �÷� ������ŭ�� ������ �����Ѵ�. 
	
4. Ŀ�� �ݱ�
    CLOSE Ŀ���̸�;
    
- Ŀ�� ���Ǵ� ����ο��� �ۼ�
- Ŀ�� ���� ~ �ݱ�� �����ο��� �ۼ�
************************************************************ */
-- DEPT_ID �� 100 �� ������ ���� ��ȸ

declare
    rec_emp emp%rowtype; --��ȸ��� �� ���� ������ ����
    --Ŀ���� ����: � sql���� ���� ����� ����� Ŀ������ ����.
    cursor emp_cur is   --�������� Ŀ���� ����*********** \
    --emp_cur �� �������� Ŀ���� �ٷ� �� �ִ�. 
    select *
    from emp
    where dept_id=100;
    
    
begin
    --2: Ŀ�� ���� (open) : 1���� ������ sql���� ����ǰ� �� ���� ����� Ŀ���� ����ȴ�. 
    open emp_cur;  --�������� ������ ����ȴ�. 
    
    --3: ��ȸ ��� ��������
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    
    --4:����ó�� �ݱ� �ϱ�.
    close emp_cur;
end;
/

-- ******************** �Ķ���Ͱ� �ִ� CURSOR  ************************

declare
    rec_emp emp%rowtype; --��ȸ��� �� ���� ������ ����
    --Ŀ���� ����: � sql���� ���� ����� ����� Ŀ������ ����.
    cursor emp_cur (cp_dept_id dept.dept_id%type) is  
        select *
        from emp
        where dept_id=cp_dept_id ;
    
begin
    --2: Ŀ�� ���� (open) : 1���� ������ sql���� ����ǰ� �� ���� ����� Ŀ���� ����ȴ�. 
    open emp_cur(110);  --�������� ������ ����ȴ�. 
    
    
    --3: ��ȸ ��� ��������
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
    
    --4:Ŀ���� �ݱ�
    close emp_cur;
        
    open emp_cur(110);
    fetch emp_cur into rec_emp;
    dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
      dbms_output.put_line(rec_emp.emp_id ||' ' || rec_emp.emp_name);
      close emp_cur;
end;
/

/* *********************************************************************************************
- LOOP �ݺ����� �̿��� ��ȸ�� ��� ��� ��ȸ
    - cursor �� fetch ������ loop ������ �ݺ��Ѵ�. 
    - ��ȸ ������ ���� ������ LOOP �� ���� ���´�. 
********************************************************************************************* */
declare 
    cursor dept_cur(cp_loc dept.loc%type) is
        select * 
        from dept
        where loc=cp_loc;
        
        rec_dept dept%rowtype;   --dept�� ��� ������ ��ȸ�����ϵ���.
        
begin
    open dept_cur('New York');
    --LOOP���� �̿��ؼ� fetch�� �Ѵ�. 
    loop
        fetch dept_cur into rec_dept; 
        exit when dept_cur%notfound;   --dept_cur���� �� �̻� ������ ���� ������... EXIT!!!!!!!!!******************************8
        dbms_output.put_line(rec_dept.dept_id || ' '|| rec_dept.dept_name || ' '|| 
                                rec_dept.loc);
    end loop;
    close dept_cur; 
end;
/


-- TODO: EMP���̺��� Ŀ�̼�(comm_pct)�� NULL�� ������ ID(emp_id), �̸�(emp_name) , 
--�޿�(salary), Ŀ�̼�(comm_pct)�� �̸� ������������ ������ ����� ���
�ѹ� 
--LOOP�ϰ� For�� ���
declare 
    rec_emp emp%rowtype;  --������ ���� ������ ����.
    
    cursor emp_cur is
        select emp_id, emp_name, salary, comm_pct
        from emp
        where comm_pct is null
        order by emp_name desc;
begin
    open emp_cur;
    --LOOP���� �̿��ؼ� fetch�� �Ѵ�. 
    loop
        fetch emp_cur into rec_emp.emp_id, rec_emp.emp_name,
                            rec_emp.salary, rec_emp.comm_pct;  --�� ���� ����� �־��ش�. 
                            
        exit when emp_cur%notfound; --Ŀ���� ���̻� X�϶� loop���� ������. 
        dbms_output.put_line(rec_emp.emp_name || ' '|| rec_emp.comm_pct);
    end loop;
    close emp_cur; 
end;
/


-- TODO: DEPT ���̺��� ��ġ�� 'New York' �� �μ����� �μ�ID, �μ��� ���
declare 
    cursor dept_cur(cp_loc dept.loc%type) is
        select * 
        from dept
        where loc=cp_loc;
        
        rec_dept dept%rowtype;   --dept�� ��� ������ ��ȸ�����ϵ���.
        
begin
    open dept_cur('New York');
    --LOOP���� �̿��ؼ� fetch�� �Ѵ�. 
    loop
        fetch dept_cur into rec_dept; 
        exit when dept_cur%notfound;   --dept_cur���� �� �̻� ������ ���� ������... EXIT!!!!!!!!!******************************8
        dbms_output.put_line(rec_dept.dept_id || ' '|| rec_dept.dept_name || ' '|| 
                                rec_dept.loc);
    end loop;
    close dept_cur; 
end;
/




/* *********************************************************************************************
FOR ���� �̿��� CURSOR ��� ��ȸ
FOR ���ڵ� IN Ŀ���� [(���ް�1, ���ް�2,..)]
LOOP
    ó�� ����
END LOOP;    

--���� �޸� OPEN �۾��� �ʿ䰡X.\

********************************************************************************************* */
declare
    cursor dept_cur (cp_loc dept.loc%type) is
                    select * from dept 
                    where loc= cp_loc;
begin
    for dept_row in dept_cur('Seattle') --for������ Ŀ���� ����, 
     
    loop
      dbms_output.put_line(dept_row.dept_name || ' '|| dept_row.loc);
    end loop;  --�ݺ��� �����鼭 �ڵ����� CLOSE.
    
    if dept_cur%isopen then --���� Ŀ���� open ���� ��ȸ
        dbms_output.put_line('��������');
    else
        dbms_output.put_line('��������');
    end if;
end;
/

-- TODO: EMP���̺��� Ŀ�̼�(comm_pct)�� NULL�� ������ ID(emp_id), �̸�(emp_name) , �޿�(salary), Ŀ�̼�(comm_pct)�� �̸� ������������ ������ ����� ���


-- TODO: DEPT ���̺��� ��ġ�� 'New York' �� �μ����� �μ�ID, �μ��� ���



DROP TABLE dept_copy;
CREATE TABLE dept_copy AS select * from dept;
-- TODO: EMP ���̺��� salary�� 13000 �̻��� �������� 
--�Ҽӵ� �μ�(DEPT_COPY���̺�)�� loc�� '����'���� �����Ͻÿ�.
declare 
    v_dept_id dept.dept_id%type;
    
    cursor dept_id_cur is
        select dept_id
        from emp
        where salary>=130000;
begin 
    open dept_id_cur;
    
    loop
        fetch dept_id_cur into v_dept_id;   --id�� �� v_dept_id ���� �ȿ� ����
        exit when dept_id_cur%notfound;  --�� �̻� ��ȸ �� ���� ������ �������´�.
        update dept_copy
        set loc='����'
        where dept_id=v_dept_id;
        
    end loop;
    
end;
/
select * from dept_copy;


/* *********************************************************************************************
FOR���� ���� Ŀ���� ���� ����

FOR ���ڵ� IN (SELECT ��)
LOOP
   ó������
END LOOP;
********************************************************************************************* */
begin 
      for d_row in (select * from dept)  --for�� �ȿ����� ����ϴ� Ŀ��!
                                            --������ Ŀ���̸��� ���� ������,.. �Ӽ��� ��ȸ X. **�ܼ� ��ȸ�� ���� ���***
      loop
        dbms_output.put_line(d_row.dept_id|| ' '|| d_row.dept_name);
      --  if d_row.loc ='New York' then
           -- insert into dept_copy values d_row;
       -- end if;
      end loop;
end;
/

-- TODO: ���� ID (job.job_id)�� �޿� �λ��(0~1)�� �Ķ���ͷ� �޾Ƽ� �� ������ ����ϴ� �������� �޿�(emp.salary)�� 
--       ������ max_salary(job.max_salary) * �λ�� ��ŭ �λ�ó���ϴ� stored procdure�� ����.
create or replace procedure job_rate (p_job_id job.job_id%type, 
                                      p_rate binary_double)
is
        v_max_salary job.max_salary%type; --������ max_salary�� ������ ����.
        
        cursor emp_cur is 
            select emp_id
            from emp
            where job_id= p_job_id;
begin
        --max salary 
        select max_salary 
        into v_max_salary
        from job
        where job_id=p_job_id;
        
        --salary �������� 
        for e_row in emp_cur  --�ݺ����� �������鼭 �ϳ��� ������Ʈ���ش�. 
        
        loop
            update emp
            set salary=salary+v_max_salary*p_rate
            where emp_id=e_row.emp_id;
        end loop;
        commit;
end;
/
exec job_rate('AD_PRES',0.2);
select * from emp where job_id='IT_PROG';

-- TODO: EMP���̺��� Ŀ�̼�(comm_pct)�� NULL�� ������ ID(emp_id), �̸�(emp_name) , �޿�(salary), 
--Ŀ�̼�(comm_pct)�� �̸� ������������ ������ ����� ����ϴ� stored Procedure�� ����


-- TODO: DEPT ���̺��� ��ġ�� 'New York' �� �μ����� �μ�ID, �μ��� ���




-- TODO: �⵵�� �Ķ���ͷ� �޾� ���� �Ի��� �������� ID, �̸�, �޿�, �Ի����� ����ϴ� Procedure ����
create or replace procedure EX_06_01 (p_year varchar2)
is

begin
    for e_row in (select emp_id, emp_name, salary, hire_date
                        from emp
                        where to_char(hire_date,'yyyy')=p_year)
    loop
        dbms_output.put_line(e_row.emp_id || ' '|| e_row.emp_name || ' '|| e_row.hire_date);
    end loop;
end;
/

EXEC EX_06_01('2005');
EXEC EX_06_01('2006');


--TODO: �μ��� �̸�(dept.dept_name)�� �Ķ���ͷ� �޾Ƽ� 
--�� �μ��� ���� ������ ID(emp.emp_id), �����̸�(emp.emp_name), 
--�޿�(emup.salary)�� �޿��� ���� ������ ����ϴ� stored Procedure�� ����.  
create or replace procedure EX_06_03 (p_dept_name dept.dept_name%type)
is
    cursor emp_dept_cursor  is
        select e.emp_id, e.emp_name, e.salary
        from emp e, dept d
        where e.dept_id=d.dept_id (+)
        and d.dept_name= p_dept_name;
begin
    for e_row in emp_dept_cursor
    loop
        dbms_output.put_line(e_row.emp_id || ' '|| e_row.emp_name || ' '|| e_row.salary );
    end loop;
end;
/

EXEC EX_06_03('IT');
EXEC EX_06_03('Purchasing');



--TODO: ������  �Ķ���ͷ� �޾Ƽ� �� ���� �̻��� ������ ������
--�μ��� ID(dept.dept_id), �μ��̸�(dept.dept_name)�� ����ϴ� stored Procedure�� ����.

create or replace procedure ex_06_04(p_num binary_integer)
is
    cursor dept_id_cur is
     select dept_id
        from emp
        group by dept_id
        having count(*) > p_num
begin 
        for d_row in dept_id_cur
        loop
            
        end loop;
end;
/

select dept_id, dept_name
from dept
where dept_id in (         --�������� Ŀ��
        select dept_id
        from emp
        group by dept_id
        having count(*) > 3);

EXEC EX_06_04(3);
EXEC EX_06_04(10);


/* **********************************
Ŀ�̼� ���� ���̺�
********************************** */
create table commission_trans(
    emp_id number(6), 
    commission number,
    comm_date date
);
-- TODO: EMP ���̺��� COMM_PCT �� �ִ�(not null) ������ Ŀ�̼�(salary * comm_pct)�� 
--commission_trans ���̺� �����ϴ� stored Procedure�� ����.
-- comm_date�� ���� �Ͻø� �ִ´�.
declare
    --Ŀ�� ����
    cursor emp_cur is
        select emp_id, salary, comm_pct
        from emp
        where comm_pct is not null;
        
begin
    for e_row in emp_cur
    loop
        insert into commission_trans
        values (e_row.emp_id, e_row.salary* e_row.comm_pct, sysdate);
        
    end loop;
    commit;
     
end;
/

SELECT * FROM commission_trans;



