drop database if exists `SpeedyGad`;
create database `SpeedyGad`;
use `SpeedyGad`;

create table Users
(
    ID       int unsigned auto_increment primary key,
    login    varchar(50)  not null,
    password varchar(100) not null,
    type     enum ('worker', 'manager', 'admin'),
    name     varchar(50)  not null,
    lastname varchar(50)  not null,
    gender   enum ('M', 'K')
);
create table Customers
(
    ID           int unsigned auto_increment primary key,
    name         varchar(50)  not null,
    lastname     varchar(50)  not null,
    phone_number int unsigned not null,
    email        varchar(50),
    check ( phone_number >= 100000000 and phone_number <= 999999999)
);

create table Brands
(
    ID      int unsigned auto_increment primary key,
    name    varchar(50) not null,
    country varchar(50) not null
);
create table Models
(
    ID        int unsigned auto_increment primary key,
    brandID   int unsigned,
    name      varchar(50) not null,
    price     float unsigned,
    max_speed dec(5, 2) unsigned,
    foreign key (brandID) references Brands (ID),
    check ( max_speed > 0 ),
    check ( price > 0 )
);

create table Stores
(
    ID           int unsigned auto_increment primary key,
    city         varchar(50) not null,
    street       varchar(50) not null,
    number       varchar(4)  not null,
    zip_code     char(5)     not null,
    phone_number int unsigned,
    check ( phone_number >= 100000000 and phone_number <= 999999999 )
);

create table Cars_in_stores
(
    modelID  int unsigned,
    storeID  int unsigned,
    quantity int unsigned,
    color    varchar(20) not null,
    primary key (modelID, storeID),
    foreign key (modelID) references Models (ID),
    foreign key (storeID) references Stores (ID),
    check ( quantity >= 0 )
);

create table Orders
(
    ID         int unsigned auto_increment primary key,
    customerID int unsigned,
    modelID    int unsigned,
    storeID    int unsigned,
    userID     int unsigned,
    color      varchar(20) not null,
    date       date        not null,
    status     enum ('pending', 'done', 'cancelled'),
    foreign key (customerID) references Customers (ID),
    foreign key (modelID) references Models (ID),
    foreign key (storeID) references Stores (ID),
    foreign key (userID) references Users (ID)
);