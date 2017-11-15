--/
DROP trigger contador_actor ON actua;
/
--/
CREATE OR REPLACE FUNCTION incrementa() RETURNS trigger AS $$
DECLARE
        cantAnterior int;
BEGIN  
        SELECT cantidad_films
                into cantAnterior 
        FROM actor 
        WHERE NEW.id = actor.id_actor; 
        
        UPDATE actor
        SET cantidad_films = cantAnterior + 1
        WHERE NEW.id = actor.id_actor ;         
        RAISE NOTICE 'Valor actualizado en id: %', id_nuevo;
        RETURN NEW;
 
END;$$
LANGUAGE plpgsql;
/
--/
CREATE TRIGGER contador_actor  
AFTER INSERT OR UPDATE ON actua
FOR EACH ROW
EXECUTE PROCEDURE incrementa();
/



