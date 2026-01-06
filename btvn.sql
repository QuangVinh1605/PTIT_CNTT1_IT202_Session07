create database if not exists bai1;
use bai1;
-- drop table if exists order_items; -- Xóa bảng này trước vì nó tham chiếu đến products/orders
-- drop table if exists orders;      -- Xóa bảng này trước vì nó tham chiếu đến customers
-- drop table if exists customers;
-- drop table if exists products;

create table if not exists customers (
id int auto_increment primary key,
name varchar(255) not null,
email varchar(255)
);

create table if not exists orders (
id int auto_increment primary key,
customer_id int,
order_date date,
total_amount decimal(10,2),
foreign key (customer_id) references customers(id)
);

insert into customers (name, email) values
('nguyễn văn a', 'a@gmail.com'),
('trần thị b', 'b@gmail.com'),
('lê văn c', 'c@gmail.com'),
('phạm minh d', 'd@gmail.com'),
('hoàng anh e', 'e@gmail.com'),
('vũ văn f', 'f@gmail.com'),
('đỗ thị g', 'g@gmail.com');

insert into orders (customer_id, order_date, total_amount) values
(1, '2024-01-01', 500000),
(1, '2024-01-05', 300000),
(2, '2024-01-10', 1200000),
(3, '2024-01-12', 450000),
(4, '2024-01-15', 800000),
(5, '2024-01-20', 150000),
(2, '2024-01-22', 200000);

select * from customers
where id in (select customer_id from orders);

create table if not exists products (
    id int auto_increment primary key,
    name varchar(255) not null,
    price decimal(10,2)
);

create table if not exists order_items (
    order_id int,
    product_id int,
    quantity int,
    foreign key (product_id) references products(id)
);

insert into products (name, price) values
('iphone 15', 25000000),
('samsung s23', 20000000),
('tai nghe sony', 5000000),
('chuột logitech', 1200000),
('bàn phím cơ', 2500000),
('màn hình dell', 8000000),
('loa bluetooth', 3000000);

insert into order_items (order_id, product_id, quantity) values
(101, 1, 1),
(101, 3, 2),
(102, 2, 1),
(103, 1, 1),
(104, 4, 3),
(105, 5, 1),
(106, 2, 2);

select * from products
where id in (select product_id from order_items);
-- bai3:
select * from orders
where total_amount > (select avg(total_amount) from orders);

-- bai4: 
select 
    name, 
    (select count(*) from orders where orders.customer_id = customers.id) as so_luong_don
from customers;

-- bai 5:
select * from customers 
where id = 
(select customer_id from orders group by customer_id having sum(total_amount) = 
(select max(tong_tien_tung_nguoi) from 
(select sum(total_amount) as tong_tien_tung_nguoi from orders group by customer_id) as bang_tam
    )
);

-- bai6:
select customer_id, sum(total_amount) as tong_chi_tieu group by customer_id having sum(total_amount) > (
select avg(tong_tung_nguoi) from 
(select sum(total_amount) as tong_tung_nguoi from orders group by customer_id) as bang_tam
);
