
-- Create Employee table

CREATE TABLE IF NOT EXISTS "Employee"."Employee"
(
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    authentication_key character varying(100),
    CONSTRAINT "Employee_pkey" PRIMARY KEY (id)
);

-- Inserting data into table

Insert into "Employee"."Employee"(id,name,authentication_key) Values
(1,'A',null),
(2,'B',null),
(3,'C',null),
(4,'D',null),
(5,'E',null),
(6,'F',null),
(7,'G',null),
(8,'H',null),
(9,'I',null),
(10,'J',null),
(11,'K',null),
(12,'L',null),
(13,'M',null),
(14,'N',null),
(15,'O',null),
(16,'P',null),
(17,'Q',null),
(18,'R',null),
(19,'S',null),
(20,'T',null),
(21,'U',null),
(22,'V',null),
(23,'W',null),
(24,'X',null),
(25,'Y',null),
(26,'Z',null);
  
  -- Temp table creation
  CREATE TEMP TABLE emp_auth_to_be_updated AS
  	SELECT ROW_NUMBER() OVER(ORDER BY id) row_id, id
  	FROM "Employee"."Employee"
  	WHERE authentication_key is null ;
    
-- Procedure
CREATE OR REPLACE PROCEDURE "Employee".update_auth_token() 
LANGUAGE plpgsql 
AS $$ 
DECLARE 
-- variable declaration 
	total_records  int;
	batch_size int:=5;
	counter int:=0;
BEGIN
	
	SELECT  INTO total_records COUNT(*) FROM "Employee"."Employee" e WHERE authentication_key  is NULL;
	
	RAISE INFO 'Total records to be updated %', total_records  ;
		
	WHILE counter <= total_records  LOOP
	
	UPDATE "Employee"."Employee" emp
	SET authentication_key = encode(gen_random_bytes(32), 'base64')
	FROM emp_auth_to_be_updated eatbu
	WHERE eatbu.id = emp.id
	AND eatbu.row_id > counter AND eatbu.row_id  <= counter+batch_size;
	
	COMMIT;
	
	counter := counter+batch_size;
	
	END LOOP ;

END;
$$;

-- Drop temp table and procedure if no longer reuired

drop procedure "Employee".update_auth_token();

drop table emp_auth_to_be_updated;


