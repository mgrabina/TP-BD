\copy pais FROM 'bafici13-paises.csv' csv header delimiter ',' NULL 'NULL';
\copy director FROM 'bafici13-directores.csv' csv header delimiter ';' NULL 'NULL';
\copy film FROM 'bafici13-filmsPRUEBA.csv' csv header delimiter ',' NULL 'NULL';
\copy film FROM 'bafici13-filmsTEST.csv' csv header delimiter ',' NULL 'NULL' encoding 'LATIN1';
--/
DO language plpgsql $$
BEGIN
  PERFORM insertar_datos();
  RAISE NOTICE 'Todas las tablas actualizadas!';
END;
$$
