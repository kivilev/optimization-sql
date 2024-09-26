drop table del$account;
create table del$account(
  id number(38),
  sum number(38,2),
  calc_date date
);


-- ������� �������
 insert into del$account 
 select level, 10, sysdate
   from dual 
connect by level <= 1000000;

-- ������� � append 
 insert /*+ append*/ into del$account 
 select level, 10, sysdate
   from dual 
connect by level <= 1000000;

--- �������� ��� ������� � �������������� autotrace
set autotrace traceonly statistics;
-- redo size

