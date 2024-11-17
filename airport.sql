# Airline table
CREATE TABLE `airline` (
  `Airline_id` int unsigned NOT NULL,
  `Airline_name` varchar(45) NOT NULL,
  `CEO` varchar(45) DEFAULT NULL,
  `IATA_code` varchar(3) NOT NULL,
  PRIMARY KEY (`Airline_id`),
  UNIQUE KEY `Airline_id_UNIQUE` (`Airline_id`),
  UNIQUE KEY `Airline_name_UNIQUE` (`Airline_name`),
  UNIQUE KEY `IATA_code_UNIQUE` (`IATA_code`)
);

# Airport table
CREATE TABLE `airport` (
  `Airport_id` int unsigned NOT NULL,
  `Airport_Name` varchar(45) NOT NULL,
  `City` varchar(45) NOT NULL,
  `Country` varchar(45) NOT NULL,
  `IATA_code` varchar(3) NOT NULL,
  PRIMARY KEY (`Airport_id`),
  UNIQUE KEY `Airport_id_UNIQUE` (`Airport_id`),
  UNIQUE KEY `IATA_code_UNIQUE` (`IATA_code`)
);

#Airport- airline
CREATE TABLE `airport-airline` (
  `Airport_id` int unsigned NOT NULL,
  `Airline_id` int unsigned NOT NULL,
  PRIMARY KEY (`Airport_id`,`Airline_id`),
  KEY `fk_airline_id_idx` (`Airline_id`),
  CONSTRAINT `fk_airline_id` FOREIGN KEY (`Airline_id`) REFERENCES `airline` (`Airline_id`) ON UPDATE RESTRICT,
  CONSTRAINT `fk_airport_id` FOREIGN KEY (`Airport_id`) REFERENCES `airport` (`Airport_id`)
);

#baggage
CREATE TABLE `baggage` (
  `P_id` int unsigned NOT NULL,
  `Baggage_No` int unsigned NOT NULL,
  `Baggage_weight` decimal(5,2) unsigned NOT NULL,
  `Status` enum('Checked_in','Lost','Delivered') NOT NULL,
  PRIMARY KEY (`P_id`,`Baggage_No`),
  CONSTRAINT `fk_p_id` FOREIGN KEY (`P_id`) REFERENCES `passenger` (`Passenger_id`) ON UPDATE RESTRICT
);

#employee
CREATE TABLE `employee` (
  `Employee_id` int unsigned NOT NULL,
  `F_Name` varchar(45) NOT NULL,
  `L_Name` varchar(45) DEFAULT NULL,
  `Salary` int unsigned NOT NULL,
  `G_No` int unsigned DEFAULT NULL,
  `R_No` int unsigned DEFAULT NULL,
  PRIMARY KEY (`Employee_id`),
  UNIQUE KEY `Employee_id_UNIQUE` (`Employee_id`),
  KEY `fk_g_no_idx` (`G_No`),
  KEY `fk_r_no_idx` (`R_No`),
  CONSTRAINT `fk_g_no` FOREIGN KEY (`G_No`) REFERENCES `gate` (`Gate_No`) ON UPDATE RESTRICT,
  CONSTRAINT `fk_r_no` FOREIGN KEY (`R_No`) REFERENCES `runway` (`Runway_No`) ON UPDATE RESTRICT,
  CONSTRAINT `employee_chk_1` CHECK ((((`G_No` is not null) and (`R_No` is null)) or ((`G_No` is null) and (`R_No` is not null))))
);

#Employee - contacts
CREATE TABLE `employee-contacts` (
  `Employee_id` int unsigned NOT NULL,
  `Contact` int NOT NULL,
  PRIMARY KEY (`Employee_id`),
  CONSTRAINT `fk_employee_id` FOREIGN KEY (`Employee_id`) REFERENCES `employee` (`Employee_id`) ON UPDATE RESTRICT
);

