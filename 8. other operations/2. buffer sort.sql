﻿/*
  Курс: Оптимизация SQL
  Автор: Кивилев Д.С. (https://t.me/oracle_dbd, https://oracle-dbd.ru, https://www.youtube.com/c/OracleDBD)

  Лекция 8. Другие операции оптимизатор
  
  Описание скрипта: buffer sort
   
*/

select e.employee_id
      ,d.department_id
  from hr.employees e
      ,hr.departments d
