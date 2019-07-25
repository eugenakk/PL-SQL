/* **********************************************************
���ǹ�
 - ���ǿ� ���� �����ϴ� ������ �ٸ� ��� ���.
 - IF ���� CASE�� �� �ִ�.

- IF �� ����
    - [������ 1���� ���] 
    IF ���� THEN ó������ END IF;
    
    - [���ΰ�� ������ ����� �� ����]
    IF ���� THEN ó������_1
    ELSE ó������_2
    END IF
    
    - [������ �������� �ܿ�]
    IF ����_1 THEN ó������_1
    ELSIF ����_2 THEN ó������_2
    ELSIF ����_3 THEN ó������_3
    ...
    ELSE ó������_N
    END IF
********************************************************** */    
declare
    v_num1 binary_integer := 20;
    v_num2 binary_integer := 20;    
begin
    if  v_num1 > v_num2 then
        dbms_output.put_line('num1�� ũ��');
    elsif v_num1 = v_num2 then
        dbms_output.put_line('num1�� num2�� ����.');
    else 
        dbms_output.put_line('num2�� ũ��');
    end if;
end;
/


-- TODO : ���� ID�� 110 �� ������ �޿�(salary)�� ��ȸ�� �� 5000 �̸��̸� 
-- 'LOW', 5000�̻� 10000���ϸ� 'MIDDLE', 10000 �ʰ��̸� 'HIGH'�� ����Ѵ�.
declare
    v_salary   emp.salary%type;
    v_grade    varchar2(6); --����� ���� ���� 
begin
    --1. �޿� ��ȸ
    select  salary 
    into    v_salary
    from    emp
    where   emp_id = 110;
    --2. ���
    if  v_salary < 5000 then
        v_grade := 'Low';
    elsif v_salary between 5000 and 10000 then
        v_grade := 'Middle';
    else  
        v_grade := 'High';
    end if;
    dbms_output.put_line ('salary : '||v_salary);
    dbms_output.put_line ('��� : '||v_grade);
end;
/


-- TODO: ���� ID�� 100 �� ������ SALARY�� COMM_PCT�� ��ȸ�Ѵ�. 
--COMM_PCT�� NULL�� �ƴϸ� SALARY + SALARY * COMM_PCT�� ���� ����ϰ� 
--NULL �̸� COMM_PCT�� ������ SALARY�� ����Ѵ�.
--����ID 100�� 145 �θ��� �غ���.
declare
    v_salary    emp.salary%type;
    v_comm_pct  emp.comm_pct%type;
begin
    select  salary, comm_pct
    into    v_salary, v_comm_pct
    from    emp
    where   emp_id = &emp_id;
    
    if  v_comm_pct is not null then
        dbms_output.put_line(v_salary + v_salary*v_comm_pct);
    else
        dbms_output.put_line(v_salary);
    end if;
end;
/
select salary, comm_pct from emp where emp_id=145;

-- TODO: emp_id�� bind������ �޾Ƽ� �� ������ Ŀ�̼��� �ִ��� ��ȸ��(emp.comm_pct) 
--Ŀ�̼��� �ִ� �����̸� commission ���̺� emp_id�� ������� �Ͻÿ� 
--Ŀ�̼�(salary * comm_pct)�� �����Ѵ�.
--Ŀ�̼� ���� ���̺�
create table commission(
    emp_id number(6),
    curr_date date,
    commission number
);

declare
    v_emp_id emp.emp_id%type := :emp_id;
    v_salary emp.salary%type;
    v_comm_pct emp.comm_pct%type;
begin
    select salary, comm_pct
    into  v_salary, v_comm_pct
    from emp 
    where emp_id = v_emp_id;
    
    --comm_pct�� �ְ� salary < 10000�̸�
--    if v_comm_pct is not null then
    if v_comm_pct is not null and v_salary < 1000 then
        insert into commission (emp_id, curr_date, commission)
        values (v_emp_id, sysdate, v_salary * v_comm_pct);
        dbms_output.put_line('Ŀ�̼� ���');
    end if;
    commit;
end;
/
select * from emp where emp_id = 145;
select * from commission;

/* ************************************************************** 
CASE �� : SQL�� CASE ���� (����)����

 [���� 1]
    CASE ǥ����
        WHEN ���1 THEN ó������_1;
        WHEN ���2 THEN ó������_2;
        ...
        ELSE ��Ÿ ó������;
    END CASE;
     
    [���� 2]
    CASE WHEN ǥ����1 THEN ó������_1;
         WHEN ǥ����2 THEN ó������_2;
         ...
         ELSE ��Ÿ ó������;
    END CASE;
************************************************************** */    
declare
    v_num binary_integer := &num;
    v_result varchar2(20);
begin
    case  v_num 
        when 10 then
            v_result := '��';
        when 20 then
            v_result := '�̽�';
        else
            v_result := '��Ÿ';
    end case;
    dbms_output.put_line(v_result);        
end;
/

-- TODO : ���� ID�� 110 �� ������ �޿�(salary)�� ��ȸ�� �� 5000 �̸��̸� 
--'LOW', 5000�̻� 10000���ϸ� 'MIDDLE', 10000 �ʰ��̸� 'HIGH'�� ����Ѵ�.
-- CASE ���� �̿��� �ۼ�
declare
    v_emp_id emp.emp_id%type := &e_id;
    v_salary emp.salary%type;
