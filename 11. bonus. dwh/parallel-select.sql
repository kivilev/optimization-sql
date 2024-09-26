
---- ������ �������
select /*+ parallel(4)*/ count(*) 
  from account;

explain plan for
select /*+ parallel(4)*/ count(*) 
  from account;  
select * from dbms_xplan.display();

-- ��������� ������� ������������� DOP (������� ������������)
explain plan for
select /*+ parallel*/ count(*) 
  from account;  
select * from dbms_xplan.display();
