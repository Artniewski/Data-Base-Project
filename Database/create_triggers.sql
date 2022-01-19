USE `SpeedyGad`;

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