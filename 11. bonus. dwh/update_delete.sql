-- �������� ������
drop table del$tab1;
drop table del$tab2;

create table del$tab1
(
  id number(38)
);

create table del$tab2
(
  id number(38)
);

insert into del$tab1 values(1);
insert into del$tab1 values(2);
insert into del$tab1 values(3);

insert into del$tab2 values(3);
commit;

---- ������ 1. Intersect
-- ����
select * 
  from del$tab1 t1
intersect
select * 
  from del$tab2 t2; 

-- �����
select * 
  from del$tab1 t1
  join del$tab2 t2 on t1.id = t2.id;


---- ������ 2. Minus

-- ����
select * 
  from del$tab1 t1
minus
select * 
  from del$tab2 t2; 

-- �����
select t1.id 
  from del$tab1 t1
  left join del$tab2 t2 on t1.id = t2.id
 where t2.id is null;


---- ������ 3. Update
-- ������������, ����� ������������� ������� �� ����������, 
-- �.�. ���������� ����������� > 100K ����� � > 5% �������
-- ������: ������������ undo �� ��������� �����, ������� �� direct write.

-- ���� 
update del$tab1 t1
   set t1.id = t1.id + 1
 where mod(t1.id, 2) = 0;

select * from del$tab1;


-- ����� 1 (���������� ������)
create table del$tab3(id) as
select (case when mod(t1.id, 2) = 0 then t1.id + 1 else t1.id end) id
  from del$tab1 t1;

drop table del$tab1;

alter table del$tab3 rename to del$tab1;

select * from del$tab1;


-- ����� 2.
drop table del$tmp$tab1;
create global temporary table del$tmp$tab1(id number(38)) on commit preserve rows;

insert into del$tmp$tab1 
select (case when mod(t1.id, 2) = 0 then t1.id + 1 else t1.id end) id
  from del$tab1 t1;

truncate table del$tab1;

insert /*+ append */ into del$tab1
select * from del$tmp$tab1;

commit;

select * from del$tab1;


---- ������ 4. Delete
-- ������������, ����� ������������� ������� �� ����������, 
-- �.�. ���������� ����������� > 100K ����� ��� > 5% �������
-- ������: ������������ undo �� ��������� �����, ������� �� direct write.

-- ���� 
delete del$tab1 t1
 where mod(t1.id, 2) = 0; -- ������� ������

select * from del$tab1;

-- ����� 1.

create table del$tab3(id) as
select *
  from del$tab1 t1
 where mod(t1.id, 2) != 0; -- ��������� ������

drop table del$tab1;

alter table del$tab3 rename to del$tab1;

select * from del$tab1;

---- ������� ��� ���������������� ��������������

update tab1 t1
   set t1.col2 = col2 + 'x'
 where exists (select 1 from tab2 t2 where t1.id = t2.client_id);


delete tab1 t1  
 where exists (select 1 from tab2 t2 where t1.id = t2.client_id);





