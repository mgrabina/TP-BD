--/
DROP trigger IF EXISTS contador_actor ON actua;
/
--/
CREATE OR REPLACE FUNCTION incrementa() RETURNS trigger AS $$
DECLARE
        cantAnterior int;
BEGIN  
        SELECT cantidad_films
                into cantAnterior 
        FROM actor 
        WHERE NEW.id_actor = actor.id_actor; 
        
        UPDATE actor
        SET actor.cantidad_films = cantAnterior + 1
        WHERE NEW.id_actor = actor.id_actor ;         
        RAISE NOTICE 'Valor actualizado en id: %', NEW.id_actor;
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



