# PL-SQL

SQL 을 확장한 절차적 언어.
 PL/SQL (Procedural Language extension to SQL)



 - SQL을 확장한 절차적 언어(Procedural Language)이다. 

 - 관계형 데이터베이스에서 사용되는 Oracle의 표준 데이터 엑세스 언어로, 프로시저 생성자를 SQL과 완벽하게 통합한다.

 - 유저 프로세스가 PL/SQL 블록을 보내면, 서버 프로세서는 PL/SQL Engine에서 해당 블록을 받고 

    SQL과 Procedural를 나눠서 SQL은 SQL Statement Executer로 보낸다.

 - PL/SQL 프로그램의 종류는 크게 Procedure, Function, Trigger 로 나뉘어 진다.

 - 오라클에서 지원하는 프로그래밍 언어의 특성을 수용하여 SQL에서는 사용할수없는 절차적 프로그래밍 기능을 가지고 있어 SQL의 단점을 보완하였다.



▶ 장점

 - 프로시저 생성자와 SQL의 통합

 - 성능 향상 : 잘 만들어진 PL/SQL 명령문이라는 가정하에 좋아진다.

 - 모듈식 프로그램 개발 가능 : 논리적인 작업 을 진행하는 여러 명령어들을 하나의 블록을 만들 수 있다.

 - 이식성이 좋다

 - 예외 처리 가능



▶ 기본 특징

 - 블록 단위의 실행을 제공한다. 이를 위해 BEGIN과 END;를 사용한다. 그리고 마지막 라인에 /를 입력하면 해당 블록이 실행된다.

 - 변수, 상수 등을 선언하여 SQL과 절차형 언어에서 사용

 - 변수의 선언은 DECLARE절에서만 가능하다. 그리고 BEGIN 섹션에서 새 값이 할당될 수 있다.

 - IF문을 사용하여 조건에 따라 문장들을 분기 가능

 - LOOP문을 사용하여 일련의 문장을 반복 가능

 - 커서를 사용하여 여러 행을 검색 및 처리

 - [ PL/SQL에서 사용 가능한 SQL은 Query, DML, TCL이다. ]

    DDL (CREATE, DROP, ALTER, TRUNCATE …), DCL (GRANT, REVOKE) 명령어는 동적 SQL을 이용할 때만 사용 가능하다.

 - [ PL/SQL의 SELECT문은 해당 SELECT의 결과를 PL/SQL Engine으로 보낸다. ]

  
