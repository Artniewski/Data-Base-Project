USE `SpeedyGad`;

delimiter //
DROP TRIGGER IF EXISTS remove_cars_from_stroes_if_0_left;
CREATE TRIGGER remove_cars_from_stroes_if_0_left
    AFTER UPDATE
    ON Cars_in_stores
    FOR EACH ROW
BEGIN
    IF (NEW.quantity = 0) THEN
        DELETE FROM Cars_in_stores WHERE quantity = 0;
    END IF;
END //
delimiter ;
