------------------------- Parte B --------------------------------
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
FOR EACH ROW
EXECUTE PROCEDURE incrementa(NEW.id_actor);

------------------------- Parte C --------------------------------
-- Funcion inserta_datos toma tablas 

CREATE FUNCTION inserta_datos()
returns null
DECLARE
        casting TEXT[]
        directores TEXT[]
        paises TEXT[]
        id_actor_mayor integer
BEGIN
        -- PELICULA (id_film, title, title_es, title_en, title_orig, year_, plot, synopsis_es, synopsis_en, tagline, duration, color, id_youtube, url_ticket) 
        INSERT INTO PELICULA
        SELECT (id_film, title, title_es, title_en, title_orig, year_, plot, synopsis_es, synopsis_en, tagline, duration, color, id_youtube, url_ticket)
        FROM film;
                 
        -- DIRIGE
        FOR s IN SELECT (id_film, director1,director2,director3,director4,director5,director6,director7,director8,director9,director10,director11,director12,director13,director14) FROM film
        LOOP    -- Por cada pelicula con sus directores
                directores = {s.director1,s.director2,s.director3,s.director4,s.director5,s.director6,s.director7,s.director8,s.director9,s.director10,s.director11,s.director12,s.director13,s.director14}                
                FOREACH direc SLICE 1 IN ARRAY directores
                LOOP
                        //terminar
                END LOOP
        END LOOP;
        
        -- PERTENECE
        FOR j IN SELECT (id_film, id_country1,id_country2,id_country3,id_country4,id_country5,id_country6,id_country7,id_country8) FROM film
        LOOP    -- Por cada pelicula con sus paises
                
                        //terminar                
        END LOOP;
        
        
        -- ACTOR y ACTUA
        id_actor_mayor = SELECT max(id_actor) from ACTOR;
        
        FOR r IN SELECT (id_film, cast_ ) from film  -- Por cada pelicula con su cast
        LOOP
                //TRIM() para eliminar caracteres, por default espacio
                //regexp_split_to_array(string text, pattern text [, flags text ]) para separar por caracter
                casting = regexp_split_to_array(r.cast_ , ',');
                
                FOREACH actor SLICE 1 in ARRAY casting
                LOOP
                
                        -- ACTOR
                        INSERT INTO ACTOR as a1
                        VALUES(id_actor_mayor + 1, trim(actor), 0);             -- Inserto como nuevo actor 
                        WHERE NOT EXISTS (
                                SELECT id_actor FROM actor as a2
                                WHERE lower(trim(a2.nombre)) = lower(trim(a1.nombre)) -- Si previamente no existia ni ningun nombre equivalente
                        );
                        id_actor_mayor += 1;
                         
                        -- ACTUA
                        INSERT INTO ACTUA
                        VALUES(r.id_film, actor);
                     
                END LOOP
                casting = NULL;
        END LOOP;
        
               
END;








