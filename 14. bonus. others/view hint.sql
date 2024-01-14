/*
  ���� ������������� ������ �� view
*/

---- ������ 1. ����� �� view ����� ������ 
-- ��������, ����� ��� �������� ������ ��������
create or replace view del$view1 as
select e.last_name, e.department_id, d.location_id
  from hr.employees e
  join departments d
    on e.department_id = d.department_id;

-- ��� ������
explain plan for
select t.* 
  from del$view1 t;

select * from dbms_xplan.display(format => 'ADVANCED');

-- � �������
explain plan for
select /*+ use_hash(t.e t.d) leading(t.d t.e) FULL(t.e) */ t.* 
  from del$view1 t;
select * from dbms_xplan.display(format => 'ADVANCED');


---- ������ 2. ����� �� view (����� QB_NAME)

-- ����� ������ ���������� �� ��������, �.�. ���� ������ �������
explain plan for
select /*+ use_hash(t.e t.d) leading(t.d t.e) FULL(t.e) */ * 
  from del$view1 t
  join locations loc on loc.location_id = t.location_id;
select * from dbms_xplan.display(format => 'ADVANCED');


-- �������� �� ���������� ����� object_alias (����� ����� ide ���������), �������
explain plan for
select /*+ USE_HASH(E@SEL$2 D@SEL$2) LEADING(E@SEL$2 D@SEL$2) FULL(E@SEL$2) FULL(D@SEL$2)*/ * 
  from del$view1 t
  join locations loc on loc.location_id = t.location_id;
select * from dbms_xplan.display(format => 'ADVANCED');




