alter session set statistics_level = all; -- ���������� ��� �������
alter session set timed_statistics = true; -- ���������� ���������� ��� �����������
alter session set tracefile_identifier = 'MON_TRC_01'; -- ����� ��� ��������������� �����
alter session set events '10046 trace name context forever, level 8'; -- waits + bind vars

select /*+ monitor use_nl(ser num) leading(ser num)*/ count(*)
  from client_data ser
  join client_data num
    on num.client_id = ser.client_id
   and num.field_value = 'FENXEOVELUCNGESNMJSE'
   and num.field_id = 5
 where ser.field_value = 'PPBZ'
   and ser.field_id = 4;

alter session set events '10046 trace name context off';


select dbms_sqltune.report_sql_monitor(sql_id => '3g2fz9g3dvhz3', report_level => 'all', type => 'HTML') from dual;
select dbms_sql_monitor.report_sql_monitor(sql_id => '3g2fz9g3dvhz3', report_level => 'all', type => 'ACTIVE') from dual;
select dbms_sql_monitor.report_sql_monitor(sql_id => '3g2fz9g3dvhz3', report_level => 'all', type => 'TEXT') from dual;
-- call flush_all()


select * from v

