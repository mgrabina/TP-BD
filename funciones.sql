-- Funcion inserta_datos toma tablas 

CREATE FUNCTION inserta_datos()
returns null
DECLARE

BEGIN
        -- PELICULA
        
        -- DIRIGE
        
        -- PERTENECE
        
        -- ACTOR
        
        -- ACTUA
                
END;




-- Funcion incrementa para el trigger

CREATE FUNCTION incrementa(id_nuevo integer)
returns null
DECLARE 
        cantAnterior integer
BEGIN  
        -- Guardamos la cantidad de peliculas hasta el momento
        cantAnterior = SELECT cantidad_films FROM actor WHERE id_nuevo = actor.id_actor; 
        
        -- Se actualiza la cantidad de actor
        UPDATE actor
        SET cantidad_films = cantAnterior + 1
        WHERE id_nuevo = actor.id_actor ;         
        
        RAISE NOTICE 'Valor actualizado en id: %', id_nuevo;
END; 



-- Trigger por cada insercion a la tabla actua (idfilm idactor) se actualiza la cantidad de peliculas de dicho actor.

CREATE TRIGGER contador_actor  
AFTER INSERT ON actua
EXECUTE PROCEDURE incrementa(NEW.id_actor);




