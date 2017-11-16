------------------- PARTE B ----------------------------------
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
        if cantAnterior is null then
                cantAnterior=0;
        END IF;
        
        UPDATE actor
        SET cantidad_films = cantAnterior + 1
        WHERE NEW.id_actor = actor.id_actor ;         
        RETURN NEW;
 
END;$$
LANGUAGE plpgsql;
/

CREATE TRIGGER contador_actor  
AFTER INSERT OR UPDATE ON actua
FOR EACH ROW
EXECUTE PROCEDURE incrementa();
/


---------------------- PARTE C ----------------------------------
--/
-- PELICULA
CREATE OR REPLACE FUNCTION inserta_datos_pelicula()
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

--DIRIGE
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

--/
CREATE or replace FUNCTION inserta_datos_pertenece()
returns VOID AS $$
DECLARE
        s film%rowtype;
        r record;              -- Variables auxiliares para iterar
        t record;
        j record;
        pai integer;
        paises integer[];
BEGIN         
        FOR s IN (SELECT * FROM film)
        LOOP    -- Por cada pelicula con sus id_country's almacenamos sus paises y los procesamos
                
                paises = ARRAY[s.id_country1,s.id_country2,s.id_country3,s.id_country4,s.id_country5,s.id_country6,s.id_country7,s.id_country8];                
                FOREACH pai  IN ARRAY paises  -- Foreach es a partir de postgresql 9.1
                LOOP
                        if(pai != 0)THEN -- Si tal pais existe lo agregamos
                                if((select id_country from pais where pai = id_country) is not null and (select id_country from pertenece where id_country = pai and id_film = s.id_film ) is null)THEN    -- Se inserta unicamente si ya existia el country
                                        INSERT INTO pertenece
                                        VALUES ( s.id_film,pai);
                                END IF;         
                        END IF;        
                END LOOP;
        END LOOP; 
        RAISE NOTICE 'Pertenece insertadas.';               
END 
$$ LANGUAGE plpgsql; 
/


        -- Actor y actua
--/
CREATE or replace FUNCTION inserta_datos_actores()
returns VOID AS $$
DECLARE
        s film%rowtype;
        casting text[];
        act text;
        id_ult integer;
        id integer;
BEGIN         
        id_ult = (SELECT max(id_actor) from ACTOR) + 1; 
        if(id_ult is null)then
                id_ult = 0;
        end if;
        FOR s IN (SELECT * from film)  -- Por cada pelicula con su cast
        LOOP
                casting = regexp_split_to_array(s.cast_ , ','); 
                FOREACH act in ARRAY casting
                LOOP
                        if(act != '' and length(act) > 0)then
                                -- ACTOR
                                id = (SELECT id_actor FROM actor WHERE lower(trim(nombre)) = lower(trim(act))); 
                                if(id is null) then
                                       INSERT INTO ACTOR
                                        VALUES(id_ult, lower(trim(act)), 0);             -- Inserto como nuevo actor si no existia
                                        id = id_ult;
                                        id_ult = id_ult + 1;                                       
                                end if;
                                 
                                -- ACTUA
                                if((select id_film from actua where id_film = s.id_film and id_actor = id) is null)then
                                        INSERT INTO ACTUA
                                        VALUES(id, s.id_film);
                                end if;
                       end if;
                END LOOP;
                casting = ARRAY['']; 
        END LOOP; 
  
        RAISE NOTICE 'Actores y actua insertadas.';               
END 
$$ LANGUAGE plpgsql; 
/

--/ 
drop function if exists inserta_datos();
/

--/
CREATE OR REPLACE FUNCTION insertar_datos()
RETURNS trigger AS $$
BEGIN 
        PERFORM inserta_datos_pelicula(),inserta_datos_dirige(),inserta_datos_pertenece(),inserta_datos_actores();
END;
$$ LANGUAGE plpgsql; 
/
--/
DROP trigger IF EXISTS normalizar_tablas ON film;
--/
CREATE TRIGGER normalizar_tablas  
AFTER INSERT OR UPDATE ON film
FOR EACH ROW
EXECUTE PROCEDURE insertar_datos();
/


