--CREACION DE LA TABLA FILM
--Aquí se deben importar los datos del archivo:
--bafici13-films.csv
CREATE TABLE film(
id_film		TEXT primary key,
id_section1	TEXT,
id_section2	TEXT,
id_section3	TEXT,
title		TEXT,
title_es	TEXT,
title_en	TEXT,
title_orig	TEXT,
id_country1	INTEGER,
id_country2	INTEGER,
id_country3	INTEGER,
id_country4	INTEGER,
year_		INTEGER,
plot		TEXT,
synopsis_es	TEXT,
synopsis_en	TEXT,
tagline		TEXT,
duration	TEXT,
color		TEXT,
id_filmcolor	TEXT,
id_filmformat	TEXT,
director	TEXT,
id_director1	INTEGER,
id_director2	INTEGER,
id_director3	INTEGER,
id_director4	INTEGER,
id_director5	INTEGER,
id_director6	INTEGER,
id_director7	INTEGER,
id_director8	INTEGER,
id_director9	INTEGER,
id_director10	INTEGER,
id_director11	INTEGER,
id_director12	INTEGER,
id_director13	INTEGER,
id_director14	INTEGER,
id_genres_list	TEXT,
cast_		TEXT,
prodteam	TEXT,
published	INTEGER,
contact_title	TEXT,
contact_person	TEXT,
contact_address1 TEXT,
contact_address2 TEXT,
contact_zipcode	 TEXT,
contact_city	TEXT,
contact_state	TEXT,
contact_id_country	TEXT,
contact_email1	TEXT,
contact_email2	TEXT,
contact_website	TEXT,
contact_phone1	TEXT,
contact_phone2	TEXT,
contact_fax	TEXT,
contact_info	TEXT,
id_youtube	TEXT,
url_ticket	TEXT,
filepic1	TEXT,
filepic2	TEXT,
filepic3	TEXT,
filepic4	TEXT,
filepic5	TEXT,
filepic_logo	TEXT,
created_ts	TEXT,
updated_ts	TEXT,
id_event1	TEXT,
id_event2	TEXT,
id_event3	TEXT,
id_event4	TEXT,
duration_sec	TEXT,
tags		TEXT,
id_country5	INTEGER,
id_country6	INTEGER,
id_country7	INTEGER,
id_country8	INTEGER
)

COMMENT ON TABLE film is 'Aquí se deben importar los datos del archivo: bafici13-films.csv';

--Se insertan las film desde 

COPY film FROM '..\bafici13-filmsPRUEBA.csv' WITH DELIMITER ';' CSV HEADER;

--A continuación las tablas del esquema FESTIVAL

CREATE TABLE pelicula(
id_film		TEXT primary key,
title		TEXT,
title_es	TEXT,
title_en	TEXT,
title_orig	TEXT,
year_		INTEGER,
plot		TEXT,
synopsis_es	TEXT,
synopsis_en	TEXT,
tagline		TEXT,
duration	TEXT,
color		TEXT,
id_youtube	TEXT,
url_ticket	TEXT
);

CREATE TABLE pais
(
id_country	INTEGER PRIMARY KEY,
code_isonum	TEXT,
code_iso2	TEXT,
code_iso3	TEXT,
name_es		TEXT,
name_en		TEXT,
isdefault	INTEGER);

COMMENT ON TABLE pais is 'Aquí se deben importar los datos del archivo: bafici13-paises.csv';

CREATE TABLE director
(id_director	INTEGER PRIMARY KEY,
name_		TEXT,
bio_es		TEXT,
bio_en		TEXT,
published	TEXT,
filepic1	TEXT,
created_ts	TIMESTAMP,
updated_ts	TIMESTAMP);

COMMENT ON TABLE director is 'Aquí se deben importar los datos del archivo: bafici13-directores.csv';

CREATE TABLE actor
(id_actor	INTEGER PRIMARY KEY,
nombre		TEXT,
cantidad_films	INTEGER DEFAULT 0);

CREATE TABLE actua
(id_actor	INTEGER REFERENCES actor,
id_film		TEXT REFERENCES pelicula,
PRIMARY KEY(id_actor, id_film)
);

CREATE TABLE dirige
(id_director	INTEGER REFERENCES director,
id_film		TEXT REFERENCES pelicula,
PRIMARY KEY(id_director, id_film)
);

CREATE TABLE pertenece
(id_film		TEXT REFERENCES pelicula,
id_country		INTEGER REFERENCES pais,
PRIMARY KEY(id_film,id_country)
);
