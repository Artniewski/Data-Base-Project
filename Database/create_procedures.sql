use `speedygad`;
DELIMITER $$
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
    values ('Wrocław', 'Jagiellońska', '12a', '50-523', 345223234),
           ('Warszawa', 'Kacza', '54', '34-863', 574934057),
           ('Poznań', 'Krucza', '645d', '12-384', 206535723),
           ('Warszawa', 'Wiejska', '4', '00-902', 226941426);

end;
$$
DELIMITER ;

DELIMITER $$
drop procedure if exists add_store;

