CREATE DATABASE test;
USE test;
CREATE TABLE stocks(TradeDate CHAR(10),
										SPY double,
                                        GLD double,
                                        AMZN double,
                                        GOOG double,
                                        KPTI double,
                                        GILD double,
										MPC double);
SELECT * FROM stocks	;	

UPDATE stocks SET TradeDate =  str_to_date(TradeDate,  "%m%d%Y");


CREATE DATABASE employee;
USE employee;

CREATE TABLE  employee_table (employee_number INT NOT NULL AUTO_INCREMENT,
														employee_firstname VARCHAR(30) NOT NULL,
                                                        employee_lastname VARCHAR(30) NOT NULL,
                                                        birth_date DATE,
                                                        age INT,
                                                        PRIMARY KEY(employee_number));
 
 INSERT INTO employee_table
 VALUES(1,'Gemar', 'Usi', '2000-01-01', 24);

 INSERT INTO employee_table
 VALUES(2,'Michelle','Usi', '1998-02-21', 23);
 
 
INSERT INTO employee_table
VALUES(3,'Basi','Lea','2021-08-30',1),(4,'Lea','Basi','2021-09-30',1),(5,'Basil','eeea','2021-10-30',1);

DESC employee_table;		

SELECT * FROM employee_table;	

UPDATE employee_table
SET employee_lastname = 'Recustodio'
WHERE employee_firstname = 'Michelle';

UPDATE employee_table
SET employee_lastname = 'Usi'
WHERE employee_firstname = 'Basi';



