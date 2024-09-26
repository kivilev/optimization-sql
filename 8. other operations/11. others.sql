/*
  ����: ����������� SQL
  �����: ������� �.�. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  ������ 8. ������ �������� �����������
  
  �������� �������: ������
*/

---- ������ 1. Load as select (�������� �������)
create table ddd as
select * from dual;


---- ������ 2. ������������� �������
 select * 
   from dual e 
connect by level <= 10;

select * 
   from hr.employees e 
connect by e.employee_id = e.manager_id
 start with e.employee_id = 100;
 

---- ������ 3. ������������� �������
grant create materialized view to hr;

create materialized view mv_employees_agg
build immediate
enable query rewrite
as
select t.department_id, count(*)
  from hr.employees t 
 group by t.department_id;

select t.department_id, count(*)
  from hr.employees t 
 group by t.department_id; 



---- ������ 4. INSERT/UPDATE/SELECT STATEMENT
insert into hr.departments
values (1, '111', 1, 2);

update hr.departments t set t.department_name = 'sdf'
 where t.department_id = 1;

select * from dual;

delete from hr.employees where 1 = 0;


---- ������ 5. �������������� ����������
with t as (
select /*+ materialize */ * 
  from employees
)
select * from t;


---- ������ 6. ���������� ����������� - STATISTICS COLLECTOR

select e.*, d.department_name
  from hr.employees   e
      ,hr.departments d
 where e.department_id = d.department_id
   and d.department_name in ('Marketing', 'Sales');

---- ������ 7. Concatination ��� Union-all
select *
  from hr.employees e   
 where e.employee_id >= 180
    or e.last_name = 'Smith'

---- ������ 8. Parallel �������
select /*+ parallel(4) */ count(*) from payment;

-- call flush_all();
