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





------------------------- Parte C --------------------------------
-- Funcion inserta_datos toma tablas 

--/
CREATE or replace FUNCTION inserta_datos()
returns integer AS $$
DECLARE
        s record;
        r record;
        t record;
        j record;
        casting TEXT[];
        directores TEXT[];
        id_direc integer;
        paises TEXT[];
        id_actor_mayor integer;
BEGIN
        -- PELICULA (id_film, title, title_es, title_en, title_orig, year_, plot, synopsis_es, synopsis_en, tagline, duration, color, id_youtube, url_ticket) 
        INSERT INTO PELICULA
        SELECT (id_film, title, title_es, title_en, title_orig, year_, plot, synopsis_es, synopsis_en, tagline, duration, color, id_youtube, url_ticket)
        FROM film;         
        
        -- DIRIGE
        FOR s IN SELECT (id_film, director1,director2,director3,director4,director5,director6,director7,director8,director9,director10,director11,director12,director13,director14) FROM film
        LOOP    -- Por cada pelicula con sus directores
                insert into directores values (s.director1,s.director2,s.director3,s.director4,s.director5,s.director6,s.director7,s.director8,s.director9,s.director10,s.director11,s.director12,s.director13,s.director14);
                FOREACH r SLICE 1 IN ARRAY directores  -- Foreach es a partir de postgresql 9.1
                LOOP
                        if(r is not null)THEN
                                id_direc = (select id_director from director where nombre = r);
                                if(id_direc is not null)THEN    -- Se inserta unicamente si ya existia el director
                                        INSERT INTO dirige
                                        VALUES (s.id_film, id_direc);
                                END IF;         
                        END IF;        
                END LOOP;
        END LOOP; 
        RAISE NOTICE 'Dirige insertadas.';           
        
        -- PERTENECE
        FOR j IN SELECT (id_film, id_country1,id_country2,id_country3,id_country4,id_country5,id_country6,id_country7,id_country8) FROM film
        LOOP    -- Por cada pelicula con sus paises
                insert into paises values (j.id_country1,j.id_country2,j.id_country3,j.id_country4,j.id_country5,j.id_country6,j.id_country7,j.id_country8);                
                FOREACH t SLICE 1 IN ARRAY paises
                LOOP
                        if(t is not null)THEN
                                        r = (SELECT id_country from pais where t = id_country);
                                        if(r is not null)then
                                                INSERT INTO pertenece                   -- Se inserta unicamente si existe el pais en los registros
                                                VALUES (s.id_film, t);
                                        end if;       
                        END IF;   
                END LOOP;              
        END LOOP; 
        RAISE NOTICE 'Pertenece insertadas.';            

        
        -- ACTOR y ACTUA
        id_actor_mayor = (SELECT max(id_actor) from ACTOR); 
        
        FOR r IN (SELECT (id_film, cast_ ) from film)  -- Por cada pelicula con su cast
        LOOP
                --TRIM() para eliminar caracteres, por default espacio
                --regexp_split_to_array(string text, pattern text [, flags text ]) para separar por caracter
                casting = regexp_split_to_array(r.cast_ , ','); 
                
                FOREACH t SLICE 1 in ARRAY casting
                LOOP
                        
                        -- ACTOR
                        j = (SELECT id_actor FROM actor as a2
                                WHERE lower(trim(a2.nombre)) = lower(trim(a1.nombre))); -- Si previamente no existia ni ningun nombre equivalente
                        if(j is null)then
                                INSERT INTO ACTOR as a1
                                VALUES(id_actor_mayor + 1, trim(t), 0);             -- Inserto como nuevo actor 
                        end if;
                        id_actor_mayor = id_actor_mayor + 1; 
                         
                        -- ACTUA
                        INSERT INTO ACTUA
                        VALUES(r.id_film, t) ;
                     
                END LOOP;
                delete from casting; 
        END LOOP; 
        RAISE NOTICE 'Actor y actua insertadas.';             
        return 1;       
END 

$$ LANGUAGE plpgsql; 

/