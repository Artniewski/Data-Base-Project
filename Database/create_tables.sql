drop database if exists `SpeedyGad`;
create database `SpeedyGad`;
use `SpeedyGad`;

create table Users
(
    ID       int auto_increment primary key,
    login    varchar(30)  not null,
    password varchar(100) not null,
    type     enum ('worker', 'manager', 'admin'),
    name     varchar(15)  not null,
    lastname varchar(15)  not null,
    gender   enum ('M', 'K')
);
create table Customers
(
    ID           int auto_increment primary key,
    name         varchar(50) not null,
    lastname     varchar(50) not null,
    phone_number int         not null,
    email        varchar(50),
    check ( phone_number >= 100000000 and phone_number <= 999999999)
);

create table Brands
(
    ID      int auto_increment primary key,
    name    varchar(50) not null,
    country varchar(50) not null
);
create table Models
(
    ID        int auto_increment primary key,
    brandID   int,
    name      varchar(50) not null,
    price     float,
    max_speed dec(3, 2),
    foreign key (brandID) references Brands (ID),
    check ( max_speed > 0 ),
    check ( price > 0 )
);

create table Stores
(
    ID           int auto_increment primary key,
    street       varchar(30) not null,
    number       varchar(4)  not null,
    zip_code     char(5)     not null,
    phone_number int,
    check ( phone_number >= 100000000 and phone_number <= 999999999 )
);

create table Cars_in_stores
(
    modelID  int,
    storeID  int,
    quantity int unsigned,
    color    varchar(20) not null,
    primary key (modelID, storeID),
    foreign key (modelID) references Models (ID),
    foreign key (storeID) references Stores (ID),
    check ( quantity > 0 )
);

create table Orders
(
    ID         int auto_increment primary key,
    customerID int,
    modelID    int,
    storeID    int,
    userID     int,
    color      varchar(20) not null,
    date       date,
    status     enum ('pending', 'done', 'cancelled'),
    primary key (ID),
    foreign key (customerID) references Customers (ID),
    foreign key (modelID) references Models (ID),
    foreign key (storeID) references Stores (ID),
    foreign key (userID) references Users (ID)
)