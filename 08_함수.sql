/* ***************************************************************************************
�Լ� (FUNCTION)
- �̸� �����ϵǾ� ���� ������ ��ü�� SQL�� �Ǵ� PL/SQL�� ������ ȣ��Ǿ� ���Ǵ� �������α׷�.

- ȣ���ڷ� ���� �Ķ���� ���� �Է� �޾� ó���ѵ� �� ����� ȣ���ڿ��� ��ȯ�Ѵ�. 
	- �Ķ���ʹ� �� ���� �� �� �ִ�.
    
- ��Ʈ�� �Լ�
	- ����Ŭ���� �����ϴ� �����Լ�
    
- ����� ���� �Լ��̸�	
	- ����� �����Լ�
	
- ����� ���� �Լ� ����
	CREATE [OR REPLACE] FUNCTION �Լ��̸� [(�Ķ����1, �Ķ����2, ..)]
		RETURN datatype
	IS
		-- �����: ����, ����� ����
	BEGIN
		-- ���� �� : ó������
		RETURN value;
	[EXCETPION]
		-- ����ó�� ��
	END;
	
	
	- RETURN ��ȯ������Ÿ��
		- ȣ���ڿ��� ������ ��ȯ���� Ÿ�� ����
		- char/varchar2 �� number�� ��� size�� �������� �ʴ´�.
		- ���� �ο��� `return ��` ������ �̿��� ó������� ��ȯ�Ѵ�.
	- �Ķ���� 
		- ���� : 0 ~ N��
		- IN ��常 ����. 
		- ����
			������ ������Ÿ�� [:=�⺻��]
		- �⺻���� ���� �Ű��������� ȣ���ڿ��� �ݵ�� ���� �����ؾ� �Ѵ�.
		
	
�Լ� ����
DROP FUNCTION �Լ���;
*************************************************************************************** */

-- �Ű����� ���� �Լ� ���� �� ȣ��



--�Ű������� 1�� �ִ� �Լ�




--�⺻���� �ִ� �Ű������� ���� �Լ�




--�Ű������� �������� �Լ�



  

--  emp_id�� �޾Ƽ� �� ������ Ŀ�̼�(salary * comm_pct)�� ���� ��ȯ�ϴ� �Լ� 





-- TODO: �Ű������� ���� �ΰ��� �޾� ���� ����� �Ҽ��� ���� �κи� ��ȯ�ϴ� �Լ� ���� (ex: 10/4 -> 0.5 ��ȯ)







-- TODO: �Ű������� ���� �ΰ��� �޾Ƽ� ������ ������ ó���ϴ� �Լ� ����.  (10/4 -> 2�� ��ȯ)
-- ���������: --������ - (��� ������ * ����)
-- ex) 10/4�� ������ : 10 - (10/4������� * 4)

      
-- TODO: 1. �Ű������� ��� ID�� �޾Ƽ� �ڽ��� �޿��� �ڽ��� ���� �μ��� ��ձ޿� �̻��̸� TRUE�� �̸��̸� FALSE�� ��ȯ�ϴ� �Լ� �ۼ�. ��ȸ�� ����� ���� ��� NULL�� ��ȯ
--       2. ���� �Լ��� ȣ���ϴ� �͸� ���ν������� �ۼ�.
--			�Լ��� ȣ���Ͽ� ��ȯ�Ǵ� boolean ����
--				TRUE�̸� '������ �޿��� �μ���� �̻�' �� FALSE�̸� '������ �޿��� �μ���� �̸�' �� NULL�̸� '���� ����' �� ����Ѵ�.


CREATE OR REPLACE FUNCTION todo_03_fn(p_emp_id emp.emp_id%TYPE)
    RETURN boolean
IS
    
	
	
BEGIN
	-- salary �� �μ� id�� ��ȸ
	
	-- �μ��� ��� �޿��� ��ȸ
	
	-- ������ salary�� �μ� ��ձ޿��� ���ؼ� boolean ���� ��ȯ
    
	
EXCEPTION
    -- ��ȸ ������ ������ null�� ��ȯ
END;


/
-- 170(�̻�) 180(����) 
-- ------���� �Լ� ����ϴ� ���ν���. ---------
DECLARE
    v_result boolean;
BEGIN
   
   
   
   
END;
/
--Ȯ�� sql��
select salary from emp where emp_id = 170;
select avg(salary) from emp where dept_id = (select dept_id from emp where emp_id = 170);






--TODO �Ű������� 5���� 'y' �Ǵ� 'n'�� �޾Ƽ� 
--���° �Ű������� y������ �ϳ��� ���ڿ��� ��� ��ȯ�ϴ� �Լ� ����.
-- select todo_03_fn('y','n', 'n', 'y', 'y') from dual;  => 1, 4, 5

create or replace function todo_04_fn ( p_yn1 varchar2,
                                         p_yn2 varchar2,
                                         p_yn3 varchar2,
                                         p_yn4 varchar2,
                                         p_yn5 varchar2,) 
    return varchar2
is  
    v_return varchar2(100); -- ������� ���ڿ��� ������ ����.
    
begin  
    
    --p_yn1 ó��: y �̸� v_return ���ڿ��� ����.
    if p_yn = 'y' then 
        if nvl(length(v_return),0)=0  then
            v_return :='1';
        else
            v_return := v_return || '1';
         end if;
    end if;
	
    
    --p_yn2 ó��
        if p_yn = 'y' then 
        if nvl(length(v_return),0)=0  then
            v_return :='2';
        else
            v_return := v_return || ',2';
         end if;
    end if;
	
	
     --p_yn3 ó��
      if nvl(length(v_return),0)=0  then
            v_return :='3';
        else
            v_return := v_return || ',3';
         end if;
    end if;
	
	
     --p_yn4 ó��
	       if nvl(length(v_return),0)=0  then
            v_return :='4';
        else
            v_return := v_return || ',4';
         end if;
    end if;

     --p_yn5 ó��
      if nvl(length(v_return),0)=0  then
            v_return :='5';
        else
            v_return := v_return || ',5';
         end if;
    end if;

    
    -- ����� ��ȯ
    return v_return;

end;
/
select todo_04_fn('y','y', 'n', 'y', 'n') from dual;
select todo_04_fn('n','n', 'n', 'y', 'y') from dual;

create table choice_tb{
    ch1 char check(ch1 in ('y','n'))
};
