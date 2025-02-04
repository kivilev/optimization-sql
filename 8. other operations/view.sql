/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция: Другие операции оптимизатора
  
  Описание скрипта: view 
   
*/

---- Пример 1. Создано view (запрос не переписывается)
create or replace view v_employees as
select t.department_id, t.manager_id
  from hr.employees t
 group by t.department_id, t.manager_id;

  
select d.*
      ,e.manager_id
  from v_employees    e
      ,hr.departments d

---- Пример 2. Обертка запроса в with (запрос не переписывается)
with emp as (
  select t.department_id, t.manager_id
    from hr.employees t
   group by t.department_id, t.manager_id
)  
select d.*
      ,e.manager_id
  from emp    e
      ,hr.departments d;
      

---- Пример 3. Подзапрос (запрос не переписывается)
select d.*
      ,e.manager_id
  from (select t.department_id
              ,t.manager_id
          from hr.employees t
         group by t.department_id
                 ,t.manager_id) e
      ,hr.departments d;


---- Пример 4. Запрос переписывается и view в плане запроса нет
select d.*
      ,e.manager_id
  from hr.departments d
  join v_employees    e on d.department_id = e.department_id;


