/*
 drop table del$account_summary;
 drop index terrorist_birhday_last_name_i;
*/


---- ������ 1. CTAS
create table del$account_summary(
  currency_id,
  sum,
  calc_date
) parallel 4 -- 4 ������ �� ������ � 4 �� ������
as
select currency_id, sum(acc.balance) sum, sysdate calc_date 
  from account acc
  group by acc.currency_id;

-- ������� ������� ������������
select t.degree, t.* from user_tables t where t.table_name = 'DEL$ACCOUNT_SUMMARY';

-- ������ �����������
alter table del$account_summary noparallel;
-- ��������
select t.degree, t.* from user_tables t where t.table_name = 'DEL$ACCOUNT_SUMMARY';



---- ������ 2. �������� �������
-- drop index terrorist_birhday_last_name_i;

-- ������� ������ � ����������
create index terrorist_birhday_last_name_i on terrorist(birthday, last_name) parallel 4; -- 4 ������ �� ������ � 4 �� ������

-- ������� ������� ������������
select t.degree, t.* from user_indexes t where t.index_name = 'TERRORIST_BIRHDAY_LAST_NAME_I';

-- ������� �����������
alter index terrorist_birhday_last_name_i noparallel;
-- ���������
select t.degree, t.* from user_indexes t where t.index_name = 'TERRORIST_BIRHDAY_LAST_NAME_I';


select * from v$parameter t where t.name like '%parallel%' or t.name like '%cpu%';


