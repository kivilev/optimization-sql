/*
  ����: ����������� SQL
  �����: ������� �.�. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  ������ 11. ����������

  �������� �������: ���������� �� ��������
  
*/

---- 1) ���������� �� �������
select t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_statistics t
 where t.table_name = 'EMPLOYEES'
   and t.owner = 'HR';



-- ��� �� ���� ���������� �� ����������
select t.num_rows, t.blocks, t.avg_row_len,
       t.last_analyzed, t.*
  from all_tables t
 where t.table_name = 'EMPLOYEES'
   and t.owner = 'HR';

---- 2) ������������ �� �����������
drop table demo$tab$stat;

-- ������� 1� - ���������� ���������� ����� (Oracle 12c � ����)
create table demo$tab$stat as
select level col1, 'sssss' col2, rpad('�',50,'�') col3
  from dual
connect by level <= 1000000;

-- ���������� �� �������
select sysdate, t.num_rows, t.blocks, t.avg_row_len,
       t.stale_stats, t.last_analyzed, 
       t.sample_size, t.*
  from user_tab_statistics t
 where  t.table_name = 'DEMO$TAB$STAT';
 
-- truncate table DEMO$TAB$STAT;

-- ������� 1� -> ���������� �� ����������.
insert into demo$tab$stat
select level col1, 'sssss' col2, rpad('�',50,'1') col3
  from dual
connect by level <= 1000000;

-- ����� ����� �������
call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEMO$TAB$STAT');

-- ������� 1K �� �������� � ����������� (STALE = NO)
insert into demo$tab$stat
select level col1, 'sssss' col2, rpad('�',50,'1') col3
  from dual
connect by level <= 1000;

-- ������� 100K �������� � ����������� (STALE = YES)
insert into demo$tab$stat
select level col1, 'sssss' col2, rpad('�',50,'1') col3
  from dual
connect by level <= 100000;

-- ������ ��� ������������ ���������� ������ �� ����
-- ���������� ���� ����� ������� -> ������� cardinality
select count(*) cnt from demo$tab$stat;


-- ��� ���������������� ������
select  t.num_rows, t.blocks, t.avg_row_len,
        t.last_analyzed, 
       t.sample_size, t.*
  from all_tab_partitions t
-- where table_owner = 'my_schema'
--   and table_name = 'my_table'
;

select t.* from all_tab_partitions t where t.;

select t.* from all_tab_statistics t where t.partition_name = 'SYS_P1262';

call dbms_stats.gather_table_stats(ownname => user, tabname => 'DEMO_CLIENT_HASH', partname => 'SYS_P1262');


