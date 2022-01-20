USE SpeedyGad;

CREATE USER IF NOT EXISTS 'app'@'localhost' IDENTIFIED BY 'app';
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin';
CREATE USER IF NOT EXISTS 'manager'@'localhost' IDENTIFIED BY 'manager';
CREATE USER IF NOT EXISTS 'worker'@'localhost' IDENTIFIED BY 'worker';

# app
GRANT SELECT on Users TO 'app'@'localhost';
GRANT EXECUTE ON PROCEDURE sample_data_generator TO 'app'@'localhost';

CREATE ROLE IF NOT EXISTS worker;
CREATE ROLE IF NOT EXISTS manager;
CREATE ROLE IF NOT EXISTS admin;


GRANT SELECT,INSERT ON Speedygad.Customers TO worker;
GRANT SELECT,INSERT ON Orders TO worker;
GRANT SELECT ON cars_in_stores TO worker;
GRANT SELECT ON Models TO worker;
GRANT SELECT ON Brands TO worker;
GRANT SELECT ON Stores TO worker;

GRANT EXECUTE ON PROCEDURE add_customer TO worker;
GRANT EXECUTE ON PROCEDURE add_order TO worker;

GRANT INSERT ON Models TO manager;
GRANT INSERT ON Brands TO manager;
GRANT SELECT,INSERT,UPDATE ON Cars_in_stores TO manager;
GRANT UPDATE ON orders TO manager;

GRANT EXECUTE ON PROCEDURE add_brand TO manager;
GRANT EXECUTE ON PROCEDURE add_car_model TO manager;
GRANT EXECUTE ON PROCEDURE add_car_to_store TO manager;

GRANT INSERT,DELETE ON Users TO admin;
#TODO: zmienic w sprawozdaniu, ze manager zajmuje sie inwentaryzacja sklepu
#nie dodaje pracownikow
GRANT EXECUTE ON PROCEDURE add_user TO admin;
GRANT EXECUTE ON PROCEDURE add_store TO admin;

GRANT worker TO manager;
GRANT manager TO admin;

GRANT 'manager' TO 'manager'@'localhost';
GRANT 'worker' TO 'worker'@'localhost';
GRANT 'admin' TO 'admin'@'localhost';






