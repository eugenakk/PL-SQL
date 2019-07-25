/* *********************************************************************
���ν���
 - Ư�� ������ ó���ϴ� ���밡���� ���� ���α׷�
 - �ۼ��� ����Ǹ� ������ �Ǿ� ��ü�� ����Ŭ�� ����Ǹ� EXECUTE�� EXEC ��ɾ�� �ʿ�ø��� ���밡��
����
CREATE [OR REPLACE] PROCEDURE �̸� [(�Ķ���� ����,..)]
IS
    [���� ����]
BEGIN
    ���౸��
[EXCEPTION
    ����ó������]
END;

- �Ķ���� ����
  - ���� ���� ����
  - ���� : ������ mode Ÿ�� [:=�ʱⰪ]
    - mode
      - IN : �⺻. ȣ���ϴ� ������ ���� ���� ���� �޾� ���ν��� ������ ���. �б� ���뺯��. 
      - OUT : ȣ�� �ϴ� ������ ������ ���� ������ ����. 
      - IN OUT : IN�� OUT�� ����� ��� �ϴ� ����
	- Ÿ�Կ� size�� �������� �ʴ´�. 
	- �ʱⰪ�� ���� �Ű������� ȣ��� �ݵ�� ���� ���޵Ǿ� �Ѵ�.

����
exec �̸�[(���ް�)]
execute �̸�[(���ް�)]

���ν��� ����
- DROP PROCEDURE ���ν����̸�

*********************************************************************** */
set serveroutput on;
create or replace procedure message_sp1
is
    --��������
    v_message varchar2(100);
begin
    --���౸��
    v_message := 'HelloWorld';
    dbms_output.put_line(v_message);
end;
/
--control-enter: ����Ŭ ������ ����

--����
execute message_sp1;
exec message_sp1;

create or replace procedure message_sp2(p_message in varchar2:='HelloWorld') 
is  
    v_message varchar2(100);
begin
    -- in ��� �Ķ���ʹ� �� ������ �ȵȴ�. �׳� ��븸 �ؾ��Ѵ�********
    dbms_output.put_line(p_message); 
    v_message:= p_message;
    dbms_output.put_line(v_message); 
    v_message :='�� �޽���';
    dbms_output.put_line(v_message); 
end;
/


exec message_sp2('�ȳ��ϼ���')
exec message_sp2('Hi')
exec message_sp2


create or replace procedure message_sp3(p_message in varchar2, 
                                        p_num pls_integer)
is
begin
    dbms_output.put_line(p_message||p_num);
end;
/

exec message_sp3('�ȳ��ϼ���', 20);
 --out: ��ȯ���� ������ ������ �޴´�.
 
create or replace procedure message_sp4(p_message out varchar2)
is    
begin
    dbms_output.put_line(p_message);
    p_message := 'message_sp4������ �޼���';
end;
/
create or replace procedure message_sp5(p_message in out varchar2)
is    
begin
    dbms_output.put_line(p_message);
    p_message := 'message_sp4������ �޼���';
end;
/

create or replace procedure caller_sp
is
    v_msg varchar2(100);
begin
   --message_sp4 �� ȣ�� - �޼����� ��ȯ�ϴ� sp
   v_msg:='�⺻��';
   message_sp4(v_msg);
   dbms_output.put_line(v_msg);
   
end;
/

exec caller_sp;

--�Ű������� �μ�ID, �μ��̸�, ��ġ�� �޾� DEPT�� �μ��� �߰��ϴ� Stored Procedure �ۼ�
create or replace procedure add_dept(p_dept_id dept.dept_id%type,
                                     p_dept_name dept.dept_name%type,
                                    p_loc dept.loc%type)
is                                         --dept���̺� �ִ� dept_id�� type�� ����ϰڴٴ� ��
    
begin
        insert into dept values (p_dept_id, p_dept_name, p_loc);  --3���� insert ���ִ� ��!!!
        commit;
end;
/

exec add_dept(3332,'��ȹ��2','����');

select * from dept order by 1 desc;   --���Ե� ���� Ȯ���� �� �ִ�. 


--�Ű������� �μ�ID�� �Ķ���ͷ�  �޾� ��ȸ�ϴ� Stored Procedure
create or replace procedure find_dept_sp(p_dept_id dept.dept_id%type)
is
    v_dept_id dept.dept_id%type;        --������ �÷��� ����Ǵ� �����ϱ� type���
    v_dept_name dept.dept_name%type;       --������ �̸��� �÷� �̸� �ٸ��� �ϴ� ���� ����.
    v_loc dept.loc%type;
begin
    select dept_id, dept_name, loc
    into v_dept_id, v_dept_name, v_loc
    from dept
    where dept_id=p_dept_id;    --�Ű������� ���� �־��ش�. 
    
    dbms_output.put_line(v_dept_id);
end;
/

-- TODO ������ ID�� �Ķ���ͷ�  �޾Ƽ� ������ �̸�(emp.emp_name), �޿�(emp.salary), ����_ID (emp.job_id), �Ի���(emp.hire_date)�� 
--����ϴ� Stored Procedure �� ����
create or replace procedure print_emp (e_emp_id in emp.emp_id%type) --default�� IN����̹Ƿ� ���� ����.
is                                        
     e_emp_name emp.emp_name%type;       
     e_salary emp.salary%type;       
     e_job_id emp.job_id%type;
     e_hire_date emp.hire_date%type; 
    
