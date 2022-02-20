create Database travel_on_the_go;
use travel_on_the_go;


create TABLE PASSENGER (Passenger_name varchar (50), 
Category varchar (25), 
Gender varchar (25),
Boarding_City varchar (50),
Destination_City varchar (50),
Distance int,
Bus_Type varchar (25),
FOREIGN KEY (Bus_Type, Distance) REFERENCES PRICE (Bus_Type, Distance));

create TABLE PRICE (Bus_Type varchar (25),
Distance int,
Price int,
PRIMARY KEY (Bus_Type, Distance));

-- 2) Insert the following data in the tables

insert into `PRICE` values ("Sleeper", '350' , '770');
insert into `PRICE` values ("Sleeper", '500' , '1100');
insert into `PRICE` values ("Sleeper", '600' , '1320');
insert into `PRICE` values ("Sleeper", '700' , '1540');
insert into `PRICE` values ("Sleeper", '1000' , '2200');
insert into `PRICE` values ("Sleeper", '1200' , '2640');
insert into `PRICE` values ("Sleeper", '1500' , '2700');
insert into `PRICE` values ("Sitting", '500' , '620');
insert into `PRICE` values ("Sitting", '600' , '744');
insert into `PRICE` values ("Sitting", '700' , '868');
insert into `PRICE` values ("Sitting", '1000' , '1240');
insert into `PRICE` values ("Sitting", '1200' , '1488');
insert into `PRICE` values ("Sitting", '1500' , '1860');

insert into `PASSENGER` values ("Sejal", "AC", "F", "Bengaluru", "Chennai", '350', "Sleeper");
insert into `PASSENGER` values ("Anmol", "Non-AC", "M", "Mumbai", "Hyderabad", '700', "Sitting");
insert into `PASSENGER` values ("Pallavi", "AC", "F", "Panaji", "Bengaluru", '600', "Sleeper");
insert into `PASSENGER` values ("Khusboo", "AC", "F", "Chennai", "Mumbai", '1500', "Sleeper");
insert into `PASSENGER` values ("Udit", "Non-AC", "M", "Trivandrum", "Panaji", '1000', "Sleeper");
insert into `PASSENGER` values ("Ankur", "AC", "M", "Nagpur", "Hyderabad", '500', "Sitting");
insert into `PASSENGER` values ("Hemant", "Non-AC", "M", "Panaji", "Mumbai", '700', "Sleeper");
insert into `PASSENGER` values ("Manish", "Non-AC", "M", "Hyderabad", "Bengaluru", '500', "Sitting");
insert into `PASSENGER` values ("Piyush", "AC", "M", "Pune", "Nagpur", '700', "Sitting");


-- 3) How many females and how many male passengers travelled for a minimum distance of 600 KM s?

select Gender, count(Gender) from `PASSENGER` 
where Distance > 600
Group by Gender;

-- 4) Find the minimum ticket price for Sleeper Bus.

select min(price) as "Min_Price_for_Sleeper" from `PRICE` where Bus_Type = "Sleeper";

-- 5) Select passenger names whose names start with character 'S'

select Passenger_name from `PASSENGER` where Passenger_name like "S%";


-- 6) Calculate price charged for each passenger displaying Passenger name, Boarding City,
-- Destination City, Bus_Type, Price in the output

select `PASSENGER`.Passenger_name, `PASSENGER`.Boarding_City, `PASSENGER`.Destination_City, `PASSENGER`.Bus_Type, `PRICE`.Price
from `PASSENGER`, `PRICE`
where (`PASSENGER`.BUS_Type, `PASSENGER`.Distance) = (`PRICE`.Bus_Type, `PRICE`.Distance)
order by `PASSENGER`.Passenger_name;


-- 7) What are the passenger name/s and his/her ticket price who travelled in the Sitting bus
-- for a distance of 1000 KM s

select `PASSENGER`.Passenger_name, `PRICE`.Price
from `PASSENGER`, `PRICE`
where ((`PASSENGER`.BUS_Type, `PASSENGER`.Distance) = (`PRICE`.Bus_Type, `PRICE`.Distance)) 
AND `PASSENGER`.Distance = '1000' AND `PASSENGER`.Bus_Type = "Sitting";

-- 8) What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji?

select `PRICE`.Bus_Type, `PRICE`.Price as "Bus_Charge" from `PRICE`
where `PRICE`.Distance = 
(select `PASSENGER`.Distance
from `PASSENGER`
where (
(`PASSENGER`.Boarding_City = "Panaji" AND `PASSENGER`.Destination_City = "Bengaluru") OR 
(`PASSENGER`.Boarding_City = "Bengaluru" AND `PASSENGER`.Destination_City = "Panaji")
)) ;

-- 9) List the distances from the "Passenger" table which are unique (non-repeated distances) in descending order.

select distinct (`PASSENGER`.Distance) from `PASSENGER` order by `PASSENGER`.Distance desc;

-- 10) Display the passenger name and percentage of distance travelled by that passenger
-- from the total distance travelled by all passengers without using user variables

select `PASSENGER`.Passenger_name, `PASSENGER`.Distance as "Distance travelled", 
round(`PASSENGER`.Distance * 100/(select sum(`PASSENGER`.Distance) from `PASSENGER`),2)  as "% of Total Distance travelled by all" 
from `PASSENGER`
order by `PASSENGER`.Passenger_name;


-- 11) Display the distance, price in three categories in table Price
-- a) Expensive if the cost is more than 1000
-- b) Average Cost if the cost is less than 1000 and greater than 500
-- c) Cheap otherwise

DELIMITER &&
CREATE PROCEDURE proc()
BEGIN
select `PRICE`.Bus_Type, `PRICE`.Distance, `PRICE`.Price, 
case
	when `PRICE`.Price > 1000 then 'Expensive'
    when `PRICE`.Price > 500 AND `PRICE`.Price < 1000 then 'Average Cost'
    ELSE 'Cheap'
END AS Price_Category from `PRICE`;
END &&
DELIMITER ; 

call proc();

-- -------------------

