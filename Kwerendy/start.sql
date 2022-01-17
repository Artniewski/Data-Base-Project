drop database if exists `db-storehouses`;
create database `db-storehouses`;
use `db-storehouses`;
create table Users (
    login varchar(30) primary key,
    password varchar(100) not null,
    type enum('worker', 'manager', 'admin')
);

create table Storehouses (
    ID int auto_increment,
    name varchar(50) not null,
    city varchar(20) not null,
    zipcode char(6) not null,
    street varchar(20) not null,
    number varchar(4) not null,
    primary key (ID)
);

create table Suppliers (
    ID int auto_increment,
    country varchar(15) not null ,
    name varchar(15) not null,
    primary key(ID)
);
create table Items (
    ID int auto_increment,
    name varchar(50) not null,
    supplierID int,
    price float unsigned,
    primary key(ID),
    foreign key (supplierID) references Suppliers(ID),
    constraint price_check
        check ( price > 0 )
);

create table Items_in_storehouses (
    storehouseID int,
    quantity int unsigned,
    itemID int,
    foreign key (storehouseID) references Storehouses(ID),
    foreign key (itemID) references  Items(ID),
    primary key (storehouseID,itemID),
    constraint quant
        check ( quantity > 0 )
);

DELIMITER $$
drop procedure if exists generate;
create procedure generate ()
begin
    insert into Suppliers (country, name)
        values
                ('Polska', 'Łucznik'),
                ('Szwecja', 'IKEA'),
                ('Niemcy', 'Szwarzkopf'),
                ('USA', 'Dodge');
    
    insert into Items (name, supplierID, price)
        values
                ('Szampon', 3, 12.5),
                ('Szafa', 2, 159.99),
                ('Dżip', 4, 399999.00),
                ('Dżipek', 4, 199999.00),
                ('Maszyna do szycia', 1, 399.99);

    insert into Storehouses (name, city, zipcode, street, number)
        values
                ('MagazynA', 'Wrocław', '34-532', 'Karmelkowa', '12'),
                ('MagazynB', 'Warszawa', '45-398', 'Piłsudzkiego', '54b'),
                ('MagazynC', 'Poznań', '65-423', 'Giełdowa', '63');
    insert into Items_in_storehouses (storehouseID, quantity, itemID)
        values
               (1, 5, 2),
               (1, 15, 3),
               (2, 6, 4),
               (3, 45, 2),
               (3, 150, 1),
               (3, 5, 5);

end; $$
DELIMITER ;

call generate()