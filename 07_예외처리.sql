

/* ***************************************************************************************************************
����ó��
 - ���๮���� �߻��� ����(����)�� ó���Ͽ� ���ν����� ���������� �����ϵ��� �ϴ� ����.
 - ���� ����
	- ����Ŭ ����
		- �ڵ尡 Ʋ���� �߻��ϴ� ����
	- ����� ���� 
		- ����� �ڵ忡�� �߻���Ų ����.
		- ���� ��Ģ�� ��� ��� �߻���Ų��.
        
- EXCEPTION ���� ó�� ������ �ۼ�
	- ���� �� ������ �ۼ��Ѵ�.
 - ����
  EXCEPTION
    WHEN �����̸�1 THEN
        ó������
    WHEN �����̸�2 THEN
        ó������
	[WHEN OTHERS THEN
		ó������ ]
 
*************************************************************************************************************** */

--����Ŭ �����ڵ� ��ȸ: https://docs.oracle.com/pls/db92/db92.error_search?remark=homepage&prefill=ORA

set serveroutput on;
 -- ���⼭ ������ ����. -->���� ó���� ���ش�. 
declare
    v_emp_name emp.emp_name%type;
    v_cnt binary_integer; 
    
begin
    v_cnt :=10/0;

    select emp_name   
    into v_emp_name 
    from emp;
    
    dbms_output.put_line(v_emp_name);
exception   
    when too_many_rows then    --����ó��**************** 
        dbms_output.put_line('�ʹ� ���� ���� ��ȸ�Ǿ���'); 
    when zero_divide then
         dbms_output.put_line('0���� ���� �� ����'); 
    when others then
        dbms_output.put_line('������ ���� ���� ó��');
    
end;
/


/* ***************************************************************************************************************
- ����Ŭ ������ ���ܸ� ����

- ���ܸ��� ���ǵ��� ���� ����Ŭ ����
    - �����ڵ�� ������ �����̸��� ���� ����Ŭ ���� ����

 - ����
 1. �����̸� ����
    �����̸� EXCEPTION;
 2. �����̸��� ����Ŭ�����ڵ� ����
    PRAGMA EXCEPTION_INIT (�����̸�, �����ڵ�) 
    - �����ڵ�� ������ ���δ�. (-01400)
*************************************************************************************************************** */
-- �̸� ���ǵ��� ���� ���� �̸� ���̱� (null �� INSERT �߻� ������ �̸� ���̱�)
desc dept;

declare
    --1: ����( exception) �̸� ���� 
    ex_null exception; 
    
    --2: 1���� ������ �����̸��� ����Ŭ �����ڵ带 ����.
    pragma exception_init(ex_null, -01400); 
    
  
begin
    insert into dept values (850, null, null);  --ORA-01400 ������ �߻��ϸ� ex_null�̶� �̸����� ���� ó���Ѵ�. 

exception 
    when ex_null then
        dbms_output.put_line('NULL�� ���� �� �����ϴ�. ');
end;
/

--TODO: �μ����̺���(DEPT) �μ�_ID�� 100�� �μ��� �����ϴ� �ڵ� �ۼ�.
--      100�� �μ��� EMP���� �����ϹǷ� 'ORA-02292: integrity constraint (SCOTT.FK_EMP_DEPT) violated - child record found' ����Ŭ ���� �߻��Ѵ�.
--      �߻��ϴ� ������ �����̸��� ����� EXCEPTION ��Ͽ��� ó���ϴ� �ڵ带 �ۼ��Ͻÿ�.

declare
    ex_null2 exception; 
    
    pragma exception_init(ex_null2, -02292);
begin
        delete 
        from dept
        where dept_id=100;
exception 
    when ex_null2 then
    dbms_output.put_line('EMP���� �����ϹǷ� ������ ���� �ʴ´�!!');
end;
/

/* ***************************************************************************************************************
���� �߻���Ű��

 1. ���� �̸� ����

 2. RAISE �����̸�
*************************************************************************************************************** */
--������ �μ� ID�� ������ ���� �߻���Ű��
declare
    v_id binary_integer=143;
    v_cnt binary_integer;
    
    ex_not_found exception ;   --���� ����*
begin
    select count(*) 
    into v_cnt
    from dept
    where dept_id=v_id;
    
    if v_cnt=0 then  --������ �μ��� ���� ��.
        raise ex_not_found;
    end if;
    
    delete 
    from dept 
    where dept_id=v_id;
    dbms_output.put_line('���� �Ϸ�');  --���� �ִ��� ������ ��.
    
exception 
    when ex_not_found then
        dbms_output.put_line('������ ���� �����ϴ�.');
end;
/


--TODO: EMP_ID�� 832���� ������ �̸��� UPDATE�ϴµ� 832���� ������ ���� ��� ����� ���� ���ܸ� ����� �߻� ��Ű�ÿ�.

declare
    v_id emp.emp_id%type;
    id_not_found exception;
begin
    update emp.
    in v_id
    set emp_id=v_id;
    
    if  v_id is null then
        raise id_not_found;
    end if;
        
        
exception id_not_found then
    dbms_output.put_line('ID�� 823�� ������ �����ϴ�.');
end;
/

--TODO: �μ� ID�� �޾� �μ��� �����ϴ� ���ν��� �ۼ�
--      EMP ���̺��� �����Ϸ��� �μ��� �����ϴ� ���� �ִ��� Ȯ�� �ѵ� ������ �����ϰ� ������ ��������� ���ܸ� �߻���Ų �� EXCEPTION ��Ͽ��� ó��



/* ****************************************************************************************************************************************************
RAISE_APPLICATION_ERROR
���� ���� ���� ���� �ڵ�� ���ܸ޼����� �޾� ���ܸ� �߻���Ű�� ���ν���
 - RAISE_APPLICATION_ERROR(�����ڵ�, ���� �޼���)
    - �����ڵ�� -20000 ~ -20999 ������ ���ڸ� ����Ѵ�. 
**************************************************************************************************************************************************** */



--TODO: �μ� ID�� �޾� �μ��� �����ϴ� ���ν��� �ۼ�
--      EMP ���̺��� �����Ϸ��� �μ��� �����ϴ� ���� �ִ��� Ȯ�� �� �� ������ �����ϰ� ������ �����ڵ� -20100 ���� ������ �޼����� �־� ����� ���� ���ܸ� �߻���Ų�� EXCEPTION ������ ó��.



