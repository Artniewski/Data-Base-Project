use
    `speedygad`;
DELIMITER
$$
drop procedure if exists sample_data_generator;
create procedure sample_data_generator()
begin
    insert into Brands (name, country)
    values ('BMW', 'Germany'),
           ('Audi', 'Germany'),
           ('Fiat', 'Italy'),
           ('Opel', 'Germany'),
           ('Dodge', 'USA'),
           ('Lamborghini', 'Italy'),
           ('Ferrari', 'Italy'),
           ('Porsche', 'Germany'),
           ('Mercedes-Benz', 'Germany'),
           ('Maserati', 'Italy'),
           ('Citroën', 'France'),
           ('Dacia', 'Romania'),
           ('Ford', 'USA'),
           ('Hyundai', 'South Korea'),
           ('Kia', 'South Korea'),
           ('Nissan', 'Japan'),
           ('Peugeot', 'France'),
           ('Renault', 'France');
    insert into Models (brandID, name, price, max_speed)
    values (1, 'iX M60', 549900.00, 250.00),
           (2, 'A1 Sportback', 249900.00, 180.00),
           (3, '126p', 1500.00, 80.00),
           (4, 'Astra', 25000.00, 140.00),
           (5, 'Challenger 6.4', 431000.00, 250.00),
           (6, 'Huracan', 1200000.00, 325.00),
           (7, '458', 1043800.00, 340.00),
           (8, '911', 520000.00, 295.00),
           (9, 'Citan', 128935.00, 180.00),
           (10, 'Ghibli', 530344.00, 250.00),
           (11, 'c5x', 147900.00, 240.00),
           (12, 'Duster', 52200.00, 180.00),
           (13, 'Fiesta', 66000.00, 160.00),
           (14, 'i10', 41300.00, 150.00),
           (15, 'Sportage', 105900.00, 200.00),
           (16, 'Leaf', 123900.00, 144.00),
           (17, 'e-208', 124900.00, 150.00),
           (18, 'Arkana', 113900.00, 205.00);
    insert into Stores (city, street, number, zip_code, phone_number)
    values ('Wrocław', 'Jagiellońska', '12a', '50523', 345223234),
           ('Warszawa', 'Kacza', '54', '34863', 574934057),
           ('Poznań', 'Krucza', '645d', '12384', 206535723),
           ('Warszawa', 'Wiejska', '4', '00902', 226941426);

end;
$$
DELIMITER ;


DELIMITER
$$
drop procedure if exists add_customer;
create procedure add_customer(IN n varchar(50), ln varchar(50), pn int, em varchar(50), out c_id int)
begin
    insert ignore into Customers (name, lastname, phone_number, email) value (n, ln, pn, em);
    select ID into c_id from customers where (name, lastname, phone_number, email) = (n, ln, pn, em);
end;
$$
DELIMITER ;


DELIMITER
$$
drop procedure if exists add_brand;
create procedure add_brand(IN n varchar(50), c varchar(50), out b_id int)
begin
    insert ignore into Brands (name, country) value (n, c);
    select ID into b_id from brands where (name, country) = (n, c);
end;
$$
DELIMITER ;


DELIMITER
$$
drop procedure if exists add_user;
create procedure add_user(IN log varchar(50), pas varchar(100), t enum ('worker', 'manager', 'admin'), n varchar(50),
                          ln varchar(50), g enum ('K', 'M'), out u_id int)
begin
    insert into Users (login, password, type, name, lastname, gender) value (log, pas, t, n, ln, g);
    select ID into u_id from users where (login, password, type, name, lastname, gender) = (log, pas, t, n, ln, g);
end;
$$
DELIMITER ;


DELIMITER
$$
drop procedure if exists add_store;
create procedure add_store(IN c varchar(50), s varchar(50), n varchar(4), zc varchar(5), p int unsigned, out s_id int)
begin
    insert into Stores (city, street, number, zip_code, phone_number)
    values (c, s, n, zc, p);
    select ID into s_id from Stores where (city, street, number, zip_code, phone_number) = (c, s, n, zc, p);
