/*
  ����: ����������� SQL
  �����: ������� �.�. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  ������ 5. ������ � ������ ������

  ��������: ���������
*/
-- drop type t_numbers;


---- �������� ���� ��������� + �������
create type t_numbers is table of number(38);
/

create or replace function get_numbers return t_numbers
is
begin
  return t_numbers(1, 2, 3);
end;
/


---- ������ 1. COLLECTION ITERATOR CONSTRUCTOR FETCH
select * 
  from t_numbers(1, 2, 3);


---- ������ 2. COLLECTION ITERATOR PICKLER FETCH
select * 
  from get_numbers();



---- ������ 3. ������ � �������� ���������������

-- 10 - ���������� �����. ����� �������
select /*+ cardinality(t 10)*/ *
  from t_numbers(1, 2, 3) t;


-- 5 - ������� ����� �� ���� �������
select /*+ dynamic_sampling(t 5)*/ *
  from t_numbers(1, 2, 3) t;
