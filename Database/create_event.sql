use `speedygad`;
drop event if exists remove_cars_from_stores_if_0_left;
create event remove_cars_from_stores_if_0_left
    on schedule at current_timestamp + interval 1 hour
    DO
    delete
    from cars_in_stores
    where quantity = 0;