end;
$$
DELIMITER ;


DELIMITER $$
drop procedure if exists add_car_model;
create procedure add_car_model(IN brand_name varchar(50), brand_country varchar(50), car_name varchar(50),
                               car_price float, car_max_speed decimal(5, 2), out b_ID int, out m_ID int)
begin
    start transaction ;
    if exists(select name from models where name = car_name) then
        rollback ;
    else
        call add_brand(brand_name, brand_country, b_ID);
        insert ignore into Models (brandID, name, price, max_speed)
            value (b_ID, car_name, car_price, car_max_speed);
        select ID
        into m_ID
        from models
        where (brandID, name, price, max_speed) = (b_ID, car_name, car_price, car_max_speed);
        commit;
    end if;
end;
$$
DELIMITER ;


-- Dodanie zlecenia - add_order(customer_name, customer_lastname,
-- customer_phone_number, customer_email, modelID, storeID, userID, car_color, date, status)
-- TODO: zmiana w sprawozdaniu usunac trigger i w add_order zmiana argumentow ( status)
DELIMITER
$$
drop procedure if exists add_order;
create procedure add_order(IN c_name varchar(50), c_lastname varchar(50),
                           c_phone int unsigned, c_email varchar(50),
                           mID int unsigned, sID int unsigned, uID int unsigned,
                           car_color varchar(20), d date)
begin
    declare carAmount int;
    start transaction;
    set carAmount = (select quantity from Cars_in_stores where (modelID, storeID, color) = (mID, sID, car_color));
    if carAmount > 0 then
        call add_customer(c_name, c_lastname, c_phone, c_email, @clID);
        insert into Orders (customerID, modelID, storeID, userID, color, date, status)
            value (@clID, mID, sID, uID, car_color, d, 'pending');

        update Cars_in_stores set quantity = quantity - 1 where (modelID, storeID, color) = (mID, sID, car_color);
    else
        rollback;
    end if;
    commit;
end;
$$
DELIMITER ;


DELIMITER $$
drop procedure if exists add_car_to_store;
create procedure add_car_to_store(IN brand_name varchar(50), brand_country varchar(50),
                                  car_name varchar(50), car_price float unsigned, car_max_speed decimal(5, 2),
                                  store_ID int unsigned, qty int unsigned,
                                  car_color varchar(15))
begin
    start transaction;
    if exists(select ID from Stores where ID = store_ID) then
        call add_car_model(brand_name, brand_country, car_name, car_price, car_max_speed, @bID, @moID);
        # select @bID, @moID; # Tutaj model_ID = null
        if exists(select modelID, storeID, color
                  from Cars_in_stores
                  where (modelID, storeID, color) = (@moID, store_ID, car_color)) then
            update Cars_in_stores
            set quantity = quantity + qty
            where (modelID, storeID, color) = (@moID, store_ID, car_color);
        else
            insert into Cars_in_stores (modelID, storeID, quantity, color) value (@moID, store_ID, qty, car_color);
        end if;

    else
        rollback;
    end if;
    commit;
end;
$$
DELIMITER ;


DELIMITER $$
drop procedure if exists cancel_order;
create procedure cancel_order(o_id int)
begin
    declare s enum ('pending', 'done','cancelled');
    declare b_name varchar(50);
    declare b_country varchar(50);
    declare m_id int unsigned;
    declare s_id int unsigned;
    declare col varchar(20);
    declare speed decimal(5, 2);
    declare c_name varchar(50);
    declare b_id int unsigned;
    declare c_price float;
    select modelID, color, storeID into m_id, col, s_id from orders where ID = o_id;
    select max_speed, name, price into speed, c_name, c_price from models where ID = m_id;
    select status into s from orders where ID = o_id;
    select brandID into b_id from models where ID = m_id;
    select name, country into b_name,b_country from brands where ID = b_id;
    if s = 'pending' then
        update orders
        set status = 'cancelled'
        where (ID = o_id);
        call add_car_to_store(b_name, b_country, c_name, c_price, speed, s_id, 1, col);
    end if;
end;
$$
DELIMITER ;