begin
    select salary
    into v_salary
    from emp
    where emp_id = v_emp_id;
    case 
        when v_salary < 5000 then
            dbms_output.put_line('Low');
        when v_salary between 5000 and 10000 then
            dbms_output.put_line('Middle');
        else
            dbms_output.put_line('High');
    end case;
    dbms_output.put_line(v_salary);
end;
/

/* *********************************************************************************
�ݺ���
 - Ư�� ������ �ݺ��ؼ� �����ϴ� ����
 - LOOP, WHILE, FOR ������ ������ �ִ�.
 - EXIT WHEN ����
	- �ݺ����� ���߰� �������´�.
-  CONTINUE WHEN ����
	- �ݺ����� ���Ϻκ��� �������� �ʰ� ó������ ó������ ���� �����Ѵ�.
 ********************************************************************************* */
 
 /* ************************************************************
    LOOP �� : �ܼ� �ݺ�ó��
    ����
        LOOP
            �ݺ�ó���� ����
            EXIT WHEN ��������
        END LOOP
 ************************************************************ */
-- LOOP ���� �̿��� 0 ~ 10���� �����հ� ���ϱ�
declare
    v_num binary_integer := 1;
    v_result binary_integer :=0; 
begin
    loop
        v_result := v_result + v_num;
        dbms_output.put_line(v_num||' ���� ��� : '||v_result);
        v_num := v_num + 1;   
        exit when v_num = 11;
    end loop;
end;
/


 /* ************************************************************
 WHILE ��: ������ ��(TRUE)�� ���� �ݺ�
 ����
    WHILE �ݺ�����
    LOOP
        ó������
    END LOOP;

************************************************************  */
-- WHILE ���� �̿��� 0 ~ 10���� �����հ�
declare
    v_num binary_integer := 1;
    v_result binary_integer :=0; 
begin
    while v_num != 11 --�ݺ������� ������ ����.
    loop
        v_result := v_result + v_num;
        dbms_output.put_line(v_num||' ���� ��� : '||v_result);
        v_num := v_num + 1;   
    end loop;
end;
/
-- TODO: hello1, hello2, hello3 ... hello10�� ����ϴ� �ڵ带 �ۼ� 
--(LOOP�� WHILE������ �ۼ�)
declare
    v_num binary_integer := 1;
begin
    loop
        dbms_output.put_line('hello'||v_num);
        v_num := v_num + 1;
        exit when v_num = 11;
    end loop;
end;
/
--while
declare
    v_num binary_integer := 1;
begin
    while v_num != 11
    loop
        dbms_output.put_line('hello'||v_num);
        v_num := v_num + 1;
    end loop;
end;
/
-- TODO: sequence t_seq �� ���� 20�� �ɶ� ���� ��ȸ�� ����ϴ� �ڵ带 �ۼ�. 
--(LOOP �� WHILE������ �ۼ�)
drop sequence t_seq;
create sequence t_seq;

declare
    v_num binary_integer:=t_seq.nextval;
begin
    
    while v_num <= 20
    loop
        dbms_output.put_line(v_num);
        v_num := t_seq.nextval;
    end loop;
end;
/
declare
    v_num binary_integer:=t_seq.nextval;
begin
    
    loop
        exit when v_num >= 21;
        dbms_output.put_line(v_num);
        v_num := t_seq.nextval;
    end loop;
end;
/

/* ************************************************************
 FOR ��: ���� Ƚ���� �ݺ��� �� ���
 
 FOR �ε��� IN [REVERSE] �ʱ갪..������
 LOOP
    �ݺ� ó�� ����
 END LOOP;

-- �ε���: �ݺ� �ø��� 1�� �����ϴ� ��. ������ �����ϳ� ������ �ȵȴ�.
-- REVERSE : ������->�ʱ갪

************************************************************ */

-- FOR ����  �̿��� 0 ~ 10���� �����հ�
declare
    v_result binary_integer := 0;
begin
    for i  in reverse 1..10
    loop
        v_result := v_result + i;
        dbms_output.put_line(i);
    end loop;
    dbms_output.put_line('�հ�: '||v_result);    
end;
/

begin
    for e_row in ( select * from emp where dept_id = 60)
    loop
        dbms_output.put_line(e_row.emp_id||e_row.emp_name);
    end loop;
end;
/



-- TODO: hello1, hello2, hello3 ... hello10�� ����ϴ� �ڵ带 �ۼ� (FOR������ �ۼ�)
begin
    for i in 1..10
    loop
        dbms_output.put_line('hello'||i);
    end loop;
end;
/
drop sequence t_seq;
create sequence t_seq;
-- TODO: sequence t_seq �� ���� 20�� �ɶ� ���� ��ȸ�� ����ϴ� �ڵ带 �ۼ�. (FOR������ �ۼ�)
declare
    v_num pls_integer;
begin
    for i in 1..20
    loop
        v_num := t_seq.nextval;
        exit when v_num > 20;
        dbms_output.put_line(v_num);
    end loop;
end;
/

--TODO ������ 5���� ����ϴ� �ڵ带 �ۼ� (loop, for, while���� �ۼ�)
declare
    v_dan pls_integer:=&dan;
begin
    for i in 1..9
    loop
        dbms_output.put_line(v_dan||' X '||i||' = '||(v_dan*i));
    end loop;
end;
/


--TODO 1 ~ 100 ������ ���� �߿� 5�� ����� ����ϵ��� �ۼ�.
--(MOD(A, B): A�� B�� ���� ������ ��ȯ �Լ�)






