begin
    select emp_name, salary, job_id, hire_date
    into e_emp_name, e_salary, e_job_id, e_hire_date
    from emp
    where emp_id=e_emp_id;   --�Ű������� ���� �־��ش�. 
    
    dbms_output.put_line(e_emp_name || ' ' || e_salary || ' ' || e_job_id || ' ' || e_hire_date);
end;
/
execute print_emp(100);
execute print_emp(110);


-- TODO ����_ID(job.job_id)�� �Ķ���ͷ� �޾Ƽ� ������(job.job_title)�� �����ִ�/�ּ� �޿�(job.max_salary, min_salary)
--�� ����ϴ� Stored Procedure �� ����
create or replace procedure print_job (j_job_id job.job_id%type)
is                                        
     j_job_title job.job_title%type;       
     j_max_salary job.max_salary%type;       
     j_min_salary job.min_salary%type;
    
begin
    select job_title, max_salary, min_salary
    into j_job_title, j_max_salary, j_min_salary
    from job
    where job_id=j_job_id;   --�Ű������� ���� �־��ش�. 
    
    dbms_output.put_line(j_job_title|| ' '|| j_max_salary|| ' '|| j_min_salary);
end;
/
EXEC print_job('FI_ACCOUNT');
EXEC print_job('IT_PROG');


-- TODO: ����_ID�� �Ķ���ͷ� �޾Ƽ� ������ �̸�(emp.emp_name), ���� ID(emp.job_id), ������(job.job_title) ����ϴ�
--Stored Procedure �� ����
create or replace procedure print_emp_job (e_emp_id emp.emp_id%type)
is                                        
     e_emp_name emp.emp_name%type;       
    e_job_id emp.job_id%type;       
     j_job_title job.job_title%type;
    
begin
    select e.emp_name, e.job_id, j.job_title
    into e_emp_name, e_job_id, j_job_title
    from emp e, job j
    where e.job_id=j.job_id
    and emp_id=e_emp_id;   --�Ű������� ���� �־��ش�. 
    
    dbms_output.put_line(e_emp_name|| ' '|| e_job_id|| ' '|| j_job_title);
end;
/
EXEC print_emp_job(110);
EXEC print_emp_job(200);


-- TODO ������ ID�� �Ķ���ͷ� �޾Ƽ� ������ �̸�(emp.emp_name), �޿�(emp.salary), �ҼӺμ��̸�(dept.dept_name), �μ���ġ(dept.loc)��
--����ϴ� Stored Procedure �� ����
create or replace procedure print_emp_dept (e_emp_id emp.emp_id%type)
is                                        
     e_emp_name emp.emp_name%type;       
    e_salary emp.salary%type;       
     d_dept_name dept.dept_name%type;
     d_loc dept.loc%type;
    
begin
    select e.emp_name, e.salary, d.dept_name, d.loc
    into e_emp_name, e_salary, d_dept_name, d_loc
    from emp e, dept d
    where e.dept_id=d.dept_id
    and emp_id=e_emp_id;   --�Ű������� ���� �־��ش�. 
    
    dbms_output.put_line(e_emp_name || ' '||e_salary|| ' '|| d_dept_name|| ' '|| d_loc);
end;
/
EXEC print_emp_dept(100);
EXEC print_emp_dept(120);



-- TODO ������ ID�� �Ķ���ͷ� �޾Ƽ� �� ������ �̸�(emp.emp_name), �޿�(emp.salary), ������ �ִ�޿�(job.max_salary), 
--������ �ּұ޿�(job.min_salary), ������ �޿����(salary_grade.grade)�� ����ϴ� store procedure�� ����
create or replace procedure print_emp_job_sal (e_emp_id emp.emp_id%type)
is                                        
    e_emp_name emp.emp_name%type;       
    e_salary emp.salary%type;       
     j_max_salary job.max_salary%type;
    j_min_salary job.min_salary%type;
    sg_grade salary_grade.grade%type;
    
begin
    select e.emp_name, e.salary, j.max_salary, j.min_salary, sg.grade
    into e_emp_name, e_salary, j_max_salary, j_min_salary, sg_grade
    from emp e, job j, salary_grade sg
    where e.job_id=j.job_id
    and  e.salary between sg.low_sal and sg.high_sal
    and emp_id=e_emp_id;   --�Ű������� ���� �־��ش�. 
    
    dbms_output.put_line(e_emp_name || ' '||e_salary|| ' '|| j_max_salary || ' '||j_min_salary || ' '|| sg_grade);
end;
/
EXEC print_emp_job_sal(100);
EXEC print_emp_job_sal(120);


-- TODO: ������ ID(emp.emp_id)�� �Ķ���ͷ� �޾Ƽ� �޿�(salary)�� ��ȸ�� ��
--�޿��� �޿������ ����ϴ� Stored Procedure �� ����.
-- �����޿� ��� ����:  �޿��� $5000 �̸� �̸� LOW, $5000 ~ $10000 �̸� MIDDLE, $10000 �ʰ��� HIGH�� ���
create or replace procedure print_1234 (e_emp_id  in emp.emp_id%type)
is                                        
     e_salary emp.salary%type;
    sg_grade salary_grade.grade%type;
    
begin
    select e.salary, sg_grade
    into e_salary, sg_grade
    from emp e, salary_grade sg
    where e.salary between sg.low_sal and sg.high_sal
    and emp_id=e_emp_id;   --�Ű������� ���� �־��ش�. 
    
   if  e_salary<5000 then
        dbms_output.put_line('LOW');
    elsif e_salary between 5000 and 10000 then
        dbms_output.put_line('MIDDLE.');
    else 
        dbms_output.put_line('HIGH');
    end if;
end; 
/

exec print_1234(100);
exec print_1234(130);