#Flight
CREATE TABLE `flight` (
  `Flight_instance_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Flight_id` int unsigned NOT NULL,
  `A/D` enum('A','D') NOT NULL,
  `Arrival_time` datetime NOT NULL,
  `Departure_time` datetime NOT NULL,
  `Status` varchar(9) NOT NULL,
  `Wait_Duration` time NOT NULL,
  `AP_ID` int unsigned NOT NULL,
  `AL_ID` int unsigned NOT NULL,
  `Runway_N` int unsigned NOT NULL,
  `Gate_N` int unsigned NOT NULL,
  PRIMARY KEY (`Flight_instance_id`),
  UNIQUE KEY `Flight_instance_id_UNIQUE` (`Flight_instance_id`),
  UNIQUE KEY `Flight_id_UNIQUE` (`Flight_id`),
  KEY `fk_ap_id_idx` (`AP_ID`),
  KEY `fk_al_id_idx` (`AL_ID`),
  KEY `fk_runway_n_idx` (`Runway_N`),
  KEY `fk_gate_n_idx` (`Gate_N`),
  CONSTRAINT `fk_al_id` FOREIGN KEY (`AL_ID`) REFERENCES `airline` (`Airline_id`) ON UPDATE RESTRICT,
  CONSTRAINT `fk_ap_id` FOREIGN KEY (`AP_ID`) REFERENCES `airport` (`Airport_id`) ON UPDATE RESTRICT,
  CONSTRAINT `fk_gate_n` FOREIGN KEY (`Gate_N`) REFERENCES `gate` (`Gate_id`) ON UPDATE RESTRICT,
  CONSTRAINT `fk_runway_n` FOREIGN KEY (`Runway_N`) REFERENCES `runway` (`Runway_id`) ON UPDATE RESTRICT
);

#Gate
CREATE TABLE `gate` (
  `Gate_id` int unsigned NOT NULL,
  `Gate_No` int unsigned NOT NULL,
  `Capacity` int unsigned NOT NULL,
  PRIMARY KEY (`Gate_id`),
  UNIQUE KEY `Gate_id_UNIQUE` (`Gate_id`),
  UNIQUE KEY `Gate_No_UNIQUE` (`Gate_No`)
)

#Passenger
CREATE TABLE `passenger` (
  `Passenger_id` int unsigned NOT NULL,
  `F_Name` varchar(45) NOT NULL,
  `L_Name` varchar(45) NOT NULL,
  `Gender` enum('Male','Female','Other') NOT NULL,
  `Nationality` varchar(45) NOT NULL,
  `Passport_No` int NOT NULL,
  PRIMARY KEY (`Passenger_id`),
  UNIQUE KEY `Passenger_id_UNIQUE` (`Passenger_id`),
  UNIQUE KEY `Passport_No_UNIQUE` (`Passport_No`)
);

#Passenger - contacts
CREATE TABLE `passenger-contacts` (
  `Passenger_id` int unsigned NOT NULL,
  `Contact` int NOT NULL,
  PRIMARY KEY (`Passenger_id`,`Contact`),
  CONSTRAINT `fk_pass_id` FOREIGN KEY (`Passenger_id`) REFERENCES `passenger` (`Passenger_id`) ON UPDATE RESTRICT
);

#runway
CREATE TABLE `runway` (
  `Runway_id` int unsigned NOT NULL,
  `Runway_No` int unsigned NOT NULL,
  PRIMARY KEY (`Runway_id`),
  UNIQUE KEY `Runway_id_UNIQUE` (`Runway_id`),
  UNIQUE KEY `Runway_No_UNIQUE` (`Runway_No`)
); 

#tickets
CREATE TABLE `tickets` (
  `Booking_id` int unsigned NOT NULL AUTO_INCREMENT,
  `Seat_No` int unsigned NOT NULL,
  `Booking_Date` datetime NOT NULL,
  `Booking_Status` enum('Confirmed','Canceled') NOT NULL,
  `Flight_id` int unsigned NOT NULL,
  `Passenger_id` int unsigned NOT NULL,
  PRIMARY KEY (`Booking_id`),
  UNIQUE KEY `Booking_id_UNIQUE` (`Booking_id`),
  KEY `fk_flight_id_idx` (`Flight_id`),
  KEY `fk_passenger_id_idx` (`Passenger_id`),
  CONSTRAINT `fk_flight_id` FOREIGN KEY (`Flight_id`) REFERENCES `flight` (`Flight_id`) ON UPDATE RESTRICT,
  CONSTRAINT `fk_passenger_id` FOREIGN KEY (`Passenger_id`) REFERENCES `passenger` (`Passenger_id`) ON UPDATE RESTRICT
);

ALTER TABLE `airport`.`flight` 
ADD COLUMN `AL_ID` INT UNSIGNED NOT NULL AFTER `AP_ID`,
ADD COLUMN `Location` VARCHAR(45) NOT NULL AFTER `Gate_N`,
CHANGE COLUMN `A/D` `Direction` ENUM('A', 'D') NOT NULL;


ALTER TABLE `airport`.`flight` 
ADD INDEX `fk_al_id_idx` (`AL_ID` ASC) VISIBLE;
;

ALTER TABLE `airport`.`flight` 
ADD CONSTRAINT `fk_al_id`
  FOREIGN KEY (`AL_ID`)
  REFERENCES `airport`.`airline` (`Airline_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;