/*
 drop table del$source;
 drop table del$target1;
 drop table del$target2;
 drop table del$target3;
*/

create table del$source
(
  id number(38),
  col2 varchar2(200 char)
);

create table del$target1(id number(38));
create table del$target2(id number(38), col2 varchar2(200 char));
create table del$target3(id number(38), col2 varchar2(200 char), col3 date);

insert /*+ append*/ into del$source 
select level, lpad('X', 100, 'x')
  from dual connect by level <= 10000;
commit;


---- ������ 1. �� �����������. ��������� ��� ������ ������� = 3 * Full table scan
insert into del$target1 (id)
select s.id from del$source s;

insert into del$target2 (id, col2)
select s.id, s.col2 from del$source s;

insert into del$target3 (id, col2, col3)
select s.id, s.col2, sysdate from del$source s;

commit;

---- ������ 2. �����������. 1 * Full table scan
insert all
  into del$target1 (id) values (id) -- ���
  into del$target2 (id, col2) values (id, col2) -- ���
  into del$target3 (id, col2, col3) values (id, col2, sysdate) -- ���
select * from del$source s;
commit;

-- � �������� when
insert all
  when 1 = 1 then into del$target1 (id) values (id) -- ���
  when mod(id, 2) = 0 then into del$target2 (id, col2) values (id, col2) -- ������
  when (mod(id, 2) = 0 and col2 is not null) then into del$target3 (id, col2, col3) values (id, col2, sysdate) -- ������ + �� ������
select * from del$source s;
commit;

-- insert first
truncate table del$target1;
truncate table del$target2;
truncate table del$target3;

insert first
  when mod(id, 2) = 0 then into del$target1 (id) values (id) -- ������
  when mod(id, 3) = 0 then into del$target2 (id, col2) values (id, col2) -- ������� �� 3
  else into del$target3 (id, col2, col3) values (id, col2, sysdate) -- ���������
select * from del$source s;
commit;

select * from del$target1;
select * from del$target2;
select * from del$target3;


