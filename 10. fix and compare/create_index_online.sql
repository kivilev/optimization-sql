﻿
-- drop table del$1;
create table del$1(
  id number(30),
  col1 varchar2(300 char),
  constraint del$1_pk primary key (id)
);

insert /*+ append */ into del$1
select level, lpad(level, 200, '_') from dual connect by level <= 100000;
commit;


select * from del$1 where col1 = 'some_value';


-- вставка без commit
insert into del$1 values (100001, 'some_value');

-- попытка создать индекс в другой сессии приведет к этому:
-- ORA-00054: resource busy and acquire with NOWAIT specified or timeout expired
create index del$1_col1_i on del$1(col1);


-- c опицей online ошибки не будет, сессия создания подвиснет, но в целом - ок

