/* ***************************************************************************************
함수 (FUNCTION)
- 미리 컴파일되어 재사용 가능한 객체로 SQL문 또는 PL/SQL문 내에서 호출되어 사용되는 서브프로그램.

- 호출자로 부터 파라미터 값을 입력 받아 처리한뒤 그 결과를 호출자에게 반환한다. 
	- 파라미터는 안 받을 수 도 있다.
    
- 빌트인 함수
	- 오라클에서 제공하는 내장함수
    
- 사용자 정의 함수이름	
	- 사용자 정의함수
	
- 사용자 정의 함수 구문
	CREATE [OR REPLACE] FUNCTION 함수이름 [(파라미터1, 파라미터2, ..)]
		RETURN datatype
	IS
		-- 선언부: 변수, 상수등 선언
	BEGIN
		-- 실행 부 : 처리구문
		RETURN value;
	[EXCETPION]
		-- 예외처리 부
	END;
	
	
	- RETURN 반환데이터타입
		- 호출자에게 전달할 반환값의 타입 지정
		- char/varchar2 나 number일 경우 size는 지정하지 않는다.
		- 실행 부에서 `return 값` 구문을 이용해 처리결과를 반환한다.
	- 파라미터 
		- 개수 : 0 ~ N개
		- IN 모드만 가능. 
		- 구문
			변수명 데이터타입 [:=기본값]
		- 기본값이 없는 매개변수에는 호출자에서 반드시 값을 전달해야 한다.
		
	
함수 제거
DROP FUNCTION 함수명;
*************************************************************************************** */

-- 매개변수 없는 함수 생성 및 호출



--매개변수가 1개 있는 함수




--기본값이 있는 매개변수를 가진 함수




--매개변수가 여러개인 함수



  

--  emp_id를 받아서 그 직원의 커미션(salary * comm_pct)의 값을 반환하는 함수 





-- TODO: 매개변수로 정수 두개를 받아 나눈 결과의 소숫점 이하 부분만 반환하는 함수 구현 (ex: 10/4 -> 0.5 반환)







-- TODO: 매개변수로 정수 두개를 받아서 나머지 연산을 처리하는 함수 구현.  (10/4 -> 2를 반환)
-- 나머지계산: --피젯수 - (결과 정수값 * 제수)
-- ex) 10/4의 나머지 : 10 - (10/4결과정수 * 4)

      
-- TODO: 1. 매개변수로 사원 ID를 받아서 자신의 급여가 자신이 속한 부서의 평균급여 이상이면 TRUE를 미만이면 FALSE를 반환하는 함수 작성. 조회한 사원이 없는 경우 NULL을 반환
--       2. 위의 함수를 호출하는 익명 프로시저에서 작성.
--			함수를 호출하여 반환되는 boolean 값이
--				TRUE이면 '직원의 급여가 부서평균 이상' 을 FALSE이면 '직원의 급여가 부서평균 미만' 을 NULL이면 '없는 직원' 을 출력한다.


CREATE OR REPLACE FUNCTION todo_03_fn(p_emp_id emp.emp_id%TYPE)
    RETURN boolean
IS
    
	
	
BEGIN
	-- salary 와 부서 id를 조회
	
	-- 부서의 평균 급여를 조회
	
	-- 직원의 salary와 부서 평균급여를 비교해서 boolean 값을 반환
    
	
EXCEPTION
    -- 조회 직원이 없으면 null을 반환
END;


/
-- 170(이상) 180(이하) 
-- ------위의 함수 사용하는 프로시저. ---------
DECLARE
    v_result boolean;
BEGIN
   
   
   
   
END;
/
--확인 sql문
select salary from emp where emp_id = 170;
select avg(salary) from emp where dept_id = (select dept_id from emp where emp_id = 170);






--TODO 매개변수로 5개의 'y' 또는 'n'을 받아서 
--몇번째 매개변수가 y인지를 하나의 문자열로 묶어서 반환하는 함수 구현.
-- select todo_03_fn('y','n', 'n', 'y', 'y') from dual;  => 1, 4, 5

create or replace function todo_04_fn ( p_yn1 varchar2,
                                         p_yn2 varchar2,
                                         p_yn3 varchar2,
                                         p_yn4 varchar2,
                                         p_yn5 varchar2,) 
    return varchar2
is  
    v_return varchar2(100); -- 최종결과 문자열을 저장할 변수.
    
begin  
    
    --p_yn1 처리: y 이면 v_return 문자열에 연결.
    if p_yn = 'y' then 
        if nvl(length(v_return),0)=0  then
            v_return :='1';
        else
            v_return := v_return || '1';
         end if;
    end if;
	
    
    --p_yn2 처리
        if p_yn = 'y' then 
        if nvl(length(v_return),0)=0  then
            v_return :='2';
        else
            v_return := v_return || ',2';
         end if;
    end if;
	
	
     --p_yn3 처리
      if nvl(length(v_return),0)=0  then
            v_return :='3';
        else
            v_return := v_return || ',3';
         end if;
    end if;
	
	
     --p_yn4 처리
	       if nvl(length(v_return),0)=0  then
            v_return :='4';
        else
            v_return := v_return || ',4';
         end if;
    end if;

     --p_yn5 처리
      if nvl(length(v_return),0)=0  then
            v_return :='5';
        else
            v_return := v_return || ',5';
         end if;
    end if;

    
    -- 결과값 반환
    return v_return;

end;
/
select todo_04_fn('y','y', 'n', 'y', 'n') from dual;
select todo_04_fn('n','n', 'n', 'y', 'y') from dual;

create table choice_tb{
    ch1 char check(ch1 in ('y','n'))
};
