/* *********************************************************************************************
PL/SQL ����     --SQL�� �����ϱ� ���� ���α׷��� �����. 
- PL/SQL �̶�
	- Oracle's Procedual Lanague extension to SQL
	- SQL�� Ȯ���Ͽ� SQL�۾��� ������ ���α׷����� �ۼ��� �� �ִ� ���α׷��� ���.
	- �ټ��� SQL���� �ѹ��� ó���� �� �־� �ϳ��� Ʈ���輱 �۾��� �ϳ��� ������� �ۼ��� ���ִ�.
	- ������ �����ϴ�.
	- ����ó���� �����Ѵ�.

********************************************************************************************* */
--�μ��� ���� �հ踦 �����ϴ� ���̺�
create table emp_sum
as
select dept_id,
        sum(salary) salary_sum
from emp
group by dept_id;

select * from emp_sum;

--emp_id�� XXX�� ������ ����
--emp_sum���� �޿� �Ѱ踦 ����.
--sum_salary�� ��ȸ
select * from emp where emp_id=200;
--dept_id=10 , salary:5500 
delete from emp where emp_id=200;   --����
update emp_sum
set salary_sum=salary_sum-5500
where dept_id=10;
rollback;

select * from emp_sum;

set serveroutput on;     --client�ʿ��� �������� ��µǴ� ����� �޾ƺ��ڴٴ� ��!!!!!!!!! -->�������� ��ũ��Ʈ ���â���� �� �� �ִ�. 
--���� ������ �ϳ��� ���ν����� ����
declare
--������ ���� ���� ����..���� ����ٰ� �̸� ����
emp_rec emp%rowtype; 
sum_rec emp_sum%rowtype;
 
begin
 --����ٰ� ������ ���� �ۼ�
 --1: 200�� ������ ���� ��ȸ
 select *
 into emp_rec    --����� ���������� ������ ������ �Ѵ�. 
 from emp
 where emp_id=200;
 
 --2: 200�� ������ ����
 delete from emp where emp_id=200;
 
 --3: �޿��հ� ���̺��� ����(update)
 update emp_sum
 set salary_sum = salary_sum-emp_rec.salary    
where dept_id = emp_rec.dept_id;

--4: �޿��հ����̺��� ���泻�� ��ȸ�ؼ� ���
select *
into sum_rec  --����� �� �������ٰ� �����Ѵ�. 
from emp_sum
where dept_id=emp_rec.dept_id;

--���: �μ� ID: 10,�޿��հ�: 10000
dbms_output.put_line('�μ� ID: ' || sum_rec.dept_id); 
dbms_output.put_line('�޿��հ�: '|| sum_rec.salary_sum); 
end;
/
rollback;
/* ***********************************************************************************************
PL/SQL �⺻ ���           

- ����(DECLARE)
    -  ����, Ŀ��, ��������� ���� �� ����
    -  ���û���
    
- ���౸�����(BEGIN)
    - ȣ��Ǹ� ������ ���� �ۼ�
    - SQL��, PL/SQL ���� ���� ������ �°� ����
    - ���ǹ��̳� �ݺ��� ��밡��
    - �ʼ�
    
- ����ó��(EXCEPTION)
    - ���๮���� �߻��� ������ ó���ϴ� ���� �ۼ�
    - ���๮�� ���൵�� ������ �߻��ϸ� EXCEPTION ���� �̵�
    - ���û���
    
- ����(END;)
    -  PL/SQL ������ ���Ḧ ǥ��
    
- PL/SQL ����
    - �͸� ���ν���
		- �̸� ���� �ۼ��ϴ� PL/SQL ���
		- DATABASE�� ����Ǿ� ���� ���� �ʰ� �ʿ��� ������ �ݺ� �ۼ�, �����Ѵ�.
        
    - ���� ���ν���(Stored Procedure)
		- �̸��� ������ DATABASE�� ����Ǿ� �����ȴ�.
		- �̸����� ȣ���Ͽ� ������ �����ϴ�. **
		- ȣ��� ���� �޾� �� ���� ���ο��� ����� �� �ִ�. 
        
    - �Լ�(Function)
		- ����� ���� �Լ��� ó���� ���� �ݵ�� ��ȯ�ؾ� �Ѵ�.
		- SQL������ ���� ó���ϱ� ���� ȣ���ؼ� ����Ѵ�.
		
*********************************************************************************************** */

-- Hellowordl ����ϴ� PL/SQL
declare   --������ �� ������ �� �κ� �����.

begin 
    dbms_output.put_line('Hello World');
end;
/



-- TODO: ������ ����ϴ� ���� �ۼ��Ͻÿ�.
/*
�̸� : ȫ�浿
���� : 20��
�ּ� : ����� ������ ���ﵿ
*/
--declare   --������ �� ������ �� �κ� �����.

set serveroutput on;
begin 
    dbms_output.put_line('�̸�: ȫ�浿');
    dbms_output.put_line('���� : 20��');
    dbms_output.put_line('�ּ� : ����� ������ ���ﵿ');
end;
/












