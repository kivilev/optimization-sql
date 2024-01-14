/*
 �������������� ������ ����������� (HR)
*/ 

---- ������ 1. > 5 ������

-- ��������� ������
select /*my query mon 1*/count(*)
  from hr.employees
  cross join hr.employees
  cross join hr.employees
  cross join hr.employees;

-- �������� SID, SERIAL ������� ������
select sid, serial#
  from v$session
 where sid in (select sid from v$mystat where rownum <=1);

-- ������� � �����������
select key
       ,status, sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'000.00') as elapsed_sec -- exeela
       ,t.*
  from v$sql_monitor t where t.sid = 50 and t.session_serial# = 15381
 order by t.report_id desc;

select * from v$sql_plan_monitor t where t.key =  25769807090;

---- ���������� 4� ������� ������������ �����:

-- ������ 1. �� ������ ���������� ������� ��������� � ���������� (�� ����������� ��� ������)
select dbms_sqltune.report_sql_monitor(report_level => 'all', type => 'HTML') from dual;

-- ������ 2. �� ������ ���������� ������� � ���������� ������ (�� ����������� ��� �������_
select dbms_sqltune.report_sql_monitor(session_id => 50, session_serial => 15381, report_level => 'all', type => 'HTML') from dual;

-- ������ 3. �� ������ ���������� ������� ����������� ������� sql_id (�� ����������� ��� ������)
select t.sql_id, t.sql_text from v$sqlarea t where t.sql_text like '%/*my query mon 1*/%'; -- ������� ��� ������

select dbms_sqltune.report_sql_monitor(sql_id => '9q6jxpvnvk01b', report_level => 'all', type => 'HTML') from dual;

-- ������ 4. ���������� ������ � ���������� ������� ���������� (����� �������� � Detail � PL/SQL Developer)
select sysdate
       ,t.sql_exec_start
       ,sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'00000.00') as elapsed_sec -- exeela
       ,dbms_sqltune.report_sql_monitor(sql_id => t.sql_id, sql_exec_start => t.sql_exec_start, report_level => 'all', type => 'TEXT')
  from v$sql_monitor t
 where t.sid = 50 and t.session_serial# = 15381;
 
 
---- ������ 2. ���� monitoring

-- ��������� ������
select /*my query mon 2*/ /*+ monitor */count(*)
  from hr.employees;

-- ������� � ����������� (����� ��������� �� �����)
select key
       ,status, sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'000.00') as elapsed_sec -- exeela
       ,t.*
  from v$sql_monitor t where t.sid = 50 and t.session_serial# = 15381
 order by t.report_id desc;  



---- ������ 3. Parallel �������

-- �� ������� ��������� ��������, ������������� �����������
select sysdate
       ,t.sql_exec_start
       ,sql_id, t.sql_text
       ,to_char(elapsed_time/1000000,'000.00') as elapsed_sec -- exeela
       ,dbms_sqltune.report_sql_monitor(sql_id => t.sql_id, sql_exec_start => t.sql_exec_start, report_level => 'all', type => 'HTML')
  from v$sql_monitor t
 where t.sid = 50 and t.session_serial# = 15381;
