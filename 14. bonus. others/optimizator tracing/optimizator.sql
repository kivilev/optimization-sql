/*
  ����: ����������� SQL
  �����: ������� �.�. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  �����. �����������

  �������� �������: ������ ����������� � ������������ ��� ���������� ����� ��� ������������ ������ ���������� �������
  ������� ������ ����������� ������� ��� alter system flush shared_pool ��� SYS ��� ������ ������������ ���� (�� ������ � ���� �����!)
*/

-- �� ������ � ���� �����!
-- alter system flush shared_pool;

---- ������ 1. ���������� ��������� � ������� departments � ���� ������������� (�������� ����)
-- ���� � ������������ - ORCLCDB_ora_559724_OPT_TRC_1.trc

alter session set events '10053 trace name context forever';
alter session set tracefile_identifier='OPT_TRC_1';

select t.first_name
  from hr.employees t
  join hr.departments d on d.department_id = t.department_id
 where t.first_name like 'Alex%';

alter session set events '10053 trace name context off';

-- � ����� �����: 810 ��� - ���������� join elimination, 942 ��� - ������ ����� �������������, 


---- ������ 2. ���������� ����������, �.�. ������������ ������� department_name
alter session set events '10053 trace name context forever';
alter session set tracefile_identifier='OPT_TRC_2';

select t.first_name, d.department_name
  from hr.employees t
  join hr.departments d on d.department_id = t.department_id
 where t.first_name like 'Alex%';
 
alter session set events '10053 trace name context off';

---- ������ 3. ��������� ������ ������������ ��� ������������� �������
select * from v$sqlarea t where t.sql_text like '%Alex%' order by t.last_load_time desc;
begin
  dbms_sqldiag.dump_trace(p_sql_id       => 'c92qr9wm7utjm',
                          p_child_number => 0,
                          p_component    => 'Optimizer', --Valid values are "Optimizer" and "Compiler"
                          p_file_id      => 'OPT_TRC_1_3');
end;
/

select * from dbms_xplan.display_cursor(sql_id => 'c92qr9wm7utjm', format => 'ALLSTATS ADVANCED LAST');
