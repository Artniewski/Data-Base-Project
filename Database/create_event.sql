use `speedygad`;
drop event if exists remove_cars_from_stores_if_0_left;
create event remove_cars_from_stores_if_0_left
    on schedule at current_timestamp + interval 1 hour
    DO
    delete
    from cars_in_stores
    where quantity = 0;

drop event if exists update_orders;
create event update_orders
    on schedule
        every 1 day
            starts (timestamp(current_date) + interval 1 day)
    do
    update orders
    set status = 'done'
    where date < current_date
      and status = 'pending'