USE `Speedygad`;

# delimiter //
# DROP TRIGGER IF EXISTS remove_cars_from_stores_if_0_left;
# CREATE TRIGGER remove_cars_from_stores_if_0_left
#     AFTER UPDATE
#     ON Cars_in_stores
#     FOR EACH ROW
# BEGIN
#     IF (NEW.quantity = 0) THEN
#         DELETE FROM Cars_in_stores WHERE quantity = 0;
#     END IF;
# END //
# delimiter ;

# DELIMITER $$
# drop trigger if exists remove_car_from_store_if_order_status_is_pending;
# create trigger remove_car_from_store_if_order_status_is_pending
#     after insert on orders
#     for each row
#     begin
#         if new.status = 'pending' then
#             update cars_in_stores
#             set quantity = quantity - 1
#             where new.storeID = cars_in_stores.storeID and new.modelID = cars_in_stores.modelID and new.color = cars_in_stores.color;
#         end if;
#     end;
# $$
-- TODO: zmiana nazwy trigger w sprawozdaniu remove_car_from_store_if_order_status_is_cancelled (remove -> add, from ->to)
# DELIMITER $$
# drop trigger if exists add_car_to_store_if_order_status_is_cancelled;
# create trigger add_car_to_store_if_order_status_is_cancelled
#     before update
#     on orders
#     for each row
# begin
#     declare brand_name varchar(50);
#     declare brand_country varchar(50);
#     declare car_name varchar(50);
#     declare car_price float unsigned;
#     declare car_max_speed decimal(5, 2) unsigned;
#     if new.status = 'cancelled' then
#         select name, country
#         into brand_name, brand_country
#         from Brands as b
#         where b.ID = (select brandID
#                       from Models as m
#                       where new.modelID = m.ID);
#         select name, price, max_speed
#         into car_name,car_price,car_max_speed
#         from Models
#         where ID = NEW.modelID;
#         call add_car_to_store(brand_name, brand_country, car_name, car_price, car_max_speed, new.storeID, 1, new.color);
#
#     end if;
# end;
# $$
# DELIMITER ;

DELIMITER $$
drop trigger if exists remove_model_if_no_cars_left;
create trigger remove_model_if_no_cars_left
    after delete
    on cars_in_stores
    for each row
begin
    if old.modelID not in (select modelID from cars_in_stores) then
        delete from models where ID = old.modelID;
    end if;
end;
$$
DELIMITER ;