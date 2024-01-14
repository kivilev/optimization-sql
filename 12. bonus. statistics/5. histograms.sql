/*
  ����: ����������� SQL
  �����: ������� �.�. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  ������ 11. ����������

  �������� �������: �����������
  
*/

drop table sale$del;
drop sequence sale$del_pk;

create sequence sale$del_pk;
create table sale$del(
  sale_id      number(38), -- primary key,
  order_date   date not null,
  some_info    varchar2(200 char)
);
create index sale$del_i on sale$del(order_date);

---- ������ 1. ������� � � ��� ����������

-- 1) �������� �������
insert into sale$del
select sale$del_pk.nextval, date'2000-01-01' + level, 'some_info'||level 
  from dual connect by level <= 10000; 
commit;

-- 2) ��������� ���������� �� �������� --> �����, ����� ��� �� ����������
select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

-- 3) ������� ���������� �� ������� -> ����� �� �������� ��������. histogram -> NONE
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR ALL COLUMNS SIZE AUTO'); 

select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

-- 4) ������� 10� ����� �� ���� ����
insert into sale$del
select sale$del_pk.nextval, date'1999-12-31', 'some_info'||level 
  from dual connect by level <= 10000; 
commit;

-- 5) �������� ����� � ������� -> histogram -> NONE, �.�. ��� �� ���� �� ���������� ������ �� ������
call dbms_stats.gather_table_stats (user, 'sale$del');
select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

---- ����� ����� ���� � 2� �������� �� � ����� ���������� ����������?

-- 1 ������
select *
  from sale$del t
 where t.order_date = date'2000-01-02';

-- 10� �����
select count(*)
  from sale$del t
 where t.order_date = date'1999-12-31';
  
/*
-- ���������� ��������� ����� �����
select x.*, c.column_name
  from dba_objects t
  join sys.col_usage$ x on x.obj# = t.object_id
  join dba_tab_cols c on c.owner = t.owner and c.table_name = t.object_name and c.column_id = x.intcol#
where t.owner = 'HR' and t.object_name = 'SALE$DEL';
*/

---- ������ 2. ���� ���������� � ��������� �����

-- ��� �������, � ���� ������� ���������� ������
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR ALL COLUMNS SIZE AUTO'); 
-- ��� �������, � ������ ��������� ���������� ������
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR ALL COLUMNS SIZE 8');
-- ���������� �������, � ���� ������� ���������� ������
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR COLUMNS SALE_ID SIZE AUTO'); 

select *
  from sale$del t
 where t.sale_id = 1;

select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

   
---- ������ 3. ��������, ��� ��� ���������� ������� NDV < N buckets ����� FREQUENCY-�����������
-- 1) ������������ �������

-- 2) ������� 100 �����
insert into sale$del(sale_id,
                     order_date,
                     some_info)
select sale$del_pk.nextval, date'2000-01-01' + level, 'some_info'||level 
  from dual connect by level <= 100; 
commit;

-- 3) �������� ������ � ����
select *
  from sale$del t
 where t.sale_id = 1;

-- 4) ������� ����� � ����������� ������ (254) > ��� ���������� ���������� (100)
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR COLUMNS SALE_ID SIZE 254'); 
   
-- 5) ��������� ��� ����������� �� �������
select t.num_distinct, t.num_buckets, t.histogram, column_name,
       t.*
  from all_tab_col_statistics t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

---- ������ 4. ����������� ��� ����������� �����������
-- 1) ������������ �������

-- 2) �������� ������� 
insert into sale$del
select sale$del_pk.nextval, date'2000-01-01', 'some_info'||level 
  from dual connect by level <= 100; 
commit;

-- 3) �������� ������ � sale_id � ������� �����
select *
  from sale$del t
 where t.sale_id = 1;
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR COLUMNS SALE_ID SIZE 5'); 

-- 4) ��������� ������������� �� �����������
select * 
  from all_tab_histograms t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';

-- 5) ����� ������� 1000 c ���������� ������   
insert into sale$del
select 150, date'2000-01-01', 'some_info'||level 
  from dual connect by level <= 1000; 
commit;   

-- 6) ������� � �������� -> ����������� �������������
call dbms_stats.gather_table_stats (user, 'sale$del', method_opt => 'FOR COLUMNS SALE_ID SIZE 5'); 
select * 
  from all_tab_histograms t
 where t.table_name = 'SALE$DEL'
   and t.owner = 'HR';
