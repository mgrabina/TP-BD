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
CREATE OR REPLACE FUNCTION INSERTA_DATOS_PELICULA()
RETURNS VOID AS $$
BEGIN  
        INSERT INTO pelicula
        SELECT id_film, title, title_es, title_en, title_orig, year_, 
        plot, synopsis_es, synopsis_en, tagline, duration, color, id_youtube, url_ticket
        FROM film
        where id_film NOT IN( SELECT DISTINCT id_film from pelicula);
END;
$$ LANGUAGE PLPGSQL;   
/
/drop function inserta_datos_dirige
--/
CREATE or replace FUNCTION inserta_datos_dirige()
returns VOID AS $$
DECLARE
        s film%rowtype;
        r record;              -- Variables auxiliares para iterar
        t record;
        j record;
        dir integer;
        casting TEXT[];
        directores integer[];
        id_direc integer;
        paises TEXT[];
        id_actor_mayor integer;
BEGIN         
        -- DIRIGE
        FOR s IN (SELECT * FROM film)
        LOOP    -- Por cada pelicula con sus id_directores
                
                directores = ARRAY[s.id_director1,s.id_director2,s.id_director3,s.id_director4,s.id_director5,s.id_director6,s.id_director7,s.id_director8,s.id_director9,s.id_director10,s.id_director11,s.id_director12,s.id_director13,s.id_director14];                
                FOREACH dir  IN ARRAY directores  -- Foreach es a partir de postgresql 9.1
                LOOP
                        if(dir != 0)THEN
                                if((select id_director from director where dir = id_director) is not null and (select id_director from dirige where id_director = dir and id_film = s.id_film ) is null)THEN    -- Se inserta unicamente si ya existia el director
                                        INSERT INTO dirige
                                        VALUES (dir, s.id_film);
                                END IF;         
                        END IF;        
                END LOOP;
        END LOOP; 
        RAISE NOTICE 'Dirige insertadas.';               
END 
$$ LANGUAGE plpgsql; 
/


